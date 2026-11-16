# 原生改寫自 rigs.js：各角色木偶關節（資料放 data/puppet_rigs.json；data/rigs.json 係 DB 用嘅骨架／拆手資料，唔好改），交俾 Puppet.addRigs
extends RefCounted

func run(_env) -> void:
	J.mc(J.G.get("Puppet"), "addRigs", [JSON.parse_string(FileAccess.get_file_as_string("res://data/puppet_rigs.json"))])
