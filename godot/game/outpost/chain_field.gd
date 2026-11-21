# [village2] 一級資源田：拓展採集（chain.json GATHER 冇 old 嗰批）唔再係「一間建築自己出貨」，
#   改成同槐樹林、稻田一樣：地上一個個資源點（竹叢、椰樹、膠樹、茶叢、禾稈堆、蕉樹、罾、枯井、舊報紙、碳粉桶）。
#   - 親手採：撳資源點 → 阿福行過去，有動作（斬／割／搖）、有彈出數字；採完要等再生（同槐樹／稻田一樣嘅節奏）。永遠得，唔使開墾。
#   - 派鬼自動採：要先「開墾」（= 舊嘅起建築，扣 unlock.cost，S.bld[bid] = 等級），之後派鬼；
#                 產量照舊由 chain_eco.gd（BSTAT／worker_f：鬼對應能力值 ÷ 30，最低 0.2；冇鬼就冇自動產出），離線照計。
#                 畫面：派咗嘅鬼企喺資源點旁邊做嘢，每採夠一份就喺嗰個點彈「+n」。
#   - 舊存檔：S.bld[bid]（已起嘅採集建築等級）＝ 資源田等級，派咗嘅鬼（post = bid）原封不動 → 唔蝕。
# 熱更新規矩：冇 class_name、冇 autoload；const CF = preload("res://game/outpost/chain_field.gd")，全部 static。
extends RefCounted

const M = preload("res://game/outpost/mat.gd")
const CE = preload("res://game/outpost/chain_eco.gd")
const VS = preload("res://game/village_style.gd")
const ZD = preload("res://game/zone/zone_data.gd")   # [zone] 分區地圖：資源點、田名牌位置喺 zones.json

# 拓展區擺位（村子世界座標）：資源田＝田中心；加工建築＝建築腳。左右兩邊、中間係石板路（x 172–220）
const ANCHOR := {
	"b_well": [84, 1300], "b_bamboo": [302, 1292], "b_paper": [100, 1480], "b_coco": [296, 1478],
	"b_latex": [86, 1660], "b_strip": [298, 1668], "b_rubbersheet": [98, 1845], "b_cocomilk": [300, 1840],
	"b_tea": [90, 2020], "b_straw": [300, 2026], "b_rope": [98, 2200], "b_banana": [294, 2198],
	"b_fish": [90, 2380], "b_newspaper": [300, 2386], "b_pulp": [98, 2560], "b_toner": [298, 2556], "b_ink": [100, 2740]}
const ROW0 := 1286.0
const ROW_H := 180.0

# 資源點樣式：art = 圖鍵（可以 crop = [x0,y0,x1,y1] 比例）；proc = 程序畫；w = 闊；n = 點數；
#   act = 親手動作（chop 斬三下／reap 割／knead 搖、執）；plant = 植物（採完由細長大）；fx = 碎片
const NODE := {   # 圖：rn_*（主對話生，透明底、底部對齊）
	"b_well": {"art": "rn_well", "w": 58.0, "n": 3, "act": "knead", "plant": false, "fx": "dust", "verb": ["吊水", "吊水"]},
	"b_bamboo": {"art": "rn_bamboo", "w": 58.0, "n": 4, "act": "chop", "plant": true, "fx": "wood", "verb": ["斬竹", "砍竹"]},
	"b_coco": {"art": "rn_coco", "w": 66.0, "n": 4, "act": "chop", "plant": true, "fx": "wood", "verb": ["打椰", "打椰子"]},
	"b_latex": {"art": "rn_latex", "w": 62.0, "n": 4, "act": "chop", "plant": true, "fx": "dough", "verb": ["割膠", "割膠"]},
	"b_tea": {"art": "rn_tea", "w": 54.0, "n": 5, "act": "reap", "plant": true, "fx": "rice", "verb": ["採茶", "採茶"]},
	"b_straw": {"art": "rn_straw", "w": 54.0, "n": 4, "act": "reap", "plant": true, "fx": "rice", "verb": ["紮禾稈", "紮稻草"]},
	"b_banana": {"art": "rn_banana", "w": 62.0, "n": 4, "act": "chop", "plant": true, "fx": "wood", "verb": ["剪蕉葉", "剪蕉葉"]},
	"b_fish": {"art": "rn_fish", "w": 70.0, "n": 3, "act": "reap", "plant": false, "fx": "dust", "verb": ["起罾", "起網"]},
	"b_newspaper": {"art": "rn_newspaper", "w": 48.0, "n": 5, "act": "knead", "plant": false, "fx": "dust", "verb": ["執報紙", "撿報紙"]},
	"b_toner": {"art": "rn_toner", "w": 50.0, "n": 4, "act": "knead", "plant": false, "fx": "dust", "verb": ["舀碳粉", "舀碳粉"]},
}
const DEF_NODE := {"proc": "pile", "w": 36.0, "n": 4, "act": "knead", "plant": false, "fx": "dust", "verb": ["採", "採"]}
const REGROW := 24.0          # 再生秒數（槐樹 25、稻田 20）
const CHOP_HITS := 3

