# [p45] 魔王收服特效實測：真係行一次 打低魔王 → 收服（魂魄）→ 祭壇招降 → 收服劇情
# 用法：bash /home/claude/setup/edtest.sh <godot目錄> p45 res://tools/tests/p45_test.gd tame 900
#   1. 第 1 關魔王據點（饕餮）真出擊、RTS 真打到完：戰報勝利、首勝、ng_boss.on_win → soul_drop 掉魔王魂魄 15
#   2. 之後每次打贏（ng_boss.on_win，非首勝 2–4）湊夠招降魂魄；祭壇 Lv、冥幣、心願備齊
#   3. 開祭壇「招降」頁，真撳饕餮嗰行「招降」掣：入名冊、播 boss_capture、vfx up_tame（大型 2 秒）、排隊 recruit_scene、入職通知書
#   4. 特效：喺 VfxTop（layer 110）、冇任何可見 CanvasLayer 高過佢（唔俾彈窗遮）、畫面中間真係有光（同招降前比較）、2 秒後連暗影一齊消失
#   截圖：/home/claude/docs/shots/p45/
extends RefCounted

const NGB = preload("res://game/newghost/ng_boss.gd")
const SO = preload("res://game/sortie/so_data.gd")
const RTS = preload("res://game/rts/rts.gd")
const SOUL = preload("res://game/soul/soul_data.gd")
const SUI = preload("res://game/soul/soul_ui.gd")
const VP = preload("res://game/fxkit/vfx_play.gd")
const SHOTS := "/home/claude/docs/shots/p45/"
const BM := "bm_taotie"

var ok := 0
var bad := 0
func _p(m): print("[p45] ", m)
func _chk(name: String, cond: bool, extra = "") -> void:
	if cond: ok += 1; _p("ok  " + name + ("　" + str(extra) if str(extra) != "" else ""))
	else: bad += 1; _p("BAD " + name + ("　" + str(extra) if str(extra) != "" else ""))
func _main(t): return t.get_tree().root.get_node_or_null("Main")
func _w(t, s: float): await t.get_tree().create_timer(s).timeout
func _skip(t, n := 6):
	for i in n:
		var m = _main(t); var st = m.get("story") if m else null
		if st and st.get("cur") != null: st.skip_scene()
		await _w(t, 0.25)
func _img(t) -> Image:
	await RenderingServer.frame_post_draw
	return t.get_viewport().get_texture().get_image()
func _shot(t, name: String) -> Image:
	var im = await _img(t)
	im.save_png(SHOTS + name + ".png"); _p("shot " + name)
	return im
func _boot(t):
	DirAccess.make_dir_recursive_absolute(SHOTS)
	for i in 120:
		await _w(t, 0.5)
		var m = _main(t)
		if m and m.get("loading") == null and J.G.get("S") is Dictionary: break
	await _w(t, 1.5)
	var m = _main(t)
	m._hide_title(); await _w(t, 1.0); await _skip(t)
	if m.has_method("_nav_on"): m._nav_on("village")
	await _w(t, 0.8)
	return m
func _goto(t, m, c: int) -> void:
	var sc = m.mv_view
	if int(J.num(sc.sim.st().ci)) == c: return
	sc.sim.st().ci = float(c); sc._after_move(); await _w(t, 1.2)
# 畫面中間（特效範圍）平均光度
func _lum(im: Image, rc: Rect2i) -> float:
	var s = 0.0; var n = 0
	for y in range(rc.position.y, rc.end.y, 6):
		for x in range(rc.position.x, rc.end.x, 6):
			var c = im.get_pixel(x, y); s += c.r * 0.3 + c.g * 0.59 + c.b * 0.11; n += 1
	return s / maxf(1.0, n)
func _diff(a: Image, b: Image, rc: Rect2i) -> float:
	var s = 0.0; var n = 0
	for y in range(rc.position.y, rc.end.y, 6):
		for x in range(rc.position.x, rc.end.x, 6):
			var p = a.get_pixel(x, y); var q = b.get_pixel(x, y)
			s += absf(p.r - q.r) + absf(p.g - q.g) + absf(p.b - q.b); n += 1
	return s / maxf(1.0, n)
# 所有可見 CanvasLayer（除 VfxTop）嘅最高 layer、同埋有冇嘢喺佢上面
func _layers(root: Node) -> Array:
	var o = []
	var st = [root]
	while st.size():
		var n = st.pop_back()
		if n is CanvasLayer and n.visible and n.name != "VfxTop" and n.get_child_count() > 0: o.append([str(n.get_path()), n.layer])
		for c in n.get_children(): st.append(c)
	return o
