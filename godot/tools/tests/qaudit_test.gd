# [qaudit] 「真玩家路徑」主線通關測試
# 用法：/home/claude/setup/edtest.sh <godot目錄> qaudit res://tools/tests/qaudit_test.gd play 1500
#   play：新開檔，只用玩家會做嘅操作推主線：撳任務條（記低鏡頭帶去邊）、撳樹／稻田、建築卡（建造／升級／親手做／招魂／擺宴／派人）、
#         名冊升級、出擊清單 → 揀目標 → 行動按鈕 → 出擊小卡「出發」、跳劇情、拔營掣。
#         資源唔夠：測試直接畀資源／好評（記低「給資源」）；大排檔拔營目標用測試加速（記低）。唔會直接叫完成任務嘅內部函數。
#         每個任務記：用咗乜途徑、模擬時間；卡住（合理時間內冇途徑推到）→ BAD＋STUCK，然後用測試後門跳過繼續（方便一次過搵晒問題）。
#   audit：唔打仗，逐個主線任務檢查任務文字有冇指去已拎走嘅舊入口（夜班巡陰／世界地圖／地盤／出村門）
# 輸出："[qaudit] RESULT ok=N bad=M"
extends RefCounted

const ZD = preload("res://game/zone/zone_data.gd")
const RTS = preload("res://game/rts/rts.gd")
const AT = preload("res://game/outpost/act_targets.gd")
const CTL = preload("res://game/outpost/ctl_ui.gd")
const MB = preload("res://game/outpost/mv_bridge.gd")
const TS := 1.0   # [qaudit2] 原本 6：但村子／生產（JS 迴圈）用真實時鐘，Engine.time_scale 只加速 Godot 嗰邊 → 模擬時間計錯；改返 1，打仗、練功另外加速
const FSTEP := 36  # [qaudit2] 打仗加速：每格額外行幾步（每步 1/30 秒，同正常幀率接近；步太粗會影響勝負）
const FDT := 1.0 / 30.0

var ok := 0
var bad := 0
var simt := 0.0          # 模擬時間（秒）
var rows: Array = []     # [qi, 文字, 途徑, 秒, 結果]
var gifts: Array = []    # 測試畀過乜

func _p(m): print("[qaudit] ", m)
func _chk(name: String, cond: bool, extra = "") -> void:
	if cond: ok += 1; _p("ok  " + name + ("　" + str(extra) if str(extra) != "" else ""))
	else: bad += 1; _p("BAD " + name + ("　" + str(extra) if str(extra) != "" else ""))
func _main(t): return t.get_tree().root.get_node_or_null("Main")
func _w(t, s: float):
	simt += s * Engine.time_scale
	await t.get_tree().create_timer(s * Engine.time_scale).timeout   # create_timer 受 time_scale 影響：等真實 s 秒＝模擬 s×TS
func _S(): return J.G.get("S")
func _Q(): return J.G.get("Quest")
func _cur(): return J.mc(_Q(), "cur", [])
func _qi() -> int: return int(J.num(_S().qi))
func _prog(q) -> Array:
	var p = J.mc(_Q(), "progress", [q]); return [J.num(p[0]), J.num(p[1])]
func _qtext(q) -> String: return MB.quest_text(q)
func _story_busy(m) -> bool:
	var st = m.get("story") if m else null
	var Sy = J.G.get("Story")
	return (st != null and st.get("cur") != null) or (Sy != null and J.t(J.mc(Sy, "busy", [])))
func _skip(t, n := 6):
	var idle = 0
	for i in maxi(n, 40):
		var m = _main(t)
		var st = m.get("story") if m else null
		var busy = _story_busy(m)
		if st and st.get("cur") != null: st.skip_scene()
		var sv = m.get("mv_view") if m else null
		if sv != null and sv.get("story") != null and sv.story.has_method("skip"): sv.story.skip()
		var Th = J.G.get("Theater")   # [p56] 劇場都算劇情：測試撳「跳過」
		if Th != null and J.t(J.gp(Th, "on")): J.mc(Th, "close", [true])
		if not busy:
			idle += 1
			if idle >= 3 and i >= n - 1: break
		else: idle = 0
		await t.get_tree().create_timer(0.1).timeout
