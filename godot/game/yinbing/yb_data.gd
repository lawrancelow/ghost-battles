# [yinbing] 陰兵兵種（近戰／中距／遠程／醫療）× 階級（雜兵／士兵／衛兵／親兵）＝16 款（全部 static；冇 class_name、冇 autoload：熱更新規矩）
#   const YB = preload("res://game/yinbing/yb_data.gd")
#   數據 data/nat/yinbing.json（tools/yinbing_build.py 生成；改數值改 build 腳本）；設計稿 /home/claude/art/out/HC_YinBing_Design.md
#   第一期（phase 1）：只提供查表＋圖鍵（未接戰鬥，未改任何現有行為）；數值倍率要 phase ≥ 2 先生效
extends RefCounted

const PATH := "res://data/nat/yinbing.json"
static var _d = null
static var off := false   # 測試：關閉
static var force_rank := ""   # 測試／截圖：強制階級

static func D() -> Dictionary:
	if _d == null:
		var o = JSON.parse_string(FileAccess.get_file_as_string(PATH)) if FileAccess.file_exists(PATH) else null
		_d = o if o is Dictionary else {}
	return _d
static func on() -> bool: return not off and not D().is_empty() and not OS.has_environment("GB_NOYB")   # GB_NOYB：平衡對照用（關兵種）
static func phase() -> int: return int(D().get("phase", 1))
static func stats_on() -> bool: return on() and phase() >= 2

static func ranks() -> Array: return D().get("RANKS", [])
static func classes() -> Array: return D().get("CLASSES", [])
static func cls(id: String) -> Dictionary:
	for c in classes():
		if str(c.id) == id: return c
	return {}
static func rank(id: String) -> Dictionary:
	for r in ranks():
		if str(r.id) == id: return r
	return {}
# 兵器檔★（0–6）→ 階級 id
static func rank_of_star(t: int) -> String:
	for r in ranks():
		if t >= int(r.star[0]) and t <= int(r.star[1]): return str(r.id)
	return "wei"
static func key(c: String, r: String) -> String: return "yb_%s_%s" % [c, r]
static func cell(c: String, r: String) -> Dictionary: return (D().get("CELLS", {}) as Dictionary).get(key(c, r), {})
static func name_of(c: String, r: String) -> String:
	var n = cell(c, r).get("n", [])
	return str(DB.N(str(n[1]) if DB.lang != "yue" else str(n[0]))) if n is Array and n.size() >= 2 else ""
# 圖鍵：有 yb_<兵種>_<階級>_<pose> 就用；冇就退返現版 soldier_<pose>
static func spr_key(c: String, r: String, pose: String) -> String:
	if ResourceLoader.exists("res://assets/spr/%s_stand.webp" % key(c, r)): return key(c, r) + "_stand"   # 一張企姿圖，行／打用同一張做動
	return "soldier_" + pose
# 數值倍率：兵種倍率（hp／atk）一律生效；階級倍率要 phase ≥ 2 先生效（phase 1 ＝ 1.0）
static func mul(c: String, r: String, stat: String) -> float:
	if not on(): return 1.0
	var a = float(cls(c).get(stat, 1.0)) if stat in ["hp", "atk"] else 1.0
	return a * (float(rank(r).get("k", 1.0)) if stats_on() else 1.0)
static func rank_k(r: String) -> float: return float(rank(r).get("k", 1.0)) if stats_on() else 1.0
static func mix_default() -> Dictionary: return D().get("MIX_DEFAULT", {})

# ======================= 存檔：S.yinbing = {v:1, mix:{jin,zhong,yuan,yi}} =======================
static func st():
	var S = J.G.get("S")
	if not (S is Dictionary) or S.is_empty(): return null
	if not (S.get("yinbing") is Dictionary): S["yinbing"] = {"v": 1.0}
	var a = S.yinbing
	if not (a.get("mix") is Dictionary): a["mix"] = mix_default().duplicate()
	return a
static func mix() -> Dictionary:
	var a = st()
	var m = a.mix if a != null else mix_default()
	var o = {}; var t = 0.0
	for c in classes(): o[str(c.id)] = maxf(0.0, float(m.get(str(c.id), 0.0))); t += o[str(c.id)]
	if t <= 0.0: return mix_default().duplicate()
	for k in o: o[k] = o[k] / t
	return o
