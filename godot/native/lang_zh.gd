# 原生改寫自 lang_zh.js：中文對照表（資料喺 data/lang_zh.json，由轉譯版原文抽出，已換走真實品牌名）
extends RefCounted

static func load_json(p: String):
	var f = FileAccess.open(p, FileAccess.READ)
	return JSON.parse_string(f.get_as_text()) if f else null

func run(_env) -> void:
	var d = load_json("res://data/lang_zh.json")
	if d is Dictionary: J.mc(J.G.get("LANG"), "add", [d])
