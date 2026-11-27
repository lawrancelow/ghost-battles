# [eqview2] 名鬼裝備顯示：另外兩個方案（原型，畀老闆同現行 "pin" 比較揀）
#   開關：eq_view.gd scheme()（S.equip.view；冇就 VIEW_DEFAULT＝"pin" 現行方案）
#   "float"（方案 B 鬼物飄浮）：兵器唔揸喺手，喺名鬼背側上方飄浮（上下浮＋輕擺＋陰氣光暈＋殘影）；
#            普攻：兵器飛出去打目標再飛返（小幅度）；放技能：蓄力時變大轉圈，放出後大幅度飛撲＋拖尾
#   "strike"（方案 C 出手才現形）：平時只喺頭側角落一個極細兵器徽章；普攻／技能時兵器以大尺寸、帶殘影嘅揮擊喺名鬼前面現形再消失
#   兩個方案共通：頭戴物照舊戴頭上（eq_view.draw_on）；護身＝輪廓等級色微光描邊（glow，要 flat 色 shader）＋背側腳邊小徽章；
#                 隨身物＝前側腳邊細細飄浮；遊魂兵（w 有 "ml"）唔經呢度，照現行貼手
#   座標：同 eq_view.draw_on 一樣（ctx 喺角色座標；foot＝腳底；H＝角色高；fd＝面向）
#   st（動態狀態）：{T:秒, act:"idle"/"atk"/"cast"/"sk", ph:0..1, tg:Vector2 或 null（目標身體中間，相對腳底）}
#   規矩：待機全部喺 1.25H 框內；任何狀態兵器頂唔高過 −0.98H（頭頂血條／ab_lay 頭頂資訊喺 op.head 以上，唔遮）；唔遮臉
extends RefCounted

const EQ = preload("res://game/equip/eq_data.gd")
const EA = preload("res://game/equip/eq_art.gd")
const BOX_HALF := 0.625      # [p45] 1.25H 方框半闊（同 eq_view.gd BOX×0.5）
const TOP := -0.98            # 兵器最高（以 H 為 1）：頭頂資訊喺呢條線以上
const SK_DUR := 0.65          # 技能放出後飛撲幾秒（Over 自己計時）
const YIN := Color(0.66, 0.88, 1.0)   # 陰氣色
static var LAST := {}         # 測試：最後一次畫嘅範圍 {k: Rect2（以 H 為 1）}
static var LAST_BACK := {}
static var _prof := {}
static var _mat: ShaderMaterial = null

# ---------------- 輪廓（全身圖不透明範圍，每行左右邊；以 H 為 1、圖中間為 0、圖本身方向） ----------------
static func prof(k: String) -> Array:
	if _prof.has(k): return _prof[k]
	var rows = []
	var tex = PtGfx.tex(Art.spr_key(k))
	var img: Image = tex.get_image() if tex != null else null
	if img != null and img.get_height() >= 8:
		if img.is_compressed(): img = img.duplicate(); img.decompress()
		var hs = 32; var ws = maxi(4, int(round(float(img.get_width()) * hs / img.get_height())))
		img = img.duplicate(); img.resize(ws, hs, Image.INTERPOLATE_BILINEAR)
		for y in hs:
			var l = 99.0; var r = -99.0
			for x in ws:
				if img.get_pixel(x, y).a > 0.35:
					l = minf(l, (x - ws * 0.5) / hs); r = maxf(r, (x + 1 - ws * 0.5) / hs)
			rows.append([l, r] if r > -99.0 else [0.0, 0.0])
	_prof[k] = rows
	return rows
# 某一高度段（y0..y1，−1＝頂、0＝腳）圖嗰邊（side＝+1 右／−1 左）最出幾遠
static var _ext := {}
static func ext(k: String, side: float, y0: float, y1: float) -> float:
	var ck = "%s|%s|%s|%s" % [k, side, y0, y1]
	if _ext.has(ck): return _ext[ck]
	var v = _ext_calc(k, side, y0, y1)
	_ext[ck] = v
	return v
static func _ext_calc(k: String, side: float, y0: float, y1: float) -> float:
	var rows = prof(k)
	if rows.is_empty(): return 0.28
	var e = 0.0
	for i in rows.size():
		var y = -1.0 + (i + 0.5) / rows.size()
		if y < y0 or y > y1: continue
		e = maxf(e, rows[i][1] if side > 0 else -rows[i][0])
	return e

