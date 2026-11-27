# [settings] 設置功能＋新標題畫面專項測試
#   logic：prefs 存取、音軌、音量、文字速度、自動播放等待、幀率／流暢模式
#   ui：標題畫面（無存檔）→ 按鈕齊、設置面板五頁、控件生效、截圖；入遊戲 → 頂欄設置鍵、劇情回顧頁設置鍵、自動播放真係翻頁
extends RefCounted
const SHOTS := "/tmp/settings_shots/"
const PF = preload("res://game/settings/prefs.gd")
var ok := 0
var bad := 0
func _p(m): print("[settings] ", m)
func _ck(c: bool, msg: String) -> void:
	if c: ok += 1
	else: bad += 1; _p("BAD " + msg)
func _w(t, s: float): await t.get_tree().create_timer(s).timeout
func _main(t): return t.get_tree().root.get_node_or_null("Main")
func _shot(t, name: String):
	await RenderingServer.frame_post_draw
	t.get_viewport().get_texture().get_image().save_png(SHOTS + name + ".png"); _p("shot " + name)
func _done() -> void: _p("RESULT ok=%d bad=%d" % [ok, bad])

func _boot(t):
	var m = null
	for i in 160:
		await _w(t, 0.5)
		m = _main(t)
		if m and m.get("loading") == null and J.G.get("S") is Dictionary: break
	await _w(t, 1.0)
	return m

