# [newghost] 新名鬼 26＋牛頭馬面（名鬼）＋大魔王 7＋新雜兵 8＋合體技 25：行起身時登記入遊戲（冇 class_name、冇 autoload）
#   const NG = preload("res://game/newghost/ng_data.gd")
#   數據：data/nat/newghost.json（由 tools/newghost/build_newghost.py 由 ng_src.py 生成；唔改 core.json／data.json，佢哋係網頁版導出）
#   掛鈎：native/patrol_ghosts.gd run() 尾一行 NG.install()（喺 data、n30_data、art 模塊之後）
#   立繪（換圖只改呢度）：assets/spr/<ART[k].spr>.webp（art 線交圖：名鬼 nw_*、大魔王 bm_*、雜兵 zd_*（檔名＝id））
#     未到 → 暫代圖 assets/spr/ng_ph/<ART[k].ph>.webp（tools/newghost/make_placeholders.py 程序畫：墨線＋偏灰病態色＋名）
extends RefCounted

const PATH := "res://data/nat/newghost.json"
const SPR_DIR := "res://assets/spr/"
const PH_DIR := "res://assets/spr/ng_ph/"
const ABIL_GD := "res://game/rts/abil.gd"

static var _D = null
static var installed := false

static func D() -> Dictionary:
	if _D == null:
		_D = {}
		var f = FileAccess.open(PATH, FileAccess.READ)
		if f:
			var j = JSON.parse_string(f.get_as_text())
			if j is Dictionary: _D = j
	return _D
static func reload() -> void: _D = null; _D2 = null
# [roster2] 第二批新名鬼 30 隻：data/nat/newghost2.json（tools/newghost/build_newghost2.py 由 ng_src2.py 生成）；install() 尾一行 install2() 登記
const PATH2 := "res://data/nat/newghost2.json"
static var _D2 = null
static var installed2 := false
static func D2() -> Dictionary:
	if _D2 == null:
		_D2 = {}
		var f = FileAccess.open(PATH2, FileAccess.READ)
		if f:
			var j = JSON.parse_string(f.get_as_text())
			if j is Dictionary: _D2 = j
	return _D2
static func keys2() -> Array: return D2().get("ROSTER2", [])                 # [roster2] 第二批 30
static func roster_all() -> Array:                                            # [roster2] 131 隻（冇第二批就 101）
	var r = D2().get("ROSTER", [])
	return r if r is Array and r.size() else roster()
static func _g2(sec: String, k: String): return D().get(sec, {}).get(k, D2().get(sec, {}).get(k))   # [roster2] 第一批冇就搵第二批

# ---------------- 名冊查詢 ----------------
static func keys() -> Array: return D().get("GHOSTS", {}).keys()          # 新名鬼＋牛頭馬面（28）
static func new_keys() -> Array: return keys().filter(func(k): return str(k).begins_with("nw_"))
static func roster() -> Array: return D().get("ROSTER", [])                # 101 隻
static func boss_keys() -> Array: return D().get("BOSS", {}).keys()
static func fod_keys() -> Array: return D().get("FOD", {}).keys()
static func pin(k: String) -> String: return str(_g2("PIN", k) if _g2("PIN", k) != null else "")
static func abil(k: String) -> Dictionary:
	var a = _g2("ABIL", k)
	return a if a is Dictionary else {}
static func enemy(k: String) -> Dictionary:
	var e = _g2("ENEMY", k)
	return e if e is Dictionary else {}
static func alias(k: String) -> String: return str(D().get("ALIAS", {}).get(k, k))
static func links() -> Array: return D().get("LINK", [])
static func links_all() -> Array: return links() + D2().get("LINK", [])   # [roster2] 25＋第二批 5

# ---------------- 立繪（真圖優先，冇就暫代圖） ----------------
static func spr_path(k: String) -> String:
	var a = _g2("ART", k)
	if not (a is Dictionary): return ""
	var real = SPR_DIR + str(a.spr) + ".webp"
	if ResourceLoader.exists(real): return real
	return PH_DIR + str(a.ph) + ".webp"
static func is_placeholder(k: String) -> bool: return spr_path(k).begins_with(PH_DIR)
static func placeholders() -> Array:
	var o = []
	for k in D().get("ART", {}): if is_placeholder(str(k)): o.append(str(k))
	for k in D2().get("ART", {}): if is_placeholder(str(k)): o.append(str(k))   # [roster2]
	return o

static func _art(d = null) -> void:
	if d == null: d = D()   # [roster2] 第二批共用
	var ART = J.G.get("ART")
	var CH = J.gp(ART, "CHAR_H") if ART != null else null
	var SO = J.gp(ART, "SOLID") if ART != null else null
	for k in d.get("ART", {}):
		var a = d.ART[k]
		var cur = Spr._man.get(str(k))
		if cur == null or str(cur).begins_with(PH_DIR):   # spr_manifest 已有真圖（例如牛頭馬面、日後 art 線登記）就唔郁
			Spr._man[str(k)] = spr_path(str(k)); Spr._tex.erase(str(k))
		if CH is Dictionary and not J.t(CH.get(k)): CH[k] = J.num(a.h)
		if SO is Dictionary and J.t(a.get("solid")) and not J.t(SO.get(k)): SO[k] = 1.0

