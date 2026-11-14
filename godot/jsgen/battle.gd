# 自動轉譯自 battle.js（tools/jsgd.js）——唔好直接改，改原 JS 再轉
extends RefCounted

func run(env):
	var this_ = null; var a = []
	J.G["__BT_ATK"] = {"windup": 1.0, "strike": 1.0, "follow": 1.0, "recover": 1.0}
	J.G["__btDC"] = Callable(self, "_f1").bind(env)
	J.G["GIFT_REWARD"] = {"gift_phone": {"coins": 300.0}, "gift_car": {"coins": 800.0, "chest": "p"}}
	J.G["Battle"] = {"active": false, "units": [], "fx": [], "t": 0.0, "speed": 1.0, "auto": false, "stage": null, "sid": "", "result": null, "init": Callable(self, "_f2").bind(env), "syncBtns": Callable(self, "_f7").bind(env), "sidOf": Callable(self, "_f8").bind(env), "stageOpen": Callable(self, "_f9").bind(env), "openSelect": Callable(self, "_f10").bind(env), "pickSlot": Callable(self, "_f24").bind(env), "tryStart": Callable(self, "_f30").bind(env), "mkGhostUnit": Callable(self, "_f33").bind(env), "start": Callable(self, "_f34").bind(env), "resize": Callable(self, "_f37").bind(env), "buildCards": Callable(self, "_f38").bind(env), "enemiesOf": Callable(self, "_f46").bind(env), "nearest": Callable(self, "_f48").bind(env), "stateOf": Callable(self, "_f49").bind(env), "hitStopFor": Callable(self, "_f50").bind(env), "kick": Callable(self, "_f51").bind(env), "hit": Callable(self, "_f52").bind(env), "doSkill": Callable(self, "_f53").bind(env), "CAST": 0.45, "beginCast": Callable(self, "_f58").bind(env), "tickCast": Callable(self, "_f59").bind(env), "fireCast": Callable(self, "_f60").bind(env), "cast": Callable(self, "_f61").bind(env), "castCombo": Callable(self, "_f62").bind(env), "fireCombo": Callable(self, "_f63").bind(env), "uy": Callable(self, "_f65").bind(env), "scaleOf": Callable(self, "_f66").bind(env), "WIND": 0.22, "STRIKE": 0.12, "REC": 0.25, "IMPACT": 0.05, "PSPD": 640.0, "period": Callable(self, "_f67").bind(env), "leadOf": Callable(self, "_f68").bind(env), "lungeOf": Callable(self, "_f69").bind(env), "stepAnim": Callable(self, "_f70").bind(env), "fire": Callable(self, "_f71").bind(env), "stepProj": Callable(self, "_f72").bind(env), "spark": Callable(self, "_f74").bind(env), "dust": Callable(self, "_f75").bind(env), "update": Callable(self, "_f76").bind(env), "visTick": Callable(self, "_f83").bind(env), "finish": Callable(self, "_f84").bind(env), "poseOf": Callable(self, "_f93").bind(env), "draw": Callable(self, "_f96").bind(env), "drawText": Callable(self, "_f99").bind(env), "drawSpark": Callable(self, "_f100").bind(env), "drawSlash": Callable(self, "_f103").bind(env), "drawDust": Callable(self, "_f104").bind(env), "drawCharge": Callable(self, "_f105").bind(env), "drawProj": Callable(self, "_f106").bind(env)}

func _f1(this_, a: Array, env):
	var v_c_5 = null; var v_k_6 = null; var v_x_7 = null; var v_y_8 = null; var v_s_9 = null; var v_o_10 = null
	v_c_5 = J.arg(a, 0)
	v_k_6 = J.arg(a, 1)
	v_x_7 = J.arg(a, 2)
	v_y_8 = J.arg(a, 3)
	v_s_9 = J.arg(a, 4)
	v_o_10 = J.arg(a, 5)
	var _t1 = J.gp(J.G.get("Battle"), "_nat")
	var _t4 = ((not J.seq(J.typeof_(J.G.get("__nat_drawChar")), "undefined")) if J.t(_t1) else _t1)
	if J.t(_t4):
		var _t2 = J.gp(J.G.get("__BT_ATK"), J.gp(v_o_10, "pose"))
		var _t3 = ((not J.seq(J.typeof_(J.G.get("MOVES")), "undefined")) if J.t(_t2) else _t2)
		_t4 = (not J.t((J.gp(J.G.get("MOVES"), v_k_6) if J.t(_t3) else _t3)))
	var _t7 = _t4
	if J.t(_t7):
		var _t5 = (not J.seq(J.typeof_(J.G.get("MeshAnim")), "undefined"))
		var _t6 = (J.gp(J.gp(J.G.get("MeshAnim"), "RIG"), v_k_6) if _t5 else _t5)
		_t7 = (not J.t((J.gp(J.gp(J.gp(J.G.get("MeshAnim"), "RIG"), v_k_6), "custom") if J.t(_t6) else _t6)))
	if J.t(_t7):
		var _t8 = J.G.get("__nat_drawChar")
		return J.cl(_t8, null, [v_c_5, v_k_6, v_x_7, v_y_8, v_s_9, v_o_10])
	var _t9 = J.G.get("ART")
	return J.mc(_t9, "drawChar", [v_c_5, v_k_6, v_x_7, v_y_8, v_s_9, v_o_10])

func _f3(this_, a: Array, env):
	var v_e_14 = null
	var _t23 = env["this"]
	var _t24 = (not J.t(J.gp(env["this"], "auto")))
	J.sp(_t23, "auto", _t24)
	J.S_localStorage_("setItem", ["gb_auto", ("1" if J.t(J.gp(env["this"], "auto")) else "0")])
	J.mc(env["this"], "syncBtns", [])

func _f4(this_, a: Array, env):
	var v_e_15 = null
	var _t28 = env["this"]
	var _t29 = (2.0 if J.seq(J.gp(env["this"], "speed"), 1.0) else 1.0)
	J.sp(_t28, "speed", _t29)
	J.S_localStorage_("setItem", ["gb_speed", J.gp(env["this"], "speed")])
	J.mc(env["this"], "syncBtns", [])

func _f5(this_, a: Array, env):
	var v_e_16 = null
	v_e_16 = J.arg(a, 0)
	if J.t(J.gp(env["this"], "result")):
		return null
	var _t33 = J.G.get("confirmInline")
	if (not J.t(J.cl(_t33, null, [J.gp(v_e_16, "target"), "確定撤退？"]))):
		return null
	J.mc(env["this"], "finish", [false, true])

func _f6(this_, a: Array, env):
	var _t35 = J.gp(env["this"], "active")
	return (J.mc(env["this"], "resize", []) if J.t(_t35) else _t35)

func _f2(this_, a: Array, env):
	var v_e_13 = null
	var _s3 = {"__p": env, "this": null}
	_s3["this"] = this_
	var _t10 = _s3["this"]
	var _t11 = J.G.get("$")
	var _t12 = J.cl(_t11, null, ["#bcvs"])
	J.sp(_t10, "cvs", _t12)
	var _t13 = _s3["this"]
	var _t14 = J.gp(_s3["this"], "cvs")
	var _t15 = J.mc(_t14, "getContext", ["2d"])
	J.sp(_t13, "ctx", _t15)
	var _t16 = _s3["this"]
	var _t17 = J.seq(J.S_localStorage_("getItem", ["gb_auto"]), "1")
	J.sp(_t16, "auto", _t17)
	var _t18 = _s3["this"]
	var _t19 = J.S_localStorage_("getItem", ["gb_speed"])
	var _t20 = J.num((_t19 if J.t(_t19) else 1.0))
	J.sp(_t18, "speed", _t20)
	var _t21 = J.G.get("$")
	var _t22 = J.cl(_t21, null, ["#b-auto"])
	var _t25 = Callable(self, "_f3").bind(_s3)
	J.sp(_t22, "onclick", _t25)
	var _t26 = J.G.get("$")
	var _t27 = J.cl(_t26, null, ["#b-speed"])
	var _t30 = Callable(self, "_f4").bind(_s3)
	J.sp(_t27, "onclick", _t30)
	var _t31 = J.G.get("$")
	var _t32 = J.cl(_t31, null, ["#b-quit"])
	var _t34 = Callable(self, "_f5").bind(_s3)
	J.sp(_t32, "onclick", _t34)
	J.S_window_("addEventListener", ["resize", Callable(self, "_f6").bind(_s3)])

func _f7(this_, a: Array, env):
	var _t36 = J.G.get("$")
	var _t37 = J.gp(J.cl(_t36, null, ["#b-auto"]), "classList")
	J.mc(_t37, "toggle", ["on", J.gp(this_, "auto")])
	var _t38 = J.G.get("$")
	var _t39 = J.cl(_t38, null, ["#b-auto"])
	var _t40 = ("自動 ON" if J.t(J.gp(this_, "auto")) else "自動 OFF")
	J.sp(_t39, "textContent", _t40)
	var _t41 = J.G.get("$")
	var _t42 = J.cl(_t41, null, ["#b-speed"])
	var _t43 = J.add("×", J.gp(this_, "speed"))
	J.sp(_t42, "textContent", _t43)

func _f8(this_, a: Array, env):
	var v_ci_21 = null; var v_si_22 = null
	v_ci_21 = J.arg(a, 0)
	v_si_22 = J.arg(a, 1)
	return (J.str(J.add(v_ci_21, 1.0)) + "-" + J.str(J.add(v_si_22, 1.0)))

func _f9(this_, a: Array, env):
	var v_ci_25 = null; var v_si_26 = null
	v_ci_25 = J.arg(a, 0)
	v_si_26 = J.arg(a, 1)
	var _t44 = J.cmp(v_si_26, 0.0, ">")
	if ((not J.t(J.gp(J.gp(J.G.get("S"), "cleared"), J.mc(this_, "sidOf", [v_ci_25, J.sub(v_si_26, 1.0)])))) if _t44 else _t44):
		return false
	var _t45 = J.seq(v_si_26, 0.0)
	var _t46 = (J.cmp(v_ci_25, 0.0, ">") if _t45 else _t45)
	if ((not J.t(J.gp(J.gp(J.G.get("S"), "cleared"), J.mc(this_, "sidOf", [J.sub(v_ci_25, 1.0), 2.0])))) if _t46 else _t46):
		return false
	return true

func _f13(this_, a: Array, env):
	var v_st_39 = null; var v_si_40 = null; var v_sid_41 = null; var v_open_42 = null; var v_done_43 = null; var v_lvOk_44 = null
	v_st_39 = J.arg(a, 0)
	v_si_40 = J.arg(a, 1)
	v_sid_41 = J.mc(env["__p"]["__p"]["this"], "sidOf", [env["ci"], v_si_40])
	v_open_42 = J.mc(env["__p"]["__p"]["this"], "stageOpen", [env["ci"], v_si_40])
	v_done_43 = J.gp(J.gp(J.G.get("S"), "cleared"), v_sid_41)
	v_lvOk_44 = J.cmp(J.gp(J.G.get("S"), "lv"), J.gp(v_st_39, "req"), ">=")
	var _t66 = J.add(env["__p"]["h"], ("<div class=\"stg " + ("" if J.t(v_open_42) else "locked") + " " + ("boss" if J.t(J.gp(v_st_39, "boss")) else "") + "\"><span class=\"sn\">" + J.str(v_sid_41) + "</span><span class=\"st\"><b>" + J.str(J.gp(v_st_39, "name")) + "</b><small>" + (("需主公 Lv" + J.str(J.gp(v_st_39, "req")) + "　<span class=\"gp-need " + ("gp-low" if J.cmp(env["__p"]["myGP"], J.mc(J.G.get("GP"), "stageNeed", [v_st_39, v_sid_41]), "<") else "gp-ok") + "\">" + J.str(J.mc(J.G.get("GP"), "T", ["建議鬼力", "建議鬼力"])) + " " + J.str(J.mc(J.G.get("GP"), "stageNeed", [v_st_39, v_sid_41])) + "</span>　" + J.str(J.mc(J.G.get("Rework"), "turfTag", [v_sid_41])) + "</small><small class=\"rw-efs\">" + J.str(J.mc(J.G.get("Rework"), "enemyHint", [J.gp(v_st_39, "en")]))) if J.t(v_open_42) else "先打通上一關") + "</small></span>" + (("<button class=\"btn sm " + ("" if J.t(((not J.t(J.mc(J.G.get("Rework"), "isLost", [v_sid_41]))) if J.t(v_done_43) else v_done_43)) else "gold") + "\" data-go=\"" + J.str(env["ci"]) + "," + J.str(v_si_40) + "\" " + ("" if J.t(v_lvOk_44) else "disabled") + ">" + (("奪回" if J.t(J.mc(J.G.get("Rework"), "isLost", [v_sid_41])) else "巡場") if J.t(v_done_43) else ("搶地盤" if J.t(v_lvOk_44) else ("Lv" + J.str(J.gp(v_st_39, "req"))))) + "</button>") if J.t(v_open_42) else "<span class=\"lk\">🔒</span>") + ("<i class=\"ok\">✓</i>" if J.t(v_done_43) else "") + "</div>"))
	env["__p"]["h"] = _t66

func _f12(this_, a: Array, env):
	var v_ch_37 = null
	var _s25 = {"__p": env, "ci": null}
	v_ch_37 = J.arg(a, 0)
	_s25["ci"] = J.arg(a, 1)
	var _t64 = J.add(_s25["__p"]["h"], ("<div class=\"chap\"><div class=\"ch-h\">第" + J.str(J.gp("一二三四五六", _s25["ci"])) + "章・" + J.str(J.gp(v_ch_37, "name")) + "</div>"))
	_s25["__p"]["h"] = _t64
	var _t65 = J.gp(v_ch_37, "stages")
	J.mc(_t65, "forEach", [Callable(self, "_f13").bind(_s25)])
	var _t67 = J.add(_s25["__p"]["h"], "</div>")
	_s25["__p"]["h"] = _t67

func _f11(this_, a: Array, env):
	var v_ad_33 = null; var v_i_34 = null; var v_g_35 = null; var v_b_36 = null
	var _s21 = {"__p": env, "h": null, "myGP": null}
	_s21["h"] = ("<div class=\"team\">")
	v_i_34 = 0.0
	while true:
		if not J.cmp(v_i_34, 3.0, "<"): break
		var _t47 = J.G.get("ghostById")
		v_g_35 = J.cl(_t47, null, [J.gp(J.gp(J.G.get("S"), "team"), v_i_34)])
		var _t48 = J.add(_s21["h"], ("<div class=\"tslot\" data-slot=\"" + J.str(v_i_34) + "\">" + (("<canvas data-por=\"" + J.str(J.gp(v_g_35, "k")) + "\"></canvas><b>" + J.str(J.gp(v_g_35, "name")) + "</b><small>Lv" + J.str(J.mc(J.G.get("F"), "glv", [v_g_35])) + "・" + J.str(J.mc(J.G.get("GP"), "T", ["鬼力", "鬼力"])) + J.str(J.mc(J.G.get("GP"), "pow", [v_g_35])) + "</small>") if J.t(v_g_35) else "<span>＋<br>出陣</span>") + "</div>"))
		_s21["h"] = _t48
		v_i_34 = J.num(v_i_34) + 1.0
	var _t49 = J.gp(J.G.get("S"), "team")
	_s21["myGP"] = J.mc(J.G.get("GP"), "avg", [J.mc(_t49, "map", [J.G.get("ghostById")])])
	var _t50 = J.G.get("ghostById")
	v_ad_33 = J.cl(_t50, null, [J.gp(J.G.get("S"), "adviser")])
	var _t51 = J.add(_s21["h"], ("<div class=\"tslot adv\" data-slot=\"adv\">" + (("<canvas data-por=\"" + J.str(J.gp(v_ad_33, "k")) + "\"></canvas><b>" + J.str(J.gp(v_ad_33, "name")) + "</b><small>軍師</small>") if J.t(v_ad_33) else "<span>＋<br>軍師</span>") + "</div></div>"))
	_s21["h"] = _t51
	var _t53 = (J.round(J.num(J.div(J.mc(J.G.get("F"), "stat", [v_ad_33, 1.0]), 8.0))) if J.t(v_ad_33) else 0.0)
	var _t54 = J.mc(J.G.get("GP"), "T", ["出陣平均", "出陣平均"])
	var _t55 = J.mc(J.G.get("GP"), "tag", [_s21["myGP"], 0.0])
	var _t56 = J.mc(J.G.get("GP"), "T", ["每關都有「建議鬼力」，紅字＝未夠，返村升級或者練嚇功先。", "每關都有「建議鬼力」，紅字＝不足，先回村升級或練嚇功。"])
	var _t52 = J.G.get("fmt")
	var _t57 = J.add(_s21["h"], ("<p class=\"desc\">軍師不上場，坐鎮後方：全隊攻擊 +" + J.str(_t53) + "%（看智力），能量滿了也能放技能。出征前可隨時換人。　</p><p class=\"desc gp-line\">" + J.str(_t54) + " " + J.str(_t55) + "　<small>" + J.str(_t56) + "</small></p><div class=\"troopbox\"><b>帶上陣的陰兵</b><span>現有 " + J.str(J.cl(_t52, null, [J.gp(J.gp(J.G.get("S"), "res"), "troops")])) + "，可組成 <em>" + J.str(J.min_([8.0, floor(J.num(J.div(J.gp(J.gp(J.G.get("S"), "res"), "troops"), 25.0)))])) + "</em> 隊（每 25 個一隊，最多 8 隊）</span><small>" + ("村裡的遊魂見你有地盤，會自願當陰兵（民宅越高級來得越快）。戰死的會扣掉。" if J.t(J.gp(J.gp(J.G.get("S"), "bld"), "home")) else "建好民宅，遊魂才會來投靠當陰兵。") + "</small></div>"))
	_s21["h"] = _t57
	if J.t(J.gp(J.gp(J.G.get("S"), "seen"), "ch1_end")):
		var _t58 = J.gp(J.G.get("S"), "scare")
		var _t59 = (J.gp(J.gp(J.gp(J.G.get("S"), "scare"), "best"), "office") if J.t(_t58) else _t58)
		v_b_36 = (_t59 if J.t(_t59) else 0.0)
		var _t60 = J.add(_s21["h"], ("<div class=\"sc-entry\"><div><b>回陽間・夜班嚇人</b><small>舊公司・二十三樓　最高 " + J.str(v_b_36) + "　" + J.str(J.mc("★", "repeat", [J.mc(J.G.get("Scare"), "starsOf", ["office", v_b_36])])) + "</small></div><button class=\"btn gold\" id=\"sc-open\">回去</button></div>"))
		_s21["h"] = _t60
	var _t61 = J.gp(J.gp(J.G.get("S"), "seen"), "ch1_end")
	if J.t(((not J.seq(J.typeof_(J.G.get("Sports")), "undefined")) if J.t(_t61) else _t61)):
		var _t62 = J.add(_s21["h"], ("<div class=\"sc-entry sp-entry\"><div><b>陰間運動會</b><small>殭屍跳遠、舌頭對脖子拔河、倒掛耐力、河童游泳</small></div><button class=\"btn gold\" id=\"sp-open\">參加</button></div>"))
		_s21["h"] = _t62
	var _t63 = J.add(_s21["h"], (J.mc(J.G.get("Station"), "entryHTML", []) if (not J.seq(J.typeof_(J.G.get("Station")), "undefined")) else J.mc(J.G.get("Rework"), "turfHead", [])))
	_s21["h"] = _t63
	J.mc(J.G.get("CHAPTERS"), "forEach", [Callable(self, "_f12").bind(_s21)])
	if (not J.seq(J.typeof_(J.G.get("N30W")), "undefined")):
		var _t68 = J.add(_s21["h"], J.mc(J.G.get("N30W"), "selectHtml", []))
		_s21["h"] = _t68
	return _s21["h"]

func _f16(this_, a: Array, env):
	return J.mc(env["__p"]["this"], "pickSlot", [J.gp(J.gp(env["el"], "dataset"), "slot")])

func _f15(this_, a: Array, env):
	var _s28 = {"__p": env, "el": null}
	_s28["el"] = J.arg(a, 0)
	var _t75 = _s28["el"]
	var _t76 = Callable(self, "_f16").bind(_s28)
	J.sp(_t75, "onclick", _t76)
	return _t76

func _f17(this_, a: Array, env):
	return J.mc(J.G.get("Scare"), "open", ["office"])

func _f18(this_, a: Array, env):
	return J.mc(J.G.get("Sports"), "open", [])

func _f19(this_, a: Array, env):
	return (J.mc(J.G.get("Street"), "open", []) if (not J.seq(J.typeof_(J.G.get("Street")), "undefined")) else J.mc(J.G.get("Station"), "openPanel", []))

func _f21(this_, a: Array, env):
	var v_ci_50 = null; var v_si_51 = null
	var _t87 = J.gp(J.gp(env["b"], "dataset"), "go")
	var _t88 = J.mc(_t87, "split", [","])
	var _t89 = J.mc(_t88, "map", [J.G.get("Number")])
	var _t90 = J.gp(_t89, 0.0)
	v_ci_50 = _t90
	var _t91 = J.gp(_t89, 1.0)
	v_si_51 = _t91
	J.mc(env["__p"]["this"], "tryStart", [v_ci_50, v_si_51])

func _f20(this_, a: Array, env):
	var _s33 = {"__p": env, "b": null}
	_s33["b"] = J.arg(a, 0)
	var _t86 = _s33["b"]
	var _t92 = Callable(self, "_f21").bind(_s33)
	J.sp(_t86, "onclick", _t92)
	return _t92

