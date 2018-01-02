(defpackage #:window-ids
  (:use #:cl #:split-sequence))

(in-package #:window-ids)

(defparameter *dump-command*
  "herbstclient dump \"\" @")

(defparameter *active-window-id-command*
  "herbstclient attr clients.focus.winid")

(defun get-ids (input)
  (let ((words (split-sequence #\Space input)))
    (subseq words 2)))

(defun run-command (cmd)
  (uiop:run-program cmd :output '(:string :stripped t)))

(defun get-title (id)
  (format nil "herbstclient attr clients.~A.title" id))

(defun inverse-if-active (str id active-id)
  (if (equal id active-id)
      (format nil "%{R}~A%{R-}" str)
      str))

(defun format-titles (window-ids)
  (let ((active-id (run-command *active-window-id-command*)))
    (format nil "~{~A~^ | ~}"
            (loop for id in window-ids
               collect (inverse-if-active
                        (run-command (get-title id))
                        id active-id)))))

(defun main (argv)
  (declare (ignore argv))
  (let ((input-string (string-trim '(#\( #\) )
                                   (run-command *dump-command*))))
    (write-line (format-titles (get-ids input-string)))))
