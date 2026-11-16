# 把純數據模塊（冇函數）嘅全局輸出做 JSON：["gdrun","res://tools/tests/dump_datamod.gd","dump"]，模塊名由環境變數 GB_DUMP（逗號分隔）
extends RefCounted
func dump(_t) -> void:
	for m in OS.get_environment("GB_DUMP").split(",", false):
		var src = FileAccess.get_file_as_string("res://jsgen/%s.gd" % m)
		var re = RegEx.new(); re.compile('J\\.G\\["([A-Za-z_0-9]+)"\\] =')
		var names = []
		for r in re.search_all(src): if not names.has(r.get_string(1)): names.append(r.get_string(1))
		var keep = {}
		for n in names: keep[n] = J.G.get(n)
		var scr: GDScript = load("res://jsgen/%s.gd" % m); var inst = scr.new(); inst.run(null)
		var out = {}
		for n in names: out[n] = J.G.get(n); J.G[n] = keep[n]
		var p = ProjectSettings.globalize_path("res://data/nat/%s.json" % m)
		var f = FileAccess.open(p, FileAccess.WRITE); f.store_string(JSON.stringify(out, "", false, true)); f.close()
		print("[dump] ", m, " ", names, " -> ", p)