func _f14(this_, a: Array, env):
	var v_so_45 = null; var v_spo_46 = null; var v_sto_47 = null
	var _t69 = J.G.get("paintPortraits")
	var _t70 = J.G.get("$")
	J.cl(_t69, null, [J.cl(_t70, null, ["#sheet"])])
	if (not J.seq(J.typeof_(J.G.get("N30W")), "undefined")):
		var _t71 = J.G.get("$")
		J.mc(J.G.get("N30W"), "bindSelect", [J.cl(_t71, null, ["#sheet"])])
	var _t72 = J.G.get("$")
	var _t73 = J.cl(_t72, null, ["#sheet"])
	var _t74 = J.mc(_t73, "querySelectorAll", [".tslot"])
	J.mc(_t74, "forEach", [Callable(self, "_f15").bind(env)])
	var _t77 = J.G.get("$")
	v_so_45 = J.cl(_t77, null, ["#sc-open"])
	if J.t(v_so_45):
		var _t78 = Callable(self, "_f17").bind(env)
		J.sp(v_so_45, "onclick", _t78)
	var _t79 = J.G.get("$")
	v_spo_46 = J.cl(_t79, null, ["#sp-open"])
	if J.t(v_spo_46):
		var _t80 = Callable(self, "_f18").bind(env)
		J.sp(v_spo_46, "onclick", _t80)
	var _t81 = J.G.get("$")
	v_sto_47 = J.cl(_t81, null, ["#stn-open"])
	if J.t(v_sto_47):
		var _t82 = Callable(self, "_f19").bind(env)
		J.sp(v_sto_47, "onclick", _t82)
	var _t83 = J.G.get("$")
	var _t84 = J.cl(_t83, null, ["#sheet"])
	var _t85 = J.mc(_t84, "querySelectorAll", ["[data-go]"])
	J.mc(_t85, "forEach", [Callable(self, "_f20").bind(env)])

func _f22(this_, a: Array, env):
	var v_sc_52 = null
	var _t94 = J.G.get("$")
	v_sc_52 = J.gp(J.cl(_t94, null, ["#sheet .sh-body"]), "scrollTop")
	var _t95 = J.G.get("$")
	var _t96 = J.cl(_t95, null, ["#sheet .sh-body"])
	var _t97 = J.cl(env["render"], null, [])
	J.sp(_t96, "innerHTML", _t97)
	J.cl(env["bind"], null, [])
	var _t98 = J.G.get("$")
	var _t99 = J.cl(_t98, null, ["#sheet .sh-body"])
	J.sp(_t99, "scrollTop", v_sc_52)

func _f23(this_, a: Array, env):
	var v_b_53 = null
	var _t101 = J.G.get("$")
	v_b_53 = J.cl(_t101, null, ["#sheet .btn.gold[data-go]"])
	if J.t(v_b_53):
		J.mc(v_b_53, "scrollIntoView", [{"block": "center"}])

func _f10(this_, a: Array, env):
	var _s20 = {"__p": env, "this": null, "render": null, "bind": null}
	_s20["this"] = this_
	_s20["render"] = Callable(self, "_f11").bind(_s20)
	_s20["bind"] = Callable(self, "_f14").bind(_s20)
	J.mc(J.G.get("UI"), "sheet", ["陽間地盤", J.cl(_s20["render"], null, [])])
	J.cl(_s20["bind"], null, [])
	var _t93 = _s20["this"]
	var _t100 = Callable(self, "_f22").bind(_s20)
	J.sp(_t93, "_reSelect", _t100)
	J.F_setTimeout([Callable(self, "_f23").bind(_s20), 30.0])

func _f25(this_, a: Array, env):
	var v_a_61 = null; var v_b_62 = null
	v_a_61 = J.arg(a, 0)
	v_b_62 = J.arg(a, 1)
	return J.sub(J.mc(J.G.get("F"), "glv", [v_b_62]), J.mc(J.G.get("F"), "glv", [v_a_61]))

func _f26(this_, a: Array, env):
	return J.mc(env["this"], "openSelect", [])

func _f29(this_, a: Array, env):
	var v_s_69 = null; var v_v_70 = null
	v_s_69 = J.arg(a, 0)
	v_v_70 = J.arg(a, 1)
	if J.seq(v_s_69, "adv"):
		var _t133 = J.G.get("S")
		J.sp(_t133, "adviser", v_v_70)
	else:
		var _t134 = J.gp(J.G.get("S"), "team")
		var _t135 = J.num(v_s_69)
		J.sp(_t134, _t135, v_v_70)

func _f28(this_, a: Array, env):
	var v_id_67 = null; var v_put_68 = null; var v_from_71 = null
	var _t132 = J.gp(J.gp(env["el"], "dataset"), "g")
	v_id_67 = (_t132 if J.t(_t132) else null)
	v_put_68 = Callable(self, "_f29").bind(env)
	if J.t(v_id_67):
		var _t136 = J.gp(J.G.get("S"), "team")
		var _t138 = null
		if J.cmp(J.mc(_t136, "indexOf", [v_id_67]), 0.0, ">="):
			var _t137 = J.gp(J.G.get("S"), "team")
			_t138 = J.add("", J.mc(_t137, "indexOf", [v_id_67]))
		else:
			_t138 = ("adv" if J.seq(J.gp(J.G.get("S"), "adviser"), v_id_67) else null)
		v_from_71 = _t138
		if (not J.seq(v_from_71, null)):
			J.cl(v_put_68, null, [v_from_71, (env["__p"]["cur"] if J.t(env["__p"]["cur"]) else null)])
	J.cl(v_put_68, null, [env["__p"]["slot"], v_id_67])
	J.cl(J.G.get("save"), null, [])
	J.mc(env["__p"]["this"], "openSelect", [])

func _f27(this_, a: Array, env):
	var _s42 = {"__p": env, "el": null}
	_s42["el"] = J.arg(a, 0)
	var _t131 = _s42["el"]
	var _t139 = Callable(self, "_f28").bind(_s42)
	J.sp(_t131, "onclick", _t139)
	return _t139

func _f24(this_, a: Array, env):
	var v_used_58 = null; var v_list_59 = null; var v_h_60 = null; var v_g_63 = null; var v_sk_64 = null; var v_where_65 = null
	var _s37 = {"__p": env, "this": null, "slot": null, "cur": null}
	_s37["this"] = this_
	_s37["slot"] = J.arg(a, 0)
	_s37["cur"] = (J.gp(J.G.get("S"), "adviser") if J.seq(_s37["slot"], "adv") else J.gp(J.gp(J.G.get("S"), "team"), J.num(_s37["slot"])))
	var _t102 = J.spread([J.SP(J.gp(J.G.get("S"), "team")), J.gp(J.G.get("S"), "adviser")])
	v_used_58 = J.new_("Set", [J.mc(_t102, "filter", [J.G.get("Boolean")])])
	var _t103 = J.mc(J.gp(J.G.get("S"), "ghosts"), "slice", [])
	v_list_59 = J.mc(_t103, "sort", [Callable(self, "_f25").bind(_s37)])
	v_h_60 = ("<p class=\"desc\">選擇" + ("軍師（看智力）" if J.seq(_s37["slot"], "adv") else "出陣鬼怪") + "。已在別的位置的，會互換。</p><div class=\"glist\">")
	if J.t(_s37["cur"]):
		var _t104 = J.add(v_h_60, ("<div class=\"gi\" data-g=\"\"><div><b>— 空著 —</b></div></div>"))
		v_h_60 = _t104
	for _t105 in J.iter(v_list_59):
		v_g_63 = _t105
		v_sk_64 = J.gp(J.G.get("SKILLS"), J.gp(v_g_63, "k"))
		var _t106 = J.gp(J.G.get("S"), "team")
		v_where_65 = ("出陣中" if J.t(J.mc(_t106, "includes", [J.gp(v_g_63, "id")])) else ("軍師" if J.seq(J.gp(J.G.get("S"), "adviser"), J.gp(v_g_63, "id")) else ""))
		var _t108 = ("sel" if J.seq(J.gp(v_g_63, "id"), _s37["cur"]) else "")
		var _t109 = J.gp(v_g_63, "id")
		var _t110 = J.gp(v_g_63, "k")
		var _t111 = J.gp(v_g_63, "name")
		var _t112 = J.gp(v_g_63, "q")
		var _t113 = J.gp(v_g_63, "q")
		var _t114 = (("<i class=\"tag\">" + J.str(v_where_65) + "</i>") if J.t(v_where_65) else "")
		var _t115 = J.mc(J.G.get("F"), "glv", [v_g_63])
		var _t116 = J.mc(J.G.get("GP"), "T", ["鬼力", "鬼力"])
		var _t117 = J.mc(J.G.get("GP"), "pow", [v_g_63])
		var _t118 = J.mc(J.G.get("F"), "stat", [v_g_63, 0.0])
		var _t119 = J.mc(J.G.get("F"), "stat", [v_g_63, 1.0])
		var _t120 = J.mc(J.G.get("F"), "stat", [v_g_63, 2.0])
		var _t107 = J.G.get("gdef")
		var _t121 = J.add(v_h_60, ("<div class=\"gi " + _t108 + "\" data-g=\"" + J.str(_t109) + "\"><canvas data-por=\"" + J.str(_t110) + "\"></canvas><div><b>" + J.str(_t111) + "</b> <i class=\"q q" + J.str(_t112) + "\">" + J.str(_t113) + "</i> " + _t114 + "<small>Lv" + J.str(_t115) + "　<b class=\"gp-pw\">" + J.str(_t116) + " " + J.str(_t117) + "</b>　力" + J.str(_t118) + " 智" + J.str(_t119) + " 武" + J.str(_t120) + "　" + ("遠程" if J.seq(J.gp(J.cl(_t107, null, [v_g_63]), "range"), "ranged") else "近戰") + "<br>" + J.str(J.mc(J.G.get("Rework"), "teamHint", [v_g_63])) + "</small><small class=\"sk\">【" + J.str(J.gp(v_sk_64, "name")) + "】" + J.str(J.gp(v_sk_64, "desc")) + "</small></div></div>"))
		v_h_60 = _t121
	var _t122 = J.add(v_h_60, ("</div><button class=\"btn wide\" id=\"pkback\">返回</button>"))
	v_h_60 = _t122
	J.mc(J.G.get("UI"), "sheet", ["佈陣", v_h_60])
	var _t123 = J.G.get("paintPortraits")
	var _t124 = J.G.get("$")
	J.cl(_t123, null, [J.cl(_t124, null, ["#sheet"])])
	var _t125 = J.G.get("$")
	var _t126 = J.cl(_t125, null, ["#pkback"])
	var _t127 = Callable(self, "_f26").bind(_s37)
	J.sp(_t126, "onclick", _t127)
	var _t128 = J.G.get("$")
	var _t129 = J.cl(_t128, null, ["#sheet"])
	var _t130 = J.mc(_t129, "querySelectorAll", [".gi"])
	J.mc(_t130, "forEach", [Callable(self, "_f27").bind(_s37)])

func _f31(this_, a: Array, env):
	return J.mc(env["this"], "start", [env["ci"], env["si"]])

func _f32(this_, a: Array, env):
	var v_id_81 = null
	v_id_81 = J.arg(a, 0)
	if (not J.t(J.gp(J.gp(J.G.get("S"), "seen"), v_id_81))):
		J.mc(J.G.get("Story"), "queue", [v_id_81])
		env["any"] = true

func _f30(this_, a: Array, env):
	var v_ch_76 = null; var v_st_77 = null; var v_sid_78 = null; var v_go_79 = null
	var _s46 = {"__p": env, "this": null, "ci": null, "si": null, "any": null}
	_s46["this"] = this_
	_s46["ci"] = J.arg(a, 0)
	_s46["si"] = J.arg(a, 1)
	var _t140 = J.gp(J.G.get("S"), "team")
	if (not J.t(J.mc(_t140, "some", [J.G.get("Boolean")]))):
		J.mc(J.G.get("Fx"), "toast", ["至少要派一位鬼怪出陣"])
		return null
	v_ch_76 = J.gp(J.G.get("CHAPTERS"), _s46["ci"])
	v_st_77 = J.gp(J.gp(v_ch_76, "stages"), _s46["si"])
	v_sid_78 = J.mc(_s46["this"], "sidOf", [_s46["ci"], _s46["si"]])
	J.mc(J.G.get("UI"), "close", [])
	v_go_79 = Callable(self, "_f31").bind(_s46)
	_s46["any"] = false
	if J.seq(_s46["si"], 0.0):
		var _t141 = J.gp(v_ch_76, "intro")
		J.mc(_t141, "forEach", [Callable(self, "_f32").bind(_s46)])
	var _t142 = J.gp(v_st_77, "before")
	var _t143 = ((not J.t(J.gp(J.gp(J.G.get("S"), "cleared"), v_sid_78))) if J.t(_t142) else _t142)
	if J.t(((not J.t(J.gp(J.gp(J.G.get("S"), "seen"), J.gp(v_st_77, "before")))) if J.t(_t143) else _t143)):
		J.mc(J.G.get("Story"), "queue", [J.gp(v_st_77, "before")])
		_s46["any"] = true
	if J.t(_s46["any"]):
		J.mc(J.G.get("Story"), "queue", [{"style": "narr", "lines": [["旁白", (J.str(v_sid_78) + "　" + J.str(J.gp(v_st_77, "name")))]]}, v_go_79])
	else:
		J.cl(v_go_79, null, [])

func _f33(this_, a: Array, env):
	var v_g_84 = null; var v_i_85 = null; var v_lv_86 = null; var v_P_87 = null; var v_I_88 = null; var v_A_89 = null; var v_d_90 = null; var v_dm_91 = null; var v_hp_92 = null
	v_g_84 = J.arg(a, 0)
	v_i_85 = J.arg(a, 1)
	v_lv_86 = J.mc(J.G.get("F"), "glv", [v_g_84])
	v_P_87 = J.mc(J.G.get("F"), "stat", [v_g_84, 0.0])
	v_I_88 = J.mc(J.G.get("F"), "stat", [v_g_84, 1.0])
	v_A_89 = J.mc(J.G.get("F"), "stat", [v_g_84, 2.0])
	var _t144 = J.G.get("gdef")
	v_d_90 = J.cl(_t144, null, [v_g_84])
	v_dm_91 = J.mc(J.G.get("GP"), "drillMul", [J.gp(v_g_84, "k")])
	v_hp_92 = J.mul(((300.0 + J.mul(v_P_87, 8.0)) + J.mul(v_A_89, 4.0)), v_dm_91)
	return {"side": 0.0, "k": J.gp(v_g_84, "k"), "gid": J.gp(v_g_84, "id"), "name": J.gp(v_g_84, "name"), "hp": v_hp_92, "maxhp": v_hp_92, "atk": J.mul((20.0 + J.mul(v_A_89, 1.4)), v_dm_91), "range": (150.0 if J.seq(J.gp(v_d_90, "range"), "ranged") else 46.0), "spd": (38.0 if J.seq(J.gp(v_d_90, "range"), "ranged") else 46.0), "x": (78.0 - J.mul(v_i_85, 14.0)), "lane": J.mul(v_i_85, 1.1), "energy": 20.0, "sk": J.gp(J.G.get("SKILLS"), J.gp(v_g_84, "k")), "st": {}, "cd": (randf() * 0.5), "lv": v_lv_86}

func _f35(this_, a: Array, env):
	var v_g_104 = null; var v_i_105 = null
	v_g_104 = J.arg(a, 0)
	v_i_105 = J.arg(a, 1)
	var _t177 = J.gp(env["this"], "units")
	return J.mc(_t177, "push", [J.mc(env["this"], "mkGhostUnit", [v_g_104, v_i_105])])

func _f36(this_, a: Array, env):
	var v_e_108 = null; var v_i_109 = null; var v_T_110 = null; var v_hp_111 = null
	v_e_108 = J.arg(a, 0)
	v_i_109 = J.arg(a, 1)
	v_T_110 = J.gp(J.G.get("ENEMY_T"), v_e_108)
	v_hp_111 = J.mul((260.0 + J.mul(90.0, J.gp(env["st"], "p"))), J.gp(v_T_110, 0.0))
	var _t184 = J.gp(env["this"], "units")
	var _t186 = J.gp(v_T_110, 2.0)
	var _t187 = J.mul((16.0 + J.mul(7.5, J.gp(env["st"], "p"))), J.gp(v_T_110, 1.0))
	var _t185 = ["zhiren", "penanggal"]
	J.mc(_t184, "push", [{"side": 1.0, "k": v_e_108, "name": _t186, "hp": v_hp_111, "maxhp": v_hp_111, "atk": _t187, "range": (140.0 if J.t(J.mc(_t185, "includes", [v_e_108])) else 46.0), "spd": (58.0 if J.seq(v_e_108, "xiaogui") else 42.0), "x": (318.0 + (J.mod(v_i_109, 2.0) * 22.0)), "lane": J.mul(v_i_109, 1.05), "energy": (30.0 if J.seq(v_e_108, J.gp(env["st"], "boss")) else 0.0), "sk": J.gp(J.G.get("SKILLS"), v_e_108), "st": {}, "cd": (randf() * 0.6), "boss": J.seq(v_e_108, J.gp(env["st"], "boss"))}])

func _f34(this_, a: Array, env):
	var v_ci_95 = null; var v_si_96 = null; var v_wild_97 = null; var v_ch_98 = null; var v_team_100 = null; var v_ad_101 = null; var v_sq_102 = null; var v_tb_103 = null; var v_i_106 = null; var v_hp_107 = null
	var _s53 = {"__p": env, "this": null, "st": null}
	_s53["this"] = this_
	v_ci_95 = J.arg(a, 0)
	v_si_96 = J.arg(a, 1)
	v_wild_97 = J.arg(a, 2)
	v_ch_98 = ({"bg": J.gp(v_wild_97, "bg")} if J.t(v_wild_97) else J.gp(J.G.get("CHAPTERS"), v_ci_95))
	_s53["st"] = (J.gp(v_wild_97, "stage") if J.t(v_wild_97) else J.gp(J.gp(v_ch_98, "stages"), v_si_96))
	var _t145 = _s53["this"]
	J.sp(_t145, "ci", v_ci_95)
	var _t146 = _s53["this"]
	J.sp(_t146, "si", v_si_96)
	var _t147 = _s53["this"]
	var _t148 = _s53["st"]
	J.sp(_t147, "stage", _t148)
	var _t149 = _s53["this"]
	var _t150 = (J.gp(v_wild_97, "sid") if J.t(v_wild_97) else J.mc(_s53["this"], "sidOf", [v_ci_95, v_si_96]))
	J.sp(_t149, "sid", _t150)
	var _t151 = _s53["this"]
	var _t152 = J.gp(v_ch_98, "bg")
	J.sp(_t151, "bg", _t152)
	var _t153 = _s53["this"]
	var _t154 = []
	J.sp(_t153, "units", _t154)
	var _t155 = _s53["this"]
	var _t156 = []
	J.sp(_t155, "fx", _t156)
	var _t157 = _s53["this"]
	J.sp(_t157, "t", 0.0)
	var _t158 = _s53["this"]
	J.sp(_t158, "result", null)
	var _t159 = _s53["this"]
	J.sp(_t159, "combo", 0.0)
	var _t160 = _s53["this"]
	J.sp(_t160, "comboT", 0.0)
	var _t161 = _s53["this"]
	J.sp(_t161, "coinsWon", 0.0)
	var _t162 = _s53["this"]
	J.sp(_t162, "timeLimit", 90.0)
	var _t163 = _s53["this"]
	var _t164 = []
	J.sp(_t163, "proj", _t164)
	var _t165 = _s53["this"]
	J.sp(_t165, "hitStop", 0.0)
	var _t166 = _s53["this"]
	J.sp(_t166, "slowT", 0.0)
	var _t167 = _s53["this"]
	J.sp(_t167, "shakeA", 0.0)
	var _t168 = _s53["this"]
	J.sp(_t168, "flashT", 0.0)
	var _t169 = _s53["this"]
	J.sp(_t169, "advCast", null)
	var _t170 = _s53["this"]
	J.sp(_t170, "comboCast", null)
	var _t171 = _s53["this"]
	var _t172 = (-9.0)
	J.sp(_t171, "lastHS", _t172)
	var _t173 = _s53["this"]
	J.sp(_t173, "comboPop", 0.0)
	var _t174 = _s53["this"]
	J.sp(_t174, "hsBank", 0.12)
	var _t175 = J.gp(J.G.get("S"), "team")
	var _t176 = J.mc(_t175, "map", [J.G.get("ghostById")])
	v_team_100 = J.mc(_t176, "filter", [J.G.get("Boolean")])
	J.mc(v_team_100, "forEach", [Callable(self, "_f35").bind(_s53)])
	var _t178 = J.G.get("ghostById")
	v_ad_101 = J.cl(_t178, null, [J.gp(J.G.get("S"), "adviser")])
	var _t179 = _s53["this"]
	var _t180 = ({"k": J.gp(v_ad_101, "k"), "name": J.gp(v_ad_101, "name"), "energy": 0.0, "sk": J.gp(J.G.get("SKILLS"), J.gp(v_ad_101, "k")), "bonus": J.div(J.div(J.mc(J.G.get("F"), "stat", [v_ad_101, 1.0]), 8.0), 100.0), "atk": (20.0 + J.mul(J.mc(J.G.get("F"), "stat", [v_ad_101, 2.0]), 1.4)), "side": 0.0} if J.t(v_ad_101) else null)
	J.sp(_t179, "adviser", _t180)
	v_sq_102 = J.min_([8.0, floor(J.num(J.div(J.gp(J.gp(J.G.get("S"), "res"), "troops"), 25.0)))])
	var _t181 = _s53["this"]
	J.sp(_t181, "squads", v_sq_102)
	v_tb_103 = (1.0 + (0.08 * J.max_([0.0, J.sub(J.gp(J.gp(J.G.get("S"), "bld"), "home"), 1.0)])))
	v_i_106 = 0.0
	while true:
		if not J.cmp(v_i_106, v_sq_102, "<"): break
		v_hp_107 = J.mul((90.0 + J.mul(14.0, J.gp(J.G.get("S"), "lv"))), v_tb_103)
		var _t182 = J.gp(_s53["this"], "units")
		J.mc(_t182, "push", [{"side": 0.0, "k": "youhun", "name": "陰兵", "minion": true, "hp": v_hp_107, "maxhp": v_hp_107, "atk": J.mul((9.0 + J.mul(2.2, J.gp(J.G.get("S"), "lv"))), v_tb_103), "range": 38.0, "spd": 52.0, "x": (120.0 + (floor(J.num(J.div(v_i_106, 4.0))) * 18.0)), "lane": ((J.mod(v_i_106, 4.0) * 0.95) + 0.4), "energy": 0.0, "sk": null, "st": {}, "cd": randf()}])
		v_i_106 = J.num(v_i_106) + 1.0
	var _t183 = J.gp(_s53["st"], "en")
	J.mc(_t183, "forEach", [Callable(self, "_f36").bind(_s53)])
	if (not J.seq(J.typeof_(J.G.get("GhostStreet")), "undefined")):
		J.mc(J.G.get("GhostStreet"), "battleBuffs", [J.gp(_s53["this"], "units")])
	var _t188 = _s53["this"]
	J.sp(_t188, "active", true)
	J.mc(J.G.get("Sound"), "setMode", ["battle"])
	var _t189 = _s53["this"]
	J.sp(_t189, "sndT", 0.0)
	var _t190 = J.G.get("$")
	var _t191 = J.gp(J.cl(_t190, null, ["#battle"]), "classList")
	J.mc(_t191, "add", ["on"])
	J.mc(_s53["this"], "resize", [])
	J.mc(_s53["this"], "buildCards", [])
	J.mc(_s53["this"], "syncBtns", [])
	var _t192 = J.G.get("$")
	var _t193 = J.cl(_t192, null, ["#b-title"])
	var _t194 = (("野鬼　" + J.str(J.gp(_s53["st"], "name"))) if J.t(J.gp(_s53["st"], "wild")) else (J.str(J.gp(_s53["this"], "sid")) + "　" + J.str(J.gp(_s53["st"], "name"))))
	J.sp(_t193, "textContent", _t194)
	var _t195 = _s53["this"]
	J.sp(_t195, "_nat", false)
	var _t197 = (not J.seq(J.typeof_(J.G.get("__nat_battle")), "undefined"))
	if J.t(_t197):
		var _t196 = J.G.get("__nat_battle")
		_t197 = J.cl(_t196, null, [_s53["this"]])
	if J.t(_t197):
		var _t198 = _s53["this"]
		J.sp(_t198, "_nat", true)
		J.mc(_s53["this"], "resize", [])

