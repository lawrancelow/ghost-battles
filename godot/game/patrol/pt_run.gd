# 夜班巡陰（原生 Godot 版）：巡邏本身——由 patrol.js 嘅 begin() 開始交俾呢度
# 規則、數值、文字同網頁版 2026.11.14b 一樣；存檔仍然係 JS 嗰份 S（同網頁版互通）
# 畫面：地面平鋪貼圖、擺設／角色 y 排序、角色 GPU 網格變形、光照用 1/4 解像度遮罩
class_name PtRun
extends Control

const TEA_CD := 60.0
const DOWN_T := 4.5
const ACC := 1500.0
const RING := {"lead": [55.0, 130.0], "crew": [80.0, 185.0], "troop": [100.0, 215.0]}
const ATK := {"windup": 0.15, "strike": 0.1, "recover": 0.22, "cast": 0.45}
const HUE := {"yuan": 110.0, "chan": -150.0, "lan": 35.0, "foe": -155.0, "gold": 0.0}
const CN := "一二三四五六"

static var cur: PtRun = null

var N: Dictionary            # Patrol._nat
var MAP: PtMap
var ci := 0
var S: Dictionary
var CHAPTERS: Array
var ENEMY_T: Dictionary
var GHOSTS: Dictionary
var FODDER: Dictionary
var SKILLS: Dictionary
var N30_G: Dictionary
var N30_TIER: Dictionary
var FAC: Dictionary

var units: Array = []
var foes: Array = []
var fx: Array = []
var proj: Array = []
var downs: Array = []
var L: PtU
var t := 0.0
var cam := Vector2.ZERO
var keys := {}
var joy = null               # {x0, y0, x, y}
var packs := {}
var next_sp := {}
var zone_seen := {}
var tea := {}
var loot := {"coins": 0.0, "exp": 0.0, "yuan": 0.0, "chan": 0.0, "lan": 0.0, "rec": 0.0, "kills": 0.0, "buns": 0.0}
var streak := 0
var bryan = null             # Array 或 null
var bryan_done := false
var bryan_want := false
var ended := false
var paused := false
var kings := {}              # t → Array 或 null
var guards := {}             # si → Array 或 null
var ot = null
var fog: PackedByteArray
var fog_w := 0
var fog_h := 0
var fog_dirty := true
var crew_buff := {}
var spots: Array = []
var near: Array = []
var near_t := 0.0
var last_ter := -1
var stop := 0.0
var shake := 0.0
var flash_a := 0.0
var buff := 0.0
var dash_cd := 0.0
var pie_cd := 0.0
var face := Vector2.ZERO
var has_face := false
var tele: Array = []
var later_q: Array = []
var wisps: Array = []
var elite_t := 0.0
var req_msg := -99.0
var before_q := false
var save_t := 0.0
var snd_at := 0
var dig = null
var act_key := "x"
var hud_t := -1
var down_v = null
var sc := 1.0
var vw := 400.0
var vh := 800.0
var cx := 0.0
var cy := 0.0
var shx := 0.0
var shy := 0.0
var lights: Array = []

# 節點
var world: Node2D
var ground: PtDraw
var path_n: PtDraw
var under: PtDraw
var ysort: Node2D
var walls_n: PtDraw
var proj_n: PtDraw
var fxtop: Node2D
var fxground: Node2D
var fxmisc: PtDraw
var text_n: PtDraw
var mist_n: PtDraw
var dark_vp: SubViewport
var dark_draw: PtDraw
var dark_rect: TextureRect
var dark_mat: ShaderMaterial
var glow_n: PtDraw
var tint: ColorRect
var hud: PtHud
var prop_live := {}
var prop_pool: Array = []
var wglow: PtDraw
var faci_nodes: Array = []
var fx_groups := {}
var ground_tex: Texture2D
var fxt := {}

# ---------------- JS 介面 ----------------
func js(name: String): return J.G.get(name)
func jm(obj_name: String, m: String, args := []): return J.mc(J.G.get(obj_name), m, args)
func jc(fn_name: String, args := []): return J.cl(J.G.get(fn_name), null, args)
func T(yue: String, zh: String) -> String: return J.str(J.cl(N.T, null, [yue, zh]))
func st() -> Dictionary: return J.cl(N.st, null, [])
func reg_st(c := -1) -> Dictionary: return J.cl(N.regSt, null, [float(ci if c < 0 else c)])
func sid_of(c: int, si: int) -> String: return "%d-%d" % [c + 1, si + 1]
func phase(mn: float) -> String:
	var h = int(floor(mn / 60.0))
	return "zi" if h < 4 else ("off" if h < 8 else ("work" if h < 18 else "ot"))
func fmt(n) -> String: return J.str(jc("fmt", [n]))
func snd(n: String) -> void: Snd.play(n)
func save() -> void: jc("save")
func has_g(n: String) -> bool: return J.G.get(n) != null

static func html2bb(h: String) -> String:
	var s = h.replace("<b>", "[b]").replace("</b>", "[/b]").replace("<br>", "\n")
	var re = RegEx.new(); re.compile("<[^>]+>")
	return re.sub(s, "", true)

# ---------------- 開始 ----------------
static func start_run(c: int, z0: int) -> bool:
	var main = Engine.get_main_loop().root.get_node_or_null("Main")
	if main == null: return false
	if cur != null and is_instance_valid(cur): cur.queue_free()
	var r = PtRun.new()
	r.name = "PtRun"
	r.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	main.add_child(r)
	var sh = main.get("sheet")
	if sh: main.move_child(r, sh.get_index())
	cur = r
	r._cover(true)
	r.begin(c, z0)
	return true

# 巡邏期間收起村子畫布同 DOM 介面（佢哋喺下面，畫咗都睇唔到，白白食 CPU）
var _hidden: Array = []
func _cover(on: bool) -> void:
	var main = get_parent()
	if on:
		for nm in ["village", "dom"]:
			var n = main.get(nm)
			if n is CanvasItem and n.visible:
				n.visible = false; n.process_mode = Node.PROCESS_MODE_DISABLED; _hidden.append(n)
	else:
		for n in _hidden:
			if is_instance_valid(n): n.visible = true; n.process_mode = Node.PROCESS_MODE_INHERIT
		_hidden.clear()

func begin(c: int, z0: int) -> void:
	var P = js("Patrol"); N = J.gp(P, "_nat")
	S = js("S"); CHAPTERS = js("CHAPTERS"); ENEMY_T = js("ENEMY_T"); GHOSTS = js("GHOSTS"); FODDER = js("FODDER"); SKILLS = js("SKILLS")
	N30_G = js("N30_G") if has_g("N30_G") else {}; N30_TIER = js("N30_TIER") if has_g("N30_TIER") else {}
	FAC = N.FAC
	ci = c
	PtChar.setup_static()
	if OS.has_environment("GB_PROF"): RenderingServer.viewport_set_measure_render_time(get_viewport().get_viewport_rid(), true)
	var t0 = Time.get_ticks_msec()
	MAP = PtMap.new(N, ci)
	print("[patrol] map ", Time.get_ticks_msec() - t0, "ms props=", MAP.props.size(), " walls=", MAP.WALLS.size(), " spots=", MAP.spots.size())
	var p = st(); var rs = reg_st()
	fog_w = int(ceil(MAP.WW / float(N.FOG))); fog_h = int(ceil(MAP.WH / float(N.FOG)))
	fog = PackedByteArray(); fog.resize(fog_w * fog_h)
	var fs: String = J.str(rs.get("fog", ""))
	if rs.get("fog") == null: fs = ""
	for i in mini(fs.length(), fog.size()): fog[i] = 1 if fs[i] == "1" else 0
	crew_buff = jm("Gear", "crewBuff") if has_g("Gear") else {}
	var stas: Dictionary = rs.sta
	stas[J.str(float(_start_z()))] = 1.0
	var sp = MAP.FACI[0]
	for f in MAP.FACI: if f.t == "station" and f.z == z0: sp = f; break
	var lx = sp.x + 60; var ly = sp.y + 60
	var afu = jc("ghostById", ["afu"])
	var L0 = unit_from_ghost(afu, "afu"); L0.x = lx; L0.y = ly; L0.leader = true; equip(L0, afu); units.append(L0); L = L0
	var i = 0
	for g in J.cl(N.leads, null, []):
		var u = unit_from_ghost(g, "lead"); u.slot = i; units.append(u); i += 1
	i = 0
	for g in J.cl(N.crewList, null, []):
		var u = unit_from_ghost(g, "crew"); u.slot = 3 + i
		if J.num(g.get("fat", 0)) >= 70: u.atk *= 0.7
		units.append(u); i += 1
	for j in int(J.cl(N.troopTeams, null, [])):
		var u = troop_unit(j); u.slot = 20 + j; units.append(u)
	i = 0
	for u in units:
		if not u.leader:
			var o = formation(u.slot if u.slot else i); u.x = lx + o.x; u.y = ly + o.y
		i += 1
	cam = Vector2(lx, ly)
	var any_poached = false
	for g in S.ghosts: if J.t(g.get("poached")): any_poached = true
	bryan_want = any_poached or randf() < 0.4
	J.cl(N.setActive, null, [true])
	QX.bump("patrol")
	_build_view()
	reveal_around(lx, ly)
	spots = MAP.spots
	Snd.set_mode("battle")
	if has_g("Guide"): jm("Guide", "visit", ["battle"])
	hud.refresh_leads()
	_hud(true)
	QX.event("patrol_begin:%d" % ci)

func _start_z() -> int:
	return 6 * MAP.COLS + MAP.mc(0)

func formation(i: int) -> Vector2:
	if i < 3:
		var a = -PI / 2 + (i - 1) * 1.1 + PI; return Vector2(cos(a) * 66, sin(a) * 40 + 8)
	if i < 20:
		var j = i - 3; var ring = 0 if j < 6 else 1; var n = 7 if ring else 6; var a = float(j % n) / n * PI * 2 + ring * 0.4
		var r = 150.0 if ring else 108.0; return Vector2(cos(a) * r, sin(a) * r * 0.65 + 10)
	var a2 = float(i - 20) / 4 * PI * 2 + 0.8; return Vector2(cos(a2) * 185, sin(a2) * 118 + 10)

# ---------------- 單位 ----------------
func fac_of(k: String) -> String: return J.str(J.cl(N.facOf, null, [k]))

func unit_from_ghost(g: Dictionary, role: String) -> PtU:
	var F = js("F")
	var Pw = J.num(J.mc(F, "stat", [g, 0.0])); var A = J.num(J.mc(F, "stat", [g, 2.0])); var dm = J.num(jm("GP", "drillMul", [g.k])); var d = jc("gdef", [g])
	var gm = jm("Gear", "unitMul", [g]) if has_g("Gear") else {"atk": 1.0, "hp": 1.0}
	var crew = role == "crew"; var fac = fac_of(g.k)
	var cm = crew_buff.get(fac, {"atk": 1.0, "hp": 1.0}) if crew else {"atk": 1.0, "hp": 1.0}
	var hp = (220 + Pw * 6 + A * 3 if crew else 300 + Pw * 8 + A * 4) * dm * J.num(gm.atk if false else gm.hp) * J.num(cm.hp)
	var atk = (15 + A * 1.1 if crew else 20 + A * 1.4) * dm * J.num(gm.atk) * J.num(cm.atk)
	var rng = 150.0 if d is Dictionary and d.get("range") == "ranged" else 46.0
	var u = PtU.new()
	u.side = 0; u.role = role; u.g = g; u.gid = J.str(g.id); u.k = J.str(g.k); u.name = J.str(g.name); u.fac = fac
	u.hp = hp; u.maxhp = hp; u.atk = atk; u.rng = rng; u.aspd = 1.2 if rng > 60 else 1.0; u.spd = 160.0 if role == "lead" else 175.0
	u.cd = randf() * 0.6; u.energy = 0.0 if crew else 30.0; u.sk = null if crew else SKILLS.get(u.k)
	u.s = 0.6 if role == "afu" or role == "lead" else 0.48
	return u

func equip(u: PtU, g) -> void:
	if not has_g("Gear") or g == null: return
	var w = jm("Gear", "weaponOf", [g])
	if w is Dictionary: u.wpn = w; u.rng = J.num(w.S.rng); u.aspd = J.num(w.S.aspd)
	var ar = jm("Gear", "armorOf", [g])
	if ar is Dictionary:
		var cl: Array = N.CLOTH[ar.f]; u.cloth = PtGfx.css_filter(J.str(cl[1 if J.num(ar.c) >= 3 else 0]))
	var bd = jm("Gear", "badgeOf", [g])
	if bd is Dictionary: u.badge = {"col": Color(J.str(FAC[bd.f].col)), "c": J.num(bd.c)}

func troop_unit(i: int) -> PtU:
	var tb = 1 + 0.08 * maxf(0, J.num(S.bld.get("home", 0)) - 1); var hp = (90 + 14 * J.num(S.lv)) * tb
	var u = PtU.new(); u.side = 0; u.role = "troop"; u.k = "youhun"; u.name = "陰兵"; u.fac = fac_of("youhun")
	u.hp = hp; u.maxhp = hp; u.atk = (9 + 2.2 * J.num(S.lv)) * tb; u.rng = 40; u.aspd = 1; u.spd = 175; u.cd = randf(); u.s = 0.4; u.ti = i
	return u

func foe(k: String, p: float, mul = null, extra := {}) -> PtU:
	var tt = ENEMY_T.get(k, [1.0, 1.0, k]); var zi = 1.3 if phase(J.num(st().min)) == "zi" else 1.0
	var hp = (260 + 90 * p) * J.num(tt[0]) * 0.55 * (J.num(mul.hp) if mul else 1.0) * zi
	var atk = (16 + 7.5 * p) * J.num(tt[1]) * 0.6 * (J.num(mul.atk) if mul else 1.0) * zi
	var d = GHOSTS.get(k, FODDER.get(k, {}))
	var rng = 140.0 if (d is Dictionary and d.get("range") == "ranged") or k == "zhiren" or k == "penanggal" else 44.0
	var u = PtU.new(); u.side = 1; u.k = k; u.name = J.str(tt[2]); u.fac = fac_of(k); u.p = p; u.hp = hp; u.maxhp = hp; u.atk = atk; u.rng = rng
	u.aspd = 1.3 if rng > 60 else 1.1; u.spd = 120.0 if k == "xiaogui" else 100.0; u.cd = randf(); u.s = 0.5; u.flip = true
	if SKILLS.has(k) and (extra.get("elite", false) or extra.has("guard") or extra.get("ot_boss", false)): u.sk = SKILLS[k]
	for kk in extra: u.set(kk, extra[kk])
	return u

# ---------------- 霧 ----------------
func reveal_around(x: float, y: float, rr := 3) -> void:
	var F = float(N.FOG); var cxx = int(floor(x / F)); var cyy = int(floor(y / F))
	for j in range(-rr, rr + 1):
		for i in range(-rr, rr + 1):
			if i * i + j * j > rr * rr + 1: continue
			var X = cxx + i; var Y = cyy + j
			if X < 0 or Y < 0 or X >= fog_w or Y * F >= MAP.WH: continue
			if fog[Y * fog_w + X] == 0: fog[Y * fog_w + X] = 1; fog_dirty = true
func fog_at(x: float, y: float) -> bool:
	var F = float(N.FOG); var X = int(floor(x / F)); var Y = int(floor(y / F))
	if X < 0 or Y < 0 or X >= fog_w or Y >= fog_h: return false
	return fog[Y * fog_w + X] == 1

# ---------------- 地頭 ----------------
func king_done(tt: int) -> bool:
	if MAP.TMAIN.has(tt): return J.t(S.cleared.get(sid_of(ci, MAP.TMAIN[tt])))
	var kg = reg_st().get("kings", {})
	return J.t(kg.get(str(tt))) if kg is Dictionary else false
func gate_open(g: Dictionary) -> bool: return g.sec or king_done(g.a) or king_done(g.b)
func sec_found(g: Dictionary) -> bool:
	if not g.sec: return true
	var sg = reg_st().get("sg", {})
	return J.t(sg.get(str(g.i)))
func ter_p(tt: int) -> float:
	var hi = J.num(CHAPTERS[ci].stages[2].p); var lo = J.num(CHAPTERS[ci - 1].stages[2].p) if ci > 0 else 0.0
	if MAP.TMAIN.has(tt): return J.num(CHAPTERS[ci].stages[MAP.TMAIN[tt]].p)
	return lo + (hi - lo) * J.num(N.TTIER[tt])
func zone_p(z: int) -> float:
	var tt = MAP.ter_of(z); var c = MAP.zone_cell(z); var j = float((c.y * 7 + c.x * 3) % 5) / 5.0
	return maxf(0.2, ter_p(tt) * (0.85 + 0.15 * j))
func elites_of() -> Array: return J.cl(N.elitesOf, null, [float(ci)])
func elite_of_zone(z: int):
	var l = elites_of()
	if l.is_empty(): return null
	var k = l[z % l.size()]
	return k if (z < l.size() or z % 2 == 0) and J.t(jm("N30W", "open", [k])) else null
func fod_of() -> Array: return J.cl(N.fodOf, null, [float(ci)])
func king_def(tt: int):
	var TK = N.TKING[ci] if ci < N.TKING.size() else {}
	if TK.has(str(tt)): return TK[str(tt)]
	if not MAP.TSECRET.has(tt): return null
	var used = {}
	for d in TK.values():
		if d.get("big"): used[d.big] = 1
		if d.get("small"): used[d.small] = 1
	var el = []
	for k in elites_of(): if not used.has(k) and GHOSTS.has(k): el.append(k)
	var pool = fod_of()
	var k2 = el[(tt - 6) % el.size()] if el.size() else pool[pool.size() - 1]
	return {"small": k2, "guard": true}
func page_ghosts() -> Array: return J.cl(N.pageGhosts, null, [float(ci)])

