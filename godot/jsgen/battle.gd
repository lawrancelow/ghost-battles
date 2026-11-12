# 自動轉譯自 battle.js（tools/jsgd.js）——唔好直接改，改原 JS 再轉
extends RefCounted

func run(env):
	var this_ = null; var a = []
	J.G["GIFT_REWARD"] = {"gift_phone": {"coins": 300.0}, "gift_car": {"coins": 800.0, "chest": "p"}}
	J.G["Battle"] = {"active": false, "units": [], "fx": [], "t": 0.0, "speed": 1.0, "auto": false, "stage": null, "sid": "", "result": null, "init": Callable(self, "_f1").bind(env), "syncBtns": Callable(self, "_f6").bind(env), "sidOf": Callable(self, "_f7").bind(env), "stageOpen": Callable(self, "_f8").bind(env), "openSelect": Callable(self, "_f9").bind(env), "pickSlot": Callable(self, "_f23").bind(env), "tryStart": Callable(self, "_f29").bind(env), "mkGhostUnit": Callable(self, "_f32").bind(env), "start": Callable(self, "_f33").bind(env), "resize": Callable(self, "_f36").bind(env), "buildCards": Callable(self, "_f37").bind(env), "enemiesOf": Callable(self, "_f45").bind(env), "nearest": Callable(self, "_f47").bind(env), "stateOf": Callable(self, "_f48").bind(env), "hitStopFor": Callable(self, "_f49").bind(env), "kick": Callable(self, "_f50").bind(env), "hit": Callable(self, "_f51").bind(env), "doSkill": Callable(self, "_f52").bind(env), "CAST": 0.45, "beginCast": Callable(self, "_f57").bind(env), "tickCast": Callable(self, "_f58").bind(env), "fireCast": Callable(self, "_f59").bind(env), "cast": Callable(self, "_f60").bind(env), "castCombo": Callable(self, "_f61").bind(env), "fireCombo": Callable(self, "_f62").bind(env), "uy": Callable(self, "_f64").bind(env), "scaleOf": Callable(self, "_f65").bind(env), "WIND": 0.22, "STRIKE": 0.12, "REC": 0.25, "IMPACT": 0.05, "PSPD": 640.0, "period": Callable(self, "_f66").bind(env), "leadOf": Callable(self, "_f67").bind(env), "lungeOf": Callable(self, "_f68").bind(env), "stepAnim": Callable(self, "_f69").bind(env), "fire": Callable(self, "_f70").bind(env), "stepProj": Callable(self, "_f71").bind(env), "spark": Callable(self, "_f73").bind(env), "dust": Callable(self, "_f74").bind(env), "update": Callable(self, "_f75").bind(env), "visTick": Callable(self, "_f82").bind(env), "finish": Callable(self, "_f83").bind(env), "poseOf": Callable(self, "_f92").bind(env), "draw": Callable(self, "_f95").bind(env), "drawText": Callable(self, "_f98").bind(env), "drawSpark": Callable(self, "_f99").bind(env), "drawSlash": Callable(self, "_f102").bind(env), "drawDust": Callable(self, "_f103").bind(env), "drawCharge": Callable(self, "_f104").bind(env), "drawProj": Callable(self, "_f105").bind(env)}

func _f2(this_, a: Array, env):
	var v_e_6 = null
	var _t14 = env["this"]
	var _t15 = (not J.t(J.gp(env["this"], "auto")))
	J.sp(_t14, "auto", _t15)
	J.S_localStorage_("setItem", ["gb_auto", ("1" if J.t(J.gp(env["this"], "auto")) else "0")])
	J.mc(env["this"], "syncBtns", [])

func _f3(this_, a: Array, env):
	var v_e_7 = null
	var _t19 = env["this"]
	var _t20 = (2.0 if J.seq(J.gp(env["this"], "speed"), 1.0) else 1.0)
	J.sp(_t19, "speed", _t20)
	J.S_localStorage_("setItem", ["gb_speed", J.gp(env["this"], "speed")])
	J.mc(env["this"], "syncBtns", [])

func _f4(this_, a: Array, env):
	var v_e_8 = null
	v_e_8 = J.arg(a, 0)
	if J.t(J.gp(env["this"], "result")):
		return null
	var _t24 = J.G.get("confirmInline")
	if (not J.t(J.cl(_t24, null, [J.gp(v_e_8, "target"), "確定撤退？"]))):
		return null
	J.mc(env["this"], "finish", [false, true])

func _f5(this_, a: Array, env):
	var _t26 = J.gp(env["this"], "active")
	return (J.mc(env["this"], "resize", []) if J.t(_t26) else _t26)

func _f1(this_, a: Array, env):
	var v_e_5 = null
	var _s2 = {"__p": env, "this": null}
	_s2["this"] = this_
	var _t1 = _s2["this"]
	var _t2 = J.G.get("$")
	var _t3 = J.cl(_t2, null, ["#bcvs"])
	J.sp(_t1, "cvs", _t3)
	var _t4 = _s2["this"]
	var _t5 = J.gp(_s2["this"], "cvs")
	var _t6 = J.mc(_t5, "getContext", ["2d"])
	J.sp(_t4, "ctx", _t6)
	var _t7 = _s2["this"]
	var _t8 = J.seq(J.S_localStorage_("getItem", ["gb_auto"]), "1")
	J.sp(_t7, "auto", _t8)
	var _t9 = _s2["this"]
	var _t10 = J.S_localStorage_("getItem", ["gb_speed"])
	var _t11 = J.num((_t10 if J.t(_t10) else 1.0))
	J.sp(_t9, "speed", _t11)
	var _t12 = J.G.get("$")
	var _t13 = J.cl(_t12, null, ["#b-auto"])
	var _t16 = Callable(self, "_f2").bind(_s2)
	J.sp(_t13, "onclick", _t16)
	var _t17 = J.G.get("$")
	var _t18 = J.cl(_t17, null, ["#b-speed"])
	var _t21 = Callable(self, "_f3").bind(_s2)
	J.sp(_t18, "onclick", _t21)
	var _t22 = J.G.get("$")
	var _t23 = J.cl(_t22, null, ["#b-quit"])
	var _t25 = Callable(self, "_f4").bind(_s2)
	J.sp(_t23, "onclick", _t25)
	J.S_window_("addEventListener", ["resize", Callable(self, "_f5").bind(_s2)])

func _f6(this_, a: Array, env):
	var _t27 = J.G.get("$")
	var _t28 = J.gp(J.cl(_t27, null, ["#b-auto"]), "classList")
	J.mc(_t28, "toggle", ["on", J.gp(this_, "auto")])
	var _t29 = J.G.get("$")
	var _t30 = J.cl(_t29, null, ["#b-auto"])
	var _t31 = ("自動 ON" if J.t(J.gp(this_, "auto")) else "自動 OFF")
	J.sp(_t30, "textContent", _t31)
	var _t32 = J.G.get("$")
	var _t33 = J.cl(_t32, null, ["#b-speed"])
	var _t34 = J.add("×", J.gp(this_, "speed"))
	J.sp(_t33, "textContent", _t34)

func _f7(this_, a: Array, env):
	var v_ci_13 = null; var v_si_14 = null
	v_ci_13 = J.arg(a, 0)
	v_si_14 = J.arg(a, 1)
	return (J.str(J.add(v_ci_13, 1.0)) + "-" + J.str(J.add(v_si_14, 1.0)))

func _f8(this_, a: Array, env):
	var v_ci_17 = null; var v_si_18 = null
	v_ci_17 = J.arg(a, 0)
	v_si_18 = J.arg(a, 1)
	var _t35 = J.cmp(v_si_18, 0.0, ">")
	if ((not J.t(J.gp(J.gp(J.G.get("S"), "cleared"), J.mc(this_, "sidOf", [v_ci_17, J.sub(v_si_18, 1.0)])))) if _t35 else _t35):
		return false
	var _t36 = J.seq(v_si_18, 0.0)
	var _t37 = (J.cmp(v_ci_17, 0.0, ">") if _t36 else _t36)
	if ((not J.t(J.gp(J.gp(J.G.get("S"), "cleared"), J.mc(this_, "sidOf", [J.sub(v_ci_17, 1.0), 2.0])))) if _t37 else _t37):
		return false
	return true

func _f12(this_, a: Array, env):
	var v_st_31 = null; var v_si_32 = null; var v_sid_33 = null; var v_open_34 = null; var v_done_35 = null; var v_lvOk_36 = null
	v_st_31 = J.arg(a, 0)
	v_si_32 = J.arg(a, 1)
	v_sid_33 = J.mc(env["__p"]["__p"]["this"], "sidOf", [env["ci"], v_si_32])
	v_open_34 = J.mc(env["__p"]["__p"]["this"], "stageOpen", [env["ci"], v_si_32])
	v_done_35 = J.gp(J.gp(J.G.get("S"), "cleared"), v_sid_33)
	v_lvOk_36 = J.cmp(J.gp(J.G.get("S"), "lv"), J.gp(v_st_31, "req"), ">=")
	var _t57 = J.add(env["__p"]["h"], ("<div class=\"stg " + ("" if J.t(v_open_34) else "locked") + " " + ("boss" if J.t(J.gp(v_st_31, "boss")) else "") + "\"><span class=\"sn\">" + J.str(v_sid_33) + "</span><span class=\"st\"><b>" + J.str(J.gp(v_st_31, "name")) + "</b><small>" + (("需主公 Lv" + J.str(J.gp(v_st_31, "req")) + "　<span class=\"gp-need " + ("gp-low" if J.cmp(env["__p"]["myGP"], J.mc(J.G.get("GP"), "stageNeed", [v_st_31, v_sid_33]), "<") else "gp-ok") + "\">" + J.str(J.mc(J.G.get("GP"), "T", ["建議鬼力", "建議鬼力"])) + " " + J.str(J.mc(J.G.get("GP"), "stageNeed", [v_st_31, v_sid_33])) + "</span>　" + J.str(J.mc(J.G.get("Rework"), "turfTag", [v_sid_33])) + "</small><small class=\"rw-efs\">" + J.str(J.mc(J.G.get("Rework"), "enemyHint", [J.gp(v_st_31, "en")]))) if J.t(v_open_34) else "先打通上一關") + "</small></span>" + (("<button class=\"btn sm " + ("" if J.t(((not J.t(J.mc(J.G.get("Rework"), "isLost", [v_sid_33]))) if J.t(v_done_35) else v_done_35)) else "gold") + "\" data-go=\"" + J.str(env["ci"]) + "," + J.str(v_si_32) + "\" " + ("" if J.t(v_lvOk_36) else "disabled") + ">" + (("奪回" if J.t(J.mc(J.G.get("Rework"), "isLost", [v_sid_33])) else "巡場") if J.t(v_done_35) else ("搶地盤" if J.t(v_lvOk_36) else ("Lv" + J.str(J.gp(v_st_31, "req"))))) + "</button>") if J.t(v_open_34) else "<span class=\"lk\">🔒</span>") + ("<i class=\"ok\">✓</i>" if J.t(v_done_35) else "") + "</div>"))
	env["__p"]["h"] = _t57

func _f11(this_, a: Array, env):
	var v_ch_29 = null
	var _s24 = {"__p": env, "ci": null}
	v_ch_29 = J.arg(a, 0)
	_s24["ci"] = J.arg(a, 1)
	var _t55 = J.add(_s24["__p"]["h"], ("<div class=\"chap\"><div class=\"ch-h\">第" + J.str(J.gp("一二三四五六", _s24["ci"])) + "章・" + J.str(J.gp(v_ch_29, "name")) + "</div>"))
	_s24["__p"]["h"] = _t55
	var _t56 = J.gp(v_ch_29, "stages")
	J.mc(_t56, "forEach", [Callable(self, "_f12").bind(_s24)])
	var _t58 = J.add(_s24["__p"]["h"], "</div>")
	_s24["__p"]["h"] = _t58

func _f10(this_, a: Array, env):
	var v_ad_25 = null; var v_i_26 = null; var v_g_27 = null; var v_b_28 = null
	var _s20 = {"__p": env, "h": null, "myGP": null}
	_s20["h"] = ("<div class=\"team\">")
	v_i_26 = 0.0
	while true:
		if not J.cmp(v_i_26, 3.0, "<"): break
		var _t38 = J.G.get("ghostById")
		v_g_27 = J.cl(_t38, null, [J.gp(J.gp(J.G.get("S"), "team"), v_i_26)])
		var _t39 = J.add(_s20["h"], ("<div class=\"tslot\" data-slot=\"" + J.str(v_i_26) + "\">" + (("<canvas data-por=\"" + J.str(J.gp(v_g_27, "k")) + "\"></canvas><b>" + J.str(J.gp(v_g_27, "name")) + "</b><small>Lv" + J.str(J.mc(J.G.get("F"), "glv", [v_g_27])) + "・" + J.str(J.mc(J.G.get("GP"), "T", ["鬼力", "鬼力"])) + J.str(J.mc(J.G.get("GP"), "pow", [v_g_27])) + "</small>") if J.t(v_g_27) else "<span>＋<br>出陣</span>") + "</div>"))
		_s20["h"] = _t39
		v_i_26 = J.num(v_i_26) + 1.0
	var _t40 = J.gp(J.G.get("S"), "team")
	_s20["myGP"] = J.mc(J.G.get("GP"), "avg", [J.mc(_t40, "map", [J.G.get("ghostById")])])
	var _t41 = J.G.get("ghostById")
	v_ad_25 = J.cl(_t41, null, [J.gp(J.G.get("S"), "adviser")])
	var _t42 = J.add(_s20["h"], ("<div class=\"tslot adv\" data-slot=\"adv\">" + (("<canvas data-por=\"" + J.str(J.gp(v_ad_25, "k")) + "\"></canvas><b>" + J.str(J.gp(v_ad_25, "name")) + "</b><small>軍師</small>") if J.t(v_ad_25) else "<span>＋<br>軍師</span>") + "</div></div>"))
	_s20["h"] = _t42
	var _t44 = (J.round(J.num(J.div(J.mc(J.G.get("F"), "stat", [v_ad_25, 1.0]), 8.0))) if J.t(v_ad_25) else 0.0)
	var _t45 = J.mc(J.G.get("GP"), "T", ["出陣平均", "出陣平均"])
	var _t46 = J.mc(J.G.get("GP"), "tag", [_s20["myGP"], 0.0])
	var _t47 = J.mc(J.G.get("GP"), "T", ["每關都有「建議鬼力」，紅字＝未夠，返村升級或者練嚇功先。", "每關都有「建議鬼力」，紅字＝不足，先回村升級或練嚇功。"])
	var _t43 = J.G.get("fmt")
	var _t48 = J.add(_s20["h"], ("<p class=\"desc\">軍師不上場，坐鎮後方：全隊攻擊 +" + J.str(_t44) + "%（看智力），能量滿了也能放技能。出征前可隨時換人。　</p><p class=\"desc gp-line\">" + J.str(_t45) + " " + J.str(_t46) + "　<small>" + J.str(_t47) + "</small></p><div class=\"troopbox\"><b>帶上陣的陰兵</b><span>現有 " + J.str(J.cl(_t43, null, [J.gp(J.gp(J.G.get("S"), "res"), "troops")])) + "，可組成 <em>" + J.str(J.min_([8.0, floor(J.num(J.div(J.gp(J.gp(J.G.get("S"), "res"), "troops"), 25.0)))])) + "</em> 隊（每 25 個一隊，最多 8 隊）</span><small>" + ("村裡的遊魂見你有地盤，會自願當陰兵（民宅越高級來得越快）。戰死的會扣掉。" if J.t(J.gp(J.gp(J.G.get("S"), "bld"), "home")) else "建好民宅，遊魂才會來投靠當陰兵。") + "</small></div>"))
	_s20["h"] = _t48
	if J.t(J.gp(J.gp(J.G.get("S"), "seen"), "ch1_end")):
		var _t49 = J.gp(J.G.get("S"), "scare")
		var _t50 = (J.gp(J.gp(J.gp(J.G.get("S"), "scare"), "best"), "office") if J.t(_t49) else _t49)
		v_b_28 = (_t50 if J.t(_t50) else 0.0)
		var _t51 = J.add(_s20["h"], ("<div class=\"sc-entry\"><div><b>回陽間・夜班嚇人</b><small>舊公司・二十三樓　最高 " + J.str(v_b_28) + "　" + J.str(J.mc("★", "repeat", [J.mc(J.G.get("Scare"), "starsOf", ["office", v_b_28])])) + "</small></div><button class=\"btn gold\" id=\"sc-open\">回去</button></div>"))
		_s20["h"] = _t51
	var _t52 = J.gp(J.gp(J.G.get("S"), "seen"), "ch1_end")
	if J.t(((not J.seq(J.typeof_(J.G.get("Sports")), "undefined")) if J.t(_t52) else _t52)):
		var _t53 = J.add(_s20["h"], ("<div class=\"sc-entry sp-entry\"><div><b>陰間運動會</b><small>殭屍跳遠、舌頭對脖子拔河、倒掛耐力、河童游泳</small></div><button class=\"btn gold\" id=\"sp-open\">參加</button></div>"))
		_s20["h"] = _t53
	var _t54 = J.add(_s20["h"], (J.mc(J.G.get("Station"), "entryHTML", []) if (not J.seq(J.typeof_(J.G.get("Station")), "undefined")) else J.mc(J.G.get("Rework"), "turfHead", [])))
	_s20["h"] = _t54
	J.mc(J.G.get("CHAPTERS"), "forEach", [Callable(self, "_f11").bind(_s20)])
	if (not J.seq(J.typeof_(J.G.get("N30W")), "undefined")):
		var _t59 = J.add(_s20["h"], J.mc(J.G.get("N30W"), "selectHtml", []))
		_s20["h"] = _t59
	return _s20["h"]

func _f15(this_, a: Array, env):
	return J.mc(env["__p"]["this"], "pickSlot", [J.gp(J.gp(env["el"], "dataset"), "slot")])

func _f14(this_, a: Array, env):
	var _s27 = {"__p": env, "el": null}
	_s27["el"] = J.arg(a, 0)
	var _t66 = _s27["el"]
	var _t67 = Callable(self, "_f15").bind(_s27)
	J.sp(_t66, "onclick", _t67)
	return _t67

func _f16(this_, a: Array, env):
	return J.mc(J.G.get("Scare"), "open", ["office"])

func _f17(this_, a: Array, env):
	return J.mc(J.G.get("Sports"), "open", [])

func _f18(this_, a: Array, env):
	return (J.mc(J.G.get("Street"), "open", []) if (not J.seq(J.typeof_(J.G.get("Street")), "undefined")) else J.mc(J.G.get("Station"), "openPanel", []))

func _f20(this_, a: Array, env):
	var v_ci_42 = null; var v_si_43 = null
	var _t78 = J.gp(J.gp(env["b"], "dataset"), "go")
	var _t79 = J.mc(_t78, "split", [","])
	var _t80 = J.mc(_t79, "map", [J.G.get("Number")])
	var _t81 = J.gp(_t80, 0.0)
	v_ci_42 = _t81
	var _t82 = J.gp(_t80, 1.0)
	v_si_43 = _t82
	J.mc(env["__p"]["this"], "tryStart", [v_ci_42, v_si_43])

func _f19(this_, a: Array, env):
	var _s32 = {"__p": env, "b": null}
	_s32["b"] = J.arg(a, 0)
	var _t77 = _s32["b"]
	var _t83 = Callable(self, "_f20").bind(_s32)
	J.sp(_t77, "onclick", _t83)
	return _t83

func _f13(this_, a: Array, env):
	var v_so_37 = null; var v_spo_38 = null; var v_sto_39 = null
	var _t60 = J.G.get("paintPortraits")
	var _t61 = J.G.get("$")
	J.cl(_t60, null, [J.cl(_t61, null, ["#sheet"])])
	if (not J.seq(J.typeof_(J.G.get("N30W")), "undefined")):
		var _t62 = J.G.get("$")
		J.mc(J.G.get("N30W"), "bindSelect", [J.cl(_t62, null, ["#sheet"])])
	var _t63 = J.G.get("$")
	var _t64 = J.cl(_t63, null, ["#sheet"])
	var _t65 = J.mc(_t64, "querySelectorAll", [".tslot"])
	J.mc(_t65, "forEach", [Callable(self, "_f14").bind(env)])
	var _t68 = J.G.get("$")
	v_so_37 = J.cl(_t68, null, ["#sc-open"])
	if J.t(v_so_37):
		var _t69 = Callable(self, "_f16").bind(env)
		J.sp(v_so_37, "onclick", _t69)
	var _t70 = J.G.get("$")
	v_spo_38 = J.cl(_t70, null, ["#sp-open"])
	if J.t(v_spo_38):
		var _t71 = Callable(self, "_f17").bind(env)
		J.sp(v_spo_38, "onclick", _t71)
	var _t72 = J.G.get("$")
	v_sto_39 = J.cl(_t72, null, ["#stn-open"])
	if J.t(v_sto_39):
		var _t73 = Callable(self, "_f18").bind(env)
		J.sp(v_sto_39, "onclick", _t73)
	var _t74 = J.G.get("$")
	var _t75 = J.cl(_t74, null, ["#sheet"])
	var _t76 = J.mc(_t75, "querySelectorAll", ["[data-go]"])
	J.mc(_t76, "forEach", [Callable(self, "_f19").bind(env)])

