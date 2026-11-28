# [int-prestall] 大排檔前大更新：新流程機器人走查（程序組 IX 整合用）
# 用法：edtest.sh <godot目錄> pflow res://tools/tests/prestall_flow_test.gd all 1500
#   新存檔 → ① 新開場（opening）→ ② 荒村重建（game/rebuild/rb.gd）→ ③ KPI 第一區（game/kpi/kpi.gd）→ ④ 陰間酒館（game/tavern）
#   各模塊未合入時記「未接」（唔當失敗），已接就逐項驗；最後印 RESULT rows/bad/skip
#   只用模塊公開函數（有就用），唔直接改 S 入面嘅進度，盡量貼近玩家路徑；截圖 /home/claude/meeting/int/shots/
extends RefCounted

const SH := "/home/claude/meeting/int/shots/"
var bad := 0
var rows := 0
var skip := 0
var shots := 0
var notes := []

func _p(s) -> void: print("[pflow] ", s)
func _chk(name: String, cond: bool, info = "") -> void:
	rows += 1
	if not cond: bad += 1
	print("[pflow]   %-44s %s %s" % [name, "OK" if cond else "<<< 唔對", str(info)])
func _skip(name: String, why: String) -> void:
	skip += 1
	notes.append(name + "：" + why)
	print("[pflow]   %-44s 未接 %s" % [name, why])
func _S(): return J.G.get("S")
func _has(path: String) -> bool: return ResourceLoader.exists(path)
func _call(o, fn: String, args := []):
	if o == null or not o.has_method(fn): return null
	return o.callv(fn, args)

func _shot(t, name: String) -> void:
	DirAccess.make_dir_recursive_absolute(SH)
	await RenderingServer.frame_post_draw
	shots += 1
	var fn = SH + "pflow_%02d_%s.jpg" % [shots, name]
	t.get_viewport().get_texture().get_image().save_jpg(fn, 0.85)
	_p("shot " + fn)

func _wait(t, sec: float) -> void:
	await t.get_tree().create_timer(sec, true, false, true).timeout

func all(t) -> void:
	await _opening(t)
	await _rebuild(t)
	await _kpi(t)
	await _tavern(t)
	_p("未接模塊：%s" % (", ".join(notes) if notes.size() else "（無）"))
	_p("RESULT rows=%d bad=%d skip=%d ok=%d" % [rows, bad, skip, rows - bad])

func logic(t) -> void:
	await all(t)

# ① 新開場：黑白無常→龐總辦公室→孟婆遞湯→流放→到村
func _opening(t) -> void:
	_p("① 新開場")
	var P := "res://game/opening/opening.gd"
	if not _has(P):
		_skip("新開場", "game/opening/opening.gd 未合入（opening 分支）")
		return
	var O = load(P)
	var beats = _call(O, "beats")
	_chk("開場有分鏡清單", beats is Array and beats.size() >= 4, beats.size() if beats is Array else beats)
	if beats is Array:
		var ids = beats.map(func(b): return str(b.get("id", "")) if b is Dictionary else str(b))
		_chk("開場含孟婆遞湯", ids.any(func(i): return "soup" in i or "孟婆" in i), ids)
		_chk("開場含流放到村", ids.any(func(i): return "exile" in i or "流放" in i), ids)
	for fem in [false, true]:
		var lines = _call(O, "lines", [fem])
		if lines == null: _skip("開場對白（%s）" % ("女" if fem else "男"), "opening.lines() 未提供"); continue
		_chk("開場對白非空（%s）" % ("女" if fem else "男"), lines is Array and lines.size() > 0, lines.size() if lines is Array else lines)
		var seen := {}
		var dup := []
		for l in lines:
			var s = str(l.get("t", l)) if l is Dictionary else str(l)
			if seen.has(s): dup.append(s)
			seen[s] = true
		_chk("開場對白無重複句（%s）" % ("女" if fem else "男"), dup.is_empty(), dup)
	var ml = _call(O, "lines", [false]); var fl = _call(O, "lines", [true])
	if ml is Array and fl is Array:
		_chk("男女主開場不是同一份對白", str(ml) != str(fl))