# ---------------- 出鬼 ----------------
func spawn_zone(z: int) -> void:
	var p = zone_p(z); var pool = fod_of(); var c = MAP.zone_center(z); var ph = phase(J.num(st().min))
	if not packs.has(z): packs[z] = []
	var want = 3 if ph == "off" else 4
	var alive = []
	for pk in packs[z]:
		for e in pk: if e.hp > 0 or e.down > 0: alive.append(pk); break
	packs[z] = alive
	if alive.size() >= want or t < next_sp.get(z, 0.0): return
	next_sp[z] = t + 2
	var x = 0.0; var y = 0.0; var ok = false
	for kk in 12:
		if ok: break
		x = c.x + (randf() - 0.5) * (MAP.CW - 160); y = c.y + (randf() - 0.5) * (MAP.CH - 160)
		ok = Vector2(x - L.x, y - L.y).length() > 380
		if ok:
			for f in MAP.FACI: if Vector2(f.x - x, f.y - y).length() < 170: ok = false; break
		if ok:
			for tt in 9:
				var q = MAP.lair(tt); if Vector2(q.x - x, q.y - y).length() < 260: ok = false; break
		if ok and MAP.blocked_at(x, y): ok = false
	if not ok: return
	var tz = MAP.ter_of(z); var n = 1 + int(floor(randf() * mini(4 if ci == 0 else 5, 1 + tz + mini(ci, 2))))
	var CH_FOD: Array = N.CH_FOD; var before = 0
	for i in ci: before += CH_FOD[i].size()
	var nun = maxi(1, mini(pool.size(), before + 1 + int(floor(tz / 2.0))))
	var unlocked = pool.slice(0, nun)
	var pk = []
	for i in n:
		var k = unlocked[unlocked.size() - 1] if randf() < 0.55 else unlocked[int(floor(randf() * unlocked.size()))]
		var e = foe(k, p); e.x = x + (randf() - 0.5) * 70; e.y = y + (randf() - 0.5) * 50; e.hx = x; e.hy = y; e.z = z; pk.append(e)
	var ek = elite_of_zone(z)
	var has_el = false
	for a in alive:
		for e in a: if e.elite: has_el = true
	if ek != null and not has_el and t > elite_t and randf() < (0.6 if ph == "zi" else 0.3):
		elite_t = t + 40
		var tier = N30_TIER.get(J.str(N30_G[ek].t), {"p": p})
		var e = foe(ek, maxf(p, J.num(tier.p)), {"hp": 3.2, "atk": 1.5}, {"elite": true}); e.s = 0.58; e.x = x; e.y = y; e.hx = x; e.hy = y; e.z = z; pk.append(e)
	for e in pk: _add_foe(e)
	packs[z].append(pk)

func _add_foe(e: PtU) -> void:
	foes.append(e)

func spawn_guards(si: int) -> void:
	var sid = sid_of(ci, si)
	if J.t(S.cleared.get(sid)) or guards.has(si): return
	var stg = CHAPTERS[ci].stages[si]; var gp = MAP.guard_pos(si); var arr = []
	var en: Array = stg.en; var i = 0
	for k in en:
		var boss = k == stg.boss
		var e = foe(k, J.num(stg.p), {"hp": 3.6 if boss else 2.2, "atk": 1.3 if boss else 1.1}, {"guard": si, "boss": boss})
		var a = (i - (en.size() - 1) / 2.0) * 0.9; e.x = gp.x + sin(a) * 70; e.y = gp.y - cos(a) * 20 + (-10 if boss else 0); e.hx = e.x; e.hy = e.y
		e.s = 0.78 if boss else 0.55; e.name = J.str(ENEMY_T.get(k, [0, 0, k])[2]); arr.append(e); _add_foe(e); i += 1
	guards[si] = arr

func spawn_king(tt: int) -> void:
	if MAP.TMAIN.has(tt) or king_done(tt) or kings.has(tt): return
	var d = king_def(tt)
	if d == null: return
	var lp = MAP.lair(tt); var p = ter_p(tt); var arr = []; var pool = fod_of()
	var mk = func(k, big: bool, dx: float, lab: String) -> void:
		if k == null or not ENEMY_T.has(k): return
		var e = foe(k, p, {"hp": 5.5, "atk": 1.6} if big else {"hp": 3.4, "atk": 1.35}, {"king": tt, "boss": big, "elite": false, "kname": lab})
		e.sk = SKILLS.get(k); e.s = 0.8 if big else 0.66; e.x = lp.x + dx; e.y = lp.y - 10; e.hx = e.x; e.hy = e.y
		e.name = J.str(GHOSTS[k].name) if GHOSTS.has(k) else e.name; arr.append(e)
	var big_k = d.get("big"); var small_k = d.get("small")
	mk.call(big_k, true, -55.0 if small_k else 0.0, "大王")
	mk.call(small_k, big_k == null, 60.0 if big_k else 0.0, "守寶鬼" if d.get("guard") else ("小王" if big_k else "地頭王"))
	var nmin = 2 + mini(3, tt)
	for i in nmin:
		var k = pool[(i + tt) % pool.size()]; var e = foe(k, p, {"hp": 1.4, "atk": 1.1}, {"king": tt, "minion": true})
		var a = float(i) / nmin * PI * 2; e.x = lp.x + cos(a) * 110; e.y = lp.y + sin(a) * 70; e.hx = e.x; e.hy = e.y; arr.append(e)
	for e in arr: _add_foe(e)
	kings[tt] = arr

func king_win(tt: int) -> void:
	var rs = reg_st(); var d = king_def(tt); if d == null: d = {}
	var kg: Dictionary = rs.kings; var first = not J.t(kg.get(str(tt))); kg[str(tt)] = J.now()
	var p = ter_p(tt); var rew = {"coins": round(60 + 45 * p), "exp": round(25 + 18 * p)}; gain(rew)
	if first:
		var key = "p" if d.get("big") or d.get("guard") else "b"; S.chests[key] = J.num(S.chests.get(key, 0)) + 1
		if d.get("guard"):
			for f in FAC: var n = 6 + ci * 3; loot[f] += n; st().mats[f] = J.num(st().mats[f]) + n
	snd("win"); spr("fx_scream", L.x, L.y - 40, {"s0": 0.4, "s1": 2.2, "life": 0.8}); spr("fx_gold", L.x, L.y - 60, {"s0": 0.4, "s1": 0.9, "life": 1.0}); flash_a = 0.4
	var tn = J.str(N.TNAME[ci][tt])
	jm("Fx", "banner", ["秘境寶物到手：%s！" % tn if d.get("guard") else "拿下地頭：%s！" % tn])
	J.cl(N.emit, null, ["king", {"ci": float(ci), "t": float(tt)}])
	jm("Fx", "toast", ["地頭王擊破：冥幣 +%d，好評 +%d%s。相連的閘口開了。" % [rew.coins, rew.exp, ("，%s箱 ×1" % ("紫" if d.get("big") else "藍")) if first else ""]])
	for k in [d.get("big"), d.get("small")]:
		if k == null or not GHOSTS.has(k) or GHOSTS[k].get("q") != "名": continue
		var owned = false
		for g in S.ghosts: if g.k == k: owned = true
		if owned: continue
		var G = GHOSTS[k]; var kk = k
		jm("Story", "queue", [{"style": "narr", "lines": [["旁白", "%s：「%s」" % [G.name, J.str(jc("L", [G.get("say", "")]))]], ["旁白", T("%s輸咗地頭，決定跟你返落魄村。" % G.name, "%s輸了地頭，決定跟你回落魄村。" % G.name)]]}, func(_t, _a): jc("joinGhost", [kk]); save()])
	persist(); save(); jm("UI", "refresh")

func spawn_bryan(z: int) -> void:
	if bryan != null or bryan_done or not bryan_want or MAP.ter_of(z) < 1: return
	var c = MAP.zone_center(z); var x = c.x + (randf() - 0.5) * 300; var y = c.y + (randf() - 0.5) * 240
	if Vector2(x - L.x, y - L.y).length() < 420: return
	var p = zone_p(z) + 0.6; var pool = fod_of(); var arr = []
	var b = foe("npc_rival", p, {"hp": 2.6, "atk": 1.2}, {"bryan": true}); b.name = "Bryan"; b.fac = "yuan"; b.rng = 44; b.s = 0.62; b.x = x; b.y = y; b.hx = x; b.hy = y; arr.append(b)
	for i in 4:
		var k = pool[int(floor(randf() * pool.size()))]; var e = foe(k, p, {"hp": 1.3, "atk": 1.1}, {"bryan": true}); e.name = "夜冷村" + e.name
		e.x = x + cos(i * 1.6) * 60; e.y = y + sin(i * 1.6) * 40; e.hx = e.x; e.hy = e.y; arr.append(e)
	for e in arr: _add_foe(e)
	bryan = arr
	msg(T("Bryan：「哦？阿福部門都有出嚟巡？你啲人睇落好攰喎，不如過嚟我度？」", "Bryan：「哦？阿福部門也出來巡？你的人看起來很累，不如過來我這邊？」"), 4)

# ---------------- 移動 ----------------
func approach_v(u: PtU, dvx: float, dvy: float, dt: float, acc := ACC) -> void:
	var ax = dvx - u.vx; var ay = dvy - u.vy; var a = sqrt(ax * ax + ay * ay); var m = acc * dt
	if a > m: u.vx += ax / a * m; u.vy += ay / a * m
	else: u.vx = dvx; u.vy = dvy

func steer(u: PtU, tx: float, ty: float, spd: float, dt: float, arrive := 0.0) -> void:
	var dx = tx - u.x; var dy = ty - u.y; var d = sqrt(dx * dx + dy * dy)
	if d < 2: approach_v(u, 0, 0, dt); return
	var s = minf(spd, spd * d / arrive) if arrive > 0 else spd
	approach_v(u, dx / d * s, dy / d * s, dt)

func move_to(u: PtU, nx: float, ny: float) -> void:
	nx = clampf(nx, 20, MAP.WW - 20); ny = clampf(ny, 30, MAP.WH - 20)
	var GW = MAP.GW
	for w in MAP.WALLS:
		if w.h:
			if nx < w.a - 14 or nx > w.b + 14: continue
			var by = w.p
			var cross = (u.y < by) != (ny < by) or absf(ny - by) < 14
			if not cross: continue
			if w.gap != null and absf(nx - w.gap.c) < GW / 2 - 12 and (u.side == 1 or gate_open(w.gap.g)): continue
			ny = minf(ny, by - 15) if u.y < by else maxf(ny, by + 15)
		else:
			if ny < w.a - 14 or ny > w.b + 14: continue
			var bx = w.p
			var cross2 = (u.x < bx) != (nx < bx) or absf(nx - bx) < 14
			if not cross2: continue
			if w.gap != null and absf(ny - w.gap.c) < GW / 2 - 12 and (u.side == 1 or gate_open(w.gap.g)): continue
			nx = minf(nx, bx - 15) if u.x < bx else maxf(nx, bx + 15)
	var gx = int(floor(nx / 200)); var gy = int(floor(ny / 200))
	for i in range(-1, 2):
		for j in range(-1, 2):
			var l = MAP.PGRID.get(Vector2i(gx + i, gy + j))
			if l == null: continue
			for o in l:
				var dx = nx - o.x; var dy = (ny - o.y) * 1.7; var d = sqrt(dx * dx + dy * dy)
				if d < o.r and d > 0.01: var k = o.r / d; nx = o.x + dx * k; ny = o.y + dy * k / 1.7
	u.x = nx; u.y = ny

func integrate(u: PtU, dt: float) -> void:
	var sp = sqrt(u.vx * u.vx + u.vy * u.vy); u.moving = sp > 16
	if absf(u.vx) > 14 and u.act == null: u.flip = u.vx < 0
	var nx = u.x + u.vx * dt; var ny = u.y + u.vy * dt
	if u.has_kb:
		nx += u.kb.x * dt; ny += u.kb.y * dt; var f = pow(0.002, dt); u.kb *= f
		if u.kb.length() < 6: u.has_kb = false
	move_to(u, nx, ny)
	if u.moving and (u.leader or u.role == "lead" or u.boss):
		u.step_t += dt * sp / 55
		if u.step_t > 1: u.step_t = 0; dust(u.x + (randf() - 0.5) * 8, u.y, 0.9 if u.boss else 0.5)

func wander(u: PtU, dt: float) -> void:
	var rg: Array = RING.get(u.role, RING.crew); var lv = Vector2(L.vx, L.vy).length(); var lm = lv > 40
	u.wt_t -= dt
	if u.wt == null or u.wt_t <= 0 or (lm and not u.wt.mv):
		var a = randf() * PI * 2
		if lm: a = atan2(-L.vy, -L.vx) + (randf() - 0.5) * 2.6
		var r = rg[0] + randf() * (rg[1] - rg[0])
		u.wt = {"x": cos(a) * r, "y": sin(a) * r * 0.6, "mv": lm}; u.wt_t = 0.7 + randf() * 1.1 if lm else 1.8 + randf() * 3.8
	var tx = L.x + u.wt.x; var ty = L.y + u.wt.y; var d = Vector2(tx - u.x, ty - u.y).length(); var dl = Vector2(L.x - u.x, L.y - u.y).length()
	if dl > 900: u.x = tx; u.y = ty; u.vx = 0; u.vy = 0; return
	if d < 9:
		approach_v(u, 0, 0, dt)
		if not lm and randf() < dt * 0.35: u.flip = not u.flip
		return
	var far = dl > rg[1] + 50
	var nsl = (u.ti if u.ti else (u.slot if u.slot else 1)) % 3
	var spd = u.spd * 1.6 if far else (maxf(u.spd * 0.7, lv * 1.08) if lm else u.spd * (0.35 + 0.25 * nsl / 2.0))
	steer(u, tx, ty, spd, dt, 30.0 if lm else 50.0)

