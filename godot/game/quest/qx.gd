# 任務系統（原生）：日常任務、支線任務、任務面板（主線／支線／日常）
# 存檔放喺 JS 嗰份 S：S.dq（日常）、S.sq（支線）、S.cnt.*（計數）。同網頁版存檔互通（網頁版唔識就唔理）。
# 計量 metric()：由 S 讀數字；日常／支線步驟 = 而家數字 − 開始時嘅數字。
extends Node

var D: Dictionary = {}
var btn: Control
var dot: Control
var _t := 0.0
var _hr_said := false

func _ready() -> void:
	var f = FileAccess.open("res://data/quests.json", FileAccess.READ)
	if f: D = JSON.parse_string(f.get_as_text())
	set_process(true)

const SPK := {"龐總": "npc_kpiboss", "冼小姐": "npc_hr", "Bryan": "npc_rival", "窮鬼": "n30_qionggui", "討債鬼": "n30_taozhai", "孤寒鬼": "n30_guhangui", "推磨鬼": "pg_tuimo", "賭鬼": "n30_dugui", "Pelesit": "n30_pelesit", "Polong": "n30_polong", "Hantu Raya": "n30_hanturaya", "Jenglot": "n30_jenglot", "老殭": "laojiang", "無頭鬼": "n30_wutou", "被賣鬼": "pg_songding", "白骨精": "n30_baigujing", "山魈": "n30_shanxiao", "Mae Nak": "n30_maenak", "前女友鬼": "pg_ex", "Churel": "n30_churel", "Tikbalang": "n30_tikbalang", "Pontianak": "pontianak", "自拍跌死鬼": "n30_zipai", "二房東": "pg_landlady", "中暑鬼": "n30_zhongshu", "車禍鬼": "n30_chehuo", "打機猝死鬼": "n30_daji", "唐傘妖": "n30_kasaobake", "聻": "pg_ji", "無臉鬼": "n30_nopperabo", "般若": "n30_hannya", "轆轤首": "n30_rokurokubi", "Pocong": "pocong"}
var _spk_done := false
func _spk() -> void:
	if _spk_done or DB.D.is_empty(): return
	_spk_done = true
	var m = DB.D.get("SPEAKER_ART", {})
	for k in SPK: if not m.has(k) and Art.char_h(SPK[k]) > 0: m[k] = SPK[k]

func _pgchat() -> void:
	# 5 隻 pg 鬼嘅碎碎念：網頁版 CHAT_DATA.named 冇，由 core.json 補入（[粵, 中]）
	if DB.D.is_empty(): return
	var CD = J.G.get("CHAT_DATA")   # 匯入存檔會重開 JS，所以每次檢查
	if CD is Dictionary and CD.get("named") is Dictionary and not CD.named.has("pg_tuimo"):
		var CH: Dictionary = DB.D.get("CHATTER", {}); var LZ: Dictionary = DB.D.get("LANG_ZH", {})
		for k in CH:
			if not str(k).begins_with("pg_"): continue
			if CD.named.has(k): continue
			var arr := []
			for l in CH[k]: arr.append([l, LZ.get(l, l)])
			CD.named[k] = arr

# ---------------- 劇情節點（主線補劇情）：on = patrol_begin:<區> / village ----------------
func event(ev: String) -> void:
	var s = S(); if s == null: return
	var st = sq()
	for b in D.get("beats", []):
		var key = "beat_" + b.id
		if st.has(key) or b.on != ev or not _cond(b.get("when")): continue
		if b.get("unless") != null and _cond(b.unless): continue
		st[key] = {"done": true, "beat": true}
		_story(b.story)
		J.cl(J.G.get("save"), null, [])
		return   # 一次一場

func S():
	var s = J.G.get("S")
	return s if s is Dictionary else null

func T(a: Array) -> String:
	return a[0] if DB.lang == "yue" else a[1]

# ---------------- 計量 ----------------
func cnt(k: String) -> float:
	var s = S(); if s == null: return 0.0
	if not s.has("cnt"): s.cnt = {}
	return J.num(s.cnt.get(k, 0.0))

