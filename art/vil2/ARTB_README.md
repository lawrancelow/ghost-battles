# 美術 B 組產出（art-b 分支）— 未經老闆過目，暫不接入遊戲

## 荒村建築三態（10 棟全齊）
`sprites/<key>_ruin.webp`、`sprites/<key>_repair.webp`；完成版沿用現有 `godot/assets/spr/<key>.webp`。
key：house 鬼宅、wood 伐木場、rice 糯米田、plank 棺材鋪、bun 包子鋪、store 倉庫、home 民宅、camp 嚇人訓練班（營）、altar 招魂台／酒館、furnace 化寶爐。
- 畫布尺寸、底部中心、物件高度都按原 sprite 自動對齊（bld_states.py），可直接同名替換廢墟／修復中顯示。
- 化寶爐三態 `furnace_ruin/repair/done.webp`：done 為重繪版（暖色爐火），是否取代原 furnace.webp 待老闆定。
- 總預覽：`PREVIEW_artb_v1.jpg`（每棟：廢墟｜修復中｜完成）。

## 普通鬼組合部件（第一批）
- `ghost_parts_sheet1.png` → `parts1/part_00..17.png`：身體 2（00 瘦高、01 矮胖）、頭 4（02–05）、髮型頭飾 4（06 辮、07 分頭、08 髻、09 宋谷帽）、上衣 4（10 唐裝、11 壽衣、12 反光背心、13 峇迪衫）、配件 4（14 工作證、15 香火袋、16 紙紮錶、17 口罩）。
- `ghost_mix.py` 隨機拼 12 隻 → `ghost_mix_test1.jpg`。對位為初版，上衣蓋身體、髮型套頭仍需逐件微調錨點。

## 工具
- `ghost_parts.py cut`：淺灰底總表自動切透明部件。
- `bld_states.py <sheet> <key> <outdir>`：左右兩版切開、去底、對齊原 sprite。
