# 村子場景（移植 game.js Village）：世界座標 390×1130，可上下拖動；主公砍樹、收割、親手做
extends Control

const W := 390.0
const WH := 1130.0
const POS := {"gate": [195, 118], "house": [195, 300], "furnace": [338, 258], "wood": [92, 612], "rice": [298, 612], "plank": [95, 752], "bun": [295, 752], "store": [195, 872], "home": [92, 1000], "camp": [300, 1000], "altar": [195, 1092]}
const DECOR := [["webTL", 223, 389], ["webTR", 375, 389], ["scarecrow", 293, 488], ["willo", 258, 438], ["willo", 350, 498], ["willo", 300, 404], ["post", 160, 180], ["post", 230, 180], ["post", 160, 690], ["post", 230, 690], ["post", 160, 945], ["post", 230, 945], ["grave", 26, 840], ["grave", 58, 858], ["grave", 362, 850], ["banana", 372, 560], ["banana", 18, 610], ["banana", 372, 930], ["banana", 20, 1060], ["offer", 150, 320], ["offer", 240, 320], ["grave", 360, 1080], ["offer", 290, 880]]
const TREE_POS := [[38, 402], [92, 392], [146, 404], [62, 452], [118, 448], [168, 458], [40, 506], [100, 512]]
const PADDY_POS := [[248, 412], [338, 412], [248, 462], [338, 462], [248, 512], [338, 512]]

signal open_building(id: String)
signal open_gate

var camY = 180.0
var t = 0.0
var sc = 1.0
var hero = {"x": 195.0, "y": 350.0, "tx": 195.0, "ty": 350.0, "dir": 1, "act": null, "actT": 0.0, "target": null, "walking": false}
var floats: Array = []
var crows: Array = []
var feathers: Array = []
var parts: Array = []
var vis: Array = []
var bubble = null
var chat_t = 6.0
var chat_used = {}
var hitstop = 0.0
var shk = 0.0
var proudT = 0.0
var _pp = null
var drag = null
var ground_tex: Texture2D
var active = true

func _ready() -> void:
	clip_contents = true
	mouse_filter = Control.MOUSE_FILTER_STOP
	G.floated.connect(func(x, y, text, col): floats.append({"x": x, "y": y, "text": text, "col": col, "t": 0.0, "life": 1.6}))
	_bake_ground()

func fx_float(x: float, y: float, text: String, col := "#fff") -> void:
	floats.append({"x": x, "y": y, "text": text, "col": col, "t": 0.0, "life": 1.6})

func view_h() -> float: return size.y / sc
func set_cam(y: float) -> void: camY = clampf(y, 0, maxf(0, WH - view_h()))
func focus(x: float, y: float) -> void: set_cam(y - view_h() / 2)

# ---------------- 地面：一次過畫好存成貼圖 ----------------
func _bake_ground() -> void:
	var vp = SubViewport.new()
	vp.size = Vector2i(int(W * 2), int(WH * 2)); vp.transparent_bg = false
	vp.render_target_update_mode = SubViewport.UPDATE_ONCE
	var painter = Node2D.new(); painter.set_script(load("res://game/ground_painter.gd"))
	painter.set("POS", POS)
	vp.add_child(painter); add_child(vp)
	await RenderingServer.frame_post_draw
	await RenderingServer.frame_post_draw
	ground_tex = ImageTexture.create_from_image(vp.get_texture().get_image())
	vp.queue_free()

# ---------------- 輸入 ----------------
func _gui_input(e: InputEvent) -> void:
	if e is InputEventMouseButton:
		var p = (e as InputEventMouseButton).position / sc
		if e.button_index == MOUSE_BUTTON_WHEEL_DOWN and e.pressed: set_cam(camY + 40); return
		if e.button_index == MOUSE_BUTTON_WHEEL_UP and e.pressed: set_cam(camY - 40); return
		if e.button_index != MOUSE_BUTTON_LEFT: return
		if e.pressed: drag = {"y0": p.y, "cam": camY, "moved": false, "x": p.x, "y": p.y}
		elif drag != null:
			var d = drag; drag = null
			if not d.moved: tap(d.x, d.y + camY)
	elif e is InputEventMouseMotion and drag != null:
		var p2 = (e as InputEventMouseMotion).position / sc
		var dy: float = p2.y - drag.y0
		if absf(dy) > 8: drag.moved = true
		if drag.moved: set_cam(drag.cam - dy)

