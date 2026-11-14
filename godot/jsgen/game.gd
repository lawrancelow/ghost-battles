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
	J.G["groundLayer"] = Callable(self, "_f114").bind(env)
	J.G["drawLily"] = Callable(self, "_f118").bind(env)
	J.G["bldUnlocked"] = Callable(self, "_f119").bind(env)
	J.G["furnaceReady"] = Callable(self, "_f121").bind(env)
	J.G["paintBg"] = Callable(self, "_f168").bind(env)
	J.G["postLabel"] = Callable(self, "_f169").bind(env)
	J.G["standOk"] = Callable(self, "_f245").bind(env)
	J.G["syncSnd"] = Callable(self, "_f246").bind(env)
	J.G["confirmInline"] = Callable(self, "_f247").bind(env)
	J.G["paintPortraits"] = Callable(self, "_f249").bind(env)
	J.G["recruitFodder"] = Callable(self, "_f251").bind(env)
	J.G["covered"] = Callable(self, "_f255").bind(env)
	J.G["loop"] = Callable(self, "_f256").bind(env)
	J.G["offlineGain"] = Callable(self, "_f257").bind(env)
	J.G["start"] = Callable(self, "_f258").bind(env)
	J.G["startGame"] = Callable(self, "_f261").bind(env)
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
	J.G["Village"] = {"cvs": null, "ctx": null, "camY": 0.0, "w": 390.0, "h": 600.0, "dpr": 1.0, "t": 0.0, "hero": {"x": 195.0, "y": 350.0, "tx": 195.0, "ty": 350.0, "dir": 1.0, "act": null, "actT": 0.0, "target": null}, "floats": [], "crows": [], "feathers": [], "drag": null, "workerPhase": {}, "vis": [], "bubble": null, "chatT": 6.0, "chatUsed": {}, "init": Callable(self, "_f54").bind(env), "resize": Callable(self, "_f60").bind(env), "setCam": Callable(self, "_f61").bind(env), "pt": Callable(self, "_f62").bind(env), "focus": Callable(self, "_f63").bind(env), "hitTest": Callable(self, "_f64").bind(env), "tap": Callable(self, "_f65").bind(env), "walkTo": Callable(self, "_f66").bind(env), "craft": Callable(self, "_f67").bind(env), "update": Callable(self, "_f68").bind(env), "doAct": Callable(self, "_f72").bind(env), "heroPose": Callable(self, "_f73").bind(env), "impact": Callable(self, "_f74").bind(env), "updateParts": Callable(self, "_f75").bind(env), "drawParts": Callable(self, "_f77").bind(env), "draw": Callable(self, "_f78").bind(env), "collect": Callable(self, "_f95").bind(env), "scatterCrows": Callable(self, "_f99").bind(env), "pickChatter": Callable(self, "_f100").bind(env), "drawBubble": Callable(self, "_f103").bind(env), "workerSpots": Callable(self, "_f107").bind(env), "questTarget": Callable(self, "_f110").bind(env), "drawPointer": Callable(self, "_f113").bind(env)}
	J.G["_ground"] = null
	J.G["JossFx"] = {"play": Callable(self, "_f122").bind(env)}
	J.G["Fx"] = {"lastPraise": {}, "float": Callable(self, "_f125").bind(env), "toast": Callable(self, "_f126").bind(env), "banner": Callable(self, "_f129").bind(env), "praise": Callable(self, "_f130").bind(env)}
	J.G["Story"] = {"q": [], "cur": null, "li": 0.0, "typing": false, "shown": "", "timer": null, "cb": null, "actors": [], "busy": Callable(self, "_f131").bind(env), "queue": Callable(self, "_f132").bind(env), "next": Callable(self, "_f133").bind(env), "render": Callable(self, "_f134").bind(env), "frame": Callable(self, "_f138").bind(env), "drawStage": Callable(self, "_f139").bind(env), "showLine": Callable(self, "_f141").bind(env), "drawAnchor": Callable(self, "_f146").bind(env), "chatLine": Callable(self, "_f147").bind(env), "chatEnd": Callable(self, "_f159").bind(env), "advance": Callable(self, "_f166").bind(env), "skipScene": Callable(self, "_f167").bind(env)}
	J.G["UI"] = {"tab": "village", "modalOpen": Callable(self, "_f170").bind(env), "refresh": Callable(self, "_f171").bind(env), "open": Callable(self, "_f173").bind(env), "sheet": Callable(self, "_f175").bind(env), "close": Callable(self, "_f176").bind(env), "openBuilding": Callable(self, "_f178").bind(env), "bldEffect": Callable(self, "_f188").bind(env), "postHtml": Callable(self, "_f191").bind(env), "postStatTxt": Callable(self, "_f193").bind(env), "pickWorker": Callable(self, "_f194").bind(env), "openRoster": Callable(self, "_f204").bind(env), "openChests": Callable(self, "_f218").bind(env), "openStory": Callable(self, "_f223").bind(env), "openBattleSelect": Callable(self, "_f244").bind(env)}
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

func _f115(this_, a: Array, env):
	var _t98 = J.mod(J.mul(env["seed"], 16807.0), 2147483647.0)
	env["seed"] = _t98
	return J.div(env["seed"], 2147483647.0)

func _f116(this_, a: Array, env):
	var v_sx_479 = null; var v_sy_480 = null; var v_w_481 = null; var v_h_482 = null; var v_j_483 = null
	v_sx_479 = J.arg(a, 0)
	v_sy_480 = J.arg(a, 1)
	v_w_481 = J.arg(a, 2)
	v_h_482 = J.arg(a, 3)
	v_j_483 = (J.sub(J.cl(env["R"], null, []), 0.5) * 2.0)
	var _t115 = env["x"]
	var _t116 = J.gp(["#3c3a3e", "#36363a", "#413e40"], floor(J.num(J.mul(J.cl(env["R"], null, []), 3.0))))
	J.sp(_t115, "fillStyle", _t116)
	J.mc(env["x"], "beginPath", [])
	J.mc(env["x"], "roundRect", [J.add(v_sx_479, v_j_483), v_sy_480, J.sub(v_w_481, 2.0), J.sub(v_h_482, 2.0), 3.0])
	J.mc(env["x"], "fill", [])
	var _t117 = env["x"]
	J.sp(_t117, "fillStyle", "rgba(255,255,255,.05)")
	J.mc(env["x"], "fillRect", [J.add(J.add(v_sx_479, v_j_483), 2.0), J.add(v_sy_480, 1.0), J.sub(v_w_481, 6.0), 1.5])
	var _t118 = env["x"]
	J.sp(_t118, "fillStyle", "rgba(0,0,0,.35)")
	J.mc(env["x"], "fillRect", [J.add(v_sx_479, v_j_483), J.sub(J.add(v_sy_480, v_h_482), 3.0), J.sub(v_w_481, 2.0), 1.5])

func _f117(this_, a: Array, env):
	var v_tx_488 = null; var v_ty_489 = null; var v_k_490 = null
	v_tx_488 = J.arg(a, 0)
	v_ty_489 = J.arg(a, 1)
	var _t124 = env["x"]
	var _t125 = ("#34463a" if J.cmp(J.cl(env["R"], null, []), 0.5, "<") else "#3e5040")
	J.sp(_t124, "strokeStyle", _t125)
	var _t126 = env["x"]
	J.sp(_t126, "lineWidth", 1.3)
	v_k_490 = (-2.0)
	while true:
		if not J.cmp(v_k_490, 2.0, "<="): break
		J.mc(env["x"], "beginPath", [])
		J.mc(env["x"], "moveTo", [J.add(v_tx_488, J.mul(v_k_490, 1.6)), v_ty_489])
		J.mc(env["x"], "quadraticCurveTo", [J.add(v_tx_488, J.mul(v_k_490, 2.2)), J.sub(v_ty_489, 4.0), J.add(J.add(v_tx_488, J.mul(v_k_490, 3.0)), (J.sub(J.cl(env["R"], null, []), 0.5) * 2.0)), (J.sub(v_ty_489, 6.0) - J.mul(J.cl(env["R"], null, []), 4.0))])
		J.mc(env["x"], "stroke", [])
		v_k_490 = J.num(v_k_490) + 1.0

func _f114(this_, a: Array, env):
	var v_k_456 = null; var v_c_457 = null; var v_gr_461 = null; var v_hr_462 = null; var v_slab_463 = null; var v_tuft_464 = null; var v_vg_465 = null; var v_strokeCols_466 = null; var v_i_467 = null; var v_px_468 = null; var v_py_469 = null; var v_r_470 = null; var v_i_471 = null; var v_a_472 = null; var v_d_473 = null; var v_i_474 = null; var v_id_475 = null; var v_bx_476 = null; var v_by_477 = null; var v_w_478 = null; var v_y_484 = null; var v_off_485 = null; var v_ry_486 = null; var v_xx_487 = null; var v_i_491 = null; var v_tx_492 = null; var v_ty_493 = null; var v_i_494 = null; var v_px_495 = null; var v_py_496 = null; var v_len_497 = null; var v_a_498 = null; var v_i_499 = null
	var _s222 = {"__p": env, "x": null, "seed": null, "R": null}
	if J.t(J.G.get("_ground")):
		return J.G.get("_ground")
	v_k_456 = 2.0
	v_c_457 = J.S_document_("createElement", ["canvas"])
	var _t96 = J.mul(J.G.get("W"), v_k_456)
	J.sp(v_c_457, "width", _t96)
	var _t97 = J.mul(J.G.get("WH"), v_k_456)
	J.sp(v_c_457, "height", _t97)
	_s222["x"] = J.mc(v_c_457, "getContext", ["2d"])
	J.mc(_s222["x"], "scale", [v_k_456, v_k_456])
	_s222["seed"] = 7.0
	_s222["R"] = Callable(self, "_f115").bind(_s222)
	v_gr_461 = J.mc(_s222["x"], "createLinearGradient", [0.0, 0.0, 0.0, J.G.get("WH")])
	J.mc(v_gr_461, "addColorStop", [0.0, "#140f12"])
	J.mc(v_gr_461, "addColorStop", [0.13, "#211b19"])
	J.mc(v_gr_461, "addColorStop", [0.5, "#26201b"])
	J.mc(v_gr_461, "addColorStop", [1.0, "#221d1a"])
	var _t99 = _s222["x"]
	J.sp(_t99, "fillStyle", v_gr_461)
	J.mc(_s222["x"], "fillRect", [0.0, 0.0, J.G.get("W"), J.G.get("WH")])
	v_hr_462 = J.mc(_s222["x"], "createLinearGradient", [0.0, 0.0, 0.0, 160.0])
	J.mc(v_hr_462, "addColorStop", [0.0, "rgba(110,30,30,.55)"])
	J.mc(v_hr_462, "addColorStop", [1.0, "rgba(70,30,30,0)"])
	var _t100 = _s222["x"]
	J.sp(_t100, "fillStyle", v_hr_462)
	J.mc(_s222["x"], "beginPath", [])
	J.mc(_s222["x"], "moveTo", [160.0, 0.0])
	J.mc(_s222["x"], "lineTo", [230.0, 0.0])
	J.mc(_s222["x"], "lineTo", [246.0, 160.0])
	J.mc(_s222["x"], "lineTo", [144.0, 160.0])
	J.mc(_s222["x"], "fill", [])
	v_i_467 = 0.0
	while true:
		if not J.cmp(v_i_467, 700.0, "<"): break
		v_px_468 = J.mul(J.cl(_s222["R"], null, []), J.G.get("W"))
		v_py_469 = (140.0 + J.mul(J.cl(_s222["R"], null, []), J.sub(J.G.get("WH"), 140.0)))
		v_r_470 = (2.0 + J.mul(J.cl(_s222["R"], null, []), 9.0))
		var _t101 = _s222["x"]
		var _t102 = ("rgba(255,240,210,.025)" if J.cmp(J.cl(_s222["R"], null, []), 0.5, "<") else "rgba(0,0,0,.12)")
		J.sp(_t101, "fillStyle", _t102)
		J.mc(_s222["x"], "beginPath", [])
		J.mc(_s222["x"], "ellipse", [v_px_468, v_py_469, J.mul(v_r_470, 1.6), v_r_470, 0.0, 0.0, 6.3])
		J.mc(_s222["x"], "fill", [])
		v_i_467 = J.num(v_i_467) + 1.0
	var _t103 = _s222["x"]
	J.sp(_t103, "fillStyle", "rgba(20,30,22,.55)")
	J.mc(_s222["x"], "beginPath", [])
	J.mc(_s222["x"], "ellipse", [100.0, 455.0, 110.0, 92.0, 0.0, 0.0, 6.3])
	J.mc(_s222["x"], "fill", [])
	v_i_471 = 0.0
	while true:
		if not J.cmp(v_i_471, 90.0, "<"): break
		v_a_472 = J.mul(J.cl(_s222["R"], null, []), 6.3)
		v_d_473 = J.cl(_s222["R"], null, [])
		var _t104 = _s222["x"]
		var _t105 = J.gp(["#3a3a20", "#4a3a1c", "#2e3a26"], J.mod(v_i_471, 3.0))
		J.sp(_t104, "fillStyle", _t105)
		J.mc(_s222["x"], "beginPath", [])
		J.mc(_s222["x"], "ellipse", [(100.0 + J.mul((cos(J.num(v_a_472)) * 100.0), v_d_473)), (455.0 + J.mul((sin(J.num(v_a_472)) * 80.0), v_d_473)), 2.2, 1.2, J.mul(J.cl(_s222["R"], null, []), 3.0), 0.0, 6.3])
		J.mc(_s222["x"], "fill", [])
		v_i_471 = J.num(v_i_471) + 1.0
	var _t106 = _s222["x"]
	J.sp(_t106, "fillStyle", "#18221f")
	J.mc(_s222["x"], "fillRect", [222.0, 388.0, 154.0, 146.0])
	var _t107 = _s222["x"]
	J.sp(_t107, "fillStyle", "rgba(70,100,95,.18)")
	v_i_474 = 0.0
	while true:
		if not J.cmp(v_i_474, 3.0, "<"): break
		J.mc(_s222["x"], "fillRect", [222.0, ((388.0 + J.mul(v_i_474, 50.0)) + 34.0), 154.0, 4.0])
		v_i_474 = J.num(v_i_474) + 1.0
	var _t108 = _s222["x"]
	J.sp(_t108, "strokeStyle", "#3a3a2c")
	var _t109 = _s222["x"]
	J.sp(_t109, "lineWidth", 3.0)
	J.mc(_s222["x"], "strokeRect", [222.0, 388.0, 154.0, 146.0])
	for _t110 in J.iter(J.S_Object_("keys", [J.G.get("POS")])):
		v_id_475 = _t110
		if J.seq(v_id_475, "gate"):
			continue
		var _t111 = J.gp(J.G.get("POS"), v_id_475)
		var _t112 = J.gp(_t111, 0.0)
		v_bx_476 = _t112
		var _t113 = J.gp(_t111, 1.0)
		v_by_477 = _t113
		v_w_478 = (80.0 if J.seq(v_id_475, "house") else (30.0 if J.seq(v_id_475, "furnace") else 56.0))
		var _t114 = _s222["x"]
		J.sp(_t114, "fillStyle", "rgba(60,48,36,.35)")
		J.mc(_s222["x"], "beginPath", [])
		J.mc(_s222["x"], "ellipse", [v_bx_476, J.sub(v_by_477, 4.0), v_w_478, 16.0, 0.0, 0.0, 6.3])
		J.mc(_s222["x"], "fill", [])
	v_slab_463 = Callable(self, "_f116").bind(_s222)
	v_y_484 = 150.0
	while true:
		if not J.cmp(v_y_484, J.G.get("WH"), "<"): break
		v_off_485 = (0.0 if J.t(J.mod(J.div(v_y_484, 18.0), 2.0)) else 12.0)
		J.cl(v_slab_463, null, [(172.0 - J.div(v_off_485, 2.0)), v_y_484, (24.0 + J.div(v_off_485, 2.0)), 18.0])
		J.cl(v_slab_463, null, [(196.0 + (0.0 if J.t(v_off_485) else (-6.0))), v_y_484, ((24.0 - (0.0 if J.t(v_off_485) else (-6.0))) + (0.0 if J.t(v_off_485) else 0.0)), 18.0])
		var _t119 = J.add(v_y_484, 18.0)
		v_y_484 = _t119
	for _t120 in J.iter([678.0, 932.0]):
		v_ry_486 = _t120
		v_xx_487 = 0.0
		while true:
			if not J.cmp(v_xx_487, J.G.get("W"), "<"): break
			var _t121 = J.cmp(v_xx_487, 160.0, ">")
			if (J.cmp(v_xx_487, 222.0, "<") if _t121 else _t121):
				var _t122 = J.add(v_xx_487, 22.0)
				v_xx_487 = _t122
				continue
			J.cl(v_slab_463, null, [v_xx_487, v_ry_486, 22.0, 11.0])
			J.cl(v_slab_463, null, [J.add(v_xx_487, 11.0), J.add(v_ry_486, 11.0), 22.0, 11.0])
			var _t123 = J.add(v_xx_487, 22.0)
			v_xx_487 = _t123
	v_tuft_464 = Callable(self, "_f117").bind(_s222)
	v_i_491 = 0.0
	while true:
		if not J.cmp(v_i_491, 220.0, "<"): break
		v_tx_492 = J.mul(J.cl(_s222["R"], null, []), J.G.get("W"))
		v_ty_493 = (150.0 + J.mul(J.cl(_s222["R"], null, []), J.sub(J.G.get("WH"), 150.0)))
		var _t127 = J.cmp(v_tx_492, 160.0, ">")
		if (J.cmp(v_tx_492, 230.0, "<") if _t127 else _t127):
			v_i_491 = J.num(v_i_491) + 1.0
			continue
		var _t128 = J.cmp(v_tx_492, 218.0, ">")
		var _t129 = (J.cmp(v_ty_493, 384.0, ">") if _t128 else _t128)
		if (J.cmp(v_ty_493, 538.0, "<") if _t129 else _t129):
			v_i_491 = J.num(v_i_491) + 1.0
			continue
		var _t130 = (absf(J.num(J.sub(v_ty_493, 690.0))) < 16.0)
		if (_t130 if _t130 else (absf(J.num(J.sub(v_ty_493, 942.0))) < 16.0)):
			v_i_491 = J.num(v_i_491) + 1.0
			continue
		J.cl(v_tuft_464, null, [v_tx_492, v_ty_493])
		v_i_491 = J.num(v_i_491) + 1.0
	v_vg_465 = J.mc(_s222["x"], "createLinearGradient", [0.0, 0.0, J.G.get("W"), 0.0])
	J.mc(v_vg_465, "addColorStop", [0.0, "rgba(0,0,0,.35)"])
	J.mc(v_vg_465, "addColorStop", [0.12, "rgba(0,0,0,0)"])
	J.mc(v_vg_465, "addColorStop", [0.88, "rgba(0,0,0,0)"])
	J.mc(v_vg_465, "addColorStop", [1.0, "rgba(0,0,0,.35)"])
	v_strokeCols_466 = ["rgba(120,92,62,.16)", "rgba(70,56,40,.22)", "rgba(150,120,80,.10)", "rgba(60,80,58,.14)", "rgba(20,14,10,.22)"]
	var _t131 = _s222["x"]
	J.sp(_t131, "lineCap", "round")
	v_i_494 = 0.0
	while true:
		if not J.cmp(v_i_494, 16000.0, "<"): break
		v_px_495 = J.mul(J.cl(_s222["R"], null, []), J.G.get("W"))
		v_py_496 = (120.0 + J.mul(J.cl(_s222["R"], null, []), J.sub(J.G.get("WH"), 120.0)))
		v_len_497 = (3.0 + J.mul(J.cl(_s222["R"], null, []), 7.0))
		v_a_498 = ((-0.6) + (J.sub(J.cl(_s222["R"], null, []), 0.5) * 0.35))
		var _t132 = _s222["x"]
		var _t133 = J.gp(v_strokeCols_466, floor(J.num(J.mul(J.cl(_s222["R"], null, []), J.len(v_strokeCols_466)))))
		J.sp(_t132, "strokeStyle", _t133)
		var _t134 = _s222["x"]
		var _t135 = (0.6 + J.mul(J.cl(_s222["R"], null, []), 1.1))
		J.sp(_t134, "lineWidth", _t135)
		J.mc(_s222["x"], "beginPath", [])
		J.mc(_s222["x"], "moveTo", [v_px_495, v_py_496])
		J.mc(_s222["x"], "lineTo", [J.add(v_px_495, J.mul(cos(J.num(v_a_498)), v_len_497)), J.add(v_py_496, J.mul(sin(J.num(v_a_498)), v_len_497))])
		J.mc(_s222["x"], "stroke", [])
		v_i_494 = J.num(v_i_494) + 1.0
	v_i_499 = 0.0
	while true:
		if not J.cmp(v_i_499, 5000.0, "<"): break
		var _t136 = _s222["x"]
		var _t137 = ("rgba(235,220,190,.07)" if J.cmp(J.cl(_s222["R"], null, []), 0.6, "<") else "rgba(0,0,0,.18)")
		J.sp(_t136, "fillStyle", _t137)
		J.mc(_s222["x"], "fillRect", [J.mul(J.cl(_s222["R"], null, []), J.G.get("W")), J.mul(J.cl(_s222["R"], null, []), J.G.get("WH")), (0.5 + J.mul(J.cl(_s222["R"], null, []), 0.9)), (0.5 + J.mul(J.cl(_s222["R"], null, []), 0.9))])
		v_i_499 = J.num(v_i_499) + 1.0
	var _t138 = _s222["x"]
	J.sp(_t138, "fillStyle", v_vg_465)
	J.mc(_s222["x"], "fillRect", [0.0, 0.0, J.G.get("W"), J.G.get("WH")])
	J.G["_ground"] = v_c_457
	return v_c_457

func _f118(this_, a: Array, env):
	var v_ctx_502 = null; var v_x_503 = null; var v_y_504 = null; var v_t_505 = null; var v_k_506 = null; var v_a_507 = null
	v_ctx_502 = J.arg(a, 0)
	v_x_503 = J.arg(a, 1)
	v_y_504 = J.arg(a, 2)
	v_t_505 = J.arg(a, 3)
	J.sp(v_ctx_502, "strokeStyle", "#3a5a32")
	J.sp(v_ctx_502, "lineWidth", 1.2)
	J.mc(v_ctx_502, "beginPath", [])
	J.mc(v_ctx_502, "moveTo", [v_x_503, J.add(v_y_504, 12.0)])
	J.mc(v_ctx_502, "lineTo", [v_x_503, J.add(v_y_504, 2.0)])
	J.mc(v_ctx_502, "stroke", [])
	J.sp(v_ctx_502, "strokeStyle", "rgba(214,40,52,.9)")
	J.sp(v_ctx_502, "lineWidth", 1.5)
	J.sp(v_ctx_502, "lineCap", "round")
	v_k_506 = 0.0
	while true:
		if not J.cmp(v_k_506, 6.0, "<"): break
		v_a_507 = (((J.div(v_k_506, 6.0) * PI) * 2.0) + (sin(J.num(J.mul(v_t_505, 0.6))) * 0.15))
		J.mc(v_ctx_502, "beginPath", [])
		J.mc(v_ctx_502, "moveTo", [v_x_503, v_y_504])
		J.mc(v_ctx_502, "quadraticCurveTo", [J.add(v_x_503, (cos(J.num(v_a_507)) * 4.0)), J.sub(J.add(v_y_504, (sin(J.num(v_a_507)) * 4.0)), 3.0), J.add(v_x_503, (cos(J.num(v_a_507)) * 7.0)), J.sub(J.add(v_y_504, (sin(J.num(v_a_507)) * 6.0)), 4.0)])
		J.mc(v_ctx_502, "stroke", [])
		v_k_506 = J.num(v_k_506) + 1.0
	J.sp(v_ctx_502, "fillStyle", "#ff6060")
	J.mc(v_ctx_502, "beginPath", [])
	J.mc(v_ctx_502, "arc", [v_x_503, v_y_504, 1.6, 0.0, 6.3])
	J.mc(v_ctx_502, "fill", [])

func _f120(this_, a: Array, env):
	var v_q_513 = null
	v_q_513 = J.arg(a, 0)
	var _t141 = J.seq(J.gp(v_q_513, "t"), "build")
	return (J.seq(J.gp(v_q_513, "b"), env["id"]) if _t141 else _t141)

func _f119(this_, a: Array, env):
	var v_b_511 = null; var v_qi_512 = null
	var _s249 = {"__p": env, "id": null}
	_s249["id"] = J.arg(a, 0)
	v_b_511 = J.gp(J.G.get("BUILDINGS"), _s249["id"])
	var _t139 = J.gp(v_b_511, "unlockLv")
	if J.t((J.cmp(J.gp(J.G.get("S"), "lv"), J.gp(v_b_511, "unlockLv"), "<") if J.t(_t139) else _t139)):
		return false
	var _t140 = J.gp(v_b_511, "unlockStage")
	if J.t(((not J.t(J.gp(J.gp(J.G.get("S"), "cleared"), J.gp(v_b_511, "unlockStage")))) if J.t(_t140) else _t140)):
		return false
	if J.t(J.gp(v_b_511, "unlockQuest")):
		v_qi_512 = J.mc(J.G.get("QUESTS"), "findIndex", [Callable(self, "_f120").bind(_s249)])
		if J.cmp(v_qi_512, J.gp(J.G.get("S"), "qi"), ">"):
			return false
	return true

func _f121(this_, a: Array, env):
	var _t142 = J.gp(J.gp(J.G.get("S"), "bld"), "furnace")
	return ((J.sub(J.S_Date_("now", []), J.gp(J.G.get("S"), "furnaceAt")) >= J.div(J.mul(J.gp(J.G.get("F"), "furnaceCD"), 1000.0), J.G.get("TIME_SCALE"))) if J.t(_t142) else _t142)

func _f168(this_, a: Array, env):
	var v_ctx_708 = null; var v_w_709 = null; var v_h_710 = null; var v_bg_711 = null; var v_t_712 = null; var v_sky_713 = null; var v_g_714 = null; var v_gy_715 = null; var v_mg_716 = null; var v_i_717 = null; var v_x_718 = null; var v_k_719 = null; var v_i_720 = null; var v_x_721 = null; var v_k_722 = null; var v_i_723 = null; var v_x_724 = null; var v_hh_725 = null; var v_a_726 = null; var v_b_727 = null; var v_i_728 = null; var v_x_729 = null; var v_y_730 = null; var v_k_731 = null; var v_a_732 = null; var v_i_733 = null; var v_x_734 = null
	v_ctx_708 = J.arg(a, 0)
	v_w_709 = J.arg(a, 1)
	v_h_710 = J.arg(a, 2)
	v_bg_711 = J.arg(a, 3)
	v_t_712 = J.arg(a, 4)
	if J.t(J.mc(J.G.get("SCENE"), "drawBg", [v_ctx_708, v_w_709, v_h_710, v_bg_711])):
		return null
	var _t143 = J.gp({"village": ["#121016", "#24222a"], "road": ["#1a0f22", "#3a1a2a"], "field": ["#0f1a1a", "#26332a"], "kampung": ["#0c1420", "#1f2a33"], "banana": ["#0a140f", "#1c2e22"], "hq": ["#0e0e1a", "#26263c"], "office": ["#141420", "#2c2c3a"]}, v_bg_711)
	v_sky_713 = (_t143 if J.t(_t143) else ["#120f22", "#2a2440"])
	v_g_714 = J.mc(v_ctx_708, "createLinearGradient", [0.0, 0.0, 0.0, v_h_710])
	J.mc(v_g_714, "addColorStop", [0.0, J.gp(v_sky_713, 0.0)])
	J.mc(v_g_714, "addColorStop", [1.0, J.gp(v_sky_713, 1.0)])
	J.sp(v_ctx_708, "fillStyle", v_g_714)
	J.mc(v_ctx_708, "fillRect", [0.0, 0.0, v_w_709, v_h_710])
	J.mc(J.G.get("ART"), "el", [v_ctx_708, J.mul(v_w_709, 0.78), J.mul(v_h_710, 0.13), 28.0, 28.0, "rgba(240,230,200,.85)"])
	J.mc(J.G.get("ART"), "el", [v_ctx_708, (J.mul(v_w_709, 0.78) + 8.0), (J.mul(v_h_710, 0.13) - 4.0), 26.0, 26.0, J.gp(v_sky_713, 0.0)])
	v_gy_715 = J.mul(v_h_710, 0.66)
	J.sp(v_ctx_708, "fillStyle", "rgba(0,0,0,.35)")
	if J.seq(v_bg_711, "banana"):
		v_i_717 = 0.0
		while true:
			if not J.cmp(v_i_717, 6.0, "<"): break
			v_x_718 = J.div(J.mul(v_i_717, v_w_709), 5.0)
			J.mc(v_ctx_708, "fillRect", [J.sub(v_x_718, 4.0), J.sub(v_gy_715, 170.0), 8.0, 170.0])
			v_k_719 = 0.0
			while true:
				if not J.cmp(v_k_719, 5.0, "<"): break
				J.mc(v_ctx_708, "save", [])
				J.mc(v_ctx_708, "translate", [v_x_718, J.sub(v_gy_715, 170.0)])
				J.mc(v_ctx_708, "rotate", [((-1.2) + J.mul(v_k_719, 0.6))])
				J.mc(J.G.get("ART"), "el", [v_ctx_708, 40.0, 0.0, 44.0, 10.0, "rgba(10,30,18,.8)"])
				J.mc(v_ctx_708, "restore", [])
				v_k_719 = J.num(v_k_719) + 1.0
			v_i_717 = J.num(v_i_717) + 1.0
	else:
		if J.seq(v_bg_711, "kampung"):
			v_i_720 = 0.0
			while true:
				if not J.cmp(v_i_720, 4.0, "<"): break
				v_x_721 = (20.0 + J.div(J.mul(v_i_720, v_w_709), 3.6))
				J.mc(v_ctx_708, "fillRect", [v_x_721, J.sub(v_gy_715, 90.0), 90.0, 50.0])
				J.mc(v_ctx_708, "beginPath", [])
				J.mc(v_ctx_708, "moveTo", [J.sub(v_x_721, 10.0), J.sub(v_gy_715, 88.0)])
				J.mc(v_ctx_708, "lineTo", [J.add(v_x_721, 45.0), J.sub(v_gy_715, 130.0)])
				J.mc(v_ctx_708, "lineTo", [J.add(v_x_721, 100.0), J.sub(v_gy_715, 88.0)])
				J.mc(v_ctx_708, "fill", [])
				v_k_722 = 0.0
				while true:
					if not J.cmp(v_k_722, 4.0, "<"): break
					J.mc(v_ctx_708, "fillRect", [J.add(v_x_721, J.mul(v_k_722, 28.0)), J.sub(v_gy_715, 40.0), 5.0, 40.0])
					v_k_722 = J.num(v_k_722) + 1.0
				v_i_720 = J.num(v_i_720) + 1.0
		else:
			var _t144 = J.seq(v_bg_711, "hq")
			if (_t144 if _t144 else J.seq(v_bg_711, "office")):
				v_i_723 = 0.0
				while true:
					if not J.cmp(v_i_723, 5.0, "<"): break
					v_x_724 = J.div(J.mul(v_i_723, v_w_709), 4.5)
					v_hh_725 = (160.0 + (J.mod(v_i_723, 3.0) * 70.0))
					J.mc(v_ctx_708, "fillRect", [v_x_724, J.sub(v_gy_715, v_hh_725), 70.0, v_hh_725])
					J.sp(v_ctx_708, "fillStyle", "rgba(255,220,120,.18)")
					v_a_726 = 0.0
					while true:
						if not J.cmp(v_a_726, 6.0, "<"): break
						v_b_727 = 0.0
						while true:
							if not J.cmp(v_b_727, 3.0, "<"): break
							if J.t(J.mod(J.add(J.add(J.mul(v_a_726, 3.0), v_b_727), v_i_723), 4.0)):
								J.mc(v_ctx_708, "fillRect", [J.add(J.add(v_x_724, 8.0), J.mul(v_b_727, 20.0)), ((J.sub(v_gy_715, v_hh_725) + 12.0) + J.mul(v_a_726, 22.0)), 10.0, 12.0])
							v_b_727 = J.num(v_b_727) + 1.0
						v_a_726 = J.num(v_a_726) + 1.0
					J.sp(v_ctx_708, "fillStyle", "rgba(0,0,0,.35)")
					v_i_723 = J.num(v_i_723) + 1.0
				if J.seq(v_bg_711, "office"):
					J.sp(v_ctx_708, "fillStyle", "rgba(30,24,20,.9)")
					J.mc(v_ctx_708, "fillRect", [0.0, J.sub(v_gy_715, 10.0), v_w_709, 30.0])
			else:
				if J.seq(v_bg_711, "road"):
					J.sp(v_ctx_708, "fillStyle", "rgba(120,40,60,.25)")
					J.mc(v_ctx_708, "beginPath", [])
					J.mc(v_ctx_708, "moveTo", [J.mul(v_w_709, 0.42), J.sub(v_gy_715, 160.0)])
					J.mc(v_ctx_708, "lineTo", [J.mul(v_w_709, 0.58), J.sub(v_gy_715, 160.0)])
					J.mc(v_ctx_708, "lineTo", [v_w_709, v_gy_715])
					J.mc(v_ctx_708, "lineTo", [0.0, v_gy_715])
					J.mc(v_ctx_708, "fill", [])
					v_i_728 = 0.0
					while true:
						if not J.cmp(v_i_728, 14.0, "<"): break
						v_x_729 = J.mod(J.mul(v_i_728, 71.0), v_w_709)
						v_y_730 = (J.sub(v_gy_715, 20.0) - J.mod(J.mul(v_i_728, 37.0), 120.0))
						J.sp(v_ctx_708, "strokeStyle", "rgba(230,50,70,.6)")
						J.sp(v_ctx_708, "lineWidth", 1.5)
						v_k_731 = 0.0
						while true:
							if not J.cmp(v_k_731, 6.0, "<"): break
							v_a_732 = ((J.div(v_k_731, 6.0) * PI) * 2.0)
							J.mc(v_ctx_708, "beginPath", [])
							J.mc(v_ctx_708, "moveTo", [v_x_729, v_y_730])
							J.mc(v_ctx_708, "lineTo", [J.add(v_x_729, (cos(J.num(v_a_732)) * 7.0)), J.add(v_y_730, (sin(J.num(v_a_732)) * 7.0))])
							J.mc(v_ctx_708, "stroke", [])
							v_k_731 = J.num(v_k_731) + 1.0
						v_i_728 = J.num(v_i_728) + 1.0
				else:
					v_i_733 = 0.0
					while true:
						if not J.cmp(v_i_733, 7.0, "<"): break
						v_x_734 = J.div(J.mul(v_i_733, v_w_709), 6.0)
						J.mc(J.G.get("ART"), "el", [v_ctx_708, v_x_734, J.sub(v_gy_715, 60.0), 40.0, 50.0, "rgba(10,20,20,.6)"])
						J.sp(v_ctx_708, "fillStyle", "rgba(10,20,20,.6)")
						J.mc(v_ctx_708, "fillRect", [J.sub(v_x_734, 4.0), J.sub(v_gy_715, 30.0), 8.0, 30.0])
						v_i_733 = J.num(v_i_733) + 1.0
	J.sp(v_ctx_708, "fillStyle", "rgba(10,8,18,.55)")
	J.mc(v_ctx_708, "fillRect", [0.0, v_gy_715, v_w_709, J.sub(v_h_710, v_gy_715)])
	v_mg_716 = J.mc(v_ctx_708, "createLinearGradient", [0.0, J.sub(v_gy_715, 40.0), 0.0, J.add(v_gy_715, 20.0)])
	J.mc(v_mg_716, "addColorStop", [0.0, "rgba(180,170,230,0)"])
	J.mc(v_mg_716, "addColorStop", [1.0, "rgba(180,170,230,.12)"])
	J.sp(v_ctx_708, "fillStyle", v_mg_716)
	J.mc(v_ctx_708, "fillRect", [0.0, J.sub(v_gy_715, 40.0), v_w_709, 60.0])

func _f169(this_, a: Array, env):
	var v_p_737 = null
	v_p_737 = J.arg(a, 0)
	if J.t(J.gp(J.G.get("POSTS"), v_p_737)):
		return J.add("打工：", J.gp(J.gp(J.G.get("POSTS"), v_p_737), "name"))
	var _t146 = J.seq(v_p_737, "street")
	if not J.t(_t146):
		var _t145 = J.F_String([v_p_737])
		_t146 = J.mc(_t145, "startsWith", ["boss:"])
	if J.t(_t146):
		return "陽間站崗中"
	var _t147 = J.F_String([v_p_737])
	if J.t(J.mc(_t147, "startsWith", ["tower"])):
		return "樓裡有鬼出更中"
	return "出外工作中"

func _f245(this_, a: Array, env):
	var v_st_928 = null
	v_st_928 = J.arg(a, 0)
	var _t148 = (not J.t(J.gp(v_st_928, "need")))
	return (_t148 if _t148 else (not (not J.t(J.gp(J.gp(J.G.get("S"), "seen"), J.gp(v_st_928, "need"))))))

