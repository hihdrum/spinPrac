# LTL

```Promela
ltl l01 { p }
```

# 表

| p | !p |
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

ltl l01 { p }
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

## テーブル出力(-d)

```
proctype A
	state   1 -(tr   5)-> state   2  [id   0 tp   2] [----G] p01.pml:5 => (p)
	state   2 -(tr   6)-> state   0  [id   1 tp 3500] [--e-L] p01.pml:6 => -end-
claim l01
	state   4 -(tr   3)-> state   4  [id   2 tp   2] [-a--G] p01.pml:4 => (!(p))

Transition Type: A=atomic; D=d_step; L=local; G=global
Source-State Labels: p=progress; e=end; a=accept;
Note: statement merging was used. Only the first
      stmnt executed in each merge sequence is shown
      (use spin -a -o3 to disable statement merging)

pan: elapsed time 1.72e+07 seconds
pan: rate         0 states/second
```

## テーブル出力(-d -d)

```
STEP 3 A
	state   1 -(tr   5)-> state   2  [id   0 tp   2] [----G] p01.pml:5 => (p)
	state   2 -(tr   6)-> state   0  [id   1 tp 3500] [--e-L] p01.pml:6 => -end-
STEP 3 l01
	state   1 -(tr   3)-> state   4  [id   2 tp   2] [----G] p01.pml:4 => (!(p))
	state   2 -(tr   0)-> state   0  [id   0 tp   0] [----L] p01.pml:4 => assert(!(!(p)))
	state   3 -(tr   3)-> state   4  [id   2 tp   2] [----G] p01.pml:4 => (!(p))
	state   4 -(tr   3)-> state   4  [id   2 tp   2] [-a--G] p01.pml:4 => (!(p))
	state   5 -(tr   1)-> state   4  [id   6 tp   2] [----L] p01.pml:6 => .(goto)
	state   6 -(tr   1)-> state   7  [id   7 tp   2] [----L] p01.pml:3 => break
	state   7 -(tr   1)-> state   8  [id   8 tp   2] [-a--L] p01.pml:7 => (1)
	state   8 -(tr   4)-> state   0  [id   9 tp 3500] [--e-L] p01.pml:8 => -end-

Transition Type: A=atomic; D=d_step; L=local; G=global
Source-State Labels: p=progress; e=end; a=accept;
Note: statement merging was used. Only the first
      stmnt executed in each merge sequence is shown
      (use spin -a -o3 to disable statement merging)

pan: elapsed time 1.72e+07 seconds
pan: rate         0 states/second
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
「p = 0」(p = false)の行が報告されており、検証されていないことがわかる。
これは、Never Claimがp成立時に遷移先なしとなり検証終了するような記述になっているからと考えらる。

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
