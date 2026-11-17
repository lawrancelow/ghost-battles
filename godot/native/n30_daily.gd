# 原生改寫自 n30_daily.js：新鬼 40 隻平日小動作（DAILY['n30_<id>_<動作>']、N30D.ACTS）
# 每個動作嘅姿勢／特效喺 game/battle/bt_n30daily.gd（由 JS 生成）；呢度係共用骨架（同 JS 嘅 A() 一樣）
extends RefCounted

const BD := preload("res://game/battle/bt_n30daily.gd")
static var _act := {}

static func play(k: String, ctx, a):
	if not (ctx is Ctx) or not (a is Dictionary): return false
	var E: Array = _act[k]
	var S = BtN30.setup(a)
	if S == null: return false
	var H: float = S.H; var at = J.num(J.gp(a.o, "at")) if J.t(J.gp(a.o, "at")) else 0.0
	var dur: float = E[3]; var g = fmod(at, dur) / dur
	var f = E[5].call(g, H, S)
	if not (f is Dictionary): f = {}
	var m = BtN30.bm(S, f)
	ctx.save(); BtMoves.enter(ctx, S); BtMoves.shadow(ctx, S, BtN30.g(f, "x"), 0, 1 - BtN30.cl(-BtN30.g(f, "y") / H) * 0.5)
	if E[6] != null: E[6].call(ctx, S, g, m, f, H)
	BtN30.body(ctx, S, m, BtN30.pose(S, f, 1 if E[8] == null else E[8]), "", f.get("a"))
	if E[7] != null: E[7].call(ctx, S, g, m, f, H)
	ctx.restore()
	return null

func run(_env) -> void:
	var D = J.G.get("DAILY")
	if not (D is Dictionary): D = {}; J.G["DAILY"] = D
	var ACTS = {}
	for E in BD.list():
		var k: String = E[1]; _act[k] = E
		if not ACTS.has(E[0]): ACTS[E[0]] = []
		ACTS[E[0]].append([k, E[2], E[3], E[4]])
		D[k] = func(_t, a): return play(k, J.arg(a, 0), J.arg(a, 1))
	J.G["N30D"] = {"ACTS": ACTS}
