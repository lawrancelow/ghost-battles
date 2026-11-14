# 自動轉譯自 gpower.js（tools/jsgd.js）——唔好直接改，改原 JS 再轉
extends RefCounted

func run(env):
	var this_ = null; var a = []
	J.G["GP"] = J.cl(Callable(self, "_f1").bind(env), null, [])
	if (not J.seq(J.typeof_(J.G.get("window")), "undefined")):
		var _t87 = J.G.get("window")
		var _t88 = J.G.get("GP")
		J.sp(_t87, "GP", _t88)

func _f4(this_, a: Array, env):
	var v_k_37 = null; var v_e_38 = null
	v_k_37 = J.arg(a, 0)
	var _t1 = env["ok"]
	var _t2 = J.cl(_t1, null, [J.G.get("Rework")])
	var _t4 = null
	if J.t((J.gp(J.G.get("Rework"), "drillLv") if J.t(_t2) else _t2)):
		var _t3 = J.mc(J.G.get("Rework"), "drillLv", [v_k_37])
		_t4 = (_t3 if J.t(_t3) else 1.0)
	else:
		_t4 = 1.0
	return _t4

func _f6(this_, a: Array, env):
	var v_i_42 = null
	v_i_42 = J.arg(a, 0)
	return J.mc(J.G.get("F"), "stat", [env["g"], v_i_42])

func _f7(this_, a: Array, env):
	var v_v_46 = null
	v_v_46 = J.arg(a, 0)
	return J.round(J.num(J.mul(v_v_46, (1.0 + (0.06 * J.sub(env["lv"], 1.0))))))

func _f5(this_, a: Array, env):
	var v_e_43 = null; var v_d_44 = null; var v_e_47 = null
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
	v_d_44 = _t13
	var _t14 = _s17["__p"]["__p"]["ok"]
	var _t15 = (J.mc(J.G.get("F"), "glv", [_s17["__p"]["g"]]) if J.t(J.cl(_t14, null, [J.G.get("F")])) else J.gp(_s17["__p"]["g"], "lv"))
	_s17["lv"] = (_t15 if J.t(_t15) else 1.0)
	if J.t((J.gp(v_d_44, "base") if J.t(v_d_44) else v_d_44)):
		var _t16 = J.gp(v_d_44, "base")
		return J.mc(_t16, "map", [Callable(self, "_f7").bind(_s17)])
	return [30.0, 30.0, 30.0]

func _f8(this_, a: Array, env):
	var v_g_50 = null; var v_s_51 = null; var v_e_52 = null
	v_g_50 = J.arg(a, 0)
	var _t22 = J.gp(v_g_50, "st")
	if not J.t(_t22):
		var _t17 = env["ok"]
		var _t18 = J.cl(_t17, null, [J.G.get("GHOSTS")])
		var _t21 = (J.gp(J.G.get("GHOSTS"), J.gp(v_g_50, "k")) if J.t(_t18) else _t18)
		if not J.t(_t21):
			var _t19 = env["ok"]
			var _t20 = J.cl(_t19, null, [J.G.get("FODDER")])
			_t21 = (J.gp(J.G.get("FODDER"), J.gp(v_g_50, "k")) if J.t(_t20) else _t20)
		_t22 = J.gp((_t21 if J.t(_t21) else {}), "base")
	v_s_51 = _t22
	if J.t((J.len(v_s_51) if J.t(v_s_51) else v_s_51)):
		return J.div(J.add(J.add(J.gp(v_s_51, 0.0), J.gp(v_s_51, 1.0)), J.gp(v_s_51, 2.0)), 3.0)
	return 30.0

func _f9(this_, a: Array, env):
	var v_g_55 = null; var v_e_56 = null
	v_g_55 = J.arg(a, 0)
	var _t23 = (not J.seq(J.typeof_(J.G.get("Gear")), "undefined"))
	return (J.mc(J.G.get("Gear"), "gpMul", [v_g_55]) if J.t((J.gp(J.G.get("Gear"), "gpMul") if _t23 else _t23)) else 1.0)

