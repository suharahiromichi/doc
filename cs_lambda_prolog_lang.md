lambda Prolog 言語概説

[https://chelsea.lol/pwhol/]

# The Type System

## ``kind ⟨id⟩ ⟨kind expression⟩``

```
⟨kind expression⟩ ::= type
                    | type → ⟨kind expression⟩
```


## ``type ⟨id⟩ ⟨type expression⟩``

```
⟨type expression⟩ ::= ⟨type variable⟩
                    | ⟨type expression⟩ → ⟨type expression⟩
                    | ⟨type constructor⟩ ⟨type expression⟩ … ⟨type expression⟩
```

## term

1. Variable
2. Constant
3. Application
4. Function

The type ``o`` is reserved for predicates and formulas and its use is restricted for different logics (see the description of Context in Setting and Logic Comparison)

Formulas are terms of type ``o``


# Setting

## Sequent ``Σ; P --> G``


## Signature ``Σ``

### Constant    nil

### Initially in the signature:


|Math font      | Concrete syntax font  | Type          |
|:-------------:|:---------------------:|:-------------:|
| ⊤             | tt                    | o             |
| ∧            | & または ,             | o -> o -> o  |
| ∨            | ;	                | o -> o -> o  |
| ⊃            | =>	                | o -> o -> o   |
| ⇐             | :-                    | o -> o -> o   |
| ∀            | pi                    | (A -> o) -> o |
| ∃            | sigma	               | (A -> o) -> o | 


### binding operator

- ``,`` ``;`` ``:-`` ``=>``のシグネチャよりも結合度が低い。

- 変数名大文字でも小文字でもよい。どちらでも、外側から参照できない。


## Program ``P``

## Goal ``G``



# Logic Comparison

- fohc
- hohc
- fohh
- hohh

## Formals

### G と D (``D ∈ P``)

| G                    |      note     | 
|:---------------------:|:-------------:|
| tt                   | hc, hh        | 
| G, G  または G & G   | hc, hh        | 
| G; G                 | hc, hh        | 
| sigma (x:τ \ G)     | hc, hh        | 
| D => G  または G :- D | hhのみ         |
| pi (x:τ \ G)        | hhのみ         |

| D                     |     note      |
|:---------------------:|:-------------:|
| A                     | hc, hh       |
| G => D または D :- G  | hc, hh       |
| D; D                  | hc, hh       |
| pi (x:τ \ D)         | hc, hh        | 

- A はアトミックな論理式とする。

- (通常のHorn節の表記から) 変数名を大文字にする場合は、
  - G の最外側の ``sigma (X \ G)`` の sigma や binding op は省略できる。
  - D の最外側の ``pi (X \ D)`` の pi や binding op は省略できる。
  

（PwHOL p.46）formula内では、抽象化によって明示的にバインドされていな
いトークンは、大文字で始まる場合は変数と見なされます。プログラムを構成
する明確な節のコレクションは、それらを順番に書くことによってPrologに示
され、各節はピリオドで終了します。これらのいずれの節も明示的なscopeが
与えられていない変数は、それらが出現する節全体にわたって全称記号である
と見なされます。

上記では、Dのpiについてしか述べていないが、Gのsigmaについても節全般に
渡って存在記号としてみなされるはずである。



### Modular programming and hypothetical reasoning:

### Generic reasoning:


## Order

### Type Expression Order


### First-Order Restrictions:

- 項変数の型は0階、かつ、``o``でないこと。関数または1階のformulaの量化はありません。

- 式は1階以下である。値コンストラクターへの関数引数も関数抽象化もありません。

- ``o``は、式のターゲット型以外に使えません。値コンストラクターへの引数をformulaにすることはできません。

- 型変数の置換は0階の式であり、``o``ではありません。それ以外の項は 「> 1」の項であるか、高階述語を示します。


# Proof Search Strategy

Goal reduction と Backcahining を交互におこなう。

## Goal reduction:

右-Inference Rules を使って、ゴールを分解していく。


## Backchaining:

goalがatomicな場合、

1. decideルールを使って、プログラム節を選択する。

2. 選ばれた節にinitialルールまたはbackchainingルールを適用する。


# Inference Rules


END
