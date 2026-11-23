# [equip] 裝備點樣顯示：戰鬥疊層（BtChar 上面）、村子廣場小件、換裝預覽
#   錨點：data/nat/equip.json ANCHOR[k] = {hand:[x,y], head:[x,y]}（角色高 H＝1、腳底中間＝原點、面向右、y 向上負）
#         未定義 → 自動估：讀全身圖（PtGfx.tex(Art.spr_key(k))）嘅不透明輪廓，頭＝最高嗰行中間，手＝身高 42–62% 段最前嗰點
#   規矩：兵器向外上斜（唔過臉）、長度 ≤ 0.55H；帽底唔低過頭頂 0.08H（唔遮眼）；護身＝腳底等級色環＋背側小徽章；
#         隨身物＝腰側小圖示；全部喺角色 1.25H 方框內（測試 eq_test shots 檢查）
extends RefCounted

const EQ = preload("res://game/equip/eq_data.gd")
const EA = preload("res://game/equip/eq_art.gd")
const BOX := 1.25
static var _anc := {}
static var LAST := {}          # 測試：最後一次畫嘅範圍 {k: Rect2（以 H 為 1）}

# ---------------- 錨點 ----------------
static func anchor(k: String) -> Dictionary:
	if _anc.has(k): return _anc[k]
	var a = EQ.D().get("ANCHOR", {}).get(k)
	var o = {}
	if a is Dictionary and a.get("hand") is Array and a.get("head") is Array:
		o = {"hand": Vector2(J.num(a.hand[0]), J.num(a.hand[1])), "head": Vector2(J.num(a.head[0]), J.num(a.head[1])), "src": "data"}
	else: o = auto_anchor(k)
	_anc[k] = o
	return o
static func auto_anchor(k: String) -> Dictionary:
	var dflt = {"hand": Vector2(0.22, -0.45), "head": Vector2(0.0, -0.95), "src": "default"}
	var tex = PtGfx.tex(Art.spr_key(k))
	if tex == null: return dflt
	var img: Image = tex.get_image()
	if img == null or img.get_height() < 8: return dflt
	if img.is_compressed(): img = img.duplicate(); img.decompress()
	var h0 = img.get_height(); var w0 = img.get_width()
	var hs = 64; var ws = maxi(8, int(round(float(w0) * hs / h0)))
	img = img.duplicate(); img.resize(ws, hs, Image.INTERPOLATE_BILINEAR)
	var top = -1; var cx = 0.0; var cn = 0
	for y in hs:
		for x in ws:
			if img.get_pixel(x, y).a > 0.4:
				if top < 0: top = y
				if y <= top + 3: cx += x; cn += 1
		if top >= 0 and y > top + 3: break
	if top < 0: return dflt
	var hx = cx / maxf(1, cn)
	var best = Vector2(-1, -1)
	for y in range(int(hs * 0.38), int(hs * 0.62)):
		for x in range(ws - 1, -1, -1):
			if img.get_pixel(x, y).a > 0.4:
				if x > best.x: best = Vector2(x, y)
				break
	if best.x < 0: return dflt
	var nx = func(px: float) -> float: return (px - ws * 0.5) / hs
	var hand = Vector2(nx.call(best.x) - 0.03, (best.y - hs) / float(hs))
	return {"hand": Vector2(clampf(hand.x, 0.05, 0.3), clampf(hand.y, -0.7, -0.3)), "head": Vector2(clampf(nx.call(hx), -0.2, 0.2), clampf((top - hs) / float(hs), -1.0, -0.6)), "src": "auto"}