func hit_test(x: float, y: float) -> Variant:
	for i in TREE_POS.size():
		var tp: Array = TREE_POS[i]
		if absf(x - tp[0]) < 24 and y > tp[1] - 72 and y < tp[1] + 8: return {"kind": "tree", "i": i}
	for i in PADDY_POS.size():
		var pp: Array = PADDY_POS[i]
		if absf(x - pp[0]) < 26 and absf(y - pp[1] + 4) < 16: return {"kind": "paddy", "i": i}
	for id in POS:
		var b: Array = POS[id]
		var w = 70.0 if id == "house" else (65.0 if id == "gate" else (26.0 if id == "furnace" else 46.0))
		var h = 115.0 if id == "house" else (92.0 if id == "gate" else 70.0)
		if absf(x - b[0]) < w and y > b[1] - h and y < b[1] + 10: return {"kind": "gate" if id == "gate" else "bld", "id": id}
	return null

func tap(x: float, y: float) -> void:
	if G.story_busy.call() or G.modal_open.call(): return
	var h = hit_test(x, y)
	if h == null: walk_to(x, y, null); return
	match h.kind:
		"tree":
			if int(G.S.trees[h.i]) > 0: walk_to(TREE_POS[h.i][0] + 20, TREE_POS[h.i][1] + 4, {"kind": "tree", "i": h.i})
			else: fx_float(x, y - 30, "樹樁還在長…", "#ccc")
		"paddy":
			if G.S.paddy[h.i]: walk_to(PADDY_POS[h.i][0] - 30, PADDY_POS[h.i][1] + 4, {"kind": "paddy", "i": h.i})
			else: fx_float(x, y - 20, "稻子還沒熟", "#ccc")
		"gate": open_gate.emit()
		"bld": open_building.emit(h.id)

func walk_to(x: float, y: float, target) -> void:
	hero.tx = clampf(x, 14, W - 14); hero.ty = clampf(y, 150, WH - 10); hero.target = target; hero.act = null

func craft(bid: String, n: int) -> void:
	n = maxi(1, n); var src = "wood" if bid == "plank" else "rice"; var can = int(floor(float(G.S.res[src]) / 4))
	var rn: String = DB.D.RES_NAMES[src]
	if can < 1: fx_float(hero.x, hero.y - 60, "%s不夠（要 4）" % rn, "#ff9a9a"); return
	if can < n: fx_float(hero.x, hero.y - 60, "材料只夠做 %d 份" % can, "#ffb37a")
	var b: Array = POS[bid]
	walk_to(b[0] + (40 if bid == "plank" else -40), b[1] + 14, {"kind": "craft", "bid": bid, "n": n, "want": n, "done": 0, "short": can < n, "dur": 0.9})

# ---------------- 更新 ----------------
func _process(dt: float) -> void:
	sc = size.x / W
	if not active or G.S.is_empty(): return
	dt = minf(dt, 0.1)
	update(dt)
	queue_redraw()

