# [meet] 體驗量測：新開檔，純玩家動作（唔畀資源）推主線，背景每 10 秒取樣；每 120 秒截圖
# 用法：edtest.sh <godot目錄> meter res://tools/tests/meter_test.gd run 1700   （METER_MIN=分鐘上限，預設 24）
# 輸出：[meter] 行（SAMPLE / EVENT / QUEST），之後由 /home/claude/meeting/parse_meter.py 整理
extends "res://tools/tests/onboard_test.gd"

const SHOTS := "/home/claude/meeting/shots/"
var t_start := 0
var decisions := 0
var taps := 0
var done := false
var toast_seen := {}
var toasts_n := 0
var last_res := {}
var idle_s := 0.0

func _p(m): print("[meter] ", m)
func _wall() -> float: return (Time.get_ticks_msec() - t_start) / 1000.0
func _bld(id: String, a: String, arg = null):
	decisions += 1
	return super._bld(id, a, arg)
func _tap_bar(t, m) -> String:
	taps += 1
	return await super._tap_bar(t, m)
func _gather(t, m) -> void:
	taps += 2
	await super._gather(t, m)

func _sampler(t, m) -> void:
	var nshot = 0; var k = 0
	var lastq = -1; var last_stage = -1; var last_seen = 0; var last_lv = -1
	var reveal = {}
	while not done:
		await t.get_tree().create_timer(1.0, true, false, true).timeout
		k += 1
		var S = _S(); if not (S is Dictionary): continue
		var w = _wall()
		# toast 計數
		if m.toasts:
			for c in m.toasts.get_children():
				var id = c.get_instance_id()
				if not toast_seen.has(id):
					toast_seen[id] = 1; toasts_n += 1
					var txt = ""
					if c.get_child_count() > 0 and c.get_child(0) is RichTextLabel: txt = c.get_child(0).get_parsed_text()
					_p("EVENT %.0f toast %s" % [w, txt.replace("\n", " ")])
		# 主角閒置（冇目標冇動作、冇劇情）
		var V = J.G.get("Village")
		var busy = _story_busy(m)
		if V and V.hero.get("target") == null and V.hero.get("act") == null and not busy: idle_s += 1.0
		var qi = int(J.num(S.qi))
		if qi != lastq:
			var q = _cur()
			_p("EVENT %.0f quest_start %d %s rw=%s" % [w, qi, MB.quest_text(q) if q is Dictionary else "-", str(q.get("rw", q.get("reward", ""))) if q is Dictionary else ""])
			lastq = qi
		var stg = OB.stage()
		if stg != last_stage: _p("EVENT %.0f stage %d" % [w, stg]); last_stage = stg
		var lv = int(J.num(S.lv))
		if lv != last_lv: _p("EVENT %.0f hero_lv %d" % [w, lv]); last_lv = lv
		var ns = S.seen.keys().size()
		if ns != last_seen:
			for id in S.seen.keys():
				if not reveal.has("seen_" + str(id)):
					reveal["seen_" + str(id)] = 1
					if last_seen > 0: _p("EVENT %.0f story %s" % [w, str(id)])
			last_seen = ns
		for z in ["market"]:
			if ZD.revealed(z) and not reveal.has(z): reveal[z] = 1; _p("EVENT %.0f unlock %s" % [w, z])
		if ZD.wild_open() and not reveal.has("wild"): reveal["wild"] = 1; _p("EVENT %.0f unlock wild" % w)
		for tb in ["roster", "chest"]:
			if OB.tab_lock(tb) == "" and not reveal.has(tb): reveal[tb] = 1; _p("EVENT %.0f unlock %s" % [w, tb])
		var sc = m.get("mv_view")
		if sc != null and sc.sim.war.get("wave") != null and not reveal.has("wave%d" % int(J.num(MVW.ws().get("n", 0)))):
			reveal["wave%d" % int(J.num(MVW.ws().get("n", 0)))] = 1; _p("EVENT %.0f wave" % w)
		if k % 10 == 0:
			var r = S.res
			var mb = 0.0
			var CM = load("res://game/outpost/mat.gd")
			if CM: mb = CM.amt("m_bao")
			_p("SAMPLE %.0f qi=%d stg=%d lv=%d wood=%d rice=%d planks=%d buns=%d coins=%d troops=%d mbao=%d ghosts=%d dec=%d taps=%d toasts=%d idle=%d busy=%s" % [w, qi, stg, lv, int(J.num(r.get("wood",0))), int(J.num(r.get("rice",0))), int(J.num(r.get("planks",0))), int(J.num(r.get("buns",0))), int(J.num(r.get("coins",0))), int(J.num(r.get("troops",0))), int(mb), (S.ghosts as Array).size(), decisions, taps, toasts_n, int(idle_s), str(busy)])
		if k % 120 == 1:
			await RenderingServer.frame_post_draw
			var fn = SHOTS + "meter_%02dmin.jpg" % int(w / 60.0)
			t.get_viewport().get_texture().get_image().save_jpg(fn, 0.85)
			nshot += 1; _p("EVENT %.0f shot %s" % [w, fn])