func _f37(this_, a: Array, env):
	var v_r_114 = null; var v_r_115 = null
	if J.t(J.gp(this_, "_nat")):
		v_r_115 = J.cl(J.G.get("__nat_btSize"), null, [])
		var _t199 = this_
		J.sp(_t199, "dpr", 1.0)
		var _t200 = this_
		var _t201 = J.gp(v_r_115, 0.0)
		J.sp(_t200, "w", _t201)
		var _t202 = this_
		var _t203 = J.gp(v_r_115, 1.0)
		J.sp(_t202, "h", _t203)
		var _t204 = this_
		var _t205 = J.div(J.gp(this_, "w"), 390.0)
		J.sp(_t204, "sc", _t205)
		return null
	v_r_114 = J.mc(J.gp(this_, "cvs"), "getBoundingClientRect", [])
	var _t206 = this_
	var _t207 = J.gp(J.G.get("window"), "devicePixelRatio")
	var _t208 = J.gp(J.G.get("window"), "devicePixelRatio")
	var _t209 = J.min_([2.0, (_t208 if J.t(_t208) else 1.0)])
	J.sp(_t206, "dpr", _t209)
	var _t210 = J.gp(this_, "cvs")
	var _t211 = J.mul(J.gp(v_r_114, "width"), J.gp(this_, "dpr"))
	J.sp(_t210, "width", _t211)
	var _t212 = J.gp(this_, "cvs")
	var _t213 = J.mul(J.gp(v_r_114, "height"), J.gp(this_, "dpr"))
	J.sp(_t212, "height", _t213)
	var _t214 = this_
	var _t215 = J.gp(v_r_114, "width")
	J.sp(_t214, "w", _t215)
	var _t216 = this_
	var _t217 = J.gp(v_r_114, "height")
	J.sp(_t216, "h", _t217)
	var _t218 = this_
	var _t219 = J.div(J.gp(this_, "w"), 390.0)
	J.sp(_t218, "sc", _t219)

func _f40(this_, a: Array, env):
	return J.mc(env["__p"]["this"], "cast", [env["u"]])

func _f39(this_, a: Array, env):
	var v_isAdv_121 = null; var v_d_122 = null; var v_p_123 = null; var v_c_124 = null
	var _s62 = {"__p": env, "u": null}
	_s62["u"] = J.arg(a, 0)
	v_isAdv_121 = J.arg(a, 1)
	v_d_122 = J.S_document_("createElement", ["button"])
	var _t222 = ("bcard" + (" adv" if J.t(v_isAdv_121) else ""))
	J.sp(v_d_122, "className", _t222)
	var _t223 = ("<canvas></canvas><b>" + J.str((J.gp(J.gp(_s62["u"], "sk"), "name") if J.t(J.gp(_s62["u"], "sk")) else "")) + "</b><small>" + ("軍師・" if J.t(v_isAdv_121) else "") + J.str(J.gp(_s62["u"], "name")) + "</small><i class=\"en\"><s></s></i>")
	J.sp(v_d_122, "innerHTML", _t223)
	v_p_123 = J.mc(J.G.get("ART"), "portrait", [J.gp(_s62["u"], "k"), 56.0, {"tamed": true, "untied": true}])
	v_c_124 = J.mc(v_d_122, "querySelector", ["canvas"])
	var _t224 = J.gp(v_p_123, "width")
	J.sp(v_c_124, "width", _t224)
	var _t225 = J.gp(v_p_123, "height")
	J.sp(v_c_124, "height", _t225)
	var _t226 = J.mc(v_c_124, "getContext", ["2d"])
	J.mc(_t226, "drawImage", [v_p_123, 0.0, 0.0])
	var _t227 = Callable(self, "_f40").bind(_s62)
	J.sp(v_d_122, "onclick", _t227)
	var _t228 = _s62["u"]
	J.sp(_t228, "card", v_d_122)
	J.mc(_s62["__p"]["box"], "appendChild", [v_d_122])

func _f41(this_, a: Array, env):
	var v_u_125 = null
	v_u_125 = J.arg(a, 0)
	var _t230 = J.seq(J.gp(v_u_125, "side"), 0.0)
	return ((not J.t(J.gp(v_u_125, "minion"))) if _t230 else _t230)

func _f42(this_, a: Array, env):
	var v_u_126 = null
	v_u_126 = J.arg(a, 0)
	var _t232 = env["mk"]
	return J.cl(_t232, null, [v_u_126, false])

func _f43(this_, a: Array, env):
	var v_u_130 = null
	v_u_130 = J.arg(a, 0)
	var _t237 = J.seq(J.gp(v_u_130, "side"), 0.0)
	return (J.seq(J.gp(v_u_130, "k"), J.gp(env["c"], "a")) if _t237 else _t237)

func _f44(this_, a: Array, env):
	var v_u_131 = null
	v_u_131 = J.arg(a, 0)
	var _t239 = J.seq(J.gp(v_u_131, "side"), 0.0)
	return (J.seq(J.gp(v_u_131, "k"), J.gp(env["c"], "b")) if _t239 else _t239)

func _f45(this_, a: Array, env):
	return J.mc(env["__p"]["this"], "castCombo", [])

func _f38(this_, a: Array, env):
	var v_a_128 = null; var v_b_129 = null; var v_d_132 = null
	var _s61 = {"__p": env, "this": null, "box": null, "mk": null}
	_s61["this"] = this_
	var _t220 = J.G.get("$")
	_s61["box"] = J.cl(_t220, null, ["#b-cards"])
	var _t221 = _s61["box"]
	J.sp(_t221, "innerHTML", "")
	_s61["mk"] = Callable(self, "_f39").bind(_s61)
	var _t229 = J.gp(_s61["this"], "units")
	var _t231 = J.mc(_t229, "filter", [Callable(self, "_f41").bind(_s61)])
	J.mc(_t231, "forEach", [Callable(self, "_f42").bind(_s61)])
	if J.t(J.gp(_s61["this"], "adviser")):
		var _t233 = _s61["mk"]
		J.cl(_t233, null, [J.gp(_s61["this"], "adviser"), true])
	var _t234 = _s61["this"]
	J.sp(_t234, "comboSkill", null)
	if J.cmp(J.gp(J.G.get("S"), "lv"), 17.0, ">="):
		for _t235 in J.iter(J.G.get("COMBOS")):
			var _s66 = {"__p": _s61, "c": null}
			_s66["c"] = _t235
			var _t236 = J.gp(_s66["__p"]["this"], "units")
			v_a_128 = J.mc(_t236, "find", [Callable(self, "_f43").bind(_s66)])
			var _t238 = J.gp(_s66["__p"]["this"], "units")
			v_b_129 = J.mc(_t238, "find", [Callable(self, "_f44").bind(_s66)])
			if J.t((v_b_129 if J.t(v_a_128) else v_a_128)):
				var _t240 = _s66["__p"]["this"]
				var _t241 = {"c": _s66["c"], "a": v_a_128, "b": v_b_129, "energy": 0.0}
				J.sp(_t240, "comboSkill", _t241)
				v_d_132 = J.S_document_("createElement", ["button"])
				J.sp(v_d_132, "className", "bcard combo")
				var _t242 = ("<b>合體技</b><b>" + J.str(J.gp(_s66["c"], "name")) + "</b><small>" + J.str(J.gp(v_a_128, "name")) + "＋" + J.str(J.gp(v_b_129, "name")) + "</small><i class=\"en\"><s></s></i>")
				J.sp(v_d_132, "innerHTML", _t242)
				var _t243 = Callable(self, "_f45").bind(_s66)
				J.sp(v_d_132, "onclick", _t243)
				var _t244 = J.gp(_s66["__p"]["this"], "comboSkill")
				J.sp(_t244, "card", v_d_132)
				J.mc(_s66["__p"]["box"], "appendChild", [v_d_132])
				break

func _f47(this_, a: Array, env):
	var v_v_136 = null
	v_v_136 = J.arg(a, 0)
	var _t246 = (not J.seq(J.gp(v_v_136, "side"), J.gp(env["u"], "side")))
	return (J.cmp(J.gp(v_v_136, "hp"), 0.0, ">") if _t246 else _t246)

func _f46(this_, a: Array, env):
	var _s72 = {"__p": env, "u": null}
	_s72["u"] = J.arg(a, 0)
	var _t245 = J.gp(this_, "units")
	return J.mc(_t245, "filter", [Callable(self, "_f47").bind(_s72)])

func _f48(this_, a: Array, env):
	var v_u_139 = null; var v_best_140 = null; var v_bd_141 = null; var v_v_142 = null; var v_d_143 = null
	v_u_139 = J.arg(a, 0)
	v_best_140 = null
	v_bd_141 = 1000000000.0
	for _t247 in J.iter(J.mc(this_, "enemiesOf", [v_u_139])):
		v_v_142 = _t247
		v_d_143 = (absf(J.num(J.sub(J.gp(v_v_142, "x"), J.gp(v_u_139, "x")))) + (absf(J.num(J.sub(J.gp(v_v_142, "lane"), J.gp(v_u_139, "lane")))) * 18.0))
		if J.cmp(v_d_143, v_bd_141, "<"):
			v_bd_141 = v_d_143
			v_best_140 = v_v_142
	return v_best_140

func _f49(this_, a: Array, env):
	var v_v_146 = null
	v_v_146 = J.arg(a, 0)
	return ("air" if J.cmp(J.gp(J.gp(v_v_146, "st"), "air"), 0.0, ">") else ("down" if J.cmp(J.gp(J.gp(v_v_146, "st"), "down"), 0.0, ">") else null))

func _f50(this_, a: Array, env):
	var v_sec_149 = null; var v_must_150 = null; var v_b_151 = null
	v_sec_149 = J.arg(a, 0)
	v_must_150 = J.arg(a, 1)
	var _t248 = J.gp(this_, "hsBank")
	v_b_151 = (_t248 if J.t(_t248) else 0.0)
	if J.cmp(v_b_151, ((-0.04) if J.t(v_must_150) else v_sec_149), "<"):
		return null
	var _t249 = this_
	var _t250 = J.sub(v_b_151, v_sec_149)
	J.sp(_t249, "hsBank", _t250)
	var _t251 = this_
	var _t252 = J.gp(this_, "hitStop")
	var _t253 = J.gp(this_, "hitStop")
	var _t254 = J.max_([(_t253 if J.t(_t253) else 0.0), J.div(v_sec_149, J.gp(this_, "speed"))])
	J.sp(_t251, "hitStop", _t254)

func _f51(this_, a: Array, env):
	var v_amp_154 = null
	v_amp_154 = J.arg(a, 0)
	var _t255 = this_
	var _t256 = J.gp(this_, "shakeA")
	var _t257 = J.gp(this_, "shakeA")
	var _t258 = J.max_([(_t257 if J.t(_t257) else 0.0), v_amp_154])
	J.sp(_t255, "shakeA", _t258)

func _f52(this_, a: Array, env):
	var v_src_157 = null; var v_v_158 = null; var v_mult_159 = null; var v_sk_160 = null; var v_m_161 = null; var v_bonus_162 = null; var v_comboHit_163 = null; var v_dmg_164 = null; var v_dir_165 = null; var v_s_166 = null; var v_hy_167 = null; var v_big_168 = null
	v_src_157 = J.arg(a, 0)
	v_v_158 = J.arg(a, 1)
	v_mult_159 = J.arg(a, 2)
	v_sk_160 = J.arg(a, 3)
	v_m_161 = v_mult_159
	var _t259 = J.seq(J.gp(v_src_157, "side"), 0.0)
	v_bonus_162 = (J.add(1.0, J.gp(J.gp(this_, "adviser"), "bonus")) if J.t((J.gp(this_, "adviser") if _t259 else _t259)) else 1.0)
	v_comboHit_163 = false
	var _t260 = (J.gp(v_sk_160, "follow") if J.t(v_sk_160) else v_sk_160)
	if J.t((J.seq(J.mc(this_, "stateOf", [v_v_158]), J.gp(v_sk_160, "follow")) if J.t(_t260) else _t260)):
		var _t261 = J.mul(v_m_161, 1.8)
		v_m_161 = _t261
		v_comboHit_163 = true
	v_dmg_164 = J.round(J.num((J.mul(J.mul(J.gp(v_src_157, "atk"), v_m_161), v_bonus_162) * (0.9 + (randf() * 0.2)))))
	var _t262 = J.sub(J.gp(v_v_158, "hp"), v_dmg_164)
	J.sp(v_v_158, "hp", _t262)
	var _t265 = v_sk_160
	if not J.t(_t265):
		var _t264 = J.gp(this_, "t")
		var _t263 = J.gp(this_, "sndT")
		_t265 = (J.sub(_t264, (_t263 if J.t(_t263) else 0.0)) > 0.09)
	if J.t(_t265):
		var _t266 = this_
		var _t267 = J.gp(this_, "t")
		J.sp(_t266, "sndT", _t267)
		J.mc(J.G.get("Sound"), "play", ["hit"])
	var _t268 = signf(J.num(J.sub(J.gp(v_v_158, "x"), (J.gp(v_src_157, "x") if (not J.leq(J.gp(v_src_157, "x"), null)) else J.sub(J.gp(v_v_158, "x"), (1.0 if J.t(J.gp(v_v_158, "side")) else (-1.0)))))))
	v_dir_165 = (_t268 if J.t(_t268) else (1.0 if J.t(J.gp(v_v_158, "side")) else (-1.0)))
	v_s_166 = J.mc(this_, "scaleOf", [v_v_158])
	v_hy_167 = J.sub(J.mc(this_, "uy", [v_v_158]), J.mul(30.0, v_s_166))
	J.sp(v_v_158, "flash", 1.0)
	var _t269 = ((-J.num(v_dir_165)) if J.seq(J.gp(v_src_157, "k"), "heiwu") else v_dir_165)
	J.sp(v_v_158, "kbDir", _t269)
	J.sp(v_v_158, "kbT", 0.0)
	var _t270 = (not J.t(J.gp(v_v_158, "anim")))
	if ((not J.t(J.gp(v_v_158, "casting"))) if _t270 else _t270):
		J.sp(v_v_158, "hurtT", 0.25)
	J.mc(this_, "spark", [J.sub(J.gp(v_v_158, "x"), J.mul(J.mul(v_dir_165, 6.0), v_s_166)), v_hy_167, (1.35 if J.t((v_comboHit_163 if J.t(v_comboHit_163) else v_sk_160)) else (0.7 if J.t(J.gp(v_v_158, "minion")) else 1.0)), ("#ff9a7a" if J.seq(J.gp(v_v_158, "side"), 0.0) else ("#ffd84a" if J.t(v_comboHit_163) else "#fff4c0"))])
	v_big_168 = (v_comboHit_163 if J.t(v_comboHit_163) else (not (not J.t(v_sk_160))))
	var _t271 = J.gp(this_, "fx")
	J.mc(_t271, "push", [{"kind": "num", "x": J.add(J.gp(v_v_158, "x"), ((randf() - 0.5) * 14.0)), "y": J.sub(J.mc(this_, "uy", [v_v_158]), J.mul(70.0, v_s_166)), "vx": J.mul(v_dir_165, (14.0 + (randf() * 18.0))), "text": J.add("", v_dmg_164), "col": ("#ffd84a" if J.t(v_comboHit_163) else ("#ff8a8a" if J.seq(J.gp(v_v_158, "side"), 0.0) else "#fff")), "t": 0.0, "life": 0.95, "big": v_big_168}])
	var _t273 = J.min_([9.0, ((2.5 if J.t(v_sk_160) else 0.8) + (J.div(v_dmg_164, J.gp(v_v_158, "maxhp")) * 26.0))])
	var _t272 = J.gp(v_v_158, "minion")
	J.mc(this_, "kick", [(_t273 * (0.4 if J.t((J.gp(v_src_157, "minion") if J.t(_t272) else _t272)) else 1.0))])
	if J.t(v_sk_160):
		J.mc(this_, "hitStopFor", [0.12, true])
	else:
		var _t274 = (not J.t(J.gp(v_src_157, "minion")))
		var _t277 = (_t274 if _t274 else (not J.t(J.gp(v_v_158, "minion"))))
		if J.t(_t277):
			var _t276 = J.gp(this_, "t")
			var _t275 = J.gp(this_, "lastHS")
			_t277 = (J.sub(_t276, (_t275 if J.t(_t275) else (-9.0))) > 0.4)
		if _t277:
			var _t278 = this_
			var _t279 = J.gp(this_, "t")
			J.sp(_t278, "lastHS", _t279)
			J.mc(this_, "hitStopFor", [(0.08 if J.cmp(v_dmg_164, J.mul(J.gp(v_v_158, "maxhp"), 0.12), ">") else 0.055)])
	if J.t((J.seq(J.gp(v_src_157, "side"), 0.0) if J.t(v_comboHit_163) else v_comboHit_163)):
		J.mc(J.G.get("Sound"), "play", ["combo", J.gp(this_, "combo")])
		var _t280 = this_
		var _t281 = (J.add(J.gp(this_, "combo"), 1.0) if J.cmp(J.gp(this_, "comboT"), 0.0, ">") else 1.0)
		J.sp(_t280, "combo", _t281)
		var _t282 = this_
		J.sp(_t282, "comboT", 3.0)
		var _t283 = this_
		J.sp(_t283, "comboPop", 1.0)
		var _t284 = J.gp(this_, "fx")
		var _t285 = J.gp(this_, "H")
		J.mc(_t284, "push", [{"x": 195.0, "y": J.mul((_t285 if J.t(_t285) else 640.0), 0.3), "text": ("連嚇 ×" + J.str(J.add(J.gp(this_, "combo"), 1.0)) + "！"), "col": "#ffd84a", "t": 0.0, "life": 1.2, "center": true}])
	var _t286 = (J.gp(v_sk_160, "apply") if J.t(v_sk_160) else v_sk_160)
	if J.t((J.cmp(J.gp(v_v_158, "hp"), 0.0, ">") if J.t(_t286) else _t286)):
		if J.seq(J.gp(v_sk_160, "apply"), "air"):
			var _t287 = J.gp(v_v_158, "st")
			var _t288 = J.gp(v_v_158, "st")
			J.sp(_t288, "airMax", 1.0)
			J.sp(_t287, "air", 1.0)
			var _t289 = J.gp(v_v_158, "st")
			J.sp(_t289, "down", 0.0)
		if J.seq(J.gp(v_sk_160, "apply"), "down"):
			var _t290 = J.gp(v_v_158, "st")
			var _t291 = J.gp(v_v_158, "st")
			J.sp(_t291, "downMax", 1.4)
			J.sp(_t290, "down", 1.4)
			var _t292 = J.gp(v_v_158, "st")
			J.sp(_t292, "air", 0.0)
			J.mc(this_, "dust", [J.gp(v_v_158, "x"), J.mc(this_, "uy", [v_v_158]), 1.2])
		if J.seq(J.gp(v_sk_160, "apply"), "push"):
			var _t293 = J.gp(v_v_158, "st")
			J.sp(_t293, "push", 0.25)
		J.sp(v_v_158, "anim", null)
	if J.t((J.gp(v_sk_160, "drain") if J.t(v_sk_160) else v_sk_160)):
		var _t294 = J.min_([J.gp(v_src_157, "maxhp"), J.add(J.gp(v_src_157, "hp"), J.mul(v_dmg_164, J.gp(v_sk_160, "drain")))])
		J.sp(v_src_157, "hp", _t294)
	if J.t((J.gp(v_sk_160, "sap") if J.t(v_sk_160) else v_sk_160)):
		var _t295 = J.max_([0.0, J.sub(J.gp(v_v_158, "energy"), J.gp(v_sk_160, "sap"))])
		J.sp(v_v_158, "energy", _t295)
	var _t296 = (J.gp(v_sk_160, "steal") if J.t(v_sk_160) else v_sk_160)
	if J.t((J.seq(J.gp(v_src_157, "side"), 0.0) if J.t(_t296) else _t296)):
		var _t297 = this_
		var _t298 = J.add(J.gp(_t297, "coinsWon"), J.gp(v_sk_160, "steal"))
		J.sp(_t297, "coinsWon", _t298)
	if (not J.t(v_sk_160)):
		var _t299 = J.min_([100.0, J.add(J.gp(v_src_157, "energy"), 8.0)])
		J.sp(v_src_157, "energy", _t299)
	var _t300 = J.min_([100.0, J.add(J.gp(v_v_158, "energy"), 4.0)])
	J.sp(v_v_158, "energy", _t300)
	if J.cmp(J.gp(v_v_158, "hp"), 0.0, "<="):
		J.sp(v_v_158, "hp", 0.0)
		J.sp(v_v_158, "deadT", 0.0)
		J.sp(v_v_158, "dieDir", v_dir_165)
		J.sp(v_v_158, "anim", null)
		J.sp(v_v_158, "casting", null)
		if (not J.t(J.gp(v_v_158, "minion"))):
			J.mc(this_, "hitStopFor", [(0.14 if J.t(v_sk_160) else 0.09), true])
		J.mc(this_, "kick", [(3.0 if J.t(J.gp(v_v_158, "minion")) else 7.0)])
		J.mc(this_, "spark", [J.gp(v_v_158, "x"), v_hy_167, 1.6, "#fff"])
	return v_dmg_164