func logic(t) -> void:
	await _boot(t)
	PF.reset_defaults(); PF.save(); PF._loaded = false; PF.load_pref()
	_ck(PF.text_speed == 1 and not PF.auto_play and PF.fps == 60 and PF.keep_on, "預設值唔啱")
	for b in ["Music", "SFX", "Voice"]: _ck(AudioServer.get_bus_index(b) >= 0, "冇音軌 " + b)
	var snd = t.get_tree().root.get_node("Snd")
	_ck(str(snd._sfx[0].bus) == "SFX" and str(snd._bed.bus) == "Music" and str(snd._mus[0].bus) == "Music", "Snd 播放器冇入對音軌")
	PF.set_vol("music", 0.25)
	_ck(absf(db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music"))) - 0.25) < 0.01, "音樂音量冇生效")
	PF.set_vol("sfx", 0.0)
	_ck(AudioServer.is_bus_mute(AudioServer.get_bus_index("SFX")), "音效 0 冇靜音")
	PF.set_vol("master", 0.5)
	if snd.is_on(): _ck(absf(db_to_linear(AudioServer.get_bus_volume_db(0)) - 0.5) < 0.01, "總音量冇生效")
	PF.set_text_speed(3); PF.set_auto(true); PF.set_fps(30); PF.set_keep_on(false)
	PF._loaded = false; PF.vol = {"master": 0.0, "music": 0.0, "sfx": 0.0, "voice": 0.0}; PF.load_pref()   # 由檔案讀返
	_ck(PF.text_speed == 3 and PF.auto_play and PF.fps == 30 and not PF.keep_on, "設置冇存落檔")
	_ck(absf(float(PF.vol.get("music", -1)) - 0.25) < 0.001, "音量冇存落檔")
	_ck(PF.type_sec() == 0.0, "即時速度唔係 0")
	var PM = load("res://ui/perf_mode.gd"); PM.load_pref(); var pm0 = PM.on
	PM.set_on(false); _ck(Engine.max_fps == 30, "流暢模式關冇用設置幀率 30")
	PF.set_fps(60); _ck(Engine.max_fps == 60, "幀率 60 冇生效")
	PM.set_on(true); PF.apply_display(); _ck(Engine.max_fps == 30, "流暢模式開冇鎖 30")
	PM.set_on(pm0)
	_ck(PF.auto_wait(10) > 1.0 and PF.auto_wait(40) > PF.auto_wait(10), "自動播放等待時間唔合理")
	# 對白語言同 settings.cfg 共存（prefs 存檔唔好洗走 ui/dialogue_lang）
	DB.set_lang("yue"); PF.save()
	var c = ConfigFile.new(); c.load(PF.FILE); _ck(str(c.get_value("ui", "dialogue_lang", "")) == "yue", "prefs 存檔洗走咗對白語言")
	DB.set_lang("zh")
	PF.reset_defaults(); PF.save(); PF.apply_audio(true); PF.apply_display()
	_done()

func ui(t) -> void:
	DirAccess.make_dir_recursive_absolute(SHOTS)
	var m = await _boot(t)
	PF.reset_defaults(); PF.save()
	# ---- 標題畫面（無存檔）----
	var tv = m.get("title_ov")
	_ck(tv != null and tv.name == "Title", "冇新標題畫面")
	if tv == null: _done(); return
	await _w(t, 2.0)
	await _shot(t, "title_fresh")
	_ck(tv.btn_new != null and tv.btn_new.visible, "冇開始新遊戲")
	_ck(tv.btn_cont == null, "無存檔仲出繼續遊戲")
	_ck(tv.btn_set != null and tv.btn_imp != null, "冇設置／導入存檔按鈕")
	# 全部按鈕喺畫面內、唔重疊
	var vr = Rect2(Vector2.ZERO, t.get_viewport().get_visible_rect().size)
	var rs: Array = []
	for b in [tv.btn_new, tv.btn_set, tv.btn_imp]:
		var r: Rect2 = b.get_global_rect(); rs.append(r)
		_ck(vr.encloses(r), "按鈕出畫面 %s %s" % [b.name, r])
	_ck(not rs[0].intersects(rs[1]) and not rs[1].intersects(rs[2]), "按鈕重疊")
	# 打開設置
	(tv.btn_set as BaseButton).pressed.emit(); await _w(t, 0.6)
	var sp = m.get_node_or_null("SettingsPanel")
	_ck(sp != null, "標題畫面撳設置冇開面板")
	if sp == null: _done(); return
	_ck(not sp.has_save, "無存檔時存檔頁冇停用")
	var names = ["sound", "gfx", "story", "save", "support"]
	for i in 5:
		sp.show_tab(i); await _w(t, 0.4)
		await _shot(t, "settings_%d_%s" % [i, names[i]])
		var body: Control = sp._body
		_ck(body.get_child_count() > 2, "第 %d 頁冇內容" % i)
		# 內容唔好出框（橫向）
		var win: Rect2 = sp.get_node("Win").get_global_rect()
		for c in body.find_children("*", "Control", true, false):
			if c.is_visible_in_tree() and c.size.x > 0 and not c.is_queued_for_deletion():
				var r: Rect2 = c.get_global_rect()
				if r.position.x < win.position.x - 1 or r.end.x > win.end.x + 1: _ck(false, "第 %d 頁 %s 橫向出框 %s" % [i, c.name, r]); break
		if i == 3:
			var dis = 0
			for b in body.find_children("*", "Button", true, false): if b.disabled: dis += 1
			_ck(dis >= 2, "無存檔：備份／重新開始冇停用")
	# 聲音頁：拉滑桿真係改音量
	sp.show_tab(0); await _w(t, 0.3)
	var sl: HSlider = sp._body.find_child("Vol_music", true, false)
	_ck(sl != null, "冇音樂滑桿")
	if sl: sl.value = 40; await _w(t, 0.1); _ck(PF.pct("music") == 40, "滑桿冇改到音樂音量")
	# 劇情頁：揀「快」
	sp.show_tab(2); await _w(t, 0.3)
	var picked = false
	for b in sp._body.find_children("*", "Button", true, false):
		if b.text == "快": b.pressed.emit(); picked = true; break
	_ck(picked and PF.text_speed == 2, "文字速度揀唔到")
	sp.close(); await _w(t, 0.5)
	_ck(m.get_node_or_null("SettingsPanel") == null, "關唔到設置面板")
	PF.reset_defaults(); PF.save()
	# ---- 入遊戲 ----
	m._hide_title(); await _w(t, 1.0)
	for i in 14:
		if m.story.cur != null: m.story.skip_scene()
		await _w(t, 0.25)
	var gb: Button = m.find_child("SetBtn", true, false)
	_ck(gb != null and gb.is_visible_in_tree(), "頂欄冇設置鍵")
	if gb:
		_ck(vr.encloses(gb.get_global_rect()), "頂欄設置鍵出畫面")
		await _shot(t, "topbar")
		gb.pressed.emit(); await _w(t, 0.6)
		var sp2 = m.get_node_or_null("SettingsPanel")
		_ck(sp2 != null and sp2.has_save, "遊戲內設置面板唔啱")
		if sp2: await _shot(t, "settings_ingame_save"); sp2.show_tab(3); await _w(t, 0.3); await _shot(t, "settings_ingame_savetab"); sp2.close(); await _w(t, 0.4)
	# 劇情回顧頁有設置鍵
	m.open_story(); await _w(t, 0.6)
	var ob = m.sheet_body.find_child("OpenSettings", true, false)
	_ck(ob != null, "劇情頁冇設置鍵")
	m.close_sheet()
	# 自動播放：開咗之後劇情自己翻頁
	PF.set_auto(true); PF.set_text_speed(3)
	# 揀一場唔係 WhatsApp 嘅劇情（WhatsApp 模式唔自動）
	var cands: Array = []
	for e in DB.D.SCENE_ORDER:
		for id in e[1]: cands.append(str(id))
	var tested = false
	for sid in cands.slice(0, 30):
		m.story.queue(sid); await _w(t, 0.4)
		if m.story.cur == null: continue
		if m.story.wa != null or m.story.cur.sc.lines.size() < 3: m.story.skip_scene(); await _w(t, 0.3); continue
		var li0 = m.story.li
		await _w(t, 7.0)
		_p("auto sid=%s li0=%d li=%d" % [sid, li0, m.story.li])
		_ck(m.story.cur == null or m.story.li > li0, "自動播放冇翻頁")
		tested = true
		while m.story.cur != null: m.story.skip_scene(); await _w(t, 0.2)
		break
	_ck(tested, "揾唔到可以測自動播放嘅劇情")
	# 有存檔嘅標題畫面（繼續遊戲＋開始新遊戲）
	var tv2 = load("res://ui/title/title_view.gd").new(); tv2.host = m; tv2.fresh = false; m.add_child(tv2)
	await _w(t, 2.2)
	_ck(tv2.btn_cont != null and tv2.btn_new != null, "有存檔冇繼續遊戲")
	var vr2 = Rect2(Vector2.ZERO, t.get_viewport().get_visible_rect().size)
	for b in [tv2.btn_cont, tv2.btn_new, tv2.btn_set, tv2.btn_imp]: _ck(vr2.encloses(b.get_global_rect()), "有存檔標題按鈕出畫面 %s" % b.name)
	_ck(not tv2.btn_cont.get_global_rect().intersects(tv2.btn_new.get_global_rect()), "繼續／新遊戲重疊")
	await _shot(t, "title_save")
	tv2.queue_free()
	PF.reset_defaults(); PF.save()
	_done()
