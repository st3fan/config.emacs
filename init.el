;;

(if (< emacs-major-version 25)
  (error "requires Emacs 25 or later."))

;;

(setq gc-cons-threshold (* 128 1024 1024))

;;

(setq custom-file "~/.emacs.custom.el")
(when (file-exists-p custom-file)
  (load custom-file))

;; ==========================================================================
;; Bootstrap MELPA and use-package
;; ==========================================================================

(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; ==========================================================================
;; The following paths do not exist everywhere but they are common
;; enough to add without checks. Both go in front of PATH so that we
;; can override commands like ctags.
;; ==========================================================================

(push "/usr/local/bin" exec-path)
(push "~/go/bin" exec-path)

(setenv "PATH" (concat "/usr/local/bin" ":" (getenv "PATH")))
(setenv "PATH" (concat "~/go/bin" ":" (getenv "PATH")))

;; ==========================================================================
;; Configure packages
;; ==========================================================================

(use-package exec-path-from-shell
  :if window-system
  :ensure t
  :config (exec-path-from-shell-initialize))

(use-package whitespace
  :ensure t
  :diminish whitespace-mode
  :config (setq whitespace-line-column 120
                whitespace-style '(face trailing lines-tail))
            (add-hook 'prog-mode-hook 'whitespace-mode))

(use-package whitespace-cleanup-mode
  :ensure t
  :diminish whitespace-cleanup-mode
  :config (global-whitespace-cleanup-mode)
            (add-hook 'cc-mode-hook 'whitespace-cleanup-mode))

(use-package magit
  :ensure t
  :bind (("C-x g" . magit-status)))

;;(use-package magithub
;;  :after magit
;;  :config (magithub-feature-autoinject t))

(use-package expand-region
  :ensure t
  :init (global-set-key (kbd "M-e") 'er/expand-region))

;; (use-package auto-complete
;;   :config
;;   (global-auto-complete-mode t))
;; (use-package auto-complete-config
;;   :config
;;   (ac-config-default))

;; (use-package go-autocomplete
;;   :ensure t
;;   :config (when (memq window-system '(mac ns))
;;             (exec-path-from-shell-initialize)
;;             (exec-path-from-shell-copy-env "GOPATH")))

(use-package rainbow-delimiters
  :ensure t
  :init (add-hook 'prog-mode-hook 'rainbow-delimiters-mode))

(use-package web-mode
  :ensure t
  :mode ("\\.html$" . web-mode))

;; (use-package smex
;;   :ensure t
;;   :bind (("M-x" . smex))
;;   :config (smex-initialize))

(use-package projectile
  :ensure t)

;; ==========================================================================
;; Random customizations
;; ==========================================================================

(setq user-full-name "Stefan Arentz")
(setq user-mail-address "stefan@arentz.ca")

(transient-mark-mode 1)                 ; highlight text selection
(delete-selection-mode 1)               ; delete seleted text when typing

(column-number-mode 1)

(setq make-backup-files nil)            ; stop creating those backup~ files
(setq auto-save-default nil)            ; stop creating those #autosave# files

(recentf-mode 1)                        ; keep a list of recently opened files

(setq inhibit-splash-screen t)          ;

(unless (getenv "TMUX")                 ; don't display the time if we are
  (setq display-time-24hr-format 1)     ; running in tmux because it
  (display-time-mode 1))                ; will already display a clock

(setq-default indent-tabs-mode nil)     ;

(when (not (display-graphic-p))         ; disable the menu when running in the terminal
  (menu-bar-mode -1))

(when (display-graphic-p)
  (tool-bar-mode -1))                   ; kill the toolbar

(when (display-graphic-p)
  (scroll-bar-mode -1))                 ; kill the scrollbar

;; (when (display-graphic-p)
;;   (set-fringe-style 0))                 ; no fringe

(blink-cursor-mode 0)                   ; no blinking cursor please

(setq ring-bell-function 'ignore)       ; stop beeping

(desktop-save-mode 0)                   ; save/restore opened files
(recentf-mode 1)                        ; keep a list of recently opened files

;; ==========================================================================
;; Load all the individual init files
;; ==========================================================================

(load "~/.emacs.d/init-appearance.el")
(load "~/.emacs.d/init-projectile.el")
(load "~/.emacs.d/init-clojure.el")
(load "~/.emacs.d/init-company.el")
(load "~/.emacs.d/init-go.el")
(load "~/.emacs.d/init-modes.el")
(load "~/.emacs.d/init-sql.el")
(load "~/.emacs.d/init-rust.el")

;; ==========================================================================
;; Finally load a 'local' config, which is not stored in version
;; control.  This file can contain things like API keys for example.
;; ==========================================================================

(when (file-exists-p "~/.emacs.local.el")
  (load "~/.emacs.local.el"))
