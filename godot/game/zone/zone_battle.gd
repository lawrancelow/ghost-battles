# [mapbattle] 分區大地圖即時戰鬥（MAPBATTLE_CONTRACT.md）：王戰、親自出征攻佔資源區、影響力告急，全部喺大地圖上打，唔切畫面
# 冇 class_name、冇 autoload（熱更新規矩）；const MB = preload("res://game/zone/zone_battle.gd")
#
# 做法：規則／數值／AI 100% 用返現有 Battle（native/battle.gd ＋ rework 包住嘅 hit／start／finish：鬼力、技能、嚇氣、怕性、失神、連嚇、
#   自動、加速、撤退、勝負、獎勵、主線劇情、收編全部照舊）。只係：
#   1. 開戰時暫時換走 __nat_battle（唔開 BtRun 舊戰鬥畫面），戰場大細固定 390 × H；
#   2. Battle 座標（x 16–374、lane）線性映射去分區地圖世界座標：world = O + (m·(x − 195)·S, (uy − H/2)·S)（m＝左右鏡像）；
#   3. 角色用 BtChar（同舊戰鬥一樣嘅 GPU 網格＋出招／受擊／嚇彈起／腳軟／倒下動作），放喺村子 world 節點入面，跟鏡頭縮放；
#   4. 血條、傷害數字、嚇法名、失神、連嚇字畫喺世界層但用畫面 px（最細 14px）；火花、刀光、飛彈、蓄力喺戰場座標畫；
#   5. 包住 Battle.update：行軍期間唔行模擬（隊伍由出村門／門洞行出去、王由柵欄外行返戰場），開打先交返；戰鬥中都照叫 Village.update（村子唔凍結）；
#   6. 底部卡片列（嚇氣、撳放、對路／唔怕提示、失神→連嚇提示）＋自動／加速／撤退／返戰場掣；鏡頭跟戰場（拖走就停跟）；
#   7. 結算：同舊戰鬥一樣嘅 #b-result 結算框（NvDomCard）；撳「回村子／繼續」＝舊 _on_ok（主線劇情、收編照觸發）；
#      之後隊伍行返村；輸／撤退：王行去柵欄／野外門外面叫囂（zone_taunt.gd）。
# 第 5、6 關（冇分區）／GB_NOMAPBATTLE=1：start() 回 false，照用舊戰鬥畫面。
extends Node

const ZD = preload("res://game/zone/zone_data.gd")
const TA = preload("res://game/zone/zone_taunt.gd")
const MD = preload("res://game/outpost/mv_data.gd")
const H := 560.0              # 戰場高（battle 單位）：lane 間距 = H × 0.1（同舊戰鬥畫面差唔多）
const S_MAX := 1.0            # battle 單位 → 世界單位；開戰鏡頭拉近到角色大細同舊戰鬥畫面差唔多
const MARCH := 150.0          # 行軍速度（世界單位／秒，× 加速）
const GAP := 24.0             # 行軍隊形間距
const PANEL_H := 156.0        # 底部卡片列高（畫面 px）
const CARD_H := 92.0

static var cur = null
static var LOG: Array = []    # 測試用：[[事件, 資料], …]
static var force_off := false

var kind := ""                # boss／cap／raid
var zid := ""
var bid := ""
var tkey := ""                # 叫囂鍵（zone_taunt）
var raid_at = null            # [raid] 村子被惡鬼襲擾：戰場對準目標（Vector2）；null＝照舊喺大排檔
var raid_from = null          # [raid] 惡鬼由邊度行過嚟
var ci := 0
var B: Dictionary
var units_ref = null
var nv = null
var main = null
var O := Vector2.ZERO
var S := 0.75
var m := 1.0
var field := Rect2()
var phase := "march"          # march → fight → result → back → done
var path := PackedVector2Array()
var mv := {}                  # unit 序號 → {pts, s, len, hide, done, face}
var chars: Array = []
var root: Node2D
var layer: Node2D
var under: PtDraw
var fxd: PtDraw
var txt: PtDraw
var ui: Control
var card_list: Array = []
var title_l: Label
var time_l: Label
var hint_l: Label
var back_b: Button
var auto_b: Button
var speed_b: Button
var quit_b: Button
var follow := true
var _quit_arm := 0.0
var _result_shown := false
var _orig_update = null
var _my_update = null
var _t := 0.0
var _march_t := 0.0
var _back_t := 0.0
var _sh := Vector2.ZERO
var _said_result := false
var _prof := []
var _pose := {}               # 今幀每隻嘅姿勢（BtChar.sync 計咗，畫字唔使再計）
var _sort_t := 0

# ================= 入口 =================
static func _main(): return Engine.get_main_loop().root.get_node_or_null("Main")
static func village():
	var mm = _main()
	if mm == null: return null
	var v = mm.get("village")
	return v if v is Control and v.is_inside_tree() and v.has_method("zone_cam") else null
static func usable() -> bool:
	return not force_off and not OS.has_environment("GB_NOMAPBATTLE") and ZD.on() and village() != null
static func busy() -> bool: return cur != null and is_instance_valid(cur) and cur.phase != "done"
static func fighting() -> bool: return busy() and cur.phase in ["march", "fight", "result"]
static func on_zone(id: String) -> bool: return (busy() and cur.zid == id and cur.kind != "raid" and cur.kind != "stage") or load("res://game/rts/rts.gd").on_zone(id)   # [rts] 王／親征打緊：王唔畫喺原位、黑霧散開
# kind：boss／cap／raid；cb：真正開戰（叫 Battle.start）；回 false＝唔用大地圖（照舊畫面，cb 未叫）
static func start(k: String, id: String, cb: Callable, opt := {}) -> bool:
	if load("res://game/rts/rts.gd").start_generic(k, id, cb, opt): return true   # [rts] 全面鋪開：改用地圖半即時戰鬥（舊畫面只喺 GB_NORTS／測試 force=0 先用）
	if not usable(): return false
	if busy(): cur._teardown()
	var G = J.G
	var ob = G.get("__nat_battle"); var osz = G.get("__nat_btSize")
	G["__nat_battle"] = func(_t, _a): return true
	G["__nat_btSize"] = func(_t, _a): return [390.0, H]
	cb.call()
	G["__nat_battle"] = ob; G["__nat_btSize"] = osz
	var Bt = G.get("Battle")
	if not (Bt is Dictionary) or not J.t(Bt.get("active")): return true
	var f = G.get("$")
	var be = J.cl(f, null, ["#battle"]) if f != null else null
	if be != null: J.mc(J.gp(be, "classList"), "remove", ["on"])   # 舊 DOM 戰鬥畫面唔出（結算框由 NvDomCard 原生畫）
	var n = load("res://game/zone/zone_battle.gd").new(); n.name = "MapBattle"
	n.kind = k; n.zid = id; n.bid = str(opt.get("bid", "")); n.B = Bt
	if opt.get("at") is Vector2: n.raid_at = opt.at; n.raid_from = opt.get("from", opt.at)   # [raid]
	cur = n
	var v = village()
	v.add_child(n)
	n._setup(v)
	LOG.append(["start", [k, id, n.bid]])
	return true

