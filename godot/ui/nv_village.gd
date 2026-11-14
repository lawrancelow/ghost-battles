# 村子（原生 Godot 版）：取代「JS Village.draw 每幀錄畫布」——
#  地面（一次拍成貼圖）、彼岸花、霧、建築／樹／稻田／擺設（原生 Art，冇變就唔重畫）、y 排序、
#  打工鬼／廣場鬼／阿福（JS 閉包畫入逐件錄製器；廣場鬼原生畫法見 nv_plaza.gd）、碎片、烏鴉、泡泡、任務箭頭、浮字。
# 邏輯（阿福走路、砍樹、產出、廣場鬼嘅行為）仍然係 JS（Village.update、PlazaLife.update），存檔同網頁互通。
extends "res://ui/js_canvas_view.gd"

const W := 390.0
const WH := 1130.0

var V: Dictionary
var world: Node2D
var ground: PtDraw
var lily: PtDraw
var mist: PtDraw
var ysort: Node2D
var top_fx: PtDraw
var top_ui: PtDraw
var statics := {}            # key → {node, sig}
var segs: Array = []         # 錄製器分段節點池
var seg_used := 0
var rec_ctx: Ctx
var ground_rec = null
var ground_tex: Texture2D
var t := 0.0
var cam_y := 0.0
var sc := 1.0
var shx := 0.0
var shy := 0.0
var plaza: NvPlaza
var stub := NvStub.new()
var prof := {}
var prof_n := 0

func bind(e: El) -> void:
	super.bind(e)
	J.G["__nat_village"] = true
	_build()

func _build() -> void:
	clip_contents = true
	world = Node2D.new(); add_child(world)
	ground = PtDraw.new(); ground.tag = "ground"; ground.fn = _draw_ground; world.add_child(ground)
	lily = PtDraw.new(); lily.tag = "lily"; lily.fn = _draw_lily; world.add_child(lily)
	ysort = Node2D.new(); ysort.y_sort_enabled = true; world.add_child(ysort)
	mist = PtDraw.new(); mist.tag = "mist"; mist.fn = _draw_mist; world.add_child(mist)
	top_fx = PtDraw.new(); top_fx.tag = "topfx"; top_fx.fn = _draw_top_fx; world.add_child(top_fx)
	top_ui = PtDraw.new(); top_ui.tag = "topui"; top_ui.fn = _draw_top_ui; world.add_child(top_ui)
	rec_ctx = Ctx.new(Recorder.new())
	plaza = NvPlaza.new(self)

# ---------------- 每幀 ----------------
func _process(_dt: float) -> void:
	if el == null or not visible or not is_visible_in_tree(): return
	V = J.G.get("Village")
	if V == null: return
	var t0 = Time.get_ticks_usec()
	sc = size.x / W
	# JS 嘅點擊座標／鏡頭夾限靠 Village.scale、Village.h：尺寸變咗就叫佢 resize 對齊
	if absf(J.num(V.get("scale", 0.0)) - sc) > 0.0005 or absf(J.num(V.get("h", 0.0)) - size.y) > 0.5: 
		V["scale"] = sc; V["w"] = size.x; V["h"] = size.y; J.mc(V, "setCam", [J.num(V.get("camY", 0.0))])
	t = J.num(V.get("t", 0.0)); cam_y = J.num(V.get("camY", 0.0))
	var sk = J.num(V.get("shk", 0.0))
	shx = (randf() - 0.5) * sk if sk > 0 else 0.0; shy = (randf() - 0.5) * sk if sk > 0 else 0.0
	world.transform = Transform2D(Vector2(sc, 0), Vector2(0, sc), Vector2(shx * sc, (shy - cam_y) * sc))
	_sync_statics()
	var t1 = Time.get_ticks_usec()
	_sync_dynamic()
	var t2 = Time.get_ticks_usec()
	if ground_tex == null: ground.queue_redraw()
	lily.queue_redraw(); mist.queue_redraw(); top_fx.queue_redraw(); top_ui.queue_redraw()
	if OS.has_environment("GB_PROF"):
		prof["static"] = prof.get("static", 0) + t1 - t0; prof["dyn"] = prof.get("dyn", 0) + t2 - t1; prof_n += 1
		if prof_n >= 30:
			var ex = ""
			for k in prof: if k != "static" and k != "dyn": ex += "%s=%.2f " % [k, prof[k] / 1000.0 / prof_n]
			print("[village] static=%.2fms dyn=%.2fms draw=%.2fms (%s) %s" % [prof.static / 1000.0 / prof_n, prof.dyn / 1000.0 / prof_n, PtDraw.prof_us / 1000.0 / prof_n, plaza.prof_str(prof_n), ex])
			var tg = ""
			for k in PtDraw.prof_tag: tg += "%s=%.2f " % [k, PtDraw.prof_tag[k] / 1000.0 / prof_n]
			print("[village draw] ", tg); PtDraw.prof_tag.clear()
			prof.clear(); prof_n = 0; PtDraw.prof_us = 0; PtDraw.prof_n = 0; plaza.prof_reset()

