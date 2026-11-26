# [soul2] 名鬼圖鑑 101 格＋詳情＋篩選（品級／8 系）＋每 10 隻完成獎；王座重遊頁（全部 static；冇 class_name）
#   入口：ui/menus/menus.gd _draw_roster 掛鈎 → roster_btns(body)；之後 open()／open_throne()
#   四種狀態：已招降（彩色＋職級星）、有魂魄（灰＋進度環）、已遇見（灰）、未遇見（原圖染黑做剪影＋？？？＋傳聞＋地點）
#   圖：老闆原圖全身，按比例縮入格（唔裁切、唔出格）。新鬼未有圖：程序畫墨線剪影（暫代圖，只改 _no_art 一處）
extends RefCounted

const SOUL = preload("res://game/soul/soul_data.gd")
const S2 = preload("res://game/soul/soul2.gd")
const FX = preload("res://game/soul/soul_fx.gd")
const INK := Color("#2b1d12")
const DIM := Color("#6e5838")
const RED := Color("#9c2219")
const COLS := 4                 # 手機直屏：4 欄（格闊約 100px，字夠大）
const CELL_H := 158.0
const AF_SIDE := 5.0            # [p44] 最高階立繪左右越界上限（< 格距 6，唔會掂到隔籬卡）

static var f_pin := ""          # 篩選：品級（""＝全部）
static var f_sys := ""          # 篩選：系
static var view := "grid"       # grid／detail／throne
static var cur_k := ""
static var LOG: Array = []

static func L(yue: String, zhs: String) -> String: return SOUL.L(yue, zhs)
static func _m(): return Engine.get_main_loop().root.get_node_or_null("Main")
static func _rich(t: String, px := 17, col := INK) -> RichTextLabel:
	var r = UIKit.rich(t, px, col); r.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	return r
static func _btn(t: String, kind: String, on: bool, f: Callable, px := 17, h := 44) -> Button:
	var b = UIKit.btn(t, kind); b.disabled = not on; b.focus_mode = Control.FOCUS_NONE
	b.add_theme_font_size_override("font_size", px); b.custom_minimum_size = Vector2(0, h)
	b.pressed.connect(func(): Snd.play("click"); f.call())
	return b
static func _h(parent: Control, t: String) -> void: parent.add_child(_rich("[b]%s[/b]" % t, 19, Color("#7a2416")))

# ======================= 名冊掛鈎：兩個入口掣 =======================
static func roster_btns(body: Control) -> void:
	if SOUL.st() == null: return
	var hb = HBoxContainer.new(); hb.add_theme_constant_override("separation", 8)
	var a = _btn(L("名鬼圖鑑 %d/%d", "名鬼圖鑑 %d/%d") % [S2.got_n(), S2.total()] + ("・領獎" if _ms_can() > 0 else ""), "gold", true, func(): open(), 17, 46)
	a.size_flags_horizontal = Control.SIZE_EXPAND_FILL; hb.add_child(a)
	var nk = _throne_ready()
	var b = _btn(L("王座重遊", "王座重遊") + ("・%d" % nk if nk > 0 else ""), "", true, func(): open_throne(), 17, 46)
	b.size_flags_horizontal = Control.SIZE_EXPAND_FILL; hb.add_child(b)
	body.add_child(hb)
static func _ms_can() -> int: return S2.ms_list().filter(func(x): return x.state == "can").size()
static func _throne_ready() -> int:
	var n = 0
	var cl = SOUL.S().get("cleared", {})
	for kd in S2.kings():
		if J.t(J.gp(cl, str(kd.sid))) and not J.t(S2._kday().done.get(str(kd.k))): n += 1
	return n

# ======================= 開圖鑑 =======================
static func open() -> void:
	view = "grid"
	Menus._begin(L("名鬼圖鑑", "名鬼圖鑑"), "soul_codex", func(): pass)
	render()
static func open_detail(k: String) -> void:
	view = "detail"; cur_k = k
	Menus._begin(L("名鬼圖鑑", "名鬼圖鑑"), "soul_codex", func(): pass)
	render()
static func open_throne() -> void:
	view = "throne"
	Menus._begin(L("王座重遊", "王座重遊"), "soul_codex", func(): pass)
	render()
static func render() -> void:
	var m = _m()
	if m == null: return
	Menus._clear()
	var body: VBoxContainer = m.sheet_body
	match view:
		"detail": _detail(body, cur_k)
		"throne": _throne(body)
		_: _grid(body)
	if m.get("sheet_scroll") != null: m.sheet_scroll.scroll_vertical = 0
static func filtered() -> Array:
	var o = []
	for x in S2.list():
		var k = str(x.k)
		if f_pin != "" and S2.pin(k) != f_pin: continue
		if f_sys != "" and S2.sys_of(k) != f_sys: continue
		o.append(x)
	return o