static func S():
	var s = J.G.get("S")
	return s if s is Dictionary else null
static func zh() -> bool: return DB.lang != "yue"
static func L(yue: String, zhs: String) -> String: return zhs if zh() else yue
static func T(a) -> String:
	if a is Array and a.size() >= 2: return str(a[1]) if zh() else str(a[0])
	return str(a) if a != null else ""

# ---------------- 資料 ----------------
static func is_field(bid: String) -> bool:
	var d = M.bld(bid)
	return d.get("kind") == "gather" and str(d.get("old", "")) == "" and bid in M.new_blds()
static func fields() -> Array:
	var o = []
	for b in M.new_blds(): if is_field(str(b)): o.append(str(b))
	return o
static func cfg(bid: String) -> Dictionary: return NODE.get(bid, DEF_NODE)
static func out_mid(bid: String) -> String: return str(M.bld(bid).get("out", ""))
static func hits(bid: String) -> int: return CHOP_HITS if str(cfg(bid).act) == "chop" else 1
# 親手採一次得幾多：基本產量 ÷ 10（最少 2）→ 槐樹 4、糯米 3 嘅同一個級數
static func yield_n(bid: String) -> int: return maxi(2, int(round(J.num(M.bld(bid).get("rate", 20)) / 10.0)))

# 擺位：固定（唔跟解鎖次序郁）；未列明嘅新建築排喺最後
static func anchor(bid: String) -> Vector2:
	if ZD.on():   # [zone]
		var fd = ZD.field_def(bid)
		if fd.has("sign"): return ZD.v2(fd.sign) + Vector2(0, -60)
		var sd = ZD.shop_def(bid)
		if sd.has("pos"): return ZD.v2(sd.pos)
	if ANCHOR.has(bid): return Vector2(ANCHOR[bid][0], ANCHOR[bid][1])
	var extra = []
	for b in M.new_blds(): if not ANCHOR.has(str(b)): extra.append(str(b))
	var i = extra.find(bid)
	var last = 0.0
	for k in ANCHOR: last = maxf(last, float(ANCHOR[k][1]))
	return Vector2([98.0, 298.0][i % 2], last + ROW_H * (1 + floor(i / 2.0)))

static var _nodes := {}
# 資源點位置：田中心附近隨機散開（固定種子，唔整齊但每次一樣），互相唔太近；由後到前排
static func nodes(bid: String) -> Array:
	if _nodes.has(bid): return _nodes[bid]
	if ZD.on() and ZD.field_def(bid).has("nodes"):   # [zone] 資源點固定位（zones.json）
		var zo = []; var rz = RandomNumberGenerator.new(); rz.seed = hash(bid) & 0x7fffffff
		var ps = ZD.field_def(bid).nodes.duplicate(); ps.sort_custom(func(a, b): return float(a[1]) < float(b[1]))
		for i in ps.size(): zo.append({"x": float(ps[i][0]), "y": float(ps[i][1]), "s": 0.9 + rz.randf() * 0.16, "flip": rz.randf() < 0.5, "i": i})
		_nodes[bid] = zo
		return zo
	var c = anchor(bid); var cf = cfg(bid); var n = int(cf.n)
	var rng = RandomNumberGenerator.new(); rng.seed = hash(bid) & 0x7fffffff
	var rx = 68.0; var ry = 38.0; var dmin = 42.0 if float(cf.w) >= 50 or cf.has("h") else 34.0
	var pts = []
	var tries = 0
	while pts.size() < n and tries < 1500:
		tries += 1
		var a = rng.randf() * TAU; var r = sqrt(rng.randf())
		var p = Vector2(c.x + cos(a) * rx * r, c.y - 8.0 + sin(a) * ry * r)
		p.x = clampf(p.x, 42.0, 348.0)
		if p.x > 150 and p.x < 242: continue   # 唔好踩落石板路
		if sign_rect(bid).grow(8).intersects(Rect2(p.x - 18, p.y - 44, 36, 48)): continue   # 唔好遮田名牌
		var okp = true
		for q in pts: if absf(q.x - p.x) < dmin and absf(q.y - p.y) < 26.0: okp = false
		if okp: pts.append(p)
	pts.sort_custom(func(a, b): return a.y < b.y)
	var o = []
	for i in pts.size():
		var s = 0.86 + rng.randf() * 0.24
		o.append({"x": pts[i].x, "y": pts[i].y, "s": s, "flip": rng.randf() < 0.5, "i": i})
	_nodes[bid] = o
	return o