func _f21(this_, a: Array, env):
	var v_sc_44 = null
	var _t85 = J.G.get("$")
	v_sc_44 = J.gp(J.cl(_t85, null, ["#sheet .sh-body"]), "scrollTop")
	var _t86 = J.G.get("$")
	var _t87 = J.cl(_t86, null, ["#sheet .sh-body"])
	var _t88 = J.cl(env["render"], null, [])
	J.sp(_t87, "innerHTML", _t88)
	J.cl(env["bind"], null, [])
	var _t89 = J.G.get("$")
	var _t90 = J.cl(_t89, null, ["#sheet .sh-body"])
	J.sp(_t90, "scrollTop", v_sc_44)

func _f22(this_, a: Array, env):
	var v_b_45 = null
	var _t92 = J.G.get("$")
	v_b_45 = J.cl(_t92, null, ["#sheet .btn.gold[data-go]"])
	if J.t(v_b_45):
		J.mc(v_b_45, "scrollIntoView", [{"block": "center"}])

func _f9(this_, a: Array, env):
	var _s19 = {"__p": env, "this": null, "render": null, "bind": null}
	_s19["this"] = this_
	_s19["render"] = Callable(self, "_f10").bind(_s19)
	_s19["bind"] = Callable(self, "_f13").bind(_s19)
	J.mc(J.G.get("UI"), "sheet", ["陽間地盤", J.cl(_s19["render"], null, [])])
	J.cl(_s19["bind"], null, [])
	var _t84 = _s19["this"]
	var _t91 = Callable(self, "_f21").bind(_s19)
	J.sp(_t84, "_reSelect", _t91)
	J.F_setTimeout([Callable(self, "_f22").bind(_s19), 30.0])

func _f24(this_, a: Array, env):
	var v_a_53 = null; var v_b_54 = null
	v_a_53 = J.arg(a, 0)
	v_b_54 = J.arg(a, 1)
	return J.sub(J.mc(J.G.get("F"), "glv", [v_b_54]), J.mc(J.G.get("F"), "glv", [v_a_53]))

func _f25(this_, a: Array, env):
	return J.mc(env["this"], "openSelect", [])

func _f28(this_, a: Array, env):
	var v_s_61 = null; var v_v_62 = null
	v_s_61 = J.arg(a, 0)
	v_v_62 = J.arg(a, 1)
	if J.seq(v_s_61, "adv"):
		var _t124 = J.G.get("S")
		J.sp(_t124, "adviser", v_v_62)
	else:
		var _t125 = J.gp(J.G.get("S"), "team")
		var _t126 = J.num(v_s_61)
		J.sp(_t125, _t126, v_v_62)

func _f27(this_, a: Array, env):
	var v_id_59 = null; var v_put_60 = null; var v_from_63 = null
	var _t123 = J.gp(J.gp(env["el"], "dataset"), "g")
	v_id_59 = (_t123 if J.t(_t123) else null)
	v_put_60 = Callable(self, "_f28").bind(env)
	if J.t(v_id_59):
		var _t127 = J.gp(J.G.get("S"), "team")
		var _t129 = null
		if J.cmp(J.mc(_t127, "indexOf", [v_id_59]), 0.0, ">="):
			var _t128 = J.gp(J.G.get("S"), "team")
			_t129 = J.add("", J.mc(_t128, "indexOf", [v_id_59]))
		else:
			_t129 = ("adv" if J.seq(J.gp(J.G.get("S"), "adviser"), v_id_59) else null)
		v_from_63 = _t129
		if (not J.seq(v_from_63, null)):
			J.cl(v_put_60, null, [v_from_63, (env["__p"]["cur"] if J.t(env["__p"]["cur"]) else null)])
	J.cl(v_put_60, null, [env["__p"]["slot"], v_id_59])
	J.cl(J.G.get("save"), null, [])
	J.mc(env["__p"]["this"], "openSelect", [])

func _f26(this_, a: Array, env):
	var _s41 = {"__p": env, "el": null}
	_s41["el"] = J.arg(a, 0)
	var _t122 = _s41["el"]
	var _t130 = Callable(self, "_f27").bind(_s41)
	J.sp(_t122, "onclick", _t130)
	return _t130

func _f23(this_, a: Array, env):
	var v_used_50 = null; var v_list_51 = null; var v_h_52 = null; var v_g_55 = null; var v_sk_56 = null; var v_where_57 = null
	var _s36 = {"__p": env, "this": null, "slot": null, "cur": null}
	_s36["this"] = this_
	_s36["slot"] = J.arg(a, 0)
	_s36["cur"] = (J.gp(J.G.get("S"), "adviser") if J.seq(_s36["slot"], "adv") else J.gp(J.gp(J.G.get("S"), "team"), J.num(_s36["slot"])))
	var _t93 = J.spread([J.SP(J.gp(J.G.get("S"), "team")), J.gp(J.G.get("S"), "adviser")])
	v_used_50 = J.new_("Set", [J.mc(_t93, "filter", [J.G.get("Boolean")])])
	var _t94 = J.mc(J.gp(J.G.get("S"), "ghosts"), "slice", [])
	v_list_51 = J.mc(_t94, "sort", [Callable(self, "_f24").bind(_s36)])
	v_h_52 = ("<p class=\"desc\">選擇" + ("軍師（看智力）" if J.seq(_s36["slot"], "adv") else "出陣鬼怪") + "。已在別的位置的，會互換。</p><div class=\"glist\">")
	if J.t(_s36["cur"]):
		var _t95 = J.add(v_h_52, ("<div class=\"gi\" data-g=\"\"><div><b>— 空著 —</b></div></div>"))
		v_h_52 = _t95
	for _t96 in J.iter(v_list_51):
		v_g_55 = _t96
		v_sk_56 = J.gp(J.G.get("SKILLS"), J.gp(v_g_55, "k"))
		var _t97 = J.gp(J.G.get("S"), "team")
		v_where_57 = ("出陣中" if J.t(J.mc(_t97, "includes", [J.gp(v_g_55, "id")])) else ("軍師" if J.seq(J.gp(J.G.get("S"), "adviser"), J.gp(v_g_55, "id")) else ""))
		var _t99 = ("sel" if J.seq(J.gp(v_g_55, "id"), _s36["cur"]) else "")
		var _t100 = J.gp(v_g_55, "id")
		var _t101 = J.gp(v_g_55, "k")
		var _t102 = J.gp(v_g_55, "name")
		var _t103 = J.gp(v_g_55, "q")
		var _t104 = J.gp(v_g_55, "q")
		var _t105 = (("<i class=\"tag\">" + J.str(v_where_57) + "</i>") if J.t(v_where_57) else "")
		var _t106 = J.mc(J.G.get("F"), "glv", [v_g_55])
		var _t107 = J.mc(J.G.get("GP"), "T", ["鬼力", "鬼力"])
		var _t108 = J.mc(J.G.get("GP"), "pow", [v_g_55])
		var _t109 = J.mc(J.G.get("F"), "stat", [v_g_55, 0.0])
		var _t110 = J.mc(J.G.get("F"), "stat", [v_g_55, 1.0])
		var _t111 = J.mc(J.G.get("F"), "stat", [v_g_55, 2.0])
		var _t98 = J.G.get("gdef")
		var _t112 = J.add(v_h_52, ("<div class=\"gi " + _t99 + "\" data-g=\"" + J.str(_t100) + "\"><canvas data-por=\"" + J.str(_t101) + "\"></canvas><div><b>" + J.str(_t102) + "</b> <i class=\"q q" + J.str(_t103) + "\">" + J.str(_t104) + "</i> " + _t105 + "<small>Lv" + J.str(_t106) + "　<b class=\"gp-pw\">" + J.str(_t107) + " " + J.str(_t108) + "</b>　力" + J.str(_t109) + " 智" + J.str(_t110) + " 武" + J.str(_t111) + "　" + ("遠程" if J.seq(J.gp(J.cl(_t98, null, [v_g_55]), "range"), "ranged") else "近戰") + "<br>" + J.str(J.mc(J.G.get("Rework"), "teamHint", [v_g_55])) + "</small><small class=\"sk\">【" + J.str(J.gp(v_sk_56, "name")) + "】" + J.str(J.gp(v_sk_56, "desc")) + "</small></div></div>"))
		v_h_52 = _t112
	var _t113 = J.add(v_h_52, ("</div><button class=\"btn wide\" id=\"pkback\">返回</button>"))
	v_h_52 = _t113
	J.mc(J.G.get("UI"), "sheet", ["佈陣", v_h_52])
	var _t114 = J.G.get("paintPortraits")
	var _t115 = J.G.get("$")
	J.cl(_t114, null, [J.cl(_t115, null, ["#sheet"])])
	var _t116 = J.G.get("$")
	var _t117 = J.cl(_t116, null, ["#pkback"])
	var _t118 = Callable(self, "_f25").bind(_s36)
	J.sp(_t117, "onclick", _t118)
	var _t119 = J.G.get("$")
	var _t120 = J.cl(_t119, null, ["#sheet"])
	var _t121 = J.mc(_t120, "querySelectorAll", [".gi"])
	J.mc(_t121, "forEach", [Callable(self, "_f26").bind(_s36)])

func _f30(this_, a: Array, env):
	return J.mc(env["this"], "start", [env["ci"], env["si"]])

func _f31(this_, a: Array, env):
	var v_id_73 = null
	v_id_73 = J.arg(a, 0)
	if (not J.t(J.gp(J.gp(J.G.get("S"), "seen"), v_id_73))):
		J.mc(J.G.get("Story"), "queue", [v_id_73])
		env["any"] = true

func _f29(this_, a: Array, env):
	var v_ch_68 = null; var v_st_69 = null; var v_sid_70 = null; var v_go_71 = null
	var _s45 = {"__p": env, "this": null, "ci": null, "si": null, "any": null}
	_s45["this"] = this_
	_s45["ci"] = J.arg(a, 0)
	_s45["si"] = J.arg(a, 1)
	var _t131 = J.gp(J.G.get("S"), "team")
	if (not J.t(J.mc(_t131, "some", [J.G.get("Boolean")]))):
		J.mc(J.G.get("Fx"), "toast", ["至少要派一位鬼怪出陣"])
		return null
	v_ch_68 = J.gp(J.G.get("CHAPTERS"), _s45["ci"])
	v_st_69 = J.gp(J.gp(v_ch_68, "stages"), _s45["si"])
	v_sid_70 = J.mc(_s45["this"], "sidOf", [_s45["ci"], _s45["si"]])
	J.mc(J.G.get("UI"), "close", [])
	v_go_71 = Callable(self, "_f30").bind(_s45)
	_s45["any"] = false
	if J.seq(_s45["si"], 0.0):
		var _t132 = J.gp(v_ch_68, "intro")
		J.mc(_t132, "forEach", [Callable(self, "_f31").bind(_s45)])
	var _t133 = J.gp(v_st_69, "before")
	var _t134 = ((not J.t(J.gp(J.gp(J.G.get("S"), "cleared"), v_sid_70))) if J.t(_t133) else _t133)
	if J.t(((not J.t(J.gp(J.gp(J.G.get("S"), "seen"), J.gp(v_st_69, "before")))) if J.t(_t134) else _t134)):
		J.mc(J.G.get("Story"), "queue", [J.gp(v_st_69, "before")])
		_s45["any"] = true
	if J.t(_s45["any"]):
		J.mc(J.G.get("Story"), "queue", [{"style": "narr", "lines": [["旁白", (J.str(v_sid_70) + "　" + J.str(J.gp(v_st_69, "name")))]]}, v_go_71])
	else:
		J.cl(v_go_71, null, [])

func _f32(this_, a: Array, env):
	var v_g_76 = null; var v_i_77 = null; var v_lv_78 = null; var v_P_79 = null; var v_I_80 = null; var v_A_81 = null; var v_d_82 = null; var v_dm_83 = null; var v_hp_84 = null
	v_g_76 = J.arg(a, 0)
	v_i_77 = J.arg(a, 1)
	v_lv_78 = J.mc(J.G.get("F"), "glv", [v_g_76])
	v_P_79 = J.mc(J.G.get("F"), "stat", [v_g_76, 0.0])
	v_I_80 = J.mc(J.G.get("F"), "stat", [v_g_76, 1.0])
	v_A_81 = J.mc(J.G.get("F"), "stat", [v_g_76, 2.0])
	var _t135 = J.G.get("gdef")
	v_d_82 = J.cl(_t135, null, [v_g_76])
	v_dm_83 = J.mc(J.G.get("GP"), "drillMul", [J.gp(v_g_76, "k")])
	v_hp_84 = J.mul(((300.0 + J.mul(v_P_79, 8.0)) + J.mul(v_A_81, 4.0)), v_dm_83)
	return {"side": 0.0, "k": J.gp(v_g_76, "k"), "gid": J.gp(v_g_76, "id"), "name": J.gp(v_g_76, "name"), "hp": v_hp_84, "maxhp": v_hp_84, "atk": J.mul((20.0 + J.mul(v_A_81, 1.4)), v_dm_83), "range": (150.0 if J.seq(J.gp(v_d_82, "range"), "ranged") else 46.0), "spd": (38.0 if J.seq(J.gp(v_d_82, "range"), "ranged") else 46.0), "x": (78.0 - J.mul(v_i_77, 14.0)), "lane": J.mul(v_i_77, 1.1), "energy": 20.0, "sk": J.gp(J.G.get("SKILLS"), J.gp(v_g_76, "k")), "st": {}, "cd": (randf() * 0.5), "lv": v_lv_78}

func _f34(this_, a: Array, env):
	var v_g_96 = null; var v_i_97 = null
	v_g_96 = J.arg(a, 0)
	v_i_97 = J.arg(a, 1)
	var _t168 = J.gp(env["this"], "units")
	return J.mc(_t168, "push", [J.mc(env["this"], "mkGhostUnit", [v_g_96, v_i_97])])

func _f35(this_, a: Array, env):
	var v_e_100 = null; var v_i_101 = null; var v_T_102 = null; var v_hp_103 = null
	v_e_100 = J.arg(a, 0)
	v_i_101 = J.arg(a, 1)
	v_T_102 = J.gp(J.G.get("ENEMY_T"), v_e_100)
	v_hp_103 = J.mul((260.0 + J.mul(90.0, J.gp(env["st"], "p"))), J.gp(v_T_102, 0.0))
	var _t175 = J.gp(env["this"], "units")
	var _t177 = J.gp(v_T_102, 2.0)
	var _t178 = J.mul((16.0 + J.mul(7.5, J.gp(env["st"], "p"))), J.gp(v_T_102, 1.0))
	var _t176 = ["zhiren", "penanggal"]
	J.mc(_t175, "push", [{"side": 1.0, "k": v_e_100, "name": _t177, "hp": v_hp_103, "maxhp": v_hp_103, "atk": _t178, "range": (140.0 if J.t(J.mc(_t176, "includes", [v_e_100])) else 46.0), "spd": (58.0 if J.seq(v_e_100, "xiaogui") else 42.0), "x": (318.0 + (J.mod(v_i_101, 2.0) * 22.0)), "lane": J.mul(v_i_101, 1.05), "energy": (30.0 if J.seq(v_e_100, J.gp(env["st"], "boss")) else 0.0), "sk": J.gp(J.G.get("SKILLS"), v_e_100), "st": {}, "cd": (randf() * 0.6), "boss": J.seq(v_e_100, J.gp(env["st"], "boss"))}])

func _f33(this_, a: Array, env):
	var v_ci_87 = null; var v_si_88 = null; var v_wild_89 = null; var v_ch_90 = null; var v_team_92 = null; var v_ad_93 = null; var v_sq_94 = null; var v_tb_95 = null; var v_i_98 = null; var v_hp_99 = null
	var _s52 = {"__p": env, "this": null, "st": null}
	_s52["this"] = this_
	v_ci_87 = J.arg(a, 0)
	v_si_88 = J.arg(a, 1)
	v_wild_89 = J.arg(a, 2)
	v_ch_90 = ({"bg": J.gp(v_wild_89, "bg")} if J.t(v_wild_89) else J.gp(J.G.get("CHAPTERS"), v_ci_87))
	_s52["st"] = (J.gp(v_wild_89, "stage") if J.t(v_wild_89) else J.gp(J.gp(v_ch_90, "stages"), v_si_88))
	var _t136 = _s52["this"]
	J.sp(_t136, "ci", v_ci_87)
	var _t137 = _s52["this"]
	J.sp(_t137, "si", v_si_88)
	var _t138 = _s52["this"]
	var _t139 = _s52["st"]
	J.sp(_t138, "stage", _t139)
	var _t140 = _s52["this"]
	var _t141 = (J.gp(v_wild_89, "sid") if J.t(v_wild_89) else J.mc(_s52["this"], "sidOf", [v_ci_87, v_si_88]))
	J.sp(_t140, "sid", _t141)
	var _t142 = _s52["this"]
	var _t143 = J.gp(v_ch_90, "bg")
	J.sp(_t142, "bg", _t143)
	var _t144 = _s52["this"]
	var _t145 = []
	J.sp(_t144, "units", _t145)
	var _t146 = _s52["this"]
	var _t147 = []
	J.sp(_t146, "fx", _t147)
	var _t148 = _s52["this"]
	J.sp(_t148, "t", 0.0)
	var _t149 = _s52["this"]
	J.sp(_t149, "result", null)
	var _t150 = _s52["this"]
	J.sp(_t150, "combo", 0.0)
	var _t151 = _s52["this"]
	J.sp(_t151, "comboT", 0.0)
	var _t152 = _s52["this"]
	J.sp(_t152, "coinsWon", 0.0)
	var _t153 = _s52["this"]
	J.sp(_t153, "timeLimit", 90.0)
	var _t154 = _s52["this"]
	var _t155 = []
	J.sp(_t154, "proj", _t155)
	var _t156 = _s52["this"]
	J.sp(_t156, "hitStop", 0.0)
	var _t157 = _s52["this"]
	J.sp(_t157, "slowT", 0.0)
	var _t158 = _s52["this"]
	J.sp(_t158, "shakeA", 0.0)
	var _t159 = _s52["this"]
	J.sp(_t159, "flashT", 0.0)
	var _t160 = _s52["this"]
	J.sp(_t160, "advCast", null)
	var _t161 = _s52["this"]
	J.sp(_t161, "comboCast", null)
	var _t162 = _s52["this"]
	var _t163 = (-9.0)
	J.sp(_t162, "lastHS", _t163)
	var _t164 = _s52["this"]
	J.sp(_t164, "comboPop", 0.0)
	var _t165 = _s52["this"]
	J.sp(_t165, "hsBank", 0.12)
	var _t166 = J.gp(J.G.get("S"), "team")
	var _t167 = J.mc(_t166, "map", [J.G.get("ghostById")])
	v_team_92 = J.mc(_t167, "filter", [J.G.get("Boolean")])
	J.mc(v_team_92, "forEach", [Callable(self, "_f34").bind(_s52)])
	var _t169 = J.G.get("ghostById")
	v_ad_93 = J.cl(_t169, null, [J.gp(J.G.get("S"), "adviser")])
	var _t170 = _s52["this"]
	var _t171 = ({"k": J.gp(v_ad_93, "k"), "name": J.gp(v_ad_93, "name"), "energy": 0.0, "sk": J.gp(J.G.get("SKILLS"), J.gp(v_ad_93, "k")), "bonus": J.div(J.div(J.mc(J.G.get("F"), "stat", [v_ad_93, 1.0]), 8.0), 100.0), "atk": (20.0 + J.mul(J.mc(J.G.get("F"), "stat", [v_ad_93, 2.0]), 1.4)), "side": 0.0} if J.t(v_ad_93) else null)
	J.sp(_t170, "adviser", _t171)
	v_sq_94 = J.min_([8.0, floor(J.num(J.div(J.gp(J.gp(J.G.get("S"), "res"), "troops"), 25.0)))])
	var _t172 = _s52["this"]
	J.sp(_t172, "squads", v_sq_94)
	v_tb_95 = (1.0 + (0.08 * J.max_([0.0, J.sub(J.gp(J.gp(J.G.get("S"), "bld"), "home"), 1.0)])))
	v_i_98 = 0.0
	while true:
		if not J.cmp(v_i_98, v_sq_94, "<"): break
		v_hp_99 = J.mul((90.0 + J.mul(14.0, J.gp(J.G.get("S"), "lv"))), v_tb_95)
		var _t173 = J.gp(_s52["this"], "units")
		J.mc(_t173, "push", [{"side": 0.0, "k": "youhun", "name": "陰兵", "minion": true, "hp": v_hp_99, "maxhp": v_hp_99, "atk": J.mul((9.0 + J.mul(2.2, J.gp(J.G.get("S"), "lv"))), v_tb_95), "range": 38.0, "spd": 52.0, "x": (120.0 + (floor(J.num(J.div(v_i_98, 4.0))) * 18.0)), "lane": ((J.mod(v_i_98, 4.0) * 0.95) + 0.4), "energy": 0.0, "sk": null, "st": {}, "cd": randf()}])
		v_i_98 = J.num(v_i_98) + 1.0
	var _t174 = J.gp(_s52["st"], "en")
	J.mc(_t174, "forEach", [Callable(self, "_f35").bind(_s52)])
	if (not J.seq(J.typeof_(J.G.get("GhostStreet")), "undefined")):
		J.mc(J.G.get("GhostStreet"), "battleBuffs", [J.gp(_s52["this"], "units")])
	var _t179 = _s52["this"]
	J.sp(_t179, "active", true)
	J.mc(J.G.get("Sound"), "setMode", ["battle"])
	var _t180 = _s52["this"]
	J.sp(_t180, "sndT", 0.0)
	var _t181 = J.G.get("$")
	var _t182 = J.gp(J.cl(_t181, null, ["#battle"]), "classList")
	J.mc(_t182, "add", ["on"])
	J.mc(_s52["this"], "resize", [])
	J.mc(_s52["this"], "buildCards", [])
	J.mc(_s52["this"], "syncBtns", [])
	var _t183 = J.G.get("$")
	var _t184 = J.cl(_t183, null, ["#b-title"])
	var _t185 = (("野鬼　" + J.str(J.gp(_s52["st"], "name"))) if J.t(J.gp(_s52["st"], "wild")) else (J.str(J.gp(_s52["this"], "sid")) + "　" + J.str(J.gp(_s52["st"], "name"))))
	J.sp(_t184, "textContent", _t185)

