# 陰陽交界（樣板）：阿福一個人入交界——搜刮、打拖魂者、救卡住嘅靈魂、天光前返雜貨店
# 操作：左邊拖＝行；右下：打（撳住連打）、擲樽、衝、電筒；情境掣（講／搜／拎／轉閘／開店）；回店（撳住 3 秒）
class_name LbRun
extends Control

static var cur: LbRun = null

const D = preload("res://game/limbo/lb_data.gd")
const C := 64.0
const SHOP_R := 230.0          # 雜貨店燈光範圍（安全區）
const SPD := 175.0

var S: Dictionary
var st: Dictionary             # S.lb：成個模式嘅存檔
var world: PtDraw
var hud: PtDraw
var dark: ColorRect
var dark_mat: ShaderMaterial
var menu: Control = null

var hmap := PackedFloat32Array()
var props: Array = []
var caches: Array = []
var foes: Array = []
var souls: Dictionary = {}
var items: Array = []          # 地上任務物品
var drops: Array = []          # 怨灰
var fx: Array = []
var trails: Array = []         # 拖痕

var tt := 0.0                  # 今晚過咗幾耐
var t := 0.0                   # 動畫時間
var level := D.L0
var gate_open := false
var ended := false
var paused := false
var cam := Vector2.ZERO
var sc := 1.0
var shake := 0.0
var spawn_t := 0.0
var galah_t := 20.0
var bone_t := 30.0
var msg_q: Array = []
var objective := ""

# 阿福
var A := {}
var inv := {}                  # 任務物品
var bag := {}                  # 今趟帶住（未存入鋪頭）

# 輸入
var joy = null                 # {"i": 觸控編號, "o": 起點, "p": 現位}
var held := {}                 # 掣 → 觸控編號
var hold_t := 0.0              # 情境掣／回店撳住幾耐
var hold_k := ""

func T(a) -> String: return a[0] if DB.lang == "yue" else a[1]

# ---------------- 開／收 ----------------
static func start() -> bool:
	var main = Engine.get_main_loop().root.get_node_or_null("Main")
	if main == null: return false
	if cur != null and is_instance_valid(cur): cur.queue_free()
	var r = LbRun.new(); r.name = "LbRun"
	r.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	main.add_child(r)
	var sh = main.get("sheet")
	if sh: main.move_child(r, sh.get_index())
	cur = r
	r._cover(true)
	r.begin()
	return true

var _hidden: Array = []
func _cover(on: bool) -> void:
	var main = get_parent()
	if on:
		for nm in ["village", "dom"]:
			var n = main.get(nm)
			if n is CanvasItem and n.visible:
				n.visible = false; n.process_mode = Node.PROCESS_MODE_DISABLED; _hidden.append(n)
	else:
		for n in _hidden:
			if is_instance_valid(n): n.visible = true; n.process_mode = Node.PROCESS_MODE_INHERIT
		_hidden.clear()

func begin() -> void:
	S = J.G.get("S")
	if not (S.get("lb") is Dictionary): S["lb"] = {}
	st = S.lb
	for k in ["mats", "souls", "lost", "wlv"]: if not (st.get(k) is Dictionary): st[k] = {}
	if not st.has("wpn"): st["wpn"] = "tongs"
	if not st.has("own"): st["own"] = {"tongs": true}
	if not st.has("night"): st["night"] = 1.0
	for k in D.SOUL_ART: DB.D.SPEAKER_ART[k] = D.SOUL_ART[k]
	DB.D.SPEAKER_ART["雜貨店伯"] = "npc_shop"
	mouse_filter = Control.MOUSE_FILTER_STOP
	_build_map()
	world = PtDraw.new(); world.fn = _draw_world; add_child(world)
	dark = ColorRect.new(); dark.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); dark.mouse_filter = Control.MOUSE_FILTER_IGNORE
	dark_mat = ShaderMaterial.new(); var sh = Shader.new(); sh.code = DARK_SHADER; dark_mat.shader = sh; dark.material = dark_mat
	add_child(dark)
	hud = PtDraw.new(); hud.fn = _draw_hud; add_child(hud)
	Snd.set_mode("battle")
	_new_night()
	if not J.t(st.get("intro")):
		st["intro"] = true
		_story(D.INTRO, "陰陽交界")

func _new_night() -> void:
	tt = 0.0; level = D.L0; gate_open = false; ended = false
	foes.clear(); drops.clear(); trails.clear(); items.clear(); fx.clear(); inv.clear(); bag.clear()
	caches = D.caches()
	for c in caches: c["done"] = false
	souls.clear()
	for id in D.SOULS:
		if st.souls.has(id) or st.lost.has(id): continue
		var d = D.SOULS[id]
		souls[id] = {"id": id, "d": d, "x": d.at.x * C, "y": d.at.y * C, "hx": d.at.x * C, "hy": d.at.y * C, "state": "idle", "prev": "idle", "line": 0, "bub": 0.0, "got": 0, "crank": 0.0}
	var sp = D.SHOP * C + Vector2(0, 150)
	A = {"x": sp.x, "y": sp.y, "fx": 1.0, "fy": 0.0, "yang": ymax(), "cd": 0.0, "sw": 0.0, "dash": 0.0, "dcd": 0.0, "hit": 0.0, "grab": 0.0, "light": false, "batt": 0.0, "dead": 0.0}
	cam = Vector2(A.x, A.y)
	galah_t = 25.0; bone_t = 40.0; spawn_t = 3.0
	_msg(T(["第 %d 晚。23:00。水開始漲。" % int(st.night), "第 %d 晚。23:00。水開始漲。" % int(st.night)]))

func ymax() -> float:
	var m = 100.0
	if J.str(st.souls.get("guard", "")) == "stay": m += 20.0
	return m

func close_mode() -> void:
	_bank()
	J.cl(J.G.get("save"), null, [])
	_cover(false)
	Snd.set_mode("village")
	J.mc(J.G.get("UI"), "refresh", [])
	cur = null
	queue_free()

# ---------------- 地圖 ----------------
func _build_map() -> void:
	hmap.resize(D.COLS * D.ROWS)
	for y in D.ROWS:
		for x in D.COLS: hmap[y * D.COLS + x] = D.height(x, y)
	props.clear()
	for p in D.props(): props.append({"k": p[0], "x": p[1] * C, "y": p[2] * C, "h": p[3], "r": p[4]})

func h_at(x: float, y: float) -> float:
	var cx = clampi(int(x / C), 0, D.COLS - 1); var cy = clampi(int(y / C), 0, D.ROWS - 1)
	return hmap[cy * D.COLS + cx]
func depth(x: float, y: float) -> float:
	var d = level - h_at(x, y)
	if gate_open and Vector2(x, y).distance_to(D.GATE * C) < 120: d += 0.6      # 閘口水急
	return d
func shop_p() -> Vector2: return D.SHOP * C
func in_shop(x: float, y: float) -> bool: return Vector2(x, y).distance_to(shop_p() + Vector2(0, 40)) < SHOP_R

# ---------------- 每幀 ----------------
func _process(dt: float) -> void:
	dt = minf(dt, 0.05)
	t += dt
	var busy = J.t(J.mc(J.G.get("Story"), "busy", []))
	if not ended and not busy and not paused and menu == null: update(dt)
	var vs = size; sc = vs.x / 450.0
	cam = cam.lerp(Vector2(A.x, A.y - 30), minf(1.0, dt * 6.0))
	world.position = vs / 2 - cam * sc + Vector2(randf_range(-shake, shake), randf_range(-shake, shake))
	world.scale = Vector2(sc, sc)
	shake = maxf(0.0, shake - dt * 30.0)
	_upd_dark()
	world.queue_redraw(); hud.queue_redraw()

func update(dt: float) -> void:
	tt += dt
	var rate = (D.L1 - D.L0) / D.NIGHT_SEC
	if gate_open: rate *= 0.3
	level += rate * dt
	if tt >= D.NIGHT_SEC: _dawn(); return
	_upd_afu(dt)
	_upd_souls(dt)
	_upd_foes(dt)
	_spawner(dt)
	for d in drops.duplicate():
		d.t += dt
		if Vector2(d.x, d.y).distance_to(Vector2(A.x, A.y)) < 46 or d.t > 40:
			if d.t <= 40: _gain({"ash": d.n}); Snd.play("coin")
			drops.erase(d)
	for f in fx.duplicate():
		f.t += dt
		if f.t > f.life: fx.erase(f)
	for tr in trails.duplicate():
		tr.t += dt
		if tr.t > 14.0: trails.erase(tr)
	for m in msg_q.duplicate():
		m.t += dt
		if m.t > 3.2: msg_q.erase(m)
	_hold_tick(dt)

# ---------------- 阿福 ----------------
func wpn() -> Dictionary:
	var w = D.WPN[J.str(st.wpn)].duplicate()
	var lv = int(J.num(st.wlv.get(st.wpn, 0)))
	w.dmg *= 1.0 + 0.18 * lv
	return w

