# 美術（移植 art.js ＋ scene.js 嘅蠟筆畫覆蓋版）：建築、樹、稻田、擺設、烏鴉、角色
extends Node

const OUT := "#1a1426"
const TAU := PI * 2
const SERIF := "\"Songti TC\",\"Noto Serif CJK TC\",serif"
const SOLID := {"npc_it": 1, "npc_mis": 1, "npc_ken": 1, "npc_boss": 1, "npc_guard": 1, "npc_auntie": 1, "laojiang": 1, "zombie": 1, "pocong": 1, "xiaozhi": 1, "zhiren": 1, "penanggal": 1}
const HOP := {"laojiang": 1, "zombie": 1, "pocong": 1}
const CHAR_H := {"npc_it": 60, "npc_mis": 62, "npc_ken": 64, "npc_boss": 64, "npc_guard": 64, "npc_auntie": 60, "afu": 58, "xiaozhi": 54, "egui": 54, "eguiking": 66, "xiaogui": 46, "toyol": 46, "laojiang": 58, "zombie": 54, "shuigui": 56, "pontianak": 60, "pocong": 54, "penanggal": 52, "mengpo": 56, "youhun": 46, "baiwu": 76, "heiwu": 76, "niutou": 64, "mamian": 64, "huang": 62, "zhiren": 54, "tianhua": 60, "npc_kiln": 58, "npc_receipt": 56, "npc_driver": 58, "npc_ferry": 60, "npc_shop": 58, "npc_rubber": 58, "npc_fisher": 58, "npc_dock": 60, "npc_stall": 58, "npc_ticket": 56, "npc_dj": 56, "npc_inn": 58, "npc_granny": 54, "npc_grandpa": 56, "npc_hq": 58, "npc_clerk": 56, "res_granny": 54, "res_guard": 58, "res_helper": 56}
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

# ---------------- 角色（照 art.js drawChar／drawMesh／drawPuppet／drawSprite）----------------
# 角色高度／實體表：JS 嗰邊（native/art.gd 或轉譯版 ART）嘅 CHAR_H／SOLID 會俾 n30_rigs、npc_antag 等模塊加嘢，以佢為準
const LIMB_POSES := {"": 1, "idle": 1, "move": 1, "walk": 1, "run": 1, "windup": 1, "strike": 1, "follow": 1, "recover": 1, "chop": 1, "hammer": 1, "proud": 1}
const MOVE_POSES := {"windup": 1, "strike": 1, "follow": 1, "recover": 1}
const PUPPET_ANIM := {"walk": 1, "run": 1, "startle": 1, "cower": 1, "tremble": 1, "phone": 1, "look": 1, "mop": 1, "faint": 1, "sip": 1, "stand": 1, "hold": 1, "shrug": 1, "windup": 1, "strike": 1, "recover": 1, "hurt": 1, "cast": 1, "die": 1, "chop": 1, "hammer": 1, "knead": 1, "reap": 1, "proud": 1}

func spr_key(type: String) -> String: return "afu_body" if type == "afu" else type
func has_spr(type: String) -> bool: return char_h(type) > 0 and PtGfx.tex(spr_key(type)) != null
func _jart(k: String):
	var A = J.G.get("ART")
	return J.gp(A, k) if A != null else null
func char_h(type: String) -> float:
	var h = _jart("CHAR_H")   # JS 表優先；原生另加嘅（巡陰 npc_kiln 等，JS 冇）用本地表
	if h is Dictionary and h.has(type) and J.t(h[type]): return J.num(h[type])
	return float(CHAR_H.get(type, 0))
func is_solid(type: String) -> bool:
	if SOLID.has(type): return true
	var so = _jart("SOLID")
	return so is Dictionary and J.t(so.get(type))
func _special_has(type: String) -> bool:
	var SP = J.G.get("SPECIAL")
	return SP != null and J.t(J.mc(SP, "has", [type]))
