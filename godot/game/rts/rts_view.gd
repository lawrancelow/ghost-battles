# [rts] 地圖半即時戰鬥：畫面（掛喺 ui/nv_village.gd；冇 class_name、冇 autoload）
#   1. 每格叫 RTS.tick（模擬）——呢個 Node 唔睇村子顯唔顯示，去咗大排檔／鬼怪頁仗照打；
#   2. 角色：疊喺大排檔（MvScene）上面一層（同 ctl 主角疊層一樣），按 y 排；鏡頭外唔顯示、唔同步；
#      名鬼／敵人＝戰鬥角色（BtChar，出招、受擊、嚇彈起、腳軟、倒下動作照舊）；陰兵小隊＝兵營陰兵圖 × 3 個代表兵；
#      遊魂兵／嘍囉小隊＝戰鬥角色 × 3 個代表兵（血掉到 2/3、1/3 各倒一個）；
#   3. 字：血條、扣血數字、技能名、失神／連嚇、打卡印、戰報（畫面 px，最細 14）；
#   4. 名鬼技能小圓鈕（跟住名鬼頭頂；畫面外就貼右邊）＋左下戰況條（叫回、自動放、撳一下鏡頭過去）。
extends Node

const RTS = preload("res://game/rts/rts.gd")
const SIM = preload("res://game/rts/rts_sim.gd")
const ZD = preload("res://game/zone/zone_data.gd")
const BA = preload("res://game/barracks/bk_art.gd")
const RFX = preload("res://game/rts/rts_fx.gd")
const FXK = preload("res://game/fxkit/fx_kit.gd")
const AH = preload("res://game/rts/ab_hud.gd")   # [abui] 頭頂狀態、ab 飄字、自動／手動
const AI = preload("res://game/rts/ab_icon.gd")   # [abui]
const AL = preload("res://game/rts/ab_lay.gd")   # [abui] 頭頂字唔重疊排版

const K_ONE := 0.85           # 名鬼／敵人（BtChar 1.32）→ 約 50–58 世界 px 高，同村子主角差唔多
const K_REP := 1.2            # 小隊代表兵（BtChar 0.75）→ 約 38 px
const K_SOL := 0.92           # 陰兵代表兵（兵營圖 46px）→ 約 39 px
const REP_OFF := [Vector2(-11, -3), Vector2(11, 4)]
const BTN := 52.0             # 技能鈕直徑（畫面 px）

var nv = null
var ov: Control               # 疊喺 MvScene 上面
var root: Node2D
var wl: Node2D                # 角色（y 排）
var under: PtDraw             # 腳底陣營色圈（分得清敵我）
var txt: PtDraw
var ui: Control               # 技能鈕、戰況條
var chip: PanelContainer
var chip_l: Label
var chip_recall: Button
var chip_auto: Button
var btns := {}                # 名鬼 gid → SkillBtn
var vis := {}                 # key → UnitVis
var fb := {"H": 560.0, "t": 0.0}
var _t := 0.0
var _yawn := 6.0
var _ev_seen := {}            # op.id → 已處理事件數
var stamps: Array = []        # {p, text, t, col}
var _snd_t := 0.0
var rfx = null                # [rtsfx] 同夜班巡陰一樣嘅貼圖特效
var fxg: Node2D
var fxt: Node2D
var _fire_tex: Texture2D
static var inst = null
var _pvu: Array = []          # [abui]
static var PROF := {}
static var SPIKE := false   # [perf2] 測試用：單格超過 60ms 印分項

static func attach(village) -> void:
	var n = Node.new(); n.name = "RtsView"
	n.set_script(load("res://game/rts/rts_view.gd"))
	n.nv = village
	village.add_child(n)
	inst = n

static func L(yue: String, zhs: String) -> String: return RTS.L(yue, zhs)

# ================= 節點 =================
func _build() -> void:
	PtChar.setup_static()
	ov = Control.new(); ov.name = "RtsOv"; ov.mouse_filter = Control.MOUSE_FILTER_IGNORE; ov.clip_contents = true
	ov.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	nv.add_child(ov)
	root = Node2D.new(); ov.add_child(root)
	under = PtDraw.new(); under.tag = "rts_under"; under.fn = _draw_under; root.add_child(under)
	fxg = Node2D.new(); fxg.name = "RtsFxG"; root.add_child(fxg)
	wl = Node2D.new(); wl.y_sort_enabled = true; root.add_child(wl)
	fxt = Node2D.new(); fxt.name = "RtsFxT"; root.add_child(fxt)
	rfx = RFX.new(fxg, fxt)
	txt = PtDraw.new(); txt.tag = "rts_txt"; txt.fn = _draw_txt; root.add_child(txt)
	ui = Control.new(); ui.name = "RtsUI"; ui.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ui.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	nv.add_child(ui)
	_build_chip()

func _build_chip() -> void:
	chip = PanelContainer.new(); chip.name = "RtsChip"
	var sb = UIKit.sb(Color(0.09, 0.05, 0.05, 0.9), 10, Color("#c8823a"), 2, Vector4(10, 2, 4, 2))
	sb.shadow_color = Color(0, 0, 0, 0.45); sb.shadow_size = 5
	chip.add_theme_stylebox_override("panel", sb)
	chip.anchor_top = 1; chip.anchor_bottom = 1; chip.offset_left = 6; chip.offset_bottom = -6; chip.offset_top = -44   # 左下：唔撞「出擊」掣（右下）、行動按鈕（中間再高啲）
	chip.grow_vertical = Control.GROW_DIRECTION_BEGIN
	chip.mouse_filter = Control.MOUSE_FILTER_STOP
	var hb = HBoxContainer.new(); hb.add_theme_constant_override("separation", 6); chip.add_child(hb)
	chip_l = UIKit.label("", 16, Color("#ffe8c8"), "sans", 900); chip_l.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	chip_l.custom_minimum_size = Vector2(100, 34); chip_l.clip_text = true; chip_l.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hb.add_child(chip_l)
	chip_auto = _btn(L("自動", "自動"), Color("#3a2c26"), Color("#6a5040")); ui.add_child(chip_auto)   # 擺喺右邊技能鈕上面（同技能有關）
	chip_auto.custom_minimum_size = Vector2(56, 32); chip_auto.size = Vector2(56, 32)
	chip_auto.pressed.connect(func():
		var B = J.G.get("Battle")
		if B is Dictionary:
			B["auto"] = not J.t(B.get("auto"))
			var ls = J.G.get("localStorage")
			if ls != null: J.mc(ls, "setItem", ["gb_auto", "1" if J.t(B.auto) else "0"])
		_sync_auto())
	chip_recall = _btn(L("叫回", "叫回"), Color("#7a2418"), Color("#e09a6a")); hb.add_child(chip_recall)
	chip_recall.pressed.connect(func():
		var op = _main_op()
		if op != null: RTS.recall(op))
	chip.gui_input.connect(func(ev):
		if (ev is InputEventMouseButton and ev.pressed and ev.button_index == MOUSE_BUTTON_LEFT) or (ev is InputEventScreenTouch and ev.pressed):
			var op = _main_op()
			if op != null: RTS.focus(op); chip.accept_event())
	chip.visible = false
	chip_auto.visible = false
	ui.add_child(chip)
