# [rts] 地圖半即時戰鬥：入口、出擊、結算接駁（全部 static；冇 class_name、冇 autoload：熱更新規矩）
#   const RTS = preload("res://game/rts/rts.gd")
#   設計稿：/home/claude/docs/rts_design.md
#
#   做法：
#     開戰（下令嗰一刻）：照舊叫 Battle.start（宵夜、羈絆、存在感、奪回地盤、遊魂兵、嘍囉全部照舊算），攞走生成嘅單位，即刻將 Battle 關返（active=false）
#       → Battle 冇被佔住，村子同其他系統完全唔受影響，可以同時有幾場。
#     打鬥：rts_sim.gd（地圖平面，規則搬自 battle.gd／rework.gd）。
#     結算（分勝負嗰一刻）：將打完嘅單位交返 Battle，叫原本嘅 Battle.finish（包住佢嘅 rework／presence／chatter／bonds 照跑）
#       → 戰死扣兵、遊魂兵扣人、獎勵、通關、劇情、收編全部係舊程式；再自動撳「繼續」（_on_ok：主線推進、關後劇情）。
#   原型：只對 ON_SIDS 入面嘅主線關卡開（其他戰鬥照舊，方便老闆比較）。
extends RefCounted

const ZD = preload("res://game/zone/zone_data.gd")
const MD = preload("res://game/outpost/mv_data.gd")
const SIM = preload("res://game/rts/rts_sim.gd")

const ON_SIDS := ["1-1"]          # 原型：邊幾場主線關卡用新打法（[] ＝ 全部主線關卡）
const MAX_OPS := 1                # 原型同時最多幾場（設計：2）
const RALLY := 120.0              # 迎戰點：離敵人據點幾遠停低
const CAMP_OFF := Vector2(0, -40)  # 據點比舊迎戰位（大排檔兩檔之間）再近野外門少少：戰場唔好疊住檔口

static var ops: Array = []
static var LOG: Array = []
static var force := -1            # 測試：-1 照 ON_SIDS；0 全關；1 全開
static var _last_f := -1
static var _next_id := 1
static var last_report := {}

# ================= 開關 =================
static func enabled_for(sid: String) -> bool:
	if force == 0 or OS.has_environment("GB_NORTS"): return false
	if not ZD.on(): return false
	if force == 1: return true
	return ON_SIDS.is_empty() or sid in ON_SIDS
static func owns(sid: String) -> bool: return enabled_for(sid)   # zone_view：據點由 rts_view 畫
static func op_for(sid: String):
	for o in ops: if o.sid == sid and o.phase != "done": return o
	return null
static func busy() -> bool:
	for o in ops: if o.phase != "done": return true
	return false
static func L(yue: String, zhs: String) -> String: return str(DB.N(ZD.L(yue, zhs)))
static func _main(): return Engine.get_main_loop().root.get_node_or_null("Main")
static func toast(s: String) -> void:
	var m = _main()
	if m != null and m.has_method("show_toast"): m.show_toast(s)

# ================= 路線（村門內集合點 → 村門 → 大排檔 → 迎戰點） =================
static func gate_pos() -> Vector2: return ZD.v2(ZD.cur().get("village", {}).get("POS", {}).get("gate", [0, 0]))
static func stage_path(at: Vector2) -> PackedVector2Array:
	var o = PackedVector2Array()
	var mk = ZD.cur().get("market", {})
	var por = mk.get("porter", [])
	var g = gate_pos()
	if por.size() >= 3:
		for i in 3: o.append(ZD.v2(por[i]))
	else:
		o.append(g + Vector2(0, 110)); o.append(g); o.append(g + Vector2(0, -60))
	var q = mk.get("q2", [])
	if q.is_empty(): q = mk.get("vol_mid", [])
	var last = o[o.size() - 1]
	for p in q:
		var v = ZD.v2(p)
		if v.distance_to(at) < 150.0: break
		if v.distance_to(at) > last.distance_to(at) + 40.0: continue   # 越行越遠嘅點唔要
		o.append(v); last = v
	var dir = (last - at).normalized() if last.distance_to(at) > 1.0 else Vector2(0, 1)
	o.append(at + dir * RALLY)
	return o

