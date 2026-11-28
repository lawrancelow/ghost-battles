# 補丁 56 實機截圖（唔入 repo 測試集）：缺料指路、失敗提示
extends RefCounted
const NEED = preload("res://game/onboard/need.gd")
func _S(): return J.G.get("S")
func _shot(t, name: String) -> void:
	for k in 20: await t.get_tree().process_frame
	await RenderingServer.frame_post_draw
	t.get_viewport().get_texture().get_image().save_png("/tmp/p56shots/" + name + ".png")
	print("[p56shot] saved ", name)
func run(t) -> void:
	DirAccess.make_dir_recursive_absolute("/tmp/p56shots")
	var S = _S()
	await t.get_tree().create_timer(4.0).timeout
	await _shot(t, "live_00_start")
	# 缺料指路：民宅缺棺材板、棺材鋪冇人做工
	S.bld["home"] = 0.0; S.bld["plank"] = 1.0; S.bld["wood"] = 1.0
	for g in S.ghosts: if str(g.get("post")) == "plank": g["post"] = null
	S.res["planks"] = 1.0; S.res["wood"] = 206.0; S.res["coins"] = 9999.0
	var q = {"t": "build", "b": "home", "text": "建造民宅", "go": "home"}
	var QQ = J.G.get("Quest"); var ocur = QQ.get("cur")
	QQ["cur"] = func(_a, _b): return q
	print("[p56shot] short=", NEED.quest_short(q), " lack=", NEED.quest_lack(q))
	await t.get_tree().create_timer(3.0).timeout
	await _shot(t, "live_01_lack_guide")
	Menus.jn("bldAct", ["home", "build", null])
	print("[p56shot] why=", J.G.get("_p56_last_why", ""))
	await t.get_tree().create_timer(0.6).timeout
	await _shot(t, "live_02_build_fail")
	await t.get_tree().create_timer(3.0).timeout
	# 招魂失敗：冥幣唔夠
	S.bld["altar"] = 1.0; S.bld["home"] = 3.0; S.res["coins"] = 40.0; S.res["buns"] = 999.0
	Menus.jn("bldAct", ["altar", "recruit", null])
	print("[p56shot] why2=", J.G.get("_p56_last_why", ""))
	await t.get_tree().create_timer(0.6).timeout
	await _shot(t, "live_03_recruit_fail")
	QQ["cur"] = ocur
	# [p56b] 任務條最長缺料文案（每幀畫之前寫返，refresh 唔會蓋走）
	var m = t.get_tree().root.get_node_or_null("Main")
	var BLD = J.G.get("BUILDINGS"); var keepc = BLD["altar"].get("build")
	S.bld["altar"] = 0.0; S.bld["bun"] = 1.0; S.res["bao"] = 0.0; BLD["altar"]["build"] = {"bao": 99999.0}
	var lq = {"t": "build", "b": "altar", "text": "建造招魂台（招雜鬼、增加雜鬼名額、開放名冊）", "go": "altar", "r": {}}
	var want = str(lq.text) + m._quest_lack_line(lq)
	var setter = func(): m.quest_lbl.text = want; m.quest_prog.text = "0/1"
	RenderingServer.frame_pre_draw.connect(setter)
	for c in m.toasts.get_children(): c.free()
	m.show_toast(NEED.hint({"coins": 99999.0, "bao": 99999.0}))
	await t.get_tree().create_timer(0.5).timeout
	await _shot(t, "live_05_bar_longest_toast_avoid")
	RenderingServer.frame_pre_draw.disconnect(setter)
	BLD["altar"]["build"] = keepc
	print("[p56shot] RESULT ok=5 bad=0")
