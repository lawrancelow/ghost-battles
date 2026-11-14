# 美術（移植 art.js ＋ scene.js 嘅蠟筆畫覆蓋版）：建築、樹、稻田、擺設、烏鴉、角色
extends Node

const OUT := "#1a1426"
const TAU := PI * 2
const SERIF := "\"Songti TC\",\"Noto Serif CJK TC\",serif"
const SOLID := {"npc_it": 1, "npc_mis": 1, "npc_ken": 1, "npc_boss": 1, "npc_guard": 1, "npc_auntie": 1, "laojiang": 1, "zombie": 1, "pocong": 1, "xiaozhi": 1, "zhiren": 1, "penanggal": 1}
const HOP := {"laojiang": 1, "zombie": 1, "pocong": 1}
const CHAR_H := {"npc_it": 60, "npc_mis": 62, "npc_ken": 64, "npc_boss": 64, "npc_guard": 64, "npc_auntie": 60, "afu": 58, "xiaozhi": 54, "egui": 54, "eguiking": 66, "xiaogui": 46, "toyol": 46, "laojiang": 58, "zombie": 54, "shuigui": 56, "pontianak": 60, "pocong": 54, "penanggal": 52, "mengpo": 56, "youhun": 46, "baiwu": 76, "heiwu": 76, "niutou": 64, "mamian": 64, "huang": 62, "zhiren": 54, "tianhua": 60}
const SPECIAL_T := {"penanggal": 1, "pocong": 1, "toyol": 1}

# ---------------- 基本形狀 ----------------
func el(ctx: Ctx, x: float, y: float, rx: float, ry: float, fill = null, stroke = null, lw = null) -> void:
	ctx.beginPath(); ctx.ellipse(x, y, maxf(0.1, rx), maxf(0.1, ry), 0, 0, TAU)
	if fill != null: ctx.fillStyle = fill; ctx.fill()
	if stroke != null: ctx.lineWidth = lw if lw != null else 1.5; ctx.strokeStyle = stroke; ctx.stroke()

func rr(ctx: Ctx, x: float, y: float, w: float, h: float, r: float, fill = null, stroke = null, lw = null) -> void:
	ctx.beginPath(); ctx.roundRect(x, y, w, h, r)
	if fill != null: ctx.fillStyle = fill; ctx.fill()
	if stroke != null: ctx.lineWidth = lw if lw != null else 1.5; ctx.strokeStyle = stroke; ctx.stroke()

func poly(ctx: Ctx, pts: Array, fill = null, stroke = null, lw = null) -> void:
	ctx.beginPath(); ctx.moveTo(pts[0], pts[1])
	for i in range(2, pts.size(), 2): ctx.lineTo(pts[i], pts[i + 1])
	ctx.closePath()
	if fill != null: ctx.fillStyle = fill; ctx.fill()
	if stroke != null: ctx.lineWidth = lw if lw != null else 1.5; ctx.strokeStyle = stroke; ctx.stroke()

func shadow(ctx: Ctx, x: float, y: float, s: float) -> void:
	el(ctx, x, y, 14 * s, 4 * s, "rgba(0,0,0,.35)")

# ---------------- scene.js：以底邊中心畫一張圖 ----------------
func put(ctx: Ctx, key: String, x: float, y: float, w: float, h := 0.0) -> Rect2:
	var im = Spr.get_tex(key)
	if im == null: return Rect2()
	if h == 0.0: h = w * im.get_height() / im.get_width()
	if w == 0.0: w = h * im.get_width() / im.get_height()
	ctx.drawImage(im, x - w / 2, y - h, w, h)
	return Rect2(x - w / 2, y - h, w, h)

const BW := {"house": 150, "gate": 124, "plank": 106, "bun": 106, "wood": 108, "rice": 108, "store": 112, "home": 104, "camp": 108, "altar": 104, "furnace": 62}
const PLAQUE := {"house": [0.47, 0.49, 0.24], "gate": [0.50, 0.36, 0.30], "plank": [0.44, 0.36, 0.32], "store": [0.48, 0.43, 0.33], "wood": [0.40, 0.36, 0.26]}

