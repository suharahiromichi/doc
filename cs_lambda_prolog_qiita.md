λProlog (Lambada Prolog) の紹介
========================

@suharahiromichi

2021/11/06


# はじめに

λProlog[1]は高階のHereditary Harrop式の自動証明を原理にするProlog言語です。
これに対して、一般的なProlog言語（SWI-Prologなど　DEC-10 Prologの子孫）は、第1階のHorn節のかたちの論理式の自動証明を原理にしています。これに伴い、DEC-10 Prologと比べて、以下の特長があります。

1. 述語や関数に型が書ける。ただし、省略してもよい。
2. 高階の述語が書ける。DEC-10 Prologではcall述語やbagof述語があるが、計算原理に基づくものではない。
3. Horn節を拡張した、Hereditary Harrop式が書ける。上位互換なので、Horn節だけでも書ける。
4. ``p(x,f(y))`` ではなく、``p x (f x)`` の関数型言語風の表記である。

4を除いて、DEC-10 Prologとの互換性は考慮されているようです。appendとかは同じように動きます。

また、最近(2017年）から、定理証明支援系 Coq[11][34] や Matita[12] の拡張用言語として採用され、処理系（EPLI : Embeddable Lambda Prolog Interpreter) [31][32][33] が実装され公開されています。そのため、これらの定理証明系が使い続けられる限り、処理系は保守されるのではないかと予想されます。

本資料は、すでにPrologプログラミングについての知識を前提にして、処理系EPLIをインストールして動かすまでの説明をします。
λPrologの言語仕様については、とても解りやすいページ[2]と書籍[3]があるので、ごく簡単な説明にとどめます。

# λPrologについて

## 名前について

``λProlog`` が正式のようですが、

- Lambda Prolog
- lambda Prolog
- lProlog

という表記もあります。Twitterのハッシュタグでも ``#λProlog``, ``#LambdaProlog``, ``#lambdaProlog``　が使われているようです。そもそもツイートはごくわずかですが。

## 処理系

λPrologは言語の名前であり、実装は複数あります。

- Teyjus [21]
- ELPI [31][32]
- Markam　[41]
- 早稲田大学上田研のLMNtalで実装されたサブセット　[51]

Teyjusが一般的な実装とされていて、ELPIとTeyjusの違いは[35]にまとめられています。
ELPIは次章で説明します。
[51]の実装は公開されていないようですが、論文の2章でλPrologの言語仕様が説明されています。

# λProlog言語

言語仕様については、解りやすい[2]と、より詳しく知りたい場合書籍[3]を参照してください。ここでは、DEC-10 Prologを知っていることを前提に、間違いやすい点を説明します。
大文字と小文字、``_`` の使い方は DEC-10 Prologと同じですが、次節でしめす binding operator で束縛する変数は大文字で小文字でも区別はありません。
どちらであっても binding operator のスコープの外には影響しません。

本資料では、説明のために、任意の式(formula)を表すために、A, G, D という文字を使用します。


## 型システム

kind と type が定義でき、以下で定義できます。<type expression> には、変数を使うことができます。

- ``kind <kind id> <kind expression>``
- ``type <type id> <type expression>``


## 例：リストとreverse 述語の定義

```
kind list       type -> type.
type cons       A -> list A -> list A.
type reverse    list A -> list A -> o.
```

述語(formula)は ``o`` で終わります。このときの「->」は、入出力 (i/o) をしめすわけではありません。
i/oを規程する場合は以下のようにします。

```
pred reverse    i:list A, o:list A.
```

## binding operator

「λ x : τ.  G」を binding operator ``\`` を使用して ``x : τ \ G`` と書きます。ここで ``: τ`` は型注釈であり省略できます。
binding operator の優先順位（結合度）は、次節にしめす``,``、``;``や``:-``、``=>`` のシグネチャより低く、``sigma``や``pi``より高いことに注意してください。
ただじ、本資料では、誤解を咲けるために、冗長に括弧``()``をつける場合があります。


## シグネチャ

