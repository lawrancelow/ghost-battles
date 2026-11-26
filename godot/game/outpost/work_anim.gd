# [workanim] 名鬼做工動畫（老闆 11-26）：放名鬼入生產鏈建築做工，每種建築有自己嘅動作
#   規矩：角色唔再手揸工具 —— 工具浮喺角色面向嗰邊身旁，動作靠工具本身（揮、刺、轉、搖…）；
#         鬼本身做配合嘅身體擺動（成張原立繪：前傾、後仰、壓扁伸長、左右挪，唔剪分件）。
#   砍樹（chop）：節奏、姿勢曲線直接攞主角砍樹（Limbs.state_of("afu","chop")）嗰條，一下 = F.chopTime() 秒，
#         0–62% 舉斧、62–80% 斬落（撞擊）、80–100% 收勢；同主角逐格同步。
#   工具：有原圖就用原圖（tool_axe／tool_sickle／tool_mallet、bun__steamer、wood__log、stump、mvi_* 貨品圖），
#         冇就程序墨線畫（同 game/equip/eq_art.gd 一樣嘅墨線、偏灰色；24×24 框、揸位＝(0,0)、向上）。
#   座標：畫工具／道具時 ctx 喺「本地框」：原點＝腳底、+x＝面向嗰邊、y 向下；H＝角色高。
#   冇 class_name（熱更新）；const WA = preload("res://game/outpost/work_anim.gd")，全部 static。
#   掛鈎：native/game.gd v_collect（村子派工鬼）、mv_motion.gd（大排檔員工）。ON＝false 就全部照舊。
extends RefCounted

const EV2 = preload("res://game/equip/eq_view2.gd")
const EA = preload("res://game/equip/eq_art.gd")
const DW = preload("res://native/daily_work.gd")
const INK := "#2a1a10"
const TOP := -0.98          # 工具最高（以 H 為 1）：頭頂資訊喺呢條線以上
static var ON := true
static var LAST := {}
# 細道具嘅動作：工具＋工作物以工具位（cx, 腳底）為中心放大（遊戲入面角色細，唔放大睇唔清）
const ZOOM := {"grate": 1.5, "press": 1.5, "stamp": 1.45, "fan": 1.5, "ladle": 1.3, "wok": 1.5, "fold": 1.5, "forge": 1.25, "steam": 1.25,
	"pick": 1.35, "mill": 1.3, "scoop": 1.2, "knead": 1.25, "twist": 1.2, "pound": 1.2, "stir": 1.15, "reap": 1.15, "poke": 1.0}       # 測試：最後一次畫 {k: {"verb", "pts": [Vector2（本地框、以 H 為 1）], "body": {}}}

# ---------------- 建築 → 動作 ----------------
# 村子崗位（舊建築用 post 名，新建築用 bid）
const POST := {
	"wood": "chop", "b_wood": "chop", "rice": "reap", "b_rice": "reap", "plank": "saw", "b_plank": "saw", "bun": "knead", "b_bun": "knead",
	"b_well": "crank", "b_bamboo": "hack", "b_coco": "poke", "b_latex": "score", "b_tea": "pick", "b_straw": "reap", "b_banana": "hack",
	"b_fish": "net", "b_newspaper": "pick", "b_toner": "scoop",
	"b_paper": "dip", "b_strip": "split", "b_cocomilk": "grate", "b_rubbersheet": "press", "b_rope": "twist", "b_pulp": "pound", "b_ink": "stir",
}
# 大排檔各檔（台圖 art → 動作）
const STALL := {
	"mvs_steamer": "steam", "mvs_tailor": "fold", "mvs_well": "ladle", "mvs_mill": "mill", "mvs_kiln": "fan", "mvs_denglong": "fold",
	"mvs_tiaodan": "ladle", "mvs_charcoal": "fan", "mvs_rubber": "press", "mvs_bamboo": "steam", "mvs_durian": "hack", "mvs_ricepot": "ladle",
	"mvs_straw": "twist", "mvs_teahouse": "ladle", "mvs_coffin": "saw", "mvs_huajiao": "fold", "mvs_notice": "stamp", "mvs_ganlu": "fold",
	"mvs_banana": "fold", "mvs_fish": "fan", "mvs_lemon": "stir", "mvs_exchange": "stamp", "mvs_float": "crank", "mvs_pier": "stamp",
	"mvs_delivery": "fold", "mvs_phone": "forge", "mvs_watch": "forge", "mvs_garage": "forge", "mvs_vinegar": "stir", "mvs_cinema": "stamp",
	"mvs_baogu": "wok", "mvs_soup": "ladle", "mvs_copier": "press", "mvs_umbrella": "fold", "mvs_files": "stamp", "mvs_lamp": "fold",
	"mvs_lounge": "saw", "mvs_daka": "stamp", "mvs_house": "fold", "mvs_bingqi": "forge",
}
# 動作 → 用嘅工具（說明／測試用）
const TOOL_OF := {"chop": "斧頭", "hack": "柴刀", "split": "柴刀", "poke": "竹竿", "reap": "鐮刀", "crank": "轆轤搖柄", "score": "膠刀", "net": "罾",
	"pick": "竹籮", "scoop": "長柄勺", "saw": "鋸", "knead": "擀麵棍", "dip": "竹簾", "grate": "刨椰凳", "press": "壓膠轆", "twist": "搓繩車",
	"pound": "打漿杵", "stir": "攪棍", "wok": "鑊鏟＋鐵鑊", "ladle": "大勺", "fold": "紙", "forge": "木槌", "steam": "蒸籠蓋", "stamp": "印仔", "fan": "葵扇", "mill": "石磨推柄"}
const VERBS := ["chop", "hack", "split", "poke", "reap", "crank", "score", "net", "pick", "scoop", "saw", "knead", "dip", "grate", "press", "twist",
	"pound", "stir", "wok", "ladle", "fold", "forge", "steam", "stamp", "fan", "mill"]
# 工作物細節（同一動作唔同建築）
const PIECE := {"b_bamboo": "bamboo", "b_banana": "leaf", "mvs_durian": "durian", "b_tea": "m_tealeaf", "b_newspaper": "m_newspaper",
	"b_straw": "straw", "b_rice": "rice", "rice": "rice"}
# 原圖工具：[圖, 揸位 u, v, 尖 u, v, 鏡像（刀口原本向左 → 翻去向前）]
const SPR_TOOL := {"axe": ["tool_axe", 0.55, 0.95, 0.5, 0.05, true], "sickle": ["tool_sickle", 0.2, 0.95, 0.62, 0.1, false],
	"mallet": ["tool_mallet", 0.5, 0.95, 0.5, 0.05, false]}

static func verb_of_post(post: String) -> String: return str(POST.get(post, ""))
static func verb_of_stall(art: String) -> String: return str(STALL.get(art, ""))

# ---------------- 小工具 ----------------
static func _ez(x: float) -> float: x = clampf(x, 0, 1); return x * x * (3.0 - 2.0 * x)
static func _eo(x: float) -> float: x = clampf(x, 0, 1); return 1.0 - (1.0 - x) * (1.0 - x)
static func _dv(ang: float) -> Vector2: return Vector2(sin(ang), -cos(ang))
static func _l(ctx: Ctx, a: Vector2, b: Vector2, col: String, w: float) -> void:
	ctx.lineCap = "round"; ctx.strokeStyle = col; ctx.lineWidth = w
	ctx.beginPath(); ctx.moveTo(a.x, a.y); ctx.lineTo(b.x, b.y); ctx.stroke()
static func _ink(ctx: Ctx, a: Vector2, b: Vector2, col: String, w: float) -> void:   # 墨線包邊嘅粗線
	_l(ctx, a, b, INK, w + 1.6); _l(ctx, a, b, col, w)
static func _h(k: String) -> float:
	var h = Art.char_h(k)
	if h <= 0: h = float(DW.SPECIAL_H.get(k, 50.0))
	return h
static func chop_time() -> float:
	var F = J.G.get("F")
	var v = J.num(J.mc(F, "chopTime", [])) if F != null else 0.7
	return v if v > 0.05 else 0.7
static func _cx(k: String) -> float:   # 工具離身中線幾遠（以 H 為 1）：上半身最闊嗰邊 + 少少
	var e = maxf(EV2.ext(k, 1.0, -0.78, -0.3), EV2.ext(k, -1.0, -0.78, -0.3))
	return clampf(e + 0.08, 0.28, 0.5)
static func _put(ctx: Ctx, key: String, x: float, y: float, w: float, rot := 0.0, a := 1.0, sx := 1.0, sy := 1.0) -> void:   # 底中間對 (x, y)
	var tex = Spr.get_tex(key) if Spr.ok(key) else null
	if tex == null: return
	var h = w * tex.get_height() / float(tex.get_width())
	ctx.save(); ctx.globalAlpha *= a; ctx.translate(x, y)
	if rot != 0.0: ctx.rotate(rot)
	ctx.scale(sx, sy)
	ctx.drawImage(tex, -w / 2, -h, w, h); ctx.restore()
static func _sprh(key: String, w: float) -> float:
	var tex = Spr.get_tex(key) if Spr.ok(key) else null
	return w * tex.get_height() / float(tex.get_width()) if tex != null else w * 0.6

# ---------------- 工具 ----------------
# 揸位 g、長 L、角度 ang（0＝向上、正＝向前）；本地框
static func tool(ctx: Ctx, id: String, g: Vector2, L: float, ang: float, a := 1.0) -> void:
	ctx.save(); ctx.globalAlpha *= a; ctx.translate(g.x, g.y)
	if SPR_TOOL.has(id) and Spr.ok(SPR_TOOL[id][0]):
		var d = SPR_TOOL[id]; var tex = Spr.get_tex(d[0])
		var h = L; var w = L * tex.get_width() / float(tex.get_height())
		var m = -1.0 if d[5] else 1.0
		var ai = atan2((d[3] - d[1]) * w * m, -(d[4] - d[2]) * h)
		ctx.rotate(ang - ai)
		if d[5]: ctx.scale(-1, 1)
		ctx.drawImage(tex, -d[1] * w, -d[2] * h, w, h)
		ctx.restore(); return
	ctx.rotate(ang); var k = L / 24.0; ctx.scale(k, k)
	shape(ctx, id)
	ctx.restore()
