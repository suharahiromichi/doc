;;; -*- coding: utf-8 -*-
;;; .emacs for Emacs23
;;; $Id: .emacs,v 1.10 2021/02/25 11:23:25 suhara Exp suhara $

;;; Function Keys
(global-set-key [f1] 'delete-other-windows)
(global-set-key [f2] 'split-window-vertically)
(global-set-key [f3] 'shell)
(global-set-key [f4] 'coq-windows)
(global-set-key [f5] 'anthy-default-mode)
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

;;; GnuEmacs
(setq menu-coding-system 'euc-jp)
(server-start)
(setq frame-title-format "%b")
(tool-bar-mode 0)
(menu-bar-mode 0)
(blink-cursor-mode 0)
;(setq x-select-enable-clipboard t)
;(setq interprogram-paste-function 'x-cut-buffer-or-selection-value)
(column-number-mode t)

;;; Mule-UNICODE
(cond ((eq emacs-major-version 21)
       (require 'un-define)
       (require 'un-tools)
       (require 'jisx0213)))


(set-language-environment "Japanese")
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-buffer-file-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)


;;;; SHELL for Windows
(add-hook 'shell-mode-hook
          (lambda ()
            (cond ((eq system-type 'windows-nt)
                   (set-buffer-process-coding-system 'sjis-unix 'sjis-unix)
                   (set-buffer-file-coding-system 'sjis-unix))
                  (t
                   (set-buffer-process-coding-system 'utf-8-unix 'utf-8-unix)
                   (set-buffer-file-coding-system 'utf-8-unix)))))
;;;;;;;;;;;;;;;;
;;;; IM
;;;;;;;;;;;;;;;;
(setq default-input-method "japanese-anthy")
;;; nn -> n'
(setq quail-japanese-use-double-n t)
(setq anthy-wide-space " ")
(setq anthy-accept-timeout 1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; default sytle
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq-default indent-tabs-mode nil)
;(setq-default fill-column 110)
(setq-default comment-column 44)


;;; OCaml
(setq auto-mode-alist (cons '("\\.ml\\w?" . tuareg-mode) auto-mode-alist))
(autoload 'tuareg-mode "tuareg" "Major mode for editing Caml code" t)


;;; C
(defun my-c-mode-common-hook ()
  (c-set-style "bsd")
  (setq comment-column 44)              ; for F-15 F/S
  (setq c-basic-offset 4)               ; for F-15 F/S
  )
(add-hook 'c-mode-common-hook 'my-c-mode-common-hook)


;;
;; Spin/Promela
;;
;(load "$HOME/lisp/promela-mode.el")
;(defun my-promela-mode-hook ()
;  (setq comment-column 44)
;  )
;(add-hook 'promela-mode-hook 'my-promela-mode-hook)
;(setq auto-mode-alist
;      (append
;       (list (cons "\\.promela$"  'promela-mode)
;             (cons "\\.spin$"     'promela-mode)
;             (cons "\\.pml$"      'promela-mode)
;             )
;       auto-mode-alist))


;;
;; Coq
;;
(load-file "/usr/local/share/emacs/site-lisp/ProofGeneral/generic/proof-site.el")
(load-file "/usr/local/share/emacs/site-lisp/pg-ssr.el")
;; 
;; ProofGneral に適したウィンドウを開く。
;;
(defun coq-windows-1 ()
  "Setup Windows for Proof General"
  (interactive)
  (delete-other-windows)
  (new-frame)
  (other-frame 1)
  (split-window-vertically)
  (switch-to-buffer "*goals*")
  (other-window 1)
  (switch-to-buffer "*response*")
  (other-window 1))

(defun coq-windows ()
  "Setup Windows for Proof General"
  (interactive)
  (toggle-frame-fullscreen)
  (delete-other-windows)
  (split-window-horizontally)
  (other-window 1)
  (switch-to-buffer "*goals*")
  (split-window-vertically)
  (other-window 1)
  (switch-to-buffer "*response*")
  (other-window 1))

;; end

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
(load "$HOME/lisp/egison-mode.el")
(setq auto-mode-alist
      (cons `("\\.egi$" . egison-mode) auto-mode-alist))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MacBook pro - internal display (default setting)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(cond
 (t
  (progn
    (setq initial-frame-alist
          (append (list
                   '(width . 90)
                   '(height . 56)
                   '(top . 0)
                   '(left . 0)
                   '(font . "梅ゴシック-13"))
                  initial-frame-alist))
    (setq default-frame-alist
          (append (list
                   '(width . 89)
                   '(height . 56)
                   '(font . "梅ゴシック-13"))
                  default-frame-alist))))
 (t
  (progn
    (setq initial-frame-alist
          (append (list
                   '(width . 86)
                   '(height . 48)
                   '(top . 0)
                   '(left . 0)
                   '(font . "梅ゴシック-11"))
                  initial-frame-alist))
    (setq default-frame-alist
          (append (list
                  '(width . 65)
                  '(height . 48)
                  '(top . 0)
                  '(left . 720)
                  '(font . "梅ゴシック-11"))
                  default-frame-alist))))
 (t
  (setq initial-frame-alist
        (append (list
                 '(width . 86)
                 '(height . 48)
                 '(top . 0)
                 '(left . 0)
                 '(font . "IPA モナー 明朝-11"))
                initial-frame-alist))
  (setq default-frame-alist
        (append (list
                 '(width . 86)
                 '(height . 48)
                 '(top . 0)
                 '(left . 640)
                 '(font . "IPA モナー 明朝-11"))
                default-frame-alist))))
;;;;;;;;;;;;;;;
;; END
;;;;;;;;;;;;;;;
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(safe-local-variable-values
   (quote
    ((coq-prog-args "-emacs-U" "-R" "/Users/suhara/WORK/coq3/cpdt-japanese/src" "Cpdt"))
    )))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