func _f10(this_, a: Array, env):
	var v_g_59 = null; var v_s_60 = null
	v_g_59 = J.arg(a, 0)
	if (not J.t(v_g_59)):
		return 0.0
	var _t24 = env["stats"]
	v_s_60 = J.cl(_t24, null, [v_g_59])
	var _t26 = J.div(J.add(J.add(J.gp(v_s_60, 0.0), J.gp(v_s_60, 1.0)), J.gp(v_s_60, 2.0)), 3.0)
	var _t25 = env["drill"]
	var _t28 = (_t26 * (1.0 + (0.2 * J.sub(J.cl(_t25, null, [J.gp(v_g_59, "k")]), 1.0))))
	var _t27 = env["gearMul"]
	return J.mul(_t28, J.cl(_t27, null, [v_g_59]))

func _f11(this_, a: Array, env):
	var v_g_63 = null
	v_g_63 = J.arg(a, 0)
	var _t29 = env["raw"]
	return J.round(J.num(J.mul(J.cl(_t29, null, [v_g_63]), 10.0)))

func _f12(this_, a: Array, env):
	var v_g_66 = null; var v_m_67 = null
	v_g_66 = J.arg(a, 0)
	if (not J.t(v_g_66)):
		return env["NONE"]
	var _t30 = env["raw"]
	v_m_67 = pow(J.num(J.div(J.cl(_t30, null, [v_g_66]), env["REF"])), J.num(0.6))
	return J.max_([env["MIN"], J.min_([env["MAX"], (v_m_67 if J.t(J.F_isFinite([v_m_67])) else 1.0)])])

func _f13(this_, a: Array, env):
	var v_g_70 = null; var v_m_71 = null
	v_g_70 = J.arg(a, 0)
	if (not J.t(v_g_70)):
		return 1.0
	var _t31 = env["raw"]
	var _t34 = J.cl(_t31, null, [v_g_70])
	var _t32 = env["base"]
	var _t33 = env["base"]
	v_m_71 = pow(J.num(J.div(_t34, J.max_([1.0, J.cl(_t33, null, [v_g_70])]))), J.num(0.6))
	return J.max_([1.0, J.min_([env["MAX"], (v_m_71 if J.t(J.F_isFinite([v_m_71])) else 1.0)])])

func _f14(this_, a: Array, env):
	var v_k_74 = null
	v_k_74 = J.arg(a, 0)
	var _t35 = env["drill"]
	return pow(J.num((1.0 + (0.2 * J.sub(J.cl(_t35, null, [v_k_74]), 1.0)))), J.num(0.6))

func _f15(this_, a: Array, env):
	var v_k_77 = null; var v_b_78 = null; var v_bv_79 = null; var v_g_80 = null; var v_v_81 = null; var v_e_82 = null
	v_k_77 = J.arg(a, 0)
	var _t36 = env["ok"]
	var _t37 = (not J.t(J.cl(_t36, null, [J.G.get("S")])))
	if (_t37 if _t37 else (not J.t(J.gp(J.G.get("S"), "ghosts")))):
		return null
	v_b_78 = null
	v_bv_79 = (-1.0)
	for _t38 in J.iter(J.gp(J.G.get("S"), "ghosts")):
		v_g_80 = _t38
		if J.t((J.seq(J.gp(v_g_80, "k"), v_k_77) if J.t(v_g_80) else v_g_80)):
			var _t39 = env["raw"]
			v_v_81 = J.cl(_t39, null, [v_g_80])
			if J.cmp(v_v_81, v_bv_79, ">"):
				v_bv_79 = v_v_81
				v_b_78 = v_g_80
	return v_b_78

