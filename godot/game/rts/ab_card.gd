# [abui] 出擊偵察卡（兩張出擊小卡共用：rts._card_body 主線／王／親征、so_view.open_card 野外據點）
#   顯示：敵人系（色牌＋數量）、怕乜嚇法、機制大圖示（撳一下睇說明）；
#         我方 3 隻＋軍師：頭像、應對標籤（對到嘅亮起）；每個機制 ✔／✘；推薦（覆蓋最多未應對機制）＋「換上」；揀軍師。
#   數據：AB.mechs_of／AB.counters_of／AB.tags_of（abcore）、系＝data/nat/counter.json（cdata），冇就用後備表。
#   全部 static；冇 class_name。用法：AC.add_to(vb, 敵人 key 陣列, {"dark": true, "on_change": Callable})
extends RefCounted

const AB = preload("res://game/rts/abil.gd")
const AI = preload("res://game/rts/ab_icon.gd")
const BK = preload("res://game/barracks/bk_data.gd")

const SYS := {"屍": "#8a9a6a", "魂": "#7f98b4", "紙紮": "#b8a478", "妖": "#5f8a52", "厲": "#a8473f", "使": "#7d5a90", "官": "#4f6488", "橫": "#94683e"}
const SYS_FB := {"youhun": "魂", "egui": "魂", "eguiking": "魂", "shuigui": "魂", "xiaogui": "使", "toyol": "使", "zombie": "屍", "laojiang": "屍", "pocong": "屍",
	"zhiren": "紙紮", "xiaozhi": "紙紮", "niutou": "官", "mamian": "官", "baiwu": "官", "heiwu": "官", "huang": "官", "mengpo": "官", "pontianak": "厲", "penanggal": "厲"}

static var _ct = null
static func L(yue: String, zhs: String) -> String: return str(DB.N(load("res://game/zone/zone_data.gd").L(yue, zhs)))

static func _counter() -> Dictionary:
	if _ct == null:
		_ct = {}
		var p = "res://data/nat/counter.json"
		if FileAccess.file_exists(p):
			var x = JSON.parse_string(FileAccess.get_file_as_string(p))
			if x is Dictionary: _ct = x
	return _ct
static func sys_of(k: String) -> String:
	var c = _counter()
	for sec in ["enemy", "ghost"]:
		var e = c.get(sec, {}).get(k)
		if e is Dictionary and str(e.get("sys", "")) != "": return str(e.sys)
	var e2 = AB.data().get("ENEMY", {}).get(k)
	if e2 is Dictionary and str(e2.get("sys", "")) != "": return str(e2.sys)
	return SYS_FB.get(k, "")

# ---------------- 計算（測試亦用） ----------------
static func ghost(id):
	if id == null or not J.t(id): return null
	for g in J.iter(J.G.S.get("ghosts", [])): if g is Dictionary and J.str(g.id) == J.str(id): return g
	return null
static func _uniq(a: Array) -> Array:
	var o = []
	for t in a:
		var c = AI.canon(t)
		if not c in o: o.append(c)
	return o
static func tags(k: String) -> Array: return _uniq(AB.tags_of(k))
static func counters(m) -> Array:
	var o = _uniq(AB.counters_of(AI.canon(m)))
	if o.is_empty(): o = _uniq(AB.counters_of(m))
	return o
static func adv_tag(g) -> String:   # 軍師提供嘅全隊型標籤（取第一個）
	if g == null: return ""
	for t in tags(J.str(g.k)): if t in AI.TEAM_TAGS: return t
	return ""
static func enemy_mechs(ks: Array) -> Array:
	var o = []
	for k in ks:
		for m in AB.mechs_of(str(k)):
			var c = AI.canon(m)
			if not c in o: o.append(c)
	return o
# 一隊（名鬼 dict 陣列＋軍師）對一組機制：{m: [應對嘅名鬼名(標籤)...]}
static func cover(team: Array, adv, ms: Array) -> Dictionary:
	var o = {}
	for m in ms:
		var cs = counters(m); var who = []
		for g in team:
			for t in tags(J.str(g.k)):
				if t in cs: who.append({"g": g, "t": t}); break
		var at = adv_tag(adv)
		if at != "" and at in cs: who.append({"g": adv, "t": at, "adv": true})
		o[m] = who
	return o
static func team_now() -> Array:
	var o = []
	for id in J.iter(J.G.S.get("team", [])):
		var g = ghost(id)
		if g != null: o.append(g)
	return o