func _f246(this_, a: Array, env):
	var v_b_931 = null
	var _t149 = J.G.get("$")
	v_b_931 = J.cl(_t149, null, ["#sndtop"])
	if J.t(v_b_931):
		var _t150 = ("🔊" if J.t(J.mc(J.G.get("Sound"), "isOn", [])) else "🔇")
		J.sp(v_b_931, "textContent", _t150)
		var _t151 = J.gp(v_b_931, "classList")
		J.mc(_t151, "toggle", ["off", (not J.t(J.mc(J.G.get("Sound"), "isOn", [])))])

func _f248(this_, a: Array, env):
	J.del(J.gp(env["btn"], "dataset"), "armed")
	var _t154 = env["btn"]
	var _t155 = env["o"]
	J.sp(_t154, "innerHTML", _t155)

func _f247(this_, a: Array, env):
	var v_msg_935 = null
	var _s516 = {"__p": env, "btn": null, "o": null}
	_s516["btn"] = J.arg(a, 0)
	v_msg_935 = J.arg(a, 1)
	if J.t(J.gp(J.gp(_s516["btn"], "dataset"), "armed")):
		return true
	var _t152 = J.gp(_s516["btn"], "dataset")
	J.sp(_t152, "armed", 1.0)
	_s516["o"] = J.gp(_s516["btn"], "innerHTML")
	var _t153 = _s516["btn"]
	J.sp(_t153, "innerHTML", v_msg_935)
	J.F_setTimeout([Callable(self, "_f248").bind(_s516), 2500.0])
	return false

func _f250(this_, a: Array, env):
	var v_c_940 = null; var v_p_941 = null
	v_c_940 = J.arg(a, 0)
	if J.t(J.gp(J.gp(v_c_940, "dataset"), "done")):
		return null
	var _t157 = J.gp(v_c_940, "dataset")
	J.sp(_t157, "done", 1.0)
	v_p_941 = J.mc(J.G.get("ART"), "portrait", [J.gp(J.gp(v_c_940, "dataset"), "por"), 64.0, {"tamed": true, "untied": true}])
	var _t158 = J.gp(v_p_941, "width")
	J.sp(v_c_940, "width", _t158)
	var _t159 = J.gp(v_p_941, "height")
	J.sp(v_c_940, "height", _t159)
	var _t160 = J.mc(v_c_940, "getContext", ["2d"])
	J.mc(_t160, "drawImage", [v_p_941, 0.0, 0.0])

func _f249(this_, a: Array, env):
	var v_root_939 = null
	v_root_939 = J.arg(a, 0)
	var _t156 = J.mc(v_root_939, "querySelectorAll", ["canvas[data-por]"])
	J.mc(_t156, "forEach", [Callable(self, "_f250").bind(env)])

func _f252(this_, a: Array, env):
	var v_k_953 = null
	v_k_953 = J.arg(a, 0)
	var _t162 = (not J.t(J.gp(J.gp(J.G.get("FODDER"), v_k_953), "unlock")))
	return (_t162 if _t162 else J.gp(J.gp(J.G.get("S"), "cleared"), J.gp(J.gp(J.G.get("FODDER"), v_k_953), "unlock")))

func _f253(this_, a: Array, env):
	return J.round(J.num(J.mul((15.0 + (randf() * 32.0)), env["m"])))

func _f254(this_, a: Array, env):
	var v_g_954 = null
	v_g_954 = J.arg(a, 0)
	return J.gp(v_g_954, "name")

func _f251(this_, a: Array, env):
	var v_rare_944 = null; var v_pool_945 = null; var v_k_946 = null; var v_purple_947 = null; var v_st_949 = null; var v_used_950 = null; var v_name_951 = null; var v_g_952 = null; var v_i_955 = null
	var _s520 = {"__p": env, "m": null}
	v_rare_944 = J.arg(a, 0)
	var _t161 = J.S_Object_("keys", [J.G.get("FODDER")])
	v_pool_945 = J.mc(_t161, "filter", [Callable(self, "_f252").bind(_s520)])
	v_k_946 = J.gp(v_pool_945, floor(J.num((randf() * J.len(v_pool_945)))))
	v_purple_947 = (v_rare_944 if J.t(v_rare_944) else (randf() < 0.15))
	_s520["m"] = (1.45 if J.t(v_purple_947) else 1.0)
	var _t163 = [0.0, 0.0, 0.0]
	v_st_949 = J.mc(_t163, "map", [Callable(self, "_f253").bind(_s520)])
	var _t164 = J.gp(J.G.get("S"), "ghosts")
	v_used_950 = J.new_("Set", [J.mc(_t164, "map", [Callable(self, "_f254").bind(_s520)])])
	v_name_951 = null
	v_i_955 = 0.0
	while true:
		if not J.cmp(v_i_955, 40.0, "<"): break
		var _t165 = J.add(J.add(J.gp(J.gp(J.G.get("FODDER"), v_k_946), "name"), "・"), J.gp(J.G.get("NICKS"), floor(J.num((randf() * J.len(J.G.get("NICKS")))))))
		v_name_951 = _t165
		if (not J.t(J.mc(v_used_950, "has", [v_name_951]))):
			break
		v_i_955 = J.num(v_i_955) + 1.0
	var _t166 = J.G.get("S")
	var _t167 = J.num(J.gp(_t166, "uid"))
	J.sp(_t166, "uid", _t167 + 1.0)
	v_g_952 = {"id": J.add("g", _t167), "k": v_k_946, "name": v_name_951, "q": ("紫" if J.t(v_purple_947) else "藍"), "lv": 1.0, "st": v_st_949, "post": null, "spent": 0.0}
	var _t168 = J.gp(J.G.get("S"), "ghosts")
	J.mc(_t168, "push", [v_g_952])
	return v_g_952

func _f255(this_, a: Array, env):
	var _t169 = (not J.seq(J.typeof_(J.G.get("Patrol")), "undefined"))
	var _t171 = (J.gp(J.G.get("Patrol"), "active") if _t169 else _t169)
	if not J.t(_t171):
		var _t170 = (not J.seq(J.typeof_(J.G.get("Scare")), "undefined"))
		_t171 = (J.gp(J.G.get("Scare"), "active") if _t170 else _t170)
	var _t173 = _t171
	if not J.t(_t173):
		var _t172 = (not J.seq(J.typeof_(J.G.get("Graveyard")), "undefined"))
		_t173 = (J.gp(J.G.get("Graveyard"), "active") if _t172 else _t172)
	var _t175 = _t173
	if not J.t(_t175):
		var _t174 = (not J.seq(J.typeof_(J.G.get("GhostStreet")), "undefined"))
		_t175 = (J.gp(J.G.get("GhostStreet"), "active") if _t174 else _t174)
	var _t178 = _t175
	if not J.t(_t178):
		var _t176 = (not J.seq(J.typeof_(J.G.get("Sports")), "undefined"))
		var _t177 = (J.gp(J.G.get("Sports"), "_g") if _t176 else _t176)
		_t178 = ((not (not J.t(J.mc(J.G.get("Sports"), "_g", [])))) if J.t(_t177) else _t177)
	return _t178

func _f256(this_, a: Array, env):
	var v_now_960 = null; var v_dt_961 = null
	v_now_960 = J.arg(a, 0)
	J.F_requestAnimationFrame([J.G.get("loop")])
	if J.cmp(J.sub(v_now_960, J.G.get("lastT")), J.G.get("FRAME_MS"), "<"):
		return null
	v_dt_961 = J.min_([0.1, J.div(J.sub(v_now_960, J.G.get("lastT")), 1000.0)])
	J.G["lastT"] = v_now_960
	if (not J.t(J.gp(J.G.get("Battle"), "active"))):
		var _t179 = J.G.get("produce")
		J.cl(_t179, null, [J.mul(v_dt_961, J.G.get("TIME_SCALE"))])
		J.mc(J.G.get("Village"), "update", [v_dt_961])
		var _t180 = (not J.t(J.cl(J.G.get("covered"), null, [])))
		if (J.seq(J.typeof_(J.G.get("__nat_village")), "undefined") if _t180 else _t180):
			J.mc(J.G.get("Village"), "draw", [])
	else:
		var _t181 = J.G.get("produce")
		J.cl(_t181, null, [J.mul(v_dt_961, J.G.get("TIME_SCALE"))])
		J.mc(J.G.get("Battle"), "update", [v_dt_961])
		J.mc(J.G.get("Battle"), "draw", [])
	var _t182 = J.add(J.G.get("uiT"), v_dt_961)
	J.G["uiT"] = _t182
	if J.cmp(J.G.get("uiT"), 0.5, ">"):
		J.G["uiT"] = 0.0
		J.mc(J.G.get("UI"), "refresh", [])
		J.mc(J.G.get("Quest"), "check", [])
	var _t183 = J.add(J.G.get("saveT"), v_dt_961)
	J.G["saveT"] = _t183
	if J.cmp(J.G.get("saveT"), 5.0, ">"):
		J.G["saveT"] = 0.0
		J.cl(J.G.get("save"), null, [])

func _f257(this_, a: Array, env):
	var v_sec_964 = null; var v_before_965 = null; var v_lv0_966 = null; var v_e0_967 = null; var v_parts_968 = null; var v_s_969 = null; var v_k_970 = null; var v_d_971 = null
	var _t188 = (8.0 * 3600.0)
	var _t185 = J.S_Date_("now", [])
	var _t184 = J.gp(J.G.get("S"), "last")
	var _t187 = J.S_Date_("now", [])
	var _t186 = J.gp(J.G.get("S"), "last")
	var _t193 = (8.0 * 3600.0)
	var _t190 = J.S_Date_("now", [])
	var _t189 = J.gp(J.G.get("S"), "last")
	var _t192 = J.S_Date_("now", [])
	var _t191 = J.gp(J.G.get("S"), "last")
	v_sec_964 = J.min_([_t193, J.max_([0.0, J.div(J.sub(_t192, (_t191 if J.t(_t191) else J.S_Date_("now", []))), 1000.0)])])
	if J.cmp(v_sec_964, 60.0, "<"):
		return null
	v_before_965 = J.S_Object_("assign", [{}, J.gp(J.G.get("S"), "res")])
	v_lv0_966 = J.gp(J.G.get("S"), "lv")
	v_e0_967 = J.gp(J.G.get("S"), "exp")
	v_s_969 = 0.0
	while true:
		if not J.cmp(v_s_969, v_sec_964, "<"): break
		var _t194 = J.G.get("produce")
		J.cl(_t194, null, [J.min_([60.0, J.sub(v_sec_964, v_s_969)])])
		var _t195 = J.add(v_s_969, 60.0)
		v_s_969 = _t195
	v_parts_968 = []
	for _t196 in J.iter(["wood", "rice", "planks", "buns", "troops", "coins"]):
		v_k_970 = _t196
		v_d_971 = floor(J.num(J.sub(J.gp(J.gp(J.G.get("S"), "res"), v_k_970), J.gp(v_before_965, v_k_970))))
		if J.cmp(v_d_971, 0.0, ">"):
			var _t198 = J.gp(J.G.get("RES_NAMES"), v_k_970)
			var _t197 = J.G.get("fmt")
			J.mc(v_parts_968, "push", [(J.str(_t198) + " +" + J.str(J.cl(_t197, null, [v_d_971])))])
	var _t199 = J.G.get("S")
	var _t200 = J.S_Date_("now", [])
	J.sp(_t199, "last", _t200)
	if J.t(J.len(v_parts_968)):
		J.mc(J.G.get("Story"), "queue", [{"style": "sys", "lines": [["系統", ("親，你離開了 " + J.str(floor(J.num(J.div(v_sec_964, 3600.0)))) + " 小時 " + J.str(floor(J.num(J.div(J.mod(v_sec_964, 3600.0), 60.0)))) + " 分鐘。鬼怪們沒有偷懶哦～（最多計 8 小時）")], ["旁白", J.add("離線收益：", J.mc(v_parts_968, "join", ["，"]))]]}])

func _f260(this_, a: Array, env):
	return J.mc(J.G.get("Web"), "init", [])

func _f259(this_, a: Array, env):
	var _t201 = (J.G.get("SPR_READY") if (not J.seq(J.typeof_(J.G.get("SPR_READY")), "undefined")) else J.S_Promise_("resolve", []))
	var _t202 = J.mc(_t201, "then", [J.G.get("startGame"), J.G.get("startGame")])
	return J.mc(_t202, "then", [Callable(self, "_f260").bind(env)])

func _f258(this_, a: Array, env):
	return null
	if J.t(J.mc(J.G.get("Web"), "boot", [])):
		return null
	J.mc(J.G.get("Web"), "receive", [Callable(self, "_f259").bind(env)])

func _f263(this_, a: Array, env):
	J.mc(J.G.get("Sound"), "play", ["click"])
	var _t210 = J.seq(J.gp(J.gp(env["b"], "dataset"), "t"), "battle")
	if ((not J.seq(J.typeof_(J.G.get("World")), "undefined")) if _t210 else _t210):
		J.mc(J.G.get("UI"), "close", [])
		J.mc(J.G.get("World"), "open", [])
		return null
	J.mc(J.G.get("UI"), "open", [J.gp(J.gp(env["b"], "dataset"), "t")])

func _f262(this_, a: Array, env):
	var _s541 = {"__p": env, "b": null}
	_s541["b"] = J.arg(a, 0)
	var _t209 = _s541["b"]
	var _t211 = Callable(self, "_f263").bind(_s541)
	J.sp(_t209, "onclick", _t211)
	return _t211

func _f264(this_, a: Array, env):
	J.mc(J.G.get("Sound"), "toggle", [])
	J.cl(J.G.get("syncSnd"), null, [])

func _f265(this_, a: Array, env):
	return J.mc(J.G.get("UI"), "close", [])

func _f267(this_, a: Array, env):
	var _t221 = J.gp(env["__p"]["RES_HELP"], J.gp(env["el"], "title"))
	var _t220 = J.seq(J.gp(env["el"], "title"), "陰兵")
	return J.mc(J.G.get("Fx"), "toast", [J.add(_t221, ("<br>（建好民宅，遊魂才會來）" if ((not J.t(J.gp(J.gp(J.G.get("S"), "bld"), "home"))) if _t220 else _t220) else ""))])

func _f266(this_, a: Array, env):
	var _s546 = {"__p": env, "el": null}
	_s546["el"] = J.arg(a, 0)
	var _t219 = _s546["el"]
	var _t222 = Callable(self, "_f267").bind(_s546)
	J.sp(_t219, "onclick", _t222)
	return _t222

func _f268(this_, a: Array, env):
	var v_p_982 = null; var v_q_983 = null
	v_p_982 = J.mc(J.G.get("Village"), "questTarget", [])
	v_q_983 = J.mc(J.G.get("Quest"), "cur", [])
	if J.t((J.seq(J.gp(v_q_983, "go"), "roster") if J.t(v_q_983) else v_q_983)):
		J.mc(J.G.get("UI"), "open", ["roster"])
		return null
	var _t225 = (J.seq(J.gp(v_q_983, "go"), "gate") if J.t(v_q_983) else v_q_983)
	if J.t((J.seq(J.gp(J.mc(J.G.get("Quest"), "cur", []), "t"), "stage") if J.t(_t225) else _t225)):
		J.mc(J.G.get("UI"), "open", ["battle"])
		return null
	if J.t(v_p_982):
		J.mc(J.G.get("UI"), "close", [])
		J.mc(J.G.get("Village"), "focus", [J.gp(v_p_982, 0.0), J.gp(v_p_982, 1.0)])

func _f269(this_, a: Array, env):
	if J.t(J.gp(J.G.get("document"), "hidden")):
		J.cl(J.G.get("save"), null, [])
	else:
		if J.t(((not J.t(J.gp(J.G.get("Phone"), "on"))) if J.t(J.G.get("S")) else J.G.get("S"))):
			J.cl(J.G.get("offlineGain"), null, [])

func _f270(this_, a: Array, env):
	return J.G.get("S")

func _f271(this_, a: Array, env):
	var v_k_984 = null
	v_k_984 = J.arg(a, 0)
	J.G["TIME_SCALE"] = v_k_984
	return J.G.get("TIME_SCALE")

func _f261(this_, a: Array, env):
	var v_fresh_976 = null; var v_d_977 = null; var v_k_979 = null
	var _s539 = {"__p": env, "RES_HELP": null}
	var _t203 = J.cl(J.G.get("load"), null, [])
	J.G["S"] = _t203
	v_fresh_976 = (not J.t(J.G.get("S")))
	if (not J.t(J.G.get("S"))):
		var _t204 = J.cl(J.G.get("newState"), null, [])
		J.G["S"] = _t204
	v_d_977 = J.cl(J.G.get("newState"), null, [])
	for _t205 in J.keys(v_d_977):
		v_k_979 = _t205
		if J.seq(J.gp(J.G.get("S"), v_k_979), null):
			var _t206 = J.G.get("S")
			var _t207 = J.gp(v_d_977, v_k_979)
			J.sp(_t206, v_k_979, _t207)
	if (not J.seq(J.typeof_(J.G.get("Guide")), "undefined")):
		J.mc(J.G.get("Guide"), "migrate", [v_fresh_976])
	J.mc(J.G.get("Village"), "init", [])
	J.mc(J.G.get("Battle"), "init", [])
	var _t208 = J.S_document_("querySelectorAll", ["#nav button"])
	J.mc(_t208, "forEach", [Callable(self, "_f262").bind(_s539)])
	var _t212 = J.G.get("$")
	var _t213 = J.cl(_t212, null, ["#sndtop"])
	var _t214 = Callable(self, "_f264").bind(_s539)
	J.sp(_t213, "onclick", _t214)
	J.cl(J.G.get("syncSnd"), null, [])
	var _t215 = J.G.get("$")
	var _t216 = J.cl(_t215, null, ["#sheet .sh-close"])
	var _t217 = Callable(self, "_f265").bind(_s539)
	J.sp(_t216, "onclick", _t217)
	_s539["RES_HELP"] = {"槐木": "槐木：主公親手砍樹，或派鬼怪去<b>伐木場</b>伐木。", "糯米": "糯米：主公親手收割，或派鬼怪去<b>糯米田</b>割稻。", "棺材板": "棺材板：在<b>棺材鋪</b>把 2 槐木做成 1 板（力量高的鬼做得快）。藍箱也會開出。用來建造和升級建築。", "壽包": "壽包：在<b>包子鋪</b>把 2 糯米包成 1 個（智力高的鬼包得快）。綠箱也會開出。用來升級鬼怪、練陰兵。", "冥幣": "冥幣：打關卡、開紫箱、燒<b>化寶爐</b>。Toyol 管倉庫時也會「撿到」冥幣。", "陰兵": "陰兵：村裡的遊魂見你有地盤，自願加入。<b>民宅</b>越高級來得越快、上限越高。夜班巡陰時每 25 個跟一隊（最多 4 隊），倒下的會扣掉。"}
	var _t218 = J.S_document_("querySelectorAll", ["#resbox .rs"])
	J.mc(_t218, "forEach", [Callable(self, "_f266").bind(_s539)])
	var _t223 = J.G.get("$")
	var _t224 = J.cl(_t223, null, ["#quest"])
	var _t226 = Callable(self, "_f268").bind(_s539)
	J.sp(_t224, "onclick", _t226)
	if (not J.t((J.mc(J.re("nophone", ""), "test", [J.gp(J.G.get("location"), "search")]) if J.t(J.G.get("DEBUG")) else J.G.get("DEBUG")))):
		J.mc(J.G.get("Title"), "show", [v_fresh_976])
	J.mc(J.G.get("UI"), "refresh", [])
	J.F_requestAnimationFrame([J.G.get("loop")])
	J.S_window_("addEventListener", ["beforeunload", J.G.get("save")])
	J.S_document_("addEventListener", ["visibilitychange", Callable(self, "_f269").bind(_s539)])
	if J.t(J.G.get("DEBUG")):
		var _t227 = J.G.get("window")
		var _t228 = {"JossFx": J.G.get("JossFx"), "Phone": J.G.get("Phone"), "Sound": J.G.get("Sound"), "S": Callable(self, "_f270").bind(_s539), "F": J.G.get("F"), "Quest": J.G.get("Quest"), "Village": J.G.get("Village"), "Battle": J.G.get("Battle"), "Story": J.G.get("Story"), "UI": J.G.get("UI"), "give": J.G.get("give"), "setScale": Callable(self, "_f271").bind(_s539), "produce": J.G.get("produce"), "joinGhost": J.G.get("joinGhost"), "recruitFodder": J.G.get("recruitFodder"), "ratesPerMin": J.G.get("ratesPerMin"), "save": J.G.get("save")}
		J.sp(_t227, "G", _t228)

func _f1(this_, a: Array, env):
	var v_q_60 = null
	v_q_60 = J.arg(a, 0)
	return J.S_document_("querySelector", [v_q_60])

func _f2(this_, a: Array, env):
	var v_n_61 = null
	v_n_61 = J.arg(a, 0)
	var _t229 = floor(J.num(v_n_61))
	v_n_61 = _t229
	if J.cmp(v_n_61, 1000000.0, ">="):
		var _t230 = J.div(v_n_61, 1000000.0)
		return J.add(J.mc(_t230, "toFixed", [1.0]), "M")
	if J.cmp(v_n_61, 10000.0, ">="):
		var _t231 = J.div(v_n_61, 1000.0)
		return J.add(J.mc(_t231, "toFixed", [1.0]), "K")
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
	var _t232 = J.round(J.num(J.mul(v_planks_83, J.sub(1.0, J.mc(J.G.get("F"), "builderDiscount", [])))))
	v_planks_83 = _t232
	return {"planks": v_planks_83, "coins": v_coins_84}

func _f13(this_, a: Array, env):
	var v_g_85 = null
	var _t233 = J.G.get("workersAt")
	v_g_85 = J.gp(J.cl(_t233, null, ["boss"]), 0.0)
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
	var _t234 = J.G.get("workersAt")
	v_m_91 = J.gp(J.cl(_t234, null, ["store"]), 0.0)
	if J.t(v_m_91):
		var _t235 = J.mul(v_c_90, (1.0 + J.div(J.mc(J.G.get("F"), "stat", [v_m_91, 2.0]), 100.0)))
		v_c_90 = _t235
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
	var _t236 = J.gp(v_q_170, "t")
	var _t237 = -1
	var _t238 = false
	if _t237 == -1 and J.seq(_t236, "chop"): _t237 = 0
	if _t237 == -1 and J.seq(_t236, "rice"): _t237 = 1
	if _t237 == -1 and J.seq(_t236, "craftPlank"): _t237 = 2
	if _t237 == -1 and J.seq(_t236, "craftBun"): _t237 = 3
	if _t237 == -1 and J.seq(_t236, "level"): _t237 = 4
	if _t237 == -1 and J.seq(_t236, "build"): _t237 = 5
	if _t237 == -1 and J.seq(_t236, "bLevel"): _t237 = 6
	if _t237 == -1 and J.seq(_t236, "assign"): _t237 = 7
	if _t237 == -1 and J.seq(_t236, "stage"): _t237 = 8
	if _t237 == -1 and J.seq(_t236, "recruit"): _t237 = 9
	if _t237 == -1 and J.seq(_t236, "ghostLv"): _t237 = 10
	if _t237 == -1 and J.seq(_t236, "troops"): _t237 = 11
	if _t237 == -1 and J.seq(_t236, "drill"): _t237 = 12
	if _t237 == -1 and J.seq(_t236, "feast"): _t237 = 13
	if _t237 == -1 and J.seq(_t236, "visit"): _t237 = 14
	while true:
		if _t237 <= 0 and _t237 >= 0:
			return [J.gp(J.gp(J.G.get("S"), "cnt"), "chop"), J.gp(v_q_170, "n")]
		if _t237 <= 1 and _t237 >= 0:
			return [J.gp(J.gp(J.G.get("S"), "cnt"), "rice"), J.gp(v_q_170, "n")]
		if _t237 <= 2 and _t237 >= 0:
			return [J.gp(J.gp(J.G.get("S"), "cnt"), "craftPlank"), J.gp(v_q_170, "n")]
		if _t237 <= 3 and _t237 >= 0:
			return [J.gp(J.gp(J.G.get("S"), "cnt"), "craftBun"), J.gp(v_q_170, "n")]
		if _t237 <= 4 and _t237 >= 0:
			return [J.gp(J.G.get("S"), "lv"), J.gp(v_q_170, "n")]
		if _t237 <= 5 and _t237 >= 0:
			return [(1.0 if J.t(J.gp(J.gp(J.G.get("S"), "bld"), J.gp(v_q_170, "b"))) else 0.0), 1.0]
		if _t237 <= 6 and _t237 >= 0:
			return [J.gp(J.gp(J.G.get("S"), "bld"), J.gp(v_q_170, "b")), J.gp(v_q_170, "n")]
		if _t237 <= 7 and _t237 >= 0:
			var _t239 = J.gp(J.G.get("S"), "ghosts")
			return [J.len(J.mc(_t239, "filter", [Callable(self, "_f46").bind(env)])), J.gp(v_q_170, "n")]
		if _t237 <= 8 and _t237 >= 0:
			return [(1.0 if J.t(J.gp(J.gp(J.G.get("S"), "cleared"), J.gp(v_q_170, "s"))) else 0.0), 1.0]
		if _t237 <= 9 and _t237 >= 0:
			return [J.gp(J.gp(J.G.get("S"), "cnt"), "recruit"), J.gp(v_q_170, "n")]
		if _t237 <= 10 and _t237 >= 0:
			var _t240 = J.gp(J.G.get("S"), "ghosts")
			var _t241 = J.mc(_t240, "filter", [Callable(self, "_f47").bind(env)])
			return [J.max_(J.spread([J.SP(J.mc(_t241, "map", [Callable(self, "_f48").bind(env)])), 0.0])), J.gp(v_q_170, "n")]
		if _t237 <= 11 and _t237 >= 0:
			return [floor(J.num(J.gp(J.gp(J.G.get("S"), "res"), "troops"))), J.gp(v_q_170, "n")]
		if _t237 <= 12 and _t237 >= 0:
			var _t242 = J.gp(J.G.get("S"), "drill")
			var _t243 = J.S_Object_("values", [(_t242 if J.t(_t242) else {})])
			v_m_174 = J.max_(J.spread([0.0, J.SP(J.mc(_t243, "concat", [[0.0]]))]))
			return [floor(J.num(J.min_([v_m_174, J.gp(v_q_170, "n")]))), J.gp(v_q_170, "n")]
		if _t237 <= 13 and _t237 >= 0:
			return [J.gp(J.gp(J.G.get("S"), "cnt"), "feast"), J.gp(v_q_170, "n")]
		if _t237 <= 14 and _t237 >= 0:
			var _t244 = J.gp(J.G.get("S"), "visit")
			return [(1.0 if J.t((J.gp(J.gp(J.G.get("S"), "visit"), J.gp(v_q_170, "place")) if J.t(_t244) else _t244)) else 0.0), 1.0]
		break
	return [0.0, 1.0]

func _f49(this_, a: Array, env):
	var v_q_177 = null; var v_a_178 = null; var v_b_179 = null
	v_q_177 = J.arg(a, 0)
	var _t245 = J.mc(this_, "progress", [v_q_177])
	var _t246 = J.gp(_t245, 0.0)
	v_a_178 = _t246
	var _t247 = J.gp(_t245, 1.0)
	v_b_179 = _t247
	return J.cmp(v_a_178, v_b_179, ">=")

func _f51(this_, a: Array, env):
	var _t253 = J.G.get("joinGhost")
	return J.cl(_t253, null, ["tianhua"])

func _f50(this_, a: Array, env):
	var v_q_182 = null
	v_q_182 = J.mc(this_, "cur", [])
	if (not J.t(v_q_182)):
		return null
	var _t248 = J.mc(this_, "done", [v_q_182])
	if J.t(((not J.t(J.mc(J.G.get("Story"), "busy", []))) if J.t(_t248) else _t248)):
		J.mc(this_, "complete", [])
	var _t249 = J.gp(J.gp(J.G.get("S"), "seen"), "ch2_end")
	var _t250 = (J.cmp(J.gp(J.gp(J.G.get("S"), "bld"), "house"), 4.0, ">=") if J.t(_t249) else _t249)
	var _t251 = ((not J.t(J.gp(J.gp(J.G.get("S"), "seen"), "side_tianhua"))) if J.t(_t250) else _t250)
	var _t252 = ((not J.t(J.mc(J.G.get("Story"), "busy", []))) if J.t(_t251) else _t251)
	if J.t(((not J.t(J.gp(J.G.get("Battle"), "active"))) if J.t(_t252) else _t252)):
		J.mc(J.G.get("Story"), "queue", ["side_tianhua", Callable(self, "_f51").bind(env)])

func _f53(this_, a: Array, env):
	var v_id_188 = null
	v_id_188 = J.arg(a, 0)
	if (not J.t(J.gp(J.gp(J.G.get("S"), "seen"), v_id_188))):
		J.mc(J.G.get("Story"), "queue", [v_id_188])

func _f52(this_, a: Array, env):
	var v_q_185 = null; var v_txt_186 = null; var v_nq_187 = null
	v_q_185 = J.mc(this_, "cur", [])
	var _t254 = J.G.get("S")
	J.sp(_t254, "qi", J.num(J.gp(_t254, "qi")) + 1.0)
	var _t255 = J.G.get("give")
	v_txt_186 = J.cl(_t255, null, [J.gp(v_q_185, "r")])
	J.mc(J.G.get("Sound"), "play", ["coin"])
	J.mc(J.G.get("Fx"), "toast", [(("任務完成：" + J.str(J.gp(v_q_185, "text")) + "<br><b>" + J.str(v_txt_186) + "</b>") + (("<br>" + J.str(J.gp(v_q_185, "note"))) if J.t(J.gp(v_q_185, "note")) else ""))])
	v_nq_187 = J.mc(this_, "cur", [])
	if J.t((J.gp(v_nq_187, "onStart") if J.t(v_nq_187) else v_nq_187)):
		var _t256 = J.gp(v_nq_187, "onStart")
		J.mc(_t256, "forEach", [Callable(self, "_f53").bind(env)])
	J.cl(J.G.get("save"), null, [])
	J.mc(J.G.get("UI"), "refresh", [])

func _f55(this_, a: Array, env):
	return J.mc(env["this"], "resize", [])

func _f56(this_, a: Array, env):
	var v_e_195 = null; var v_p_196 = null
	v_e_195 = J.arg(a, 0)
	v_p_196 = J.mc(env["this"], "pt", [v_e_195])
	var _t263 = env["this"]
	var _t264 = {"y0": J.gp(v_p_196, "cy"), "cam": J.gp(env["this"], "camY"), "moved": false, "x": J.gp(v_p_196, "cx"), "y": J.gp(v_p_196, "cy")}
	J.sp(_t263, "drag", _t264)

func _f57(this_, a: Array, env):
	var v_e_197 = null; var v_p_198 = null; var v_dy_199 = null
	v_e_197 = J.arg(a, 0)
	if (not J.t(J.gp(env["this"], "drag"))):
		return null
	v_p_198 = J.mc(env["this"], "pt", [v_e_197])
	v_dy_199 = J.sub(J.gp(v_p_198, "cy"), J.gp(J.gp(env["this"], "drag"), "y0"))
	if (absf(J.num(v_dy_199)) > 8.0):
		var _t265 = J.gp(env["this"], "drag")
		J.sp(_t265, "moved", true)
	if J.t(J.gp(J.gp(env["this"], "drag"), "moved")):
		J.mc(env["this"], "setCam", [J.sub(J.gp(J.gp(env["this"], "drag"), "cam"), v_dy_199)])
	J.mc(v_e_197, "preventDefault", [])

func _f58(this_, a: Array, env):
	var v_e_200 = null; var v_d_201 = null
	v_e_200 = J.arg(a, 0)
	if (not J.t(J.gp(env["this"], "drag"))):
		return null
	v_d_201 = J.gp(env["this"], "drag")
	var _t266 = env["this"]
	J.sp(_t266, "drag", null)
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
	var _t257 = _s89["this"]
	var _t258 = J.G.get("$")
	var _t259 = J.cl(_t258, null, ["#village"])
	J.sp(_t257, "cvs", _t259)
	var _t260 = _s89["this"]
	var _t261 = J.gp(_s89["this"], "cvs")
	var _t262 = J.mc(_t261, "getContext", ["2d"])
	J.sp(_t260, "ctx", _t262)
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
	var _t267 = _s89["this"]
	J.sp(_t267, "camY", 180.0)

func _f60(this_, a: Array, env):
	var v_r_205 = null
	v_r_205 = J.mc(J.gp(this_, "cvs"), "getBoundingClientRect", [])
	var _t268 = this_
	var _t269 = J.gp(J.G.get("window"), "devicePixelRatio")
	var _t270 = J.gp(J.G.get("window"), "devicePixelRatio")
	var _t271 = J.min_([2.0, (_t270 if J.t(_t270) else 1.0)])
	J.sp(_t268, "dpr", _t271)
	var _t272 = this_
	var _t273 = J.gp(v_r_205, "width")
	J.sp(_t272, "w", _t273)
	var _t274 = this_
	var _t275 = J.gp(v_r_205, "height")
	J.sp(_t274, "h", _t275)
	var _t276 = J.gp(this_, "cvs")
	var _t277 = J.mul(J.gp(v_r_205, "width"), J.gp(this_, "dpr"))
	J.sp(_t276, "width", _t277)
	var _t278 = J.gp(this_, "cvs")
	var _t279 = J.mul(J.gp(v_r_205, "height"), J.gp(this_, "dpr"))
	J.sp(_t278, "height", _t279)
	var _t280 = this_
	var _t281 = J.div(J.gp(this_, "w"), J.G.get("W"))
	J.sp(_t280, "scale", _t281)
	J.mc(this_, "setCam", [J.gp(this_, "camY")])

func _f61(this_, a: Array, env):
	var v_y_208 = null; var v_vh_209 = null
	v_y_208 = J.arg(a, 0)
	v_vh_209 = J.div(J.gp(this_, "h"), J.gp(this_, "scale"))
	var _t282 = this_
	var _t283 = J.max_([0.0, J.min_([J.sub(J.G.get("WH"), v_vh_209), v_y_208])])
	J.sp(_t282, "camY", _t283)

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
		var _t284 = J.gp(J.G.get("TREE_POS"), v_i_222)
		var _t285 = J.gp(_t284, 0.0)
		v_tx_223 = _t285
		var _t286 = J.gp(_t284, 1.0)
		v_ty_224 = _t286
		var _t287 = (absf(J.num(J.sub(v_x_220, v_tx_223))) < 24.0)
		var _t288 = (J.cmp(v_y_221, J.sub(v_ty_224, 72.0), ">") if _t287 else _t287)
		if (J.cmp(v_y_221, J.add(v_ty_224, 8.0), "<") if _t288 else _t288):
			return {"kind": "tree", "i": v_i_222}
		v_i_222 = J.num(v_i_222) + 1.0
	v_i_225 = 0.0
	while true:
		if not J.cmp(v_i_225, J.len(J.G.get("PADDY_POS")), "<"): break
		var _t289 = J.gp(J.G.get("PADDY_POS"), v_i_225)
		var _t290 = J.gp(_t289, 0.0)
		v_px_226 = _t290
		var _t291 = J.gp(_t289, 1.0)
		v_py_227 = _t291
		var _t292 = (absf(J.num(J.sub(v_x_220, v_px_226))) < 26.0)
		if ((absf(J.num((J.sub(v_y_221, v_py_227) + 4.0))) < 16.0) if _t292 else _t292):
			return {"kind": "paddy", "i": v_i_225}
		v_i_225 = J.num(v_i_225) + 1.0
	for _t293 in J.iter(J.S_Object_("keys", [J.G.get("POS")])):
		v_id_228 = _t293
		var _t294 = J.gp(J.G.get("POS"), v_id_228)
		var _t295 = J.gp(_t294, 0.0)
		v_bx_229 = _t295
		var _t296 = J.gp(_t294, 1.0)
		v_by_230 = _t296
		v_w_231 = (70.0 if J.seq(v_id_228, "house") else (65.0 if J.seq(v_id_228, "gate") else (26.0 if J.seq(v_id_228, "furnace") else 46.0)))
		v_h_232 = (115.0 if J.seq(v_id_228, "house") else (92.0 if J.seq(v_id_228, "gate") else 70.0))
		var _t297 = J.cmp(absf(J.num(J.sub(v_x_220, v_bx_229))), v_w_231, "<")
		var _t298 = (J.cmp(v_y_221, J.sub(v_by_230, v_h_232), ">") if _t297 else _t297)
		if (J.cmp(v_y_221, J.add(v_by_230, 10.0), "<") if _t298 else _t298):
			return {"kind": ("gate" if J.seq(v_id_228, "gate") else "bld"), "id": v_id_228}
	return null

func _f65(this_, a: Array, env):
	var v_x_235 = null; var v_y_236 = null; var v_h_237 = null
	v_x_235 = J.arg(a, 0)
	v_y_236 = J.arg(a, 1)
	var _t299 = J.mc(J.G.get("Story"), "busy", [])
	if J.t((_t299 if J.t(_t299) else J.mc(J.G.get("UI"), "modalOpen", []))):
		return null
	var _t300 = (not J.seq(J.typeof_(J.G.get("HeroDaily")), "undefined"))
	if J.t((J.mc(J.G.get("HeroDaily"), "tap", [this_, v_x_235, v_y_236]) if _t300 else _t300)):
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
	var _t301 = J.max_([14.0, J.min_([J.sub(J.G.get("W"), 14.0), v_x_240])])
	J.sp(v_H_243, "tx", _t301)
	var _t302 = J.max_([150.0, J.min_([J.sub(J.G.get("WH"), 10.0), v_y_241])])
	J.sp(v_H_243, "ty", _t302)
	J.sp(v_H_243, "target", v_target_242)
	J.sp(v_H_243, "act", null)