# ---------------- 護身微光描邊：全身圖染單色、向四周偏移畫一圈（畫喺角色身後，所以只露出輪廓外圈） ----------------
static func glow_mat() -> ShaderMaterial:
	if _mat == null:
		var sh = Shader.new()
		sh.code = "shader_type canvas_item;\nvarying vec4 vc;\nvoid vertex(){ vc = COLOR; }\nvoid fragment(){ COLOR = vec4(vc.rgb, vc.a * texture(TEXTURE, UV).a); }\n"
		_mat = ShaderMaterial.new(); _mat.shader = sh
	return _mat
static func glow(ci: CanvasItem, xf: Transform2D, k: String, foot: Vector2, H: float, fd: float, col: Color, T: float, k_a := 1.0) -> void:
	var tex = PtGfx.tex(Art.spr_key(k))
	if tex == null or H < 6.0: return
	var Wd = H * tex.get_width() / float(tex.get_height())
	ci.draw_set_transform_matrix(xf * Transform2D(0.0, Vector2(fd, 1.0), 0.0, foot))
	var a = (0.42 + 0.14 * sin(T * 2.6)) * k_a
	var n = 8   # 效能：每隻名鬼 16 次貼圖（8 方向 × 兩圈）
	for ring in [[0.034, 0.26], [0.020, 0.7]]:
		var c = Color(col.r, col.g, col.b, a * ring[1])
		for i in n:
			var an = i * TAU / n
			var o = Vector2(cos(an), sin(an)) * H * ring[0]
			ci.draw_texture_rect(tex, Rect2(-Wd * 0.5 + o.x, -H + o.y, Wd, H), false, c)
	ci.draw_set_transform_matrix(xf)

# ---------------- 主畫：一隻名鬼身上（front 層） ----------------
static func draw(ctx: Ctx, sch: String, k: String, w: Dictionary, foot: Vector2, H: float, fd: float, st: Dictionary, low := false, layer := "front") -> Rect2:
	var EV = load("res://game/equip/eq_view.gd")
	var r = Rect2(foot, Vector2.ZERO)
	var T = J.num(st.get("T", 0.0))
	if layer == "back":   # 角色後面一層：只有飛過身後嘅兵器（方案 B）
		var wb = str(w.get("wea", ""))
		if sch == "float" and wb != "" and str(EQ.item(wb).get("look")) == "hand": r = _float(ctx, k, wb, foot, H, fd, st, low, "back")
		LAST_BACK[k] = Rect2((r.position - foot) / H, r.size / H)
		return r
	if sch == "float":   # [補丁43] 老闆 11-26：盾、衫、隨身物、頭戴都唔顯示，只顯示漂浮兵器
		var wf = str(w.get("wea", ""))
		if wf != "" and str(EQ.item(wf).get("look")) == "hand": r = r.merge(_float(ctx, k, wf, foot, H, fd, st, low))
		LAST[k] = Rect2((r.position - foot) / H, r.size / H)
		return r
	# 頭戴：照現行（壓喺頭頂）
	var hw = {}
	for sl in ["wea", "arm", "acc"]:
		var id = str(w.get(sl, ""))
		if id != "" and str(EQ.item(id).get("look")) == "head": hw[sl] = id
	if not hw.is_empty(): r = r.merge(EV.draw_on(ctx, k, hw, foot, H, fd, "", 0.0, low, "front"))
	# 護身：背側腳邊小徽章（描邊喺 glow 層）
	var arm = str(w.get("arm", ""))
	if arm != "" and str(EQ.item(arm).get("look")) == "body" and not low:
		var bp = foot + Vector2(-0.24 * H * fd, -0.04 * H)
		EA.icon(ctx, arm, bp.x, bp.y, H * 0.17)
		r = r.expand(bp + Vector2(-H * 0.09, -H * 0.17)).expand(bp + Vector2(H * 0.09, 0))
	# 隨身物：前側腳邊細細飄浮
	var acc = str(w.get("acc", ""))
	if acc != "" and str(EQ.item(acc).get("look")) == "belt" and not low:
		var ap = foot + Vector2(0.27 * H * fd, -0.06 * H + sin(T * 2.4 + 1.7) * 0.025 * H)
		Art.el(ctx, ap.x, ap.y - H * 0.065, H * 0.085, H * 0.085, "rgba(170,225,255,0.13)")
		EA.icon(ctx, acc, ap.x, ap.y, H * 0.13)
		r = r.expand(ap + Vector2(-H * 0.075, -H * 0.15)).expand(ap + Vector2(H * 0.075, H * 0.01))
	# 兵器
	var wea = str(w.get("wea", ""))
	if wea != "" and str(EQ.item(wea).get("look")) == "hand":
		if sch == "float": r = r.merge(_float(ctx, k, wea, foot, H, fd, st, low))
		elif sch == "strike": r = r.merge(_strike(ctx, k, wea, foot, H, fd, st, low))
	LAST[k] = Rect2((r.position - foot) / H, r.size / H)
	return r

