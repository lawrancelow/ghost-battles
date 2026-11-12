# 自動轉譯自 gpower.js（tools/jsgd.js）——唔好直接改，改原 JS 再轉
extends RefCounted

func run(env):
	var this_ = null; var a = []
	J.G["GP"] = J.cl(Callable(self, "_f1").bind(env), null, [])
	if (not J.seq(J.typeof_(J.G.get("window")), "undefined")):
		var _t84 = J.G.get("window")
		var _t85 = J.G.get("GP")
		J.sp(_t84, "GP", _t85)

func _f4(this_, a: Array, env):
	var v_k_36 = null; var v_e_37 = null
	v_k_36 = J.arg(a, 0)
	var _t1 = env["ok"]
	var _t2 = J.cl(_t1, null, [J.G.get("Rework")])
	var _t4 = null
	if J.t((J.gp(J.G.get("Rework"), "drillLv") if J.t(_t2) else _t2)):
		var _t3 = J.mc(J.G.get("Rework"), "drillLv", [v_k_36])
		_t4 = (_t3 if J.t(_t3) else 1.0)
	else:
		_t4 = 1.0
	return _t4

func _f6(this_, a: Array, env):
	var v_i_41 = null
	v_i_41 = J.arg(a, 0)
	return J.mc(J.G.get("F"), "stat", [env["g"], v_i_41])

func _f7(this_, a: Array, env):
	var v_v_45 = null
	v_v_45 = J.arg(a, 0)
	return J.round(J.num(J.mul(v_v_45, (1.0 + (0.06 * J.sub(env["lv"], 1.0))))))

func _f5(this_, a: Array, env):
	var v_e_42 = null; var v_d_43 = null; var v_e_46 = null
	var _s12 = {"__p": env, "g": null}
	_s12["g"] = J.arg(a, 0)
	var _t5 = _s12["__p"]["ok"]
	var _t6 = J.cl(_t5, null, [J.G.get("F")])
	var _t7 = (_s12["g"] if J.t(_t6) else _t6)
	if J.t((J.gp(_s12["g"], "st") if J.t(_t7) else _t7)):
		var _t8 = [0.0, 1.0, 2.0]
		return J.mc(_t8, "map", [Callable(self, "_f6").bind(_s12)])
	var _s17 = {"__p": _s12, "lv": null}
	var _t9 = _s17["__p"]["__p"]["ok"]
	var _t10 = J.cl(_t9, null, [J.G.get("GHOSTS")])
	var _t13 = (J.gp(J.G.get("GHOSTS"), J.gp(_s17["__p"]["g"], "k")) if J.t(_t10) else _t10)
	if not J.t(_t13):
		var _t11 = _s17["__p"]["__p"]["ok"]
		var _t12 = J.cl(_t11, null, [J.G.get("FODDER")])
		_t13 = (J.gp(J.G.get("FODDER"), J.gp(_s17["__p"]["g"], "k")) if J.t(_t12) else _t12)
	v_d_43 = _t13
	var _t14 = _s17["__p"]["__p"]["ok"]
	var _t15 = (J.mc(J.G.get("F"), "glv", [_s17["__p"]["g"]]) if J.t(J.cl(_t14, null, [J.G.get("F")])) else J.gp(_s17["__p"]["g"], "lv"))
	_s17["lv"] = (_t15 if J.t(_t15) else 1.0)
	if J.t((J.gp(v_d_43, "base") if J.t(v_d_43) else v_d_43)):
		var _t16 = J.gp(v_d_43, "base")
		return J.mc(_t16, "map", [Callable(self, "_f7").bind(_s17)])
	return [30.0, 30.0, 30.0]

