# 過勞鬼大作戰・特效目錄（特效組）

版本：第一批（2026-11-26）｜工作分支：`vfx`（/home/claude/wt/vfx）｜程式目錄：`godot/game/fxkit/vfx_cat.gd`

## 0. 規格（全部特效一致）

- 格式：序列幀 4×4＝16 格，每格 256px，整張 1024×1024 PNG；純黑底，遊戲用加色混合（黑＝透明）
- 節奏：第 1–3 格起勢（細）、第 4–8 格頂點（最大最光）、第 9–16 格散走，第 16 格近乎全空
- 唔爆格：清理工具 `art/vfx/tools/clean_sheet.py` 會自動揾格縫、整張統一縮放到內容最多佔格 92%、每格邊 8px 羽化
- 風格：陰間詭異、蠟筆／油粉彩手繪質感、黑暗系；唔光鮮、唔可愛
- 禁止：西方元素、符咒／符字／宗教法器味、真實品牌；唔做血腥特效（噴血、血花）——抓傷、斬擊用暗紫、綠、黑陰氣表現
- 來源：老闆 ChatGPT Plus 生圖（可商用）；原圖 `art/vfx/raw/`，清理後 `art/vfx/sheets/`，遊戲用 `godot/art/vfx/<key>.png`

## 1. 播放方式（代碼）

| 位置 | 做咩 |
|---|---|
| `game/rts/abil.gd` `trig()` | 副技／王牌技發動時加一行 `sim._vq(["sk2", u, pe, ts])` |
| `game/rts/rts_fx.gd` `sk2()` | 由目錄揀序列幀、按 `at` 放位置；王牌技另加柔光＋輕微震屏 |
| `game/fxkit/fx_kit.gd` `draw_spr()` | 加 `grid` 參數：按進度揀格（`draw_texture_rect_region`）；舊單張貼圖照舊 |
| `game/fxkit/vfx_play.gd` | 介面上播一次（升級用），播完自己消失，唔擋點擊 |
| `game/soul/soul_up_ui.gd` | 融合成功播 `up_fuse`；突破成功播 `up_star` |

冇圖嘅鍵唔會播（目錄有但檔案未放＝零影響），所以可以逐批加。

`at`（放喺邊）：`tgt` 目標身中｜`tgt_all` 每個目標各一個（最多 4）｜`tgt_g` 目標腳底｜`self` 自己身中｜`area` 自己腳底大範圍｜`line` 自己→目標中點｜`ui` 畫面正中

## 2. 特效家族（20 個，同一家族配色一致）

| 家族 | 主色 | 用喺 |
|---|---|---|
| 斬 slash | 暗紫＋骨白邊 | 扇形斬、斬殺、爪 |
| 撞 smash | 骨白閃＋啡灰塵 | 震地、搥地、撞低、頂 |
| 爆 blast | 暗金＋餘燼橙 | 轟、重擊、吼 |
| 毒霧 miasma | 暗綠／病黃綠 | 毒、咬、迷惑 |
| 鬼火 wisp | 淡青綠 | 燒一片、飛頭、彈射 |
| 冰霜 frost | 淡冰藍 | 凍一片、減速 |
| 雷 thunder | 紫電＋淡金芯 | 大吼、打斷 |
| 紙錢 coin | 舊金＋骨白 | 派能量、加攻 |
| 頭髮 hair | 墨黑髮＋淡綠光 | 女鬼聲波、纏 |
| 長舌 tongue | 暗紫紅（唔係血紅） | 卷、拉 |
| 鎖鏈 chain | 鐵灰＋紫黑煙 | 定身、鎖 |
| 黑影 shadow | 黑＋暗紫 | 閃後排、消失 |
| 魂光 soul | 淡金／淡青 | 抽能量、返生、升級 |
| 治療光 heal | 淡翠綠＋奶白 | 治療、回血、淨化 |
| 護盾 guard | 青藍＋白邊 | 護盾、企硬、減傷 |
| 隱身煙 smoke | 黑紫煙 | 隱身 |
| 召喚陣 circle | 淡藍灰（純幾何圈，冇字） | 範圍定身、召喚 |
| 電話信號 signal | 青綠掃描線 | 電話系、封口 |
| 口水 spit | 黃綠黏液 | 減速、易傷 |
| 風刃 wind | 淡青白 | 直線穿、點殺、衝 |

## 3. 第一批（已生成，待審批）

### 3a. 王牌技 19 個（每隻專屬）

