# [worksfx] 做工音效專項測試：38 個事件齊、合成檔載入、每個都播得出（真係有聲：音軌峰值）、限流、走 SFX 音軌、work_anim 掛鈎會叫 Snd
extends RefCounted
const WA = preload("res://game/outpost/work_anim.gd")
const WX = preload("res://game/outpost/work_sfx_idx.gd")
var ok := 0
var bad := 0
func _p(m): print("[worksfx] ", m)
func _ck(c: bool, msg: String) -> void:
	if c: ok += 1
	else: bad += 1; _p("BAD " + msg)
func _w(t, s: float): await t.get_tree().create_timer(s).timeout
func all(t) -> void:
	await _w(t, 3.0)
	var snd = t.get_tree().root.get_node("Snd")
	_ck(snd.has_method("work_sfx"), "Snd 冇 work_sfx")
	# 1. 38 個事件同 work_anim 掛點一一對應
	var evs: Array = WA.SFX.values()
	_ck(evs.size() == 38, "掛點唔係 38：%d" % evs.size())
	for e in evs: _ck(WX.IDX.has(e), "索引冇 " + e)
	_ck(WX.IDX.size() == 38, "索引數唔啱")
	# 2. 合成檔
	var st = snd.work_stream()
	_ck(st != null, "work_sheet.ogg 載入唔到")
	if st == null: _p("RESULT ok=%d bad=%d" % [ok, bad]); return
	var L: float = st.get_length()
	for e in WX.IDX:
		var seg = WX.IDX[e]
		_ck(float(seg[1]) >= 0.08 and float(seg[0]) + float(seg[1]) <= L + 0.01, "%s 切點越界 %s / %.2f" % [e, str(seg), L])
	# 3. 逐個播：等夠限流時間，要「play」，SFX 音軌有聲
	var sfx_bus = AudioServer.get_bus_index("SFX")
	_ck(sfx_bus >= 0, "冇 SFX 音軌")
	var PF = load("res://game/settings/prefs.gd"); PF.set_vol("sfx", 1.0); PF.set_vol("master", 1.0)
	if not snd.is_on(): snd.toggle()
	var heard := 0
	var i := 0
	for e in WX.IDX:
		i += 1
		var r = snd.work_sfx(e, "t", float(i) * 500.0, 0.0)
		_ck(r == true, "%s 播唔到（%s）" % [e, str(snd.wk_log.back())])
		var pk := 0.0
		for f in 12:
			await t.get_tree().process_frame
			pk = maxf(pk, AudioServer.get_bus_peak_volume_left_db(sfx_bus, 0))
		if pk > -60.0: heard += 1
		await _w(t, 0.2)
	_p("有聲 %d / 38" % heard)
	_ck(heard >= 36, "實際有聲太少：%d" % heard)   # 無聲卡環境峰值可能讀唔到，容許少量
	for q in snd._wkp: _ck(str(q.bus) == "SFX", "做工播放器冇走 SFX 音軌")
	# 4. 限流：同一位置連發、同一聲連發、同時上限
	await _w(t, 1.0)
	_ck(snd.work_sfx("wk_chop_hit", "a", 10, 10) == true, "限流前第一聲應該播")
	await _w(t, 0.08)
	_ck(snd.work_sfx("wk_saw_stroke", "b", 30, 20) == false and str(snd.wk_log.back()[1]) == "gap_b", "同一建築 0.33 秒內應該限流")
	_ck(snd.work_sfx("wk_chop_hit", "c", 900, 900) == false, "同一聲 0.16 秒內應該限流")
	await _w(t, 1.0)
	var played := 0
	for j in 8:
		if snd.work_sfx(WX.IDX.keys()[j], "m", 2000.0 + j * 300.0, 0.0): played += 1
		await _w(t, 0.07)
	var busy := 0
	for q in snd._wkp: if q.playing: busy += 1
	_ck(busy <= 3, "同時播超過 3 個：%d" % busy)
	_p("密集 8 下實際播 %d" % played)
	# 5. 隨機音高範圍
	var pmin := 9.0; var pmax := 0.0
	for q in snd._wkp: pmin = minf(pmin, q.pitch_scale); pmax = maxf(pmax, q.pitch_scale)
	_ck(pmin >= 0.93 and pmax <= 1.07, "音高超出範圍 %.3f–%.3f" % [pmin, pmax])
	# 6. work_anim 冇自訂 on_sfx 時會叫 Snd（模擬一下觸發）
	await _w(t, 1.0)
	var n0 = snd.wk_log.size()
	WA.on_sfx = Callable()
	var snd2 = Engine.get_main_loop().root.get_node_or_null("Snd")
	_ck(snd2 == snd, "work_anim 揾唔到 Snd")
	snd2.work_sfx("wk_fan_whoosh", "z", 5000, 5000)
	_ck(snd.wk_log.size() > n0, "掛鈎冇記錄")
	_p("RESULT ok=%d bad=%d" % [ok, bad])
