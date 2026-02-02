;; -*- lexical-binding: t; -*-
(setq custom-file "~/.config/emacs/custom.el")
(load custom-file :noerror)

(setq create-lockfiles nil
      make-backup-files nil)
(let ((dir (expand-file-name "~/.config/emacs/saves/")))
  (unless (file-directory-p dir)
    (make-directory dir t))
  (setq auto-save-file-name-transforms `((".*" ,dir t))
        auto-save-list-file-prefix (concat dir ".saves-")))

(menu-bar-mode -1)
(savehist-mode 1)
(which-key-mode 1)
(add-hook 'prog-mode-hook 'display-line-numbers-mode)

(setq display-line-numbers-grow-only   t
      display-line-numbers-width-start t)
(setq org-startup-indented t)
(setq tab-bar-close-button-show nil
      tab-bar-tab-hints t
      tab-bar-format '(tab-bar-format-tabs tab-bar-separator))
(setopt use-short-answers t)
(setq vc-follow-symlinks t)
(setq xref-search-program 'ripgrep)

(setq ediff-window-setup-function 'ediff-setup-windows-plain
      ediff-split-window-function 'split-window-horizontally)
(add-hook 'ediff-cleanup-hook (lambda () (ediff-janitor t nil)))

(if (eq system-type 'darwin)
    (progn
      (setenv "PATH" (concat "/opt/homebrew/bin:" (getenv "PATH")))
      (add-to-list 'exec-path "/opt/homebrew/bin")
      (add-to-list 'default-frame-alist '(font . "Iosevka-14"))
      (set-frame-font "Iosevka-14" nil t)
      (set-face-attribute 'default nil :family "Iosevka" :height 140)
      (set-face-attribute 'fixed-pitch nil :family "Iosevka" :height 1.0)
      (set-face-attribute 'variable-pitch nil :family "Inter" :height 140)
      (setq ns-option-modifier 'meta
	    ns-right-alternate-modifier 'none))
  (progn
    (add-to-list 'default-frame-alist '(font . "Iosevka-12"))
    (set-frame-font "Iosevka-12" nil t)
    (set-face-attribute 'default nil :family "Iosevka" :height 120)
    (set-face-attribute 'fixed-pitch nil :family "Iosevka" :height 1.0)
    (set-face-attribute 'variable-pitch nil :family "Noto Sans" :height 120)
    ))

(require 'eglot)
(dolist (eglot-hooks '(go-ts-mode-hook))
  (add-hook eglot-hooks #'eglot-ensure))
(define-key eglot-mode-map (kbd "C-c a") 'eglot-code-actions)
(define-key eglot-mode-map (kbd "C-c r") 'eglot-rename)
(define-key eglot-mode-map (kbd "C-c f") 'eglot-format)

(require 'flymake)
(define-key flymake-mode-map (kbd "M-n") 'flymake-goto-next-error)
(define-key flymake-mode-map (kbd "M-p") 'flymake-goto-prev-error)
(define-key flymake-mode-map (kbd "C-c d") 'flymake-show-buffer-diagnostics)

(setq treesit-auto-install-grammar 'ask)
(setq treesit-language-source-alist
      '((c-sharp "https://github.com/tree-sitter/tree-sitter-c-sharp")
	(go "https://github.com/tree-sitter/tree-sitter-go")
	(gomod "https://github.com/camdencheek/tree-sitter-go-mod")
	(yaml "https://github.com/ikatyang/tree-sitter-yaml")))
(dolist (mode-alist '(("\\.cs\\'" . csharp-ts-mode)
		      ("\\.go\\'"     . go-ts-mode)
                      ("go\\.mod\\'" . go-mod-ts-mode)
		      ("\\.yml\\'" . yaml-ts-mode)
		      ("\\.yaml\\'" . yaml-ts-mode)))
  (add-to-list 'auto-mode-alist mode-alist))

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(use-package cape
  :ensure t
  :bind ("C-c p" . cape-prefix-map)
  :init
  (add-hook 'completion-at-point-functions #'cape-dabbrev)
  (add-hook 'completion-at-point-functions #'cape-file)
  (add-hook 'completion-at-point-functions #'cape-elisp-block))

(use-package consult
  :ensure t
  :bind (("C-x b" . consult-buffer)
         ("C-x p b" . consult-project-buffer)))

(use-package corfu
  :ensure t
  :custom
  (corfu-cycle t)
  :init
  (global-corfu-mode)
  (corfu-history-mode)
  (corfu-popupinfo-mode))

(use-package csv-mode
  :ensure t
  :mode ("\\.csv\\'" . csv-mode))

(use-package denote
  :ensure t
  :hook (dired-mode . denote-dired-mode)
  :bind
  (("C-c n n" . denote)
   ("C-c n r" . denote-rename-file)
   ("C-c n l" . denote-link)
   ("C-c n b" . denote-backlinks)
   ("C-c n d" . denote-dired)
   ("C-c n f" . (lambda() (interactive) (dired denote-directory))))
  :custom
  (denote-directory (expand-file-name "~/Documents/Notes/"))
  :config
  (denote-rename-buffer-mode 1))

(use-package doom-themes
  :ensure t
  :custom
  (doom-themes-enable-bold t)
  :config
  (load-theme 'doom-monokai-ristretto t)
  (doom-themes-visual-bell-config)
  (doom-themes-org-config)
  (custom-set-faces
   '(org-level-1 ((t (:inherit outline-1 :height 1.3))))
   '(org-level-2 ((t (:inherit outline-2 :height 1.2))))
   '(org-level-3 ((t (:inherit outline-3 :height 1.1))))
   '(org-level-4 ((t (:inherit outline-4 :height 1.1))))
   '(org-level-5 ((t (:inherit outline-5 :height 1.1))))
   ))

(use-package denote-journal
  :ensure t
  :bind (("C-c n j" . denote-journal-new-or-existing-entry))
  :commands (denote-journal-new-entry
             denote-journal-new-or-existing-entry
             denote-journal-link-or-create-entry)
  :hook (calendar-mode . denote-journal-calendar-mode)
  :custom
  (denote-journal-directory (expand-file-name "journal" denote-directory))
  (denote-journal-interval 'weekly)
  (denote-journal-keyword "journal")
  (denote-journal-title-format "%Y-W%W"))

(use-package eat
  :ensure t
  :custom
  (eat-term-name "xterm-256color"))

(use-package embark
  :ensure t
  :bind
  (("C-." . embark-act)
   ("C-;" . embark-dwim)
   ("C-h B" . embark-bindings))
  :init
  (setq prefix-help-command #'embark-prefix-help-command)
  :config
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

(use-package magit
  :ensure t
  :bind ("C-x g" . magit-status)
  :custom
  (if (eq system-type 'darwin)
      (magit-git-executable "/opt/homebrew/bin/git")))

(use-package marginalia
  :ensure t
  :init
  (marginalia-mode))

(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles partial-completion))))
  (completion-category-defaults nil)
  (completion-pcm-leading-wildcard t))

(use-package tempel
  :bind (("M-+" . tempel-complete)
         ("M-*" . tempel-insert)))

(use-package verb
  :ensure t
  :after org
  :config (define-key org-mode-map (kbd "C-c C-r") verb-command-map))

(use-package vertico
  :ensure t
  :custom
  ;; emacs
  (context-menu-mode t)
  (enable-recursive-minibuffers t)
  (read-extended-command-predicate #'command-completion-default-include-p)
  (minibuffer-prompt-properties
   '(read-only t cursor-intangible t face minibuffer-prompt))
  ;; vertico
  (vertico-count 10)
  (vertico-cycle t)
  :init
  (vertico-mode))

(use-package wgrep
  :ensure t)