# ---------------- 登記（GHOSTS／SKILLS／ENEMY_T／COMBOS／LANG；J.G 同 DB.D 兩邊都要） ----------------
static func _put(dst, src: Dictionary, over := false) -> void:
	if not (dst is Dictionary): return
	for k in src:
		if over or not dst.has(k): dst[k] = src[k].duplicate(true) if (src[k] is Dictionary or src[k] is Array) else src[k]
static func _combos(arr, d = null) -> void:
	if d == null: d = D()   # [roster2]
	if not (arr is Array): return
	var have = {}
	for c in arr: if c is Dictionary: have[str(c.get("id", ""))] = true
	for c in d.get("COMBOS_OLD", []): if not have.has(str(c.id)): arr.append(c.duplicate(true))

static func install() -> void:
	var d = D()
	if d.is_empty(): return
	for tb in ["GHOSTS", "SKILLS", "ENEMY_T"]:
		_put(J.G.get(tb), d.get(tb, {}))
		_put(DB.D.get(tb), d.get(tb, {}))
	_combos(J.G.get("COMBOS")); _combos(DB.D.get("COMBOS"))
	var ZH = d.get("LANG_ZH", {})
	var LANG = J.G.get("LANG")
	if LANG != null and ZH.size(): J.mc(LANG, "add", [ZH])
	if DB.D.get("LANG_ZH") is Dictionary: _put(DB.D.LANG_ZH, ZH)
	_art()
	merge_abil()
	installed = true
	install2()   # [roster2] 第二批 30 隻（newghost2.json）
	load("res://game/legion/lg_data.gd").install()   # [legion] 八大軍團 54 隻（legion.json）

# [roster2] 同 install() 一樣登記第二批（GHOSTS／SKILLS／ENEMY_T／COMBOS／LANG／圖／ABIL／ENEMY／LINK）
static func install2() -> void:
	var d = D2()
	if d.is_empty(): return
	for tb in ["GHOSTS", "SKILLS", "ENEMY_T"]:
		_put(J.G.get(tb), d.get(tb, {}))
		_put(DB.D.get(tb), d.get(tb, {}))
	_combos(J.G.get("COMBOS"), d); _combos(DB.D.get("COMBOS"), d)
	var ZH = d.get("LANG_ZH", {})
	var LANG = J.G.get("LANG")
	if LANG != null and ZH.size(): J.mc(LANG, "add", [ZH])
	if DB.D.get("LANG_ZH") is Dictionary: _put(DB.D.LANG_ZH, ZH)
	_art(d)
	merge_abil(null, d)
	installed2 = true

# abcore 嘅 abil.gd（data/abil.json）：ABIL／ENEMY 只加冇嘅 key；LINK 只加冇嘅 id（ABIL 段歸 newghost＋cdata；唔郁舊條目）
static func merge_abil(A = null, d = null) -> void:
	if A == null:
		if not ResourceLoader.exists(ABIL_GD): return
		var AB = load(ABIL_GD)
		if AB == null or not AB.has_method("data"): return
		A = AB.data()
	if not (A is Dictionary) or A.is_empty(): return
	if d == null: d = D()   # [roster2] 第二批共用
	for sec in ["ABIL", "ENEMY"]:
		if not (A.get(sec) is Dictionary): A[sec] = {}
		for k in d.get(sec, {}): if not A[sec].has(k): A[sec][k] = d[sec][k]
	if not (A.get("LINK") is Array): A["LINK"] = []
	var have = {}
	for x in A.LINK: if x is Dictionary: have[str(x.get("id", ""))] = true
	for x in d.get("LINK", []): if not have.has(str(x.id)): A.LINK.append(x)

# ---------------- 能力（abil.json 有就用；冇就用本檔；再冇就舊 SKILLS 自動轉換） ----------------
static func abil_of(k: String) -> Dictionary:
	if ResourceLoader.exists(ABIL_GD):
		var AB = load(ABIL_GD)
		if AB != null and AB.has_method("abil"):
			var a = AB.abil(k)
			if a is Dictionary and not a.is_empty(): return a
	var b = abil(k)
	if not b.is_empty(): return b
	var sk = J.G.get("SKILLS")
	var s = sk.get(k) if sk is Dictionary else null
	return {"legacy": s} if s is Dictionary else {}

# ---------------- 台詞（每隻名鬼一句；名冊 101 隻） ----------------
static func say_of(k: String) -> String:
	var g = J.G.get("GHOSTS")
	var e = g.get(k) if g is Dictionary else null
	var s = str(e.get("say", "")) if e is Dictionary and e.get("say") != null else ""
	if s != "": return s
	var a = abil_of(k).get("say")
	if a is Array and a.size(): return str(a[0])
	if a is String: return a
	return str(D().get("SAY_FB", {}).get(k, ""))   # 主線 12 隻：cdata ABIL.say 後備

# ---------------- 合體技觸發（一隊最多 3 隻名鬼） ----------------
# team：鬼 key 陣列；回 [{id, name, kind, n}]（n＝同場成員數，用嚟揀 fx3 加強）
static func active_links(team: Array) -> Array:
	var o = []
	var ks = {}
	for x in team: ks[str(x)] = true
	for L in links_all():   # [roster2]
		var n = 0
		for m in L.m: if ks.has(str(m)): n += 1
		if n < int(L.need): continue
		var ok = true
		for m in L.get("must", []): if not ks.has(str(m)): ok = false
		if ok: o.append({"id": str(L.id), "name": str(L.name), "kind": str(L.kind), "n": n})
	return o
