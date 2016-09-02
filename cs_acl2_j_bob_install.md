"The Little Prover" - J-BOBの実行まで（ACL2版）
=======================

2016_05_26 @suharahiromichi

# 環境

## OS

FreeBSD/i386 で、故あって未だ32bit環境を使用している。
64bit環境ならば、後のようにHeapの不足は生じないだろう。

```
% uname -a
FreeBSD faure 10.2-RELEASE FreeBSD 10.2-RELEASE #0 (略)  i386
```

## Common Lisp

Common Lisp は既にインストール済みの SBCL を使用した。

```
% sbcl -v
This is SBCL 1.2.9, an implementation of ANSI Common Lisp.
More information about SBCL is available at <http://www.sbcl.org/>.
```

## Emacs

``GNU Emacs 24.5.2 (i386-portbld-freebsd10.2, GTK+ Version 2.24.28)``


# ACL2 のインストール

手順で示す。なお、~/WORK/proj/ というディレクトリは適宜読み替えてください。

- acl2 は、``~/WORK/proj/acl2-7.2``
- j-bobのacl2版は、``~/WORK/proj/j-bob/acl2``

acl2.sh のスクリプトは、``~/bin/`` に置いた。


## ACL2の入手

http://www.cs.utexas.edu/users/moore/acl2/ から acl2-7.2.tar.gz


## コンパイルからインストールまでの手順


```
% mkdir ~/WORK/proj
% cd ~/WORK/proj
% tar xzvf acl2-7.2.tar.gz
% cd acl2-7.2
% vi cl.sh      (注1)
% chmod 777 cl.sh
% gmake LISP=./cl.sh
% cp saved_acl2 acl2.sh
% vi acl2.sh    (注2)
% cp acl2.sh ~/bin
% rehash
% acl2.sh
ACL2 !>(good-bye)
%
```

- (注1) SBCLの場合、32bit OSではコンパイル時にHeapが不足するので、それを避け
るためのスクリプトを acl2-7.2 のディレクトリに用意して、それを指
定してビルドする。--dynamic-space-size 1600 の1600は自分の環境に合わせ
て設定する。大きすぎてもエラーになる。

```
% cat cl.sh 
#!/bin/sh
/usr/local/bin/sbcl --dynamic-space-size 1600 "$@"
```

- (注2) ビルドすると、saved_acl2 というshスクリプトが生成される。
それをacl2.sh にコピーしたのち修正する。
そこに含まれる``--dynamic-space-size 2000`` の2000は自分の環境に合わせて設定する。
1600にした。

```
% cat acl2.sh
#!/bin/sh
# Saved May 27, 2016  23:13:34
export SBCL_HOME="/usr/local/lib/sbcl"
exec "/usr/local/bin/sbcl" --dynamic-space-size 1600       \
 --control-stack-size 64                                   \
 --core "/Users/suhara/WORK/proj/acl2-7.2/saved_acl2.core" \
 --end-runtime-options --no-userinit                       \
 --eval '(acl2::sbcl-restart)' "$@"
```

（見やすく改行した）


# The Little Prover のサンプルコード (J-BOB) の実行


## J-BOBの入手

```
% cd ~/WORK/proj
% git clone https://github.com/the-little-prover/j-bob
```

## J-BOBの実行例


``ACL2 !>`` がプロンプトである。

```
% cd ~/WORK/proj/j-bob/acl2
% acl2.sh 
略
ACL2 Version 7.2.  Level 1.  Cbd "/Users/suhara/WORK/proj/j-bob/acl2/".
System books directory "/Users/suhara/WORK/proj/acl2-7.2/books/".
Type :help for help.
Type (good-bye) to quit completely out of ACL2.

ACL2 !>(include-book "j-bob-lang")
略

ACL2 !>(include-book "j-bob")
略

ACL2 !>(include-book "little-prover")
略

ACL2 !>(dethm.align/align)
((DETHM ATOM/CONS (X Y)
        (EQUAL (ATOM (CONS X Y)) 'NIL))

略
 (DETHM ALIGN/ALIGN (X)
        (EQUAL (ALIGN (ALIGN X)) (ALIGN X))))
ACL2 !>^D
%
```

# Emacs インターフェース

## ~/.emacs の設定

~/.emacs （または ~/init.el など) に以下を追加する。

```.emacs
(defvar acl2-skip-shell t)
(defvar *acl2-shell* "*inferior-acl2*")
(defvar inferior-acl2-program "acl2.sh")
(load-file "$HOME/WORK/proj/acl2-7.2/emacs/emacs-acl2.el")
```

注意

``emacs-acl2.el`` のパスは各自の環境にあわせる。ただし、ACL2に含まれる
他のelispファイルにも依存するので、場所を移動してはいけない。

``acl2.sh`` は上記の実行例と同じ起動スクリプトである。実行パスが通って
いるところに置いてあるならば、フルパスで指定する必要はない。


## 起動方法

``cd ~/WORK/proj/j-bob/acl2; emacs``

Emacsを起動する。Emacs を起動したディレクトリが実行時のカレントディレ
クトリ、すなわち、ACL2のinclude-book の起点になる。


## 主なコマンド


``M-x run-acl2`` -- ACL2を実行するバッファ（実行バッファ）を開き、ACL2
を起動する。上記の設定の場合は``acl2.sh``。


以降、プログラム（証明）の編集は任意のバッファでおこなう（編集バッ
ファ）。編集バッファで以下のコマンドが使える。


``C-t C-e`` -- カーソルのある定義などを実行バッファに送る。

``C-t l`` -- リージョン（選択した範囲）を実行バッファに送る。


## 補足説明

ProofGeneral は、

``
ACL2 Proof General is incomplete!  Please help improve it!
Please add improvements at http://proofgeneral.inf.ed.ac.uk/trac"
``

なので、ACL2に付属の ``emacs/emacs-acl2.el`` を使う。これをロードする
**だけ** で ``*shell*`` バッファが開くので、そこで実行例の ``acl2.sh``
以降を実行してもよい。このとき、acl2 関連のコマンドは ``*shell*`` バッ
ファに送られる。

いきなり ``*shell*`` バッファが開くのが嫌な場合は、``~/.emacs`` に上記
の設定をする。すると、``M-x run-acl2`` で ``*inferior-acl2*`` バッファ
が開かれそこで acl2 が起動する。acl2 関連のコマンドは
``*inferior-acl2*`` バッファに送られる。


``acl2.sh`` が実行されたディレクトリがカレントディレクトリになり、
``(include-book "j-bob")`` などインクルードの起点はカレントディレクト
リになる。そのため、Emacs の起動は、ACL2を実行するときのカレントディレ
クトリでおこなう必要がある。

ACL2 のインクルードパス、とくにEmacsバッファから使う場合の詳細について
は調査中です。

**以上**
