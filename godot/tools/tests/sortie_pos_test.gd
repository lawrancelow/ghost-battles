# [sortiepos] 出擊起點測試：主角喺大排檔撳出擊 → 主角由自己個位出發（唔係由村口再行一次），地圖上主角只得一個；打完／叫回行返出發點
# 用法：/home/claude/setup/edtest.sh <godot目錄> spos res://tools/tests/sortie_pos_test.gd logic
extends RefCounted

var ok := 0
var bad := 0
const ZD = preload("res://game/zone/zone_data.gd")
const RTS = preload("res://game/rts/rts.gd")
const SO = preload("res://game/sortie/so_data.gd")
const AW = preload("res://game/sortie/so_away.gd")
const SHOTS := "/home/claude/docs/sortie_pos_shots/"
const T0 = preload("res://tools/tests/sortie_test.gd")

func _p(m): print("[spos] ", m)
func _chk(name: String, cond: bool, extra = "") -> void:
	if cond: ok += 1; _p("ok  " + name + ("　" + str(extra) if str(extra) != "" else ""))
	else: bad += 1; _p("BAD " + name + ("　" + str(extra) if str(extra) != "" else ""))
func _w(t, s: float): await t.get_tree().create_timer(s).timeout
func _hero() -> Dictionary: return J.G.Village.hero
func _set_hero(p: Vector2) -> void:
	var H = _hero(); H["x"] = p.x; H["y"] = p.y; H["tx"] = p.x; H["ty"] = p.y; H["walking"] = false; H["target"] = null; H["act"] = null
func _afu(op) -> Array:
	var o = []
	for u in op.units: if J.num(u.get("side")) == 0 and not J.t(u.get("minion")) and J.str(u.get("k")) == "afu": o.append(u)
	return o
func _shot(t, name: String) -> void:
	await RenderingServer.frame_post_draw
	t.get_viewport().get_texture().get_image().save_png(SHOTS + name + ".png"); _p("shot " + name)

func logic(t) -> void:
	DirAccess.make_dir_recursive_absolute(SHOTS)
	var T = T0.new()
	var m = await T._boot(t)
	await T._prep(t, m)
	SO.force_open = true; SO.test_now = 1000000.0
	T._rich()
	var S = J.G.S
	var hid = S.ghosts[0].id
	if not S.team.has(hid): S.team[0] = hid
	_chk("隊伍有主角", J.str(S.ghosts[0].k) == "afu", S.ghosts[0].k)
	var gate = RTS.gate_pos()
	var mk = ZD.zrect("market").get_center() if ZD.zrect("market").size.x > 0 else gate + Vector2(0, -260)
	_chk("座標一致：村口同大排檔距離合理", gate.distance_to(mk) < 2500.0, "%s %s" % [gate, mk])
	# ---- 1. 主角喺大排檔出擊 ----
	_set_hero(mk)
	await _w(t, 0.3)
	var e = SO.camps()[0]
	var r = SO.dispatch(e)
	var op = RTS.op_for(SO.sid_of(e))
	_chk("出擊成功", op != null, r)
	if op == null: _p("RESULT ok=%d bad=%d" % [ok, bad]); return
	var hs = _afu(op)
	_chk("出擊隊只有一個主角", hs.size() == 1, hs.size())
	var h = hs[0] if hs.size() else {}
	_chk("主角起點＝佢而家個位（大排檔）", (h.get("p", Vector2.ZERO) as Vector2).distance_to(mk) < 3.0, h.get("p"))
	_chk("主角有引路去會合點", h.has("pre"))
	await t.get_tree().process_frame
	_chk("村入面唔再畫主角（地圖上只得一個）", AW.hero_out())
	m.village.zone_cam().center_on(mk); await _w(t, 0.6)
	await _shot(t, "a_depart_from_market")
	var path0: Vector2 = op.path[0]
	var max_near_gate = INF
	for i in 30:
		RTS._last_f = -1; RTS.tick(0.1)
		if h.get("p") is Vector2: max_near_gate = minf(max_near_gate, (h.p as Vector2).distance_to(path0))
	_chk("主角冇由村口行出嚟（3 秒內離村口起點都遠）", max_near_gate > 60.0 or mk.distance_to(path0) < 60.0, "%.0f" % max_near_gate)
	await _shot(t, "b_marching")
	# 陰兵照由村出
	var yin_start_ok = false
	for u in op.units:
		if J.num(u.get("side")) == 0 and J.t(u.get("minion")) and (u.p as Vector2).distance_to(path0) < 400.0: yin_start_ok = true
	_chk("陰兵由村口／兵營出發", yin_start_ok)
	# 打完：行返出發點，村入面主角喺嗰度
	T._weak_foes(op); T._ff(op, ["back", "done"]); T._ff(op, ["done"], 400.0)
	_chk("打完收隊", op.phase == "done", op.phase)
	var hp = Vector2(J.num(_hero().x), J.num(_hero().y))
	_chk("村入面主角喺出發嗰度（大排檔），唔會閃去村口", hp.distance_to(mk) < 6.0, hp)
	await t.get_tree().process_frame
	_chk("收隊後主角重新畫返", not AW.hero_out())
	# ---- 2. 行軍中叫回：行返出發點 ----
	_set_hero(mk + Vector2(40, 30))
	S.res["buns"] = 5000.0; S.res["coins"] = 100000.0
	var e2 = SO.camps()[mini(1, SO.camps().size() - 1)]
	SO.dispatch(e2)
	var op2 = RTS.op_for(SO.sid_of(e2))
	if op2 != null:
		for i in 10: RTS._last_f = -1; RTS.tick(0.1)
		RTS.recall(op2); T._ff(op2, ["done"], 200.0)
		hp = Vector2(J.num(_hero().x), J.num(_hero().y))
		_chk("叫回：主角行返出發點", hp.distance_to(mk + Vector2(40, 30)) < 6.0, hp)
		_chk("叫回：只得一個主角", _afu(op2).size() == 1)
	else: _chk("第二次出擊", false, "op null")
	# ---- 3. 主角喺村口：照舊（冇引路） ----
	_set_hero(path0)
	S.res["buns"] = 5000.0; S.res["coins"] = 100000.0
	SO.dispatch(e)
	var op3 = RTS.op_for(SO.sid_of(e))
	if op3 != null:
		var h3 = _afu(op3)
		_chk("主角喺村口：唔使引路", h3.size() == 1 and not h3[0].has("pre"))
		RTS.recall(op3); T._ff(op3, ["done"], 200.0)
	_p("RESULT ok=%d bad=%d" % [ok, bad])