func _upd_afu(dt: float) -> void:
	if A.dead > 0:
		A.dead -= dt
		if A.dead <= 0: _respawn()
		return
	var mv = Vector2.ZERO
	if joy != null:
		var d = joy.p - joy.o
		if d.length() > 8: mv = d.limit_length(70) / 70.0
	var kb := Vector2(Input.get_axis("ui_left", "ui_right"), Input.get_axis("ui_up", "ui_down"))
	if kb.length() > 0.1: mv = kb.normalized()
	var sp = SPD
	var dp = depth(A.x, A.y)
	if dp > 1.0: sp *= 0.5
	elif dp > 0.3: sp *= 0.72
	if A.grab > 0: sp *= 0.4; A.grab -= dt
	if A.dash > 0:
		A.dash -= dt; sp = 560.0
		if mv.length() < 0.1: mv = Vector2(A.fx, A.fy)
	A.dcd = maxf(0.0, A.dcd - dt)
	if mv.length() > 0.05:
		A.fx = mv.normalized().x; A.fy = mv.normalized().y
	var nx = A.x + mv.x * sp * dt; var ny = A.y + mv.y * sp * dt
	var p = _collide(nx, ny, 14.0)
	A.x = p.x; A.y = p.y
	A["moving"] = mv.length() > 0.05
	# 陽氣
	var safe = in_shop(A.x, A.y)
	if safe:
		A.yang = minf(ymax(), A.yang + 14.0 * dt)
		if not bag.is_empty(): _bank(); Snd.play("coin")
	else:
		var drain = 0.42
		if dp > 0.3: drain += 0.8
		if dp > 1.0: drain += 0.8
		A.yang -= drain * dt
	A.hit = maxf(0.0, A.hit - dt)
	# 打
	A.cd = maxf(0.0, A.cd - dt); A.sw = maxf(0.0, A.sw - dt)
	if held.has("atk") and A.cd <= 0: swing()
	# 電筒
	if A.light:
		if A.batt <= 0:
			if _take("bat", 1): A.batt = 25.0
			else: A.light = false; _msg(T(["冇電芯喇。", "沒電池了。"]))
		A.batt -= dt
	if A.yang <= 0: _die()

func _collide(nx: float, ny: float, r: float) -> Vector2:
	nx = clampf(nx, 20, D.COLS * C - 20); ny = clampf(ny, 20, D.ROWS * C - 20)
	for pr in props:
		if pr.r <= 0: continue
		var d = Vector2(nx - pr.x, (ny - pr.y) * 1.6)
		var rr = pr.r + r
		if d.length() < rr and d.length() > 0.01:
			var n = d.normalized() * rr
			nx = pr.x + n.x; ny = pr.y + n.y / 1.6
	return Vector2(nx, ny)

func swing() -> void:
	var w = wpn()
	A.cd = w.cd; A.sw = 0.22
	var fwd = Vector2(A.fx, A.fy)
	var hit_any = false
	for f in foes.duplicate():
		var d = Vector2(f.x - A.x, f.y - A.y)
		if d.length() > w.rng + 16: continue
		if d.length() > 6 and rad_to_deg(abs(fwd.angle_to(d))) > w.arc / 2: continue
		_hurt_foe(f, w.dmg, d.normalized() * w.kb, w.stun)
		hit_any = true
	fx.append({"k": "slash", "x": A.x + fwd.x * 40, "y": A.y - 26 + fwd.y * 30, "a": fwd.angle(), "t": 0.0, "life": 0.2, "arc": w.arc})
	Snd.play("hit" if hit_any else "click")

func throw_bottle() -> void:
	if not _take("bottle", 1): _msg(T(["冇玻璃樽。去搜吓啲箱。", "沒有玻璃瓶。去搜搜箱子。"])); return
	var tg = null; var best = 380.0
	for f in foes:
		var dd = Vector2(f.x - A.x, f.y - A.y).length()
		if dd < best: best = dd; tg = f
	var to = Vector2(A.x + A.fx * 260, A.y + A.fy * 260) if tg == null else Vector2(tg.x, tg.y)
	fx.append({"k": "bottle", "x": A.x, "y": A.y - 30, "ox": A.x, "oy": A.y - 30, "tx": to.x, "ty": to.y, "t": 0.0, "life": 0.45})
	later(0.45, _bottle_land.bind(to))
	Snd.play("click")

func _bottle_land(to: Vector2) -> void:
	for f in foes.duplicate():
		if Vector2(f.x - to.x, f.y - to.y).length() < 70: _hurt_foe(f, 32.0, (Vector2(f.x, f.y) - to).normalized() * 90, 0.6)
	fx.append({"k": "splash", "x": to.x, "y": to.y, "t": 0.0, "life": 0.5})
	Snd.play("hit"); shake = 4.0

func dash() -> void:
	if A.dcd > 0 or A.dead > 0: return
	A.dash = 0.17; A.dcd = 1.6; A.grab = 0.0
	fx.append({"k": "dust", "x": A.x, "y": A.y, "t": 0.0, "life": 0.4})

var _later: Array = []
var _uid := 0
func later(s: float, f: Callable) -> void:
	_later.append({"t": s, "f": f})
func _physics_process(dt: float) -> void:
	for l in _later.duplicate():
		l.t -= dt
		if l.t <= 0: _later.erase(l); l.f.call()

func _hurt_afu(n: float, from: Vector2, grab := false) -> void:
	if A.dead > 0 or A.dash > 0: return
	if in_shop(A.x, A.y): return
	A.yang -= n; A.hit = 0.3; shake = 6.0
	var p = _collide(A.x + (A.x - from.x) * 0.25, A.y + (A.y - from.y) * 0.25, 14.0); A.x = p.x; A.y = p.y
	if grab and depth(A.x, A.y) > 0.3: A.grab = 1.3; _msg(T(["有嘢捉住你隻腳！撳「衝」掙脫！", "有東西抓住你的腳！按「衝」掙脫！"]))
	Snd.play("heartbeat" if A.yang < 30 else "hit")

func _die() -> void:
	A.dead = 2.2; A.yang = 0.0
	var lost = bag.duplicate(); bag.clear()
	for id in souls:
		var s = souls[id]
		if s.state == "follow": s.state = "wait"; s.hx = s.x; s.hy = s.y
	_msg(T(["陽氣散晒……帶住嘅嘢冇晒。", "陽氣散盡……身上的東西都沒了。"]))
	Snd.play("lose")

func _respawn() -> void:
	var sp = shop_p() + Vector2(0, 130)
	A.x = sp.x; A.y = sp.y; A.yang = ymax() * 0.6; A.grab = 0.0
	cam = Vector2(A.x, A.y)

func _gain(d: Dictionary) -> void:
	for k in d: bag[k] = J.num(bag.get(k, 0)) + J.num(d[k])
func _bank() -> void:
	for k in bag: st.mats[k] = J.num(st.mats.get(k, 0)) + J.num(bag[k])
	bag.clear()
func have(k: String) -> float: return J.num(bag.get(k, 0)) + J.num(st.mats.get(k, 0))
func _take(k: String, n: float) -> bool:
	if have(k) < n: return false
	var b = J.num(bag.get(k, 0)); var u = minf(b, n)
	bag[k] = b - u; st.mats[k] = J.num(st.mats.get(k, 0)) - (n - u)
	return true

# ---------------- 靈魂 ----------------
func _upd_souls(dt: float) -> void:
	for id in souls:
		var s = souls[id]
		s.bub = maxf(0.0, s.bub - dt)
		match s.state:
			"follow":
				var d = Vector2(A.x - s.x, A.y - s.y)
				if d.length() > 70 and d.length() < 700:
					var p = Vector2(s.x, s.y) + d.normalized() * minf(d.length() - 60, 165.0 * dt)
					s.x = p.x; s.y = p.y
				if in_shop(s.x, s.y): _soul_home(s)
			"dragged":
				pass
			_:
				# 原地重複做嗰晚嘅嘢（輕輕郁）
				s.x = s.hx + sin(t * 0.7 + s.hx) * 10.0
	# 拾任務物品
	for it in items.duplicate():
		if Vector2(it.x - A.x, it.y - A.y).length() < 50:
			items.erase(it)
			inv[it.item] = J.num(inv.get(it.item, 0)) + 1
			Snd.play("chest")
			var s = souls[it.soul]
			if it.item == "shirt":
				_msg(T(["拎到件衫（%d/3）" % int(inv.shirt), "拿到衣服（%d/3）" % int(inv.shirt)]))
			else:
				_msg(T(["拎到：", "拿到："]) + T(s.d.task.n))
			_objective()

func talk(s: Dictionary) -> void:
	var d = s.d
	if s.state == "idle":
		s.state = "met"
		_spawn_task_items(s)
		_say(s)
		later(1.2, func(): _msg(T(d.task.hint)))
		_objective(); return
	if s.state == "met":
		var ok = false
		match d.task.t:
			"fetch": ok = inv.has(d.task.item)
			"collect": ok = J.num(inv.get(d.task.item, 0)) >= d.task.need
			"fetch_then_crank": ok = gate_open
		if ok:
			s.state = "follow"
			_story(d.mem, d.name)
			_objective()
		else:
			_say(s)
		return
	if s.state == "wait":
		s.state = "follow"; _say_t(s, ["我跟住你。", "我跟著你。"]); return
	_say(s)

func _say(s: Dictionary) -> void:
	var lp = s.d.loop
	s.say = lp[s.line % lp.size()]; s.line += 1; s.bub = 3.2
func _say_t(s: Dictionary, a: Array) -> void: s.say = a; s.bub = 2.5

func _spawn_task_items(s: Dictionary) -> void:
	var tk = s.d.task
	match tk.t:
		"fetch", "fetch_then_crank":
			items.append({"item": tk.item, "soul": s.id, "x": tk.at.x * C + 30, "y": tk.at.y * C + 40})
		"collect":
			for c in D.CLOTHES: items.append({"item": "shirt", "soul": s.id, "x": c.x * C, "y": c.y * C})