func _f67(this_, a: Array, env):
	var v_bid_246 = null; var v_n_247 = null; var v_src_248 = null; var v_can_249 = null; var v_bx_250 = null; var v_by_251 = null
	v_bid_246 = J.arg(a, 0)
	v_n_247 = J.arg(a, 1)
	var _t303 = J.bor(v_n_247, 0.0)
	var _t304 = J.bor(v_n_247, 0.0)
	var _t305 = J.max_([1.0, (_t304 if J.t(_t304) else 1.0)])
	v_n_247 = _t305
	v_src_248 = ("wood" if J.seq(v_bid_246, "plank") else "rice")
	v_can_249 = floor(J.num(J.div(J.gp(J.gp(J.G.get("S"), "res"), v_src_248), 4.0)))
	if J.cmp(v_can_249, 1.0, "<"):
		J.mc(J.G.get("Fx"), "float", [J.gp(J.gp(this_, "hero"), "x"), J.sub(J.gp(J.gp(this_, "hero"), "y"), 60.0), (J.str(J.gp(J.G.get("RES_NAMES"), v_src_248)) + "不夠（要 4）"), "#ff9a9a"])
		return null
	if J.cmp(v_can_249, v_n_247, "<"):
		J.mc(J.G.get("Fx"), "float", [J.gp(J.gp(this_, "hero"), "x"), J.sub(J.gp(J.gp(this_, "hero"), "y"), 60.0), ("材料只夠做 " + J.str(v_can_249) + " 份"), "#ffb37a"])
	var _t306 = J.gp(J.G.get("POS"), v_bid_246)
	var _t307 = J.gp(_t306, 0.0)
	v_bx_250 = _t307
	var _t308 = J.gp(_t306, 1.0)
	v_by_251 = _t308
	J.mc(this_, "walkTo", [J.add(v_bx_250, (40.0 if J.seq(v_bid_246, "plank") else (-40.0))), J.add(v_by_251, 14.0), {"kind": "craft", "bid": v_bid_246, "n": v_n_247, "want": v_n_247, "done": 0.0, "short": J.cmp(v_can_249, v_n_247, "<"), "dur": 0.9}])

func _f69(this_, a: Array, env):
	var v_f_262 = null
	v_f_262 = J.arg(a, 0)
	var _t327 = J.add(J.gp(v_f_262, "t"), env["dt"])
	J.sp(v_f_262, "t", _t327)
	return J.cmp(_t327, J.gp(v_f_262, "life"), "<")

func _f70(this_, a: Array, env):
	var v_f_263 = null
	v_f_263 = J.arg(a, 0)
	var _t331 = J.add(J.gp(v_f_263, "t"), env["dt"])
	J.sp(v_f_263, "t", _t331)
	var _t332 = J.add(J.gp(v_f_263, "x"), (J.mul(J.gp(v_f_263, "vx"), env["dt"]) + (sin(J.num(J.mul(J.gp(v_f_263, "t"), 4.0))) * 0.4)))
	J.sp(v_f_263, "x", _t332)
	var _t333 = J.add(J.gp(v_f_263, "y"), J.mul(14.0, env["dt"]))
	J.sp(v_f_263, "y", _t333)
	var _t334 = J.add(J.gp(v_f_263, "rot"), J.mul(env["dt"], 2.0))
	J.sp(v_f_263, "rot", _t334)
	return J.cmp(J.gp(v_f_263, "t"), J.gp(v_f_263, "life"), "<")

func _f71(this_, a: Array, env):
	var v_c_264 = null
	v_c_264 = J.arg(a, 0)
	var _t338 = J.add(J.gp(v_c_264, "t"), env["dt"])
	J.sp(v_c_264, "t", _t338)
	var _t339 = J.add(J.gp(v_c_264, "x"), J.mul(J.gp(v_c_264, "vx"), env["dt"]))
	J.sp(v_c_264, "x", _t339)
	var _t340 = J.add(J.gp(v_c_264, "y"), J.mul(J.gp(v_c_264, "vy"), env["dt"]))
	J.sp(v_c_264, "y", _t340)
	var _t341 = J.sub(J.gp(v_c_264, "vy"), J.mul(30.0, env["dt"]))
	J.sp(v_c_264, "vy", _t341)
	var _t342 = J.add(J.gp(v_c_264, "ph"), J.mul(env["dt"], 22.0))
	J.sp(v_c_264, "ph", _t342)
	return J.cmp(J.gp(v_c_264, "t"), J.gp(v_c_264, "life"), "<")

func _f68(this_, a: Array, env):
	var v_H_255 = null; var v_dx_256 = null; var v_dy_257 = null; var v_d_258 = null; var v_i_259 = null; var v_i_260 = null; var v_sp_261 = null
	var _s115 = {"__p": env, "dt": null}
	_s115["dt"] = J.arg(a, 0)
	if J.cmp(J.gp(this_, "hitstop"), 0.0, ">"):
		var _t309 = this_
		var _t310 = J.sub(J.gp(_t309, "hitstop"), _s115["dt"])
		J.sp(_t309, "hitstop", _t310)
		J.mc(this_, "updateParts", [J.mul(_s115["dt"], 0.3), true])
		return null
	var _t311 = this_
	var _t312 = J.add(J.gp(_t311, "t"), _s115["dt"])
	J.sp(_t311, "t", _t312)
	v_H_255 = J.gp(this_, "hero")
	v_i_259 = 0.0
	while true:
		if not J.cmp(v_i_259, J.len(J.gp(J.G.get("S"), "trees")), "<"): break
		if J.cmp(J.gp(J.gp(J.G.get("S"), "trees"), v_i_259), 0.0, "<="):
			var _t313 = J.gp(J.G.get("S"), "treeRegrow")
			var _t314 = J.sub(J.gp(_t313, v_i_259), _s115["dt"])
			J.sp(_t313, v_i_259, _t314)
			if J.cmp(J.gp(J.gp(J.G.get("S"), "treeRegrow"), v_i_259), 0.0, "<="):
				var _t315 = J.gp(J.G.get("S"), "trees")
				J.sp(_t315, v_i_259, 3.0)
		v_i_259 = J.num(v_i_259) + 1.0
	v_i_260 = 0.0
	while true:
		if not J.cmp(v_i_260, J.len(J.gp(J.G.get("S"), "paddy")), "<"): break
		if (not J.t(J.gp(J.gp(J.G.get("S"), "paddy"), v_i_260))):
			var _t316 = J.gp(J.G.get("S"), "paddyRegrow")
			var _t317 = J.sub(J.gp(_t316, v_i_260), _s115["dt"])
			J.sp(_t316, v_i_260, _t317)
			if J.cmp(J.gp(J.gp(J.G.get("S"), "paddyRegrow"), v_i_260), 0.0, "<="):
				var _t318 = J.gp(J.G.get("S"), "paddy")
				J.sp(_t318, v_i_260, 1.0)
		v_i_260 = J.num(v_i_260) + 1.0
	v_dx_256 = J.sub(J.gp(v_H_255, "tx"), J.gp(v_H_255, "x"))
	v_dy_257 = J.sub(J.gp(v_H_255, "ty"), J.gp(v_H_255, "y"))
	v_d_258 = J.hypot_([v_dx_256, v_dy_257])
	if J.cmp(v_d_258, 2.0, ">"):
		v_sp_261 = J.mul(J.mc(J.G.get("F"), "walk", []), _s115["dt"])
		var _t319 = J.add(J.gp(v_H_255, "x"), (J.div(v_dx_256, v_d_258) * J.min_([v_sp_261, v_d_258])))
		J.sp(v_H_255, "x", _t319)
		var _t320 = J.add(J.gp(v_H_255, "y"), (J.div(v_dy_257, v_d_258) * J.min_([v_sp_261, v_d_258])))
		J.sp(v_H_255, "y", _t320)
		if (absf(J.num(v_dx_256)) > 1.0):
			var _t321 = (1.0 if J.cmp(v_dx_256, 0.0, ">") else (-1.0))
			J.sp(v_H_255, "dir", _t321)
		J.sp(v_H_255, "walking", true)
	else:
		J.sp(v_H_255, "walking", false)
		if J.t(J.gp(v_H_255, "target")):
			var _t322 = J.gp(v_H_255, "target")
			J.sp(v_H_255, "act", _t322)
			J.sp(v_H_255, "target", null)
			J.sp(v_H_255, "actT", 0.0)
			if J.seq(J.gp(J.gp(v_H_255, "act"), "kind"), "tree"):
				var _t323 = (-1.0)
				J.sp(v_H_255, "dir", _t323)
			if J.seq(J.gp(J.gp(v_H_255, "act"), "kind"), "paddy"):
				J.sp(v_H_255, "dir", 1.0)
			if J.seq(J.gp(J.gp(v_H_255, "act"), "kind"), "craft"):
				var _t324 = ((-1.0) if J.seq(J.gp(J.gp(v_H_255, "act"), "bid"), "plank") else 1.0)
				J.sp(v_H_255, "dir", _t324)
		if J.t(J.gp(v_H_255, "act")):
			J.mc(this_, "doAct", [J.mul(_s115["dt"], (J.mc(J.G.get("GhostStreet"), "mul", ["work"]) if (not J.seq(J.typeof_(J.G.get("GhostStreet")), "undefined")) else 1.0))])
	J.mc(this_, "updateParts", [_s115["dt"]])
	if (not J.seq(J.typeof_(J.G.get("HeroDaily")), "undefined")):
		J.mc(J.G.get("HeroDaily"), "update", [this_, _s115["dt"]])
	var _t325 = this_
	var _t326 = J.gp(this_, "floats")
	var _t328 = J.mc(_t326, "filter", [Callable(self, "_f69").bind(_s115)])
	J.sp(_t325, "floats", _t328)
	var _t329 = this_
	var _t330 = J.gp(this_, "feathers")
	var _t335 = J.mc(_t330, "filter", [Callable(self, "_f70").bind(_s115)])
	J.sp(_t329, "feathers", _t335)
	var _t336 = this_
	var _t337 = J.gp(this_, "crows")
	var _t343 = J.mc(_t337, "filter", [Callable(self, "_f71").bind(_s115)])
	J.sp(_t336, "crows", _t343)
	var _t346 = J.gp(this_, "bubble")
	if J.t(_t346):
		var _t344 = J.gp(this_, "bubble")
		var _t345 = J.add(J.gp(_t344, "t"), _s115["dt"])
		J.sp(_t344, "t", _t345)
		_t346 = J.cmp(_t345, 4.6, ">")
	if J.t(_t346):
		var _t347 = this_
		J.sp(_t347, "bubble", null)
	var _t348 = this_
	var _t349 = J.sub(J.gp(_t348, "chatT"), _s115["dt"])
	J.sp(_t348, "chatT", _t349)
	var _t350 = J.cmp(J.gp(this_, "chatT"), 0.0, "<=")
	if ((not J.t(J.gp(this_, "bubble"))) if _t350 else _t350):
		var _t351 = this_
		var _t352 = (6.0 + (randf() * 5.0))
		J.sp(_t351, "chatT", _t352)
		J.mc(this_, "pickChatter", [])

func _f72(this_, a: Array, env):
	var v_dt_267 = null; var v_H_268 = null; var v_a_269 = null; var v_firstHit_270 = null; var v_tx_271 = null; var v_ty_272 = null; var v_tx0_273 = null; var v_ty0_274 = null; var v_px_275 = null; var v_py_276 = null; var v_plank_277 = null; var v_src_278 = null; var v_out_279 = null; var v_more_280 = null
	v_dt_267 = J.arg(a, 0)
	v_H_268 = J.gp(this_, "hero")
	v_a_269 = J.gp(v_H_268, "act")
	var _t353 = J.add(J.gp(v_H_268, "actT"), v_dt_267)
	J.sp(v_H_268, "actT", _t353)
	if J.seq(J.gp(v_a_269, "kind"), "tree"):
		if J.cmp(J.gp(J.gp(J.G.get("S"), "trees"), J.gp(v_a_269, "i")), 0.0, "<="):
			J.sp(v_H_268, "act", null)
			return null
		if J.cmp(J.gp(v_H_268, "actT"), J.mc(J.G.get("F"), "chopTime", []), ">="):
			J.sp(v_H_268, "actT", 0.0)
			v_firstHit_270 = J.seq(J.gp(J.gp(J.G.get("S"), "trees"), J.gp(v_a_269, "i")), 3.0)
			var _t354 = J.gp(J.G.get("S"), "trees")
			var _t355 = J.gp(v_a_269, "i")
			J.sp(_t354, _t355, J.num(J.gp(_t354, _t355)) + -1.0)
			J.sp(v_a_269, "shake", 0.15)
			J.mc(J.G.get("Sound"), "play", ["chop"])
			var _t356 = J.gp(J.G.get("TREE_POS"), J.gp(v_a_269, "i"))
			var _t357 = J.gp(_t356, 0.0)
			v_tx0_273 = _t357
			var _t358 = J.gp(_t356, 1.0)
			v_ty0_274 = _t358
			J.mc(this_, "impact", [J.add(v_tx0_273, 6.0), J.sub(v_ty0_274, 22.0), "wood", (1.2 if J.t(v_firstHit_270) else 1.0)])
			if J.t(v_firstHit_270):
				J.mc(this_, "scatterCrows", [J.gp(v_a_269, "i")])
			var _t359 = J.gp(J.G.get("TREE_POS"), J.gp(v_a_269, "i"))
			var _t360 = J.gp(_t359, 0.0)
			v_tx_271 = _t360
			var _t361 = J.gp(_t359, 1.0)
			v_ty_272 = _t361
			J.mc(J.G.get("Fx"), "float", [v_tx_271, J.sub(v_ty_272, 50.0), "咚！", "#ffe9a8"])
			if J.cmp(J.gp(J.gp(J.G.get("S"), "trees"), J.gp(v_a_269, "i")), 0.0, "<="):
				var _t362 = J.gp(J.G.get("S"), "treeRegrow")
				var _t363 = J.gp(v_a_269, "i")
				J.sp(_t362, _t363, 25.0)
				var _t364 = J.gp(J.G.get("S"), "cnt")
				J.sp(_t364, "chop", J.num(J.gp(_t364, "chop")) + 1.0)
				var _t365 = J.gp(J.G.get("S"), "res")
				var _t366 = J.add(J.gp(_t365, "wood"), 4.0)
				J.sp(_t365, "wood", _t366)
				var _t367 = J.G.get("gainExp")
				J.cl(_t367, null, [2.0])
				J.mc(J.G.get("Sound"), "play", ["treeFall"])
				J.mc(J.G.get("Fx"), "float", [v_tx_271, J.sub(v_ty_272, 70.0), "槐木 +4　好評 +2", "#a8ffcf"])
				J.mc(J.G.get("Fx"), "praise", ["chop"])
				J.sp(v_H_268, "act", null)
				var _t368 = this_
				J.sp(_t368, "proudT", 0.9)
				var _t369 = this_
				J.sp(_t369, "shk", 5.0)
				J.mc(J.G.get("Quest"), "check", [])
	else:
		if J.seq(J.gp(v_a_269, "kind"), "paddy"):
			if J.cmp(J.gp(v_H_268, "actT"), J.mul(J.mc(J.G.get("F"), "chopTime", []), 1.4), ">="):
				var _t370 = J.gp(J.G.get("S"), "paddy")
				var _t371 = J.gp(v_a_269, "i")
				J.sp(_t370, _t371, 0.0)
				var _t372 = J.gp(J.G.get("S"), "paddyRegrow")
				var _t373 = J.gp(v_a_269, "i")
				J.sp(_t372, _t373, 20.0)
				var _t374 = this_
				J.sp(_t374, "proudT", 0.8)
				var _t375 = J.gp(J.G.get("S"), "cnt")
				J.sp(_t375, "rice", J.num(J.gp(_t375, "rice")) + 1.0)
				var _t376 = J.gp(J.G.get("S"), "res")
				var _t377 = J.add(J.gp(_t376, "rice"), 3.0)
				J.sp(_t376, "rice", _t377)
				var _t378 = J.G.get("gainExp")
				J.cl(_t378, null, [1.0])
				J.mc(J.G.get("Sound"), "play", ["harvest"])
				var _t379 = J.gp(J.G.get("PADDY_POS"), J.gp(v_a_269, "i"))
				var _t380 = J.gp(_t379, 0.0)
				v_px_275 = _t380
				var _t381 = J.gp(_t379, 1.0)
				v_py_276 = _t381
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
					var _t382 = J.gp(J.G.get("S"), "res")
					var _t383 = J.sub(J.gp(_t382, v_src_278), 4.0)
					J.sp(_t382, v_src_278, _t383)
					var _t384 = J.gp(J.G.get("S"), "res")
					var _t385 = J.add(J.gp(_t384, v_out_279), 2.0)
					J.sp(_t384, v_out_279, _t385)
					var _t386 = J.gp(J.G.get("S"), "cnt")
					var _t387 = ("craftPlank" if J.t(v_plank_277) else "craftBun")
					J.sp(_t386, _t387, J.num(J.gp(_t386, _t387)) + 1.0)
					var _t388 = J.G.get("gainExp")
					J.cl(_t388, null, [1.0])
					J.mc(J.G.get("Sound"), "play", ["craft"])
					J.sp(v_a_269, "done", J.num(J.gp(v_a_269, "done")) + 1.0)
					J.sp(v_a_269, "n", J.num(J.gp(v_a_269, "n")) + -1.0)
					J.mc(J.G.get("Quest"), "check", [])
					var _t389 = J.cmp(J.gp(v_a_269, "n"), 0.0, ">")
					v_more_280 = (J.cmp(J.gp(J.gp(J.G.get("S"), "res"), v_src_278), 4.0, ">=") if _t389 else _t389)
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
	var _t390 = (not J.t(v_a_284))
	if J.t((_t390 if _t390 else J.gp(v_H_283, "walking"))):
		return [null, 0.0]
	if J.seq(J.gp(v_a_284, "kind"), "tree"):
		return ["chop", J.min_([1.0, J.div(J.gp(v_H_283, "actT"), J.mc(J.G.get("F"), "chopTime", []))])]
	if J.seq(J.gp(v_a_284, "kind"), "paddy"):
		return ["reap", J.min_([1.0, J.div(J.gp(v_H_283, "actT"), J.mul(J.mc(J.G.get("F"), "chopTime", []), 1.4))])]
	if J.seq(J.gp(v_a_284, "kind"), "craft"):
		var _t395 = ("hammer" if J.seq(J.gp(v_a_284, "bid"), "plank") else "knead")
		var _t392 = J.gp(v_H_283, "actT")
		var _t391 = J.gp(v_a_284, "dur")
		var _t394 = J.gp(v_H_283, "actT")
		var _t393 = J.gp(v_a_284, "dur")
		return [_t395, J.min_([1.0, J.div(_t394, (_t393 if J.t(_t393) else 0.9))])]
	return [null, 0.0]

func _f74(this_, a: Array, env):
	var v_x_287 = null; var v_y_288 = null; var v_kind_289 = null; var v_power_290 = null; var v_P_291 = null; var v_n_292 = null; var v_i_293 = null
	v_x_287 = J.arg(a, 0)
	v_y_288 = J.arg(a, 1)
	v_kind_289 = J.arg(a, 2)
	v_power_290 = J.arg(a, 3)
	var _t396 = this_
	var _t397 = J.gp(this_, "parts")
	var _t398 = (_t397 if J.t(_t397) else [])
	J.sp(_t396, "parts", _t398)
	v_P_291 = _t398
	var _t399 = (v_power_290 if J.t(v_power_290) else 1.0)
	v_power_290 = _t399
	var _t400 = this_
	var _t401 = J.gp(this_, "hitstop")
	var _t402 = J.gp(this_, "hitstop")
	var _t403 = J.max_([(_t402 if J.t(_t402) else 0.0), J.mul(0.05, v_power_290)])
	J.sp(_t400, "hitstop", _t403)
	var _t404 = this_
	var _t405 = J.gp(this_, "shk")
	var _t406 = J.gp(this_, "shk")
	var _t407 = J.max_([(_t406 if J.t(_t406) else 0.0), J.mul(2.5, v_power_290)])
	J.sp(_t404, "shk", _t407)
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
	var _t410 = J.add(J.gp(v_p_301, "t"), env["dt"])
	J.sp(v_p_301, "t", _t410)
	var _t411 = J.gp(v_p_301, "vx")
	var _t412 = J.add(J.gp(v_p_301, "x"), J.mul((_t411 if J.t(_t411) else 0.0), env["dt"]))
	J.sp(v_p_301, "x", _t412)
	var _t413 = J.gp(v_p_301, "vy")
	var _t414 = J.add(J.gp(v_p_301, "y"), J.mul((_t413 if J.t(_t413) else 0.0), env["dt"]))
	J.sp(v_p_301, "y", _t414)
	var _t415 = J.gp(v_p_301, "vy")
	var _t417 = (_t415 if J.t(_t415) else 0.0)
	var _t416 = J.gp(v_p_301, "g")
	var _t418 = J.add(_t417, J.mul((_t416 if J.t(_t416) else 0.0), env["dt"]))
	J.sp(v_p_301, "vy", _t418)
	var _t419 = J.gp(v_p_301, "vr")
	var _t420 = J.add(J.gp(v_p_301, "r"), J.mul((_t419 if J.t(_t419) else 0.0), env["dt"]))
	J.sp(v_p_301, "r", _t420)
	return J.cmp(J.gp(v_p_301, "t"), J.gp(v_p_301, "life"), "<")

func _f75(this_, a: Array, env):
	var v_frozen_297 = null; var v_P_298 = null; var v_H_299 = null; var v_a_300 = null; var v_p_302 = null; var v_hits_303 = null; var v_prev_304 = null; var v_h_305 = null; var v_p_306 = null; var v_prev_307 = null; var v_h_308 = null; var v_px_309 = null; var v_py_310 = null
	var _s146 = {"__p": env, "dt": null}
	_s146["dt"] = J.arg(a, 0)
	v_frozen_297 = J.arg(a, 1)
	var _t408 = J.gp(this_, "parts")
	v_P_298 = (_t408 if J.t(_t408) else [])
	var _t409 = this_
	var _t421 = J.mc(v_P_298, "filter", [Callable(self, "_f76").bind(_s146)])
	J.sp(_t409, "parts", _t421)
	if J.cmp(J.gp(this_, "shk"), 0.0, ">"):
		var _t422 = this_
		var _t423 = J.max_([0.0, J.sub(J.gp(this_, "shk"), J.mul(_s146["dt"], 18.0))])
		J.sp(_t422, "shk", _t423)
	if J.cmp(J.gp(this_, "proudT"), 0.0, ">"):
		var _t424 = this_
		var _t425 = J.sub(J.gp(_t424, "proudT"), _s146["dt"])
		J.sp(_t424, "proudT", _t425)
	if J.t(v_frozen_297):
		return null
	v_H_299 = J.gp(this_, "hero")
	v_a_300 = J.gp(v_H_299, "act")
	var _t426 = (J.seq(J.gp(v_a_300, "kind"), "craft") if J.t(v_a_300) else v_a_300)
	if J.t(((not J.t(J.gp(v_H_299, "walking"))) if J.t(_t426) else _t426)):
		var _t428 = J.gp(v_H_299, "actT")
		var _t427 = J.gp(v_a_300, "dur")
		var _t430 = J.gp(v_H_299, "actT")
		var _t429 = J.gp(v_a_300, "dur")
		v_p_302 = J.min_([1.0, J.div(_t430, (_t429 if J.t(_t429) else 0.9))])
		v_hits_303 = ([0.5, 0.999] if J.seq(J.gp(v_a_300, "bid"), "plank") else [0.125, 0.375, 0.625, 0.875])
		v_prev_304 = (v_p_302 if J.leq(J.gp(this_, "_pp"), null) else J.gp(this_, "_pp"))
		for _t431 in J.iter(v_hits_303):
			v_h_305 = _t431
			var _t432 = J.cmp(v_prev_304, v_h_305, "<")
			if (J.cmp(v_p_302, v_h_305, ">=") if _t432 else _t432):
				J.mc(this_, "impact", [J.add(J.gp(v_H_299, "x"), ((-16.0) if J.cmp(J.gp(v_H_299, "dir"), 0.0, "<") else 16.0)), J.sub(J.gp(v_H_299, "y"), 4.0), ("wood" if J.seq(J.gp(v_a_300, "bid"), "plank") else "dough"), (0.8 if J.seq(J.gp(v_a_300, "bid"), "plank") else 0.4)])
		var _t433 = this_
		var _t434 = (0.0 if J.cmp(v_p_302, 0.999, ">=") else v_p_302)
		J.sp(_t433, "_pp", _t434)
	else:
		var _t435 = (J.seq(J.gp(v_a_300, "kind"), "paddy") if J.t(v_a_300) else v_a_300)
		if J.t(((not J.t(J.gp(v_H_299, "walking"))) if J.t(_t435) else _t435)):
			v_p_306 = J.min_([1.0, J.div(J.gp(v_H_299, "actT"), J.mul(J.mc(J.G.get("F"), "chopTime", []), 1.4))])
			v_prev_307 = (v_p_306 if J.leq(J.gp(this_, "_pp"), null) else J.gp(this_, "_pp"))
			for _t436 in J.iter([J.div(1.0, 12.0), J.div(5.0, 12.0), J.div(9.0, 12.0)]):
				v_h_308 = _t436
				var _t437 = J.cmp(v_prev_307, v_h_308, "<")
				if (J.cmp(v_p_306, v_h_308, ">=") if _t437 else _t437):
					var _t438 = J.gp(J.G.get("PADDY_POS"), J.gp(v_a_300, "i"))
					var _t439 = J.gp(_t438, 0.0)
					v_px_309 = _t439
					var _t440 = J.gp(_t438, 1.0)
					v_py_310 = _t440
					J.mc(this_, "impact", [(J.sub(v_px_309, 6.0) + (randf() * 12.0)), J.sub(v_py_310, 8.0), "rice", 0.5])
			var _t441 = this_
			J.sp(_t441, "_pp", v_p_306)
		else:
			var _t442 = this_
			J.sp(_t442, "_pp", null)

func _f77(this_, a: Array, env):
	var v_ctx_313 = null; var v_p_314 = null; var v_f_315 = null; var v_im_316 = null; var v_I_317 = null; var v_sc_318 = null
	v_ctx_313 = J.arg(a, 0)
	var _t444 = J.gp(this_, "parts")
	for _t443 in J.iter((_t444 if J.t(_t444) else [])):
		v_p_314 = _t443
		v_f_315 = J.div(J.gp(v_p_314, "t"), J.gp(v_p_314, "life"))
		J.mc(v_ctx_313, "save", [])
		var _t445 = J.max_([0.0, (1.0 - J.mul(v_f_315, v_f_315))])
		J.sp(v_ctx_313, "globalAlpha", _t445)
		J.mc(v_ctx_313, "translate", [J.gp(v_p_314, "x"), J.gp(v_p_314, "y")])
		J.mc(v_ctx_313, "rotate", [J.gp(v_p_314, "r")])
		v_im_316 = J.gp({"spark": "fx_spark", "chip": "fx_chips", "dust": "fx_dust", "dough": "fx_dough", "grain": "fx_dough"}, J.gp(v_p_314, "k"))
		if J.seq(J.gp(v_p_314, "k"), "grain"):
			J.sp(v_ctx_313, "fillStyle", "#e9cf7a")
			J.mc(v_ctx_313, "fillRect", [(-1.5), (-3.0), 3.0, 6.0])
		else:
			var _t447 = (J.seq(J.typeof_(J.G.get("sprOk")), "function") if J.t(v_im_316) else v_im_316)
			if J.t(_t447):
				var _t446 = J.G.get("sprOk")
				_t447 = J.cl(_t446, null, [v_im_316])
			if J.t(_t447):
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
	var _t456 = J.gp(J.arg(a, 0), 0.0)
	_s168["k"] = _t456
	var _t457 = J.gp(J.arg(a, 0), 1.0)
	_s168["x"] = _t457
	var _t458 = J.gp(J.arg(a, 0), 2.0)
	_s168["y"] = _t458
	return J.mc(_s168["__p"]["items"], "push", [{"y": _s168["y"], "f": Callable(self, "_f83").bind(_s168)}])

func _f85(this_, a: Array, env):
	var _t467 = env["__p"]["ctx"]
	var _t468 = env["x"]
	var _t469 = env["y"]
	var _t470 = J.gp(J.gp(J.G.get("S"), "trees"), env["i"])
	var _t471 = env["__p"]["t"]
	var _t461 = J.gp(J.gp(env["__p"]["this"], "hero"), "act")
	var _t462 = (J.seq(J.gp(J.gp(J.gp(env["__p"]["this"], "hero"), "act"), "kind"), "tree") if J.t(_t461) else _t461)
	var _t463 = (J.seq(J.gp(J.gp(J.gp(env["__p"]["this"], "hero"), "act"), "i"), env["i"]) if J.t(_t462) else _t462)
	var _t466 = (J.cmp(J.gp(J.gp(J.gp(env["__p"]["this"], "hero"), "act"), "shake"), 0.0, ">") if J.t(_t463) else _t463)
	if J.t(_t466):
		var _t464 = J.gp(J.gp(env["__p"]["this"], "hero"), "act")
		var _t465 = J.sub(J.gp(_t464, "shake"), J.div(1.0, 60.0))
		J.sp(_t464, "shake", _t465)
		_t466 = (_t465 > 0.0)
	return J.mc(J.G.get("ART"), "drawTree", [_t467, _t468, _t469, _t470, _t471, _t466, J.seq(J.gp(J.gp(J.G.get("S"), "trees"), env["i"]), 3.0), env["i"]])

func _f84(this_, a: Array, env):
	var _s170 = {"__p": env, "x": null, "y": null, "i": null}
	var _t459 = J.gp(J.arg(a, 0), 0.0)
	_s170["x"] = _t459
	var _t460 = J.gp(J.arg(a, 0), 1.0)
	_s170["y"] = _t460
	_s170["i"] = J.arg(a, 1)
	return J.mc(_s170["__p"]["items"], "push", [{"y": _s170["y"], "f": Callable(self, "_f85").bind(_s170)}])

func _f87(this_, a: Array, env):
	return J.mc(J.G.get("ART"), "drawPaddy", [env["__p"]["ctx"], env["x"], env["y"], J.gp(J.gp(J.G.get("S"), "paddy"), env["i"]), env["__p"]["t"], env["i"]])

func _f86(this_, a: Array, env):
	var _s172 = {"__p": env, "x": null, "y": null, "i": null}
	var _t472 = J.gp(J.arg(a, 0), 0.0)
	_s172["x"] = _t472
	var _t473 = J.gp(J.arg(a, 0), 1.0)
	_s172["y"] = _t473
	_s172["i"] = J.arg(a, 1)
	return J.mc(_s172["__p"]["items"], "push", [{"y": J.sub(_s172["y"], 10.0), "f": Callable(self, "_f87").bind(_s172)}])

func _f88(this_, a: Array, env):
	return (J.mc(J.G.get("WORK"), "drawWorker", [env["__p"]["ctx"], env["s"], env["__p"]["t"], 0.62, env["__p"]["workInfo"]]) if (not J.seq(J.typeof_(J.G.get("WORK")), "undefined")) else J.mc(J.G.get("ART"), "drawChar", [env["__p"]["ctx"], J.gp(J.gp(env["s"], "g"), "k"), J.gp(env["s"], "x"), J.gp(env["s"], "y"), 0.62, {"t": J.add(env["__p"]["t"], J.gp(env["s"], "ph")), "work": true, "flip": J.gp(env["s"], "flip"), "tamed": true, "untied": true}]))

func _f89(this_, a: Array, env):
	var v_g_356 = null
	v_g_356 = J.arg(a, 0)
	var _t479 = (not J.t(J.gp(v_g_356, "post")))
	return ((not J.seq(J.gp(v_g_356, "k"), "afu")) if _t479 else _t479)

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
	var _t448 = J.gp(_s158["this"], "shk")
	v_sk_323 = (_t448 if J.t(_t448) else 0.0)
	v_kx_324 = J.mul((randf() - 0.5), v_sk_323)
	v_ky_325 = J.mul((randf() - 0.5), v_sk_323)
	J.mc(_s158["ctx"], "setTransform", [J.mul(J.gp(_s158["this"], "dpr"), J.gp(_s158["this"], "scale")), 0.0, 0.0, J.mul(J.gp(_s158["this"], "dpr"), J.gp(_s158["this"], "scale")), J.mul(J.mul(v_kx_324, J.gp(_s158["this"], "dpr")), J.gp(_s158["this"], "scale")), J.mul(J.mul(J.sub(v_ky_325, J.gp(_s158["this"], "camY")), J.gp(_s158["this"], "dpr")), J.gp(_s158["this"], "scale"))])
	J.mc(_s158["ctx"], "drawImage", [J.cl(J.G.get("groundLayer"), null, []), 0.0, 0.0, J.G.get("W"), J.G.get("WH")])
	v_i_334 = 0.0
	while true:
		if not J.cmp(v_i_334, 9.0, "<"): break
		v_fx_335 = J.mod((J.mul(v_i_334, 47.0) + 20.0), J.G.get("W"))
		v_fy_336 = (24.0 + J.mod(J.mul(v_i_334, 31.0), 112.0))
		var _t449 = J.G.get("drawLily")
		J.cl(_t449, null, [_s158["ctx"], v_fx_335, v_fy_336, J.add(_s158["t"], v_i_334)])
		v_i_334 = J.num(v_i_334) + 1.0
	v_i_337 = 0.0
	while true:
		if not J.cmp(v_i_337, 6.0, "<"): break
		v_mx_338 = (J.mod((J.mul(_s158["t"], 8.0) + J.mul(v_i_337, 90.0)), J.add(J.G.get("W"), 200.0)) - 100.0)
		v_my_339 = (160.0 + J.mul(v_i_337, 170.0))
		v_mg_340 = J.mc(_s158["ctx"], "createRadialGradient", [v_mx_338, v_my_339, 5.0, v_mx_338, v_my_339, 90.0])
		J.mc(v_mg_340, "addColorStop", [0.0, "rgba(200,210,200,.06)"])
		J.mc(v_mg_340, "addColorStop", [1.0, "rgba(200,210,200,0)"])
		var _t450 = _s158["ctx"]
		J.sp(_t450, "fillStyle", v_mg_340)
		J.mc(_s158["ctx"], "fillRect", [J.sub(v_mx_338, 90.0), J.sub(v_my_339, 90.0), 180.0, 180.0])
		v_i_337 = J.num(v_i_337) + 1.0
	_s158["items"] = []
	J.mc(_s158["items"], "push", [{"y": J.gp(J.gp(J.G.get("POS"), "gate"), 1.0), "f": Callable(self, "_f79").bind(_s158)}])
	for _t451 in J.iter(J.G.get("BLD_ORDER")):
		var _s164 = {"__p": _s158, "id": null}
		_s164["id"] = _t451
		var _s165 = {"__p": _s164, "x": null, "y": null, "lv": null}
		var _t452 = J.gp(J.G.get("POS"), _s165["__p"]["id"])
		var _t453 = J.gp(_t452, 0.0)
		_s165["x"] = _t453
		var _t454 = J.gp(_t452, 1.0)
		_s165["y"] = _t454
		_s165["lv"] = J.gp(J.gp(J.G.get("S"), "bld"), _s165["__p"]["id"])
		if J.t(_s165["lv"]):
			J.mc(_s165["__p"]["__p"]["items"], "push", [{"y": _s165["y"], "f": Callable(self, "_f80").bind(_s165)}])
		else:
			var _t455 = J.G.get("bldUnlocked")
			if J.t(J.cl(_t455, null, [_s165["__p"]["id"]])):
				J.mc(_s165["__p"]["__p"]["items"], "push", [{"y": _s165["y"], "f": Callable(self, "_f81").bind(_s165)}])
	J.mc(J.G.get("DECOR"), "forEach", [Callable(self, "_f82").bind(_s158)])
	J.mc(J.G.get("TREE_POS"), "forEach", [Callable(self, "_f84").bind(_s158)])
	J.mc(J.G.get("PADDY_POS"), "forEach", [Callable(self, "_f86").bind(_s158)])
	v_spots_327 = J.mc(_s158["this"], "workerSpots", [])
	var _t474 = _s158["this"]
	var _t475 = []
	J.sp(_t474, "vis", _t475)
	_s158["vis"] = _t475
	for _t476 in J.iter(v_spots_327):
		v_s_354 = _t476
		J.mc(_s158["vis"], "push", [{"g": J.gp(v_s_354, "g"), "x": J.gp(v_s_354, "x"), "y": J.gp(v_s_354, "y")}])
	_s158["workInfo"] = {"furnace": ([J.gp(J.gp(J.G.get("POS"), "furnace"), 0.0), J.sub(J.gp(J.gp(J.G.get("POS"), "furnace"), 1.0), 22.0)] if J.t(J.gp(J.gp(J.G.get("S"), "bld"), "furnace")) else null)}
	for _t477 in J.iter(v_spots_327):
		var _s175 = {"__p": _s158, "s": null}
		_s175["s"] = _t477
		J.mc(_s175["__p"]["items"], "push", [{"y": J.gp(_s175["s"], "y"), "f": Callable(self, "_f88").bind(_s175)}])
	var _t478 = J.gp(J.G.get("S"), "ghosts")
	v_idle_330 = J.mc(_t478, "filter", [Callable(self, "_f89").bind(_s158)])
	if (not J.seq(J.typeof_(J.G.get("PlazaLife")), "undefined")):
		J.mc(J.G.get("PlazaLife"), "frame", [_s158["this"], v_idle_330, _s158["items"], _s158["vis"], _s158["ctx"], _s158["t"]])
	else:
		J.mc(v_idle_330, "forEach", [Callable(self, "_f90").bind(_s158)])
	_s158["H"] = J.gp(_s158["this"], "hero")
	J.mc(_s158["vis"], "push", [{"g": J.gp(J.gp(J.G.get("S"), "ghosts"), 0.0), "x": J.gp(_s158["H"], "x"), "y": J.gp(_s158["H"], "y"), "hero": true}])
	_s158["hp"] = J.mc(_s158["this"], "heroPose", [])
	_s158["hd"] = (J.mc(J.G.get("HeroDaily"), "opts", [_s158["this"]]) if (not J.seq(J.typeof_(J.G.get("HeroDaily")), "undefined")) else null)
	J.mc(_s158["items"], "push", [{"y": J.gp(_s158["H"], "y"), "f": Callable(self, "_f92").bind(_s158)}])
	var _t480 = J.mc(_s158["items"], "sort", [Callable(self, "_f93").bind(_s158)])
	J.mc(_t480, "forEach", [Callable(self, "_f94").bind(_s158)])
	for _t481 in J.iter(J.gp(_s158["this"], "feathers")):
		v_f_365 = _t481
		J.mc(_s158["ctx"], "save", [])
		var _t482 = _s158["ctx"]
		var _t483 = J.max_([0.0, (1.0 - J.div(J.gp(v_f_365, "t"), J.gp(v_f_365, "life")))])
		J.sp(_t482, "globalAlpha", _t483)
		J.mc(_s158["ctx"], "translate", [J.gp(v_f_365, "x"), J.gp(v_f_365, "y")])
		J.mc(_s158["ctx"], "rotate", [(sin(J.num(J.gp(v_f_365, "rot"))) * 0.8)])
		J.mc(J.G.get("ART"), "el", [_s158["ctx"], 0.0, 0.0, 1.4, 4.0, "#14111a", "#5a5068", 0.5])
		J.mc(_s158["ctx"], "restore", [])
	J.mc(_s158["this"], "drawParts", [_s158["ctx"]])
	for _t484 in J.iter(J.gp(_s158["this"], "crows")):
		v_c_366 = _t484
		var _t485 = _s158["ctx"]
		var _t486 = J.min_([1.0, J.div(J.sub(J.gp(v_c_366, "life"), J.gp(v_c_366, "t")), 0.6)])
		J.sp(_t485, "globalAlpha", _t486)
		J.mc(J.G.get("ART"), "drawCrow", [_s158["ctx"], J.gp(v_c_366, "x"), J.gp(v_c_366, "y"), J.gp(v_c_366, "s"), J.gp(v_c_366, "ph"), J.gp(v_c_366, "vx"), false])
		var _t487 = _s158["ctx"]
		J.sp(_t487, "globalAlpha", 1.0)
	if J.t(J.gp(_s158["this"], "bubble")):
		J.mc(_s158["this"], "drawBubble", [_s158["ctx"]])
	J.mc(_s158["this"], "drawPointer", [_s158["ctx"], _s158["t"]])
	for _t488 in J.iter(J.gp(_s158["this"], "floats")):
		v_f_367 = _t488
		var _t489 = _s158["ctx"]
		var _t490 = J.max_([0.0, (1.0 - J.div(J.gp(v_f_367, "t"), J.gp(v_f_367, "life")))])
		J.sp(_t489, "globalAlpha", _t490)
		var _t491 = _s158["ctx"]
		var _t492 = "bold 14px \"PingFang TC\",\"Noto Sans TC\",sans-serif"
		J.sp(_t491, "font", _t492)
		var _t493 = _s158["ctx"]
		J.sp(_t493, "textAlign", "center")
		var _t494 = _s158["ctx"]
		J.sp(_t494, "lineWidth", 3.5)
		var _t495 = _s158["ctx"]
		J.sp(_t495, "strokeStyle", "rgba(10,6,20,.9)")
		J.mc(_s158["ctx"], "strokeText", [J.gp(v_f_367, "text"), J.gp(v_f_367, "x"), J.sub(J.gp(v_f_367, "y"), J.mul(J.gp(v_f_367, "t"), 26.0))])
		var _t496 = _s158["ctx"]
		var _t497 = J.gp(v_f_367, "col")
		J.sp(_t496, "fillStyle", _t497)
		J.mc(_s158["ctx"], "fillText", [J.gp(v_f_367, "text"), J.gp(v_f_367, "x"), J.sub(J.gp(v_f_367, "y"), J.mul(J.gp(v_f_367, "t"), 26.0))])
		var _t498 = _s158["ctx"]
		J.sp(_t498, "globalAlpha", 1.0)

