#!/usr/bin/sbcl --script
(load "~/.sbclrc")
(ql:quickload :split-sequence)

(defpackage #:window-ids
  (:use #:cl #:split-sequence))

(in-package #:window-ids)

(defparameter *dump-command*
  "herbstclient dump \"\" @")

(defparameter *active-window-id-command*
  "herbstclient attr clients.focus.winid")

(defparameter *max-title-length* 60)

(defun get-ids (input)
  (let ((words (split-sequence #\Space input)))
    (subseq words 2)))

(defun run-command (cmd &optional (ignore-error nil))
  (uiop:run-program cmd
                    :output '(:string :stripped t)
                    :ignore-error-status ignore-error))

(defun get-title (id)
  (format nil "herbstclient attr clients.~A.title" id))

(defun inverse-if-active (str id active-id)
  (if (equal id active-id)
      (concatenate 'string "%{R}" str "%{R-}")
      str))

(defun trunkate (str)
  (if (> (length str) *max-title-length*)
      (concatenate 'string (subseq str 0 *max-title-length*) "...")
      str))

(defun format-titles (window-ids)
  (let ((active-id (run-command *active-window-id-command* t)))
    (format nil "~{~A~^ | ~}"
            (loop for id in window-ids
               collect (inverse-if-active
                        (trunkate (run-command (get-title id)))
                        id active-id)))))

(defun get-titles ()
  (let ((input-string (string-trim '(#\( #\) )
                                   (run-command *dump-command*))))
    (format-titles (get-ids input-string))))

(let ((process (sb-ext:run-program "/usr/bin/herbstclient"
                                   (list "--idle")
                                   :output :stream
                                   :wait nil)))
  (with-open-stream (stream (sb-ext:process-output process))
    (unwind-protect
         (loop for line = (read-line stream nil)
            while line
            do (write-line (get-titles)))
      (sb-ext:process-close process))))
