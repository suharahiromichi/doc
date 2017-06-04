;; -*- coding: utf-8 -*-
;; The Little Prover
;;
;; (equal (first-of (pair a b)) a))
;;       
;; M-x run-acl2     
;;        S           C-t C-e          
;;
;; pair   first-of, second-of          
;; a   b   pair      first-of   a              
;;

(in-package "ACL2")

;; J-BOB          
(include-book "j-bob")

;;    pair                      't     
(J-Bob/prove
 (prelude)
 '(((defun pair (x y)
      (cons x (cons y '())))
    nil)))
;; 'T

;;                 pair   J-BOB         
;;       defun.pair           
(defun defun.pair ()
  (J-Bob/define
   (prelude)
   '(((defun pair (x y)
        (cons x (cons y '())))
      nil))))

;;        first-of   J-BOB         
;;       defun.first-of           
(defun defun.first-of ()
  (J-Bob/define
   (defun.pair)
   '(((defun first-of (x)
        (car x))
      nil))))

;;        secnd-of   J-BOB         
;;       defun.second-of           
(defun defun.second-of ()
  (J-Bob/define
   (defun.first-of)
   '(((defun second-of (x)
        (car (cdr x)))
      nil))))


;; (equal (first-of (pair a b)) a))       
;;                        
(J-Bob/prove
 (defun.second-of)
 '(((dethm first-of-pair (a b)
           (equal (first-of (pair a b)) a))
    nil
    ;; (EQUAL (FIRST-OF (PAIR A B)) A)
    )))