# 程序工具（24×24 框，揸位＝(0,0)，向上；刀口向 +x）
static func shape(ctx: Ctx, sh: String) -> void:
	var V = func(x, y): return Vector2(x, y)
	match sh:
		"cleaver", "spatula": EA.shape(ctx, sh)
		"saw":   # 框鋸：木柄＋長鋸片＋鋸齒
			Art.rr(ctx, -1.8, -6, 3.6, 8, 1, "#6a4428", INK, 0.9)
			Art.poly(ctx, [-1.6, -6, 2.6, -6, 2.2, -25, -1.6, -25], "#9a968c", INK, 0.9)
			var pts = []
			for i in 10: pts.append_array([2.4 - i * 0.02, -7.0 - i * 1.8, 3.8, -7.9 - i * 1.8])
			ctx.strokeStyle = INK; ctx.lineWidth = 0.7; ctx.beginPath(); ctx.moveTo(pts[0], pts[1])
			for i in range(2, pts.size(), 2): ctx.lineTo(pts[i], pts[i + 1])
			ctx.stroke()
		"tapper":   # 膠刀：短柄＋彎鉤細刀
			Art.rr(ctx, -1.6, -9, 3.2, 10, 1, "#6a4428", INK, 0.9)
			Art.poly(ctx, [-1.2, -9, 1.6, -9, 3.4, -15, 6, -17, 5, -19, 1.6, -16, -1.2, -13], "#8c8a84", INK, 0.9)
		"pole":   # 竹竿
			_ink(ctx, V.call(0, 2), V.call(0, -24), "#8a9a58", 2.0)
			for y in [-5, -11, -17, -23]: _l(ctx, V.call(-1.4, y), V.call(1.4, y), INK, 0.8)
		"ladle":   # 大勺：木柄＋勺頭
			_ink(ctx, V.call(0, 2), V.call(0, -17), "#8a6a40", 1.8)
			Art.el(ctx, 0, -20, 4.6, 3.4, "#6a6a70", INK, 1.0); Art.el(ctx, 0, -21, 3.4, 1.6, "#3a3a40")
		"paddle":   # 攪棍：長木棍＋扁頭
			_ink(ctx, V.call(0, 2), V.call(0, -16), "#9a7a4a", 2.0)
			Art.rr(ctx, -2.6, -25, 5.2, 10, 2, "#8a6a40", INK, 0.9)
		"pestle":   # 打漿杵：長柄＋粗頭（頭向上，用嗰陣翻轉向下）
			_ink(ctx, V.call(0, 2), V.call(0, -15), "#9a7a4a", 2.2)
			Art.rr(ctx, -3.4, -25, 6.8, 11, 2.4, "#7a5a34", INK, 1.0)
		"stamp":   # 印仔：木柄頭＋紅底
			Art.el(ctx, 0, -20, 3.2, 3.2, "#8a5a30", INK, 0.9); Art.rr(ctx, -1.4, -18, 2.8, 10, 1, "#8a5a30", INK, 0.8)
			Art.rr(ctx, -5, -8, 10, 5, 1, "#7a5a34", INK, 0.9); Art.rr(ctx, -5, -3.4, 10, 2.4, 0.6, "#b83a2e", INK, 0.7)
		"fan":   # 葵扇：短柄＋圓扇面
			_ink(ctx, V.call(0, 2), V.call(0, -9), "#8a6a40", 1.8)
			Art.el(ctx, 0, -17, 8, 8.6, "#c8b078", INK, 1.0)
			for i in 7:
				var an = -1.2 + i * 0.4
				_l(ctx, V.call(0, -9), V.call(sin(an) * 7.4, -17 - cos(an) * 7.8), "#8a6a40", 0.6)
		"pin":   # 擀麵棍（打橫，揸位＝中間）
			Art.rr(ctx, -12, -2.2, 24, 4.4, 2.2, "#b8925a", INK, 0.9)
			Art.rr(ctx, -12, -1.2, 3, 2.4, 1, "#8a6a40"); Art.rr(ctx, 9, -1.2, 3, 2.4, 1, "#8a6a40")
		"crank":   # 轆轤搖柄（L 形）
			_ink(ctx, V.call(0, 0), V.call(0, -18), "#6a4428", 2.0)
			_ink(ctx, V.call(0, -18), V.call(5, -18), "#6a4428", 2.0)
		"basket":   # 竹籮
			Art.poly(ctx, [-9, -12, 9, -12, 7, 0, -7, 0], "#b8925a", INK, 1.0)
			for i in 4: _l(ctx, V.call(-8.4 + i * 0.6, -9 + i * 2.6), V.call(8.4 - i * 0.6, -9 + i * 2.6), "#8a6a40", 0.6)
			ctx.strokeStyle = INK; ctx.lineWidth = 1.0; ctx.beginPath(); ctx.ellipse(0, -12, 9, 2.4, 0, 0, TAU); ctx.stroke()
			ctx.beginPath(); ctx.arc(0, -12, 8, PI, TAU); ctx.stroke()
		_:
			Art.el(ctx, 0, -12, 6, 6, "#a89a88", INK, 1.0)

# ---------------- 道具（工作物） ----------------
static func _block(ctx: Ctx, x: float, w: float, h: float) -> void:   # 木墩
	Art.rr(ctx, x - w / 2, -h, w, h, 2, "#6e4a30", INK, 1.0)
	Art.el(ctx, x, -h, w / 2, w * 0.12, "#a07a4e", INK, 1.0)
	Art.el(ctx, x, -h, w * 0.28, w * 0.06, null, "#7a5a34", 0.7)
static func _tub(ctx: Ctx, x: float, w: float, h: float, liq: String) -> float:   # 木盆，回水面 y
	Art.poly(ctx, [x - w / 2, -h, x + w / 2, -h, x + w * 0.42, 0, x - w * 0.42, 0], "#7a5a34", INK, 1.0)
	_l(ctx, Vector2(x - w * 0.47, -h * 0.55), Vector2(x + w * 0.47, -h * 0.55), "#4a3020", 1.2)
	Art.el(ctx, x, -h, w / 2, w * 0.13, liq, INK, 1.0)
	return -h
static func _table(ctx: Ctx, x: float, w: float, h: float) -> void:   # 細枱
	_ink(ctx, Vector2(x - w * 0.4, 0), Vector2(x - w * 0.36, -h), "#6a4428", 1.6)
	_ink(ctx, Vector2(x + w * 0.4, 0), Vector2(x + w * 0.36, -h), "#6a4428", 1.6)
	Art.rr(ctx, x - w / 2, -h - 3, w, 4, 1.5, "#8a6a40", INK, 1.0)
static func _bamboo(ctx: Ctx, x: float, y0: float, y1: float, w: float) -> void:   # 一條竹（由 y0 到 y1）
	Art.rr(ctx, x - w / 2, y1, w, y0 - y1, w * 0.3, "#6f9a4a", INK, 1.0)
	var n = int(absf(y0 - y1) / (w * 2.2))
	for i in n: _l(ctx, Vector2(x - w / 2, y0 - (i + 1) * w * 2.2), Vector2(x + w / 2, y0 - (i + 1) * w * 2.2), "#3e6a2a", 1.0)
	_l(ctx, Vector2(x - w * 0.2, y0 - 2), Vector2(x - w * 0.2, y1 + 2), "rgba(220,240,200,.45)", 1.0)
static func _steam(ctx: Ctx, x: float, y: float, T: float, H: float, seed: float) -> void:
	DW.steam(ctx, x, y, fmod(T, 1.4), 1.4, H, seed, 3)
static func _flame(ctx: Ctx, x: float, y: float, T: float, H: float, seed: float) -> void:   # 爐火（常燒）
	for i in 3:
		var hh = H * (0.07 + 0.04 * sin(T * 11.0 + i * 2.1)); var ox = (i - 1) * H * 0.035
		var sw = sin(T * 9.0 + i) * H * 0.012
		DW.crayon(ctx, [[x + ox, y], [x + ox + sw, y - hh * 0.6], [x + ox * 0.6 - sw, y - hh]], "#ff6a2a" if i % 2 else "#ffb43a", maxf(1.2, H * 0.028), seed + i)

# ======================= 主畫 =======================
# k＝角色；(x, y)＝腳底；s＝角色縮放（同 Art.draw_char）；flip＝面向左；T＝秒（已加個人時差）；verb＝動作；opt：{piece, solid, alpha, noshadow}
static func draw(ctx: Ctx, k: String, x: float, y: float, s: float, flip: bool, T: float, verb: String, seed := 0.0, opt := {}) -> Dictionary:
	var H = _h(k) * s; var fd = -1.0 if flip else 1.0
	var c = {"k": k, "H": H, "T": T, "seed": seed, "cx": _cx(k) * H, "opt": opt, "piece": str(opt.get("piece", "")),
		"body": {"lean": 0.0, "dx": 0.0, "dy": 0.0, "sx": 1.0, "sy": 1.0}, "tools": [], "back": [], "front": [], "pts": []}
	_verb(verb, c)
	var z = float(ZOOM.get(verb, 1.0)); var ax: float = c.cx
	ctx.save()
	if opt.get("alpha") != null: ctx.globalAlpha *= float(opt.alpha)
	if not opt.get("noshadow", false):
		ctx.save(); ctx.globalAlpha *= 0.55; Art.shadow(ctx, x, y + 1 * s, s * 0.8); ctx.restore()
	# 後層：工作物、喺身後嘅工具
	ctx.save(); ctx.translate(x, y); ctx.scale(fd, 1); ctx.translate(ax, 0); ctx.scale(z, z); ctx.translate(-ax, 0)
	for f in c.back: f.call(ctx)
	for tl in c.tools: if tl.get("behind", false) and tl.id != "_none": tool(ctx, tl.id, tl.g, tl.L, tl.ang, tl.get("a", 1.0))
	ctx.restore()
	# 身體：成張原圖，做配合嘅擺動
	var b = c.body
	ctx.save(); ctx.translate(x + fd * b.dx * H, y + b.dy * H)
	ctx.translate(0, -0.3 * H); ctx.rotate(fd * deg_to_rad(b.lean)); ctx.translate(0, 0.3 * H)
	ctx.scale(b.sx, b.sy)
	var o = {"t": T, "flip": flip, "pose": "wk", "tamed": true, "untied": true, "shadow": false}
	if opt.get("solid", false): o["solid"] = true
	Art.draw_char(ctx, k, 0.0, 0.0, s, o)
	ctx.restore()
	# 前層：工具、特效
	ctx.save(); ctx.translate(x, y); ctx.scale(fd, 1); ctx.translate(ax, 0); ctx.scale(z, z); ctx.translate(-ax, 0)
	for tl in c.tools: if not tl.get("behind", false) and tl.id != "_none": tool(ctx, tl.id, tl.g, tl.L, tl.ang, tl.get("a", 1.0))
	for f in c.front: f.call(ctx)
	ctx.restore()
	ctx.restore()
	# 測試：工具兩端（以 H 為 1）
	var pts = []
	for tl in c.tools:
		if tl.id == "_none": continue
		for q in [tl.g, tl.g + _dv(tl.ang) * tl.L]: pts.append(Vector2(ax + (q.x - ax) * z, q.y * z) / H)
	LAST[k] = {"verb": verb, "pts": pts, "body": b.duplicate(), "tools": c.tools.size()}
	return {"verb": verb, "hit": c.get("hit", false)}