func _f96(this_, a: Array, env):
	return (J.mc(J.G.get("WORK"), "drawWorker", [env["__p"]["ctx"], env["s"], env["__p"]["t"], 0.62, env["__p"]["workInfo"]]) if (not J.seq(J.typeof_(J.G.get("WORK")), "undefined")) else J.mc(J.G.get("ART"), "drawChar", [env["__p"]["ctx"], J.gp(J.gp(env["s"], "g"), "k"), J.gp(env["s"], "x"), J.gp(env["s"], "y"), 0.62, {"t": J.add(env["__p"]["t"], J.gp(env["s"], "ph")), "work": true, "flip": J.gp(env["s"], "flip"), "tamed": true, "untied": true}]))

func _f97(this_, a: Array, env):
	var v_g_383 = null
	v_g_383 = J.arg(a, 0)
	var _t504 = (not J.t(J.gp(v_g_383, "post")))
	return ((not J.seq(J.gp(v_g_383, "k"), "afu")) if _t504 else _t504)

func _f98(this_, a: Array, env):
	return J.mc(J.G.get("ART"), "drawChar", [env["ctx"], "afu", J.gp(env["H"], "x"), J.gp(env["H"], "y"), 0.72, J.S_Object_("assign", [{"t": env["t"], "walk": J.gp(env["H"], "walking"), "work": (not (not J.t(J.gp(env["H"], "act")))), "flip": J.cmp(J.gp(env["H"], "dir"), 0.0, "<"), "mood": ("happy" if J.t(J.gp(J.G.get("S"), "ended")) else null), "pose": J.gp(env["hp"], 0.0), "pt": J.gp(env["hp"], 1.0)}, (env["hd"] if J.t(env["hd"]) else {})])])

func _f95(this_, a: Array, env):
	var v_items_372 = null; var v_spots_373 = null; var v_vis_374 = null; var v_idle_376 = null; var v_n0_377 = null; var v_s_381 = null; var v_i_384 = null
	var _s189 = {"__p": env, "ctx": null, "t": null, "workInfo": null, "H": null, "hp": null, "hd": null}
	_s189["ctx"] = J.arg(a, 0)
	_s189["t"] = J.gp(this_, "t")
	v_items_372 = []
	v_spots_373 = J.mc(this_, "workerSpots", [])
	var _t499 = this_
	var _t500 = []
	J.sp(_t499, "vis", _t500)
	v_vis_374 = _t500
	for _t501 in J.iter(v_spots_373):
		v_s_381 = _t501
		J.mc(v_vis_374, "push", [{"g": J.gp(v_s_381, "g"), "x": J.gp(v_s_381, "x"), "y": J.gp(v_s_381, "y")}])
	_s189["workInfo"] = {"furnace": ([J.gp(J.gp(J.G.get("POS"), "furnace"), 0.0), J.sub(J.gp(J.gp(J.G.get("POS"), "furnace"), 1.0), 22.0)] if J.t(J.gp(J.gp(J.G.get("S"), "bld"), "furnace")) else null)}
	for _t502 in J.iter(v_spots_373):
		var _s191 = {"__p": _s189, "s": null}
		_s191["s"] = _t502
		J.mc(v_items_372, "push", [{"y": J.gp(_s191["s"], "y"), "kind": "work", "s": _s191["s"], "f": Callable(self, "_f96").bind(_s191)}])
	var _t503 = J.gp(J.G.get("S"), "ghosts")
	v_idle_376 = J.mc(_t503, "filter", [Callable(self, "_f97").bind(_s189)])
	v_n0_377 = J.len(v_items_372)
	if (not J.seq(J.typeof_(J.G.get("PlazaLife")), "undefined")):
		J.mc(J.G.get("PlazaLife"), "frame", [this_, v_idle_376, v_items_372, v_vis_374, _s189["ctx"], _s189["t"]])
	v_i_384 = v_n0_377
	while true:
		if not J.cmp(v_i_384, J.len(v_items_372), "<"): break
		var _t505 = J.gp(v_items_372, v_i_384)
		var _t506 = J.gp(J.gp(v_items_372, v_i_384), "kind")
		var _t507 = (_t506 if J.t(_t506) else "plaza")
		J.sp(_t505, "kind", _t507)
		v_i_384 = J.num(v_i_384) + 1.0
	_s189["H"] = J.gp(this_, "hero")
	J.mc(v_vis_374, "push", [{"g": J.gp(J.gp(J.G.get("S"), "ghosts"), 0.0), "x": J.gp(_s189["H"], "x"), "y": J.gp(_s189["H"], "y"), "hero": true}])
	_s189["hp"] = J.mc(this_, "heroPose", [])
	_s189["hd"] = (J.mc(J.G.get("HeroDaily"), "opts", [this_]) if (not J.seq(J.typeof_(J.G.get("HeroDaily")), "undefined")) else null)
	J.mc(v_items_372, "push", [{"y": J.gp(_s189["H"], "y"), "kind": "hero", "f": Callable(self, "_f98").bind(_s189)}])
	return v_items_372

func _f99(this_, a: Array, env):
	var v_i_387 = null; var v_tx_388 = null; var v_ty_389 = null; var v_n_390 = null; var v_k_391 = null; var v_dir_392 = null; var v_sx_393 = null; var v_sy_394 = null
	v_i_387 = J.arg(a, 0)
	var _t508 = J.gp(J.G.get("TREE_POS"), v_i_387)
	var _t509 = J.gp(_t508, 0.0)
	v_tx_388 = _t509
	var _t510 = J.gp(_t508, 1.0)
	v_ty_389 = _t510
	v_n_390 = (3.0 + floor(J.num((randf() * 3.0))))
	v_k_391 = 0.0
	while true:
		if not J.cmp(v_k_391, v_n_390, "<"): break
		v_dir_392 = (1.0 if J.t(J.mod(v_k_391, 2.0)) else (-1.0))
		v_sx_393 = J.add(v_tx_388, ((randf() - 0.5) * 40.0))
		v_sy_394 = (J.sub(v_ty_389, 48.0) - (randf() * 18.0))
		var _t511 = J.gp(this_, "crows")
		J.mc(_t511, "push", [{"x": v_sx_393, "y": v_sy_394, "vx": J.mul(v_dir_392, (50.0 + (randf() * 90.0))), "vy": (-(50.0 + (randf() * 60.0))), "t": 0.0, "life": (2.0 + (randf() * 0.8)), "ph": (randf() * 6.0), "s": (1.1 + (randf() * 0.4))}])
		var _t512 = J.gp(this_, "feathers")
		J.mc(_t512, "push", [{"x": v_sx_393, "y": v_sy_394, "t": 0.0, "life": 2.4, "vx": ((randf() - 0.5) * 20.0), "rot": (randf() * 6.0)}])
		v_k_391 = J.num(v_k_391) + 1.0
	J.mc(J.G.get("Sound"), "play", ["crow", J.div(J.sub(v_tx_388, 195.0), 195.0)])

func _f101(this_, a: Array, env):
	var v_v_405 = null
	v_v_405 = J.arg(a, 0)
	var _t514 = J.cmp(J.gp(v_v_405, "y"), J.add(env["top"], 120.0), ">")
	var _t515 = (J.cmp(J.gp(v_v_405, "y"), env["bot"], "<") if _t514 else _t514)
	var _t517 = (J.gp(J.G.get("CHATTER"), J.gp(J.gp(v_v_405, "g"), "k")) if _t515 else _t515)
	if J.t(_t517):
		var _t516 = (not J.t(J.gp(v_v_405, "hero")))
		_t517 = (_t516 if _t516 else J.cmp(J.gp(J.G.get("S"), "qi"), 3.0, ">"))
	return _t517

func _f102(this_, a: Array, env):
	var v_l_406 = null
	v_l_406 = J.arg(a, 0)
	return (not J.t(J.mc(env["used"], "includes", [v_l_406])))

func _f100(this_, a: Array, env):
	var v_cand_399 = null; var v_v_400 = null; var v_k_401 = null; var v_pool_403 = null; var v_line_404 = null
	var _s199 = {"__p": env, "top": null, "bot": null, "used": null}
	_s199["top"] = J.add(J.gp(this_, "camY"), 60.0)
	_s199["bot"] = J.sub(J.add(J.gp(this_, "camY"), J.div(J.gp(this_, "h"), J.gp(this_, "scale"))), 20.0)
	var _t513 = J.gp(this_, "vis")
	v_cand_399 = J.mc(_t513, "filter", [Callable(self, "_f101").bind(_s199)])
	var _t518 = (not J.t(J.len(v_cand_399)))
	var _t519 = (_t518 if _t518 else J.mc(J.G.get("Story"), "busy", []))
	if J.t((_t519 if J.t(_t519) else J.mc(J.G.get("UI"), "modalOpen", []))):
		return null
	v_v_400 = J.gp(v_cand_399, floor(J.num((randf() * J.len(v_cand_399)))))
	v_k_401 = J.gp(J.gp(v_v_400, "g"), "k")
	var _t520 = J.gp(this_, "chatUsed")
	var _t521 = J.gp(J.gp(this_, "chatUsed"), v_k_401)
	var _t522 = (_t521 if J.t(_t521) else [])
	J.sp(_t520, v_k_401, _t522)
	_s199["used"] = _t522
	var _t523 = J.gp(J.G.get("CHATTER"), v_k_401)
	v_pool_403 = J.mc(_t523, "filter", [Callable(self, "_f102").bind(_s199)])
	if (not J.t(J.len(v_pool_403))):
		var _t524 = _s199["used"]
		J.sp(_t524, "length", 0.0)
		v_pool_403 = J.gp(J.G.get("CHATTER"), v_k_401)
	v_line_404 = J.gp(v_pool_403, floor(J.num((randf() * J.len(v_pool_403)))))
	J.mc(_s199["used"], "push", [v_line_404])
	var _t525 = this_
	var _t526 = {"id": J.gp(J.gp(v_v_400, "g"), "id"), "hero": (not (not J.t(J.gp(v_v_400, "hero")))), "text": v_line_404, "t": 0.0}
	J.sp(_t525, "bubble", _t526)

func _f104(this_, a: Array, env):
	var v_o_421 = null
	v_o_421 = J.arg(a, 0)
	var _t529 = null
	if J.t(J.gp(env["b"], "hero")):
		_t529 = J.gp(v_o_421, "hero")
	else:
		var _t528 = J.seq(J.gp(J.gp(v_o_421, "g"), "id"), J.gp(env["b"], "id"))
		_t529 = ((not J.t(J.gp(v_o_421, "hero"))) if _t528 else _t528)
	return _t529

func _f105(this_, a: Array, env):
	var v_l_423 = null
	v_l_423 = J.arg(a, 0)
	return J.gp(J.mc(env["ctx"], "measureText", [v_l_423]), "width")

func _f106(this_, a: Array, env):
	var v_l_424 = null; var v_i_425 = null
	v_l_424 = J.arg(a, 0)
	v_i_425 = J.arg(a, 1)
	return J.mc(env["ctx"], "fillText", [v_l_424, J.add(env["bx"], 8.0), J.add(J.add(env["by"], 6.0), J.mul(v_i_425, 17.0))])

func _f103(this_, a: Array, env):
	var v_v_411 = null; var v_a_412 = null; var v_maxW_413 = null; var v_chars_414 = null; var v_lines_415 = null; var v_cur_416 = null; var v_w_417 = null; var v_h_418 = null; var v_ch_422 = null
	var _s203 = {"__p": env, "ctx": null, "b": null, "bx": null, "by": null}
	_s203["ctx"] = J.arg(a, 0)
	_s203["b"] = J.gp(this_, "bubble")
	var _t527 = J.gp(this_, "vis")
	v_v_411 = J.mc(_t527, "find", [Callable(self, "_f104").bind(_s203)])
	if (not J.t(v_v_411)):
		var _t530 = this_
		J.sp(_t530, "bubble", null)
		return null
	v_a_412 = J.min_([1.0, J.mul(J.gp(_s203["b"], "t"), 5.0), (J.sub(4.6, J.gp(_s203["b"], "t")) * 3.0)])
	J.mc(_s203["ctx"], "save", [])
	var _t531 = _s203["ctx"]
	var _t532 = J.max_([0.0, v_a_412])
	J.sp(_t531, "globalAlpha", _t532)
	var _t533 = _s203["ctx"]
	var _t534 = "600 12.5px \"PingFang TC\",\"Noto Sans TC\",sans-serif"
	J.sp(_t533, "font", _t534)
	v_maxW_413 = 168.0
	v_chars_414 = J.spread([J.SP(J.gp(_s203["b"], "text"))])
	v_lines_415 = []
	v_cur_416 = ""
	for _t535 in J.iter(v_chars_414):
		v_ch_422 = _t535
		if J.cmp(J.gp(J.mc(_s203["ctx"], "measureText", [J.add(v_cur_416, v_ch_422)]), "width"), v_maxW_413, ">"):
			J.mc(v_lines_415, "push", [v_cur_416])
			v_cur_416 = v_ch_422
		else:
			var _t536 = J.add(v_cur_416, v_ch_422)
			v_cur_416 = _t536
	if J.t(v_cur_416):
		J.mc(v_lines_415, "push", [v_cur_416])
	v_w_417 = (J.max_(J.spread([J.SP(J.mc(v_lines_415, "map", [Callable(self, "_f105").bind(_s203)]))])) + 16.0)
	v_h_418 = ((J.len(v_lines_415) * 17.0) + 10.0)
	_s203["bx"] = J.max_([6.0, J.min_([(J.sub(J.G.get("W"), v_w_417) - 6.0), J.sub(J.gp(v_v_411, "x"), J.div(v_w_417, 2.0))])])
	_s203["by"] = J.sub(J.sub(J.gp(v_v_411, "y"), 62.0), v_h_418)
	J.mc(J.G.get("ART"), "rr", [_s203["ctx"], _s203["bx"], _s203["by"], v_w_417, v_h_418, 4.0, "#ecd9a4", "#5a4030", 1.2])
	J.mc(J.G.get("ART"), "poly", [_s203["ctx"], [J.sub(J.gp(v_v_411, "x"), 5.0), J.sub(J.add(_s203["by"], v_h_418), 0.5), J.add(J.gp(v_v_411, "x"), 5.0), J.sub(J.add(_s203["by"], v_h_418), 0.5), J.gp(v_v_411, "x"), J.add(J.add(_s203["by"], v_h_418), 7.0)], "#ecd9a4"])
	var _t537 = _s203["ctx"]
	J.sp(_t537, "strokeStyle", "#5a4030")
	var _t538 = _s203["ctx"]
	J.sp(_t538, "lineWidth", 1.2)
	J.mc(_s203["ctx"], "beginPath", [])
	J.mc(_s203["ctx"], "moveTo", [J.sub(J.gp(v_v_411, "x"), 5.0), J.add(_s203["by"], v_h_418)])
	J.mc(_s203["ctx"], "lineTo", [J.gp(v_v_411, "x"), J.add(J.add(_s203["by"], v_h_418), 7.0)])
	J.mc(_s203["ctx"], "lineTo", [J.add(J.gp(v_v_411, "x"), 5.0), J.add(_s203["by"], v_h_418)])
	J.mc(_s203["ctx"], "stroke", [])
	var _t539 = _s203["ctx"]
	J.sp(_t539, "fillStyle", "#2b1d12")
	var _t540 = _s203["ctx"]
	J.sp(_t540, "textAlign", "left")
	var _t541 = _s203["ctx"]
	J.sp(_t541, "textBaseline", "top")
	J.mc(v_lines_415, "forEach", [Callable(self, "_f106").bind(_s203)])
	J.mc(_s203["ctx"], "restore", [])

func _f109(this_, a: Array, env):
	var v_g_432 = null; var v_i_433 = null; var v_p_434 = null
	v_g_432 = J.arg(a, 0)
	v_i_433 = J.arg(a, 1)
	v_p_434 = J.gp(env["pts"], J.mod(v_i_433, J.len(env["pts"])))
	J.mc(env["__p"]["out"], "push", [{"g": v_g_432, "x": J.gp(v_p_434, 0.0), "y": J.gp(v_p_434, 1.0), "flip": J.gp(v_p_434, 2.0), "ph": J.mul(v_i_433, 0.7), "post": env["post"]}])

func _f108(this_, a: Array, env):
	var _s212 = {"__p": env, "post": null, "pts": null}
	_s212["post"] = J.arg(a, 0)
	_s212["pts"] = J.arg(a, 1)
	var _t542 = J.G.get("workersAt")
	var _t543 = J.cl(_t542, null, [_s212["post"]])
	return J.mc(_t543, "forEach", [Callable(self, "_f109").bind(_s212)])

func _f107(this_, a: Array, env):
	var v_add_429 = null
	var _s211 = {"__p": env, "out": null}
	_s211["out"] = []
	v_add_429 = Callable(self, "_f108").bind(_s211)
	J.cl(v_add_429, null, ["wood", [[130.0, 520.0, 1.0], [178.0, 430.0, 1.0], [70.0, 540.0, 0.0], [24.0, 460.0, 0.0]]])
	J.cl(v_add_429, null, ["rice", [[290.0, 437.0, 0.0], [290.0, 487.0, 0.0], [290.0, 537.0, 1.0], [372.0, 487.0, 1.0]]])
	J.cl(v_add_429, null, ["plank", [[45.0, 770.0, 0.0], [140.0, 772.0, 1.0], [60.0, 790.0, 0.0], [128.0, 794.0, 1.0]]])
	J.cl(v_add_429, null, ["bun", [[250.0, 772.0, 0.0], [345.0, 770.0, 1.0], [262.0, 794.0, 0.0], [332.0, 794.0, 1.0]]])
	J.cl(v_add_429, null, ["store", [[150.0, 890.0, 0.0]]])
	J.cl(v_add_429, null, ["boss", [[260.0, 320.0, 1.0]]])
	J.cl(v_add_429, null, ["camp", [[250.0, 1018.0, 0.0], [350.0, 1018.0, 1.0], [270.0, 1036.0, 0.0], [330.0, 1036.0, 1.0]]])
	return _s211["out"]

func _f111(this_, a: Array, env):
	var v_v_439 = null
	v_v_439 = J.arg(a, 0)
	return J.cmp(v_v_439, 0.0, ">")

func _f112(this_, a: Array, env):
	var v_v_441 = null
	v_v_441 = J.arg(a, 0)
	return v_v_441

func _f110(this_, a: Array, env):
	var v_q_437 = null; var v_i_438 = null; var v_i_440 = null
	v_q_437 = J.mc(J.G.get("Quest"), "cur", [])
	if (not J.t(v_q_437)):
		return null
	if J.seq(J.gp(v_q_437, "go"), "tree"):
		var _t544 = J.gp(J.G.get("S"), "trees")
		v_i_438 = J.mc(_t544, "findIndex", [Callable(self, "_f111").bind(env)])
		return (J.gp(J.G.get("TREE_POS"), v_i_438) if J.cmp(v_i_438, 0.0, ">=") else J.gp(J.G.get("TREE_POS"), 0.0))
	if J.seq(J.gp(v_q_437, "go"), "paddy"):
		var _t545 = J.gp(J.G.get("S"), "paddy")
		v_i_440 = J.mc(_t545, "findIndex", [Callable(self, "_f112").bind(env)])
		return (J.gp(J.G.get("PADDY_POS"), v_i_440) if J.cmp(v_i_440, 0.0, ">=") else J.gp(J.G.get("PADDY_POS"), 0.0))
	if J.seq(J.gp(v_q_437, "go"), "gate"):
		return J.gp(J.G.get("POS"), "gate")
	if J.t(J.gp(J.G.get("POS"), J.gp(v_q_437, "go"))):
		return J.gp(J.G.get("POS"), J.gp(v_q_437, "go"))
	return null

func _f113(this_, a: Array, env):
	var v_ctx_444 = null; var v_t_445 = null; var v_p_446 = null; var v_vh_447 = null; var v_x_448 = null; var v_y_449 = null; var v_ty_450 = null; var v_top_451 = null; var v_bot_452 = null; var v_rot_453 = null
	v_ctx_444 = J.arg(a, 0)
	v_t_445 = J.arg(a, 1)
	v_p_446 = J.mc(this_, "questTarget", [])
	var _t546 = (not J.t(v_p_446))
	if (_t546 if _t546 else (not J.seq(J.gp(J.G.get("UI"), "tab"), "village"))):
		return null
	v_vh_447 = J.div(J.gp(this_, "h"), J.gp(this_, "scale"))
	var _t547 = J.gp(v_p_446, 0.0)
	v_x_448 = _t547
	var _t548 = J.gp(v_p_446, 1.0)
	v_y_449 = _t548
	var _t549 = J.seq(J.gp(J.gp(J.G.get("POS"), "house"), 0.0), v_x_448)
	v_ty_450 = (J.sub(v_y_449, (128.0 if (J.seq(J.gp(J.gp(J.G.get("POS"), "house"), 1.0), v_y_449) if _t549 else _t549) else 78.0)) + (sin(J.num(J.mul(v_t_445, 5.0))) * 5.0))
	v_top_451 = J.add(J.gp(this_, "camY"), 8.0)
	v_bot_452 = J.sub(J.add(J.gp(this_, "camY"), v_vh_447), 12.0)
	v_rot_453 = 0.0
	if J.cmp(v_ty_450, v_top_451, "<"):
		var _t550 = J.add(v_top_451, 14.0)
		v_ty_450 = _t550
		v_rot_453 = PI
	else:
		if J.cmp(v_ty_450, v_bot_452, ">"):
			var _t551 = J.sub(v_bot_452, 14.0)
			v_ty_450 = _t551
			v_rot_453 = 0.0
	J.mc(v_ctx_444, "save", [])
	J.mc(v_ctx_444, "translate", [v_x_448, v_ty_450])
	J.mc(v_ctx_444, "rotate", [v_rot_453])
	J.mc(J.G.get("ART"), "poly", [v_ctx_444, [(-9.0), (-14.0), 9.0, (-14.0), 9.0, (-2.0), 15.0, (-2.0), 0.0, 12.0, (-15.0), (-2.0), (-9.0), (-2.0)], "#ffd84a", "#3a2400", 2.0])
	J.mc(v_ctx_444, "restore", [])

func _f123(this_, a: Array, env):
	var v_p_548 = null; var v_a_549 = null; var v_w_550 = null; var v_h_551 = null; var v_sx_552 = null; var v_back_553 = null; var v_shade_554 = null; var v_q_555 = null; var v_q_556 = null
	v_p_548 = J.arg(a, 0)
	v_a_549 = J.arg(a, 1)
	v_w_550 = J.gp(v_p_548, "w")
	v_h_551 = J.gp(v_p_548, "h")
	v_sx_552 = cos(J.num(J.gp(v_p_548, "fl")))
	J.mc(env["x"], "save", [])
	J.mc(env["x"], "translate", [J.gp(v_p_548, "x"), J.gp(v_p_548, "y")])
	J.mc(env["x"], "rotate", [J.gp(v_p_548, "rot")])
	J.mc(env["x"], "scale", [v_sx_552, 1.0])
	var _t582 = env["x"]
	J.sp(_t582, "globalAlpha", v_a_549)
	v_back_553 = J.cmp(v_sx_552, 0.0, "<")
	v_shade_554 = (0.75 + (0.25 * absf(J.num(v_sx_552))))
	if J.t(J.gp(v_p_548, "gold")):
		var _t583 = env["x"]
		var _t584 = (("rgb(" + J.str(J.bor(J.mul(190.0, v_shade_554), 0.0)) + "," + J.str(J.bor(J.mul(140.0, v_shade_554), 0.0)) + "," + J.str(J.bor(J.mul(50.0, v_shade_554), 0.0)) + ")") if J.t(v_back_553) else ("rgb(" + J.str(J.bor(J.mul(236.0, v_shade_554), 0.0)) + "," + J.str(J.bor(J.mul(188.0, v_shade_554), 0.0)) + "," + J.str(J.bor(J.mul(70.0, v_shade_554), 0.0)) + ")"))
		J.sp(_t583, "fillStyle", _t584)
		J.mc(env["x"], "fillRect", [J.div((-J.num(v_w_550)), 2.0), J.div((-J.num(v_h_551)), 2.0), v_w_550, v_h_551])
		var _t585 = env["x"]
		J.sp(_t585, "strokeStyle", "rgba(140,80,10,.7)")
		var _t586 = env["x"]
		J.sp(_t586, "lineWidth", 1.0)
		J.mc(env["x"], "strokeRect", [(J.div((-J.num(v_w_550)), 2.0) + 1.5), (J.div((-J.num(v_h_551)), 2.0) + 1.5), J.sub(v_w_550, 3.0), J.sub(v_h_551, 3.0)])
		if (not J.t(v_back_553)):
			v_q_555 = J.mul(v_h_551, 0.42)
			var _t587 = env["x"]
			J.sp(_t587, "fillStyle", "#c8281c")
			J.mc(env["x"], "fillRect", [J.div((-J.num(v_q_555)), 2.0), J.div((-J.num(v_q_555)), 2.0), v_q_555, v_q_555])
			var _t588 = env["x"]
			J.sp(_t588, "fillStyle", "rgba(255,220,120,.85)")
			J.mc(env["x"], "fillRect", [J.div((-J.num(v_q_555)), 5.0), J.div((-J.num(v_q_555)), 5.0), J.mul(v_q_555, 0.4), J.mul(v_q_555, 0.4)])
	else:
		var _t589 = env["x"]
		var _t590 = (("rgb(" + J.str(J.bor(J.mul(170.0, v_shade_554), 0.0)) + "," + J.str(J.bor(J.mul(172.0, v_shade_554), 0.0)) + "," + J.str(J.bor(J.mul(178.0, v_shade_554), 0.0)) + ")") if J.t(v_back_553) else ("rgb(" + J.str(J.bor(J.mul(226.0, v_shade_554), 0.0)) + "," + J.str(J.bor(J.mul(228.0, v_shade_554), 0.0)) + "," + J.str(J.bor(J.mul(234.0, v_shade_554), 0.0)) + ")"))
		J.sp(_t589, "fillStyle", _t590)
		J.mc(env["x"], "fillRect", [J.div((-J.num(v_w_550)), 2.0), J.div((-J.num(v_h_551)), 2.0), v_w_550, v_h_551])
		var _t591 = env["x"]
		J.sp(_t591, "strokeStyle", "rgba(90,95,110,.6)")
		var _t592 = env["x"]
		J.sp(_t592, "lineWidth", 1.0)
		J.mc(env["x"], "strokeRect", [(J.div((-J.num(v_w_550)), 2.0) + 1.5), (J.div((-J.num(v_h_551)), 2.0) + 1.5), J.sub(v_w_550, 3.0), J.sub(v_h_551, 3.0)])
		if (not J.t(v_back_553)):
			v_q_556 = J.mul(v_h_551, 0.42)
			var _t593 = env["x"]
			J.sp(_t593, "fillStyle", "#7d828f")
			J.mc(env["x"], "fillRect", [J.div((-J.num(v_q_556)), 2.0), J.div((-J.num(v_q_556)), 2.0), v_q_556, v_q_556])
	J.mc(env["x"], "restore", [])

func _f124(this_, a: Array, env):
	var v_now_557 = null; var v_el_558 = null; var v_dt_559 = null; var v_fade_560 = null; var v_g_561 = null; var v_p_562 = null; var v_term_563 = null; var v_s_564 = null; var v_k_565 = null; var v_r_566 = null
	v_now_557 = J.arg(a, 0)
	v_el_558 = J.div(J.sub(v_now_557, env["t0"]), 1000.0)
	v_dt_559 = J.min_([0.05, J.div(J.sub(v_now_557, env["last"]), 1000.0)])
	env["last"] = v_now_557
	J.mc(env["x"], "setTransform", [env["dpr"], 0.0, 0.0, env["dpr"], 0.0, 0.0])
	J.mc(env["x"], "clearRect", [0.0, 0.0, env["vw"], env["vh"]])
	v_fade_560 = (J.max_([0.0, J.div(J.sub(env["T"], v_el_558), 0.6)]) if J.cmp(v_el_558, J.sub(env["T"], 0.6), ">") else 1.0)
	if J.cmp(v_el_558, 0.5, "<"):
		v_g_561 = J.mc(env["x"], "createRadialGradient", [env["ox"], env["oy"], 0.0, env["ox"], env["oy"], J.mul(160.0, env["sz"])])
		J.mc(v_g_561, "addColorStop", [0.0, ("rgba(255,200,90," + J.str((0.55 * (1.0 - J.div(v_el_558, 0.5)))) + ")")])
		J.mc(v_g_561, "addColorStop", [1.0, "rgba(255,120,30,0)"])
		var _t594 = env["x"]
		J.sp(_t594, "fillStyle", v_g_561)
		J.mc(env["x"], "fillRect", [0.0, 0.0, env["vw"], env["vh"]])
	for _t595 in J.iter(env["P"]):
		v_p_562 = _t595
		if J.cmp(v_el_558, J.gp(v_p_562, "delay"), "<"):
			continue
		var _t596 = J.mul(J.gp(v_p_562, "vx"), pow(J.num(0.35), J.num(v_dt_559)))
		J.sp(v_p_562, "vx", _t596)
		var _t597 = J.add(J.gp(v_p_562, "vy"), J.mul(J.mul(520.0, env["sz"]), v_dt_559))
		J.sp(v_p_562, "vy", _t597)
		var _t598 = J.gp(v_p_562, "term")
		v_term_563 = J.mul((_t598 if J.t(_t598) else 250.0), env["sz"])
		if J.cmp(J.gp(v_p_562, "vy"), v_term_563, ">"):
			var _t599 = J.add(J.gp(v_p_562, "vy"), (J.sub(v_term_563, J.gp(v_p_562, "vy")) * J.min_([1.0, J.mul(v_dt_559, 4.0)])))
			J.sp(v_p_562, "vy", _t599)
		var _t600 = J.add(J.gp(v_p_562, "sw"), J.mul(J.gp(v_p_562, "vs"), v_dt_559))
		J.sp(v_p_562, "sw", _t600)
		var _t601 = J.add(J.gp(v_p_562, "x"), J.mul(J.add(J.gp(v_p_562, "vx"), J.mul((sin(J.num(J.gp(v_p_562, "sw"))) * 70.0), env["sz"])), v_dt_559))
		J.sp(v_p_562, "x", _t601)
		var _t602 = J.add(J.gp(v_p_562, "y"), J.mul(J.gp(v_p_562, "vy"), v_dt_559))
		J.sp(v_p_562, "y", _t602)
		var _t603 = J.add(J.gp(v_p_562, "rot"), J.mul(J.gp(v_p_562, "vr"), v_dt_559))
		J.sp(v_p_562, "rot", _t603)
		var _t604 = J.add(J.gp(v_p_562, "fl"), J.mul(J.gp(v_p_562, "vf"), v_dt_559))
		J.sp(v_p_562, "fl", _t604)
		if J.cmp(J.gp(v_p_562, "y"), J.add(env["vh"], 40.0), "<"):
			var _t605 = env["paper"]
			J.cl(_t605, null, [v_p_562, v_fade_560])
	var _t606 = env["x"]
	J.sp(_t606, "globalCompositeOperation", "lighter")
	for _t607 in J.iter(env["S2"]):
		v_s_564 = _t607
		if J.cmp(v_el_558, J.gp(v_s_564, "d"), "<"):
			continue
		var _t608 = J.add(J.gp(v_s_564, "t"), v_dt_559)
		J.sp(v_s_564, "t", _t608)
		if J.cmp(J.gp(v_s_564, "t"), J.gp(v_s_564, "life"), ">"):
			continue
		var _t609 = J.add(J.gp(v_s_564, "vy"), J.mul(J.mul(600.0, env["sz"]), v_dt_559))
		J.sp(v_s_564, "vy", _t609)
		var _t610 = J.add(J.gp(v_s_564, "x"), J.mul(J.gp(v_s_564, "vx"), v_dt_559))
		J.sp(v_s_564, "x", _t610)
		var _t611 = J.add(J.gp(v_s_564, "y"), J.mul(J.gp(v_s_564, "vy"), v_dt_559))
		J.sp(v_s_564, "y", _t611)
		v_k_565 = (1.0 - J.div(J.gp(v_s_564, "t"), J.gp(v_s_564, "life")))
		v_r_566 = (2.0 + J.mul(3.0, v_k_565))
		var _t612 = env["x"]
		J.sp(_t612, "globalAlpha", v_k_565)
		var _t613 = env["x"]
		J.sp(_t613, "fillStyle", "#fff2b0")
		J.mc(env["x"], "beginPath", [])
		J.mc(env["x"], "moveTo", [J.gp(v_s_564, "x"), J.sub(J.gp(v_s_564, "y"), J.mul(v_r_566, 2.0))])
		J.mc(env["x"], "lineTo", [J.add(J.gp(v_s_564, "x"), J.mul(v_r_566, 0.5)), J.gp(v_s_564, "y")])
		J.mc(env["x"], "lineTo", [J.gp(v_s_564, "x"), J.add(J.gp(v_s_564, "y"), J.mul(v_r_566, 2.0))])
		J.mc(env["x"], "lineTo", [J.sub(J.gp(v_s_564, "x"), J.mul(v_r_566, 0.5)), J.gp(v_s_564, "y")])
		J.mc(env["x"], "closePath", [])
		J.mc(env["x"], "fill", [])
		J.mc(env["x"], "fillRect", [J.sub(J.gp(v_s_564, "x"), J.mul(v_r_566, 2.0)), J.sub(J.gp(v_s_564, "y"), 0.6), J.mul(v_r_566, 4.0), 1.2])
	var _t614 = env["x"]
	J.sp(_t614, "globalCompositeOperation", "source-over")
	var _t615 = env["x"]
	J.sp(_t615, "globalAlpha", 1.0)
	if J.cmp(v_el_558, env["T"], "<"):
		var _t616 = env["this"]
		var _t617 = J.F_requestAnimationFrame([env["step"]])
		J.sp(_t616, "raf", _t617)
	else:
		J.mc(env["cv"], "remove", [])
		var _t618 = env["this"]
		J.sp(_t618, "cv", null)
		var _t619 = env["this"]
		J.sp(_t619, "raf", 0.0)

