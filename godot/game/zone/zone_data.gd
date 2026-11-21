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
static var _pos_ref = null          # [hotfix12] 套用嗰陣嘅 J.G.POS／TREE_POS（重開局／匯入存檔會換新 dict，要重新套用）
static var _tree_ref = null
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
		if z.get("door") is Dictionary and rect(z.door.get("vis", z.door.rect)).grow(6).has_point(p): return str(z.id)   # [zone2] vis：畫閘嗰格（第 3 關石階平台好闊）
	return ""

# ---------------- 狀態 ----------------
static func st():
	var s = S()
	if s == null: return null
	if not (s.get("trees") is Array) or s.trees.size() < 8 or not (s.get("paddy") is Array) or s.paddy.size() < 6: pad_fields(s)   # [fogfix]
	if not (s.get("zone") is Dictionary): s["zone"] = {"v": 1.0, "own": {}, "boss": {}, "exp": null}
	var z = s.zone
	for k in ["own", "boss"]: if not (z.get(k) is Dictionary): z[k] = {}
	if int(J.num(z.get("mig", 0))) < 1: _migrate(s, z)
	if int(J.num(z.get("mig", 0))) < 2: _migrate2(s, z)
	if int(J.num(z.get("mig", 0))) < 3: _migrate3(s, z)
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
	var cur = int(J.num(s.mv.get("ci", 0))) if s.get("mv") is Dictionary else 0
	for ck in D().maps:
		var c = int(ck)
		if c > cur: continue   # [zone2] 未去到嘅圖唔送（同一個建築 id 第 2–4 關會再出現）
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
# [zone2] 第 2–4 關加入之後再遷移一次（舊存檔已經行過 v1）：只處理而家所在嘅圖同之前嘅圖（未去到嘅圖照新開始，唔送）；
#   已開墾資源田／已起加工廠 → 該區已佔領；世界地圖已打低嘅主 Boss → 對應王（連前面嘅）已打低。等級、派鬼唔郁。
static func _migrate2(s: Dictionary, z: Dictionary) -> void:
	z["mig"] = 2.0
	var bld = s.get("bld") if s.get("bld") is Dictionary else {}
	var cur = int(J.num(s.mv.get("ci", 0))) if s.get("mv") is Dictionary else 0
	for ck in D().maps:
		var c = int(ck)
		if c == 0 or c > cur: continue
		for zz in zones(c):
			if str(zz.get("type")) == "res":
				for b in _zbids(zz): if J.num(bld.get(b, 0)) > 0: z.own[_k(str(zz.id), c)] = true
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
	ev("zone_cap", zid)   # [zone2] 劇情
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
	if kind == "boss":   # [zone2] 王開戰前：先播劇情（boss_pre），播完先入戰鬥
		var bi0 = boss_next(zid)
		if bi0 >= 0 and team_ok() and S() != null and J.G.get("Battle") is Dictionary:
			var bid0 = str(bosses(zid)[bi0].id)
			var r0 = ["ok"]
			ev("boss_pre", bid0, func(): r0[0] = _start_battle(kind, zid))
			return r0[0]
	return _start_battle(kind, zid)
