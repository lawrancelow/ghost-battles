# 生產鏈要生的新圖（設計線 chain-data，2026-11-19）

畫風：與現有 mvs_*／mvi_* 一致——Q 版、詭異可愛、深色陰間村配色（墨綠、暗紫、舊紙黃，帶一點青白鬼火光），粗描邊、透明背景。
- 圖示（icon）：正方，單件物件置中，留邊，縮小到 24px 仍認得出（與 mvi_bun、mvi_plank 同樣大小和角度）。
- 建築：村子後院建築，與現有 wood／rice／plank／bun 村子建築圖同一視角和比例，底部對齊地面，不要畫出格。

圖到了以後：在 `godot/tools/chain_build.py` 把對應材料／建築的圖鍵（目前暫借的鍵）改成下面的新鍵，再執行 `python3 tools/chain_build.py`、`python3 tools/chain_check.py`（會列出哪些鍵已經有圖）。

## A. 新材料圖示（18 張）

| 新圖鍵 | 材料（mid） | 目前暫借 | 外觀描述 |
|---|---|---|---|
| mvi_wellwater | 枯井水 m_wellwater（T1） | mvs_well | 一個舊木桶，只有半桶黑水，水面映出一張不屬於你的臉；桶邊搭著一根青白手指 |
| mvi_bamboo_raw | 後山竹 m_bamboo（T1） | mvi_bamboo | 一捆青竹用草繩紮著，其中一節竹上有一隻眼睛在眨 |
| mvi_coconut | 椰子 m_coconut（T1） | n30_yezi__coconut | 一顆棕色毛椰子，頂部有個腫包（像剛砸中人頭），三個椰眼像一張驚訝的臉 |
| mvi_latex | 膠汁 m_latex（T1） | mvs_rubber | 一個綁在樹皮上的膠杯，盛著白色膠汁，膠汁表面有一個微笑 |
| mvi_tealeaf | 霧谷茶葉 m_tealeaf（T1） | mvi_tea | 一撮深綠茶葉，被一團白霧包著，霧裡隱約有手 |
| mvi_straw_raw | 禾稈草 m_straw（T1） | mvi_straw | 一紮濕稻草，草尾滴水，像在哭 |
| mvi_bananaleaf | 蕉葉 m_bananaleaf（T1） | mvi_leaf | 一張自己捲起一半的蕉葉，像蓋著被子在睡覺 |
| mvi_fish | 河口魚 m_fish（T1） | mvi_saltfish | 一條灰銀色河魚，張大嘴在說話（頭上一個小對話泡，不用寫字，畫三個點就好） |
| mvi_newspaper | 舊報紙 m_newspaper（T1） | furnace__paper | 一疊褪色舊報紙，頭條位置是一片模糊黑影，紙角捲起 |
| mvi_toner | 碳粉 m_toner（T1） | of_cabinet | 一盒影印機碳粉，倒出一堆黑粉，粉面反光映出一個人影 |
| mvi_baozi | 普通包子 m_bao（T2） | bun | 一個很正常的白包子，十八摺收口，正常得有點詭異（表面光滑、沒有表情，旁邊一滴汗） |
| mvi_paper | 竹紙 m_paper（T2） | op_paper | 一疊黃色竹紙，最上面那張透光可見一個人影 |
| mvi_strip | 竹篾 m_strip（T2） | mvi_bamboo | 一束細長竹篾，其中一條彎著，像在喊痛 |
| mvi_cocomilk | 椰漿 m_cocomilk（T2） | mvi_coconutrice | 半個椰殼當碗盛著白椰漿，碗邊搭著一隻很長很長的手 |
| mvi_rubbersheet | 生膠片 m_rubbersheet（T2） | mvi_slipper | 一張米黃色生膠片捲起一半，像在睡覺，有一對閉著的眼睛 |
| mvi_rope | 草繩 m_rope（T2） | mvi_straw | 一卷草繩，中間打了一個結，摻著幾根黑色長髮 |
| mvi_pulp | 報紙漿 m_pulp（T2） | furnace__stack | 一桶灰色紙漿，表面浮著幾個報紙鉛字 |
| mvi_ink | 影印墨 m_ink（T2） | mvi_form | 一瓶黑墨，幾個小小的字從瓶口排著隊爬出來 |

## B. 改名貨品圖示（2 張）

