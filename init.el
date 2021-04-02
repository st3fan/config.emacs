(if (< emacs-major-version 26)
    (error "requires Emacs 26 or later."))

(setq gc-cons-threshold (* 128 1024 1024))
(setq read-process-output-max (* 1024 1024)) ;; For LSP Servers

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

(setq custom-file "~/.emacs.custom.el")

;; ===========================================================================
;; This is a good looking light theme. Only local fix is to give
;; mode-line-inactive a better color.

(use-package spacemacs-theme
  :defer t
  :init (progn
         (load-theme 'spacemacs-light t)
         (face-spec-set
           'mode-line-inactive
           '((default
               :inherit mode-line)
             (((class color) (min-colors 88) (background light))
              :weight light
              :box (:line-width -1 :color "grey75" :style nil)
              :foreground "grey20" :background "grey90")
             (((class color) (min-colors 88) (background dark))
              :background "black" :foreground "gray70" :box nil)))))

;; ===========================================================================
;; Visualize whitespace beyond 120 columns. Should probably disable
;; this because I generally prefer lines to wrap.

(use-package whitespace
  :ensure t
  :diminish whitespace-mode
  :config (progn
            (setq whitespace-line-column 120
                  whitespace-style '(face trailing lines-tail))
            (add-hook 'prog-mode-hook 'whitespace-mode)))

;; ===========================================================================
;; A simpler mode line.

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1))

;; ===========================================================================
;; Should probably drop this because I can barely see the different colors.

(use-package rainbow-delimiters
  :ensure t
  :init (add-hook 'prog-mode-hook 'rainbow-delimiters-mode))


;; ===========================================================================
;; Auto clean up whitespace. Both trailing and empty lines.

(use-package whitespace-cleanup-mode
  :ensure t
  :diminish whitespace-cleanup-mode
  :config (progn
            (global-whitespace-cleanup-mode)
            (add-hook 'cc-mode-hook 'whitespace-cleanup-mode)))

;; ===========================================================================
;; Something I miss from IntelliJ.

(use-package expand-region
  :ensure t
  :init (global-set-key (kbd "M-e") 'er/expand-region))

;; ===========================================================================
;; Remove all bold and underline faces.

(mapc (lambda (face)
        (set-face-attribute face nil :weight 'light :underline nil))
      (face-list))

;; ===========================================================================
;; It's Magit! A Git Porcelain inside Emacs.

(use-package magit
  :ensure t
  :bind (("C-x g" . magit-status)))

;; ===========================================================================
;; I've not found a good use for this yet.

;;(use-package projectile
;;  :ensure t
;;  :config (progn
;;	    (add-to-list 'projectile-globally-ignored-directories "node_modules")
;;           (add-to-list 'projectile-globally-ignored-directories "env")
;;	    (define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
;;            (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
;;            (projectile-mode +1)))

;; ===========================================================================
;; Code in C, Code in C, Java is not the answer, Code in C.

(use-package cc-mode
  :ensure t
  :config (setq c-default-style "ellemtel"
                c-basic-offset 3))

;; ===========================================================================
;; Small modes that make editing some specific file types more pleasant.

(use-package json-mode
  :ensure t)

(use-package markdown-mode
  :ensure t)

(use-package yaml-mode
  :ensure t)

(use-package dockerfile-mode
  :ensure t)

;; ===========================================================================

(use-package lsp-mode
  :ensure t
  :config (progn
            (setq lsp-enable-snippet t
                  lsp-auto-guess-root t
                  lsp-enable-symbol-highlighting nil
                  lsp-headerline-breadcrumb-enable nil
                  lsp-prefer-flymake nil)
            (add-to-list 'lsp-file-watch-ignored "^\\/opt\\/homebrew")
            (lsp-register-custom-settings
             '(("gopls.completeUnimported" t t)
               ("gopls.staticcheck" t t))))
  :hook (go-mode . lsp-deferred)
  :commands (lsp lsp-deferred))

(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode
  :config (setq lsp-ui-sideline-enable nil
	        lsp-ui-peek-enable t
                lsp-ui-doc-enable nil
                lsp-ui-flycheck-enable nil
		lsp-ui-sideline-enable nil
                lsp-ui-imenu-enable nil
                lsp-ui-sideline-ignore-duplicate t))

;; ===========================================================================

(use-package company
  :ensure t
  :diminish company-mode
  :init (add-hook 'after-init-hook 'global-company-mode)
  :config (setq company-idle-delay 1
                company-minimum-prefix-length 1
                company-tooltip-align-annotations t))

;; ===========================================================================

(use-package yasnippet
  :ensure t
  :commands yas-minor-mode
  :hook (go-mode . yas-minor-mode))

;; ===========================================================================

(use-package go-mode
  :ensure t
  :init (add-hook 'go-mode-hook
                  (lambda ()
                    (setq truncate-lines t)
                    (setq indent-tabs-mode t)
                    (setq tab-width 4))))

 (defun lsp-go-install-save-hooks ()
   (add-hook 'before-save-hook #'lsp-format-buffer t t)
   (add-hook 'before-save-hook #'lsp-organize-imports t t))
 (add-hook 'go-mode-hook #'lsp-go-install-save-hooks)

;; ===========================================================================

(use-package clojure-mode
  :ensure t)

(use-package cider
  :ensure t)

;; ===========================================================================

(when (file-exists-p custom-file)
  (load custom-file))

;; ===========================================================================

(when (file-exists-p "~/.emacs.local.el")
  (load "~/.emacs.local.el"))
