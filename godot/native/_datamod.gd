# 純數據模塊共用底：由 data/nat/<模塊>.json 讀返轉譯版原本設嘅全局（tools/tests/dump_datamod.gd 生成）
extends RefCounted

static func install(module: String) -> void:
	var f = FileAccess.open("res://data/nat/%s.json" % module, FileAccess.READ)
	if f == null: push_error("缺數據 " + module); return
	var d = JSON.parse_string(f.get_as_text())
	if not (d is Dictionary): push_error("數據壞咗 " + module); return
	var w = J.G.get("window")
	for k in d:
		J.G[k] = d[k]
		if w != null: J.sp(w, k, d[k])
