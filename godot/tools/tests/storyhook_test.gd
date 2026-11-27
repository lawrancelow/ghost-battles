# [story] 劇本接駁線測試（game/outpost/mv_story.gd）
# 用法：/home/claude/setup/edtest.sh <godot目錄> storyhook res://tools/tests/storyhook_test.gd logic|shots|all
#   logic：每關每個 beat 觸發條件都會觸發一次、條件未到唔播、主對話忙唔播、唔重播、Boss 已打低跳過、
#          拔營 beat 時序（播完先郁；真場景動畫喺 beat 之後）、舊存檔、客人四種狀態句（唔連續重複）、
#          惡鬼 head／roam／wave、女主稱呼、粵／中揀語言
#   shots：第 1 關開場 beat、客人四種氣泡（/tmp/storyhook/shots/）
# 全部資料驅動：mv_story.json 加新關（第 6 關）唔使改測試。
extends RefCounted

const MD = preload("res://game/outpost/mv_data.gd")
const SIM = preload("res://game/outpost/mv_sim.gd")
const MVW = preload("res://game/outpost/mv_war.gd")
const STY = preload("res://game/outpost/mv_story.gd")
const SHOTS := "/tmp/storyhook/shots/"
var ok := 0
var bad := 0

func _p(m): print("[storyhook] ", m)
func _chk(name: String, cond: bool, extra = "") -> void:
	if cond: ok += 1; _p("ok  " + name + ("　" + str(extra) if str(extra) != "" else ""))
	else: bad += 1; _p("BAD " + name + ("　" + str(extra) if str(extra) != "" else ""))
func _main(t): return t.get_tree().root.get_node_or_null("Main")
func _w(t, s: float): await t.get_tree().create_timer(s).timeout
func _S(): return J.G.get("S")

# 假場景：mv_story 用到嘅欄位
class FakeSc extends RefCounted:
	var sim
	var visible := true
	var embed := true
	var hud_on := true
	var anim = null
	var card = null
	var sheet = null
	var picker = null
	var main = null
	var top_pad := 0.0
	var cam := 0.0
	var bubbles: Array = []
	var floats: Array = []
	var moved := 0
	func _bubble(p: Vector2, tx: String, who: String, life := 2.6) -> void: bubbles.append({"p": p, "text": tx, "who": who, "life": life})
	func _float(p: Vector2, tx: String, _c: Color, _sz := 16, _life := 1.4) -> void: floats.append({"p": p, "text": tx})
	func s2w(p: Vector2) -> Vector2: return p
	func move_next(_instant := false) -> bool: moved += 1; return true

var _q: Array = []   # 假播放器：[scene, cb]
func _mk(sim) -> Array:
	var st = STY.new()
	_q = []
	st.play_fn = func(scene, cb): _q.append([scene, cb])
	st.busy_fn = func(): return false
	var sc = FakeSc.new(); sc.sim = sim
	return [st, sc]
func _finish_all() -> void:   # 播放器逐個播完
	while _q.size():
		var it = _q.pop_front(); (it[1] as Callable).call()
func _tick(st, sc, n := 4) -> void:
	for i in n:
		st._gap = 0.0; st._ct = 0.0; st.tick(sc, 0.1)
		_finish_all()

func _reset_map(sim, c: int) -> void:
	var S = _S()
	S.erase("mv"); S.erase("mv_story"); S["cleared"] = {}
	sim.st().ci = float(c); sim.reset_live(); sim.st()
	MVW.ws()

# 令 beat 嘅 when 成立
func _drive(sim, b: Dictionary) -> void:
	var w = b.get("when", {}); var k = str(w.get("k", "")); var n = float(w.get("n", 1))
	match str(w.get("t")):
		"unlock": sim.sst(k).unlocked = true
		"level": sim.sst(k).unlocked = true; sim.sst(k).lv = n
		"sold":
			var g = k
			if g == "*" or g == "":
				g = str(MD.st_def(MD.stations(sim.ci())[0]).get("good", "x"))
			sim.st().sold[g] = J.num(sim.st().sold.get(g)) + n
		"goal": sim.st().goals_done.append(float(int(w.get("i", w.get("n", 0)))))
		"boss_next":
			var G = MD.goals(sim.ci())
			for i in G.size(): if str(G[i].get("t")) != "boss" and not sim.goal_claimed(i): sim.st().goals_done.append(float(i))
		"all_done":
			for i in MD.goals(sim.ci()).size(): if not sim.goal_claimed(i): sim.st().goals_done.append(float(i))
			_S().cleared["%d-3" % (sim.ci() + 1)] = true
			load("res://game/zone/zone_data.gd").mark_all_bosses(int(sim.ci()))   # [zone56] 第 6 關都分區：野外王全部打低先算 all_done
		"inf_below": MVW.ws().inf[str(sim.ci())] = n - 1.0
		"wave": MVW.ws().wn[str(sim.ci())] = n