# ---------------- 方案 B：鬼物飄浮 ----------------
static func rest_of(k: String, wea: String, foot: Vector2, H: float, fd: float, T: float) -> Array:   # [中心, 角度(弧度，0＝向上), 長度]
	var L = H * (0.46 if EA.is_long(wea) else 0.36)
	var e = ext(k, 1.0, -0.78, -0.3)      # [補丁43] 圖嘅面向側（右）上半身幾闊：兵器永遠喺面向嗰邊
	var cx = clampf(e + 0.09, 0.30, 0.52)
	# [p45] 唔爆格：闊身圖（紙紮大屋等）兵器貼住 0.52 時，長兵器斜到最盡（0.30 弧度）＋邊距 0.05H 會出 1.25H 框右邊；
	#   按兵器長度收返中心，令 中心＋半長×sin(最大斜)＋0.05 ≤ 0.62（留 0.005 緩衝）
	cx = minf(cx, BOX_HALF - 0.005 - 0.05 - sin(0.30) * (L / H) * 0.5)
	var c = foot + Vector2(fd * cx * H, (-0.50 + 0.035 * sin(T * 2.1)) * H)
	var ang = fd * (0.20 + 0.10 * sin(T * 1.35))
	return [c, ang, L]
static func _put(ctx: Ctx, id: String, c: Vector2, ang: float, L: float, a := 1.0, tint := Color.WHITE, fd := 1.0) -> void:
	var dv = Vector2(sin(ang), -cos(ang))
	var g = c - dv * L * 0.5
	ctx.save(); ctx.globalAlpha *= a
	if tint != Color.WHITE: Art.tint = tint
	EA.held(ctx, id, g.x, g.y, L, ang, EA.edge_side(id) != (1 if fd >= 0 else -1))   # [補丁43 修正] 面向邊，刀口就向邊
	Art.tint = Color.WHITE
	ctx.restore()
static func _aura(ctx: Ctx, c: Vector2, ang: float, L: float, H: float, k := 1.0, gc := YIN) -> void:
	ctx.save(); ctx.translate(c.x, c.y); ctx.rotate(ang)
	for i in 2:
		var s = 1.0 - i * 0.3
		Art.el(ctx, 0, 0, L * 0.30 * s * k, L * 0.62 * s * k, "rgba(%d,%d,%d,%.3f)" % [int(gc.r8), int(gc.g8), int(gc.b8), 0.09 + i * 0.05])
	ctx.restore()
static func _wisps(ctx: Ctx, c: Vector2, H: float, T: float) -> void:
	for i in 2:
		var q = fmod(T * 0.55 + i / 2.0, 1.0)
		var p = c + Vector2(sin(q * 5.0 + i * 2.1) * 0.07 * H, (0.16 - q * 0.30) * H)
		Art.el(ctx, p.x, p.y, H * 0.018 * (1.0 - q * 0.5), H * 0.024 * (1.0 - q * 0.5), "rgba(190,235,255,%.2f)" % ((1.0 - q) * 0.45))
