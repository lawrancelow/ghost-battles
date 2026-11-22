# [militia] 遊魂兵 UI（飄字、兵營面板一欄、出擊構成橫額）；全部 static
extends RefCounted

const ML = preload("res://game/militia/ml_data.gd")

# 大排檔事件：遊魂兵加入
static func eat(sc) -> void:
	for e in sc.sim.ev:
		if str(e.get("k", "")) != "ml_join": continue
		sc._float(e.pos, str(e.line), Color("#bff0a0"), 17, 2.0)
		if sc.has_method("_burst"): sc._burst(e.pos + Vector2(0, 30), Color("#d8f0b0"), 10)
