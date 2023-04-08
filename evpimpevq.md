# LTL

```Promela
ltl l01 { <>p -> <>q }
```

# 表

LTL : <>p -> <>q = !<>p || <>q = []!p || <>q

Nevet Claim : !(<>p -> <>q) = !([]!p || <>q) = ![]!p && !<>q = <>!!p && []!q = <>p && []!q

# Never Claim

```Promela
never l01 {    /* !((! (<> (p))) || (<> (q))) */
T0_init:
        do
        :: (! ((q)) && (p)) -> goto accept_S4
        :: (! ((q))) -> goto T0_init
        od;
accept_S4:
        do
        :: (! ((q))) -> goto accept_S4
        od;
}
```

# Never Claim(手動編集)

```Promela
never l01 {    /* !(!<>p || <>q) = <>p && []!q */
T0_init:
        do
        :: p && !q -> goto accept_S4
        :: !q -> goto T0_init
        od;
accept_S4:
        do
        :: !q -> goto accept_S4
        od;
}
```

# 動作

- p && !q が成立した場合は、accept_S4に遷移し、[]!qを成立を確認する。
- !qが成立する場合は、T0_initに戻る。[]!qを確認する。
- 上記二つの確認で、<>p の確認も行われている。

# サンプルモデル1

## 検証結果

# サンプルモデル2

## 検証結果

## 反例
