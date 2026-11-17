# 原生改寫自 moves_spirit.js：Pontianak、水鬼、天花姐（game/battle/bt_moves2.gd）、保安阿伯、清潔安娣、陳總（game/battle/bt_moves3.gd）
extends RefCounted
const MV := preload("res://native/moves.gd")

func run(_env) -> void:
	MV.register(["pontianak", "shuigui", "tianhua", "npc_guard", "npc_auntie", "npc_boss"])