# ② 荒村重建：開局廢墟、清理堆、三步重建、外觀變新
func _rebuild(t) -> void:
	_p("② 荒村重建")
	var P := "res://game/rebuild/rb.gd"
	if not _has(P):
		_skip("荒村重建", "game/rebuild/rb.gd 未合入（vil2 分支 P1 進行中）")
		return
	var RB = load(P)
	var ruins = _call(RB, "ruined_list")
	_chk("新存檔有廢墟建築", ruins is Array and ruins.size() >= 3, ruins)
	var piles = _call(RB, "piles")
	_chk("村內有清理堆", piles is Array and piles.size() >= 10, piles.size() if piles is Array else piles)
	if piles is Array and piles.size():
		var pid = piles[0].get("id") if piles[0] is Dictionary else piles[0]
		var before = J.num(_S().res.get("wood", 0)) + J.num(_S().res.get("rice", 0)) + J.num(_S().res.get("coins", 0))
		for i in 6: _call(RB, "tap_pile", [pid])
		var after = J.num(_S().res.get("wood", 0)) + J.num(_S().res.get("rice", 0)) + J.num(_S().res.get("coins", 0))
		_chk("點清理堆有資源回饋", after > before, "%s→%s" % [before, after])
	if ruins is Array and ruins.size():
		var bid = ruins[0]
		var st0 = _call(RB, "state", [bid])
		_chk("第一棟初始＝廢墟", str(st0) in ["ruin", "ruined", "廢墟"], st0)
		_call(RB, "restore", [bid])
		var st1 = _call(RB, "state", [bid])
		await _wait(t, 9.0)
		var st2 = _call(RB, "state", [bid])
		_chk("修復後外觀推進（廢墟→修復中→完成）", str(st2) != str(st0), "%s→%s→%s" % [st0, st1, st2])
	await _shot(t, "rebuild")

# ③ KPI 第一區：考核牌、指標、賄賂、逾期（中檔：Bryan 搶功）
func _kpi(t) -> void:
	_p("③ KPI 第一區")
	var P := "res://game/kpi/kpi.gd"
	if not _has(P):
		_skip("KPI 閘門", "game/kpi/kpi.gd 未合入（kpi 分支）")
		return
	var K = load(P)
	var zid = _call(K, "first_zone")
	_chk("有第一個考核區", zid != null and str(zid) != "", zid)
	var goals = _call(K, "goals", [zid])
	_chk("考核指標 2–3 項", goals is Array and goals.size() >= 2 and goals.size() <= 3, goals)
	_chk("未達標時區域未開", _call(K, "is_open", [zid]) == false)
	var pen = _call(K, "penalty_tier")
	if pen != null: _chk("逾期懲罰＝中（老闆定案）", str(pen) in ["mid", "中", "medium"], pen)
	else: _skip("逾期懲罰檔次", "kpi.penalty_tier() 未提供")
	var br = _call(K, "bribe_options", [zid])
	_chk("有三檔賄賂", br is Array and br.size() == 3, br.size() if br is Array else br)
	await _shot(t, "kpi")

# ④ 陰間酒館：名單、刷新、招募、夜宵罷工（tavern 分支已合入，做串接檢查）
func _tavern(t) -> void:
	_p("④ 陰間酒館")
	var P := "res://game/tavern/tavern.gd"
	if not _has(P):
		_skip("陰間酒館", "game/tavern/tavern.gd 未合入")
		return
	var TV = load(P)
	_chk("酒館模塊可用", TV.has_method("on"))
	if not TV.on():
		_skip("酒館開關", "tavern.on() = false（存檔未就緒或開關關閉）")
		return
	var lst = TV.refresh(false)
	_chk("酒館名單有普通鬼", lst is Array and lst.size() > 0, lst.size() if lst is Array else lst)
	if lst is Array and lst.size():
		var c = TV.can_recruit(0)
		_chk("可查詢招募條件", c is Dictionary, c)
		_chk("招募費用 > 0（冥幣）", TV.cost_of(lst[0]) > 0, TV.cost_of(lst[0]))
	_chk("夜宵費用可計算", TV.meal_cost() >= 0, TV.meal_cost())
	var JS = load("res://game/joss/joss.gd") if _has("res://game/joss/joss.gd") else null
	_chk("化寶爐模塊存在（前期冥幣來源）", JS != null)
	await _shot(t, "tavern")
