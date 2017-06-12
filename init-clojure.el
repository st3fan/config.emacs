;; This Source Code Form is subject to the terms of the Mozilla Public
;; License, v. 2.0. If a copy of the MPL was not distributed with this
;; file, You can obtain one at http://mozilla.org/MPL/2.0/

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
