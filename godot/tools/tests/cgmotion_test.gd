# [cgm] 分層動態劇情插圖測試（ui/cg_motion.gd＋ui/story_cg.gd）
# 用法：bash tools/devkit/edtest.sh <godot目錄> cgm res://tools/tests/cgmotion_test.gd logic|shots
#   logic：有分層素材→動態；冇→退返靜態圖；冇圖→唔顯示；anim:false 關動態；角色腳底對齊底圖位置；
#          飄／呼吸／晃／抖／換表情真係有郁；同一張圖換行動作接住播；收起清走節點；效能（600 格）
#   shots：每 0.25 秒截一張（CGM_SHOTS 目錄，預設 /tmp/cgm/shots/），之後用 python 砌 GIF
extends RefCounted

const CGM = preload("res://ui/cg_motion.gd")
const CGC = preload("res://ui/story_cg.gd")
const KEY := "cg_test_rebuilt"
var ok := 0
var bad := 0

func _p(m): print("[cgm] ", m)
func _chk(name: String, cond: bool, extra = "") -> void:
	if cond: ok += 1; _p("ok  " + name + ("　" + str(extra) if str(extra) != "" else ""))
	else: bad += 1; _p("BAD " + name + ("　" + str(extra) if str(extra) != "" else ""))
func _w(t, s: float): await t.get_tree().create_timer(s).timeout

func _mk(t) -> Array:   # 假劇情畫面：全屏 Control，入面放插圖卡
	var root = t.get_tree().root
	var par = Control.new(); par.name = "cgm_par"
	par.size = Vector2(450, 975); par.position = Vector2.ZERO
	var bgc = ColorRect.new(); bgc.color = Color("#2a2030"); bgc.size = par.size; par.add_child(bgc)
	root.add_child(par)
	var cg = CGC.new(); par.add_child(cg)
	return [par, cg]