func _soul_home(s: Dictionary) -> void:
	s.state = "home"
	var d = s.d
	st.souls[s.id] = d.end
	var lines = d.fin.duplicate()
	if d.end == "wake":
		for k in d.gift: st.mats[k] = J.num(st.mats.get(k, 0)) + d.gift[k]
		lines.append(["旁白", d.gift_t])
	else:
		lines.append(["旁白", [d.perk[0], d.perk[1]]])
		A.yang = ymax()
	_story(lines, d.name)
	Snd.play("win")
	J.cl(J.G.get("save"), null, [])
	var left = 0
	for id in D.SOULS: if not st.souls.has(id) and not st.lost.has(id): left += 1
	if left == 0 and not J.t(st.get("all_done")):
		st["all_done"] = true
		later(0.5, func(): _story(D.ALL_DONE, "雜貨店"))
	_objective()

func _objective() -> void:
	objective = ""
	for id in souls:
		var s = souls[id]
		if s.state == "follow": objective = T(["帶%s返雜貨店" % s.d.name, "帶%s回雜貨店" % s.d.name]); return
	for id in souls:
		var s = souls[id]
		if s.state != "met": continue
		var tk = s.d.task
		match tk.t:
			"fetch": objective = T(["搵%s，交俾%s" % [T(tk.n), s.d.name], "找%s，交給%s" % [T(tk.n), s.d.name]]) if not inv.has(tk.item) else T(["將%s交返俾%s" % [T(tk.n), s.d.name], "把%s交還給%s" % [T(tk.n), s.d.name]])
			"collect": objective = T(["搵齊三件衫（%d/3）" % int(J.num(inv.get("shirt", 0))), "找齊三件衣服（%d/3）" % int(J.num(inv.get("shirt", 0)))])
			"fetch_then_crank": objective = (T(["去更亭攞閘門鎖匙", "去更亭拿閘門鑰匙"]) if not inv.has("key") else (T(["去水閘轉開閘門（撳住）", "去水閘轉開閘門（按住）"]) if not gate_open else T(["同保安伯講", "跟保安伯說話"])))
		return

# ---------------- 拖魂者 ----------------
func _spawner(dt: float) -> void:
	spawn_t -= dt; galah_t -= dt; bone_t -= dt
	var want = 3 + int(tt / 80.0)
	if spawn_t <= 0:
		spawn_t = 2.5
		var nk = 0
		for f in foes: if f.k == "kappa": nk += 1
		if nk < mini(want, 7):
			for i in 12:
				var a = randf() * TAU; var r = randf_range(260, 520)
				var x = A.x + cos(a) * r; var y = A.y + sin(a) * r
				if x < 20 or y < 20 or x > D.COLS * C - 20 or y > D.ROWS * C - 20: continue
				if depth(x, y) > 0.5 and not in_shop(x, y):
					_spawn("kappa", x, y); break
	if galah_t <= 0:
		galah_t = maxf(28.0, 55.0 - tt / 20.0)
		var tg = _galah_target(null)
		var ng = 0
		for f in foes: if f.k == "galah": ng += 1
		if tg != null and ng < 2:
			var rp = _near_rift(tg.x, tg.y)
			_spawn("galah", rp.x, rp.y)
			_msg(T(["裂口有嘢爬咗出嚟……", "裂口有東西爬了出來……"]))
	if bone_t <= 0:
		bone_t = maxf(22.0, 42.0 - tt / 25.0)
		var nb = 0
		for f in foes: if f.k == "bone": nb += 1
		if nb < 3:
			var rp = D.RIFTS[randi() % D.RIFTS.size()] * C
			_spawn("bone", rp.x, rp.y)

func _spawn(k: String, x: float, y: float) -> void:
	var d = D.FOE[k]
	var hpm = 1.0 + tt / D.NIGHT_SEC * 0.6
	_uid += 1
	foes.append({"uid": _uid, "k": k, "d": d, "x": x, "y": y, "hp": d.hp * hpm, "mhp": d.hp * hpm, "cd": 1.0, "stun": 0.0, "hit": 0.0, "kbx": 0.0, "kby": 0.0, "tg": null, "drag": null, "fx": 1.0, "rise": 0.6, "trail_d": 0.0})

func _near_rift(x: float, y: float) -> Vector2:
	var b = D.RIFTS[0] * C
	for r in D.RIFTS: if (r * C).distance_to(Vector2(x, y)) < b.distance_to(Vector2(x, y)): b = r * C
	return b

func _galah_target(me) -> Variant:
	var best = null; var bd = 1e9
	for id in souls:
		var s = souls[id]
		if not (s.state in ["idle", "met", "follow", "wait"]): continue
		if in_shop(s.x, s.y): continue
		var taken = false
		for f in foes: if f != me and (f.tg == s or f.drag == s): taken = true
		if taken: continue
		var d = Vector2(s.x, s.y).distance_to(Vector2(A.x, A.y) if me == null else Vector2(me.x, me.y))
		if d < bd: bd = d; best = s
	return best

func _upd_foes(dt: float) -> void:
	var ap = Vector2(A.x, A.y)
	for f in foes.duplicate():
		var d = f.d
		f.hit = maxf(0.0, f.hit - dt); f.rise = maxf(0.0, f.rise - dt)
		f.x += f.kbx * dt; f.y += f.kby * dt; f.kbx *= 0.86; f.kby *= 0.86
		if f.stun > 0: f.stun -= dt; continue
		if f.rise > 0: continue
		var sp = d.spd * (1.0 + tt / D.NIGHT_SEC * 0.25)
		var lit = _in_cone(f.x, f.y)
		if lit: sp *= 0.45
		f.cd -= dt
		var p = Vector2(f.x, f.y)
		var goal = ap
		if f.k == "galah":
			if f.drag != null:
				var s = f.drag
				if lit:
					f["grip"] = J.num(f.get("grip", 0)) + dt
					if f.grip > 1.6: _release(f, T(["電筒照住，長手鬼鬆咗手！", "手電筒照著，長手鬼鬆了手！"]))
				var rp = _near_rift(f.x, f.y)
				var dv = rp - p
				if dv.length() < 36:
					_soul_lost(s); foes.erase(f); continue
				var step = dv.normalized() * 62.0 * (0.4 if lit else 1.0) * dt
				f.x += step.x; f.y += step.y; f.fx = signf(step.x) if abs(step.x) > 0.01 else f.fx
				s.x = f.x - f.fx * 26; s.y = f.y + 6
				f.trail_d += step.length()
				if f.trail_d > 22: f.trail_d = 0; trails.append({"x": s.x, "y": s.y + 8, "t": 0.0})
				continue
			if f.tg == null or not (f.tg.state in ["idle", "met", "follow", "wait"]): f.tg = _galah_target(f)
			if f.tg != null:
				goal = Vector2(f.tg.x, f.tg.y)
				if p.distance_to(goal) < 34 and not in_shop(goal.x, goal.y):
					var s = f.tg
					s.prev = s.state; s.state = "dragged"; f.drag = s; f.tg = null; f.grip = 0.0
					_msg(T(["%s俾長手鬼捉住咗！追佢！" % s.d.name, "%s被長手鬼抓住了！快追！" % s.d.name]))
					Snd.play("crow"); continue
		var dv2 = goal - p
		var dist = dv2.length()
		if f.k == "kappa" and depth(f.x, f.y) < 0.1 and dist > 160:
			f.hp -= 6.0 * dt          # 離水太耐會乾
		if dist > d.rng * 0.8:
			var stp = dv2.normalized() * sp * dt
			var np = p + stp
			if in_shop(np.x, np.y): np = p          # 唔入得燈光
			var c2 = _collide(np.x, np.y, 12.0)
			f.x = c2.x; f.y = c2.y
			if abs(stp.x) > 0.01: f.fx = signf(stp.x)
		elif goal == ap and f.cd <= 0:
			f.cd = d.cd
			_hurt_afu(d.atk * (1.0 + tt / D.NIGHT_SEC * 0.4), p, f.k == "kappa")
		if f.hp <= 0: _kill(f)

func _in_cone(x: float, y: float) -> bool:
	if not A.light: return false
	var d = Vector2(x - A.x, y - (A.y - 30))
	if d.length() > 300: return false
	return abs(Vector2(A.fx, A.fy).angle_to(d)) < deg_to_rad(28)

func _hurt_foe(f: Dictionary, n: float, kb: Vector2, stun: float) -> void:
	f.hp -= n; f.hit = 0.15; f.kbx += kb.x * 4; f.kby += kb.y * 4
	if stun > 0: f.stun = maxf(f.stun, stun)
	fx.append({"k": "num", "x": f.x, "y": f.y - f.d.h - 6, "n": int(n), "t": 0.0, "life": 0.7})
	shake = maxf(shake, 3.0)
	if f.hp <= 0: _kill(f)

func _release(f: Dictionary, m: String) -> void:
	var s = f.drag
	if s == null: return
	f.drag = null
	s.state = s.prev if s.prev != "dragged" else "met"
	s.hx = s.x; s.hy = s.y
	f.stun = 1.5
	_msg(m)

func _kill(f: Dictionary) -> void:
	if not foes.has(f): return
	if f.drag != null: _release(f, T(["打低咗長手鬼！%s冇事。" % f.drag.d.name, "打倒了長手鬼！%s沒事。" % f.drag.d.name]))
	foes.erase(f)
	drops.append({"x": f.x, "y": f.y, "n": f.d.ash, "t": 0.0})
	fx.append({"k": "poof", "x": f.x, "y": f.y - f.d.h * 0.5, "t": 0.0, "life": 0.5})
	Snd.play("skill")