func _f8(this_, a: Array, env):
	var v_g_49 = null; var v_s_50 = null; var v_e_51 = null
	v_g_49 = J.arg(a, 0)
	var _t22 = J.gp(v_g_49, "st")
	if not J.t(_t22):
		var _t17 = env["ok"]
		var _t18 = J.cl(_t17, null, [J.G.get("GHOSTS")])
		var _t21 = (J.gp(J.G.get("GHOSTS"), J.gp(v_g_49, "k")) if J.t(_t18) else _t18)
		if not J.t(_t21):
			var _t19 = env["ok"]
			var _t20 = J.cl(_t19, null, [J.G.get("FODDER")])
			_t21 = (J.gp(J.G.get("FODDER"), J.gp(v_g_49, "k")) if J.t(_t20) else _t20)
		_t22 = J.gp((_t21 if J.t(_t21) else {}), "base")
	v_s_50 = _t22
	if J.t((J.len(v_s_50) if J.t(v_s_50) else v_s_50)):
		return J.div(J.add(J.add(J.gp(v_s_50, 0.0), J.gp(v_s_50, 1.0)), J.gp(v_s_50, 2.0)), 3.0)
	return 30.0

func _f9(this_, a: Array, env):
	var v_g_54 = null; var v_s_55 = null
	v_g_54 = J.arg(a, 0)
	if (not J.t(v_g_54)):
		return 0.0
	var _t23 = env["stats"]
	v_s_55 = J.cl(_t23, null, [v_g_54])
	var _t25 = J.div(J.add(J.add(J.gp(v_s_55, 0.0), J.gp(v_s_55, 1.0)), J.gp(v_s_55, 2.0)), 3.0)
	var _t24 = env["drill"]
	return (_t25 * (1.0 + (0.2 * J.sub(J.cl(_t24, null, [J.gp(v_g_54, "k")]), 1.0))))

func _f10(this_, a: Array, env):
	var v_g_58 = null
	v_g_58 = J.arg(a, 0)
	var _t26 = env["raw"]
	return J.round(J.num(J.mul(J.cl(_t26, null, [v_g_58]), 10.0)))

func _f11(this_, a: Array, env):
	var v_g_61 = null; var v_m_62 = null
	v_g_61 = J.arg(a, 0)
	if (not J.t(v_g_61)):
		return env["NONE"]
	var _t27 = env["raw"]
	v_m_62 = pow(J.num(J.div(J.cl(_t27, null, [v_g_61]), env["REF"])), J.num(0.6))
	return J.max_([env["MIN"], J.min_([env["MAX"], (v_m_62 if J.t(J.F_isFinite([v_m_62])) else 1.0)])])

func _f12(this_, a: Array, env):
	var v_g_65 = null; var v_m_66 = null
	v_g_65 = J.arg(a, 0)
	if (not J.t(v_g_65)):
		return 1.0
	var _t28 = env["raw"]
	var _t31 = J.cl(_t28, null, [v_g_65])
	var _t29 = env["base"]
	var _t30 = env["base"]
	v_m_66 = pow(J.num(J.div(_t31, J.max_([1.0, J.cl(_t30, null, [v_g_65])]))), J.num(0.6))
	return J.max_([1.0, J.min_([env["MAX"], (v_m_66 if J.t(J.F_isFinite([v_m_66])) else 1.0)])])

func _f13(this_, a: Array, env):
	var v_k_69 = null
	v_k_69 = J.arg(a, 0)
	var _t32 = env["drill"]
	return pow(J.num((1.0 + (0.2 * J.sub(J.cl(_t32, null, [v_k_69]), 1.0)))), J.num(0.6))

func _f14(this_, a: Array, env):
	var v_k_72 = null; var v_b_73 = null; var v_bv_74 = null; var v_g_75 = null; var v_v_76 = null; var v_e_77 = null
	v_k_72 = J.arg(a, 0)
	var _t33 = env["ok"]
	var _t34 = (not J.t(J.cl(_t33, null, [J.G.get("S")])))
	if (_t34 if _t34 else (not J.t(J.gp(J.G.get("S"), "ghosts")))):
		return null
	v_b_73 = null
	v_bv_74 = (-1.0)
	for _t35 in J.iter(J.gp(J.G.get("S"), "ghosts")):
		v_g_75 = _t35
		if J.t((J.seq(J.gp(v_g_75, "k"), v_k_72) if J.t(v_g_75) else v_g_75)):
			var _t36 = env["raw"]
			v_v_76 = J.cl(_t36, null, [v_g_75])
			if J.cmp(v_v_76, v_bv_74, ">"):
				v_bv_74 = v_v_76
				v_b_73 = v_g_75
	return v_b_73

