# 共用戰鬥特效（夜班巡陰 ＋ 地圖半即時戰鬥）：同一批 fx 貼圖、同一套配方、同一個畫法
#   emit: Callable(n: String, x: float, y: float, o: Dictionary) —— 由用嘅一方決定點收（巡陰＝pt_run.spr；rts＝rts_fx.spr）
#   配方數字全部由巡陰（pt_run.gd）原封搬過嚟：兩邊觀感一樣
extends RefCounted

const HUE := {"yuan": 110.0, "chan": -150.0, "lan": 35.0, "foe": -155.0, "gold": 0.0}
# 嚇法 → 出手風格（巡陰武器 sty 同一套名）；色相跟巡陰陣營色
const TYPE_STY := {"breath": "spin", "light": "beam", "cold": "drain", "sound": "slam", "paper": "paper", "phone": "pull", "face": "smash", "shadow": "combo"}
const TYPE_HUE := {"breath": 0.0, "light": -150.0, "cold": 35.0, "sound": 110.0, "paper": -150.0, "phone": 35.0, "face": 0.0, "shadow": 110.0}
# 嚇法 → 出場特效（appear 四種：0 鬼火、1 煙、2 紙紮、3 地裂）
const TYPE_APPEAR := {"breath": 0, "light": 0, "cold": 3, "sound": 1, "paper": 2, "phone": 0, "face": 1, "shadow": 3}

static func spark(emit: Callable, x: float, y: float, k: float, red: bool) -> void:
	emit.call("fx_hit", x, y, {"s0": 0.08 * k, "s1": 0.22 * k, "life": 0.18, "rot": randf() * 6.28, "hue": -155.0 if red else 0.0})
	if k >= 1.3: emit.call("fx_bolt", x, y - 6, {"s0": 0.18, "s1": 0.3, "life": 0.16, "rot": (randf() - 0.5) * 1.2})

static func dust(emit: Callable, x: float, y: float, k: float) -> void:
	emit.call("fx_dust", x + (randf() - 0.5) * 10, y, {"add": true, "alpha": 0.45, "s0": 0.06 * k, "s1": 0.16 * k, "life": 0.5, "vy": 10.0, "anchor": 0.8, "flip": randf() < 0.5})

# 出場：回傳要播嘅聲
static func appear(emit: Callable, x: float, y: float, style: int, k := 1.0) -> String:
	match style:
		0:
			for i in 8:
				var a = i / 8.0 * TAU; var r = 46 * k
				emit.call("fx2_ghostfire", x + cos(a) * r, y - 30 + sin(a) * r * 0.5, {"vx": -cos(a) * r, "vy": sin(a) * r * 0.5, "s0": 0.22 * k, "s1": 0.1 * k, "life": 0.55, "anchor": 0.85})
			emit.call("fx2_burst", x, y - 34, {"s0": 0.1 * k, "s1": 0.45 * k, "life": 0.5, "alpha": 0.9})
		1:
			emit.call("fx2_smoke", x, y - 20, {"s0": 0.2 * k, "s1": 0.75 * k, "life": 0.9, "add": false, "alpha": 0.85, "vy": 20.0})
			emit.call("fx2_smoke", x + 20 * k, y - 10, {"s0": 0.15 * k, "s1": 0.5 * k, "life": 0.75, "add": false, "alpha": 0.7, "flip": true, "rot": 0.4})
		2:
			emit.call("fx2_scraps", x, y - 30, {"s0": 0.25 * k, "s1": 0.6 * k, "life": 0.85, "add": false, "spin": 5.0, "alpha": 0.95})
			emit.call("fx2_scraps", x, y - 30, {"s0": 0.4 * k, "s1": 0.8 * k, "life": 0.7, "add": false, "spin": -4.0, "alpha": 0.6, "flip": true})
		3:
			emit.call("fx2_crack", x, y + 6, {"ground": true, "add": false, "s0": 0.32 * k, "s1": 0.4 * k, "life": 1.6, "alpha": 1.0, "sy": 0.6})
			emit.call("fx2_ghostfire", x, y - 10, {"s0": 0.12 * k, "s1": 0.3 * k, "life": 0.7, "vy": 50.0, "anchor": 0.9, "alpha": 0.8, "hue": 280.0})
	return "paper" if style == 2 else "hit"