| 鍵 | 技能 | 鬼 | 家族 | 位置 | 秒 | 主色 |
|---|---|---|---|---|---|---|
| ace_heiwu | 鎖魂待審 | 黑無常 | 鎖鏈 | 目標 | 1.1 | 鐵灰＋紫黑 |
| ace_baiwu | 一見發財 | 白無常 | 紙錢 | 自己 | 1.2 | 舊金＋骨白 |
| ace_mengpo | 忘憂湯 | 孟婆 | 治療光 | 範圍 | 1.3 | 淡翠綠 |
| ace_niutou | 牛氣沖天 | 牛頭 | 撞 | 範圍 | 0.9 | 啡＋餘燼橙 |
| ace_mamian | 馬不停蹄 | 馬面 | 風刃 | 直線 | 0.8 | 淡鬼藍 |
| ace_huapi | 借皮 | 畫皮 | 剝皮（專屬） | 目標 | 1.1 | 象牙白＋淡紫 |
| ace_qiongqi | 顛倒是非 | 窮奇 | 毒霧 | 目標 | 1.1 | 深紫＋病綠 |
| ace_nian | 大年夕 | 年獸 | 爆 | 範圍 | 1.0 | 暗金＋橙 |
| ace_niexiaoqian | 歸骨還魂 | 聶小倩 | 魂光 | 目標（隊友） | 1.4 | 月白＋淡藍 |
| ace_pontianak | 夜半笑聲 | Pontianak | 頭髮 | 範圍 | 1.2 | 墨黑＋淡綠 |
| ace_dokkaebi | 金棒變變變 | Dokkaebi | 爆 | 自己 | 1.1 | 暗金＋苔綠 |
| ace_dullahan | 點名索命 | 無頭騎士 | 斬 | 目標 | 1.0 | 紫＋黑 |
| ace_taotie | 咬一口先 | 饕餮 | 毒霧 | 目標 | 0.9 | 暗綠 |
| ace_jembalang | 土地翻身 | Jembalang | 撞 | 目標腳底 | 1.1 | 泥啡＋琥珀 |
| ace_hou | 犼食龍 | 犼 | 雷 | 範圍 | 1.0 | 紫電＋淡金 |
| ace_langsuir | 夜梟啼 | Langsuir | 斬（爪） | 目標 | 0.8 | 暗紫＋黑羽 |
| ace_krasue | 飛頭夜巡 | Krasue | 鬼火 | 每個目標 | 1.0 | 淡青綠 |
| ace_pang | 甩鍋大師 | 胖 | 撞 | 目標 | 1.0 | 鐵黑＋暗紫 |
| ace_shuten | 千杯不醉 | 酒吞童子 | 鬼火 | 自己 | 1.3 | 暗紫＋暗粉 |

### 3b. 副技模板 10 個（最多鬼用嘅 10 個，覆蓋 64 隻鬼）

| 鍵 | 模板 | 用嘅鬼數 | 家族 | 位置 | 主色 |
|---|---|---|---|---|---|
| sub_A_BACK | 閃後排 | 7 | 黑影 | 自己 | 黑＋暗紫 |
| sub_S_SAP | 抽能量 | 7 | 魂光 | 每個目標 | 淡青 |
| sub_T_GUARD | 護盾 | 7 | 護盾 | 自己 | 青藍 |
| sub_S_STUN | 範圍定身 | 7 | 召喚陣 | 目標腳底 | 淡藍灰 |
| sub_T_STUN | 震地 | 6 | 撞 | 範圍 | 骨白＋啡 |
| sub_T_SLAM | 搥地 | 6 | 撞 | 目標腳底 | 骨白＋啡灰 |
| sub_T_WALL | 企硬 | 6 | 護盾 | 自己 | 石灰＋鋼藍 |
| sub_W_KNOCK | 撞低 | 6 | 撞 | 目標（跟方向翻） | 骨白 |
| sub_R_SNIPE | 點殺 | 6 | 風刃 | 目標 | 淡鬼藍 |
| sub_W_BREAK | 重擊（破甲） | 6 | 爆 | 目標 | 鋼灰＋餘燼橙 |

### 3c. 升級 2 個

| 鍵 | 觸發 | 家族 | 主色 |
|---|---|---|---|
| up_fuse | 祭壇【融合】成功（soul_up.gd fuse） | 魂光 | 淡青＋淡紫 → 淡金 |
| up_star | 祭壇【突破】成功（soul_up.gd up_star） | 魂光 | 淡金＋暖白 |

## 4. 之後批次計劃

### 第二批：其餘 20 個副技模板（家族沿用上表）

