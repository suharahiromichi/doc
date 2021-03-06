Edison 文法メモ
=======================

2019_11_26 @suharahiromichi


# 文法

数字は説明のためのもの。

```
M ::=                                                  ; expression
      | x | c | (lambda [$x ...] M) | (M M)
      | [M ...]                                        ; tuple
      | {M ...}                                        ; collection
      | <C M ...>                                      ; inductive data
      | [| M ... |]                                    ; tensor
      | {|[key M] ...|}                                ; hash map
      | (match-all M1 M2  [p M])
      | (match     M1 M2 {[p M] ...})
      | something
      | (matcher {φ ...})

  M1 は target
  M2 は matcher
  [p M] は match clause
  p  は pattern
  M  は body


p ::= _ | $x | ,M | <c p ...>                          ; pattern
       
  $x は pattern variable
  ,M は value pattern
  c  は pattern constructor



φ ::= [pp M1 {[dp M2] ...}]                           ; matcher clause

   pp      は primitive-pattern pattern
   M1      は next-matcher exp.
   [dp M2] は primitive-data-match clause
   dp      は primitive-data pattern
   M2      は primitive-data exp.


pp ::= $ | ,$x | <c pp ...>                            ; primitive-pattern pattern

   $   は pattern hole
   $,x は value-pattern pattern
   c   は pattern constructor
   

dp := $x       | <C dp ...>                            ; primitive-data pattern

   $x は pattern variable
   C は data constructor

```

# matcher のコード例

```
(define unordered-pairs (lambda [$a]
    (matcher {
                [<pair $ $> [a a]       {[<Pair $x $y> {[x y] [y x]}]}]
                [$          [something] {[$tgt         {tgt}]}]
             })))


(define $multiset (lambda [$a]
        (matcher {
                        [<nil> [] {[{} {[]}] [_ {}]}]
                        [<cons $ $> [a (multiset a)]
                               {[$tgt (match-all tgt (list a)
                                       [<join $hs <cons $x $ts> [x (append hs ts)]])]}]
                        [,$val []
                               {[$tgt (match [val tgt] [(list a) (multiset a)]
                                      {[[<nil> <nil>] {[]}]
                                       [[<cons $x $xs> <cons ,x ,xs>] {[]}]
                                       [[_ _] {}]})]}]
                        [$ [something] {[$tgt {tgt}]}]
                 })))

(define $integer
        (matcher {
                        [,$val [] {[$tgt (if (eq? val tgt) {[]} {})]}]
                        [$ [something]      {[$tgt {tgt}]}]
                 }))

```


# matcher clause ``[pp M1 {[dp M2] ...}]`` の tuple の対応について

M2 は collectionであること。これは複数解を許すためで、空 ``{}`` は失敗を示す。

以下はすべて要素の数が同じであること。

- pp のなかの $ の数。ただし、,$x は数えない。

- M1 の評価結果の tuple の要素の数。

- (dp のなかの $x の数 ... これは、他と一致しなくてもよい)

- M1 評価結果の collection の各要素の tuple の要素の数。



# matcher clause ``[pp M1 {[dp M2] ...}]`` の計算例

- pp が、match の pattern から選ばれて、

- dp が、match の target とマッチした場合：

- そのマッチのもとで、M2 の collection が計算される。
  このとき pp が ,$x なら、x を通して、match pattern が参照できる。

