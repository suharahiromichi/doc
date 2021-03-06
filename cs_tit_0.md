「コンピュータは数学者になれるのか？」を不完全性定理の入門書として読む
===============================

2018_08_18      ProofCafe#78


@suharahiromichi

# 1. 目的

本資料は、定理証明の勉強会である *ProofCafe* で、
不完全性定理を勉強する際のレジュメです。
不完全性定理にはいくつかの書籍がありますが、今回は[1]の2章に沿って説明します。
[1]は（題名はともかく）数学基礎論からはじまるコンピュータサイエンスの入門書として、
とても優れたものです。そのいちばん最初の部分を読んでみたいと思います。

不完全性定理の解説書としては、[1]と同時期に出版された[2]も素晴らしいのですが、
まず[1]から入門して[2]に進むのがよいのではないか、と考えます。


# 2. 解説

## 2.1 定義

記号を[1]にあわせて、次のように定義します。一部は、本資料固有のものです。

- N 自然数（のモデル）
- N ⊨ A モデルNからAは導かれる。
- N ⊭ A モデルNからAは導かれない。

- T 任意の形式系
- Q 自然数を含む第一階述語論理の形式系（数学的帰納法を含まない）
- T ⊢ A 形式系TからAは証明できる。
- T ⊬ A 形式系TからA証明できない。

- ⇔、⇒ ならば。ただし、⊨や⊢より優先度（結合度）が低い。
- <->、-> ならば。ただし、⊨や⊢より優先度（結合度）が高い。
- ⇒ と -> は入れ替えられる。``T ⊢ A->B`` と ``T⊢A ⇒ T⊢B`` は同じ。

- ⌜A⌝ Aをゲーデル数化して得られる自然数。

- 「文」は自由変数を含まない。「文A(x)」というとき、xは実引数を示す。
- 「論理式」は自由変数を含んでよい。「(1変数)論理式A(x)」というとき、xは仮引数を示す。


## 2.2 準備

以下において、定理などの番号は[1]と同じです。

### 2.2.1 算術階層と決定可能性

#### 2.2.1.1 算術階層

以下で、A(x, y, z) は有界論理式（他に∃や∀があっても、その上限が定められている）とする。

変数x, y, zは、カントールの対関数などの方法で、複数の変数をひとつにまとめたものと考える。

```
Δ0 : A(x)

Σ1 : ∃x.A(x)                 Π1 : ∀x.A(x)

Σ2 : ∃x.∀y.A(x, y)           Π2 : ∀x.∃y.A(x, y)

Σ3 : ∃x.∀y.∃z.A(x, y, z)     Π2 : ∀x.∃y.∀z.A(x, y, z)
```

- AがΣ1文で、``N ⊨ A ⇒ T ⊢ A`` であるとき、Σ1完全 であるという。

- AがΣ1文で、``N ⊨ A ⇐ T ⊢ A`` であるとき、Σ1健全 または Σ1無矛盾、1-無矛盾 であるという。

- （補足）特に本資料では、[1]で「論理式XがΣ1論理式に書き直すことができる」というとき、
「論理式XはΣ1論理式である」ということがある。


#### 2.2.1.2 (定理2.12) 論理式 X は半決定可能 ⇔ 論理式X は Σ1 論理式である。

Σ1論理式は、真ならばいつかは決定できる。しかし、偽であることは決定できない。
つまり半決定可能である。


### 2.2.2 不動点定理（対角化定理）

(定理2.3 不動点) 1変数論理式A(x)に対して、文DAが存在して ``N ⊨ DA <-> A(⌜DA⌝)`` が成り立つ。

証明の概略：

- ゲーデル数がnであるような1変数論理式``Bn(x)``を考える。

```
B0(0)           B0(1)           B0(2)                  自己参照1
B1(0)           B1(1)           B1(2)
B2(0)           B2(1)           B2(2)
```

- ``C(x)`` を ``N ⊨ C(n) <-> A(⌜Bn(n)⌝)`` を満たす1変数論理式として、そのゲーデル数をkとする。

```
A(⌜B0(0)⌝)      A(⌜B1(1)⌝)      A(⌜B2(2)⌝)             θの適用
  ↕               ↕               ↕
C(0)            C(1)            C(2)                    対象化
                 ‖
B0(0)           B1(1)           B2(2)                   自己参照1
```

- このとき、論理式C(x)のゲーデル数 k = 1 の場合、不動点 DA = C(1) = B1(1) となる。


### 2.2.3 集合PrfT、ProvT、論理式provT

#### 2.2.3.1 (定理2.13)
形式系Tから証明できる定理の集合``ProvT ≡ {⌜A⌝ | T ⊢ A}``は半決定可能である。

証明の概略：形式系Tの証明図の集合 PrfT は半決定可能である。
PrfTの中から、任意の定理Aの証明になっている証明図を選んだのが ProvT であるが、
それは容易な計算なので、ProvTも半決定可能である。
（補足）ひとつの定理に対して、一般に複数の証明図があるが、それはどうでもよい。


