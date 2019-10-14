;; Basic emacs configuration
(setq inhibit-startup-message t)
(tool-bar-mode -1)
(toggle-frame-maximized)
(setq default-directory "~/")
(defalias 'yes-or-no-p 'y-or-n-p)

;; Move custom configuration variables set by Emacs, to a seperate file
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file 'noerror)

;; Package setup
(require 'package)
(add-to-list 'package-archives
	     '("melpa-stable" . "http://stable.melpa.org/packages/"))
(package-initialize)

;; Automatically reload files when they change on disk
(global-auto-revert-mode 1)
(setq auto-revert-verbose nil)

;; Install use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-verbose t)
(setq-default use-package-always-ensure t)

;; Theme setup
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
(use-package zenburn-theme
  :ensure t
  :config
  (load-theme 'zenburn t))

;; Look and Feel
(set-face-attribute 'region nil :background "gray20")
(set-cursor-color "sienna1")
(set-default-font "Source Code Pro-11")
(setq-default visible-bell t)
(delete-selection-mode t)

;; ido and flx-ido
(ido-mode t)
(ido-everywhere t)
(use-package ido-vertical-mode
  :ensure t
  :config
  (ido-vertical-mode t))

(use-package flx-ido
  :ensure t
  :config
  (flx-ido-mode 1))

;; smex
(use-package smex
  :ensure t
  :config
  (smex-initialize)
  (global-set-key (kbd "M-x") 'smex)
  (global-set-key (kbd "M-X") 'smex-major-mode-commands)
  (global-set-key (kbd "C-c C-c M-x") 'execute-extended-command))

(global-set-key [f7] 'start-kbd-macro)
(global-set-key [f8] 'end-kbd-macro)
(global-set-key [f9] 'call-last-kbd-macro)
(global-set-key (kbd "C-z") 'undo)
(global-set-key (kbd "C-x C-z") 'undo)

(setq
 frame-title-format
 '((:eval (if (buffer-file-name)
              (abbreviate-file-name (buffer-file-name))
            "%b"))))

;; Removed to try to fix an issue - unable to start NREPL process
;; ;; Adds some niceties/refactoring support
;; (use-package clj-refactor
;;   :ensure t
;;   :config
;;   (add-hook 'clojure-mode-hook
;;             (lambda ()
;;               (clj-refactor-mode 1))))

;; Aggressively indents your clojure code
(use-package aggressive-indent
  :ensure t
  :commands (aggressive-indent-mode)
  :config
  (add-hook 'clojure-mode-hook 'aggressive-indent-mode))

;; Which-key
(use-package which-key
  :ensure t
  :config
  (which-key-mode))

;; ELISP
(add-hook 'emacs-lisp-mode-hook 'eldoc-mode)

;; Install and setup company-mode for autocompletion
(use-package company
  :ensure t
  :init
  (add-hook 'prog-mode-hook 'company-mode)
  :config
  (global-company-mode)
  (setq company-tooltip-limit 10)
  (setq company-idle-delay 0.2)
  (setq company-echo-delay 0)
  (setq company-minimum-prefix-length 3)
  (setq company-require-match nil)
  (setq company-selection-wrap-around t)
  (setq company-tooltip-align-annotations t)
  (setq company-tooltip-flip-when-above t)
  ;; weight by frequency
  (setq company-transformers '(company-sort-by-occurrence)))

;; Cider integrates a Clojure buffer with a REPL
(use-package cider
  :ensure t
  :init
  (setq cider-repl-pop-to-buffer-on-connect 'display-only
        cider-show-error-buffer nil ;; changed from t in advised config to avoid error popups
        cider-auto-select-error-buffer t
        cider-repl-history-file "~/.emacs.d/cider-history"
        cider-repl-wrap-history t
        cider-repl-history-size 100
        cider-repl-use-clojure-font-lock t
        cider-docview-fill-column 70
        cider-stacktrace-fill-column 76
        ;; Stop error buffer from popping up while working in buffers other than REPL:
        nrepl-popup-stacktraces nil
        nrepl-log-messages nil
        nrepl-hide-special-buffers t
        cider-repl-use-pretty-printing t
        cider-repl-result-prefix ";; => ")

  :config
  (add-hook 'cider-mode-hook #'eldoc-mode)
  (add-hook 'cider-repl-mode-hook #'paredit-mode)
  (add-hook 'cider-repl-mode-hook #'company-mode)
  (add-hook 'cider-mode-hook #'company-mode)
  (add-hook 'cider-mode-hook
            (local-set-key (kbd "<C-return>") 'cider-eval-defun-at-point))

  (global-set-key [f12] 'cider-visit-error-buffer)) ;; this last was my add
;;(add-to-list 'same-window-buffer-names "<em>nrepl</em>")

(use-package clojure-mode
  :ensure t
  :config 
  (add-hook 'clojure-mode-hook 'turn-on-eldoc-mode))

;; Better syntax highlighting
(use-package clojure-mode-extra-font-locking
  :ensure t)

;; Paredit makes it easier to navigate/edit s-expressions as blocks.
(use-package paredit
  :ensure t
  :init
  (add-hook 'clojure-mode-hook 'enable-paredit-mode)
  (add-hook 'emacs-lisp-mode-hook 'paredit-mode)
  (add-hook 'cider-repl-mode-hook 'enable-paredit-mode))

;; Show parenthesis mode
(show-paren-mode 1)

;; To add some colors to those boring parens
(use-package rainbow-delimiters
  :ensure t
  :init (add-hook 'prog-mode-hook #'rainbow-delimiters-mode))

;; Windmove keys
(global-set-key (kbd "C-c <left>")  'windmove-left)
(global-set-key (kbd "C-c <right>") 'windmove-right)
(global-set-key (kbd "C-c <up>")    'windmove-up)
(global-set-key (kbd "C-c <down>")  'windmove-down)
(global-set-key (kbd "C-c C-<left>")  'windmove-left)
(global-set-key (kbd "C-c C-<right>") 'windmove-right)
(global-set-key (kbd "C-c C-<up>")    'windmove-up)
(global-set-key (kbd "C-c C-<down>")  'windmove-down)

;; Scrolling
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time
(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
(setq scroll-step 1) ;; keyboard scroll one line at a time