func _soul_lost(s: Dictionary) -> void:
	s.state = "lost"; st.lost[s.id] = true
	_msg(T(["%s俾拖咗落冥界牢……" % s.d.name, "%s被拖進了冥界牢……" % s.d.name]))
	shake = 10.0; Snd.play("lose")
	J.cl(J.G.get("save"), null, [])
	_objective()

# ---------------- 互動 ----------------
func ctx() -> Dictionary:
	if A.dead > 0: return {}
	var ap = Vector2(A.x, A.y)
	if in_shop(A.x, A.y) and ap.distance_to(shop_p()) < 170: return {"k": "shop", "n": T(["入鋪", "進店"])}
	if inv.has("key") and not gate_open and ap.distance_to(D.GATE * C) < 90: return {"k": "crank", "n": T(["轉閘", "轉閘"]), "hold": 3.5}
	for id in souls:
		var s = souls[id]
		if s.state in ["idle", "met", "wait"] and ap.distance_to(Vector2(s.x, s.y)) < 105: return {"k": "talk", "s": s, "n": T(["講嘢", "說話"])}
	for c in caches:
		if not c.done and ap.distance_to(Vector2(c.x * C, c.y * C)) < 70: return {"k": "search", "c": c, "n": T(["搜", "搜"]), "hold": 1.0}
	return {}

func _hold_tick(dt: float) -> void:
	if held.has("ctx"):
		var c = ctx()
		if c.has("hold"):
			if hold_k != c.k: hold_k = c.k; hold_t = 0.0
			hold_t += dt
			if c.k == "crank" and fmod(hold_t, 0.5) < dt: Snd.play("click")
			if hold_t >= c.hold:
				hold_t = 0.0; held.erase("ctx")
				_do(c)
			return
	if held.has("home"):
		var near = false
		for f in foes: if Vector2(f.x - A.x, f.y - A.y).length() < 260: near = true
		if near:
			if hold_k != "home_x": _msg(T(["附近有嘢，返唔到鋪頭！", "附近有東西，回不了店！"]))
			hold_k = "home_x"; hold_t = 0.0; return
		if hold_k != "home": hold_k = "home"; hold_t = 0.0
		hold_t += dt
		if hold_t >= 3.0:
			hold_t = 0.0; held.erase("home")
			var sp = shop_p() + Vector2(0, 130); A.x = sp.x; A.y = sp.y; cam = Vector2(A.x, A.y)
			for id in souls:
				var s = souls[id]
				if s.state == "follow": s.x = A.x + 40; s.y = A.y + 20
			Snd.play("gong")
		return
	hold_k = ""; hold_t = 0.0

func _do(c: Dictionary) -> void:
	if c.is_empty(): return
	match c.k:
		"shop": open_shop()
		"talk": talk(c.s)
		"search":
			c.c.done = true
			_gain(c.c.loot)
			var s = []
			for k in c.c.loot: s.append("%s ×%d" % [T(D.MAT_NAME[k]), int(c.c.loot[k])])
			_msg(T(["搜到：", "搜到："]) + "、".join(s)); Snd.play("chest")
			# 搜嘢有聲，附近嘅嘢會過嚟
			for f in foes: if Vector2(f.x - A.x, f.y - A.y).length() < 500 and f.k != "galah": f.cd = minf(f.cd, 0.3)
		"crank":
			gate_open = true; inv.erase("key")
			_msg(T(["閘門開咗！水漲得慢咗。", "閘門開了！水漲得慢了。"]))
			Snd.play("gong"); shake = 8.0
			for id in souls:
				var s = souls[id]
				if s.d.task.t == "fetch_then_crank": s.hx = D.GATE.x * C + 50; s.hy = D.GATE.y * C; s.x = s.hx; s.y = s.hy
			_objective()

# ---------------- 天光 ----------------
func _dawn() -> void:
	ended = true
	_bank()
	for f in foes: if f.drag != null: _release(f, "")
	var saved = []; var lost = []
	for id in D.SOULS:
		if J.str(st.souls.get(id, "")) != "": saved.append(D.SOULS[id].name)
		if st.lost.has(id): lost.append(D.SOULS[id].name)
	st.night = J.num(st.night) + 1.0
	J.cl(J.G.get("save"), null, [])
	_end_panel(saved, lost)

# ---------------- 輸入（多點觸控：一隻手搖桿、一隻手打） ----------------
func _btns() -> Dictionary:
	var w = size.x; var h = size.y; var k = sc
	var b = {
		"atk": [Vector2(w - 82 * k, h - 140 * k), 54 * k],
		"bottle": [Vector2(w - 182 * k, h - 92 * k), 36 * k],
		"dash": [Vector2(w - 182 * k, h - 190 * k), 34 * k],
		"light": [Vector2(w - 82 * k, h - 250 * k), 32 * k],
		"home": [Vector2(w - 40 * k, 128 * k), 28 * k],
	}
	if not ctx().is_empty(): b["ctx"] = [Vector2(w - 268 * k, h - 150 * k), 44 * k]
	return b

func _btn_at(p: Vector2) -> String:
	var bs = _btns()
	for k in bs:
		if p.distance_to(bs[k][0]) < bs[k][1] * 1.15: return k
	return ""

func _input(ev: InputEvent) -> void:
	if menu != null or ended: return
	if J.t(J.mc(J.G.get("Story"), "busy", [])): return
	var idx := -1; var pos := Vector2.ZERO; var down := false; var drag := false
	if ev is InputEventScreenTouch: idx = ev.index; pos = ev.position; down = ev.pressed
	elif ev is InputEventScreenDrag: idx = ev.index; pos = ev.position; drag = true
	elif ev is InputEventMouseButton and ev.device != InputEvent.DEVICE_ID_EMULATION and ev.button_index == MOUSE_BUTTON_LEFT: idx = 100; pos = ev.position; down = ev.pressed
	elif ev is InputEventMouseMotion and ev.device != InputEvent.DEVICE_ID_EMULATION and joy != null and joy.i == 100: idx = 100; pos = ev.position; drag = true
	else: return
	pos = pos - global_position
	if drag:
		if joy != null and joy.i == idx: joy.p = pos
		get_viewport().set_input_as_handled(); return
	if down:
		var b = _btn_at(pos)
		if b != "":
			held[b] = idx; _press(b)
		elif joy == null:
			joy = {"i": idx, "o": pos, "p": pos}
	else:
		if joy != null and joy.i == idx:
			# 輕撳（冇拖）＝撳地圖上嘅嘢
			if (joy.p - joy.o).length() < 12: _tap_world(pos)
			joy = null
		for k in held.keys():
			if held[k] == idx: held.erase(k)
	get_viewport().set_input_as_handled()

func _press(b: String) -> void:
	match b:
		"atk": if A.cd <= 0: swing()
		"bottle": throw_bottle()
		"dash": dash()
		"light":
			if not A.light and A.batt <= 0 and have("bat") < 1: _msg(T(["冇電芯。", "沒電池。"])); return
			A.light = not A.light; Snd.play("click")
		"ctx":
			var c = ctx()
			if not c.has("hold"): held.erase("ctx"); _do(c)
		"home": pass

func _tap_world(p: Vector2) -> void:
	var w = (p - world.position) / sc
	if w.distance_to(shop_p()) < 110 and in_shop(A.x, A.y): open_shop()

# ---------------- 劇情 ----------------
func _story(lines: Array, title: String) -> void:
	QX._story({"style": "talk", "bg": "kampung", "title": title, "lines": lines})
func _msg(m: String) -> void:
	if m == "": return
	msg_q.append({"m": m, "t": 0.0})
	if msg_q.size() > 3: msg_q.pop_front()

# ---------------- 畫：世界 ----------------
func _vis_rect() -> Rect2:
	var hw = size.x / sc / 2 + 80; var hh = size.y / sc / 2 + 140
	return Rect2(cam.x - hw, cam.y - hh, hw * 2, hh * 2)

