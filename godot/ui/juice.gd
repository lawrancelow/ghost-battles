# [juice] 爽感包（會議第一批）：數字滾動、連續入帳音高遞升、震屏、手機震動、粒子慶祝、飛向頂欄、王登場、終結慢鏡、戰力演出
#   全部 static；冇 class_name（熱更新）。用法：load("res://ui/juice.gd").xxx(...)
#   開關：設定 → 畫面 →「爽感特效」(PF.juice)、「手機震動」(PF.vibrate)；關咗全部退返舊表現，數值唔受影響
#   音效全部由 Snd 即場合成（冇外部素材，可商用）
extends RefCounted

const PF = preload("res://game/settings/prefs.gd")
const ROLL = preload("res://ui/juice_roll.gd")
const SEMI := [0, 2, 4, 5, 7, 9, 11, 12, 14, 16]   # do re mi fa sol la ti do re mi

static var force := -1          # 測試：-1 跟設定；0 關；1 開
static var log: Array = []      # 測試用：做過乜（[種類, 數值]）
static var _chime_n := 0
static var _chime_t := -10000
static var _slow_until := 0

static func on() -> bool:
	if force >= 0: return force == 1
	PF.load_pref(); return PF.juice
static func _log(k: String, v = null) -> void:
	log.append([k, v])
	if log.size() > 400: log = log.slice(200)
static func _tree() -> SceneTree: return Engine.get_main_loop() as SceneTree
static func _main() -> Node:
	var t = _tree()
	return t.root.get_node_or_null("Main") if t != null else null

# ---------------- 手機震動 ----------------
static func vib(ms: int) -> void:
	PF.load_pref()
	if not PF.vibrate: return
	_log("vib", ms)
	if OS.has_feature("mobile"): Input.vibrate_handheld(ms)

# ---------------- 數字滾動 ----------------
# 喺 label 上滾到新數（逐位由左至右停、輕微衝過頭再回彈）；fmt＝數字→字串
static func roll(lb: Label, to: float, fmt: Callable, dur := 0.55) -> void:
	if lb == null or not is_instance_valid(lb): return
	var r = lb.get_node_or_null("JuiceRoll")
	if not on():
		if r != null: r.queue_free()
		lb.text = fmt.call(to); return
	if r == null:
		r = ROLL.new(); r.name = "JuiceRoll"; r.fmt = fmt; r.cur = to; lb.add_child(r)
		lb.text = fmt.call(to); return
	r.fmt = fmt; r.go(to, dur)

# ---------------- 連續入帳：音高遞升 ----------------
static func chime(kind := "coin") -> void:
	if not on(): Snd.play(kind); return
	var now = Time.get_ticks_msec()
	_chime_n = _chime_n + 1 if now - _chime_t < 1300 else 0
	_chime_t = now
	var st = SEMI[mini(_chime_n, SEMI.size() - 1)]
	_log("chime", st)
	Snd.play_p(kind, pow(2.0, st / 12.0))

# ---------------- 震屏（Control／Node2D 都得；回彈返原位） ----------------
static func shake(n: Node, amp := 6.0, dur := 0.28) -> void:
	if not on() or n == null or not is_instance_valid(n) or not ("position" in n): return
	if n.has_meta("jshake"): return
	_log("shake", amp)
	var p0 = n.position; n.set_meta("jshake", true)
	var tw = n.create_tween()
	var steps = 6
	for i in steps:
		var k = 1.0 - float(i) / steps
		tw.tween_property(n, "position", p0 + Vector2(randf_range(-1, 1), randf_range(-1, 1)) * amp * k, dur / steps)
	tw.tween_property(n, "position", p0, 0.04)
	tw.tween_callback(func(): if is_instance_valid(n): n.remove_meta("jshake"))

# 大額入帳：輕震畫面＋震機
static func big_income(amount: float) -> void:
	if not on(): return
	_log("big", amount)
	var m = _main()
	if m != null: shake(m, 4.0 if amount < 1000 else 7.0, 0.3)
	vib(30 if amount < 1000 else 60)

