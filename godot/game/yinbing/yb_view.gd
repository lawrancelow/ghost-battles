# [yinbing] 陰兵漂浮兵器（戰場 SolRep 用）：沿用名鬼 eq_view2 "float" 方案（浮喺面向嗰邊、普攻飛去打再飛返），
#   兵器圖用 eq_art 程序圖（id "ybw_<形狀>"），刃口方向跟 eq_art EDGE 規矩（面向邊，刃口就向邊）。
#   穿戴件（盾、箭袋、藥箱、葫蘆）已經畫咗入立繪，呢度唔另外疊。
#   座標：SolRep 嘅 base 空間（原點＝腳底、H＝畫出嚟嘅立繪高）；dir＝面向（+1 右／−1 左）
#   刀盾／長兵：普攻用 eq_view2.float_at（揮斬／直刺）；弓弩：唔飛出去，喺身邊瞄住目標、出手時後座；醫護：藥具喺身邊浮
#   全部 static；冇 class_name（熱更新規矩）：const YBV = preload("res://game/yinbing/yb_view.gd")
extends RefCounted

const YB = preload("res://game/yinbing/yb_data.gd")
const EV2 = preload("res://game/equip/eq_view2.gd")
const EA = preload("res://game/equip/eq_art.gd")
const BA = preload("res://game/barracks/bk_art.gd")
static var off := false   # 測試／對照：唔畫漂浮兵器
static var LAST := {}     # 測試：最後一次每個 look 畫嘅 [中心, 角度, 長度, 鏡像, 動作]

static func wea_of(c: String, r: String) -> String:
	var sh = str(YB.cell(c, r).get("shape", ""))
	return EA.YBW + sh if sh != "" else ""
# 輪廓（俾 eq_view2.rest_of／float_back 用）：按落腳點對齊（唔係圖中間），以畫出嚟嘅高為 1
static func pkey(look: String) -> String:
	var k = "yb:" + look
	if EV2._prof.has(k): return k
	var rows = []
	var tex = BA.yb_tex(look)
	var img: Image = tex.get_image() if tex != null else null
	if img != null and img.get_height() >= 8:
		img = img.duplicate()
		if img.is_compressed(): img.decompress()
		var ax = float(BA._yb_ax.get(look, img.get_width() * 0.5))
		var hs = 32; var sc = float(hs) / img.get_height()
		var ws = maxi(4, int(round(img.get_width() * sc)))
		img.resize(ws, hs, Image.INTERPOLATE_BILINEAR)
		for y in hs:
			var l = 99.0; var rr = -99.0
			for x in ws:
				if img.get_pixel(x, y).a > 0.35:
					l = minf(l, (x - ax * sc) / hs); rr = maxf(rr, (x + 1 - ax * sc) / hs)
			rows.append([l, rr] if rr > -99.0 else [0.0, 0.0])
	EV2._prof[k] = rows
	return k
# 畫出嚟嘅立繪高（衛兵 340px 圖 → BA.H；雜兵／士兵 300px 圖矮啲；冇新圖＝BA.H）
static func h_of(look: String) -> float:
	var t = BA.yb_tex(look)
	return BA.H * (float(t.get_height()) / BA.YB_REF if t != null else 1.0)

