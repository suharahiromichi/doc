λProlog 便利帳
--------------------------


2023_02_08 @suharahiromichi

2023_02_12 @suharahiromichi


# 演算子と束縛子


|Math font      | Concrete syntax font  | Type          |
|:-------------:|:---------------------:|:-------------:|
| ∧             | & または ,            | o -> o -> o  |
| ∨             | ;                     | o -> o -> o  |
| ⊃             | =>                    | o -> o -> o   |
| ⇐             | :-                    | o -> o -> o   |
| λ            | \\                    | 束縛子      |
| ∀             | pi                    | (A -> o) -> o |
| ∃             | sigma                 | (A -> o) -> o | 


``not`` と ``!`` (カット)は、通常の述語である。


# 2項述語

| 述語 | Concrete syntax font | type | 同じ定義 |
|:----:|:--------:|:---------------------:|:---------:|
|      |  =       | A -> A -> o  | 
| lt_  |  <       | A -> A -> o  | i<、r<、s<
| gt_  | >        | A -> A -> o  | i>、r>、s>
| le_  | =<       | A -> A -> o  | i=<、r=<、s=<
| ge_  | >=       | A -> A -> o  | i>=、r>=、s>=
| calc | is       | A -> A -> o  | 

calc と (is) では、引数の順番が逆になる。



# calc (is) の演算子

整数
```
type (i-) int -> int -> int.
type (+) int -> int -> int.
type (i+) int -> int -> int.
type (*) int -> int -> int.
type (mod) int -> int -> int.
type (div) int -> int -> int.
type (~) int -> int.              (* opposite *)
type (i~) int -> int.             (* opposite *)
type abs int -> int.
type iabs int -> int.
type max int -> int -> int.
type min int -> int -> int.
```

## 浮動小数点数
```
type (r-) float -> float -> float.
type (+) float -> float -> float.
type (r+) float -> float -> float.
type (*) float -> float -> float.
type (/) float -> float -> float.
type (~) float -> float.          (* opposite *)
type (r~) float -> float.         (* opposite *)
type abs float -> float.
type rabs float -> float.
type max float -> float -> float.
type min float -> float -> float.
type sqrt float -> float.
type sin float -> float.
type cos float -> float.
type arctan float -> float.
type ln float -> float.

type floor float -> int.
type ceil float -> int.
type truncate float -> int.
type int_to_real int -> float.
```

## 文字列
```
type (^) string -> string -> string.
type size string -> int.
```

## 文字と整数の変換
```
type chr int -> string.
type rhc string -> int.
```

## 文字列と数値の変換
```
type string_to_int string -> int.
type int_to_string int -> string.
type real_to_string float -> string.
type substring string -> int -> int -> string.
```

# 組込述語

## ELPI

- elpi/src/builtin.elpi

(<) などのELPIの組込述語


- elpi/src/builtin_stdlib.elpi

std. のELPIの組込述語


- elpi/src/builtin_map.elpi

std.map. のELPIの組込述語


- elpi/src/builtin_set.elpi

std.set. のELPIの組込述語


## Coq-ELPI

- coq-elpi/elpi-builtin.elpi

(elpi/src/builtin.elpi と同じ)


- coq-elpi/coq-builtin.elpi


- elpi/coq-lib.elpi

- elpi/coq-HOAS.elpi

- elpi/elpi-ltac.elpi
- elpi/elpi_elaborator.elpi

- elpi/elpi-tactic-template.elpi
- elpi/elpi-command-template.elpi
- elpi/coq-elaborator.elpi

- elpi/coq-elpi-checker.elpi- elpi/elpi-reduction.elpi

以上