static func reset() -> void: _nodes.clear()
# 田名牌（撳佢開資源田卡：開墾／升級／派鬼）：放喺近路嗰邊、田前面
static func sign_pos(bid: String) -> Vector2:
	if ZD.on() and ZD.field_def(bid).has("sign"): return ZD.v2(ZD.field_def(bid).sign)   # [zone]
	var c = anchor(bid)
	return Vector2(c.x + (50.0 if c.x < 195 else -50.0), c.y + 56.0)

# ---------------- 狀態（S.cfield[bid] = {"hp":[…], "rg":[…]}）----------------
static func st(bid: String) -> Dictionary:
	var s = S()
	if s == null: return {"hp": [], "rg": []}
	if not (s.get("cfield") is Dictionary): s["cfield"] = {}
	var n = nodes(bid).size()
	var e = s.cfield.get(bid)
	if not (e is Dictionary): e = {"hp": [], "rg": []}; s.cfield[bid] = e
	if not (e.get("hp") is Array): e["hp"] = []
	if not (e.get("rg") is Array): e["rg"] = []
	while e.hp.size() < n: e.hp.append(float(hits(bid)))
	while e.rg.size() < n: e.rg.append(0.0)
	return e
static func hp(bid: String, i: int) -> int: return int(J.num(st(bid).hp[i]))
static func ripe(bid: String, i: int) -> bool: return hp(bid, i) > 0
# 再生進度 0..1（1 = 長好）
static func grow(bid: String, i: int) -> float:
	if ripe(bid, i): return 1.0
	return clampf(1.0 - J.num(st(bid).rg[i]) / REGROW, 0.0, 1.0)
static func usable(bid: String) -> bool: return CE.unlocked(bid) and (not ZD.on() or ZD.bid_ok(bid))   # [zone] 資源區要先攻佔

# 舊存檔遷移：已起嘅拓展採集建築（S.bld[bid]）＝ 資源田等級，鬼（post = bid）照留；只補資源點狀態
static func migrate(s: Dictionary) -> void:
	if int(J.num(s.get("cfield_v", 0))) >= 1: return
	if not (s.get("cfield") is Dictionary): s["cfield"] = {}
	s["cfield_v"] = 1.0

# ---------------- 每格（包住 Village.update）----------------
static var acc := {}       # 自動採：未彈出嘅累積量
static var who := {}       # 自動採：下一個彈數字嘅工人
static var shake := {}     # "bid:i" → 搖嘅剩餘秒
static func tick(dt: float) -> void:
	var s = S()
	if s == null: return
	for bid in fields():
		if not usable(bid): continue
		var e = st(bid)
		for i in e.hp.size():
			if J.num(e.hp[i]) <= 0:
				e.rg[i] = J.num(e.rg[i]) - dt
				if J.num(e.rg[i]) <= 0: e.hp[i] = float(hits(bid)); e.rg[i] = 0.0
	for k in shake.keys():
		shake[k] = float(shake[k]) - dt
		if shake[k] <= 0: shake.erase(k)
	_auto_fx(dt)

# 自動採嘅畫面：跟 CE.rates 嘅真實產量累積，夠一份就喺工人嗰個點彈數字（真正入倉由 CE.produce 做）
static func _auto_fx(dt: float) -> void:
	var R = CE.rates()
	for bid in fields():
		var r = R.get(bid)
		if not (r is Dictionary): acc.erase(bid); continue
		var mid = out_mid(bid)
		if M.room(mid) < 0.5: continue
		var per = J.num(r.out.get(mid, 0)) / 60.0
		var a = float(acc.get(bid, 0.0)) + per * dt
		var step = float(yield_n(bid))
		if a >= step:
			a -= step
			var ws = workers_at(bid)
			if ws.size():
				var k = int(who.get(bid, 0)) % ws.size(); who[bid] = k + 1
				var nd = ws[k]
				shake["%s:%d" % [bid, int(nd.i)]] = 0.35
				_float(float(nd.x), float(nd.y) - 56.0, "%s +%d" % [M.name(mid), int(step)], "#cfe8a8")
				_parts(float(nd.x), float(nd.y) - 22.0, str(cfg(bid).fx), 4)
		acc[bid] = minf(a, step * 2.0)

static func workers_at(bid: String) -> Array:   # [{g, i, x, y}]：每隻鬼對一個資源點
	var o = []
	var ns = nodes(bid)
	if ns.is_empty(): return o
	var ws = []
	var s = S()
	for g in J.iter(s.get("ghosts")):
		if J.seq(J.gp(g, "post"), bid): ws.append(g)
	for k in ws.size():
		var nd = ns[(k * 2 + 1) % ns.size()] if ns.size() > 2 else ns[k % ns.size()]
		o.append({"g": ws[k], "i": nd.i, "x": nd.x, "y": nd.y})
	return o