# ---------------- 粒子慶祝 ----------------
const COLS := [Color("#ffd84a"), Color("#ff7a3a"), Color("#f4ecd4"), Color("#c2362b"), Color("#9fe0c0")]
static func burst(host: Node, at: Vector2, n := 26, big := false) -> void:
	if not on() or host == null or not is_instance_valid(host): return
	_log("burst", n)
	var p = CPUParticles2D.new(); p.name = "JuiceBurst"
	p.top_level = true; p.z_index = 95; p.global_position = at
	p.one_shot = true; p.explosiveness = 0.92; p.amount = n; p.lifetime = 1.0 if big else 0.75
	p.direction = Vector2(0, -1); p.spread = 75.0
	p.initial_velocity_min = 160.0 if big else 110.0; p.initial_velocity_max = 320.0 if big else 220.0
	p.gravity = Vector2(0, 520); p.angular_velocity_min = -360; p.angular_velocity_max = 360
	p.scale_amount_min = 3.0; p.scale_amount_max = 7.0 if big else 5.0
	var g = Gradient.new(); g.offsets = PackedFloat32Array([0.0, 0.7, 1.0])
	var c0: Color = COLS[randi() % COLS.size()]
	g.colors = PackedColorArray([c0, Color(c0, 0.9), Color(c0, 0.0)]); p.color_ramp = g
	var ci = Gradient.new(); ci.offsets = PackedFloat32Array([0.0, 0.25, 0.5, 0.75, 1.0])
	ci.colors = PackedColorArray(COLS); p.color_initial_ramp = ci
	host.add_child(p); p.emitting = true
	var t = _tree()
	if t != null: t.create_timer(p.lifetime + 0.4, true, false, true).timeout.connect(func(): if is_instance_valid(p): p.queue_free())

# 升級／修復／解鎖：喺某個 Control 中間爆粒子＋彈一下
static func celebrate(c: Control, big := false) -> void:
	if not on() or c == null or not is_instance_valid(c) or not c.is_inside_tree(): return
	burst(c, c.global_position + c.size * 0.5, 34 if big else 22, big)
	pop(c)
	Snd.play("pop")
	if big: vib(35)

# 喺頂部橫幅位爆粒子（建成、升級、解鎖：橫幅一出就喺佢後面爆）
static func celebrate_banner(big := false) -> void:
	if not on(): return
	var m = _main()
	if m == null: return
	var vs = m.get_viewport().get_visible_rect().size
	var at = Vector2(vs.x * 0.5, vs.y * 0.22)
	var bn = m.get("banner") if "banner" in m else null
	if bn is Control and bn.is_inside_tree(): at = bn.global_position + bn.size * 0.5
	burst(m, at, 36 if big else 22, big)
	_log("celebrate", big)
	if big: vib(35)

# 彈一下（scale 1 → 1.18 → 1）
static func pop(c: CanvasItem, k := 1.18) -> void:
	if not on() or c == null or not is_instance_valid(c): return
	if c is Control: (c as Control).pivot_offset = (c as Control).size * 0.5
	var tw = c.create_tween()
	tw.tween_property(c, "scale", Vector2(k, k), 0.08).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tw.tween_property(c, "scale", Vector2.ONE, 0.22).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

# ---------------- 數字跳出＋圖示飛向頂欄 ----------------
# host：放特效嘅節點（通常 Main）；from：世界／畫面位置（global canvas）；to_lb：頂欄嗰格 Label
static func gain_fly(host: Node, from: Vector2, txt: String, tex: Texture2D, to_lb: Control, col := Color("#ffe98a")) -> void:
	if not on() or host == null or not is_instance_valid(host): return
	_log("fly", txt)
	if txt != "": _float_lbl(host, from, txt, col)
	if tex == null or to_lb == null or not is_instance_valid(to_lb) or not to_lb.is_inside_tree(): return
	_fly_icon(host, from, tex, to_lb)