static func _start_battle(kind: String, zid: String) -> String:
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
		var go = func(): J.mc(B, "start", [float(chap[0]), float(chap[1])])
		if not _mb().start(kind, zid, go, {"bid": str(bosses(zid)[bi].id)}): go.call()   # [mapbattle] 喺大地圖打（勝利＝原關卡通關）
		return "ok"
	var st0 = (stage as Dictionary).duplicate(true)
	st0["name"] = nm
	if not st0.has("boss"): st0["boss"] = str(st0.en[st0.en.size() - 1])
	var sid2 = L("分區", "分區") + "·" + nm
	st().exp = {"kind": kind, "ci": float(c), "id": zid, "bi": float(bi), "sid": sid2, "had": J.t(s.cleared.get(sid2))}
	s.cleared[sid2] = true   # 當「再打」：唔出寶箱（同 mv_war 出征一樣）；結算後清返
	var ET = J.G.get("ENEMY_T")   # 敵人表冇呢隻（例如 n30 鬼未登記）→ 用遊魂頂
	if ET is Dictionary:
		var en2 = []
		for e in st0.en: en2.append(str(e) if ET.has(str(e)) else "youhun")
		st0["en"] = en2
		if not ET.has(str(st0.boss)): st0["boss"] = en2[en2.size() - 1]
	var go2 = func(): J.mc(B, "start", [-1.0, -1.0, {"stage": st0, "bg": bg, "sid": sid2}])
	if not _mb().start(kind, zid, go2, {"bid": str(bosses(zid)[bi].id) if kind == "boss" else ""}): go2.call()   # [mapbattle]
	if kind == "boss" and bi >= 0 and J.t(bosses(zid)[bi].get("rename")):   # 王喺戰鬥入面顯示呢度嘅名（例如「亂葬崗守墓鬼」）
		for u in J.iter(B.get("units")):
			if J.t(J.gp(u, "boss")): u["name"] = nm
	return "ok"
static func _mb(): return load("res://game/zone/zone_battle.gd")   # [mapbattle] 大地圖即時戰鬥
static var NEWS: Array = []   # 戰鬥結果（畫面攞嚟出橫額）
# main.gd／畫面每格叫：收戰鬥結果
static func poll() -> Dictionary:
	reveal_poll()   # [fogfix] 跟主線逐步解霧
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
				out["bid"] = str(bs[bi].id)
	NEWS.append(out)
	_save()
	if win and c == ci():   # [zone2] 劇情
		if ex.kind == "cap": ev("zone_cap", zid)
		elif out.has("bid"):
			ev("boss_win", str(out.bid))
			if all_bosses_done(c): _ev_once("liberate", "")
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

# 測試用：當呢張圖全部野外王已打低
static func mark_all_bosses(c := 0) -> void:
	var s = st()
	if s == null: return
	for z in of_type("wild", c):
		for b in z.get("bosses", []): s.boss[_k(str(b.id), c)] = true
static func unmark_bosses(c := 0) -> void:
	var s = st()
	if s == null: return
	for z in of_type("wild", c):
		for b in z.get("bosses", []): s.boss.erase(_k(str(b.id), c))
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
	var G = J.G
	if want == _applied and is_same(G.get("POS"), _pos_ref) and is_same(G.get("TREE_POS"), _tree_ref): return
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
		pad_fields(G.get("S"), v.TREE_POS.size(), v.PADDY_POS.size())   # [fogfix] 舊存檔：樹／稻田格數唔夠就補
		var dc = []
		for d in v.DECOR: dc.append([str(d[0]), float(d[1]), float(d[2])])
		G["DECOR"] = dc
		G["W"] = float(m.w); G["WH"] = float(m.h)
		var pz = v.plaza
		var eave = {"x": float(pz.eave[0]), "y": float(pz.eave[1]), "ey": float(pz.eave[2])}
		_plaza(PL, pz.ZA, pz.ZB, eave, _fa(pz.banana), _fa(pz.bumps))
		var fc = v.fence
		if J.t(fc.get("off")): VF.set_cfg(-1e6, -1e6, 0.0, [[-10.0, -10.0], [-10.0, -10.0]])   # [zone2] 出村門唔喺北面：舊橫柵欄唔用
		else: VF.set_cfg(float(fc.y), float(fc.gate_x), float(fc.gap), fc.spans)
		_hero(v2(v.hero), zrect("village").grow(-16))
	_applied = want
	_pos_ref = G.get("POS"); _tree_ref = G.get("TREE_POS")
	var CF = load("res://game/outpost/chain_field.gd"); CF.reset()
	var V = G.get("Village")
	if V is Dictionary and V.get("plaza") is Dictionary:   # 廣場鬼：重新擺（舊位喺新圖外面）
		V.erase("plaza")