static func _grid(body: VBoxContainer) -> void:
	var n = S2.got_n()
	body.add_child(_rich(L("已招降 [b]%d[/b]/%d　每 10 隻一個獎", "已招降 [b]%d[/b]/%d　每 10 隻一個獎") % [n, S2.total()], 18))
	# 完成獎：一行字＋（有得領先出）領獎掣
	var ml = S2.ms_list()
	var gotn = ml.filter(func(x): return x.state == "got").size()
	var nx = ml.filter(func(x): return x.state == "lock")
	var t = L("完成獎：已領 %d/%d", "完成獎：已領 %d/%d") % [gotn, ml.size()]
	if nx.size(): t += L("　下一個 %d 隻（差 %d）", "　下一個 %d 隻（差 %d）") % [int(nx[0].m), int(nx[0].m) - n]
	body.add_child(_rich(t, 16, DIM))
	for x in ml:
		if x.state != "can": continue
		var mm = int(x.m)
		var b = _btn(L("領「年度員工大合照」（%d 隻）：散魂 +%d、紫箱", "領「年度員工大合照」（%d 隻）：散魂 +%d、紫箱") % [mm, S2.MS_SAN], "gold", true, func():
			if S2.ms_claim(mm) == "ok":
				var m = _m()
				if m != null and m.has_method("show_banner"): m.show_banner(S2.ms_text(mm))
				Snd.play("chest")
			render(), 16, 44)
		body.add_child(b)
	# 篩選
	body.add_child(_rich(L("品級", "品級"), 16, DIM))
	var pr = HFlowContainer.new(); pr.add_theme_constant_override("h_separation", 6); pr.add_theme_constant_override("v_separation", 6)
	for p in ["", "凡", "靈", "煞", "王"]:
		var pp = p
		var b = _btn(p if p != "" else L("全部", "全部"), "gold" if f_pin == p else "", true, func(): f_pin = pp; render(), 17, 42)
		b.custom_minimum_size = Vector2(60, 42); pr.add_child(b)
	body.add_child(pr)
	body.add_child(_rich(L("系", "系"), 16, DIM))
	var sr = HFlowContainer.new(); sr.add_theme_constant_override("h_separation", 6); sr.add_theme_constant_override("v_separation", 6)
	for s in ["", "魂", "屍", "厲", "妖", "使", "橫", "紙紮", "官"]:
		var ss = s
		var b = _btn(s if s != "" else L("全部", "全部"), "gold" if f_sys == s else "", true, func(): f_sys = ss; render(), 17, 42)
		b.custom_minimum_size = Vector2(72 if s == "" or s == "紙紮" else 52, 42); sr.add_child(b)
	body.add_child(sr)
	var lst = filtered()
	body.add_child(_rich(L("顯示 %d 格　撳格仔睇詳情", "顯示 %d 格　按格子看詳情") % lst.size(), 15, DIM))
	var gr = GridContainer.new(); gr.columns = COLS
	gr.add_theme_constant_override("h_separation", 6); gr.add_theme_constant_override("v_separation", 6)
	gr.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	for x in lst:
		var c = Cell.new(); c.k = str(x.k); c.no = int(x.no)
		c.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		c.prep()
		c.custom_minimum_size = Vector2(0, CELL_H + c.pad)   # [p44] 最高階：格頂預留越界位（同一行一齊高，卡照貼底）
		gr.add_child(c)
	var gm = MarginContainer.new()   # [p44] 左右留 6px：最高階立繪越過卡邊唔會俾 ScrollContainer 切走
	gm.add_theme_constant_override("margin_left", AF_SIDE + 1); gm.add_theme_constant_override("margin_right", AF_SIDE + 1)
	gm.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	gm.add_child(gr)
	body.add_child(gm)
	if lst.is_empty(): body.add_child(_rich(L("呢個篩選冇鬼。", "這個篩選沒有鬼。"), 17, DIM))