# 派咗嘅鬼企喺資源點側邊做嘢（俾 Village.workerSpots 用）
static func worker_spots() -> Array:
	var o = []
	for bid in fields():
		if CE.lv(bid) <= 0 or not usable(bid): continue
		var k = 0
		for w in workers_at(bid):
			var left = float(w.x) > 300.0 or (k % 2 == 1 and float(w.x) > 60.0)
			var dx = -24.0 if left else 24.0
			o.append({"g": w.g, "x": float(w.x) + dx, "y": float(w.y) + 5.0, "flip": not left, "ph": k * 0.7 + float(w.x) * 0.01, "post": bid})
			k += 1
	return o

# ---------------- 點擊 ----------------
static func node_rect(bid: String, nd: Dictionary) -> Rect2:
	var w = node_w(bid) * float(nd.s); var h = node_h(bid) * float(nd.s)
	return Rect2(float(nd.x) - w * 0.42, float(nd.y) - h * 0.92, w * 0.84, h * 0.92 + 10.0)
static func node_w(bid: String) -> float:
	var cf = cfg(bid)
	if float(cf.w) > 0: return float(cf.w)
	var tx = _tex(bid)
	return float(cf.get("h", 60.0)) * tx.get_width() / tx.get_height() if tx != null else 40.0
static func node_h(bid: String) -> float:
	var cf = cfg(bid)
	if cf.has("h"): return float(cf.h)
	var tx = _tex(bid)
	if tx == null: return float(cf.w) * (0.8 if str(cf.get("proc", "")) == "tea" else 1.0)
	var cr = cf.get("crop", [0, 0, 1, 1])
	return float(cf.w) * (tx.get_height() * (cr[3] - cr[1])) / (tx.get_width() * (cr[2] - cr[0]))
static func sign_rect(bid: String) -> Rect2:
	var p = sign_pos(bid)
	return Rect2(p.x - 48, p.y - 46, 96, 52)
# 回 {"kind":"node"|"sign", "bid", "i"} 或 null
static func hit(x: float, y: float, shown: Array):
	var p = Vector2(x, y)
	for bid in fields():
		if not (bid in shown): continue
		if sign_rect(bid).has_point(p): return {"kind": "sign", "bid": bid}
	var best = null; var by = -1e9
	for bid in fields():
		if not (bid in shown): continue
		for nd in nodes(bid):
			if node_rect(bid, nd).has_point(p) and float(nd.y) > by: best = {"kind": "node", "bid": bid, "i": int(nd.i)}; by = float(nd.y)
	return best

# 撳資源點：行過去親手採（同砍樹一樣）
static func tap_node(V: Dictionary, bid: String, i: int, x: float, y: float) -> void:
	var nd = nodes(bid)[i]
	if not usable(bid):
		_float(x, y - 30, L("村子去到第 %d 張圖先採得", "村子抵達第 %d 張地圖才能採") % (CE.need_ci(bid) + 1), "#ccc"); return
	if not ripe(bid, i):
		_float(x, y - 30, L("%s 仲未長返…", "%s 還沒長回來…") % M.name(out_mid(bid)), "#ccc"); return
	var right = float(nd.x) < 330.0
	J.mc(V, "walkTo", [float(nd.x) + (22.0 if right else -22.0), float(nd.y) + 4.0, {"kind": "cnode", "bid": bid, "i": i, "dir": -1.0 if right else 1.0}])

# ---------------- 親手採（包住 Village.doAct／heroPose）----------------
static func dur(bid: String) -> float:
	var ct = J.num(J.mc(J.G.get("F"), "chopTime", [])) if J.G.get("F") != null else 0.6
	return ct if str(cfg(bid).act) == "chop" else ct * 1.4
static func do_act(V: Dictionary, dt: float) -> void:
	var H = V.hero; var a = H.act
	var bid = str(a.bid); var i = int(J.num(a.i))
	if not usable(bid) or i >= nodes(bid).size() or not ripe(bid, i): H["act"] = null; return
	if not a.has("started"): a["started"] = true; H["dir"] = J.num(a.get("dir", -1.0)); a["pp"] = 0.0
	H["actT"] = J.num(H.get("actT")) + dt
	var nd = nodes(bid)[i]; var d = dur(bid); var cf = cfg(bid)
	var p = minf(1.0, J.num(H.actT) / d)
	if str(cf.act) != "chop":   # 割／搖：過程中三下碎片
		for h in [1.0 / 12, 5.0 / 12, 9.0 / 12]:
			if float(a.pp) < h and p >= h: _parts(float(nd.x) - 6 + randf() * 12, float(nd.y) - 14, str(cf.fx), 5); shake["%s:%d" % [bid, i]] = 0.15
		a["pp"] = p
	if J.num(H.actT) < d: return
	H["actT"] = 0.0; a["pp"] = 0.0
	var e = st(bid)
	if str(cf.act) == "chop":
		var first = int(J.num(e.hp[i])) == hits(bid)
		e.hp[i] = J.num(e.hp[i]) - 1.0
		shake["%s:%d" % [bid, i]] = 0.18
		J.mc(V, "impact", [float(nd.x) + 6.0, float(nd.y) - 22.0, "wood" if str(cf.fx) == "wood" else "dust", 1.1 if first else 0.9])
		_sound("chop")
		_float(float(nd.x), float(nd.y) - 50.0, L("咚！", "咚！"), "#ffe9a8")
		if J.num(e.hp[i]) > 0: return
	else:
		e.hp[i] = 0.0
	_harvest(V, bid, i)