static func bump(k: String, n := 1.0) -> void:
	var s = J.G.get("S")
	if not (s is Dictionary): return
	if not s.has("cnt") or not (s.cnt is Dictionary): s.cnt = {}
	s.cnt[k] = J.num(s.cnt.get(k, 0.0)) + n

func metric(m: String) -> float:
	var s = S(); if s == null: return 0.0
	var p = m.split(":")
	var k = p[0]
	if k.begins_with("cnt."): return cnt(k.substr(4))
	if k.begins_with("pt."):
		var pt = s.get("pt", {})
		return J.num(pt.get(k.substr(3), 0.0)) if pt is Dictionary else 0.0
	match k:
		"sumlv":
			var t = 0.0
			for g in s.ghosts: if g.k != "afu": t += J.num(g.lv)
			return t
		"lv": return J.num(s.lv)
		"kill": return cnt("k_" + p[1])
		"stage": return 1.0 if J.t(s.cleared.get(p[1])) else 0.0
		"seen": return 1.0 if J.t(s.seen.get(p[1])) else 0.0
		"has":
			for g in s.ghosts: if g.k == p[1]: return 1.0
			return 0.0
		"lm", "kings", "ca", "pg", "sg", "sta":
			var r = _reg(int(p[1]))
			if r.is_empty(): return 0.0
			var key = {"lm": "lm", "kings": "kings", "ca": "ca", "pg": "pg", "sg": "sg", "sta": "sta"}[k]
			var d = r.get(key, {})
			if p.size() > 2: return 1.0 if d is Dictionary and J.t(d.get(p[2])) else 0.0
			return float(d.size()) if d is Dictionary else 0.0
		"res": return J.num(s.res.get(p[1], 0.0))
		"side":
			var e = sq().get(p[1])
			return 1.0 if e is Dictionary and J.t(e.get("done")) else 0.0
	return 0.0

func _reg(ci: int) -> Dictionary:
	var s = S(); var pt = s.get("pt", {})
	if not (pt is Dictionary): return {}
	var reg = pt.get("reg", {})
	if not (reg is Dictionary): return {}
	var r = reg.get(str(ci), {})
	return r if r is Dictionary else {}

# ---------------- 日常 ----------------
func _today() -> String:
	var d = Time.get_datetime_dict_from_system()   # 玩家本地時間
	return "%04d-%02d-%02d" % [d.year, d.month, d.day]

func dq() -> Dictionary:
	var s = S()
	if not s.has("dq") or not (s.dq is Dictionary): s.dq = {"day": "", "list": [], "streak": 0.0, "bonus": false, "last_full": ""}
	var q: Dictionary = s.dq
	if q.day != _today(): _roll(q)
	return q

func _roll(q: Dictionary) -> void:
	# 斷咗一日全勤就由頭計
	var yday = _day_offset(-1)
	if q.get("last_full", "") != yday and q.get("last_full", "") != _today(): q.streak = 0.0
	q.day = _today(); q.bonus = false
	var pool: Array = D.get("daily", [])
	var vil = pool.filter(func(x): return x.cat == "village")
	var pat = pool.filter(func(x): return x.cat == "patrol")
	var lv = J.num(S().lv)
	if lv < 3: pat = []   # 未開巡陰
	var pick = []
	var rng = RandomNumberGenerator.new(); rng.seed = hash(q.day + str(J.num(S().get("uid", 0))))
	var take = func(arr: Array, n: int) -> void:
		var a = arr.duplicate()
		for i in n:
			if a.is_empty(): return
			var j = rng.randi() % a.size(); pick.append(a[j]); a.remove_at(j)
	take.call(vil, 1 if pat.size() else 2)
	take.call(pat, 2 if pat.size() else 0)
	var rest = pool.filter(func(x): return not pick.has(x) and (x.cat == "village" or pat.size()))
	take.call(rest, 1)
	q.list = []
	for x in pick: q.list.append({"id": x.id, "base": metric(x.m), "got": false})
	_hr_said = false

func _day_offset(n: int) -> String:
	var u = Time.get_unix_time_from_system() + n * 86400 + Time.get_time_zone_from_system().bias * 60
	var d = Time.get_datetime_dict_from_unix_time(int(u))
	return "%04d-%02d-%02d" % [d.year, d.month, d.day]

