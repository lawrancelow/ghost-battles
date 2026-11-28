# 過勞鬼市集 M1 ↔ M2 接口（M1 線定稿 2026-11-28）

M1 營運層全部在新檔 `godot/game/market/mk_ops.gd`（下稱 MKO）＋數值 `godot/data/market_ops.json`，狀態存 `S.mk.ops`。
M1 沒有改 `market.json` 的既有欄位、沒有動 `mk_ui.gd`、`mv_scene.gd`；`mv_sim.gd` 只**新增行**（沒有改 M2 改過的那幾行），合併時兩邊的行都保留即可。

用法：`const MKO = preload("res://game/market/mk_ops.gd")`（無 class_name、無 autoload）。

## 一、M2 在等的三個接口

### 1. `J.G["mk_counter_n_fn"]`：櫃檯員人數
- 簽名：`Callable(street: String) -> int`，回該街在職櫃檯員數（0–3）。
- 由 `MKO.reg()` 登記（`MK.reg_metrics()` 和 `MKO.tick()` 都會叫，重複叫無害；已有人登記就不覆蓋，M2 測試自己塞假的照樣有效）。
- M2 的 `FUN.counter_n(street)` 已經是先讀這個，**不用改**。
- 反方向：M1 收銀箱入帳前會問 `FUN.counter_down(street) -> bool`（櫃檯趴下＝當沒櫃檯員）。

### 2. `patrol_handled`：巡邏員處理了一件
- M1 在巡邏員**成功**處理事件時呼叫 M2：`FUN.patrol_handled(who: String, team_n: int) -> Dictionary`
  - `who`＝鬼 id（字串），`team_n`＝該街巡邏隊人數（1–4，**上限已由 2 改為 4**）。回傳值 M1 不使用。
- M1 派人前會問 M2（M2 沒這些函式就用預設值）：
  - `FUN.patrol_ok(who) -> bool`（預設 true；趴下的巡邏員當沒有）
  - `FUN.patrol_reach(who) -> int`（預設 0；≥1＝隊長可兼顧相鄰一條街）
  - `FUN.patrol_speed(who) -> float`（預設 0.7；隊長兼顧相鄰街時處理時間 ÷ 這個數）
  - `FUN.rush_phase() -> String`（"peak" 事件頻率 ×2、"rest" ×0.5）
- M1 找 M2 的方式：`res://game/market/mk_fun.gd` 存在才載入，按函式名呼叫；所以 M2 分支單獨跑、M1 分支單獨跑都不會報錯。
- 注意 `staff_fat_mul(team_n)` 目前最多 −40%（5 人封頂），巡邏 4 隻＝−30%，不用改。

### 3. `extra_slots`：店員位
- 權威表在 M1：`MKO.staff_slots(sid: String, lv: float) -> int`（Lv1/10/25/50/100/200 → 1/2/3/3/4/5；奢侈品店最多 2）。
- `MKO.extra_slots(sid, lv) -> int`＝`staff_slots − 1`。**請 M2 把 `FUN.extra_slots` 改成直接回 `MKO.extra_slots(sid, lv)`**（M2 現在用 slot_lv 25/100/200，和老闆定的表不同）。
- `MKO.staff_mul(n) -> float`：n 名店員總產能 1／1.35／1.70／1.95／2.20。實際套用在 `MK.mul(sid)` 裡（`× MKO.prod_k(sid)`）。
- 位數由 M1 每格維護（`workers` 陣列自動補到該等級位數；超出的店員放回村子）。