func _f36(this_, a: Array, env):
	var v_r_106 = null
	v_r_106 = J.mc(J.gp(this_, "cvs"), "getBoundingClientRect", [])
	var _t186 = this_
	var _t187 = J.gp(J.G.get("window"), "devicePixelRatio")
	var _t188 = J.gp(J.G.get("window"), "devicePixelRatio")
	var _t189 = J.min_([2.0, (_t188 if J.t(_t188) else 1.0)])
	J.sp(_t186, "dpr", _t189)
	var _t190 = J.gp(this_, "cvs")
	var _t191 = J.mul(J.gp(v_r_106, "width"), J.gp(this_, "dpr"))
	J.sp(_t190, "width", _t191)
	var _t192 = J.gp(this_, "cvs")
	var _t193 = J.mul(J.gp(v_r_106, "height"), J.gp(this_, "dpr"))
	J.sp(_t192, "height", _t193)
	var _t194 = this_
	var _t195 = J.gp(v_r_106, "width")
	J.sp(_t194, "w", _t195)
	var _t196 = this_
	var _t197 = J.gp(v_r_106, "height")
	J.sp(_t196, "h", _t197)
	var _t198 = this_
	var _t199 = J.div(J.gp(this_, "w"), 390.0)
	J.sp(_t198, "sc", _t199)

func _f39(this_, a: Array, env):
	return J.mc(env["__p"]["this"], "cast", [env["u"]])

func _f38(this_, a: Array, env):
	var v_isAdv_112 = null; var v_d_113 = null; var v_p_114 = null; var v_c_115 = null
	var _s59 = {"__p": env, "u": null}
	_s59["u"] = J.arg(a, 0)
	v_isAdv_112 = J.arg(a, 1)
	v_d_113 = J.S_document_("createElement", ["button"])
	var _t202 = ("bcard" + (" adv" if J.t(v_isAdv_112) else ""))
	J.sp(v_d_113, "className", _t202)
	var _t203 = ("<canvas></canvas><b>" + J.str((J.gp(J.gp(_s59["u"], "sk"), "name") if J.t(J.gp(_s59["u"], "sk")) else "")) + "</b><small>" + ("軍師・" if J.t(v_isAdv_112) else "") + J.str(J.gp(_s59["u"], "name")) + "</small><i class=\"en\"><s></s></i>")
	J.sp(v_d_113, "innerHTML", _t203)
	v_p_114 = J.mc(J.G.get("ART"), "portrait", [J.gp(_s59["u"], "k"), 56.0, {"tamed": true, "untied": true}])
	v_c_115 = J.mc(v_d_113, "querySelector", ["canvas"])
	var _t204 = J.gp(v_p_114, "width")
	J.sp(v_c_115, "width", _t204)
	var _t205 = J.gp(v_p_114, "height")
	J.sp(v_c_115, "height", _t205)
	var _t206 = J.mc(v_c_115, "getContext", ["2d"])
	J.mc(_t206, "drawImage", [v_p_114, 0.0, 0.0])
	var _t207 = Callable(self, "_f39").bind(_s59)
	J.sp(v_d_113, "onclick", _t207)
	var _t208 = _s59["u"]
	J.sp(_t208, "card", v_d_113)
	J.mc(_s59["__p"]["box"], "appendChild", [v_d_113])

func _f40(this_, a: Array, env):
	var v_u_116 = null
	v_u_116 = J.arg(a, 0)
	var _t210 = J.seq(J.gp(v_u_116, "side"), 0.0)
	return ((not J.t(J.gp(v_u_116, "minion"))) if _t210 else _t210)

func _f41(this_, a: Array, env):
	var v_u_117 = null
	v_u_117 = J.arg(a, 0)
	var _t212 = env["mk"]
	return J.cl(_t212, null, [v_u_117, false])

func _f42(this_, a: Array, env):
	var v_u_121 = null
	v_u_121 = J.arg(a, 0)
	var _t217 = J.seq(J.gp(v_u_121, "side"), 0.0)
	return (J.seq(J.gp(v_u_121, "k"), J.gp(env["c"], "a")) if _t217 else _t217)

func _f43(this_, a: Array, env):
	var v_u_122 = null
	v_u_122 = J.arg(a, 0)
	var _t219 = J.seq(J.gp(v_u_122, "side"), 0.0)
	return (J.seq(J.gp(v_u_122, "k"), J.gp(env["c"], "b")) if _t219 else _t219)

func _f44(this_, a: Array, env):
	return J.mc(env["__p"]["this"], "castCombo", [])

func _f37(this_, a: Array, env):
	var v_a_119 = null; var v_b_120 = null; var v_d_123 = null
	var _s58 = {"__p": env, "this": null, "box": null, "mk": null}
	_s58["this"] = this_
	var _t200 = J.G.get("$")
	_s58["box"] = J.cl(_t200, null, ["#b-cards"])
	var _t201 = _s58["box"]
	J.sp(_t201, "innerHTML", "")
	_s58["mk"] = Callable(self, "_f38").bind(_s58)
	var _t209 = J.gp(_s58["this"], "units")
	var _t211 = J.mc(_t209, "filter", [Callable(self, "_f40").bind(_s58)])
	J.mc(_t211, "forEach", [Callable(self, "_f41").bind(_s58)])
	if J.t(J.gp(_s58["this"], "adviser")):
		var _t213 = _s58["mk"]
		J.cl(_t213, null, [J.gp(_s58["this"], "adviser"), true])
	var _t214 = _s58["this"]
	J.sp(_t214, "comboSkill", null)
	if J.cmp(J.gp(J.G.get("S"), "lv"), 17.0, ">="):
		for _t215 in J.iter(J.G.get("COMBOS")):
			var _s63 = {"__p": _s58, "c": null}
			_s63["c"] = _t215
			var _t216 = J.gp(_s63["__p"]["this"], "units")
			v_a_119 = J.mc(_t216, "find", [Callable(self, "_f42").bind(_s63)])
			var _t218 = J.gp(_s63["__p"]["this"], "units")
			v_b_120 = J.mc(_t218, "find", [Callable(self, "_f43").bind(_s63)])
			if J.t((v_b_120 if J.t(v_a_119) else v_a_119)):
				var _t220 = _s63["__p"]["this"]
				var _t221 = {"c": _s63["c"], "a": v_a_119, "b": v_b_120, "energy": 0.0}
				J.sp(_t220, "comboSkill", _t221)
				v_d_123 = J.S_document_("createElement", ["button"])
				J.sp(v_d_123, "className", "bcard combo")
				var _t222 = ("<b>合體技</b><b>" + J.str(J.gp(_s63["c"], "name")) + "</b><small>" + J.str(J.gp(v_a_119, "name")) + "＋" + J.str(J.gp(v_b_120, "name")) + "</small><i class=\"en\"><s></s></i>")
				J.sp(v_d_123, "innerHTML", _t222)
				var _t223 = Callable(self, "_f44").bind(_s63)
				J.sp(v_d_123, "onclick", _t223)
				var _t224 = J.gp(_s63["__p"]["this"], "comboSkill")
				J.sp(_t224, "card", v_d_123)
				J.mc(_s63["__p"]["box"], "appendChild", [v_d_123])
				break

func _f46(this_, a: Array, env):
	var v_v_127 = null
	v_v_127 = J.arg(a, 0)
	var _t226 = (not J.seq(J.gp(v_v_127, "side"), J.gp(env["u"], "side")))
	return (J.cmp(J.gp(v_v_127, "hp"), 0.0, ">") if _t226 else _t226)

func _f45(this_, a: Array, env):
	var _s69 = {"__p": env, "u": null}
	_s69["u"] = J.arg(a, 0)
	var _t225 = J.gp(this_, "units")
	return J.mc(_t225, "filter", [Callable(self, "_f46").bind(_s69)])

func _f47(this_, a: Array, env):
	var v_u_130 = null; var v_best_131 = null; var v_bd_132 = null; var v_v_133 = null; var v_d_134 = null
	v_u_130 = J.arg(a, 0)
	v_best_131 = null
	v_bd_132 = 1000000000.0
	for _t227 in J.iter(J.mc(this_, "enemiesOf", [v_u_130])):
		v_v_133 = _t227
		v_d_134 = (absf(J.num(J.sub(J.gp(v_v_133, "x"), J.gp(v_u_130, "x")))) + (absf(J.num(J.sub(J.gp(v_v_133, "lane"), J.gp(v_u_130, "lane")))) * 18.0))
		if J.cmp(v_d_134, v_bd_132, "<"):
			v_bd_132 = v_d_134
			v_best_131 = v_v_133
	return v_best_131

func _f48(this_, a: Array, env):
	var v_v_137 = null
	v_v_137 = J.arg(a, 0)
	return ("air" if J.cmp(J.gp(J.gp(v_v_137, "st"), "air"), 0.0, ">") else ("down" if J.cmp(J.gp(J.gp(v_v_137, "st"), "down"), 0.0, ">") else null))

func _f49(this_, a: Array, env):
	var v_sec_140 = null; var v_must_141 = null; var v_b_142 = null
	v_sec_140 = J.arg(a, 0)
	v_must_141 = J.arg(a, 1)
	var _t228 = J.gp(this_, "hsBank")
	v_b_142 = (_t228 if J.t(_t228) else 0.0)
	if J.cmp(v_b_142, ((-0.04) if J.t(v_must_141) else v_sec_140), "<"):
		return null
	var _t229 = this_
	var _t230 = J.sub(v_b_142, v_sec_140)
	J.sp(_t229, "hsBank", _t230)
	var _t231 = this_
	var _t232 = J.gp(this_, "hitStop")
	var _t233 = J.gp(this_, "hitStop")
	var _t234 = J.max_([(_t233 if J.t(_t233) else 0.0), J.div(v_sec_140, J.gp(this_, "speed"))])
	J.sp(_t231, "hitStop", _t234)

func _f50(this_, a: Array, env):
	var v_amp_145 = null
	v_amp_145 = J.arg(a, 0)
	var _t235 = this_
	var _t236 = J.gp(this_, "shakeA")
	var _t237 = J.gp(this_, "shakeA")
	var _t238 = J.max_([(_t237 if J.t(_t237) else 0.0), v_amp_145])
	J.sp(_t235, "shakeA", _t238)

func _f51(this_, a: Array, env):
	var v_src_148 = null; var v_v_149 = null; var v_mult_150 = null; var v_sk_151 = null; var v_m_152 = null; var v_bonus_153 = null; var v_comboHit_154 = null; var v_dmg_155 = null; var v_dir_156 = null; var v_s_157 = null; var v_hy_158 = null; var v_big_159 = null
	v_src_148 = J.arg(a, 0)
	v_v_149 = J.arg(a, 1)
	v_mult_150 = J.arg(a, 2)
	v_sk_151 = J.arg(a, 3)
	v_m_152 = v_mult_150
	var _t239 = J.seq(J.gp(v_src_148, "side"), 0.0)
	v_bonus_153 = (J.add(1.0, J.gp(J.gp(this_, "adviser"), "bonus")) if J.t((J.gp(this_, "adviser") if _t239 else _t239)) else 1.0)
	v_comboHit_154 = false
	var _t240 = (J.gp(v_sk_151, "follow") if J.t(v_sk_151) else v_sk_151)
	if J.t((J.seq(J.mc(this_, "stateOf", [v_v_149]), J.gp(v_sk_151, "follow")) if J.t(_t240) else _t240)):
		var _t241 = J.mul(v_m_152, 1.8)
		v_m_152 = _t241
		v_comboHit_154 = true
	v_dmg_155 = J.round(J.num((J.mul(J.mul(J.gp(v_src_148, "atk"), v_m_152), v_bonus_153) * (0.9 + (randf() * 0.2)))))
	var _t242 = J.sub(J.gp(v_v_149, "hp"), v_dmg_155)
	J.sp(v_v_149, "hp", _t242)
	var _t245 = v_sk_151
	if not J.t(_t245):
		var _t244 = J.gp(this_, "t")
		var _t243 = J.gp(this_, "sndT")
		_t245 = (J.sub(_t244, (_t243 if J.t(_t243) else 0.0)) > 0.09)
	if J.t(_t245):
		var _t246 = this_
		var _t247 = J.gp(this_, "t")
		J.sp(_t246, "sndT", _t247)
		J.mc(J.G.get("Sound"), "play", ["hit"])
	var _t248 = signf(J.num(J.sub(J.gp(v_v_149, "x"), (J.gp(v_src_148, "x") if (not J.leq(J.gp(v_src_148, "x"), null)) else J.sub(J.gp(v_v_149, "x"), (1.0 if J.t(J.gp(v_v_149, "side")) else (-1.0)))))))
	v_dir_156 = (_t248 if J.t(_t248) else (1.0 if J.t(J.gp(v_v_149, "side")) else (-1.0)))
	v_s_157 = J.mc(this_, "scaleOf", [v_v_149])
	v_hy_158 = J.sub(J.mc(this_, "uy", [v_v_149]), J.mul(30.0, v_s_157))
	J.sp(v_v_149, "flash", 1.0)
	var _t249 = ((-J.num(v_dir_156)) if J.seq(J.gp(v_src_148, "k"), "heiwu") else v_dir_156)
	J.sp(v_v_149, "kbDir", _t249)
	J.sp(v_v_149, "kbT", 0.0)
	var _t250 = (not J.t(J.gp(v_v_149, "anim")))
	if ((not J.t(J.gp(v_v_149, "casting"))) if _t250 else _t250):
		J.sp(v_v_149, "hurtT", 0.25)
	J.mc(this_, "spark", [J.sub(J.gp(v_v_149, "x"), J.mul(J.mul(v_dir_156, 6.0), v_s_157)), v_hy_158, (1.35 if J.t((v_comboHit_154 if J.t(v_comboHit_154) else v_sk_151)) else (0.7 if J.t(J.gp(v_v_149, "minion")) else 1.0)), ("#ff9a7a" if J.seq(J.gp(v_v_149, "side"), 0.0) else ("#ffd84a" if J.t(v_comboHit_154) else "#fff4c0"))])
	v_big_159 = (v_comboHit_154 if J.t(v_comboHit_154) else (not (not J.t(v_sk_151))))
	var _t251 = J.gp(this_, "fx")
	J.mc(_t251, "push", [{"kind": "num", "x": J.add(J.gp(v_v_149, "x"), ((randf() - 0.5) * 14.0)), "y": J.sub(J.mc(this_, "uy", [v_v_149]), J.mul(70.0, v_s_157)), "vx": J.mul(v_dir_156, (14.0 + (randf() * 18.0))), "text": J.add("", v_dmg_155), "col": ("#ffd84a" if J.t(v_comboHit_154) else ("#ff8a8a" if J.seq(J.gp(v_v_149, "side"), 0.0) else "#fff")), "t": 0.0, "life": 0.95, "big": v_big_159}])
	var _t253 = J.min_([9.0, ((2.5 if J.t(v_sk_151) else 0.8) + (J.div(v_dmg_155, J.gp(v_v_149, "maxhp")) * 26.0))])
	var _t252 = J.gp(v_v_149, "minion")
	J.mc(this_, "kick", [(_t253 * (0.4 if J.t((J.gp(v_src_148, "minion") if J.t(_t252) else _t252)) else 1.0))])
	if J.t(v_sk_151):
		J.mc(this_, "hitStopFor", [0.12, true])
	else:
		var _t254 = (not J.t(J.gp(v_src_148, "minion")))
		var _t257 = (_t254 if _t254 else (not J.t(J.gp(v_v_149, "minion"))))
		if J.t(_t257):
			var _t256 = J.gp(this_, "t")
			var _t255 = J.gp(this_, "lastHS")
			_t257 = (J.sub(_t256, (_t255 if J.t(_t255) else (-9.0))) > 0.4)
		if _t257:
			var _t258 = this_
			var _t259 = J.gp(this_, "t")
			J.sp(_t258, "lastHS", _t259)
			J.mc(this_, "hitStopFor", [(0.08 if J.cmp(v_dmg_155, J.mul(J.gp(v_v_149, "maxhp"), 0.12), ">") else 0.055)])
	if J.t((J.seq(J.gp(v_src_148, "side"), 0.0) if J.t(v_comboHit_154) else v_comboHit_154)):
		J.mc(J.G.get("Sound"), "play", ["combo", J.gp(this_, "combo")])
		var _t260 = this_
		var _t261 = (J.add(J.gp(this_, "combo"), 1.0) if J.cmp(J.gp(this_, "comboT"), 0.0, ">") else 1.0)
		J.sp(_t260, "combo", _t261)
		var _t262 = this_
		J.sp(_t262, "comboT", 3.0)
		var _t263 = this_
		J.sp(_t263, "comboPop", 1.0)
		var _t264 = J.gp(this_, "fx")
		var _t265 = J.gp(this_, "H")
		J.mc(_t264, "push", [{"x": 195.0, "y": J.mul((_t265 if J.t(_t265) else 640.0), 0.3), "text": ("連嚇 ×" + J.str(J.add(J.gp(this_, "combo"), 1.0)) + "！"), "col": "#ffd84a", "t": 0.0, "life": 1.2, "center": true}])
	var _t266 = (J.gp(v_sk_151, "apply") if J.t(v_sk_151) else v_sk_151)
	if J.t((J.cmp(J.gp(v_v_149, "hp"), 0.0, ">") if J.t(_t266) else _t266)):
		if J.seq(J.gp(v_sk_151, "apply"), "air"):
			var _t267 = J.gp(v_v_149, "st")
			var _t268 = J.gp(v_v_149, "st")
			J.sp(_t268, "airMax", 1.0)
			J.sp(_t267, "air", 1.0)
			var _t269 = J.gp(v_v_149, "st")
			J.sp(_t269, "down", 0.0)
		if J.seq(J.gp(v_sk_151, "apply"), "down"):
			var _t270 = J.gp(v_v_149, "st")
			var _t271 = J.gp(v_v_149, "st")
			J.sp(_t271, "downMax", 1.4)
			J.sp(_t270, "down", 1.4)
			var _t272 = J.gp(v_v_149, "st")
			J.sp(_t272, "air", 0.0)
			J.mc(this_, "dust", [J.gp(v_v_149, "x"), J.mc(this_, "uy", [v_v_149]), 1.2])
		if J.seq(J.gp(v_sk_151, "apply"), "push"):
			var _t273 = J.gp(v_v_149, "st")
			J.sp(_t273, "push", 0.25)
		J.sp(v_v_149, "anim", null)
	if J.t((J.gp(v_sk_151, "drain") if J.t(v_sk_151) else v_sk_151)):
		var _t274 = J.min_([J.gp(v_src_148, "maxhp"), J.add(J.gp(v_src_148, "hp"), J.mul(v_dmg_155, J.gp(v_sk_151, "drain")))])
		J.sp(v_src_148, "hp", _t274)
	if J.t((J.gp(v_sk_151, "sap") if J.t(v_sk_151) else v_sk_151)):
		var _t275 = J.max_([0.0, J.sub(J.gp(v_v_149, "energy"), J.gp(v_sk_151, "sap"))])
		J.sp(v_v_149, "energy", _t275)
	var _t276 = (J.gp(v_sk_151, "steal") if J.t(v_sk_151) else v_sk_151)
	if J.t((J.seq(J.gp(v_src_148, "side"), 0.0) if J.t(_t276) else _t276)):
		var _t277 = this_
		var _t278 = J.add(J.gp(_t277, "coinsWon"), J.gp(v_sk_151, "steal"))
		J.sp(_t277, "coinsWon", _t278)
	if (not J.t(v_sk_151)):
		var _t279 = J.min_([100.0, J.add(J.gp(v_src_148, "energy"), 8.0)])
		J.sp(v_src_148, "energy", _t279)
	var _t280 = J.min_([100.0, J.add(J.gp(v_v_149, "energy"), 4.0)])
	J.sp(v_v_149, "energy", _t280)
	if J.cmp(J.gp(v_v_149, "hp"), 0.0, "<="):
		J.sp(v_v_149, "hp", 0.0)
		J.sp(v_v_149, "deadT", 0.0)
		J.sp(v_v_149, "dieDir", v_dir_156)
		J.sp(v_v_149, "anim", null)
		J.sp(v_v_149, "casting", null)
		if (not J.t(J.gp(v_v_149, "minion"))):
			J.mc(this_, "hitStopFor", [(0.14 if J.t(v_sk_151) else 0.09), true])
		J.mc(this_, "kick", [(3.0 if J.t(J.gp(v_v_149, "minion")) else 7.0)])
		J.mc(this_, "spark", [J.gp(v_v_149, "x"), v_hy_158, 1.6, "#fff"])
	return v_dmg_155