func _f122(this_, a: Array, env):
	var v_N_525 = null; var v_R_527 = null; var v_V_535 = null; var v_r_536 = null; var v_fx_537 = null; var v_fy_538 = null; var v_e_539 = null; var v_i_540 = null; var v_burst_541 = null; var v_gold_542 = null; var v_w_543 = null; var v_p_544 = null; var v_ang_545 = null; var v_sp_546 = null; var v_i_547 = null
	var _s253 = {"__p": env, "this": null, "dpr": null, "vw": null, "vh": null, "cv": null, "x": null, "ox": null, "oy": null, "P": null, "sz": null, "S2": null, "T": null, "t0": null, "last": null, "paper": null, "step": null}
	_s253["this"] = this_
	if J.t(J.gp(_s253["this"], "raf")):
		J.F_cancelAnimationFrame([J.gp(_s253["this"], "raf")])
		if J.t(J.gp(_s253["this"], "cv")):
			J.mc(J.gp(_s253["this"], "cv"), "remove", [])
	var _t552 = J.gp(J.G.get("window"), "devicePixelRatio")
	var _t553 = J.gp(J.G.get("window"), "devicePixelRatio")
	_s253["dpr"] = J.min_([2.0, (_t553 if J.t(_t553) else 1.0)])
	_s253["vw"] = J.gp(J.G.get("window"), "innerWidth")
	_s253["vh"] = J.gp(J.G.get("window"), "innerHeight")
	_s253["cv"] = J.S_document_("createElement", ["canvas"])
	var _t554 = _s253["cv"]
	J.sp(_t554, "id", "jossfx")
	var _t555 = _s253["cv"]
	var _t556 = J.round(J.num(J.mul(_s253["vw"], _s253["dpr"])))
	J.sp(_t555, "width", _t556)
	var _t557 = _s253["cv"]
	var _t558 = J.round(J.num(J.mul(_s253["vh"], _s253["dpr"])))
	J.sp(_t557, "height", _t558)
	var _t559 = J.gp(_s253["cv"], "style")
	var _t560 = ("position:fixed;left:0;top:0;width:" + J.str(_s253["vw"]) + "px;height:" + J.str(_s253["vh"]) + "px;pointer-events:none;z-index:65")
	J.sp(_t559, "cssText", _t560)
	var _t561 = J.gp(J.G.get("document"), "body")
	J.mc(_t561, "appendChild", [_s253["cv"]])
	var _t562 = _s253["this"]
	var _t563 = _s253["cv"]
	J.sp(_t562, "cv", _t563)
	_s253["x"] = J.mc(_s253["cv"], "getContext", ["2d"])
	_s253["ox"] = J.mul(_s253["vw"], 0.8)
	_s253["oy"] = J.mul(_s253["vh"], 0.55)
	v_V_535 = J.G.get("Village")
	v_r_536 = J.mc(J.gp(v_V_535, "cvs"), "getBoundingClientRect", [])
	var _t564 = J.gp(J.G.get("POS"), "furnace")
	var _t565 = J.gp(_t564, 0.0)
	v_fx_537 = _t565
	var _t566 = J.gp(_t564, 1.0)
	v_fy_538 = _t566
	var _t567 = J.add(J.gp(v_r_536, "left"), J.mul(v_fx_537, J.gp(v_V_535, "scale")))
	_s253["ox"] = _t567
	var _t568 = J.add(J.gp(v_r_536, "top"), J.mul(J.sub(J.sub(v_fy_538, 40.0), J.gp(v_V_535, "camY")), J.gp(v_V_535, "scale")))
	_s253["oy"] = _t568
	var _t569 = J.max_([30.0, J.min_([J.sub(_s253["vw"], 30.0), _s253["ox"]])])
	_s253["ox"] = _t569
	var _t570 = J.max_([J.mul(_s253["vh"], 0.25), J.min_([J.mul(_s253["vh"], 0.8), _s253["oy"]])])
	_s253["oy"] = _t570
	v_N_525 = (140.0 if J.cmp(_s253["vw"], 500.0, "<") else 170.0)
	_s253["P"] = []
	v_R_527 = J.gp(J.G.get("Math"), "random")
	_s253["sz"] = J.div(J.max_([_s253["vw"], _s253["vh"]]), 844.0)
	v_i_540 = 0.0
	while true:
		if not J.cmp(v_i_540, v_N_525, "<"): break
		v_burst_541 = J.cmp(v_i_540, J.mul(v_N_525, 0.55), "<")
		v_gold_542 = J.cmp(J.cl(v_R_527, null, []), 0.6, "<")
		v_w_543 = J.mul((16.0 + J.mul(J.cl(v_R_527, null, []), 12.0)), _s253["sz"])
		v_p_544 = {"gold": v_gold_542, "w": v_w_543, "h": J.mul(v_w_543, (0.72 + J.mul(J.cl(v_R_527, null, []), 0.14))), "rot": J.mul(J.cl(v_R_527, null, []), 6.3), "vr": (J.sub(J.cl(v_R_527, null, []), 0.5) * 7.0), "fl": J.mul(J.cl(v_R_527, null, []), 6.3), "vf": (4.0 + J.mul(J.cl(v_R_527, null, []), 8.0)), "sw": J.mul(J.cl(v_R_527, null, []), 6.3), "vs": (1.5 + J.mul(J.cl(v_R_527, null, []), 2.5)), "delay": 0.0}
		if J.t(v_burst_541):
			v_ang_545 = (J.div((-PI), 2.0) + (J.sub(J.cl(v_R_527, null, []), 0.5) * 1.9))
			v_sp_546 = J.mul((420.0 + J.mul(J.cl(v_R_527, null, []), 520.0)), _s253["sz"])
			var _t571 = _s253["ox"]
			J.sp(v_p_544, "x", _t571)
			var _t572 = _s253["oy"]
			J.sp(v_p_544, "y", _t572)
			var _t573 = J.mul(cos(J.num(v_ang_545)), v_sp_546)
			J.sp(v_p_544, "vx", _t573)
			var _t574 = J.mul(sin(J.num(v_ang_545)), v_sp_546)
			J.sp(v_p_544, "vy", _t574)
			var _t575 = J.mul(J.cl(v_R_527, null, []), 0.3)
			J.sp(v_p_544, "delay", _t575)
		else:
			var _t576 = J.mul(J.cl(v_R_527, null, []), _s253["vw"])
			J.sp(v_p_544, "x", _t576)
			var _t577 = ((-30.0) - (J.mul(J.cl(v_R_527, null, []), _s253["vh"]) * 0.25))
			J.sp(v_p_544, "y", _t577)
			var _t578 = (J.sub(J.cl(v_R_527, null, []), 0.5) * 60.0)
			J.sp(v_p_544, "vx", _t578)
			var _t579 = (320.0 + J.mul(J.cl(v_R_527, null, []), 160.0))
			J.sp(v_p_544, "vy", _t579)
			var _t580 = J.mul(J.cl(v_R_527, null, []), 0.5)
			J.sp(v_p_544, "delay", _t580)
		var _t581 = (300.0 + J.mul(J.cl(v_R_527, null, []), 160.0))
		J.sp(v_p_544, "term", _t581)
		J.mc(_s253["P"], "push", [v_p_544])
		v_i_540 = J.num(v_i_540) + 1.0
	_s253["S2"] = []
	v_i_547 = 0.0
	while true:
		if not J.cmp(v_i_547, 46.0, "<"): break
		J.mc(_s253["S2"], "push", [{"x": J.add(_s253["ox"], (J.sub(J.cl(v_R_527, null, []), 0.5) * 60.0)), "y": _s253["oy"], "vx": J.mul((J.sub(J.cl(v_R_527, null, []), 0.5) * 500.0), _s253["sz"]), "vy": J.mul((-(200.0 + J.mul(J.cl(v_R_527, null, []), 700.0))), _s253["sz"]), "life": (0.6 + J.mul(J.cl(v_R_527, null, []), 0.9)), "t": 0.0, "d": J.mul(J.cl(v_R_527, null, []), 0.5)}])
		v_i_547 = J.num(v_i_547) + 1.0
	_s253["T"] = 2.8
	_s253["t0"] = J.S_performance_("now", [])
	_s253["last"] = _s253["t0"]
	_s253["paper"] = Callable(self, "_f123").bind(_s253)
	_s253["step"] = Callable(self, "_f124").bind(_s253)
	var _t620 = _s253["this"]
	var _t621 = J.F_requestAnimationFrame([_s253["step"]])
	J.sp(_t620, "raf", _t621)

func _f125(this_, a: Array, env):
	var v_x_569 = null; var v_y_570 = null; var v_text_571 = null; var v_col_572 = null
	v_x_569 = J.arg(a, 0)
	v_y_570 = J.arg(a, 1)
	v_text_571 = J.arg(a, 2)
	v_col_572 = J.arg(a, 3)
	var _t622 = J.gp(J.G.get("Village"), "floats")
	J.mc(_t622, "push", [{"x": v_x_569, "y": v_y_570, "text": v_text_571, "col": (v_col_572 if J.t(v_col_572) else "#fff"), "t": 0.0, "life": 1.6}])

func _f127(this_, a: Array, env):
	var _t628 = J.gp(env["d"], "classList")
	return J.mc(_t628, "add", ["out"])

func _f128(this_, a: Array, env):
	return J.mc(env["d"], "remove", [])

func _f126(this_, a: Array, env):
	var v_html_575 = null; var v_box_576 = null
	var _s276 = {"__p": env, "d": null}
	v_html_575 = J.arg(a, 0)
	var _t623 = J.G.get("$")
	v_box_576 = J.cl(_t623, null, ["#toasts"])
	while true:
		if not (J.len(J.gp(v_box_576, "children")) >= 3.0): break
		J.mc(J.gp(v_box_576, "firstChild"), "remove", [])
	_s276["d"] = J.S_document_("createElement", ["div"])
	var _t624 = _s276["d"]
	J.sp(_t624, "className", "toast")
	var _t625 = _s276["d"]
	J.sp(_t625, "innerHTML", v_html_575)
	var _t626 = J.G.get("$")
	var _t627 = J.cl(_t626, null, ["#toasts"])
	J.mc(_t627, "appendChild", [_s276["d"]])
	J.F_setTimeout([Callable(self, "_f127").bind(_s276), 2600.0])
	J.F_setTimeout([Callable(self, "_f128").bind(_s276), 3200.0])

func _f129(this_, a: Array, env):
	var v_text_580 = null; var v_d_581 = null
	v_text_580 = J.arg(a, 0)
	var _t629 = J.G.get("$")
	v_d_581 = J.cl(_t629, null, ["#banner"])
	J.sp(v_d_581, "textContent", v_text_580)
	var _t630 = J.gp(v_d_581, "classList")
	J.mc(_t630, "remove", ["show"])
	J.nop(J.gp(v_d_581, "offsetWidth"))
	var _t631 = J.gp(v_d_581, "classList")
	J.mc(_t631, "add", ["show"])

func _f130(this_, a: Array, env):
	var v_kind_584 = null; var v_pool_585 = null; var v_i_586 = null; var v_d_587 = null; var v_c_588 = null; var v_ic_589 = null
	v_kind_584 = J.arg(a, 0)
	v_pool_585 = (J.G.get("PRAISE_KIND") if J.t(J.gp(J.G.get("S"), "ended")) else (J.G.get("PRAISE_CHOP") if J.seq(v_kind_584, "chop") else (J.G.get("PRAISE_RICE") if J.seq(v_kind_584, "rice") else J.G.get("PRAISE_CRAFT"))))
	v_i_586 = null
	var _t632 = true
	while true:
		if not _t632:
			var _t633 = (J.len(v_pool_585) > 1.0)
			if not (J.seq(v_i_586, J.gp(J.gp(this_, "lastPraise"), v_kind_584)) if _t633 else _t633): break
		_t632 = false
		var _t634 = floor(J.num((randf() * J.len(v_pool_585))))
		v_i_586 = _t634
	var _t635 = J.gp(this_, "lastPraise")
	J.sp(_t635, v_kind_584, v_i_586)
	var _t636 = J.G.get("$")
	v_d_587 = J.cl(_t636, null, ["#praise"])
	var _t637 = ("<canvas></canvas><span>" + J.str(J.gp(v_pool_585, v_i_586)) + "</span>")
	J.sp(v_d_587, "innerHTML", _t637)
	v_c_588 = J.mc(v_d_587, "querySelector", ["canvas"])
	v_ic_589 = J.mc(J.G.get("ART"), "sysIcon", [30.0])
	var _t638 = J.gp(v_ic_589, "width")
	J.sp(v_c_588, "width", _t638)
	var _t639 = J.gp(v_ic_589, "height")
	J.sp(v_c_588, "height", _t639)
	var _t640 = J.gp(v_c_588, "style")
	J.sp(_t640, "width", "30px")
	var _t641 = J.gp(v_c_588, "style")
	J.sp(_t641, "height", "30px")
	var _t642 = J.mc(v_c_588, "getContext", ["2d"])
	J.mc(_t642, "drawImage", [v_ic_589, 0.0, 0.0])
	var _t643 = J.gp(v_d_587, "classList")
	J.mc(_t643, "remove", ["show"])
	J.nop(J.gp(v_d_587, "offsetWidth"))
	var _t644 = J.gp(v_d_587, "classList")
	J.mc(_t644, "add", ["show"])
	J.mc(J.G.get("Sound"), "play", ["praise"])
	var _t645 = J.cmp(J.gp(J.G.get("S"), "lv"), 3.0, ">=")
	if ((randf() < 0.04) if _t645 else _t645):
		var _t646 = J.gp(J.G.get("S"), "chests")
		J.sp(_t646, "g", J.num(J.gp(_t646, "g")) + 1.0)
		J.mc(J.G.get("Fx"), "toast", ["系統太滿意了，掉落一個<b>綠箱</b>！"])

func _f131(this_, a: Array, env):
	var _t647 = (not (not J.t(J.gp(this_, "cur"))))
	return (_t647 if _t647 else (J.len(J.gp(this_, "q")) > 0.0))

func _f132(this_, a: Array, env):
	var v_sc_594 = null; var v_cb_595 = null
	v_sc_594 = J.arg(a, 0)
	v_cb_595 = J.arg(a, 1)
	var _t648 = J.gp(this_, "q")
	J.mc(_t648, "push", [{"sc": v_sc_594, "cb": v_cb_595}])
	if (not J.t(J.gp(this_, "cur"))):
		J.mc(this_, "next", [])

func _f133(this_, a: Array, env):
	var v_it_598 = null; var v_sc_599 = null; var v_f_600 = null
	var _t649 = J.gp(this_, "cur")
	if J.t((J.gp(J.gp(this_, "cur"), "cb") if J.t(_t649) else _t649)):
		v_f_600 = J.gp(J.gp(this_, "cur"), "cb")
		var _t650 = J.gp(this_, "cur")
		J.sp(_t650, "cb", null)
		J.cl(v_f_600, null, [])
	v_it_598 = J.mc(J.gp(this_, "q"), "shift", [])
	if (not J.t(v_it_598)):
		var _t651 = this_
		J.sp(_t651, "cur", null)
		var _t652 = J.G.get("$")
		var _t653 = J.cl(_t652, null, ["#dlg"])
		J.sp(_t653, "className", "")
		var _t654 = J.G.get("$")
		var _t655 = J.cl(_t654, null, ["#dlg"])
		J.sp(_t655, "innerHTML", "")
		var _t656 = (not J.t(J.gp(J.G.get("Battle"), "active")))
		if ((not J.t(J.gp(J.G.get("Phone"), "on"))) if _t656 else _t656):
			J.mc(J.G.get("Sound"), "setMode", ["village"])
		J.mc(J.G.get("UI"), "refresh", [])
		J.mc(J.G.get("Quest"), "check", [])
		J.cl(J.G.get("save"), null, [])
		return null
	v_sc_599 = (J.gp(J.G.get("SCENES"), J.gp(v_it_598, "sc")) if J.seq(J.typeof_(J.gp(v_it_598, "sc")), "string") else J.gp(v_it_598, "sc"))
	if J.seq(J.typeof_(J.gp(v_it_598, "sc")), "string"):
		var _t657 = J.gp(J.G.get("S"), "seen")
		var _t658 = J.gp(v_it_598, "sc")
		J.sp(_t657, _t658, true)
	J.F_clearTimeout([J.gp(this_, "chatT")])
	var _t659 = this_
	J.sp(_t659, "chatWait", null)
	var _t660 = this_
	J.sp(_t660, "chatFast", null)
	var _t661 = this_
	J.sp(_t661, "lastMine", null)
	var _t662 = this_
	var _t663 = {"sc": v_sc_599, "cb": J.gp(v_it_598, "cb"), "id": (J.gp(v_it_598, "sc") if J.seq(J.typeof_(J.gp(v_it_598, "sc")), "string") else null)}
	J.sp(_t662, "cur", _t663)
	var _t664 = this_
	J.sp(_t664, "li", 0.0)
	if (not J.t(J.gp(J.G.get("Battle"), "active"))):
		J.mc(J.G.get("Sound"), "setMode", [("office" if J.seq(J.gp(J.gp(this_, "cur"), "id"), "prologue_chat") else "story")])
	J.mc(this_, "render", [true])

func _f135(this_, a: Array, env):
	var v_e_606 = null
	v_e_606 = J.arg(a, 0)
	var _t670 = J.gp(v_e_606, "target")
	if J.t(J.mc(_t670, "closest", [".skip"])):
		J.mc(env["this"], "skipScene", [])
		return null
	J.mc(env["this"], "advance", [v_e_606])

func _f136(this_, a: Array, env):
	var v_l_607 = null
	v_l_607 = J.arg(a, 0)
	return J.gp(v_l_607, 0.0)

func _f137(this_, a: Array, env):
	var v_n_608 = null
	v_n_608 = J.arg(a, 0)
	var _t675 = J.gp(J.G.get("SPEAKER_ART"), v_n_608)
	return ((not J.seq(v_n_608, "黑白無常")) if J.t(_t675) else _t675)

func _f134(this_, a: Array, env):
	var v_first_603 = null; var v_sc_604 = null; var v_box_605 = null
	var _s288 = {"__p": env, "this": null}
	_s288["this"] = this_
	v_first_603 = J.arg(a, 0)
	var _t665 = J.gp(_s288["this"], "cur")
	var _t666 = J.gp(_t665, "sc")
	v_sc_604 = _t666
	var _t667 = J.G.get("$")
	v_box_605 = J.cl(_t667, null, ["#dlg"])
	var _t668 = J.add("on st-", J.gp(v_sc_604, "style"))
	J.sp(v_box_605, "className", _t668)
	if J.t(v_first_603):
		var _t669 = J.mc(_s288["this"], "frame", [v_sc_604])
		J.sp(v_box_605, "innerHTML", _t669)
		var _t671 = Callable(self, "_f135").bind(_s288)
		J.sp(v_box_605, "onclick", _t671)
		if J.seq(J.gp(v_sc_604, "style"), "talk"):
			var _t672 = _s288["this"]
			var _t673 = J.gp(v_sc_604, "lines")
			var _t674 = J.mc(_t673, "map", [Callable(self, "_f136").bind(_s288)])
			var _t676 = J.spread([J.SP(J.new_("Set", [J.mc(_t674, "filter", [Callable(self, "_f137").bind(_s288)])]))])
			var _t677 = J.mc(_t676, "slice", [0.0, 6.0])
			J.sp(_t672, "actors", _t677)
			J.mc(_s288["this"], "drawStage", [])
	J.mc(_s288["this"], "showLine", [])

func _f138(this_, a: Array, env):
	var v_sc_611 = null; var v_sk_612 = null
	v_sc_611 = J.arg(a, 0)
	v_sk_612 = "<button class=\"skip\">跳過 ▸▸</button>"
	var _t678 = J.gp(v_sc_611, "style")
	var _t679 = -1
	var _t680 = false
	if _t679 == -1 and J.seq(_t678, "chat"): _t679 = 0
	if _t679 == -1 and J.seq(_t678, "sys"): _t679 = 1
	if _t679 == -1 and J.seq(_t678, "news"): _t679 = 2
	if _t679 == -1 and J.seq(_t678, "notice"): _t679 = 3
	if _t679 == -1 and J.seq(_t678, "radio"): _t679 = 4
	if _t679 == -1 and J.seq(_t678, "report"): _t679 = 5
	if _t679 == -1 and J.seq(_t678, "mail"): _t679 = 6
	if _t679 == -1 and J.seq(_t678, "letter"): _t679 = 7
	if _t679 == -1 and J.seq(_t678, "narr"): _t679 = 8
	if _t679 == -1: _t679 = 9
	while true:
		if _t679 <= 0 and _t679 >= 0:
			var _t681 = J.G.get("waStatus")
			var _t684 = J.cl(_t681, null, [("02:13" if J.seq(J.gp(J.gp(this_, "cur"), "id"), "prologue_chat") else J.cl(J.G.get("nowHM"), null, [])), ("3%" if J.seq(J.gp(J.gp(this_, "cur"), "id"), "prologue_chat") else "∞"), J.seq(J.gp(J.gp(this_, "cur"), "id"), "prologue_chat")])
			var _t685 = J.gp(J.G.get("ICON"), "back")
			var _t682 = J.G.get("waAvatar")
			var _t683 = J.gp(v_sc_611, "av")
			var _t687 = J.cl(_t682, null, [(_t683 if J.t(_t683) else ["?", "#555"]), 38.0])
			var _t688 = J.gp(v_sc_611, "title")
			var _t686 = J.gp(v_sc_611, "group")
			return (J.str(v_sk_612) + "<div class=\"wa wa-chat\">" + J.str(_t684) + "<div class=\"wa-head\"><span class=\"wa-back\">" + J.str(_t685) + "</span>" + J.str(_t687) + "<div class=\"wa-who\"><b>" + J.str(_t688) + "</b><small class=\"wa-sub\">" + J.str((_t686 if J.t(_t686) else "在線上")) + "</small></div><span class=\"ic\">" + J.str(J.gp(J.G.get("ICON"), "video")) + "</span><span class=\"ic\">" + J.str(J.gp(J.G.get("ICON"), "call")) + "</span><span class=\"ic\">" + J.str(J.gp(J.G.get("ICON"), "dots")) + "</span></div><div class=\"wa-body\"><div class=\"wa-lock\">🔒 訊息和通話皆已端對端加密。</div><div class=\"wa-day\">今天</div></div><div class=\"wa-input\"><div class=\"wa-field\">" + J.str(J.gp(J.G.get("ICON"), "smile")) + "<span class=\"wa-txt\">輸入訊息</span>" + J.str(J.gp(J.G.get("ICON"), "clip")) + "</div><button class=\"wa-send\">" + J.str(J.gp(J.G.get("ICON"), "mic")) + "</button></div><div class=\"wa-crack\"></div></div><div class=\"tap\" style=\"display:none\">點擊繼續</div>")
		if _t679 <= 1 and _t679 >= 0:
			return (J.str(v_sk_612) + "<div class=\"syswin\"><div class=\"sys-h\">陰司 KPI 系統</div><div class=\"sys-body\"></div></div><div class=\"tap\">點擊繼續</div>")
		if _t679 <= 2 and _t679 >= 0:
			return (J.str(v_sk_612) + "<div class=\"tv\"><div class=\"tv-screen\"><div class=\"tv-logo\">陰間新聞台 <i>LIVE</i></div><canvas class=\"anchor\" width=\"160\" height=\"160\"></canvas><div class=\"tv-sub\"></div></div><div class=\"tv-ticker\"><span>快訊：鬼門將開　落魄村徵求打工鬼　包吃（包子）　詳情請洽陰司 KPI 系統</span></div></div><div class=\"tap\">點擊繼續</div>")
		if _t679 <= 3 and _t679 >= 0:
			return (J.str(v_sk_612) + "<div class=\"notice\"><div class=\"nt-h\">" + J.str(J.gp(v_sc_611, "title")) + "</div><div class=\"nt-body\"></div><div class=\"nt-stamp\">湘西</div></div><div class=\"tap\">點擊繼續</div>")
		if _t679 <= 4 and _t679 >= 0:
			return (J.str(v_sk_612) + "<div class=\"radio\"><div class=\"rd-h\">" + J.str(J.gp(v_sc_611, "title")) + "</div><div class=\"rd-wave\"></div><div class=\"rd-body\"></div></div><div class=\"tap\">點擊繼續</div>")
		if _t679 <= 5 and _t679 >= 0:
			return (J.str(v_sk_612) + "<div class=\"term\"><div class=\"tm-h\">&gt; " + J.str(J.gp(v_sc_611, "title")) + "</div><div class=\"tm-body\"></div></div><div class=\"tap\">點擊繼續</div>")
		if _t679 <= 6 and _t679 >= 0:
			return (J.str(v_sk_612) + "<div class=\"mail\"><div class=\"ml-h\">" + J.str(J.gp(v_sc_611, "title")) + "</div><div class=\"ml-body\"></div></div><div class=\"tap\">點擊繼續</div>")
		if _t679 <= 7 and _t679 >= 0:
			return (J.str(v_sk_612) + "<div class=\"letterwrap\"><div class=\"letter-body\"></div></div><div class=\"tap\">點擊繼續</div>")
		if _t679 <= 8 and _t679 >= 0:
			return (J.str(v_sk_612) + "<div class=\"narr-body\"></div><div class=\"tap\">點擊繼續</div>")
		if _t679 <= 9 and _t679 >= 0:
			return (J.str(v_sk_612) + "<canvas class=\"stage\"></canvas><div class=\"talkbox\"><canvas class=\"pt\" width=\"120\" height=\"120\"></canvas><div class=\"nm\"></div><div class=\"tx\"></div><div class=\"nx\">▼</div></div>")
		break

func _f140(this_, a: Array, env):
	var v_a_626 = null; var v_i_627 = null; var v_x_628 = null; var v_y_629 = null; var v_base_630 = null; var v_on_631 = null; var v_type_632 = null; var v_sid_633 = null
	v_a_626 = J.arg(a, 0)
	v_i_627 = J.arg(a, 1)
	v_x_628 = J.mul(env["w"], (0.5 if J.seq(env["n"], 1.0) else (0.16 + J.div(J.mul(0.68, v_i_627), J.max_([1.0, J.sub(env["n"], 1.0)])))))
	v_y_629 = (J.mul(env["h"], 0.66) + ((J.mod(v_i_627, 2.0) * 18.0) if J.cmp(env["n"], 3.0, ">") else 0.0))
	v_base_630 = (3.1 if J.cmp(env["n"], 2.0, "<=") else (2.7 if J.seq(env["n"], 3.0) else (2.3 if J.seq(env["n"], 4.0) else 1.9)))
	var _t700 = J.seq(v_a_626, env["speaker"])
	if not J.t(_t700):
		var _t699 = J.seq(env["speaker"], "黑白無常")
		if J.t(_t699):
			var _t698 = J.seq(v_a_626, "白無常")
			_t699 = (_t698 if _t698 else J.seq(v_a_626, "黑無常"))
		_t700 = _t699
	v_on_631 = _t700
	v_type_632 = J.gp(J.G.get("SPEAKER_ART"), v_a_626)
	var _t701 = J.gp(J.gp(env["this"], "cur"), "id")
	v_sid_633 = (_t701 if J.t(_t701) else "")
	var _t709 = env["ctx"]
	var _t710 = J.add(v_y_629, (0.0 if J.t(v_on_631) else 6.0))
	var _t711 = (v_base_630 if J.t(v_on_631) else J.mul(v_base_630, 0.9))
	var _t705 = J.cmp(v_x_628, J.div(env["w"], 2.0), ">")
	var _t706 = (1.0 if J.t(v_on_631) else 0.45)
	var _t707 = (not J.seq(v_sid_633, "ch4_boss"))
	var _t708 = (not J.seq(v_sid_633, "ch5_intro2"))
	var _t702 = J.mc(J.re("boss", ""), "test", [v_sid_633])
	var _t703 = ((not J.seq(v_a_626, "阿福")) if J.t(_t702) else _t702)
	var _t704 = ((not J.seq(v_a_626, "小紙")) if J.t(_t703) else _t703)
	J.mc(J.G.get("ART"), "drawChar", [_t709, v_type_632, v_x_628, _t710, _t711, {"t": 0.3, "flip": _t705, "alpha": _t706, "tamed": _t707, "untied": _t708, "enemy": (v_on_631 if J.t(_t704) else _t704)}])

func _f139(this_, a: Array, env):
	var v_box_615 = null; var v_c_616 = null; var v_r_617 = null; var v_dpr_618 = null; var v_bg_622 = null; var v_g_625 = null
	var _s297 = {"__p": env, "this": null, "ctx": null, "w": null, "h": null, "n": null, "speaker": null}
	_s297["this"] = this_
	var _t689 = J.G.get("$")
	v_box_615 = J.cl(_t689, null, ["#dlg"])
	v_c_616 = J.mc(v_box_615, "querySelector", ["canvas.stage"])
	if (not J.t(v_c_616)):
		return null
	v_r_617 = J.mc(v_box_615, "getBoundingClientRect", [])
	var _t690 = J.gp(J.G.get("window"), "devicePixelRatio")
	var _t691 = J.gp(J.G.get("window"), "devicePixelRatio")
	v_dpr_618 = J.min_([2.0, (_t691 if J.t(_t691) else 1.0)])
	var _t692 = J.mul(J.gp(v_r_617, "width"), v_dpr_618)
	J.sp(v_c_616, "width", _t692)
	var _t693 = J.mul(J.gp(v_r_617, "height"), v_dpr_618)
	J.sp(v_c_616, "height", _t693)
	_s297["ctx"] = J.mc(v_c_616, "getContext", ["2d"])
	J.mc(_s297["ctx"], "scale", [v_dpr_618, v_dpr_618])
	_s297["w"] = J.gp(v_r_617, "width")
	_s297["h"] = J.gp(v_r_617, "height")
	var _t694 = J.gp(J.gp(J.gp(_s297["this"], "cur"), "sc"), "bg")
	v_bg_622 = (_t694 if J.t(_t694) else "village")
	var _t695 = J.G.get("paintBg")
	J.cl(_t695, null, [_s297["ctx"], _s297["w"], _s297["h"], v_bg_622, 0.0])
	_s297["n"] = J.len(J.gp(_s297["this"], "actors"))
	_s297["speaker"] = (J.gp(J.gp(J.gp(J.gp(J.gp(_s297["this"], "cur"), "sc"), "lines"), J.gp(_s297["this"], "li")), 0.0) if J.t(J.gp(J.gp(J.gp(J.gp(_s297["this"], "cur"), "sc"), "lines"), J.gp(_s297["this"], "li"))) else "")
	if J.t(J.gp(J.gp(J.gp(_s297["this"], "cur"), "sc"), "mic")):
		v_g_625 = J.mc(_s297["ctx"], "createRadialGradient", [J.mul(_s297["w"], 0.5), J.mul(_s297["h"], 0.62), 10.0, J.mul(_s297["w"], 0.5), J.mul(_s297["h"], 0.62), J.mul(_s297["w"], 0.55)])
		J.mc(v_g_625, "addColorStop", [0.0, "rgba(255,236,190,.28)"])
		J.mc(v_g_625, "addColorStop", [1.0, "rgba(0,0,0,.55)"])
		var _t696 = _s297["ctx"]
		J.sp(_t696, "fillStyle", v_g_625)
		J.mc(_s297["ctx"], "fillRect", [0.0, 0.0, _s297["w"], _s297["h"]])
	var _t697 = J.gp(_s297["this"], "actors")
	J.mc(_t697, "forEach", [Callable(self, "_f140").bind(_s297)])

func _f143(this_, a: Array, env):
	J.F_clearInterval([J.gp(env["__p"]["this"], "timer")])
	var _t720 = env["el"]
	var _t721 = env["__p"]["text"]
	J.sp(_t720, "textContent", _t721)
	var _t722 = env["__p"]["this"]
	J.sp(_t722, "typing", false)
	if J.t(env["cb"]):
		J.cl(env["cb"], null, [])

func _f144(this_, a: Array, env):
	env["i"] = J.num(env["i"]) + 1.0
	var _t725 = env["el"]
	var _t726 = J.mc(env["__p"]["text"], "slice", [0.0, env["i"]])
	J.sp(_t725, "textContent", _t726)
	if J.cmp(env["i"], J.len(env["__p"]["text"]), ">="):
		J.F_clearInterval([J.gp(env["__p"]["this"], "timer")])
		var _t727 = env["__p"]["this"]
		J.sp(_t727, "typing", false)
		if J.t(env["cb"]):
			J.cl(env["cb"], null, [])

func _f142(this_, a: Array, env):
	var _s303 = {"__p": env, "el": null, "cb": null, "i": null}
	_s303["el"] = J.arg(a, 0)
	_s303["cb"] = J.arg(a, 1)
	var _t718 = _s303["__p"]["this"]
	J.sp(_t718, "typing", true)
	_s303["i"] = 0.0
	J.F_clearInterval([J.gp(_s303["__p"]["this"], "timer")])
	var _t719 = _s303["__p"]["this"]
	var _t723 = Callable(self, "_f143").bind(_s303)
	J.sp(_t719, "full", _t723)
	var _t724 = _s303["__p"]["this"]
	var _t728 = J.F_setInterval([Callable(self, "_f144").bind(_s303), 28.0])
	J.sp(_t724, "timer", _t728)

func _f145(this_, a: Array, env):
	var v_container_648 = null; var v_cls_649 = null; var v_inner_650 = null; var v_d_651 = null
	v_container_648 = J.arg(a, 0)
	v_cls_649 = J.arg(a, 1)
	v_inner_650 = J.arg(a, 2)
	v_d_651 = J.S_document_("createElement", ["div"])
	J.sp(v_d_651, "className", v_cls_649)
	J.sp(v_d_651, "innerHTML", v_inner_650)
	J.mc(v_container_648, "appendChild", [v_d_651])
	var _t729 = J.gp(v_container_648, "scrollHeight")
	J.sp(v_container_648, "scrollTop", _t729)
	return v_d_651