| 模板 | 家族 | 位置 | 主色 |
|---|---|---|---|
| T_DRAIN 吸血咬 | 毒霧（咬）＋治療光回流 | 目標 | 暗綠→淡翠綠 |
| A_POISON 毒 | 毒霧 | 目標 | 病黃綠 |
| M_BURN 燒一片 | 鬼火 | 目標腳底 | 淡青綠鬼火 |
| R_CHAIN 彈射 | 鬼火 | 每個目標 | 淡青綠 |
| M_BLAST 轟 | 爆 | 目標腳底 | 暗金＋橙 |
| S_DISPEL 驅散 | 魂光（碎散） | 目標 | 淡青白 |
| W_CLEAVE 扇形斬 | 斬 | 自己→前方 | 暗紫＋骨白 |
| M_HUSH 封口 | 電話信號 | 目標 | 青綠 |
| R_LINE 直線穿 | 風刃 | 直線 | 淡青白 |
| A_EXEC 斬殺 | 斬 | 目標 | 紫黑 |
| H_HOT 持續回血 | 治療光 | 目標 | 淡翠綠 |
| A_VANISH 消失 | 隱身煙 | 自己 | 黑紫煙 |
| S_RALLY 打氣 | 紙錢 | 自己範圍 | 舊金 |
| W_RAGE 谷氣 | 爆（暗紅轉暗紫，唔用血紅） | 自己 | 暗紫＋餘燼 |
| S_HASTE 加速 | 風刃 | 自己範圍 | 淡青白 |
| R_ANTI 打飛行 | 風刃（向上） | 目標 | 淡藍 |
| H_SHIELD 加盾 | 護盾 | 目標 | 青藍 |
| H_BURST 治療 | 治療光 | 目標 | 淡翠綠 |
| H_CLEAN 淨化 | 治療光（水波） | 目標 | 奶白＋淡青 |
| M_FROST 凍一片 | 冰霜 | 目標腳底 | 淡冰藍 |

### 第三批：狀態（頭頂／身上持續小特效，約 30 種）

做法：每種 1 張 4×4 循環序列幀（第 16 格接返第 1 格），細尺寸（世界 40–60px），疊喺單位身上循環播；另出 `res://art/ab/<key>.png` 正式狀態圖示（ab_icon.gd 自動換）。

| 狀態鍵 | 名 | 家族 | 表現 |
|---|---|---|---|
| st_stun | 定身 | 鎖鏈 | 細鎖鏈繞腳 |
| st_silence | 封口 | 電話信號 | 嘴前斷線雜訊 |
| st_burn | 燒傷 | 鬼火 | 身上細鬼火 |
| st_poison | 中毒 | 毒霧 | 綠泡泡升起 |
| st_claw | 抓傷 | 斬 | 三條暗紫爪痕閃（冇血） |
| st_mark | 易傷 | 斬 | 頭頂暗紫目標圈 |
| st_abreak | 破甲 | 爆 | 碎甲片跌落 |
| st_wound | 重創 | 毒霧 | 暗紫裂紋（治療減） |
| st_slow / st_aslow | 減速／遲鈍 | 冰霜 | 腳底霜 |
| st_flee | 驚走 | 頭髮 | 頭頂發抖線＋冷汗 |
| st_confuse / st_daze | 迷魂／失神 | 魂光 | 頭頂轉圈鬼火 |
| st_charm | 迷惑 | 毒霧 | 紫粉霧心跳 |
| st_taunted | 被嘲諷 | 長舌 | 頭頂紫紅箭嘴 |
| st_down / st_air | 腳軟／嚇彈起 | 撞 | 塵圈 |
| st_curse | 陰氣 | 黑影 | 黑煙纏身 |
| st_saplock | 鎖嚇氣 | 鎖鏈 | 細鎖扣 |
| st_atk | 加攻 | 紙錢 | 金色向上箭 |
| st_aspd / st_spd | 加速／疾行 | 風刃 | 腳邊風線 |
| st_def / st_shield | 減傷／護盾 | 護盾 | 薄罩 |
| st_hot / st_healup | 回血／醫術 | 治療光 | 綠光點上升 |
| st_immune / st_steady | 免疫／定神 | 魂光 | 淡金外框 |
| st_revive | 返生 | 魂光 | 胸口一點魂火 |
| st_guard / st_taunt | 護衛／嘲諷中 | 護盾 | 背後半透明罩 |
| st_stealth | 隱身 | 隱身煙 | 身邊煙絲 |

### 第四批：升級其餘 + 戰場常用

- 裝備紙紮師傅加工（eq_data.gd do_plus，eq_ui.gd 194 行觸發）：紙紮碎片＋舊金火星（紙錢家族）
- 專屬物加工（王牌技升級，ace_fx_scale）：同上＋金邊閃
- 魔王收服（ng_boss.gd / soul_ui.gd 收服劇情後）：召喚陣＋鎖鏈收束（大型、2 秒）
- 套裝湊齊（eq_data.gd set_info 2 件／3 件開咗）：魂光環一圈
- 20 家族其餘未用到嘅（雷打斷、口水、長舌、召喚嘍囉陣）補做通用版本

## 5. 檔案

- 目錄（代碼）：`/home/claude/wt/vfx/godot/game/fxkit/vfx_cat.gd`
- 遊戲用序列幀：`/home/claude/wt/vfx/godot/art/vfx/*.png`
- 原圖：`/home/claude/art/vfx/raw/`；清理後：`/home/claude/art/vfx/sheets/`；實機樣本：`/home/claude/art/vfx/shots/`
- 提示詞：`/home/claude/art/vfx/notes/prompts.py`；對話網址：`/home/claude/art/vfx/notes/convs.txt`
- 工具：`/home/claude/art/vfx/tools/clean_sheet.py`、`approval.py`
- 測試：`res://tools/tests/vfx_test.gd`（all｜cat｜sim｜shots｜ui）
