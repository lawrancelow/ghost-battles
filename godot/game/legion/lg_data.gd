# [legion] 八大軍團 54 隻＋軍團據點（每軍團 3 營：雜兵營 → 頭目營 → 軍團王營）（全部 static；冇 class_name、冇 autoload）
#   const LG = preload("res://game/legion/lg_data.gd")
#   數據：data/nat/legion.json（tools/legion/build_legion.py 由 lg_src.py 生成；hm／am 由 tools/balance/apply_bal.py 套 bal_scale.json）
#   掛鈎（全部標 # [legion]）：
#     ng_data.gd install() 尾 → install()（GHOSTS／SKILLS／ENEMY_T／LANG／圖／CHAR_H／SOLID，J.G 同 DB.D 兩邊）
#     abil.gd data() → 讀 legion.json ABIL／ENEMY（只補冇嘅 key）
#     so_data.gd：camps()（掛咗圖先有）、title／short、state 鎖、stage_of 敵陣、dispatch 名牌／射程、path_of 路線
#     soul_data.gd：pin／wish／ch_of 後備、同場兵種一齊掉主魂（co）、sources；soul2.gd 圖鑑自動加格
#   老闆 17:10／17:13：軍團唔放現有 6 張圖；之後掛去新地圖七～十二（ci 6–11，legion.json MAP_OF／CAMPS[].ci）。
#     地圖未做好 → CAMP_ON＝false：SO.camps() 唔會有軍團營（唔顯示）。地圖線接駁時：legion.json CAMP_ON＝true＋每營填 pos／route／dir（或者 attach()）。
#   立繪：assets/spr/<id>.webp（整張圖 plain 模式、面向左＝預設，唔使入 PtChar.PLAIN_R）
extends RefCounted

const PATH := "res://data/nat/legion.json"
const SPR_DIR := "res://assets/spr/"
const LV_RING := [0.0, 1.0, 2.5, 4.0]

static var _D = null
static var installed := false
static var force_on := false          # 測試：當 CAMP_ON
static var _att := {}                 # attach() 動態掛圖：cid → {pos, route, dir}

static func D() -> Dictionary:
	if _D == null:
		_D = {}
		var f = FileAccess.open(PATH, FileAccess.READ)
		if f:
			var j = JSON.parse_string(f.get_as_text())
			if j is Dictionary: _D = j
	return _D
static func reload() -> void: _D = null
static func L(yue: String, zhs: String) -> String: return str(DB.N(zhs if DB.lang != "yue" else yue))
static func T(a) -> String:
	if a is Array and a.size() >= 2: return L(str(a[0]), str(a[1]))
	return str(a) if a != null else ""

# ---------------- 名冊查詢 ----------------
static func keys() -> Array: return D().get("ROSTER3", [])
static func is_lg(k: String) -> bool: return k.begins_with("lg_") and D().get("UNIT", {}).has(k)
static func unit(k: String) -> Dictionary:
	var u = D().get("UNIT", {}).get(k)
	return u if u is Dictionary else {}
static func leg(lg: String) -> Dictionary:
	var g = D().get("LEG", {}).get(lg)
	return g if g is Dictionary else {}
static func legions() -> Array:
	var o = D().get("LEG", {}).keys()
	o.sort_custom(func(a, b): return int(leg(a).get("order", 0)) < int(leg(b).get("order", 0)))
	return o
static func pin(k: String) -> String: return str(D().get("PIN", {}).get(k, ""))
static func wish(k: String) -> Array:
	var w = D().get("WISH", {}).get(k)
	return w if w is Array and w.size() >= 3 else []
static func ch_of(k: String) -> int:   # 招降費用嘅「章」＝所屬地圖（ci 6–11）
	var u = unit(k)
	if u.is_empty(): return -1
	return int(J.num(leg(str(u.lg)).get("ci", 6)))
static func gname(k: String) -> String:
	var g = D().get("GHOSTS", {}).get(k)
	return str(g.get("name", k)) if g is Dictionary else k

# ---------------- 登記（同 ng_data install2 一樣：J.G 同 DB.D 兩邊） ----------------
static func _put(dst, src: Dictionary) -> void:
	if not (dst is Dictionary): return
	for k in src:
		if not dst.has(k): dst[k] = src[k].duplicate(true) if (src[k] is Dictionary or src[k] is Array) else src[k]
static func install() -> void:
	var d = D()
	if d.is_empty(): return
	for tb in ["GHOSTS", "SKILLS", "ENEMY_T"]:
		_put(J.G.get(tb), d.get(tb, {}))
		_put(DB.D.get(tb), d.get(tb, {}))
	var ZH = d.get("LANG_ZH", {})
	var LANG = J.G.get("LANG")
	if LANG != null and ZH.size(): J.mc(LANG, "add", [ZH])
	if DB.D.get("LANG_ZH") is Dictionary: _put(DB.D.LANG_ZH, ZH)
	var ART = J.G.get("ART")
	var CH = J.gp(ART, "CHAR_H") if ART != null else null
	var SO = J.gp(ART, "SOLID") if ART != null else null
	for k in d.get("ART", {}):
		var a = d.ART[k]
		var p = SPR_DIR + str(a.get("spr", k)) + ".webp"
		if Spr._man.get(str(k)) == null and ResourceLoader.exists(p): Spr._man[str(k)] = p; Spr._tex.erase(str(k))
		if CH is Dictionary and not J.t(CH.get(k)): CH[k] = J.num(a.h)
		if SO is Dictionary and J.t(a.get("solid")) and not J.t(SO.get(k)): SO[k] = 1.0
	installed = true

# ---------------- 據點（每軍團 3 營） ----------------
static func camp_def(cid: String) -> Dictionary:
	var c = D().get("CAMPS", {}).get(cid)
	return c if c is Dictionary else {}
