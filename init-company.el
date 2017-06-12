;; This Source Code Form is subject to the terms of the Mozilla Public
;; License, v. 2.0. If a copy of the MPL was not distributed with this
;; file, You can obtain one at http://mozilla.org/MPL/2.0/

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
