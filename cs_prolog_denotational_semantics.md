Prologの表示的意味論
=========
2013/08/24 @suharahiromichi

# エルブランベース

PrologのプログラムPにおいて、
出現しうるすべての原始論理式（例：p(a,f(b))）の集合をエルブランベース Bp で表す。

関数 Tp を次のように定義する。

    Tp(M) = {A∈Bp | ∀Θ, ∀c∈P, A:-B1,B2,..Bn = c Θ, B1,B2,..Bn∈M⊆Bp}

## 最小不動点

Tpの最小不動点 Lfp(Tp) = Tp↑ω ⊆Bp を次のようにもとめる。

    Tp↑0 = {}
    Tp↑1 = Tp(Tp↑0) ∪ Tp↑0
    Tp↑2 = Tp(Tp↑1) ∪ Tp↑1
    Tp↑n+1 = Tp(Tp↑n) ∪ Tp↑n
    Tp↑ω = ∪(n=0,∞)Tp↑n

エルブランの定理：
以下が成立する。

1. Tp↑ω は、Tpの最小不動点 Lfp(Tp) である。
2. Tp↑ω は、最小エルブランモデルである。
3. A∈Tp↑ω のAは、プログラムPの論理的帰結である。


## 最大不動点

Tpの最大不動点 Gfp(Tp) = Tp↓(ω+1) ⊆Bp を次のようにもとめる。
最小不動点と異なり Gfp(Tp)≠Tp↓ω  である。
 
    Tp↓0 = Bp
    Tp↓1 = Tp(Tp↓0) ∩ Tp↓0
    Tp↓2 = Tp(Tp↓1) ∩ Tp↓1
    Tp↓n+1 = Tp(Tp↓n) ∩ Tp↓n
    Tp↓ω = ∩(n=0,∞)Tp↓n
    Gfp(Tp) = Tp↓(ω+1) = Tp(Tp↓ω)
    

## エルブラン・ベースの部分集合の関係

プログラムPにおいて、次の関係が成立する。

    {} ⊆ Tp↑ω ⊆ Gfp(Tp) ⊆ Tp↓ω ⊆ Bp

