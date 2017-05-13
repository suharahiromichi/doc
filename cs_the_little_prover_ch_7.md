"The Little Prover" 第7章
=======================

第65回 ProofCafe 2017年5月20日

2017_05_20 @suharahiromichi

第l章の第mフレーム[から第n]を、CHl.n[-m] と示します。

# 概要

ctx? 関数に関する定理を証明します。
ctx?の定義はCH7.3で、リストの要素に'?があるとき't、さもなければ'()を返します。

ここでは、3つの証明します。このうち、1と2は前前回読んだので復習をします。
今回は3を中心に読んでいきます。

1. ctx? が全域関数(total)であることの証明 (CH7.4-6)。

2. 定理 ctx?/sub の証明 (CH7.7-29)。

3. 補題 ctx?/t の証明 (CH7.30-40)。


# ctx? が全域関数であることの証明 (CH7.4-6)。

## ctx? の定義 (CH7.3)

```lisp:
(defun ctx? (x)
       (if (atom x)
           (equal x '?)
           (if (ctx? (car x))
               't
               (ctx? (cdr x)))))
measure: (size x)
```

``measure: (size x)`` は、引数のリスト ``x`` のサイズが減ることを停止性の根拠とすることを意味する。


## totality claim の定義 (CH7.4)

全域的であることの主張は CH7.4で示される。この命題を証明する。
ctx?の定義から、その totality claim を求める方法は第8章で説明する。

先生は、関数が全域的でなけれは、定義できない、という制約を言及している。


## totality claim の証明 (CH7.5)

- 赤が前提 (premise) で、書き換えの前提になる。
- 黒が注目する場所、フォーカス(focus) で、書き換えの対象になる。
- 青がそれ以外の箇所

具体的には、

(1) ``(atom x)`` を前提に、``size/car``公理 （裏表紙参照）をつかって、最初の フォーカス の ``(< (size (car x)) (size x))`` を ``'t`` に書き換える。``size/car``公理

```lisp:
(dethm size/car (x)
       (if (atom x)
           't
           (equal (< (size (car x)) (size x)) 't)))
```

は、前提``(atom x)``のelse節では、``(< (size (car x)) (size x))`` を ``'t`` に書き換えられることを意味する。

(2) ``(atom x)`` を前提に、``size/cdr``公理 （裏表紙参照）をつかって、最初の フォーカス の ``(< (size (cdr x)) (size x))`` を ``'t`` に書き換える。


## totality claim の証明 (CH7.6)

以下、本文で省略されている書き換えを補足する。


```lisp:
(if (atom x)
    't
    (if 't
        (if (ctx? (car x))
            't
            't)
        '()))
```