func _f141(this_, a: Array, env):
	var v_sc_636 = null; var v_who_637 = null; var v_raw_638 = null; var v_box_639 = null; var v_time_641 = null; var v_typeInto_642 = null; var v_add_643 = null; var v_m_644 = null; var v_d_652 = null; var v_s_653 = null; var v_d_654 = null; var v_d_655 = null; var v_d_656 = null; var v_d_657 = null; var v_d_658 = null; var v_d_659 = null; var v_nm_660 = null; var v_tx_661 = null; var v_pt_662 = null; var v_pc_663 = null; var v_art_664 = null; var v_sid_665 = null
	var _s300 = {"__p": env, "this": null, "text": null}
	_s300["this"] = this_
	var _t712 = J.gp(_s300["this"], "cur")
	var _t713 = J.gp(_t712, "sc")
	v_sc_636 = _t713
	var _t714 = J.gp(J.gp(v_sc_636, "lines"), J.gp(_s300["this"], "li"))
	var _t715 = J.gp(_t714, 0.0)
	v_who_637 = _t715
	var _t716 = J.gp(_t714, 1.0)
	v_raw_638 = _t716
	var _t717 = J.G.get("$")
	v_box_639 = J.cl(_t717, null, ["#dlg"])
	_s300["text"] = v_raw_638
	v_time_641 = ""
	if J.seq(J.gp(v_sc_636, "style"), "chat"):
		v_m_644 = J.mc(v_raw_638, "match", [J.re("^(\\d\\d:\\d\\d)\\|(.*)$", "")])
		if J.t(v_m_644):
			v_time_641 = J.gp(v_m_644, 1.0)
			_s300["text"] = J.gp(v_m_644, 2.0)
	v_typeInto_642 = Callable(self, "_f142").bind(_s300)
	v_add_643 = Callable(self, "_f145").bind(_s300)
	var _t730 = J.gp(v_sc_636, "style")
	var _t731 = -1
	var _t732 = false
	if _t731 == -1 and J.seq(_t730, "chat"): _t731 = 0
	if _t731 == -1 and J.seq(_t730, "sys"): _t731 = 1
	if _t731 == -1 and J.seq(_t730, "news"): _t731 = 2
	if _t731 == -1 and J.seq(_t730, "notice"): _t731 = 3
	if _t731 == -1 and J.seq(_t730, "radio"): _t731 = 4
	if _t731 == -1 and J.seq(_t730, "report"): _t731 = 5
	if _t731 == -1 and J.seq(_t730, "mail"): _t731 = 6
	if _t731 == -1 and J.seq(_t730, "letter"): _t731 = 7
	if _t731 == -1 and J.seq(_t730, "narr"): _t731 = 8
	if _t731 == -1: _t731 = 9
	while true:
		if _t731 <= 0 and _t731 >= 0:
			J.mc(_s300["this"], "chatLine", [v_who_637, _s300["text"], v_time_641])
			break
		if _t731 <= 1 and _t731 >= 0:
			v_d_652 = J.cl(v_add_643, null, [J.mc(v_box_639, "querySelector", [".sys-body"]), ("sl " + ("s" if J.seq(v_who_637, "系統") else ("n" if J.seq(v_who_637, "旁白") else "u"))), (("<b>【系統】</b>" if J.seq(v_who_637, "系統") else ("" if J.seq(v_who_637, "旁白") else ("<b>" + J.str(v_who_637) + "：</b>"))) + "<span class=\"tt\"></span>")])
			J.cl(v_typeInto_642, null, [J.mc(v_d_652, "querySelector", [".tt"])])
			break
		if _t731 <= 2 and _t731 >= 0:
			v_s_653 = J.mc(v_box_639, "querySelector", [".tv-sub"])
			var _t733 = "<span class=\"tt\"></span>"
			J.sp(v_s_653, "innerHTML", _t733)
			J.mc(_s300["this"], "drawAnchor", [])
			J.cl(v_typeInto_642, null, [J.mc(v_s_653, "querySelector", [".tt"])])
			break
		if _t731 <= 3 and _t731 >= 0:
			v_d_654 = J.cl(v_add_643, null, [J.mc(v_box_639, "querySelector", [".nt-body"]), "np", "<span class=\"tt\"></span>"])
			J.cl(v_typeInto_642, null, [J.mc(v_d_654, "querySelector", [".tt"])])
			break
		if _t731 <= 4 and _t731 >= 0:
			v_d_655 = J.cl(v_add_643, null, [J.mc(v_box_639, "querySelector", [".rd-body"]), ("rl " + ("dj" if J.seq(v_who_637, "DJ") else "call")), ("<b>" + ("DJ" if J.seq(v_who_637, "DJ") else J.add("來電・", v_who_637)) + "</b><span class=\"tt\"></span>")])
			J.cl(v_typeInto_642, null, [J.mc(v_d_655, "querySelector", [".tt"])])
			break
		if _t731 <= 5 and _t731 >= 0:
			v_d_656 = J.cl(v_add_643, null, [J.mc(v_box_639, "querySelector", [".tm-body"]), "tl", ("<b>[" + J.str(v_who_637) + "]</b> <span class=\"tt\"></span>")])
			J.cl(v_typeInto_642, null, [J.mc(v_d_656, "querySelector", [".tt"])])
			break
		if _t731 <= 6 and _t731 >= 0:
			v_d_657 = J.cl(v_add_643, null, [J.mc(v_box_639, "querySelector", [".ml-body"]), ("mr " + ("content" if J.seq(v_who_637, "內文") else "")), ("<b>" + J.str(v_who_637) + "</b><span class=\"tt\"></span>")])
			J.cl(v_typeInto_642, null, [J.mc(v_d_657, "querySelector", [".tt"])])
			break
		if _t731 <= 7 and _t731 >= 0:
			v_d_658 = J.cl(v_add_643, null, [J.mc(v_box_639, "querySelector", [".letter-body"]), ("lt-mom" if J.seq(v_who_637, "媽") else ("lt-n" if J.seq(v_who_637, "旁白") else "lt-u")), (("<b>阿福：</b>" if J.seq(v_who_637, "阿福") else "") + "<span class=\"tt\"></span>")])
			J.cl(v_typeInto_642, null, [J.mc(v_d_658, "querySelector", [".tt"])])
			break
		if _t731 <= 8 and _t731 >= 0:
			v_d_659 = J.cl(v_add_643, null, [J.mc(v_box_639, "querySelector", [".narr-body"]), "nl", "<span class=\"tt\"></span>"])
			J.cl(v_typeInto_642, null, [J.mc(v_d_659, "querySelector", [".tt"])])
			break
		if _t731 <= 9 and _t731 >= 0:
			v_nm_660 = J.mc(v_box_639, "querySelector", [".nm"])
			v_tx_661 = J.mc(v_box_639, "querySelector", [".tx"])
			v_pt_662 = J.mc(v_box_639, "querySelector", ["canvas.pt"])
			var _t734 = ("" if J.seq(v_who_637, "旁白") else v_who_637)
			J.sp(v_nm_660, "textContent", _t734)
			var _t735 = J.gp(v_nm_660, "style")
			var _t736 = ("none" if J.seq(v_who_637, "旁白") else "")
			J.sp(_t735, "display", _t736)
			v_pc_663 = J.mc(v_pt_662, "getContext", ["2d"])
			J.mc(v_pc_663, "clearRect", [0.0, 0.0, 120.0, 120.0])
			v_art_664 = ("sys" if J.seq(v_who_637, "系統") else J.gp(J.G.get("SPEAKER_ART"), v_who_637))
			if J.seq(v_art_664, "sys"):
				J.mc(v_pc_663, "drawImage", [J.mc(J.G.get("ART"), "sysIcon", [120.0]), 0.0, 0.0, 120.0, 120.0])
			else:
				if J.t(v_art_664):
					var _t737 = J.gp(J.gp(_s300["this"], "cur"), "id")
					v_sid_665 = (_t737 if J.t(_t737) else "")
					J.mc(v_pc_663, "drawImage", [J.mc(J.G.get("ART"), "portrait", [v_art_664, 120.0, {"tamed": (not J.seq(v_sid_665, "ch4_boss")), "untied": (not J.seq(v_sid_665, "ch5_intro2"))}]), 0.0, 0.0, 120.0, 120.0])
			var _t738 = J.gp(v_pt_662, "style")
			var _t739 = ("" if J.t(v_art_664) else "none")
			J.sp(_t738, "display", _t739)
			var _t740 = J.gp(v_tx_661, "classList")
			J.mc(_t740, "toggle", ["narr", J.seq(v_who_637, "旁白")])
			J.mc(_s300["this"], "drawStage", [])
			J.cl(v_typeInto_642, null, [v_tx_661])
		break

func _f146(this_, a: Array, env):
	var v_c_668 = null; var v_ctx_669 = null
	var _t741 = J.G.get("$")
	v_c_668 = J.cl(_t741, null, ["#dlg canvas.anchor"])
	if (not J.t(v_c_668)):
		return null
	v_ctx_669 = J.mc(v_c_668, "getContext", ["2d"])
	J.mc(v_ctx_669, "clearRect", [0.0, 0.0, 160.0, 160.0])
	J.mc(J.G.get("ART"), "drawChar", [v_ctx_669, "mamian", 80.0, 168.0, 2.3, {"t": 0.2, "shadow": false}])
	J.mc(J.G.get("ART"), "rr", [v_ctx_669, 10.0, 130.0, 140.0, 30.0, 4.0, "#26304a", "#4a5a8a", 2.0])

func _f148(this_, a: Array, env):
	var v_cls_683 = null; var v_html_684 = null; var v_d_685 = null
	v_cls_683 = J.arg(a, 0)
	v_html_684 = J.arg(a, 1)
	v_d_685 = J.S_document_("createElement", ["div"])
	J.sp(v_d_685, "className", v_cls_683)
	J.sp(v_d_685, "innerHTML", v_html_684)
	J.mc(env["body"], "appendChild", [v_d_685])
	var _t743 = env["body"]
	var _t744 = J.gp(env["body"], "scrollHeight")
	J.sp(_t743, "scrollTop", _t744)
	return v_d_685

func _f149(this_, a: Array, env):
	var _t745 = env["this"]
	J.sp(_t745, "chatT", null)
	var _t746 = env["this"]
	J.sp(_t746, "li", J.num(J.gp(_t746, "li")) + 1.0)
	if J.cmp(J.gp(env["this"], "li"), J.len(J.gp(env["sc"], "lines")), ">="):
		J.mc(env["this"], "chatEnd", [])
		return null
	J.mc(env["this"], "showLine", [])

func _f150(this_, a: Array, env):
	env["i"] = J.num(env["i"]) + 1.0
	var _t750 = env["txt"]
	var _t751 = J.mc(env["__p"]["text"], "slice", [0.0, env["i"]])
	J.sp(_t750, "textContent", _t751)
	J.mc(J.G.get("Sound"), "play", ["key"])
	if J.cmp(env["i"], J.len(env["__p"]["text"]), "<"):
		var _t752 = env["__p"]["this"]
		var _t753 = J.F_setTimeout([env["step"], 55.0])
		J.sp(_t752, "chatT", _t753)
	else:
		var _t754 = env["__p"]["this"]
		J.sp(_t754, "chatT", null)
		var _t755 = env["btn"]
		var _t756 = J.gp(J.G.get("ICON"), "send")
		J.sp(_t755, "innerHTML", _t756)
		var _t757 = J.gp(env["btn"], "classList")
		J.mc(_t757, "add", ["await"])
		var _t758 = env["__p"]["this"]
		J.sp(_t758, "chatWait", "send")

func _f151(this_, a: Array, env):
	J.F_clearTimeout([J.gp(env["__p"]["this"], "chatT")])
	var _t760 = env["txt"]
	var _t761 = env["__p"]["text"]
	J.sp(_t760, "textContent", _t761)
	var _t762 = env["btn"]
	var _t763 = J.gp(J.G.get("ICON"), "send")
	J.sp(_t762, "innerHTML", _t763)
	var _t764 = J.gp(env["btn"], "classList")
	J.mc(_t764, "add", ["await"])
	var _t765 = env["__p"]["this"]
	J.sp(_t765, "chatWait", "send")
	var _t766 = env["__p"]["this"]
	J.sp(_t766, "chatT", null)

func _f153(this_, a: Array, env):
	var _t782 = J.mc(env["d"], "querySelector", [".tk"])
	var _t783 = J.G.get("TICK")
	var _t784 = J.cl(_t783, null, [false, true])
	J.sp(_t782, "outerHTML", _t784)
	var _t785 = env["__p"]["__p"]["this"]
	var _t786 = J.F_setTimeout([env["__p"]["__p"]["nextLine"], 650.0])
	J.sp(_t785, "chatT", _t786)

func _f152(this_, a: Array, env):
	var _s329 = {"__p": env, "d": null}
	var _t769 = _s329["__p"]["__p"]["this"]
	J.sp(_t769, "chatWait", null)
	var _t770 = J.gp(_s329["__p"]["btn"], "classList")
	J.mc(_t770, "remove", ["await"])
	var _t771 = _s329["__p"]["btn"]
	var _t772 = J.gp(J.G.get("ICON"), "mic")
	J.sp(_t771, "innerHTML", _t772)
	var _t773 = J.gp(_s329["__p"]["field"], "classList")
	J.mc(_t773, "remove", ["typing"])
	var _t774 = _s329["__p"]["txt"]
	J.sp(_t774, "textContent", "輸入訊息")
	J.mc(J.G.get("Sound"), "play", ["waOut"])
	var _t775 = _s329["__p"]["__p"]["add"]
	var _t777 = _s329["__p"]["__p"]["text"]
	var _t778 = _s329["__p"]["__p"]["tm"]
	var _t776 = J.G.get("TICK")
	_s329["d"] = J.cl(_t775, null, ["bub me pop", ("<span>" + J.str(_t777) + "</span><i>" + J.str(_t778) + " " + J.str(J.cl(_t776, null, [false, false])) + "</i>")])
	var _t779 = _s329["__p"]["__p"]["this"]
	var _t780 = _s329["d"]
	J.sp(_t779, "lastMine", _t780)
	var _t781 = _s329["__p"]["__p"]["this"]
	var _t787 = J.F_setTimeout([Callable(self, "_f153").bind(_s329), 600.0])
	J.sp(_t781, "chatT", _t787)

func _f154(this_, a: Array, env):
	J.F_clearTimeout([J.gp(env["this"], "chatT")])
	J.cl(env["nextLine"], null, [])

func _f156(this_, a: Array, env):
	var v_t_692 = null
	v_t_692 = J.arg(a, 0)
	var _t803 = J.G.get("TICK")
	var _t804 = J.cl(_t803, null, [true, true])
	J.sp(v_t_692, "outerHTML", _t804)
	return _t804

func _f157(this_, a: Array, env):
	J.F_clearTimeout([J.gp(env["this"], "chatT")])
	J.cl(env["nextLine"], null, [])

func _f155(this_, a: Array, env):
	var _t796 = env["this"]
	J.sp(_t796, "chatT", null)
	var _t797 = env["sub"]
	var _t798 = J.gp(env["sc"], "group")
	var _t799 = (_t798 if J.t(_t798) else "在線上")
	J.sp(_t797, "textContent", _t799)
	var _t800 = J.gp(env["sub"], "classList")
	J.mc(_t800, "remove", ["typing"])
	if J.t(J.gp(env["this"], "lastMine")):
		var _t801 = J.gp(env["this"], "lastMine")
		var _t802 = J.mc(_t801, "querySelectorAll", [".tk"])
		J.mc(_t802, "forEach", [Callable(self, "_f156").bind(env)])
		var _t805 = env["this"]
		J.sp(_t805, "lastMine", null)
	var _t806 = env["add"]
	J.cl(_t806, null, ["bub them pop", ((("<b class=\"nm\">" + J.str(env["who"]) + "</b>") if J.t(J.gp(env["sc"], "group")) else "") + ("<span>" + J.str(env["text"]) + "</span><i>" + J.str(env["tm"]) + "</i>"))])
	J.mc(J.G.get("Sound"), "play", ["waIn"])
	var _t807 = env["this"]
	var _t808 = J.F_setTimeout([env["nextLine"], J.min_([1800.0, (700.0 + (J.len(env["text"]) * 22.0))])])
	J.sp(_t807, "chatT", _t808)
	var _t809 = env["this"]
	var _t810 = Callable(self, "_f157").bind(env)
	J.sp(_t809, "chatFast", _t810)

func _f158(this_, a: Array, env):
	J.F_clearTimeout([J.gp(env["this"], "chatT")])
	J.cl(env["arrive"], null, [])

func _f147(this_, a: Array, env):
	var v_time_674 = null; var v_box_675 = null
	var _s321 = {"__p": env, "this": null, "who": null, "text": null, "sc": null, "body": null, "sub": null, "add": null, "nextLine": null, "tm": null, "arrive": null}
	_s321["this"] = this_
	_s321["who"] = J.arg(a, 0)
	_s321["text"] = J.arg(a, 1)
	v_time_674 = J.arg(a, 2)
	var _t742 = J.G.get("$")
	v_box_675 = J.cl(_t742, null, ["#dlg"])
	_s321["sc"] = J.gp(J.gp(_s321["this"], "cur"), "sc")
	_s321["body"] = J.mc(v_box_675, "querySelector", [".wa-body"])
	_s321["sub"] = J.mc(v_box_675, "querySelector", [".wa-sub"])
	_s321["add"] = Callable(self, "_f148").bind(_s321)
	_s321["nextLine"] = Callable(self, "_f149").bind(_s321)
	_s321["tm"] = (v_time_674 if J.t(v_time_674) else J.cl(J.G.get("nowHM"), null, []))
	var _t747 = _s321["this"]
	J.sp(_t747, "chatWait", null)
	J.F_clearTimeout([J.gp(_s321["this"], "chatT")])
	if J.seq(_s321["who"], "阿福"):
		var _s325 = {"__p": _s321, "field": null, "txt": null, "btn": null, "i": null, "step": null}
		_s325["field"] = J.mc(v_box_675, "querySelector", [".wa-field"])
		_s325["txt"] = J.mc(_s325["field"], "querySelector", [".wa-txt"])
		_s325["btn"] = J.mc(v_box_675, "querySelector", [".wa-send"])
		_s325["i"] = 0.0
		var _t748 = J.gp(_s325["field"], "classList")
		J.mc(_t748, "add", ["typing"])
		var _t749 = _s325["txt"]
		J.sp(_t749, "textContent", "")
		_s325["step"] = Callable(self, "_f150").bind(_s325)
		var _t759 = _s325["__p"]["this"]
		var _t767 = Callable(self, "_f151").bind(_s325)
		J.sp(_t759, "chatFast", _t767)
		var _t768 = _s325["__p"]["this"]
		var _t788 = Callable(self, "_f152").bind(_s325)
		J.sp(_t768, "chatSend", _t788)
		var _t789 = _s325["__p"]["this"]
		var _t790 = J.F_setTimeout([_s325["step"], 350.0])
		J.sp(_t789, "chatT", _t790)
		return null
	if J.seq(_s321["who"], "旁白"):
		var _t791 = _s321["add"]
		J.cl(_t791, null, ["bub mid pop", _s321["text"]])
		var _t792 = _s321["this"]
		var _t793 = J.F_setTimeout([_s321["nextLine"], 1300.0])
		J.sp(_t792, "chatT", _t793)
		var _t794 = _s321["this"]
		var _t795 = Callable(self, "_f154").bind(_s321)
		J.sp(_t794, "chatFast", _t795)
		return null
	_s321["arrive"] = Callable(self, "_f155").bind(_s321)
	if J.seq(J.gp(_s321["this"], "li"), 0.0):
		J.cl(_s321["arrive"], null, [])
		return null
	var _t811 = _s321["sub"]
	var _t812 = ((J.str(_s321["who"]) + " 正在輸入…") if J.t(J.gp(_s321["sc"], "group")) else "正在輸入…")
	J.sp(_t811, "textContent", _t812)
	var _t813 = J.gp(_s321["sub"], "classList")
	J.mc(_t813, "add", ["typing"])
	var _t814 = _s321["this"]
	var _t815 = J.F_setTimeout([_s321["arrive"], J.min_([1600.0, (450.0 + (J.len(_s321["text"]) * 30.0))])])
	J.sp(_t814, "chatT", _t815)
	var _t816 = _s321["this"]
	var _t817 = Callable(self, "_f158").bind(_s321)
	J.sp(_t816, "chatFast", _t817)

func _f161(this_, a: Array, env):
	var v_t_698 = null
	v_t_698 = J.arg(a, 0)
	var _t822 = J.G.get("TICK")
	var _t823 = J.cl(_t822, null, [true, true])
	J.sp(v_t_698, "outerHTML", _t823)
	return _t823

func _f160(this_, a: Array, env):
	var _t820 = J.gp(env["__p"]["this"], "lastMine")
	var _t821 = J.mc(_t820, "querySelectorAll", [".tk"])
	J.mc(_t821, "forEach", [Callable(self, "_f161").bind(env)])
	var _t824 = env["__p"]["this"]
	J.sp(_t824, "lastMine", null)
	var _t825 = env["sub"]
	J.sp(_t825, "textContent", "正在輸入…")
	var _t826 = J.gp(env["sub"], "classList")
	J.mc(_t826, "add", ["typing"])

func _f162(this_, a: Array, env):
	J.mc(J.G.get("Sound"), "play", ["heartbeat"])

func _f163(this_, a: Array, env):
	J.mc(J.G.get("Sound"), "play", ["heartbeat"])
	var _t828 = J.gp(J.mc(env["__p"]["box"], "querySelector", [".wa"]), "classList")
	J.mc(_t828, "add", ["crash"])

func _f164(this_, a: Array, env):
	J.mc(J.G.get("Sound"), "play", ["flatline"])
	var _t829 = J.gp(J.mc(env["__p"]["box"], "querySelector", [".wa"]), "classList")
	J.mc(_t829, "add", ["dead"])

func _f165(this_, a: Array, env):
	return J.mc(env["__p"]["this"], "next", [])

func _f159(this_, a: Array, env):
	var v_sc_696 = null
	var _s339 = {"__p": env, "this": null, "box": null}
	_s339["this"] = this_
	var _t818 = J.G.get("$")
	_s339["box"] = J.cl(_t818, null, ["#dlg"])
	v_sc_696 = J.gp(J.gp(_s339["this"], "cur"), "sc")
	if J.seq(J.gp(v_sc_696, "end"), "crash"):
		var _s340 = {"__p": _s339, "sub": null}
		_s340["sub"] = J.mc(_s340["__p"]["box"], "querySelector", [".wa-sub"])
		if J.t(J.gp(_s340["__p"]["this"], "lastMine")):
			var _t819 = _s340["__p"]["this"]
			var _t827 = J.F_setTimeout([Callable(self, "_f160").bind(_s340), 900.0])
			J.sp(_t819, "chatT", _t827)
		J.F_setTimeout([Callable(self, "_f162").bind(_s340), 2200.0])
		J.F_setTimeout([Callable(self, "_f163").bind(_s340), 3000.0])
		J.F_setTimeout([Callable(self, "_f164").bind(_s340), 3700.0])
		var _t830 = _s340["__p"]["this"]
		J.sp(_t830, "chatWait", "crash")
		var _t831 = _s340["__p"]["this"]
		var _t832 = J.F_setTimeout([Callable(self, "_f165").bind(_s340), 7200.0])
		J.sp(_t831, "chatT", _t832)
		return null
	var _t833 = _s339["this"]
	J.sp(_t833, "chatWait", "end")
	var _t834 = J.gp(J.mc(_s339["box"], "querySelector", [".tap"]), "style")
	J.sp(_t834, "display", "")

func _f166(this_, a: Array, env):
	var v_e_701 = null; var v_b_702 = null; var v_f_703 = null
	v_e_701 = J.arg(a, 0)
	var _t835 = J.gp(this_, "cur")
	if J.t((J.seq(J.gp(J.gp(J.gp(this_, "cur"), "sc"), "style"), "chat") if J.t(_t835) else _t835)):
		if J.seq(J.gp(this_, "chatWait"), "crash"):
			return null
		if J.seq(J.gp(this_, "chatWait"), "end"):
			J.mc(this_, "next", [])
			return null
		if J.seq(J.gp(this_, "chatWait"), "send"):
			var _t837 = v_e_701
			if J.t(_t837):
				var _t836 = J.gp(v_e_701, "target")
				_t837 = J.mc(_t836, "closest", [".wa-input"])
			if J.t(_t837):
				J.mc(this_, "chatSend", [])
			else:
				var _t838 = J.G.get("$")
				v_b_702 = J.cl(_t838, null, ["#dlg .wa-send"])
				var _t839 = J.gp(v_b_702, "classList")
				J.mc(_t839, "remove", ["nudge"])
				J.nop(J.gp(v_b_702, "offsetWidth"))
				var _t840 = J.gp(v_b_702, "classList")
				J.mc(_t840, "add", ["nudge"])
			return null
		if J.t(J.gp(this_, "chatFast")):
			v_f_703 = J.gp(this_, "chatFast")
			var _t841 = this_
			J.sp(_t841, "chatFast", null)
			J.cl(v_f_703, null, [])
		return null
	if J.t(J.gp(this_, "typing")):
		J.mc(this_, "full", [])
		return null
	var _t842 = this_
	J.sp(_t842, "li", J.num(J.gp(_t842, "li")) + 1.0)
	if J.cmp(J.gp(this_, "li"), J.len(J.gp(J.gp(J.gp(this_, "cur"), "sc"), "lines")), ">="):
		J.mc(this_, "next", [])
		return null
	J.mc(this_, "showLine", [])

func _f167(this_, a: Array, env):
	J.F_clearInterval([J.gp(this_, "timer")])
	J.F_clearTimeout([J.gp(this_, "chatT")])
	var _t843 = this_
	J.sp(_t843, "chatWait", null)
	var _t844 = this_
	J.sp(_t844, "chatFast", null)
	var _t845 = this_
	J.sp(_t845, "lastMine", null)
	var _t846 = this_
	J.sp(_t846, "typing", false)
	J.mc(this_, "next", [])

func _f170(this_, a: Array, env):
	var _t847 = J.G.get("$")
	var _t848 = J.gp(J.cl(_t847, null, ["#sheet"]), "classList")
	var _t851 = J.mc(_t848, "contains", ["on"])
	if not J.t(_t851):
		var _t849 = J.G.get("$")
		var _t850 = J.gp(J.cl(_t849, null, ["#battle"]), "classList")
		_t851 = J.mc(_t850, "contains", ["on"])
	return _t851

func _f172(this_, a: Array, env):
	var v_b_751 = null
	v_b_751 = J.arg(a, 0)
	var _t891 = J.gp(v_b_751, "classList")
	var _t895 = env["q"]
	if J.t(_t895):
		var _t892 = J.seq(J.gp(env["q"], "go"), "roster")
		var _t894 = (J.seq(J.gp(J.gp(v_b_751, "dataset"), "t"), "roster") if _t892 else _t892)
		if not J.t(_t894):
			var _t893 = J.seq(J.gp(env["q"], "go"), "gate")
			_t894 = (J.seq(J.gp(J.gp(v_b_751, "dataset"), "t"), "battle") if _t893 else _t893)
		_t895 = _t894
	return J.mc(_t891, "toggle", ["pulse", _t895])

func _f171(this_, a: Array, env):
	var v_need_742 = null; var v_cap_743 = null; var v_qb_745 = null; var v_ch_746 = null; var v_k_747 = null; var v_e_748 = null; var v_a_749 = null; var v_b_750 = null
	var _s380 = {"__p": env, "q": null}
	if (not J.t(J.G.get("S"))):
		return null
	var _t852 = J.G.get("$")
	var _t853 = J.cl(_t852, null, ["#lv"])
	var _t854 = J.gp(J.G.get("S"), "lv")
	J.sp(_t853, "textContent", _t854)
	v_need_742 = J.mc(J.G.get("F"), "expNeed", [J.gp(J.G.get("S"), "lv")])
	var _t855 = J.G.get("$")
	var _t856 = J.gp(J.cl(_t855, null, ["#expbar i"]), "style")
	var _t857 = J.add((100.0 if J.cmp(J.gp(J.G.get("S"), "lv"), 20.0, ">=") else J.min_([100.0, (J.div(J.gp(J.G.get("S"), "exp"), v_need_742) * 100.0)])), "%")
	J.sp(_t856, "width", _t857)
	var _t858 = J.G.get("$")
	var _t859 = J.cl(_t858, null, ["#exptxt"])
	var _t863 = null
	if J.cmp(J.gp(J.G.get("S"), "lv"), 20.0, ">="):
		_t863 = "好評 MAX"
	else:
		var _t860 = J.G.get("fmt")
		var _t862 = J.cl(_t860, null, [J.gp(J.G.get("S"), "exp")])
		var _t861 = J.G.get("fmt")
		_t863 = ("好評 " + J.str(_t862) + "/" + J.str(J.cl(_t861, null, [v_need_742])))
	J.sp(_t859, "textContent", _t863)
	v_cap_743 = J.mc(J.G.get("F"), "cap", [])
	for _t864 in J.iter(["wood", "rice", "planks", "buns"]):
		v_k_747 = _t864
		var _t865 = J.G.get("$")
		v_e_748 = J.cl(_t865, null, [J.add("#r-", v_k_747)])
		var _t866 = J.G.get("fmt")
		var _t867 = J.cl(_t866, null, [J.gp(J.gp(J.G.get("S"), "res"), v_k_747)])
		J.sp(v_e_748, "textContent", _t867)
		var _t868 = J.gp(J.gp(v_e_748, "parentElement"), "classList")
		J.mc(_t868, "toggle", ["full", J.cmp(J.gp(J.gp(J.G.get("S"), "res"), v_k_747), J.sub(v_cap_743, 0.5), ">=")])
	var _t869 = J.G.get("$")
	var _t870 = J.cl(_t869, null, ["#r-coins"])
	var _t871 = J.G.get("fmt")
	var _t872 = J.cl(_t871, null, [J.gp(J.gp(J.G.get("S"), "res"), "coins")])
	J.sp(_t870, "textContent", _t872)
	var _t873 = J.G.get("$")
	var _t874 = J.cl(_t873, null, ["#r-troops"])
	var _t875 = J.G.get("fmt")
	var _t876 = J.cl(_t875, null, [J.gp(J.gp(J.G.get("S"), "res"), "troops")])
	J.sp(_t874, "textContent", _t876)
	_s380["q"] = J.mc(J.G.get("Quest"), "cur", [])
	var _t877 = J.G.get("$")
	v_qb_745 = J.cl(_t877, null, ["#quest"])
	if J.t(_s380["q"]):
		var _t878 = J.mc(J.G.get("Quest"), "progress", [_s380["q"]])
		var _t879 = J.gp(_t878, 0.0)
		v_a_749 = _t879
		var _t880 = J.gp(_t878, 1.0)
		v_b_750 = _t880
		var _t881 = ("<b>主線</b><span>" + J.str(J.gp(_s380["q"], "text")) + "</span><em>" + J.str(J.min_([v_a_749, v_b_750])) + "/" + J.str(v_b_750) + "</em>")
		J.sp(v_qb_745, "innerHTML", _t881)
		var _t882 = J.gp(v_qb_745, "classList")
		J.mc(_t882, "toggle", ["done", J.cmp(v_a_749, v_b_750, ">=")])
	else:
		var _t883 = ("<b>主線</b><span>" + ("第一季完。村子由你慢慢經營。" if J.t(J.gp(J.G.get("S"), "ended")) else "—") + "</span>")
		J.sp(v_qb_745, "innerHTML", _t883)
	v_ch_746 = J.add(J.add(J.gp(J.gp(J.G.get("S"), "chests"), "g"), J.gp(J.gp(J.G.get("S"), "chests"), "b")), J.gp(J.gp(J.G.get("S"), "chests"), "p"))
	var _t884 = J.G.get("$")
	var _t885 = J.cl(_t884, null, ["#nav [data-t=chest] i"])
	var _t886 = (v_ch_746 if J.t(v_ch_746) else "")
	J.sp(_t885, "textContent", _t886)
	var _t887 = J.G.get("$")
	var _t888 = J.gp(J.cl(_t887, null, ["#nav [data-t=chest] i"]), "style")
	var _t889 = ("" if J.t(v_ch_746) else "none")
	J.sp(_t888, "display", _t889)
	var _t890 = J.S_document_("querySelectorAll", ["#nav button"])
	J.mc(_t890, "forEach", [Callable(self, "_f172").bind(_s380)])
	var _t898 = J.gp(this_, "sheetRefresh")
	if J.t(_t898):
		var _t896 = J.G.get("$")
		var _t897 = J.gp(J.cl(_t896, null, ["#sheet"]), "classList")
		_t898 = J.mc(_t897, "contains", ["on"])
	if J.t(_t898):
		J.mc(this_, "sheetRefresh", [])

func _f174(this_, a: Array, env):
	var v_b_755 = null
	v_b_755 = J.arg(a, 0)
	var _t900 = J.gp(v_b_755, "classList")
	return J.mc(_t900, "toggle", ["on", J.seq(J.gp(J.gp(v_b_755, "dataset"), "t"), env["t"])])

func _f173(this_, a: Array, env):
	var _s385 = {"__p": env, "t": null}
	_s385["t"] = J.arg(a, 0)
	if J.seq(_s385["t"], "village"):
		J.mc(this_, "close", [])
		return null
	if J.seq(_s385["t"], "roster"):
		J.mc(this_, "openRoster", [])
	if J.seq(_s385["t"], "battle"):
		J.mc(this_, "openBattleSelect", [])
	if J.seq(_s385["t"], "chest"):
		J.mc(this_, "openChests", [])
	if J.seq(_s385["t"], "story"):
		J.mc(this_, "openStory", [])
	var _t899 = J.S_document_("querySelectorAll", ["#nav button"])
	J.mc(_t899, "forEach", [Callable(self, "_f174").bind(_s385)])

func _f175(this_, a: Array, env):
	var v_title_758 = null; var v_html_759 = null; var v_refresher_760 = null; var v_sh_761 = null
	v_title_758 = J.arg(a, 0)
	v_html_759 = J.arg(a, 1)
	v_refresher_760 = J.arg(a, 2)
	var _t901 = J.G.get("$")
	v_sh_761 = J.cl(_t901, null, ["#sheet"])
	var _t902 = J.gp(v_sh_761, "classList")
	J.mc(_t902, "add", ["on"])
	var _t903 = J.gp(v_sh_761, "classList")
	if (not J.t(J.mc(_t903, "contains", ["was"]))):
		J.mc(J.G.get("Sound"), "play", ["paper"])
	var _t904 = J.gp(v_sh_761, "classList")
	J.mc(_t904, "add", ["was"])
	var _t905 = J.mc(v_sh_761, "querySelector", [".sh-title"])
	J.sp(_t905, "textContent", v_title_758)
	var _t906 = J.mc(v_sh_761, "querySelector", [".sh-body"])
	J.sp(_t906, "innerHTML", v_html_759)
	var _t907 = this_
	var _t908 = (v_refresher_760 if J.t(v_refresher_760) else null)
	J.sp(_t907, "sheetRefresh", _t908)

func _f177(this_, a: Array, env):
	var v_b_764 = null
	v_b_764 = J.arg(a, 0)
	var _t913 = J.gp(v_b_764, "classList")
	return J.mc(_t913, "toggle", ["on", J.seq(J.gp(J.gp(v_b_764, "dataset"), "t"), "village")])

func _f176(this_, a: Array, env):
	var _t909 = J.G.get("$")
	var _t910 = J.gp(J.cl(_t909, null, ["#sheet"]), "classList")
	J.mc(_t910, "remove", ["on", "was"])
	var _t911 = this_
	J.sp(_t911, "sheetRefresh", null)
	var _t912 = J.S_document_("querySelectorAll", ["#nav button"])
	J.mc(_t912, "forEach", [Callable(self, "_f177").bind(env)])

func _f180(this_, a: Array, env):
	var v_k_781 = null
	v_k_781 = J.arg(a, 0)
	var _t940 = (not J.t(J.gp(J.gp(J.G.get("FODDER"), v_k_781), "unlock")))
	return (_t940 if _t940 else J.gp(J.gp(J.G.get("S"), "cleared"), J.gp(J.gp(J.G.get("FODDER"), v_k_781), "unlock")))

func _f181(this_, a: Array, env):
	var v_k_782 = null
	v_k_782 = J.arg(a, 0)
	return J.gp(J.gp(J.G.get("FODDER"), v_k_782), "name")

func _f182(this_, a: Array, env):
	var v_a_785 = null; var v_g_786 = null
	v_a_785 = J.arg(a, 0)
	v_g_786 = J.arg(a, 1)
	return J.add(v_a_785, J.mc(J.G.get("F"), "stat", [v_g_786, 1.0]))

