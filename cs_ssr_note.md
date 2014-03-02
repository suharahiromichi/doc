SSReflectノート
========
2014/03/02 @suharahiromichi

# 基本のキ (CheatSheet以前)

## moveとrewriteは分配できる。

| 例                   | 同じ意味                          |備考             |
|:---------------------|:---------------------------------|:----------------|
| move=> a b c.        | move=> a; move=> b; move=> c.    |                 |
| move: x y z.         | move: x; move: y; move: z.       |                 |
| rewrite p q r        | rewrite p; rewrite q; rewrite r  |                 |

## 「:」と「=>」はmoveを略した書き方。

| 例                   | 同じ意味                          |備考                   |
|:---------------------|:---------------------------------|:----------------------|
| apply: x y => a b    | move: x y; apply; move => a b    |                       |
| exact: x y => a b    | move: x y; exact; move => a b    |                       |
| case:  x y => a b    | move: x y; case;  move => a b    |                       |
| elim: x y => a b     | move: x y; elim;  move => a b    |                       |
| apply/V: x y => a b  | move: x y; apply/V; move => a b  | Viewを指定しても同じ。 |


## move=>[]と、caseの関係。

| 例                   | 同じ意味                          |備考                   |
|:---------------------|:---------------------------------|:----------------------|
| case=> [].           | move=> [].                       |                       |
| case=> [].           | case.                            |                       |
| case=> [l m n].      | move=> [l m n].                  |                       |
| case=> [l m n].      | case=> l m n.                    | 「move=> l m n」ではない。|
| move=> [l m n].      | move=> [] l m n.                 | move=> []; move=> l m n. |
| move=> [l m n].      | case; move=> l m n.              | case=> []; move=> l m n. |

以下はすべて同じになる。

例1
```Coq
case=> [l m].
move=> [l m].
move=> []; move=> l m.
case; move=> l m.
case=> l m.
```

例2
```Coq
move=> [[l m] n].
move=> [] [l m] n.
move=> [] [] l m n.
move=> []; move=> []; move=> l m n.
case; case; move=> l m n.
case; case=> l m n.
```

# move (DischargeとIntroduction)

# rewrite

# View

# Tactics

# haveとwlog (Structure)

# Gallinaの拡張

以上
