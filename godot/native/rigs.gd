# 原生改寫自 rigs.js：各角色木偶關節（資料放 data/rigs.json），交俾 Puppet.addRigs
extends RefCounted

func run(_env) -> void:
	J.mc(J.G.get("Puppet"), "addRigs", [JSON.parse_string(FileAccess.get_file_as_string("res://data/rigs.json"))])
