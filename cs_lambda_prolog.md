λProlog についての情報

# 表記

- Lambda Prolog

- λProlog

- lambda Prolog (lは小文字)

- lProlog

- #LambdaProlog (ハッシュタグ)


# 文書

## Wikipedia

- [https://ja.wikipedia.org/wiki/論理プログラミング]

- [https://en.wikipedia.org/wiki/ΛProlog]
- [https://en.wikipedia.org/wiki/%CE%9BProlog]


## Home Page

- λProlog: Logic programming in higher-order logic

[http://www.lix.polytechnique.fr/Labo/Dale.Miller/lProlog/]

λPrologは、A.Church の単純型理論のスタイルの高階直観主義論理に基づく
論理プログラミング言語です。 このような強力な論理的基盤は、モジュラー
プログラミング、抽象データ型、高階プログラミング、および構文内の束縛変
数の処理に対するλ-tree syntaxアプローチの論理的にサポートされた概念を
λPrologに提供します。 λPrologの実装には、単純に型指定されたλ項と
（サブセット）高階統一のサポートが含まれています。 その結果、λProlog
は、高次抽象構文（HOAS）を直接サポートする最初のプログラミング言語です。


- λ-tree syntax

[http://www.lix.polytechnique.fr/Labo/Dale.Miller/papers/mmr-final.pdf]


- A Tutorial on Lambda Prolog and its Applications to Theorem Proving

[http://www.lix.polytechnique.fr/~dale/lProlog/felty-tutorial-lprolog97.pdf]



## 文書

- Programming with Higher-Order Logic

[https://sites.google.com/site/proghol/]

highly recommended


- Hi! I'm Chelsea Corvus

[https://chelsea.lol/pwhol/] とても解りやすい解説


- 上田研による実装の論文

[http://jssst.or.jp/files/user/taikai/2014/PPL/PPL6-4.pdf] 2章に言語の概説がある。



## 処理系

実装は複数ある。

### Teyjus

[https://github.com/teyjus/teyjus] メイン実装とされるが、開発は停止しているかも。

[https://github.com/teyjus/teyjus/wiki/TeyjusManual] リファレンスマニュアル。


### Markam

[http://astampoulis.github.io/makam/]


### ELPI (Embeddable λProlog Interpreter)

（次節）


# ELPI

[https://github.com/LPCIC/elpi] CoqとMatitaのプラグインとして使える。


## 解説

- Extensions to λProlog implemented in ELPI

[https://github.com/LPCIC/elpi/blob/master/ELPI.md]

- TeyjusとELPIとの違い

[https://github.com/LPCIC/elpi/blob/master/INCOMPATIBILITIES.md]

- ML風言語の型推論（ELPIのサンプルコード）

[https://github.com/gares/mlws18/tree/master/toyml]


## Coq

- Coq のプラグイン

[https://github.com/LPCIC/coq-elpi]

- Algebra Tactics

[https://github.com/math-comp/algebra-tactics]


## Matita

[http://matita.cs.unibo.it/]

以上
