;; -*- lexical-binding: t; -*-
(setopt custom-file (expand-file-name "custom.el" user-emacs-directory)
	make-backup-files nil
	use-short-answers t
	scroll-conservatively 101
	scroll-margin 5
	flymake-indicator-type 'margins
	flymake-margin-indicators-string
	`((error "!" compilation-error)
	  (warning "?" compilation-warning)
	  (note "i" compilation-info))
	eglot-autoshutdown t
	treesit-auto-install-grammar 'ask
	treesit-enabled-modes t
	completion-auto-help t
	completion-auto-select 'second-tab
	completion-eager-update t
	completion-ignore-case t
	completion-show-help nil
	completions-format 'one-column
	completions-max-height 10
	completions-sort 'historical
	enable-recursive-minibuffers t
	read-buffer-completion-ignore-case t
	read-file-name-completion-ignore-case t
	icomplete-delay-completions-threshold 0
	icomplete-compute-delay 0
	icomplete-show-matches-on-no-input t
	icomplete-scroll t)

(load custom-file :noerror)
(load-theme 'modus-vivendi)
(set-frame-font "Iosevka 12" nil t)

(global-hl-line-mode)
(savehist-mode)
(which-key-mode)

(defun micro80/prog-mode-setup ()
  "Prog mode settings."
  (display-line-numbers-mode)
  (electric-pair-mode)
  (flymake-mode)
  (unless (memq major-mode '(emacs-lisp-mode lisp-mode))
    (eglot-ensure)))
(add-hook 'prog-mode-hook #'micro80/prog-mode-setup)

(add-hook 'org-mode-hook #'variable-pitch-mode)

(with-eval-after-load 'eglot
  (define-key eglot-mode-map (kbd "C-c l a") #'eglot-code-actions)
  (define-key eglot-mode-map (kbd "C-c l o") #'eglot-code-action-organize-imports)
  (define-key eglot-mode-map (kbd "C-c l r") #'eglot-rename)
  (define-key eglot-mode-map (kbd "C-c l i") #'eglot-inlay-hints-mode)
  (define-key eglot-mode-map (kbd "C-c l f") #'eglot-format))

(with-eval-after-load 'flymake
  (define-key flymake-mode-map (kbd "M-n") #'flymake-goto-next-error)
  (define-key flymake-mode-map (kbd "M-p") #'flymake-goto-prev-error)
  (define-key flymake-mode-map (kbd "C-c ! l") #'flymake-show-buffer-diagnostics))

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(use-package olivetti
  :ensure t
  :hook 'org-mode-hook)

(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic)))

(use-package vertico
  :ensure t
  :custom
  (vertico-cycle t)
  (vertico-resize nil)
  :config
  (vertico-mode 1))