# ---------------- 主更新 ----------------
func update(dt: float) -> void:
	if stop > 0:
		stop -= dt
		for f in fx: if f.kind == "num": f.t += dt * 0.2
		return
	t += dt
	var p = st()
	p.min = fmod(J.num(p.min) + dt * 2, 1440.0); var ph = phase(p.min)
	shake = maxf(0, shake - dt * 30); flash_a = maxf(0, flash_a - dt * 3)
	if buff > 0: buff -= dt
	dash_cd = maxf(0, dash_cd - dt); pie_cd = maxf(0, pie_cd - dt)
	# 輸入
	var mx = 0.0; var my = 0.0
	if joy != null:
		var dx = joy.x - joy.x0; var dy = joy.y - joy.y0; var d = sqrt(dx * dx + dy * dy)
		if d > 6: var kk = minf(1, (d - 6) / 44.0); mx = dx / d * kk; my = dy / d * kk
	if keys.get("a") or keys.get("left"): mx -= 1
	if keys.get("d") or keys.get("right"): mx += 1
	if keys.get("w") or keys.get("up"): my -= 1
	if keys.get("s") or keys.get("down"): my += 1
	var ml = sqrt(mx * mx + my * my)
	if ml > 1: mx /= ml; my /= ml
	if ml > 0.05: face = Vector2(mx, my) / maxf(ml, 0.01); has_face = true
	if L.hp > 0:
		if L.dash > 0:
			L.dash -= dt; L.inv = L.dash > 0
			if randf() < 0.7: fx.append({"kind": "after", "u": L, "x": L.x, "y": L.y, "s": L.s, "flip": L.flip, "t": 0.0, "life": 0.28})
			for e in foes:
				if e.hp > 0 and not e.fled and not e.down > 0 and not L.dash_hit.has(e) and Vector2(e.x - L.x, (e.y - L.y) * 1.3).length() < 40:
					L.dash_hit[e] = 1; hit(L, e, 0.8, {"kb": 300.0}); QX.bump("dashHit")
		else:
			var spd = L.spd * (1.12 if buff > 0 else 1.0); approach_v(L, mx * spd, my * spd, dt, 1800.0 if ml > 0.05 else 2400.0)
		integrate(L, dt)
	reveal_around(L.x, L.y)
	var z = MAP.zone_at(L.x, L.y); var t_now = MAP.ter_of(z)
	if last_ter != t_now:
		last_ter = t_now
		var d = king_def(t_now); var kn = ""
		if MAP.TMAIN.has(t_now): kn = "主線・%s" % CHAPTERS[ci].stages[MAP.TMAIN[t_now]].name
		elif d != null:
			var nm = []
			for k in [d.get("big"), d.get("small")]: if k != null: nm.append(J.str(GHOSTS[k].name) if GHOSTS.has(k) else J.str(k))
			kn = "、".join(nm)
		var s = "<b>%s：%s</b>" % ["秘境" if MAP.TSECRET.has(t_now) else "地頭", N.TNAME[ci][t_now]]
		if king_done(t_now): s += "　（已拿下）"
		elif kn != "": s += "　" + ("" if MAP.TMAIN.has(t_now) else ("守寶鬼：" if d and d.get("guard") else "地頭王：")) + kn
		msg(s, 3)
	if not zone_seen.has(z):
		zone_seen[z] = 1; var ek = elite_of_zone(z)
		if ek != null and not J.t(jm("N30W", "owned", [ek])):
			later(2.5, func(): msg("新面孔出沒：<b>%s</b>（%s）" % [GHOSTS[ek].name, GHOSTS[ek].get("title", "")], 3))
	for zz in near: spawn_zone(zz)
	if t > near_t:
		near_t = t + 0.5; near = []
		for q in MAP.COLS * MAP.ROWS:
			var c = MAP.zone_center(q)
			if absf(c.x - L.x) < MAP.CW * 1.05 and absf(c.y - L.y) < MAP.CH * 1.05: near.append(q)
	for tt in 9:
		var lp = MAP.lair(tt)
		if Vector2(lp.x - L.x, lp.y - L.y).length() < 900: spawn_king(tt)
	spot_tick(dt)
	for si in 3:
		var gp = MAP.guard_pos(si)
		if Vector2(gp.x - L.x, gp.y - L.y).length() < 900: spawn_guards(si)
	spawn_bryan(z)
	var keep = []
	for e in foes:
		if e.guard >= 0 or e.bryan or e.ot or e.king >= 0: keep.append(e); continue
		if not near.has(e.z) and Vector2(e.x - L.x, e.y - L.y).length() > 1200: e.gone = true; _drop_view(e); continue
		keep.append(e)
	foes = keep
	for zz in packs:
		var np = []
		for pk in packs[zz]:
			var q = []
			for e in pk: if not e.gone and not e.fled and not e.done: q.append(e)
			if q.size(): np.append(q)
		packs[zz] = np
	for si in 3:
		var sid = sid_of(ci, si); var stg = CHAPTERS[ci].stages[si]; var gp = MAP.guard_pos(si); var d = Vector2(gp.x - L.x, gp.y - L.y).length()
		if J.t(S.cleared.get(sid)) or d > 300: continue
		if J.num(S.lv) < J.num(stg.req):
			if t - req_msg > 6: req_msg = t; msg("<b>%s</b>：需主公 Lv%d（建議鬼力 %s）。先回村升級再來。" % [stg.name, int(J.num(stg.req)), J.str(jm("GP", "stageNeed", [stg, sid]))], 4)
			continue
		if stg.get("before") != null and not J.t(S.seen.get(stg.before)) and not before_q:
			before_q = true; jm("Story", "queue", [stg.before, func(_t, _a): before_q = false]); return
		if guards.get(si) != null and not guards[si].is_empty() and not guards[si][0].awake:
			for e in guards[si]: e.awake = true
			msg("<b>%s</b>：「%s」" % [stg.name, "總監親自當值。" if si == 2 else "主管當值，閒人勿進。"], 2.5); shake = 6
	var party = []
	for u in units: if u.hp > 0 and not u.gone: party.append(u)
	var foes_a = []
	for e in foes:
		if e.hp > 0 and not e.fled and (ph != "work" or e.provoked or e.guard >= 0 or e.bryan or Vector2(e.x - L.x, e.y - L.y).length() < 110): foes_a.append(e)
	var calm = true
	for e in foes:
		if e.hp > 0 and not e.fled and not e.down > 0 and (e.provoked or e.awake) and Vector2(e.x - L.x, e.y - L.y).length() < 420: calm = false; break
	if calm:
		for u in party: u.hp = minf(u.maxhp, u.hp + u.maxhp * 0.03 * dt)
	# 我方
	for u in units:
		u.flash = maxf(0, u.flash - dt * 5); u.hurt = maxf(0, u.hurt - dt)
		if u.hp <= 0:
			u.dead_t += dt
			if u.role == "lead" and u.dead_t > 25:
				u.hp = u.maxhp * 0.6; u.dead_t = 0; u.x = L.x; u.y = L.y; u.vx = 0; u.vy = 0
				fx_text(u.x, u.y - 50, "歸隊！", Color("#9ff")); spr("fx_beam", u.x, u.y + 6, {"s0": 0.3, "s1": 0.4, "sx": 0.7, "life": 0.8, "anchor": 0.95})
				fx.append({"kind": "ring", "x": u.x, "y": u.y, "t": 0.0, "life": 0.5, "col": Color("#9ff"), "r": 60.0})
			continue
		if u.leader:
			if u.act != null: tick_act(u, dt)
			else:
				u.cd -= dt
				var tg = nearest(u, foes_a, u.rng + 10)
				if tg != null and u.cd <= 0 and not u.dash > 0: start_attack(u, tg)
			continue
		u.cd -= dt
		if u.role == "crew" and u.in_fight:
			u.g.fat = minf(100, J.num(u.g.get("fat", 0)) + dt * 0.5)
			if J.num(u.g.fat) >= 100 and not u.sick:
				u.sick = true; u.hp = 0; u.dead_t = 0; fx_text(u.x, u.y - 40, "請病假", Color("#fca")); msg("%s 過勞，請病假回村。" % u.name, 2.5); continue
			if J.num(u.g.fat) >= 70 and not u.tired: u.tired = true; u.atk *= 0.7
		if u.act != null: tick_act(u, dt); approach_v(u, 0, 0, dt); integrate(u, dt); continue
		var tg2 = nearest(u, foes_a, 240)
		u.in_fight = tg2 != null and Vector2(tg2.x - L.x, tg2.y - L.y).length() < 340
		var tl = null
		for q in tele:
			if Vector2((u.x - q.x) / q.r, (u.y - q.y) / (q.r * 0.6)).length() < 1.05: tl = q; break
		if tl != null:
			var dx = u.x - tl.x; var dy = u.y - tl.y; var d = sqrt(dx * dx + dy * dy)
			if d == 0: d = 1
			approach_v(u, dx / d * u.spd * 1.3, dy / d * u.spd * 1.3, dt)
		elif u.in_fight:
			var d = Vector2(tg2.x - u.x, (tg2.y - u.y) * 1.2).length(); var want = u.rng * (0.85 if u.rng > 60 else 0.8)
			if u.sk != null and u.energy >= 100 and (st().get("autoSk") != false or u.want_cast): start_attack(u, tg2, true); u.want_cast = false
			elif d > u.rng:
				var side = (1 if (u.ti if u.ti else u.slot) % 2 else -1) * 18
				steer(u, tg2.x + (-want if u.x < tg2.x else want), tg2.y + side, u.spd, dt, 24)
			else:
				approach_v(u, 0, 0, dt)
				if u.cd <= 0: start_attack(u, tg2)
		else: wander(u, dt)
		integrate(u, dt)
	# 敵方
	for e in foes:
		e.flash = maxf(0, e.flash - dt * 5); e.hurt = maxf(0, e.hurt - dt)
		if e.down > 0:
			e.down -= dt; approach_v(e, 0, 0, dt); integrate(e, dt)
			if e.down <= 0 and not e.done: resolve_down(e, "soul", true)
			continue
		if e.hp <= 0 or e.fled:
			e.dead_t += dt
			if e.fled: e.x += (-1 if e.flip else 1) * 160 * dt; e.y -= 20 * dt
			continue
		e.cd -= dt
		if e.slam_cd < -0.5: e.slam_cd = 3 + randf() * 3
		e.slam_cd -= dt
		if e.act != null: tick_act(e, dt); approach_v(e, 0, 0, dt); integrate(e, dt); continue
		var passive = (not e.awake) if e.guard >= 0 else (ph == "work" and not e.provoked and not e.bryan)
		var tg = null if passive else nearest(e, party, 280.0 if e.guard >= 0 else (420.0 if e.provoked else 190.0))
		var home = Vector2(e.x - e.hx, e.y - e.hy).length(); var spd = e.spd * (0.7 if ph == "off" else 1.0)
		if tg != null and home < (340 if e.guard >= 0 else 480):
			e.provoked = true; var d = Vector2(tg.x - e.x, (tg.y - e.y) * 1.2).length()
			var big = e.elite or e.boss or e.ot_boss or (e.bryan and e.k == "npc_rival")
			if big and e.slam_cd <= 0 and d < 200: e.slam_cd = 5.5 + randf() * 2.5; telegraph(e, tg); continue
			if e.sk != null and e.energy >= 100 and d < 220: start_attack(e, tg, true); continue
			if e.rng > 60 and d < 70:
				var dx = e.x - tg.x; var dy = e.y - tg.y; var dd = sqrt(dx * dx + dy * dy)
				if dd == 0: dd = 1
				approach_v(e, dx / dd * spd, dy / dd * spd, dt)
			elif d > e.rng: steer(e, tg.x + (-e.rng * 0.8 if e.x < tg.x else e.rng * 0.8), tg.y, spd * (1.5 if e.k == "xiaogui" and d > 120 else 1.0), dt, 20)
			else:
				approach_v(e, 0, 0, dt)
				if e.cd <= 0: start_attack(e, tg)
		elif home > 30:
			steer(e, e.hx, e.hy, spd * 0.7, dt, 40)
			if home > 300: e.hp = minf(e.maxhp, e.hp + e.maxhp * dt * 0.3)
		else:
			approach_v(e, 0, 0, dt, 600)
			if randf() < dt * 0.35 and e.z >= 0 and e.guard < 0 and not e.ot:
				var c0 = MAP.zone_center(e.z)
				e.hx = clampf(e.hx + (randf() - 0.5) * 110, c0.x - MAP.CW / 2 + 70, c0.x + MAP.CW / 2 - 70)
				e.hy = clampf(e.hy + (randf() - 0.5) * 80, c0.y - MAP.CH / 2 + 70, c0.y + MAP.CH / 2 - 70)
		integrate(e, dt)
	# 預警圈落地
	var nt = []
	for q in tele:
		q.t += dt
		if q.t < q.dur: nt.append(q); continue
		var src: PtU = q.src
		if src.hp > 0 and not src.down > 0:
			shake = 9; dust(q.x - 20, q.y, 1.6); dust(q.x + 20, q.y, 1.4)
			spr("fx_shock", q.x, q.y, {"ground": true, "s0": q.r * 1.4 / 256, "s1": q.r * 2.3 / 256, "life": 0.5})
			for u in units:
				if u.hp > 0 and not u.inv and Vector2((u.x - q.x) / q.r, (u.y - q.y) / (q.r * 0.6)).length() < 1: hit(src, u, 2.2, {"kb": 260.0, "from": Vector2(q.x, q.y)})
			snd("skill")
	tele = nt
	# 分開（軟推）
	var all = party.duplicate()
	for e in foes: if e.hp > 0 and not e.fled and not e.down > 0: all.append(e)
	var na = all.size()
	for i in na:
		var a: PtU = all[i]
		for j in range(i + 1, na):
			var b: PtU = all[j]
			var R0 = (a.s + b.s) * 30; var dx = b.x - a.x
			if absf(dx) >= R0: continue
			var dy = (b.y - a.y) * 1.5; var d = sqrt(dx * dx + dy * dy)
			if d > 0.1 and d < R0:
				var k = (R0 - d) / d * 4
				if not a.leader: a.vx -= dx * k * dt * 10; a.vy -= dy * k * dt * 6
				if not b.leader: b.vx += dx * k * dt * 10; b.vy += dy * k * dt * 6
	# 子彈
	var np2 = []
	for q in proj:
		var v: PtU = q.tg
		if v == null or v.hp <= 0 or v.down > 0:
			q.dead = q.get("dead", 0.0) + dt
			if q.dead < 0.15: np2.append(q)
			continue
		var ty = v.y - 34 * v.s * 1.65; var dx = v.x - q.x; var dy = ty - q.y; var d = sqrt(dx * dx + dy * dy); var stp = q.spd * dt
		q.trail.append(Vector2(q.x, q.y))
		if q.trail.size() > 7: q.trail.pop_front()
		if d <= stp + 6:
			hit(q.src, v, q.get("mult", 1.0)); spr("fx_fire", q.x, q.y, {"s0": 0.12, "s1": 0.26, "life": 0.18, "hue": q.hue, "rot": atan2(q.get("vy", 0.0), q.get("vx", 1.0)) + PI}); continue
		q.vx = dx; q.vy = dy; q.x += dx / d * stp; q.y += dy / d * stp + sin(t * 18 + q.ph) * 0.8; np2.append(q)
	proj = np2
	# Bryan 挖角
	if bryan != null:
		var b: PtU = bryan[0]
		if b.hp > 0:
			for u in units:
				if u.role == "crew" and u.hp > 0 and J.num(u.g.get("fat", 0)) >= 75 and Vector2(u.x - b.x, u.y - b.y).length() < 220:
					u.g.poached = 1.0; u.hp = 0; u.dead_t = 9; u.gone = true; fx_text(u.x, u.y - 40, "跳槽！", Color("#f88"))
					msg(T("Bryan：「%s，嚟我度，我哋冇 KPI 㗎。」%s跟咗 Bryan 走。" % [u.name, u.name], "Bryan：「%s，來我這邊，我們沒有 KPI 的。」%s跟 Bryan 走了。" % [u.name, u.name]), 4)
		var all_down = true
		for e in bryan: if e.hp > 0 or e.down > 0: all_down = false
		if all_down:
			bryan_done = true; bryan = null
			var back = []
			for g in S.ghosts: if J.t(g.get("poached")): back.append(g)
			var names = []
			for g in back: g.erase("poached"); names.append(J.str(g.name))
			if back.size(): msg(T("打贏 Bryan 部門！%s 返嚟咗：「其實佢嗰邊都有 KPI……」" % "、".join(names), "打贏 Bryan 部門！%s 回來了：「其實他那邊也有 KPI……」" % "、".join(names)), 5)
			else: msg(T("打贏 Bryan 部門！Bryan：「今次唔計，我啱啱熱緊身。」", "打贏 Bryan 部門！Bryan：「這次不算，我剛在熱身。」"), 5)
			gain({"coins": round(40 + 30 * zone_p(z)), "exp": 20})
	var keep2 = []
	for e in foes:
		if (e.hp <= 0 or e.fled) and not e.down > 0 and e.dead_t > 1.5: _drop_view(e); continue
		keep2.append(e)
	foes = keep2
	if ot != null:
		var all_ot = true
		for e in ot: if not ((e.hp <= 0 or e.fled) and not e.down > 0): all_ot = false
		if all_ot:
			ot = null; S.chests.p = J.num(S.chests.p) + 1; gain({"coins": round(80 + 60 * zone_p(9)), "exp": 30})
			jm("Fx", "toast", ["通宵加班房搞定！紫箱 ×1"]); msg(T("加班鬼：「多謝你哋……我終於可以收工。」佢瞓咗。", "加班鬼：「謝謝你們……我終於可以下班了。」他睡著了。"), 3)
	for tt in kings.keys():
		var g = kings[tt]
		if g == null: continue
		var lp = MAP.lair(tt)
		if not kings_woke.has(tt):
			if Vector2(lp.x - L.x, lp.y - L.y).length() < 300:
				kings_woke[tt] = 1
				for e in g: e.provoked = true
				var d = king_def(tt)
				msg(T("<b>%s</b>係我哋嘅地頭！" % N.TNAME[ci][tt], "<b>%s</b>是我們的地頭！" % N.TNAME[ci][tt]) + (("（大王：%s）" % (GHOSTS[d.big].name if GHOSTS.has(d.big) else "")) if d != null and d.get("big") else ""), 2.5); shake = 6
		var all_k = true
		for e in g: if e.hp > 0 or e.down > 0: all_k = false
		if all_k: kings[tt] = null; king_win(tt)
	for si in guards.keys():
		var g = guards[si]
		if g != null and g.size():
			var all_g = true
			for e in g: if e.hp > 0: all_g = false
			if all_g: guards[si] = null; stage_win(si)
	var nfx = []
	for f in fx:
		f.t += dt
		if f.t < f.life: nfx.append(f)
	fx = nfx
	if later_q.size():
		var nl = []
		var due = []
		for q in later_q:
			q.t -= dt
			if q.t > 0: nl.append(q)
			else: due.append(q)
		later_q = nl
		for q in due: q.f.call()
	if L.swing != null:
		L.swing.t += dt
		if L.swing.t > 0.45: L.swing = null
	ambient(dt)
	facilities(dt)
	var lx = L.x + L.vx * 0.25; var ly = L.y - 30 + L.vy * 0.2
	cam.x += (lx - cam.x) * minf(1, dt * 4.5); cam.y += (ly - cam.y) * minf(1, dt * 4.5)
	if L.hp <= 0 and not ended: end(true)
	if t - save_t > 10: save_t = t; persist()

var kings_woke := {}
var prof_u := 0
var prof_r := 0
var prof_n := 0

func nearest(u: PtU, list: Array, r: float):
	var b = null; var bd = r
	for v in list:
		if v.hp <= 0 or v.down > 0 or v.fled or v.gone or (v.guard >= 0 and not v.awake): continue
		var dx = v.x - u.x
		if absf(dx) >= bd: continue
		var d = Vector2(dx, (v.y - u.y) * 1.2).length()
		if d < bd: bd = d; b = v
	return b

func provoke(v: PtU) -> void:
	if not v.provoked and v.hp > 0: fx.append({"kind": "txt", "x": v.x, "y": v.y - 100 * v.s, "text": "！", "col": Color("#ff8a6a"), "t": 0.0, "life": 0.7, "big": true})
	v.provoked = true
	if v.z >= 0 and packs.has(v.z):
		for pk in packs[v.z]:
			if pk.has(v):
				for e in pk: e.provoked = true

func start_attack(u: PtU, v: PtU, cast := false) -> void:
	u.act = {"ph": "windup", "t": 0.0, "tg": v, "cast": cast, "dur": ATK.cast if cast else ATK.windup * (1.6 if u.boss else 1.0), "slam": false}
	u.cd = u.aspd * (0.85 + randf() * 0.3)
	if absf(v.x - u.x) > 2: u.flip = v.x < u.x
	if u.side == 0 and v.side == 1: provoke(v)
	if cast:
		u.energy = 0; snd("click")
		if u.side == 0 and u.role == "lead": QX.bump("cast")

func tick_act(u: PtU, dt: float) -> void:
	var a = u.act; a.t += dt
	if a.ph == "windup" and a.t >= a.dur:
		a.ph = "strike"; a.t = 0.0
		if u.hp > 0: fire(u, a)
	elif a.ph == "strike" and a.t >= ATK.strike: a.ph = "recover"; a.t = 0.0
	elif a.ph == "recover" and a.t >= ATK.recover: u.act = null

func proj_col(u: PtU) -> Color: return {"yuan": Color("#d6a8ff"), "chan": Color("#ffc27a"), "lan": Color("#9fdcff")}.get(u.fac, Color("#bff"))

func fire(u: PtU, a: Dictionary) -> void:
	if a.cast: skill(u); return
	if a.slam: return
	var v: PtU = a.tg
	if v == null or v.hp <= 0 or v.down > 0: return
	if u.leader and u.wpn != null: wfire(u, v); return
	if u.rng > 60:
		proj.append({"x": u.x + (-14 if u.flip else 14), "y": u.y - 44 * u.s * 1.65, "tg": v, "src": u, "spd": 560.0, "col": Color("#ff9ac0") if u.side else proj_col(u), "hue": HUE.foe if u.side else HUE.get(u.fac, 0.0), "big": 1.3 if u.role == "lead" or u.elite or u.boss else 1.0, "trail": [], "ph": randf() * 6})
		return
	var dir = signf(v.x - u.x); if dir == 0: dir = 1
	u.vx += dir * 120
	var big = 1.5 if u.boss else (1.15 if u.leader or u.role == "lead" or u.elite else (0.6 if u.role == "troop" else 0.8))
	spr("fx_slash", v.x - dir * 6, v.y - 34 * v.s * 1.65, {"s0": 0.16 * big, "s1": 0.3 * big, "life": 0.2, "flip": dir < 0, "rot": (randf() - 0.5) * 0.6, "hue": -155.0 if u.side else (0.0 if u.leader else HUE.get(u.fac, 0.0))})
	hit(u, v, 1)

func later(tt: float, f: Callable) -> void: later_q.append({"t": tt, "f": f})
func foes_near(x: float, y: float, r: float) -> Array:
	var out = []
	for e in foes:
		if e.hp > 0 and not e.down > 0 and not e.fled and not (e.guard >= 0 and not e.awake) and Vector2(e.x - x, (e.y - y) * 1.3).length() < r: out.append(e)
	return out