func _btn(t: String, bg: Color, bd: Color) -> Button:
	var b = Button.new(); b.text = t; b.focus_mode = Control.FOCUS_NONE
	b.add_theme_font_override("font", UIKit.font("sans", 900)); b.add_theme_font_size_override("font_size", 15)
	var s = UIKit.sb(bg, 8, bd, 2, Vector4(9, 4, 9, 4))
	for k in ["normal", "hover", "pressed", "disabled"]: b.add_theme_stylebox_override(k, s)
	b.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
	for k in ["font_color", "font_hover_color", "font_pressed_color"]: b.add_theme_color_override(k, Color("#fff0dc"))
	b.custom_minimum_size = Vector2(50, 34)
	return b
func _sync_auto() -> void:
	var on = J.t(J.gp(J.G.get("Battle"), "auto")) if J.G.get("Battle") != null else false
	chip_auto.text = L("自動", "自動")   # 綠＝開、啡＝關
	var s = UIKit.sb(Color("#2e5d55") if on else Color("#3a2c26"), 8, Color("#7ac0b0") if on else Color("#6a5040"), 2, Vector4(9, 4, 9, 4))
	for k in ["normal", "hover", "pressed"]: chip_auto.add_theme_stylebox_override(k, s)

# ================= [補丁43] 撳戰鬥單位：睇佢身上全部 buff／debuff =================
var insp = null          # {u, op, t}
var _tap0 = null         # {p, t}
func _input(ev: InputEvent) -> void:
	if nv == null or not is_instance_valid(nv) or txt == null or not txt.is_visible_in_tree(): return
	var dn = (ev is InputEventMouseButton and ev.button_index == MOUSE_BUTTON_LEFT and ev.pressed) or (ev is InputEventScreenTouch and ev.pressed)
	var up = (ev is InputEventMouseButton and ev.button_index == MOUSE_BUTTON_LEFT and not ev.pressed) or (ev is InputEventScreenTouch and not ev.pressed)
	if dn: _tap0 = {"p": ev.position, "t": _t}; return
	if not up or _tap0 == null: return
	var p0: Vector2 = _tap0.p; var dt0 = _t - float(_tap0.t); _tap0 = null
	if p0.distance_to(ev.position) > 12.0 or dt0 > 0.45: return
	var hit = pick_at(ev.position)
	if hit != null:
		insp = {"u": hit[0], "op": hit[1], "t": 0.0}; get_viewport().set_input_as_handled()
	elif insp != null: insp = null
func pick_at(sp: Vector2):   # 畫面座標 → 最近嘅戰鬥單位（36px 內）
	var best = null; var bd = 36.0
	for op in RTS.ops:
		if not (op.phase in ["fight", "end"]): continue
		for u in op.units:
			if J.num(u.get("hp", 0)) <= 0 or not (u.get("p") is Vector2) or not _shown(u, op): continue
			if J.num(u.side) == 0 and not J.t(u.get("out")): continue
			var q = _scr(op.head(u).lerp(u.p, 0.5))
			var d = q.distance_to(sp)
			if d < bd: bd = d; best = [u, op]
	return best
func insp_lines(u: Dictionary, op) -> Array:   # [[文字, 顏色]]
	var o = []
	var ef = AH.effects(op, u)
	for e in ef:
		var inf = AI.info(e.k)
		var nm = str(DB.L(str(inf.get("n", e.k))))
		var lt = "" if J.num(e.left) < 0 else L("　剩 %.1f 秒", "　剩 %.1f 秒") % J.num(e.left)
		var nn = "" if int(e.n) < 2 else " ×%d" % int(e.n)
		var ds = inf.get("d")
		var dt = ("　" + RTS.L(str(ds[0]), str(ds[1]))) if ds is Array else ""
		o.append([nm + nn + lt + dt, Color("#ffb0a0") if e.neg else Color("#b8f0c0")])
	var s0 = AH.status(op, u)
	if s0.shield > 0.5: o.push_front([L("護盾 %d", "護盾 %d") % int(s0.shield), Color("#9ad0ff")])
	if s0.stealth: o.push_front([L("隱身", "隱身"), Color("#c8c0e0")])
	if o.is_empty(): o.append([L("冇任何狀態", "沒有任何狀態"), Color("#d8d0c0")])
	return o
func _draw_insp(n: CanvasItem, f: Font) -> void:
	if insp == null: return
	var u: Dictionary = insp.u; var op = insp.op
	if J.num(u.get("hp", 0)) <= 0 or not (op.phase in ["fight", "end"]): insp = null; return
	n.draw_set_transform_matrix(n.get_global_transform_with_canvas().affine_inverse())   # 畫面座標
	var ls = insp_lines(u, op)
	var vp = get_viewport().get_visible_rect().size
	var W = minf(vp.x - 24.0, 420.0); var lh = 22.0
	var H = 40.0 + ls.size() * lh + 8.0
	var r = Rect2((vp.x - W) / 2.0, vp.y - 150.0 - H, W, H)   # 放喺底部戰況條上面（頂部 HUD 會遮）
	n.draw_style_box(_box(Color(0.08, 0.06, 0.1, 0.92), 8), r)
	n.draw_rect(r, Color("#7a5a3a"), false, 2.0)
	var nm = str(DB.L(J.str(u.get("name", u.get("k")))))
	n.draw_string(f, r.position + Vector2(12, 26), nm + L("　身上狀態（撳其他地方收起）", "　身上狀態（點其他地方收起）"), HORIZONTAL_ALIGNMENT_LEFT, W - 20, 16, Color("#ffe8b0"))
	for i in ls.size():
		n.draw_string(f, r.position + Vector2(14, 48 + i * lh), str(ls[i][0]), HORIZONTAL_ALIGNMENT_LEFT, W - 24, 14, ls[i][1])
	n.draw_set_transform_matrix(Transform2D.IDENTITY)

func _main_op():   # 戰況條／技能鈕：名鬼帶隊嗰場優先
	for o in RTS.ops: if o.phase != "done" and not o.no_heroes: return o
	for o in RTS.ops: if o.phase != "done": return o
	return null

# ================= 每格 =================
func _process(dt: float) -> void:
	var tq0 = Time.get_ticks_usec()
	RTS.tick(dt)   # 模擬：唔睇畫面（去咗大排檔、鬼怪頁都照打）
	_t += dt
	AH.tick(dt)   # [abui]
	var tq1 = Time.get_ticks_usec()
	if nv == null or not is_instance_valid(nv): return
	if not nv.is_visible_in_tree() or not ZD.on():
		if ov != null: ov.visible = false; ui.visible = false
		_fx_off()
		return
	if ov == null: _build()
	ov.visible = true; ui.visible = true
	var t0 = Time.get_ticks_usec()
	_fx_frame(dt)
	var ta = Time.get_ticks_usec()
	_layer()
	_sync_units(dt)
	var tb = Time.get_ticks_usec()
	_events()
	txt.queue_redraw(); under.queue_redraw()
	_sync_ui()
	var tc = Time.get_ticks_usec()
	if SPIKE:
		for kv in [["sim", tq1 - tq0], ["fx", ta - t0], ["units", tb - ta], ["ui", tc - tb]]: PROF[kv[0]] = PROF.get(kv[0], 0) + kv[1]
		PROF["sn"] = PROF.get("sn", 0) + 1
	PROF["view"] = PROF.get("view", 0) + Time.get_ticks_usec() - t0
	PROF["n"] = PROF.get("n", 0) + 1

