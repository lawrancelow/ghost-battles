# ability 線：名鬼能力系統接入地圖半即時戰鬥（設計稿）

> 程序主管（ability 線）2026-11-23。全部根據讀過的代碼寫（行號＝revamp-p1 本機 /home/claude/ghost-battles/godot），冇改 repo。
> 讀過：game/rts/rts_sim.gd、rts.gd、rts_view.gd、rts_fx.gd、game/fxkit/fx_kit.gd、game/sortie/so_data.gd、so_view.gd、tools/devkit/session_20261123/rts_design.md、native/battle.gd（mk_ghost_unit／start）、native/game.gd（stat／glv）、native/gpower.gd、native/rework.gd、game/militia/ml_data.gd（battle_units）、tools/tests/qaudit2_test.gd、data/core.json。

---

## 0. 一句講晒

**同一套「能力積木」引擎，敵我兩邊共用。** 名鬼＝積木組合＋參數；敵人＝同一隻鬼（ENEMY_T 有 69 隻同 GHOSTS 同名）＋「機制積木」。招降之後，你喺野外打過嘅嗰套能力，就係佢入隊之後幫你用嘅能力（「打過先知佢識乜」）。克制唔係一個倍數表，而係**機制 vs 應對積木真係喺模擬入面生效**（飛行真係打唔到、隱身真係揀唔到做目標、護盾真係食傷害），所以要換配搭。

---

## 1. 現況（讀代碼結果，唔係估）

### 1.1 單位結構（rts_sim 入面每隻單位係一個 Dictionary）

| 欄位 | 來源 | 意思 |
|---|---|---|
| side | battle.gd | 0 我方、1 敵方 |
| k / gid / name | mk_ghost_unit | 鬼種 key（GHOSTS／ENEMY_T／SKILLS 都用同一個 key）、存檔 id、名 |
| hp / maxhp / atk | 見 1.2 公式 | 冇防禦欄位，**傷害＝攻 × 倍數**，冇減傷 |
| range | 名鬼 ranged 150／melee 46；敵人 zhiren、penanggal 140，其餘 46；陰兵 38 | >60 當遠程（射子彈 PSPD 640） |
| spd | 名鬼 遠 38／近 46；陰兵 52；敵 42（xiaogui 58） | 世界 px／秒 |
| energy | 名鬼開場 20、王 30、其餘 0 | 滿 100 可放技能 |
| sk | `SKILLS[k]`（陰兵 null） | 技能字典（見 1.3） |
| st | {} | 狀態：air／airMax、down／downMax、push |
| minion / ml / foe_ml / boss | | 陰兵小隊、遊魂兵（ml＝兵器級）、惡鬼嘍囉、王 |
| 地圖欄位 | rts_sim.setup | p（座標）、face、s（行軍弧長）、lat／dl／drow（行軍橫位）、ls／ls2／row（接觸後陣位）、eng、tg、anim、casting、cd |

一隊陰兵／遊魂兵＝**一個單位**（25 個兵，畫 2 個代表兵）。名鬼最多 3（`S.team` 3 格，阿福佔一格），陰兵最多 8 隊，遊魂兵最多 6 隊。

### 1.2 屬性、等級、傷害公式

- 名鬼屬性：`stat(g,i) = round(g.st[i] × (1 + 0.06 × (lv−1)))`（native/game.gd:75）；三屬性 `STAT_NAMES = [力, 智, 武]`；`g.st` 初始＝GHOSTS.base。等級上限 20／30／40（主公 Lv <7／7–14／≥15）；Lv40 ＝ 基礎 ×3.34。阿福等級＝min(上限, 主公等級×2)。
- 名鬼上陣（battle.gd:365 mk_ghost_unit）：`hp = (300 + 力×8 + 武×4) × dm`、`atk = (20 + 武×1.4) × dm`，`dm = GP.drillMul = (1 + 0.2×(嚇功級−1))^0.6`。**「智」對上場名鬼完全冇用**（只用喺軍師加成同打工）。
- 陰兵小隊：`hp = (90 + 14×主公lv) × 兵營加成`、`atk = (9 + 2.2×主公lv) × 兵營加成`。遊魂兵再 × 兵器 pw × 0.9／1.1。
- 敵人：`hp = (260 + 90×p) × ENEMY_T[k][0]`、`atk = (16 + 7.5×p) × ENEMY_T[k][1]`（p＝關卡難度 1–23；野外據點 p＝LV_BASE＋圈加成）；第 5、6 關再 ×0.55／0.5（rts.gd `_soften`）；第 4 圈頭目血 ×1.6。
- 開戰後 `GhostStreet.battleBuffs` 再加宵夜（麻辣 攻×1.15、肉骨茶 血×1.15……）。
- **每一下傷害**（rts_sim.hit，L214–273）：
  `dmg = round(atk × m × 軍師加成 × rand(0.9–1.1))`
  `m` ＝ 技能 mult（普攻 1）× 嚇法相剋（名鬼技能打敵人先有：怕 ×1.35、唔怕 ×0.6、失神中換另一種怕＝連嚇 ×1.8、追嚇 ×1.3、嚇功每級 +5%）× 追擊（技能 follow 對中狀態 ×1.8）。
- **軍師**（L237）：`bonus = 智 / 8 / 100`，即智 278（智 130 鬼 Lv20）＝我方**全部單位（包括陰兵）**每一下 +34.8%。軍師唔上場，嚇氣 +7／秒，自動模式滿咗自己放佢個技能（adv_cast）。**新介面冇地方揀軍師**，但 `S.adviser` 照生效（HANDOFF 已知問題）。
- 合體技 COMBOS（2 個）：Battle.build_cards 有設 `comboSkill`，**rts_sim 完全冇實作**（snap 帶過去但冇人讀）＝地圖戰鬥冇咗合體技。

### 1.3 技能數據與觸發

- SKILLS 82 條，欄位只有：`name kind(hit 57／aoe 24／heal 1) mult apply(down 20／push 18／air 10) follow(down 10／air 9／push 1) drain sap steal hits forget desc`。GHOSTS.trait 只係文字，**代碼冇讀 trait 做戰鬥**（只喺 ui/main.gd:824、menus.gd 顯示）。
- 嚇氣：有 sk 嘅單位 +9／秒（王 +11）、普攻打中 +8、被打 +4（L264–265、L568）。
- 觸發（L574）：`energy ≥ 100 且冇動作` → 敵人**一定即刻放**；我方名鬼只喺 `auto`（Battle.auto，共用 gb_auto）先自動放；陰兵冇技能。
- 手動：rts_view `SkillBtn`（右邊豎排，L507–594）撳 → `op.cast(u)` → `begin_cast`（CAST 0.45 秒）→ `fire_cast` → `do_skill`。
- `do_skill`（L279）：heal＝**全場**同邊回 mult×maxhp；aoe＝**全場所有敵人**（`enemies_of(u)`，冇半徑！設計稿寫 150px 但代碼冇做）；hit＝最近一隻，hits>1 分段。
- apply 效果（L255–260）：`air`＝st.air 1.0 秒（期間唔郁唔打；被打中斷施法＝即放）；`down`＝st.down 1.4 秒（同上）；`push`＝0.25 秒以 160px／秒被推（≈40px）。**冇任何免疫**，人人都食。drain＝吸血；sap＝扣對方嚇氣；steal＝冥幣（只我方）；forget＝敵人嚇氣清零。
- 畫面：rts_fx.consume 食 vq（melee／phit／hit／cast／skill），按嚇法揀 fxkit 風格（TYPE_STY／TYPE_HUE）。

