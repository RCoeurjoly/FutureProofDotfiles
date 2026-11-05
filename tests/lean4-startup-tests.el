;;; lean4-startup-tests.el --- Lean startup regression checks -*- lexical-binding: t; -*-

;; Run with the flake's Emacs:
;; nix run . -- --batch -q -l tests/lean4-startup-tests.el -f ert-run-tests-batch-and-exit

(require 'ert)
(require 'package)
(package-initialize)
(require 'use-package)

;; Load just the Lean configuration, without unrelated personal startup hooks.
(with-temp-buffer
  (insert-file-contents
   (expand-file-name "../configuration.el"
                     (file-name-directory (or load-file-name buffer-file-name))))
  (search-forward "(use-package lean4-mode")
  (goto-char (match-beginning 0))
  (eval (read (current-buffer))))
(require 'lean4-mode)

(ert-deftest lean4-startup-does-not-probe-or-download-toolchains-synchronously ()
  "Constructing the LSP command must not execute an elan toolchain proxy."
  (let* ((root (make-temp-file "lean4-startup-" t))
         (bin (expand-file-name "bin" root))
         (marker (expand-file-name "proxy-was-executed" root))
         (lake (expand-file-name "lake" bin))
         (lean4-rootdir root))
    (unwind-protect
        (progn
          (make-directory bin)
          (dolist (name '("lean" "lake"))
            (let ((file (expand-file-name name bin)))
              (with-temp-file file
                (insert "#!/bin/sh\n"
                        "touch " (shell-quote-argument marker) "\n"
                        "printf 'Lake version 5.0.0 (Lean version 4.35.0)\\n'\n"))
              (set-file-modes file #o755)))
          (let ((command (lean4--server-cmd)))
            (should-not (file-exists-p marker))
            (should (equal command (list lake "serve")))))
      (delete-directory root t))))

;;; lean4-startup-tests.el ends here
