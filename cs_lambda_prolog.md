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