func run(t) -> void:
	DirAccess.make_dir_recursive_absolute(SHOTS)
	nogift = true
	var lim_min = float(OS.get_environment("METER_MIN")) if OS.has_environment("METER_MIN") else 24.0
	var m = await _boot(t)
	t_start = Time.get_ticks_msec()
	var S = _S()
	S["ob"] = {"test": 1.0}
	ZD.gate_on = true
	if not J.t(S.seen.get("prologue_sys")) and int(J.num(S.qi)) == 0: S.seen["prologue_sys"] = true
	CTL.attach(m)
	_sampler(t, m)
	await _skip(t, 4); await _w(t, 3.0)
	var last = -1; var retry = 0
	while _wall() < lim_min * 60.0:
		await _skip(t, 2)
		J.mc(_Q(), "check", [])
		var q = _cur()
		if not (q is Dictionary): break
		var qi = _qi()
		if qi == last:
			retry += 1
			await _skip(t, 4); J.mc(_Q(), "check", []); await _w(t, 2.0)
			if _qi() != qi: retry = 0; continue
			if retry < 4: continue
			_p("EVENT %.0f STUCK %d %s 進度%s" % [_wall(), qi, MB.quest_text(q), str(_prog(q))])
			# 卡位：記低，後門跳過繼續量（記低）
			if str(q.get("t", "")) == "stage": _S().cleared[str(q.s)] = true
			if _qi() == qi: _S()["qi"] = float(qi + 1)
			gifts.append([qi, "後門跳過", MB.quest_text(q)])
			last = -1; retry = 0; continue
		last = qi; retry = 0
		var t0 = _wall(); var how = ""
		await _tap_bar(t, m)
		match str(q.t):
			"chop": how = await _do_field(t, m, q, "tree")
			"rice": how = await _do_field(t, m, q, "paddy")
			"craftPlank", "craftBun": how = "親手做 %d 輪" % await _until(t, m, q, func(): _bld("plank" if str(q.t) == "craftPlank" else "bun", "craft", 1))
			"build": how = "建造（等料 %d 輪）" % await _until(t, m, q, func(): _bld(str(q.b), "build"))
			"bLevel": how = "升級（等料 %d 輪）" % await _until(t, m, q, func(): _bld(str(q.b), "up"))
			"level": how = "做嘢儲好評 %d 輪" % await _until(t, m, q, func(): pass)
			"assign": how = await _do_assign(t, q)
			"ghostLv": how = await _do_ghostlv(t, q)
			"recruit": how = await _do_recruit(t, q)
			"drill": how = await _do_drill(t, q)
			"feast": how = await _do_feast(t, q)
			"sell": how = await _do_sell(t, m, q)
			"guard": how = await _do_guard(t, m, q)
			"stage": how = await _do_stage(t, m, q)
			_: how = "（未識：%s）" % str(q.t)
		decisions += 1
		await _skip(t, 2); J.mc(_Q(), "check", [])
		_p("QUEST %.0f Q%02d %s｜%s｜%.0fs" % [_wall(), qi, MB.quest_text(q), how, _wall() - t0])
	done = true
	var lines = 0
	for id in S.seen.keys():
		var sc = DB.D.SCENES.get(id)
		if sc is Dictionary: lines += (sc.get("lines", []) as Array).size()
	_p("END wall=%.0f qi=%d dec=%d taps=%d toasts=%d idle=%d story_lines=%d gifts=%s" % [_wall(), _qi(), decisions, taps, toasts_n, int(idle_s), lines, str(gifts)])
	_p("RESULT ok=%d bad=%d" % [ok, bad])
