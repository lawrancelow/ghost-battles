# A 線截圖：設主角做「測試名／女」，播一段有「阿福」「少爺」嘅劇情，俾 tester 影相
# [["wait",3],["notitle"],["gdrun","res://tools/tests/xa_shot.gd","fem"],["wait",1.5],["shot","/tmp/A/fem_story.png"],["quit"]]
extends RefCounted

func fem(t) -> void:
	DB.hero_apply(DB.hero_make("測試名", "f"))
	var sc = {"style": "talk", "bg": "village", "title": "下班後", "lines": [["小紙", "少爺，阿福哥話你做到成隻鬼咁殘喇。"], ["阿福", "我係陳大福，Kelvin 都係我。"]]}
	t.main().story.queue(sc)
	print("[xa_shot] queued")

func male(t) -> void:
	DB.hero_apply(DB.hero_make("測試名", "m"))
	var sc = {"style": "talk", "bg": "village", "title": "下班後", "lines": [["小紙", "少爺，阿福哥話你做到成隻鬼咁殘喇。"], ["阿福", "我係陳大福，Kelvin 都係我。"]]}
	t.main().story.queue(sc)