func hy_of(e: PtU) -> float: return e.y - 34 * e.s * 1.65

func wfire(u: PtU, v: PtU) -> void:
	var w = u.wpn; var m = J.num(w.lvMul); var dir = signf(v.x - u.x); if dir == 0: dir = 1
	var hue = HUE.get(J.str(w.it.f), 0.0); var sty = J.str(w.sty)
	u.swing = {"sty": sty, "t": 0.0}
	match sty:
		"shoot":
			for i in 3:
				later(i * 0.09, func():
					if v.hp <= 0: return
					proj.append({"x": u.x + dir * 16, "y": u.y - 50, "tg": v, "src": u, "spd": 720.0, "col": Color("#d6e4ff"), "hue": hue, "big": 0.7, "trail": [], "ph": randf() * 6, "mult": 0.5 * m}); snd("click"))
			u.vx -= dir * 90
		"smash", "drain":
			u.vx += dir * 260
			var r = 80.0 if sty == "smash" else 62.0; var hs = foes_near(v.x, v.y, r)
			for e in hs: hit(u, e, (1.6 if sty == "smash" else 1.3) * m, {"kb": 230.0, "from": Vector2(u.x, u.y)})
			spr("fx_shock", v.x, v.y, {"ground": true, "s0": 0.2, "s1": 0.55, "life": 0.35, "hue": hue}); dust(v.x, v.y, 1.2); shake = maxf(shake, 6); stop = maxf(stop, 0.05)
			if sty == "drain" and hs.size():
				var h = u.atk * 0.3 * hs.size() * m; u.hp = minf(u.maxhp, u.hp + h); fx_text(u.x, u.y - 70, "+%d" % round(h), Color("#8affb0"))
				for e in hs: spr("fx_heal", e.x, hy_of(e), {"s0": 0.15, "s1": 0.05, "life": 0.4, "vx": u.x - e.x, "vy": -(u.y - e.y), "hue": HUE.yuan})
		"spin", "flail":
			var r2 = 120.0 if sty == "spin" else 160.0
			for e in foes_near(u.x, u.y, r2): hit(u, e, (0.8 if sty == "spin" else 0.72) * m, {"kb": 200.0, "from": Vector2(u.x, u.y)})
			spr("fx_wind", u.x, u.y, {"s0": 0.4, "s1": r2 / 150, "life": 0.4, "anchor": 0.85, "hue": hue, "spin": 9.0})
			fx.append({"kind": "ring", "x": u.x, "y": u.y, "t": 0.0, "life": 0.35, "col": Color("#bfe0ff"), "r": r2})
		"beam":
			var Lb = J.num(w.S.rng) + 50; var ang = atan2(v.y - u.y, v.x - u.x); var ex = cos(ang); var ey = sin(ang)
			for e in foes.duplicate():
				if e.hp > 0 and not e.down > 0 and not e.fled:
					var px = e.x - u.x; var py = e.y - u.y; var tt = px * ex + py * ey
					if tt > 0 and tt < Lb and absf(px * ey - py * ex) < 34: hit(u, e, 1.0 * m, {"kb": 120.0, "from": Vector2(u.x, u.y)})
			spr("fx_beam", u.x + ex * Lb / 2, u.y - 40 + ey * Lb / 2, {"s0": 0.4, "s1": 0.5, "sx": Lb / 180, "life": 0.25, "rot": ang - PI / 2, "hue": hue}); flash_a = maxf(flash_a, 0.08)
		"combo":
			for i in 3:
				later(i * 0.12, func():
					if v.hp <= 0: return
					u.vx += dir * 60; hit(u, v, (0.8 if i == 2 else 0.45) * m, {"kb": 260.0 if i == 2 else 40.0})
					spr("fx_slash", v.x - dir * 6, hy_of(v) + (i - 1) * 8, {"s0": 0.16, "s1": 0.3, "life": 0.16, "flip": (dir > 0) if i % 2 else (dir < 0), "rot": (i - 1) * 0.5, "hue": hue}))
		"splash":
			var tx = v.x; var ty = v.y
			spr("fx_smoke", u.x + dir * 20, u.y - 50, {"s0": 0.1, "s1": 0.2, "life": 0.3, "vx": tx - u.x, "vy": -(ty - u.y), "hue": hue})
			later(0.3, func():
				for e in foes_near(tx, ty, 95): hit(u, e, 0.85 * m, {"kb": 90.0, "from": Vector2(tx, ty)}); e.cd += 0.5; e.slow = 1.5
				spr("fx_smoke", tx, ty, {"ground": true, "s0": 0.3, "s1": 0.75, "life": 0.7, "hue": hue}); fx_text(tx, ty - 60, "燙！", Color("#ffc27a")))
		"pull":
			var d = Vector2(v.x - u.x, v.y - u.y).length(); if d == 0: d = 1
			if not v.boss: v.kb = Vector2(-(v.x - u.x) / d * 520, -(v.y - u.y) / d * 300); v.has_kb = true
			spr("fx_bolt", (u.x + v.x) / 2, (u.y + v.y) / 2 - 40, {"s0": 0.2, "s1": 0.3, "sx": d / 160, "life": 0.2, "rot": atan2(v.y - u.y, v.x - u.x), "hue": hue})
			later(0.18, func(): if v.hp > 0: hit(u, v, 1.25 * m, {"kb": 200.0}))
		"poke":
			var ang2 = atan2(v.y - u.y, v.x - u.x); var ex2 = cos(ang2); var ey2 = sin(ang2); u.vx += ex2 * 160
			var cand = []
			for e in foes:
				if e.hp > 0 and not e.down > 0 and not e.fled:
					var px = e.x - u.x; var py = e.y - u.y; var along = px * ex2 + py * ey2; var off = absf(px * ey2 - py * ex2)
					if along > 0 and along < J.num(w.S.rng) + 30 and off < 30: cand.append([e, along])
			cand.sort_custom(func(a, b): return a[1] < b[1])
			for q in cand.slice(0, 2): hit(u, q[0], 0.95 * m, {"kb": 150.0, "from": Vector2(u.x, u.y)})
			spr("fx_dash", u.x + ex2 * 60, u.y - 40, {"s0": 0.25, "s1": 0.4, "life": 0.18, "rot": ang2, "hue": hue})
		"slam":
			u.vx += dir * 200
			later(0.12, func():
				for e in foes_near(v.x, v.y, 150):
					hit(u, e, 1.35 * m, {"kb": 120.0, "from": Vector2(v.x, v.y)})
					if not e.boss and e.hp > 0: e.cd += 1.0; fx_text(e.x, e.y - 70 * e.s, "壓扁", Color("#ffd0a0"))
				spr("fx_shock", v.x, v.y, {"ground": true, "s0": 0.3, "s1": 0.9, "life": 0.45, "hue": hue}); dust(v.x - 30, v.y, 1.6); dust(v.x + 30, v.y, 1.6); shake = maxf(shake, 9); stop = maxf(stop, 0.07); snd("skill"))

func hit(u: PtU, v: PtU, mult: float, o := {}) -> void:
	if v.hp <= 0 or v.down > 0 or v.inv: return
	var crit = u.side == 0 and randf() < (0.16 if u.leader else 0.1); var bf = 1.3 if u.side == 0 and buff > 0 else 1.0
	var dmg = maxf(1, round(u.atk * mult * bf * (1.8 if crit else 1.0) * (0.9 + randf() * 0.2)))
	v.hp -= dmg; v.hurt = 0.24; v.flash = 1; v.last_by = u
	if v.act != null and v.act.ph == "windup" and not v.boss and (crit or mult > 1.5): v.act = null
	var from: Vector2 = o.get("from", Vector2(u.x, u.y))
	var dx = v.x - from.x; var dy = v.y - from.y; var dl = sqrt(dx * dx + dy * dy); if dl == 0: dl = 1
	var kb = (o.get("kb", 0.0) if o.get("kb", 0.0) else (170.0 if crit else (150.0 if mult > 1 else 70.0))) * (0.25 if v.boss else (0.5 if v.elite or v.guard >= 0 else 1.0))
	v.kb = Vector2(dx / dl * kb, dy / dl * kb * 0.6); v.has_kb = true
	if u.sk != null: u.energy = minf(100, u.energy + (4 if mult > 1 else 10))
	if v.sk != null and v.side == 1: v.energy = minf(100, v.energy + 6)
	if u.sk != null and u.sk.get("drain") and mult > 1: u.hp = minf(u.maxhp, u.hp + dmg * J.num(u.sk.drain))
	if u.fac == "chan" and u.side == 0 and u.role == "crew": u.hp = minf(u.maxhp, u.hp + dmg * 0.08)
	if u.fac == "lan" and u.side == 0 and randf() < 0.12: v.cd += 0.6; fx_text(v.x, v.y - 70 * v.s, "卡到陰", Color("#9fdcff"))
	var hy = v.y - 34 * v.s * 1.65
	spark(v.x - dx / dl * 6, hy, 1.3 if crit or mult > 1 else (0.7 if v.side == 0 else 0.9), v.side == 0)
	if crit or mult > 1 or v.side == 0 or u.leader or u.role == "lead" or v.boss or v.elite:
		fx.append({"kind": "num", "x": v.x + (randf() - 0.5) * 14, "y": hy - 30 * v.s, "vx": (dx / dl) * (14 + randf() * 18), "text": ("%d!" % dmg) if crit else str(int(dmg)), "col": Color("#ffd84a") if crit else (Color.WHITE if v.side else Color("#ff8a8a")), "big": crit or mult > 1.4, "t": 0.0, "life": 0.95})
	if crit or mult > 1.4: shake = maxf(shake, 4 if crit else 6); stop = maxf(stop, 0.05)
	if Time.get_ticks_msec() - snd_at > 80: snd_at = Time.get_ticks_msec(); snd("hit")
	if v.hp <= 0:
		v.hp = 0; shake = maxf(shake, 5 if v.side == 1 else 3); spark(v.x, hy, 1.6, false)
		if v.side == 1: stop = maxf(stop, 0.06)
		on_down(v, u)

func telegraph(e: PtU, tg: PtU) -> void:
	var r = 120.0 if e.boss else 92.0
	tele.append({"x": tg.x, "y": tg.y, "r": r, "t": 0.0, "dur": 1.1 if e.boss else 0.9, "src": e})
	e.act = {"ph": "windup", "t": 0.0, "tg": tg, "cast": false, "dur": 1.1 if e.boss else 0.9, "slam": true}; e.flip = tg.x < e.x

func skill(u: PtU) -> void:
	var sk = u.sk
	if sk == null: return
	var fa = []; var al = []
	for e in foes: if e.hp > 0 and not e.down > 0 and not e.fled: fa.append(e)
	for x in units: if x.hp > 0 and not x.gone: al.append(x)
	var enemies = fa if u.side == 0 else al; var mine = al if u.side == 0 else fa
	var col = Color("#ff9ac0") if u.side else Color("#9ff3ff")
	var kind = J.str(sk.get("kind", "")); var mult = J.num(sk.get("mult", 1.0))
	if kind == "heal":
		for v in mine:
			if Vector2(v.x - u.x, v.y - u.y).length() < 280:
				var h = v.maxhp * mult; v.hp = minf(v.maxhp, v.hp + h)
				spr("fx_heal", v.x, v.y - 30, {"s0": 0.15, "s1": 0.35, "life": 0.8, "vy": 30.0, "spin": 1.5}); fx_text(v.x, v.y - 60, "+%d" % round(h), Color("#8affb0"))
				fx.append({"kind": "ring", "x": v.x, "y": v.y, "t": 0.0, "life": 0.5, "col": Color("#8affb0"), "r": 40.0})
	elif kind == "aoe":
		for v in enemies.duplicate():
			if Vector2(v.x - u.x, (v.y - u.y) * 1.3).length() < 210: hit(u, v, mult, {"kb": 240.0})
		var hh = -155.0 if u.side else 0.0
		spr("fx_wind", u.x, u.y, {"s0": 0.4, "s1": 1.1, "life": 0.6, "anchor": 0.85, "hue": hh}); spr("fx_scream", u.x, u.y - 40, {"s0": 0.3, "s1": 1.6, "life": 0.5, "alpha": 0.8, "hue": hh}); spr("fx_shock", u.x, u.y, {"ground": true, "s0": 0.8, "s1": 1.8, "life": 0.5, "hue": hh})
		flash_a = 0.35; shake = 8
	else:
		var v = nearest(u, enemies, 280)
		if v != null:
			var n = int(J.num(sk.get("hits", 1))); if n < 1: n = 1
			for i in n: hit(u, v, mult / n, {"kb": 260.0 if i == n - 1 else 60.0})
			var d = signf(v.x - u.x); if d == 0: d = 1
			spr("fx_slash", v.x, hy_of(v), {"s0": 0.35, "s1": 0.6, "life": 0.3, "flip": d < 0, "hue": -155.0 if u.side else HUE.get(u.fac, 0.0)}); spr("fx_hit", v.x, hy_of(v), {"s0": 0.2, "s1": 0.45, "life": 0.25}); spr("fx_bolt", v.x, v.y - 50, {"s0": 0.25, "s1": 0.4, "life": 0.2})
			if sk.get("steal") and u.side == 0: gain({"coins": J.num(sk.steal)})
	fx.append({"kind": "num", "x": u.x, "y": u.y - 95 * u.s * 1.65, "text": J.str(sk.get("name", "")), "col": col, "skill": true, "t": 0.0, "life": 1.1})
	snd("skill")

func dash() -> void:
	if L == null or L.hp <= 0 or dash_cd > 0 or ended: return
	var f = face if has_face else Vector2(-1 if L.flip else 1, 0)
	L.vx = f.x * 640; L.vy = f.y * 640; L.dash = 0.24; L.dash_hit = {}; L.act = null
	dash_cd = 3.5; dust(L.x, L.y, 1.1); spr("fx_dash", L.x + f.x * 50, L.y - 34, {"s0": 0.35, "s1": 0.55, "life": 0.3, "rot": atan2(f.y, f.x)}); snd("click")

func pie() -> void:
	if pie_cd > 0 or ended or L.hp <= 0: return
	buff = 8; pie_cd = 30; flash_a = 0.25; QX.bump("pie")
	for u in units:
		if u.hp > 0:
			spr("fx_aura", u.x, u.y + 4, {"s0": 0.15, "s1": 0.3, "life": 0.8, "anchor": 0.95})
			if u.g != null and u.role == "crew": u.g.fat = minf(100, J.num(u.g.get("fat", 0)) + 4)
	var lines = [["阿福", T("各位！做完今晚，年尾分紅一定有！（應該）", "各位！做完今晚，年底分紅一定有！（應該）")], ["阿福", T("公司好睇好你哋㗎！（我估）", "公司很看好你們的！（我猜）")], ["阿福", T("呢個 project 做完，大家升職！（未批）", "這個 project 做完，大家升職！（還沒批）")]]
	var l = lines[randi() % lines.size()]; msg("<b>%s</b>：%s　全隊攻擊 +30%%" % [l[0], l[1]], 2.5); snd("gong")

func spark(x: float, y: float, k: float, red: bool) -> void:
	spr("fx_hit", x, y, {"s0": 0.08 * k, "s1": 0.22 * k, "life": 0.18, "rot": randf() * 6.28, "hue": -155.0 if red else 0.0})
	if k >= 1.3: spr("fx_bolt", x, y - 6, {"s0": 0.18, "s1": 0.3, "life": 0.16, "rot": (randf() - 0.5) * 1.2})

func spr(n: String, x: float, y: float, o := {}) -> void:
	var f = {"kind": "spr", "n": n, "x": x, "y": y, "t": 0.0, "life": 0.3, "s0": 0.3, "s1": 0.5, "rot": 0.0, "alpha": 1.0, "add": true, "sx": 1.0, "sy": 1.0, "vy": 0.0, "hue": 0.0}
	f.merge(o, true)
	fx.append(f)

func dust(x: float, y: float, k: float) -> void:
	spr("fx_dust", x + (randf() - 0.5) * 10, y, {"add": true, "alpha": 0.45, "s0": 0.06 * k, "s1": 0.16 * k, "life": 0.5, "vy": 10.0, "anchor": 0.8, "flip": randf() < 0.5})

func ambient(dt: float) -> void:
	while wisps.size() < 26: wisps.append({"x": L.x + (randf() - 0.5) * 700, "y": L.y + (randf() - 0.5) * 1000, "vx": (randf() - 0.5) * 14, "vy": -6 - randf() * 12, "ph": randf() * 6, "r": 1.2 + randf() * 1.8, "hue": 0 if randf() < 0.7 else 1})
	for w in wisps:
		w.x += (w.vx + sin(t + w.ph) * 8) * dt; w.y += w.vy * dt
		if absf(w.x - L.x) > 420 or absf(w.y - L.y) > 620: w.x = L.x + (randf() - 0.5) * 700; w.y = L.y + 300 + randf() * 300

func fx_text(x: float, y: float, text: String, col: Color, big := false) -> void:
	fx.append({"kind": "num", "x": x, "y": y, "text": text, "col": col, "big": big, "t": 0.0, "life": 0.95, "vx": (randf() - 0.5) * 30})

func msg(h: String, sec := 3.0) -> void:
	if hud: hud.msg(html2bb(h), sec)

# ---------------- 打倒：靈體不穩 → 送去投胎／遞合約 ----------------
func on_down(v: PtU, _by: PtU) -> void:
	if v.side == 0:
		v.dead_t = 0
		if v.role == "crew": v.g.fat = 100.0; fx_text(v.x, v.y - 40, "倒下", Color("#fca"))
		if v.role == "troop": S.res.troops = maxf(0, J.num(S.res.troops) - 25)
		return
	streak += 1; loot.kills += 1; st().kills = J.num(st().get("kills", 0)) + 1
	QX.bump("k_" + v.k)
	if v.elite: QX.bump("elite")
	for u in units:
		if u.role == "crew" and u.hp > 0 and u.in_fight: u.g.fat = minf(100, J.num(u.g.get("fat", 0)) + 1.5)
	if v.guard >= 0 or v.bryan or v.ot_boss: v.dead_t = 0; soul_drop(v, 0.6); return
	v.down = DOWN_T; v.down_max = DOWN_T; downs.append(v)
	if J.t(st().get("auto")): resolve_down(v, "soul"); return
	down_ui()