static func gpow(g) -> float: return J.num(J.mc(J.G.get("GP"), "pow", [g])) if J.G.get("GP") != null else J.num(g.get("lv", 1))
# 推薦：已擁有、未出陣、唔係軍師；揀覆蓋最多「未應對」機制，再按鬼力；最多 n 個
static func recommend(ms: Array, n := 2) -> Array:
	var team = team_now(); var adv = ghost(J.G.S.get("adviser"))
	var cv = cover(team, adv, ms)
	var miss = []
	for m in ms: if (cv[m] as Array).is_empty(): miss.append(m)
	if miss.is_empty(): return []
	var ids = {}
	for g in team: ids[J.str(g.id)] = true
	if adv != null: ids[J.str(adv.id)] = true
	var cand = []
	for g in J.iter(J.G.S.get("ghosts", [])):
		if not (g is Dictionary) or ids.has(J.str(g.id)) or J.str(g.k) == "afu": continue
		var hit = []
		var ts = tags(J.str(g.k))
		for m in miss:
			for t in counters(m):
				if t in ts: hit.append([m, t]); break
		if hit.is_empty(): continue
		var busy = BK.job(g) in ["post", "away", "cap_def", "cap_sweep"]
		cand.append({"g": g, "hit": hit, "pow": gpow(g), "busy": busy})
	cand.sort_custom(func(a, b):
		if a.hit.size() != b.hit.size(): return a.hit.size() > b.hit.size()
		if a.busy != b.busy: return not a.busy
		return a.pow > b.pow)
	return cand.slice(0, n)
# 換上：有空格先填；否則換走「應對最少、鬼力最低」嗰隻（唔換阿福）。回換咗邊格（-1＝換唔到）
static func swap_in(id, ms: Array) -> int:
	var S = J.G.S
	if not (S.get("team") is Array): return -1
	var team: Array = S.team
	var slot = -1
	for i in team.size(): if not J.t(team[i]): slot = i; break
	if slot < 0:
		var best = 1e9
		for i in team.size():
			var g = ghost(team[i])
			if g == null or J.str(g.k) == "afu": continue
			var n = 0
			var ts = tags(J.str(g.k))
			for m in ms:
				for t in counters(m): if t in ts: n += 1; break
			var sc = n * 1e6 + gpow(g)
			if sc < best: best = sc; slot = i
	if slot < 0: return -1
	if J.str(S.get("adviser")) == J.str(id): S["adviser"] = null
	team[slot] = id
	BK.after_team(id)
	var sv = J.G.get("save")
	if sv != null: J.cl(sv, null, [])
	return slot
static func set_adviser(id) -> void:
	var S = J.G.S
	if id != null and S.get("team") is Array and (S.team as Array).has(id): return   # 出陣中嘅唔做軍師
	S["adviser"] = id
	var sv = J.G.get("save")
	if sv != null: J.cl(sv, null, [])

# ---------------- 畫面 ----------------
static func _pal(dark: bool) -> Dictionary:
	if dark: return {"tx": Color("#f0e0d0"), "dim": Color("#c8b8a0"), "ok": Color("#a8f0a0"), "bad": Color("#ff8a7a"), "hd": Color("#ffd27a"), "box": Color(1, 1, 1, 0.06), "bd": Color(1, 1, 1, 0.16), "lit": Color("#ffd27a")}
	return {"tx": UIKit.INKTXT, "dim": UIKit.INKDIM, "ok": Color("#2e6d5a"), "bad": Color("#c2362b"), "hd": Color("#7a1a10"), "box": Color(0, 0, 0, 0.05), "bd": Color(0.4, 0.3, 0.2, 0.3), "lit": Color("#c8822a")}

static func add_to(vb: Container, enemy_keys: Array, opt := {}) -> VBoxContainer:
	for c in vb.get_children(): if c.name == "AbCard": vb.remove_child(c); c.queue_free()   # 舊卡等緊 free：讓個名
	var box = VBoxContainer.new(); box.name = "AbCard"
	box.add_theme_constant_override("separation", 6)
	box.set_meta("ks", enemy_keys.duplicate()); box.set_meta("opt", opt)
	vb.add_child(box)
	render(box)
	return box

static func _lab(t: String, px: int, col: Color, wrap := true) -> Label:
	var l = UIKit.label(t, px, col, "sans", 900)
	if wrap: l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART; l.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	l.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return l
