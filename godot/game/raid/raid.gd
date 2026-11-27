# [raid] 第四期：村子被惡鬼襲擾（邏輯，全部 static；畫面喺 game/raid/raid_view.gd）
# 用法：const RAID = preload("res://game/raid/raid.gd")；冇 class_name、冇 autoload（熱更新規矩）
#
# 流程：
#   開始：第 1 關擊敗餓鬼王（zb_eguiking）→ 排一段劇情 zs0_raid_intro（入 mv_story 佇列，守「一個任務只放一段故事」）→ 播完先開始計時。
#         舊存檔已經過咗第 1 關：唔補播劇情，出一句系統通知（style sys，唔算故事）就開始。
#   頻率：在線每 TUNE.every_min～every_max 秒一次；最後 TUNE.warn 秒畫面上方預告（idle → warn）。
#         劇情播放中、戰鬥中、新手頭幾個任務（S.qi < min_qi）唔計時。
#         離線（兩次 tick 相隔 > offline_gap 秒）：最多積一次——返嚟最多即刻預告一次，唔會一次過嚟幾轉。
#   到達：隨機揀一個運作中嘅目標（村子建築／大排檔／已佔資源區；停工中、壞咗嘅唔揀）。
#         防衛戰力（派去防衛 × def_full ＋ 待命陰兵 × def_frac 保底；算法用兵營 bk_data）≥ 惡鬼戰力 → 自動擊退、小收入；
#         唔夠 → 惡鬼行到目標（walk 秒）再圍住（siege 秒）：玩家可以按行動按鈕（act_targets kind "raid"）或者撳惡鬼親自迎戰（大地圖戰鬥 kind raid）。
#         打贏＝擊退；打輸／唔理到時間＝襲擾成功。
#   懲罰：同一處連續被成功襲擾第 1、2 次：停工 stop 秒（損壞外觀）；第 break_n 次：壞咗，要花資源修理（點建築出修理掣），唔修唔運作。
#         嗰處成功擊退一次 → 連續計數歸零。
# 存檔：S.raid（讀一律 .get(key, 預設)；舊存檔冇呢格自動補）
extends RefCounted

const ZD = preload("res://game/zone/zone_data.gd")
const PACE = preload("res://game/econ/pace.gd")   # [ux] 前期節奏

# ================= 數值（老闆試完喺度調） =================
const TUNE := {
	"first": 180.0,        # 劇情播完 → 第一次惡鬼到達（秒，在線；包括預告）
	"every_min": 480.0,    # 之後每次相隔（秒，在線）最少 8 分鐘
	"every_max": 720.0,    #                      最多 12 分鐘
	"warn": 60.0,          # 提前幾秒預告
	"walk": 14.0,          # 防衛唔夠：惡鬼由邊界行到目標要幾秒
	"siege": 75.0,         # 行到之後圍住幾秒：呢段時間內可以親自迎戰，過咗就算襲擾成功
	"min_qi": 8,           # 新手：主線任務未做夠呢個數唔襲擾
	"offline_gap": 30.0,   # 兩次 tick 相隔超過幾秒當離線／切咗出去
	"pow_base": 20.0,      # 惡鬼戰力 = pow_base + 第幾關 × pow_ci + min(已襲擾次數, pow_n_max) × pow_n
	"pow_ci": 40.0,
	"pow_n": 3.0,
	"pow_n_max": 20.0,
	"def_full": 1.0,       # 防衛戰力：派去防衛嘅陰兵（兵營 bk_data.def_power，已含加成、防衛隊長）× 呢個
	"def_frac": 0.5,       #          ＋ 待命陰兵（未派出；冇兵營＝全部）戰力 × 呢個（保底）
	"auto_coins": 25.0,    # 自動擊退：冥幣 = auto_coins × (第幾關 + 1)
	"fight_coins": 60.0,   # 親自迎戰打贏：冥幣 = fight_coins × (第幾關 + 1)
	"fight_p": 0.6,        # 親自迎戰嘅敵人強度 = 呢關第一場主線關卡強度（p）× 呢個（越細越易）
	"fight_n": 3,          # 親自迎戰幾多隻惡鬼
	"stop": 180.0,         # 襲擾成功：停工幾秒（3 分鐘）
	"break_n": 3,          # 同一處連續被成功襲擾幾多次就壞咗
	"repair": {"planks": 30.0, "coins": 80.0},   # 修理費（第 1 關）
	"repair_ci": 0.5,      # 每多一關修理費 × (1 + 呢個)
}
const KING_ID := "zb_eguiking"            # 第 1 關餓鬼王
const INTRO := "zs0_raid_intro"           # 開始劇情（data/nat/mv_story.json）
const TGT_BLD := ["wood", "rice", "plank", "bun", "store", "home", "camp"]   # 會被襲擾嘅村子建築（有產出嘅）
const FOES := {0: ["egui", "egui", "egui"]}   # 每關惡鬼（冇列就用大排檔圍欄惡鬼 fence_foes）