static func _verb(v: String, c: Dictionary) -> void:
	match v:
		"chop": _v_chop(c, "axe")
		"hack": _v_chop(c, "cleaver")
		"split": _v_chop(c, "cleaver")
		"poke": _v_poke(c)
		"reap": _v_reap(c)
		"crank": _v_crank(c)
		"score": _v_score(c)
		"net": _v_net(c)
		"pick": _v_pick(c)
		"scoop": _v_scoop(c)
		"saw": _v_saw(c)
		"knead": _v_knead(c)
		"dip": _v_dip(c)
		"grate": _v_grate(c)
		"press": _v_press(c)
		"twist": _v_twist(c)
		"pound": _v_pound(c)
		"stir": _v_stir(c)
		"wok": _v_wok(c)
		"ladle": _v_ladle(c)
		"fold": _v_fold(c)
		"forge": _v_forge(c)
		"steam": _v_steam(c)
		"stamp": _v_stamp(c)
		"fan": _v_fan(c)
		"mill": _v_mill(c)
		_: _v_idle(c)
	c["verb"] = v

static func _v_idle(c: Dictionary) -> void:
	c.body.dy = sin(c.T * 2.0) * 0.01

# ---------------- 砍樹（同主角一樣）＋ 劈竹／斬蕉葉（柴刀）＋ 破篾 ----------------
const CHOP_N := 3
const CHOP_REST := 0.6
# 主角砍樹嘅一下（q：0..1）→ 斧頭角度、揸位、身體；直接用主角 Limbs 姿勢曲線
static func chop_pose(q: float, cx: float, H: float) -> Dictionary:
	var S = Limbs.state_of("afu", "chop", q)
	var th = float(S.th)
	var raise = clampf(th / 72.0, 0, 1); var fw = clampf(-th / 128.0, 0, 1)
	var ang = deg_to_rad(25.0 - th * (0.8 if th > 0.0 else 1.0))   # 舉高時斧頭唔好倒過塊臉
	var g = Vector2(cx + (0.10 * fw + 0.06 * raise) * H, (-0.52 - 0.06 * raise + 0.10 * fw) * H)
	if q > 0.8:   # 斬中之後：斧頭卡喺木度輕輕彈（唔穿過木頭），時間照主角
		var k = (q - 0.8) / 0.2
		ang = deg_to_rad(87.0) - deg_to_rad(6.0) * sin(k * PI)
		g = Vector2(cx + 0.048 * H + 0.012 * H * sin(k * PI), -0.452 * H)
	elif th < -62.0: ang = minf(ang, deg_to_rad(87.0))
	# 身體：主角嘅 lean／dx／壓扁伸長（主角 lean 正＝後仰；呢度正＝前傾）
	var body = {"lean": -float(S.lean) * 0.8, "dx": float(S.dx) * 0.5, "dy": float(S.dy), "sx": float(S.sx), "sy": float(S.sy)}
	return {"g": g, "ang": ang, "body": body, "behind": false, "th": th}
static func _v_chop(c: Dictionary, tid: String) -> void:
	var H: float = c.H; var cx: float = c.cx; var Th = chop_time()
	var cyc = Th * CHOP_N + CHOP_REST
	var tt = fmod(c.T, cyc); var n = int(floor(c.T / cyc))
	var P: Dictionary
	if tt < Th * CHOP_N:
		var i = int(tt / Th); var q = (tt - i * Th) / Th
		P = chop_pose(q, cx, H); c["q"] = q; c["i"] = i
	else:
		P = chop_pose(0.0, cx, H)
		P.g.y += sin(c.T * 2.1) * 0.015 * H; c["q"] = -1.0
	var L = 0.42 * H
	if tid == "cleaver": L = 0.4 * H
	var ang: float = P.ang
	if tid == "cleaver" and c.piece != "": ang += deg_to_rad(12.0)   # 斜劈
	c.body = P.body
	c.tools.append({"id": tid, "g": P.g, "L": L, "ang": ang, "behind": P.behind})
	# 撞擊點（斬中嗰刻斧頭位置）
	var HP = chop_pose(0.8, cx, H)
	var hit = HP.g + _dv(HP.ang + (deg_to_rad(12.0) if tid == "cleaver" and c.piece != "" else 0.0)) * L * 0.8
	var hits = []   # 每下斬中時間（呢一輪）
	for j in CHOP_N: hits.append(j * Th + 0.8 * Th)
	var age_last = tt - hits[CHOP_N - 1]
	var seed: float = c.seed + n * 7.0
	var piece = c.piece
	var verb_split = tid == "cleaver" and piece == ""
	c.back.append(func(ctx: Ctx):
		if piece == "bamboo" or piece == "leaf" or piece == "durian":   # 企喺度嘅竹／蕉葉／榴槤枝：斬三下就跌
			var px = hit.x + 0.06 * H
			var fall = clampf(age_last / 0.45, 0, 1) if age_last > 0 else 0.0
			var al = 1.0 - clampf((age_last - 0.45) / 0.15, 0, 1) if age_last > 0 else 1.0
			var pop = _eo(tt / 0.25) if age_last <= 0 else 1.0
			if piece == "bamboo":   # 下半截留低；上半截斬三下之後由切口跌開
				_bamboo(ctx, px, 0, hit.y, 0.07 * H)
				ctx.save(); ctx.globalAlpha *= al; ctx.translate(px, hit.y); ctx.rotate(fall * 1.3)
				_bamboo(ctx, 0, 0, -0.4 * H * pop, 0.07 * H)
				ctx.restore()
			elif piece == "leaf":
				_bamboo(ctx, px, 0, hit.y, 0.06 * H)
				ctx.save(); ctx.globalAlpha *= al; ctx.translate(px, hit.y); ctx.rotate(0.5 + fall * 1.2)
				Art.el(ctx, 0.14 * H * pop, -0.12 * H * pop, 0.2 * H * pop, 0.07 * H * pop, "#5aa04a", INK, 1.0)
				_l(ctx, Vector2.ZERO, Vector2(0.32 * H * pop, -0.22 * H * pop), "#3e7a2a", 1.0)
				ctx.restore()
			else:
				_bamboo(ctx, px, 0, hit.y - 0.1 * H, 0.05 * H)
				_put(ctx, "mvi_durian", px + fall * 0.1 * H, lerpf(hit.y + 0.12 * H, 0.0, _ez(fall)), 0.16 * H * pop, fall * 2.0, al)
		else:
			# 木墩＋木頭（砍樹）／竹筒（破篾）：最後一下一開二（破篾一開四）
			var logW = 0.36 * H if not verb_split else 0.1 * H
			var lh = _sprh("wood__log", logW) if not verb_split else 0.2 * H
			var top = hit.y + 0.02 * H + lh
			var bw = 0.4 * H
			var sw = bw; var shh = _sprh("stump", sw)
			if Spr.ok("stump") and not verb_split:
				var k = -top / (shh * 0.82)   # 木墩頂面對準
				_put(ctx, "stump", hit.x, 0.0, sw * maxf(0.6, k), 0.0, 1.0, 1.0, 1.0)
			else: _block(ctx, hit.x, bw * 0.8, -top)
			if age_last <= 0.0:
				var pop = _eo(tt / 0.3)
				if verb_split: _bamboo(ctx, hit.x, top, top - lh * pop, logW)
				else: _put(ctx, "wood__log", hit.x, top, logW * pop)
			else:
				var q = clampf(age_last / 0.5, 0, 1); var fall = q * q; var al = 1.0 - clampf((age_last - 0.6) / 0.3, 0, 1)
				ctx.save(); ctx.globalAlpha *= al
				var parts = 4 if verb_split else 2
				for j in parts:
					var side = -1.0 if j < parts / 2 else 1.0; var far = 1.0 + (j % 2) * 0.6 if verb_split else 1.0
					var px = hit.x + side * far * fall * 0.16 * H; var py = lerpf(top, 0.0, fall)
					if verb_split:
						ctx.save(); ctx.translate(px, py); ctx.rotate(side * far * fall * 1.2)
						Art.rr(ctx, -logW * 0.12, -lh, logW * 0.24, lh, 1, "#c8a85a", INK, 0.8); ctx.restore()
					else:
						var tex = Spr.get_tex("wood__log") if Spr.ok("wood__log") else null
						if tex != null:
							var w = logW; var h = _sprh("wood__log", w)
							ctx.save(); ctx.translate(px, py); ctx.rotate(side * fall * 1.2)
							var u0 = 0.0 if side < 0 else 0.5
							ctx.drawImage(tex, tex.get_width() * u0, 0, tex.get_width() * 0.5, tex.get_height(), -w * (0.5 if side < 0 else 0.0), -h, w * 0.5, h)
							ctx.restore()
				ctx.restore())
	c.front.append(func(ctx: Ctx):
		for j in CHOP_N:
			var g = tt - hits[j]
			if g >= 0 and g < 0.6: DW.chips(ctx, hit.x, hit.y, g, seed + j * 7, H, 0.0)
		if age_last > 0.2: DW.puff(ctx, hit.x, 0, age_last - 0.2, 0.5, 0.3 * H, 5 + seed, "wood"))
	c["hit"] = false
	for h in hits: if tt >= h and tt - h < 0.05: c["hit"] = true

# ---------------- 打椰：竹竿向上篤，椰子跌落 ----------------
static func _v_poke(c: Dictionary) -> void:
	var H: float = c.H; var cx: float = c.cx; var P = 1.6; var tt = fmod(c.T, P); var q = tt / P
	var ang = deg_to_rad(22.0)
	var push = 0.0
	if q < 0.3: push = -_ez(q / 0.3) * 0.06
	elif q < 0.4: push = lerpf(-0.06, 0.12, _eo((q - 0.3) / 0.1))
	else: push = lerpf(0.12, 0.0, _ez((q - 0.4) / 0.6))
	var g = Vector2(cx, -0.34 * H) + _dv(ang) * push * H
	c.tools.append({"id": "pole", "g": g, "L": 0.5 * H, "ang": ang})
	c.body = {"lean": -4.0 - push * 40.0, "dx": 0.0, "dy": -push * 0.1, "sx": 1.0 - push * 0.2, "sy": 1.0 + push * 0.3}
	var tip = Vector2(cx, -0.34 * H) + _dv(ang) * (0.5 + 0.12) * H
	c.back.append(func(ctx: Ctx):
		var cp = tip + Vector2(0.03 * H, 0.0)
		if q < 0.4: _put(ctx, "mvi_coconut", cp.x, cp.y + 0.07 * H, 0.14 * H, sin(c.T * 3.0) * 0.1)
		else:
			var f = (q - 0.4) / 0.6; var t2 = f * P
			var yy = minf(0.0, cp.y + 0.07 * H + 0.5 * 9.0 * H * t2 * t2)
			var bounce = 0.0
			if yy >= 0.0: bounce = -absf(sin((t2 - 0.3) * 9.0)) * 0.05 * H * maxf(0.0, 1.0 - (t2 - 0.3) * 2.0)
			_put(ctx, "mvi_coconut", cp.x + f * 0.12 * H, yy + bounce, 0.12 * H, f * 4.0, 1.0 - clampf((f - 0.85) / 0.15, 0, 1)))
	c.front.append(func(ctx: Ctx):
		var g2 = tt - 0.4 * P
		if g2 >= 0: DW.chips(ctx, tip.x, tip.y, g2, c.seed, H * 0.7, 0.0))

