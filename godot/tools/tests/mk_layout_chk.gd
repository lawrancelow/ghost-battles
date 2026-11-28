# [market 57] 市集畫面版面總檢：任何看得見的字都唔可以畀頂部牌（不透明底板）切開、唔可以出畫面；
#   （鏡頭邊緣：世界字隨鏡頭移出畫面係正常，唔計；牌／小卡本身夾喺畫面內，由 MKOU.layout_bad 驗）
#   事件牌／過勞小卡／狀態牌互不重疊、唔貼住、唔貼畫面邊；對白框唔疊牌；名牌唔鑽入頂部牌。
#   用法：sc.mk_log = true 之後等一兩格，再 MKLC.bad(sc)
extends RefCounted

static func _cov(sc) -> Array:
	var MKUI = load("res://game/market/mk_fun_ui.gd"); var MKOU = load("res://game/market/mk_ops_ui.gd")
	var c: Array = []
	for q in MKUI.hud_rects: c.append(q)
	if MKOU.on(sc) and float(MKOU.hud_bot) > 0.0: c.append(Rect2(-100000.0, -100000.0, 200000.0, 100000.0 + float(MKOU.hud_bot)))
	if sc._cb_pos != null and sc._cb_sz != Vector2.ZERO: c.append(Rect2(sc._cb_pos, sc._cb_sz))   # 「生產鏈」掣
	return c

static func _scr(sc, r: Rect2) -> Rect2:
	var a: Vector2 = sc.w2s(r.position); var b: Vector2 = sc.w2s(r.end)
	return Rect2(a, b - a).abs()

static func bad(sc) -> Array:
	var MKOU = load("res://game/market/mk_ops_ui.gd")
	var b: Array = []
	var cov = _cov(sc)
	var fw = float(sc.FW)
	for it in sc.mk_txt_log:
		var s = str(it[0]); var r: Rect2 = it[1]
		if s.strip_edges() == "": continue
		for q in cov: if r.intersects(q): b.append("字畀頂部牌切開「%s」%s" % [s, str(r)]); break
		if it.size() > 2 and it[2]:
			for q in sc._mk_pl: if r.intersects(q): b.append("字畀名牌蓋住「%s」%s" % [s, str(r)]); break
	for p in sc._plates:
		var sr = _scr(sc, p)
		for q in cov: if sr.intersects(q): b.append("名牌鑽入頂部牌 %s" % str(sr)); break
	for p in MKOU.lay:
		var sr = _scr(sc, p)
		for q in cov: if sr.intersects(q): b.append("牌／小卡鑽入頂部牌或生產鏈掣 %s" % str(sr)); break
	b.append_array(MKOU.layout_bad(sc))
	return b
