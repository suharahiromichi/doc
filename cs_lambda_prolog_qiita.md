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

また、最近(2018年〜)、定理証明支援系 Coq[11][34] や Matita[12] の拡張用言語として採用され、処理系（EPLI : Embeddable Lambda Prolog Interpreter) [31][32][33] が実装され公開されています。そのため、これらの定理証明系が使い続けられる限り、処理系は保守されるのではないかと予想されます。

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
大文字と小文字、``_`` の使い方分けは DEC-10 Prologと同じですが、次節でしめす binding operator で束縛する変数は区別ありません。

本資料では、説明のために、任意の式(formula)を表すために、A, G, D という文字を使用します。

また、改行やインデントの制限はありませんが、プログラムやゴールの末尾は ``.`` で終わります。


## λスクエア

λPrologでは、以下の式(formula)を扱うことができます。

- 一階のHorn節   (FOHC)    First Order Horn Clause
- 高階のHorn節   (HOHC)    Higher Order Horn Clause
- 一階のHereditary Harrop式   (FOHH)  First Order Hereditary Harrop Formula
- 高階のHereditary Harrop式   (HOHH)  Higher Order Hereditary Harrop Formula

これは、図のようなスクエアをかたち作ります。

$\require{AMScd}$

```math
\begin{CD}
FOHH @>>> HOHH \\
@AAA      @AAA \\
HOHC @>>> HOHC
\end{CD}
```


## 型システム

定数の型をtypeキーワードで、型の型をkindキーワードで定義します。<type expression> には、変数として大文字から始まる名前を使うことができます。

- ``kind <kind id> <kind expression>``
- ``type <type id> <type expression>``

例：リストとreverse 述語の定義

```
kind    list     type -> type.
type    ons      A -> list A -> list A.
type	reverse  list A -> list A -> o.
type	rev	 list A -> list A -> list A -> o.

reverse L K :- rev L K nil.
rev nil L L.
rev (X :: L) K M :- rev L K (X :: M).
```

type reverse    list A -> list A -> o.
```

述語(formula)は ``o`` で終わります。このときの「->」は引数の入出力 (i/o) をしめすわけではありません。
i/oを規程する場合は以下のようにします。

```
pred reverse    i:list A, o:list A.
```

## 文法の拡張

Horn節の範囲ですが、関数型言語に置ける``λx.F``にあたる表記や、全称・存在の表記、``:-``の逆の表記が導入されています。

### binding operator

「λ x : τ.  G」を binding operator ``\`` を使用して ``x : τ \ G`` と書きます。ここで ``: τ`` は型注釈ですが省略できます。
binding operator の優先順位（結合度）は、``,``、``;``や``:-``、``=>`` のシグネチャより低く、次節にしめす``sigma``や``pi``より高いことに注意してください。
ただじ、本資料では、誤解を咲けるために、冗長に括弧``()``をつける場合があります。

### 全称(``pi``)と存在(``sigma``)

全称をしめす``pi``と、存在をしめす``sigma``が導入されます。binding operatorと併用して使います。
テキスト数学記号として書く場合は「∀」と「∃」を使いますが、「λ」を省略した普通の書き方をするようです。

``pi (x \ G)`` は、「∀x.G」 です。

DEC-10 Prolog で次の表記、これは当然FOHCですが、

``p(X, Z) :- q(X, Y), r(Y, Z).``

は、数学記号での表記は、

``∀x.∀y.∀z.(p(x,z) :- q(x, y) ∧ r(y, z)``

となります。λPrologで、piとbinding operatorを使うと、

``pi x \ pi y \ pi z \ (p x z :- q x y, r y z).``

となります。束縛変数の変数名は、大文字から始まる名前でも、小文字から始まる名前でも構いません。
名前としては区別されますが、``\`` の右側の式をスコープとする、という意味では同じです。

λPrologでは、FOHCの式に限り、変数名を大文字から始めることで、piなどを省略することができます。

``p x z :- q x y, r y z.``

と書くことができ、結局DEC-10 Prologと同じになります。


また、ゴールに書く式、

``p(X, Z).``

は、数学記号での表記は、

``∃a.p(42, a)``

は、

``sigma a \ (p 42 a).``

で、大文字から始まる名前にして、sigma を省略でき、

``p 42 A.``

と書けます。


### 含意 (``:-``の逆``=>``)

- ``:-`` に加えて、逆をしめす``=>``が使えます。テキストで数学記号として書く場合は「⇐」と「⊃」を使います。
両者は向きが違うだけで同じように使用できます。


## Hereditary Harrop式

Hereditary Harrop Formula は、Horn Clauseの拡張です。HarropとHornは人名です。

Prologのプログラムの節、「頭部 :- 尾部」

``D :- G.``

とすると、尾部``G``に入れ子にして、``G :- D`` や ``D => G`` を書くことができます。
また、尾部``G``に``pi (x \ G)``（∀x.G x） が書けるようになります。

これを応用すると、ローカル述語が定義できるようになります。これを Moduler Programming と呼ぶようです。

前節の``reverse``の定義では、``reserve``の中からしか使わない述語``rev``が定義されていました。revをreverseのローカルな述語とするには、以下のようにします。

```
kind    list    type -> type.
type    cons    A -> list A -> list A.
type    nil     list A.
type	reverse list A -> list A -> o.

reverse L K :-
        pi rev \ (
                    (
                        (pi l \
                            rev nil l l),
                        (pi x \ pi l \ pi k \ pi m \
                            (rev (cons x l) k m :- rev l k (cons x m)))
                    )
                 ) => rev L K nil.
```

これは、reverse述語の尾部に``=>``や``pi``があるため、Horn節ではないことが判ります。
reverseの定義の一番外側の全体は、大文字から始まる変数名``L``と``K``を使って、pi（∀）が省略されているこにも注意してください。
``pi l \ rev nil l l`` も``rev nil L2 L2``に変更できます。ただし、外側の``L``と重ならない変数名``L2``にします。
``pi x \ pi l \ pi k \ pi m \ ...`` の…の部分はFOHHでありFOHCでないので、大文字から始まる変数に直すことはできません。


## 高階述語


# ELPI の設置と実行




# Coq




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
