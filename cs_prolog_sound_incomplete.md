(CS) Prologは定理証明系として健全だが完全ではない
==============
2013/08/15      @suharahiromichi

# Prologの健全性と完全性
第一階述語論理（Horn節に限定）の定理証明系として、Prologは、健全(sound)だが完全(complete)ではない。

* 健全性：××が健全とは、全ての、××で証明できる論理式は、充足可能な論理式である。
* 完全性：××が完全とは、全ての、充足可能な論理式は、××で証明できる論理式である。

 + 「全ての」は論理式にかかる。
 + 「充足可能」とは、変数に具体的な値を当てはめて、と言い換えてよい。ただし述語論理なので。
 + 「証明できる」とは、_有限_の証明がある、と言い換えてよい。
 + 健全性と完全性は、「逆」の関係にある。


## 導出原理(Resolution)
Resolutionは、健全かつ完全である。

コワルスキの「論理による問題の解決」には、
>証明手続の完全性を保証するためには、
>探索空間が完全であるばかりでなく、
>探索戦略もすべての場合を尽くさなければならない。

と書いてある。これはPrologについて述べてはいない。

以下の講義資料では、定理証明系Coqを使って健全性を証明している。
完全性を証明していないのは難しいからだろうか。
http://www.math.nagoya-u.ac.jp/~garrigue/lecture/2013_SS/coq14.pdf


## 出現チェック(Occurs Check)
ResolutionにおいてOccurs Checkを省くと__健全性__が失われる。

節 p(X, f(X)). に対して、論理式 p(X, X)が証明ができてしまうが、これは充足可能ではない。
すなわち、健全性に対する反例になっている。

Occurs Checkを省いても証明できる論理式が減ることはない。
だから、完全性が失われることはない。


## Prolog
Prologは、深さ優先探索をするので、__完全性__が保証されない。

Prologは、Resolutionにおける節の選択を、最左から深さ優先で探索することで実行するものである。
そのため、最左の論理式が無限に探索できてしまう場合、その論理式は証明できないことになる。
すなわち、完全性に対する反例になっている。

健全性はResolutionの場合と同様に成立する。ひとたび証明できてしまえば同じだから。



## 失敗による否定
失敗を否定とみなす規則は、健全かつ完全である。


# 課題のようなもの
## CoqによるResolutionの完全性の証明
講義で証明れている健全性にたいして、

    Theorem soundnes forall n s' v v' pl, 
    In (State s' v' nil) 
       (iter n expand_all (State nil v pl :: nil))
    -> derivable (map (subs_pred s') pl).
    
その逆の完全性を証明したい。（例）

    Theorem complete forall n s' v v' pl, 
    derivable (map (subs_pred s') pl).
    -> In (State s' v' nil) 
       (iter n expand_all (State nil v pl :: nil))


## Prologの個々のプログラムの完全性の証明

型付きラムダ式の型推論を行うプログラム

    https://github.com/suharahiromichi/prolog/blob/master/tapl/tapl_type_stlc.swi

は、論理式をPrologで証明しているとみてよいので、結果として完全性が保証されないのだろうか。

ならば、どうすればよいのだろうか。型推論の健全性と完全性

* 健全性：あるプログラムの型推論で得られる、全ての型の組み合わせは、そのプログラムに正しく型を与える。
* 完全性：あるプログラムに正しく型を与える、全ての型の組み合わせは、そのプログラムの型推論で得られる。

 + 「全ての」は「型の組み合わせ」に掛かる。
 + 正しく型が与えられたプログラムは、エラーなく実行できる（安全性 (=進行性と型の保存性)）。


# 参考文献

* R.コワルスキ、浦監訳「論理による問題の解決」培風館
* J.W.ロイド、佐藤他訳「論理プログラミングの基礎」産業図書
* ジャック・ガリグ、 2013年度前期・数理解析・計算機数学 II (同 概論II)、名古屋大学大学院多元数理研究科
http://www.math.nagoya-u.ac.jp/~garrigue/lecture/2013_SS/index.html
* 五十嵐 淳「ＭＬ型推論の光と影」、京都大学
http://www.sato.kuis.kyoto-u.ac.jp/~igarashi/class/isle4-11w/OCaml-meeting0908-revised.pdf

__以上__