func _f54(this_, a: Array, env):
	var v_v_175 = null
	v_v_175 = J.arg(a, 0)
	var _t302 = J.seq(J.gp(v_v_175, "side"), J.gp(env["u"], "side"))
	return (J.cmp(J.gp(v_v_175, "hp"), 0.0, ">") if _t302 else _t302)

func _f55(this_, a: Array, env):
	var v_v_176 = null; var v_h_177 = null
	v_v_176 = J.arg(a, 0)
	v_h_177 = J.mul(J.gp(v_v_176, "maxhp"), J.gp(env["sk"], "mult"))
	var _t304 = J.min_([J.gp(v_v_176, "maxhp"), J.add(J.gp(v_v_176, "hp"), v_h_177)])
	J.sp(v_v_176, "hp", _t304)
	var _t305 = J.gp(env["this"], "fx")
	J.mc(_t305, "push", [{"x": J.gp(v_v_176, "x"), "y": J.sub(J.mc(env["this"], "uy", [v_v_176]), 90.0), "text": J.add("+", J.round(J.num(v_h_177))), "col": "#8affb0", "t": 0.0, "life": 0.9}])
	var _t306 = J.gp(env["this"], "fx")
	J.mc(_t306, "push", [{"kind": "ring", "x": J.gp(v_v_176, "x"), "y": J.sub(J.mc(env["this"], "uy", [v_v_176]), 30.0), "t": 0.0, "life": 0.5, "col": "#8affb0"}])

func _f56(this_, a: Array, env):
	var v_v_178 = null
	v_v_178 = J.arg(a, 0)
	J.sp(v_v_178, "energy", 0.0)
	return 0.0

func _f57(this_, a: Array, env):
	var v_v_179 = null
	v_v_179 = J.arg(a, 0)
	return J.mc(env["this"], "hit", [env["u"], v_v_179, env["mult"], env["sk"]])

func _f53(this_, a: Array, env):
	var v_extraMult_173 = null; var v_v_180 = null; var v_i_181 = null
	var _s91 = {"__p": env, "this": null, "u": null, "sk": null, "mult": null}
	_s91["this"] = this_
	_s91["u"] = J.arg(a, 0)
	_s91["sk"] = J.arg(a, 1)
	v_extraMult_173 = J.arg(a, 2)
	if (not J.t(_s91["sk"])):
		return null
	_s91["mult"] = J.mul(J.gp(_s91["sk"], "mult"), (v_extraMult_173 if J.t(v_extraMult_173) else 1.0))
	if J.seq(J.gp(_s91["sk"], "kind"), "heal"):
		var _t301 = J.gp(_s91["this"], "units")
		var _t303 = J.mc(_t301, "filter", [Callable(self, "_f54").bind(_s91)])
		J.mc(_t303, "forEach", [Callable(self, "_f55").bind(_s91)])
		if J.t(J.gp(_s91["sk"], "forget")):
			var _t307 = J.mc(_s91["this"], "enemiesOf", [_s91["u"]])
			J.mc(_t307, "forEach", [Callable(self, "_f56").bind(_s91)])
	else:
		if J.seq(J.gp(_s91["sk"], "kind"), "aoe"):
			var _t308 = J.mc(_s91["this"], "enemiesOf", [_s91["u"]])
			J.mc(_t308, "forEach", [Callable(self, "_f57").bind(_s91)])
		else:
			v_v_180 = J.mc(_s91["this"], "nearest", [_s91["u"]])
			if J.t(v_v_180):
				if (not J.leq(J.gp(_s91["u"], "x"), null)):
					var _t309 = J.gp(_s91["this"], "fx")
					var _t311 = J.gp(v_v_180, "x")
					var _t312 = J.sub(J.mc(_s91["this"], "uy", [v_v_180]), J.mul(30.0, J.mc(_s91["this"], "scaleOf", [v_v_180])))
					var _t310 = signf(J.num(J.sub(J.gp(v_v_180, "x"), J.gp(_s91["u"], "x"))))
					J.mc(_t309, "push", [{"kind": "slash", "x": _t311, "y": _t312, "dir": (_t310 if J.t(_t310) else 1.0), "t": 0.0, "life": 0.22, "r": 34.0, "col": ("#bff" if J.seq(J.gp(_s91["u"], "side"), 0.0) else "#f9a")}])
				if J.cmp(J.gp(_s91["sk"], "hits"), 1.0, ">"):
					v_i_181 = 0.0
					while true:
						if not J.cmp(v_i_181, J.gp(_s91["sk"], "hits"), "<"): break
						if J.cmp(J.gp(v_v_180, "hp"), 0.0, ">"):
							J.mc(_s91["this"], "hit", [_s91["u"], v_v_180, J.div(_s91["mult"], J.gp(_s91["sk"], "hits")), (_s91["sk"] if J.seq(v_i_181, J.sub(J.gp(_s91["sk"], "hits"), 1.0)) else J.S_Object_("assign", [{}, _s91["sk"], {"apply": null, "drain": J.gp(_s91["sk"], "drain"), "sap": 0.0, "steal": 0.0}]))])
						v_i_181 = J.num(v_i_181) + 1.0
				else:
					J.mc(_s91["this"], "hit", [_s91["u"], v_v_180, _s91["mult"], _s91["sk"]])
	var _t313 = J.gp(_s91["this"], "fx")
	J.mc(_t313, "push", [{"x": (J.gp(_s91["u"], "x") if (not J.leq(J.gp(_s91["u"], "x"), null)) else 60.0), "y": (J.sub(J.mc(_s91["this"], "uy", [_s91["u"]]), 115.0) if (not J.leq(J.gp(_s91["u"], "x"), null)) else 90.0), "text": J.gp(_s91["sk"], "name"), "col": ("#bff" if J.seq(J.gp(_s91["u"], "side"), 0.0) else "#f9a"), "t": 0.0, "life": 1.1, "skill": true}])
	var _t314 = _s91["this"]
	J.sp(_t314, "flashT", 0.12)
	J.mc(_s91["this"], "kick", [(8.0 if J.seq(J.gp(_s91["sk"], "kind"), "aoe") else 5.0)])
	J.mc(J.G.get("Sound"), "play", ["skill"])

func _f58(this_, a: Array, env):
	var v_u_184 = null
	v_u_184 = J.arg(a, 0)
	J.sp(v_u_184, "energy", 0.0)
	if J.leq(J.gp(v_u_184, "x"), null):
		var _t315 = this_
		var _t316 = {"u": v_u_184, "t": 0.0, "dur": J.gp(this_, "CAST"), "slow": false}
		J.sp(_t315, "advCast", _t316)
		return null
	J.sp(v_u_184, "anim", null)
	J.sp(v_u_184, "walking", false)
	var _t317 = {"t": 0.0, "dur": J.gp(this_, "CAST"), "slow": false}
	J.sp(v_u_184, "casting", _t317)

func _f59(this_, a: Array, env):
	var v_c_187 = null; var v_dt_188 = null; var v_u_189 = null
	v_c_187 = J.arg(a, 0)
	v_dt_188 = J.arg(a, 1)
	v_u_189 = J.arg(a, 2)
	var _t318 = J.add(J.gp(v_c_187, "t"), v_dt_188)
	J.sp(v_c_187, "t", _t318)
	var _t319 = (not J.t(J.gp(v_c_187, "slow")))
	if (J.cmp(J.gp(v_c_187, "t"), J.mul(J.gp(v_c_187, "dur"), 0.5), ">=") if _t319 else _t319):
		J.sp(v_c_187, "slow", true)
		var _t320 = (not J.t(v_u_189))
		var _t321 = (_t320 if _t320 else J.seq(J.gp(v_u_189, "side"), 0.0))
		if J.t((_t321 if _t321 else J.gp(v_u_189, "boss"))):
			var _t322 = this_
			var _t323 = J.gp(this_, "slowT")
			var _t324 = J.gp(this_, "slowT")
			var _t325 = J.max_([(_t324 if J.t(_t324) else 0.0), J.div(0.25, J.gp(this_, "speed"))])
			J.sp(_t322, "slowT", _t325)
	return J.cmp(J.gp(v_c_187, "t"), J.gp(v_c_187, "dur"), ">=")

func _f60(this_, a: Array, env):
	var v_u_192 = null
	v_u_192 = J.arg(a, 0)
	J.sp(v_u_192, "casting", null)
	J.mc(this_, "doSkill", [v_u_192, J.gp(v_u_192, "sk")])

func _f61(this_, a: Array, env):
	var v_u_195 = null
	v_u_195 = J.arg(a, 0)
	var _t326 = J.gp(this_, "result")
	if J.t((_t326 if J.t(_t326) else J.cmp(J.gp(v_u_195, "energy"), 100.0, "<"))):
		return null
	var _t327 = (not J.leq(J.gp(v_u_195, "hp"), null))
	if (J.cmp(J.gp(v_u_195, "hp"), 0.0, "<=") if _t327 else _t327):
		return null
	var _t330 = (not J.leq(J.gp(v_u_195, "x"), null))
	if J.t(_t330):
		var _t328 = J.cmp(J.gp(J.gp(v_u_195, "st"), "air"), 0.0, ">")
		var _t329 = (_t328 if _t328 else J.cmp(J.gp(J.gp(v_u_195, "st"), "down"), 0.0, ">"))
		_t330 = (_t329 if _t329 else J.gp(v_u_195, "casting"))
	if J.t(_t330):
		return null
	var _t331 = J.leq(J.gp(v_u_195, "x"), null)
	if J.t((J.gp(this_, "advCast") if _t331 else _t331)):
		return null
	J.mc(this_, "beginCast", [v_u_195])

func _f62(this_, a: Array, env):
	var v_c_198 = null
	v_c_198 = J.gp(this_, "comboSkill")
	var _t332 = (not J.t(v_c_198))
	var _t333 = (_t332 if _t332 else J.cmp(J.gp(v_c_198, "energy"), 100.0, "<"))
	var _t334 = (_t333 if _t333 else J.gp(this_, "result"))
	var _t335 = (_t334 if J.t(_t334) else J.cmp(J.gp(J.gp(v_c_198, "a"), "hp"), 0.0, "<="))
	var _t336 = (_t335 if J.t(_t335) else J.cmp(J.gp(J.gp(v_c_198, "b"), "hp"), 0.0, "<="))
	if J.t((_t336 if J.t(_t336) else J.gp(this_, "comboCast"))):
		return null
	J.sp(v_c_198, "energy", 0.0)
	var _t337 = this_
	var _t338 = {"t": 0.0, "dur": J.gp(this_, "CAST"), "slow": false}
	J.sp(_t337, "comboCast", _t338)

func _f64(this_, a: Array, env):
	var v_v_203 = null
	v_v_203 = J.arg(a, 0)
	J.mc(env["this"], "hit", [env["src"], v_v_203, J.gp(J.gp(env["c"], "c"), "mult"), {"apply": "air"}])
	var _t341 = J.gp(v_v_203, "st")
	var _t342 = J.gp(v_v_203, "st")
	J.sp(_t342, "downMax", 1.6)
	J.sp(_t341, "down", 1.6)
	var _t343 = J.gp(v_v_203, "st")
	J.sp(_t343, "air", 0.0)
	J.mc(env["this"], "dust", [J.gp(v_v_203, "x"), J.mc(env["this"], "uy", [v_v_203]), 1.3])

func _f63(this_, a: Array, env):
	var _s109 = {"__p": env, "this": null, "c": null, "src": null}
	_s109["this"] = this_
	_s109["c"] = J.gp(_s109["this"], "comboSkill")
	var _t339 = _s109["this"]
	J.sp(_t339, "comboCast", null)
	_s109["src"] = {"atk": J.div(J.add(J.gp(J.gp(_s109["c"], "a"), "atk"), J.gp(J.gp(_s109["c"], "b"), "atk")), 2.0), "side": 0.0, "hp": 1.0, "maxhp": 1.0, "x": J.div(J.add(J.gp(J.gp(_s109["c"], "a"), "x"), J.gp(J.gp(_s109["c"], "b"), "x")), 2.0), "lane": 1.0, "energy": 0.0}
	var _t340 = J.mc(_s109["this"], "enemiesOf", [_s109["src"]])
	J.mc(_t340, "forEach", [Callable(self, "_f64").bind(_s109)])
	var _t344 = J.gp(_s109["this"], "fx")
	var _t345 = J.gp(_s109["this"], "H")
	J.mc(_t344, "push", [{"x": 195.0, "y": J.mul((_t345 if J.t(_t345) else 640.0), 0.34), "text": J.gp(J.gp(_s109["c"], "c"), "name"), "col": "#ffb0ff", "t": 0.0, "life": 1.5, "center": true}])
	J.mc(_s109["this"], "kick", [11.0])
	var _t346 = _s109["this"]
	J.sp(_t346, "flashT", 0.25)

func _f65(this_, a: Array, env):
	var v_u_206 = null; var v_H_207 = null
	v_u_206 = J.arg(a, 0)
	var _t347 = J.gp(this_, "H")
	v_H_207 = (_t347 if J.t(_t347) else 640.0)
	return (J.mul(v_H_207, 0.5) + (J.mul(J.gp(v_u_206, "lane"), v_H_207) * 0.1))

func _f66(this_, a: Array, env):
	var v_u_210 = null
	v_u_210 = J.arg(a, 0)
	return (0.75 if J.t(J.gp(v_u_210, "minion")) else (1.7 if J.t(J.gp(v_u_210, "boss")) else 1.32))

func _f67(this_, a: Array, env):
	var v_u_213 = null
	v_u_213 = J.arg(a, 0)
	return (1.15 if J.cmp(J.gp(v_u_213, "range"), 60.0, ">") else 0.95)

func _f68(this_, a: Array, env):
	var v_u_216 = null; var v_tg_217 = null
	v_u_216 = J.arg(a, 0)
	v_tg_217 = J.arg(a, 1)
	return (J.add(J.gp(this_, "WIND"), J.div(J.max_([0.0, (absf(J.num(J.sub(J.gp(v_tg_217, "x"), J.gp(v_u_216, "x")))) - 10.0)]), J.gp(this_, "PSPD"))) if J.cmp(J.gp(v_u_216, "range"), 60.0, ">") else J.add(J.gp(this_, "WIND"), J.gp(this_, "IMPACT")))

func _f69(this_, a: Array, env):
	var v_u_220 = null
	v_u_220 = J.arg(a, 0)
	return (12.0 if J.t(J.gp(v_u_220, "boss")) else (6.0 if J.t(J.gp(v_u_220, "minion")) else 9.0))

func _f70(this_, a: Array, env):
	var v_u_223 = null; var v_dt_224 = null; var v_a_225 = null; var v_ranged_226 = null; var v_tg_227 = null; var v_n_228 = null; var v_s_229 = null
	v_u_223 = J.arg(a, 0)
	v_dt_224 = J.arg(a, 1)
	v_a_225 = J.gp(v_u_223, "anim")
	var _t348 = J.add(J.gp(v_a_225, "t"), v_dt_224)
	J.sp(v_a_225, "t", _t348)
	var _t349 = J.sub(J.gp(v_u_223, "cd"), v_dt_224)
	J.sp(v_u_223, "cd", _t349)
	v_ranged_226 = J.cmp(J.gp(v_u_223, "range"), 60.0, ">")
	var _t350 = J.seq(J.gp(v_a_225, "name"), "windup")
	if (J.cmp(J.gp(v_a_225, "t"), J.gp(this_, "WIND"), ">=") if _t350 else _t350):
		var _t351 = {"name": "strike", "t": J.sub(J.gp(v_a_225, "t"), J.gp(this_, "WIND")), "dur": J.gp(this_, "STRIKE"), "tg": J.gp(v_a_225, "tg")}
		J.sp(v_u_223, "anim", _t351)
		if J.t(v_ranged_226):
			J.mc(this_, "fire", [v_u_223, J.gp(v_a_225, "tg")])
		else:
			J.mc(this_, "dust", [J.gp(v_u_223, "x"), J.mc(this_, "uy", [v_u_223]), 0.6])
		return null
	if J.seq(J.gp(v_a_225, "name"), "strike"):
		var _t352 = (not J.t(v_ranged_226))
		var _t353 = ((not J.t(J.gp(v_a_225, "done"))) if _t352 else _t352)
		if (J.cmp(J.gp(v_a_225, "t"), J.gp(this_, "IMPACT"), ">=") if _t353 else _t353):
			J.sp(v_a_225, "done", true)
			var _t354 = J.gp(v_a_225, "tg")
			var _t355 = (J.cmp(J.gp(J.gp(v_a_225, "tg"), "hp"), 0.0, ">") if J.t(_t354) else _t354)
			v_tg_227 = (J.gp(v_a_225, "tg") if J.t((J.cmp(absf(J.num(J.sub(J.gp(J.gp(v_a_225, "tg"), "x"), J.gp(v_u_223, "x")))), J.add(J.gp(v_u_223, "range"), 24.0), "<=") if J.t(_t355) else _t355)) else null)
			if (not J.t(v_tg_227)):
				v_n_228 = J.mc(this_, "nearest", [v_u_223])
				if J.t((J.cmp(absf(J.num(J.sub(J.gp(v_n_228, "x"), J.gp(v_u_223, "x")))), J.add(J.gp(v_u_223, "range"), 24.0), "<=") if J.t(v_n_228) else v_n_228)):
					v_tg_227 = v_n_228
			if J.t(v_tg_227):
				var _t356 = J.mc(this_, "period", [v_u_223])
				J.sp(v_u_223, "cd", _t356)
				v_s_229 = J.mc(this_, "scaleOf", [v_tg_227])
				var _t357 = J.gp(this_, "fx")
				var _t359 = J.gp(v_tg_227, "x")
				var _t360 = J.sub(J.mc(this_, "uy", [v_tg_227]), J.mul(30.0, v_s_229))
				var _t358 = signf(J.num(J.sub(J.gp(v_tg_227, "x"), J.gp(v_u_223, "x"))))
				J.mc(_t357, "push", [{"kind": "slash", "x": _t359, "y": _t360, "dir": (_t358 if J.t(_t358) else ((-1.0) if J.t(J.gp(v_u_223, "side")) else 1.0)), "t": 0.0, "life": 0.17, "r": ((18.0 if J.t(J.gp(v_u_223, "minion")) else 26.0) * (1.4 if J.t(J.gp(v_u_223, "boss")) else 1.0)), "col": ("#e8fbff" if J.seq(J.gp(v_u_223, "side"), 0.0) else "#ffd0c0")}])
				J.mc(this_, "hit", [v_u_223, v_tg_227, 1.0, null])
		if J.cmp(J.gp(v_a_225, "t"), J.gp(this_, "STRIKE"), ">="):
			var _t361 = {"name": "recover", "t": J.sub(J.gp(v_a_225, "t"), J.gp(this_, "STRIKE")), "dur": J.gp(this_, "REC")}
			J.sp(v_u_223, "anim", _t361)
		return null
	var _t362 = J.seq(J.gp(v_a_225, "name"), "recover")
	if (J.cmp(J.gp(v_a_225, "t"), J.gp(this_, "REC"), ">=") if _t362 else _t362):
		J.sp(v_u_223, "anim", null)