# [fogfix] 存檔 S.trees／S.paddy（＋Regrow）格數唔夠就補：新補嘅樹 3 血、稻田熟咗；已有嘅格（已砍／已割）照舊對應索引
static func pad_fields(s, nt := 8, np := 6) -> void:
	if not (s is Dictionary): return
	nt = maxi(nt, 8); np = maxi(np, 6)
	for kv in [["trees", nt, 3.0], ["treeRegrow", nt, 0.0], ["paddy", np, 1.0], ["paddyRegrow", np, 0.0]]:
		if not (s.get(kv[0]) is Array): s[kv[0]] = []
		var a: Array = s[kv[0]]
		while a.size() < int(kv[1]): a.append(kv[2])
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

# ================= [zone2] 劇情事件（zone 線 ↔ 劇情線 zstory 約定） =================
# 喺以下時刻叫 MS.zone_event(kind, id[, cb])（MS＝mv_scene.story，即 mv_story.gd 實例；冇就跳過，唔報錯）：
#   map_enter（第一次見到呢關新地圖）、zone_seen（第一次鏡頭見到某資源區／野外區）、zone_cap（佔領資源區）、
#   boss_pre（王開戰前；cb＝開戰，劇情播完先 call）、boss_win（打低王）、factory（二級廠解鎖，id＝資源區 id）、liberate（全部王打低）
#   id＝zones.json 嘅 zone id／boss id（每張圖嘅清單喺 maps[ci].events）。
static var EV_LOG: Array = []   # 測試用：[[kind, id, ci], …]
static var hook = null   # 測試用：代替劇情線（有 zone_event(kind, id, cb) 方法嘅物件）
static var _ms = null
static var _ms_ok := -1
# 劇情線接口（branch zstory）：MS = load("res://game/outpost/mv_story.gd")；MS.zone_ev(kind, id, cb) 係 static；冇就回 null（唔報錯）
static func _story():
	if hook != null: return hook
	if _ms_ok < 0:
		_ms_ok = 0
		if ResourceLoader.exists("res://game/outpost/mv_story.gd"):
			_ms = load("res://game/outpost/mv_story.gd")
			for f in _ms.get_script_method_list(): if str(f.get("name", "")) == "zone_ev": _ms_ok = 1
	return _ms if _ms_ok == 1 else null
# 回 true＝cb 會由劇情播完先 call；false＝cb 已經即刻 call 咗
static func ev(kind: String, id := "", cb := Callable()) -> bool:
	EV_LOG.append([kind, id, ci()])
	var st = _story()
	if st != null and kind != "map_enter":   # map_enter：劇情線自己睇 ZD.on_for(ci) 播開場，唔使叫
		if hook != null: return J.t(hook.zone_event(kind, id, cb))
		return J.t(st.zone_ev(kind, id, cb))
	if cb.is_valid(): cb.call()
	return false
# 每張存檔每個事件只發一次（S.zone.sent）
static func _ev_once(kind: String, id: String) -> void:
	var z = st()
	if z == null: return
	if not (z.get("sent") is Dictionary): z["sent"] = {}
	var k = "%d:%s:%s" % [ci(), kind, id]
	if z.sent.has(k): return
	var st0 = _story()
	if st0 != null:   # 有劇情線先記「發咗」（劇情線未上之前唔好食咗啲事件）
		z.sent[k] = 1.0
		ev(kind, id)
	elif not _logged.has(k):
		_logged[k] = true
		EV_LOG.append([kind, id, ci()])