func lv_badge(ctx: Ctx, x: float, y: float, lv) -> void:
	ctx.save(); ctx.translate(x, y); ctx.rotate(0.12)
	rr(ctx, -1, -8, 22, 16, 2, "#c2362b", "#f0c8b4", 1)
	ctx.fillStyle = "#fff3e0"; ctx.font = "900 10px sans-serif"; ctx.textAlign = "center"; ctx.textBaseline = "middle"; ctx.fillText(str(lv), 10, 0.5); ctx.restore()

func plaque_text(ctx: Ctx, r: Rect2, p: Array, text: String, lv) -> void:
	var cx: float = r.position.x + r.size.x * p[0]; var cy: float = r.position.y + r.size.y * p[1]; var pw: float = r.size.x * p[2]
	var fs = clampf(pw / (text.length() * 1.08), 7, 15)
	ctx.save(); ctx.font = "900 %spx %s" % [fs, SERIF]; ctx.textAlign = "center"; ctx.textBaseline = "middle"
	ctx.lineWidth = maxf(2, fs * 0.28); ctx.strokeStyle = "rgba(40,20,8,.95)"; ctx.lineJoin = "round"
	ctx.strokeText(text, cx, cy + 0.5); ctx.fillStyle = "#f6d58a"; ctx.fillText(text, cx, cy + 0.5); ctx.restore()
	if lv: lv_badge(ctx, cx + pw / 2 - 2, cy - 9, lv)

func sign_board(ctx: Ctx, x: float, y: float, text: String, lv) -> void:
	ctx.save(); ctx.font = "900 11.5px " + SERIF; var w: float = ctx.measureText(text).width + 14
	rr(ctx, x - 1.5, y - 6, 3, 10, 1, "#4a3020")
	rr(ctx, x - w / 2, y - 21, w, 16, 2, "#7a5634", "#2a1a0e", 1.4)
	ctx.fillStyle = "rgba(255,230,180,.15)"; ctx.fillRect(x - w / 2 + 2, y - 19, w - 4, 2)
	ctx.fillStyle = "#f6e2b0"; ctx.textAlign = "center"; ctx.textBaseline = "middle"; ctx.fillText(text, x, y - 12.5); ctx.restore()
	if lv: lv_badge(ctx, x + w / 2 - 1, y - 23, lv)

func draw_building(ctx: Ctx, id: String, x: float, y: float, lv, t: float, extra = null) -> void:
	el(ctx, x, y + 1, BW[id] * 0.44, 7, "rgba(0,0,0,.28)")
	var r = put(ctx, id, x, y + 6, BW[id])
	var bname: String = DB.D.BUILDINGS[id].name
	if PLAQUE.has(id): plaque_text(ctx, r, PLAQUE[id], bname, lv)
	else: sign_board(ctx, x + (0.0 if id == "furnace" else BW[id] * 0.30), y + 12, bname, lv)
	if id == "furnace" and extra:
		var fx = r.position.x + r.size.x * 0.5; var fy = r.position.y + r.size.y * 0.62; var a = 0.35 + sin(t * 7) * 0.12
		var g = ctx.createRadialGradient(fx, fy, 2, fx, fy, 30); g.addColorStop(0, "rgba(255,170,60,%s)" % a); g.addColorStop(1, "rgba(255,170,60,0)")
		ctx.fillStyle = g; ctx.fillRect(fx - 30, fy - 30, 60, 60)

func draw_gate(ctx: Ctx, x: float, y: float, _t: float) -> void:
	var r = put(ctx, "gate", x, y + 6, BW.gate); plaque_text(ctx, r, PLAQUE.gate, "出村", 0)

