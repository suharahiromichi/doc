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



# Proof Search Strategy


## Goal reduction:

## Backchaining:


# Inference Rules


END


