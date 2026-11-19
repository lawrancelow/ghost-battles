# 移動村「假場景」（整合線用嚟做接駁同測試；引擎線 game/outpost/mv_scene.gd 交貨之後 main 會自動用真嘅）
# API 同合約一樣：setup(main)、on_show()、on_hide()、mv_state()、ci()、can_move()、move_next()、offline_gain(ms)
# 狀態：S.mv = {ci, st:{sid:{lv, unlocked, workers:[gid...]}}, goals_done:[], cash_till}；收入入 S.res.coins
# 冇 class_name（熱更新規矩）
extends Control

const FALLBACK := {
	"steamer": {"n": ["蒸籠台", "蒸籠台"], "unlock_cost": 0, "up_cost0": 20, "up_mul": 1.12, "price": 3},
	"coffin": {"n": ["棺材板工場", "棺材板工場"], "unlock_cost": 60, "up_cost0": 30, "up_mul": 1.12, "price": 5},
	"guard": {"n": ["守夜台", "守夜台"], "unlock_cost": 150, "up_cost0": 45, "up_mul": 1.12, "price": 4},
}
const B := preload("res://game/outpost/mv_bridge.gd")

var main = null
var box: VBoxContainer
var head: Label
var info: Label
var move_btn: Button
var _t := 0.0
var shown := false

func setup(m) -> void:
	main = m
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	clip_contents = true
	var bg = ColorRect.new(); bg.color = Color("#1c1622"); bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); bg.mouse_filter = Control.MOUSE_FILTER_IGNORE; add_child(bg)
	var sc = ScrollContainer.new(); sc.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); sc.offset_left = 12; sc.offset_right = -12; sc.offset_top = 10; sc.offset_bottom = -8
	sc.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED; add_child(sc)
	box = VBoxContainer.new(); box.size_flags_horizontal = Control.SIZE_EXPAND_FILL; box.add_theme_constant_override("separation", 8); sc.add_child(box)
	_render()

func _lbl(t: String, fs := 15, col := Color("#f3e6c8")) -> Label:
	var l = Label.new(); l.text = t; l.add_theme_font_size_override("font_size", fs); l.add_theme_color_override("font_color", col)
	l.autowrap_mode = TextServer.AUTOWRAP_ARBITRARY; l.size_flags_horizontal = Control.SIZE_EXPAND_FILL; return l
func _btn(t: String, f: Callable, ok := true) -> Button:
	var b = Button.new(); b.text = t; b.custom_minimum_size = Vector2(96, 40); b.add_theme_font_size_override("font_size", 15); b.disabled = not ok; b.pressed.connect(f); return b

# ---------------- 狀態 ----------------
func mv_state() -> Dictionary:
	var s = B.S()
	if s == null: return {}
	B._ensure_mv(s)
	return s.mv
func ci() -> int: return int(J.num(mv_state().get("ci", 0)))
func sids() -> Array:
	var M = B.od().get("MAPS", [])
	var c = ci()
	if M is Array and c < M.size() and M[c].get("stations") is Array and M[c].stations.size() > 0: return M[c].stations
	return FALLBACK.keys()
func sdef(sid: String) -> Dictionary:
	var d = load("res://game/outpost/mv_data.gd").st_def(sid)
	return d if not d.is_empty() else FALLBACK.get(sid, {"n": [sid, sid], "unlock_cost": 0, "up_cost0": 20, "up_mul": 1.12, "price": 3})
func ent(sid: String) -> Dictionary:
	var st = mv_state().st
	if not (st.get(sid) is Dictionary):
		var free = J.num(sdef(sid).get("unlock_cost", 0)) <= 0
		st[sid] = {"lv": 1.0 if free else 0.0, "unlocked": free, "workers": []}
	return st[sid]
func up_cost(sid: String) -> float:
	var d = sdef(sid); var e = ent(sid)
	return round(J.num(d.get("up_cost0", 20)) * pow(J.num(d.get("up_mul", 1.12)), J.num(e.lv) - 1) * (1.0 + 0.5 * ci()))
func income_ps() -> float:
	var t = 0.0
	for sid in sids():
		var e = ent(sid)
		if J.t(e.unlocked): t += J.num(e.lv) * 0.08 * J.num(sdef(sid).get("price", 3)) * (1.0 + 0.3 * e.workers.size())
	return t * (1.0 + 0.3 * ci())
func goals() -> Array:   # 假目標：開齊所有台
	var o = []
	for sid in sids(): o.append({"sid": sid, "ok": J.t(ent(sid).unlocked)})
	return o
func goals_ok() -> bool:
	for g in goals(): if not g.ok: return false
	return true
