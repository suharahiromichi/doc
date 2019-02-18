量子計算についてのメモ

2019_02_12 @suharahiromichi 

$$
\def\bra#1{\mathinner{\left\langle{#1}\right|}}
\def\ket#1{\mathinner{\left|{#1}\right\rangle}}
\def\braket#1#2{\mathinner{\left\langle{#1}\middle|#2\right\rangle}}
$$

## はじめに

1qubitのデータは、2次元の縦ベクトル、1階のテンソルで表現される。
1qubitに作用する演算子は、2x2の行列、2階のテンソルで表現される。

```math
a
=
\ket{\phi}
=
a_0\ket{0} + a_1\ket{1}
=
\begin{pmatrix}
a_0 \\
a_1
\end{pmatrix}
```

```math
A
=
\begin{pmatrix}
A_{00} & A_{01} \\
A_{10} & A_{11}
\end{pmatrix}
```

データへの演算子の作用は、行列と縦ベクトルの積である。

```math
A \ a
```

## クロネッカー積

2qubitのデータ、および、その演算子はそれぞれのテンソル積で得られる。線型写像のテンソル積はクロネッカー積で与えられる。これは、データはn次の縦ベクトル、演算子はnxnの行列で表現され、「フラットな表現」と呼ばれることもある。

|qubit    |テンソル  |縦ベクトル  |　例 |
|:-:|----:|--:|:---------------:|
|1  |1階  |2次  |　　a |
|2  |2階  |4次  |　　a ⊗ b |
|3  |3階  |8次  |　　a ⊗ b ⊗ c |
|4  |4階  |16次  |　　a ⊗ b ⊗ c ⊗ d |
|n  |n階  |(2^n)次  |　

|qubit演算子  |テンソル  |行列  |　例 |
|:-:|---:|-----:|:---:|
|1  |2階  |2x2  |　　A |
|2  |4階  |4x4  |　　A ⊗ B |
|3  |8階  |8x8  |　　A ⊗ B ⊗ C |
|4  |16階  |16x16  |　　A ⊗ B ⊗ C ⊗ D |
|n  |2^n階  |(2^n)x(2^n)  |　

クロネッカー積は、右側掛けるほうがマイナーに回ることに留意する。

### qubit　（量子ビット）

```math
a \otimes b
=
\begin{pmatrix}
a_0 \\
a_1
\end{pmatrix}
\otimes
\begin{pmatrix}
b_0 \\
b_1
\end{pmatrix}
=
\begin{pmatrix}
a_0
\begin{pmatrix}
b_0 \\
b_1
\end{pmatrix}
\\
a_1
\begin{pmatrix}
b_0 \\
b_1
\end{pmatrix}
\end{pmatrix}
=
\begin{pmatrix}
a_0 b_0 \\
a_0 b_1 \\
a_1 b_0 \\
a_1 b_1 \\
\end{pmatrix}
```

要素毎に書くと、

```math
w_{(ij)} = a_i b_j

\\

w_{(ijk)} = a_i b_j c_k
```
ここで (ij) は、2進数である。別な書き方では、

```math
w_{x} = a_{(x/2)} b_{(x\ mod\ 2)}
```

### 演算子

```math
A B
=
\begin{pmatrix}
A_{00} & A_{01} \\
A_{10} & A_{11}
\end{pmatrix}
\otimes
\begin{pmatrix}
B_{00} & B_{01} \\
B_{10} & B_{11}
\end{pmatrix}
=
\begin{pmatrix}
A_{00} (B) & A_{01} (B) \\
A_{10} (B) & A_{11} (B)
\end{pmatrix}
\\ =
\begin{pmatrix}
A_{00} B_{00} & A_{00} B_{01} & A_{01} B_{00} & A_{01} B_{01} \\
A_{00} B_{10} & A_{00} B_{11} & A_{01} B_{10} & A_{01} B_{11} \\
A_{10} B_{00} & A_{10} B_{01} & A_{11} B_{00} & A_{11} B_{01} \\
A_{10} B_{10} & A_{10} B_{11} & A_{11} B_{10} & A_{11} B_{11}\\
\end{pmatrix}
```

要素毎に書くと、

```math
T_{(ij)(nm)} = A_{in} B_{jm}
\\
T_{(ijk)(nml)} = A_{in} B_{jm} C_{kl}
\\
```
ここで (ij) は、2進数である。別な書き方では、

```math
T_{xy} = A_{(x/2)(y/2)} B_{(x\ mod\ 2)(y\ mod\ 2)}
```

## 内積

随伴行列、adjoint　matrix、またはエルミート転置　（エルミート行列ではない）

```math
\ket{\phi}^\dagger
=
\bra{\phi}
=
(a_0\ket{0})^\dagger + (a_1\ket{1})^\dagger
=
a_0^*\bra{0} + a_1^*\bra{1}
```

ここで、<0|と<1|はブラと読む。a*は複素共役。


```math
\braket{\phi}{\psi}
=
\bra{\phi} \ket{\psi}
=
\begin{pmatrix}
a_0^* & a_1^*
\end{pmatrix}
\begin{pmatrix}
b_0 \\
b_1
\end{pmatrix}
=
a_0^* b_0 + a_1^* b_1
```

## 便利な公式
### その1
```math
(\ket{a} \otimes \ket{b})(\ket{c} \otimes \ket{d})
=
\braket{a}{c} \braket{b}{d}
\\
\\
\\
(=
a_0 b_0 c_0 d_0 +
a_0 b_1 c_0 d_1 +
a_1 b_0 c_1 d_0 +
a_1 b_1 c_1 d_1
)
```