func _boot(t):
	for i in 120:
		await t.get_tree().create_timer(0.5).timeout
		var m = _main(t)
		if m and m.get("loading") == null and J.G.get("S") is Dictionary: break
	await t.get_tree().create_timer(1.5).timeout
	var m = _main(t)
	m._hide_title(); await t.get_tree().create_timer(1.0).timeout; await _skip(t)
	if m.has_method("_nav_on"): m._nav_on("village")
	await t.get_tree().create_timer(0.8).timeout
	return m
func _give(r: Dictionary, why: String) -> void:
	J.cl(J.G.get("give"), null, [r]); gifts.append([_qi(), why, r])
func _rich() -> void:   # 給資源：建／升級／招魂唔使等（只係資源，唔係完成任務）
	var S = _S(); var r = {}
	for k in ["wood", "rice", "planks", "buns", "coins"]:
		if J.num(S.res.get(k, 0)) < 3000: r[k] = 3000.0
	if r.size(): _give(r, "資源")
	# [p55] 補丁 52 起：Lv10 前鬼怪升級、招魂用「冥幣＋普通包子」（m_bao，存喺材料庫）——真玩家由包子鋪出，測試照畀（記低）
	var CM = load("res://game/outpost/mat.gd")
	if CM.amt("m_bao") < 500.0:
		var add = 1500.0 - CM.amt("m_bao"); CM.add("m_bao", add); gifts.append([_qi(), "普通包子", add])
# 撳任務條（玩家第一下）：記低鏡頭帶去邊
func _tap_bar(t, m) -> String:
	var c = m.village.zone_cam() if m.village and m.village.has_method("zone_cam") else null
	var before = Vector2(c.x, c.y) if c else Vector2.ZERO
	var ev = InputEventMouseButton.new(); ev.button_index = MOUSE_BUTTON_LEFT; ev.pressed = true
	m.quest_bar.gui_input.emit(ev)
	await t.get_tree().create_timer(0.3).timeout
	var shown = Menus.cur if Menus.cur != null else ""
	var after = Vector2(c.x, c.y) if c else Vector2.ZERO
	var tgt = c.get("tgt") if c else null
	return "鏡頭%s%s" % ["→" + str(Vector2i(tgt)) if tgt is Vector2 else ("郁" if before.distance_to(after) > 2 else "冇郁"), ("／開" + str(shown)) if str(shown) != "" else ""]
func _bld(id: String, a: String, arg = null):
	Menus.open_bld(id)
	var r = Menus.jn("bldAct", [id, a, arg])
	Menus.close_hook()
	var m = Engine.get_main_loop().root.get_node_or_null("Main")
	if m: m.close_sheet()
	return r
func _ctl(): return CTL.inst

# ================= 主線各類任務嘅玩家途徑 =================
func _do_field(t, m, q, kind: String) -> String:
	var V = J.G.get("Village"); var n = int(J.num(q.get("n", 1)))
	for k in 60:
		if _prog(q)[0] >= _prog(q)[1]: break
		var p = J.mc(V, "questTarget", [])
		if p == null: return "冇目標"
		J.mc(V, "tap", [J.num(p[0]), J.num(p[1]) - (20.0 if kind == "tree" else 0.0)])
		for j in 12:   # 等阿福行到、做完（唔好中途再撳，會打斷）
			await _w(t, 0.5)
			if V.hero.get("target") == null and V.hero.get("act") == null: break
		if kind == "paddy" and k % 6 == 5: await _w(t, 6.0)   # 等禾熟
	return "撳%s" % ("樹" if kind == "tree" else "稻田")
func _do_craft(t, q) -> String:
	var b = "plank" if str(q.t) == "craftPlank" else "bun"
	_rich()
	for k in 40:
		if _prog(q)[0] >= _prog(q)[1]: break
		_bld(b, "craft", 1)
		var V = J.G.get("Village")
		for j in 20:   # 阿福行去建築親手做：等佢做完先再撳
			await _w(t, 0.5)
			if V.hero.get("target") == null and V.hero.get("act") == null: break
		if str(q.t) == "craftBun":   # 新版：嘆氣蒸籠蒸出壽包（mv_bridge）：等佢蒸
			await _w(t, 3.0)
	return "建築卡「親手做」"
func _do_build(t, q) -> String:
	_rich()
	var b = str(q.b)
	var r = _bld(b, "build")
	await _w(t, 1.0)
	if _prog(q)[0] < 1: return "建築卡「建造」失敗（%s）" % str(r)
	return "建築卡「建造」"