func draw_site(ctx: Ctx, x: float, y: float, name: String) -> void:
	ctx.save(); ctx.font = "700 12px \"PingFang TC\",\"Noto Sans TC\",sans-serif"; var w = maxf(64, ctx.measureText(name).width + 22)
	el(ctx, x, y - 2, w * 0.7, 9, "rgba(60,48,36,.45)")
	ctx.setLineDash([3, 4]); ctx.strokeStyle = "rgba(236,217,164,.35)"; ctx.lineWidth = 1.2; ctx.beginPath(); ctx.ellipse(x, y - 2, w * 0.7, 11, 0, 0, TAU); ctx.stroke(); ctx.setLineDash([])
	rr(ctx, x - 1.5, y - 30, 3, 28, 1, "#5a4030")
	rr(ctx, x - w / 2, y - 44, w, 20, 2, "#ecd9a4", "#5a4030", 1.5)
	ctx.fillStyle = "#2b1d12"; ctx.textAlign = "center"; ctx.textBaseline = "middle"; ctx.fillText(name, x, y - 33.5)
	ctx.fillStyle = "#c2362b"; ctx.font = "900 10px sans-serif"; ctx.fillText("待建", x, y - 14)
	ctx.restore()

const PERCH := [[-0.22, 0.40, 1], [0.24, 0.30, -1]]
func draw_tree(ctx: Ctx, x: float, y: float, hp: int, t: float, shake: bool, perched: bool, idx: int) -> void:
	if hp <= 0: put(ctx, "stump", x, y + 3, 38); return
	var sx = sin(t * 60) * 2.2 if shake else 0.0; var H = 80.0 + (idx % 3) * 4
	el(ctx, x, y + 2, 20, 5, "rgba(0,0,0,.35)")
	ctx.save()
	if shake: ctx.translate(x, y); ctx.rotate(sin(t * 60) * 0.02); ctx.translate(-x, -y)
	var key = "tree_bare" if Spr.ok("tree_bare") else "tree"; var flip = idx % 2 == 1
	if flip: ctx.translate(x, 0); ctx.scale(-1, 1); ctx.translate(-x, 0)
	var r = put(ctx, key, x + sx, y + 4, 0, H)
	ctx.restore()
	if key == "tree_bare" and perched and Spr.ok("crowsit"):
		for p in PERCH:
			var cx: float = x + r.size.x * p[0] * (-1 if flip else 1) + sx; var cy: float = r.position.y + r.size.y * p[1]
			ctx.save(); ctx.translate(cx, cy); ctx.scale(p[2] * (-1 if flip else 1), 1); put(ctx, "crowsit", 0, 0, 13); ctx.restore()

func draw_paddy(ctx: Ctx, x: float, y: float, ripe, _t: float, _i: int) -> void:
	if ripe: put(ctx, "paddy", x, y + 9, 56); return
	if Spr.ok("paddy_cut"): put(ctx, "paddy_cut", x, y + 9, 56); return
	ctx.save(); ctx.globalAlpha = 0.55; ctx.filter = "brightness(.55) saturate(.4)"; put(ctx, "paddy", x, y + 9, 56, 34); ctx.restore()

func draw_web(ctx: Ctx, cx: float, cy: float, r: float, a0: float, a1: float, alpha := 0.38) -> void:
	ctx.save(); ctx.strokeStyle = "rgba(225,225,235,%s)" % alpha; ctx.lineWidth = 0.6
	var n = 7
	for k in range(n + 1):
		var a = a0 + (a1 - a0) * k / n; ctx.beginPath(); ctx.moveTo(cx, cy); ctx.lineTo(cx + cos(a) * r, cy + sin(a) * r); ctx.stroke()
	for ring in range(1, 6):
		var rr2 = r * ring / 5.4; ctx.beginPath()
		for k in range(n + 1):
			var a = a0 + (a1 - a0) * k / n; var sag = 0.88 if k % 2 else 1.0
			var px = cx + cos(a) * rr2 * sag; var py = cy + sin(a) * rr2 * sag
			if k: ctx.lineTo(px, py)
			else: ctx.moveTo(px, py)
		ctx.stroke()
	ctx.restore()