### その2

この式は、量子回路における信号の独立性を表している。

```math
(A \otimes B) (\ket{a} \otimes \ket{b})
=
A \ket{a} \otimes B \ket{b}
```
```math
(=
\begin{pmatrix}
A_{00} B_{00} a_0 b_0 + A_{00} B_{01} a_0 b_1 + A_{01} B_{00} a_1 b_0 + A_{01} B_{01} a_1 b_1 \\
A_{00} B_{10} a_0 b_0 + A_{00} B_{11} a_0 b_1 + A_{01} B_{10} a_1 b_0 + A_{01} B_{11} a_1 b_1 \\
A_{10} B_{00} a_0 b_0 + A_{10} B_{01} a_0 b_1 + A_{11} B_{00} a_1 b_0 + A_{11} B_{01} a_1 b_1 \\
A_{10} B_{10} a_0 b_0 + A_{10} B_{11} a_0 b_1 + A_{11} B_{10} a_1 b_0 + A_{11} B_{11} a_1 b_1 \\
\end{pmatrix}
)
```

## swap (量子ビットの入れ替え）

```math
swap
=
\begin{pmatrix}
1 & 0 & 0 & 0 \\
0 & 0 & 1 & 0 \\
0 & 1 & 0 & 0 \\
0 & 0 & 0 & 1 \\
\end{pmatrix}
```
をつかう。

### 2量子ビットの場合

```math
swap \cdot (a \otimes b)
=
swap \cdot 
\begin{pmatrix}
a_0 b_0 \\
a_0 b_1 \\
a_1 b_0 \\
a_1 b_1 \\
\end{pmatrix}
=
\begin{pmatrix}
a_0 b_0 \\
a_1 b_0 \\
a_0 b_1 \\
a_1 b_1 \\
\end{pmatrix}
=
b \otimes a
```
### 3量子ビットの場合

```math
(swap \otimes I) (a \otimes b \otimes c)
=
(swap \cdot (a \otimes b)) \otimes c
=
b \otimes a \otimes c
```

```math
(I \otimes swap) (a \otimes b \otimes c)
=
a \otimes (swap \cdot (b \otimes c))
=
a \otimes c \otimes b
```

別のswapの場合は、これらを組み合わせて、

```math
\begin{eqnarray}
&&
(I \otimes swap)(swap \otimes I)(I \otimes swap)(a \otimes b \otimes c)
\\ &=&
(I \otimes swap)(swap \otimes I)(a \otimes c \otimes b)
\\ &=&
(I \otimes swap)(c \otimes a \otimes b)
\\ &=&
(c \otimes b \otimes a)
\end{eqnarray}
```

より一般的に、

```math
swap3(p, q, r) = (I \otimes swap)^p　(swap \otimes I)^q 　(I \otimes swap)^r
```
ここで、p, q, r は 0または1。

逆変換は、

```math
swap = swap^{-1}
```
なので、

```math
swap3(p, q, r)^{-1} = swap3(r, q, p)
```

### 4量子ビットの場合

```math
(swap \otimes I \otimes I)(a \otimes b \otimes c \otimes d)
=
(swap \cdot (a \otimes b)) \otimes c \otimes d
=
b \otimes a \otimes c \otimes d
```

```math
(I \otimes swap \otimes I)(a \otimes b \otimes c \otimes d)
=
a \otimes (swap \cdot (b \otimes c)) \otimes d
=
a \otimes c \otimes b \otimes d
```

## 補足

```math
\ket{00} =
\ket{0} \otimes \ket{0} =
\ket{0} \bra{0} =
\begin{pmatrix}
1 \\ 0
\end{pmatrix}
\begin{pmatrix}
1 & 0
\end{pmatrix}
=
\begin{pmatrix}
1 & 0 \\
0 & 0
\end{pmatrix}
=
\begin{pmatrix}
1 \\ 0 \\
0 \\ 0
\end{pmatrix}
```

```math
\ket{01} =
\ket{0} \otimes \ket{1} =
\ket{0} \bra{1} =
\begin{pmatrix}
1 \\ 0
\end{pmatrix}
\begin{pmatrix}
0 & 1
\end{pmatrix}
=
\begin{pmatrix}
0 & 1 \\
0 & 0
\end{pmatrix}
=
\begin{pmatrix}
0 \\ 1 \\
0 \\ 0
\end{pmatrix}
```

```math
\ket{10} =
\ket{1} \otimes \ket{0} =
\ket{1} \bra{0} =
\begin{pmatrix}
0 \\ 1
\end{pmatrix}
\begin{pmatrix}
1 & 0
\end{pmatrix}
=
\begin{pmatrix}
0 & 0 \\
1 & 0
\end{pmatrix}
=
\begin{pmatrix}
0 \\ 0 \\
1 \\ 0
\end{pmatrix}
```
```math
\ket{11} =
\ket{1} \otimes \ket{1} =
\ket{1} \bra{1} =
\begin{pmatrix}
0 \\ 1
\end{pmatrix}
\begin{pmatrix}
0 & 1
\end{pmatrix}
=
\begin{pmatrix}
0 & 0 \\
0 & 1
\end{pmatrix}
=
\begin{pmatrix}
0 \\ 0 \\
0 \\ 1
\end{pmatrix}
```

以上