# ---------------- 割禾／紮禾稈：鐮刀低位由前拉後，一輪三下（同主角割稻）----------------
static func _v_reap(c: Dictionary) -> void:
	var H: float = c.H; var cx: float = c.cx; var P = chop_time() * 1.4; var tt = fmod(c.T, P); var q = tt / P
	var w = fmod(q * 3.0, 1.0); var e = _ez(w / 0.55) if w < 0.55 else 1.0 - _ez((w - 0.55) / 0.45)
	var g = Vector2(cx + (0.18 - 0.16 * e) * H, (-0.3 + 0.03 * e) * H)
	var ang = deg_to_rad(lerpf(135.0, 55.0, e))
	c.tools.append({"id": "sickle", "g": g, "L": 0.32 * H, "ang": ang})
	c.body = {"lean": 12.0 + 5.0 * sin(w * TAU), "dx": 0.02, "dy": 0.02 + 0.01 * e, "sx": 1.0 + 0.02 * e, "sy": 1.0 - 0.03 * e}
	var bx = cx + 0.34 * H; var straw = c.piece == "straw"
	var cut = int(q * 3.0)
	c.back.append(func(ctx: Ctx):
		for i in 6:
			var x0 = bx + (i - 2.5) * 0.04 * H; var hh = (0.3 - (0.12 if i <= cut * 2 else 0.0)) * H
			var sw = sin(c.T * 2.0 + i) * 0.01 * H
			ctx.strokeStyle = "#d6b45a" if straw else "#6f9a4a"; ctx.lineWidth = maxf(1.0, 0.012 * H); ctx.lineCap = "round"
			ctx.beginPath(); ctx.moveTo(x0, 0); ctx.quadraticCurveTo(x0, -hh * 0.6, x0 + sw + 0.02 * H, -hh); ctx.stroke()
			if not straw and hh > 0.2 * H:
				for j in 3: Art.el(ctx, x0 + sw + 0.022 * H + j * 0.008 * H, -hh + j * 0.018 * H, 0.009 * H, 0.006 * H, "#e2c05a", INK, 0.4))
	c.front.append(func(ctx: Ctx):
		for j in 3:
			var g2 = tt - (j + 0.4) / 3.0 * P
			if g2 >= 0 and g2 < 0.6: DW.grains(ctx, bx, -0.2 * H, g2, c.seed + j * 5, H, -0.6))

# ---------------- 枯井轆轤：轆轤架、搖柄轉圈、桶由井口升上嚟倒水 ----------------
static func _v_crank(c: Dictionary) -> void:
	var H: float = c.H; var cx: float = c.cx; var R = 1.1; var ph = c.T * TAU / R
	var D = Vector2(cx + 0.3 * H, -0.5 * H)        # 轆轤軸中間
	var E0 = Vector2(D.x - 0.13 * H, D.y)          # 搖柄軸頭（向住隻鬼嗰邊）
	var arm = 0.085 * H
	var E = E0 + Vector2(cos(ph), sin(ph)) * arm
	c.tools.append({"id": "crank", "g": E0, "L": arm * 24.0 / 18.0, "ang": ph + PI / 2.0})
	c.body = {"lean": 5.0 + 5.0 * cos(ph), "dx": 0.02 * cos(ph), "dy": 0.01 * sin(ph), "sx": 1.0 + 0.02 * cos(ph), "sy": 1.0 - 0.02 * cos(ph)}
	var cyc = R * 4.0 + 0.8; var tt = fmod(c.T, cyc)
	var up = clampf(tt / (R * 4.0), 0, 1)
	var by = lerpf(-0.02 * H, D.y + 0.16 * H, up)
	var pour = clampf((tt - R * 4.0) / 0.8, 0, 1)
	var wx = D.x
	c.back.append(func(ctx: Ctx):
		Art.el(ctx, wx, -0.02 * H, 0.15 * H, 0.04 * H, "#5a5a62", INK, 1.0)   # 井口
		Art.el(ctx, wx, -0.025 * H, 0.11 * H, 0.026 * H, "#1a1820")
		for s in [-1.0, 1.0]: _ink(ctx, Vector2(wx + s * 0.13 * H, -0.02 * H), Vector2(wx + s * 0.11 * H, D.y - 0.03 * H), "#6a4428", 2.0)   # 兩條柱
		Art.rr(ctx, D.x - 0.11 * H, D.y - 0.035 * H, 0.22 * H, 0.07 * H, 0.02 * H, "#8a6a40", INK, 1.0)   # 木軸
		for j in 4: _l(ctx, Vector2(D.x - 0.06 * H + j * 0.035 * H, D.y - 0.03 * H), Vector2(D.x - 0.08 * H + j * 0.035 * H, D.y + 0.03 * H), "#c8b898", 1.0)
		_l(ctx, Vector2(wx, D.y + 0.035 * H), Vector2(wx, by - 0.07 * H), "#c8b898", 1.2)
		ctx.save(); ctx.translate(wx, by); ctx.rotate(pour * 1.1)
		Art.poly(ctx, [-0.045 * H, -0.07 * H, 0.045 * H, -0.07 * H, 0.036 * H, 0, -0.036 * H, 0], "#6e4a30", INK, 1.0)
		_l(ctx, Vector2(-0.045 * H, -0.04 * H), Vector2(0.045 * H, -0.04 * H), "#3a2410", 1.0)
		Art.el(ctx, 0, -0.07 * H, 0.045 * H, 0.01 * H, "#6f8fa6", INK, 0.7)
		ctx.restore()
		_ink(ctx, E0, Vector2(D.x - 0.11 * H, D.y), "#4a3020", 1.6))
	c.front.append(func(ctx: Ctx):
		Art.el(ctx, E.x, E.y, 0.016 * H, 0.016 * H, "#8a6a40", INK, 0.8)
		if pour > 0.2:
			for i in 4:
				var f = fmod(pour * 3.0 + i * 0.25, 1.0)
				Art.el(ctx, wx + 0.04 * H + f * 0.03 * H, by - 0.06 * H + f * f * 0.3 * H, 0.008 * H, 0.012 * H, "rgba(150,190,220,%.2f)" % (0.8 * (1.0 - f))))

# ---------------- 割膠：膠刀沿樹身斜斜割一刀，白膠流落杯 ----------------
static func _v_score(c: Dictionary) -> void:
	var H: float = c.H; var cx: float = c.cx; var P = 1.5; var tt = fmod(c.T, P); var q = tt / P
	var tx = cx + 0.3 * H
	var a = Vector2(tx - 0.05 * H, -0.62 * H); var b = Vector2(tx - 0.05 * H, -0.44 * H)
	var k = _ez(q / 0.55) if q < 0.55 else 1.0 - _ez((q - 0.55) / 0.45)
	var g = a.lerp(b, k) + Vector2(-0.12 * H, 0.06 * H)
	c.tools.append({"id": "tapper", "g": g, "L": 0.2 * H, "ang": deg_to_rad(70.0)})
	c.body = {"lean": 6.0 + 6.0 * k, "dx": 0.01 * k, "dy": 0.01 * k, "sx": 1.0, "sy": 1.0 - 0.02 * k}
	c.back.append(func(ctx: Ctx):
		Art.rr(ctx, tx - 0.07 * H, -0.85 * H, 0.14 * H, 0.85 * H, 0.03 * H, "#7a6a54", INK, 1.0)
		for i in 4: _l(ctx, Vector2(tx - 0.07 * H, (-0.66 + i * 0.05) * H), Vector2(tx + 0.07 * H, (-0.6 + i * 0.05) * H), "#efe8d8" if i == 0 else "#5a4a3a", 1.2)
		var cut = a.lerp(b, k)
		_l(ctx, Vector2(tx - 0.07 * H, a.y), cut + Vector2(0.03 * H, 0), "#f4f0e4", 1.6)
		Art.poly(ctx, [tx + 0.05 * H, -0.22 * H, tx + 0.13 * H, -0.22 * H, tx + 0.12 * H, -0.15 * H, tx + 0.06 * H, -0.15 * H], "#6e4a30", INK, 0.9)
		for i in 3:
			var f = fmod(c.T * 0.8 + i / 3.0, 1.0)
			Art.el(ctx, tx + 0.085 * H, lerpf(-0.42 * H, -0.23 * H, f), 0.007 * H, 0.011 * H, "rgba(244,240,228,%.2f)" % (1.0 - f * 0.4)))

