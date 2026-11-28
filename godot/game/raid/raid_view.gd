# [raid] 村子被惡鬼襲擾：畫面（預告橫條、損壞外觀、惡鬼、迎戰／修理點擊、提示）
# ui/nv_village.gd _build 尾叫 attach(self)；zone_tap 開頭叫 tap(main, 世界座標)；_draw_static 用 tilt() 令損壞建築歪斜。
# 暫代圖：損壞外觀（黑煙、裂痕、歪斜、變黑、瓦礫、火）全部程序畫（本檔 _draw_damage），之後有圖只改呢個函數。
extends Node

const RAID = preload("res://game/raid/raid.gd")
const ZD = preload("res://game/zone/zone_data.gd")
const ZV = preload("res://game/zone/zone_view.gd")

static var TILT := {}          # statics 鍵（"b_wood"／"cb_b_paper"）→ [角度, 支點]
static var hits: Array = []    # [[Rect2 世界, "fight"/"repair", key]]
static var _me = null

var nv = null
var layer: Control
var X := Transform2D.IDENTITY   # 世界 → 本層
var bar: PanelContainer
var bar_l: Label
var _sig := ""
var _t := 0.0

static func attach(v) -> void:
	if v == null or v.has_node("RaidView"): return
	var n = load("res://game/raid/raid_view.gd").new(); n.name = "RaidView"
	n.nv = v
	v.add_child(n)
	n._build()
	_me = weakref(n)

func _build() -> void:
	# 畫喺村子（同大排檔嵌入畫面）上面：夜色唔會蓋住煙火；上面 HUD 嗰截裁走
	layer = Lay.new(); layer.name = "RaidFx"; layer.fn = func(c): _draw(c)
	layer.anchor_right = 1; layer.anchor_bottom = 1; layer.clip_contents = true
	layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	nv.add_child(layer)
	bar = PanelContainer.new(); bar.name = "RaidBar"; bar.visible = false
	var sb = StyleBoxFlat.new(); sb.bg_color = Color(0.32, 0.05, 0.04, 0.93); sb.border_color = Color("#ffcf7a"); sb.set_border_width_all(2)
	sb.set_corner_radius_all(6); sb.content_margin_left = 12; sb.content_margin_right = 12; sb.content_margin_top = 7; sb.content_margin_bottom = 7
	sb.shadow_color = Color(0, 0, 0, 0.5); sb.shadow_size = 6
	bar.add_theme_stylebox_override("panel", sb)
	bar.anchor_left = 0; bar.anchor_right = 1; bar.offset_left = 8; bar.offset_right = -8
	bar_l = Label.new(); bar_l.autowrap_mode = TextServer.AUTOWRAP_ARBITRARY; bar_l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	bar_l.add_theme_font_size_override("font_size", 18); bar_l.add_theme_color_override("font_color", Color("#fff0d0"))
	bar_l.add_theme_color_override("font_outline_color", Color(0.1, 0.02, 0.02)); bar_l.add_theme_constant_override("outline_size", 4)
	bar.add_child(bar_l)
	bar.mouse_filter = Control.MOUSE_FILTER_STOP
	bar.gui_input.connect(_bar_input)
	nv.add_child(bar)

class Lay extends Control:
	var fn: Callable
	func _process(_dt: float) -> void:
		if is_visible_in_tree(): queue_redraw()
	func _draw() -> void:
		if fn.is_valid(): fn.call(self)

# ================= 每幀 =================
func _process(dt: float) -> void:
	_t += dt
	_eat_news()
	if nv == null or not is_instance_valid(nv) or not nv.visible: return
	var on = ZD.on() and nv.get("zone")
	layer.visible = on
	var n = nv.get_child_count()   # 永遠喺最上（大排檔嵌入畫面、按鈕之上）
	if layer.get_index() != n - 2 or bar.get_index() != n - 1:
		nv.move_child(layer, -1); nv.move_child(bar, -1)
	var top = float(nv._zone_top_px()) if nv.has_method("_zone_top_px") else 0.0
	if absf(layer.offset_top - top) > 0.5: layer.offset_top = top
	X = Transform2D(0, Vector2(0, -layer.offset_top)) * nv.world.transform
	_sync_tilt()
	_update_bar(on)

