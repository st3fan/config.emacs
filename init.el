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
  :commands magit-get-top-dir
  :bind ("C-c g" . magit-status))

(use-package magithub
  :after magit
  :config (magithub-feature-autoinject t))

(use-package expand-region
  :init (global-set-key (kbd "M-e") 'er/expand-region))

;; TODO This should inherit from the shell instead
;; (setenv "GOPATH" "/Users/stefan/go")
;; (add-to-list 'exec-path "/Users/stefan/go/bin")

;;
;; Install the following tools:
;;
;;   go get -u -v golang.org/x/tools/cmd/goimports
;;   go get -u -v github.com/nsf/gocode
;;

(use-package go-mode
  :ensure t
  :init
    (add-hook 'go-mode-hook
	      (lambda ()
		(setq gofmt-command "goimports")
		(add-hook 'before-save-hook 'gofmt-before-save)
		(setq truncate-lines t)
		(setq indent-tabs-mode t)
		(setq tab-width 4))))

(use-package go-eldoc
  :ensure t
  :init (add-hook 'go-mode-hook 'go-eldoc-setup))

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

(use-package company
  :ensure t
  :diminish company-mode
  :init (add-hook 'after-init-hook 'global-company-mode))

(use-package company-go
  :ensure t
  :init (add-hook 'go-mode-hook
                  (lambda ()
                    (set (make-local-variable 'company-backends) '(company-go))
                    (company-mode))))

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

(use-package cc-mode
  :config (setq c-default-style "ellemtel"
                c-basic-offset 3))

(use-package linum-mode
  :init (add-hook 'prog-mode-hook 'linum-mode))
(setq linum-format " %d ")

(use-package projectile
  :ensure t)

(use-package inf-clojure
  :ensure t
  :commands inf-clojure-minor-mode)

(use-package clojure-mode
  :ensure t
  :init
  ;;(add-hook 'clojure-mode-hook 'paredit-mode)
  (add-hook 'clojure-mode-hook #'rainbow-delimiters-mode)
  (add-hook 'clojure-mode-hook 'projectile-mode)
  ;;(add-hook 'clojure-mode-hook 'flycheck-mode)
  (add-hook 'clojure-mode-hook 'inf-clojure-minor-mode))

(use-package cider-mode
  :config (setq cider-repl-display-help-banner nil)
  :commands cider-jack-in)

(use-package fish-mode
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
;; Prefer Source Code Pro Light and remove all bold and underline faces
;; ==========================================================================

(when (featurep 'ns-win)
  (set-face-attribute 'default nil :family "Source Code Pro" :height 170 :weight 'light))

(mapc (lambda (face)
        (set-face-attribute face nil :weight 'light :underline nil))
      (face-list))

;; ==========================================================================
;; Some defaults for SQL Mode
;; ==========================================================================

(setq sql-postgres-login-params
      '((user :default (user-login-name))
        (database :default (user-login-name))
        (server :default "localhost")
        (port :default 5432)))

(add-hook 'sql-interactive-mode-hook
          (lambda ()
            (toggle-truncate-lines t)))

;; ==========================================================================
;; Finally load a 'local' config, which is not stored in version
;; control.  This file can contain things like API keys for example.
;; ==========================================================================

(when (file-exists-p "~/.emacs.local.el")
  (load "~/.emacs.local.el"))