# [rtsfx] 只有鏡頭內嘅仗開特效；震屏只喺呢度（輕微）
func _fx_off() -> void:
	for op in RTS.ops: op.vfx_on = false; op.vq.clear()
	if rfx != null: rfx.clear()
func _fx_frame(dt: float) -> void:
	var vr: Rect2 = nv.view_rect().grow(120)
	rfx.vr = vr
	var any_on = false
	for op in RTS.ops:
		var on = op.phase in ["fight", "end"] and vr.grow(160).has_point(op.center())
		op.vfx_on = on
		if not on: op.vq.clear(); continue
		any_on = true
		if op.phase == "fight": rfx.appear_op(op)
		rfx.consume(op)
	if not any_on: rfx.shake = 0.0
	rfx.tick(dt)
	if rfx.shake > 0.05 and nv.get("world") is Node2D:
		nv.world.position += Vector2((randf() - 0.5), (randf() - 0.5) * 0.7) * rfx.shake * float(nv.sc)

func _layer() -> void:
	var sc = nv.get_node_or_null("MvScene")
	var m = RTS._main()
	if m != null and m.get("mv_view") != null and is_instance_valid(m.mv_view) and m.mv_view.get_parent() == nv: sc = m.mv_view
	if sc != null and ov.get_index() < sc.get_index(): nv.move_child(ov, sc.get_index() + 1)
	if ui.get_index() != nv.get_child_count() - 1: nv.move_child(ui, nv.get_child_count() - 1)
	var top = 0.0
	if sc != null and sc.get("hud_on") and nv.has_method("_zone_top_px"): top = nv._zone_top_px()
	if ov.offset_top != top: ov.offset_top = top
	root.transform = Transform2D(0, Vector2(0, -top)) * nv.world.transform
	var gm = nv.ysort.modulate if nv.get("ysort") is CanvasItem else Color.WHITE
	if wl.modulate != gm: wl.modulate = gm

# ---------------- 角色 ----------------
func _want() -> Array:   # [[key, unit, op 或 null]]
	var o = []
	for op in RTS.ops:
		for i in op.units.size(): o.append(["o%d:%d" % [op.id, i], op.units[i], op])
	var tg = ZD.stage_target()
	if tg.has("pos") and RTS.owns(str(tg.sid)) and RTS.op_for(str(tg.sid)) == null:   # 未出擊：據點企住
		if not has_meta("pv_sid") or get_meta("pv_sid") != str(tg.sid):
			set_meta("pv_sid", str(tg.sid)); set_meta("pv", RTS.camp_preview(tg))
		var pv: Array = get_meta("pv")
		for i in pv.size(): o.append(["pv:%s:%d" % [str(tg.sid), i], pv[i], null])
	o.append_array(load("res://game/sortie/so_view.gd").want())   # [sortie] 野外出擊據點
	return o
func _sync_units(dt: float) -> void:
	fb["t"] = _t
	var want = _want()
	_pvu.clear()   # [abui] 據點預覽敵人（頭頂畫機制圖示）
	for w in want: if w[2] == null: _pvu.append(w[1])
	var keep = {}
	var vr: Rect2 = nv.view_rect().grow(90)
	for w in want:
		var key: String = w[0]; var u: Dictionary = w[1]; var op = w[2]
		keep[key] = true
		var v = vis.get(key)
		if v == null:
			v = UnitVis.new(); v.setup(u, fb); wl.add_child(v); vis[key] = v
		var T = op.t if op != null and op.phase in ["fight", "end"] else _t
		var show = _shown(u, op) and vr.has_point(u.p)
		v.visible = show
		if show: v.sync(T, dt, op)
	for k in vis.keys():
		if not keep.has(k): vis[k].queue_free(); vis.erase(k)
	_idle_preview(dt)
func _shown(u: Dictionary, op) -> bool:
	if op == null: return true
	if J.num(u.side) == 0:
		if J.t(u.get("home")): return false
		if not J.t(u.get("out")) and op.phase in ["march", "fight"]: return false
		if J.num(u.get("s", 0)) < 0 and op.phase == "back" and J.num(u.hp) > 0: return true
	return true
# 據點：敵人偷懶（左右望、打喊露）
func _idle_preview(dt: float) -> void:
	if not has_meta("pv") or RTS.op_for(str(get_meta("pv_sid", ""))) != null: return
	var tg = ZD.stage_target()
	if not tg.has("pos") or str(tg.sid) != str(get_meta("pv_sid")): return
	var pv: Array = get_meta("pv")
	_yawn -= dt
	if _yawn <= 0.0 and pv.size():
		_yawn = randf_range(4.0, 7.0)
		var u = pv[randi() % pv.size()]
		if randf() < 0.5: u["face"] = -J.num(u.get("face", -1))
		else: stamps.append({"p": (u.p as Vector2) + Vector2(12, -66), "text": L("呵～", "呵～"), "t": 0.0, "life": 1.6, "kind": "yawn"})