# ================= 座標 =================
func uy_b(u) -> float: return H * 0.5 + J.num(u.get("lane", 0)) * H * 0.1
func b2w(bx: float, by: float) -> Vector2: return O + Vector2(m * (bx - 195.0) * S, (by - H * 0.5) * S)
func w2b(p: Vector2) -> Vector2: return Vector2(195.0 + (p.x - O.x) / (m * S), H * 0.5 + (p.y - O.y) / S)
func upos(u) -> Vector2: return b2w(J.num(u.x), uy_b(u))
func set_upos(u, p: Vector2) -> void:
	var b = w2b(p)
	u["x"] = b.x; u["lane"] = (b.y - H * 0.5) / (H * 0.1)
func field_center() -> Vector2: return field.get_center()

# ================= 開局 =================
func _setup(v) -> void:
	nv = v; main = _main(); ci = ZD.ci()
	units_ref = B.units
	B["H"] = H
	PtChar.setup_static()
	_geometry()
	_build_nodes()
	_build_ui()
	_plan_march()
	_hook_update()
	# 鏡頭：拉近少少、對住隊伍
	var c = nv.zone_cam()
	c.z = clampf(nv.size.x / 380.0 * (S_MAX / S if S < S_MAX else 1.0), c.z_min(), c.z_max()); c.clamp_all()   # 角色畫面大細 ≈ 舊戰鬥（1.32 × 畫面闊 ÷ 390）
	follow = true
	if tkey != "" and TA.on(tkey) and kind == "boss": TA.say(tkey, "rematch", Vector2.ZERO, _boss_pos_fn())
	if tkey != "": TA.hide_keys[tkey] = true
	set_process(true)

func _boss_unit():
	for u in B.units: if J.num(u.side) == 1 and J.t(u.get("boss")): return u
	for u in B.units: if J.num(u.side) == 1: return u
	return null
func _boss_pos_fn() -> Callable:
	var me = weakref(self); var key = tkey
	return func():
		var s = me.get_ref()
		if s == null or s.phase == "done": return TA.spot(key) if key != "" and TA.on(key) else Vector2(-9999, -9999)
		var u = s._boss_unit()
		return s.upos(u) if u != null else s.field_center()

func _geometry() -> void:
	var z = ZD.zone(zid) if zid != "" else {}
	var r := Rect2()
	var anchor := Vector2.ZERO
	m = 1.0
	if kind == "boss":
		r = ZD.rect(z.rect)
		anchor = ZD.v2(z.get("boss_at", [r.get_center().x, r.get_center().y]))
		var g = TA.gate_of(zid)
		if g[0].x > anchor.x + 30.0: m = -1.0   # 門喺王右邊：隊伍由右邊入（鏡像）
		tkey = TA.boss_key(ZD.ci(), bid) if bid != "" else ""
	elif kind == "cap":
		r = ZD.rect(z.rect)
		anchor = r.get_center() + Vector2(0, -30)
		if z.get("door") is Dictionary:
			var o = ZD.v2(z.door.out)
			if o.x > r.get_center().x + 20.0: m = -1.0
		tkey = TA.cap_key(ZD.ci(), zid)
	else:   # raid：喺大排檔近野外門迎戰；[outgate] stage（主線關卡）都喺度打
		r = ZD.zrect("market")
		var wz = ZD.of_type("wild")
		anchor = ZD.front_anchor()
		zid = str(wz[0].id) if wz.size() else ""
		tkey = TA.raid_key(ZD.ci()) if kind == "raid" else ""
		if raid_at != null:   # [raid] 落點：目標建築／大排檔／資源區（村口、資源區都得）
			anchor = raid_at
			var az = ZD.zone_at(anchor)
			r = ZD.zrect(az) if az != "" else Rect2(anchor - Vector2(240, 260), Vector2(480, 520))
	S = clampf((r.size.x - 16.0) / 360.0, 0.5, S_MAX)
	# 王對準 anchor（王嘅 battle 起始位）
	var bu = _boss_unit()
	if bu != null:
		O = anchor - Vector2(m * (J.num(bu.x) - 195.0) * S, (uy_b(bu) - H * 0.5) * S)
		if kind != "boss": O = anchor - Vector2(0, 50.0 * S)   # 資源區／告急：戰場中心對準 anchor
	else: O = anchor
	# 戰場（世界）：闊 360·S、由 lane 0 頂（頭）到 lane 4 腳
	var hx = 180.0 * S; var top = 105.0 * S; var bot = 255.0 * S
	var inner = r.grow(-8.0)
	if inner.size.x > hx * 2: O.x = clampf(O.x, inner.position.x + hx, inner.end.x - hx)
	else: O.x = inner.get_center().x
	if inner.size.y > top + bot: O.y = clampf(O.y, inner.position.y + top, inner.end.y - bot)
	field = Rect2(O.x - hx, O.y - top, hx * 2, top + bot)

func _build_nodes() -> void:
	root = Node2D.new(); root.name = "MapBattleWorld"
	nv.world.add_child(root)
	var zo = nv.get("zone_over")
	if zo is Node and zo.get_parent() == nv.world: nv.world.move_child(root, zo.get_index() + 1)   # 區名牌／黑霧之上，頂層 UI 之下
	layer = Node2D.new(); root.add_child(layer)
	under = PtDraw.new(); under.tag = "mb_under"; under.fn = _draw_under; layer.add_child(under)
	for i in B.units.size():
		var c = BtChar.new(B.units[i], B); c.set_meta("ix", i); layer.add_child(c); chars.append(c)
	fxd = PtDraw.new(); fxd.tag = "mb_fx"; fxd.fn = _draw_fx; layer.add_child(fxd)
	txt = PtDraw.new(); txt.tag = "mb_txt"; txt.fn = _draw_txt; root.add_child(txt)

# ================= 行軍路線 =================
func _village_cross() -> Vector2:
	var mains = []
	for p in ZD.cur().get("paths", []): if str(p.get("k")) == "main": mains.append(p.pts)
	if mains.size() >= 2:
		var best = INF; var bp = Vector2.ZERO
		for a in mains[0]:
			for b in mains[1]:
				var d = ZD.v2(a).distance_to(ZD.v2(b))
				if d < best: best = d; bp = (ZD.v2(a) + ZD.v2(b)) / 2.0
		return bp
	return ZD.zrect("village").get_center()