# 兵器喺某一刻嘅擺位：[中心, 角度(0＝向上), 長度, 鏡像(刃口換邊), 動作]
static func pose_of(look: String, c: String, wea: String, H: float, fd: float, st: Dictionary) -> Array:
	var k = pkey(look)
	var foot = Vector2.ZERO
	var T = J.num(st.get("T", 0.0))
	var act = str(st.get("act", "idle"))
	var mir = EA.edge_side(wea) != (1 if fd >= 0 else -1)
	if c == "jin" or c == "zhong":
		var P = EV2.float_at(k, wea, foot, H, fd, st, J.num(st.get("ph", 0.0)))
		return [P[0], P[1], P[2], mir, act]
	var R = EV2.rest_of(k, wea, foot, H, fd, T)
	var cc: Vector2 = R[0]; var L: float = R[2]; var ang = 0.0
	if c == "yuan":
		L = H * (0.40 if wea.ends_with("xbow_iron") else 0.42)
		var tg = st.get("tg")
		var d = (tg as Vector2) - cc if tg is Vector2 else Vector2(fd, 0)
		if wea.ends_with("xbow_iron"):   # 弩：弩身向目標
			ang = atan2(d.x, -d.y)
			ang = fd * clampf(absf(ang), PI * 0.5 - 0.6, PI * 0.5 + 0.6) if absf(ang) > 0.01 else fd * PI * 0.5
		elif wea.ends_with("sling"):   # 投石索：喺身邊吊住，出手時打圈
			ang = fd * 0.15 + (fd * TAU * J.num(st.get("ph", 0.0)) if act == "atk" else 0.0)
		else:   # 弓：弓背向目標（直企，跟住目標上下斜少少）
			var a = d.angle() if fd > 0 else wrapf(d.angle() - PI, -PI, PI)
			ang = clampf(a, -0.6, 0.6)
		if act == "atk":   # 出手：拉弓後座
			var ph = J.num(st.get("ph", 0.0))
			var q = sin(clampf(ph / 0.57, 0, 1) * PI)
			cc -= (d.normalized() if d.length() > 0.1 else Vector2(fd, 0)) * 0.05 * H * q
		return [cc, ang, L, mir, act]
	# 醫護：藥具細細浮喺身邊（高少少，唔遮臉）
	L = H * 0.30
	cc += Vector2(fd * 0.02 * H, 0.06 * H)
	ang = fd * 0.06 * sin(T * 1.7)
	return [cc, ang, L, mir, "idle"]

# SolRep._draw 用：layer "back"（飛過身後）先畫、然後立繪、再 "front"
static func draw(ci: CanvasItem, base: Transform2D, look: String, u: Dictionary, fd: float, T: float, rep_off: Vector2, layer: String, rep := 0) -> void:
	if off or look == "" or not (u is Dictionary): return
	var p = look.split("_")
	if p.size() < 3: return
	var c = p[1]; var r = p[2]
	var wea = wea_of(c, r)
	if wea == "": return
	var H = h_of(look)
	var st = EV2.state_of(u, T, -1.0)
	if c == "yi": st = {"T": T, "act": "idle", "ph": 0.0}
	if st.act == "atk" and rep > 0: st["ph"] = maxf(0.0, J.num(st.ph) - 0.06 * rep)
	st["tg"] = _tgv(u, rep_off, base)
	var P = pose_of(look, c, wea, H, fd, st)
	var cc: Vector2 = P[0]; var ang: float = P[1]; var L: float = P[2]
	var back = EV2.float_back(pkey(look), cc, Vector2.ZERO, H, fd, str(P[4]), ang, L)
	if back != (layer == "back"): return
	LAST[look] = P
	var ctx = Ctx.new(ci, base)
	# 陰氣淡光（細細個，唔搶畫面）
	ctx.save(); ctx.translate(cc.x, cc.y); ctx.rotate(ang)
	Art.el(ctx, 0, 0, L * 0.26, L * 0.56, "rgba(168,224,255,0.10)")
	ctx.restore()
	var dv = Vector2(sin(ang), -cos(ang))
	var g = cc - dv * L * 0.5
	EA.held(ctx, wea, g.x, g.y, L, ang, P[3])
	ci.draw_set_transform_matrix(base)
# 目標身體中間（相對腳底，base 空間）
static func _tgv(u: Dictionary, rep_off: Vector2, base: Transform2D):
	var a = u.get("anim")
	var tg = a.get("tg") if a is Dictionary else null
	if not (tg is Dictionary) or J.num(tg.get("hp", 0)) <= 0: tg = u.get("tg")
	if not (tg is Dictionary) or not (tg.get("p") is Vector2) or not (u.get("p") is Vector2): return null
	var hh = 40.0 if J.t(tg.get("minion")) else (78.0 if J.t(tg.get("boss")) else 56.0)
	var w = (tg.p as Vector2) + Vector2(0, -hh * 0.5) - (u.p as Vector2).round() - rep_off
	return base.affine_inverse() * w