func _f53(this_, a: Array, env):
	var v_v_166 = null
	v_v_166 = J.arg(a, 0)
	var _t282 = J.seq(J.gp(v_v_166, "side"), J.gp(env["u"], "side"))
	return (J.cmp(J.gp(v_v_166, "hp"), 0.0, ">") if _t282 else _t282)

func _f54(this_, a: Array, env):
	var v_v_167 = null; var v_h_168 = null
	v_v_167 = J.arg(a, 0)
	v_h_168 = J.mul(J.gp(v_v_167, "maxhp"), J.gp(env["sk"], "mult"))
	var _t284 = J.min_([J.gp(v_v_167, "maxhp"), J.add(J.gp(v_v_167, "hp"), v_h_168)])
	J.sp(v_v_167, "hp", _t284)
	var _t285 = J.gp(env["this"], "fx")
	J.mc(_t285, "push", [{"x": J.gp(v_v_167, "x"), "y": J.sub(J.mc(env["this"], "uy", [v_v_167]), 90.0), "text": J.add("+", J.round(J.num(v_h_168))), "col": "#8affb0", "t": 0.0, "life": 0.9}])
	var _t286 = J.gp(env["this"], "fx")
	J.mc(_t286, "push", [{"kind": "ring", "x": J.gp(v_v_167, "x"), "y": J.sub(J.mc(env["this"], "uy", [v_v_167]), 30.0), "t": 0.0, "life": 0.5, "col": "#8affb0"}])

func _f55(this_, a: Array, env):
	var v_v_169 = null
	v_v_169 = J.arg(a, 0)
	J.sp(v_v_169, "energy", 0.0)
	return 0.0

func _f56(this_, a: Array, env):
	var v_v_170 = null
	v_v_170 = J.arg(a, 0)
	return J.mc(env["this"], "hit", [env["u"], v_v_170, env["mult"], env["sk"]])

func _f52(this_, a: Array, env):
	var v_extraMult_164 = null; var v_v_171 = null; var v_i_172 = null
	var _s88 = {"__p": env, "this": null, "u": null, "sk": null, "mult": null}
	_s88["this"] = this_
	_s88["u"] = J.arg(a, 0)
	_s88["sk"] = J.arg(a, 1)
	v_extraMult_164 = J.arg(a, 2)
	if (not J.t(_s88["sk"])):
		return null
	_s88["mult"] = J.mul(J.gp(_s88["sk"], "mult"), (v_extraMult_164 if J.t(v_extraMult_164) else 1.0))
	if J.seq(J.gp(_s88["sk"], "kind"), "heal"):
		var _t281 = J.gp(_s88["this"], "units")
		var _t283 = J.mc(_t281, "filter", [Callable(self, "_f53").bind(_s88)])
		J.mc(_t283, "forEach", [Callable(self, "_f54").bind(_s88)])
		if J.t(J.gp(_s88["sk"], "forget")):
			var _t287 = J.mc(_s88["this"], "enemiesOf", [_s88["u"]])
			J.mc(_t287, "forEach", [Callable(self, "_f55").bind(_s88)])
	else:
		if J.seq(J.gp(_s88["sk"], "kind"), "aoe"):
			var _t288 = J.mc(_s88["this"], "enemiesOf", [_s88["u"]])
			J.mc(_t288, "forEach", [Callable(self, "_f56").bind(_s88)])
		else:
			v_v_171 = J.mc(_s88["this"], "nearest", [_s88["u"]])
			if J.t(v_v_171):
				if (not J.leq(J.gp(_s88["u"], "x"), null)):
					var _t289 = J.gp(_s88["this"], "fx")
					var _t291 = J.gp(v_v_171, "x")
					var _t292 = J.sub(J.mc(_s88["this"], "uy", [v_v_171]), J.mul(30.0, J.mc(_s88["this"], "scaleOf", [v_v_171])))
					var _t290 = signf(J.num(J.sub(J.gp(v_v_171, "x"), J.gp(_s88["u"], "x"))))
					J.mc(_t289, "push", [{"kind": "slash", "x": _t291, "y": _t292, "dir": (_t290 if J.t(_t290) else 1.0), "t": 0.0, "life": 0.22, "r": 34.0, "col": ("#bff" if J.seq(J.gp(_s88["u"], "side"), 0.0) else "#f9a")}])
				if J.cmp(J.gp(_s88["sk"], "hits"), 1.0, ">"):
					v_i_172 = 0.0
					while true:
						if not J.cmp(v_i_172, J.gp(_s88["sk"], "hits"), "<"): break
						if J.cmp(J.gp(v_v_171, "hp"), 0.0, ">"):
							J.mc(_s88["this"], "hit", [_s88["u"], v_v_171, J.div(_s88["mult"], J.gp(_s88["sk"], "hits")), (_s88["sk"] if J.seq(v_i_172, J.sub(J.gp(_s88["sk"], "hits"), 1.0)) else J.S_Object_("assign", [{}, _s88["sk"], {"apply": null, "drain": J.gp(_s88["sk"], "drain"), "sap": 0.0, "steal": 0.0}]))])
						v_i_172 = J.num(v_i_172) + 1.0
				else:
					J.mc(_s88["this"], "hit", [_s88["u"], v_v_171, _s88["mult"], _s88["sk"]])
	var _t293 = J.gp(_s88["this"], "fx")
	J.mc(_t293, "push", [{"x": (J.gp(_s88["u"], "x") if (not J.leq(J.gp(_s88["u"], "x"), null)) else 60.0), "y": (J.sub(J.mc(_s88["this"], "uy", [_s88["u"]]), 115.0) if (not J.leq(J.gp(_s88["u"], "x"), null)) else 90.0), "text": J.gp(_s88["sk"], "name"), "col": ("#bff" if J.seq(J.gp(_s88["u"], "side"), 0.0) else "#f9a"), "t": 0.0, "life": 1.1, "skill": true}])
	var _t294 = _s88["this"]
	J.sp(_t294, "flashT", 0.12)
	J.mc(_s88["this"], "kick", [(8.0 if J.seq(J.gp(_s88["sk"], "kind"), "aoe") else 5.0)])
	J.mc(J.G.get("Sound"), "play", ["skill"])

func _f57(this_, a: Array, env):
	var v_u_175 = null
	v_u_175 = J.arg(a, 0)
	J.sp(v_u_175, "energy", 0.0)
	if J.leq(J.gp(v_u_175, "x"), null):
		var _t295 = this_
		var _t296 = {"u": v_u_175, "t": 0.0, "dur": J.gp(this_, "CAST"), "slow": false}
		J.sp(_t295, "advCast", _t296)
		return null
	J.sp(v_u_175, "anim", null)
	J.sp(v_u_175, "walking", false)
	var _t297 = {"t": 0.0, "dur": J.gp(this_, "CAST"), "slow": false}
	J.sp(v_u_175, "casting", _t297)

func _f58(this_, a: Array, env):
	var v_c_178 = null; var v_dt_179 = null; var v_u_180 = null
	v_c_178 = J.arg(a, 0)
	v_dt_179 = J.arg(a, 1)
	v_u_180 = J.arg(a, 2)
	var _t298 = J.add(J.gp(v_c_178, "t"), v_dt_179)
	J.sp(v_c_178, "t", _t298)
	var _t299 = (not J.t(J.gp(v_c_178, "slow")))
	if (J.cmp(J.gp(v_c_178, "t"), J.mul(J.gp(v_c_178, "dur"), 0.5), ">=") if _t299 else _t299):
		J.sp(v_c_178, "slow", true)
		var _t300 = (not J.t(v_u_180))
		var _t301 = (_t300 if _t300 else J.seq(J.gp(v_u_180, "side"), 0.0))
		if J.t((_t301 if _t301 else J.gp(v_u_180, "boss"))):
			var _t302 = this_
			var _t303 = J.gp(this_, "slowT")
			var _t304 = J.gp(this_, "slowT")
			var _t305 = J.max_([(_t304 if J.t(_t304) else 0.0), J.div(0.25, J.gp(this_, "speed"))])
			J.sp(_t302, "slowT", _t305)
	return J.cmp(J.gp(v_c_178, "t"), J.gp(v_c_178, "dur"), ">=")

func _f59(this_, a: Array, env):
	var v_u_183 = null
	v_u_183 = J.arg(a, 0)
	J.sp(v_u_183, "casting", null)
	J.mc(this_, "doSkill", [v_u_183, J.gp(v_u_183, "sk")])

func _f60(this_, a: Array, env):
	var v_u_186 = null
	v_u_186 = J.arg(a, 0)
	var _t306 = J.gp(this_, "result")
	if J.t((_t306 if J.t(_t306) else J.cmp(J.gp(v_u_186, "energy"), 100.0, "<"))):
		return null
	var _t307 = (not J.leq(J.gp(v_u_186, "hp"), null))
	if (J.cmp(J.gp(v_u_186, "hp"), 0.0, "<=") if _t307 else _t307):
		return null
	var _t310 = (not J.leq(J.gp(v_u_186, "x"), null))
	if J.t(_t310):
		var _t308 = J.cmp(J.gp(J.gp(v_u_186, "st"), "air"), 0.0, ">")
		var _t309 = (_t308 if _t308 else J.cmp(J.gp(J.gp(v_u_186, "st"), "down"), 0.0, ">"))
		_t310 = (_t309 if _t309 else J.gp(v_u_186, "casting"))
	if J.t(_t310):
		return null
	var _t311 = J.leq(J.gp(v_u_186, "x"), null)
	if J.t((J.gp(this_, "advCast") if _t311 else _t311)):
		return null
	J.mc(this_, "beginCast", [v_u_186])

func _f61(this_, a: Array, env):
	var v_c_189 = null
	v_c_189 = J.gp(this_, "comboSkill")
	var _t312 = (not J.t(v_c_189))
	var _t313 = (_t312 if _t312 else J.cmp(J.gp(v_c_189, "energy"), 100.0, "<"))
	var _t314 = (_t313 if _t313 else J.gp(this_, "result"))
	var _t315 = (_t314 if J.t(_t314) else J.cmp(J.gp(J.gp(v_c_189, "a"), "hp"), 0.0, "<="))
	var _t316 = (_t315 if J.t(_t315) else J.cmp(J.gp(J.gp(v_c_189, "b"), "hp"), 0.0, "<="))
	if J.t((_t316 if J.t(_t316) else J.gp(this_, "comboCast"))):
		return null
	J.sp(v_c_189, "energy", 0.0)
	var _t317 = this_
	var _t318 = {"t": 0.0, "dur": J.gp(this_, "CAST"), "slow": false}
	J.sp(_t317, "comboCast", _t318)

func _f63(this_, a: Array, env):
	var v_v_194 = null
	v_v_194 = J.arg(a, 0)
	J.mc(env["this"], "hit", [env["src"], v_v_194, J.gp(J.gp(env["c"], "c"), "mult"), {"apply": "air"}])
	var _t321 = J.gp(v_v_194, "st")
	var _t322 = J.gp(v_v_194, "st")
	J.sp(_t322, "downMax", 1.6)
	J.sp(_t321, "down", 1.6)
	var _t323 = J.gp(v_v_194, "st")
	J.sp(_t323, "air", 0.0)
	J.mc(env["this"], "dust", [J.gp(v_v_194, "x"), J.mc(env["this"], "uy", [v_v_194]), 1.3])

func _f62(this_, a: Array, env):
	var _s106 = {"__p": env, "this": null, "c": null, "src": null}
	_s106["this"] = this_
	_s106["c"] = J.gp(_s106["this"], "comboSkill")
	var _t319 = _s106["this"]
	J.sp(_t319, "comboCast", null)
	_s106["src"] = {"atk": J.div(J.add(J.gp(J.gp(_s106["c"], "a"), "atk"), J.gp(J.gp(_s106["c"], "b"), "atk")), 2.0), "side": 0.0, "hp": 1.0, "maxhp": 1.0, "x": J.div(J.add(J.gp(J.gp(_s106["c"], "a"), "x"), J.gp(J.gp(_s106["c"], "b"), "x")), 2.0), "lane": 1.0, "energy": 0.0}
	var _t320 = J.mc(_s106["this"], "enemiesOf", [_s106["src"]])
	J.mc(_t320, "forEach", [Callable(self, "_f63").bind(_s106)])
	var _t324 = J.gp(_s106["this"], "fx")
	var _t325 = J.gp(_s106["this"], "H")
	J.mc(_t324, "push", [{"x": 195.0, "y": J.mul((_t325 if J.t(_t325) else 640.0), 0.34), "text": J.gp(J.gp(_s106["c"], "c"), "name"), "col": "#ffb0ff", "t": 0.0, "life": 1.5, "center": true}])
	J.mc(_s106["this"], "kick", [11.0])
	var _t326 = _s106["this"]
	J.sp(_t326, "flashT", 0.25)

func _f64(this_, a: Array, env):
	var v_u_197 = null; var v_H_198 = null
	v_u_197 = J.arg(a, 0)
	var _t327 = J.gp(this_, "H")
	v_H_198 = (_t327 if J.t(_t327) else 640.0)
	return (J.mul(v_H_198, 0.5) + (J.mul(J.gp(v_u_197, "lane"), v_H_198) * 0.1))

func _f65(this_, a: Array, env):
	var v_u_201 = null
	v_u_201 = J.arg(a, 0)
	return (0.75 if J.t(J.gp(v_u_201, "minion")) else (1.7 if J.t(J.gp(v_u_201, "boss")) else 1.32))

func _f66(this_, a: Array, env):
	var v_u_204 = null
	v_u_204 = J.arg(a, 0)
	return (1.15 if J.cmp(J.gp(v_u_204, "range"), 60.0, ">") else 0.95)

func _f67(this_, a: Array, env):
	var v_u_207 = null; var v_tg_208 = null
	v_u_207 = J.arg(a, 0)
	v_tg_208 = J.arg(a, 1)
	return (J.add(J.gp(this_, "WIND"), J.div(J.max_([0.0, (absf(J.num(J.sub(J.gp(v_tg_208, "x"), J.gp(v_u_207, "x")))) - 10.0)]), J.gp(this_, "PSPD"))) if J.cmp(J.gp(v_u_207, "range"), 60.0, ">") else J.add(J.gp(this_, "WIND"), J.gp(this_, "IMPACT")))

func _f68(this_, a: Array, env):
	var v_u_211 = null
	v_u_211 = J.arg(a, 0)
	return (12.0 if J.t(J.gp(v_u_211, "boss")) else (6.0 if J.t(J.gp(v_u_211, "minion")) else 9.0))

func _f69(this_, a: Array, env):
	var v_u_214 = null; var v_dt_215 = null; var v_a_216 = null; var v_ranged_217 = null; var v_tg_218 = null; var v_n_219 = null; var v_s_220 = null
	v_u_214 = J.arg(a, 0)
	v_dt_215 = J.arg(a, 1)
	v_a_216 = J.gp(v_u_214, "anim")
	var _t328 = J.add(J.gp(v_a_216, "t"), v_dt_215)
	J.sp(v_a_216, "t", _t328)
	var _t329 = J.sub(J.gp(v_u_214, "cd"), v_dt_215)
	J.sp(v_u_214, "cd", _t329)
	v_ranged_217 = J.cmp(J.gp(v_u_214, "range"), 60.0, ">")
	var _t330 = J.seq(J.gp(v_a_216, "name"), "windup")
	if (J.cmp(J.gp(v_a_216, "t"), J.gp(this_, "WIND"), ">=") if _t330 else _t330):
		var _t331 = {"name": "strike", "t": J.sub(J.gp(v_a_216, "t"), J.gp(this_, "WIND")), "dur": J.gp(this_, "STRIKE"), "tg": J.gp(v_a_216, "tg")}
		J.sp(v_u_214, "anim", _t331)
		if J.t(v_ranged_217):
			J.mc(this_, "fire", [v_u_214, J.gp(v_a_216, "tg")])
		else:
			J.mc(this_, "dust", [J.gp(v_u_214, "x"), J.mc(this_, "uy", [v_u_214]), 0.6])
		return null
	if J.seq(J.gp(v_a_216, "name"), "strike"):
		var _t332 = (not J.t(v_ranged_217))
		var _t333 = ((not J.t(J.gp(v_a_216, "done"))) if _t332 else _t332)
		if (J.cmp(J.gp(v_a_216, "t"), J.gp(this_, "IMPACT"), ">=") if _t333 else _t333):
			J.sp(v_a_216, "done", true)
			var _t334 = J.gp(v_a_216, "tg")
			var _t335 = (J.cmp(J.gp(J.gp(v_a_216, "tg"), "hp"), 0.0, ">") if J.t(_t334) else _t334)
			v_tg_218 = (J.gp(v_a_216, "tg") if J.t((J.cmp(absf(J.num(J.sub(J.gp(J.gp(v_a_216, "tg"), "x"), J.gp(v_u_214, "x")))), J.add(J.gp(v_u_214, "range"), 24.0), "<=") if J.t(_t335) else _t335)) else null)
			if (not J.t(v_tg_218)):
				v_n_219 = J.mc(this_, "nearest", [v_u_214])
				if J.t((J.cmp(absf(J.num(J.sub(J.gp(v_n_219, "x"), J.gp(v_u_214, "x")))), J.add(J.gp(v_u_214, "range"), 24.0), "<=") if J.t(v_n_219) else v_n_219)):
					v_tg_218 = v_n_219
			if J.t(v_tg_218):
				var _t336 = J.mc(this_, "period", [v_u_214])
				J.sp(v_u_214, "cd", _t336)
				v_s_220 = J.mc(this_, "scaleOf", [v_tg_218])
				var _t337 = J.gp(this_, "fx")
				var _t339 = J.gp(v_tg_218, "x")
				var _t340 = J.sub(J.mc(this_, "uy", [v_tg_218]), J.mul(30.0, v_s_220))
				var _t338 = signf(J.num(J.sub(J.gp(v_tg_218, "x"), J.gp(v_u_214, "x"))))
				J.mc(_t337, "push", [{"kind": "slash", "x": _t339, "y": _t340, "dir": (_t338 if J.t(_t338) else ((-1.0) if J.t(J.gp(v_u_214, "side")) else 1.0)), "t": 0.0, "life": 0.17, "r": ((18.0 if J.t(J.gp(v_u_214, "minion")) else 26.0) * (1.4 if J.t(J.gp(v_u_214, "boss")) else 1.0)), "col": ("#e8fbff" if J.seq(J.gp(v_u_214, "side"), 0.0) else "#ffd0c0")}])
				J.mc(this_, "hit", [v_u_214, v_tg_218, 1.0, null])
		if J.cmp(J.gp(v_a_216, "t"), J.gp(this_, "STRIKE"), ">="):
			var _t341 = {"name": "recover", "t": J.sub(J.gp(v_a_216, "t"), J.gp(this_, "STRIKE")), "dur": J.gp(this_, "REC")}
			J.sp(v_u_214, "anim", _t341)
		return null
	var _t342 = J.seq(J.gp(v_a_216, "name"), "recover")
	if (J.cmp(J.gp(v_a_216, "t"), J.gp(this_, "REC"), ">=") if _t342 else _t342):
		J.sp(v_u_214, "anim", null)

func _f70(this_, a: Array, env):
	var v_u_223 = null; var v_tg_224 = null; var v_s_225 = null; var v_y_226 = null; var v_dist_227 = null
	v_u_223 = J.arg(a, 0)
	v_tg_224 = J.arg(a, 1)
	var _t343 = (not J.t(v_tg_224))
	if (_t343 if _t343 else J.cmp(J.gp(v_tg_224, "hp"), 0.0, "<=")):
		var _t344 = J.mc(this_, "nearest", [v_u_223])
		v_tg_224 = _t344
		if (not J.t(v_tg_224)):
			return null
	v_s_225 = J.mc(this_, "scaleOf", [v_u_223])
	v_y_226 = J.sub(J.mc(this_, "uy", [v_u_223]), J.mul(34.0, v_s_225))
	v_dist_227 = J.max_([0.0, (absf(J.num(J.sub(J.gp(v_tg_224, "x"), J.gp(v_u_223, "x")))) - 10.0)])
	var _t345 = J.add(J.mc(this_, "period", [v_u_223]), J.div(v_dist_227, J.gp(this_, "PSPD")))
	J.sp(v_u_223, "cd", _t345)
	var _t346 = J.gp(this_, "proj")
	J.mc(_t346, "push", [{"src": v_u_223, "tg": v_tg_224, "x": J.add(J.gp(v_u_223, "x"), J.mul(((-14.0) if J.t(J.gp(v_u_223, "side")) else 14.0), v_s_225)), "y": v_y_226, "trail": [], "col": ("#9ff3ff" if J.seq(J.gp(v_u_223, "side"), 0.0) else "#ff9ac0"), "side": J.gp(v_u_223, "side")}])