func _gate_path(wzid: String, into_wild: bool) -> PackedVector2Array:
	var o = PackedVector2Array()
	var L = MD.layout(ZD.ci())
	for q in L.get("porter", []): o.append(MD.v2(q))
	if o.is_empty(): o.append(_village_cross())
	var g = TA.gate_of(wzid); var gp: Vector2 = g[0]; var dir = float(g[1])
	var end = o[o.size() - 1]
	var mids = []
	for q in L.get("vol_mid", []):
		var p = MD.v2(q)
		if p.distance_to(gp) < end.distance_to(gp): mids.append(p)
	mids.sort_custom(func(a, b): return a.distance_to(end) < b.distance_to(end))
	for p in mids: o.append(p)
	o.append(gp + Vector2(0, dir * 34.0))
	if into_wild:
		o.append(gp)
		var wr = ZD.zrect(wzid)   # 入到野外區（門同區邊之間可能有一段空位）
		o.append(Vector2(gp.x, minf(gp.y - 46.0, wr.end.y - 30.0) if dir > 0 else maxf(gp.y + 46.0, wr.position.y + 30.0)))
	return o
func _plan_march() -> void:
	mv.clear()
	var tail = PackedVector2Array()
	if kind == "cap":
		var z = ZD.zone(zid)
		path = PackedVector2Array([ZD.v2(ZD.cur().village.get("hero", [0, 0])), _village_cross()])
		if z.get("door") is Dictionary: path.append(ZD.v2(z.door.in)); path.append(ZD.v2(z.door.out))
	else:
		path = _gate_path(zid, kind == "boss")
	if raid_at != null:   # [raid] 隊伍由主角身邊行去目標
		var VV = J.G.get("Village"); var hp = raid_at + Vector2(0, 160)
		if VV is Dictionary and VV.get("hero") is Dictionary: hp = Vector2(J.num(VV.hero.x), J.num(VV.hero.y))
		path = PackedVector2Array([hp, raid_at + Vector2(0, 40)])
	var order = 0
	for i in B.units.size():
		var u = B.units[i]
		var goal = upos(u)
		if J.num(u.side) == 0:
			var pts = path.duplicate(); pts.append(goal)
			var d = {"pts": pts, "s": -order * GAP, "len": MD.poly_len(pts)}
			mv[i] = d; order += 1
			set_upos(u, pts[0])
		else:
			var src = PackedVector2Array()
			if kind == "boss" and tkey != "" and TA.on(tkey) and J.t(u.get("boss")): src = PackedVector2Array([TA.spot(tkey), goal])
			elif raid_at != null:   # [raid] 惡鬼由邊界行埋嚟
				src = PackedVector2Array([raid_from + Vector2((i % 3 - 1) * 26.0, 0), goal])
			elif kind == "raid" or kind == "stage":
				var g = TA.gate_of(zid)
				src = PackedVector2Array([g[0] + Vector2((i % 3 - 1) * 26.0, -float(g[1]) * 60.0), g[0], goal])
			if src.size():
				var d2 = {"pts": src, "s": -(i % 4) * 10.0, "len": MD.poly_len(src)}
				mv[i] = d2; set_upos(u, src[0])
	_march_t = 0.0
	if mv.is_empty(): phase = "fight"

func _step_march(dt: float) -> bool:
	var all_done = true
	var spd = MARCH * maxf(1.0, J.num(B.get("speed", 1)))
	for i in mv:
		var d = mv[i]; var u = B.units[i]
		if d.get("done", false): continue
		var p0 = upos(u)
		d.s = float(d.s) + spd * dt
		if d.s >= d.len: d.s = d.len; d["done"] = true
		else: all_done = false
		var p = MD.poly_at(d.pts, maxf(0.0, d.s))
		set_upos(u, p)
		u["walking"] = not d.get("done", false) and d.s > 0.0
		d["hide"] = d.s < 0.0
		var dx = w2b(p).x - w2b(p0).x
		if absf(dx) > 0.05: d["face"] = signf(dx)
	_march_t += dt
	return all_done or _march_t > 40.0

# 行返村（結算之後；Battle 已經唔 active，純畫面）
func _plan_back() -> void:
	mv.clear()
	var home = path.duplicate(); home.reverse()
	var order = 0
	for i in B.units.size():
		var u = B.units[i]
		if J.num(u.side) == 0:
			if J.t(u.get("minion")) and J.num(u.hp) <= 0: continue
			if J.num(u.hp) <= 0:   # 輸咗嘅鬼：企返起身行返去（純畫面）
				u["hp"] = maxf(1.0, J.num(u.maxhp) * 0.05); u["deadT"] = 0.0
			u.st.clear(); u["anim"] = null; u["casting"] = null; u["kbT"] = null; u["hurtT"] = 0.0
			var pts = PackedVector2Array([upos(u)]); pts.append_array(home)
			mv[i] = {"pts": pts, "s": -order * 10.0, "len": MD.poly_len(pts), "back": true}
			order += 1
		elif J.num(u.hp) > 0 and J.t(u.get("boss")) and tkey != "" and TA.on(tkey) and kind != "raid":
			u.st.clear(); u["anim"] = null; u["casting"] = null
			mv[i] = {"pts": PackedVector2Array([upos(u), TA.spot(tkey)]), "s": 0.0, "len": upos(u).distance_to(TA.spot(tkey)), "boss": true}
	_back_t = 0.0

func _step_back(dt: float) -> bool:
	var all_done = true
	var spd = MARCH * 1.3 * maxf(1.0, J.num(B.get("speed", 1)))
	for i in mv:
		var d = mv[i]; var u = B.units[i]
		if d.get("done", false): continue
		var p0 = upos(u)
		d.s = float(d.s) + spd * dt * (0.6 if d.get("boss", false) else 1.0)
		if d.s >= d.len: d.s = d.len; d["done"] = true
		else: all_done = false
		var p = MD.poly_at(d.pts, maxf(0.0, d.s)); set_upos(u, p)
		u["walking"] = not d.get("done", false)
		var dx = w2b(p).x - w2b(p0).x
		if absf(dx) > 0.05: d["face"] = signf(dx)
		if d.get("done", false) and not d.get("boss", false): d["hide"] = true
	_back_t += dt
	# 敵人（打贏咗）淡出；王（叫囂）到咗門口就交俾 zone_taunt 畫
	return all_done or _back_t > 30.0

