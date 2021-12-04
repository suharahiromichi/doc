λProlog (Lambada Prolog) の紹介
========================

@suharahiromichi

2021/12/05

# はじめに

λProlog[1]は高階のHereditary Harrop Formulaの自動証明を原理にするProlog言語です。これに対して、一般的なProlog言語（SWI-PrologなどのISO規格に準拠したProlog、以下ISO Prolog）は、第1階のHorn Clause（ホーン節）のかたちの論理式の自動証明を原理にしています。これに伴い、ISO Prologと比べて、以下の特長があります。

1. 述語や関数に型が書ける。
2. 高階の述語が書ける。ISO Prologではcall述語やbagof述語があるが、ad-hocで、計算原理に基づくものではない。
3. Horn Clauseを拡張した、Hereditary Harrop Formulaが書ける。後者は前者の上位互換なので、Horn Clauseだけでも書ける。
4. ``p(x,f(y))`` ではなく、``p x (f x)`` の関数型言語風の表記である。また、引数の数が違っても同じ述語としてみなされる。

4を除いて、ISO Prologとの互換性は考慮されているようです。member述語などは同じように動きます（ご安心ください）。

また、最近(2018年〜)、定理証明支援系 Coq[11] や Matita[12] の拡張用言語として採用され、処理系（ELPI : Embeddable Lambda Prolog Interpreter) [31] が実装され公開されています。そのため、これらの定理証明系が使い続けられる限り、処理系は保守されるのではないかと予想されます。

本資料は、基本的なPrologプログラミングについて少しの知識を前提にして、処理系ELPIをインストールして動かすまでの説明をします。λPrologの言語仕様については、とても解りやすいページ[2]と書籍[3]があるので、簡単な説明にとどめます。また、ELPI独自の拡張[32][33]についてもすこし触れます。CoqとELPIの連携については、文献[36]〜[36.3]を参照してください。

なお、ELPIは現時点でも開発が進んでおり、記述が古くなってしまっている場合があります。ご注意願います。


# λPrologについて

公式ホームページは[1]です。

## 名前について

``λProlog`` が正式のようですが、

- Lambda Prolog
- Lambda-Prolog
- lambda Prolog
- lProlog

という表記もあります。Twitterのハッシュタグでも ``#λProlog``, ``#LambdaProlog``, ``#lambdaProlog``　が使われているようです。そもそもツイートはごくわずかですが。

## 処理系

λPrologは言語の名前であり、実装は複数あります。

- Teyjus [21]
- ELPI [31]
- Markam　[41]
- 早稲田大学上田研のLMNtalで実装されたサブセット　[51]

Teyjusが一般的な実装とされていて、書籍[3]でも参照されています。ELPIの拡張機能やTeyjusの違いは[32]と[33]にまとめられています。ELPIは次章で説明します。[51]の実装は公開されていないようですが、論文の2章でλPrologの言語仕様が説明されています。

# λProlog言語

言語仕様については、解りやすい[2]と、より詳しく知りたい場合は書籍[3]を参照してください。ここでは、ISO Prologを知っていることを前提に、間違いやすい点を説明します。

- ISO Prologと同様に、述語や定数は小文字から初め、変数を大文字から始めます。ただし、いわゆるラムダ式で束縛する変数には区別ありません（binding operatorの項を参照してください）。
- ISO Prologと同様に、改行やインデントの制限はありません（オフサイドルールではない）。
- ISO Prologと同様に、節（正しくは formula と呼ぶ。次節参照）の末尾は``.``で終わります。
- ISO Prologと同様に、カットオペレータ（``!``）があります。
- ISO Prologと違って、オーカーチェックをしてくれます（注）。
- リストの表記はISO Prologと同じです。ただしELPIでは Coq と同じ表記（``::``) も使えます。
- ELPIの固有の拡張として、アンダースコアから始まる名前は変数ではなく、ワイルドカードとして扱われます。

