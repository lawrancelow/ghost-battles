# [zone] 分區據點地圖（ZONE_CONTRACT.md）：資料＋狀態＋規則（全部 static；冇 class_name、冇 autoload，熱更新規矩）
#   const ZD = preload("res://game/zone/zone_data.gd")
# 資料：data/nat/zones.json（tools/zone_build.py 產生）。maps["<ci>"] 有定義嘅圖就用分區地圖，冇就照舊豎條布局。
# 狀態：S.zone = {"v":1, "own":{"<ci>:<zid>":true}, "boss":{"<ci>:<bossid>":true}, "exp":null|{kind,ci,id,sid,had}}
#
# 規則：
#   陰兵戰力 power() = floor(S.res.troops) × (1 + 0.08 × max(0, 民宅等級 − 1))
#                     （同戰鬥入面陰兵嘅民宅加成 tb 一樣；陰兵＝民宅遊魂自願當兵嗰個 S.res.troops）
#   資源區：未佔領 = 黑霧＋鎖＋建議戰力 N（zones.json power）
#           派陰兵攻佔：power ≥ N 先得；即刻佔領，折損 ceil(N × loss ÷ 民宅加成) 個陰兵（loss 預設 0.3）
#           親自出征：用現有戰鬥（Battle.start 野鬼戰格式，stage 喺 zones.json），打贏即佔領；輸咗冇損失
#           佔領咗唔會再失去
#   加工廠（shops）：只可以起喺所屬資源區；要該區已佔領＋need 入面嘅一級資源田升到指定等級
#   野外王：每區按次序打（①→②）；chapter 有填嘅（主 Boss）直接開世界地圖嗰一關（劇情、收編照舊），S.cleared 記低
#           全部王打低 → 呢張圖解放 → 先可以拔營（mv_sim.can_move）
#   舊存檔：S.bld 已開墾／已起嘅資源田、加工廠 → 該區當已佔領；主線已打低餓鬼王（S.cleared 1-3）→ 餓鬼坑兩個王當已打低
extends RefCounted

const PATH := "res://data/nat/zones.json"
static var _D = null
static var force_off := false      # 測試用：強制用舊豎條布局
static var _applied := ""          # 而家套用咗邊張圖嘅村子座標（"" = 舊）
static var _orig = null            # 舊村子座標（還原用）
static var _mv_l := {}             # ci → 大排檔 layout 快取

# ---------------- 資料 ----------------
static func D() -> Dictionary:
	if _D == null: reload()
	return _D
static func reload() -> void:
	var f = FileAccess.open(PATH, FileAccess.READ)
	var o = JSON.parse_string(f.get_as_text()) if f != null else null
	_D = o if o is Dictionary else {"maps": {}}
	if not (_D.get("maps") is Dictionary): _D["maps"] = {}
	_mv_l = {}
static func mdef(c: int) -> Dictionary:
	var m = D().maps.get(str(c))
	return m if m is Dictionary else {}
static func S():
	var s = J.G.get("S")
	return s if s is Dictionary and not s.is_empty() else null
static func ci() -> int:
	var s = S()
	if s == null or not (s.get("mv") is Dictionary): return 0
	return int(J.num(s.mv.get("ci", 0)))
static func disabled() -> bool: return force_off or OS.has_environment("GB_NOZONE")
static func on_for(c: int) -> bool:
	if disabled(): return false
	var s = S()
	if s == null or not J.t(s.get("mv_on")): return false
	return not mdef(c).is_empty()
static func on() -> bool: return on_for(ci())
static func cur() -> Dictionary: return mdef(ci())
static func zh() -> bool: return DB.lang != "yue"
static func L(yue: String, zhs: String) -> String: return zhs if zh() else yue
static func T(a) -> String:
	if a is Array and a.size() >= 2: return str(a[1]) if zh() else str(a[0])
	return str(a) if a != null else ""
static func v2(a) -> Vector2: return Vector2(float(a[0]), float(a[1])) if a is Array and a.size() >= 2 else Vector2.ZERO
static func rect(a) -> Rect2: return Rect2(float(a[0]), float(a[1]), float(a[2]) - float(a[0]), float(a[3]) - float(a[1]))
static func world_size(c := -1) -> Vector2:
	var m = mdef(ci() if c < 0 else c)
	return Vector2(float(m.get("w", 390)), float(m.get("h", 1130)))

