剰余演算について

2013_03_16

2020_08_02

@suharahiromichi

# はじめに

負数を含む整数割算の余り（剰余演算）の結果がCとPythonで異なることは結構有名で、コーディングルールで負数を含む割算や剰余の計算を禁止している場合もあるでしょう。
ここでは、そんな（嫌われものの）剰余計算について調べてみます。


AをBで割った剰余計算の結果 ``A mod B`` を M とする。すると、

```A = f(A / B) * B + M```

が成り立つ。ここで、「/」は実数割り算で、fは整数化の関数である。
また、fの定義によらず、f(A / B)\*B の符号はAに等しいとする(\*)。

以下において、fの考え得るすべての定義 f1 〜 f6 について、剰余演算の結果を調べてみる。


# C Style (f1)、剰余が被除数と同符号になる場合

fが0方向への切り捨て(tranc)のとき、|A|≧|f(A/B)\*B| だがら、(\*)を考慮して絶対値を外すと、

- Aが正、Bが正なら、A≧f(A/B)\*B、M = A - f(A/B)\*B ≧ 0
- Aが負、Bが正なら、A≦f(A/B)\*B、M = A - f(A/B)\*B ≦ 0
- Aが正、Bが負なら、A≧f(A/B)\*B、M = A - f(A/B)\*B ≧ 0
- Aが負、Bが負なら、A≦f(A/B)\*B、M = A - f(A/B)\*B ≦ 0

つまり、Mの符号はA(Dividend)に等しい。


# Python Style (f2)、剰余が除数と同符号になる場合

fが-∞方向への切り捨て(floor、床関数)のとき、A/B≧f(A/B)だから、両辺にBを掛けると、

- Aが正、Bが正なら、A≧f(A/B)\*B、M = A - f(A/B)\*B ≧ 0
- Aが負、Bが正なら、A≧f(A/B)\*B、M = A - f(A/B)\*B ≧ 0
- Aが正、Bが負なら、A≦f(A/B)\*B、M = A - f(A/B)\*B ≦ 0
- Aが負、Bが負なら、A≦f(A/B)\*B、M = A - f(A/B)\*B ≦ 0

つまり、Mの符号はB(Divisor)に等しい。


# C99 remainder (f3)、剰余が絶対値で最小になる場合

fが四捨五入のとき、|A - f(A/B)\*B| が最小になるから、|M|も最小になる。
Mは絶対値が最小に選ばれることになる。絶対値最小剰余代表系という。


# Pascal Style (f4)、剰余が常に正になる場合

Bが正ならfloor、つまり、Bが正ならA/B≧f(A/B)。
Bが負ならceil、つまり、Bが負ならA/B≦f(A/B)。
すなわち、除算が、ユーグリッド除法のとき、A≧f(A/B)\*B だがら、

- Aが正、Bが正なら、A≧f(A/B)\*B、M = A - f(A/B)\*B ≧ 0
- Aが負、Bが正なら、A≧f(A/B)\*B、M = A - f(A/B)\*B ≧ 0
- Aが正、Bが負なら、A≧f(A/B)\*B、M = A - f(A/B)\*B ≧ 0
- Aが負、Bが負なら、A≧f(A/B)\*B、M = A - f(A/B)\*B ≧ 0

つまり、Mは常に正になる。非負最小剰余代表系という。


# (f5)、剰余が商と同符号になる場合

Aが正ならfloor、つまり、Aが正ならA/B≧f(A/B)。
Aが負ならceil、つまり、Aが負ならA/B≦f(A/B)。

- Aが正、Bが正なら、f(A/B)は正で、A≧f(A/B)\*B、M = A - f(A/B)\*B ≧ 0
- Aが負、Bが正なら、f(A/B)は負で、A≦f(A/B)\*B、M = A - f(A/B)\*B ≦ 0
- Aが正、Bが負なら、f(A/B)は負で、A≦f(A/B)\*B、M = A - f(A/B)\*B ≦ 0
- Aが負、Bが負なら、f(A/B)は正で、A≧f(A/B)\*B、M = A - f(A/B)\*B ≧ 0

つまり、Mは、商 f(A/B) と同じ符号になる。


# (f6)、使えない場合

fが+∞方向の切り上げ(ceil、天井関数)のとき、A/B≦f(A/B)だから、両辺にBを掛けると、

- Aが正、Bが正なら、A≦f(A/B)\*B、M = A - f(A/B)\*B ≦ 0
- Aが負、Bが正なら、A≦f(A/B)\*B、M = A - f(A/B)\*B ≦ 0
- Aが正、Bが負なら、A≧f(A/B)\*B、M = A - f(A/B)\*B ≧ 0
- Aが負、Bが負なら、A≧f(A/B)\*B、M = A - f(A/B)\*B ≧ 0

つまり、Mの符号はB(Divisor)の符号の逆になる。
10/3が-2になるため、これは適切な定義ではない。


# 参考

https://ja.wikipedia.org/wiki/剰余演算


以上
