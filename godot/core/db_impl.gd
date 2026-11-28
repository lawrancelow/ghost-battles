# 數據表（由網頁版 JS 自動導出：tools/dump_data.js → data/core.json）＋ 對白語言 L()/Lf()
extends Node

var D = {}
var RIGS = {}
var lang = "zh"   # 'zh' 中文 | 'yue' 粵語

func _ready() -> void:
	D = _load("res://data/core.json")
	RIGS = _load("res://data/rigs.json")
	fem_load()
	var cfg = ConfigFile.new()
	if cfg.load("user://settings.cfg") == OK: lang = cfg.get_value("ui", "dialogue_lang", "zh")

func _load(p: String) -> Dictionary:
	var f = FileAccess.open(p, FileAccess.READ)
	if not f: push_error("缺數據 " + p); return {}
	return JSON.parse_string(f.get_as_text())

func t(name: String) -> Variant: return D.get(name)

# 先查 LANG_ZH（用粵語原句做 key），之後先經 N() 換主角名（次序唔可以倒轉）
func L(s: Variant) -> Variant:
	if not (s is String): return s
	if lang != "zh":
		var y = D.get("LANG_YUE", {}).get(s)   # [opening] 中文原句嘅粵語版（story_v2.json "yue"；未填就照出中文）
		return N(y if y != null and y != "" else s)
	var z = D.get("LANG_ZH", {}).get(s)
	return N(z if z != null and z != "" else s)

func Lf(s: String, v: Dictionary = {}) -> String:
	var r: String = L(s)
	for k in v: r = r.replace("{" + k + "}", N(str(v[k])))
	return r

# ---------------- 主角名／性別：顯示時替換（2026-11-18 大改版 A 線） ----------------
# 存檔 S.hero = {"name":"阿福","full":"陳大福","en":"Kelvin","sex":"m","set":false}；冇呢欄／阿福＋男 → N() 原句奉還
# 劇本、對照表、內部鍵（SPEAKER_ART、qx.SPK、ART3、whatsapp who=="阿福"）全部照用「阿福」，只喺出口換
const HERO_M := {"name": "阿福", "full": "陳大福", "en": "Kelvin", "sex": "m", "set": false}
const HERO_F := {"name": "阿慧", "full": "陳嘉慧", "en": "", "sex": "f", "set": false}
const NAME_MAX := 6
const NAME_BAD := "{}[]<>%|\\\"'`=&;"
# 含有呢啲字嘅名唔收（會連環替換，或者撞內部講者鍵）
const NAME_RESERVED := ["阿福", "陳大福", "Kelvin", "少爺", "大小姐", "旁白", "系統", "內文", "我"]
var FEM := {}          # data/fem.json：{原句（粵語原句或中文版）: 女版句}，整句換
var _fem_sub: Array = []   # 長句 key（≥8 字），HTML 等整段文字入面逐句換用
var _nc := {}          # 已換結果快取（主角資料一變就清）
var _nsig := ""

func fem_load() -> void:
	FEM = {}; _fem_sub = []
	if FileAccess.file_exists("res://data/fem.json"):
		var o = _load("res://data/fem.json")
		if o is Dictionary:
			for k in o:
				if str(k).begins_with("_"): continue   # _note 之類註解欄
				if o[k] is String and o[k] != "": FEM[str(k)] = o[k]
	for k in FEM: if k.length() >= 8: _fem_sub.append(k)
	_fem_sub.sort_custom(func(a, b): return a.length() > b.length())
	_nc.clear(); _nsig = ""

# 而家個主角（native：J.G.S；後備模式：G.S）。冇就回 {}
func hero() -> Dictionary:
	var S = J.G.get("S")
	if not (S is Dictionary) or not S.has("hero"):
		var g = get_node_or_null("/root/G")
		S = g.S if g != null else null
	if S is Dictionary and S.get("hero") is Dictionary: return S.hero
	return {}

func hero_female() -> bool: return str(hero().get("sex", "m")) == "f"

