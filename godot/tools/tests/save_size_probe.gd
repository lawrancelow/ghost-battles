# [account] 估算存檔大小：新開局 vs 模擬後期（全 131 名鬼、裝備、魂魄、劇情全看過）
extends RefCounted
func _p(m): print("[sz] ", m)
func run(t) -> void:
	await t.get_tree().create_timer(2.0).timeout
	var o = G.new_state()
	_p("fresh_json=%d" % JSON.stringify(o).length())
	_p("keys=" + ",".join(o.keys()))
	for k in o.keys(): _p("  %s=%d" % [k, JSON.stringify(o[k]).length()])
	var g0 = o.ghosts[0] if o.ghosts is Array and o.ghosts.size() > 0 else {}
	_p("ghost0=" + JSON.stringify(g0))
	# 模擬後期
	var ids = DB.D.GHOSTS.keys()
	var arr = []
	for i in ids.size():
		var g = g0.duplicate(true); g["id"] = str(ids[i]); g["lv"] = 60; g["uid"] = "g%05d" % i
		g["eq"] = {"w": "eq_w_%d" % (i % 18), "a": "eq_a_%d" % (i % 20), "t": "eq_t_%d" % (i % 30)}; g["star"] = 5; g["pin"] = "王"; g["exp"] = 123456
		arr.append(g)
	o.ghosts = arr
	var seen = {}
	for id in DB.D.get("SCENE_ORDER", []):
		for s in id[1]: seen[s] = true
	for i in 400: seen["sc_%d" % i] = true
	o.seen = seen
	var soul = {}
	for i in 192: soul["s_%d" % i] = {"n": 37, "f": 2, "lv": 5}
	o["soul_probe"] = soul
	var inv = []
	for i in 300: inv.append({"id": "eq_%d" % (i % 94), "q": 3, "up": 7, "uid": "e%05d" % i})
	o["eq_probe"] = inv
	var s = JSON.stringify(o)
	_p("late_json=%d late_b64=%d" % [s.length(), G.enc(o).length()])
	var z = s.to_utf8_buffer().compress(FileAccess.COMPRESSION_GZIP)
	_p("late_gzip=%d" % z.size())
