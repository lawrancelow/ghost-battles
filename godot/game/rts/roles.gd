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
	"攻": {"id": "dps", "zh": "攻", "name": ["攻", "攻"], "full": ["輸出", "輸出"], "col": "#c8463a", "hp": 0.92, "atk": 1.22,
		"desc": ["主力輸出，打得最痛。每殺一隻敵人即刻回大招能量。", "主力輸出，傷害最高。每擊倒一個敵人立即回復大招能量。"],
		"pas": [
			{"tr": "kill", "fx": [{"p": "energy", "v": 25}], "tg": {"sel": "self"}, "icd": 1.0, "cls": true}]},
	"輔": {"id": "sup", "zh": "輔", "name": ["輔", "輔"], "full": ["輔助", "輔助"], "col": "#b48a2a", "hp": 1.05, "atk": 0.85,
		"desc": ["幫隊友加攻、清負面狀態，令成隊打得更快。", "替隊友加攻擊、清除負面狀態，讓整隊打得更快。"],
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
const ORDER := ["坦", "攻", "輔", "醫"]

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
	if a is Dictionary and J.num(a.get("rng", 46)) > 60: return "攻"
	var G = DB.D.get("GHOSTS", {})
	if G is Dictionary and G.get(ks) is Dictionary and str(G[ks].get("range", "")) == "ranged": return "攻"
	return "坦"

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

# 定位招（abil 被動）
static func kit(k) -> Array:
	var o = []
	for pe in info(k).pas: o.append((pe as Dictionary).duplicate(true))
	return o

# 小標（名冊／出擊卡用）：有色圓角「坦／攻／輔／醫」
static func badge(k, sz := 13) -> Control: return badge_cls(cls_of(k), sz)
static func badge_cls(c: String, sz := 13) -> Control:
	var p = PanelContainer.new()
	var sb = StyleBoxFlat.new(); sb.bg_color = Color(str(CLS[c].col)); sb.set_corner_radius_all(4)
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
	for c in ORDER: o.append("%s %d" % [T(CLS[c].name), n[c]])
	return "・".join(o)
