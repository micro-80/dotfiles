;; Most of this copied from protesilaos

;; hugely increase GC in startup, then increase to 100MB
(setq gc-cons-threshold most-positive-fixnum)
(add-hook 'emacs-startup-hook
          (lambda () (setq gc-cons-threshold 100000000)))

(setq frame-resize-pixelwise t
      frame-inhibit-implied-resize 'force      
      use-dialog-box nil
      use-file-dialog nil
      use-short-answers t
      inhibit-splash-screen t
      inhibit-startup-screen t)

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

(setq initial-frame-alist `((horizontal-scroll-bars . nil)
			    (vertical-scroll-bars . nil)
                            (menu-bar-lines . 0)
                            (tool-bar-lines . 0)))

(setq package-enable-at-startup t)