# 損壞建築：歪斜＋變黑（statics 節點）
func _sync_tilt() -> void:
	var want = {}
	var r = RAID._peek()
	if r != null and ZD.on():
		for key in RAID.all_targets():
			var s = RAID.state_of(key)
			if s == "": continue
			var a = (0.07 if s == "down" else 0.12) * (1.0 if hash(key) % 2 == 0 else -1.0)
			var mod = Color(0.66, 0.6, 0.58) if s == "down" else Color(0.48, 0.43, 0.42)
			if key.begins_with("b:"):
				var id = key.substr(2)
				want["b_" + id] = [a, RAID.tpos(key), mod]
			elif key.begins_with("z:"):
				var CB = load("res://game/outpost/chain_bld.gd")
				for b in RAID.zone_bids(key):
					var p = CB.pos(str(b))
					if p.x < -900.0 or CB.CF.is_field(str(b)): continue
					want["cb_" + str(b)] = [a * 0.8, p, mod]
	var sig = str(want)
	var st = nv.get("statics")
	if sig != _sig and st is Dictionary:
		for k in TILT.keys():
			if not want.has(k) and st.has(k):
				st[k]["dirty"] = true; st[k].node.modulate = Color.WHITE
		for k in want:
			if st.has(k): st[k]["dirty"] = true
		_sig = sig
	TILT.clear()
	for k in want:
		TILT[k] = [want[k][0], want[k][1]]
		if st is Dictionary and st.has(k) and st[k].node.modulate != want[k][2]: st[k].node.modulate = want[k][2]

# nv_village._draw_static：損壞嘅建築喺地基支點度歪
static func tilt(key: String, X: Transform2D, y: float) -> Transform2D:
	var e = TILT.get(key)
	if e == null: return X
	var P: Vector2 = e[1]
	return Transform2D(0, P - Vector2(0, y)) * Transform2D(float(e[0]), Vector2.ZERO) * Transform2D(0, -P)

# ================= 上方預告橫條 =================
func _bar_text() -> String:
	var ph = RAID.phase(); var c = RAID.cur()
	if not (c is Dictionary): return ""
	var key = str(c.tgt); var nm = RAID.tname(key); var fn = RAID.foe_name(int(J.num(c.get("ci", RAID.ci()))))
	var sec = int(ceil(RAID.left()))
	if ph == "warn":
		return RAID.L("%s有一隊%s正行緊過嚟！目標：%s　%d 秒", "%s有一隊%s正走過來！目標：%s　%d 秒") % [RAID.dir_txt(str(c.dir)), fn, nm, sec]
	if ph == "siege":
		var warn = ""
		if RAID.streak(key) + 1 >= int(RAID.TUNE.break_n): warn = RAID.L("（再失守就壞咗！）", "（再失守就壞了！）")
		if J.num(c.get("t", 0)) < float(RAID.TUNE.walk):
			return RAID.L("陰兵守唔住！%s快到%s，快啲去迎戰%s　%d 秒", "陰兵守不住！%s快到%s，快去迎戰%s　%d 秒") % [fn, nm, warn, sec]
		return RAID.L("%s圍住咗%s！快啲親自迎戰，唔係就要停工%s　%d 秒", "%s圍住了%s！快親自迎戰，不然就要停工%s　%d 秒") % [fn, nm, warn, sec]
	return ""
func _update_bar(on: bool) -> void:
	var tx = _bar_text() if on and not load("res://game/zone/zone_battle.gd").fighting() else ""   # 迎戰緊：收埋（圍住倒數停咗）
	if tx == "":
		if bar.visible: bar.visible = false
		return
	bar_l.text = tx
	var top = 6.0
	if nv.has_method("_zone_top_px"): top = float(nv._zone_top_px()) + 6.0
	bar.offset_top = top
	bar.modulate.a = 0.82 + 0.18 * sin(_t * 5.0) if RAID.phase() == "siege" else 1.0
	if not bar.visible: bar.visible = true
func _bar_input(ev: InputEvent) -> void:
	if ev is InputEventMouseButton and ev.button_index == MOUSE_BUTTON_LEFT and not ev.pressed:
		var c = RAID.cur()
		if c is Dictionary and nv.has_method("zone_cam"):
			var p = RAID.siege_pos() if RAID.phase() == "siege" else RAID.tpos(str(c.tgt))
			nv.zone_cam().center_on(p)
		bar.accept_event()

