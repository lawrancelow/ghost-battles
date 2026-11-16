# standup 原生對照：資料（套品牌替換後）、ok／audience、Standup.list、劇情回顧次序（多咗 c6_after）
extends "res://tools/tests/xc_l1.gd"

func standup(_t) -> void:
	mod = "standup"
	var Sb = _subs()
	var keys = ["SU_BITS", "XO_SCENES", "XO_AFTER", "XO_SPEAKERS", "Standup"]
	var nat = {}; for k in keys: nat[k] = J.G[k]
	var tr = load_trans("standup", keys)
	# build.sh 品牌表（轉譯版已套）
	var b = FileAccess.get_file_as_string("res://tools/jsgd/build.sh")
	var m = RegEx.create_from_string("for\\(const \\[a,b\\] of (\\[\\[.*?\\]\\])\\)").search(b)
	var all = JSON.parse_string(m.get_string(1)) + Sb
	eq("SU_BITS", nat.SU_BITS, _sub(tr.SU_BITS, all))
	eq("XO_SCENES", nat.XO_SCENES, _sub(tr.XO_SCENES, all))
	eq("XO_SPEAKERS", nat.XO_SPEAKERS, tr.XO_SPEAKERS)
	var xa = tr.XO_AFTER.duplicate(true); xa["epilogue"] = ["c6_after"]
	eq("XO_AFTER (+epilogue)", nat.XO_AFTER, xa)
	for bit in nat.SU_BITS:
		eq("ok " + bit.id, J.mc(nat.Standup, "ok", [bit]), J.mc(tr.Standup, "ok", [bit]))
		eq("audience " + bit.id, J.mc(nat.Standup, "audience", [bit]), J.mc(tr.Standup, "audience", [bit]))
	var s1 = J.mc(nat.Standup, "st", []); var s2 = J.mc(tr.Standup, "st", [])
	eq("st", s1, s2)
	eq("list", J.gp(nat.Standup, "list"), _sub(J.gp(tr.Standup, "list"), all))
	var row = []
	for r in J.G.SCENE_ORDER: if r[1].has("epilogue"): row = r[1]
	eq("SCENE_ORDER 尾聲", row, ["epilogue", "c6_after"])
	eq("SCENES.c6_after", J.G.SCENES.has("c6_after"), true)
	_report()