func _ma(): return J.G.get("MeshAnim")
func _ma_has(type: String) -> bool:
	var M = _ma()
	return M != null and J.t(J.mc(M, "has", [type]))
static func _ot(o: Dictionary) -> float: return J.num(o.get("t")) if J.t(o.get("t")) else 0.0
static func _pz(o: Dictionary) -> String: return J.str(o.pose) if o.get("pose") != null else ""

# js = true：照網頁版，有 o.act 就交俾 DAILY（JS ART.drawChar 叫）；原生場景要講明 o._daily
func draw_char(ctx: Ctx, type: String, x: float, y: float, s: float, o: Dictionary = {}, js := false) -> void:
	o["t"] = _ot(o)
	if char_h(type) > 0 and _ma_has(type) and not _special_has(type) and not J.t(o.get("noMesh")):
		_draw_mesh(ctx, type, x, y, s, o, js, false); return
	var PU = J.G.get("Puppet")
	if PU != null and J.t(J.mc(PU, "has", [type])) and not J.t(o.get("noPuppet")):
		ctx.save()
		if o.get("alpha") != null: ctx.globalAlpha = J.num(o.alpha)
		if J.t(o.get("rot")): ctx.translate(x, y - 15 * s); ctx.rotate(J.num(o.rot)); ctx.translate(-x, -(y - 15 * s))
		_draw_puppet(ctx, type, x, y, s, o); ctx.restore(); return
	_draw_plain(ctx, type, x, y, s, o)

# MOVES 交返 false 之後（BtMoves 叫）：由 custom／Limbs／網格繼續畫，唔再入 MOVES
func draw_char_after_moves(ctx: Ctx, type: String, x: float, y: float, s: float, o: Dictionary) -> void:
	o["t"] = _ot(o)
	if char_h(type) > 0 and _ma_has(type) and not _special_has(type) and not J.t(o.get("noMesh")): _draw_mesh(ctx, type, x, y, s, o, false, true)
	else: draw_char(ctx, type, x, y, s, o)

func _arg(type: String, x: float, y: float, s: float, H: float, o: Dictionary, solid: bool, ctx: Ctx) -> Dictionary:
	var sh = func(_t, a):
		var k = J.arg(a, 1)
		shadow(ctx, J.num(J.arg(a, 0)), y + 1 * s, s * (J.num(k) if J.t(k) else (1.0 if solid else 0.8))); return null
	return {"type": type, "x": x, "y": y, "s": s, "H": H, "o": o, "faceRight": not J.t(o.get("flip")), "solid": solid, "shadow": sh}

func _hand(ctx: Ctx, fn, a: Dictionary, o: Dictionary) -> bool:
	ctx.save()
	if o.get("alpha") != null: ctx.globalAlpha = J.num(o.alpha)
	var done = J.cl(fn, null, [ctx, a])
	ctx.restore()
	return not (done is bool and done == false)

