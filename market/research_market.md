# 市集資料組報告：現有大排檔審查與對標經營遊戲

日期：2026-11-28　用途：「過勞鬼市集」大更新
依據：origin/kpi 分支代碼與數據（`godot/data/nat/outpost.json`、`game/outpost/mv_data.gd`、`mv_scene.gd`、`mv_cust.gd`）、`/home/claude/meeting/dev_metrics.md`、`design_inventory.md`、`research.md`、項目文檔 UX_Audit_20261127。
說明：本次未另跑機器人量測。原因是全機 Godot 測試排隊（2 核 8G，各線都在跑），而且現有量測腳本 meter_test 是從新存檔起跑，在新流程裡大排檔要到約第 35–45 分鐘才開；跑一輪會佔測試槽超過半小時。下面的運行數據引用開發組 meter_test 的實測（`dev_metrics.md`，補丁 54 源碼）與 UX_Audit。引用網頁原文每個來源最多一個短語，其餘為轉述。

---

## 一、現有大排檔的問題清單（附證據）

| # | 問題 | 證據 |
|---|---|---|
| P1 | **一張地圖一條街、品類混雜**：每張圖 7–9 個台，食物、衣服、家具、兵器、雜貨混在同一條路上（例：第 1 圖 壽包、紙衫、豆花、糯米糍、棺材板床、燈籠、挑擔），玩家看不出「這一區賣甚麼」，也沒有分區經營的感覺 | `outpost.json` MAPS[*].stations；39 種貨沒有品類欄位 |
| P2 | **里程碑其實已有，但玩家感覺不到**：Idle Outpost 式里程碑（Lv10／25／50／100／150／200，速度 ×2、售價 ×2 交替，品質星）已實作，但回饋只是一條 2.6 秒的橫幅「收益 ×N！」，沒有外觀變化、沒有加員工、沒有數字暴增演出 | `mv_data.gd` MILES、`mv_scene.gd:421-423`；會議 design_inventory B1「沒有短循環大數字增長」 |
| P3 | **數字膨脹過快、地圖之間斷層**：貨品單價由 4（壽包）一路到 3.12 億（紙紮考勤卡），每張新圖從頭建、舊圖經營歸零；沒有跨地圖的永久加成 | `outpost.json` GOODS price；design_inventory B6 |
| P4 | **回饋慢、早期一分鐘只賣幾件**：UX_Audit 指壽包 30 分鐘才 2 個（補丁 52 前）；實測 8 分鐘後冥幣 667、壽包 284 沒地方花 | UX_Audit 一；dev_metrics 二、悶點 5 |
| P5 | **畫面雜亂**：39 個台、要貨泡、閒聊泡、加速／收益掣、告急掣、孤魂、義勇軍同屏；補丁 55 已減（泡只出排頭 2 位、閒聊最多 1 個），但同屏元素仍多 | 老闆截圖回饋（11/28 08:02）；補丁 55 commit 440da96 |
| P6 | **客人只是「要貨單」**：50 種客人（6 個 VIP），每人有台詞，但客人沒有記憶、不回訪、沒有名字成長；VIP 只是要貨量大 | `outpost.json` CUSTOMERS（vip 欄 6 個）、`mv_cust.gd` wants |
| P7 | **加速／收益 ×2 是冷卻按鈕**：收益 ×2（5 分鐘、冷卻 20 分鐘）、加速 ×2（2 分鐘、冷卻 10 分鐘），只是按了等，沒有取捨，和「過勞」主題無關 | `mv_data.gd` BOOST_INC／BOOST_SPD；`mv_scene.gd:1354` |
| P8 | **防守干擾經營**：告急、霸檔、鬼潮會同時發生；補丁 52 已減少前期襲擾，補丁 55 讓霸檔孤魂站到攤位上，但仍可能多處同時告急 | UX_Audit；補丁 52／55 |
| P9 | **沒有每日回流、沒有潮流變化**：每天賣的東西一樣，沒有「今日熱賣」，回陽間帶回的供品與大排檔貨品沒有直接連動 | design_inventory B2、C4 |
| P10 | **經濟出口不足**：冥幣多但缺少「再存一點就能做某件事」的目標；目標表（goals）獎勵由 20 跳到 80000 冥幣，膨脹大於感受 | `outpost.json` MAPS[0].goals；dev_metrics 悶點 5 |

---

## 二、對標遊戲可借鑒的機制（對應新設計）

