# データ

```
{ value ... }           collection
[ value ... ]           tuple
<C value ...>           inductive data  , C は id
[| value ... |]         tensor
{|[key value] ...|}     hash map
```


# match

```
(match     M M {[p M] ...})
(match-all M M  [p M]     )

TARGET                    M
TYPE                      M
MATCH-CLAUSE              [p M]
MATCH-CLAUSE-PATTERN      p ::= _ | $x | ,M |  <C p ... >
MATCH-CLAUSE-BODY         M
```

## 例

### 1

```
(match-all {1 2 3} (list integer) [<join $xs $ys> [xs ys]])
TARGET               : {1 2 3}
TYPE                 : (list integer)
MATCH-CLAUSE-PATTERN : <join $xs $ys>
MATCH-CLAUSE-BODY    : [xs ys]
```

### 2
```
(match-all primes (list integer) [<join _ <cons $p <cons ,(+ p 2) _>>> [p (+ p 2)]]))
TARGET               : primes
TYPE                 : (list integer)
MATCH-CLAUSE-PATTERN : <join _ <cons $p <cons ,(+ p 2) _>>>
MATCH-CLAUSE-BODY    : [p (+ p 2)]
```

### 3
```
(match-all b (matcher {[$ something {[<True> {e1}] [<False> {e2}]}]}) [$x x])
TARGET               : b
TYPE                 : (matcher {[$ something {[<True> {e1}] [<False> {e2}]}]})
MATCH-CLAUSE-PATTERN : $x
MATCH-CLAUSE-BODY    : x
```

### 4
```
(match-all (take n (repeat 0)) (multiset integer) [<insert $x <insert ,(+ x 1) _>> x])
TARGET               : (take n (repeat 0))
TYPE                 : (multiset integer)
MATCH-CLAUSE-PATTERN : <insert $x <insert ,(+ x 1) _>>
MATCH-CLAUSE-BODY    : x
```

### 5
```
(match-all {1 2 3} (list integer) [<cons $x $rs> [x rs]])
TARGET               : {1 2 3}
TYPE                 : (list integer)
MATCH-CLAUSE-PATTERN : [<cons $x $rs>
MATCH-CLAUSE-BODY    : [x rs]
```

### 6
```
(match-all {1 2 3} (multiset integer) [<cons $x $rs> [x rs]])
TARGET               : {1 2 3}
TYPE                 : (multiset integer)
MATCH-CLAUSE-PATTERN : [<cons $x $rs>
MATCH-CLAUSE-BODY    : [x rs]
出力                 : {[1 {2 3}] [2 {1 3}] [3 {1 2}]} 
```

### 6'

これは成功する。multiset なので {1 2} と {3 2} は一致する。

```
(match {1 2 3} (multiset integer) {[<cons ,1 ,{3 2}> {[]}] [_ {}]})
TARGET               : {1 2 3}
TYPE                 : (multiset integer)
MATCH-CLAUSE-PATTERN : [<cons ,1 ,{3 2}>
MATCH-CLAUSE-BODY    : {[]}
MATCH-CLAUSE-PATTERN : _
MATCH-CLAUSE-BODY    : {}
出力                 : {[]}
```


### 7
```
(match-all {1 2 3} (set integer) [<cons $x $rs> [x rs]])
TARGET               : {1 2 3}
TYPE                 : (set integer)
MATCH-CLAUSE-PATTERN : [<cons $x $rs>
MATCH-CLAUSE-BODY    : [x rs]
出力                 : {[1 {1 2 3}] [2 {1 2 3}] [3 {1 2 3}]}
```

### 7'

これは成功する。set なので {1 2 3} と {3 2 1} は一致する。

```
(match {1 2 3} (set integer) {[<cons ,1 ,{3 2 1} {[]}] [_ {}]})
TARGET               : {1 2 3}
TYPE                 : (set integer)
MATCH-CLAUSE-PATTERN : [<cons $x $rs>
MATCH-CLAUSE-BODY    : [x rs]
出力                 : {[]}
```

### 8
```
(match-all {1 2 3} (multiset integer) [,{2 1 3} "Matched"])
TARGET               : {1 2 3}
TYPE                 : (multiset integer)
MATCH-CLAUSE-PATTERN : ,{2 1 3}
MATCH-CLAUSE-BODY    : "Matched"
```

### 9
```
(match-all <Pair 2 5> (unordered-pair integer) [<pair ,5 $x> x])
TARGET               : <Pair 2 5>
TYPE                 : (unordered-pair integer)
MATCH-CLAUSE-PATTERN : <pair ,5 $x>
MATCH-CLAUSE-BODY    : x
```