class UnitVis extends Node2D:
	var u: Dictionary
	var fb: Dictionary
	var kind := "one"          # one／squad（BtChar × 3）／yin（陰兵圖 × 3）
	var wraps: Array = []
	var chars: Array = []
	var proxies: Array = []
	var sols: Array = []
	var dead_t := [-1.0, -1.0]
	var flash := 0.0
	var lift := 0.0               # [abui] 飛行抬高（px，平滑）
	var off_base: Array = []      # [abui] 代表兵原位
	func _draw() -> void:         # [abui] 飛行：腳底影
		if lift < 1.0: return
		var k = clampf(lift / AH.LIFT, 0, 1)
		draw_set_transform(Vector2(0, 2), 0, Vector2(1, 0.34))
		draw_circle(Vector2.ZERO, 20.0 - 4.0 * k, Color(0, 0, 0, 0.32 * k))
		draw_circle(Vector2.ZERO, 12.0 - 2.0 * k, Color(0, 0, 0, 0.22 * k))
		draw_set_transform_matrix(Transform2D.IDENTITY)
	func setup(unit: Dictionary, fakeb: Dictionary) -> void:
		u = unit; fb = fakeb
		y_sort_enabled = true
		var minion = J.t(u.get("minion"))
		if minion and J.num(u.side) == 0 and u.get("ml") == null: kind = "yin"
		elif minion: kind = "squad"
		var n = 1 if kind == "one" else SIM.REPS
		for i in n:
			var off = REP_OFF[i] if n > 1 else Vector2.ZERO
			off_base.append(off)   # [abui]
			if kind == "yin":
				var s = SolRep.new(); s.position = off; s.seed = int(abs(hash(str(u.get("lane", 0)) + str(i)))) % 97
				if u.get("yb_c") != null: s.look = "yb_%s_%s" % [str(u.yb_c), str(u.get("yb_r", "wei"))]   # [yinbing] 兵種×階級立繪
				add_child(s); sols.append(s)
			else:
				var w = Node2D.new(); w.position = off; add_child(w); wraps.append(w)
				var px = {"side": u.side, "k": J.str(u.k), "boss": J.t(u.get("boss")), "minion": minion, "x": 0.0, "lane": -5.0, "hp": 1.0, "maxhp": 1.0, "st": {}, "range": J.num(u.get("range", 46)), "_soul": (randi() % 1000)}
				proxies.append(px)
				var c = BtChar.new(px, fb); w.add_child(c); chars.append(c)
				load("res://game/equip/eq_view.gd").attach(c, u)   # [equip] 裝備疊層（兵器喺手、帽喺頭、護身色環徽章）
	func _alive_reps() -> int:
		var hp = J.num(u.get("hp", 0))
		if hp <= 0: return 0
		return clampi(int(ceil(hp / maxf(1.0, J.num(u.get("maxhp", 1))) * float(SIM.REPS) - 0.001)), 1, SIM.REPS)
	func sync(T: float, dt: float, op) -> void:
		position = (u.p as Vector2).round()
		var face = J.num(u.get("face", 1.0)); if face == 0: face = 1.0
		var natural = 1.0 if J.num(u.side) == 0 else -1.0
		var flip = face * natural
		var ar = _alive_reps() if kind != "one" else (1 if J.num(u.get("hp", 0)) > 0 else 0)
		var lt = AH.lift_of(op, u) if kind != "yin" else 0.0   # [abui] 飛高 30px＋影；隱身半透明
		if absf(lt - lift) > 0.05:
			lift = move_toward(lift, lt, dt * 90.0); queue_redraw()
		var al = AH.alpha_of(op, u)
		if absf(modulate.a - al) > 0.01: modulate.a = move_toward(modulate.a, al, dt * 3.0)
		var n = maxi(wraps.size(), sols.size())
		for i in n:
			var rep_dead = (kind != "one") and i >= ar
			if rep_dead and dead_t[i] < 0: dead_t[i] = 0.0
			elif not rep_dead: dead_t[i] = -1.0
			if dead_t[i] >= 0: dead_t[i] += dt
		if kind == "yin":
			for i in sols.size():
				var s: SolRep = sols[i]
				var pose = "stand"
				if J.num(u.get("sal", -1)) >= 0 and J.num(u.get("hp", 0)) > 0: pose = "salute"
				elif u.get("anim") is Dictionary and str(u.anim.name) in ["windup", "strike"]: pose = "attack"
				elif J.t(u.get("walking")): pose = "walk"
				s.pose = pose; s.dir = face; s.ph = T + i * 0.13
				s.dead = dead_t[i]
				s.flash = J.num(u.get("flash", 0))
				s.queue_redraw()
			return
		for i in chars.size():
			var w: Node2D = wraps[i]
			w.position = (off_base[i] as Vector2) + Vector2(0, -lift)   # [abui]
			var k = K_ONE if kind == "one" else K_REP
			w.scale = Vector2(k * flip, k)
			var px: Dictionary = proxies[i]
			var dead = dead_t[i] if kind != "one" else (J.num(u.get("deadT", 0)) if J.num(u.get("hp", 0)) <= 0 else -1.0)
			px["hp"] = 1.0 if dead < 0 else 0.0
			px["deadT"] = maxf(0.0, dead)
			px["dieDir"] = J.num(u.get("dieDir", -natural)) * flip if u.get("dieDir") != null else -1.0
			px["walking"] = J.t(u.get("walking"))
			px["st"] = u.get("st", {}) if dead < 0 else {}
			px["casting"] = u.get("casting") if i == 0 else null
			var a = u.get("anim")
			if a is Dictionary: px["anim"] = {"name": a.name, "t": maxf(0.0, J.num(a.t) - i * 0.04), "dur": a.dur}
			else: px["anim"] = null
			px["flash"] = J.num(u.get("flash", 0))
			px["hurtT"] = J.num(u.get("hurtT", 0))
			px["kbT"] = u.get("kbT"); px["kbDir"] = J.num(u.get("kbDir", 1)) * flip
			px["lane"] = -5.0 + i * 0.0
			chars[i].sync(T + i * 0.37)

class SolRep extends Node2D:
	var look := ""   # [yinbing] yb_<兵種>_<階級>；空＝現版
	var pose := "stand"
	var dir := 1.0
	var ph := 0.0
	var seed := 0
	var dead := -1.0
	var flash := 0.0
	func _draw() -> void:
		var base = Transform2D(0.0, Vector2(K_SOL, K_SOL), 0.0, Vector2.ZERO)
		if dead >= 0:
			var k = clampf(dead / 0.3, 0.0, 1.0)
			var a = 1.0 - clampf((dead - 0.35) / 0.6, 0.0, 1.0)
			if a <= 0.0: return
			modulate = Color(1, 1, 1, a)
			base = Transform2D(-dir * 1.25 * k, Vector2(K_SOL, K_SOL), 0.0, Vector2(-dir * 8 * k, 0))
			BA.draw_soldier(self, "stand", 0.0, dir, seed, base, look)
			return
		modulate = Color(1 + flash * 1.2, 1 + flash, 1 + flash * 0.8, 1)
		BA.draw_soldier(self, pose, ph, dir, seed, base, look)

# 腳底色圈：我方青綠、敵方暗紅（交戰先出；小隊圈大啲包住三個代表兵）
func _draw_under(n: CanvasItem) -> void:
	var vr: Rect2 = nv.view_rect().grow(60)
	for op in RTS.ops:
		if not (op.phase in ["fight", "end"]): continue
		for u in op.units:
			if J.num(u.get("hp", 0)) <= 0 or not _shown(u, op) or not vr.has_point(u.p): continue
			if J.num(u.side) == 0 and not J.t(u.get("out")): continue
			var mn = J.t(u.get("minion"))
			var col = Color(0.35, 0.95, 0.8, 0.22) if J.num(u.side) == 0 else Color(1.0, 0.22, 0.2, 0.26)
			var rx = 30.0 if mn else 22.0
			n.draw_set_transform(u.p + Vector2(0, 3), 0, Vector2(1, 0.36))
			n.draw_circle(Vector2.ZERO, rx, col)
			n.draw_arc(Vector2.ZERO, rx, 0, TAU, 28, Color(col, col.a * 2.2), 2.0)
	n.draw_set_transform_matrix(Transform2D.IDENTITY)

# ---------------- 事件（打卡印、聲） ----------------
func _events() -> void:
	for op in RTS.ops:
		var n0 = int(_ev_seen.get(op.id, 0))
		for i in range(n0, op.events.size()):
			var e = op.events[i]
			match e[0]:
				"stamp":
					var u = e[1]
					stamps.append({"p": op.head(u) + Vector2(0, -14), "text": L(e[2], e[2]) if e[2] != "打卡" else L("打卡", "打卡"), "t": 0.0, "life": 1.3, "kind": "stamp", "u": u, "op": op})
				"contact":
					if _on_screen(op.anchor): Snd.play("click")
				"ab":
					AH.on_event(op, e)   # [abui] 能力事件飄字
					if _on_screen(op.anchor):   # [sfx43] 副技／王牌技／狀態中招音效
						var sk = load("res://core/sfx43.gd").ev_key(e)
						if sk != "": Snd.play(sk)
		_ev_seen[op.id] = op.events.size()
	var keep = []
	for s in stamps:
		s.t += get_process_delta_time()
		if s.t < s.life: keep.append(s)
	stamps = keep