### 1. 五條街（分區、品類、組合）
- **Kairosoft《Mega Mall Story》**：同類店鋪放在一起組成「組合」，大幅提升收入，例：組合完成後糖果店單價由 300 升到 1700；組合與新店會推高人氣。出處：https://kairosoft.wiki.gg/wiki/Tips_(Mega_Mall_Story)
  → 套用：每條街湊齊指定攤位（如食街「宵夜三寶」）觸發「街坊組合」加成；跨街組合（衣街＋飾品街＝「行頭套裝」）讓客人一次買齊。
- **Kairosoft**：顧客送禮請求，把店換成他要的類型能把他變成熟客。出處：同上
  → 套用：熟客點名要某類貨，開對應攤位就升熟客等級。
- **Supermarket Simulator**：玩家喜歡店面「看得見地長大」、自己排佈局；差評集中在早期客人要沒有授權的貨、空手離開。出處：https://gametyrant.com/news/supermarket-simulator-review-why-are-these-games-so-addicting
  → 套用：客人只要「已開放街道」的貨（延續補丁 50 的規則）；新街開張時街景明顯擴張。

### 2. 過勞營業（加班模式＋過勞值）
- **Two Point Hospital**：員工體力隨時間下降，靠咖啡機或休息恢復；需求不滿足、拖延升職會讓員工不開心，最終威脅辭職。出處：https://www.ludo.guide/guide/two-point-hospital/staff-happiness-staff-threats
  → 套用：過勞值＝體力的反面；休息、餵包子、茶水間（建築）恢復；長期過勞的店員「申請轉崗」（搞笑版辭職）而不是永久損失。
- **My Perfect Hotel**：手動做事很快變重複，形成瓶頸，直到僱人自動化；連續小獎勵讓人放不下。出處：https://martinjurasek.substack.com/p/900-seconds-with-my-perfect-hotel
  → 套用：加班模式是「主動拼」的時刻，平時交給店員自動；加班帶來的是短期爆量，不能變成必須一直點。

### 3. 子時高峰（爆單節奏）
- **Overcooked**：快慢、難易交替的推拉節奏讓人投入；時間壓力＋多任務製造緊張；荒謬的意外讓失敗變好笑；複雜度逐步加入。出處：https://uxdesign.cc/the-ux-of-overcooked-from-umami-to-unexpected-design-principles-56e9ea146f7e
  → 套用：子時高峰前有預告（鐘聲、燈籠變紅），高峰時人潮＋限時大客＋爆單音樂；高峰後是喘息期，用來升級、清倉。高峰中的「意外」用搞笑方式（如紙紮外賣被風吹走）。
- **Cook, Serve, Delicious!**：高峰時段被評論形容為噩夢般忙亂；菜單選擇影響口碑（健康菜慢但有小費）。出處：https://www.gamezebo.com/reviews/cook-serve-delicious-review/
  → 套用：高峰要「可應付」而不是懲罰；貨品有快慢取捨（快貨量大、慢貨給小費／名聲）。

### 4. 潮流榜
- **Mega Mall Story**：人氣有上升條，節日前衝人氣、宣傳和新聞事件帶來人氣暴增。出處：https://kairosoft.wiki.gg/wiki/Tips_(Mega_Mall_Story)
  → 套用：「陽間潮流榜」每日換 3 款熱門貨（售價 ×1.5–2），農曆節日（化寶爐已有 17 個節日）推節日潮流；回陽間帶回的供品觸發「陽間新聞」解鎖新潮流貨。
- **Idle Outpost**（前次報告）：3 天輪換主題活動是留存主力。出處：https://www.pocketgamer.biz/how-rockbite-games-transformed-its-idle-game-into-an-idle-rpg

### 5. 熟客
- **Good Pizza, Great Pizza**：訂單由大量隨機元件組合，基於真實菜單引起熟悉感；故事靠客人推動，客人來自日常人物原型，玩家因為「熟悉的客人行為」覺得好笑。出處：https://www.gamedeveloper.com/design/good-pizza-great-pizza-would-not-exist-if-not-for-costco
  → 套用：熟客有名字、固定造型、每次來說新的一句（延續），熟客等級上升解鎖支線；可直接沿用酒館普通鬼生成器（種子固定外觀＋名字＋口頭禪）。
- **Whiteout Survival**（前次報告）：有名字、會寄信的居民讓基地感覺是活的。出處：https://naavik.co/deep-dives/four-x-evolution-2/
  → 套用：熟客寄感謝信／投訴信，接化寶爐來信系統。

### 6. 評論家
- **Cook, Serve, Delicious!**：口碑（buzz）由菜單決定並影響客流；餐廳要完成清單才升星。出處：https://www.gamezebo.com/reviews/cook-serve-delicious-review/
- **Mega Mall Story**：取得星級是一種新聞事件，帶來人氣。出處：https://kairosoft.wiki.gg/wiki/Tips_(Mega_Mall_Story)
  → 套用：「陰間米芝蓮」不定期出現，按該街貨品品質星、供貨速度、潮流命中打分；高分整條街名聲上升並掛牌（街頭永久裝飾＝成就感）。