# ---------------- 區 ----------------
static func zones(c := -1) -> Array:
	var z = mdef(ci() if c < 0 else c).get("zones", [])
	return z if z is Array else []
static func zone(id: String, c := -1) -> Dictionary:
	for z in zones(c): if str(z.id) == id: return z
	return {}
static func zrect(id: String, c := -1) -> Rect2:
	var z = zone(id, c)
	return rect(z.rect) if z.has("rect") else Rect2()
static func of_type(tp: String, c := -1) -> Array:
	var o = []
	for z in zones(c): if str(z.get("type")) == tp: o.append(z)
	return o
static func zone_at(p: Vector2, c := -1) -> String:
	for z in zones(c): if rect(z.rect).has_point(p): return str(z.id)
	return ""
static func door_at(p: Vector2, c := -1) -> String:   # 撳中門洞（屬於邊個資源區）
	for z in of_type("res", c):
		if z.get("door") is Dictionary and rect(z.door.rect).grow(6).has_point(p): return str(z.id)
	return ""

# ---------------- 狀態 ----------------
static func st():
	var s = S()
	if s == null: return null
	if not (s.get("zone") is Dictionary): s["zone"] = {"v": 1.0, "own": {}, "boss": {}, "exp": null}
	var z = s.zone
	for k in ["own", "boss"]: if not (z.get(k) is Dictionary): z[k] = {}
	if int(J.num(z.get("mig", 0))) < 1: _migrate(s, z)
	return z
static func _k(id: String, c := -1) -> String: return "%d:%s" % [ci() if c < 0 else c, id]
static func owned(zid: String, c := -1) -> bool:
	var z = zone(zid, c)
	if z.is_empty(): return false
	if str(z.get("type")) != "res": return true
	var s = st()
	return s != null and J.t(s.own.get(_k(zid, c)))
static func set_owned(zid: String, c := -1) -> void:
	var s = st()
	if s != null: s.own[_k(zid, c)] = true

# 舊存檔遷移：已開墾嘅資源田／已起嘅加工廠 → 該區已佔領；主線已過 1-3 → 餓鬼坑兩個王已打
static func _migrate(s: Dictionary, z: Dictionary) -> void:
	z["mig"] = 1.0
	var bld = s.get("bld") if s.get("bld") is Dictionary else {}
	for ck in D().maps:
		var c = int(ck)
		for zz in zones(c):
			if str(zz.get("type")) == "res":
				var hit = false
				for b in _zbids(zz): if J.num(bld.get(b, 0)) > 0: hit = true
				if hit: z.own[_k(str(zz.id), c)] = true
			elif str(zz.get("type")) == "wild":
				var bs = zz.get("bosses", [])
				for i in bs.size():
					if bs[i].get("chapter") is Array and _chapter_done(s, bs[i].chapter):
						for j in i + 1: z.boss[_k(str(bs[j].id), c)] = true
static func _zbids(z: Dictionary) -> Array:
	var o = []
	for k in ["fields", "shops"]:
		if z.get(k) is Dictionary: for b in z[k]: o.append(str(b))
	return o
static func _chapter_done(s, ch: Array) -> bool:
	var cl = s.get("cleared")
	return cl is Dictionary and J.t(cl.get("%d-%d" % [int(ch[0]) + 1, int(ch[1]) + 1]))

# ---------------- 陰兵戰力 ----------------
static func troop_mul() -> float:
	var s = S()
	if s == null: return 1.0
	return 1.0 + 0.08 * maxf(0.0, J.num(s.bld.get("home", 1)) - 1.0)
static func power() -> int:
	var s = S()
	if s == null: return 0
	return int(floor(floor(J.num(s.res.get("troops", 0))) * troop_mul()))
static func need(zid: String) -> int: return int(zone(zid).get("power", 0))
static func loss(zid: String) -> int:
	return int(ceil(float(need(zid)) * float(zone(zid).get("loss", 0.3)) / troop_mul()))
