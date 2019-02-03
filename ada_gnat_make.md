GNATによるAdaプログラムの手動ビルド（誰得）
========
2015/01/31 @suharahiromichi

# はじめに

Ada言語は、分割コンパイルに際してコンパイル順序が厳しく定められているため、
通常は処理系の用意するユーティリティを使用してコンパイルをおこなうのが普通である。
C言語のように、プログラマが依存規則を書くことはない。

しかし、C言語のメインルーチンからAdaで書いた処理を呼び出す場合、
標準のユーティリティが使用できない。

そこで、手動でコンパイルする方法をまとめてみたい。
もっとも、自動の場合と同じことを行うわけだけれど。


# 例題プログラム

データテーブルをふたつ用意する。テーブルだけなので拡張子は``.ads``である。

```data1.ads:
package DATA1 is
   I : Integer;
   J : Integer;
end DATA1;
```

```data2.ads:
package DATA2 is
   K : Integer;
end DATA2;
```

数学演算ライブラリ（のつもり）のものを用意する。仕様と本体をわける。

```mathlib.ads
package Mathlib is
   function X2(X : Integer) return Integer;
end Mathlib;
```

```mathlib.adb
package body Mathlib is
   function X2(X : Integer) return Integer is
   begin
      return X * 2;
   end X2;
end Mathlib;
```

メイン手続きPARENTを用意する。グローバルなテーブルに値をセットして、
下位処理CHILDを呼び出して、また、グローバルなテーブルを参照する処理である。

```parent.adb
procedure PARENT is
   procedure CHILD is separate;
begin
   I := 1;
   J := 20;
   CHILD;
   K := J + I;
   
   Put_Line("Hello");
   Put(K, 10);                          --  10桁表示
end PARENT;
```

parent.adbにおいてCHILDは「副単位」になっているので、
CHILDを定義するファイルparent-child.adbは、親-子の関係にある。
子のファイルは、このように、親（祖先）の名前を「-」で継ぐのが、GNATの規則である。

```parent-child.adb
with DATA1; use DATA1;
with DATA2; use DATA2;
with Mathlib; use Mathlib;

separate (PARENT)

procedure CHILD is
begin
   I := X2(I);
   J := X2(J);
end CHILD;
```

# 自動にbuild

通常は、以下だけでビルドできる。
```
% gnatmake parent
```

その時、以下が実行される。

```
gcc-4.6 -c parent.adb
gcc-4.6 -c data1.ads
gcc-4.6 -c data2.ads
gcc-4.6 -c mathlib.adb
gnatbind -x parent.ali
gnatlink parent.ali
```

```
% /parent 
Hello
        42
```

parent-child.adb がコンパイルされていないように見えるが、
ちゃんと反映されている。インラインで展開されているのだ。
data1.adsとdata2.adsはコンパイルされるが、
mathlib.ads (仕様) はコンパイルされない。
つくられた``.o``は、``data1.o  data2.o  mathlib.o  parent.o`` である。
また、``data1.ali  data2.ali  mathlib.ali  parent.ali`` もつくられる。

# 手動でbuild

手動であっても先の実行結果と同じことをすると同じことになる。すこし変えて、

```
rm -f *.o *ali parent

# コンパイルは順不同
gcc-4.6 -c data1.ads
gcc-4.6 -c data2.ads
gcc-4.6 -c parent.adb
gcc-4.6 -c mathlib.adb
gcc-4.6 -c main.c

# メインのサブルーチンであるparent.aliから。残りは順不同
gnatbind parent.ali \
    data1.ali \
    data2.ali \
    mathlib.ali \

# メインだけ指定する。
gnatlink parent
```

# C言語のメイン

ここからが本題である。C言語のメインを用意する。

```main.c:
void adainit(void);
void adafinal(void);
void _ada_task01(void);

int
main()
{
    adainit();
    _ada_parent();
    adafinal();
}
```

gnatbind の -n と -C オプションを使って、
C言語とのインターフェースのコード``ada-control.c ``を出力させる。
ここに、adainiとadafinalが定義されている。

```warning: gnatbind switch -C is obsolescent``` という警告がでるが、
``-C``をとるとうまくかないようだ。

また、Adaの``parent``手続は、Cからは``_ada_parent``という名前で参照できる。

```
rm -f *.o *ali ada-control.c main

# 順不動
gcc-4.6 -c data1.ads
gcc-4.6 -c data2.ads
gcc-4.6 -c parent.adb
gcc-4.6 -c mathlib.adb
gcc-4.6 -c main.c

# 順不動
gnatbind -n \
    data1.ali \
    data2.ali \
    parent.ali \
    mathlib.ali \
    -C -o ada-control.c

gcc-4.6 -c ada-control.c

# オブジェクトは順不動
gcc -o main main.o \
    ada-control.o \
    data1.o data2.o mathlib.o parent.o \
    -L/usr/lib/gcc/i686-linux-gnu/4.6/adalib \
    -lgnat
```

リンクはgccを使用しておこなう。そのため、GNATのライブラリを明示的に指定する必要がある。

以上
