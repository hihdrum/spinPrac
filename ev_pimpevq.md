# LTL

```Promela
ltl l01 { <>(p -> <>q) }
```

# 表

LTL : <>(p -> <>q) = <>(!p || <>q) = <>!p || <><>q = <>!p || <>q = <>(!p || q) = <>(p -> q)

Nevet Claim : <>(p -> <>q) = !<>(p -> <>q) = !(p -> q) = !<>(!p || q)  = []!(!p || q) = [](p && !q)

# Never Claim

```Promela
never l01 {    /* !(<> ((! (p)) || (<> (q)))) */
accept_init:
T0_init:
        do
        :: (! ((! (p))) && ! ((q))) -> goto T0_init
        od;
}
```

# Never Claim(手動編集)

```Promela
never l01 {    /* !(<> (!p || <> q)) = [](p && !q) */
accept_init:
T0_init:
        do
        :: p && !q -> goto T0_init
        od;
}
```

# 動作

# サンプルモデル1

## 検証結果

# サンプルモデル2

## 検証結果

## 反例
