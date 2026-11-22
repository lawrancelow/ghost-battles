# [perf] 第一期效能：主角描邊 shader、靜態烘圖、霧併入暗影 shader、流暢模式開關（存設定、切返冇殘留）
extends RefCounted
var ok := 0
var bad := 0
func _w(t, s: float): await t.get_tree().create_timer(s).timeout
func _ck(c: bool, msg: String) -> void:
	if c: ok += 1
	else: bad += 1; print("[perf] BAD ", msg)
func all(t) -> void:
	var m = null
	for i in 120:
		await _w(t, 0.5)
		m = t.get_tree().root.get_node_or_null("Main")
		if m and m.get("loading") == null and J.G.get("S") is Dictionary: break
	await _w(t, 1.5)
	m._hide_title(); await _w(t, 1.0)
	for i in 12:
		if m.story.cur != null: m.story.skip_scene()
		await _w(t, 0.25)
	var nv = m.village
	var PM = load("res://ui/perf_mode.gd"); var NB = load("res://ui/nv_bake.gd"); var VS = load("res://game/village_style.gd")
	nv.zone_cam().center_on(Vector2(J.num(J.G.Village.hero.x), J.num(J.G.Village.hero.y)))
	await _w(t, 2.0)
	# 1. 主角描邊：CanvasGroup + shader，舊 6 次重播節點收埋
	var hg = nv.ysort.get_node_or_null("hero_grp")
	_ck(hg != null and hg.visible, "主角描邊群組唔見")
	_ck(hg != null and hg.material is ShaderMaterial and str((hg.material as ShaderMaterial).shader.code).contains("offs[6]"), "描邊 shader 唔啱")
	_ck(nv.hero_ol == null or not nv.hero_ol.visible, "舊描邊（重播 6 次）仲喺度畫")
	if hg != null:
		var n = hg.get_meta("node"); var r: Recorder = n.get_meta("rec")
		_ck(r.cmds.size() > 5, "主角冇錄到筆")
		_ck(absf(hg.position.y - J.num(J.G.Village.hero.y)) < 1.0, "主角群組 y 排序位唔啱")
	# 2. 靜態烘圖
	_ck(NB.stats.bake > 5, "烘圖次數太少 %d" % NB.stats.bake)
	_ck(NB.stats.hit > 50, "用烘圖次數太少 %d" % NB.stats.hit)
	var b0 = NB.stats.bake
	await _w(t, 1.5)
	_ck(NB.stats.bake - b0 <= 2, "鏡頭唔郁都不停重烘 %d" % (NB.stats.bake - b0))
	# 3. 霧併入暗影 shader；血霧層熄咗唔畫
	var dk = nv.world.get_node_or_null("va_dark")
	_ck(dk != null and dk.visible, "暗影層唔見")
	_ck(dk != null and str((dk.material as ShaderMaterial).shader.code).contains("mcol"), "暗影 shader 冇霧")
	var vm = nv.world.get_node_or_null("va_mist")
	_ck(vm != null and not vm.visible, "血霧層仲喺度每格畫")
	_ck(VS.mist_pts.size() <= 16, "霧團多過 shader 位")
	# 4. 流暢模式：開
	PM.set_on(true, m)
	await _w(t, 1.0)
	var tr = nv.get_node_or_null("perf_lowres")
	_ck(tr != null, "流暢模式冇低解像度層")
	_ck(tr != null and nv.world.get_parent() is SubViewport, "世界冇搬入 SubViewport")
	if tr != null:
		var vp: SubViewport = tr.get_node("vp")
		var fs = nv.get_viewport().get_final_transform().get_scale().x
		_ck(absi(vp.size.x - int(round(nv.size.x * fs * 0.75))) <= 1, "內部解像度唔係 0.75：%s" % str(vp.size))
	_ck(Engine.max_fps == 30, "冇鎖 30 幀")
	_ck(FileAccess.get_file_as_string("user://perf_mode.txt").strip_edges() == "1", "設定冇存")
	PM._loaded = false; PM.on = false; PM.load_pref()
	_ck(PM.on, "重讀設定唔記得")
	_ck(PM.label().contains("開"), "掣字唔啱")
	await _w(t, 1.0)
	_ck(hg != null and hg.visible, "流暢模式主角描邊唔見")
	# 5. 流暢模式：關（冇殘留）
	PM.set_on(false, m)
	await _w(t, 0.5)
	_ck(nv.get_node_or_null("perf_lowres") == null or nv.get_node("perf_lowres").is_queued_for_deletion(), "關咗仲有低解像度層")
	_ck(nv.world.get_parent() == nv, "世界冇搬返出嚟")
	_ck(Engine.max_fps == 0, "關咗仲鎖幀")
	_ck(FileAccess.get_file_as_string("user://perf_mode.txt").strip_edges() == "0", "關咗設定冇存")
	# 6. 開關之後村子照常：撳地圖、主角照畫
	await _w(t, 1.0)
	_ck(hg != null and hg.visible and is_instance_valid(hg), "開關之後主角唔見")
	_ck(nv.world.get_index() < nv.get_child_count(), "世界層次")
	# 7. 大排檔：名牌／HUD 烘圖（MB）
	var MB = load("res://game/outpost/mv_bake.gd")
	nv.zone_cam().center_on(load("res://game/zone/zone_data.gd").zrect("market").get_center())
	await _w(t, 2.5)
	var h0 = MB.stats.hit
	await _w(t, 1.0)
	_ck(MB.stats.hit - h0 > 20, "大排檔名牌冇用烘圖 %d" % (MB.stats.hit - h0))
	var mvs = nv.find_child("MvScene", true, false)
	_ck(mvs != null and mvs.has_meta("mvbake") and (mvs.get_meta("mvbake") as Dictionary).keys().any(func(k): return str(k).begins_with("pl:")), "冇名牌烘圖")
	_ck(mvs != null and mvs._plates.size() > 0, "名牌位（_plates）冇登記")
	# 8. 安全畫面模式：烘圖全部停，逐格畫
	var sg = G.safe_gfx
	G.safe_gfx = true
	_ck(not MB.ok() and not NB.ok(), "安全畫面模式仲烘圖")
	var l0 = MB.stats.live; var h1 = MB.stats.hit
	await _w(t, 0.6)
	_ck(MB.stats.hit == h1, "安全畫面模式仲用烘圖")
	G.safe_gfx = sg
	G.gfx_bad["mvbake"] = true
	_ck(not MB.ok(), "烘圖閃退記號冇效")
	G.gfx_bad.erase("mvbake")
	await _w(t, 1.0)
	_ck(MB.ok() and MB.stats.hit > h1, "安全模式關返冇恢復烘圖")
	print("[perf] RESULT ok=%d bad=%d" % [ok, bad])