# ---- 格仔 ----
class Cell extends Control:
	const SOUL = preload("res://game/soul/soul_data.gd")
	const S2 = preload("res://game/soul/soul2.gd")
	const FX = preload("res://game/soul/soul_fx.gd")
	const CH := 158.0       # = CH
	const SIDE := 5.0       # = SIDE
	var k := ""
	var no := 0
	var st := "unseen"
	var tex: Texture2D = null
	var nm := ""
	var pin := ""
	var rk := 0
	var have := 0
	var need := 1
	var lv := 0
	var brk_l := 0          # [p44] 撐爆畫框：0＝照舊；1＝最高階；2＝酒吞第四階（更強）
	var pad := 0.0
	var brk := []           # [p44] 測試：[卡框, 立繪實際範圍, 唔可以遮嘅文字範圍, 頂部文字（喺立繪之後畫）]
	func prep() -> void:
		st = S2.state(k)
		tex = FX.tex_of(k) if SOUL.is_ghost(k) or k == "afu" else null
		nm = SOUL.gname(k) if SOUL.is_ghost(k) or k == "afu" else str(S2.entry(k).get("name", k))
		pin = S2.pin(k)
		var g = SOUL.ghost(k)
		if st == "own" and g != null: lv = int(J.num(g.get("lv", 1)))
		if st == "own" and k != "afu": rk = SOUL.rank(k)
		if st == "prog": have = SOUL.souls(k); need = maxi(1, SOUL.need_of(k))
		mouse_filter = Control.MOUSE_FILTER_STOP
		tooltip_text = ""
		var AF = load("res://game/soul/ace_frame.gd")
		brk_l = AF.lvl(k) if st == "own" and tex != null else 0
		pad = AF.pad(brk_l, CH - 3)
	func _gui_input(ev: InputEvent) -> void:
		if (ev is InputEventMouseButton and ev.button_index == MOUSE_BUTTON_LEFT and not ev.pressed) or (ev is InputEventScreenTouch and not ev.pressed):
			accept_event(); Snd.play("paper")
			load("res://game/soul/soul_codex.gd").open_detail(k)
	func _draw() -> void:
		var W = size.x; var H = size.y
		var own = st == "own"
		var bg = Color("#f6ecd2") if own else (Color("#e4dccb") if st != "unseen" else Color("#d3cbbb"))
		var r = Rect2(1, H - CH + 1, W - 3, CH - 3)   # [p44] 卡貼底（最高階格頂多咗越界位）
		draw_rect(Rect2(r.position + Vector2(2, 3), r.size), Color(0, 0, 0, 0.18))
		draw_rect(r, bg)
		var edge = Color("#d9a030") if own and rk >= 5 else FX.INK
		draw_rect(r, edge, false, 3.0 if own and rk >= 5 else 2.0)
		# 品級色條
		var pc = FX.PINC.get(pin, Color.GRAY)
		draw_rect(Rect2(r.position.x + 2, r.position.y + 2, r.size.x - 4, 5), Color(pc, 0.9 if st != "unseen" else 0.35))
		if brk_l == 0: _head(r, pc, false)
		# 圖框：全身原圖縮入（唔裁切）
		var box = Rect2(r.position.x + 6, r.position.y + 28, r.size.x - 12, CH - 28 - 66)
		var mod = Color.WHITE
		match st:
			"prog", "seen": mod = Color(0.5, 0.5, 0.53)
			"unseen": mod = Color(0.06, 0.05, 0.07)
		if brk_l > 0:   # [p44] 最高階：撐爆畫框
			var AF = load("res://game/soul/ace_frame.gd")
			var yc = box.end.y
			AF.top_light(self, r, 3.0 if own and rk >= 5 else 2.0)
			var A = AF.draw_art(self, tex, r, yc, brk_l, 1.0, 1.18, SIDE, mod, 3.0 if own and rk >= 5 else 2.0, 0.0)
			AF.bottom_shade(self, r, yc, 2.0, 0.09)
			draw_line(Vector2(r.position.x + 2, yc), Vector2(r.end.x - 2, yc), Color(edge, 0.55), 1.5)   # 名牌上緣（喺立繪前面）
			var hd = _head(r, pc, true, yc)
			brk = [r, A, Rect2(r.position.x, yc + 1, r.size.x, r.end.y - yc - 1), hd]
		elif tex != null: draw_texture_rect(tex, FX.fit(tex, box), false, mod)
		else: load("res://game/soul/soul_codex.gd")._no_art(self, box, st)
		if st == "prog":   # 進度環
			var c = Vector2(box.end.x - 18, box.position.y + 18)
			draw_circle(c, 17, Color(0.1, 0.08, 0.06, 0.85))
			draw_arc(c, 13, -PI / 2, -PI / 2 + TAU * clampf(float(have) / need, 0, 1), 36, Color("#6fe0c0"), 5.0, true)
			draw_arc(c, 17, 0, TAU, 36, FX.INK, 1.5, true)
		# 名（太長：縮到 13；再長就分兩行）
		var nm2 = nm if st != "unseen" else "？？？"
		var two = st == "own" and k != "afu"
		var ny = H - (48 if two else 34)
		var f2 = FX.font("sans"); var mw = r.size.x - 8
		if f2.get_string_size(nm2, HORIZONTAL_ALIGNMENT_LEFT, -1, 13).x > mw:
			var cut = nm2.find(" ")
			if cut < 0: cut = nm2.length() / 2
			FX.text_c(self, nm2.substr(0, cut).strip_edges(), W / 2, ny - 14, 13, FX.INK, "sans", mw)
			FX.text_c(self, nm2.substr(cut).strip_edges(), W / 2, ny + 1, 13, FX.INK, "sans", mw)
		else: FX.text_c(self, nm2, W / 2, ny, 16, FX.INK, "sans", mw)
		# 底行
		var line = ""; var col = Color(FX.INK, 0.7)
		match st:
			"own": line = (SOUL.L("主角 Lv%d", "主角 Lv%d") % lv) if k == "afu" else ("Lv%d　%s" % [lv, SOUL.rank_name(rk)])
			"prog": line = "%d/%d" % [have, need]; col = Color("#2e6b5a")
			"seen": line = SOUL.L("已遇見", "已遇見")
			"unseen": line = SOUL.L("第%d章", "第%d章") % maxi(1, int(S2.entry(k).get("ch", 1)))
		if two:
			FX.text_c(self, line, W / 2, H - 27, 13, col, "sans", mw)
			for i in SOUL.RANK_MAX:   # 職級星
				_star(Vector2(W / 2 - 34 + i * 17, H - 12), 7.0, Color("#e8b040") if i < rk else Color(FX.INK, 0.18))
		else: FX.text_c(self, line, W / 2, H - 12, 14, col, "sans", mw)
	# 格頂：編號＋品級；返回文字範圍
	#   最高階（plate）：頂部讓俾衝出框嘅頭，編號／品級改擺喺立繪窗底（名牌上緣之上、壓喺下半身），喺立繪之後畫、墊紙底，永遠睇得清
	func _head(r: Rect2, pc: Color, plate: bool, yc := 0.0) -> Array:
		var f = FX.font("sans")
		var out = []
		var ns = "%03d" % no
		var nw = f.get_string_size(ns, HORIZONTAL_ALIGNMENT_LEFT, -1, 13).x
		var y0 = r.position.y if not plate else yc - 28.0   # 文字基線 = y0 + 22／23（最高階：牌底離名牌線 1px）
		var nr = Rect2(r.position.x + 3, y0 + 9, nw + 6, 17)
		if plate:
			draw_rect(nr, Color("#f6ecd2", 0.9)); draw_rect(nr, Color(FX.INK, 0.35), false, 1.0)
		draw_string(f, Vector2(r.position.x + 6, y0 + 22), ns, HORIZONTAL_ALIGNMENT_LEFT, -1, 13, Color(FX.INK, 0.55 if not plate else 0.8))
		out.append(nr)
		if st != "unseen" and pin != "":
			var pl = load("res://game/soul/soul_up.gd").pin_label(pin)
			var pw = f.get_string_size(pl, HORIZONTAL_ALIGNMENT_LEFT, -1, 14).x
			var pr = Rect2(r.end.x - pw - 9, y0 + 8, pw + 6, 19)
			if plate:
				draw_rect(pr, Color("#f6ecd2", 0.9)); draw_rect(pr, Color(FX.INK, 0.35), false, 1.0)
			draw_string(f, Vector2(r.end.x - pw - 6, y0 + 23), pl, HORIZONTAL_ALIGNMENT_LEFT, -1, 14, pc.darkened(0.15))
			out.append(pr)
		return out
	func _star(p: Vector2, rr: float, col: Color) -> void:
		var pts = PackedVector2Array()
		for i in 10:
			var a = -PI / 2 + i * PI / 5
			pts.append(p + Vector2(cos(a), sin(a)) * (rr if i % 2 == 0 else rr * 0.45))
		draw_colored_polygon(pts, col)

