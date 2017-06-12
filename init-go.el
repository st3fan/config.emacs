;; This Source Code Form is subject to the terms of the Mozilla Public
;; License, v. 2.0. If a copy of the MPL was not distributed with this
;; file, You can obtain one at http://mozilla.org/MPL/2.0/

(use-package go-mode
  :ensure t
  :init (add-hook 'go-mode-hook
                  (lambda ()
                    (setq gofmt-command "goimports")
                    (add-hook 'before-save-hook 'gofmt-before-save)
                    (setq truncate-lines t)
                    (setq indent-tabs-mode t)
                    (setq tab-width 4))))

(use-package go-eldoc
  :ensure t
  :init (add-hook 'go-mode-hook 'go-eldoc-setup))

(use-package go-guru
  :ensure t
  :init (add-hook 'go-mode-hook 'go-guru-hl-identifier-mode))

;; (use-package golist
;;   :ensure t)