### 10
```
(match poly math-expr
       {[<+ <* $n <,cos $x>^,2 $y> <* ,n <,sin ,x>^,2 ,y> $r>
              (rewrite-rule-for-cos-and-sin-poly <+' r <*' n y>>)]
       [_ poly]})
TARGET               : poly
TYPE                 : math-expr
MATCH-CLAUSE-PATTERN : <+ <* $n <,cos $x>^,2 $y> <* ,n <,sin ,x>^,2 ,y> $r>
MATCH-CLAUSE-BODY    : (rewrite-rule-for-cos-and-sin-poly <+' r <*' n y>>)
MATCH-CLAUSE-PATTERN : _
MATCH-CLAUSE-BODY    : poly
```

### 11
```
(match-all {2 8 2} (multiset integer) [<cons $m <cons ,m _>> m])
TARGET               : {2 8 2}
TYPE                 : (multiset integer)
MATCH-CLAUSE-PATTERN : <cons $m <cons ,m _>>
MATCH-CLAUSE-BODY    : m
```

### 12
```
(match-all nats (set integer) [<cons $m <cons $n _>> [m n]])
TARGET               : nats
TYPE                 : (set integer)
MATCH-CLAUSE-PATTERN : <cons $m <cons $n _>>
MATCH-CLAUSE-BODY    : [m n]
```

### 13
```
(match-all tgt (list a) [<join $hs <cons $x $ts>> [x (append hs ts)]])]}]
TARGET               : tgt
TYPE                 : (list a)
MATCH-CLAUSE-PATTERN : <join $hs <cons $x $ts>>
MATCH-CLAUSE-BODY    : [x (append hs ts)]
```

### 14

val と tgt が空でないコレクションで順列の関係であるとき {[]} を返す。さもなければ {} を返す。
例 6' を参照せよ。
左側のlist の [1 {3 2}] とマッチしないようにみえるが、そのようなことはない。

```
(match-all [val tgt] [(list a) (multiset a)] [[<cons $x $xs> <cons ,x ,xs>] {[]}])
TARGET               : [val tgt]
TYPE                 : [(list a) (multiset a)]
MATCH-CLAUSE-PATTERN : [<cons $x $xs> <cons ,x ,xs>]
MATCH-CLAUSE-BODY    : {[]}
```

### 15

上記を match で書き、かつ 両方が {} である場合も {[]} を返すようにする。

```
(match [val tgt] [(list a) (multiset a)]
{
        [[<nil> <nil>] {[]}]
        [[<cons $x $xs> <cons ,x ,xs>] {[]}]
        [[_ _] {}]
})
TARGET               : [val tgt]
TYPE                 : [(list a) (multiset a)]
MATCH-CLAUSE-PATTERN : [<nil> <nil>]
MATCH-CLAUSE-BODY    : {[]}
MATCH-CLAUSE-PATTERN : [<cons $x $xs> <cons ,x ,xs>]
MATCH-CLAUSE-BODY    : {[]}
MATCH-CLAUSE-PATTERN : [_ _]
MATCH-CLAUSE-BODY    : {}
```

### 16
```
(match [val tgt] [(multiset a) (multiset a)]
{
        [[<nil> <nil>] <true>]
        [[<cons $x $xs> <cons ,x ,xs>] <true>]
        [[_ _] <false>]
})
TARGET               : [val tgt]
TYPE                 : [(multiset a) (multiset a)]
MATCH-CLAUSE-PATTERN : [<nil> <nil>]
MATCH-CLAUSE-BODY    : <true>
MATCH-CLAUSE-PATTERN : <cons $x $xs> <cons ,x ,xs>
MATCH-CLAUSE-BODY    : <true>
MATCH-CLAUSE-PATTERN : [_ _]
MATCH-CLAUSE-BODY    : <false>

```

# matcher

```
(matcher {[pp M {[dp M] ...}] ... })

PRIMITIVE-PATTERN PATTERN               pp ::= $ | ,$x | ,M |  <C pp ... >
NEXT-MATCHER EXPRESSIONS                M
PRIMITIVE-DATA-MATCH CLAUSES            [dp M]
PRIMITIVE-DATA PATTERNS RESPECTIVELY    dp ::= $x |  <C dp ... >
PRIMITIVE-DATA EXPRESSION               M
```

## 例

### 1

(if b e1 e2) のマクロを示す matcher である。