func _draw_mesh(ctx: Ctx, type: String, x: float, y: float, s: float, o: Dictionary, js: bool, skip_moves: bool) -> void:
	var solid = is_solid(type); var H: float = char_h(type) * s; var t: float = o.t
	var pose = _pz(o)
	# 平日動作（DAILY[act]）：回傳 false 先照一般畫法
	var act = o.get("act")
	if J.t(act) and (js or J.t(o.get("_daily"))):
		act = J.str(act)
		if not js and ScDaily.has(act):   # 回陽間辦公室嗰批動作（原生 game/scare/sc_daily.gd）
			ctx.save()
			if o.get("alpha") != null: ctx.globalAlpha = float(o.alpha)
			var ok = ScDaily.draw(ctx, act, {"type": type, "x": x, "y": y, "s": s, "H": H, "o": o, "faceRight": not o.get("flip", false), "solid": solid})
			ctx.restore()
			if ok: return
		else:
			var DA = J.G.get("DAILY")
			if DA is Dictionary and J.t(DA.get(act)) and _hand(ctx, DA[act], _arg(type, x, y, s, H, o, solid, ctx), o): return
	# 專屬招式（MOVES[type]）
	if not skip_moves and MOVE_POSES.has(pose):
		var MV = J.G.get("MOVES")
		if MV is Dictionary and J.t(MV.get(type)) and _hand(ctx, MV[type], _arg(type, x, y, s, H, o, solid, ctx), o): return
	var R = J.gp(J.gp(_ma(), "RIG"), type)
	if R is Dictionary and J.t(R.get("custom")) and _hand(ctx, R.custom, _arg(type, x, y, s, H, o, solid, ctx), o): return
	var A = J.gp(_ma(), "ANIM")
	var fy = y - (0.0 if solid else (3 + sin(t * 2.4) * 2) * s)
	var LB = J.G.get("Limbs")
	if LB != null and J.t(J.mc(LB, "has", [type])) and LIMB_POSES.has(pose) and not J.t(o.get("hurt")):
		var walking = J.t(o.get("walk")) or pose == "move" or pose == "walk" or pose == "run"
		var mp = J.cl(A.walk if walking else A.idle, null, [t])
		ctx.save()
		if o.get("alpha") != null: ctx.globalAlpha = J.num(o.alpha)
		if not (o.get("shadow") is bool and o.shadow == false):
			ctx.save()
			if not solid: ctx.globalAlpha *= 0.55
			shadow(ctx, x, y + 1 * s, s * (1.0 if solid else 0.8)); ctx.restore()
		var tip = J.mc(LB, "draw", [ctx, type, x, fy, H, o, not J.t(o.get("flip")), mp])
		ctx.restore()
		if J.t(o.get("tipOut")): J.sp(o.tipOut, "p", tip)
		return
	var pz = mesh_pose(A, type, o)
	if R is Dictionary and J.t(R.get("tweak")): J.cl(R.tweak, null, [pz, o])
	if R is Dictionary and J.t(R.get("hop")) and (J.t(o.get("walk")) or J.t(o.get("enemy")) or pose == "move"): pz["y"] = (J.num(pz.y) if J.t(pz.get("y")) else 0.0) - absf(sin(t * 5)) * 0.09
	ctx.save()
	if o.get("alpha") != null: ctx.globalAlpha = J.num(o.alpha)
	if not (o.get("shadow") is bool and o.shadow == false):
		ctx.save()
		if not solid: ctx.globalAlpha *= 0.55
		shadow(ctx, x, y + 1 * s, s * (1.0 if solid else 0.8)); ctx.restore()
	J.mc(_ma(), "draw", [ctx, type, x, fy, H, pz, not J.t(o.get("flip"))])
	ctx.restore()

# art.js meshPose：動作名 → 骨頭姿勢（用 JS 嗰邊嘅 MeshAnim.ANIM）
func mesh_pose(A, type: String, o: Dictionary) -> Dictionary:
	var t: float = o.t; var p = clampf(J.num(o.get("pt")) if J.t(o.get("pt")) else 0.0, 0, 1)
	var f = func(k: String, args: Array): return J.cl(J.gp(A, k), null, args)
	var pose = _pz(o)
	match pose:
		"windup", "strike", "follow", "recover", "cast", "die", "air", "down": return f.call(pose, [p, t, type])
		"faint": return f.call("die", [p, t])
		"hurt": return f.call("hurtP", [p, t])
		"scared", "startle", "tremble", "cower": return f.call("scared", [t])
		"chop", "hammer":
			var q = p if pose == "chop" else fmod(p * 2, 1.0)
			return f.call("windup", [q / 0.72, t, type]) if q < 0.72 else f.call("strike", [(q - 0.72) / 0.28, t, type])
		"reap": return f.call("strike", [absf(sin(p * PI * 3)), t, type])
		"knead":
			var z = f.call("idle", [t]); z["body"] = 0.15 + sin(p * PI * 4) * 0.05; z["y"] = (J.num(z.y) if J.t(z.get("y")) else 0.0) + absf(sin(p * PI * 4)) * 0.02; z["armF"] = 0.3; z["armB"] = -0.3; return z
		"proud":
			var z2 = f.call("idle", [t]); z2["head"] = -0.12; z2["body"] = -0.05; return z2
		"run", "move", "walk": return f.call("walk", [t * (1.8 if pose == "run" else 1.0)])
	if J.t(o.get("hurt")): return f.call("hurtP", [0.3, t])
	if J.t(o.get("atk")): return f.call("strike", [0.6, t, type])
	if J.t(o.get("walk")): return f.call("walk", [t])
	return f.call("idle", [t])