# 普通近戰一刀（巡陰 fire() 近戰）
static func slash(emit: Callable, vx: float, hy: float, dir: float, big: float, hue: float) -> void:
	emit.call("fx_slash", vx - dir * 6, hy, {"s0": 0.16 * big, "s1": 0.3 * big, "life": 0.2, "flip": dir < 0, "rot": (randf() - 0.5) * 0.6, "hue": hue})

# 出手風格嘅畫面部分（巡陰 wfire() 每種 sty 嘅貼圖）。u＝出手者腳底、v＝目標腳底、hy＝目標身中高度
#   回傳 {"shake": 震屏量, "stop": 命中停頓秒}（由用嘅一方決定點用）
static func strike(emit: Callable, sty: String, u: Vector2, v: Vector2, hy: float, hue: float, k := 1.0) -> Dictionary:
	var dir = signf(v.x - u.x); if dir == 0: dir = 1
	var out = {"shake": 0.0, "stop": 0.0}
	match sty:
		"smash", "drain":
			emit.call("fx_shock", v.x, v.y, {"ground": true, "s0": 0.2 * k, "s1": 0.55 * k, "life": 0.35, "hue": hue}); dust(emit, v.x, v.y, 1.2 * k)
			out = {"shake": 6.0, "stop": 0.05}
			if sty == "drain": emit.call("fx_heal", v.x, hy, {"s0": 0.15, "s1": 0.05, "life": 0.4, "vx": u.x - v.x, "vy": -(u.y - v.y), "hue": HUE.yuan})
		"spin", "flail":
			emit.call("fx_wind", u.x, u.y, {"s0": 0.4 * k, "s1": 0.8 * k, "life": 0.4, "anchor": 0.85, "hue": hue, "spin": 9.0})
		"beam":
			var d = u.distance_to(v) + 20; var ang = atan2(v.y - u.y, v.x - u.x)
			emit.call("fx_beam", (u.x + v.x) / 2, (u.y + v.y) / 2 - 30 * k, {"s0": 0.4 * k, "s1": 0.5 * k, "sx": d / 180, "life": 0.25, "rot": ang - PI / 2, "hue": hue})
		"combo":
			for i in 3: emit.call("fx_slash", v.x - dir * 6, hy + (i - 1) * 8, {"t": -i * 0.12, "s0": 0.16 * k, "s1": 0.3 * k, "life": 0.16, "flip": (dir > 0) if i % 2 else (dir < 0), "rot": (i - 1) * 0.5, "hue": hue})
		"splash":
			emit.call("fx_smoke", v.x, v.y, {"ground": true, "s0": 0.3 * k, "s1": 0.75 * k, "life": 0.7, "hue": hue})
		"pull":
			var d2 = u.distance_to(v)
			emit.call("fx_bolt", (u.x + v.x) / 2, (u.y + v.y) / 2 - 30 * k, {"s0": 0.2 * k, "s1": 0.3 * k, "sx": d2 / 160, "life": 0.2, "rot": atan2(v.y - u.y, v.x - u.x), "hue": hue})
		"poke":
			var ang2 = atan2(v.y - u.y, v.x - u.x)
			emit.call("fx_dash", u.x + cos(ang2) * 40, u.y - 30 * k, {"s0": 0.25 * k, "s1": 0.4 * k, "life": 0.18, "rot": ang2, "hue": hue})
		"slam":
			emit.call("fx_shock", v.x, v.y, {"ground": true, "s0": 0.3 * k, "s1": 0.9 * k, "life": 0.45, "hue": hue}); dust(emit, v.x - 30 * k, v.y, 1.6 * k); dust(emit, v.x + 30 * k, v.y, 1.6 * k)
			out = {"shake": 9.0, "stop": 0.07}
		"paper":   # 紙紮：碎紙打埋身
			emit.call("fx2_scraps", v.x, hy, {"s0": 0.12 * k, "s1": 0.3 * k, "life": 0.4, "add": false, "spin": 6.0, "alpha": 0.95})
			slash(emit, v.x, hy, dir, k, hue)
		_:
			slash(emit, v.x, hy, dir, k, hue)
	return out