#### 2.2.3.2 (定理2.14 証明図の存在と証明可能の関係)
Σ1論理式``provT(x)``は、任意の文Aについて、``N ⊨ provT(⌜A⌝) ⇔ T ⊢ A`` を満たす。

（補足説明）``provT(⌜A⌝)``は、「形式系Tは定理Aを証明する証明図がある」ことで、
それが、「形式系Tが定理Aを証明できる」と同値であることを示すものである。

証明の概略：(定理2.13) ``ProvT ≡ {⌜A⌝ | T ⊢ A}`` は、
（集合ProvTをぴったりと表現する）特性関数provTを使って、
``ProvT ≡ {x | provT(x)}`` と定義しなおすことができる。

ここで、provT(x)は半決定可能なので(定理2.12)から、1変数Σ1論理式になる。
これは後で使う。


## 2.4 第一不完全性定理

### 2.4.1 形式系Qについて考える。

- (定理1.3 QのΣ1完全性)
AがΣ1論理式なら、``N ⊨ A ⇔ Q ⊢ A``

(定理1.3)は、NとQに対して、特別に成り立つことに注意してください。


### 2.4.2 TはQの無矛盾な拡大（または 1-無矛盾な拡大）とする。

- (定理1.3)より、AがΣ1論理式なら、``N ⊨ A ⇒ T ⊢ A``  ..... (式2.13)、無矛盾な拡大のとき

- (定理1.3)より、AがΣ1論理式なら、``N ⊨ A ⇔ T ⊢ A``  ..... (式2.13')、1-無矛盾な拡大のとき、

1-無矛盾の定義 ``N ⊨ A ⇐ T ⊢ A`` から、⇐ も成り立つことになるわけだ。

- (定理2.3 不動点)より、``T ⊢ DA <-> A(⌜DA⌝)``        ..... (式2.11)

Qは自然数を扱えるので、TがQの拡大なら(定理2.3 不動点)も証明できると考えられる。


- (定理2.14) の証明図の存在と証明可能の関係から、

provT(x)はΣ1文であるので、左辺に(式2.13)または(式2.13')適用できる。

無矛盾な拡大のとき、
```T ⊢ provT(⌜A⌝) ⇐ T ⊢ A```         ..... (式a)

1-無矛盾な拡大のとき、
```T ⊢ provT(⌜A⌝) ⇔ T ⊢ A```         ..... (式a')


### 2.4.3 (定理2.16 第1不完全性定理)
形式系TはQのRE拡大であるとき、あるΠ1文GTが存在して、次が成り立つ。

- T が無矛盾なら、``T ⊬ GT``
- T が1-無矛盾なら、``T ⊬ ~GT``


証明の概略：

TはQの無矛盾な拡大（または 1-無矛盾な拡大）と仮定する。

#### 2.4.3.1 (式2.11)より、次の不動点GTが存在して、それをゲーデル文と呼ぶ。

```T ⊢ GT <-> ~ provT(⌜GT⌝)```

両辺の否定をとる。
```T ⊢ ~GT <-> provT(⌜GT⌝)```

ばらす。
```T ⊢ ~GT ⇔ T ⊢ provT(⌜GT⌝)```        ..... (式b)


``provT(x)`` はΣ1文なので、それと同値な~GTはΣ1文、GTはΠ1文である。


#### 2.4.3.2 (式a)や(式a')のAは任意の文でよいので、そこにGTを代入できる。

無矛盾な拡大のとき、
```T ⊢ provT(⌜GT⌝) ⇐ T ⊢ GT```         ..... (式c)

または、1-無矛盾な拡大のとき、
```T ⊢ provT(⌜GT⌝) ⇔ T ⊢ GT```         ..... (式c')


#### 2.4.3.3 TがQの無矛盾な拡大のとき、GTが導けないような文が存在する。

(式b)と(式c)から、``T ⊢ GT ⇒ T ⊢ provT(⌜GT⌝) ⇔ T ⊢ ~GT`` が得られる。
GTが導けるとすると~GTが導けてしまうので、GTが導けないことが結論できる。


#### 2.4.3.4 TがQの1-無矛盾な拡大のとき、~GTもGTも導けないような文が存在する。

(式b)と(式c')から、``T ⊢ GT ⇔ T ⊢ provT(⌜GT⌝) ⇔ T ⊢ ~GT`` が得られる。
GTが導けるとすると~GTが導けてしまい、~GTが導けるとするとGTが導けてしまうので、~GTもGTも導けないことが結論できる。

#### 2.4.3.5 （補足）表にすると、

```
Tは無矛盾（1-無矛盾でない）    T ⊬ GT    
Tは1-無矛盾（ならば無矛盾）    T ⊬ GT    T ⊬ ~GT
```


# 3 参考文献

[1] 照井一成著「コンピュータは数学者になれるのか？」青土社


[2] 菊池誠著「不完全性定理」共立出版


[3] ゲーデル著、林晋、八杉満里子訳・解説「不完全性定理」岩波文庫


[4] 照井一成「『数学』を数学的に考える」
http://www.kurims.kyoto-u.ac.jp/~kenkyubu/kokai-koza/terui.pdf


以上
