# LTL

```Promela
ltl l01 { p }
```

# 表

| q | !q |
|---|----|
| F | T  |
| T | F  |

# Never Claim

```Promela
never l01 {    /* !(p) */
accept_init:
T0_init:
	do
	:: atomic { (! ((p))) -> assert(!(! ((p)))) }
	od;
accept_all:
	skip
}
```

# Never Claim(手動編集)

```Promela
never l01 {    /* !p */
accept_init:
T0_init:
	do
	:: atomic { !p -> assert(!(! ((p)))) }
	od;
}
```

# 動作

- !pが成立したら、assertion violateとなる。
- pが成立する場合は、遷移先なしとなりNever Claimの検証は終了となり、反例は報告されない。

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
$ spin -run -ltl l01 -a p01.pml 
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
	p.pml:6, state 2, "-end-"
	(1 of 2 states)
unreached in claim l01
	_spin_nvr.tmp:8, state 8, "-end-"
	(1 of 8 states)

pan: elapsed time 0 seconds
```

# サンプルモデル2

```Promela
bool p = true;

active proctype A()
{
  p;
  p = false;
}
```

## 検証結果

異常(errors)は0件となっている。「unreached in proctype A」に着目すると、
「p = 0」(p = false)の行が報告されており、検証されていないこがわかる。
これは、Never Claimがp成立のタイミングで検証終了するような記述になっているからと
考えらる。

```
$ spin -run -ltl l01 -a p02.pml 
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
	p02.pml:6, state 2, "p = 0"
	p02.pml:7, state 3, "-end-"
	(2 of 3 states)
unreached in claim l01
	_spin_nvr.tmp:8, state 8, "-end-"
	(1 of 8 states)

pan: elapsed time 0 seconds

```