# 派陰兵攻佔：回 "ok"／"owned"／"weak"
static func capture_auto(zid: String) -> String:
	if owned(zid): return "owned"
	if power() < need(zid): return "weak"
	var s = S()
	s.res["troops"] = maxf(0.0, J.num(s.res.get("troops", 0)) - loss(zid))
	set_owned(zid)
	_save()
	return "ok"

# ---------------- 野外王 ----------------
static func bosses(zid: String, c := -1) -> Array:
	var b = zone(zid, c).get("bosses", [])
	return b if b is Array else []
static func boss_done(zid: String, i: int, c := -1) -> bool:
	var bs = bosses(zid, c)
	if i < 0 or i >= bs.size(): return false
	var b = bs[i]; var s = st()
	if s != null and J.t(s.boss.get(_k(str(b.id), c))): return true
	if b.get("chapter") is Array and S() != null and _chapter_done(S(), b.chapter): return true
	return false
static func boss_next(zid: String, c := -1) -> int:   # 下一個要打嘅王（-1 = 打晒）
	for i in bosses(zid, c).size(): if not boss_done(zid, i, c): return i
	return -1
static func wild_done(zid: String, c := -1) -> bool: return boss_next(zid, c) < 0
static func all_bosses_done(c := -1) -> bool:
	for z in of_type("wild", c): if not wild_done(str(z.id), c): return false
	return true
static func main_boss_done(c := -1) -> bool:
	for z in of_type("wild", c):
		var bs = bosses(str(z.id), c)
		for i in bs.size(): if J.t(bs[i].get("main")) and not boss_done(str(z.id), i, c): return false
	return true
static func boss_count(c := -1) -> Array:   # [打低咗, 總數]
	var a = 0; var n = 0
	for z in of_type("wild", c):
		for i in bosses(str(z.id), c).size():
			n += 1
			if boss_done(str(z.id), i, c): a += 1
	return [a, n]

# ---------------- 出征（現有戰鬥） ----------------
static func team_ok() -> bool:
	var s = S()
	for x in J.iter(s.get("team")): if J.t(x): return true
	return false
# kind = "cap"（資源區）／"boss"（野外王）；回 "ok"／"noteam"／"nobattle"／"order"／"done"
static func start_battle(kind: String, zid: String) -> String:
	var s = S(); var B = J.G.get("Battle")
	if s == null or not (B is Dictionary): return "nobattle"
	if not team_ok(): return "noteam"
	var z = zone(zid); var c = ci()
	var stage = null; var bg = "field"; var nm = T(z.get("n", ["", ""])); var chap = null; var bi = -1
	if kind == "cap":
		if owned(zid): return "done"
		stage = z.get("stage", {"en": ["youhun", "youhun", "youhun"], "boss": "youhun", "p": 1.0})
	else:
		bi = boss_next(zid)
		if bi < 0: return "done"
		var b = bosses(zid)[bi]
		nm = T(b.get("n", ["", ""]))
		if b.get("chapter") is Array: chap = b.chapter
		else: stage = b.get("stage", {})
	var CH = J.G.get("CHAPTERS")
	if CH is Array and c < CH.size(): bg = str(CH[c].get("bg", "field"))
	if not (s.get("cleared") is Dictionary): s["cleared"] = {}
	var ui = J.G.get("UI")
	if ui != null: J.mc(ui, "close", [])
	if chap != null:
		var sid = "%d-%d" % [int(chap[0]) + 1, int(chap[1]) + 1]
		st().exp = {"kind": kind, "ci": float(c), "id": zid, "bi": float(bi), "sid": sid, "had": true, "chap": true}
		J.mc(B, "start", [float(chap[0]), float(chap[1])])
		return "ok"
	var st0 = (stage as Dictionary).duplicate(true)
	st0["name"] = nm
	if not st0.has("boss"): st0["boss"] = str(st0.en[st0.en.size() - 1])
	var sid2 = L("分區", "分區") + "·" + nm
	st().exp = {"kind": kind, "ci": float(c), "id": zid, "bi": float(bi), "sid": sid2, "had": J.t(s.cleared.get(sid2))}
	s.cleared[sid2] = true   # 當「再打」：唔出寶箱（同 mv_war 出征一樣）；結算後清返
	J.mc(B, "start", [-1.0, -1.0, {"stage": st0, "bg": bg, "sid": sid2}])
	return "ok"
