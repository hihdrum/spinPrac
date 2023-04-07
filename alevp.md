# LTL

```Promela
ltl l01 { []<>p }
```

# 表

| p | !p |
|---|----|
| F | T  |
| T | F  |

編集中
時相演算子[]<>がpに付与されている。

1. いつかpが成立する。が、
1. 常に成立する。

場合に[]<>pが成立する。

Never Claimでは、LTLの否定を探すので、![]<>p = <>!<>p = <>[]!p の成立を探すことになる。
時相演算子<>と[]が付与されている。

# Never Claim

```Promela
never l01 {    /* !([] (<> (p))) */
T0_init:
        do
        :: (! ((p))) -> goto accept_S4
        :: (1) -> goto T0_init
        od;
accept_S4:
        do
        :: (! ((p))) -> goto accept_S4
        od;
}
```

# Never Claim(手動編集)

```Promela
never l01 {    /* !([] <>p) = <>!(<>p) = <>[]!p */
T0_init:
        do
        :: !p -> goto accept_S4
        :: true -> goto T0_init
        od;
accept_S4:
        do
        :: !p -> goto accept_S4
        od;
}
```

# 動作

- T0_init
  - !pが成立する場合、trueも成立するため非決定的にどちらかが選ばれる。
    - !pが選択された場合、accept_S4に遷移する。
    - trueが選択された場合、次の時相フレームについての検証が行われる。
  - !pが成立しない場合、trueが決定的に選ばれ、次の時相フレームについての検証が行われる。
- accept_S4:
  - !pが成立する場合、現在の状態を維持し、次の時相フレームについて検証を行う。
    常に!pが成立する状態を検査しており、最終的にこの状態を維持していた場合、
    Never Claimの受理状態となる。すなわち、LTLの反例となる。
  - !pが成立しない場合、遷移先が無いので検証終了となる。

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
(Spin Version 6.5.0 -- 17 July 2019)
	+ Partial Order Reduction

Full statespace search for:
	never claim         	+ (l01)
	assertion violations	+ (if within scope of claim)
	acceptance   cycles 	+ (fairness disabled)
	invalid end states	- (disabled by never claim)

State-vector 20 byte, depth reached 5, errors: 0
        3 states, stored
        1 states, matched
        4 transitions (= stored+matched)
        0 atomic steps
hash conflicts:         0 (resolved)

Stats on memory usage (in Megabytes):
    0.000	equivalent memory usage for states (stored*(State-vector + overhead))
    0.291	actual memory usage for states
  128.000	memory used for hash table (-w24)
    0.534	memory used for DFS stack (-m10000)
  128.730	total actual memory usage


unreached in proctype A
	(0 of 2 states)
unreached in claim l01
	_spin_nvr.tmp:8, state 10, "-end-"
	(1 of 10 states)

pan: elapsed time 0 seconds
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
(Spin Version 6.5.0 -- 17 July 2019)
Warning: Search not completed
	+ Partial Order Reduction

Full statespace search for:
	never claim         	+ (l01)
	assertion violations	+ (if within scope of claim)
	acceptance   cycles 	+ (fairness disabled)
	invalid end states	- (disabled by never claim)

State-vector 20 byte, depth reached 9, errors: 1
        7 states, stored (9 visited)
        1 states, matched
       10 transitions (= visited+matched)
        0 atomic steps
hash conflicts:         0 (resolved)

Stats on memory usage (in Megabytes):
    0.000	equivalent memory usage for states (stored*(State-vector + overhead))
    0.291	actual memory usage for states
  128.000	memory used for hash table (-w24)
    0.534	memory used for DFS stack (-m10000)
  128.730	total actual memory usage



pan: elapsed time 0 seconds
```

## 反例

```
$ spin -t0 alevp02.pml
ltl l01: [] (<> (p))
starting claim 1
Never claim moves to line 4	[(1)]
  2:	proc  0 (A:1) alevp02.pml:5 (state 1)	[p = 0]
  4:	proc  0 (A:1) alevp02.pml:6 (state 2)	[p = 1]
  6:	proc  0 (A:1) alevp02.pml:7 (state 3)	[p = 0]
Never claim moves to line 3	[(!(p))]
  8: proc 0 terminates
  <<<<<START OF CYCLE>>>>>
Never claim moves to line 8	[(!(p))]
spin: trail ends after 10 steps
#processes: 0
		p = 0
 10:	proc  - (l01:1) _spin_nvr.tmp:7 (state 10)
1 processes created
```