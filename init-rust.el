;; This Source Code Form is subject to the terms of the Mozilla Public
;; License, v. 2.0. If a copy of the MPL was not distributed with this
;; file, You can obtain one at http://mozilla.org/MPL/2.0/

;; https://github.com/rust-lang/rust-mode
(use-package rust-mode
  :ensure t
  :init (setq rust-format-on-save t))

;; https://github.com/kwrooijen/cargo.el
(use-package cargo
  :ensure t
  :after rust-mode
  :init (add-hook 'rust-mode-hook #'cargo-minor-mode))

;;(setenv "RUST_SRC_PATH" "/Users/stefan/.rustup/toolchains/stable-x86_64-apple-darwin/lib/rustlib/src/rust/src")

(use-package racer
  :ensure t
  :after rust-mode
  :init (add-hook 'rust-mode-hook #'racer-mode)
        (add-hook 'racer-mode-hook #'eldoc-mode)
        (add-hook 'racer-mode-hook #'company-mode)
        (add-hook 'racer-mode-hook
                  (lambda ()
                    (define-key rust-mode-map (kbd "TAB") #'company-indent-or-complete-common)
                    (setq company-tooltip-align-annotations t))))

