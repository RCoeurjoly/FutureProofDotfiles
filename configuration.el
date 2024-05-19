(setq org-agenda-files '("~/Exocortex"))

(custom-set-variables
 '(org-agenda-custom-commands
   '(("c" "Custom agenda, ignore IGNORE_FOR_AGENDA tag"
      ((agenda ""))
      ((org-agenda-tag-filter-preset '("-IGNORE_FOR_AGENDA")))))))

(setq org-log-done 'time)

(setq org-capture-templates
      '(("j" "JIRA" entry
         (file+headline "~/Exocortex/Exocortex.org" "JIRAs")
         (file "templates/JIRA.txt"))
        ("p" "project" entry
         (file+headline "~/Exocortex/Exocortex.org" "projects")
         (file "templates/project.txt"))))

(defun insert-orgproject-template ()
  "Insert org project template under current heading."
  (interactive)
  (org-insert-heading-respect-content)
  (org-metaright)
  (insert "Rationale")
  (org-insert-heading-respect-content)
  (insert "Desired result (Definition of Done)")
  (org-insert-heading-respect-content)
  (insert "Results")
  (org-insert-heading-respect-content)
  (insert "Relevant information")
  (org-insert-heading-respect-content)
  (org-metaright)
  (insert "Stream of Consciousness")
  (org-insert-heading-respect-content)
  (org-metaleft)
  (insert "Actions")
  (org-insert-heading-respect-content)
  (org-metaright)
  (insert "TODO_NEXT Determine the next [[file+emacs:~/Exocortex/20200427191126-moonshots.org::* Work on the hard part first][monkey action]] :monkey:"))

(defun insert-jira-template (jira-code)
  "Insert org project template under current heading."
  (interactive)
  (org-insert-link (concat "https://jira-inntech.grupobme.es/jira/browse/" jira-code) jira-code)
  (org-insert-heading-respect-content)
  (org-metaright)
  (insert "Rationale")
  (org-insert-heading-respect-content)
  (insert "Desired result (Definition of Done)")
  (org-insert-heading-respect-content)
  (insert "Informe de resolución")
  (org-insert-heading-respect-content)
  (org-metaright)
  (insert "Acciones realizadas")
  (org-insert-heading-respect-content)
  (org-metaright)
  (insert "Análisis de impacto")
  (org-insert-heading-respect-content)
  (org-metaright)
  (insert "Pruebas sugeridas")
  (org-insert-heading-respect-content)
  (org-metaleft)
  (insert "Relevant information")
  (org-insert-heading-respect-content)
  (org-metaright)
  (insert "Stream of Consciousness")
  (org-insert-heading-respect-content)
  (org-metaleft)
  (insert "Actions")
  (org-insert-heading-respect-content)
  (org-metaright)
  (insert "TODO_NEXT Determine the next [[file+emacs:~/Exocortex/20200427191126-moonshots.org::* Work on the hard part first][monkey action]] :monkey:"))

;;(make-directory "~/.org-jira")
(setq jiralib-url "https://jira-inntech.grupobme.es/")

(fset 'Enter-JIRA
   (kmacro-lambda-form [C-down C-down C-down C-down C-down C-down C-down C-down C-down C-down C-down C-down C-up C-up C-up C-down down tab ?r ?c ?o ?e ?u ?r ?j ?o ?l ?y tab ?U ?c ?3 ?m ?b ?a ?h ?a ?m ?u ?t ?6 return] 0 "%d"))

(add-to-list 'load-path "~/ob-elixir/ob-elixir.el")
(require 'ob-elixir)

(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (gnuplot . t)
   ;;(arduino . t)
   ;(verilog . t)
   (clojure . t)
   (C . t)
   (latex . t)
   (shell . t)
   (R . t)
   (sql . t)
   (perl . t)
   (python . t)
   (lua . t)
   (haskell . t)
   ;;(coq . t)
   (ocaml . t)
   (sqlite . t)
   (org . t)
   (elixir . t)
   (dot . t)))

(setq org-src-fontify-natively t)

(defadvice org-edit-src-code (around set-buffer-file-name activate compile)
  (let ((file-name (buffer-file-name))) ;; (1)
    ad-do-it                            ;; (2)
    (setq buffer-file-name file-name))) ;; (3)

(setq org-src-tab-acts-natively t)

(setq org-confirm-babel-evaluate nil)

(setq org-src-preserve-indentation t)

;;(require 'org-tempo)
(add-to-list 'org-structure-template-alist
'("sh" . "src shell"))
(add-to-list 'org-structure-template-alist
'("cpp" . "src C++"))
(add-to-list 'org-structure-template-alist
'("py" . "src python"))

(setq org-export-babel-evaluate nil)

(setq org-roam-directory "~/Exocortex/")
(setq org-roam-v2-ack t)
'(org-roam-completion-system (quote helm))

(defun my/org-roam--backlinks-list-with-content (file)
  (with-temp-buffer
    (if-let* ((backlinks (org-roam--get-backlinks file))
              (grouped-backlinks (--group-by (nth 0 it) backlinks)))
        (progn
          (insert (format "\n\n* %d Backlinks\n"
                          (length backlinks)))
          (dolist (group grouped-backlinks)
            (let ((file-from (car group))
                  (bls (cdr group)))
              (insert (format "** [[file:%s][%s]]\n"
                              file-from
                              (org-roam--get-title-or-slug file-from)))
              (dolist (backlink bls)
                (pcase-let ((`(,file-from _ ,props) backlink))
                  (insert (s-trim (s-replace "\n" " " (plist-get props :content))))
                  (insert "\n\n")))))))
    (buffer-string)))

  (defun my/org-export-preprocessor (backend)
    (let ((links (my/org-roam--backlinks-list-with-content (buffer-file-name))))
      (unless (string= links "")
        (save-excursion
          (goto-char (point-max))
          (insert (concat "\n* Backlinks\n") links)))))

;;  (add-hook 'org-export-before-processing-hook 'my/org-export-preprocessor)

;;(map! :map org-mode-map
;;       :i "[[" #'org-roam-node-insert
;;       :i "[ SPC" (cmd! (insert "[]")
;;                           (backward-char)))

;;(add-to-list 'load-path "~/.emacs.d/private/org-roam-ui")
;;(load-library "org-roam-ui")

;; Org-mode settings
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)
(global-font-lock-mode 1)

(setq org-startup-align-all-table t)
(setq org-startup-shrink-all-tables t)

;;(defun org-summary-todo (n-done n-not-done)
;;  "Switch entry to DONE when all subentries are done, to TODO otherwise."
;;  (let (org-log-done org-log-states)   ; turn off logging
;;    (org-todo (if (= n-not-done 0) "DONE" "TODO"))))

;; (add-hook 'org-after-todo-statistics-hook 'org-summary-todo)

(setq org-fontify-done-headline nil)

(setq org-todo-keywords
      '((sequence "TODO_NEXT(n!)" "TODO(t!)" "WAIT(w!)" "|" "DONE(d!)" "CANCELED(c!)")))

(setq org-hierarchical-todo-statistics t)

'(org-roam-completion-system (quote helm))
(global-page-break-lines-mode 0)
(setq org-roam-v2-ack t)

(setq org-ellipsis "⤵")

(require 'org-bullets)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
;;(setq org-bullets-bullet-list '("■" "◆" "▲" "▶"))
;;(setq org-bullets-bullet-list '("甲" "乙" "丙" "丁" "戊" "己" "庚" "辛" "壬" "癸"))
(setq org-bullets-bullet-list '("①" "②" "③" "④" "⑤" "⑥" "⑦" "⑧" "⑨" "⑩" "⑪" "⑫" "⑬" "⑭" "⑮" "⑯" "⑰" "⑱" "⑲" "⑳"))

(add-hook 'org-mode-hook #'visual-line-mode)

(setq org-format-latex-options (plist-put org-format-latex-options :scale 2.0))

;; Setting for GPG encryption in org mode
(custom-set-variables '(epg-gpg-program  "/usr/bin/gpg2"))

(require 'org-crypt)
(org-crypt-use-before-save-magic)
(setq org-tags-exclude-from-inheritance (quote ("crypt")))
;;  set to nil to use symmetric encryption.
(setq org-crypt-key nil)
(setq org-tag-alist '(("crypt" . ?c)))
;; Auto-saving does not cooperate with org-crypt.el: so you need
;; to turn it off if you plan to use org-crypt.el quite often.
;; Otherwise, you'll get an (annoying) message each time you
;; start Org.

;; To turn it off only locally, you can insert this:
;;
;; # -*- buffer-auto-save-file-name: nil; -*-
;; Better yet would be to leave auto-save on globally but set it on only in org mode
;; This is annoying
;; Set again when org crypt encrypts when saving
(add-hook 'org-mode-hook
          'auto-save-mode)
;;(add-hook 'org-mode-hook '(lambda()
;;                            (set (make-local-variable 'auto-save) nil)))
;; ;; Global Tags

;;(define-key org-mode-map (kbd "M-return") nil)

(setq org-link-search-must-match-exact-headline nil)

(setq browse-url-browser-function 'eww-browse-url)

(setq org-file-apps
      '((auto-mode . emacs)
        ("\\.pdf\\'" . emacs)
        ("\\.pdf::\\([0-9]+\\)\\'" . emacs)
        ("\\.pdf.xoj" . "xournal %s")))

(setq org-export-with-smart-quotes t)

(add-hook 'markdown-mode-hook #'flycheck-mode)
(add-hook 'gfm-mode-hook #'flycheck-mode)
(add-hook 'text-mode-hook #'flycheck-mode)
(add-hook 'org-mode-hook #'flycheck-mode)
(add-hook 'verilog-mode-hook #'flycheck-mode)
(add-hook 'arduino-mode-hook #'flycheck-mode)

(add-to-list 'org-modules 'org-habit t)

(fset 'add\ row\ to\ habit\ table
      (kmacro-lambda-form [134217798 134217798 134217798 134217798 ?\S-\C-f ?\M-w tab tab tab tab tab tab tab tab ?\C-y ?\M-b ?\M-b S-up S-up S-up S-up S-up S-up S-up tab ?\M-b ?\M-b ?\M-b ?\M-b left] 0 "%d"))

(setq global-visual-line-mode t)

(add-hook 'org-mode-hook
          (lambda () (face-remap-add-relative 'default :family "Monospace")))

(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")

(setq shell-file-name "bash")
(setq shell-command-switch "-ic")

(use-package yasnippet
  :ensure t
  :config
  (setq yas-snippet-dirs '("~/FutureProofDotfiles/snippets"))  ; Set snippet directory
  (yas-reload-all)  ; Reload the snippets after setting the directory
  (yas-global-mode 1))  ; Enable Yasnippet globally

(setq history-delete-duplicates t)

(setq user-full-name "Roland Coeurjoly"
      user-mail-address "rolandcoeurjoly@gmail.com")

(global-hl-line-mode)

(global-set-key [C-mouse-4] 'text-scale-increase)
(global-set-key [C-mouse-5] 'text-scale-decrease)

(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))
;;(load "~/clang/tools/clang-format/clang-format.el")
(global-set-key [C-M-tab] 'clang-format-region)
;;((c++-mode (helm-make-build-dir . "build/")))
;;(put 'helm-make-build-dir 'safe-local-variable 'stringp)

(setq compile-command "docker-compose -f ~/docker-services/dev/docker-compose.yml exec dev_rhel7 bash -c \"make\"")



(setq auto-mode-alist (cons '("\\.smt$" . smtlib-mode) auto-mode-alist))
(autoload 'smtlib-mode "smtlib" "Major mode for SMTLIB" t)
(setq smtlib-solver-cmd "z3")

;  (add-hook 'python-mode-hook 'company-jedi:setup)
;  (setq company-jedi:complete-on-dot t)
;  (setq elpy-rpc-backend "company-jedi")

;(eval-after-load "company"
; '(add-to-list 'company-backends 'company-anaconda))
;(spacemacs|defvar-company-backends python-mode)

;; This doesn't work in Ubuntu
(autoload 'arduino-mode "arduino-mode" "Arduino mode" t )
(add-hook 'arduino-mode-hook
          'auto-complete-mode
          'company-mode)

(setq flycheck-dafny-executable "~/Downloads/dafny/dafny")

(fset 'replace-binary-fix-separators
   (kmacro-lambda-form [?\M-x ?r ?e ?p ?l ?a ?c ?e ?- ?s ?t ?r ?i ?n ?g return ?^ ?A return ?\C-x ?8 return down return return] 0 "%d"))

(add-to-list 'load-path "~/FutureProofDotfiles/dependencies/cucumber.el")
(require 'feature-mode)
(add-to-list 'auto-mode-alist '("\.feature$" . feature-mode))

(global-flycheck-mode t)

(global-company-mode t)

(global-auto-complete-mode t)

(require 'cl-lib)
(cl-defun get-closest-pathname (&optional (file "Makefile"))
  "Determine the pathname of the first instance of FILE starting from the current directory towards root.
This may not do the correct thing in presence of links. If it does not find FILE, then it shall return the name
of FILE in the current directory, suitable for creation"
  (let ((root (expand-file-name "/"))) ; the win32 builds should translate this correctly
    (expand-file-name file
		      (loop
			for d = default-directory then (expand-file-name ".." d)
			if (file-exists-p (expand-file-name file d))
			return d
			if (equal d root)
			return nil))))
 (require 'compile)

(setq compile-command "executeInDocker make")

(autoload 'verilog-mode "verilog-mode" "Verilog mode" t )
(add-hook 'verilog-mode-hook
          'auto-complete-mode
          'company-mode)
(add-to-list 'auto-mode-alist '("\\.[ds]?vh?\\'" . verilog-mode))
(setq verilog-tool 'verilog-linter)
(setq verilog-linter "vlint ... ")
(setq verilog-coverage "coverage ... ")
(setq verilog-simulator "verilator ... ")
(setq verilog-compiler "verilator ... " )
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

(defun my/emacs-start-operations ()
  "Open specific org file and initialize Org Roam features."
  (find-file "~/Exocortex/20200916104516-now.org")
  (org-roam-db-sync)
  (org-roam-buffer-toggle))

(add-hook 'emacs-startup-hook 'my/emacs-start-operations)
(setq inhibit-startup-screen t)

(setq ediff-diff-options "-w")
(setq diff-switches "-u --ignore-space-change")

;;(fset 'open_file_in_docker
;;   "\C-x\C-f\C-a\C-k/docker\C-?::drcoeurjoly@dev_dev_rhel7_1:/data/programs/oms/include/vtstore/1.6.6/Node.h")

;;(defun file_in_docker
;;    find-file "/docker:drcoeurjoly@dev_dev_rhel7_1:/")

(use-package magit
  :ensure t)
(use-package helm
  :ensure t
  :config
  (helm-mode 1))
(use-package ivy
  :ensure t
  :config
  (ivy-mode 1))
(use-package projectile
  :ensure t
  :config
  (projectile-mode +1))
(use-package which-key
  :ensure t
  :config
  (which-key-mode))
(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))
(use-package company
  :ensure t
  :init
  (global-company-mode 1))
(use-package doom-themes
  :ensure t
  :config
  (load-theme 'doom-one t))
(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1))
(add-hook 'window-setup-hook 'toggle-frame-fullscreen)
