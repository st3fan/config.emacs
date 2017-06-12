;; This Source Code Form is subject to the terms of the Mozilla Public
;; License, v. 2.0. If a copy of the MPL was not distributed with this
;; file, You can obtain one at http://mozilla.org/MPL/2.0/

(use-package fish-mode
  :ensure t)

(use-package json-mode
  :ensure t)

(use-package cc-mode
  :config (setq c-default-style "ellemtel"
                c-basic-offset 3))