func N(s: Variant) -> Variant:
	if not (s is String) or s == "": return s
	var h = hero()
	if h.is_empty(): return s
	var f = str(h.get("sex", "m")) == "f"
	var nm = str(h.get("name", "阿福"))
	if nm == "阿福" and not f and str(h.get("full", "")) in ["", "陳大福"] and str(h.get("en", "")) in ["", "Kelvin"]: return s   # [namefix] 只改全名／英文名都要換
	if nm == "": nm = HERO_F.name if f else HERO_M.name
	var full = str(h.get("full", "")); if full == "": full = nm
	var en = str(h.get("en", "")); if en == "": en = nm
	var sig = "%s|%s|%s|%s" % [nm, full, en, f]
	if sig != _nsig: _nc.clear(); _nsig = sig
	var c = _nc.get(s)
	if c != null: return c
	var r: String = s
	if f:
		var w = FEM.get(s)
		if w != null: r = w
		else:
			for k in _fem_sub:
				if r.length() > k.length() and r.contains(k): r = r.replace(k, FEM[k])
	r = r.replace("陳大福", full).replace("阿福哥", nm + ("姐" if f else "哥")).replace("Kelvin", en).replace("阿福", nm)
	if f: r = r.replace("少爺", "大小姐")
	if _nc.size() > 6000: _nc.clear()
	_nc[s] = r
	return r

# 唔換名：場景本身指緊「另一個阿福」（例如嚇人玩法保安阿伯手機入面嘅舊同事阿福，女線唔應該識女主）
# 喺「阿」同「福」之間插零寬字（U+2060 WORD JOINER），顯示一樣，N() 唔會再認到
const KEEP_MARK := "\u2060"
func keep(s: Variant) -> Variant:
	if not (s is String): return s
	return s.replace("陳大福", "陳大" + KEEP_MARK + "福").replace("阿福", "阿" + KEEP_MARK + "福")

# 名字驗證（B 線改名卡用）：kind = "name"（名／稱呼）| "full"（全名）| "en"（英文名，可留空）
# 回傳 "" = 合格；否則係顯示俾玩家睇嘅原因（跟對白語言）
func name_check(s: String, kind := "name") -> String:
	var t = s.strip_edges()
	var yue = lang == "yue"
	if kind == "en" and t == "": return ""
	if t == "": return "名唔可以留空" if yue else "名字不能留空"
	var mx = 16 if kind == "en" else NAME_MAX
	if t.length() > mx: return ("最多 %d 個字" if yue else "最多 %d 個字") % mx
	for i in t.length():
		var ch = t[i]
		if NAME_BAD.contains(ch) or ch.unicode_at(0) < 32: return ("唔可以用「%s」" if yue else "不能使用「%s」") % ch
	if kind == "en":
		for i in t.length():
			var u = t.unicode_at(i)
			if u > 126: return "英文名只可以用英文字母" if yue else "英文名只能用英文字母"
	for w in NAME_RESERVED:
		if t.contains(w) and not (kind != "name" and w == "我"): return ("「%s」係保留字，換個名啦" if yue else "「%s」是保留字，請換個名字") % w
	return ""

func name_ok(s: String, kind := "name") -> bool: return name_check(s, kind) == ""

# 砌一份 hero（未驗證嘅欄位會用預設）；sex "m"/"f"
func hero_make(name: String, sex := "m", full := "", en := "") -> Dictionary:
	var dflt = HERO_F if sex == "f" else HERO_M
	var base = dflt.duplicate()
	var n = name.strip_edges(); var fu = full.strip_edges(); var e = en.strip_edges()
	if n != "" and name_ok(n): base.name = n
	var renamed = str(base.name) != str(dflt.name)
	if fu != "" and name_ok(fu, "full"): base.full = fu
	elif renamed: base.full = base.name          # 改咗名又冇俾全名：全名都用個名（唔會出「陳大福」）
	if e != "" and name_ok(e, "en"): base.en = e
	elif renamed: base.en = ""                   # 英文名留空 → N() 用返個名
	base.set = true
	return base

# 寫入存檔：S.hero，同步名冊入面 id=="afu" 嗰隻嘅 name（名冊、佩戴、站崗日誌讀 g.name）
func hero_apply(h: Dictionary, S = null) -> void:
	if S == null: S = J.G.get("S")
	if not (S is Dictionary):
		var g = get_node_or_null("/root/G")
		S = g.S if g != null else null
	if not (S is Dictionary): return
	S["hero"] = h.duplicate()
	for gh in S.get("ghosts", []):
		if gh is Dictionary and str(gh.get("id", "")) == "afu": gh["name"] = str(h.get("name", "阿福"))
	_nc.clear(); _nsig = ""

func set_lang(v: String) -> void:
	lang = "yue" if v == "yue" else "zh"
	var cfg = ConfigFile.new(); cfg.load("user://settings.cfg")
	cfg.set_value("ui", "dialogue_lang", lang); cfg.save("user://settings.cfg")