static func _harvest(V: Dictionary, bid: String, i: int) -> void:
	var nd = nodes(bid)[i]; var e = st(bid); var mid = out_mid(bid); var n = yield_n(bid)
	e.hp[i] = 0.0; e.rg[i] = REGROW
	var got = M.add_capped(mid, float(n))
	var s = S()
	if s.get("cnt") is Dictionary: s.cnt["gather"] = J.num(s.cnt.get("gather", 0)) + 1.0
	var ge = J.G.get("gainExp")
	if ge != null: J.cl(ge, null, [1.0])
	_sound("treeFall" if str(cfg(bid).act) == "chop" else "harvest")
	if got >= 0.5: _float(float(nd.x), float(nd.y) - 70.0, L("%s +%d　好評 +1", "%s +%d　好評 +1") % [M.name(mid), int(round(got))], "#a8ffcf")
	else: _float(float(nd.x), float(nd.y) - 70.0, L("%s 倉滿咗", "%s 倉庫滿了") % M.name(mid), "#ffb37a")
	var fx = J.G.get("Fx")
	if fx != null: J.mc(fx, "praise", ["chop" if str(cfg(bid).act) == "chop" else "rice"])
	V.hero["act"] = null; V["proudT"] = 0.8
	if str(cfg(bid).act) == "chop": V["shk"] = 4.0
	var q = J.G.get("Quest")
	if q != null: J.mc(q, "check", [])

static func pose(V: Dictionary):
	var H = V.hero; var a = H.get("act")
	if J.num(V.get("proudT", 0)) > 0 or not (a is Dictionary) or a.get("kind") != "cnode" or J.t(H.get("walking")): return null
	var bid = str(a.bid)
	return [str(cfg(bid).act), minf(1.0, J.num(H.get("actT")) / dur(bid))]

# ---------------- 小工具 ----------------
static func _float(x: float, y: float, txt: String, col: String) -> void:
	var fx = J.G.get("Fx")
	if fx != null: J.mc(fx, "float", [x, y, txt, col])
static func _sound(k: String) -> void:
	var so = J.G.get("Sound")
	if so != null: J.mc(so, "play", [k])
static func _parts(x: float, y: float, kind: String, n: int) -> void:
	var V = J.G.get("Village")
	if not (V is Dictionary) or not (V.get("parts") is Array): return
	var k = {"wood": "chip", "rice": "grain", "dough": "dough"}.get(kind, "dust")
	for j in n:
		V.parts.append({"k": k, "x": x, "y": y, "vx": (randf() - 0.5) * 90.0, "vy": -50.0 - randf() * 70.0, "g": -10.0 if k == "dust" else 300.0, "t": 0.0, "life": 0.5 + randf() * 0.3, "r": randf() * 6.0, "vr": (randf() - 0.5) * 14.0, "s": 0.022 if k == "dough" else (0.035 if k == "dust" else 0.04)})

# ---------------- 畫資源點（nv_village 叫）----------------
static func _tex(bid: String) -> Texture2D:
	var k = str(cfg(bid).get("art", ""))
	if k == "" or not Spr.ok(k): return null
	return Spr.get_tex(k)

# ctx：世界座標；lock = 預告（下一張圖先開）
static func draw_node(ctx: Ctx, bid: String, nd: Dictionary, t: float, lock: bool) -> void:
	var cf = cfg(bid); var i = int(nd.i)
	var g = 1.0 if lock else grow(bid, i)
	var rp = lock or ripe(bid, i)
	var x = float(nd.x); var y = float(nd.y); var s = float(nd.s)
	var sh = shake.has("%s:%d" % [bid, i])
	var plant = bool(cf.plant)
	var k = s * (1.0 if rp or not plant else lerpf(0.42, 0.92, g))
	var tint = Color(0.88, 0.84, 0.82)
	if not rp: tint = tint.lerp(Color(0.30, 0.27, 0.30), 0.55 * (1.0 - g) + 0.25)
	if lock: tint = Color(0.40, 0.38, 0.42, 0.55)
	var w = node_w(bid) * k; var h = node_h(bid) * k
	Art.el(ctx, x, y + 1, w * 0.40, 4.5 * s, "rgba(8,2,8,.34)")
	ctx.save()
	var sway = sin(t * 0.9 + x * 0.3) * 0.018 if plant and rp else 0.0
	if sh: sway += sin(t * 55.0) * 0.035
	ctx.translate(x, y); ctx.rotate(sway); ctx.translate(-x, -y)
	if not rp and not plant: _stub(ctx, bid, x, y, s, g)
	if rp or plant:
		var proc = str(cf.get("proc", ""))
		if proc != "": _proc(ctx, proc, x, y, w, h, tint, bool(nd.flip), t + x)
		else: _img(ctx, bid, x, y, w, h, tint, bool(nd.flip))
	ctx.restore()
	if not rp and plant and g < 0.999: _sprout(ctx, x, y, s, g)

