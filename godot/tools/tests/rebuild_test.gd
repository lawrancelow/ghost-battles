# [rebuild] 荒村重建 P1 測試（設計 docs/PreStall_Design_v1.md）
#   1. 開荒村：鬼宅／伐木場／糯米田＝0，虛擬任務排頭（清理鬼宅周圍）
#   2. 經玩家撳（Village.tap → v_tap）清雜物：每下有資源入帳、清完任務前進
#   3. 撳廢墟：未清唔修得；清完交料搭棚；撳棚加快；時間到開張（bld＝1）、任務前進
#   4. 次序：未修好鬼宅撳伐木場唔郁；三棟修完 → 虛擬任務冇咗，返去正式主線（S.qi 冇郁過）
#   5. 存讀檔：S.rb 寫得入 JSON；舊存檔（冇 S.rb）完全唔受影響
# 用法：bash tools/devkit/edtest.sh <godot目錄> rebuild res://tools/tests/rebuild_test.gd all 600
extends RefCounted

const RB = preload("res://game/rebuild/rb.gd")
const PF = preload("res://tools/tests/paddyfix_test.gd")
const SHOTS := "/tmp/rebuild/shots/"
var ok := 0
var bad := 0

func _p(m): print("[rebuild] ", m)
func _chk(name: String, cond: bool, extra = "") -> void:
	if cond: ok += 1; _p("ok  " + name + ("　" + str(extra) if str(extra) != "" else ""))
	else: bad += 1; _p("BAD " + name + ("　" + str(extra) if str(extra) != "" else ""))
func _w(t, s: float): await t.get_tree().create_timer(s).timeout
func _shot(t, m, name: String, at: Vector2):
	var v = m.get("village")
	if v != null and v.has_method("zone_cam") and v.zone_cam() != null: v.zone_cam().center_on(at) if v.zone_cam().has_method("center_on") else null
	J.mc(J.G.get("Village"), "focus", [at.x, at.y])
	await _w(t, 0.6)
	await RenderingServer.frame_post_draw
	t.get_viewport().get_texture().get_image().save_png(SHOTS + name + ".png"); _p("shot " + name)

func _tap(x: float, y: float) -> void: J.mc(J.G.get("Village"), "tap", [x, y])
func _q(): return J.mc(J.G.get("Quest"), "cur", [])
func _check() -> void: J.mc(J.G.get("Quest"), "check", [])

