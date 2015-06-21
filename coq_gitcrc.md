"A Gentle Introduction to Type Classes and Relations in Coq" の読み方
======

2014/12/20 @suharahiromichi

2015/ 6/21 @suharahiromichi


# 文書の在処

http://www.labri.fr/perso/casteran/CoqArt/TypeClassesTut/typeclassestut.pdf


# サンプルコードのインストール

http://www.labri.fr/perso/casteran/CoqArt/TypeClassesTut/
から自分のCoqのバージョンにあわせたアーカイブををダウンロードして展開する。
typeclassesTut というディレクトリができる。

Coq veversion 8.4 でコンパイルする手順は以下である。
（version 8.4pl2 で確認）

- ``cd typeclassesTut``

- 以下の修正をする。

(1) ``cp V8.3/Matrics.v Mat.v``

(1') Section名をMatに修正する。

(2) Makefileの ``_CoqProject`` のエントリをコメントアウトする。

- make

BSD系UNIXの場合は、GNU Make (gmake) を使用すること。


# 本文とサンプルコードの対応

全体にサンプルコードのほうが、より多くの事項を扱っているようだ。

| 章節    | 表題                              |  サンプルソース      |   | 補足  |
|:--------|:---------------------------------|:----------------------|:---------|:------|
| 2.1	  | A Monomorphic Introduction       | Power_mono.v	|               |       |
| 2.2	  | On Monoids	                     | Monoid_prog.v 	| Monoid.v	|       |
| 2.2.1   | Classes and Instances	     | Monoid_prog.v 	| Monoid.v	|       |
| 2.2.2   | A generic deﬁnition of power     | Monoid_prog.v 	| Monoid.v	|       |
| 2.2.3   | Instance Resolution	             | Monoid_prog.v 	| Monoid.v	|       |
| 2.2.4	  | More Monoids	             | Mat.v		| |             |
| 2.2.4.1 | Matrices over some ring	     | Mat.v		| |             |
| 2.3	  | Reasoning within a Type Class    | Monoid_prog.v 	| Monoid.v      |  1.   |
| 2.3.1   | The Equivalence Proof	     | Monoid_prog.v 	| Monoid.v	|       |
| 2.3.2   | Some Useful Lemmas About power   | Monoid_prog.v 	| Monoid.v	|       |
| 2.3.3   | Final Steps	                     | Monoid_prog.v 	| Monoid.v	|       |
| 2.3.4   | Discharging the Context	     | Monoid_prog.v 	| Monoid.v	|       |
| 2.3.5   | Subclasses	                     | Monoid_prog.v 	| Monoid.v	|       |
| 3.1	  | Introduction: Lost in Manhattan  | Lost_in_NY.v 		| |     |
| 3.2	  | Data Types and Deﬁnitions	     | Lost_in_NY.v 		| |     |
| 3.3	  | Route Semantics	             | Lost_in_NY.v 		| |     |
| 3.4	  | On Route Equivalence	     | Lost_in_NY.v 		| |     |
| 3.5	  | Proper Functions	             | Lost_in_NY.v 		| |     |
| 3.6	  | Some Other instances of Proper   | Lost_in_NY.v 		| |     |
| 3.7	  | Deciding Route Equivalence	     | Lost_in_NY.v 		| |     |
| 3.8	  | Monoids and Setoids	             | Lost_in_NY.v 		| |     |
| 	  | (Class EMonoid)	             | EMonoid.v	| Monoid_op_classes.v |2.|
| 	  | (Fixpoint Epower)	             | EMonoid.v	| Monoid_op_classes.v |2.|
| 	  | (Abelian_EMonoid)	             | EMonoid.v	| |	              |
| 3.9	  | Advanced Features of Type Classes           | | |			      |
| 3.9.1   | Alternate deﬁnitions of the class Monoid	| | |		              |
| 3.9.2	  | Operational Type Classes	     | Monoid_op_classes.v | |		      |
| 3.9.3   | Instance Resolution	             | Monoid_op_classes.v | |		      |

1. Monoid.vはFunction版である。この以外の節で内容は重複している。
2. 内容はほぼ重複している。


# 本文の正誤表

1. Class Monoid の定義 (p.5)。unitをoneに置き換える。


# ProofCafe で使った資料

## 本文2.1〜2.3.4 Classes and Instances
### ProofCafeの資料
https://github.com/suharahiromichi/coq/blob/master/gitcrc/coq_gitcrc_2_Monoid.v

### 概要
- モノイドクラス。その上で、power関数を定義する。
- Implicit generalization
- ``binary_power_ok : forall (x:A) (n:nat), binary_power x n = x ** n`` を証明する。

## 本文3.1〜3.6 Lost in Manhattan

### ProofCafeの資料
https://github.com/suharahiromichi/coq/blob/master/gitcrc/coq_gitcrc_3_digest.v

### 概要
- ルートの同値関係(=r=)を定義する。
- ルートの同値関係(=r=)の上で、rewrite や reflexivity をする。
- Proper, ``==>``
- consのtailをrewriteする。appendの一部をrewriteする。


## 本文3.7 Deciding Route Equivalence
### ProofCafeの資料
https://github.com/suharahiromichi/coq/blob/master/gitcrc/coq_gitcrc_3_7_digest.v
https://github.com/suharahiromichi/coq/blob/master/gitcrc/ssr_gitcrc_3.v

### 概要
- 計算による同値の証明
- ``East::North::West::South::East::nil =r= East::nil`` を証明する。

## 本文3.8 Monoids and Setoids
### ProofCafeの資料
https://github.com/suharahiromichi/coq/blob/master/gitcrc/coq_gitcrc_3_8_EMonoid.v

### 概要
- Equivalence
- ``E_rel :> Equivalence E_eq`` は、
E_rel は、``EMonoid _ _ _ _`` から ``Equivalence E_eq`` へのコアーションであるということ。
つまり、EMonoid が 同値関係を Equivalenceから継承することを示す。
- EMonoid の インスタンスとしての route を定義する。

## 本文3.9.1 Alternate deﬁnitions of the class Monoid
### 概要
- 台(carrier)や演算子、単位元などをclassのfieldに書く方法。
- あまり勧められない。


## 本文3.9.2 Operational Type Classes (前半)
### ProofCafeの資料
https://github.com/suharahiromichi/coq/blob/master/gitcrc/coq_gitcrc_3_9_2_operational_type_classes.v

### 概要
- operational type class


## 本文3.9.2 (後半）Class SemiRing
### ProofCafeの資料
https://github.com/suharahiromichi/coq/blob/master/gitcrc/coq_gitcrc_3_9_2_2_semi_ring.v
https://github.com/suharahiromichi/coq/blob/master/gitcrc/coq_gitcrc_3_9_2_2_semi_ring_simple.v
https://github.com/suharahiromichi/coq/blob/master/gitcrc/ssr_gitcrc_3_9_22_semi_ring.v

### 概要
- Hintデータベースへの追加 (Typeclasses Transparent)
- 半環(semiring)の定義
- (補足) semiring のインスタンスを作ってみる。




## 本文3.9.3 Instance Resolution
### ProofCafeの資料
https://github.com/suharahiromichi/coq/blob/master/gitcrc/coq_gitcrc_3_9_2_operational_type_classes.v
(最後の「優先順位」の部分)

### 概要
- インスタンスの優先順位の指定する。
- 例：monoid_binop Z のインスタンスである Z_plus_op と Z_mult_op の優先順位によって、結果が変わる。
- 指定なければ、複雑なものが優先される。


# 参考

ProofCafeの中で参考にさせていただいたページを以下に示します。ありがとうございました。

- Coq で Setoid を作る。 http://mathink.net/program/coq_setoid.html
- Setoid の Proper な Map を作る。 http://mathink.net/program/coq_map.html
- 代数的構造と Coq：序 http://mathink.net/program/coq_group.html

- Coq Reference Manual, Chapter 19  Type Classes
https://coq.inria.fr/distrib/current/refman/Reference-Manual022.html

(章の移動でリンクがずれている可能性があります。ご注意ください）

- First-Class Type Classes
http://www.pps.univ-paris-diderot.fr/~sozeau/research/publications/First-Class_Type_Classes.pdf

以上
