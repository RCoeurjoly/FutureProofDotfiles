(add-hook 'emacs-startup-hook
          (lambda ()
            (require 'org)
            (org-babel-load-file
             (expand-file-name "configuration.org"))))
