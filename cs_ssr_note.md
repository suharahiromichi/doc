SSReflectノート (暫定版)
========
2014/04/27 @suharahiromichi

章節番号とページは、"No 6455 A Small Sscale Reflection Extension for the Coq System" の該当箇所を示す。

# CheatSheet以前

## tactic の意味

| 例                   | ゴール H->G のとき。                       | ゴール forall x, G のとき。 |
|:---------------------|:------------------------------------------|:---------------------------|
| move.                | なにもしない。「=>」や「:」と組み合わせる。 | 同左                        |
| apply.               | Hを適用する。                             |                            |
| exact.               | by apply.                                 |                           |
| case.                | Hで場合わけする。                          | xで場合わけする。          |
| elim.                | Hに対して帰納法を使う。                    | xに対して帰納法を使う。    |

1. H->G1->G2なら、(G1->G2)にHを…する。H->(G1->G2)であるため。
1. byは証明を閉じる（現在のsubgoalの証明を終了できなければ、エラーにする）。
1. by t1; t2. は by (t1; t2). の意味である。

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

1. xやyにhole(placeholder)のあるときは、成立しない。


## moveとrewriteは「分配」できる

| 例                   | 意味                              | 備考            |
|:---------------------|:---------------------------------|:----------------|
| move=> a b c.        | move=> a; move=> b; move=> c.    | move: a b c で戻る。 |
| move: a b c.         | move: c; move: b; move: a.       | 逆順になる。     |
| rewrite p q r        | rewrite p; rewrite q; rewrite r  |                 |

例外として、clear-switchのとき「:」は付かない。
```Coq
move: x {y}.
move: x; move {y}.
move: x; clear y.
```


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

例3
```Coq
move=> [|[]].
move=> []; last move=> [].
move=> []; [| move=> []].
case; last case.
case; [| case].
```


# Introduction

| 例                   | 意味                   | 備考                             |
|:---------------------|:----------------------|:---------------------------------|
| move=> a.            | intro a.              |                                  |
| move=> ->.           | intor a; rewrite a; clear a.  | (1.)                     |
| move=> //.           | try done.             |                                  |
| move=> /=.           | simpl.                |                                  |
| move=> //=.          | simpl; try done.      |                                  |
| move=> {H}//.        | (clear-switch)        | 5.4 p.23 (Hも使い、Hを消す。)     | 
| move=> /V.           | move/V.               | 5.4 p.23 (最後)、9.9　            |
| move=> -.            | move.                 | 9.9 (なにもしない、NO-OP)         |

1. 対象をその順番で指定するには、occ-switch(例：{2})を使う。


# Discharge

| 例                   | 意味                   | 備考                             |
|:---------------------|:----------------------|:---------------------------------|
| move: x.             | revert x.             | xをclearする。(1.)                |
| move: (x).           | generalize x.         | xを消さずに残す。(1.)         |
| move: {+}x.          | generalize x.         | xを消さずに残す。(1.)         |
| move H.              | Hは、option item      | 5.5 p.25  (要確認)                    |
| case H.              | Hは、option item      | 5.5 p.25  (要確認)                    |
| case: y/x.           | y/は、type families   | 5.5 p.26  (要確認)                    |

1. 対象をその順番で指定するには、occ-switch(例：{2})を使う。


# rewrite

| 例                   | 意味                   | 備考                             |
|:---------------------|:----------------------|:---------------------------------|
| rewrite /t.          | unfold t.             |                                  |
| rewrite //.          | try done.             |                                  |
| rewrite /=.          | simpl.                |                                  |
| rewrite //=.         | somple; try done.     |                                  |
| rewrite (s, t, u).   |                       | 順番に試す。                      |
| rewrite -[x]/y.      | change x with y.      | p.37、これはこのかたちで覚える。   |
| rewrite (_: a=b).    | replace (_ : a=b).    | あとでa=bの証明をする。           |
| cutrewrite (a=b).    | replace a with b.     | あとでa=bの証明をする。           |
| rewrite -t.          | (方向)                | 逆方向へ書き換える。(1.)          |
| rewrite 3!t.         | (回数)                | 3回だけ書き換える。(1.)           |
| rewrite !t.          |                       | 1回以上書き換える。(1.)           |
| rewrite ?t.          |                       | 0回以上書き換える。(1.)           |
| rewrite 3?t.         |                       | 3回以下書き換える。(1.)           |
| rewrite {2}t.        | (occ-switch)          | {2}はocc-switch。(1.)            |
| rewrite [m]t.        | (contextual-pattern)  | 8. p.44 (マッチした箇所を) (1.)   |
| rewrite {}H.         | rewrite H; clear H.   | {}は occ-switchではない。        |

1. 方向、回数、occ-switch、contextual-pattern の順番で指定すること。

# Views