# 編制預設（兵營面板揀）
const PRESETS := {
	"std":  {"n": ["均衡", "均衡"], "mix": {"jin": 0.4, "zhong": 0.3, "yuan": 0.2, "yi": 0.1}},
	"wall": {"n": ["重盾", "重盾"], "mix": {"jin": 0.6, "zhong": 0.2, "yuan": 0.1, "yi": 0.1}},
	"bow":  {"n": ["重弓", "重弓"], "mix": {"jin": 0.3, "zhong": 0.2, "yuan": 0.4, "yi": 0.1}},
	"med":  {"n": ["重醫", "重醫"], "mix": {"jin": 0.4, "zhong": 0.2, "yuan": 0.2, "yi": 0.2}},
}
static func set_preset(id: String) -> bool:
	var a = st()
	if a == null or not PRESETS.has(id): return false
	a["mix"] = (PRESETS[id].mix as Dictionary).duplicate(); a["preset"] = id
	return true
static func preset() -> String:
	var a = st()
	return str(a.get("preset", "std")) if a != null else "std"
# n 隊 → 每隊兵種（最大餘數法；有隊就至少 1 隊刀盾手；次序：刀盾 → 長兵 → 弓弩 → 醫護）
static func split(n: int, m = null) -> Array:
	if n <= 0: return []
	var mx: Dictionary = m if m is Dictionary else mix()
	var ids = []; var cnt = {}; var rem = []; var used = 0
	for c in classes():
		var id = str(c.id); ids.append(id)
		var f = float(mx.get(id, 0.0)) * n
		cnt[id] = int(floor(f)); used += cnt[id]; rem.append([f - floor(f), id])
	rem.sort_custom(func(a, b): return a[0] > b[0] if a[0] != b[0] else ids.find(a[1]) < ids.find(b[1]))
	var i = 0
	while used < n: cnt[rem[i % rem.size()][1]] += 1; used += 1; i += 1
	if cnt.get("jin", 0) == 0:
		for id in ["yi", "yuan", "zhong"]:
			if cnt.get(id, 0) > 0: cnt[id] -= 1; cnt["jin"] = 1; break
	var o = []
	for id in ids: for k in int(cnt.get(id, 0)): o.append(id)
	return o
# 而家階級（兵器檔★；兵器檔未開＝★0）
static func rank_now() -> String:
	if force_rank != "": return force_rank
	var ML = load("res://game/militia/ml_data.gd")
	return rank_of_star(ML.tier_now() if ML.stall_open() else 0)
# 戰鬥：我方陰兵小隊（minion、唔係遊魂兵）按編制分兵種，套兵種數值（射程、行速、血攻倍率）
static func assign(units: Array) -> int:
	if not on(): return 0
	var ys = []
	for u in units:
		if u is Dictionary and J.num(u.get("side", 0)) == 0 and J.t(u.get("minion")) and u.get("ml") == null and u.get("yb_c") == null and not J.t(u.get("sum")): ys.append(u)
	var cs = split(ys.size()); var r = rank_now()
	for i in ys.size():
		var u = ys[i]; var c = cs[i]; var cd = cls(c)
		u["yb_c"] = c; u["yb_r"] = r; u["name"] = name_of(c, r)
		var hk = mul(c, r, "hp"); var ak = mul(c, r, "atk")
		u["yb_b"] = {"range": J.num(u.get("range", 38.0)), "spd": J.num(u.get("spd", 52.0)), "hk": hk, "ak": ak}   # 還原用（reassign）
		u["hp"] = J.num(u.hp) * hk; u["maxhp"] = J.num(u.get("maxhp", u.hp)) * hk; u["atk"] = J.num(u.atk) * ak
		u["range"] = float(cd.get("range", 38.0)); u["spd"] = float(cd.get("spd", 52.0))
		if c == "yi": u["yb_heal"] = (cd.get("heal", {}) as Dictionary).duplicate(); u["yb_ht"] = 0.0
	LOG.append(["assign", cs, r])
	return ys.size()
