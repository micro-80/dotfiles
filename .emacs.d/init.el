(setq make-backup-files nil)
(setq backup-inhibited nil)
(setq create-lockfiles nil)

;; hide M-x commands not relevant for current mode
;;(read-extended-command-predicate #'command-completion-default-include-p)

(defun flash-mode-line ()
  (invert-face 'mode-line)
  (run-with-timer 0.1 nil #'invert-face 'mode-line))
(setq ring-bell-function #'flash-mode-line)

(let ((mono-spaced-font "JetBrainsMono NF")
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

(setq org-agenda-files '("~/Notes/agenda.org"))
(org-babel-do-load-languages
   'org-babel-load-languages
   '(
     (shell . t)
     )
   )

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
  :bind(;; below are minimal bindings based on things I know I use. Look at docs for comprehensive binds.
	("C-x b" . consult-buffer)
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
  :bind
  (("C-c n n" . denote)
   ("C-c n f" . my/denote-find-file)
   ("C-c n R" . denote-rename-file-using-front-matter)
   ("C-c n r" . denote-rename-file)
   ("C-c n l" . denote-link)
   ("C-c n b" . denote-backlinks)
   ("C-c n d" . denote-dired))
  :config
  (setq denote-directory (expand-file-name "~/Notes/Denote"))
  (denote-rename-buffer-mode 1)
  )

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
	 ("M-<tab>" . 'eglot-code-actions)
	 ("C-c i" . 'eglot-inlay-hints-mode)
	 ("C-c f" . 'eglot-format)
	 ("C-c r" . 'eglot-rename)
	 )
  :custom
  (eglot-code-action-indicator "")
  )