func _f15(this_, a: Array, env):
	var v_k_80 = null; var v_g_81 = null
	v_k_80 = J.arg(a, 0)
	var _t37 = env["best"]
	v_g_81 = J.cl(_t37, null, [v_k_80])
	var _t39 = null
	if J.t(v_g_81):
		var _t38 = env["mul"]
		_t39 = J.cl(_t38, null, [v_g_81])
	else:
		_t39 = env["NONE"]
	return _t39

func _f16(this_, a: Array, env):
	var v_k_84 = null; var v_g_85 = null
	v_k_84 = J.arg(a, 0)
	var _t40 = env["best"]
	v_g_85 = J.cl(_t40, null, [v_k_84])
	var _t42 = null
	if J.t(v_g_85):
		var _t41 = env["pow"]
		_t42 = J.cl(_t41, null, [v_g_85])
	else:
		_t42 = 0.0
	return _t42

func _f17(this_, a: Array, env):
	var v_k_88 = null; var v_g_89 = null
	v_k_88 = J.arg(a, 0)
	var _t43 = env["best"]
	v_g_89 = J.cl(_t43, null, [v_k_88])
	var _t45 = null
	if J.t(v_g_89):
		var _t44 = env["grow"]
		_t45 = J.cl(_t44, null, [v_g_89])
	else:
		_t45 = 1.0
	return _t45

func _f19(this_, a: Array, env):
	var v_s_94 = null; var v_g_95 = null
	v_s_94 = J.arg(a, 0)
	v_g_95 = J.arg(a, 1)
	var _t47 = env["pow"]
	return J.add(v_s_94, J.cl(_t47, null, [v_g_95]))

func _f18(this_, a: Array, env):
	var v_list_92 = null; var v_a_93 = null
	v_list_92 = J.arg(a, 0)
	var _t46 = (v_list_92 if J.t(v_list_92) else [])
	v_a_93 = J.mc(_t46, "filter", [J.G.get("Boolean")])
	return (J.round(J.num(J.div(J.mc(v_a_93, "reduce", [Callable(self, "_f19").bind(env), 0.0]), J.len(v_a_93)))) if J.t(J.len(v_a_93)) else 0.0)

func _f21(this_, a: Array, env):
	var v_g_100 = null
	v_g_100 = J.arg(a, 0)
	return ((not J.seq(J.gp(v_g_100, "k"), "afu")) if J.t(v_g_100) else v_g_100)

func _f22(this_, a: Array, env):
	var v_x_101 = null; var v_y_102 = null
	v_x_101 = J.arg(a, 0)
	v_y_102 = J.arg(a, 1)
	return J.sub(v_y_102, v_x_101)

func _f23(this_, a: Array, env):
	var v_s_103 = null; var v_v_104 = null
	v_s_103 = J.arg(a, 0)
	v_v_104 = J.arg(a, 1)
	return J.add(v_s_103, v_v_104)

func _f20(this_, a: Array, env):
	var v_n_98 = null; var v_a_99 = null; var v_e_105 = null
	v_n_98 = J.arg(a, 0)
	var _t48 = J.gp(J.G.get("S"), "ghosts")
	var _t49 = J.mc(_t48, "filter", [Callable(self, "_f21").bind(env)])
	var _t50 = J.mc(_t49, "map", [env["pow"]])
	var _t51 = J.mc(_t50, "sort", [Callable(self, "_f22").bind(env)])
	v_a_99 = J.mc(_t51, "slice", [0.0, (v_n_98 if J.t(v_n_98) else 3.0)])
	return (J.round(J.num(J.div(J.mc(v_a_99, "reduce", [Callable(self, "_f23").bind(env), 0.0]), J.len(v_a_99)))) if J.t(J.len(v_a_99)) else 0.0)