func update(dt: float) -> void:
	if hitstop > 0: hitstop -= dt; _update_parts(dt * 0.3, true); return
	t += dt; var H = hero; var S: Dictionary = G.S
	for i in S.trees.size():
		if int(S.trees[i]) <= 0:
			S.treeRegrow[i] = float(S.treeRegrow[i]) - dt
			if S.treeRegrow[i] <= 0: S.trees[i] = 3
	for i in S.paddy.size():
		if not S.paddy[i]:
			S.paddyRegrow[i] = float(S.paddyRegrow[i]) - dt
			if S.paddyRegrow[i] <= 0: S.paddy[i] = 1
	var dx: float = H.tx - H.x; var dy: float = H.ty - H.y; var d = Vector2(dx, dy).length()
	if d > 2:
		var sp = G.walk() * dt; H.x += dx / d * minf(sp, d); H.y += dy / d * minf(sp, d)
		if absf(dx) > 1: H.dir = 1 if dx > 0 else -1
		H.walking = true
	else:
		H.walking = false
		if H.target != null:
			H.act = H.target; H.target = null; H.actT = 0.0
			if H.act.kind == "tree": H.dir = -1
			if H.act.kind == "paddy": H.dir = 1
			if H.act.kind == "craft": H.dir = -1 if H.act.bid == "plank" else 1
		if H.act != null: _do_act(dt)
	_update_parts(dt)
	floats = floats.filter(func(f): f.t += dt; return f.t < f.life)
	feathers = feathers.filter(func(f): f.t += dt; f.x += f.vx * dt + sin(f.t * 4) * 0.4; f.y += 14 * dt; f.rot += dt * 2; return f.t < f.life)
	crows = crows.filter(func(c): c.t += dt; c.x += c.vx * dt; c.y += c.vy * dt; c.vy -= 30 * dt; c.ph += dt * 22; return c.t < c.life)
	if bubble != null:
		bubble.t += dt
		if bubble.t > 4.6: bubble = null
	chat_t -= dt
	if chat_t <= 0 and bubble == null: chat_t = 6 + randf() * 5; _pick_chatter()

func _do_act(dt: float) -> void:
	var H = hero; var a: Dictionary = H.act; var S: Dictionary = G.S; H.actT += dt
	if a.kind == "tree":
		if int(S.trees[a.i]) <= 0: H.act = null; return
		if H.actT >= G.chopTime():
			H.actT = 0.0; var first_hit: bool = int(S.trees[a.i]) == 3; S.trees[a.i] = int(S.trees[a.i]) - 1; a.shake = 0.15; G.sound.emit("chop")
			var tp: Array = TREE_POS[a.i]
			impact(tp[0] + 6, tp[1] - 22, "wood", 1.2 if first_hit else 1.0)
			if first_hit: _scatter_crows(a.i)
			fx_float(tp[0], tp[1] - 50, "咚！", "#ffe9a8")
			if int(S.trees[a.i]) <= 0:
				S.treeRegrow[a.i] = 25; S.cnt.chop = int(S.cnt.chop) + 1; S.res.wood = float(S.res.wood) + 4; G.gainExp(2); G.sound.emit("treeFall")
				fx_float(tp[0], tp[1] - 70, "槐木 +4　好評 +2", "#a8ffcf"); G.praise.emit("chop"); H.act = null; proudT = 0.9; shk = 5; G.quest_check()
	elif a.kind == "paddy":
		if H.actT >= G.chopTime() * 1.4:
			S.paddy[a.i] = 0; S.paddyRegrow[a.i] = 20; proudT = 0.8; S.cnt.rice = int(S.cnt.rice) + 1; S.res.rice = float(S.res.rice) + 3; G.gainExp(1); G.sound.emit("harvest")
			var pp: Array = PADDY_POS[a.i]; fx_float(pp[0], pp[1] - 30, "糯米 +3　好評 +1", "#a8ffcf"); G.praise.emit("rice"); H.act = null; G.quest_check()
	elif a.kind == "craft":
		if H.actT >= a.dur:
			var plank: bool = a.bid == "plank"; var src = "wood" if plank else "rice"; var out = "planks" if plank else "buns"
			var RN: Dictionary = DB.D.RES_NAMES
			if float(S.res[src]) < 4:
				H.act = null; fx_float(H.x, H.y - 60, ("%s用完了，做好 %d 份" % [RN[src], a.done]) if a.done else ("%s不夠（要 4）" % RN[src]), "#ff9a9a"); return
			S.res[src] = float(S.res[src]) - 4; S.res[out] = float(S.res[out]) + 2
			var ck = "craftPlank" if plank else "craftBun"; S.cnt[ck] = int(S.cnt[ck]) + 1; G.gainExp(1); G.sound.emit("craft")
			a.done += 1; a.n -= 1; G.quest_check()
			var more: bool = a.n > 0 and float(S.res[src]) >= 4
			if a.want == 1: fx_float(H.x, H.y - 60, "%s +2　好評 +1" % RN[out], "#a8ffcf"); G.praise.emit("craft")
			elif more: fx_float(H.x + 26, H.y - 44, "%s %d/%d" % [RN[out], a.done, (a.done + mini(a.n, int(floor(float(S.res[src]) / 4)))) if a.short else a.want], "#ffe9a8")
			if more: H.actT = 0.0; a.dur = 0.6; return
			H.act = null
			if a.want > 1: fx_float(H.x, H.y - 66, "%s +%d　好評 +%d" % [RN[out], a.done * 2, a.done], "#a8ffcf"); G.praise.emit("craft")

