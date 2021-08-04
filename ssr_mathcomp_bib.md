Coq/SSReflect/MathCompの資料

@suharahiromichi

2021/08/04

------------

# 君の名は？

Coq Proof Assistant の　SSReflect proof language の Mathematical Components というライブラリで、
全体を総称して Mathematical Components と呼ぶようです。
Mathematical Componentsの正式な略称は無いようですが、MathCompというのが使われるようです。

# 公式サイト

Mathematical Components
https://math-comp.github.io/

- ソースコードは以下からブラウスできます。これに勝る解説はありません。

math-comp/math-comp
https://github.com/math-comp/math-comp/tree/master/mathcomp


# 日本語情報
## 書籍

[OA18] 萩原学,　アフェルト・レナルド,
Coq/SSReflect/MathCompによる定理証明　- フリーソフトではじめる数学の形式化 森北出版

## 日本語解説サイト

- [OA18]に記載されていないノウハウがあるので一読を薦めます。Cheat Sheatもあります。

Coq/SSReflect/MathComp Tutorial
https://staff.aist.go.jp/reynald.affeldt/ssrcoq/


# 一次資料

- キモいとさえ言われるSSReflectの文法ですが、公式のユーザズマニュアルがあります。お勧め。

[GMT15] Georges Gonthier, Assia Mahboubi, Enrico Tassi
A Small Scale Reflection Extension for the Coq system
https://hal.inria.fr/inria-00258384v16/document


- MathComp の全容を解説した書籍で、MathCompのソースコードを読むための知識が得られます。
必読。

[MCB] Assia Mahboubi, Enrico Tassi
Mathematical Components (the Book)
https://math-comp.github.io/mcb/


- apply/V や move/V の View の説明が詳しいです。

[GM11] Georges Gonthier, Assia Mahboubi
An introduction to small scale reflection in Coq 
https://hal.inria.fr/inria-00515548v4/document

# MathComp ライブラリ

- MathCompライブラリの原理といえる``Packed Class``の説明です。お勧め。

Francois Garillot, Georges Gonthier, Assia Mahboubi, Laurence Rideau
Packaging mathematical structures
http://www.normalesup.org/~garillot/tphols09.pdf

- 同じく``Packed Class``の解説ですが、表題に反して内容は難しいです。

[MT13] Assia Mahboubi, Enrico Tassi
Canonical Structures for the working Coq user
https://hal.inria.fr/hal-00816703v1/document


# 解説書

- プログラムの証明よりの入門書ですが、ケーススタディとして分離論理まで扱っています。
MathCompのライブラリとしては自然数までで、（整数のような）高度な数学は出てきません。
ただし、Packed Classの型階層を定義する話題も取り上げられています（MathCompと命名規則が異なるのが惜しい）。

[PnP] Ilya Sergey
Programs and Proofs - Mechanizing Mathematics with Dependent Types
https://ilyasergey.net/pnp/pnp.pdf


# Coqと共通な話題

- βδι簡約をおこなう　simpl タクティクの説明です。お勧め。

Pierre Boutillier 
Simple simpl
https://hal.archives-ouvertes.fr/hal-00816918/document


- 有名なCoqの実践的な教科書ですが、第III部のLtacや``auto``タクティクの解説はMathCompにも適用できます。
たとえば、　``Hint Constructors`` は、MathCompの``done``や``by``でも有効です。

[CPDT] Adam Chlipala
Certified Programming with Dependent Types
http://adam.chlipala.net/cpdt/


# Qiita

- Qiita には記事がありますが、MathCompで（自然数でなく）整数を使うときに参考になる良記事です。

@junjihashimoto@github
整数を使った証明（整数精度のHaar変換）のトライアル
https://qiita.com/junjihashimoto@github/items/310d87e504ee79d691af

以上