## 二、M1 提供給畫面／M2 的其他函式
| 函式 | 說明 |
|---|---|
| `MKO.assign(sim, kind, street, gid) -> "ok"/"full"/"bad"/"closed"` | `kind`＝"ctr" 櫃檯員（每街 0–3）／"pat" 巡邏員（每街 0–4）；鬼從原崗位調走，`post`＝"mk_ctr"／"mk_pat" |
| `MKO.unassign(sim, gid) -> bool` | 撤回村子 |
| `MKO.staff_of(kind, street) -> Array`、`counter_n(street)`、`patrol_n(street)`、`village_cost()` | 名單與人數 |
| `MKO.till(street) -> float`、`MKO.collect(sim, street, by := "tap") -> float` | 收銀箱未入帳金額；玩家點收銀箱即收 |
| `MKO.sub_open(sid)`、`sub_choices(ci, sid)`、`set_sub(ci, sid, gid)`、`sub_of(sid)`、`ratio/set_ratio`、`smart/set_smart` | 雙貨（Lv25 開；換貨後 10 秒不產出） |
| `MKO.events(street := "") -> Array` | 未處理事件：`{id, k, street, sid, sp, var, n:[粵,中], t, st:"open"/"chase", who}`；`k`＝steal_cash／steal_goods／cut_queue／brawl |
| `MKO.handle_event(sim, id) -> bool` | 玩家親自點事件：立即處理、名聲 +2 |
| `MKO.spawn_event(sim, street, type := "", special := -1)` | 手動生成（劇情、教學用） |
| `MKO.loss_room(street)`、`win_income(street)`、`win_loss(street)` | 10 分鐘 15% 損失上限的餘額 |
| `MKO.summary()` | `{clk, income, loss, handled, lost, village_cost}` |

## 三、事件佇列（沿用 `MK.evq`，`MK.pop_events()` 取）
- `{"k":"ev_new","ev":e}`、`{"k":"ev_tut","ev":e}`（開張第 3 分鐘固定第一件插隊）
- `{"k":"ev_chase","id","who"}`、`{"k":"ev_miss","id","who"}`
- `{"k":"ev_done","ev":e,"by":"patrol"/"tap","renown":1/2,"praise":bool}`（praise＝每 10 件觸發甄好賣一句）
- `{"k":"ev_lost","ev":e,"loss":金額,"capped":bool,"info":{…}}`（capped＝到 15% 上限，只演出）
- `{"k":"till","street","amt","by":"ctr"/"worker"/"tap"}`、`{"k":"swap","sid","gid"}`、`{"k":"staff","kind","street","n"}`

## 四、名聲與 KPI
- 處理成功時 M1 呼叫 `J.G["mk_renown_add_fn"]`（`Callable(pts: int, why: String)`）；沒登記就累加到 `S.mk.renown_pts`。**請 M2 的 mk_renown 登記這個**。
- 人流係數讀 `S.mk.renown_lv`。
- KPI 指標 `mk_patrol_done` 現在讀真實處理次數 `S.mk.patrol_done`（不再預設 5）。

## 五、mv_sim.gd 新增的行（M2 合併時保留）
1. `const MKO = preload(...)`
2. `_step_workers`：`gid = MKO.wgood(w, gid)`；做完一轉後 `if MKO.batch_sub(self, sid, w, n): continue`
3. `step()`：`if MK.active(): MKO.tick(self, dt * sp)`
4. `cust_value()`：`amt += MKO.sub_adj(self, c)`
5. `_pay()`：`add_coins(amt)` 後 `MKO.on_pay(self, c, amt)`（錢先進收銀箱）
6. `goods_list()`／`avail_goods()`：加入副貨

## 六、2026-11-28 15:45 補充
- **預設副貨配對**（goods_final）：`market_ops.json` 的 `pairs[ci]＝{主攤: 副貨攤}`。副貨攤不再獨立擺攤（`MK.stall_list()` 會剔掉），它的貨在主攤 **Lv25** 自動成為副貨（`MKO.sub_of()`；玩家選過就用玩家的，選 "" ＝不賣副貨）。
  - 目前生效：第 1 章 枯井豆花＋豆花擔；第 3 章 嘆氣包＋霧谷茶寮、補丁紙衣＋單腳草鞋、紙紮兵器＋義莊板盾；第 4 章 夜捲蕉葉＋碟頂鹹魚；第 5 章 外賣＋收工醋；第 6 章 補丁紙衣＋單褲管紙褲。
  - `pairs_pending`＝其中一邊是新台（或第 2 章現有攤太少），等新台數據併入再生效。
  - **M2 注意**：`MD.stations(ci)`、`MK.sids_on()` 因此少了副貨攤；副貨的 gid 會出現在 `sim.goods_list()`／櫃台／客人 `wants`，`sim.sid_of(gid)` 對未擺攤的副貨回 ""，要查寄賣攤用 `MKO.host_of(gid)`、單價用 `MKO.sub_val(sim, gid)`。`FUN.item_mul(self, sid)` 那行對副貨不會乘到（sid 為空），如要讓副貨也吃加班 ×1.2／潮流，請在 `MKO.sub_adj` 之後另乘。