func draw_willo(ctx: Ctx, x: float, y: float, t: float) -> void:
	var fy = y + sin(t * 1.6 + x) * 5; var a = 0.5 + sin(t * 3 + x) * 0.25
	var g = ctx.createRadialGradient(x, fy, 1, x, fy, 14); g.addColorStop(0, "rgba(140,220,255,%s)" % a); g.addColorStop(1, "rgba(140,220,255,0)")
	ctx.fillStyle = g; ctx.fillRect(x - 14, fy - 14, 28, 28)
	ctx.beginPath(); ctx.moveTo(x - 3, fy + 2); ctx.quadraticCurveTo(x - 3, fy - 5, x + sin(t * 5) * 1.5, fy - 9); ctx.quadraticCurveTo(x + 3, fy - 5, x + 3, fy + 2); ctx.arc(x, fy + 2, 3, 0, PI); ctx.fillStyle = "rgba(190,240,255,%s)" % (a + 0.2); ctx.fill()

const DECO := {"scarecrow": ["scarecrow", 0, 62], "grave": ["grave", 26, 0], "post": ["lamppost", 0, 46], "banana": ["banana", 0, 64]}
func draw_decor(ctx: Ctx, kind: String, x: float, y: float, t: float) -> void:
	if DECO.has(kind) and Spr.ok(DECO[kind][0]):
		var d: Array = DECO[kind]
		if kind == "banana": ctx.save(); ctx.translate(x, y); ctx.rotate(sin(t * 0.8 + x) * 0.02); put(ctx, d[0], 0, 2, d[1], d[2]); ctx.restore(); return
		if kind == "scarecrow": ctx.save(); ctx.translate(x, y); ctx.rotate(sin(t * 0.9) * 0.03); put(ctx, d[0], 0, 4, d[1], d[2]); ctx.restore(); return
		put(ctx, d[0], x, y + 3, d[1], d[2])
		if kind == "post":
			var a = 0.22 + sin(t * 2 + x) * 0.06; var g = ctx.createRadialGradient(x + 6, y - 30, 1, x + 6, y - 30, 18)
			g.addColorStop(0, "rgba(255,236,190,%s)" % a); g.addColorStop(1, "rgba(255,236,190,0)"); ctx.fillStyle = g; ctx.fillRect(x - 14, y - 50, 40, 40)
		return
	match kind:
		"willo": draw_willo(ctx, x, y, t)
		"webTL": draw_web(ctx, x, y, 30, 0, PI / 2, 0.32)
		"webTR": draw_web(ctx, x, y, 30, PI / 2, PI, 0.32)
		"offer":
			rr(ctx, x - 9, y - 6, 18, 6, 1, "#7a3a2a", OUT, 1)
			for k in range(-1, 2): rr(ctx, x + k * 4 - 0.6, y - 16, 1.2, 10, 0.5, "#c8a050"); el(ctx, x + k * 4, y - 16, 1.2, 1.2, "#ff8040")
			ctx.strokeStyle = "rgba(220,220,240,.25)"; ctx.lineWidth = 1; ctx.beginPath(); ctx.moveTo(x, y - 17); ctx.quadraticCurveTo(x + 4 + sin(t * 2) * 3, y - 26, x, y - 34); ctx.stroke()

func draw_crow(ctx: Ctx, x: float, y: float, s: float, ph: float, dir: float, perched: bool) -> void:
	var key = "crowsit" if perched else "crowfly"; var im = Spr.get_tex(key)
	if im == null: return
	ctx.save(); ctx.translate(x, y); ctx.scale(-1 if dir < 0 else 1, 1.0 if perched else 0.55 + absf(sin(ph)) * 0.55)
	var w = (12.0 if perched else 20.0) * s; var h = w * im.get_height() / im.get_width(); ctx.drawImage(im, -w / 2, -h / 2, w, h); ctx.restore()

