;; -*- lexical-binding: t; no-byte-compile: t -*-

(setq make-backup-files nil)
(setq create-lockfiles nil)

;; hide M-x commands not relevant for current mode
;;(read-extended-command-predicate #'command-completion-default-include-p)

(let ((mono-spaced-font "Iosevka NF")
      (proportionately-spaced-font "Sans"))
  (set-face-attribute 'default nil :family mono-spaced-font :height 140)
  (set-face-attribute 'fixed-pitch nil :family mono-spaced-font :height 1.0)
  (set-face-attribute 'variable-pitch nil :family proportionately-spaced-font :height 1.0))

(setq mac-option-key-is-meta t)
(setq mac-right-option-modifier nil)

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file :noerror)

(defun set-prog-options ()
  (display-line-numbers-mode)
  (hl-line-mode))
(add-hook 'prog-mode-hook 'set-prog-options)

(setq browse-url-browser-function 'eww-browse-url)
(setq browse-url-chrome-program "/usr/bin/open")
(setq browse-url-chrome-arguments '("-a" "Google Chrome"))

(defun my/open-link-in-chrome ()
  "Open link below cursor in Chrome."
  (interactive)
  (let ((url (or (thing-at-point 'url t)
                 (read-string "URL: "))))
    (browse-url-chrome url)))

(use-package dired
  :ensure nil
  :commands (dired)
  :hook (dired-mode . hl-line-mode)
  :config
  (setq dired-dwim-target t))

(use-package flymake
  :ensure nil
  :bind (
	 ("M-n" . 'flymake-goto-next-error)
	 ("M-p" . 'flymake-goto-prev-error)
	 )
  )

(use-package flyspell
  :ensure nil
  :hook ((git-commit-mode . flyspell-mode)
	 (text-mode . flyspell-mode)
	 (org-mode . flyspell-mode))
  :config
  (setq ispell-program-name "aspell")
  )

(use-package org
  :ensure nil
  :config
  (setq org-agenda-files (append '("~/Notes/agenda.org") (file-expand-wildcards "~/Notes/Denote/journal/*.org"))
	org-checkbox-hierarchical-statistics t
	org-enforce-todo-dependencies t
	org-todo-keywords '((sequence "TODO" "IN PROGRESS" "DONE")))
  (org-babel-do-load-languages
   'org-babel-load-languages
   '(
     (shell . t)
     )
   ))

(use-package savehist
  :ensure nil
  :init
  (savehist-mode))

(use-package which-key
  :ensure nil
  :init
  (which-key-mode))

(require 'package)
(setopt package-archives
        '(("gnu" . "https://elpa.gnu.org/packages/")
          ("nongnu" . "https://elpa.nongnu.org/nongnu/")
          ("melpa" . "https://melpa.org/packages/")))

(use-package avy
  :ensure t
  :bind (
	 ("C-:" . avy-goto-char)
	 ("C-'" . avy-goto-word-1)
	 )
  )

(use-package exec-path-from-shell
  :ensure t
  :init
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize))
  )

(use-package cape
  :ensure t
  :bind ("C-c p" . cape-prefix-map)
  )

(use-package consult
  :ensure t
  ;; below are minimal bindings based on things I know I use. Look at docs for comprehensive binds.
  :bind(("C-x b" . consult-buffer)
	("C-x p b" . consult-project-buffer)
	("M-g g" . consult-goto-line)
	("M-g M-g" . consult-goto-line)
	("M-s r" . consult-ripgrep)
	("M-s G" . consult-git-grep)
	("M-s l" . consult-line)
	)
  :init
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)
  )

(use-package corfu
  :ensure t
  :custom
  ;; -- EMACS --
  (tab-always-indent 'complete)
  (text-mode-ispell-word-completion nil)
  ;; -- PLUGIN --
  (corfu-cycle t)
  :init
  (global-corfu-mode)
  (corfu-popupinfo-mode)
  ;; corfu-quick looks nice, but doesn't seem to work
  ;;(corfu-quick)
  )

(use-package consult-denote
  :ensure t
  :bind
  (("C-c n f" . consult-denote-find)
   ("C-c n g" . consult-denote-grep))
  :config
  (consult-denote-mode 1))

(use-package denote
  :ensure t
  :commands denote-article
  :bind
  (("C-c n a" . denote-article)
   ("C-c n n" . denote)
   ("C-c n R" . denote-rename-file-using-front-matter)
   ("C-c n r" . denote-rename-file)
   ("C-c n l" . denote-link)
   ("C-c n b" . denote-backlinks)
   ("C-c n d" . denote-dired))
  :config
  (setq denote-directory (expand-file-name "~/Notes/Denote"))
  (denote-rename-buffer-mode 1)

  ;; denote-article - one day make this into a plugin
  (defun denote-article (url)
    "Create a Denote note for a webpage URL."
    (interactive "sEnter URL: ")
    (require 'url-parse)
    (require 'denote)
    (let* ((url-parsed (url-generic-parse-url url))
           (host (url-host url-parsed))
           (title (get-page-title url))
           (keywords (list (format "site-%s" host))))
      ;; store values for hook to use
      (setq denote-last-url url
            denote-last-title title)
      (denote title keywords)))

  (defvar denote-last-url nil
    "Holds the URL for the most recent Denote-created note.")

  (defvar denote-last-title nil
    "Holds the title for the most recent Denote-created note.")

  (defun get-page-title (url)
    "Retrieve the <title> of a web page at URL."
    (let ((title))
      (with-current-buffer (url-retrieve-synchronously url)
	(goto-char (point-min))
	(when (re-search-forward "<title>\\([^<]*\\)</title>" nil t 1)
          (setq title (string-trim (match-string 1)))))
      title))

  (defun denote-insert-url-link ()
    "Insert an Org link to the source URL at the end of the new note."
    (when (and denote-last-url denote-last-title)
      (save-excursion
	(goto-char (point-max))
	(insert (format "[[%s][%s]]\n\n"
			denote-last-url
			denote-last-title)))
      (setq denote-last-url nil
            denote-last-title nil))
    (goto-char (point-max)))

  (add-hook 'denote-after-new-note-hook #'denote-insert-url-link)
  )

(use-package denote-journal
  :ensure t
  :bind ("C-c n j" . denote-journal-new-or-existing-entry)
  :config
  (setq denote-journal-directory
        (expand-file-name "journal" denote-directory))
  (setq denote-journal-keyword "journal")
  (setq denote-journal-interval "weekly")
  (setq denote-journal-title-format "Week %V - %Y"))

;; TODO upgrade when 2.0 is out
(use-package ef-themes
  :ensure t
  :config
  (mapc #'disable-theme custom-enabled-themes)
  (load-theme 'ef-dream :no-confirm)
  (ef-themes-select 'ef-dream))

(use-package embark
  :ensure t
  :bind
  (("C-." . embark-act)
   ("C-;" . embark-dwim)
   ("C-h B" . embark-bindings)))

(use-package embark-consult
  :ensure t
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

(use-package magit
  :ensure t)

(use-package marginalia
  :ensure t
  :init
  (marginalia-mode))

(use-package nerd-icons
  :ensure t)

(use-package nerd-icons-completion
  :ensure t
  :after marginalia
  :hook (marginalia-mode . nerd-icons-completion-marginalia-setup)
  :init
  (nerd-icons-completion-mode))

(use-package nerd-icons-corfu
  :ensure t
  :after corfu
  :config
  (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter))

(use-package nerd-icons-dired
  :ensure t
  :hook (dired-mode . nerd-icons-dired-mode))

(use-package nov
  :ensure t
  :mode
  ("\\.epub\\'" . nov-mode))

(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles partial-completion))))
  (completion-category-defaults nil)
  (completion-pcm-leading-wildcard t))

(use-package tempel
  :ensure t
  :bind (("M-+" . tempel-complete)
         ("M-*" . tempel-insert))
  :custom
  (tempel-trigger-prefix "<")
  :init
  (defun tempel-setup-capf ()
    (setq-local completion-at-point-functions
                (cons #'tempel-complete
                      completion-at-point-functions)))
  (add-hook 'conf-mode-hook 'tempel-setup-capf)
  (add-hook 'prog-mode-hook 'tempel-setup-capf)
  (add-hook 'text-mode-hook 'tempel-setup-capf)
  )

(use-package verb
  :ensure t
  :config
  (define-key org-mode-map (kbd "C-c C-r") verb-command-map))

(use-package vertico
  :ensure t
  :custom
  ;; -- EMACS --
  (context-menu-mode t)
  (enable-recursive-minibuffers t)
  (minibuffer-prompt-properties
   '(read-only t cursor-intangible t face minibuffer-prompt))
  ;; -- PLUGIN --
  (vertico-cycle t)
  :init
  (vertico-mode))

(setq treesit-language-source-alist
      '((bash "https://github.com/tree-sitter/tree-sitter-bash")
	(css "https://github.com/tree-sitter/tree-sitter-css")
	(elisp "https://github.com/Wilfred/tree-sitter-elisp")
	(go "https://github.com/tree-sitter/tree-sitter-go")
	(html "https://github.com/tree-sitter/tree-sitter-html")
	(java "https://github.com/tree-sitter/tree-sitter-java")
	(javascript "https://github.com/tree-sitter/tree-sitter-javascript")
	(json "https://github.com/tree-sitter/tree-sitter-json")
	(make "https://github.com/alemuller/tree-sitter-make")
	(markdown "https://github.com/ikatyang/tree-sitter-markdown")
	(python "https://github.com/tree-sitter/tree-sitter-python")
	(sql "https://github.com/DerekStride/tree-sitter-sql" "gh-pages" "src")
	(toml "https://github.com/tree-sitter/tree-sitter-toml")
	(tsx "https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src")
	(typescript "https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src")
	(yaml "https://github.com/ikatyang/tree-sitter-yaml")))

(setq major-mode-remap-alist
      '(
	(yaml-mode . yaml-ts-mode)
	(bash-mode . bash-ts-mode)
	(js2-mode . js-ts-mode)
	(typescript-mode . typescript-ts-mode)
	(json-mode . json-ts-mode)
	(css-mode . css-ts-mode)
	(python-mode . python-ts-mode)
	(java-mode . java-ts-mode)
	(sql-mode . sql-ts-mode)
	)
      )

(add-to-list 'auto-mode-alist '("\\.go\\'" . go-ts-mode))
(add-to-list 'auto-mode-alist '("\\.gomod\\'" . go-ts-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-ts-mode))

(use-package eglot
  :ensure nil
  :hook (
	 (go-ts-mode . eglot-ensure)
	 )
  :bind (
	 ("C-c a" . 'eglot-code-actions)
	 ("C-c i" . 'eglot-inlay-hints-mode)
	 ("C-c f" . 'eglot-format)
	 ("C-c r" . 'eglot-rename)
	 )
  :custom
  (eglot-code-action-indicator "")
  )