# art.js drawPuppet（木偶分件；PUPPET_ON 關咗時唔會行到）
func _draw_puppet(ctx: Ctx, type: String, x: float, y: float, s: float, o: Dictionary) -> void:
	var PU = J.G.Puppet; var A = J.gp(PU, "ANIMS"); var pose = _pz(o)
	var name = pose if pose != "" and J.t(J.gp(A, pose)) else ("move" if J.t(o.get("walk")) else "idle")
	if not J.t(J.mc(PU, "armed", [type])) and J.t(J.gp(A, name + "C")): name = name + "C"
	if J.t(o.get("hurt")) and J.t(J.gp(A, "hurt")): name = "hurt"
	var R = J.gp(J.gp(PU, "RIGS"), type); var human = R != null and J.t(J.gp(R, "lF"))
	if human and name == "idle": name = "stand"
	if human and name == "move": name = "walk"
	var T1 = {"idle": 1, "move": 1, "walk": 1, "run": 1, "look": 1, "mop": 1, "sip": 1, "stand": 1, "hold": 1}
	var pz = J.cl(J.gp(A, name), null, [o.t] if T1.has(name) else [J.num(o.get("pt")) if J.t(o.get("pt")) else 0.0, o.t])
	if J.t(o.get("face")): pz["hk"] = o.face
	if J.t(o.get("weapon")):
		pz["wpn"] = o.weapon
		if not J.t(pz.get("tool")) and type == "afu": pz["tool"] = "_W"; pz["tr"] = -(J.num(pz.get("aF")) + J.num(pz.get("eF"))) + 0.25
	if J.t(o.get("cloth")): pz["cloth"] = o.cloth
	if J.t(o.get("badge")): pz["badge"] = o.badge
	if not J.t(pz.get("tool")) and type != "afu" and not human and J.t(J.mc(PU, "armed", [type])): pz["tool"] = "_W"; pz["tr"] = -(J.num(pz.get("aF")) + J.num(pz.get("eF"))) + 0.15
	if not PUPPET_ANIM.has(name) and J.t(o.get("atk")): pz["aF"] = 1.6; pz["eF"] = 0.1
	if HOP.has(type) and (name == "idle" or name == "move"):
		pz["aF"] = 1.5; pz["eF"] = 0.05; pz["aB"] = 1.4; pz["eB"] = 0.05; pz["lean"] = 0
		if name == "move" or J.t(o.get("enemy")): pz["dy"] = -absf(sin(o.t * 5)) * 7
	var sol = is_solid(type)
	if not (o.get("shadow") is bool and o.shadow == false): shadow(ctx, x, y + 1 * s, s * (1.0 if sol else 0.8))
	J.mc(PU, "draw", [ctx, type, x, y - (0.0 if sol else (3 + sin(o.t * 2.4) * 2) * s), char_h(type) * s * 1.08, pz, not J.t(o.get("flip"))])

