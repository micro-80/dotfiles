;; -- OPTIONS --
;; This section is a fucking mess - I will clean it once I am happy with it!

(setq inhibit-splash-screen t)
(setq use-file-dialog nil)
(menu-bar-mode -1)

(set-face-attribute 'default nil
		    :font "FiraCode Nerd Font Mono"
		    :height 140)

(global-display-line-numbers-mode)
(global-hl-line-mode)
(savehist-mode)

(setq mac-option-modifier 'meta)
(setq mac-right-option-modifier 'none)
(setq mac-command-modifier 'super)

(dolist (dir '("~/.emacs.d/backups" "~/.emacs.d/auto-saves"))
  (unless (file-directory-p dir)
    (make-directory dir t)))

(setq backup-directory-alist `(("." . "~/.emacs.d/backups"))
      auto-save-file-name-transforms `((".*" "~/.emacs.d/auto-saves/" t)))

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file 'noerror)

(setq ediff-window-setup-function 'ediff-setup-windows-plain
      ediff-split-window-function 'split-window-horizontally)

(setq browse-url-browser-function 'eww-browse-url)
(setq browse-url-firefox-program "/usr/bin/open")
(setq browse-url-firefox-arguments '("-a" "Firefox"))

(setq org-checkbox-hierarchical-statistics t
      org-enforce-todo-dependencies t)

(defvar-local my/notes-folder "~/Notes")
(defvar-local my/journal-folder "~/Notes/Journal/")
(defun my/open-current-week-journal ()
  "Open this week's journal file."
  (interactive)
  (find-file (expand-file-name (format-time-string "%G-W%V.org") my/journal-folder)))
(defun my/search-notes ()
  "Search notes with ripgrep."
  (interactive)
  (consult-ripgrep my/notes-folder))

(define-prefix-command 'notes-prefix)
(keymap-global-set "C-c n" 'notes-prefix)
(define-key notes-prefix (kbd "j") #'my/open-current-week-journal)
(define-key notes-prefix (kbd "s") #'my/search-notes)

(defun my/open-link-in-firefox ()
  "Open link below cursor in Firefox."
  (interactive)
  (let ((url (or (thing-at-point 'url t)
                 (read-string "URL: "))))
    (browse-url-firefox url)))

;; -- PLUGINS --

(require 'package)
(add-to-list 'package-archives '("gnu"   . "https://elpa.gnu.org/packages/"))
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

(setq use-package-always-ensure t)

(use-package cape
  :bind ("C-c p" . cape-prefix-map)
  :init
  (add-hook 'completion-at-point-functions #'cape-dabbrev)
  (add-hook 'completion-at-point-functions #'cape-file)
  (add-hook 'completion-at-point-functions #'yasnippet-capf))

(use-package corfu
  :custom
  (corfu-auto t)
  (corfu-preselect 'directory)
  (corfu-popupinfo-mode)
  :init
  (global-corfu-mode)
  :config
  (keymap-unset corfu-map "RET"))

(use-package consult
  :bind
  (
   ("C-c f d" . consult-flymake)
   ))

(use-package ef-themes
  :config
  (load-theme 'ef-dream t))

(use-package envrc
  :hook (after-init . envrc-global-mode))

;;(use-package exec-path-from-shell
;;  :config
;;  (exec-path-from-shell-initialize))

(use-package flymake
  :hook ((prog-mode) . flymake-mode)
  :bind (:map flymake-mode-map
              ("M-n" . flymake-goto-next-error)
              ("M-p" . flymake-goto-prev-error)))

(use-package flyspell
  :custom
  (ispell-dictionary "en_GB")
  (ispell-program-name "hunspell")
  (ispell-silently-savep t)
  :hook ((text-mode . flyspell-mode)
         (org-mode  . flyspell-mode)))

(use-package git-auto-commit-mode
  :custom
  (gac-automatically-push-p t)
  (gac-automatically-add-new-files-p t)
  (gac-silent-message-p t))

(use-package magit
  :custom
  (define-prefix-command 'magit-prefix)
  (keymap-global-set "C-x m" 'magit-prefix)
  (define-key magit-prefix (kbd "m") #'magit)
  (define-key magit-prefix (kbd "P") #'magit-pull)
  (define-key magit-prefix (kbd "p") #'magit-push))

(use-package marginalia
  :init
  (marginalia-mode))

(use-package multiple-cursors
  :bind
  ("C-S-c C-S-c" .  mc/edit-lines)
  ("C->" .  mc/mark-next-like-this)
  ("C-<" .  mc/mark-previous-like-this)
  ("C-c C-<" .  mc/mark-all-like-this))

(use-package nov
  :mode ("\\.epub\\'" . nov-mode))

(use-package olivetti
  :custom
  (olivetti-style 'fancy)
  (olivetti-body-width 100)
  :hook
  (olivetti-mode . (lambda () (display-line-numbers-mode 0))))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles partial-completion)))))

(use-package pdf-tools
  :init
  (pdf-loader-install)
  :hook
  (pdf-view-mode . (lambda () (display-line-numbers-mode -1)))
  :custom
  (pdf-view-display-size 'fit-page)
  (pdf-view-resize-factor 1.1)
  (pdf-annot-activate-created-annotations t))

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :custom
  (which-key-idle-delay 0.3))

(use-package yasnippet
  :init
  (yas-global-mode 1))

(use-package yasnippet-capf)

(use-package verb
  :after org
  :config
  (define-key org-mode-map (kbd "C-c C-v") verb-command-map))

(use-package vertico
  :custom
  (vertico-cycle t)
  :init
  (setq context-menu-mode t
	enable-recursive-minibuffers t
	read-extended-command-predicate #'command-completion-default-include-p
	minibuffer-prompt-properties
	'(read-only t cursor-intangible t face minibuffer-prompt))
  (vertico-mode))

(use-package vterm)

;; lsp + treesit + modes
(use-package eglot
  :custom
  (eglot-autoshutdown t)
  (eglot-code-action-indicator "!")
  :hook (prog-mode . eglot-ensure))

(add-to-list 'load-path (expand-file-name "~/.emacs.d/site-lisp/svelte-ts-mode"))
(use-package svelte-ts-mode
  :after eglot
  :ensure nil
  :config
  (add-to-list 'eglot-server-programs '(svelte-ts-mode . ("svelteserver" "--stdio"))))

(setq treesit-language-source-alist
   '((c "https://github.com/tree-sitter/tree-sitter-c")
     (cpp "https://github.com/tree-sitter/tree-sitter-cpp")
     (css "https://github.com/tree-sitter/tree-sitter-css")
     (go "https://github.com/tree-sitter/tree-sitter-go")
     (html "https://github.com/tree-sitter/tree-sitter-html")
     (javascript "https://github.com/tree-sitter/tree-sitter-javascript" "master" "src")
     (json "https://github.com/tree-sitter/tree-sitter-json")
     (python "https://github.com/tree-sitter/tree-sitter-python")
     (rust "https://github.com/tree-sitter/tree-sitter-rust")
     (svelte "https://github.com/Himujjal/tree-sitter-svelte")
     (toml "https://github.com/tree-sitter/tree-sitter-toml")
     (tsx "https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src")
     (typescript "https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src")
     (yaml "https://github.com/ikatyang/tree-sitter-yaml")))

(setq major-mode-remap-alist
      '((c-mode      . c-ts-mode)
        (c++-mode    . c++-ts-mode)
	(html-mode   . html-ts-mode)
	(java-mode   . java-ts-mode)
	(js-mode     . js-ts-mode)
	(python-mode . python-ts-mode)
        ))
