# 原生改寫自 moves_beast.js：惡鬼王、惡鬼、小鬼、殭屍（老姜／殭屍）
# 招式本體喺 game/battle/bt_moves.gd（原生主線戰鬥同一份）；呢度登記入 MOVES，jiangshiMove 照留做全局
extends RefCounted
const MV := preload("res://native/moves.gd")

func run(_env) -> void:
	MV.register(["eguiking", "egui", "xiaogui", "laojiang", "zombie"])
	J.G["jiangshiMove"] = J.G.MOVES.get("laojiang")
