SSReflectノート
========
2014/03/02 @suharahiromichi

# 基本のキ (CheatSheet以前)

## moveとrewriteは分配できる。

| 例                   | 意味                              | 備考            |
|:---------------------|:---------------------------------|:----------------|
| move=> a b c.        | move=> a; move=> b; move=> c.    |                 |
| move: x y z.         | move: x; move: y; move: z.       |                 |
| rewrite p q r        | rewrite p; rewrite q; rewrite r  |                 |

## 「:」と「=>」はmoveを略した書き方。

| 例                   | 意味                              | 備考                  |
|:---------------------|:---------------------------------|:----------------------|
| apply: x y => a b    | move: x y; apply; move=> a b     |                       |
| exact: x y => a b    | move: x y; exact; move=> a b     |                       |
| case:  x y => a b    | move: x y; case;  move=> a b     |                       |
| elim: x y => a b     | move: x y; elim;  move=> a b     |                       |
| apply/V: x y => a b  | move: x y; apply/V; move=> a b   | Viewを指定しても同じ。 |


## move=>[]と、caseの関係。

| 例                   | 意味                              | 備考                  |
|:---------------------|:---------------------------------|:----------------------|
| case=> [].           | move=> [].                       |                       |
| case=> [].           | case.                            |                       |
| case=> [l m n].      | move=> [l m n].                  |                       |
| case=> [l m n].      | case=> l m n.                    | 「move=> l m n」ではない。|
| move=> [l m n].      | move=> [] l m n.                 | move=> []; move=> l m n. |
| move=> [l m n].      | case; move=> l m n.              | case=> []; move=> l m n. |

以下はすべて同じになる。

例1
```Coq
case=> [l m].
move=> [l m].
move=> []; move=> l m.
case; move=> l m.
case=> l m.
```

例2
```Coq
move=> [[l m] n].
move=> [] [l m] n.
move=> [] [] l m n.
move=> []; move=> []; move=> l m n.
case; case; move=> l m n.
case; case=> l m n.
```

# Introduction

| 例                   | 意味                   | 備考                             |
|:---------------------|:----------------------|:---------------------------------|
| move=> a.            | intro a.              |                                  |
| move=> ->.           | intor a; rewrite a; clear a.  | (†)                     |
| move=> //.           | try done.             |                                  |
| move=> /=.           | simpl.                |                                  |
| move=> //=.          | simpl; try done.      |                                  |
| move=> {H}//.        | (clear-switch)        | 5.4 p.23 (Hも使い、Hを消す。)     | 
| move=> /V.           | view                  | 5.3 p.23 (一番最後)               |

(†) 対象が一意に決定できないときは、occ-switch(例：{2})を使う。


# Discharge

| 例                   | 意味                   | 備考                             |
|:---------------------|:----------------------|:---------------------------------|
| move: x.             | revert x.             | (†)                             |
| move: (x).           | generalize x.         | (†)                             |
| move: {+}x.          | generalize x.         | (†)                             |
| move H.              | Hは、Hは、option item | 5.5 p.25                         |
| case H.              | Hは、Hは、option item | 5.5 p.25                         |
| case: y/x.           | y/は、type families   | 5.5 p.26                         |

(†) 対象が一意に決定できないときは、occ-switch(例：{2})を使う。


# rewrite

| 例                   | 意味                   | 備考                             |
|:---------------------|:----------------------|:---------------------------------|
| rewrite /t.          | unfold t.             |                                  |
| rewrite //.          | try done.             |                                  |
| rewrite /=.          | simpl.                |                                  |
| rewrite //=.         | somple; try done.     |                                  |
| rewrite (s, t, u).   |                       | 順番に試す。                      |
| rewrite -[x]y.       | change x with y.      |                                  |
| rewrite (_: a=b).    | replace (_ : a=b).    | あとでa=bの証明をする。           |
| cutrewrite (a=b).    | replace a with b.     | あとでa=bの証明をする。           |
| rewrite -t.          | (方向)                | 逆方向へ書き換える。(‡)          |
| rewrite 3!t.         | (回数)                | 3回だけ書き換える。(‡)           |
| rewrite !t.          |                       | 1回以上書き換える。(‡)           |
| rewrite ?t.          |                       | 0回以上書き換える。(‡)           |
| rewrite 3?t.         |                       | 3回以下書き換える。(‡)           |
| rewrite {2}t.        | (occ-switch)          | {2}はocc-switch。(‡)            |
| rewrite [m]t.        | (contextual-pattern)  | 8. p.44 (マッチした箇所を) (‡)   |

(‡) 方向、回数、occ-switch、contextual-pattern の順番で指定すること。

# Views

| 例                   | 意味                                | 備考                |
|:---------------------|:-----------------------------------|:--------------------|
| move/V.              | H->GのHをReflectして、move          |                    |
| move/V: x => a.      | move: x => a /V.                   | 5.3 p.23 (一番最後) |
| case/V.              | H->GのHをReflectして、case          |                    |
| elim/V.              | H->GのHをReflectして、elim          |                    |
| elim/V.              | intro x; elim x using V; clear x.  | standard Coq の場合 |
| elim/V: x => a.      | elim x using V; clear x; intro a.  | standard Coq の場合 |
| apply/V.             | H->GのGをReflectして、apply         |                    |
| apply/Vl/Vr.         | 左右を示すふたつ。                  | 9.5 p.55           |

# Control flow

## Selector

   first
   last

## Iteration

| 例                    | 意味                  | 備考                             |
|:----------------------|:---------------------|:---------------------------------|
| do    [t1 &#0x7C; t2 &#0x7C; t3]. |                      | 1回だけt1,t2,t3のどれかを試す。   |
| do 3! [t1 &#0x7C; t2 &#0x7C; t3]. |                      | 3回だけt1,t2,t3のどれかを試す。   |
| do !  [t1 &#0x7C; t2 &#0x7C; t3]. |                      | 1回以上t1,t2,t3のどれかを試す。   |
| do ?  [t1 &#0x7C; t2 &#0x7C; t3]. |                      | 0回以上t1,t2,t3のどれかを試す。   |
| do 3? [t1 &#0x7C; t2 &#0x7C; t3]. |                      | 3回以下t1,t2,t3のどれかを試す。   |
\ 「&#0x7C;」は縦棒。

## Localisation

| 例                   | 意味                             | 備考                    |
|:---------------------|:--------------------------------|:------------------------|
|  tactic in *.        | tactic.                         | ゴールに適用する。       |
|  tactic in H.        |                                 | 前提Hに適用する。        |
|  tactic in H *.      |                                 | ゴールと前提Hに適用する。 |

# Structure (haveとwlog)

# Gallinaの拡張

以上
