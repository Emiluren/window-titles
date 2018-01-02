#!/bin/sh

sbcl --no-userinit --no-sysinit --non-interactive \
     --load ~/quicklisp/setup.lisp \
     --eval '(ql:quickload "split-sequence")' \
     --eval '(ql:write-asdf-manifest-file "quicklisp-manifest.txt")'

buildapp \
    --require uiop \
    --manifest-file quicklisp-manifest.txt \
    --load-system split-sequence \
    --load utils.lisp --dispatched-entry /utils:main \
    --load window_ids.lisp --dispatched-entry window_ids/window-ids:main \
    --load wait-for-hc.lisp --dispatched-entry hook_loop/wait-for-hc:main \
    --output window_ids
