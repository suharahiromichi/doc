PrologのCutとリファクタリングの話
==============

2014/12/07 @suharahiromichi


Prologのコードのリファクタリングを通して、Cutの意味、大げさにいうとPrologプログラムの手続的意味を考えてみたい。


# もとのプログラム
もとのプログラムは次のようなもので、大学の課題として作成されたようだ。
「ストリームから項を入力して、引数で与えられた項とマッチする項だけを印刷する」



```prolog:

findallterm(Term) :-
        read(Term0),
        process(Term0, Term).

process(end_of_file, _) :- !.
process(Term0, Term) :-
        (not(Term0 = Term), !;
         write(Term0 ), nl),
        findallterm(Term).


```
このプログラムが解りにくいのは、notとcutとorが連続していることである。C言語の

    (Term0 != Term) || write(Term0)
に似ているというより、まったくそのもので、

    「!=」が成立しなければ（つまり「=」なら）、writeする。
という失礼ながら、Cのプログラムとしても駄目出しされそうである。


# ORをやめる
一旦、頭部パターンマッチングをやめ、Term0 = end_of_file を追加する。ここでは、説明のために、true述語を補った。trueは常に成功するので、なにもしないのと同じである。
さらにOR（「;」）をやめてみる。(A;B)のAが成立する場合と、Bが成立する場合で節を分けることで実現できる。もとのプログラムではAの中にcut（「!」）が入っていたが、そのまま残してよい。


```prolog:

findallterm1(Term) :-
        read(Term0),
        process1(Term0, Term).

process1(Term0, _) :-
        Term0 = end_of_file, !,
        true.
process1(Term0, Term) :-
        not(Term0 = Term), !,
        findallterm1(Term).
process1(Term0, Term) :-
        write(Term0 ), nl,
        findallterm1(Term).


```

# NOTをやめる
process1の第2節と第3節を入れ替え、「=」の判定を先にするることで、notが止められる。


```prolog:

findallterm2(Term) :-
        read(Term0),
        process2(Term0, Term).

process2(Term0, _) :-
        Term0 = end_of_file, !,
        true.
process2(Term0, Term) :-
        Term0 = Term, !,
        write(Term0 ), nl,
        findallterm2(Term).
process2(Term0, Term) :-
        findallterm2(Term).


```
Process2をみると、

     P :- Q1, !, R1.
     P :- Q2, !, R2.
     R :- S.
の形式になっていて、これは、Prologのcutを含む節の一般的なかたちである。

          if Q1 then R1
     else if Q2 then R3
     else S
という、if-then-elseのかたちに他ならない。  


# if-then-else (Q -> R ; S) にする
大抵のProlog処理系は「if Q then R else S」を表すメタ述語 (Q -> R ; S) を持っているから、これを使ってみる。elseのところでネストしている。


```prolog:

findallterm3(Term) :-
        read(Term0),
        (Term0 = end_of_file ->
            true;
         Term0 = Term ->
            write(Term0 ), nl,
            findallterm3(Term);
         findallterm3(Term)).


```
これは、ほとんど手続型言語といえそうである。
Prologのif-then-elseを使うことの是非は議論になりそうだが、これはひとつの完成形だろう。


# 頭部パターンマッチングを使う
前にもどって、頭部パターンマッチングを使うようにする。Term0 = end_of_file はもちろん、「=」の判定である Term0 = Term もパターンマッチングで済む。


```prolog:

findallterm4(Term) :-
        read(Term0),
        process4(Term0, Term).

process4(end_of_file, _) :- !.
process4(Term, Term) :- !,
        write(Term), nl,
        findallterm4(Term).
process4(_, Term) :-
        findallterm4(Term).


```
もとのプログラムにくらべて、findallterm(Term) の呼び出し（再帰呼出）が2箇所になったのが気になるかもしれない。しかし、Term0=Termが成立しても、そうでなくても、次の項の処理のために再帰を実行するのだから、2箇所で再帰するほうが本質的と考えられる。もちろんオーバーヘッドはない。たとえば、マッチした最初のひとつで終わるとか、たかだが3個だけ出力するといった具合に「仕様変更」が生じた場合には、このほうが対応し易いはずだ。
以上の話とは別に、Prologには repeat-fail による繰り返しがある。それとの比較については議論を避けた。別の誰かが書くだろう。


```