static func _float_lbl(host: Node, from: Vector2, txt: String, col: Color) -> void:
	var l = Label.new(); l.text = txt; l.top_level = true; l.z_index = 96; l.mouse_filter = Control.MOUSE_FILTER_IGNORE
	l.add_theme_font_size_override("font_size", 20); l.add_theme_color_override("font_color", col)
	l.add_theme_color_override("font_outline_color", Color(0.06, 0.02, 0.02)); l.add_theme_constant_override("outline_size", 6)
	host.add_child(l); l.global_position = from + Vector2(-14, -30); l.pivot_offset = Vector2(14, 12); l.scale = Vector2(0.4, 0.4)
	var tw = l.create_tween()
	tw.tween_property(l, "scale", Vector2(1.15, 1.15), 0.1); tw.tween_property(l, "scale", Vector2.ONE, 0.1)
	tw.parallel().tween_property(l, "global_position:y", l.global_position.y - 26, 0.6)
	tw.tween_property(l, "modulate:a", 0.0, 0.25); tw.tween_callback(l.queue_free)

static func _fly_icon(host: Node, from: Vector2, tex: Texture2D, to_lb: Control) -> void:
	var ic = TextureRect.new(); ic.texture = tex; ic.expand_mode = TextureRect.EXPAND_IGNORE_SIZE; ic.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	ic.size = Vector2(26, 26); ic.top_level = true; ic.z_index = 96; ic.mouse_filter = Control.MOUSE_FILTER_IGNORE
	host.add_child(ic); ic.global_position = from - Vector2(13, 13)
	var a = from - Vector2(13, 13); var b = to_lb.global_position + Vector2(-6, to_lb.size.y * 0.5 - 13)
	var ctrl = (a + b) * 0.5 + Vector2(-60, -90)
	var t2 = ic.create_tween()
	t2.tween_method(func(k: float):
		if not is_instance_valid(ic): return
		var q = a.lerp(ctrl, k).lerp(ctrl.lerp(b, k), k)
		ic.global_position = q; ic.scale = Vector2.ONE * lerpf(1.0, 0.6, k), 0.0, 1.0, 0.55).set_delay(0.12).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	t2.tween_callback(func():
		if is_instance_valid(to_lb): pop(to_lb.get_parent() if to_lb.get_parent() is Control else to_lb, 1.12)
		ic.queue_free())

# ---------------- 終結慢鏡 ----------------
static func slowmo(scale: float, real_s: float) -> void:
	if not on(): return
	if Engine.time_scale != 1.0 and Time.get_ticks_msec() > _slow_until: return   # 測試／加速中唔郁
	_log("slow", scale)
	var t = _tree()
	if t == null: return
	_slow_until = Time.get_ticks_msec() + int(real_s * 1000.0)
	Engine.time_scale = scale
	t.create_timer(real_s, true, false, true).timeout.connect(func():
		if Time.get_ticks_msec() >= _slow_until - 20: Engine.time_scale = 1.0)

# ---------------- 王登場 ----------------
static func boss_intro(nm: String, _k := "") -> void:
	if not on(): return
	var m = _main()
	if m == null: return
	_log("boss", nm)
	Snd.play("bossIn")
	var cl = CanvasLayer.new(); cl.layer = 110; cl.name = "BossIntro"; m.add_child(cl)
	var vs = m.get_viewport().get_visible_rect().size
	var band = ColorRect.new(); band.color = Color(0.05, 0.0, 0.0, 0.78); band.mouse_filter = Control.MOUSE_FILTER_IGNORE
	band.size = Vector2(vs.x, 96); band.position = Vector2(0, vs.y * 0.34); cl.add_child(band)
	var edge = ColorRect.new(); edge.color = Color("#c2362b"); edge.size = Vector2(vs.x, 3); edge.position = Vector2(0, 0); band.add_child(edge)
	var edge2 = edge.duplicate(); edge2.position = Vector2(0, 93); band.add_child(edge2)
	var t1 = Label.new(); t1.text = "王 駕 到"; t1.add_theme_font_size_override("font_size", 16); t1.add_theme_color_override("font_color", Color("#ffb46a"))
	t1.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; t1.size = Vector2(vs.x, 22); t1.position = Vector2(0, 10); band.add_child(t1)
	var t2 = Label.new(); t2.text = nm if nm != "" else "？？？"; t2.add_theme_font_size_override("font_size", 34); t2.add_theme_color_override("font_color", Color("#f4ecd4"))
	t2.add_theme_color_override("font_outline_color", Color("#3a0808")); t2.add_theme_constant_override("outline_size", 8)
	t2.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; t2.size = Vector2(vs.x, 48); t2.position = Vector2(0, 34); band.add_child(t2)
	band.scale = Vector2(1, 0.05); band.pivot_offset = Vector2(vs.x * 0.5, 48)
	t2.position.x = vs.x
	var tw = band.create_tween()
	tw.tween_property(band, "scale", Vector2.ONE, 0.16).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tw.tween_property(t2, "position:x", 0.0, 0.22).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	tw.tween_interval(1.05)
	tw.tween_property(band, "modulate:a", 0.0, 0.3)
	tw.tween_callback(cl.queue_free)
	_tree().create_timer(2.4, true, false, true).timeout.connect(func(): if is_instance_valid(cl): cl.queue_free())   # 後備：卡幀都會收
	shake(m, 6.0, 0.35)

