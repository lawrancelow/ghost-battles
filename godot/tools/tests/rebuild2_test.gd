# [rebuild2] 荒村重建補驗（vil2 P2）：
#   1. 10 棟（ORDER 4＋LATER 6）每棟三態：廢墟 → 清理 → 搭棚（修復中）→ 開張；每態截圖（/tmp/rebuild2/shots/<棟>_<1ruin|2fix|3open>.png）
#   2. 化寶爐排第 4；後段 6 棟行舊建造流程鈎（build_hook）：未清唔起、清完扣錢搭棚、撳加快、時間到開張
#   3. 睡著的名鬼：倉庫第 1 堆挖出椰子砸死鬼 → 劇情 → 入村（只一次）
#   4. 生氣值：0 → 每開一棟 +1/10 → 1.0；冇 juice（J.G.juice_vitality 冇人寫）時村子畫面照用 rb.vitality()；有 juice 式 listener 時每次開張收到最新值
#   5. 全村點燈：10 棟開齊即點（唔使等兵營等後加建築），只點一次；村史館 8 件、集齊獎、存檔
# 用法：bash /home/claude/setup/edtest.sh <godot目錄> rebuild2 res://tools/tests/rebuild2_test.gd all 900
extends RefCounted

const RB = preload("res://game/rebuild/rb.gd")
const PF = preload("res://tools/tests/paddyfix_test.gd")
const SHOTS := "/tmp/rebuild2/shots/"
var ok := 0
var bad := 0

func _p(m): print("[rebuild2] ", m)
func _chk(name: String, cond: bool, extra = "") -> void:
	if cond: ok += 1; _p("ok  " + name + ("　" + str(extra) if str(extra) != "" else ""))
	else: bad += 1; _p("BAD " + name + ("　" + str(extra) if str(extra) != "" else ""))
func _w(t, s: float): await t.get_tree().create_timer(s).timeout
func _busy() -> bool: return J.t(J.mc(J.G.get("Story"), "busy", [])) or J.t(J.mc(J.G.get("UI"), "modalOpen", []))
# 好似玩家咁：有劇情就撳跳過、有彈窗就閂；回 true ＝ 而家撳得屏
func _clear_ui(t, m, tries := 40) -> bool:
	for i in tries:
		if not _busy(): return true
		var sn = m.get("story")
		if sn != null and sn.get("cur") is Dictionary:
			var ls = sn.cur.sc.get("lines", [])
			_p("（撳屏被擋）劇情 id=%s style=%s 第一句=%s" % [sn.cur.get("id"), sn.cur.sc.get("style", ""), str(ls[0]).left(70) if ls.size() > 0 else ""])
			sn.skip_scene()
		elif J.t(J.mc(J.G.get("UI"), "modalOpen", [])): _p("（撳屏被擋）彈窗 tab=%s" % str(J.gp(J.G.get("UI"), "tab")))
		J.mc(J.G.get("UI"), "close", [])
		if m.get("sheet") != null and J.t(J.mc(J.G.get("UI"), "modalOpen", [])): m.sheet.visible = false
		await _w(t, 0.2)
	return not _busy()
func _shot(t, m, name: String, at: Vector2):
	J.mc(J.G.get("Village"), "focus", [at.x, at.y])
	await _w(t, 2.4 if not name.ends_with("_1ruin") else 0.6)   # 等跳字散咗先影（測試一秒內撳十幾下，跳字會疊埋；真玩家唔會）
	await RenderingServer.frame_post_draw
	t.get_viewport().get_texture().get_image().save_png(SHOTS + name + ".png")
func _tap(x: float, y: float) -> void: J.mc(J.G.get("Village"), "tap", [x, y])
func _check() -> void: J.mc(J.G.get("Quest"), "check", [])
func _has_ghost(S, k: String) -> bool:
	for g in S.ghosts: if str(g.k) == k: return true
	return false

