# [roles] 名鬼定位（好似《劍與遠征》）：坦／攻／輔／醫。人人都會普攻，分別在於體質同主招。
#   數據 data/nat/roles.json（CLS：鬼 key → 定位）；冇寫嘅：近戰＝坦、遠程＝攻。
#   體質：開戰時乘落 hp／atk（native/battle.gd mk_ghost_unit）；定位招：開戰時加落 abil 被動（abil.gd compile）。
#   站位（前 3 後 3）由玩家自己揀；建議前排放坦，後排放攻／輔／醫。
extends RefCounted

const PATH := "res://data/nat/roles.json"
static var _D: Dictionary = {}

const CLS := {
	"坦": {"id": "tank", "zh": "坦", "name": ["坦", "坦"], "full": ["坦克", "坦克"], "col": "#4a78c8", "hp": 1.55, "atk": 0.72,
		"desc": ["皮粗肉厚，企前排擋打。開場嘲諷身邊敵人，受傷少兩成，間中自己上護盾。", "皮粗肉厚，站前排擋傷害。開場嘲諷身邊敵人，受到傷害減兩成，不時替自己加護盾。"],
		"pas": [
			{"tr": "start", "fx": [{"p": "buff", "stat": "taken", "v": -0.2, "dur": -1}], "tg": {"sel": "self"}, "cls": true},
			{"tr": "start", "fx": [{"p": "taunt", "r": 170, "dur": 3.0}], "tg": {"sel": "self"}, "cls": true},
			{"tr": "every", "t": 10.0, "fx": [{"p": "shield", "pct": 0.14, "dur": 6.0}, {"p": "taunt", "r": 150, "dur": 2.0}], "tg": {"sel": "self"}, "cls": true}]},
	"戰": {"id": "war", "zh": "戰", "name": ["戰", "戰"], "full": ["戰士", "戰士"], "col": "#d27a2a", "hp": 1.2, "atk": 1.05,
		"desc": ["近身肉搏，又打得又捱得。每打三下令目標易傷；血跌到一半就發狂：攻擊 +30%、回一成血。", "近身肉搏，攻守兼備。每打三下讓目標易傷；血量降到一半就發狂：攻擊 +30%、回復一成血。"],
		"pas": [
			{"tr": "start", "fx": [{"p": "buff", "stat": "taken", "v": -0.08, "dur": -1}], "tg": {"sel": "self"}, "cls": true},
			{"tr": "attack", "n": 3, "fx": [{"p": "mark", "v": 0.12, "dur": 3.0}], "cls": true},
			{"tr": "low_hp", "pct": 0.5, "fx": [{"p": "buff", "stat": "atk", "v": 0.3, "dur": -1}, {"p": "heal", "pct": 0.1}], "tg": {"sel": "self"}, "cls": true}]},
	"刺": {"id": "ass", "zh": "刺", "name": ["刺", "刺"], "full": ["刺客", "刺客"], "col": "#8a4ac8", "hp": 0.85, "atk": 1.3,
		"desc": ["開場隱身兩秒摸去後排，第一下特別痛；專收殘血，打低過三成血嘅敵人多六成傷害；每殺一隻再隱身、回能量。", "開場隱身兩秒摸到後排，第一擊特別痛；專收殘血，攻擊血量低於三成的敵人多六成傷害；每擊倒一個再隱身、回能量。"],
		"pas": [
			{"tr": "start", "fx": [{"p": "stealth", "dur": 2.0, "first_x": 1.5}], "tg": {"sel": "self"}, "cls": true},
			{"tr": "attack", "fx": [{"p": "execute", "hp_pct": 0.3, "x": 0.6}], "icd": 0.5, "cls": true},
			{"tr": "kill", "fx": [{"p": "stealth", "dur": 1.5, "first_x": 1.3}, {"p": "energy", "v": 20}], "tg": {"sel": "self"}, "icd": 1.0, "cls": true}]},
	"射": {"id": "rng", "zh": "射", "name": ["射", "射"], "full": ["射手", "射手"], "col": "#c8463a", "hp": 0.9, "atk": 1.22,
		"desc": ["企後排遠距離點殺。每打四下替目標加易傷標記；每殺一隻即刻回大招能量。", "站後排遠距離點殺。每打四下替目標加上易傷標記；每擊倒一個敵人立即回復大招能量。"],
		"pas": [
			{"tr": "attack", "n": 4, "fx": [{"p": "mark", "v": 0.15, "dur": 4.0}], "cls": true},
			{"tr": "kill", "fx": [{"p": "energy", "v": 25}], "tg": {"sel": "self"}, "icd": 1.0, "cls": true}]},
	"法": {"id": "mag", "zh": "法", "name": ["法", "法"], "full": ["法師", "法師"], "col": "#2a9aa8", "hp": 0.85, "atk": 1.15,
		"desc": ["遠程打一大片。開場多三成能量，大招快人一步；每 9 秒向敵人最密嗰度轟一下。", "遠程打一大片。開場多三成能量，大招快人一步；每 9 秒向敵人最密集的地方轟一下。"],
		"pas": [
			{"tr": "start", "fx": [{"p": "energy", "v": 30}], "tg": {"sel": "self"}, "cls": true},
			{"tr": "every", "t": 9.0, "fx": [{"p": "dmg", "mult": 0.6}], "tg": {"sel": "dense", "shape": "circle", "r": 80}, "cls": true},
			{"tr": "kill", "fx": [{"p": "energy", "v": 10}], "tg": {"sel": "self"}, "icd": 1.0, "cls": true}]},
	"輔": {"id": "sup", "zh": "輔", "name": ["輔", "輔"], "full": ["輔助", "輔助"], "col": "#b48a2a", "hp": 1.05, "atk": 0.85,
		"desc": ["幫隊友加攻、清負面狀態，或者專門控住敵人，令成隊打得更快。", "替隊友加攻擊、清除負面狀態，或專門控制敵人，讓整隊打得更快。"],
		"pas": [
			{"tr": "start", "fx": [{"p": "buff", "stat": "atk", "v": 0.12, "dur": 6.0}, {"p": "energy", "v": 15}], "tg": {"sel": "allies", "r": 260}, "cls": true},
			{"tr": "every", "t": 8.0, "fx": [{"p": "buff", "stat": "atk", "v": 0.15, "dur": 4.0}], "tg": {"sel": "allies", "r": 240}, "cls": true},
			{"tr": "every", "t": 12.0, "fx": [{"p": "cleanse", "n": 2}], "tg": {"sel": "ally_low"}, "cls": true}]},
	"醫": {"id": "heal", "zh": "醫", "name": ["醫", "醫"], "full": ["醫療", "醫療"], "col": "#3a9a5a", "hp": 0.95, "atk": 0.72,
		"desc": ["專門回血：不時醫返血最少嗰隻，再俾全隊慢慢回血。", "專門回血：不時治療血最少的隊友，再讓全隊持續回血。"],
		"pas": [
			{"tr": "every", "t": 5.0, "fx": [{"p": "heal", "pct": 0.12}], "tg": {"sel": "ally_low"}, "cls": true},
			{"tr": "every", "t": 11.0, "fx": [{"p": "hot", "pct": 0.025, "dur": 5.0}], "tg": {"sel": "allies", "r": 260}, "cls": true},
			{"tr": "low_hp", "pct": 0.3, "fx": [{"p": "heal", "pct": 0.2}], "tg": {"sel": "self"}, "cls": true}]},
}
const TIERS := {
	"普通": {"col": "#6aa86a", "rank": 1}, "精英": {"col": "#4a88d8", "rank": 2}, "傳說": {"col": "#9a5ad8", "rank": 3},
	"王牌": {"col": "#e0a020", "rank": 4}, "主角": {"col": "#e0a020", "rank": 4}}
