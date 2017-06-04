;; -*- coding: utf-8 -*-
;; The Little Prover
;;
;; (equal (first-of (pair a b)) a))
;;       
;; トップレベルのS式のそれぞれを順番に C-t C-e してみてください。
;;

;; J-BOBをインクルードする。
(include-book "j-bob")

;; 関数 pair を証明する。再帰関数でないので、かならず 't となる。
(J-Bob/prove
 (prelude)
 '(((defun pair (x y)
      (cons x (cons y '())))
    nil)))
;; 'T

;; 証明できるとわかったので、関数 pair を J-BOBの環境に定義する。
;; あたらしく defun.pair という環境ができる。
(defun defun.pair ()
  (J-Bob/define
   (prelude)
   '(((defun pair (x y)
        (cons x (cons y '())))
      nil))))

;; 同様に、関数 first-of を J-BOBの環境に定義する。
;; あたらしく defun.first-of という環境ができる。
(defun defun.first-of ()
  (J-Bob/define
   (defun.pair)
   '(((defun first-of (x)
        (car x))
      nil))))

;; 同様に、関数 secnd-of を J-BOBの環境に定義する。
;; あたらしく defun.second-of という環境ができる。
(defun defun.second-of ()
  (J-Bob/define
   (defun.first-of)
   '(((defun second-of (x)
        (car (cdr x)))
      nil))))


;; (equal (first-of (pair a b)) a)) を証明する。
;; まだなにもしていないので、ゴールが表示される。
(J-Bob/prove
 (defun.second-of)
 '(((dethm first-of-pair (a b)
           (equal (first-of (pair a b)) a))
    nil
    ;; (EQUAL (FIRST-OF (PAIR A B)) A)
    )))

;; ゴールS式の(1 1)にある (pair a b) を展開する。
(J-Bob/prove
 (defun.second-of)
 '(((dethm first-of-pair (a b)
           (equal (first-of (pair a b)) a))
    nil
    ((1 1) (pair a b))
    ;; (EQUAL (FIRST-OF (CONS A (CONS B 'NIL))) A)
    )))

;; ゴールS式の(1)にある (first-of ...) を展開する。
(J-Bob/prove
 (defun.second-of)
 '(((dethm first-of-pair (a b)
           (equal (first-of (pair a b)) a))
    nil
    ((1 1) (pair a b))
    ((1) (first-of (cons a (cons b '()))))
    ;; (EQUAL (CAR (CONS A (CONS B 'NIL))) A)
    )))

;; ゴールS式の(1)に、公理 car/cons を適用する。
;; (equal (car (cons x y)) x)
;; この場合は、
;; (car/cons a (cons b '())) なので、
;; (equal (car (cons a (cons b '()))) a) を適用することで、
;; 新しいゴールは、
;; (EQUAL A A) になる。
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

;; ゴールS式の全体に、公理 equal-same を適用する。
;; (equal (equal x x) 't)
;; この場合は、
;; (equal-same x) なので、
;; (equal (equal a a) 't) を適用することで、
;; ゴールは、
;; 'T になる。
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

;; 証明できるとわかったので、定理 first-of-pair を J-BOBの環境に定義す
;; る。あたらしく dethm.first-of-pair という環境ができる。
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

;; 同様に、定理 second-of-pair を J-BOBの環境に定義する。あたらしく
;; dethm.second-of-pair という環境ができる。
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

;; pair のどちらかにアトム '? が含まれているかをチェックする関数
;; in-pair? を定義する。これは、't か nil を返す。
(defun defun.in-pair? ()
  (J-Bob/define
   (dethm.second-of-pair)
   '(((defun in-pair? (xs)
        (if (equal (first-of xs) '?) 't (equal (second-of xs) '?)))
      nil))))

;; '? と任意もののpairに対して、in-pair? が真になるという定理を証明する。
;; (equal (in-pair? (pair '? b)) 't))

;; ゴールは (EQUAL (IN-PAIR? (PAIR '? B)) 'T) である。
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

;; 証明できるとわかったので、定理 in-first-of-pair を J-BOBの環境に定
;; 義する。あたらしく dethm.in-first-of-pair という環境ができる。
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

;; 同様に、定理 in-second-of-pair を J-BOBの環境に定義する。あたらしく
;; dethm.in-second-of-pair という環境ができる。
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