# ---------------- 戰力 ----------------
# 戰力總值＝全部名鬼鬼力加埋（含主公；裝備、品階、練嚇功都經 GP.pow 計入）
static func power_total() -> int:
	var S = J.G.get("S")
	var GP = J.G.get("GP")
	if not (S is Dictionary) or GP == null: return 0
	var t = 0.0
	for g in J.iter(S.get("ghosts", [])):
		if g is Dictionary: t += J.num(J.mc(GP, "pow", [g]))
	return int(round(t))

static func pow_of_k(k: String) -> float:
	var S = J.G.get("S"); var GP = J.G.get("GP")
	if not (S is Dictionary) or GP == null: return 0.0
	for g in J.iter(S.get("ghosts", [])):
		if g is Dictionary and J.str(g.get("k")) == k: return J.num(J.mc(GP, "pow", [g]))
	return 0.0

# 升級／突破演出：中間卡（頭像＋名＋鬼力舊→新滾動）；full＝全屏（突破、升品、融合）
static func power_show(k: String, nm: String, before: float, after: float, full := false, title := "") -> void:
	if not on(): return
	var m = _main()
	if m == null: return
	_log("power", [k, before, after, full])
	var old = m.get_node_or_null("PowerShow")
	if old != null: old.name = "PowerShowOld"; old.queue_free()   # 改名先，唔係新嗰個會撞名
	var cl = CanvasLayer.new(); cl.layer = 112; cl.name = "PowerShow"; m.add_child(cl)
	var vs = m.get_viewport().get_visible_rect().size
	var root = Control.new(); root.size = vs; root.mouse_filter = Control.MOUSE_FILTER_STOP if full else Control.MOUSE_FILTER_IGNORE; cl.add_child(root)
	if full:
		var dim = ColorRect.new(); dim.color = Color(0, 0, 0, 0.72); dim.size = vs; dim.mouse_filter = Control.MOUSE_FILTER_IGNORE; root.add_child(dim)
	var card = VBoxContainer.new(); card.alignment = BoxContainer.ALIGNMENT_CENTER; card.add_theme_constant_override("separation", 4); card.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var pw = 220.0 if full else 120.0
	var pr = UIKit.portrait(k, pw); pr.mouse_filter = Control.MOUSE_FILTER_IGNORE; pr.size_flags_horizontal = Control.SIZE_SHRINK_CENTER; card.add_child(pr)
	var tl = Label.new(); tl.text = title if title != "" else nm; tl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	tl.add_theme_font_size_override("font_size", 26 if full else 18); tl.add_theme_color_override("font_color", Color("#ffd84a"))
	tl.add_theme_color_override("font_outline_color", Color(0.08, 0.02, 0.02)); tl.add_theme_constant_override("outline_size", 6); card.add_child(tl)
	var nl = Label.new(); nl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	nl.add_theme_font_size_override("font_size", 30 if full else 22); nl.add_theme_color_override("font_color", Color("#f4ecd4"))
	nl.add_theme_color_override("font_outline_color", Color(0.08, 0.02, 0.02)); nl.add_theme_constant_override("outline_size", 6); card.add_child(nl)
	var dl = Label.new(); dl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; dl.text = "▲ +%d" % int(round(after - before))
	dl.add_theme_font_size_override("font_size", 18 if full else 15); dl.add_theme_color_override("font_color", Color("#7dff8a"))
	dl.add_theme_color_override("font_outline_color", Color(0.05, 0.02, 0.02)); dl.add_theme_constant_override("outline_size", 5); card.add_child(dl)
	root.add_child(card)
	card.size = Vector2(vs.x, pw + 110); card.position = Vector2(0, vs.y * (0.24 if full else 0.3))
	var fmt = func(v: float) -> String: return "鬼力 %d" % int(round(v))
	nl.text = fmt.call(before)
	var rr = ROLL.new(); rr.name = "JuiceRoll"; rr.fmt = fmt; rr.cur = before; nl.add_child(rr)
	card.pivot_offset = card.size * 0.5; card.scale = Vector2(0.6, 0.6); card.modulate.a = 0.0
	var tw = card.create_tween()
	tw.tween_property(card, "scale", Vector2.ONE, 0.22).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tw.parallel().tween_property(card, "modulate:a", 1.0, 0.15)
	tw.tween_callback(func():
		if is_instance_valid(rr): rr.go(after, 0.7 if full else 0.5)
		Snd.play("powerUp")
		burst(root, Vector2(vs.x * 0.5, card.position.y + pw * 0.5), 40 if full else 24, full))
	tw.tween_interval(2.2 if full else 1.2)
	tw.tween_property(card, "modulate:a", 0.0, 0.3)
	tw.tween_callback(cl.queue_free)
	if full:
		vib(70); shake(m, 5.0, 0.3)
		root.gui_input.connect(func(e): if e is InputEventMouseButton and e.pressed and is_instance_valid(cl): cl.queue_free())
	else: vib(20)

