"The Little Prover" 参考訳
=======================

2016_05_25 @suharahiromichi

# コラムの訳

## Chapter 1

### The Law of Dethm (initial) - Dethm の規則 (導入)

任意の定理 (detm name (x_1 ... x_n) body_x) について、 body_x の中
の変数 x_1 ... x_n を対応する式 e_1 ... e_n に置き換える。

その結果の body_e が、 (equal p q) または (equal q p) であるとき、フォー
カス（された）pをqになるように書き換えることができる。

## Chapter 2

### The Law of Dethm (initial) - Dethm の規則 (決定)

任意の定理 (detm name (x_1 ... x_n) body_x) について、 body_x の中
の変数 x_1 ... x_n を対応する式 e_1 ... e_n に置き換える。

その結果の body_e は、焦点を次のように書き換えることができる。
- body_e は、結論に (equal p q) または (equal q p) を含まなければならず、
- その結論は、任意の``if``のquestionか、任意の関数適用の引数になければならず、
- もし、結論が``if``のanswer(もしくはelse)にあるとき、
焦点は``if``のanswer(もしくはelse)になければならない。


## Chapter 3

### Insight: Skip Irrelevent Expressions - ヒント：無関係な式をスキップする。

主張を 't に書き換えることは、特定の順番で行う必要はない。
式のいくつかの部分は完全にスキップされるかもしれない。
例えば、if-same は、多くの``if``式を``if``questionによらず、`tに簡略化
できる。


## Chapter 5

### Insight: Rewrite form the Inside Out - ヒント：内から外への書き換え。

- ひとつの式の書き換えを``if``answer、``if``elseまたは関数引数の内側か
ら始めて外側に向かっておこなう。
- 関数に適用される引数をできるだけ簡略化し、関数の適用を関数の本体で置
き換えるためにDefunの規則を適用する。
- ``if``questionを、要すれば、前提を必要とする定理を使って書き換える。
- 内側の式が簡略化できなければ、外側の式に進む。


### If Lifiting - ``if``のもちあげ

- ひとつの``if``questionを焦点の内側から焦点の外側に移動するために、x
を``if``questionとし、yを焦点全体として、if-same を使う。これは、新し
い``if``のanswerとelseの中の焦点をコピーする。

- それから、if-nest-A と if-nest-E を新しい``if``のanswerとelseの中の
  同じquestionを使って、それぞれの``if``取り除くために使う。


### Insight: Pulls Ifs Outward - ヒント：``if``を外側に引っ張り出す。

``if``が関数の引数、または、``if``questionにあるとき、``if``の持ち上げ
を使う。``if``を関数適用と``if``questionの外側に持ち上げる。


### Insight: Keep Theorems in Mind - ヒント：定理をこころに留めておく。

既存の定理、とりわけ公理をこころに留めておく。現在の主張がいくつかの定
理で書き換えることのできるひとつの式を含むとき、その定理を使うことを試みよ。

現在の主張がいくつかの定理で書き換えることのできるひとつの式 *の部分*
を含むとき、その部分を残しておいて、現在の主張をその定理で書き換えるこ
とを試みよ。




# 訳語対応表

| 英語       | 訳          | 備考         |
|:-----------|:------------|:-------------|
| premise    | 前提        | |
| conclusion | 結論        | |
| focus      | 焦点        | フォーカス |
| intuition  | 直観        | |
| claim      | 主張        | |
| total      | 全域的      | 全域関数 |
| partial    | 部分的      | 部分関数 |
| measure    | 測度        | |

** 以上 **