static var NEWS: Array = []   # 戰鬥結果（畫面攞嚟出橫額）
# main.gd／畫面每格叫：收戰鬥結果
static func poll() -> Dictionary:
	var s = S()
	if s == null or not (s.get("zone") is Dictionary) or not (s.zone.get("exp") is Dictionary): return {}
	var B = J.G.get("Battle")
	if not (B is Dictionary) or J.str(B.get("sid")) != J.str(s.zone.exp.sid): return {}
	var r = B.get("result")
	if not (r is Dictionary): return {}
	return resolve(J.t(r.get("win")))
static func resolve(win: bool) -> Dictionary:
	var s = S(); var z = st()
	if z == null or not (z.get("exp") is Dictionary): return {}
	var ex = z.exp; z.exp = null
	if not J.t(ex.get("chap")) and s.get("cleared") is Dictionary and not J.t(ex.get("had")): s.cleared.erase(J.str(ex.sid))
	var c = int(J.num(ex.ci)); var zid = str(ex.id)
	var out = {"win": win, "kind": str(ex.kind), "id": zid, "ci": c}
	if win:
		if ex.kind == "cap": z.own[_k(zid, c)] = true
		else:
			var bs = bosses(zid, c); var bi = int(J.num(ex.bi))
			if bi >= 0 and bi < bs.size():
				z.boss[_k(str(bs[bi].id), c)] = true
				out["boss"] = T(bs[bi].get("n", ["", ""]))
	NEWS.append(out)
	_save()
	return out
static func _save() -> void:
	var f = J.G.get("save")
	if f != null: J.cl(f, null, [])

# ---------------- 資源田／加工廠 ----------------
static func bid_zone(bid: String, c := -1) -> String:
	for z in of_type("res", c):
		if bid in _zbids(z): return str(z.id)
	return ""
static func field_def(bid: String) -> Dictionary:
	var zid = bid_zone(bid)
	if zid == "": return {}
	var f = zone(zid).get("fields", {})
	return f.get(bid, {}) if f is Dictionary else {}
static func shop_def(bid: String) -> Dictionary:
	var zid = bid_zone(bid)
	if zid == "": return {}
	var f = zone(zid).get("shops", {})
	return f.get(bid, {}) if f is Dictionary else {}
static func zone_bids(c := -1) -> Array:
	var o = []
	for z in of_type("res", c): o.append_array(_zbids(z))
	return o
# 加工廠：[ok, 要升邊個資源田, 要幾級]
static func shop_req(bid: String) -> Array:
	var sd = shop_def(bid)
	var nd = sd.get("need", {})
	if nd is Dictionary:
		var s = S()
		for b in nd:
			if s == null or J.num(s.bld.get(b, 0)) < float(nd[b]): return [false, str(b), int(nd[b])]
	return [true, "", 0]
# 分區模式：呢個建築用得未（所屬區已佔領；加工廠仲要資源田等級）
static func bid_ok(bid: String) -> bool:
	var zid = bid_zone(bid)
	if zid == "": return true
	if not owned(zid): return false
	if not shop_def(bid).is_empty(): return shop_req(bid)[0]
	return true

# ---------------- 拔營 ----------------
static func can_move_ok(c: int) -> bool:
	if not on_for(c): return true
	return all_bosses_done(c)

# ---------------- 大排檔 layout（mv_data.layout 格式） ----------------
static func mv_layout(c: int) -> Dictionary:
	if _mv_l.has(c): return _mv_l[c]
	var L0 = mdef(c).get("market", {})
	var o = (L0 as Dictionary).duplicate(true)
	_mv_l[c] = o
	return o