# 新鬼未有圖：墨線鬼影（暫代圖；美術到咗只要 PtGfx 有圖就自動用原圖）
static func _no_art(c: CanvasItem, box: Rect2, st: String) -> void:
	var cx = box.get_center().x; var bot = box.end.y - 4
	var h = minf(box.size.y - 8, box.size.x * 1.25); var w = h * 0.62
	var top = bot - h
	var pts = PackedVector2Array()
	for i in 13:   # 頭＋身
		var a = PI + i * PI / 12.0
		pts.append(Vector2(cx + cos(a) * w * 0.5, top + w * 0.5 + sin(a) * w * 0.5))
	for i in 7:   # 下擺波浪
		var x = cx + w * 0.5 - i * w / 6.0
		pts.append(Vector2(x, bot - (8.0 if i % 2 == 0 else 0.0)))
	var fill = Color(0.06, 0.05, 0.07) if st == "unseen" else Color(0.45, 0.45, 0.48)
	c.draw_colored_polygon(pts, fill)
	pts.append(pts[0]); c.draw_polyline(pts, FX.INK, 2.0, true)
	FX.text_c(c, "？", cx, top + w * 0.62, int(w * 0.5), Color(0.85, 0.8, 0.7, 0.8), "serif")

# ======================= 詳情 =======================
static func _detail(body: VBoxContainer, k: String) -> void:
	var st = S2.state(k)
	var ent = S2.entry(k)
	var known = st != "unseen"
	var top = HBoxContainer.new(); top.add_theme_constant_override("separation", 8)
	var bk = _btn(L("← 返回圖鑑", "← 返回圖鑑"), "", true, func(): view = "grid"; render(), 17, 44); bk.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	top.add_child(bk)
	var lst = filtered(); var idx = -1
	for i in lst.size(): if str(lst[i].k) == k: idx = i
	if idx >= 0:
		var pk = str(lst[(idx - 1 + lst.size()) % lst.size()].k); var nk = str(lst[(idx + 1) % lst.size()].k)
		var pb = _btn("‹", "", true, func(): open_detail(pk), 20, 44); pb.custom_minimum_size = Vector2(56, 44); top.add_child(pb)
		var nb = _btn("›", "", true, func(): open_detail(nk), 20, 44); nb.custom_minimum_size = Vector2(56, 44); top.add_child(nb)
	body.add_child(top)
	# 大圖＋名
	var hb = HBoxContainer.new(); hb.add_theme_constant_override("separation", 12)
	var art = Big.new(); art.k = k; art.st = st; art.custom_minimum_size = Vector2(170, 230); art.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	art.tex = FX.tex_of(k) if SOUL.is_ghost(k) or k == "afu" else null
	art.setup()   # [p44] 最高階：頂部預留越界位、左邊留位（唔俾 ScrollContainer 切）
	hb.add_child(art)
	var vb = VBoxContainer.new(); vb.size_flags_horizontal = Control.SIZE_EXPAND_FILL; vb.add_theme_constant_override("separation", 4); hb.add_child(vb)
	var gd = SOUL.GH().get(k, {})
	var name = (SOUL.gname(k) if SOUL.is_ghost(k) or k == "afu" else str(ent.get("name", k))) if known else "？？？"
	vb.add_child(_rich("[font_size=14][color=#6e5838]No.%03d[/color][/font_size]\n[b]%s[/b]" % [int(ent.get("no", 0)), name], 24))
	if known and str(gd.get("title", "")) != "": vb.add_child(_rich(str(DB.N(str(gd.title))), 16, DIM))
	var pin = S2.pin(k)
	var sysn = S2.sys_of(k)
	if known:
		var UP = load("res://game/soul/soul_up.gd")
		var stn = UP.star(k) if SOUL.is_ghost(k) else 0
		vb.add_child(_rich("[color=#%s][b]%s[/b][/color]%s　%s" % [UP.tag_col(k).darkened(0.15).to_html(false), UP.tag_name(k) if pin != "主" else L("主角", "主角"), ("　[color=#b07a1f]" + "★".repeat(stn) + "[/color]") if stn > 0 else "", (L("%s系", "%s系") % sysn if sysn != "" and sysn != "主" else "")], 18))
		if SOUL.is_ghost(k) or k == "afu":   # [roles] 定位
			var RO = load("res://game/rts/roles.gd"); var ci = RO.info(k)
			var tl = RO.tier(k); var sb0 = RO.sub(k)
			vb.add_child(_rich("[color=%s][b]【%s】%s%s[/b][/color]　[color=%s][b]%s[/b][/color]　%s系" % [str(ci.col), str(ci.zh), RO.T(ci.full), ("・" + sb0) if sb0 != "" else "", "#" + RO.tier_col(k).to_html(false), tl, RO.sys_of(k)], 15))
			vb.add_child(_rich(RO.T(ci.desc) + ((RO.T(["　另有【毒】：每打三下令敵人中毒。", "　另有【毒】：每打三下讓敵人中毒。"])) if RO.has_poison(k) else ""), 14))
		var reg = str(S2.C().REG.get(str(ent.get("reg", "")), ""))
		if reg != "": vb.add_child(_rich(L("地區：%s", "地區：%s") % reg, 16, DIM))
	vb.add_child(_rich(_state_line(k, st), 17, Color("#2e5a3a") if st == "own" else INK))
	if st == "own" and k != "afu":
		var r = SOUL.rank(k)
		vb.add_child(_rich("[color=#b07a1f]%s[/color]%s　%s" % ["★".repeat(r), "[color=#00000030]%s[/color]" % "★".repeat(SOUL.RANK_MAX - r), SOUL.rank_name(r)], 18))
	body.add_child(hb)
	body.add_child(UIKit.hsep())
	if not known:
		_h(body, L("傳聞", "傳聞"))
		body.add_child(_rich("「%s……」" % _rumor(k), 18, INK))
		_h(body, L("出沒地點", "出沒地點"))
		body.add_child(_rich(_where(k, true), 17, INK))
		body.add_child(_rich(L("打贏佢就知道佢係邊個。", "打贏他就知道他是誰。"), 16, DIM))
		_go_btns(body, k)
		return
	# 能力
	_h(body, L("能力", "能力"))
	var SK = J.G.get("SKILLS")
	var sk = SK.get(k) if SK is Dictionary else null
	if sk is Dictionary: body.add_child(_rich("[b]【%s】[/b]%s" % [str(DB.N(str(sk.get("name", "")))), str(DB.N(str(sk.get("desc", ""))))], 17))
	var AB = S2._ab()
	if AB != null and S2.abm("describe"):
		var ds = str(AB.describe(k))
		if ds != "": body.add_child(_rich(ds, 16, DIM))
	if str(gd.get("trait", "")) != "": body.add_child(_rich(str(DB.N(str(gd.trait))), 16, DIM))
	if SOUL.is_ghost(k) or k == "afu":   # [補丁43] 技能七層
		_h(body, L("技能七層", "技能七層"))
		load("res://game/soul/soul_sk.gd").add_to(body, k, func(tx, sz, c): return _rich(tx, sz, c), DIM, INK)
	# 標籤
	var tags = S2.tags_of(k)
	var mech = ent.get("mech", [])
	if tags.size() or (mech is Array and mech.size()):
		_h(body, L("標籤", "標籤"))
		var fl = HFlowContainer.new(); fl.add_theme_constant_override("h_separation", 6); fl.add_theme_constant_override("v_separation", 6)
		for tg in tags:
			var td = S2.C().TAGS.get(str(tg), {})
			fl.add_child(_chip(str(td.get("n", tg)), Color(str(td.get("c", "#a08050")))))
		body.add_child(fl)
		for tg in tags:
			var td = S2.C().TAGS.get(str(tg), {})
			if str(td.get("desc", "")) != "": body.add_child(_rich("[b]%s[/b]：%s" % [str(td.get("n", tg)), str(td.desc)], 15, DIM))
		if mech is Array and mech.size(): body.add_child(_rich(L("做敵人時嘅機制：%s", "做敵人時的機制：%s") % "、".join(mech), 15, DIM))
	var sd = S2.C().SYS.get(sysn, {})
	if sd is Dictionary and sd.has("fear"):
		var SC = S2.C().SC
		var fear = []
		for x in sd.fear: fear.append(str(SC.get(str(x), x)))
		body.add_child(_rich(L("%s系：怕%s；唔怕%s", "%s系：怕%s；不怕%s") % [sysn, "、".join(fear), str(SC.get(str(sd.imm), sd.imm))], 15, DIM))
	# 出處
	_h(body, L("出處", "出處"))
	var lore = str(gd.get("lore", ""))
	if lore == "": lore = str(ent.get("note", ""))
	body.add_child(_rich(str(DB.N(lore)) if lore != "" else L("落魄村原創。", "落魄村原創。"), 17))
	# 台詞
	var say = str(gd.get("say", ""))
	if say == "": say = str(S2.C().get("SAY_FB", {}).get(k, ""))
	if say == "" and SOUL.D().WISH.has(k): say = SOUL.wish_of(k)[1]
	if say != "":
		_h(body, L("台詞", "台詞"))
		body.add_child(_rich("「%s」" % str(DB.N(say)), 18, Color("#5a2a14")))
	# 魂魄
	if k != "afu" and SOUL.is_ghost(k):
		_h(body, L("魂魄", "魂魄"))
		if st == "own":
			var r2 = SOUL.rank(k)
			if r2 < SOUL.RANK_MAX: body.add_child(_rich(L("升職魂魄 %d/%d（下一級：%s）", "升職魂魄 %d/%d（下一級：%s）") % [SOUL.souls(k), SOUL.rank_cost(k, r2 + 1), SOUL.rank_name(r2 + 1)], 17))
			else: body.add_child(_rich(L("已經係合夥人：魂魄自動化成散魂", "已經是合夥人：魂魄自動化成散魂"), 17))
		elif SOUL.story(k) and not J.t(SOUL.st().got.get(k)): body.add_child(_rich(L("劇情鬼：跟主線加入；魂魄留嚟升職（%d）", "劇情鬼：跟主線加入；魂魄留著升職（%d）") % SOUL.souls(k), 17))
		else: body.add_child(_rich(L("招降魂魄 %d/%d", "招降魂魄 %d/%d") % [SOUL.souls(k), SOUL.need_of(k)], 17))
		_h(body, L("魂魄來源", "魂魄來源"))
		body.add_child(_rich(_where(k, false), 16, INK))
	_go_btns(body, k)