func _f16(this_, a: Array, env):
	var v_k_85 = null; var v_g_86 = null
	v_k_85 = J.arg(a, 0)
	var _t40 = env["best"]
	v_g_86 = J.cl(_t40, null, [v_k_85])
	var _t42 = null
	if J.t(v_g_86):
		var _t41 = env["mul"]
		_t42 = J.cl(_t41, null, [v_g_86])
	else:
		_t42 = env["NONE"]
	return _t42

func _f17(this_, a: Array, env):
	var v_k_89 = null; var v_g_90 = null
	v_k_89 = J.arg(a, 0)
	var _t43 = env["best"]
	v_g_90 = J.cl(_t43, null, [v_k_89])
	var _t45 = null
	if J.t(v_g_90):
		var _t44 = env["pow"]
		_t45 = J.cl(_t44, null, [v_g_90])
	else:
		_t45 = 0.0
	return _t45

func _f18(this_, a: Array, env):
	var v_k_93 = null; var v_g_94 = null
	v_k_93 = J.arg(a, 0)
	var _t46 = env["best"]
	v_g_94 = J.cl(_t46, null, [v_k_93])
	var _t48 = null
	if J.t(v_g_94):
		var _t47 = env["grow"]
		_t48 = J.cl(_t47, null, [v_g_94])
	else:
		_t48 = 1.0
	return _t48

func _f20(this_, a: Array, env):
	var v_s_99 = null; var v_g_100 = null
	v_s_99 = J.arg(a, 0)
	v_g_100 = J.arg(a, 1)
	var _t50 = env["pow"]
	return J.add(v_s_99, J.cl(_t50, null, [v_g_100]))

func _f19(this_, a: Array, env):
	var v_list_97 = null; var v_a_98 = null
	v_list_97 = J.arg(a, 0)
	var _t49 = (v_list_97 if J.t(v_list_97) else [])
	v_a_98 = J.mc(_t49, "filter", [J.G.get("Boolean")])
	return (J.round(J.num(J.div(J.mc(v_a_98, "reduce", [Callable(self, "_f20").bind(env), 0.0]), J.len(v_a_98)))) if J.t(J.len(v_a_98)) else 0.0)

func _f22(this_, a: Array, env):
	var v_g_105 = null
	v_g_105 = J.arg(a, 0)
	return ((not J.seq(J.gp(v_g_105, "k"), "afu")) if J.t(v_g_105) else v_g_105)

func _f23(this_, a: Array, env):
	var v_x_106 = null; var v_y_107 = null
	v_x_106 = J.arg(a, 0)
	v_y_107 = J.arg(a, 1)
	return J.sub(v_y_107, v_x_106)

func _f24(this_, a: Array, env):
	var v_s_108 = null; var v_v_109 = null
	v_s_108 = J.arg(a, 0)
	v_v_109 = J.arg(a, 1)
	return J.add(v_s_108, v_v_109)

func _f21(this_, a: Array, env):
	var v_n_103 = null; var v_a_104 = null; var v_e_110 = null
	v_n_103 = J.arg(a, 0)
	var _t51 = J.gp(J.G.get("S"), "ghosts")
	var _t52 = J.mc(_t51, "filter", [Callable(self, "_f22").bind(env)])
	var _t53 = J.mc(_t52, "map", [env["pow"]])
	var _t54 = J.mc(_t53, "sort", [Callable(self, "_f23").bind(env)])
	v_a_104 = J.mc(_t54, "slice", [0.0, (v_n_103 if J.t(v_n_103) else 3.0)])
	return (J.round(J.num(J.div(J.mc(v_a_104, "reduce", [Callable(self, "_f24").bind(env), 0.0]), J.len(v_a_104)))) if J.t(J.len(v_a_104)) else 0.0)

