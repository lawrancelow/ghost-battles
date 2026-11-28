# [tavern] 普通鬼生成器：種子決定一切（外觀部件、名字、死因梗、口頭禪、三圍、稀有度）。
# 冇 class_name、冇 autoload（熱更新規矩）：用 load("res://game/tavern/tv_gen.gd") 叫 static func。
#
# gen(seed, rar, avoid) → {seed, rar, name, gag, cp, look:{body,face,hair,cloth,acc,tint,rcloth,halo}, st:[力,智,武], k(現有雜鬼外觀鍵，美術部件未到前用嚟畫)}
#   rar：0 普通／1 好／2 出眾；-1 ＝ 由種子擲（按 RAR.p）
#   avoid：{names:{}, cps:{}}（同一畫面已用嘅名、口頭禪）→ 撞到就重抽，最多 10 次，再撞就揀下一個未用嘅
# named(id, seed) → 15 隻有名字稀有鬼（文案組 story_v2 §4.4）
# 同一隻鬼一經生成就存檔固定（存成 S.ghosts[i].gen），唔會每次打開都變。
extends RefCounted

const PATH := "res://data/tavern.json"
static var _D = null

static func D() -> Dictionary:
	if _D == null:
		var o = JSON.parse_string(FileAccess.get_file_as_string(PATH)) if FileAccess.file_exists(PATH) else null
		_D = o if o is Dictionary else {}
	return _D
static func yue() -> bool: return DB.lang == "yue"
static func P(pair) -> String:
	if pair is Array and pair.size() >= 2: return str(pair[0]) if yue() else str(pair[1])
	return str(pair) if pair != null else ""

static func _rng(seed: int) -> RandomNumberGenerator:
	var r = RandomNumberGenerator.new(); r.seed = seed; return r
static func _pick(r: RandomNumberGenerator, a: Array):
	return a[r.randi_range(0, a.size() - 1)] if a.size() else null

static func roll_rar(r: RandomNumberGenerator) -> int:
	var p: Array = D().RAR.p; var x = r.randf(); var acc = 0.0
	for i in p.size():
		acc += float(p[i])
		if x < acc: return i
	return 0

# 名字（唔包 15 隻有名字稀有鬼嘅名）
static func roll_name(r: RandomNumberGenerator) -> String:
	var N = D().NAME; var x = r.randf()
	if x < 0.25: return "阿" + str(_pick(r, N.one))
	if x < 0.55: return str(_pick(r, N.sur)) + str(_pick(r, N.title))
	if x < 0.75: return str(_pick(r, N.nick)[0])
	if x < 0.90: return str(_pick(r, N.nick)[0]) + str(_pick(r, N.sur))
	return str(_pick(r, N.sea_t)) + " " + (str(_pick(r, N.sea)) if r.randf() < 0.6 else str(_pick(r, N.one)))
static func _bad(n: String) -> bool:
	for b in D().NAME.get("blk", []): if n.find(str(b)) >= 0: return true
	for x in D().get("NAMED", []): if str(x.name) == n: return true
	return false
static func _uniq(r: RandomNumberGenerator, used: Dictionary, roll: Callable, all: Array) -> Variant:
	var v = null
	for i in 10:
		v = roll.call(r)
		if not used.has(v) and not (v is String and _bad(v)): return v
	for a in all: if not used.has(a): return a   # 10 次都撞：揀下一個未用
	return v

static func _fodder_keys() -> Array:
	var FO = J.G.get("FODDER")
	var ks = []
	if FO is Dictionary:
		var S = J.G.get("S")
		for k in FO:
			var u = FO[k].get("unlock") if FO[k] is Dictionary else null
			if u == null or u == "" or (S is Dictionary and S.get("cleared") is Dictionary and J.t(S.cleared.get(str(u)))): ks.append(k)
	if ks.is_empty(): ks = ["youhun"]
	ks.sort()
	return ks

static func gen(seed: int, rar := -1, avoid := {}) -> Dictionary:
	var r = _rng(seed)
	if rar < 0: rar = roll_rar(r)
	var L = D().LOOK
	var look = {"body": r.randi_range(0, int(L.body) - 1), "face": r.randi_range(0, int(L.face) - 1), "hair": r.randi_range(0, int(L.hair) - 1),
		"cloth": r.randi_range(0, int(L.cloth) - 1), "acc": r.randi_range(0, int(L.acc) - 1), "tint": r.randi_range(0, int(L.tint) - 1),
		"rcloth": r.randi_range(0, int(L.rare_cloth) - 1) if rar >= 1 else -1, "halo": str(L.halo[clampi(rar, 0, 2)])}
	var names: Dictionary = avoid.get("names", {}); var cps: Dictionary = avoid.get("cps", {})
	var all_names = []
	for o in D().NAME.one: all_names.append("阿" + str(o))
	var name = _uniq(r, names, func(rr): return roll_name(rr), all_names)
	var cpi = _uniq(r, cps, func(rr): return rr.randi_range(0, D().CP.size() - 1), range(D().CP.size()))
	var gag = r.randi_range(0, D().GAG.size() - 1)
	var m = float(D().RAR.mul[clampi(rar, 0, 2)])
	var st = []
	for i in 3: st.append(roundf((15 + r.randf() * 32) * m))
	if rar >= 1: st[r.randi_range(0, 2)] += 8.0 * rar   # 好／出眾：有一門專長
	var ks = _fodder_keys()
	return {"seed": seed, "rar": rar, "name": str(name), "gag": gag, "cp": int(cpi), "look": look, "st": st, "k": str(ks[r.randi_range(0, ks.size() - 1)])}

static func named(id: String, seed := 1) -> Dictionary:
	var o = {}
	for x in D().get("NAMED", []): if str(x.id) == id: o = x
	if o.is_empty(): return {}
	var r = _rng(seed ^ id.hash())
	var pin = int(o.pin); var pm = float(D().NAMED_PIN_MUL[clampi(pin, 0, 2)])
	var st = []
	for i in 3: st.append(roundf((22 + r.randf() * 20) * pm * float(o.mul[i])))
	var ks = _fodder_keys()
	var rar = 2 if pin >= 1 else 1
	return {"seed": seed, "rar": rar, "named": id, "pin": pin, "name": str(o.name), "life": str(o.life), "trait": str(o.trait), "post": str(o.post),
		"gag": -1, "cp": r.randi_range(0, D().CP.size() - 1), "look": {"halo": "gold" if rar == 2 else "purple", "rcloth": pin}, "st": st,
		"k": str(ks[r.randi_range(0, ks.size() - 1)])}

# ---------- 台詞 ----------
static func cp_text(g: Dictionary) -> String: return P(D().CP[clampi(int(g.get("cp", 0)), 0, D().CP.size() - 1)])
static func gag_text(g: Dictionary) -> String:
	var i = int(g.get("gag", -1))
	if i < 0: return str(g.get("life", "")) + "。"
	return P(D().GAG[clampi(i, 0, D().GAG.size() - 1)])
static func line(g: Dictionary, kind: String) -> String:
	var t = P(D().LINES.get(kind, ["{c}", "{c}"]))
	return t.replace("{n}", str(g.get("name", ""))).replace("{g}", gag_text(g)).replace("{c}", cp_text(g))
static func rar_label(rar: int) -> String: return P(D().RAR.label[clampi(rar, 0, 2)])
