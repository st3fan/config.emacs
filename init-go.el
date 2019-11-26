;; This Source Code Form is subject to the terms of the Mozilla Public
;; License, v. 2.0. If a copy of the MPL was not distributed with this
;; file, You can obtain one at http://mozilla.org/MPL/2.0/

(use-package go-mode
  :ensure t
  :init (add-hook 'go-mode-hook
                  (lambda ()
                    ;;(setq gofmt-command "goimports")
                    (add-hook 'before-save-hook 'lsp-organize-imports nil t)
                    (setq truncate-lines t)
                    (setq indent-tabs-mode t)
                    (setq tab-width 4))))

(use-package yasnippet
  :diminish yas-minor-mode
  :custom (yas-snippet-dirs '("~/.emacs.d/snippets"))
  :hook (after-init . yas-global-mode))

(require 'company-lsp)
(push 'company-lsp company-backends)

(use-package lsp-mode
  :ensure t
  :commands (lsp lsp-deferred)
  :config (progn
	    (setq lsp-auto-guess-root t)
	    (setq lsp-prefer-flymake nil)))

(add-hook 'go-mode-hook #'lsp-deferred)

(use-package company-lsp
  :config
  (push 'company-lsp company-backends))

;; optional - provides fancier overlays
(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode
  :config
  (setq lsp-ui-sideline-enable nil
        lsp-ui-doc-enable nil
        lsp-ui-flycheck-enable nil
        lsp-ui-imenu-enable nil
        lsp-ui-sideline-ignore-duplicate t))

;; if you use company-mode for completion (otherwise, complete-at-point works out of the box):
(use-package company-lsp
	     :ensure t
  :commands company-lsp)


(use-package flycheck
	       :ensure t)




;;(use-package go-eldoc
;;  :ensure t
;;  :init (add-hook 'go-mode-hook 'go-eldoc-setup))
;;
;;(use-package go-guru
;;  :ensure t
;;  :init (add-hook 'go-mode-hook 'go-guru-hl-identifier-mode))

;; (use-package golist
;;   :ensure t)