func draw_lily(ctx: Ctx, x: float, y: float, t: float) -> void:
	ctx.strokeStyle = "#3a5a32"; ctx.lineWidth = 1.2; ctx.beginPath(); ctx.moveTo(x, y + 12); ctx.lineTo(x, y + 2); ctx.stroke()
	ctx.strokeStyle = "rgba(214,40,52,.9)"; ctx.lineWidth = 1.5; ctx.lineCap = "round"
	for k in 6:
		var a = k / 6.0 * PI * 2 + sin(t * 0.6) * 0.15; ctx.beginPath(); ctx.moveTo(x, y)
		ctx.quadraticCurveTo(x + cos(a) * 4, y + sin(a) * 4 - 3, x + cos(a) * 7, y + sin(a) * 6 - 4); ctx.stroke()
	ctx.lineCap = "butt"
	ctx.fillStyle = "#ff6060"; ctx.beginPath(); ctx.arc(x, y, 1.6, 0, 6.3); ctx.fill()

# ---------------- 角色 ----------------
const LIMB_POSES := {"idle": 1, "move": 1, "walk": 1, "run": 1, "windup": 1, "strike": 1, "follow": 1, "recover": 1, "chop": 1, "hammer": 1, "proud": 1}

func spr_key(type: String) -> String: return "afu_body" if type == "afu" else type
func has_spr(type: String) -> bool: return char_h(type) > 0 and PtGfx.tex(spr_key(type)) != null
# 原生表冇嘅角色（n30、巡陰新鬼、npc_*）：用 JS ART.CHAR_H 嘅高度
func char_h(type: String) -> float:
	if CHAR_H.has(type): return CHAR_H[type]
	var A = J.G.get("ART")
	if A != null:
		var h = J.gp(A, "CHAR_H")
		if h is Dictionary and h.has(type): return J.num(h[type])
	return 0.0

func draw_char(ctx: Ctx, type: String, x: float, y: float, s: float, o: Dictionary = {}) -> void:
	if not o.has("t"): o.t = 0.0
	if CHAR_H.has(type) and MeshAnim.has(type) and not (SPECIAL_T.has(type) and has_spr(type)) and not o.get("noMesh", false):
		_draw_mesh(ctx, type, x, y, s, o); return
	_draw_plain(ctx, type, x, y, s, o)

func _draw_mesh(ctx: Ctx, type: String, x: float, y: float, s: float, o: Dictionary) -> void:
	var solid = SOLID.has(type); var H: float = CHAR_H[type] * s; var t: float = o.t
	var pose = o.get("pose")
	ctx.save()
	if o.get("alpha") != null: ctx.globalAlpha = float(o.alpha)
	if Limbs.has(type) and (pose == null or LIMB_POSES.has(pose)) and not o.get("hurt", false):
		var walking: bool = o.get("walk", false) or pose == "move" or pose == "walk" or pose == "run"
		var mp: Dictionary = MeshAnim.walk(t) if walking else MeshAnim.idle(t)
		if o.get("shadow", true) != false:
			ctx.save()
			if not solid: ctx.globalAlpha *= 0.55
			shadow(ctx, x, y + 1 * s, s * (1.0 if solid else 0.8)); ctx.restore()
		Limbs.draw(ctx, type, x, y - (0.0 if solid else (3 + sin(t * 2.4) * 2) * s), H, o, not o.get("flip", false), mp)
		ctx.restore(); return
	var pz = MeshAnim.pose_for(type, o)
	var R: Dictionary = MeshAnim.RIG[type]
	if R.get("hop", false) and (o.get("walk", false) or o.get("enemy", false) or pose == "move"): pz.y = float(pz.get("y", 0)) - absf(sin(t * 5)) * 0.09
	if o.get("shadow", true) != false:
		ctx.save()
		if not solid: ctx.globalAlpha *= 0.55
		shadow(ctx, x, y + 1 * s, s * (1.0 if solid else 0.8)); ctx.restore()
	MeshAnim.draw(ctx, type, x, y - (0.0 if solid else (3 + sin(t * 2.4) * 2) * s), H, pz, not o.get("flip", false))
	ctx.restore()