func _f24(this_, a: Array, env):
	var v_st_108 = null; var v_sid_109 = null; var v_p_110 = null
	v_st_108 = J.arg(a, 0)
	v_sid_109 = J.arg(a, 1)
	if J.t((J.gp(env["STAGE_NEED"], v_sid_109) if J.t(v_sid_109) else v_sid_109)):
		return J.gp(env["STAGE_NEED"], v_sid_109)
	var _t52 = (J.gp(v_st_108, "p") if J.t(v_st_108) else v_st_108)
	v_p_110 = (_t52 if J.t(_t52) else 1.0)
	return (J.round(J.num(J.div((420.0 + ((50.0 * J.max_([0.0, J.sub(v_p_110, 3.0)])) * (1.15 if J.t((J.gp(v_st_108, "boss") if J.t(v_st_108) else v_st_108)) else 1.0))), 10.0))) * 10.0)

func _f25(this_, a: Array, env):
	var v_lv_113 = null; var v_d_114 = null
	v_lv_113 = J.arg(a, 0)
	v_d_114 = J.max_([1.0, (v_lv_113 if J.t(v_lv_113) else 1.0)])
	return (J.round(J.num(J.div((450.0 * pow(J.num((1.0 + (0.05 * J.sub(v_d_114, 1.0)))), J.num(J.div(1.0, 0.6)))), 10.0))) * 10.0)

func _f26(this_, a: Array, env):
	var v_have_117 = null; var v_need_118 = null; var v_low_119 = null
	v_have_117 = J.arg(a, 0)
	v_need_118 = J.arg(a, 1)
	v_low_119 = (J.cmp(v_have_117, v_need_118, "<") if J.t(v_need_118) else v_need_118)
	var _t54 = ("gp-low" if J.t(v_low_119) else "gp-ok")
	var _t53 = env["T"]
	var _t57 = J.cl(_t53, null, ["鬼力", "鬼力"])
	var _t56 = null
	if J.t(v_need_118):
		var _t55 = env["T"]
		_t56 = ("／" + J.str(J.cl(_t55, null, ["建議", "建議"])) + " " + J.str(v_need_118))
	else:
		_t56 = ""
	return ("<span class=\"gp-tag " + _t54 + "\">" + J.str(_t57) + " <b>" + J.str(v_have_117) + "</b>" + _t56 + "</span>")

func _f27(this_, a: Array, env):
	var v_need_122 = null
	v_need_122 = J.arg(a, 0)
	var _t60 = null
	if J.t(v_need_122):
		var _t58 = env["T"]
		_t60 = J.cl(_t58, null, [("鬼力唔夠（建議 " + J.str(v_need_122) + "）。返村幫隻鬼升級、落訓練班練嚇功，再嚟過！"), ("鬼力不足（建議 " + J.str(v_need_122) + "）。回村幫鬼升級、去訓練班練嚇功，再來一次！")])
	else:
		var _t59 = env["T"]
		_t60 = J.cl(_t59, null, ["打唔過？返村幫隻鬼升級、落訓練班練嚇功，再嚟過！", "打不過？回村幫鬼升級、去訓練班練嚇功，再來一次！"])
	return _t60

func _f28(this_, a: Array, env):
	var v_have_125 = null; var v_need_126 = null; var v_extra_127 = null
	v_have_125 = J.arg(a, 0)
	v_need_126 = J.arg(a, 1)
	v_extra_127 = J.arg(a, 2)
	var _t61 = env["tag"]
	var _t64 = J.cl(_t61, null, [v_have_125, v_need_126])
	var _t63 = v_extra_127
	if not J.t(_t63):
		var _t62 = env["hint"]
		_t63 = J.cl(_t62, null, [(v_need_126 if J.t((J.cmp(v_have_125, v_need_126, "<") if J.t(v_need_126) else v_need_126)) else 0.0)])
	var _t65 = env["T"]
	return ("<div class=\"gp-fail\"><p>" + J.str(_t64) + "</p><p class=\"gp-hint\">" + J.str(_t63) + "</p><button class=\"btn gold wide gp-back\">" + J.str(J.cl(_t65, null, ["返村升級", "回村升級"])) + "</button></div>")