### 1.4 三個已知問題嘅成因（量化）

**(a) 陰兵小隊幾秒死光** — 三個原因疊埋：
1. 數值：小隊血跟主公等級線性，敵人攻跟 p 線性但斜率大。估算（兵營加成當 1）：

| 場景 | 敵人 血／攻 | 小隊 血／攻 | 小隊捱幾下 | 小隊打死一隻敵人要 |
|---|---|---|---|---|
| p3 餓鬼、主公 Lv3 | 662／42 | 132／16 | 3.1 下（3.0 秒） | 40 秒 |
| p10 殭屍兵、Lv8 | 2204／100 | 202／27 | 2.0 下（1.9 秒） | 79 秒 |
| p15 水鬼、Lv12 | 2093／161 | 258／35 | 1.6 下 | 56 秒 |
| p20 Penanggal、Lv16 | 7416／315 | 314／44 | 1.0 下 | 159 秒 |

2. 揀目標：`tune_minion = 120`（L66、L515）＝敵人**優先打小隊**（扣分 120px，等於隔成個身位都會揀小隊）。
3. 敵人 AoE 打**全場**：一個「年終考核」（huang aoe 1.4）＝8 隊陰兵同時食。
→ 每死一隊扣 25 兵（battle.gd finish），所以呢個唔止係觀感問題。

**(b) 名鬼兩翼被圍**：`_form`（L492–495）排法係「名鬼一半＋小隊＋名鬼另一半」，名鬼**一定企兩頭**；`_line_want` 將陣位壓入對面闊度＋56px，對面人多時兩頭嘅名鬼正對 2–3 隻；`_line_tg` 用橫向距離揀目標，兩頭敵人全部揀佢。

**(c) 陣型接觸後變一團**：
1. L584 `CLOSE` 規則：離目標射程＋100 內而陣位反而更遠 → 直接衝向目標（放棄橫位）；
2. `_separate`（L628）同邊互推係全方向，一推就亂；
3. 冇「每隻目標最多幾個人打」上限（`_pick`／`_load`／`_slot_pos` 已寫好但**冇被呼叫**，係死碼）→ 大家圍住同一隻。

---

## 2. 能力數據結構（新檔 data/abil.json）

### 2.1 為乜放新檔、熱更新點做

- 唔塞落 core.json：core.json 係「網頁版導出」（tools/dump_data.js），重新導出會蓋走；新檔 ownership 清楚，熱更新 pck diff 只會帶呢個檔。
- 讀法（新腳本 `game/rts/abil.gd`，**冇 class_name**，用 `const AB = preload("res://game/rts/abil.gd")`）：
  ```gdscript
  static var D = null
  static func data() -> Dictionary:
      if D == null:
          var f = FileAccess.open("res://data/abil.json", FileAccess.READ)
          D = JSON.parse_string(f.get_as_text()) if f else {}
          if not (D is Dictionary): D = {}
      return D
  static func on() -> bool: return not data().is_empty() and not J.t(J.G.S.get("ab_off", false))
  ```
  冇檔／讀唔到＝`on()` 假 → rts_sim 全部行舊路（A/B 對比用、出事一鍵關）。
- 存檔新欄位一律 `.get(key, 預設)`：`S.ab_role`（{gid: "front"/"back"/"flank"}，冇＝用數據預設）、`S.ab_auto`（{gid: bool}，冇＝跟 gb_auto）。唔需要 migration。

### 2.2 頂層

```jsonc
{
  "ver": 1,
  "TAGS":  { "<tag>": {"n": "對空", "icon": "ab_air", "c": "#7dd3fc", "desc": "打得中飛行敵人，傷害 ×1.25"} },
  "MECH":  { "<mech>": { "n": "飛行", "icon": "mc_fly", "counter": ["anti_air","ground","ranged"], "lv": 1,
                         "pas": [ /* 用下面同一套 trigger+fx 寫 */ ], "warn": "近戰打唔中佢（只有 40% 傷害）" } },
  "ABIL":  { "<鬼 key>": { /* 見 2.3 */ } },
  "ENEMY": { "<敵人 key>": { "mech": ["fly"], "use_abil": true } },   // 克制線擁有
  "LINK":  [ {"id": "wuchang", "a": "baiwu", "b": "heiwu", "abil": { /* 合體技 */ } } ],  // 取代 COMBOS
  "CAMP_MOD": { "ring": [[0,1],[1,1],[1,2],[2,3]] }                    // 每圈機制數 [最少,最多]（克制線擁有）
}
```

### 2.3 一隻名鬼嘅能力（ABIL 條目）

```jsonc
"laojiang": {
  "role": "front",                  // 預設站位：front 前排／back 後排／flank 側翼
  "tags": ["armor_break", "cc"],    // 應對標籤（自動由積木推導，這裡只係手動補／覆寫）
  "act": {                          // 主動技（按鈕）——每隻一個
    "name": "跳屍撞", "cost": 100, "cast": 0.45,
    "tg": {"sel": "near"},                                  // 目標選擇器（2.5）
    "fx": [ {"p": "dmg", "mult": [1.5,1.6,1.7,1.85,2.0,2.2]},
            {"p": "air", "dur": 1.0},
            {"p": "armor_break", "v": 0.5, "dur": 6} ],
    "ai": {"when": "asap"}                                  // 自動模式幾時放（第 5 節）
  },
  "pas": [                          // 被動／觸發（0–3 個，按星級解鎖）
    {"tr": "start", "star": 0, "fx": [ {"p": "immune", "tags": ["push"], "dur": -1} ]},
    {"tr": "hit_taken", "star": 2, "icd": 8, "chance": 0.3, "fx": [ {"p": "shield", "pct": 0.12, "dur": 4, "tg": "self"} ]}
  ],
  "aura": {"star": 3, "r": 110, "side": "ally", "fx": [ {"p": "buff", "stat": "taken", "v": -0.12} ]},
  "desc": "自動生成（AB.describe），唔使手寫"
}
```