# ---------------- 村子座標套用（J.G POS／TREE_POS／PADDY_POS／DECOR／W／WH、廣場鬼範圍、柵欄） ----------------
static func apply() -> void:
	var want = str(ci()) if on() else ""
	if want == _applied: return
	var G = J.G
	if G.get("POS") == null: return
	var PL = G.get("PlazaLife")
	if _orig == null:
		_orig = {"POS": G.POS.duplicate(true), "TREE_POS": G.TREE_POS.duplicate(true), "PADDY_POS": G.PADDY_POS.duplicate(true),
			"DECOR": G.DECOR.duplicate(true), "W": G.W, "WH": G.WH}
		if PL is Dictionary and PL.get("ZA") is Array:
			_orig["ZA"] = PL.ZA.duplicate(); _orig["ZB"] = PL.ZB.duplicate(); _orig["SPOTS"] = PL.SPOTS.duplicate(true)
	var VF = load("res://game/village_fence.gd")
	if want == "":
		G["POS"] = _orig.POS.duplicate(true); G["TREE_POS"] = _orig.TREE_POS.duplicate(true); G["PADDY_POS"] = _orig.PADDY_POS.duplicate(true)
		G["DECOR"] = _orig.DECOR.duplicate(true); G["W"] = _orig.W; G["WH"] = _orig.WH
		if _orig.has("ZA"): _plaza(PL, _orig.ZA, _orig.ZB, _orig.SPOTS.eave, _orig.SPOTS.banana, _orig.SPOTS.bumps)
		VF.reset_cfg()
		_hero(Vector2(195, 350), Rect2(0, 120, 390, 1010))
	else:
		var m = cur(); var v = m.village
		var pos = {}
		for k in v.POS: pos[k] = [float(v.POS[k][0]), float(v.POS[k][1])]
		G["POS"] = pos
		G["TREE_POS"] = _fa(v.TREE_POS); G["PADDY_POS"] = _fa(v.PADDY_POS)
		var dc = []
		for d in v.DECOR: dc.append([str(d[0]), float(d[1]), float(d[2])])
		G["DECOR"] = dc
		G["W"] = float(m.w); G["WH"] = float(m.h)
		var pz = v.plaza
		var eave = {"x": float(pz.eave[0]), "y": float(pz.eave[1]), "ey": float(pz.eave[2])}
		_plaza(PL, pz.ZA, pz.ZB, eave, _fa(pz.banana), _fa(pz.bumps))
		var fc = v.fence
		VF.set_cfg(float(fc.y), float(fc.gate_x), float(fc.gap), fc.spans)
		_hero(v2(v.hero), zrect("village").grow(-16))
	_applied = want
	var CF = load("res://game/outpost/chain_field.gd"); CF.reset()
	var V = G.get("Village")
	if V is Dictionary and V.get("plaza") is Dictionary:   # 廣場鬼：重新擺（舊位喺新圖外面）
		V.erase("plaza")
static func _fa(a: Array) -> Array:
	var o = []
	for p in a:
		var q = []
		for x in p: q.append(float(x))
		o.append(q)
	return o
static func _plaza(PL, za, zb, eave, banana, bumps) -> void:
	if not (PL is Dictionary) or not (PL.get("ZA") is Array): return
	for i in 4: PL.ZA[i] = float(za[i]); PL.ZB[i] = float(zb[i])
	var SP = PL.SPOTS
	if eave is Dictionary: SP.eave["x"] = float(eave.x); SP.eave["y"] = float(eave.y); SP.eave["ey"] = float(eave.ey)
	SP.banana.clear(); for b in banana: SP.banana.append(b.duplicate())
	SP.bumps.clear(); for b in bumps: SP.bumps.append(b.duplicate())
static func _hero(home: Vector2, r: Rect2) -> void:
	var V = J.G.get("Village")
	if not (V is Dictionary) or not (V.get("hero") is Dictionary): return
	var H = V.hero
	if r.has_point(Vector2(J.num(H.x), J.num(H.y))): return
	H["x"] = home.x; H["y"] = home.y; H["tx"] = home.x; H["ty"] = home.y; H["act"] = null; H["target"] = null
	H["zq"] = []
static func applied() -> String: return _applied
static func reset_apply() -> void: _applied = "~"   # 下次 apply 一定重做