# ================= 畫 =================
func _draw(c: CanvasItem) -> void:
	hits.clear()
	if not ZD.on(): return
	var r = RAID._peek()
	if r == null: return
	var ctx = Ctx.new(c, X)
	c.draw_set_transform_matrix(X)
	var px = ZV._name_px(nv) if nv != null else 17
	var vr: Rect2 = nv.view_rect().grow(160)
	for key in RAID.all_targets():
		var s = RAID.state_of(key)
		if s == "": continue
		for p in _spots(key):
			if vr.has_point(p[0]): _draw_damage(c, ctx, key, p[0], p[1], s)
		var at = _spots(key)[0][0]; var w = float(_spots(key)[0][1])
		var py = at.y - 125.0 if key == "market" else at.y + px * 1.1   # 大排檔檔口下面有名牌：牌放上面
		if not vr.has_point(at):
			if s == "broken": hits.append([_bld_rect(at, w), "repair", key])
			continue
		if s == "down":
			ZV._plate(ctx, RAID.L("停工 %s", "停工 %s") % _mmss(RAID.down_left(key)), at.x, py, px, "rgba(40,30,26,.92)", "#ffd8a8")
		else:
			ctx.globalAlpha = 0.8 + 0.2 * sin(_t * 4.0)
			var pr = ZV._plate(ctx, RAID.L("壞咗・撳我修理", "壞了・點我修理"), at.x, py, px, "rgba(150,34,26,.96)")
			ctx.globalAlpha = 1.0
			hits.append([_bld_rect(at, w).merge(pr), "repair", key])
	var ph = RAID.phase(); var cu = RAID.cur()
	if cu is Dictionary and (ph == "warn" or ph == "siege") and not load("res://game/zone/zone_battle.gd").fighting() and not load("res://game/rts/rts.gd").has_kind("raid"):   # [rts] 迎擊緊：惡鬼由 rts 畫
		var at2 = RAID.tpos(str(cu.tgt))
		_target_mark(c, ctx, at2, ph, px)
		if ph == "siege": _draw_foes(c, ctx, cu, px)

static func _mmss(s: float) -> String:
	var n = int(ceil(s)); return "%d:%02d" % [n / 60, n % 60]
# 每個目標要畫損壞嘅位置：[[支點, 闊], …]
func _spots(key: String) -> Array:
	if key.begins_with("b:"):
		var id = key.substr(2)
		return [[RAID.tpos(key), float(Art.BW.get(id, 106))]]
	if key == "market":   # 大排檔：已開嘅檔口（最多 3 個）冒煙、翻枱；冇就櫃台
		var o2 = []
		for q in RAID.market_spots(): o2.append([q, 110.0])
		if o2.is_empty(): o2.append([RAID.tpos(key), 150.0])
		return o2
	var CB = load("res://game/outpost/chain_bld.gd"); var o = []
	for b in RAID.zone_bids(key):
		var p = CB.pos(str(b))
		if p.x < -900.0 or CB.CF.is_field(str(b)): continue
		o.append([p, 100.0])
	if o.is_empty(): o.append([RAID.tpos(key), 120.0])
	return o
static func _bld_rect(at: Vector2, w: float) -> Rect2: return Rect2(at.x - w * 0.55, at.y - w * 0.95, w * 1.1, w * 1.05)

