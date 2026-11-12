# 自動轉譯自 game.js（tools/jsgd.js）——唔好直接改，改原 JS 再轉
extends RefCounted

func run(env):
	var this_ = null; var a = []
	J.G["newState"] = Callable(self, "_f3").bind(env)
	J.G["save"] = Callable(self, "_f4").bind(env)
	J.G["load"] = Callable(self, "_f5").bind(env)
	J.G["fodderCount"] = Callable(self, "_f24").bind(env)
	J.G["workersAt"] = Callable(self, "_f26").bind(env)
	J.G["ghostById"] = Callable(self, "_f28").bind(env)
	J.G["gdef"] = Callable(self, "_f30").bind(env)
	J.G["ratesPerMin"] = Callable(self, "_f31").bind(env)
	J.G["produce"] = Callable(self, "_f32").bind(env)
	J.G["canPay"] = Callable(self, "_f33").bind(env)
	J.G["pay"] = Callable(self, "_f34").bind(env)
	J.G["costText"] = Callable(self, "_f35").bind(env)
	J.G["give"] = Callable(self, "_f38").bind(env)
	J.G["gainExp"] = Callable(self, "_f39").bind(env)
	J.G["onLevelUp"] = Callable(self, "_f40").bind(env)
	J.G["joinGhost"] = Callable(self, "_f42").bind(env)
	J.G["groundLayer"] = Callable(self, "_f110").bind(env)
	J.G["drawLily"] = Callable(self, "_f114").bind(env)
	J.G["bldUnlocked"] = Callable(self, "_f115").bind(env)
	J.G["furnaceReady"] = Callable(self, "_f117").bind(env)
	J.G["paintBg"] = Callable(self, "_f164").bind(env)
	J.G["postLabel"] = Callable(self, "_f165").bind(env)
	J.G["standOk"] = Callable(self, "_f241").bind(env)
	J.G["syncSnd"] = Callable(self, "_f242").bind(env)
	J.G["confirmInline"] = Callable(self, "_f243").bind(env)
	J.G["paintPortraits"] = Callable(self, "_f245").bind(env)
	J.G["recruitFodder"] = Callable(self, "_f247").bind(env)
	J.G["covered"] = Callable(self, "_f251").bind(env)
	J.G["loop"] = Callable(self, "_f252").bind(env)
	J.G["offlineGain"] = Callable(self, "_f253").bind(env)
	J.G["start"] = Callable(self, "_f254").bind(env)
	J.G["startGame"] = Callable(self, "_f257").bind(env)
	J.G["$"] = Callable(self, "_f1").bind(env)
	J.G["fmt"] = Callable(self, "_f2").bind(env)
	J.G["RES_NAMES"] = {"wood": "槐木", "rice": "糯米", "planks": "棺材板", "buns": "壽包", "coins": "冥幣", "troops": "陰兵"}
	J.G["SPEAKER_ART"] = {"阿福": "afu", "小紙": "xiaozhi", "白無常": "baiwu", "黑無常": "heiwu", "黑白無常": "baiwu", "黃總": "huang", "餓鬼王": "eguiking", "餓鬼": "egui", "Toyol": "toyol", "老殭": "laojiang", "Pontianak": "pontianak", "Pocong": "pocong", "Penanggal": "penanggal", "孟婆": "mengpo", "遊魂阿強": "youhun", "天花姐": "tianhua"}
	J.G["SAVE_KEY"] = "ghostBattles_v1"
	J.G["DEBUG"] = J.mc(J.re("debug", ""), "test", [J.gp(J.G.get("location"), "search")])
	J.G["S"] = null
	J.G["TIME_SCALE"] = 1.0
	J.G["F"] = {"expNeed": Callable(self, "_f6").bind(env), "ghostCap": Callable(self, "_f7").bind(env), "stat": Callable(self, "_f8").bind(env), "glv": Callable(self, "_f9").bind(env), "lvCost": Callable(self, "_f10").bind(env), "bldMax": Callable(self, "_f11").bind(env), "upCost": Callable(self, "_f12").bind(env), "builderDiscount": Callable(self, "_f13").bind(env), "slots": Callable(self, "_f14").bind(env), "mult": Callable(self, "_f15").bind(env), "cap": Callable(self, "_f16").bind(env), "troopCap": Callable(self, "_f17").bind(env), "rosterCap": Callable(self, "_f18").bind(env), "walk": Callable(self, "_f19").bind(env), "chopTime": Callable(self, "_f20").bind(env), "furnaceCD": 300.0, "feastCD": 1200.0, "furnaceCoins": Callable(self, "_f21").bind(env), "chestGain": Callable(self, "_f22").bind(env), "recruitCost": Callable(self, "_f23").bind(env), "feastNeed": 350.0}
	J.G["expAcc"] = 0.0
	J.G["Quest"] = {"cur": Callable(self, "_f44").bind(env), "progress": Callable(self, "_f45").bind(env), "done": Callable(self, "_f49").bind(env), "check": Callable(self, "_f50").bind(env), "complete": Callable(self, "_f52").bind(env)}
	J.G["W"] = 390.0
	J.G["WH"] = 1130.0
	J.G["POS"] = {"gate": [195.0, 118.0], "house": [195.0, 300.0], "furnace": [338.0, 258.0], "wood": [92.0, 612.0], "rice": [298.0, 612.0], "plank": [95.0, 752.0], "bun": [295.0, 752.0], "store": [195.0, 872.0], "home": [92.0, 1000.0], "camp": [300.0, 1000.0], "altar": [195.0, 1092.0]}
	J.G["DECOR"] = [["webTL", 223.0, 389.0], ["webTR", 375.0, 389.0], ["scarecrow", 293.0, 488.0], ["willo", 258.0, 438.0], ["willo", 350.0, 498.0], ["willo", 300.0, 404.0], ["post", 160.0, 180.0], ["post", 230.0, 180.0], ["post", 160.0, 690.0], ["post", 230.0, 690.0], ["post", 160.0, 945.0], ["post", 230.0, 945.0], ["grave", 26.0, 840.0], ["grave", 58.0, 858.0], ["grave", 362.0, 850.0], ["banana", 372.0, 560.0], ["banana", 18.0, 610.0], ["banana", 372.0, 930.0], ["banana", 20.0, 1060.0], ["offer", 150.0, 320.0], ["offer", 240.0, 320.0], ["grave", 360.0, 1080.0], ["offer", 290.0, 880.0]]
	J.G["TREE_POS"] = [[38.0, 402.0], [92.0, 392.0], [146.0, 404.0], [62.0, 452.0], [118.0, 448.0], [168.0, 458.0], [40.0, 506.0], [100.0, 512.0]]
	J.G["PADDY_POS"] = [[248.0, 412.0], [338.0, 412.0], [248.0, 462.0], [338.0, 462.0], [248.0, 512.0], [338.0, 512.0]]
	J.G["Village"] = {"cvs": null, "ctx": null, "camY": 0.0, "w": 390.0, "h": 600.0, "dpr": 1.0, "t": 0.0, "hero": {"x": 195.0, "y": 350.0, "tx": 195.0, "ty": 350.0, "dir": 1.0, "act": null, "actT": 0.0, "target": null}, "floats": [], "crows": [], "feathers": [], "drag": null, "workerPhase": {}, "vis": [], "bubble": null, "chatT": 6.0, "chatUsed": {}, "init": Callable(self, "_f54").bind(env), "resize": Callable(self, "_f60").bind(env), "setCam": Callable(self, "_f61").bind(env), "pt": Callable(self, "_f62").bind(env), "focus": Callable(self, "_f63").bind(env), "hitTest": Callable(self, "_f64").bind(env), "tap": Callable(self, "_f65").bind(env), "walkTo": Callable(self, "_f66").bind(env), "craft": Callable(self, "_f67").bind(env), "update": Callable(self, "_f68").bind(env), "doAct": Callable(self, "_f72").bind(env), "heroPose": Callable(self, "_f73").bind(env), "impact": Callable(self, "_f74").bind(env), "updateParts": Callable(self, "_f75").bind(env), "drawParts": Callable(self, "_f77").bind(env), "draw": Callable(self, "_f78").bind(env), "scatterCrows": Callable(self, "_f95").bind(env), "pickChatter": Callable(self, "_f96").bind(env), "drawBubble": Callable(self, "_f99").bind(env), "workerSpots": Callable(self, "_f103").bind(env), "questTarget": Callable(self, "_f106").bind(env), "drawPointer": Callable(self, "_f109").bind(env)}
	J.G["_ground"] = null
	J.G["JossFx"] = {"play": Callable(self, "_f118").bind(env)}
	J.G["Fx"] = {"lastPraise": {}, "float": Callable(self, "_f121").bind(env), "toast": Callable(self, "_f122").bind(env), "banner": Callable(self, "_f125").bind(env), "praise": Callable(self, "_f126").bind(env)}
	J.G["Story"] = {"q": [], "cur": null, "li": 0.0, "typing": false, "shown": "", "timer": null, "cb": null, "actors": [], "busy": Callable(self, "_f127").bind(env), "queue": Callable(self, "_f128").bind(env), "next": Callable(self, "_f129").bind(env), "render": Callable(self, "_f130").bind(env), "frame": Callable(self, "_f134").bind(env), "drawStage": Callable(self, "_f135").bind(env), "showLine": Callable(self, "_f137").bind(env), "drawAnchor": Callable(self, "_f142").bind(env), "chatLine": Callable(self, "_f143").bind(env), "chatEnd": Callable(self, "_f155").bind(env), "advance": Callable(self, "_f162").bind(env), "skipScene": Callable(self, "_f163").bind(env)}
	J.G["UI"] = {"tab": "village", "modalOpen": Callable(self, "_f166").bind(env), "refresh": Callable(self, "_f167").bind(env), "open": Callable(self, "_f169").bind(env), "sheet": Callable(self, "_f171").bind(env), "close": Callable(self, "_f172").bind(env), "openBuilding": Callable(self, "_f174").bind(env), "bldEffect": Callable(self, "_f184").bind(env), "postHtml": Callable(self, "_f187").bind(env), "postStatTxt": Callable(self, "_f189").bind(env), "pickWorker": Callable(self, "_f190").bind(env), "openRoster": Callable(self, "_f200").bind(env), "openChests": Callable(self, "_f214").bind(env), "openStory": Callable(self, "_f219").bind(env), "openBattleSelect": Callable(self, "_f240").bind(env)}
	J.G["lastT"] = J.S_performance_("now", [])
	J.G["saveT"] = 0.0
	J.G["uiT"] = 0.0
	J.G["FRAME_MS"] = (J.div(1000.0, 30.0) - 2.0)

func _f3(this_, a: Array, env):
	return {"v": 1.0, "lv": 1.0, "exp": 0.0, "res": {"wood": 0.0, "rice": 0.0, "planks": 0.0, "buns": 0.0, "coins": 0.0, "troops": 0.0}, "bld": {"house": 1.0, "wood": 1.0, "rice": 1.0, "plank": 0.0, "bun": 0.0, "store": 0.0, "home": 0.0, "camp": 0.0, "altar": 0.0, "furnace": 0.0}, "ghosts": [{"id": "afu", "k": "afu", "name": "阿福", "q": "主", "lv": 1.0, "st": [30.0, 30.0, 30.0], "post": null, "spent": 0.0}], "team": ["afu", null, null], "adviser": null, "cleared": {}, "qi": 0.0, "cnt": {"chop": 0.0, "rice": 0.0, "craftPlank": 0.0, "craftBun": 0.0, "recruit": 0.0, "feast": 0.0, "chest": 0.0}, "seen": {}, "chests": {"g": 0.0, "b": 0.0, "p": 0.0}, "furnaceAt": 0.0, "feastAt": 0.0, "last": J.S_Date_("now", []), "ended": false, "trees": [3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0], "treeRegrow": [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], "paddy": [1.0, 1.0, 1.0, 1.0, 1.0, 1.0], "paddyRegrow": [0.0, 0.0, 0.0, 0.0, 0.0, 0.0], "uid": 1.0, "prod": {}}

func _f4(this_, a: Array, env):
	var v_prev_66 = null; var v_pv_67 = null; var v_e_68 = null; var v_e_69 = null
	var _t1 = (not J.t(J.G.get("S")))
	var _t2 = (_t1 if _t1 else (not J.seq(J.typeof_(J.G.get("S")), "object")))
	if J.t((_t2 if _t2 else J.gp(J.G.get("window"), "__NOSAVE"))):
		return null
	var _t3 = J.G.get("S")
	var _t4 = J.S_Date_("now", [])
	J.sp(_t3, "last", _t4)
	v_prev_66 = J.S_localStorage_("getItem", [J.G.get("SAVE_KEY")])
	if J.t(v_prev_66):
		v_pv_67 = J.S_JSON_("parse", [v_prev_66])
		var _t8 = v_pv_67
		if J.t(_t8):
			var _t5 = J.gp(v_pv_67, "lv")
			var _t7 = (_t5 if J.t(_t5) else 1.0)
			var _t6 = J.gp(J.G.get("S"), "lv")
			_t8 = J.cmp(_t7, J.add((_t6 if J.t(_t6) else 1.0), 2.0), ">")
		if J.t(_t8):
			J.S_localStorage_("setItem", [J.add(J.G.get("SAVE_KEY"), "_hi"), v_prev_66])
	J.S_localStorage_("setItem", [J.G.get("SAVE_KEY"), J.S_JSON_("stringify", [J.G.get("S")])])

func _f5(this_, a: Array, env):
	var v_j_72 = null; var v_e_73 = null
	v_j_72 = J.S_localStorage_("getItem", [J.G.get("SAVE_KEY")])
	if J.t(v_j_72):
		return J.S_JSON_("parse", [v_j_72])
	return null

func _f25(this_, a: Array, env):
	var v_g_95 = null
	v_g_95 = J.arg(a, 0)
	var _t10 = J.seq(J.gp(v_g_95, "q"), "藍")
	return (_t10 if _t10 else J.seq(J.gp(v_g_95, "q"), "紫"))

func _f24(this_, a: Array, env):
	var _t9 = J.gp(J.G.get("S"), "ghosts")
	return J.len(J.mc(_t9, "filter", [Callable(self, "_f25").bind(env)]))

func _f27(this_, a: Array, env):
	var v_g_99 = null
	v_g_99 = J.arg(a, 0)
	return J.seq(J.gp(v_g_99, "post"), env["post"])

func _f26(this_, a: Array, env):
	var _s37 = {"__p": env, "post": null}
	_s37["post"] = J.arg(a, 0)
	var _t11 = J.gp(J.G.get("S"), "ghosts")
	return J.mc(_t11, "filter", [Callable(self, "_f27").bind(_s37)])

func _f29(this_, a: Array, env):
	var v_g_103 = null
	v_g_103 = J.arg(a, 0)
	return J.seq(J.gp(v_g_103, "id"), env["id"])

func _f28(this_, a: Array, env):
	var _s39 = {"__p": env, "id": null}
	_s39["id"] = J.arg(a, 0)
	var _t12 = J.gp(J.G.get("S"), "ghosts")
	return J.mc(_t12, "find", [Callable(self, "_f29").bind(_s39)])

func _f30(this_, a: Array, env):
	var v_g_106 = null
	v_g_106 = J.arg(a, 0)
	var _t13 = J.gp(J.G.get("GHOSTS"), J.gp(v_g_106, "k"))
	return (_t13 if J.t(_t13) else J.gp(J.G.get("FODDER"), J.gp(v_g_106, "k")))

func _f31(this_, a: Array, env):
	var v_r_109 = null; var v_g_110 = null; var v_lv_111 = null; var v_o_112 = null; var v_o_113 = null; var v_o_114 = null
	v_r_109 = {"wood": 0.0, "rice": 0.0, "planks": 0.0, "buns": 0.0, "troops": 0.0, "coins": 0.0, "woodUse": 0.0, "riceUse": 0.0, "bunUse": 0.0, "exp": 0.0}
	for _t14 in J.iter(J.gp(J.G.get("S"), "ghosts")):
		v_g_110 = _t14
		if (not J.t(J.gp(v_g_110, "post"))):
			continue
		v_lv_111 = J.mc(J.G.get("F"), "glv", [v_g_110])
		var _t15 = J.gp(v_g_110, "post")
		var _t16 = -1
		var _t17 = false
		if _t16 == -1 and J.seq(_t15, "wood"): _t16 = 0
		if _t16 == -1 and J.seq(_t15, "rice"): _t16 = 1
		if _t16 == -1 and J.seq(_t15, "plank"): _t16 = 2
		if _t16 == -1 and J.seq(_t15, "bun"): _t16 = 3
		if _t16 == -1 and J.seq(_t15, "camp"): _t16 = 4
		if _t16 == -1 and J.seq(_t15, "store"): _t16 = 5
		while true:
			if _t16 <= 0 and _t16 >= 0:
				var _t18 = J.add(J.gp(v_r_109, "wood"), J.mul((9.0 + J.mul(0.7, v_lv_111)), J.mc(J.G.get("F"), "mult", ["wood"])))
				J.sp(v_r_109, "wood", _t18)
				break
			if _t16 <= 1 and _t16 >= 0:
				var _t19 = J.add(J.gp(v_r_109, "rice"), J.mul((9.0 + J.mul(0.7, v_lv_111)), J.mc(J.G.get("F"), "mult", ["rice"])))
				J.sp(v_r_109, "rice", _t19)
				break
			if _t16 <= 2 and _t16 >= 0:
				v_o_112 = J.mul((2.5 + J.mul(J.mc(J.G.get("F"), "stat", [v_g_110, 0.0]), 0.05)), J.mc(J.G.get("F"), "mult", ["plank"]))
				var _t20 = J.add(J.gp(v_r_109, "planks"), v_o_112)
				J.sp(v_r_109, "planks", _t20)
				var _t21 = J.add(J.gp(v_r_109, "woodUse"), J.mul(v_o_112, 2.0))
				J.sp(v_r_109, "woodUse", _t21)
				break
			if _t16 <= 3 and _t16 >= 0:
				v_o_113 = J.mul((2.5 + J.mul(J.mc(J.G.get("F"), "stat", [v_g_110, 1.0]), 0.05)), J.mc(J.G.get("F"), "mult", ["bun"]))
				var _t22 = J.add(J.gp(v_r_109, "buns"), v_o_113)
				J.sp(v_r_109, "buns", _t22)
				var _t23 = J.add(J.gp(v_r_109, "riceUse"), J.mul(v_o_113, 2.0))
				J.sp(v_r_109, "riceUse", _t23)
				break
			if _t16 <= 4 and _t16 >= 0:
				v_o_114 = J.mul((2.0 + J.mul(J.mc(J.G.get("F"), "stat", [v_g_110, 2.0]), 0.04)), J.mc(J.G.get("F"), "mult", ["camp"]))
				var _t24 = J.gp(v_r_109, "drill")
				var _t25 = J.add((_t24 if J.t(_t24) else 0.0), v_o_114)
				J.sp(v_r_109, "drill", _t25)
				var _t26 = J.add(J.gp(v_r_109, "bunUse"), J.mul(v_o_114, 0.6))
				J.sp(v_r_109, "bunUse", _t26)
				var _t27 = J.gp(v_r_109, "drillBy")
				var _t28 = (_t27 if J.t(_t27) else [])
				J.sp(v_r_109, "drillBy", _t28)
				J.mc(_t28, "push", [[J.gp(v_g_110, "k"), v_o_114]])
				break
			if _t16 <= 5 and _t16 >= 0:
				if J.seq(J.gp(v_g_110, "k"), "toyol"):
					var _t29 = J.add(J.gp(v_r_109, "coins"), (2.0 + J.mul(v_lv_111, 0.25)))
					J.sp(v_r_109, "coins", _t29)
				break
			break
		var _t30 = J.add(J.gp(v_r_109, "exp"), 0.6)
		J.sp(v_r_109, "exp", _t30)
	if J.t(J.gp(J.gp(J.G.get("S"), "bld"), "home")):
		var _t31 = J.add(J.gp(v_r_109, "troops"), (1.2 + J.mul(1.3, J.gp(J.gp(J.G.get("S"), "bld"), "home"))))
		J.sp(v_r_109, "troops", _t31)
	return v_r_109

func _f32(this_, a: Array, env):
	var v_dt_117 = null; var v_r_118 = null; var v_m_119 = null; var v_cap_120 = null; var v_R_121 = null; var v_need_122 = null; var v_k_123 = null; var v_need_124 = null; var v_k_125 = null; var v_need_126 = null; var v_k_127 = null; var v_gk_128 = null; var v_o_129 = null; var v_e_130 = null
	v_dt_117 = J.arg(a, 0)
	v_r_118 = J.cl(J.G.get("ratesPerMin"), null, [])
	v_m_119 = J.div(v_dt_117, 60.0)
	v_cap_120 = J.mc(J.G.get("F"), "cap", [])
	v_R_121 = J.gp(J.G.get("S"), "res")
	if J.cmp(J.gp(v_R_121, "wood"), v_cap_120, "<"):
		var _t32 = J.min_([v_cap_120, J.add(J.gp(v_R_121, "wood"), J.mul(J.gp(v_r_118, "wood"), v_m_119))])
		J.sp(v_R_121, "wood", _t32)
	if J.cmp(J.gp(v_R_121, "rice"), v_cap_120, "<"):
		var _t33 = J.min_([v_cap_120, J.add(J.gp(v_R_121, "rice"), J.mul(J.gp(v_r_118, "rice"), v_m_119))])
		J.sp(v_R_121, "rice", _t33)
	var _t34 = J.gp(v_r_118, "planks")
	if J.t((J.cmp(J.gp(v_R_121, "planks"), v_cap_120, "<") if J.t(_t34) else _t34)):
		v_need_122 = J.mul(J.gp(v_r_118, "woodUse"), v_m_119)
		v_k_123 = (J.min_([1.0, J.div(J.gp(v_R_121, "wood"), v_need_122)]) if J.cmp(v_need_122, 0.0, ">") else 0.0)
		var _t35 = J.sub(J.gp(v_R_121, "wood"), J.mul(v_need_122, v_k_123))
		J.sp(v_R_121, "wood", _t35)
		var _t36 = J.min_([v_cap_120, J.add(J.gp(v_R_121, "planks"), J.mul(J.mul(J.gp(v_r_118, "planks"), v_m_119), v_k_123))])
		J.sp(v_R_121, "planks", _t36)
	var _t37 = J.gp(v_r_118, "buns")
	if J.t((J.cmp(J.gp(v_R_121, "buns"), v_cap_120, "<") if J.t(_t37) else _t37)):
		v_need_124 = J.mul(J.gp(v_r_118, "riceUse"), v_m_119)
		v_k_125 = (J.min_([1.0, J.div(J.gp(v_R_121, "rice"), v_need_124)]) if J.cmp(v_need_124, 0.0, ">") else 0.0)
		var _t38 = J.sub(J.gp(v_R_121, "rice"), J.mul(v_need_124, v_k_125))
		J.sp(v_R_121, "rice", _t38)
		var _t39 = J.min_([v_cap_120, J.add(J.gp(v_R_121, "buns"), J.mul(J.mul(J.gp(v_r_118, "buns"), v_m_119), v_k_125))])
		J.sp(v_R_121, "buns", _t39)
	var _t40 = J.gp(v_r_118, "troops")
	if J.t((J.cmp(J.gp(v_R_121, "troops"), J.mc(J.G.get("F"), "troopCap", []), "<") if J.t(_t40) else _t40)):
		var _t41 = J.min_([J.mc(J.G.get("F"), "troopCap", []), J.add(J.gp(v_R_121, "troops"), J.mul(J.gp(v_r_118, "troops"), v_m_119))])
		J.sp(v_R_121, "troops", _t41)
	if J.t(J.gp(v_r_118, "drillBy")):
		v_need_126 = J.mul(J.gp(v_r_118, "bunUse"), v_m_119)
		v_k_127 = (J.min_([1.0, J.div(J.gp(v_R_121, "buns"), v_need_126)]) if J.cmp(v_need_126, 0.0, ">") else 0.0)
		var _t42 = J.sub(J.gp(v_R_121, "buns"), J.mul(v_need_126, v_k_127))
		J.sp(v_R_121, "buns", _t42)
		var _t43 = J.G.get("S")
		var _t44 = J.gp(J.G.get("S"), "drill")
		var _t45 = (_t44 if J.t(_t44) else {})
		J.sp(_t43, "drill", _t45)
		for _t46 in J.iter(J.gp(v_r_118, "drillBy")):
			var _t47 = J.gp(_t46, 0.0)
			v_gk_128 = _t47
			var _t48 = J.gp(_t46, 1.0)
			v_o_129 = _t48
			var _t49 = J.gp(J.G.get("S"), "drill")
			var _t50 = J.gp(J.gp(J.G.get("S"), "drill"), v_gk_128)
			var _t51 = J.add((_t50 if J.t(_t50) else 0.0), J.mul(J.mul(v_o_129, v_m_119), v_k_127))
			J.sp(_t49, v_gk_128, _t51)
	var _t52 = J.add(J.gp(v_R_121, "coins"), J.mul(J.gp(v_r_118, "coins"), v_m_119))
	J.sp(v_R_121, "coins", _t52)
	var _t53 = J.add(J.G.get("expAcc"), J.mul(J.gp(v_r_118, "exp"), v_m_119))
	J.G["expAcc"] = _t53
	if J.cmp(J.G.get("expAcc"), 1.0, ">="):
		v_e_130 = floor(J.num(J.G.get("expAcc")))
		var _t54 = J.sub(J.G.get("expAcc"), v_e_130)
		J.G["expAcc"] = _t54
		var _t55 = J.G.get("gainExp")
		J.cl(_t55, null, [v_e_130, true])

func _f33(this_, a: Array, env):
	var v_c_133 = null; var v_k_134 = null
	v_c_133 = J.arg(a, 0)
	for _t56 in J.keys(v_c_133):
		v_k_134 = _t56
		var _t57 = J.gp(J.gp(J.G.get("S"), "res"), v_k_134)
		if J.cmp((_t57 if J.t(_t57) else 0.0), J.sub(J.gp(v_c_133, v_k_134), 0.000001), "<"):
			return false
	return true

func _f34(this_, a: Array, env):
	var v_c_137 = null; var v_k_138 = null
	v_c_137 = J.arg(a, 0)
	for _t58 in J.keys(v_c_137):
		v_k_138 = _t58
		var _t59 = J.gp(J.G.get("S"), "res")
		var _t60 = J.sub(J.gp(_t59, v_k_138), J.gp(v_c_137, v_k_138))
		J.sp(_t59, v_k_138, _t60)

func _f36(this_, a: Array, env):
	var v_k_142 = null
	v_k_142 = J.arg(a, 0)
	return J.gp(env["c"], v_k_142)

func _f37(this_, a: Array, env):
	var v_k_143 = null
	v_k_143 = J.arg(a, 0)
	var _t63 = J.gp(J.gp(J.G.get("S"), "res"), v_k_143)
	var _t65 = ("" if J.cmp((_t63 if J.t(_t63) else 0.0), J.gp(env["c"], v_k_143), ">=") else "lack")
	var _t66 = J.gp(J.G.get("RES_NAMES"), v_k_143)
	var _t64 = J.G.get("fmt")
	return ("<span class=\"" + _t65 + "\">" + J.str(_t66) + " " + J.str(J.cl(_t64, null, [J.gp(env["c"], v_k_143)])) + "</span>")

func _f35(this_, a: Array, env):
	var _s59 = {"__p": env, "c": null}
	_s59["c"] = J.arg(a, 0)
	var _t61 = J.S_Object_("keys", [_s59["c"]])
	var _t62 = J.mc(_t61, "filter", [Callable(self, "_f36").bind(_s59)])
	var _t67 = J.mc(_t62, "map", [Callable(self, "_f37").bind(_s59)])
	return J.mc(_t67, "join", ["　"])

func _f38(this_, a: Array, env):
	var v_r_146 = null; var v_src_147 = null; var v_parts_148 = null; var v_k_149 = null
	v_r_146 = J.arg(a, 0)
	v_src_147 = J.arg(a, 1)
	v_parts_148 = []
	for _t68 in J.keys(v_r_146):
		v_k_149 = _t68
		if J.seq(v_k_149, "exp"):
			var _t69 = J.G.get("gainExp")
			J.cl(_t69, null, [J.gp(v_r_146, "exp")])
			J.mc(v_parts_148, "push", [("好評 +" + J.str(J.gp(v_r_146, "exp")))])
		else:
			if J.seq(v_k_149, "chest"):
				var _t70 = J.gp(J.G.get("S"), "chests")
				var _t71 = J.gp(v_r_146, "chest")
				J.sp(_t70, _t71, J.num(J.gp(_t70, _t71)) + 1.0)
				J.mc(v_parts_148, "push", [J.add(J.gp({"g": "綠箱", "b": "藍箱", "p": "紫箱"}, J.gp(v_r_146, "chest")), " ×1")])
			else:
				var _t72 = J.gp(J.G.get("S"), "res")
				var _t73 = J.gp(J.gp(J.G.get("S"), "res"), v_k_149)
				var _t74 = J.add((_t73 if J.t(_t73) else 0.0), J.gp(v_r_146, v_k_149))
				J.sp(_t72, v_k_149, _t74)
				var _t76 = J.gp(J.G.get("RES_NAMES"), v_k_149)
				var _t75 = J.G.get("fmt")
				J.mc(v_parts_148, "push", [(J.str(_t76) + " +" + J.str(J.cl(_t75, null, [J.gp(v_r_146, v_k_149)])))])
	return J.mc(v_parts_148, "join", ["，"])

func _f39(this_, a: Array, env):
	var v_n_152 = null; var v_silent_153 = null; var v_up_154 = null
	v_n_152 = J.arg(a, 0)
	v_silent_153 = J.arg(a, 1)
	var _t77 = J.G.get("S")
	var _t78 = J.add(J.gp(_t77, "exp"), v_n_152)
	J.sp(_t77, "exp", _t78)
	v_up_154 = false
	while true:
		var _t79 = J.cmp(J.gp(J.G.get("S"), "lv"), 20.0, "<")
		if not (J.cmp(J.gp(J.G.get("S"), "exp"), J.mc(J.G.get("F"), "expNeed", [J.gp(J.G.get("S"), "lv")]), ">=") if _t79 else _t79): break
		var _t80 = J.G.get("S")
		var _t81 = J.sub(J.gp(_t80, "exp"), J.mc(J.G.get("F"), "expNeed", [J.gp(J.G.get("S"), "lv")]))
		J.sp(_t80, "exp", _t81)
		var _t82 = J.G.get("S")
		J.sp(_t82, "lv", J.num(J.gp(_t82, "lv")) + 1.0)
		v_up_154 = true
		var _t83 = J.G.get("onLevelUp")
		J.cl(_t83, null, [J.gp(J.G.get("S"), "lv")])
	if J.cmp(J.gp(J.G.get("S"), "lv"), 20.0, ">="):
		var _t84 = J.G.get("S")
		var _t85 = J.min_([J.gp(J.G.get("S"), "exp"), J.mc(J.G.get("F"), "expNeed", [20.0])])
		J.sp(_t84, "exp", _t85)
	if J.t(v_up_154):
		J.mc(J.G.get("UI"), "refresh", [])

func _f41(this_, a: Array, env):
	var _t88 = J.G.get("joinGhost")
	return J.cl(_t88, null, ["xiaozhi"])

func _f40(this_, a: Array, env):
	var v_lv_157 = null; var v_u_158 = null
	v_lv_157 = J.arg(a, 0)
	v_u_158 = J.gp(J.G.get("LEVEL_UNLOCKS"), v_lv_157)
	J.mc(J.G.get("Sound"), "play", ["levelUp"])
	J.mc(J.G.get("Fx"), "banner", [(("升級！Lv " + J.str(v_lv_157)) + (("　解鎖【" + J.str(J.gp(v_u_158, "name")) + "】") if J.t(v_u_158) else ""))])
	if J.t(v_u_158):
		var _t86 = J.gp(v_u_158, "lines")
		J.mc(J.G.get("Story"), "queue", [{"style": "sys", "lines": J.mc(_t86, "concat", [[["旁白", ("解鎖：" + J.str(J.gp(v_u_158, "desc")))]]])}])
	var _t87 = J.seq(v_lv_157, 4.0)
	if ((not J.t(J.gp(J.gp(J.G.get("S"), "seen"), "gift_xiaozhi"))) if _t87 else _t87):
		J.mc(J.G.get("Story"), "queue", ["gift_xiaozhi"])
		J.mc(J.G.get("Story"), "queue", ["gift_xiaozhi2", Callable(self, "_f41").bind(env)])

func _f43(this_, a: Array, env):
	var v_g_165 = null
	v_g_165 = J.arg(a, 0)
	return J.seq(J.gp(v_g_165, "k"), env["k"])

func _f42(this_, a: Array, env):
	var v_d_162 = null; var v_g_163 = null; var v_i_164 = null
	var _s74 = {"__p": env, "k": null}
	_s74["k"] = J.arg(a, 0)
	var _t89 = J.gp(J.G.get("S"), "ghosts")
	if J.t(J.mc(_t89, "some", [Callable(self, "_f43").bind(_s74)])):
		return null
	v_d_162 = J.gp(J.G.get("GHOSTS"), _s74["k"])
	var _t90 = J.G.get("S")
	var _t91 = J.num(J.gp(_t90, "uid"))
	J.sp(_t90, "uid", _t91 + 1.0)
	v_g_163 = {"id": J.add("g", _t91), "k": _s74["k"], "name": J.gp(v_d_162, "name"), "q": "名", "lv": J.max_([1.0, J.min_([J.mc(J.G.get("F"), "ghostCap", []), floor(J.num(J.mul(J.gp(J.G.get("S"), "lv"), 1.3)))])]), "st": J.mc(J.gp(v_d_162, "base"), "slice", []), "post": null, "spent": 0.0}
	var _t92 = J.gp(J.G.get("S"), "ghosts")
	J.mc(_t92, "push", [v_g_163])
	var _t93 = J.gp(J.G.get("S"), "team")
	v_i_164 = J.mc(_t93, "indexOf", [null])
	if J.cmp(v_i_164, 0.0, ">="):
		var _t94 = J.gp(J.G.get("S"), "team")
		var _t95 = J.gp(v_g_163, "id")
		J.sp(_t94, v_i_164, _t95)
	J.mc(J.G.get("Sound"), "play", ["gong"])
	J.mc(J.G.get("Fx"), "banner", [("【" + J.str(J.gp(v_d_162, "name")) + "】加入了落魄村！")])
	J.mc(J.G.get("UI"), "refresh", [])

func _f111(this_, a: Array, env):
	var _t98 = J.mod(J.mul(env["seed"], 16807.0), 2147483647.0)
	env["seed"] = _t98
	return J.div(env["seed"], 2147483647.0)

func _f112(this_, a: Array, env):
	var v_sx_462 = null; var v_sy_463 = null; var v_w_464 = null; var v_h_465 = null; var v_j_466 = null
	v_sx_462 = J.arg(a, 0)
	v_sy_463 = J.arg(a, 1)
	v_w_464 = J.arg(a, 2)
	v_h_465 = J.arg(a, 3)
	v_j_466 = (J.sub(J.cl(env["R"], null, []), 0.5) * 2.0)
	var _t115 = env["x"]
	var _t116 = J.gp(["#3c3a3e", "#36363a", "#413e40"], floor(J.num(J.mul(J.cl(env["R"], null, []), 3.0))))
	J.sp(_t115, "fillStyle", _t116)
	J.mc(env["x"], "beginPath", [])
	J.mc(env["x"], "roundRect", [J.add(v_sx_462, v_j_466), v_sy_463, J.sub(v_w_464, 2.0), J.sub(v_h_465, 2.0), 3.0])
	J.mc(env["x"], "fill", [])
	var _t117 = env["x"]
	J.sp(_t117, "fillStyle", "rgba(255,255,255,.05)")
	J.mc(env["x"], "fillRect", [J.add(J.add(v_sx_462, v_j_466), 2.0), J.add(v_sy_463, 1.0), J.sub(v_w_464, 6.0), 1.5])
	var _t118 = env["x"]
	J.sp(_t118, "fillStyle", "rgba(0,0,0,.35)")
	J.mc(env["x"], "fillRect", [J.add(v_sx_462, v_j_466), J.sub(J.add(v_sy_463, v_h_465), 3.0), J.sub(v_w_464, 2.0), 1.5])

func _f113(this_, a: Array, env):
	var v_tx_471 = null; var v_ty_472 = null; var v_k_473 = null
	v_tx_471 = J.arg(a, 0)
	v_ty_472 = J.arg(a, 1)
	var _t124 = env["x"]
	var _t125 = ("#34463a" if J.cmp(J.cl(env["R"], null, []), 0.5, "<") else "#3e5040")
	J.sp(_t124, "strokeStyle", _t125)
	var _t126 = env["x"]
	J.sp(_t126, "lineWidth", 1.3)
	v_k_473 = (-2.0)
	while true:
		if not J.cmp(v_k_473, 2.0, "<="): break
		J.mc(env["x"], "beginPath", [])
		J.mc(env["x"], "moveTo", [J.add(v_tx_471, J.mul(v_k_473, 1.6)), v_ty_472])
		J.mc(env["x"], "quadraticCurveTo", [J.add(v_tx_471, J.mul(v_k_473, 2.2)), J.sub(v_ty_472, 4.0), J.add(J.add(v_tx_471, J.mul(v_k_473, 3.0)), (J.sub(J.cl(env["R"], null, []), 0.5) * 2.0)), (J.sub(v_ty_472, 6.0) - J.mul(J.cl(env["R"], null, []), 4.0))])
		J.mc(env["x"], "stroke", [])
		v_k_473 = J.num(v_k_473) + 1.0

func _f110(this_, a: Array, env):
	var v_k_439 = null; var v_c_440 = null; var v_gr_444 = null; var v_hr_445 = null; var v_slab_446 = null; var v_tuft_447 = null; var v_vg_448 = null; var v_strokeCols_449 = null; var v_i_450 = null; var v_px_451 = null; var v_py_452 = null; var v_r_453 = null; var v_i_454 = null; var v_a_455 = null; var v_d_456 = null; var v_i_457 = null; var v_id_458 = null; var v_bx_459 = null; var v_by_460 = null; var v_w_461 = null; var v_y_467 = null; var v_off_468 = null; var v_ry_469 = null; var v_xx_470 = null; var v_i_474 = null; var v_tx_475 = null; var v_ty_476 = null; var v_i_477 = null; var v_px_478 = null; var v_py_479 = null; var v_len_480 = null; var v_a_481 = null; var v_i_482 = null
	var _s215 = {"__p": env, "x": null, "seed": null, "R": null}
	if J.t(J.G.get("_ground")):
		return J.G.get("_ground")
	v_k_439 = 2.0
	v_c_440 = J.S_document_("createElement", ["canvas"])
	var _t96 = J.mul(J.G.get("W"), v_k_439)
	J.sp(v_c_440, "width", _t96)
	var _t97 = J.mul(J.G.get("WH"), v_k_439)
	J.sp(v_c_440, "height", _t97)
	_s215["x"] = J.mc(v_c_440, "getContext", ["2d"])
	J.mc(_s215["x"], "scale", [v_k_439, v_k_439])
	_s215["seed"] = 7.0
	_s215["R"] = Callable(self, "_f111").bind(_s215)
	v_gr_444 = J.mc(_s215["x"], "createLinearGradient", [0.0, 0.0, 0.0, J.G.get("WH")])
	J.mc(v_gr_444, "addColorStop", [0.0, "#140f12"])
	J.mc(v_gr_444, "addColorStop", [0.13, "#211b19"])
	J.mc(v_gr_444, "addColorStop", [0.5, "#26201b"])
	J.mc(v_gr_444, "addColorStop", [1.0, "#221d1a"])
	var _t99 = _s215["x"]
	J.sp(_t99, "fillStyle", v_gr_444)
	J.mc(_s215["x"], "fillRect", [0.0, 0.0, J.G.get("W"), J.G.get("WH")])
	v_hr_445 = J.mc(_s215["x"], "createLinearGradient", [0.0, 0.0, 0.0, 160.0])
	J.mc(v_hr_445, "addColorStop", [0.0, "rgba(110,30,30,.55)"])
	J.mc(v_hr_445, "addColorStop", [1.0, "rgba(70,30,30,0)"])
	var _t100 = _s215["x"]
	J.sp(_t100, "fillStyle", v_hr_445)
	J.mc(_s215["x"], "beginPath", [])
	J.mc(_s215["x"], "moveTo", [160.0, 0.0])
	J.mc(_s215["x"], "lineTo", [230.0, 0.0])
	J.mc(_s215["x"], "lineTo", [246.0, 160.0])
	J.mc(_s215["x"], "lineTo", [144.0, 160.0])
	J.mc(_s215["x"], "fill", [])
	v_i_450 = 0.0
	while true:
		if not J.cmp(v_i_450, 700.0, "<"): break
		v_px_451 = J.mul(J.cl(_s215["R"], null, []), J.G.get("W"))
		v_py_452 = (140.0 + J.mul(J.cl(_s215["R"], null, []), J.sub(J.G.get("WH"), 140.0)))
		v_r_453 = (2.0 + J.mul(J.cl(_s215["R"], null, []), 9.0))
		var _t101 = _s215["x"]
		var _t102 = ("rgba(255,240,210,.025)" if J.cmp(J.cl(_s215["R"], null, []), 0.5, "<") else "rgba(0,0,0,.12)")
		J.sp(_t101, "fillStyle", _t102)
		J.mc(_s215["x"], "beginPath", [])
		J.mc(_s215["x"], "ellipse", [v_px_451, v_py_452, J.mul(v_r_453, 1.6), v_r_453, 0.0, 0.0, 6.3])
		J.mc(_s215["x"], "fill", [])
		v_i_450 = J.num(v_i_450) + 1.0
	var _t103 = _s215["x"]
	J.sp(_t103, "fillStyle", "rgba(20,30,22,.55)")
	J.mc(_s215["x"], "beginPath", [])
	J.mc(_s215["x"], "ellipse", [100.0, 455.0, 110.0, 92.0, 0.0, 0.0, 6.3])
	J.mc(_s215["x"], "fill", [])
	v_i_454 = 0.0
	while true:
		if not J.cmp(v_i_454, 90.0, "<"): break
		v_a_455 = J.mul(J.cl(_s215["R"], null, []), 6.3)
		v_d_456 = J.cl(_s215["R"], null, [])
		var _t104 = _s215["x"]
		var _t105 = J.gp(["#3a3a20", "#4a3a1c", "#2e3a26"], J.mod(v_i_454, 3.0))
		J.sp(_t104, "fillStyle", _t105)
		J.mc(_s215["x"], "beginPath", [])
		J.mc(_s215["x"], "ellipse", [(100.0 + J.mul((cos(J.num(v_a_455)) * 100.0), v_d_456)), (455.0 + J.mul((sin(J.num(v_a_455)) * 80.0), v_d_456)), 2.2, 1.2, J.mul(J.cl(_s215["R"], null, []), 3.0), 0.0, 6.3])
		J.mc(_s215["x"], "fill", [])
		v_i_454 = J.num(v_i_454) + 1.0
	var _t106 = _s215["x"]
	J.sp(_t106, "fillStyle", "#18221f")
	J.mc(_s215["x"], "fillRect", [222.0, 388.0, 154.0, 146.0])
	var _t107 = _s215["x"]
	J.sp(_t107, "fillStyle", "rgba(70,100,95,.18)")
	v_i_457 = 0.0
	while true:
		if not J.cmp(v_i_457, 3.0, "<"): break
		J.mc(_s215["x"], "fillRect", [222.0, ((388.0 + J.mul(v_i_457, 50.0)) + 34.0), 154.0, 4.0])
		v_i_457 = J.num(v_i_457) + 1.0
	var _t108 = _s215["x"]
	J.sp(_t108, "strokeStyle", "#3a3a2c")
	var _t109 = _s215["x"]
	J.sp(_t109, "lineWidth", 3.0)
	J.mc(_s215["x"], "strokeRect", [222.0, 388.0, 154.0, 146.0])
	for _t110 in J.iter(J.S_Object_("keys", [J.G.get("POS")])):
		v_id_458 = _t110
		if J.seq(v_id_458, "gate"):
			continue
		var _t111 = J.gp(J.G.get("POS"), v_id_458)
		var _t112 = J.gp(_t111, 0.0)
		v_bx_459 = _t112
		var _t113 = J.gp(_t111, 1.0)
		v_by_460 = _t113
		v_w_461 = (80.0 if J.seq(v_id_458, "house") else (30.0 if J.seq(v_id_458, "furnace") else 56.0))
		var _t114 = _s215["x"]
		J.sp(_t114, "fillStyle", "rgba(60,48,36,.35)")
		J.mc(_s215["x"], "beginPath", [])
		J.mc(_s215["x"], "ellipse", [v_bx_459, J.sub(v_by_460, 4.0), v_w_461, 16.0, 0.0, 0.0, 6.3])
		J.mc(_s215["x"], "fill", [])
	v_slab_446 = Callable(self, "_f112").bind(_s215)
	v_y_467 = 150.0
	while true:
		if not J.cmp(v_y_467, J.G.get("WH"), "<"): break
		v_off_468 = (0.0 if J.t(J.mod(J.div(v_y_467, 18.0), 2.0)) else 12.0)
		J.cl(v_slab_446, null, [(172.0 - J.div(v_off_468, 2.0)), v_y_467, (24.0 + J.div(v_off_468, 2.0)), 18.0])
		J.cl(v_slab_446, null, [(196.0 + (0.0 if J.t(v_off_468) else (-6.0))), v_y_467, ((24.0 - (0.0 if J.t(v_off_468) else (-6.0))) + (0.0 if J.t(v_off_468) else 0.0)), 18.0])
		var _t119 = J.add(v_y_467, 18.0)
		v_y_467 = _t119
	for _t120 in J.iter([678.0, 932.0]):
		v_ry_469 = _t120
		v_xx_470 = 0.0
		while true:
			if not J.cmp(v_xx_470, J.G.get("W"), "<"): break
			var _t121 = J.cmp(v_xx_470, 160.0, ">")
			if (J.cmp(v_xx_470, 222.0, "<") if _t121 else _t121):
				var _t122 = J.add(v_xx_470, 22.0)
				v_xx_470 = _t122
				continue
			J.cl(v_slab_446, null, [v_xx_470, v_ry_469, 22.0, 11.0])
			J.cl(v_slab_446, null, [J.add(v_xx_470, 11.0), J.add(v_ry_469, 11.0), 22.0, 11.0])
			var _t123 = J.add(v_xx_470, 22.0)
			v_xx_470 = _t123
	v_tuft_447 = Callable(self, "_f113").bind(_s215)
	v_i_474 = 0.0
	while true:
		if not J.cmp(v_i_474, 220.0, "<"): break
		v_tx_475 = J.mul(J.cl(_s215["R"], null, []), J.G.get("W"))
		v_ty_476 = (150.0 + J.mul(J.cl(_s215["R"], null, []), J.sub(J.G.get("WH"), 150.0)))
		var _t127 = J.cmp(v_tx_475, 160.0, ">")
		if (J.cmp(v_tx_475, 230.0, "<") if _t127 else _t127):
			v_i_474 = J.num(v_i_474) + 1.0
			continue
		var _t128 = J.cmp(v_tx_475, 218.0, ">")
		var _t129 = (J.cmp(v_ty_476, 384.0, ">") if _t128 else _t128)
		if (J.cmp(v_ty_476, 538.0, "<") if _t129 else _t129):
			v_i_474 = J.num(v_i_474) + 1.0
			continue
		var _t130 = (absf(J.num(J.sub(v_ty_476, 690.0))) < 16.0)
		if (_t130 if _t130 else (absf(J.num(J.sub(v_ty_476, 942.0))) < 16.0)):
			v_i_474 = J.num(v_i_474) + 1.0
			continue
		J.cl(v_tuft_447, null, [v_tx_475, v_ty_476])
		v_i_474 = J.num(v_i_474) + 1.0
	v_vg_448 = J.mc(_s215["x"], "createLinearGradient", [0.0, 0.0, J.G.get("W"), 0.0])
	J.mc(v_vg_448, "addColorStop", [0.0, "rgba(0,0,0,.35)"])
	J.mc(v_vg_448, "addColorStop", [0.12, "rgba(0,0,0,0)"])
	J.mc(v_vg_448, "addColorStop", [0.88, "rgba(0,0,0,0)"])
	J.mc(v_vg_448, "addColorStop", [1.0, "rgba(0,0,0,.35)"])
	v_strokeCols_449 = ["rgba(120,92,62,.16)", "rgba(70,56,40,.22)", "rgba(150,120,80,.10)", "rgba(60,80,58,.14)", "rgba(20,14,10,.22)"]
	var _t131 = _s215["x"]
	J.sp(_t131, "lineCap", "round")
	v_i_477 = 0.0
	while true:
		if not J.cmp(v_i_477, 16000.0, "<"): break
		v_px_478 = J.mul(J.cl(_s215["R"], null, []), J.G.get("W"))
		v_py_479 = (120.0 + J.mul(J.cl(_s215["R"], null, []), J.sub(J.G.get("WH"), 120.0)))
		v_len_480 = (3.0 + J.mul(J.cl(_s215["R"], null, []), 7.0))
		v_a_481 = ((-0.6) + (J.sub(J.cl(_s215["R"], null, []), 0.5) * 0.35))
		var _t132 = _s215["x"]
		var _t133 = J.gp(v_strokeCols_449, floor(J.num(J.mul(J.cl(_s215["R"], null, []), J.len(v_strokeCols_449)))))
		J.sp(_t132, "strokeStyle", _t133)
		var _t134 = _s215["x"]
		var _t135 = (0.6 + J.mul(J.cl(_s215["R"], null, []), 1.1))
		J.sp(_t134, "lineWidth", _t135)
		J.mc(_s215["x"], "beginPath", [])
		J.mc(_s215["x"], "moveTo", [v_px_478, v_py_479])
		J.mc(_s215["x"], "lineTo", [J.add(v_px_478, J.mul(cos(J.num(v_a_481)), v_len_480)), J.add(v_py_479, J.mul(sin(J.num(v_a_481)), v_len_480))])
		J.mc(_s215["x"], "stroke", [])
		v_i_477 = J.num(v_i_477) + 1.0
	v_i_482 = 0.0
	while true:
		if not J.cmp(v_i_482, 5000.0, "<"): break
		var _t136 = _s215["x"]
		var _t137 = ("rgba(235,220,190,.07)" if J.cmp(J.cl(_s215["R"], null, []), 0.6, "<") else "rgba(0,0,0,.18)")
		J.sp(_t136, "fillStyle", _t137)
		J.mc(_s215["x"], "fillRect", [J.mul(J.cl(_s215["R"], null, []), J.G.get("W")), J.mul(J.cl(_s215["R"], null, []), J.G.get("WH")), (0.5 + J.mul(J.cl(_s215["R"], null, []), 0.9)), (0.5 + J.mul(J.cl(_s215["R"], null, []), 0.9))])
		v_i_482 = J.num(v_i_482) + 1.0
	var _t138 = _s215["x"]
	J.sp(_t138, "fillStyle", v_vg_448)
	J.mc(_s215["x"], "fillRect", [0.0, 0.0, J.G.get("W"), J.G.get("WH")])
	J.G["_ground"] = v_c_440
	return v_c_440

func _f114(this_, a: Array, env):
	var v_ctx_485 = null; var v_x_486 = null; var v_y_487 = null; var v_t_488 = null; var v_k_489 = null; var v_a_490 = null
	v_ctx_485 = J.arg(a, 0)
	v_x_486 = J.arg(a, 1)
	v_y_487 = J.arg(a, 2)
	v_t_488 = J.arg(a, 3)
	J.sp(v_ctx_485, "strokeStyle", "#3a5a32")
	J.sp(v_ctx_485, "lineWidth", 1.2)
	J.mc(v_ctx_485, "beginPath", [])
	J.mc(v_ctx_485, "moveTo", [v_x_486, J.add(v_y_487, 12.0)])
	J.mc(v_ctx_485, "lineTo", [v_x_486, J.add(v_y_487, 2.0)])
	J.mc(v_ctx_485, "stroke", [])
	J.sp(v_ctx_485, "strokeStyle", "rgba(214,40,52,.9)")
	J.sp(v_ctx_485, "lineWidth", 1.5)
	J.sp(v_ctx_485, "lineCap", "round")
	v_k_489 = 0.0
	while true:
		if not J.cmp(v_k_489, 6.0, "<"): break
		v_a_490 = (((J.div(v_k_489, 6.0) * PI) * 2.0) + (sin(J.num(J.mul(v_t_488, 0.6))) * 0.15))
		J.mc(v_ctx_485, "beginPath", [])
		J.mc(v_ctx_485, "moveTo", [v_x_486, v_y_487])
		J.mc(v_ctx_485, "quadraticCurveTo", [J.add(v_x_486, (cos(J.num(v_a_490)) * 4.0)), J.sub(J.add(v_y_487, (sin(J.num(v_a_490)) * 4.0)), 3.0), J.add(v_x_486, (cos(J.num(v_a_490)) * 7.0)), J.sub(J.add(v_y_487, (sin(J.num(v_a_490)) * 6.0)), 4.0)])
		J.mc(v_ctx_485, "stroke", [])
		v_k_489 = J.num(v_k_489) + 1.0
	J.sp(v_ctx_485, "fillStyle", "#ff6060")
	J.mc(v_ctx_485, "beginPath", [])
	J.mc(v_ctx_485, "arc", [v_x_486, v_y_487, 1.6, 0.0, 6.3])
	J.mc(v_ctx_485, "fill", [])

func _f116(this_, a: Array, env):
	var v_q_496 = null
	v_q_496 = J.arg(a, 0)
	var _t141 = J.seq(J.gp(v_q_496, "t"), "build")
	return (J.seq(J.gp(v_q_496, "b"), env["id"]) if _t141 else _t141)

func _f115(this_, a: Array, env):
	var v_b_494 = null; var v_qi_495 = null
	var _s242 = {"__p": env, "id": null}
	_s242["id"] = J.arg(a, 0)
	v_b_494 = J.gp(J.G.get("BUILDINGS"), _s242["id"])
	var _t139 = J.gp(v_b_494, "unlockLv")
	if J.t((J.cmp(J.gp(J.G.get("S"), "lv"), J.gp(v_b_494, "unlockLv"), "<") if J.t(_t139) else _t139)):
		return false
	var _t140 = J.gp(v_b_494, "unlockStage")
	if J.t(((not J.t(J.gp(J.gp(J.G.get("S"), "cleared"), J.gp(v_b_494, "unlockStage")))) if J.t(_t140) else _t140)):
		return false
	if J.t(J.gp(v_b_494, "unlockQuest")):
		v_qi_495 = J.mc(J.G.get("QUESTS"), "findIndex", [Callable(self, "_f116").bind(_s242)])
		if J.cmp(v_qi_495, J.gp(J.G.get("S"), "qi"), ">"):
			return false
	return true

func _f117(this_, a: Array, env):
	var _t142 = J.gp(J.gp(J.G.get("S"), "bld"), "furnace")
	return ((J.sub(J.S_Date_("now", []), J.gp(J.G.get("S"), "furnaceAt")) >= J.div(J.mul(J.gp(J.G.get("F"), "furnaceCD"), 1000.0), J.G.get("TIME_SCALE"))) if J.t(_t142) else _t142)

func _f164(this_, a: Array, env):
	var v_ctx_691 = null; var v_w_692 = null; var v_h_693 = null; var v_bg_694 = null; var v_t_695 = null; var v_sky_696 = null; var v_g_697 = null; var v_gy_698 = null; var v_mg_699 = null; var v_i_700 = null; var v_x_701 = null; var v_k_702 = null; var v_i_703 = null; var v_x_704 = null; var v_k_705 = null; var v_i_706 = null; var v_x_707 = null; var v_hh_708 = null; var v_a_709 = null; var v_b_710 = null; var v_i_711 = null; var v_x_712 = null; var v_y_713 = null; var v_k_714 = null; var v_a_715 = null; var v_i_716 = null; var v_x_717 = null
	v_ctx_691 = J.arg(a, 0)
	v_w_692 = J.arg(a, 1)
	v_h_693 = J.arg(a, 2)
	v_bg_694 = J.arg(a, 3)
	v_t_695 = J.arg(a, 4)
	if J.t(J.mc(J.G.get("SCENE"), "drawBg", [v_ctx_691, v_w_692, v_h_693, v_bg_694])):
		return null
	var _t143 = J.gp({"village": ["#121016", "#24222a"], "road": ["#1a0f22", "#3a1a2a"], "field": ["#0f1a1a", "#26332a"], "kampung": ["#0c1420", "#1f2a33"], "banana": ["#0a140f", "#1c2e22"], "hq": ["#0e0e1a", "#26263c"], "office": ["#141420", "#2c2c3a"]}, v_bg_694)
	v_sky_696 = (_t143 if J.t(_t143) else ["#120f22", "#2a2440"])
	v_g_697 = J.mc(v_ctx_691, "createLinearGradient", [0.0, 0.0, 0.0, v_h_693])
	J.mc(v_g_697, "addColorStop", [0.0, J.gp(v_sky_696, 0.0)])
	J.mc(v_g_697, "addColorStop", [1.0, J.gp(v_sky_696, 1.0)])
	J.sp(v_ctx_691, "fillStyle", v_g_697)
	J.mc(v_ctx_691, "fillRect", [0.0, 0.0, v_w_692, v_h_693])
	J.mc(J.G.get("ART"), "el", [v_ctx_691, J.mul(v_w_692, 0.78), J.mul(v_h_693, 0.13), 28.0, 28.0, "rgba(240,230,200,.85)"])
	J.mc(J.G.get("ART"), "el", [v_ctx_691, (J.mul(v_w_692, 0.78) + 8.0), (J.mul(v_h_693, 0.13) - 4.0), 26.0, 26.0, J.gp(v_sky_696, 0.0)])
	v_gy_698 = J.mul(v_h_693, 0.66)
	J.sp(v_ctx_691, "fillStyle", "rgba(0,0,0,.35)")
	if J.seq(v_bg_694, "banana"):
		v_i_700 = 0.0
		while true:
			if not J.cmp(v_i_700, 6.0, "<"): break
			v_x_701 = J.div(J.mul(v_i_700, v_w_692), 5.0)
			J.mc(v_ctx_691, "fillRect", [J.sub(v_x_701, 4.0), J.sub(v_gy_698, 170.0), 8.0, 170.0])
			v_k_702 = 0.0
			while true:
				if not J.cmp(v_k_702, 5.0, "<"): break
				J.mc(v_ctx_691, "save", [])
				J.mc(v_ctx_691, "translate", [v_x_701, J.sub(v_gy_698, 170.0)])
				J.mc(v_ctx_691, "rotate", [((-1.2) + J.mul(v_k_702, 0.6))])
				J.mc(J.G.get("ART"), "el", [v_ctx_691, 40.0, 0.0, 44.0, 10.0, "rgba(10,30,18,.8)"])
				J.mc(v_ctx_691, "restore", [])
				v_k_702 = J.num(v_k_702) + 1.0
			v_i_700 = J.num(v_i_700) + 1.0
	else:
		if J.seq(v_bg_694, "kampung"):
			v_i_703 = 0.0
			while true:
				if not J.cmp(v_i_703, 4.0, "<"): break
				v_x_704 = (20.0 + J.div(J.mul(v_i_703, v_w_692), 3.6))
				J.mc(v_ctx_691, "fillRect", [v_x_704, J.sub(v_gy_698, 90.0), 90.0, 50.0])
				J.mc(v_ctx_691, "beginPath", [])
				J.mc(v_ctx_691, "moveTo", [J.sub(v_x_704, 10.0), J.sub(v_gy_698, 88.0)])
				J.mc(v_ctx_691, "lineTo", [J.add(v_x_704, 45.0), J.sub(v_gy_698, 130.0)])
				J.mc(v_ctx_691, "lineTo", [J.add(v_x_704, 100.0), J.sub(v_gy_698, 88.0)])
				J.mc(v_ctx_691, "fill", [])
				v_k_705 = 0.0
				while true:
					if not J.cmp(v_k_705, 4.0, "<"): break
					J.mc(v_ctx_691, "fillRect", [J.add(v_x_704, J.mul(v_k_705, 28.0)), J.sub(v_gy_698, 40.0), 5.0, 40.0])
					v_k_705 = J.num(v_k_705) + 1.0
				v_i_703 = J.num(v_i_703) + 1.0
		else:
			var _t144 = J.seq(v_bg_694, "hq")
			if (_t144 if _t144 else J.seq(v_bg_694, "office")):
				v_i_706 = 0.0
				while true:
					if not J.cmp(v_i_706, 5.0, "<"): break
					v_x_707 = J.div(J.mul(v_i_706, v_w_692), 4.5)
					v_hh_708 = (160.0 + (J.mod(v_i_706, 3.0) * 70.0))
					J.mc(v_ctx_691, "fillRect", [v_x_707, J.sub(v_gy_698, v_hh_708), 70.0, v_hh_708])
					J.sp(v_ctx_691, "fillStyle", "rgba(255,220,120,.18)")
					v_a_709 = 0.0
					while true:
						if not J.cmp(v_a_709, 6.0, "<"): break
						v_b_710 = 0.0
						while true:
							if not J.cmp(v_b_710, 3.0, "<"): break
							if J.t(J.mod(J.add(J.add(J.mul(v_a_709, 3.0), v_b_710), v_i_706), 4.0)):
								J.mc(v_ctx_691, "fillRect", [J.add(J.add(v_x_707, 8.0), J.mul(v_b_710, 20.0)), ((J.sub(v_gy_698, v_hh_708) + 12.0) + J.mul(v_a_709, 22.0)), 10.0, 12.0])
							v_b_710 = J.num(v_b_710) + 1.0
						v_a_709 = J.num(v_a_709) + 1.0
					J.sp(v_ctx_691, "fillStyle", "rgba(0,0,0,.35)")
					v_i_706 = J.num(v_i_706) + 1.0
				if J.seq(v_bg_694, "office"):
					J.sp(v_ctx_691, "fillStyle", "rgba(30,24,20,.9)")
					J.mc(v_ctx_691, "fillRect", [0.0, J.sub(v_gy_698, 10.0), v_w_692, 30.0])
			else:
				if J.seq(v_bg_694, "road"):
					J.sp(v_ctx_691, "fillStyle", "rgba(120,40,60,.25)")
					J.mc(v_ctx_691, "beginPath", [])
					J.mc(v_ctx_691, "moveTo", [J.mul(v_w_692, 0.42), J.sub(v_gy_698, 160.0)])
					J.mc(v_ctx_691, "lineTo", [J.mul(v_w_692, 0.58), J.sub(v_gy_698, 160.0)])
					J.mc(v_ctx_691, "lineTo", [v_w_692, v_gy_698])
					J.mc(v_ctx_691, "lineTo", [0.0, v_gy_698])
					J.mc(v_ctx_691, "fill", [])
					v_i_711 = 0.0
					while true:
						if not J.cmp(v_i_711, 14.0, "<"): break
						v_x_712 = J.mod(J.mul(v_i_711, 71.0), v_w_692)
						v_y_713 = (J.sub(v_gy_698, 20.0) - J.mod(J.mul(v_i_711, 37.0), 120.0))
						J.sp(v_ctx_691, "strokeStyle", "rgba(230,50,70,.6)")
						J.sp(v_ctx_691, "lineWidth", 1.5)
						v_k_714 = 0.0
						while true:
							if not J.cmp(v_k_714, 6.0, "<"): break
							v_a_715 = ((J.div(v_k_714, 6.0) * PI) * 2.0)
							J.mc(v_ctx_691, "beginPath", [])
							J.mc(v_ctx_691, "moveTo", [v_x_712, v_y_713])
							J.mc(v_ctx_691, "lineTo", [J.add(v_x_712, (cos(J.num(v_a_715)) * 7.0)), J.add(v_y_713, (sin(J.num(v_a_715)) * 7.0))])
							J.mc(v_ctx_691, "stroke", [])
							v_k_714 = J.num(v_k_714) + 1.0
						v_i_711 = J.num(v_i_711) + 1.0
				else:
					v_i_716 = 0.0
					while true:
						if not J.cmp(v_i_716, 7.0, "<"): break
						v_x_717 = J.div(J.mul(v_i_716, v_w_692), 6.0)
						J.mc(J.G.get("ART"), "el", [v_ctx_691, v_x_717, J.sub(v_gy_698, 60.0), 40.0, 50.0, "rgba(10,20,20,.6)"])
						J.sp(v_ctx_691, "fillStyle", "rgba(10,20,20,.6)")
						J.mc(v_ctx_691, "fillRect", [J.sub(v_x_717, 4.0), J.sub(v_gy_698, 30.0), 8.0, 30.0])
						v_i_716 = J.num(v_i_716) + 1.0
	J.sp(v_ctx_691, "fillStyle", "rgba(10,8,18,.55)")
	J.mc(v_ctx_691, "fillRect", [0.0, v_gy_698, v_w_692, J.sub(v_h_693, v_gy_698)])
	v_mg_699 = J.mc(v_ctx_691, "createLinearGradient", [0.0, J.sub(v_gy_698, 40.0), 0.0, J.add(v_gy_698, 20.0)])
	J.mc(v_mg_699, "addColorStop", [0.0, "rgba(180,170,230,0)"])
	J.mc(v_mg_699, "addColorStop", [1.0, "rgba(180,170,230,.12)"])
	J.sp(v_ctx_691, "fillStyle", v_mg_699)
	J.mc(v_ctx_691, "fillRect", [0.0, J.sub(v_gy_698, 40.0), v_w_692, 60.0])

func _f165(this_, a: Array, env):
	var v_p_720 = null
	v_p_720 = J.arg(a, 0)
	if J.t(J.gp(J.G.get("POSTS"), v_p_720)):
		return J.add("打工：", J.gp(J.gp(J.G.get("POSTS"), v_p_720), "name"))
	var _t146 = J.seq(v_p_720, "street")
	if not J.t(_t146):
		var _t145 = J.F_String([v_p_720])
		_t146 = J.mc(_t145, "startsWith", ["boss:"])
	if J.t(_t146):
		return "陽間站崗中"
	var _t147 = J.F_String([v_p_720])
	if J.t(J.mc(_t147, "startsWith", ["tower"])):
		return "樓裡有鬼出更中"
	return "出外工作中"

func _f241(this_, a: Array, env):
	var v_st_911 = null
	v_st_911 = J.arg(a, 0)
	var _t148 = (not J.t(J.gp(v_st_911, "need")))
	return (_t148 if _t148 else (not (not J.t(J.gp(J.gp(J.G.get("S"), "seen"), J.gp(v_st_911, "need"))))))

func _f242(this_, a: Array, env):
	var v_b_914 = null
	var _t149 = J.G.get("$")
	v_b_914 = J.cl(_t149, null, ["#sndtop"])
	if J.t(v_b_914):
		var _t150 = ("🔊" if J.t(J.mc(J.G.get("Sound"), "isOn", [])) else "🔇")
		J.sp(v_b_914, "textContent", _t150)
		var _t151 = J.gp(v_b_914, "classList")
		J.mc(_t151, "toggle", ["off", (not J.t(J.mc(J.G.get("Sound"), "isOn", [])))])

func _f244(this_, a: Array, env):
	J.del(J.gp(env["btn"], "dataset"), "armed")
	var _t154 = env["btn"]
	var _t155 = env["o"]
	J.sp(_t154, "innerHTML", _t155)

func _f243(this_, a: Array, env):
	var v_msg_918 = null
	var _s509 = {"__p": env, "btn": null, "o": null}
	_s509["btn"] = J.arg(a, 0)
	v_msg_918 = J.arg(a, 1)
	if J.t(J.gp(J.gp(_s509["btn"], "dataset"), "armed")):
		return true
	var _t152 = J.gp(_s509["btn"], "dataset")
	J.sp(_t152, "armed", 1.0)
	_s509["o"] = J.gp(_s509["btn"], "innerHTML")
	var _t153 = _s509["btn"]
	J.sp(_t153, "innerHTML", v_msg_918)
	J.F_setTimeout([Callable(self, "_f244").bind(_s509), 2500.0])
	return false

func _f246(this_, a: Array, env):
	var v_c_923 = null; var v_p_924 = null
	v_c_923 = J.arg(a, 0)
	if J.t(J.gp(J.gp(v_c_923, "dataset"), "done")):
		return null
	var _t157 = J.gp(v_c_923, "dataset")
	J.sp(_t157, "done", 1.0)
	v_p_924 = J.mc(J.G.get("ART"), "portrait", [J.gp(J.gp(v_c_923, "dataset"), "por"), 64.0, {"tamed": true, "untied": true}])
	var _t158 = J.gp(v_p_924, "width")
	J.sp(v_c_923, "width", _t158)
	var _t159 = J.gp(v_p_924, "height")
	J.sp(v_c_923, "height", _t159)
	var _t160 = J.mc(v_c_923, "getContext", ["2d"])
	J.mc(_t160, "drawImage", [v_p_924, 0.0, 0.0])

func _f245(this_, a: Array, env):
	var v_root_922 = null
	v_root_922 = J.arg(a, 0)
	var _t156 = J.mc(v_root_922, "querySelectorAll", ["canvas[data-por]"])
	J.mc(_t156, "forEach", [Callable(self, "_f246").bind(env)])

func _f248(this_, a: Array, env):
	var v_k_936 = null
	v_k_936 = J.arg(a, 0)
	var _t162 = (not J.t(J.gp(J.gp(J.G.get("FODDER"), v_k_936), "unlock")))
	return (_t162 if _t162 else J.gp(J.gp(J.G.get("S"), "cleared"), J.gp(J.gp(J.G.get("FODDER"), v_k_936), "unlock")))

func _f249(this_, a: Array, env):
	return J.round(J.num(J.mul((15.0 + (randf() * 32.0)), env["m"])))

func _f250(this_, a: Array, env):
	var v_g_937 = null
	v_g_937 = J.arg(a, 0)
	return J.gp(v_g_937, "name")

func _f247(this_, a: Array, env):
	var v_rare_927 = null; var v_pool_928 = null; var v_k_929 = null; var v_purple_930 = null; var v_st_932 = null; var v_used_933 = null; var v_name_934 = null; var v_g_935 = null; var v_i_938 = null
	var _s513 = {"__p": env, "m": null}
	v_rare_927 = J.arg(a, 0)
	var _t161 = J.S_Object_("keys", [J.G.get("FODDER")])
	v_pool_928 = J.mc(_t161, "filter", [Callable(self, "_f248").bind(_s513)])
	v_k_929 = J.gp(v_pool_928, floor(J.num((randf() * J.len(v_pool_928)))))
	v_purple_930 = (v_rare_927 if J.t(v_rare_927) else (randf() < 0.15))
	_s513["m"] = (1.45 if J.t(v_purple_930) else 1.0)
	var _t163 = [0.0, 0.0, 0.0]
	v_st_932 = J.mc(_t163, "map", [Callable(self, "_f249").bind(_s513)])
	var _t164 = J.gp(J.G.get("S"), "ghosts")
	v_used_933 = J.new_("Set", [J.mc(_t164, "map", [Callable(self, "_f250").bind(_s513)])])
	v_name_934 = null
	v_i_938 = 0.0
	while true:
		if not J.cmp(v_i_938, 40.0, "<"): break
		var _t165 = J.add(J.add(J.gp(J.gp(J.G.get("FODDER"), v_k_929), "name"), "・"), J.gp(J.G.get("NICKS"), floor(J.num((randf() * J.len(J.G.get("NICKS")))))))
		v_name_934 = _t165
		if (not J.t(J.mc(v_used_933, "has", [v_name_934]))):
			break
		v_i_938 = J.num(v_i_938) + 1.0
	var _t166 = J.G.get("S")
	var _t167 = J.num(J.gp(_t166, "uid"))
	J.sp(_t166, "uid", _t167 + 1.0)
	v_g_935 = {"id": J.add("g", _t167), "k": v_k_929, "name": v_name_934, "q": ("紫" if J.t(v_purple_930) else "藍"), "lv": 1.0, "st": v_st_932, "post": null, "spent": 0.0}
	var _t168 = J.gp(J.G.get("S"), "ghosts")
	J.mc(_t168, "push", [v_g_935])
	return v_g_935

func _f251(this_, a: Array, env):
	var _t169 = (not J.seq(J.typeof_(J.G.get("Scare")), "undefined"))
	var _t171 = (J.gp(J.G.get("Scare"), "active") if _t169 else _t169)
	if not J.t(_t171):
		var _t170 = (not J.seq(J.typeof_(J.G.get("Graveyard")), "undefined"))
		_t171 = (J.gp(J.G.get("Graveyard"), "active") if _t170 else _t170)
	var _t173 = _t171
	if not J.t(_t173):
		var _t172 = (not J.seq(J.typeof_(J.G.get("GhostStreet")), "undefined"))
		_t173 = (J.gp(J.G.get("GhostStreet"), "active") if _t172 else _t172)
	var _t176 = _t173
	if not J.t(_t176):
		var _t174 = (not J.seq(J.typeof_(J.G.get("Sports")), "undefined"))
		var _t175 = (J.gp(J.G.get("Sports"), "_g") if _t174 else _t174)
		_t176 = ((not (not J.t(J.mc(J.G.get("Sports"), "_g", [])))) if J.t(_t175) else _t175)
	return _t176

func _f252(this_, a: Array, env):
	var v_now_943 = null; var v_dt_944 = null
	v_now_943 = J.arg(a, 0)
	J.F_requestAnimationFrame([J.G.get("loop")])
	if J.cmp(J.sub(v_now_943, J.G.get("lastT")), J.G.get("FRAME_MS"), "<"):
		return null
	v_dt_944 = J.min_([0.1, J.div(J.sub(v_now_943, J.G.get("lastT")), 1000.0)])
	J.G["lastT"] = v_now_943
	if (not J.t(J.gp(J.G.get("Battle"), "active"))):
		var _t177 = J.G.get("produce")
		J.cl(_t177, null, [J.mul(v_dt_944, J.G.get("TIME_SCALE"))])
		J.mc(J.G.get("Village"), "update", [v_dt_944])
		if (not J.t(J.cl(J.G.get("covered"), null, []))):
			J.mc(J.G.get("Village"), "draw", [])
	else:
		var _t178 = J.G.get("produce")
		J.cl(_t178, null, [J.mul(v_dt_944, J.G.get("TIME_SCALE"))])
		J.mc(J.G.get("Battle"), "update", [v_dt_944])
		J.mc(J.G.get("Battle"), "draw", [])
	var _t179 = J.add(J.G.get("uiT"), v_dt_944)
	J.G["uiT"] = _t179
	if J.cmp(J.G.get("uiT"), 0.5, ">"):
		J.G["uiT"] = 0.0
		J.mc(J.G.get("UI"), "refresh", [])
		J.mc(J.G.get("Quest"), "check", [])
	var _t180 = J.add(J.G.get("saveT"), v_dt_944)
	J.G["saveT"] = _t180
	if J.cmp(J.G.get("saveT"), 5.0, ">"):
		J.G["saveT"] = 0.0
		J.cl(J.G.get("save"), null, [])

func _f253(this_, a: Array, env):
	var v_sec_947 = null; var v_before_948 = null; var v_lv0_949 = null; var v_e0_950 = null; var v_parts_951 = null; var v_s_952 = null; var v_k_953 = null; var v_d_954 = null
	var _t185 = (8.0 * 3600.0)
	var _t182 = J.S_Date_("now", [])
	var _t181 = J.gp(J.G.get("S"), "last")
	var _t184 = J.S_Date_("now", [])
	var _t183 = J.gp(J.G.get("S"), "last")
	var _t190 = (8.0 * 3600.0)
	var _t187 = J.S_Date_("now", [])
	var _t186 = J.gp(J.G.get("S"), "last")
	var _t189 = J.S_Date_("now", [])
	var _t188 = J.gp(J.G.get("S"), "last")
	v_sec_947 = J.min_([_t190, J.max_([0.0, J.div(J.sub(_t189, (_t188 if J.t(_t188) else J.S_Date_("now", []))), 1000.0)])])
	if J.cmp(v_sec_947, 60.0, "<"):
		return null
	v_before_948 = J.S_Object_("assign", [{}, J.gp(J.G.get("S"), "res")])
	v_lv0_949 = J.gp(J.G.get("S"), "lv")
	v_e0_950 = J.gp(J.G.get("S"), "exp")
	v_s_952 = 0.0
	while true:
		if not J.cmp(v_s_952, v_sec_947, "<"): break
		var _t191 = J.G.get("produce")
		J.cl(_t191, null, [J.min_([60.0, J.sub(v_sec_947, v_s_952)])])
		var _t192 = J.add(v_s_952, 60.0)
		v_s_952 = _t192
	v_parts_951 = []
	for _t193 in J.iter(["wood", "rice", "planks", "buns", "troops", "coins"]):
		v_k_953 = _t193
		v_d_954 = floor(J.num(J.sub(J.gp(J.gp(J.G.get("S"), "res"), v_k_953), J.gp(v_before_948, v_k_953))))
		if J.cmp(v_d_954, 0.0, ">"):
			var _t195 = J.gp(J.G.get("RES_NAMES"), v_k_953)
			var _t194 = J.G.get("fmt")
			J.mc(v_parts_951, "push", [(J.str(_t195) + " +" + J.str(J.cl(_t194, null, [v_d_954])))])
	var _t196 = J.G.get("S")
	var _t197 = J.S_Date_("now", [])
	J.sp(_t196, "last", _t197)
	if J.t(J.len(v_parts_951)):
		J.mc(J.G.get("Story"), "queue", [{"style": "sys", "lines": [["系統", ("親，你離開了 " + J.str(floor(J.num(J.div(v_sec_947, 3600.0)))) + " 小時 " + J.str(floor(J.num(J.div(J.mod(v_sec_947, 3600.0), 60.0)))) + " 分鐘。鬼怪們沒有偷懶哦～（最多計 8 小時）")], ["旁白", J.add("離線收益：", J.mc(v_parts_951, "join", ["，"]))]]}])

func _f256(this_, a: Array, env):
	return J.mc(J.G.get("Web"), "init", [])

func _f255(this_, a: Array, env):
	var _t198 = (J.G.get("SPR_READY") if (not J.seq(J.typeof_(J.G.get("SPR_READY")), "undefined")) else J.S_Promise_("resolve", []))
	var _t199 = J.mc(_t198, "then", [J.G.get("startGame"), J.G.get("startGame")])
	return J.mc(_t199, "then", [Callable(self, "_f256").bind(env)])

func _f254(this_, a: Array, env):
	return null
	if J.t(J.mc(J.G.get("Web"), "boot", [])):
		return null
	J.mc(J.G.get("Web"), "receive", [Callable(self, "_f255").bind(env)])

func _f259(this_, a: Array, env):
	J.mc(J.G.get("Sound"), "play", ["click"])
	var _t207 = J.seq(J.gp(J.gp(env["b"], "dataset"), "t"), "battle")
	if ((not J.seq(J.typeof_(J.G.get("World")), "undefined")) if _t207 else _t207):
		J.mc(J.G.get("UI"), "close", [])
		J.mc(J.G.get("World"), "open", [])
		return null
	J.mc(J.G.get("UI"), "open", [J.gp(J.gp(env["b"], "dataset"), "t")])

func _f258(this_, a: Array, env):
	var _s534 = {"__p": env, "b": null}
	_s534["b"] = J.arg(a, 0)
	var _t206 = _s534["b"]
	var _t208 = Callable(self, "_f259").bind(_s534)
	J.sp(_t206, "onclick", _t208)
	return _t208

func _f260(this_, a: Array, env):
	J.mc(J.G.get("Sound"), "toggle", [])
	J.cl(J.G.get("syncSnd"), null, [])

func _f261(this_, a: Array, env):
	return J.mc(J.G.get("UI"), "close", [])

func _f263(this_, a: Array, env):
	var _t218 = J.gp(env["__p"]["RES_HELP"], J.gp(env["el"], "title"))
	var _t217 = J.seq(J.gp(env["el"], "title"), "陰兵")
	return J.mc(J.G.get("Fx"), "toast", [J.add(_t218, ("<br>（建好民宅，遊魂才會來）" if ((not J.t(J.gp(J.gp(J.G.get("S"), "bld"), "home"))) if _t217 else _t217) else ""))])

func _f262(this_, a: Array, env):
	var _s539 = {"__p": env, "el": null}
	_s539["el"] = J.arg(a, 0)
	var _t216 = _s539["el"]
	var _t219 = Callable(self, "_f263").bind(_s539)
	J.sp(_t216, "onclick", _t219)
	return _t219

func _f264(this_, a: Array, env):
	var v_p_965 = null; var v_q_966 = null
	v_p_965 = J.mc(J.G.get("Village"), "questTarget", [])
	v_q_966 = J.mc(J.G.get("Quest"), "cur", [])
	if J.t((J.seq(J.gp(v_q_966, "go"), "roster") if J.t(v_q_966) else v_q_966)):
		J.mc(J.G.get("UI"), "open", ["roster"])
		return null
	var _t222 = (J.seq(J.gp(v_q_966, "go"), "gate") if J.t(v_q_966) else v_q_966)
	if J.t((J.seq(J.gp(J.mc(J.G.get("Quest"), "cur", []), "t"), "stage") if J.t(_t222) else _t222)):
		J.mc(J.G.get("UI"), "open", ["battle"])
		return null
	if J.t(v_p_965):
		J.mc(J.G.get("UI"), "close", [])
		J.mc(J.G.get("Village"), "focus", [J.gp(v_p_965, 0.0), J.gp(v_p_965, 1.0)])

func _f265(this_, a: Array, env):
	if J.t(J.gp(J.G.get("document"), "hidden")):
		J.cl(J.G.get("save"), null, [])
	else:
		if J.t(((not J.t(J.gp(J.G.get("Phone"), "on"))) if J.t(J.G.get("S")) else J.G.get("S"))):
			J.cl(J.G.get("offlineGain"), null, [])

func _f266(this_, a: Array, env):
	return J.G.get("S")

func _f267(this_, a: Array, env):
	var v_k_967 = null
	v_k_967 = J.arg(a, 0)
	J.G["TIME_SCALE"] = v_k_967
	return J.G.get("TIME_SCALE")

func _f257(this_, a: Array, env):
	var v_fresh_959 = null; var v_d_960 = null; var v_k_962 = null
	var _s532 = {"__p": env, "RES_HELP": null}
	var _t200 = J.cl(J.G.get("load"), null, [])
	J.G["S"] = _t200
	v_fresh_959 = (not J.t(J.G.get("S")))
	if (not J.t(J.G.get("S"))):
		var _t201 = J.cl(J.G.get("newState"), null, [])
		J.G["S"] = _t201
	v_d_960 = J.cl(J.G.get("newState"), null, [])
	for _t202 in J.keys(v_d_960):
		v_k_962 = _t202
		if J.seq(J.gp(J.G.get("S"), v_k_962), null):
			var _t203 = J.G.get("S")
			var _t204 = J.gp(v_d_960, v_k_962)
			J.sp(_t203, v_k_962, _t204)
	if (not J.seq(J.typeof_(J.G.get("Guide")), "undefined")):
		J.mc(J.G.get("Guide"), "migrate", [v_fresh_959])
	J.mc(J.G.get("Village"), "init", [])
	J.mc(J.G.get("Battle"), "init", [])
	var _t205 = J.S_document_("querySelectorAll", ["#nav button"])
	J.mc(_t205, "forEach", [Callable(self, "_f258").bind(_s532)])
	var _t209 = J.G.get("$")
	var _t210 = J.cl(_t209, null, ["#sndtop"])
	var _t211 = Callable(self, "_f260").bind(_s532)
	J.sp(_t210, "onclick", _t211)
	J.cl(J.G.get("syncSnd"), null, [])
	var _t212 = J.G.get("$")
	var _t213 = J.cl(_t212, null, ["#sheet .sh-close"])
	var _t214 = Callable(self, "_f261").bind(_s532)
	J.sp(_t213, "onclick", _t214)
	_s532["RES_HELP"] = {"槐木": "槐木：主公親手砍樹，或派鬼怪去<b>伐木場</b>伐木。", "糯米": "糯米：主公親手收割，或派鬼怪去<b>糯米田</b>割稻。", "棺材板": "棺材板：在<b>棺材鋪</b>把 2 槐木做成 1 板（力量高的鬼做得快）。藍箱也會開出。用來建造和升級建築。", "壽包": "壽包：在<b>包子鋪</b>把 2 糯米包成 1 個（智力高的鬼包得快）。綠箱也會開出。用來升級鬼怪、練陰兵。", "冥幣": "冥幣：打關卡、開紫箱、燒<b>化寶爐</b>。Toyol 管倉庫時也會「撿到」冥幣。", "陰兵": "陰兵：村裡的遊魂見你有地盤，自願加入。<b>民宅</b>越高級來得越快、上限越高。搶地盤時每 25 個組成一隊（最多 8 隊），戰死的會扣掉。"}
	var _t215 = J.S_document_("querySelectorAll", ["#resbox .rs"])
	J.mc(_t215, "forEach", [Callable(self, "_f262").bind(_s532)])
	var _t220 = J.G.get("$")
	var _t221 = J.cl(_t220, null, ["#quest"])
	var _t223 = Callable(self, "_f264").bind(_s532)
	J.sp(_t221, "onclick", _t223)
	if (not J.t((J.mc(J.re("nophone", ""), "test", [J.gp(J.G.get("location"), "search")]) if J.t(J.G.get("DEBUG")) else J.G.get("DEBUG")))):
		J.mc(J.G.get("Title"), "show", [v_fresh_959])
	J.mc(J.G.get("UI"), "refresh", [])
	J.F_requestAnimationFrame([J.G.get("loop")])
	J.S_window_("addEventListener", ["beforeunload", J.G.get("save")])
	J.S_document_("addEventListener", ["visibilitychange", Callable(self, "_f265").bind(_s532)])
	if J.t(J.G.get("DEBUG")):
		var _t224 = J.G.get("window")
		var _t225 = {"JossFx": J.G.get("JossFx"), "Phone": J.G.get("Phone"), "Sound": J.G.get("Sound"), "S": Callable(self, "_f266").bind(_s532), "F": J.G.get("F"), "Quest": J.G.get("Quest"), "Village": J.G.get("Village"), "Battle": J.G.get("Battle"), "Story": J.G.get("Story"), "UI": J.G.get("UI"), "give": J.G.get("give"), "setScale": Callable(self, "_f267").bind(_s532), "produce": J.G.get("produce"), "joinGhost": J.G.get("joinGhost"), "recruitFodder": J.G.get("recruitFodder"), "ratesPerMin": J.G.get("ratesPerMin"), "save": J.G.get("save")}
		J.sp(_t224, "G", _t225)

func _f1(this_, a: Array, env):
	var v_q_60 = null
	v_q_60 = J.arg(a, 0)
	return J.S_document_("querySelector", [v_q_60])

func _f2(this_, a: Array, env):
	var v_n_61 = null
	v_n_61 = J.arg(a, 0)
	var _t226 = floor(J.num(v_n_61))
	v_n_61 = _t226
	if J.cmp(v_n_61, 1000000.0, ">="):
		var _t227 = J.div(v_n_61, 1000000.0)
		return J.add(J.mc(_t227, "toFixed", [1.0]), "M")
	if J.cmp(v_n_61, 10000.0, ">="):
		var _t228 = J.div(v_n_61, 1000.0)
		return J.add(J.mc(_t228, "toFixed", [1.0]), "K")
	return J.add("", v_n_61)

func _f6(this_, a: Array, env):
	var v_lv_74 = null
	v_lv_74 = J.arg(a, 0)
	return J.round(J.num((30.0 * pow(J.num(v_lv_74), J.num(1.75)))))

func _f7(this_, a: Array, env):
	return (40.0 if J.cmp(J.gp(J.G.get("S"), "lv"), 15.0, ">=") else (30.0 if J.cmp(J.gp(J.G.get("S"), "lv"), 7.0, ">=") else 20.0))

func _f8(this_, a: Array, env):
	var v_g_75 = null; var v_i_76 = null
	v_g_75 = J.arg(a, 0)
	v_i_76 = J.arg(a, 1)
	return J.round(J.num(J.mul(J.gp(J.gp(v_g_75, "st"), v_i_76), (1.0 + (0.06 * J.sub(J.mc(J.G.get("F"), "glv", [v_g_75]), 1.0))))))

func _f9(this_, a: Array, env):
	var v_g_77 = null
	v_g_77 = J.arg(a, 0)
	return (J.min_([J.mc(J.G.get("F"), "ghostCap", []), J.mul(J.gp(J.G.get("S"), "lv"), 2.0)]) if J.seq(J.gp(v_g_77, "k"), "afu") else J.gp(v_g_77, "lv"))

func _f10(this_, a: Array, env):
	var v_lv_78 = null
	v_lv_78 = J.arg(a, 0)
	return (floor(J.num((6.0 * pow(J.num(v_lv_78), J.num(1.5))))) + 4.0)

func _f11(this_, a: Array, env):
	var v_id_79 = null
	v_id_79 = J.arg(a, 0)
	return (20.0 if J.seq(v_id_79, "house") else J.gp(J.gp(J.G.get("S"), "bld"), "house"))

func _f12(this_, a: Array, env):
	var v_id_80 = null; var v_lv_81 = null; var v_k_82 = null; var v_planks_83 = null; var v_coins_84 = null
	v_id_80 = J.arg(a, 0)
	v_lv_81 = J.arg(a, 1)
	v_k_82 = (1.1 if J.seq(v_id_80, "house") else 0.9)
	v_planks_83 = J.round(J.num(J.mul((25.0 * pow(J.num(v_lv_81), J.num(1.72))), v_k_82)))
	v_coins_84 = J.round(J.num(J.mul((28.0 * pow(J.num(v_lv_81), J.num(1.8))), v_k_82)))
	var _t229 = J.round(J.num(J.mul(v_planks_83, J.sub(1.0, J.mc(J.G.get("F"), "builderDiscount", [])))))
	v_planks_83 = _t229
	return {"planks": v_planks_83, "coins": v_coins_84}

func _f13(this_, a: Array, env):
	var v_g_85 = null
	var _t230 = J.G.get("workersAt")
	v_g_85 = J.gp(J.cl(_t230, null, ["boss"]), 0.0)
	return (J.min_([0.35, J.mul(J.mc(J.G.get("F"), "glv", [v_g_85]), 0.012)]) if J.t(v_g_85) else 0.0)

func _f14(this_, a: Array, env):
	var v_post_86 = null; var v_p_87 = null; var v_lv_88 = null
	v_post_86 = J.arg(a, 0)
	v_p_87 = J.gp(J.G.get("POSTS"), v_post_86)
	v_lv_88 = J.gp(J.gp(J.G.get("S"), "bld"), J.gp(v_p_87, "bld"))
	if (not J.t(v_lv_88)):
		return 0.0
	if J.seq(v_post_86, "boss"):
		return 1.0
	return J.min_([4.0, (1.0 + floor(J.num(J.div(J.sub(v_lv_88, 1.0), 3.0))))])

func _f15(this_, a: Array, env):
	var v_bid_89 = null
	v_bid_89 = J.arg(a, 0)
	return (1.0 + (0.3 * J.sub(J.gp(J.gp(J.G.get("S"), "bld"), v_bid_89), 1.0)))

func _f16(this_, a: Array, env):
	var v_c_90 = null; var v_m_91 = null
	v_c_90 = ((400.0 + ((400.0 * pow(J.num(J.gp(J.gp(J.G.get("S"), "bld"), "store")), J.num(1.5))) if J.t(J.gp(J.gp(J.G.get("S"), "bld"), "store")) else 0.0)) + (600.0 if J.cmp(J.gp(J.G.get("S"), "lv"), 9.0, ">=") else 0.0))
	var _t231 = J.G.get("workersAt")
	v_m_91 = J.gp(J.cl(_t231, null, ["store"]), 0.0)
	if J.t(v_m_91):
		var _t232 = J.mul(v_c_90, (1.0 + J.div(J.mc(J.G.get("F"), "stat", [v_m_91, 2.0]), 100.0)))
		v_c_90 = _t232
	return J.round(J.num(v_c_90))

func _f17(this_, a: Array, env):
	return ((150.0 + J.mul(150.0, J.gp(J.gp(J.G.get("S"), "bld"), "home"))) + J.mul(50.0, J.gp(J.gp(J.G.get("S"), "bld"), "camp")))

func _f18(this_, a: Array, env):
	return (5.0 + J.mul(2.0, J.gp(J.gp(J.G.get("S"), "bld"), "home")))

func _f19(this_, a: Array, env):
	return J.mul((150.0 if J.cmp(J.gp(J.G.get("S"), "lv"), 5.0, ">=") else 95.0), (J.mc(J.G.get("GhostStreet"), "mul", ["walk"]) if (not J.seq(J.typeof_(J.G.get("GhostStreet")), "undefined")) else 1.0))

func _f20(this_, a: Array, env):
	return (0.42 if J.cmp(J.gp(J.G.get("S"), "lv"), 2.0, ">=") else 0.7)

func _f21(this_, a: Array, env):
	return ((30.0 + J.mul(15.0, J.gp(J.gp(J.G.get("S"), "bld"), "furnace"))) + J.mul(6.0, J.gp(J.G.get("S"), "lv")))

func _f22(this_, a: Array, env):
	var v_c_92 = null
	v_c_92 = J.arg(a, 0)
	return ({"buns": (40.0 + J.mul(30.0, J.gp(J.gp(J.G.get("S"), "bld"), "bun")))} if J.seq(v_c_92, "g") else ({"planks": (30.0 + J.mul(25.0, J.gp(J.gp(J.G.get("S"), "bld"), "plank")))} if J.seq(v_c_92, "b") else {"coins": (120.0 + J.mul(60.0, J.gp(J.gp(J.G.get("S"), "bld"), "house")))}))

func _f23(this_, a: Array, env):
	return {"coins": 150.0, "buns": 40.0}

func _f44(this_, a: Array, env):
	return J.gp(J.G.get("QUESTS"), J.gp(J.G.get("S"), "qi"))

func _f46(this_, a: Array, env):
	var v_g_171 = null
	v_g_171 = J.arg(a, 0)
	return J.gp(v_g_171, "post")

func _f47(this_, a: Array, env):
	var v_g_172 = null
	v_g_172 = J.arg(a, 0)
	return (not J.seq(J.gp(v_g_172, "k"), "afu"))

func _f48(this_, a: Array, env):
	var v_g_173 = null
	v_g_173 = J.arg(a, 0)
	return J.gp(v_g_173, "lv")

func _f45(this_, a: Array, env):
	var v_q_170 = null; var v_m_174 = null
	v_q_170 = J.arg(a, 0)
	var _t233 = J.gp(v_q_170, "t")
	var _t234 = -1
	var _t235 = false
	if _t234 == -1 and J.seq(_t233, "chop"): _t234 = 0
	if _t234 == -1 and J.seq(_t233, "rice"): _t234 = 1
	if _t234 == -1 and J.seq(_t233, "craftPlank"): _t234 = 2
	if _t234 == -1 and J.seq(_t233, "craftBun"): _t234 = 3
	if _t234 == -1 and J.seq(_t233, "level"): _t234 = 4
	if _t234 == -1 and J.seq(_t233, "build"): _t234 = 5
	if _t234 == -1 and J.seq(_t233, "bLevel"): _t234 = 6
	if _t234 == -1 and J.seq(_t233, "assign"): _t234 = 7
	if _t234 == -1 and J.seq(_t233, "stage"): _t234 = 8
	if _t234 == -1 and J.seq(_t233, "recruit"): _t234 = 9
	if _t234 == -1 and J.seq(_t233, "ghostLv"): _t234 = 10
	if _t234 == -1 and J.seq(_t233, "troops"): _t234 = 11
	if _t234 == -1 and J.seq(_t233, "drill"): _t234 = 12
	if _t234 == -1 and J.seq(_t233, "feast"): _t234 = 13
	if _t234 == -1 and J.seq(_t233, "visit"): _t234 = 14
	while true:
		if _t234 <= 0 and _t234 >= 0:
			return [J.gp(J.gp(J.G.get("S"), "cnt"), "chop"), J.gp(v_q_170, "n")]
		if _t234 <= 1 and _t234 >= 0:
			return [J.gp(J.gp(J.G.get("S"), "cnt"), "rice"), J.gp(v_q_170, "n")]
		if _t234 <= 2 and _t234 >= 0:
			return [J.gp(J.gp(J.G.get("S"), "cnt"), "craftPlank"), J.gp(v_q_170, "n")]
		if _t234 <= 3 and _t234 >= 0:
			return [J.gp(J.gp(J.G.get("S"), "cnt"), "craftBun"), J.gp(v_q_170, "n")]
		if _t234 <= 4 and _t234 >= 0:
			return [J.gp(J.G.get("S"), "lv"), J.gp(v_q_170, "n")]
		if _t234 <= 5 and _t234 >= 0:
			return [(1.0 if J.t(J.gp(J.gp(J.G.get("S"), "bld"), J.gp(v_q_170, "b"))) else 0.0), 1.0]
		if _t234 <= 6 and _t234 >= 0:
			return [J.gp(J.gp(J.G.get("S"), "bld"), J.gp(v_q_170, "b")), J.gp(v_q_170, "n")]
		if _t234 <= 7 and _t234 >= 0:
			var _t236 = J.gp(J.G.get("S"), "ghosts")
			return [J.len(J.mc(_t236, "filter", [Callable(self, "_f46").bind(env)])), J.gp(v_q_170, "n")]
		if _t234 <= 8 and _t234 >= 0:
			return [(1.0 if J.t(J.gp(J.gp(J.G.get("S"), "cleared"), J.gp(v_q_170, "s"))) else 0.0), 1.0]
		if _t234 <= 9 and _t234 >= 0:
			return [J.gp(J.gp(J.G.get("S"), "cnt"), "recruit"), J.gp(v_q_170, "n")]
		if _t234 <= 10 and _t234 >= 0:
			var _t237 = J.gp(J.G.get("S"), "ghosts")
			var _t238 = J.mc(_t237, "filter", [Callable(self, "_f47").bind(env)])
			return [J.max_(J.spread([J.SP(J.mc(_t238, "map", [Callable(self, "_f48").bind(env)])), 0.0])), J.gp(v_q_170, "n")]
		if _t234 <= 11 and _t234 >= 0:
			return [floor(J.num(J.gp(J.gp(J.G.get("S"), "res"), "troops"))), J.gp(v_q_170, "n")]
		if _t234 <= 12 and _t234 >= 0:
			var _t239 = J.gp(J.G.get("S"), "drill")
			var _t240 = J.S_Object_("values", [(_t239 if J.t(_t239) else {})])
			v_m_174 = J.max_(J.spread([0.0, J.SP(J.mc(_t240, "concat", [[0.0]]))]))
			return [floor(J.num(J.min_([v_m_174, J.gp(v_q_170, "n")]))), J.gp(v_q_170, "n")]
		if _t234 <= 13 and _t234 >= 0:
			return [J.gp(J.gp(J.G.get("S"), "cnt"), "feast"), J.gp(v_q_170, "n")]
		if _t234 <= 14 and _t234 >= 0:
			var _t241 = J.gp(J.G.get("S"), "visit")
			return [(1.0 if J.t((J.gp(J.gp(J.G.get("S"), "visit"), J.gp(v_q_170, "place")) if J.t(_t241) else _t241)) else 0.0), 1.0]
		break
	return [0.0, 1.0]

func _f49(this_, a: Array, env):
	var v_q_177 = null; var v_a_178 = null; var v_b_179 = null
	v_q_177 = J.arg(a, 0)
	var _t242 = J.mc(this_, "progress", [v_q_177])
	var _t243 = J.gp(_t242, 0.0)
	v_a_178 = _t243
	var _t244 = J.gp(_t242, 1.0)
	v_b_179 = _t244
	return J.cmp(v_a_178, v_b_179, ">=")

func _f51(this_, a: Array, env):
	var _t250 = J.G.get("joinGhost")
	return J.cl(_t250, null, ["tianhua"])

func _f50(this_, a: Array, env):
	var v_q_182 = null
	v_q_182 = J.mc(this_, "cur", [])
	if (not J.t(v_q_182)):
		return null
	var _t245 = J.mc(this_, "done", [v_q_182])
	if J.t(((not J.t(J.mc(J.G.get("Story"), "busy", []))) if J.t(_t245) else _t245)):
		J.mc(this_, "complete", [])
	var _t246 = J.gp(J.gp(J.G.get("S"), "seen"), "ch2_end")
	var _t247 = (J.cmp(J.gp(J.gp(J.G.get("S"), "bld"), "house"), 4.0, ">=") if J.t(_t246) else _t246)
	var _t248 = ((not J.t(J.gp(J.gp(J.G.get("S"), "seen"), "side_tianhua"))) if J.t(_t247) else _t247)
	var _t249 = ((not J.t(J.mc(J.G.get("Story"), "busy", []))) if J.t(_t248) else _t248)
	if J.t(((not J.t(J.gp(J.G.get("Battle"), "active"))) if J.t(_t249) else _t249)):
		J.mc(J.G.get("Story"), "queue", ["side_tianhua", Callable(self, "_f51").bind(env)])

func _f53(this_, a: Array, env):
	var v_id_188 = null
	v_id_188 = J.arg(a, 0)
	if (not J.t(J.gp(J.gp(J.G.get("S"), "seen"), v_id_188))):
		J.mc(J.G.get("Story"), "queue", [v_id_188])

func _f52(this_, a: Array, env):
	var v_q_185 = null; var v_txt_186 = null; var v_nq_187 = null
	v_q_185 = J.mc(this_, "cur", [])
	var _t251 = J.G.get("S")
	J.sp(_t251, "qi", J.num(J.gp(_t251, "qi")) + 1.0)
	var _t252 = J.G.get("give")
	v_txt_186 = J.cl(_t252, null, [J.gp(v_q_185, "r")])
	J.mc(J.G.get("Sound"), "play", ["coin"])
	J.mc(J.G.get("Fx"), "toast", [(("任務完成：" + J.str(J.gp(v_q_185, "text")) + "<br><b>" + J.str(v_txt_186) + "</b>") + (("<br>" + J.str(J.gp(v_q_185, "note"))) if J.t(J.gp(v_q_185, "note")) else ""))])
	v_nq_187 = J.mc(this_, "cur", [])
	if J.t((J.gp(v_nq_187, "onStart") if J.t(v_nq_187) else v_nq_187)):
		var _t253 = J.gp(v_nq_187, "onStart")
		J.mc(_t253, "forEach", [Callable(self, "_f53").bind(env)])
	J.cl(J.G.get("save"), null, [])
	J.mc(J.G.get("UI"), "refresh", [])

func _f55(this_, a: Array, env):
	return J.mc(env["this"], "resize", [])

func _f56(this_, a: Array, env):
	var v_e_195 = null; var v_p_196 = null
	v_e_195 = J.arg(a, 0)
	v_p_196 = J.mc(env["this"], "pt", [v_e_195])
	var _t260 = env["this"]
	var _t261 = {"y0": J.gp(v_p_196, "cy"), "cam": J.gp(env["this"], "camY"), "moved": false, "x": J.gp(v_p_196, "cx"), "y": J.gp(v_p_196, "cy")}
	J.sp(_t260, "drag", _t261)

func _f57(this_, a: Array, env):
	var v_e_197 = null; var v_p_198 = null; var v_dy_199 = null
	v_e_197 = J.arg(a, 0)
	if (not J.t(J.gp(env["this"], "drag"))):
		return null
	v_p_198 = J.mc(env["this"], "pt", [v_e_197])
	v_dy_199 = J.sub(J.gp(v_p_198, "cy"), J.gp(J.gp(env["this"], "drag"), "y0"))
	if (absf(J.num(v_dy_199)) > 8.0):
		var _t262 = J.gp(env["this"], "drag")
		J.sp(_t262, "moved", true)
	if J.t(J.gp(J.gp(env["this"], "drag"), "moved")):
		J.mc(env["this"], "setCam", [J.sub(J.gp(J.gp(env["this"], "drag"), "cam"), v_dy_199)])
	J.mc(v_e_197, "preventDefault", [])

func _f58(this_, a: Array, env):
	var v_e_200 = null; var v_d_201 = null
	v_e_200 = J.arg(a, 0)
	if (not J.t(J.gp(env["this"], "drag"))):
		return null
	v_d_201 = J.gp(env["this"], "drag")
	var _t263 = env["this"]
	J.sp(_t263, "drag", null)
	if (not J.t(J.gp(v_d_201, "moved"))):
		J.mc(env["this"], "tap", [J.gp(v_d_201, "x"), J.add(J.gp(v_d_201, "y"), J.gp(env["this"], "camY"))])

func _f59(this_, a: Array, env):
	var v_e_202 = null
	v_e_202 = J.arg(a, 0)
	J.mc(env["this"], "setCam", [J.add(J.gp(env["this"], "camY"), J.mul(J.gp(v_e_202, "deltaY"), 0.6))])
	J.mc(v_e_202, "preventDefault", [])

func _f54(this_, a: Array, env):
	var v_c_191 = null; var v_down_192 = null; var v_move_193 = null; var v_up_194 = null
	var _s89 = {"__p": env, "this": null}
	_s89["this"] = this_
	var _t254 = _s89["this"]
	var _t255 = J.G.get("$")
	var _t256 = J.cl(_t255, null, ["#village"])
	J.sp(_t254, "cvs", _t256)
	var _t257 = _s89["this"]
	var _t258 = J.gp(_s89["this"], "cvs")
	var _t259 = J.mc(_t258, "getContext", ["2d"])
	J.sp(_t257, "ctx", _t259)
	J.mc(_s89["this"], "resize", [])
	J.S_window_("addEventListener", ["resize", Callable(self, "_f55").bind(_s89)])
	v_c_191 = J.gp(_s89["this"], "cvs")
	v_down_192 = Callable(self, "_f56").bind(_s89)
	v_move_193 = Callable(self, "_f57").bind(_s89)
	v_up_194 = Callable(self, "_f58").bind(_s89)
	J.mc(v_c_191, "addEventListener", ["pointerdown", v_down_192])
	J.mc(v_c_191, "addEventListener", ["pointermove", v_move_193, {"passive": false}])
	J.S_window_("addEventListener", ["pointerup", v_up_194])
	J.mc(v_c_191, "addEventListener", ["wheel", Callable(self, "_f59").bind(_s89), {"passive": false}])
	var _t264 = _s89["this"]
	J.sp(_t264, "camY", 180.0)

func _f60(this_, a: Array, env):
	var v_r_205 = null
	v_r_205 = J.mc(J.gp(this_, "cvs"), "getBoundingClientRect", [])
	var _t265 = this_
	var _t266 = J.gp(J.G.get("window"), "devicePixelRatio")
	var _t267 = J.gp(J.G.get("window"), "devicePixelRatio")
	var _t268 = J.min_([2.0, (_t267 if J.t(_t267) else 1.0)])
	J.sp(_t265, "dpr", _t268)
	var _t269 = this_
	var _t270 = J.gp(v_r_205, "width")
	J.sp(_t269, "w", _t270)
	var _t271 = this_
	var _t272 = J.gp(v_r_205, "height")
	J.sp(_t271, "h", _t272)
	var _t273 = J.gp(this_, "cvs")
	var _t274 = J.mul(J.gp(v_r_205, "width"), J.gp(this_, "dpr"))
	J.sp(_t273, "width", _t274)
	var _t275 = J.gp(this_, "cvs")
	var _t276 = J.mul(J.gp(v_r_205, "height"), J.gp(this_, "dpr"))
	J.sp(_t275, "height", _t276)
	var _t277 = this_
	var _t278 = J.div(J.gp(this_, "w"), J.G.get("W"))
	J.sp(_t277, "scale", _t278)
	J.mc(this_, "setCam", [J.gp(this_, "camY")])

func _f61(this_, a: Array, env):
	var v_y_208 = null; var v_vh_209 = null
	v_y_208 = J.arg(a, 0)
	v_vh_209 = J.div(J.gp(this_, "h"), J.gp(this_, "scale"))
	var _t279 = this_
	var _t280 = J.max_([0.0, J.min_([J.sub(J.G.get("WH"), v_vh_209), v_y_208])])
	J.sp(_t279, "camY", _t280)

func _f62(this_, a: Array, env):
	var v_e_212 = null; var v_r_213 = null
	v_e_212 = J.arg(a, 0)
	v_r_213 = J.mc(J.gp(this_, "cvs"), "getBoundingClientRect", [])
	return {"cx": J.div(J.sub(J.gp(v_e_212, "clientX"), J.gp(v_r_213, "left")), J.gp(this_, "scale")), "cy": J.div(J.sub(J.gp(v_e_212, "clientY"), J.gp(v_r_213, "top")), J.gp(this_, "scale"))}

func _f63(this_, a: Array, env):
	var v_x_216 = null; var v_y_217 = null
	v_x_216 = J.arg(a, 0)
	v_y_217 = J.arg(a, 1)
	J.mc(this_, "setCam", [J.sub(v_y_217, J.div(J.div(J.gp(this_, "h"), J.gp(this_, "scale")), 2.0))])

func _f64(this_, a: Array, env):
	var v_x_220 = null; var v_y_221 = null; var v_i_222 = null; var v_tx_223 = null; var v_ty_224 = null; var v_i_225 = null; var v_px_226 = null; var v_py_227 = null; var v_id_228 = null; var v_bx_229 = null; var v_by_230 = null; var v_w_231 = null; var v_h_232 = null
	v_x_220 = J.arg(a, 0)
	v_y_221 = J.arg(a, 1)
	v_i_222 = 0.0
	while true:
		if not J.cmp(v_i_222, J.len(J.G.get("TREE_POS")), "<"): break
		var _t281 = J.gp(J.G.get("TREE_POS"), v_i_222)
		var _t282 = J.gp(_t281, 0.0)
		v_tx_223 = _t282
		var _t283 = J.gp(_t281, 1.0)
		v_ty_224 = _t283
		var _t284 = (absf(J.num(J.sub(v_x_220, v_tx_223))) < 24.0)
		var _t285 = (J.cmp(v_y_221, J.sub(v_ty_224, 72.0), ">") if _t284 else _t284)
		if (J.cmp(v_y_221, J.add(v_ty_224, 8.0), "<") if _t285 else _t285):
			return {"kind": "tree", "i": v_i_222}
		v_i_222 = J.num(v_i_222) + 1.0
	v_i_225 = 0.0
	while true:
		if not J.cmp(v_i_225, J.len(J.G.get("PADDY_POS")), "<"): break
		var _t286 = J.gp(J.G.get("PADDY_POS"), v_i_225)
		var _t287 = J.gp(_t286, 0.0)
		v_px_226 = _t287
		var _t288 = J.gp(_t286, 1.0)
		v_py_227 = _t288
		var _t289 = (absf(J.num(J.sub(v_x_220, v_px_226))) < 26.0)
		if ((absf(J.num((J.sub(v_y_221, v_py_227) + 4.0))) < 16.0) if _t289 else _t289):
			return {"kind": "paddy", "i": v_i_225}
		v_i_225 = J.num(v_i_225) + 1.0
	for _t290 in J.iter(J.S_Object_("keys", [J.G.get("POS")])):
		v_id_228 = _t290
		var _t291 = J.gp(J.G.get("POS"), v_id_228)
		var _t292 = J.gp(_t291, 0.0)
		v_bx_229 = _t292
		var _t293 = J.gp(_t291, 1.0)
		v_by_230 = _t293
		v_w_231 = (70.0 if J.seq(v_id_228, "house") else (65.0 if J.seq(v_id_228, "gate") else (26.0 if J.seq(v_id_228, "furnace") else 46.0)))
		v_h_232 = (115.0 if J.seq(v_id_228, "house") else (92.0 if J.seq(v_id_228, "gate") else 70.0))
		var _t294 = J.cmp(absf(J.num(J.sub(v_x_220, v_bx_229))), v_w_231, "<")
		var _t295 = (J.cmp(v_y_221, J.sub(v_by_230, v_h_232), ">") if _t294 else _t294)
		if (J.cmp(v_y_221, J.add(v_by_230, 10.0), "<") if _t295 else _t295):
			return {"kind": ("gate" if J.seq(v_id_228, "gate") else "bld"), "id": v_id_228}
	return null

func _f65(this_, a: Array, env):
	var v_x_235 = null; var v_y_236 = null; var v_h_237 = null
	v_x_235 = J.arg(a, 0)
	v_y_236 = J.arg(a, 1)
	var _t296 = J.mc(J.G.get("Story"), "busy", [])
	if J.t((_t296 if J.t(_t296) else J.mc(J.G.get("UI"), "modalOpen", []))):
		return null
	var _t297 = (not J.seq(J.typeof_(J.G.get("HeroDaily")), "undefined"))
	if J.t((J.mc(J.G.get("HeroDaily"), "tap", [this_, v_x_235, v_y_236]) if _t297 else _t297)):
		return null
	v_h_237 = J.mc(this_, "hitTest", [v_x_235, v_y_236])
	if (not J.t(v_h_237)):
		J.mc(this_, "walkTo", [v_x_235, v_y_236, null])
		return null
	if J.seq(J.gp(v_h_237, "kind"), "tree"):
		if J.cmp(J.gp(J.gp(J.G.get("S"), "trees"), J.gp(v_h_237, "i")), 0.0, ">"):
			J.mc(this_, "walkTo", [J.add(J.gp(J.gp(J.G.get("TREE_POS"), J.gp(v_h_237, "i")), 0.0), 20.0), J.add(J.gp(J.gp(J.G.get("TREE_POS"), J.gp(v_h_237, "i")), 1.0), 4.0), {"kind": "tree", "i": J.gp(v_h_237, "i")}])
		else:
			J.mc(J.G.get("Fx"), "float", [v_x_235, J.sub(v_y_236, 30.0), "樹樁還在長…", "#ccc"])
		return null
	if J.seq(J.gp(v_h_237, "kind"), "paddy"):
		if J.t(J.gp(J.gp(J.G.get("S"), "paddy"), J.gp(v_h_237, "i"))):
			J.mc(this_, "walkTo", [J.sub(J.gp(J.gp(J.G.get("PADDY_POS"), J.gp(v_h_237, "i")), 0.0), 30.0), J.add(J.gp(J.gp(J.G.get("PADDY_POS"), J.gp(v_h_237, "i")), 1.0), 4.0), {"kind": "paddy", "i": J.gp(v_h_237, "i")}])
		else:
			J.mc(J.G.get("Fx"), "float", [v_x_235, J.sub(v_y_236, 20.0), "稻子還沒熟", "#ccc"])
		return null
	if J.seq(J.gp(v_h_237, "kind"), "gate"):
		if (not J.seq(J.typeof_(J.G.get("World")), "undefined")):
			J.mc(J.G.get("World"), "open", [])
		else:
			J.mc(J.G.get("UI"), "open", ["battle"])
		return null
	if J.seq(J.gp(v_h_237, "kind"), "bld"):
		J.mc(J.G.get("UI"), "openBuilding", [J.gp(v_h_237, "id")])
		return null

func _f66(this_, a: Array, env):
	var v_x_240 = null; var v_y_241 = null; var v_target_242 = null; var v_H_243 = null
	v_x_240 = J.arg(a, 0)
	v_y_241 = J.arg(a, 1)
	v_target_242 = J.arg(a, 2)
	v_H_243 = J.gp(this_, "hero")
	var _t298 = J.max_([14.0, J.min_([J.sub(J.G.get("W"), 14.0), v_x_240])])
	J.sp(v_H_243, "tx", _t298)
	var _t299 = J.max_([150.0, J.min_([J.sub(J.G.get("WH"), 10.0), v_y_241])])
	J.sp(v_H_243, "ty", _t299)
	J.sp(v_H_243, "target", v_target_242)
	J.sp(v_H_243, "act", null)

func _f67(this_, a: Array, env):
	var v_bid_246 = null; var v_n_247 = null; var v_src_248 = null; var v_can_249 = null; var v_bx_250 = null; var v_by_251 = null
	v_bid_246 = J.arg(a, 0)
	v_n_247 = J.arg(a, 1)
	var _t300 = J.bor(v_n_247, 0.0)
	var _t301 = J.bor(v_n_247, 0.0)
	var _t302 = J.max_([1.0, (_t301 if J.t(_t301) else 1.0)])
	v_n_247 = _t302
	v_src_248 = ("wood" if J.seq(v_bid_246, "plank") else "rice")
	v_can_249 = floor(J.num(J.div(J.gp(J.gp(J.G.get("S"), "res"), v_src_248), 4.0)))
	if J.cmp(v_can_249, 1.0, "<"):
		J.mc(J.G.get("Fx"), "float", [J.gp(J.gp(this_, "hero"), "x"), J.sub(J.gp(J.gp(this_, "hero"), "y"), 60.0), (J.str(J.gp(J.G.get("RES_NAMES"), v_src_248)) + "不夠（要 4）"), "#ff9a9a"])
		return null
	if J.cmp(v_can_249, v_n_247, "<"):
		J.mc(J.G.get("Fx"), "float", [J.gp(J.gp(this_, "hero"), "x"), J.sub(J.gp(J.gp(this_, "hero"), "y"), 60.0), ("材料只夠做 " + J.str(v_can_249) + " 份"), "#ffb37a"])
	var _t303 = J.gp(J.G.get("POS"), v_bid_246)
	var _t304 = J.gp(_t303, 0.0)
	v_bx_250 = _t304
	var _t305 = J.gp(_t303, 1.0)
	v_by_251 = _t305
	J.mc(this_, "walkTo", [J.add(v_bx_250, (40.0 if J.seq(v_bid_246, "plank") else (-40.0))), J.add(v_by_251, 14.0), {"kind": "craft", "bid": v_bid_246, "n": v_n_247, "want": v_n_247, "done": 0.0, "short": J.cmp(v_can_249, v_n_247, "<"), "dur": 0.9}])

func _f69(this_, a: Array, env):
	var v_f_262 = null
	v_f_262 = J.arg(a, 0)
	var _t324 = J.add(J.gp(v_f_262, "t"), env["dt"])
	J.sp(v_f_262, "t", _t324)
	return J.cmp(_t324, J.gp(v_f_262, "life"), "<")

func _f70(this_, a: Array, env):
	var v_f_263 = null
	v_f_263 = J.arg(a, 0)
	var _t328 = J.add(J.gp(v_f_263, "t"), env["dt"])
	J.sp(v_f_263, "t", _t328)
	var _t329 = J.add(J.gp(v_f_263, "x"), (J.mul(J.gp(v_f_263, "vx"), env["dt"]) + (sin(J.num(J.mul(J.gp(v_f_263, "t"), 4.0))) * 0.4)))
	J.sp(v_f_263, "x", _t329)
	var _t330 = J.add(J.gp(v_f_263, "y"), J.mul(14.0, env["dt"]))
	J.sp(v_f_263, "y", _t330)
	var _t331 = J.add(J.gp(v_f_263, "rot"), J.mul(env["dt"], 2.0))
	J.sp(v_f_263, "rot", _t331)
	return J.cmp(J.gp(v_f_263, "t"), J.gp(v_f_263, "life"), "<")

func _f71(this_, a: Array, env):
	var v_c_264 = null
	v_c_264 = J.arg(a, 0)
	var _t335 = J.add(J.gp(v_c_264, "t"), env["dt"])
	J.sp(v_c_264, "t", _t335)
	var _t336 = J.add(J.gp(v_c_264, "x"), J.mul(J.gp(v_c_264, "vx"), env["dt"]))
	J.sp(v_c_264, "x", _t336)
	var _t337 = J.add(J.gp(v_c_264, "y"), J.mul(J.gp(v_c_264, "vy"), env["dt"]))
	J.sp(v_c_264, "y", _t337)
	var _t338 = J.sub(J.gp(v_c_264, "vy"), J.mul(30.0, env["dt"]))
	J.sp(v_c_264, "vy", _t338)
	var _t339 = J.add(J.gp(v_c_264, "ph"), J.mul(env["dt"], 22.0))
	J.sp(v_c_264, "ph", _t339)
	return J.cmp(J.gp(v_c_264, "t"), J.gp(v_c_264, "life"), "<")

func _f68(this_, a: Array, env):
	var v_H_255 = null; var v_dx_256 = null; var v_dy_257 = null; var v_d_258 = null; var v_i_259 = null; var v_i_260 = null; var v_sp_261 = null
	var _s115 = {"__p": env, "dt": null}
	_s115["dt"] = J.arg(a, 0)
	if J.cmp(J.gp(this_, "hitstop"), 0.0, ">"):
		var _t306 = this_
		var _t307 = J.sub(J.gp(_t306, "hitstop"), _s115["dt"])
		J.sp(_t306, "hitstop", _t307)
		J.mc(this_, "updateParts", [J.mul(_s115["dt"], 0.3), true])
		return null
	var _t308 = this_
	var _t309 = J.add(J.gp(_t308, "t"), _s115["dt"])
	J.sp(_t308, "t", _t309)
	v_H_255 = J.gp(this_, "hero")
	v_i_259 = 0.0
	while true:
		if not J.cmp(v_i_259, J.len(J.gp(J.G.get("S"), "trees")), "<"): break
		if J.cmp(J.gp(J.gp(J.G.get("S"), "trees"), v_i_259), 0.0, "<="):
			var _t310 = J.gp(J.G.get("S"), "treeRegrow")
			var _t311 = J.sub(J.gp(_t310, v_i_259), _s115["dt"])
			J.sp(_t310, v_i_259, _t311)
			if J.cmp(J.gp(J.gp(J.G.get("S"), "treeRegrow"), v_i_259), 0.0, "<="):
				var _t312 = J.gp(J.G.get("S"), "trees")
				J.sp(_t312, v_i_259, 3.0)
		v_i_259 = J.num(v_i_259) + 1.0
	v_i_260 = 0.0
	while true:
		if not J.cmp(v_i_260, J.len(J.gp(J.G.get("S"), "paddy")), "<"): break
		if (not J.t(J.gp(J.gp(J.G.get("S"), "paddy"), v_i_260))):
			var _t313 = J.gp(J.G.get("S"), "paddyRegrow")
			var _t314 = J.sub(J.gp(_t313, v_i_260), _s115["dt"])
			J.sp(_t313, v_i_260, _t314)
			if J.cmp(J.gp(J.gp(J.G.get("S"), "paddyRegrow"), v_i_260), 0.0, "<="):
				var _t315 = J.gp(J.G.get("S"), "paddy")
				J.sp(_t315, v_i_260, 1.0)
		v_i_260 = J.num(v_i_260) + 1.0
	v_dx_256 = J.sub(J.gp(v_H_255, "tx"), J.gp(v_H_255, "x"))
	v_dy_257 = J.sub(J.gp(v_H_255, "ty"), J.gp(v_H_255, "y"))
	v_d_258 = J.hypot_([v_dx_256, v_dy_257])
	if J.cmp(v_d_258, 2.0, ">"):
		v_sp_261 = J.mul(J.mc(J.G.get("F"), "walk", []), _s115["dt"])
		var _t316 = J.add(J.gp(v_H_255, "x"), (J.div(v_dx_256, v_d_258) * J.min_([v_sp_261, v_d_258])))
		J.sp(v_H_255, "x", _t316)
		var _t317 = J.add(J.gp(v_H_255, "y"), (J.div(v_dy_257, v_d_258) * J.min_([v_sp_261, v_d_258])))
		J.sp(v_H_255, "y", _t317)
		if (absf(J.num(v_dx_256)) > 1.0):
			var _t318 = (1.0 if J.cmp(v_dx_256, 0.0, ">") else (-1.0))
			J.sp(v_H_255, "dir", _t318)
		J.sp(v_H_255, "walking", true)
	else:
		J.sp(v_H_255, "walking", false)
		if J.t(J.gp(v_H_255, "target")):
			var _t319 = J.gp(v_H_255, "target")
			J.sp(v_H_255, "act", _t319)
			J.sp(v_H_255, "target", null)
			J.sp(v_H_255, "actT", 0.0)
			if J.seq(J.gp(J.gp(v_H_255, "act"), "kind"), "tree"):
				var _t320 = (-1.0)
				J.sp(v_H_255, "dir", _t320)
			if J.seq(J.gp(J.gp(v_H_255, "act"), "kind"), "paddy"):
				J.sp(v_H_255, "dir", 1.0)
			if J.seq(J.gp(J.gp(v_H_255, "act"), "kind"), "craft"):
				var _t321 = ((-1.0) if J.seq(J.gp(J.gp(v_H_255, "act"), "bid"), "plank") else 1.0)
				J.sp(v_H_255, "dir", _t321)
		if J.t(J.gp(v_H_255, "act")):
			J.mc(this_, "doAct", [J.mul(_s115["dt"], (J.mc(J.G.get("GhostStreet"), "mul", ["work"]) if (not J.seq(J.typeof_(J.G.get("GhostStreet")), "undefined")) else 1.0))])
	J.mc(this_, "updateParts", [_s115["dt"]])
	if (not J.seq(J.typeof_(J.G.get("HeroDaily")), "undefined")):
		J.mc(J.G.get("HeroDaily"), "update", [this_, _s115["dt"]])
	var _t322 = this_
	var _t323 = J.gp(this_, "floats")
	var _t325 = J.mc(_t323, "filter", [Callable(self, "_f69").bind(_s115)])
	J.sp(_t322, "floats", _t325)
	var _t326 = this_
	var _t327 = J.gp(this_, "feathers")
	var _t332 = J.mc(_t327, "filter", [Callable(self, "_f70").bind(_s115)])
	J.sp(_t326, "feathers", _t332)
	var _t333 = this_
	var _t334 = J.gp(this_, "crows")
	var _t340 = J.mc(_t334, "filter", [Callable(self, "_f71").bind(_s115)])
	J.sp(_t333, "crows", _t340)
	var _t343 = J.gp(this_, "bubble")
	if J.t(_t343):
		var _t341 = J.gp(this_, "bubble")
		var _t342 = J.add(J.gp(_t341, "t"), _s115["dt"])
		J.sp(_t341, "t", _t342)
		_t343 = J.cmp(_t342, 4.6, ">")
	if J.t(_t343):
		var _t344 = this_
		J.sp(_t344, "bubble", null)
	var _t345 = this_
	var _t346 = J.sub(J.gp(_t345, "chatT"), _s115["dt"])
	J.sp(_t345, "chatT", _t346)
	var _t347 = J.cmp(J.gp(this_, "chatT"), 0.0, "<=")
	if ((not J.t(J.gp(this_, "bubble"))) if _t347 else _t347):
		var _t348 = this_
		var _t349 = (6.0 + (randf() * 5.0))
		J.sp(_t348, "chatT", _t349)
		J.mc(this_, "pickChatter", [])

func _f72(this_, a: Array, env):
	var v_dt_267 = null; var v_H_268 = null; var v_a_269 = null; var v_firstHit_270 = null; var v_tx_271 = null; var v_ty_272 = null; var v_tx0_273 = null; var v_ty0_274 = null; var v_px_275 = null; var v_py_276 = null; var v_plank_277 = null; var v_src_278 = null; var v_out_279 = null; var v_more_280 = null
	v_dt_267 = J.arg(a, 0)
	v_H_268 = J.gp(this_, "hero")
	v_a_269 = J.gp(v_H_268, "act")
	var _t350 = J.add(J.gp(v_H_268, "actT"), v_dt_267)
	J.sp(v_H_268, "actT", _t350)
	if J.seq(J.gp(v_a_269, "kind"), "tree"):
		if J.cmp(J.gp(J.gp(J.G.get("S"), "trees"), J.gp(v_a_269, "i")), 0.0, "<="):
			J.sp(v_H_268, "act", null)
			return null
		if J.cmp(J.gp(v_H_268, "actT"), J.mc(J.G.get("F"), "chopTime", []), ">="):
			J.sp(v_H_268, "actT", 0.0)
			v_firstHit_270 = J.seq(J.gp(J.gp(J.G.get("S"), "trees"), J.gp(v_a_269, "i")), 3.0)
			var _t351 = J.gp(J.G.get("S"), "trees")
			var _t352 = J.gp(v_a_269, "i")
			J.sp(_t351, _t352, J.num(J.gp(_t351, _t352)) + -1.0)
			J.sp(v_a_269, "shake", 0.15)
			J.mc(J.G.get("Sound"), "play", ["chop"])
			var _t353 = J.gp(J.G.get("TREE_POS"), J.gp(v_a_269, "i"))
			var _t354 = J.gp(_t353, 0.0)
			v_tx0_273 = _t354
			var _t355 = J.gp(_t353, 1.0)
			v_ty0_274 = _t355
			J.mc(this_, "impact", [J.add(v_tx0_273, 6.0), J.sub(v_ty0_274, 22.0), "wood", (1.2 if J.t(v_firstHit_270) else 1.0)])
			if J.t(v_firstHit_270):
				J.mc(this_, "scatterCrows", [J.gp(v_a_269, "i")])
			var _t356 = J.gp(J.G.get("TREE_POS"), J.gp(v_a_269, "i"))
			var _t357 = J.gp(_t356, 0.0)
			v_tx_271 = _t357
			var _t358 = J.gp(_t356, 1.0)
			v_ty_272 = _t358
			J.mc(J.G.get("Fx"), "float", [v_tx_271, J.sub(v_ty_272, 50.0), "咚！", "#ffe9a8"])
			if J.cmp(J.gp(J.gp(J.G.get("S"), "trees"), J.gp(v_a_269, "i")), 0.0, "<="):
				var _t359 = J.gp(J.G.get("S"), "treeRegrow")
				var _t360 = J.gp(v_a_269, "i")
				J.sp(_t359, _t360, 25.0)
				var _t361 = J.gp(J.G.get("S"), "cnt")
				J.sp(_t361, "chop", J.num(J.gp(_t361, "chop")) + 1.0)
				var _t362 = J.gp(J.G.get("S"), "res")
				var _t363 = J.add(J.gp(_t362, "wood"), 4.0)
				J.sp(_t362, "wood", _t363)
				var _t364 = J.G.get("gainExp")
				J.cl(_t364, null, [2.0])
				J.mc(J.G.get("Sound"), "play", ["treeFall"])
				J.mc(J.G.get("Fx"), "float", [v_tx_271, J.sub(v_ty_272, 70.0), "槐木 +4　好評 +2", "#a8ffcf"])
				J.mc(J.G.get("Fx"), "praise", ["chop"])
				J.sp(v_H_268, "act", null)
				var _t365 = this_
				J.sp(_t365, "proudT", 0.9)
				var _t366 = this_
				J.sp(_t366, "shk", 5.0)
				J.mc(J.G.get("Quest"), "check", [])
	else:
		if J.seq(J.gp(v_a_269, "kind"), "paddy"):
			if J.cmp(J.gp(v_H_268, "actT"), J.mul(J.mc(J.G.get("F"), "chopTime", []), 1.4), ">="):
				var _t367 = J.gp(J.G.get("S"), "paddy")
				var _t368 = J.gp(v_a_269, "i")
				J.sp(_t367, _t368, 0.0)
				var _t369 = J.gp(J.G.get("S"), "paddyRegrow")
				var _t370 = J.gp(v_a_269, "i")
				J.sp(_t369, _t370, 20.0)
				var _t371 = this_
				J.sp(_t371, "proudT", 0.8)
				var _t372 = J.gp(J.G.get("S"), "cnt")
				J.sp(_t372, "rice", J.num(J.gp(_t372, "rice")) + 1.0)
				var _t373 = J.gp(J.G.get("S"), "res")
				var _t374 = J.add(J.gp(_t373, "rice"), 3.0)
				J.sp(_t373, "rice", _t374)
				var _t375 = J.G.get("gainExp")
				J.cl(_t375, null, [1.0])
				J.mc(J.G.get("Sound"), "play", ["harvest"])
				var _t376 = J.gp(J.G.get("PADDY_POS"), J.gp(v_a_269, "i"))
				var _t377 = J.gp(_t376, 0.0)
				v_px_275 = _t377
				var _t378 = J.gp(_t376, 1.0)
				v_py_276 = _t378
				J.mc(J.G.get("Fx"), "float", [v_px_275, J.sub(v_py_276, 30.0), "糯米 +3　好評 +1", "#a8ffcf"])
				J.mc(J.G.get("Fx"), "praise", ["rice"])
				J.sp(v_H_268, "act", null)
				J.mc(J.G.get("Quest"), "check", [])
		else:
			if J.seq(J.gp(v_a_269, "kind"), "craft"):
				if J.leq(J.gp(v_a_269, "n"), null):
					J.sp(v_a_269, "n", 1.0)
					J.sp(v_a_269, "want", 1.0)
					J.sp(v_a_269, "done", 0.0)
				if J.leq(J.gp(v_a_269, "dur"), null):
					J.sp(v_a_269, "dur", 0.9)
				if J.cmp(J.gp(v_H_268, "actT"), J.gp(v_a_269, "dur"), ">="):
					v_plank_277 = J.seq(J.gp(v_a_269, "bid"), "plank")
					v_src_278 = ("wood" if J.t(v_plank_277) else "rice")
					v_out_279 = ("planks" if J.t(v_plank_277) else "buns")
					if J.cmp(J.gp(J.gp(J.G.get("S"), "res"), v_src_278), 4.0, "<"):
						J.sp(v_H_268, "act", null)
						J.mc(J.G.get("Fx"), "float", [J.gp(v_H_268, "x"), J.sub(J.gp(v_H_268, "y"), 60.0), ((J.str(J.gp(J.G.get("RES_NAMES"), v_src_278)) + "用完了，做好 " + J.str(J.gp(v_a_269, "done")) + " 份") if J.t(J.gp(v_a_269, "done")) else (J.str(J.gp(J.G.get("RES_NAMES"), v_src_278)) + "不夠（要 4）")), "#ff9a9a"])
						return null
					var _t379 = J.gp(J.G.get("S"), "res")
					var _t380 = J.sub(J.gp(_t379, v_src_278), 4.0)
					J.sp(_t379, v_src_278, _t380)
					var _t381 = J.gp(J.G.get("S"), "res")
					var _t382 = J.add(J.gp(_t381, v_out_279), 2.0)
					J.sp(_t381, v_out_279, _t382)
					var _t383 = J.gp(J.G.get("S"), "cnt")
					var _t384 = ("craftPlank" if J.t(v_plank_277) else "craftBun")
					J.sp(_t383, _t384, J.num(J.gp(_t383, _t384)) + 1.0)
					var _t385 = J.G.get("gainExp")
					J.cl(_t385, null, [1.0])
					J.mc(J.G.get("Sound"), "play", ["craft"])
					J.sp(v_a_269, "done", J.num(J.gp(v_a_269, "done")) + 1.0)
					J.sp(v_a_269, "n", J.num(J.gp(v_a_269, "n")) + -1.0)
					J.mc(J.G.get("Quest"), "check", [])
					var _t386 = J.cmp(J.gp(v_a_269, "n"), 0.0, ">")
					v_more_280 = (J.cmp(J.gp(J.gp(J.G.get("S"), "res"), v_src_278), 4.0, ">=") if _t386 else _t386)
					if J.seq(J.gp(v_a_269, "want"), 1.0):
						J.mc(J.G.get("Fx"), "float", [J.gp(v_H_268, "x"), J.sub(J.gp(v_H_268, "y"), 60.0), (J.str(J.gp(J.G.get("RES_NAMES"), v_out_279)) + " +2　好評 +1"), "#a8ffcf"])
						J.mc(J.G.get("Fx"), "praise", ["craft"])
					else:
						if J.t(v_more_280):
							J.mc(J.G.get("Fx"), "float", [J.add(J.gp(v_H_268, "x"), 26.0), J.sub(J.gp(v_H_268, "y"), 44.0), (J.str(J.gp(J.G.get("RES_NAMES"), v_out_279)) + " " + J.str(J.gp(v_a_269, "done")) + "/" + J.str((J.add(J.gp(v_a_269, "done"), J.min_([J.gp(v_a_269, "n"), floor(J.num(J.div(J.gp(J.gp(J.G.get("S"), "res"), v_src_278), 4.0)))])) if J.t(J.gp(v_a_269, "short")) else J.gp(v_a_269, "want")))), "#ffe9a8"])
					if J.t(v_more_280):
						J.sp(v_H_268, "actT", 0.0)
						J.sp(v_a_269, "dur", 0.6)
						return null
					J.sp(v_H_268, "act", null)
					if J.cmp(J.gp(v_a_269, "want"), 1.0, ">"):
						J.mc(J.G.get("Fx"), "float", [J.gp(v_H_268, "x"), J.sub(J.gp(v_H_268, "y"), 66.0), (J.str(J.gp(J.G.get("RES_NAMES"), v_out_279)) + " +" + J.str(J.mul(J.gp(v_a_269, "done"), 2.0)) + "　好評 +" + J.str(J.gp(v_a_269, "done"))), "#a8ffcf"])
						J.mc(J.G.get("Fx"), "praise", ["craft"])

func _f73(this_, a: Array, env):
	var v_H_283 = null; var v_a_284 = null
	v_H_283 = J.gp(this_, "hero")
	v_a_284 = J.gp(v_H_283, "act")
	if J.cmp(J.gp(this_, "proudT"), 0.0, ">"):
		return ["proud", 0.0]
	var _t387 = (not J.t(v_a_284))
	if J.t((_t387 if _t387 else J.gp(v_H_283, "walking"))):
		return [null, 0.0]
	if J.seq(J.gp(v_a_284, "kind"), "tree"):
		return ["chop", J.min_([1.0, J.div(J.gp(v_H_283, "actT"), J.mc(J.G.get("F"), "chopTime", []))])]
	if J.seq(J.gp(v_a_284, "kind"), "paddy"):
		return ["reap", J.min_([1.0, J.div(J.gp(v_H_283, "actT"), J.mul(J.mc(J.G.get("F"), "chopTime", []), 1.4))])]
	if J.seq(J.gp(v_a_284, "kind"), "craft"):
		var _t392 = ("hammer" if J.seq(J.gp(v_a_284, "bid"), "plank") else "knead")
		var _t389 = J.gp(v_H_283, "actT")
		var _t388 = J.gp(v_a_284, "dur")
		var _t391 = J.gp(v_H_283, "actT")
		var _t390 = J.gp(v_a_284, "dur")
		return [_t392, J.min_([1.0, J.div(_t391, (_t390 if J.t(_t390) else 0.9))])]
	return [null, 0.0]

func _f74(this_, a: Array, env):
	var v_x_287 = null; var v_y_288 = null; var v_kind_289 = null; var v_power_290 = null; var v_P_291 = null; var v_n_292 = null; var v_i_293 = null
	v_x_287 = J.arg(a, 0)
	v_y_288 = J.arg(a, 1)
	v_kind_289 = J.arg(a, 2)
	v_power_290 = J.arg(a, 3)
	var _t393 = this_
	var _t394 = J.gp(this_, "parts")
	var _t395 = (_t394 if J.t(_t394) else [])
	J.sp(_t393, "parts", _t395)
	v_P_291 = _t395
	var _t396 = (v_power_290 if J.t(v_power_290) else 1.0)
	v_power_290 = _t396
	var _t397 = this_
	var _t398 = J.gp(this_, "hitstop")
	var _t399 = J.gp(this_, "hitstop")
	var _t400 = J.max_([(_t399 if J.t(_t399) else 0.0), J.mul(0.05, v_power_290)])
	J.sp(_t397, "hitstop", _t400)
	var _t401 = this_
	var _t402 = J.gp(this_, "shk")
	var _t403 = J.gp(this_, "shk")
	var _t404 = J.max_([(_t403 if J.t(_t403) else 0.0), J.mul(2.5, v_power_290)])
	J.sp(_t401, "shk", _t404)
	J.mc(v_P_291, "push", [{"k": "spark", "x": v_x_287, "y": v_y_288, "t": 0.0, "life": 0.16, "s": J.mul(0.07, v_power_290), "r": (randf() * 6.0)}])
	v_n_292 = (6.0 if J.seq(v_kind_289, "wood") else (9.0 if J.seq(v_kind_289, "rice") else (2.0 if J.seq(v_kind_289, "dough") else 3.0)))
	v_i_293 = 0.0
	while true:
		if not J.cmp(v_i_293, v_n_292, "<"): break
		J.mc(v_P_291, "push", [{"k": ("chip" if J.seq(v_kind_289, "wood") else ("grain" if J.seq(v_kind_289, "rice") else ("dough" if J.seq(v_kind_289, "dough") else "dust"))), "x": v_x_287, "y": v_y_288, "vx": (((randf() - 0.5) * 120.0) + (50.0 if J.seq(v_kind_289, "wood") else 0.0)), "vy": ((-60.0) - (randf() * 90.0)), "g": ((-10.0) if J.seq(v_kind_289, "dust") else 320.0), "t": 0.0, "life": (0.5 + (randf() * 0.4)), "r": (randf() * 6.0), "vr": ((randf() - 0.5) * 18.0), "s": (0.022 if J.seq(v_kind_289, "dough") else (0.035 if J.seq(v_kind_289, "dust") else (0.04 + (randf() * 0.03))))}])
		v_i_293 = J.num(v_i_293) + 1.0
	if (not J.seq(v_kind_289, "rice")):
		J.mc(v_P_291, "push", [{"k": "dust", "x": v_x_287, "y": J.add(v_y_288, 4.0), "vx": 0.0, "vy": (-12.0), "g": 0.0, "t": 0.0, "life": 0.45, "r": 0.0, "vr": 0.0, "s": 0.05}])

func _f76(this_, a: Array, env):
	var v_p_301 = null
	v_p_301 = J.arg(a, 0)
	var _t407 = J.add(J.gp(v_p_301, "t"), env["dt"])
	J.sp(v_p_301, "t", _t407)
	var _t408 = J.gp(v_p_301, "vx")
	var _t409 = J.add(J.gp(v_p_301, "x"), J.mul((_t408 if J.t(_t408) else 0.0), env["dt"]))
	J.sp(v_p_301, "x", _t409)
	var _t410 = J.gp(v_p_301, "vy")
	var _t411 = J.add(J.gp(v_p_301, "y"), J.mul((_t410 if J.t(_t410) else 0.0), env["dt"]))
	J.sp(v_p_301, "y", _t411)
	var _t412 = J.gp(v_p_301, "vy")
	var _t414 = (_t412 if J.t(_t412) else 0.0)
	var _t413 = J.gp(v_p_301, "g")
	var _t415 = J.add(_t414, J.mul((_t413 if J.t(_t413) else 0.0), env["dt"]))
	J.sp(v_p_301, "vy", _t415)
	var _t416 = J.gp(v_p_301, "vr")
	var _t417 = J.add(J.gp(v_p_301, "r"), J.mul((_t416 if J.t(_t416) else 0.0), env["dt"]))
	J.sp(v_p_301, "r", _t417)
	return J.cmp(J.gp(v_p_301, "t"), J.gp(v_p_301, "life"), "<")

func _f75(this_, a: Array, env):
	var v_frozen_297 = null; var v_P_298 = null; var v_H_299 = null; var v_a_300 = null; var v_p_302 = null; var v_hits_303 = null; var v_prev_304 = null; var v_h_305 = null; var v_p_306 = null; var v_prev_307 = null; var v_h_308 = null; var v_px_309 = null; var v_py_310 = null
	var _s146 = {"__p": env, "dt": null}
	_s146["dt"] = J.arg(a, 0)
	v_frozen_297 = J.arg(a, 1)
	var _t405 = J.gp(this_, "parts")
	v_P_298 = (_t405 if J.t(_t405) else [])
	var _t406 = this_
	var _t418 = J.mc(v_P_298, "filter", [Callable(self, "_f76").bind(_s146)])
	J.sp(_t406, "parts", _t418)
	if J.cmp(J.gp(this_, "shk"), 0.0, ">"):
		var _t419 = this_
		var _t420 = J.max_([0.0, J.sub(J.gp(this_, "shk"), J.mul(_s146["dt"], 18.0))])
		J.sp(_t419, "shk", _t420)
	if J.cmp(J.gp(this_, "proudT"), 0.0, ">"):
		var _t421 = this_
		var _t422 = J.sub(J.gp(_t421, "proudT"), _s146["dt"])
		J.sp(_t421, "proudT", _t422)
	if J.t(v_frozen_297):
		return null
	v_H_299 = J.gp(this_, "hero")
	v_a_300 = J.gp(v_H_299, "act")
	var _t423 = (J.seq(J.gp(v_a_300, "kind"), "craft") if J.t(v_a_300) else v_a_300)
	if J.t(((not J.t(J.gp(v_H_299, "walking"))) if J.t(_t423) else _t423)):
		var _t425 = J.gp(v_H_299, "actT")
		var _t424 = J.gp(v_a_300, "dur")
		var _t427 = J.gp(v_H_299, "actT")
		var _t426 = J.gp(v_a_300, "dur")
		v_p_302 = J.min_([1.0, J.div(_t427, (_t426 if J.t(_t426) else 0.9))])
		v_hits_303 = ([0.5, 0.999] if J.seq(J.gp(v_a_300, "bid"), "plank") else [0.125, 0.375, 0.625, 0.875])
		v_prev_304 = (v_p_302 if J.leq(J.gp(this_, "_pp"), null) else J.gp(this_, "_pp"))
		for _t428 in J.iter(v_hits_303):
			v_h_305 = _t428
			var _t429 = J.cmp(v_prev_304, v_h_305, "<")
			if (J.cmp(v_p_302, v_h_305, ">=") if _t429 else _t429):
				J.mc(this_, "impact", [J.add(J.gp(v_H_299, "x"), ((-16.0) if J.cmp(J.gp(v_H_299, "dir"), 0.0, "<") else 16.0)), J.sub(J.gp(v_H_299, "y"), 4.0), ("wood" if J.seq(J.gp(v_a_300, "bid"), "plank") else "dough"), (0.8 if J.seq(J.gp(v_a_300, "bid"), "plank") else 0.4)])
		var _t430 = this_
		var _t431 = (0.0 if J.cmp(v_p_302, 0.999, ">=") else v_p_302)
		J.sp(_t430, "_pp", _t431)
	else:
		var _t432 = (J.seq(J.gp(v_a_300, "kind"), "paddy") if J.t(v_a_300) else v_a_300)
		if J.t(((not J.t(J.gp(v_H_299, "walking"))) if J.t(_t432) else _t432)):
			v_p_306 = J.min_([1.0, J.div(J.gp(v_H_299, "actT"), J.mul(J.mc(J.G.get("F"), "chopTime", []), 1.4))])
			v_prev_307 = (v_p_306 if J.leq(J.gp(this_, "_pp"), null) else J.gp(this_, "_pp"))
			for _t433 in J.iter([J.div(1.0, 12.0), J.div(5.0, 12.0), J.div(9.0, 12.0)]):
				v_h_308 = _t433
				var _t434 = J.cmp(v_prev_307, v_h_308, "<")
				if (J.cmp(v_p_306, v_h_308, ">=") if _t434 else _t434):
					var _t435 = J.gp(J.G.get("PADDY_POS"), J.gp(v_a_300, "i"))
					var _t436 = J.gp(_t435, 0.0)
					v_px_309 = _t436
					var _t437 = J.gp(_t435, 1.0)
					v_py_310 = _t437
					J.mc(this_, "impact", [(J.sub(v_px_309, 6.0) + (randf() * 12.0)), J.sub(v_py_310, 8.0), "rice", 0.5])
			var _t438 = this_
			J.sp(_t438, "_pp", v_p_306)
		else:
			var _t439 = this_
			J.sp(_t439, "_pp", null)

func _f77(this_, a: Array, env):
	var v_ctx_313 = null; var v_p_314 = null; var v_f_315 = null; var v_im_316 = null; var v_I_317 = null; var v_sc_318 = null
	v_ctx_313 = J.arg(a, 0)
	var _t441 = J.gp(this_, "parts")
	for _t440 in J.iter((_t441 if J.t(_t441) else [])):
		v_p_314 = _t440
		v_f_315 = J.div(J.gp(v_p_314, "t"), J.gp(v_p_314, "life"))
		J.mc(v_ctx_313, "save", [])
		var _t442 = J.max_([0.0, (1.0 - J.mul(v_f_315, v_f_315))])
		J.sp(v_ctx_313, "globalAlpha", _t442)
		J.mc(v_ctx_313, "translate", [J.gp(v_p_314, "x"), J.gp(v_p_314, "y")])
		J.mc(v_ctx_313, "rotate", [J.gp(v_p_314, "r")])
		v_im_316 = J.gp({"spark": "fx_spark", "chip": "fx_chips", "dust": "fx_dust", "dough": "fx_dough", "grain": "fx_dough"}, J.gp(v_p_314, "k"))
		if J.seq(J.gp(v_p_314, "k"), "grain"):
			J.sp(v_ctx_313, "fillStyle", "#e9cf7a")
			J.mc(v_ctx_313, "fillRect", [(-1.5), (-3.0), 3.0, 6.0])
		else:
			var _t444 = (J.seq(J.typeof_(J.G.get("sprOk")), "function") if J.t(v_im_316) else v_im_316)
			if J.t(_t444):
				var _t443 = J.G.get("sprOk")
				_t444 = J.cl(_t443, null, [v_im_316])
			if J.t(_t444):
				v_I_317 = J.gp(J.G.get("SPR"), v_im_316)
				v_sc_318 = J.mul(J.gp(v_p_314, "s"), ((1.0 + J.mul(v_f_315, 0.8)) if J.seq(J.gp(v_p_314, "k"), "spark") else ((1.0 + J.mul(v_f_315, 1.5)) if J.seq(J.gp(v_p_314, "k"), "dust") else 1.0)))
				J.mc(v_ctx_313, "drawImage", [v_I_317, J.div(J.mul((-J.num(J.gp(v_I_317, "naturalWidth"))), v_sc_318), 2.0), J.div(J.mul((-J.num(J.gp(v_I_317, "naturalHeight"))), v_sc_318), 2.0), J.mul(J.gp(v_I_317, "naturalWidth"), v_sc_318), J.mul(J.gp(v_I_317, "naturalHeight"), v_sc_318)])
		J.mc(v_ctx_313, "restore", [])

func _f79(this_, a: Array, env):
	return J.mc(J.G.get("ART"), "drawGate", [env["ctx"], J.gp(J.gp(J.G.get("POS"), "gate"), 0.0), J.gp(J.gp(J.G.get("POS"), "gate"), 1.0), env["t"]])

func _f80(this_, a: Array, env):
	return J.mc(J.G.get("ART"), "drawBuilding", [env["__p"]["__p"]["ctx"], env["__p"]["id"], env["x"], env["y"], env["lv"], env["__p"]["__p"]["t"], (J.cl(J.G.get("furnaceReady"), null, []) if J.seq(env["__p"]["id"], "furnace") else null)])

func _f81(this_, a: Array, env):
	return J.mc(J.G.get("ART"), "drawSite", [env["__p"]["__p"]["ctx"], env["x"], env["y"], J.gp(J.gp(J.G.get("BUILDINGS"), env["__p"]["id"]), "name")])

func _f83(this_, a: Array, env):
	return J.mc(J.G.get("ART"), "drawDecor", [env["__p"]["ctx"], env["k"], env["x"], env["y"], env["__p"]["t"]])

func _f82(this_, a: Array, env):
	var _s168 = {"__p": env, "k": null, "x": null, "y": null}
	var _t453 = J.gp(J.arg(a, 0), 0.0)
	_s168["k"] = _t453
	var _t454 = J.gp(J.arg(a, 0), 1.0)
	_s168["x"] = _t454
	var _t455 = J.gp(J.arg(a, 0), 2.0)
	_s168["y"] = _t455
	return J.mc(_s168["__p"]["items"], "push", [{"y": _s168["y"], "f": Callable(self, "_f83").bind(_s168)}])

func _f85(this_, a: Array, env):
	var _t464 = env["__p"]["ctx"]
	var _t465 = env["x"]
	var _t466 = env["y"]
	var _t467 = J.gp(J.gp(J.G.get("S"), "trees"), env["i"])
	var _t468 = env["__p"]["t"]
	var _t458 = J.gp(J.gp(env["__p"]["this"], "hero"), "act")
	var _t459 = (J.seq(J.gp(J.gp(J.gp(env["__p"]["this"], "hero"), "act"), "kind"), "tree") if J.t(_t458) else _t458)
	var _t460 = (J.seq(J.gp(J.gp(J.gp(env["__p"]["this"], "hero"), "act"), "i"), env["i"]) if J.t(_t459) else _t459)
	var _t463 = (J.cmp(J.gp(J.gp(J.gp(env["__p"]["this"], "hero"), "act"), "shake"), 0.0, ">") if J.t(_t460) else _t460)
	if J.t(_t463):
		var _t461 = J.gp(J.gp(env["__p"]["this"], "hero"), "act")
		var _t462 = J.sub(J.gp(_t461, "shake"), J.div(1.0, 60.0))
		J.sp(_t461, "shake", _t462)
		_t463 = (_t462 > 0.0)
	return J.mc(J.G.get("ART"), "drawTree", [_t464, _t465, _t466, _t467, _t468, _t463, J.seq(J.gp(J.gp(J.G.get("S"), "trees"), env["i"]), 3.0), env["i"]])

func _f84(this_, a: Array, env):
	var _s170 = {"__p": env, "x": null, "y": null, "i": null}
	var _t456 = J.gp(J.arg(a, 0), 0.0)
	_s170["x"] = _t456
	var _t457 = J.gp(J.arg(a, 0), 1.0)
	_s170["y"] = _t457
	_s170["i"] = J.arg(a, 1)
	return J.mc(_s170["__p"]["items"], "push", [{"y": _s170["y"], "f": Callable(self, "_f85").bind(_s170)}])

func _f87(this_, a: Array, env):
	return J.mc(J.G.get("ART"), "drawPaddy", [env["__p"]["ctx"], env["x"], env["y"], J.gp(J.gp(J.G.get("S"), "paddy"), env["i"]), env["__p"]["t"], env["i"]])

func _f86(this_, a: Array, env):
	var _s172 = {"__p": env, "x": null, "y": null, "i": null}
	var _t469 = J.gp(J.arg(a, 0), 0.0)
	_s172["x"] = _t469
	var _t470 = J.gp(J.arg(a, 0), 1.0)
	_s172["y"] = _t470
	_s172["i"] = J.arg(a, 1)
	return J.mc(_s172["__p"]["items"], "push", [{"y": J.sub(_s172["y"], 10.0), "f": Callable(self, "_f87").bind(_s172)}])

func _f88(this_, a: Array, env):
	return (J.mc(J.G.get("WORK"), "drawWorker", [env["__p"]["ctx"], env["s"], env["__p"]["t"], 0.62, env["__p"]["workInfo"]]) if (not J.seq(J.typeof_(J.G.get("WORK")), "undefined")) else J.mc(J.G.get("ART"), "drawChar", [env["__p"]["ctx"], J.gp(J.gp(env["s"], "g"), "k"), J.gp(env["s"], "x"), J.gp(env["s"], "y"), 0.62, {"t": J.add(env["__p"]["t"], J.gp(env["s"], "ph")), "work": true, "flip": J.gp(env["s"], "flip"), "tamed": true, "untied": true}]))

func _f89(this_, a: Array, env):
	var v_g_356 = null
	v_g_356 = J.arg(a, 0)
	var _t476 = (not J.t(J.gp(v_g_356, "post")))
	return ((not J.seq(J.gp(v_g_356, "k"), "afu")) if _t476 else _t476)

func _f91(this_, a: Array, env):
	return J.mc(J.G.get("ART"), "drawChar", [env["__p"]["ctx"], J.gp(env["g"], "k"), env["x"], env["y"], 0.58, {"t": J.add(env["__p"]["t"], env["i"]), "walk": true, "flip": (sin(J.num(env["a"])) > 0.0), "tamed": true, "untied": true}])

func _f90(this_, a: Array, env):
	var _s178 = {"__p": env, "g": null, "i": null, "a": null, "x": null, "y": null}
	_s178["g"] = J.arg(a, 0)
	_s178["i"] = J.arg(a, 1)
	_s178["a"] = (J.mul(_s178["__p"]["t"], 0.25) + J.mul(_s178["i"], 1.7))
	_s178["x"] = (195.0 + (cos(J.num(_s178["a"])) * (60.0 + (J.mod(_s178["i"], 3.0) * 18.0))))
	_s178["y"] = (((400.0 + 130.0) + (sin(J.num(J.mul(_s178["a"], 1.3))) * 18.0)) + (J.mod(_s178["i"], 3.0) * 8.0))
	J.mc(_s178["__p"]["vis"], "push", [{"g": _s178["g"], "x": _s178["x"], "y": _s178["y"]}])
	J.mc(_s178["__p"]["items"], "push", [{"y": _s178["y"], "f": Callable(self, "_f91").bind(_s178)}])

func _f92(this_, a: Array, env):
	return J.mc(J.G.get("ART"), "drawChar", [env["ctx"], "afu", J.gp(env["H"], "x"), J.gp(env["H"], "y"), 0.72, J.S_Object_("assign", [{"t": env["t"], "walk": J.gp(env["H"], "walking"), "work": (not (not J.t(J.gp(env["H"], "act")))), "flip": J.cmp(J.gp(env["H"], "dir"), 0.0, "<"), "mood": ("happy" if J.t(J.gp(J.G.get("S"), "ended")) else null), "pose": J.gp(env["hp"], 0.0), "pt": J.gp(env["hp"], 1.0)}, (env["hd"] if J.t(env["hd"]) else {})])])

func _f93(this_, a: Array, env):
	var v_a_362 = null; var v_b_363 = null
	v_a_362 = J.arg(a, 0)
	v_b_363 = J.arg(a, 1)
	return J.sub(J.gp(v_a_362, "y"), J.gp(v_b_363, "y"))

func _f94(this_, a: Array, env):
	var v_i_364 = null
	v_i_364 = J.arg(a, 0)
	return J.mc(v_i_364, "f", [])

func _f78(this_, a: Array, env):
	var v_sk_323 = null; var v_kx_324 = null; var v_ky_325 = null; var v_spots_327 = null; var v_idle_330 = null; var v_i_334 = null; var v_fx_335 = null; var v_fy_336 = null; var v_i_337 = null; var v_mx_338 = null; var v_my_339 = null; var v_mg_340 = null; var v_s_354 = null; var v_f_365 = null; var v_c_366 = null; var v_f_367 = null
	var _s158 = {"__p": env, "this": null, "ctx": null, "t": null, "items": null, "vis": null, "workInfo": null, "H": null, "hp": null, "hd": null}
	_s158["this"] = this_
	_s158["ctx"] = J.gp(_s158["this"], "ctx")
	_s158["t"] = J.gp(_s158["this"], "t")
	var _t445 = J.gp(_s158["this"], "shk")
	v_sk_323 = (_t445 if J.t(_t445) else 0.0)
	v_kx_324 = J.mul((randf() - 0.5), v_sk_323)
	v_ky_325 = J.mul((randf() - 0.5), v_sk_323)
	J.mc(_s158["ctx"], "setTransform", [J.mul(J.gp(_s158["this"], "dpr"), J.gp(_s158["this"], "scale")), 0.0, 0.0, J.mul(J.gp(_s158["this"], "dpr"), J.gp(_s158["this"], "scale")), J.mul(J.mul(v_kx_324, J.gp(_s158["this"], "dpr")), J.gp(_s158["this"], "scale")), J.mul(J.mul(J.sub(v_ky_325, J.gp(_s158["this"], "camY")), J.gp(_s158["this"], "dpr")), J.gp(_s158["this"], "scale"))])
	J.mc(_s158["ctx"], "drawImage", [J.cl(J.G.get("groundLayer"), null, []), 0.0, 0.0, J.G.get("W"), J.G.get("WH")])
	v_i_334 = 0.0
	while true:
		if not J.cmp(v_i_334, 9.0, "<"): break
		v_fx_335 = J.mod((J.mul(v_i_334, 47.0) + 20.0), J.G.get("W"))
		v_fy_336 = (24.0 + J.mod(J.mul(v_i_334, 31.0), 112.0))
		var _t446 = J.G.get("drawLily")
		J.cl(_t446, null, [_s158["ctx"], v_fx_335, v_fy_336, J.add(_s158["t"], v_i_334)])
		v_i_334 = J.num(v_i_334) + 1.0
	v_i_337 = 0.0
	while true:
		if not J.cmp(v_i_337, 6.0, "<"): break
		v_mx_338 = (J.mod((J.mul(_s158["t"], 8.0) + J.mul(v_i_337, 90.0)), J.add(J.G.get("W"), 200.0)) - 100.0)
		v_my_339 = (160.0 + J.mul(v_i_337, 170.0))
		v_mg_340 = J.mc(_s158["ctx"], "createRadialGradient", [v_mx_338, v_my_339, 5.0, v_mx_338, v_my_339, 90.0])
		J.mc(v_mg_340, "addColorStop", [0.0, "rgba(200,210,200,.06)"])
		J.mc(v_mg_340, "addColorStop", [1.0, "rgba(200,210,200,0)"])
		var _t447 = _s158["ctx"]
		J.sp(_t447, "fillStyle", v_mg_340)
		J.mc(_s158["ctx"], "fillRect", [J.sub(v_mx_338, 90.0), J.sub(v_my_339, 90.0), 180.0, 180.0])
		v_i_337 = J.num(v_i_337) + 1.0
	_s158["items"] = []
	J.mc(_s158["items"], "push", [{"y": J.gp(J.gp(J.G.get("POS"), "gate"), 1.0), "f": Callable(self, "_f79").bind(_s158)}])
	for _t448 in J.iter(J.G.get("BLD_ORDER")):
		var _s164 = {"__p": _s158, "id": null}
		_s164["id"] = _t448
		var _s165 = {"__p": _s164, "x": null, "y": null, "lv": null}
		var _t449 = J.gp(J.G.get("POS"), _s165["__p"]["id"])
		var _t450 = J.gp(_t449, 0.0)
		_s165["x"] = _t450
		var _t451 = J.gp(_t449, 1.0)
		_s165["y"] = _t451
		_s165["lv"] = J.gp(J.gp(J.G.get("S"), "bld"), _s165["__p"]["id"])
		if J.t(_s165["lv"]):
			J.mc(_s165["__p"]["__p"]["items"], "push", [{"y": _s165["y"], "f": Callable(self, "_f80").bind(_s165)}])
		else:
			var _t452 = J.G.get("bldUnlocked")
			if J.t(J.cl(_t452, null, [_s165["__p"]["id"]])):
				J.mc(_s165["__p"]["__p"]["items"], "push", [{"y": _s165["y"], "f": Callable(self, "_f81").bind(_s165)}])
	J.mc(J.G.get("DECOR"), "forEach", [Callable(self, "_f82").bind(_s158)])
	J.mc(J.G.get("TREE_POS"), "forEach", [Callable(self, "_f84").bind(_s158)])
	J.mc(J.G.get("PADDY_POS"), "forEach", [Callable(self, "_f86").bind(_s158)])
	v_spots_327 = J.mc(_s158["this"], "workerSpots", [])
	var _t471 = _s158["this"]
	var _t472 = []
	J.sp(_t471, "vis", _t472)
	_s158["vis"] = _t472
	for _t473 in J.iter(v_spots_327):
		v_s_354 = _t473
		J.mc(_s158["vis"], "push", [{"g": J.gp(v_s_354, "g"), "x": J.gp(v_s_354, "x"), "y": J.gp(v_s_354, "y")}])
	_s158["workInfo"] = {"furnace": ([J.gp(J.gp(J.G.get("POS"), "furnace"), 0.0), J.sub(J.gp(J.gp(J.G.get("POS"), "furnace"), 1.0), 22.0)] if J.t(J.gp(J.gp(J.G.get("S"), "bld"), "furnace")) else null)}
	for _t474 in J.iter(v_spots_327):
		var _s175 = {"__p": _s158, "s": null}
		_s175["s"] = _t474
		J.mc(_s175["__p"]["items"], "push", [{"y": J.gp(_s175["s"], "y"), "f": Callable(self, "_f88").bind(_s175)}])
	var _t475 = J.gp(J.G.get("S"), "ghosts")
	v_idle_330 = J.mc(_t475, "filter", [Callable(self, "_f89").bind(_s158)])
	if (not J.seq(J.typeof_(J.G.get("PlazaLife")), "undefined")):
		J.mc(J.G.get("PlazaLife"), "frame", [_s158["this"], v_idle_330, _s158["items"], _s158["vis"], _s158["ctx"], _s158["t"]])
	else:
		J.mc(v_idle_330, "forEach", [Callable(self, "_f90").bind(_s158)])
	_s158["H"] = J.gp(_s158["this"], "hero")
	J.mc(_s158["vis"], "push", [{"g": J.gp(J.gp(J.G.get("S"), "ghosts"), 0.0), "x": J.gp(_s158["H"], "x"), "y": J.gp(_s158["H"], "y"), "hero": true}])
	_s158["hp"] = J.mc(_s158["this"], "heroPose", [])
	_s158["hd"] = (J.mc(J.G.get("HeroDaily"), "opts", [_s158["this"]]) if (not J.seq(J.typeof_(J.G.get("HeroDaily")), "undefined")) else null)
	J.mc(_s158["items"], "push", [{"y": J.gp(_s158["H"], "y"), "f": Callable(self, "_f92").bind(_s158)}])
	var _t477 = J.mc(_s158["items"], "sort", [Callable(self, "_f93").bind(_s158)])
	J.mc(_t477, "forEach", [Callable(self, "_f94").bind(_s158)])
	for _t478 in J.iter(J.gp(_s158["this"], "feathers")):
		v_f_365 = _t478
		J.mc(_s158["ctx"], "save", [])
		var _t479 = _s158["ctx"]
		var _t480 = J.max_([0.0, (1.0 - J.div(J.gp(v_f_365, "t"), J.gp(v_f_365, "life")))])
		J.sp(_t479, "globalAlpha", _t480)
		J.mc(_s158["ctx"], "translate", [J.gp(v_f_365, "x"), J.gp(v_f_365, "y")])
		J.mc(_s158["ctx"], "rotate", [(sin(J.num(J.gp(v_f_365, "rot"))) * 0.8)])
		J.mc(J.G.get("ART"), "el", [_s158["ctx"], 0.0, 0.0, 1.4, 4.0, "#14111a", "#5a5068", 0.5])
		J.mc(_s158["ctx"], "restore", [])
	J.mc(_s158["this"], "drawParts", [_s158["ctx"]])
	for _t481 in J.iter(J.gp(_s158["this"], "crows")):
		v_c_366 = _t481
		var _t482 = _s158["ctx"]
		var _t483 = J.min_([1.0, J.div(J.sub(J.gp(v_c_366, "life"), J.gp(v_c_366, "t")), 0.6)])
		J.sp(_t482, "globalAlpha", _t483)
		J.mc(J.G.get("ART"), "drawCrow", [_s158["ctx"], J.gp(v_c_366, "x"), J.gp(v_c_366, "y"), J.gp(v_c_366, "s"), J.gp(v_c_366, "ph"), J.gp(v_c_366, "vx"), false])
		var _t484 = _s158["ctx"]
		J.sp(_t484, "globalAlpha", 1.0)
	if J.t(J.gp(_s158["this"], "bubble")):
		J.mc(_s158["this"], "drawBubble", [_s158["ctx"]])
	J.mc(_s158["this"], "drawPointer", [_s158["ctx"], _s158["t"]])
	for _t485 in J.iter(J.gp(_s158["this"], "floats")):
		v_f_367 = _t485
		var _t486 = _s158["ctx"]
		var _t487 = J.max_([0.0, (1.0 - J.div(J.gp(v_f_367, "t"), J.gp(v_f_367, "life")))])
		J.sp(_t486, "globalAlpha", _t487)
		var _t488 = _s158["ctx"]
		var _t489 = "bold 14px \"PingFang TC\",\"Noto Sans TC\",sans-serif"
		J.sp(_t488, "font", _t489)
		var _t490 = _s158["ctx"]
		J.sp(_t490, "textAlign", "center")
		var _t491 = _s158["ctx"]
		J.sp(_t491, "lineWidth", 3.5)
		var _t492 = _s158["ctx"]
		J.sp(_t492, "strokeStyle", "rgba(10,6,20,.9)")
		J.mc(_s158["ctx"], "strokeText", [J.gp(v_f_367, "text"), J.gp(v_f_367, "x"), J.sub(J.gp(v_f_367, "y"), J.mul(J.gp(v_f_367, "t"), 26.0))])
		var _t493 = _s158["ctx"]
		var _t494 = J.gp(v_f_367, "col")
		J.sp(_t493, "fillStyle", _t494)
		J.mc(_s158["ctx"], "fillText", [J.gp(v_f_367, "text"), J.gp(v_f_367, "x"), J.sub(J.gp(v_f_367, "y"), J.mul(J.gp(v_f_367, "t"), 26.0))])
		var _t495 = _s158["ctx"]
		J.sp(_t495, "globalAlpha", 1.0)

func _f95(this_, a: Array, env):
	var v_i_370 = null; var v_tx_371 = null; var v_ty_372 = null; var v_n_373 = null; var v_k_374 = null; var v_dir_375 = null; var v_sx_376 = null; var v_sy_377 = null
	v_i_370 = J.arg(a, 0)
	var _t496 = J.gp(J.G.get("TREE_POS"), v_i_370)
	var _t497 = J.gp(_t496, 0.0)
	v_tx_371 = _t497
	var _t498 = J.gp(_t496, 1.0)
	v_ty_372 = _t498
	v_n_373 = (3.0 + floor(J.num((randf() * 3.0))))
	v_k_374 = 0.0
	while true:
		if not J.cmp(v_k_374, v_n_373, "<"): break
		v_dir_375 = (1.0 if J.t(J.mod(v_k_374, 2.0)) else (-1.0))
		v_sx_376 = J.add(v_tx_371, ((randf() - 0.5) * 40.0))
		v_sy_377 = (J.sub(v_ty_372, 48.0) - (randf() * 18.0))
		var _t499 = J.gp(this_, "crows")
		J.mc(_t499, "push", [{"x": v_sx_376, "y": v_sy_377, "vx": J.mul(v_dir_375, (50.0 + (randf() * 90.0))), "vy": (-(50.0 + (randf() * 60.0))), "t": 0.0, "life": (2.0 + (randf() * 0.8)), "ph": (randf() * 6.0), "s": (1.1 + (randf() * 0.4))}])
		var _t500 = J.gp(this_, "feathers")
		J.mc(_t500, "push", [{"x": v_sx_376, "y": v_sy_377, "t": 0.0, "life": 2.4, "vx": ((randf() - 0.5) * 20.0), "rot": (randf() * 6.0)}])
		v_k_374 = J.num(v_k_374) + 1.0
	J.mc(J.G.get("Sound"), "play", ["crow", J.div(J.sub(v_tx_371, 195.0), 195.0)])

func _f97(this_, a: Array, env):
	var v_v_388 = null
	v_v_388 = J.arg(a, 0)
	var _t502 = J.cmp(J.gp(v_v_388, "y"), J.add(env["top"], 120.0), ">")
	var _t503 = (J.cmp(J.gp(v_v_388, "y"), env["bot"], "<") if _t502 else _t502)
	var _t505 = (J.gp(J.G.get("CHATTER"), J.gp(J.gp(v_v_388, "g"), "k")) if _t503 else _t503)
	if J.t(_t505):
		var _t504 = (not J.t(J.gp(v_v_388, "hero")))
		_t505 = (_t504 if _t504 else J.cmp(J.gp(J.G.get("S"), "qi"), 3.0, ">"))
	return _t505

func _f98(this_, a: Array, env):
	var v_l_389 = null
	v_l_389 = J.arg(a, 0)
	return (not J.t(J.mc(env["used"], "includes", [v_l_389])))

func _f96(this_, a: Array, env):
	var v_cand_382 = null; var v_v_383 = null; var v_k_384 = null; var v_pool_386 = null; var v_line_387 = null
	var _s192 = {"__p": env, "top": null, "bot": null, "used": null}
	_s192["top"] = J.add(J.gp(this_, "camY"), 60.0)
	_s192["bot"] = J.sub(J.add(J.gp(this_, "camY"), J.div(J.gp(this_, "h"), J.gp(this_, "scale"))), 20.0)
	var _t501 = J.gp(this_, "vis")
	v_cand_382 = J.mc(_t501, "filter", [Callable(self, "_f97").bind(_s192)])
	var _t506 = (not J.t(J.len(v_cand_382)))
	var _t507 = (_t506 if _t506 else J.mc(J.G.get("Story"), "busy", []))
	if J.t((_t507 if J.t(_t507) else J.mc(J.G.get("UI"), "modalOpen", []))):
		return null
	v_v_383 = J.gp(v_cand_382, floor(J.num((randf() * J.len(v_cand_382)))))
	v_k_384 = J.gp(J.gp(v_v_383, "g"), "k")
	var _t508 = J.gp(this_, "chatUsed")
	var _t509 = J.gp(J.gp(this_, "chatUsed"), v_k_384)
	var _t510 = (_t509 if J.t(_t509) else [])
	J.sp(_t508, v_k_384, _t510)
	_s192["used"] = _t510
	var _t511 = J.gp(J.G.get("CHATTER"), v_k_384)
	v_pool_386 = J.mc(_t511, "filter", [Callable(self, "_f98").bind(_s192)])
	if (not J.t(J.len(v_pool_386))):
		var _t512 = _s192["used"]
		J.sp(_t512, "length", 0.0)
		v_pool_386 = J.gp(J.G.get("CHATTER"), v_k_384)
	v_line_387 = J.gp(v_pool_386, floor(J.num((randf() * J.len(v_pool_386)))))
	J.mc(_s192["used"], "push", [v_line_387])
	var _t513 = this_
	var _t514 = {"id": J.gp(J.gp(v_v_383, "g"), "id"), "hero": (not (not J.t(J.gp(v_v_383, "hero")))), "text": v_line_387, "t": 0.0}
	J.sp(_t513, "bubble", _t514)

func _f100(this_, a: Array, env):
	var v_o_404 = null
	v_o_404 = J.arg(a, 0)
	var _t517 = null
	if J.t(J.gp(env["b"], "hero")):
		_t517 = J.gp(v_o_404, "hero")
	else:
		var _t516 = J.seq(J.gp(J.gp(v_o_404, "g"), "id"), J.gp(env["b"], "id"))
		_t517 = ((not J.t(J.gp(v_o_404, "hero"))) if _t516 else _t516)
	return _t517

func _f101(this_, a: Array, env):
	var v_l_406 = null
	v_l_406 = J.arg(a, 0)
	return J.gp(J.mc(env["ctx"], "measureText", [v_l_406]), "width")

func _f102(this_, a: Array, env):
	var v_l_407 = null; var v_i_408 = null
	v_l_407 = J.arg(a, 0)
	v_i_408 = J.arg(a, 1)
	return J.mc(env["ctx"], "fillText", [v_l_407, J.add(env["bx"], 8.0), J.add(J.add(env["by"], 6.0), J.mul(v_i_408, 17.0))])

func _f99(this_, a: Array, env):
	var v_v_394 = null; var v_a_395 = null; var v_maxW_396 = null; var v_chars_397 = null; var v_lines_398 = null; var v_cur_399 = null; var v_w_400 = null; var v_h_401 = null; var v_ch_405 = null
	var _s196 = {"__p": env, "ctx": null, "b": null, "bx": null, "by": null}
	_s196["ctx"] = J.arg(a, 0)
	_s196["b"] = J.gp(this_, "bubble")
	var _t515 = J.gp(this_, "vis")
	v_v_394 = J.mc(_t515, "find", [Callable(self, "_f100").bind(_s196)])
	if (not J.t(v_v_394)):
		var _t518 = this_
		J.sp(_t518, "bubble", null)
		return null
	v_a_395 = J.min_([1.0, J.mul(J.gp(_s196["b"], "t"), 5.0), (J.sub(4.6, J.gp(_s196["b"], "t")) * 3.0)])
	J.mc(_s196["ctx"], "save", [])
	var _t519 = _s196["ctx"]
	var _t520 = J.max_([0.0, v_a_395])
	J.sp(_t519, "globalAlpha", _t520)
	var _t521 = _s196["ctx"]
	var _t522 = "600 12.5px \"PingFang TC\",\"Noto Sans TC\",sans-serif"
	J.sp(_t521, "font", _t522)
	v_maxW_396 = 168.0
	v_chars_397 = J.spread([J.SP(J.gp(_s196["b"], "text"))])
	v_lines_398 = []
	v_cur_399 = ""
	for _t523 in J.iter(v_chars_397):
		v_ch_405 = _t523
		if J.cmp(J.gp(J.mc(_s196["ctx"], "measureText", [J.add(v_cur_399, v_ch_405)]), "width"), v_maxW_396, ">"):
			J.mc(v_lines_398, "push", [v_cur_399])
			v_cur_399 = v_ch_405
		else:
			var _t524 = J.add(v_cur_399, v_ch_405)
			v_cur_399 = _t524
	if J.t(v_cur_399):
		J.mc(v_lines_398, "push", [v_cur_399])
	v_w_400 = (J.max_(J.spread([J.SP(J.mc(v_lines_398, "map", [Callable(self, "_f101").bind(_s196)]))])) + 16.0)
	v_h_401 = ((J.len(v_lines_398) * 17.0) + 10.0)
	_s196["bx"] = J.max_([6.0, J.min_([(J.sub(J.G.get("W"), v_w_400) - 6.0), J.sub(J.gp(v_v_394, "x"), J.div(v_w_400, 2.0))])])
	_s196["by"] = J.sub(J.sub(J.gp(v_v_394, "y"), 62.0), v_h_401)
	J.mc(J.G.get("ART"), "rr", [_s196["ctx"], _s196["bx"], _s196["by"], v_w_400, v_h_401, 4.0, "#ecd9a4", "#5a4030", 1.2])
	J.mc(J.G.get("ART"), "poly", [_s196["ctx"], [J.sub(J.gp(v_v_394, "x"), 5.0), J.sub(J.add(_s196["by"], v_h_401), 0.5), J.add(J.gp(v_v_394, "x"), 5.0), J.sub(J.add(_s196["by"], v_h_401), 0.5), J.gp(v_v_394, "x"), J.add(J.add(_s196["by"], v_h_401), 7.0)], "#ecd9a4"])
	var _t525 = _s196["ctx"]
	J.sp(_t525, "strokeStyle", "#5a4030")
	var _t526 = _s196["ctx"]
	J.sp(_t526, "lineWidth", 1.2)
	J.mc(_s196["ctx"], "beginPath", [])
	J.mc(_s196["ctx"], "moveTo", [J.sub(J.gp(v_v_394, "x"), 5.0), J.add(_s196["by"], v_h_401)])
	J.mc(_s196["ctx"], "lineTo", [J.gp(v_v_394, "x"), J.add(J.add(_s196["by"], v_h_401), 7.0)])
	J.mc(_s196["ctx"], "lineTo", [J.add(J.gp(v_v_394, "x"), 5.0), J.add(_s196["by"], v_h_401)])
	J.mc(_s196["ctx"], "stroke", [])
	var _t527 = _s196["ctx"]
	J.sp(_t527, "fillStyle", "#2b1d12")
	var _t528 = _s196["ctx"]
	J.sp(_t528, "textAlign", "left")
	var _t529 = _s196["ctx"]
	J.sp(_t529, "textBaseline", "top")
	J.mc(v_lines_398, "forEach", [Callable(self, "_f102").bind(_s196)])
	J.mc(_s196["ctx"], "restore", [])

func _f105(this_, a: Array, env):
	var v_g_415 = null; var v_i_416 = null; var v_p_417 = null
	v_g_415 = J.arg(a, 0)
	v_i_416 = J.arg(a, 1)
	v_p_417 = J.gp(env["pts"], J.mod(v_i_416, J.len(env["pts"])))
	J.mc(env["__p"]["out"], "push", [{"g": v_g_415, "x": J.gp(v_p_417, 0.0), "y": J.gp(v_p_417, 1.0), "flip": J.gp(v_p_417, 2.0), "ph": J.mul(v_i_416, 0.7), "post": env["post"]}])

func _f104(this_, a: Array, env):
	var _s205 = {"__p": env, "post": null, "pts": null}
	_s205["post"] = J.arg(a, 0)
	_s205["pts"] = J.arg(a, 1)
	var _t530 = J.G.get("workersAt")
	var _t531 = J.cl(_t530, null, [_s205["post"]])
	return J.mc(_t531, "forEach", [Callable(self, "_f105").bind(_s205)])

func _f103(this_, a: Array, env):
	var v_add_412 = null
	var _s204 = {"__p": env, "out": null}
	_s204["out"] = []
	v_add_412 = Callable(self, "_f104").bind(_s204)
	J.cl(v_add_412, null, ["wood", [[130.0, 520.0, 1.0], [178.0, 430.0, 1.0], [70.0, 540.0, 0.0], [24.0, 460.0, 0.0]]])
	J.cl(v_add_412, null, ["rice", [[290.0, 437.0, 0.0], [290.0, 487.0, 0.0], [290.0, 537.0, 1.0], [372.0, 487.0, 1.0]]])
	J.cl(v_add_412, null, ["plank", [[45.0, 770.0, 0.0], [140.0, 772.0, 1.0], [60.0, 790.0, 0.0], [128.0, 794.0, 1.0]]])
	J.cl(v_add_412, null, ["bun", [[250.0, 772.0, 0.0], [345.0, 770.0, 1.0], [262.0, 794.0, 0.0], [332.0, 794.0, 1.0]]])
	J.cl(v_add_412, null, ["store", [[150.0, 890.0, 0.0]]])
	J.cl(v_add_412, null, ["boss", [[260.0, 320.0, 1.0]]])
	J.cl(v_add_412, null, ["camp", [[250.0, 1018.0, 0.0], [350.0, 1018.0, 1.0], [270.0, 1036.0, 0.0], [330.0, 1036.0, 1.0]]])
	return _s204["out"]

func _f107(this_, a: Array, env):
	var v_v_422 = null
	v_v_422 = J.arg(a, 0)
	return J.cmp(v_v_422, 0.0, ">")

func _f108(this_, a: Array, env):
	var v_v_424 = null
	v_v_424 = J.arg(a, 0)
	return v_v_424

func _f106(this_, a: Array, env):
	var v_q_420 = null; var v_i_421 = null; var v_i_423 = null
	v_q_420 = J.mc(J.G.get("Quest"), "cur", [])
	if (not J.t(v_q_420)):
		return null
	if J.seq(J.gp(v_q_420, "go"), "tree"):
		var _t532 = J.gp(J.G.get("S"), "trees")
		v_i_421 = J.mc(_t532, "findIndex", [Callable(self, "_f107").bind(env)])
		return (J.gp(J.G.get("TREE_POS"), v_i_421) if J.cmp(v_i_421, 0.0, ">=") else J.gp(J.G.get("TREE_POS"), 0.0))
	if J.seq(J.gp(v_q_420, "go"), "paddy"):
		var _t533 = J.gp(J.G.get("S"), "paddy")
		v_i_423 = J.mc(_t533, "findIndex", [Callable(self, "_f108").bind(env)])
		return (J.gp(J.G.get("PADDY_POS"), v_i_423) if J.cmp(v_i_423, 0.0, ">=") else J.gp(J.G.get("PADDY_POS"), 0.0))
	if J.seq(J.gp(v_q_420, "go"), "gate"):
		return J.gp(J.G.get("POS"), "gate")
	if J.t(J.gp(J.G.get("POS"), J.gp(v_q_420, "go"))):
		return J.gp(J.G.get("POS"), J.gp(v_q_420, "go"))
	return null

func _f109(this_, a: Array, env):
	var v_ctx_427 = null; var v_t_428 = null; var v_p_429 = null; var v_vh_430 = null; var v_x_431 = null; var v_y_432 = null; var v_ty_433 = null; var v_top_434 = null; var v_bot_435 = null; var v_rot_436 = null
	v_ctx_427 = J.arg(a, 0)
	v_t_428 = J.arg(a, 1)
	v_p_429 = J.mc(this_, "questTarget", [])
	var _t534 = (not J.t(v_p_429))
	if (_t534 if _t534 else (not J.seq(J.gp(J.G.get("UI"), "tab"), "village"))):
		return null
	v_vh_430 = J.div(J.gp(this_, "h"), J.gp(this_, "scale"))
	var _t535 = J.gp(v_p_429, 0.0)
	v_x_431 = _t535
	var _t536 = J.gp(v_p_429, 1.0)
	v_y_432 = _t536
	var _t537 = J.seq(J.gp(J.gp(J.G.get("POS"), "house"), 0.0), v_x_431)
	v_ty_433 = (J.sub(v_y_432, (128.0 if (J.seq(J.gp(J.gp(J.G.get("POS"), "house"), 1.0), v_y_432) if _t537 else _t537) else 78.0)) + (sin(J.num(J.mul(v_t_428, 5.0))) * 5.0))
	v_top_434 = J.add(J.gp(this_, "camY"), 8.0)
	v_bot_435 = J.sub(J.add(J.gp(this_, "camY"), v_vh_430), 12.0)
	v_rot_436 = 0.0
	if J.cmp(v_ty_433, v_top_434, "<"):
		var _t538 = J.add(v_top_434, 14.0)
		v_ty_433 = _t538
		v_rot_436 = PI
	else:
		if J.cmp(v_ty_433, v_bot_435, ">"):
			var _t539 = J.sub(v_bot_435, 14.0)
			v_ty_433 = _t539
			v_rot_436 = 0.0
	J.mc(v_ctx_427, "save", [])
	J.mc(v_ctx_427, "translate", [v_x_431, v_ty_433])
	J.mc(v_ctx_427, "rotate", [v_rot_436])
	J.mc(J.G.get("ART"), "poly", [v_ctx_427, [(-9.0), (-14.0), 9.0, (-14.0), 9.0, (-2.0), 15.0, (-2.0), 0.0, 12.0, (-15.0), (-2.0), (-9.0), (-2.0)], "#ffd84a", "#3a2400", 2.0])
	J.mc(v_ctx_427, "restore", [])

func _f119(this_, a: Array, env):
	var v_p_531 = null; var v_a_532 = null; var v_w_533 = null; var v_h_534 = null; var v_sx_535 = null; var v_back_536 = null; var v_shade_537 = null; var v_q_538 = null; var v_q_539 = null
	v_p_531 = J.arg(a, 0)
	v_a_532 = J.arg(a, 1)
	v_w_533 = J.gp(v_p_531, "w")
	v_h_534 = J.gp(v_p_531, "h")
	v_sx_535 = cos(J.num(J.gp(v_p_531, "fl")))
	J.mc(env["x"], "save", [])
	J.mc(env["x"], "translate", [J.gp(v_p_531, "x"), J.gp(v_p_531, "y")])
	J.mc(env["x"], "rotate", [J.gp(v_p_531, "rot")])
	J.mc(env["x"], "scale", [v_sx_535, 1.0])
	var _t570 = env["x"]
	J.sp(_t570, "globalAlpha", v_a_532)
	v_back_536 = J.cmp(v_sx_535, 0.0, "<")
	v_shade_537 = (0.75 + (0.25 * absf(J.num(v_sx_535))))
	if J.t(J.gp(v_p_531, "gold")):
		var _t571 = env["x"]
		var _t572 = (("rgb(" + J.str(J.bor(J.mul(190.0, v_shade_537), 0.0)) + "," + J.str(J.bor(J.mul(140.0, v_shade_537), 0.0)) + "," + J.str(J.bor(J.mul(50.0, v_shade_537), 0.0)) + ")") if J.t(v_back_536) else ("rgb(" + J.str(J.bor(J.mul(236.0, v_shade_537), 0.0)) + "," + J.str(J.bor(J.mul(188.0, v_shade_537), 0.0)) + "," + J.str(J.bor(J.mul(70.0, v_shade_537), 0.0)) + ")"))
		J.sp(_t571, "fillStyle", _t572)
		J.mc(env["x"], "fillRect", [J.div((-J.num(v_w_533)), 2.0), J.div((-J.num(v_h_534)), 2.0), v_w_533, v_h_534])
		var _t573 = env["x"]
		J.sp(_t573, "strokeStyle", "rgba(140,80,10,.7)")
		var _t574 = env["x"]
		J.sp(_t574, "lineWidth", 1.0)
		J.mc(env["x"], "strokeRect", [(J.div((-J.num(v_w_533)), 2.0) + 1.5), (J.div((-J.num(v_h_534)), 2.0) + 1.5), J.sub(v_w_533, 3.0), J.sub(v_h_534, 3.0)])
		if (not J.t(v_back_536)):
			v_q_538 = J.mul(v_h_534, 0.42)
			var _t575 = env["x"]
			J.sp(_t575, "fillStyle", "#c8281c")
			J.mc(env["x"], "fillRect", [J.div((-J.num(v_q_538)), 2.0), J.div((-J.num(v_q_538)), 2.0), v_q_538, v_q_538])
			var _t576 = env["x"]
			J.sp(_t576, "fillStyle", "rgba(255,220,120,.85)")
			J.mc(env["x"], "fillRect", [J.div((-J.num(v_q_538)), 5.0), J.div((-J.num(v_q_538)), 5.0), J.mul(v_q_538, 0.4), J.mul(v_q_538, 0.4)])
	else:
		var _t577 = env["x"]
		var _t578 = (("rgb(" + J.str(J.bor(J.mul(170.0, v_shade_537), 0.0)) + "," + J.str(J.bor(J.mul(172.0, v_shade_537), 0.0)) + "," + J.str(J.bor(J.mul(178.0, v_shade_537), 0.0)) + ")") if J.t(v_back_536) else ("rgb(" + J.str(J.bor(J.mul(226.0, v_shade_537), 0.0)) + "," + J.str(J.bor(J.mul(228.0, v_shade_537), 0.0)) + "," + J.str(J.bor(J.mul(234.0, v_shade_537), 0.0)) + ")"))
		J.sp(_t577, "fillStyle", _t578)
		J.mc(env["x"], "fillRect", [J.div((-J.num(v_w_533)), 2.0), J.div((-J.num(v_h_534)), 2.0), v_w_533, v_h_534])
		var _t579 = env["x"]
		J.sp(_t579, "strokeStyle", "rgba(90,95,110,.6)")
		var _t580 = env["x"]
		J.sp(_t580, "lineWidth", 1.0)
		J.mc(env["x"], "strokeRect", [(J.div((-J.num(v_w_533)), 2.0) + 1.5), (J.div((-J.num(v_h_534)), 2.0) + 1.5), J.sub(v_w_533, 3.0), J.sub(v_h_534, 3.0)])
		if (not J.t(v_back_536)):
			v_q_539 = J.mul(v_h_534, 0.42)
			var _t581 = env["x"]
			J.sp(_t581, "fillStyle", "#7d828f")
			J.mc(env["x"], "fillRect", [J.div((-J.num(v_q_539)), 2.0), J.div((-J.num(v_q_539)), 2.0), v_q_539, v_q_539])
	J.mc(env["x"], "restore", [])

func _f120(this_, a: Array, env):
	var v_now_540 = null; var v_el_541 = null; var v_dt_542 = null; var v_fade_543 = null; var v_g_544 = null; var v_p_545 = null; var v_term_546 = null; var v_s_547 = null; var v_k_548 = null; var v_r_549 = null
	v_now_540 = J.arg(a, 0)
	v_el_541 = J.div(J.sub(v_now_540, env["t0"]), 1000.0)
	v_dt_542 = J.min_([0.05, J.div(J.sub(v_now_540, env["last"]), 1000.0)])
	env["last"] = v_now_540
	J.mc(env["x"], "setTransform", [env["dpr"], 0.0, 0.0, env["dpr"], 0.0, 0.0])
	J.mc(env["x"], "clearRect", [0.0, 0.0, env["vw"], env["vh"]])
	v_fade_543 = (J.max_([0.0, J.div(J.sub(env["T"], v_el_541), 0.6)]) if J.cmp(v_el_541, J.sub(env["T"], 0.6), ">") else 1.0)
	if J.cmp(v_el_541, 0.5, "<"):
		v_g_544 = J.mc(env["x"], "createRadialGradient", [env["ox"], env["oy"], 0.0, env["ox"], env["oy"], J.mul(160.0, env["sz"])])
		J.mc(v_g_544, "addColorStop", [0.0, ("rgba(255,200,90," + J.str((0.55 * (1.0 - J.div(v_el_541, 0.5)))) + ")")])
		J.mc(v_g_544, "addColorStop", [1.0, "rgba(255,120,30,0)"])
		var _t582 = env["x"]
		J.sp(_t582, "fillStyle", v_g_544)
		J.mc(env["x"], "fillRect", [0.0, 0.0, env["vw"], env["vh"]])
	for _t583 in J.iter(env["P"]):
		v_p_545 = _t583
		if J.cmp(v_el_541, J.gp(v_p_545, "delay"), "<"):
			continue
		var _t584 = J.mul(J.gp(v_p_545, "vx"), pow(J.num(0.35), J.num(v_dt_542)))
		J.sp(v_p_545, "vx", _t584)
		var _t585 = J.add(J.gp(v_p_545, "vy"), J.mul(J.mul(520.0, env["sz"]), v_dt_542))
		J.sp(v_p_545, "vy", _t585)
		var _t586 = J.gp(v_p_545, "term")
		v_term_546 = J.mul((_t586 if J.t(_t586) else 250.0), env["sz"])
		if J.cmp(J.gp(v_p_545, "vy"), v_term_546, ">"):
			var _t587 = J.add(J.gp(v_p_545, "vy"), (J.sub(v_term_546, J.gp(v_p_545, "vy")) * J.min_([1.0, J.mul(v_dt_542, 4.0)])))
			J.sp(v_p_545, "vy", _t587)
		var _t588 = J.add(J.gp(v_p_545, "sw"), J.mul(J.gp(v_p_545, "vs"), v_dt_542))
		J.sp(v_p_545, "sw", _t588)
		var _t589 = J.add(J.gp(v_p_545, "x"), J.mul(J.add(J.gp(v_p_545, "vx"), J.mul((sin(J.num(J.gp(v_p_545, "sw"))) * 70.0), env["sz"])), v_dt_542))
		J.sp(v_p_545, "x", _t589)
		var _t590 = J.add(J.gp(v_p_545, "y"), J.mul(J.gp(v_p_545, "vy"), v_dt_542))
		J.sp(v_p_545, "y", _t590)
		var _t591 = J.add(J.gp(v_p_545, "rot"), J.mul(J.gp(v_p_545, "vr"), v_dt_542))
		J.sp(v_p_545, "rot", _t591)
		var _t592 = J.add(J.gp(v_p_545, "fl"), J.mul(J.gp(v_p_545, "vf"), v_dt_542))
		J.sp(v_p_545, "fl", _t592)
		if J.cmp(J.gp(v_p_545, "y"), J.add(env["vh"], 40.0), "<"):
			var _t593 = env["paper"]
			J.cl(_t593, null, [v_p_545, v_fade_543])
	var _t594 = env["x"]
	J.sp(_t594, "globalCompositeOperation", "lighter")
	for _t595 in J.iter(env["S2"]):
		v_s_547 = _t595
		if J.cmp(v_el_541, J.gp(v_s_547, "d"), "<"):
			continue
		var _t596 = J.add(J.gp(v_s_547, "t"), v_dt_542)
		J.sp(v_s_547, "t", _t596)
		if J.cmp(J.gp(v_s_547, "t"), J.gp(v_s_547, "life"), ">"):
			continue
		var _t597 = J.add(J.gp(v_s_547, "vy"), J.mul(J.mul(600.0, env["sz"]), v_dt_542))
		J.sp(v_s_547, "vy", _t597)
		var _t598 = J.add(J.gp(v_s_547, "x"), J.mul(J.gp(v_s_547, "vx"), v_dt_542))
		J.sp(v_s_547, "x", _t598)
		var _t599 = J.add(J.gp(v_s_547, "y"), J.mul(J.gp(v_s_547, "vy"), v_dt_542))
		J.sp(v_s_547, "y", _t599)
		v_k_548 = (1.0 - J.div(J.gp(v_s_547, "t"), J.gp(v_s_547, "life")))
		v_r_549 = (2.0 + J.mul(3.0, v_k_548))
		var _t600 = env["x"]
		J.sp(_t600, "globalAlpha", v_k_548)
		var _t601 = env["x"]
		J.sp(_t601, "fillStyle", "#fff2b0")
		J.mc(env["x"], "beginPath", [])
		J.mc(env["x"], "moveTo", [J.gp(v_s_547, "x"), J.sub(J.gp(v_s_547, "y"), J.mul(v_r_549, 2.0))])
		J.mc(env["x"], "lineTo", [J.add(J.gp(v_s_547, "x"), J.mul(v_r_549, 0.5)), J.gp(v_s_547, "y")])
		J.mc(env["x"], "lineTo", [J.gp(v_s_547, "x"), J.add(J.gp(v_s_547, "y"), J.mul(v_r_549, 2.0))])
		J.mc(env["x"], "lineTo", [J.sub(J.gp(v_s_547, "x"), J.mul(v_r_549, 0.5)), J.gp(v_s_547, "y")])
		J.mc(env["x"], "closePath", [])
		J.mc(env["x"], "fill", [])
		J.mc(env["x"], "fillRect", [J.sub(J.gp(v_s_547, "x"), J.mul(v_r_549, 2.0)), J.sub(J.gp(v_s_547, "y"), 0.6), J.mul(v_r_549, 4.0), 1.2])
	var _t602 = env["x"]
	J.sp(_t602, "globalCompositeOperation", "source-over")
	var _t603 = env["x"]
	J.sp(_t603, "globalAlpha", 1.0)
	if J.cmp(v_el_541, env["T"], "<"):
		var _t604 = env["this"]
		var _t605 = J.F_requestAnimationFrame([env["step"]])
		J.sp(_t604, "raf", _t605)
	else:
		J.mc(env["cv"], "remove", [])
		var _t606 = env["this"]
		J.sp(_t606, "cv", null)
		var _t607 = env["this"]
		J.sp(_t607, "raf", 0.0)

func _f118(this_, a: Array, env):
	var v_N_508 = null; var v_R_510 = null; var v_V_518 = null; var v_r_519 = null; var v_fx_520 = null; var v_fy_521 = null; var v_e_522 = null; var v_i_523 = null; var v_burst_524 = null; var v_gold_525 = null; var v_w_526 = null; var v_p_527 = null; var v_ang_528 = null; var v_sp_529 = null; var v_i_530 = null
	var _s246 = {"__p": env, "this": null, "dpr": null, "vw": null, "vh": null, "cv": null, "x": null, "ox": null, "oy": null, "P": null, "sz": null, "S2": null, "T": null, "t0": null, "last": null, "paper": null, "step": null}
	_s246["this"] = this_
	if J.t(J.gp(_s246["this"], "raf")):
		J.F_cancelAnimationFrame([J.gp(_s246["this"], "raf")])
		if J.t(J.gp(_s246["this"], "cv")):
			J.mc(J.gp(_s246["this"], "cv"), "remove", [])
	var _t540 = J.gp(J.G.get("window"), "devicePixelRatio")
	var _t541 = J.gp(J.G.get("window"), "devicePixelRatio")
	_s246["dpr"] = J.min_([2.0, (_t541 if J.t(_t541) else 1.0)])
	_s246["vw"] = J.gp(J.G.get("window"), "innerWidth")
	_s246["vh"] = J.gp(J.G.get("window"), "innerHeight")
	_s246["cv"] = J.S_document_("createElement", ["canvas"])
	var _t542 = _s246["cv"]
	J.sp(_t542, "id", "jossfx")
	var _t543 = _s246["cv"]
	var _t544 = J.round(J.num(J.mul(_s246["vw"], _s246["dpr"])))
	J.sp(_t543, "width", _t544)
	var _t545 = _s246["cv"]
	var _t546 = J.round(J.num(J.mul(_s246["vh"], _s246["dpr"])))
	J.sp(_t545, "height", _t546)
	var _t547 = J.gp(_s246["cv"], "style")
	var _t548 = ("position:fixed;left:0;top:0;width:" + J.str(_s246["vw"]) + "px;height:" + J.str(_s246["vh"]) + "px;pointer-events:none;z-index:65")
	J.sp(_t547, "cssText", _t548)
	var _t549 = J.gp(J.G.get("document"), "body")
	J.mc(_t549, "appendChild", [_s246["cv"]])
	var _t550 = _s246["this"]
	var _t551 = _s246["cv"]
	J.sp(_t550, "cv", _t551)
	_s246["x"] = J.mc(_s246["cv"], "getContext", ["2d"])
	_s246["ox"] = J.mul(_s246["vw"], 0.8)
	_s246["oy"] = J.mul(_s246["vh"], 0.55)
	v_V_518 = J.G.get("Village")
	v_r_519 = J.mc(J.gp(v_V_518, "cvs"), "getBoundingClientRect", [])
	var _t552 = J.gp(J.G.get("POS"), "furnace")
	var _t553 = J.gp(_t552, 0.0)
	v_fx_520 = _t553
	var _t554 = J.gp(_t552, 1.0)
	v_fy_521 = _t554
	var _t555 = J.add(J.gp(v_r_519, "left"), J.mul(v_fx_520, J.gp(v_V_518, "scale")))
	_s246["ox"] = _t555
	var _t556 = J.add(J.gp(v_r_519, "top"), J.mul(J.sub(J.sub(v_fy_521, 40.0), J.gp(v_V_518, "camY")), J.gp(v_V_518, "scale")))
	_s246["oy"] = _t556
	var _t557 = J.max_([30.0, J.min_([J.sub(_s246["vw"], 30.0), _s246["ox"]])])
	_s246["ox"] = _t557
	var _t558 = J.max_([J.mul(_s246["vh"], 0.25), J.min_([J.mul(_s246["vh"], 0.8), _s246["oy"]])])
	_s246["oy"] = _t558
	v_N_508 = (140.0 if J.cmp(_s246["vw"], 500.0, "<") else 170.0)
	_s246["P"] = []
	v_R_510 = J.gp(J.G.get("Math"), "random")
	_s246["sz"] = J.div(J.max_([_s246["vw"], _s246["vh"]]), 844.0)
	v_i_523 = 0.0
	while true:
		if not J.cmp(v_i_523, v_N_508, "<"): break
		v_burst_524 = J.cmp(v_i_523, J.mul(v_N_508, 0.55), "<")
		v_gold_525 = J.cmp(J.cl(v_R_510, null, []), 0.6, "<")
		v_w_526 = J.mul((16.0 + J.mul(J.cl(v_R_510, null, []), 12.0)), _s246["sz"])
		v_p_527 = {"gold": v_gold_525, "w": v_w_526, "h": J.mul(v_w_526, (0.72 + J.mul(J.cl(v_R_510, null, []), 0.14))), "rot": J.mul(J.cl(v_R_510, null, []), 6.3), "vr": (J.sub(J.cl(v_R_510, null, []), 0.5) * 7.0), "fl": J.mul(J.cl(v_R_510, null, []), 6.3), "vf": (4.0 + J.mul(J.cl(v_R_510, null, []), 8.0)), "sw": J.mul(J.cl(v_R_510, null, []), 6.3), "vs": (1.5 + J.mul(J.cl(v_R_510, null, []), 2.5)), "delay": 0.0}
		if J.t(v_burst_524):
			v_ang_528 = (J.div((-PI), 2.0) + (J.sub(J.cl(v_R_510, null, []), 0.5) * 1.9))
			v_sp_529 = J.mul((420.0 + J.mul(J.cl(v_R_510, null, []), 520.0)), _s246["sz"])
			var _t559 = _s246["ox"]
			J.sp(v_p_527, "x", _t559)
			var _t560 = _s246["oy"]
			J.sp(v_p_527, "y", _t560)
			var _t561 = J.mul(cos(J.num(v_ang_528)), v_sp_529)
			J.sp(v_p_527, "vx", _t561)
			var _t562 = J.mul(sin(J.num(v_ang_528)), v_sp_529)
			J.sp(v_p_527, "vy", _t562)
			var _t563 = J.mul(J.cl(v_R_510, null, []), 0.3)
			J.sp(v_p_527, "delay", _t563)
		else:
			var _t564 = J.mul(J.cl(v_R_510, null, []), _s246["vw"])
			J.sp(v_p_527, "x", _t564)
			var _t565 = ((-30.0) - (J.mul(J.cl(v_R_510, null, []), _s246["vh"]) * 0.25))
			J.sp(v_p_527, "y", _t565)
			var _t566 = (J.sub(J.cl(v_R_510, null, []), 0.5) * 60.0)
			J.sp(v_p_527, "vx", _t566)
			var _t567 = (320.0 + J.mul(J.cl(v_R_510, null, []), 160.0))
			J.sp(v_p_527, "vy", _t567)
			var _t568 = J.mul(J.cl(v_R_510, null, []), 0.5)
			J.sp(v_p_527, "delay", _t568)
		var _t569 = (300.0 + J.mul(J.cl(v_R_510, null, []), 160.0))
		J.sp(v_p_527, "term", _t569)
		J.mc(_s246["P"], "push", [v_p_527])
		v_i_523 = J.num(v_i_523) + 1.0
	_s246["S2"] = []
	v_i_530 = 0.0
	while true:
		if not J.cmp(v_i_530, 46.0, "<"): break
		J.mc(_s246["S2"], "push", [{"x": J.add(_s246["ox"], (J.sub(J.cl(v_R_510, null, []), 0.5) * 60.0)), "y": _s246["oy"], "vx": J.mul((J.sub(J.cl(v_R_510, null, []), 0.5) * 500.0), _s246["sz"]), "vy": J.mul((-(200.0 + J.mul(J.cl(v_R_510, null, []), 700.0))), _s246["sz"]), "life": (0.6 + J.mul(J.cl(v_R_510, null, []), 0.9)), "t": 0.0, "d": J.mul(J.cl(v_R_510, null, []), 0.5)}])
		v_i_530 = J.num(v_i_530) + 1.0
	_s246["T"] = 2.8
	_s246["t0"] = J.S_performance_("now", [])
	_s246["last"] = _s246["t0"]
	_s246["paper"] = Callable(self, "_f119").bind(_s246)
	_s246["step"] = Callable(self, "_f120").bind(_s246)
	var _t608 = _s246["this"]
	var _t609 = J.F_requestAnimationFrame([_s246["step"]])
	J.sp(_t608, "raf", _t609)

func _f121(this_, a: Array, env):
	var v_x_552 = null; var v_y_553 = null; var v_text_554 = null; var v_col_555 = null
	v_x_552 = J.arg(a, 0)
	v_y_553 = J.arg(a, 1)
	v_text_554 = J.arg(a, 2)
	v_col_555 = J.arg(a, 3)
	var _t610 = J.gp(J.G.get("Village"), "floats")
	J.mc(_t610, "push", [{"x": v_x_552, "y": v_y_553, "text": v_text_554, "col": (v_col_555 if J.t(v_col_555) else "#fff"), "t": 0.0, "life": 1.6}])

func _f123(this_, a: Array, env):
	var _t616 = J.gp(env["d"], "classList")
	return J.mc(_t616, "add", ["out"])

func _f124(this_, a: Array, env):
	return J.mc(env["d"], "remove", [])

func _f122(this_, a: Array, env):
	var v_html_558 = null; var v_box_559 = null
	var _s269 = {"__p": env, "d": null}
	v_html_558 = J.arg(a, 0)
	var _t611 = J.G.get("$")
	v_box_559 = J.cl(_t611, null, ["#toasts"])
	while true:
		if not (J.len(J.gp(v_box_559, "children")) >= 3.0): break
		J.mc(J.gp(v_box_559, "firstChild"), "remove", [])
	_s269["d"] = J.S_document_("createElement", ["div"])
	var _t612 = _s269["d"]
	J.sp(_t612, "className", "toast")
	var _t613 = _s269["d"]
	J.sp(_t613, "innerHTML", v_html_558)
	var _t614 = J.G.get("$")
	var _t615 = J.cl(_t614, null, ["#toasts"])
	J.mc(_t615, "appendChild", [_s269["d"]])
	J.F_setTimeout([Callable(self, "_f123").bind(_s269), 2600.0])
	J.F_setTimeout([Callable(self, "_f124").bind(_s269), 3200.0])

func _f125(this_, a: Array, env):
	var v_text_563 = null; var v_d_564 = null
	v_text_563 = J.arg(a, 0)
	var _t617 = J.G.get("$")
	v_d_564 = J.cl(_t617, null, ["#banner"])
	J.sp(v_d_564, "textContent", v_text_563)
	var _t618 = J.gp(v_d_564, "classList")
	J.mc(_t618, "remove", ["show"])
	J.nop(J.gp(v_d_564, "offsetWidth"))
	var _t619 = J.gp(v_d_564, "classList")
	J.mc(_t619, "add", ["show"])

func _f126(this_, a: Array, env):
	var v_kind_567 = null; var v_pool_568 = null; var v_i_569 = null; var v_d_570 = null; var v_c_571 = null; var v_ic_572 = null
	v_kind_567 = J.arg(a, 0)
	v_pool_568 = (J.G.get("PRAISE_KIND") if J.t(J.gp(J.G.get("S"), "ended")) else (J.G.get("PRAISE_CHOP") if J.seq(v_kind_567, "chop") else (J.G.get("PRAISE_RICE") if J.seq(v_kind_567, "rice") else J.G.get("PRAISE_CRAFT"))))
	v_i_569 = null
	var _t620 = true
	while true:
		if not _t620:
			var _t621 = (J.len(v_pool_568) > 1.0)
			if not (J.seq(v_i_569, J.gp(J.gp(this_, "lastPraise"), v_kind_567)) if _t621 else _t621): break
		_t620 = false
		var _t622 = floor(J.num((randf() * J.len(v_pool_568))))
		v_i_569 = _t622
	var _t623 = J.gp(this_, "lastPraise")
	J.sp(_t623, v_kind_567, v_i_569)
	var _t624 = J.G.get("$")
	v_d_570 = J.cl(_t624, null, ["#praise"])
	var _t625 = ("<canvas></canvas><span>" + J.str(J.gp(v_pool_568, v_i_569)) + "</span>")
	J.sp(v_d_570, "innerHTML", _t625)
	v_c_571 = J.mc(v_d_570, "querySelector", ["canvas"])
	v_ic_572 = J.mc(J.G.get("ART"), "sysIcon", [30.0])
	var _t626 = J.gp(v_ic_572, "width")
	J.sp(v_c_571, "width", _t626)
	var _t627 = J.gp(v_ic_572, "height")
	J.sp(v_c_571, "height", _t627)
	var _t628 = J.gp(v_c_571, "style")
	J.sp(_t628, "width", "30px")
	var _t629 = J.gp(v_c_571, "style")
	J.sp(_t629, "height", "30px")
	var _t630 = J.mc(v_c_571, "getContext", ["2d"])
	J.mc(_t630, "drawImage", [v_ic_572, 0.0, 0.0])
	var _t631 = J.gp(v_d_570, "classList")
	J.mc(_t631, "remove", ["show"])
	J.nop(J.gp(v_d_570, "offsetWidth"))
	var _t632 = J.gp(v_d_570, "classList")
	J.mc(_t632, "add", ["show"])
	J.mc(J.G.get("Sound"), "play", ["praise"])
	var _t633 = J.cmp(J.gp(J.G.get("S"), "lv"), 3.0, ">=")
	if ((randf() < 0.04) if _t633 else _t633):
		var _t634 = J.gp(J.G.get("S"), "chests")
		J.sp(_t634, "g", J.num(J.gp(_t634, "g")) + 1.0)
		J.mc(J.G.get("Fx"), "toast", ["系統太滿意了，掉落一個<b>綠箱</b>！"])

func _f127(this_, a: Array, env):
	var _t635 = (not (not J.t(J.gp(this_, "cur"))))
	return (_t635 if _t635 else (J.len(J.gp(this_, "q")) > 0.0))

func _f128(this_, a: Array, env):
	var v_sc_577 = null; var v_cb_578 = null
	v_sc_577 = J.arg(a, 0)
	v_cb_578 = J.arg(a, 1)
	var _t636 = J.gp(this_, "q")
	J.mc(_t636, "push", [{"sc": v_sc_577, "cb": v_cb_578}])
	if (not J.t(J.gp(this_, "cur"))):
		J.mc(this_, "next", [])

func _f129(this_, a: Array, env):
	var v_it_581 = null; var v_sc_582 = null; var v_f_583 = null
	var _t637 = J.gp(this_, "cur")
	if J.t((J.gp(J.gp(this_, "cur"), "cb") if J.t(_t637) else _t637)):
		v_f_583 = J.gp(J.gp(this_, "cur"), "cb")
		var _t638 = J.gp(this_, "cur")
		J.sp(_t638, "cb", null)
		J.cl(v_f_583, null, [])
	v_it_581 = J.mc(J.gp(this_, "q"), "shift", [])
	if (not J.t(v_it_581)):
		var _t639 = this_
		J.sp(_t639, "cur", null)
		var _t640 = J.G.get("$")
		var _t641 = J.cl(_t640, null, ["#dlg"])
		J.sp(_t641, "className", "")
		var _t642 = J.G.get("$")
		var _t643 = J.cl(_t642, null, ["#dlg"])
		J.sp(_t643, "innerHTML", "")
		var _t644 = (not J.t(J.gp(J.G.get("Battle"), "active")))
		if ((not J.t(J.gp(J.G.get("Phone"), "on"))) if _t644 else _t644):
			J.mc(J.G.get("Sound"), "setMode", ["village"])
		J.mc(J.G.get("UI"), "refresh", [])
		J.mc(J.G.get("Quest"), "check", [])
		J.cl(J.G.get("save"), null, [])
		return null
	v_sc_582 = (J.gp(J.G.get("SCENES"), J.gp(v_it_581, "sc")) if J.seq(J.typeof_(J.gp(v_it_581, "sc")), "string") else J.gp(v_it_581, "sc"))
	if J.seq(J.typeof_(J.gp(v_it_581, "sc")), "string"):
		var _t645 = J.gp(J.G.get("S"), "seen")
		var _t646 = J.gp(v_it_581, "sc")
		J.sp(_t645, _t646, true)
	J.F_clearTimeout([J.gp(this_, "chatT")])
	var _t647 = this_
	J.sp(_t647, "chatWait", null)
	var _t648 = this_
	J.sp(_t648, "chatFast", null)
	var _t649 = this_
	J.sp(_t649, "lastMine", null)
	var _t650 = this_
	var _t651 = {"sc": v_sc_582, "cb": J.gp(v_it_581, "cb"), "id": (J.gp(v_it_581, "sc") if J.seq(J.typeof_(J.gp(v_it_581, "sc")), "string") else null)}
	J.sp(_t650, "cur", _t651)
	var _t652 = this_
	J.sp(_t652, "li", 0.0)
	if (not J.t(J.gp(J.G.get("Battle"), "active"))):
		J.mc(J.G.get("Sound"), "setMode", [("office" if J.seq(J.gp(J.gp(this_, "cur"), "id"), "prologue_chat") else "story")])
	J.mc(this_, "render", [true])

func _f131(this_, a: Array, env):
	var v_e_589 = null
	v_e_589 = J.arg(a, 0)
	var _t658 = J.gp(v_e_589, "target")
	if J.t(J.mc(_t658, "closest", [".skip"])):
		J.mc(env["this"], "skipScene", [])
		return null
	J.mc(env["this"], "advance", [v_e_589])

func _f132(this_, a: Array, env):
	var v_l_590 = null
	v_l_590 = J.arg(a, 0)
	return J.gp(v_l_590, 0.0)

func _f133(this_, a: Array, env):
	var v_n_591 = null
	v_n_591 = J.arg(a, 0)
	var _t663 = J.gp(J.G.get("SPEAKER_ART"), v_n_591)
	return ((not J.seq(v_n_591, "黑白無常")) if J.t(_t663) else _t663)

func _f130(this_, a: Array, env):
	var v_first_586 = null; var v_sc_587 = null; var v_box_588 = null
	var _s281 = {"__p": env, "this": null}
	_s281["this"] = this_
	v_first_586 = J.arg(a, 0)
	var _t653 = J.gp(_s281["this"], "cur")
	var _t654 = J.gp(_t653, "sc")
	v_sc_587 = _t654
	var _t655 = J.G.get("$")
	v_box_588 = J.cl(_t655, null, ["#dlg"])
	var _t656 = J.add("on st-", J.gp(v_sc_587, "style"))
	J.sp(v_box_588, "className", _t656)
	if J.t(v_first_586):
		var _t657 = J.mc(_s281["this"], "frame", [v_sc_587])
		J.sp(v_box_588, "innerHTML", _t657)
		var _t659 = Callable(self, "_f131").bind(_s281)
		J.sp(v_box_588, "onclick", _t659)
		if J.seq(J.gp(v_sc_587, "style"), "talk"):
			var _t660 = _s281["this"]
			var _t661 = J.gp(v_sc_587, "lines")
			var _t662 = J.mc(_t661, "map", [Callable(self, "_f132").bind(_s281)])
			var _t664 = J.spread([J.SP(J.new_("Set", [J.mc(_t662, "filter", [Callable(self, "_f133").bind(_s281)])]))])
			var _t665 = J.mc(_t664, "slice", [0.0, 6.0])
			J.sp(_t660, "actors", _t665)
			J.mc(_s281["this"], "drawStage", [])
	J.mc(_s281["this"], "showLine", [])

func _f134(this_, a: Array, env):
	var v_sc_594 = null; var v_sk_595 = null
	v_sc_594 = J.arg(a, 0)
	v_sk_595 = "<button class=\"skip\">跳過 ▸▸</button>"
	var _t666 = J.gp(v_sc_594, "style")
	var _t667 = -1
	var _t668 = false
	if _t667 == -1 and J.seq(_t666, "chat"): _t667 = 0
	if _t667 == -1 and J.seq(_t666, "sys"): _t667 = 1
	if _t667 == -1 and J.seq(_t666, "news"): _t667 = 2
	if _t667 == -1 and J.seq(_t666, "notice"): _t667 = 3
	if _t667 == -1 and J.seq(_t666, "radio"): _t667 = 4
	if _t667 == -1 and J.seq(_t666, "report"): _t667 = 5
	if _t667 == -1 and J.seq(_t666, "mail"): _t667 = 6
	if _t667 == -1 and J.seq(_t666, "letter"): _t667 = 7
	if _t667 == -1 and J.seq(_t666, "narr"): _t667 = 8
	if _t667 == -1: _t667 = 9
	while true:
		if _t667 <= 0 and _t667 >= 0:
			var _t669 = J.G.get("waStatus")
			var _t672 = J.cl(_t669, null, [("02:13" if J.seq(J.gp(J.gp(this_, "cur"), "id"), "prologue_chat") else J.cl(J.G.get("nowHM"), null, [])), ("3%" if J.seq(J.gp(J.gp(this_, "cur"), "id"), "prologue_chat") else "∞"), J.seq(J.gp(J.gp(this_, "cur"), "id"), "prologue_chat")])
			var _t673 = J.gp(J.G.get("ICON"), "back")
			var _t670 = J.G.get("waAvatar")
			var _t671 = J.gp(v_sc_594, "av")
			var _t675 = J.cl(_t670, null, [(_t671 if J.t(_t671) else ["?", "#555"]), 38.0])
			var _t676 = J.gp(v_sc_594, "title")
			var _t674 = J.gp(v_sc_594, "group")
			return (J.str(v_sk_595) + "<div class=\"wa wa-chat\">" + J.str(_t672) + "<div class=\"wa-head\"><span class=\"wa-back\">" + J.str(_t673) + "</span>" + J.str(_t675) + "<div class=\"wa-who\"><b>" + J.str(_t676) + "</b><small class=\"wa-sub\">" + J.str((_t674 if J.t(_t674) else "在線上")) + "</small></div><span class=\"ic\">" + J.str(J.gp(J.G.get("ICON"), "video")) + "</span><span class=\"ic\">" + J.str(J.gp(J.G.get("ICON"), "call")) + "</span><span class=\"ic\">" + J.str(J.gp(J.G.get("ICON"), "dots")) + "</span></div><div class=\"wa-body\"><div class=\"wa-lock\">🔒 訊息和通話皆已端對端加密。</div><div class=\"wa-day\">今天</div></div><div class=\"wa-input\"><div class=\"wa-field\">" + J.str(J.gp(J.G.get("ICON"), "smile")) + "<span class=\"wa-txt\">輸入訊息</span>" + J.str(J.gp(J.G.get("ICON"), "clip")) + "</div><button class=\"wa-send\">" + J.str(J.gp(J.G.get("ICON"), "mic")) + "</button></div><div class=\"wa-crack\"></div></div><div class=\"tap\" style=\"display:none\">點擊繼續</div>")
		if _t667 <= 1 and _t667 >= 0:
			return (J.str(v_sk_595) + "<div class=\"syswin\"><div class=\"sys-h\">陰司 KPI 系統</div><div class=\"sys-body\"></div></div><div class=\"tap\">點擊繼續</div>")
		if _t667 <= 2 and _t667 >= 0:
			return (J.str(v_sk_595) + "<div class=\"tv\"><div class=\"tv-screen\"><div class=\"tv-logo\">陰間新聞台 <i>LIVE</i></div><canvas class=\"anchor\" width=\"160\" height=\"160\"></canvas><div class=\"tv-sub\"></div></div><div class=\"tv-ticker\"><span>快訊：鬼門將開　落魄村徵求打工鬼　包吃（包子）　詳情請洽陰司 KPI 系統</span></div></div><div class=\"tap\">點擊繼續</div>")
		if _t667 <= 3 and _t667 >= 0:
			return (J.str(v_sk_595) + "<div class=\"notice\"><div class=\"nt-h\">" + J.str(J.gp(v_sc_594, "title")) + "</div><div class=\"nt-body\"></div><div class=\"nt-stamp\">湘西</div></div><div class=\"tap\">點擊繼續</div>")
		if _t667 <= 4 and _t667 >= 0:
			return (J.str(v_sk_595) + "<div class=\"radio\"><div class=\"rd-h\">" + J.str(J.gp(v_sc_594, "title")) + "</div><div class=\"rd-wave\"></div><div class=\"rd-body\"></div></div><div class=\"tap\">點擊繼續</div>")
		if _t667 <= 5 and _t667 >= 0:
			return (J.str(v_sk_595) + "<div class=\"term\"><div class=\"tm-h\">&gt; " + J.str(J.gp(v_sc_594, "title")) + "</div><div class=\"tm-body\"></div></div><div class=\"tap\">點擊繼續</div>")
		if _t667 <= 6 and _t667 >= 0:
			return (J.str(v_sk_595) + "<div class=\"mail\"><div class=\"ml-h\">" + J.str(J.gp(v_sc_594, "title")) + "</div><div class=\"ml-body\"></div></div><div class=\"tap\">點擊繼續</div>")
		if _t667 <= 7 and _t667 >= 0:
			return (J.str(v_sk_595) + "<div class=\"letterwrap\"><div class=\"letter-body\"></div></div><div class=\"tap\">點擊繼續</div>")
		if _t667 <= 8 and _t667 >= 0:
			return (J.str(v_sk_595) + "<div class=\"narr-body\"></div><div class=\"tap\">點擊繼續</div>")
		if _t667 <= 9 and _t667 >= 0:
			return (J.str(v_sk_595) + "<canvas class=\"stage\"></canvas><div class=\"talkbox\"><canvas class=\"pt\" width=\"120\" height=\"120\"></canvas><div class=\"nm\"></div><div class=\"tx\"></div><div class=\"nx\">▼</div></div>")
		break

func _f136(this_, a: Array, env):
	var v_a_609 = null; var v_i_610 = null; var v_x_611 = null; var v_y_612 = null; var v_base_613 = null; var v_on_614 = null; var v_type_615 = null; var v_sid_616 = null
	v_a_609 = J.arg(a, 0)
	v_i_610 = J.arg(a, 1)
	v_x_611 = J.mul(env["w"], (0.5 if J.seq(env["n"], 1.0) else (0.16 + J.div(J.mul(0.68, v_i_610), J.max_([1.0, J.sub(env["n"], 1.0)])))))
	v_y_612 = (J.mul(env["h"], 0.66) + ((J.mod(v_i_610, 2.0) * 18.0) if J.cmp(env["n"], 3.0, ">") else 0.0))
	v_base_613 = (3.1 if J.cmp(env["n"], 2.0, "<=") else (2.7 if J.seq(env["n"], 3.0) else (2.3 if J.seq(env["n"], 4.0) else 1.9)))
	var _t688 = J.seq(v_a_609, env["speaker"])
	if not J.t(_t688):
		var _t687 = J.seq(env["speaker"], "黑白無常")
		if J.t(_t687):
			var _t686 = J.seq(v_a_609, "白無常")
			_t687 = (_t686 if _t686 else J.seq(v_a_609, "黑無常"))
		_t688 = _t687
	v_on_614 = _t688
	v_type_615 = J.gp(J.G.get("SPEAKER_ART"), v_a_609)
	var _t689 = J.gp(J.gp(env["this"], "cur"), "id")
	v_sid_616 = (_t689 if J.t(_t689) else "")
	var _t697 = env["ctx"]
	var _t698 = J.add(v_y_612, (0.0 if J.t(v_on_614) else 6.0))
	var _t699 = (v_base_613 if J.t(v_on_614) else J.mul(v_base_613, 0.9))
	var _t693 = J.cmp(v_x_611, J.div(env["w"], 2.0), ">")
	var _t694 = (1.0 if J.t(v_on_614) else 0.45)
	var _t695 = (not J.seq(v_sid_616, "ch4_boss"))
	var _t696 = (not J.seq(v_sid_616, "ch5_intro2"))
	var _t690 = J.mc(J.re("boss", ""), "test", [v_sid_616])
	var _t691 = ((not J.seq(v_a_609, "阿福")) if J.t(_t690) else _t690)
	var _t692 = ((not J.seq(v_a_609, "小紙")) if J.t(_t691) else _t691)
	J.mc(J.G.get("ART"), "drawChar", [_t697, v_type_615, v_x_611, _t698, _t699, {"t": 0.3, "flip": _t693, "alpha": _t694, "tamed": _t695, "untied": _t696, "enemy": (v_on_614 if J.t(_t692) else _t692)}])

func _f135(this_, a: Array, env):
	var v_box_598 = null; var v_c_599 = null; var v_r_600 = null; var v_dpr_601 = null; var v_bg_605 = null; var v_g_608 = null
	var _s290 = {"__p": env, "this": null, "ctx": null, "w": null, "h": null, "n": null, "speaker": null}
	_s290["this"] = this_
	var _t677 = J.G.get("$")
	v_box_598 = J.cl(_t677, null, ["#dlg"])
	v_c_599 = J.mc(v_box_598, "querySelector", ["canvas.stage"])
	if (not J.t(v_c_599)):
		return null
	v_r_600 = J.mc(v_box_598, "getBoundingClientRect", [])
	var _t678 = J.gp(J.G.get("window"), "devicePixelRatio")
	var _t679 = J.gp(J.G.get("window"), "devicePixelRatio")
	v_dpr_601 = J.min_([2.0, (_t679 if J.t(_t679) else 1.0)])
	var _t680 = J.mul(J.gp(v_r_600, "width"), v_dpr_601)
	J.sp(v_c_599, "width", _t680)
	var _t681 = J.mul(J.gp(v_r_600, "height"), v_dpr_601)
	J.sp(v_c_599, "height", _t681)
	_s290["ctx"] = J.mc(v_c_599, "getContext", ["2d"])
	J.mc(_s290["ctx"], "scale", [v_dpr_601, v_dpr_601])
	_s290["w"] = J.gp(v_r_600, "width")
	_s290["h"] = J.gp(v_r_600, "height")
	var _t682 = J.gp(J.gp(J.gp(_s290["this"], "cur"), "sc"), "bg")
	v_bg_605 = (_t682 if J.t(_t682) else "village")
	var _t683 = J.G.get("paintBg")
	J.cl(_t683, null, [_s290["ctx"], _s290["w"], _s290["h"], v_bg_605, 0.0])
	_s290["n"] = J.len(J.gp(_s290["this"], "actors"))
	_s290["speaker"] = (J.gp(J.gp(J.gp(J.gp(J.gp(_s290["this"], "cur"), "sc"), "lines"), J.gp(_s290["this"], "li")), 0.0) if J.t(J.gp(J.gp(J.gp(J.gp(_s290["this"], "cur"), "sc"), "lines"), J.gp(_s290["this"], "li"))) else "")
	if J.t(J.gp(J.gp(J.gp(_s290["this"], "cur"), "sc"), "mic")):
		v_g_608 = J.mc(_s290["ctx"], "createRadialGradient", [J.mul(_s290["w"], 0.5), J.mul(_s290["h"], 0.62), 10.0, J.mul(_s290["w"], 0.5), J.mul(_s290["h"], 0.62), J.mul(_s290["w"], 0.55)])
		J.mc(v_g_608, "addColorStop", [0.0, "rgba(255,236,190,.28)"])
		J.mc(v_g_608, "addColorStop", [1.0, "rgba(0,0,0,.55)"])
		var _t684 = _s290["ctx"]
		J.sp(_t684, "fillStyle", v_g_608)
		J.mc(_s290["ctx"], "fillRect", [0.0, 0.0, _s290["w"], _s290["h"]])
	var _t685 = J.gp(_s290["this"], "actors")
	J.mc(_t685, "forEach", [Callable(self, "_f136").bind(_s290)])

func _f139(this_, a: Array, env):
	J.F_clearInterval([J.gp(env["__p"]["this"], "timer")])
	var _t708 = env["el"]
	var _t709 = env["__p"]["text"]
	J.sp(_t708, "textContent", _t709)
	var _t710 = env["__p"]["this"]
	J.sp(_t710, "typing", false)
	if J.t(env["cb"]):
		J.cl(env["cb"], null, [])

func _f140(this_, a: Array, env):
	env["i"] = J.num(env["i"]) + 1.0
	var _t713 = env["el"]
	var _t714 = J.mc(env["__p"]["text"], "slice", [0.0, env["i"]])
	J.sp(_t713, "textContent", _t714)
	if J.cmp(env["i"], J.len(env["__p"]["text"]), ">="):
		J.F_clearInterval([J.gp(env["__p"]["this"], "timer")])
		var _t715 = env["__p"]["this"]
		J.sp(_t715, "typing", false)
		if J.t(env["cb"]):
			J.cl(env["cb"], null, [])

func _f138(this_, a: Array, env):
	var _s296 = {"__p": env, "el": null, "cb": null, "i": null}
	_s296["el"] = J.arg(a, 0)
	_s296["cb"] = J.arg(a, 1)
	var _t706 = _s296["__p"]["this"]
	J.sp(_t706, "typing", true)
	_s296["i"] = 0.0
	J.F_clearInterval([J.gp(_s296["__p"]["this"], "timer")])
	var _t707 = _s296["__p"]["this"]
	var _t711 = Callable(self, "_f139").bind(_s296)
	J.sp(_t707, "full", _t711)
	var _t712 = _s296["__p"]["this"]
	var _t716 = J.F_setInterval([Callable(self, "_f140").bind(_s296), 28.0])
	J.sp(_t712, "timer", _t716)

func _f141(this_, a: Array, env):
	var v_container_631 = null; var v_cls_632 = null; var v_inner_633 = null; var v_d_634 = null
	v_container_631 = J.arg(a, 0)
	v_cls_632 = J.arg(a, 1)
	v_inner_633 = J.arg(a, 2)
	v_d_634 = J.S_document_("createElement", ["div"])
	J.sp(v_d_634, "className", v_cls_632)
	J.sp(v_d_634, "innerHTML", v_inner_633)
	J.mc(v_container_631, "appendChild", [v_d_634])
	var _t717 = J.gp(v_container_631, "scrollHeight")
	J.sp(v_container_631, "scrollTop", _t717)
	return v_d_634

func _f137(this_, a: Array, env):
	var v_sc_619 = null; var v_who_620 = null; var v_raw_621 = null; var v_box_622 = null; var v_time_624 = null; var v_typeInto_625 = null; var v_add_626 = null; var v_m_627 = null; var v_d_635 = null; var v_s_636 = null; var v_d_637 = null; var v_d_638 = null; var v_d_639 = null; var v_d_640 = null; var v_d_641 = null; var v_d_642 = null; var v_nm_643 = null; var v_tx_644 = null; var v_pt_645 = null; var v_pc_646 = null; var v_art_647 = null; var v_sid_648 = null
	var _s293 = {"__p": env, "this": null, "text": null}
	_s293["this"] = this_
	var _t700 = J.gp(_s293["this"], "cur")
	var _t701 = J.gp(_t700, "sc")
	v_sc_619 = _t701
	var _t702 = J.gp(J.gp(v_sc_619, "lines"), J.gp(_s293["this"], "li"))
	var _t703 = J.gp(_t702, 0.0)
	v_who_620 = _t703
	var _t704 = J.gp(_t702, 1.0)
	v_raw_621 = _t704
	var _t705 = J.G.get("$")
	v_box_622 = J.cl(_t705, null, ["#dlg"])
	_s293["text"] = v_raw_621
	v_time_624 = ""
	if J.seq(J.gp(v_sc_619, "style"), "chat"):
		v_m_627 = J.mc(v_raw_621, "match", [J.re("^(\\d\\d:\\d\\d)\\|(.*)$", "")])
		if J.t(v_m_627):
			v_time_624 = J.gp(v_m_627, 1.0)
			_s293["text"] = J.gp(v_m_627, 2.0)
	v_typeInto_625 = Callable(self, "_f138").bind(_s293)
	v_add_626 = Callable(self, "_f141").bind(_s293)
	var _t718 = J.gp(v_sc_619, "style")
	var _t719 = -1
	var _t720 = false
	if _t719 == -1 and J.seq(_t718, "chat"): _t719 = 0
	if _t719 == -1 and J.seq(_t718, "sys"): _t719 = 1
	if _t719 == -1 and J.seq(_t718, "news"): _t719 = 2
	if _t719 == -1 and J.seq(_t718, "notice"): _t719 = 3
	if _t719 == -1 and J.seq(_t718, "radio"): _t719 = 4
	if _t719 == -1 and J.seq(_t718, "report"): _t719 = 5
	if _t719 == -1 and J.seq(_t718, "mail"): _t719 = 6
	if _t719 == -1 and J.seq(_t718, "letter"): _t719 = 7
	if _t719 == -1 and J.seq(_t718, "narr"): _t719 = 8
	if _t719 == -1: _t719 = 9
	while true:
		if _t719 <= 0 and _t719 >= 0:
			J.mc(_s293["this"], "chatLine", [v_who_620, _s293["text"], v_time_624])
			break
		if _t719 <= 1 and _t719 >= 0:
			v_d_635 = J.cl(v_add_626, null, [J.mc(v_box_622, "querySelector", [".sys-body"]), ("sl " + ("s" if J.seq(v_who_620, "系統") else ("n" if J.seq(v_who_620, "旁白") else "u"))), (("<b>【系統】</b>" if J.seq(v_who_620, "系統") else ("" if J.seq(v_who_620, "旁白") else ("<b>" + J.str(v_who_620) + "：</b>"))) + "<span class=\"tt\"></span>")])
			J.cl(v_typeInto_625, null, [J.mc(v_d_635, "querySelector", [".tt"])])
			break
		if _t719 <= 2 and _t719 >= 0:
			v_s_636 = J.mc(v_box_622, "querySelector", [".tv-sub"])
			var _t721 = "<span class=\"tt\"></span>"
			J.sp(v_s_636, "innerHTML", _t721)
			J.mc(_s293["this"], "drawAnchor", [])
			J.cl(v_typeInto_625, null, [J.mc(v_s_636, "querySelector", [".tt"])])
			break
		if _t719 <= 3 and _t719 >= 0:
			v_d_637 = J.cl(v_add_626, null, [J.mc(v_box_622, "querySelector", [".nt-body"]), "np", "<span class=\"tt\"></span>"])
			J.cl(v_typeInto_625, null, [J.mc(v_d_637, "querySelector", [".tt"])])
			break
		if _t719 <= 4 and _t719 >= 0:
			v_d_638 = J.cl(v_add_626, null, [J.mc(v_box_622, "querySelector", [".rd-body"]), ("rl " + ("dj" if J.seq(v_who_620, "DJ") else "call")), ("<b>" + ("DJ" if J.seq(v_who_620, "DJ") else J.add("來電・", v_who_620)) + "</b><span class=\"tt\"></span>")])
			J.cl(v_typeInto_625, null, [J.mc(v_d_638, "querySelector", [".tt"])])
			break
		if _t719 <= 5 and _t719 >= 0:
			v_d_639 = J.cl(v_add_626, null, [J.mc(v_box_622, "querySelector", [".tm-body"]), "tl", ("<b>[" + J.str(v_who_620) + "]</b> <span class=\"tt\"></span>")])
			J.cl(v_typeInto_625, null, [J.mc(v_d_639, "querySelector", [".tt"])])
			break
		if _t719 <= 6 and _t719 >= 0:
			v_d_640 = J.cl(v_add_626, null, [J.mc(v_box_622, "querySelector", [".ml-body"]), ("mr " + ("content" if J.seq(v_who_620, "內文") else "")), ("<b>" + J.str(v_who_620) + "</b><span class=\"tt\"></span>")])
			J.cl(v_typeInto_625, null, [J.mc(v_d_640, "querySelector", [".tt"])])
			break
		if _t719 <= 7 and _t719 >= 0:
			v_d_641 = J.cl(v_add_626, null, [J.mc(v_box_622, "querySelector", [".letter-body"]), ("lt-mom" if J.seq(v_who_620, "媽") else ("lt-n" if J.seq(v_who_620, "旁白") else "lt-u")), (("<b>阿福：</b>" if J.seq(v_who_620, "阿福") else "") + "<span class=\"tt\"></span>")])
			J.cl(v_typeInto_625, null, [J.mc(v_d_641, "querySelector", [".tt"])])
			break
		if _t719 <= 8 and _t719 >= 0:
			v_d_642 = J.cl(v_add_626, null, [J.mc(v_box_622, "querySelector", [".narr-body"]), "nl", "<span class=\"tt\"></span>"])
			J.cl(v_typeInto_625, null, [J.mc(v_d_642, "querySelector", [".tt"])])
			break
		if _t719 <= 9 and _t719 >= 0:
			v_nm_643 = J.mc(v_box_622, "querySelector", [".nm"])
			v_tx_644 = J.mc(v_box_622, "querySelector", [".tx"])
			v_pt_645 = J.mc(v_box_622, "querySelector", ["canvas.pt"])
			var _t722 = ("" if J.seq(v_who_620, "旁白") else v_who_620)
			J.sp(v_nm_643, "textContent", _t722)
			var _t723 = J.gp(v_nm_643, "style")
			var _t724 = ("none" if J.seq(v_who_620, "旁白") else "")
			J.sp(_t723, "display", _t724)
			v_pc_646 = J.mc(v_pt_645, "getContext", ["2d"])
			J.mc(v_pc_646, "clearRect", [0.0, 0.0, 120.0, 120.0])
			v_art_647 = ("sys" if J.seq(v_who_620, "系統") else J.gp(J.G.get("SPEAKER_ART"), v_who_620))
			if J.seq(v_art_647, "sys"):
				J.mc(v_pc_646, "drawImage", [J.mc(J.G.get("ART"), "sysIcon", [120.0]), 0.0, 0.0, 120.0, 120.0])
			else:
				if J.t(v_art_647):
					var _t725 = J.gp(J.gp(_s293["this"], "cur"), "id")
					v_sid_648 = (_t725 if J.t(_t725) else "")
					J.mc(v_pc_646, "drawImage", [J.mc(J.G.get("ART"), "portrait", [v_art_647, 120.0, {"tamed": (not J.seq(v_sid_648, "ch4_boss")), "untied": (not J.seq(v_sid_648, "ch5_intro2"))}]), 0.0, 0.0, 120.0, 120.0])
			var _t726 = J.gp(v_pt_645, "style")
			var _t727 = ("" if J.t(v_art_647) else "none")
			J.sp(_t726, "display", _t727)
			var _t728 = J.gp(v_tx_644, "classList")
			J.mc(_t728, "toggle", ["narr", J.seq(v_who_620, "旁白")])
			J.mc(_s293["this"], "drawStage", [])
			J.cl(v_typeInto_625, null, [v_tx_644])
		break

func _f142(this_, a: Array, env):
	var v_c_651 = null; var v_ctx_652 = null
	var _t729 = J.G.get("$")
	v_c_651 = J.cl(_t729, null, ["#dlg canvas.anchor"])
	if (not J.t(v_c_651)):
		return null
	v_ctx_652 = J.mc(v_c_651, "getContext", ["2d"])
	J.mc(v_ctx_652, "clearRect", [0.0, 0.0, 160.0, 160.0])
	J.mc(J.G.get("ART"), "drawChar", [v_ctx_652, "mamian", 80.0, 168.0, 2.3, {"t": 0.2, "shadow": false}])
	J.mc(J.G.get("ART"), "rr", [v_ctx_652, 10.0, 130.0, 140.0, 30.0, 4.0, "#26304a", "#4a5a8a", 2.0])

func _f144(this_, a: Array, env):
	var v_cls_666 = null; var v_html_667 = null; var v_d_668 = null
	v_cls_666 = J.arg(a, 0)
	v_html_667 = J.arg(a, 1)
	v_d_668 = J.S_document_("createElement", ["div"])
	J.sp(v_d_668, "className", v_cls_666)
	J.sp(v_d_668, "innerHTML", v_html_667)
	J.mc(env["body"], "appendChild", [v_d_668])
	var _t731 = env["body"]
	var _t732 = J.gp(env["body"], "scrollHeight")
	J.sp(_t731, "scrollTop", _t732)
	return v_d_668

func _f145(this_, a: Array, env):
	var _t733 = env["this"]
	J.sp(_t733, "chatT", null)
	var _t734 = env["this"]
	J.sp(_t734, "li", J.num(J.gp(_t734, "li")) + 1.0)
	if J.cmp(J.gp(env["this"], "li"), J.len(J.gp(env["sc"], "lines")), ">="):
		J.mc(env["this"], "chatEnd", [])
		return null
	J.mc(env["this"], "showLine", [])

func _f146(this_, a: Array, env):
	env["i"] = J.num(env["i"]) + 1.0
	var _t738 = env["txt"]
	var _t739 = J.mc(env["__p"]["text"], "slice", [0.0, env["i"]])
	J.sp(_t738, "textContent", _t739)
	J.mc(J.G.get("Sound"), "play", ["key"])
	if J.cmp(env["i"], J.len(env["__p"]["text"]), "<"):
		var _t740 = env["__p"]["this"]
		var _t741 = J.F_setTimeout([env["step"], 55.0])
		J.sp(_t740, "chatT", _t741)
	else:
		var _t742 = env["__p"]["this"]
		J.sp(_t742, "chatT", null)
		var _t743 = env["btn"]
		var _t744 = J.gp(J.G.get("ICON"), "send")
		J.sp(_t743, "innerHTML", _t744)
		var _t745 = J.gp(env["btn"], "classList")
		J.mc(_t745, "add", ["await"])
		var _t746 = env["__p"]["this"]
		J.sp(_t746, "chatWait", "send")

func _f147(this_, a: Array, env):
	J.F_clearTimeout([J.gp(env["__p"]["this"], "chatT")])
	var _t748 = env["txt"]
	var _t749 = env["__p"]["text"]
	J.sp(_t748, "textContent", _t749)
	var _t750 = env["btn"]
	var _t751 = J.gp(J.G.get("ICON"), "send")
	J.sp(_t750, "innerHTML", _t751)
	var _t752 = J.gp(env["btn"], "classList")
	J.mc(_t752, "add", ["await"])
	var _t753 = env["__p"]["this"]
	J.sp(_t753, "chatWait", "send")
	var _t754 = env["__p"]["this"]
	J.sp(_t754, "chatT", null)

func _f149(this_, a: Array, env):
	var _t770 = J.mc(env["d"], "querySelector", [".tk"])
	var _t771 = J.G.get("TICK")
	var _t772 = J.cl(_t771, null, [false, true])
	J.sp(_t770, "outerHTML", _t772)
	var _t773 = env["__p"]["__p"]["this"]
	var _t774 = J.F_setTimeout([env["__p"]["__p"]["nextLine"], 650.0])
	J.sp(_t773, "chatT", _t774)

func _f148(this_, a: Array, env):
	var _s322 = {"__p": env, "d": null}
	var _t757 = _s322["__p"]["__p"]["this"]
	J.sp(_t757, "chatWait", null)
	var _t758 = J.gp(_s322["__p"]["btn"], "classList")
	J.mc(_t758, "remove", ["await"])
	var _t759 = _s322["__p"]["btn"]
	var _t760 = J.gp(J.G.get("ICON"), "mic")
	J.sp(_t759, "innerHTML", _t760)
	var _t761 = J.gp(_s322["__p"]["field"], "classList")
	J.mc(_t761, "remove", ["typing"])
	var _t762 = _s322["__p"]["txt"]
	J.sp(_t762, "textContent", "輸入訊息")
	J.mc(J.G.get("Sound"), "play", ["waOut"])
	var _t763 = _s322["__p"]["__p"]["add"]
	var _t765 = _s322["__p"]["__p"]["text"]
	var _t766 = _s322["__p"]["__p"]["tm"]
	var _t764 = J.G.get("TICK")
	_s322["d"] = J.cl(_t763, null, ["bub me pop", ("<span>" + J.str(_t765) + "</span><i>" + J.str(_t766) + " " + J.str(J.cl(_t764, null, [false, false])) + "</i>")])
	var _t767 = _s322["__p"]["__p"]["this"]
	var _t768 = _s322["d"]
	J.sp(_t767, "lastMine", _t768)
	var _t769 = _s322["__p"]["__p"]["this"]
	var _t775 = J.F_setTimeout([Callable(self, "_f149").bind(_s322), 600.0])
	J.sp(_t769, "chatT", _t775)

func _f150(this_, a: Array, env):
	J.F_clearTimeout([J.gp(env["this"], "chatT")])
	J.cl(env["nextLine"], null, [])

func _f152(this_, a: Array, env):
	var v_t_675 = null
	v_t_675 = J.arg(a, 0)
	var _t791 = J.G.get("TICK")
	var _t792 = J.cl(_t791, null, [true, true])
	J.sp(v_t_675, "outerHTML", _t792)
	return _t792

func _f153(this_, a: Array, env):
	J.F_clearTimeout([J.gp(env["this"], "chatT")])
	J.cl(env["nextLine"], null, [])

func _f151(this_, a: Array, env):
	var _t784 = env["this"]
	J.sp(_t784, "chatT", null)
	var _t785 = env["sub"]
	var _t786 = J.gp(env["sc"], "group")
	var _t787 = (_t786 if J.t(_t786) else "在線上")
	J.sp(_t785, "textContent", _t787)
	var _t788 = J.gp(env["sub"], "classList")
	J.mc(_t788, "remove", ["typing"])
	if J.t(J.gp(env["this"], "lastMine")):
		var _t789 = J.gp(env["this"], "lastMine")
		var _t790 = J.mc(_t789, "querySelectorAll", [".tk"])
		J.mc(_t790, "forEach", [Callable(self, "_f152").bind(env)])
		var _t793 = env["this"]
		J.sp(_t793, "lastMine", null)
	var _t794 = env["add"]
	J.cl(_t794, null, ["bub them pop", ((("<b class=\"nm\">" + J.str(env["who"]) + "</b>") if J.t(J.gp(env["sc"], "group")) else "") + ("<span>" + J.str(env["text"]) + "</span><i>" + J.str(env["tm"]) + "</i>"))])
	J.mc(J.G.get("Sound"), "play", ["waIn"])
	var _t795 = env["this"]
	var _t796 = J.F_setTimeout([env["nextLine"], J.min_([1800.0, (700.0 + (J.len(env["text"]) * 22.0))])])
	J.sp(_t795, "chatT", _t796)
	var _t797 = env["this"]
	var _t798 = Callable(self, "_f153").bind(env)
	J.sp(_t797, "chatFast", _t798)

func _f154(this_, a: Array, env):
	J.F_clearTimeout([J.gp(env["this"], "chatT")])
	J.cl(env["arrive"], null, [])

func _f143(this_, a: Array, env):
	var v_time_657 = null; var v_box_658 = null
	var _s314 = {"__p": env, "this": null, "who": null, "text": null, "sc": null, "body": null, "sub": null, "add": null, "nextLine": null, "tm": null, "arrive": null}
	_s314["this"] = this_
	_s314["who"] = J.arg(a, 0)
	_s314["text"] = J.arg(a, 1)
	v_time_657 = J.arg(a, 2)
	var _t730 = J.G.get("$")
	v_box_658 = J.cl(_t730, null, ["#dlg"])
	_s314["sc"] = J.gp(J.gp(_s314["this"], "cur"), "sc")
	_s314["body"] = J.mc(v_box_658, "querySelector", [".wa-body"])
	_s314["sub"] = J.mc(v_box_658, "querySelector", [".wa-sub"])
	_s314["add"] = Callable(self, "_f144").bind(_s314)
	_s314["nextLine"] = Callable(self, "_f145").bind(_s314)
	_s314["tm"] = (v_time_657 if J.t(v_time_657) else J.cl(J.G.get("nowHM"), null, []))
	var _t735 = _s314["this"]
	J.sp(_t735, "chatWait", null)
	J.F_clearTimeout([J.gp(_s314["this"], "chatT")])
	if J.seq(_s314["who"], "阿福"):
		var _s318 = {"__p": _s314, "field": null, "txt": null, "btn": null, "i": null, "step": null}
		_s318["field"] = J.mc(v_box_658, "querySelector", [".wa-field"])
		_s318["txt"] = J.mc(_s318["field"], "querySelector", [".wa-txt"])
		_s318["btn"] = J.mc(v_box_658, "querySelector", [".wa-send"])
		_s318["i"] = 0.0
		var _t736 = J.gp(_s318["field"], "classList")
		J.mc(_t736, "add", ["typing"])
		var _t737 = _s318["txt"]
		J.sp(_t737, "textContent", "")
		_s318["step"] = Callable(self, "_f146").bind(_s318)
		var _t747 = _s318["__p"]["this"]
		var _t755 = Callable(self, "_f147").bind(_s318)
		J.sp(_t747, "chatFast", _t755)
		var _t756 = _s318["__p"]["this"]
		var _t776 = Callable(self, "_f148").bind(_s318)
		J.sp(_t756, "chatSend", _t776)
		var _t777 = _s318["__p"]["this"]
		var _t778 = J.F_setTimeout([_s318["step"], 350.0])
		J.sp(_t777, "chatT", _t778)
		return null
	if J.seq(_s314["who"], "旁白"):
		var _t779 = _s314["add"]
		J.cl(_t779, null, ["bub mid pop", _s314["text"]])
		var _t780 = _s314["this"]
		var _t781 = J.F_setTimeout([_s314["nextLine"], 1300.0])
		J.sp(_t780, "chatT", _t781)
		var _t782 = _s314["this"]
		var _t783 = Callable(self, "_f150").bind(_s314)
		J.sp(_t782, "chatFast", _t783)
		return null
	_s314["arrive"] = Callable(self, "_f151").bind(_s314)
	if J.seq(J.gp(_s314["this"], "li"), 0.0):
		J.cl(_s314["arrive"], null, [])
		return null
	var _t799 = _s314["sub"]
	var _t800 = ((J.str(_s314["who"]) + " 正在輸入…") if J.t(J.gp(_s314["sc"], "group")) else "正在輸入…")
	J.sp(_t799, "textContent", _t800)
	var _t801 = J.gp(_s314["sub"], "classList")
	J.mc(_t801, "add", ["typing"])
	var _t802 = _s314["this"]
	var _t803 = J.F_setTimeout([_s314["arrive"], J.min_([1600.0, (450.0 + (J.len(_s314["text"]) * 30.0))])])
	J.sp(_t802, "chatT", _t803)
	var _t804 = _s314["this"]
	var _t805 = Callable(self, "_f154").bind(_s314)
	J.sp(_t804, "chatFast", _t805)

func _f157(this_, a: Array, env):
	var v_t_681 = null
	v_t_681 = J.arg(a, 0)
	var _t810 = J.G.get("TICK")
	var _t811 = J.cl(_t810, null, [true, true])
	J.sp(v_t_681, "outerHTML", _t811)
	return _t811

func _f156(this_, a: Array, env):
	var _t808 = J.gp(env["__p"]["this"], "lastMine")
	var _t809 = J.mc(_t808, "querySelectorAll", [".tk"])
	J.mc(_t809, "forEach", [Callable(self, "_f157").bind(env)])
	var _t812 = env["__p"]["this"]
	J.sp(_t812, "lastMine", null)
	var _t813 = env["sub"]
	J.sp(_t813, "textContent", "正在輸入…")
	var _t814 = J.gp(env["sub"], "classList")
	J.mc(_t814, "add", ["typing"])

func _f158(this_, a: Array, env):
	J.mc(J.G.get("Sound"), "play", ["heartbeat"])

func _f159(this_, a: Array, env):
	J.mc(J.G.get("Sound"), "play", ["heartbeat"])
	var _t816 = J.gp(J.mc(env["__p"]["box"], "querySelector", [".wa"]), "classList")
	J.mc(_t816, "add", ["crash"])

func _f160(this_, a: Array, env):
	J.mc(J.G.get("Sound"), "play", ["flatline"])
	var _t817 = J.gp(J.mc(env["__p"]["box"], "querySelector", [".wa"]), "classList")
	J.mc(_t817, "add", ["dead"])

func _f161(this_, a: Array, env):
	return J.mc(env["__p"]["this"], "next", [])

func _f155(this_, a: Array, env):
	var v_sc_679 = null
	var _s332 = {"__p": env, "this": null, "box": null}
	_s332["this"] = this_
	var _t806 = J.G.get("$")
	_s332["box"] = J.cl(_t806, null, ["#dlg"])
	v_sc_679 = J.gp(J.gp(_s332["this"], "cur"), "sc")
	if J.seq(J.gp(v_sc_679, "end"), "crash"):
		var _s333 = {"__p": _s332, "sub": null}
		_s333["sub"] = J.mc(_s333["__p"]["box"], "querySelector", [".wa-sub"])
		if J.t(J.gp(_s333["__p"]["this"], "lastMine")):
			var _t807 = _s333["__p"]["this"]
			var _t815 = J.F_setTimeout([Callable(self, "_f156").bind(_s333), 900.0])
			J.sp(_t807, "chatT", _t815)
		J.F_setTimeout([Callable(self, "_f158").bind(_s333), 2200.0])
		J.F_setTimeout([Callable(self, "_f159").bind(_s333), 3000.0])
		J.F_setTimeout([Callable(self, "_f160").bind(_s333), 3700.0])
		var _t818 = _s333["__p"]["this"]
		J.sp(_t818, "chatWait", "crash")
		var _t819 = _s333["__p"]["this"]
		var _t820 = J.F_setTimeout([Callable(self, "_f161").bind(_s333), 7200.0])
		J.sp(_t819, "chatT", _t820)
		return null
	var _t821 = _s332["this"]
	J.sp(_t821, "chatWait", "end")
	var _t822 = J.gp(J.mc(_s332["box"], "querySelector", [".tap"]), "style")
	J.sp(_t822, "display", "")

func _f162(this_, a: Array, env):
	var v_e_684 = null; var v_b_685 = null; var v_f_686 = null
	v_e_684 = J.arg(a, 0)
	var _t823 = J.gp(this_, "cur")
	if J.t((J.seq(J.gp(J.gp(J.gp(this_, "cur"), "sc"), "style"), "chat") if J.t(_t823) else _t823)):
		if J.seq(J.gp(this_, "chatWait"), "crash"):
			return null
		if J.seq(J.gp(this_, "chatWait"), "end"):
			J.mc(this_, "next", [])
			return null
		if J.seq(J.gp(this_, "chatWait"), "send"):
			var _t825 = v_e_684
			if J.t(_t825):
				var _t824 = J.gp(v_e_684, "target")
				_t825 = J.mc(_t824, "closest", [".wa-input"])
			if J.t(_t825):
				J.mc(this_, "chatSend", [])
			else:
				var _t826 = J.G.get("$")
				v_b_685 = J.cl(_t826, null, ["#dlg .wa-send"])
				var _t827 = J.gp(v_b_685, "classList")
				J.mc(_t827, "remove", ["nudge"])
				J.nop(J.gp(v_b_685, "offsetWidth"))
				var _t828 = J.gp(v_b_685, "classList")
				J.mc(_t828, "add", ["nudge"])
			return null
		if J.t(J.gp(this_, "chatFast")):
			v_f_686 = J.gp(this_, "chatFast")
			var _t829 = this_
			J.sp(_t829, "chatFast", null)
			J.cl(v_f_686, null, [])
		return null
	if J.t(J.gp(this_, "typing")):
		J.mc(this_, "full", [])
		return null
	var _t830 = this_
	J.sp(_t830, "li", J.num(J.gp(_t830, "li")) + 1.0)
	if J.cmp(J.gp(this_, "li"), J.len(J.gp(J.gp(J.gp(this_, "cur"), "sc"), "lines")), ">="):
		J.mc(this_, "next", [])
		return null
	J.mc(this_, "showLine", [])

func _f163(this_, a: Array, env):
	J.F_clearInterval([J.gp(this_, "timer")])
	J.F_clearTimeout([J.gp(this_, "chatT")])
	var _t831 = this_
	J.sp(_t831, "chatWait", null)
	var _t832 = this_
	J.sp(_t832, "chatFast", null)
	var _t833 = this_
	J.sp(_t833, "lastMine", null)
	var _t834 = this_
	J.sp(_t834, "typing", false)
	J.mc(this_, "next", [])

func _f166(this_, a: Array, env):
	var _t835 = J.G.get("$")
	var _t836 = J.gp(J.cl(_t835, null, ["#sheet"]), "classList")
	var _t839 = J.mc(_t836, "contains", ["on"])
	if not J.t(_t839):
		var _t837 = J.G.get("$")
		var _t838 = J.gp(J.cl(_t837, null, ["#battle"]), "classList")
		_t839 = J.mc(_t838, "contains", ["on"])
	return _t839

func _f168(this_, a: Array, env):
	var v_b_734 = null
	v_b_734 = J.arg(a, 0)
	var _t879 = J.gp(v_b_734, "classList")
	var _t883 = env["q"]
	if J.t(_t883):
		var _t880 = J.seq(J.gp(env["q"], "go"), "roster")
		var _t882 = (J.seq(J.gp(J.gp(v_b_734, "dataset"), "t"), "roster") if _t880 else _t880)
		if not J.t(_t882):
			var _t881 = J.seq(J.gp(env["q"], "go"), "gate")
			_t882 = (J.seq(J.gp(J.gp(v_b_734, "dataset"), "t"), "battle") if _t881 else _t881)
		_t883 = _t882
	return J.mc(_t879, "toggle", ["pulse", _t883])

func _f167(this_, a: Array, env):
	var v_need_725 = null; var v_cap_726 = null; var v_qb_728 = null; var v_ch_729 = null; var v_k_730 = null; var v_e_731 = null; var v_a_732 = null; var v_b_733 = null
	var _s373 = {"__p": env, "q": null}
	if (not J.t(J.G.get("S"))):
		return null
	var _t840 = J.G.get("$")
	var _t841 = J.cl(_t840, null, ["#lv"])
	var _t842 = J.gp(J.G.get("S"), "lv")
	J.sp(_t841, "textContent", _t842)
	v_need_725 = J.mc(J.G.get("F"), "expNeed", [J.gp(J.G.get("S"), "lv")])
	var _t843 = J.G.get("$")
	var _t844 = J.gp(J.cl(_t843, null, ["#expbar i"]), "style")
	var _t845 = J.add((100.0 if J.cmp(J.gp(J.G.get("S"), "lv"), 20.0, ">=") else J.min_([100.0, (J.div(J.gp(J.G.get("S"), "exp"), v_need_725) * 100.0)])), "%")
	J.sp(_t844, "width", _t845)
	var _t846 = J.G.get("$")
	var _t847 = J.cl(_t846, null, ["#exptxt"])
	var _t851 = null
	if J.cmp(J.gp(J.G.get("S"), "lv"), 20.0, ">="):
		_t851 = "好評 MAX"
	else:
		var _t848 = J.G.get("fmt")
		var _t850 = J.cl(_t848, null, [J.gp(J.G.get("S"), "exp")])
		var _t849 = J.G.get("fmt")
		_t851 = ("好評 " + J.str(_t850) + "/" + J.str(J.cl(_t849, null, [v_need_725])))
	J.sp(_t847, "textContent", _t851)
	v_cap_726 = J.mc(J.G.get("F"), "cap", [])
	for _t852 in J.iter(["wood", "rice", "planks", "buns"]):
		v_k_730 = _t852
		var _t853 = J.G.get("$")
		v_e_731 = J.cl(_t853, null, [J.add("#r-", v_k_730)])
		var _t854 = J.G.get("fmt")
		var _t855 = J.cl(_t854, null, [J.gp(J.gp(J.G.get("S"), "res"), v_k_730)])
		J.sp(v_e_731, "textContent", _t855)
		var _t856 = J.gp(J.gp(v_e_731, "parentElement"), "classList")
		J.mc(_t856, "toggle", ["full", J.cmp(J.gp(J.gp(J.G.get("S"), "res"), v_k_730), J.sub(v_cap_726, 0.5), ">=")])
	var _t857 = J.G.get("$")
	var _t858 = J.cl(_t857, null, ["#r-coins"])
	var _t859 = J.G.get("fmt")
	var _t860 = J.cl(_t859, null, [J.gp(J.gp(J.G.get("S"), "res"), "coins")])
	J.sp(_t858, "textContent", _t860)
	var _t861 = J.G.get("$")
	var _t862 = J.cl(_t861, null, ["#r-troops"])
	var _t863 = J.G.get("fmt")
	var _t864 = J.cl(_t863, null, [J.gp(J.gp(J.G.get("S"), "res"), "troops")])
	J.sp(_t862, "textContent", _t864)
	_s373["q"] = J.mc(J.G.get("Quest"), "cur", [])
	var _t865 = J.G.get("$")
	v_qb_728 = J.cl(_t865, null, ["#quest"])
	if J.t(_s373["q"]):
		var _t866 = J.mc(J.G.get("Quest"), "progress", [_s373["q"]])
		var _t867 = J.gp(_t866, 0.0)
		v_a_732 = _t867
		var _t868 = J.gp(_t866, 1.0)
		v_b_733 = _t868
		var _t869 = ("<b>主線</b><span>" + J.str(J.gp(_s373["q"], "text")) + "</span><em>" + J.str(J.min_([v_a_732, v_b_733])) + "/" + J.str(v_b_733) + "</em>")
		J.sp(v_qb_728, "innerHTML", _t869)
		var _t870 = J.gp(v_qb_728, "classList")
		J.mc(_t870, "toggle", ["done", J.cmp(v_a_732, v_b_733, ">=")])
	else:
		var _t871 = ("<b>主線</b><span>" + ("第一季完。村子由你慢慢經營。" if J.t(J.gp(J.G.get("S"), "ended")) else "—") + "</span>")
		J.sp(v_qb_728, "innerHTML", _t871)
	v_ch_729 = J.add(J.add(J.gp(J.gp(J.G.get("S"), "chests"), "g"), J.gp(J.gp(J.G.get("S"), "chests"), "b")), J.gp(J.gp(J.G.get("S"), "chests"), "p"))
	var _t872 = J.G.get("$")
	var _t873 = J.cl(_t872, null, ["#nav [data-t=chest] i"])
	var _t874 = (v_ch_729 if J.t(v_ch_729) else "")
	J.sp(_t873, "textContent", _t874)
	var _t875 = J.G.get("$")
	var _t876 = J.gp(J.cl(_t875, null, ["#nav [data-t=chest] i"]), "style")
	var _t877 = ("" if J.t(v_ch_729) else "none")
	J.sp(_t876, "display", _t877)
	var _t878 = J.S_document_("querySelectorAll", ["#nav button"])
	J.mc(_t878, "forEach", [Callable(self, "_f168").bind(_s373)])
	var _t886 = J.gp(this_, "sheetRefresh")
	if J.t(_t886):
		var _t884 = J.G.get("$")
		var _t885 = J.gp(J.cl(_t884, null, ["#sheet"]), "classList")
		_t886 = J.mc(_t885, "contains", ["on"])
	if J.t(_t886):
		J.mc(this_, "sheetRefresh", [])

func _f170(this_, a: Array, env):
	var v_b_738 = null
	v_b_738 = J.arg(a, 0)
	var _t888 = J.gp(v_b_738, "classList")
	return J.mc(_t888, "toggle", ["on", J.seq(J.gp(J.gp(v_b_738, "dataset"), "t"), env["t"])])

func _f169(this_, a: Array, env):
	var _s378 = {"__p": env, "t": null}
	_s378["t"] = J.arg(a, 0)
	if J.seq(_s378["t"], "village"):
		J.mc(this_, "close", [])
		return null
	if J.seq(_s378["t"], "roster"):
		J.mc(this_, "openRoster", [])
	if J.seq(_s378["t"], "battle"):
		J.mc(this_, "openBattleSelect", [])
	if J.seq(_s378["t"], "chest"):
		J.mc(this_, "openChests", [])
	if J.seq(_s378["t"], "story"):
		J.mc(this_, "openStory", [])
	var _t887 = J.S_document_("querySelectorAll", ["#nav button"])
	J.mc(_t887, "forEach", [Callable(self, "_f170").bind(_s378)])

func _f171(this_, a: Array, env):
	var v_title_741 = null; var v_html_742 = null; var v_refresher_743 = null; var v_sh_744 = null
	v_title_741 = J.arg(a, 0)
	v_html_742 = J.arg(a, 1)
	v_refresher_743 = J.arg(a, 2)
	var _t889 = J.G.get("$")
	v_sh_744 = J.cl(_t889, null, ["#sheet"])
	var _t890 = J.gp(v_sh_744, "classList")
	J.mc(_t890, "add", ["on"])
	var _t891 = J.gp(v_sh_744, "classList")
	if (not J.t(J.mc(_t891, "contains", ["was"]))):
		J.mc(J.G.get("Sound"), "play", ["paper"])
	var _t892 = J.gp(v_sh_744, "classList")
	J.mc(_t892, "add", ["was"])
	var _t893 = J.mc(v_sh_744, "querySelector", [".sh-title"])
	J.sp(_t893, "textContent", v_title_741)
	var _t894 = J.mc(v_sh_744, "querySelector", [".sh-body"])
	J.sp(_t894, "innerHTML", v_html_742)
	var _t895 = this_
	var _t896 = (v_refresher_743 if J.t(v_refresher_743) else null)
	J.sp(_t895, "sheetRefresh", _t896)

func _f173(this_, a: Array, env):
	var v_b_747 = null
	v_b_747 = J.arg(a, 0)
	var _t901 = J.gp(v_b_747, "classList")
	return J.mc(_t901, "toggle", ["on", J.seq(J.gp(J.gp(v_b_747, "dataset"), "t"), "village")])

func _f172(this_, a: Array, env):
	var _t897 = J.G.get("$")
	var _t898 = J.gp(J.cl(_t897, null, ["#sheet"]), "classList")
	J.mc(_t898, "remove", ["on", "was"])
	var _t899 = this_
	J.sp(_t899, "sheetRefresh", null)
	var _t900 = J.S_document_("querySelectorAll", ["#nav button"])
	J.mc(_t900, "forEach", [Callable(self, "_f173").bind(env)])

func _f176(this_, a: Array, env):
	var v_k_764 = null
	v_k_764 = J.arg(a, 0)
	var _t928 = (not J.t(J.gp(J.gp(J.G.get("FODDER"), v_k_764), "unlock")))
	return (_t928 if _t928 else J.gp(J.gp(J.G.get("S"), "cleared"), J.gp(J.gp(J.G.get("FODDER"), v_k_764), "unlock")))

func _f177(this_, a: Array, env):
	var v_k_765 = null
	v_k_765 = J.arg(a, 0)
	return J.gp(J.gp(J.G.get("FODDER"), v_k_765), "name")

func _f178(this_, a: Array, env):
	var v_a_768 = null; var v_g_769 = null
	v_a_768 = J.arg(a, 0)
	v_g_769 = J.arg(a, 1)
	return J.add(v_a_768, J.mc(J.G.get("F"), "stat", [v_g_769, 1.0]))

func _f175(this_, a: Array, env):
	var v_b_754 = null; var v_lv_755 = null; var v_h_756 = null; var v_c_757 = null; var v_src_758 = null; var v_can_759 = null; var v_dis_760 = null; var v_left_761 = null; var v_c_762 = null; var v_pool_763 = null; var v_iq_766 = null; var v_left_767 = null; var v_p_770 = null
	v_b_754 = J.gp(J.G.get("BUILDINGS"), env["id"])
	v_lv_755 = J.gp(J.gp(J.G.get("S"), "bld"), env["id"])
	var _t902 = J.gp(J.G.get("FLAVOR"), env["id"])
	v_h_756 = ("<p class=\"flavor\">" + J.str((_t902 if J.t(_t902) else "")) + "</p><p class=\"desc\">" + J.str(J.gp(v_b_754, "desc")) + "</p>")
	if (not J.t(v_lv_755)):
		var _t903 = J.G.get("bldUnlocked")
		if (not J.t(J.cl(_t903, null, [env["id"]]))):
			var _t904 = J.add(v_h_756, ("<p class=\"lack\">尚未解鎖。</p>"))
			v_h_756 = _t904
		else:
			var _t905 = J.G.get("costText")
			var _t907 = J.cl(_t905, null, [J.gp(v_b_754, "build")])
			var _t906 = J.G.get("canPay")
			var _t908 = J.add(v_h_756, ("<div class=\"row\"><span>建造費用：" + J.str(_t907) + "</span><button class=\"btn gold\" data-act=\"build\" " + ("" if J.t(J.cl(_t906, null, [J.gp(v_b_754, "build")])) else "disabled") + ">建造</button></div>"))
			v_h_756 = _t908
	else:
		var _t909 = J.add(v_h_756, ("<div class=\"stat\">等級 <b>Lv " + J.str(v_lv_755) + "</b>" + (("（上限 = 鬼宅等級 " + J.str(J.gp(J.gp(J.G.get("S"), "bld"), "house")) + "）") if (not J.seq(env["id"], "house")) else "") + "</div>"))
		v_h_756 = _t909
		var _t910 = J.add(v_h_756, J.mc(env["this"], "bldEffect", [env["id"]]))
		v_h_756 = _t910
		if J.cmp(v_lv_755, J.mc(J.G.get("F"), "bldMax", [env["id"]]), "<"):
			v_c_757 = J.mc(J.G.get("F"), "upCost", [env["id"], v_lv_755])
			var _t911 = J.G.get("costText")
			var _t913 = J.cl(_t911, null, [v_c_757])
			var _t914 = (("<br><small>工頭省了 " + J.str(J.round(J.num(J.mul(J.mc(J.G.get("F"), "builderDiscount", []), 100.0)))) + "% 棺材板</small>") if J.t(J.mc(J.G.get("F"), "builderDiscount", [])) else "")
			var _t912 = J.G.get("canPay")
			var _t915 = J.add(v_h_756, ("<div class=\"row\"><span>升級：" + J.str(_t913) + _t914 + "</span><button class=\"btn gold\" data-act=\"up\" " + ("" if J.t(J.cl(_t912, null, [v_c_757])) else "disabled") + ">升級</button></div>"))
			v_h_756 = _t915
		else:
			var _t916 = J.add(v_h_756, ("<p class=\"desc\">" + ("已達最高等級。" if J.seq(env["id"], "house") else "已達上限，先升級鬼宅。") + "</p>"))
			v_h_756 = _t916
		var _t917 = J.seq(env["id"], "plank")
		if (_t917 if _t917 else J.seq(env["id"], "bun")):
			v_src_758 = ("wood" if J.seq(env["id"], "plank") else "rice")
			v_can_759 = floor(J.num(J.div(J.gp(J.gp(J.G.get("S"), "res"), v_src_758), 4.0)))
			v_dis_760 = ("disabled" if J.cmp(v_can_759, 1.0, "<") else "")
			var _t918 = J.add(v_h_756, ("<div class=\"row craft-row\"><span>親手做：每份 4 " + ("槐木 → 2 棺材板" if J.seq(env["id"], "plank") else "糯米 → 2 壽包") + "　好評 +1<br><small>現有" + J.str(J.gp(J.G.get("RES_NAMES"), v_src_758)) + " " + J.str(J.gp(J.gp(J.G.get("S"), "res"), v_src_758)) + "，夠做 " + J.str(v_can_759) + " 份</small></span><div class=\"craft-btns\"><button class=\"btn\" data-act=\"craft\" data-n=\"1\" " + J.str(v_dis_760) + ">做1份</button><button class=\"btn\" data-act=\"craft\" data-n=\"5\" " + J.str(v_dis_760) + ">一次做5份</button><button class=\"btn\" data-act=\"craft\" data-n=\"10\" " + J.str(v_dis_760) + ">一次做10份</button></div></div>"))
			v_h_756 = _t918
		if J.seq(env["id"], "furnace"):
			v_left_761 = J.max_([0.0, J.sub(J.gp(J.G.get("F"), "furnaceCD"), J.div(J.mul(J.sub(J.S_Date_("now", []), J.gp(J.G.get("S"), "furnaceAt")), J.G.get("TIME_SCALE")), 1000.0))])
			var _t919 = J.add(v_h_756, ("<div class=\"row\"><span>" + (("還要 " + J.str(ceil(J.num(J.div(v_left_761, 60.0)))) + " 分鐘") if J.cmp(v_left_761, 0.0, ">") else "爐火正旺！") + "　可燒出 冥幣 " + J.str(J.mc(J.G.get("F"), "furnaceCoins", [])) + "</span><button class=\"btn gold\" data-act=\"burn\" " + ("disabled" if J.cmp(v_left_761, 0.0, ">") else "") + ">燒</button></div>"))
			v_h_756 = _t919
		if J.seq(env["id"], "altar"):
			v_c_762 = J.mc(J.G.get("F"), "recruitCost", [])
			var _t920 = J.G.get("costText")
			var _t923 = J.cl(_t920, null, [v_c_762])
			var _t924 = J.cl(J.G.get("fodderCount"), null, [])
			var _t925 = J.mc(J.G.get("F"), "rosterCap", [])
			var _t921 = J.G.get("canPay")
			var _t922 = J.cl(_t921, null, [v_c_762])
			var _t926 = J.add(v_h_756, ("<div class=\"row\"><span>招魂一次：" + J.str(_t923) + "<br><small>雜鬼名額 " + J.str(_t924) + "/" + J.str(_t925) + "（升級民宅增加；收服的名鬼不佔名額）</small></span><button class=\"btn gold\" data-act=\"recruit\" " + ("" if J.t((J.cmp(J.cl(J.G.get("fodderCount"), null, []), J.mc(J.G.get("F"), "rosterCap", []), "<") if J.t(_t922) else _t922)) else "disabled") + ">招魂</button></div>"))
			v_h_756 = _t926
			var _t927 = J.S_Object_("keys", [J.G.get("FODDER")])
			var _t929 = J.mc(_t927, "filter", [Callable(self, "_f176").bind(env)])
			var _t930 = J.mc(_t929, "map", [Callable(self, "_f177").bind(env)])
			v_pool_763 = J.mc(_t930, "join", ["、"])
			var _t931 = J.add(v_h_756, ("<p class=\"desc\">目前可能招到：" + J.str(v_pool_763) + "。收服更多鬼怪後，招魂池會變大。</p>"))
			v_h_756 = _t931
		var _t932 = J.seq(env["id"], "house")
		if (J.cmp(J.gp(J.G.get("S"), "lv"), 12.0, ">=") if _t932 else _t932):
			var _t933 = J.gp(J.G.get("S"), "ghosts")
			v_iq_766 = J.mc(_t933, "reduce", [Callable(self, "_f178").bind(env), 0.0])
			v_left_767 = J.max_([0.0, J.sub(J.gp(J.G.get("F"), "feastCD"), J.div(J.mul(J.sub(J.S_Date_("now", []), J.gp(J.G.get("S"), "feastAt")), J.G.get("TIME_SCALE")), 1000.0))])
			var _t936 = J.gp(J.G.get("F"), "feastNeed")
			var _t937 = (("　冷卻 " + J.str(ceil(J.num(J.div(v_left_767, 60.0)))) + " 分") if J.cmp(v_left_767, 0.0, ">") else "")
			var _t934 = J.cmp(J.gp(J.gp(J.G.get("S"), "res"), "buns"), 300.0, ">=")
			var _t935 = (J.cmp(v_iq_766, J.gp(J.G.get("F"), "feastNeed"), ">=") if _t934 else _t934)
			var _t938 = J.add(v_h_756, ("<div class=\"row\"><span>盂蘭宴：壽包 300<br><small>全村智力總和 " + J.str(v_iq_766) + "/" + J.str(_t936) + _t937 + "</small></span><button class=\"btn gold\" data-act=\"feast\" " + ("" if (J.cmp(v_left_767, 0.0, "<=") if _t935 else _t935) else "disabled") + ">擺宴</button></div>"))
			v_h_756 = _t938
		for _t939 in J.iter(J.gp(v_b_754, "posts")):
			v_p_770 = _t939
			var _t940 = J.add(v_h_756, J.mc(env["this"], "postHtml", [v_p_770]))
			v_h_756 = _t940
	return v_h_756

func _f179(this_, a: Array, env):
	var _t941 = J.G.get("$")
	var _t942 = J.cl(_t941, null, ["#sheet .sh-body"])
	var _t943 = J.cl(env["render"], null, [])
	J.sp(_t942, "innerHTML", _t943)
	J.cl(env["bind"], null, [])

func _f182(this_, a: Array, env):
	var v_a_772 = null; var v_c_773 = null; var v_c_774 = null; var v_g_775 = null; var v_g_776 = null; var v_g_777 = null
	v_a_772 = J.gp(J.gp(env["btn"], "dataset"), "act")
	if J.seq(v_a_772, "build"):
		J.mc(J.G.get("Sound"), "play", ["build"])
		var _t948 = J.G.get("pay")
		J.cl(_t948, null, [J.gp(J.gp(J.G.get("BUILDINGS"), env["__p"]["id"]), "build")])
		var _t949 = J.gp(J.G.get("S"), "bld")
		var _t950 = env["__p"]["id"]
		J.sp(_t949, _t950, 1.0)
		var _t951 = J.G.get("gainExp")
		J.cl(_t951, null, [15.0])
		J.mc(J.G.get("Fx"), "banner", [(J.str(J.gp(J.gp(J.G.get("BUILDINGS"), env["__p"]["id"]), "name")) + " 建好了！")])
		J.mc(J.G.get("Quest"), "check", [])
	if J.seq(v_a_772, "up"):
		J.mc(J.G.get("Sound"), "play", ["build"])
		v_c_773 = J.mc(J.G.get("F"), "upCost", [env["__p"]["id"], J.gp(J.gp(J.G.get("S"), "bld"), env["__p"]["id"])])
		var _t952 = J.G.get("pay")
		J.cl(_t952, null, [v_c_773])
		var _t953 = J.gp(J.G.get("S"), "bld")
		var _t954 = env["__p"]["id"]
		J.sp(_t953, _t954, J.num(J.gp(_t953, _t954)) + 1.0)
		var _t955 = J.G.get("gainExp")
		J.cl(_t955, null, [(10.0 + J.mul(8.0, J.gp(J.gp(J.G.get("S"), "bld"), env["__p"]["id"])))])
		J.mc(J.G.get("Fx"), "banner", [(J.str(J.gp(J.gp(J.G.get("BUILDINGS"), env["__p"]["id"]), "name")) + " 升到 Lv " + J.str(J.gp(J.gp(J.G.get("S"), "bld"), env["__p"]["id"])))])
		J.mc(J.G.get("Quest"), "check", [])
	if J.seq(v_a_772, "craft"):
		J.mc(env["__p"]["this"], "close", [])
		var _t957 = env["__p"]["id"]
		var _t956 = J.num(J.gp(J.gp(env["btn"], "dataset"), "n"))
		J.mc(J.G.get("Village"), "craft", [_t957, (_t956 if J.t(_t956) else 1.0)])
		return null
	if J.seq(v_a_772, "burn"):
		if (not J.t(J.cl(J.G.get("furnaceReady"), null, []))):
			return null
		J.mc(J.G.get("Sound"), "play", ["coin"])
		J.mc(J.G.get("JossFx"), "play", [])
		var _t958 = J.G.get("S")
		var _t959 = J.S_Date_("now", [])
		J.sp(_t958, "furnaceAt", _t959)
		v_c_774 = J.mc(J.G.get("F"), "furnaceCoins", [])
		var _t960 = J.gp(J.G.get("S"), "res")
		var _t961 = J.add(J.gp(_t960, "coins"), v_c_774)
		J.sp(_t960, "coins", _t961)
		J.mc(J.G.get("Fx"), "toast", [("化寶爐燒出 <b>冥幣 " + J.str(v_c_774) + "</b>")])
	if J.seq(v_a_772, "recruit"):
		J.mc(J.G.get("Sound"), "play", ["whoosh"])
		var _t962 = J.G.get("pay")
		J.cl(_t962, null, [J.mc(J.G.get("F"), "recruitCost", [])])
		var _t963 = J.G.get("recruitFodder")
		v_g_775 = J.cl(_t963, null, [false])
		var _t964 = J.gp(J.G.get("S"), "cnt")
		J.sp(_t964, "recruit", J.num(J.gp(_t964, "recruit")) + 1.0)
		J.mc(J.G.get("Fx"), "toast", [("招來了 <b>" + J.str(J.gp(v_g_775, "name")) + "</b>（" + J.str(J.gp(v_g_775, "q")) + "）")])
		J.mc(J.G.get("Quest"), "check", [])
	if J.seq(v_a_772, "feast"):
		J.mc(J.G.get("Sound"), "play", ["gong"])
		var _t965 = J.gp(J.G.get("S"), "res")
		var _t966 = J.sub(J.gp(_t965, "buns"), 300.0)
		J.sp(_t965, "buns", _t966)
		var _t967 = J.G.get("S")
		var _t968 = J.S_Date_("now", [])
		J.sp(_t967, "feastAt", _t968)
		var _t969 = J.gp(J.G.get("S"), "cnt")
		J.sp(_t969, "feast", J.num(J.gp(_t969, "feast")) + 1.0)
		var _t970 = J.G.get("gainExp")
		J.cl(_t970, null, [150.0])
		if J.cmp(J.cl(J.G.get("fodderCount"), null, []), J.mc(J.G.get("F"), "rosterCap", []), "<"):
			var _t971 = J.G.get("recruitFodder")
			v_g_776 = J.cl(_t971, null, [true])
			J.mc(J.G.get("Fx"), "toast", [("盂蘭宴請來了稀客 <b>" + J.str(J.gp(v_g_776, "name")) + "</b>（紫）！好評 +150")])
		else:
			var _t972 = J.gp(J.G.get("S"), "chests")
			J.sp(_t972, "p", J.num(J.gp(_t972, "p")) + 1.0)
			J.mc(J.G.get("Fx"), "toast", ["盂蘭宴賓客滿座，可惜村裡住不下了。客人留下一個<b>紫箱</b>就走了。好評 +150"])
		J.mc(J.G.get("Quest"), "check", [])
	if J.seq(v_a_772, "assign"):
		J.mc(env["__p"]["this"], "pickWorker", [J.gp(J.gp(env["btn"], "dataset"), "post"), env["__p"]["id"]])
		return null
	if J.seq(v_a_772, "unassign"):
		var _t973 = J.G.get("ghostById")
		v_g_777 = J.cl(_t973, null, [J.gp(J.gp(env["btn"], "dataset"), "g")])
		if J.t(v_g_777):
			J.sp(v_g_777, "post", null)
	J.cl(J.G.get("save"), null, [])
	J.mc(J.G.get("UI"), "refresh", [])
	J.cl(env["__p"]["re"], null, [])

func _f181(this_, a: Array, env):
	var _s400 = {"__p": env, "btn": null}
	_s400["btn"] = J.arg(a, 0)
	var _t947 = _s400["btn"]
	var _t974 = Callable(self, "_f182").bind(_s400)
	J.sp(_t947, "onclick", _t974)
	return _t974

func _f180(this_, a: Array, env):
	var _t944 = J.G.get("$")
	var _t945 = J.cl(_t944, null, ["#sheet .sh-body"])
	var _t946 = J.mc(_t945, "querySelectorAll", ["[data-act]"])
	J.mc(_t946, "forEach", [Callable(self, "_f181").bind(env)])

func _f183(this_, a: Array, env):
	var v_sc_778 = null
	var _t976 = (not J.t(J.gp(J.G.get("document"), "activeElement")))
	var _t978 = (_t976 if _t976 else (not J.t(J.gp(J.gp(J.G.get("document"), "activeElement"), "closest"))))
	if not J.t(_t978):
		var _t977 = J.gp(J.G.get("document"), "activeElement")
		_t978 = (not J.t(J.mc(_t977, "closest", ["#sheet"])))
	if _t978:
		var _t979 = J.G.get("$")
		v_sc_778 = J.gp(J.cl(_t979, null, ["#sheet .sh-body"]), "scrollTop")
		J.cl(env["re"], null, [])
		var _t980 = J.G.get("$")
		var _t981 = J.cl(_t980, null, ["#sheet .sh-body"])
		J.sp(_t981, "scrollTop", v_sc_778)

func _f174(this_, a: Array, env):
	var _s384 = {"__p": env, "this": null, "id": null, "render": null, "re": null, "bind": null}
	_s384["this"] = this_
	_s384["id"] = J.arg(a, 0)
	_s384["render"] = Callable(self, "_f175").bind(_s384)
	_s384["re"] = Callable(self, "_f179").bind(_s384)
	_s384["bind"] = Callable(self, "_f180").bind(_s384)
	J.mc(_s384["this"], "sheet", [J.gp(J.gp(J.G.get("BUILDINGS"), _s384["id"]), "name"), J.cl(_s384["render"], null, []), null])
	J.cl(_s384["bind"], null, [])
	var _t975 = _s384["this"]
	var _t982 = Callable(self, "_f183").bind(_s384)
	J.sp(_t975, "sheetRefresh", _t982)

func _f185(this_, a: Array, env):
	var v_a_784 = null
	v_a_784 = J.arg(a, 0)
	return ("<div class=\"eff\">" + J.str(v_a_784) + "</div>")

func _f186(this_, a: Array, env):
	var v_g_786 = null; var v_lv_787 = null; var v_nx_788 = null
	v_g_786 = J.arg(a, 0)
	v_lv_787 = J.mc(J.G.get("Rework"), "drillLv", [J.gp(v_g_786, "k")])
	v_nx_788 = J.mc(J.G.get("Rework"), "drillNext", [J.gp(v_g_786, "k")])
	return (J.str(J.gp(v_g_786, "name")) + " 嚇功 Lv" + J.str(v_lv_787) + (("（" + J.str(floor(J.num(J.mc(J.G.get("Rework"), "drillXp", [J.gp(v_g_786, "k")])))) + "/" + J.str(v_nx_788) + "）") if J.t(v_nx_788) else "（滿）"))

func _f184(this_, a: Array, env):
	var v_id_781 = null; var v_r_782 = null; var v_L_783 = null; var v_ws_785 = null
	v_id_781 = J.arg(a, 0)
	v_r_782 = J.cl(J.G.get("ratesPerMin"), null, [])
	v_L_783 = Callable(self, "_f185").bind(env)
	var _t983 = -1
	var _t984 = false
	if _t983 == -1 and J.seq(v_id_781, "house"): _t983 = 0
	if _t983 == -1 and J.seq(v_id_781, "wood"): _t983 = 1
	if _t983 == -1 and J.seq(v_id_781, "rice"): _t983 = 2
	if _t983 == -1 and J.seq(v_id_781, "plank"): _t983 = 3
	if _t983 == -1 and J.seq(v_id_781, "bun"): _t983 = 4
	if _t983 == -1 and J.seq(v_id_781, "store"): _t983 = 5
	if _t983 == -1 and J.seq(v_id_781, "home"): _t983 = 6
	if _t983 == -1 and J.seq(v_id_781, "camp"): _t983 = 7
	if _t983 == -1: _t983 = 8
	while true:
		if _t983 <= 0 and _t983 >= 0:
			return J.cl(v_L_783, null, [("其他建築最高可升到 Lv " + J.str(J.gp(J.gp(J.G.get("S"), "bld"), "house")))])
		if _t983 <= 1 and _t983 >= 0:
			var _t985 = J.mc(J.G.get("F"), "mult", ["wood"])
			var _t987 = J.mc(_t985, "toFixed", [1.0])
			var _t988 = J.mc(J.G.get("F"), "slots", ["wood"])
			var _t986 = J.gp(v_r_782, "wood")
			return J.cl(v_L_783, null, [("每崗產量 ×" + J.str(_t987) + "　崗位 " + J.str(_t988) + "　目前 槐木 +" + J.str(J.mc(_t986, "toFixed", [1.0])) + "/分")])
		if _t983 <= 2 and _t983 >= 0:
			var _t989 = J.mc(J.G.get("F"), "mult", ["rice"])
			var _t991 = J.mc(_t989, "toFixed", [1.0])
			var _t992 = J.mc(J.G.get("F"), "slots", ["rice"])
			var _t990 = J.gp(v_r_782, "rice")
			return J.cl(v_L_783, null, [("每崗產量 ×" + J.str(_t991) + "　崗位 " + J.str(_t992) + "　目前 糯米 +" + J.str(J.mc(_t990, "toFixed", [1.0])) + "/分")])
		if _t983 <= 3 and _t983 >= 0:
			var _t994 = J.mc(J.G.get("F"), "slots", ["plank"])
			var _t993 = J.gp(v_r_782, "planks")
			var _t996 = J.mc(_t993, "toFixed", [1.0])
			var _t995 = J.gp(v_r_782, "woodUse")
			return J.cl(v_L_783, null, [("崗位 " + J.str(_t994) + "　目前 棺材板 +" + J.str(_t996) + "/分（耗槐木 " + J.str(J.mc(_t995, "toFixed", [1.0])) + "/分）<br>藍箱可開出 棺材板 " + J.str(J.gp(J.mc(J.G.get("F"), "chestGain", ["b"]), "planks")))])
		if _t983 <= 4 and _t983 >= 0:
			var _t998 = J.mc(J.G.get("F"), "slots", ["bun"])
			var _t997 = J.gp(v_r_782, "buns")
			var _t1000 = J.mc(_t997, "toFixed", [1.0])
			var _t999 = J.gp(v_r_782, "riceUse")
			return J.cl(v_L_783, null, [("崗位 " + J.str(_t998) + "　目前 壽包 +" + J.str(_t1000) + "/分（耗糯米 " + J.str(J.mc(_t999, "toFixed", [1.0])) + "/分）<br>綠箱可開出 壽包 " + J.str(J.gp(J.mc(J.G.get("F"), "chestGain", ["g"]), "buns")))])
		if _t983 <= 5 and _t983 >= 0:
			var _t1001 = J.G.get("fmt")
			return J.cl(v_L_783, null, [("槐木、糯米、棺材板、壽包 存放上限：" + J.str(J.cl(_t1001, null, [J.mc(J.G.get("F"), "cap", [])])))])
		if _t983 <= 6 and _t983 >= 0:
			var _t1003 = J.mc(J.G.get("F"), "rosterCap", [])
			var _t1002 = J.gp(v_r_782, "troops")
			var _t1005 = J.mc(_t1002, "toFixed", [1.0])
			var _t1004 = J.G.get("fmt")
			return J.cl(v_L_783, null, [("雜鬼名額 " + J.str(_t1003) + "　遊魂自願當陰兵 +" + J.str(_t1005) + "/分　陰兵上限 " + J.str(J.cl(_t1004, null, [J.mc(J.G.get("F"), "troopCap", [])])))])
		if _t983 <= 7 and _t983 >= 0:
			var _t1006 = J.G.get("workersAt")
			v_ws_785 = J.cl(_t1006, null, ["camp"])
			var _t1007 = J.mc(J.G.get("F"), "mult", ["camp"])
			var _t1009 = J.mc(_t1007, "toFixed", [1.0])
			var _t1010 = J.mc(J.G.get("F"), "slots", ["camp"])
			var _t1008 = J.gp(v_r_782, "bunUse")
			var _t1013 = J.cl(v_L_783, null, [("練習速度 ×" + J.str(_t1009) + "　崗位 " + J.str(_t1010) + "　耗壽包 " + J.str(J.mc(_t1008, "toFixed", [1.0])) + "/分<br>嚇功越高：回陽間招式更嚇人、更省陰氣；戰鬥嚇法更痛。")])
			var _t1012 = null
			if J.t(J.len(v_ws_785)):
				var _t1011 = J.mc(v_ws_785, "map", [Callable(self, "_f186").bind(env)])
				_t1012 = J.add("<br>", J.mc(_t1011, "join", ["　"]))
			else:
				_t1012 = ""
			return J.add(_t1013, _t1012)
		if _t983 <= 8 and _t983 >= 0:
			return ""
		break

func _f188(this_, a: Array, env):
	var _t1024 = J.G.get("paintPortraits")
	var _t1025 = J.G.get("$")
	return J.cl(_t1024, null, [J.cl(_t1025, null, ["#sheet"])])

func _f187(this_, a: Array, env):
	var v_post_791 = null; var v_P_792 = null; var v_n_793 = null; var v_h_794 = null; var v_ws_795 = null; var v_i_796 = null; var v_g_797 = null
	v_post_791 = J.arg(a, 0)
	v_P_792 = J.gp(J.G.get("POSTS"), v_post_791)
	v_n_793 = J.mc(J.G.get("F"), "slots", [v_post_791])
	if (not J.t(v_n_793)):
		return ""
	var _t1014 = J.seq(v_post_791, "wood")
	var _t1015 = (_t1014 if _t1014 else J.seq(v_post_791, "rice"))
	var _t1016 = (_t1015 if _t1015 else J.seq(v_post_791, "plank"))
	var _t1017 = (_t1016 if _t1016 else J.seq(v_post_791, "bun"))
	var _t1018 = (_t1017 if _t1017 else J.seq(v_post_791, "camp"))
	var _t1019 = (_t1018 if _t1018 else J.seq(v_post_791, "store"))
	if (_t1019 if _t1019 else J.seq(v_post_791, "boss")):
		if J.cmp(J.gp(J.G.get("S"), "lv"), 4.0, "<"):
			return ("<div class=\"post\"><div class=\"ph\">" + J.str(J.gp(v_P_792, "name")) + "崗位</div><p class=\"lack\">升到 4 級【略懂管理學】後可派鬼怪打工。</p></div>")
	v_h_794 = ("<div class=\"post\"><div class=\"ph\">" + J.str(J.gp(v_P_792, "name")) + "崗位 <small>" + J.str(J.gp(v_P_792, "desc")) + "</small></div><div class=\"slots\">")
	var _t1020 = J.G.get("workersAt")
	v_ws_795 = J.cl(_t1020, null, [v_post_791])
	v_i_796 = 0.0
	while true:
		if not J.cmp(v_i_796, v_n_793, "<"): break
		v_g_797 = J.gp(v_ws_795, v_i_796)
		if J.t(v_g_797):
			var _t1021 = J.add(v_h_794, ("<div class=\"slot\"><canvas data-por=\"" + J.str(J.gp(v_g_797, "k")) + "\"></canvas><div><b>" + J.str(J.gp(v_g_797, "name")) + "</b><small>Lv" + J.str(J.mc(J.G.get("F"), "glv", [v_g_797])) + "　" + J.str(J.mc(this_, "postStatTxt", [v_g_797, v_post_791])) + "</small></div><button class=\"btn sm\" data-act=\"unassign\" data-g=\"" + J.str(J.gp(v_g_797, "id")) + "\">撤下</button></div>"))
			v_h_794 = _t1021
		else:
			var _t1022 = J.add(v_h_794, ("<div class=\"slot empty\"><span>空崗位</span><button class=\"btn sm\" data-act=\"assign\" data-post=\"" + J.str(v_post_791) + "\">派人</button></div>"))
			v_h_794 = _t1022
		v_i_796 = J.num(v_i_796) + 1.0
	var _t1023 = J.add(v_h_794, "</div></div>")
	v_h_794 = _t1023
	J.F_setTimeout([Callable(self, "_f188").bind(env), 0.0])
	return v_h_794

func _f189(this_, a: Array, env):
	var v_g_800 = null; var v_post_801 = null; var v_s_802 = null
	v_g_800 = J.arg(a, 0)
	v_post_801 = J.arg(a, 1)
	v_s_802 = J.gp(J.gp(J.G.get("POSTS"), v_post_801), "stat")
	return ((J.str(J.gp(J.G.get("STAT_NAMES"), v_s_802)) + " " + J.str(J.mc(J.G.get("F"), "stat", [v_g_800, v_s_802]))) if J.cmp(v_s_802, 0.0, ">=") else ("等級 " + J.str(J.mc(J.G.get("F"), "glv", [v_g_800]))))

func _f191(this_, a: Array, env):
	var v_g_812 = null
	v_g_812 = J.arg(a, 0)
	return (J.mc(J.G.get("F"), "stat", [v_g_812, env["s"]]) if J.cmp(env["s"], 0.0, ">=") else J.mc(J.G.get("F"), "glv", [v_g_812]))

func _f192(this_, a: Array, env):
	var v_g_813 = null
	v_g_813 = J.arg(a, 0)
	var _t1026 = J.gp(J.G.get("GHOSTS"), J.gp(v_g_813, "k"))
	var _t1027 = (J.gp(J.gp(J.G.get("GHOSTS"), J.gp(v_g_813, "k")), "forbid") if J.t(_t1026) else _t1026)
	var _t1028 = (_t1027 if J.t(_t1027) else [])
	return (1.0 if J.t(J.mc(_t1028, "includes", [env["post"]])) else 0.0)

func _f193(this_, a: Array, env):
	var v_g_814 = null
	v_g_814 = J.arg(a, 0)
	var _t1030 = (not J.seq(J.gp(v_g_814, "k"), "afu"))
	return ((not J.seq(J.gp(v_g_814, "post"), env["post"])) if _t1030 else _t1030)

func _f194(this_, a: Array, env):
	var v_a_815 = null; var v_b_816 = null
	v_a_815 = J.arg(a, 0)
	v_b_816 = J.arg(a, 1)
	var _t1032 = env["fbd"]
	var _t1034 = J.cl(_t1032, null, [v_a_815])
	var _t1033 = env["fbd"]
	var _t1038 = J.sub(_t1034, J.cl(_t1033, null, [v_b_816]))
	if not J.t(_t1038):
		var _t1035 = env["val"]
		var _t1037 = J.cl(_t1035, null, [v_b_816])
		var _t1036 = env["val"]
		_t1038 = J.sub(_t1037, J.cl(_t1036, null, [v_a_815]))
	return (_t1038 if J.t(_t1038) else J.sub(J.mc(J.G.get("F"), "glv", [v_b_816]), J.mc(J.G.get("F"), "glv", [v_a_815])))

func _f195(this_, a: Array, env):
	var v_i_819 = null
	v_i_819 = J.arg(a, 0)
	return (not J.seq(v_i_819, env["__p"]["s"]))

func _f196(this_, a: Array, env):
	var v_i_820 = null
	v_i_820 = J.arg(a, 0)
	return J.add(J.gp(J.G.get("STAT_NAMES"), v_i_820), J.mc(J.G.get("F"), "stat", [env["g"], v_i_820]))

func _f197(this_, a: Array, env):
	return J.mc(env["this"], "openBuilding", [env["back"]])

func _f199(this_, a: Array, env):
	var v_g_822 = null; var v_old_823 = null
	var _t1072 = J.G.get("ghostById")
	v_g_822 = J.cl(_t1072, null, [J.gp(J.gp(env["el"], "dataset"), "g")])
	var _t1073 = J.G.get("workersAt")
	if J.cmp(J.len(J.cl(_t1073, null, [env["__p"]["post"]])), J.mc(J.G.get("F"), "slots", [env["__p"]["post"]]), ">="):
		var _t1074 = J.G.get("workersAt")
		v_old_823 = J.gp(J.cl(_t1074, null, [env["__p"]["post"]]), 0.0)
		J.sp(v_old_823, "post", null)
	var _t1075 = env["__p"]["post"]
	J.sp(v_g_822, "post", _t1075)
	J.mc(J.G.get("Quest"), "check", [])
	J.cl(J.G.get("save"), null, [])
	J.mc(J.G.get("UI"), "refresh", [])
	J.mc(env["__p"]["this"], "openBuilding", [env["__p"]["back"]])

func _f198(this_, a: Array, env):
	var _s435 = {"__p": env, "el": null}
	_s435["el"] = J.arg(a, 0)
	var _t1071 = _s435["el"]
	var _t1076 = Callable(self, "_f199").bind(_s435)
	J.sp(_t1071, "onclick", _t1076)
	return _t1076

func _f190(this_, a: Array, env):
	var v_list_810 = null; var v_h_811 = null; var v_fb_818 = null
	var _s425 = {"__p": env, "this": null, "post": null, "back": null, "s": null, "val": null, "fbd": null}
	_s425["this"] = this_
	_s425["post"] = J.arg(a, 0)
	_s425["back"] = J.arg(a, 1)
	_s425["s"] = J.gp(J.gp(J.G.get("POSTS"), _s425["post"]), "stat")
	_s425["val"] = Callable(self, "_f191").bind(_s425)
	_s425["fbd"] = Callable(self, "_f192").bind(_s425)
	var _t1029 = J.gp(J.G.get("S"), "ghosts")
	var _t1031 = J.mc(_t1029, "filter", [Callable(self, "_f193").bind(_s425)])
	v_list_810 = J.mc(_t1031, "sort", [Callable(self, "_f194").bind(_s425)])
	v_h_811 = ("<p class=\"desc\">挑一位去「" + J.str(J.gp(J.gp(J.G.get("POSTS"), _s425["post"]), "name")) + "」。" + (("這份工看【" + J.str(J.gp(J.G.get("STAT_NAMES"), _s425["s"])) + "】。") if J.cmp(_s425["s"], 0.0, ">=") else "這份工看等級。") + "已在別處打工的，會被調過來。</p><p class=\"desc sortnote\">▼ 已按【" + J.str((J.gp(J.G.get("STAT_NAMES"), _s425["s"]) if J.cmp(_s425["s"], 0.0, ">=") else "等級")) + "】由高到低排好</p><div class=\"glist\">")
	for _t1039 in J.iter(v_list_810):
		var _s430 = {"__p": _s425, "g": null}
		_s430["g"] = _t1039
		var _t1040 = J.gp(J.G.get("GHOSTS"), J.gp(_s430["g"], "k"))
		var _t1041 = (J.gp(J.gp(J.G.get("GHOSTS"), J.gp(_s430["g"], "k")), "forbid") if J.t(_t1040) else _t1040)
		var _t1042 = (_t1041 if J.t(_t1041) else [])
		v_fb_818 = J.mc(_t1042, "includes", [_s430["__p"]["post"]])
		var _t1044 = ("dis" if J.t(v_fb_818) else "")
		var _t1045 = J.gp(_s430["g"], "id")
		var _t1046 = J.gp(_s430["g"], "k")
		var _t1047 = J.gp(_s430["g"], "name")
		var _t1048 = J.gp(_s430["g"], "q")
		var _t1049 = J.gp(_s430["g"], "q")
		var _t1050 = (J.gp(J.G.get("STAT_NAMES"), _s430["__p"]["s"]) if J.cmp(_s430["__p"]["s"], 0.0, ">=") else "等級")
		var _t1043 = _s430["__p"]["val"]
		var _t1054 = J.cl(_t1043, null, [_s430["g"]])
		var _t1055 = ((J.add("Lv", J.mc(J.G.get("F"), "glv", [_s430["g"]])) + "　") if J.cmp(_s430["__p"]["s"], 0.0, ">=") else "")
		var _t1051 = [0.0, 1.0, 2.0]
		var _t1052 = J.mc(_t1051, "filter", [Callable(self, "_f195").bind(_s430)])
		var _t1053 = J.mc(_t1052, "map", [Callable(self, "_f196").bind(_s430)])
		var _t1059 = J.mc(_t1053, "join", [" "])
		var _t1058 = null
		if J.t(J.gp(_s430["g"], "post")):
			var _t1056 = J.G.get("postLabel")
			var _t1057 = J.cl(_t1056, null, [J.gp(_s430["g"], "post")])
			_t1058 = J.add("目前：", J.mc(_t1057, "replace", [J.re("^打工：", ""), ""]))
		else:
			_t1058 = "閒著"
		var _t1060 = J.add(v_h_811, ("<div class=\"gi " + _t1044 + "\" data-g=\"" + J.str(_t1045) + "\"><canvas data-por=\"" + J.str(_t1046) + "\"></canvas><div><b>" + J.str(_t1047) + "</b> <i class=\"q q" + J.str(_t1048) + "\">" + J.str(_t1049) + "</i><small><span class=\"keystat\">" + J.str(_t1050) + " " + J.str(_t1054) + "</span>　" + _t1055 + J.str(_t1059) + "</small><small>" + _t1058 + ("　<span class=\"lack\">怕糯米，不肯去</span>" if J.t(v_fb_818) else "") + "</small></div></div>"))
		v_h_811 = _t1060
	if (not J.t(J.len(v_list_810))):
		var _t1061 = J.add(v_h_811, "<p class=\"desc\">沒有可以派的鬼怪。</p>")
		v_h_811 = _t1061
	var _t1062 = J.add(v_h_811, ("</div><button class=\"btn wide\" id=\"pkback\">返回</button>"))
	v_h_811 = _t1062
	J.mc(_s425["this"], "sheet", [("派人：" + J.str(J.gp(J.gp(J.G.get("POSTS"), _s425["post"]), "name"))), v_h_811])
	var _t1063 = J.G.get("paintPortraits")
	var _t1064 = J.G.get("$")
	J.cl(_t1063, null, [J.cl(_t1064, null, ["#sheet"])])
	var _t1065 = J.G.get("$")
	var _t1066 = J.cl(_t1065, null, ["#pkback"])
	var _t1067 = Callable(self, "_f197").bind(_s425)
	J.sp(_t1066, "onclick", _t1067)
	var _t1068 = J.G.get("$")
	var _t1069 = J.cl(_t1068, null, ["#sheet"])
	var _t1070 = J.mc(_t1069, "querySelectorAll", [".gi:not(.dis)"])
	J.mc(_t1070, "forEach", [Callable(self, "_f198").bind(_s425)])

func _f202(this_, a: Array, env):
	var v_k_831 = null
	v_k_831 = J.arg(a, 0)
	return J.mc(J.G.get("N30W"), "owned", [v_k_831])

func _f203(this_, a: Array, env):
	var v_a_832 = null; var v_b_833 = null
	v_a_832 = J.arg(a, 0)
	v_b_833 = J.arg(a, 1)
	var _t1088 = null
	if J.seq(J.gp(v_a_832, "k"), "afu"):
		_t1088 = (-1.0)
	else:
		var _t1087 = null
		if J.seq(J.gp(v_b_833, "k"), "afu"):
			_t1087 = 1.0
		else:
			var _t1086 = ((0.0 if J.seq(J.gp(v_a_832, "q"), "名") else 1.0) - (0.0 if J.seq(J.gp(v_b_833, "q"), "名") else 1.0))
			_t1087 = (_t1086 if J.t(_t1086) else J.sub(J.mc(J.G.get("F"), "glv", [v_b_833]), J.mc(J.G.get("F"), "glv", [v_a_832])))
		_t1088 = _t1087
	return _t1088

func _f204(this_, a: Array, env):
	var v_o_842 = null; var v_v_843 = null
	v_o_842 = J.gp(env["g"], "lv")
	var _t1093 = env["g"]
	var _t1094 = J.add(v_o_842, 1.0)
	J.sp(_t1093, "lv", _t1094)
	v_v_843 = J.mc(J.G.get("GP"), "pow", [env["g"]])
	var _t1095 = env["g"]
	J.sp(_t1095, "lv", v_o_842)
	return v_v_843

func _f201(this_, a: Array, env):
	var v_h_829 = null; var v_order_830 = null; var v_lv_835 = null; var v_cost_836 = null; var v_d_837 = null; var v_sk_838 = null; var v_inTeam_839 = null; var v_gpNow_840 = null; var v_gpNext_841 = null
	var _t1078 = J.mc(J.G.get("F"), "ghostCap", [])
	var _t1079 = J.cl(J.G.get("fodderCount"), null, [])
	var _t1080 = J.mc(J.G.get("F"), "rosterCap", [])
	var _t1077 = J.G.get("fmt")
	var _t1083 = J.cl(_t1077, null, [J.gp(J.gp(J.G.get("S"), "res"), "buns")])
	var _t1084 = J.mc(J.G.get("GP"), "T", ["鬼力會帶到主線戰鬥、陽間站崗、樓裡有鬼、夜班嚇人、運動會等所有玩法：喺村升級、落訓練班練嚇功，出面即刻勁啲。出面打唔過，就返嚟升級。", "鬼力會帶到主線戰鬥、陽間站崗、樓裡有鬼、夜班嚇人、運動會等所有玩法：在村裡升級、去訓練班練嚇功，外面立即變強。外面打不過，就回來升級。"])
	var _t1082 = null
	if (not J.seq(J.typeof_(J.G.get("N30W")), "undefined")):
		var _t1081 = J.mc(J.G.get("N30W"), "ids", [])
		_t1082 = ("<button class=\"btn wide\" id=\"n30cx\">新鬼圖鑑（" + J.str(J.len(J.mc(_t1081, "filter", [Callable(self, "_f202").bind(env)]))) + "/" + J.str(J.len(J.mc(J.G.get("N30W"), "ids", []))) + "）</button>")
	else:
		_t1082 = ""
	v_h_829 = ("<p class=\"desc\">用壽包升級鬼怪。等級上限 " + J.str(_t1078) + "。雜鬼名額 " + J.str(_t1079) + "/" + J.str(_t1080) + "　壽包 " + J.str(_t1083) + "</p><p class=\"desc gp-line\">" + J.str(_t1084) + "</p>" + _t1082 + "<div class=\"glist\">")
	var _t1085 = J.mc(J.gp(J.G.get("S"), "ghosts"), "slice", [])
	v_order_830 = J.mc(_t1085, "sort", [Callable(self, "_f203").bind(env)])
	for _t1089 in J.iter(v_order_830):
		var _s442 = {"__p": env, "g": null}
		_s442["g"] = _t1089
		v_lv_835 = J.mc(J.G.get("F"), "glv", [_s442["g"]])
		v_cost_836 = J.mc(J.G.get("F"), "lvCost", [v_lv_835])
		var _t1090 = J.G.get("gdef")
		v_d_837 = J.cl(_t1090, null, [_s442["g"]])
		v_sk_838 = J.gp(J.G.get("SKILLS"), J.gp(_s442["g"], "k"))
		var _t1091 = J.gp(J.G.get("S"), "team")
		v_inTeam_839 = ("出陣" if J.t(J.mc(_t1091, "includes", [J.gp(_s442["g"], "id")])) else ("軍師" if J.seq(J.gp(J.G.get("S"), "adviser"), J.gp(_s442["g"], "id")) else ""))
		v_gpNow_840 = J.mc(J.G.get("GP"), "pow", [_s442["g"]])
		var _t1092 = (not J.seq(J.gp(_s442["g"], "k"), "afu"))
		v_gpNext_841 = (J.cl(Callable(self, "_f204").bind(_s442), null, []) if (J.cmp(v_lv_835, J.mc(J.G.get("F"), "ghostCap", []), "<") if _t1092 else _t1092) else null)
		var _t1099 = J.gp(_s442["g"], "k")
		var _t1100 = J.gp(_s442["g"], "name")
		var _t1101 = J.gp(_s442["g"], "q")
		var _t1102 = J.gp(_s442["g"], "q")
		var _t1103 = (("<i class=\"tag\">" + J.str(v_inTeam_839) + "</i>") if J.t(v_inTeam_839) else "")
		var _t1104 = (J.add(J.gp(J.gp(J.G.get("GHOSTS"), J.gp(_s442["g"], "k")), "title"), "　") if J.t(J.gp(J.G.get("GHOSTS"), J.gp(_s442["g"], "k"))) else "")
		var _t1105 = J.mc(J.G.get("F"), "stat", [_s442["g"], 0.0])
		var _t1106 = J.mc(J.G.get("F"), "stat", [_s442["g"], 1.0])
		var _t1107 = J.mc(J.G.get("F"), "stat", [_s442["g"], 2.0])
		var _t1108 = ("遠程" if J.seq(J.gp(v_d_837, "range"), "ranged") else "近戰")
		var _t1109 = J.mc(J.G.get("GP"), "T", ["鬼力", "鬼力"])
		var _t1110 = (("　" + J.str(J.mc(J.G.get("GP"), "T", ["升級後", "升級後"])) + " <b class=\"gp-up\">" + J.str(v_gpNext_841) + "</b>（+" + J.str(J.sub(v_gpNext_841, v_gpNow_840)) + "）") if J.t(v_gpNext_841) else "")
		var _t1111 = (("　" + J.str(J.mc(J.G.get("GP"), "T", ["嚇功", "嚇功"])) + " Lv" + J.str(J.mc(J.G.get("Rework"), "drillLv", [J.gp(_s442["g"], "k")]))) if (not J.seq(J.typeof_(J.G.get("Rework")), "undefined")) else "")
		var _t1112 = J.gp(v_sk_838, "name")
		var _t1113 = J.gp(v_sk_838, "desc")
		var _t1098 = null
		if J.t(J.gp(J.G.get("GHOSTS"), J.gp(_s442["g"], "k"))):
			var _t1097 = null
			if J.seq(J.typeof_(J.G.get("L")), "function"):
				var _t1096 = J.G.get("L")
				_t1097 = J.cl(_t1096, null, [J.gp(J.gp(J.G.get("GHOSTS"), J.gp(_s442["g"], "k")), "trait")])
			else:
				_t1097 = J.gp(J.gp(J.G.get("GHOSTS"), J.gp(_s442["g"], "k")), "trait")
			_t1098 = ("<small class=\"tr\">" + J.str(_t1097) + "</small>")
		else:
			_t1098 = ""
		var _t1114 = J.gp(J.G.get("GHOSTS"), J.gp(_s442["g"], "k"))
		var _t1117 = (("<small class=\"tr\">" + J.str(J.gp(J.gp(J.G.get("GHOSTS"), J.gp(_s442["g"], "k")), "lore")) + "</small>") if J.t((J.gp(J.gp(J.G.get("GHOSTS"), J.gp(_s442["g"], "k")), "lore") if J.t(_t1114) else _t1114)) else "")
		var _t1116 = null
		if J.t(J.gp(_s442["g"], "post")):
			var _t1115 = J.G.get("postLabel")
			_t1116 = J.cl(_t1115, null, [J.gp(_s442["g"], "post")])
		else:
			_t1116 = ("主公本人" if J.seq(J.gp(_s442["g"], "k"), "afu") else "閒著")
		var _t1119 = ("<small>隨主公等級成長</small>" if J.seq(J.gp(_s442["g"], "k"), "afu") else (("<button class=\"btn sm gold\" data-up=\"" + J.str(J.gp(_s442["g"], "id")) + "\" " + ("" if J.cmp(J.gp(J.gp(J.G.get("S"), "res"), "buns"), v_cost_836, ">=") else "disabled") + ">升級<br><small>壽包 " + J.str(v_cost_836) + "</small></button>") if J.cmp(v_lv_835, J.mc(J.G.get("F"), "ghostCap", []), "<") else "<small>已達上限</small>"))
		var _t1118 = (not J.seq(J.gp(_s442["g"], "q"), "名"))
		var _t1120 = J.add(v_h_829, ("<div class=\"gcard\"><canvas data-por=\"" + J.str(_t1099) + "\"></canvas><div class=\"gc-main\"><div><b>" + J.str(_t1100) + "</b> <i class=\"q q" + J.str(_t1101) + "\">" + J.str(_t1102) + "</i> <span class=\"lvl\">Lv" + J.str(v_lv_835) + "</span> " + _t1103 + "</div>\n          <small>" + _t1104 + "力 " + J.str(_t1105) + "　智 " + J.str(_t1106) + "　武 " + J.str(_t1107) + "　" + _t1108 + "</small>\n          <small class=\"gp-row\">" + J.str(_t1109) + " <b>" + J.str(v_gpNow_840) + "</b>" + _t1110 + _t1111 + "</small>\n          <small class=\"sk\">【" + J.str(_t1112) + "】" + J.str(_t1113) + "</small>\n          " + _t1098 + _t1117 + "\n          <small>" + J.str(_t1116) + "</small></div>\n          <div class=\"gc-act\">" + _t1119 + "\n          " + (("<button class=\"btn sm ghost\" data-rel=\"" + J.str(J.gp(_s442["g"], "id")) + "\">送去投胎</button>") if ((not J.seq(J.gp(_s442["g"], "q"), "主")) if _t1118 else _t1118) else "") + "</div></div>"))
		v_h_829 = _t1120
	return J.add(v_h_829, "</div>")

func _f207(this_, a: Array, env):
	var v_g_846 = null; var v_c_847 = null
	var _t1125 = J.G.get("ghostById")
	v_g_846 = J.cl(_t1125, null, [J.gp(J.gp(env["b"], "dataset"), "up")])
	v_c_847 = J.mc(J.G.get("F"), "lvCost", [J.gp(v_g_846, "lv")])
	if J.cmp(J.gp(J.gp(J.G.get("S"), "res"), "buns"), v_c_847, "<"):
		return null
	var _t1126 = J.gp(J.G.get("S"), "res")
	var _t1127 = J.sub(J.gp(_t1126, "buns"), v_c_847)
	J.sp(_t1126, "buns", _t1127)
	var _t1128 = J.add(J.gp(v_g_846, "spent"), v_c_847)
	J.sp(v_g_846, "spent", _t1128)
	J.sp(v_g_846, "lv", J.num(J.gp(v_g_846, "lv")) + 1.0)
	var _t1129 = J.G.get("gainExp")
	J.cl(_t1129, null, [2.0])
	J.mc(J.G.get("Quest"), "check", [])
	J.cl(J.G.get("save"), null, [])
	J.mc(J.G.get("UI"), "refresh", [])
	J.cl(env["__p"]["re"], null, [])

func _f206(this_, a: Array, env):
	var _s446 = {"__p": env, "b": null}
	_s446["b"] = J.arg(a, 0)
	var _t1124 = _s446["b"]
	var _t1130 = Callable(self, "_f207").bind(_s446)
	J.sp(_t1124, "onclick", _t1130)
	return _t1130

func _f210(this_, a: Array, env):
	var v_x_851 = null
	v_x_851 = J.arg(a, 0)
	return (not J.seq(v_x_851, env["g"]))

func _f211(this_, a: Array, env):
	var v_x_852 = null
	v_x_852 = J.arg(a, 0)
	return (null if J.seq(v_x_852, J.gp(env["g"], "id")) else v_x_852)

func _f209(this_, a: Array, env):
	var v_back_850 = null
	var _s449 = {"__p": env, "g": null}
	var _t1135 = J.G.get("ghostById")
	_s449["g"] = J.cl(_t1135, null, [J.gp(J.gp(_s449["__p"]["b"], "dataset"), "rel")])
	var _t1136 = J.G.get("confirmInline")
	if (not J.t(J.cl(_t1136, null, [_s449["__p"]["b"], "確定？"]))):
		return null
	v_back_850 = floor(J.num(J.mul(J.gp(_s449["g"], "spent"), 0.6)))
	var _t1137 = J.gp(J.G.get("S"), "res")
	var _t1138 = J.add(J.gp(_t1137, "buns"), v_back_850)
	J.sp(_t1137, "buns", _t1138)
	var _t1139 = J.G.get("S")
	var _t1140 = J.gp(J.G.get("S"), "ghosts")
	var _t1141 = J.mc(_t1140, "filter", [Callable(self, "_f210").bind(_s449)])
	J.sp(_t1139, "ghosts", _t1141)
	var _t1142 = J.G.get("S")
	var _t1143 = J.gp(J.G.get("S"), "team")
	var _t1144 = J.mc(_t1143, "map", [Callable(self, "_f211").bind(_s449)])
	J.sp(_t1142, "team", _t1144)
	if J.seq(J.gp(J.G.get("S"), "adviser"), J.gp(_s449["g"], "id")):
		var _t1145 = J.G.get("S")
		J.sp(_t1145, "adviser", null)
	J.mc(J.G.get("Fx"), "toast", [(J.str(J.gp(_s449["g"], "name")) + " 去投胎了。退回 壽包 " + J.str(v_back_850))])
	J.cl(J.G.get("save"), null, [])
	J.mc(J.G.get("UI"), "refresh", [])
	J.cl(_s449["__p"]["__p"]["re"], null, [])

func _f208(this_, a: Array, env):
	var _s448 = {"__p": env, "b": null}
	_s448["b"] = J.arg(a, 0)
	var _t1134 = _s448["b"]
	var _t1146 = Callable(self, "_f209").bind(_s448)
	J.sp(_t1134, "onclick", _t1146)
	return _t1146

func _f212(this_, a: Array, env):
	return J.mc(J.G.get("N30W"), "openCodex", [])

func _f205(this_, a: Array, env):
	var v_cx_844 = null
	var _t1121 = J.G.get("$")
	var _t1122 = J.cl(_t1121, null, ["#sheet"])
	var _t1123 = J.mc(_t1122, "querySelectorAll", ["[data-up]"])
	J.mc(_t1123, "forEach", [Callable(self, "_f206").bind(env)])
	var _t1131 = J.G.get("$")
	var _t1132 = J.cl(_t1131, null, ["#sheet"])
	var _t1133 = J.mc(_t1132, "querySelectorAll", ["[data-rel]"])
	J.mc(_t1133, "forEach", [Callable(self, "_f208").bind(env)])
	var _t1147 = J.G.get("paintPortraits")
	var _t1148 = J.G.get("$")
	J.cl(_t1147, null, [J.cl(_t1148, null, ["#sheet"])])
	var _t1149 = J.G.get("$")
	v_cx_844 = J.cl(_t1149, null, ["#n30cx"])
	if J.t(v_cx_844):
		var _t1150 = Callable(self, "_f212").bind(env)
		J.sp(v_cx_844, "onclick", _t1150)

func _f213(this_, a: Array, env):
	var v_sc_853 = null
	var _t1151 = J.G.get("$")
	v_sc_853 = J.gp(J.cl(_t1151, null, ["#sheet .sh-body"]), "scrollTop")
	var _t1152 = J.G.get("$")
	var _t1153 = J.cl(_t1152, null, ["#sheet .sh-body"])
	var _t1154 = J.cl(env["render"], null, [])
	J.sp(_t1153, "innerHTML", _t1154)
	J.cl(env["bind"], null, [])
	var _t1155 = J.G.get("$")
	var _t1156 = J.cl(_t1155, null, ["#sheet .sh-body"])
	J.sp(_t1156, "scrollTop", v_sc_853)

func _f200(this_, a: Array, env):
	var _s438 = {"__p": env, "render": null, "bind": null, "re": null}
	_s438["render"] = Callable(self, "_f201").bind(_s438)
	_s438["bind"] = Callable(self, "_f205").bind(_s438)
	_s438["re"] = Callable(self, "_f213").bind(_s438)
	J.mc(this_, "sheet", ["鬼怪名冊", J.cl(_s438["render"], null, [])])
	J.cl(_s438["bind"], null, [])
	var _t1157 = this_
	J.sp(_t1157, "sheetRefresh", null)

func _f215(this_, a: Array, env):
	var v_C_858 = null; var v_h_859 = null; var v_k_860 = null; var v_n_861 = null; var v_d_862 = null
	v_C_858 = [["g", "綠箱", "壽包", ("開出 壽包 " + J.str(J.gp(J.mc(J.G.get("F"), "chestGain", ["g"]), "buns")) + "（隨包子鋪等級提升）")], ["b", "藍箱", "棺材板", ("開出 棺材板 " + J.str(J.gp(J.mc(J.G.get("F"), "chestGain", ["b"]), "planks")) + "（隨棺材鋪等級提升）")], ["p", "紫箱", "冥幣", ("開出 冥幣 " + J.str(J.gp(J.mc(J.G.get("F"), "chestGain", ["p"]), "coins")) + "（隨鬼宅等級提升）")]]
	v_h_859 = ("<p class=\"desc\">小提示：箱子不會過期。先把對應的建築升高，再開，收穫更多。</p>")
	for _t1158 in J.iter(v_C_858):
		var _t1159 = J.gp(_t1158, 0.0)
		v_k_860 = _t1159
		var _t1160 = J.gp(_t1158, 1.0)
		v_n_861 = _t1160
		var _t1161 = J.gp(_t1158, 3.0)
		v_d_862 = _t1161
		var _t1162 = J.add(v_h_859, ("<div class=\"row chest\"><span class=\"cb k-" + J.str(v_k_860) + "\"></span><span><b>" + J.str(v_n_861) + " ×" + J.str(J.gp(J.gp(J.G.get("S"), "chests"), v_k_860)) + "</b><br><small>" + J.str(v_d_862) + "</small></span><span class=\"btns\"><button class=\"btn sm gold\" data-open=\"" + J.str(v_k_860) + "\" data-n=\"1\" " + ("" if J.t(J.gp(J.gp(J.G.get("S"), "chests"), v_k_860)) else "disabled") + ">開 1</button><button class=\"btn sm\" data-open=\"" + J.str(v_k_860) + "\" data-n=\"all\" " + ("" if J.cmp(J.gp(J.gp(J.G.get("S"), "chests"), v_k_860), 1.0, ">") else "disabled") + ">全開</button></span></div>"))
		v_h_859 = _t1162
	return v_h_859

func _f218(this_, a: Array, env):
	var v_k_864 = null; var v_n_865 = null; var v_tot_866 = null; var v_i_867 = null; var v_g_868 = null; var v_r_869 = null
	v_k_864 = J.gp(J.gp(env["b"], "dataset"), "open")
	v_n_865 = (J.gp(J.gp(J.G.get("S"), "chests"), v_k_864) if J.seq(J.gp(J.gp(env["b"], "dataset"), "n"), "all") else 1.0)
	v_tot_866 = {}
	v_i_867 = 0.0
	while true:
		if not J.cmp(v_i_867, v_n_865, "<"): break
		v_g_868 = J.mc(J.G.get("F"), "chestGain", [v_k_864])
		for _t1167 in J.keys(v_g_868):
			v_r_869 = _t1167
			var _t1168 = J.gp(v_tot_866, v_r_869)
			var _t1169 = J.add((_t1168 if J.t(_t1168) else 0.0), J.gp(v_g_868, v_r_869))
			J.sp(v_tot_866, v_r_869, _t1169)
		v_i_867 = J.num(v_i_867) + 1.0
	J.mc(J.G.get("Sound"), "play", ["chest"])
	var _t1170 = J.gp(J.G.get("S"), "chests")
	var _t1171 = J.sub(J.gp(_t1170, v_k_864), v_n_865)
	J.sp(_t1170, v_k_864, _t1171)
	var _t1172 = J.gp(J.G.get("S"), "cnt")
	var _t1173 = J.add(J.gp(_t1172, "chest"), v_n_865)
	J.sp(_t1172, "chest", _t1173)
	var _t1174 = J.G.get("give")
	J.mc(J.G.get("Fx"), "toast", [("開箱：" + J.str(J.cl(_t1174, null, [v_tot_866])))])
	J.cl(J.G.get("save"), null, [])
	J.mc(J.G.get("UI"), "refresh", [])
	var _t1175 = J.G.get("$")
	var _t1176 = J.cl(_t1175, null, ["#sheet .sh-body"])
	var _t1177 = J.cl(env["__p"]["render"], null, [])
	J.sp(_t1176, "innerHTML", _t1177)
	J.cl(env["__p"]["bind"], null, [])

func _f217(this_, a: Array, env):
	var _s458 = {"__p": env, "b": null}
	_s458["b"] = J.arg(a, 0)
	var _t1166 = _s458["b"]
	var _t1178 = Callable(self, "_f218").bind(_s458)
	J.sp(_t1166, "onclick", _t1178)
	return _t1178

func _f216(this_, a: Array, env):
	var _t1163 = J.G.get("$")
	var _t1164 = J.cl(_t1163, null, ["#sheet"])
	var _t1165 = J.mc(_t1164, "querySelectorAll", ["[data-open]"])
	return J.mc(_t1165, "forEach", [Callable(self, "_f217").bind(env)])

func _f214(this_, a: Array, env):
	var _s454 = {"__p": env, "render": null, "bind": null}
	_s454["render"] = Callable(self, "_f215").bind(_s454)
	_s454["bind"] = Callable(self, "_f216").bind(_s454)
	J.mc(this_, "sheet", ["箱子", J.cl(_s454["render"], null, [])])
	J.cl(_s454["bind"], null, [])

func _f221(this_, a: Array, env):
	var v_id_879 = null
	v_id_879 = J.arg(a, 0)
	return J.gp(J.gp(J.G.get("S"), "seen"), v_id_879)

func _f220(this_, a: Array, env):
	var v_name_875 = null; var v_ids_876 = null; var v_i_877 = null; var v_ok_878 = null
	var _t1179 = J.gp(J.arg(a, 0), 0.0)
	v_name_875 = _t1179
	var _t1180 = J.gp(J.arg(a, 0), 1.0)
	v_ids_876 = _t1180
	v_i_877 = J.arg(a, 1)
	v_ok_878 = J.mc(v_ids_876, "some", [Callable(self, "_f221").bind(env)])
	var _t1181 = J.add(env["h"], ("<button class=\"btn wide " + ("" if J.t(v_ok_878) else "ghost") + "\" data-sc=\"" + J.str(v_i_877) + "\" " + ("" if J.t(v_ok_878) else "disabled") + ">" + J.str((v_name_875 if J.t(v_ok_878) else "？？？")) + "</button>"))
	env["h"] = _t1181

func _f222(this_, a: Array, env):
	var v_st_880 = null; var v_i_881 = null; var v_ok_882 = null
	v_st_880 = J.arg(a, 0)
	v_i_881 = J.arg(a, 1)
	var _t1183 = J.G.get("standOk")
	v_ok_882 = J.cl(_t1183, null, [v_st_880])
	var _t1184 = J.add(env["h"], ("<button class=\"btn wide " + ("" if J.t(v_ok_882) else "ghost") + "\" data-st=\"" + J.str(v_i_881) + "\" " + ("" if J.t(v_ok_882) else "disabled") + ">" + (("<small>" + J.str(J.gp(v_st_880, "who")) + "</small>　" + J.str(J.gp(v_st_880, "title"))) if J.t(v_ok_882) else (J.add("？？？（", J.gp(v_st_880, "hint")) + "）")) + "</button>"))
	env["h"] = _t1184

func _f223(this_, a: Array, env):
	var v_best_883 = null; var v_k_884 = null; var v_o_885 = null; var v_e_886 = null
	v_best_883 = null
	for _t1185 in J.iter(["_hi", "_bak", "_del"]):
		v_k_884 = _t1185
		var _t1186 = J.S_localStorage_("getItem", [J.add(J.G.get("SAVE_KEY"), v_k_884)])
		v_o_885 = J.S_JSON_("parse", [(_t1186 if J.t(_t1186) else "null")])
		var _t1190 = v_o_885
		if J.t(_t1190):
			var _t1187 = J.gp(v_o_885, "lv")
			var _t1189 = (_t1187 if J.t(_t1187) else 1.0)
			var _t1188 = J.gp(J.G.get("S"), "lv")
			_t1190 = J.cmp(_t1189, (_t1188 if J.t(_t1188) else 1.0), ">")
		var _t1192 = _t1190
		if J.t(_t1192):
			var _t1191 = (not J.t(v_best_883))
			_t1192 = (_t1191 if _t1191 else J.cmp(J.gp(v_o_885, "lv"), J.gp(J.gp(v_best_883, "o"), "lv"), ">"))
		if J.t(_t1192):
			var _t1193 = {"k": v_k_884, "o": v_o_885}
			v_best_883 = _t1193
	return (("<button class=\"btn wide gold\" id=\"restorebtn\" data-k=\"" + J.str(J.gp(v_best_883, "k")) + "\">恢復備份存檔（主公 " + J.str(J.gp(J.gp(v_best_883, "o"), "lv")) + " 級）</button>") if J.t(v_best_883) else "")

func _f226(this_, a: Array, env):
	var v_id_888 = null
	v_id_888 = J.arg(a, 0)
	return J.gp(J.gp(J.G.get("S"), "seen"), v_id_888)

func _f227(this_, a: Array, env):
	var v_id_889 = null
	v_id_889 = J.arg(a, 0)
	return J.mc(J.G.get("Story"), "queue", [v_id_889])

func _f225(this_, a: Array, env):
	J.mc(env["__p"]["this"], "close", [])
	var _t1199 = J.gp(J.gp(J.G.get("SCENE_ORDER"), J.num(J.gp(J.gp(env["b"], "dataset"), "sc"))), 1.0)
	var _t1200 = J.mc(_t1199, "filter", [Callable(self, "_f226").bind(env)])
	J.mc(_t1200, "forEach", [Callable(self, "_f227").bind(env)])

func _f224(this_, a: Array, env):
	var _s473 = {"__p": env, "b": null}
	_s473["b"] = J.arg(a, 0)
	var _t1198 = _s473["b"]
	var _t1201 = Callable(self, "_f225").bind(_s473)
	J.sp(_t1198, "onclick", _t1201)
	return _t1201

func _f229(this_, a: Array, env):
	var v_st_891 = null
	J.mc(env["__p"]["this"], "close", [])
	v_st_891 = J.gp(J.G.get("STANDUP"), J.num(J.gp(J.gp(env["b"], "dataset"), "st")))
	J.mc(J.G.get("Story"), "queue", [{"style": "talk", "bg": J.gp(v_st_891, "bg"), "mic": true, "title": J.gp(v_st_891, "title"), "lines": J.spread([J.SP(J.gp(v_st_891, "lines")), ["旁白", J.gp(v_st_891, "end")]])}])

func _f228(this_, a: Array, env):
	var _s477 = {"__p": env, "b": null}
	_s477["b"] = J.arg(a, 0)
	var _t1205 = _s477["b"]
	var _t1206 = Callable(self, "_f229").bind(_s477)
	J.sp(_t1205, "onclick", _t1206)
	return _t1206

func _f230(this_, a: Array, env):
	J.mc(env["this"], "close", [])
	J.mc(J.G.get("Web"), "installGuide", [false])

func _f231(this_, a: Array, env):
	J.mc(env["this"], "close", [])
	J.mc(J.G.get("Phone"), "home", ["post"])

func _f232(this_, a: Array, env):
	var v_e_892 = null; var v_on_893 = null
	v_e_892 = J.arg(a, 0)
	v_on_893 = J.mc(J.G.get("Sound"), "toggle", [])
	var _t1214 = J.gp(v_e_892, "target")
	var _t1215 = ("聲音：" + ("開" if J.t(v_on_893) else "關"))
	J.sp(_t1214, "textContent", _t1215)
	J.cl(J.G.get("syncSnd"), null, [])

func _f233(this_, a: Array, env):
	var v_e_894 = null; var v_er_895 = null
	v_e_894 = J.arg(a, 0)
	var _t1219 = J.G.get("confirmInline")
	if (not J.t(J.cl(_t1219, null, [J.gp(v_e_894, "target"), "再按一次確定刪檔"]))):
		return null
	var _t1221 = J.add(J.G.get("SAVE_KEY"), "_del")
	var _t1220 = J.S_localStorage_("getItem", [J.G.get("SAVE_KEY")])
	J.S_localStorage_("setItem", [_t1221, (_t1220 if J.t(_t1220) else "")])
	J.S_localStorage_("removeItem", [J.G.get("SAVE_KEY")])
	J.S_location_("reload", [])

func _f235(this_, a: Array, env):
	return J.mc(J.G.get("Fx"), "toast", ["存檔碼已複製，貼去記事本或者 WhatsApp 自己收好"])

func _f236(this_, a: Array, env):
	var _t1227 = J.G.get("$")
	var _t1228 = J.cl(_t1227, null, ["#impbox"])
	J.sp(_t1228, "hidden", false)
	var _t1229 = J.G.get("$")
	var _t1230 = J.cl(_t1229, null, ["#impta"])
	var _t1231 = env["code"]
	J.sp(_t1230, "value", _t1231)
	var _t1232 = J.G.get("$")
	J.mc(J.cl(_t1232, null, ["#impta"]), "select", [])
	J.mc(J.G.get("Fx"), "toast", ["自己長按複製呢段存檔碼"])

func _f234(this_, a: Array, env):
	var v_done_897 = null; var v_er_898 = null
	var _s486 = {"__p": env, "code": null}
	J.cl(J.G.get("save"), null, [])
	_s486["code"] = J.mc(J.G.get("Web"), "enc", [J.G.get("S")])
	v_done_897 = Callable(self, "_f235").bind(_s486)
	var _t1225 = J.gp(J.G.get("navigator"), "clipboard")
	var _t1226 = J.mc(_t1225, "writeText", [_s486["code"]])
	J.mc(_t1226, "then", [v_done_897, Callable(self, "_f236").bind(_s486)])

func _f237(this_, a: Array, env):
	var _t1236 = J.G.get("$")
	var _t1237 = J.cl(_t1236, null, ["#impbox"])
	J.sp(_t1237, "hidden", false)
	var _t1238 = J.G.get("$")
	var _t1239 = J.cl(_t1238, null, ["#impta"])
	J.sp(_t1239, "value", "")
	var _t1240 = J.G.get("$")
	J.mc(J.cl(_t1240, null, ["#impta"]), "focus", [])

func _f238(this_, a: Array, env):
	var v_e_899 = null; var v_o_900 = null; var v_er_901 = null; var v_er_902 = null
	v_e_899 = J.arg(a, 0)
	v_o_900 = null
	var _t1244 = J.G.get("$")
	var _t1245 = J.mc(J.gp(J.cl(_t1244, null, ["#impta"]), "value"), "trim", [])
	var _t1246 = J.mc(J.G.get("Web"), "dec", [J.mc(_t1245, "replace", [J.re("^.*#save=", ""), ""])])
	v_o_900 = _t1246
	var _t1247 = (not J.t(v_o_900))
	if (_t1247 if _t1247 else (not J.t(J.gp(v_o_900, "res")))):
		J.mc(J.G.get("Fx"), "toast", ["存檔碼讀唔到，檢查吓有冇貼齊"])
		return null
	var _t1248 = J.G.get("confirmInline")
	var _t1250 = J.gp(v_e_899, "target")
	var _t1249 = J.gp(v_o_900, "lv")
	if (not J.t(J.cl(_t1248, null, [_t1250, ("再按一次：換成主公 " + J.str((_t1249 if J.t(_t1249) else 1.0)) + " 級嘅存檔")]))):
		return null
	var _t1252 = J.add(J.G.get("SAVE_KEY"), "_bak")
	var _t1251 = J.S_localStorage_("getItem", [J.G.get("SAVE_KEY")])
	J.S_localStorage_("setItem", [_t1252, (_t1251 if J.t(_t1251) else "")])
	J.S_window_("removeEventListener", ["beforeunload", J.G.get("save")])
	var _t1253 = J.S_Date_("now", [])
	J.sp(v_o_900, "last", _t1253)
	J.S_localStorage_("setItem", [J.G.get("SAVE_KEY"), J.S_JSON_("stringify", [v_o_900])])
	var _t1254 = J.G.get("window")
	J.sp(_t1254, "__NOSAVE", 1.0)
	J.S_location_("reload", [])

func _f239(this_, a: Array, env):
	var v_e_903 = null; var v_k_904 = null; var v_v_905 = null; var v_er_906 = null
	v_e_903 = J.arg(a, 0)
	var _t1258 = J.G.get("confirmInline")
	if (not J.t(J.cl(_t1258, null, [J.gp(v_e_903, "target"), "再按一次確定恢復"]))):
		return null
	v_k_904 = J.add(J.G.get("SAVE_KEY"), J.gp(J.gp(env["rb"], "dataset"), "k"))
	v_v_905 = J.S_localStorage_("getItem", [v_k_904])
	var _t1260 = J.add(J.G.get("SAVE_KEY"), "_bak")
	var _t1259 = J.S_localStorage_("getItem", [J.G.get("SAVE_KEY")])
	J.S_localStorage_("setItem", [_t1260, (_t1259 if J.t(_t1259) else "")])
	J.S_window_("removeEventListener", ["beforeunload", J.G.get("save")])
	J.S_localStorage_("setItem", [J.G.get("SAVE_KEY"), v_v_905])
	var _t1261 = J.G.get("window")
	J.sp(_t1261, "__NOSAVE", 1.0)
	J.S_location_("reload", [])

func _f219(this_, a: Array, env):
	var v_ib_873 = null
	var _s463 = {"__p": env, "this": null, "h": null, "rb": null}
	_s463["this"] = this_
	_s463["h"] = "<p class=\"desc\">看過的劇情，可以在這裡重溫。</p><div class=\"slist\">"
	J.mc(J.G.get("SCENE_ORDER"), "forEach", [Callable(self, "_f220").bind(_s463)])
	var _t1182 = J.add(_s463["h"], "</div><h4 class=\"stand-h\">開麥之夜・陰間脫口秀</h4><p class=\"desc\">村裡的鬼，入了村就能上台。</p><div class=\"slist\">")
	_s463["h"] = _t1182
	J.mc(J.G.get("STANDUP"), "forEach", [Callable(self, "_f222").bind(_s463)])
	var _t1194 = J.add(_s463["h"], ("</div><hr>" + ("<button class=\"btn wide gold\" id=\"instbtn\">放到手機桌面（自動更新）</button>" if J.t(((not J.t(J.cl(J.G.get("isStandalone"), null, []))) if J.t(J.G.get("IS_WEB")) else J.G.get("IS_WEB"))) else "") + "<button class=\"btn wide\" id=\"phonebtn\">看手機</button><button class=\"btn wide\" id=\"sndbtn\">聲音：" + ("開" if J.t(J.mc(J.G.get("Sound"), "isOn", [])) else "關") + "</button><button class=\"btn wide\" id=\"expbtn\">備份存檔（複製存檔碼）</button><button class=\"btn wide\" id=\"impbtn\">導入存檔碼</button><div id=\"impbox\" hidden><textarea id=\"impta\" rows=\"4\" style=\"width:100%;font-size:14px\" placeholder=\"貼上存檔碼\"></textarea><button class=\"btn wide gold\" id=\"impgo\">確定導入</button></div><button class=\"btn wide ghost\" id=\"resetbtn\">重新開始（刪除存檔）</button>" + J.str(J.cl(Callable(self, "_f223").bind(_s463), null, []))))
	_s463["h"] = _t1194
	J.mc(_s463["this"], "sheet", ["劇情", _s463["h"]])
	var _t1195 = J.G.get("$")
	var _t1196 = J.cl(_t1195, null, ["#sheet"])
	var _t1197 = J.mc(_t1196, "querySelectorAll", ["[data-sc]"])
	J.mc(_t1197, "forEach", [Callable(self, "_f224").bind(_s463)])
	var _t1202 = J.G.get("$")
	var _t1203 = J.cl(_t1202, null, ["#sheet"])
	var _t1204 = J.mc(_t1203, "querySelectorAll", ["[data-st]"])
	J.mc(_t1204, "forEach", [Callable(self, "_f228").bind(_s463)])
	var _t1207 = J.G.get("$")
	v_ib_873 = J.cl(_t1207, null, ["#instbtn"])
	if J.t(v_ib_873):
		var _t1208 = Callable(self, "_f230").bind(_s463)
		J.sp(v_ib_873, "onclick", _t1208)
	var _t1209 = J.G.get("$")
	var _t1210 = J.cl(_t1209, null, ["#phonebtn"])
	var _t1211 = Callable(self, "_f231").bind(_s463)
	J.sp(_t1210, "onclick", _t1211)
	var _t1212 = J.G.get("$")
	var _t1213 = J.cl(_t1212, null, ["#sndbtn"])
	var _t1216 = Callable(self, "_f232").bind(_s463)
	J.sp(_t1213, "onclick", _t1216)
	var _t1217 = J.G.get("$")
	var _t1218 = J.cl(_t1217, null, ["#resetbtn"])
	var _t1222 = Callable(self, "_f233").bind(_s463)
	J.sp(_t1218, "onclick", _t1222)
	var _t1223 = J.G.get("$")
	var _t1224 = J.cl(_t1223, null, ["#expbtn"])
	var _t1233 = Callable(self, "_f234").bind(_s463)
	J.sp(_t1224, "onclick", _t1233)
	var _t1234 = J.G.get("$")
	var _t1235 = J.cl(_t1234, null, ["#impbtn"])
	var _t1241 = Callable(self, "_f237").bind(_s463)
	J.sp(_t1235, "onclick", _t1241)
	var _t1242 = J.G.get("$")
	var _t1243 = J.cl(_t1242, null, ["#impgo"])
	var _t1255 = Callable(self, "_f238").bind(_s463)
	J.sp(_t1243, "onclick", _t1255)
	var _t1256 = J.G.get("$")
	_s463["rb"] = J.cl(_t1256, null, ["#restorebtn"])
	if J.t(_s463["rb"]):
		var _t1257 = _s463["rb"]
		var _t1262 = Callable(self, "_f239").bind(_s463)
		J.sp(_t1257, "onclick", _t1262)

func _f240(this_, a: Array, env):
	J.mc(J.G.get("Battle"), "openSelect", [])