- **45 個新攤數據初稿**：`godot/data/market_new_stalls.json`（STATIONS＋GOODS，價格＝該章基價 × 街階倍率）。**未併入 outpost.json**，等美術過審。
- **佔位畫面** `godot/game/market/mk_ops_ui.gd`（M1 新檔）：街名牌列下方一條「櫃檯 n/3 −＋｜巡邏 n/4 −＋｜收銀箱」，再下面是事件紅牌（點＝主角處理）。`mv_scene.gd` 新增三行：`const MKOU`、`MKOU.draw(self, ctx)`（在 `MKU.draw_strip` 後）、`if MKOU.tap(self, p): return`（在 `MKU.tap` 前）。M2 的 mk_ui 如要接管，把這兩個呼叫拿掉即可。
- 浮字：`MKO.toast(text, color)`／`MKO.pop_toasts()`。
- `MK.ot_mul(sid)`：只含加班與老員工的倍數（不含店員人數、停工），估算攤位產值用。

## 七、第二階段補充（2026-11-28 傍晚）
- **畫面排位**：`MKOU.hud_bot`（static var，畫面座標）＝M1 這一疊（人手列＋治安卡＋對白條）這一格的底。M2 的 `draw_hud` 要排在它下面：`y = maxf(y, MKOU.hud_bot + 6)`（合併分支 `market-int` 已加這三行）；`mv_scene.chain_btn_pos` 也已避開。
- **演出事件**：M1 畫面改讀自己的 `MKO.pop_fx()`（內容同 `MK.evq`，但不會被 M2 的畫面取走）；對白走 `MKO.pop_say()`。M2 照舊 `MK.pop_events()`。
- **過勞四段小卡**（已選用美術第 1 款，素材鍵 `mk_ow_1…4`）由 M1 的 `MKOU._draw_ow` 畫在攤位上方：過勞 ≥70 硬撐、≥90 快不行、趴下、餵包子復活 2.5 秒。M2 的掛牌在攤位左上，不衝突；M2 如已有趴下演出，請二選一（建議留這套，老闆選的就是這款）。
- **客流參數**（加班平衡）：`market_ops.json` 的 `demand.base`／`demand.ot_draw`，`mv_sim` 新增一行 `spawn_t /= MKO.flow_mul(self)`。原因：原本客人每 2.2–4 秒來一位、排隊最多 4 位，收入被客流卡死，加班產量 ×2 賣不掉（實測不加班仍有 95–104%）。`ot_draw`＝全街加班時客流再 ×(1+ot_draw)。
- **按章價格**：`mk_price.gd` 視圖（`MD.st_def`／`good_def`／`goals` 在市集模式下回傳按章換算後的副本）；開關 `market_ops.json` 的 `price_rebase`。M2 的 `item_mul` 等照舊乘在 `MD.val` 上，不用改。
- **目標補發**：`MKO.comp_goals(sim)`（每格），輪到被跳過的目標時自動發獎，記在 `S.mv.goals_comp`。
- **文案詞庫**：`data/market_lines.json`（`tools/market_lines_build.py` 由文案稿產生並檢查同章不重複）。`MKO.complain()` 取過勞抱怨（20 句輪完才重複）——M2 的過勞泡泡請也用這個函式，避免兩邊各出各的造成同一句重複。