static func _go_btns(body: VBoxContainer, k: String) -> void:
	var bb = HBoxContainer.new(); bb.add_theme_constant_override("separation", 8)
	var SUI = load("res://game/soul/soul_ui.gd")
	var e = SUI._go_camp(k) if SOUL.is_ghost(k) else {}
	if not e.is_empty():
		var b = _btn(L("去出擊", "去出擊"), "gold", true, func(): SUI.go_camp(e), 17, 46); b.size_flags_horizontal = Control.SIZE_EXPAND_FILL; bb.add_child(b)
	var kd = S2.king(k)
	if not kd.is_empty():
		var b3 = _btn(L("王座重遊", "王座重遊"), "", true, func(): open_throne(), 17, 46); b3.size_flags_horizontal = Control.SIZE_EXPAND_FILL; bb.add_child(b3)
	if SOUL.is_ghost(k) and k != "afu" and S2.state(k) != "unseen":
		var b2 = _btn(L("去祭壇", "去祭壇"), "", true, func():
			SUI.tab = "promote" if SOUL.owned(k) else "summon"
			Menus.open_bld("altar"), 17, 46)
		b2.size_flags_horizontal = Control.SIZE_EXPAND_FILL; bb.add_child(b2)
	if bb.get_child_count() > 0: body.add_child(bb)
	var bk = _btn(L("返回圖鑑", "返回圖鑑"), "", true, func(): view = "grid"; render(), 17, 44)
	body.add_child(bk)