- そのマッチの結果 (pattern は pattern として、target は M1 のcollection のひとつ）が、
  M1 をなすtupleの対応する要素の matcher に送られる。

- それぞれの matcher から戻ってきた結果が、対応する pp の $ に送られる。


## unordered-pairs の例

この matcher が再帰的に呼ばれる部分をプログラム変換的に示すと：

```
(match-all <Pair 1 2> (unordered-pair integer) [<pair ,2 $a> a]) ;=> {1}

(match-all 2          (multiset integer) [,2 []]) ;=> {[]}

(match-all 1       integer            [$a           m) ;=> {1}

(match-all 1       something          [$a          []) ;=> {[]} a=1が確定する。
````

paper の書き方

| #        | MState                                                       | env       | 備考  |
|:---------|:-------------------------------------------------------------|:----------|:------------------|
|1         | {[<pair ,2 $a> (unordered-pair integer) <Pair 1 2>}         |  {}       |       |
|2-1        | {[,2 integer 1]    [$a integer 2]}      |  {}       |       |
|2-2        | {[,2 integer 2]    [$a integer 1]}      |  {}       |       |
|3         | {[$a something 1]}      |  {}       |  a=1 が確定する。   |





match 側の pattern と target と matcher 側の clause の対応を示すと：

|          | match 側                 |          | matcher 側                       | 備考              |
|:---------|:-------------------------|:---------|:---------------------------------|:------------------|
| pattern  | <pair ,2 $a>             |   pp     | <pair $ $>                       |  |
|          |                          |   M1     | [integer integer]                |                 |
| target   | <Pair 1 2>               |   dp     | <Pair $x $y>                    |                |
|          |                          |   M2     | {[1 2] [2 1]}                   | 計算結果 |
| pattern  | ,2                       |   pp     | ,$val                            |  |
|          |                          |   M1     | integer                          |                 |
| target   | 2                        |   dp     | $tgt                             |                |
|          |                          |   M2     | {[]}                             | 計算結果 |
| pattern  | $a                       |   pp     | $                                |  |
|          |                          |   M1     | integer                        |                 |
| target   | 1                        |   dp     | $tgt                             |                |
|          |                          |   M2     | {1}                            | 計算結果 |
| pattern  | $a                       |   pp     | -                                |  |
|          |                          |   M1     | something                        |                 |
| target   | 1                        |   dp     | -                               |                |
|          |                          |   M2     | {[]}                            | a=1 が確定する。 |






## multiset の例

この matcher が再帰的に呼ばれる部分をプログラム変換的に示すと：


```
(match-all {2 8 2} (multiset integer) [<cons $m <cons ,m _>> m]) ;=> {2 2}

(match-all 2       integer            [$m           m) ;=> {2}

(match-all 2       something          [$m          []) ;=> {[]} m=2が確定する。

(match-all {8 2}   (multiset integer) [<cons ,2 _> []]) ;=> {[]}

(match-all 2       integer            [,2          []]) ;=> {[]}

```

paper の書き方

| #        | MState                                                       | env       | 備考  |
|:---------|:-------------------------------------------------------------|:----------|:------------------|
|1         | {[<cons $m <cons ,m _>> (multiset integer) {2 8 2}]}         |  {}       |       |
|2-1       | {[$m integer 2]    [<cons ,m _> (multiset integer) {8 2}]}      |  {}       |       |
|2-2       | {[$m integer 8]    [<cons ,m _> (multiset integer) {2 2}]}      |  {}       |       |
|2-3       | {[$m integer 2]    [<cons ,m _> (multiset integer) {2 8}]}      |  {}       |       |
|3         | {[$m something 2]    [<cons ,m _> (multiset integer) {8 2}]}      |  {}       | m=2が確定する。    |
|4         | {[<cons ,m _> (multiset integer) {8 2}]}      |  {[m 2]}       |       |
|5-1       | {[,m integer 8]    [_ (multiset integer) {2}]} | {[m 2]}  |         |
|5-2       | {[,m integer 2]    [_ (multiset integer) {8}]} | {[m 2]}  |         |
|6         | {[_ (multiset integer) {8}]}                 | {[m 2]} |         |
|7         | {[_ something {8}]}                        |  {[m 2]} |         |
|8         | {}| {[m 2]}                              |         |


match 側の pattern と target と matcher 側の clause の対応を示すと：



|          | match 側                 |          | matcher 側                       | 備考              |
|:---------|:-------------------------|:---------|:---------------------------------|:------------------|
| pattern  | <cons $m <cons ,m _>>    |   pp     | <cons $ $>                       |  |
|          |                          |   M1     | [integer (multiset integer)]     |                 |
| target   | {2 8 2}                  |   dp     | $tgt                             |                |
|          |                          |   M2     | {[2 {8 2}] [8 {2 2}] [2 {2 8}]}  | 計算結果 |
| pattern  | $m                       |   pp     | $                                |  |
|          |                          |   M1     | integer                          |                 |
| target   | 2                        |   dp     | $tgt                             |                |
|          |                          |   M2     | {2}                              | 計算結果 |
| pattern  | $m                       |   pp     | -                                |  |
|          |                          |   M1     | something                        |                 |
| target   | 2                        |   dp     | -                               |                |
|          |                          |   M2     | {[]}                            | a=1 が確定する。 |
| pattern  | <cons ,m _>    [m:=2]    |   pp     | <cons $ $>                       |   |
|          |                          |   M1     | [integer (multiset integer)]     |                 |
| target   | {2 8}                    |   dp     | $tgt                             |                |
|          |                          |   M2     | {[2 8] [8 2]}                    | 計算結果 |
| patten   | ,m             [m=2]     |   pp     |  ,$val                           |                |
|          |                          |   M1     | integer                          |                 |
| target   | 2                        |   dp     | $tgt                             |          |
|          |                          |   M2     |  {[]}                            | 計算結果        |


# 補足

cut pattern は廃止された。


以上