static func _pill(t: String, bg: Color, px := 16) -> PanelContainer:
	var p = PanelContainer.new()
	p.add_theme_stylebox_override("panel", UIKit.sb(bg, 6, bg.darkened(0.45), 2, Vector4(8, 2, 8, 2)))
	var l = UIKit.label(t, px, Color("#fff6e8"), "sans", 900); l.mouse_filter = Control.MOUSE_FILTER_IGNORE
	p.add_child(l); p.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return p
static func _small_btn(t: String, dark: bool) -> Button:
	var b = Button.new(); b.text = t; b.focus_mode = Control.FOCUS_NONE
	b.add_theme_font_override("font", UIKit.font("sans", 900)); b.add_theme_font_size_override("font_size", 16)
	var s = UIKit.sb(Color("#8a2a18"), 8, Color("#f0b070"), 2, Vector4(10, 4, 10, 4))
	for k in ["normal", "hover", "pressed", "disabled"]: b.add_theme_stylebox_override(k, s)
	b.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
	for k in ["font_color", "font_hover_color", "font_pressed_color"]: b.add_theme_color_override(k, Color("#fff0dc"))
	b.custom_minimum_size = Vector2(76, 40)
	return b
static func _changed(box: VBoxContainer) -> void:
	var opt: Dictionary = box.get_meta("opt", {})
	var cb = opt.get("on_change")
	if cb is Callable and cb.is_valid(): cb.call()
	elif is_instance_valid(box): render(box)