- **數值陣列＝按星級**（星級由魂魄祭壇線決定，0–5）：`[1.5,1.6,...]` 取 `[min(star, size−1)]`；寫單一數字＝唔隨星變。等級成長照舊由 atk／hp 帶（唔另外加），避免雙重成長。
- `star` 欄＝幾星解鎖：建議 ★0 主動技＋1 被動；★2 第 2 被動；★3 光環；★5「覺醒」（主動技加一粒積木）。
- **觸發 `tr`**：`start`（開場／接觸時）、`every`（每 N 秒，參數 `t`）、`low_hp`（`pct`，一場一次）、`kill`（殺敵）、`hit_taken`（被攻擊，`chance`、`icd`）、`attack`（每第 N 下普攻，參數 `n`）、`ally_down`（隊友倒下）、`foe_cast`（附近敵人開始施法）、`death`（自己倒下：分裂、復活、遺言）。所有觸發都有 `icd`（內部冷卻，預設 1 秒）防止無限連鎖；觸發入面嘅 fx **唔會再觸發 hit_taken／attack**（`depth ≤ 1`）。
- **tags 推導規則**（AB.tags_of，名冊／配搭 UI 用）：有 `anti_air` 積木→對空；`reveal`→照妖；`shield_break`/`dispel`→破盾／驅散；`interrupt`/`silence`/`sap`≥25→打斷；`cleanse`→淨化；`banish`→收魂；`armor_break`→破甲；`execute`→斬殺；`taunt`/`guard`→護衛；`immune fear`→定神；`aoe` 形狀→群攻；range>60→遠程；`dash`/`pull`→突進。手寫 `tags` 只用嚟補（例如純 lore 嘅標籤）。

### 2.4 舊 SKILLS 自動轉換（第一版唔使手寫 72 隻）

`AB.from_legacy(sk)` 將舊技能變成 act：

| 舊欄位 | 變成 |
|---|---|
| kind hit | `tg {sel: near}`；hits>1 → `dmg {hits}` |
| kind aoe | `tg {sel: near, shape: circle, r: 130}`（**唔再係全場**） |
| kind heal | `tg {sel: allies, r: 220}` + `heal {pct: mult}` |
| apply down／air／push | `down {dur 1.4}`／`air {dur 1.0}`／`push {dist 40}` |
| follow | `dmg {vs_state: "down", x: 1.8}` |
| drain／sap／steal／forget | `drain {pct}`／`sap {v}`／`coin {v}`／`sap {v: 100, tg: all_r}` |

→ 72 隻即刻喺新引擎跑、數值同舊一樣（除咗 AoE 有半徑），之後先逐隻加被動／光環／標籤（第 3.4 節示例）。

### 2.5 目標選擇器（`tg`）

`sel`：`near`（最近）、`far`、`low`（血% 最低）、`strong`（攻最高）、`back`（沿陣線軸最後面＝炮台／施法者）、`caster`（施法中）、`mech:<id>`（帶某機制，例如 `mech:summon` 揀召喚者）、`flyer`、`stealth`（只限已顯形）、`boss`、`self`、`ally_low`、`allies`、`all_r`。
`shape`：`single`（預設）、`circle {r}`（以目標為圓心）、`self_circle {r}`、`cone {r, deg}`、`line {len, w}`、`chain {n, falloff}`。
實作：`AB.select(sim, u, tg) -> Array`，約 90 行。**所有選擇器都經 `AB.targetable(sim, u, v)`**（隱身、飛行規則喺呢度）。

---

## 3. 能力積木（effect primitives）— 38 個

實作點縮寫：**H**＝`rts_sim.hit()` 管線；**T**＝`AB.tick_unit()`（每格每隻單位）；**S**＝`AB.select()`；**F**＝`_form()`／走位；**D**＝死亡處理。所有 buff／debuff 統一放 `u["bf"] = [{id, p, v, until, src, stack}]`，屬性讀 `AB.stat(u, "atk"|"aspd"|"spd"|"taken"|"heal_in"|"energy")` ＝ 基值 × (1＋Σv)，一個函數食晒。

### 3.1 傷害類

| # | id | 中文 | 參數 | 實作點 | 行數 |
|---|---|---|---|---|---|
| 1 | dmg | 傷害 | mult, hits, vs_state{down/air/push}, x, vs_mech{id:x}, vs_tag | H：包舊 hit()，多段沿用舊做法 | 30 |
| 2 | dot | 持續傷害（燒／毒／咒） | dps(×atk), dur, kind, stack≤3 | T：每 0.5 秒扣血，`kind` 用嚟俾淨化揀 | 25 |
| 3 | execute | 斬殺 | hp_pct, x | H：目標血 < hp_pct → m×x | 8 |
| 4 | chain | 彈射 | n, falloff, r | S：chain 形狀，逐跳 hit | 20 |
| 5 | splash | 普攻濺射（被動） | r, pct | H：普攻命中後對 r 內其他敵人 pct | 15 |
| 6 | mark | 易傷 | v, dur | bf：stat taken +v | 5 |
| 7 | pierce | 穿甲普攻（被動） | v | H：計硬甲時減免 −v | 5 |

### 3.2 控場類（全部經 `AB.cc_ok(v, kind)` 檢查免疫）

| # | id | 中文 | 參數 | 實作點 | 行數 |
|---|---|---|---|---|---|
| 8 | down | 腳軟（舊） | dur | H：搬舊 L258；**對飛行＝擊落 2.5 秒**（見機制 fly） | 6 |
| 9 | air | 嚇彈起（舊） | dur | H：舊 L257 | 4 |
| 10 | push | 嚇退（舊） | dist | H：舊 L259，dist→時間 | 4 |
| 11 | pull | 扯近 | dist | T：同 push 反方向（長舌、長臂；扯炮台／後排出嚟） | 12 |
| 12 | stun | 定身 | dur | T：同 down 但唔倒地（冇追擊加成） | 8 |
| 13 | silence | 封口（打斷＋禁技） | dur | T：`casting` 清走、energy 唔加 | 12 |
| 14 | interrupt | 打斷 | — | 直接 `casting = null`＋扣 50 嚇氣；對 caster 機制額外 stun 1 秒 | 10 |
| 15 | slow | 減速 | v(移動), va(攻速), dur | bf：spd／aspd | 5 |
| 16 | flee | 驚走（恐懼） | dur | T：背向攻擊者行，唔出手 | 18 |
| 17 | taunt | 嘲諷 | r, dur | T：r 內敵人 `tg` 鎖定自己；`_line_tg` 先查 | 15 |

### 3.3 防守／支援類

| # | id | 中文 | 參數 | 實作點 | 行數 |
|---|---|---|---|---|---|
| 18 | heal | 治療 | pct(maxhp) 或 mult(atk), tg | 直接加血 × heal_in | 10 |
| 19 | hot | 持續回血 | pct, dur | T | 8 |
| 20 | shield | 護盾 | pct(maxhp), dur | H：扣血前先食盾（`u.shd`） | 15 |
| 21 | drain | 吸血（舊） | pct | H：舊 L261 | 3 |
| 22 | guard | 護衛（替隊友擋） | r, pct, cap | H：r 內**陰兵小隊**受傷 pct 轉去自己身（cap＝每秒上限 % maxhp） | 25 |
| 23 | immune | 免疫 | tags[down/air/push/stun/flee/fear_aura/sap], dur | bf；cc_ok 查 | 8 |
| 24 | cleanse | 淨化（己方解負面） | n, kinds | 清 bf 入面負面（dot／slow／flee／curse／mark） | 12 |
| 25 | revive | 返生（一次） | pct | D：倒地 1.5 秒後企返起身 | 15 |
| 26 | buff | 強化 | stat, v, dur, tg | bf | 5 |
| 27 | energy | 回嚇氣 | v, tg | 直接加 energy | 3 |