func all(t) -> void:
	DirAccess.make_dir_recursive_absolute(SHOTS)
	var pf = PF.new()
	var m = await pf._boot(t)
	var S: Dictionary = J.G.S
	RB.start_fresh(S, true)
	var ev := []
	var jv := []   # 模擬 juice：listener 入面讀 vitality 寫 J.G.juice_vitality
	RB.listen(func(k, a):
		ev.append([k, a])
		J.G["juice_vitality"] = {"v": RB.vitality()}; jv.append(RB.vitality()))
	J.G.erase("juice_vitality")
	await _w(t, 0.6)
	_chk("化寶爐排第 4", RB.ORDER.size() == 4 and RB.ORDER[3] == "furnace" and J.t(J.cl(J.G.get("bldUnlocked"), null, ["furnace"])), RB.ORDER)
	_chk("荒村 10 棟", RB.ALL.size() == 10)
	_chk("生氣值：開局 0", RB.opened_count() == 0 and is_zero_approx(RB.vitality()), "%d %.2f" % [RB.opened_count(), RB.vitality()])
	var nv = m.get("village")
	_chk("冇 juice：村子畫面 vit() 照用 rb.vitality()（安全退化）", J.G.get("juice_vitality") == null and nv != null and nv.has_method("vit") and is_zero_approx(float(nv.vit())), nv.vit() if nv != null and nv.has_method("vit") else "-")
	var had_sleeper = _has_ghost(S, RB.SLEEPER.k)
	var n_open := 0
	for b in RB.ALL:
		var later = b in RB.LATER
		var bp = RB._pos(b)
		_chk("%s：有位置" % b, bp != Vector2.ZERO, bp)
		await _clear_ui(t, m)
		# —— 一、廢墟 ——
		_chk("%s：廢墟（bld 0、未開、雜草密度滿）" % b, J.num(S.bld[b]) == 0 and not RB.is_open(b) and RB.holds(b) and RB.weed_k(b) > 0.99, "%s %.2f" % [S.bld[b], RB.weed_k(b)])
		await _shot(t, m, "%s_1ruin" % b, bp)
		await _clear_ui(t, m)
		_tap(bp.x, bp.y - 30)
		_chk("%s：未清雜物撳廢墟唔搭棚" % b, not RB.fixing(b))
		if later:
			_chk("%s：未清雜物建造鈎接手但唔起" % b, RB.build_hook(b) and not RB.fixing(b) and J.num(S.bld[b]) == 0)
		# —— 清理 ——
		var hits := 0
		for e in RB.piles():
			if e.b != b: continue
			for k in RB.HITS:
				if _busy(): await _clear_ui(t, m)
				_tap((e.p as Vector2).x, (e.p as Vector2).y - 4); hits += 1
				await _w(t, 0.04)
		_chk("%s：撳 %d 下清晒（雜草密度跌到最低）" % [b, hits], RB.cleared(b) and hits == RB.PILES[b].size() * RB.HITS and RB.weed_k(b) < 0.11, "%d %.2f" % [RB.left_of(b), RB.weed_k(b)])
		if b == "store":
			# 睡著的名鬼：劇情播完（玩家撳跳過／撳完）先入村
			for i in 50:
				var sn = m.get("story")
				if sn != null and sn.get("cur") != null: sn.skip_scene()
				await _w(t, 0.2)
				if _has_ghost(S, RB.SLEEPER.k): break
			_chk("睡著的名鬼：倉庫第 1 堆挖出椰子砸死鬼並入村", had_sleeper or _has_ghost(S, RB.SLEEPER.k), RB.SLEEPER.k)
			_chk("睡著的名鬼：有 sleeper 事件、只一次", had_sleeper or ev.filter(func(e): return e[0] == "sleeper").size() == 1, ev.filter(func(e): return e[0] == "sleeper"))
			var SD = load("res://game/soul/soul_data.gd")
			_chk("睡著的名鬼：唔會變成「去祭壇簽約」（祭壇仲係廢墟）", had_sleeper or (J.num(S.bld.altar) == 0 and not J.t(SD.st().dir.get(RB.SLEEPER.k)) and J.t(SD.st().got.get(RB.SLEEPER.k))), SD.st().dir)
			var n0 = S.ghosts.size(); RB._sleeper(); await _w(t, 0.3)
			_chk("睡著的名鬼：再叫唔會重複加", S.ghosts.size() == n0 and not J.t(J.mc(J.G.get("Story"), "busy", [])))
		await _clear_ui(t, m)
		# —— 二、搭棚 ——
		var cost: Dictionary = RB.COST[b] if not later else (J.G.BUILDINGS[b].get("build") if J.G.BUILDINGS[b].get("build") is Dictionary else {})
		if later: RB._costs(); cost = J.G.BUILDINGS[b].get("build") if J.G.BUILDINGS[b].get("build") is Dictionary else {}
		for k in cost: S.res[k] = J.num(cost[k]) + 5.0
		var before = S.res.duplicate()
		if later: _chk("%s：清完建造鈎接手" % b, RB.build_hook(b))
		else: _tap(bp.x, bp.y - 30)
		_chk("%s：開始搭棚、bld 仲係 0" % b, RB.fixing(b) and J.num(S.bld[b]) == 0, S.bld[b])
		var paid = true
		for k in cost: if not is_equal_approx(J.num(S.res[k]), J.num(before[k]) - J.num(cost[k])): paid = false
		_chk("%s：扣咗修復費 %s" % [b, cost], paid, S.res)
		if later:
			var r2 = S.res.duplicate(); RB.build_hook(b)
			_chk("%s：搭緊棚再撳建造唔會重複扣錢" % b, r2 == S.res)
		var fl0 = RB.fix_left(b)
		_tap(bp.x, bp.y - 30)
		_chk("%s：撳棚架加快 1 秒" % b, RB.fix_left(b) < fl0 - 0.5, "%.1f→%.1f" % [fl0, RB.fix_left(b)])
		RB.st().fix[b] = J.now() / 1000.0 + 9.0   # 截圖用：留足時間（唔影響邏輯）
		await _shot(t, m, "%s_2fix" % b, bp)
		_chk("%s：搭棚期間其他系統冇偷改 bld" % b, J.num(S.bld[b]) == 0 and RB.fixing(b), S.bld[b])
		RB.st().fix[b] = J.now() / 1000.0 + 0.3
		# —— 三、開張 ——
		for i in 60:
			_check(); await _w(t, 0.1)
			if RB.is_open(b): break
		n_open += 1
		_chk("%s：時間到開張（bld≥1、open 事件）" % b, RB.is_open(b) and J.num(S.bld[b]) >= 1 and not RB.fixing(b) and ev.has(["open", b]), S.bld[b])
		_chk("%s：生氣值 %d/10" % [b, n_open], RB.opened_count() == n_open and is_equal_approx(RB.vitality(), n_open / 10.0) and is_equal_approx(float(nv.vit()), n_open / 10.0), "%d %.2f" % [RB.opened_count(), RB.vitality()])
		_chk("%s：juice 接口收到最新生氣值" % b, J.G.get("juice_vitality") is Dictionary and is_equal_approx(float(J.G.juice_vitality.v), n_open / 10.0), J.G.get("juice_vitality"))
		if b == "furnace": _chk("四棟修完：rb.done、虛擬任務完", J.t(RB.st().get("done")) and not RB.on() and RB.cur_q() == null)
		await _w(t, 0.5); await _clear_ui(t, m)
		await _shot(t, m, "%s_3open" % b, bp)
	# —— 全村點燈 ——
	_check(); await _w(t, 0.6); _check()
	var BO = J.G.get("BLD_ORDER")
	_chk("全村點燈：10 棟開齊即點（BLD_ORDER 而家 %d 項，唔使等後加建築）" % (BO as Array).size(), RB.all_lit() and ev.has(["lit", null]) and is_equal_approx(RB.vitality(), 1.0))
	for i in 4: _check(); await _w(t, 0.3)
	_chk("全村點燈：只點一次", ev.filter(func(e): return e[0] == "lit").size() == 1)
	_chk("荒村做完：冇雜物、冇廢墟 hold", RB.piles().is_empty() and RB.ALL.all(func(b): return not RB.holds(b)))
	# —— 村史館 ——
	var c0 = J.num(S.res.coins)
	var r0 = RB.relics().size()
	for i in 12: RB._relic(Vector2(200, 400))
	_chk("村史館：8 件唔重複", RB.relics().size() == 8 and ev.filter(func(e): return e[0] == "relic").size() >= 8 - r0, RB.relics())
	_chk("村史館：集齊有冥幣獎（只一次）", (r0 == 8) or (J.num(S.res.coins) >= c0 + 200 and J.num(S.res.coins) < c0 + 400), J.num(S.res.coins) - c0)
	# 提示排隊：一個一個出（每 NOTE_GAP 秒），劇情／彈窗期間唔出，最後出晒
	var nl = RB.notes_left()
	_chk("提示排隊：有嘢排緊", nl >= 2, nl)
	await _clear_ui(t, m)
	for i in int((nl + 2) * RB.NOTE_GAP / 0.5) + 10:
		if _busy(): await _clear_ui(t, m, 3)
		_check(); await _w(t, 0.5)
		if RB.notes_left() == 0: break
	_chk("提示排隊：最後全部顯示完", RB.notes_left() == 0, RB.notes_left())
	var js = JSON.parse_string(J.to_json(S))
	_chk("存檔：rb（done／lit／sleeper／relics 8／open 10）", js is Dictionary and js.get("rb") is Dictionary and J.t(js.rb.get("done")) and J.t(js.rb.get("lit")) and J.t(js.rb.get("sleeper")) and (js.rb.get("relics") as Array).size() == 8 and (js.rb.get("open") as Dictionary).size() == 10)
	_p("RESULT ok=%d bad=%d" % [ok, bad])
