(defpackage #:utils
  (:use #:cl))

(in-package #:utils)

(defun main (argv)
  (let ((name (pathname-name (first argv))))
    (format *error-output*
            "Unknown binary name ~S, try using window_ids or hook_loop~%"
            name)
    (sb-ext:exit :code 1)))
