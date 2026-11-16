# 原生改寫自 limbdata.js：從原圖拆出嘅手同武器（資料放 data/limbdata.json）
extends RefCounted

func run(_env) -> void:
	J.G["LIMBS_DATA"] = JSON.parse_string(FileAccess.get_file_as_string("res://data/limbdata.json"))