func logic(t) -> void: await _logic(t); _p("RESULT ok=%d bad=%d" % [ok, bad])
func shots(t) -> void: await _shots(t); _p("RESULT ok=%d bad=%d" % [ok, bad])
func all(t) -> void:
	await _logic(t); await _shots(t)
	_p("RESULT ok=%d bad=%d" % [ok, bad])

func _wait_boot(t):
	for i in 120:
		await _w(t, 0.5)
		var m = _main(t)
		if m and m.get("loading") == null and J.G.get("S") is Dictionary: break
	await _w(t, 1.5)

func _logic(t) -> void:
	STY.auto_on = true
	await _wait_boot(t)
	var m = _main(t)
	if m != null and m.has_method("_hide_title"): m._hide_title()
	await _w(t, 0.5)
	var S = _S()
	var save0 = S.duplicate(true)
	var lang0 = DB.lang
	MD.reload(); STY.reload()
	J.test_clock = 1.9e12
	var sim = SIM.new()
	var maps = STY.D().MAPS
	_chk("mv_story.json 載入（%d 張圖）" % maps.size(), maps.size() >= 5)
	# ---------- 每關每個 beat ----------
	for ms in maps:
		var c = int(ms.ci)
		_reset_map(sim, c)
		var r = _mk(sim); var st = r[0]; var sc = r[1]
		var bl = STY.beats(c)
		for zb in bl: if STY.is_zone(zb): STY.mark(str(zb.id))   # [zstory] 分區 beat（開場、協調前置）由 zstory_test 測；呢度當已播
		var moves = []
		for b in bl:
			var id = str(b.id); var wt = str(b.when.t)
			if wt == "move": moves.append(b); continue
			if wt == "zone": continue   # [zstory] 分區事件 beat：由 zstory_test 測
			if wt != "open":
				_tick(st, sc)
				_chk("圖%d %s：條件未到唔播" % [c + 1, id], not st.played.has(id))
				_drive(sim, b)
				st.busy_fn = func(): return true
				_tick(st, sc)
				_chk("圖%d %s：主對話忙唔播" % [c + 1, id], not st.played.has(id))
				st.busy_fn = func(): return false
			sc.hud_on = false; _tick(st, sc)
			if wt == "open": _chk("圖%d %s：未見到大排檔唔播" % [c + 1, id], not st.played.has(id))
			sc.hud_on = true; _tick(st, sc)
			var cnt = st.played.count(id)
			_chk("圖%d %s（%s）：觸發一次" % [c + 1, id, wt], cnt == 1, cnt)
			_tick(st, sc, 6)
			_chk("圖%d %s：唔重播" % [c + 1, id], st.played.count(id) == 1 and STY.is_seen(id))
		var has_end = false
		for b in bl: if str(b.when.t) == "all_done": has_end = true
		_chk("圖%d：有拔營 beat（最後一張圖：all_done 收尾）" % (c + 1), moves.size() >= 1 or (has_end and c == MD.maps_n() - 1))
		_S().cleared = {}
		# 拔營 beat 時序
		for b in moves:
			var id2 = str(b.id)
			sc.moved = 0
			var blk = st.before_move(sc, false)
			_chk("圖%d %s：撳拔營 → 先播 beat、未郁" % [c + 1, id2], blk and sc.moved == 0 and _q.size() == 1 and st.pending_move)
			_chk("圖%d %s：播緊再撳唔會重複" % [c + 1, id2], st.before_move(sc, false) and _q.size() == 1)
			_finish_all()
			_chk("圖%d %s：播完 → 拔營一次" % [c + 1, id2], sc.moved == 1 and not st.pending_move)
			_chk("圖%d %s：之後撳拔營唔再播" % [c + 1, id2], not st.before_move(sc, false) and _q.is_empty() and st.played.count(id2) == 1)
		# scene 內容
		for b in bl:
			var scn = STY.build_scene(b)
			var good = scn.lines.size() <= b.scene.lines.size() and scn.lines.size() > 0   # [zstory] 有出場條件嘅句可能唔播
			for l in scn.lines: if not (l is Array and l.size() == 2 and str(l[1]) != ""): good = false
			if str(scn.style) == "chat" and not (scn.get("title") is String): good = false
			if str(scn.style) == "talk" and scn.has("bg") and not Spr.ok("bg_" + str(scn.bg)): good = false
			for who in b.get("art", {}): if not DB.D.SPEAKER_ART.has(who): good = false
			_chk("圖%d %s：scene 格式（%s）" % [c + 1, str(b.id), scn.style], good)
	# ---------- _doc 其他觸發（資料暫時未用到）：level／inf_below／wave／goal／all_done／need.after ----------
	var c0 = 0
	var s0 = MD.stations(c0)[0]
	var syn = [
		{"id": "syn_a", "when": {"t": "open"}, "scene": {"style": "talk", "lines": [["旁白", "甲", "甲"]]}},
		{"id": "syn_level", "when": {"t": "level", "k": s0, "n": 7}, "need": {"after": ["syn_a"]}, "scene": {"style": "talk", "lines": [["旁白", "乙", "乙"]]}},
		{"id": "syn_inf", "when": {"t": "inf_below", "n": 30}, "scene": {"style": "talk", "lines": [["旁白", "丙", "丙"]]}},
		{"id": "syn_wave", "when": {"t": "wave", "n": 2}, "scene": {"style": "talk", "lines": [["旁白", "丁", "丁"]]}},
		{"id": "syn_goal", "when": {"t": "goal", "i": 1}, "scene": {"style": "talk", "lines": [["旁白", "戊", "戊"]]}},
		{"id": "syn_after", "when": {"t": "open"}, "need": {"after": ["syn_goal"]}, "scene": {"style": "talk", "lines": [["旁白", "己", "己"]]}},
		{"id": "syn_end", "when": {"t": "all_done"}, "scene": {"style": "talk", "lines": [["旁白", "庚", "庚"]]}}]
	var keep_b = STY.map_story(c0).beats
	STY.map_story(c0)["beats"] = syn
	_reset_map(sim, c0)
	var rs = _mk(sim); var sts = rs[0]; var scs = rs[1]
	MVW.ws().inf[str(c0)] = 60.0
	_tick(sts, scs)
	_chk("其他觸發：開頭只播 open", sts.played == ["syn_a"], sts.played)
	sim.sst(s0).lv = 6.0; _tick(sts, scs); _chk("level：Lv6 < 7 唔播", not sts.played.has("syn_level"))
	sim.sst(s0).lv = 7.0; _tick(sts, scs); _chk("level：Lv7 播", sts.played.has("syn_level"))
	MVW.ws().inf[str(c0)] = 30.0; _tick(sts, scs); _chk("inf_below：影響力 30 唔播", not sts.played.has("syn_inf"))
	MVW.ws().inf[str(c0)] = 29.0; _tick(sts, scs); _chk("inf_below：影響力 29 播", sts.played.has("syn_inf"))
	MVW.ws().wn[str(c0)] = 1.0; _tick(sts, scs); _chk("wave：打完第 1 波唔播", not sts.played.has("syn_wave"))
	sim.war.start_wave(sim); _tick(sts, scs); _chk("wave：第 2 波開始播", sts.played.has("syn_wave"))
	sim.war.wave = null
	_chk("need.after：前置未播唔播", not sts.played.has("syn_after"))
	sim.st().goals_done.append(1.0); _tick(sts, scs)
	_chk("goal：第 2 個目標完成播；need.after 跟住播", sts.played.has("syn_goal") and sts.played.has("syn_after") and sts.played.find("syn_after") > sts.played.find("syn_goal"))
	for i in MD.goals(c0).size(): if not sim.goal_claimed(i): sim.st().goals_done.append(float(i))
	_tick(sts, scs); _chk("all_done：目標全領、Boss 未打唔播", not sts.played.has("syn_end"))
	_S().cleared["%d-3" % (c0 + 1)] = true
	load("res://game/zone/zone_data.gd").mark_all_bosses(c0)   # [zone] 分區地圖：野外王全部打低先算 all_done
	_tick(sts, scs); _chk("all_done：Boss 已打低播", sts.played.has("syn_end"))
	_S().cleared = {}
	STY.map_story(c0)["beats"] = keep_b
	STY.auto_on = false
	var rq = _mk(sim); _reset_map(sim, c0); _tick(rq[0], rq[1])
	_chk("auto_on 關（其他線測試）：唔自動播、拔營唔阻", rq[0].played.is_empty() and not rq[0].before_move(rq[1], false))
	STY.auto_on = true
	# ---------- Boss 已打低：boss_alive beat 跳過 ----------
	for ms in maps:
		var c = int(ms.ci)
		for b in STY.beats(c):
			if not J.t(b.get("need", {}).get("boss_alive")): continue
			_reset_map(sim, c)
			var r2 = _mk(sim); var st2 = r2[0]; var sc2 = r2[1]
			for af in b.need.get("after", []): STY.mark(str(af))
			_drive(sim, b)
			_S().cleared["%d-3" % (c + 1)] = true
			_tick(st2, sc2, 6)
			_chk("圖%d %s：Boss 已打低 → 跳過唔播" % [c + 1, str(b.id)], not st2.played.has(str(b.id)) and J.num(STY.seen_d().get(str(b.id))) == 2.0)
			_S().cleared = {}
			_reset_map(sim, c)
			r2 = _mk(sim); st2 = r2[0]; sc2 = r2[1]
			for af in b.need.get("after", []): STY.mark(str(af))
			_drive(sim, b); _tick(st2, sc2)
			_chk("圖%d %s：Boss 未打 → 播" % [c + 1, str(b.id)], st2.played.has(str(b.id)))
	# ---------- 唔同關嘅 beat 唔會喺第二關播 ----------
	_reset_map(sim, 1)
	var r3 = _mk(sim); _tick(r3[0], r3[1])
	var only1 = true
	for id in r3[0].played: if STY._beat_ci(str(id)) != 1: only1 = false   # [integ6] 第 2 關合併 zone2 後係分區地圖：分區開場 zs1_* 都係 ci=1 嘅 beat
	_chk("只播當前圖（ci=2）嘅 beat", only1 and r3[0].played.size() >= 1, r3[0].played)
	# ---------- 舊存檔 ----------
	var S0 = _S()
	S0.erase("mv")
	sim.st()
	_chk("舊存檔（冇 S.mv.story_seen）：自動補", not S0.mv.has("story_seen") and STY.seen_d() is Dictionary and S0.mv.get("story_seen") is Dictionary)
	S0.mv.erase("story_seen"); S0["mv_story"] = {"mv0_open": 1}
	_chk("舊存檔（S.mv_story）：搬入 story_seen", STY.is_seen("mv0_open"))
	S0.erase("mv_story")
	var r4 = _mk(sim); sim.st().ci = 0.0; _tick(r4[0], r4[1])
	_chk("舊存檔已播 open → 唔重播", not r4[0].played.has("mv0_open"))
	var S_no = _S(); var mv_bak = S_no.mv; S_no.erase("mv")
	_chk("冇 S.mv：is_seen 唔報錯", not STY.is_seen("mv0_open"))
	S_no["mv"] = mv_bak
	# ---------- 客人四種狀態句 ----------
	var st5 = STY.new()
	var kinds = ["q", "buy", "wait", "vol"]
	var n_say = 0; var all_in = true; var no_rep = true; var fb_ok = true
	for cd in MD.D().CUSTOMERS:
		var cid = str(cd.id)
		var has_say = cd.get("say") is Dictionary
		if has_say: n_say += 1
		for kd in kinds:
			var pool = STY.say_pool(cid, kd)
			var exp = []
			for a in pool: exp.append(STY.TN(a))
			if has_say and cd.say.get(kd) is Array and cd.say[kd].size():
				if str(pool) != str(cd.say[kd]): all_in = false
			elif not has_say:
				if kd in ["q", "buy"] and str(pool) != str(cd.get("lines", [])): fb_ok = false
				if kd == "vol" and str(pool) != str(MVW.L_JOIN): fb_ok = false
			var prev = ""
			for i in 24:
				var s = st5.cust_line(cid, kd)
				if exp.size() and not exp.has(s): all_in = false
				if exp.size() > 1 and s == prev: no_rep = false
				prev = s
	_chk("客人有 say（%d 種）" % n_say, n_say > 0)
	_chk("客人句全部出自 say.q／buy／wait／vol", all_in)
	_chk("同一個客人唔連續重複上一句", no_rep)
	_chk("冇 say 嘅客人：q／buy 用 lines、vol 用 L_JOIN", fb_ok)
	# 事件 → 氣泡（用真 sim 數據）
	_reset_map(sim, 0)
	for sid in MD.stations(0): sim.sst(sid).unlocked = true
	sim.relayout()
	var cd0 = null
	for cd in MD.D().CUSTOMERS: if cd.get("say") is Dictionary and MD.map_def(0).customers.has(cd.id): cd0 = cd; break
	var cid0 = str(cd0.id)
	var r6 = _mk(sim); var st6 = r6[0]; var sc6 = r6[1]
	var pool_of = func(kd):
		var o = []
		for a in STY.say_pool(cid0, kd): o.append(STY.TN(a))
		return o
	var cu = {"cid": cid0, "k": "youhun", "wants": {}, "got": {}, "st": "serve", "slot": 0, "take": 0.3, "s": 0.0, "pos": Vector2(200, 900), "ph": 0.0, "flip": true, "lines": [], "vip": false, "wait": 0.0}
	sim.custs = [cu]
	st6.random_line(sc6)
	_chk("排隊 → say.q", sc6.bubbles.size() == 1 and pool_of.call("q").has(sc6.bubbles[0].text), sc6.bubbles)
	sc6.bubbles.clear(); cu.wait = SIM.PATIENCE * 0.6
	st6.tick(sc6, 0.1)
	_chk("櫃台前等太耐 → say.wait（一次）", sc6.bubbles.size() == 1 and pool_of.call("wait").has(sc6.bubbles[0].text))
	st6.tick(sc6, 0.1); _chk("等太耐氣泡唔重出", sc6.bubbles.size() == 1)
	sc6.bubbles.clear()
	var nb = 0
	for i in 20:
		cu.st = "out"; cu.wait = 0.0
		sim.ev = [{"k": "pay", "amt": 1.0, "pos": cu.pos + Vector2(0, -60), "cid": cid0}]
		st6.eat(sc6)
	for b in sc6.bubbles: if pool_of.call("buy").has(b.text): nb += 1
	_chk("買到 → say.buy", nb > 0 and nb == sc6.bubbles.size(), "%d/%d" % [nb, sc6.bubbles.size()])
	sc6.bubbles.clear()
	var cu2 = cu.duplicate(); cu2.erase("_sw"); cu2.st = "out"; sim.custs = [cu2]
	sim.ev = [{"k": "leave", "pos": cu2.pos + Vector2(0, -60), "cid": cid0}]
	st6.eat(sc6)
	_chk("等到嬲走人 → say.wait", sc6.bubbles.size() == 1 and pool_of.call("wait").has(sc6.bubbles[0].text))
	sc6.bubbles.clear()
	var ej = {"k": "war_join", "pos": Vector2(100, 900), "line": "舊句", "gid": "", "cid": cid0}
	sim.ev = [{"k": "pay", "amt": 1.0, "pos": Vector2(100, 900), "cid": cid0}, ej]
	st6.eat(sc6)
	_chk("變義勇軍 → say.vol（代替 L_JOIN），同時唔出 buy", pool_of.call("vol").has(str(ej.line)) and sc6.bubbles.is_empty(), ej.line)
	# 真 sim：等太耐離開嘅事件有 cid（[story] 掛鈎）
	_reset_map(sim, 0)
	for sid in MD.stations(0): sim.sst(sid).unlocked = true
	for sid in MD.stations(0): sim.st().counter[str(MD.st_def(sid).get("good", ""))] = 30.0   # [militia] 客人只要有供應嘅貨：櫃台擺貨
	sim.custs = []; sim.spawn_t = 0.0
	sim.spawn_cust()
	var evs = []
	if sim.custs.size():
		var c9 = sim.custs[0]; c9.st = "serve"; c9.s = 0.0; c9.wait = 999.0; c9.got = {}
		sim.ev.clear(); sim._step_custs(0.05); evs = sim.ev.duplicate(); sim.ev.clear()
	var lv_ok = false
	for e in evs: if str(e.k) == "leave" and str(e.get("cid", "")) != "": lv_ok = true
	_chk("mv_sim 走人事件帶 cid", lv_ok, evs)
	# ---------- 惡鬼 ----------
	for ms in maps:
		var c = int(ms.ci)
		_reset_map(sim, c); sim.relayout()
		var r7 = _mk(sim); var st7 = r7[0]; var sc7 = r7[1]
		var P = {}
		for kd in ["head", "roam", "wave"]:
			P[kd] = []
			for a in ms.FOE[kd]: P[kd].append(STY.TN(a))
		sim.foes = [{"k": "youhun", "pos": Vector2(200, 200), "hp": 1.0, "mx": 1.0, "st": "charge", "t": 0.0, "boss": true}]
		st7.tick(sc7, 0.1); st7.tick(sc7, 0.1)
		_chk("圖%d 鬼潮頭目出場 → FOE.head（一次）" % (c + 1), sc7.bubbles.size() == 1 and P.head.has(sc7.bubbles[0].text))
		sim.foes = []; sc7.bubbles.clear()
		var rl = []
		for i in 30:
			var eb = {"k": "bang", "pos": Vector2(100, 300)}; sim.ev = [eb]; st7.eat(sc7)
			if eb.has("line"): rl.append(eb.line)
		var rin = rl.size() > 0
		for s in rl: if not P.roam.has(s): rin = false
		_chk("圖%d 遊魂撞圍欄 → FOE.roam" % (c + 1), rin, rl.size())
		var ew = {"k": "war_warn"}; sim.ev = [ew]; st7.eat(sc7)
		var joined = ""
		for f in sc7.floats: joined += str(f.text)
		var fit = true
		for f in sc7.floats: if str(f.text).length() > STY.WAVE_CH: fit = false
		_chk("圖%d 鬼潮預告 → FOE.wave（每行 ≤%d 字）" % [c + 1, STY.WAVE_CH], P.wave.has(joined) and J.t(ew.get("said")) and fit, joined)
	# 長句拆行
	var okc = true
	for ms in maps:
		for a in ms.FOE.wave:
			for s in a:
				var ls = STY.split2(str(s), STY.WAVE_CH)
				if "".join(ls) != str(s) or ls.size() > 2: okc = false
				for l in ls: if l.length() > STY.WAVE_CH: okc = false
	_chk("全部鬼潮預告拆兩行之內、每行 ≤%d 字" % STY.WAVE_CH, okc)
	# ---------- 語言、女主稱呼 ----------
	var b0 = STY.beat("mv0_open")
	DB.lang = "yue"; var sy = STY.build_scene(b0)
	DB.lang = "zh"; var sz = STY.build_scene(b0)
	_chk("粵／中揀對欄", str(sy.lines[0][1]) == str(b0.scene.lines[0][1]) and str(sz.lines[0][1]) == str(b0.scene.lines[0][2]))
	var hero0 = S.get("hero")
	S["hero"] = {"name": "阿慧", "full": "陳嘉慧", "en": "", "sex": "f", "set": true}
	DB.fem_load()
	var fem_bad = []; var fem_hit = 0; var n_lines = 0
	for lg in ["yue", "zh"]:
		DB.lang = lg
		for ms in maps:
			for b in ms.beats:
				var scn = STY.build_scene(b)
				for l in scn.lines:
					n_lines += 1
					var shown = str(DB.L(str(l[1]))); var who = str(DB.N(str(l[0])))
					if shown.contains("阿福") or shown.contains("少爺") or shown.contains("陳大福") or who.contains("阿福"): fem_bad.append(shown.substr(0, 20))
					if DB.FEM.has(str(l[1])) and shown == str(DB.FEM[str(l[1])]): fem_hit += 1
				if scn.get("title") is String and str(DB.N(scn.title)).contains("阿福"): fem_bad.append(scn.title)
	_chk("女主：劇本 beat 冇「阿福／少爺」（%d 句）" % n_lines, fem_bad.is_empty(), fem_bad.slice(0, 3))
	_chk("女主：fem.json 女版句有用到（%d 句）" % fem_hit, fem_hit > 0)
	var st8 = STY.new(); var cbad = []
	for lg in ["yue", "zh"]:
		DB.lang = lg
		for cd in MD.D().CUSTOMERS:
			for kd in kinds:
				for i in 6:
					var s = st8.cust_line(str(cd.id), kd)
					if s.contains("阿福") or s.contains("少爺"): cbad.append(s)
	_chk("女主：客人氣泡冇「阿福／少爺」", cbad.is_empty(), cbad.slice(0, 3))
	DB.lang = "zh"
	var shown_zh = str(DB.L(str(STY.build_scene(b0).lines[2][1])))
	_chk("女主：小紙叫「大小姐」", shown_zh.contains("大小姐"), shown_zh)
	if hero0 == null: S.erase("hero")
	else: S["hero"] = hero0
	DB.lang = lang0
	# 還原
	J.G["S"] = save0
	J.test_clock = -1.0

