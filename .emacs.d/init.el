;; emacs start up and basic personalization
(menu-bar-mode)
(scroll-bar-mode)
(setq initial-scratch-message nil)
(setq make-backup-files nil)
(setq-default cursor-type 'bar)

;; package archive
(require 'package)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/"))
(package-initialize)

;; color-theme
(require 'color-theme)
(require 'color-theme-solarized)
(setq color-theme-is-global t)
(load-theme 'solarized-light t)

;; diminish

(require 'diminish)

;; clojure
(require 'clojure-mode)

;; rainbow delimiters
(require 'rainbow-delimiters)
(global-rainbow-delimiters-mode)

;; paredit
(require 'paredit)
(defun turn-on-paredit () (paredit-mode 1))
(add-hook 'clojure-mode-hook 'turn-on-paredit)
(add-hook 'emacs-lisp-mode-hook 'turn-on-paredit)

;; clean up paredit

(eval-after-load 'paredit
  '(progn
     (diminish 'paredit-mode " Par")     
     ;; These are handy everywhere, not just in lisp modes
     (global-set-key (kbd "M-(") 'paredit-wrap-round)
     (global-set-key (kbd "M-[") 'paredit-wrap-square)
     (global-set-key (kbd "M-{") 'paredit-wrap-curly)

     (global-set-key (kbd "M-)") 'paredit-close-round-and-newline)
     (global-set-key (kbd "M-]") 'paredit-close-square-and-newline)
     (global-set-key (kbd "M-}") 'paredit-close-curly-and-newline)

     (dolist (binding (list (kbd "C-<left>") (kbd "C-<right>")
                            (kbd "C-M-<left>") (kbd "C-M-<right>")))
       (define-key paredit-mode-map binding nil))

     ;; Disable kill-sentence, which is easily confused with the kill-sexp
     ;; binding, but doesn't preserve sexp structure
     (define-key paredit-mode-map [remap kill-sentence] nil)
     (define-key paredit-mode-map [remap backward-kill-sentence] nil)))

;; nrepl
(require 'nrepl)
(add-hook 'nrepl-interaction-mode-hook 'nrepl-turn-on-eldoc-mode)
(setq nrepl-popup-stacktraces nil)
(add-to-list 'same-window-buffer-names "*nrepl*")
(add-hook 'nrepl-mode-hook 'paredit-mode)
(global-set-key [f9] 'nrepl-jack-in)

;; Auto complete
(require 'auto-complete-config)
(ac-config-default)
(define-key ac-completing-map "\M-/" 'ac-stop) ; use M-/ to stop completion

;; ac-nrepl
(require 'ac-nrepl)
(add-hook 'nrepl-mode-hook 'ac-nrepl-setup)
(add-hook 'nrepl-interaction-mode-hook 'ac-nrepl-setup)
(eval-after-load "auto-complete" '(add-to-list 'ac-modes 'nrepl-mode))

;; Use only spaces (no tabs at all).
(setq-default indent-tabs-mode nil)

;; Always show column numbers.
(setq-default column-number-mode t)

;; Display full pathname for files.
(add-hook 'find-file-hooks
          '(lambda ()
             (setq mode-line-buffer-identification 'buffer-file-truename)))

;; For easy window scrolling up and down.
(global-set-key "\M-n" 'scroll-up-line)
(global-set-key "\M-p" 'scroll-down-line)

;; Laptop numeric keyboard

(global-set-key (kbd "<C-kp-home>") 'beginning-of-buffer)
(global-set-key (kbd "<C-kp-end>") 'end-of-buffer)
(global-set-key (kbd "<C-kp-right>") 'right-word)
(global-set-key (kbd "<C-kp-left>") 'left-word)
(global-set-key (kbd "<C-kp-up>") 'backward-paragraph)
(global-set-key (kbd "<C-kp-down>") 'forward-paragraph)

;; For easier regex search/replace.
(defalias 'qrr 'query-replace-regexp)

(menu-bar-mode)