func _f72(this_, a: Array, env):
	var v_p_231 = null; var v_tx_232 = null; var v_ty_233 = null; var v_dx_234 = null; var v_dy_235 = null; var v_d_236 = null; var v_step_237 = null
	v_p_231 = J.arg(a, 0)
	var _t349 = (not J.t(J.gp(v_p_231, "tg")))
	if (_t349 if _t349 else J.cmp(J.gp(J.gp(v_p_231, "tg"), "hp"), 0.0, "<=")):
		var _t350 = J.mc(env["this"], "nearest", [J.gp(v_p_231, "src")])
		J.sp(v_p_231, "tg", _t350)
		if (not J.t(J.gp(v_p_231, "tg"))):
			return false
	v_tx_232 = J.gp(J.gp(v_p_231, "tg"), "x")
	v_ty_233 = J.sub(J.mc(env["this"], "uy", [J.gp(v_p_231, "tg")]), J.mul(30.0, J.mc(env["this"], "scaleOf", [J.gp(v_p_231, "tg")])))
	v_dx_234 = J.sub(v_tx_232, J.gp(v_p_231, "x"))
	v_dy_235 = J.sub(v_ty_233, J.gp(v_p_231, "y"))
	v_d_236 = J.hypot_([v_dx_234, v_dy_235])
	v_step_237 = J.mul(J.gp(env["this"], "PSPD"), env["dt"])
	var _t351 = J.gp(v_p_231, "trail")
	J.mc(_t351, "push", [[J.gp(v_p_231, "x"), J.gp(v_p_231, "y")]])
	if (J.len(J.gp(v_p_231, "trail")) > 7.0):
		J.mc(J.gp(v_p_231, "trail"), "shift", [])
	if J.cmp(v_d_236, J.add(v_step_237, 4.0), "<="):
		J.mc(env["this"], "hit", [J.gp(v_p_231, "src"), J.gp(v_p_231, "tg"), 1.0, null])
		return false
	var _t352 = J.add(J.gp(v_p_231, "x"), J.mul(J.div(v_dx_234, v_d_236), v_step_237))
	J.sp(v_p_231, "x", _t352)
	var _t353 = J.add(J.gp(v_p_231, "y"), J.mul(J.div(v_dy_235, v_d_236), v_step_237))
	J.sp(v_p_231, "y", _t353)
	return true

func _f71(this_, a: Array, env):
	var _s121 = {"__p": env, "this": null, "dt": null}
	_s121["this"] = this_
	_s121["dt"] = J.arg(a, 0)
	var _t347 = _s121["this"]
	var _t348 = J.gp(_s121["this"], "proj")
	var _t354 = J.mc(_t348, "filter", [Callable(self, "_f72").bind(_s121)])
	J.sp(_t347, "proj", _t354)

func _f73(this_, a: Array, env):
	var v_x_240 = null; var v_y_241 = null; var v_k_242 = null; var v_col_243 = null; var v_n_244 = null; var v_rays_245 = null; var v_i_246 = null
	v_x_240 = J.arg(a, 0)
	v_y_241 = J.arg(a, 1)
	v_k_242 = J.arg(a, 2)
	v_col_243 = J.arg(a, 3)
	v_n_244 = (7.0 + floor(J.num((randf() * 4.0))))
	v_rays_245 = []
	v_i_246 = 0.0
	while true:
		if not J.cmp(v_i_246, v_n_244, "<"): break
		J.mc(v_rays_245, "push", [{"a": (((J.div(v_i_246, v_n_244) * PI) * 2.0) + ((randf() - 0.5) * 0.5)), "len": J.mul((14.0 + (randf() * 16.0)), v_k_242), "j": (randf() * 1000.0)}])
		v_i_246 = J.num(v_i_246) + 1.0
	var _t355 = J.gp(this_, "fx")
	J.mc(_t355, "push", [{"kind": "spark", "x": v_x_240, "y": v_y_241, "t": 0.0, "life": 0.24, "rays": v_rays_245, "col": v_col_243, "k": v_k_242, "rot": (randf() * PI)}])

func _f74(this_, a: Array, env):
	var v_x_249 = null; var v_y_250 = null; var v_k_251 = null; var v_puffs_252 = null; var v_i_253 = null
	v_x_249 = J.arg(a, 0)
	v_y_250 = J.arg(a, 1)
	v_k_251 = J.arg(a, 2)
	v_puffs_252 = []
	v_i_253 = 0.0
	while true:
		if not J.cmp(v_i_253, 5.0, "<"): break
		J.mc(v_puffs_252, "push", [{"dx": J.mul(((randf() - 0.5) * 18.0), v_k_251), "vx": J.mul(((randf() - 0.5) * 60.0), v_k_251), "r": J.mul((4.0 + (randf() * 4.0)), v_k_251)}])
		v_i_253 = J.num(v_i_253) + 1.0
	var _t356 = J.gp(this_, "fx")
	J.mc(_t356, "push", [{"kind": "dust", "x": v_x_249, "y": v_y_250, "t": 0.0, "life": 0.45, "puffs": v_puffs_252}])

func _f76(this_, a: Array, env):
	var v_f_262 = null
	v_f_262 = J.arg(a, 0)
	var _t371 = J.add(J.gp(v_f_262, "t"), env["dtReal"])
	J.sp(v_f_262, "t", _t371)
	return J.cmp(_t371, J.gp(v_f_262, "life"), "<")

func _f77(this_, a: Array, env):
	var v_u_271 = null
	v_u_271 = J.arg(a, 0)
	return J.cmp(J.gp(v_u_271, "hp"), 0.0, ">")

func _f78(this_, a: Array, env):
	var v_u_277 = null
	v_u_277 = J.arg(a, 0)
	return J.gp(v_u_277, "card")

func _f79(this_, a: Array, env):
	var v_u_278 = null
	v_u_278 = J.arg(a, 0)
	var _t423 = J.gp(v_u_278, "card")
	var _t424 = J.gp(J.mc(_t423, "querySelector", [".en s"]), "style")
	var _t425 = J.add(J.gp(v_u_278, "energy"), "%")
	J.sp(_t424, "height", _t425)
	var _t426 = J.gp(J.gp(v_u_278, "card"), "classList")
	var _t427 = J.cmp(J.gp(v_u_278, "energy"), 100.0, ">=")
	var _t428 = (J.cmp(J.gp(v_u_278, "hp"), 0.0, ">") if _t427 else _t427)
	J.mc(_t426, "toggle", ["ready", ((not J.t(J.gp(v_u_278, "casting"))) if _t428 else _t428)])
	var _t429 = J.gp(J.gp(v_u_278, "card"), "classList")
	J.mc(_t429, "toggle", ["dead", J.cmp(J.gp(v_u_278, "hp"), 0.0, "<=")])

func _f80(this_, a: Array, env):
	var v_u_280 = null
	v_u_280 = J.arg(a, 0)
	var _t440 = J.seq(J.gp(v_u_280, "side"), 0.0)
	var _t441 = ((not J.t(J.gp(v_u_280, "minion"))) if _t440 else _t440)
	return (J.cmp(J.gp(v_u_280, "hp"), 0.0, ">") if _t441 else _t441)

func _f81(this_, a: Array, env):
	var v_u_281 = null
	v_u_281 = J.arg(a, 0)
	var _t443 = J.seq(J.gp(v_u_281, "side"), 1.0)
	return (J.cmp(J.gp(v_u_281, "hp"), 0.0, ">") if _t443 else _t443)

func _f75(this_, a: Array, env):
	var v_ts_257 = null; var v_dt_258 = null; var v_alive_259 = null; var v_heroes_260 = null; var v_foes_261 = null; var v_u_263 = null; var v_u_264 = null; var v_tg_265 = null; var v_dx_266 = null; var v_dist_267 = null; var v_u_268 = null; var v_c_269 = null; var v_c_270 = null; var v_i_272 = null; var v_j_273 = null; var v_a_274 = null; var v_b_275 = null; var v_s_276 = null; var v_c_279 = null
	var _s129 = {"__p": env, "dtReal": null}
	_s129["dtReal"] = J.arg(a, 0)
	if (not J.t(J.gp(this_, "active"))):
		return null
	var _t357 = this_
	var _t358 = J.gp(this_, "shakeA")
	var _t359 = J.mul((_t358 if J.t(_t358) else 0.0), exp(J.num(((-J.num(_s129["dtReal"])) * 13.0))))
	J.sp(_t357, "shakeA", _t359)
	if J.cmp(J.gp(this_, "shakeA"), 0.15, "<"):
		var _t360 = this_
		J.sp(_t360, "shakeA", 0.0)
	var _t361 = this_
	var _t362 = J.gp(this_, "flashT")
	var _t363 = J.gp(this_, "flashT")
	var _t364 = J.max_([0.0, J.sub((_t363 if J.t(_t363) else 0.0), _s129["dtReal"])])
	J.sp(_t361, "flashT", _t364)
	var _t365 = this_
	var _t366 = J.gp(this_, "comboPop")
	var _t367 = J.gp(this_, "comboPop")
	var _t368 = J.max_([0.0, J.sub((_t367 if J.t(_t367) else 0.0), J.mul(_s129["dtReal"], 4.0))])
	J.sp(_t365, "comboPop", _t368)
	var _t369 = this_
	var _t370 = J.gp(this_, "fx")
	var _t372 = J.mc(_t370, "filter", [Callable(self, "_f76").bind(_s129)])
	J.sp(_t369, "fx", _t372)
	if J.cmp(J.gp(this_, "hitStop"), 0.0, ">"):
		var _t373 = this_
		var _t374 = J.sub(J.gp(_t373, "hitStop"), _s129["dtReal"])
		J.sp(_t373, "hitStop", _t374)
		return null
	v_ts_257 = 1.0
	if J.cmp(J.gp(this_, "slowT"), 0.0, ">"):
		var _t375 = this_
		var _t376 = J.sub(J.gp(_t375, "slowT"), _s129["dtReal"])
		J.sp(_t375, "slowT", _t376)
		v_ts_257 = 0.35
	v_dt_258 = J.mul(J.mul(_s129["dtReal"], J.gp(this_, "speed")), v_ts_257)
	if J.t(J.gp(this_, "result")):
		for _t377 in J.iter(J.gp(this_, "units")):
			v_u_263 = _t377
			J.mc(this_, "visTick", [v_u_263, v_dt_258])
		return null
	var _t378 = this_
	var _t379 = J.add(J.gp(_t378, "t"), v_dt_258)
	J.sp(_t378, "t", _t379)
	var _t380 = this_
	var _t381 = J.sub(J.gp(_t380, "comboT"), v_dt_258)
	J.sp(_t380, "comboT", _t381)
	var _t382 = this_
	var _t383 = J.gp(this_, "hsBank")
	var _t384 = J.gp(this_, "hsBank")
	var _t385 = J.min_([0.16, J.add((_t384 if J.t(_t384) else 0.0), J.mul(v_dt_258, 0.07))])
	J.sp(_t382, "hsBank", _t385)
	J.mc(this_, "stepProj", [v_dt_258])
	for _t386 in J.iter(J.gp(this_, "units")):
		v_u_264 = _t386
		J.mc(this_, "visTick", [v_u_264, v_dt_258])
		if J.cmp(J.gp(v_u_264, "hp"), 0.0, "<="):
			continue
		if J.cmp(J.gp(J.gp(v_u_264, "st"), "air"), 0.0, ">"):
			if J.t(J.gp(v_u_264, "casting")):
				J.mc(this_, "fireCast", [v_u_264])
			J.sp(v_u_264, "anim", null)
			var _t387 = J.gp(v_u_264, "st")
			var _t388 = J.sub(J.gp(_t387, "air"), v_dt_258)
			J.sp(_t387, "air", _t388)
			if J.cmp(J.gp(J.gp(v_u_264, "st"), "air"), 0.0, "<="):
				J.mc(this_, "dust", [J.gp(v_u_264, "x"), J.mc(this_, "uy", [v_u_264]), 1.1])
				J.mc(this_, "kick", [(5.0 if J.t(J.gp(v_u_264, "boss")) else 2.5)])
			continue
		if J.cmp(J.gp(J.gp(v_u_264, "st"), "down"), 0.0, ">"):
			if J.t(J.gp(v_u_264, "casting")):
				J.mc(this_, "fireCast", [v_u_264])
			J.sp(v_u_264, "anim", null)
			var _t389 = J.gp(v_u_264, "st")
			var _t390 = J.sub(J.gp(_t389, "down"), v_dt_258)
			J.sp(_t389, "down", _t390)
			continue
		if J.cmp(J.gp(J.gp(v_u_264, "st"), "push"), 0.0, ">"):
			J.sp(v_u_264, "anim", null)
			var _t391 = J.gp(v_u_264, "st")
			var _t392 = J.sub(J.gp(_t391, "push"), v_dt_258)
			J.sp(_t391, "push", _t392)
			var _t393 = J.add(J.gp(v_u_264, "x"), J.mul((((-1.0) if J.seq(J.gp(v_u_264, "side"), 0.0) else 1.0) * 160.0), v_dt_258))
			J.sp(v_u_264, "x", _t393)
			var _t394 = J.max_([16.0, J.min_([374.0, J.gp(v_u_264, "x")])])
			J.sp(v_u_264, "x", _t394)
			if (randf() < J.mul(v_dt_258, 30.0)):
				J.mc(this_, "dust", [J.gp(v_u_264, "x"), J.mc(this_, "uy", [v_u_264]), 0.5])
			continue
		if J.t(J.gp(v_u_264, "sk")):
			var _t395 = J.min_([100.0, J.add(J.gp(v_u_264, "energy"), J.mul((11.0 if J.t(J.gp(v_u_264, "boss")) else 9.0), v_dt_258))])
			J.sp(v_u_264, "energy", _t395)
		if J.t(J.gp(v_u_264, "casting")):
			var _t396 = J.sub(J.gp(v_u_264, "cd"), v_dt_258)
			J.sp(v_u_264, "cd", _t396)
			if J.t(J.mc(this_, "tickCast", [J.gp(v_u_264, "casting"), v_dt_258, v_u_264])):
				J.mc(this_, "fireCast", [v_u_264])
			continue
		var _t397 = J.gp(v_u_264, "sk")
		var _t398 = (J.cmp(J.gp(v_u_264, "energy"), 100.0, ">=") if J.t(_t397) else _t397)
		var _t401 = ((not J.t(J.gp(v_u_264, "anim"))) if J.t(_t398) else _t398)
		if J.t(_t401):
			var _t400 = J.seq(J.gp(v_u_264, "side"), 1.0)
			if not J.t(_t400):
				var _t399 = J.gp(this_, "auto")
				_t400 = ((not J.t(J.gp(v_u_264, "minion"))) if J.t(_t399) else _t399)
			_t401 = _t400
		if J.t(_t401):
			J.mc(this_, "beginCast", [v_u_264])
			continue
		if J.t(J.gp(v_u_264, "anim")):
			J.mc(this_, "stepAnim", [v_u_264, v_dt_258])
			continue
		v_tg_265 = J.mc(this_, "nearest", [v_u_264])
		if (not J.t(v_tg_265)):
			continue
		v_dx_266 = J.sub(J.gp(v_tg_265, "x"), J.gp(v_u_264, "x"))
		v_dist_267 = absf(J.num(v_dx_266))
		if J.cmp(v_dist_267, J.gp(v_u_264, "range"), ">"):
			var _t402 = J.add(J.gp(v_u_264, "x"), J.mul(J.mul(signf(J.num(v_dx_266)), J.gp(v_u_264, "spd")), v_dt_258))
			J.sp(v_u_264, "x", _t402)
			J.sp(v_u_264, "walking", true)
		else:
			J.sp(v_u_264, "walking", false)
			var _t403 = J.sub(J.gp(v_u_264, "cd"), v_dt_258)
			J.sp(v_u_264, "cd", _t403)
			if J.cmp(J.gp(v_u_264, "cd"), J.mc(this_, "leadOf", [v_u_264, v_tg_265]), "<="):
				var _t404 = {"name": "windup", "t": 0.0, "dur": J.gp(this_, "WIND"), "tg": v_tg_265}
				J.sp(v_u_264, "anim", _t404)
	if J.t(J.gp(this_, "adviser")):
		var _t405 = J.gp(this_, "adviser")
		var _t406 = J.min_([100.0, J.add(J.gp(J.gp(this_, "adviser"), "energy"), J.mul(7.0, v_dt_258))])
		J.sp(_t405, "energy", _t406)
		var _t407 = J.gp(this_, "auto")
		var _t408 = (J.cmp(J.gp(J.gp(this_, "adviser"), "energy"), 100.0, ">=") if J.t(_t407) else _t407)
		if J.t(((not J.t(J.gp(this_, "advCast"))) if J.t(_t408) else _t408)):
			J.mc(this_, "cast", [J.gp(this_, "adviser")])
	var _t409 = J.gp(this_, "advCast")
	if J.t((J.mc(this_, "tickCast", [J.gp(this_, "advCast"), v_dt_258]) if J.t(_t409) else _t409)):
		v_u_268 = J.gp(J.gp(this_, "advCast"), "u")
		var _t410 = this_
		J.sp(_t410, "advCast", null)
		J.mc(this_, "doSkill", [v_u_268, J.gp(v_u_268, "sk")])
	if J.t(J.gp(this_, "comboSkill")):
		v_c_269 = J.gp(this_, "comboSkill")
		var _t411 = J.cmp(J.gp(J.gp(v_c_269, "a"), "hp"), 0.0, ">")
		if (J.cmp(J.gp(J.gp(v_c_269, "b"), "hp"), 0.0, ">") if _t411 else _t411):
			var _t412 = J.min_([100.0, J.add(J.gp(v_c_269, "energy"), J.mul(5.0, v_dt_258))])
			J.sp(v_c_269, "energy", _t412)
		var _t413 = J.gp(this_, "auto")
		if J.t((J.cmp(J.gp(v_c_269, "energy"), 100.0, ">=") if J.t(_t413) else _t413)):
			J.mc(this_, "castCombo", [])
	var _t414 = J.gp(this_, "comboCast")
	if J.t((J.mc(this_, "tickCast", [J.gp(this_, "comboCast"), v_dt_258]) if J.t(_t414) else _t414)):
		v_c_270 = J.gp(this_, "comboSkill")
		var _t415 = J.cmp(J.gp(J.gp(v_c_270, "a"), "hp"), 0.0, ">")
		if (J.cmp(J.gp(J.gp(v_c_270, "b"), "hp"), 0.0, ">") if _t415 else _t415):
			J.mc(this_, "fireCombo", [])
		else:
			var _t416 = this_
			J.sp(_t416, "comboCast", null)
	var _t417 = J.gp(this_, "units")
	v_alive_259 = J.mc(_t417, "filter", [Callable(self, "_f77").bind(_s129)])
	v_i_272 = 0.0
	while true:
		if not J.cmp(v_i_272, J.len(v_alive_259), "<"): break
		v_j_273 = J.add(v_i_272, 1.0)
		while true:
			if not J.cmp(v_j_273, J.len(v_alive_259), "<"): break
			v_a_274 = J.gp(v_alive_259, v_i_272)
			v_b_275 = J.gp(v_alive_259, v_j_273)
			if (not J.seq(J.gp(v_a_274, "side"), J.gp(v_b_275, "side"))):
				v_j_273 = J.num(v_j_273) + 1.0
				continue
			var _t418 = (absf(J.num(J.sub(J.gp(v_a_274, "x"), J.gp(v_b_275, "x")))) < 22.0)
			if ((absf(J.num(J.sub(J.gp(v_a_274, "lane"), J.gp(v_b_275, "lane")))) < 0.6) if _t418 else _t418):
				v_s_276 = ((-1.0) if J.cmp(J.gp(v_a_274, "x"), J.gp(v_b_275, "x"), "<") else 1.0)
				var _t419 = J.add(J.gp(v_a_274, "x"), J.mul(J.mul(v_s_276, 10.0), v_dt_258))
				J.sp(v_a_274, "x", _t419)
				var _t420 = J.sub(J.gp(v_b_275, "x"), J.mul(J.mul(v_s_276, 10.0), v_dt_258))
				J.sp(v_b_275, "x", _t420)
			v_j_273 = J.num(v_j_273) + 1.0
		v_i_272 = J.num(v_i_272) + 1.0
	var _t421 = J.gp(this_, "units")
	var _t422 = J.mc(_t421, "filter", [Callable(self, "_f78").bind(_s129)])
	J.mc(_t422, "forEach", [Callable(self, "_f79").bind(_s129)])
	if J.t(J.gp(this_, "adviser")):
		var _t430 = J.gp(J.gp(this_, "adviser"), "card")
		var _t431 = J.gp(J.mc(_t430, "querySelector", [".en s"]), "style")
		var _t432 = J.add(J.gp(J.gp(this_, "adviser"), "energy"), "%")
		J.sp(_t431, "height", _t432)
		var _t433 = J.gp(J.gp(J.gp(this_, "adviser"), "card"), "classList")
		var _t434 = J.cmp(J.gp(J.gp(this_, "adviser"), "energy"), 100.0, ">=")
		J.mc(_t433, "toggle", ["ready", ((not J.t(J.gp(this_, "advCast"))) if _t434 else _t434)])
	if J.t(J.gp(this_, "comboSkill")):
		v_c_279 = J.gp(this_, "comboSkill")
		var _t435 = J.gp(v_c_279, "card")
		var _t436 = J.gp(J.mc(_t435, "querySelector", [".en s"]), "style")
		var _t437 = J.add(J.gp(v_c_279, "energy"), "%")
		J.sp(_t436, "height", _t437)
		var _t438 = J.gp(J.gp(v_c_279, "card"), "classList")
		J.mc(_t438, "toggle", ["ready", J.cmp(J.gp(v_c_279, "energy"), 100.0, ">=")])
	var _t439 = J.gp(this_, "units")
	v_heroes_260 = J.len(J.mc(_t439, "filter", [Callable(self, "_f80").bind(_s129)]))
	var _t442 = J.gp(this_, "units")
	v_foes_261 = J.len(J.mc(_t442, "filter", [Callable(self, "_f81").bind(_s129)]))
	var _t444 = J.G.get("$")
	var _t445 = J.cl(_t444, null, ["#b-time"])
	var _t446 = J.add(J.max_([0.0, ceil(J.num(J.sub(J.gp(this_, "timeLimit"), J.gp(this_, "t"))))]), "s")
	J.sp(_t445, "textContent", _t446)
	if (not J.t(v_foes_261)):
		J.mc(this_, "finish", [true])
	else:
		if (not J.t(v_heroes_260)):
			J.mc(this_, "finish", [false])
		else:
			if J.cmp(J.gp(this_, "t"), J.gp(this_, "timeLimit"), ">="):
				J.mc(this_, "finish", [false, false, true])