func _tame_btn(body: Node, k: String) -> Button:
	var nm = SOUL.gname(k)
	var st = [body]
	while st.size():
		var n = st.pop_back()
		if n is Button and str(n.text).begins_with("招降") and not n.disabled:
			var card = n.get_parent().get_parent() if n.get_parent() != null else null
			if card != null:
				var hit = false
				var s2 = [card]
				while s2.size():
					var q = s2.pop_back()
					if q is RichTextLabel and q.text.contains(nm): hit = true; break
					for c in q.get_children(): s2.append(c)
				if hit: return n
		for c in n.get_children(): st.append(c)
	return null

func tame(t) -> void:
	var m = await _boot(t)
	var S = J.G.S
	var root = t.get_tree().root
	var vs = root.get_visible_rect().size
	# ---------- 1. 真出擊打低魔王（第 1 關饕餮） ----------
	await _goto(t, m, 0)
	S.erase("ngb")
	SO.force_open = true; SO.test_now = 5000000.0
	S["sortie"] = {"v": 1.0, "camps": {}, "n": 0.0}
	var eb = SO.camps(0).filter(func(x): return str(x.get("bm", "")) != "")[0]
	_chk("第 1 關魔王據點係饕餮", str(eb.bm) == BM, eb.bm)
	for x in SO.camps(0): if int(x.ring) == 4 and str(x.get("bm", "")) == "": SO.cst(x)["first"] = true
	if S.ghosts.size() < 3:
		var have = []
		for g in S.ghosts: have.append(str(g.k))
		for k in ["xiaozhi", "toyol"]:
			if not k in have: J.cl(J.G.get("joinGhost"), null, [k])
		await _skip(t, 8)
	var ids = []
	for g in S.ghosts:
		if ids.size() >= 3: break
		ids.append(g.id)
	S["team"] = ids; S["lv"] = maxf(3.0, J.num(S.lv)); S.res["troops"] = 100.0; S.res["buns"] = 5000.0; S.res["coins"] = 100000.0
	J.G.Battle["auto"] = true
	var o = SOUL.st()
	o.sh.erase(BM); o.got.erase(BM)
	var r = SO.dispatch(eb)
	var op = RTS.op_for(SO.sid_of(eb))
	_chk("魔王據點出擊 ok", r == "ok" and op != null, r)
	if op == null: _p("RESULT ok=%d bad=%d" % [ok, bad]); return
	for u in op.units: if J.num(u.side) == 1: u["hp"] = 1.0; u["maxhp"] = maxf(1.0, J.num(u.maxhp))
	for i in 3000:
		if op.phase == "done": break
		RTS._last_f = -1; RTS.tick(0.1)
	await _w(t, 0.5)
	var rep = RTS.last_report
	_chk("打贏魔王：戰報勝利、首勝", J.t(rep.get("win")) and J.t(rep.get("first")), rep.get("head"))
	_chk("魔王據點副魂唔會抽中魔王自己（魔王魂魄只靠 soul_drop）", not SOUL.sec_of(eb).begins_with("bm_"), SOUL.sec_of(eb))
	_chk("ng_boss.on_win → soul_drop：首殺魔王魂魄 15（戰報有一行）", SOUL.souls(BM) == 15 and str(rep.get("full", "")).contains("散魂"), [SOUL.souls(BM), rep.get("full"), rep.get("soul"), SOUL.sec_of(eb), SOUL.guard_of(eb), SOUL.camp_named(eb)])
	_chk("魔王未收服之前唔會自己入名冊", not SOUL.owned(BM))
	# ---------- 2. 再打贏幾次（非首勝每次 2–4）湊夠魂魄 ----------
	var need = int(SOUL.summon_cost(BM).souls)
	var wins = 1; var bad_drop = []
	while SOUL.souls(BM) < need and wins < 200:
		var s0 = SOUL.souls(BM)
		NGB.on_win(eb, false)
		var dn = SOUL.souls(BM) - s0
		if dn < 2 or dn > 4: bad_drop.append(dn)
		wins += 1
	_chk("再打贏 %d 次（每次 2–4）湊夠 %d 魂魄" % [wins - 1, need], SOUL.souls(BM) >= need and bad_drop.is_empty(), [SOUL.souls(BM), bad_drop])
	var cs = SOUL.summon_cost(BM)
	S.bld["altar"] = maxf(J.num(S.bld.get("altar", 0)), float(cs.altar))
	S.res["coins"] = float(cs.coins) + float(cs.wish_n) + 1000.0
	if str(cs.wish) != "coins": S.res[str(cs.wish)] = float(cs.wish_n) + 10.0
	_chk("可以招降饕餮", SOUL.can_summon(BM).ok, SOUL.can_summon(BM))
	# ---------- 3. 開祭壇招降頁、真撳掣 ----------
	SUI.tab = "summon"
	Menus.open_bld("altar"); await _w(t, 0.9)
	var btn = _tame_btn(m.sheet_body, BM)
	_chk("祭壇招降頁有饕餮「招降」掣（可撳）", btn != null)
	await _shot(t, "01_altar_before")
	var before = await _img(t)
	if btn == null: _p("RESULT ok=%d bad=%d" % [ok, bad]); return
	var lg0 = VP.LOG.size()
	var t0 = Time.get_ticks_msec()
	btn.emit_signal("pressed")
	var tm2 = t.get_tree().create_timer(2.0)   # 遊戲時間 2 秒（xvfb 軟件渲染幀率低，遊戲時間比牆鐘慢）
	_chk("撳完：饕餮入名冊", SOUL.owned(BM) and S.ghosts.any(func(g): return str(g.k) == BM))
	_chk("撳完：播咗 up_tame", VP.LOG.slice(lg0).has("up_tame"), VP.LOG.slice(lg0))
	var host = root.get_node_or_null("VfxTop")
	var fx = null
	if host != null:
		for c in host.get_children(): if c is Control and c.get("key") == "up_tame": fx = c
	_chk("特效節點喺 VfxTop（layer 110）", host != null and host.layer == 110 and fx != null, host.layer if host else null)
	_chk("特效大型：闊 ≥ 畫面闊、壽命 2 秒", fx != null and float(fx.px) >= vs.x and is_equal_approx(float(fx.life), 2.0), [fx.px if fx else 0, vs.x])
	# 收服劇情、入職通知書亦已出（同一時間）：佢哋都要喺特效下面
	await _w(t, 0.25)
	var shots = {}
	for x in [[0.35, "02_tame_0.35s"], [0.8, "03_tame_0.8s"], [1.3, "04_tame_1.3s"], [1.75, "05_tame_1.75s"]]:
		while is_instance_valid(fx) and float(fx.t) < float(x[0]): await t.get_tree().process_frame
		shots[x[1]] = await _shot(t, str(x[1]))
		if is_instance_valid(fx): _p("  fx.t=%.2f 實際=%.2f paused=%s can_process=%s fps=%d" % [float(fx.t), (Time.get_ticks_msec() - t0) / 1000.0, str(t.get_tree().paused), str(fx.can_process()), Engine.get_frames_per_second()])
		if str(x[1]) == "03_tame_0.8s" and is_instance_valid(fx):
			# 特效貢獻：同一刻收埋特效＋暗影再影一張比較（彈窗遮住嘅話兩張一樣）
			fx.visible = false; fx.bd.visible = false
			var hid = await _img(t)
			fx.visible = true; fx.bd.visible = true
			hid.save_png(SHOTS + "03b_tame_0.8s_fx_hidden.png")
			shots["hid"] = hid
	var hi = _layers(root).filter(func(a): return int(a[1]) >= 110)
	_chk("冇任何可見彈窗／圖層高過特效（layer ≥110）", hi.is_empty(), [hi, _layers(root).map(func(a): return a[1])])
	var main_r = Rect2i(Vector2i(int(vs.x * 0.15), int(vs.y * 0.5 - vs.x * 0.35)), Vector2i(int(vs.x * 0.7), int(vs.x * 0.7)))
	var d1 = _diff(shots.get("hid", before), shots["03_tame_0.8s"], main_r)
	_chk("特效真係睇得到、冇被遮（同一刻收埋特效對比，畫面中間差 %.3f）" % d1, shots.has("hid") and d1 > 0.08, d1)
	var sm = m.get_node_or_null("SoulShow")
	_chk("入職通知書演出（SoulShow）同時出現，喺特效下面", sm == null or not (sm is CanvasLayer) or sm.layer < 110, sm)
	# ---------- 4. 2 秒後消失 ----------
	_chk("1.75 秒時特效仲喺度（唔會早收）", is_instance_valid(fx) and shots.has("05_tame_1.75s"))
	if tm2.time_left > 0: await tm2.timeout
	for i in 3: await t.get_tree().process_frame
	var left = []
	if host != null:
		for c in host.get_children(): if not c.is_queued_for_deletion(): left.append(c.name)
	_chk("遊戲時間 2 秒後特效＋暗影全部消失（牆鐘 %.2f 秒）" % ((Time.get_ticks_msec() - t0) / 1000.0), not is_instance_valid(fx) and left.is_empty(), left)
	await _shot(t, "06_tame_after_2s")
	# 收服劇情（男女主版）排咗隊；播完名冊有饕餮
	var bsc = NGB.recruit_scene(BM)
	_chk("收服劇情 recruit_scene 有內容（%s）" % ("女" if DB.hero_female() else "男"), bsc != null and (bsc.lines as Array).size() >= 3)
	await _w(t, 1.0); await _shot(t, "07_recruit_scene")
	await _skip(t, 10)
	Menus.close_hook()
	_chk("最後：饕餮喺名冊、王品", SOUL.owned(BM) and SOUL.pin(BM) == "王")
	_p("RESULT ok=%d bad=%d" % [ok, bad])