- ``:-`` に加えて、逆をしめす``=>``が使えます。論文などで数学記号として書く場合は「⇐」と「⊃」を使います。
両者は向きが違うだけで同じように使用できますが、本資料では、説明を単純にするために ``=>`` は使わないようにします。

- 全称をしめす``pi``と、存在をしめす``sigma``が導入されます。binding operatorと併用して使います。
数学記号として書く場合は「∀」と「∃」を使いますが、「λ」を省略した普通の書き方をするようです。

``pi (x \ G)`` は、「∀x.G」 です。


## Hereditary Harrop式

Hereditary Harrop Formula は、Horn Clauseの拡張です。HarropとHornは人名。

``D :- G``

において、``G``に ``G :- D`` と ``sigma (x \ G)`` 「∀x.G x」 が書けるようになります。


## 例1

全称記号を大文字の変数に置き換える例。

- 数学記号
  ``∀x.[p(X) ⇐ ∀y.[q(x), r(y,x)]]``

これは``:-``の右側の``G``に全称があるため、Horn節では表せませんが、Hereditary Harrop式なら表すことができます。

- piとbinding operatorを使う。
  ``sigma (x \ (p x :- (sigma (y \ (q y, r y x)))))``

- 不要な括弧を省く。
  ``sigma x \ p x :- sigma y \ q y, r y x``

抽象化によって明示的にバインドされていないトークンは、大文字で始まる場合は変数と見なされます。（中略）それらが出現する節全体にわたって全称記号であると見なされます。(PwHOL p.46)

- 大文字の変数にして、sigmaを削除する。もちろん束縛された変数が同じなら削除できません。
  ``p X :- q Y, r Y X``

結局、DEC-10 Prologの表記と同じになります。

- DEC-10 Prolog
  ``p(X) :- q(Y), r(Y, X)``


## 例2

``P ⇐ (Q ⇐ R)''

これは``:-``の右側の``G``に``:-``があるため、Horn節では表せませんが、Hereditary Harrop式なら表すことができます。``(Q :- R)`` の括弧は省くことはできません。

``P :- (Q :- R)``

これは、直感的には次の意味になります。

```
R.
P :- Q
```

ただし、Rが有効になる(assertされる)のは、``P :- (Q :- R)`` が選択されたタイミングです。


## λスクエア

$\require{AMScd}$

```math
\begin{CD}
FOHH @>>> HOHH \\
@AAA      @AAA \\
HOHC @>>> HOHC
\end{CD}
```


# 文献

## λProlog

[1] "λProlog: Logic programming in higher-order logic", [http://www.lix.polytechnique.fr/Labo/Dale.Miller/lProlog]
[2] Chelsea Corvus, "Programming with Higher-Order Logic", [https://chelsea.lol/pwhol]
[3] Dale Miller and Gopalan Nadathur, "Programming with Higher-Order Logic", [https://sites.google.com/site/proghol] PwHOL

# 定理証明支援系

[11] "The Coq Proof Assistant", [https://coq.inria.fr]
[12] "Matita", [http://matita.cs.unibo.it/]

# Teyjus

[21] Teyjus, [https://github.com/teyjus/teyjus]
[22] Teyjus Manual, [https://github.com/teyjus/teyjus/wiki/TeyjusManual]

# ELPI

[31] Enrico Tassi, "Elpi: an extension language for Coq”, [https://hal.inria.fr/hal-01637063/document]
[32] ELPI, [https://github.com/LPCIC/elpi/blob/master/ELPI.md]
[33] coq-elpi, [https://github.com/LPCIC/coq-elpi]
[34] Algebra Tactics, [https://github.com/math-comp/algebra-tactics]
[35] "Known incompatibilities with Teyjus",[https://github.com/LPCIC/elpi/blob/master/INCOMPATIBILITIES.md]

# Markam

[41] Markam, [http://astampoulis.github.io/makam]

# 上田研

[51] Alimujiang Yasen, Kazunori Ueda, "Implementing a subset of Lambda Prolog in HyperLMNtal", [http://jssst.or.jp/files/user/taikai/2014/PPL/PPL6-4.pdf]