func _do_blevel(t, q) -> String:
	var b = str(q.b); var how = "建築卡「升級」"
	for k in 30:
		if _prog(q)[0] >= _prog(q)[1]: break
		_rich()
		if b != "house" and J.num(_S().bld.get(b, 0)) >= J.num(_S().bld.get("house", 1)):
			_bld("house", "up"); how = "先升鬼宅再升" + b
		else: _bld(b, "up")
		await _w(t, 0.5)
	return how
func _do_level(t, q) -> String:
	var need = J.num(q.n)
	for k in 20:
		if J.num(_S().lv) >= need: break
		var S = _S(); var en = maxf(10.0, float(load("res://native/game.gd").exp_need(J.num(S.lv))) - J.num(S.exp) + 1.0)
		J.cl(J.G.get("gainExp"), null, [en]); gifts.append([_qi(), "好評", en])
		await _w(t, 0.3); await _skip(t, 2)
	return "給好評（升級）"
func _free_ghosts() -> Array:
	var o = []
	for g in _S().ghosts: if str(g.k) != "afu": o.append(g)
	return o
func _do_assign(t, q) -> String:
	var n = int(J.num(q.n))
	var posts = ["bun", "plank", "wood", "rice", "home", "camp"].filter(func(x): return (J.G.get("POSTS") as Dictionary).has(x))   # [qaudit2] 民宅唔係崗位
	if _free_ghosts().size() < n:
		_rich()
		for k in 6:
			if _free_ghosts().size() >= n: break
			if J.num(_S().bld.get("altar", 0)) > 0: _bld("altar", "recruit")
		await _skip(t, 3)
	var i = 0
	for g in _free_ghosts():
		if _prog(q)[0] >= _prog(q)[1]: break
		if J.t(g.get("post")): continue
		for p in posts:
			if J.num(_S().bld.get(p, 0)) <= 0: continue
			# [qaudit2] 玩家揀有空位嘅崗位（崗位滿咗再派會頂走原本嗰隻，任務數唔會加）
			if J.iter(J.cl(J.G.get("workersAt"), null, [p])).size() >= J.num(J.mc(J.G.get("F"), "slots", [p])): continue
			Menus.open_pick(p, p); Menus.jn("pickDo", [p, J.str(g.id)]); Menus.close_hook(); m_close()
			if J.t(g.get("post")): break
		await _w(t, 0.3)
	var sl = []
	for p in posts: if J.num(_S().bld.get(p, 0)) > 0: sl.append("%s %d/%d" % [p, J.iter(J.cl(J.G.get("workersAt"), null, [p])).size(), int(J.num(J.mc(J.G.get("F"), "slots", [p])))])
	return "建築卡「派人」（%d 隻可派；崗位 %s）" % [_free_ghosts().size(), ", ".join(sl)]
func m_close():
	var m = Engine.get_main_loop().root.get_node_or_null("Main")
	if m: m.close_sheet()
func _do_ghostlv(t, q) -> String:
	var g = null
	for x in _free_ghosts():
		if g == null or J.num(x.lv) > J.num(g.lv): g = x
	if g == null: return "冇名鬼"
	for k in 60:
		if _prog(q)[0] >= _prog(q)[1]: break
		_rich()
		Menus.open_roster(); Menus.jn("rosterAct", ["up", J.str(g.id)]); Menus.close_hook(); m_close()
		await _w(t, 0.2)
	return "名冊「升級」"
func _do_recruit(t, q) -> String:
	for k in 5:
		if _prog(q)[0] >= _prog(q)[1]: break
		_rich(); _bld("altar", "recruit"); await _skip(t, 3)
	return "招魂台「招魂」"