func hero_pose() -> Array:
	var H = hero; var a = H.act
	if proudT > 0: return ["proud", 0.0]
	if a == null or H.walking: return [null, 0.0]
	if a.kind == "tree": return ["chop", minf(1, H.actT / G.chopTime())]
	if a.kind == "paddy": return ["reap", minf(1, H.actT / (G.chopTime() * 1.4))]
	if a.kind == "craft": return ["hammer" if a.bid == "plank" else "knead", minf(1, H.actT / a.get("dur", 0.9))]
	return [null, 0.0]

func impact(x: float, y: float, kind: String, power := 1.0) -> void:
	hitstop = maxf(hitstop, 0.05 * power); shk = maxf(shk, 2.5 * power)
	parts.append({"k": "spark", "x": x, "y": y, "t": 0.0, "life": 0.16, "s": 0.07 * power, "r": randf() * 6})
	var n = 6 if kind == "wood" else (9 if kind == "rice" else (2 if kind == "dough" else 3))
	for i in n:
		var k = "chip" if kind == "wood" else ("grain" if kind == "rice" else ("dough" if kind == "dough" else "dust"))
		parts.append({"k": k, "x": x, "y": y, "vx": (randf() - 0.5) * 120 + (50.0 if kind == "wood" else 0.0), "vy": -60 - randf() * 90, "g": -10.0 if kind == "dust" else 320.0, "t": 0.0, "life": 0.5 + randf() * 0.4, "r": randf() * 6, "vr": (randf() - 0.5) * 18, "s": 0.022 if kind == "dough" else (0.035 if kind == "dust" else 0.04 + randf() * 0.03)})
	if kind != "rice": parts.append({"k": "dust", "x": x, "y": y + 4, "vx": 0.0, "vy": -12.0, "g": 0.0, "t": 0.0, "life": 0.45, "r": 0.0, "vr": 0.0, "s": 0.05})

func _update_parts(dt: float, frozen := false) -> void:
	parts = parts.filter(func(p): p.t += dt; p.x += p.get("vx", 0.0) * dt; p.y += p.get("vy", 0.0) * dt; p.vy = p.get("vy", 0.0) + p.get("g", 0.0) * dt; p.r += p.get("vr", 0.0) * dt; return p.t < p.life)
	if shk > 0: shk = maxf(0, shk - dt * 18)
	if proudT > 0: proudT -= dt
	if frozen: return
	var H = hero; var a = H.act
	if a != null and a.kind == "craft" and not H.walking:
		var p = minf(1, H.actT / a.get("dur", 0.9)); var hits = [0.5, 0.999] if a.bid == "plank" else [0.125, 0.375, 0.625, 0.875]
		var prev: float = p if _pp == null else _pp
		for h in hits:
			if prev < h and p >= h: impact(H.x + (-16 if H.dir < 0 else 16), H.y - 4, "wood" if a.bid == "plank" else "dough", 0.8 if a.bid == "plank" else 0.4)
		_pp = 0.0 if p >= 0.999 else p
	elif a != null and a.kind == "paddy" and not H.walking:
		var p2 = minf(1, H.actT / (G.chopTime() * 1.4)); var prev2: float = p2 if _pp == null else _pp
		for h in [1.0 / 12, 5.0 / 12, 9.0 / 12]:
			if prev2 < h and p2 >= h:
				var pp: Array = PADDY_POS[a.i]; impact(pp[0] - 6 + randf() * 12, pp[1] - 8, "rice", 0.5)
		_pp = p2
	else: _pp = null