# 冇骨架嘅角色：整張圖（drawSprite）或者程序畫法（DRAW）；鬼就浮起，下半身漸隱
const TIE := {"x0": 618, "x1": 946, "y0": 462, "y1": 648, "ow": 953}
var last_fade_raw: Recorder = null   # 對照用：漸隱之前嘅原始指令
func _draw_plain(ctx: Ctx, type: String, x: float, y: float, s: float, o: Dictionary) -> void:
	var spr = has_spr(type)
	var f = func(c: Ctx, xx: float, yy: float) -> void:
		if spr: _draw_sprite(c, type, xx, yy, s, o)
		else: _draw_youhun(c, xx, yy, s, o)
	var ghost = not is_solid(type)
	ctx.save()
	if o.get("alpha") != null: ctx.globalAlpha = J.num(o.alpha)
	if not (o.get("shadow") is bool and o.shadow == false):
		if ghost: ctx.save(); ctx.globalAlpha *= 0.55; shadow(ctx, x, y + 1 * s, s * 0.8); ctx.restore()
		else: shadow(ctx, x, y + 1 * s, s)
	if J.t(o.get("flip")): ctx.translate(x, 0); ctx.scale(-1, 1); ctx.translate(-x, 0)
	if J.t(o.get("rot")): ctx.translate(x, y - 15 * s); ctx.rotate(J.num(o.rot)); ctx.translate(-x, -(y - 15 * s))
	if not ghost: f.call(ctx, x, y); ctx.restore(); return
	# 飄浮：網頁版先畫入暫存畫布再用 destination-out 漸層擦淡下半身；Godot 冇呢種混合 → 錄低再按高度逐點乘透明度（效果一樣）
	var fy = y - (3 + sin(o.t * 2.4) * 2) * s
	var raw = Recorder.new(); var bc = Ctx.new(raw); bc.font = ctx.font
	f.call(bc, x, fy)
	last_fade_raw = raw
	var st = [[0.0, 0.0], [0.6, 0.22], [1.0, 0.55]] if spr else [[0.0, 0.0], [0.55, 0.55], [1.0, 0.92]]
	var faded = fade_rec(raw, fy - 13 * s, fy + 6 * s, fy + 17 * s, st)
	if ctx.ci is Recorder: ctx.ci.rec(faded, ctx.T, ctx.globalAlpha)
	else: faded.replay(ctx.ci, ctx.T, ctx.globalAlpha); ctx.ci.draw_set_transform_matrix(Transform2D.IDENTITY)
	ctx.restore()

# 垂直漸隱遮罩：y∈[g0, r1] 之間按漸層（g0→g1，stops = [位置, 擦走嘅透明度]）乘 (1-a)；之外不變
static func _fade_a(Y: float, g0: float, g1: float, r1: float, st: Array) -> float:
	if Y < g0 or Y > r1: return 1.0
	var p = clampf((Y - g0) / maxf(0.0001, g1 - g0), 0, 1)
	for i in range(1, st.size()):
		if p <= st[i][0]:
			var q = (p - st[i - 1][0]) / maxf(0.0001, st[i][0] - st[i - 1][0])
			return 1.0 - (st[i - 1][1] + (st[i][1] - st[i - 1][1]) * q)
	return 1.0 - st[-1][1]