func _f179(this_, a: Array, env):
	var v_b_771 = null; var v_lv_772 = null; var v_h_773 = null; var v_c_774 = null; var v_src_775 = null; var v_can_776 = null; var v_dis_777 = null; var v_left_778 = null; var v_c_779 = null; var v_pool_780 = null; var v_iq_783 = null; var v_left_784 = null; var v_p_787 = null
	v_b_771 = J.gp(J.G.get("BUILDINGS"), env["id"])
	v_lv_772 = J.gp(J.gp(J.G.get("S"), "bld"), env["id"])
	var _t914 = J.gp(J.G.get("FLAVOR"), env["id"])
	v_h_773 = ("<p class=\"flavor\">" + J.str((_t914 if J.t(_t914) else "")) + "</p><p class=\"desc\">" + J.str(J.gp(v_b_771, "desc")) + "</p>")
	if (not J.t(v_lv_772)):
		var _t915 = J.G.get("bldUnlocked")
		if (not J.t(J.cl(_t915, null, [env["id"]]))):
			var _t916 = J.add(v_h_773, ("<p class=\"lack\">尚未解鎖。</p>"))
			v_h_773 = _t916
		else:
			var _t917 = J.G.get("costText")
			var _t919 = J.cl(_t917, null, [J.gp(v_b_771, "build")])
			var _t918 = J.G.get("canPay")
			var _t920 = J.add(v_h_773, ("<div class=\"row\"><span>建造費用：" + J.str(_t919) + "</span><button class=\"btn gold\" data-act=\"build\" " + ("" if J.t(J.cl(_t918, null, [J.gp(v_b_771, "build")])) else "disabled") + ">建造</button></div>"))
			v_h_773 = _t920
	else:
		var _t921 = J.add(v_h_773, ("<div class=\"stat\">等級 <b>Lv " + J.str(v_lv_772) + "</b>" + (("（上限 = 鬼宅等級 " + J.str(J.gp(J.gp(J.G.get("S"), "bld"), "house")) + "）") if (not J.seq(env["id"], "house")) else "") + "</div>"))
		v_h_773 = _t921
		var _t922 = J.add(v_h_773, J.mc(env["this"], "bldEffect", [env["id"]]))
		v_h_773 = _t922
		if J.cmp(v_lv_772, J.mc(J.G.get("F"), "bldMax", [env["id"]]), "<"):
			v_c_774 = J.mc(J.G.get("F"), "upCost", [env["id"], v_lv_772])
			var _t923 = J.G.get("costText")
			var _t925 = J.cl(_t923, null, [v_c_774])
			var _t926 = (("<br><small>工頭省了 " + J.str(J.round(J.num(J.mul(J.mc(J.G.get("F"), "builderDiscount", []), 100.0)))) + "% 棺材板</small>") if J.t(J.mc(J.G.get("F"), "builderDiscount", [])) else "")
			var _t924 = J.G.get("canPay")
			var _t927 = J.add(v_h_773, ("<div class=\"row\"><span>升級：" + J.str(_t925) + _t926 + "</span><button class=\"btn gold\" data-act=\"up\" " + ("" if J.t(J.cl(_t924, null, [v_c_774])) else "disabled") + ">升級</button></div>"))
			v_h_773 = _t927
		else:
			var _t928 = J.add(v_h_773, ("<p class=\"desc\">" + ("已達最高等級。" if J.seq(env["id"], "house") else "已達上限，先升級鬼宅。") + "</p>"))
			v_h_773 = _t928
		var _t929 = J.seq(env["id"], "plank")
		if (_t929 if _t929 else J.seq(env["id"], "bun")):
			v_src_775 = ("wood" if J.seq(env["id"], "plank") else "rice")
			v_can_776 = floor(J.num(J.div(J.gp(J.gp(J.G.get("S"), "res"), v_src_775), 4.0)))
			v_dis_777 = ("disabled" if J.cmp(v_can_776, 1.0, "<") else "")
			var _t930 = J.add(v_h_773, ("<div class=\"row craft-row\"><span>親手做：每份 4 " + ("槐木 → 2 棺材板" if J.seq(env["id"], "plank") else "糯米 → 2 壽包") + "　好評 +1<br><small>現有" + J.str(J.gp(J.G.get("RES_NAMES"), v_src_775)) + " " + J.str(J.gp(J.gp(J.G.get("S"), "res"), v_src_775)) + "，夠做 " + J.str(v_can_776) + " 份</small></span><div class=\"craft-btns\"><button class=\"btn\" data-act=\"craft\" data-n=\"1\" " + J.str(v_dis_777) + ">做1份</button><button class=\"btn\" data-act=\"craft\" data-n=\"5\" " + J.str(v_dis_777) + ">一次做5份</button><button class=\"btn\" data-act=\"craft\" data-n=\"10\" " + J.str(v_dis_777) + ">一次做10份</button></div></div>"))
			v_h_773 = _t930
		if J.seq(env["id"], "furnace"):
			v_left_778 = J.max_([0.0, J.sub(J.gp(J.G.get("F"), "furnaceCD"), J.div(J.mul(J.sub(J.S_Date_("now", []), J.gp(J.G.get("S"), "furnaceAt")), J.G.get("TIME_SCALE")), 1000.0))])
			var _t931 = J.add(v_h_773, ("<div class=\"row\"><span>" + (("還要 " + J.str(ceil(J.num(J.div(v_left_778, 60.0)))) + " 分鐘") if J.cmp(v_left_778, 0.0, ">") else "爐火正旺！") + "　可燒出 冥幣 " + J.str(J.mc(J.G.get("F"), "furnaceCoins", [])) + "</span><button class=\"btn gold\" data-act=\"burn\" " + ("disabled" if J.cmp(v_left_778, 0.0, ">") else "") + ">燒</button></div>"))
			v_h_773 = _t931
		if J.seq(env["id"], "altar"):
			v_c_779 = J.mc(J.G.get("F"), "recruitCost", [])
			var _t932 = J.G.get("costText")
			var _t935 = J.cl(_t932, null, [v_c_779])
			var _t936 = J.cl(J.G.get("fodderCount"), null, [])
			var _t937 = J.mc(J.G.get("F"), "rosterCap", [])
			var _t933 = J.G.get("canPay")
			var _t934 = J.cl(_t933, null, [v_c_779])
			var _t938 = J.add(v_h_773, ("<div class=\"row\"><span>招魂一次：" + J.str(_t935) + "<br><small>雜鬼名額 " + J.str(_t936) + "/" + J.str(_t937) + "（升級民宅增加；收服的名鬼不佔名額）</small></span><button class=\"btn gold\" data-act=\"recruit\" " + ("" if J.t((J.cmp(J.cl(J.G.get("fodderCount"), null, []), J.mc(J.G.get("F"), "rosterCap", []), "<") if J.t(_t934) else _t934)) else "disabled") + ">招魂</button></div>"))
			v_h_773 = _t938
			var _t939 = J.S_Object_("keys", [J.G.get("FODDER")])
			var _t941 = J.mc(_t939, "filter", [Callable(self, "_f180").bind(env)])
			var _t942 = J.mc(_t941, "map", [Callable(self, "_f181").bind(env)])
			v_pool_780 = J.mc(_t942, "join", ["、"])
			var _t943 = J.add(v_h_773, ("<p class=\"desc\">目前可能招到：" + J.str(v_pool_780) + "。收服更多鬼怪後，招魂池會變大。</p>"))
			v_h_773 = _t943
		var _t944 = J.seq(env["id"], "house")
		if (J.cmp(J.gp(J.G.get("S"), "lv"), 12.0, ">=") if _t944 else _t944):
			var _t945 = J.gp(J.G.get("S"), "ghosts")
			v_iq_783 = J.mc(_t945, "reduce", [Callable(self, "_f182").bind(env), 0.0])
			v_left_784 = J.max_([0.0, J.sub(J.gp(J.G.get("F"), "feastCD"), J.div(J.mul(J.sub(J.S_Date_("now", []), J.gp(J.G.get("S"), "feastAt")), J.G.get("TIME_SCALE")), 1000.0))])
			var _t948 = J.gp(J.G.get("F"), "feastNeed")
			var _t949 = (("　冷卻 " + J.str(ceil(J.num(J.div(v_left_784, 60.0)))) + " 分") if J.cmp(v_left_784, 0.0, ">") else "")
			var _t946 = J.cmp(J.gp(J.gp(J.G.get("S"), "res"), "buns"), 300.0, ">=")
			var _t947 = (J.cmp(v_iq_783, J.gp(J.G.get("F"), "feastNeed"), ">=") if _t946 else _t946)
			var _t950 = J.add(v_h_773, ("<div class=\"row\"><span>盂蘭宴：壽包 300<br><small>全村智力總和 " + J.str(v_iq_783) + "/" + J.str(_t948) + _t949 + "</small></span><button class=\"btn gold\" data-act=\"feast\" " + ("" if (J.cmp(v_left_784, 0.0, "<=") if _t947 else _t947) else "disabled") + ">擺宴</button></div>"))
			v_h_773 = _t950
		for _t951 in J.iter(J.gp(v_b_771, "posts")):
			v_p_787 = _t951
			var _t952 = J.add(v_h_773, J.mc(env["this"], "postHtml", [v_p_787]))
			v_h_773 = _t952
	return v_h_773

func _f183(this_, a: Array, env):
	var _t953 = J.G.get("$")
	var _t954 = J.cl(_t953, null, ["#sheet .sh-body"])
	var _t955 = J.cl(env["render"], null, [])
	J.sp(_t954, "innerHTML", _t955)
	J.cl(env["bind"], null, [])

func _f186(this_, a: Array, env):
	var v_a_789 = null; var v_c_790 = null; var v_c_791 = null; var v_g_792 = null; var v_g_793 = null; var v_g_794 = null
	v_a_789 = J.gp(J.gp(env["btn"], "dataset"), "act")
	if J.seq(v_a_789, "build"):
		J.mc(J.G.get("Sound"), "play", ["build"])
		var _t960 = J.G.get("pay")
		J.cl(_t960, null, [J.gp(J.gp(J.G.get("BUILDINGS"), env["__p"]["id"]), "build")])
		var _t961 = J.gp(J.G.get("S"), "bld")
		var _t962 = env["__p"]["id"]
		J.sp(_t961, _t962, 1.0)
		var _t963 = J.G.get("gainExp")
		J.cl(_t963, null, [15.0])
		J.mc(J.G.get("Fx"), "banner", [(J.str(J.gp(J.gp(J.G.get("BUILDINGS"), env["__p"]["id"]), "name")) + " 建好了！")])
		J.mc(J.G.get("Quest"), "check", [])
	if J.seq(v_a_789, "up"):
		J.mc(J.G.get("Sound"), "play", ["build"])
		v_c_790 = J.mc(J.G.get("F"), "upCost", [env["__p"]["id"], J.gp(J.gp(J.G.get("S"), "bld"), env["__p"]["id"])])
		var _t964 = J.G.get("pay")
		J.cl(_t964, null, [v_c_790])
		var _t965 = J.gp(J.G.get("S"), "bld")
		var _t966 = env["__p"]["id"]
		J.sp(_t965, _t966, J.num(J.gp(_t965, _t966)) + 1.0)
		var _t967 = J.G.get("gainExp")
		J.cl(_t967, null, [(10.0 + J.mul(8.0, J.gp(J.gp(J.G.get("S"), "bld"), env["__p"]["id"])))])
		J.mc(J.G.get("Fx"), "banner", [(J.str(J.gp(J.gp(J.G.get("BUILDINGS"), env["__p"]["id"]), "name")) + " 升到 Lv " + J.str(J.gp(J.gp(J.G.get("S"), "bld"), env["__p"]["id"])))])
		J.mc(J.G.get("Quest"), "check", [])
	if J.seq(v_a_789, "craft"):
		J.mc(env["__p"]["this"], "close", [])
		var _t969 = env["__p"]["id"]
		var _t968 = J.num(J.gp(J.gp(env["btn"], "dataset"), "n"))
		J.mc(J.G.get("Village"), "craft", [_t969, (_t968 if J.t(_t968) else 1.0)])
		return null
	if J.seq(v_a_789, "burn"):
		if (not J.t(J.cl(J.G.get("furnaceReady"), null, []))):
			return null
		J.mc(J.G.get("Sound"), "play", ["coin"])
		J.mc(J.G.get("JossFx"), "play", [])
		var _t970 = J.G.get("S")
		var _t971 = J.S_Date_("now", [])
		J.sp(_t970, "furnaceAt", _t971)
		v_c_791 = J.mc(J.G.get("F"), "furnaceCoins", [])
		var _t972 = J.gp(J.G.get("S"), "res")
		var _t973 = J.add(J.gp(_t972, "coins"), v_c_791)
		J.sp(_t972, "coins", _t973)
		J.mc(J.G.get("Fx"), "toast", [("化寶爐燒出 <b>冥幣 " + J.str(v_c_791) + "</b>")])
	if J.seq(v_a_789, "recruit"):
		J.mc(J.G.get("Sound"), "play", ["whoosh"])
		var _t974 = J.G.get("pay")
		J.cl(_t974, null, [J.mc(J.G.get("F"), "recruitCost", [])])
		var _t975 = J.G.get("recruitFodder")
		v_g_792 = J.cl(_t975, null, [false])
		var _t976 = J.gp(J.G.get("S"), "cnt")
		J.sp(_t976, "recruit", J.num(J.gp(_t976, "recruit")) + 1.0)
		J.mc(J.G.get("Fx"), "toast", [("招來了 <b>" + J.str(J.gp(v_g_792, "name")) + "</b>（" + J.str(J.gp(v_g_792, "q")) + "）")])
		J.mc(J.G.get("Quest"), "check", [])
	if J.seq(v_a_789, "feast"):
		J.mc(J.G.get("Sound"), "play", ["gong"])
		var _t977 = J.gp(J.G.get("S"), "res")
		var _t978 = J.sub(J.gp(_t977, "buns"), 300.0)
		J.sp(_t977, "buns", _t978)
		var _t979 = J.G.get("S")
		var _t980 = J.S_Date_("now", [])
		J.sp(_t979, "feastAt", _t980)
		var _t981 = J.gp(J.G.get("S"), "cnt")
		J.sp(_t981, "feast", J.num(J.gp(_t981, "feast")) + 1.0)
		var _t982 = J.G.get("gainExp")
		J.cl(_t982, null, [150.0])
		if J.cmp(J.cl(J.G.get("fodderCount"), null, []), J.mc(J.G.get("F"), "rosterCap", []), "<"):
			var _t983 = J.G.get("recruitFodder")
			v_g_793 = J.cl(_t983, null, [true])
			J.mc(J.G.get("Fx"), "toast", [("盂蘭宴請來了稀客 <b>" + J.str(J.gp(v_g_793, "name")) + "</b>（紫）！好評 +150")])
		else:
			var _t984 = J.gp(J.G.get("S"), "chests")
			J.sp(_t984, "p", J.num(J.gp(_t984, "p")) + 1.0)
			J.mc(J.G.get("Fx"), "toast", ["盂蘭宴賓客滿座，可惜村裡住不下了。客人留下一個<b>紫箱</b>就走了。好評 +150"])
		J.mc(J.G.get("Quest"), "check", [])
	if J.seq(v_a_789, "assign"):
		J.mc(env["__p"]["this"], "pickWorker", [J.gp(J.gp(env["btn"], "dataset"), "post"), env["__p"]["id"]])
		return null
	if J.seq(v_a_789, "unassign"):
		var _t985 = J.G.get("ghostById")
		v_g_794 = J.cl(_t985, null, [J.gp(J.gp(env["btn"], "dataset"), "g")])
		if J.t(v_g_794):
			J.sp(v_g_794, "post", null)
	J.cl(J.G.get("save"), null, [])
	J.mc(J.G.get("UI"), "refresh", [])
	J.cl(env["__p"]["re"], null, [])

func _f185(this_, a: Array, env):
	var _s407 = {"__p": env, "btn": null}
	_s407["btn"] = J.arg(a, 0)
	var _t959 = _s407["btn"]
	var _t986 = Callable(self, "_f186").bind(_s407)
	J.sp(_t959, "onclick", _t986)
	return _t986

func _f184(this_, a: Array, env):
	var _t956 = J.G.get("$")
	var _t957 = J.cl(_t956, null, ["#sheet .sh-body"])
	var _t958 = J.mc(_t957, "querySelectorAll", ["[data-act]"])
	J.mc(_t958, "forEach", [Callable(self, "_f185").bind(env)])

func _f187(this_, a: Array, env):
	var v_sc_795 = null
	var _t988 = (not J.t(J.gp(J.G.get("document"), "activeElement")))
	var _t990 = (_t988 if _t988 else (not J.t(J.gp(J.gp(J.G.get("document"), "activeElement"), "closest"))))
	if not J.t(_t990):
		var _t989 = J.gp(J.G.get("document"), "activeElement")
		_t990 = (not J.t(J.mc(_t989, "closest", ["#sheet"])))
	if _t990:
		var _t991 = J.G.get("$")
		v_sc_795 = J.gp(J.cl(_t991, null, ["#sheet .sh-body"]), "scrollTop")
		J.cl(env["re"], null, [])
		var _t992 = J.G.get("$")
		var _t993 = J.cl(_t992, null, ["#sheet .sh-body"])
		J.sp(_t993, "scrollTop", v_sc_795)

func _f178(this_, a: Array, env):
	var _s391 = {"__p": env, "this": null, "id": null, "render": null, "re": null, "bind": null}
	_s391["this"] = this_
	_s391["id"] = J.arg(a, 0)
	_s391["render"] = Callable(self, "_f179").bind(_s391)
	_s391["re"] = Callable(self, "_f183").bind(_s391)
	_s391["bind"] = Callable(self, "_f184").bind(_s391)
	J.mc(_s391["this"], "sheet", [J.gp(J.gp(J.G.get("BUILDINGS"), _s391["id"]), "name"), J.cl(_s391["render"], null, []), null])
	J.cl(_s391["bind"], null, [])
	var _t987 = _s391["this"]
	var _t994 = Callable(self, "_f187").bind(_s391)
	J.sp(_t987, "sheetRefresh", _t994)

func _f189(this_, a: Array, env):
	var v_a_801 = null
	v_a_801 = J.arg(a, 0)
	return ("<div class=\"eff\">" + J.str(v_a_801) + "</div>")

func _f190(this_, a: Array, env):
	var v_g_803 = null; var v_lv_804 = null; var v_nx_805 = null
	v_g_803 = J.arg(a, 0)
	v_lv_804 = J.mc(J.G.get("Rework"), "drillLv", [J.gp(v_g_803, "k")])
	v_nx_805 = J.mc(J.G.get("Rework"), "drillNext", [J.gp(v_g_803, "k")])
	return (J.str(J.gp(v_g_803, "name")) + " 嚇功 Lv" + J.str(v_lv_804) + (("（" + J.str(floor(J.num(J.mc(J.G.get("Rework"), "drillXp", [J.gp(v_g_803, "k")])))) + "/" + J.str(v_nx_805) + "）") if J.t(v_nx_805) else "（滿）"))

func _f188(this_, a: Array, env):
	var v_id_798 = null; var v_r_799 = null; var v_L_800 = null; var v_ws_802 = null
	v_id_798 = J.arg(a, 0)
	v_r_799 = J.cl(J.G.get("ratesPerMin"), null, [])
	v_L_800 = Callable(self, "_f189").bind(env)
	var _t995 = -1
	var _t996 = false
	if _t995 == -1 and J.seq(v_id_798, "house"): _t995 = 0
	if _t995 == -1 and J.seq(v_id_798, "wood"): _t995 = 1
	if _t995 == -1 and J.seq(v_id_798, "rice"): _t995 = 2
	if _t995 == -1 and J.seq(v_id_798, "plank"): _t995 = 3
	if _t995 == -1 and J.seq(v_id_798, "bun"): _t995 = 4
	if _t995 == -1 and J.seq(v_id_798, "store"): _t995 = 5
	if _t995 == -1 and J.seq(v_id_798, "home"): _t995 = 6
	if _t995 == -1 and J.seq(v_id_798, "camp"): _t995 = 7
	if _t995 == -1: _t995 = 8
	while true:
		if _t995 <= 0 and _t995 >= 0:
			return J.cl(v_L_800, null, [("其他建築最高可升到 Lv " + J.str(J.gp(J.gp(J.G.get("S"), "bld"), "house")))])
		if _t995 <= 1 and _t995 >= 0:
			var _t997 = J.mc(J.G.get("F"), "mult", ["wood"])
			var _t999 = J.mc(_t997, "toFixed", [1.0])
			var _t1000 = J.mc(J.G.get("F"), "slots", ["wood"])
			var _t998 = J.gp(v_r_799, "wood")
			return J.cl(v_L_800, null, [("每崗產量 ×" + J.str(_t999) + "　崗位 " + J.str(_t1000) + "　目前 槐木 +" + J.str(J.mc(_t998, "toFixed", [1.0])) + "/分")])
		if _t995 <= 2 and _t995 >= 0:
			var _t1001 = J.mc(J.G.get("F"), "mult", ["rice"])
			var _t1003 = J.mc(_t1001, "toFixed", [1.0])
			var _t1004 = J.mc(J.G.get("F"), "slots", ["rice"])
			var _t1002 = J.gp(v_r_799, "rice")
			return J.cl(v_L_800, null, [("每崗產量 ×" + J.str(_t1003) + "　崗位 " + J.str(_t1004) + "　目前 糯米 +" + J.str(J.mc(_t1002, "toFixed", [1.0])) + "/分")])
		if _t995 <= 3 and _t995 >= 0:
			var _t1006 = J.mc(J.G.get("F"), "slots", ["plank"])
			var _t1005 = J.gp(v_r_799, "planks")
			var _t1008 = J.mc(_t1005, "toFixed", [1.0])
			var _t1007 = J.gp(v_r_799, "woodUse")
			return J.cl(v_L_800, null, [("崗位 " + J.str(_t1006) + "　目前 棺材板 +" + J.str(_t1008) + "/分（耗槐木 " + J.str(J.mc(_t1007, "toFixed", [1.0])) + "/分）<br>藍箱可開出 棺材板 " + J.str(J.gp(J.mc(J.G.get("F"), "chestGain", ["b"]), "planks")))])
		if _t995 <= 4 and _t995 >= 0:
			var _t1010 = J.mc(J.G.get("F"), "slots", ["bun"])
			var _t1009 = J.gp(v_r_799, "buns")
			var _t1012 = J.mc(_t1009, "toFixed", [1.0])
			var _t1011 = J.gp(v_r_799, "riceUse")
			return J.cl(v_L_800, null, [("崗位 " + J.str(_t1010) + "　目前 壽包 +" + J.str(_t1012) + "/分（耗糯米 " + J.str(J.mc(_t1011, "toFixed", [1.0])) + "/分）<br>綠箱可開出 壽包 " + J.str(J.gp(J.mc(J.G.get("F"), "chestGain", ["g"]), "buns")))])
		if _t995 <= 5 and _t995 >= 0:
			var _t1013 = J.G.get("fmt")
			return J.cl(v_L_800, null, [("槐木、糯米、棺材板、壽包 存放上限：" + J.str(J.cl(_t1013, null, [J.mc(J.G.get("F"), "cap", [])])))])
		if _t995 <= 6 and _t995 >= 0:
			var _t1015 = J.mc(J.G.get("F"), "rosterCap", [])
			var _t1014 = J.gp(v_r_799, "troops")
			var _t1017 = J.mc(_t1014, "toFixed", [1.0])
			var _t1016 = J.G.get("fmt")
			return J.cl(v_L_800, null, [("雜鬼名額 " + J.str(_t1015) + "　遊魂自願當陰兵 +" + J.str(_t1017) + "/分　陰兵上限 " + J.str(J.cl(_t1016, null, [J.mc(J.G.get("F"), "troopCap", [])])))])
		if _t995 <= 7 and _t995 >= 0:
			var _t1018 = J.G.get("workersAt")
			v_ws_802 = J.cl(_t1018, null, ["camp"])
			var _t1019 = J.mc(J.G.get("F"), "mult", ["camp"])
			var _t1021 = J.mc(_t1019, "toFixed", [1.0])
			var _t1022 = J.mc(J.G.get("F"), "slots", ["camp"])
			var _t1020 = J.gp(v_r_799, "bunUse")
			var _t1025 = J.cl(v_L_800, null, [("練習速度 ×" + J.str(_t1021) + "　崗位 " + J.str(_t1022) + "　耗壽包 " + J.str(J.mc(_t1020, "toFixed", [1.0])) + "/分<br>嚇功越高：回陽間招式更嚇人、更省陰氣；戰鬥嚇法更痛。")])
			var _t1024 = null
			if J.t(J.len(v_ws_802)):
				var _t1023 = J.mc(v_ws_802, "map", [Callable(self, "_f190").bind(env)])
				_t1024 = J.add("<br>", J.mc(_t1023, "join", ["　"]))
			else:
				_t1024 = ""
			return J.add(_t1025, _t1024)
		if _t995 <= 8 and _t995 >= 0:
			return ""
		break

func _f192(this_, a: Array, env):
	var _t1036 = J.G.get("paintPortraits")
	var _t1037 = J.G.get("$")
	return J.cl(_t1036, null, [J.cl(_t1037, null, ["#sheet"])])

func _f191(this_, a: Array, env):
	var v_post_808 = null; var v_P_809 = null; var v_n_810 = null; var v_h_811 = null; var v_ws_812 = null; var v_i_813 = null; var v_g_814 = null
	v_post_808 = J.arg(a, 0)
	v_P_809 = J.gp(J.G.get("POSTS"), v_post_808)
	v_n_810 = J.mc(J.G.get("F"), "slots", [v_post_808])
	if (not J.t(v_n_810)):
		return ""
	var _t1026 = J.seq(v_post_808, "wood")
	var _t1027 = (_t1026 if _t1026 else J.seq(v_post_808, "rice"))
	var _t1028 = (_t1027 if _t1027 else J.seq(v_post_808, "plank"))
	var _t1029 = (_t1028 if _t1028 else J.seq(v_post_808, "bun"))
	var _t1030 = (_t1029 if _t1029 else J.seq(v_post_808, "camp"))
	var _t1031 = (_t1030 if _t1030 else J.seq(v_post_808, "store"))
	if (_t1031 if _t1031 else J.seq(v_post_808, "boss")):
		if J.cmp(J.gp(J.G.get("S"), "lv"), 4.0, "<"):
			return ("<div class=\"post\"><div class=\"ph\">" + J.str(J.gp(v_P_809, "name")) + "崗位</div><p class=\"lack\">升到 4 級【略懂管理學】後可派鬼怪打工。</p></div>")
	v_h_811 = ("<div class=\"post\"><div class=\"ph\">" + J.str(J.gp(v_P_809, "name")) + "崗位 <small>" + J.str(J.gp(v_P_809, "desc")) + "</small></div><div class=\"slots\">")
	var _t1032 = J.G.get("workersAt")
	v_ws_812 = J.cl(_t1032, null, [v_post_808])
	v_i_813 = 0.0
	while true:
		if not J.cmp(v_i_813, v_n_810, "<"): break
		v_g_814 = J.gp(v_ws_812, v_i_813)
		if J.t(v_g_814):
			var _t1033 = J.add(v_h_811, ("<div class=\"slot\"><canvas data-por=\"" + J.str(J.gp(v_g_814, "k")) + "\"></canvas><div><b>" + J.str(J.gp(v_g_814, "name")) + "</b><small>Lv" + J.str(J.mc(J.G.get("F"), "glv", [v_g_814])) + "　" + J.str(J.mc(this_, "postStatTxt", [v_g_814, v_post_808])) + "</small></div><button class=\"btn sm\" data-act=\"unassign\" data-g=\"" + J.str(J.gp(v_g_814, "id")) + "\">撤下</button></div>"))
			v_h_811 = _t1033
		else:
			var _t1034 = J.add(v_h_811, ("<div class=\"slot empty\"><span>空崗位</span><button class=\"btn sm\" data-act=\"assign\" data-post=\"" + J.str(v_post_808) + "\">派人</button></div>"))
			v_h_811 = _t1034
		v_i_813 = J.num(v_i_813) + 1.0
	var _t1035 = J.add(v_h_811, "</div></div>")
	v_h_811 = _t1035
	J.F_setTimeout([Callable(self, "_f192").bind(env), 0.0])
	return v_h_811

func _f193(this_, a: Array, env):
	var v_g_817 = null; var v_post_818 = null; var v_s_819 = null
	v_g_817 = J.arg(a, 0)
	v_post_818 = J.arg(a, 1)
	v_s_819 = J.gp(J.gp(J.G.get("POSTS"), v_post_818), "stat")
	return ((J.str(J.gp(J.G.get("STAT_NAMES"), v_s_819)) + " " + J.str(J.mc(J.G.get("F"), "stat", [v_g_817, v_s_819]))) if J.cmp(v_s_819, 0.0, ">=") else ("等級 " + J.str(J.mc(J.G.get("F"), "glv", [v_g_817]))))

func _f195(this_, a: Array, env):
	var v_g_829 = null
	v_g_829 = J.arg(a, 0)
	return (J.mc(J.G.get("F"), "stat", [v_g_829, env["s"]]) if J.cmp(env["s"], 0.0, ">=") else J.mc(J.G.get("F"), "glv", [v_g_829]))

func _f196(this_, a: Array, env):
	var v_g_830 = null
	v_g_830 = J.arg(a, 0)
	var _t1038 = J.gp(J.G.get("GHOSTS"), J.gp(v_g_830, "k"))
	var _t1039 = (J.gp(J.gp(J.G.get("GHOSTS"), J.gp(v_g_830, "k")), "forbid") if J.t(_t1038) else _t1038)
	var _t1040 = (_t1039 if J.t(_t1039) else [])
	return (1.0 if J.t(J.mc(_t1040, "includes", [env["post"]])) else 0.0)

func _f197(this_, a: Array, env):
	var v_g_831 = null
	v_g_831 = J.arg(a, 0)
	var _t1042 = (not J.seq(J.gp(v_g_831, "k"), "afu"))
	return ((not J.seq(J.gp(v_g_831, "post"), env["post"])) if _t1042 else _t1042)

func _f198(this_, a: Array, env):
	var v_a_832 = null; var v_b_833 = null
	v_a_832 = J.arg(a, 0)
	v_b_833 = J.arg(a, 1)
	var _t1044 = env["fbd"]
	var _t1046 = J.cl(_t1044, null, [v_a_832])
	var _t1045 = env["fbd"]
	var _t1050 = J.sub(_t1046, J.cl(_t1045, null, [v_b_833]))
	if not J.t(_t1050):
		var _t1047 = env["val"]
		var _t1049 = J.cl(_t1047, null, [v_b_833])
		var _t1048 = env["val"]
		_t1050 = J.sub(_t1049, J.cl(_t1048, null, [v_a_832]))
	return (_t1050 if J.t(_t1050) else J.sub(J.mc(J.G.get("F"), "glv", [v_b_833]), J.mc(J.G.get("F"), "glv", [v_a_832])))

func _f199(this_, a: Array, env):
	var v_i_836 = null
	v_i_836 = J.arg(a, 0)
	return (not J.seq(v_i_836, env["__p"]["s"]))

func _f200(this_, a: Array, env):
	var v_i_837 = null
	v_i_837 = J.arg(a, 0)
	return J.add(J.gp(J.G.get("STAT_NAMES"), v_i_837), J.mc(J.G.get("F"), "stat", [env["g"], v_i_837]))

func _f201(this_, a: Array, env):
	return J.mc(env["this"], "openBuilding", [env["back"]])

func _f203(this_, a: Array, env):
	var v_g_839 = null; var v_old_840 = null
	var _t1084 = J.G.get("ghostById")
	v_g_839 = J.cl(_t1084, null, [J.gp(J.gp(env["el"], "dataset"), "g")])
	var _t1085 = J.G.get("workersAt")
	if J.cmp(J.len(J.cl(_t1085, null, [env["__p"]["post"]])), J.mc(J.G.get("F"), "slots", [env["__p"]["post"]]), ">="):
		var _t1086 = J.G.get("workersAt")
		v_old_840 = J.gp(J.cl(_t1086, null, [env["__p"]["post"]]), 0.0)
		J.sp(v_old_840, "post", null)
	var _t1087 = env["__p"]["post"]
	J.sp(v_g_839, "post", _t1087)
	J.mc(J.G.get("Quest"), "check", [])
	J.cl(J.G.get("save"), null, [])
	J.mc(J.G.get("UI"), "refresh", [])
	J.mc(env["__p"]["this"], "openBuilding", [env["__p"]["back"]])

func _f202(this_, a: Array, env):
	var _s442 = {"__p": env, "el": null}
	_s442["el"] = J.arg(a, 0)
	var _t1083 = _s442["el"]
	var _t1088 = Callable(self, "_f203").bind(_s442)
	J.sp(_t1083, "onclick", _t1088)
	return _t1088

func _f194(this_, a: Array, env):
	var v_list_827 = null; var v_h_828 = null; var v_fb_835 = null
	var _s432 = {"__p": env, "this": null, "post": null, "back": null, "s": null, "val": null, "fbd": null}
	_s432["this"] = this_
	_s432["post"] = J.arg(a, 0)
	_s432["back"] = J.arg(a, 1)
	_s432["s"] = J.gp(J.gp(J.G.get("POSTS"), _s432["post"]), "stat")
	_s432["val"] = Callable(self, "_f195").bind(_s432)
	_s432["fbd"] = Callable(self, "_f196").bind(_s432)
	var _t1041 = J.gp(J.G.get("S"), "ghosts")
	var _t1043 = J.mc(_t1041, "filter", [Callable(self, "_f197").bind(_s432)])
	v_list_827 = J.mc(_t1043, "sort", [Callable(self, "_f198").bind(_s432)])
	v_h_828 = ("<p class=\"desc\">挑一位去「" + J.str(J.gp(J.gp(J.G.get("POSTS"), _s432["post"]), "name")) + "」。" + (("這份工看【" + J.str(J.gp(J.G.get("STAT_NAMES"), _s432["s"])) + "】。") if J.cmp(_s432["s"], 0.0, ">=") else "這份工看等級。") + "已在別處打工的，會被調過來。</p><p class=\"desc sortnote\">▼ 已按【" + J.str((J.gp(J.G.get("STAT_NAMES"), _s432["s"]) if J.cmp(_s432["s"], 0.0, ">=") else "等級")) + "】由高到低排好</p><div class=\"glist\">")
	for _t1051 in J.iter(v_list_827):
		var _s437 = {"__p": _s432, "g": null}
		_s437["g"] = _t1051
		var _t1052 = J.gp(J.G.get("GHOSTS"), J.gp(_s437["g"], "k"))
		var _t1053 = (J.gp(J.gp(J.G.get("GHOSTS"), J.gp(_s437["g"], "k")), "forbid") if J.t(_t1052) else _t1052)
		var _t1054 = (_t1053 if J.t(_t1053) else [])
		v_fb_835 = J.mc(_t1054, "includes", [_s437["__p"]["post"]])
		var _t1056 = ("dis" if J.t(v_fb_835) else "")
		var _t1057 = J.gp(_s437["g"], "id")
		var _t1058 = J.gp(_s437["g"], "k")
		var _t1059 = J.gp(_s437["g"], "name")
		var _t1060 = J.gp(_s437["g"], "q")
		var _t1061 = J.gp(_s437["g"], "q")
		var _t1062 = (J.gp(J.G.get("STAT_NAMES"), _s437["__p"]["s"]) if J.cmp(_s437["__p"]["s"], 0.0, ">=") else "等級")
		var _t1055 = _s437["__p"]["val"]
		var _t1066 = J.cl(_t1055, null, [_s437["g"]])
		var _t1067 = ((J.add("Lv", J.mc(J.G.get("F"), "glv", [_s437["g"]])) + "　") if J.cmp(_s437["__p"]["s"], 0.0, ">=") else "")
		var _t1063 = [0.0, 1.0, 2.0]
		var _t1064 = J.mc(_t1063, "filter", [Callable(self, "_f199").bind(_s437)])
		var _t1065 = J.mc(_t1064, "map", [Callable(self, "_f200").bind(_s437)])
		var _t1071 = J.mc(_t1065, "join", [" "])
		var _t1070 = null
		if J.t(J.gp(_s437["g"], "post")):
			var _t1068 = J.G.get("postLabel")
			var _t1069 = J.cl(_t1068, null, [J.gp(_s437["g"], "post")])
			_t1070 = J.add("目前：", J.mc(_t1069, "replace", [J.re("^打工：", ""), ""]))
		else:
			_t1070 = "閒著"
		var _t1072 = J.add(v_h_828, ("<div class=\"gi " + _t1056 + "\" data-g=\"" + J.str(_t1057) + "\"><canvas data-por=\"" + J.str(_t1058) + "\"></canvas><div><b>" + J.str(_t1059) + "</b> <i class=\"q q" + J.str(_t1060) + "\">" + J.str(_t1061) + "</i><small><span class=\"keystat\">" + J.str(_t1062) + " " + J.str(_t1066) + "</span>　" + _t1067 + J.str(_t1071) + "</small><small>" + _t1070 + ("　<span class=\"lack\">怕糯米，不肯去</span>" if J.t(v_fb_835) else "") + "</small></div></div>"))
		v_h_828 = _t1072
	if (not J.t(J.len(v_list_827))):
		var _t1073 = J.add(v_h_828, "<p class=\"desc\">沒有可以派的鬼怪。</p>")
		v_h_828 = _t1073
	var _t1074 = J.add(v_h_828, ("</div><button class=\"btn wide\" id=\"pkback\">返回</button>"))
	v_h_828 = _t1074
	J.mc(_s432["this"], "sheet", [("派人：" + J.str(J.gp(J.gp(J.G.get("POSTS"), _s432["post"]), "name"))), v_h_828])
	var _t1075 = J.G.get("paintPortraits")
	var _t1076 = J.G.get("$")
	J.cl(_t1075, null, [J.cl(_t1076, null, ["#sheet"])])
	var _t1077 = J.G.get("$")
	var _t1078 = J.cl(_t1077, null, ["#pkback"])
	var _t1079 = Callable(self, "_f201").bind(_s432)
	J.sp(_t1078, "onclick", _t1079)
	var _t1080 = J.G.get("$")
	var _t1081 = J.cl(_t1080, null, ["#sheet"])
	var _t1082 = J.mc(_t1081, "querySelectorAll", [".gi:not(.dis)"])
	J.mc(_t1082, "forEach", [Callable(self, "_f202").bind(_s432)])

func _f206(this_, a: Array, env):
	var v_k_848 = null
	v_k_848 = J.arg(a, 0)
	return J.mc(J.G.get("N30W"), "owned", [v_k_848])

func _f207(this_, a: Array, env):
	var v_a_849 = null; var v_b_850 = null
	v_a_849 = J.arg(a, 0)
	v_b_850 = J.arg(a, 1)
	var _t1100 = null
	if J.seq(J.gp(v_a_849, "k"), "afu"):
		_t1100 = (-1.0)
	else:
		var _t1099 = null
		if J.seq(J.gp(v_b_850, "k"), "afu"):
			_t1099 = 1.0
		else:
			var _t1098 = ((0.0 if J.seq(J.gp(v_a_849, "q"), "名") else 1.0) - (0.0 if J.seq(J.gp(v_b_850, "q"), "名") else 1.0))
			_t1099 = (_t1098 if J.t(_t1098) else J.sub(J.mc(J.G.get("F"), "glv", [v_b_850]), J.mc(J.G.get("F"), "glv", [v_a_849])))
		_t1100 = _t1099
	return _t1100

func _f208(this_, a: Array, env):
	var v_o_859 = null; var v_v_860 = null
	v_o_859 = J.gp(env["g"], "lv")
	var _t1105 = env["g"]
	var _t1106 = J.add(v_o_859, 1.0)
	J.sp(_t1105, "lv", _t1106)
	v_v_860 = J.mc(J.G.get("GP"), "pow", [env["g"]])
	var _t1107 = env["g"]
	J.sp(_t1107, "lv", v_o_859)
	return v_v_860