static var LOG: Array = []
static var HEALS := 0   # 測試用：累計醫咗幾多次
# 揀少咗隊（rts._trim）之後重新按編制分：先還原兵種倍率（之後乘落去嘅血倍率照留），再分過
static func reassign(units: Array) -> int:
	for u in units:
		if not (u is Dictionary) or u.get("yb_c") == null: continue
		var b = u.get("yb_b")
		if b is Dictionary:
			u["hp"] = J.num(u.hp) / float(b.hk); u["maxhp"] = J.num(u.maxhp) / float(b.hk); u["atk"] = J.num(u.atk) / float(b.ak)
			u["range"] = float(b.range); u["spd"] = float(b.spd)
		for k in ["yb_c", "yb_r", "yb_b", "yb_heal", "yb_ht"]: u.erase(k)
	return assign(units)
# 醫護兵：每 heal.t 秒醫 heal.r 內血最少（比例）嘅一隊我方陰兵／遊魂兵（唔醫名鬼）；回 (治療量, 目標)
static func heal_tick(sim, u: Dictionary, dt: float):
	var h = u.get("yb_heal")
	if not (h is Dictionary): return null
	u["yb_ht"] = J.num(u.get("yb_ht", 0)) + dt
	if J.num(u.yb_ht) < float(h.get("t", 3.0)): return null
	var best = null; var br = 1.0; var r = float(h.get("r", 160.0))
	for v in sim.units:
		if not (v is Dictionary) or J.num(v.get("side", 0)) != J.num(u.get("side", 0)) or not J.t(v.get("minion")) or J.t(v.get("sum")): continue
		if not sim.alive(v): continue
		var mh = J.num(v.get("maxhp", 1)); var k = J.num(v.hp) / maxf(1.0, mh)
		if k >= 0.999 or (v.p as Vector2).distance_to(u.p) > r: continue
		if k < br: br = k; best = v
	if best == null: return null
	u["yb_ht"] = 0.0
	var amt = J.num(best.maxhp) * float(h.get("pct", 0.05)) * rank_k(str(u.get("yb_r", "wei")))
	amt = minf(amt, J.num(best.maxhp) - J.num(best.hp))
	best["hp"] = J.num(best.hp) + amt
	HEALS += 1
	return [amt, best]

# ======================= 兵營面板 =======================
static func L2(yue: String, zhs: String) -> String: return str(DB.N(zhs if DB.lang != "yue" else yue))
static func box(body: VBoxContainer, refresh: Callable) -> void:
	if not on(): return
	var UI = load("res://game/barracks/bk_ui.gd")
	var BK = load("res://game/barracks/bk_data.gd")
	var v = UI._box(body, L2("陰兵編制（兵種）", "陰兵編制（兵種）"))
	var r = rank_now(); var rd = rank(r)
	var ML = load("res://game/militia/ml_data.gd")
	var star = ML.tier_now() if ML.stall_open() else 0
	var nxt = ""
	for x in ranks():
		if int(x.star[0]) > star: nxt = L2("　兵器檔升到 ★%d 變%s", "　兵器檔升到 ★%d 變%s") % [int(x.star[0]), T(x.n)]; break
	v.add_child(UI._rich(L2("階級：[b]%s[/b]（兵器檔 ★%d）%s", "階級：[b]%s[/b]（兵器檔 ★%d）%s") % [T(rd.get("n", ["", ""])), star, nxt], 13.5))
	var nsq = mini(8, int(floor(float(BK.standby()) / 25.0)))
	var cs = split(maxi(nsq, 1))
	var parts = []
	for c in classes():
		var cnt = cs.count(str(c.id)) if nsq > 0 else 0
		parts.append("%s %d" % [T(c.n), cnt])
	v.add_child(UI._rich(L2("出擊 %d 隊：%s", "出擊 %d 隊：%s") % [nsq, "　".join(parts)], 13.5))
	for c in classes():
		v.add_child(UI._rich("[font_size=12]%s（%s）：%s[/font_size]" % [T(c.n), T(c.role), T(c.get("d", ""))], 12, UIKit.INKDIM))
	var hb = HBoxContainer.new(); hb.add_theme_constant_override("separation", 4)
	var cur = preset()
	for id in PRESETS:
		var pid = id
		hb.add_child(UI._b(T(PRESETS[id].n), "gold" if pid == cur else "", pid != cur, func(): set_preset(pid); refresh.call()))
	v.add_child(hb)
static func T(a) -> String:
	if a is Array and a.size() >= 2: return str(DB.N(str(a[1]) if DB.lang != "yue" else str(a[0])))
	return str(a)