# ---------------- 起罾：放落水、等、拉起（有魚跳）----------------
static func _v_net(c: Dictionary) -> void:
	var H: float = c.H; var cx: float = c.cx; var P = 3.0; var tt = fmod(c.T, P); var q = tt / P
	var a0 = 48.0; var a1 = 112.0
	var a = a0
	if q < 0.3: a = lerpf(a0, a1, _ez(q / 0.3))
	elif q < 0.55: a = a1 + sin(c.T * 3.0) * 1.5
	elif q < 0.8: a = lerpf(a1, a0, _ez((q - 0.55) / 0.25))
	else: a = a0 + sin((q - 0.8) / 0.2 * PI * 3.0) * 4.0 * (1.0 - (q - 0.8) / 0.2)
	var g = Vector2(cx, -0.42 * H); var L = 0.6 * H; var ang = deg_to_rad(a)
	c.tools.append({"id": "pole", "g": g, "L": L, "ang": ang})
	var pull = clampf((q - 0.55) / 0.25, 0, 1) * (1.0 if q < 0.8 else 0.0)
	c.body = {"lean": lerpf(10.0, -6.0, pull) if q >= 0.55 and q < 0.8 else (10.0 * _ez(q / 0.3) if q < 0.3 else (10.0 if q < 0.55 else -6.0 * (1.0 - (q - 0.8) / 0.2))), "dx": 0.0, "dy": 0.0, "sx": 1.0, "sy": 1.0 + 0.03 * pull}
	var tip = g + _dv(ang) * L
	var full = q >= 0.55
	c.back.append(func(ctx: Ctx):
		Art.el(ctx, cx + 0.62 * H, -0.01 * H, 0.26 * H, 0.05 * H, "#3a5468", INK, 1.0)
		Art.el(ctx, cx + 0.6 * H, -0.02 * H, 0.16 * H, 0.02 * H, "rgba(160,200,220,.4)"))
	c.front.append(func(ctx: Ctx):
		var nw = 0.11 * H; var ny = tip.y + 0.14 * H
		ny = minf(ny, -0.01 * H)
		for s in [-1.0, 1.0]: _l(ctx, tip, Vector2(tip.x + s * nw, ny), "#4a3a2a", 0.9)
		ctx.strokeStyle = "#4a3a2a"; ctx.lineWidth = 0.8
		ctx.beginPath(); ctx.moveTo(tip.x - nw, ny); ctx.quadraticCurveTo(tip.x, ny + 0.06 * H, tip.x + nw, ny); ctx.stroke()
		for i in 3: _l(ctx, Vector2(tip.x - nw + (i + 1) * nw * 0.5, ny + 0.02 * H), Vector2(tip.x + (i - 1) * nw * 0.2, tip.y + 0.04 * H), "rgba(74,58,42,.6)", 0.6)
		if full: _put(ctx, "mvi_fish", tip.x, ny + 0.03 * H, 0.1 * H, sin(c.T * 14.0) * 0.4)
		if full and q < 0.8:
			for i in 3:
				var f = fmod(c.T * 1.6 + i * 0.33, 1.0)
				Art.el(ctx, tip.x + (i - 1) * 0.04 * H, ny + f * 0.2 * H, 0.008 * H, 0.012 * H, "rgba(150,190,220,%.2f)" % (0.8 * (1.0 - f))))

# ---------------- 採茶／執報紙：竹籮浮喺身邊，貨一粒粒飛入籮 ----------------
static func _v_pick(c: Dictionary) -> void:
	var H: float = c.H; var cx: float = c.cx; var P = 0.9; var tt = fmod(c.T, P); var q = tt / P
	var bg = Vector2(cx + 0.02 * H, (-0.3 + 0.015 * sin(c.T * 2.2)) * H)
	c.tools.append({"id": "basket", "g": bg, "L": 0.2 * H, "ang": sin(c.T * 1.7) * 0.06})
	var dip = sin(clampf(q / 0.5, 0, 1) * PI)
	c.body = {"lean": 8.0 + 10.0 * dip, "dx": 0.02 * dip, "dy": 0.015 * dip, "sx": 1.0 + 0.02 * dip, "sy": 1.0 - 0.03 * dip}
	var key = c.piece if c.piece.begins_with("m_") else "m_tealeaf"
	var ik = "mvi_" + key.substr(2)
	var src = Vector2(cx + 0.36 * H, -0.12 * H)
	c.back.append(func(ctx: Ctx):
		if key == "m_newspaper":
			for i in 4: Art.rr(ctx, src.x - 0.12 * H + i * 0.01 * H, -0.035 * H * (i + 1), 0.22 * H, 0.035 * H, 1, "#b8b0a0" if i % 2 else "#d0c8b8", INK, 0.8)
		else:
			for i in 5: Art.el(ctx, src.x + (i - 2) * 0.05 * H, -0.06 * H - (2 - absf(i - 2)) * 0.03 * H, 0.07 * H, 0.06 * H, "#4f8a5a" if i % 2 else "#3e7a4a", INK, 0.8))
	c.front.append(func(ctx: Ctx):
		if q > 0.35:
			var f = _ez((q - 0.35) / 0.55)
			var p = src.lerp(bg + Vector2(0, -0.18 * H), f) + Vector2(0, -sin(f * PI) * 0.16 * H)
			_put(ctx, ik, p.x, p.y + 0.04 * H, 0.08 * H, f * 3.0, 1.0 - clampf((f - 0.9) / 0.1, 0, 1)))

# ---------------- 舀碳粉：長柄勺伸入桶舀，抽起抖落麻包 ----------------
static func _v_scoop(c: Dictionary) -> void:
	var H: float = c.H; var cx: float = c.cx; var P = 1.5; var tt = fmod(c.T, P); var q = tt / P
	var bx = cx + 0.4 * H
	var a = deg_to_rad(lerpf(60.0, 125.0, _ez(q / 0.4)) if q < 0.5 else lerpf(125.0, 60.0, _ez((q - 0.5) / 0.35)))
	var g = Vector2(cx + 0.02 * H, -0.4 * H)
	c.tools.append({"id": "ladle", "g": g, "L": 0.4 * H, "ang": a})
	var d = sin(clampf(q / 0.5, 0, 1) * PI)
	c.body = {"lean": 6.0 + 10.0 * d, "dx": 0.02 * d, "dy": 0.01 * d, "sx": 1.0, "sy": 1.0 - 0.02 * d}
	c.back.append(func(ctx: Ctx):
		Art.rr(ctx, bx - 0.1 * H, -0.26 * H, 0.2 * H, 0.26 * H, 2, "#3a3a44", INK, 1.0)
		Art.el(ctx, bx, -0.26 * H, 0.1 * H, 0.025 * H, "#1e1e24", INK, 1.0)
		_l(ctx, Vector2(bx - 0.1 * H, -0.12 * H), Vector2(bx + 0.1 * H, -0.12 * H), "#5a5a62", 1.4))
	c.front.append(func(ctx: Ctx):
		var g2 = tt - 0.72 * P
		if g2 >= 0: DW.puff(ctx, g.x + 0.1 * H, -0.42 * H, g2, 0.45, 0.16 * H, c.seed, null))

# ---------------- 棺材鋪：鋸板（鋸斜斜壓住木頭來回拉，四下鋸斷一截）----------------
static func _v_saw(c: Dictionary) -> void:
	var H: float = c.H; var cx: float = c.cx; var S = 0.5; var n = 4; var cyc = S * n + 0.5
	var tt = fmod(c.T, cyc); var i = mini(n - 1, int(tt / S)); var sq = clampf((tt - i * S) / S, 0, 1)
	var sawing = tt < S * n
	var stroke = sin(sq * TAU) if sawing else 0.0
	var depth = clampf(tt / (S * n), 0, 1) if sawing else 0.0
	var ang = deg_to_rad(132.0)
	var lx = cx + 0.36 * H; var top = -0.28 * H; var w = 0.42 * H
	var lh = _sprh("wood__log", w)
	var cut = Vector2(lx + w * 0.12, top - lh * 0.75 + depth * lh * 0.6)
	var L = 0.4 * H
	var g = cut - _dv(ang) * L * 0.55 + _dv(ang) * stroke * 0.07 * H
	if not sawing: g += Vector2(-0.03 * H, -0.06 * H)
	c.tools.append({"id": "saw", "g": g, "L": L, "ang": ang})
	c.body = {"lean": 7.0 + 6.0 * stroke, "dx": 0.025 * stroke, "dy": 0.0, "sx": 1.0 + 0.015 * stroke, "sy": 1.0 - 0.015 * stroke}
	var fallt = tt - S * n
	c.back.append(func(ctx: Ctx):
		for s in [-1.0, 1.0]:   # 鋸馬
			_ink(ctx, Vector2(lx + s * 0.12 * H, 0), Vector2(lx + s * 0.06 * H, top + 0.02 * H), "#6a4428", 1.6)
			_ink(ctx, Vector2(lx - s * 0.02 * H, 0), Vector2(lx + s * 0.06 * H, top + 0.02 * H), "#6a4428", 1.6)
		var tex = Spr.get_tex("wood__log") if Spr.ok("wood__log") else null
		if tex == null: return
		var f = clampf(fallt / 0.35, 0, 1) if fallt >= 0 else -1.0
		var keep = 0.62
		ctx.drawImage(tex, 0, 0, tex.get_width() * keep, tex.get_height(), lx - w / 2, top + 0.03 * H - lh, w * keep, lh)
		if f < 0.0: ctx.drawImage(tex, tex.get_width() * keep, 0, tex.get_width() * (1.0 - keep), tex.get_height(), lx - w / 2 + w * keep, top + 0.03 * H - lh, w * (1.0 - keep), lh)
		else:
			ctx.save(); ctx.globalAlpha *= 1.0 - clampf((fallt - 0.35) / 0.15, 0, 1)
			ctx.translate(lx - w / 2 + w * keep, lerpf(top + 0.03 * H, 0.0, f * f)); ctx.rotate(f * 1.1)
			ctx.drawImage(tex, tex.get_width() * keep, 0, tex.get_width() * (1.0 - keep), tex.get_height(), 0, -lh, w * (1.0 - keep), lh); ctx.restore()
		if sawing: _l(ctx, Vector2(cut.x, top + 0.03 * H - lh), cut, "#3a2410", 1.4))
	c.front.append(func(ctx: Ctx):
		if sawing:
			var a2 = fmod(tt, S)
			DW.puff(ctx, cut.x, top + 0.03 * H, a2, 0.45, 0.12 * H, c.seed + i, "wood")
			for j in 3:
				var fq = fmod(a2 * 2.0 + j * 0.33, 1.0)
				Art.el(ctx, cut.x + (j - 1) * 0.02 * H, lerpf(top + 0.03 * H, 0.0, fq), 0.008 * H, 0.006 * H, "rgba(200,160,100,%.2f)" % (1.0 - fq)))

# ---------------- 包子鋪：擀麵棍來回碌，個麵團變包、轉住捏摺 ----------------
static func _v_knead(c: Dictionary) -> void:
	var H: float = c.H; var cx: float = c.cx; var R = 0.42; var n = 4; var cyc = R * n + 1.0
	var tt = fmod(c.T, cyc); var rolling = tt < R * n
	var x0 = cx + 0.3 * H; var top = -0.34 * H
	var rx = sin(tt / R * TAU) if rolling else 0.0
	var press = absf(cos(tt / R * TAU)) if rolling else 0.0
	var pin = Vector2(x0 + rx * 0.06 * H, top - 0.06 * H + 0.012 * H * press)
	var lift = 0.0 if rolling else _ez((tt - R * n) / 0.3) * 0.12
	c.tools.append({"id": "pin", "g": pin + Vector2(0, -lift * H), "L": 0.24 * H, "ang": 0.04 * rx, "a": 1.0})
	c.body = {"lean": 10.0 + 6.0 * press, "dx": 0.02 * rx, "dy": 0.012 * press, "sx": 1.0 + 0.02 * press, "sy": 1.0 - 0.03 * press}
	c.back.append(func(ctx: Ctx):
		_table(ctx, x0, 0.32 * H, -top - 0.03 * H)
		if rolling:
			var fl = 1.0 + 0.4 * clampf(tt / (R * n), 0, 1)
			Art.el(ctx, x0, top - 0.025 * H, 0.08 * H * fl, 0.035 * H / fl, "#efe6d2", INK, 1.0)
		else:
			var f = clampf((tt - R * n) / 0.5, 0, 1)
			_put(ctx, "bun__bun", x0, top - 0.005 * H, 0.15 * H * (0.7 + 0.3 * _eo(f)), sin(f * TAU * 2.0) * 0.15)
			if f > 0.3: DW.steam(ctx, x0, top - 0.1 * H, (tt - R * n) - 0.15, 0.8, H * 0.5, c.seed, 2))
	c.front.append(func(ctx: Ctx):
		if rolling and press > 0.9: DW.puff(ctx, x0, top, 0.05, 0.4, 0.1 * H, c.seed, "flour"))

