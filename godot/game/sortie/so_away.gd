# [away] 出征中嘅名鬼（連主角阿福）：村子／廣場唔再畫佢哋，主角唔可以留喺村度做手工。冇 class_name、冇 autoload。
extends RefCounted

static var _f := -1
static var _ks := {}

static func ks() -> Dictionary:   # 出緊征（未收隊）嘅我方名鬼種類 k → true；每幀算一次
	var f = Engine.get_process_frames()
	if f == _f: return _ks
	_f = f; _ks = {}
	var RTS = load("res://game/rts/rts.gd")
	for o in RTS.ops:
		if o == null or o.phase == "done": continue
		for u in o.units:
			if not (u is Dictionary): continue
			if J.num(u.get("side")) != 0 or J.t(u.get("minion")): continue
			_ks[J.str(u.get("k"))] = true
	return _ks

static func hero_out() -> bool: return ks().has("afu")
static func out(k) -> bool: return ks().has(J.str(k))
