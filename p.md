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

!pが成立したら、assertion violateとなる。