func _draw() -> void: pass

func view_rect() -> Rect2:
	return Rect2(0, cam_y, W, size.y / sc)

# ---------------- 靜態物件：原生 Art 畫，狀態冇變唔重畫 ----------------
func _static(key: String, y: float, sig, animated: bool, fn: Callable) -> void:
	var s = statics.get(key)
	if s == null:
		var n = PtDraw.new(); n.tag = "st_" + key.substr(0, 2); n.position = Vector2(0, y); ysort.add_child(n)
		s = {"node": n, "sig": null, "fn": fn}; statics[key] = s
		n.fn = func(c): _draw_static(c, key)
	s.fn = fn; s.used = true
	var n2: PtDraw = s.node
	if n2.position.y != y: n2.position.y = y
	if animated and (y < cam_y - 40 or y > cam_y + size.y / maxf(0.01, sc) + 140):
		s.dirty = true; return  # 鏡頭外動畫唔重畫
	if animated or s.sig != sig or s.get("dirty", false):
		s.sig = sig; s.dirty = false
		n2.queue_redraw()

func _draw_static(c: CanvasItem, key: String) -> void:
	var s = statics[key]
	var ctx = Ctx.new(c, Transform2D(0, Vector2(0, -c.position.y)))
	s.fn.call(ctx)