;;    S  (1 1)    (pair a b)       
(J-Bob/prove
 (defun.second-of)
 '(((dethm first-of-pair (a b)
           (equal (first-of (pair a b)) a))
    nil
    ((1 1) (pair a b))
    ;; (EQUAL (FIRST-OF (CONS A (CONS B 'NIL))) A)
    )))

;;    S  (1)    (first-of ...)       
(J-Bob/prove
 (defun.second-of)
 '(((dethm first-of-pair (a b)
           (equal (first-of (pair a b)) a))
    nil
    ((1 1) (pair a b))
    ((1) (first-of (cons a (cons b '()))))
    ;; (EQUAL (CAR (CONS A (CONS B 'NIL))) A)
    )))

;;    S  (1)     car/cons       
;; (equal (car (cons x y)) x)
;;       
;; (car/cons a (cons b '()))     
;; (equal (car (cons a (cons b '()))) a)          
;;         
;; (EQUAL A A)     
(J-Bob/prove
 (defun.second-of)
 '(((dethm first-of-pair (a b)
           (equal (first-of (pair a b)) a))
    nil
    ((1 1) (pair a b))
    ((1) (first-of (cons a (cons b '()))))
    ((1) (car/cons a (cons b '())))
    ;; (EQUAL A A)
    )))

;;    S         equal-same       
;; (equal (equal x x) 't)
;;       
;; (equal-same x)     
;; (equal (equal a a) 't)          
;;      
;; 'T     
(J-Bob/prove
 (defun.second-of)
 '(((dethm first-of-pair (a b)
           (equal (first-of (pair a b)) a))
    nil
    ((1 1) (pair a b))
    ((1) (first-of (cons a (cons b '()))))
    ((1) (car/cons a (cons b '())))
    (() (equal-same a))
    ;; 'T
    )))

;;                 first-of-pair   J-BOB       
;;         dethm.first-of-pair           
(defun dethm.first-of-pair ()
  (J-Bob/define
   (defun.second-of)
   '(((dethm first-of-pair (a b)
             (equal (first-of (pair a b)) a))
      nil
      ((1 1) (pair a b))
      ((1) (first-of (cons a (cons b '()))))
      ((1) (car/cons a (cons b '())))
      (() (equal-same a))))))

;;        second-of-pair   J-BOB              
;; dethm.second-of-pair           
(defun dethm.second-of-pair ()
  (J-Bob/define
   (dethm.first-of-pair)
   '(((dethm second-of-pair (a b)
             (equal (second-of (pair a b)) b))
      nil
      ((1) (second-of (pair a b)))
      ((1 1 1) (pair a b))
      ((1 1) (cdr/cons a (cons b '())))
      ((1) (car/cons b '()))
      (() (equal-same b))))))

;; pair           '?                  
;; in-pair?           't   nil     
(defun defun.in-pair? ()
  (J-Bob/define
   (dethm.second-of-pair)
   '(((defun in-pair? (xs)
        (if (equal (first-of xs) '?) 't (equal (second-of xs) '?)))
      nil))))

;; '?       pair     in-pair?                 
;; (equal (in-pair? (pair '? b)) 't))

;;      (EQUAL (IN-PAIR? (PAIR '? B)) 'T)     
(J-Bob/prove
 (defun.in-pair?)
 '(((dethm in-first-of-pair (b)
           (equal (in-pair? (pair '? b)) 't))
    nil
    ;; (EQUAL (IN-PAIR? (PAIR '? B)) 'T)
    )))

(J-Bob/prove
 (defun.in-pair?)
 '(((dethm in-first-of-pair (b)
           (equal (in-pair? (pair '? b)) 't))
    nil
    ((1 1) (pair '? b))
    ;; (EQUAL (IN-PAIR? (CONS '? (CONS B 'NIL))) 'T)
    )))

(J-Bob/prove
 (defun.in-pair?)
 '(((dethm in-first-of-pair (b)
           (equal (in-pair? (pair '? b)) 't))
    nil
    ((1 1) (pair '? b))
    ((1) (in-pair? (cons '? (cons b '()))))
    ;; (EQUAL (IF (EQUAL (FIRST-OF (CONS '? (CONS B 'NIL))) '?)
    ;;            'T
    ;;            (EQUAL (SECOND-OF (CONS '? (CONS B 'NIL))) '?))
    ;;        'T)
    )))

(J-Bob/prove
 (defun.in-pair?)
 '(((dethm in-first-of-pair (b)
           (equal (in-pair? (pair '? b)) 't))
    nil
    ((1 1) (pair '? b))
    ((1) (in-pair? (cons '? (cons b '()))))
    ((1 Q 1) (first-of (cons '? (cons b '()))))
    ;; (EQUAL (IF (EQUAL (CAR (CONS '? (CONS B 'NIL))) '?)
    ;;            'T
    ;;            (EQUAL (SECOND-OF (CONS '? (CONS B 'NIL))) '?))
    ;;        'T)
    )))

(J-Bob/prove
 (defun.in-pair?)
 '(((dethm in-first-of-pair (b)
           (equal (in-pair? (pair '? b)) 't))
    nil
    ((1 1) (pair '? b))
    ((1) (in-pair? (cons '? (cons b '()))))
    ((1 Q 1) (first-of (cons '? (cons b '()))))
    ((1 Q 1) (car/cons '? (cons b '())))
    ;; (EQUAL (IF (EQUAL '? '?)
    ;;            'T
    ;;            (EQUAL (SECOND-OF (CONS '? (CONS B 'NIL))) '?))
    ;;        'T)
    )))

(J-Bob/prove
 (defun.in-pair?)
 '(((dethm in-first-of-pair (b)
           (equal (in-pair? (pair '? b)) 't))
    nil
    ((1 1) (pair '? b))
    ((1) (in-pair? (cons '? (cons b '()))))
    ((1 Q 1) (first-of (cons '? (cons b '()))))
    ((1 Q 1) (car/cons '? (cons b '())))
    ((1 Q) (equal-same '?))
    ;; (EQUAL (IF 'T
    ;;            'T
    ;;            (EQUAL (SECOND-OF (CONS '? (CONS B 'NIL))) '?))
    ;;        'T)
    )))

(J-Bob/prove
 (defun.in-pair?)
 '(((dethm in-first-of-pair (b)
           (equal (in-pair? (pair '? b)) 't))
    nil
    ((1 1) (pair '? b))
    ((1) (in-pair? (cons '? (cons b '()))))
    ((1 Q 1) (first-of (cons '? (cons b '()))))
    ((1 Q 1) (car/cons '? (cons b '())))
    ((1 Q) (equal-same '?))
    ((1) (if-true 't (equal (second-of (cons '? (cons b '()))) '?)))
    ;; (EQUAL 'T 'T)
    )))

(J-Bob/prove
 (defun.in-pair?)
 '(((dethm in-first-of-pair (b)
           (equal (in-pair? (pair '? b)) 't))
    nil
    ((1 1) (pair '? b))
    ((1) (in-pair? (cons '? (cons b '()))))
    ((1 Q 1) (first-of (cons '? (cons b '()))))
    ((1 Q 1) (car/cons '? (cons b '())))
    ((1 Q) (equal-same '?))
    ((1) (if-true 't (equal (second-of (cons '? (cons b '()))) '?)))
    (() (equal-same 't))
    ;; 'T
    )))

;;                 in-first-of-pair   J-BOB     
;;           dethm.in-first-of-pair           
(defun dethm.in-first-of-pair ()
  (J-Bob/define
   (defun.in-pair?)
   '(((dethm in-first-of-pair (b)
             (equal (in-pair? (pair '? b)) 't))
      nil
      ((1 1) (pair '? b))
      ((1) (in-pair? (cons '? (cons b '()))))
      ((1 Q 1) (first-of (cons '? (cons b '()))))
      ((1 Q 1) (car/cons '? (cons b '())))
      ((1 Q) (equal-same '?))
      ((1) (if-true 't (equal (second-of (cons '? (cons b '()))) '?)))
      (() (equal-same 't))))))

;;        in-second-of-pair   J-BOB              
;; dethm.in-second-of-pair           
(defun dethm.in-second-of-pair ()
  (J-Bob/define (dethm.in-first-of-pair)
    '(((dethm in-second-of-pair (a)
         (equal (in-pair? (pair a '?)) 't))
       nil
       ((1 1) (pair a '?))
       ((1) (in-pair? (cons a (cons '? '()))))
       ((1 Q 1) (first-of (cons a (cons '? '()))))
       ((1 Q 1) (car/cons a (cons '? '())))
       ((1 E 1) (second-of (cons a (cons '? '()))))
       ((1 E 1 1) (cdr/cons a (cons '? '())))
       ((1 E 1) (car/cons '? '()))
       ((1 E) (equal-same '?))
       ((1) (if-same (equal a '?) 't))
       (() (equal-same 't))))))

;; END