func _f30(this_, a: Array, env):
	var v_e_135 = null
	J.mc(J.G.get("UI"), "openRoster", [])

func _f29(this_, a: Array, env):
	var v_before_130 = null; var v_e_131 = null; var v_e_132 = null; var v_e_133 = null; var v_e_134 = null; var v_e_136 = null
	v_before_130 = J.arg(a, 0)
	if J.t(v_before_130):
		J.cl(v_before_130, null, [])
	var _t66 = env["ok"]
	var _t67 = J.cl(_t66, null, [J.G.get("Street")])
	var _t68 = (J.gp(J.G.get("Street"), "Turf") if J.t(_t67) else _t67)
	if J.t((J.gp(J.gp(J.G.get("Street"), "Turf"), "on") if J.t(_t68) else _t68)):
		J.mc(J.gp(J.G.get("Street"), "Turf"), "close", [])
	var _t69 = env["ok"]
	var _t70 = J.cl(_t69, null, [J.G.get("Street")])
	if J.t((J.gp(J.G.get("Street"), "close") if J.t(_t70) else _t70)):
		J.mc(J.G.get("Street"), "close", [])
	var _t71 = env["ok"]
	var _t72 = J.cl(_t71, null, [J.G.get("World")])
	var _t73 = (J.gp(J.G.get("World"), "close") if J.t(_t72) else _t72)
	if J.t((J.S_document_("querySelector", ["#world.on"]) if J.t(_t73) else _t73)):
		J.mc(J.G.get("World"), "close", [])
	var _t74 = env["ok"]
	if J.t(J.cl(_t74, null, [J.G.get("UI")])):
		J.mc(J.G.get("UI"), "close", [])
		if J.t(J.gp(J.G.get("UI"), "refresh")):
			J.mc(J.G.get("UI"), "refresh", [])
		J.F_setTimeout([Callable(self, "_f30").bind(env), 60.0])

func _f33(this_, a: Array, env):
	var v_e_142 = null
	v_e_142 = J.arg(a, 0)
	J.mc(v_e_142, "stopPropagation", [])
	var _t77 = env["__p"]["goVillage"]
	J.cl(_t77, null, [env["before"]])

func _f32(this_, a: Array, env):
	var v_b_141 = null
	v_b_141 = J.arg(a, 0)
	var _t78 = Callable(self, "_f33").bind(env)
	J.sp(v_b_141, "onclick", _t78)
	return _t78

func _f31(this_, a: Array, env):
	var v_root_139 = null
	var _s75 = {"__p": env, "before": null}
	v_root_139 = J.arg(a, 0)
	_s75["before"] = J.arg(a, 1)
	var _t75 = (v_root_139 if J.t(v_root_139) else J.G.get("document"))
	var _t76 = J.mc(_t75, "querySelectorAll", [".gp-back"])
	J.mc(_t76, "forEach", [Callable(self, "_f32").bind(_s75)])

func _f2(this_, a: Array, env):
	var v_x_30 = null
	v_x_30 = J.arg(a, 0)
	return (not J.seq(J.typeof_(v_x_30), "undefined"))

func _f3(this_, a: Array, env):
	var v_yue_31 = null; var v_zh_32 = null; var v_e_33 = null
	v_yue_31 = J.arg(a, 0)
	v_zh_32 = J.arg(a, 1)
	var _t79 = env["ok"]
	var _t80 = J.cl(_t79, null, [J.G.get("LANG")])
	if J.t((v_zh_32 if J.t(_t80) else _t80)):
		J.mc(J.G.get("LANG"), "add", [{J.key(v_yue_31): v_zh_32}])
	var _t81 = env["ok"]
	var _t83 = null
	if J.t(J.cl(_t81, null, [J.G.get("L")])):
		var _t82 = J.G.get("L")
		_t83 = J.cl(_t82, null, [v_yue_31])
	else:
		_t83 = v_yue_31
	return _t83