func sign_info(v: PtU) -> Dictionary:
	var p = st(); var ph = phase(J.num(p.min)); var isN = N30_G.has(v.k); var F = js("F")
	if isN and J.t(jm("N30W", "owned", [v.k])): return {"ok": false, "why": "已經收服了"}
	if isN:
		var tier = N30_TIER.get(J.str(N30_G[v.k].t), {})
		if J.num(S.lv) < J.num(tier.get("req", 0)): return {"ok": false, "why": "需主公 Lv%d" % int(J.num(tier.req))}
	if not isN and not FODDER.has(v.k): return {"ok": false, "why": "不肯簽"}
	if not isN and J.num(jc("fodderCount")) >= J.num(J.mc(F, "rosterCap", [])): return {"ok": false, "why": "編制滿了（升級民宅）"}
	var ch = 30.0 if isN else 60.0
	var clr = 0
	for si in 3: if J.t(S.cleared.get(sid_of(ci, si))): clr += 1
	ch *= 0.8 + 0.4 * clr / 3.0
	ch += J.num(p.pity.get(v.k, 0))
	var fear = false
	if v.last_by != null and has_g("Rework"):
		var f = jm("Rework", "fearOf", [v.k]); var ts = jm("Rework", "typesOf", [v.last_by.k])
		if ts is Array and f is Dictionary and f.get("w") is Array:
			for tt in ts: if f.w.has(tt): fear = true
		if fear: ch += 20
	if ph == "zi": ch -= 10
	if ph == "off": ch += 10
	ch = clampf(round(ch), 5, 95)
	var cost = round(30 + 8 * v.p if isN else 8 + 3 * v.p)
	var ok = J.num(S.res.buns) >= cost
	return {"ok": ok, "why": "" if ok else "壽包不夠", "ch": ch, "cost": cost, "fear": fear, "isN": isN}

func soul_drop(v: PtU, mul := 1.0) -> void:
	var ph = phase(J.num(st().min)); var m = mul * (2.0 if ph == "zi" else 1.0) * (1 + minf(1, streak * 0.01)) * (5.0 if v.elite else 1.0)
	var coins = maxf(1, round((3 + 2.2 * v.p) * m)); var mat = maxf(1, round((1 + v.p / 5) * m * (0.7 + randf() * 0.6))); var exp = maxf(1, round((1 + v.p * 0.8) * (4.0 if v.elite else 1.0)))
	var f = v.fac if FAC.has(v.fac) else "lan"; var g = {"coins": coins, "exp": exp}; g[f] = mat; gain(g)
	if v.elite and randf() < 0.5: S.chests.g = J.num(S.chests.g) + 1; fx_text(v.x, v.y - 90, "綠箱 ×1", Color("#9f9"), true)
	fx_text(v.x, v.y - 70, "+%d 冥幣　+%d %s" % [coins, mat, FAC[f].mat], Color("#ffe08a"))
	spr("fx_beam", v.x, v.y + 6, {"s0": 0.35, "s1": 0.5, "sx": 0.7, "life": 1.1, "anchor": 0.95, "fadeIn": true}); spr("fx_gold", v.x, v.y - 40, {"s0": 0.15, "s1": 0.35, "life": 0.7, "vy": 40.0})

func gain(g: Dictionary) -> void:
	for k in g:
		if k == "coins": S.res.coins = J.num(S.res.coins) + g.coins; loot.coins += g.coins
		elif k == "exp": jc("gainExp", [float(g.exp)]); loot.exp += g.exp
		elif FAC.has(k): st().mats[k] = J.num(st().mats[k]) + g[k]; loot[k] += g[k]

func resolve_down(v: PtU, how: String, _timeout := false) -> void:
	if v.done: return
	v.done = true; v.down = 0; v.dead_t = 0; downs.erase(v)
	if how == "soul": soul_drop(v); v.soul = true; QX.bump("soul")
	else:
		var I = sign_info(v)
		if not I.ok:
			v.done = false; v.down = maxf(0.5, v.down); downs.append(v); jm("Fx", "toast", [I.why]); return
		S.res.buns = J.num(S.res.buns) - I.cost; loot.buns += I.cost
		if randf() * 100 < I.ch:
			st().pity[v.k] = 0.0; loot.rec += 1; st().rec = J.num(st().get("rec", 0)) + 1; v.signed = true
			if I.isN:
				var k = v.k; var G = GHOSTS[k]
				jm("Story", "queue", [{"style": "narr", "lines": [[G.name, G.get("say", "")], ["旁白", T("%s簽咗合約，跟你返落魄村。" % G.name, "%s簽了合約，跟你回落魄村。" % G.name)]]}, func(_t, _a): jc("joinGhost", [k]); persist()])
			else:
				var g = add_crew(v.k, v.p, v.elite, v.x, v.y)
				msg("<b>收編成功！</b>%s（%s・Lv%d）加入部門。%s" % [g.name, g.q, int(J.num(g.lv)), "（對症收編 +20%）" if I.fear else ""], 3)
			fx_text(v.x, v.y - 80, "簽約！", Color("#9fffb0"), true); spr("fx_ring", v.x, v.y, {"ground": true, "s0": 0.2, "s1": 0.55, "life": 0.8}); spr("fx_gold", v.x, v.y - 50, {"s0": 0.2, "s1": 0.5, "life": 0.8, "vy": 30.0}); snd("gong")
		else:
			st().pity[v.k] = J.num(st().pity.get(v.k, 0)) + 15; v.fled = true; spr("fx_smoke", v.x, v.y - 30, {"s0": 0.2, "s1": 0.5, "life": 0.7, "add": false, "alpha": 0.9})
			fx_text(v.x, v.y - 80, "跑掉了！", Color("#fca"), true); msg(T("%s睇完合約，走咗。（下次收同種 +15%%）" % v.name, "%s看完合約，跑了。（下次收同種 +15%%）" % v.name), 2.5)
	down_ui(); save()

func add_crew(k: String, p: float, rare: bool, x: float, y: float) -> Dictionary:
	var F = js("F")
	var lv = maxf(1, minf(J.num(J.mc(F, "ghostCap", [])), round(1 + p * 1.6)))
	var purple = rare or randf() < 0.12; var m = 1.45 if purple else 1.0
	var s3 = []
	for i in 3: s3.append(round((15 + randf() * 32) * m))
	var used = {}
	for g in S.ghosts: used[g.name] = 1
	var NICKS: Array = js("NICKS"); var name = J.str(FODDER[k].name)
	for i in 40:
		name = J.str(FODDER[k].name) + "・" + J.str(NICKS[randi() % NICKS.size()])
		if not used.has(name): break
	var g = {"id": "g%d" % int(J.num(S.uid)), "k": k, "name": name, "q": "紫" if purple else "藍", "lv": lv, "st": s3, "post": null, "spent": 0.0, "fat": 0.0}
	S.uid = J.num(S.uid) + 1
	S.ghosts.append(g); S.cnt.recruit = J.num(S.cnt.get("recruit", 0)) + 1
	var n_crew = 0
	for u in units: if u.role == "crew" and not u.gone: n_crew += 1
	if n_crew < int(J.cl(N.crewCap, null, [])):
		var u = unit_from_ghost(g, "crew"); u.slot = 3 + n_crew; u.x = x; u.y = y; units.append(u)
	if has_g("Chatter") and J.gp(js("Chatter"), "onRecruit") != null: jm("Chatter", "onRecruit", [g])
	return g

func down_ui() -> void:
	var v = downs.back() if downs.size() else null
	if v == null: hud.down_hide(); down_v = null; return
	if down_v == v: return
	down_v = v
	hud.down_show(v, sign_info(v))

# ---------------- 探索點 ----------------
func spot_tick(dt: float) -> void:
	var rs = reg_st()
	for g in MAP.GATES:
		if g.sec and not J.t(rs.sg.get(str(g.i))) and Vector2(g.x - L.x, g.y - L.y).length() < 300:
			rs.sg[str(g.i)] = 1.0
			var to = g.b if MAP.ter_xy(L.x, L.y) == g.a else g.a
			msg("發現暗路！通往 <b>%s</b>" % N.TNAME[ci][to], 3); snd("click"); persist(); J.cl(N.emit, null, ["secret", {"ci": float(ci), "gate": float(g.i), "to": float(to)}])
	var digging = null
	for sp in spots:
		var d = Vector2(sp.x - L.x, (sp.y - L.y) * 1.2).length()
		if sp.k == "lm" and not J.t(rs.lm.get(str(sp.id))) and d < 170:
			rs.lm[str(sp.id)] = 1.0; QX.bump("lm"); var rew = {"coins": 8 + ci * 6, "exp": 6 + ci * 3}; gain(rew); reveal_around(sp.x, sp.y, 7)
			msg("<b>發現地標：%s</b>　冥幣 +%d　好評 +%d　（地標 %d/%d）" % [sp.name, rew.coins, rew.exp, rs.lm.size(), N.LMNAME[ci].size()], 3.5)
			spr("fx_ring", sp.x, sp.y, {"ground": true, "s0": 0.2, "s1": 0.9, "life": 0.7, "hue": HUE.lan}); snd("click"); persist()
			J.cl(N.emit, null, ["discover", {"ci": float(ci), "id": float(sp.id), "name": sp.name, "t": float(sp.t)}])
		elif sp.k == "pg" and not J.t(rs.pg.get(str(sp.id))) and d < 70:
			rs.pg[str(sp.id)] = 1.0; var G = GHOSTS[sp.gk]; gain({"exp": 10 + ci * 4}); persist(); J.cl(N.emit, null, ["page", {"ci": float(ci), "id": float(sp.id), "gk": sp.gk}])
			var tot = page_ghosts().size()
			jm("Story", "queue", [{"style": "narr", "lines": [["旁白", T("拾到典籍殘頁・%s" % G.name, "撿到典籍殘頁・%s" % G.name)], ["旁白", J.str(jc("L", [G.get("lore", "")]))], ["旁白", "（殘頁 %d/%d）" % [rs.pg.size(), tot]]]}])
		elif sp.k == "ca" and not J.t(rs.ca.get(str(sp.id))) and d < 60: digging = sp
	if digging != null and Vector2(L.vx, L.vy).length() < 60:
		if dig == null or dig.sp != digging: dig = {"sp": digging, "t": 0.0}
		dig.t += dt
		if dig.t > 1.3:
			var sp = digging; rs.ca[str(sp.id)] = 1.0; dig = null; QX.bump("dig")
			var f = FAC.keys()[sp.id % 3]; var n = 3 + randi() % 4 + ci * 2; var coins = 15 + ci * 12; var box = randf() < 0.18
			loot[f] += n; st().mats[f] = J.num(st().mats[f]) + n; gain({"coins": coins})
			if box: S.chests.b = J.num(S.chests.b) + 1
			msg("挖到埋咗嘅嘢：%s +%d　冥幣 +%d%s" % [FAC[f].mat, n, coins, "　<b>藍箱 ×1</b>" if box else ""], 3)
			dust(sp.x, sp.y, 1.5); spr("fx_gold", sp.x, sp.y - 30, {"s0": 0.2, "s1": 0.6, "life": 0.8}); persist(); J.cl(N.emit, null, ["cache", {"ci": float(ci), "id": float(sp.id)}])
	elif dig != null: dig = null

# ---------------- 設施 ----------------
func station_cost(z: int) -> int:
	var c = ci + 1
	return 0 if z == _start_z() else int(round((10 + 4 * MAP.ter_of(z)) * pow(c, 1.5)))
func mat_total() -> float:
	var m = st().mats; return J.num(m.yuan) + J.num(m.chan) + J.num(m.lan)
func pay_mat(n: float) -> void:
	var m = st().mats; var left = n
	var ks = ["yuan", "chan", "lan"]; ks.sort_custom(func(a, b): return J.num(m[a]) > J.num(m[b]))
	for k in ks:
		var d = minf(J.num(m[k]), left); m[k] = J.num(m[k]) - d; left -= d
		if left <= 0: break
func day_no() -> int: return int(floor(J.now() / 864e5))

func facilities(_dt: float) -> void:
	var rs = reg_st(); var day = day_no()
	var nf = null
	for f in MAP.FACI:
		if Vector2(f.x - L.x, f.y - L.y).length() < 90: nf = f; break
	var key = ""
	if nf != null: key = "%s%d:%d%d%s%s" % [nf.t, nf.z, 1 if J.t(rs.sta.get(str(nf.z))) else 0, 1 if tea.get(nf.z, 0.0) > t else 0, J.num(rs.get("ot", -1)) == day, J.num(rs.get("pr", -1)) == day]
	if key == act_key: return
	act_key = key
	if nf == null: hud.act_hide(); return
	var title = ""; var desc = ""; var btns = []
	var F = js("F")
	if nf.t == "station":
		if not J.t(rs.sta.get(str(nf.z))):
			var c = station_cost(nf.z)
			title = "陰間地鐵站（未開通）"; desc = "開通後可從準備畫面直接在這裡出發，巡邏中也能互相轉站。"
			btns.append(["開通（執念 %d，任何派系）" % c, mat_total() >= c, func(): use_faci(nf), true])
		else:
			title = "陰間地鐵站・%s" % N.TNAME[ci][MAP.ter_of(nf.z)]
			var others = []
			for f in MAP.FACI: if f.t == "station" and f.z != nf.z and J.t(rs.sta.get(str(f.z))): others.append(f)
			desc = "搭到：" if others.size() else "其他站未開通"
			for f in others:
				var ff = f
				btns.append(["%s站" % N.TNAME[ci][MAP.ter_of(f.z)], true, func(): teleport(ff.x + 60, ff.y + 60), false])
	elif nf.t == "tea":
		var cdv = tea.get(nf.z, 0.0) - t
		title = "陰間茶水間"; desc = "全部門回血，過勞 -40。"
		btns.append(["在沖咖啡（%d 秒）" % ceil(cdv) if cdv > 0 else "進去歇一下", cdv <= 0, func(): use_faci(nf), true])
	elif nf.t == "prison":
		title = "扣押室"
		if J.num(rs.get("pr", -1)) == day: desc = "今天已經救過人，明天再來。"
		else:
			desc = "關著一隻欠交報告的實習鬼。救牠出來，牠會自願加入部門（要有編制）。"
			var room = J.num(jc("fodderCount")) < J.num(J.mc(F, "rosterCap", []))
			btns.append(["救人" if room else "編制滿了", room, func(): use_faci(nf), true])
	elif nf.t == "overtime":
		title = "通宵加班房"
		if J.num(rs.get("ot", -1)) == day: desc = "今晚已經加過班，明晚再來。"
		else:
			desc = "裡面有隻連加三晚班的鬼（攻擊 ×3、血 ×6），帶著 4 個實習鬼。打贏有大獎（紫箱）。"
			btns.append(["開門", true, func(): use_faci(nf), true])
	hud.act_show(title, desc, btns)

func teleport(x: float, y: float) -> void:
	L.x = x; L.y = y
	for u in units:
		u.vx = 0; u.vy = 0
		if not u.leader: var o = formation(u.slot); u.x = x + o.x; u.y = y + o.y
	cam = Vector2(x, y); act_key = "x"; reveal_around(x, y); msg("到站。", 1.2)

func use_faci(f: Dictionary) -> void:
	var rs = reg_st(); var day = day_no(); act_key = "x"; var F = js("F")
	if f.t == "station":
		var c = station_cost(f.z)
		if mat_total() < c: return
		pay_mat(c); rs.sta[str(f.z)] = 1.0; msg("開通了 %s 地鐵站。" % N.TNAME[ci][MAP.ter_of(f.z)], 2); save()
	elif f.t == "tea":
		tea[f.z] = t + TEA_CD; QX.bump("tea")
		for u in units:
			if u.hp > 0: u.hp = u.maxhp
			if u.g != null and J.num(u.g.get("fat", 0)) > 0:
				u.g.fat = maxf(0, J.num(u.g.fat) - 40)
				if J.num(u.g.fat) < 70 and u.tired: u.tired = false; u.atk /= 0.7
		msg(T("茶水間：「咖啡機又壞咗。」大家飲住熱水休息咗一陣。全部門回血，過勞 -40。", "茶水間：「咖啡機又壞了。」大家喝熱水休息了一下。全部門回血，過勞 -40。"), 3); snd("click")
	elif f.t == "prison":
		if J.num(jc("fodderCount")) >= J.num(J.mc(F, "rosterCap", [])): return
		rs.pr = float(day); var pool = fod_of(); var k = pool[randi() % pool.size()]
		var g = add_crew(k, zone_p(f.z), false, f.x, f.y + 30); loot.rec += 1
		fx_text(f.x, f.y - 60, J.str(g.name) + " 入部門", Color("#9fffb0"), true)
		msg(T("實習鬼：「多謝前輩！報告我聽日一定交！」（佢唔會交）", "實習鬼：「謝謝前輩！報告我明天一定交！」（他不會交）"), 3)
	elif f.t == "overtime":
		rs.ot = float(day); var z = f.z; var p = zone_p(z) + 0.5; var pool = fod_of(); var arr = []
		var bk = pool[pool.size() - 1]; var b = foe(bk, p, {"hp": 6, "atk": 3}, {"ot": true}); b.name = "通宵" + b.name; b.ot_boss = true; b.sk = SKILLS.get(bk); b.s = 0.75
		b.x = f.x; b.y = f.y - 40; b.hx = b.x; b.hy = b.y; b.provoked = true; b.z = z; arr.append(b)
		for i in 4:
			var e = foe(pool[i % pool.size()], p, {"hp": 1.2, "atk": 1.1}, {"ot": true}); e.name = "實習" + e.name
			e.x = f.x + cos(i * 1.57) * 70; e.y = f.y - 40 + sin(i * 1.57) * 45; e.hx = e.x; e.hy = e.y; e.provoked = true; e.z = z; arr.append(e)
		for e in arr: _add_foe(e)
		ot = arr; msg(T("加班房道門打開：「你哋又係嚟陪我加班？」", "加班房的門打開了：「你們也是來陪我加班的？」"), 3)
	persist()

