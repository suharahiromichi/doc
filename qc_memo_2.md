量子計算についてのメモ

2019_02_18 @suharahiromichi 

$$
\def\bra#1{\mathinner{\left\langle{#1}\right|}}
\def\ket#1{\mathinner{\left|{#1}\right\rangle}}
\def\braket#1#2{\mathinner{\left\langle{#1}\middle|#2\right\rangle}}
$$

## superoperator (超演算子)

```math
A^* ρ = A\cdot ρ\cdot A^\dagger
```

便利な公式

```math
(A\cdot B)^* ρ = A^* (B^* ρ)

\\
\\

(A \otimes B)^* = A^* \otimes B^*
```

それぞれ、次から求められる。

```math
(A \cdot B)^\dagger = B^\dagger \cdot A^\dagger
\\
(A \otimes B)^\dagger = A^\dagger \otimes B^\dagger
```

また、

```math
I^* = I
```

cをスカラーとすると、

```math
(c\cdot A)^* = c^2\cdot A^*
\\
A^* (c\cdot ρ) = c\cdot A^* ρ
```

## unitary の superoperator

```math

X^* ρ
\\=
\begin{pmatrix}
0 & 1 \\
1 & 0 \\
\end{pmatrix}
\begin{pmatrix}
ρ_{00} & ρ_{01} \\
ρ_{10} & ρ_{11} \\
\end{pmatrix}
\begin{pmatrix}
0 & 1 \\
1 & 0 \\
\end{pmatrix}
\\=
\begin{pmatrix}
ρ_{11} & ρ_{10} \\
ρ_{01} & ρ_{00} \\
\end{pmatrix}

```

```math

Y^* ρ
\\=
\begin{pmatrix}
0 & -i \\
i & 0 \\
\end{pmatrix}
\begin{pmatrix}
ρ_{00} & ρ_{01} \\
ρ_{10} & ρ_{11} \\
\end{pmatrix}
\begin{pmatrix}
0 & i \\
-i & 0 \\
\end{pmatrix}
\\=
\begin{pmatrix}
-ρ_{11} & ρ_{10} \\
ρ_{01} & -ρ_{00} \\
\end{pmatrix}

```

```math

Z^* ρ
\\=
\begin{pmatrix}
1 & 0 \\
0 & -1 \\
\end{pmatrix}
\begin{pmatrix}
ρ_{00} & ρ_{01} \\
ρ_{10} & ρ_{11} \\
\end{pmatrix}
\begin{pmatrix}
1 & 0 \\
0 & -1 \\
\end{pmatrix}
\\=
\begin{pmatrix}
ρ_{00} & -ρ_{01} \\
-ρ_{10} & ρ_{11} \\
\end{pmatrix}

```

```math

H^* ρ
\\=
\frac{1}{2}
\begin{pmatrix}
1 & 1 \\
1 & -1 \\
\end{pmatrix}
\begin{pmatrix}
ρ_{00} & ρ_{01} \\
ρ_{10} & ρ_{11} \\
\end{pmatrix}
\begin{pmatrix}
1 & 1 \\
1 & -1 \\
\end{pmatrix}
\\=
\frac{1}{2}
\begin{pmatrix}
ρ_{00}+ρ_{01}+ρ_{10}+ρ_{11} &
ρ_{00}-ρ_{01}+ρ_{10}-ρ_{11} \\
ρ_{00}+ρ_{01}-ρ_{10}-ρ_{11} &
ρ_{00}-ρ_{01}-ρ_{10}+ρ_{11} \\
\end{pmatrix}

```


## CNOT の superoperator

```math
CNOT
=
\begin{pmatrix}
1 & 0 & 0 & 0 \\
0 & 1 & 0 & 0 \\
0 & 0 & 0 & 1 \\
0 & 0 & 1 & 0 \\
\end{pmatrix}
```

```math
CNOT^* ρ
\\=
CNOT\cdot
\begin{pmatrix}
ρ_{00} & ρ_{01} & ρ_{02} & ρ_{03}\\
ρ_{10} & ρ_{11} & ρ_{12} & ρ_{13}\\
ρ_{20} & ρ_{21} & ρ_{22} & ρ_{23}\\
ρ_{30} & ρ_{31} & ρ_{32} & ρ_{33}\\
\end{pmatrix}\cdot
CNOT^\dagger
\\=
\begin{pmatrix}
ρ_{00} & ρ_{01} & ρ_{02} & ρ_{03}\\
ρ_{10} & ρ_{11} & ρ_{12} & ρ_{13}\\
ρ_{20} & ρ_{21} & ρ_{22} & ρ_{23}\\
ρ_{30} & ρ_{31} & ρ_{32} & ρ_{33}\\
\end{pmatrix}
```

## swap の superoperator

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

```math
swap^* ρ
\\=
swap\cdot
\begin{pmatrix}
ρ_{00} & ρ_{01} & ρ_{02} & ρ_{03}\\
ρ_{10} & ρ_{11} & ρ_{12} & ρ_{13}\\
ρ_{20} & ρ_{21} & ρ_{22} & ρ_{23}\\
ρ_{30} & ρ_{31} & ρ_{32} & ρ_{33}\\
\end{pmatrix}\cdot
swap^\dagger
\\=
\begin{pmatrix}
ρ_{00} & ρ_{01} & ρ_{02} & ρ_{03}\\
ρ_{20} & ρ_{22} & ρ_{21} & ρ_{23}\\
ρ_{10} & ρ_{12} & ρ_{11} & ρ_{13}\\
ρ_{30} & ρ_{31} & ρ_{32} & ρ_{33}\\
\end{pmatrix}
```

## measure (計測） の superoperator