# ================= 包住 Battle.update =================
func _hook_update() -> void:
	_orig_update = B.get("update")
	var me = weakref(self)
	var ou = _orig_update
	var bb = B
	_my_update = func(t, a):
		var s = me.get_ref()
		var dt = J.num(J.arg(a, 0))
		if s != null and s.phase != "done" and is_same(bb.get("units"), s.units_ref):
			var V = J.G.get("Village")
			if V is Dictionary: J.mc(V, "update", [dt])   # 村子照行（唔凍結）
			if s.phase == "march": return null   # 行軍：模擬未開始
			var t0 = Time.get_ticks_usec()
			var r = J.cl(ou, t, a)
			prof_us += Time.get_ticks_usec() - t0
			PROF["sim"] = PROF.get("sim", 0) + Time.get_ticks_usec() - t0
			return r
		return J.cl(ou, t, a)
	B["update"] = _my_update
func _unhook() -> void:
	if _my_update != null and is_same(B.get("update"), _my_update): B["update"] = _orig_update
	_my_update = null

# ================= 每格 =================
static var prof_us := 0   # 測試用：模擬（包住嘅 update）＋同步嘅累計 µs
static var prof_n := 0
static var PROF := {}
func _process(dt: float) -> void:
	if phase == "done": return
	var _t0 = Time.get_ticks_usec()
	_t += dt
	if not is_same(B.get("units"), units_ref):   # 其他地方開咗另一場戰鬥
		_teardown(); return
	B["H"] = H
	match phase:
		"march":
			if B.get("result") != null: _enter_result()
			elif _step_march(dt):
				for i in mv: set_upos(B.units[i], mv[i].pts[mv[i].pts.size() - 1]); B.units[i]["walking"] = false
				mv.clear(); phase = "fight"; LOG.append(["fight", B.t])
		"fight":
			if B.get("result") != null: _enter_result()
		"result":
			if not J.t(B.get("active")):
				_unhook(); _plan_back(); phase = "back"; LOG.append(["back", kind])
				var zc = nv.zone_cam(); zc.tgt = null   # 鏡頭交返玩家
		"back":
			if _step_back(dt): _teardown(); return
	var _t1 = Time.get_ticks_usec()
	_sync_world()
	var _t2 = Time.get_ticks_usec()
	_update_ui(dt)
	_camera(dt)
	var _t3 = Time.get_ticks_usec()
	prof_us += _t3 - _t0; prof_n += 1
	PROF["sync"] = PROF.get("sync", 0) + _t2 - _t1; PROF["ui"] = PROF.get("ui", 0) + _t3 - _t2

func _enter_result() -> void:
	if phase == "result": return
	phase = "result"
	_quit_arm = 0.0; quit_b.text = L("撤退")
	mv.clear()
	for u in B.units: u["walking"] = false
	var win = J.t(B.result.get("win"))
	LOG.append(["result", win])
	if not _said_result and tkey != "":
		_said_result = true
		var fn = _boss_pos_fn()
		if win:
			if kind != "raid": TA.say(tkey, "defeat", Vector2.ZERO, fn)
			if TA.on(tkey): TA.clear(tkey)
		else:
			if kind == "boss": TA.set_on(tkey, "boss", zid)
			elif kind == "cap": TA.set_on(tkey, "cap", zid)
			TA.say(tkey, "lose", Vector2.ZERO, fn)
	if not _result_shown:
		_result_shown = true
		if not OS.has_environment("GB_RESDOM"): _result_card()

func _result_card() -> void:
	var f = J.G.get("$")
	var rb = J.cl(f, null, ["#b-result"]) if f != null else null
	if rb == null or main == null: return
	var c = NvDomCard.new(); c.name = "MapBattleResult"
	main.add_child(c)
	var dom = main.get("dom")
	if dom: main.move_child(c, dom.get_index() + 1)
	c.backdrop = 0.3
	c.alive_fn = func(): return rb.classList.d.has("on")
	c.open(rb)

func _teardown() -> void:
	if phase == "done": return
	phase = "done"
	_unhook()
	if tkey != "": TA.hide_keys.erase(tkey)
	if root != null and is_instance_valid(root): root.queue_free()
	if ui != null and is_instance_valid(ui): ui.queue_free()
	if cur == self: cur = null
	LOG.append(["done", kind])
	queue_free()

# ---------------- 角色同步 ----------------
func _sync_world() -> void:
	var A = J.num(B.get("shakeA", 0)) if phase in ["fight", "result"] else 0.0
	_sh = Vector2((randf() - 0.5) * 2 * A, (randf() - 0.5) * 1.2 * A) * 0.5 if A > 0 else Vector2.ZERO
	var org = O - Vector2(m * 195.0 * S, H * 0.5 * S) + _sh * S
	layer.transform = Transform2D(Vector2(m * S, 0), Vector2(0, S), org)
	var gm = nv.get("ysort").modulate if nv.get("ysort") is CanvasItem else Color.WHITE
	if layer.modulate != gm: layer.modulate = gm
	var T = J.num(B.get("t", 0)) if phase in ["fight", "result"] else _t
	var ord = chars
	_sort_t += 1
	if _sort_t % 4 == 0:   # 前後排（按 lane）：每 4 格排一次
		ord = chars.duplicate()
		ord.sort_custom(func(a, b): return J.num(a.u.get("lane", 0)) < J.num(b.u.get("lane", 0)))
		chars = ord
	for i in ord.size():
		var c = ord[i]
		if c.get_index() != i + 1: layer.move_child(c, i + 1)   # 0 係 under
		c.sync(T)
		var cix = int(c.get_meta("ix"))
		_pose[cix] = c.st.get("P") if c.st is Dictionary else null
		var d = mv.get(cix, {})
		if d.get("hide", false): c.visible = false
		# 行緊路：面向行嘅方向（鏡像節點，以 u.x 做軸）
		var face = float(d.get("face", 0.0))
		var want = 1.0 if J.num(c.u.side) == 0 else -1.0
		if face != 0.0 and signf(face) != want and c.u.get("walking", false):
			var x = J.num(c.u.x)
			c.transform = Transform2D(Vector2(-1, 0), Vector2(0, 1), Vector2(2 * x, 0))
		else: c.transform = Transform2D.IDENTITY
	under.queue_redraw(); fxd.queue_redraw(); txt.queue_redraw()

func _draw_under(n: CanvasItem) -> void:
	# 戰場地面：淡淡一圈（知道邊度係戰場）；慢鏡：再暗少少
	if phase in ["march", "fight", "result"]:
		n.draw_colored_polygon(_ell(210, 160), Color(0.125, 0.03, 0.07, 0.16 if phase != "march" else 0.08))
		var slowT = J.num(B.get("slowT", 0))
		if slowT > 0: n.draw_colored_polygon(_ell(235, 185), Color(0.03, 0.016, 0.08, minf(0.3, slowT * 2.0)))
	var ctx = null
	for f in B.get("fx", []):
		if J.str(f.get("kind", "")) == "dust":
			if ctx == null: ctx = Ctx.new(n)
			BtDraw.draw_dust(ctx, f)