func _do_drill(t, q) -> String:
	if J.num(_S().bld.get("camp", 0)) <= 0: return "冇訓練班"
	var g = null
	for x in _free_ghosts(): if not J.t(x.get("post")) or str(x.get("post")) == "camp": g = x; break
	if g == null and _free_ghosts().size(): g = _free_ghosts()[0]
	if g == null: return "冇鬼"
	Menus.open_pick("camp", "camp"); Menus.jn("pickDo", ["camp", J.str(g.id)]); Menus.close_hook(); m_close()
	# [qaudit2] 練功好慢（每分鐘 2～4 點，Lv2 要 300 點）：玩家會升訓練班加速；等嘅時候測試再加速（Engine.time_scale 調高，只係快轉時間）
	var ups = 0
	for k in 4:
		_rich()
		if J.num(_S().bld.get("camp", 0)) >= J.num(_S().bld.get("house", 1)): _bld("house", "up")
		var b0 = J.num(_S().bld.get("camp", 0)); _bld("camp", "up")
		if J.num(_S().bld.get("camp", 0)) > b0: ups += 1
	var FAST := 40.0   # 生產（練功）用 J.G.TIME_SCALE 加速（遊戲本身嘅時間倍數；Engine.time_scale 管唔到）
	J.G["TIME_SCALE"] = FAST
	var t0 = simt
	for k in 600:
		if _prog(q)[0] >= _prog(q)[1]: break
		if k % 20 == 0:   # [p55] 練嚇功食普通包子（m_bao，補丁 52 起），唔係壽包
			var CM = load("res://game/outpost/mat.gd")
			if CM.amt("m_bao") < 800.0:
				var add = 1500.0 - CM.amt("m_bao"); CM.add("m_bao", add); gifts.append([_qi(), "普通包子（練功食）", add])
		await t.get_tree().create_timer(1.0, true, false, true).timeout
		simt += FAST
	J.G["TIME_SCALE"] = 1.0
	return "訓練班「派人」＋升訓練班 %d 級，等練功 %d 秒（%s/%s）" % [ups, int(simt - t0), str(_prog(q)[0]), str(_prog(q)[1])]
func _do_feast(t, q) -> String:
	_rich()
	for k in 10:
		if _prog(q)[0] >= _prog(q)[1]: break
		var r = _bld("house", "feast")
		await _w(t, 0.5); await _skip(t, 3)
		if _prog(q)[0] < _prog(q)[1]:   # 智力唔夠：派多啲鬼／升級
			for g in _free_ghosts(): Menus.jn("rosterAct", ["up", J.str(g.id)])
	return "鬼宅卡「擺宴」"

# [onboard] 大排檔賣貨：撳嘆氣蒸籠（同其他開咗嘅台）做貨／收去櫃台，等客人買；冇料＝畀普通包子（記低）
func _do_sell(t, m, q) -> String:
	var sc = m.get("mv_view")
	if sc == null: return "冇大排檔"
	var sim = sc.sim; var MDd = load("res://game/outpost/mv_data.gd"); var Mt = load("res://game/outpost/mat.gd")
	var taps = 0; var gave = 0.0
	for k in 600:
		if _prog(q)[0] >= _prog(q)[1]: break
		for sid in MDd.stations(sim.ci()):
			if not sim.unlocked(sid): continue
			var r = sim.tap_station(sid); taps += 1
			if r == "starve" and sid == "st_shoubao": gave += await _sell_mat(t, m)   # 其他台（紙扇、豆花）冇料唔理：任務只要賣貨，玩家都係撳蒸籠
		await _w(t, 0.4)
		if k % 25 == 0: await _skip(t, 1)
		if k % 50 == 49 or (k % 25 == 24 and get("nogift") == true):
			var Mm = load("res://game/outpost/mat.gd"); var cs = []
			for c in sim.custs: if c.st != "out": cs.append(str(c.wants))
			var stx = []
			for sid in MDd.stations(sim.ci()): stx.append("%s:%s/%s" % [sid, str(sim.unlocked(sid)), str(sim.pile_n(sid))])
			_p("  sell… t=%s ts=%.1f sold=%s earn=%s 進度%s" % [str(get("simt")), Engine.time_scale, str(J.gp(_S().cnt, "ob_sold")), str(J.gp(_S().cnt, "ob_earn")), str(_prog(q))]); _p("  sell…… 進度%s 普通包子%s 壽包%s 客%s 台%s 櫃台%s" % [str(_prog(q)), str(Mm.amt("m_bao")), str(Mm.amt("m_shoubao")), str(cs), str(stx), str(sim.st().counter)])
	if gave > 0: gifts.append([_qi(), "普通包子（做壽包料）", gave])
	return "撳大排檔台 %d 下，等客人買（%s/%s）" % [taps, str(_prog(q)[0]), str(_prog(q)[1])]
func _sell_mat(_t, _m) -> float:   # 大排檔冇料：畀普通包子（onboard_test pace 改做親手包）
	load("res://game/outpost/mat.gd").add("m_bao", 20.0); return 20.0