static func render(box: VBoxContainer) -> void:
	for c in box.get_children(): box.remove_child(c); c.queue_free()
	var ks: Array = box.get_meta("ks", [])
	var opt: Dictionary = box.get_meta("opt", {})
	var dark = J.t(opt.get("dark", false))
	var P = _pal(dark)
	var cmp = J.t(box.get_meta("compact", false))   # 放唔落畫面時：細啲、少啲
	# ---- 第 1 行：偵察：系 ×數、怕乜 ----
	var hf = HFlowContainer.new(); hf.add_theme_constant_override("h_separation", 6); hf.add_theme_constant_override("v_separation", 4); box.add_child(hf)
	hf.add_child(_lab(L("偵察", "偵察"), 18, P.hd, false))
	var cnt = {}; var order = []
	for k in ks:
		var s = sys_of(str(k))
		if s == "": s = "?"
		if not cnt.has(s): cnt[s] = 0; order.append(s)
		cnt[s] += 1
	for s in order:
		hf.add_child(_pill("%s ×%d" % [str(DB.L(s)) if s != "?" else L("未知", "未知"), cnt[s]], Color(SYS.get(s, "#6a6060"))))
	var R = J.G.get("Rework"); var fw = {}
	if R != null:
		for k in ks:
			var f = J.mc(R, "fearOf", [str(k)])
			if f is Dictionary: for w in J.iter(f.get("w", [])): fw[w] = int(fw.get(w, 0)) + 1
	if not fw.is_empty():
		var ws = fw.keys(); ws.sort_custom(func(a, b): return fw[a] > fw[b])
		var wn = []
		for w in ws.slice(0, 3): wn.append(str(J.mc(R, "word", [w])))
		box.add_child(_lab(L("佢哋怕：%s", "它們怕：%s") % "、".join(wn), 16, P.tx))
	# ---- 機制大圖示 ----
	var ms = enemy_mechs(ks)
	var team = team_now(); var adv = ghost(J.G.S.get("adviser"))
	var cv = cover(team, adv, ms)
	if J.t(box.get_meta("pick_adv", false)):   # 揀緊軍師：只顯示隊伍＋清單（唔好令張卡太長）
		var need0 = {}
		for m in ms:
			for t in counters(m): need0[t] = true
		var tr0 = HBoxContainer.new(); tr0.add_theme_constant_override("separation", 6); box.add_child(tr0)
		for g in team: tr0.add_child(_member(g, need0, P, false, box, cmp))
		tr0.add_child(_member(adv, need0, P, true, box, cmp))
		_adv_picker(box, P, dark)
		if box.get_meta("opt", {}).get("host") != null: (func(): _fit(box)).call_deferred()
		return
	if ms.is_empty():
		box.add_child(_lab(L("敵人冇特別本事：正常打就得", "敵人沒有特別本事：正常打就行"), 16, P.dim))
	else:
		var mf = HFlowContainer.new(); mf.add_theme_constant_override("h_separation", 8); mf.add_theme_constant_override("v_separation", 6); box.add_child(mf)
		var open_m = str(box.get_meta("open_m", ""))
		for m in ms:
			var okm = not (cv[m] as Array).is_empty()
			var cell = VBoxContainer.new(); cell.add_theme_constant_override("separation", 0); cell.custom_minimum_size = Vector2(70, 0)
			var ic = AI.Icon.new(m, 44.0 if cmp else 54.0)
			ic.ring = P.ok if okm else P.bad
			ic.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
			cell.add_child(ic)
			var nl = _lab(AI.name_of(m), 15, P.tx, false); nl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; cell.add_child(nl)
			cell.mouse_filter = Control.MOUSE_FILTER_STOP
			var mm = m
			cell.gui_input.connect(func(ev):
				if (ev is InputEventMouseButton and ev.pressed and ev.button_index == MOUSE_BUTTON_LEFT) or (ev is InputEventScreenTouch and ev.pressed):
					box.set_meta("open_m", "" if str(box.get_meta("open_m", "")) == mm else mm); render(box))
			mf.add_child(cell)
		if open_m != "" and open_m in ms:
			var d = AI.info(open_m).get("d", ["", ""])
			box.add_child(_lab("%s：%s" % [AI.name_of(open_m), L(d[0], d[1])], 15, P.dim))
		elif not cmp:
			box.add_child(_lab(L("（撳圖示睇說明）", "（點圖示看說明）"), 14, P.dim))
	# ---- 我方：3 隻＋軍師 ----
	var need = {}
	for m in ms:
		for t in counters(m): need[t] = true
	var tr = HBoxContainer.new(); tr.add_theme_constant_override("separation", 6); box.add_child(tr)
	for g in team: tr.add_child(_member(g, need, P, false, box, cmp))
	tr.add_child(_member(adv, need, P, true, box, cmp))
	# ---- ✔／✘ ----
	var nok = 0
	for m in ms:
		var who: Array = cv[m]
		if who.size():
			nok += 1
			var nm = []
			for w in who: nm.append("%s（%s%s）" % [str(DB.L(J.str(w.g.name))), AI.name_of(w.t), L("・軍師", "・軍師") if J.t(w.get("adv")) else ""])
			box.add_child(_lab("✔ %s：%s" % [AI.name_of(m), "、".join(nm)], 16, P.ok))
		else:
			var ws2 = AI.info(m).get("w", ["", ""])
			var cn = []
			for t in counters(m): cn.append("「%s」" % AI.name_of(t))
			box.add_child(_lab("✘ %s：%s%s → %s" % [AI.name_of(m), L("冇", "缺"), "／".join(cn), L(ws2[0], ws2[1])], 16, P.bad))
	if ms.size():
		var dots = ""
		for i in ms.size(): dots += "●" if i < nok else "○"
		box.add_child(_lab(L("應對度 %s（%d/%d）", "應對度 %s（%d/%d）") % [dots, nok, ms.size()], 16, P.ok if nok == ms.size() else P.tx))
	# ---- 推薦＋換上 ----
	var rc = recommend(ms, 1 if cmp else 2)
	if rc.size():
		box.add_child(_lab(L("推薦：", "推薦："), 16, P.hd, false))
		for r in rc:
			var hb = HBoxContainer.new(); hb.add_theme_constant_override("separation", 8); box.add_child(hb)
			var pr = UIKit.portrait(J.str(r.g.k), 40); pr.mouse_filter = Control.MOUSE_FILTER_IGNORE; hb.add_child(pr)
			var hs = []
			for h in r.hit: hs.append("%s→%s" % [AI.name_of(h[1]), AI.name_of(h[0])])
			var t = "%s（%s）" % [str(DB.L(J.str(r.g.name))), "、".join(hs)]
			if r.busy: t += L("　%s，換上會調返嚟", "　%s，換上會調回來") % BK.job_label(r.g)
			var l = _lab(t, 15, P.tx); l.size_flags_vertical = Control.SIZE_SHRINK_CENTER; hb.add_child(l)
			var b = _small_btn(L("換上", "換上"), dark); b.size_flags_vertical = Control.SIZE_SHRINK_CENTER
			var gid = r.g.id
			b.pressed.connect(func():
				var sl = swap_in(gid, ms)
				if sl >= 0: Snd.play("click"); _changed(box))
			hb.add_child(b)
	if box.get_meta("opt", {}).get("host") != null: (func(): _fit(box)).call_deferred()
	if ms.size() and nok < ms.size() and not cmp:
		box.add_child(_lab(L("冇應對都打得贏，只係辛苦啲、慢啲", "沒有應對也打得贏，只是辛苦點、慢一點"), 14, P.dim))