static func fade_rec(raw: Recorder, g0: float, g1: float, r1: float, st: Array) -> Recorder:
	var out = Recorder.new(); var cur = Transform2D.IDENTITY
	var ys = [g0, r1]
	for e in st: ys.append(g0 + (g1 - g0) * e[0])
	for c in raw.cmds:
		match c[0]:
			0: cur = c[1]; out.cmds.append(c)
			5, 6:
				var tex: Texture2D = c[1]; var r: Rect2 = c[2]; var m: Color = c[4] if c[0] == 6 else c[3]
				var src: Rect2 = c[3] if c[0] == 6 else Rect2(0, 0, tex.get_width(), tex.get_height())
				var tw = float(tex.get_width()); var th = float(tex.get_height())
				# 喺遮罩範圍入面嘅高度切成橫條（每條頂底各自計透明度；漸層分段點都落喺切線上）
				var ylo = minf((cur * r.position).y, (cur * (r.position + r.size)).y); var yhi = maxf((cur * r.position).y, (cur * (r.position + r.size)).y)
				if yhi < g0 or ylo > r1: out.cmds.append(c); continue
				var vs = [0.0, 1.0]
				var n = clampi(int(ceil(absf(yhi - ylo) / 2.0)), 1, 24)
				for i in range(1, n): vs.append(float(i) / n)
				var inv = cur.affine_inverse()
				for Yc in ys:
					var lp = inv * Vector2((cur * r.position).x, Yc)
					var v = (lp.y - r.position.y) / maxf(0.0001, r.size.y)
					if v > 0 and v < 1: vs.append(v)
				vs.sort()
				var pts = PackedVector2Array(); var uvs = PackedVector2Array(); var cols = PackedColorArray(); var idx = PackedInt32Array()
				for v in vs:
					for u in [0.0, 1.0]:
						var lp2 = r.position + Vector2(u * r.size.x, v * r.size.y); var wp = cur * lp2
						pts.append(wp); uvs.append(Vector2((src.position.x + u * src.size.x) / tw, (src.position.y + v * src.size.y) / th))
						var cc = m; cc.a *= _fade_a(wp.y, g0, g1, r1, st); cols.append(cc)
				for i in range(vs.size() - 1):
					var b0 = i * 2
					idx.append_array([b0, b0 + 1, b0 + 3, b0, b0 + 3, b0 + 2])
				out.cmds.append([0, Transform2D.IDENTITY]); out.cmds.append([10, idx, pts, cols, uvs, tex]); out.cmds.append([0, cur])
			10:
				var cols2: PackedColorArray = (c[3] as PackedColorArray).duplicate(); var pts2: PackedVector2Array = c[2]
				for i in cols2.size(): cols2[i].a *= _fade_a((cur * pts2[i]).y, g0, g1, r1, st)
				out.cmds.append([10, c[1], pts2, cols2, c[4], c[5]])
			4:
				var pp: PackedVector2Array = c[1]; var cen = Vector2.ZERO
				for q in pp: cen += q
				cen /= maxf(1, pp.size()); var c4: Color = c[2]; c4.a *= _fade_a((cur * cen).y, g0, g1, r1, st)
				out.cmds.append([4, pp, c4])
			_: out.cmds.append(c)
	return out

func _draw_sprite(ctx: Ctx, type: String, x: float, y: float, s: float, o: Dictionary) -> void:
	if _special_has(type): J.mc(J.G.SPECIAL, "draw", [ctx, type, x, y, s, o]); return
	var key = spr_key(type); var img = PtGfx.tex(key); var iw = float(img.get_width()); var ih = float(img.get_height())
	var t: float = o.t; var H: float = char_h(type) * s; var Wd = H * iw / ih
	var sy = 1 + sin(t * 2.2) * 0.02; var sx = 1 - (sy - 1) * 0.5; var r = 0.0; var dy = 0.0
	if J.t(o.get("walk")): r += sin(t * 9) * 0.07; dy -= absf(sin(t * 9)) * 1.5 * s
	if J.t(o.get("work")): r += sin(t * 12) * 0.12
	if HOP.has(type) and (J.t(o.get("walk")) or J.t(o.get("enemy"))): dy -= absf(sin(t * 5)) * 5 * s
	if J.t(o.get("atk")): sx *= 1.08; sy *= 1.08
	ctx.save(); ctx.translate(x, y + dy); ctx.rotate(r); ctx.scale(sx, sy)
	ctx.drawImage(img, -Wd / 2, -H, Wd, H)
	var tie = PtGfx.tex("afu_tie") if type == "afu" else null
	if tie != null:   # 阿福領帶：分成直條，像在風裡飄
		var tw = float(tie.get_width()); var p = tw / TIE.ow; var kx = Wd / tw; var ky = H / float(tie.get_height())
		var sx0 = TIE.x0 * p; var sx1 = minf(tw, TIE.x1 * p); var sy0 = TIE.y0 * p; var sh = (TIE.y1 - TIE.y0) * p
		var ln = sx1 - sx0; var step = maxf(1, 2 * p); var amp = H * 0.032
		var cx = sx0
		while cx < sx1:
			var d = (cx - sx0) / p; var fr = (cx - sx0) / ln
			var off = sin(t * 6 - d * 0.016) * amp * pow(fr, 1.3) + sin(t * 2.7) * amp * 0.45 * fr
			var w = minf(step, sx1 - cx)
			ctx.drawImage(tie, cx, sy0, w, sh, -Wd / 2 + cx * kx, -H + sy0 * ky + off, w * kx + 0.6, sh * ky)
			cx += step
	ctx.restore()