# [onboard] 第一次守夜：撳圍欄外嘅孤魂
func _do_guard(t, m, q) -> String:
	var sc = m.get("mv_view")
	if sc == null: return "冇大排檔"
	var sim = sc.sim; var taps = 0
	for k in 400:
		if _prog(q)[0] >= _prog(q)[1]: break
		for f in sim.foes.duplicate():
			if f.st != "die" and f.get("ob"): sim.tap_foe(f.pos + Vector2(0, -28)); taps += 1
		await _w(t, 0.25)
		if k % 20 == 0: await _skip(t, 1)
	return "撳孤魂 %d 下（%s/%s）" % [taps, str(_prog(q)[0]), str(_prog(q)[1])]

# ================= 主線關卡：出擊清單 → 揀 → 行動按鈕 → 小卡出發 =================
func _pick_target(tg: Dictionary):
	var ctl = _ctl()
	var ts = ctl.list_targets() if ctl else AT.collect(null)
	if tg.has("pos"):
		for x in ts: if str(x.id) == "stage:" + str(tg.sid): return x
	if tg.has("zid"):
		for x in ts: if str(x.kind) == "king" and str(x.get("zid", "")) == str(tg.zid): return x
	return null
func _strengthen(t) -> void:   # 打輸：畀兵＋升名鬼（玩家會做嘅事）
	_rich()
	_give({"troops": 400.0}, "陰兵")
	# [qaudit2] 名鬼等級上限跟主角等級（Lv7→30、Lv15→40）：玩家打唔過會掛機／做嘢儲好評升級 → 測試畀一級好評（記低）
	var S = _S(); var en = maxf(10.0, float(load("res://native/game.gd").exp_need(J.num(S.lv))) - J.num(S.exp) + 1.0)
	J.cl(J.G.get("gainExp"), null, [en]); gifts.append([_qi(), "好評（練級）", en])
	# 名冊「升級」：全部名鬼升到上限（壽包唔夠就畀；記低）——之前只升 8 級又冇壽包，老殭／Pontianak 呢類底子好嘅一直停喺 Lv12～14
	var F = J.G.get("F"); var bn = 0.0
	for g in _free_ghosts():
		if J.str(g.get("q")) != "名": continue
		for k in 45:
			if J.num(J.mc(F, "glv", [g])) >= J.num(J.mc(F, "ghostCap", [])): break
			var c = J.num(J.mc(F, "lvCost", [g.lv]))
			if J.num(_S().res.buns) < c: J.cl(J.G.get("give"), null, [{"buns": c * 2.0}]); bn += c * 2.0
			Menus.jn("rosterAct", ["up", J.str(g.id)])
	if bn > 0: gifts.append([_qi(), "壽包（升名鬼）", bn])
# [qaudit2] 出擊前：名冊「職務 → 出陣」將最強嘅名鬼放入出陣空位（名鬼一職：派咗去打工嘅會由崗位調返嚟；打完唔調返）
#   （第 1 關「派 1 隻鬼去打工」會將唯一嘅小紙由出陣調走，之後阿福一個帶兵打餓鬼王必輸：舊引擎同新地圖戰鬥都係 0/6；小紙出陣就 6/6）
var tm_alt := 0   # [qaudit2] 打輸之後玩家會試其他出陣組合：第 n 次輸就試第 n 個組合
const PAIRS := [[0, 1], [0, 2], [1, 2], [0, 3], [1, 3], [2, 3]]
func _team_up() -> String:
	var S = _S(); var BKd = load("res://game/barracks/bk_data.gd")
	if not (S.get("team") is Array): return ""
	var GP = J.G.get("GP")
	var pw = func(g): return J.num(J.mc(GP, "pow", [g]))
	var gs = []
	for g in S.ghosts: if BKd.is_named(g) and BKd.job(g) != "away": gs.append(g)
	gs.sort_custom(func(a, b): return pw.call(a) > pw.call(b))
	if gs.is_empty(): return ""
	var pr = PAIRS[tm_alt % PAIRS.size()]
	var want = []
	for k in pr: if k < gs.size(): want.append(J.str(gs[k].id))
	if want.size() < mini(2, gs.size()): want = [J.str(gs[0].id)] + ([J.str(gs[1].id)] if gs.size() > 1 else [])
	var cur = []
	for id in S.team: if id != null and str(id) != "afu": cur.append(J.str(id))
	if cur.size() == want.size() and cur.all(func(x): return x in want): return ""
	for id in cur: if not (id in want): BKd.set_job(id, "idle")
	var o = []
	for id in want:
		if id in cur: continue
		if BKd.set_job(id, "team") == "ok": o.append(str(J.cl(J.G.get("ghostById"), null, [id]).name))
	return ("出陣＋" + "、".join(o)) if o.size() else ""
