(if (< emacs-major-version 28)
    (error "requires Emacs 28 or later."))

(setq gc-cons-percentage 0.5
      gc-cons-threshold (* 128 1024 1024))

;; Package

(require 'package)
(when (not (assoc "melpa" package-archives))
  (setq package-archives (append '(("melpa" . "https://melpa.org/packages/")) package-archives)))
(package-initialize)

(when (not package-archive-contents) (package-refresh-contents))

(when (not (package-installed-p 'use-package))
  (package-install 'use-package))

;;

(setq user-full-name "Stefan Arentz")
(setq user-mail-address "stefan@arentz.ca")

(transient-mark-mode 1)                 ; highlight text selection
(delete-selection-mode 1)               ; delete seleted text when typing

(column-number-mode 1)

(setq make-backup-files nil)            ; stop creating those backup~ files
(setq auto-save-default nil)            ; stop creating those #autosave# files

(setq inhibit-splash-screen t)          ;

(unless (getenv "TMUX")                 ; don't display the time if we are
  (setq display-time-24hr-format 1)     ; running in tmux because it
  (display-time-mode 1))                ; will already display a clock

(setq-default indent-tabs-mode nil)     ;

(when (not (display-graphic-p))         ; disable the menu when running in the terminal
  (menu-bar-mode -1))

(setq ring-bell-function 'ignore)       ; stop beeping

(desktop-save-mode 0)                   ; save/restore opened files
(recentf-mode 1)                        ; keep a list of recently opened files

(save-place-mode 1)                     ; remember position in files

(show-paren-mode 1)
(setq show-paren-delay 0)
(setq show-paren-context-when-offscreen t)

(global-hl-line-mode 1)

(setq eldoc-echo-area-use-multiline-p 1)

(setq custom-file "~/.emacs.custom.el")

;;

(defun st3fan/hasenv (name)
  (not (eq (getenv name) nil)))

(defun st3fan/in-tmux ()
    (st3fan/hasenv "TMUX"))

;;

(add-to-list 'auto-mode-alist '("COMMIT_EDITMSG" . git-commit-mode))

(add-hook
 'Info-mode-hook
 #'(lambda ()
     (add-to-list 'Info-directory-list (expand-file-name "~/.local/share/info"))))

;;

(use-package dashboard
  :config
  (setq dashboard-startup-banner 'logo
        dashboard-set-heading-icons t
        dashboard-set-file-icons t
        show-week-agenda-p nil)
  (dashboard-setup-startup-hook))

(use-package vertico
  :ensure t
  :init (vertico-mode))

(use-package savehist
  :ensure t
  :init (savehist-mode))

(use-package marginalia
  :after vertico
  :init (marginalia-mode))

;; (use-package consult
;;   :ensure t)

(use-package which-key
  :ensure t
  :config (setq which-key-idle-delay 0.5)
  :init (which-key-mode))

;; (use-package leuven-theme
;;   :ensure t
;;   :init (load-theme 'leuven :no-confirm))

(use-package catppuccin-theme
  :ensure t
  :init (progn
          (setq catppuccin-flavor 'mocha)
          (load-theme 'catppuccin :no-confirm)
          (catppuccin-reload)))

;; (use-package treesit-auto
;;   :ensure t
;;   :config
;;   (global-treesit-auto-mode))

(use-package doom-modeline
 :ensure t
 :init (doom-modeline-mode 1))

(use-package whitespace
  :ensure t
  ;;:diminish whitespace-mode
  :config (progn
            (setq whitespace-line-column 120
                  whitespace-style '(face trailing lines-tail))
            (add-hook 'prog-mode-hook 'whitespace-mode)))

(use-package rainbow-delimiters
  :ensure t
  :init (add-hook 'prog-mode-hook 'rainbow-delimiters-mode))

(use-package whitespace-cleanup-mode
  :ensure t
  :diminish whitespace-cleanup-mode
  :config (progn
            (global-whitespace-cleanup-mode)
            (add-hook 'cc-mode-hook 'whitespace-cleanup-mode)))

(use-package expand-region
  :ensure t
  :init (global-set-key (kbd "M-e") 'er/expand-region))

(use-package flymake
  :ensure t)

(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

(use-package company
  :ensure t
  :diminish company-mode
  :init (add-hook 'after-init-hook 'global-company-mode)
  :config (setq company-idle-delay 1
                company-minimum-prefix-length 1
                company-tooltip-align-annotations t))

(use-package yasnippet
  :ensure t
  :commands yas-minor-mode
  :hook (prog-mode . yas-minor-mode))

(use-package magit
  :ensure t
  :config (setq magit-define-global-key-bindings 'recommended))

(use-package hl-todo
  :ensure t
  :config (global-hl-todo-mode))

(use-package git-link
  :ensure t)

;;

(use-package go-ts-mode
  :ensure t
  :custom (go-ts-mode-indent-offset 4)
  :config (add-hook 'go-ts-mode-hook
                    (lambda ()
                      (add-hook 'before-save-hook 'gofmt-before-save)
                      ;;(setq truncate-lines t)
                      (setq indent-tabs-mode t)
                      (setq tab-width 4))))

(use-package rust-mode
  :ensure t)

(use-package cc-mode
  :ensure t
  :config (setq c-default-style "ellemtel"
                c-basic-offset 3))

(use-package json-mode
  :ensure t)

(use-package markdown-mode
  :ensure t)

(use-package yaml-mode
  :ensure t)

(use-package dockerfile-mode
  :ensure t)

(defun st3fan/eglot-format-buffer-on-save ()
  (add-hook 'before-save-hook
            (lambda ()
              (eglot-code-action-organize-imports (point-min))) -11 t)
  (add-hook 'before-save-hook
            (lambda ()
              (xeglot-format-buffer)) -10 t))

(use-package eglot
  :ensure t
  :config (setq-default eglot-workspace-configuration '((:gopls . ((usePlaceholders . t)
                                                                   (allExperiments . t)
                                                                   (staticcheck . t)
                                                                   (analyses . (
                                                                                (nilness . t)
                                                                                (fieldalignment . t)
                                                                                (shadow . t)
                                                                                (unusedparams . t)
                                                                                (unusedwrite . t)))
                                                                   (matcher . "Fuzzy"))))
                        eglot-events-buffer-size 0)
  :hook ((go-ts-mode . eglot-ensure))) ;; (eglot-managed-mode . st3fan/eglot-format-buffer-on-save)))

;;

(when (file-exists-p custom-file)
  (load custom-file))

(when (file-exists-p "~/.config/emacs/local.el")
  (load "~/.config/emacs/local.el"))
