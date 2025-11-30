;; -*- lexical-binding: t; no-byte-compile: t -*-

(setq make-backup-files nil
      backup-inhibited t
      auto-save-default nil
      create-lockfiles nil)

(let ((mono-spaced-font "Iosevka NF")
      (proportionately-spaced-font "Sans"))
  (set-face-attribute 'default nil :family mono-spaced-font :height 140)
  (set-face-attribute 'fixed-pitch nil :family mono-spaced-font :height 1.0)
  (set-face-attribute 'variable-pitch nil :family "Arial" :height 140))

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

(defun my/kill-other-buffers ()
  "Kill all other buffers."
  (interactive)
  (mapc 'kill-buffer (delq (current-buffer) (buffer-list))))

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
  (setq ispell-local-dictionary "en_GB-ise"
	ispell-program-name "aspell")
  )

(use-package org
  :ensure nil
  :config
  (setq org-agenda-files (append '("~/Notes/agenda.org") (file-expand-wildcards "~/Notes/Denote/journal/*.org"))
	org-checkbox-hierarchical-statistics t
	org-enforce-todo-dependencies t
	org-hide-emphasis-markers t
	org-hide-leading-stars t
	org-startup-indented t
	org-todo-keywords '((sequence "TODO" "IN PROGRESS" "DONE")))
  (org-babel-do-load-languages
   'org-babel-load-languages
   '(
     (shell . t)
     )
   )
  )

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
	 ("C-'" . avy-goto-word-1)
	 ("C-\"" . avy-goto-char)
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
  :bind ("C-q" . corfu-quick-insert)
  :custom
  ;; -- EMACS --
  (tab-always-indent 'complete)
  (text-mode-ispell-word-completion nil)
  ;; -- PLUGIN --
  (corfu-cycle t)
  :init
  (global-corfu-mode)
  (corfu-popupinfo-mode)
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
  (defun denote-article ()
    "Create a Denote note for a webpage URL in the clipboard."
    (interactive)
    (require 'url-parse)
    (require 'denote)
    (let* ((url (current-kill 0))
	   (url-parsed (url-generic-parse-url url))
           (host (url-host url-parsed))
           (title (org-cliplink-retrieve-title-synchronously url))
           (keywords (list (format "site-%s" host))))
      ;; store values for hook to use
      (setq denote-last-url url
            denote-last-title title)
      (denote title keywords)))

  (defvar denote-last-url nil
    "Holds the URL for the most recent Denote-created note.")

  (defvar denote-last-title nil
    "Holds the title for the most recent Denote-created note.")

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

(use-package eat
  :ensure t
  :after project
  :bind (:map project-prefix-map
              ("t" . eat-project)
	      ("T" . eat-project-other-window))
  :init
  (add-to-list 'project-switch-commands '(eat-project "Eat terminal") t)
  (add-to-list 'project-switch-commands '(eat-project-other-window "Eat terminal other window") t)
  (add-to-list 'project-kill-buffer-conditions '(major-mode . eat-mode))
  :custom
  (process-adaptive-read-buffering nil)
  (eat-kill-buffer-on-exit t)
  (eat-term-name "xterm-256color"))

(use-package ef-themes
  :ensure t
  :init
  (ef-themes-take-over-modus-themes-mode 1)
  :config
  (setq modus-themes-mixed-fonts t
        modus-themes-italic-constructs t
        modus-themes-bold-constructs t
	modus-themes-scale-headings t
	modus-themes-headings
	'((1 . (semibold 1.4))
          (2 . (semibold 1.3))
          (3 . (semibold 1.2))
          (t . (semibold 1.1)))
        modus-themes-completions '((t . (bold)))
        modus-themes-prompts '(bold))
  
  (modus-themes-load-theme 'ef-autumn))

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

(use-package olivetti
  :ensure t
  :config
  (setq-default olivetti-body-width 0.6)
  (setq olivetti-style 'fancy)
  (setq olivetti-minimum-body-width 80))

(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles partial-completion))))
  (completion-category-defaults nil)
  (completion-pcm-leading-wildcard t))

(use-package org-cliplink
  :ensure t)

(use-package pdf-tools
  :ensure t
  :mode ("\\.pdf\\'" . pdf-tools-install))

(use-package tempel
  :ensure t
  :bind (("M-+" . tempel-complete)
         ("M-*" . tempel-insert))
  :init
  (defun tempel-setup-capf ()
    (setq-local completion-at-point-functions
                (cons #'tempel-expand completion-at-point-functions))
  )

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