# 冇骨架嘅角色：整張圖做呼吸／走路搖擺（art.js drawSprite），鬼就浮起
const TIE := {"x0": 618, "x1": 946, "y0": 462, "y1": 648, "ow": 953}
func _draw_plain(ctx: Ctx, type: String, x: float, y: float, s: float, o: Dictionary) -> void:
	if not has_spr(type):
		shadow(ctx, x, y + s, s); el(ctx, x, y - 20 * s, 12 * s, 18 * s, "rgba(220,230,240,.8)", OUT, 1.2); return
	var ghost = not SOLID.has(type)
	ctx.save()
	if o.get("alpha") != null: ctx.globalAlpha = float(o.alpha)
	if o.get("shadow", true) != false:
		if ghost: ctx.save(); ctx.globalAlpha *= 0.55; shadow(ctx, x, y + 1 * s, s * 0.8); ctx.restore()
		else: shadow(ctx, x, y + 1 * s, s)
	if o.get("flip", false): ctx.translate(x, 0); ctx.scale(-1, 1); ctx.translate(-x, 0)
	if o.get("rot") != null: ctx.translate(x, y - 15 * s); ctx.rotate(float(o.rot)); ctx.translate(-x, -(y - 15 * s))
	var yy = y if not ghost else y - (3 + sin(float(o.t) * 2.4) * 2) * s
	_draw_sprite(ctx, type, x, yy, s, o)
	ctx.restore()

func _draw_sprite(ctx: Ctx, type: String, x: float, y: float, s: float, o: Dictionary) -> void:
	var key = spr_key(type); var img = PtGfx.tex(key); var iw = img.get_width(); var ih = img.get_height()
	var t: float = o.get("t", 0.0); var H: float = char_h(type) * s; var Wd = H * iw / ih
	var sy = 1 + sin(t * 2.2) * 0.02; var sx = 1 - (sy - 1) * 0.5; var r = 0.0; var dy = 0.0
	if o.get("walk", false): r += sin(t * 9) * 0.07; dy -= absf(sin(t * 9)) * 1.5 * s
	if o.get("work", false): r += sin(t * 12) * 0.12
	if HOP.has(type) and (o.get("walk", false) or o.get("enemy", false)): dy -= absf(sin(t * 5)) * 5 * s
	if o.get("atk", false): sx *= 1.08; sy *= 1.08
	ctx.save(); ctx.translate(x, y + dy); ctx.rotate(r); ctx.scale(sx, sy)
	ctx.drawImage(img, -Wd / 2, -H, Wd, H)
	ctx.restore()

# 頭像（UI 用）：由原圖頂部裁一個正方形
const PCROP := {"baiwu": [0.30, 0.95], "heiwu": [0.30, 0.95], "penanggal": [0.02, 0.85], "eguiking": [0.0, 0.8], "huang": [0.0, 0.8], "niutou": [0.04, 0.82], "mamian": [0.04, 0.82], "afu": [0.0, 0.72], "tree": [0, 1]}
func portrait_region(type: String) -> Array:
	var key = spr_key(type)
	var img = Spr.get_tex(key)
	if img == null: return []
	var iw = float(img.get_width()); var ih = float(img.get_height())
	var c: Array = PCROP.get(type, [0.0, 0.86])
	var S = minf(iw * c[1], ih); var sx = (iw - S) / 2 + (iw * 0.1 if type == "afu" else 0.0); var sy = minf(ih - S, iw * c[0])
	return [img, Rect2(clampf(sx, 0, iw - S), maxf(0, sy), S, S)]
