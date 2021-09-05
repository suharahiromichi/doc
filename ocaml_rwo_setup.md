Real World OCaml (RWO) のためのセットアップ
---------------------

# opam install

- base
- core

- tuareg
- merlin
- utop
- dune


# .emacs の設定

```
;; tuareg
(load "~/.opam/4.07.1/share/emacs/site-lisp/tuareg-site-file")
(setq auto-mode-alist (cons '("\\.ml\\w?" . tuareg-mode) auto-mode-alist))
(autoload 'tuareg-mode "tuareg" "Major mode for editing Caml code" t)

;; merlin-mode
(let ((opam-share (ignore-errors (car (process-lines "opam" "config" "var" "share")))))
  (when (and opam-share (file-directory-p opam-share))
    ;; Register Merlin
    (add-to-list 'load-path (expand-file-name "emacs/site-lisp" opam-share))
    (autoload 'merlin-mode "merlin" nil t nil)
    ;; Automatically start it in OCaml buffers
    (add-hook 'tuareg-mode-hook 'merlin-mode t)
    (add-hook 'caml-mode-hook 'merlin-mode t)
    ;; Use opam switch to lookup ocamlmerlin binary
    (setq merlin-command 'opam)))

;; utop
(setq opam-share 
  (substring (shell-command-to-string "opam config var share 2> /dev/null") 0 -1))
(add-to-list 'load-path (concat opam-share "/emacs/site-lisp"))
(require 'utop)
```

とりあえず ~/.ocamlinit と 各ディレクトリの ./.merlin は作らないでおく。


# utop on emacs からの実行

- emacs から M-x utop を実行する。入力の最後は<Enter>である。

- ライブラリを使えるようにする。

```
#reuqre "base";;
open Base;;
```

を実行してから、テキストの内容を実行する。``#require`` が必要である。
大文字小文字と「"」の有無に注意すること。


- 既存のコードを使う（その1）

ソースコードは以下で読み込む。

```
#use "sum.ml";;
```

ファイルを単純に読むため、分割コンパイル単位が module と解釈されず、エラーになる。



- 既存のコードを使う（その2）

バイナリは ``ocamlc -c`` で cmo ファイル（ocamlrun）を作り、以下で読み込む。

```
#load "risc.cmo";;
open Risc;;
```

さらに明示的に module を定義している場合は open が必要である。



# dune

ml のソースコードに ``#require`` は不要である。あるとエラーになる。
RWOのduneの説明は簡略なので、以下を参考にする。

[https://e-tec-memo.herokuapp.com/article/317/]


コマンドラインから以下を実行する。変えられるのは myfreq のみである。


```
% dune init project myfreq
```

```
myfreq
├── bin
│   ├── dune
│   └── freq.ml
├── lib
│   ├── dune
│   ├── counter.mli
│   └── counter.ml
├── myfreq.opam
└── test
    ├── dune
    └── myfreq.ml
```

- bin/dune は、

```
(executable
 (public_name myfreq)
 (name freq)
 (libraries counter base stdio))
```

mame には複数指定でき、その場合は ``dune build`` の次に指定するようだ。


- lib/dune は、

```
(library
 (name counter)
 (libraries base stdio))
```

コマンドラインから

```
dune build
```

を実行すると、``_build/default/bin/freq.exe`` が作られる。


以上