func _f25(this_, a: Array, env):
	var v_st_113 = null; var v_sid_114 = null; var v_p_115 = null
	v_st_113 = J.arg(a, 0)
	v_sid_114 = J.arg(a, 1)
	if J.t((J.gp(env["STAGE_NEED"], v_sid_114) if J.t(v_sid_114) else v_sid_114)):
		return J.gp(env["STAGE_NEED"], v_sid_114)
	var _t55 = (J.gp(v_st_113, "p") if J.t(v_st_113) else v_st_113)
	v_p_115 = (_t55 if J.t(_t55) else 1.0)
	return (J.round(J.num(J.div((420.0 + ((50.0 * J.max_([0.0, J.sub(v_p_115, 3.0)])) * (1.15 if J.t((J.gp(v_st_113, "boss") if J.t(v_st_113) else v_st_113)) else 1.0))), 10.0))) * 10.0)

func _f26(this_, a: Array, env):
	var v_lv_118 = null; var v_d_119 = null
	v_lv_118 = J.arg(a, 0)
	v_d_119 = J.max_([1.0, (v_lv_118 if J.t(v_lv_118) else 1.0)])
	return (J.round(J.num(J.div((450.0 * pow(J.num((1.0 + (0.05 * J.sub(v_d_119, 1.0)))), J.num(J.div(1.0, 0.6)))), 10.0))) * 10.0)

func _f27(this_, a: Array, env):
	var v_have_122 = null; var v_need_123 = null; var v_low_124 = null
	v_have_122 = J.arg(a, 0)
	v_need_123 = J.arg(a, 1)
	v_low_124 = (J.cmp(v_have_122, v_need_123, "<") if J.t(v_need_123) else v_need_123)
	var _t57 = ("gp-low" if J.t(v_low_124) else "gp-ok")
	var _t56 = env["T"]
	var _t60 = J.cl(_t56, null, ["鬼力", "鬼力"])
	var _t59 = null
	if J.t(v_need_123):
		var _t58 = env["T"]
		_t59 = ("／" + J.str(J.cl(_t58, null, ["建議", "建議"])) + " " + J.str(v_need_123))
	else:
		_t59 = ""
	return ("<span class=\"gp-tag " + _t57 + "\">" + J.str(_t60) + " <b>" + J.str(v_have_122) + "</b>" + _t59 + "</span>")

func _f28(this_, a: Array, env):
	var v_need_127 = null
	v_need_127 = J.arg(a, 0)
	var _t63 = null
	if J.t(v_need_127):
		var _t61 = env["T"]
		_t63 = J.cl(_t61, null, [("鬼力唔夠（建議 " + J.str(v_need_127) + "）。返村幫隻鬼升級、落訓練班練嚇功，再嚟過！"), ("鬼力不足（建議 " + J.str(v_need_127) + "）。回村幫鬼升級、去訓練班練嚇功，再來一次！")])
	else:
		var _t62 = env["T"]
		_t63 = J.cl(_t62, null, ["打唔過？返村幫隻鬼升級、落訓練班練嚇功，再嚟過！", "打不過？回村幫鬼升級、去訓練班練嚇功，再來一次！"])
	return _t63

func _f29(this_, a: Array, env):
	var v_have_130 = null; var v_need_131 = null; var v_extra_132 = null
	v_have_130 = J.arg(a, 0)
	v_need_131 = J.arg(a, 1)
	v_extra_132 = J.arg(a, 2)
	var _t64 = env["tag"]
	var _t67 = J.cl(_t64, null, [v_have_130, v_need_131])
	var _t66 = v_extra_132
	if not J.t(_t66):
		var _t65 = env["hint"]
		_t66 = J.cl(_t65, null, [(v_need_131 if J.t((J.cmp(v_have_130, v_need_131, "<") if J.t(v_need_131) else v_need_131)) else 0.0)])
	var _t68 = env["T"]
	return ("<div class=\"gp-fail\"><p>" + J.str(_t67) + "</p><p class=\"gp-hint\">" + J.str(_t66) + "</p><button class=\"btn gold wide gp-back\">" + J.str(J.cl(_t68, null, ["返村升級", "回村升級"])) + "</button></div>")