# ---------------- 主線 ----------------
func stage_win(si: int) -> void:
	var ch = CHAPTERS[ci]; var stg = ch.stages[si]; var sid = sid_of(ci, si); var first = not J.t(S.cleared.get(sid))
	var pp = J.num(stg.p)
	var rew = {"coins": 60 * pp + 40, "exp": 30 * pp + 40, "chest": ["g", "b", "p"][si]} if first else {"coins": 20 * pp, "exp": 8 * pp}
	S.cleared[sid] = true; var txt = J.str(jc("give", [rew])); loot.coins += rew.get("coins", 0); loot.exp += rew.get("exp", 0)
	snd("win"); spr("fx_scream", L.x, L.y - 40, {"s0": 0.4, "s1": 2.2, "life": 0.8}); spr("fx_gold", L.x, L.y - 60, {"s0": 0.4, "s1": 0.9, "life": 1.0}); flash_a = 0.4
	jm("Fx", "banner", ["區域總監 %s 擊破！" % stg.name if si == 2 else "部門主管擊破！%s" % ("第 4 區閘口開放" if si == 0 else "第 8 區閘口開放")])
	jm("Fx", "toast", ["%s　%s　%s" % [sid, stg.name, txt]])
	if first:
		var afters: Array = stg.get("after", []).duplicate() if stg.get("after") is Array else []
		if sid == "6-2":
			jm("Story", "queue", ["ch6_wuchang", func(_t, _a): jc("joinGhost", ["baiwu"]); jc("joinGhost", ["heiwu"])])
			jm("Story", "queue", ["ch6_mengpo", func(_t, _a): jc("joinGhost", ["mengpo"])])
		elif sid == "6-3":
			jm("Story", "queue", ["ch6_end"]); jm("Story", "queue", ["ch6_reboot", func(_t, _a): S.ended = true]); jm("Story", "queue", ["epilogue"])
		else:
			var i = 0
			for id in afters:
				var ii = i; var idd = id
				jm("Story", "queue", [id, func(_t, _a):
					if ii == 0:
						for jg in (stg.get("join", []) if stg.get("join") is Array else []): jc("joinGhost", [jg])
					var GR = js("GIFT_REWARD")
					if GR is Dictionary and GR.has(idd): jm("Fx", "toast", ["媽媽燒來的禮物：" + J.str(jc("give", [GR[idd]]))])])
				i += 1
		if si == 2 and ci < 5: jm("Story", "queue", [{"style": "narr", "lines": [["旁白", "第%s區・%s 開放了。收工返村，準備好就可以出發。" % [CN[ci + 1], CHAPTERS[ci + 1].name]]]}])
	jm("Quest", "check"); persist(); save(); jm("UI", "refresh")

# ---------------- 結束 ----------------
func persist() -> void:
	var s = PackedStringArray(); s.resize(fog.size())
	var last = -1
	for i in fog.size():
		s[i] = "1" if fog[i] == 1 else "0"
		if fog[i] == 1: last = i
	reg_st().fog = "".join(s.slice(0, last + 1))
	save()

func end(died: bool) -> void:
	if ended: return
	ended = true; persist()
	st().restAt = J.now()
	if died: streak = 0
	elif loot.kills >= 10: QX.bump("cleanRun")
	var q = N.MEET[randi() % N.MEET.size()]
	hud.end_show(died, T(J.str(q[0]), J.str(q[1])), loot)
	snd("lose" if died else "win")
	save()

func close_run() -> void:
	_cover(false)
	J.cl(N.setActive, null, [false])
	Snd.set_mode("village")
	jm("Quest", "check"); save(); jm("UI", "refresh")
	cur = null
	queue_free()

# 測試用
func t_lair(tt: int) -> void:
	var lp = MAP.lair(tt); teleport(lp.x, lp.y + 220)
func t_god() -> void:
	for u in units: u.maxhp *= 50; u.hp = u.maxhp; u.atk *= 4
func t_stat() -> String:
	return "units=%d foes=%d downs=%d loot=%s kings=%s" % [units.size(), foes.size(), downs.size(), str(loot), str(reg_st().get("kings"))]

func ask_quit() -> void:
	if not ended: end(false)

# ---------------- 每幀 ----------------
func _process(dt: float) -> void:
	if MAP == null: return
	dt = minf(0.08, dt)
	var tp0 = Time.get_ticks_usec()
	var busy = J.t(jm("Story", "busy"))
	if not ended and not busy and not paused: update(dt)
	var tp1 = Time.get_ticks_usec()
	_render()
	var tp2 = Time.get_ticks_usec()
	prof_u += tp1 - tp0; prof_r += tp2 - tp1; prof_n += 1
	if prof_n >= 30 and OS.has_environment("GB_PROF"):
		print("[patrol] update=%.1fms render=%.1fms draw=%.1fms(%d) proc=%.1fms rcpu=%.1fms rgpu=%.1fms units=%d foes=%d fx=%d" % [prof_u / 1000.0 / prof_n, prof_r / 1000.0 / prof_n, PtDraw.prof_us / 1000.0 / prof_n, PtDraw.prof_n / prof_n, Performance.get_monitor(Performance.TIME_PROCESS) * 1000, RenderingServer.viewport_get_measured_render_time_cpu(get_viewport().get_viewport_rid()) + RenderingServer.get_frame_setup_time_cpu(), RenderingServer.viewport_get_measured_render_time_gpu(get_viewport().get_viewport_rid()), units.size(), foes.size(), fx.size()]); prof_u = 0; prof_r = 0; prof_n = 0; PtDraw.prof_us = 0; PtDraw.prof_n = 0
	var hq = int(t * 4)
	if hq != hud_t: hud_t = hq; _hud(false)

func _hud(_full: bool) -> void:
	if hud: hud.update_hud()

func _gui_input(ev: InputEvent) -> void:
	if ended: return
	if ev is InputEventMouseButton and ev.button_index == MOUSE_BUTTON_LEFT:
		if ev.pressed: joy = {"x0": ev.position.x, "y0": ev.position.y, "x": ev.position.x, "y": ev.position.y}
		else: joy = null
		accept_event()
	elif ev is InputEventMouseMotion and joy != null:
		joy.x = ev.position.x; joy.y = ev.position.y; accept_event()

func _unhandled_input(ev: InputEvent) -> void:
	if ev is InputEventKey:
		var k = OS.get_keycode_string(ev.keycode).to_lower()
		keys[k] = ev.pressed
		if ev.pressed and not ev.echo:
			if k == "space" or k == "j": dash()
			elif k == "k": pie()
			elif k == "m": hud.toggle_map()

# ---------------- 畫面 ----------------
func fx_tex(n: String) -> Texture2D:
	if not fxt.has(n): fxt[n] = PtGfx.tex(n)
	return fxt[n]

func _build_view() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	clip_contents = true
	var bg = ColorRect.new(); bg.color = Color("#060508"); bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); bg.mouse_filter = Control.MOUSE_FILTER_IGNORE; add_child(bg)
	world = Node2D.new(); add_child(world)
	ground_tex = PtGfx.tex("ground%d" % ci)
	ground = PtDraw.new(); ground.texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED; ground.fn = _draw_ground; world.add_child(ground)
	path_n = PtDraw.new(); path_n.fn = _draw_path; world.add_child(path_n)
	under = PtDraw.new(); under.fn = _draw_under; world.add_child(under)
	fxground = Node2D.new(); world.add_child(fxground)
	ysort = Node2D.new(); ysort.y_sort_enabled = true; world.add_child(ysort)
	wglow = PtDraw.new(); wglow.fn = _draw_wglow; var wgm = CanvasItemMaterial.new(); wgm.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD; wglow.material = wgm
	world.add_child(wglow); world.move_child(wglow, under.get_index() + 1)
	for f in MAP.FACI:
		var n2 = PtDraw.new(); n2.position = Vector2(f.x, f.y); var ff = f
		n2.fn = func(c): _draw_faci(c, ff)
		ysort.add_child(n2); faci_nodes.append(n2)
	walls_n = PtDraw.new(); walls_n.fn = _draw_walls; world.add_child(walls_n)
	proj_n = PtDraw.new(); proj_n.fn = _draw_proj; var pm = CanvasItemMaterial.new(); pm.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD; proj_n.material = pm; world.add_child(proj_n)
	fxtop = Node2D.new(); world.add_child(fxtop)
	fxmisc = PtDraw.new(); fxmisc.fn = _draw_fxmisc; world.add_child(fxmisc)
	text_n = PtDraw.new(); text_n.fn = _draw_text; world.add_child(text_n)
	mist_n = PtDraw.new(); mist_n.fn = _draw_mist; world.add_child(mist_n)
	# 光照遮罩（1/4 解像度）
	dark_vp = SubViewport.new(); dark_vp.transparent_bg = false; dark_vp.render_target_update_mode = SubViewport.UPDATE_ALWAYS; dark_vp.size = Vector2i(100, 211)
	dark_vp.canvas_item_default_texture_filter = Viewport.DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_LINEAR
	add_child(dark_vp)
	var white = ColorRect.new(); white.color = Color.WHITE; white.size = Vector2(4000, 4000); dark_vp.add_child(white)
	dark_draw = PtDraw.new(); dark_draw.fn = _draw_dark_mask
	var dm = ShaderMaterial.new(); var dsh = Shader.new()
	dsh.code = "shader_type canvas_item;\nrender_mode blend_mul;\nvoid fragment(){ float g = texture(TEXTURE, UV).a; COLOR = vec4(vec3(1.0 - COLOR.a * g), 1.0); }"
	dm.shader = dsh; dark_draw.material = dm; dark_vp.add_child(dark_draw)
	dark_rect = TextureRect.new(); dark_rect.texture = dark_vp.get_texture(); dark_rect.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); dark_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE; dark_rect.stretch_mode = TextureRect.STRETCH_SCALE
	dark_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	dark_mat = ShaderMaterial.new(); var dsh2 = Shader.new()
	dsh2.code = "shader_type canvas_item;\nuniform vec4 dark = vec4(0.0, 0.0, 0.0, 0.7);\nvoid fragment(){ float f = texture(TEXTURE, UV).r; COLOR = vec4(dark.rgb, dark.a * f); }"
	dark_mat.shader = dsh2; dark_rect.material = dark_mat; add_child(dark_rect)
	glow_n = PtDraw.new(); glow_n.fn = _draw_glow; var gm = CanvasItemMaterial.new(); gm.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD; glow_n.material = gm; add_child(glow_n)
	tint = ColorRect.new(); tint.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); tint.mouse_filter = Control.MOUSE_FILTER_IGNORE; tint.color = Color(0, 0, 0, 0); add_child(tint)
	hud = PtHud.new(); hud.run = self; hud.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); add_child(hud)

func _drop_view(u: PtU) -> void:
	if u.view != null and is_instance_valid(u.view): u.view.queue_free()
	u.view = null

func vis(u: PtU) -> bool: return u.x > cx - 80 and u.x < cx + vw + 80 and u.y > cy - 20 and u.y < cy + vh + 140

func _render() -> void:
	var sz = size
	if sz.x < 10: return
	sc = sz.x / float(N.VIEW); vw = float(N.VIEW); vh = sz.y / sc
	cx = clampf(cam.x - vw / 2, 0, MAP.WW - vw)
	cy = (MAP.WH - vh) / 2 if vh >= MAP.WH else clampf(cam.y - vh / 2, -60, MAP.WH - vh + 40)
	shx = (randf() - 0.5) * shake if shake > 0 else 0.0; shy = (randf() - 0.5) * shake * 0.7 if shake > 0 else 0.0
	world.transform = Transform2D(Vector2(sc, 0), Vector2(0, sc), Vector2((-cx + shx) * sc, (-cy + shy) * sc))
	lights.clear()
	# 擺設：只有鏡頭附近嘅先有節點（節點池重用）
	var want = {}
	var gx0 = int(floor((cx - 90) / 200.0)); var gx1 = int(floor((cx + vw + 90) / 200.0)); var gy0 = int(floor((cy - 20) / 200.0)); var gy1 = int(floor((cy + vh + 160) / 200.0))
	for gy in range(gy0, gy1 + 1):
		for gx in range(gx0, gx1 + 1):
			for p in MAP.PROPGRID.get(Vector2i(gx, gy), []):
				if p.x > cx - 90 and p.x < cx + vw + 90 and p.y > cy - 20 and p.y < cy + vh + 160:
					want[p] = 1
					var d = N.PROP.get(p.t)
					if d != null and d.get("light"): lights.append([p.x, p.y - J.num(d.h) * p.s * 0.6, 150.0, 0.85, _rgb(d.light)])
	for p in prop_live.keys():
		if not want.has(p): var n0: PtDraw = prop_live[p]; n0.visible = false; prop_pool.append(n0); prop_live.erase(p)
	for p in want:
		if prop_live.has(p): continue
		var n: PtDraw
		if prop_pool.size(): n = prop_pool.pop_back()
		else: n = PtDraw.new(); ysort.add_child(n)
		var pp = p; n.position = Vector2(p.x, p.y); n.visible = true; n.queue_redraw(); prop_live[p] = n
		n.fn = func(c): _draw_prop(c, pp)
	var i = 0
	var rs = reg_st()
	i = 0
	for f in MAP.FACI:
		var on2 = f.x > cx - 140 and f.x < cx + vw + 140 and f.y > cy - 60 and f.y < cy + vh + 160
		faci_nodes[i].visible = on2
		if on2:
			faci_nodes[i].queue_redraw()
			var col = {"station": Color8(120, 255, 160), "tea": Color8(255, 200, 120), "overtime": Color8(140, 200, 255)}.get(f.t)
			lights.append([f.x, f.y - 40, 170.0, 0.85, col])
		i += 1
	for tt in 9:
		if not king_done(tt):
			var lp = MAP.lair(tt); lights.append([lp.x, lp.y, 200.0, 0.85, Color8(90, 255, 160)])
	# 角色
	var live = {}
	for u in units:
		if (u.hp > 0 or u.dead_t < 0.8) and not u.gone and vis(u):
			_sync_char(u); live[u] = 1
			if u.hp > 0 and not u.leader: lights.append([u.x, u.y - 30, 60.0, 0.85, null])
		elif u.view != null: u.view.visible = false
	for e in foes:
		if ((e.hp > 0 and not e.fled) or e.down > 0 or e.dead_t < 0.8 or (e.fled and e.dead_t < 1.2)) and vis(e): _sync_char(e)
		elif e.view != null: e.view.visible = false
	_sync_after()
	for q in proj: lights.append([q.x, q.y, 50.0, 0.85, null])
	for f in fx: if f.kind == "ring": lights.append([f.x, f.y, f.r * 0.8, 0.85, null])
	_collect_glows()
	_sync_fx()
	ground.queue_redraw(); under.queue_redraw(); wglow.queue_redraw(); walls_n.queue_redraw(); proj_n.queue_redraw(); fxmisc.queue_redraw(); text_n.queue_redraw(); mist_n.queue_redraw()
	# 光照
	var ph = phase(J.num(st().min))
	var dk = {"zi": Color(22 / 255.0, 0, 10 / 255.0, 0.8), "work": Color(8 / 255.0, 12 / 255.0, 24 / 255.0, 0.5), "off": Color(10 / 255.0, 10 / 255.0, 26 / 255.0, 0.62)}.get(ph, Color(4 / 255.0, 4 / 255.0, 14 / 255.0, 0.7))
	dark_mat.set_shader_parameter("dark", Vector4(dk.r, dk.g, dk.b, dk.a))
	var vps = Vector2i(maxi(8, int(ceil(sz.x / 4))), maxi(8, int(ceil(sz.y / 4))))
	if dark_vp.size != vps: dark_vp.size = vps
	dark_draw.queue_redraw(); glow_n.queue_redraw()
	if buff > 0: tint.color = Color("#ffcf5a"); tint.color.a = 0.08 + 0.04 * sin(t * 6)
	elif flash_a > 0: tint.color = Color(1, 1, 1, flash_a * 0.5)
	else: tint.color = Color(0, 0, 0, 0)
	if flash_a > 0 and buff > 0: tint.color = tint.color.lerp(Color(1, 1, 1, flash_a * 0.5), 0.6)
	hud.frame()

func _rgb(s) -> Color:
	var a = J.str(s).split(","); return Color8(int(a[0]), int(a[1]), int(a[2]))

func ws(x: float, y: float) -> Vector2: return Vector2((x - cx + shx) * sc, (y - cy + shy) * sc)

func _sync_char(u: PtU) -> void:
	if u.view == null:
		u.view = PtChar.new(u, self); ysort.add_child(u.view)
	var v: PtChar = u.view
	v.visible = true
	var dying = (u.hp <= 0 or u.fled) and not u.down > 0
	var p = minf(1, u.dead_t / (1.2 if u.fled else 0.8)) if dying else 0.0
	var eo = func(q: float) -> float: return 1 - pow(1 - clampf(q, 0, 1), 3)
	var pose = "idle"; var pt = 0.0; var ox = 0.0; var oy = 0.0; var rot = 0.0
	var a = u.act; var tg = a.tg if a != null else null
	if u.down > 0: pose = "down"; pt = 1
	elif dying and not u.fled: pose = "die"; pt = p
	elif a != null:
		var dir = (signf(tg.x - u.x) if tg != null else (-1.0 if u.flip else 1.0)); if dir == 0: dir = 1
		var melee = u.rng < 60; var Lg = (16.0 if u.boss else 12.0) * u.s * 1.65
		if a.cast or a.slam:
			pose = "windup"; pt = minf(1, a.t / a.dur)
			if a.ph != "windup": pose = "strike"; pt = 1
		elif a.ph == "windup": pose = "windup"; pt = a.t / a.dur; ox = -dir * 3 * eo.call(pt)
		elif a.ph == "strike": pose = "strike"; pt = a.t / ATK.strike; ox = dir * Lg * eo.call(pt * 2) if melee else -dir * 4
		else: pose = "recover"; pt = a.t / ATK.recover; ox = dir * Lg * (1 - eo.call(pt)) if melee else -dir * 4 * (1 - pt)
	elif u.hurt > 0: pose = "hurt"; pt = 1 - u.hurt / 0.24
	elif u.moving: pose = "move"
	if pose == "idle" and not dying: var tt = t + u.x * 0.013; oy = -absf(sin(tt * 3.2)) * 1.6
	if u.dash > 0: rot = 0.18 if u.flip else -0.18
	var swing_t = -1.0
	if u.swing != null:
		swing_t = u.swing.t
		if (u.swing.sty == "spin" or u.swing.sty == "flail") and u.swing.t < 0.32: rot = (-1.0 if u.flip else 1.0) * u.swing.t / 0.32 * PI * 2; pose = "strike"; pt = 1
	var alpha = 1.0
	if u.fled: alpha = maxf(0, 0.6 - p * 0.6)
	elif dying: alpha = 1 - p
	elif u.down > 0: alpha = 0.55 + 0.3 * sin(t * 12)
	var o = {"t": t + fmod(u.x, 7.0), "walk": pose == "move", "pose": pose, "pt": pt, "flip": u.flip, "enemy": u.side == 1, "tamed": u.side == 0, "untied": u.side == 0, "rot": rot,
		"tdx": (tg.x - u.x) if tg != null else (-40.0 if u.flip else 40.0), "tdy": (tg.y - u.y) if tg != null else 0.0, "alpha": alpha, "flash": u.flash, "ox": ox, "oy": oy, "s": u.s * 1.65,
		"cloth": u.cloth, "badge": u.badge, "wtex": null, "wsty": "", "swing_t": swing_t, "aura": 0.0, "charge": -1.0, "dying": dying, "lweapon": null}
	if u.wpn != null:
		o.wtex = fx_tex(J.str(u.wpn.img)); o.wsty = J.str(u.wpn.sty); o.lweapon = u.wpn.img
	if u.side == 0 and buff > 0 and u.hp > 0 and not dying: o.aura = 0.35 + 0.15 * sin(t * 8 + u.x)
	if a != null and (a.cast or a.slam) and a.ph == "windup": o.charge = a.t / a.dur
	v.sync(o)

