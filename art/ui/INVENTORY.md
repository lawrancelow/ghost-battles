# 過勞鬼大作戰 — 介面盤點與現況問題（美術二組，2026-11-27）

截圖：art/ui/shots/450x975/*.png（直屏）、art/ui/shots/1920x1080/*.png（PC）。截圖腳本：godot/tools/tests/uiart_shot.gd（每次一張，arg = 名稱）。

## 一、全部面板／彈窗清單（共 46 個，分 9 類）

| # | 類別 | 面板 | 程式位置 | 已截圖 |
|---|---|---|---|---|
| 1 | 常駐 HUD | 頂欄（主公等級、資源 6 格、好評、設置） | ui/main.gd | hud |
| 2 | 常駐 HUD | 主線任務條（紅「主線」標＋進度） | ui/main.gd | hud |
| 3 | 常駐 HUD | 底部導航（村子／鬼怪／地圖／箱子／劇情） | ui/main.gd _nav_on | hud |
| 4 | 常駐 HUD | 生產鏈浮鈕、收入×2／加速、新手保護 | game/outpost/mv_scene.gd | station |
| 5 | 常駐 HUD | 出擊大按鈕、迎戰提示「點我迎戰」 | game/rts、raid_view.gd | hud |
| 6 | 生產 | 台面板（例：嘆氣蒸籠） | mv_scene.gd open_sheet | station |
| 7 | 生產 | 派鬼揀人 | mv_scene.gd _open_picker | picker |
| 8 | 生產 | 營地建築面板（伐木場等） | ui/main.gd open_building | building |
| 9 | 生產 | 後院（舊村子設施）列表 | ui/main.gd open_backyard | backyard |
| 10 | 生產 | 生產鏈總覽 | game/outpost/chain_panel.gd | chain |
| 11 | 生產 | 分村面板（補給線／存糧倉） | game/garrison/gr_panel.gd | — |
| 12 | 生產 | 冥牌坊貨倉 | game/offer/offer_ui.gd | — |
| 13 | 生產 | 化寶爐／開包畫面 | game/joss/joss_ui.gd | — |
| 14 | 鬼怪 | 鬼怪名冊 | ui/main.gd open_roster | roster |
| 15 | 鬼怪 | 名鬼圖鑑（192 格、品級／系分頁） | game/soul/soul_codex.gd | codex |
| 16 | 鬼怪 | 圖鑑詳情 | soul_codex.gd open_detail | codex_detail |
| 17 | 鬼怪 | 祭壇四頁（招降／升職／散魂／招雜鬼） | game/soul/soul_ui.gd | — |
| 18 | 鬼怪 | 王座重遊 | soul_codex.gd open_throne | — |
| 19 | 裝備 | 紙紮兵器攤・訂製名鬼裝備 | game/equip/eq_ui.gd open_craft | equip |
| 20 | 裝備 | 裝備欄（單鬼換裝） | eq_ui.gd open_slot | — |
| 21 | 兵營 | 兵營面板（陰兵 4 兵種 × 階級） | game/barracks/bk_data.gd | barracks |
| 22 | 兵營 | 崗位／上限揀人 | game/barracks/bk_ui.gd | — |
| 23 | 兵營 | 遊魂兵資料卡 | game/militia/ml_ui.gd | — |
| 24 | 出擊 | 出擊卡（據點） | game/sortie/so_view.gd open_card | — |
| 25 | 出擊 | 主線選關、佈陣 | ui/battle_select/bt_select.gd | — |
| 26 | 出擊 | 地圖戰鬥 HUD（技能鈕、王血條） | game/rts/rts_view.gd | — |
| 27 | 出擊 | 戰鬥結算 | game/battle/bt_run.gd | — |
| 28 | 出擊 | 區域佔領／野外王卡 | game/zone/zone_battle.gd | — |
| 29 | 箱子 | 箱子（綠／藍／紫） | ui/main.gd open_chests | chests |
| 30 | 劇情 | 劇情回顧列表 | ui/main.gd open_story | story |
| 31 | 劇情 | 對白框＋頭像＋名牌 | ui/story.gd | — |
| 32 | 劇情 | 老電視插圖框 | ui/story_cg.gd | — |
| 33 | 劇情 | 手機聊天（ApaKhabar 仿 WhatsApp） | ui/whatsapp.gd | — |
| 34 | 劇情 | 名字卡（頭七回魂夜、選頭像） | ui/name_card.gd | — |
| 35 | 設置 | 設置・聲音 | ui/settings/settings_panel.gd | settings_sound |
| 36 | 設置 | 設置・畫面 | 同上 | settings_gfx |
| 37 | 設置 | 設置・劇情 | 同上 | settings_story |
| 38 | 設置 | 設置・存檔 | 同上 | settings_save |
| 39 | 設置 | 設置・支援 | 同上 | settings_help |
| 40 | 設置 | 導入存檔碼 | ui/main.gd open_import | import |
| 41 | 帳號 | 登入／註冊／遊客（account 分支，未上線） | ui/account/login_panel.gd | — |
| 42 | 通用 | 提示飄字、橫幅 | ui/main.gd show_toast/banner | toast |
| 43 | 通用 | 確認框（二選一） | 各處 UIKit | — |
| 44 | 小玩法 | 夜班巡陰選單、裝備房 | ui/patrol_menu/patrol_menu.gd | — |
| 45 | 小玩法 | 回陽間帶隊出更、陽間站崗彈窗 | ui/scare_select、game/station | — |
| 46 | 小玩法 | 冥街夜市／亂葬崗／運動會介面、陰間地圖 | game/minis/*、ui/world_map | — |

「—」= 要特定進度或劇情狀態才開得到，下一輪補截（用測試存檔直接呼叫）。

## 二、現況問題（看截圖得出）

1. **紙底太亮、和主題不搭**：台面板、建築面板、名冊、圖鑑、箱子、劇情回顧、裝備攤全部是米白／牛皮紙底，跟標題畫面與地圖的暗黑蠟筆完全兩個世界；只有設置面板是深色。
2. **沒有蠟筆質感**：面板框、按鈕、格子全是乾淨的扁平向量（圓角矩形＋細邊線），沒有任何筆觸、顆粒、手繪毛邊。
3. **按鈕樣式不一**：紅底白字（升級、出擊、打開）、深棕（一鍵穿戴、返回圖鑑）、灰（未開）、黃描邊（傭用）、紅條全寬（去營地看看）——至少 6 種，沒有統一主／次按鈕規則。
4. **標題列不統一**：有的標題粗黑字＋右上灰 ×，有的有返回鈕＋左右翻頁，有的沒有分隔；關閉鈕大小、位置各異。
5. **資訊層級雜亂**：台面板一屏塞 10 行小字（製作時間、售價、員工、升級條件、累計、上手…），主次不分；圖鑑分頁 9 個按鈕兩排擠在一起。
6. **HUD 頂欄過擠**：6 個資源格＋主公＋好評＋設置擠在 450 寬，數字小；寬屏 1920×1080 時頂欄和收入／加速按鈕被放得極大（另一組回報過）。
7. **字太小**：說明字 11–12px 灰字，手機上難讀。
8. **層級（已由程序組 D 修）**：台面板曾被地圖角色／關卡提示蓋住——補丁 50 已改不透明＋遮罩，新美術要沿用這個層級。

## 三、Steam／寬屏注意
- 所有框、按鈕、卡片做九宮格（四角裝飾固定、邊可拉伸），同一套素材直屏和寬屏共用。
- 寬屏面板限寬約 600–720px 置中；HUD 頂欄按高度縮放，不按寬度。