# [sfx43] 戰報卡第一次出：打贏有 MVP → mvp；之後排隊嘅（掉魂魄、專屬物）逐個慢慢出
func _rep_sfx(op) -> void:
	var SX = load("res://core/sfx43.gd")
	var later = SX.take()
	var rep = op.get_meta("report")
	var srows = load("res://game/rts/abil.gd").stats_rows(op) if op.get("ab_log") is Dictionary else []
	var d = 0.0
	if rep is Dictionary and J.t(rep.get("win")) and srows.size(): Snd.play("mvp"); d = 0.9
	for k in later:
		if d <= 0.0: Snd.play(k)
		else: get_tree().create_timer(d).timeout.connect(func(): Snd.play(k))
		d += 0.8
func _on_screen(p: Vector2) -> bool: return nv.view_rect().has_point(p)

# ---------------- 字（畫面 px） ----------------
const DARK := Color(10 / 255.0, 6 / 255.0, 20 / 255.0, 0.92)
static var _sbc := {}
static func _box(c: Color, r: float) -> StyleBoxFlat:
	var key = "%s|%s" % [c.to_html(), r]
	if not _sbc.has(key):
		var b = StyleBoxFlat.new(); b.bg_color = c; b.set_corner_radius_all(int(round(r))); b.anti_aliasing = true; _sbc[key] = b
	return _sbc[key]
func _z() -> float: return maxf(0.05, float(nv.sc))
func _at(n: CanvasItem, wp: Vector2, k := 1.0, rot := 0.0) -> void:
	var z = _z(); n.draw_set_transform(wp, rot, Vector2(k / z, k / z))
func _str(n: CanvasItem, f: Font, s: String, x: float, y: float, px: int, col: Color, ow := 5) -> void:
	var w = f.get_string_size(s, HORIZONTAL_ALIGNMENT_LEFT, -1, px).x
	if ow > 0: n.draw_string_outline(f, Vector2(x - w / 2, y), s, HORIZONTAL_ALIGNMENT_LEFT, -1, px, ow, Color(DARK, DARK.a * col.a))
	n.draw_string(f, Vector2(x - w / 2, y), s, HORIZONTAL_ALIGNMENT_LEFT, -1, px, col)
# [abui] 地圖上面嘅可撳 HUD（細過半個畫面、會食撳嘅 Control）：每 0.5 秒重新搵一次
var _txt_seen := {}   # [abui] 同格重複 txt 飄字
var _hud_c: Array = []
var _hud_at := -1.0
func _hud_ctl() -> Array:
	if _t - _hud_at < 0.5 and _hud_at >= 0: return _hud_c
	_hud_at = _t; _hud_c.clear()
	var m = RTS._main()
	if m == null: return _hud_c
	var va = get_viewport().get_visible_rect().size
	var st = [m]
	while st.size():
		var x = st.pop_back()
		if x == ui or x == ov: continue
		if x is CanvasItem and not x.visible: continue
		if x is Control and x.mouse_filter == Control.MOUSE_FILTER_STOP:
			var r = (x as Control).get_global_rect()
			if r.size.x * r.size.y < va.x * va.y * 0.25 and r.size.x > 4 and r.size.y > 4: _hud_c.append(x); continue
		for ch in x.get_children(): st.append(ch)
	return _hud_c
func _scr(wp: Vector2) -> Vector2: return txt.get_global_transform_with_canvas() * wp   # [abui] 世界 → 畫面
func _avoid_w(wp: Vector2, r: Rect2) -> void: AL.add_obs(Rect2(_scr(wp) + r.position, r.size))   # [abui]
func _draw_txt(n: CanvasItem) -> void:
	var f = UIKit.font("sans", 900)
	var vr: Rect2 = nv.view_rect().grow(60)
	AL.begin()   # [abui]
	_txt_seen.clear()
	AL.active = false
	for o0 in RTS.ops: if o0.phase in ["fight", "end"] and o0.vfx_on: AL.active = true
	if not AL.active: AL.busy.clear()
	var tg = ZD.stage_target()
	if tg.has("pos") and RTS.owns(str(tg.sid)) and vr.has_point(tg.pos):   # 據點名牌
		var at: Vector2 = tg.pos
		var op0 = RTS.op_for(str(tg.sid))
		_at(n, at + RTS.CAMP_OFF + Vector2(0, 34))
		if op0 == null:
			_str(n, f, L("主線 %s　%s", "主線 %s　%s") % [str(tg.sid), str(DB.L(str(tg.get("name", ""))))], 0, 0, 16, Color("#ffb0a0"))
			_avoid_w(at + RTS.CAMP_OFF + Vector2(0, 34), Rect2(-110, -18, 220, 54))   # [abui]
			var a = 0.75 + 0.25 * sin(_t * 3.0)
			var s = L("撳我迎戰", "點我迎戰"); var w = f.get_string_size(s, HORIZONTAL_ALIGNMENT_LEFT, -1, 16).x
			n.draw_style_box(_box(Color(0.59, 0.16, 0.12, 0.95 * a), 6), Rect2(-w / 2 - 9, 7, w + 18, 26))
			_str(n, f, s, 0, 26, 16, Color(1, 0.96, 0.9, a), 0)
		n.draw_set_transform_matrix(Transform2D.IDENTITY)
	load("res://game/sortie/so_view.gd").draw(self, n, f, vr)   # [sortie] 據點木牌（等級、已清空、重生）
	for op in RTS.ops: _draw_op(n, f, op, vr)
	_draw_pv_mech(n, vr)   # [abui]
	AH.gather_floats(self, AL)   # [abui]
	for b in btns.values(): AL.add_obs(b.get_global_rect().grow(4))   # [abui] 右邊技能鈕、戰況條唔畫字落去
	for c in _hud_ctl(): if is_instance_valid(c) and c.is_visible_in_tree(): AL.add_obs(c.get_global_rect().grow(3))   # [abui] 地圖上嘅 HUD 掣（生產鏈、招牌菜……）
	var msc = nv.get_node_or_null("MvScene")   # [abui] 大排檔 HUD 畫出嚟嘅掣（招牌菜、任務條……）
	var m0 = RTS._main()
	if m0 != null and m0.get("mv_view") != null and is_instance_valid(m0.mv_view): msc = m0.mv_view
	if msc != null and msc.get("over") is Control and msc.get("_btns") is Dictionary and msc.over.is_visible_in_tree():
		var oxf = msc.over.get_global_transform_with_canvas()
		var va = get_viewport().get_visible_rect().size
		for k in msc._btns:
			var r = msc._btns[k]
			if r is Rect2 and r.size.x * r.size.y < va.x * va.y * 0.25: AL.add_obs((oxf * (r as Rect2)).grow(2))
	if chip != null and chip.visible: AL.add_obs(chip.get_global_rect())
	if chip_auto != null and chip_auto.visible: AL.add_obs(chip_auto.get_global_rect())
	var vp = get_viewport().get_visible_rect()
	var top_px = float(nv._zone_top_px()) if nv.has_method("_zone_top_px") else 0.0
	AL.solve(Rect2(vp.position + Vector2(0, top_px), vp.size - Vector2(0, top_px + 70.0)), f)   # [abui] 唔入頂部 HUD、底部導航
	AL.draw(self, n, f)
	for s in stamps:
		var p: Vector2 = s.p
		if s.get("u") != null and s.get("op") != null: p = s.op.head(s.u) + Vector2(0, -16)
		if not vr.has_point(p): continue
		var k = s.t / s.life
		var a = 1.0 if k < 0.7 else 1.0 - (k - 0.7) / 0.3
		if s.kind == "stamp":
			var pop = 1.6 - 0.6 * clampf(s.t / 0.12, 0, 1)
			_at(n, p + Vector2(0, -s.t * 10), pop, -0.14)
			var w = f.get_string_size(s.text, HORIZONTAL_ALIGNMENT_LEFT, -1, 15).x
			var col = Color(0.72, 0.1, 0.08, 0.92 * a) if s.text != L("早退", "早退") else Color(0.35, 0.3, 0.3, 0.92 * a)
			n.draw_style_box(_box(Color(1, 0.94, 0.86, 0.9 * a), 3), Rect2(-w / 2 - 7, -17, w + 14, 22))
			n.draw_rect(Rect2(-w / 2 - 5, -15, w + 10, 18), col, false, 2.0)
			_str(n, f, s.text, 0, 0, 15, col, 0)
		else:
			_at(n, p + Vector2(0, -s.t * 8))
			_str(n, f, s.text, 0, 0, 15, Color(0.92, 0.88, 0.8, 0.9 * a))
	n.draw_set_transform_matrix(Transform2D.IDENTITY)
	_draw_insp(n, f)   # [補丁43]

