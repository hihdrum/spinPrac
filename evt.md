# LTL

```Promela
ltl l01 { <>p }
```

# 表

| p | !p |
|---|----|
| F | T  |
| T | F  |

時相演算子<>がpに付与されているので、pがどこかの時相フレームで成立すれば、<>pの成立となる。

Never Claimでは、LTLの否定を探すので、!<>p = []!p の成立を探すことになる。

# Never Claim

```Promela
never l01 {    /* !(<> (p)) */
accept_init:
T0_init:
        do
        :: (! ((p))) -> goto T0_init
        od;
}
```

# Never Claim(手動編集)

```Promela
never l01 {    /* !<>p = []!p */
accept_init:
T0_init:
        do
        :: !p -> goto T0_init
        od;
}
```

# 動作

- !pが成立する場合、gotoによりT0_init, accept_initに戻る。
  最後まで!pが成立し続けた場合、accept_initの受理状態となり、Never Claimが成立する。
  つまり、LTLの反例となる。
- p成立のタイミングで遷移先がなくなり、検証終了となる。


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
$ spin -run -ltl l01 -a evt01.pml
(Spin Version 6.5.0 -- 17 July 2019)
	+ Partial Order Reduction

Full statespace search for:
	never claim         	+ (l01)
	assertion violations	+ (if within scope of claim)
	acceptance   cycles 	+ (fairness disabled)
	invalid end states	- (disabled by never claim)

State-vector 20 byte, depth reached 0, errors: 0
        1 states, stored
        0 states, matched
        1 transitions (= stored+matched)
        0 atomic steps
hash conflicts:         0 (resolved)

Stats on memory usage (in Megabytes):
    0.000	equivalent memory usage for states (stored*(State-vector + overhead))
    0.292	actual memory usage for states
  128.000	memory used for hash table (-w24)
    0.534	memory used for DFS stack (-m10000)
  128.730	total actual memory usage


unreached in proctype A
	evt01.pml:6, state 2, "-end-"
	(1 of 2 states)
unreached in claim l01
	_spin_nvr.tmp:6, state 6, "-end-"
	(1 of 6 states)

pan: elapsed time 0 seconds
```

# サンプルモデル2

```Promela
bool p = false;

active proctype A()
{
  p;
}
```

## 検証結果


```
$ spin -run -ltl l01 -a evt02.pml
(Spin Version 6.5.0 -- 17 July 2019)
Warning: Search not completed
	+ Partial Order Reduction

Full statespace search for:
	never claim         	+ (l01)
	assertion violations	+ (if within scope of claim)
	acceptance   cycles 	+ (fairness disabled)
	invalid end states	- (disabled by never claim)

State-vector 20 byte, depth reached 1, errors: 1
        1 states, stored
        0 states, matched
        1 transitions (= stored+matched)
        0 atomic steps
hash conflicts:         0 (resolved)

Stats on memory usage (in Megabytes):
    0.000	equivalent memory usage for states (stored*(State-vector + overhead))
    0.292	actual memory usage for states
  128.000	memory used for hash table (-w24)
    0.534	memory used for DFS stack (-m10000)
  128.730	total actual memory usage



pan: elapsed time 0 seconds
```

## 反例

```
$ spin -t0 evt02.pml
ltl l01: <> (p)
  <<<<<START OF CYCLE>>>>>
Never claim moves to line 4	[(!(p))]
spin: trail ends after 2 steps
#processes: 1
		p = 0
  2:	proc  0 (A:1) evt02.pml:5 (state 1)
  2:	proc  - (l01:1) _spin_nvr.tmp:3 (state 3)
1 processes created
```