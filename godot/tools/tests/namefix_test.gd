# [namefix] 分區／大排檔劇情句子要經 DB.N：改名、女主版
extends RefCounted
func all(t) -> void:
	await t.get_tree().create_timer(3.0).timeout
	var MS = load("res://game/outpost/mv_story.gd")
	var ok = 0; var bad = 0
	var S = J.G.S
	var h0 = S.get("hero", {}).duplicate()
	DB.lang = "zh"
	S["hero"] = {"name": "阿明", "full": "李大明", "en": "Ming", "sex": "m", "set": true}
	var b = null
	for x in MS.beats(0): if str(x.id) == "zs0_stage_win_1-1": b = x   # [outgate] 陰間新聞台（有村長全名）搬咗去 1-1 打完
	var sc = MS.build_scene(b); var txt = ""
	for l in sc.lines: txt += str(DB.L(l[1]))
	if txt.contains("李大明") and not txt.contains("陳大福"): ok += 1
	else: bad += 1; print("[nf] BAD 改名 ", txt.substr(0, 80))
	S["hero"] = {"name": "阿慧", "full": "陳慧", "en": "Wai", "sex": "f", "set": true}
	sc = MS.build_scene(b); txt = ""
	for l in sc.lines: txt += str(DB.L(l[1]))
	if txt.contains("陳慧") and not txt.contains("陳大福"): ok += 1
	else: bad += 1; print("[nf] BAD 女主 ", txt.substr(0, 80))
	S["hero"] = {"name": "阿福", "full": "林大福", "en": "Kelvin", "sex": "m", "set": true}
	DB.N("x")
	var t3 = str(DB.L("陳大福村長"))
	if t3 == "林大福村長": ok += 1
	else: bad += 1; print("[nf] BAD 只改全名 ", t3)
	S["hero"] = h0
	print("[nf] RESULT ok=%d bad=%d" % [ok, bad])
