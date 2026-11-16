# chatter 原生對照：同一個存檔深拷貝、同一個隨機種子，兩邊跑同一串呼叫，比回傳值同 S.chat／g.arch
extends "res://tools/tests/native_xcheck.gd"

var T0 := 0.0
func _run(C, S0: Dictionary, sd: int) -> Array:
	var S = S0.duplicate(true); J.G["S"] = S
	seed(sd)
	var out = []
	var gs: Array = S.ghosts
	for g in gs:
		out.append(J.mc(C, "archOf", [g])); out.append(J.mc(C, "sample", [g]))
		var p = J.mc(C, "poolOf", [g]); out.append(p.key if p != null else null)
	for r in 6:
		for g in gs: out.append(J.mc(C, "lineFor", [g]))
	for tg in [null, "", "夜", "晨", "early", "mid", "late", "win", "new", "p:wood", "arc:a1:1", "arc:a1:2", "mid,win"]:
		for g in [null, gs[0], gs[min(3, gs.size() - 1)]]: out.append(J.mc(C, "tagOk", [tg, g]))
	J.mc(C, "st", [])
	S.chat.ev["win"] = {"t": T0, "n": ""}; S.chat.ev["new"] = {"t": T0, "n": "阿強"}
	for r in 4:
		for g in gs: out.append(J.mc(C, "lineFor", [g]))
	for i in gs.size():
		for j in range(i + 1, mini(gs.size(), i + 6)):
			var cv = J.mc(C, "convFor", [gs[i], gs[j]])
			out.append([cv.cv, J.gp(cv.A, "id"), J.gp(cv.B, "id")] if cv != null else null)
	for g in gs: out.append(J.mc(C, "enterFor", [g]))
	for g in gs:
		var g2 = g.duplicate(true); g2.erase("arch"); out.append(J.mc(C, "archOf", [g2, true]))
	out.append(S.chat); out.append(gs.map(func(g): return g.get("arch")))
	return out

func chatter(_t) -> void:
	mod = "chatter"
	var tr = load_trans("chatter", ["Chatter"]).Chatter; var nat = J.G.Chatter
	var S0: Dictionary = J.G.S.duplicate(true)
	T0 = J.now()
	# 存檔冇雜鬼：每種有性格嘅雜鬼加兩隻（一隻英文花名）
	var n = 0
	for k in J.G.CHAT_DATA.arch:
		S0.ghosts.append({"id": "tf%d" % n, "k": k, "name": "%s・阿%d" % [k, n], "q": "藍", "lv": 3.0, "post": "wood"}); n += 1
		S0.ghosts.append({"id": "tf%d" % n, "k": k, "name": "%s・Ah Boy%d" % [k, n], "q": "紫", "lv": 5.0, "post": null}); n += 1
	var nf = 0
	for g in S0.ghosts: if str(g.get("q")) in ["藍", "紫"]: nf += 1
	print("[xcheck-info] ghosts=%d fodder=%d" % [S0.ghosts.size(), nf])
	for sd in [1, 7, 42, 99, 2026]:
		var a = _run(nat, S0, sd); var b = _run(tr, S0, sd)
		for i in a.size():
			if JSON.stringify(a[i]) == JSON.stringify(b[i]): ok += 1
			else:
				bad += 1
				if bad <= 12: print("[xcheck-diff] seed%d #%d nat=%s tr=%s" % [sd, i, JSON.stringify(a[i]).substr(0, 300), JSON.stringify(b[i]).substr(0, 300)])
	J.G["S"] = S0
	_report()