### 3.4 應對（克制）專用類

| # | id | 中文 | 參數 | 實作點 | 行數 |
|---|---|---|---|---|---|
| 28 | anti_air | 對空（被動） | x | S：可以揀飛行做目標；H：對飛行 ×x | 8 |
| 29 | reveal | 照妖（驅散隱身） | r, dur | T：r 內敵人 `bf revealed`（可被揀、失去隱身加成） | 15 |
| 30 | armor_break | 破甲 | v, dur | bf：抵銷硬甲（armor −v） | 6 |
| 31 | shield_break | 破盾 | pct 或 flat | 直接清 `shd` | 5 |
| 32 | dispel | 驅散（敵方正面 buff） | n | 清敵 bf 正面（再生、狂暴、護盾、霸體） | 12 |
| 33 | banish | 收魂（反召喚／反返生） | hp_pct | 召喚物／分裂體血 < hp_pct＝直接消失；目標有 revive → 取消 | 12 |
| 34 | sap | 抽嚇氣（舊） | v | 舊 L262 | 3 |
| 35 | wound | 重創（減治療） | v, dur | bf：heal_in −v（克再生、吸血） | 5 |

### 3.5 位置／召喚類

| # | id | 中文 | 參數 | 實作點 | 行數 |
|---|---|---|---|---|---|
| 36 | dash | 突進／繞後 | to(back/target), dist | F：瞬移（畫面用 fxkit appear），之後 `tg` 鎖後排 | 20 |
| 37 | stealth | 自己隱身 | dur, first_x | 自己 bf stealth；隱身中第一下 ×first_x | 10 |
| 38 | summon | 召喚 | k, n, hp_pct, atk_pct, dur | D/T：`units.append` 新單位（`sum:true`、`_id` 新號；sim 已支援中途加單位，因為迴圈用 `for u in units`） | 30 |

另 `coin`（偷冥幣，舊 steal）、`zone`（地面區域：r、dur、內含一個 fx 每 0.5 秒套落區內敵人，例如糯米圈 slow）屬 2 個輔助積木，共 **40**。

**合計核心代碼** ≈ 600 行（abil.gd）＋ rts_sim 掛鈎約 35 行（第 3.6）＋ rts_view／rts_fx 狀態圖示約 120 行。

### 3.6 rts_sim 掛鈎（全部一行級，標 `# [ab]`，`AB.on()` 假時行舊路）

| 位置 | 改法 |
|---|---|
| L72 `_init` | `const AB = preload(...)`（檔頭） |
| L105 setup 尾 | `if AB.on(): AB.setup(self)` — 編譯每隻單位 `u.ab`（敵我都做），敵人掛 MECH，`u.sk` 換成 `{name, kind:"ab"}`（技能鈕照用） |
| L151–161 nearest／L508 `_line_tg`／L340 普攻目標 | 加 `AB.targetable(self,u,v)` 過濾；`_line_tg` 先查 taunt |
| L214 hit 開頭 | `if AB.on(): return AB.hit(self, src, v, mult, sk)` — 新管線（下面）；舊 hit 保留做 legacy |
| L279 do_skill | `kind == "ab"` → `AB.cast(self, u)` |
| L544 `_step_fight` 每隻單位開頭 | `if AB.on() and AB.tick_unit(self, u, dt): continue`（定身／驚走／dot／hot／狀態到期） |
| L568 嚇氣 | `× AB.stat(u,"energy")` |
| L574 自動放 | 條件改 `AB.want_cast(self, u)`（敵我都經 AI，第 5 節） |
| L585 走位 spd／L345 cd | `× AB.stat(u,"spd")`、`period(u) / AB.stat(u,"aspd")` |
| L478 `_form` | `AB.form(self, mel, rng, fo)`（第 5.3 節） |
| L589 軍師後 | 每 0.25 秒 `AB.tick_auras(self)` |
| L266 倒地 | `AB.on_down(self, v, src)`（分裂、返生、kill 觸發、召喚物連帶消失） |
| L643 finish | `AB.report(self)` → `op.ab_log`（測試、魂魄線用） |

**新 hit 管線**（AB.hit，約 80 行）：
```
m  = mult
m *= rework 嚇法相剋（原封不動搬 L218–236）
m *= follow 追擊 ×1.8（舊）
m *= vs_mech / vs_tag / execute / anti_air / 隱身首擊
m  = clamp(m, 0.2, 4.0)                       # 總倍數封頂，防止嚇法×機制×追擊疊爆
dmg = AB.stat(src,"atk") × m × 軍師 × AB.stat(v,"taken") × 硬甲(v,src) × rand
dmg = guard 轉移 → shield 吸收 → 扣 hp
apply（cc_ok 檢查免疫；飛行食 down＝擊落）
drain × heal_in(src)、sap、coin、嚇氣 +8/+4（舊）
post：thorns 反傷、hit_taken／attack 觸發（depth≤1）、事件 ["ab", src, prim, v]
```

---

## 4. 敵人「機制」積木（克制嘅技術基礎）

原則：
1. **冇應對＝難打但打得贏**（效率跌 30–50%），唔做硬鎖（明日方舟飛行敵人只可遠程打，係硬鎖；我哋 4 隻遠程太少，硬鎖會卡死，所以近戰打飛行有 40% 傷害）。
2. **每個機制 ≥3 種應對積木**，而且 ≥1 種係「舊技能已經有」（down／push／sap／aoe），等新玩家用現有 72 隻都有路行。
3. 機制同樣用 trigger＋fx 寫（MECH.pas），引擎冇特例碼（除咗 fly／stealth 嘅可揀規則喺 targetable）。

