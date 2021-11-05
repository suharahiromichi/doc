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

## Program ``P``

## Goal ``G``



# Logic Comparison

- fohc
- hohc
- fohh
- hohh

## Formals

### G と D (``D ∈ P``)

| G                    |      note     |  DEC-10 Prolog  |
|:---------------------:|:-------------:|:--------------:|
| tt                   | hc, hh        |  true   |
| G, G                 | hc, hh        |  g, g  |
| G; G                 | hc, hh        |  g; g  |
| sigma (x:τ \ G)     | hc, hh        |  g(X)  |
| D => G               | hhのみ         |  なし    |
| pi (x:τ \ G)        | hhのみ         |   なし   |

| D                     |     note      | DEC-10 Prolog  |
|:---------------------:|:-------------:|:--------------:|
| A                     | hc, hh       |  (atomic) 
| G => D                | hc, hh       |  d :- g
| D; D                  | hc, hh       |  d; d
| pi (x:τ \ D)         | hc, hh        | d(X)


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
