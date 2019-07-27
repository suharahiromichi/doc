SSReflectノート (暫定版)
========
2014/04/27 @suharahiromichi
2014/04/27 @suharahiromichi、Qiitaに投稿。曖昧な箇所を削除した。
2014/12/20 @suharahiromichi、追記。Viewについての記述を訂正した。

章節番号とページは、No 6455 "A Small Sscale Reflection Extension for the Coq System" の該当箇所を示す。

# CheatSheet以前の事項

## tactic の意味

| 例                   | ゴール H->G のとき。                       | ゴール forall x, G のとき。 |
|:---------------------|:------------------------------------------|:---------------------------|
| move.                | なにもしない。「=>」や「:」と組み合わせる。 | 同左                        |
| apply.               | Hを適用する。                             |                            |
| exact.               | by apply.                                 |                           |
| case.                | Hで場合わけする。                          | xで場合わけする。          |
| elim.                | Hに対して帰納法を使う。                    | xに対して帰納法を使う。    |

1. H->G1->G2なら、(G1->G2)にHを…する。H->(G1->G2)であるため。


## 「tactic: x => a」は、「move: x; tactic; move=> a」

| 例                   | 意味                              | 備考                  |
|:---------------------|:---------------------------------|:----------------------|
| apply: x y => a b    | move: x y; apply; move=> a b     |                   |
| exact: x y => a b    | move: x y; exact; move=> a b     |                   |
| case: x y => a b     | move: x y; case;  move=> a b     |                       |
| elim: x y => a b     | move: x y; elim;  move=> a b     |                       |
| move/V: x y => a b   | move: x y; move/V; move=> a b    | Viewを指定しても同じ。 |
| apply/V: x y => a b  | move: x y; apply/V; move=> a b   | Viewを指定しても同じ。 |
| rewrite p q => a b   | rewrite p q; move=> a b          | 「:」のないtactic全て。 |




## moveとrewriteは「分配」できる

| 例                   | 意味                              | 備考            |
|:---------------------|:---------------------------------|:----------------|
| move=> a b c.        | move=> a; move=> b; move=> c.    | move: a b c で戻る。 |
| move: a b c.         | move: c; move: b; move: a.       | 逆順になる。     |
| rewrite p q r        | rewrite p; rewrite q; rewrite r  |                 |


## move=>[]と、caseの関係