| # | 機制 | 模擬入面點樣 | 應對（標籤 → 積木） | 冇應對會點 |
|---|---|---|---|---|
| M1 | 飛行 fly | 畫面高 30px；近戰（range≤60）只可喺冇地面目標時揀佢，傷害 ×0.4；**食 down／air／pull＝擊落 2.5 秒**（變地面） | 對空 anti_air（×1.25）、遠程、控場 down/air、扯近 pull | 近戰圍住地面兵，飛頭喺後面咬 |
| M2 | 隱身 stealth | 未顯形唔可被揀做目標（AoE 圓形亦唔中）；出手後顯形 1.5 秒；隱身首擊 ×2 | 照妖 reveal、群攻（顯形時一次過）、嘲諷（佢要埋身） | 我方後排被偷襲 |
| M3 | 護盾 shield | 開場盾 30% maxhp，每 12 秒補 15% | 破盾 shield_break、驅散 dispel、多段 hits（每段都計）、斬殺唔計盾 | 打唔郁，時間到 |
| M4 | 再生 regen | 每秒回 2.5% maxhp（被打後 2 秒停） | 重創 wound（−60%）、驅散、高爆發、持續傷害 dot（停回血） | 拖到 90 秒時間到 |
| M5 | 分裂 split | 死時分 2 隻（各 35% 血、60% 攻，`sum`） | 群攻、收魂（分裂體 <40% 血即消失）、濺射 | 越打越多，陰兵被圍 |
| M6 | 召喚 summon | 每 8 秒召 1 隻嘍囉（上限 4，`sum`） | 收魂、突進 dash 揀 `mech:summon`、群攻、打斷（召喚有 1 秒施法） | 陰兵被嘍囉食晒 |
| M7 | 反傷 thorns | 近戰打佢反 25% 傷害（遠程 ×0.3） | 遠程、護盾（盾食反傷）、治療／吸血、驅散 | 近戰名鬼自己打殘自己 |
| M8 | 炮台 turret | spd 0、range 260、濺射 r 60、企後排 | 突進 dash、扯近 pull、遠程、嘲諷（佢唔會郁所以唔受嘲諷：只係減前排傷） | 陰兵喺行近途中已經死 |
| M9 | 恐懼光環 fear_aura | r 140 內我方攻 −25%、嚇氣 −50%（陰兵另外每 6 秒 20% 機會驚走 2 秒） | 定神 immune fear_aura、淨化、遠程（企光環外）、斬殺 | 全隊無力、放唔到技 |
| M10 | 霸體 cc_immune | 免疫 down／air／push／stun | 易傷 mark、破甲、斬殺、純傷害 | 控場隊（腳軟流）完全失效 |
| M11 | 硬甲 armor | 受傷 ×0.5（破甲／穿甲抵銷） | 破甲、穿甲 pierce、dot（無視甲）、易傷 | 傷害減半 |
| M12 | 施法者 caster | 每 10 秒讀 2.0 秒大招（紅圈預告，範圍 r 160、×2.5 + 腳軟） | 打斷 interrupt／silence、抽嚇氣 sap、突進、定神（唔食腳軟） | 全隊每 10 秒食大招 |
| M13 | 詛咒 curse | 打中我方：治療 −50%、dot 1%/秒 6 秒 | 淨化 cleanse、遠程、護盾 | 補血隊失效 |
| M14 | 返生 revive | 死後 3 秒企返起身 50% 血（一次） | 收魂 banish（3 秒內打中＝取消）、淨化、斬殺（斬殺死＝唔返生） | 要打兩次 |
| M15 | 狂暴 enrage | 血 <40%：攻 +60%、攻速 +40% | 斬殺、驅散、嘲諷＋護盾（坦住）、控場 | 尾段秒殺陰兵 |
| M16 | 抽能 sap_aura | r 160 內我方嚇氣 −60%，每 5 秒扣 15 | 定神 immune sap、回嚇氣 energy、遠程 | 名鬼成場放唔到技 |

**實作量**：16 個機制全部係 MECH 數據（pas＋aura），引擎特例只有 fly／stealth 喺 `targetable`（約 30 行）、caster 紅圈預告畫面（約 30 行）。

**敵人點樣掛機制**（克制線擁有數值，呢度只係建議初值）：
- 主線 17 種：youhun —；egui 再生；xiaogui 隱身；zombie 硬甲＋霸體；shuigui 扯近（自己有 pull）＋詛咒；zhiren 遠程（已 140）＋分裂（紙碎）；niutou／mamian 狂暴；eguiking 再生＋吸血；toyol 隱身＋抽能；laojiang 硬甲＋霸體；pontianak 飛行＋恐懼光環；pocong 霸體＋返生；penanggal 飛行＋吸血；baiwu／heiwu 召喚（勾魂）＋施法者；huang 召喚（「PPT」嘍囉）＋施法者＋狂暴。
- 名鬼做敵人時（`use_abil: true`）：用佢自己 ABIL（星級 0）＋ ENEMY 表額外機制 0–1 個。
- 野外據點：`CAMP_MOD.ring` 決定機制數（圈 1：0–1、圈 2：1、圈 3：1–2、圈 4／頭目：2–3），由據點 id hash 揀（同 so_data.stage_of 揀敵人一樣，固定唔隨機，玩家可以記住「呢個據點有飛頭」）。

---

## 5. 自動戰鬥 AI、站位、三個已知問題點修

### 5.1 主動技：自動 vs 按鈕

- 保留現有「自動」小掣（gb_auto）。另加每隻名鬼長按技能鈕＝切換「呢隻自動／手動」（`S.ab_auto[gid]`，冇＝跟總掣）。
- **自動 AI**：每個 act 有 `ai`：
  - `asap`：滿就放（單體技預設）
  - `{"n_in": 3, "r": 130}`：目標圈內 ≥3 隻敵人先放（AoE 預設，`n_in` 隨場上敵人數 min(3, 敵數)）
  - `{"ally_hp": 0.5}`：有隊友（包括陰兵）<50% 先放（治療、護盾）
  - `{"foe_cast": true}`：附近敵人讀緊大招先放（打斷）
  - `{"tg_mech": "shield"}`：場上有帶某機制嘅敵人先放（破盾、收魂、照妖）
  - `{"self_hp": 0.4}`
  - 全部有 `wait`（預設 5 秒）：滿咗 5 秒條件都唔成立就照放，**唔會儲住唔用**。
- **手動嘅價值**（唔係純自動就最好）：敵人施法者頭頂紅色讀條 2 秒 → 你撳打斷技＝取消佢大招；AI 打斷都會做，但 AI 會先用喺第一個讀條，玩家可以留俾王。→ 自動＝穩陣 85 分，手動＝打得好可以 100 分。
- **敵人都經 AI**（而家敵人滿 100 即刻放全場 AoE）：AoE 要 ≥2 目標入圈、治療要有隊友 <60%；王另有 `boss_open`（接觸後 3 秒先第一次放，畀玩家睇到）。

### 5.2 站位（前排／後排／側翼）

| 角色 | 預設俾 | 接觸後點企 | 被動加成（引擎內建，唔使逐隻寫） |
|---|---|---|---|
| 前排 front | 力高、近戰、有 guard／taunt／shield 嘅 | 陣線中間，小隊企佢兩邊 | 自動帶 `guard {r 70, pct 0.35, cap 6%/秒}` ← 保護身邊陰兵 |
| 後排 back | 遠程、治療、施法 | 前線後 60px | 敵人揀目標時 +80px 懲罰（唔易被揀） |
| 側翼 flank | 有 dash／stealth 嘅 | 陣線兩頭外 50px，接觸 2 秒後繞去打 `back`（炮台、施法者、召喚者） | 被 ≥3 隻圍住時自動退回陣線（`retreat` 1 次／10 秒） |

