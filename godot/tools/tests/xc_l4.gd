# L4（嚇人與陽間線）原生對照測試：["gdrun","res://tools/tests/xc_l4.gd","l4_scops"] 等
extends "res://tools/tests/native_xcheck.gd"

# ---- L4：資料模塊指紋（GB_NONAT=1 同原生各跑一次，比 /tmp/L4/fp_*.json）----
func l4_fp(_t) -> void:
	var G = J.G; var fp = {}
	fp["STN_FG"] = G.STN_FG; fp["STN_FG_W"] = G.STN_FG_W; fp["STN_FG_H"] = G.STN_FG_H
	fp["STN_PROPS"] = G.STN_PROPS; fp["STN_AB_SRC"] = G.STN_AB_SRC; fp["STN_AB_NOLEG"] = G.STN_AB_NOLEG; fp["PT_IMG_SRC"] = G.PT_IMG_SRC
	var keys = J.gp(G.PG_GHOSTS, "keys"); fp["PG_keys"] = keys
	for k in keys + ["n30_hantugalah"]:
		fp["GH_" + k] = G.GHOSTS.get(k); fp["SK_" + k] = G.SKILLS.get(k); fp["EN_" + k] = G.ENEMY_T.get(k)
		fp["CH_" + k] = J.gp(J.gp(G.ART, "CHAR_H"), k); fp["SPR_" + k] = J.t(J.gp(G.SPR, k))
		var L = G.get("L"); var g = G.GHOSTS.get(k)
		if g != null: for f in ["name", "title", "lore", "say", "trait"]: fp["L_%s_%s" % [k, f]] = J.str(J.cl(L, null, [g.get(f)]))
	for k in G.STN_AB_SRC: fp["SPRAB_" + k] = J.t(J.gp(G.SPR, k)); fp["SRCAB_" + k] = J.gp(G.get("SPR_SRC"), k)
	# STN_FG 函數
	var sites = G.STN_FG.keys(); var out = []
	for s in sites:
		for i in range(-1, 6):
			out.append(J.cl(G.STN_FG_list, null, [s, float(i)]).size())
			out.append(J.cl(G.STN_FG_list, null, [s, float(i), 700.0]).size())
	fp["fg_list"] = out
	var it = G.STN_FG[sites[0]][0][0]
	var im1 = J.cl(G.STN_FG_img, null, [it]); var im2 = J.cl(G.STN_FG_img, null, [it])
	fp["fg_img_same"] = im1 == im2; fp["fg_img_src"] = J.gp(im1, "src")
	var mode = "nonat" if OS.has_environment("GB_NONAT") else "nat"
	var f = FileAccess.open("/tmp/L4/fp_%s.json" % mode, FileAccess.WRITE); f.store_string(JSON.stringify(fp, " ", true)); f.close()
	print("[xcheck] l4_fp written ", mode, " natives=", JSRun.native_used)

# ---- L4：scare_ops（要喺 GB_NAT_EXTRA 開咗 scare_ops）----
func _sc_reset(Sc, seed: float) -> void:
	J.mc(Sc, "start", ["office", ["afu", "eguiking", "toyol"], true, seed])
	J.sp(Sc, "mana", 200.0); J.sp(Sc, "_intel", {}); J.sp(Sc, "known", {}); J.sp(Sc, "_opcd", {})

func _sc_sum(Sc) -> String:
	var ns = []
	for n in J.iter(J.gp(Sc, "npcs")):
		var o = {}
		for k in ["fear", "peak", "combo", "shaken", "fleeing", "gone", "bubT", "_seed", "out"]: o[k] = J.gp(n, k)   # bub 文字有隨機（其他人反應），唔比
		ns.append(o)
	var it = {}
	var I = J.gp(Sc, "_intel")
	if J.t(I): for k in I: it[k] = J.iter(I[k])
	return J.to_json({"mana": J.gp(Sc, "mana"), "kpi": J.gp(Sc, "kpi"), "expo": J.gp(Sc, "expo"), "opcd": J.gp(Sc, "_opcd"), "paused": J.gp(Sc, "paused"), "intel": it, "npcs": ns,
		"phone": J.gp(J.cl(J.G.get("$"), null, ["#sc-phone"]), "innerHTML")})

func _sc_cmp(label: String, a: String, b: String) -> void:
	if a == b: ok += 1
	else:
		bad += 1
		if bad <= 30:
			var i = 0
			while i < min(a.length(), b.length()) and a[i] == b[i]: i += 1
			print("[xcheck-diff] ", label, " @", i, " nat=", a.substr(max(0, i - 60), 200), "\n   tr=", b.substr(max(0, i - 60), 200))

