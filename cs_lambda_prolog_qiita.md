λProlog (Lambada Prolog) の紹介
========================

@suharahiromichi

2021/11/06


# はじめに

λPrologは高階のHereditary Harrop式の自動証明を原理にするProlog言語です。
これに対して、一般的なProlog言語（SWI-Prolog [1] など　DEC-10 Prologの子孫）は、第1階のHorn節のかたちの論理式の自動証明を原理にしています。これに伴い、DEC-10 Prologと比べて、以下の特長があります。

1. 述語や関数に型が書ける。ただし、省略してもよい。
2. 高階の述語が書ける。DEC-10 Prologではcall述語やbagof述語があるが、計算原理に基づくものではない。
3. Horn節を拡張した、Hereditary Harrop式が書ける。上位互換なので、Horn節だけでも書ける。
4. ``p(x,f(y))`` ではなく、``p x (f x)`` の関数型言語風の表記である。

4を除いて、DEC-10 Prologとの互換性は考慮されているようです。appendとかは同じように動きます。

また、最近(2017年）から、定理証明支援系 Coq[2] や Matita[3] の拡張用言語として採用され、処理系（EPLI　： Embeddable Lambda Prolog Interpreter)が実装され公開されています。そのため、これらの定理証明系が使い続けられる限り、処理系は保守されるのではないかと予想されます。

本資料は、すでにPrologプログラミングについての知識を前提にして、処理系EPLIをインストールして動かすまでの説明をします。
λPrologの言語仕様については、とても解りやすいページ[6]と書籍[7]があるので、ごく簡単な説明にとどめます。

# λPrologについて

## 名前について

``λProlog`` が正式のようですが、

- Lambda Prolog
- lambda Prolog
- lProlog

という表記もあります。Twitterのハッシュタグでも ``#λProlog``, ``#LambdaProlog``, ``#lambdaProlog``　が使われているようです。そもそもツイートはごくわずかですが。

## 処理系

λPrologは言語の名前であり、実装は複数あります。

- Teyjus [8]
- ELPI
- Makam　[9]
- 早稲田大学上田研のLMNtalで実装されたサブセット　[11]

Teyjusが一般的な実装とされていて、ELPIとTeyjusの違いは[10]にまとめられています。
ELPIは次章で説明します。
[11]の実装は公開されていないようですが、論文の2章でλPrologの言語仕様が説明されています。

# λProlog言語

言語仕様については、解りやすい[6]と、より詳しく知りたい場合書籍[7]を参照してください。ここでは、DEC-10 Prologを知っていることを前提に、間違いやすい点を説明します。
大文字と小文字、``_`` の使い方は DEC-10 Prologと同じですが、次節でしめす binding operator で束縛する変数は大文字で小文字でも区別はありません。
どちらであっても binding operator のスコープの外には影響しません。

本資料では、説明のために、任意の式(formula)を表すために、A, G, D という文字を使用します。

## binding operator

「λ x : τ.  G」を binding operator ``\`` を使用して ``x : τ \ G`` と書きます。ここで ``: τ`` は型注釈であり省略できます。
binding operator の優先順位（結合度）は、次節にしめす``,``、``;``や``:-``、``=>`` のシグネチャより低く、``sigma``や``pi``より高いことに注意してください。
ただじ、本資料では、誤解を咲けるために、冗長に括弧``()``をつける場合があります。


## 型システム

kind と type が定義でき、以下で定義できます。<type expression> には、変数を使うことができます。

- ``kind <kind id> <kind expression>``
- ``type <type id> <type expression>``


例：リストとreverse 述語は以下で定義されます。

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


## シグネチャ

- ``:-`` に加えて、逆をしめす``=>``が使えます。論文などで数学記号として書く場合は「⇐」と「⊃」を使います。
両者は向きが違うだけで同じように使用できますが、本資料では、説明を単純にするために ``=>`` は使わないようにします。

- 全称をしめす``pi``と、存在をしめす``sigma``が導入されます。binding operatorと併用して使います。
数学記号として書く場合は「∀」と「∃」を使いますが、「λ」を省略した普通の書き方をするようです。

``pi (x \ G)`` は、「∀x.G」の意味です。

- 数学記号
  ``∀x.[p(X) ⇐ ∀y.[q(x), r(y,x)]]``

- DEC-10 Prolog
  ``p(X) :- q(Y), r(Y, X)``

- piとbinding operatorを使う。
  ``sigma (x \ (p x :- (sigma (y \ (q y, r y x)))))``

- 不要な括弧を省く。
  ``sigma x \ p x :- sigma y \ q y, r y x``

- piとbinding operatorを使わない。
  ``p X :- q Y, r Y X``





## Hereditary Harrop式

Hereditary Harrop Formula は、Horn Clauseの拡張です。HarropとHornは人名。

``D :- G``

において、``G``に ``G :- D`` と ``sigma (x \ G)`` 「∀x.G x」 が書けるようになります。

説明を補足すること。


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

[1] Enrico Tassi, "Elpi: an extension language for Coq”, [https://hal.inria.fr/hal-01637063/document]

[6] Chelsea Corvus, "Programming with Higher-Order Logic", [https://chelsea.lol/pwhol]

[8] Teyjus, [https://github.com/teyjus/teyjus]
[8] Teyjus Manual, [https://github.com/teyjus/teyjus/wiki/TeyjusManual]
[9] Markam, [http://astampoulis.github.io/makam/]

[10] "Known incompatibilities with Teyjus",[https://github.com/LPCIC/elpi/blob/master/INCOMPATIBILITIES.md]

[11] Alimujiang Yasen, Kazunori Ueda, "Implementing a subset of Lambda Prolog in HyperLMNtal", [http://jssst.or.jp/files/user/taikai/2014/PPL/PPL6-4.pdf]

