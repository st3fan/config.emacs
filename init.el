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
  :config
  (setq which-key-idle-delay 0.5)
  (which-key-mode))

;; (use-package leuven-theme
;;   :ensure t
;;   :init (load-theme 'leuven :no-confirm))

(use-package catppuccin-theme
  :ensure t
  :init (progn
          (setq catppuccin-flavor 'mocha)
          (load-theme 'catppuccin :no-confirm)
          (catppuccin-reload)))

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

(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

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
                lsp-ui-sideline-show-symbol t
                lsp-ui-sideline-show-hover t
                lsp-ui-sideline-ignore-duplicate t
                lsp-ui-sideline-show-diagnostics t
	        lsp-ui-peek-enable t
                lsp-ui-doc-enable nil
                lsp-ui-flycheck-enable t
                lsp-ui-imenu-enable nil))

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
  :hook (go-mode . yas-minor-mode))

(use-package magit
  :ensure t
  :config (setq magit-define-global-key-bindings 'recommended))

(use-package hl-todo
  :ensure t
  :config (global-hl-todo-mode))

(use-package git-link
  :ensure t)

;;

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

;; This has no Go support yet

;; (if (>= emacs-major-version 29)
;;     (use-package treesit
;;       :preface
;;       (defun mp-setup-install-grammars ()
;;         "Install Tree-sitter grammars if they are absent."
;;         (interactive)
;;         (dolist (grammar
;;                  '((go "https://github.com/tree-sitter/tree-sitter-go")
;;                    (gomod "https://github.com/camdencheek/tree-sitter-go-mod")
;;                    (json "https://github.com/tree-sitter/tree-sitter-json")
;;                    (python "https://github.com/tree-sitter/tree-sitter-python")
;;                    (yaml "https://github.com/ikatyang/tree-sitter-yaml")))
;;           (add-to-list 'treesit-language-source-alist grammar)
;;           ;; Only install `grammar' if we don't already have it
;;           ;; installed. However, if you want to *update* a grammar then
;;           ;; this obviously prevents that from happening.
;;           (unless (treesit-language-available-p (car grammar))
;;             (treesit-install-language-grammar (car grammar)))))

;;       ;; Optional, but recommended. Tree-sitter enabled major modes are
;;       ;; distinct from their ordinary counterparts.
;;       ;;
;;       ;; You can remap major modes with `major-mode-remap-alist'. Note
;;       ;; that this does *not* extend to hooks! Make sure you migrate them
;;       ;; also
;;       (dolist (mapping '((go-mode . go-ts-mode)
;;                          (go-mod-mode . go-mod-ts-mode)
;;                          (json-mode . json-ts-mode)
;;                          (python-mode . python-ts-mode)
;;                          (yaml-mode . yaml-ts-mode)))
;;         (add-to-list 'major-mode-remap-alist mapping))

;;       :config
;;       (mp-setup-install-grammars)

;;       ;; Do not forget to customize Combobulate to your liking:
;;       ;;
;;       ;;  M-x customize-group RET combobulate RET
;;       ;;
;;       (if (file-directory-p "~/go/src/github.com/st3fan/mickeynp/combobulate")
;;           (use-package combobulate
;;             :preface
;;             ;; You can customize Combobulate's key prefix here.
;;             ;; Note that you may have to restart Emacs for this to take effect!
;;             (setq combobulate-key-prefix "C-c o")

;;             ;; Optional, but recommended.
;;             ;;
;;             ;; You can manually enable Combobulate with `M-x
;;             ;; combobulate-mode'.
;;             :hook ((python-ts-mode . combobulate-mode)
;;                    (go-ts-mode . combobulate-mode)
;;                    (gomod-ts-mode . combobulate-mode)
;;                    (yaml-ts-mode . combobulate-mode)
;;                    (json-ts-mode . combobulate-mode))
;;             ;; Amend this to the directory where you keep Combobulate's source
;;             ;; code.
;;             :load-path ("~/go/src/github.com/st3fan/mickeynp/combobulate")))))

;;

(when (file-exists-p custom-file)
  (load custom-file))

(when (file-exists-p "~/.config/emacs/local.el")
  (load "~/.config/emacs/local.el"))