出擊卡可以改（2 個字掣「前／後／翼」輪轉），存 `S.ab_role`。

### 5.3 三個已知問題點修（AB.form／走位）

**(a) 陰兵秒死**
1. AoE 有半徑（130px），唔再全場（2.4 節）。單計呢條，「年終考核」由打 8 隊變打 2–3 隊。
2. `tune_minion` 120 → 30；改成「威脅值」揀目標：`k = 橫距×1.6 + 縱距×0.4 − 威脅`，威脅：嘲諷 999、前排名鬼 60、小隊 30、後排 −80。
3. 前排名鬼自帶 guard（上表）。
4. 小隊企喺前排名鬼兩側、唔係陣線最前（見 c）。
5. **數值線決定**（唔屬能力系統，但列出建議）：小隊血改 `max(舊, (60 + 40×p) × 兵營)`，令同級 TTK ≥ 6 秒。
- 驗收：同一存檔 p10、8 隊陰兵＋3 名鬼，陰兵戰死平均由（實測後填）降 ≥40%；第一隊小隊陣亡時間 ≥ 6 秒。

**(b) 名鬼兩翼被圍**
- 新排法（AB.form）：`[翼] [小隊…] [前排名鬼] [小隊…] [前排名鬼] [小隊…] [翼]`，前排名鬼喺中間 1/3，兩頭係小隊或側翼名鬼（側翼係故意、有退路）。
- 「被圍救援」：每 0.5 秒計每隻名鬼被幾多隻近戰敵人鎖住（用返死碼 `_load`），≥3 → 最近 2 隊小隊 `tg` 改打圍佢嘅敵人（側移去佢身邊）。

**(c) 接觸後變一團**
1. **鎖陣位**：接觸後 `ls` 唔再隨目標變；L584 CLOSE 直衝規則改成「只有橫距 <50px 先直衝，否則先沿軸行」。
2. **每隻目標最多 3 個近戰**（`_load` 上限，超過揀下一隻；遠程唔計）。
3. `_separate` 同邊只沿 perp 方向推（保住前後行）、異邊只沿 ax 推。
4. 驗收（測試量）：交戰第 5／15 秒，我方同一行單位嘅「陣線分散度」＝沿 ax 標準差 < 35px；同邊兩兩距離 <20px 嘅對數 ≤ 2。

---

## 6. 戰鬥前「配搭」UI

位置：兩張已有嘅出擊卡 —— `rts.gd _card_body`（主線／王／親征）同 `so_view.open_card`（野外據點）。共用新檔 `game/rts/ab_card.gd`（static，`add_to(vb, enemy_keys)`）。

```
┌────────────── 出擊：Lv.12 深處據點　第3圈 ──────────────┐
│ 敵人機制： [飛] 飛行  [盾] 護盾                          │  ← 圖示 28px＋字 15px，撳一下彈一句說明
│                                                        │
│ 我方：阿福 [前]   老殭 [前] 破甲 控場   小紙 [後] 遠程 群攻 │  ← 每隻名鬼頭像＋站位掣＋應對標籤
│ 軍師：孟婆 ▸（撳換）                                     │  ← 補返「冇地方揀軍師」
│                                                        │
│ ✔ 飛行：小紙（遠程）、老殭（腳軟可擊落）                  │  綠
│ ✘ 護盾：冇隊員破盾 → 慢 40%、可能時間到                    │  紅
│   推薦：討債鬼（破盾）、二房東（驅散）  [換上]              │  撳＝換走應對最少嗰隻（唔換阿福）
│ 應對度 ●●○  （1/2）                                      │
│ 出擊消耗：壽包 24　冥幣 72        [出擊]  [關閉]            │
└────────────────────────────────────────────────────────┘
```

- 敵人機制來源：`camp_preview`（rts.gd L76）已經有敵人 key 列表 → `AB.mechs_of(k)`；野外用 `so_data.stage_of(e).en`。
- 「應對」判定：機制 counter 標籤 ∩ 隊伍 `AB.tags_of(k)`（只計 ★ 已解鎖嘅積木）。
- 推薦：喺「已擁有＋未出陣＋冇派去打工」名鬼入面，揀覆蓋最多未應對機制、再按 GP.pow 排序；最多 2 個。派工中嘅會寫「（打工中）」（對應 HANDOFF「派工會把小紙調離出陣」）。
- 名冊頁（名冊線）：每隻鬼卡顯示標籤圖示＋AB.describe 生成嘅技能說明。
- 字體：標題 20、內容 15–17（跟現有卡）；手機直屏寬 430 以內排得落（標籤最多 3 個／人）。

---

## 7. 自動化測試（tools/tests/abil_test.gd）

跑法同現有 qaudit2：`edtest.sh <godot> abil res://tools/tests/abil_test.gd <mode>`（要 boot 遊戲，因為 sim 用 J.G.Rework／Battle.auto）。全部 `seed(n)` 固定（sim 用 randf）。單位用 `mk(k, side, lv, star)` 直接按 1.2 公式生成，唔經 Battle.start（唔受存檔影響）；路線用直線 `[(0,900),(0,300)]`，`t_skip_march()` 跳行軍；`vfx_on=false`；dt 1/20。

| mode | 做乜 | 合格線 |
|---|---|---|
| `prim` | 40 個積木各一個最細場景（1v1 或 3v3），讀 `op.ab_log` | 每個積木事件 ≥1 次、對應狀態真係變（盾值、bf、位置、單位數）；A/B（有積木 vs 冇）指標差 ≥ 設定值（例如 armor_break 對硬甲傷害 ≥ +60%） |
| `mech` | 16 機制 × 「有應對隊」vs「同戰力（GP.pow ±10%）冇應對隊」× 20 種子 | 有應對勝率 − 冇應對 ≥ 25 個百分點，或取勝時間 −30%；冇應對勝率（第 1–3 圈）≥ 20%（唔硬鎖） |
| `cover` | 純數據，唔跑戰鬥 | 每機制 ≥ 8 隻鬼可應對（100 隻中）、其中 ≥ 3 隻係首 30 隻容易得到嘅；每機制 ≥ 3 種積木；每隻鬼 1–3 個應對標籤；冇兩隻鬼 act＋pas 積木組合完全一樣 |
| `meta` | 從 100 隻抽隊：先用數據「覆蓋度」揀前 60 隊＋隨機 140 隊，對 40 個據點配置（各圈、各機制組合）各打 5 場 | **冇萬能隊**：任何一隊喺第 3–4 圈配置勝率 ≤ 75%；「最佳隊」喺 40 個配置入面 ≥ 6 隊唔同；任何 3 隻鬼覆蓋 16 機制 ≤ 60% |
| `form` | 第 5.3 節三個問題嘅量測 | 陰兵第一隊陣亡 ≥ 6 秒；陣線分散度 < 35px；名鬼被 ≥3 近戰圍住嘅總秒數 −50% |
| `regress` | `ab_off=true` 對比舊行為；再跑 rts_test、sortie_test、qaudit2 | 同種子同結果；舊測試全過 |
| `perf` | 2 場 × 40 單位（含召喚、光環） | 每格模擬平均 < 0.5 ms（而家 20 單位約 0.1 ms） |