func ddef(id: String) -> Dictionary:
	for x in D.get("daily", []): if x.id == id: return x
	return {}

func dprog(e: Dictionary) -> Array:
	var x = ddef(e.id)
	if x.is_empty(): return [0, 1]
	return [mini(int(metric(x.m) - J.num(e.base)), int(x.n)), int(x.n)]

func daily_ready() -> int:
	var n = 0
	for e in dq().list:
		var p = dprog(e)
		if not e.got and p[0] >= p[1]: n += 1
	var q = dq()
	if not q.bonus and q.list.size() and q.list.all(func(e): return e.got): n += 1
	return n

func claim_daily(e: Dictionary) -> void:
	var p = dprog(e)
	if e.got or p[0] < p[1]: return
	e.got = true
	var x = ddef(e.id)
	var txt = J.str(J.cl(J.G.get("give"), null, [x.r]))
	Snd.play("coin"); G.toast.emit("日常完成：%s\n[b]%s[/b]" % [T(x.text), txt])
	var q = dq()
	if q.list.all(func(z): return z.got) and not q.bonus:
		q.bonus = true; q.last_full = _today(); q.streak = J.num(q.get("streak", 0)) + 1
		var b = D.daily_bonus
		var t2 = J.str(J.cl(J.G.get("give"), null, [b.r]))
		var extra = ""
		if int(q.streak) % 7 == 0: extra = "　連續 7 日全勤：" + J.str(J.cl(J.G.get("give"), null, [b.week.r]))
		G.banner.emit("全勤！")
		G.toast.emit("今日全勤獎：[b]%s[/b]%s" % [t2, extra])
	J.cl(J.G.get("save"), null, [])

# ---------------- 支線 ----------------
func sq() -> Dictionary:
	var s = S()
	if not s.has("sq") or not (s.sq is Dictionary): s.sq = {}
	return s.sq

func sdef(id: String) -> Dictionary:
	for x in D.get("side", []): if x.id == id: return x
	return {}

func _cond(c) -> bool:
	if c == null: return true
	if c is Array:
		for m in c: if not _cond(m): return false
		return true
	var parts = String(c).split(">=")
	if parts.size() == 2: return metric(parts[0].strip_edges()) >= float(parts[1])
	return metric(String(c)) >= 1.0

func side_tick() -> void:
	var st = sq(); var busy = J.t(J.mc(J.G.get("Story"), "busy", []))
	for x in D.get("side", []):
		var e = st.get(x.id)
		if e == null:
			if _cond(x.get("when")):
				st[x.id] = {"step": 0.0, "base": _step_base(x, 0), "done": false, "new": true, "told": false}
			continue
		if e.done: continue
		if not e.get("told", true):
			if busy: continue
			e.told = true
			if x.get("start") != null:
				var sc = x.start.duplicate(); sc.title = "支線・" + T(x.title); _story(sc); busy = true
			else: G.toast.emit("新支線：[b]%s[/b]" % T(x.title))
			continue
		var i = int(e.step); var steps: Array = x.steps
		if i >= steps.size(): continue
		var s = steps[i]
		if s.get("pay") != null: continue   # 要玩家撳「交俾佢」
		if _step_prog(x, e)[0] >= _step_prog(x, e)[1] and not busy:
			_advance(x, e)
			busy = true

func _step_base(x: Dictionary, i: int) -> float:
	var steps: Array = x.steps
	if i >= steps.size(): return 0.0
	var s = steps[i]
	if s.get("m") == null or s.get("abs", false): return 0.0
	return metric(s.m)

func _step_prog(x: Dictionary, e: Dictionary) -> Array:
	var s = x.steps[int(e.step)]
	if s.get("m") == null: return [1, 1]
	var v = metric(s.m) if s.get("abs", false) else metric(s.m) - J.num(e.base)
	return [mini(int(v), int(s.get("n", 1))), int(s.get("n", 1))]