func _sync_statics() -> void:
	var S = J.G.S
	for k in statics: statics[k].used = false
	var POS = J.G.get("POS")
	var gp = POS.gate
	var gdot = J.t(J.mc(J.G.get("Guide"), "anyDot", [])) if J.G.get("Guide") != null else false
	_static("gate", gp[1], gdot, gdot, func(ctx):
		Art.draw_gate(ctx, gp[0], gp[1], t)
		if gdot:
			var bw = 124.0; var im = Spr.get_tex("gate"); var h = bw * im.get_height() / im.get_width()
			var rx = gp[0] - bw / 2; var ry = gp[1] + 6 - h
			var r = 7 + sin(t * 5) * 1.2
			ctx.fillStyle = "#e8303a"; ctx.strokeStyle = "#fff3e0"; ctx.lineWidth = 2; ctx.beginPath(); ctx.arc(rx + bw * 0.78, ry + h * 0.52, r, 0, 7); ctx.fill(); ctx.stroke())
	var bunl = J.G.get("bldUnlocked"); var BUILDINGS = J.G.get("BUILDINGS")
	for id in J.G.get("BLD_ORDER"):
		var p = POS[id]; var lv = S.bld.get(id, 0)
		if J.t(lv):
			var extra = J.t(J.cl(J.G.get("furnaceReady"), null, [])) if id == "furnace" else false
			var idd = id
			_static("b_" + id, p[1], [lv, extra], id == "furnace" and extra, func(ctx):
				Art.draw_building(ctx, idd, p[0], p[1], lv, t, false)
				if idd == "furnace" and extra: _furnace_glow(ctx.ci, p[0], p[1]))
		elif J.t(J.cl(bunl, null, [id])):
			var nm = J.str(BUILDINGS[id].name)
			_static("b_" + id, p[1], "site", false, func(ctx): Art.draw_site(ctx, p[0], p[1], nm))
	# 原生新增：任務公告板（撳落去開任務面板）、投胎辦事處
	for e in EXTRA:
		var ek: String = e[0]; var ex: float = e[1]; var ey: float = e[2]; var ew: float = e[3]
		_static("x_" + ek, ey, QX.has_new() if ek == "vil_board" else 0, true, func(ctx): _extra(ctx, ek, ex, ey, ew))
	var i = 0
	for d in J.G.get("DECOR"):
		var kind = J.str(d[0]); var dx = J.num(d[1]); var dy = J.num(d[2])
		if _decor_hidden(dx, dy): i += 1; continue
		var anim = kind in ["banana", "scarecrow", "post", "willo", "offer"]
		_static("d_%d" % i, dy, 0, anim, func(ctx): _decor(ctx, kind, dx, dy))
		i += 1
	var H = V.hero; var act = H.get("act")
	i = 0
	for p in J.G.get("TREE_POS"):
		var hp = int(J.num(S.trees[i]))
		var shake = false
		if act is Dictionary and act.get("kind") == "tree" and int(J.num(act.get("i", -1))) == i and J.num(act.get("shake", 0)) > 0:
			act.shake = J.num(act.shake) - 1.0 / 60.0; shake = act.shake > 0
		var ii = i
		_static("t_%d" % i, p[1], [hp, shake], shake, func(ctx): Art.draw_tree(ctx, p[0], p[1], hp, t, shake, hp == 3, ii))
		i += 1
	i = 0
	for p in J.G.get("PADDY_POS"):
		var ripe = J.t(S.paddy[i]); var ii2 = i
		_static("p_%d" % i, p[1] - 10, ripe, false, func(ctx): Art.draw_paddy(ctx, p[0], p[1], ripe, t, ii2))
		i += 1
	for k in statics:
		var s = statics[k]
		if not s.used and s.node.visible: s.node.visible = false
		elif s.used and not s.node.visible: s.node.visible = true

# ---------------- 會郁嘅：打工鬼、廣場鬼、阿福 ----------------
func _seg() -> PtDraw:
	var n: PtDraw
	if seg_used < segs.size(): n = segs[seg_used]
	else:
		n = PtDraw.new(); n.tag = "seg"; ysort.add_child(n); segs.append(n)
		n.set_meta("rec", Recorder.new())
		var nn = n
		n.fn = func(c): _draw_seg(c, nn)
	seg_used += 1
	n.visible = true
	return n

func _draw_seg(c: CanvasItem, n: PtDraw) -> void:
	var r: Recorder = n.get_meta("rec")
	r.replay(c, Transform2D(0, Vector2(0, -n.position.y)))

var hero_flip := false
var hero_seg = null
func _sync_dynamic() -> void:
	seg_used = 0
	var tc0 = Time.get_ticks_usec()
	var items = J.mc(V, "collect", [rec_ctx])
	prof["collect"] = prof.get("collect", 0) + Time.get_ticks_usec() - tc0
	if not items is Array: items = []
	plaza.begin_frame()
	for it in items:
		var y = J.num(it.y)
		if it.get("kind") == "plaza" and plaza.try_item(it, y): continue
		var n = _seg(); n.position = Vector2(0, y)
		if it.get("kind") == "hero":
			# 主角 JS 繪製較貴：隔幀重錄（30fps 動作），另一幀重用上幀錄像
			hero_flip = not hero_flip
			if hero_flip and n == hero_seg and n.has_meta("hy"):
				n.position = Vector2(0, n.get_meta("hy")); n.visible = true
				continue
			hero_seg = n; n.set_meta("hy", y)
		var r: Recorder = n.get_meta("rec"); r.clear()
		rec_ctx.ci = r; rec_ctx.T = Transform2D.IDENTITY; rec_ctx.base = Transform2D.IDENTITY; rec_ctx.globalAlpha = 1.0
		var ti0 = Time.get_ticks_usec()
		J.cl(it.f, null, [])
		var kk = "js_" + J.str(it.get("kind", "?"))
		prof[kk] = prof.get(kk, 0) + Time.get_ticks_usec() - ti0
		n.queue_redraw()
	plaza.end_frame()
	for i in range(seg_used, segs.size()):
		if segs[i].visible: segs[i].visible = false