var _ellc := {}
func _ell(rx: float, ry: float) -> PackedVector2Array:
	var k = "%d,%d" % [rx, ry]
	if not _ellc.has(k):
		var o = PackedVector2Array(); var c = Vector2(195, H * 0.7)
		for i in 40: o.append(c + Vector2(cos(i * TAU / 40) * rx, sin(i * TAU / 40) * ry))
		_ellc[k] = o
	return _ellc[k]
func _draw_fx(n: CanvasItem) -> void:
	if not (phase in ["fight", "result"]): return
	var ctx = Ctx.new(n)
	var T = J.num(B.get("t", 0))
	var ac = B.get("advCast")
	if ac is Dictionary:   # 軍師（唔上場）：喺隊伍後面蓄力
		var hx = 60.0
		BtDraw.draw_charge(ctx, T, hx, H * 0.5 - 10, 1, J.num(ac.t) / J.num(ac.dur), Color("#c8ffb0"), true)
	var cc2 = B.get("comboCast")
	if cc2 is Dictionary:
		var c = B.comboSkill; var p = J.num(cc2.t) / J.num(cc2.dur)
		for u in [c.a, c.b]:
			if J.num(u.hp) > 0: BtDraw.draw_charge(ctx, T, J.num(u.x), uy_b(u) - 28 * BtDraw.scale_of(u), BtDraw.scale_of(u), p, Color("#ffb0ff"), true)
	for p in B.get("proj", []): BtDraw.draw_proj(ctx, p)
	for f in B.get("fx", []):
		var kd = J.str(f.get("kind", ""))
		if kd == "spark": BtDraw.draw_spark(ctx, f)
		elif kd == "slash": BtDraw.draw_slash(ctx, f)
		elif kd == "ring":
			var p = J.num(f.t) / J.num(f.life); ctx.save(); ctx.globalAlpha = 1 - p; ctx.strokeStyle = f.col; ctx.lineWidth = 3 * (1 - p) + 1
			ctx.beginPath(); ctx.ellipse(J.num(f.x), J.num(f.y), 14 + p * 26, (14 + p * 26) * 0.5, 0, 0, TAU); ctx.stroke(); ctx.restore()

# ---------------- 血條、字（畫面 px，最細 14） ----------------
const DARK := Color(10 / 255.0, 6 / 255.0, 20 / 255.0, 0.92)
static var _sb := {}
static func _box(c: Color, r: float) -> StyleBoxFlat:
	var key = "%s|%s" % [c.to_html(), r]
	if not _sb.has(key):
		var b = StyleBoxFlat.new(); b.bg_color = c; b.set_corner_radius_all(int(round(r))); b.anti_aliasing = false; _sb[key] = b
	return _sb[key]
func _zs() -> float: return maxf(0.05, float(nv.sc))
func _at(n: CanvasItem, wp: Vector2, sc := 1.0) -> void:
	var z = _zs()
	n.draw_set_transform(wp, 0, Vector2(sc / z, sc / z))
func _str(n: CanvasItem, f: Font, s: String, x: float, y: float, px: int, col: Color, ow := 4) -> void:
	var w = f.get_string_size(s, HORIZONTAL_ALIGNMENT_LEFT, -1, px).x
	if ow > 0: n.draw_string_outline(f, Vector2(x - w / 2, y), s, HORIZONTAL_ALIGNMENT_LEFT, -1, px, ow, DARK)
	n.draw_string(f, Vector2(x - w / 2, y), s, HORIZONTAL_ALIGNMENT_LEFT, -1, px, col)
func _draw_txt(n: CanvasItem) -> void:
	var fb = UIKit.font("sans", 900)
	var z = _zs()
	var T = J.num(B.get("t", 0))
	for ix in B.units.size():
		var u = B.units[ix]
		var hp = J.num(u.hp)
		if hp <= 0: continue
		if mv.has(ix) and mv[ix].get("hide", false): continue
		var mn = J.t(u.get("minion")); var bo = J.t(u.get("boss")); var side1 = J.num(u.side) != 0
		var P = _pose.get(ix)
		if P == null: P = BtDraw.pose_of(B, u)
		var head = (36.0 if mn else (92.0 if bo else 72.0)) * S * BtDraw.scale_of(u) / (0.75 if mn else (1.7 if bo else 1.32))
		var wp = b2w(J.num(u.x) + P.ox * 0.4, uy_b(u)) + Vector2(0, -head - 6.0 * S)
		_at(n, wp)
		if u.get("ml") != null: load("res://game/militia/ml_art.gd").tag(n, wp, 1.0 / z, int(J.num(u.ml)))   # [militia] 遊魂兵頭頂兵器牌
		var bw = 26.0 if mn else (60.0 if bo else 42.0)
		if mn and hp >= J.num(u.maxhp) - 0.01: continue   # 陰兵滿血唔出血條（戰場唔好太亂）
		n.draw_style_box(_box(Color(0, 0, 0, 0.65), 2), Rect2(-bw / 2 - 1, -1, bw + 2, 7))
		var fr = clampf(hp / maxf(1.0, J.num(u.maxhp)), 0, 1)
		if fr * bw > 0.3: n.draw_style_box(_box(Color("#e84a5f") if side1 else Color("#4ade80"), 2), Rect2(-bw / 2, 0, bw * fr, 5))
		var en = J.num(u.get("energy", 0))
		if u.get("sk") != null and not mn and phase != "back" and en > 0.5:
			n.draw_style_box(_box(Color("#ffd84a") if en >= 100 else Color("#7dd3fc"), 1), Rect2(-bw / 2, 6, bw * clampf(en / 100.0, 0, 1), 3))
		var yy = -6.0
		if bo and phase != "back": _str(n, fb, DB.L(J.str(u.name)), 0, yy, 14, Color("#ffd0d8")); yy -= 17.0
		if phase in ["fight", "result"]:
			var st: Dictionary = u.st
			var air = J.num(st.get("air", 0)) > 0; var down = J.num(st.get("down", 0)) > 0
			if air or down: _str(n, fb, J.str(DB.L("嚇彈起" if air else "腳軟")), 0, yy, 14, Color("#99ffff") if air else Color("#ffcc99")); yy -= 17.0
			var ft = u.get("fearT")
			if side1 and ft is Dictionary and J.num(ft.get("until", 0)) > T:
				var tx = J.str(DB.L("失神")) + "・" + J.str(DB.L(J.str(J.mc(J.G.get("Rework"), "word", [ft.get("t")]))))
				_str(n, fb, tx, 0, yy, 15, Color("#e6c4ff"))
	n.draw_set_transform_matrix(Transform2D.IDENTITY)
	if not (phase in ["fight", "result"]): return
	for f in B.get("fx", []):
		var kd = J.str(f.get("kind", ""))
		if kd in ["spark", "slash", "ring", "dust"]: continue
		_fx_text(n, fb, f)
	var combo = J.num(B.get("combo", 0))
	if J.num(B.get("comboT", 0)) > 0 and combo > 0:
		var k = 1 + J.num(B.get("comboPop", 0)) * 0.6
		_at(n, Vector2(field.end.x - 10, field.end.y - 10), k)
		_str(n, fb, "COMBO %d" % int(combo), -40, 0, 18, Color("#ffd84a"), 5)
		n.draw_set_transform_matrix(Transform2D.IDENTITY)