# 技能大招（巡陰 skill()）：kind＝heal／aoe／其他（單體）
static func skill(emit: Callable, kind: String, u: Vector2, v, hy: float, hue: float, k := 1.0) -> Dictionary:
	if kind == "heal":
		emit.call("fx_heal", u.x, u.y - 30, {"s0": 0.15, "s1": 0.35, "life": 0.8, "vy": 30.0, "spin": 1.5})
		return {"shake": 0.0, "stop": 0.0, "flash": 0.0}
	if kind == "aoe":
		emit.call("fx_wind", u.x, u.y, {"s0": 0.4 * k, "s1": 1.1 * k, "life": 0.6, "anchor": 0.85, "hue": hue}); emit.call("fx_scream", u.x, u.y - 40 * k, {"s0": 0.3 * k, "s1": 1.6 * k, "life": 0.5, "alpha": 0.8, "hue": hue}); emit.call("fx_shock", u.x, u.y, {"ground": true, "s0": 0.8 * k, "s1": 1.8 * k, "life": 0.5, "hue": hue})
		return {"shake": 8.0, "stop": 0.06, "flash": 0.35}
	if v is Vector2:
		var d = signf(v.x - u.x); if d == 0: d = 1
		emit.call("fx_slash", v.x, hy, {"s0": 0.35 * k, "s1": 0.6 * k, "life": 0.3, "flip": d < 0, "hue": hue}); emit.call("fx_hit", v.x, hy, {"s0": 0.2 * k, "s1": 0.45 * k, "life": 0.25}); emit.call("fx_bolt", v.x, v.y - 50 * k, {"s0": 0.25 * k, "s1": 0.4 * k, "life": 0.2})
	return {"shake": 6.0, "stop": 0.05, "flash": 0.0}

# 畫一張特效貼圖（巡陰 _draw_spr 原樣）
static func draw_spr(c: CanvasItem, f: Dictionary, im: Texture2D) -> void:
	if im == null or f.t < 0: return
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

# 飛彈本體（巡陰 _draw_proj 原樣）：fx_fire 貼圖，按色相上色
static func draw_bolt(c: CanvasItem, fi: Texture2D, p: Vector2, ang: float, big: float, hue: float) -> void:
	if fi == null: return
	var W = 46 * big; var H = W * fi.get_height() / fi.get_width()
	c.draw_set_transform_matrix(Transform2D(ang, p))
	var col = Color.WHITE
	if hue != 0.0:
		var v = (PtGfx.m_sat(1.2) * PtGfx.m_hue(hue)) * Vector3(0.6, 1.0, 0.8); col = Color(clampf(v.x / 1.0, 0, 1) * 1.4, clampf(v.y, 0, 1), clampf(v.z, 0, 1) * 1.2)
	c.draw_texture_rect(fi, Rect2(-W * 0.8, -H / 2, W, H), false, col)
	c.draw_set_transform_matrix(Transform2D.IDENTITY)

static func spr_dict(n: String, x: float, y: float, o: Dictionary) -> Dictionary:
	var f = {"kind": "spr", "n": n, "x": x, "y": y, "t": 0.0, "life": 0.3, "s0": 0.3, "s1": 0.5, "rot": 0.0, "alpha": 1.0, "add": true, "sx": 1.0, "sy": 1.0, "vy": 0.0, "hue": 0.0}
	f.merge(o, true)
	return f

# 按（地面／上層、色相、疊光）分組畫：groups 係快取 {key: PtDraw}；回傳 {key: [fx...]}
static func sync_groups(fx: Array, groups_n: Dictionary, ground: Node, top: Node, tex_fn: Callable) -> Dictionary:
	var groups = {}
	for f in fx:
		if f.kind != "spr": continue
		var key = "%s_%d_%s" % ["g" if f.get("ground", false) else "t", int(f.hue), f.add]
		if not groups.has(key): groups[key] = []
		groups[key].append(f)
	for key in groups_n.keys():
		if not groups.has(key): groups_n[key].visible = false
	for key in groups:
		var n: PtDraw = groups_n.get(key)
		if n == null:
			n = PtDraw.new(); var parts = key.split("_")
			n.material = PtGfx.hue_mat(float(parts[1]), parts[2] == "true")
			(ground if parts[0] == "g" else top).add_child(n); groups_n[key] = n
		n.visible = true
		var lst = groups[key]
		n.fn = func(c): for f in lst: draw_spr(c, f, tex_fn.call(f.n))
		n.queue_redraw()
	return groups
