(setq make-backup-files nil)
(setq backup-inhibited nil)
(setq create-lockfiles nil)

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

(use-package eglot
  :ensure nil
  :hook (
	 (go-ts-mode . eglot-ensure)
	 )
  :bind ("M-<tab>" . 'eglot-code-actions)
  )

(require 'package)
(setopt package-archives
        '(("gnu" . "https://elpa.gnu.org/packages/")
          ("nongnu" . "https://elpa.nongnu.org/nongnu/")
          ("melpa" . "https://melpa.org/packages/")))

;; TODO - can this be moved?
(use-package emacs
  :custom
  ;; -- CORFU CONFIG --
  (tab-always-indent 'complete)

  ;; Emacs 30 and newer: Disable Ispell completion function.
  ;; Try `cape-dict' as an alternative.
  (text-mode-ispell-word-completion nil)

  ;; Hide commands in M-x which do not apply to the current mode.  Corfu
  ;; commands are hidden, since they are not used via M-x. This setting is
  ;; useful beyond Corfu.
  (read-extended-command-predicate #'command-completion-default-include-p)

  ;; -- VERTIGO CONFIG --
  (context-menu-mode t)
  (enable-recursive-minibuffers t)
  ;; Hide commands in M-x which do not work in the current mode.  Vertico
  ;; commands are hidden in normal buffers. This setting is useful beyond
  ;; Vertico.
  (read-extended-command-predicate #'command-completion-default-include-p)
  ;; Do not allow the cursor in the minibuffer prompt
  (minibuffer-prompt-properties
   '(read-only t cursor-intangible t face minibuffer-prompt))
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
  (corfu-cycle t)
  :init
  (global-corfu-mode)
  (corfu-popupinfo-mode)
  ;; corfu-quick looks nice, but doesn't seem to work
  ;;(corfu-quick) 
  )

;; TODO: change when new version comes out
(use-package ef-themes
  :ensure t
  :config
  (setq ef-themes-mixed-fonts t)
  (mapc #'disable-theme custom-enabled-themes)
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

(use-package kind-icon
  :ensure t
  :after corfu
  :config
  (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter))

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

(use-package vertico
  :ensure t
  :custom
  (vertico-cycle t)
  :init
  (vertico-mode))