func _f71(this_, a: Array, env):
	var v_u_232 = null; var v_tg_233 = null; var v_s_234 = null; var v_y_235 = null; var v_dist_236 = null
	v_u_232 = J.arg(a, 0)
	v_tg_233 = J.arg(a, 1)
	var _t363 = (not J.t(v_tg_233))
	if (_t363 if _t363 else J.cmp(J.gp(v_tg_233, "hp"), 0.0, "<=")):
		var _t364 = J.mc(this_, "nearest", [v_u_232])
		v_tg_233 = _t364
		if (not J.t(v_tg_233)):
			return null
	v_s_234 = J.mc(this_, "scaleOf", [v_u_232])
	v_y_235 = J.sub(J.mc(this_, "uy", [v_u_232]), J.mul(34.0, v_s_234))
	v_dist_236 = J.max_([0.0, (absf(J.num(J.sub(J.gp(v_tg_233, "x"), J.gp(v_u_232, "x")))) - 10.0)])
	var _t365 = J.add(J.mc(this_, "period", [v_u_232]), J.div(v_dist_236, J.gp(this_, "PSPD")))
	J.sp(v_u_232, "cd", _t365)
	var _t366 = J.gp(this_, "proj")
	J.mc(_t366, "push", [{"src": v_u_232, "tg": v_tg_233, "x": J.add(J.gp(v_u_232, "x"), J.mul(((-14.0) if J.t(J.gp(v_u_232, "side")) else 14.0), v_s_234)), "y": v_y_235, "trail": [], "col": ("#9ff3ff" if J.seq(J.gp(v_u_232, "side"), 0.0) else "#ff9ac0"), "side": J.gp(v_u_232, "side")}])

func _f73(this_, a: Array, env):
	var v_p_240 = null; var v_tx_241 = null; var v_ty_242 = null; var v_dx_243 = null; var v_dy_244 = null; var v_d_245 = null; var v_step_246 = null
	v_p_240 = J.arg(a, 0)
	var _t369 = (not J.t(J.gp(v_p_240, "tg")))
	if (_t369 if _t369 else J.cmp(J.gp(J.gp(v_p_240, "tg"), "hp"), 0.0, "<=")):
		var _t370 = J.mc(env["this"], "nearest", [J.gp(v_p_240, "src")])
		J.sp(v_p_240, "tg", _t370)
		if (not J.t(J.gp(v_p_240, "tg"))):
			return false
	v_tx_241 = J.gp(J.gp(v_p_240, "tg"), "x")
	v_ty_242 = J.sub(J.mc(env["this"], "uy", [J.gp(v_p_240, "tg")]), J.mul(30.0, J.mc(env["this"], "scaleOf", [J.gp(v_p_240, "tg")])))
	v_dx_243 = J.sub(v_tx_241, J.gp(v_p_240, "x"))
	v_dy_244 = J.sub(v_ty_242, J.gp(v_p_240, "y"))
	v_d_245 = J.hypot_([v_dx_243, v_dy_244])
	v_step_246 = J.mul(J.gp(env["this"], "PSPD"), env["dt"])
	var _t371 = J.gp(v_p_240, "trail")
	J.mc(_t371, "push", [[J.gp(v_p_240, "x"), J.gp(v_p_240, "y")]])
	if (J.len(J.gp(v_p_240, "trail")) > 7.0):
		J.mc(J.gp(v_p_240, "trail"), "shift", [])
	if J.cmp(v_d_245, J.add(v_step_246, 4.0), "<="):
		J.mc(env["this"], "hit", [J.gp(v_p_240, "src"), J.gp(v_p_240, "tg"), 1.0, null])
		return false
	var _t372 = J.add(J.gp(v_p_240, "x"), J.mul(J.div(v_dx_243, v_d_245), v_step_246))
	J.sp(v_p_240, "x", _t372)
	var _t373 = J.add(J.gp(v_p_240, "y"), J.mul(J.div(v_dy_244, v_d_245), v_step_246))
	J.sp(v_p_240, "y", _t373)
	return true

func _f72(this_, a: Array, env):
	var _s124 = {"__p": env, "this": null, "dt": null}
	_s124["this"] = this_
	_s124["dt"] = J.arg(a, 0)
	var _t367 = _s124["this"]
	var _t368 = J.gp(_s124["this"], "proj")
	var _t374 = J.mc(_t368, "filter", [Callable(self, "_f73").bind(_s124)])
	J.sp(_t367, "proj", _t374)

func _f74(this_, a: Array, env):
	var v_x_249 = null; var v_y_250 = null; var v_k_251 = null; var v_col_252 = null; var v_n_253 = null; var v_rays_254 = null; var v_i_255 = null
	v_x_249 = J.arg(a, 0)
	v_y_250 = J.arg(a, 1)
	v_k_251 = J.arg(a, 2)
	v_col_252 = J.arg(a, 3)
	v_n_253 = (7.0 + floor(J.num((randf() * 4.0))))
	v_rays_254 = []
	v_i_255 = 0.0
	while true:
		if not J.cmp(v_i_255, v_n_253, "<"): break
		J.mc(v_rays_254, "push", [{"a": (((J.div(v_i_255, v_n_253) * PI) * 2.0) + ((randf() - 0.5) * 0.5)), "len": J.mul((14.0 + (randf() * 16.0)), v_k_251), "j": (randf() * 1000.0)}])
		v_i_255 = J.num(v_i_255) + 1.0
	var _t375 = J.gp(this_, "fx")
	J.mc(_t375, "push", [{"kind": "spark", "x": v_x_249, "y": v_y_250, "t": 0.0, "life": 0.24, "rays": v_rays_254, "col": v_col_252, "k": v_k_251, "rot": (randf() * PI)}])

func _f75(this_, a: Array, env):
	var v_x_258 = null; var v_y_259 = null; var v_k_260 = null; var v_puffs_261 = null; var v_i_262 = null
	v_x_258 = J.arg(a, 0)
	v_y_259 = J.arg(a, 1)
	v_k_260 = J.arg(a, 2)
	v_puffs_261 = []
	v_i_262 = 0.0
	while true:
		if not J.cmp(v_i_262, 5.0, "<"): break
		J.mc(v_puffs_261, "push", [{"dx": J.mul(((randf() - 0.5) * 18.0), v_k_260), "vx": J.mul(((randf() - 0.5) * 60.0), v_k_260), "r": J.mul((4.0 + (randf() * 4.0)), v_k_260)}])
		v_i_262 = J.num(v_i_262) + 1.0
	var _t376 = J.gp(this_, "fx")
	J.mc(_t376, "push", [{"kind": "dust", "x": v_x_258, "y": v_y_259, "t": 0.0, "life": 0.45, "puffs": v_puffs_261}])

func _f77(this_, a: Array, env):
	var v_f_271 = null
	v_f_271 = J.arg(a, 0)
	var _t391 = J.add(J.gp(v_f_271, "t"), env["dtReal"])
	J.sp(v_f_271, "t", _t391)
	return J.cmp(_t391, J.gp(v_f_271, "life"), "<")

func _f78(this_, a: Array, env):
	var v_u_280 = null
	v_u_280 = J.arg(a, 0)
	return J.cmp(J.gp(v_u_280, "hp"), 0.0, ">")

func _f79(this_, a: Array, env):
	var v_u_286 = null
	v_u_286 = J.arg(a, 0)
	return J.gp(v_u_286, "card")

func _f80(this_, a: Array, env):
	var v_u_287 = null
	v_u_287 = J.arg(a, 0)
	var _t443 = J.gp(v_u_287, "card")
	var _t444 = J.gp(J.mc(_t443, "querySelector", [".en s"]), "style")
	var _t445 = J.add(J.gp(v_u_287, "energy"), "%")
	J.sp(_t444, "height", _t445)
	var _t446 = J.gp(J.gp(v_u_287, "card"), "classList")
	var _t447 = J.cmp(J.gp(v_u_287, "energy"), 100.0, ">=")
	var _t448 = (J.cmp(J.gp(v_u_287, "hp"), 0.0, ">") if _t447 else _t447)
	J.mc(_t446, "toggle", ["ready", ((not J.t(J.gp(v_u_287, "casting"))) if _t448 else _t448)])
	var _t449 = J.gp(J.gp(v_u_287, "card"), "classList")
	J.mc(_t449, "toggle", ["dead", J.cmp(J.gp(v_u_287, "hp"), 0.0, "<=")])

func _f81(this_, a: Array, env):
	var v_u_289 = null
	v_u_289 = J.arg(a, 0)
	var _t460 = J.seq(J.gp(v_u_289, "side"), 0.0)
	var _t461 = ((not J.t(J.gp(v_u_289, "minion"))) if _t460 else _t460)
	return (J.cmp(J.gp(v_u_289, "hp"), 0.0, ">") if _t461 else _t461)

func _f82(this_, a: Array, env):
	var v_u_290 = null
	v_u_290 = J.arg(a, 0)
	var _t463 = J.seq(J.gp(v_u_290, "side"), 1.0)
	return (J.cmp(J.gp(v_u_290, "hp"), 0.0, ">") if _t463 else _t463)

func _f76(this_, a: Array, env):
	var v_ts_266 = null; var v_dt_267 = null; var v_alive_268 = null; var v_heroes_269 = null; var v_foes_270 = null; var v_u_272 = null; var v_u_273 = null; var v_tg_274 = null; var v_dx_275 = null; var v_dist_276 = null; var v_u_277 = null; var v_c_278 = null; var v_c_279 = null; var v_i_281 = null; var v_j_282 = null; var v_a_283 = null; var v_b_284 = null; var v_s_285 = null; var v_c_288 = null
	var _s132 = {"__p": env, "dtReal": null}
	_s132["dtReal"] = J.arg(a, 0)
	if (not J.t(J.gp(this_, "active"))):
		return null
	var _t377 = this_
	var _t378 = J.gp(this_, "shakeA")
	var _t379 = J.mul((_t378 if J.t(_t378) else 0.0), exp(J.num(((-J.num(_s132["dtReal"])) * 13.0))))
	J.sp(_t377, "shakeA", _t379)
	if J.cmp(J.gp(this_, "shakeA"), 0.15, "<"):
		var _t380 = this_
		J.sp(_t380, "shakeA", 0.0)
	var _t381 = this_
	var _t382 = J.gp(this_, "flashT")
	var _t383 = J.gp(this_, "flashT")
	var _t384 = J.max_([0.0, J.sub((_t383 if J.t(_t383) else 0.0), _s132["dtReal"])])
	J.sp(_t381, "flashT", _t384)
	var _t385 = this_
	var _t386 = J.gp(this_, "comboPop")
	var _t387 = J.gp(this_, "comboPop")
	var _t388 = J.max_([0.0, J.sub((_t387 if J.t(_t387) else 0.0), J.mul(_s132["dtReal"], 4.0))])
	J.sp(_t385, "comboPop", _t388)
	var _t389 = this_
	var _t390 = J.gp(this_, "fx")
	var _t392 = J.mc(_t390, "filter", [Callable(self, "_f77").bind(_s132)])
	J.sp(_t389, "fx", _t392)
	if J.cmp(J.gp(this_, "hitStop"), 0.0, ">"):
		var _t393 = this_
		var _t394 = J.sub(J.gp(_t393, "hitStop"), _s132["dtReal"])
		J.sp(_t393, "hitStop", _t394)
		return null
	v_ts_266 = 1.0
	if J.cmp(J.gp(this_, "slowT"), 0.0, ">"):
		var _t395 = this_
		var _t396 = J.sub(J.gp(_t395, "slowT"), _s132["dtReal"])
		J.sp(_t395, "slowT", _t396)
		v_ts_266 = 0.35
	v_dt_267 = J.mul(J.mul(_s132["dtReal"], J.gp(this_, "speed")), v_ts_266)
	if J.t(J.gp(this_, "result")):
		for _t397 in J.iter(J.gp(this_, "units")):
			v_u_272 = _t397
			J.mc(this_, "visTick", [v_u_272, v_dt_267])
		return null
	var _t398 = this_
	var _t399 = J.add(J.gp(_t398, "t"), v_dt_267)
	J.sp(_t398, "t", _t399)
	var _t400 = this_
	var _t401 = J.sub(J.gp(_t400, "comboT"), v_dt_267)
	J.sp(_t400, "comboT", _t401)
	var _t402 = this_
	var _t403 = J.gp(this_, "hsBank")
	var _t404 = J.gp(this_, "hsBank")
	var _t405 = J.min_([0.16, J.add((_t404 if J.t(_t404) else 0.0), J.mul(v_dt_267, 0.07))])
	J.sp(_t402, "hsBank", _t405)
	J.mc(this_, "stepProj", [v_dt_267])
	for _t406 in J.iter(J.gp(this_, "units")):
		v_u_273 = _t406
		J.mc(this_, "visTick", [v_u_273, v_dt_267])
		if J.cmp(J.gp(v_u_273, "hp"), 0.0, "<="):
			continue
		if J.cmp(J.gp(J.gp(v_u_273, "st"), "air"), 0.0, ">"):
			if J.t(J.gp(v_u_273, "casting")):
				J.mc(this_, "fireCast", [v_u_273])
			J.sp(v_u_273, "anim", null)
			var _t407 = J.gp(v_u_273, "st")
			var _t408 = J.sub(J.gp(_t407, "air"), v_dt_267)
			J.sp(_t407, "air", _t408)
			if J.cmp(J.gp(J.gp(v_u_273, "st"), "air"), 0.0, "<="):
				J.mc(this_, "dust", [J.gp(v_u_273, "x"), J.mc(this_, "uy", [v_u_273]), 1.1])
				J.mc(this_, "kick", [(5.0 if J.t(J.gp(v_u_273, "boss")) else 2.5)])
			continue
		if J.cmp(J.gp(J.gp(v_u_273, "st"), "down"), 0.0, ">"):
			if J.t(J.gp(v_u_273, "casting")):
				J.mc(this_, "fireCast", [v_u_273])
			J.sp(v_u_273, "anim", null)
			var _t409 = J.gp(v_u_273, "st")
			var _t410 = J.sub(J.gp(_t409, "down"), v_dt_267)
			J.sp(_t409, "down", _t410)
			continue
		if J.cmp(J.gp(J.gp(v_u_273, "st"), "push"), 0.0, ">"):
			J.sp(v_u_273, "anim", null)
			var _t411 = J.gp(v_u_273, "st")
			var _t412 = J.sub(J.gp(_t411, "push"), v_dt_267)
			J.sp(_t411, "push", _t412)
			var _t413 = J.add(J.gp(v_u_273, "x"), J.mul((((-1.0) if J.seq(J.gp(v_u_273, "side"), 0.0) else 1.0) * 160.0), v_dt_267))
			J.sp(v_u_273, "x", _t413)
			var _t414 = J.max_([16.0, J.min_([374.0, J.gp(v_u_273, "x")])])
			J.sp(v_u_273, "x", _t414)
			if (randf() < J.mul(v_dt_267, 30.0)):
				J.mc(this_, "dust", [J.gp(v_u_273, "x"), J.mc(this_, "uy", [v_u_273]), 0.5])
			continue
		if J.t(J.gp(v_u_273, "sk")):
			var _t415 = J.min_([100.0, J.add(J.gp(v_u_273, "energy"), J.mul((11.0 if J.t(J.gp(v_u_273, "boss")) else 9.0), v_dt_267))])
			J.sp(v_u_273, "energy", _t415)
		if J.t(J.gp(v_u_273, "casting")):
			var _t416 = J.sub(J.gp(v_u_273, "cd"), v_dt_267)
			J.sp(v_u_273, "cd", _t416)
			if J.t(J.mc(this_, "tickCast", [J.gp(v_u_273, "casting"), v_dt_267, v_u_273])):
				J.mc(this_, "fireCast", [v_u_273])
			continue
		var _t417 = J.gp(v_u_273, "sk")
		var _t418 = (J.cmp(J.gp(v_u_273, "energy"), 100.0, ">=") if J.t(_t417) else _t417)
		var _t421 = ((not J.t(J.gp(v_u_273, "anim"))) if J.t(_t418) else _t418)
		if J.t(_t421):
			var _t420 = J.seq(J.gp(v_u_273, "side"), 1.0)
			if not J.t(_t420):
				var _t419 = J.gp(this_, "auto")
				_t420 = ((not J.t(J.gp(v_u_273, "minion"))) if J.t(_t419) else _t419)
			_t421 = _t420
		if J.t(_t421):
			J.mc(this_, "beginCast", [v_u_273])
			continue
		if J.t(J.gp(v_u_273, "anim")):
			J.mc(this_, "stepAnim", [v_u_273, v_dt_267])
			continue
		v_tg_274 = J.mc(this_, "nearest", [v_u_273])
		if (not J.t(v_tg_274)):
			continue
		v_dx_275 = J.sub(J.gp(v_tg_274, "x"), J.gp(v_u_273, "x"))
		v_dist_276 = absf(J.num(v_dx_275))
		if J.cmp(v_dist_276, J.gp(v_u_273, "range"), ">"):
			var _t422 = J.add(J.gp(v_u_273, "x"), J.mul(J.mul(signf(J.num(v_dx_275)), J.gp(v_u_273, "spd")), v_dt_267))
			J.sp(v_u_273, "x", _t422)
			J.sp(v_u_273, "walking", true)
		else:
			J.sp(v_u_273, "walking", false)
			var _t423 = J.sub(J.gp(v_u_273, "cd"), v_dt_267)
			J.sp(v_u_273, "cd", _t423)
			if J.cmp(J.gp(v_u_273, "cd"), J.mc(this_, "leadOf", [v_u_273, v_tg_274]), "<="):
				var _t424 = {"name": "windup", "t": 0.0, "dur": J.gp(this_, "WIND"), "tg": v_tg_274}
				J.sp(v_u_273, "anim", _t424)
	if J.t(J.gp(this_, "adviser")):
		var _t425 = J.gp(this_, "adviser")
		var _t426 = J.min_([100.0, J.add(J.gp(J.gp(this_, "adviser"), "energy"), J.mul(7.0, v_dt_267))])
		J.sp(_t425, "energy", _t426)
		var _t427 = J.gp(this_, "auto")
		var _t428 = (J.cmp(J.gp(J.gp(this_, "adviser"), "energy"), 100.0, ">=") if J.t(_t427) else _t427)
		if J.t(((not J.t(J.gp(this_, "advCast"))) if J.t(_t428) else _t428)):
			J.mc(this_, "cast", [J.gp(this_, "adviser")])
	var _t429 = J.gp(this_, "advCast")
	if J.t((J.mc(this_, "tickCast", [J.gp(this_, "advCast"), v_dt_267]) if J.t(_t429) else _t429)):
		v_u_277 = J.gp(J.gp(this_, "advCast"), "u")
		var _t430 = this_
		J.sp(_t430, "advCast", null)
		J.mc(this_, "doSkill", [v_u_277, J.gp(v_u_277, "sk")])
	if J.t(J.gp(this_, "comboSkill")):
		v_c_278 = J.gp(this_, "comboSkill")
		var _t431 = J.cmp(J.gp(J.gp(v_c_278, "a"), "hp"), 0.0, ">")
		if (J.cmp(J.gp(J.gp(v_c_278, "b"), "hp"), 0.0, ">") if _t431 else _t431):
			var _t432 = J.min_([100.0, J.add(J.gp(v_c_278, "energy"), J.mul(5.0, v_dt_267))])
			J.sp(v_c_278, "energy", _t432)
		var _t433 = J.gp(this_, "auto")
		if J.t((J.cmp(J.gp(v_c_278, "energy"), 100.0, ">=") if J.t(_t433) else _t433)):
			J.mc(this_, "castCombo", [])
	var _t434 = J.gp(this_, "comboCast")
	if J.t((J.mc(this_, "tickCast", [J.gp(this_, "comboCast"), v_dt_267]) if J.t(_t434) else _t434)):
		v_c_279 = J.gp(this_, "comboSkill")
		var _t435 = J.cmp(J.gp(J.gp(v_c_279, "a"), "hp"), 0.0, ">")
		if (J.cmp(J.gp(J.gp(v_c_279, "b"), "hp"), 0.0, ">") if _t435 else _t435):
			J.mc(this_, "fireCombo", [])
		else:
			var _t436 = this_
			J.sp(_t436, "comboCast", null)
	var _t437 = J.gp(this_, "units")
	v_alive_268 = J.mc(_t437, "filter", [Callable(self, "_f78").bind(_s132)])
	v_i_281 = 0.0
	while true:
		if not J.cmp(v_i_281, J.len(v_alive_268), "<"): break
		v_j_282 = J.add(v_i_281, 1.0)
		while true:
			if not J.cmp(v_j_282, J.len(v_alive_268), "<"): break
			v_a_283 = J.gp(v_alive_268, v_i_281)
			v_b_284 = J.gp(v_alive_268, v_j_282)
			if (not J.seq(J.gp(v_a_283, "side"), J.gp(v_b_284, "side"))):
				v_j_282 = J.num(v_j_282) + 1.0
				continue
			var _t438 = (absf(J.num(J.sub(J.gp(v_a_283, "x"), J.gp(v_b_284, "x")))) < 22.0)
			if ((absf(J.num(J.sub(J.gp(v_a_283, "lane"), J.gp(v_b_284, "lane")))) < 0.6) if _t438 else _t438):
				v_s_285 = ((-1.0) if J.cmp(J.gp(v_a_283, "x"), J.gp(v_b_284, "x"), "<") else 1.0)
				var _t439 = J.add(J.gp(v_a_283, "x"), J.mul(J.mul(v_s_285, 10.0), v_dt_267))
				J.sp(v_a_283, "x", _t439)
				var _t440 = J.sub(J.gp(v_b_284, "x"), J.mul(J.mul(v_s_285, 10.0), v_dt_267))
				J.sp(v_b_284, "x", _t440)
			v_j_282 = J.num(v_j_282) + 1.0
		v_i_281 = J.num(v_i_281) + 1.0
	var _t441 = J.gp(this_, "units")
	var _t442 = J.mc(_t441, "filter", [Callable(self, "_f79").bind(_s132)])
	J.mc(_t442, "forEach", [Callable(self, "_f80").bind(_s132)])
	if J.t(J.gp(this_, "adviser")):
		var _t450 = J.gp(J.gp(this_, "adviser"), "card")
		var _t451 = J.gp(J.mc(_t450, "querySelector", [".en s"]), "style")
		var _t452 = J.add(J.gp(J.gp(this_, "adviser"), "energy"), "%")
		J.sp(_t451, "height", _t452)
		var _t453 = J.gp(J.gp(J.gp(this_, "adviser"), "card"), "classList")
		var _t454 = J.cmp(J.gp(J.gp(this_, "adviser"), "energy"), 100.0, ">=")
		J.mc(_t453, "toggle", ["ready", ((not J.t(J.gp(this_, "advCast"))) if _t454 else _t454)])
	if J.t(J.gp(this_, "comboSkill")):
		v_c_288 = J.gp(this_, "comboSkill")
		var _t455 = J.gp(v_c_288, "card")
		var _t456 = J.gp(J.mc(_t455, "querySelector", [".en s"]), "style")
		var _t457 = J.add(J.gp(v_c_288, "energy"), "%")
		J.sp(_t456, "height", _t457)
		var _t458 = J.gp(J.gp(v_c_288, "card"), "classList")
		J.mc(_t458, "toggle", ["ready", J.cmp(J.gp(v_c_288, "energy"), 100.0, ">=")])
	var _t459 = J.gp(this_, "units")
	v_heroes_269 = J.len(J.mc(_t459, "filter", [Callable(self, "_f81").bind(_s132)]))
	var _t462 = J.gp(this_, "units")
	v_foes_270 = J.len(J.mc(_t462, "filter", [Callable(self, "_f82").bind(_s132)]))
	var _t464 = J.G.get("$")
	var _t465 = J.cl(_t464, null, ["#b-time"])
	var _t466 = J.add(J.max_([0.0, ceil(J.num(J.sub(J.gp(this_, "timeLimit"), J.gp(this_, "t"))))]), "s")
	J.sp(_t465, "textContent", _t466)
	if (not J.t(v_foes_270)):
		J.mc(this_, "finish", [true])
	else:
		if (not J.t(v_heroes_269)):
			J.mc(this_, "finish", [false])
		else:
			if J.cmp(J.gp(this_, "t"), J.gp(this_, "timeLimit"), ">="):
				J.mc(this_, "finish", [false, false, true])