時間預算：每場約 0.15–0.3 秒（無畫面）；meta 200 隊×40×5＝4 萬場 ≈ 2–3 小時 → 背景跑、每晚一次；日常只跑 prim＋mech＋cover＋form（約 10 分鐘）。

---

## 8. 100 隻點樣「每隻唔同」：組合示例

規則：每隻＝1 主動（2–4 粒積木）＋ 1–3 被動／光環（各 1–2 粒）＋ 參數；「同一組積木」最多兩隻共用，而且參數要差 ≥30% 或觸發唔同。lore 先行（全部有依據，同 trait／lore 對得上）：

| 鬼 | 站位 | 主動 | 被動／光環 | 應對標籤 |
|---|---|---|---|---|
| 小紙 | 後 | 紙錢漫天：circle r130 dmg 0.8＋down | ★2 被打中 30% 生 1 個紙紮替身（summon 20% 血，6 秒） | 遠程、群攻、控場 |
| 老殭 | 前 | 跳屍撞：dmg 1.5＋air＋armor_break 6 秒 | 開場 immune push；★3 光環隊友 taken −12% | 破甲、護衛 |
| 白無常 | 翼 | 一見生財：dash back＋dmg＋banish 40% | kill 時 coin＋energy 20 | 收魂、突進 |
| 黑無常 | 前 | 天下太平：cone 鎖鏈 dmg＋pull | 開場 taunt r120 4 秒 | 收魂（★2 普攻附 banish 25%）、護衛 |
| 孟婆 | 後 | 一碗湯：allies heal 30%＋cleanse 2 | 光環 r160 immune fear_aura | 淨化、定神 |
| 提燈妖 | 後 | 照住你：reveal r200 8 秒＋mark 15% | 普攻 range 120（燈） | 照妖 |
| Orang Bunian | 翼 | 隱身繞後：stealth＋dash back＋dmg 1.7＋sap 30 | 被動看得見隱身（自己 reveal r90） | 照妖、打斷、突進 |
| Banshee | 後 | 報喪尖叫：self_circle r150 interrupt＋push | ★3 光環敵人 energy −30% | 打斷 |
| 吊死鬼 | 前 | 長舌鞭：pull 80＋air | anti_air 1.25（舌由上而下） | 對空、突進 |
| Hantu Galah | 前 | 高處彈額頭：dmg＋down | anti_air；被望（被 ≥3 敵鎖定）atk +20%（KS08「越多人望我就越高」） | 對空 |
| 雷劈鬼 | 後 | 舉傘招雷：chain n4 dmg＋air | anti_air 1.4 | 對空、群攻 |
| 討債鬼 | 前 | 紅油潑門：dmg＋down＋shield_break 100% | attack n3：wound 40% | 破盾、重創 |
| 二房東 | 前 | 我講第二次：circle dispel 2＋coin＋push | 第二次放同一技 ×1.5（「講第二次」） | 驅散 |
| 前女友鬼 | 後 | 我有講錯嗎：circle silence 2.5 秒＋down | 被打 icd 8：反問（taunt 2 秒） | 打斷 |
| 聻 | 翼 | 死多一次：circle sap 25＋banish 30% | 光環 敵人 flee 機率（「鬼之畏聻」） | 收魂、打斷 |
| 餓者髑髏 | 前 | — | kill：hot 5% 3 秒（食） | 斬殺（execute 25% ×1.6） |

（其餘 56 隻由 2.4 自動轉換起步，名冊線補新 28 隻時按 9.3 嘅缺口表填。）

LINK（取代 COMBOS，修返 rts_sim 冇合體技）：兩隻同時上場 → 兩個技能鈕之間出一粒雙頭像鈕，兩隻嚇氣都 ≥100 先可以撳，耗兩邊嚇氣。勾魂索命＝全場 air＋dmg 3.2＋banish 50%；一跳又一跳＝circle r200 down 2 秒。

---

## 9. 工作量、檔案、接口

### 9.1 拆分（ability 線）

| 階段 | 檔案／函數 | 內容 | 估計 |
|---|---|---|---|
| P0 | `game/rts/abil.gd`：data、on、setup、from_legacy、select、targetable、stat、hit、cast、tick_unit、want_cast、tick_auras、on_down、report | 引擎骨架＋舊 SKILLS 自動轉換 | 5 h |
| P0 | `rts_sim.gd` 掛鈎 12 處（3.6） | `# [ab]` 一行級 | 1 h |
| P0 | 積木第一批 22 個（1–3、6、8–10、13–15、17–18、20–23、28–33） | 夠做 10 個機制 | 4 h |
| P0 | MECH 10 個（fly、stealth、shield、regen、summon、thorns、fear_aura、cc_immune、armor、caster） | 數據＋fly／stealth 特例＋caster 讀條 | 2.5 h |
| P0 | 5.3 陣型三點修＋威脅值揀目標＋AoE 半徑 | AB.form、_line_tg、_separate | 3 h |
| P0 | 5.1 AI（ai 條件 6 種＋wait）＋敵人 AI | want_cast | 1.5 h |
| P0 | `rts_view`／`rts_fx`：頭頂狀態圖示（盾、甲、隱、飛、驚）、隱身半透明、飛行高 30px＋影、讀條紅圈、`ab` 事件飄字 | 用 fxkit 現有 sprite | 3 h |
| P0 | `game/rts/ab_card.gd` 出擊卡機制／標籤／警告（推薦＋換上、軍師 P1） | 兩張卡掛 | 2.5 h |
| P0 | `data/abil.json`：16 隻 lore 示例＋敵人主線 17 種機制 | | 2 h |
| P0 | `tools/tests/abil_test.gd`：prim、mech、cover、form、regress | | 4 h |
| **P0 小計** | | **第一版可玩** | **≈ 28.5 h（一人）；拆 3 個 agent 並行 ≈ 1 個工作天** |
| P1 | 其餘 18 積木＋6 機制、星級解鎖、LINK 合體技、長按自動／手動、站位掣、軍師揀 | | 8 h |
| P1 | 72＋28 隻全部 ABIL（按 9.3 缺口）、AB.describe 文字 | 同名冊線並行 | 8 h |
| P1 | meta 測試＋平衡一輪 | | 4 h（＋背景跑） |
| **合計** | | | **≈ 48 h** |

> 同已報老闆嘅「1 天出可玩第一版」對得上嘅前提：P0 拆三條並行（引擎＋積木／陣型＋AI＋測試／畫面＋出擊卡＋數據）。P1 喺補鬼圖嗰 0.5–1 天同步做。