static func _chip(t: String, col: Color) -> Control:
	var pc = PanelContainer.new(); pc.add_theme_stylebox_override("panel", UIKit.sb(Color(col, 0.28), 6, Color("#2b1d12"), 1, Vector4(10, 4, 10, 4)))
	pc.add_child(UIKit.label(t, 17, INK, "sans", 900))
	return pc
static func _state_line(k: String, st: String) -> String:
	match st:
		"own": return L("已招降", "已招降") if k != "afu" else L("主角", "主角")
		"prog": return L("有魂魄 %d/%d，未招降", "有魂魄 %d/%d，未招降") % [SOUL.souls(k), SOUL.need_of(k)]
		"seen": return L("已遇見，未有魂魄", "已遇見，還沒有魂魄")
	return L("未遇見", "未遇見")
static func _rumor(k: String) -> String:   # lore 第一句截 12 字
	var gd = SOUL.GH().get(k, {})
	var s = str(DB.N(str(gd.get("lore", "")))) if gd is Dictionary else ""
	if s == "": s = str(S2.entry(k).get("note", ""))
	if s == "": s = L("有人話喺野外見過佢", "有人說在野外見過他")
	for sep in ["。", "，", "；", "（"]:
		var i = s.find(sep)
		if i > 0: s = s.substr(0, i)
	return s.substr(0, 12)