const SYS_ZH := ["屍", "魂", "紙紮", "妖", "厲", "使", "官", "橫"]
const ORDER := ["坦", "戰", "刺", "射", "法", "輔", "醫"]
const SHORT := {"坦": ["擋打護隊", "擋打護隊"], "戰": ["近身肉搏", "近身肉搏"], "刺": ["切後排收殘血", "切後排收殘血"], "射": ["遠程點殺", "遠程點殺"],
	"法": ["遠程打一片", "遠程打一片"], "輔": ["加持／控場", "加持／控場"], "醫": ["回血復活", "回血復活"]}

static func data() -> Dictionary:
	if _D.is_empty():
		var t = FileAccess.get_file_as_string(PATH)
		var p = JSON.parse_string(t) if t != "" else null
		_D = p if p is Dictionary else {"CLS": {}}
	return _D

static func cls_of(k) -> String:
	var ks = J.str(k)
	var c = data().CLS.get(ks)
	if c != null and CLS.has(str(c)): return str(c)
	var a = load("res://game/rts/abil.gd").abil(ks)
	if a is Dictionary and J.num(a.get("rng", 46)) > 60: return "射"
	var G = DB.D.get("GHOSTS", {})
	if G is Dictionary and G.get(ks) is Dictionary and str(G[ks].get("range", "")) == "ranged": return "射"
	return "戰"

