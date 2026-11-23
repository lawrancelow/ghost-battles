# [cdata] 克制數據讀取：data/nat/counter.json（8 系表、ch_k、24 鬼幫、90 據點）（全部 static；冇 class_name、冇 autoload）
#   const CT = preload("res://game/counter/ct_data.gd")
#   數據由 tools/cdata/build_cdata.py 生成；設計：/home/claude/bs/counter.md 第 3、5、8、10、11 節
#   冇檔／讀唔到／S.ct_off＝true → on() 假，據點敵人同打折全部行返舊路（一鍵回退）
extends RefCounted

const PATH := "res://data/nat/counter.json"
static var D = null

static func data() -> Dictionary:
	if D == null:
		D = {}
		if FileAccess.file_exists(PATH):
			var j = JSON.parse_string(FileAccess.get_file_as_string(PATH))
			if j is Dictionary: D = j
	return D
static func reload() -> void: D = null
static func on() -> bool:
	if data().is_empty(): return false
	var s = J.G.get("S")
	return not (s is Dictionary and J.t(s.get("ct_off", false)))

# ---------- 系／嚇法 ----------
static func sys_info(sy: String) -> Dictionary:
	var t = data().get("sys", {})
	return t.get(sy, {}) if t is Dictionary else {}
static func fear_of_sys(sy: String) -> Dictionary:   # {w:[怕,怕], i:[不怕]}（同 rework.EFEAR 一樣格式）
	var f = sys_info(sy)
	if f.is_empty(): return {}
	return {"w": f.get("fear", []), "i": [f.get("imm", "")], "why": ""}

# ---------- 第 5、6 關打折（SOFT 步驟 A：血、攻分開） ----------
static func ch_k(ci: int, kind := "stage") -> Dictionary:   # 冇＝{}（即唔打折）；據點用 sortie_k（審查修正 10）
	if not on(): return {}
	var t = data().get("sortie_k" if kind == "sortie" else "ch_k", {})
	var k = t.get(str(ci)) if t is Dictionary else null
	if not (k is Dictionary): return {}
	return {"hp": float(k.get("hp", 1.0)), "atk": float(k.get("atk", 1.0))}
static func soften(snap: Dictionary, hk: float, ak: float) -> void:
	if hk >= 1.0 and ak >= 1.0: return
	for u in snap.get("units", []):
		if J.num(u.get("side")) != 1: continue
		var mh = J.num(u.get("maxhp", u.get("hp")))
		u["hp"] = J.num(u.hp) * hk; u["maxhp"] = mh * hk
		u["atk"] = J.num(u.get("atk")) * ak

# ---------- 據點 ----------
static func camp(id: String) -> Dictionary:
	if not on(): return {}
	var cs = data().get("camps", {})
	var c = cs.get(id) if cs is Dictionary else null
	return c if c is Dictionary else {}
static func gang(ci: int, dir: String) -> Dictionary:
	var g = data().get("gangs", {})
	if not (g is Dictionary) or not (g.get(str(ci)) is Dictionary): return {}
	var x = g[str(ci)].get(dir)
	return x if x is Dictionary else {}
# 據點敵人（so_data.stage_of 用）：冇呢個據點／敵人唔齊 → {}（行舊算法）
static func stage_en(id: String) -> Dictionary:
	var c = camp(id)
	if c.is_empty(): return {}
	var ET = J.G.get("ENEMY_T")
	var en = []
	for k in c.get("en", []):
		if ET is Dictionary and not ET.has(str(k)): return {}
		en.append(str(k))
	if en.is_empty(): return {}
	return {"en": en, "hm": c.get("hm", []), "am": c.get("am", []), "mk": c.get("mk", []), "guard": str(c.get("guard", "")), "gang": str(c.get("gang", "")),
		"dir": str(c.get("dir", "")), "mech": c.get("mech", []), "sys": c.get("sys", []), "king": J.t(c.get("king", false))}
# 出擊後：頂替雜兵嘅名鬼按 hm／am 縮細、寫入每隻嘅機制 u.mech；回駐守鬼單位（最後一隻敵方名鬼）
static func apply_camp(snap: Dictionary, st: Dictionary):
	var en: Array = st.get("en", []); var hm: Array = st.get("hm", []); var am: Array = st.get("am", [])
	var i = 0; var last = null
	for u in snap.get("units", []):
		if J.num(u.get("side")) != 1 or J.t(u.get("minion")) or u.get("foe_ml") != null: continue
		if i < en.size() and str(u.get("k")) == str(en[i]):
			var h = float(hm[i]) if i < hm.size() else 1.0; var a = float(am[i]) if i < am.size() else 1.0
			if h != 1.0: u["hp"] = J.num(u.hp) * h; u["maxhp"] = J.num(u.get("maxhp", u.hp)) * h
			if a != 1.0: u["atk"] = J.num(u.atk) * a
			u["camp_i"] = i
			var mk: Array = st.get("mk", [])
			if i < mk.size(): u["mech"] = mk[i]   # 呢隻敵人喺呢個據點實際開嘅機制（ENEMY.mech ∩ 據點上限；abcore 有 u.mech 就用佢）
		i += 1
		last = u
	return last
