(setq custom-file "~/.config/emacs/custom.el")
(load custom-file :noerror)

(setq inhibit-startup-screen t)

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
(setq ring-bell-function 'ignore)

(set-face-attribute 'default nil :family "Iosevka NFM" :height 140)
(set-face-attribute 'fixed-pitch nil :family "Iosevka NFM" :height 1.0)
(set-face-attribute 'variable-pitch nil :family "Inter" :height 160)

(setq org-startup-indented t)

(add-hook 'prog-mode-hook 'display-line-numbers-mode)

(setopt use-short-answers t)
(setq ns-option-modifier 'meta
      ns-right-alternate-modifier 'none)

(setenv "PATH" (concat "/opt/homebrew/bin:" (getenv "PATH")))
(add-to-list 'exec-path "/opt/homebrew/bin")

(setq vc-follow-symlinks t)

(require 'eglot)
(dolist (eglot-hooks '(go-ts-mode-hook))
  (add-hook eglot-hooks #'eglot-ensure))
(define-key eglot-mode-map (kbd "C-c r") 'eglot-rename)
(define-key eglot-mode-map (kbd "C-c f") 'eglot-format)

(require 'flymake)
(define-key flymake-mode-map (kbd "M-n") 'flymake-goto-next-error)
(define-key flymake-mode-map (kbd "M-p") 'flymake-goto-prev-error)
(define-key flymake-mode-map (kbd "C-c d") 'flymake-show-buffer-diagnostics)

(setq treesit-language-source-alist
      '((go "https://github.com/tree-sitter/tree-sitter-go")
	(gomod "https://github.com/camdencheek/tree-sitter-go-mod")
	(yaml "https://github.com/ikatyang/tree-sitter-yaml")))
(dolist (mode-alist '(("\\.go\\'"     . go-ts-mode)
                      ("go\\.mod\\'" . go-mod-ts-mode)
		      ("\\.yml\\'" . yaml-ts-mode)
		      ("\\.yaml\\'" . yaml-ts-mode)))
  (add-to-list 'auto-mode-alist mode-alist))

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(use-package consult
  :bind (("C-c m" . consult-man)
         ("C-c i" . consult-info)
         ([remap Info-search] . consult-info)
         ("C-x b" . consult-buffer)
         ("C-x p b" . consult-project-buffer)
         ("M-y" . consult-yank-pop)
         ("M-g f" . consult-flymake)
         ("M-g o" . consult-outline) ;; org headings
         ("M-s d" . consult-find)
         ("M-s c" . consult-locate)
         ("M-s g" . consult-grep)
         ("M-s G" . consult-git-grep)
         ("M-s r" . consult-ripgrep)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         ("M-s u" . consult-focus-lines))
  :hook (completion-list-mode . consult-preview-at-point-mode)
  :init
  (advice-add #'register-preview :override #'consult-register-window)
  (setq register-preview-delay 0.5)
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)
  :config
  (consult-customize
   consult-theme :preview-key '(:debounce 0.2 any)
   consult-ripgrep consult-git-grep consult-grep consult-man
   consult-bookmark consult-recent-file consult-xref
   consult-source-bookmark consult-source-file-register
   consult-source-recent-file consult-source-project-recent-file
   :preview-key '(:debounce 0.4 any)))

(use-package consult-denote
  :ensure t
  :bind
  (("C-c n f" . consult-denote-find)
   ("C-c n g" . consult-denote-grep))
  :config
  (consult-denote-mode 1))

(use-package corfu
  :ensure t
  :custom
  (corfu-cycle t)
  :init
  (global-corfu-mode)
  (corfu-history-mode)
  (corfu-popupinfo-mode))

(use-package denote
  :ensure t
  :hook (dired-mode . denote-dired-mode)
  :bind
  (("C-c n n" . denote)
   ("C-c n r" . denote-rename-file)
   ("C-c n l" . denote-link)
   ("C-c n b" . denote-backlinks)
   ("C-c n d" . denote-dired))
  :custom
  (denote-directory (expand-file-name "~/Org/Notes/"))
  :config
  (denote-rename-buffer-mode 1))

(use-package denote-journal
  :ensure t
  :commands ( denote-journal-new-entry
              denote-journal-new-or-existing-entry
              denote-journal-link-or-create-entry )
  :hook (calendar-mode . denote-journal-calendar-mode)
  :custom
  (denote-journal-directory (expand-file-name "journal" denote-directory))
  (denote-journal-keyword "journal")
  (denote-journal-title-format "%Y-%m-%d"))

(use-package doric-themes
  :ensure t
  :demand t
  :config
  (doric-themes-select 'doric-fire))

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

(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles partial-completion))))
  (completion-category-defaults nil)
  (completion-pcm-leading-wildcard t))

;; remember to install mupdf
(setq package-vc-allow-build-commands t)
(use-package reader
  :vc (:url "https://codeberg.org/divyaranjan/emacs-reader"
  	    :make "clean all"))

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
