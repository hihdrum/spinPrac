# LTL

```Promela
ltl l01 { [](p -> <>q) }
```

# 表

LTL :  [](p -> <>q) = [](!p || <>q) = []!p || []<>q

Nevet Claim : ![](p -> <>q) = ![](!p || <>q) = <>!(!p || <>q) = <>(!!p && !<>q)
 = <>(p && []!q)

# Never Claim

```Promela
never l01 {    /* !([] ((! (p)) || (<> (q)))) */
T0_init:
        do
        :: (! ((! (p))) && ! ((q))) -> goto accept_S4
        :: (1) -> goto T0_init
        od;
accept_S4:
        do
        :: (! ((q))) -> goto accept_S4
        od;
}
```

# Never Claim(手動編集)

```Promela
never l01 {    /* ![](!p || <>q) = <>(p && []!q) */
T0_init:
        do
        :: p && !q -> goto accept_S4
        :: true -> goto T0_init
        od;
accept_S4:
        do
        :: !q -> goto accept_S4
        od;
}
```

# 動作

- T0_init
  - p && !q が成立する場合、trueも成立するので非決定的な動作となる。
    - p && !q が選択された場合、accept_S4に遷移し、[]!qの検査継続となる。
    - trueが選択された場合、続く時相フレームで再度T0_initから検査を行う。
      <>(...)の部分に相当する動作となる。
- accept_S4
  - []!qの成立を検査する状態である。
- spinが出力したPromelaコード
  - p && q が成立した場合、true部分が選択されるので、応答となみなされない
    ようである。
  - p && !q の成立がaccept_S4の条件となっているので、pのみの成立を要求として
    みているようだ。


# サンプルモデル1

## 検証結果

# サンプルモデル2

## 検証結果

## 反例