func _scatter_crows(i: int) -> void:
	var tp: Array = TREE_POS[i]; var n = 3 + randi() % 3
	for k in n:
		var dir = 1 if k % 2 else -1; var sx: float = tp[0] + (randf() - 0.5) * 40; var sy: float = tp[1] - 48 - randf() * 18
		crows.append({"x": sx, "y": sy, "vx": dir * (50 + randf() * 90), "vy": -(50 + randf() * 60), "t": 0.0, "life": 2 + randf() * 0.8, "ph": randf() * 6, "s": 1.1 + randf() * 0.4})
		feathers.append({"x": sx, "y": sy, "t": 0.0, "life": 2.4, "vx": (randf() - 0.5) * 20, "rot": randf() * 6})
	G.sound.emit("crow")

func _pick_chatter() -> void:
	var top = camY + 60; var bot = camY + view_h() - 20
	var CH: Dictionary = DB.D.CHATTER
	var cand = vis.filter(func(v): return v.y > top + 120 and v.y < bot and CH.has(v.g.k) and (not v.get("hero", false) or int(G.S.qi) > 3))
	if cand.is_empty() or G.story_busy.call() or G.modal_open.call(): return
	var v: Dictionary = cand[randi() % cand.size()]; var k: String = v.g.k
	if not chat_used.has(k): chat_used[k] = []
	var used: Array = chat_used[k]
	var pool: Array = CH[k].filter(func(l): return not used.has(l))
	if pool.is_empty(): used.clear(); pool = CH[k]
	var line = pool[randi() % pool.size()]; used.append(line)
	bubble = {"id": v.g.id, "hero": v.get("hero", false), "text": DB.L(line), "t": 0.0}

func worker_spots() -> Array:
	var out = []
	var add = func(post: String, pts: Array) -> void:
		var ws = G.workersAt(post)
		for i in ws.size():
			var p: Array = pts[i % pts.size()]
			out.append({"g": ws[i], "x": float(p[0]), "y": float(p[1]), "flip": p[2] == 1, "ph": i * 0.7, "post": post})
	add.call("wood", [[130, 520, 1], [178, 430, 1], [70, 540, 0], [24, 460, 0]])
	add.call("rice", [[290, 437, 0], [290, 487, 0], [290, 537, 1], [372, 487, 1]])
	add.call("plank", [[45, 770, 0], [140, 772, 1], [60, 790, 0], [128, 794, 1]])
	add.call("bun", [[250, 772, 0], [345, 770, 1], [262, 794, 0], [332, 794, 1]])
	add.call("store", [[150, 890, 0]]); add.call("boss", [[260, 320, 1]])
	add.call("camp", [[250, 1018, 0], [350, 1018, 1], [270, 1036, 0], [330, 1036, 1]])
	return out

func quest_target() -> Variant:
	var q = G.quest_cur()
	if q == null: return null
	var S: Dictionary = G.S
	match q.go:
		"tree":
			for i in S.trees.size():
				if int(S.trees[i]) > 0: return TREE_POS[i]
			return TREE_POS[0]
		"paddy":
			for i in S.paddy.size():
				if S.paddy[i]: return PADDY_POS[i]
			return PADDY_POS[0]
	if POS.has(q.go): return POS[q.go]
	return null