func all(t) -> void:
	DirAccess.make_dir_recursive_absolute(SHOTS)
	var pf = PF.new()
	var m = await pf._boot(t)
	var S: Dictionary = J.G.S
	var qi0 = J.num(S.qi)
	# 舊存檔：冇 rb
	_chk("舊存檔：冇 S.rb → 虛擬任務 null", RB.cur_q() == null and not RB.on())
	# 開荒村
	RB.start_fresh(S, true)
	var z = true
	for b in RB.ALL: if J.num(S.bld.get(b, 0)) != 0: z = false
	_chk("開荒村：10 棟都係 0", z, S.bld)
	_chk("化寶爐一開始已解鎖（排第 4）", J.t(J.cl(J.G.get("bldUnlocked"), null, ["furnace"])))
	var q = _q()
	_chk("任務排頭：清理鬼宅", q != null and str(q.get("t")) == "rb_clear" and str(q.b) == "house", str(q))
	await _shot(t, m, "01_ruins", RB._pos("house"))
	for i in 60:
		var h0 = J.num(S.bld.house); await t.get_tree().process_frame
		if J.num(S.bld.house) != h0: _chk("重建期間鬼宅唔會被其他系統改（frame %d）" % i, false, "%s→%s" % [h0, S.bld.house]); break
	_chk("重建期間鬼宅保持廢墟", J.num(S.bld.house) == 0, S.bld.house)
	# 未清就撳鬼宅
	_tap(RB._pos("house").x, RB._pos("house").y - 30)
	_chk("未清雜物：撳鬼宅唔搭棚", not RB.fixing("house"))
	# 撳伐木場（未輪到）
	_tap(RB._pos("wood").x, RB._pos("wood").y - 30)
	_chk("未輪到：撳伐木場唔郁", not RB.fixing("wood"))
	for b in RB.ORDER:
		var r0 = S.res.duplicate()
		for _w9 in 40:   # 等劇情／彈窗（例如開張後嘅教程對白）完咗先撳
			if not J.t(J.mc(J.G.get("Story"), "busy", [])) and not J.t(J.mc(J.G.get("UI"), "modalOpen", [])): break
			var Stn = J.G.get("Story")
			var cid = "-"
			var sn = m.get("story") if m is Object else null
			if sn != null: cid = (str(sn.cur.get("id")) + "/" + str(sn.cur.sc.get("style", "")) if sn.cur is Dictionary else "null") + " q=" + str(sn.q.map(func(e): return e.sc if e.sc is String else "obj")) + " wa=" + str(sn.get("wa") != null)
			if _w9 % 8 == 0: _p("wait busy=%s modal=%s cur=%s" % [J.mc(Stn, "busy", []), J.mc(J.G.get("UI"), "modalOpen", []), cid])
			J.mc(Stn, "skipScene" if Stn is Dictionary else "skip_scene", []); J.mc(J.G.get("UI"), "close", [])
			await _w(t, 0.25)
		var hits := 0
		var HDd = J.G.get("HeroDaily"); var V0 = J.G.get("Village")
		_p("dbg %s active=%s on=%s left=%d story=%s modal=%s hd=%s" % [b, RB.active(), RB.on(), RB.left_of(b), J.mc(J.G.get("Story"), "busy", []), J.mc(J.G.get("UI"), "modalOpen", []), J.mc(HDd, "tap", [V0, -9999.0, -9999.0]) if HDd != null else "-"])
		for e in RB.piles():
			if e.b != b: continue
			for k in RB.HITS:
				_tap((e.p as Vector2).x, (e.p as Vector2).y - 4); hits += 1
				await _w(t, 0.05)
		var gain = 0.0
		for k in ["wood", "rice", "coins"]: gain += J.num(S.res[k]) - J.num(r0.get(k, 0))
		_chk("%s：撳 %d 下清晒、有資源入帳（+%d）" % [b, hits, int(gain)], RB.cleared(b) and gain >= hits, RB.left_of(b))
		_check(); await _w(t, 0.6)
		q = _q()
		_chk("%s：任務前進到修復" % b, q != null and str(q.get("t")) == "rb_fix" and str(q.b) == b, str(q))
		if b == "house": await _shot(t, m, "02_house_cleared", RB._pos(b))
		for k in RB.COST[b]: S.res[k] = maxf(J.num(S.res[k]), J.num(RB.COST[b][k]) + 2)
		var before = S.res.duplicate()
		_tap(RB._pos(b).x, RB._pos(b).y - 30)
		_chk("%s：撳廢墟開始搭棚" % b, RB.fixing(b))
		for k in RB.COST[b]: _chk("%s：扣咗 %s" % [b, k], J.num(S.res[k]) == J.num(before[k]) - J.num(RB.COST[b][k]))
		var fl0 = RB.fix_left(b)
		_tap(RB._pos(b).x, RB._pos(b).y - 30)
		_chk("%s：撳棚架加快" % b, RB.fix_left(b) < fl0 - 0.5, "%.1f→%.1f" % [fl0, RB.fix_left(b)])
		if b == "house": await _shot(t, m, "03_scaffold", RB._pos(b))
		for i in 80:
			_check(); await _w(t, 0.1)
			if J.num(S.bld[b]) > 0: break
		_chk("%s：時間到開張（bld≥1）" % b, J.num(S.bld[b]) >= 1, S.bld[b])
		_check(); await _w(t, 0.6)
		if b == "house": await _shot(t, m, "04_house_open", RB._pos(b))
	_chk("四棟（含化寶爐）修完：rb.done", J.t(RB.st().get("done")) and not RB.on())
	_chk("接口：opened_count ≥ 3、vitality 0–1", RB.opened_count() >= 3 and RB.vitality() > 0 and RB.vitality() <= 1.0, "%d %.2f" % [RB.opened_count(), RB.vitality()])
	# 後段：棺材鋪跟舊建造流程（建築卡「建造」）
	var N = J.gp(J.G.get("UI"), "_n")
	var b2 = "plank"
	var r1 = J.mc(N, "bldAct", [b2, "build", null])
	_chk("後段：未清雜物撳建造唔起（唔扣錢、唔搭棚）", not RB.fixing(b2) and J.num(S.bld[b2]) == 0, r1)
	for e in RB.piles():
		if e.b != b2: continue
		for k in RB.HITS: _tap((e.p as Vector2).x, (e.p as Vector2).y - 4); await _w(t, 0.03)
	_chk("後段：棺材鋪雜物清晒", RB.cleared(b2))
	S.res.wood = 999.0; S.res.planks = 999.0; S.res.coins = 999.0; S.res.rice = 999.0
	var w0 = J.num(S.res.wood)
	J.mc(N, "bldAct", [b2, "build", null])
	_chk("後段：撳建造 → 扣錢、搭棚、bld 仲係 0", RB.fixing(b2) and J.num(S.bld[b2]) == 0 and J.num(S.res.wood) < w0, "%s %s" % [S.bld[b2], S.res.wood])
	await _shot(t, m, "06_plank_scaffold", RB._pos(b2))
	for i in 120:
		_check(); await _w(t, 0.1)
		if RB.is_open(b2): break
	_chk("後段：時間到開張", RB.is_open(b2) and J.num(S.bld[b2]) >= 1)
	_chk("後段：民宅修復費改棺材板 30", J.num(J.G.BUILDINGS.home.build.get("planks", 0)) == 30.0, J.G.BUILDINGS.home.build)
	# 睡著的名鬼：倉庫第 1 堆
	var had = false
	for g in S.ghosts: if str(g.k) == RB.SLEEPER.k: had = true
	for e in RB.piles():
		if e.id != RB.SLEEPER.pile: continue
		for k in RB.HITS: _tap((e.p as Vector2).x, (e.p as Vector2).y - 4); await _w(t, 0.03)
	await _w(t, 0.5)
	await _shot(t, m, "07_sleeper", RB._pos("store"))
	for i in 60:
		await pf._skip(t)
		await _w(t, 0.2)
		var got = false
		for g in S.ghosts: if str(g.k) == RB.SLEEPER.k: got = true
		if got: break
	var got2 = false
	for g in S.ghosts: if str(g.k) == RB.SLEEPER.k: got2 = true
	_chk("睡著的名鬼：挖出椰子砸死鬼並入村", had or got2, RB.SLEEPER.k)
	# 村史館：連挖 8 件集齊有獎、唔重複
	var ev = []
	RB.listen(func(k, a): ev.append(k))
	var c0 = J.num(S.res.coins); var r0 = RB.relics().size()
	for i in 10: RB._relic(Vector2(200, 400))
	_chk("提示排隊：唔會即刻全部彈出", RB.notes_left() >= 2, RB.notes_left())
	_chk("村史館：8 件唔重複、集齊", RB.relics().size() == 8, RB.relics())
	_chk("村史館：集齊有冥幣獎", J.num(S.res.coins) >= c0 + 200)
	_chk("接口：listen 收到 relic 事件（新挖 %d 件）" % (8 - r0), ev.count("relic") == 8 - r0, ev.size())
	# 全村點燈：10 棟開張
	for id in J.G.get("BLD_ORDER"): S.bld[id] = maxf(1.0, J.num(S.bld.get(id, 0)))
	_check(); await _w(t, 0.6)
	_chk("全村點燈：10 棟開張 → lit＋事件", RB.all_lit() and "lit" in ev, ev)
	for i in 40:
		_check(); await _w(t, 0.5)
		if RB.notes_left() == 0: break
	_chk("提示排隊：最後全部顯示完", RB.notes_left() == 0, RB.notes_left())
	# 粵語只喺粵語欄：書面模式下村史館文字唔准有粵語字
	var bad_y = []
	for e in RB.RELICS:
		for w in ["咗", "嘅", "嗰", "喺", "嚟", "係", "住"]:
			if (e[2] + e[4]).contains(w): bad_y.append(e[0] + ":" + w)
	_chk("村史館書面中文欄冇粵語字", bad_y.is_empty(), bad_y)
	q = _q()
	_chk("返正式主線：S.qi 冇郁過、任務唔係 rb", J.num(S.qi) == qi0 and q != null and not J.t(q.get("rb")), str(q.get("text")) if q != null else "null")
	var js = JSON.parse_string(J.to_json(S))
	_chk("存檔 JSON 有 rb", js is Dictionary and js.get("rb") is Dictionary and J.t(js.rb.get("done")))
	await _shot(t, m, "05_done", RB._pos("rice"))
	_p("RESULT ok=%d bad=%d" % [ok, bad])