```
(matcher {[$ something {[<True> {e1}] [<False> {e2}]}]})
PRIMITIVE-PATTERN PATTERN            : $
NEXT-MATCHER EXPRESSIONS             : something
PRIMITIVE-DATA PATTERNS RESPECTIVELY : <True>
PRIMITIVE-DATA EXPRESSION            : {e1}
PRIMITIVE-DATA PATTERNS RESPECTIVELY : <False>
PRIMITIVE-DATA EXPRESSION            : {e2}
```

### 2

Unordered Pairs の matcher である。

```
(matcher {
                [<pair $ $> [a a]       {[<Pair $x $y> {[x y] [y x]}]}]
                [$          [something] {[$tgt         {tgt}]}]
         }
)
PRIMITIVE-PATTERN PATTERN            : <pair $ $>
NEXT-MATCHER EXPRESSIONS             : [a a]
PRIMITIVE-DATA PATTERNS RESPECTIVELY : <Pair $x $y>
PRIMITIVE-DATA EXPRESSION            : {[x y] [y x]}
PRIMITIVE-PATTERN PATTERN            : $
NEXT-MATCHER EXPRESSIONS             : [something]
PRIMITIVE-DATA PATTERNS RESPECTIVELY : $tgt
PRIMITIVE-DATA EXPRESSION            : {tgt}
```

### 3

multiset の matcher である。

```
(matcher
        {[<nil> [] {[{} {[]}] [_ {}]}]
         [<cons $ $> [a (multiset a)]
               {[$tgt (match-all tgt (list a)
                                 [<join $hs <cons $x $ts>>
                                 [x (append hs ts)]])]}]
         [,$val []
               {[$tgt (match [val tgt] [(list a) (multiset a)]
                                  {[[<nil> <nil>] {[]}]
                                  [[<cons $x $xs> <cons ,x ,xs>] {[]}]
                                  [[_ _] {}]})]}]
         [$ [something] {[$tgt {tgt}]}]})

PRIMITIVE-PATTERN PATTERN            : <nil>
NEXT-MATCHER EXPRESSIONS             : []
PRIMITIVE-DATA PATTERNS RESPECTIVELY : {}
PRIMITIVE-DATA EXPRESSION            : {[]}
PRIMITIVE-DATA PATTERNS RESPECTIVELY : _
PRIMITIVE-DATA EXPRESSION            : {}

PRIMITIVE-PATTERN PATTERN            : <cons $ $>
NEXT-MATCHER EXPRESSIONS             : [a (multiset a)]
PRIMITIVE-DATA PATTERNS RESPECTIVELY : $tgt
PRIMITIVE-DATA EXPRESSION            :
               (match-all tgt (list a) [<join $hs <cons $x $ts>> [x (append hs ts)]])
PRIMITIVE-PATTERN PATTERN            : ,$val
NEXT-MATCHER EXPRESSIONS             : []
PRIMITIVE-DATA PATTERNS RESPECTIVELY : $tgt
PRIMITIVE-DATA EXPRESSION            : (match [val tgt] [(list a) (multiset a)]
                                                 {[[<nil> <nil>] {[]}]
                                                  [[<cons $x $xs> <cons ,x ,xs>] {[]}]
                                                  [[_ _] {}]})
PRIMITIVE-PATTERN PATTERN            : $
NEXT-MATCHER EXPRESSIONS             : [something]
PRIMITIVE-DATA PATTERNS RESPECTIVELY : $tgt
PRIMITIVE-DATA EXPRESSION            : {tgt}
```

### 4
```
(matcher {[,$n [] {[$tgt (if (eq? tgt n) {[]} {})]}]
          [<lt ,$n> [] {[$tgt (if (lt? tgt n) {[]} {})]}]
          [$ [something] {[$tgt {tgt}]}]}))

PRIMITIVE-PATTERN PATTERN            : ,$n
NEXT-MATCHER EXPRESSIONS             : []
PRIMITIVE-DATA PATTERNS RESPECTIVELY : $tgt
PRIMITIVE-DATA EXPRESSION            : (if (eq? tgt n) {[]} {})
PRIMITIVE-PATTERN PATTERN            : <lt ,$n>
NEXT-MATCHER EXPRESSIONS             : []
PRIMITIVE-DATA PATTERNS RESPECTIVELY : $tgt
PRIMITIVE-DATA EXPRESSION            : (if (lt? tgt n) {[]} {})
PRIMITIVE-PATTERN PATTERN            : $
NEXT-MATCHER EXPRESSIONS             : [sometihg]
PRIMITIVE-DATA PATTERNS RESPECTIVELY : $tgt
PRIMITIVE-DATA EXPRESSION            : {tgt}
```


# 補足

cut pattern は廃止された。