static func _img(ctx: Ctx, bid: String, x: float, y: float, w: float, h: float, tint: Color, flip: bool) -> void:
	var tx = _tex(bid)
	if tx == null: return
	var cr = cfg(bid).get("crop", [0, 0, 1, 1])
	var iw = float(tx.get_width()); var ih = float(tx.get_height())
	var sx0 = iw * float(cr[0]); var sy0 = ih * float(cr[1]); var sw = iw * (float(cr[2]) - float(cr[0])); var sh = ih * (float(cr[3]) - float(cr[1]))
	var c = ctx.ci
	var X = ctx.T
	if flip: X = X * Transform2D(Vector2(-1, 0), Vector2(0, 1), Vector2(2 * x, 0))
	c.draw_set_transform_matrix(X)
	var m = tint * ctx._mod()
	if cr == [0, 0, 1, 1] or (float(cr[0]) <= 0.0 and float(cr[2]) >= 1.0):
		c.draw_texture_rect_region(tx, Rect2(x - w / 2, y - h, w, h), Rect2(sx0, sy0, sw, sh), m)
	else:   # 裁咗邊：兩邊最後 16% 分段淡出（唔見硬邊）
		var n = 6; var edge = 0.16
		var core0 = edge; var core1 = 1.0 - edge
		c.draw_texture_rect_region(tx, Rect2(x - w / 2 + w * core0, y - h, w * (core1 - core0), h), Rect2(sx0 + sw * core0, sy0, sw * (core1 - core0), sh), m)
		for j in n:
			var f0 = edge * j / n; var f1 = edge * (j + 1) / n
			var a = (j + 0.5) / n
			var mm = Color(m.r, m.g, m.b, m.a * a * a)
			c.draw_texture_rect_region(tx, Rect2(x - w / 2 + w * f0, y - h, w * (f1 - f0) + 0.3, h), Rect2(sx0 + sw * f0, sy0, sw * (f1 - f0), sh), mm)
			var g0 = 1.0 - f1; var g1 = 1.0 - f0
			c.draw_texture_rect_region(tx, Rect2(x - w / 2 + w * g0, y - h, w * (g1 - g0) + 0.3, h), Rect2(sx0 + sw * g0, sy0, sw * (g1 - g0), sh), mm)
	c.draw_set_transform_matrix(Transform2D.IDENTITY)

# 非植物採完：枯井冇水（暗）、罾空、報紙得返一張、碳粉桶側翻
static func _stub(ctx: Ctx, bid: String, x: float, y: float, s: float, g: float) -> void:
	var cf = cfg(bid)
	var proc = str(cf.get("proc", ""))
	if proc == "news":
		ctx.save(); ctx.translate(x, y - 3 * s); ctx.rotate(0.3)
		Art.rr(ctx, -9 * s, -3 * s, 18 * s, 6 * s, 1, "#8f8778", "#3a342c", 0.8); ctx.restore(); return
	if proc == "toner":
		ctx.save(); ctx.translate(x, y - 6 * s); ctx.rotate(1.4)
		Art.rr(ctx, -7 * s, -10 * s, 14 * s, 20 * s, 2, "#26262c", "#0e0e12", 1); ctx.restore()
		Art.el(ctx, x + 12 * s, y - 2, 9 * s, 3 * s, "rgba(20,20,26,.7)"); return
	var w = node_w(bid) * s; var h = node_h(bid) * s
	_img(ctx, bid, x, y, w, h, Color(0.32, 0.30, 0.34, 0.85), false)

# 植物採完：地上一個樹樁仔＋嫩芽（慢慢長返）
static func _sprout(ctx: Ctx, x: float, y: float, s: float, g: float) -> void:
	Art.el(ctx, x, y - 2, 7 * s, 3 * s, "#3a2a1e", "#1a100a", 0.8)
	var n = 3
	for j in n:
		var a = -0.6 + j * 0.6
		var L2 = (4.0 + 9.0 * g) * s
		ctx.strokeStyle = "rgba(90,120,70,.9)"; ctx.lineWidth = 1.4
		ctx.beginPath(); ctx.moveTo(x + (j - 1) * 2.5, y - 3); ctx.quadraticCurveTo(x + (j - 1) * 3 + sin(a) * L2 * 0.4, y - 3 - L2 * 0.6, x + (j - 1) * 3 + sin(a) * L2, y - 3 - L2); ctx.stroke()

