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
- body_e は、結論 (equal p q) または (equal q p) を含まなければならず、
- その結論は、任意の``if``のquestionか、任意の関数適用の引数であってはならず、
- もし、結論が``if``のanswer(もしくはelse)にあるとき、
焦点は``if``のanswer(もしくはelse)になければならず、
(body_eと書換え対象の文脈の) question は、同じでなければあらない。

  補足
  結論：conclusion。body_e = (if Q A T) の、A または Tのこと。
  焦点：forcus。書換えの対象となる部分。


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


## Chapter 6

### Insight: Don't Touch Inductive Premises - ヒント：帰納法の前提に触れてはならない。

帰納法の証明において、帰納法の前提を直接簡略化してはならない。確かに、
帰納法の前提が適用できるまで、式を書き換える。しばしば、帰納法の前提を
適用したあと、帰納法の証明はほぼ終了する。


### Insight: Build Up to Induction Gradually - 帰納を徐々に組立てていく。

空のリストに、ひとつの要素のリストついて、という具合に定理を証明するこ
とでリストの上での帰納法での証明を組み立てよ。一旦、これらの証明のパター
ンが明かになったら、帰納法による証明は同様である。


### Proof by List Induction - List Induction (リストの帰納法) による証明

リスト x 上の帰納法で主張Cを証明するためには、

(if (atom x) C (if C_cdr C '))

を証明せよ。ここで、C_cdr は C の x を (cdr C)で置き換えたものである。


## Chapter 7

### Proof by Star Induction - Star Induction による証明

変数 x の car と cdr の上の帰納法で、主張Cを証明するためには、

(if (atom C) C (if C_car (if (C_cdr) C 't) 't)

を証明せよ。ここで、C_car は C の x を (car C)で置き換えたもので、
C_cdr は C の x を (cdr C)で置き換えたものである。


### Insight: Combine Ifs - ヒント：``if``の組み合わせ

複数の ``if`` が同じ question にあるとき、``if``の持ち上げによって、そ
れらをひとつの``if``に組み合わせよ。それら``if``を任意の関数適用と
``if``questionの外側に持ち上げよ。


### Insight: Create Helpers for Induction - ヒント：帰納のヘルパーを作る。

再帰関数の適用を書き換えるとき、帰納を使って再帰関数についての分離された定理を証明せよ。

もし、現在の証明が帰納を使って証明できるかどうかでこれを行え。
その関数と異なった種類の再帰、その関数適用と異なった種類の引数


## Chapter 8

### Conjunction - 連言

式の連言 e_1 ... e_n が成立するには e_1, ..., e_n それぞれが true でな
ければならない。


- 0個の式の連言は 't 。

- 1個の式の連言は e_1 は e 。

- e_1 と e_2 の連言は もし e_2 が 't なら e_1、もし e_1 が 't なら e_2、
  さもなければ それは、(if e_1 e_2 'nil) である。

- 3個またはそれ以上の連言 e_1 e_2 ... e_n は、e_1 と 連言 e_2 ... e_n
  との連言である。


### Constructing Totality Claims - 全域的な主張の構成

関数 (defun name (x_1 ... x_n) body) が与えられ、測度が m であるとき、
body の部分式についての主張は ：

- 変数とクオットされたリテラルについては 't を使う。

- (if Q A E) ここで QとAとEについての主張がc_qとc_aとc_eであり、もし、
  c_a と c_e が同じなら、c_q と c_a の連言を使い、さもなければ、c_q と
  (if Q c_a c_e) の連言を使う。

- それ以外の任意の式 Eについて、Eのなかのそれぞれの再帰的な関数適用
  (name e_1 ... e_n) を考える。

  e_1 を x_1, ... e_n に置き換えることによる、mの中のx_nの再帰的な関数
  適用の測度 m_r を構成する。

  Eについての主張は、Eのなかの再帰的な関数適用のそれぞれについての (<
  m_r m) の連言である。

- name についての全域的な主張は、(natp m) と bodyについての主張との連
  言である。


## Chapter 9

### Inductive Premises - 帰納法の前提

主張 c と、再帰的な関数適用 (name e_1 ... e_n) と、変数 x_1 ... x_n が
与えられたとき、この関数適用についての帰納法の前提は c である。ここで、
x_1 は e_1、...  x_n は e_n とする。


### Implication - 含意

含意が成立するのは、いくつかの前提が結論を導くことである。言い換えると、
前提 e_1 ... e_n が真で、同様に結論 e_0 が真でなければならない。

- 0個の前提について、含意は e_0 である。

- 1個の前提 e_1 について、連言は (if e_1 e_0 't) である。

- 2個またはそれ以上の前提 e_1 e_2 ... e_n について、e_1 が、
前提 e_2 ... e_n の連言が結論 e_0 を導く、ことを導くことを示せ。


### Defun Induction - 帰納法の定義

主張 c と、関数 (defun name_f (x_1 ... x_n) body_f) と、変数の選択 y_1
... y_n が与えられたとき、body_i の部分式についての主張を構成する。こ
こで、body_i は body_f の x_1 をy_1 で置き換え ... x_n を y_n で置き換
えたもの：

- (if Q A E) ここで、A と E についての主張が c_a と c_c であるときにつ
  いて、Qの帰納法の前提は c_ae を導くことを示せ。ここで、c_ae はもし、
  c_a が c_e に等しいとき c_a、さもなければ (if Q c_a c_e)。

- 他の任意の式 E について、E の帰納法の前提は c を導くことを示せ。

c の帰納的な主張は、body_i についての主張である。


## Chapter 10

### Insight: Create Helper for Repetition - ヒント：繰り返しのヘルパーを作る。

もし証明が、何度も何度もステップのシーケンスと似た振る舞いをするなら、
Dethm の規則を通して、それらのステップと同じ書き換えをする定理を示せ。
証明を短くするために、ステップのシーケンスの代わりにその定理を使え。



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
| conjunction | 連言       | |
| inplication | 含意       | |

**以上**