func _f1(this_, a: Array, env):
	var v_drillMul_15 = null; var v_kindMul_17 = null; var v_kindPow_18 = null; var v_kindGrow_19 = null; var v_avg_20 = null; var v_top_21 = null; var v_stageNeed_23 = null; var v_turfNeed_24 = null; var v_failHTML_27 = null; var v_bindBack_29 = null
	var _s2 = {"__p": env, "REF": null, "NONE": null, "MIN": null, "MAX": null, "ok": null, "T": null, "drill": null, "stats": null, "base": null, "raw": null, "pow": null, "mul": null, "grow": null, "best": null, "STAGE_NEED": null, "tag": null, "hint": null, "goVillage": null}
	_s2["drill"] = Callable(self, "_f4").bind(_s2)
	_s2["stats"] = Callable(self, "_f5").bind(_s2)
	_s2["base"] = Callable(self, "_f8").bind(_s2)
	_s2["raw"] = Callable(self, "_f9").bind(_s2)
	_s2["pow"] = Callable(self, "_f10").bind(_s2)
	_s2["mul"] = Callable(self, "_f11").bind(_s2)
	_s2["grow"] = Callable(self, "_f12").bind(_s2)
	v_drillMul_15 = Callable(self, "_f13").bind(_s2)
	_s2["best"] = Callable(self, "_f14").bind(_s2)
	v_kindMul_17 = Callable(self, "_f15").bind(_s2)
	v_kindPow_18 = Callable(self, "_f16").bind(_s2)
	v_kindGrow_19 = Callable(self, "_f17").bind(_s2)
	v_avg_20 = Callable(self, "_f18").bind(_s2)
	v_top_21 = Callable(self, "_f20").bind(_s2)
	v_stageNeed_23 = Callable(self, "_f24").bind(_s2)
	v_turfNeed_24 = Callable(self, "_f25").bind(_s2)
	_s2["tag"] = Callable(self, "_f26").bind(_s2)
	_s2["hint"] = Callable(self, "_f27").bind(_s2)
	v_failHTML_27 = Callable(self, "_f28").bind(_s2)
	_s2["goVillage"] = Callable(self, "_f29").bind(_s2)
	v_bindBack_29 = Callable(self, "_f31").bind(_s2)
	_s2["REF"] = 45.0
	_s2["NONE"] = 0.7
	_s2["MIN"] = 0.6
	_s2["MAX"] = 3.2
	_s2["ok"] = Callable(self, "_f2").bind(_s2)
	_s2["T"] = Callable(self, "_f3").bind(_s2)
	_s2["STAGE_NEED"] = {"1-1": 450.0, "1-2": 470.0, "1-3": 500.0, "2-1": 520.0, "2-2": 540.0, "2-3": 560.0, "3-1": 580.0, "3-2": 680.0, "3-3": 920.0, "4-1": 870.0, "4-2": 1070.0, "4-3": 1300.0, "5-1": 870.0, "5-2": 1160.0, "5-3": 1300.0, "6-1": 1500.0, "6-2": 1560.0, "6-3": 1900.0}
	return {"REF": _s2["REF"], "NONE": _s2["NONE"], "pow": _s2["pow"], "mul": _s2["mul"], "best": _s2["best"], "kindMul": v_kindMul_17, "kindPow": v_kindPow_18, "hint": _s2["hint"], "raw": _s2["raw"], "grow": _s2["grow"], "kindGrow": v_kindGrow_19, "drillMul": v_drillMul_15, "avg": v_avg_20, "top": v_top_21, "STAGE_NEED": _s2["STAGE_NEED"], "stageNeed": v_stageNeed_23, "turfNeed": v_turfNeed_24, "tag": _s2["tag"], "failHTML": v_failHTML_27, "goVillage": _s2["goVillage"], "bindBack": v_bindBack_29, "T": _s2["T"]}
