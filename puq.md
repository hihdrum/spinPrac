# LTL

```Promela
ltl l01 { p U q) }
```

q が成立するまでpが成立する。

「今の状態かそれ以降のどこかでqが成り立ち、それまではずっとpが成り立つ」
(参考 : 経営情報システム学特論1 6. 性質の検証(2))

「qは現在または将来の時点で真であり、かつpはその時点まで真である。その時点以降pは真になるとは限らない。」(Wikipedia)


# 表

| p | q |
|---|---|
| F | F |
| F | T |
| T | F |
| T | T |


LTL :  p U q

Never Claim : !(p U q)

# Never Claim

```Promela
never l01 {    /* !((p) U (q)) */
accept_init:
T0_init:
        do
        :: (! ((q))) -> goto T0_init
        :: atomic { (! ((p)) && ! ((q))) -> assert(!(! ((p)) && ! ((q)))) }
        od;
accept_all:
        skip
}
```

# Never Claim(手動編集)

```Promela
never l01 {    /* !((p) U (q)) */
accept_init:
T0_init:
        do
        :: !q -> goto T0_init
        :: atomic { !p && !q -> assert(!(! ((p)) && ! ((q)))) }
        od;
}
```

# 動作

- !q &&  !q成立の場合、!qも成立するので非決定的に処理が選ばれる。
- !qが成立する場合、T0_init(accept_init)から再度検査する。
  最終的に!qが成立し続けた場合、accept_initの受理状態となり、反例検出となる。
  qが成立することがなかったケースである。
- !p && !q が成立する場合、assertion violateでLTLの反例検出となる。
- p が成立する場合は、遷移先なしでNever Claimの検証が止まる。

# サンプルモデル

## p = false, q = false
```Promela
bool p = false;
bool q = false;

active proctype A()
{
  false;
}

ltl l01 { p U q }
```

### 結果

```
$ spin -run -ltl l01 puq01.pml
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
    0.291	actual memory usage for states
  128.000	memory used for hash table (-w24)
    0.534	memory used for DFS stack (-m10000)
  128.730	total actual memory usage



pan: elapsed time 0 seconds
```

## p = false, q = true
```Promela

bool p = false;
bool q = true;

active proctype A()
{
  false;
}

ltl l01 { p U q }
```

### 結果

```
$ spin -run -ltl l01 puq02.pml
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
    0.291	actual memory usage for states
  128.000	memory used for hash table (-w24)
    0.534	memory used for DFS stack (-m10000)
  128.730	total actual memory usage


unreached in proctype A
	puq02.pml:7, state 2, "-end-"
	(1 of 2 states)
unreached in claim l01
	_spin_nvr.tmp:9, state 10, "-end-"
	(1 of 10 states)

pan: elapsed time 0 seconds
```

## p = true, q = false
```Promela

bool p = true;
bool q = false;

active proctype A()
{
  false;
}

ltl l01 { p U q }
```

### 結果
```
$ spin -run -ltl l01 puq03.pml
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
    0.291	actual memory usage for states
  128.000	memory used for hash table (-w24)
    0.534	memory used for DFS stack (-m10000)
  128.730	total actual memory usage



pan: elapsed time 0 seconds
```

## p = true, q = true
```Promela

bool p = true;
bool q = true;

active proctype A()
{
  false;
}

ltl l01 { p U q }
```

### 結果
```
$ spin -run -ltl l01 puq04.pml
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
    0.291	actual memory usage for states
  128.000	memory used for hash table (-w24)
    0.534	memory used for DFS stack (-m10000)
  128.730	total actual memory usage


unreached in proctype A
	puq04.pml:7, state 2, "-end-"
	(1 of 2 states)
unreached in claim l01
	_spin_nvr.tmp:9, state 10, "-end-"
	(1 of 10 states)

pan: elapsed time 0 seconds
```

# サンプルモデル1( p U q の反例確認)

以下のようなサンプルを作成した。

```Promela
bool p = false;
bool q = false;

int t = 0;

active proctype A()
{
  do
  :: t > 0 -> break;
  :: else ->
      if
      :: atomic { p = false; q = false; printf("p = %d, q = %d\n", p, q); t++; }
      :: atomic { p = false; q = true; printf("p = %d, q = %d\n", p, q); t++; }
      :: atomic { p = true; q = false; printf("p = %d, q = %d\n", p, q); t++; }
      :: atomic { p = true; q = true; printf("p = %d, q = %d\n", p, q); t++; }
      fi;
  od
}

ltl l01 { p U q }
```

## 検証結果

```
$ spin -run -ltl l01 -e tmp01.pml
(Spin Version 6.5.0 -- 17 July 2019)
	+ Partial Order Reduction

Full statespace search for:
	never claim         	+ (l01)
	assertion violations	+ (if within scope of claim)
	acceptance   cycles 	+ (fairness disabled)
	invalid end states	- (disabled by never claim)

State-vector 28 byte, depth reached 9, errors: 23
       10 states, stored (20 visited)
       21 states, matched
       41 transitions (= visited+matched)
        0 atomic steps
hash conflicts:         0 (resolved)

Stats on memory usage (in Megabytes):
    0.001	equivalent memory usage for states (stored*(State-vector + overhead))
    0.288	actual memory usage for states
  128.000	memory used for hash table (-w24)
    0.534	memory used for DFS stack (-m10000)
  128.730	total actual memory usage


unreached in proctype A
	(0 of 29 states)
unreached in claim l01
	_spin_nvr.tmp:9, state 10, "-end-"
	(1 of 10 states)

pan: elapsed time 0 seconds
```

p,qの値に着目してエラートレイルを確認すると以下でエラーとなっていた。

### 結果が p = false, q = false となっているもの
#### !p && !q でassertion violateが選択されたケース
```
$ spin -t2 tmp01.pml
ltl l01: (p) U (q)
Never claim moves to line 4	[(!(q))]
          p = 0, q = 0
spin: _spin_nvr.tmp:5, Error: assertion violated
spin: text of failed assertion: assert(!((!(p)&&!(q))))
Never claim moves to line 5	[assert(!((!(p)&&!(q))))]
spin: trail ends after 10 steps
#processes: 0
		p = 0
		q = 0
		t = 1
 10:	proc  - (l01:1) _spin_nvr.tmp:3 (state 6)
1 processes created
```

#### !p && !q 成立時に !q 側が選択され受理状態となったケース
```
$ spin -t1 tmp01.pml
ltl l01: (p) U (q)
Never claim moves to line 4	[(!(q))]
          p = 0, q = 0
  <<<<<START OF CYCLE>>>>>
spin: trail ends after 10 steps
#processes: 0
		p = 0
		q = 0
		t = 1
 10:	proc  - (l01:1) _spin_nvr.tmp:3 (state 6)
1 processes created
```

### 結果が p = true, q = false となっているもの

!qが成立し続けたため、qが今を含めたどこかで成立するという条件が成立しなかったため、反例となっている。

```
$ spin -t17 tmp01.pml
ltl l01: (p) U (q)
Never claim moves to line 4	[(!(q))]
          p = 1, q = 0
  <<<<<START OF CYCLE>>>>>
spin: trail ends after 10 steps
#processes: 0
		p = 1
		q = 0
		t = 1
 10:	proc  - (l01:1) _spin_nvr.tmp:3 (state 6)
1 processes created
```