# ---------------- 地面、彼岸花、霧 ----------------
func _draw_ground(c: CanvasItem) -> void:
	if ground_tex == null:
		if ground_rec == null:
			var gl = J.cl(J.G.get("groundLayer"), null, [])
			if gl is El and gl.rec != null:
				ground_rec = gl.rec
				if Baker.host == null: Baker.host = self
				Baker._bake(ground_rec)
		if ground_rec != null and ground_rec.baked != null: ground_tex = ground_rec.baked
	if ground_tex != null: c.draw_texture_rect(ground_tex, Rect2(0, 0, W, WH), false)
	elif ground_rec != null: ground_rec.replay(c, Transform2D(Vector2(0.5, 0), Vector2(0, 0.5), Vector2.ZERO))

func _draw_lily(c: CanvasItem) -> void:
	var ctx = Ctx.new(c)
	for i in 9:
		var fx = fmod(i * 47 + 20, W); var fy = 24 + fmod(i * 31, 112)
		if fy > cam_y - 20 and fy < cam_y + size.y / sc + 20: Art.draw_lily(ctx, fx, fy, t + i)

func _draw_mist(c: CanvasItem) -> void:
	PtGfx.init()
	for i in 6:
		var mx = fmod(t * 8 + i * 90, W + 200) - 100; var my = 160 + i * 170
		if my < cam_y - 100 or my > cam_y + size.y / sc + 100: continue
		c.draw_texture_rect(PtGfx.RAD, Rect2(mx - 90, my - 90, 180, 180), false, Color(200 / 255.0, 210 / 255.0, 200 / 255.0, 0.06))

# ---------------- 烏鴉、羽毛、碎片 ----------------
const PART_IMG := {"spark": "fx_spark", "chip": "fx_chips", "dust": "fx_dust", "dough": "fx_dough", "grain": "fx_dough"}
func _draw_top_fx(c: CanvasItem) -> void:
	var ctx = Ctx.new(c)
	for f in V.get("feathers", []):
		var ft = J.num(f.t); var life = J.num(f.life)
		ctx.save(); ctx.globalAlpha = maxf(0, 1 - ft / life); ctx.translate(J.num(f.x), J.num(f.y)); ctx.rotate(sin(J.num(f.rot)) * 0.8)
		Art.el(ctx, 0, 0, 1.4, 4, "#14111a", "#5a5068", 0.5); ctx.restore()
	for p in V.get("parts", []) if V.get("parts") is Array else []:
		var fr = J.num(p.t) / J.num(p.life); var k = J.str(p.k)
		c.draw_set_transform(Vector2(J.num(p.x), J.num(p.y)), J.num(p.r), Vector2.ONE)
		var a = maxf(0, 1 - fr * fr)
		if k == "grain": c.draw_rect(Rect2(-1.5, -3, 3, 6), Color("#e9cf7a", a))
		else:
			var im = Spr.get_tex(PART_IMG.get(k, "")) if Spr.ok(PART_IMG.get(k, "")) else null
			if im:
				var s = J.num(p.s) * (1 + fr * 0.8 if k == "spark" else (1 + fr * 1.5 if k == "dust" else 1.0))
				var w = im.get_width() * s; var h = im.get_height() * s
				c.draw_texture_rect(im, Rect2(-w / 2, -h / 2, w, h), false, Color(1, 1, 1, a))
	c.draw_set_transform_matrix(Transform2D.IDENTITY)
	for cr in V.get("crows", []):
		var ga = minf(1, (J.num(cr.life) - J.num(cr.t)) / 0.6)
		ctx.save(); ctx.globalAlpha = ga; Art.draw_crow(ctx, J.num(cr.x), J.num(cr.y), J.num(cr.s), J.num(cr.ph), J.num(cr.vx), false); ctx.restore()