それぞれに含まれる原始論理式は、以下の意味をもつ(「-」は差集合）。

 + Tp↑ω             ：プログラムPの論理的帰結である。
幅優先の探索（ハイパーレゾリューション）で証明できる。正しい。

 + Gfp(Tp) - Tp↑ω   ：無限の探索木が作られる（無限ループ）。証明できない。

 + Tp↓ω   - Gfp(Tp) ：無限のバックトラックが起きる。証明できない。

 + Bp      - Tp↓ω   ：有限の探索木で失敗する。有限失敗(Fp)。


## 否定との関係

それぞれに含まれる原始論理式Aの否定(\+ A)は、以下の意味をもつ。

 + Bp - Tp↑ω   ：閉世界仮説に基づいて、\+Aが推論される。
 + Bp - Gfp(Tp) ：エルブラン規則により、\+Aが推論される（要補足）。
 + Bp - Tp↓ω   ：失敗を否定とみなす規則により、\+Aが推論される。


# 例1
## プログラムP
プログラムPを以下とする。 ([文献1]p.158)

    n(0).                           % (1)
    n(s(X)) :- n(X).                % (2)
    d(s(X)) :- d(X).                % (3)
    loop1 :- loop1.                 % (4)
    loop2 :- d(X), n(X).            % (5)

## エルブラン・ベースBp
プログラムPのエルブラン・ベースBpは、

    Bp = {loop1, loop2,
          n(0), n(s(0)), n(s(s(0))),....
          d(0), d(s(0)), d(s(s(0))),....}

## 関数Tp
関数Tpの実行例を示す。

    Tp({loop1, d(0)}) = {loop1, d(s(0)), n(0)}

値の最初の要素は(4)、二番目は(3)、三番目は(1)の節を使う。

## 最小不動点

    Tp↑0 = {}
    Tp↑1 = {n(0)}
    Tp↑2 = {n(s(0)), n(0)}
    Tp↑3 = {n(s(s(0))), n(s(0)), n(0)}
    Tp↑ω = {n(s(s(...(0)))), .... , n(s(s(0))), n(s(0)), n(0)}


## 最大不動点

    Tp↓0 = Bp = {loop1, loop2, n(0), n(s(0)), n(.).. , d(0), d(s(0)), d(.).. }
    Tp↓1      = {loop1, loop2, n(0), n(s(0)), n(.).. ,       d(s(0)), d(.).. }
    Tp↓2      = {loop1, loop2, n(0), n(s(0)), n(.).. ,              , d(.).. }
    Tp↓ω      = {loop1, loop2, n(0), n(s(0)), n(.).. ,                       }
    Gfp(Tp)   = {loop1,        n(0), n(s(0)), n(.).. ,                       }

Tp↓ω で、節3によってd(.)が消える。
Gfp(Tp)=Tp(Tp↓ω)で、節5によってloop2が消える。

 + Gfp(Tp) - Tp↑ω   = {loop1} （無限ループ）
 + Tp↓ω   - Gfp(Tp) = {loop2} （無限バックトラック）
 + Bp      - Tp↓ω   = {d(0), d(s(0)), ... } （有限失敗）


# Prolog（深さ優先探索）との関係

## プログラム2
[文献2.]p.58
  
    p(X, Z) :- q(X, Y), p(Y, Z).        % (1)
    p(X, X).                            % (2)
    q(a, b).                            % (3)

最小不動点は以下になる。

   Tp↑1 = {q(a, b)}
   Tp↑2 = {p(a, b), q(a, b)}
   Tp↑ω = {p(a, b), q(a, b)}

p(a, b) は、Tpの最小不動点に含まれるので、論理的帰結である。しかし、
最左深さ優先の計算規則のとき、有限の木でrefutationが成立する。
最右深さ優先の計算規則のとき（または、(1)節の尾部のqとpを逆にする）、
無限の木が作られ、証明が終わらない。


## プログラム3
[文献2.]p.62

    p(a, b).                             % (1)
    p(c, b).                             % (2)
    p(X, Z) :- p(X, Y), p(Y, Z).         % (3)
    p(X, Y) :- p(Y, X).                  % (4)

最小不動点は以下になる。

    Tp↑1 = {p(a, b), p(c, b)}
    Tp↑2 = {p(b, a), p(b, c), p(a, b), p(c, b)}
    Tp↑3 = {p(a, c), p(b, b), p(b, a), p(b, c), p(a, b), p(c, b)}
    Tp↑ω = ...

p(a, c)は、Tpの最小不動点に含まれるので、論理的帰結である。しかし、
Prologで、深さ優先探索をおこなうがぎり探索木は無限になり終了しない。
計算規則や節の順番を入れ替えても、深さ優先探索をする限り解消できない。


## プログラム4
[文献1]p.158

    loop1 :- loop1.
    loop3 :- loop1, loop0.
    loop4 :- loop0, loop1.

最大不動点は以下になる。

    Tp↓0 = Bp = {loop0, loop1, loop3, loop4}
    Tp↓1      = {       loop1, loop3, loop4}
    Tp↓2      = {       loop1              }
    Tp↓ω      = {       loop1              }
    Gfp(Tp)   = {       loop1              }

loop0, loop3, loop4 は、有限失敗（Fp = Bp - Tp↓ω）だが、
loop3は、最左深さ優先の計算規則の場合は探索木が無限になり、無限ループになる。
loop4は、最右深さ優先の計算規則の場合は探索木が無限になり、無限ループになる。


# 参考文献

1. 萩谷、「論理プログラム混沌の中」bit Vol.16, No.6 共立出版
2. J.W.ロイド、佐藤 他訳「論理プログラミングの基礎」産業図書

以上