量子計算についての出鱈目なメモ　（ツッコミ謝絶）

2019_02_02 @suharahiromichi 

$$
\def\bra#1{\mathinner{\left\langle{#1}\right|}}
\def\ket#1{\mathinner{\left|{#1}\right\rangle}}
\def\braket#1#2{\mathinner{\left\langle{#1}\middle|#2\right\rangle}}
$$

## 0-1テンソルの表現

2次の複素ベクトル。

```math
\ket{\phi}
=
c_0\ket{0} + c_1\ket{1}
=
c_0\ket{e_0} + c_1\ket{e_1}
=
\sum_{i=0}^1{c_i\ket{e_i}}
=
\begin{pmatrix}
c_0 \\
c_1
\end{pmatrix}
```
```math
\ket{\psi}
=
d_0\ket{0} + d_1\ket{1}
=
d_0\ket{e_0} + d_1\ket{e_1}
=
\sum_{i=0}^1{d_i\ket{e_i}}
=
\begin{pmatrix}
d_0 \\
d_1
\end{pmatrix}
```

ここで、|0>と|1>は基底ベクトル。ケットと読む。

```math
\ket{0} =
\ket{e_0} =
\begin{pmatrix}
1 \\
0 
\end{pmatrix}
\\
\ket{1} =
\ket{e_1} =
\begin{pmatrix}
0 \\
1 
\end{pmatrix}
```

随伴行列、またはエルミート転置　（エルミート行列ではない）

```math
\ket{\phi}^\dagger
=
\bra{\phi}
=
(c_0\ket{0})^\dagger + (c_1\ket{1})^\dagger
=
c_0^*\bra{0} + c_1^*\bra{1}
=
\sum_{i=0}^1{c_i^*\bra{e_i}}
=
\begin{pmatrix}
c_0^* & c_1^*
\end{pmatrix}
```

ここで、<0|と<1|はブラと読む。α*は複素共役。

```math
\ket{0}^\dagger =
\bra{0} =
\bra{e_0} =
\begin{pmatrix}
1  & 0 
\end{pmatrix}
\\
\ket{1}^\dagger =
\bra{1} =
\bra{e_1} =
\begin{pmatrix}
0 & 1 
\end{pmatrix}
```

## 0-1テンソルの内積

随伴行列を掛ける。スカラーになる。可換ではない。

```math
\braket{\psi}{\phi}
=
\bra{\psi} \ket{\phi}
=
\begin{pmatrix}
c_0^* & c_1^*
\end{pmatrix}
\begin{pmatrix}
d_0 \\
d_1
\end{pmatrix}
=
c_0^* d_0 + c_1^* d_1
=
\sum_{i=0}^1{c_i^* d_i} 
```

## 0-1テンソルのテンソル積

0-2テンソルになる。フラットな表現で4次。

```math
\ket{\psi} \otimes \ket{\phi}
=
\ket{\psi} \bra{\phi}
=
\begin{pmatrix}
c_0 \\
c_1
\end{pmatrix}
\begin{pmatrix}
d_0 & d_1
\end{pmatrix}
\\ =
c_0 d_0 \ket{00} + c_0 d_1 \ket{01} + c_1 d_0 \ket{10} + c_1 d_1 \ket{11}
=
\sum_{i,  j=0}^1{c_i d_j \ket{e_i} \otimes \ket{e_j}}
\\ =
\begin{pmatrix}
c_0 d_0 & c_0 d_1 \\
c_1 d_0 & c_1 d_1
\end{pmatrix}
=
\begin{pmatrix}
c_0 d_0 \\
c_0 d_1 \\
c_1 d_0 \\
c_1 d_1
\end{pmatrix}
```

最後のは「フラットな表現」という。ここで、

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

## 0-2テンソルの表現

```math
\ket{\phi}
=
c_{00}\ket{00} + c_{01}\ket{01} + c_{10}\ket{10} + c_{11}\ket{11}
=
\sum_{i=0}^1\sum_{j=0}^1{c_{ij}\ket{e_{ij}}}
=
\begin{pmatrix}
c_{00} & c_{01} \\
c_{10} & c_{11}
\end{pmatrix}
=
\begin{pmatrix}
c_{00} \\ c_{01} \\
c_{10} \\ c_{11}
\end{pmatrix}
```

```math
\ket{\phi}
=
d_{00}\ket{00} + d_{01}\ket{01} + d_{10}\ket{10} + d_{11}\ket{11}
=
\sum_{i=0}^1\sum_{j=0}^1{d_{ij}\ket{e_{ij}}}
=
\begin{pmatrix}
d_{00} & d_{01} \\
d_{10} & d_{11}
\end{pmatrix}
=
\begin{pmatrix}
d_{00} \\ d_{01} \\
d_{10} \\ d_{11}
\end{pmatrix}
```

## 0-2テンソルの内積

スカラーになる。可換ではない。