# ---------------- 泡泡、任務箭頭、浮字 ----------------
func _draw_top_ui(c: CanvasItem) -> void:
	var fnt = UIKit.font("sans", 600); var fb = UIKit.font("sans", 900)
	var b = V.get("bubble")
	if b is Dictionary:
		var v = null
		for o in V.get("vis", []):
			if (J.t(b.get("hero")) and J.t(o.get("hero"))) or (not J.t(b.get("hero")) and not J.t(o.get("hero")) and o.g is Dictionary and o.g.get("id") == b.get("id")): v = o; break
		if v != null: _bubble(c, fnt, J.str(b.text), J.num(b.t), J.num(v.x), J.num(v.y))
	_pointer(c)
	for f in V.get("floats", []):
		var ft = J.num(f.t); var a = maxf(0, 1 - ft / J.num(f.life)); var txt = J.str(f.text)
		var sw = fb.get_string_size(txt, HORIZONTAL_ALIGNMENT_LEFT, -1, 14).x
		var p = Vector2(J.num(f.x) - sw / 2, J.num(f.y) - ft * 26)
		c.draw_string_outline(fb, p, txt, HORIZONTAL_ALIGNMENT_LEFT, -1, 14, 4, Color(10 / 255.0, 6 / 255.0, 20 / 255.0, 0.9 * a))
		c.draw_string(fb, p, txt, HORIZONTAL_ALIGNMENT_LEFT, -1, 14, Color(J.str(f.col), a) if Color.html_is_valid(J.str(f.col)) else Color(1, 1, 1, a))

func _bubble(c: CanvasItem, fnt: Font, text: String, bt: float, vx: float, vy: float) -> void:
	var a = clampf(minf(minf(1, bt * 5), (4.6 - bt) * 3), 0, 1)
	var fs = 12.5; var maxw = 168.0; var lines = []; var cur = ""
	for ch in text:
		if fnt.get_string_size(cur + ch, HORIZONTAL_ALIGNMENT_LEFT, -1, int(fs)).x > maxw: lines.append(cur); cur = ch
		else: cur += ch
	if cur != "": lines.append(cur)
	var w = 0.0
	for l in lines: w = maxf(w, fnt.get_string_size(l, HORIZONTAL_ALIGNMENT_LEFT, -1, int(fs)).x)
	w += 16; var h = lines.size() * 17 + 10
	var bx = clampf(vx - w / 2, 6, W - w - 6); var by = vy - 62 - h
	var paper = Color("#ecd9a4", a); var line = Color("#5a4030", a)
	var sb = StyleBoxFlat.new(); sb.bg_color = paper; sb.border_color = line; sb.set_border_width_all(1); sb.set_corner_radius_all(4); sb.anti_aliasing = true
	c.draw_style_box(sb, Rect2(bx, by, w, h))
	c.draw_colored_polygon(PackedVector2Array([Vector2(vx - 5, by + h - 1), Vector2(vx + 5, by + h - 1), Vector2(vx, by + h + 7)]), paper)
	c.draw_polyline(PackedVector2Array([Vector2(vx - 5, by + h), Vector2(vx, by + h + 7), Vector2(vx + 5, by + h)]), line, 1.2, true)
	for i in lines.size(): c.draw_string(fnt, Vector2(bx + 8, by + 6 + i * 17 + fs), lines[i], HORIZONTAL_ALIGNMENT_LEFT, -1, int(fs), Color("#2b1d12", a))