# ---------------- 畫 ----------------
func _draw() -> void:
	if G.S.is_empty(): return
	var kx = (randf() - 0.5) * shk; var ky = (randf() - 0.5) * shk
	var base = Transform2D(Vector2(sc, 0), Vector2(0, sc), Vector2(kx * sc, (ky - camY) * sc))
	var ctx = Ctx.new(self, base)
	var S: Dictionary = G.S
	if ground_tex: ctx.drawImage(ground_tex, 0, 0, W, WH)
	else: ctx.fillStyle = "#211b19"; ctx.fillRect(0, 0, W, WH)
	for i in 9: Art.draw_lily(ctx, fmod(i * 47 + 20, W), 24 + (i * 31) % 112, t + i)
	for i in 6:
		var mx = fmod(t * 8 + i * 90, W + 200) - 100; var my = 160.0 + i * 170
		var mg = ctx.createRadialGradient(mx, my, 5, mx, my, 90); mg.addColorStop(0, "rgba(200,210,200,.06)"); mg.addColorStop(1, "rgba(200,210,200,0)")
		ctx.fillStyle = mg; ctx.fillRect(mx - 90, my - 90, 180, 180)
	var top = camY - 140; var bot = camY + view_h() + 140
	var items: Array = []
	items.append([POS.gate[1], func(): Art.draw_gate(ctx, POS.gate[0], POS.gate[1], t)])
	for id in DB.D.BLD_ORDER:
		var p: Array = POS[id]; var lv = S.bld.get(id, 0)
		if p[1] < top or p[1] > bot + 40: continue
		if lv and float(lv) > 0: items.append([p[1], func(): Art.draw_building(ctx, id, p[0], p[1], int(lv), t, G.furnaceReady() if id == "furnace" else null)])
		elif G.bldUnlocked(id): items.append([p[1], func(): Art.draw_site(ctx, p[0], p[1], DB.D.BUILDINGS[id].name)])
	for d in DECOR:
		if d[2] < top or d[2] > bot: continue
		items.append([d[2], func(): Art.draw_decor(ctx, d[0], d[1], d[2], t)])
	for i in TREE_POS.size():
		var tp: Array = TREE_POS[i]
		if tp[1] < top or tp[1] > bot + 60: continue
		var a = hero.act; var shake = false
		if a != null and a.kind == "tree" and a.i == i and a.get("shake", 0.0) > 0:
			a.shake -= 1.0 / 60; shake = a.shake > 0
		items.append([tp[1], func(): Art.draw_tree(ctx, tp[0], tp[1], int(S.trees[i]), t, shake, int(S.trees[i]) == 3, i)])
	for i in PADDY_POS.size():
		var pp: Array = PADDY_POS[i]
		items.append([pp[1] - 10, func(): Art.draw_paddy(ctx, pp[0], pp[1], S.paddy[i], t, i)])
	var spots = worker_spots(); vis = []
	for s in spots:
		vis.append({"g": s.g, "x": s.x, "y": s.y})
		items.append([s.y, func(): Art.draw_char(ctx, s.g.k, s.x, s.y, 0.62, {"t": t + s.ph, "work": true, "flip": s.flip, "tamed": true})])
	var idle = []
	for g in S.ghosts:
		if g.get("post") == null and g.k != "afu": idle.append(g)
	for i in idle.size():
		var g: Dictionary = idle[i]; var a2 = t * 0.25 + i * 1.7
		var x = 195 + cos(a2) * (60 + (i % 3) * 18); var y = 400 + 130 + sin(a2 * 1.3) * 18 + (i % 3) * 8
		vis.append({"g": g, "x": x, "y": y})
		items.append([y, func(): Art.draw_char(ctx, g.k, x, y, 0.58, {"t": t + i, "walk": true, "flip": sin(a2) > 0, "tamed": true})])
	var H = hero
	vis.append({"g": S.ghosts[0], "x": H.x, "y": H.y, "hero": true})
	var hp = hero_pose()
	items.append([H.y, func(): Art.draw_char(ctx, "afu", H.x, H.y, 0.72, {"t": t, "walk": H.walking, "work": H.act != null, "flip": H.dir < 0, "pose": hp[0], "pt": hp[1]})])
	items.sort_custom(func(a, b): return a[0] < b[0])
	for it in items: it[1].call()
	for f in feathers:
		ctx.save(); ctx.globalAlpha = maxf(0, 1 - f.t / f.life); ctx.translate(f.x, f.y); ctx.rotate(sin(f.rot) * 0.8); Art.el(ctx, 0, 0, 1.4, 4, "#14111a", "#5a5068", 0.5); ctx.restore()
	_draw_parts(ctx)
	for c in crows:
		ctx.globalAlpha = minf(1, (c.life - c.t) / 0.6); Art.draw_crow(ctx, c.x, c.y, c.s, c.ph, c.vx, false); ctx.globalAlpha = 1
	if bubble != null: _draw_bubble(ctx)
	_draw_pointer(ctx)
	for f in floats:
		ctx.globalAlpha = maxf(0, 1 - f.t / f.life); ctx.font = "bold 14px \"PingFang TC\",\"Noto Sans TC\",sans-serif"; ctx.textAlign = "center"
		ctx.lineWidth = 3.5; ctx.strokeStyle = "rgba(10,6,20,.9)"; ctx.strokeText(f.text, f.x, f.y - f.t * 26); ctx.fillStyle = f.col; ctx.fillText(f.text, f.x, f.y - f.t * 26); ctx.globalAlpha = 1

