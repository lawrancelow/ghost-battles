# 原生改寫自 moves_chain.js：黑無常（鐵鏈）
# 招式本體喺 game/battle/bt_moves2.gd mv_heiwu；MoveKit（工具組，daily_work.js 都用）照用轉譯版——佢係 JS 物件介面（new MoveKit.M() 矩陣），
# 原生招式自己用 BtMoves 嘅 Transform2D 版，唔經 MoveKit
extends RefCounted
const MV := preload("res://native/moves.gd")
var _tr = null

func run(_env) -> void:
	var keep = J.G.MOVES.get("heiwu")
	_tr = load("res://jsgen/moves_chain.gd").new(); _tr.run(null)   # 只為 MoveKit
	if keep != null: J.G.MOVES["heiwu"] = keep
	MV.register(["heiwu"])