static var now_override := 0.0            # 測試用：固定「而家」（毫秒）
static var LOG: Array = []                # 測試用：[[事件, 資料], …]
static var NEWS: Array = []               # 畫面要出嘅提示：{k, …}（raid_view 食）
static var hold_fn: Callable = Callable() # 測試用：代替「而家唔好計時」判斷（回原因字串；"" = 可以）
static var _last_ms := 0
static var _reg := false

static func now_ms() -> float: return now_override if now_override > 0.0 else Time.get_unix_time_from_system() * 1000.0
static func L(yue: String, zh: String) -> String: return ZD.L(yue, zh)
static func S():
	var s = J.G.get("S")
	return s if s is Dictionary and not s.is_empty() else null
static func _log(ev: String, d = null) -> void:
	LOG.append([ev, d])
	if LOG.size() > 400: LOG.pop_front()

# ================= 存檔 =================
static func blank() -> Dictionary:
	return {"v": 1.0, "on": 0.0, "ph": "idle", "left": 0.0, "cur": null, "fight": null, "n": 0.0, "won": 0.0, "lost": 0.0,
		"streak": {}, "down": {}, "broken": {}, "seen": 0.0, "iq": 0.0, "note": 0.0}
static func st():
	var s = S()
	if s == null: return null
	var r = s.get("raid")
	if not (r is Dictionary):
		r = blank(); s["raid"] = r
	else:
		var b = blank()
		for k in b: if not r.has(k): r[k] = b[k]   # 舊版欄位補齊
		for k in ["streak", "down", "broken"]: if not (r[k] is Dictionary): r[k] = {}
	return r
static func _peek():   # 唔建立（產出掛鈎用：冇 S.raid 就當冇事）
	var s = J.G.get("S")
	if not (s is Dictionary): return null
	var r = s.get("raid")
	return r if r is Dictionary else null

# ================= 目標 =================
static func ci() -> int:
	var s = S()
	if s != null and s.get("mv") is Dictionary: return int(J.num(s.mv.get("ci", 0)))
	return ZD.ci()
static func tkey_b(id: String) -> String: return "b:" + id
static func tkey_z(zid: String, c := -1) -> String: return "z:%d:%s" % [ci() if c < 0 else c, zid]
# 而家可以被襲擾嘅目標（全部，包括停工／壞咗）
static func all_targets() -> Array:
	var s = S(); var o = []
	if s == null: return o
	var bl = s.get("bld", {})
	for id in TGT_BLD: if bl is Dictionary and J.num(bl.get(id, 0)) > 0: o.append(tkey_b(id))
	if ZD.on() and ZD.revealed("market"): o.append("market")
	if ZD.on():
		for z in ZD.of_type("res"): if ZD.owned(str(z.id)): o.append(tkey_z(str(z.id)))
	return o
# 運作中（未停工、未壞）
static func targets() -> Array:
	var o = []
	for k in all_targets(): if state_of(k) == "": o.append(k)
	return o