static func _h(i: int, k: int) -> float: return fmod(absf(sin(float(i) * 12.9898 + float(k) * 78.233) * 43758.5453), 1.0)
# 損壞外觀（程序畫，暫代圖）：黑煙、裂痕、瓦礫；壞咗再加火、跌落嘅木板
func _draw_damage(c: CanvasItem, _ctx: Ctx, key: String, at: Vector2, w: float, s: String) -> void:
	var hk = absi(hash(key + str(at))) % 997
	var broken = s == "broken"
	var hgt = w * 0.82
	var top = at + Vector2(0, -hgt)
	# 地上瓦礫、焦黑
	var sc = Color(0.08, 0.06, 0.06, 0.55 if broken else 0.38)
	c.draw_set_transform_matrix(X * Transform2D(0, Vector2(1.0, 0.32), 0, at + Vector2(0, 2)))
	c.draw_circle(Vector2.ZERO, w * (0.62 if broken else 0.5), sc)
	c.draw_set_transform_matrix(X)
	for i in (9 if broken else 5):
		var rx = (_h(hk, i) - 0.5) * w * 1.0; var ry = (_h(hk, i + 40) - 0.5) * 10.0
		var rs = 3.0 + _h(hk, i + 80) * (7.0 if broken else 4.0)
		var pts = PackedVector2Array([at + Vector2(rx - rs, ry + 2), at + Vector2(rx - rs * 0.3, ry - rs * 0.8), at + Vector2(rx + rs * 0.7, ry - rs * 0.5), at + Vector2(rx + rs, ry + 2)])
		c.draw_colored_polygon(pts, Color(0.22, 0.18, 0.16).lerp(Color(0.05, 0.04, 0.04), _h(hk, i + 9)))
	# 裂痕（喺建築正面；大排檔係露天檔口，唔畫）
	var nc = 0 if key == "market" else (4 if broken else 2)
	for j in nc:
		var x0 = at.x + (_h(hk, j + 3) - 0.5) * w * 0.6
		var y0 = at.y - hgt * (0.55 + 0.35 * _h(hk, j + 7))
		var pts2 = PackedVector2Array([Vector2(x0, y0)])
		var p = Vector2(x0, y0)
		for k in 5:
			p += Vector2((_h(hk, j * 10 + k) - 0.5) * 14.0, hgt * 0.09 + _h(hk, j * 10 + k + 50) * 6.0)
			pts2.append(p)
		c.draw_polyline(pts2, Color(0.04, 0.02, 0.02, 0.95), 3.6 if broken else 3.0, true)
		var hl = PackedVector2Array()
		for q in pts2: hl.append(q + Vector2(1.6, 0.6))
		c.draw_polyline(hl, Color(1.0, 0.62, 0.3, 0.55 if broken else 0.4), 1.0, true)   # 裂縫邊受光（橙紅），暗處都見到
		if broken:   # 分叉
			var m2 = pts2[2]
			c.draw_polyline(PackedVector2Array([m2, m2 + Vector2(10 * (1 if j % 2 else -1), 9), m2 + Vector2(16 * (1 if j % 2 else -1), 22)]), Color(0.05, 0.03, 0.03, 0.85), 1.8, true)
	# 壞咗：跌落嘅木板＋火
	if broken:
		for i in 3:
			var bx = at.x + (_h(hk, i + 20) - 0.5) * w * 0.8; var by = at.y - 4.0 - i * 3.0
			var ang = (_h(hk, i + 30) - 0.5) * 1.6
			c.draw_set_transform_matrix(X * Transform2D(ang, Vector2(bx, by)))
			c.draw_rect(Rect2(-w * 0.18, -3.5, w * 0.36, 7.0), Color(0.36, 0.24, 0.15))
			c.draw_rect(Rect2(-w * 0.18, -3.5, w * 0.36, 7.0), Color(0.08, 0.05, 0.03), false, 1.4)
			c.draw_set_transform_matrix(X)
		for i in 3:
			var fx = at.x + (_h(hk, i + 60) - 0.5) * w * 0.7
			var fy = at.y - hgt * (0.15 + 0.3 * _h(hk, i + 61))
			var fl = 1.0 + 0.25 * sin(_t * 11.0 + i * 2.1)
			var f1 = PackedVector2Array([Vector2(fx - 7, fy), Vector2(fx, fy - 20 * fl), Vector2(fx + 7, fy)])
			var f2 = PackedVector2Array([Vector2(fx - 4, fy), Vector2(fx, fy - 12 * fl), Vector2(fx + 4, fy)])
			c.draw_colored_polygon(f1, Color(0.95, 0.42, 0.12, 0.85))
			c.draw_colored_polygon(f2, Color(1.0, 0.85, 0.35, 0.9))
	# 黑煙（由屋頂升上去）
	var ns = 14 if broken else 10
	for i in ns:
		var ph = fmod(_t * (0.26 if broken else 0.2) + float(i) / ns + _h(hk, i + 90) * 0.1, 1.0)
		var sx = top.x + (_h(hk, i + 70) - 0.5) * w * 0.5 + sin(_t * 1.3 + i) * 6.0 + ph * 30.0
		var sy = top.y + 10.0 - ph * (140.0 if broken else 110.0)
		var rad = 9.0 + ph * (30.0 if broken else 24.0)
		var a = minf(1.0, (1.0 - ph) * 2.2) * minf(1.0, ph * 6.0 + 0.2) * (0.72 if broken else 0.6)
		c.draw_circle(Vector2(sx, sy), rad, Color(0.16, 0.14, 0.14, a))
		c.draw_circle(Vector2(sx - rad * 0.3, sy - rad * 0.3), rad * 0.6, Color(0.42, 0.39, 0.38, a * 0.55))   # 灰白受光面：夜晚都睇到

