coq-ELPI tutorial を攻略するためのメモ
-----------------

2022/03/07 @suharahiromichi


# Tutorial on the Elpi programming language

## 主なbuiltin述語

- [coq.say ...] Prints an info message

# Tutorial on the HOAS for Coq terms

## GlobalReference (gref) 型の(ELPIの)コンストラクタ

- ``type const  constant -> gref.``<br>
例： ``const «x»``<br>``Defintion``などて定義された定数

- ``type indt   inductive -> gref.``<br>
例： ``indt «nat»``

- ``type indc   constructor -> gref.``<br>
例： indc «O» または indt «S»

- ``type global gref -> term.``

- ``type app    list term -> term.``

- ``type fun    name -> term -> (term -> term) -> term.``

- ``type fix    name -> int -> term -> (term -> term) -> term.``

- ``type match  term -> term -> list term -> term.``

- ``type prod   name -> term -> (term -> term) -> term.``<br>
forall x : t, の意味である。


### 主なbuiltin述語
- ``coq.locate Name GR``<br>
``pred coq.locate i:id, o:gref.``<br>
文字列で与えられたCoqの定義、型やコンストラクタから、grefオブジェクトを得る。
locates a global definition, inductive type or constructor via its name.

| Name       | GR                  | 意味             |
|-----------|-----------------------|------------------|
| Nat.add   | const «Nat.add»       | 定数           |
| x         | const «x»             | 定数           |
| nat       | indt «nat»            | Type             |
| O         | indc «O»              | Constructor      |
| S         | indc «S»              | Constructor      |

- ``coq.env.typeof GR Ty``<br>
``pred coq.env.typeof i:gref, o:term.``<br>
grefオブジェクトのCoqでの型を返す。型はterm。
reads the type Ty of a global reference.

|　GR           | Ty　                  | 意味             |
|---------------|-----------------------|------------------|
| const «x»     | global (indt «nat»)   | x : nat          |
| indt «nat»    | sort (typ «Set»)      | nat : Set        |
| indc «O»      | global (indt «nat»)   | O : nat          |
| indc «S»      | †                     | S : nat -> nat   |

†　``prod `_` (global (indt «nat»)) c0 \ global (indt «nat»)``

- ``coq.env.const GR Bo Ty``<br>
``pred coq.env.const i:constant, o:option term, o:term.``
定数に対して、その定義と型を返す。どちらもterm。
reads the type Ty and the body Bo of constant GR.<br>

|　GR    | Bo         | Ty　                | 意味             |
|--------|------------|---------------------|-----------------|
| «x»    | some (†)  | global (indt «nat») | x := 2          |
| «Nat.add»  | some (††)  | ††† | ††††          |

†　``app [global (indc «S»), app [global (indc «S»), global (indc «O»)]]``

††
```coq
fix `add` 0 
 (prod `n` (global (indt «nat»)) c0 \
   prod `m` (global (indt «nat»)) c1 \ global (indt «nat»)) c0 \
 fun `n` (global (indt «nat»)) c1 \
  fun `m` (global (indt «nat»)) c2 \
   match c1 (fun `n` (global (indt «nat»)) c3 \ global (indt «nat»)) 
	[c2, 
     (fun `p` (global (indt «nat»)) c3 \
       app [global (indc «S»), app [c0, c3, c2]])]
```

††† ``Π n : nat, Π m : nat, nat``  = ``nat -> nat -> nat``
```
prod `n` (global (indt «nat»))
   c0 \ prod `m` (global (indt «nat»))
    c1 \ global (indt «nat»)
```

††††
```
Nat.add = 
Fix add (n m : nat) {struct n} : nat :=
  match n with
  | 0 => m
  | S p => S (add p m)
  end
```

- [coq.name-suffix Name Suffix NameSuffix] suffixes a Name with a string or an int or another name

## Sortコンストラクタ

- ``type sort  universe -> term.``
- ``type prop  universe.``
- ``type typ   univ -> universe.``

### bulitin述語（制約を課す　to impose constrains)

- ``coq.univ.sup U1 U2`` <br>
``pred coq.univ.sup i:univ, i:univ.``<br>
制約　constrains ``U2 = U1 + 1`` を与える。計算をするわけではない。

- ``coq.univ.leq U1 U2``<br>
``pred coq.univ.leq i:univ, i:univ.``<br>
制約 constrains ``U1 <= U2`` を与える。

--------------------------
--------------------------
# いろいろな書き方で、λx.xを書いてみよう。

 ## Global Reference

```
Elpi Query lp:{{
  coq.locate "nat" GR,
  ID = (fun `m` (global GR) x\ x),
  coq.locate "O" GRo,
  B = global GRo,
  coq.say "(id b) is:" (app [ID, B])
}}.
```

## Sort

```
Elpi Query lp:{{
  ID = (fun `x` (sort (typ U)) x\ x),
  A = (sort (typ U)), % the same U as before
  B = (sort (typ V)),
  coq.say "(id b) is:" (app [ID, B])
}}.
```

## Quotations and Aatiquotations

Elpi Query lp:{{
  ID = (fun `x` {{nat}} x\ x),
  B = {{O}},
  coq.say "(id b) is:" (app [ID, B])
}}.





--------------------------
--------------------------
作成中

- [coq.univ.print] prints the set of universe constraints

- [coq.typecheck T Ty Diagnostic]<br>
typchecks a term T returning its type Ty.<br>
pred coq.typecheck i:term, o:term, o:diagnostic.<br>
diagonostice は ok または (error Msg) である。

- [coq.sigma.print] Prints Coq's Evarmap and the mapping to/from Elpi's <br>
(略)


# Tutorial on Coq commands

## 主なbuiltin述語

- [std.assert! C M] takes the first success of C or fails with message M
- [std.assert-ok! C M] like assert! but the last argument of the predicate must be a diagnostic that is printed after M in case it is not ok

- [std.lenght]
- [std.map]
- [std.findall P L] L is the list [P1,P2,P3..] where each Pi is a solution to P.
- [std.forall]

- [coq.elaborate-skeleton T ETy E Diagnostic] elabotares T against the expected type ETy.
- [coq.env.add-const Name Bo Ty Opaque C] Declare a new constant
- [coq.env.indt-decl] reads the inductive type declaration for the environment

- [coq.elpi.accumulate Scope DbName Clause] Declare that, once the program is over, the given clause has to be added to the given db (see Elpi Db).

- coq.parse-attributes
- [coq.ltac.fail Level ...] Interrupts the Elpi program and calls Ltac's

- [coq.warn ...] Prints a generic warning message

# Tutorial on Coq tactics

## 主なbuiltin述語

- [std.mem! L X] succeeds once if X occurs inside L
- [std.map]
- [std.nth N L X] picks in X the N-th element of L (L must be of length > N)

- [coq.ltac.call]

- [coq.term->string T S] prints a term T to a string S using Coq's pretty

- [coq.unify-leq A B Diagnostic] unifies the two terms (with cumulativity, if they are types)
- [coq.ltac.id-free? ID G] Fails if ID is already used in G. Note that ids which are taken are renamed
- [coq.id->name]

- [coq.ltac.collect-goals T Goals ShelvedGoals] Turns the holes in T into Goals.

- The utility (coq.ltac.open T G GL) postulates all the variables bounds by nabla and loads the goal context before calling T on the unsealed goal. The invocation of a tactic with arguments

- [coq.ltac.set-goal-arguments]

- [coq.uint63->int U I] Transforms a primitive unsigned integer U into an elpi integer I. Fails if it does not fit.