`` (if 't ...) ``をフォーカスにして、公理``if-true``を適用する。

```lisp:
(if (atom x)
    't
    (if (ctx? (car x))
        't
        't))
```

`` (if (ctx? (car x)) ...) ``をフォーカスにして、公理``if-same``を適用する。

```lisp:
(if (atom x)
    't
    't)
```

`` (if (atom x) ...) ``をフォーカスにして、ふたたび、公理``if-same``を適用する。

```lisp:
't
```

Q.E.D.


## 「全域関数」についての注意

全域関数(total function)とは、引数のすべて定義域に対して、計算が停止して関数の値が決まる関数のことです。

部分関数(partial function)とは、引数のすべて定義域に対して、関数の値が決まらなくても *よい* 関数なので、全域関数は部分関数に含まれるます。なので、ここでは、「全域的」か「全域的でない」かという言い方をして、部分関数という語は使いません。

定義域つまり引数の型を明確にしないと、厳密が議論はできませんが、ここではLispの一種でリストを引数とする関数だけを扱うので、全域的とは、「引数にどんなリストが与えられても結果が得られる」という意味に理解してください。
リストを与えるべきところに、数値などを与えた場合などについては、関数の定義のなかで配慮されていますから、注意してください。


# 定理 ctx?/sub の証明 (CH7.7-29)。

## sub関数 (CH7.7)

```lisp:
(defun sub (x y)
       (if (atom y)
           (if (equal y '?)
               x
               y)
           (cons (sub x (car y))
                 (sub x (cdr y)))))
measure: (size y)
```

``(sub x y)`` は、リスト``y``の要素``'?``を``x``で置き換える。
これは全域的であり、リスト``y``のサイズにより停止性が保証される。その証明はCH4.88-94にある。
（それが証明できないと、関数として定義できない。）


``x``のサイズは変わらないことに注意。

## 命題ctx?/sub (CH7.7)

```lisp:
(dethm ctx?/sub (x y)
       (if (ctx? x)
           (if (ctx? y)
               (equal (ctx? (sub x y)) 't)
               't)
           't))
```

命題ctx?/subは、
``x``の要素に``'?``があり、
``y``の要素に``'?``があるなら、
(sub x y)の値の要素には、``'?``がある。


## Star Induction （星型帰納）による証明 (CH7.8-9)。

Natural Induction  （自然帰納）(CH6.35) と対になる。
Natural Induction が、線形なリストのcdrの方向に再帰を進めるのに対して、
Star Induction は、リストのcarとcdrの両方の方向に再帰を進める。
Star InductionもNatual Inductionも一般的な術語ではない。

コラムの訳：
「
Proof by Star Induction - Star Induction による証明

変数 x の car と cdr の上の帰納法で、主張Cを証明するためには、

``(if (atom x) C (if C_car (if (C_cdr) C 't) 't)``

を証明せよ。ここで、``C_car`` は ``C`` の ``x`` を``(car C)`` で置き換えたもので、``C_cdr`` は ``C`` の ``x`` を ``(cdr C)`` で置き換えたものである。
」

もう少しわかりやすくいうと、
(1) (atom x) として、C を証明する。
(2) C_car と C_cdr が成り立つと仮定して（帰納法の仮定）、C を証明する。


## Star Induction の適用 (CH7.10)。

``C(y)`` ≡

```lisp:
(if (ctx? x)
    (if (ctx? y)
        (equal (ctx? (sub x y)) 't)
        't)
    't)
```

として、Star Induction を適用する。``x``でなく``y``に対して帰納法を適用することに注意してください。


## ``ctx?/t``補題が必要であることの説明 (CH7.14-19)

前提``(ctx? x)``が成り立つときに、そのif-Aにある``(ctx? x)``を``'t``に書き換えてよいようにみえる。

コラムの訳：
「
Insight: Create Helpers for Induction - ヒント：帰納のヘルパーを作る。

再帰関数の適用を書き直すには、帰納を使って再帰関数に関する別の定理を証明せよ。

現在の証明が、以下のどれかの場合は、これを行え。

- 帰納を使用しない。
- （同じ関数の from the function）別の種類の再帰の帰納を使用する。
- （同じ関数適用の from the application）異なる引数で帰納を使用する。

」


# 補題 ctx?/t の証明 (CH7.30-40)。

## 命題 ctx?/t (CH7.31)

```lisp:
(dethm ctx?/t (x)
       (if (ctx? x)
           (equal (ctx? x) 't)
           't))
```

## Star Induction の適用 (CH7.31)。

``C(y)`` ≡

```lisp:
(if (ctx? x)
    (equal (ctx? x) 't)
    't))
```

これも、star induction で証明する。``x``に対して帰納法を適用する。

```lisp:
(if (atom x)
    (if (ctx? x)
        (equal (ctx? x) 't)
        't)
    (if (if (ctx? (car x))
            (equal (ctx? (car x)) 't)
            't)
        (if (if (ctx? (cdr x))
            (equal (ctx? (cdr x)) 't)
            't)
            (if (ctx? x)
                (equal (ctx? x) 't)
                't)
            't)
        't))
```

もう少しわかりやすくいうと、
(1) ``(atom x)`` が成立するとして、

```lisp:
(if (ctx? x)
    (equal (ctx? x) 't)
    't)
```

を証明する。

(2) 帰納法の仮定

```lisp:
(if (ctx? (car x))
    (equal (ctx? (car x)) 't)
    't)
```

と

```lisp:
(if (ctx? (cdr x))
    (equal (ctx? (cdr x)) 't)
    't)
```

を前提として、

```lisp:
(if (ctx? x)
    (equal (ctx? x) 't)
    't)
```

を証明する。

## サブゴール(1)の証明 CH7.32-34

### CH7.32

``(atom x)`` を前提とし、2箇所ある``(ctx? x)``をフォーカスにして、公理``if-nest-A``を適用する。ただし、``ctx?`` はその定義で展開することで、``(if (atom x) (equal x '?) ...)`` なので、それを使う。

``if-nest-A``は``(dethm if-nest-A (x y z) (if x (equal (if x y z) y) 't))``で、フォーカスはif-A節にあるので、``(if (atom x) (equal x '?) ...)`` は、2箇所とも``(equal x '?)``と書き換えられる。

### CH7.33

``(equal x '?)`` を前提、``x``をフォーカスとして、公理``equal-if``を使用して``'?``と書き換える。

### CH7.34

```lisp:
(if (equal x '?)
    (equal (equal '? '?) 't) 't)
```
をフォーカスにして、

公理``equal-same``を2回、公理``if-same``を1回使用して、``'t``と書き換える。

以上で、サブゴール(1)は証明できた。


## サブゴール(2)の証明 CH7.35-39

### CH7.35

``(atom x)`` を前提とし、2箇所ある``(ctx? x)``をフォーカスにして、公理``if-nest-E``を適用する。ただし、``ctx?`` はその定義で展開することで、以下なので、それを使う。（CH7.32 で if-nest-Aを使ったことに対応する。）

```lisp:
    (if (atom x)
       ...
       (if (ctx? (car x))
           't
           (ctx? (cdr x))))
```

### CH7.36

p.67 の ``if Lifting`` を使う。これはif-Qをフォーカスの外に出すことである。CH7.36左のフォーカスを抜き出す。

```lisp:
(if (if (ctx? (car x))
        (equal (ctx? (car x)) 't)
        't)
    ...
    't)
```

これが ``if Lifting`` によって、

```lisp:
(if (ctx? (car x))
    (if (equal (ctx? (car x)) 't)
        ...          ;; A
        't)
    (if 't
        ...          ;; E
        't))
```

となる。``(if 't ... 't)`` は``...``になるので、

```lisp:
(if (ctx? (car x))
    (if (equal (ctx? (car x)) 't)
        ...          ;; A
        't)
    ...              ;; E
```


``...`` の部分は以下である。

```lisp::
        (if (if (ctx? (cdr x))
                (equal (ctx? (cdr x)) 't)
                't)
            (if (if (ctx? (car x))
                    't
                    (ctx? (cdr x)))
                (equal (if (ctx? (car x))
                           't
                           (ctx? (cdr x)))
                       't)
                't)
            't)
```

Aに入る部分は、``(ctx? (car x))``が``'t``なので、公理``if-true``ほかで、以下のようになる。

```lisp::
        (if (if (ctx? (cdr x))
                (equal (ctx? (cdr x)) 't)
                't)
            't
            't)
```

Eに入る部分は、``(ctx? (car x))``が``'()``なので、公理``if-false``ほかで、以下のようになる。

```lisp::
        (if (if (ctx? (cdr x))
                (equal (ctx? (cdr x)) 't)
                't)
            (if (ctx? (cdr x))
                (equal (ctx? (cdr x)) 't)
                't)
            't)
```

全体をあわせると、CH7.36右のフォーカスの部分になる。

```lisp:
(if (ctx? (car x))
    (if (equal (ctx? (car x)) 't)
        (if (if (ctx? (cdr x))
                (equal (ctx? (cdr x)) 't)
                't)
            't
            't)
        't)
    (if (if (ctx? (cdr x))
            (equal (ctx? (cdr x)) 't)
            't)
        (if (ctx? (cdr x))
            (equal (ctx? (cdr x)) 't)
            't)
        't))
```

### CH.7.37

公理``if-same``を3回適用すると、フォーカス全体が``'t``になる。


### CH7.38

``if Lifting`` を使う。

CH7.38左のフォーカスを抜き出す。

```lisp:
(if (if (ctx? (cdr x))
        (equal (ctx? (cdr x)) 't)
        't)
    ...
    't)
```

これが ``if Lifting`` によって、

```lisp:
(if (ctx? (cdr x))
    (if (equal (ctx? (cdr x)) 't)
        ...               ;; A
        't)
    (if 't
        ...               ;; E
        't))
```

となる。``(if 't ... 't)`` は``...``になるので、

```lisp:
(if (ctx? (cdr x))
    (if (equal (ctx? (cdr x)) 't)
        ...               ;; A
        't)
    ...)                  ;; E
```

``...`` の部分は以下である。

```lisp::
        (if (ctx? (cdr x))
            (equal (ctx? (cdr x)) 't)
            't)
```

Aに入る部分は、``(ctx? (cdr x))``が``'t``なので、

```lisp::
        (equal (ctx? (cdr x)) 't)
```

Eに入る部分は、``(ctx? (cdr x))``が``'()``なので、

```lisp::
        't
```

全体を合わせると、

```lisp:
(if (ctx? (cdr x))
    (if (equal (ctx? (cdr x)) 't)
        (equal (ctx? (cdr x)) 't)
        't)
    't)
```

となり、CH7.38右のフォーカスの部分となる。


### CH7.39

if-Qの``(equal (ctx? (cdr x))``を前提として、そのif-Aの``(ctx? (cdr x))``をフォーカスして、公理``equal-if``を適用して、``'t``に書き換える。つまり``(equal (ctx? (cdr x)) 't)``が``(equal 't 't)``になる。

さらに、公理``equal-same``を適用すると、``'t``になる。
最後に、公理``if-same``を4回適用すると、全体が``'t``になる。

以上で、サブゴール(2)は証明できた。Q.E.D.

**以上**
