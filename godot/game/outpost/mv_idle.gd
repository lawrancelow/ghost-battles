# [idle] Idle Outpost 式升級線：解鎖鏈、累計產量門檻、品質星、領班鬼、舊存檔遷移（全部 static；冇 class_name）
# 用法：const IDL = preload("res://game/outpost/mv_idle.gd")；sim = mv_sim.gd 實例。分析見 IDLE_ANALYSIS.md。
#
# 規則（數值喺 mv_data.gd：MILES、GATE、Q_VAL）：
#   解鎖鏈   chain(ci) = 呢張圖 MAPS.stations 入面唔係隨村台嘅台（照資料次序）；第 1 個開局已開；
#            第 N 個要「第 N−1 個到 Lv10（UNLOCK_LV）」先可以花 unlock_cost 冥幣解鎖。隨村台唔入鏈。
#   累計產量 st[sid].made_n：呢個台做好嘅件數（手做、員工、領班、離線都計；隨村台跟大屋走）。
#            升過里程碑 m 要 made_n ≥ MD.gate(sid, m)；cap_lv = 未夠數嗰個里程碑 − 1（Lv10 之前冇門檻）。
#   品質星   ★ = 過咗幾多個里程碑（MD.stars）；售價 ×(1 + 0.2★)；客人滿意度：每粒星多 1 秒耐性（PAT_STAR）。
#   領班鬼   st[sid].fore = [gid]（一格，唔佔員工位；鬼 post = "mv"）。有領班：
#            ① 呢個台做貨速度 ×FORE_SPD（員工、手做、離線都計）；
#            ② 自動收錢：台面手做好嘅貨自動收去櫃台；③ 自動開工：冇員工都會自己一轉接一轉咁做（等於手做速度，唔使行路）。
#            冇領班：員工照做（冇加速）；冇員工嘅台要玩家撳台開工、撳台收貨。離線：冇員工又冇領班嘅台唔做。
extends RefCounted

const MD = preload("res://game/outpost/mv_data.gd")
const UNLOCK_LV := 10
const FORE_SPD := 1.25
const PAT_STAR := 1.0
const AUTO_DT := 0.5        # 領班自動撳台間隔（秒）

static func chain(ci: int) -> Array:
	var o = []
	for s in MD.map_def(ci).get("stations", []):
		var sid = str(s)
		if MD.D().STATIONS.has(sid) and not MD.is_carry(sid) and not o.has(sid): o.append(sid)
	return o
static func prev_of(ci: int, sid: String) -> String:
	var a = chain(ci); var i = a.find(sid)
	return str(a[i - 1]) if i > 0 else ""
static func next_of(ci: int, sid: String) -> String:
	var a = chain(ci); var i = a.find(sid)
	return str(a[i + 1]) if i >= 0 and i + 1 < a.size() else ""
# 可唔可以解鎖（唔計錢）：[ok, 要邊個台, 要幾級]
static func unlock_req(sim, sid: String) -> Array:
	if sid == "st_bingqi": return load("res://game/militia/ml_data.gd").unlock_req(sim)   # [militia] 兵器檔：要補丁紙衫檔 Lv10
	var p = prev_of(sim.ci(), sid)
	if p == "": return [true, "", 0]
	return [sim.lv(p) >= UNLOCK_LV and sim.unlocked(p), p, UNLOCK_LV]

# ---------- 累計產量 ----------
static func made_n(sim, sid: String) -> float: return J.num(sim.sst(sid).get("made_n"))
static func add_made(sim, sid: String, n: float) -> void:
	var e = sim.sst(sid)
	if sim.st() != null and sim.st().st.has(sid): e["made_n"] = J.num(e.get("made_n")) + n
# 而家最高可以升到幾級（累計產量限住）
static func cap_lv(sim, sid: String) -> int:
	var l = sim.lv(sid); var have = made_n(sim, sid)
	for m in MD.sorted_miles(sid):
		if float(m) > l and have < float(MD.gate(sid, m)): return m - 1
	return MD.max_lv(sid)