func _f83(this_, a: Array, env):
	var v_u_293 = null; var v_dt_294 = null
	v_u_293 = J.arg(a, 0)
	v_dt_294 = J.arg(a, 1)
	if J.cmp(J.gp(v_u_293, "hp"), 0.0, "<="):
		var _t467 = J.gp(v_u_293, "deadT")
		var _t468 = J.add((_t467 if J.t(_t467) else 0.0), v_dt_294)
		J.sp(v_u_293, "deadT", _t468)
	var _t469 = J.gp(v_u_293, "flash")
	var _t470 = J.gp(v_u_293, "flash")
	var _t471 = J.max_([0.0, J.sub((_t470 if J.t(_t470) else 0.0), J.div(v_dt_294, 0.18))])
	J.sp(v_u_293, "flash", _t471)
	var _t472 = J.gp(v_u_293, "hurtT")
	var _t473 = J.gp(v_u_293, "hurtT")
	var _t474 = J.max_([0.0, J.sub((_t473 if J.t(_t473) else 0.0), v_dt_294)])
	J.sp(v_u_293, "hurtT", _t474)
	if (not J.leq(J.gp(v_u_293, "kbT"), null)):
		var _t475 = J.add(J.gp(v_u_293, "kbT"), v_dt_294)
		J.sp(v_u_293, "kbT", _t475)
		if J.cmp(J.gp(v_u_293, "kbT"), 0.3, ">"):
			J.sp(v_u_293, "kbT", null)

func _f85(this_, a: Array, env):
	var v_u_307 = null
	v_u_307 = J.arg(a, 0)
	var _t479 = J.gp(v_u_307, "minion")
	return (J.cmp(J.gp(v_u_307, "hp"), 0.0, "<=") if J.t(_t479) else _t479)

func _f86(this_, a: Array, env):
	var v_ok_308 = null
	var _t505 = J.G.get("$")
	v_ok_308 = J.cl(_t505, null, ["#b-ok"])
	if J.t(v_ok_308):
		J.mc(v_ok_308, "onclick", [])

func _f88(this_, a: Array, env):
	var _t513 = J.G.get("joinGhost")
	J.cl(_t513, null, ["baiwu"])
	var _t514 = J.G.get("joinGhost")
	J.cl(_t514, null, ["heiwu"])

func _f89(this_, a: Array, env):
	var _t515 = J.G.get("joinGhost")
	return J.cl(_t515, null, ["mengpo"])

func _f90(this_, a: Array, env):
	var _t516 = J.G.get("S")
	J.sp(_t516, "ended", true)

func _f92(this_, a: Array, env):
	if J.seq(env["i"], 0.0):
		var _t517 = J.gp(env["__p"]["st"], "join")
		var _t518 = (_t517 if J.t(_t517) else [])
		J.mc(_t518, "forEach", [J.G.get("joinGhost")])
	if J.t(J.gp(J.G.get("GIFT_REWARD"), env["id"])):
		var _t519 = J.G.get("give")
		J.mc(J.G.get("Fx"), "toast", [J.add("媽媽燒來的禮物：", J.cl(_t519, null, [J.gp(J.G.get("GIFT_REWARD"), env["id"])]))])

func _f91(this_, a: Array, env):
	var _s178 = {"__p": env, "id": null, "i": null}
	_s178["id"] = J.arg(a, 0)
	_s178["i"] = J.arg(a, 1)
	return J.mc(J.G.get("Story"), "queue", [_s178["id"], Callable(self, "_f92").bind(_s178)])

func _f87(this_, a: Array, env):
	var v_afters_309 = null
	var _t508 = J.gp(env["box"], "classList")
	J.mc(_t508, "remove", ["on"])
	var _t509 = env["this"]
	J.sp(_t509, "active", false)
	var _t510 = J.G.get("$")
	var _t511 = J.gp(J.cl(_t510, null, ["#battle"]), "classList")
	J.mc(_t511, "remove", ["on"])
	if J.t((J.gp(env["st"], "wild") if J.t(env["first"]) else env["first"])):
		if (not J.seq(J.typeof_(J.G.get("N30W")), "undefined")):
			J.mc(J.G.get("N30W"), "onWin", [env["st"]])
	else:
		if J.t(env["first"]):
			var _t512 = J.gp(env["st"], "after")
			v_afters_309 = J.mc((_t512 if J.t(_t512) else []), "slice", [])
			if J.seq(env["sid"], "6-2"):
				J.mc(J.G.get("Story"), "queue", ["ch6_wuchang", Callable(self, "_f88").bind(env)])
				J.mc(J.G.get("Story"), "queue", ["ch6_mengpo", Callable(self, "_f89").bind(env)])
			else:
				if J.seq(env["sid"], "6-3"):
					J.mc(J.G.get("Story"), "queue", ["ch6_end"])
					J.mc(J.G.get("Story"), "queue", ["ch6_reboot", Callable(self, "_f90").bind(env)])
					J.mc(J.G.get("Story"), "queue", ["epilogue"])
				else:
					J.mc(v_afters_309, "forEach", [Callable(self, "_f91").bind(env)])
	if (not J.t(J.mc(J.G.get("Story"), "busy", []))):
		J.mc(J.G.get("Sound"), "setMode", ["village"])
	J.mc(J.G.get("Quest"), "check", [])
	J.cl(J.G.get("save"), null, [])
	J.mc(J.G.get("UI"), "refresh", [])

func _f84(this_, a: Array, env):
	var v_win_297 = null; var v_quit_298 = null; var v_timeout_299 = null; var v_lost_300 = null; var v_rew_304 = null; var v_txt_305 = null
	var _s166 = {"__p": env, "this": null, "st": null, "sid": null, "first": null, "box": null}
	_s166["this"] = this_
	v_win_297 = J.arg(a, 0)
	v_quit_298 = J.arg(a, 1)
	v_timeout_299 = J.arg(a, 2)
	var _t476 = _s166["this"]
	var _t477 = {"win": v_win_297}
	J.sp(_t476, "result", _t477)
	J.mc(J.G.get("Sound"), "play", [("win" if J.t(v_win_297) else "lose")])
	var _t480 = J.gp(J.gp(J.G.get("S"), "res"), "troops")
	var _t478 = J.gp(_s166["this"], "units")
	var _t482 = J.gp(J.gp(J.G.get("S"), "res"), "troops")
	var _t481 = J.gp(_s166["this"], "units")
	v_lost_300 = J.min_([_t482, (J.len(J.mc(_t481, "filter", [Callable(self, "_f85").bind(_s166)])) * 25.0)])
	var _t483 = J.gp(J.G.get("S"), "res")
	var _t484 = J.max_([0.0, J.sub(J.gp(J.gp(J.G.get("S"), "res"), "troops"), v_lost_300)])
	J.sp(_t483, "troops", _t484)
	_s166["st"] = J.gp(_s166["this"], "stage")
	_s166["sid"] = J.gp(_s166["this"], "sid")
	_s166["first"] = ((not J.t(J.gp(J.gp(J.G.get("S"), "cleared"), _s166["sid"]))) if J.t(v_win_297) else v_win_297)
	v_rew_304 = {}
	v_txt_305 = ""
	if J.t(v_win_297):
		var _t485 = ({"coins": (J.mul(60.0, J.gp(_s166["st"], "p")) + 40.0), "exp": (J.mul(30.0, J.gp(_s166["st"], "p")) + 40.0), "chest": J.gp(["g", "b", "p"], J.gp(_s166["this"], "si"))} if J.t(_s166["first"]) else {"coins": J.mul(20.0, J.gp(_s166["st"], "p")), "exp": J.mul(8.0, J.gp(_s166["st"], "p"))})
		v_rew_304 = _t485
		if J.t(J.gp(_s166["this"], "coinsWon")):
			var _t486 = J.add(J.gp(v_rew_304, "coins"), J.gp(_s166["this"], "coinsWon"))
			J.sp(v_rew_304, "coins", _t486)
		var _t487 = J.gp(J.G.get("S"), "cleared")
		var _t488 = _s166["sid"]
		J.sp(_t487, _t488, true)
		var _t489 = J.G.get("give")
		var _t490 = J.cl(_t489, null, [v_rew_304])
		v_txt_305 = _t490
	var _t491 = J.G.get("$")
	_s166["box"] = J.cl(_t491, null, ["#b-result"])
	var _t492 = _s166["box"]
	var _t496 = ("win" if J.t(v_win_297) else "lose")
	var _t497 = (("首次通關！" if J.t(_s166["first"]) else "勝利") if J.t(v_win_297) else ("撤退" if J.t(v_quit_298) else ("時間到" if J.t(v_timeout_299) else "戰敗")))
	var _t498 = (("<p class=\"quip\">" + J.str(J.gp(J.G.get("WIN_QUIPS"), floor(J.num((randf() * J.len(J.G.get("WIN_QUIPS"))))))) + "</p><p>" + J.str(v_txt_305) + "</p>") if J.t(v_win_297) else (("" if J.t(v_quit_298) else ("<p class=\"quip\">" + J.str(J.gp(J.G.get("LOSE_QUIPS"), floor(J.num((randf() * J.len(J.G.get("LOSE_QUIPS"))))))) + "</p>")) + "<p>" + ("" if J.t(v_quit_298) else "提示：換上嚇法對得上的陣容（看敵人怕什麼）；先嚇到敵人失神，再接另一種他怕的，打出連嚇。") + "</p>"))
	var _t499 = (("<p class=\"lost\">陰兵戰死 " + J.str(floor(J.num(v_lost_300))) + "</p>") if J.t(v_lost_300) else "")
	var _t493 = (not J.t(v_win_297))
	var _t495 = null
	if ((not J.t(v_quit_298)) if _t493 else _t493):
		var _t494 = J.gp(J.G.get("S"), "team")
		_t495 = J.mc(J.G.get("GP"), "failHTML", [J.mc(J.G.get("GP"), "avg", [J.mc(_t494, "map", [J.G.get("ghostById")])]), J.mc(J.G.get("GP"), "stageNeed", [_s166["st"], _s166["sid"]])])
	else:
		_t495 = ""
	var _t500 = (not J.t(v_win_297))
	var _t502 = ("" if ((not J.t(v_quit_298)) if _t500 else _t500) else "gold ")
	var _t501 = (_s166["first"] if J.t(v_win_297) else v_win_297)
	var _t503 = ("<div class=\"br " + _t496 + "\"><h2>" + _t497 + "</h2>\n      " + _t498 + "\n      " + _t499 + "\n      " + J.str(_t495) + "\n      <button class=\"btn " + _t502 + "wide\" id=\"b-ok\">" + ("繼續" if J.t((J.gp(_s166["st"], "after") if J.t(_t501) else _t501)) else "回村子") + "</button></div>")
	J.sp(_t492, "innerHTML", _t503)
	var _t504 = J.gp(_s166["box"], "classList")
	J.mc(_t504, "add", ["on"])
	J.mc(J.G.get("GP"), "bindBack", [_s166["box"], Callable(self, "_f86").bind(_s166)])
	var _t506 = J.G.get("$")
	var _t507 = J.cl(_t506, null, ["#b-ok"])
	var _t520 = Callable(self, "_f87").bind(_s166)
	J.sp(_t507, "onclick", _t520)
	J.cl(J.G.get("save"), null, [])

func _f94(this_, a: Array, env):
	var v_p_324 = null
	v_p_324 = J.arg(a, 0)
	return (1.0 - pow(J.num((1.0 - J.min_([1.0, J.max_([0.0, v_p_324])]))), J.num(3.0)))

func _f95(this_, a: Array, env):
	var v_p_325 = null
	v_p_325 = J.arg(a, 0)
	var _t521 = J.min_([1.0, J.max_([0.0, v_p_325])])
	v_p_325 = _t521
	return (J.mul(J.mul(J.mul(4.0, v_p_325), v_p_325), v_p_325) if J.cmp(v_p_325, 0.5, "<") else (1.0 - J.div(pow(J.num((J.mul((-2.0), v_p_325) + 2.0)), J.num(3.0)), 2.0)))

func _f93(this_, a: Array, env):
	var v_u_314 = null; var v_fw_315 = null; var v_eo_316 = null; var v_io_317 = null; var v_pose_318 = null; var v_pt_319 = null; var v_ox_320 = null; var v_oy_321 = null; var v_rot_322 = null; var v_alpha_323 = null; var v_p_326 = null; var v_d_327 = null; var v_p_328 = null; var v_D_329 = null; var v_el_330 = null; var v_a_331 = null; var v_p_332 = null; var v_L_333 = null; var v_ranged_334 = null; var v_p_335 = null; var v_k_336 = null; var v_ph_337 = null; var v_tt_338 = null; var v_tq_339 = null; var v_k_340 = null
	v_u_314 = J.arg(a, 0)
	v_fw_315 = ((-1.0) if J.t(J.gp(v_u_314, "side")) else 1.0)
	v_eo_316 = Callable(self, "_f94").bind(env)
	v_io_317 = Callable(self, "_f95").bind(env)
	v_pose_318 = ("move" if J.t(J.gp(v_u_314, "walking")) else "idle")
	v_pt_319 = 0.0
	v_ox_320 = 0.0
	v_oy_321 = 0.0
	v_rot_322 = 0.0
	v_alpha_323 = 1.0
	if J.cmp(J.gp(v_u_314, "hp"), 0.0, "<="):
		v_p_326 = J.min_([1.0, J.div(J.gp(v_u_314, "deadT"), 0.8)])
		var _t522 = J.gp(v_u_314, "dieDir")
		v_d_327 = (_t522 if J.t(_t522) else (-J.num(v_fw_315)))
		v_pose_318 = "die"
		v_pt_319 = v_p_326
		var _t523 = J.mul(J.mul(v_d_327, 24.0), J.cl(v_eo_316, null, [v_p_326]))
		v_ox_320 = _t523
		var _t524 = ((-sin(J.num((J.min_([1.0, J.mul(v_p_326, 1.4)]) * PI)))) * 12.0)
		v_oy_321 = _t524
		var _t525 = (1.0 if J.cmp(v_p_326, 0.45, "<") else J.max_([0.0, (1.0 - J.div(J.sub(v_p_326, 0.45), 0.55))]))
		v_alpha_323 = _t525
	else:
		if J.cmp(J.gp(J.gp(v_u_314, "st"), "air"), 0.0, ">"):
			var _t527 = J.gp(J.gp(v_u_314, "st"), "air")
			var _t526 = J.gp(J.gp(v_u_314, "st"), "airMax")
			v_p_328 = (1.0 - J.div(_t527, (_t526 if J.t(_t526) else 1.0)))
			v_pose_318 = "air"
			v_pt_319 = v_p_328
			var _t528 = (((-J.num(v_fw_315)) * 12.0) * sin(J.num(J.mul(v_p_328, PI))))
			v_ox_320 = _t528
		else:
			if J.cmp(J.gp(J.gp(v_u_314, "st"), "down"), 0.0, ">"):
				var _t529 = J.gp(J.gp(v_u_314, "st"), "downMax")
				v_D_329 = (_t529 if J.t(_t529) else 1.4)
				v_el_330 = J.sub(v_D_329, J.gp(J.gp(v_u_314, "st"), "down"))
				v_pose_318 = "down"
				var _t530 = J.div(v_el_330, v_D_329)
				v_pt_319 = _t530
				if J.cmp(v_el_330, 0.25, "<"):
					var _t531 = ((-absf(J.num(sin(J.num((J.div(v_el_330, 0.25) * PI)))))) * 7.0)
					v_oy_321 = _t531
			else:
				if J.cmp(J.gp(J.gp(v_u_314, "st"), "push"), 0.0, ">"):
					v_pose_318 = "hurt"
					var _t532 = (1.0 - J.div(J.gp(J.gp(v_u_314, "st"), "push"), 0.25))
					v_pt_319 = _t532
				else:
					if J.t(J.gp(v_u_314, "casting")):
						v_pose_318 = "cast"
						var _t533 = J.min_([1.0, J.div(J.gp(J.gp(v_u_314, "casting"), "t"), J.gp(J.gp(v_u_314, "casting"), "dur"))])
						v_pt_319 = _t533
					else:
						if J.t(J.gp(v_u_314, "anim")):
							v_a_331 = J.gp(v_u_314, "anim")
							v_p_332 = J.div(J.gp(v_a_331, "t"), J.gp(v_a_331, "dur"))
							v_L_333 = J.mc(this_, "lungeOf", [v_u_314])
							v_ranged_334 = J.cmp(J.gp(v_u_314, "range"), 60.0, ">")
							v_pose_318 = J.gp(v_a_331, "name")
							var _t534 = J.min_([1.0, v_p_332])
							v_pt_319 = _t534
							if J.seq(J.gp(v_a_331, "name"), "windup"):
								var _t535 = J.mul(((-J.num(v_fw_315)) * (1.0 if J.t(v_ranged_334) else 2.0)), J.cl(v_eo_316, null, [v_p_332]))
								v_ox_320 = _t535
							else:
								if J.seq(J.gp(v_a_331, "name"), "strike"):
									var _t536 = (J.mul(((-J.num(v_fw_315)) * 5.0), J.cl(v_eo_316, null, [J.mul(v_p_332, 2.0)])) if J.t(v_ranged_334) else J.mul(J.mul(v_fw_315, v_L_333), J.cl(v_eo_316, null, [J.mul(v_p_332, 2.4)])))
									v_ox_320 = _t536
								else:
									var _t537 = ((((-J.num(v_fw_315)) * 5.0) * J.sub(1.0, J.cl(v_io_317, null, [v_p_332]))) if J.t(v_ranged_334) else (J.mul(v_fw_315, v_L_333) * J.sub(1.0, J.cl(v_io_317, null, [v_p_332]))))
									v_ox_320 = _t537
						else:
							if J.cmp(J.gp(v_u_314, "hurtT"), 0.0, ">"):
								v_pose_318 = "hurt"
								var _t538 = (1.0 - J.div(J.gp(v_u_314, "hurtT"), 0.25))
								v_pt_319 = _t538
	var _t539 = (not J.leq(J.gp(v_u_314, "kbT"), null))
	if (J.cmp(J.gp(v_u_314, "hp"), 0.0, ">") if _t539 else _t539):
		v_p_335 = J.div(J.gp(v_u_314, "kbT"), 0.3)
		v_k_336 = (J.cl(v_eo_316, null, [J.div(v_p_335, 0.25)]) if J.cmp(v_p_335, 0.25, "<") else J.sub(1.0, J.cl(v_io_317, null, [J.div(J.sub(v_p_335, 0.25), 0.75)])))
		var _t540 = J.gp(v_u_314, "kbDir")
		var _t542 = (_t540 if J.t(_t540) else (-J.num(v_fw_315)))
		var _t541 = J.gp(v_u_314, "kbAmp")
		var _t543 = J.add(v_ox_320, J.mul(J.mul(_t542, (_t541 if J.t(_t541) else 6.0)), v_k_336))
		v_ox_320 = _t543
	var _t544 = J.seq(v_pose_318, "idle")
	if (J.cmp(J.gp(v_u_314, "hp"), 0.0, ">") if _t544 else _t544):
		var _t545 = J.gp(v_u_314, "lane")
		v_ph_337 = (J.mul((_t545 if J.t(_t545) else 0.0), 1.7) + (0.9 if J.t(J.gp(v_u_314, "side")) else 0.0))
		v_tt_338 = J.add(J.gp(this_, "t"), v_ph_337)
		var _t546 = J.add(v_oy_321, ((-absf(J.num(sin(J.num(J.mul(v_tt_338, 4.2)))))) * 2.2))
		v_oy_321 = _t546
		v_tq_339 = J.div(J.mod(v_tt_338, 4.6), 4.6)
		var _t547 = (not J.t(J.gp(v_u_314, "minion")))
		if (J.cmp(v_tq_339, 0.82, ">") if _t547 else _t547):
			v_k_340 = sin(J.num((J.div(J.sub(v_tq_339, 0.82), 0.18) * PI)))
			var _t548 = J.add(v_ox_320, J.mul(J.mul(v_fw_315, 4.0), v_k_340))
			v_ox_320 = _t548
			var _t549 = J.add(v_rot_322, J.mul(((-J.num(v_fw_315)) * 0.05), v_k_340))
			v_rot_322 = _t549
	return {"pose": v_pose_318, "pt": v_pt_319, "ox": v_ox_320, "oy": v_oy_321, "rot": v_rot_322, "alpha": v_alpha_323}

