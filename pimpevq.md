# LTL

```Promela
ltl l01 { p -> <>q }
```

# 表

p -> <>q = !p || <>q

!(p -> <>q) = !(!p || <> q) = !!p && !<>q = p && []!q

# Never Claim

```Promela
never l01 {    /* !((! (p)) || (<> (q))) */
accept_init:
T0_init:
        do
        :: (! ((! (p))) && ! ((q))) -> goto accept_S3
        od;
accept_S3:
T0_S3:
        do
        :: (! ((q))) -> goto accept_S3
        od;
}
```

# Never Claim(手動編集)

```Promela
never l01 {    /* !(!p || <> q) = p && []!q */
accept_init:
T0_init:
        do
        :: p && !q -> goto accept_S3
        od;
accept_S3:
T0_S3:
        do
        :: !q -> goto accept_S3
        od;
}
```

# 動作

- p && !q が成立したら、accept_S3に遷移する。
- 以降、!qが成立し続けると、 Never Claimの受理となり、LTLの反例が検出される。
  qが成立すると遷移先がなくなり、検証終了となる。

# サンプルモデル1

## 検証結果

# サンプルモデル2

## 検証結果

## 反例