# ---------------- 紙寮：竹簾落漿池撈、抽起抖勻、揭紙疊好 ----------------
static func _v_dip(c: Dictionary) -> void:
	var H: float = c.H; var cx: float = c.cx; var P = 2.6; var tt = fmod(c.T, P); var q = tt / P
	var vx = cx + 0.34 * H
	var y_up = -0.52 * H; var y_dn = -0.2 * H
	var y = y_up; var tilt = 0.0; var dx = 0.0; var sheet = 0.0
	if q < 0.25: y = lerpf(y_up, y_dn, _ez(q / 0.25)); tilt = 0.35 * _ez(q / 0.25)
	elif q < 0.35: y = y_dn; tilt = 0.35 * (1.0 - (q - 0.25) / 0.1)
	elif q < 0.55: y = lerpf(y_dn, y_up, _ez((q - 0.35) / 0.2)); sheet = 1.0
	elif q < 0.75: y = y_up; dx = sin((q - 0.55) / 0.2 * TAU * 2.0) * 0.03 * H; sheet = 1.0
	else: y = y_up; tilt = -0.5 * sin((q - 0.75) / 0.25 * PI); sheet = 1.0 - clampf((q - 0.8) / 0.1, 0, 1)
	var g = Vector2(vx + dx, y)
	c.body = {"lean": 8.0 + 10.0 * clampf((y - y_up) / (y_dn - y_up), 0, 1), "dx": dx / H * 0.5, "dy": 0.0, "sx": 1.0, "sy": 1.0}
	c.tools.append({"id": "_none", "g": g, "L": 0.0, "ang": 0.0, "a": 0.0})
	var stack = int(c.T / P) % 5
	c.back.append(func(ctx: Ctx):
		_tub(ctx, vx, 0.36 * H, 0.18 * H, "#d8d4c4")
		for i in stack + 1: Art.rr(ctx, vx + 0.2 * H, -0.02 * H * (i + 1), 0.14 * H, 0.02 * H, 0.5, "#efe4c4", INK, 0.6))
	c.front.append(func(ctx: Ctx):
		ctx.save(); ctx.translate(g.x, g.y); ctx.rotate(tilt)
		var w = 0.3 * H; var h = 0.035 * H
		if y > -0.2 * H - 0.001: ctx.globalAlpha *= 0.85
		Art.rr(ctx, -w / 2, -h / 2, w, h, 1, "#b8925a", INK, 1.0)
		for i in 7: _l(ctx, Vector2(-w / 2 + (i + 1) * w / 8, -h / 2), Vector2(-w / 2 + (i + 1) * w / 8, h / 2), "#8a6a40", 0.6)
		if sheet > 0: ctx.globalAlpha *= sheet; Art.rr(ctx, -w * 0.45, -h * 0.9, w * 0.9, h * 0.5, 1, "#f2ead2", INK, 0.6)
		ctx.restore()
		if q > 0.35 and q < 0.55:
			for i in 4:
				var f = fmod((q - 0.35) / 0.2 * 2.0 + i * 0.25, 1.0)
				Art.el(ctx, g.x + (i - 1.5) * 0.06 * H, g.y + f * 0.2 * H, 0.008 * H, 0.012 * H, "rgba(220,214,196,%.2f)" % (0.8 * (1.0 - f))))

# ---------------- 刨椰寮：半個椰喺刨椰刀上來回刨，椰絲跌落碗 ----------------
static func _v_grate(c: Dictionary) -> void:
	var H: float = c.H; var cx: float = c.cx; var S = 0.5; var st = sin(c.T / S * TAU)
	var bx = cx + 0.32 * H; var top = -0.26 * H
	var cp = Vector2(bx + st * 0.06 * H, top - 0.035 * H)
	c.body = {"lean": 10.0 + 5.0 * st, "dx": 0.02 * st, "dy": 0.01, "sx": 1.0 + 0.015 * st, "sy": 1.0 - 0.015 * st}
	c.tools.append({"id": "_none", "g": cp, "L": 0.0, "ang": 0.0, "a": 0.0})
	c.back.append(func(ctx: Ctx):
		_table(ctx, bx, 0.3 * H, -top)
		Art.poly(ctx, [bx + 0.1 * H, top - 0.02 * H, bx + 0.15 * H, top - 0.05 * H, bx + 0.16 * H, top - 0.02 * H], "#8c8a84", INK, 0.8)
		Art.el(ctx, bx + 0.02 * H, -0.03 * H, 0.08 * H, 0.03 * H, "#e8e2d0", INK, 0.9)
		Art.el(ctx, bx + 0.02 * H, -0.05 * H, 0.06 * H, 0.012 * H, "#f8f4ec"))
	c.front.append(func(ctx: Ctx):
		_put(ctx, "mvi_coconut", cp.x, cp.y + 0.05 * H, 0.12 * H, 0.3 + st * 0.15)
		for i in 5:
			var f = fmod(c.T * 1.8 + i * 0.2, 1.0)
			Art.el(ctx, bx + 0.08 * H - f * 0.06 * H + (i - 2) * 0.01 * H, lerpf(top, -0.06 * H, f), 0.01 * H, 0.004 * H, "rgba(248,244,236,%.2f)" % (1.0 - f * 0.5)))

# ---------------- 膠片房：兩條壓膠轆轉、膠片穿過 ----------------
static func _v_press(c: Dictionary) -> void:
	var H: float = c.H; var cx: float = c.cx; var R = 1.4; var ph = c.T * TAU / R
	var rx = cx + 0.34 * H; var ry = -0.36 * H; var rr = 0.05 * H
	var D = Vector2(rx + 0.1 * H, ry)
	c.tools.append({"id": "crank", "g": D, "L": 0.1 * H * 24.0 / 18.0, "ang": ph + PI / 2.0})
	c.body = {"lean": 6.0 + 5.0 * cos(ph), "dx": 0.015 * cos(ph), "dy": 0.0, "sx": 1.0, "sy": 1.0 - 0.015 * cos(ph)}
	var mv = fmod(c.T * 0.08 * H, 0.3 * H)
	c.back.append(func(ctx: Ctx):
		_table(ctx, rx, 0.34 * H, -ry - rr * 2.2)
		Art.rr(ctx, rx - 0.18 * H + mv * 0.0, ry - 0.008 * H, 0.18 * H, 0.016 * H, 1, "#e8e2d0", INK, 0.7)
		Art.rr(ctx, rx, ry - 0.006 * H, mv, 0.012 * H, 1, "#c8913a", INK, 0.7)
		for s in [-1.0, 1.0]:
			Art.el(ctx, rx, ry + s * rr * 1.05, rr, rr, "#5a5a62", INK, 1.0)
			var a = ph * s
			_l(ctx, Vector2(rx, ry + s * rr * 1.05), Vector2(rx + cos(a) * rr * 0.8, ry + s * rr * 1.05 + sin(a) * rr * 0.8), "#8a8a92", 1.0))

# ---------------- 搓繩棚：搓繩車勾住禾稈轉，條繩一路搓長 ----------------
static func _v_twist(c: Dictionary) -> void:
	var H: float = c.H; var cx: float = c.cx; var ph = c.T * TAU * 2.2
	var hk = Vector2(cx + 0.06 * H, -0.46 * H)
	var cyc = 2.6; var grow = clampf(fmod(c.T, cyc) / (cyc - 0.4), 0, 1)
	var end = Vector2(hk.x + (0.15 + 0.35 * grow) * H, -0.3 * H)
	c.tools.append({"id": "crank", "g": hk, "L": 0.06 * H * 24.0 / 18.0, "ang": ph})
	c.body = {"lean": -3.0 + 2.0 * sin(ph * 0.5), "dx": -0.01 * grow, "dy": 0.0, "sx": 1.0, "sy": 1.0}
	c.front.append(func(ctx: Ctx):
		Art.el(ctx, hk.x, hk.y, 0.04 * H, 0.04 * H, "#7a5a34", INK, 1.0)
		var pts = []
		for i in 15:
			var f = i / 14.0; var p = hk.lerp(end, f) + Vector2(0, sin(f * PI) * 0.04 * H)
			pts.append(p + Vector2(0, sin(f * 22.0 - ph) * 0.008 * H))
		for i in pts.size() - 1: _l(ctx, pts[i], pts[i + 1], "#b8925a", 2.6)
		for i in 6:
			var f = (i + 0.5) / 6.0; var p = hk.lerp(end, f) + Vector2(0, sin(f * PI) * 0.04 * H)
			_l(ctx, p + Vector2(-0.01 * H, -0.01 * H), p + Vector2(0.01 * H, 0.01 * H), "#6a4a2a", 0.8)
		for i in 4: _l(ctx, end, end + Vector2(0.04 * H + i * 0.01 * H, (i - 1.5) * 0.02 * H), "#d6b45a", 1.0))

# ---------------- 紙漿池：打漿杵舉起、舂落（主角錘嘢節奏）----------------
static func _v_pound(c: Dictionary) -> void:
	var H: float = c.H; var cx: float = c.cx; var P = 0.9; var tt = fmod(c.T, P); var p = tt / P
	var S = Limbs.state_of("afu", "hammer", p)
	var raise = clampf(float(S.th) / 72.0, 0, 1)
	var hitk = clampf(-float(S.th) / 62.0, 0, 1)
	var vx = cx + 0.28 * H
	var g = Vector2(vx, (-0.5 - 0.14 * raise + 0.08 * hitk) * H)
	c.tools.append({"id": "pestle", "g": g, "L": 0.36 * H, "ang": PI})
	c.body = {"lean": -float(S.lean) * 0.6, "dx": float(S.dx) * 0.3, "dy": float(S.dy), "sx": float(S.sx), "sy": float(S.sy)}
	c.back.append(func(ctx: Ctx): _tub(ctx, vx, 0.3 * H, 0.16 * H, "#a8a498"))
	c.front.append(func(ctx: Ctx):
		for j in 2:
			var g2 = tt - (j * 0.5 + 0.4) * P
			if g2 >= 0 and g2 < 0.3:
				for i in 4:
					var a = -2.4 + i * 0.5; var r = g2 / 0.3
					Art.el(ctx, vx + cos(a) * r * 0.1 * H, -0.16 * H + sin(a) * r * 0.08 * H + r * r * 0.05 * H, 0.008 * H, 0.008 * H, "rgba(200,196,184,%.2f)" % (1.0 - r)))

