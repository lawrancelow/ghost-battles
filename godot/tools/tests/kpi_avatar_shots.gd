# [kpi] 六位考核官頭像實機截圖：逐個閘門開考核卡，影頂部（頭像出圈）＋ A 區霧上考核牌
# 用法：UX_OUT=/tmp/kpi/av/ bash tools/devkit/edtest.sh <godot目錄> kpiav res://tools/tests/kpi_avatar_shots.gd all 600
extends RefCounted
const KG = preload("res://game/kpi/kpi_data.gd")
const KU = preload("res://game/kpi/kpi_ui.gd")
const KT = preload("res://tools/tests/kpi_test.gd")
var ok := 0
var bad := 0
func all(t) -> void:
	var k = KT.new()
	var eo = OS.get_environment("UX_OUT")
	if eo != "": k.SHOTS = eo
	DirAccess.make_dir_recursive_absolute(k.SHOTS)
	var m = await k.PF.new()._boot(t)
	KU.play_fn = func(sc, cb): if cb.is_valid(): cb.call()
	k._reset_state(); k._rich()
	await k._w(t, 4.0)
	for g in KG.gates(0):
		var gid = str(g.id)
		KG.start(gid); KG.gs(gid).left = 734.0
		KU._sheet(m, gid); await k._w(t, 0.5); await k._shot(t, "sheet_" + str(g.boss))
		if Spr.ok("kpi_boss_" + str(g.boss)): ok += 1
		else: bad += 1
		m.close_sheet(); await k._w(t, 0.2)
	KU.play_fn = Callable()
	print("[kpiav] RESULT ok=%d bad=%d" % [ok, bad])