static func tname(key: String) -> String:
	if key == "market": return L("大排檔", "大排檔")
	if key.begins_with("b:"):
		var B = J.G.get("BUILDINGS"); var id = key.substr(2)
		return J.str(DB.L(J.str(B[id].name))) if B is Dictionary and B.get(id) != null else id
	if key.begins_with("z:"):
		var p = key.split(":")
		if p.size() >= 3: return ZD.T(ZD.zone(p[2], int(p[1])).get("n", [p[2], p[2]])).split("　")[-1]
	return key
# 目標位置（世界座標；建築＝地基中間）
static func tpos(key: String) -> Vector2:
	if key == "market":
		var sp = market_spots()
		if sp.size(): return sp[0]
		var mk = ZD.cur().get("market", {})
		if mk is Dictionary and mk.get("house") is Array: return ZD.v2(mk.house)
		return ZD.zrect("market").get_center()
	if key.begins_with("b:"):
		var P = J.G.get("POS"); var id = key.substr(2)
		if P is Dictionary and P.get(id) is Array: return Vector2(J.num(P[id][0]), J.num(P[id][1]))
		return Vector2.ZERO
	if key.begins_with("z:"):
		var p = key.split(":")
		if p.size() >= 3:
			var CB = load("res://game/outpost/chain_bld.gd")
			var z = ZD.zone(p[2], int(p[1]))
			for b in (z.get("shops", {}) as Dictionary):
				var bp = CB.pos(str(b))
				if bp.x > -900.0: return bp
			return ZD.zrect(p[2], int(p[1])).get_center()
	return Vector2.ZERO
# 大排檔已開嘅檔口位置（最多 3 個；惡鬼衝去第一個、損壞畫喺呢幾個）
static func market_spots() -> Array:
	var s = S(); var o = []
	if s == null or not (s.get("mv") is Dictionary) or not (s.mv.get("st") is Dictionary): return o
	var MD = load("res://game/outpost/mv_data.gd")
	for sid in MD.stations(ci()):
		if o.size() >= 3: break
		var e = s.mv.st.get(str(sid))
		if e is Dictionary and J.t(e.get("unlocked")): o.append(MD.st_xy(ci(), str(sid)) + Vector2(0, 10))
	return o
# 資源區入面嘅建築 bid（畫損壞用）
static func zone_bids(key: String) -> Array:
	var p = key.split(":")
	if p.size() < 3: return []
	return ZD._zbids(ZD.zone(p[2], int(p[1])))
# 惡鬼由邊個方向嚟：[方向字, 出發點]
static func approach(key: String) -> Array:
	var p = tpos(key); var ws = ZD.world_size()
	var d = "N"
	if key.begins_with("z:"):
		var r = ZD.zrect(key.split(":")[2], int(key.split(":")[1]))
		if r.end.x <= ws.x * 0.25: d = "W"
		elif r.position.x >= ws.x * 0.75: d = "E"
		elif r.position.y >= ws.y * 0.75: d = "S"
	var v = {"N": Vector2(0, -1), "S": Vector2(0, 1), "W": Vector2(-1, 0), "E": Vector2(1, 0)}[d]
	var f = p + v * 520.0
	f = Vector2(clampf(f.x, 30.0, ws.x - 30.0), clampf(f.y, 40.0, ws.y - 20.0))
	return [d, f]
static func dir_txt(d: String) -> String:
	return {"N": L("北面", "北面"), "S": L("南面", "南面"), "W": L("西面", "西面"), "E": L("東面", "東面")}.get(d, L("北面", "北面"))
static func foe_name(c := -1) -> String:
	return L("餓鬼", "餓鬼") if (ci() if c < 0 else c) == 0 else L("惡鬼", "惡鬼")
static func foe_kinds(c := -1) -> Array:
	var cc = ci() if c < 0 else c
	if FOES.has(cc): return FOES[cc].duplicate()
	var MD = load("res://game/outpost/mv_data.gd")
	var ks = MD.map_def(cc).get("fence_foes", ["youhun"])
	var ET = J.G.get("ENEMY_T"); var o = []
	if ks is Array:
		for k in ks: if not (ET is Dictionary) or ET.has(str(k)): o.append(str(k))
	if o.is_empty(): o = ["youhun"]
	while o.size() < 3: o.append(o[o.size() % maxi(1, o.size())] if o.size() else "youhun")
	return o.slice(0, 3)