func _fx_text(n: CanvasItem, fb: Font, f: Dictionary) -> void:
	var t = J.num(f.t); var life = J.num(f.life)
	var a = maxf(0.0, 1 - (t - life * 0.7) / (life * 0.3)) if t > life * 0.7 else 1.0
	var pop = 0.35 + (t / 0.1) * 1.05 if t < 0.1 else (1.4 - (t - 0.1) / 0.1 * 0.4 if t < 0.2 else 1.0)
	var x = J.num(f.x); var y = J.num(f.y)
	var center = J.t(f.get("center")); var big = J.t(f.get("big"))
	if J.str(f.get("kind", "")) == "num": x += J.num(f.get("vx", 0)) * t; y += -120 * t + 0.5 * 330 * t * t
	elif not center: y -= t * 30
	var px = 24 if center else (17 if J.t(f.get("skill")) else (20 if big else 15))
	var wp = b2w(x, y) if f.get("x") != null else field_center()
	if center: wp = Vector2(field.get_center().x, field.position.y + 4.0 + 0.0)
	_at(n, wp, pop)
	var col = Ctx.col(f.col) if f.get("col") != null else Color.WHITE
	col.a *= a
	var dk = DARK; dk.a *= a
	var s = J.str(DB.L(J.str(f.text)))
	var w = fb.get_string_size(s, HORIZONTAL_ALIGNMENT_LEFT, -1, px).x
	n.draw_string_outline(fb, Vector2(-w / 2, 0), s, HORIZONTAL_ALIGNMENT_LEFT, -1, px, 6 if big or center else 5, dk)
	n.draw_string(fb, Vector2(-w / 2, 0), s, HORIZONTAL_ALIGNMENT_LEFT, -1, px, col)
	n.draw_set_transform_matrix(Transform2D.IDENTITY)

# ================= 鏡頭 =================
func _focus() -> Vector2:
	if phase == "march":
		var sum = Vector2.ZERO; var n = 0
		for i in mv:
			var d = mv[i]
			if d.get("hide", false) or J.num(B.units[i].side) != 0: continue
			sum += upos(B.units[i]); n += 1
		if n > 0: return sum / n
	return field_center()
func _camera(_dt: float) -> void:
	var c = nv.zone_cam()
	if c.dragging or c._pinch != null:
		if follow: follow = false; LOG.append(["unfollow", null])
	if back_b != null: back_b.visible = not follow and phase != "back"
	if not follow or phase == "back": return   # 收咗場：鏡頭交返玩家（隊伍自己行返村）
	var F = _focus()
	var em = nv._zone_em() if nv.has_method("_zone_em") else null
	var top = float(em.sc.embed_top) if em != null and em.sc != null else 0.0   # 打緊仗：大排檔 HUD 收埋，只剩頂部資源列
	var bot = PANEL_H if phase != "back" else 0.0
	var sy = (top + (nv.size.y - bot)) * 0.5 + 40.0
	c.tgt = Vector2(F.x - c.vw() / 2.0, F.y - sy / c.z)
	c.vel = Vector2.ZERO
func back_to_field() -> void:
	follow = true; LOG.append(["follow", null])

# ================= 底部卡片列 =================
static func L(s) -> String: return J.str(DB.L(J.str(s)))
func _btn(t: String, bg: Color, bd: Color, fg: Color) -> Button:
	var b = Button.new(); b.text = t; b.add_theme_font_override("font", UIKit.font("sans", 900)); b.add_theme_font_size_override("font_size", 14)
	var s = UIKit.sb(bg, 4, bd, 1, Vector4(8, 3, 8, 3))
	for k in ["normal", "hover", "pressed", "disabled"]: b.add_theme_stylebox_override(k, s)
	b.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
	for k in ["font_color", "font_hover_color", "font_pressed_color"]: b.add_theme_color_override(k, fg)
	b.focus_mode = Control.FOCUS_NONE
	return b