# 目標標記：紅圈（預告＝虛線閃，圍住＝實心紅光）
func _target_mark(c: CanvasItem, ctx: Ctx, at: Vector2, ph: String, px: int) -> void:
	var k = 0.5 + 0.5 * sin(_t * (4.0 if ph == "warn" else 7.0))
	c.draw_set_transform_matrix(X * Transform2D(0, Vector2(1.0, 0.38), 0, at + Vector2(0, 2)))
	var rr = 78.0 + 8.0 * k
	if ph == "siege": c.draw_circle(Vector2.ZERO, rr, Color(0.8, 0.08, 0.05, 0.18 + 0.12 * k))
	c.draw_arc(Vector2.ZERO, rr, 0, TAU, 48, Color(1.0, 0.25, 0.15, 0.55 + 0.4 * k), 5.0, true)
	c.draw_set_transform_matrix(X)
	if ph == "warn":
		ctx.globalAlpha = 0.65 + 0.35 * k
		ZV._plate(ctx, RAID.L("！%s要嚟", "！%s要來") % RAID.foe_name(), at.x, at.y - 150.0, px, "rgba(160,30,24,.95)")
		ctx.globalAlpha = 1.0

# 惡鬼：行埋嚟 → 圍住目標（撳就迎戰）
func _draw_foes(c: CanvasItem, ctx: Ctx, cu: Dictionary, px: int) -> void:
	var ks: Array = cu.ks if cu.get("ks") is Array and cu.ks.size() else ["egui"]
	var at = RAID.tpos(str(cu.tgt))
	var p = RAID.siege_pos()
	var arrived = J.num(cu.get("t", 0)) >= float(RAID.TUNE.walk)
	var off = [Vector2(-58, 8), Vector2(0, 26), Vector2(58, 8)]
	var g = ctx.createRadialGradient(p.x, p.y - 40, 6, p.x, p.y - 40, 110)
	g.addColorStop(0, "rgba(200,30,30,.36)"); g.addColorStop(1, "rgba(200,30,30,0)")
	ctx.fillStyle = g; ctx.fillRect(p.x - 110, p.y - 150, 220, 220)
	var fl = (at - ZD.v2(cu.get("from", [at.x, at.y]))).x < 0
	for i in [0, 2, 1]:
		var o: Vector2 = off[i]
		var bob = sin(_t * (9.0 if not arrived else 3.0) + i) * (4.0 if not arrived else 3.0)
		var jit = Vector2(sin(_t * 1.7 + i * 2.0) * 6.0, 0) if arrived else Vector2.ZERO
		Art.draw_char(ctx, str(ks[i % ks.size()]), p.x + o.x + jit.x, p.y + o.y + bob, 1.0, {"t": _t + i, "flip": fl, "seed": "raid%d" % i})
	ctx.globalAlpha = 0.75 + 0.25 * sin(_t * 3.0)
	var up = RAID.PO.is_tkey(str(cu.tgt))   # [post] 駐點：字放喺頭頂，下面留返畀木牌
	var pr = ZV._plate(ctx, RAID.L("撳我迎戰", "點我迎戰"), p.x, (p.y - 92.0 - px * 1.7) if up else (p.y + px * 2.4), px, "rgba(150,40,30,.95)")
	ctx.globalAlpha = 1.0
	var nm = RAID.L("%s　戰力 %d", "%s　戰力 %d") % [RAID.foe_name(), int(J.num(cu.get("pow", 0)))]
	if up: ZV._plate(ctx, nm, p.x, p.y - 92.0, px, "rgba(40,14,12,.85)", "#ffb0a0")
	else: ZV._txt(ctx, nm, p.x, p.y + px * 1.0, px, "#ffb0a0")
	hits.insert(0, [Rect2(p.x - 110, p.y - 150, 220, 200).merge(pr), "fight", str(cu.tgt)])