# ================= 停工／壞咗 =================
# "" 運作中；"down" 停工中；"broken" 壞咗（要修）
static func state_of(key: String) -> String:
	var r = _peek()
	if r == null: return ""
	if r.get("broken") is Dictionary and J.t(r.broken.get(key)): return "broken"
	if r.get("down") is Dictionary and J.num(r.down.get(key, 0)) > now_ms(): return "down"
	return ""
static func is_down(key: String) -> bool: return state_of(key) != ""
static func down_left(key: String) -> float:
	var r = _peek()
	if r == null or not (r.get("down") is Dictionary): return 0.0
	return maxf(0.0, (J.num(r.down.get(key, 0)) - now_ms()) / 1000.0)
static func streak(key: String) -> int:
	var r = _peek()
	return int(J.num(r.streak.get(key, 0))) if r != null and r.get("streak") is Dictionary else 0
# 產出掛鈎（native/game.gd rates_per_min、chain_eco.rates、mv_war.blocked）
static func post_down(post: String) -> bool: return _peek() != null and is_down(tkey_b(post))
static func bid_down(bid: String) -> bool:
	if _peek() == null: return false
	var z = ZD.bid_zone(bid)
	return z != "" and is_down(tkey_z(z))
static func market_down() -> bool: return _peek() != null and is_down("market")

# ================= 戰力 =================
static func has_army() -> bool:
	var s = S()
	return s != null and s.get("army") is Dictionary
static func _bk(): return load("res://game/barracks/bk_data.gd")
# 待命陰兵戰力（未派出；冇兵營＝全部陰兵都算待命）
static func standby_pow() -> int:
	if S() == null: return 0
	var BK = _bk()
	if not BK.built(): return int(floor(float(BK.total()) * BK.troop_mul()))
	return BK.power()
# 派去防衛嘅陰兵戰力（直接用兵營算法：def × 民宅／兵營加成 × 防衛隊長加成；冇兵營＝0）
static func deployed_pow() -> int:
	if S() == null: return 0
	var BK = _bk()
	return BK.def_power() if BK.built() else 0
# 防衛戰力 = 派去防衛 × def_full ＋ 待命 × def_frac（保底：唔派兵都守得住初期襲擾；派咗更穩）
static func def_pow() -> int:
	if S() == null: return 0
	return int(floor(float(deployed_pow()) * float(TUNE.def_full) + float(standby_pow()) * float(TUNE.def_frac)))
static func foe_pow(n := -1) -> int:
	var r = st(); var nn = J.num(r.n) if n < 0 and r != null else float(maxi(n, 0))
	return int(round(float(TUNE.pow_base) + float(TUNE.pow_ci) * ci() + minf(nn, float(TUNE.pow_n_max)) * float(TUNE.pow_n)))

# ================= 開始條件 =================
static func king_done() -> bool:
	for z in ZD.of_type("wild", 0):
		var bs = ZD.bosses(str(z.id), 0)
		for i in bs.size(): if str(bs[i].get("id", "")) == KING_ID: return ZD.boss_done(str(z.id), i, 0)
	var s = S()   # 冇分區資料：睇主線 1-3
	return s != null and s.get("cleared") is Dictionary and J.t(s.cleared.get("1-3"))
static func unlocked() -> bool: return ci() > 0 or king_done()
static func _MS(): return load("res://game/outpost/mv_story.gd")
static func intro_seen() -> bool: return _MS().is_seen(INTRO)

# 而家唔好計時嘅原因（"" = 可以）
static func hold_reason(main = null) -> String:
	if hold_fn.is_valid(): return str(hold_fn.call())
	var s = S()
	if s == null: return "nos"
	if J.num(s.get("qi", 0)) < float(TUNE.min_qi): return "newbie"
	if not PACE.raid_on(): return "pace"   # [ux] 安頓期／鎖住：唔襲擾
	var MB = load("res://game/zone/zone_battle.gd")
	if MB.busy(): return "battle"
	var B = J.G.get("Battle")
	if B is Dictionary and J.t(B.get("active")): return "battle"
	var Sy = J.G.get("Story")
	if Sy is Dictionary and J.t(J.mc(Sy, "busy", [])): return "story"
	if main != null and is_instance_valid(main):
		var p = main.get("story")
		if p is Control and p.has_method("busy") and p.busy(): return "story"
		for k in ["title_ov", "phone", "loading", "selftest"]:
			var v = main.get(k)
			if v != null and is_instance_valid(v): return "ui"
	return ""