static var _logged := {}
# 畫面每格叫（zone_view.draw_over）：map_enter、zone_seen（鏡頭第一次見到某區三成或者區中心）、factory（加工廠條件啱咗）、liberate
static var _watch_t := 0
static func watch(view: Rect2) -> void:
	if not on(): return
	_watch_t += 1
	if _watch_t % 6 != 0: return
	reveal_poll(true)
	_ev_once("map_enter", "")
	for z in zones():
		var tp = str(z.get("type"))
		if tp != "res" and tp != "wild": continue
		var r = rect(z.rect); var a = r.intersection(view).get_area()
		if not revealed(str(z.id)): continue   # [fogfix] 未解霧（未介紹）嘅區唔發 zone_seen
		if gate_on and z.get("reveal") is Dictionary: continue   # [fogfix] 有解霧條件嘅區：zone_seen 喺解霧嗰刻發（reveal_poll），唔跟鏡頭
		if view.has_point(r.get_center()) or a >= minf(r.get_area(), view.get_area()) * 0.3: _ev_once("zone_seen", str(z.id))
	for z in of_type("res"):
		if not owned(str(z.id)): continue
		for b in (z.get("shops", {}) as Dictionary):
			if shop_req(str(b))[0]: _ev_once("factory", str(z.id))
	if all_bosses_done(): _ev_once("liberate", "")
static func events(c := -1) -> Array:
	var e = mdef(ci() if c < 0 else c).get("events", [])
	return e if e is Array else []

# ================= [fogfix] 跟主線逐步解霧（出村門外：大排檔／野外區／資源區） =================
# zones.json 每區可以有 "reveal"：{條件, "hint": [粵, 中]}；冇 reveal ＝ 一開始就見到。條件（任何一個中就解）：
#   "always": true                        一開始就開
#   "bld": "<建築id>"                     村子嗰間建築起咗（等級 ≥ 1）
#   "quest_done": ["<t>", "<b 或 s>"]      主線任務（D.QUESTS 搵 t＋b／s 嗰個）已完成（S.qi 過咗佢）
#   "quest_at": ["<t>", "<b 或 s>"]        主線任務已經去到（S.qi ≥ 佢）；stage 類：S.cleared 有都算
#   "enter": true                         呢關開場劇情（mv_story map_enter beat）播完／跳過（冇劇情線／自動播關 → 當播完）
#   "with": "<zone id>"                   跟另一區一齊開
# 解咗記入 S.zone.rev["<ci>:<zid>"]（唔會再蓋返）；解霧嗰刻：REVEALED 記時間（霧散動畫）＋ REV_NEWS（橫額）＋ ev("reveal", zid)（劇情線可以掛）。
# 舊存檔（mig 3）：已經過咗嘅圖全開；而家喺第 2–4 關＝全開；而家喺第 1 關＝按條件即刻默默解（唔播動畫）。
# 自動化測試（GB_TEST）預設唔閘（gate_on = false，其他線測試照舊睇到成張圖）；fogfix_test 自己打開。
static var gate_on := not OS.has_environment("GB_TEST")
static var REVEALED := {}   # "<ci>:<zid>" → 解霧嗰刻（Time.get_ticks_msec）
static var REV_NEWS: Array = []   # 待出橫額：[zid, ci]
static var _rev_t := 0
static func _rev() -> Dictionary:
	var z = st()
	if z == null: return {}
	if not (z.get("rev") is Dictionary): z["rev"] = {}
	return z.rev
static func revealed(zid: String, c := -1) -> bool:
	if not gate_on or not on_for(ci() if c < 0 else c): return true
	var z = zone(zid, c)
	if z.is_empty() or str(z.get("type")) == "village" or not (z.get("reveal") is Dictionary): return true
	return J.t(_rev().get(_k(zid, c)))
static func wild_open(c := -1) -> bool:   # 有任何一個野外區已解霧（未有就冇鬼潮）
	if not gate_on or not on_for(ci() if c < 0 else c): return true
	for z in of_type("wild", c): if revealed(str(z.id), c): return true
	return of_type("wild", c).is_empty()