# 拖尾帶：pts 由舊到新；闊度由 w0 漸變到 w1；一個多邊形填色（唔會一粒粒）
static func _ribbon(ctx: Ctx, pts: Array, w0: float, w1: float, col: Color, a: float) -> void:
	if pts.size() < 2: return
	var L = []; var R = []
	for i in pts.size():
		var p: Vector2 = pts[i]
		var d: Vector2 = (pts[mini(i + 1, pts.size() - 1)] - pts[maxi(i - 1, 0)])
		if d.length() < 0.001: d = Vector2(1, 0)
		var nrm = Vector2(-d.y, d.x).normalized()
		var wd = lerpf(w0, w1, float(i) / (pts.size() - 1)) * 0.5
		L.append(p + nrm * wd); R.append(p - nrm * wd)
	R.reverse()
	ctx.fillStyle = "rgba(%d,%d,%d,%.3f)" % [int(col.r8), int(col.g8), int(col.b8), a]
	ctx.beginPath()
	var all = L + R
	ctx.moveTo(all[0].x, all[0].y)
	for i in range(1, all.size()): ctx.lineTo(all[i].x, all[i].y)
	ctx.closePath(); ctx.fill()
static func _ease(x: float) -> float: x = clampf(x, 0, 1); return x * x * (3.0 - 2.0 * x)
# 兵器喺動作某一刻嘅位置：[中心, 角度, 長度, 透明]
static func float_at(k: String, wea: String, foot: Vector2, H: float, fd: float, st: Dictionary, ph: float) -> Array:
	var T = J.num(st.get("T", 0.0))
	var R = rest_of(k, wea, foot, H, fd, T)
	var c0: Vector2 = R[0]; var a0: float = R[1]; var L: float = R[2]
	var act = str(st.get("act", "idle"))
	if act == "idle": return [c0, a0, L, 1.0]
	var tg = st.get("tg")
	var tp = foot + (tg as Vector2) if tg is Vector2 else foot + Vector2(fd * 1.7 * H, -0.5 * H)
	if act == "cast":   # 蓄力：升到背側高位、變大、轉一圈（唔高過頭頂資訊線）
		var k1 = _ease(ph / 0.5)
		var sc = 1.0 + 0.45 * k1
		var top = c0 + Vector2(-fd * 0.02 * H, -0.06 * H * k1)
		var L2 = L * sc
		top.y = maxf(top.y, foot.y + (TOP * H) + L2 * 0.5 + 0.02 * H)
		return [top, a0 + fd * 0.22 * sin(ph * TAU * 2.0), L2, 1.0]
	var big = act == "sk"
	if big:
		c0 = c0 + Vector2(-fd * 0.02 * H, -0.06 * H); L *= 1.45
		c0.y = maxf(c0.y, foot.y + TOP * H + L * 0.5 + 0.02 * H)
	var d = tp - c0; var dist = maxf(1.0, d.length()); var dn = d / dist
	var reach = minf(dist - 0.12 * H, (3.6 if big else 1.0) * H)
	reach = maxf(reach, 0.25 * H)
	var hit = c0 + dn * reach
	# 目標企得高過自己頭頂（透視後面）：撞擊點壓喺自己頭頂資訊線以下，飛行全程唔掠過自己血條／頭頂字
	var ylim = foot.y + TOP * H + L * 0.5 + 0.02 * H
	if hit.y < ylim:
		hit.y = ylim
		dn = (hit - c0).normalized() if (hit - c0).length() > 1.0 else dn
	var aim = atan2(dn.x, -dn.y)
	# 目標喺身前（兵器由背側飛過去）：飛行路線向下彎（經胸腹以下），唔掠過塊臉
	var sg = Vector2(0, (0.30 if big else 0.22) * H) if (hit.x - foot.x) * fd > 0.0 else Vector2.ZERO
	if big:   # 放出：直撲目標（轉 1.5 圈）→ 撞擊 → 飛返
		if ph < 0.45:
			var q = _ease(ph / 0.45)
			return [c0.lerp(hit, q) + sg * sin(q * PI), lerp_angle(a0, aim, minf(1.0, q * 4.0)) + fd * TAU * 1.5 * clampf((q - 0.3) / 0.7, 0, 1), L, 1.0]
		if ph < 0.6: return [hit + dn * 0.04 * H * sin((ph - 0.45) / 0.15 * PI), aim, L, 1.0]
		var q2 = _ease((ph - 0.6) / 0.4)
		return [hit.lerp(c0, q2) + sg * sin(q2 * PI), lerp_angle(aim, a0, q2), lerp(L, L / 1.45, q2), 1.0]
	var sty = EA.atk_style(wea)   # [補丁43] 每款兵器自己嘅打法
	if sty == "swing":   # 揮斬：飛到目標側前、舉高 → 一刀斬落 → 飛返
		var pre = hit - dn * 0.22 * H
		var up = aim - fd * 1.3
		if ph < 0.3:
			var q = _ease(ph / 0.3)
			return [c0.lerp(pre, q) + sg * sin(q * PI), lerp_angle(a0, up, q), L, 1.0]
		if ph < 0.55:
			var q = (ph - 0.3) / 0.25; q = q * q
			return [pre.lerp(hit - dn * 0.12 * H, q), up + fd * 2.3 * q, L, 1.0]
		if ph < 0.65: return [hit - dn * 0.12 * H, up + fd * 2.3, L, 1.0]
		var qs = _ease((ph - 0.65) / 0.35)
		return [(hit - dn * 0.12 * H).lerp(c0, qs) + sg * sin(qs * PI), lerp_angle(up + fd * 2.3, a0, qs), L, 1.0]
	if sty == "spin":   # 轉住撞：一路轉兩圈飛去撞目標 → 彈返
		if ph < 0.55:
			var q = _ease(ph / 0.55)
			return [c0.lerp(hit, q) + sg * sin(q * PI), a0 + fd * TAU * 2.0 * q, L, 1.0]
		if ph < 0.65: return [hit + dn * 0.03 * H * sin((ph - 0.55) / 0.1 * PI), a0, L, 1.0]
		var qp = _ease((ph - 0.65) / 0.35)
		return [hit.lerp(c0, qp) + sg * sin(qp * PI), a0 - fd * TAU * qp, L, 1.0]
	if sty == "throw":   # 飛出去：細後拉 → 打橫轉一圈飛過去 → 撞 → 飛返
		var bk = c0 - dn * 0.05 * H
		if ph < 0.15: return [c0.lerp(bk, _ease(ph / 0.15)), a0, L, 1.0]
		if ph < 0.5:
			var q = _ease((ph - 0.15) / 0.35)
			return [bk.lerp(hit, q) + sg * sin(q * PI), a0 + fd * TAU * q, L, 1.0]
		if ph < 0.6: return [hit, a0, L, 1.0]
		var qt = _ease((ph - 0.6) / 0.4)
		return [hit.lerp(c0, qt) + sg * sin(qt * PI), a0 + fd * TAU * qt, L, 1.0]
	# 直刺（thrust）：後拉 → 直刺 → 撞擊 → 飛返（細幅度）
	var back = c0 - dn * 0.08 * H
	if ph < 0.3:
		var q = _ease(ph / 0.3)
		return [c0.lerp(back, q), lerp_angle(a0, aim, q), L, 1.0]
	if ph < 0.55:
		var q = (ph - 0.3) / 0.25; q = q * q
		return [back.lerp(hit, q) + sg * sin(q * PI), aim, L, 1.0]
	if ph < 0.65: return [hit + dn * 0.03 * H * sin((ph - 0.55) / 0.1 * PI), aim, L, 1.0]
	var q3 = _ease((ph - 0.65) / 0.35)
	return [hit.lerp(c0, q3) + sg * sin(q3 * PI), lerp_angle(aim, a0, q3), L, 1.0]
