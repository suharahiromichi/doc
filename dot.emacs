;;; -*- coding: utf-8 -*-
;;; .emacs for Emacs23
;;; $Id: .emacs,v 1.20 2023/09/23 11:11:47 suhara Exp suhara $

;;; Function Keys
(global-set-key [f1] 'delete-other-windows)
(global-set-key [f2] 'split-window-vertically)
(global-set-key [f3] 'shell)
;(global-set-key [f4] 'coq-windows)
(global-set-key [f4] 'proof-three-window-toggle)
(global-set-key [f5] 'run-wolfram)
(global-set-key [f7] 'search-forward-regexp)
(global-set-key [f8] 'replace-regexp)
(global-set-key [f10] 'kill-buffer)
(global-set-key [down-mouse-3] 'mouse-buffer-menu)

;;; Key Bindings
(global-set-key [?\C-\ ] 'toggle-input-method)
(global-set-key [?\C-x?\C-b] 'ibuffer)
(global-set-key "\^\\" 'set-mark-command)
(global-set-key "\^h" 'delete-backward-char)
(global-set-key "\^t" 'call-last-kbd-macro)
(global-set-key "\^z"  'scroll-down)
(global-set-key "\^[g" 'goto-line)
(global-set-key "\^[k" 'kill-rectangle)
(global-set-key "\^[s" 'shell)
(global-set-key "\^[y" 'yank-rectangle)
(global-set-key "\^[\^[" 'what-line)

(global-set-key [?\C-x?\C-o] 'next-multiframe-window) ;; C-xC-o
(global-set-key "\^[o" 'previous-multiframe-window)   ;; M-o
;; PGで上書きされる。
;;(global-set-key "\^[p" 'previous-multiframe-window)
;;(global-set-key "\^[n" 'next-multiframe-window)

;;; GnuEmacs
(server-start)
(setq frame-title-format "%b")
(tool-bar-mode 1)
(menu-bar-mode 1)
(blink-cursor-mode 0)
(column-number-mode t)
;;(toggle-frame-fullscreen)

;; Emacs Mac Port (EMP)
;; ミニバッファに入力時、自動的に英語モード
(mac-auto-ascii-mode 1)
;;
;; Font設定
;;
(create-fontset-from-ascii-font "Menlo-14:weight=normal:slant=normal" nil "menlomarugo")
;;(create-fontset-from-ascii-font "Menlo-17:weight=normal:slant=normal" nil "menlomarugo")
(set-fontset-font "fontset-menlomarugo" 'unicode (font-spec :family "Hiragino Maru Gothic ProN" ) nil 'append)
(add-to-list 'default-frame-alist '(font . "fontset-menlomarugo"))
(setq face-font-rescale-alist '((".*Hiragino.*" . 1.2) (".*Menlo.*" . 1.0)))
;; フォント幅設定確認用文字列 (半角:全角 = 1:2)
;;||||||||||||||||||||||||||
;;||||||||あいうえお||||||||  <-- ここ揃ってますか？
;;||||||||||||||||||||||||||

;; Whitespace
(require 'whitespace)
(set-face-foreground 'whitespace-space "DarkOliveGreen3")
(set-face-background 'whitespace-space nil)
(set-face-bold-p 'whitespace-space t)
(set-face-foreground 'whitespace-tab "DarkOliveGreen3")
(set-face-background 'whitespace-tab nil)
(set-face-underline  'whitespace-tab t)
(setq whitespace-style '(face tabs tab-mark spaces space-mark))
(setq whitespace-space-regexp "\\(\x3000+\\)")
(setq whitespace-display-mappings
      '((space-mark ?\x3000 [?\□])
        (tab-mark   ?\t   [?\xBB ?\t])))
(global-whitespace-mode 1)              ; 全角スペースを常に表示
(global-set-key (kbd "C-x w") 'global-whitespace-mode) ; 全角スペース表示の切替

;;;;;;;;;;;;;;;;
;; IM
;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; default sytle
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq-default indent-tabs-mode nil)
;;(setq-default fill-column 110)
(setq-default comment-column 44)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Package System
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;;
;; Rust
;; MELPA rust-mode
;;
;;(add-to-list 'exec-path (expand-file-name "~/.cargo/bin"))
;;(use-package rust-mode
;;  :ensure t
;;  :custom rust-format-on-save t)

;;
;; OCaml
;; ELPA Tuareg Mode
;;

;;; C
(defun my-c-mode-common-hook ()
  (c-set-style "bsd")
  (setq comment-column 44)              ; for F-15 F/S
  (setq c-basic-offset 4)               ; for F-15 F/S
  )
(add-hook 'c-mode-common-hook 'my-c-mode-common-hook)

;;
;; Coq
;;
;; ELPA proof-general
;;
;(setq coq-prog-args '("-emacs" "-impredicative-set"))
(setq coq-prog-args
      (cons "-R" (cons "/Users/suhara/Work/coq/common/" (cons "common" (cons "-emacs" nil)))))

;;
;; Satysfi
;;
;;(require 'satysfi)
(load-file "$HOME/.emacs.d/lisp/satysfi.el")
(add-to-list 'auto-mode-alist '("\\.saty$" . satysfi-mode))
(add-to-list 'auto-mode-alist '("\\.satyh$" . satysfi-mode))
(setq satysfi-command "satysfi")
;;; set the command for typesetting (default: "satysfi -b")
(setq satysfi-pdf-viewer-command "sumatrapdf")
;; set the command for opening PDF files (default: "open")

;;
;; λProlog (Teyjus)
;; 
(load-file "$HOME/.emacs.d/lisp/teyjus.el")
(setq auto-mode-alist
   (cons '("\\.mod\\'" . teyjus-edit-mode) 
    (cons '("\\.sig\\'" . teyjus-edit-mode)
     (cons '("\\.hc\\'" .  teyjus-edit-mode)
      (cons '("\\.def\\'" .  teyjus-edit-mode)
       (cons '("\\.elpi\\'" .  teyjus-edit-mode)
           auto-mode-alist))))))
(autoload 'teyjus           "~/emacs/teyjus"
          "Run an inferior Teyjus process." t)
(autoload 'teyjus-edit-mode "~/emacs/teyjus" 
  "Syntax Highlighting, etc. for Lambda Prolog" t)

;;
;; SWI-Prolog
;;
;(load-file "$HOME/lisp/prolog.el") ;; ver.1.12
(setq auto-mode-alist
      (cons
       '("\\.swi" . prolog-mode)
       (cons
       '("\\.kl1" . prolog-mode)
       auto-mode-alist)))
(setq prolog-program-name "/usr/local/bin/swipl")
;;(setq prolog-program-name "/usr/local/bin/pl")
;;;(setq prolog-consult-string "[user].\n")
(setq prolog-indent-width 8)
(defun prolog-consult-buffer ()
  "Send current buffer to Prolog Process"
  (interactive)
  (save-excursion
    (send-string "prolog" prolog-consult-string)
    (send-region "prolog" (point-min) (point-max))
    (send-string "prolog" "\n")
    (if prolog-eof-string
        (send-string "prolog" prolog-eof-string)
      (process-send-eof "prolog"))
    (switch-to-buffer-other-window "*prolog*")))

;;
;; ACL2
;;
;; C-t を prefix に使う！
;(defvar acl2-skip-shell t)
;(defvar *acl2-shell* "*inferior-acl2*")
;(defvar inferior-acl2-program "acl2.sh")
;(load-file "$HOME/WORK/proj/acl2-7.2/emacs/emacs-acl2.el")

;;
;; Egison
;;
;;(load "$HOME/lisp/egison-mode.el")
(setq auto-mode-alist
      (cons `("\\.egi$" . egison-mode) auto-mode-alist))

;;
;; WolframScript
;;
(load-file "$HOME/.emacs.d/lisp/wolfram-mode.el")
(autoload 'wolfram-mode "wolfram-mode" nil t)
(autoload 'run-wolfram "wolfram-mode" nil t)
(setq wolfram-program "/usr/local/bin/wolframscript")
(setq wolfram-path "./")
(setq auto-mode-alist
      (cons `("\\.wls$" . wolfram-mode)
            (cons `("\\.m$" . wolfram-mode)
                  auto-mode-alist)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;
;; END
;;;;;;;;;;;;;;;
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(blink-cursor-mode nil)
 '(column-number-mode t)
 '(package-selected-packages '(rust-mode tuareg typescript-mode proof-general))
 '(safe-local-variable-values
   '((coq-prog-args "-emacs-U" "-R" "/Users/suhara/WORK/coq3/cpdt-japanese/src" "Cpdt"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Menlo" :foundry "nil" :slant normal :weight normal :height 120 :width normal)))))

(put 'set-goal-column 'disabled nil)