func logic(t) -> void:
	_chk("有分層設定", CGM.has(KEY))
	_chk("冇設定＝false", not CGM.has("cg_no_such"))
	_chk("底圖讀到", CGM.bg(KEY) != null)
	var pc = _mk(t); var par = pc[0]; var cg = pc[1]
	await _w(t, 0.2)
	cg.show_spec({"k": KEY})
	await _w(t, 0.1)
	_chk("分層插圖顯示", cg.visible and cg.mot != null)
	var m = cg.mot
	_chk("角色層 2 個", m != null and m.items.size() == 2, m.items.size() if m else -1)
	_chk("粒子 4 組", m != null and m.parts.size() == 4, m.parts.size() if m else -1)
	_chk("動態層喺疊圖層之下", m != null and m.root.get_index() < cg.layer.get_index())
	# 腳底對齊：t=0 時角色腳底（未計動作）＝ layout x,y 換算位置
	var L = CGM.conf()[KEY]
	var errs := []
	for i in m.items.size():
		var it = m.items[i]; var n: TextureRect = it.n
		var ly = null
		for o in L.layers:
			if n.texture == load(CGM.ROOT + KEY + "/" + str(o.img)): ly = o
		if ly == null: errs.append("搵唔到層"); continue
		var foot = it.pos + Vector2(n.size.x / 2.0, n.size.y)
		var want = m.img2view(Vector2(J.num(ly.x), J.num(ly.y)))
		if foot.distance_to(want) > 1.5: errs.append([foot, want])
	_chk("腳底對齊底圖位置", errs.is_empty(), errs)
	# 動作真係有郁
	var p0 := []
	for it in m.items: p0.append([it.n.position, it.n.scale, it.n.rotation])
	await _w(t, 0.9)
	var moved := 0
	for i in m.items.size():
		var it = m.items[i]
		if it.n.position.distance_to(p0[i][0]) > 0.3 or absf(it.n.scale.x - p0[i][1].x) > 0.001 or absf(it.n.rotation - p0[i][2]) > 0.0005: moved += 1
	_chk("每個角色都有郁", moved == m.items.size(), moved)
	_chk("慢推鏡：底圖放大緊", cg.pic.scale.x > 1.0, cg.pic.scale.x)
	_chk("疊圖層跟底圖一齊推", absf(cg.layer.scale.x - cg.pic.scale.x) < 0.0001)
	# 換表情：模擬時間行一個周期，期間一定見到 alt
	var it0 = m.items[0]
	var seen_alt := false; var seen_main := false
	var tt = m.t
	for k in 300:
		m.tick(1.0 / 60.0)
		if it0.n.texture == it0.alt: seen_alt = true
		if it0.n.texture == it0.main: seen_main = true
	_chk("換表情（眨眼）有出現又會變返", seen_alt and seen_main)
	# 抖（驚嚇）：water 層 every 5s dur 0.4，行 6 秒內位移峰值大過淨飄
	var it1 = m.items[1]
	var mx := 0.0
	for k in 360:
		m.tick(1.0 / 60.0); mx = maxf(mx, absf(it1.n.position.x - it1.pos.x))
	_chk("抖：橫向有位移", mx > 0.5, snappedf(mx, 0.01))
	# 同一張圖換行：唔重頭
	var tb = m.t
	cg.show_spec({"k": KEY})
	await _w(t, 0.05)
	_chk("同一張圖：動作時間接住", cg.mot != null and cg.mot.t >= tb, [tb, cg.mot.t if cg.mot else -1])
	_chk("同一張圖：舊節點清走（唔疊兩套）", cg.vp.get_children().filter(func(c): return str(c.name).begins_with("cgm")).size() == 1)
	# anim:false 關動態
	cg.show_spec({"k": KEY, "anim": false})
	await _w(t, 0.05)
	_chk("anim:false＝冇動態", cg.mot == null)
	# 靜態圖（冇分層素材）退返舊做法
	cg.show_spec({"k": "cg7_box"})
	await _w(t, 0.05)
	_chk("冇分層素材＝靜態圖照顯示", cg.visible and cg.mot == null and cg.pic.texture != null)
	# 冇圖：唔顯示
	cg.show_spec({"k": "cg_no_such"})
	await _w(t, 0.5)
	_chk("冇圖＝收起", not cg.visible)
	# 停用開關
	CGM.disabled = true
	cg.show_spec({"k": KEY})
	await _w(t, 0.05)
	_chk("停用動態：冇素材 key 照舊收起／有就用靜態", cg.mot == null)
	CGM.disabled = false
	# 收起清走
	cg.show_spec({"k": KEY}); await _w(t, 0.1)
	cg.hide_cg(); await _w(t, 0.6)
	_chk("收起後清走動態層", cg.mot == null and not cg.visible)
	# 美術產線分層（A2：5 角色＋12 燈籠＋2 炊煙，rect／pivot 定位，燈籠閃＋擺、炊煙飄）
	var K2 = "cg_a2_rebuilt"
	_chk("A2 分層設定", CGM.has(K2))
	cg.show_spec({"k": K2}); await _w(t, 0.1)
	var m2 = cg.mot
	_chk("A2 層數 19", m2 != null and m2.items.size() == 19, m2.items.size() if m2 else -1)
	var L2 = CGM.conf()[K2]
	var rerr := []
	for o in L2.layers:   # rect 換算：t≈0 時（未郁）左上角＝rect 位置
		for it in m2.items:
			if it.main == load(CGM.ROOT + K2 + "/" + str(o.img)):
				var want = m2.img2view(Vector2(J.num(o.rect[0]), J.num(o.rect[1])))
				if it.pos.distance_to(want) > 1.5: rerr.append([o.name, it.pos, want])
	_chk("A2 rect 位置對齊", rerr.is_empty(), rerr)
	var lan = null; var smk = null
	for it in m2.items:
		if it.fx.has("flicker") and lan == null: lan = it
		if it.fx.has("drift") and smk == null: smk = it
	_chk("燈籠：軸心喺頂（吊住擺）", lan != null and absf(lan.n.pivot_offset.y) < 0.5)
	_chk("燈籠：有光暈", lan != null and lan.glow != null)
	var mods := {}
	for k in 120:
		m2.tick(1.0 / 60.0); mods[snappedf(lan.n.modulate.r, 0.02)] = 1
	_chk("燈籠：亮度會閃", mods.size() >= 4, mods.size())
	var alphas := []
	for k in 300:
		m2.tick(1.0 / 60.0); alphas.append(smk.n.modulate.a)
	_chk("炊煙：淡入淡出循環", alphas.min() < 0.15 and alphas.max() > 0.85, [snappedf(alphas.min(), 0.01), snappedf(alphas.max(), 0.01)])
	_chk("炊煙：有第二份錯開", smk.twin != null and absf(smk.twin.modulate.a - smk.n.modulate.a) > 0.05)
	# 效能：600 格 tick（只計 CPU 計算）
	cg.show_spec({"k": KEY}); await _w(t, 0.1)
	var t0 = Time.get_ticks_usec()
	for k in 600: cg.mot.tick(1.0 / 60.0)
	var ms = (Time.get_ticks_usec() - t0) / 1000.0 / 600.0
	_chk("每格 tick < 0.3 ms（佔位 2 層）", ms < 0.3, snappedf(ms, 0.001))
	cg.show_spec({"k": "cg_a2_rebuilt"}); await _w(t, 0.1)
	t0 = Time.get_ticks_usec()
	for k in 600: cg.mot.tick(1.0 / 60.0)
	ms = (Time.get_ticks_usec() - t0) / 1000.0 / 600.0
	_chk("每格 tick < 0.6 ms（A2 19 層）", ms < 0.6, snappedf(ms, 0.001))
	par.queue_free()
	_p("RESULT ok=%d bad=%d" % [ok, bad])

func shots(t) -> void:
	var dir = OS.get_environment("CGM_SHOTS")
	if dir == "": dir = "/tmp/cgm/shots/"
	DirAccess.make_dir_recursive_absolute(dir)
	var key = OS.get_environment("CGM_KEY")
	if key == "": key = "cg_a2_rebuilt"
	var pc = _mk(t); var cg = pc[1]
	await _w(t, 0.2)
	cg.show_spec({"k": key})
	for i in 48:   # 12 秒，每 0.25 秒一張
		await _w(t, 0.25)
		var img = t.get_viewport().get_texture().get_image()
		img.save_png(dir + "f%03d.png" % i)
	_p("RESULT ok=1 bad=0 shots=" + dir)