# ================= 截圖 =================
func _shot(t, name: String):
	await RenderingServer.frame_post_draw
	t.get_viewport().get_texture().get_image().save_png(SHOTS + name + ".png"); _p("shot " + name)

func _shots(t) -> void:
	STY.auto_on = true
	DirAccess.make_dir_recursive_absolute(SHOTS)
	await _wait_boot(t)
	var m = _main(t)
	m._hide_title(); await _w(t, 1.0)
	for i in 8:
		if m.story.cur != null: m.story.skip_scene()
		await _w(t, 0.25)
	if m.has_method("_nav_on"): m._nav_on("village")
	await _w(t, 0.6)
	var sc = m.mv_view; var em = m.mv_embed
	_chk("截圖：合一地圖嵌入場景有 story", sc != null and sc.story != null)
	var S = _S()
	sc.sim.st().ci = 0.0; sc._after_move()
	sc.sim.st()["story_seen"] = {}
	for b in STY.beats(0): if STY.is_zone(b): STY.mark(str(b.id))   # [zstory] 分區開場另外測（zstory_test），呢度淨係測大排檔 open
	S.res.coins = 1e7
	for sid in MD.stations(0): sc.sim.sst(sid).unlocked = true
	# 鏡頭去大排檔區 → 開場 beat 自動播
	var E = em.eh()
	var ZDh = load("res://game/zone/zone_data.gd")
	if ZDh.on() and m.village.has_method("zone_cam"):   # [p45] 分區地圖：大排檔要散咗霧（fogfix：未散霧唔播開檔、唔開檔冇客），鏡頭用 2D 鏡頭對準大排檔
		ZDh.reveal_all(-1, true)
		var zc = m.village.zone_cam(); zc.center_on(ZDh.zrect("market").get_center()); zc.tgt = null; zc.vel = Vector2.ZERO
	else: J.mc(J.G.get("Village"), "setCam", [-E + 260.0])
	var got = false
	for i in 30:
		await _w(t, 0.3)
		if m.story.cur != null: got = true; break
	_chk("真場景：見到大排檔 → 播第 1 關開場 beat", got and STY.is_seen("mv0_open"))
	await _w(t, 0.3); m.story.advance(); await _w(t, 0.3)   # 第 1 句打完字
	await _shot(t, "01_open_beat_l1")
	m.story.advance(); await _w(t, 0.1); m.story.advance(); await _w(t, 0.3)   # 第 2 句
	m.story.advance(); await _w(t, 0.1); m.story.advance(); await _w(t, 0.3)   # 第 3 句（小紙）
	await _shot(t, "02_open_beat_l3")
	# 等其他 beat 唔好彈出嚟（截氣泡、拔營時序）：要喺跳走開場 beat「之前」標晒已播。
	# 之前係跳完先標：開場播完隔 GAP(1.2)+CHECK_DT(≤0.5) 秒，tick 會自動播下一個（全部檔已解鎖 → mv0_mill），
	# 跳嘅迴圈（8×0.2 秒）長過定短過呢段時間純粹睇幀率；機器慢時 mv0_mill 喺迴圈尾先入隊、冇被跳走，
	# 一路播到下面拔營時序，skip_scene 跳走嘅係佢而唔係 move beat → 拔營動畫唔開（合併後畫面重咗，幾乎次次中）。
	for b in STY.beats(0): if str(b.when.t) != "move": STY.mark(str(b.id))
	for i in 8:
		if m.story.cur != null: m.story.skip_scene()
		await _w(t, 0.2)
	for sid in MD.stations(0): sc.sim.st().counter[str(MD.st_def(sid).get("good", ""))] = 30.0   # [militia] 客人只要有供應嘅貨：櫃台擺貨
	sc._prefill(); await _w(t, 5.0)
	# 客人四種氣泡
	var cs = []
	for c in sc.sim.custs: if c.st != "out" and MD.cust_def(str(c.cid)).get("say") is Dictionary: cs.append(c)
	_chk("截圖：有客人", cs.size() >= 1, cs.size())
	sc._line_t = 999.0
	if cs.size(): J.mc(J.G.get("Village"), "setCam", [float(cs[0].pos.y) - E - 430.0])
	await _w(t, 0.6)
	var kinds = ["q", "buy", "wait", "vol"]
	for i in kinds.size():
		if cs.is_empty(): break
		sc.bubbles.clear()
		var c = cs[i % cs.size()]
		sc.story.bubble_cust(sc, c, kinds[i])
		if sc.bubbles.is_empty(): continue   # [qa54] 客人啱啱走咗／冷卻中就唔出氣泡，截圖跳過唔好報錯
		sc.bubbles[sc.bubbles.size() - 1].life = 99.0
		await _w(t, 0.5)
		await _shot(t, "03_cust_%s" % kinds[i])
	# 四種一齊（三個上限 → 分兩張）
	sc.bubbles.clear()
	for i in 3:
		if cs.size() > i: sc.story.bubble_cust(sc, cs[i], kinds[i])
	for b in sc.bubbles: b.life = 99.0
	await _w(t, 0.5); await _shot(t, "04_cust_mix")
	# 惡鬼：頭目＋鬼潮預告
	sc.bubbles.clear()
	J.mc(J.G.get("Village"), "setCam", [-E - em.top_extra()])
	await _w(t, 0.5)
	sc.sim.spawn_foe()
	var f = sc.sim.foes[sc.sim.foes.size() - 1]; f["boss"] = true; f.pos = Vector2(200, float(sc.sim.L.fence_y) - 30.0); f.st = "roam"; f.tgt = f.pos
	await _w(t, 0.4)
	for b in sc.bubbles: b.life = 99.0
	await _shot(t, "05_foe_head")
	sc.bubbles.clear(); sc.sim.foes.erase(f)
	sc.sim.ev.append({"k": "war_warn"})
	await _w(t, 0.4)
	await _shot(t, "05_foe_wave")
	sc.bubbles.clear(); sc._line_t = 8.0
	# 真場景拔營時序：撳拔營 → 先播 move beat（動畫未開始）→ 播完先開始拔營動畫
	J.mc(J.G.get("Village"), "setCam", [-E + 260.0]); await _w(t, 0.4)
	var ms0 = sc.sim.st()
	ms0.goals_done = []
	for i in MD.goals(0).size(): ms0.goals_done.append(float(i))
	S["cleared"] = S.get("cleared", {}) if S.get("cleared") is Dictionary else {}
	var cl0 = S.cleared.get("1-3")
	S.cleared["1-3"] = true
	load("res://game/zone/zone_data.gd").mark_all_bosses(0)   # [zone] 新規則：第 1 關野外王全部打低先拔得營
	_chk("真場景：可以拔營", sc.can_move())
	_chk("真場景：拔營前冇其他劇情播緊", m.story.cur == null and m.story.q.is_empty() and not sc.story._playing, "cur=%s q=%d playing=%s" % [(str(m.story.cur.sc.keys()) + " " + str(m.story.cur.sc.get("lines", [[""]])[0])) if m.story.cur != null else "null", m.story.q.size(), str(sc.story._playing)])
	var r = sc.move_next()
	await _w(t, 0.5)
	var mb = ""; var mbt = ""
	for b in STY.beats(0): if str(b.when.t) == "move": mb = str(b.id); mbt = str(STY.build_scene(b).get("title", ""))
	var cur_t = str(m.story.cur.sc.get("title", "")) if m.story.cur != null else ""
	_chk("真場景：撳拔營 → 播 move beat、動畫未開始", r and m.story.cur != null and cur_t == mbt and sc.anim == null and STY.is_seen(mb) and sc.story.pending_move)
	await _w(t, 0.3); m.story.advance(); await _w(t, 0.3)
	await _shot(t, "06_move_beat")
	sc.move_next()
	_chk("真場景：beat 播緊再撳拔營唔會開動畫", sc.anim == null)
	m.story.skip_scene(); await _w(t, 0.3)
	_chk("真場景：beat 播完 → 拔營動畫開始", sc.anim != null and not sc.story.pending_move)
	for i in 30:
		await _w(t, 0.3)
		if sc.anim == null: break
	_chk("真場景：拔營完成 → 第 2 張圖", sc.sim.ci() == 1)
	for i in 8:
		if m.story.cur != null: m.story.skip_scene()
		await _w(t, 0.2)
	if cl0 == null: S.cleared.erase("1-3")
	else: S.cleared["1-3"] = cl0
	sc.sim.st().ci = 0.0; sc._after_move()
	J.mc(J.G.get("Village"), "setCam", [180.0])