static func _where(k: String, short: bool) -> String:
	var o = []
	if SOUL.is_ghost(k):
		var ZDm = load("res://game/zone/zone_data.gd"); var SOm = load("res://game/sortie/so_data.gd")
		for x in SOUL.sources(k):
			var e = x.e
			o.append(L("第%d章・%s Lv.%d（%s）", "第%d章・%s Lv.%d（%s）") % [int(e.c) + 1, ZDm.T(SOm.RING_NAME[SOUL.ri(e.ring)]), int(e.lv), L("主魂", "主魂") if x.pri else L("副魂", "副魂")])
			if short and o.size() >= 2: break
	var kd = S2.king(k)
	if kd.is_empty():
		for x in S2.kings(): if k in x.ks: kd = x
	if not kd.is_empty(): o.append(L("王座重遊（主線 %s）每日 +%d", "王座重遊（主線 %s）每日 +%d") % [str(kd.sid), S2.THRONE_SOULS])
	if o.is_empty():
		var ch = int(S2.entry(k).get("ch", 0))
		if SOUL.story(k): return L("劇情：跟主線加入", "劇情：跟主線加入")
		return L("第%d章（據點未開放）", "第%d章（據點未開放）") % maxi(1, ch)
	return "\n".join(o)

class Big extends Control:
	const SOUL = preload("res://game/soul/soul_data.gd")
	const S2 = preload("res://game/soul/soul2.gd")
	const FX = preload("res://game/soul/soul_fx.gd")
	var k := ""
	var st := ""
	var tex: Texture2D = null
	var brk_l := 0
	var pad := 0.0
	var mx := 0.0
	var brk := []        # [p44] 測試：[框, 立繪實際範圍]
	const SD := 8.0
	func setup() -> void:
		var AF = load("res://game/soul/ace_frame.gd")
		brk_l = AF.lvl(k) if st == "own" and tex != null else 0
		if brk_l <= 0: return
		pad = AF.pad(brk_l, 224.0); mx = SD * AF.SIDE_K[brk_l] + 2
		custom_minimum_size = Vector2(170 + mx, 230 + pad)
	func _draw() -> void:
		var r = Rect2(Vector2(2 + mx, 2 + pad), size - Vector2(6 + mx, 6 + pad))
		var seed = hash(k) % 50
		FX.ink_card(self, r, Color("#f6ecd2") if st == "own" else Color("#ddd4c2"), seed)
		var box = r.grow(-10)
		var mod = Color.WHITE if st == "own" else (Color(0.06, 0.05, 0.07) if st == "unseen" else Color(0.55, 0.55, 0.58))
		if brk_l > 0:   # [p44] 最高階：撐爆畫框
			var AF = load("res://game/soul/ace_frame.gd")
			var ins = 2.5; var yc = r.end.y - ins
			AF.top_light(self, r, ins)
			var A = AF.draw_art(self, tex, r, yc, brk_l, 0.95, 1.3, SD, mod, ins, 0.0)
			AF.bottom_shade(self, r, yc, ins, 0.1)
			_edge_front(r, seed, r.position.y + r.size.y * 0.3)
			brk = [r, A]
		elif tex != null: draw_texture_rect(tex, FX.fit(tex, box), false, mod)
		else: load("res://game/soul/soul_codex.gd")._no_art(self, box, st)
	# 框底緣＋下半段左右邊重畫喺立繪前面（同 FX.ink_card 一樣嘅抖動）
	func _edge_front(r: Rect2, seed: int, y_from: float) -> void:
		var rng = RandomNumberGenerator.new(); rng.seed = 9137 + seed
		for i in 2:
			var j = Vector2(rng.randf_range(-1, 1), rng.randf_range(-1, 1)) * (1.2 + i)
			var c = Color(FX.INK, 0.9 if i == 0 else 0.35); var w = 2.6 if i == 0 else 1.2
			var a = r.position + j; var b = r.end + j
			draw_line(Vector2(a.x, b.y), Vector2(b.x, b.y), c, w)
			draw_line(Vector2(a.x, y_from), Vector2(a.x, b.y), c, w)
			draw_line(Vector2(b.x, y_from), Vector2(b.x, b.y), c, w)