# ================= 敵人據點預覽（未出擊時企喺度） =================
static func camp_preview(tg: Dictionary) -> Array:
	var at: Vector2 = tg.pos + CAMP_OFF
	var pth = stage_path(at)
	var din = (pth[pth.size() - 1] - pth[pth.size() - 2]).normalized()
	var ks = []
	for e in (tg.get("en", []) as Array): ks.append(str(e))
	var bo = str(tg.get("boss")) if tg.get("boss") != null else ""
	var ET = J.G.get("ENEMY_T")
	var pos = SIM.camp_layout(at, ks.size(), din)
	var o = []
	for i in ks.size():
		var nm = str(ET[ks[i]][2]) if ET is Dictionary and ET.has(ks[i]) else ks[i]
		o.append({"side": 1.0, "k": ks[i], "name": nm, "hp": 1.0, "maxhp": 1.0, "st": {}, "boss": ks[i] == bo, "p": pos[i], "post": pos[i],
			"face": -1.0 if din.x >= 0 else 1.0, "preview": true})
	return o

# ================= 出擊 =================
# 主線關卡（zone_data.start_stage 掛鈎）：回 "ok"／"noteam"／"nobattle"／"busy"
static func dispatch_stage(tg: Dictionary) -> String:
	var sid = str(tg.sid)
	var ex = op_for(sid)
	if ex != null: focus(ex); return "ok"
	var B = J.G.get("Battle")
	if not (B is Dictionary): return "nobattle"
	if not ZD.team_ok(): return "noteam"
	if ops.size() >= MAX_OPS or J.t(B.get("active")):
		toast(L("而家打緊另一場，等佢打完先", "現在正在打另一場，等它打完再說")); return "busy"
	var ui = J.G.get("UI")
	if ui != null: J.mc(ui, "close", [])
	var c = float(tg.c); var si = float(tg.s)
	var snap = _start_battle(func(): J.mc(B, "start", [c, si]))
	if snap.is_empty(): return "nobattle"
	var op = SIM.new()
	op.id = _next_id; _next_id += 1
	op.kind = "stage"; op.sid = sid
	op.title = L("主線 %s　%s", "主線 %s　%s") % [sid, str(DB.L(str(tg.get("name", sid))))]
	op.adviser = snap.get("adviser")
	op.set_meta("snap", snap)
	op.setup(snap.units, stage_path(tg.pos + CAMP_OFF), tg.pos + CAMP_OFF, gate_pos())
	ops.append(op)
	LOG.append(["dispatch", sid, _count(op)])
	# 鏡頭：只滑一次去村門，之後交返玩家（唔鎖）
	var m = _main()
	var nv = m.get("village") if m != null else null
	if nv != null and nv.has_method("zone_cam"):
		var cam = nv.zone_cam()
		if not cam.rect().grow(-60).has_point(op.path[0]): cam.glide_to(op.path[0].lerp(op.path[1], 0.5))
	Snd.play("click")
	return "ok"
static func _count(op) -> Dictionary:
	var r = {"hero": 0, "yin": 0, "ml": 0, "foe": 0}
	for u in op.units:
		if J.num(u.side) == 1: r.foe += 1
		elif u.get("ml") != null: r.ml += 1
		elif J.t(u.get("minion")): r.yin += 1
		else: r.hero += 1
	return r
# 借 Battle.start 生成單位（唔開舊畫面），即刻關返
static func _start_battle(cb: Callable) -> Dictionary:
	var G = J.G
	var ob = G.get("__nat_battle"); var osz = G.get("__nat_btSize")
	G["__nat_battle"] = func(_t, _a): return true
	G["__nat_btSize"] = func(_t, _a): return [390.0, 560.0]
	cb.call()
	G["__nat_battle"] = ob; G["__nat_btSize"] = osz
	var B = G.get("Battle")
	if not (B is Dictionary) or not J.t(B.get("active")): return {}
	var snap = {"units": B.units}
	for k in ["stage", "sid", "ci", "si", "bg", "retake", "adviser", "comboSkill", "squads", "ml_ext", "ml_foe", "ml_my", "ml_sq"]: snap[k] = B.get(k)
	B["active"] = false
	var f = G.get("$")
	var be = J.cl(f, null, ["#battle"]) if f != null else null
	if be != null: J.mc(J.gp(be, "classList"), "remove", ["on"])
	var Sd = G.get("Sound")
	if Sd != null: J.mc(Sd, "setMode", ["village"])
	return snap