# 飛行中嘅兵器喺名鬼身體範圍入面 → 畫喺角色後面一層（飛過身後，唔會遮臉）；待機永遠前面
static func float_back(k: String, c: Vector2, foot: Vector2, H: float, fd: float, act: String, ang := 0.0, L := 0.0) -> bool:
	if act == "idle": return false
	var l = -ext(k, -1.0, -0.95, -0.2) - 0.04; var rr = ext(k, 1.0, -0.95, -0.2) + 0.04
	var dv = Vector2(sin(ang), -cos(ang)) * L * 0.5
	for p in [c, c + dv, c - dv]:
		var xi = (p.x - foot.x) / H * fd
		if xi > l and xi < rr: return true
	return false
static func _float(ctx: Ctx, k: String, wea: String, foot: Vector2, H: float, fd: float, st: Dictionary, low: bool, layer := "front") -> Rect2:
	var T = J.num(st.get("T", 0.0))
	var act = str(st.get("act", "idle")); var ph = J.num(st.get("ph", 0.0))
	var gc = EQ.grade_col(EQ.grade_of(wea))
	var P = float_at(k, wea, foot, H, fd, st, ph)
	var c: Vector2 = P[0]; var ang: float = P[1]; var L: float = P[2]
	var r = Rect2(c, Vector2.ZERO)
	if float_back(k, c, foot, H, fd, act, ang, L) != (layer == "back"): return r
	var moving = act == "atk" and ph > 0.25 or act == "sk"
	# 殘影／拖尾
	if not low:
		if moving:
			var n = 6 if act == "sk" else 3
			var stp = 0.035 if act == "sk" else 0.04
			var pts = []
			for j in range(n, 0, -1):
				var Q = float_at(k, wea, foot, H, fd, st, maxf(0.0, ph - j * stp))
				pts.append(Q[0])
				_put(ctx, wea, Q[0], Q[1], Q[2], (0.30 if act == "sk" else 0.22) * (1.0 - float(j) / (n + 1)), gc.lerp(YIN, 0.4) if act == "sk" else YIN, fd)
			if pts.size() >= 2:   # 拖尾帶（技能：等級色、闊；普攻：陰氣色、幼）
				var tp2 = []
				for j in range(n * 2, -1, -1):
					tp2.append(float_at(k, wea, foot, H, fd, st, maxf(0.0, ph - j * stp * 0.5))[0])
				if act == "sk":
					_ribbon(ctx, tp2, H * 0.01, H * 0.16, gc.lerp(YIN, 0.25), 0.28)
					_ribbon(ctx, tp2, H * 0.004, H * 0.06, Color(1, 1, 0.92), 0.45)
				else: _ribbon(ctx, tp2, H * 0.004, H * 0.06, YIN, 0.30)
		else:
			for j in [2]:   # 待機殘影：慢慢跟住（一個，慳效能）
				var Q = float_at(k, wea, foot, H, fd, {"T": T - j * 0.22, "act": act, "tg": st.get("tg")}, ph)
				_put(ctx, wea, Q[0], Q[1], Q[2], 0.10 * j * 0.8, YIN, fd)
		_aura(ctx, c, ang, L, H, 1.35 if act in ["cast", "sk"] else 1.0, gc.lerp(YIN, 0.35) if act in ["cast", "sk"] else YIN)
		if act == "idle": _wisps(ctx, c, H, T)
		if act == "cast":   # 蓄力光圈
			ctx.strokeStyle = "rgba(%d,%d,%d,%.2f)" % [int(gc.r8), int(gc.g8), int(gc.b8), 0.6 * ph]; ctx.lineWidth = H * 0.025
			ctx.beginPath(); ctx.arc(c.x, c.y, L * (0.62 - 0.12 * ph), 0, TAU); ctx.stroke()
	_put(ctx, wea, c, ang, L, 1.0, Color.WHITE, fd)
	# 撞擊閃光
	var imp = (act == "atk" and ph >= 0.55 and ph < 0.72) or (act == "sk" and ph >= 0.45 and ph < 0.66)
	if imp and not low:
		var dv = Vector2(sin(ang), -cos(ang)); var tip = c + dv * L * 0.5
		var q = (ph - (0.55 if act == "atk" else 0.45)) / (0.17 if act == "atk" else 0.21)
		var rr = H * (0.10 if act == "atk" else 0.22) * (0.5 + q)
		ctx.strokeStyle = "rgba(235,250,255,%.2f)" % (0.85 * (1.0 - q)); ctx.lineWidth = H * (0.025 if act == "atk" else 0.04)
		ctx.beginPath(); ctx.arc(tip.x, tip.y, rr, 0, TAU); ctx.stroke()
	var dv2 = Vector2(sin(ang), -cos(ang))
	var mg = Vector2(H * 0.05, H * 0.05)
	for p in [c - dv2 * L * 0.5, c + dv2 * L * 0.5]: r = r.expand(p - mg).expand(p + mg)
	return r