func l4_scops(_t) -> void:
	mod = "scare_ops"
	var Sc = J.G.Scare
	J.mc(Sc, "start", ["office", ["afu", "eguiking", "toyol"]])   # 有 DOM（#sc-phone）
	var rt = J.gp(Sc, "renderTarget"); var hd = J.gp(Sc, "hud")
	var tr = load_trans("scare_ops", ["ScareOps"]).ScareOps; var nat = J.G.ScareOps
	J.sp(Sc, "renderTarget", rt); J.sp(Sc, "hud", hd)   # 轉譯版 boot 會再包一層，還原
	var keep_hook = J.G.get("__nat_scOps"); J.G["__nat_scOps"] = null   # 用 HTML 版視窗先比得到
	var M = {"nat": nat, "tr": tr}
	var npcs = J.iter(J.gp(Sc, "npcs"))
	for i in npcs.size():
		var res = {}
		for side in ["nat", "tr"]:
			var X = M[side]; var out = []
			_sc_reset(Sc, 77.0); var n = J.iter(J.gp(Sc, "npcs"))[i]
			out.append(J.to_json(J.cl(X.ctx, null, [Sc, n])))
			for st in ["", "walk", "work", "call"]:
				J.sp(n, "act", st); out.append(J.to_json(J.cl(X.ctx, null, [Sc, n])))
			var O = J.gp(X.OPS, J.gp(J.gp(n, "d"), "k"))
			if J.t(O) and J.t(J.gp(O, "apps")):
				for tab in [null, "msg", "photo", "search", "note"]: J.cl(X.openPhone, null, [Sc, n, tab]); out.append(_sc_sum(Sc))
				J.cl(X.compose, null, [Sc, n]); out.append(_sc_sum(Sc))
			if J.t(O) and J.t(J.gp(O, "pc")): J.cl(X.openPC, null, [Sc, n]); out.append(_sc_sum(Sc))
			J.cl(X.openPantry, null, [Sc, n]); out.append(_sc_sum(Sc))
			J.cl(X.close, null, [Sc]); out.append(_sc_sum(Sc))
			out.append(J.to_json(J.cl(X.cdOf, null, [Sc, n, "k1"])))
			res[side] = out
		for j in res.nat.size(): _sc_cmp("npc%d#%d" % [i, j], res.nat[j], res.tr[j])
	# act：每個人 × 每一招（手機／電腦／茶水間），陰氣夠／唔夠、冷卻
	for i in npcs.size():
		for side_ops in ["msgs", "pc", "pantry"]:
			var cnt = 0
			_sc_reset(Sc, 77.0); var n0 = J.iter(J.gp(Sc, "npcs"))[i]
			var O0 = J.gp(nat.OPS, J.gp(J.gp(n0, "d"), "k"))
			var list = []
			if side_ops == "msgs" and J.t(O0): list = J.iter(J.gp(O0, "msgs"))
			elif side_ops == "pc" and J.t(O0) and J.t(J.gp(O0, "pc")): list = J.iter(J.gp(J.gp(O0, "pc"), "ops"))
			elif side_ops == "pantry": list = J.iter(nat.PANTRY)
			for oi in list.size():
				var res = {}
				for side in ["nat", "tr"]:
					var X = M[side]; var out = []
					_sc_reset(Sc, 77.0); var n = J.iter(J.gp(Sc, "npcs"))[i]; J.sp(n, "_seed", 4242.0)
					var lst = J.iter(J.gp(X.OPS[J.str(J.gp(J.gp(n, "d"), "k"))], "msgs")) if side_ops == "msgs" else (J.iter(J.gp(J.gp(X.OPS[J.str(J.gp(J.gp(n, "d"), "k"))], "pc"), "ops")) if side_ops == "pc" else J.iter(X.PANTRY))
					var o = lst[oi]
					var kind = "msg" if side_ops == "msgs" else side_ops
					J.cl(X.act, null, [Sc, n, o, kind]); out.append(_sc_sum(Sc))
					if J.t(J.gp(o, "say")): out.append(str(J.seq(J.gp(n, "bub"), J.cl(J.G.L, null, [J.gp(o, "say")]))))   # 有指定對白：要蓋返佢
					J.cl(X.act, null, [Sc, n, o, kind]); out.append(_sc_sum(Sc))   # 冷卻中
					J.sp(Sc, "_opcd", {}); J.sp(Sc, "mana", 1.0); J.cl(X.act, null, [Sc, n, o, kind]); out.append(_sc_sum(Sc))   # 陰氣唔夠
					J.sp(Sc, "mana", 200.0); J.sp(n, "gone", true); J.cl(X.act, null, [Sc, n, o, kind]); out.append(_sc_sum(Sc))   # 人唔喺度
					res[side] = out
				for j in res.nat.size(): _sc_cmp("act npc%d %s#%d.%d" % [i, side_ops, oi, j], res.nat[j], res.tr[j])
	J.G["__nat_scOps"] = keep_hook
	_report()

func l4_turf(_t) -> void:
	J.mc(J.G.Street, "open", [])
	J.mc(J.gp(J.G.Street, "Turf"), "open", ["bus"])
	print("[xcheck] turf opened on=", J.gp(J.gp(J.G.Street, "Turf"), "on"))

func l4_scphone(_t) -> void:
	var Sc = J.G.Scare; var n = J.iter(J.gp(Sc, "npcs"))[0]
	J.sp(Sc, "sel", n); J.cl(J.G.ScareOps.openPhone, null, [Sc, n, "msg"])
	print("[xcheck] phone paused=", J.gp(Sc, "paused"), " intel=", J.iter(J.cl(J.G.ScareOps.intel, null, [Sc, J.gp(J.gp(n, "d"), "k")])))