# ---------------- 碳粉墨房／檸茶／醋缸：攪棍喺缸入面打圈 ----------------
static func _v_stir(c: Dictionary) -> void:
	var H: float = c.H; var cx: float = c.cx; var R = 1.6; var ph = c.T * TAU / R
	var vx = cx + 0.3 * H
	var tip = Vector2(vx + cos(ph) * 0.08 * H, -0.18 * H + sin(ph) * 0.015 * H)
	var g = Vector2(vx + cos(ph) * 0.03 * H - 0.06 * H, -0.56 * H)
	var d = tip - g
	c.tools.append({"id": "paddle", "g": g, "L": d.length() + 0.04 * H, "ang": atan2(d.x, -d.y), "behind": sin(ph) < 0})
	c.body = {"lean": 6.0 + 4.0 * cos(ph), "dx": 0.015 * cos(ph), "dy": 0.0, "sx": 1.0, "sy": 1.0}
	c.back.append(func(ctx: Ctx):
		var liq = _tub(ctx, vx, 0.34 * H, 0.2 * H, "#2c3a6a")
		ctx.strokeStyle = "rgba(160,180,230,.5)"; ctx.lineWidth = 1.0
		ctx.beginPath(); ctx.ellipse(vx, liq, 0.08 * H, 0.02 * H, 0, ph, ph + 2.4); ctx.stroke())

# ---------------- 大排檔炒嘢：鐵鑊兜、鑊鏟炒，料彈起 ----------------
static func _v_wok(c: Dictionary) -> void:
	var H: float = c.H; var cx: float = c.cx; var P = 1.0; var tt = fmod(c.T, P); var q = tt / P
	var toss = sin(clampf(q / 0.4, 0, 1) * PI)
	var wc = Vector2(cx + 0.26 * H, (-0.36 - 0.05 * toss) * H)
	var wa = -0.25 * toss
	var sp = Vector2(cx + 0.18 * H + sin(c.T * 7.0) * 0.04 * H, -0.62 * H)
	c.tools.append({"id": "spatula", "g": sp, "L": 0.28 * H, "ang": deg_to_rad(150.0 + 12.0 * sin(c.T * 7.0))})
	c.body = {"lean": 4.0 - 6.0 * toss, "dx": -0.01 * toss, "dy": -0.01 * toss, "sx": 1.0, "sy": 1.0 + 0.02 * toss}
	c.back.append(func(ctx: Ctx):
		_flame(ctx, cx + 0.26 * H, -0.24 * H, c.T, H, c.seed)
		ctx.save(); ctx.translate(wc.x, wc.y); ctx.rotate(wa)
		_ink(ctx, Vector2(-0.14 * H, -0.04 * H), Vector2(-0.24 * H, -0.08 * H), "#6a4428", 2.0)
		ctx.beginPath(); ctx.moveTo(-0.14 * H, -0.04 * H); ctx.quadraticCurveTo(0, 0.1 * H, 0.14 * H, -0.04 * H); ctx.closePath()
		ctx.fillStyle = "#3a3a42"; ctx.fill(); ctx.strokeStyle = INK; ctx.lineWidth = 1.2; ctx.stroke()
		ctx.restore())
	c.front.append(func(ctx: Ctx):
		for i in 5:
			var f = clampf((q - 0.1) / 0.6, 0, 1); var hh = sin(f * PI) * (0.1 + 0.03 * (i % 3)) * H
			var cols = ["#d8a84a", "#8a4a2a", "#6f9a4a", "#efe6d2", "#c8483a"]
			Art.el(ctx, wc.x + (i - 2) * 0.035 * H + sin(f * PI) * 0.02 * H, wc.y - 0.02 * H - hh, 0.016 * H, 0.012 * H, cols[i], INK, 0.6)
		_steam(ctx, wc.x, wc.y - 0.06 * H, c.T, H * 0.6, c.seed))

# ---------------- 豆腐花／湯／茶：大勺由煲舀起、倒落碗 ----------------
static func _v_ladle(c: Dictionary) -> void:
	var H: float = c.H; var cx: float = c.cx; var P = 1.8; var tt = fmod(c.T, P); var q = tt / P
	var px = cx + 0.42 * H; var bwx = cx + 0.12 * H
	var A = Vector2(px - 0.02 * H, -0.48 * H); var B = Vector2(bwx + 0.02 * H, -0.42 * H)
	var g: Vector2; var ang: float; var pour = 0.0
	if q < 0.3: g = A + Vector2(0, -0.04 * H * (1.0 - sin(q / 0.3 * PI))); ang = deg_to_rad(lerpf(160.0, 175.0, sin(q / 0.3 * PI)))
	elif q < 0.6: var f = _ez((q - 0.3) / 0.3); g = A.lerp(B, f) + Vector2(0, -sin(f * PI) * 0.06 * H); ang = deg_to_rad(165.0)
	elif q < 0.85: g = B; pour = sin((q - 0.6) / 0.25 * PI); ang = deg_to_rad(165.0 - 40.0 * pour)
	else: var f2 = _ez((q - 0.85) / 0.15); g = B.lerp(A, f2); ang = deg_to_rad(165.0)
	c.tools.append({"id": "ladle", "g": g, "L": 0.3 * H, "ang": ang})
	c.body = {"lean": 6.0 + 4.0 * pour, "dx": 0.0, "dy": 0.0, "sx": 1.0, "sy": 1.0 - 0.01 * pour}
	c.back.append(func(ctx: Ctx):
		Art.poly(ctx, [px - 0.1 * H, -0.2 * H, px + 0.1 * H, -0.2 * H, px + 0.08 * H, 0, px - 0.08 * H, 0], "#5a5a62", INK, 1.0)
		Art.el(ctx, px, -0.2 * H, 0.1 * H, 0.025 * H, "#efe6d2", INK, 1.0)
		_steam(ctx, px, -0.22 * H, c.T, H * 0.5, c.seed)
		_table(ctx, bwx, 0.16 * H, 0.18 * H)
		Art.poly(ctx, [bwx - 0.05 * H, -0.26 * H, bwx + 0.05 * H, -0.26 * H, bwx + 0.03 * H, -0.21 * H, bwx - 0.03 * H, -0.21 * H], "#efe8d8", INK, 0.9))
	c.front.append(func(ctx: Ctx):
		if pour > 0.2:
			var tip = g + _dv(ang) * 0.28 * H
			_l(ctx, tip, Vector2(bwx, -0.26 * H), "rgba(239,230,210,.9)", 1.6))

# ---------------- 紙紮檔：一張紙浮喺身邊，對摺兩次變成貨，跳落貨堆 ----------------
static func _v_fold(c: Dictionary) -> void:
	var H: float = c.H; var cx: float = c.cx; var P = 2.2; var tt = fmod(c.T, P); var q = tt / P
	var p = Vector2(cx + 0.2 * H, (-0.48 + 0.01 * sin(c.T * 2.0)) * H)
	var ik = str(c.opt.get("icon", "mvi_paper"))
	var nod = sin(clampf(q / 0.6, 0, 1) * PI * 2.0)
	c.body = {"lean": 6.0 + 3.0 * nod, "dx": 0.0, "dy": 0.0, "sx": 1.0, "sy": 1.0}
	c.tools.append({"id": "_none", "g": p, "L": 0.0, "ang": 0.0, "a": 0.0})
	c.front.append(func(ctx: Ctx):
		var w = 0.22 * H; var h = 0.16 * H
		if q < 0.3:
			var f = _ez(q / 0.3); var ww = w * (1.0 - 0.5 * f)
			Art.rr(ctx, p.x - ww / 2, p.y - h / 2, ww, h, 1, "#efe6d2", INK, 0.9)
			ctx.save(); ctx.translate(p.x + ww / 2, p.y); ctx.scale(cos(f * PI) * 0.5 + 0.0001, 1)
			Art.rr(ctx, 0, -h / 2, w, h, 1, "#e2d8c0", INK, 0.9); ctx.restore()
		elif q < 0.55:
			var f2 = _ez((q - 0.3) / 0.25); var hh = h * (1.0 - 0.5 * f2)
			Art.rr(ctx, p.x - w / 4, p.y - hh / 2, w / 2, hh, 1, "#e8dec6", INK, 0.9)
			_l(ctx, Vector2(p.x - w / 4, p.y), Vector2(p.x + w / 4, p.y), "#b8a888", 0.7)
		elif q < 0.75:
			var f3 = _eo((q - 0.55) / 0.2)
			_put(ctx, ik, p.x, p.y + 0.09 * H, 0.2 * H * (0.5 + 0.5 * f3), sin(f3 * TAU) * 0.2)
			if f3 < 0.6: DW.twinkle(ctx, p.x, p.y, (q - 0.55) * P, H * 0.6, c.seed)
		else:
			var f4 = _ez((q - 0.75) / 0.25)
			var d = p.lerp(Vector2(cx + 0.42 * H, -0.02 * H), f4) + Vector2(0, -sin(f4 * PI) * 0.1 * H)
			_put(ctx, ik, d.x, d.y + 0.09 * H, 0.2 * H, f4 * 2.0, 1.0 - clampf((f4 - 0.85) / 0.15, 0, 1)))