(注) オーカーチェックとは、``f X = X`` を偽とする機能のことです。ISO Prologでは歴史的な理由でチェックしない（真になり、``f (f (f (f ...))) = X`` になる）のがディフォルト。


## Clause vs. Formula

C言語のような、文の終わりが``;``な言語では、``;``で終わる文法単位（通常一行に書く）を「文」と呼ぶわけです。翻って、ISO Prologのプログラムは Horn Cluaseの終わりを``.``で示します。このため、``.``で終わる文法単位（通常一行に書く）を"clause"や「節」と呼びます（注1）。

λPrologは、Horn Cluaseではなく、Hereditary Harrop Formulaなので、これは節とは呼べず（注2）"formula" と呼ぶことになります。これを「式」と呼ぶと紛らわしいので、困りますね。

（注1）Hone Clauseを略してClauseと呼ぶ感覚です。Hone ClauseもClauseなので間違いではないのですが。

（注2）Hereditary Harrop Formula は Horn Cluase のスーパーセットで、どの定義に照らしてもclauseではない。


## 扱える論理式

λPrologは、以下の論理式を扱うことができます。

- 一階のHorn Clause (FOHC : First Order Horn Clause)
- 高階のHorn Clause (HOHC : Higher Order Horn Clause)
- 一階のHereditary Harrop Formula (FOHH : First Order Hereditary Harrop Formula)
- 高階のHereditary Harrop Formula (HOHH : Higher Order Hereditary Harrop Formula)

これらサブ言語の関係は、図のような（キューブならぬ）スクエアをつくります。

$\require{AMScd}$

```math
\begin{CD}
FOHH @>>> HOHH \\
@AAA      @AAA \\
FOHC @>>> HOHC
\end{CD}
```


## 型システム

定数の型をtypeキーワードで、型の型をkindキーワードで定義します。
``<type expression>`` には、型変数として大文字から始まる名前を使うことができ、その``<type expression>``の中がスコープになります。型変数に宣言は要りません。

- ``kind <K> <kind expression>``
- ``type <T> <type expression>``

例1：リストとreverse 述語の定義 (reverse0.elpi)

```prolog
kind    list     type -> type.
type    cons      A -> list A -> list A.
type    nil       list A.

pred reverse0  o:list A, o:list A.
pred rev0      o:list A, o:list A, o:list A.

reverse0 L K :- rev0 L K nil.
rev0 nil L L :- !.
rev0 (cons X L) K M :- rev0 L K (cons X M).
```

``->``は右結合です。

述語の型宣言は、命題型(pred)を返すことを意味する、``-> o`` で終わります。しかし、その左側の引数については、入出力(i/o)を示してはいないことに注意してください。

なお、型の扱いは実装依存の部分もあり、ELPIではプログラムを最初にロードしたときに型チェックが走りエラーまたはワーニングが出ますが、実行時には型チェックは省略されるようです。
特にbinding operatorの型注釈（いわゆるラムダ変数の型指定）は無視されるようです。

``!`` については後述します。

## mode

λPrologの範囲を越えたELPIの拡張機能ですが、predキーワードによって、述語の引数のmode（入出力 i/o のどちらか)を指定できます。

inとoutの指定方法は、ISO Prologのmode指定とも異なり（詳細は略）、次の規則になっているようです。

in (``i:``) を指定した引数に対して、

- goal (呼び出し側) が、unboundの変数を含む場合は、fail になる。

- ただし、プログラム（呼び出され側）と goal (呼び出し側) のユニフィケーションで、どちらもunboundの変数同士だった場合はfailにならない。

out (``o:``) を指定した引数に対しては、制約がない（ディフォルト）ので、決められない場合は、outを指定して次のように書いておけばよいようです。

```prolog
prod reverse  o:list A, o:list A.
prod rv       o:list A, o:list A, o:list A.
```

本項はあとで補足します。


## 文法の拡張

FOHCの範囲でのλPrologのシンタックスは次のようになります。``<A>``はアトミックな論理式、``<T>``は型システムで定義した型、``<X>``は変数名とします。