func can_move() -> bool:
	return goals_ok() and B.cleared(ci()) and ci() < B.maps_n() - 1
func move_next() -> bool:
	if not can_move(): return false
	var m = mv_state()
	for sid in m.st:   # 放返員工
		for gid in (m.st[sid].get("workers", []) as Array):
			var gh = B.ghost(gid)
			if gh != null and J.seq(gh.get("post"), "mv"): gh["post"] = null
	m["ci"] = float(ci() + 1); m["st"] = {}; m["goals_done"] = []
	var gr = B.garrison()
	if gr != null: gr.tick()
	J.cl(J.G.get("save"), null, [])
	_render(); return true
func offline_gain(ms: float) -> void:
	var s = B.S()
	if s == null: return
	s.res["coins"] = J.num(s.res.get("coins")) + income_ps() * ms / 1000.0 * 0.5

# ---------------- 畫面 ----------------
func on_show() -> void: shown = true; _render()
func on_hide() -> void: shown = false

func _process(dt: float) -> void:
	var s = B.S()
	if s == null or not J.t(s.get("mv_on")): return
	var B2 = J.G.get("Battle")
	if B2 is Dictionary and J.t(B2.get("active")): pass
	s.res["coins"] = J.num(s.res.get("coins")) + income_ps() * dt
	_t += dt
	if _t > 0.5 and shown and is_visible_in_tree(): _t = 0; _render_info()

func _render_info() -> void:
	if info == null: return
	info.text = "冥幣 %d　每秒收入 %.1f" % [int(J.num(B.S().res.coins)), income_ps()]

func _render() -> void:
	if box == null or B.S() == null: return
	for c in box.get_children(): box.remove_child(c); c.queue_free()
	var c = ci()
	head = _lbl("出殯巡遊大排檔・%s（%d/%d）" % [B.map_name(c), c + 1, B.maps_n()], 18, Color("#ffd884")); box.add_child(head)
	info = _lbl("", 15); box.add_child(info); _render_info()
	var g_ok = 0
	for g in goals(): if g.ok: g_ok += 1
	box.add_child(_lbl("目標：開齊所有生產台 %d/%d　＋　打低呢張圖嘅主線 Boss %s" % [g_ok, goals().size(), "✓" if B.cleared(c) else "✗"], 14, Color("#d8ccb8")))
	for sid in sids():
		var d = sdef(sid); var e = ent(sid); var nm = str(d.n[0] if DB.lang == "yue" else d.n[1]) if d.get("n") is Array else sid
		var hb = HBoxContainer.new(); hb.add_theme_constant_override("separation", 6); box.add_child(hb)
		var role = ""   # [integ] bridge 已冇角色估算
		var feeds = {"buns": "　→壽包", "planks": "　→棺材板", "troops": "　→陰兵"}.get(role, "")
		hb.add_child(_lbl("%s Lv%d　員工 %d%s" % [nm, int(J.num(e.lv)), e.workers.size(), feeds], 15))
		var sid2: String = sid
		if not J.t(e.unlocked):
			var uc = J.num(d.get("unlock_cost", 0))
			hb.add_child(_btn("解鎖 %d" % int(uc), func(): _pay_unlock(sid2, uc), J.num(B.S().res.coins) >= uc))
		else:
			var cost = up_cost(sid)
			hb.add_child(_btn("升級 %d" % int(cost), func(): _pay_up(sid2, cost), J.num(B.S().res.coins) >= cost))
			hb.add_child(_btn("派鬼", func(): _hire(sid2), e.workers.size() < 3))
	move_btn = _btn("拔營去下一張圖", func(): move_next(), can_move()); box.add_child(move_btn)

func _pay_unlock(sid: String, c: float) -> void:
	var s = B.S()
	if J.num(s.res.coins) < c: return
	s.res["coins"] = J.num(s.res.coins) - c; var e = ent(sid); e["unlocked"] = true; e["lv"] = 1.0; B.sync(); _render()
func _pay_up(sid: String, c: float) -> void:
	var s = B.S()
	if J.num(s.res.coins) < c: return
	s.res["coins"] = J.num(s.res.coins) - c; var e = ent(sid); e["lv"] = J.num(e.lv) + 1; B.sync(); _render()
func _hire(sid: String) -> void:
	var s = B.S()
	for gh in s.ghosts:
		if J.seq(gh.get("k"), "afu") or gh.get("post") != null: continue
		gh["post"] = "mv"; ent(sid).workers.append(gh.id); B.sync(); _render(); return
	J.mc(J.G.get("Fx"), "toast", ["冇閒住嘅鬼可以派。"])