func _build_ui() -> void:
	ui = Control.new(); ui.name = "MapBattleUI"
	ui.anchor_top = 1; ui.anchor_right = 1; ui.anchor_bottom = 1; ui.offset_top = -PANEL_H
	ui.mouse_filter = Control.MOUSE_FILTER_STOP
	nv.add_child(ui)
	var bg = Panel.new(); bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var bs = StyleBoxFlat.new(); bs.bg_color = Color(0.09, 0.06, 0.07, 0.9); bs.border_color = Color("#5a2e22"); bs.border_width_top = 2
	bg.add_theme_stylebox_override("panel", bs); ui.add_child(bg)
	var vb = VBoxContainer.new(); vb.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	vb.offset_left = 6; vb.offset_right = -6; vb.offset_top = 5; vb.offset_bottom = -6; vb.add_theme_constant_override("separation", 3)
	vb.mouse_filter = Control.MOUSE_FILTER_IGNORE; ui.add_child(vb)
	var hb = HBoxContainer.new(); hb.add_theme_constant_override("separation", 5); hb.custom_minimum_size = Vector2(0, 28); vb.add_child(hb)
	title_l = UIKit.label("", 15, Color("#f3e3c0"), "serif", 900); title_l.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title_l.clip_text = true; title_l.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS; title_l.vertical_alignment = VERTICAL_ALIGNMENT_CENTER; hb.add_child(title_l)
	time_l = UIKit.label("", 15, Color("#ffcf6a"), "sans", 900); time_l.custom_minimum_size = Vector2(38, 0); time_l.vertical_alignment = VERTICAL_ALIGNMENT_CENTER; hb.add_child(time_l)
	back_b = _btn(ZD.L("返戰場", "回戰場"), Color("#5a3a1a"), Color("#c89a4a"), Color("#ffe8b0")); back_b.visible = false; hb.add_child(back_b)
	back_b.pressed.connect(back_to_field)
	speed_b = _btn("×1", Color("#3a2c26"), Color("#6a5040"), Color("#f0e2c8")); hb.add_child(speed_b)
	speed_b.pressed.connect(func():
		B["speed"] = 1.0 if J.num(B.get("speed", 1)) == 2.0 else 2.0
		_ls("gb_speed", str(int(J.num(B.speed)))); _sync_btns())
	auto_b = _btn("", Color("#3a2c26"), Color("#6a5040"), Color("#f0e2c8")); hb.add_child(auto_b)
	auto_b.pressed.connect(func():
		B["auto"] = not J.t(B.get("auto"))
		_ls("gb_auto", "1" if J.t(B.auto) else "0"); _sync_btns())
	quit_b = _btn(L("撤退"), Color(0, 0, 0, 0.25), Color("#6a5a50"), Color("#c8b8a8")); hb.add_child(quit_b)
	quit_b.pressed.connect(_on_quit)
	hint_l = UIKit.label("", 14, Color(0.9, 0.84, 0.74, 0.95)); hint_l.clip_text = true; hint_l.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	hint_l.custom_minimum_size = Vector2(0, 19); hint_l.mouse_filter = Control.MOUSE_FILTER_IGNORE; vb.add_child(hint_l)
	var cards = HBoxContainer.new(); cards.add_theme_constant_override("separation", 5); cards.size_flags_vertical = Control.SIZE_EXPAND_FILL
	cards.alignment = BoxContainer.ALIGNMENT_CENTER
	vb.add_child(cards)
	for u in B.units:
		if J.num(u.side) == 0 and not J.t(u.get("minion")): _mk_card(cards, u, "hero")
	if B.get("adviser") is Dictionary: _mk_card(cards, B.adviser, "adv")
	if B.get("comboSkill") is Dictionary: _mk_card(cards, B.comboSkill, "combo")
	var st = B.get("stage")
	var nm = J.str(st.get("name")) if st is Dictionary else ""
	var pre = {"boss": ZD.L("王戰", "王戰"), "cap": ZD.L("攻佔", "攻佔"), "raid": ZD.L("迎戰鬼潮", "迎戰鬼潮")}.get(kind, "")
	if raid_at != null: pre = ZD.L("迎戰", "迎戰")   # [raid] 標題已經係「餓鬼襲擾包子鋪」
	title_l.text = "%s　%s" % [pre, L(nm)]
	load("res://game/militia/ml_ui.gd").battle_bar(self)   # [militia] 出擊構成：陰兵＋遊魂兵 對 嘍囉
	_sync_btns()
func _ls(k: String, v: String) -> void:
	var ls = J.G.get("localStorage")
	if ls != null: J.mc(ls, "setItem", [k, v])
func _sync_btns() -> void:
	var on = J.t(B.get("auto"))
	auto_b.text = L("自動 ON") if on else L("自動 OFF")
	var s = UIKit.sb(Color("#2e5d55") if on else Color("#3a2c26"), 4, Color("#7ac0b0") if on else Color("#6a5040"), 1, Vector4(8, 3, 8, 3))
	for k in ["normal", "hover", "pressed"]: auto_b.add_theme_stylebox_override(k, s)
	speed_b.text = "×%d" % int(J.num(B.get("speed", 1)))
func _on_quit() -> void:
	if B.get("result") != null or phase == "back": return
	if _quit_arm <= 0:
		_quit_arm = 2.5; quit_b.text = L("確定？"); return
	_quit_arm = 0
	quit()
func quit() -> void:   # 撤退（同舊戰鬥一樣：finish(false, true)）
	if B.get("result") != null: return
	J.mc(B, "finish", [false, true])

func _mk_card(box: HBoxContainer, u: Dictionary, k: String) -> void:
	var base := Color("#e9ca68"); var edge := Color("#9a7a2a"); var ink := Color("#7a1a10")
	if k == "adv": base = Color("#ccd6b0"); edge = Color("#5a7a5a"); ink = Color("#2a4a3a")
	elif k == "combo": base = Color("#dcaccc"); edge = Color("#7a3a6a"); ink = Color("#5a0a4a")
	var n = 0
	for u2 in B.units: if J.num(u2.side) == 0 and not J.t(u2.get("minion")): n += 1
	if B.get("adviser") is Dictionary: n += 1
	if B.get("comboSkill") is Dictionary: n += 1
	var cw = clampf((nv.size.x - 12.0) / maxf(1, n) - 5.0, 76.0, 118.0)
	var p = Panel.new(); p.custom_minimum_size = Vector2(cw, CARD_H); p.clip_contents = true
	p.mouse_filter = Control.MOUSE_FILTER_STOP
	var st = StyleBoxFlat.new(); st.bg_color = base; st.border_color = edge; st.set_border_width_all(2); st.set_corner_radius_all(2)
	st.shadow_color = Color(0, 0, 0, 0.5); st.shadow_size = 0
	p.add_theme_stylebox_override("panel", st)
	var fill = ColorRect.new(); fill.color = Color(0.78, 0.2, 0.16, 0.26); fill.anchor_right = 1; fill.anchor_top = 1; fill.anchor_bottom = 1; fill.mouse_filter = Control.MOUSE_FILTER_IGNORE; p.add_child(fill)
	var vb = VBoxContainer.new(); vb.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); vb.offset_top = 3; vb.offset_bottom = -3
	vb.alignment = BoxContainer.ALIGNMENT_CENTER; vb.add_theme_constant_override("separation", 0); vb.mouse_filter = Control.MOUSE_FILTER_IGNORE; p.add_child(vb)
	if k != "combo":
		var pr = TextureRect.new(); pr.custom_minimum_size = Vector2(34, 34); pr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE; pr.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED; pr.mouse_filter = Control.MOUSE_FILTER_IGNORE
		var r = Art.portrait_region(J.str(u.k))
		if r.size(): var at = AtlasTexture.new(); at.atlas = r[0]; at.region = r[1]; pr.texture = at
		pr.size_flags_horizontal = Control.SIZE_SHRINK_CENTER; vb.add_child(pr)
	var t1 = ""
	if k == "combo": t1 = L(u.c.name)
	else: t1 = L(J.gp(u.get("sk"), "name")) if u.get("sk") != null else L(u.name)
	var nm = UIKit.label(t1, 14, ink, "serif", 900); nm.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; nm.clip_text = true
	nm.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS; nm.mouse_filter = Control.MOUSE_FILTER_IGNORE; vb.add_child(nm)
	var sub = UIKit.label("", 14, Color("#5a3a18"), "sans", 700); sub.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; sub.clip_text = true
	sub.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS; sub.mouse_filter = Control.MOUSE_FILTER_IGNORE; vb.add_child(sub)
	if k == "combo": sub.text = ZD.L("合體技", "合體技")
	elif k == "adv": sub.text = L("軍師・") + L(u.name)
	var seal = Label.new(); seal.text = ZD.L("放！", "放！"); seal.add_theme_font_override("font", UIKit.font("serif", 900)); seal.add_theme_font_size_override("font_size", 14)
	seal.add_theme_color_override("font_color", Color.WHITE); seal.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; seal.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	seal.add_theme_stylebox_override("normal", UIKit.sb(Color("#c8372d"), 2))
	seal.anchor_left = 1; seal.anchor_right = 1; seal.offset_left = -36; seal.offset_right = -3; seal.offset_top = 3; seal.offset_bottom = 23; seal.rotation = 0.12
	seal.mouse_filter = Control.MOUSE_FILTER_IGNORE; seal.visible = false; p.add_child(seal)
	var uu = u; var kk = k
	p.gui_input.connect(func(ev):
		if (ev is InputEventMouseButton and ev.pressed and ev.button_index == MOUSE_BUTTON_LEFT) or (ev is InputEventScreenTouch and ev.pressed):
			p.accept_event(); cast_card(uu, kk))
	box.add_child(p)
	card_list.append({"u": u, "box": p, "fill": fill, "seal": seal, "kind": k, "st": st, "edge": edge, "sub": sub, "sig": ""})