# ================= 每 0.5 秒（ui/main.gd _mv_tick） =================
static func tick(main = null, dt := -1.0) -> void:
	var s = S()
	if s == null or not J.t(s.get("mv_on")): return
	if not _reg: _register()
	var ms = Time.get_ticks_msec()
	if dt < 0.0: dt = clampf((ms - _last_ms) / 1000.0, 0.0, 2.0) if _last_ms > 0 else 0.0
	_last_ms = ms
	var r = st()
	var t = now_ms()
	var gap = (t - J.num(r.seen)) / 1000.0 if J.num(r.seen) > 0.0 else 0.0
	r["seen"] = t
	_expire()
	poll_fight()
	if not ZD.on() or not unlocked(): return
	if not J.t(r.on):
		if not _start_ok(main): return
		r["on"] = 1.0; r["ph"] = "idle"; r["left"] = maxf(float(TUNE.first), PACE.raid_first()); r["cur"] = null   # [ux] 練手期第一次遲啲
		_log("on", ci())
		return
	if gap > float(TUNE.offline_gap) and PACE.raid_on(): offline(gap)   # [ux] 安頓期離線都唔積襲擾
	if hold_reason(main) != "": return
	step(dt)

# 開始：劇情播咗（或者舊存檔已經過咗第 1 關：系統通知）
static func _start_ok(main) -> bool:
	var r = st()
	if intro_seen(): return true
	if ci() > 0:   # 舊存檔：唔補播第 1 關劇情（佇列會清走唔係呢張圖嘅 beat），出一句系統通知
		if hold_reason(main) != "": return false
		if not J.t(r.note):
			r["note"] = 1.0
			var Sy = J.G.get("Story")
			if Sy is Dictionary: J.mc(Sy, "queue", [{"style": "sys", "lines": [[L("系統", "系統"), L("叮！偵測到落魄村附近有惡鬼出沒，會不定時嚟襲擾。陰兵守得住就自動擊退；守唔住，親可以親自出手哦～", "叮！偵測到落魄村附近有惡鬼出沒，會不定時來襲擾。陰兵守得住就自動擊退；守不住，親可以親自出手哦～")]]}])
			_log("note")
		return true
	if not J.t(r.iq):   # 第 1 關：劇情入 mv_story 佇列（一個任務只放一段故事：等玩家做下一個任務先播）
		r["iq"] = 1.0
		_MS().zone_ev("raid_intro", "")
		_log("intro_q")
	else:
		var q = _MS().zq()
		if not q.has(INTRO) and not intro_seen(): q.append(INTRO)   # 佇列畀人清咗（例如讀舊檔）：補返
	return false

# 推進（已經過咗所有「唔好計時」檢查）
static func step(dt: float) -> void:
	var r = st()
	if r.get("cur") is Dictionary and int(J.num(r.cur.get("ci", ci()))) != ci() and not (r.get("fight") is Dictionary):   # 拔營咗：舊圖嗰隊散咗
		r["ph"] = "idle"; r["cur"] = null; r["left"] = maxf(J.num(r.left), float(TUNE.warn) + 30.0)
		_log("moved")
	match str(r.ph):
		"idle":
			r["left"] = J.num(r.left) - dt
			if J.num(r.left) <= float(TUNE.warn): begin_warn()
		"warn":
			r["left"] = J.num(r.left) - dt
			if J.num(r.left) <= 0.0: arrive()
		"siege":
			if r.get("fight") is Dictionary: return   # 迎戰緊：唔計
			var c = r.cur
			c["t"] = J.num(c.get("t", 0)) + dt
			if J.num(c.t) >= float(TUNE.walk) + float(TUNE.siege): fail()