# ---------------- 畫：一隻角色身上全部裝備 ----------------
# ctx 已經喺角色座標；foot＝腳底；H＝角色高（px）；fd＝1 面向右／−1 面向左；pose／pt＝出招狀態
#   w：{wea,arm,acc}（名鬼）或 {"ml": id}（遊魂兵）
#   layer："back"＝只畫手持（掛喺角色後面一層，個手壓住握位＝揸住）；"front"＝只畫頭戴／護身／隨身；""＝全部
static func draw_on(ctx: Ctx, k: String, w: Dictionary, foot: Vector2, H: float, fd: float, pose := "", pt := 0.0, low := false, layer := "") -> Rect2:
	var A = anchor(k)
	var r = Rect2(foot, Vector2.ZERO)
	var ids = []
	for sl in ["arm", "acc", "wea", "ml"]:
		if str(w.get(sl, "")) != "": ids.append([sl, str(w[sl])])
	for e in ids:
		var id = str(e[1]); var it = EQ.item(id)
		var look = str(it.get("look", "hand"))
		var gc = EQ.grade_col(EQ.grade_of(id)) if str(it.get("kind")) == "eq" else Color("#c8b080")
		if layer == "back" and look != "hand": continue
		if layer == "front" and look == "hand": continue
		match look:
			"hand":
				var L = H * (0.48 if EA.is_long(id) else 0.32)
				var ang = 0.55
				if pose == "windup": ang = 0.55 - 0.9 * pt
				elif pose == "strike": ang = -0.35 + 1.75 * minf(1.0, pt * 1.6)
				elif pose == "follow": ang = 1.4
				elif pose == "recover": ang = 1.4 - 0.85 * pt
				var g = foot + Vector2(A.hand.x * H * fd, A.hand.y * H)
				# 握位：物件底部 22% 喺手下面（俾手／身體壓住），即係揸住把柄而唔係浮喺手邊
				var dirv = Vector2(sin(ang * fd), -cos(ang * fd))
				var g0 = g - dirv * L * 0.22
				EA.held(ctx, id, g0.x, g0.y, L, ang * fd)
				var tip = g0 + dirv * L
				r = r.expand(g0)
				r = r.expand(g).expand(tip).expand(g + Vector2(L * 0.25, 0)).expand(g - Vector2(L * 0.25, 0))
			"head":
				# 頭戴：底邊壓落頭頂 0.17H（蓋住原有帽／頭頂，唔懸空）；闊 0.46H
				var hp = foot + Vector2(A.head.x * H * fd, A.head.y * H + H * 0.17)
				var sw = H * 0.46
				ctx.save(); ctx.translate(hp.x, hp.y); ctx.scale(sw / 24.0 * fd, sw / 24.0)
				if EA.has_img(id): Art.put(ctx, EA.img_key(id), 0, 0, 24, 24)
				else: EA.shape(ctx, EA.shape_of(id))
				ctx.restore()
				r = r.expand(hp + Vector2(-sw * 0.55, -sw * 0.5)).expand(hp + Vector2(sw * 0.55, 0))
			"body":
				if low: continue
				# 貼身微光：腳底細細一圈等級色（半透明、細線）
				ctx.save(); ctx.translate(foot.x, foot.y); ctx.scale(1.0, 0.3)
				ctx.strokeStyle = "rgba(%d,%d,%d,0.55)" % [int(gc.r8), int(gc.g8), int(gc.b8)]; ctx.lineWidth = maxf(1.0, H * 0.018)
				ctx.beginPath(); ctx.arc(0, 0, H * 0.17, 0, TAU); ctx.stroke()
				ctx.restore()
				# 背側小徽章
				var bp = foot + Vector2(-0.24 * H * fd, -0.12 * H)   # 背側腳邊（避開臉：浮游鬼個臉好低）
				EA.icon(ctx, id, bp.x, bp.y + H * 0.08, H * 0.17)
				r = r.expand(foot + Vector2(-H * 0.18, -H * 0.06)).expand(foot + Vector2(H * 0.18, H * 0.06)).expand(bp + Vector2(-H * 0.09, -H * 0.1)).expand(bp + Vector2(H * 0.09, H * 0.09))
			"belt":
				if low: continue
				var bp2 = foot + Vector2(0.22 * H * fd, -0.10 * H)   # 前側腳邊
				EA.icon(ctx, id, bp2.x, bp2.y + H * 0.065, H * 0.13)
				r = r.expand(bp2 + Vector2(-H * 0.07, -H * 0.07)).expand(bp2 + Vector2(H * 0.07, H * 0.07))
	LAST[k] = Rect2((r.position - foot) / H, r.size / H)
	return r
# 有冇出界（以 H 為 1 嘅範圍，喺 1.25H 方框：x −0.625..0.625、y −1.25..0.15）
static func in_box(rn: Rect2) -> bool:
	return rn.position.x >= -BOX * 0.5 - 0.001 and rn.end.x <= BOX * 0.5 + 0.001 and rn.position.y >= -BOX - 0.001 and rn.end.y <= 0.16

