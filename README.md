# spinPrac

spinによるモデル検証の練習

# メモ

## LTL

p : 原子命題

- p : p.md, p01.pml
- []p : alp.md, alp01.pml
- <>p : evp.md, evp01.pml
- []<>p : 進行性 : alevp.md, alevp01.pml
- <>[]p : evalp.md, evalp01.pml

- <>p -> q
- p -> <>q : pimpevq.md, pimpevq01.pml
- <>p -> <>q : evpimpevq.md, evpimpevq01.pml

- <>(p -> <>q) : ev_pimpevq.md, ev_pimpevq01.pml
- <>(p -> q) : ev_pimpq.md, ev_pimpq01.pml

- p -> []q : pimpalq.md, pimpalq01.pml
- [](p -> q) : al_pimpq.md al_pimpq01.pml

- p -> []<>q : pimpalevq.md, pimpalevq01.pml
- p -> <>[]q : pimpevalq.md, pimpevalq01.pml

- [](p -> <>q) : 応答性 : al_pimpevq.md, al_pimpevq01.pml
- []<>p -> q : 無条件公平性 : alevpimpq.md, alevpimpq01.pml

## Never Claim