func _f31(this_, a: Array, env):
	var v_e_140 = null
	J.mc(J.G.get("UI"), "openRoster", [])

func _f30(this_, a: Array, env):
	var v_before_135 = null; var v_e_136 = null; var v_e_137 = null; var v_e_138 = null; var v_e_139 = null; var v_e_141 = null
	v_before_135 = J.arg(a, 0)
	if J.t(v_before_135):
		J.cl(v_before_135, null, [])
	var _t69 = env["ok"]
	var _t70 = J.cl(_t69, null, [J.G.get("Street")])
	var _t71 = (J.gp(J.G.get("Street"), "Turf") if J.t(_t70) else _t70)
	if J.t((J.gp(J.gp(J.G.get("Street"), "Turf"), "on") if J.t(_t71) else _t71)):
		J.mc(J.gp(J.G.get("Street"), "Turf"), "close", [])
	var _t72 = env["ok"]
	var _t73 = J.cl(_t72, null, [J.G.get("Street")])
	if J.t((J.gp(J.G.get("Street"), "close") if J.t(_t73) else _t73)):
		J.mc(J.G.get("Street"), "close", [])
	var _t74 = env["ok"]
	var _t75 = J.cl(_t74, null, [J.G.get("World")])
	var _t76 = (J.gp(J.G.get("World"), "close") if J.t(_t75) else _t75)
	if J.t((J.S_document_("querySelector", ["#world.on"]) if J.t(_t76) else _t76)):
		J.mc(J.G.get("World"), "close", [])
	var _t77 = env["ok"]
	if J.t(J.cl(_t77, null, [J.G.get("UI")])):
		J.mc(J.G.get("UI"), "close", [])
		if J.t(J.gp(J.G.get("UI"), "refresh")):
			J.mc(J.G.get("UI"), "refresh", [])
		J.F_setTimeout([Callable(self, "_f31").bind(env), 60.0])

func _f34(this_, a: Array, env):
	var v_e_147 = null
	v_e_147 = J.arg(a, 0)
	J.mc(v_e_147, "stopPropagation", [])
	var _t80 = env["__p"]["goVillage"]
	J.cl(_t80, null, [env["before"]])

func _f33(this_, a: Array, env):
	var v_b_146 = null
	v_b_146 = J.arg(a, 0)
	var _t81 = Callable(self, "_f34").bind(env)
	J.sp(v_b_146, "onclick", _t81)
	return _t81

func _f32(this_, a: Array, env):
	var v_root_144 = null
	var _s79 = {"__p": env, "before": null}
	v_root_144 = J.arg(a, 0)
	_s79["before"] = J.arg(a, 1)
	var _t78 = (v_root_144 if J.t(v_root_144) else J.G.get("document"))
	var _t79 = J.mc(_t78, "querySelectorAll", [".gp-back"])
	J.mc(_t79, "forEach", [Callable(self, "_f33").bind(_s79)])

func _f2(this_, a: Array, env):
	var v_x_31 = null
	v_x_31 = J.arg(a, 0)
	return (not J.seq(J.typeof_(v_x_31), "undefined"))

func _f3(this_, a: Array, env):
	var v_yue_32 = null; var v_zh_33 = null; var v_e_34 = null
	v_yue_32 = J.arg(a, 0)
	v_zh_33 = J.arg(a, 1)
	var _t82 = env["ok"]
	var _t83 = J.cl(_t82, null, [J.G.get("LANG")])
	if J.t((v_zh_33 if J.t(_t83) else _t83)):
		J.mc(J.G.get("LANG"), "add", [{J.key(v_yue_32): v_zh_33}])
	var _t84 = env["ok"]
	var _t86 = null
	if J.t(J.cl(_t84, null, [J.G.get("L")])):
		var _t85 = J.G.get("L")
		_t86 = J.cl(_t85, null, [v_yue_32])
	else:
		_t86 = v_yue_32
	return _t86