# ---------------- 戰鬥疊層（掛喺 BtChar 入面） ----------------
class Over extends Node2D:
	const EQ2 = preload("res://game/equip/eq_data.gd")
	var bc = null
	var u: Dictionary
	var layer := ""
	func _process(_dt: float) -> void:
		if bc != null and bc.visible: queue_redraw()
	func _draw() -> void:
		if bc == null or not (bc.st is Dictionary) or bc.st.is_empty(): return
		if J.num(u.get("hp", 0)) <= 0: return
		var w = {}
		if u.get("eq") is Dictionary: w = u.eq
		elif str(u.get("eq_ml", "")) != "": w = {"ml": str(u.eq_ml)}
		if w.is_empty(): return
		var st = bc.st
		var k = J.str(u.get("k"))
		var H = J.num(PtChar.CHAR_H.get(k, 58.0)) * J.num(st.s) if PtChar.CHAR_H is Dictionary else 58.0 * J.num(st.s)
		var P = st.get("P", {})
		var pose = str(P.get("pose", "")) if P is Dictionary else ""
		var pt = J.num(P.get("pt", 0)) if P is Dictionary else 0.0
		var fd = -1.0 if J.t(st.get("side1")) else 1.0
		var ctx = Ctx.new(self)
		load("res://game/equip/eq_view.gd").draw_on(ctx, k, w, Vector2(J.num(st.x), J.num(st.y)), H, fd, pose, pt, J.t(u.get("minion")) and w.has("ml") and str(EQ2.item(str(w.ml)).get("look")) != "body", layer)

# rts_view UnitVis.setup 掛鈎：每個 BtChar 加一層（冇裝備嘅單位都掛，但係唔畫嘢）
static func attach(bc, u: Dictionary) -> void:
	if not EQ.on() or bc == null: return
	if not (u.get("eq") is Dictionary) and str(u.get("eq_ml", "")) == "": return
	var o = Over.new(); o.bc = bc; o.u = u; o.name = "EqOver"; o.layer = "front"
	bc.add_child(o)
	var ob = Over.new(); ob.bc = bc; ob.u = u; ob.name = "EqBack"; ob.layer = "back"
	bc.add_child(ob); bc.move_child(ob, 0)   # 手持：喺角色身後一層

# ---------------- 村子廣場（nv_agent head_ops 掛鈎） ----------------
static func village(ops: Array, k: String, ax: float, ay: float, H: float, fwd: float, back_ops = null) -> void:
	if not EQ.on(): return
	var w = EQ.worn_of_k(k)
	if w.is_empty(): return
	var ww = {}
	for sl in ["wea", "arm"]:   # 廣場只畫手持同帽（細，唔畫徽章）
		var id = str(w.get(sl, ""))
		if id != "" and str(EQ.item(id).get("look")) in ["hand", "head"]: ww[sl] = id
	if ww.is_empty(): return
	var bo = back_ops if back_ops is Array else ops
	bo.append(func(ctx): load("res://game/equip/eq_view.gd").draw_on(ctx, k, ww, Vector2(ax, ay), H, fwd, "", 0.0, true, "back"))
	ops.append(func(ctx): load("res://game/equip/eq_view.gd").draw_on(ctx, k, ww, Vector2(ax, ay), H, fwd, "", 0.0, true, "front"))

# ---------------- 換裝預覽（UI）：全身圖＋裝備，縮放到框內，唔裁切 ----------------
static func preview(ctx: Ctx, k: String, w: Dictionary, box: Rect2) -> Rect2:
	var tex = PtGfx.tex(Art.spr_key(k))
	var H = box.size.y / BOX * 0.96
	var foot = Vector2(box.position.x + box.size.x * 0.5, box.end.y - box.size.y * 0.12)
	var Wd = 0.0
	if tex != null:
		var iw = float(tex.get_width()); var ih = float(tex.get_height())
		Wd = H * iw / ih
		if Wd > box.size.x * 0.8: H *= box.size.x * 0.8 / Wd; Wd = box.size.x * 0.8
	var r = draw_on(ctx, k, w, foot, H, 1.0, "", 0.0, false, "back")
	if tex != null:
		ctx.ci.draw_set_transform_matrix(ctx.T); ctx.ci.draw_texture_rect(tex, Rect2(foot.x - Wd * 0.5, foot.y - H, Wd, H), false); ctx.ci.draw_set_transform_matrix(Transform2D.IDENTITY)
	var r2 = draw_on(ctx, k, w, foot, H, 1.0, "", 0.0, false, "front")
	LAST[k] = Rect2((r.merge(r2).position - foot) / H, r.merge(r2).size / H)
	return r.merge(r2)