# ---------------- 方案 C：出手才現形 ----------------
static func badge_pos(k: String, foot: Vector2, H: float, fd: float) -> Vector2:   # 頭側角落（背側、頭頂下少少；唔入頭頂資訊、唔遮臉）
	var A = load("res://game/equip/eq_view.gd").anchor(k)
	var hw = J.num(A.get("hw", 0.4))
	var bx = clampf(A.head.x - (hw * 0.5 + 0.08), -0.55, 0.55)   # 圖嘅背側（左）
	return foot + Vector2(bx * H * fd, (A.head.y + 0.22) * H)
static func strike_at(foot: Vector2, H: float, fd: float, act: String, ph: float) -> Array:   # [握位, 角度, 長度, 透明]
	# 角度 0＝向上、正＝向前；起手 a_min（頂唔高過 TOP）、收手 a_max（尖唔低過腳底 0.1H，唔出格）
	var big = act in ["cast", "sk"]
	var L = H * (0.74 if big else 0.62)
	var g = foot + Vector2(fd * 0.22 * H, (-0.36 if big else -0.38) * H)
	var a_min = acos(clampf((g.y - foot.y - TOP * H) / L - 0.02, -1, 1))
	var a_max = acos(clampf((g.y - foot.y + 0.02 * H) / L, -1, 1))
	match act:
		"atk":
			if ph < 0.37:
				var q = ph / 0.37
				return [g, fd * (a_min + 0.15 * (1.0 - q)), L * (0.75 + 0.25 * q), q]
			if ph < 0.62:
				var q2 = _ease((ph - 0.37) / 0.25)
				return [g, fd * lerpf(a_min, a_max, q2), L, 1.0]
			var q3 = (ph - 0.62) / 0.38
			return [g, fd * a_max, L, 1.0 - q3]
		"cast":
			return [g, fd * (a_min + 0.04 * sin(ph * 40.0)), L * (0.6 + 0.4 * _ease(ph)), _ease(ph * 1.3)]
		"sk":
			if ph < 0.4:
				var q4 = _ease(ph / 0.4)
				return [g, fd * lerpf(a_min, a_max, q4), L, 1.0]
			var q5 = (ph - 0.4) / 0.6
			return [g, fd * a_max, L, 1.0 - q5]
	return [g, fd * a_min, L, 0.0]