# 浮動卡（野外出擊卡）：放唔落就向上移；再唔夠就轉精簡版（唔准出界、唔准遮底部導航）
const NAV_H := 74.0
static func _fit(box: VBoxContainer, again := 3) -> void:
	if not is_instance_valid(box) or not box.is_inside_tree():
		if again > 0 and is_instance_valid(box): (func(): _fit(box, again - 1)).call_deferred()
		return
	if again > 0: box.get_tree().process_frame.connect(func(): _fit(box, again - 1), CONNECT_ONE_SHOT)   # HFlow 要排完先知真高度
	var host = (box.get_meta("opt", {}) as Dictionary).get("host")
	if not (host is Control) or not is_instance_valid(host): return
	if not host.has_meta("top0"): host.set_meta("top0", host.offset_top)
	var vh = host.get_viewport_rect().size.y
	var h = host.get_combined_minimum_size().y
	var top0 = float(host.get_meta("top0"))
	var par = host.get_parent()
	var py = (par as Control).get_global_rect().position.y if par is Control else 0.0
	var room = vh - NAV_H - 8.0 - py
	var nt = clampf(room - h, 8.0, top0)
	host.offset_top = nt; host.offset_bottom = nt + h   # 兩邊一齊設：成張卡向上移（唔係拉長）
	if h > room and not J.t(box.get_meta("compact", false)):
		box.set_meta("compact", true); render(box)
static func _member(g, need: Dictionary, P: Dictionary, adv: bool, box: VBoxContainer, cmp := false) -> Control:
	var p = PanelContainer.new(); p.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var ts = tags(J.str(g.k)) if g != null else []
	var lit = false
	for t in ts: if need.has(t) and (not adv or t == adv_tag(g)): lit = true
	p.add_theme_stylebox_override("panel", UIKit.sb(P.box, 6, P.lit if lit else P.bd, 3 if lit else 1, Vector4(3, 4, 3, 4)))
	var vb = VBoxContainer.new(); vb.add_theme_constant_override("separation", 1); vb.alignment = BoxContainer.ALIGNMENT_CENTER; vb.mouse_filter = Control.MOUSE_FILTER_IGNORE; p.add_child(vb)
	if adv:
		var hl = _lab(L("軍師", "軍師"), 14, P.hd, false); hl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; vb.add_child(hl)
	if g != null:
		var pr = UIKit.portrait(J.str(g.k), (34 if adv else 38) if cmp else (44 if adv else 48)); pr.size_flags_horizontal = Control.SIZE_SHRINK_CENTER; pr.mouse_filter = Control.MOUSE_FILTER_IGNORE; vb.add_child(pr)
	var nm = str(DB.L(J.str(g.name))) if g != null else L("＋揀軍師", "＋選軍師")
	var nl = _lab(nm, 15, P.tx, false); nl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; nl.clip_text = true; nl.custom_minimum_size = Vector2(0, 20); vb.add_child(nl)
	if g != null:
		var th = HBoxContainer.new(); th.alignment = BoxContainer.ALIGNMENT_CENTER; th.add_theme_constant_override("separation", 2); th.mouse_filter = Control.MOUSE_FILTER_IGNORE; vb.add_child(th)
		var show = ts if not adv else ([adv_tag(g)] if adv_tag(g) != "" else [])
		for t in show.slice(0, 3):
			var ic = AI.Icon.new(t, 26.0, not need.has(t)); ic.mouse_filter = Control.MOUSE_FILTER_IGNORE; th.add_child(ic)
		if show.is_empty(): var nl2 = _lab(L("（冇標籤）", "（無標籤）"), 13, P.dim, false); th.add_child(nl2)
	if adv:
		var sub = _lab(L("撳換", "點擊換"), 13, P.dim, false); sub.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; vb.add_child(sub)
		p.mouse_filter = Control.MOUSE_FILTER_STOP
		p.gui_input.connect(func(ev):
			if (ev is InputEventMouseButton and ev.pressed and ev.button_index == MOUSE_BUTTON_LEFT) or (ev is InputEventScreenTouch and ev.pressed):
				Snd.play("click"); box.set_meta("pick_adv", not J.t(box.get_meta("pick_adv", false))); render(box))
	else: p.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return p

