# 原生改寫自 station_props.js（陽間站崗障礙物 sprite 表；純資料 → data/nat/station_props.json）
extends RefCounted
func run(_env) -> void:
	preload("res://native/_datamod.gd").install("station_props")