static func reveal_hint(zid: String, c := -1) -> String:
	var r = zone(zid, c).get("reveal")
	if r is Dictionary and r.get("quest_done") is Array:   # 按任務名自動生成：「完成主線任務「升到 3 級」後開放」
		var q = _quest(str(r.quest_done[0]), str(r.quest_done[1]))
		if not q.is_empty():
			var tx = str(q.get("text", ""))
			if str(zone(zid, c).get("type")) == "market": return L("出村門未開：完成主線任務「%s」先出得村", "出村門未開放：完成主線任務「%s」後才能出村") % tx
			return L("完成主線任務「%s」後開放", "完成主線任務「%s」後開放") % tx
	if r is Dictionary and r.get("beat_t") != null:   # 「睇完劇情「甘榜開檔」後開放」
		var bb = beat_of(str(r.beat_t), ci() if c < 0 else c)
		var tl = bb.get("scene", {}).get("title") if bb.get("scene") is Dictionary else null
		if tl != null and T(tl) != "": return L("睇完劇情「%s」先開放", "看完劇情「%s」後開放") % T(tl)
	if r is Dictionary and r.get("hint") != null: return T(r.hint)
	return L("呢度仲未開放，跟住主線任務行落去就會開", "這裡還沒開放，跟著主線任務走就會開放")
static func _quest(t: String, key: String) -> Dictionary:
	var i = _qidx(t, key)
	var Q = J.G.get("QUESTS")
	return Q[i] if i >= 0 and Q is Array and Q[i] is Dictionary else {}
static func _qidx(t: String, key: String) -> int:
	var Q = J.G.get("QUESTS")
	if not (Q is Array): return -1
	for i in Q.size():
		var q = Q[i]
		if q is Dictionary and str(q.get("t")) == t and (str(q.get("b", "")) == key or str(q.get("s", "")) == key or (q.get("n") != null and t == "level" and str(int(J.num(q.n))) == key)): return i
	return -1
static func _enter_done(c: int) -> bool:
	var MS = _story()
	if MS == null or hook != null: return true
	if not MS.auto_on: return true
	var eb = MS.enter_beat(c)
	return eb.is_empty() or MS.is_seen(str(eb.get("id", "")))
# "beat_t"：呢關第一個 when.t＝佢嘅大排檔劇情（open／unlock／sold…）播完／跳過（冇劇情線／自動播關 → 當播完）
static func beat_of(t: String, c: int) -> Dictionary:
	var MS = _story()
	if MS == null or hook != null: return {}
	for b in MS.beats(c):
		if b is Dictionary and b.get("when") is Dictionary and str(b.when.get("t", "")) == t: return b
	return {}
static func _beat_done(t: String, c: int) -> bool:
	var MS = _story()
	if MS == null or hook != null: return true
	if not MS.auto_on: return true
	var b = beat_of(t, c)
	return b.is_empty() or MS.is_seen(str(b.get("id", "")))
static func cond_ok(zid: String, c := -1) -> bool:
	var z = zone(zid, c); var cc = ci() if c < 0 else c
	var r = z.get("reveal")
	if not (r is Dictionary): return true
	var s = S()
	if s == null: return false
	if J.t(r.get("always")): return true
	if r.get("bld") != null and J.num(s.bld.get(str(r.bld), 0)) >= 1: return true
	var qi = int(J.num(s.get("qi", 0)))
	if r.get("quest_done") is Array:
		var t0 = str(r.quest_done[0]); var k0 = str(r.quest_done[1])
		var i = _qidx(t0, k0)
		if i >= 0 and qi > i: return true
		var q = _quest(t0, k0)   # 舊存檔／任務次序唔同：按狀態判斷任務係咪已經做咗
		match t0:
			"level": if J.num(s.get("lv", 1)) >= float(k0) and qi > 0: return true
			"stage": if s.get("cleared") is Dictionary and J.t(s.cleared.get(k0)): return true
			"build": if J.num(s.bld.get(k0, 0)) >= 1: return true
			"bLevel": if not q.is_empty() and J.num(s.bld.get(k0, 0)) >= J.num(q.get("n", 99)): return true
	if r.get("quest_at") is Array:
		var i2 = _qidx(str(r.quest_at[0]), str(r.quest_at[1]))
		if i2 >= 0 and qi >= i2: return true
		if str(r.quest_at[0]) == "stage" and s.get("cleared") is Dictionary and J.t(s.cleared.get(str(r.quest_at[1]))): return true
	if J.t(r.get("enter")) and _enter_done(cc): return true
	if r.get("beat_t") != null and _beat_done(str(r.beat_t), cc): return true
	if r.get("with") != null and str(r.with) != zid and revealed(str(r.with), c): return true
	return false
