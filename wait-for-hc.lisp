(defpackage #:wait-for-hc
  (:use #:cl))

(in-package #:wait-for-hc)

(defun main (argv)
  (declare (ignore argv))
  (let ((process (sb-ext:run-program "/usr/bin/herbstclient"
                                     (list "--idle")
                                     :output :stream
                                     :wait nil)))
    (with-open-stream (stream (sb-ext:process-output process))
      (unwind-protect
           (loop for line = (read-line stream nil)
              while line
              do (sb-ext:run-program "/home/em/bin/polybar_hlwm_hook"
                                     nil))
        (sb-ext:process-close process)))))