### 7. 里程碑表現（解決 P2）
- **Balatro**（前次報告）：數字逐位滾動、音高遞升、按大小分級震動。出處：https://blakecrosley.com/guides/design/balatro
- **Idle Outpost**（前次報告）：升級台 → 速度翻倍 → 錢跳得更快，每 1–2 分鐘一次升級回饋。
  → 套用：現有里程碑保留，但每到里程碑：攤位外觀換一階、多一個店員、全屏大字＋煙花＋數字滾動（爽感包已有接口）。

---

## 三、要避開的坑
1. **早期客人要沒開放的貨、空手離開**（Supermarket Simulator 差評）：客人只要已開放街道的貨。
2. **手動維護變成瓶頸**（My Perfect Hotel）：加班模式只能是選擇，不能是唯一提速手段。
3. **高峰變成懲罰**（Cook, Serve, Delicious! 的「噩夢」評價）：高峰失敗不扣錢，只是少賺；要有預告和喘息期。
4. **過勞系統太囉嗦**（Two Point Hospital 員工需求多）：只留一個過勞值＋一種恢復（休息／包子），不要飢餓、口渴、如廁多條。
5. **數字膨脹失控、跨圖歸零**（現有 P3）：新市集用「街道永久等級」或「老員工」跨地圖帶走，減少重來感。
6. **彈窗、廣告式加速**（Idle Outpost 差評）：現有收益 ×2／加速冷卻掣應被「過勞營業」取代，不要兩套並存。
7. **同屏太多**（現有 P5）：一次只顯示一條街。

---

## 四、十條關鍵發現
1. 現有大排檔每張圖只有一條街、7–9 個台，品類混雜；改成五條街是結構性改動，不只是換名。
2. Idle Outpost 式里程碑（速度／售價 ×2、品質星）其實已經做了，問題在表現：只有 2.6 秒橫幅，沒有外觀變化和加員工。
3. 現有收益 ×2、加速 ×2 冷卻按鈕應由「過勞營業」取代，兩套並存會重複又雜亂。
4. 貨品單價由 4 膨脹到 3.12 億、每圖重來；需要跨地圖保留的東西（街道等級、老員工）。
5. Mega Mall Story 的「組合」（同類店相鄰加成）最適合五條街：湊齊一條街的組合就有明顯收入跳升。
6. Two Point Hospital 證明「體力＋休息」能製造管理樂趣，但要簡化成單一過勞值。
7. Overcooked 的推拉節奏適合子時高峰：預告 → 爆單 → 喘息，失敗要好笑不要懲罰。
8. 潮流榜可以把化寶爐節日、回陽間供品、奢侈品三者串起來，解決「每天賣一樣東西」。
9. 熟客可直接沿用酒館普通鬼生成器（固定外觀、名字、口頭禪），成本低。
10. 評論家打分＋街頭掛牌提供看得見的成就感，補上「沒有成就牆」的缺口。

---

## 參考來源
- Kairosoft Wiki, Tips (Mega Mall Story): https://kairosoft.wiki.gg/wiki/Tips_(Mega_Mall_Story)
- Martin Jurasek, 900 seconds with My Perfect Hotel: https://martinjurasek.substack.com/p/900-seconds-with-my-perfect-hotel
- GameTyrant, Supermarket Simulator Review: https://gametyrant.com/news/supermarket-simulator-review-why-are-these-games-so-addicting
- UX Collective, The UX of Overcooked: https://uxdesign.cc/the-ux-of-overcooked-from-umami-to-unexpected-design-principles-56e9ea146f7e
- Game Developer, Good Pizza Great Pizza: https://www.gamedeveloper.com/design/good-pizza-great-pizza-would-not-exist-if-not-for-costco
- Ludo Guide, Two Point Hospital staff happiness: https://www.ludo.guide/guide/two-point-hospital/staff-happiness-staff-threats
- Gamezebo, Cook, Serve, Delicious! Review: https://www.gamezebo.com/reviews/cook-serve-delicious-review/
- 前次報告引用：PocketGamer.biz（Idle Outpost）、Naavik（Whiteout Survival）、blakecrosley.com（Balatro），見 `/home/claude/meeting/research.md`
- 註：「开个密室馆」本次未找到新的玩家評價（搜到的 TapTap 評論是另一款密室遊戲，已排除），沿用前次報告的拆解。