static func camps_on() -> bool: return force_on or J.t(D().get("CAMP_ON", false))
# 動態掛圖（地圖線用；唔改 json）：pos＝營地座標、route＝行軍路線（[[x,y]…]，可空）、dir＝方向
static func attach(cid: String, pos: Vector2, route = null, dir := "") -> void:
	_att[cid] = {"pos": pos, "route": route, "dir": dir}
static func detach_all() -> void: _att = {}
# SO 據點條目（同 so_data.camps() 格式：id, ring, lv(難度 p), pos, c；另加 lg／tier／guard／route）
static func entry(cid: String, pos = null, c := -1) -> Dictionary:
	var d = camp_def(cid)
	if d.is_empty(): return {}
	var at = _att.get(cid, {})
	var p = pos
	if p == null: p = at.get("pos") if at.get("pos") is Vector2 else (Vector2(d.pos[0], d.pos[1]) if d.get("pos") is Array and d.pos.size() >= 2 else null)
	if p == null: return {}
	var e = {"id": cid, "ring": int(J.num(d.ring)), "lv": J.num(d.p), "pos": p, "c": int(J.num(d.ci)) if c < 0 else c, "lg": str(d.lg), "tier": int(J.num(d.tier)),
		"guard": str(d.guard), "show_lv": int(J.num(d.get("lv", 0)))}
	var rt = at.get("route", d.get("route"))
	if rt is Array and rt.size() >= 2: e["route"] = rt
	return e
static var _cache := {}
static func camps(c: int) -> Array:   # so_data.camps() 掛鈎：只有 CAMP_ON（或測試 force_on）而且有座標先出現
	if not camps_on(): return []
	var key = "%d:%d" % [c, _att.size()]
	if _cache.has(key) and not force_on: return _cache[key]
	var o = []
	for cid in D().get("CAMPS", {}):
		var d = D().CAMPS[cid]
		if int(J.num(d.get("ci", -1))) != c: continue
		var e = entry(str(cid))
		if not e.is_empty(): o.append(e)
	o.sort_custom(func(a, b): return str(a.id) < str(b.id))
	_cache[key] = o
	return o
static func is_camp(e: Dictionary) -> bool: return str(e.get("lg", "")) != ""
static func title(e: Dictionary) -> String:
	var d = camp_def(str(e.id))
	return L("Lv.%d　%s・%s", "Lv.%d　%s・%s") % [int(d.get("lv", e.lv)), str(leg(str(e.lg)).get("name", "")), T(d.get("n", ["", ""]))]
static func short(e: Dictionary) -> String:
	var d = camp_def(str(e.id))
	return "Lv.%d %s" % [int(d.get("lv", e.lv)), T(d.get("n", ["", ""]))]
# 鎖：頭目營要雜兵營首勝、王營要頭目營首勝
static func locked(e: Dictionary) -> bool:
	if not is_camp(e): return false
	var need = str(camp_def(str(e.id)).get("need", ""))
	if need == "": return false
	var SO = load("res://game/sortie/so_data.gd")
	var pe = {"id": need, "c": int(e.c)}
	return not J.t(SO.cst(pe).get("first"))
# 敵陣：ct 同 counter.json 據點一樣格式（CT.apply_camp 用 hm／am／mk）
static func stage(e: Dictionary, ttl: String) -> Dictionary:
	var d = camp_def(str(e.id))
	var en = (d.get("en", []) as Array).duplicate()
	var ct = {"en": en, "hm": d.get("hm", []), "am": d.get("am", []), "mk": d.get("mk", []), "guard": str(d.get("guard", "")), "gang": str(leg(str(e.lg)).get("name", "")),
		"dir": "", "mech": [], "sys": [str(leg(str(e.lg)).get("sys", ""))], "king": int(J.num(d.get("tier", 1))) == 3}
	return {"name": ttl, "en": en, "boss": "", "p": float(e.lv), "sortie": true, "bg": "field", "ct": ct, "guard": ct.guard, "lg": str(e.lg)}
static func co_of(e: Dictionary) -> Array:   # 同場一齊掉主魂嘅兵種（唔計主魂）
	if not is_camp(e): return []
	var o = []
	for k in camp_def(str(e.id)).get("co", []): if str(k) != str(e.get("guard", "")): o.append(str(k))
	return o
# dispatch 之後：射程、頭目／王旗標同名牌
static func decorate(snap: Dictionary, e: Dictionary) -> void:
	if not is_camp(e): return
	for u in snap.get("units", []):
		if J.num(u.get("side")) != 1: continue
		var un = unit(str(u.get("k", "")))
		if un.is_empty(): continue
		var rg = J.num(un.get("rng", 46))
		if rg > 60: u["range"] = 140.0 if rg >= 150 else rg; u["spd"] = 38.0
		var sl = str(un.get("slot", ""))
		if sl in ["boss", "boss2"]: u["boss"] = true; u["name"] = L("%s（頭目）", "%s（頭目）") % gname(str(u.k))
		elif sl == "king": u["boss"] = true; u["lg_king"] = true; u["name"] = L("%s（軍團王）", "%s（軍團王）") % gname(str(u.k))
		u["lg"] = str(un.get("lg", ""))
# 呢隻鬼喺邊幾個營有主魂（掛咗圖先有）
static func sources(k: String) -> Array:
	var o = []
	if not is_lg(k): return o
	for cid in D().get("CAMPS", {}):
		var d = D().CAMPS[cid]
		if str(d.guard) != k and not (k in d.get("co", [])): continue
		var e = entry(str(cid))
		if e.is_empty() or not camps_on(): continue
		o.append({"e": e, "pri": true, "co": str(d.guard) != k})
	return o