```
<G> ::= true | <A> | <G1> , <G2> | <G1> ; <G2> | sigma <X> : <T> \ <G>

<D> ::= <A> | <A> :- <G> | <G> => <A> | pi <X> : <T> \ <D>
```

数学記号では、

```
<G> ::= T | <A> | <G1> ∧ <G2> | <G1> ∨ <G2> | ∃<T> <X>.<G>

<D> ::= <A> |  <A> ⊂ <G> | <G> ⊃ <A> | ∀<T> <X>.<D>
```

``<G>``を Goal Clause または 「頭部」、``<D>``をDefine Clause または「尾部」と呼びます。``<D>``を「.」で区切って並べたものがPrologのプログラムとなります。ISO Prolog と同じく、``,`` と ``;`` は右結合で、``,``のほうが優先度が高いです。

関数型言語に置ける``λx.F``にあたる表記や、全称・存在の表記、含意(⊂)の``:-``の逆向(⊃)の``=>``が追加になっています。

### binding operator

いわゆるラムダ式です。

「λ x : τ.  G」を binding operator ``\`` を使用して ``<X> : <T> \ <G>`` と書きます。ここで ``: <T>`` は型注釈です。変数``<X>``は、小文字から初めても大文字から初めて違いがありません。

binding operator の優先順位（結合度）は、``,``、``;``や``:-``、``=>`` のシグネチャより低く、次節にしめす``sigma``や``pi``より高いことに注意してください。ただじ、本資料では、誤解を咲けるために、冗長に括弧``()``をつける場合があります。

現時点のELPIでは、型注釈は省略でき、書いても無視されます。また、ELPIの拡張機能として、複数の変数を並べて書くこともできます。


### 全称(∀ ``pi``)と存在(∃ ``sigma``)

全称をしめす``pi``と、存在をしめす``sigma``が導入されます。正確にいうとHone Clauseではこれらを省略するのですが、省略しない書き方もできる、というべきでしょうか。なので、これだけで、Hone Clauseの表現できる範囲を越えることはありません。
必ずbinding operatorと併用して使います。テキストに数学記号として書く場合は「∀」と「∃」を使いますが、その場合はbinding operatorを使わない普通の書き方をするようです。すなわち、``pi (<X> \ <G>)`` は ``∀x.G`` です。

ちょっと面倒ですが、ISO PrologとλPrologで全称と存在記号を使った場合と使わない場合の表記の違いを説明します。

ISO Prolog でのの定義の式、これは当然FOHCですが、

``p(X, Z) :- q(X, Y), r(Y, Z).``

は、数学記号での表記は、