static func _adv_picker(box: VBoxContainer, P: Dictionary, dark: bool) -> void:
	var S = J.G.S
	var pnl = PanelContainer.new()
	pnl.add_theme_stylebox_override("panel", UIKit.sb(P.box, 6, P.lit, 2, Vector4(6, 6, 6, 6)))
	var vb = VBoxContainer.new(); vb.add_theme_constant_override("separation", 4); pnl.add_child(vb)
	vb.add_child(_lab(L("揀軍師（唔上場，全隊攻擊加成睇「智」；仲會帶一個全隊標籤）", "選軍師（不上場，全隊攻擊加成看「智」；還會帶一個全隊標籤）"), 15, P.tx))
	var fl = HFlowContainer.new(); fl.add_theme_constant_override("h_separation", 6); fl.add_theme_constant_override("v_separation", 6); vb.add_child(fl)
	var list = []
	for g in J.iter(S.get("ghosts", [])):
		if g is Dictionary and not J.iter(S.get("team", [])).has(g.id): list.append(g)
	list.sort_custom(func(a, b):
		var aa = 1 if adv_tag(a) != "" else 0; var bb = 1 if adv_tag(b) != "" else 0
		if aa != bb: return aa > bb
		return J.num(J.mc(J.G.get("F"), "stat", [a, 1])) > J.num(J.mc(J.G.get("F"), "stat", [b, 1])) if J.G.get("F") != null else false)
	var mk = func(g):
		var c = PanelContainer.new(); c.custom_minimum_size = Vector2(84, 0)
		var cur = g != null and J.str(S.get("adviser")) == J.str(g.id)
		c.add_theme_stylebox_override("panel", UIKit.sb(Color(0.95, 0.85, 0.5, 0.3) if cur else P.box, 6, P.lit if cur else P.bd, 2 if cur else 1, Vector4(3, 3, 3, 3)))
		var v = VBoxContainer.new(); v.add_theme_constant_override("separation", 0); v.mouse_filter = Control.MOUSE_FILTER_IGNORE; c.add_child(v)
		if g != null:
			var pr = UIKit.portrait(J.str(g.k), 40); pr.size_flags_horizontal = Control.SIZE_SHRINK_CENTER; pr.mouse_filter = Control.MOUSE_FILTER_IGNORE; v.add_child(pr)
		var nl = _lab(str(DB.L(J.str(g.name))) if g != null else L("唔要軍師", "不要軍師"), 14, P.tx, false); nl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; nl.clip_text = true; v.add_child(nl)
		if g != null:
			var zi = int(J.num(J.mc(J.G.get("F"), "stat", [g, 1]))) if J.G.get("F") != null else 0
			var at = adv_tag(g)
			var sl = _lab(L("智 %d", "智 %d") % zi + ("・" + AI.name_of(at) if at != "" else ""), 13, P.dim, false); sl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; v.add_child(sl)
		c.mouse_filter = Control.MOUSE_FILTER_STOP
		var gid = g.id if g != null else null
		c.gui_input.connect(func(ev):
			if (ev is InputEventMouseButton and ev.pressed and ev.button_index == MOUSE_BUTTON_LEFT) or (ev is InputEventScreenTouch and ev.pressed):
				Snd.play("click"); set_adviser(gid); box.set_meta("pick_adv", false); _changed(box))
		return c
	if S.get("adviser") != null: fl.add_child(mk.call(null))
	for g in list: fl.add_child(mk.call(g))
	if list.is_empty(): vb.add_child(_lab(L("冇閒住嘅名鬼", "沒有空閒的名鬼"), 14, P.dim))
	box.add_child(pnl)

# rts._card_body 用：由出擊 pend 搵敵人 key（主線關卡 tg.en、野外王 stage.en；其他＝未知）
static func keys_for(pend: Dictionary) -> Array:
	var tg = pend.get("tg")
	if tg is Dictionary and tg.get("en") is Array: return tg.en
	if str(pend.get("kind")) == "boss":
		var ZD = load("res://game/zone/zone_data.gd")
		var bid = str((pend.get("opt", {}) as Dictionary).get("bid", ""))
		for z in ZD.of_type("wild"):
			for b in ZD.bosses(str(z.id)):
				if str(b.get("id")) == bid and b.get("stage") is Dictionary and b.stage.get("en") is Array: return b.stage.en
	return []