# 離線：最多積一次
static func offline(gap: float) -> void:
	var r = st()
	_log("offline", gap)
	match str(r.ph):
		"idle":
			r["left"] = maxf(J.num(r.left) - gap, float(TUNE.warn))   # 過咗時間：返嚟即刻預告（得一次）
			if J.num(r.left) <= float(TUNE.warn): begin_warn()
		"warn": r["left"] = float(TUNE.warn)   # 預告緊就走咗：返嚟重新預告一次（唔會趁你唔喺度就打埋）
		_: pass                               # 圍住緊：等你返嚟先計

static func next_gap() -> float: return randf_range(float(TUNE.every_min), float(TUNE.every_max)) * PACE.raid_mul()   # [ux] 練手期 ×1.8

static func begin_warn() -> void:
	var r = st()
	var ts = targets()
	if ts.is_empty():   # 冇嘢好搶：下一輪
		r["ph"] = "idle"; r["left"] = next_gap(); _log("notgt"); return
	var key: String = ts[randi() % ts.size()]
	var ap = approach(key)
	r["cur"] = {"tgt": key, "dir": ap[0], "from": [ap[1].x, ap[1].y], "pow": float(foe_pow()), "ks": foe_kinds(), "t": 0.0, "ci": float(ci())}
	r["ph"] = "warn"; r["left"] = clampf(J.num(r.left), 1.0, float(TUNE.warn))
	NEWS.append({"k": "warn", "tgt": key})
	_log("warn", key)

static func arrive() -> void:
	var r = st(); var c = r.cur
	if not (c is Dictionary): r["ph"] = "idle"; r["left"] = next_gap(); return
	r["n"] = J.num(r.n) + 1.0
	var dp = def_pow()
	if c.has("force"): dp = int(c.force)
	c["def"] = float(dp)
	if dp >= int(J.num(c.pow)):
		_log("auto", [c.tgt, dp, c.pow])
		load("res://game/rts/rts.gd").raid_show(c.duplicate(true))   # [rts] 睇到防衛隊出營迎擊
		repel("auto")
	else:
		r["ph"] = "siege"; c["t"] = 0.0
		NEWS.append({"k": "siege", "tgt": str(c.tgt)})
		_log("siege", [c.tgt, dp, c.pow])

# 擊退（auto 陰兵自動／fight 親自迎戰）
static func repel(how: String) -> void:
	var r = st(); var c = r.cur
	var key = str(c.tgt) if c is Dictionary else ""
	var coins = float(TUNE.auto_coins if how == "auto" else TUNE.fight_coins) * (ci() + 1)
	var s = S()
	s.res["coins"] = J.num(s.res.get("coins", 0)) + coins
	if key != "": r.streak.erase(key)
	r["won"] = J.num(r.won) + 1.0
	NEWS.append({"k": "repel", "how": how, "tgt": key, "coins": coins})
	load("res://game/soul/soul_data.gd").on_raid(how)   # [soul] 擊退：散魂
	_log("repel", [how, key, coins])
	_next()
# 襲擾成功
static func fail() -> void:
	var r = st(); var c = r.cur
	if not (c is Dictionary): _next(); return
	var key = str(c.tgt)
	var n = streak(key) + 1
	r.streak[key] = float(n)
	r["lost"] = J.num(r.lost) + 1.0
	if n >= int(TUNE.break_n):
		r.broken[key] = 1.0; r.down.erase(key)
		NEWS.append({"k": "broken", "tgt": key})
		_log("broken", key)
	else:
		r.down[key] = now_ms() + float(TUNE.stop) * 1000.0
		NEWS.append({"k": "down", "tgt": key, "n": n})
		_log("down", [key, n])
	_next()
static func _next() -> void:
	var r = st()
	r["ph"] = "idle"; r["cur"] = null; r["left"] = next_gap()
	_save()

# 停工時間到：恢復（出提示）
static func _expire() -> void:
	var r = _peek()
	if r == null or not (r.get("down") is Dictionary): return
	var t = now_ms()
	for k in r.down.keys():
		if J.num(r.down[k]) <= t:
			r.down.erase(k)
			NEWS.append({"k": "resume", "tgt": str(k)})
			_log("resume", k)