| 例                   | 意味                                | 備考                |
|:---------------------|:-----------------------------------|:--------------------|
| move/V.              | H->GのHをReflectする。              |                    |
| case/V.              | move/V; case.                      | (2.)               |
| elim/V.              | move/V; elim.                      | (2.)               |
| elim/V.              | intro x; elim x using V; clear x.  | standard Coq の場合 |
| elim/V: x => a.      | elim x using V; clear x; intro a.  | standard Coq の場合 |
| apply/V.             | H->GのGをReflectする。              |                    |
| apply/Vl/Vr.         | 左右を示すふたつ。                  | 9.5 p.55 (1.)       |

1. apply/idP/idP は、ゴール x=y を x->y と y->x にする。

1. case/Vとelim/Vの場合は、以下はすべて同じになる。apply/Vは駄目である。
```Coq
case/V: x y => a b.
move: x y; case/V; move=> a b.
move: x y; move/V; case; move=> a b.
move/V: x y; case; move=> a b.
```

case=>[]と、move=>[]が同じことから、合わせ技で、以下もすべて同じになる。
```Coq
case/V => [l m].
case/V; move=> [l m].
move/V; case=> [l m].
move/V; move=> [l m].
move/V => [l m].
```

# Control flow

## Selector

| 例                   | 意味                | 備考                |
|:---------------------|:-------------------|:--------------------|
| first                |                    | 6.3 p.29            |
| last                 |                    | 6.3 p.29            |
| [t1  &#124;t2]       | first t1; last t2  | byやdoが付くと、選択ではなく、tryの意味になる。 |

## Iteration

| 例                    | 意味                  | 備考                             |
|:----------------------|:---------------------|:---------------------------------|
| do    [t1 &#124; t2 &#124; t3]. | (回数指定)            | 1回だけt1,t2,t3のどれかを試す。   |
| do 3! [t1 &#124; t2 &#124; t3]. |                      | 3回だけt1,t2,t3のどれかを試す。   |
| do !  [t1 &#124; t2 &#124; t3]. |                      | 1回以上t1,t2,t3のどれかを試す。   |
| do ?  [t1 &#124; t2 &#124; t3]. |                      | 0回以上t1,t2,t3のどれかを試す。   |
| do 3? [t1 &#124; t2 &#124; t3]. |                      | 3回以下t1,t2,t3のどれかを試す。   |

## Localisation

| 例                   | 意味                             | 備考                    |
|:---------------------|:--------------------------------|:------------------------|
|  tactic in *.        | tactic.                         | ゴールに適用する。       |
|  tactic in H.        |                                 | 前提Hに適用する。        |
|  tactic in H *.      |                                 | ゴールと前提Hに適用する。 |

# Structure

| 例                         | 意味                                   | 備考                    |
|:---------------------------|:---------------------------------------|:-----------------------|
| have: t.                   | assert t.                              | (1.) (2.)              |
| have H : t.                | have: t => H.                          | Hには場合分け[&#124;]も書ける。 |
| have H : t by tactics.     | have: t; first by tactics. move=> H.   | 6.6 p.32               |
| have H := t.               | move: t => H                           | 6.6 p.33 (3.)          |
| suff                       |                                        | 6.6 p.33               |
| wlong:                     |                                        | 6.6 p.33               |

1. have:t は現在のゴールにtをpushするとともに、新しいゴールをtにする。 assert t は新しいゴールtだけ。
2. have:の後に括弧が要らない。assertの後には括弧が要る。
3. have:の後にはひとつだけ。move:の後には括弧が要るが、複数書ける。直接証明を与える。

# Gallinaの拡張
## Gallinaの拡張

| 例                                       | 意味                                                    | 備考                      |
|:-----------------------------------------|:--------------------------------------------------------|:-------------------------|
| let: p      := t1 in t2.                 | match t1          with p      => t2 end.                |                          |
| let: p as i := t1 return t in t2.        | match t1 return t with p as i => t2 end.                | iはpの別名、tはt2とt3の型 |
| if t1 is p               then t2 else t3 | match t1          with p      => t2 &#124; _ => t3 end  |                          |
| if t1 is p as i return t then t2 else t3 | match t1 return t with p as i => t2 &#124; _ => t3 end  | iはpの別名、tはt2とt3の型 |
| pose t := x.                             |                                                         | 4.1 p.12                 |
| set t := x.                              |                                                         | 4.2 p.13                 |

## Inductive

以下はどれも同じ。3.4 p.12
```Coq
Inductive list (A : Type) : Type :=
| nil
| cons of A & list A.

Inductive list' (A : Type) : Type :=
| nil' : list' A
| cons' of A & list' A : list' A.

Inductive list'' (A : Type) : Type :=
| nil'' : list'' A
| cons'' : A -> list'' A -> list'' A.

Inductive list''' (A : Type) : Type :=
| nil''' : list''' A
| cons''' (x : A) (l : list''' A) : list''' A.
```

以上

https://wri.pe/app#0mpqDaG/edit