func _f82(this_, a: Array, env):
	var v_u_284 = null; var v_dt_285 = null
	v_u_284 = J.arg(a, 0)
	v_dt_285 = J.arg(a, 1)
	if J.cmp(J.gp(v_u_284, "hp"), 0.0, "<="):
		var _t447 = J.gp(v_u_284, "deadT")
		var _t448 = J.add((_t447 if J.t(_t447) else 0.0), v_dt_285)
		J.sp(v_u_284, "deadT", _t448)
	var _t449 = J.gp(v_u_284, "flash")
	var _t450 = J.gp(v_u_284, "flash")
	var _t451 = J.max_([0.0, J.sub((_t450 if J.t(_t450) else 0.0), J.div(v_dt_285, 0.18))])
	J.sp(v_u_284, "flash", _t451)
	var _t452 = J.gp(v_u_284, "hurtT")
	var _t453 = J.gp(v_u_284, "hurtT")
	var _t454 = J.max_([0.0, J.sub((_t453 if J.t(_t453) else 0.0), v_dt_285)])
	J.sp(v_u_284, "hurtT", _t454)
	if (not J.leq(J.gp(v_u_284, "kbT"), null)):
		var _t455 = J.add(J.gp(v_u_284, "kbT"), v_dt_285)
		J.sp(v_u_284, "kbT", _t455)
		if J.cmp(J.gp(v_u_284, "kbT"), 0.3, ">"):
			J.sp(v_u_284, "kbT", null)

func _f84(this_, a: Array, env):
	var v_u_298 = null
	v_u_298 = J.arg(a, 0)
	var _t459 = J.gp(v_u_298, "minion")
	return (J.cmp(J.gp(v_u_298, "hp"), 0.0, "<=") if J.t(_t459) else _t459)

func _f85(this_, a: Array, env):
	var v_ok_299 = null
	var _t485 = J.G.get("$")
	v_ok_299 = J.cl(_t485, null, ["#b-ok"])
	if J.t(v_ok_299):
		J.mc(v_ok_299, "onclick", [])

func _f87(this_, a: Array, env):
	var _t493 = J.G.get("joinGhost")
	J.cl(_t493, null, ["baiwu"])
	var _t494 = J.G.get("joinGhost")
	J.cl(_t494, null, ["heiwu"])

func _f88(this_, a: Array, env):
	var _t495 = J.G.get("joinGhost")
	return J.cl(_t495, null, ["mengpo"])

func _f89(this_, a: Array, env):
	var _t496 = J.G.get("S")
	J.sp(_t496, "ended", true)

func _f91(this_, a: Array, env):
	if J.seq(env["i"], 0.0):
		var _t497 = J.gp(env["__p"]["st"], "join")
		var _t498 = (_t497 if J.t(_t497) else [])
		J.mc(_t498, "forEach", [J.G.get("joinGhost")])
	if J.t(J.gp(J.G.get("GIFT_REWARD"), env["id"])):
		var _t499 = J.G.get("give")
		J.mc(J.G.get("Fx"), "toast", [J.add("媽媽燒來的禮物：", J.cl(_t499, null, [J.gp(J.G.get("GIFT_REWARD"), env["id"])]))])

func _f90(this_, a: Array, env):
	var _s175 = {"__p": env, "id": null, "i": null}
	_s175["id"] = J.arg(a, 0)
	_s175["i"] = J.arg(a, 1)
	return J.mc(J.G.get("Story"), "queue", [_s175["id"], Callable(self, "_f91").bind(_s175)])

func _f86(this_, a: Array, env):
	var v_afters_300 = null
	var _t488 = J.gp(env["box"], "classList")
	J.mc(_t488, "remove", ["on"])
	var _t489 = env["this"]
	J.sp(_t489, "active", false)
	var _t490 = J.G.get("$")
	var _t491 = J.gp(J.cl(_t490, null, ["#battle"]), "classList")
	J.mc(_t491, "remove", ["on"])
	if J.t((J.gp(env["st"], "wild") if J.t(env["first"]) else env["first"])):
		if (not J.seq(J.typeof_(J.G.get("N30W")), "undefined")):
			J.mc(J.G.get("N30W"), "onWin", [env["st"]])
	else:
		if J.t(env["first"]):
			var _t492 = J.gp(env["st"], "after")
			v_afters_300 = J.mc((_t492 if J.t(_t492) else []), "slice", [])
			if J.seq(env["sid"], "6-2"):
				J.mc(J.G.get("Story"), "queue", ["ch6_wuchang", Callable(self, "_f87").bind(env)])
				J.mc(J.G.get("Story"), "queue", ["ch6_mengpo", Callable(self, "_f88").bind(env)])
			else:
				if J.seq(env["sid"], "6-3"):
					J.mc(J.G.get("Story"), "queue", ["ch6_end"])
					J.mc(J.G.get("Story"), "queue", ["ch6_reboot", Callable(self, "_f89").bind(env)])
					J.mc(J.G.get("Story"), "queue", ["epilogue"])
				else:
					J.mc(v_afters_300, "forEach", [Callable(self, "_f90").bind(env)])
	if (not J.t(J.mc(J.G.get("Story"), "busy", []))):
		J.mc(J.G.get("Sound"), "setMode", ["village"])
	J.mc(J.G.get("Quest"), "check", [])
	J.cl(J.G.get("save"), null, [])
	J.mc(J.G.get("UI"), "refresh", [])

func _f83(this_, a: Array, env):
	var v_win_288 = null; var v_quit_289 = null; var v_timeout_290 = null; var v_lost_291 = null; var v_rew_295 = null; var v_txt_296 = null
	var _s163 = {"__p": env, "this": null, "st": null, "sid": null, "first": null, "box": null}
	_s163["this"] = this_
	v_win_288 = J.arg(a, 0)
	v_quit_289 = J.arg(a, 1)
	v_timeout_290 = J.arg(a, 2)
	var _t456 = _s163["this"]
	var _t457 = {"win": v_win_288}
	J.sp(_t456, "result", _t457)
	J.mc(J.G.get("Sound"), "play", [("win" if J.t(v_win_288) else "lose")])
	var _t460 = J.gp(J.gp(J.G.get("S"), "res"), "troops")
	var _t458 = J.gp(_s163["this"], "units")
	var _t462 = J.gp(J.gp(J.G.get("S"), "res"), "troops")
	var _t461 = J.gp(_s163["this"], "units")
	v_lost_291 = J.min_([_t462, (J.len(J.mc(_t461, "filter", [Callable(self, "_f84").bind(_s163)])) * 25.0)])
	var _t463 = J.gp(J.G.get("S"), "res")
	var _t464 = J.max_([0.0, J.sub(J.gp(J.gp(J.G.get("S"), "res"), "troops"), v_lost_291)])
	J.sp(_t463, "troops", _t464)
	_s163["st"] = J.gp(_s163["this"], "stage")
	_s163["sid"] = J.gp(_s163["this"], "sid")
	_s163["first"] = ((not J.t(J.gp(J.gp(J.G.get("S"), "cleared"), _s163["sid"]))) if J.t(v_win_288) else v_win_288)
	v_rew_295 = {}
	v_txt_296 = ""
	if J.t(v_win_288):
		var _t465 = ({"coins": (J.mul(60.0, J.gp(_s163["st"], "p")) + 40.0), "exp": (J.mul(30.0, J.gp(_s163["st"], "p")) + 40.0), "chest": J.gp(["g", "b", "p"], J.gp(_s163["this"], "si"))} if J.t(_s163["first"]) else {"coins": J.mul(20.0, J.gp(_s163["st"], "p")), "exp": J.mul(8.0, J.gp(_s163["st"], "p"))})
		v_rew_295 = _t465
		if J.t(J.gp(_s163["this"], "coinsWon")):
			var _t466 = J.add(J.gp(v_rew_295, "coins"), J.gp(_s163["this"], "coinsWon"))
			J.sp(v_rew_295, "coins", _t466)
		var _t467 = J.gp(J.G.get("S"), "cleared")
		var _t468 = _s163["sid"]
		J.sp(_t467, _t468, true)
		var _t469 = J.G.get("give")
		var _t470 = J.cl(_t469, null, [v_rew_295])
		v_txt_296 = _t470
	var _t471 = J.G.get("$")
	_s163["box"] = J.cl(_t471, null, ["#b-result"])
	var _t472 = _s163["box"]
	var _t476 = ("win" if J.t(v_win_288) else "lose")
	var _t477 = (("首次通關！" if J.t(_s163["first"]) else "勝利") if J.t(v_win_288) else ("撤退" if J.t(v_quit_289) else ("時間到" if J.t(v_timeout_290) else "戰敗")))
	var _t478 = (("<p class=\"quip\">" + J.str(J.gp(J.G.get("WIN_QUIPS"), floor(J.num((randf() * J.len(J.G.get("WIN_QUIPS"))))))) + "</p><p>" + J.str(v_txt_296) + "</p>") if J.t(v_win_288) else (("" if J.t(v_quit_289) else ("<p class=\"quip\">" + J.str(J.gp(J.G.get("LOSE_QUIPS"), floor(J.num((randf() * J.len(J.G.get("LOSE_QUIPS"))))))) + "</p>")) + "<p>" + ("" if J.t(v_quit_289) else "提示：換上嚇法對得上的陣容（看敵人怕什麼）；先嚇到敵人失神，再接另一種他怕的，打出連嚇。") + "</p>"))
	var _t479 = (("<p class=\"lost\">陰兵戰死 " + J.str(floor(J.num(v_lost_291))) + "</p>") if J.t(v_lost_291) else "")
	var _t473 = (not J.t(v_win_288))
	var _t475 = null
	if ((not J.t(v_quit_289)) if _t473 else _t473):
		var _t474 = J.gp(J.G.get("S"), "team")
		_t475 = J.mc(J.G.get("GP"), "failHTML", [J.mc(J.G.get("GP"), "avg", [J.mc(_t474, "map", [J.G.get("ghostById")])]), J.mc(J.G.get("GP"), "stageNeed", [_s163["st"], _s163["sid"]])])
	else:
		_t475 = ""
	var _t480 = (not J.t(v_win_288))
	var _t482 = ("" if ((not J.t(v_quit_289)) if _t480 else _t480) else "gold ")
	var _t481 = (_s163["first"] if J.t(v_win_288) else v_win_288)
	var _t483 = ("<div class=\"br " + _t476 + "\"><h2>" + _t477 + "</h2>\n      " + _t478 + "\n      " + _t479 + "\n      " + J.str(_t475) + "\n      <button class=\"btn " + _t482 + "wide\" id=\"b-ok\">" + ("繼續" if J.t((J.gp(_s163["st"], "after") if J.t(_t481) else _t481)) else "回村子") + "</button></div>")
	J.sp(_t472, "innerHTML", _t483)
	var _t484 = J.gp(_s163["box"], "classList")
	J.mc(_t484, "add", ["on"])
	J.mc(J.G.get("GP"), "bindBack", [_s163["box"], Callable(self, "_f85").bind(_s163)])
	var _t486 = J.G.get("$")
	var _t487 = J.cl(_t486, null, ["#b-ok"])
	var _t500 = Callable(self, "_f86").bind(_s163)
	J.sp(_t487, "onclick", _t500)
	J.cl(J.G.get("save"), null, [])

func _f93(this_, a: Array, env):
	var v_p_315 = null
	v_p_315 = J.arg(a, 0)
	return (1.0 - pow(J.num((1.0 - J.min_([1.0, J.max_([0.0, v_p_315])]))), J.num(3.0)))

func _f94(this_, a: Array, env):
	var v_p_316 = null
	v_p_316 = J.arg(a, 0)
	var _t501 = J.min_([1.0, J.max_([0.0, v_p_316])])
	v_p_316 = _t501
	return (J.mul(J.mul(J.mul(4.0, v_p_316), v_p_316), v_p_316) if J.cmp(v_p_316, 0.5, "<") else (1.0 - J.div(pow(J.num((J.mul((-2.0), v_p_316) + 2.0)), J.num(3.0)), 2.0)))

func _f92(this_, a: Array, env):
	var v_u_305 = null; var v_fw_306 = null; var v_eo_307 = null; var v_io_308 = null; var v_pose_309 = null; var v_pt_310 = null; var v_ox_311 = null; var v_oy_312 = null; var v_rot_313 = null; var v_alpha_314 = null; var v_p_317 = null; var v_d_318 = null; var v_p_319 = null; var v_D_320 = null; var v_el_321 = null; var v_a_322 = null; var v_p_323 = null; var v_L_324 = null; var v_ranged_325 = null; var v_p_326 = null; var v_k_327 = null; var v_ph_328 = null; var v_tt_329 = null; var v_tq_330 = null; var v_k_331 = null
	v_u_305 = J.arg(a, 0)
	v_fw_306 = ((-1.0) if J.t(J.gp(v_u_305, "side")) else 1.0)
	v_eo_307 = Callable(self, "_f93").bind(env)
	v_io_308 = Callable(self, "_f94").bind(env)
	v_pose_309 = ("move" if J.t(J.gp(v_u_305, "walking")) else "idle")
	v_pt_310 = 0.0
	v_ox_311 = 0.0
	v_oy_312 = 0.0
	v_rot_313 = 0.0
	v_alpha_314 = 1.0
	if J.cmp(J.gp(v_u_305, "hp"), 0.0, "<="):
		v_p_317 = J.min_([1.0, J.div(J.gp(v_u_305, "deadT"), 0.8)])
		var _t502 = J.gp(v_u_305, "dieDir")
		v_d_318 = (_t502 if J.t(_t502) else (-J.num(v_fw_306)))
		v_pose_309 = "die"
		v_pt_310 = v_p_317
		var _t503 = J.mul(J.mul(v_d_318, 24.0), J.cl(v_eo_307, null, [v_p_317]))
		v_ox_311 = _t503
		var _t504 = ((-sin(J.num((J.min_([1.0, J.mul(v_p_317, 1.4)]) * PI)))) * 12.0)
		v_oy_312 = _t504
		var _t505 = (1.0 if J.cmp(v_p_317, 0.45, "<") else J.max_([0.0, (1.0 - J.div(J.sub(v_p_317, 0.45), 0.55))]))
		v_alpha_314 = _t505
	else:
		if J.cmp(J.gp(J.gp(v_u_305, "st"), "air"), 0.0, ">"):
			var _t507 = J.gp(J.gp(v_u_305, "st"), "air")
			var _t506 = J.gp(J.gp(v_u_305, "st"), "airMax")
			v_p_319 = (1.0 - J.div(_t507, (_t506 if J.t(_t506) else 1.0)))
			v_pose_309 = "air"
			v_pt_310 = v_p_319
			var _t508 = (((-J.num(v_fw_306)) * 12.0) * sin(J.num(J.mul(v_p_319, PI))))
			v_ox_311 = _t508
		else:
			if J.cmp(J.gp(J.gp(v_u_305, "st"), "down"), 0.0, ">"):
				var _t509 = J.gp(J.gp(v_u_305, "st"), "downMax")
				v_D_320 = (_t509 if J.t(_t509) else 1.4)
				v_el_321 = J.sub(v_D_320, J.gp(J.gp(v_u_305, "st"), "down"))
				v_pose_309 = "down"
				var _t510 = J.div(v_el_321, v_D_320)
				v_pt_310 = _t510
				if J.cmp(v_el_321, 0.25, "<"):
					var _t511 = ((-absf(J.num(sin(J.num((J.div(v_el_321, 0.25) * PI)))))) * 7.0)
					v_oy_312 = _t511
			else:
				if J.cmp(J.gp(J.gp(v_u_305, "st"), "push"), 0.0, ">"):
					v_pose_309 = "hurt"
					var _t512 = (1.0 - J.div(J.gp(J.gp(v_u_305, "st"), "push"), 0.25))
					v_pt_310 = _t512
				else:
					if J.t(J.gp(v_u_305, "casting")):
						v_pose_309 = "cast"
						var _t513 = J.min_([1.0, J.div(J.gp(J.gp(v_u_305, "casting"), "t"), J.gp(J.gp(v_u_305, "casting"), "dur"))])
						v_pt_310 = _t513
					else:
						if J.t(J.gp(v_u_305, "anim")):
							v_a_322 = J.gp(v_u_305, "anim")
							v_p_323 = J.div(J.gp(v_a_322, "t"), J.gp(v_a_322, "dur"))
							v_L_324 = J.mc(this_, "lungeOf", [v_u_305])
							v_ranged_325 = J.cmp(J.gp(v_u_305, "range"), 60.0, ">")
							v_pose_309 = J.gp(v_a_322, "name")
							var _t514 = J.min_([1.0, v_p_323])
							v_pt_310 = _t514
							if J.seq(J.gp(v_a_322, "name"), "windup"):
								var _t515 = J.mul(((-J.num(v_fw_306)) * (1.0 if J.t(v_ranged_325) else 2.0)), J.cl(v_eo_307, null, [v_p_323]))
								v_ox_311 = _t515
							else:
								if J.seq(J.gp(v_a_322, "name"), "strike"):
									var _t516 = (J.mul(((-J.num(v_fw_306)) * 5.0), J.cl(v_eo_307, null, [J.mul(v_p_323, 2.0)])) if J.t(v_ranged_325) else J.mul(J.mul(v_fw_306, v_L_324), J.cl(v_eo_307, null, [J.mul(v_p_323, 2.4)])))
									v_ox_311 = _t516
								else:
									var _t517 = ((((-J.num(v_fw_306)) * 5.0) * J.sub(1.0, J.cl(v_io_308, null, [v_p_323]))) if J.t(v_ranged_325) else (J.mul(v_fw_306, v_L_324) * J.sub(1.0, J.cl(v_io_308, null, [v_p_323]))))
									v_ox_311 = _t517
						else:
							if J.cmp(J.gp(v_u_305, "hurtT"), 0.0, ">"):
								v_pose_309 = "hurt"
								var _t518 = (1.0 - J.div(J.gp(v_u_305, "hurtT"), 0.25))
								v_pt_310 = _t518
	var _t519 = (not J.leq(J.gp(v_u_305, "kbT"), null))
	if (J.cmp(J.gp(v_u_305, "hp"), 0.0, ">") if _t519 else _t519):
		v_p_326 = J.div(J.gp(v_u_305, "kbT"), 0.3)
		v_k_327 = (J.cl(v_eo_307, null, [J.div(v_p_326, 0.25)]) if J.cmp(v_p_326, 0.25, "<") else J.sub(1.0, J.cl(v_io_308, null, [J.div(J.sub(v_p_326, 0.25), 0.75)])))
		var _t520 = J.gp(v_u_305, "kbDir")
		var _t522 = (_t520 if J.t(_t520) else (-J.num(v_fw_306)))
		var _t521 = J.gp(v_u_305, "kbAmp")
		var _t523 = J.add(v_ox_311, J.mul(J.mul(_t522, (_t521 if J.t(_t521) else 6.0)), v_k_327))
		v_ox_311 = _t523
	var _t524 = J.seq(v_pose_309, "idle")
	if (J.cmp(J.gp(v_u_305, "hp"), 0.0, ">") if _t524 else _t524):
		var _t525 = J.gp(v_u_305, "lane")
		v_ph_328 = (J.mul((_t525 if J.t(_t525) else 0.0), 1.7) + (0.9 if J.t(J.gp(v_u_305, "side")) else 0.0))
		v_tt_329 = J.add(J.gp(this_, "t"), v_ph_328)
		var _t526 = J.add(v_oy_312, ((-absf(J.num(sin(J.num(J.mul(v_tt_329, 4.2)))))) * 2.2))
		v_oy_312 = _t526
		v_tq_330 = J.div(J.mod(v_tt_329, 4.6), 4.6)
		var _t527 = (not J.t(J.gp(v_u_305, "minion")))
		if (J.cmp(v_tq_330, 0.82, ">") if _t527 else _t527):
			v_k_331 = sin(J.num((J.div(J.sub(v_tq_330, 0.82), 0.18) * PI)))
			var _t528 = J.add(v_ox_311, J.mul(J.mul(v_fw_306, 4.0), v_k_331))
			v_ox_311 = _t528
			var _t529 = J.add(v_rot_313, J.mul(((-J.num(v_fw_306)) * 0.05), v_k_331))
			v_rot_313 = _t529
	return {"pose": v_pose_309, "pt": v_pt_310, "ox": v_ox_311, "oy": v_oy_312, "rot": v_rot_313, "alpha": v_alpha_314}