func _draw_world(c: CanvasItem) -> void:
	var vr = _vis_rect()
	var x0 = maxi(0, int(vr.position.x / C)); var x1 = mini(D.COLS - 1, int(vr.end.x / C))
	var y0 = maxi(0, int(vr.position.y / C)); var y1 = mini(D.ROWS - 1, int(vr.end.y / C))
	var gt = [PtGfx.tex("ground0"), PtGfx.tex("ground1"), PtGfx.tex("ground2"), PtGfx.tex("ground3")]
	for y in range(y0, y1 + 1):
		for x in range(x0, x1 + 1):
			var h = hmap[y * D.COLS + x]
			var gi = 2 if y < 30 else (1 if y < 42 else 0)
			var r = Rect2(x * C, y * C, C + 1, C + 1)
			var br = 0.62 + (1.0 - float(y) / D.ROWS) * 0.3
			if gt[gi]: c.draw_texture_rect(gt[gi], r, false, Color(br * 0.85, br * 0.95, br, 1))
			else: c.draw_rect(r, Color(0.2 + h * 0.03, 0.22 + h * 0.03, 0.18, 1))
	# 路
	c.draw_rect(Rect2(17.2 * C, 8 * C, 1.6 * C, 32 * C), Color(0.35, 0.3, 0.24, 0.55))
	# 拖痕
	for tr in trails:
		var a = (1.0 - tr.t / 14.0) * 0.55
		c.draw_circle(Vector2(tr.x, tr.y), 9, Color(0.25, 0.05, 0.3, a))
	# 裂口
	for r in D.RIFTS:
		var p = r * C
		c.draw_set_transform(p, 0, Vector2(1, 0.45))
		c.draw_circle(Vector2.ZERO, 70, Color(0.12, 0.0, 0.16, 0.9))
		c.draw_circle(Vector2.ZERO, 52 + sin(t * 2) * 4, Color(0.35, 0.05, 0.45, 0.6))
		c.draw_circle(Vector2.ZERO, 30, Color(0.02, 0, 0.03, 1))
		c.draw_set_transform(Vector2.ZERO)
		for i in 4:
			var a = t * 0.8 + i * 1.57
			c.draw_circle(p + Vector2(cos(a) * 50, sin(a) * 18 - fmod(t * 30 + i * 20, 60)), 3, Color(0.8, 0.4, 1, 0.6))
	# 水
	for y in range(y0, y1 + 1):
		for x in range(x0, x1 + 1):
			var dpt = level - hmap[y * D.COLS + x]
			if dpt <= 0: continue
			var al = clampf(0.45 + dpt * 0.15, 0.45, 0.82)
			var edge = false
			for o in [Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1)]:
				var nx = clampi(x + o.x, 0, D.COLS - 1); var ny = clampi(y + o.y, 0, D.ROWS - 1)
				if level - hmap[ny * D.COLS + nx] <= 0: edge = true
			var wc = Color(0.16, 0.3, 0.42, al if not edge else al * 0.7)
			if edge: c.draw_circle(Vector2(x * C + 32, y * C + 32), C * 0.66, wc)
			else: c.draw_rect(Rect2(x * C, y * C, C + 1, C + 1), wc)
			if (x * 7 + y * 3) % 5 == 0: c.draw_line(Vector2(x * C + 8, y * C + 20 + sin(t + x) * 3), Vector2(x * C + 40, y * C + 20 + sin(t + x) * 3), Color(0.75, 0.88, 1, 0.22), 2)
			if (x + y) % 3 == 0:
				var w = fmod(t * 0.6 + x * 0.37 + y * 0.21, 1.0)
				c.draw_arc(Vector2(x * C + 32, y * C + 32), 6 + w * 16, 0, TAU, 12, Color(0.7, 0.85, 1.0, 0.4 * (1 - w)), 1.5)
	# 水閘
	_draw_gate(c)
	# Y 排序：道具、箱、靈魂、拖魂者、阿福、雜貨店、物品
	var L: Array = []
	for pr in props: if vr.has_point(Vector2(pr.x, pr.y)): L.append([pr.y, "prop", pr])
	for cc in caches: if vr.has_point(Vector2(cc.x * C, cc.y * C)): L.append([cc.y * C, "cache", cc])
	for id in souls:
		var s = souls[id]
		if s.state in ["home", "lost"]: continue
		L.append([s.y, "soul", s])
	for f in foes: L.append([f.y, "foe", f])
	for it in items: L.append([it.y, "item", it])
	for d in drops: L.append([d.y, "drop", d])
	L.append([A.y, "afu", A])
	L.append([shop_p().y + 20, "shop", null])
	L.sort_custom(func(a, b): return a[0] < b[0])
	for e in L:
		match e[1]:
			"prop": _draw_prop(c, e[2])
			"cache": _draw_cache(c, e[2])
			"soul": _draw_soul(c, e[2])
			"foe": _draw_foe(c, e[2])
			"item": _draw_item(c, e[2])
			"drop": c.draw_circle(Vector2(e[2].x, e[2].y - 6 - sin(t * 4) * 3), 7, Color(0.7, 0.4, 1, 0.9))
			"afu": _draw_afu(c)
			"shop": _draw_shop(c)
	# 特效
	for f in fx:
		var k = f.t / f.life
		match f.k:
			"slash":
				var arc = deg_to_rad(f.arc)
				c.draw_arc(Vector2(f.x, f.y), 34 + k * 20, f.a - arc / 2, f.a + arc / 2, 14, Color(1, 0.95, 0.8, 0.85 * (1 - k)), 6)
			"num":
				c.draw_string(PtGfx.font(900), Vector2(f.x - 10, f.y - k * 30), str(f.n), HORIZONTAL_ALIGNMENT_LEFT, -1, 18, Color(1, 0.9, 0.5, 1 - k))
			"bottle":
				var p = Vector2(f.ox, f.oy).lerp(Vector2(f.tx, f.ty), k) + Vector2(0, -sin(k * PI) * 80)
				c.draw_circle(p, 6, Color(0.6, 0.9, 0.7, 0.9))
			"splash":
				c.draw_circle(Vector2(f.x, f.y), 20 + k * 50, Color(0.6, 0.9, 1, 0.5 * (1 - k)))
			"poof":
				c.draw_circle(Vector2(f.x, f.y), 14 + k * 30, Color(0.6, 0.3, 0.8, 0.5 * (1 - k)))
			"dust":
				c.draw_circle(Vector2(f.x, f.y), 10 + k * 26, Color(0.8, 0.8, 0.8, 0.35 * (1 - k)))
	# 雨
	var vr2 = vr
	for i in 90:
		var rx = vr2.position.x + fmod(i * 97.3 + t * 40, vr2.size.x)
		var ry = vr2.position.y + fmod(i * 53.7 + t * 620, vr2.size.y)
		c.draw_line(Vector2(rx, ry), Vector2(rx - 3, ry + 16), Color(0.7, 0.8, 0.95, 0.28), 1.2)

func _tex_draw(c: CanvasItem, k: String, x: float, y: float, h: float, flip := false, col := Color.WHITE) -> void:
	var tx: Texture2D = PtGfx.tex(k)
	if tx == null: c.draw_circle(Vector2(x, y - h / 2), h / 3, col); return
	var w = h * tx.get_width() / tx.get_height()
	if flip:
		c.draw_set_transform(Vector2(x, y), 0, Vector2(-1, 1))
		c.draw_texture_rect(tx, Rect2(-w / 2, -h, w, h), false, col)
		c.draw_set_transform(Vector2.ZERO)
	else:
		c.draw_texture_rect(tx, Rect2(x - w / 2, y - h, w, h), false, col)

func _shadow(c: CanvasItem, x: float, y: float, rx: float) -> void:
	c.draw_set_transform(Vector2(x, y), 0, Vector2(1, 0.32))
	c.draw_circle(Vector2.ZERO, rx, Color(0, 0, 0, 0.35))
	c.draw_set_transform(Vector2.ZERO)

func _draw_prop(c: CanvasItem, pr: Dictionary) -> void:
	var sub = clampf((level - h_at(pr.x, pr.y)) * 18.0, 0.0, pr.h * 0.35)
	_shadow(c, pr.x, pr.y, pr.h * 0.28)
	_tex_draw(c, pr.k, pr.x, pr.y + sub, pr.h, false, Color(0.82, 0.85, 0.92))
	if pr.k == "pr_lamp":
		c.draw_circle(Vector2(pr.x, pr.y - pr.h + 8), 6 + sin(t * 3 + pr.x) * 1.5, Color(1, 0.85, 0.5, 0.9))

func _draw_cache(c: CanvasItem, cc: Dictionary) -> void:
	var x = cc.x * C; var y = cc.y * C
	_shadow(c, x, y, 22)
	_tex_draw(c, cc.k, x, y, 46.0, false, Color(0.5, 0.5, 0.55) if cc.done else Color(0.95, 0.92, 0.85))
	if not cc.done:
		var a = 0.5 + 0.5 * sin(t * 4 + x)
		c.draw_circle(Vector2(x + 18, y - 44), 5, Color(1, 0.9, 0.4, 0.5 + a * 0.4))

func _draw_gate(c: CanvasItem) -> void:
	var p = D.GATE * C
	c.draw_rect(Rect2(p.x - 60, p.y - 70, 14, 80), Color(0.35, 0.36, 0.38))
	c.draw_rect(Rect2(p.x + 46, p.y - 70, 14, 80), Color(0.35, 0.36, 0.38))
	var gh = 20.0 if gate_open else 64.0
	c.draw_rect(Rect2(p.x - 46, p.y - gh - 4 + (0 if gate_open else 4), 92, gh), Color(0.42, 0.3, 0.2) if not gate_open else Color(0.42, 0.3, 0.2, 0.5))
	c.draw_rect(Rect2(p.x - 64, p.y - 82, 128, 12), Color(0.3, 0.3, 0.32))
	var wc = p + Vector2(0, -96)
	var rot = t * 3.0 if held.has("ctx") and hold_k == "crank" else 0.0
	c.draw_arc(wc, 16, 0, TAU, 18, Color(0.6, 0.55, 0.5), 4)
	for i in 4: c.draw_line(wc, wc + Vector2(16, 0).rotated(rot + i * PI / 2), Color(0.6, 0.55, 0.5), 3)
	if hold_k == "crank" and held.has("ctx"):
		c.draw_arc(wc, 24, -PI / 2, -PI / 2 + TAU * hold_t / 3.5, 24, Color(1, 0.85, 0.4), 4)

