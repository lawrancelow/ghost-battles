# 原生改寫自 moves.js：登記表（各分檔往入面加）
# register(keys)：MOVES[k] 用 art.js 嘅介面 MOVES[k](ctx, {type,x,y,s,H,o,faceRight,solid,shadow})，招式本體交俾 BtMoves.FN（原生主線戰鬥同一份）
extends RefCounted

func run(_env) -> void:
	J.G["MOVES"] = {}

static func register(keys: Array) -> void:
	BtMoves._setup_table()
	var M = J.G.get("MOVES")
	if not (M is Dictionary): M = {}; J.G["MOVES"] = M
	for k in keys:
		if not BtMoves.FN.has(k): continue
		M[k] = _mk(k)

static func _mk(k: String) -> Callable:
	return func(_t, a):
		var ctx = J.arg(a, 0); var arg = J.arg(a, 1)
		if not (ctx is Ctx) or not (arg is Dictionary): return false
		if k.begins_with("n30_"): BtN30.ensure_rig(k)
		return BtMoves.FN[k].call(ctx, arg)