func _draw_op(n: CanvasItem, f: Font, op, vr: Rect2) -> void:
	# 飛彈
	for q in op.proj:
		var p: Vector2 = q.p
		if not vr.has_point(p): continue
		var col = Color(q.col)
		var tr: Array = q.trail
		var ysrc = q.get("src")
		if ysrc is Dictionary and str(ysrc.get("yb_c", "")) == "yuan":   # [yinbing] 弓弩手：箭／石仔／弩箭（實物，冇鬼火、冇拖尾）
			var pv: Vector2 = tr[tr.size() - 1] if tr.size() else p - Vector2(1, 0)
			BA.draw_missile(n, p, (p - pv).angle(), str(ysrc.get("yb_r", "wei")))
			continue
		for i in tr.size():   # 拖尾
			var c2 = col; c2.a = 0.08 + 0.35 * float(i) / maxf(1, tr.size())
			n.draw_circle(tr[i], 1.5 + i * 0.5, c2)
		if _fire_tex == null: _fire_tex = PtGfx.tex("fx_fire")
		var src = q.get("src")
		var S = rfx.sty_of(src) if src is Dictionary and rfx != null else {"hue": 0.0, "k": 0.9}
		var prev: Vector2 = tr[tr.size() - 1] if tr.size() else p - Vector2(1, 0)
		FXK.draw_bolt(n, _fire_tex, p, atan2(p.y - prev.y, p.x - prev.x), 0.8 if src is Dictionary and J.t(src.get("minion")) else 1.05, S.hue)
	# 角色血條、名
	for u in op.units:
		var hp = J.num(u.get("hp", 0))
		if hp <= 0 or not _shown(u, op) or not vr.has_point(u.p): continue
		if J.num(u.side) == 0 and not J.t(u.get("out")): continue
		var mn = J.t(u.get("minion")); var bo = J.t(u.get("boss")); var side1 = J.num(u.side) != 0
		var hd = op.head(u) + Vector2(0, -4 - AH.lift_of(op, u))   # [abui] 飛行抬高
		_at(n, hd)
		var full = hp >= J.num(u.get("maxhp", 1)) - 0.01
		if op.phase in ["fight", "end"] or not full:
			if not (mn and full):
				var bw = 28.0 if mn else (58.0 if bo else 44.0)
				AL.add_bar(Rect2(_scr(hd) + Vector2(-bw / 2 - 2, -2), Vector2(bw + 4, 12)))   # [abui] 血條係障礙：唔准字蓋住
				n.draw_style_box(_box(Color(0, 0, 0, 0.7), 2), Rect2(-bw / 2 - 1, -1, bw + 2, 8))
				var fr = clampf(hp / maxf(1.0, J.num(u.maxhp)), 0, 1)
				if fr * bw > 0.3: n.draw_style_box(_box(Color("#e84a5f") if side1 else Color("#4ade80"), 2), Rect2(-bw / 2, 0, bw * fr, 6))
				var en = J.num(u.get("energy", 0))
				if u.get("sk") != null and not mn and not side1 and en > 0.5: n.draw_style_box(_box(Color("#ffd84a") if en >= 100 else Color("#7dd3fc"), 1), Rect2(-bw / 2, 6, bw * clampf(en / 100.0, 0, 1), 3))
		# [abui] 頭頂資訊（讀條、狀態圖示、技能滿金點、王名、腳軟、失神）交 ab_lay 排版：同隔籬唔重疊
		var lines = AH.lines_of(op, u, f) if op.phase == "fight" else []
		if u.get("ml") != null: lines.push_front({"k": "ml", "t": int(J.num(u.ml)), "w": 26.0, "h": 22.0})   # 遊魂兵頭頂兵器牌（一齊排版，唔會疊）
		if not side1 and not mn and op.phase == "fight" and J.num(u.get("energy", 0)) >= 100: lines.append({"k": "dot", "w": 16.0, "h": 18.0})
		if bo:
			var bn = str(DB.L(J.str(u.name)))
			lines.append({"k": "text", "s": bn, "px": 15, "col": Color("#ffd0d8"), "w": f.get_string_size(bn, HORIZONTAL_ALIGNMENT_LEFT, -1, 15).x + 10.0, "h": 19.0})
		if op.phase == "fight":
			var st: Dictionary = u.st
			if J.num(st.get("air", 0)) > 0 or J.num(st.get("down", 0)) > 0:
				var sn = str(DB.L("嚇彈起" if J.num(st.get("air", 0)) > 0 else "腳軟"))
				lines.append({"k": "text", "s": sn, "px": 14, "col": Color("#99ffff") if J.num(st.get("air", 0)) > 0 else Color("#ffcc99"), "w": f.get_string_size(sn, HORIZONTAL_ALIGNMENT_LEFT, -1, 14).x + 10.0, "h": 18.0, "opt": true})
			var ft = u.get("fearT")
			if side1 and ft is Dictionary and J.num(ft.get("until", 0)) > op.t:
				var fn = str(DB.L("失神"))
				lines.append({"k": "text", "s": fn, "px": 15, "col": Color("#e6c4ff"), "w": f.get_string_size(fn, HORIZONTAL_ALIGNMENT_LEFT, -1, 15).x + 10.0, "h": 19.0, "opt": true})
		AL.add_block(u, _scr(hd) + Vector2(0, -2), lines)
	n.draw_set_transform_matrix(Transform2D.IDENTITY)
	# 特效
	for fx in op.fx:
		var p: Vector2 = fx.p
		if not vr.has_point(p): continue
		var t = J.num(fx.t); var life = J.num(fx.life); var k = t / life
		match str(fx.kind):   # spark／slash／ring 改由 rts_fx 貼圖特效畫（同夜班巡陰一樣）
			"num":
				var a = 1.0 if k < 0.7 else 1.0 - (k - 0.7) / 0.3
				var pop = 0.35 + (t / 0.1) * 1.05 if t < 0.1 else (1.4 - (t - 0.1) / 0.1 * 0.4 if t < 0.2 else 1.0)
				var wp = p + Vector2(J.num(fx.vx) * t, -60 * t + 0.5 * 160 * t * t)
				_at(n, wp, pop)
				var col = Color(fx.col); col.a = a
				_str(n, f, str(fx.text), 0, 0, 20 if J.t(fx.get("big")) else 16, col, 5)
			"txt":   # [abui] 技能名、怕X・失神、連嚇：同 ab 飄字一齊排（唔重疊）
				var dk = "%s@%d,%d" % [str(fx.text), int(p.x / 48.0), int(p.y / 48.0)]
				if _txt_seen.has(dk): continue   # 同一句喺同一位（例如霸體每次擋控場都出）：只出一個
				_txt_seen[dk] = true
				var a = 1.0 if k < 0.7 else 1.0 - (k - 0.7) / 0.3
				var col = Color(fx.col); col.a = a
				AL.add_float(fx, _scr(p), str(fx.text), int(fx.get("px", 15)), col, t * 22.0, 1.0, null)
		n.draw_set_transform_matrix(Transform2D.IDENTITY)
	# 戰報（結算後 4.5 秒，喺戰場上面）
	if op.has_meta("report") and op.phase in ["back", "done"]:
		if not op.has_meta("rep_t"):
			op.set_meta("rep_t", _t)
			_rep_sfx(op)   # [sfx43] 戰報卡出：MVP／魔王掉魂魄／專屬物
		var age = _t - float(op.get_meta("rep_t"))
		var srows = load("res://game/rts/abil.gd").stats_rows(op) if op.get("ab_log") is Dictionary else []   # [補丁43] 戰後統計
		var life = 7.5 if srows.size() else 4.5
		if age < life and vr.has_point(op.anchor):
			var rep: Dictionary = op.get_meta("report")
			var a = clampf(age / 0.25, 0, 1) * (1.0 if age < life - 0.7 else 1.0 - (age - (life - 0.7)) / 0.7)
			_at(n, op.anchor + Vector2(0, -96), 0.9 + 0.1 * clampf(age / 0.2, 0, 1))
			var l1 = str(rep.get("head", "")); var l2 = str(rep.get("reward", ""))
			var lost: Array = rep.get("lost", [])
			var w = maxf(f.get_string_size(l1, HORIZONTAL_ALIGNMENT_LEFT, -1, 22).x, f.get_string_size(l2, HORIZONTAL_ALIGNMENT_LEFT, -1, 15).x)
			for x in lost: w = maxf(w, f.get_string_size(str(x), HORIZONTAL_ALIGNMENT_LEFT, -1, 15).x)
			if srows.size(): w = maxf(w, 300.0)
			w = minf(w, nv.size.x - 40.0)
			var h = 36.0 + (22.0 if l2 != "" else 0.0) + 20.0 * lost.size() + ((24.0 + 19.0 * mini(5, srows.size())) if srows.size() else 0.0)
			var win = J.t(rep.get("win"))
			n.draw_style_box(_box(Color(0.96, 0.9, 0.74, 0.94 * a), 6), Rect2(-w / 2 - 14, -30, w + 28, h))
			n.draw_rect(Rect2(-w / 2 - 10, -26, w + 20, h - 8), Color(0.6, 0.14, 0.1, 0.8 * a) if win else Color(0.3, 0.26, 0.24, 0.8 * a), false, 2.0)
			_str(n, f, l1, 0, -2, 22, Color(0.62, 0.1, 0.06, a) if win else Color(0.3, 0.26, 0.24, a), 0)
			var y = 22.0
			if l2 != "": _str(n, f, l2, 0, y, 15, Color(0.25, 0.18, 0.1, a), 0); y += 20.0
			for x in lost: _str(n, f, str(x), 0, y, 15, Color(0.55, 0.12, 0.1, a), 0); y += 20.0
			if srows.size():   # [補丁43] 名　輸出　承傷　治療（MVP 金色）
				var cx = [-w / 2 + 50.0, -w / 2 + w * 0.45, -w / 2 + w * 0.66, -w / 2 + w * 0.87]
				var hd = [L("名鬼", "名鬼"), L("輸出", "輸出"), L("承傷", "承傷"), L("治療", "治療")]
				for i in 4: _str(n, f, hd[i], cx[i], y + 2, 14, Color(0.4, 0.3, 0.2, a), 0)
				y += 21.0
				for r0 in srows.slice(0, 5):
					var cl = Color(0.7, 0.45, 0.05, a) if r0.mvp else Color(0.25, 0.18, 0.1, a)
					var nm = str(DB.L(str(r0.name)))
					if nm.length() > 6: nm = nm.substr(0, 6)
					_str(n, f, ("★" if r0.mvp else "") + nm, cx[0], y, 14, cl, 0)
					_str(n, f, _kn(J.num(r0.dmg)), cx[1], y, 14, cl, 0)
					_str(n, f, _kn(J.num(r0.tak)), cx[2], y, 14, cl, 0)
					_str(n, f, _kn(J.num(r0.heal)), cx[3], y, 14, cl, 0)
					y += 19.0
			n.draw_set_transform_matrix(Transform2D.IDENTITY)