func _fight(t, m, x) -> String:
	var tu = _team_up()
	_p("  fight %s kind=%s %s team=%s" % [str(x.id), str(x.kind), tu, str(_S().team)])
	var ctl = _ctl()
	if ctl != null:
		ctl.pick(x)   # 出擊清單揀一項：阿福行過去
		for k in 40:
			await _w(t, 0.5)
			if ctl.get("cur") is Dictionary and str(ctl.cur.get("id", "")) == str(x.id) and ctl.act_btn.visible: break
		if ctl.get("cur") is Dictionary and str(ctl.cur.get("id", "")) == str(x.id) and ctl.act_btn.visible: ctl.press_act()   # 行動按鈕
		else: x.go.call()   # 行唔到：撳地圖目標（tap 同 go 一樣入口）
	else: x.go.call()
	_p("  pressed; pending=%s story=%s" % [str(RTS.pending != null), str(_story_busy(m))])
	await _skip(t, 3)   # 王戰前劇情
	if RTS.pending == null:
		await _w(t, 0.5)
		if RTS.pending == null: return "冇出擊小卡"
	var n0 = RTS.ops.size()
	var B = J.G.get("Battle"); if B is Dictionary: B["auto"] = true
	var r = RTS.card_go()
	if r != "ok": return "出發失敗:" + r
	var op = RTS.ops[RTS.ops.size() - 1] if RTS.ops.size() > n0 else null
	# [qaudit2] 測試加速：機器慢（幀率低），rts.tick 每格最多行 0.1 秒 → 每格額外行 FSTEP 步（同一套規則，只係快啲）；
	#   模擬時間用呢場仗自己行咗幾耐（op.T）計，唔用計時器
	var fr = 0
	while op != null and op.phase != "done" and fr < 20000:
		if op.phase in ["march", "fight", "back"]:
			for i in FSTEP:
				op.step(FDT)
				if not (op.phase in ["march", "fight", "back"]): break
		await t.get_tree().process_frame
		fr += 1
		if OS.has_environment("QA_DBG") and fr % (1 if OS.get_environment("QA_DBG") == "2" else 4) == 0 and op.phase == "fight":   # [qaudit2] 除錯：逐隻單位位置／血／目標
			var ln = []
			for u in op.units:
				if J.num(u.get("hp")) <= 0: continue
				var tg = u.get("tg")
				var ex = ""
				if OS.get_environment("QA_DBG") == "2" and not J.t(u.get("minion")):
					ex = "[d%d st%s an%s ca%s cd%.1f rg%d]" % [int(op.dist(u, tg)) if tg is Dictionary else -1, str(u.st), str(u.get("anim").get("name") if u.get("anim") is Dictionary else ""), str(J.t(u.get("casting"))), J.num(u.get("cd")), int(J.num(u.get("range")))]
				ln.append("%s%s(%d,%d)hp%d%s%s%s" % ["敵" if J.num(u.side) == 1 else "", str(u.get("name", "")).left(4), int(u.p.x), int(u.p.y), int(J.num(u.hp)), ("→" + str(tg.get("name", "")).left(4)) if tg is Dictionary else "", "" if J.t(u.get("eng")) or J.num(u.side) == 1 else "未接", ex])
			_p("    t=%.1f %s" % [op.t, " ".join(ln)])
		if fr % 400 == 0: _p("    op %s" % str(RTS.ops.map(func(o): return [o.sid, o.phase, int(o.t), int(o.T)])))
		if fr % 60 == 0: await _skip(t, 1)
	if op != null:
		simt += op.T
		_p("    戰後 %s：%s" % [str(op.result), _unit_sum(op)])
		if op.phase != "done": _p("    op 未完：%s %s" % [op.phase, str(op.result)])
	await _skip(t, 4)
	var rep = RTS.last_report
	var tus = ("（%s）" % tu) if tu != "" else ""
	return ("勝" + tus) if str(rep.get("head", "")).contains("勝") or str(rep.get("head", "")).contains("通關") or str(rep.get("win", "")) == "true" else ("結果:" + str(rep.get("head", "")) + tus)