# 卡住嘅里程碑：[里程碑等級, 要幾多, 差幾多]；冇卡 = [-1, 0, 0]
static func gate_block(sim, sid: String) -> Array:
	var l = sim.lv(sid); var have = made_n(sim, sid)
	for m in MD.sorted_miles(sid):
		if float(m) > l:
			var g = float(MD.gate(sid, m))
			if have < g: return [m, g, ceil(g - have)]
			return [-1, 0, 0]
	return [-1, 0, 0]

# ---------- 品質星 ----------
static func stars(sim, sid: String) -> int: return MD.stars(sid, sim.lv(sid))
static func mile_txt(sid: String, i: int) -> String:   # 第 i 個里程碑效果
	return MD.S("mk_spd", "生產速度 ×2", "生產速度 ×2") if MD.mile_kind(sid, i) == "spd" else MD.S("mk_val", "售價 ×2", "售價 ×2")

# ---------- 領班鬼 ----------
static func fore_arr(sim, sid: String) -> Array:
	var e = sim.sst(sid)
	if sim.st() == null or not sim.st().st.has(sid): return []
	if not (e.get("fore") is Array): e["fore"] = [null]
	while e.fore.size() < 1: e.fore.append(null)
	return e.fore
static func fore(sim, sid: String):
	var a = fore_arr(sim, sid)
	return a[0] if a.size() > 0 else null
static func has_fore(sim, sid: String) -> bool: return fore(sim, sid) != null
static func eff(sim, sid: String) -> float: return FORE_SPD if has_fore(sim, sid) else 1.0
# 離線／估算用：[等效員工數, 每轉搬貨秒數係咪要計]（只得領班 = 1 個唔使搬貨嘅手做）
static func off_w(sim, sid: String) -> Array:
	var w = sim.nworkers(sid)
	if w > 0: return [float(w) * eff(sim, sid), true]
	if has_fore(sim, sid): return [FORE_SPD, false]
	return [0.0, true]
# 每幀：領班自動收錢＋自動開工
static func step(sim, dt: float) -> void:
	var m = sim.st()
	if m == null: return
	var tmr = sim.idle.get("auto", {})
	for sid in m.st:
		if not has_fore(sim, sid) or not sim.unlocked(sid): continue
		var t = float(tmr.get(sid, 0.0)) - dt
		if t > 0.0: tmr[sid] = t; continue
		tmr[sid] = AUTO_DT
		if sim.war.blocked(sim, sid): continue
		if sim.pile_n(sid) > 0: sim.tap_station(sid)
		if sim.nworkers(sid) == 0 and float(sim.mk.get(sid, -1.0)) < 0.0 and sim.pile_n(sid) < sim.pile_cap(sid):
			if sim.missing(sid).is_empty(): sim.tap_station(sid)
	sim.idle["auto"] = tmr

# ---------- 舊存檔遷移（S.mv.idle_v < 1） ----------
# 舊檔冇 made_n：用 max(呢個台已過里程碑嘅門檻, S.mv.made 記低呢樣貨嘅數) 補返，唔會因為門檻而跌級／卡住；
# 已解鎖嘅台照舊解鎖（就算上一個台未到 Lv10）；領班位補空格。
static func migrate(m: Dictionary) -> void:
	if J.num(m.get("idle_v")) >= 1.0: return
	for sid in m.st:
		var e = m.st[sid]
		if not (e is Dictionary): continue
		if e.get("made_n") == null:
			var l = J.num(e.get("lv", 1)); var g = 0.0
			for mm in MD.sorted_miles(sid): if l >= float(mm): g = maxf(g, float(MD.gate(sid, mm)))
			var key = str(MD.st_def(sid).get("good", ""))
			var made = J.num((m.get("made", {}) as Dictionary).get(key)) if m.get("made") is Dictionary else 0.0
			e["made_n"] = maxf(g, made)
		if not (e.get("fore") is Array): e["fore"] = [null]
	if m.get("carry_st") is Dictionary:
		for sid in m.carry_st:
			var cs = m.carry_st[sid]
			if cs is Dictionary and cs.get("made_n") == null:
				var g2 = 0.0
				for mm in MD.sorted_miles(sid): if J.num(cs.get("lv", 1)) >= float(mm): g2 = maxf(g2, float(MD.gate(sid, mm)))
				cs["made_n"] = g2
	m["idle_v"] = 1.0
