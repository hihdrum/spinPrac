# LTL

```Promela
ltl l01 { []p }
```

# 表

| p | !p |
|---|----|
| F | T  |
| T | F  |

時相演算子[]がpの付与されているので、pが常に成立することを確認し、常に成立した場合に[]pが成立する。
Never Claimでは、LTLの否定を探すので、![]p = <>!p の成立を探すことになる。

# Never Claim

```Promela
never l01 {    /* !([] (p)) */
T0_init:
        do
        :: atomic { (! ((p))) -> assert(!(! ((p)))) }
        :: (1) -> goto T0_init
        od;
accept_all:
        skip
}
```

# Never Claim(手動編集)

```Promela
never l01 {    /* ![]p = <>!p */
T0_init:
        do
        :: atomic { !p -> assert(!(! ((p)))) }
        :: true -> goto T0_init
        od;
}
```

# 動作

- !pが成立する場合、trueも成立するため非決定的にどちらかが選ばれる。
  - !pが選択された場合、assertion violateとなる。
    !pの成立はすなわち、LTLのpの非成立が確認できたことになるわけだから、エラーとして報告するため、
	assertで失敗させている。
  - trueが選択された場合、T0_initにジャンプするので次の検査時に再度同じような検査が行われる。
- pが成立する場合、ガード条件が用意されていないため、trueが決定的に選ばれる。
  T0_initにジャンプするので次の検査時に再度同じような検査が行われる。

# 疑問なぜ以下の形ではないのか

```Promela
never l01 {    /* ![]p = <>!p */
T0_init:
        do
        :: atomic { !p -> assert(!(! ((p)))) }
        :: else -> goto T0_init
        od;
}
```

spinのよる変換では、else部分がtrueとなっているがなぜだろうか。
elseを使用すると、!p成立時の分岐が決定的に選ばれるので検証が単純になりそうだが。


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
bool p = true;

active proctype A()
{
  p;
  p = false;
}
```

## 検証結果


```
$ spin -run -ltl l01 -a alp02.pml 
pan:1: assertion violated  !( !(p)) (at depth 4)
pan: wrote alp02.pml.trail

(Spin Version 6.5.0 -- 17 July 2019)
Warning: Search not completed
	+ Partial Order Reduction

Full statespace search for:
	never claim         	+ (l01)
	assertion violations	+ (if within scope of claim)
	acceptance   cycles 	+ (fairness disabled)
	invalid end states	- (disabled by never claim)

State-vector 20 byte, depth reached 4, errors: 1
        3 states, stored
        0 states, matched
        3 transitions (= stored+matched)
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
$ spin -t0 alp02.pml
ltl l01: [] (p)
Never claim moves to line 4	[(1)]
spin: _spin_nvr.tmp:3, Error: assertion violated
spin: text of failed assertion: assert(!(!(p)))
Never claim moves to line 3	[assert(!(!(p)))]
spin: trail ends after 5 steps
#processes: 1
		p = 0
  5:	proc  0 (A:1) alp02.pml:7 (state 3) <valid end state>
  5:	proc  - (l01:1) _spin_nvr.tmp:2 (state 6)
1 processes created
```