static func off() -> bool: return OS.get_environment("GB_NOROLES") == "1"   # 測試用：關定位（對照組）
const _NONE := {"zh": "", "hp": 1.0, "atk": 1.0, "pas": [], "col": "#888888", "full": ["", ""], "desc": ["", ""]}
static func info(k) -> Dictionary: return _NONE if off() else CLS[cls_of(k)]
static func T(a) -> String: return str(a[0] if DB.lang == "yue" else a[1]) if a is Array else str(a)
static func short(k) -> String: return str(info(k).zh)
static func full(k) -> String: return T(info(k).full)
static func col(k) -> Color: return Color(str(info(k).col))

# 體質（hp／atk 倍數）
static func apply_stats(u: Dictionary) -> void:
	if J.t(u.get("cls_ok")): return
	var c = info(u.get("k"))
	u["hp"] = J.num(u.hp) * float(c.hp); u["maxhp"] = J.num(u.get("maxhp", u.hp)) * float(c.hp)
	if u.get("maxhp") != null and J.num(u.maxhp) < J.num(u.hp): u["maxhp"] = u.hp
	u["atk"] = J.num(u.atk) * float(c.atk)
	u["cls"] = cls_of(u.get("k")); u["cls_ok"] = true

# 定位招（abil 被動）＋個別額外被動（放毒擴充等）
static func kit(k) -> Array:
	var o = []
	for pe in info(k).pas: o.append((pe as Dictionary).duplicate(true))
	if not off():
		var ex = data().get("EXTRA", {}).get(J.str(k))
		if ex is Array: for pe in ex: o.append((pe as Dictionary).duplicate(true))
	return o

# 品級
static func tier(k) -> String:
	var t = data().get("TIER", {}).get(J.str(k))
	return str(t) if t != null and TIERS.has(str(t)) else "精英"
static func tier_col(k) -> Color: return Color(str(TIERS[tier(k)].col))
static func is_ace(k) -> bool: return tier(k) == "王牌"
static func ace_max() -> int: return int(J.num(data().get("ACE_MAX", 2)))
static func sub(k) -> String: return str(data().get("SUB", {}).get(J.str(k), ""))
static func sys_of(k) -> String:
	var a = load("res://game/rts/abil.gd").abil(J.str(k))
	return J.str(a.get("sys")) if a is Dictionary else ""
static func has_poison(k) -> bool: return data().get("EXTRA", {}).has(J.str(k))

