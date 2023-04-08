# LTL

```Promela
ltl l01 { p -> []<>q) }
```

# 表

LTL : p -> []<>q = !p || []<>q

Nevet Claim : !(p -> []<>q) = !(!p || []<>q) = !!p && ![]<>q = p && <>[]!q

# Never Claim

```Promela
never l01 {    /* !((! (p)) || ([] (<> (q)))) */
T0_init:
        do
        :: (! ((! (p))) && ! ((q))) -> goto accept_S9
        :: (! ((! (p)))) -> goto T0_S8
        od;
accept_S9:
        do
        :: (! ((q))) -> goto accept_S9
        od;
T0_S8:
        do
        :: (! ((q))) -> goto accept_S9
        :: (1) -> goto T0_S8
        od;
}
```

# Never Claim(手動編集)

```Promela
never l01 {    /* !(!p || []<>q) = p && <>[]!q */
T0_init:
        do
        :: p && !q -> goto accept_S9
        :: p -> goto T0_S8
        od;
accept_S9:
        do
        :: !q -> goto accept_S9
        od;
T0_S8:
        do
        :: !q -> goto accept_S9
        :: true -> goto T0_S8
        od;
}
```

# 動作

- T0_init
  - p && !qのケース、すなわちp -> qがFとなる場合、[]!qを検査するため、
    accept_S9に遷移する。
  - pが成立する場合、<>!qの可能性をみるため、T0_S8に遷移する。
- accept_S9
  - []!qを検査する部分である。!qが成立し続ければ受理状態となり、LTL反例の
    検出となる。qが成立すれば、遷移先無しで検証終了となる。
- T0_S8
  - 前提条件q成立時の状態である。
  - !qが成立時は非決定的な動作となる。
    - !q部分が選択されたら、accept_S9に遷移し、[]!qの検査を続ける。
    - true部分が選択されたら、<>!qの可能性を見るため再度T0_S8に戻る。
  - qが成立する場合、true部分が決定的に選択されるので、<>!qの可能性を見るため
    再度T0_S8に戻る。


- accept_S9が受理された状態は、選定条件pが成立したが、
  qが成立しなかった場合である。

# サンプルモデル1

## 検証結果

# サンプルモデル2

## 検証結果

## 反例