``∀x.∀y.∀z.(p(x,z) ⊂ q(x, y) ∧ r(y, z)``

となります。λPrologで、piとbinding operatorを使うと、

``pi x \ pi y \ pi z \ (p x z :- q x y, r y z).``

となります。束縛変数の変数名は、大文字から始まる名前でも、小文字から始まる名前でも構いません。名前としては区別されますが、``\`` の右側の式をスコープとする、という意味では同じです。
また、λPrologでは、FOHCの式に限り、変数名を大文字から始めることで、piなどを省略することができます。すると、

``p X Z :- q X Y, r Y Z.``

と書くことができ、結局ISO Prologと同じになります。


また、ISO Prologでゴールに書く式、

``p(X, Z).``

は、数学記号での表記は、

``∃a.p(42, a)``

は、λPrologでは、

``sigma a \ (p 42 a).``

で、大文字から始まる名前にして、sigma を省略できて、

``p 42 A.``

と書けます。


### 含意 (``:-``の逆``=>``)

``:-`` に加えて、逆をしめす``=>``が使えます。テキストで数学記号として書く場合は「⇐」と「⊃」を使います。両者は向きが違うだけで同じように使用できます。

``:-`` は左結合、``=>``は右結合で、``=>``のほうが優先度が高いです。


## Hereditary Harrop Formula

Hereditary Harrop Formula は、Horn Clauseの拡張です。HarropとHornは人名です。

```
<G> ::= (FOHC)とおなじ | <G> :- <D> | <D> => <G> | pi <X> : <T> \ <D>

<D> ::= (FOHC)とおなじ。
```

数学記号では、

```
<G> ::= (FOHC)とおなじ | <G> ⊂ <D> | <D> ⊃ <G> | ∀<T> <X>.<D>

<D> ::= (FOHC)とおなじ。
```

すなわち、尾部``G``に入れ子にして、``G :- D`` や ``D => G`` (D ⊃ G) を書くことができます。また、尾部``G``に``pi (x \ G)``（∀x.G x） が書けるようになります。
これを応用すると、ローカル述語が定義できるようになります。これを Moduler Programming と呼ぶようです。

前節の``reverse0``の定義では、``reserve``の中からしか使わない述語``rv``が定義されていました。rvをreverseのローカルな述語とするには、以下のようにします。
なお、この例は[3]を参考にしていますが、``reverse``の決定性を定義するためにカットオペレータを追加しています。
これがないと``reverse X [1,2]``に対して ``X = [2,1]``を求めることはできても、バックトラックして別解を求めようとすると無限再帰に陥ってしまいます。

また、この例では ELPI のlist型を使用することにして、型の定義を省略しています。

例2: ``reverse.elpi``

```prolog
pred    reverse  o:list A, o:list A.

reverse L K :-
        pi rv \ (
                   (rv nil K :- !),
                   (pi x \ pi n \ pi m \
                       (rv (x :: n) m :- rv n (x :: m)))
                ) => rv L nil.
```

これは、``reverse``述語の尾部に``=>``や``pi``があるため、Horn Clauseではないことが判ります。
``reverse``の定義の一番外側の全体は、大文字から始まる変数名``L``と``K``を使って、pi（∀）が省略されているこにも注意してください。
``pi x \ pi n \ pi m \ …`` の部分はFOHHでありFOHCでないので(注)、大文字から始まる変数に直すことはできません。
また、再帰の基底にあたる ``rv nil K`` で ``K`` を参照しているため、単純な書き換えでISO Prologに書き直すことができません。

(注) ``=>``の左辺の``<G>``のなかでの``pi …``の出現であるため。


## 高階述語

高階述語の扱いについては、とくに難しいことはありません。ただし、高階述語を受け取る引数の型を指定するときには、predキーワードではなく ``A -> o`` の書き方になります。

例3: ``sublist.elpi``

```prolog
pred    sublist	        i:(A -> o), i:list A, o:list A.
pred    flagged         i:A.
type    v, w, x, y, z   A.

sublist P (X :: L) (X :: K) :- P X, !, sublist P L K.
sublist P (_ :: L) K :- sublist P L K.
sublist _ nil nil.

flagged x.
flagged y.
flagged z.
```

# ELPI

ELPI固有の機能は[32]が解りやすいです。拡張機能のうち以下は既に説明しました。

- アンダースコア
- binding operatorで複数の変数が書ける
- 引数のmode、pred キーワード

これ以外にも、以下の機能がありますが、記事を改めたいとおもいます。

- Constraint    (制約プログラミング)
- Namespace


## インストール

インストールはOpamからおこなうのが簡単です。

```
% opam install elpi
```

## 実行

引数にソースコードのファイル名を指定して実行すれば、それを読み込んだうえで対話モードになります。

実行例は以下です。値を求めたい引数は、変数を示す大文字で指定します。ここでも末尾に``.``が要るので注意してください。

- 例2

```
% elpi reverse.elpi
goal> reverse [1, 2, 3] Y.
Success:
  Y = [3, 2, 1].
```

- 例2 (逆方向）

```
% elpi reverse.elpi
goal> reverse X [3, 2, 1].
Success:
  X = [1, 2, 3].
```

- 例3

```
% elpi sublist.elpi
goal> sublist flagged [v,x,w,y,z] X.
Success:
  X = [x, y, z]
```

このように、「成功」の文字とともに変数の値、すなわち解が示されます。実行する内容によっては、別解があることを示す``More?``が表示される場合があります。ここで``Y``を指定すると、この場でfailしたとみなされバックトラックが発生します。別解がなければ、もう解がないことを示す「失敗」で終了します。

```
More? (Y/n)
Y
Failure
```

場合によっては無限ループや無限バックトラックになる場合があるのでその場合は``Ctrl-C``で止めることができます。


## 開発

VSCodeとVimのシンタックスハイライトに対応しているようです。[31]を参照してください。Emascへの言及はありませんが、とりあえず prolog-mode でなんとかならないこともありません。


# Coq-ELPI

ELPI[31]は、λPrologをCoqの拡張言語（あるいはプラグイン用言語）として使うために[36]開発されました。その成果は[39]です。

Coq（Vernacular にというべきでしょうか) に、``Elpi`` コマンドが追加され、``*.v`` ファイルのなかにELPIのプログラムを書くことができるようになります。その中からCoqのコンテキストやゴールなどにアクセスすることができ、タクティクをELPIで書くことができます。

詳細は[38][38.1][38.2][38.3]と、そこから参照されているページを参照してください。


# 文献

速習したい場合は、λProlog [2]、ELPI [32]、Coq-ELPI [38] を順番で読むとよいです。

## λProlog

[1] "λProlog: Logic programming in higher-order logic", [http://www.lix.polytechnique.fr/Labo/Dale.Miller/lProlog]

[2] Chelsea Corvus, "Programming with Higher-Order Logic", [https://chelsea.lol/pwhol]
全般に解りやすい資料ですが、Logic Comparison のページの ``reverse L K`` の引用にミスがあります。本資料では修正してあります。

[3] Dale Miller and Gopalan Nadathur, PwHOL "Programming with Higher-Order Logic", [https://sites.google.com/site/proghol]

## 定理証明支援系

[11] "The Coq Proof Assistant", [https://coq.inria.fr]

[12] "Matita", [http://matita.cs.unibo.it/]

## Teyjus

[21] Teyjus, [https://github.com/teyjus/teyjus]

[22] Teyjus Manual, [https://github.com/teyjus/teyjus/wiki/TeyjusManual]

## ELPI

[31] ELPI, [https://github.com/LPCIC/elpi]

[32] "Extensions to λProlog implemented in ELPI", [https://github.com/LPCIC/elpi/blob/master/ELPI.md]

[33] "Known incompatibilities with Teyjus",[https://github.com/LPCIC/elpi/blob/master/INCOMPATIBILITIES.md]


## Coq-ELPI

[36] coq-elpi, [https://github.com/LPCIC/coq-elpi]

[37] Enrico Tassi, "Elpi: an extension language for Coq”, [https://hal.inria.fr/hal-01637063/document]

[38] Enrico Tassi, "Tutorial on the Elpi programming language", [https://lpcic.github.io/coq-elpi/tutorial_elpi_lang.html]

[38.1] Enrico Tassi, "Tutorial on the HOAS for Coq terms", [https://lpcic.github.io/coq-elpi/tutorial_coq_elpi_HOAS.html]

[38.2] Enrico Tassi, "Tutorial on Coq commands", [https://lpcic.github.io/coq-elpi/tutorial_coq_elpi_command.html]

[38.3] Enrico Tassi, "Tutorial on Coq tactics", [https://lpcic.github.io/coq-elpi/tutorial_coq_elpi_tactic.html]

[39] Algebra Tactics, [https://github.com/math-comp/algebra-tactics]


## Markam

[41] Markam, [http://astampoulis.github.io/makam]

## そのほか

[51] Alimujiang Yasen, Kazunori Ueda, "Implementing a subset of Lambda Prolog in HyperLMNtal", [http://jssst.or.jp/files/user/taikai/2014/PPL/PPL6-4.pdf]

以上