| 例                   | 意味                              | 備考                  |
|:---------------------|:---------------------------------|:----------------------|
| case=> [].           | move=> [].                       |                       |
| case=> [].           | case.                            |                       |
| case=> [l m n].      | move=> [l m n].                  |                       |
| case=> [l m n].      | case=> l m n.                    | 「move=> l m n」ではない。|
| move=> [l m n].      | move=> [] l m n.                 | move=> []; move=> l m n. |
| move=> [l m n].      | case; move=> l m n.              | case=> []; move=> l m n. |
| move=> [l&#124;m].        | move=> []; first move=> l; last move=> m. |                 |
| move=> [l&#124;m].        | move=> []; [move=> l&#124; move=> m]. |                       |

以下の例はそれぞれ同じになる。

例1. 以下の5者はおなじ結果になる。

```
case=> [l m].
move=> [l m].
move=> []; move=> l m.
case; move=> l m.
case=> l m.
```

例2. 以下の6者はおなじ結果になる。

```
move=> [[l m] n].
move=> [] [l m] n.
move=> [] [] l m n.
move=> []; move=> []; move=> l m n.
case; case; move=> l m n.
case; case=> l m n.
```

例3. 以下の5者はおなじ結果になる。

```
move=> [|[]].
move=> []; last move=> [].
move=> []; [| move=> []].
case; last case.
case; [| case].
```


# Introduction (i-item)

| 例                   | 意味                   | 備考                             |
|:---------------------|:----------------------|:---------------------------------|
| move=> a.            | intro a.              |                                  |
| move=> ->.           | intro a; rewrite a; clear a.      |                      |
| move=> {2}->.        | intro a; rewrite {2}a; clear a.   | occ-switch          |
| move=> <-.           | intro a; rewrite -a; clear a.     |                      |
| move=> {2}<-.        | intro a; rewrite -{2}a; clear a.  | occ-switch          |
| move=> //.           | try done.             |                                  |
| move=> /=.           | simpl.                |                                  |
| move=> //=.          | simpl; try done.      |                                  |
| move=> {a}.          | intro a; clear a.     | clear-switch  |
| move=> /V.           | move/V.               | 5.4 p.23 (最後)、9.9　            |
| move=> -.            | move.                 | 9.9 (なにもしない)           |


# Discharge (d-item)

| 例                   | 意味                   | 備考                             |
|:---------------------|:----------------------|:---------------------------------|
| move: x.             | revert x.             | xをpushする。xをclearする。      |
| move: {2}x.          | ゴールの2番めのxをgeneralizeする。| occ-switch            |
| move: {-2}x.         | ゴールの2番め以外のxをgeneralizeする。| occ-switch            |
| move: {+}x.          | generalize x.         | xをpushする。xを消さずに残す。        |
| move: (x).           | generalize x.         | xをpushする。xを消さずに残す。        |
| move: {x}(c).        | move: (c); clear x    | clear-switch (後で clear x)  (1.)   |
| move: (c){x}.        | clear x; move: (c)    | clear-switch (先に clear x)  (2.)    |

1. move: (c); move {x} と同じ。。。
2. move {x}; move: (c) と同じ。。。

# rewrite (r-step)

| 例                   | 意味                   | 備考                             |
|:---------------------|:----------------------|:---------------------------------|
| rewrite /t.          | unfold t.             |                                  |
| rewrite //.          | try done.             |                                  |
| rewrite /=.          | simpl.                |                                  |
| rewrite //=.         | somple; try done.     |                                  |
| rewrite (s, t, u).   |                       | 順番に試す。                      |
| rewrite -[x]/y.      | change x with y.      | p.37。(4.)                       |
| rewrite (_: a=b).    | replace a with b.    | あとでa=bの証明をする。(2.)       |
| rewrite -t.          | (方向)                | 逆方向へ書き換える。(1.)          |
| rewrite 3!t.         | (回数)                | 3回だけ書き換える。(1.)           |
| rewrite !t.          |                       | 1回以上書き換える。(1.)           |
| rewrite ?t.          |                       | 0回以上書き換える。(1.)           |
| rewrite 3?t.         |                       | 3回以下書き換える。(1.)           |
| rewrite {2}t. | (occ-switch) | 2番めの箇所を書き換える。(1.) |
| rewrite {-2}t. | (occ-switch) | 2番めの箇所以外を書き換える。(1.) |
| rewrite [m]t.        | (contextual-pattern)(3.) | mとマッチした全部を書き換える。 (1.)(5.)   |
| rewrite [X in m]t.   | (contextual-pattern)(3.) | mとマッチしたうちのXの全部を書き換える。 (1.)(6.)   |
| rewrite [in m]t.        | (contextual-pattern)(3.) | mとマッチした部分を書き換える。 (1.)(5.)   |
| rewrite [in X in m]t.   | (contextual-pattern)(3.) | mとマッチしたうちのXの部分を書き換える。 (1.)(6.)   |
| rewrite {}H.         | rewrite H; clear H.   | {}は occ-switchではない。        |

1. 方向、回数、occ-switch、contextual-pattern の順番で指定すること。
2. cutrewrite (a=b). と replace (_ : a=b).  でも同じ。
3. r-pattern (c-patternも含む)。
4. rewrite -[ term1 ]/ term2. is equivalent to: change term1 with term.
If term2 is a single constant and term1 head symbol is not term2 , then the head symbol
of term1 is repeatedly unfolded until term2 appears.

5. mは``_``を含んでもよい。8. p.44
6. Xは変数名(ident)で、mのなかに出現すること。8. p.44

# ident

| 例                   | 意味                               | 備考         |
|:---------------------|:----------------------------------|:-------------|
| move H : (t) => h.   | 仮定 H : t = h を導入する。 　　　　 |              |
| case H : t.          | 仮定 H に場合わけの条件を保存する。  |               |


# congr

ゴールが等式のとき、等式を複数のゴールに分解する。f_equalと同じだが、分解のパターンを明示する必要がある。

例：``congr (_ + _).``


# Views

| 例                   | 意味                                      | 備考                |
|:---------------------|:-----------------------------------------|:--------------------|
| case/V.              | intro H; case H using V.           |  9.1 p.47 |
| elim/V.              | intro H; induction H using V.       |  9.1 p.47 | 
| apply/V.             | apply V.                           | ゴール全体を書き換える。ゴールが△->○の場合はその全体が対象になる(注) 。 |
| move/V.              | intro H; apply V in H; apply H.    | ゴールが「△->○」のとき、△の部分（スタックトップ）を書き換える(注)。  |
| move/V.              | move=>H; move: (V H); move=> {H}.  | (注)
| move/(_ 0).          | move=> H; move: (H 0); move=> {H}.   | 「_」は、スタックトップを意味する。
| apply/V1/V2.         | apply/V1; apply/V2                 | 連続してapplyする。　|
| apply/idP/idP        | ゴールの A = B を A -> B と B -> A にする。 | 9.5 p.55 (1.)       |

(注) iffLRやelimTなどが自動的に補われること（View Hint）については、
http://qiita.com/suharahiromichi/items/02c7f42809f2d20ba11a
および、「An introduction to small scale reflection in Coq」の4章を参照のこと。

# Control flow

## Terminator

(未作成）

## Selector

(未作成）

## Iteration

| 例                    | 意味                  | 備考                             |
|:----------------------|:---------------------|:---------------------------------|
| do    [t1 &#124; t2 &#124; t3]. | (回数指定)            | 1回だけt1,t2,t3のどれかを試す。   |
| do 3! [t1 &#124; t2 &#124; t3]. |                      | 3回だけt1,t2,t3のどれかを試す。   |
| do !  [t1 &#124; t2 &#124; t3]. |                      | 1回以上t1,t2,t3のどれかを試す。   |
| do ?  [t1 &#124; t2 &#124; t3]. |                      | 0回以上t1,t2,t3のどれかを試す。   |
| do 3? [t1 &#124; t2 &#124; t3]. |                      | 3回以下t1,t2,t3のどれかを試す。   |

## Localisation

(未作成）

# Structure

| 例                         | 意味                                   | 備考                    |
|:---------------------------|:---------------------------------------|:-----------------------|
| have: t.                   | assert t.                              | (2.)                  |
| have H : t.                | have: t => H.                          | (1.)                   |
| have H : t by tactics.     | have: t; first by tactics. move=> H.   | 6.6 p.32               |
| have H := t.               | move: t => H                           | 直接証明を与える。6.6 p.33 (3.)   |

1. Hには、[ &#124; ] や、/V、 -> など、i-itemを書くことができる。
2. assertの後には括弧が要る。have:の後にはひとつの項しか書けない。
3. move:の後には括弧が要るが、複数の項を書ける。have:の後にはひとつの項しか書けない。

実行前が、 Γ ⊦ G である場合、

| 例                   | 実行後                                      | 備考          |
|:---------------------|:--------------------------------------------|:-----------------------|
| have H := t.         | Γ  H:t ⊦  G                                 | 直接与える。           |
| have H : P.          | Γ      ⊦  P,         Γ  H:P ⊦ G           | assert P as H.         |
| suff H : P.          | Γ  H:P ⊦  G,              Γ ⊦ P           | 6.6 p.33               |
| have suff H : P.     | Γ      ⊦ P->G,    Γ  H:P->G ⊦ G          |                       |
| suff have H : P.     | Γ  H:P ⊦  G,              Γ ⊦ (P->G)->G  | 6.6 p.34            |
| wlog H : / P.        | Γ      ⊦ (P->G)->G,  Γ  H:P ⊦ G          | 6.6 p.34            |
| wlog suff H : / P.   | Γ  H:P ⊦  G,              Γ ⊦  (P->G)->G  | suff have H : P.    |

# Gallinaの拡張

## match

| 例                                       | 意味                                                    | 備考                      |
|:-----------------------------------------|:--------------------------------------------------------|:-------------------------|
| let: p      := t1 in t2.                 | match t1          with p      => t2 end.                |                          |
| let: p as i := t1 return t in t2.        | match t1 return t with p as i => t2 end.                | iはpの別名、tはt2とt3の型 |
| if t1 is p               then t2 else t3 | match t1          with p      => t2 &#124; _ => t3 end  |                          |
| if t1 is p as i return t then t2 else t3 | match t1 return t with p as i => t2 &#124; _ => t3 end  | iはpの別名、tはt2とt3の型 |


## Inductive

以下はどれも同じ。3.4 p.12

```
Inductive list (A : Type) : Type :=
| nil
| cons of A & list A.
```

```
Inductive list (A : Type) : Type :=
| nil : list A
| cons of A & list A : list A.
```

```
Inductive list (A : Type) : Type :=
| nil : list A
| cons : A -> list A -> list A.
```

```
Inductive list (A : Type) : Type :=
| nil : list A
| cons (x : A) (l : list A) : list A.
```

# 参考文献

以下にタクティクのリファレンスとしても使える資料を列挙する。

1. No 6455 "A Small Sscale Reflection Extension for the Coq System",
   https://hal.inria.fr/file/index/docid/409356/filename/main.pdf
3. No. 367 "An Ssreflect Tutorial",
   https://hal.inria.fr/inria-00407778/file/RT-367.pdf
2. No 7392 "An introduction to small scale reflection in Coq",
   https://hal.inria.fr/inria-00515548/file/main-rr.pdf
4. "Programs and Proofs",
   http://ilyasergey.net/pnp/
5. "定理証明支援系Coq/SSReflect入門",
   https://staff.aist.go.jp/reynald.affeldt/ssrcoq/


以上