func _draw_shop(c: CanvasItem) -> void:
	var p = shop_p()
	_shadow(c, p.x, p.y + 4, 80)
	_tex_draw(c, "store", p.x, p.y + 8, 150.0)
	_tex_draw(c, "npc_shop", p.x - 70, p.y + 14, 70.0, false)
	var fnt = PtGfx.font(900)
	var tw = fnt.get_string_size("雜貨店", HORIZONTAL_ALIGNMENT_LEFT, -1, 15).x + 16
	c.draw_rect(Rect2(p.x - tw / 2, p.y - 160, tw, 22), Color("#7a2a1c")); c.draw_rect(Rect2(p.x - tw / 2, p.y - 160, tw, 22), Color("#1a0c06"), false, 2)
	c.draw_string(fnt, Vector2(p.x - tw / 2 + 8, p.y - 143), "雜貨店", HORIZONTAL_ALIGNMENT_LEFT, -1, 15, Color("#f4e2b0"))

func _draw_item(c: CanvasItem, it: Dictionary) -> void:
	var p = Vector2(it.x, it.y - 14 - sin(t * 3 + it.x) * 4)
	c.draw_circle(p, 18, Color(1, 0.9, 0.5, 0.18 + 0.1 * sin(t * 5)))
	match it.item:
		"helmet":
			c.draw_circle(p, 11, Color("#c2332b")); c.draw_rect(Rect2(p.x - 12, p.y, 24, 5), Color("#2a2a2a"))
		"key":
			c.draw_circle(p + Vector2(-6, 0), 6, Color("#e6c25a")); c.draw_rect(Rect2(p.x - 1, p.y - 2, 14, 4), Color("#e6c25a")); c.draw_rect(Rect2(p.x + 9, p.y, 3, 6), Color("#e6c25a"))
		"shirt":
			var col = Color("#4a6fa5")
			c.draw_colored_polygon(PackedVector2Array([p + Vector2(-12, -8), p + Vector2(-5, -11), p + Vector2(5, -11), p + Vector2(12, -8), p + Vector2(9, -2), p + Vector2(6, -4), p + Vector2(6, 11), p + Vector2(-6, 11), p + Vector2(-6, -4), p + Vector2(-9, -2)]), col)

func _draw_afu(c: CanvasItem) -> void:
	if A.dead > 0:
		_tex_draw(c, "afu", A.x, A.y, 64.0, A.fx < 0, Color(1, 1, 1, A.dead / 2.2 * 0.6)); return
	var sub = clampf(depth(A.x, A.y) * 14.0, 0.0, 22.0)
	var bob = abs(sin(t * 10)) * 4.0 if A.get("moving", false) else sin(t * 2) * 1.5
	_shadow(c, A.x, A.y, 18)
	var col = Color(1, 0.6, 0.6) if A.hit > 0 else Color.WHITE
	_tex_draw(c, "afu", A.x, A.y + sub - bob, 64.0, A.fx < 0, col)
	# 武器
	var w = D.WPN[J.str(st.wpn)]
	var wt: Texture2D = PtGfx.tex(w.icon)
	if wt:
		var dir = 1.0 if A.fx >= 0 else -1.0
		var sw = A.sw / 0.22
		var ang = (-0.9 + (1.0 - sw) * 1.8) * dir if A.sw > 0 else 0.5 * dir
		var hp = Vector2(A.x + dir * 16, A.y - 26 + sub - bob)
		c.draw_set_transform(hp, ang, Vector2(dir, 1))
		var ws = 30.0
		c.draw_texture_rect(wt, Rect2(-4, -ws, ws * wt.get_width() / wt.get_height(), ws), false)
		c.draw_set_transform(Vector2.ZERO)
	if A.grab > 0:
		for i in 3: c.draw_line(Vector2(A.x - 10 + i * 10, A.y + 4), Vector2(A.x - 14 + i * 12, A.y + 20), Color(0.3, 0.5, 0.3, 0.9), 3)
	if A.light:
		c.draw_circle(Vector2(A.x + A.fx * 18, A.y - 30 + A.fy * 6), 4, Color(1, 1, 0.8))

func _draw_soul(c: CanvasItem, s: Dictionary) -> void:
	var a = 0.62 + 0.1 * sin(t * 2 + s.hx)
	var col = Color(0.72, 0.88, 1.0, a)
	var sub = clampf(depth(s.x, s.y) * 12.0, 0.0, 18.0)
	if s.state == "dragged":
		c.draw_set_transform(Vector2(s.x, s.y + sub), 0.5, Vector2.ONE)
		var tx: Texture2D = PtGfx.tex(s.d.spr)
		if tx:
			var w = 60.0 * tx.get_width() / tx.get_height()
			c.draw_texture_rect(tx, Rect2(-w / 2, -60, w, 60), false, Color(0.8, 0.6, 1, 0.75))
		c.draw_set_transform(Vector2.ZERO)
	else:
		_tex_draw(c, s.d.spr, s.x, s.y + sub, 62.0, false, col)
		# 滴水
		var dy = fmod(t * 40 + s.hx, 26)
		c.draw_circle(Vector2(s.x - 8, s.y - 30 + dy), 1.6, Color(0.6, 0.8, 1, 0.6))
	var fnt = PtGfx.font(900)
	if s.state == "idle":
		var p = Vector2(s.x, s.y - 80 - sin(t * 3) * 3)
		c.draw_circle(p, 10, Color("#f4e2b0")); c.draw_string(fnt, p + Vector2(-4, 5), "？", HORIZONTAL_ALIGNMENT_LEFT, -1, 13, Color("#5a2a8a"))
	if s.bub > 0 and s.has("say"):
		var txt = T(s.say)
		var fs = 13
		var tw = minf(fnt.get_string_size(txt, HORIZONTAL_ALIGNMENT_LEFT, -1, fs).x, 230.0)
		var lines = int(ceil(fnt.get_string_size(txt, HORIZONTAL_ALIGNMENT_LEFT, -1, fs).x / 230.0))
		var bh = 8 + lines * 17
		var r = Rect2(s.x - tw / 2 - 8, s.y - 96 - bh, tw + 16, bh)
		c.draw_rect(r, Color(0.96, 0.92, 0.82, 0.95)); c.draw_rect(r, Color(0.1, 0.05, 0.03), false, 1.5)
		c.draw_multiline_string(fnt, r.position + Vector2(8, 17), txt, HORIZONTAL_ALIGNMENT_LEFT, 230.0, fs, -1, Color(0.15, 0.08, 0.05))

func _draw_foe(c: CanvasItem, f: Dictionary) -> void:
	var d = f.d
	var sub = clampf(depth(f.x, f.y) * 14.0, 0.0, 26.0)
	var rise = f.rise / 0.6
	var col = Color(2, 2, 2) if f.hit > 0 else (Color(0.75, 0.7, 1.0) if f.stun > 0 else Color(0.85, 0.95, 0.85))
	if rise > 0: col.a = 1.0 - rise
	_shadow(c, f.x, f.y, d.h * 0.25)
	_tex_draw(c, d.spr, f.x, f.y + sub + rise * 30, d.h, f.fx < 0, col)
	if f.hp < f.mhp:
		var w = 44.0
		c.draw_rect(Rect2(f.x - w / 2, f.y - d.h - 10, w, 5), Color(0, 0, 0, 0.6))
		c.draw_rect(Rect2(f.x - w / 2, f.y - d.h - 10, w * maxf(0.0, f.hp / f.mhp), 5), Color(0.85, 0.25, 0.3))
	if f.k == "galah" and f.drag != null:
		c.draw_line(Vector2(f.x, f.y - d.h * 0.6), Vector2(f.drag.x, f.drag.y - 40), Color(0.2, 0.1, 0.2, 0.9), 4)

# ---------------- 畫：黑暗 ----------------
const DARK_SHADER := """
shader_type canvas_item;
uniform vec4 lights[16];
uniform int nl = 0;
uniform vec2 scr = vec2(450.0, 975.0);
uniform vec4 cone = vec4(0.0);
uniform vec2 cdir = vec2(1.0, 0.0);
uniform float darkness = 0.72;
uniform float flash = 0.0;
void fragment() {
	vec2 p = SCREEN_UV * scr;
	float lit = 0.0;
	for (int i = 0; i < 16; i++) {
		if (i >= nl) break;
		vec4 l = lights[i];
		float d = length(p - l.xy) / l.z;
		lit = max(lit, l.w * (1.0 - smoothstep(0.25, 1.0, d)));
	}
	if (cone.w > 0.0) {
		vec2 v = p - cone.xy;
		float dd = length(v);
		float ang = dot(normalize(v), cdir);
		float c = smoothstep(0.86, 0.93, ang) * (1.0 - smoothstep(cone.z * 0.6, cone.z, dd));
		lit = max(lit, c * 0.95);
	}
	float a = darkness * (1.0 - lit);
	COLOR = vec4(0.02, 0.02, 0.06, a * (1.0 - flash));
}
"""

func _w2s(p: Vector2) -> Vector2: return world.position + p * sc