# ================= 叫回／鏡頭 =================
static func recall(op) -> void:
	if op == null or op.phase in ["back", "done"]: return
	LOG.append(["recall", op.sid, op.phase])
	op.recall()
static func focus(op) -> void:
	var m = _main()
	var nv = m.get("village") if m != null else null
	if nv != null and nv.has_method("zone_cam"): nv.zone_cam().glide_to(op.center())

# ================= 每格（rts_view 叫；同一格只行一次） =================
static func tick(dt: float) -> void:
	var f = Engine.get_process_frames()
	if f == _last_f: return
	_last_f = f
	dt = minf(dt, 0.1)
	for op in ops.duplicate():
		op.step(dt)
		if op.phase == "end" and not op.settled:
			if _settle(op): op.settled = true; op.begin_back()
		if op.phase == "done": ops.erase(op); LOG.append(["done", op.sid])

# ================= 結算：交返 Battle.finish（舊程式） =================
static func _settle(op) -> bool:
	var r = op.result
	if r == null: return false
	if J.t(r.get("none")): return true
	var B = J.G.get("Battle")
	if not (B is Dictionary): return true
	if J.t(B.get("active")): return false   # 舊版戰鬥打緊（例如其他戰鬥未改）：等佢完先
	var snap: Dictionary = op.get_meta("snap")
	for k in snap: B[k] = snap[k]
	B["units"] = op.units; B["result"] = null; B["coinsWon"] = op.coins_won; B["t"] = op.t; B["proj"] = []; B["fx"] = []
	B["advCast"] = null; B["comboCast"] = null; B["active"] = true
	var cl0 = (J.G.S.cleared as Dictionary).duplicate() if J.G.get("S") is Dictionary and J.G.S.get("cleared") is Dictionary else {}
	J.mc(B, "finish", [r.win, r.quit, r.timeout])
	var f = J.G.get("$")
	var box = J.cl(f, null, ["#b-result"]) if f != null else null
	var rep = _report(J.str(J.gp(box, "innerHTML")) if box != null else "")
	rep["win"] = r.win; rep["sid"] = op.sid; rep["first"] = r.win and not J.t(cl0.get(op.sid))
	var okb = J.cl(f, null, ["#b-ok"]) if f != null else null
	if okb != null and J.gp(okb, "onclick") != null: J.cl(J.gp(okb, "onclick"), okb, [])   # 自動「繼續」（_on_ok：主線推進、關後劇情）
	B["active"] = false
	if box != null: J.mc(J.gp(box, "classList"), "remove", ["on"])
	op.set_meta("report", rep)
	last_report = rep
	LOG.append(["settle", op.sid, r.win, rep])
	var lines = [rep.head]
	if rep.reward != "": lines.append(rep.reward)
	for x in rep.lost: lines.append(x)
	toast("　".join(lines))
	return true
static func _strip(h: String) -> String:
	var re = RegEx.new(); re.compile("<[^>]*>")
	return re.sub(h, "", true).strip_edges()
static func _report(html: String) -> Dictionary:
	var o = {"head": "", "reward": "", "quip": "", "lost": []}
	var re = RegEx.new(); re.compile("<h2>(.*?)</h2>")
	var m = re.search(html)
	if m: o.head = _strip(m.get_string(1))
	var rp = RegEx.new(); rp.compile("<p( class=\"([a-z]+)\")?>(.*?)</p>")
	for mm in rp.search_all(html):
		var cls = mm.get_string(2); var tx = _strip(mm.get_string(3))
		if tx == "": continue
		if cls == "quip": o.quip = tx
		elif cls == "lost": o.lost.append(tx)
		elif o.reward == "" and not tx.begins_with("提示"): o.reward = tx
	return o
