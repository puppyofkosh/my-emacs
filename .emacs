(setq package-list '(auto-complete yasnippet xcscope ecb go-mode py-autopep8))

;; autopep8 requires you to sudo apt-get install python-autopep8

(require 'package)
; add MELPA to repository list
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))
; initialize package.elx
(package-initialize)

; fetch the list of packages available 
(unless package-archive-contents
  (package-refresh-contents))

; install the missing packages
(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))

; TO GET THIS RUN M-x package-install auto-complete
; start auto-complete with emacs
(require 'auto-complete)
; do default config for auto-complete
(require 'auto-complete-config)
(global-auto-complete-mode t)

(set-default 'ac-sources
             '(ac-source-imenu
               ac-source-dictionary
               ac-source-words-in-buffer
               ac-source-words-in-same-mode-buffers
               ac-source-words-in-all-buffer))
;; don't ignore case in providing ac matches
(setq ac-ignore-case nil)

;; M-x package-install xscope
(require 'xcscope)

;; Use flycheck whenever we can
;; For python you need to sudo apt-get install pylint
(add-hook 'after-init-hook #'global-flycheck-mode)

;;(ac-config-default)

; M-x package-install yasnippet
; yasnippet (gives us templates for loops and functions and stuff)
(require 'yasnippet)
(yas-global-mode 1)

; package-install iedit
; (Weird bug with iedit)
(define-key global-map (kbd "C-c ;") 'iedit-mode)

; package-install ecb
(require 'ecb)


(setq default-frame-alist
      '((top . 250) (left . 400)
        (width . 80) (height . 600)
        (cursor-color . "white")
        (cursor-type . box)
        (foreground-color . "blue")
        (background-color . "white")
        (font . "DejaVu Sans Mono-18")))

;; Use ibuffer instead of regular buffer list
(global-set-key (kbd "C-x C-b") 'ibuffer)


(setq initial-frame-alist '((top . 50) (left . 30)))

;; Pyret
(ignore-errors
  (add-to-list 'load-path (expand-file-name "~/.emacs.d/"))
  (require 'pyret)
  (add-to-list 'auto-mode-alist '("\\.arr$" . pyret-mode))
  (add-to-list 'file-coding-system-alist '("\\.arr\\'" . utf-8)))


;; Use spaces insteads of tabs
(setq tab-width 3)
(setq-default indent-tabs-mode nil)

;; C
(setq c-default-style "bsd"
      c-basic-offset 3)



(setq column-number-mode t)
(add-to-list 'default-frame-alist '(height . 55))
(add-to-list 'default-frame-alist '(width . 80))

;; to rename a variable
;; C-c , g (symref) then type in varname
;; C-c C-e (open references)
;; R (capital) to rename 


;; Set M-p and M-n to move cursor up/down 5 lines
(global-set-key (kbd "M-n")
    (lambda () (interactive) (next-line 5)))
(global-set-key (kbd "M-p")
    (lambda () (interactive) (previous-line 5)))

;; ecb key binding stuff
;;(global-set-key (kbd "<M-left>") 'ecb-goto-window-methods)
;;(global-set-key (kbd "<M-right>") 'ecb-goto-window-edit1)

(global-set-key (kbd "<M-left>") 'windmove-left)
(global-set-key (kbd "<M-right>") 'windmove-right)
(global-set-key (kbd "<M-up>") 'windmove-up)
(global-set-key (kbd "<M-down>") 'windmove-down)

;; gtags setup
(require 'ggtags)
(add-hook 'c-mode-common-hook
          (lambda ()
            (when (derived-mode-p 'c-mode 'c++-mode 'java-mode 'asm-mode)
              (ggtags-mode 1))))

(define-key ggtags-mode-map (kbd "C-c t s") 'ggtags-find-other-symbol)
;;(define-key ggtags-mode-map (kbd "C-c t d") 'ggtags-find-definition)
;; this bound to M-.
(define-key ggtags-mode-map (kbd "C-c t h") 'ggtags-view-tag-history)
(define-key ggtags-mode-map (kbd "C-c t r") 'ggtags-find-reference)
(define-key ggtags-mode-map (kbd "C-c t f") 'ggtags-find-file)
(define-key ggtags-mode-map (kbd "C-c t c") 'ggtags-create-tags)
(define-key ggtags-mode-map (kbd "C-c t u") 'ggtags-update-tags)
(define-key ggtags-mode-map (kbd "C-c t g") 'ggtags-grep)
(define-key ggtags-mode-map (kbd "C-c t n") 'ggtags-navigation-mode-abort)


;; (define-key ggtags-mode-map (kbd "M-,") 'pop-tag-mark)

;; hs-minor mode (for collapsing braces)
(add-hook 'c-mode-common-hook 'hs-minor-mode)
(global-set-key (kbd "C-c h h") 'hs-hide-block)
(global-set-key (kbd "C-c h s") 'hs-show-block)
(global-set-key (kbd "C-c h a") 'hs-hide-all)
(global-set-key (kbd "C-c h n") 'hs-show-all)

;; Rust
;; allow autocomplete in rust mode
(add-to-list 'ac-modes 'rust-mode)

;; Go
(add-to-list 'ac-modes 'go-mode)
(add-hook 'before-save-hook #'gofmt-before-save)


;; be able to list all functions in buffer
(require 'imenu-list)
(global-set-key (kbd "C-'") #'imenu-list-minor-mode)
(setq imenu-list-focus-after-activation t)



;; cscope
;;(add-hook 'prog-mode-hook #'cscope-minor-mode)


;; colors
(add-to-list 'default-frame-alist '(foreground-color . "#E0DFDB"))
(add-to-list 'default-frame-alist '(background-color . "#102372"))

;; command to create the tags file
(defun create-tags (dir-name)
  "Create tags file."
  (interactive "DDirectory: ")
  (eshell-command
   (format "find %s -type f -name \"*.[ch]\" | etags -" dir-name)))


(setq ibuffer-formats
      '((mark modified read-only " "
              (name 45 45 :left :elide) " "
              (size 9 -1 :right) " "
              (mode 16 16 :left :elide) " " filename-and-process)
        (mark " " (name 16 -1) " " filename)))


;; Whitespace 80 char limit thing
(require 'whitespace)
(setq whitespace-style '(face empty tabs lines-tail trailing))
(global-whitespace-mode t)

;; OSX ONLY
(setenv "PATH" (concat (getenv "PATH") ":/usr/local/bin"))
(setq exec-path (append exec-path '("/usr/local/bin")))

;; Cool tricks (to print 1, 2, 3, and so on on each line)
;; (dotimes (i 20) (insert (format "%d\n" (1+ i))))