func _upd_dark() -> void:
	var L: Array = []
	var ap = _w2s(Vector2(A.x, A.y - 30))
	L.append(Vector4(ap.x, ap.y, 175 * sc, 0.95))
	var sp = _w2s(shop_p() + Vector2(0, -20))
	L.append(Vector4(sp.x, sp.y, SHOP_R * 1.25 * sc, 1.0))
	var vr = _vis_rect()
	for pr in props:
		if pr.k == "pr_lamp" and vr.has_point(Vector2(pr.x, pr.y)):
			var lp = _w2s(Vector2(pr.x, pr.y - pr.h + 8)); L.append(Vector4(lp.x, lp.y, 120 * sc, 0.75))
	for r in D.RIFTS:
		if vr.grow(200).has_point(r * C):
			var rp = _w2s(r * C); L.append(Vector4(rp.x, rp.y, 110 * sc, 0.45))
	for id in souls:
		var s = souls[id]
		if s.state in ["home", "lost"]: continue
		if vr.has_point(Vector2(s.x, s.y)):
			var q = _w2s(Vector2(s.x, s.y - 30)); L.append(Vector4(q.x, q.y, 95 * sc, 0.75))
	for it in items:
		if vr.has_point(Vector2(it.x, it.y)):
			var q = _w2s(Vector2(it.x, it.y)); L.append(Vector4(q.x, q.y, 50 * sc, 0.6))
	while L.size() > 16: L.pop_back()
	var arr = PackedVector4Array()
	for l in L: arr.append(l)
	for i in range(L.size(), 16): arr.append(Vector4.ZERO)
	dark_mat.set_shader_parameter("lights", arr)
	dark_mat.set_shader_parameter("nl", L.size())
	dark_mat.set_shader_parameter("scr", size)
	var thunder = 0.0
	var ph = fmod(t, 23.0)
	if ph < 0.12 or (ph > 0.25 and ph < 0.32): thunder = 0.55
	dark_mat.set_shader_parameter("flash", thunder)
	if A.light and A.dead <= 0:
		dark_mat.set_shader_parameter("cone", Vector4(ap.x, ap.y, 300 * sc, 1.0))
		dark_mat.set_shader_parameter("cdir", Vector2(A.fx, A.fy).normalized())
	else:
		dark_mat.set_shader_parameter("cone", Vector4.ZERO)

# ---------------- 畫：介面 ----------------
func _draw_hud(c: CanvasItem) -> void:
	var fnt = PtGfx.font(900); var k = sc; var w = size.x
	# 頂欄
	c.draw_rect(Rect2(0, 0, w, 96 * k), Color(0.05, 0.03, 0.06, 0.72))
	var ym = ymax()
	c.draw_string(fnt, Vector2(12 * k, 26 * k), T(["陽氣", "陽氣"]), HORIZONTAL_ALIGNMENT_LEFT, -1, int(15 * k), Color("#f4e2b0"))
	var bw = 200 * k
	c.draw_rect(Rect2(56 * k, 12 * k, bw, 16 * k), Color(0, 0, 0, 0.6))
	var yc = Color("#e8b04a") if A.yang > 30 else Color("#d8423a")
	c.draw_rect(Rect2(56 * k, 12 * k, bw * clampf(A.yang / ym, 0, 1), 16 * k), yc)
	c.draw_string(fnt, Vector2(62 * k, 25 * k), "%d / %d" % [int(maxf(A.yang, 0)), int(ym)], HORIZONTAL_ALIGNMENT_LEFT, -1, int(12 * k), Color.WHITE)
	var mins = int(tt / D.NIGHT_SEC * 360.0)
	var hh = (23 + mins / 60) % 24; var mm = mins % 60
	c.draw_string(fnt, Vector2(w - 92 * k, 28 * k), "%02d:%02d" % [hh, mm], HORIZONTAL_ALIGNMENT_LEFT, -1, int(22 * k), Color("#f4e2b0"))
	c.draw_string(fnt, Vector2(12 * k, 52 * k), T(["水位", "水位"]), HORIZONTAL_ALIGNMENT_LEFT, -1, int(13 * k), Color("#9fc8e8"))
	c.draw_rect(Rect2(56 * k, 41 * k, bw, 10 * k), Color(0, 0, 0, 0.5))
	c.draw_rect(Rect2(56 * k, 41 * k, bw * clampf((level - D.L0) / (D.L1 - D.L0), 0, 1), 10 * k), Color("#3f7fb5"))
	if gate_open: c.draw_string(fnt, Vector2(262 * k, 51 * k), T(["閘已開", "閘已開"]), HORIZONTAL_ALIGNMENT_LEFT, -1, int(12 * k), Color("#9fdc9f"))
	var bt = []
	for m in ["wood", "iron", "cloth", "bottle", "bat", "ash"]:
		var n = int(have(m))
		if n > 0 or J.num(bag.get(m, 0)) > 0: bt.append("%s %d" % [T(D.MAT_NAME[m]), n])
	c.draw_string(fnt, Vector2(12 * k, 76 * k), "  ".join(bt) if bt.size() else T(["（乜都未搜到）", "（還沒搜到東西）"]), HORIZONTAL_ALIGNMENT_LEFT, w - 24 * k, int(12 * k), Color(0.85, 0.85, 0.85))
	if not bag.is_empty() and not in_shop(A.x, A.y):
		c.draw_string(fnt, Vector2(12 * k, 92 * k), T(["身上嘅嘢未存，返鋪頭先算數", "身上的東西未存，回店裡才算數"]), HORIZONTAL_ALIGNMENT_LEFT, -1, int(11 * k), Color("#e8b04a"))
	# 目標
	if objective != "":
		var tw = fnt.get_string_size(objective, HORIZONTAL_ALIGNMENT_LEFT, -1, int(14 * k)).x + 20 * k
		c.draw_rect(Rect2(w / 2 - tw / 2, 104 * k, tw, 26 * k), Color(0.1, 0.05, 0.02, 0.75))
		c.draw_string(fnt, Vector2(w / 2 - tw / 2 + 10 * k, 122 * k), objective, HORIZONTAL_ALIGNMENT_LEFT, -1, int(14 * k), Color("#f4e2b0"))
	# 訊息
	var my = 150 * k
	for m in msg_q:
		var a = clampf(3.2 - m.t, 0, 1)
		var tw = minf(fnt.get_string_size(m.m, HORIZONTAL_ALIGNMENT_LEFT, -1, int(14 * k)).x + 20 * k, w - 20 * k)
		c.draw_rect(Rect2(w / 2 - tw / 2, my, tw, 26 * k), Color(0, 0, 0, 0.6 * a))
		c.draw_string(fnt, Vector2(w / 2 - tw / 2 + 10 * k, my + 18 * k), m.m, HORIZONTAL_ALIGNMENT_LEFT, w - 40 * k, int(14 * k), Color(1, 1, 1, a))
		my += 30 * k
	# 方向指示：目標喺畫面外
	_draw_arrows(c)
	# 搖桿
	if joy != null:
		c.draw_circle(joy.o, 56 * k, Color(1, 1, 1, 0.08)); c.draw_arc(joy.o, 56 * k, 0, TAU, 32, Color(1, 1, 1, 0.3), 2)
		var kp = joy.o + (joy.p - joy.o).limit_length(56 * k)
		c.draw_circle(kp, 24 * k, Color(1, 1, 1, 0.35))
	# 掣
	var bs = _btns()
	var lab = {"atk": T(["打", "打"]), "bottle": T(["擲樽", "擲瓶"]) + " %d" % int(have("bottle")), "dash": T(["衝", "衝"]), "light": T(["電筒", "電筒"]), "home": T(["回店", "回店"])}
	var cx = ctx()
	if cx.has("n"): lab["ctx"] = cx.n
	for b in bs:
		var p = bs[b][0]; var r = bs[b][1]
		var on = held.has(b) or (b == "light" and A.light)
		var col = Color(0.12, 0.06, 0.04, 0.72) if not on else Color(0.55, 0.32, 0.12, 0.85)
		if b == "ctx": col = Color(0.45, 0.22, 0.08, 0.9)
		c.draw_circle(p, r, col)
		c.draw_arc(p, r, 0, TAU, 32, Color("#f4e2b0"), 2.0 * k)
		var fs = int((20 if b == "atk" else 14) * k)
		var lt = lab.get(b, "")
		var tw = fnt.get_string_size(lt, HORIZONTAL_ALIGNMENT_LEFT, -1, fs).x
		c.draw_string(fnt, p + Vector2(-tw / 2, fs * 0.35), lt, HORIZONTAL_ALIGNMENT_LEFT, -1, fs, Color("#f4e2b0"))
		if b == "dash" and A.dcd > 0: c.draw_arc(p, r - 4 * k, -PI / 2, -PI / 2 + TAU * (1 - A.dcd / 1.6), 24, Color(1, 1, 1, 0.5), 3)
		if b == "atk" and A.cd > 0: c.draw_arc(p, r - 5 * k, -PI / 2, -PI / 2 + TAU * (1 - A.cd / wpn().cd), 24, Color(1, 1, 1, 0.4), 4)
		if b == "light" and A.light: c.draw_arc(p, r + 4 * k, -PI / 2, -PI / 2 + TAU * clampf(A.batt / 25.0, 0, 1), 24, Color(1, 1, 0.6), 3)
		if (b == "ctx" or b == "home") and hold_t > 0 and ((b == "home" and hold_k == "home") or (b == "ctx" and hold_k != "home" and hold_k != "home_x")):
			var tot = 3.0 if b == "home" else J.num(cx.get("hold", 1.0))
			c.draw_arc(p, r + 5 * k, -PI / 2, -PI / 2 + TAU * clampf(hold_t / tot, 0, 1), 32, Color(1, 0.85, 0.4), 4 * k)
	if A.dead > 0:
		c.draw_rect(Rect2(Vector2.ZERO, size), Color(0, 0, 0, 0.5))
		var m = T(["陽氣散晒……", "陽氣散盡……"])
		var tw2 = fnt.get_string_size(m, HORIZONTAL_ALIGNMENT_LEFT, -1, int(26 * k)).x
		c.draw_string(fnt, Vector2(w / 2 - tw2 / 2, size.y / 2), m, HORIZONTAL_ALIGNMENT_LEFT, -1, int(26 * k), Color("#d8423a"))