func _advance(x: Dictionary, e: Dictionary) -> void:
	var s = x.steps[int(e.step)]
	if s.get("after") != null: _story(s.after)
	e.step = J.num(e.step) + 1
	if int(e.step) >= x.steps.size():
		e.done = true
		if x.get("end") != null: _story(x.end)
		var txt = J.str(J.cl(J.G.get("give"), null, [x.r])) if x.get("r") != null else ""
		Snd.play("coin"); G.toast.emit("支線完成：[b]%s[/b]\n%s" % [T(x.title), txt])
		if x.get("join") != null: J.cl(J.G.get("joinGhost"), null, [x.join])
	else:
		e.base = _step_base(x, int(e.step))
		var ns = x.steps[int(e.step)]
		if ns.get("before") != null: _story(ns.before)
	J.cl(J.G.get("save"), null, [])

func pay_step(x: Dictionary, e: Dictionary) -> void:
	var s = x.steps[int(e.step)]
	var c: Dictionary = s.pay
	var res = S().res
	for k in c: if J.num(res.get(k, 0)) < J.num(c[k]): G.toast.emit("唔夠：%s" % k); return
	for k in c: res[k] = J.num(res[k]) - J.num(c[k])
	_advance(x, e)

# 劇情：{"style":"talk","bg":"village","lines":[[講者,[粵,中]],…]}
func _story(sc: Dictionary) -> void:
	var lines = []; var zh = {}
	for l in sc.lines:
		var txt = l[1]
		if txt is Array: zh[txt[0]] = txt[1]; txt = txt[0]
		lines.append([l[0], txt])
	if zh.size():
		J.mc(J.G.get("LANG"), "add", [zh])
		if not DB.D.has("LANG_ZH"): DB.D.LANG_ZH = {}
		DB.D.LANG_ZH.merge(zh, true)
	var o = sc.duplicate(); o.lines = lines
	J.mc(J.G.get("Story"), "queue", [o])

# ---------------- 每 0.5 秒 ----------------
func _process(dt: float) -> void:
	_t += dt
	if _t < 0.5: return
	_t = 0
	var s = S()
	if s == null or not s.has("ghosts"): return
	var main = get_tree().root.get_node_or_null("Main")
	if main == null or main.get("loading") != null: return
	if btn == null or not is_instance_valid(btn): _mk_btn(main)
	# 劇情播緊時，提示改喺頂部出，唔好遮住對白
	var tq = main.get("toasts")
	if tq:
		var top = main.story != null and main.story.get("cur") != null
		tq.offset_bottom = -86 - (main.size.y * 0.62 if top else 0.0)
	_spk(); _pgchat()
	dq(); side_tick()
	if btn.visible and not J.t(J.mc(J.G.get("Story"), "busy", [])) and not main.sheet.visible: event("village")
	var n = daily_ready()
	for k in sq():
		var e = sq()[k]; var x = sdef(k)
		if not x.is_empty() and not e.done and (e.get("new", false) or (int(e.step) < x.steps.size() and x.steps[int(e.step)].get("pay") != null)): n += 1
	var P = J.G.get("Patrol"); var N = J.gp(P, "_nat") if P != null else null
	if N != null:
		for gl in D.get("goals", []):
			if not sq().has("goal_" + gl.id) and J.t(J.cl(N.regionOpen, null, [float(gl.ci)])) and metric(gl.m) >= float(gl.n): n += 1
	dot.visible = n > 0
	btn.visible = main.get("title_ov") == null and get_tree().root.get_node_or_null("Main/PtRun") == null

# ---------------- 任務掣＋面板 ----------------
func _mk_btn(main: Node) -> void:
	btn = Button.new(); btn.text = "任務"
	btn.add_theme_font_override("font", UIKit.font("serif", 900)); btn.add_theme_font_size_override("font_size", 14)
	var sb = UIKit.sb(Color("#2a2024", 0.92), 18, Color("#c2362b"), 2, Vector4(10, 6, 10, 6))
	for k in ["normal", "hover", "pressed"]: btn.add_theme_stylebox_override(k, sb)
	btn.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
	for k in ["font_color", "font_hover_color", "font_pressed_color"]: btn.add_theme_color_override(k, Color("#f3e3c0"))
	btn.anchor_left = 1; btn.anchor_right = 1; btn.anchor_top = 1; btn.anchor_bottom = 1; btn.offset_left = -66; btn.offset_right = -8; btn.offset_top = -58 - 46; btn.offset_bottom = -58 - 12
	dot = Panel.new(); dot.add_theme_stylebox_override("panel", UIKit.sb(Color("#e84a5f"), 6, Color("#fff3e0"), 1)); dot.size = Vector2(11, 11); dot.position = Vector2(50, -3); dot.mouse_filter = Control.MOUSE_FILTER_IGNORE; btn.add_child(dot)
	btn.pressed.connect(func(): open("daily" if daily_ready() > 0 else "main"))
	main.add_child(btn)
	var sh = main.get("sheet")
	if sh: main.move_child(btn, sh.get_index())