# 衝刺殘影：用一個淡淡嘅角色拷貝
var after_nodes: Array = []
func _sync_after() -> void:
	var n = 0
	for f in fx:
		if f.kind != "after": continue
		var v: PtChar
		if n < after_nodes.size(): v = after_nodes[n]
		else:
			v = PtChar.new(L, self); v.over.visible = false; v.glow.visible = false
			ysort.add_child(v); after_nodes.append(v)
		v.visible = true
		var o = {"t": t, "walk": true, "pose": "move", "pt": 0.0, "flip": f.flip, "enemy": false, "rot": 0.0, "tdx": 0.0, "tdy": 0.0, "alpha": 0.35 * (1 - f.t / f.life), "flash": 0.0, "ox": 0.0, "oy": 0.0, "s": f.s * 1.65,
			"cloth": null, "badge": null, "wtex": null, "wsty": "", "swing_t": -1.0, "aura": 0.0, "charge": -1.0, "dying": false, "lweapon": null}
		v.sync(o); v.position = Vector2(f.x, f.y - 0.1)
		n += 1
	for i in range(n, after_nodes.size()): after_nodes[i].visible = false

# ---------------- 特效圖（按色相／疊光分組畫）----------------
func _sync_fx() -> void:
	var groups = {}
	for f in fx:
		if f.kind != "spr": continue
		var key = "%s_%d_%s" % ["g" if f.get("ground", false) else "t", int(f.hue), f.add]
		if not groups.has(key): groups[key] = []
		groups[key].append(f)
	for key in fx_groups.keys():
		if not groups.has(key): fx_groups[key].visible = false
	for key in groups:
		var n: PtDraw = fx_groups.get(key)
		if n == null:
			n = PtDraw.new(); var parts = key.split("_")
			n.material = PtGfx.hue_mat(float(parts[1]), parts[2] == "true")
			(fxground if parts[0] == "g" else fxtop).add_child(n); fx_groups[key] = n
		n.visible = true
		var lst = groups[key]
		n.fn = func(c): for f in lst: _draw_spr(c, f)
		n.queue_redraw()
		if not key.begins_with("g"):
			for f in lst:
				if f.add and f.t < f.life * 0.5: lights.append([f.x, f.y, 60.0, 0.85, null])

func _draw_spr(c: CanvasItem, f: Dictionary) -> void:
	var im = fx_tex(f.n)
	if im == null: return
	var p = f.t / f.life; var e = 1 - pow(1 - p, 2.2); var s = f.s0 + (f.s1 - f.s0) * e
	var a = f.alpha * ((p / 0.2) if f.get("fadeIn", false) and p < 0.2 else 1.0) * (1.0 if p < 0.55 else 1 - (p - 0.55) / 0.45)
	var w = im.get_width() * s * f.sx; var h = im.get_height() * s * f.sy
	var X = Transform2D(0, Vector2(f.x + f.get("vx", 0.0) * p, f.y - f.vy * p))
	var r = f.rot + f.get("spin", 0.0) * p
	if r != 0.0: X = X * Transform2D(r, Vector2.ZERO)
	if f.get("flip", false): X = X * Transform2D(Vector2(-1, 0), Vector2(0, 1), Vector2.ZERO)
	c.draw_set_transform_matrix(X)
	c.draw_texture_rect(im, Rect2(-w / 2, -h * f.get("anchor", 0.5), w, h), false, Color(1, 1, 1, maxf(0, a)))
	c.draw_set_transform_matrix(Transform2D.IDENTITY)

# ---------------- 地面、小路 ----------------
func _draw_ground(c: CanvasItem) -> void:
	var gx0 = maxf(0, cx); var gy0 = maxf(0, cy); var gx1 = minf(MAP.WW, cx + vw); var gy1 = minf(MAP.WH, cy + vh)
	if ground_tex != null:
		c.draw_texture_rect_region(ground_tex, Rect2(gx0, gy0, gx1 - gx0, gy1 - gy0), Rect2(gx0, gy0, gx1 - gx0, gy1 - gy0))
	else:
		c.draw_rect(Rect2(gx0, gy0, gx1 - gx0, gy1 - gy0), Color(J.str(N.REG[ci].g0)))

var path_pts: PackedVector2Array
var path_dash: PackedVector2Array
func _draw_path(c: CanvasItem) -> void:
	if path_pts.is_empty():
		var pts = MAP.path; var out = PackedVector2Array(); out.append(pts[0])
		for i in range(1, pts.size()):
			var p0 = pts[i - 1]; var p1 = pts[i]; var mid = (p0 + p1) / 2
			# quadraticCurveTo(p0, mid)：由上一點（前一個 mid）彎去 mid
			var a = out[out.size() - 1]
			for k in range(1, 9):
				var tt = k / 8.0; out.append(a * (1 - tt) * (1 - tt) + p0 * 2 * tt * (1 - tt) + mid * tt * tt)
		out.append(pts[pts.size() - 1])
		path_pts = out
		var acc = 0.0; var on = true; var seg = 3.0
		path_dash = PackedVector2Array()
		for i in range(1, out.size()):
			var a2 = out[i - 1]; var b2 = out[i]; var L2 = a2.distance_to(b2); var pos = 0.0
			while pos < L2:
				var step = minf(L2 - pos, seg - acc)
				if on: path_dash.append(a2.lerp(b2, pos / L2)); path_dash.append(a2.lerp(b2, (pos + step) / L2))
				pos += step; acc += step
				if acc >= seg - 0.001: acc = 0; on = not on; seg = 3.0 if on else 14.0
	c.draw_polyline(path_pts, Color(20 / 255.0, 14 / 255.0, 10 / 255.0, 0.28), 120, true)
	c.draw_polyline(path_pts, Color(120 / 255.0, 104 / 255.0, 80 / 255.0, 0.16), 80, true)
	c.draw_multiline(path_dash, Color(200 / 255.0, 180 / 255.0, 140 / 255.0, 0.12), 3)

# ---------------- 地面層：王巢、探索點、預警圈、光圈 ----------------
func _ell(c: CanvasItem, x: float, y: float, rx: float, ry: float, col: Color) -> void:
	c.draw_set_transform(Vector2(x, y), 0, Vector2(rx, ry)); c.draw_circle(Vector2.ZERO, 1.0, col); c.draw_set_transform_matrix(Transform2D.IDENTITY)
func _ell_line(c: CanvasItem, x: float, y: float, rx: float, ry: float, col: Color, w: float, dash := 0.0, gap := 0.0, off := 0.0) -> void:
	var n = 64; var pts = PackedVector2Array()
	for i in n + 1: var a = TAU * i / n; pts.append(Vector2(x + cos(a) * rx, y + sin(a) * ry))
	if dash <= 0: c.draw_polyline(pts, col, w, true); return
	var segs = PackedVector2Array(); var acc = fposmod(off, dash + gap); var on = acc < dash
	for i in range(1, pts.size()):
		var a2 = pts[i - 1]; var b2 = pts[i]; var L2 = a2.distance_to(b2); var pos = 0.0
		while pos < L2:
			var lim = dash if on else dash + gap
			var step = minf(L2 - pos, lim - acc)
			if on: segs.append(a2.lerp(b2, pos / L2)); segs.append(a2.lerp(b2, (pos + step) / L2))
			pos += step; acc += step
			if acc >= lim - 0.001:
				if on: on = false
				else: on = true; acc = 0
	if segs.size(): c.draw_multiline(segs, col, w)
func _rad(c: CanvasItem, x: float, y: float, r: float, col: Color, sy := 1.0) -> void:
	c.draw_texture_rect(PtGfx.RAD, Rect2(x - r, y - r * sy, r * 2, r * 2 * sy), false, col)

func _draw_under(c: CanvasItem) -> void:
	for tt in 9:
		var lp = MAP.lair(tt)
		if absf(lp.x - (cx + vw / 2)) < vw and absf(lp.y - (cy + vh / 2)) < vh: _draw_lair(c, tt)
	_draw_spots(c)
	# 預警圈
	var wi = fx_tex("fx_warn")
	for q in tele:
		var p = q.t / q.dur
		if wi:
			var W = q.r * 2.2; var H = W * wi.get_height() / wi.get_width()
			c.draw_texture_rect(wi, Rect2(q.x - W / 2, q.y - H / 2, W, H), false, Color(1, 1, 1, 0.7 + 0.25 * sin(t * 18)))
			c.draw_texture_rect(wi, Rect2(q.x - W * p / 2, q.y - H * p / 2, W * p, H * p), false, Color(1, 1, 1, 0.5 + 0.4 * p))
	# 阿福腳下光圈
	_ell_line(c, L.x, L.y + 2, 26, 9, Color(1, 220 / 255.0, 120 / 255.0, 0.55), 2, 6, 5, t * 20)
	if dig != null:
		var sp = dig.sp
		c.draw_arc(Vector2(sp.x, sp.y - 40), 14, -PI / 2, -PI / 2 + PI * 2 * minf(1, dig.t / 1.3), 32, Color("#ffe9a0"), 4, true)

func _draw_lair(c: CanvasItem, tt: int) -> void:
	var lp = MAP.lair(tt); var done = king_done(tt); var r = 150.0
	_rad(c, lp.x, lp.y, r, Color(30 / 255.0, 40 / 255.0, 40 / 255.0, 0.15) if done else Color(40 / 255.0, 0, 10 / 255.0, 0.35), 0.62)
	_ell_line(c, lp.x, lp.y, r * 0.9, r * 0.56, Color(120 / 255.0, 140 / 255.0, 140 / 255.0, 0.25) if done else Color(150 / 255.0, 30 / 255.0, 40 / 255.0, 0.45), 3, 14, 10)
	for i in 6:
		var a = i / 6.0 * PI * 2 + 0.3; var x = lp.x + cos(a) * r * 0.9; var y = lp.y + sin(a) * r * 0.56
		c.draw_rect(Rect2(x - 3, y - 26, 6, 26), Color("#1a1612"))

var _rad_add_list: Array = []

func _draw_spots(c: CanvasItem) -> void:
	var rs = reg_st(); var fnt = PtGfx.font(900)
	for sp in spots:
		if sp.x < cx - 120 or sp.x > cx + vw + 120 or sp.y < cy - 60 or sp.y > cy + vh + 160: continue
		var x = sp.x; var y = sp.y
		if sp.k == "lm":
			var found = J.t(rs.lm.get(str(sp.id)))
			_ell(c, x, y, 20, 6, Color(0, 0, 0, 0.35))
			c.draw_rect(Rect2(x - 3, y - 58, 6, 58), Color("#3a2a1c")); c.draw_rect(Rect2(x - 3, y - 58, 6, 58), Color("#120a06"), false, 2)
			var txt = sp.name if found else "？"; var tw = maxf(34, fnt.get_string_size(txt, HORIZONTAL_ALIGNMENT_LEFT, -1, 13).x + 18)
			var poly = PackedVector2Array([Vector2(x - tw / 2, y - 66), Vector2(x + tw / 2 - 6, y - 66), Vector2(x + tw / 2 + 4, y - 56), Vector2(x + tw / 2 - 6, y - 46), Vector2(x - tw / 2, y - 46)])
			c.draw_colored_polygon(poly, Color("#d9c79c") if found else Color("#6d6252"))
			var pc = poly.duplicate(); pc.append(poly[0]); c.draw_polyline(pc, Color("#120a06"), 2)
			var sw = fnt.get_string_size(txt, HORIZONTAL_ALIGNMENT_LEFT, -1, 13).x
			c.draw_string(fnt, Vector2(x - sw / 2, y - 51), txt, HORIZONTAL_ALIGNMENT_LEFT, -1, 13, Color("#3a1a10") if found else Color("#e8dcc0"))
		elif sp.k == "ca" and not J.t(rs.ca.get(str(sp.id))):
			if Vector2(sp.x - L.x, sp.y - L.y).length() > 280: continue
			_ell(c, x, y, 22, 9, Color(60 / 255.0, 46 / 255.0, 36 / 255.0, 0.85))
			_ell_line(c, x, y, 22, 9, Color(20 / 255.0, 14 / 255.0, 10 / 255.0, 0.8), 1.5)
		elif sp.k == "pg" and not J.t(rs.pg.get(str(sp.id))):
			var bob = sin(t * 2.4 + sp.id) * 5
			var X = Transform2D(sin(t * 1.7 + sp.id) * 0.2, Vector2(x, y - 30 + bob))
			c.draw_set_transform_matrix(X)
			c.draw_rect(Rect2(-9, -12, 18, 24), Color("#e9e0c6")); c.draw_rect(Rect2(-9, -12, 18, 24), Color("#3a2c1c"), false, 1.5)
			for i in 4: c.draw_line(Vector2(-5 + i * 3.3, -8), Vector2(-5 + i * 3.3, 8), Color(60 / 255.0, 40 / 255.0, 30 / 255.0, 0.6), 1)
			c.draw_set_transform_matrix(Transform2D.IDENTITY)

# ---------------- 擺設 ----------------
func _draw_prop(c: CanvasItem, p: Dictionary) -> void:
	var d = N.PROP.get(p.t); var im = PtGfx.tex(J.str(d.img)) if d != null else null
	if im == null:
		_ell(c, 0, 2, 16 * p.s, 5 * p.s, Color(0, 0, 0, 0.35))
		var pts = PackedVector2Array([Vector2(-15, 0), Vector2(-10, -12), Vector2(4, -15), Vector2(15, -4), Vector2(12, 0)])
		for i in pts.size(): pts[i] *= p.s
		c.draw_colored_polygon(pts, Color("#3e3b3a")); return
	var h = J.num(d.h) * p.s; var w = h * im.get_width() / im.get_height()
	_ell(c, 0, 2, w * 0.38, w * 0.11, Color(0, 0, 0, 0.32))
	if p.v > 0.5: c.draw_set_transform(Vector2.ZERO, 0, Vector2(-1, 1))
	c.draw_texture_rect(im, Rect2(-w / 2, -h + 6, w, h), false)
	c.draw_set_transform_matrix(Transform2D.IDENTITY)

# ---------------- 設施 ----------------
func _draw_faci(c: CanvasItem, f: Dictionary) -> void:
	var rs = reg_st(); var fnt = PtGfx.font(900)
	_ell(c, 0, 2, 52, 14, Color(0, 0, 0, 0.4))
	var im = PtGfx.tex(f.t)
	var on = J.t(rs.sta.get(str(f.z)))
	if im:
		var w = 118.0; var h = w * im.get_height() / im.get_width()
		var off = (f.t == "station" and not on) or (f.t == "tea" and tea.get(f.z, 0.0) > t)
		c.draw_texture_rect(im, Rect2(-w / 2, -h + 8, w, h), false, Color(0.42, 0.42, 0.42) if off else Color.WHITE)
	var lab = {"station": ["地鐵站・%s" % N.TNAME[ci][MAP.ter_of(f.z)] if on else "地鐵站（未開通）", Color("#9fe0b8") if on else Color("#aaa")], "tea": ["茶水間", Color("#ffd69a")], "prison": ["扣押室", Color("#d8c8c8")], "overtime": ["通宵加班房", Color("#bcd8ff")]}[f.t]
	var sw = fnt.get_string_size(lab[0], HORIZONTAL_ALIGNMENT_LEFT, -1, 12).x
	c.draw_string_outline(fnt, Vector2(-sw / 2, 18), lab[0], HORIZONTAL_ALIGNMENT_LEFT, -1, 12, 3, Color(0, 0, 0, 0.8))
	c.draw_string(fnt, Vector2(-sw / 2, 18), lab[0], HORIZONTAL_ALIGNMENT_LEFT, -1, 12, lab[1])

# ---------------- 深坑／陰河／閘口 ----------------
func _band_quad(c: CanvasItem, a: float, b: float, H2: float, col: Color) -> void:
	var t0 = Color(col, 0.0)
	var ys = [-H2, -H2 * 0.4, H2 * 0.4, H2]; var cs = [t0, col, col, t0]
	for i in 3:
		c.draw_polygon(PackedVector2Array([Vector2(a, ys[i]), Vector2(b, ys[i]), Vector2(b, ys[i + 1]), Vector2(a, ys[i + 1])]), PackedColorArray([cs[i], cs[i], cs[i + 1], cs[i + 1]]))