static func _kn(x: float) -> String:   # 1234 → 1.2K
	if x >= 1e6: return "%.1fM" % (x / 1e6)
	if x >= 1e4: return "%dK" % int(x / 1e3)
	if x >= 1e3: return "%.1fK" % (x / 1e3)
	return str(int(round(x)))
# [abui] 據點預覽敵人：頭頂機制細圖示（出擊前喺地圖都睇到「佢識飛」）
func _draw_pv_mech(n: CanvasItem, vr: Rect2) -> void:
	if _z() < 0.35: return   # 拉得太遠唔畫（太細睇唔清，反而遮地圖）
	for u in _pvu:
		if not vr.has_point(u.p): continue
		var ms = AH.mechs(u)
		if ms.is_empty(): continue
		var h = 78.0 if J.t(u.get("boss")) else 56.0
		var row = []
		for m in ms.slice(0, 3): row.append(AI.canon(m))
		AL.add_block(u, _scr((u.p as Vector2) + Vector2(0, -h - 6 - AH.lift_of(null, u))), [{"k": "icons", "keys": row, "w": row.size() * (AH.IC * 2.0 + 3.0) + 2.0, "h": AH.IC * 2.0 + 5.0}])

# ================= 技能小圓鈕＋戰況條 =================
func _sync_ui() -> void:
	var op = _main_op()
	chip.visible = op != null
	var want = {}
	if op != null:
		_chip_text(op)
		var c = nv.zone_cam()
		var top = 0.0
		if nv.has_method("_zone_top_px"): top = float(nv._zone_top_px()) if ov.offset_top > 0 else 0.0
		var dock_i = 0
		for u in op.units:
			if J.num(u.side) != 0 or J.t(u.get("minion")) or u.get("sk") == null: continue
			if op.phase != "fight": continue
			if not J.t(u.get("out")): continue
			var key = J.str(u.get("gid", u.k))
			want[key] = true
			var b = btns.get(key)
			if b == null:
				b = SkillBtn.new(); b.u = u; b.op = op; b.view = self; ui.add_child(b); btns[key] = b
			b.u = u; b.op = op
			# 貼畫面右邊豎排（唔遮戰場；位置固定，手指易撳）；名鬼頭頂另有小金點提示「可以放」
			var sp = Vector2(nv.size.x - BTN * 0.5 - 8, nv.size.y * 0.40 + dock_i * (BTN + 26)); dock_i += 1
			b.docked = true
			b.position = (sp - Vector2(BTN, BTN) * 0.5).round()
			b.queue_redraw()
	for k in btns.keys():
		if not want.has(k): btns[k].queue_free(); btns.erase(k)
	chip_auto.visible = not btns.is_empty()
	if chip_auto.visible:
		_sync_auto()
		chip_auto.position = Vector2(nv.size.x - 56 - 6, nv.size.y * 0.40 - BTN * 0.5 - 40)
