;; This Source Code Form is subject to the terms of the Mozilla Public
;; License, v. 2.0. If a copy of the MPL was not distributed with this
;; file, You can obtain one at http://mozilla.org/MPL/2.0/

(use-package gruvbox-theme
  :ensure t
  :config (load-theme 'gruvbox t))

(use-package git-gutter-fringe
  :if window-system
  :ensure t
  :diminish git-gutter-mode
  :config (global-git-gutter-mode))

(use-package paren
  :ensure t
  :init (show-paren-mode)
  :config (setq show-paren-when-point-inside-paren nil
                show-paren-when-point-in-periphery t))

(use-package hl-line
  :ensure t
  :init (global-hl-line-mode))

(use-package linum-mode
  :init (add-hook 'prog-mode-hook 'linum-mode))
(setq linum-format " %d ")

;; Prefer Source Code Pro Light
(when (featurep 'ns-win)
  (set-face-attribute 'default nil :family "Source Code Pro" :height 170 :weight 'light))

;; Remove all bold and underline faces
(mapc (lambda (face)
        (set-face-attribute face nil :weight 'light :underline nil))
      (face-list))