| 新圖鍵 | 貨品 | 目前暫借 | 外觀描述 |
|---|---|---|---|
| mvi_jiaoyejuan | 蕉葉糯米卷 m_jiaoye（T3） | mvi_leaf | 兩條用蕉葉包著、烤到邊緣焦黑的糯米卷，用竹籤串著，蕉葉自己捲得很緊 |
| mvi_plankshield | 二手棺材板盾 m_jiuban（T3，裝備·盾） | mvi_plank | 一塊曬到裂開的舊棺材板，背面釘了一個把手，正面是木蟲逃光後留下的洞 |

（加班頭燈 m_jiabandeng 沿用 mvi_lamp；美術有空的話，可補一張「戴在頭上的紙紮燈籠頭盔」mvi_headlamp。）

## C. 村子後院新建築（17 張）

| 新圖鍵 | 建築（bid） | 目前暫借 | 外觀描述 |
|---|---|---|---|
| vb_well | 枯井轆轤 b_well（採集，第 1 張圖） | pr_well | 磚砌枯井加木轆轤，繩子垂進黑暗，井口有半隻手扶著 |
| vb_bamboo | 後山竹林 b_bamboo（採集，第 1 張圖） | mvs_bamboo | 一小片竹林，竹竿彎腰像在偷看，地上有幾截砍斷的竹頭 |
| vb_coco | 椰林 b_coco（採集，第 2 張圖） | n30_yezi__coconut | 兩棵椰樹，樹下站著一隻頭頂腫包的鬼在抬頭看 |
| vb_latex | 膠園 b_latex（採集，第 2 張圖） | mvs_rubber | 兩棵割了斜紋的膠樹，樹身掛著膠杯，旁邊一盞凌晨用的頭燈 |
| vb_tea | 霧谷茶田 b_tea（採集，第 3 張圖） | mvs_teahouse | 一級級小茶田，被濃霧蓋住一半，霧裡有個戴竹笠的背影 |
| vb_straw | 禾稈草堆 b_straw（採集，第 3 張圖） | mvi_straw | 一個大稻草堆，旁邊一個稻草人在拆自己身上的草 |
| vb_banana | 蕉園 b_banana（採集，第 4 張圖） | mvs_banana | 幾棵香蕉樹，蕉葉自己捲起，最大那棵樹下有一雙小紅鞋 |
| vb_fish | 河口罾棚 b_fish（採集，第 4 張圖） | mvs_fish | 河邊竹棚吊著一張大罾網，水面伸出一隻濕手幫忙拉 |
| vb_newspaper | 橋底回收站 b_newspaper（採集，第 5 張圖） | pr_boxes | 高架橋底一堆紮好的舊報紙和紙皮，一把舊秤，秤砣的位置是一個鬼頭 |
| vb_toner | 地庫碳粉房 b_toner（採集，第 6 張圖） | mvs_copier | 地下室機房一角，一台舊影印機自己在吐白紙，地上一堆黑碳粉 |
| vb_paper | 紙寮 b_paper（加工，第 1 張圖） | op_paper | 竹搭小寮，一個水槽和一張竹簾，簾上撈起一張紙，紙上有人影 |
| vb_strip | 破篾棚 b_strip（加工，第 2 張圖） | mvs_bamboo | 矮棚下一張木凳，篾刀插在竹上，地上散著篾條 |
| vb_cocomilk | 刨椰寮 b_cocomilk（加工，第 2 張圖） | mvs_ricepot | 高腳木寮，刨椰凳上坐著一隻手很長的鬼，那隻手伸到畫面外 |
| vb_rubbersheet | 膠片房 b_rubbersheet（加工，第 2 張圖） | mvs_rubber | 鐵皮屋前一台手搖壓膠機，竹竿上晾著一排捲起的膠片 |
| vb_rope | 搓繩棚 b_rope（加工，第 3 張圖） | mvs_straw | 草棚下一個繩架，掛著幾卷草繩，繩裡摻著黑色長髮 |
| vb_pulp | 紙漿池 b_pulp（加工，第 5 張圖） | pr_puddle | 一個水泥池盛著灰色紙漿，池邊一根攪漿棍，漿面冒出半個頭 |
| vb_ink | 碳粉墨房 b_ink（加工，第 6 張圖） | mvs_files | 一間小小的辦公室儲物房，一個大墨缸，攪墨棍自己在轉 |

紅線：不要畫神像、符、香燭、廟宇元素；不要有真實品牌字樣（影印機、報紙頭條不要寫真實牌子）；不要畫小孩。