func _pointer(c: CanvasItem) -> void:
	var UI = J.G.get("UI")
	if UI == null or J.str(UI.get("tab")) != "village": return
	var p = J.mc(V, "questTarget", [])
	if not p is Array: return
	var POS = J.G.get("POS")
	var x = J.num(p[0]); var y = J.num(p[1])
	var is_house = J.num(POS.house[0]) == x and J.num(POS.house[1]) == y
	var ty = y - (128.0 if is_house else 78.0) + sin(t * 5) * 5
	var vh = size.y / sc; var top = cam_y + 8; var bot = cam_y + vh - 12; var rot = 0.0
	if ty < top: ty = top + 14; rot = PI
	elif ty > bot: ty = bot - 14
	c.draw_set_transform(Vector2(x, ty), rot, Vector2.ONE)
	var pts = PackedVector2Array([Vector2(-9, -14), Vector2(9, -14), Vector2(9, -2), Vector2(15, -2), Vector2(0, 12), Vector2(-15, -2), Vector2(-9, -2)])
	c.draw_colored_polygon(pts, Color("#ffd84a"))
	var cl = pts.duplicate(); cl.append(pts[0]); c.draw_polyline(cl, Color("#3a2400"), 2, true)
	c.draw_set_transform_matrix(Transform2D.IDENTITY)

# 俾 PtChar 用嘅「巡邏」替身（村子冇血條、冇光暈）
class NvStub extends RefCounted:
	var t := 0.0
	func fx_tex(n: String) -> Texture2D: return PtGfx.tex(n)
	func draw_over(_n, _u, _o) -> void: pass

# ---------------- 會郁嘅擺設（快速版：漸變用放射貼圖，唔用 Ctx 漸變）----------------
func _put(c: CanvasItem, key: String, X: Transform2D, x: float, y: float, w: float, h: float) -> void:
	var im = Spr.get_tex(key)
	if im == null: return
	if h == 0.0: h = w * im.get_height() / im.get_width()
	if w == 0.0: w = h * im.get_width() / im.get_height()
	c.draw_set_transform_matrix(X); c.draw_texture_rect(im, Rect2(x - w / 2, y - h, w, h), false); c.draw_set_transform_matrix(Transform2D.IDENTITY)

func _glow(c: CanvasItem, X: Transform2D, x: float, y: float, r: float, col: Color) -> void:
	PtGfx.init(); c.draw_set_transform_matrix(X); c.draw_texture_rect(PtGfx.RAD, Rect2(x - r, y - r, r * 2, r * 2), false, col); c.draw_set_transform_matrix(Transform2D.IDENTITY)

func _decor(ctx: Ctx, kind: String, x: float, y: float) -> void:
	var c = ctx.ci; var B = ctx.base
	match kind:
		"banana":
			if Spr.ok("banana"): _put(c, "banana", B * Transform2D(sin(t * 0.8 + x) * 0.02, Vector2(x, y)), 0, 2, 0, 64); return
		"scarecrow":
			if Spr.ok("scarecrow"): _put(c, "scarecrow", B * Transform2D(sin(t * 0.9) * 0.03, Vector2(x, y)), 0, 4, 0, 62); return
		"post":
			if Spr.ok("lamppost"):
				_put(c, "lamppost", B, x, y + 3, 0, 46)
				_glow(c, B, x + 6, y - 30, 18, Color(1, 236 / 255.0, 190 / 255.0, 0.22 + sin(t * 2 + x) * 0.06)); return
		"willo":
			var fy = y + sin(t * 1.6 + x) * 5; var a = 0.5 + sin(t * 3 + x) * 0.25
			_glow(c, B, x, fy, 14, Color(140 / 255.0, 220 / 255.0, 1, a))
			ctx.beginPath(); ctx.moveTo(x - 3, fy + 2); ctx.quadraticCurveTo(x - 3, fy - 5, x + sin(t * 5) * 1.5, fy - 9); ctx.quadraticCurveTo(x + 3, fy - 5, x + 3, fy + 2); ctx.arc(x, fy + 2, 3, 0, PI)
			ctx.fillStyle = Color(190 / 255.0, 240 / 255.0, 1, a + 0.2); ctx.fill(); return
	Art.draw_decor(ctx, kind, x, y, t)

