# 標識圖樣盤點（2026-11-28）
## 仍是扁平簡單圖（要換）
- assets/ui/i-wood.svg 槐木、i-rice.svg 糯米、i-planks.svg 棺材板、i-buns.svg 壽包、i-coins.svg 冥幣、i-troops.svg 鬼／兵力
  - 用在：ui/main.gd 頂欄資源格（i-%s.svg）、game/joss/joss.gd mat_icon（化寶爐材料）、game/outpost/mv_scene.gd 1248 行（貨品沒有 mvi 圖時的後備）、game/minis/gs_panel.gd 77 行（冥幣）
- assets/ui/n-*.svg 底部導航舊圖：補丁 51 已由 UI 套件取代（kit_skin），不用再換
## 已是美術版（不用換）
- 貨品／材料 mvi_*（116 張，蠟筆插畫）：倉庫總覽、櫃台氣泡、生產鏈、任務條用
- 裝備 eqi_*_i、兵器 mvi_bingqi_*、狀態圖示（art/ab 戰鬥圖示 29 個）、UI 套件 45 件
## 本次產出
- 過渡版：res_planks（mvi_plank）、res_buns（mvi_bun）、res_troops（soul_a）、mat_bao（mvi_baozi）→ assets/ui/icons/*_128/_64.webp
- 待生成：res_wood、res_rice、res_coins（Chrome 全部離線，ChatGPT 無法使用）

## 生成規矩（老闆長期規矩，2026-11-28）
所有生成圖必須是亞洲風格，以東亞為主，可帶一點東南亞元素。
補生成槐木、糯米、冥幣時，提示詞必須明確寫：
`East Asian (Chinese/Hong Kong/Malaysian-Chinese) style, no Western elements`
並沿用：transparent background, no text, refined crayon/pastel game icon, Eastern underworld office-cabinet mood；不得有宗教、符咒、紙錢、方孔錢、品牌、字母。