static func _arc_lim(foot: Vector2, H: float, act: String) -> Array:
	var big = act in ["cast", "sk"]
	var L = H * (0.74 if big else 0.62)
	var gy = (-0.36 if big else -0.38) * H
	return [acos(clampf((gy - TOP * H) / L - 0.02, -1, 1)), acos(clampf((gy + 0.02 * H) / L, -1, 1))]
static func _strike(ctx: Ctx, k: String, wea: String, foot: Vector2, H: float, fd: float, st: Dictionary, low: bool) -> Rect2:
	var act = str(st.get("act", "idle")); var ph = J.num(st.get("ph", 0.0))
	var gc = EQ.grade_col(EQ.grade_of(wea))
	if act == "idle":
		if low: return Rect2(foot, Vector2.ZERO)
		var bp = badge_pos(k, foot, H, fd)
		EA.icon(ctx, wea, bp.x, bp.y, H * 0.13)
		return Rect2(bp + Vector2(-H * 0.07, -H * 0.13), Vector2(H * 0.14, H * 0.14))
	var P = strike_at(foot, H, fd, act, ph)
	var g: Vector2 = P[0]; var ang: float = P[1]; var L: float = P[2]; var a: float = P[3]
	var r = Rect2(g, Vector2.ZERO)
	if a <= 0.01: return r
	var swing = (act == "atk" and ph >= 0.37 and ph < 0.8) or (act == "sk" and ph < 0.8)
	if swing and not low:
		# 刀光：月牙形（由起手角度掃到而家），技能再加一道飛出去嘅劍氣
		var lim = _arc_lim(foot, H, act)
		var a_min: float = lim[0]
		var a1 = absf(ang)
		var fade = a if act == "atk" else clampf(1.0 - (ph - 0.4) / 0.4, 0, 1) if ph > 0.4 else 1.0
		var col = gc.lerp(Color(1, 1, 1), 0.6)
		var outer = []; var inner = []
		var segs = 16
		for j in segs + 1:
			var tt = a_min + (a1 - a_min) * j / segs
			var fa = float(j) / segs
			var dv0 = Vector2(fd * sin(tt), -cos(tt))
			outer.append(g + dv0 * L * 1.02)
			inner.append(g + dv0 * L * (1.0 - (0.10 if act == "atk" else 0.20) * fa))
		_ribbon(ctx, outer, H * 0.005, H * (0.05 if act == "atk" else 0.09), col, 0.55 * fade)
		_ribbon(ctx, inner, H * 0.002, H * 0.025, Color(1, 1, 1), 0.35 * fade)
		if act == "sk" and ph > 0.25:   # 劍氣：月牙由前面飛向目標
			var tg = st.get("tg")
			var tp = (tg as Vector2) if tg is Vector2 else Vector2(fd * 1.6 * H, -0.45 * H)
			var q = clampf((ph - 0.25) / 0.55, 0, 1)
			var c0 = g + Vector2(fd * 0.25 * H, -0.05 * H)
			var cc = c0.lerp(foot + tp, q)
			cc.y = maxf(cc.y, foot.y + (TOP + 0.3) * H)
			ctx.save(); ctx.globalAlpha *= (1.0 - q * 0.6)
			_crescent(ctx, cc, fd, H, col)
			ctx.restore()
		var n = 3
		for j in range(n, 0, -1):   # 殘影（淡）
			var Q = strike_at(foot, H, fd, act, maxf(0.0, ph - j * 0.04))
			ctx.save(); ctx.globalAlpha *= 0.16 * (1.0 - float(j) / (n + 1)) * a
			EA.held(ctx, wea, Q[0].x, Q[0].y, Q[2], Q[1])
			ctx.restore()
	if act == "cast" and not low:   # 現形光
		var dv = Vector2(sin(ang), -cos(ang))
		_aura(ctx, g + dv * L * 0.5, ang, L, H, 1.2, gc.lerp(YIN, 0.3))
	ctx.save(); ctx.globalAlpha *= a
	EA.held(ctx, wea, g.x, g.y, L, ang)
	ctx.restore()
	var dv2 = Vector2(sin(ang), -cos(ang))
	var mg = Vector2(H * 0.05, H * 0.05)
	r = r.expand(g - mg).expand(g + mg).expand(g + dv2 * L - mg).expand(g + dv2 * L + mg)
	return r

