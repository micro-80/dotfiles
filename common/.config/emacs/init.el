;; -*- lexical-binding: t; -*-

;; -- VARIABLES --
(setopt init-eglot-ensure-hooks '(c-mode-hook go-ts-mode-hook)
	init-frame-font "Iosevka Term 15"
	init-theme 'modus-vivendi)

(setopt completions-format 'one-column
	completions-max-height 15)

(setopt auto-mode-alist
	(append '(("\\.go\\'" . go-ts-mode)
		  ("/go\\.mod\\'" . go-mod-ts-mode)
		  ("\\.md\\'" . markdown-ts-mode))
		auto-mode-alist)
	treesit-language-source-alist
	'((go "https://github.com/tree-sitter/tree-sitter-go")
	  (gomod "https://github.com/camdencheek/tree-sitter-go-mod")
	  (markdown "https://github.com/ikatyang/tree-sitter-markdown")
	  (toml "https://github.com/tree-sitter/tree-sitter-toml")))

;; -- INIT --
(menu-bar-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)

(load-theme init-theme)
(set-frame-font init-frame-font nil t)

(add-hook 'prog-mode-hook 'hl-line-mode)
(add-hook 'prog-mode-hook 'display-line-numbers-mode)

(dolist (hook init-eglot-ensure-hooks)
  (add-hook hook 'eglot-ensure))