# ======================= 王座重遊 =======================
static func _throne(body: VBoxContainer) -> void:
	body.add_child(_rich(L("打低過嘅劇情王，每日可以返去王座再挑戰一次：難度係當日王戰 ×1.1，打贏掉該王魂魄 +%d（留嚟升職）。每日 05:00 重置。", "打敗過的劇情王，每天可以回王座再挑戰一次：難度是當時王戰 ×1.1，打贏掉該王魂魄 +%d（留著升職）。每天 05:00 重置。") % S2.THRONE_SOULS, 16, DIM))
	var any = false
	for kd in S2.kings():
		any = true
		var k = str(kd.k)
		var c = S2.can_throne(k)
		var pc = PanelContainer.new(); pc.add_theme_stylebox_override("panel", UIKit.sb(Color(1, 0.97, 0.88, 0.55), 6, UIKit.PAPERLINE, 1, Vector4(10, 8, 10, 8)))
		var hb = HBoxContainer.new(); hb.add_theme_constant_override("separation", 10); pc.add_child(hb)
		var lock = c.why == "lock"
		var art = Big.new(); art.k = k; art.st = "unseen" if lock and not SOUL.seen(k) else ("own" if SOUL.owned(k) else "seen")
		art.tex = FX.tex_of(k); art.custom_minimum_size = Vector2(92, 120); art.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
		hb.add_child(art)
		var vb = VBoxContainer.new(); vb.size_flags_horizontal = Control.SIZE_EXPAND_FILL; vb.add_theme_constant_override("separation", 4); hb.add_child(vb)
		vb.add_child(_rich("[b]%s[/b]　[font_size=15][color=#6e5838]%s[/color][/font_size]" % [str(kd.name), L("主線 %s", "主線 %s") % str(kd.sid)], 19))
		var soul_t = []
		for kk in kd.ks: soul_t.append("%s %d" % [SOUL.gname(str(kk)), SOUL.souls(str(kk))])
		vb.add_child(_rich(L("魂魄：%s　每次 +%d", "魂魄：%s　每次 +%d") % ["、".join(soul_t), S2.THRONE_SOULS], 16))
		vb.add_child(_rich(L("難度：原王戰 ×%.1f（敵人血、攻 ×%.2f）", "難度：原王戰 ×%.1f（敵人血、攻 ×%.2f）") % [S2.THRONE_MUL, S2.throne_mul(kd)], 15, DIM))
		var why = S2.throne_why(c, kd)
		if why != "": vb.add_child(_rich(why, 16, RED if c.why != "done" else Color("#2e6b3a")))
		var kk2 = k
		var b = _btn(L("挑戰", "挑戰") if c.ok else (L("今日已挑戰", "今日已挑戰") if c.why == "done" else L("挑戰", "挑戰")), "gold", c.ok, func():
			var r = S2.throne_go(kk2)
			if r == "ok":
				var m = _m()
				Menus.close_hook()
				if m != null and m.has_method("_nav_on"): m._nav_on("village")
			else: render(), 17, 46)
		vb.add_child(b)
		body.add_child(pc)
	if not any: body.add_child(_rich(L("未有劇情王。", "還沒有劇情王。"), 17, DIM))
	body.add_child(_rich(L("小紙、孟婆、天花姐冇王戰：佢哋嘅魂魄靠野外據點副魂。", "小紙、孟婆、天花姐沒有王戰：他們的魂魄靠野外據點副魂。"), 15, DIM))
	var bk = _btn(L("返回圖鑑", "返回圖鑑"), "", true, func(): view = "grid"; render(), 17, 44)
	body.add_child(bk)