# ---------------- [juice] 荒村重建／生氣值接口（vil2 用） ----------------
# vil2 嘅 res://game/rebuild/rb.gd 有 listen(fn)（kind：open／relic／lit）同 vitality() 0–1。
# hook_rebuild()：主畫面 _ready 叫一次；rb.gd 唔存在（未合 vil2）就乜都唔做。
# vitality_fx(v)：生氣值 → 畫面參數（村子用嚟調暗角、路燈、遊魂數）；寫入 J.G["juice_vitality"] 俾 nv_village 讀。
static var _rb_hooked := false
const RB_PATH := "res://game/rebuild/rb.gd"
static func hook_rebuild() -> bool:
	if _rb_hooked or not ResourceLoader.exists(RB_PATH): return false
	var RB = load(RB_PATH)
	if RB == null or not RB.has_method("listen"): return false
	RB.listen(func(kind: String, arg): on_rebuild(kind, arg))
	_rb_hooked = true
	return true
static func on_rebuild(kind: String, arg) -> void:
	var v := 0.0
	if ResourceLoader.exists(RB_PATH):
		var RB = load(RB_PATH)
		if RB != null and RB.has_method("vitality"): v = float(RB.vitality())
	vitality_fx(v)
	if not on(): return
	_log("rebuild", kind)
	match kind:
		"open": celebrate_banner(false); chime("coin"); vib(25)
		"relic": chime("coin")
		"lit":
			celebrate_banner(true); vib(80)
			var m = _main()
			if m != null: shake(m, 4.0, 0.35)
static func vitality_fx(v: float) -> Dictionary:
	v = clampf(v, 0.0, 1.0)
	var fx := {
		"v": v,
		"dark_mul": lerpf(1.0, 0.55, v),      # 全圖暗層透明度倍率（越修越亮）
		"fog_mul": lerpf(1.0, 0.35, v),       # 霧濃度倍率
		"lamps": v,                           # 路燈開幾成（0–1）
		"wander_ghosts": int(round(lerpf(0.0, 8.0, v))),   # 路上遊魂數
		"juice": on(),                        # 特效關：nv_village 可以直接跳到目標值唔做漸變
	}
	J.G["juice_vitality"] = fx
	_log("vitality", v)
	return fx