var tab := "main"
func open(t := "") -> void:
	if t != "": tab = t
	var main = get_tree().root.get_node_or_null("Main")
	if main == null: return
	main.open_sheet("任務", func(): open())
	var body: VBoxContainer = main.sheet_body
	var tabs = HBoxContainer.new(); tabs.add_theme_constant_override("separation", 6); body.add_child(tabs)
	for k in [["main", "主線"], ["side", "支線"], ["daily", "日常"]]:
		var b = UIKit.btn(k[1], "gold" if tab == k[0] else "", true); var kk = k[0]
		b.pressed.connect(func(): open(kk)); tabs.add_child(b)
	body.add_child(UIKit.hsep())
	match tab:
		"main": _main_tab(body)
		"side": _side_tab(body)
		"daily": _daily_tab(body)

func _main_tab(body: VBoxContainer) -> void:
	var s = S(); var Q = J.G.get("Quest"); var qs: Array = J.G.get("QUESTS")
	var qi = int(J.num(s.qi))
	var cur = J.mc(Q, "cur", [])
	if cur is Dictionary:
		var p = J.mc(Q, "progress", [cur])
		body.add_child(UIKit.rich("[b]目前主線[/b]（%d/%d）" % [qi + 1, qs.size()], 15, UIKit.INKTXT))
		body.add_child(UIKit.rich("%s　[color=#9c2219]%d/%d[/color]" % [J.str(cur.text), int(J.num(p[0])), int(J.num(p[1]))], 16, UIKit.INKTXT))
		var go = UIKit.btn("前往", "gold", true); go.size_flags_horizontal = Control.SIZE_SHRINK_END
		go.pressed.connect(func():
			var main = get_tree().root.get_node_or_null("Main")
			main.close_sheet()
			if cur.get("go") == "roster": main.open_roster(); return
			if cur.get("go") == "gate": J.mc(J.G.get("Patrol"), "openPrep", []); return
			var pp = J.mc(J.G.get("Village"), "questTarget", [])
			if pp: J.mc(J.G.get("Village"), "focus", [pp[0], pp[1]]))
		body.add_child(go)
	else: body.add_child(UIKit.rich("主線已經全部完成。", 15, UIKit.INKTXT))
	body.add_child(UIKit.hsep())
	# 巡陰主線目標：已開放嘅區
	var P = J.G.get("Patrol"); var N = J.gp(P, "_nat")
	var shown = false
	for gl in D.get("goals", []):
		if not J.t(J.cl(N.regionOpen, null, [float(gl.ci)])): continue
		var key = "goal_" + gl.id; var got = sq().has(key)
		if got: continue
		if not shown: body.add_child(UIKit.rich("[b]巡陰主線目標[/b]", 15, UIKit.INKTXT)); shown = true
		var v = mini(int(metric(gl.m)), int(gl.n))
		var hb = HBoxContainer.new(); hb.add_theme_constant_override("separation", 8); body.add_child(hb)
		var r = UIKit.rich("%s　[color=#9c2219]%d/%d[/color]\n[color=#6e5838]獎勵：%s[/color]" % [T(gl.text), v, int(gl.n), _rtext(gl.r)], 14, UIKit.INKTXT); r.size_flags_horizontal = Control.SIZE_EXPAND_FILL; hb.add_child(r)
		var b = UIKit.btn("領取", "gold" if v >= int(gl.n) else "", true); b.disabled = v < int(gl.n); b.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		var gg = gl
		b.pressed.connect(func():
			sq()["goal_" + gg.id] = {"done": true, "beat": true}
			G.toast.emit("目標完成：%s\n[b]%s[/b]" % [T(gg.text), J.str(J.cl(J.G.get("give"), null, [gg.r]))]); Snd.play("coin")
			J.cl(J.G.get("save"), null, []); open())
		hb.add_child(b)
	if shown: body.add_child(UIKit.hsep())
	body.add_child(UIKit.rich("[b]已完成[/b]", 14, UIKit.INKDIM))
	for i in range(maxi(0, qi - 6), qi):
		body.add_child(UIKit.rich("[color=#6e5838]✓ %s[/color]" % J.str(qs[i].text), 13, UIKit.INKDIM))

