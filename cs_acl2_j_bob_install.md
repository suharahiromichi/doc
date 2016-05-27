ACl2のインストールからサンプルの実行まで
=======================

"The Little Prover"

2016_05_26 @suharahiromichi

# サンプルコードの実行まで

## 環境

### OS

FreeBSD/i386 で、故あって未だ32bit環境を使用している。
64bit環境ならば、後のようにHeapサイズの不足は生じないだろう。

```
% uname -a
FreeBSD faure 10.2-RELEASE FreeBSD 10.2-RELEASE #0 (略)  i386
```

### Common Lisp

Common Lisp は既にインストール済みの SBCL を使用した。

```
% sbcl -v
This is SBCL 1.2.9, an implementation of ANSI Common Lisp.
More information about SBCL is available at <http://www.sbcl.org/>.
```

## acl2 のインストール

手順

なお、全体に ~/WORK/proj/ というディレクトリに作っている。

- acl2 は、``~/WORK/proj/acl2-7.2``
- j-bobのacl2版は、``~/WORK/proj/j-bob/acl2``
- acl2.sh のスクリプトは、``~/bin/`` に置いた。

1. 入手

http://www.cs.utexas.edu/users/moore/acl2/ から acl2-7.2.tar.gz

2. コンパイルからインストールまでの手順

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

- SBCLの場合、32bit OSではコンパイル時にHeapが不足するので、それを避け
るためのスクリプト(注1)を acl2-7.2 のディレクトリに用意して、それを指
定してビルドする。--dynamic-space-size 1600 の1600は自分の環境に合わせ
て設定する。大きすぎてもエラーになる。

```
% cat cl.sh 
#!/bin/sh
/usr/local/bin/sbcl --dynamic-space-size 1600 "$@"
```

- ビルドすると、saved_acl2 というshスクリプトが生成される。それを
  acl2.sh にコピーしたのち修正する。そこに含まれる
  --dynamic-space-size 2000の2000は自分の環境に合わせて設定する。
  1600にした。

```
% cat acl2.sh
#!/bin/sh
# Saved May 27, 2016  23:13:34
export SBCL_HOME="/usr/local/lib/sbcl"
exec "/usr/local/bin/sbcl" --dynamic-space-size 1600
--control-stack-size 64
--core "/Users/suhara/WORK/proj/acl2-7.2/saved_acl2.core"
--end-runtime-options --no-userinit
--eval '(acl2::sbcl-restart)' "$@"
```

（見やすく改行した）


### The Little Prover の実行

1. サンプルの入手

% cd ~/WORK/proj
% git clone https://github.com/the-little-prover/j-bob

2. 実行例

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

**以上**
