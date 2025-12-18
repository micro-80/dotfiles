(setq custom-file "~/.config/emacs/custom.el")
(load custom-file :noerror)

(setq inhibit-startup-screen t)

(icomplete-vertical-mode 1)
(setq completion-styles '(basic flex)
      completions-format 'one-column
      completions-sort 'historical
      completions-max-height 30
      icomplete-scroll t
      ;; ignore case in icomplete
      completion-ignore-case t
      read-file-name-completion-ignore-case t
      read-buffer-completion-ignore-case t)

(setq create-lockfiles nil
      make-backup-files nil)
(let ((dir (expand-file-name "~/.config/emacs/saves/")))
  (unless (file-directory-p dir)
    (make-directory dir t))
  (setq auto-save-file-name-transforms `((".*" ,dir t))
        auto-save-list-file-prefix (concat dir ".saves-")))

(savehist-mode 1)
(which-key-mode 1)
(menu-bar-mode -1)
(tool-bar-mode -1)
(setq ring-bell-function 'ignore)

(set-face-attribute 'default nil :family "Iosevka NFM" :height 140)
(set-face-attribute 'fixed-pitch nil :family "Iosevka NFM" :height 1.0)
(set-face-attribute 'variable-pitch nil :family "Inter" :height 160)

(require-theme 'modus-themes)
(setq modus-vivendi-palette-overrides
      '((docstring yellow-faint)
	(string yellow-warmer))
      modus-themes-headings
      '((1 . (variable-pitch bold 1.5))
	(2 . (variable-pitch bold 1.4))
	(3 . (variable-pitch bold 1.3))
	(4 . (variable-pitch bold 1.2))
	(t . (variable-pitch bold 1.1)))
      modus-themes-italic-constructs t
      modus-themes-bold-constructs nil
      modus-themes-mixed-fonts t)
(load-theme 'modus-operandi)

(setq org-startup-indented t)

(add-hook 'prog-mode-hook (lambda() (display-line-numbers-mode 1)
				     (completion-preview-mode 1)))

(setopt use-short-answers t)
(setq ns-option-modifier 'meta
      ns-right-alternate-modifier 'none)

(setenv "PATH" (concat "/opt/homebrew/bin:" (getenv "PATH")))
(add-to-list 'exec-path "/opt/homebrew/bin")

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

(use-package elfeed
  :ensure t
  :bind (("C-x f" . elfeed)
	 :map elfeed-search-mode-map
         ("m" . (lambda ()
		  (interactive)
		  (elfeed-search-toggle-all 'star))))
  :custom
  (elfeed-use-curl t)
  (elfeed-curl-extra-arguments '("--insecure"))
  :config
  (elfeed-set-timeout 36000))

(use-package elfeed-protocol
  :ensure t
  :after elfeed
  :custom
  (elfeed-protocol-feeds '(("fever+http://admin@aiko"
			    :api-url "http://aiko/api/fever.php"
			    :password-file "~/.config/emacs/freshrss-password"))) ;; TODO - use 'pass' maybe?
  (elfeed-protocol-enabled-protocols '(fever))
  (elfeed-protocol-fever-update-unread-only nil)
  (elfeed-protocol-fever-fetch-category-as-tag t) ;; freshrss id fix
  :config
  (elfeed-protocol-enable))

(use-package verb
  :ensure t
  :after org
  :config (define-key org-mode-map (kbd "C-c C-r") verb-command-map))