func _side_tab(body: VBoxContainer) -> void:
	var st = sq(); var any = false
	var lst = D.get("side", []).filter(func(x): return st.has(x.id))
	lst.sort_custom(func(a, b): return (1 if st[a.id].done else 0) < (1 if st[b.id].done else 0))
	for x in lst:
		var e = st.get(x.id)
		if e == null: continue
		any = true; e.new = false
		var box = VBoxContainer.new(); box.add_theme_constant_override("separation", 3); body.add_child(box)
		var head = "[b]%s[/b]" % T(x.title) + ("　[color=#3f7a4a]完成[/color]" if e.done else "")
		box.add_child(UIKit.rich(head, 15, UIKit.INKTXT))
		if x.get("desc") != null: box.add_child(UIKit.rich(T(x.desc), 13, UIKit.INKDIM))
		if not e.done:
			var s = x.steps[int(e.step)]
			var pr = _step_prog(x, e)
			var line = "第 %d/%d 步：%s" % [int(e.step) + 1, x.steps.size(), T(s.text)]
			if s.get("pay") != null: line += "　[color=#6e5838]（%s）[/color]" % _rtext(s.pay)
			if s.get("m") != null and int(s.get("n", 1)) > 1: line += "　[color=#9c2219]%d/%d[/color]" % pr
			box.add_child(UIKit.rich(line, 14, UIKit.INKTXT))
			if s.get("pay") != null:
				var b = UIKit.btn(T(["交俾佢", "交給他"]), "gold", true)
				var xx = x; var ee = e
				b.pressed.connect(func(): pay_step(xx, ee); open()); b.size_flags_horizontal = Control.SIZE_SHRINK_END; box.add_child(b)
		body.add_child(UIKit.hsep())
	if not any: body.add_child(UIKit.rich("暫時未有支線。巡陰時打贏地頭王、發現地標，會有鬼搵你幫手。", 14, UIKit.INKDIM))

func _daily_tab(body: VBoxContainer) -> void:
	var q = dq(); var hr: Array = D.get("daily_hr", [])
	if hr.size():
		var i = (hash(q.day) % hr.size() + hr.size()) % hr.size()
		body.add_child(UIKit.rich("[b]冼小姐[/b]：%s" % T(hr[i]), 14, UIKit.INKTXT))
		body.add_child(UIKit.hsep())
	for e in q.list:
		var x = ddef(e.id)
		if x.is_empty(): continue
		var p = dprog(e)
		var hb = HBoxContainer.new(); hb.add_theme_constant_override("separation", 8); body.add_child(hb)
		var vb = VBoxContainer.new(); vb.size_flags_horizontal = Control.SIZE_EXPAND_FILL; vb.add_theme_constant_override("separation", 2); hb.add_child(vb)
		vb.add_child(UIKit.rich(("[color=#6e5838]✓ %s[/color]" if e.got else "%s") % T(x.text), 15, UIKit.INKTXT))
		var bar = ProgressBar.new(); bar.max_value = p[1]; bar.value = p[0]; bar.show_percentage = false; bar.custom_minimum_size = Vector2(0, 6)
		bar.add_theme_stylebox_override("background", UIKit.sb(Color(0, 0, 0, 0.12), 3)); bar.add_theme_stylebox_override("fill", UIKit.sb(Color("#c2362b"), 3))
		vb.add_child(bar)
		vb.add_child(UIKit.rich("[color=#6e5838]%d/%d　獎勵：%s[/color]" % [p[0], p[1], _rtext(x.r)], 12, UIKit.INKDIM))
		var b = UIKit.btn("已領" if e.got else "領取", "gold" if not e.got and p[0] >= p[1] else "", true)
		b.disabled = e.got or p[0] < p[1]; var ee = e
		b.pressed.connect(func(): claim_daily(ee); open()); b.size_flags_vertical = Control.SIZE_SHRINK_CENTER; hb.add_child(b)
		body.add_child(UIKit.hsep())
	var done = q.list.filter(func(e): return e.got).size()
	body.add_child(UIKit.rich("全勤獎（%d/%d）：%s%s　連續全勤 %d 日（7 日有紫箱）" % [done, q.list.size(), _rtext(D.daily_bonus.r), "　已領" if q.bonus else "", int(J.num(q.get("streak", 0)))], 13, UIKit.INKDIM))

