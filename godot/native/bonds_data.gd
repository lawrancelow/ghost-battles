# 原生：bonds_data.js 係純數據（冇函數），由 data/nat/bonds_data.json 讀返（tools/tests/dump_datamod.gd 生成；改原 JS 之後要重新輸出）
extends RefCounted
const DM = preload("res://native/_datamod.gd")
func run(_env) -> void: DM.install("bonds_data")