```math

meas^* ρ
\\
=
(\ket{0}\bra{0})^* ρ
+
(\ket{1}\bra{1})^* ρ
\\=
\begin{pmatrix}
1 & 0 \\
0 & 0 \\
\end{pmatrix}
\begin{pmatrix}
ρ_{00} & ρ_{01} \\
ρ_{10} & ρ_{11} \\
\end{pmatrix}
\begin{pmatrix}
1 & 0 \\
0 & 0 \\
\end{pmatrix}
+
\begin{pmatrix}
0 & 0 \\
0 & 1 \\
\end{pmatrix}
\begin{pmatrix}
ρ_{00} & ρ_{01} \\
ρ_{10} & ρ_{11} \\
\end{pmatrix}
\begin{pmatrix}
0 & 0 \\
0 & 1 \\
\end{pmatrix}
\\=
\begin{pmatrix}
ρ_{00} & 0 \\
0 & 0 \\
\end{pmatrix}
+
\begin{pmatrix}
0 & 0 \\
0 & ρ_{11} \\
\end{pmatrix}
\\=
\begin{pmatrix}
ρ_{00} & 0 \\
0 & ρ_{11} \\
\end{pmatrix}
```

## discard の superoperator

```math

disc^* ρ
\\=
\ket{0}^* ρ + \ket{1}^* ρ
\\=
\begin{pmatrix}
1 & 0 \\
\end{pmatrix}
\begin{pmatrix}
ρ_{00} & ρ_{01} \\
ρ_{10} & ρ_{11} \\
\end{pmatrix}
\begin{pmatrix}
1 \\
0 \\
\end{pmatrix}
+
\begin{pmatrix}
0 & 1 \\
\end{pmatrix}
\begin{pmatrix}
ρ_{00} & ρ_{01} \\
ρ_{10} & ρ_{11} \\
\end{pmatrix}
\begin{pmatrix}
0 \\
1 \\
\end{pmatrix}
\\=
ρ_{00} + ρ_{11}
```

## bit-control の superoperator

Bit⊗Qubit -> Bit⊗Qubit のbit-controlは、次で定義される。

```math
ctrl\ A
\\=
(\ket{1}\bra{1}) \otimes A + (\ket{1}\bra{1}) \otimes I
\\=
\begin{pmatrix}
0 & 0 \\
0 & 1 \\
\end{pmatrix} \otimes A
+
\begin{pmatrix}
1 & 0 \\
0 & 0 \\
\end{pmatrix} \otimes I
\\=
\begin{pmatrix}
I & 0 \\
0 & A \\
\end{pmatrix}
```

入力にあたるBit⊗Qubit型の密度行列は、meas⊗I を通ってくるので、　

```math
\begin{eqnarray}
((ctrl\ A)\cdot(meas \otimes I))^* (a \otimes b)
&=&
(ctrl\ A)^* ((meas \otimes I)^* (a \otimes b))
\\ &=&
(ctrl\ A)^* ((meas^* \otimes I^*)(a \otimes b))
\\ &=&
(ctrl\ A)^* (meas^* a \otimes b)
\\ &=&
(ctrl\ A)^* (\begin{pmatrix}
a_{00} & 0 \\
0 & a_{11} \\
\end{pmatrix} \otimes b)
\\ &=&
(ctrl\ A)^*\ \begin{pmatrix}
a_{00}\ (b) & 0 \\
0 & a_{11}\ (b) \\
\end{pmatrix}
\\ &=&
\begin{pmatrix}
I & 0 \\
0 & A \\
\end{pmatrix}^*\ 
\begin{pmatrix}
a_{00}\ (b) & 0 \\
0 & a_{11}\ (b) \\
\end{pmatrix}
\\ &=&
\begin{pmatrix}
I & 0 \\
0 & A \\
\end{pmatrix}
\begin{pmatrix}
a_{00}\ (b) & 0 \\
0 & a_{11}\ (b) \\
\end{pmatrix}
\begin{pmatrix}
I & 0 \\
0 & A^\dagger \\
\end{pmatrix}
\\ &=&
\begin{pmatrix}
a_{00}\ (b) & 0 \\
0 & a_{11}\ A\ (b)\ A^\dagger \\
\end{pmatrix}
\\ &=&
\begin{pmatrix}
a_{00}\ (b) & 0 \\
0 & a_{11}\ A^* (b) \\
\end{pmatrix}
\end{eqnarray}
```

##　例

```math
\begin{eqnarray}
&&
disc^*\ (meas^*\ ((H\cdot X)^*\  \ket{0}\bra{0}))
\\ &=&
disc^*\ 
(meas^*\ 
((H\cdot X)^*
\begin{pmatrix}
1 & 0 \\
0 & 0 \\
\end{pmatrix}
))
\\ &=&
disc^*\ 
(meas^*\ 
(H^*\ (X^*
\begin{pmatrix}
1 & 0 \\
0 & 0 \\
\end{pmatrix}
)))
\\ &=&
disc^* 
(meas^*\ 
(
H^*
\begin{pmatrix}
0 & 0 \\
0 & 1 \\
\end{pmatrix}
))
\\ &=&
disc^*\ 
(meas^*\
\begin{pmatrix}
\frac{1}{2} & -\frac{1}{2} \\
-\frac{1}{2} & \frac{1}{2} \\
\end{pmatrix}
)
\\ &=&
disc^* 

\begin{pmatrix}
\frac{1}{2} & 0 \\
0 & \frac{1}{2} \\
\end{pmatrix}
\\ &=&
\frac{1}{2}
+
\frac{1}{2}
\\ &=&
1
\end{eqnarray}
```

以上