# 程序畫（蠟筆＋暗色；冇圖時用）
static func _proc(ctx: Ctx, kind: String, x: float, y: float, w: float, h: float, tint: Color, flip: bool, ph: float) -> void:
	var tc = func(hex: String) -> String:
		var c = Color(hex) * tint
		return "rgba(%d,%d,%d,%.2f)" % [int(c.r * 255), int(c.g * 255), int(c.b * 255), tint.a]
	var fl = -1.0 if flip else 1.0
	match kind:
		"tea":   # 茶叢：矮闊一壟，頂邊一嚿嚿唔規則，暗橄欖綠＋蠟筆排線，葉尖幾點嫩綠
			var rx = w * 0.5; var hh = h * 0.62
			Art.el(ctx, x, y - hh * 0.42, rx, hh * 0.46, tc.call("#1e2818"), tc.call("#0e140a"), 1.1)
			var cols = ["#33422a", "#3a4a2e", "#435634", "#364628"]
			for j in 8:
				var u = (j + 0.5) / 8.0
				var px = x - rx * 0.86 + u * rx * 1.72
				var top = y - hh * (0.55 + 0.38 * sin(u * PI)) + sin(j * 2.3 + ph) * 1.6
				var rr = rx * (0.24 + 0.08 * fmod(j * 0.61, 1.0))
				Art.el(ctx, px, top + rr * 0.5, rr, rr * 0.78, tc.call(cols[j % 4]), tc.call("#121a0c"), 0.8)
				Art.el(ctx, px - rr * 0.2, top + rr * 0.25, rr * 0.55, rr * 0.28, tc.call("#56703e"))   # 頂光
			ctx.strokeStyle = "rgba(8,10,6,.55)"; ctx.lineWidth = 0.7
			for j in 12:   # 暗影排線（左下）
				var px3 = x - rx * 0.8 + j * rx * 0.13; var py3 = y - hh * 0.18 - fmod(j * 0.37, 1.0) * hh * 0.25
				ctx.beginPath(); ctx.moveTo(px3, py3); ctx.lineTo(px3 + 3.2, py3 - 2.4); ctx.stroke()
			ctx.strokeStyle = tc.call("#6f8f52"); ctx.lineWidth = 1.1
			for j in 7:   # 嫩芽
				var u2 = fmod(j * 0.383 + 0.1, 1.0); var px2 = x - rx * 0.7 + u2 * rx * 1.4
				var py2 = y - hh * (0.62 + 0.36 * sin(u2 * PI))
				ctx.beginPath(); ctx.moveTo(px2, py2); ctx.lineTo(px2 + 1.6 * fl, py2 - 3.0); ctx.stroke()
			for j in 3:   # 茶樹枝腳
				Art.rr(ctx, x - rx * 0.5 + j * rx * 0.5 - 1, y - 4, 2, 4, 0.5, tc.call("#3a2a1e"))
		"news":   # 舊報紙：幾紮用繩綁住、疊埋一堆，最頂一張俾風吹起
			var bw = w; var bh = h * 0.22
			for j in 3:
				var yy = y - bh * (j + 1) - j * 0.5; var ox = (j % 2) * 3.0 * fl - 1.5
				Art.rr(ctx, x - bw / 2 + ox, yy, bw, bh, 1.2, tc.call(["#9a9282", "#a8a090", "#8c8474"][j]), tc.call("#3a342c"), 0.9)
				ctx.strokeStyle = tc.call("#5a5048"); ctx.lineWidth = 0.6
				for r in 3: ctx.beginPath(); ctx.moveTo(x - bw / 2 + ox + 2, yy + 1.5 + r * bh / 3.2); ctx.lineTo(x + bw / 2 + ox - 2, yy + 1.5 + r * bh / 3.2); ctx.stroke()
				Art.rr(ctx, x - 1 + ox, yy - 0.5, 2.2, bh + 1, 0.5, tc.call("#6a4a2a"))
			var top = y - bh * 3 - 2; var fpx = x + 2 * fl + sin(ph * 2.0) * 1.5
			Art.poly(ctx, [fpx - bw * 0.42, top, fpx + bw * 0.38, top - 2, fpx + bw * 0.30, top - bh * 1.1 + sin(ph * 2.3) * 1.5, fpx - bw * 0.36, top - bh * 0.8], tc.call("#b8b0a0"), tc.call("#3a342c"), 0.8)
			ctx.fillStyle = tc.call("#3a3430"); ctx.fillRect(fpx - bw * 0.30, top - bh * 0.6, bw * 0.3, 1.6)   # 頭條
			ctx.fillStyle = tc.call("#7a2a22"); ctx.fillRect(fpx + bw * 0.04, top - bh * 0.62, bw * 0.16, bh * 0.36)   # 舊相
		"toner":   # 碳粉桶：黑鐵桶、桶口黑粉、地上一灘
			var bw2 = w; var bh2 = h * 1.2
			Art.el(ctx, x + 6 * fl, y - 1, bw2 * 0.8, 3.5, "rgba(16,16,22,.75)")
			Art.rr(ctx, x - bw2 / 2, y - bh2, bw2, bh2, 3, tc.call("#2c2c34"), tc.call("#0c0c10"), 1.2)
			for r in 2: Art.rr(ctx, x - bw2 / 2 - 1, y - bh2 * (0.3 + r * 0.38), bw2 + 2, 2.6, 1, tc.call("#46464e"))
			Art.el(ctx, x, y - bh2, bw2 / 2, 3.2, tc.call("#14141a"), tc.call("#0c0c10"), 1)
			Art.el(ctx, x - 1, y - bh2 - 1.5, bw2 * 0.34, 2.2, tc.call("#08080a"))
			ctx.fillStyle = tc.call("#8a8a92"); ctx.fillRect(x - bw2 * 0.28, y - bh2 * 0.62, bw2 * 0.56, bh2 * 0.14)   # 舊標籤
			ctx.strokeStyle = "rgba(160,160,170,.18)"; ctx.lineWidth = 1
			ctx.beginPath(); ctx.moveTo(x - bw2 * 0.34, y - bh2 * 0.9); ctx.lineTo(x - bw2 * 0.34, y - bh2 * 0.12); ctx.stroke()
		_:
			Art.el(ctx, x, y - h * 0.3, w * 0.5, h * 0.3, tc.call("#5a4a3a"), tc.call("#1a120c"), 1)