func _rtext(r: Dictionary) -> String:
	var names = {"coins": "冥幣", "exp": "好評", "buns": "壽包", "planks": "棺材板", "wood": "槐木", "rice": "糯米", "troops": "陰兵"}
	var out = []
	for k in r:
		if k == "chest": out.append({"g": "綠箱", "b": "藍箱", "p": "紫箱"}[r[k]])
		else: out.append("%s %d" % [names.get(k, k), int(r[k])])
	return "、".join(out)

# 收編劇情：第一次收服名鬼（巡陰簽約／打贏地頭王）
func recruit_scene(k: String, tail: Array = []):
	var R = D.get("recruit", {})
	if not R.has(k): return null
	var G = J.G.get("GHOSTS")
	if G is Dictionary and G.has(k):
		var nm = J.str(G[k].name); var m = DB.D.get("SPEAKER_ART", {})
		if not m.has(nm) and Art.char_h(k) > 0: m[nm] = k
	var lines = []; var zh = {}
	for l in R[k] + tail:
		var txt = l[1]
		if txt is Array: zh[txt[0]] = txt[1]; txt = txt[0]
		lines.append([l[0], txt])
	if zh.size():
		J.mc(J.G.get("LANG"), "add", [zh])
		if not DB.D.has("LANG_ZH"): DB.D.LANG_ZH = {}
		DB.D.LANG_ZH.merge(zh, true)
	return {"style": "talk", "bg": "village", "lines": lines}

# 村內閒聊：雜鬼按 id 固定揀一種性格
static func fodder_pers(g: Dictionary) -> Dictionary:
	var FP: Dictionary = DB.D.get("FODDER_PERS", {})
	var k = str(g.get("k", ""))
	if not FP.has(k) or FP[k].is_empty(): return {}
	var arr: Array = FP[k]
	return arr[abs(str(g.get("id", k)).hash()) % arr.size()]

# 返回可直接 DB.L() 嘅句子 key 列表（名鬼用 CHATTER，雜鬼用性格句，冇就退返類型 CHATTER）
static func chatter_pool(g: Dictionary) -> Array:
	var k = str(g.get("k", ""))
	if DB.D.get("FODDER", {}).has(k):
		var p = fodder_pers(g)
		if not p.is_empty(): return p.lines + DB.D.CHATTER.get(k, [])
	return DB.D.get("CHATTER", {}).get(k, [])

# 測試用
func t_pay(id: String) -> void:
	var x = sdef(id); var e = sq().get(id)
	if e != null: pay_step(x, e)
func t_chat() -> void:
	for g in [{"k": "youhun", "id": 3}, {"k": "youhun", "id": 7}, {"k": "egui", "id": "a1"}, {"k": "n30_pelesit", "id": 1}, {"k": "baiwu", "id": 2}]:
		var p = fodder_pers(g); var pool = chatter_pool(g)
		print("CHAT ", g.k, " pers=", p.get("id", "-"), " enter=", DB.L(p.get("enter", "")), " n=", pool.size(), " ", DB.L(pool[0]))

func t_dump() -> void:
	for k in sq(): print("SQ ", k, " ", sq()[k])
	print("DQ ", dq())

func t_pgchat() -> void:
	var CD = J.G.get("CHAT_DATA")
	for k in ["pg_ji", "pg_ex", "n30_qionggui"]: print("PGCHAT ", k, " ", CD.named.get(k, []).size(), " ", CD.named.get(k, [[""]])[0])
