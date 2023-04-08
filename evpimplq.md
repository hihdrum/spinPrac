# LTL

```Promela
ltl l01 { []<>p -> q }
```

# 表

| p | q | p -> q | !p | !p v q |
|---|----|---|---|--- |
| F | F  | T | T | T |
| F | T  | T | T | T |
| T | F  | F | F | F |
| T | T  | T | F | T


編集中
時相演算子[]<>がpに付与されている。

1. いつかpが成立する。が、
1. 常に成立する。

場合に[]<>pが成立する。

Never Claimでは、LTLの否定を探すので、![]<>p = <>!<>p = <>[]!p の成立を探すことになる。
時相演算子<>と[]が付与されている。

Never Claimでは、LTLの否定を探すので、!(!<>p || q) = !([]!p || q) = ![]!p && !q = <>p && !q

# Never Claim

```Promela
never l01 {    /* !((! (<> (p))) || (q)) */
T0_init:
	do
	:: atomic { (! ((q)) && (p)) -> assert(!(! ((q)) && (p))) }
	:: (! ((q))) -> goto T0_S3
	od;
T0_S3:
	do
	:: atomic { ((p)) -> assert(!((p))) }
	:: (1) -> goto T0_S3
	od;
accept_all:
	skip
}
```

# Never Claim(手動編集)

```Promela
never l01 {    /* !((!<>p) || (q)) */
T0_init:
	do
	:: atomic { (p && !q) -> assert(!(! ((q)) && (p))) }
	:: !q -> goto T0_S3
	od;
T0_S3:
	do
	:: atomic { p -> assert(!((p))) }
	:: true -> goto T0_S3
	od;
}
```

# 動作

- T0_init
  - p && !q が成立する場合、assertion violateとなる。
    これは、LTLにおけるFのケースである。
  - !qが成立する場合、T0_S3に遷移する。pの成否は続く時相でT0_S3でのチェックとなる。
- T0_S3
  - pが成立する場合、LTLのFのケースとなる。
  - pが成立しない場合、trueが成立するので、次の時相で検査する。

# サンプルモデル1

```Promela
bool p = true;

active proctype A()
{
  p;
}
```

## 検証結果

```
$ spin -run -ltl l01 -a alp01.pml
.
```

# サンプルモデル2

```Promela
bool p = false;

active proctype A()
{
  p = false;
  p = true;
  p = false;
}
```

## 検証結果


```
$ spin -run -ltl l01 -a alevp02.pml
.
```

## 反例

```
$ spin -t0 alevp02.pml
.
```