# ================= 點擊（世界座標）：回 true＝處理咗 =================
static func tap(main, w: Vector2) -> bool:
	if not ZD.on(): return false
	if load("res://game/zone/zone_battle.gd").fighting(): return false
	for h in hits:
		if not (h[0] as Rect2).has_point(w): continue
		if h[1] == "fight":
			var r = RAID.start_fight()
			if r == "ok" and main != null and main.has_method("close_sheet"): main.close_sheet()
			return true
		if h[1] == "repair":
			open_repair(main, str(h[2])); return true
	return false

static func open_repair(main, key: String) -> void:
	if main == null or not main.has_method("open_sheet"): return
	main.open_sheet(RAID.L("修理：%s", "修理：%s") % RAID.tname(key), func(): pass)
	var body = main.sheet_body
	var R = func(bb: String, sz := 16): var r = UIKit.rich(bb, sz, UIKit.INKTXT); body.add_child(r); return r
	R.call(RAID.L("%s被%s連續襲擾 %d 次，壞咗。[b]修好之前唔可以運作。[/b]", "%s被%s連續襲擾 %d 次，壞了。[b]修好之前不能運作。[/b]") % [RAID.tname(key), RAID.foe_name(), int(RAID.TUNE.break_n)], 16)
	var cst = RAID.repair_cost(key)
	R.call(RAID.L("修理費：%s", "修理費：%s") % RAID.cost_txt(cst), 16)
	R.call(RAID.L("下次記得派陰兵守村，或者惡鬼一到就親自迎戰。", "下次記得派陰兵守村，或者惡鬼一到就親自迎戰。"), 14)
	body.add_child(UIKit.hsep())
	var b = UIKit.btn(RAID.L("修理", "修理"), "gold")
	b.disabled = not RAID.can_repair(key)
	b.pressed.connect(func():
		if RAID.repair(key):
			main.close_sheet(); Snd.play("build")
			main.refresh())
	body.add_child(b)
	if b.disabled: R.call("[color=#a8322a]%s[/color]" % RAID.L("材料唔夠", "材料不夠"), 14)

# ================= 提示 =================
func _main():
	return get_tree().root.get_node_or_null("Main") if is_inside_tree() else null
func _eat_news() -> void:
	if RAID.NEWS.is_empty(): return
	var m = _main()
	while RAID.NEWS.size():
		var e = RAID.NEWS.pop_front()
		if m == null: continue
		var nm = RAID.tname(str(e.get("tgt", ""))); var fn = RAID.foe_name()
		match str(e.k):
			"warn":
				Snd.play("gong")
			"siege":
				m.show_toast(RAID.L("陰兵守唔住！%s衝去%s，撳上面紅色條或者撳惡鬼親自迎戰。", "陰兵守不住！%s衝向%s，點上面紅色條或者點惡鬼親自迎戰。") % [fn, nm])
			"repel":
				if str(e.get("how")) == "fight": m.show_banner(RAID.L("擊退%s！", "擊退%s！") % fn)
				m.show_toast(RAID.L("%s擊退咗%s，%s保住咗。冥幣 +%d", "%s擊退了%s，%s保住了。冥幣 +%d") % [RAID.L("陰兵", "陰兵") if str(e.get("how")) == "auto" else RAID.L("你", "你"), fn, nm, int(J.num(e.get("coins", 0)))])
			"down":
				m.show_toast(RAID.L("%s被%s搞到停工 %d 分鐘（連續第 %d 次，第 %d 次會壞）", "%s被%s搞到停工 %d 分鐘（連續第 %d 次，第 %d 次會壞）") % [nm, fn, int(ceil(float(RAID.TUNE.stop) / 60.0)), int(e.get("n", 1)), int(RAID.TUNE.break_n)])
			"broken":
				m.show_banner(RAID.L("%s壞咗！", "%s壞了！") % nm)
				m.show_toast(RAID.L("%s連續被襲擾 %d 次，壞咗。撳佢修理，唔修唔運作。", "%s連續被襲擾 %d 次，壞了。點它修理，不修不能運作。") % [nm, int(RAID.TUNE.break_n)])
			"resume":
				m.show_toast(RAID.L("%s恢復開工", "%s恢復開工") % nm)
			"fixed":
				m.show_toast(RAID.L("%s修好咗，恢復運作", "%s修好了，恢復運作") % nm)