func _unit_sum(op) -> String:   # [qaudit2] 除錯：打完雙方剩幾多
	var a = []; var f = []
	for u in op.units:
		var tag = "%s%s %d/%d" % [str(u.get("name", u.get("k", "?"))), ("Lv%d" % int(J.num(u.get("lv")))) if u.get("lv") != null else "", int(J.num(u.get("hp"))), int(J.num(u.get("maxhp")))]
		if J.num(u.side) == 1: f.append(tag)
		elif not J.t(u.get("minion")) or u.get("ml") != null: a.append(tag)
		else: a.append("兵" + tag)
	return "我方[%s] 敵方[%s] t=%d" % [", ".join(a), ", ".join(f), int(op.t)]
func _snap(qi: int) -> void:   # [qaudit2] 每個任務開始前存檔快照（/tmp/qa2snap/qNN.json）：之後可以由呢度開始重玩（edtest_from.sh）
	J.cl(J.G.get("save"), null, [])
	DirAccess.make_dir_recursive_absolute("/tmp/qa2snap")
	var f = FileAccess.open("/tmp/qa2snap/q%02d.json" % qi, FileAccess.WRITE)
	if f: f.store_string(JSON.stringify(JSRun.ls))
func _do_stage(t, m, q) -> String:
	var sid = str(q.s); var how = []
	for tries in 12:
		if _prog(q)[0] >= 1: break
		await _skip(t, 2)
		var tg = ZD.stage_target()
		_p("  stage try %d tg=%s" % [tries, str(tg.keys())])
		if tg.is_empty(): how.append("冇目標"); break
		if J.t(tg.get("later")):
			var mv = await _move_camp(t, m)
			how.append(mv)
			if not mv.begins_with("拔營"): break
			continue
		if J.t(tg.get("locked")): how.append("大排檔未開（%s）" % ZD.reveal_hint("market")); break
		var x = _pick_target(tg)
		if x == null:
			how.append("出擊清單冇目標（tg=%s rev=%s）" % [str(tg.keys()), str(ZD.revealed(str(tg.get("zid", "market"))))])
			break
		var r = await _fight(t, m, x)
		how.append("出擊清單「%s」%s" % [str(x.name), r])
		if not r.begins_with("勝") and _prog(q)[0] < 1: _strengthen(t); tm_alt += 1
		elif r.begins_with("勝"): tm_alt = 0
		J.mc(_Q(), "check", [])
	return "；".join(how)
# 拔營：先清晒野外王（出擊清單），再領大排檔目標（測試加速），最後撳拔營
func _move_camp(t, m) -> String:
	var sc = m.get("mv_view")
	if sc == null: return "冇移動村"
	var sim = sc.sim; var c = int(sim.ci())
	var log = []
	for k in 10:
		var ks = []
		for x in (_ctl().list_targets() if _ctl() else AT.collect(null)): if str(x.kind) == "king": ks.append(x)
		if ks.is_empty(): break
		var r = await _fight(t, m, ks[0]); log.append(str(ks[0].name) + r)
		if not r.begins_with("勝"): _strengthen(t); tm_alt += 1
		else: tm_alt = 0
	var ab = ZD.all_bosses_done(c)
	if not ab:
		var miss = []
		for z in ZD.of_type("wild"):
			if ZD.boss_next(str(z.id)) >= 0: miss.append("%s(霧%s)" % [str(z.id), "開" if ZD.revealed(str(z.id)) else "未開"])
		return "拔營卡住：野外王未清 %s" % str(miss)
	var fast = 0
	var MD = load("res://game/outpost/mv_data.gd")
	for i in MD.goals(c).size():
		if sim.goal_claimed(i): continue
		if not sim.claim(i): sim.st().goals_done.append(float(i)); fast += 1   # 測試加速：大排檔經營目標
	if fast: gifts.append([_qi(), "大排檔目標加速", fast])
	if not sim.can_move(): return "拔營卡住：can_move=false（cleared %d-3=%s）" % [c + 1, str(J.t(_S().cleared.get("%d-3" % (c + 1))))]
	var okm = sc.move_next(true)
	await _w(t, 2.0); await _skip(t, 8)
	await _w(t, 2.0); await _skip(t, 8)
	return "拔營→第%d關（%s；王：%s）" % [int(sim.ci()) + 1, str(okm), ",".join(log)]