# ================= 修理 =================
static func repair_cost(key := "") -> Dictionary:
	var m = 1.0 + float(TUNE.repair_ci) * ci(); var o = {}
	for k in TUNE.repair: o[k] = round(float(TUNE.repair[k]) * m)
	return o
static func can_repair(key: String) -> bool:
	if state_of(key) != "broken": return false
	var s = S(); var c = repair_cost(key)
	for k in c: if J.num(s.res.get(k, 0)) < float(c[k]): return false
	return true
static func repair(key: String) -> bool:
	if not can_repair(key): return false
	var s = S(); var c = repair_cost(key)
	for k in c: s.res[k] = J.num(s.res.get(k, 0)) - float(c[k])
	var r = st()
	r.broken.erase(key); r.streak.erase(key); r.down.erase(key)
	NEWS.append({"k": "fixed", "tgt": key})
	_log("repair", key)
	_save()
	return true
static func cost_txt(c: Dictionary) -> String:
	var RN = {"planks": L("棺材板", "棺材板"), "coins": L("冥幣", "冥幣"), "wood": L("槐木", "槐木"), "rice": L("糯米", "糯米"), "buns": L("壽包", "壽包")}
	var a = []
	for k in c: a.append("%s ×%d" % [RN.get(k, k), int(c[k])])
	return "、".join(a)

# ================= 親自迎戰（大地圖戰鬥 kind raid，落點＝目標） =================
static func can_fight() -> bool:
	var r = _peek()
	return r != null and str(r.get("ph", "")) == "siege" and r.get("cur") is Dictionary and not (r.get("fight") is Dictionary)
static func fight_sid() -> String: return L("襲擾", "襲擾") + "·%d" % (ci() + 1)
static func fight_stage() -> Dictionary:
	var r = st(); var c = r.cur
	var ks: Array = c.ks if c is Dictionary and c.get("ks") is Array else foe_kinds()
	var CH = J.G.get("CHAPTERS"); var p = 1.0 + 4.0 * ci(); var bg = "field"
	if CH is Array and ci() < CH.size():
		bg = str(CH[ci()].get("bg", "field")); p = J.num(CH[ci()].stages[0].p)
	var en = []
	for i in int(TUNE.fight_n): en.append(str(ks[i % ks.size()]))
	var nm = L("%s襲擾%s", "%s襲擾%s") % [foe_name(), tname(str(c.tgt)) if c is Dictionary else ""]
	return {"stage": {"name": nm, "p": maxf(1.0, p * float(TUNE.fight_p)), "en": en, "boss": en[en.size() - 1]}, "bg": bg, "sid": fight_sid()}
static func team_ok() -> bool:
	var s = S()
	if s == null: return false
	for x in J.iter(s.get("team")): if J.t(x): return true
	return false
# 回 "ok"／"none"／"noteam"／"nobattle"
static func start_fight() -> String:
	if not can_fight(): return "none"
	if not team_ok():
		var fx = J.G.get("Fx")
		if fx != null: J.mc(fx, "toast", [L("至少要派一位鬼怪出陣（去「鬼怪」頁揀隊）", "至少要派一位鬼怪出陣（去「鬼怪」頁選隊）")])
		return "noteam"
	var B = J.G.get("Battle")
	if not (B is Dictionary): return "nobattle"
	var r = st(); var s = S(); var c = r.cur
	var ex = fight_stage()
	if not (s.get("cleared") is Dictionary): s["cleared"] = {}
	r["fight"] = {"sid": ex.sid, "had": J.t(s.cleared.get(ex.sid))}
	s.cleared[ex.sid] = true   # 當「再打」：唔出寶箱；結算後清返
	var ui = J.G.get("UI")
	if ui != null: J.mc(ui, "close", [])
	var go = func(): J.mc(B, "start", [-1.0, -1.0, ex])
	var at = tpos(str(c.tgt)); var f0 = ZD.v2(c.get("from", [at.x, at.y - 400.0]))
	var fr = siege_pos()   # 惡鬼而家喺邊就由邊度行埋嚟；已經圍住：由嚟嗰邊退後少少
	if fr.distance_to(at) < 160.0: fr = at + (f0 - at).normalized() * 200.0
	if not load("res://game/zone/zone_battle.gd").start("raid", "", go, {"at": at, "from": fr}): go.call()
	_log("fight", c.tgt)
	return "ok"