func cast_card(u, k: String) -> void:
	if B.get("result") != null or phase != "fight": return
	if k == "combo": J.mc(B, "castCombo", [])
	else: J.mc(B, "cast", [u])
	LOG.append(["cast", J.str(u.get("k", "combo"))])

# 對手：而家最近嗰隻（冇就王）
func focus_enemy():
	var hero = null
	for u in B.units: if J.num(u.side) == 0 and not J.t(u.get("minion")) and J.num(u.hp) > 0: hero = u; break
	var best = null; var bd = INF
	for v in B.units:
		if J.num(v.side) != 1 or J.num(v.hp) <= 0: continue
		var d = absf(J.num(v.x) - (J.num(hero.x) if hero != null else 0.0)) + (0.0 if J.t(v.get("boss")) else 30.0)
		if d < bd: bd = d; best = v
	return best
func _types(k: String) -> Array:
	var ts = J.mc(J.G.get("Rework"), "typesOf", [k])
	return ts if ts is Array else []
func _word(t) -> String: return L(J.mc(J.G.get("Rework"), "word", [t]))
func _update_ui(dt: float) -> void:
	if ui == null: return
	ui.visible = phase in ["march", "fight", "result"]
	if not ui.visible: return
	var left = maxf(0.0, ceil(J.num(B.get("timeLimit", 90)) - J.num(B.get("t", 0))))
	time_l.text = "%ds" % int(left)
	time_l.add_theme_color_override("font_color", Color("#ff7a6a") if left <= 10 else Color("#ffcf6a"))
	if _quit_arm > 0:
		_quit_arm -= dt
		if _quit_arm <= 0: quit_b.text = L("撤退")
	var fe = focus_enemy()
	var fear = J.mc(J.G.get("Rework"), "fearOf", [fe.k]) if fe != null else null
	var marked = null
	if fe != null and fe.get("fearT") is Dictionary and J.num(fe.fearT.get("until", 0)) > J.num(B.get("t", 0)): marked = fe.fearT.get("t")
	if phase == "march": hint_l.text = ZD.L("隊伍出發中……到咗戰場就開打", "隊伍出發中……到了戰場就開打")
	elif fe != null and fear is Dictionary:
		var w = []; for x in fear.w: w.append(_word(x))
		var im = []; for x in fear.i: im.append(_word(x))
		var nm = L(fe.name)
		if marked != null: hint_l.text = ZD.L("%s 失神（%s）！即刻用另一種佢怕嘅（%s）＝連嚇", "%s 失神（%s）！馬上用另一種他怕的（%s）＝連嚇") % [nm, _word(marked), "、".join(w)]
		else: hint_l.text = ZD.L("%s 怕%s　唔怕%s　先嚇到失神，再接另一種＝連嚇", "%s 怕%s　不怕%s　先嚇到失神，再接另一種＝連嚇") % [nm, "、".join(w), "、".join(im)]
	for c in card_list:
		var u = c.u; var en = J.num(u.get("energy", 0)); var ready := false; var dead := false
		if c.kind == "hero": ready = en >= 100 and J.num(u.hp) > 0 and u.get("casting") == null; dead = J.num(u.hp) <= 0
		elif c.kind == "adv": ready = en >= 100 and B.get("advCast") == null
		else: ready = en >= 100
		if phase != "fight": ready = false
		var tag = ""; var tcol = Color("#5a3a18")
		if c.kind == "hero" and fear is Dictionary:
			var ts = _types(J.str(u.k))
			var good = null; var bad_t = null
			for x in ts: if fear.w.has(x) and good == null: good = x
			for x in ts: if fear.i.has(x): bad_t = x
			if good != null and marked != null and good != marked: tag = ZD.L("連嚇！%s", "連嚇！%s") % _word(good); tcol = Color("#b8320a")
			elif good != null and marked == null: tag = ZD.L("對路・%s", "對路・%s") % _word(good); tcol = Color("#2a6a2a")
			elif good != null: tag = ZD.L("%s（已失神）", "%s（已失神）") % _word(good); tcol = Color("#6a5a3a")
			elif bad_t != null and ts.size() == 1: tag = ZD.L("唔怕%s", "不怕%s") % _word(bad_t); tcol = Color("#7a7a7a")
			elif ts.size(): tag = "／".join(ts.map(func(x): return _word(x)))
		var sig = "%d%s%s%s" % [int(en), ready, dead, tag]
		if sig == c.sig: continue
		c.sig = sig
		if c.kind == "hero": c.sub.text = tag; c.sub.add_theme_color_override("font_color", tcol)
		c.fill.anchor_top = 1.0 - clampf(en / 100.0, 0, 1)
		c.seal.visible = ready and not dead
		var st: StyleBoxFlat = c.st
		st.border_color = Color("#c8372d") if ready and not dead else c.edge
		st.shadow_color = Color(1, 0.75, 0.35, 0.75) if ready and not dead else Color(0, 0, 0, 0.5)
		st.shadow_size = 6 if ready and not dead else 0
		c.box.modulate = Color(0.35, 0.35, 0.35) if dead else (Color.WHITE if ready else Color(0.86, 0.82, 0.74))

# ================= 測試 =================
static func t_skip_march() -> void:
	if not busy() or cur.phase != "march": return
	for i in cur.mv: cur.mv[i].s = cur.mv[i].len
	cur._step_march(0.0)
static func t_skip_back() -> void:
	if busy() and cur.phase == "back":
		for i in cur.mv: cur.mv[i].s = cur.mv[i].len