# ================= play =================
func play(t) -> void:
	var m = await _boot(t)
	Engine.time_scale = TS
	CTL.attach(m)
	var stuck = []
	var last_qi = -1
	var lim = int(OS.get_environment("QA_N")) if OS.has_environment("QA_N") else 9999   # [qaudit2] 除錯：只做 N 個任務
	while lim > 0:
		lim -= 1
		await _skip(t, 2)
		J.mc(_Q(), "check", [])
		var q = _cur()
		if not (q is Dictionary): break
		var qi = _qi()
		if qi == last_qi:   # 同一個任務做完一輪都推唔郁
			stuck.append([qi, _qtext(q)])
			_chk("任務 %d「%s」可以推進" % [qi, _qtext(q)], false, "STUCK")
			if str(q.get("t", "")) == "stage":   # [qaudit2] 關卡卡住：後門當通關（唔係就之後拔營全部連環卡住），記低
				_S().cleared[str(q.s)] = true; gifts.append([qi, "後門通關", str(q.s)])
				J.mc(_Q(), "check", []); await _skip(t, 3)
			if _qi() == qi: _S()["qi"] = float(qi + 1)   # 測試後門：跳過，繼續搵後面問題（已報 BAD）
			last_qi = -1; continue
		last_qi = qi
		_snap(qi)
		var t0 = simt
		var bar = await _tap_bar(t, m)
		var how = ""
		match str(q.t):
			"chop": how = await _do_field(t, m, q, "tree")
			"rice": how = await _do_field(t, m, q, "paddy")
			"craftPlank", "craftBun": how = await _do_craft(t, q)
			"build": how = await _do_build(t, q)
			"bLevel": how = await _do_blevel(t, q)
			"level": how = await _do_level(t, q)
			"assign": how = await _do_assign(t, q)
			"ghostLv": how = await _do_ghostlv(t, q)
			"recruit": how = await _do_recruit(t, q)
			"drill": how = await _do_drill(t, q)
			"feast": how = await _do_feast(t, q)
			"stage": how = await _do_stage(t, m, q)
			"sell": how = await _do_sell(t, m, q)   # [onboard]
			"guard": how = await _do_guard(t, m, q)   # [onboard]
			_: how = "未知類型 " + str(q.t)
		await _skip(t, 3)
		J.mc(_Q(), "check", [])
		await _w(t, 0.3)
		var done = _qi() > qi
		rows.append([qi, _qtext(q), bar, how, int(simt - t0), "完成" if done else "未完成"])
		_p("Q%02d %s｜任務條:%s｜途徑:%s｜%ds｜%s" % [qi, _qtext(q), bar, how, int(simt - t0), "完成" if done else "未完成"])
		if done: ok += 1
	Engine.time_scale = 1.0
	var S = _S()
	_chk("主線全部做完（qi=%d/%d）" % [_qi(), (J.G.get("QUESTS") as Array).size()], _qi() >= (J.G.get("QUESTS") as Array).size())
	_chk("通關 6-3", J.t(S.cleared.get("6-3")))
	_chk("冇卡住嘅任務", stuck.is_empty(), stuck)
	_p("gifts %d 次（資源／好評／加速）" % gifts.size())
	for g in gifts: if str(g[1]) in ["大排檔目標加速", "後門通關"]: _p("  %s Q%d %s" % [str(g[1]), g[0], str(g[2])])
	_p("simtime %ds" % int(simt))
	_p("RESULT ok=%d bad=%d" % [ok, bad])

# ================= audit：任務文字 =================
const OLD_WORDS := ["夜班巡陰", "世界地圖", "地盤", "出村門", "村門", "巡陰"]
func audit(t) -> void:
	await _boot(t)
	var Q: Array = J.G.get("QUESTS"); var S = _S()
	var q0 = S.qi
	for i in Q.size():
		S["qi"] = float(i)
		var tx = _qtext(Q[i])
		var badw = OLD_WORDS.filter(func(w): return tx.contains(w))
		_chk("Q%02d 文字唔指舊入口：%s" % [i, tx], badw.is_empty(), badw)
	S["qi"] = q0
	_p("RESULT ok=%d bad=%d" % [ok, bad])
