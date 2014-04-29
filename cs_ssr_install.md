SSReflectのインストール
========
2013/08/26 @suharahiromichi

2013/10/26 @suharahiromichi 追記

2014/04/29 @suharahiromichi 追記

# はじめに

最新の事項については、
みずぴー日記 ssreflectインストール方法まとめ(Windowsもあるよ!)
http://mzp.hatenablog.com/entry/2014/04/29/105144
を参照してください。

以下は、私自身の控えとして、設置作業の記録を残したものです。
SSReflectの設置（インストール）は、原則として、
SSReflectの配布物にある INSTALL ファイルに基づいておこなってください。

なお、[文献1.]のInstallの節の内容は、役に立ちません。

# 準備

## 設置するもの
以下を設置する。

1. coq-8.4pl2
2. ssreflect-1.4

SSReflectの設置には、
「同じバージョンのOCamlでビルドされたCoq」が必要である。
だから、既にCoqが設置されていても、Coq本体もソースコードからビルドして入れ直すべきである。

## インストール先

    /usr/local/bin

バイナリパッケージなどでCoq本体を既に /usr/bin に設置している場合(Ubuntuなど)であっても、
それはそのままにして、指示通りソースコードから入れ直すことにする。


## 入手元

 + coq-8.4pl2

http://coq.inria.fr/download から coq-8.4pl2.tar.gz (ソースコード)

 + ssreflect-1.4 (for Coq 8.4)

https://gforge.inria.fr/frs/?group_id=401 から ssreflect-1.4-coq8.4.tar.gz

同じ場所に「for Coq 8.3pl4」 も置いてあるので、間違えないようにすること。


## その他のバージョン情報

    OCaml         3.12.1
    Camlp5        6.02.3
    GNU Make      3.81  
    Ubuntu        12.04 LTS   (i386)
    GNU Emacs     23.3.1
    ProofGeneral  4.2 

## 追記 (2013/10/26)

Coq、SSReflectに加えて、Camlp5 も同一のバージョンのOCamlでビルドするべきのようだ。
今回は、Camlp5は、信頼の置けるバイナリパッケージ(Ubutu、FreeBSD)から設置したが、
Camlp5もソースコードからコンパイルするとよいようだ。

## 注意

 + BSD系のOSも同様の手順で可能だが、その場合は、gmakeでGNU Makeを使う。

 + ビルドの過程で coqtop がメモリをかなり(〜1GB)消費するため、
主記憶が小さいマシンでは時間がかかる。
VMwareなどの仮想マシンを使っている場合に注意が必要である。


# 設置手順

## Coq本体
Coq本体の配布物を展開し、以下をおこなう。

    cd coq-8.4pl2
    ./configure
    make world
    sudo make install

configureは、省略時解釈（ディフォルト）で/usr/localに設置になる。

## 環境変数の設定

  setenv COQBIN /usr/local/bin/

最後の/を忘れないようにする。
もし必要ならば、PATHを/usr/local/binが/usr/binの前になるように設定する。


## SSReflect
SSReflectの配布物を展開して、以下をおこなう。

    cd ssreflect-1.4
    make
    sudo make install
  
最初のmakeでエラーが出たら、次のようにやり直す。

    make clean
    make
    sudo make install


## ProofGeneral for ssreflect syntax

ProofGeneral自体の設置方法は省略する。
SSReflectの配布物に含まれる、pg-ssr.el を
emacs lispのパスを通ったところ(例：$HOME/lisp/)にコピーする。

~/.emacsなどに以下の行を追加する。

    (load-file "/usr/share/emacs/site-lisp/ProofGeneral/generic/proof-site.el")
    (load-file "$HOME/lisp/pg-ssr.el")


# 補足

タクティクスについてのノート（暫定版）

https://github.com/suharahiromichi/doc/blob/master/cs_ssr_note.md


# 文献

1. Georges Gonthier, Assia Mahboubi,
"A Small Scale Reﬂection Extension for the Coq system", INRIA

以上