```math
\braket{\psi}{\phi}
=
\bra{\psi} \ket{\phi}
=
\begin{pmatrix}
c_{00}^* & c_{01}^* & c_{10}^* & c_{11}^*
\end{pmatrix}
\begin{pmatrix}
d_{00} \\
d_{01} \\
d_{10} \\
d_{11}
\end{pmatrix}
\\=
c_{00}^* d_{00} + c_{01}^* d_{01} + c_{10}^* d_{10} + c_{11}^* d_{11}
=
\sum_{i=0}^1\sum_{j=0}^1{c_{ij}^* d_{ij}} 
```

## 0-2テンソルのテンソル積

0-4テンソルになる。フラットな表現で16次。

```math
\ket{\psi} \otimes \ket{\phi}
=
\ket{\psi} \bra{\phi}
=
\begin{pmatrix}
c_{00} \\
c_{01} \\
c_{10} \\
c_{11}
\end{pmatrix}
\begin{pmatrix}
d_{00} & d_{01} & d_{10} & d_{11}
\end{pmatrix}
\\ =
c_{00} d_{00} \ket{0000} +
c_{00} d_{01} \ket{0001} +
c_{00} d_{10} \ket{0010} +
c_{00} d_{11} \ket{0011}
\\ +
c_{01} d_{00} \ket{0100} +
c_{01} d_{01} \ket{0101} +
c_{01} d_{10} \ket{0110} +
c_{01} d_{11} \ket{0111}
\\ +
c_{10} d_{00} \ket{1000} +
c_{10} d_{01} \ket{1001} +
c_{10} d_{10} \ket{1010} +
c_{10} d_{11} \ket{1011}
\\ +
c_{11} d_{00} \ket{1100} +
c_{11} d_{01} \ket{1101} +
c_{11} d_{10} \ket{1110} +
c_{11} d_{11} \ket{1111}
\\ =
\sum_{i,j,k,l=0}^1{c_{ij} d_{kl} (\ket{e_{ij}} \otimes \ket{e_{kl})}}
\\ =
\begin{pmatrix}
c_{00} d_{00} & c_{00} d_{01} & c_{00} d_{10} & c_{00} d_{11} \\
c_{01} d_{00} & c_{01} d_{01} & c_{01} d_{10} & c_{01} d_{11} \\
c_{10} d_{00} & c_{10} d_{01} & c_{10} d_{10} & c_{10} d_{11} \\
c_{11} d_{00} & c_{11} d_{01} & c_{11} d_{10} & c_{11} d_{11}
\end{pmatrix}
```

## 0-2テンソルと0-1テンソルのテンソル積

0-3テンソルになる。フラットな表現で8次。

```math
\ket{\psi} \otimes \ket{\phi}
=
\ket{\psi} \bra{\phi}
=
\begin{pmatrix}
c_{00} \\
c_{01} \\
c_{10} \\
c_{11}
\end{pmatrix}
\begin{pmatrix}
d_{0} & d_{1}
\end{pmatrix}
\\ =
c_{00} d_{0} \ket{000} +
c_{00} d_{1} \ket{001}
\\ +
c_{01} d_{0} \ket{010} +
c_{01} d_{1} \ket{011}
\\ +
c_{10} d_{0} \ket{100} +
c_{10} d_{1} \ket{101}
\\ +
c_{11} d_{0} \ket{110} +
c_{11} d_{1} \ket{111}
\\ =
\sum_{i,j,k=0}^1{c_{ij} d_{k} (\ket{e_{ij}} \otimes \ket{e_{k})}}
=
\begin{pmatrix}
c_{00} d_{0} & c_{00} d_{1} \\
c_{01} d_{0} & c_{01} d_{1} \\
c_{10} d_{0} & c_{10} d_{1} \\
c_{11} d_{0} & c_{11} d_{1}
\end{pmatrix}
```

## 意味についてすこし

- nxmの行列は、フラットな表現ならn＊mの複素ベクトルになる。
- 1qubitのデータは、0-1テンソル（2次の複素ベクトル）で表現される。
- 2qubitのデータは、ふたつの1qubitのデータのテンソル積で表現され、0-2テンソル（2x2の行列、4次の複素ベクトル）で表現される。
- 3qunitのデータは、みっつの1qubitのデータのテンソル積、2qubitと1qubitのテンソル積で表現され、0-3テンソル（4x2の行列、8次の複素ベクトル）で表現される。
- n-qubitのデータは、0-nテンソル（2^n　次の複素ベクトル）で表現される。
- 1qubitに作用するゲート（ユニタリという）は、0-2テンソル（2x2のユニタリ行列）で表現される。
- 2qubitに作用するゲートは、ユニタリのテンソル積で表現され、0-4テンソル（4x4のユニタリ行列）で表現される。
- n-qubitに作用するゲートは、0-2^n　テンソル（2^n x 2^n　のユニタリ行列）で表現される。


以上