static func _crescent(ctx: Ctx, c: Vector2, fd: float, H: float, col: Color) -> void:   # 劍氣月牙
	var o = []; var ii = []
	for j in 15:
		var an = -1.1 + 2.2 * j / 14.0
		o.append(c + Vector2(fd * cos(an) * 0.17 * H, sin(an) * 0.30 * H))
		ii.append(c + Vector2(fd * (cos(an) * 0.10 - 0.02) * H, sin(an) * 0.24 * H))
	ii.reverse()
	var poly = o + ii
	ctx.fillStyle = "rgba(%d,%d,%d,0.55)" % [int(col.r8), int(col.g8), int(col.b8)]
	ctx.beginPath(); ctx.moveTo(poly[0].x, poly[0].y)
	for i in range(1, poly.size()): ctx.lineTo(poly[i].x, poly[i].y)
	ctx.closePath(); ctx.fill()
	ctx.strokeStyle = "rgba(255,255,250,0.7)"; ctx.lineWidth = H * 0.012
	ctx.beginPath(); ctx.moveTo(o[0].x, o[0].y)
	for i in range(1, o.size()): ctx.lineTo(o[i].x, o[i].y)
	ctx.stroke()

# ---------------- 戰鬥單位 → 動態狀態 ----------------
#   rts_sim：windup 0.22s → strike 0.12s → recover 0.25s（WIND／STRIKE／REC）；蓄力 casting {t, dur}
static func state_of(u: Dictionary, T: float, sk_t: float) -> Dictionary:
	var c = u.get("casting")
	if c is Dictionary: return {"T": T, "act": "cast", "ph": clampf(J.num(c.t) / maxf(0.01, J.num(c.dur)), 0, 1)}
	if sk_t >= 0.0: return {"T": T, "act": "sk", "ph": clampf(sk_t / SK_DUR, 0, 1)}
	var a = u.get("anim")
	if a is Dictionary:
		var t = J.num(a.get("t", 0)); var ph = -1.0
		match str(a.get("name")):
			"windup": ph = clampf(t / 0.22, 0, 1) * 0.37
			"strike": ph = 0.37 + clampf(t / 0.12, 0, 1) * 0.2
			"recover": ph = 0.57 + clampf(t / 0.25, 0, 1) * 0.43
		if ph >= 0.0: return {"T": T, "act": "atk", "ph": ph}
	return {"T": T, "act": "idle", "ph": 0.0}
