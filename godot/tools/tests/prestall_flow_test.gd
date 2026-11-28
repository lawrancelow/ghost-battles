# [int-prestall] 大排檔前大更新：新流程機器人走查（程序組 IX 整合用）
# 用法：edtest.sh <godot目錄> pflow res://tools/tests/prestall_flow_test.gd all 1500
#   新存檔 → ① 新開場（SCENES op2_*）→ ② 荒村重建（game/rebuild/rb.gd）→ ③ KPI 第一區（game/kpi/kpi_data.gd）→ ④ 陰間酒館（game/tavern）
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

# ① 新開場：黃泉路→大堂→龐總辦公室→孟婆遞湯→流放→到荒村（opening 分支：SCENES op2_*／opf2_*）
func _opening(t) -> void:
	_p("① 新開場")
	var SC = J.G.get("SCENES")
	if not (SC is Dictionary) or not SC.has("op2_soup"):
		_skip("新開場", "SCENES 冇 op2_*（opening 分支未合入）")
		return
	var M := ["op2_road", "op2_lobby", "op2_office", "op2_soup", "op2_exile", "op2_arrive"]
	var F := ["opf2_road", "opf2_lobby", "opf2_office", "opf2_soup", "opf2_exile", "opf2_arrive"]
	_chk("男主開場 6 段齊", M.all(func(i): return SC.has(i)), M.filter(func(i): return not SC.has(i)))
	_chk("女主開場 6 段齊", F.all(func(i): return SC.has(i)), F.filter(func(i): return not SC.has(i)))
	for pair in [[M, "男"], [F, "女"]]:
		var seen := {}; var dup := []; var n := 0
		for id in pair[0]:
			if not SC.has(id): continue
			for l in SC[id].get("lines", []):
				var s = str(l[1]) if l is Array and l.size() > 1 else str(l)
				n += 1
				if seen.has(s): dup.append(s)
				seen[s] = true
		_chk("開場對白非空、無重複句（%s）" % pair[1], n > 0 and dup.is_empty(), "%d 句 重複%s" % [n, str(dup)])
	var ms = str(SC.get("op2_soup", {}).get("lines", [])); var fs = str(SC.get("opf2_soup", {}).get("lines", []))
	_chk("男女主孟婆場唔係同一份對白", ms != fs)

# ② 荒村重建：開局廢墟、清理堆、搭棚、開張（vil2：game/rebuild/rb.gd）
func _rebuild(t) -> void:
	_p("② 荒村重建")
	var P := "res://game/rebuild/rb.gd"
	if not _has(P):
		_skip("荒村重建", "game/rebuild/rb.gd 未合入")
		return
	var RB = load(P)
	RB.start_fresh(_S(), true)   # GB_TEST 下荒村預設關：用測試開關開新荒村
	var bld = _S().bld
	_chk("新存檔：鬼宅、伐木場、糯米田係廢墟", J.num(bld.get("house", 1)) == 0 and J.num(bld.get("wood", 1)) == 0 and J.num(bld.get("rice", 1)) == 0, {"house": bld.get("house"), "wood": bld.get("wood"), "rice": bld.get("rice")})
	var piles = RB.piles()
	_chk("村內有清理堆", piles.size() >= 10, piles.size())
	_chk("任務排頭係清理", RB.cur_q() != null and str(RB.cur_q().get("t")) == "rb_clear", RB.cur_q())
	var hp = piles.filter(func(e): return e.b == "house")
	var before = J.num(_S().res.get("wood", 0)) + J.num(_S().res.get("rice", 0)) + J.num(_S().res.get("coins", 0))
	var vil = J.G.get("Village")
	for e in hp:
		for k in RB.HITS:
			RB.tap(vil, (e.p as Vector2).x, (e.p as Vector2).y - 4)
	var after = J.num(_S().res.get("wood", 0)) + J.num(_S().res.get("rice", 0)) + J.num(_S().res.get("coins", 0))
	_chk("清鬼宅雜物：有資源回饋、清晒", after > before and RB.cleared("house"), "%s→%s 剩%d" % [before, after, RB.left_of("house")])
	_chk("生氣值 0–1", RB.vitality() >= 0.0 and RB.vitality() <= 1.0, RB.vitality())
	await _shot(t, "rebuild")

# ③ KPI 第一區：閘門、指標、賄賂三檔、逾期＝中（Bryan 搶功＋橫幅）（kpi 分支：game/kpi/kpi_data.gd）
func _kpi(t) -> void:
	_p("③ KPI 第一區")
	var P := "res://game/kpi/kpi_data.gd"
	if not _has(P):
		_skip("KPI 閘門", "game/kpi/kpi_data.gd 未合入")
		return
	var K = load(P)
	K.enable(true)
	var gl = K.gates()
	_chk("有考核閘門", gl is Array and gl.size() >= 1, gl.size() if gl is Array else gl)
	if not (gl is Array) or gl.is_empty(): return
	var gid = str(gl[0].id)
	var pr = K.progress(gid)
	_chk("第一閘門指標 2–3 項", pr is Array and pr.size() >= 2 and pr.size() <= 3, pr)
	for tier in ["snack", "watch", "car"]:
		_chk("賄賂檔次 %s 有定義、有價" % tier, not K.bribe_def(tier).is_empty() and not K.bribe_cost(tier).is_empty(), K.bribe_cost(tier))
	K.start(gid)
	var od = K.overdue(gid)
	_chk("逾期＝中檔：Bryan 搶功", str(od.get("kind", "")) == "bryan", od)
	_chk("逾期後村口掛 Bryan 橫幅", K.banner_on(), K.banner_on())
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