func _f97(this_, a: Array, env):
	var v_a_353 = null; var v_b_354 = null
	v_a_353 = J.arg(a, 0)
	v_b_354 = J.arg(a, 1)
	return J.sub(J.gp(v_a_353, "lane"), J.gp(v_b_354, "lane"))

func _f98(this_, a: Array, env):
	var v_u_370 = null
	v_u_370 = J.arg(a, 0)
	var _t589 = J.cmp(J.gp(v_u_370, "hp"), 0.0, ">")
	return (J.mc(env["__p"]["this"], "drawCharge", [env["__p"]["ctx"], J.gp(v_u_370, "x"), J.sub(J.mc(env["__p"]["this"], "uy", [v_u_370]), J.mul(28.0, J.mc(env["__p"]["this"], "scaleOf", [v_u_370]))), J.mc(env["__p"]["this"], "scaleOf", [v_u_370]), env["p"], "#ffb0ff", true]) if _t589 else _t589)

func _f96(this_, a: Array, env):
	var v_k_344 = null; var v_A_345 = null; var v_shx_346 = null; var v_shy_347 = null; var v_H_348 = null; var v_list_349 = null; var v_gy_350 = null; var v_gg_351 = null; var v_f_352 = null; var v_u_355 = null; var v_P_356 = null; var v_s_357 = null; var v_x_358 = null; var v_y0_359 = null; var v_y_360 = null; var v_tg_361 = null; var v_o_362 = null; var v_bx_363 = null; var v_bw_364 = null; var v_by_365 = null; var v_ty_366 = null; var v_tx_367 = null; var v_c_368 = null; var v_p_371 = null; var v_f_372 = null; var v_p_373 = null; var v_z_374 = null
	var _s193 = {"__p": env, "this": null, "ctx": null}
	_s193["this"] = this_
	if (not J.t(J.gp(_s193["this"], "active"))):
		return null
	var _t550 = J.gp(_s193["this"], "_nat")
	if J.t(((not J.t(J.gp(_s193["this"], "_natCtx"))) if J.t(_t550) else _t550)):
		return null
	var _t551 = J.gp(_s193["this"], "_natCtx")
	_s193["ctx"] = (_t551 if J.t(_t551) else J.gp(_s193["this"], "ctx"))
	v_k_344 = J.mul(J.gp(_s193["this"], "sc"), J.gp(_s193["this"], "dpr"))
	var _t552 = J.gp(_s193["this"], "shakeA")
	v_A_345 = (_t552 if J.t(_t552) else 0.0)
	v_shx_346 = (J.mul(((randf() - 0.5) * 2.0), v_A_345) if J.t(v_A_345) else 0.0)
	v_shy_347 = (J.mul(((randf() - 0.5) * 1.2), v_A_345) if J.t(v_A_345) else 0.0)
	J.mc(_s193["ctx"], "setTransform", [v_k_344, 0.0, 0.0, v_k_344, J.mul(v_shx_346, v_k_344), J.mul(v_shy_347, v_k_344)])
	var _t553 = _s193["this"]
	var _t554 = J.div(J.gp(_s193["this"], "h"), J.gp(_s193["this"], "sc"))
	J.sp(_t553, "H", _t554)
	v_H_348 = _t554
	if (not J.t(J.mc(J.G.get("SCENE"), "drawBg", [_s193["ctx"], 390.0, v_H_348, J.gp(_s193["this"], "bg")]))):
		var _t555 = J.G.get("paintBg")
		J.cl(_t555, null, [_s193["ctx"], 390.0, J.mul(v_H_348, 0.545), J.gp(_s193["this"], "bg"), J.gp(_s193["this"], "t")])
		v_gy_350 = J.mul(v_H_348, 0.36)
		v_gg_351 = J.mc(_s193["ctx"], "createLinearGradient", [0.0, v_gy_350, 0.0, v_H_348])
		J.mc(v_gg_351, "addColorStop", [0.0, "#2a2622"])
		J.mc(v_gg_351, "addColorStop", [0.5, "#1c1a1a"])
		J.mc(v_gg_351, "addColorStop", [1.0, "#121012"])
		var _t556 = _s193["ctx"]
		J.sp(_t556, "fillStyle", v_gg_351)
		J.mc(_s193["ctx"], "fillRect", [0.0, v_gy_350, 390.0, J.sub(v_H_348, v_gy_350)])
	if J.cmp(J.gp(_s193["this"], "slowT"), 0.0, ">"):
		var _t557 = _s193["ctx"]
		var _t558 = ("rgba(8,4,20," + J.str(J.min_([0.35, J.mul(J.gp(_s193["this"], "slowT"), 2.4)])) + ")")
		J.sp(_t557, "fillStyle", _t558)
		J.mc(_s193["ctx"], "fillRect", [(-20.0), (-20.0), 430.0, J.add(v_H_348, 40.0)])
	for _t559 in J.iter(J.gp(_s193["this"], "fx")):
		v_f_352 = _t559
		if J.seq(J.gp(v_f_352, "kind"), "dust"):
			J.mc(_s193["this"], "drawDust", [_s193["ctx"], v_f_352])
	var _t560 = J.mc(J.gp(_s193["this"], "units"), "slice", [])
	v_list_349 = J.mc(_t560, "sort", [Callable(self, "_f97").bind(_s193)])
	for _t561 in J.iter(v_list_349):
		v_u_355 = _t561
		var _t562 = J.cmp(J.gp(v_u_355, "hp"), 0.0, "<=")
		if (J.cmp(J.gp(v_u_355, "deadT"), 0.8, ">") if _t562 else _t562):
			continue
		v_P_356 = J.mc(_s193["this"], "poseOf", [v_u_355])
		v_s_357 = J.mc(_s193["this"], "scaleOf", [v_u_355])
		v_x_358 = J.add(J.gp(v_u_355, "x"), J.gp(v_P_356, "ox"))
		v_y0_359 = J.mc(_s193["this"], "uy", [v_u_355])
		v_y_360 = J.add(v_y0_359, J.gp(v_P_356, "oy"))
		if J.t(J.gp(v_u_355, "casting")):
			J.mc(_s193["this"], "drawCharge", [_s193["ctx"], v_x_358, J.sub(v_y0_359, J.mul(28.0, v_s_357)), v_s_357, J.div(J.gp(J.gp(v_u_355, "casting"), "t"), J.gp(J.gp(v_u_355, "casting"), "dur")), ("#9ff3ff" if J.seq(J.gp(v_u_355, "side"), 0.0) else "#ff9ac0"), false])
		var _t563 = J.gp(v_u_355, "anim")
		var _t564 = (J.gp(J.gp(v_u_355, "anim"), "tg") if J.t(_t563) else _t563)
		v_tg_361 = (J.gp(J.gp(v_u_355, "anim"), "tg") if J.t((J.cmp(J.gp(J.gp(J.gp(v_u_355, "anim"), "tg"), "hp"), 0.0, ">") if J.t(_t564) else _t564)) else null)
		v_o_362 = {"tdx": (J.sub(J.gp(v_tg_361, "x"), J.gp(v_u_355, "x")) if J.t(v_tg_361) else ((-40.0) if J.t(J.gp(v_u_355, "side")) else 40.0)), "tdy": (J.sub(J.mc(_s193["this"], "uy", [v_tg_361]), J.mc(_s193["this"], "uy", [v_u_355])) if J.t(v_tg_361) else 0.0), "t": J.add(J.gp(_s193["this"], "t"), J.gp(v_u_355, "lane")), "walk": J.seq(J.gp(v_P_356, "pose"), "move"), "pose": J.gp(v_P_356, "pose"), "pt": J.gp(v_P_356, "pt"), "flip": J.seq(J.gp(v_u_355, "side"), 1.0), "enemy": J.seq(J.gp(v_u_355, "side"), 1.0), "alpha": J.gp(v_P_356, "alpha"), "rot": J.gp(v_P_356, "rot"), "tamed": J.seq(J.gp(v_u_355, "side"), 0.0), "untied": J.seq(J.gp(v_u_355, "side"), 0.0)}
		var _t565 = J.G.get("__btDC")
		J.cl(_t565, null, [_s193["ctx"], J.gp(v_u_355, "k"), v_x_358, v_y_360, v_s_357, v_o_362])
		if J.cmp(J.gp(v_u_355, "flash"), 0.0, ">"):
			J.mc(_s193["ctx"], "save", [])
			var _t566 = _s193["ctx"]
			J.sp(_t566, "globalCompositeOperation", "lighter")
			var _t567 = J.G.get("__btDC")
			J.cl(_t567, null, [_s193["ctx"], J.gp(v_u_355, "k"), v_x_358, v_y_360, v_s_357, J.S_Object_("assign", [{}, v_o_362, {"alpha": (J.mul(J.gp(v_P_356, "alpha"), J.gp(v_u_355, "flash")) * 0.85), "shadow": false}])])
			J.mc(_s193["ctx"], "restore", [])
		if J.t(J.gp(v_u_355, "casting")):
			J.mc(_s193["this"], "drawCharge", [_s193["ctx"], v_x_358, J.sub(v_y0_359, J.mul(28.0, v_s_357)), v_s_357, J.div(J.gp(J.gp(v_u_355, "casting"), "t"), J.gp(J.gp(v_u_355, "casting"), "dur")), ("#9ff3ff" if J.seq(J.gp(v_u_355, "side"), 0.0) else "#ff9ac0"), true])
		if J.cmp(J.gp(v_u_355, "hp"), 0.0, ">"):
			v_bx_363 = J.add(J.gp(v_u_355, "x"), J.mul(J.gp(v_P_356, "ox"), 0.4))
			v_bw_364 = (26.0 if J.t(J.gp(v_u_355, "minion")) else (64.0 if J.t(J.gp(v_u_355, "boss")) else 46.0))
			v_by_365 = J.sub(v_y0_359, (36.0 if J.t(J.gp(v_u_355, "minion")) else (92.0 if J.t(J.gp(v_u_355, "boss")) else 72.0)))
			J.mc(J.G.get("ART"), "rr", [_s193["ctx"], J.sub(v_bx_363, J.div(v_bw_364, 2.0)), v_by_365, v_bw_364, 5.0, 2.0, "rgba(0,0,0,.6)"])
			J.mc(J.G.get("ART"), "rr", [_s193["ctx"], J.sub(v_bx_363, J.div(v_bw_364, 2.0)), v_by_365, J.div(J.mul(v_bw_364, J.gp(v_u_355, "hp")), J.gp(v_u_355, "maxhp")), 5.0, 2.0, ("#e84a5f" if J.t(J.gp(v_u_355, "side")) else "#4ade80")])
			var _t568 = J.gp(v_u_355, "sk")
			if J.t(((not J.t(J.gp(v_u_355, "minion"))) if J.t(_t568) else _t568)):
				J.mc(J.G.get("ART"), "rr", [_s193["ctx"], J.sub(v_bx_363, J.div(v_bw_364, 2.0)), J.add(v_by_365, 6.0), J.div(J.mul(v_bw_364, J.gp(v_u_355, "energy")), 100.0), 3.0, 1.5, ("#ffd84a" if J.cmp(J.gp(v_u_355, "energy"), 100.0, ">=") else "#7dd3fc")])
			if J.t(J.gp(v_u_355, "boss")):
				var _t569 = _s193["ctx"]
				J.sp(_t569, "fillStyle", "#ffd0d8")
				var _t570 = _s193["ctx"]
				var _t571 = "bold 12px \"PingFang TC\",\"Noto Sans TC\",sans-serif"
				J.sp(_t570, "font", _t571)
				var _t572 = _s193["ctx"]
				J.sp(_t572, "textAlign", "center")
				J.mc(_s193["ctx"], "fillText", [J.gp(v_u_355, "name"), v_bx_363, J.sub(v_by_365, 4.0)])
			var _t573 = J.cmp(J.gp(J.gp(v_u_355, "st"), "air"), 0.0, ">")
			if (_t573 if _t573 else J.cmp(J.gp(J.gp(v_u_355, "st"), "down"), 0.0, ">")):
				var _t574 = _s193["ctx"]
				var _t575 = ("#9ff" if J.cmp(J.gp(J.gp(v_u_355, "st"), "air"), 0.0, ">") else "#fc9")
				J.sp(_t574, "fillStyle", _t575)
				var _t576 = _s193["ctx"]
				J.sp(_t576, "font", "bold 11px sans-serif")
				var _t577 = _s193["ctx"]
				J.sp(_t577, "textAlign", "center")
				J.mc(_s193["ctx"], "fillText", [("嚇彈起" if J.cmp(J.gp(J.gp(v_u_355, "st"), "air"), 0.0, ">") else "腳軟"), v_bx_363, J.sub(v_by_365, (18.0 if J.t(J.gp(v_u_355, "boss")) else 4.0))])
			var _t578 = J.seq(J.gp(v_u_355, "side"), 1.0)
			var _t579 = (J.gp(v_u_355, "fearT") if _t578 else _t578)
			if J.t((J.cmp(J.gp(J.gp(v_u_355, "fearT"), "until"), J.gp(_s193["this"], "t"), ">") if J.t(_t579) else _t579)):
				J.mc(_s193["ctx"], "save", [])
				var _t580 = _s193["ctx"]
				var _t581 = "bold 11px \"PingFang TC\",\"Noto Sans TC\",sans-serif"
				J.sp(_t580, "font", _t581)
				var _t582 = _s193["ctx"]
				J.sp(_t582, "textAlign", "center")
				var _t583 = _s193["ctx"]
				J.sp(_t583, "lineWidth", 3.0)
				var _t584 = _s193["ctx"]
				J.sp(_t584, "strokeStyle", "rgba(20,0,30,.8)")
				var _t585 = _s193["ctx"]
				J.sp(_t585, "fillStyle", "#e6c4ff")
				var _t587 = J.sub(v_by_365, (18.0 if J.t(J.gp(v_u_355, "boss")) else 6.0))
				var _t586 = J.cmp(J.gp(J.gp(v_u_355, "st"), "air"), 0.0, ">")
				v_ty_366 = (_t587 - (13.0 if (_t586 if _t586 else J.cmp(J.gp(J.gp(v_u_355, "st"), "down"), 0.0, ">")) else 0.0))
				v_tx_367 = ("失神・" + J.str(J.mc(J.G.get("Rework"), "word", [J.gp(J.gp(v_u_355, "fearT"), "t")])))
				J.mc(_s193["ctx"], "strokeText", [v_tx_367, v_bx_363, v_ty_366])
				J.mc(_s193["ctx"], "fillText", [v_tx_367, v_bx_363, v_ty_366])
				J.mc(_s193["ctx"], "restore", [])
	if J.t(J.gp(_s193["this"], "advCast")):
		J.mc(_s193["this"], "drawCharge", [_s193["ctx"], 34.0, J.mul(v_H_348, 0.36), 1.0, J.div(J.gp(J.gp(_s193["this"], "advCast"), "t"), J.gp(J.gp(_s193["this"], "advCast"), "dur")), "#c8ffb0", true])
	if J.t(J.gp(_s193["this"], "comboCast")):
		var _s206 = {"__p": _s193, "p": null}
		v_c_368 = J.gp(_s206["__p"]["this"], "comboSkill")
		_s206["p"] = J.div(J.gp(J.gp(_s206["__p"]["this"], "comboCast"), "t"), J.gp(J.gp(_s206["__p"]["this"], "comboCast"), "dur"))
		var _t588 = [J.gp(v_c_368, "a"), J.gp(v_c_368, "b")]
		J.mc(_t588, "forEach", [Callable(self, "_f98").bind(_s206)])
	for _t590 in J.iter(J.gp(_s193["this"], "proj")):
		v_p_371 = _t590
		J.mc(_s193["this"], "drawProj", [_s193["ctx"], v_p_371])
	if J.cmp(J.gp(_s193["this"], "flashT"), 0.0, ">"):
		var _t591 = _s193["ctx"]
		var _t592 = ("rgba(255,255,255," + J.str(J.mul(J.gp(_s193["this"], "flashT"), 1.5)) + ")")
		J.sp(_t591, "fillStyle", _t592)
		J.mc(_s193["ctx"], "fillRect", [(-20.0), (-20.0), 430.0, J.add(v_H_348, 40.0)])
	for _t593 in J.iter(J.gp(_s193["this"], "fx")):
		v_f_372 = _t593
		if J.seq(J.gp(v_f_372, "kind"), "spark"):
			J.mc(_s193["this"], "drawSpark", [_s193["ctx"], v_f_372])
		else:
			if J.seq(J.gp(v_f_372, "kind"), "slash"):
				J.mc(_s193["this"], "drawSlash", [_s193["ctx"], v_f_372])
			else:
				if J.seq(J.gp(v_f_372, "kind"), "ring"):
					v_p_373 = J.div(J.gp(v_f_372, "t"), J.gp(v_f_372, "life"))
					J.mc(_s193["ctx"], "save", [])
					var _t594 = _s193["ctx"]
					var _t595 = J.sub(1.0, v_p_373)
					J.sp(_t594, "globalAlpha", _t595)
					var _t596 = _s193["ctx"]
					var _t597 = J.gp(v_f_372, "col")
					J.sp(_t596, "strokeStyle", _t597)
					var _t598 = _s193["ctx"]
					var _t599 = ((3.0 * J.sub(1.0, v_p_373)) + 1.0)
					J.sp(_t598, "lineWidth", _t599)
					J.mc(_s193["ctx"], "beginPath", [])
					J.mc(_s193["ctx"], "ellipse", [J.gp(v_f_372, "x"), J.gp(v_f_372, "y"), (14.0 + J.mul(v_p_373, 26.0)), ((14.0 + J.mul(v_p_373, 26.0)) * 0.5), 0.0, 0.0, (PI * 2.0)])
					J.mc(_s193["ctx"], "stroke", [])
					J.mc(_s193["ctx"], "restore", [])
				else:
					if (not J.seq(J.gp(v_f_372, "kind"), "dust")):
						J.mc(_s193["this"], "drawText", [_s193["ctx"], v_f_372])
	var _t600 = J.cmp(J.gp(_s193["this"], "comboT"), 0.0, ">")
	if (J.cmp(J.gp(_s193["this"], "combo"), 0.0, ">") if _t600 else _t600):
		var _t601 = J.gp(_s193["this"], "comboPop")
		v_z_374 = (1.0 + J.mul((_t601 if J.t(_t601) else 0.0), 0.7))
		J.mc(_s193["ctx"], "save", [])
		J.mc(_s193["ctx"], "translate", [380.0, 40.0])
		J.mc(_s193["ctx"], "scale", [v_z_374, v_z_374])
		var _t602 = _s193["ctx"]
		J.sp(_t602, "textAlign", "right")
		var _t603 = _s193["ctx"]
		J.sp(_t603, "font", "900 16px sans-serif")
		var _t604 = _s193["ctx"]
		J.sp(_t604, "lineWidth", 4.0)
		var _t605 = _s193["ctx"]
		J.sp(_t605, "strokeStyle", "rgba(10,6,20,.9)")
		J.mc(_s193["ctx"], "strokeText", [("COMBO " + J.str(J.gp(_s193["this"], "combo"))), 0.0, 0.0])
		var _t606 = _s193["ctx"]
		J.sp(_t606, "fillStyle", "#ffd84a")
		J.mc(_s193["ctx"], "fillText", [("COMBO " + J.str(J.gp(_s193["this"], "combo"))), 0.0, 0.0])
		J.mc(_s193["ctx"], "restore", [])