func _draw_arrows(c: CanvasItem) -> void:
	var tgs: Array = []
	for id in souls:
		var s = souls[id]
		if s.state == "follow": tgs.append([shop_p(), Color("#f4e2b0")])
		elif s.state == "dragged": tgs.append([Vector2(s.x, s.y), Color("#d8423a")])
		elif s.state == "met":
			var tk = s.d.task
			match tk.t:
				"fetch": tgs.append([tk.at * C if not inv.has(tk.item) else Vector2(s.x, s.y), Color("#9fdcff")])
				"fetch_then_crank": tgs.append([tk.at * C if not inv.has("key") and not gate_open else (D.GATE * C if not gate_open else Vector2(s.x, s.y)), Color("#9fdcff")])
				"collect":
					if J.num(inv.get("shirt", 0)) >= 3: tgs.append([Vector2(s.x, s.y), Color("#9fdcff")])
					else:
						for it in items: if it.item == "shirt": tgs.append([Vector2(it.x, it.y), Color("#9fdcff")])
	var ctr = size / 2; var m = 40 * sc
	for tg in tgs:
		var sp = _w2s(tg[0])
		if Rect2(Vector2(m, 110 * sc), size - Vector2(m * 2, 110 * sc + 300 * sc)).has_point(sp): continue
		var d = (sp - ctr).normalized()
		var e = ctr + d * minf(size.x, size.y) * 0.42
		e.x = clampf(e.x, m, size.x - m); e.y = clampf(e.y, 120 * sc, size.y - 320 * sc)
		var a = d.angle()
		var pts = PackedVector2Array([e + Vector2(16, 0).rotated(a) * sc, e + Vector2(-8, 9).rotated(a) * sc, e + Vector2(-8, -9).rotated(a) * sc])
		c.draw_colored_polygon(pts, tg[1])

# ---------------- 雜貨店介面 ----------------
func _panel(title: String) -> VBoxContainer:
	if menu != null: menu.queue_free()
	var root = Control.new(); root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); add_child(root); menu = root
	var bg = ColorRect.new(); bg.color = Color(0, 0, 0, 0.7); bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); root.add_child(bg)
	var pc = PanelContainer.new(); root.add_child(pc)
	var sb = StyleBoxFlat.new(); sb.bg_color = Color("#2a1a12"); sb.border_color = Color("#c89a5a"); sb.set_border_width_all(2); sb.set_corner_radius_all(10); sb.set_content_margin_all(14)
	pc.add_theme_stylebox_override("panel", sb)
	pc.position = Vector2(16, 110) * sc; pc.size = Vector2(418, 0) * sc; pc.custom_minimum_size = Vector2(418 * sc, 0)
	var sc2 = ScrollContainer.new(); sc2.custom_minimum_size = Vector2(390 * sc, 640 * sc); sc2.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED; pc.add_child(sc2)
	var vb = VBoxContainer.new(); vb.size_flags_horizontal = Control.SIZE_EXPAND_FILL; vb.add_theme_constant_override("separation", int(8 * sc)); sc2.add_child(vb)
	_lab(vb, title, 22, Color("#f4e2b0"))
	return vb

func _lab(p: Control, s: String, fs := 15, col := Color(0.9, 0.88, 0.82)) -> Label:
	var l = Label.new(); l.text = s; l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	l.add_theme_font_override("font", PtGfx.font(900)); l.add_theme_font_size_override("font_size", int(fs * sc)); l.add_theme_color_override("font_color", col)
	p.add_child(l); return l

func _btn(p: Control, s: String, f: Callable, on := true) -> Button:
	var b = Button.new(); b.text = s; b.disabled = not on; b.focus_mode = Control.FOCUS_NONE
	b.add_theme_font_override("font", PtGfx.font(900)); b.add_theme_font_size_override("font_size", int(16 * sc))
	b.custom_minimum_size = Vector2(0, 46 * sc)
	b.pressed.connect(func(): Snd.play("click"); f.call())
	p.add_child(b); return b

func _cost_s(cst: Dictionary) -> String:
	var a = []
	for k in cst: a.append("%s %d" % [T(D.MAT_NAME[k]), int(cst[k])])
	return "、".join(a)
func _can(cst: Dictionary) -> bool:
	for k in cst: if J.num(st.mats.get(k, 0)) < cst[k]: return false
	return true
func _pay(cst: Dictionary) -> void:
	for k in cst: st.mats[k] = J.num(st.mats.get(k, 0)) - cst[k]

func open_shop() -> void:
	_bank()
	var vb = _panel(T(["村口雜貨店", "村口雜貨店"]))
	_lab(vb, T(["「條村停咗喺嗰一晚。有燈嘅地方，佢哋唔敢入嚟。」", "「村子停在了那一晚。有燈的地方，它們不敢進來。」"]), 14, Color(0.75, 0.7, 0.62))
	var ms = []
	for m in ["wood", "iron", "cloth", "bottle", "bat", "ash"]: ms.append("%s %d" % [T(D.MAT_NAME[m]), int(J.num(st.mats.get(m, 0)))])
	_lab(vb, T(["倉存：", "倉存："]) + "  ".join(ms), 14)
	_lab(vb, T(["— 武器 —", "— 武器 —"]), 17, Color("#e8b04a"))
	for id in D.WPN:
		var w = D.WPN[id]; var own = J.t(st.own.get(id)); var lv = int(J.num(st.wlv.get(id, 0)))
		_lab(vb, "%s  Lv%d　%s" % [T(w.n), lv, T(w.d)], 15, Color(0.95, 0.92, 0.85))
		var hb = HBoxContainer.new(); hb.add_theme_constant_override("separation", int(8 * sc)); vb.add_child(hb)
		if not own:
			var cst = D.WPN_UNLOCK[id]
			_btn(hb, T(["造（", "造（"]) + _cost_s(cst) + "）", func(): _pay(cst); st.own[id] = true; open_shop(), _can(cst))
		else:
			if J.str(st.wpn) != id: _btn(hb, T(["用", "用"]), func(): st.wpn = id; open_shop())
			else: _btn(hb, T(["使用中", "使用中"]), func(): pass, false)
			if lv < 5:
				var uc = D.up_cost(lv)
				_btn(hb, T(["升級", "升級"]), func(): _pay(uc); st.wlv[id] = lv + 1; Snd.play("craft"); open_shop(), _can(uc))
		if own and lv < 5: _lab(vb, "    " + T(["升級要：", "升級需要："]) + _cost_s(D.up_cost(lv)), 12, Color(0.65, 0.62, 0.55))
	_lab(vb, T(["— 打造 —", "— 打造 —"]), 17, Color("#e8b04a"))
	var bc = {"cloth": 1.0, "wood": 1.0}
	_btn(vb, T(["包好玻璃樽 ×2（", "包好玻璃瓶 ×2（"]) + _cost_s(bc) + "）", func(): _pay(bc); st.mats.bottle = J.num(st.mats.get("bottle", 0)) + 2; Snd.play("craft"); open_shop(), _can(bc))
	var tc = {"iron": 2.0}
	_btn(vb, T(["駁電芯 ×1（", "接電池 ×1（"]) + _cost_s(tc) + "）", func(): _pay(tc); st.mats.bat = J.num(st.mats.get("bat", 0)) + 1; Snd.play("craft"); open_shop(), _can(tc))
	_lab(vb, T(["— 救返嚟嘅人 —", "— 救回來的人 —"]), 17, Color("#e8b04a"))
	var any = false
	for id in D.SOULS:
		var d = D.SOULS[id]
		if st.souls.has(id):
			any = true
			_lab(vb, "%s：%s" % [d.name, T(["醒返陽間", "醒回陽間"]) if J.str(st.souls[id]) == "wake" else T(d.perk)], 14)
		elif st.lost.has(id):
			any = true
			_lab(vb, "%s：%s" % [d.name, T(["俾拖咗落冥界牢（之後可以去救）", "被拖進了冥界牢（之後可以去救）"])], 14, Color("#d8423a"))
	if not any: _lab(vb, T(["未有。", "還沒有。"]), 14)
	_btn(vb, T(["出發", "出發"]), func(): menu.queue_free(); menu = null)
	_btn(vb, T(["收工返村（今晚進度唔留）", "收工回村（今晚進度不保留）"]), func(): close_mode())

func _end_panel(saved: Array, lost: Array) -> void:
	var vb = _panel(T(["天光喇", "天亮了"]))
	_lab(vb, T(["水退咗少少。條村又停返喺嗰一晚。", "水退了一點。村子又停回那一晚。"]), 15)
	_lab(vb, T(["救返：", "救回："]) + ("、".join(saved) if saved.size() else T(["冇", "沒有"])), 15)
	if lost.size(): _lab(vb, T(["俾拖走：", "被拖走："]) + "、".join(lost), 15, Color("#d8423a"))
	_btn(vb, T(["再落一晚", "再來一晚"]), func(): menu.queue_free(); menu = null; _new_night())
	_btn(vb, T(["收工返村", "收工回村"]), func(): close_mode())

# ---------------- 測試用 ----------------
func t_tp(cx: float, cy: float) -> void: A.x = cx * C; A.y = cy * C; cam = Vector2(A.x, A.y)
func t_god() -> void: A.yang = 9999.0