func _f96(this_, a: Array, env):
	var v_a_344 = null; var v_b_345 = null
	v_a_344 = J.arg(a, 0)
	v_b_345 = J.arg(a, 1)
	return J.sub(J.gp(v_a_344, "lane"), J.gp(v_b_345, "lane"))

func _f97(this_, a: Array, env):
	var v_u_361 = null
	v_u_361 = J.arg(a, 0)
	var _t565 = J.cmp(J.gp(v_u_361, "hp"), 0.0, ">")
	return (J.mc(env["__p"]["this"], "drawCharge", [env["__p"]["ctx"], J.gp(v_u_361, "x"), J.sub(J.mc(env["__p"]["this"], "uy", [v_u_361]), J.mul(28.0, J.mc(env["__p"]["this"], "scaleOf", [v_u_361]))), J.mc(env["__p"]["this"], "scaleOf", [v_u_361]), env["p"], "#ffb0ff", true]) if _t565 else _t565)

func _f95(this_, a: Array, env):
	var v_k_335 = null; var v_A_336 = null; var v_shx_337 = null; var v_shy_338 = null; var v_H_339 = null; var v_list_340 = null; var v_gy_341 = null; var v_gg_342 = null; var v_f_343 = null; var v_u_346 = null; var v_P_347 = null; var v_s_348 = null; var v_x_349 = null; var v_y0_350 = null; var v_y_351 = null; var v_tg_352 = null; var v_o_353 = null; var v_bx_354 = null; var v_bw_355 = null; var v_by_356 = null; var v_ty_357 = null; var v_tx_358 = null; var v_c_359 = null; var v_p_362 = null; var v_f_363 = null; var v_p_364 = null; var v_z_365 = null
	var _s190 = {"__p": env, "this": null, "ctx": null}
	_s190["this"] = this_
	if (not J.t(J.gp(_s190["this"], "active"))):
		return null
	_s190["ctx"] = J.gp(_s190["this"], "ctx")
	v_k_335 = J.mul(J.gp(_s190["this"], "sc"), J.gp(_s190["this"], "dpr"))
	var _t530 = J.gp(_s190["this"], "shakeA")
	v_A_336 = (_t530 if J.t(_t530) else 0.0)
	v_shx_337 = (J.mul(((randf() - 0.5) * 2.0), v_A_336) if J.t(v_A_336) else 0.0)
	v_shy_338 = (J.mul(((randf() - 0.5) * 1.2), v_A_336) if J.t(v_A_336) else 0.0)
	J.mc(_s190["ctx"], "setTransform", [v_k_335, 0.0, 0.0, v_k_335, J.mul(v_shx_337, v_k_335), J.mul(v_shy_338, v_k_335)])
	var _t531 = _s190["this"]
	var _t532 = J.div(J.gp(_s190["this"], "h"), J.gp(_s190["this"], "sc"))
	J.sp(_t531, "H", _t532)
	v_H_339 = _t532
	if (not J.t(J.mc(J.G.get("SCENE"), "drawBg", [_s190["ctx"], 390.0, v_H_339, J.gp(_s190["this"], "bg")]))):
		var _t533 = J.G.get("paintBg")
		J.cl(_t533, null, [_s190["ctx"], 390.0, J.mul(v_H_339, 0.545), J.gp(_s190["this"], "bg"), J.gp(_s190["this"], "t")])
		v_gy_341 = J.mul(v_H_339, 0.36)
		v_gg_342 = J.mc(_s190["ctx"], "createLinearGradient", [0.0, v_gy_341, 0.0, v_H_339])
		J.mc(v_gg_342, "addColorStop", [0.0, "#2a2622"])
		J.mc(v_gg_342, "addColorStop", [0.5, "#1c1a1a"])
		J.mc(v_gg_342, "addColorStop", [1.0, "#121012"])
		var _t534 = _s190["ctx"]
		J.sp(_t534, "fillStyle", v_gg_342)
		J.mc(_s190["ctx"], "fillRect", [0.0, v_gy_341, 390.0, J.sub(v_H_339, v_gy_341)])
	if J.cmp(J.gp(_s190["this"], "slowT"), 0.0, ">"):
		var _t535 = _s190["ctx"]
		var _t536 = ("rgba(8,4,20," + J.str(J.min_([0.35, J.mul(J.gp(_s190["this"], "slowT"), 2.4)])) + ")")
		J.sp(_t535, "fillStyle", _t536)
		J.mc(_s190["ctx"], "fillRect", [(-20.0), (-20.0), 430.0, J.add(v_H_339, 40.0)])
	for _t537 in J.iter(J.gp(_s190["this"], "fx")):
		v_f_343 = _t537
		if J.seq(J.gp(v_f_343, "kind"), "dust"):
			J.mc(_s190["this"], "drawDust", [_s190["ctx"], v_f_343])
	var _t538 = J.mc(J.gp(_s190["this"], "units"), "slice", [])
	v_list_340 = J.mc(_t538, "sort", [Callable(self, "_f96").bind(_s190)])
	for _t539 in J.iter(v_list_340):
		v_u_346 = _t539
		var _t540 = J.cmp(J.gp(v_u_346, "hp"), 0.0, "<=")
		if (J.cmp(J.gp(v_u_346, "deadT"), 0.8, ">") if _t540 else _t540):
			continue
		v_P_347 = J.mc(_s190["this"], "poseOf", [v_u_346])
		v_s_348 = J.mc(_s190["this"], "scaleOf", [v_u_346])
		v_x_349 = J.add(J.gp(v_u_346, "x"), J.gp(v_P_347, "ox"))
		v_y0_350 = J.mc(_s190["this"], "uy", [v_u_346])
		v_y_351 = J.add(v_y0_350, J.gp(v_P_347, "oy"))
		if J.t(J.gp(v_u_346, "casting")):
			J.mc(_s190["this"], "drawCharge", [_s190["ctx"], v_x_349, J.sub(v_y0_350, J.mul(28.0, v_s_348)), v_s_348, J.div(J.gp(J.gp(v_u_346, "casting"), "t"), J.gp(J.gp(v_u_346, "casting"), "dur")), ("#9ff3ff" if J.seq(J.gp(v_u_346, "side"), 0.0) else "#ff9ac0"), false])
		var _t541 = J.gp(v_u_346, "anim")
		var _t542 = (J.gp(J.gp(v_u_346, "anim"), "tg") if J.t(_t541) else _t541)
		v_tg_352 = (J.gp(J.gp(v_u_346, "anim"), "tg") if J.t((J.cmp(J.gp(J.gp(J.gp(v_u_346, "anim"), "tg"), "hp"), 0.0, ">") if J.t(_t542) else _t542)) else null)
		v_o_353 = {"tdx": (J.sub(J.gp(v_tg_352, "x"), J.gp(v_u_346, "x")) if J.t(v_tg_352) else ((-40.0) if J.t(J.gp(v_u_346, "side")) else 40.0)), "tdy": (J.sub(J.mc(_s190["this"], "uy", [v_tg_352]), J.mc(_s190["this"], "uy", [v_u_346])) if J.t(v_tg_352) else 0.0), "t": J.add(J.gp(_s190["this"], "t"), J.gp(v_u_346, "lane")), "walk": J.seq(J.gp(v_P_347, "pose"), "move"), "pose": J.gp(v_P_347, "pose"), "pt": J.gp(v_P_347, "pt"), "flip": J.seq(J.gp(v_u_346, "side"), 1.0), "enemy": J.seq(J.gp(v_u_346, "side"), 1.0), "alpha": J.gp(v_P_347, "alpha"), "rot": J.gp(v_P_347, "rot"), "tamed": J.seq(J.gp(v_u_346, "side"), 0.0), "untied": J.seq(J.gp(v_u_346, "side"), 0.0)}
		J.mc(J.G.get("ART"), "drawChar", [_s190["ctx"], J.gp(v_u_346, "k"), v_x_349, v_y_351, v_s_348, v_o_353])
		if J.cmp(J.gp(v_u_346, "flash"), 0.0, ">"):
			J.mc(_s190["ctx"], "save", [])
			var _t543 = _s190["ctx"]
			J.sp(_t543, "globalCompositeOperation", "lighter")
			J.mc(J.G.get("ART"), "drawChar", [_s190["ctx"], J.gp(v_u_346, "k"), v_x_349, v_y_351, v_s_348, J.S_Object_("assign", [{}, v_o_353, {"alpha": (J.mul(J.gp(v_P_347, "alpha"), J.gp(v_u_346, "flash")) * 0.85), "shadow": false}])])
			J.mc(_s190["ctx"], "restore", [])
		if J.t(J.gp(v_u_346, "casting")):
			J.mc(_s190["this"], "drawCharge", [_s190["ctx"], v_x_349, J.sub(v_y0_350, J.mul(28.0, v_s_348)), v_s_348, J.div(J.gp(J.gp(v_u_346, "casting"), "t"), J.gp(J.gp(v_u_346, "casting"), "dur")), ("#9ff3ff" if J.seq(J.gp(v_u_346, "side"), 0.0) else "#ff9ac0"), true])
		if J.cmp(J.gp(v_u_346, "hp"), 0.0, ">"):
			v_bx_354 = J.add(J.gp(v_u_346, "x"), J.mul(J.gp(v_P_347, "ox"), 0.4))
			v_bw_355 = (26.0 if J.t(J.gp(v_u_346, "minion")) else (64.0 if J.t(J.gp(v_u_346, "boss")) else 46.0))
			v_by_356 = J.sub(v_y0_350, (36.0 if J.t(J.gp(v_u_346, "minion")) else (92.0 if J.t(J.gp(v_u_346, "boss")) else 72.0)))
			J.mc(J.G.get("ART"), "rr", [_s190["ctx"], J.sub(v_bx_354, J.div(v_bw_355, 2.0)), v_by_356, v_bw_355, 5.0, 2.0, "rgba(0,0,0,.6)"])
			J.mc(J.G.get("ART"), "rr", [_s190["ctx"], J.sub(v_bx_354, J.div(v_bw_355, 2.0)), v_by_356, J.div(J.mul(v_bw_355, J.gp(v_u_346, "hp")), J.gp(v_u_346, "maxhp")), 5.0, 2.0, ("#e84a5f" if J.t(J.gp(v_u_346, "side")) else "#4ade80")])
			var _t544 = J.gp(v_u_346, "sk")
			if J.t(((not J.t(J.gp(v_u_346, "minion"))) if J.t(_t544) else _t544)):
				J.mc(J.G.get("ART"), "rr", [_s190["ctx"], J.sub(v_bx_354, J.div(v_bw_355, 2.0)), J.add(v_by_356, 6.0), J.div(J.mul(v_bw_355, J.gp(v_u_346, "energy")), 100.0), 3.0, 1.5, ("#ffd84a" if J.cmp(J.gp(v_u_346, "energy"), 100.0, ">=") else "#7dd3fc")])
			if J.t(J.gp(v_u_346, "boss")):
				var _t545 = _s190["ctx"]
				J.sp(_t545, "fillStyle", "#ffd0d8")
				var _t546 = _s190["ctx"]
				var _t547 = "bold 12px \"PingFang TC\",\"Noto Sans TC\",sans-serif"
				J.sp(_t546, "font", _t547)
				var _t548 = _s190["ctx"]
				J.sp(_t548, "textAlign", "center")
				J.mc(_s190["ctx"], "fillText", [J.gp(v_u_346, "name"), v_bx_354, J.sub(v_by_356, 4.0)])
			var _t549 = J.cmp(J.gp(J.gp(v_u_346, "st"), "air"), 0.0, ">")
			if (_t549 if _t549 else J.cmp(J.gp(J.gp(v_u_346, "st"), "down"), 0.0, ">")):
				var _t550 = _s190["ctx"]
				var _t551 = ("#9ff" if J.cmp(J.gp(J.gp(v_u_346, "st"), "air"), 0.0, ">") else "#fc9")
				J.sp(_t550, "fillStyle", _t551)
				var _t552 = _s190["ctx"]
				J.sp(_t552, "font", "bold 11px sans-serif")
				var _t553 = _s190["ctx"]
				J.sp(_t553, "textAlign", "center")
				J.mc(_s190["ctx"], "fillText", [("嚇彈起" if J.cmp(J.gp(J.gp(v_u_346, "st"), "air"), 0.0, ">") else "腳軟"), v_bx_354, J.sub(v_by_356, (18.0 if J.t(J.gp(v_u_346, "boss")) else 4.0))])
			var _t554 = J.seq(J.gp(v_u_346, "side"), 1.0)
			var _t555 = (J.gp(v_u_346, "fearT") if _t554 else _t554)
			if J.t((J.cmp(J.gp(J.gp(v_u_346, "fearT"), "until"), J.gp(_s190["this"], "t"), ">") if J.t(_t555) else _t555)):
				J.mc(_s190["ctx"], "save", [])
				var _t556 = _s190["ctx"]
				var _t557 = "bold 11px \"PingFang TC\",\"Noto Sans TC\",sans-serif"
				J.sp(_t556, "font", _t557)
				var _t558 = _s190["ctx"]
				J.sp(_t558, "textAlign", "center")
				var _t559 = _s190["ctx"]
				J.sp(_t559, "lineWidth", 3.0)
				var _t560 = _s190["ctx"]
				J.sp(_t560, "strokeStyle", "rgba(20,0,30,.8)")
				var _t561 = _s190["ctx"]
				J.sp(_t561, "fillStyle", "#e6c4ff")
				var _t563 = J.sub(v_by_356, (18.0 if J.t(J.gp(v_u_346, "boss")) else 6.0))
				var _t562 = J.cmp(J.gp(J.gp(v_u_346, "st"), "air"), 0.0, ">")
				v_ty_357 = (_t563 - (13.0 if (_t562 if _t562 else J.cmp(J.gp(J.gp(v_u_346, "st"), "down"), 0.0, ">")) else 0.0))
				v_tx_358 = ("失神・" + J.str(J.mc(J.G.get("Rework"), "word", [J.gp(J.gp(v_u_346, "fearT"), "t")])))
				J.mc(_s190["ctx"], "strokeText", [v_tx_358, v_bx_354, v_ty_357])
				J.mc(_s190["ctx"], "fillText", [v_tx_358, v_bx_354, v_ty_357])
				J.mc(_s190["ctx"], "restore", [])
	if J.t(J.gp(_s190["this"], "advCast")):
		J.mc(_s190["this"], "drawCharge", [_s190["ctx"], 34.0, J.mul(v_H_339, 0.36), 1.0, J.div(J.gp(J.gp(_s190["this"], "advCast"), "t"), J.gp(J.gp(_s190["this"], "advCast"), "dur")), "#c8ffb0", true])
	if J.t(J.gp(_s190["this"], "comboCast")):
		var _s203 = {"__p": _s190, "p": null}
		v_c_359 = J.gp(_s203["__p"]["this"], "comboSkill")
		_s203["p"] = J.div(J.gp(J.gp(_s203["__p"]["this"], "comboCast"), "t"), J.gp(J.gp(_s203["__p"]["this"], "comboCast"), "dur"))
		var _t564 = [J.gp(v_c_359, "a"), J.gp(v_c_359, "b")]
		J.mc(_t564, "forEach", [Callable(self, "_f97").bind(_s203)])
	for _t566 in J.iter(J.gp(_s190["this"], "proj")):
		v_p_362 = _t566
		J.mc(_s190["this"], "drawProj", [_s190["ctx"], v_p_362])
	if J.cmp(J.gp(_s190["this"], "flashT"), 0.0, ">"):
		var _t567 = _s190["ctx"]
		var _t568 = ("rgba(255,255,255," + J.str(J.mul(J.gp(_s190["this"], "flashT"), 1.5)) + ")")
		J.sp(_t567, "fillStyle", _t568)
		J.mc(_s190["ctx"], "fillRect", [(-20.0), (-20.0), 430.0, J.add(v_H_339, 40.0)])
	for _t569 in J.iter(J.gp(_s190["this"], "fx")):
		v_f_363 = _t569
		if J.seq(J.gp(v_f_363, "kind"), "spark"):
			J.mc(_s190["this"], "drawSpark", [_s190["ctx"], v_f_363])
		else:
			if J.seq(J.gp(v_f_363, "kind"), "slash"):
				J.mc(_s190["this"], "drawSlash", [_s190["ctx"], v_f_363])
			else:
				if J.seq(J.gp(v_f_363, "kind"), "ring"):
					v_p_364 = J.div(J.gp(v_f_363, "t"), J.gp(v_f_363, "life"))
					J.mc(_s190["ctx"], "save", [])
					var _t570 = _s190["ctx"]
					var _t571 = J.sub(1.0, v_p_364)
					J.sp(_t570, "globalAlpha", _t571)
					var _t572 = _s190["ctx"]
					var _t573 = J.gp(v_f_363, "col")
					J.sp(_t572, "strokeStyle", _t573)
					var _t574 = _s190["ctx"]
					var _t575 = ((3.0 * J.sub(1.0, v_p_364)) + 1.0)
					J.sp(_t574, "lineWidth", _t575)
					J.mc(_s190["ctx"], "beginPath", [])
					J.mc(_s190["ctx"], "ellipse", [J.gp(v_f_363, "x"), J.gp(v_f_363, "y"), (14.0 + J.mul(v_p_364, 26.0)), ((14.0 + J.mul(v_p_364, 26.0)) * 0.5), 0.0, 0.0, (PI * 2.0)])
					J.mc(_s190["ctx"], "stroke", [])
					J.mc(_s190["ctx"], "restore", [])
				else:
					if (not J.seq(J.gp(v_f_363, "kind"), "dust")):
						J.mc(_s190["this"], "drawText", [_s190["ctx"], v_f_363])
	var _t576 = J.cmp(J.gp(_s190["this"], "comboT"), 0.0, ">")
	if (J.cmp(J.gp(_s190["this"], "combo"), 0.0, ">") if _t576 else _t576):
		var _t577 = J.gp(_s190["this"], "comboPop")
		v_z_365 = (1.0 + J.mul((_t577 if J.t(_t577) else 0.0), 0.7))
		J.mc(_s190["ctx"], "save", [])
		J.mc(_s190["ctx"], "translate", [380.0, 40.0])
		J.mc(_s190["ctx"], "scale", [v_z_365, v_z_365])
		var _t578 = _s190["ctx"]
		J.sp(_t578, "textAlign", "right")
		var _t579 = _s190["ctx"]
		J.sp(_t579, "font", "900 16px sans-serif")
		var _t580 = _s190["ctx"]
		J.sp(_t580, "lineWidth", 4.0)
		var _t581 = _s190["ctx"]
		J.sp(_t581, "strokeStyle", "rgba(10,6,20,.9)")
		J.mc(_s190["ctx"], "strokeText", [("COMBO " + J.str(J.gp(_s190["this"], "combo"))), 0.0, 0.0])
		var _t582 = _s190["ctx"]
		J.sp(_t582, "fillStyle", "#ffd84a")
		J.mc(_s190["ctx"], "fillText", [("COMBO " + J.str(J.gp(_s190["this"], "combo"))), 0.0, 0.0])
		J.mc(_s190["ctx"], "restore", [])