func _f99(this_, a: Array, env):
	var v_ctx_377 = null; var v_f_378 = null; var v_t_379 = null; var v_a_380 = null; var v_pop_381 = null; var v_x_382 = null; var v_y_383 = null; var v_size_384 = null
	v_ctx_377 = J.arg(a, 0)
	v_f_378 = J.arg(a, 1)
	v_t_379 = J.gp(v_f_378, "t")
	v_a_380 = (J.max_([0.0, (1.0 - J.div(J.sub(v_t_379, J.mul(J.gp(v_f_378, "life"), 0.7)), J.mul(J.gp(v_f_378, "life"), 0.3)))]) if J.cmp(v_t_379, J.mul(J.gp(v_f_378, "life"), 0.7), ">") else 1.0)
	v_pop_381 = ((0.35 + (J.div(v_t_379, 0.1) * 1.05)) if J.cmp(v_t_379, 0.1, "<") else ((1.4 - (J.div(J.sub(v_t_379, 0.1), 0.1) * 0.4)) if J.cmp(v_t_379, 0.2, "<") else 1.0))
	v_x_382 = J.gp(v_f_378, "x")
	v_y_383 = J.gp(v_f_378, "y")
	if J.seq(J.gp(v_f_378, "kind"), "num"):
		var _t607 = J.gp(v_f_378, "vx")
		var _t608 = J.add(v_x_382, J.mul((_t607 if J.t(_t607) else 0.0), v_t_379))
		v_x_382 = _t608
		var _t609 = J.add(v_y_383, (J.mul((-120.0), v_t_379) + J.mul(J.mul((0.5 * 330.0), v_t_379), v_t_379)))
		v_y_383 = _t609
	else:
		if (not J.t(J.gp(v_f_378, "center"))):
			var _t610 = J.sub(v_y_383, J.mul(v_t_379, 30.0))
			v_y_383 = _t610
	v_size_384 = (30.0 if J.t(J.gp(v_f_378, "center")) else (16.0 if J.t(J.gp(v_f_378, "skill")) else (19.0 if J.t(J.gp(v_f_378, "big")) else 14.0)))
	J.mc(v_ctx_377, "save", [])
	J.sp(v_ctx_377, "globalAlpha", v_a_380)
	J.mc(v_ctx_377, "translate", [v_x_382, v_y_383])
	J.mc(v_ctx_377, "scale", [v_pop_381, v_pop_381])
	J.sp(v_ctx_377, "textAlign", "center")
	var _t611 = ("900 " + J.str(v_size_384) + "px \"PingFang TC\",\"Noto Sans TC\",sans-serif")
	J.sp(v_ctx_377, "font", _t611)
	var _t612 = J.gp(v_f_378, "big")
	var _t613 = (5.0 if J.t((_t612 if J.t(_t612) else J.gp(v_f_378, "center"))) else 4.0)
	J.sp(v_ctx_377, "lineWidth", _t613)
	J.sp(v_ctx_377, "lineJoin", "round")
	J.sp(v_ctx_377, "strokeStyle", "rgba(10,6,20,.92)")
	J.mc(v_ctx_377, "strokeText", [J.gp(v_f_378, "text"), 0.0, 0.0])
	var _t614 = J.gp(v_f_378, "col")
	J.sp(v_ctx_377, "fillStyle", _t614)
	J.mc(v_ctx_377, "fillText", [J.gp(v_f_378, "text"), 0.0, 0.0])
	J.mc(v_ctx_377, "restore", [])

func _f101(this_, a: Array, env):
	var v_r_394 = null; var v_i_395 = null
	v_r_394 = J.arg(a, 0)
	v_i_395 = J.arg(a, 1)
	return (sin(J.num(J.add(J.gp(v_r_394, "j"), J.mul(v_i_395, 7.3)))) * 1.6)

func _f102(this_, a: Array, env):
	var v_col_396 = null; var v_w_397 = null; var v_al_398 = null; var v_off_399 = null; var v_r_400 = null; var v_r0_401 = null; var v_r1_402 = null; var v_c_403 = null; var v_sn_404 = null; var v_i_405 = null
	v_col_396 = J.arg(a, 0)
	v_w_397 = J.arg(a, 1)
	v_al_398 = J.arg(a, 2)
	v_off_399 = J.arg(a, 3)
	var _t616 = env["ctx"]
	J.sp(_t616, "strokeStyle", v_col_396)
	var _t617 = env["ctx"]
	var _t618 = J.mul(v_al_398, env["a"])
	J.sp(_t617, "globalAlpha", _t618)
	var _t619 = env["ctx"]
	J.sp(_t619, "lineWidth", v_w_397)
	for _t620 in J.iter(J.gp(env["f"], "rays")):
		v_r_400 = _t620
		v_r0_401 = J.mul(J.gp(v_r_400, "len"), (0.15 + J.mul(env["e"], 0.55)))
		v_r1_402 = J.mul(J.gp(v_r_400, "len"), (0.45 + J.mul(env["e"], 0.75)))
		v_c_403 = cos(J.num(J.gp(v_r_400, "a")))
		v_sn_404 = sin(J.num(J.gp(v_r_400, "a")))
		v_i_405 = 0.0
		while true:
			if not J.cmp(v_i_405, 2.0, "<"): break
			J.mc(env["ctx"], "beginPath", [])
			var _t622 = J.mul(v_c_403, v_r0_401)
			var _t621 = env["jit"]
			var _t625 = J.add(_t622, J.cl(_t621, null, [v_r_400, J.add(v_i_405, v_off_399)]))
			var _t624 = J.mul(v_sn_404, v_r0_401)
			var _t623 = env["jit"]
			J.mc(env["ctx"], "moveTo", [_t625, J.add(_t624, J.cl(_t623, null, [v_r_400, J.add(J.add(v_i_405, v_off_399), 3.0)]))])
			var _t627 = J.mul(v_c_403, v_r1_402)
			var _t626 = env["jit"]
			var _t630 = J.add(_t627, J.cl(_t626, null, [v_r_400, J.add(J.add(v_i_405, v_off_399), 5.0)]))
			var _t629 = J.mul(v_sn_404, v_r1_402)
			var _t628 = env["jit"]
			J.mc(env["ctx"], "lineTo", [_t630, J.add(_t629, J.cl(_t628, null, [v_r_400, J.add(J.add(v_i_405, v_off_399), 1.0)]))])
			J.mc(env["ctx"], "stroke", [])
			v_i_405 = J.num(v_i_405) + 1.0

func _f100(this_, a: Array, env):
	var v_p_389 = null; var v_pass_393 = null; var v_q_406 = null; var v_i_407 = null; var v_ang_408 = null; var v_rr_409 = null
	var _s216 = {"__p": env, "ctx": null, "f": null, "e": null, "a": null, "jit": null}
	_s216["ctx"] = J.arg(a, 0)
	_s216["f"] = J.arg(a, 1)
	v_p_389 = J.div(J.gp(_s216["f"], "t"), J.gp(_s216["f"], "life"))
	_s216["e"] = (1.0 - pow(J.num(J.sub(1.0, v_p_389)), J.num(2.0)))
	_s216["a"] = J.sub(1.0, v_p_389)
	J.mc(_s216["ctx"], "save", [])
	var _t615 = _s216["ctx"]
	J.sp(_t615, "lineCap", "round")
	J.mc(_s216["ctx"], "translate", [J.gp(_s216["f"], "x"), J.gp(_s216["f"], "y")])
	_s216["jit"] = Callable(self, "_f101").bind(_s216)
	v_pass_393 = Callable(self, "_f102").bind(_s216)
	J.cl(v_pass_393, null, ["rgba(20,10,30,.85)", (J.mul(4.2, J.gp(_s216["f"], "k")) * (1.0 - J.mul(v_p_389, 0.5))), 0.8, 0.0])
	J.cl(v_pass_393, null, [J.gp(_s216["f"], "col"), (J.mul(2.4, J.gp(_s216["f"], "k")) * (1.0 - J.mul(v_p_389, 0.5))), 1.0, 2.0])
	J.cl(v_pass_393, null, ["#fff", J.mul(1.0, J.gp(_s216["f"], "k")), 0.9, 4.0])
	if J.cmp(v_p_389, 0.5, "<"):
		v_q_406 = J.mul(((1.0 - J.mul(v_p_389, 2.0)) * 12.0), J.gp(_s216["f"], "k"))
		var _t631 = _s216["ctx"]
		var _t632 = (1.0 - J.mul(v_p_389, 2.0))
		J.sp(_t631, "globalAlpha", _t632)
		J.mc(_s216["ctx"], "rotate", [J.gp(_s216["f"], "rot")])
		var _t633 = _s216["ctx"]
		J.sp(_t633, "fillStyle", "#fff")
		J.mc(_s216["ctx"], "beginPath", [])
		v_i_407 = 0.0
		while true:
			if not J.cmp(v_i_407, 8.0, "<"): break
			v_ang_408 = J.div(J.mul(v_i_407, PI), 4.0)
			v_rr_409 = (J.mul(v_q_406, 0.28) if J.t(J.mod(v_i_407, 2.0)) else v_q_406)
			J.mc(_s216["ctx"], "lineTo", [J.mul(cos(J.num(v_ang_408)), v_rr_409), J.mul(sin(J.num(v_ang_408)), v_rr_409)])
			v_i_407 = J.num(v_i_407) + 1.0
		J.mc(_s216["ctx"], "closePath", [])
		J.mc(_s216["ctx"], "fill", [])
	J.mc(_s216["ctx"], "restore", [])

func _f103(this_, a: Array, env):
	var v_ctx_412 = null; var v_f_413 = null; var v_p_414 = null; var v_r_415 = null; var v_sweep_416 = null; var v_a0_417 = null; var v_a1_418 = null; var v_tail_419 = null; var v_i_420 = null
	v_ctx_412 = J.arg(a, 0)
	v_f_413 = J.arg(a, 1)
	v_p_414 = J.div(J.gp(v_f_413, "t"), J.gp(v_f_413, "life"))
	v_r_415 = J.gp(v_f_413, "r")
	v_sweep_416 = J.min_([1.0, J.mul(v_p_414, 2.2)])
	v_a0_417 = (-1.25)
	v_a1_418 = J.add(v_a0_417, J.mul(2.5, v_sweep_416))
	v_tail_419 = J.max_([v_a0_417, J.sub(v_a1_418, 1.6)])
	J.mc(v_ctx_412, "save", [])
	J.mc(v_ctx_412, "translate", [J.sub(J.gp(v_f_413, "x"), (J.mul(J.gp(v_f_413, "dir"), v_r_415) * 0.35)), J.gp(v_f_413, "y")])
	J.mc(v_ctx_412, "scale", [J.gp(v_f_413, "dir"), 1.0])
	var _t634 = (1.0 - J.mul(v_p_414, 0.9))
	J.sp(v_ctx_412, "globalAlpha", _t634)
	J.sp(v_ctx_412, "lineCap", "round")
	v_i_420 = 0.0
	while true:
		if not J.cmp(v_i_420, 3.0, "<"): break
		var _t635 = ("rgba(20,10,30,.6)" if J.seq(v_i_420, 0.0) else (J.gp(v_f_413, "col") if J.seq(v_i_420, 1.0) else "#fff"))
		J.sp(v_ctx_412, "strokeStyle", _t635)
		var _t636 = J.mul(J.gp([7.0, 4.0, 1.6], v_i_420), (1.0 - J.mul(v_p_414, 0.6)))
		J.sp(v_ctx_412, "lineWidth", _t636)
		J.mc(v_ctx_412, "beginPath", [])
		J.mc(v_ctx_412, "arc", [0.0, 0.0, (J.sub(v_r_415, J.mul(v_i_420, 1.2)) + (sin(J.num(J.mul(v_i_420, 3.0))) * 0.8)), v_tail_419, v_a1_418])
		J.mc(v_ctx_412, "stroke", [])
		v_i_420 = J.num(v_i_420) + 1.0
	J.mc(v_ctx_412, "restore", [])

func _f104(this_, a: Array, env):
	var v_ctx_423 = null; var v_f_424 = null; var v_p_425 = null; var v_e_426 = null; var v_q_427 = null
	v_ctx_423 = J.arg(a, 0)
	v_f_424 = J.arg(a, 1)
	v_p_425 = J.div(J.gp(v_f_424, "t"), J.gp(v_f_424, "life"))
	v_e_426 = (1.0 - pow(J.num(J.sub(1.0, v_p_425)), J.num(2.0)))
	J.mc(v_ctx_423, "save", [])
	var _t637 = (0.55 * J.sub(1.0, v_p_425))
	J.sp(v_ctx_423, "globalAlpha", _t637)
	for _t638 in J.iter(J.gp(v_f_424, "puffs")):
		v_q_427 = _t638
		J.sp(v_ctx_423, "fillStyle", "rgba(190,176,150,1)")
		J.mc(v_ctx_423, "beginPath", [])
		J.mc(v_ctx_423, "arc", [J.add(J.add(J.gp(v_f_424, "x"), J.gp(v_q_427, "dx")), (J.mul(J.gp(v_q_427, "vx"), v_e_426) * 0.4)), (J.sub(J.gp(v_f_424, "y"), 2.0) - J.mul(v_e_426, 8.0)), J.mul(J.gp(v_q_427, "r"), (0.6 + J.mul(v_e_426, 0.9))), 0.0, (PI * 2.0)])
		J.mc(v_ctx_423, "fill", [])
	J.mc(v_ctx_423, "restore", [])

func _f105(this_, a: Array, env):
	var v_ctx_430 = null; var v_x_431 = null; var v_y_432 = null; var v_s_433 = null; var v_p_434 = null; var v_col_435 = null; var v_front_436 = null; var v_R_437 = null; var v_g_438 = null; var v_i_439 = null; var v_ang_440 = null; var v_rr_441 = null
	v_ctx_430 = J.arg(a, 0)
	v_x_431 = J.arg(a, 1)
	v_y_432 = J.arg(a, 2)
	v_s_433 = J.arg(a, 3)
	v_p_434 = J.arg(a, 4)
	v_col_435 = J.arg(a, 5)
	v_front_436 = J.arg(a, 6)
	var _t639 = J.min_([1.0, v_p_434])
	v_p_434 = _t639
	J.mc(v_ctx_430, "save", [])
	if (not J.t(v_front_436)):
		v_g_438 = J.mc(v_ctx_430, "createRadialGradient", [v_x_431, v_y_432, 0.0, v_x_431, v_y_432, J.mul(46.0, v_s_433)])
		J.mc(v_g_438, "addColorStop", [0.0, v_col_435])
		J.mc(v_g_438, "addColorStop", [1.0, "rgba(0,0,0,0)"])
		J.sp(v_ctx_430, "globalCompositeOperation", "lighter")
		var _t640 = (0.25 + J.mul(v_p_434, 0.45))
		J.sp(v_ctx_430, "globalAlpha", _t640)
		J.sp(v_ctx_430, "fillStyle", v_g_438)
		J.mc(v_ctx_430, "beginPath", [])
		J.mc(v_ctx_430, "arc", [v_x_431, v_y_432, J.mul(46.0, v_s_433), 0.0, (PI * 2.0)])
		J.mc(v_ctx_430, "fill", [])
		J.mc(v_ctx_430, "restore", [])
		return null
	v_R_437 = J.mul((44.0 - J.mul(v_p_434, 26.0)), v_s_433)
	J.sp(v_ctx_430, "strokeStyle", v_col_435)
	J.sp(v_ctx_430, "lineWidth", 2.5)
	var _t641 = (0.4 + J.mul(v_p_434, 0.6))
	J.sp(v_ctx_430, "globalAlpha", _t641)
	J.mc(v_ctx_430, "setLineDash", [[7.0, 5.0]])
	var _t642 = ((-J.num(J.gp(this_, "t"))) * 60.0)
	J.sp(v_ctx_430, "lineDashOffset", _t642)
	J.mc(v_ctx_430, "beginPath", [])
	J.mc(v_ctx_430, "ellipse", [v_x_431, J.add(v_y_432, J.mul(20.0, v_s_433)), J.mul(v_R_437, 1.1), J.mul(v_R_437, 0.42), 0.0, 0.0, (PI * 2.0)])
	J.mc(v_ctx_430, "stroke", [])
	J.mc(v_ctx_430, "setLineDash", [[]])
	J.sp(v_ctx_430, "lineWidth", 1.6)
	J.mc(v_ctx_430, "beginPath", [])
	J.mc(v_ctx_430, "arc", [v_x_431, v_y_432, v_R_437, 0.0, (PI * 2.0)])
	J.mc(v_ctx_430, "stroke", [])
	J.sp(v_ctx_430, "fillStyle", "#fff")
	v_i_439 = 0.0
	while true:
		if not J.cmp(v_i_439, 8.0, "<"): break
		v_ang_440 = (J.div(J.mul(v_i_439, PI), 4.0) + J.mul(J.gp(this_, "t"), 3.0))
		v_rr_441 = J.mul(v_R_437, (1.25 - J.mul(v_p_434, 0.6)))
		J.sp(v_ctx_430, "globalAlpha", 0.9)
		J.mc(v_ctx_430, "beginPath", [])
		J.mc(v_ctx_430, "arc", [J.add(v_x_431, J.mul(cos(J.num(v_ang_440)), v_rr_441)), J.add(v_y_432, (J.mul(sin(J.num(v_ang_440)), v_rr_441) * 0.8)), (1.6 + J.mul(v_p_434, 1.4)), 0.0, (PI * 2.0)])
		J.mc(v_ctx_430, "fill", [])
		v_i_439 = J.num(v_i_439) + 1.0
	J.mc(v_ctx_430, "restore", [])

func _f106(this_, a: Array, env):
	var v_ctx_444 = null; var v_p_445 = null; var v_g_446 = null; var v_i_447 = null; var v_x0_448 = null; var v_y0_449 = null; var v_x1_450 = null; var v_y1_451 = null; var v_f_452 = null; var v_x0_453 = null; var v_y0_454 = null
	v_ctx_444 = J.arg(a, 0)
	v_p_445 = J.arg(a, 1)
	J.mc(v_ctx_444, "save", [])
	J.sp(v_ctx_444, "lineCap", "round")
	v_i_447 = 1.0
	while true:
		if not J.cmp(v_i_447, J.len(J.gp(v_p_445, "trail")), "<"): break
		var _t643 = J.gp(J.gp(v_p_445, "trail"), J.sub(v_i_447, 1.0))
		var _t644 = J.gp(_t643, 0.0)
		v_x0_448 = _t644
		var _t645 = J.gp(_t643, 1.0)
		v_y0_449 = _t645
		var _t646 = J.gp(J.gp(v_p_445, "trail"), v_i_447)
		var _t647 = J.gp(_t646, 0.0)
		v_x1_450 = _t647
		var _t648 = J.gp(_t646, 1.0)
		v_y1_451 = _t648
		v_f_452 = J.div(v_i_447, J.len(J.gp(v_p_445, "trail")))
		var _t649 = J.mul(v_f_452, 0.7)
		J.sp(v_ctx_444, "globalAlpha", _t649)
		var _t650 = J.gp(v_p_445, "col")
		J.sp(v_ctx_444, "strokeStyle", _t650)
		var _t651 = (1.0 + J.mul(v_f_452, 5.0))
		J.sp(v_ctx_444, "lineWidth", _t651)
		J.mc(v_ctx_444, "beginPath", [])
		J.mc(v_ctx_444, "moveTo", [v_x0_448, v_y0_449])
		J.mc(v_ctx_444, "lineTo", [v_x1_450, v_y1_451])
		J.mc(v_ctx_444, "stroke", [])
		v_i_447 = J.num(v_i_447) + 1.0
	if J.t(J.len(J.gp(v_p_445, "trail"))):
		var _t652 = J.gp(J.gp(v_p_445, "trail"), (J.len(J.gp(v_p_445, "trail")) - 1.0))
		var _t653 = J.gp(_t652, 0.0)
		v_x0_453 = _t653
		var _t654 = J.gp(_t652, 1.0)
		v_y0_454 = _t654
		J.sp(v_ctx_444, "globalAlpha", 0.8)
		J.sp(v_ctx_444, "lineWidth", 6.0)
		J.mc(v_ctx_444, "beginPath", [])
		J.mc(v_ctx_444, "moveTo", [v_x0_453, v_y0_454])
		J.mc(v_ctx_444, "lineTo", [J.gp(v_p_445, "x"), J.gp(v_p_445, "y")])
		J.mc(v_ctx_444, "stroke", [])
	J.sp(v_ctx_444, "globalAlpha", 1.0)
	J.sp(v_ctx_444, "globalCompositeOperation", "lighter")
	v_g_446 = J.mc(v_ctx_444, "createRadialGradient", [J.gp(v_p_445, "x"), J.gp(v_p_445, "y"), 0.0, J.gp(v_p_445, "x"), J.gp(v_p_445, "y"), 11.0])
	J.mc(v_g_446, "addColorStop", [0.0, "#fff"])
	J.mc(v_g_446, "addColorStop", [0.35, J.gp(v_p_445, "col")])
	J.mc(v_g_446, "addColorStop", [1.0, "rgba(0,0,0,0)"])
	J.sp(v_ctx_444, "fillStyle", v_g_446)
	J.mc(v_ctx_444, "beginPath", [])
	J.mc(v_ctx_444, "arc", [J.gp(v_p_445, "x"), J.gp(v_p_445, "y"), 11.0, 0.0, (PI * 2.0)])
	J.mc(v_ctx_444, "fill", [])
	J.mc(v_ctx_444, "restore", [])