static func poll_fight() -> Dictionary:
	var r = _peek()
	if r == null or not (r.get("fight") is Dictionary): return {}
	var B = J.G.get("Battle")
	if not (B is Dictionary): return {}
	if J.str(B.get("sid")) != J.str(r.fight.sid):
		if not J.t(B.get("active")): r["fight"] = null   # 戰鬥畀其他嘢換咗：當冇打過
		return {}
	var res = B.get("result")
	if not (res is Dictionary): return {}
	return resolve_fight(J.t(res.get("win")))
static func resolve_fight(win: bool) -> Dictionary:
	var r = st(); var s = S()
	var f = r.get("fight")
	if not (f is Dictionary): return {}
	r["fight"] = null
	if s.get("cleared") is Dictionary and not J.t(f.get("had")): s.cleared.erase(J.str(f.sid))
	_log("fight_end", win)
	if str(r.ph) == "siege":
		if win: repel("fight")
		else: fail()
	return {"win": win}

# ================= 行動按鈕（act_targets，ctl 線） =================
static func _register() -> void:
	_reg = true
	var AT = load("res://game/outpost/act_targets.gd")
	if AT == null: return
	AT.providers.append(func(game): return act_targets(game))
static func act_targets(_game = null) -> Array:
	if not can_fight(): return []
	var r = st(); var c = r.cur
	var key = str(c.tgt)
	var GP = J.G.get("GP"); var mine = 0; var need = 0
	var ex = fight_stage()
	if GP is Dictionary:
		var team = []
		var s = S()
		for id in J.iter(s.get("team")):
			for g in J.iter(s.get("ghosts")): if g is Dictionary and g.get("id") == id: team.append(g)
		mine = int(J.num(J.mc(GP, "avg", [team])))
		need = int(J.num(J.mc(GP, "stageNeed", [ex.stage, null])))
	return [{"id": "raid", "kind": "raid", "name": L("迎戰%s（%s）", "迎戰%s（%s）") % [foe_name(), tname(key)], "pos": siege_pos(),
		"my_pow": mine, "foe_pow": need, "icon": str((c.ks as Array)[0]) if c.get("ks") is Array and c.ks.size() else "egui",
		"go": func(): return start_fight()}]

# 惡鬼而家喺邊（行緊／圍住）
static func siege_pos() -> Vector2:
	var r = _peek()
	if r == null or not (r.get("cur") is Dictionary): return Vector2.ZERO
	var c = r.cur; var at = tpos(str(c.tgt)) + Vector2(0, 34)
	if str(r.ph) != "siege": return ZD.v2(c.get("from", [at.x, at.y]))
	var k = clampf(J.num(c.get("t", 0)) / maxf(0.1, float(TUNE.walk)), 0.0, 1.0)
	return ZD.v2(c.get("from", [at.x, at.y])).lerp(at, k)

# ================= 畫面用 =================
static func phase() -> String:
	var r = _peek()
	return str(r.get("ph", "idle")) if r != null and J.t(r.get("on")) else "off"
static func cur():
	var r = _peek()
	return r.get("cur") if r != null else null
static func left() -> float:
	var r = _peek()
	if r == null: return 0.0
	if str(r.get("ph")) == "siege" and r.get("cur") is Dictionary: return maxf(0.0, float(TUNE.walk) + float(TUNE.siege) - J.num(r.cur.get("t", 0)))
	return maxf(0.0, J.num(r.get("left", 0)))

static func _save() -> void:
	var f = J.G.get("save")
	if f != null: J.cl(f, null, [])

# ================= 測試／後備 =================
static func t_reset() -> void:
	var s = S()
	if s != null: s.erase("raid")
	LOG.clear(); NEWS.clear(); now_override = 0.0; hold_fn = Callable(); _last_ms = 0
