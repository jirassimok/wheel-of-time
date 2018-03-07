;;; wheel-of-time.el --- Scrolling moves through time instead of space.

;; Copyright (C) 2017 Jacob Komissar

;; Author: Jacob Komissar <jikomissar@gmail.com>
;; Created: 2017-03-08
;; Keywords: mouse, files, undo, redo
;; Version: 0.2
;; Package-Requires: ((undo-tree "0.1"))


;; This file is not part of GNU Emacs.

;; This file is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary

;; This package was inspired by this comic: xkcd.com/1806/


;; FEATURES TO ADD:
;; Horizontal scrolling (through the undo tree)
;; Ability to add custom-set modifiers to use.
;; Allow setting speed.


;;; Changelog:

;; 2017-03-15
;; Made wheel-of-time-mode nonglobal, added wheel-of-time-global-mode.

;;; Code:

(require 'undo-tree)

(defgroup wheel-of-time nil
  "Group for wheel-of-time package."
  :group 'undo)


;; Variable for direction.
(defcustom wheel-of-time-direction 'undo-up
  "Direction wheel-of-time runs.
Valid values are the symbol ‘undo-up’ and the symbol ‘undo-down’.
The other direction will be used for redo." ; possibly add redo-up and redo-down later
  :options (list 'undo-up 'undo-down)
  :group 'wheel-of-time
  :type 'symbol)

;; Modeline indicator.
(defcustom wheel-of-time-lighter " Time-Scroll"
  "Variable displayed in mode line in ‘wheel-of-time-mode’."
  :group 'wheel-of-time
  :type 'string)

;; Keymap variable
(defvar wheel-of-time-map nil "Keymap for ‘wheel-of-time-mode’.")
(unless wheel-of-time-map
  (let ((map (make-sparse-keymap)))
    (define-key map [wheel-down] 'wheel-of-time-down)
    (define-key map [wheel-up] 'wheel-of-time-up)
    (setq wheel-of-time-map map)))


;;; Functions

(defun wheel-of-time-up ()
  "Calls either ‘undo-tree-undo’ or ‘undo-tree-redo’, depending on the value
of ‘wheel-of-time-direction’."
  (interactive)
  (cond ((eq wheel-of-time-direction 'undo-up) (undo-tree-undo))
        ((eq wheel-of-time-direction 'undo-down) (undo-tree-redo))
        (t (error "Invalid value for wheel-of-time-direction."))))

(defun wheel-of-time-down ()
  "Calls either ‘undo-tree-redo’ or ‘undo-tree-undo’, depending on the value
of ‘wheel-of-time-direction’."
  (interactive)
  (cond ((eq wheel-of-time-direction 'undo-up) (undo-tree-redo))
        ((eq wheel-of-time-direction 'undo-down) (undo-tree-undo))
        (t (error "Invalid value for wheel-of-time-direction."))))


;;; The Mode Itself

(define-minor-mode wheel-of-time-mode
  "Use the mouse wheel to scroll through time. Inspired by xkcd.com/1806.
Directions are controlled by ‘wheel-of-time-direction’.
Key bindings:
\\{wheel-of-time-map}"
  nil ; init value of mode variable
  wheel-of-time-lighter ; modeline
  wheel-of-time-map ; keymap
  :group 'wheel-of-time
  :global nil)


(define-minor-mode wheel-of-time-global-mode
  "Use the mouse wheel to scroll through time. Inspired by xkcd.com/1806.
Directions are controlled by ‘wheel-of-time-direction’.
Key bindings:
\\{wheel-of-time-map}"
  nil ; init value of mode variable
  wheel-of-time-lighter ; modeline
  wheel-of-time-map ; keymap
  :group 'wheel-of-time
  :global t)


(provide 'wheel-of-time)
;;; wheel-of-time.el ends here