const PART_IM := {"spark": "fx_spark", "chip": "fx_chips", "dust": "fx_dust", "dough": "fx_dough", "grain": "fx_dough"}
func _draw_parts(ctx: Ctx) -> void:
	for p in parts:
		var f: float = p.t / p.life; ctx.save(); ctx.globalAlpha = maxf(0, 1 - f * f); ctx.translate(p.x, p.y); ctx.rotate(p.r)
		if p.k == "grain": ctx.fillStyle = "#e9cf7a"; ctx.fillRect(-1.5, -3, 3, 6)
		elif Spr.ok(PART_IM[p.k]):
			var I = Spr.get_tex(PART_IM[p.k]); var s: float = p.s * ((1 + f * 0.8) if p.k == "spark" else ((1 + f * 1.5) if p.k == "dust" else 1.0))
			ctx.drawImage(I, -I.get_width() * s / 2, -I.get_height() * s / 2, I.get_width() * s, I.get_height() * s)
		ctx.restore()

func _draw_bubble(ctx: Ctx) -> void:
	var b: Dictionary = bubble; var v = null
	for o in vis:
		if (b.hero and o.get("hero", false)) or (not b.hero and o.g.id == b.id and not o.get("hero", false)): v = o; break
	if v == null: bubble = null; return
	var a = minf(1, minf(b.t * 5, (4.6 - b.t) * 3)); ctx.save(); ctx.globalAlpha = maxf(0, a)
	ctx.font = "600 12.5px \"PingFang TC\",\"Noto Sans TC\",sans-serif"
	var maxW = 168.0; var lines = []; var cur = ""
	for ch in b.text:
		if ctx.measureText(cur + ch).width > maxW: lines.append(cur); cur = ch
		else: cur += ch
	if cur != "": lines.append(cur)
	var w = 0.0
	for l in lines: w = maxf(w, ctx.measureText(l).width)
	w += 16; var h = lines.size() * 17.0 + 10
	var bx = clampf(v.x - w / 2, 6, W - w - 6); var by: float = v.y - 62 - h
	Art.rr(ctx, bx, by, w, h, 4, "#ecd9a4", "#5a4030", 1.2)
	Art.poly(ctx, [v.x - 5, by + h - 0.5, v.x + 5, by + h - 0.5, v.x, by + h + 7], "#ecd9a4")
	ctx.strokeStyle = "#5a4030"; ctx.lineWidth = 1.2; ctx.beginPath(); ctx.moveTo(v.x - 5, by + h); ctx.lineTo(v.x, by + h + 7); ctx.lineTo(v.x + 5, by + h); ctx.stroke()
	ctx.fillStyle = "#2b1d12"; ctx.textAlign = "left"; ctx.textBaseline = "top"
	for i in lines.size(): ctx.fillText(lines[i], bx + 8, by + 6 + i * 17)
	ctx.restore()

var pointer_on = true
func _draw_pointer(ctx: Ctx) -> void:
	var p = quest_target()
	if p == null or not pointer_on: return
	var x: float = p[0]; var y: float = p[1]
	var ty = y - (128.0 if (x == POS.house[0] and y == POS.house[1]) else 78.0) + sin(t * 5) * 5
	var tp = camY + 8; var bt = camY + view_h() - 12; var rot = 0.0
	if ty < tp: ty = tp + 14; rot = PI
	elif ty > bt: ty = bt - 14
	ctx.save(); ctx.translate(x, ty); ctx.rotate(rot)
	Art.poly(ctx, [-9, -14, 9, -14, 9, -2, 15, -2, 0, 12, -15, -2, -9, -2], "#ffd84a", "#3a2400", 2); ctx.restore()