func _f1(this_, a: Array, env):
	var v_drillMul_16 = null; var v_kindMul_18 = null; var v_kindPow_19 = null; var v_kindGrow_20 = null; var v_avg_21 = null; var v_top_22 = null; var v_stageNeed_24 = null; var v_turfNeed_25 = null; var v_failHTML_28 = null; var v_bindBack_30 = null
	var _s2 = {"__p": env, "REF": null, "NONE": null, "MIN": null, "MAX": null, "ok": null, "T": null, "drill": null, "stats": null, "base": null, "gearMul": null, "raw": null, "pow": null, "mul": null, "grow": null, "best": null, "STAGE_NEED": null, "tag": null, "hint": null, "goVillage": null}
	_s2["drill"] = Callable(self, "_f4").bind(_s2)
	_s2["stats"] = Callable(self, "_f5").bind(_s2)
	_s2["base"] = Callable(self, "_f8").bind(_s2)
	_s2["gearMul"] = Callable(self, "_f9").bind(_s2)
	_s2["raw"] = Callable(self, "_f10").bind(_s2)
	_s2["pow"] = Callable(self, "_f11").bind(_s2)
	_s2["mul"] = Callable(self, "_f12").bind(_s2)
	_s2["grow"] = Callable(self, "_f13").bind(_s2)
	v_drillMul_16 = Callable(self, "_f14").bind(_s2)
	_s2["best"] = Callable(self, "_f15").bind(_s2)
	v_kindMul_18 = Callable(self, "_f16").bind(_s2)
	v_kindPow_19 = Callable(self, "_f17").bind(_s2)
	v_kindGrow_20 = Callable(self, "_f18").bind(_s2)
	v_avg_21 = Callable(self, "_f19").bind(_s2)
	v_top_22 = Callable(self, "_f21").bind(_s2)
	v_stageNeed_24 = Callable(self, "_f25").bind(_s2)
	v_turfNeed_25 = Callable(self, "_f26").bind(_s2)
	_s2["tag"] = Callable(self, "_f27").bind(_s2)
	_s2["hint"] = Callable(self, "_f28").bind(_s2)
	v_failHTML_28 = Callable(self, "_f29").bind(_s2)
	_s2["goVillage"] = Callable(self, "_f30").bind(_s2)
	v_bindBack_30 = Callable(self, "_f32").bind(_s2)
	_s2["REF"] = 45.0
	_s2["NONE"] = 0.7
	_s2["MIN"] = 0.6
	_s2["MAX"] = 3.2
	_s2["ok"] = Callable(self, "_f2").bind(_s2)
	_s2["T"] = Callable(self, "_f3").bind(_s2)
	_s2["STAGE_NEED"] = {"1-1": 450.0, "1-2": 470.0, "1-3": 500.0, "2-1": 520.0, "2-2": 540.0, "2-3": 560.0, "3-1": 580.0, "3-2": 680.0, "3-3": 920.0, "4-1": 870.0, "4-2": 1070.0, "4-3": 1300.0, "5-1": 870.0, "5-2": 1160.0, "5-3": 1300.0, "6-1": 1500.0, "6-2": 1560.0, "6-3": 1900.0}
	return {"REF": _s2["REF"], "NONE": _s2["NONE"], "pow": _s2["pow"], "mul": _s2["mul"], "best": _s2["best"], "kindMul": v_kindMul_18, "kindPow": v_kindPow_19, "hint": _s2["hint"], "raw": _s2["raw"], "grow": _s2["grow"], "kindGrow": v_kindGrow_20, "drillMul": v_drillMul_16, "avg": v_avg_21, "top": v_top_22, "STAGE_NEED": _s2["STAGE_NEED"], "stageNeed": v_stageNeed_24, "turfNeed": v_turfNeed_25, "tag": _s2["tag"], "failHTML": v_failHTML_28, "goVillage": _s2["goVillage"], "bindBack": v_bindBack_30, "T": _s2["T"]}