# 田名牌：木樁＋牌（名 14px）＋等級；未開墾／預告寫細字
static func draw_sign(ctx: Ctx, bid: String, lv: int, un: bool, nw: int) -> void:
	var p = sign_pos(bid); var x = p.x; var y = p.y
	var nm = T(M.bld(bid).get("n", bid))
	if ZD.on() and ZD.field_def(bid).get("n") is Array: nm = ZD.T(ZD.field_def(bid).n)   # [zone56] 同一種田喺唔同關有唔同叫法（例如枯井→舊村古井）
	ctx.save()
	ctx.font = "900 14px " + Art.SERIF
	var w = maxf(64.0, ctx.measureText(nm).width + 18)
	Art.el(ctx, x, y + 1, 10, 3, "rgba(8,2,8,.4)")
	Art.rr(ctx, x - 2, y - 30, 4, 32, 1, "#4a3020", "#1a100a", 1)
	ctx.globalAlpha = 1.0 if un else 0.75
	Art.rr(ctx, x - w / 2, y - 46, w, 22, 2, "#7a5634", "#2a1a0e", 1.4)
	ctx.fillStyle = "rgba(255,230,180,.15)"; ctx.fillRect(x - w / 2 + 2, y - 44, w - 4, 2)
	var col = CB_col(bid)
	ctx.fillStyle = col; ctx.fillRect(x - w / 2 + 2, y - 44, 4, 18)
	ctx.textAlign = "center"; ctx.textBaseline = "middle"
	ctx.lineWidth = 3; ctx.strokeStyle = "rgba(30,16,8,.95)"; ctx.lineJoin = "round"
	ctx.strokeText(nm, x + 2, y - 34.5); ctx.fillStyle = "#f6e2b0"; ctx.fillText(nm, x + 2, y - 34.5)
	ctx.globalAlpha = 1.0
	if lv > 0:
		Art.rr(ctx, x + w / 2 - 6, y - 54, 24, 18, 2, "#c2362b", "#f0c8b4", 1)
		_t(ctx, str(lv), x + w / 2 + 6, y - 45, "#fff3e0")
		if nw <= 0: _t(ctx, L("冇鬼開工", "沒有鬼開工"), x, y - 12, "#ff9a7a")
	elif un: _t(ctx, L("未開墾", "未開墾"), x, y - 12, "#ff9a7a")
	else: _t(ctx, L("第 %d 張圖", "第 %d 張地圖") % (CE.need_ci(bid) + 1), x, y - 12, "#c8bca8")
	ctx.restore()
static func _t(ctx: Ctx, s: String, x: float, y: float, col: String) -> void:
	ctx.font = "900 14px " + Art.SERIF; ctx.textAlign = "center"; ctx.textBaseline = "middle"
	ctx.lineWidth = 3; ctx.strokeStyle = "rgba(30,16,8,.95)"; ctx.lineJoin = "round"; ctx.strokeText(s, x, y); ctx.fillStyle = col; ctx.fillText(s, x, y)
static func CB_col(bid: String) -> String:
	var CBm = load("res://game/outpost/chain_bld.gd")
	return "#" + CBm.mat_col(out_mid(bid)).to_html(false)