### 9.2 同其他線嘅接口

| 線 | 佢哋畀我 | 我畀佢哋 | 約定 |
|---|---|---|---|
| **克制線** | `abil.json` 入面 `ENEMY`（每隻敵人機制）、`CAMP_MOD`、MECH 數值（倍數、%）；8 種嚇法相剋表照舊（rework） | MECH 定義格式、counter 標籤清單、`AB.mechs_of(k)`、`AB.counters_of(k)`、mech 測試結果 | 嚇法相剋（第 1 層：×1.35／×0.6）同機制（第 2 層）總倍數封頂 0.2–4.0；同一檔分段 ownership：ENEMY／CAMP_MOD 歸克制線，其餘歸 ability 線 |
| **魂魄祭壇線** | 星級存檔欄（建議 `S.soul[k].star`，0–5）；`AB.rank(k)` 只讀 `.get` | 戰後 `op.ab_log.kills = [{k, sum, boss}]`；**召喚物／分裂體 `sum:true` 唔掉魂魄**；收魂（banish）殺嘅可選 +1 魂魄（預設：唔加，免得收魂變必帶） | 星級解鎖積木表（2.3）由我定，祭壇只負責升星 |
| **名冊線** | 新 28 隻 GHOSTS（name／base／range／lore）、tag 圖示 12 個（28px，可商用生成） | 每隻 ABIL 模板、`AB.tags_of`、`AB.describe`、9.3 缺口表 | 新鬼優先補缺口；遠程至少再加 8 隻 |
| **rts 線** | rts_sim／rts_view 現狀 | 掛鈎全部 `# [ab]`、`AB.on()` 一鍵關 | 唔改 Battle.start／finish（結算照舊） |

### 9.3 缺口（按現有 72 隻＋lore 估）

| 標籤 | 現有可得（估） | 目標（100 隻） | 名冊線補新鬼時優先 |
|---|---|---|---|
| 遠程 | 4 | 12 | 弓／吹箭類鬼、長舌長頸（半遠程 range 100） |
| 對空 | 吊死鬼、Hantu Galah、雷劈鬼、轆轤首、Mae Nak、Pontianak、天花姐（7） | 10 | |
| 照妖 | 提燈妖、Orang Bunian（2） | 8 | 有燈、鏡、眼嘅鬼 |
| 淨化 | 孟婆（1） | 8 | 廟祝類（**避開宗教**：用「涼茶」「柚葉水」等民俗） |
| 收魂 | 黑白無常、聻（3） | 8 | |
| 打斷 | Banshee、前女友鬼、舊 sap 技 9 隻 | 10 | |
| 破盾／驅散 | 討債鬼、二房東、孤寒鬼（3） | 8 | |
| 破甲 | 老殭、夜叉（鋼叉）、榴槤砸死鬼（3） | 8 | |
| 定神 | 孟婆光環（1） | 8 | |
| 斬殺 | 餓者髑髏、Aswang（2） | 8 | |
| 護衛／嘲諷 | 黑無常、老殭（2） | 10 | |
| 群攻 | 舊 aoe 24 隻 | 夠 | 唔使補 |

---

## 10. 風險與對策

| 風險 | 對策 |
|---|---|
| 新管線改變舊數值，主線變難／易 | AoE 半徑係唯一默認改動；`ab_off` 對比測試；第一版敵人機制只開第 2 關後 |
| 觸發連鎖無限 loop／爆傷 | icd、depth≤1、總倍數封頂、每格事件上限 64（沿用 vq 上限） |
| 召喚太多單位卡機 | 每場 `sum` 上限 12；perf 測試 |
| 近戰對飛行太痛（只有 4 隻遠程） | 近戰 ×0.4 唔硬鎖；down／air 擊落（現有 30 個技能有）；新鬼補遠程 |
| 出擊卡資訊太多 | 機制最多 3 個圖示、標籤最多 3 個／人；說明撳先出 |
| 熱更新 | 只新增 3 個 .gd（preload）＋1 個 json；唔加 class_name／autoload；唔改 project.godot |
| 「一隊萬能」 | cover／meta 測試做硬指標；任何 3 隻覆蓋 ≤60% |

---

## 11. 未決問題（附預設）

| 問題 | 預設建議 |
|---|---|
| 「智」要唔要喺場上有用？ | 要：嚇氣回復 ×(0.85 + 智/600)，上限 ×1.35；軍師加成封頂 +25%（而家可以去到 +35%，太大） |
| 自動掣預設 | 新存檔開；AI 用 5.1 條件 |
| 名鬼做敵人用幾星能力？ | ★0；王用 ★2 |
| AoE 半徑 | 130px（舊設計稿寫 150；130 配合陣線行距 42–46） |
| 一個據點最多幾個機制 | 3（第 4 圈頭目） |
| 陰兵血公式 | `max(舊, (60+40p)×兵營)`，由數值／克制線最後定 |
| 飛行近戰傷害 | ×0.4 |
| 收魂係咪多掉魂魄 | 唔多掉 |
| 時限 | 照舊 90 秒（再生、護盾機制會令時間到變多，mech 測試監察「時間到率」≤ 15%） |

---

## 12. 參考（業界做法）

- Unreal Engine Gameplay Ability System：能力＝數據化嘅 Ability＋Effect＋Tag，用 Tag 判斷免疫／觸發 —— 本稿「積木＋標籤＋觸發」就係同一思路，但縮到一個 600 行 GDScript static 檔。https://dev.epicgames.com/documentation/en-us/unreal-engine/understanding-the-unreal-engine-gameplay-ability-system 、https://dev.epicgames.com/documentation/en-us/unreal-engine/gameplay-effects-for-the-gameplay-ability-system-in-unreal-engine 、社群詳解 https://github.com/tranek/GASDocumentation
- 明日方舟（Arknights）：敵人特性（飛行／空中單位、隱身）逼玩家帶特定幹員 —— 我哋借「機制 → 要帶應對」嘅結構，但唔做硬鎖。https://arknights.wiki.gg/wiki/Aerial_unit 、https://arknights.wiki.gg/wiki/Invisible 、https://arknights.wiki.gg/wiki/Unit_flags
- Kingdom Rush：護甲／魔抗類型對應唔同塔 —— 參考「每種防禦都有 2–3 種解法」。https://support.ironhidegames.com/support/solutions/articles/4000223666-armor-types-breakdown-kingdom-rush-battles-guide
- 我哋自己嘅特色（唔係照搬）：①敵我同一套能力，打過＝睇到招降後能力；②現有「嚇法相剋／失神／連嚇」保留做第一層，機制做第二層；③舊技能嘅腳軟／嚇彈起變成「擊落飛頭」等應對，舊 72 隻即刻有用；④陰間打工味：二房東「講第二次」加成、Hantu Galah「越多人望越高」、前女友鬼反問嘲諷。