# DRAW.youhun（冇素材時嘅後備畫法；網頁版 DRAW[type] || DRAW.youhun，其他程序畫法有素材就唔會用到）
func _draw_youhun(ctx: Ctx, x: float, y: float, s: float, o: Dictionary) -> void:
	var t: float = o.t; var hy = y - 26 * s - sin(t * 3) * 2 * s
	ctx.globalAlpha *= 0.88
	var gy = y - sin(t * 3) * 2 * s
	ctx.beginPath(); ctx.moveTo(x - 9 * s, gy - 16 * s)
	ctx.quadraticCurveTo(x - 10 * s, gy - 4 * s, x - 4 * s + sin(t * 4) * 2 * s, gy)
	ctx.quadraticCurveTo(x, gy - 5 * s, x + 4 * s + sin(t * 4 + 1) * 2 * s, gy + 1 * s)
	ctx.quadraticCurveTo(x + 10 * s, gy - 4 * s, x + 9 * s, gy - 16 * s); ctx.closePath()
	ctx.fillStyle = "#dfeaff"; ctx.fill(); ctx.strokeStyle = OUT; ctx.lineWidth = 1.5 * s; ctx.stroke()
	el(ctx, x, hy, 12 * s, 12 * s, "#e9f1ff", OUT, 1.6 * s)
	var dx = 5 * s; var ey = hy + 1 * s + 1 * s
	if J.t(o.get("enemy")):
		el(ctx, x - dx, ey + 0.5 * s, 1.7 * s, 1.9 * s, OUT); el(ctx, x + dx, ey + 0.5 * s, 1.7 * s, 1.9 * s, OUT)
		ctx.strokeStyle = OUT; ctx.lineWidth = 1.5 * s; ctx.beginPath()
		ctx.moveTo(x - dx - 3 * s, ey - 3.5 * s); ctx.lineTo(x - dx + 2.5 * s, ey - 1.8 * s)
		ctx.moveTo(x + dx + 3 * s, ey - 3.5 * s); ctx.lineTo(x + dx - 2.5 * s, ey - 1.8 * s); ctx.stroke()
	else: el(ctx, x - dx, ey, 1.5 * s, 1.8 * s, OUT); el(ctx, x + dx, ey, 1.5 * s, 1.8 * s, OUT)
	ctx.strokeStyle = OUT; ctx.lineWidth = 1.2 * s
	el(ctx, x, hy + 7 * s, 2.2 * s, 1.8 * s, "#5a1020")
	el(ctx, x + 10 * s, hy - 10 * s, 2 * s, 3 * s, "rgba(160,230,255,.8)")

# 頭像（UI 用）：由原圖頂部裁一個正方形
const PCROP := {"baiwu": [0.30, 0.95], "heiwu": [0.30, 0.95], "penanggal": [0.02, 0.85], "eguiking": [0.0, 0.8], "huang": [0.0, 0.8], "niutou": [0.04, 0.82], "mamian": [0.04, 0.82], "afu": [0.0, 0.72], "tree": [0, 1]}
func portrait_region(type: String) -> Array:
	var key = spr_key(type)
	var img = PtGfx.tex(key)
	if img == null: return []
	var iw = float(img.get_width()); var ih = float(img.get_height())
	var c: Array = PCROP.get(type, [0.0, 0.86])
	var S = minf(iw * c[1], ih); var sx = (iw - S) / 2 + (iw * 0.1 if type == "afu" else 0.0); var sy = minf(ih - S, iw * c[0])
	return [img, Rect2(clampf(sx, 0, iw - S), maxf(0, sy), S, S)]
