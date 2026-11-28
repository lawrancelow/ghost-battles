# [paging] 對話框文字唔准溢出：掃全部 talk 樣式劇情（DB.D.SCENES），逐句用實際字體排版量高度，
#   分頁後每一頁都要喺對話框入面；主角名取最長允許長度（名 6 字、全名 6 字、英文名 16 字）男女都要過；中文／粵語都掃
# 用法：bash /home/claude/gbslot.sh bash /home/claude/setup/edtest.sh <godot目錄> textfit res://tools/tests/textfit_test.gd all 900
extends "res://tools/tests/eqview2_test.gd"
const STG = preload("res://ui/story.gd")
func _p(m): print("[fit] ", m)

func all(t) -> void:
	var m = await _boot(t)
	var st = m.get("story")
	_chk("劇情框存在", st != null)
	if st == null: _p("RESULT ok=%d bad=%d" % [ok, bad]); return
	# 同對話框一模一樣嘅字：UIKit.label 18 號、自動換行
	var lb = UIKit.label("", 18, UIKit.INKTXT); lb.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	lb.position = Vector2(-2000, -2000); lb.size = Vector2(250, 120); t.add_child(lb)
	var W: float = st.size.x if st.size.x > 50.0 else 390.0
	var box_h := 154.0; var avail: float = STG.tx_avail_h(box_h)
	STG.measure_h(lb, "量", 200.0)
	var lh: float = lb.get_line_height()
	_chk("對話框每頁最少放到 3 行", lh > 10.0 and avail >= lh * 3.0, "可用高 %.0f、行高 %.0f" % [avail, lh])
	var S = J.G.S; var h0 = S.get("hero", {}).duplicate(); var l0 = DB.lang
	var heroes = [
		["男主預設", {"name": "阿福", "full": "陳大福", "en": "Kelvin", "sex": "m", "set": true}],
		["男主最長名", {"name": "龘龘龘龘龘龘", "full": "龘龘龘龘龘龘", "en": "WWWWWWWWWWWWWWWW", "sex": "m", "set": true}],
		["女主預設", {"name": DB.HERO_F.name, "full": DB.HERO_F.get("full", ""), "en": DB.HERO_F.get("en", ""), "sex": "f", "set": true}],
		["女主最長名", {"name": "龘龘龘龘龘龘", "full": "龘龘龘龘龘龘", "en": "WWWWWWWWWWWWWWWW", "sex": "f", "set": true}],
	]
	_chk("最長名係合法名", DB.name_check("龘龘龘龘龘龘", "name") == "" and DB.name_check("龘龘龘龘龘龘", "full") == "" and DB.name_check("WWWWWWWWWWWWWWWW", "en") == "" and DB.name_check("龘龘龘龘龘龘龘", "name") != "")
	for hv in heroes:
		S["hero"] = hv[1]
		for lang in ["zh", "yue"]:
			DB.lang = lang
			var n_line := 0; var n_multi := 0; var n_raw_over := 0; var over: Array = []; var lost: Array = []; var maxpg := 1; var tiny: Array = []
			for sid in DB.D.SCENES:
				var sc = DB.D.SCENES[sid]
				if not (sc is Dictionary) or str(sc.get("style", "talk")) != "talk" or not (sc.get("lines") is Array): continue
				for ln in sc.lines:
					if not (ln is Array) or ln.size() < 2: continue
					var who := str(ln[0]); var text := str(DB.L(str(ln[1])))
					var art = "sys" if who == "系統" else DB.D.SPEAKER_ART.get(who)
					var w: float = (W - 16.0) - (108.0 if art != null else 18.0) - 14.0
					n_line += 1
					if STG.measure_h(lb, text, w) > avail + 0.5: n_raw_over += 1
					var pgs: Array = STG.paginate(lb, text, w, avail)
					if pgs.size() > 1: n_multi += 1
					maxpg = maxi(maxpg, pgs.size())
					var joined := ""
					for pg in pgs:
						joined += str(pg)
						if STG.measure_h(lb, str(pg), w) > avail + 0.5: over.append("%s:%s" % [sid, str(pg).left(14)])
						if pgs.size() > 1 and str(pg).length() < 4: tiny.append("%s:%s" % [sid, pg])
					if joined.replace(" ", "").replace("\n", "") != text.replace(" ", "").replace("\n", ""): lost.append("%s:%s" % [sid, text.left(14)])
			_chk("%s／%s：冇任何一頁溢出對話框" % [hv[0], lang], over.is_empty() and n_line > 300, "句 %d、原本溢出 %d、分頁 %d 句、最多 %d 頁 %s" % [n_line, n_raw_over, n_multi, maxpg, str(over.slice(0, 4))])
			_chk("%s／%s：分頁冇漏字、冇得幾隻字嘅碎頁" % [hv[0], lang], lost.is_empty() and tiny.is_empty(), str(lost.slice(0, 3)) + str(tiny.slice(0, 3)))
	# 斷句位：優先句號
	var demo: Array = STG.paginate(lb, "坐。不用緊張，這不是面試，是入職。（翻檔案）十八歲，全科Ａ，每學期幫組員做三份報告，還替教授改過兩次投影片。很好，很好。這種人，集團最需要，也最好用。", W - 16.0 - 108.0 - 14.0, avail)
	_chk("長句喺句讀位斷開", demo.size() >= 2 and "。！？…）」".contains(str(demo[0]).right(1)), demo)
	DB.lang = l0; S["hero"] = h0; lb.queue_free()
	# 實機：女主龐總辦公室／孟婆湯（之前溢出嗰兩句）逐頁量對話框入面嗰個 Label
	S["hero"] = {"name": "小慧", "full": "林慧", "en": "", "sex": "f", "set": true}; DB.lang = "zh"
	var seen0 = S.seen.duplicate()
	DirAccess.make_dir_recursive_absolute("/home/claude/meeting/vil2/opening/")
	for sid in ["opf2_office", "opf2_soup"]:
		st.queue(sid)
		var guard := 0; var worst := 0.0; var multi := 0; var shot := false
		while st.cur != null and str(st.cur.get("id", "")) == sid and guard < 200:
			guard += 1
			if st.typing: st.advance(); await _f(t, 2)
			var h: float = st.tx.get_line_count() * st.tx.get_line_height() + maxi(0, st.tx.get_line_count() - 1) * st.tx.get_theme_constant("line_spacing")
			worst = maxf(worst, h)
			if st.pages.size() > 1 and st.pg == 0:
				multi += 1
				if not shot:
					shot = true
					for pi in st.pages.size():
						await _w(t, 0.5); await RenderingServer.frame_post_draw
						t.get_viewport().get_texture().get_image().save_png("/home/claude/meeting/vil2/opening/f_%s_page%d.png" % [sid, pi + 1])
						if pi < st.pages.size() - 1:
							st.advance(); await _f(t, 2)
							if st.typing: st.advance(); await _f(t, 2)
			st.advance(); await _f(t, 2)
		_chk("實機 %s：對白 Label 最高 %.0f <= 可用 %.0f，有分頁 %d 句" % [sid, worst, STG.tx_avail_h(st.talkbox.size.y) if st.talkbox != null and is_instance_valid(st.talkbox) else avail, multi], worst <= avail + 0.5 and multi >= 1)
	S["seen"] = seen0; S["hero"] = h0; DB.lang = l0
	_p("RESULT ok=%d bad=%d" % [ok, bad])