const EXTRA := [["vil_board", 56.0, 268.0, 74.0], ["vil_rebirth", 62.0, 1116.0, 84.0]]
func _decor_hidden(x: float, y: float) -> bool:
	return absf(x - 20) < 1 and absf(y - 1060) < 1   # 投胎辦事處位置原本有棵蕉樹

func _extra(ctx: Ctx, k: String, x: float, y: float, w: float) -> void:
	var c = ctx.ci; var B = ctx.base; var im = PtGfx.tex(k)
	if im == null: return
	var h = w * im.get_height() / im.get_width()
	c.draw_set_transform_matrix(B); c.draw_texture_rect(im, Rect2(x - w / 2, y - h, w, h), false)
	if k == "vil_board":
		_glow(c, B, x + w * 0.36, y - h * 0.62, 16, Color(1, 0.5, 0.3, 0.3 + sin(t * 2.3) * 0.08))
		if QX.has_new():
			var r = 6 + sin(t * 5) * 1.2
			c.draw_set_transform_matrix(B); c.draw_circle(Vector2(x + w * 0.42, y - h * 0.95), r, Color("#e8303a")); c.draw_arc(Vector2(x + w * 0.42, y - h * 0.95), r, 0, TAU, 20, Color("#fff3e0"), 1.5)
	else:
		_glow(c, B, x + 2, y - h * 0.98, 26, Color(0.85, 0.95, 1, 0.22 + sin(t * 1.4) * 0.06))
	c.draw_set_transform_matrix(Transform2D.IDENTITY)

func extra_hit(p: Vector2) -> String:
	var wp = Vector2(p.x / sc, p.y / sc + cam_y)
	for e in EXTRA:
		var im = PtGfx.tex(e[0]); if im == null: continue
		var w: float = e[3]; var h = w * im.get_height() / im.get_width()
		if Rect2(e[1] - w / 2, e[2] - h, w, h).has_point(wp): return e[0]
	return ""

func _gui_input(ev: InputEvent) -> void:
	if ev is InputEventMouseButton and ev.button_index == MOUSE_BUTTON_LEFT:
		if ev.pressed: _down_p = ev.position
		elif ev.position.distance_to(_down_p) < 10:
			var hit = extra_hit(ev.position)
			if hit == "vil_board": QX.open("main"); Snd.play("paper"); accept_event(); return
			if hit == "vil_rebirth":
				var zh = DB.lang != "yue"
				var lines = [["投胎辦事處：今日輪候人數「好多」。請先拎籌。", "投胎辦事處：今日輪候人數「很多」。請先取號。"], ["投胎辦事處：第二志願「做貓」已經額滿。", "投胎辦事處：第二志願「做貓」已經額滿。"], ["投胎辦事處：在職員工唔可以投胎，請先辭職。", "投胎辦事處：在職員工不能投胎，請先辭職。"], ["投胎辦事處：午飯時間，請兩小時後再嚟。而家係凌晨三點。", "投胎辦事處：午飯時間，請兩小時後再來。現在是凌晨三點。"]]
				var l = lines[randi() % lines.size()]
				J.mc(J.G.get("Fx"), "toast", [l[1] if zh else l[0]]); Snd.play("paper"); accept_event(); return
	super._gui_input(ev)
var _down_p := Vector2.ZERO

func _furnace_glow(c: CanvasItem, x: float, y: float) -> void:
	var im = Spr.get_tex("furnace")
	if im == null: return
	var w = 62.0; var h = w * im.get_height() / im.get_width()
	var fx = x; var fy = y + 6 - h + h * 0.62
	_glow(c, Transform2D(0, Vector2(0, -y)), fx, fy, 30, Color(1, 170 / 255.0, 60 / 255.0, 0.35 + sin(t * 7) * 0.12))