func _f205(this_, a: Array, env):
	var v_h_846 = null; var v_order_847 = null; var v_lv_852 = null; var v_cost_853 = null; var v_d_854 = null; var v_sk_855 = null; var v_inTeam_856 = null; var v_gpNow_857 = null; var v_gpNext_858 = null
	var _t1090 = J.mc(J.G.get("F"), "ghostCap", [])
	var _t1091 = J.cl(J.G.get("fodderCount"), null, [])
	var _t1092 = J.mc(J.G.get("F"), "rosterCap", [])
	var _t1089 = J.G.get("fmt")
	var _t1095 = J.cl(_t1089, null, [J.gp(J.gp(J.G.get("S"), "res"), "buns")])
	var _t1096 = J.mc(J.G.get("GP"), "T", ["鬼力會帶到主線戰鬥、陽間站崗、樓裡有鬼、夜班嚇人、運動會等所有玩法：喺村升級、落訓練班練嚇功，出面即刻勁啲。出面打唔過，就返嚟升級。", "鬼力會帶到主線戰鬥、陽間站崗、樓裡有鬼、夜班嚇人、運動會等所有玩法：在村裡升級、去訓練班練嚇功，外面立即變強。外面打不過，就回來升級。"])
	var _t1094 = null
	if (not J.seq(J.typeof_(J.G.get("N30W")), "undefined")):
		var _t1093 = J.mc(J.G.get("N30W"), "ids", [])
		_t1094 = ("<button class=\"btn wide\" id=\"n30cx\">新鬼圖鑑（" + J.str(J.len(J.mc(_t1093, "filter", [Callable(self, "_f206").bind(env)]))) + "/" + J.str(J.len(J.mc(J.G.get("N30W"), "ids", []))) + "）</button>")
	else:
		_t1094 = ""
	v_h_846 = ("<p class=\"desc\">用壽包升級鬼怪。等級上限 " + J.str(_t1090) + "。雜鬼名額 " + J.str(_t1091) + "/" + J.str(_t1092) + "　壽包 " + J.str(_t1095) + "</p><p class=\"desc gp-line\">" + J.str(_t1096) + "</p>" + _t1094 + "<div class=\"glist\">")
	var _t1097 = J.mc(J.gp(J.G.get("S"), "ghosts"), "slice", [])
	v_order_847 = J.mc(_t1097, "sort", [Callable(self, "_f207").bind(env)])
	for _t1101 in J.iter(v_order_847):
		var _s449 = {"__p": env, "g": null}
		_s449["g"] = _t1101
		v_lv_852 = J.mc(J.G.get("F"), "glv", [_s449["g"]])
		v_cost_853 = J.mc(J.G.get("F"), "lvCost", [v_lv_852])
		var _t1102 = J.G.get("gdef")
		v_d_854 = J.cl(_t1102, null, [_s449["g"]])
		v_sk_855 = J.gp(J.G.get("SKILLS"), J.gp(_s449["g"], "k"))
		var _t1103 = J.gp(J.G.get("S"), "team")
		v_inTeam_856 = ("出陣" if J.t(J.mc(_t1103, "includes", [J.gp(_s449["g"], "id")])) else ("軍師" if J.seq(J.gp(J.G.get("S"), "adviser"), J.gp(_s449["g"], "id")) else ""))
		v_gpNow_857 = J.mc(J.G.get("GP"), "pow", [_s449["g"]])
		var _t1104 = (not J.seq(J.gp(_s449["g"], "k"), "afu"))
		v_gpNext_858 = (J.cl(Callable(self, "_f208").bind(_s449), null, []) if (J.cmp(v_lv_852, J.mc(J.G.get("F"), "ghostCap", []), "<") if _t1104 else _t1104) else null)
		var _t1111 = J.gp(_s449["g"], "k")
		var _t1112 = J.gp(_s449["g"], "name")
		var _t1113 = J.gp(_s449["g"], "q")
		var _t1114 = J.gp(_s449["g"], "q")
		var _t1115 = (("<i class=\"tag\">" + J.str(v_inTeam_856) + "</i>") if J.t(v_inTeam_856) else "")
		var _t1116 = (J.add(J.gp(J.gp(J.G.get("GHOSTS"), J.gp(_s449["g"], "k")), "title"), "　") if J.t(J.gp(J.G.get("GHOSTS"), J.gp(_s449["g"], "k"))) else "")
		var _t1117 = J.mc(J.G.get("F"), "stat", [_s449["g"], 0.0])
		var _t1118 = J.mc(J.G.get("F"), "stat", [_s449["g"], 1.0])
		var _t1119 = J.mc(J.G.get("F"), "stat", [_s449["g"], 2.0])
		var _t1120 = ("遠程" if J.seq(J.gp(v_d_854, "range"), "ranged") else "近戰")
		var _t1121 = J.mc(J.G.get("GP"), "T", ["鬼力", "鬼力"])
		var _t1122 = (("　" + J.str(J.mc(J.G.get("GP"), "T", ["升級後", "升級後"])) + " <b class=\"gp-up\">" + J.str(v_gpNext_858) + "</b>（+" + J.str(J.sub(v_gpNext_858, v_gpNow_857)) + "）") if J.t(v_gpNext_858) else "")
		var _t1123 = (("　" + J.str(J.mc(J.G.get("GP"), "T", ["嚇功", "嚇功"])) + " Lv" + J.str(J.mc(J.G.get("Rework"), "drillLv", [J.gp(_s449["g"], "k")]))) if (not J.seq(J.typeof_(J.G.get("Rework")), "undefined")) else "")
		var _t1124 = J.gp(v_sk_855, "name")
		var _t1125 = J.gp(v_sk_855, "desc")
		var _t1110 = null
		if J.t(J.gp(J.G.get("GHOSTS"), J.gp(_s449["g"], "k"))):
			var _t1109 = null
			if J.seq(J.typeof_(J.G.get("L")), "function"):
				var _t1108 = J.G.get("L")
				_t1109 = J.cl(_t1108, null, [J.gp(J.gp(J.G.get("GHOSTS"), J.gp(_s449["g"], "k")), "trait")])
			else:
				_t1109 = J.gp(J.gp(J.G.get("GHOSTS"), J.gp(_s449["g"], "k")), "trait")
			_t1110 = ("<small class=\"tr\">" + J.str(_t1109) + "</small>")
		else:
			_t1110 = ""
		var _t1126 = J.gp(J.G.get("GHOSTS"), J.gp(_s449["g"], "k"))
		var _t1129 = (("<small class=\"tr\">" + J.str(J.gp(J.gp(J.G.get("GHOSTS"), J.gp(_s449["g"], "k")), "lore")) + "</small>") if J.t((J.gp(J.gp(J.G.get("GHOSTS"), J.gp(_s449["g"], "k")), "lore") if J.t(_t1126) else _t1126)) else "")
		var _t1128 = null
		if J.t(J.gp(_s449["g"], "post")):
			var _t1127 = J.G.get("postLabel")
			_t1128 = J.cl(_t1127, null, [J.gp(_s449["g"], "post")])
		else:
			_t1128 = ("主公本人" if J.seq(J.gp(_s449["g"], "k"), "afu") else "閒著")
		var _t1131 = ("<small>隨主公等級成長</small>" if J.seq(J.gp(_s449["g"], "k"), "afu") else (("<button class=\"btn sm gold\" data-up=\"" + J.str(J.gp(_s449["g"], "id")) + "\" " + ("" if J.cmp(J.gp(J.gp(J.G.get("S"), "res"), "buns"), v_cost_853, ">=") else "disabled") + ">升級<br><small>壽包 " + J.str(v_cost_853) + "</small></button>") if J.cmp(v_lv_852, J.mc(J.G.get("F"), "ghostCap", []), "<") else "<small>已達上限</small>"))
		var _t1130 = (not J.seq(J.gp(_s449["g"], "q"), "名"))
		var _t1132 = J.add(v_h_846, ("<div class=\"gcard\"><canvas data-por=\"" + J.str(_t1111) + "\"></canvas><div class=\"gc-main\"><div><b>" + J.str(_t1112) + "</b> <i class=\"q q" + J.str(_t1113) + "\">" + J.str(_t1114) + "</i> <span class=\"lvl\">Lv" + J.str(v_lv_852) + "</span> " + _t1115 + "</div>\n          <small>" + _t1116 + "力 " + J.str(_t1117) + "　智 " + J.str(_t1118) + "　武 " + J.str(_t1119) + "　" + _t1120 + "</small>\n          <small class=\"gp-row\">" + J.str(_t1121) + " <b>" + J.str(v_gpNow_857) + "</b>" + _t1122 + _t1123 + "</small>\n          <small class=\"sk\">【" + J.str(_t1124) + "】" + J.str(_t1125) + "</small>\n          " + _t1110 + _t1129 + "\n          <small>" + J.str(_t1128) + "</small></div>\n          <div class=\"gc-act\">" + _t1131 + "\n          " + (("<button class=\"btn sm ghost\" data-rel=\"" + J.str(J.gp(_s449["g"], "id")) + "\">送去投胎</button>") if ((not J.seq(J.gp(_s449["g"], "q"), "主")) if _t1130 else _t1130) else "") + "</div></div>"))
		v_h_846 = _t1132
	return J.add(v_h_846, "</div>")

func _f211(this_, a: Array, env):
	var v_g_863 = null; var v_c_864 = null
	var _t1137 = J.G.get("ghostById")
	v_g_863 = J.cl(_t1137, null, [J.gp(J.gp(env["b"], "dataset"), "up")])
	v_c_864 = J.mc(J.G.get("F"), "lvCost", [J.gp(v_g_863, "lv")])
	if J.cmp(J.gp(J.gp(J.G.get("S"), "res"), "buns"), v_c_864, "<"):
		return null
	var _t1138 = J.gp(J.G.get("S"), "res")
	var _t1139 = J.sub(J.gp(_t1138, "buns"), v_c_864)
	J.sp(_t1138, "buns", _t1139)
	var _t1140 = J.add(J.gp(v_g_863, "spent"), v_c_864)
	J.sp(v_g_863, "spent", _t1140)
	J.sp(v_g_863, "lv", J.num(J.gp(v_g_863, "lv")) + 1.0)
	var _t1141 = J.G.get("gainExp")
	J.cl(_t1141, null, [2.0])
	J.mc(J.G.get("Quest"), "check", [])
	J.cl(J.G.get("save"), null, [])
	J.mc(J.G.get("UI"), "refresh", [])
	J.cl(env["__p"]["re"], null, [])

func _f210(this_, a: Array, env):
	var _s453 = {"__p": env, "b": null}
	_s453["b"] = J.arg(a, 0)
	var _t1136 = _s453["b"]
	var _t1142 = Callable(self, "_f211").bind(_s453)
	J.sp(_t1136, "onclick", _t1142)
	return _t1142

func _f214(this_, a: Array, env):
	var v_x_868 = null
	v_x_868 = J.arg(a, 0)
	return (not J.seq(v_x_868, env["g"]))

func _f215(this_, a: Array, env):
	var v_x_869 = null
	v_x_869 = J.arg(a, 0)
	return (null if J.seq(v_x_869, J.gp(env["g"], "id")) else v_x_869)

func _f213(this_, a: Array, env):
	var v_back_867 = null
	var _s456 = {"__p": env, "g": null}
	var _t1147 = J.G.get("ghostById")
	_s456["g"] = J.cl(_t1147, null, [J.gp(J.gp(_s456["__p"]["b"], "dataset"), "rel")])
	var _t1148 = J.G.get("confirmInline")
	if (not J.t(J.cl(_t1148, null, [_s456["__p"]["b"], "確定？"]))):
		return null
	v_back_867 = floor(J.num(J.mul(J.gp(_s456["g"], "spent"), 0.6)))
	var _t1149 = J.gp(J.G.get("S"), "res")
	var _t1150 = J.add(J.gp(_t1149, "buns"), v_back_867)
	J.sp(_t1149, "buns", _t1150)
	var _t1151 = J.G.get("S")
	var _t1152 = J.gp(J.G.get("S"), "ghosts")
	var _t1153 = J.mc(_t1152, "filter", [Callable(self, "_f214").bind(_s456)])
	J.sp(_t1151, "ghosts", _t1153)
	var _t1154 = J.G.get("S")
	var _t1155 = J.gp(J.G.get("S"), "team")
	var _t1156 = J.mc(_t1155, "map", [Callable(self, "_f215").bind(_s456)])
	J.sp(_t1154, "team", _t1156)
	if J.seq(J.gp(J.G.get("S"), "adviser"), J.gp(_s456["g"], "id")):
		var _t1157 = J.G.get("S")
		J.sp(_t1157, "adviser", null)
	J.mc(J.G.get("Fx"), "toast", [(J.str(J.gp(_s456["g"], "name")) + " 去投胎了。退回 壽包 " + J.str(v_back_867))])
	J.cl(J.G.get("save"), null, [])
	J.mc(J.G.get("UI"), "refresh", [])
	J.cl(_s456["__p"]["__p"]["re"], null, [])

func _f212(this_, a: Array, env):
	var _s455 = {"__p": env, "b": null}
	_s455["b"] = J.arg(a, 0)
	var _t1146 = _s455["b"]
	var _t1158 = Callable(self, "_f213").bind(_s455)
	J.sp(_t1146, "onclick", _t1158)
	return _t1158

func _f216(this_, a: Array, env):
	return J.mc(J.G.get("N30W"), "openCodex", [])

func _f209(this_, a: Array, env):
	var v_cx_861 = null
	var _t1133 = J.G.get("$")
	var _t1134 = J.cl(_t1133, null, ["#sheet"])
	var _t1135 = J.mc(_t1134, "querySelectorAll", ["[data-up]"])
	J.mc(_t1135, "forEach", [Callable(self, "_f210").bind(env)])
	var _t1143 = J.G.get("$")
	var _t1144 = J.cl(_t1143, null, ["#sheet"])
	var _t1145 = J.mc(_t1144, "querySelectorAll", ["[data-rel]"])
	J.mc(_t1145, "forEach", [Callable(self, "_f212").bind(env)])
	var _t1159 = J.G.get("paintPortraits")
	var _t1160 = J.G.get("$")
	J.cl(_t1159, null, [J.cl(_t1160, null, ["#sheet"])])
	var _t1161 = J.G.get("$")
	v_cx_861 = J.cl(_t1161, null, ["#n30cx"])
	if J.t(v_cx_861):
		var _t1162 = Callable(self, "_f216").bind(env)
		J.sp(v_cx_861, "onclick", _t1162)

func _f217(this_, a: Array, env):
	var v_sc_870 = null
	var _t1163 = J.G.get("$")
	v_sc_870 = J.gp(J.cl(_t1163, null, ["#sheet .sh-body"]), "scrollTop")
	var _t1164 = J.G.get("$")
	var _t1165 = J.cl(_t1164, null, ["#sheet .sh-body"])
	var _t1166 = J.cl(env["render"], null, [])
	J.sp(_t1165, "innerHTML", _t1166)
	J.cl(env["bind"], null, [])
	var _t1167 = J.G.get("$")
	var _t1168 = J.cl(_t1167, null, ["#sheet .sh-body"])
	J.sp(_t1168, "scrollTop", v_sc_870)

func _f204(this_, a: Array, env):
	var _s445 = {"__p": env, "render": null, "bind": null, "re": null}
	_s445["render"] = Callable(self, "_f205").bind(_s445)
	_s445["bind"] = Callable(self, "_f209").bind(_s445)
	_s445["re"] = Callable(self, "_f217").bind(_s445)
	J.mc(this_, "sheet", ["鬼怪名冊", J.cl(_s445["render"], null, [])])
	J.cl(_s445["bind"], null, [])
	var _t1169 = this_
	J.sp(_t1169, "sheetRefresh", null)

func _f219(this_, a: Array, env):
	var v_C_875 = null; var v_h_876 = null; var v_k_877 = null; var v_n_878 = null; var v_d_879 = null
	v_C_875 = [["g", "綠箱", "壽包", ("開出 壽包 " + J.str(J.gp(J.mc(J.G.get("F"), "chestGain", ["g"]), "buns")) + "（隨包子鋪等級提升）")], ["b", "藍箱", "棺材板", ("開出 棺材板 " + J.str(J.gp(J.mc(J.G.get("F"), "chestGain", ["b"]), "planks")) + "（隨棺材鋪等級提升）")], ["p", "紫箱", "冥幣", ("開出 冥幣 " + J.str(J.gp(J.mc(J.G.get("F"), "chestGain", ["p"]), "coins")) + "（隨鬼宅等級提升）")]]
	v_h_876 = ("<p class=\"desc\">小提示：箱子不會過期。先把對應的建築升高，再開，收穫更多。</p>")
	for _t1170 in J.iter(v_C_875):
		var _t1171 = J.gp(_t1170, 0.0)
		v_k_877 = _t1171
		var _t1172 = J.gp(_t1170, 1.0)
		v_n_878 = _t1172
		var _t1173 = J.gp(_t1170, 3.0)
		v_d_879 = _t1173
		var _t1174 = J.add(v_h_876, ("<div class=\"row chest\"><span class=\"cb k-" + J.str(v_k_877) + "\"></span><span><b>" + J.str(v_n_878) + " ×" + J.str(J.gp(J.gp(J.G.get("S"), "chests"), v_k_877)) + "</b><br><small>" + J.str(v_d_879) + "</small></span><span class=\"btns\"><button class=\"btn sm gold\" data-open=\"" + J.str(v_k_877) + "\" data-n=\"1\" " + ("" if J.t(J.gp(J.gp(J.G.get("S"), "chests"), v_k_877)) else "disabled") + ">開 1</button><button class=\"btn sm\" data-open=\"" + J.str(v_k_877) + "\" data-n=\"all\" " + ("" if J.cmp(J.gp(J.gp(J.G.get("S"), "chests"), v_k_877), 1.0, ">") else "disabled") + ">全開</button></span></div>"))
		v_h_876 = _t1174
	return v_h_876

func _f222(this_, a: Array, env):
	var v_k_881 = null; var v_n_882 = null; var v_tot_883 = null; var v_i_884 = null; var v_g_885 = null; var v_r_886 = null
	v_k_881 = J.gp(J.gp(env["b"], "dataset"), "open")
	v_n_882 = (J.gp(J.gp(J.G.get("S"), "chests"), v_k_881) if J.seq(J.gp(J.gp(env["b"], "dataset"), "n"), "all") else 1.0)
	v_tot_883 = {}
	v_i_884 = 0.0
	while true:
		if not J.cmp(v_i_884, v_n_882, "<"): break
		v_g_885 = J.mc(J.G.get("F"), "chestGain", [v_k_881])
		for _t1179 in J.keys(v_g_885):
			v_r_886 = _t1179
			var _t1180 = J.gp(v_tot_883, v_r_886)
			var _t1181 = J.add((_t1180 if J.t(_t1180) else 0.0), J.gp(v_g_885, v_r_886))
			J.sp(v_tot_883, v_r_886, _t1181)
		v_i_884 = J.num(v_i_884) + 1.0
	J.mc(J.G.get("Sound"), "play", ["chest"])
	var _t1182 = J.gp(J.G.get("S"), "chests")
	var _t1183 = J.sub(J.gp(_t1182, v_k_881), v_n_882)
	J.sp(_t1182, v_k_881, _t1183)
	var _t1184 = J.gp(J.G.get("S"), "cnt")
	var _t1185 = J.add(J.gp(_t1184, "chest"), v_n_882)
	J.sp(_t1184, "chest", _t1185)
	var _t1186 = J.G.get("give")
	J.mc(J.G.get("Fx"), "toast", [("開箱：" + J.str(J.cl(_t1186, null, [v_tot_883])))])
	J.cl(J.G.get("save"), null, [])
	J.mc(J.G.get("UI"), "refresh", [])
	var _t1187 = J.G.get("$")
	var _t1188 = J.cl(_t1187, null, ["#sheet .sh-body"])
	var _t1189 = J.cl(env["__p"]["render"], null, [])
	J.sp(_t1188, "innerHTML", _t1189)
	J.cl(env["__p"]["bind"], null, [])

func _f221(this_, a: Array, env):
	var _s465 = {"__p": env, "b": null}
	_s465["b"] = J.arg(a, 0)
	var _t1178 = _s465["b"]
	var _t1190 = Callable(self, "_f222").bind(_s465)
	J.sp(_t1178, "onclick", _t1190)
	return _t1190

func _f220(this_, a: Array, env):
	var _t1175 = J.G.get("$")
	var _t1176 = J.cl(_t1175, null, ["#sheet"])
	var _t1177 = J.mc(_t1176, "querySelectorAll", ["[data-open]"])
	return J.mc(_t1177, "forEach", [Callable(self, "_f221").bind(env)])

func _f218(this_, a: Array, env):
	var _s461 = {"__p": env, "render": null, "bind": null}
	_s461["render"] = Callable(self, "_f219").bind(_s461)
	_s461["bind"] = Callable(self, "_f220").bind(_s461)
	J.mc(this_, "sheet", ["箱子", J.cl(_s461["render"], null, [])])
	J.cl(_s461["bind"], null, [])

func _f225(this_, a: Array, env):
	var v_id_896 = null
	v_id_896 = J.arg(a, 0)
	return J.gp(J.gp(J.G.get("S"), "seen"), v_id_896)

func _f224(this_, a: Array, env):
	var v_name_892 = null; var v_ids_893 = null; var v_i_894 = null; var v_ok_895 = null
	var _t1191 = J.gp(J.arg(a, 0), 0.0)
	v_name_892 = _t1191
	var _t1192 = J.gp(J.arg(a, 0), 1.0)
	v_ids_893 = _t1192
	v_i_894 = J.arg(a, 1)
	v_ok_895 = J.mc(v_ids_893, "some", [Callable(self, "_f225").bind(env)])
	var _t1193 = J.add(env["h"], ("<button class=\"btn wide " + ("" if J.t(v_ok_895) else "ghost") + "\" data-sc=\"" + J.str(v_i_894) + "\" " + ("" if J.t(v_ok_895) else "disabled") + ">" + J.str((v_name_892 if J.t(v_ok_895) else "？？？")) + "</button>"))
	env["h"] = _t1193

func _f226(this_, a: Array, env):
	var v_st_897 = null; var v_i_898 = null; var v_ok_899 = null
	v_st_897 = J.arg(a, 0)
	v_i_898 = J.arg(a, 1)
	var _t1195 = J.G.get("standOk")
	v_ok_899 = J.cl(_t1195, null, [v_st_897])
	var _t1196 = J.add(env["h"], ("<button class=\"btn wide " + ("" if J.t(v_ok_899) else "ghost") + "\" data-st=\"" + J.str(v_i_898) + "\" " + ("" if J.t(v_ok_899) else "disabled") + ">" + (("<small>" + J.str(J.gp(v_st_897, "who")) + "</small>　" + J.str(J.gp(v_st_897, "title"))) if J.t(v_ok_899) else (J.add("？？？（", J.gp(v_st_897, "hint")) + "）")) + "</button>"))
	env["h"] = _t1196

func _f227(this_, a: Array, env):
	var v_best_900 = null; var v_k_901 = null; var v_o_902 = null; var v_e_903 = null
	v_best_900 = null
	for _t1197 in J.iter(["_hi", "_bak", "_del"]):
		v_k_901 = _t1197
		var _t1198 = J.S_localStorage_("getItem", [J.add(J.G.get("SAVE_KEY"), v_k_901)])
		v_o_902 = J.S_JSON_("parse", [(_t1198 if J.t(_t1198) else "null")])
		var _t1202 = v_o_902
		if J.t(_t1202):
			var _t1199 = J.gp(v_o_902, "lv")
			var _t1201 = (_t1199 if J.t(_t1199) else 1.0)
			var _t1200 = J.gp(J.G.get("S"), "lv")
			_t1202 = J.cmp(_t1201, (_t1200 if J.t(_t1200) else 1.0), ">")
		var _t1204 = _t1202
		if J.t(_t1204):
			var _t1203 = (not J.t(v_best_900))
			_t1204 = (_t1203 if _t1203 else J.cmp(J.gp(v_o_902, "lv"), J.gp(J.gp(v_best_900, "o"), "lv"), ">"))
		if J.t(_t1204):
			var _t1205 = {"k": v_k_901, "o": v_o_902}
			v_best_900 = _t1205
	return (("<button class=\"btn wide gold\" id=\"restorebtn\" data-k=\"" + J.str(J.gp(v_best_900, "k")) + "\">恢復備份存檔（主公 " + J.str(J.gp(J.gp(v_best_900, "o"), "lv")) + " 級）</button>") if J.t(v_best_900) else "")

func _f230(this_, a: Array, env):
	var v_id_905 = null
	v_id_905 = J.arg(a, 0)
	return J.gp(J.gp(J.G.get("S"), "seen"), v_id_905)

func _f231(this_, a: Array, env):
	var v_id_906 = null
	v_id_906 = J.arg(a, 0)
	return J.mc(J.G.get("Story"), "queue", [v_id_906])

func _f229(this_, a: Array, env):
	J.mc(env["__p"]["this"], "close", [])
	var _t1211 = J.gp(J.gp(J.G.get("SCENE_ORDER"), J.num(J.gp(J.gp(env["b"], "dataset"), "sc"))), 1.0)
	var _t1212 = J.mc(_t1211, "filter", [Callable(self, "_f230").bind(env)])
	J.mc(_t1212, "forEach", [Callable(self, "_f231").bind(env)])

func _f228(this_, a: Array, env):
	var _s480 = {"__p": env, "b": null}
	_s480["b"] = J.arg(a, 0)
	var _t1210 = _s480["b"]
	var _t1213 = Callable(self, "_f229").bind(_s480)
	J.sp(_t1210, "onclick", _t1213)
	return _t1213

func _f233(this_, a: Array, env):
	var v_st_908 = null
	J.mc(env["__p"]["this"], "close", [])
	v_st_908 = J.gp(J.G.get("STANDUP"), J.num(J.gp(J.gp(env["b"], "dataset"), "st")))
	J.mc(J.G.get("Story"), "queue", [{"style": "talk", "bg": J.gp(v_st_908, "bg"), "mic": true, "title": J.gp(v_st_908, "title"), "lines": J.spread([J.SP(J.gp(v_st_908, "lines")), ["旁白", J.gp(v_st_908, "end")]])}])

func _f232(this_, a: Array, env):
	var _s484 = {"__p": env, "b": null}
	_s484["b"] = J.arg(a, 0)
	var _t1217 = _s484["b"]
	var _t1218 = Callable(self, "_f233").bind(_s484)
	J.sp(_t1217, "onclick", _t1218)
	return _t1218

func _f234(this_, a: Array, env):
	J.mc(env["this"], "close", [])
	J.mc(J.G.get("Web"), "installGuide", [false])

func _f235(this_, a: Array, env):
	J.mc(env["this"], "close", [])
	J.mc(J.G.get("Phone"), "home", ["post"])

func _f236(this_, a: Array, env):
	var v_e_909 = null; var v_on_910 = null
	v_e_909 = J.arg(a, 0)
	v_on_910 = J.mc(J.G.get("Sound"), "toggle", [])
	var _t1226 = J.gp(v_e_909, "target")
	var _t1227 = ("聲音：" + ("開" if J.t(v_on_910) else "關"))
	J.sp(_t1226, "textContent", _t1227)
	J.cl(J.G.get("syncSnd"), null, [])

func _f237(this_, a: Array, env):
	var v_e_911 = null; var v_er_912 = null
	v_e_911 = J.arg(a, 0)
	var _t1231 = J.G.get("confirmInline")
	if (not J.t(J.cl(_t1231, null, [J.gp(v_e_911, "target"), "再按一次確定刪檔"]))):
		return null
	var _t1233 = J.add(J.G.get("SAVE_KEY"), "_del")
	var _t1232 = J.S_localStorage_("getItem", [J.G.get("SAVE_KEY")])
	J.S_localStorage_("setItem", [_t1233, (_t1232 if J.t(_t1232) else "")])
	J.S_localStorage_("removeItem", [J.G.get("SAVE_KEY")])
	J.S_location_("reload", [])

func _f239(this_, a: Array, env):
	return J.mc(J.G.get("Fx"), "toast", ["存檔碼已複製，貼去記事本或者 WhatsApp 自己收好"])

func _f240(this_, a: Array, env):
	var _t1239 = J.G.get("$")
	var _t1240 = J.cl(_t1239, null, ["#impbox"])
	J.sp(_t1240, "hidden", false)
	var _t1241 = J.G.get("$")
	var _t1242 = J.cl(_t1241, null, ["#impta"])
	var _t1243 = env["code"]
	J.sp(_t1242, "value", _t1243)
	var _t1244 = J.G.get("$")
	J.mc(J.cl(_t1244, null, ["#impta"]), "select", [])
	J.mc(J.G.get("Fx"), "toast", ["自己長按複製呢段存檔碼"])

func _f238(this_, a: Array, env):
	var v_done_914 = null; var v_er_915 = null
	var _s493 = {"__p": env, "code": null}
	J.cl(J.G.get("save"), null, [])
	_s493["code"] = J.mc(J.G.get("Web"), "enc", [J.G.get("S")])
	v_done_914 = Callable(self, "_f239").bind(_s493)
	var _t1237 = J.gp(J.G.get("navigator"), "clipboard")
	var _t1238 = J.mc(_t1237, "writeText", [_s493["code"]])
	J.mc(_t1238, "then", [v_done_914, Callable(self, "_f240").bind(_s493)])

func _f241(this_, a: Array, env):
	var _t1248 = J.G.get("$")
	var _t1249 = J.cl(_t1248, null, ["#impbox"])
	J.sp(_t1249, "hidden", false)
	var _t1250 = J.G.get("$")
	var _t1251 = J.cl(_t1250, null, ["#impta"])
	J.sp(_t1251, "value", "")
	var _t1252 = J.G.get("$")
	J.mc(J.cl(_t1252, null, ["#impta"]), "focus", [])

func _f242(this_, a: Array, env):
	var v_e_916 = null; var v_o_917 = null; var v_er_918 = null; var v_er_919 = null
	v_e_916 = J.arg(a, 0)
	v_o_917 = null
	var _t1256 = J.G.get("$")
	var _t1257 = J.mc(J.gp(J.cl(_t1256, null, ["#impta"]), "value"), "trim", [])
	var _t1258 = J.mc(J.G.get("Web"), "dec", [J.mc(_t1257, "replace", [J.re("^.*#save=", ""), ""])])
	v_o_917 = _t1258
	var _t1259 = (not J.t(v_o_917))
	if (_t1259 if _t1259 else (not J.t(J.gp(v_o_917, "res")))):
		J.mc(J.G.get("Fx"), "toast", ["存檔碼讀唔到，檢查吓有冇貼齊"])
		return null
	var _t1260 = J.G.get("confirmInline")
	var _t1262 = J.gp(v_e_916, "target")
	var _t1261 = J.gp(v_o_917, "lv")
	if (not J.t(J.cl(_t1260, null, [_t1262, ("再按一次：換成主公 " + J.str((_t1261 if J.t(_t1261) else 1.0)) + " 級嘅存檔")]))):
		return null
	var _t1264 = J.add(J.G.get("SAVE_KEY"), "_bak")
	var _t1263 = J.S_localStorage_("getItem", [J.G.get("SAVE_KEY")])
	J.S_localStorage_("setItem", [_t1264, (_t1263 if J.t(_t1263) else "")])
	J.S_window_("removeEventListener", ["beforeunload", J.G.get("save")])
	var _t1265 = J.S_Date_("now", [])
	J.sp(v_o_917, "last", _t1265)
	J.S_localStorage_("setItem", [J.G.get("SAVE_KEY"), J.S_JSON_("stringify", [v_o_917])])
	var _t1266 = J.G.get("window")
	J.sp(_t1266, "__NOSAVE", 1.0)
	J.S_location_("reload", [])

func _f243(this_, a: Array, env):
	var v_e_920 = null; var v_k_921 = null; var v_v_922 = null; var v_er_923 = null
	v_e_920 = J.arg(a, 0)
	var _t1270 = J.G.get("confirmInline")
	if (not J.t(J.cl(_t1270, null, [J.gp(v_e_920, "target"), "再按一次確定恢復"]))):
		return null
	v_k_921 = J.add(J.G.get("SAVE_KEY"), J.gp(J.gp(env["rb"], "dataset"), "k"))
	v_v_922 = J.S_localStorage_("getItem", [v_k_921])
	var _t1272 = J.add(J.G.get("SAVE_KEY"), "_bak")
	var _t1271 = J.S_localStorage_("getItem", [J.G.get("SAVE_KEY")])
	J.S_localStorage_("setItem", [_t1272, (_t1271 if J.t(_t1271) else "")])
	J.S_window_("removeEventListener", ["beforeunload", J.G.get("save")])
	J.S_localStorage_("setItem", [J.G.get("SAVE_KEY"), v_v_922])
	var _t1273 = J.G.get("window")
	J.sp(_t1273, "__NOSAVE", 1.0)
	J.S_location_("reload", [])

func _f223(this_, a: Array, env):
	var v_ib_890 = null
	var _s470 = {"__p": env, "this": null, "h": null, "rb": null}
	_s470["this"] = this_
	_s470["h"] = "<p class=\"desc\">看過的劇情，可以在這裡重溫。</p><div class=\"slist\">"
	J.mc(J.G.get("SCENE_ORDER"), "forEach", [Callable(self, "_f224").bind(_s470)])
	var _t1194 = J.add(_s470["h"], "</div><h4 class=\"stand-h\">開麥之夜・陰間脫口秀</h4><p class=\"desc\">村裡的鬼，入了村就能上台。</p><div class=\"slist\">")
	_s470["h"] = _t1194
	J.mc(J.G.get("STANDUP"), "forEach", [Callable(self, "_f226").bind(_s470)])
	var _t1206 = J.add(_s470["h"], ("</div><hr>" + ("<button class=\"btn wide gold\" id=\"instbtn\">放到手機桌面（自動更新）</button>" if J.t(((not J.t(J.cl(J.G.get("isStandalone"), null, []))) if J.t(J.G.get("IS_WEB")) else J.G.get("IS_WEB"))) else "") + "<button class=\"btn wide\" id=\"phonebtn\">看手機</button><button class=\"btn wide\" id=\"sndbtn\">聲音：" + ("開" if J.t(J.mc(J.G.get("Sound"), "isOn", [])) else "關") + "</button><button class=\"btn wide\" id=\"expbtn\">備份存檔（複製存檔碼）</button><button class=\"btn wide\" id=\"impbtn\">導入存檔碼</button><div id=\"impbox\" hidden><textarea id=\"impta\" rows=\"4\" style=\"width:100%;font-size:14px\" placeholder=\"貼上存檔碼\"></textarea><button class=\"btn wide gold\" id=\"impgo\">確定導入</button></div><button class=\"btn wide ghost\" id=\"resetbtn\">重新開始（刪除存檔）</button>" + J.str(J.cl(Callable(self, "_f227").bind(_s470), null, []))))
	_s470["h"] = _t1206
	J.mc(_s470["this"], "sheet", ["劇情", _s470["h"]])
	var _t1207 = J.G.get("$")
	var _t1208 = J.cl(_t1207, null, ["#sheet"])
	var _t1209 = J.mc(_t1208, "querySelectorAll", ["[data-sc]"])
	J.mc(_t1209, "forEach", [Callable(self, "_f228").bind(_s470)])
	var _t1214 = J.G.get("$")
	var _t1215 = J.cl(_t1214, null, ["#sheet"])
	var _t1216 = J.mc(_t1215, "querySelectorAll", ["[data-st]"])
	J.mc(_t1216, "forEach", [Callable(self, "_f232").bind(_s470)])
	var _t1219 = J.G.get("$")
	v_ib_890 = J.cl(_t1219, null, ["#instbtn"])
	if J.t(v_ib_890):
		var _t1220 = Callable(self, "_f234").bind(_s470)
		J.sp(v_ib_890, "onclick", _t1220)
	var _t1221 = J.G.get("$")
	var _t1222 = J.cl(_t1221, null, ["#phonebtn"])
	var _t1223 = Callable(self, "_f235").bind(_s470)
	J.sp(_t1222, "onclick", _t1223)
	var _t1224 = J.G.get("$")
	var _t1225 = J.cl(_t1224, null, ["#sndbtn"])
	var _t1228 = Callable(self, "_f236").bind(_s470)
	J.sp(_t1225, "onclick", _t1228)
	var _t1229 = J.G.get("$")
	var _t1230 = J.cl(_t1229, null, ["#resetbtn"])
	var _t1234 = Callable(self, "_f237").bind(_s470)
	J.sp(_t1230, "onclick", _t1234)
	var _t1235 = J.G.get("$")
	var _t1236 = J.cl(_t1235, null, ["#expbtn"])
	var _t1245 = Callable(self, "_f238").bind(_s470)
	J.sp(_t1236, "onclick", _t1245)
	var _t1246 = J.G.get("$")
	var _t1247 = J.cl(_t1246, null, ["#impbtn"])
	var _t1253 = Callable(self, "_f241").bind(_s470)
	J.sp(_t1247, "onclick", _t1253)
	var _t1254 = J.G.get("$")
	var _t1255 = J.cl(_t1254, null, ["#impgo"])
	var _t1267 = Callable(self, "_f242").bind(_s470)
	J.sp(_t1255, "onclick", _t1267)
	var _t1268 = J.G.get("$")
	_s470["rb"] = J.cl(_t1268, null, ["#restorebtn"])
	if J.t(_s470["rb"]):
		var _t1269 = _s470["rb"]
		var _t1274 = Callable(self, "_f243").bind(_s470)
		J.sp(_t1269, "onclick", _t1274)

func _f244(this_, a: Array, env):
	if (not J.seq(J.typeof_(J.G.get("Patrol")), "undefined")):
		J.mc(J.G.get("Patrol"), "openPrep", [])
	else:
		J.mc(J.G.get("Battle"), "openSelect", [])
