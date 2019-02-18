量子計算についてのメモ

2019_02_18 @suharahiromichi 

$$
\def\bra#1{\mathinner{\left\langle{#1}\right|}}
\def\ket#1{\mathinner{\left|{#1}\right\rangle}}
\def\braket#1#2{\mathinner{\left\langle{#1}\middle|#2\right\rangle}}
$$

## superoperator (超演算子)

```math
A^*\ ρ = A\ ρ\ A^\dagger
```

便利な公式

```math
(A\cdot B)^*\ ρ = A^*\ (B^*\ ρ)

\\
\\

(A \otimes B)^* = A^* \otimes B^*
```

それぞれ、次から求められる。

```math
(A \cdot B)^\dagger = B^\dagger A^\dagger
\\
(A \otimes B)^\dagger = A^\dagger \otimes B^\dagger
```

また、

```math
I^*\ ρ　= ρ
```

## swap の superoperator

```math

swap^* ρ
\\=
swap
\begin{pmatrix}
ρ_{00} & ρ_{01} & p_{02} & p_{03}\\
ρ_{10} & ρ_{11} & p_{12} & p_{13}\\
ρ_{20} & ρ_{21} & p_{22} & p_{23}\\
ρ_{30} & ρ_{31} & p_{32} & p_{33}\\
\end{pmatrix}
swap^\dagger
\\=
\begin{pmatrix}
ρ_{00} & ρ_{01} & p_{02} & p_{03}\\
ρ_{20} & ρ_{22} & p_{21} & p_{23}\\
ρ_{10} & ρ_{12} & p_{11} & p_{13}\\
ρ_{30} & ρ_{31} & p_{32} & p_{33}\\
\end{pmatrix}
```

## measure (計測） の superoperator

```math

meas^* ρ
\\
=
(\ket{0}\bra{0})^*\ ρ
+
(\ket{1}\bra{1})^*\ ρ
\\=
\begin{pmatrix}
1 & 0 \\
0 & 0 \\
\end{pmatrix}
\begin{pmatrix}
ρ_{00} & ρ_{01} \\
ρ_{11} & ρ_{11} \\
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
ρ_{11} & ρ_{11} \\
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
\ket{0}^*\ ρ + \ket{1}^*\ ρ
\\=
\begin{pmatrix}
1 & 0 \\
\end{pmatrix}
\begin{pmatrix}
ρ_{00} & ρ_{01} \\
ρ_{11} & ρ_{11} \\
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
ρ_{11} & ρ_{11} \\
\end{pmatrix}
\begin{pmatrix}
0 \\
1 \\
\end{pmatrix}
\\=
ρ_{00} + ρ_{11}
```

##　例

```math

(disc\ (meas\ (H\ X))^*\  \ket{0}\bra{0}
```

```math
=
(disc\ (meas\ 
\begin{eqnarray}
\frac{1}{\sqrt{2}}
\end{eqnarray}
\begin{pmatrix}
1 & 1 \\
1 & -1 \\
\end{pmatrix}
\begin{pmatrix}
0 & 1 \\
1 & 0 \\
\end{pmatrix}
))^*
\ 
\begin{pmatrix}
1 & 0 \\
0 & 0 \\
\end{pmatrix}
```

```math
=
disc^* 
(meas^*
((
\frac{1}{\sqrt{2}}
\begin{pmatrix}
1 & 1 \\
-1 & 1 \\
\end{pmatrix})^* 
\begin{pmatrix}
1 & 0 \\
0 & 0 \\
\end{pmatrix}
))
```

```math
=
disc^* 
(meas^*
(
\frac{1}{2}
\begin{pmatrix}
1 & 1 \\
-1 & 1 \\
\end{pmatrix}
\begin{pmatrix}
1 & 0 \\
0 & 0 \\
\end{pmatrix}
\begin{pmatrix}
1 & -1 \\
1 & 1 \\
\end{pmatrix}
)
```

```math
=
disc^*\ 
(meas^*\
\begin{pmatrix}
\frac{1}{2} & -\frac{1}{2} \\
-\frac{1}{2} & \frac{1}{2} \\
\end{pmatrix}
)
```

```math
=
disc^* 

\begin{pmatrix}
\frac{1}{2} & 0 \\
0 & \frac{1}{2} \\
\end{pmatrix}
```

```math
=
\frac{1}{2}
+
\frac{1}{2}
=
1
```

以上