# ---------------- 兵器檔：木槌錘紙紮兵器（主角錘嘢節奏：一輪兩下）----------------
static func _v_forge(c: Dictionary) -> void:
	var H: float = c.H; var cx: float = c.cx; var P = 0.9; var tt = fmod(c.T, P); var p = tt / P
	var S = Limbs.state_of("afu", "hammer", p)
	var th = float(S.th)
	var ang = deg_to_rad(clampf(30.0 - th * (0.8 if th > 0.0 else 1.0), -30.0, 110.0))
	var g = Vector2(cx + (0.02 + 0.04 * clampf(th / 72.0, 0, 1)) * H, (-0.42 - 0.06 * clampf(th / 72.0, 0, 1) + 0.04 * clampf(-th / 62.0, 0, 1)) * H)
	var gc = Vector2(cx + 0.02 * H, -0.38 * H)
	var hc = gc + _dv(deg_to_rad(110.0)) * 0.32 * H * 0.82   # 錘頭落點
	var bx = hc.x; var top = hc.y + 0.03 * H
	c.tools.append({"id": "mallet", "g": g, "L": 0.32 * H, "ang": ang})
	c.body = {"lean": -float(S.lean) * 0.7, "dx": float(S.dx) * 0.4, "dy": float(S.dy), "sx": float(S.sx), "sy": float(S.sy)}
	c.back.append(func(ctx: Ctx):
		_block(ctx, bx, 0.22 * H, -top)
		ctx.save(); ctx.translate(bx - 0.1 * H, top - 0.012 * H); ctx.rotate(PI / 2.0); ctx.scale(0.2 * H / 24.0, 0.2 * H / 24.0)
		Art.rr(ctx, -1.5, -7, 3, 9, 1, "#b8a888", INK, 0.9); Art.poly(ctx, [-2, -7, 6, -7, 7, -20, 1, -22, -2, -18], "#efe6d2", INK, 1.0)
		ctx.restore())
	c.front.append(func(ctx: Ctx):
		for j in 2:
			var g2 = tt - (j * 0.5 + 0.4) * P
			if g2 >= 0 and g2 < 0.3: DW.puff(ctx, bx, top, g2, 0.3, 0.1 * H, c.seed + j, null))

# ---------------- 蒸籠：蒸籠蓋揭起、出煙、個包跳一跳 ----------------
static func _v_steam(c: Dictionary) -> void:
	var H: float = c.H; var cx: float = c.cx; var P = 2.0; var tt = fmod(c.T, P); var q = tt / P
	var sx = cx + 0.3 * H; var top = -0.26 * H
	var lift = sin(clampf((q - 0.2) / 0.5, 0, 1) * PI)
	var lid = Vector2(sx - 0.02 * H, top - 0.03 * H - lift * 0.14 * H)
	c.body = {"lean": 4.0 - 6.0 * lift, "dx": 0.0, "dy": 0.0, "sx": 1.0, "sy": 1.0 + 0.02 * lift}
	c.tools.append({"id": "_none", "g": lid, "L": 0.0, "ang": 0.0, "a": 0.0})
	c.back.append(func(ctx: Ctx):
		_flame(ctx, sx, -0.02 * H, c.T, H * 0.8, c.seed)
		if Spr.ok("bun__steamer"): _put(ctx, "bun__steamer", sx, -0.03 * H, 0.26 * H)
		else: Art.rr(ctx, sx - 0.12 * H, top, 0.24 * H, -top, 2, "#b8925a", INK, 1.0))
	c.front.append(func(ctx: Ctx):
		if lift > 0.05:
			_put(ctx, "bun__bun", sx, top + 0.01 * H - lift * 0.04 * H, 0.1 * H)
			DW.steam(ctx, sx, top - 0.02 * H, tt - 0.2 * P, 1.0, H * 0.6, c.seed, 3)
		ctx.save(); ctx.translate(lid.x, lid.y); ctx.rotate(-0.4 * lift)
		Art.el(ctx, 0, 0, 0.13 * H, 0.035 * H, "#c8a868", INK, 1.0)
		Art.rr(ctx, -0.02 * H, -0.05 * H, 0.04 * H, 0.025 * H, 1, "#8a6a40", INK, 0.8)
		ctx.restore())

# ---------------- 表格室／匯兌／戲院：印仔啪落張紙，三下換一張 ----------------
static func _v_stamp(c: Dictionary) -> void:
	var H: float = c.H; var cx: float = c.cx; var S = 0.7; var tt = fmod(c.T, S * 3.0 + 0.5); var i = mini(2, int(tt / S))
	var q = clampf((tt - i * S) / S, 0, 1)
	var px = cx + 0.3 * H; var top = -0.3 * H
	var hy = 0.0
	if q < 0.55: hy = _ez(q / 0.55) * 0.12
	elif q < 0.65: hy = lerpf(0.12, 0.0, (q - 0.55) / 0.1)
	if tt >= S * 3.0: hy = 0.12
	var g = Vector2(px, top - 0.01 * H - hy * H - 0.2 * H)
	c.tools.append({"id": "stamp", "g": g + Vector2(0, 0.2 * H), "L": 0.2 * H, "ang": 0.0})
	c.body = {"lean": 4.0 + 8.0 * (1.0 - hy / 0.12), "dx": 0.0, "dy": 0.01 * (1.0 - hy / 0.12), "sx": 1.0, "sy": 1.0}
	var slide = clampf((tt - S * 3.0) / 0.5, 0, 1)
	var marks = i if tt < S * 3.0 else 3
	if tt < S * 3.0 and q >= 0.65: marks = i + 1
	c.back.append(func(ctx: Ctx):
		_table(ctx, px, 0.32 * H, -top)
		var sx = px - 0.1 * H + slide * 0.3 * H
		ctx.save(); ctx.globalAlpha *= 1.0 - slide
		Art.rr(ctx, sx, top - 0.012 * H, 0.2 * H, 0.012 * H, 0.5, "#f2ecd8", INK, 0.7)
		for m in marks: Art.el(ctx, sx + 0.05 * H + m * 0.05 * H, top - 0.014 * H, 0.018 * H, 0.004 * H, "#b83a2e")
		ctx.restore())

# ---------------- 炭爐／磚窰／鹹魚：葵扇撥爐火 ----------------
static func _v_fan(c: Dictionary) -> void:
	var H: float = c.H; var cx: float = c.cx; var P = 0.55; var w = sin(c.T / P * TAU)
	var sx = cx + 0.34 * H
	var g = Vector2(cx + 0.08 * H, -0.3 * H)
	c.tools.append({"id": "fan", "g": g, "L": 0.2 * H, "ang": deg_to_rad(85.0 + 30.0 * w)})
	c.body = {"lean": 10.0 + 3.0 * w, "dx": 0.01 * w, "dy": 0.015, "sx": 1.0, "sy": 0.98}
	c.back.append(func(ctx: Ctx):
		Art.poly(ctx, [sx - 0.1 * H, -0.2 * H, sx + 0.1 * H, -0.2 * H, sx + 0.08 * H, 0, sx - 0.08 * H, 0], "#8a5a3a", INK, 1.0)
		Art.el(ctx, sx, -0.08 * H, 0.04 * H, 0.03 * H, "#2a1a10")
		_flame(ctx, sx, -0.2 * H, c.T * (1.0 + 0.5 * absf(w)), H * (1.0 + 0.3 * absf(w)), c.seed)
		Art.rr(ctx, sx - 0.11 * H, -0.23 * H, 0.22 * H, 0.03 * H, 1, "#3a3a42", INK, 0.9))

# ======================= 掛鈎用 =======================
# 村子派工鬼（WORK.drawWorker 嘅 spot：{g, x, y, flip, ph, post}）：有動作就畫，冇就回 null（照舊）
static func draw_worker(ctx, s, t: float, sc: float):
	if not ON or not (ctx is Ctx): return null
	var post = J.str(J.gp(s, "post")); var v = verb_of_post(post)
	if v == "": return null
	var g = J.gp(s, "g"); var k = J.str(J.gp(g, "k"))
	if k == "" or (not Art.has_spr(k) and _h(k) <= 0): return null
	var ph = J.num(J.gp(s, "ph")) if J.t(J.gp(s, "ph")) else 0.0
	draw(ctx, k, J.num(J.gp(s, "x")), J.num(J.gp(s, "y")), sc, J.t(J.gp(s, "flip")), t + ph * 1.37, v, ph * 3.1, {"piece": PIECE.get(post, "")})
	return {"act": "wa_" + v, "t0": 0.0, "dur": 1.0, "v": {}, "post": post}
# 大排檔員工：art＝台圖；good＝貨（攞圖示）
static func draw_stall(ctx: Ctx, k: String, x: float, y: float, s: float, flip: bool, T: float, art: String, good: String, seed: float) -> bool:
	if not ON: return false
	var v = verb_of_stall(art)
	if v == "": return false
	var M = load("res://game/outpost/mat.gd")
	var ic = str(M.icon(good)) if good != "" else "mvi_paper"
	if not Spr.ok(ic):
		var MD = load("res://game/outpost/mv_data.gd")
		ic = str(MD.good_def(good).get("icon", "mvi_paper"))
	draw(ctx, k, x, y, s, flip, T, v, seed, {"piece": PIECE.get(art, ""), "icon": ic})
	return true

# ---------------- 自轉石磨：推柄喺磨面打圈，磨漿由磨口流出 ----------------
static func _v_mill(c: Dictionary) -> void:
	var H: float = c.H; var cx: float = c.cx; var R = 1.6; var ph = c.T * TAU / R
	var mx = cx + 0.3 * H; var top = -0.26 * H; var rw = 0.16 * H
	var peg = Vector2(mx + cos(ph) * rw * 0.75, top - 0.06 * H + sin(ph) * rw * 0.2)
	var g = Vector2(cx + 0.02 * H, -0.42 * H)
	var d = peg + Vector2(0, -0.05 * H) - g
	c.tools.append({"id": "paddle", "g": g, "L": d.length(), "ang": atan2(d.x, -d.y), "behind": sin(ph) < 0})
	c.body = {"lean": 6.0 + 6.0 * cos(ph), "dx": 0.025 * cos(ph), "dy": 0.0, "sx": 1.0 + 0.015 * cos(ph), "sy": 1.0 - 0.015 * cos(ph)}
	c.back.append(func(ctx: Ctx):
		Art.rr(ctx, mx - rw * 1.15, -0.12 * H, rw * 2.3, 0.12 * H, 2, "#6a6a70", INK, 1.0)   # 磨盤
		Art.el(ctx, mx, -0.12 * H, rw * 1.15, rw * 0.3, "#7a7a80", INK, 1.0)
		Art.rr(ctx, mx - rw, top, rw * 2.0, -top - 0.12 * H, 2, "#8a8a90", INK, 1.0)   # 上扇
		Art.el(ctx, mx, top, rw, rw * 0.26, "#9a9aa0", INK, 1.0)
		Art.el(ctx, mx - rw * 0.3, top, rw * 0.16, rw * 0.06, "#3a3a40")
		Art.poly(ctx, [mx + rw * 1.1, -0.1 * H, mx + rw * 1.5, -0.08 * H, mx + rw * 1.45, -0.06 * H, mx + rw * 1.1, -0.07 * H], "#6a6a70", INK, 0.8)
		var f = fmod(c.T * 1.3, 1.0)
		Art.el(ctx, mx + rw * 1.5, -0.06 * H + f * 0.05 * H, 0.008 * H, 0.012 * H, "rgba(240,236,224,%.2f)" % (1.0 - f)))
	c.front.append(func(ctx: Ctx):
		_ink(ctx, peg, peg + Vector2(0, -0.06 * H), "#6a4428", 2.0))
