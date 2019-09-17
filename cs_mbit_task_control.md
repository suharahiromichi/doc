micro:bit のタスク制御
=================
2019_09_17

@suharahiromichi 

# はじめに

子供向けのワンボードコンピュータである micro:bit は、[1.]で紹介されているように、
MakeCode (https://makecode.microbit.org) という「ブロック」プログラミング によって、
簡単にプログラムを書くことができます。

micro:bit は、ARM社の mbed プラットフォーム([2.])の上に実装されていますが、
それを意識することはなく、DAL (Device Abstruct layer [3.]) と、
MakeCode のランタイムルーチン([4.])とで動作しています。

ランタイムでは、fiber と呼ばれる軽量スレッドにもとづくnon-preemptiveなタスク制御が
実現されているようですが、資料がありません（すくなくとも、私には見つけられませんでした）。
[5.] はすこしだけ詳しいですが、パワポなので断片的な内容です。

そこで、サンプルコードと[2.][3.]とを照らして、推測をしてみました。

お断り：私は制御系のプログラマですが、組込系の実務に携わっていたのは遠い昔です。
また、Microsoft社の資料にアクセスできない（していない）ので、
あるいはそこに詳しい情報があるのかもしれません。
その場合は、コメントいただければ反映させていただきます。

ご注意：ブロック・プログラミングの「ブロック」と、タスクがblockされる(block状態になる)
どちらもブロックで紛らわしいのですが、このように書き分けるようにします。


# サンプルコード

サンプルコードを図に示します。
(実際にQiitaに投稿するなら、「ブロック」の絵にすること。

```
input.onButtonPressed(Button.A, function () {
    while (true) {
        basic.showString("AAAAA")
        basic.pause(100)
    }
})
input.onButtonPressed(Button.B, function () {
    while (true) {
        basic.showString("BBBBB")
        basic.pause(100)
    }
})
let count = 0
basic.forever(function () {
    count += 1
    basic.showNumber(count % 10)
})
```


- LEDに0〜9までの数字を繰返して表示する。（数字表示と呼ぶ)
- ボタンAが押されたら``AAAAA``のスクロール表示を繰返す。(AAAAA表示と呼ぶ)
- ボタンBが押されたら``BBBBB``のスクロール表示を繰返す。(BBBBB表示と呼ぶ)


ボタン押下で起動する処理のなかで無限ループを実行していることがポイントです。

このプログラムは、次のように動作します。
micro:bit のボードがなくても、MakeCodeのシミュレータで試すことができ、同じ結果になります。
（当初、ボタンAとボタンBの処理にwaitを入れていなかったら、
シミュレータと実機で違う結果になった。実機ではAAAAAの繰返しだけ）


1. リセットすると、数字表示する。

2. 数字表示 ``5`` の表示中に、ボタンA を押すと、
   AAAAA表示を *1回* だけする。

3. 数字表示 ``6`` を表示する。その後、AAAAA表示を *1回* だけする。
   以降、数字表示を更新しながら、これを繰り返す。

4. AAAAA表示の途中で、ボタンB を押すと、
   AAAAA表示を終わった後、数字表示 ``7`` を表示する。

5. 以降、AAAAA表示、数字表示、BBBBB表示、AAAAA表示、数字表示、BBBBB表示と繰返す。


# なにが起きているか

1. メインループである「ずっと」は、単純なループではなく、
   ループ1回毎に 20msec のwait をする。また、1文字表示する後に wait して、CPUを放棄する
   (main fiber)。

2. ボタンA を押すと、そのタスク(fiber)が、起動する。
   メインループ1回毎、または、1文字表示毎の wait で、
   main fiber が中断したタイミングで動作する。
   一回のスクロール表示のが終わるまでCPUを占有する。
   スクロール表示が終わったタイミングで wait して、CPUを放棄する (ボタンA fiber)。
   
3. ボタンB については、2.と同様（ボタンB fiber)。
   main → ボタンB → ボタンA → main の順番で動作する理由は、
   ボタンを押すタイミングにもよるかもしれないが、判らない。


# ソースコードとの対応

わたしは読み解けた範囲で、ランタイムおよびDALとの対応を示します。

## ずっと (forever)

- https://github.com/microsoft/pxt-microbit
  libs/core/basic.cpp の forever が「ブロック」に対応する。

- https://github.com/microsoft/pxt-microbit
  libs/core/codal.cpp の runForever がmain fiber の実体か。

fiber を作り forever_stub を実行する。
forever_stub は、1回実行下後 20msec wait する（CPUを放棄する)。


## LED表示

- https://github.com/microsoft/pxt-microbit
  libs/core/basic.cpp の showString が「ブロック」に対応する。

- https://github.com/lancaster-university/microbit-dal
  source/drivers/MicroBitDisplay.cpp

  printChar     1文字の場合、表示後にwaitする（CPUを放棄する)。
  scroll        2文字以上の場合、全文字表示後にwaitする（CPUを放棄する)。



# 文献

[1.] インターフェース 2018.6 CQ出版社

[2.] https://www.mbed.com

[3.] https://github.com/lancaster-university/microbit-dal

[4.] https://github.com/microsoft/pxt-microbit

[5.] https://www.microsoft.com/en-us/research/wp-content/uploads/2016/07/Ball_Tom_FS2016_Microbit.pdf

以上
