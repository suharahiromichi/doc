λProlog 便利帳
--------------------------


2023_02_08 @suharahiromichi



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


# 2項述語

| 述語 | Concrete syntax font | type |
|:----:|:--------:|:---------------------:|
|      |  =       | A -> A -> o  | 
| gt_  |  <       | A -> A -> o  |
| lt_  | >        | A -> A -> o  | 
| ge_  | =<       | A -> A -> o  | 
| le_  | >=       | A -> A -> o  | 
| calc | is       | A -> A -> o  | 

calc と (is) では、引数の順番が逆になる。


# calc　(is) の演算子

整数
```
type (i-) int -> int -> int.
type (+) int -> int -> int.
type (i+) int -> int -> int.
type (*) int -> int -> int.
type (mod) int -> int -> int.
type (div) int -> int -> int.
type (~) int -> int.
type (i~) int -> int.
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
type (~) float -> float.
type (r~) float -> float.
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

- coq-elpi/elpi/coq-HOAS.elpi

match や indt-decl などのHOASのコンストラクタ


- coq-elpi/elpi/coq-lib.elpi

copy-indt-decl など


以上