# 系羈絆：同系 3／4／5 隻 → 加攻、減受傷（5 隻再加能量）
static func bond_of(ks: Array) -> Dictionary:
	var n = {}
	for k in ks:
		var s0 = sys_of(k)
		if s0 != "": n[s0] = int(n.get(s0, 0)) + 1
	var best = ""; var bn = 0
	for s1 in n: if int(n[s1]) > bn: bn = int(n[s1]); best = s1
	if bn < 3 or off(): return {}
	var B = data().get("BOND", {}).get(str(mini(bn, 5)))
	if not (B is Dictionary): return {}
	return {"sys": best, "n": bn, "b": B}
static func bond_kit(ks: Array) -> Array:
	var bd = bond_of(ks)
	if bd.is_empty(): return []
	var b = bd.b; var fx = []
	if J.num(b.get("atk", 0)) != 0: fx.append({"p": "buff", "stat": "atk", "v": J.num(b.atk), "dur": -1})
	if J.num(b.get("taken", 0)) != 0: fx.append({"p": "buff", "stat": "taken", "v": J.num(b.taken), "dur": -1})
	if J.num(b.get("energy", 0)) != 0: fx.append({"p": "energy", "v": J.num(b.energy)})
	return [{"tr": "start", "fx": fx, "tg": {"sel": "self"}, "cls": true, "bond": bd.sys}]
static func bond_text(ids: Array) -> String:
	var ks = []
	var S = J.G.get("S")
	for id in ids:
		if not J.t(id) or not (S is Dictionary): continue
		for g in J.iter(S.ghosts): if g is Dictionary and J.str(g.id) == J.str(id): ks.append(J.str(g.k))
	var bd = bond_of(ks)
	if bd.is_empty(): return T(["同系 3 隻起有羈絆（加攻、減傷）", "同系 3 隻起有羈絆（加攻擊、減傷害）"])
	var b = bd.b
	var t = "%s系 ×%d：攻 +%d%%、受傷 −%d%%" % [bd.sys, bd.n, roundi(J.num(b.get("atk", 0)) * 100), roundi(-J.num(b.get("taken", 0)) * 100)]
	if J.num(b.get("energy", 0)) > 0: t += T(["、開場能量 +%d", "、開場能量 +%d"]) % int(J.num(b.energy))
	return t

# 小標（名冊／出擊卡用）：有色圓角「坦／攻／輔／醫」
static func badge(k, sz := 13) -> Control: return badge_cls(cls_of(k), sz, tier_col(k))
static func badge_cls(c: String, sz := 13, tcol = null) -> Control:
	var p = PanelContainer.new()
	var sb = StyleBoxFlat.new(); sb.bg_color = Color(str(CLS[c].col))
	if tcol is Color: sb.border_color = tcol; sb.set_border_width_all(2); sb.set_corner_radius_all(4)
	sb.content_margin_left = 3; sb.content_margin_right = 3; sb.content_margin_top = 0; sb.content_margin_bottom = 0
	p.add_theme_stylebox_override("panel", sb); p.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var l = Label.new(); l.text = str(CLS[c].zh); l.add_theme_font_size_override("font_size", sz); l.add_theme_color_override("font_color", Color.WHITE)
	l.mouse_filter = Control.MOUSE_FILTER_IGNORE; p.add_child(l)
	return p

# 隊伍組成「坦 1・攻 2・輔 1・醫 1」
static func team_mix(ids: Array) -> String:
	var n = {}
	for c in ORDER: n[c] = 0
	var S = J.G.get("S")
	for id in ids:
		if not J.t(id) or not (S is Dictionary): continue
		for g in J.iter(S.ghosts):
			if g is Dictionary and J.str(g.id) == J.str(id): n[cls_of(g.k)] += 1
	var o = []
	for c in ORDER: if int(n[c]) > 0: o.append("%s %d" % [T(CLS[c].name), n[c]])
	return "・".join(o) if o.size() else "—"