func _chip_text(op) -> void:
	var s = ""
	match op.phase:
		"march": s = L("行軍", "行軍")
		"fight": s = L("交戰", "交戰")
		"end": s = L("結算", "結算")
		"back":
			var r = op.result
			s = L("凱旋", "凱旋") if r != null and J.t(r.get("win")) else L("撤退", "撤退")
	var nm = {"stage": op.sid, "boss": L("王戰", "王戰"), "cap": L("親征", "親征"), "capauto": L("攻佔", "攻佔"), "raid": L("迎擊", "迎擊"), "raidauto": L("守村", "守村")}.get(op.kind, op.sid)
	chip_l.text = "%s %s" % [op.title if op.kind == "sortie" else nm, s]   # [sortie] 出擊顯示據點名
	chip_recall.visible = op.phase in ["march", "fight"]

class SkillBtn extends Control:
	var u: Dictionary
	var op
	var view
	var docked := false
	func _init() -> void:
		custom_minimum_size = Vector2(BTN, BTN + 18); size = Vector2(BTN, BTN + 18)
		mouse_filter = Control.MOUSE_FILTER_STOP
	func ready_() -> bool: return op != null and op.phase == "fight" and J.num(u.get("energy", 0)) >= 100 and J.num(u.get("hp", 0)) > 0 and u.get("casting") == null
	var hold := -1.0              # [abui] 長按計時（≥ HOLD 秒＝切換呢隻自動／手動）
	const HOLD := 0.6
	func _gui_input(ev: InputEvent) -> void:
		var down = (ev is InputEventMouseButton and ev.pressed and ev.button_index == MOUSE_BUTTON_LEFT) or (ev is InputEventScreenTouch and ev.pressed)
		var up = (ev is InputEventMouseButton and not ev.pressed and ev.button_index == MOUSE_BUTTON_LEFT) or (ev is InputEventScreenTouch and not ev.pressed)
		if down:
			accept_event()
			hold = 0.0
			if op != null and op.cast(u):
				RTS.LOG.append(["cast", J.str(u.k)])
				Snd.play("click")
		elif up:
			accept_event(); hold = -1.0
	func _process(dt: float) -> void:   # [abui] 長按
		if hold < 0: return
		hold += dt
		if hold >= HOLD:
			hold = -1.0
			long_press()
	func auto_now() -> bool:
		var B = J.G.get("Battle")
		return AH.auto_of(u, J.t(J.gp(B, "auto")) if B != null else false)
	func long_press() -> void:
		var B = J.G.get("Battle")
		var on = AH.toggle(u, J.t(J.gp(B, "auto")) if B != null else false)
		var nm = str(DB.L(J.str(u.get("name", ""))))
		RTS.toast(RTS.L("%s：%s", "%s：%s") % [nm, RTS.L("自動放技能", "自動放技能") if on else RTS.L("手動（撳先放）", "手動（點擊才放）")])
		RTS.LOG.append(["ab_auto", J.str(u.k), on])
		Snd.play("click")
		queue_redraw()
	func _draw() -> void:
		var c = Vector2(BTN, BTN) * 0.5; var R = BTN * 0.5
		var dead = J.num(u.get("hp", 0)) <= 0
		var en = clampf(J.num(u.get("energy", 0)) / 100.0, 0, 1)
		var rd = ready_()
		var t = Time.get_ticks_msec() / 1000.0
		var pulse = 1.0 + (0.06 * sin(t * 8.0) if rd else 0.0)
		draw_set_transform(c, 0, Vector2(pulse, pulse)); var o = Vector2.ZERO
		draw_circle(o + Vector2(0, 2), R, Color(0, 0, 0, 0.45))
		if rd: draw_circle(o, R + 4, Color(1, 0.8, 0.3, 0.35 + 0.25 * sin(t * 8.0)))
		draw_circle(o, R, Color(0.16, 0.1, 0.09, 0.95) if not dead else Color(0.2, 0.2, 0.2, 0.9))
		var r = Art.portrait_region(J.str(u.k))
		if r.size():
			var s = R * 1.36
			draw_texture_rect_region(r[0], Rect2(o - Vector2(s, s) * 0.5, Vector2(s, s)), r[1], Color(1, 1, 1, 1) if not dead else Color(0.45, 0.45, 0.45, 1))
		draw_arc(o, R - 2, 0, TAU, 40, Color(0, 0, 0, 0.6), 5.0, true)
		if not dead and en > 0.0: draw_arc(o, R - 2, -PI / 2, -PI / 2 + TAU * en, 40, Color("#ffd84a") if rd else Color("#7dd3fc"), 4.0, true)
		draw_arc(o, R, 0, TAU, 40, Color("#e8b070") if not rd else Color("#fff2b0"), 1.5, true)
		var f = UIKit.font("sans", 900)
		if rd:   # 「放」印
			draw_circle(o + Vector2(R * 0.72, -R * 0.72), 11, Color("#c8372d"))
			var w = f.get_string_size("放", HORIZONTAL_ALIGNMENT_LEFT, -1, 14).x
			draw_string(f, o + Vector2(R * 0.72 - w / 2, -R * 0.72 + 5), "放", HORIZONTAL_ALIGNMENT_LEFT, -1, 14, Color.WHITE)
		draw_set_transform_matrix(Transform2D.IDENTITY)
		if hold >= 0.12:   # [abui] 長按進度圈
			draw_arc(c, R + 5, -PI / 2, -PI / 2 + TAU * clampf(hold / HOLD, 0, 1), 40, Color("#7ac0b0"), 4.0, true)
		var au = auto_now()   # [abui] 左下角「自／手」牌（長按切換）
		var bc = c + Vector2(-R * 0.6, R * 0.6)
		draw_circle(bc, 10, Color("#2e5d55") if au else Color("#4a3a32"))
		draw_arc(bc, 10, 0, TAU, 20, Color("#7ac0b0") if au else Color("#a08870"), 1.5, true)
		var bt = "自" if au else "手"; var bw = f.get_string_size(bt, HORIZONTAL_ALIGNMENT_LEFT, -1, 13).x
		draw_string(f, bc + Vector2(-bw / 2, 5), bt, HORIZONTAL_ALIGNMENT_LEFT, -1, 13, Color.WHITE)
		if docked:   # 貼邊：名（知道係邊隻）
			var nm = str(DB.L(J.str(u.get("name", ""))))
			var w2 = f.get_string_size(nm, HORIZONTAL_ALIGNMENT_LEFT, -1, 14).x
			draw_string_outline(f, Vector2(c.x - w2 / 2, BTN + 15), nm, HORIZONTAL_ALIGNMENT_LEFT, -1, 14, 4, DARK)
			draw_string(f, Vector2(c.x - w2 / 2, BTN + 15), nm, HORIZONTAL_ALIGNMENT_LEFT, -1, 14, Color("#ffe8c8"))