func _f98(this_, a: Array, env):
	var v_ctx_368 = null; var v_f_369 = null; var v_t_370 = null; var v_a_371 = null; var v_pop_372 = null; var v_x_373 = null; var v_y_374 = null; var v_size_375 = null
	v_ctx_368 = J.arg(a, 0)
	v_f_369 = J.arg(a, 1)
	v_t_370 = J.gp(v_f_369, "t")
	v_a_371 = (J.max_([0.0, (1.0 - J.div(J.sub(v_t_370, J.mul(J.gp(v_f_369, "life"), 0.7)), J.mul(J.gp(v_f_369, "life"), 0.3)))]) if J.cmp(v_t_370, J.mul(J.gp(v_f_369, "life"), 0.7), ">") else 1.0)
	v_pop_372 = ((0.35 + (J.div(v_t_370, 0.1) * 1.05)) if J.cmp(v_t_370, 0.1, "<") else ((1.4 - (J.div(J.sub(v_t_370, 0.1), 0.1) * 0.4)) if J.cmp(v_t_370, 0.2, "<") else 1.0))
	v_x_373 = J.gp(v_f_369, "x")
	v_y_374 = J.gp(v_f_369, "y")
	if J.seq(J.gp(v_f_369, "kind"), "num"):
		var _t583 = J.gp(v_f_369, "vx")
		var _t584 = J.add(v_x_373, J.mul((_t583 if J.t(_t583) else 0.0), v_t_370))
		v_x_373 = _t584
		var _t585 = J.add(v_y_374, (J.mul((-120.0), v_t_370) + J.mul(J.mul((0.5 * 330.0), v_t_370), v_t_370)))
		v_y_374 = _t585
	else:
		if (not J.t(J.gp(v_f_369, "center"))):
			var _t586 = J.sub(v_y_374, J.mul(v_t_370, 30.0))
			v_y_374 = _t586
	v_size_375 = (30.0 if J.t(J.gp(v_f_369, "center")) else (16.0 if J.t(J.gp(v_f_369, "skill")) else (19.0 if J.t(J.gp(v_f_369, "big")) else 14.0)))
	J.mc(v_ctx_368, "save", [])
	J.sp(v_ctx_368, "globalAlpha", v_a_371)
	J.mc(v_ctx_368, "translate", [v_x_373, v_y_374])
	J.mc(v_ctx_368, "scale", [v_pop_372, v_pop_372])
	J.sp(v_ctx_368, "textAlign", "center")
	var _t587 = ("900 " + J.str(v_size_375) + "px \"PingFang TC\",\"Noto Sans TC\",sans-serif")
	J.sp(v_ctx_368, "font", _t587)
	var _t588 = J.gp(v_f_369, "big")
	var _t589 = (5.0 if J.t((_t588 if J.t(_t588) else J.gp(v_f_369, "center"))) else 4.0)
	J.sp(v_ctx_368, "lineWidth", _t589)
	J.sp(v_ctx_368, "lineJoin", "round")
	J.sp(v_ctx_368, "strokeStyle", "rgba(10,6,20,.92)")
	J.mc(v_ctx_368, "strokeText", [J.gp(v_f_369, "text"), 0.0, 0.0])
	var _t590 = J.gp(v_f_369, "col")
	J.sp(v_ctx_368, "fillStyle", _t590)
	J.mc(v_ctx_368, "fillText", [J.gp(v_f_369, "text"), 0.0, 0.0])
	J.mc(v_ctx_368, "restore", [])

func _f100(this_, a: Array, env):
	var v_r_385 = null; var v_i_386 = null
	v_r_385 = J.arg(a, 0)
	v_i_386 = J.arg(a, 1)
	return (sin(J.num(J.add(J.gp(v_r_385, "j"), J.mul(v_i_386, 7.3)))) * 1.6)

func _f101(this_, a: Array, env):
	var v_col_387 = null; var v_w_388 = null; var v_al_389 = null; var v_off_390 = null; var v_r_391 = null; var v_r0_392 = null; var v_r1_393 = null; var v_c_394 = null; var v_sn_395 = null; var v_i_396 = null
	v_col_387 = J.arg(a, 0)
	v_w_388 = J.arg(a, 1)
	v_al_389 = J.arg(a, 2)
	v_off_390 = J.arg(a, 3)
	var _t592 = env["ctx"]
	J.sp(_t592, "strokeStyle", v_col_387)
	var _t593 = env["ctx"]
	var _t594 = J.mul(v_al_389, env["a"])
	J.sp(_t593, "globalAlpha", _t594)
	var _t595 = env["ctx"]
	J.sp(_t595, "lineWidth", v_w_388)
	for _t596 in J.iter(J.gp(env["f"], "rays")):
		v_r_391 = _t596
		v_r0_392 = J.mul(J.gp(v_r_391, "len"), (0.15 + J.mul(env["e"], 0.55)))
		v_r1_393 = J.mul(J.gp(v_r_391, "len"), (0.45 + J.mul(env["e"], 0.75)))
		v_c_394 = cos(J.num(J.gp(v_r_391, "a")))
		v_sn_395 = sin(J.num(J.gp(v_r_391, "a")))
		v_i_396 = 0.0
		while true:
			if not J.cmp(v_i_396, 2.0, "<"): break
			J.mc(env["ctx"], "beginPath", [])
			var _t598 = J.mul(v_c_394, v_r0_392)
			var _t597 = env["jit"]
			var _t601 = J.add(_t598, J.cl(_t597, null, [v_r_391, J.add(v_i_396, v_off_390)]))
			var _t600 = J.mul(v_sn_395, v_r0_392)
			var _t599 = env["jit"]
			J.mc(env["ctx"], "moveTo", [_t601, J.add(_t600, J.cl(_t599, null, [v_r_391, J.add(J.add(v_i_396, v_off_390), 3.0)]))])
			var _t603 = J.mul(v_c_394, v_r1_393)
			var _t602 = env["jit"]
			var _t606 = J.add(_t603, J.cl(_t602, null, [v_r_391, J.add(J.add(v_i_396, v_off_390), 5.0)]))
			var _t605 = J.mul(v_sn_395, v_r1_393)
			var _t604 = env["jit"]
			J.mc(env["ctx"], "lineTo", [_t606, J.add(_t605, J.cl(_t604, null, [v_r_391, J.add(J.add(v_i_396, v_off_390), 1.0)]))])
			J.mc(env["ctx"], "stroke", [])
			v_i_396 = J.num(v_i_396) + 1.0

func _f99(this_, a: Array, env):
	var v_p_380 = null; var v_pass_384 = null; var v_q_397 = null; var v_i_398 = null; var v_ang_399 = null; var v_rr_400 = null
	var _s213 = {"__p": env, "ctx": null, "f": null, "e": null, "a": null, "jit": null}
	_s213["ctx"] = J.arg(a, 0)
	_s213["f"] = J.arg(a, 1)
	v_p_380 = J.div(J.gp(_s213["f"], "t"), J.gp(_s213["f"], "life"))
	_s213["e"] = (1.0 - pow(J.num(J.sub(1.0, v_p_380)), J.num(2.0)))
	_s213["a"] = J.sub(1.0, v_p_380)
	J.mc(_s213["ctx"], "save", [])
	var _t591 = _s213["ctx"]
	J.sp(_t591, "lineCap", "round")
	J.mc(_s213["ctx"], "translate", [J.gp(_s213["f"], "x"), J.gp(_s213["f"], "y")])
	_s213["jit"] = Callable(self, "_f100").bind(_s213)
	v_pass_384 = Callable(self, "_f101").bind(_s213)
	J.cl(v_pass_384, null, ["rgba(20,10,30,.85)", (J.mul(4.2, J.gp(_s213["f"], "k")) * (1.0 - J.mul(v_p_380, 0.5))), 0.8, 0.0])
	J.cl(v_pass_384, null, [J.gp(_s213["f"], "col"), (J.mul(2.4, J.gp(_s213["f"], "k")) * (1.0 - J.mul(v_p_380, 0.5))), 1.0, 2.0])
	J.cl(v_pass_384, null, ["#fff", J.mul(1.0, J.gp(_s213["f"], "k")), 0.9, 4.0])
	if J.cmp(v_p_380, 0.5, "<"):
		v_q_397 = J.mul(((1.0 - J.mul(v_p_380, 2.0)) * 12.0), J.gp(_s213["f"], "k"))
		var _t607 = _s213["ctx"]
		var _t608 = (1.0 - J.mul(v_p_380, 2.0))
		J.sp(_t607, "globalAlpha", _t608)
		J.mc(_s213["ctx"], "rotate", [J.gp(_s213["f"], "rot")])
		var _t609 = _s213["ctx"]
		J.sp(_t609, "fillStyle", "#fff")
		J.mc(_s213["ctx"], "beginPath", [])
		v_i_398 = 0.0
		while true:
			if not J.cmp(v_i_398, 8.0, "<"): break
			v_ang_399 = J.div(J.mul(v_i_398, PI), 4.0)
			v_rr_400 = (J.mul(v_q_397, 0.28) if J.t(J.mod(v_i_398, 2.0)) else v_q_397)
			J.mc(_s213["ctx"], "lineTo", [J.mul(cos(J.num(v_ang_399)), v_rr_400), J.mul(sin(J.num(v_ang_399)), v_rr_400)])
			v_i_398 = J.num(v_i_398) + 1.0
		J.mc(_s213["ctx"], "closePath", [])
		J.mc(_s213["ctx"], "fill", [])
	J.mc(_s213["ctx"], "restore", [])

func _f102(this_, a: Array, env):
	var v_ctx_403 = null; var v_f_404 = null; var v_p_405 = null; var v_r_406 = null; var v_sweep_407 = null; var v_a0_408 = null; var v_a1_409 = null; var v_tail_410 = null; var v_i_411 = null
	v_ctx_403 = J.arg(a, 0)
	v_f_404 = J.arg(a, 1)
	v_p_405 = J.div(J.gp(v_f_404, "t"), J.gp(v_f_404, "life"))
	v_r_406 = J.gp(v_f_404, "r")
	v_sweep_407 = J.min_([1.0, J.mul(v_p_405, 2.2)])
	v_a0_408 = (-1.25)
	v_a1_409 = J.add(v_a0_408, J.mul(2.5, v_sweep_407))
	v_tail_410 = J.max_([v_a0_408, J.sub(v_a1_409, 1.6)])
	J.mc(v_ctx_403, "save", [])
	J.mc(v_ctx_403, "translate", [J.sub(J.gp(v_f_404, "x"), (J.mul(J.gp(v_f_404, "dir"), v_r_406) * 0.35)), J.gp(v_f_404, "y")])
	J.mc(v_ctx_403, "scale", [J.gp(v_f_404, "dir"), 1.0])
	var _t610 = (1.0 - J.mul(v_p_405, 0.9))
	J.sp(v_ctx_403, "globalAlpha", _t610)
	J.sp(v_ctx_403, "lineCap", "round")
	v_i_411 = 0.0
	while true:
		if not J.cmp(v_i_411, 3.0, "<"): break
		var _t611 = ("rgba(20,10,30,.6)" if J.seq(v_i_411, 0.0) else (J.gp(v_f_404, "col") if J.seq(v_i_411, 1.0) else "#fff"))
		J.sp(v_ctx_403, "strokeStyle", _t611)
		var _t612 = J.mul(J.gp([7.0, 4.0, 1.6], v_i_411), (1.0 - J.mul(v_p_405, 0.6)))
		J.sp(v_ctx_403, "lineWidth", _t612)
		J.mc(v_ctx_403, "beginPath", [])
		J.mc(v_ctx_403, "arc", [0.0, 0.0, (J.sub(v_r_406, J.mul(v_i_411, 1.2)) + (sin(J.num(J.mul(v_i_411, 3.0))) * 0.8)), v_tail_410, v_a1_409])
		J.mc(v_ctx_403, "stroke", [])
		v_i_411 = J.num(v_i_411) + 1.0
	J.mc(v_ctx_403, "restore", [])

func _f103(this_, a: Array, env):
	var v_ctx_414 = null; var v_f_415 = null; var v_p_416 = null; var v_e_417 = null; var v_q_418 = null
	v_ctx_414 = J.arg(a, 0)
	v_f_415 = J.arg(a, 1)
	v_p_416 = J.div(J.gp(v_f_415, "t"), J.gp(v_f_415, "life"))
	v_e_417 = (1.0 - pow(J.num(J.sub(1.0, v_p_416)), J.num(2.0)))
	J.mc(v_ctx_414, "save", [])
	var _t613 = (0.55 * J.sub(1.0, v_p_416))
	J.sp(v_ctx_414, "globalAlpha", _t613)
	for _t614 in J.iter(J.gp(v_f_415, "puffs")):
		v_q_418 = _t614
		J.sp(v_ctx_414, "fillStyle", "rgba(190,176,150,1)")
		J.mc(v_ctx_414, "beginPath", [])
		J.mc(v_ctx_414, "arc", [J.add(J.add(J.gp(v_f_415, "x"), J.gp(v_q_418, "dx")), (J.mul(J.gp(v_q_418, "vx"), v_e_417) * 0.4)), (J.sub(J.gp(v_f_415, "y"), 2.0) - J.mul(v_e_417, 8.0)), J.mul(J.gp(v_q_418, "r"), (0.6 + J.mul(v_e_417, 0.9))), 0.0, (PI * 2.0)])
		J.mc(v_ctx_414, "fill", [])
	J.mc(v_ctx_414, "restore", [])

func _f104(this_, a: Array, env):
	var v_ctx_421 = null; var v_x_422 = null; var v_y_423 = null; var v_s_424 = null; var v_p_425 = null; var v_col_426 = null; var v_front_427 = null; var v_R_428 = null; var v_g_429 = null; var v_i_430 = null; var v_ang_431 = null; var v_rr_432 = null
	v_ctx_421 = J.arg(a, 0)
	v_x_422 = J.arg(a, 1)
	v_y_423 = J.arg(a, 2)
	v_s_424 = J.arg(a, 3)
	v_p_425 = J.arg(a, 4)
	v_col_426 = J.arg(a, 5)
	v_front_427 = J.arg(a, 6)
	var _t615 = J.min_([1.0, v_p_425])
	v_p_425 = _t615
	J.mc(v_ctx_421, "save", [])
	if (not J.t(v_front_427)):
		v_g_429 = J.mc(v_ctx_421, "createRadialGradient", [v_x_422, v_y_423, 0.0, v_x_422, v_y_423, J.mul(46.0, v_s_424)])
		J.mc(v_g_429, "addColorStop", [0.0, v_col_426])
		J.mc(v_g_429, "addColorStop", [1.0, "rgba(0,0,0,0)"])
		J.sp(v_ctx_421, "globalCompositeOperation", "lighter")
		var _t616 = (0.25 + J.mul(v_p_425, 0.45))
		J.sp(v_ctx_421, "globalAlpha", _t616)
		J.sp(v_ctx_421, "fillStyle", v_g_429)
		J.mc(v_ctx_421, "beginPath", [])
		J.mc(v_ctx_421, "arc", [v_x_422, v_y_423, J.mul(46.0, v_s_424), 0.0, (PI * 2.0)])
		J.mc(v_ctx_421, "fill", [])
		J.mc(v_ctx_421, "restore", [])
		return null
	v_R_428 = J.mul((44.0 - J.mul(v_p_425, 26.0)), v_s_424)
	J.sp(v_ctx_421, "strokeStyle", v_col_426)
	J.sp(v_ctx_421, "lineWidth", 2.5)
	var _t617 = (0.4 + J.mul(v_p_425, 0.6))
	J.sp(v_ctx_421, "globalAlpha", _t617)
	J.mc(v_ctx_421, "setLineDash", [[7.0, 5.0]])
	var _t618 = ((-J.num(J.gp(this_, "t"))) * 60.0)
	J.sp(v_ctx_421, "lineDashOffset", _t618)
	J.mc(v_ctx_421, "beginPath", [])
	J.mc(v_ctx_421, "ellipse", [v_x_422, J.add(v_y_423, J.mul(20.0, v_s_424)), J.mul(v_R_428, 1.1), J.mul(v_R_428, 0.42), 0.0, 0.0, (PI * 2.0)])
	J.mc(v_ctx_421, "stroke", [])
	J.mc(v_ctx_421, "setLineDash", [[]])
	J.sp(v_ctx_421, "lineWidth", 1.6)
	J.mc(v_ctx_421, "beginPath", [])
	J.mc(v_ctx_421, "arc", [v_x_422, v_y_423, v_R_428, 0.0, (PI * 2.0)])
	J.mc(v_ctx_421, "stroke", [])
	J.sp(v_ctx_421, "fillStyle", "#fff")
	v_i_430 = 0.0
	while true:
		if not J.cmp(v_i_430, 8.0, "<"): break
		v_ang_431 = (J.div(J.mul(v_i_430, PI), 4.0) + J.mul(J.gp(this_, "t"), 3.0))
		v_rr_432 = J.mul(v_R_428, (1.25 - J.mul(v_p_425, 0.6)))
		J.sp(v_ctx_421, "globalAlpha", 0.9)
		J.mc(v_ctx_421, "beginPath", [])
		J.mc(v_ctx_421, "arc", [J.add(v_x_422, J.mul(cos(J.num(v_ang_431)), v_rr_432)), J.add(v_y_423, (J.mul(sin(J.num(v_ang_431)), v_rr_432) * 0.8)), (1.6 + J.mul(v_p_425, 1.4)), 0.0, (PI * 2.0)])
		J.mc(v_ctx_421, "fill", [])
		v_i_430 = J.num(v_i_430) + 1.0
	J.mc(v_ctx_421, "restore", [])

func _f105(this_, a: Array, env):
	var v_ctx_435 = null; var v_p_436 = null; var v_g_437 = null; var v_i_438 = null; var v_x0_439 = null; var v_y0_440 = null; var v_x1_441 = null; var v_y1_442 = null; var v_f_443 = null; var v_x0_444 = null; var v_y0_445 = null
	v_ctx_435 = J.arg(a, 0)
	v_p_436 = J.arg(a, 1)
	J.mc(v_ctx_435, "save", [])
	J.sp(v_ctx_435, "lineCap", "round")
	v_i_438 = 1.0
	while true:
		if not J.cmp(v_i_438, J.len(J.gp(v_p_436, "trail")), "<"): break
		var _t619 = J.gp(J.gp(v_p_436, "trail"), J.sub(v_i_438, 1.0))
		var _t620 = J.gp(_t619, 0.0)
		v_x0_439 = _t620
		var _t621 = J.gp(_t619, 1.0)
		v_y0_440 = _t621
		var _t622 = J.gp(J.gp(v_p_436, "trail"), v_i_438)
		var _t623 = J.gp(_t622, 0.0)
		v_x1_441 = _t623
		var _t624 = J.gp(_t622, 1.0)
		v_y1_442 = _t624
		v_f_443 = J.div(v_i_438, J.len(J.gp(v_p_436, "trail")))
		var _t625 = J.mul(v_f_443, 0.7)
		J.sp(v_ctx_435, "globalAlpha", _t625)
		var _t626 = J.gp(v_p_436, "col")
		J.sp(v_ctx_435, "strokeStyle", _t626)
		var _t627 = (1.0 + J.mul(v_f_443, 5.0))
		J.sp(v_ctx_435, "lineWidth", _t627)
		J.mc(v_ctx_435, "beginPath", [])
		J.mc(v_ctx_435, "moveTo", [v_x0_439, v_y0_440])
		J.mc(v_ctx_435, "lineTo", [v_x1_441, v_y1_442])
		J.mc(v_ctx_435, "stroke", [])
		v_i_438 = J.num(v_i_438) + 1.0
	if J.t(J.len(J.gp(v_p_436, "trail"))):
		var _t628 = J.gp(J.gp(v_p_436, "trail"), (J.len(J.gp(v_p_436, "trail")) - 1.0))
		var _t629 = J.gp(_t628, 0.0)
		v_x0_444 = _t629
		var _t630 = J.gp(_t628, 1.0)
		v_y0_445 = _t630
		J.sp(v_ctx_435, "globalAlpha", 0.8)
		J.sp(v_ctx_435, "lineWidth", 6.0)
		J.mc(v_ctx_435, "beginPath", [])
		J.mc(v_ctx_435, "moveTo", [v_x0_444, v_y0_445])
		J.mc(v_ctx_435, "lineTo", [J.gp(v_p_436, "x"), J.gp(v_p_436, "y")])
		J.mc(v_ctx_435, "stroke", [])
	J.sp(v_ctx_435, "globalAlpha", 1.0)
	J.sp(v_ctx_435, "globalCompositeOperation", "lighter")
	v_g_437 = J.mc(v_ctx_435, "createRadialGradient", [J.gp(v_p_436, "x"), J.gp(v_p_436, "y"), 0.0, J.gp(v_p_436, "x"), J.gp(v_p_436, "y"), 11.0])
	J.mc(v_g_437, "addColorStop", [0.0, "#fff"])
	J.mc(v_g_437, "addColorStop", [0.35, J.gp(v_p_436, "col")])
	J.mc(v_g_437, "addColorStop", [1.0, "rgba(0,0,0,0)"])
	J.sp(v_ctx_435, "fillStyle", v_g_437)
	J.mc(v_ctx_435, "beginPath", [])
	J.mc(v_ctx_435, "arc", [J.gp(v_p_436, "x"), J.gp(v_p_436, "y"), 11.0, 0.0, (PI * 2.0)])
	J.mc(v_ctx_435, "fill", [])
	J.mc(v_ctx_435, "restore", [])