# 解霧檢查（ZD.poll 每格、watch 每 6 格；quiet＝唔播動畫／橫額）
static func reveal_poll(force := false, quiet := false) -> Array:
	var out = []
	if not gate_on or not on(): return out
	_rev_t += 1
	if not force and _rev_t % 10 != 0: return out
	var rv = _rev()
	var c = ci()
	for _pass in 2:   # "with" 鏈：兩輪
		for z in zones(c):
			var zid = str(z.id)
			if not (z.get("reveal") is Dictionary) or J.t(rv.get(_k(zid, c))): continue
			if not cond_ok(zid, c): continue
			rv[_k(zid, c)] = 1.0; out.append(zid)
			if not quiet:
				REVEALED[_k(zid, c)] = Time.get_ticks_msec()
				REV_NEWS.append([zid, c])
				ev("reveal", zid)
				if str(z.get("type")) in ["res", "wild"]: _ev_once("zone_seen", zid)   # 介紹劇情：解霧先排（劇情線逐個播，唔連播）
	if out.size(): _save()
	return out
# 測試／除錯：成張圖即刻解
static func reveal_all(c := -1, quiet := true) -> void:
	var cc = ci() if c < 0 else c
	var rv = _rev()
	for z in zones(cc):
		if z.get("reveal") is Dictionary and not J.t(rv.get(_k(str(z.id), cc))):
			rv[_k(str(z.id), cc)] = 1.0
			if not quiet: REVEALED[_k(str(z.id), cc)] = Time.get_ticks_msec(); REV_NEWS.append([str(z.id), cc])
# 解霧動畫進度：0＝啱啱解、1＝散晒（未解／好耐之前解 → 1）
static func reveal_k(zid: String, c := -1, dur := 1800.0) -> float:
	var t0 = REVEALED.get(_k(zid, c))
	if t0 == null: return 1.0
	return clampf(float(Time.get_ticks_msec() - int(t0)) / dur, 0.0, 1.0)
static func _migrate3(s: Dictionary, z: Dictionary) -> void:
	z["mig"] = 3.0
	if not (z.get("rev") is Dictionary): z["rev"] = {}
	var cur = int(J.num(s.mv.get("ci", 0))) if s.get("mv") is Dictionary else 0
	var old = int(J.num(s.get("qi", 0))) > 0 or J.num(s.get("lv", 1)) > 1 or (s.get("cleared") is Dictionary and (s.cleared as Dictionary).size() > 0)
	for ck in D().maps:
		var c = int(ck)
		if c < cur or (c == cur and c > 0 and old):
			for zz in zones(c):
				if zz.get("reveal") is Dictionary: z.rev[_k(str(zz.id), c)] = 1.0
	# 而家喺第 1 關：按條件默默解（進度已經過咗解鎖點嘅舊存檔即刻全開，唔播動畫）
	if cur == 0 or not old:
		for _p in 2:
			for zz in zones(cur):
				var zid = str(zz.id)
				if zz.get("reveal") is Dictionary and not J.t(z.rev.get(_k(zid, cur))) and cond_ok(zid, cur): z.rev[_k(zid, cur)] = 1.0
