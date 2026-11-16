# 原生改寫自 patrol_assets.js（夜班巡陰圖片路徑表；純資料 → data/nat/patrol_assets.json）
extends RefCounted
func run(_env) -> void:
	preload("res://native/_datamod.gd").install("patrol_assets")