func _draw_walls(c: CanvasItem) -> void:
	var fnt = PtGfx.font(900); var GW = MAP.GW
	for w in MAP.WALLS:
		var len = w.b - w.a; var H2 = 46.0 if w.kind == "border" else 34.0
		var x0w = w.a if w.h else w.p - H2; var x1w = w.b if w.h else w.p + H2; var y0w = w.p - H2 if w.h else w.a; var y1w = w.p + H2 if w.h else w.b
		if x1w < cx - 60 or x0w > cx + vw + 60 or y1w < cy - 60 or y0w > cy + vh + 100: continue
		var X = Transform2D(0, Vector2(w.a, w.p)) if w.h else Transform2D(PI / 2, Vector2(w.p, w.a))
		c.draw_set_transform_matrix(X)
		var river = w.kind == "river"; var cap = w.kind != "border"
		var band = func(a: float, b: float) -> void:
			if b <= a: return
			_band_quad(c, a, b, H2, Color(6 / 255.0, 18 / 255.0, 16 / 255.0, 0.95) if river else Color(4 / 255.0, 3 / 255.0, 8 / 255.0, 0.95))
			var ec = Color(40 / 255.0, 70 / 255.0, 60 / 255.0, 0.8) if river else Color(70 / 255.0, 58 / 255.0, 50 / 255.0, 0.75)
			for sg in [-1.0, 1.0]:
				var pts = PackedVector2Array(); var x = a
				while x <= b:
					var XX = x + w.a; var j = sin(XX * 0.07 + sg) * 4 + fmod(XX * 7919, 11.0) * 0.5
					pts.append(Vector2(x, sg * (H2 * 0.36) + j * sg)); x += 16
				if pts.size() > 1: c.draw_polyline(pts, ec, 3)
			if river:
				var x2 = a - fmod(a, 60.0)
				while x2 < b:
					var ph = fmod(t * 0.6 + x2 * 0.013, 1.0)
					_ell(c, x2 + ph * 40, sin(x2) * 6, 18, 3, Color(90 / 255.0, 1, 170 / 255.0, 0.10 * sin(ph * PI)))
					x2 += 60
			else:
				var x3 = a - fmod(a, 90.0)
				while x3 < b:
					_ell(c, x3 + sin(t * 0.4 + x3) * 20, 0, 70, 12, Color(120 / 255.0, 140 / 255.0, 170 / 255.0, 0.05)); x3 += 90
			c.draw_set_transform_matrix(X)
		var g = w.gap; var gc = g.c - w.a if g != null else -1e9; var sec = g != null and g.g.sec; var found = sec and sec_found(g.g)
		if g != null: band.call(0.0, gc - GW / 2); band.call(gc + GW / 2, len)
		else: band.call(0.0, len)
		c.draw_set_transform_matrix(X)
		if sec and not found:
			_band_quad(c, gc - GW / 2, gc + GW / 2, H2, Color(10 / 255.0, 12 / 255.0, 8 / 255.0, 0.82))
			var segs = PackedVector2Array()
			for i in 16:
				var x = gc - GW / 2 + 8 + i * (GW - 16) / 15.0; var h = 10 + ((i * 37) % 9)
				segs.append(Vector2(x, H2 * 0.3)); segs.append(Vector2(x + sin(t * 1.5 + i) * 3, H2 * 0.3 - h))
			c.draw_multiline(segs, Color(60 / 255.0, 80 / 255.0, 40 / 255.0, 0.7), 2)
		if cap:
			for e in [0.0, len]:
				var tr = X * Transform2D(0, Vector2(e, 0))
				c.draw_set_transform_matrix(tr * Transform2D(Vector2(H2 * 0.6, 0), Vector2(0, H2 * 0.5), Vector2.ZERO))
				c.draw_circle(Vector2.ZERO, 1.0, Color(6 / 255.0, 18 / 255.0, 16 / 255.0, 0.9) if river else Color(4 / 255.0, 3 / 255.0, 8 / 255.0, 0.9))
			c.draw_set_transform_matrix(X)
		if g != null and not sec:
			var yy = -H2 + 4
			while yy < H2 - 4:
				var r = Rect2(gc - GW / 2 + 22, yy, GW - 44, 9); c.draw_rect(r, Color("#3a2c20")); c.draw_rect(r, Color("#120c08"), false, 2); yy += 12
			c.draw_line(Vector2(gc - GW / 2 + 18, -H2), Vector2(gc - GW / 2 + 18, H2), Color("#2a1c12"), 4)
			c.draw_line(Vector2(gc + GW / 2 - 18, -H2), Vector2(gc + GW / 2 - 18, H2), Color("#2a1c12"), 4)
			if not gate_open(g.g):
				for i in 5: var x = gc - GW / 2 + 30 + i * (GW - 60) / 4.0; c.draw_rect(Rect2(x - 3, -26, 6, 32), Color("#1a1414"))
				c.draw_rect(Rect2(gc - GW / 2 + 24, -22, GW - 48, 10), Color("#7a1420"))
				for i in 7: c.draw_rect(Rect2(gc - GW / 2 + 32 + i * 24, -22, 11, 10), Color("#222"))
		if found:
			for i in 5:
				var yy2 = -H2 + 8 + i * (H2 * 2 - 16) / 4.0
				_ell(c, gc + sin(i * 2.3) * 12, yy2, 16, 7, Color("#4a4238")); _ell_line(c, gc + sin(i * 2.3) * 12, yy2, 16, 7, Color("#151210"), 1.5)
				c.draw_set_transform_matrix(X)
		c.draw_set_transform_matrix(Transform2D.IDENTITY)
		if g != null and not gate_open(g.g):
			var gx = g.g.x; var gy = g.g.y - (30 if g.g.vert else 50); var main = MAP.TMAIN.has(g.g.a) or MAP.TMAIN.has(g.g.b)
			c.draw_rect(Rect2(gx - 50, gy - 26, 100, 22), Color("#e8dcc0")); c.draw_rect(Rect2(gx - 50, gy - 26, 100, 22), Color("#2a1a10"), false, 2)
			var txt = "主管當值" if main else "地頭封路"; var sw = fnt.get_string_size(txt, HORIZONTAL_ALIGNMENT_LEFT, -1, 13).x
			c.draw_string(fnt, Vector2(gx - sw / 2, gy - 10), txt, HORIZONTAL_ALIGNMENT_LEFT, -1, 13, Color("#7a1a10"))

# ---------------- 子彈、雜項特效、文字、霧 ----------------
func _draw_proj(c: CanvasItem) -> void:
	var fi = fx_tex("fx_fire")
	for q in proj:
		if fi == null: continue
		var ang = atan2(q.get("vy", 0.0), q.get("vx", 1.0)); var W = 46 * q.big; var H = W * fi.get_height() / fi.get_width()
		c.draw_set_transform_matrix(Transform2D(ang, Vector2(q.x, q.y)))
		var hm: Basis = PtGfx.m_sat(1.2) * PtGfx.m_hue(q.hue) if q.hue != 0.0 else Basis.IDENTITY
		var col = Color(1, 1, 1)
		if q.hue != 0.0:
			var v = hm * Vector3(0.6, 1.0, 0.8); col = Color(clampf(v.x / 1.0, 0, 1) * 1.4, clampf(v.y, 0, 1), clampf(v.z, 0, 1) * 1.2)
		c.draw_texture_rect(fi, Rect2(-W * 0.8, -H / 2, W, H), false, col if q.hue != 0.0 else Color.WHITE)
	c.draw_set_transform_matrix(Transform2D.IDENTITY)

func _draw_fxmisc(c: CanvasItem) -> void:
	for f in fx:
		if f.kind == "ring":
			var p = f.t / f.life; var col: Color = f.col; col.a = 1 - p
			_ell_line(c, f.x, f.y, f.r * (0.3 + 0.7 * p), f.r * 0.6 * (0.3 + 0.7 * p), col, 4 * (1 - p) + 1)

func _draw_text(c: CanvasItem) -> void:
	var fnt = PtGfx.font(900)
	for f in fx:
		if f.kind != "num" and f.kind != "txt": continue
		var tt = f.t; var a = maxf(0, 1 - (tt - f.life * 0.7) / (f.life * 0.3)) if tt > f.life * 0.7 else 1.0
		var pop = 0.35 + (tt / 0.1) * 1.05 if tt < 0.1 else (1.4 - (tt - 0.1) / 0.1 * 0.4 if tt < 0.2 else 1.0)
		var x = f.x; var y = f.y
		if f.kind == "num": x += f.get("vx", 0.0) * tt; y += -120 * tt + 0.5 * 330 * tt * tt
		else: y -= tt * 30
		var size = 16 if f.get("skill", false) else (19 if f.get("big", false) else 14)
		var txt = J.str(f.text); var sw = fnt.get_string_size(txt, HORIZONTAL_ALIGNMENT_LEFT, -1, size).x
		c.draw_set_transform(Vector2(x, y), 0, Vector2(pop, pop))
		var col: Color = f.col; col.a *= a
		c.draw_string_outline(fnt, Vector2(-sw / 2, 0), txt, HORIZONTAL_ALIGNMENT_LEFT, -1, size, 5 if f.get("big", false) else 4, Color(10 / 255.0, 6 / 255.0, 20 / 255.0, 0.92 * a))
		c.draw_string(fnt, Vector2(-sw / 2, 0), txt, HORIZONTAL_ALIGNMENT_LEFT, -1, size, col)
	c.draw_set_transform_matrix(Transform2D.IDENTITY)

func _draw_mist(c: CanvasItem) -> void:
	for i in 3:
		var fxx = cx + fmod(i * 173 + t * (8 + i * 2), vw + 400) - 200; var fy = cy + vh * (0.15 + i * 0.15) + sin(t * 0.3 + i) * 30
		_rad(c, fxx, fy, 220, Color(150 / 255.0, 160 / 255.0, 190 / 255.0, 0.07))

# 光照遮罩：喺 1/4 解像度畫「挖光」
func _draw_dark_mask(c: CanvasItem) -> void:
	var k = sc / 4.0
	var hole = func(x: float, y: float, r: float, a: float) -> void:
		var s = ws(x, y) / 4.0; var rr = r * k
		c.draw_texture_rect(PtGfx.RAD, Rect2(s.x - rr, s.y - rr, rr * 2, rr * 2), false, Color(1, 1, 1, a))
	hole.call(L.x, L.y - 30, 330, 1.0)
	for q in lights:
		if q[0] > cx - 200 and q[0] < cx + vw + 200 and q[1] > cy - 200 and q[1] < cy + vh + 200: hole.call(q[0], q[1], q[2], q[3])

# 有色光暈＋鬼火（螢幕座標，疊光）
func _draw_glow(c: CanvasItem) -> void:
	for q in lights:
		if q[4] == null: continue
		var s = ws(q[0], q[1]); var rr = q[2] * 0.7 * sc
		var col: Color = q[4]; col.a = 0.22
		c.draw_texture_rect(PtGfx.RAD, Rect2(s.x - rr, s.y - rr, rr * 2, rr * 2), false, col)
	for w in wisps:
		var s2 = ws(w.x, w.y); var a = 0.45 + 0.4 * sin(t * 3 + w.ph); var rr2 = w.r * 3 * sc
		var col2 = Color(1, 180 / 255.0, 120 / 255.0, a) if w.hue else Color(150 / 255.0, 1, 190 / 255.0, a)
		c.draw_texture_rect(PtGfx.RAD, Rect2(s2.x - rr2, s2.y - rr2, rr2 * 2, rr2 * 2), false, col2)

# 地上鬼火（王巢）、地標光柱、寶藏閃光、殘頁光暈：世界座標、疊光，喺黑幕之前畫（同網頁一樣會俾黑幕壓暗）
func _draw_wglow(c: CanvasItem) -> void:
	for q in _rad_add_list:
		if q[0] is String:
			if q[0] == "beam":
				var x = q[1]; var y = q[2]; var cc = Color(120 / 255.0, 200 / 255.0, 1, q[3]); var c0 = Color(cc, 0.0)
				c.draw_polygon(PackedVector2Array([Vector2(x - 10, y - 140), Vector2(x + 10, y - 140), Vector2(x + 10, y), Vector2(x - 10, y)]), PackedColorArray([c0, c0, cc, cc]))
			elif q[0] == "star":
				var col3 = Color(1, 236 / 255.0, 170 / 255.0, q[3])
				c.draw_rect(Rect2(q[1] - 1, q[2] - 4, 2, 8), col3); c.draw_rect(Rect2(q[1] - 4, q[2] - 1, 8, 2), col3)
			continue
		c.draw_texture_rect(PtGfx.RAD, Rect2(q[0] - q[2], q[1] - q[2], q[2] * 2, q[2] * 2), false, q[3])

# 地上鬼火（王巢）、地標光柱、寶藏閃光、殘頁光暈：喺邏輯幀收集，畫光暈時用
func _collect_glows() -> void:
	_rad_add_list.clear()
	for tt in 9:
		var lp = MAP.lair(tt)
		if absf(lp.x - (cx + vw / 2)) >= vw or absf(lp.y - (cy + vh / 2)) >= vh or king_done(tt): continue
		for i in 6:
			var a = i / 6.0 * PI * 2 + 0.3; var x = lp.x + cos(a) * 150 * 0.9; var y = lp.y + sin(a) * 150 * 0.56
			var f = 0.7 + 0.3 * sin(t * 7 + i * 1.7)
			_rad_add_list.append([x, y - 32, 16 * f, Color(160 / 255.0, 1, 190 / 255.0, 0.9)])
	var rs = reg_st()
	for sp in spots:
		if sp.x < cx - 120 or sp.x > cx + vw + 120 or sp.y < cy - 60 or sp.y > cy + vh + 160: continue
		if sp.k == "lm" and not J.t(rs.lm.get(str(sp.id))): _rad_add_list.append(["beam", sp.x, sp.y, 0.25 + 0.15 * sin(t * 2 + sp.id)])
		elif sp.k == "ca" and not J.t(rs.ca.get(str(sp.id))) and Vector2(sp.x - L.x, sp.y - L.y).length() <= 280:
			for i in 3:
				var ph = fmod(t * 1.3 + i * 0.33 + sp.id * 0.1, 1.0)
				_rad_add_list.append(["star", sp.x + sin(i * 2.1 + sp.id) * 14, sp.y - 4 - ph * 10, 0.8 * sin(ph * PI)])
		elif sp.k == "pg" and not J.t(rs.pg.get(str(sp.id))):
			_rad_add_list.append([sp.x, sp.y - 30 + sin(t * 2.4 + sp.id) * 5, 40.0, Color(200 / 255.0, 1, 220 / 255.0, 0.45)])

# 名牌、血條（PtChar 嘅 over 節點呼叫；座標以角色腳底為原點）
func draw_over(n: CanvasItem, u: PtU, o: Dictionary) -> void:
	var off = Vector2(-o.ox, -o.oy)
	var s = u.s * 1.65; var fnt = PtGfx.font(900)
	var top = -(70.0 if u.leader else (88.0 if u.boss else 78.0)) * s - 2
	n.draw_set_transform(off)
	if u.down > 0:
		n.draw_arc(Vector2(0, top - 6), 11, -PI / 2, -PI / 2 + PI * 2 * (u.down / u.down_max), 32, Color("#ffd84a"), 3, true)
		var qw = fnt.get_string_size("?", HORIZONTAL_ALIGNMENT_LEFT, -1, 12).x
		n.draw_string(fnt, Vector2(-qw / 2, top - 2), "?", HORIZONTAL_ALIGNMENT_LEFT, -1, 12, Color("#ffd84a"))
		n.draw_set_transform_matrix(Transform2D.IDENTITY); return
	var named = u.boss or u.elite or u.guard >= 0 or (u.bryan and u.k == "npc_rival") or u.ot_boss
	if u.hp < u.maxhp or named or u.leader:
		var bw = 62.0 if u.boss else (46.0 if named else (40.0 if u.leader else (20.0 if u.role == "troop" else 28.0)))
		n.draw_rect(Rect2(-bw / 2 - 1, top - 1, bw + 2, 5), Color(0, 0, 0, 0.65))
		n.draw_rect(Rect2(-bw / 2, top, bw * maxf(0, u.hp / u.maxhp), 3), Color("#e84a5f") if u.side else (Color("#ffd84a") if u.leader else Color("#4ade80")))
		if u.sk != null and u.side == 0 and not u.leader: n.draw_rect(Rect2(-bw / 2, top + 4, bw * minf(1, u.energy / 100.0), 2), Color("#ffd84a") if u.energy >= 100 else Color("#7dd3fc"))
		if u.role == "crew" and u.g != null and J.num(u.g.get("fat", 0)) >= 70: n.draw_string(fnt, Vector2(bw / 2 + 1, top + 8), "累", HORIZONTAL_ALIGNMENT_LEFT, -1, 10, Color("#ff9a5a"))
	if named or u.leader:
		var txt = "阿福" if u.leader else (("%s・%s" % [u.kname, u.name]) if u.kname != "" else (("釘子戶・%s" % u.name) if u.elite else u.name))
		var col = Color("#ffe9a0") if u.leader else (Color("#ffb0ff") if u.elite else (Color("#ff9a9a") if u.bryan else Color("#ffd0d8")))
		var fs = 13 if u.boss else 11
		var sw = fnt.get_string_size(txt, HORIZONTAL_ALIGNMENT_LEFT, -1, fs).x
		n.draw_string_outline(fnt, Vector2(-sw / 2, top - 5), txt, HORIZONTAL_ALIGNMENT_LEFT, -1, fs, 3, Color(0, 0, 0, 0.85))
		n.draw_string(fnt, Vector2(-sw / 2, top - 5), txt, HORIZONTAL_ALIGNMENT_LEFT, -1, fs, col)
		if u.guard >= 0 and not u.awake and u.boss:
			var req = J.num(CHAPTERS[ci].stages[u.guard].req)
			if J.num(S.lv) < req:
				var rt = "需主公 Lv%d" % int(req); var rw = fnt.get_string_size(rt, HORIZONTAL_ALIGNMENT_LEFT, -1, fs).x
				n.draw_string_outline(fnt, Vector2(-rw / 2, top - 19), rt, HORIZONTAL_ALIGNMENT_LEFT, -1, fs, 3, Color(0, 0, 0, 0.85))
				n.draw_string(fnt, Vector2(-rw / 2, top - 19), rt, HORIZONTAL_ALIGNMENT_LEFT, -1, fs, Color("#ff8a8a"))
	if u.side == 1 and phase(J.num(st().min)) == "work" and not u.provoked and u.guard < 0 and not u.bryan:
		var mt = "摸魚中 z"; var mw = fnt.get_string_size(mt, HORIZONTAL_ALIGNMENT_LEFT, -1, 10).x
		n.draw_string(fnt, Vector2(-mw / 2, top - 5), mt, HORIZONTAL_ALIGNMENT_LEFT, -1, 10, Color(200 / 255.0, 220 / 255.0, 1, 0.75))
	n.draw_set_transform_matrix(Transform2D.IDENTITY)
