# 原生改寫自 lang.js：對白語言（中文預設／粵語）。LANG.ZH[粵語原句] = 中文；L(s)、Lf(s, v)
# 加入對照表時同步落 DB.D.LANG_ZH（原生劇情框 DB.L 用）
extends RefCounted

static var cur := "zh"
static var ZH := {}
static var subs: Array = []

# 查完對照表（粵語原句做 key）先經 DB.N() 換主角名／女版句
static func L(s):
	if typeof(s) != TYPE_STRING: return s
	if cur != "zh": return DB.N(s)
	var t = ZH.get(s)
	return DB.N(t if t != null and J.str(t) != "" else s)

static func Lf(s, v):
	var r = L(s)
	if J.t(v):
		for k in J.keys(v): r = J.str(r).replace("{" + J.str(k) + "}", J.str(DB.N(J.str(J.gp(v, k)))))
	return r

static func set_lang(v) -> void:
	cur = "yue" if J.str(v) == "yue" else "zh"
	J.S_localStorage_("setItem", ["gb_dialogue_lang", cur])
	for f in subs.duplicate(): J.cl(f, null, [cur])

static func add(t) -> void:
	if not (t is Dictionary): return
	var dz = DB.D.get("LANG_ZH")
	for k in t:
		ZH[k] = t[k]
		if dz is Dictionary: dz[k] = t[k]

func run(_env) -> void:
	cur = "zh"; ZH = {}; subs = []
	var v = J.S_localStorage_("getItem", ["gb_dialogue_lang"])
	if J.str(v) == "zh" or J.str(v) == "yue": cur = J.str(v)
	var LANG = {
		"ZH": ZH,
		"set": func(_t, a): set_lang(J.arg(a, 0)); return null,
		"toggle": func(_t, _a): set_lang("yue" if cur == "zh" else "zh"); return cur,
		"on": func(_t, a): subs.append(J.arg(a, 0)); return null,
		"add": func(_t, a): add(J.arg(a, 0)); return null,
		"name": func(_t, _a): return "中文" if cur == "zh" else "粵語",
		"__getters": {"cur": func(_t, _a): return cur},
	}
	J.G["LANG"] = LANG
	J.G["L"] = func(_t, a): return L(J.arg(a, 0))
	J.G["Lf"] = func(_t, a): return Lf(J.arg(a, 0), J.arg(a, 1))
