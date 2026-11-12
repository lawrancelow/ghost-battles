# 自動轉譯自 scare_squad.js（tools/jsgd.js）——唔好直接改，改原 JS 再轉
extends RefCounted

func run(env):
	var this_ = null; var a = []
	J.G["ScareX"] = J.cl(Callable(self, "_f1").bind(env), null, [])

func _f14(this_, a: Array, env):
	var v_loc_67 = null; var v_d_68 = null; var v_lv_69 = null
	v_loc_67 = J.arg(a, 0)
	var _t1 = (v_loc_67 if J.t(v_loc_67) else "office")
	v_loc_67 = _t1
	var _t2 = (not J.seq(J.typeof_(J.G.get("S")), "undefined"))
	var _t3 = (J.G.get("S") if _t2 else _t2)
	var _t4 = (J.gp(J.G.get("S"), "legend") if J.t(_t3) else _t3)
	var _t5 = (J.gp(J.gp(J.G.get("S"), "legend"), v_loc_67) if J.t(_t4) else _t4)
	v_d_68 = (_t5 if J.t(_t5) else {"heat": 0.0, "nights": 0.0})
	v_lv_69 = 1.0
	while true:
		var _t6 = J.cmp(v_lv_69, 5.0, "<")
		if not (J.cmp(J.gp(v_d_68, "heat"), J.gp(env["LV"], v_lv_69), ">=") if _t6 else _t6): break
		v_lv_69 = J.num(v_lv_69) + 1.0
	var _t7 = J.gp(v_d_68, "heat")
	var _t9 = (_t7 if J.t(_t7) else 0.0)
	var _t8 = J.gp(v_d_68, "nights")
	var _t11 = (_t8 if J.t(_t8) else 0.0)
	var _t10 = env["Lx"]
	return {"heat": _t9, "lv": v_lv_69, "nights": _t11, "name": J.cl(_t10, null, [J.gp(env["LVNAME"], J.sub(v_lv_69, 1.0))]), "next": (J.gp(env["LV"], v_lv_69) if J.cmp(v_lv_69, 5.0, "<") else null), "prev": J.gp(env["LV"], J.sub(v_lv_69, 1.0))}

func _f17(this_, a: Array, env):
	var v_t_75 = null
	var _t12 = J.bor(J.add(env["a"], 1831565813.0), 0.0)
	env["a"] = _t12
	v_t_75 = J.math("imul", [J.bxor(env["a"], J.ushr(env["a"], 15.0)), J.bor(1.0, env["a"])])
	var _t13 = J.bxor(J.add(v_t_75, J.math("imul", [J.bxor(v_t_75, J.ushr(v_t_75, 7.0)), J.bor(61.0, v_t_75)])), v_t_75)
	v_t_75 = _t13
	return J.div(J.ushr(J.bxor(v_t_75, J.ushr(v_t_75, 14.0)), 0.0), 4294967296.0)

func _f16(this_, a: Array, env):
	var v_seed_73 = null
	var _s21 = {"__p": env, "a": null}
	v_seed_73 = J.arg(a, 0)
	_s21["a"] = J.bor(v_seed_73, 0.0)
	return Callable(self, "_f17").bind(_s21)

func _f18(this_, a: Array, env):
	var v_Sc_78 = null; var v_lg_79 = null; var v_R_80 = null; var v_forced_81 = null; var v_p_82 = null; var v_n_83 = null; var v_d_84 = null; var v_n_85 = null
	v_Sc_78 = J.arg(a, 0)
	var _t14 = env["legend"]
	v_lg_79 = J.cl(_t14, null, [J.gp(v_Sc_78, "siteId")])
	var _t15 = env["rng"]
	v_R_80 = J.cl(_t15, null, [(J.mul(J.gp(v_Sc_78, "seed"), 7.0) + 991.0)])
	var _t16 = {"seen": 0.0, "nb": 0.0, "alone": 0.0, "types": J.new_("Set", []), "tricks": J.new_("Set", []), "inf": 0.0, "infFled": 0.0, "filmed": 0.0, "stole": 0.0, "foiled": 0.0, "bryanOut": 0.0, "per": {}, "best": null, "lv": J.gp(v_lg_79, "lv")}
	J.sp(v_Sc_78, "night", _t16)
	var _t17 = (55.0 if J.cmp(J.gp(v_lg_79, "lv"), 4.0, ">=") else 0.0)
	J.sp(v_Sc_78, "daoAt", _t17)
	var _t18 = (3.0 if J.cmp(J.gp(v_lg_79, "lv"), 4.0, ">=") else 0.0)
	J.sp(v_Sc_78, "daoDelay", _t18)
	if (not J.t(J.gp(J.gp(v_Sc_78, "site"), "pano"))):
		return null
	if J.cmp(J.gp(v_lg_79, "lv"), 2.0, ">="):
		for _t19 in J.iter(J.gp(v_Sc_78, "npcs")):
			v_n_83 = _t19
			if (not J.t(J.gp(J.gp(v_n_83, "d"), "guard"))):
				J.sp(v_n_83, "shaken", 15.0)
				J.sp(v_n_83, "fear", 8.0)
	if J.cmp(J.gp(v_lg_79, "lv"), 3.0, ">="):
		var _t20 = env["KOL"]
		v_d_84 = J.cl(_t20, null, [J.gp(["sound", "shadow", "face", "phone"], floor(J.num(J.mul(J.cl(v_R_80, null, []), 4.0))))])
		v_n_85 = {"d": v_d_84, "x": J.gp(J.gp(v_d_84, "post"), 0.0), "y": J.gp(J.gp(v_d_84, "post"), 1.0), "wi": 0.0, "wait": 6.0, "dir": 1.0, "fear": 0.0, "peak": 0.0, "gone": false, "exitT": 0.0, "bounce": 0.0, "look": 0.0, "bub": null, "bubT": 0.0, "act": "film", "ph": 0.0, "ev": [], "_seed": J.bor((J.mul(J.gp(v_Sc_78, "seed"), 131.0) + 77.0), 0.0)}
		var _t21 = {"x": J.gp(v_n_85, "x"), "y": J.gp(v_n_85, "y"), "wait": 8.0, "act": "film", "arrived": true}
		J.sp(v_n_85, "step", _t21)
		var _t22 = J.gp(v_Sc_78, "npcs")
		J.mc(_t22, "push", [v_n_85])
		var _t24 = (12.0 + J.mul(J.cl(v_R_80, null, []), 15.0))
		var _t23 = env["T"]
		J.mc(v_Sc_78, "goOut", [v_n_85, _t24, false, J.cl(_t23, null, ["大家好！今晚帶大家探二十三樓！", "大家好！今晚帶大家探二十三樓！"]), true])
	v_forced_81 = (J.gp(v_Sc_78, "forceBryan") if (not J.leq(J.gp(v_Sc_78, "forceBryan"), null)) else null)
	v_p_82 = (0.25 + (0.08 * J.sub(J.gp(v_lg_79, "lv"), 1.0)))
	var _t25 = ({"at": (30.0 + J.mul(J.cl(v_R_80, null, []), 30.0)), "st": "wait", "x": 0.0, "y": 0.8, "cd": 4.0, "t": 0.0, "R": v_R_80, "dir": 1.0, "alpha": 0.0} if J.t((v_forced_81 if (not J.leq(v_forced_81, null)) else J.cmp(J.cl(v_R_80, null, []), v_p_82, "<"))) else null)
	J.sp(v_Sc_78, "bryan", _t25)

func _f19(this_, a: Array, env):
	var v_Sc_88 = null; var v_n_89 = null; var v_o_90 = null; var v_N_91 = null; var v_B_92 = null; var v_P_93 = null; var v_m_94 = null
	v_Sc_88 = J.arg(a, 0)
	v_n_89 = J.arg(a, 1)
	v_o_90 = J.arg(a, 2)
	v_N_91 = J.gp(v_Sc_88, "night")
	if (not J.t(v_N_91)):
		return null
	if J.cmp(J.gp(v_o_90, "pts"), 0.0, ">"):
		var _t26 = J.gp(v_N_91, "types")
		J.mc(_t26, "add", [J.gp(v_o_90, "type")])
		var _t27 = J.gp(v_N_91, "tricks")
		J.mc(_t27, "add", [J.gp(v_o_90, "ghost")])
		var _t28 = J.gp(v_N_91, "per")
		var _t29 = J.gp(v_o_90, "ghost")
		var _t30 = J.gp(J.gp(v_N_91, "per"), J.gp(v_o_90, "ghost"))
		var _t31 = (_t30 if J.t(_t30) else {"scares": 0.0, "fear": 0.0})
		J.sp(_t28, _t29, _t31)
		v_P_93 = _t31
		J.sp(v_P_93, "scares", J.num(J.gp(v_P_93, "scares")) + 1.0)
		var _t32 = J.add(J.gp(v_P_93, "fear"), J.gp(v_o_90, "pts"))
		J.sp(v_P_93, "fear", _t32)
	var _t33 = J.gp(v_o_90, "clean")
	if J.t((J.cmp(J.gp(v_o_90, "mk"), 2.0, ">=") if J.t(_t33) else _t33)):
		J.sp(v_N_91, "nb", J.num(J.gp(v_N_91, "nb")) + 1.0)
	var _t34 = J.gp(v_o_90, "clean")
	if J.t((J.gp(v_o_90, "alone") if J.t(_t34) else _t34)):
		J.sp(v_N_91, "alone", J.num(J.gp(v_N_91, "alone")) + 1.0)
	var _t36 = J.cmp(J.gp(v_o_90, "pts"), 0.0, ">")
	if J.t(_t36):
		var _t35 = (not J.t(J.gp(v_N_91, "best")))
		_t36 = (_t35 if _t35 else J.cmp(J.gp(v_n_89, "fear"), J.gp(J.gp(v_N_91, "best"), "fear"), ">"))
	if _t36:
		var _t37 = {"name": J.gp(J.gp(v_n_89, "d"), "name"), "fear": J.gp(v_n_89, "fear"), "ghost": J.gp(v_o_90, "ghost"), "room": (J.gp(J.mc(J.G.get("OFFMAP"), "roomAt", [J.gp(v_n_89, "x")]), "name") if J.t(J.gp(J.gp(v_Sc_88, "site"), "pano")) else "")}
		J.sp(v_N_91, "best", _t37)
	var _t38 = J.gp(J.gp(v_n_89, "d"), "influencer")
	if J.t((J.cmp(J.gp(v_o_90, "pts"), 0.0, ">") if J.t(_t38) else _t38)):
		var _t39 = J.add(J.gp(v_N_91, "inf"), 3.0)
		J.sp(v_N_91, "inf", _t39)
		if J.cmp(J.gp(v_n_89, "fear"), 100.0, ">="):
			J.sp(v_N_91, "infFled", 1.0)
	v_B_92 = J.gp(v_Sc_88, "bryan")
	var _t40 = (J.seq(J.gp(v_B_92, "st"), "stalk") if J.t(v_B_92) else v_B_92)
	var _t41 = (J.seq(J.gp(v_B_92, "tgt"), v_n_89) if J.t(_t40) else _t40)
	if J.t((J.cmp(J.gp(v_o_90, "pts"), 0.0, ">") if J.t(_t41) else _t41)):
		J.sp(v_B_92, "st", "roam")
		J.sp(v_B_92, "cd", 8.0)
		J.sp(v_B_92, "tgt", null)
		J.sp(v_N_91, "foiled", J.num(J.gp(v_N_91, "foiled")) + 1.0)
		var _t42 = J.add(J.gp(v_Sc_88, "kpi"), 10.0)
		J.sp(v_Sc_88, "kpi", _t42)
		var _t45 = J.gp(v_n_89, "x")
		var _t46 = J.sub(J.gp(v_n_89, "y"), 0.3)
		var _t43 = env["Lx"]
		var _t44 = env["T"]
		J.mc(v_Sc_88, "float", [_t45, _t46, J.cl(_t43, null, [J.cl(_t44, null, ["搶先一步！Bryan 冇得搶 +10", "搶先一步！Bryan 搶不到 +10"])]), "#c9a0ff", 1.6])
		if J.t(J.gp(v_Sc_88, "bubble")):
			var _t47 = env["bryanSay"]
			var _t48 = env["T"]
			J.cl(_t47, null, [v_Sc_88, J.cl(_t48, null, ["喂！搶我生意？！", "喂！搶我生意？！"])])
		else:
			pass
	var _t50 = v_B_92
	if J.t(_t50):
		var _t49 = J.seq(J.gp(v_B_92, "st"), "stalk")
		_t50 = (_t49 if _t49 else J.seq(J.gp(v_B_92, "st"), "roam"))
	var _t51 = (J.mc(v_Sc_88, "sameRoom", [v_n_89, v_B_92]) if J.t(_t50) else _t50)
	if J.t(((J.hypot_([J.sub(J.gp(v_n_89, "x"), J.gp(v_B_92, "x")), J.sub(J.gp(v_n_89, "y"), J.gp(v_B_92, "y"))]) < 0.7) if J.t(_t51) else _t51)):
		for _t52 in J.iter(J.gp(v_Sc_88, "npcs")):
			v_m_94 = _t52
			var _t53 = (not J.seq(v_m_94, v_n_89))
			var _t54 = ((not J.t(J.gp(J.gp(v_m_94, "d"), "guard"))) if _t53 else _t53)
			var _t55 = (J.mc(v_Sc_88, "sameRoom", [v_m_94, v_B_92]) if _t54 else _t54)
			var _t56 = ((not J.t(J.gp(v_m_94, "out"))) if J.t(_t55) else _t55)
			if J.t(((not J.t(J.gp(v_m_94, "gone"))) if J.t(_t56) else _t56)):
				var _t57 = J.gp(v_m_94, "lookUp")
				var _t58 = J.gp(v_m_94, "lookUp")
				var _t59 = J.max_([(_t58 if J.t(_t58) else 0.0), 3.0])
				J.sp(v_m_94, "lookUp", _t59)

func _f20(this_, a: Array, env):
	var v_Sc_97 = null; var v_s_98 = null; var v_B_99 = null
	v_Sc_97 = J.arg(a, 0)
	v_s_98 = J.arg(a, 1)
	v_B_99 = J.gp(v_Sc_97, "bryan")
	if (not J.t(v_B_99)):
		return null
	var _t60 = env["Lx"]
	var _t61 = J.cl(_t60, null, [v_s_98])
	J.sp(v_B_99, "say", _t61)
	J.sp(v_B_99, "sayT", 2.4)

func _f22(this_, a: Array, env):
	var v_tx_109 = null; var v_ty_110 = null; var v_sp_111 = null; var v_dx_112 = null; var v_dy_113 = null; var v_d_114 = null
	v_tx_109 = J.arg(a, 0)
	v_ty_110 = J.arg(a, 1)
	v_sp_111 = J.arg(a, 2)
	v_dx_112 = J.sub(v_tx_109, J.gp(env["B"], "x"))
	v_dy_113 = J.sub(v_ty_110, J.gp(env["B"], "y"))
	v_d_114 = J.hypot_([v_dx_112, v_dy_113])
	if J.cmp(v_d_114, J.mul(v_sp_111, env["dt"]), "<"):
		var _t82 = env["B"]
		J.sp(_t82, "x", v_tx_109)
		var _t83 = env["B"]
		J.sp(_t83, "y", v_ty_110)
		return true
	var _t84 = env["B"]
	var _t85 = J.add(J.gp(_t84, "x"), J.mul(J.mul(J.div(v_dx_112, v_d_114), v_sp_111), env["dt"]))
	J.sp(_t84, "x", _t85)
	var _t86 = env["B"]
	var _t87 = J.add(J.gp(_t86, "y"), J.mul(J.mul(J.div(v_dy_113, v_d_114), v_sp_111), env["dt"]))
	J.sp(_t86, "y", _t87)
	var _t88 = env["B"]
	var _t89 = (1.0 if J.cmp(v_dx_112, 0.0, ">=") else (-1.0))
	J.sp(_t88, "dir", _t89)
	return false

func _f23(this_, a: Array, env):
	var v_n_115 = null
	v_n_115 = J.arg(a, 0)
	var _t90 = ((not J.t(J.gp(v_n_115, "gone"))) if J.t(v_n_115) else v_n_115)
	var _t91 = ((not J.t(J.gp(v_n_115, "out"))) if J.t(_t90) else _t90)
	var _t92 = ((not J.t(J.gp(v_n_115, "fleeing"))) if J.t(_t91) else _t91)
	var _t93 = ((not J.t(J.gp(J.gp(v_n_115, "d"), "guard"))) if J.t(_t92) else _t92)
	return ((not J.t(J.gp(J.gp(v_n_115, "d"), "daoshi"))) if J.t(_t93) else _t93)

func _f24(this_, a: Array, env):
	var v_n_118 = null
	v_n_118 = J.arg(a, 0)
	var _t101 = J.add(J.gp(v_n_118, "fear"), (20.0 if J.seq(v_n_118, J.gp(env["__p"]["Sc"], "sel")) else 0.0))
	var _t100 = J.gp(v_n_118, "mocked")
	return J.add(J.add(_t101, J.mul((_t100 if J.t(_t100) else 0.0), 6.0)), J.mul(J.mc(env["__p"]["B"], "R", []), 12.0))

func _f25(this_, a: Array, env):
	var v_a_119 = null; var v_b_120 = null
	v_a_119 = J.arg(a, 0)
	v_b_120 = J.arg(a, 1)
	var _t103 = env["sc"]
	var _t105 = J.cl(_t103, null, [v_b_120])
	var _t104 = env["sc"]
	return J.sub(_t105, J.cl(_t104, null, [v_a_119]))

func _f21(this_, a: Array, env):
	var v_move_105 = null; var v_ok_106 = null; var v_rs_107 = null; var v_r_108 = null; var v_c_116 = null; var v_n_121 = null; var v_arrived_122 = null; var v_n_123 = null
	var _s33 = {"__p": env, "Sc": null, "dt": null, "B": null}
	_s33["Sc"] = J.arg(a, 0)
	_s33["dt"] = J.arg(a, 1)
	_s33["B"] = J.gp(_s33["Sc"], "bryan")
	var _t62 = (not J.t(_s33["B"]))
	if (_t62 if _t62 else J.seq(J.gp(_s33["B"], "st"), "gone")):
		return null
	var _t63 = _s33["B"]
	var _t64 = J.add(J.gp(_t63, "t"), _s33["dt"])
	J.sp(_t63, "t", _t64)
	var _t65 = _s33["B"]
	var _t66 = J.gp(_s33["B"], "sayT")
	var _t67 = J.gp(_s33["B"], "sayT")
	var _t68 = J.max_([0.0, J.sub((_t67 if J.t(_t67) else 0.0), _s33["dt"])])
	J.sp(_t65, "sayT", _t68)
	if J.seq(J.gp(_s33["B"], "st"), "wait"):
		if J.cmp(J.gp(_s33["Sc"], "t"), J.gp(_s33["B"], "at"), "<"):
			return null
		v_rs_107 = J.gp(J.G.get("OFFMAP"), "ROOMS")
		v_r_108 = J.gp(v_rs_107, floor(J.num(J.mul(J.mc(_s33["B"], "R", []), J.len(v_rs_107)))))
		var _t69 = _s33["B"]
		var _t70 = J.gp(v_r_108, "cx")
		J.sp(_t69, "x", _t70)
		var _t71 = _s33["B"]
		J.sp(_t71, "y", 0.8)
		var _t72 = _s33["B"]
		J.sp(_t72, "st", "roam")
		var _t73 = _s33["B"]
		J.sp(_t73, "cd", 5.0)
		var _t74 = _s33["B"]
		J.sp(_t74, "alpha", 0.0)
		var _t75 = _s33["__p"]["Lx"]
		var _t76 = _s33["__p"]["T"]
		J.mc(_s33["Sc"], "float", [0.5, 0.3, J.cl(_t75, null, [J.cl(_t76, null, ["死對頭 Bryan 都嚟咗，佢要搶你嘅 KPI！", "死對頭 Bryan 也來了，他要搶你的 KPI！"])]), "#c9a0ff", 2.4])
		var _t77 = _s33["__p"]["bryanSay"]
		var _t79 = _s33["Sc"]
		var _t78 = _s33["__p"]["T"]
		J.cl(_t77, null, [_t79, J.cl(_t78, null, ["今晚呢層樓係我嘅！", "今晚這層樓是我的！"])])
		return null
	var _t80 = _s33["B"]
	var _t81 = J.min_([0.85, J.add(J.gp(_s33["B"], "alpha"), J.mul(_s33["dt"], 1.5))])
	J.sp(_t80, "alpha", _t81)
	v_move_105 = Callable(self, "_f22").bind(_s33)
	v_ok_106 = Callable(self, "_f23").bind(_s33)
	if J.seq(J.gp(_s33["B"], "st"), "roam"):
		var _t94 = _s33["B"]
		var _t95 = J.sub(J.gp(_t94, "cd"), _s33["dt"])
		J.sp(_t94, "cd", _t95)
		var _t96 = (not J.t(J.gp(_s33["B"], "wp")))
		if J.t((_t96 if _t96 else J.cl(v_move_105, null, [J.gp(J.gp(_s33["B"], "wp"), 0.0), J.gp(J.gp(_s33["B"], "wp"), 1.0), 0.08]))):
			var _t97 = _s33["B"]
			var _t98 = [J.max_([0.15, J.min_([J.sub(J.gp(J.G.get("OFFMAP"), "WW"), 0.15), J.add(J.gp(_s33["B"], "x"), (J.sub(J.mc(_s33["B"], "R", []), 0.5) * 0.6))])]), (0.7 + J.mul(J.mc(_s33["B"], "R", []), 0.2))]
			J.sp(_t97, "wp", _t98)
		if J.cmp(J.gp(_s33["B"], "cd"), 0.0, "<="):
			var _t99 = J.gp(_s33["Sc"], "npcs")
			v_c_116 = J.mc(_t99, "filter", [v_ok_106])
			if J.t(J.len(v_c_116)):
				var _s40 = {"__p": _s33, "sc": null}
				_s40["sc"] = Callable(self, "_f24").bind(_s40)
				var _t102 = _s40["__p"]["B"]
				var _t106 = J.gp(J.mc(v_c_116, "sort", [Callable(self, "_f25").bind(_s40)]), 0.0)
				J.sp(_t102, "tgt", _t106)
				var _t107 = _s40["__p"]["B"]
				J.sp(_t107, "st", "stalk")
				var _t108 = _s40["__p"]["B"]
				J.sp(_t108, "t", 0.0)
				var _t109 = _s40["__p"]["B"]
				var _t110 = ((-1.0) if J.cmp(J.mc(_s40["__p"]["B"], "R", []), 0.5, "<") else 1.0)
				J.sp(_t109, "side", _t110)
			else:
				var _t111 = _s33["B"]
				J.sp(_t111, "cd", 4.0)
		return null
	if J.seq(J.gp(_s33["B"], "st"), "stalk"):
		v_n_121 = J.gp(_s33["B"], "tgt")
		if (not J.t(J.cl(v_ok_106, null, [v_n_121]))):
			var _t112 = _s33["B"]
			J.sp(_t112, "st", "roam")
			var _t113 = _s33["B"]
			J.sp(_t113, "cd", 3.0)
			return null
		v_arrived_122 = J.cl(v_move_105, null, [J.add(J.gp(v_n_121, "x"), J.mul(J.gp(_s33["B"], "side"), 0.15)), J.sub(J.gp(v_n_121, "y"), 0.01), 0.16])
		if J.t((J.cmp(J.gp(_s33["B"], "t"), 4.0, ">") if J.t(v_arrived_122) else v_arrived_122)):
			var _t114 = _s33["B"]
			J.sp(_t114, "st", "strike")
			var _t115 = _s33["B"]
			J.sp(_t115, "t", 0.0)
		return null
	if J.seq(J.gp(_s33["B"], "st"), "strike"):
		v_n_123 = J.gp(_s33["B"], "tgt")
		if J.cmp(J.gp(_s33["B"], "t"), 0.5, "<"):
			return null
		if (not J.t(J.gp(_s33["B"], "done"))):
			var _t116 = _s33["B"]
			J.sp(_t116, "done", true)
			var _t117 = _s33["__p"]["resolve"]
			J.cl(_t117, null, [_s33["Sc"], _s33["B"], v_n_123])
		if J.cmp(J.gp(_s33["B"], "t"), 1.1, ">"):
			var _t118 = _s33["B"]
			J.sp(_t118, "done", false)
			if J.seq(J.gp(_s33["B"], "st"), "strike"):
				var _t119 = _s33["B"]
				J.sp(_t119, "st", "roam")
				var _t120 = _s33["B"]
				var _t121 = (14.0 + J.mul(J.mc(_s33["B"], "R", []), 6.0))
				J.sp(_t120, "cd", _t121)
				var _t122 = _s33["B"]
				J.sp(_t122, "tgt", null)
		return null
	if J.seq(J.gp(_s33["B"], "st"), "flee"):
		var _t123 = _s33["B"]
		var _t124 = J.max_([0.0, J.sub(J.gp(_s33["B"], "alpha"), J.mul(_s33["dt"], 0.8))])
		J.sp(_t123, "alpha", _t124)
		J.cl(v_move_105, null, [J.add(J.gp(_s33["B"], "x"), J.mul(J.gp(_s33["B"], "dir"), 2.0)), J.gp(_s33["B"], "y"), 0.4])
		if J.cmp(J.gp(_s33["B"], "alpha"), 0.0, "<="):
			var _t125 = _s33["B"]
			J.sp(_t125, "st", "gone")

func _f27(this_, a: Array, env):
	var v_m_130 = null
	v_m_130 = J.arg(a, 0)
	var _t130 = (not J.seq(v_m_130, env["n"]))
	var _t131 = ((not J.t(J.gp(J.gp(v_m_130, "d"), "daoshi"))) if _t130 else _t130)
	return (J.mc(env["Sc"], "sees", [v_m_130, {"x": J.gp(env["B"], "x"), "y": J.gp(env["B"], "y")}]) if _t131 else _t131)

func _f28(this_, a: Array, env):
	var v_w_131 = null
	v_w_131 = J.arg(a, 0)
	return J.gp(J.gp(v_w_131, "d"), "name")

func _f26(this_, a: Array, env):
	var v_wits_129 = null; var v_w_132 = null
	var _s51 = {"__p": env, "Sc": null, "B": null, "n": null}
	_s51["Sc"] = J.arg(a, 0)
	_s51["B"] = J.arg(a, 1)
	_s51["n"] = J.arg(a, 2)
	var _t126 = (not J.t(_s51["n"]))
	var _t127 = (_t126 if _t126 else J.gp(_s51["n"], "gone"))
	var _t128 = (_t127 if J.t(_t127) else J.gp(_s51["n"], "out"))
	if J.t((_t128 if J.t(_t128) else J.gp(_s51["n"], "fleeing"))):
		return null
	var _t129 = J.gp(_s51["Sc"], "npcs")
	v_wits_129 = J.mc(_t129, "filter", [Callable(self, "_f27").bind(_s51)])
	if J.t(J.len(v_wits_129)):
		var _t132 = _s51["B"]
		J.sp(_t132, "st", "flee")
		var _t133 = _s51["B"]
		var _t134 = ((-1.0) if J.cmp(J.gp(_s51["B"], "x"), J.div(J.gp(J.G.get("OFFMAP"), "WW"), 2.0), "<") else 1.0)
		J.sp(_t133, "dir", _t134)
		var _t135 = J.gp(_s51["Sc"], "night")
		J.sp(_t135, "bryanOut", 1.0)
		var _t136 = _s51["Sc"]
		var _t137 = J.add(J.gp(_t136, "kpi"), 40.0)
		J.sp(_t136, "kpi", _t137)
		var _t142 = J.gp(_s51["B"], "x")
		var _t143 = J.sub(J.gp(_s51["B"], "y"), 0.3)
		var _t138 = _s51["__p"]["Lf"]
		var _t139 = _s51["__p"]["T"]
		var _t141 = J.cl(_t139, null, ["Bryan 穿崩！俾{n}望到，走佬 +40", "Bryan 穿幫！被{n}看到，溜了 +40"])
		var _t140 = J.mc(v_wits_129, "map", [Callable(self, "_f28").bind(_s51)])
		J.mc(_s51["Sc"], "float", [_t142, _t143, J.cl(_t138, null, [_t141, {"n": J.mc(_t140, "join", ["、"])}]), "#c9a0ff", 2.2])
		var _t144 = _s51["__p"]["bryanSay"]
		var _t146 = _s51["Sc"]
		var _t145 = _s51["__p"]["T"]
		J.cl(_t144, null, [_t146, J.cl(_t145, null, ["衰咗……走先！", "糟了……先走！"])])
		for _t147 in J.iter(v_wits_129):
			v_w_132 = _t147
			if (not J.t(J.gp(J.gp(v_w_132, "d"), "guard"))):
				var _t148 = J.min_([99.0, J.add(J.gp(v_w_132, "fear"), 10.0)])
				J.sp(v_w_132, "fear", _t148)
				var _t149 = J.max_([J.gp(v_w_132, "peak"), J.gp(v_w_132, "fear")])
				J.sp(v_w_132, "peak", _t149)
				var _t150 = _s51["__p"]["Lx"]
				var _t151 = _s51["__p"]["T"]
				J.mc(_s51["Sc"], "bubble", [v_w_132, J.cl(_t150, null, [J.cl(_t151, null, ["頭先……個著波衫嘅係邊個？！", "剛才……那個穿球衣的是誰？！"])]), 2.2])
		return null
	if J.cmp(J.gp(_s51["n"], "fear"), 40.0, ">="):
		var _t152 = _s51["n"]
		var _t153 = J.add(J.gp(_t152, "fear"), 45.0)
		J.sp(_t152, "fear", _t153)
		var _t154 = _s51["n"]
		var _t155 = J.max_([J.gp(_s51["n"], "peak"), J.min_([100.0, J.gp(_s51["n"], "fear")])])
		J.sp(_t154, "peak", _t155)
		var _t156 = _s51["n"]
		J.sp(_t156, "mocked", 0.0)
		var _t157 = _s51["n"]
		J.sp(_t157, "combo", 0.0)
		var _t158 = J.gp(_s51["Sc"], "night")
		J.sp(_t158, "stole", J.num(J.gp(_t158, "stole")) + 1.0)
		var _t161 = J.gp(_s51["n"], "x")
		var _t162 = J.sub(J.gp(_s51["n"], "y"), 0.3)
		var _t159 = _s51["__p"]["Lx"]
		var _t160 = _s51["__p"]["T"]
		J.mc(_s51["Sc"], "float", [_t161, _t162, J.cl(_t159, null, [J.cl(_t160, null, ["Bryan 搶咗你嘅爆點！", "Bryan 搶走了你的爆點！"])]), "#ff8ad0", 2.2])
		var _t163 = _s51["__p"]["bryanSay"]
		var _t165 = _s51["Sc"]
		var _t164 = _s51["__p"]["T"]
		J.cl(_t163, null, [_t165, J.cl(_t164, null, ["多謝晒你幫我鋪墊！", "多謝你幫我鋪墊！"])])
		if (not J.t(J.gp(_s51["Sc"], "headless"))):
			J.mc(_s51["Sc"], "react", [_s51["n"], "burst", {"src": J.gp(_s51["B"], "x")}])
		var _t168 = _s51["n"]
		var _t166 = _s51["__p"]["Lx"]
		var _t167 = _s51["__p"]["T"]
		J.mc(_s51["Sc"], "bubble", [_t168, J.cl(_t166, null, [J.cl(_t167, null, ["呀——！", "啊——！"])]), 1.8])
		if J.cmp(J.gp(_s51["n"], "fear"), 100.0, ">="):
			var _t169 = _s51["n"]
			J.sp(_t169, "fleeing", true)
			if (not J.t(J.gp(_s51["Sc"], "headless"))):
				var _t170 = _s51["n"]
				var _t171 = J.gp(_s51["Sc"], "t")
				J.sp(_t170, "fleeT", _t171)
				var _t172 = _s51["n"]
				J.sp(_t172, "fleeHold", 0.4)
				var _t173 = _s51["n"]
				var _t174 = [[J.gp(_s51["Sc"], "t"), J.gp(_s51["n"], "x"), J.gp(_s51["n"], "y")]]
				J.sp(_t173, "trail", _t174)
	else:
		var _t175 = _s51["n"]
		var _t176 = J.min_([60.0, J.add(J.gp(_s51["n"], "fear"), 15.0)])
		J.sp(_t175, "fear", _t176)
		var _t177 = _s51["n"]
		var _t178 = J.max_([J.gp(_s51["n"], "peak"), J.gp(_s51["n"], "fear")])
		J.sp(_t177, "peak", _t178)
		if (not J.t(J.gp(_s51["Sc"], "headless"))):
			J.mc(_s51["Sc"], "react", [_s51["n"], "flinch", {"src": J.gp(_s51["B"], "x")}])
		var _t179 = _s51["__p"]["bryanSay"]
		var _t181 = _s51["Sc"]
		var _t180 = _s51["__p"]["T"]
		J.cl(_t179, null, [_t181, J.cl(_t180, null, ["暖下身先。", "先熱熱身。"])])

func _f29(this_, a: Array, env):
	var v_Sc_135 = null; var v_ctx_136 = null; var v_t_137 = null; var v_B_138 = null; var v_x_139 = null; var v_y_140 = null; var v_hh_141 = null; var v_fl_142 = null; var v_st_143 = null; var v_lab_144 = null; var v_ty_145 = null; var v_n_146 = null; var v_x_147 = null; var v_y_148 = null; var v_hh_149 = null; var v_s_150 = null; var v_px_151 = null; var v_py_152 = null; var v_g_153 = null; var v_tx_154 = null; var v_ty_155 = null; var v_hh_156 = null; var v_e_157 = null; var v_w_158 = null; var v_bx_159 = null
	v_Sc_135 = J.arg(a, 0)
	v_ctx_136 = J.arg(a, 1)
	v_t_137 = J.arg(a, 2)
	for _t182 in J.iter(J.gp(v_Sc_135, "npcs")):
		v_n_146 = _t182
		var _t183 = J.gp(J.gp(v_n_146, "d"), "influencer")
		var _t184 = ((not J.t(J.gp(v_n_146, "gone"))) if J.t(_t183) else _t183)
		var _t185 = ((not J.t(J.gp(v_n_146, "out"))) if J.t(_t184) else _t184)
		if J.t((J.mc(v_Sc_135, "onScreen", [J.gp(v_n_146, "x"), 0.2]) if J.t(_t185) else _t185)):
			var _t186 = J.mc(v_Sc_135, "pt", [(J.gp(v_n_146, "vX") if (not J.leq(J.gp(v_n_146, "vX"), null)) else J.gp(v_n_146, "x")), J.gp(v_n_146, "y")])
			var _t187 = J.gp(_t186, 0.0)
			v_x_147 = _t187
			var _t188 = J.gp(_t186, 1.0)
			v_y_148 = _t188
			v_hh_149 = J.mc(v_Sc_135, "hh", [J.gp(v_n_146, "y")])
			var _t189 = J.gp(v_n_146, "dir")
			v_s_150 = (_t189 if J.t(_t189) else 1.0)
			v_px_151 = J.add(v_x_147, (J.mul(v_s_150, v_hh_149) * 0.2))
			v_py_152 = J.sub(v_y_148, J.mul(v_hh_149, 0.72))
			J.mc(v_ctx_136, "save", [])
			J.sp(v_ctx_136, "strokeStyle", "rgba(40,40,50,.9)")
			J.sp(v_ctx_136, "lineWidth", 3.0)
			J.mc(v_ctx_136, "beginPath", [])
			J.mc(v_ctx_136, "moveTo", [J.add(v_x_147, (J.mul(v_s_150, v_hh_149) * 0.08)), J.sub(v_y_148, J.mul(v_hh_149, 0.5))])
			J.mc(v_ctx_136, "lineTo", [v_px_151, v_py_152])
			J.mc(v_ctx_136, "stroke", [])
			J.sp(v_ctx_136, "fillStyle", "#222")
			J.mc(v_ctx_136, "fillRect", [J.sub(v_px_151, J.mul(v_hh_149, 0.035)), J.sub(v_py_152, J.mul(v_hh_149, 0.06)), J.mul(v_hh_149, 0.07), J.mul(v_hh_149, 0.11)])
			J.sp(v_ctx_136, "globalCompositeOperation", "lighter")
			var _t190 = ("rgba(255,250,230," + J.str((0.7 + (0.2 * sin(J.num(J.mul(v_t_137, 3.0)))))) + ")")
			J.sp(v_ctx_136, "strokeStyle", _t190)
			J.sp(v_ctx_136, "lineWidth", 2.5)
			J.mc(v_ctx_136, "beginPath", [])
			J.mc(v_ctx_136, "arc", [v_px_151, v_py_152, J.mul(v_hh_149, 0.085), 0.0, (PI * 2.0)])
			J.mc(v_ctx_136, "stroke", [])
			v_g_153 = J.mc(v_ctx_136, "createRadialGradient", [v_px_151, v_py_152, 0.0, v_px_151, v_py_152, J.mul(v_hh_149, 0.5)])
			J.mc(v_g_153, "addColorStop", [0.0, "rgba(255,250,230,.22)"])
			J.mc(v_g_153, "addColorStop", [1.0, "rgba(255,250,230,0)"])
			J.sp(v_ctx_136, "fillStyle", v_g_153)
			J.mc(v_ctx_136, "beginPath", [])
			J.mc(v_ctx_136, "arc", [v_px_151, v_py_152, J.mul(v_hh_149, 0.5), 0.0, (PI * 2.0)])
			J.mc(v_ctx_136, "fill", [])
			if (sin(J.num(J.mul(v_t_137, 2.0))) > 0.0):
				J.sp(v_ctx_136, "globalCompositeOperation", "source-over")
				J.sp(v_ctx_136, "fillStyle", "#ff3a3a")
				J.mc(v_ctx_136, "beginPath", [])
				J.mc(v_ctx_136, "arc", [J.add(v_px_151, (J.mul(v_s_150, v_hh_149) * 0.05)), J.sub(v_py_152, J.mul(v_hh_149, 0.09)), 3.0, 0.0, (PI * 2.0)])
				J.mc(v_ctx_136, "fill", [])
				J.sp(v_ctx_136, "font", "800 9px sans-serif")
				J.mc(v_ctx_136, "fillText", ["LIVE", J.sub(J.add(v_px_151, (J.mul(v_s_150, v_hh_149) * 0.07)), 4.0), J.sub(v_py_152, J.mul(v_hh_149, 0.07))])
			J.mc(v_ctx_136, "restore", [])
	v_B_138 = J.gp(v_Sc_135, "bryan")
	var _t191 = (not J.t(v_B_138))
	var _t192 = (_t191 if _t191 else J.seq(J.gp(v_B_138, "st"), "wait"))
	var _t193 = (_t192 if _t192 else J.seq(J.gp(v_B_138, "st"), "gone"))
	if (_t193 if _t193 else J.seq(J.typeof_(J.G.get("Antag")), "undefined")):
		return null
	var _t194 = J.seq(J.gp(v_B_138, "st"), "stalk")
	var _t195 = (J.gp(v_B_138, "tgt") if _t194 else _t194)
	var _t196 = ((not J.t(J.gp(J.gp(v_B_138, "tgt"), "gone"))) if J.t(_t195) else _t195)
	if J.t((J.mc(v_Sc_135, "onScreen", [J.gp(J.gp(v_B_138, "tgt"), "x"), 0.1]) if J.t(_t196) else _t196)):
		var _t197 = J.mc(v_Sc_135, "pt", [(J.gp(J.gp(v_B_138, "tgt"), "vX") if (not J.leq(J.gp(J.gp(v_B_138, "tgt"), "vX"), null)) else J.gp(J.gp(v_B_138, "tgt"), "x")), J.gp(J.gp(v_B_138, "tgt"), "y")])
		var _t198 = J.gp(_t197, 0.0)
		v_tx_154 = _t198
		var _t199 = J.gp(_t197, 1.0)
		v_ty_155 = _t199
		v_hh_156 = J.mc(v_Sc_135, "hh", [J.gp(J.gp(v_B_138, "tgt"), "y")])
		J.mc(v_ctx_136, "save", [])
		var _t200 = ("rgba(210,140,255," + J.str((0.5 + (0.3 * sin(J.num(J.mul(v_t_137, 6.0)))))) + ")")
		J.sp(v_ctx_136, "strokeStyle", _t200)
		J.sp(v_ctx_136, "lineWidth", 2.0)
		J.mc(v_ctx_136, "setLineDash", [[5.0, 4.0]])
		J.mc(v_ctx_136, "beginPath", [])
		J.mc(v_ctx_136, "ellipse", [v_tx_154, v_ty_155, J.mul(v_hh_156, 0.3), J.mul(v_hh_156, 0.08), 0.0, 0.0, (PI * 2.0)])
		J.mc(v_ctx_136, "stroke", [])
		J.mc(v_ctx_136, "restore", [])
	if (not J.t(J.mc(v_Sc_135, "onScreen", [J.gp(v_B_138, "x"), 0.3]))):
		return null
	var _t201 = J.mc(v_Sc_135, "pt", [J.gp(v_B_138, "x"), J.gp(v_B_138, "y")])
	var _t202 = J.gp(_t201, 0.0)
	v_x_139 = _t202
	var _t203 = J.gp(_t201, 1.0)
	v_y_140 = _t203
	v_hh_141 = J.mc(v_Sc_135, "hh", [J.gp(v_B_138, "y")])
	v_fl_142 = ((J.mul(sin(J.num(J.mul(v_t_137, 2.2))), v_hh_141) * 0.025) - J.mul(v_hh_141, 0.04))
	v_st_143 = (("attack" if J.cmp(J.gp(v_B_138, "t"), 0.6, "<") else "jumpshot") if J.seq(J.gp(v_B_138, "st"), "strike") else ("walk" if J.seq(J.gp(v_B_138, "st"), "stalk") else ("scared" if J.seq(J.gp(v_B_138, "st"), "flee") else ("spin" if J.t(J.mod(floor(J.num(J.div(v_t_137, 4.0))), 2.0)) else "dribble"))))
	J.mc(v_ctx_136, "save", [])
	var _t204 = J.gp(v_B_138, "alpha")
	J.sp(v_ctx_136, "globalAlpha", _t204)
	J.sp(v_ctx_136, "fillStyle", "rgba(120,60,180,.25)")
	J.mc(v_ctx_136, "beginPath", [])
	J.mc(v_ctx_136, "ellipse", [v_x_139, v_y_140, J.mul(v_hh_141, 0.2), J.mul(v_hh_141, 0.05), 0.0, 0.0, (PI * 2.0)])
	J.mc(v_ctx_136, "fill", [])
	J.mc(J.G.get("Antag"), "draw", [v_ctx_136, "npc_rival", v_x_139, J.add(v_y_140, v_fl_142), J.mul(v_hh_141, 0.93), v_st_143, (J.gp(v_B_138, "t") if J.seq(J.gp(v_B_138, "st"), "strike") else v_t_137), {"faceRight": J.cmp(J.gp(v_B_138, "dir"), 0.0, ">"), "alpha": J.gp(v_B_138, "alpha"), "shadow": false, "time": v_t_137}])
	J.mc(v_ctx_136, "restore", [])
	J.mc(v_ctx_136, "save", [])
	J.sp(v_ctx_136, "font", "800 11px sans-serif")
	J.sp(v_ctx_136, "textAlign", "center")
	J.sp(v_ctx_136, "lineWidth", 3.0)
	J.sp(v_ctx_136, "strokeStyle", "rgba(0,0,0,.8)")
	var _t205 = env["Lx"]
	var _t206 = env["T"]
	v_lab_144 = J.cl(_t205, null, [J.cl(_t206, null, ["Bryan（死對頭）", "Bryan（死對頭）"])])
	v_ty_145 = J.add(J.sub(v_y_140, J.mul(v_hh_141, 1.02)), v_fl_142)
	J.mc(v_ctx_136, "strokeText", [v_lab_144, v_x_139, v_ty_145])
	J.sp(v_ctx_136, "fillStyle", "#d6a8ff")
	J.mc(v_ctx_136, "fillText", [v_lab_144, v_x_139, v_ty_145])
	var _t207 = J.cmp(J.gp(v_B_138, "sayT"), 0.0, ">")
	if J.t((J.gp(v_B_138, "say") if _t207 else _t207)):
		J.sp(v_ctx_136, "font", "700 12px sans-serif")
		v_w_158 = J.add(J.gp(J.mc(v_ctx_136, "measureText", [J.gp(v_B_138, "say")]), "width"), 16.0)
		v_bx_159 = J.max_([4.0, J.min_([(J.sub(J.gp(v_Sc_135, "W"), v_w_158) - 4.0), J.sub(v_x_139, J.div(v_w_158, 2.0))])])
		J.sp(v_ctx_136, "fillStyle", "rgba(50,20,70,.92)")
		J.sp(v_ctx_136, "strokeStyle", "#b48ad8")
		J.sp(v_ctx_136, "lineWidth", 1.5)
		J.mc(v_ctx_136, "beginPath", [])
		J.mc(v_ctx_136, "roundRect", [v_bx_159, J.sub(v_ty_145, 38.0), v_w_158, 24.0, 9.0])
		J.mc(v_ctx_136, "fill", [])
		J.mc(v_ctx_136, "stroke", [])
		J.sp(v_ctx_136, "fillStyle", "#f0e0ff")
		J.sp(v_ctx_136, "textAlign", "left")
		J.mc(v_ctx_136, "fillText", [J.gp(v_B_138, "say"), J.add(v_bx_159, 8.0), J.sub(v_ty_145, 21.0)])
	J.mc(v_ctx_136, "restore", [])

func _f31(this_, a: Array, env):
	var v_i_179 = null; var v_v_180 = null
	v_i_179 = J.arg(a, 0)
	v_v_180 = (sin(J.num((J.mul(v_i_179, 127.1) + 311.7))) * 43758.5)
	return J.sub(v_v_180, floor(J.num(v_v_180)))

func _f32(this_, a: Array, env):
	var v_s_181 = null; var v_xx_182 = null; var v_yy_183 = null; var v_sz_184 = null; var v_a_185 = null; var v_c_186 = null
	v_s_181 = J.arg(a, 0)
	v_xx_182 = J.arg(a, 1)
	v_yy_183 = J.arg(a, 2)
	v_sz_184 = J.arg(a, 3)
	v_a_185 = J.arg(a, 4)
	v_c_186 = J.arg(a, 5)
	J.mc(env["ctx"], "save", [])
	var _t214 = env["ctx"]
	var _t215 = J.mul(J.gp(_t214, "globalAlpha"), v_a_185)
	J.sp(_t214, "globalAlpha", _t215)
	var _t216 = env["ctx"]
	var _t217 = ("900 " + J.str(J.round(J.num(v_sz_184))) + "px sans-serif")
	J.sp(_t216, "font", _t217)
	var _t218 = env["ctx"]
	J.sp(_t218, "textAlign", "center")
	var _t219 = env["ctx"]
	J.sp(_t219, "lineWidth", 3.0)
	var _t220 = env["ctx"]
	J.sp(_t220, "strokeStyle", "#1a1020")
	J.mc(env["ctx"], "strokeText", [v_s_181, v_xx_182, v_yy_183])
	var _t221 = env["ctx"]
	var _t222 = (v_c_186 if J.t(v_c_186) else "#fff3d0")
	J.sp(_t221, "fillStyle", _t222)
	J.mc(env["ctx"], "fillText", [v_s_181, v_xx_182, v_yy_183])
	J.mc(env["ctx"], "restore", [])

func _f30(this_, a: Array, env):
	var v_Sc_162 = null; var v_f_164 = null; var v_t_165 = null; var v_k_166 = null; var v_n_167 = null; var v_vx_168 = null; var v_x_169 = null; var v_y_170 = null; var v_hh_171 = null; var v_hx_172 = null; var v_hy_173 = null; var v_col_174 = null; var v_e_175 = null; var v_PI_176 = null; var v_R_177 = null; var v_txt_178 = null; var v_i_187 = null; var v_a_188 = null; var v_r_189 = null; var v_cx_190 = null; var v_cy_191 = null; var v_j_192 = null; var v_b_193 = null; var v_w_194 = null; var v_h_195 = null; var v_bx_196 = null; var v_by_197 = null; var v_pc_198 = null; var v_i_199 = null; var v_q_200 = null; var v_px_201 = null; var v_py_202 = null; var v_w_203 = null; var v_h_204 = null; var v_bx_205 = null; var v_by_206 = null; var v_bl_207 = null; var v_g_208 = null; var v_i_209 = null; var v_a_210 = null; var v_L0_211 = null; var v_px_212 = null; var v_py_213 = null; var v_j_214 = null; var v_sx_215 = null; var v_sy_216 = null; var v_op_217 = null; var v_s_218 = null; var v_i_219 = null; var v_q_220 = null; var v_i_221 = null; var v_q_222 = null; var v_dx_223 = null; var v_i_224 = null; var v_q_225 = null; var v_i_226 = null; var v_q_227 = null; var v_px_228 = null; var v_py_229 = null; var v_r_230 = null; var v_g_231 = null; var v_sx_232 = null; var v_H_233 = null; var v_i_234 = null; var v_q_235 = null; var v_px_236 = null; var v_py_237 = null; var v_L1_238 = null; var v_vy_239 = null; var v_i_240 = null; var v_sx_241 = null; var v_i_242 = null; var v_px_243 = null; var v_py_244 = null; var v_q_245 = null; var v_on_246 = null; var v_g_247 = null; var v_pc_248 = null; var v_sz_249 = null; var v_i_250 = null; var v_q_251 = null; var v_px_252 = null; var v_px_253 = null; var v_py_254 = null; var v_sh_255 = null; var v_i_256 = null; var v_i_257 = null; var v_q_258 = null; var v_s_259 = null; var v_i_260 = null; var v_q_261 = null; var v_px_262 = null; var v_py_263 = null; var v_j_264 = null; var v_g_265 = null
	var _s70 = {"__p": env, "ctx": null}
	v_Sc_162 = J.arg(a, 0)
	_s70["ctx"] = J.arg(a, 1)
	v_f_164 = J.arg(a, 2)
	v_t_165 = J.arg(a, 3)
	v_k_166 = J.arg(a, 4)
	v_n_167 = J.gp(v_f_164, "n")
	var _t208 = (not J.t(v_n_167))
	if J.t((_t208 if _t208 else J.gp(v_n_167, "gone"))):
		return null
	v_vx_168 = (J.gp(v_n_167, "vX") if (not J.leq(J.gp(v_n_167, "vX"), null)) else J.gp(v_n_167, "x"))
	var _t209 = J.gp(J.gp(v_Sc_162, "site"), "pano")
	if J.t(((not J.t(J.mc(v_Sc_162, "onScreen", [v_vx_168, 0.2]))) if J.t(_t209) else _t209)):
		return null
	var _t210 = J.mc(v_Sc_162, "pt", [v_vx_168, J.gp(v_n_167, "y")])
	var _t211 = J.gp(_t210, 0.0)
	v_x_169 = _t211
	var _t212 = J.gp(_t210, 1.0)
	v_y_170 = _t212
	v_hh_171 = J.mc(v_Sc_162, "hh", [J.gp(v_n_167, "y")])
	v_hx_172 = v_x_169
	v_hy_173 = J.sub(v_y_170, J.mul(v_hh_171, 0.8))
	var _t213 = J.gp(v_f_164, "col")
	v_col_174 = (_t213 if J.t(_t213) else "#fff")
	v_e_175 = J.min_([1.0, J.mul(v_k_166, 5.0), (J.sub(1.0, v_k_166) * 4.0)])
	v_PI_176 = PI
	v_R_177 = Callable(self, "_f31").bind(_s70)
	v_txt_178 = Callable(self, "_f32").bind(_s70)
	J.mc(_s70["ctx"], "save", [])
	var _t223 = _s70["ctx"]
	J.sp(_t223, "globalAlpha", v_e_175)
	var _t224 = _s70["ctx"]
	J.sp(_t224, "lineCap", "round")
	var _t225 = J.gp(v_f_164, "sig")
	var _t226 = -1
	var _t227 = false
	if _t226 == -1 and J.seq(_t225, "frost"): _t226 = 0
	if _t226 == -1 and J.seq(_t225, "copier"): _t226 = 1
	if _t226 == -1 and J.seq(_t225, "pop"): _t226 = 2
	if _t226 == -1 and J.seq(_t225, "screen"): _t226 = 3
	if _t226 == -1 and J.seq(_t225, "spark"): _t226 = 4
	if _t226 == -1 and J.seq(_t225, "snip"): _t226 = 5
	if _t226 == -1 and J.seq(_t225, "drip"): _t226 = 6
	if _t226 == -1 and J.seq(_t225, "laugh"): _t226 = 7
	if _t226 == -1 and J.seq(_t225, "smoke"): _t226 = 8
	if _t226 == -1 and J.seq(_t225, "shadow"): _t226 = 9
	if _t226 == -1 and J.seq(_t225, "coins"): _t226 = 10
	if _t226 == -1 and J.seq(_t225, "hair"): _t226 = 11
	if _t226 == -1 and J.seq(_t225, "veil"): _t226 = 12
	if _t226 == -1 and J.seq(_t225, "tongue"): _t226 = 13
	if _t226 == -1 and J.seq(_t225, "bones"): _t226 = 14
	if _t226 == -1 and J.seq(_t225, "thump"): _t226 = 15
	if _t226 == -1 and J.seq(_t225, "flash"): _t226 = 16
	if _t226 == -1 and J.seq(_t225, "heat"): _t226 = 17
	if _t226 == -1 and J.seq(_t225, "phone"): _t226 = 18
	if _t226 == -1 and J.seq(_t225, "whisper"): _t226 = 19
	if _t226 == -1 and J.seq(_t225, "scream"): _t226 = 20
	if _t226 == -1 and J.seq(_t225, "prints"): _t226 = 21
	if _t226 == -1 and J.seq(_t225, "dark"): _t226 = 22
	while true:
		if _t226 <= 0 and _t226 >= 0:
			v_i_187 = 0.0
			while true:
				if not J.cmp(v_i_187, 14.0, "<"): break
				v_a_188 = (J.mul(J.cl(v_R_177, null, [v_i_187]), v_PI_176) * 2.0)
				v_r_189 = J.mul(v_hh_171, (0.1 + J.mul(J.mul(0.35, v_k_166), J.cl(v_R_177, null, [J.add(v_i_187, 3.0)]))))
				var _t228 = _s70["ctx"]
				J.sp(_t228, "strokeStyle", "rgba(220,245,255,.9)")
				var _t229 = _s70["ctx"]
				J.sp(_t229, "lineWidth", 1.6)
				v_cx_190 = J.add(v_hx_172, J.mul(cos(J.num(v_a_188)), v_r_189))
				v_cy_191 = J.add(J.add(v_hy_173, J.mul(v_hh_171, 0.2)), (J.mul(sin(J.num(v_a_188)), v_r_189) * 0.6))
				v_j_192 = 0.0
				while true:
					if not J.cmp(v_j_192, 3.0, "<"): break
					v_b_193 = J.div(J.mul(v_j_192, v_PI_176), 3.0)
					J.mc(_s70["ctx"], "beginPath", [])
					J.mc(_s70["ctx"], "moveTo", [J.sub(v_cx_190, (cos(J.num(v_b_193)) * 4.0)), J.sub(v_cy_191, (sin(J.num(v_b_193)) * 4.0))])
					J.mc(_s70["ctx"], "lineTo", [J.add(v_cx_190, (cos(J.num(v_b_193)) * 4.0)), J.add(v_cy_191, (sin(J.num(v_b_193)) * 4.0))])
					J.mc(_s70["ctx"], "stroke", [])
					v_j_192 = J.num(v_j_192) + 1.0
				v_i_187 = J.num(v_i_187) + 1.0
			var _t230 = _s70["ctx"]
			J.sp(_t230, "fillStyle", "rgba(200,235,255,.85)")
			J.mc(_s70["ctx"], "fillRect", [J.add(v_hx_172, J.mul(v_hh_171, 0.18)), J.add(v_hy_173, J.mul(v_hh_171, 0.25)), J.mul(v_hh_171, 0.08), J.mul(v_hh_171, 0.1)])
			var _t231 = _s70["ctx"]
			J.sp(_t231, "strokeStyle", "#fff")
			J.mc(_s70["ctx"], "strokeRect", [J.add(v_hx_172, J.mul(v_hh_171, 0.18)), J.add(v_hy_173, J.mul(v_hh_171, 0.25)), J.mul(v_hh_171, 0.08), J.mul(v_hh_171, 0.1)])
			J.cl(v_txt_178, null, ["冰", J.add(v_hx_172, J.mul(v_hh_171, 0.22)), J.add(v_hy_173, J.mul(v_hh_171, 0.33)), J.mul(v_hh_171, 0.07), 1.0, "#2a6a9a"])
			break
		if _t226 <= 1 and _t226 >= 0:
			v_w_194 = J.mul(v_hh_171, 0.55)
			v_h_195 = J.mul(v_hh_171, 0.32)
			v_bx_196 = J.sub(v_hx_172, J.div(v_w_194, 2.0))
			v_by_197 = J.sub(v_hy_173, J.mul(v_hh_171, 0.45))
			var _t232 = _s70["ctx"]
			J.sp(_t232, "fillStyle", "rgba(180,255,210,.35)")
			J.mc(_s70["ctx"], "fillRect", [v_bx_196, v_by_197, v_w_194, v_h_195])
			var _t233 = _s70["ctx"]
			J.sp(_t233, "strokeStyle", "rgba(200,255,220,.9)")
			var _t234 = _s70["ctx"]
			J.sp(_t234, "lineWidth", 2.0)
			J.mc(_s70["ctx"], "strokeRect", [v_bx_196, v_by_197, v_w_194, v_h_195])
			var _t235 = (not J.seq(J.typeof_(J.G.get("ART")), "undefined"))
			if J.t((J.gp(J.G.get("ART"), "portrait") if _t235 else _t235)):
				v_pc_198 = J.mc(J.G.get("ART"), "portrait", [J.gp(v_f_164, "ghost"), 96.0, {"tamed": true}])
				var _t236 = _s70["ctx"]
				var _t237 = J.mul(v_e_175, 0.85)
				J.sp(_t236, "globalAlpha", _t237)
				var _t238 = _s70["ctx"]
				J.sp(_t238, "globalCompositeOperation", "luminosity")
				J.mc(_s70["ctx"], "drawImage", [v_pc_198, J.sub(v_hx_172, J.mul(v_h_195, 0.45)), J.add(v_by_197, J.mul(v_h_195, 0.05)), J.mul(v_h_195, 0.9), J.mul(v_h_195, 0.9)])
			var _t239 = _s70["ctx"]
			J.sp(_t239, "globalCompositeOperation", "lighter")
			var _t240 = _s70["ctx"]
			J.sp(_t240, "fillStyle", "rgba(150,255,190,.5)")
			J.mc(_s70["ctx"], "fillRect", [v_bx_196, J.add(v_by_197, J.mul(v_h_195, J.mod(J.mul(v_t_165, 1.5), 1.0))), v_w_194, 3.0])
			break
		if _t226 <= 2 and _t226 >= 0:
			v_i_199 = 0.0
			while true:
				if not J.cmp(v_i_199, 6.0, "<"): break
				v_q_200 = J.min_([1.0, (J.mul(v_k_166, 2.2) - J.mul(v_i_199, 0.12))])
				if J.cmp(v_q_200, 0.0, "<="):
					v_i_199 = J.num(v_i_199) + 1.0
					continue
				v_px_201 = J.add(v_hx_172, J.mul((J.mul(J.sub(J.cl(v_R_177, null, [v_i_199]), 0.5), v_hh_171) * 0.9), v_q_200))
				v_py_202 = ((J.sub(v_hy_173, J.mul(v_hh_171, 0.2)) - (J.mul(sin(J.num(J.mul(v_q_200, v_PI_176))), v_hh_171) * 0.5)) + (J.mul(v_q_200, v_hh_171) * 0.2))
				var _t241 = _s70["ctx"]
				J.sp(_t241, "fillStyle", v_col_174)
				var _t242 = _s70["ctx"]
				J.sp(_t242, "strokeStyle", "#776")
				var _t243 = _s70["ctx"]
				J.sp(_t243, "lineWidth", 1.0)
				J.mc(_s70["ctx"], "beginPath", [])
				J.mc(_s70["ctx"], "arc", [v_px_201, v_py_202, J.mul(v_hh_171, 0.035), 0.0, J.mul(v_PI_176, 2.0)])
				J.mc(_s70["ctx"], "fill", [])
				J.mc(_s70["ctx"], "stroke", [])
				v_i_199 = J.num(v_i_199) + 1.0
			J.cl(v_txt_178, null, ["噗！", v_hx_172, J.sub(v_hy_173, J.mul(v_hh_171, 0.5)), J.mul(v_hh_171, 0.12), 1.0])
			break
		if _t226 <= 3 and _t226 >= 0:
			v_w_203 = J.mul(v_hh_171, 0.6)
			v_h_204 = J.mul(v_hh_171, 0.38)
			v_bx_205 = J.sub(v_hx_172, J.div(v_w_203, 2.0))
			v_by_206 = J.sub(v_hy_173, J.mul(v_hh_171, 0.55))
			var _t244 = _s70["ctx"]
			J.sp(_t244, "fillStyle", "#101018")
			J.mc(_s70["ctx"], "fillRect", [v_bx_205, v_by_206, v_w_203, v_h_204])
			var _t245 = _s70["ctx"]
			J.sp(_t245, "strokeStyle", "#555")
			var _t246 = _s70["ctx"]
			J.sp(_t246, "lineWidth", 3.0)
			J.mc(_s70["ctx"], "strokeRect", [v_bx_205, v_by_206, v_w_203, v_h_204])
			v_bl_207 = (sin(J.num(J.mul(v_t_165, 9.0))) > 0.0)
			var _t247 = _s70["ctx"]
			J.sp(_t247, "fillStyle", v_col_174)
			var _t248 = _s70["ctx"]
			var _t249 = ("900 " + J.str(J.round(J.num(J.mul(v_h_204, 0.26)))) + "px monospace")
			J.sp(_t248, "font", _t249)
			var _t250 = _s70["ctx"]
			J.sp(_t250, "textAlign", "center")
			if J.t((v_bl_207 if J.t(v_bl_207) else (not J.seq(J.gp(v_f_164, "ghost"), "n30_daji")))):
				J.mc(_s70["ctx"], "fillText", [("GAME OVER" if J.seq(J.gp(v_f_164, "ghost"), "n30_daji") else ("（冇面）" if J.seq(J.gp(v_f_164, "ghost"), "n30_nopperabo") else "+1")), v_hx_172, J.add(v_by_206, J.mul(v_h_204, 0.58))])
			var _t251 = _s70["ctx"]
			J.sp(_t251, "globalCompositeOperation", "lighter")
			v_g_208 = J.mc(_s70["ctx"], "createRadialGradient", [v_hx_172, J.add(v_by_206, J.div(v_h_204, 2.0)), 0.0, v_hx_172, J.add(v_by_206, J.div(v_h_204, 2.0)), v_w_203])
			J.mc(v_g_208, "addColorStop", [0.0, "rgba(255,90,90,.25)"])
			J.mc(v_g_208, "addColorStop", [1.0, "rgba(255,90,90,0)"])
			var _t252 = _s70["ctx"]
			J.sp(_t252, "fillStyle", v_g_208)
			J.mc(_s70["ctx"], "fillRect", [J.sub(v_bx_205, J.div(v_w_203, 2.0)), J.sub(v_by_206, v_h_204), J.mul(v_w_203, 2.0), J.mul(v_h_204, 3.0)])
			break
		if _t226 <= 4 and _t226 >= 0:
			v_i_209 = 0.0
			while true:
				if not J.cmp(v_i_209, 7.0, "<"): break
				if (randf() < 0.4):
					v_i_209 = J.num(v_i_209) + 1.0
					continue
				v_a_210 = (J.mul(J.cl(v_R_177, null, [J.add(v_i_209, floor(J.num(J.mul(v_t_165, 20.0))))]), v_PI_176) * 2.0)
				v_L0_211 = J.mul(v_hh_171, (0.15 + (0.2 * randf())))
				var _t253 = _s70["ctx"]
				var _t254 = ("#fff" if J.t(J.mod(v_i_209, 2.0)) else v_col_174)
				J.sp(_t253, "strokeStyle", _t254)
				var _t255 = _s70["ctx"]
				J.sp(_t255, "lineWidth", 2.0)
				J.mc(_s70["ctx"], "beginPath", [])
				v_px_212 = v_hx_172
				v_py_213 = J.sub(v_y_170, J.mul(v_hh_171, 0.15))
				J.mc(_s70["ctx"], "moveTo", [v_px_212, v_py_213])
				v_j_214 = 0.0
				while true:
					if not J.cmp(v_j_214, 4.0, "<"): break
					var _t256 = J.add(v_px_212, (J.div(J.mul(cos(J.num(v_a_210)), v_L0_211), 4.0) + ((randf() - 0.5) * 8.0)))
					v_px_212 = _t256
					var _t257 = J.add(v_py_213, (J.div(J.mul(sin(J.num(v_a_210)), v_L0_211), 4.0) + ((randf() - 0.5) * 8.0)))
					v_py_213 = _t257
					J.mc(_s70["ctx"], "lineTo", [v_px_212, v_py_213])
					v_j_214 = J.num(v_j_214) + 1.0
				J.mc(_s70["ctx"], "stroke", [])
				v_i_209 = J.num(v_i_209) + 1.0
			J.cl(v_txt_178, null, ["啪！", J.add(v_hx_172, J.mul(v_hh_171, 0.25)), J.sub(v_y_170, J.mul(v_hh_171, 0.35)), J.mul(v_hh_171, 0.1), 1.0])
			break
		if _t226 <= 5 and _t226 >= 0:
			v_sx_215 = J.add(v_hx_172, J.mul(v_hh_171, 0.25))
			v_sy_216 = J.sub(v_hy_173, J.mul(v_hh_171, 0.1))
			v_op_217 = (absf(J.num(sin(J.num(J.mul(v_t_165, 12.0))))) * 0.6)
			var _t258 = _s70["ctx"]
			J.sp(_t258, "strokeStyle", "#ddd")
			var _t259 = _s70["ctx"]
			J.sp(_t259, "lineWidth", 3.0)
			for _t260 in J.iter([(-1.0), 1.0]):
				v_s_218 = _t260
				J.mc(_s70["ctx"], "beginPath", [])
				J.mc(_s70["ctx"], "moveTo", [v_sx_215, v_sy_216])
				J.mc(_s70["ctx"], "lineTo", [J.add(v_sx_215, (J.mul(cos(J.num(J.mul(v_s_218, v_op_217))), v_hh_171) * 0.18)), J.add(v_sy_216, (J.mul(sin(J.num(J.mul(v_s_218, v_op_217))), v_hh_171) * 0.18))])
				J.mc(_s70["ctx"], "stroke", [])
				J.mc(_s70["ctx"], "beginPath", [])
				J.mc(_s70["ctx"], "arc", [J.sub(v_sx_215, (J.mul(cos(J.num(J.mul((-J.num(v_s_218)), v_op_217))), v_hh_171) * 0.04)), J.sub(v_sy_216, (J.mul(sin(J.num(J.mul((-J.num(v_s_218)), v_op_217))), v_hh_171) * 0.04)), 4.0, 0.0, J.mul(v_PI_176, 2.0)])
				J.mc(_s70["ctx"], "stroke", [])
			v_i_219 = 0.0
			while true:
				if not J.cmp(v_i_219, 6.0, "<"): break
				v_q_220 = J.mod(J.add(J.mul(v_k_166, 1.5), J.cl(v_R_177, null, [v_i_219])), 1.0)
				var _t261 = _s70["ctx"]
				J.sp(_t261, "fillStyle", v_col_174)
				J.mc(_s70["ctx"], "save", [])
				J.mc(_s70["ctx"], "translate", [J.add(v_sx_215, (J.mul(J.sub(J.cl(v_R_177, null, [J.add(v_i_219, 1.0)]), 0.5), v_hh_171) * 0.5)), J.add(v_sy_216, (J.mul(v_q_220, v_hh_171) * 0.7))])
				J.mc(_s70["ctx"], "rotate", [J.add(J.mul(v_t_165, 3.0), v_i_219)])
				J.mc(_s70["ctx"], "fillRect", [(-4.0), (-1.5), 8.0, 3.0])
				J.mc(_s70["ctx"], "restore", [])
				v_i_219 = J.num(v_i_219) + 1.0
			J.cl(v_txt_178, null, ["咔嚓", v_sx_215, J.sub(v_sy_216, J.mul(v_hh_171, 0.15)), J.mul(v_hh_171, 0.08), 1.0])
			break
		if _t226 <= 6 and _t226 >= 0:
			v_i_221 = 0.0
			while true:
				if not J.cmp(v_i_221, 8.0, "<"): break
				v_q_222 = J.mod(J.add(J.mul(v_t_165, 1.3), J.cl(v_R_177, null, [v_i_221])), 1.0)
				v_dx_223 = J.add(v_hx_172, (J.mul(J.sub(J.cl(v_R_177, null, [J.add(v_i_221, 2.0)]), 0.5), v_hh_171) * 0.3))
				var _t262 = _s70["ctx"]
				J.sp(_t262, "fillStyle", v_col_174)
				J.mc(_s70["ctx"], "beginPath", [])
				J.mc(_s70["ctx"], "ellipse", [v_dx_223, (J.sub(v_hy_173, J.mul(v_hh_171, 0.9)) + (J.mul(v_q_222, v_hh_171) * 0.85)), 2.5, 4.0, 0.0, 0.0, J.mul(v_PI_176, 2.0)])
				J.mc(_s70["ctx"], "fill", [])
				v_i_221 = J.num(v_i_221) + 1.0
			var _t263 = _s70["ctx"]
			J.sp(_t263, "fillStyle", "rgba(120,180,230,.35)")
			J.mc(_s70["ctx"], "beginPath", [])
			J.mc(_s70["ctx"], "ellipse", [v_hx_172, v_y_170, (J.mul(v_hh_171, 0.25) * J.min_([1.0, J.mul(v_k_166, 3.0)])), J.mul(v_hh_171, 0.05), 0.0, 0.0, J.mul(v_PI_176, 2.0)])
			J.mc(_s70["ctx"], "fill", [])
			J.cl(v_txt_178, null, ["滴……滴……", v_hx_172, J.sub(v_hy_173, J.mul(v_hh_171, 0.6)), J.mul(v_hh_171, 0.08), 1.0])
			break
		if _t226 <= 7 and _t226 >= 0:
			v_i_224 = 0.0
			while true:
				if not J.cmp(v_i_224, 5.0, "<"): break
				v_q_225 = J.mod((J.mul(v_k_166, 1.6) + J.div(v_i_224, 5.0)), 1.0)
				J.cl(v_txt_178, null, ["哈", J.add(v_hx_172, (J.mul(J.sub(J.cl(v_R_177, null, [v_i_224]), 0.5), v_hh_171) * 0.9)), J.sub(v_hy_173, (J.mul(v_q_225, v_hh_171) * 0.6)), J.mul(v_hh_171, (0.08 + J.mul(0.05, J.cl(v_R_177, null, [J.add(v_i_224, 3.0)])))), sin(J.num(J.mul(v_q_225, v_PI_176))), v_col_174])
				v_i_224 = J.num(v_i_224) + 1.0
			break
		if _t226 <= 8 and _t226 >= 0:
			v_i_226 = 0.0
			while true:
				if not J.cmp(v_i_226, 7.0, "<"): break
				v_q_227 = J.mod((J.mul(v_k_166, 1.2) + J.div(v_i_226, 7.0)), 1.0)
				v_px_228 = J.add(J.add(v_hx_172, (J.mul(J.sub(J.cl(v_R_177, null, [v_i_226]), 0.5), v_hh_171) * 0.4)), (sin(J.num(J.add(J.mul(v_t_165, 2.0), v_i_226))) * 6.0))
				v_py_229 = J.sub(J.add(v_hy_173, J.mul(v_hh_171, 0.2)), (J.mul(v_q_227, v_hh_171) * 0.5))
				v_r_230 = J.mul(v_hh_171, (0.06 + J.mul(0.12, v_q_227)))
				v_g_231 = J.mc(_s70["ctx"], "createRadialGradient", [v_px_228, v_py_229, 0.0, v_px_228, v_py_229, v_r_230])
				J.mc(v_g_231, "addColorStop", [0.0, v_col_174])
				J.mc(v_g_231, "addColorStop", [1.0, "rgba(0,0,0,0)"])
				var _t264 = _s70["ctx"]
				var _t265 = (J.mul(v_e_175, 0.55) * J.sub(1.0, v_q_227))
				J.sp(_t264, "globalAlpha", _t265)
				var _t266 = _s70["ctx"]
				J.sp(_t266, "fillStyle", v_g_231)
				J.mc(_s70["ctx"], "beginPath", [])
				J.mc(_s70["ctx"], "arc", [v_px_228, v_py_229, v_r_230, 0.0, J.mul(v_PI_176, 2.0)])
				J.mc(_s70["ctx"], "fill", [])
				v_i_226 = J.num(v_i_226) + 1.0
			break
		if _t226 <= 9 and _t226 >= 0:
			var _t267 = _s70["ctx"]
			var _t268 = J.mul(v_e_175, 0.55)
			J.sp(_t267, "globalAlpha", _t268)
			var _t269 = J.gp(v_n_167, "dir")
			v_sx_232 = J.sub(v_hx_172, (J.mul((_t269 if J.t(_t269) else 1.0), v_hh_171) * 0.3))
			v_H_233 = J.mul(v_hh_171, (1.3 + J.mul(0.5, v_k_166)))
			var _t270 = _s70["ctx"]
			var _t271 = J.seq(v_col_174, "#e8e8f0")
			var _t272 = ("rgba(230,230,240,.5)" if (_t271 if _t271 else J.seq(v_col_174, "#e8e0d0")) else "rgba(5,3,12,.85)")
			J.sp(_t270, "fillStyle", _t272)
			J.mc(_s70["ctx"], "beginPath", [])
			J.mc(_s70["ctx"], "ellipse", [v_sx_232, J.sub(v_y_170, J.mul(v_H_233, 0.5)), J.mul(v_hh_171, 0.22), J.mul(v_H_233, 0.5), 0.0, 0.0, J.mul(v_PI_176, 2.0)])
			J.mc(_s70["ctx"], "fill", [])
			J.mc(_s70["ctx"], "beginPath", [])
			J.mc(_s70["ctx"], "arc", [v_sx_232, J.sub(v_y_170, J.mul(v_H_233, 0.98)), J.mul(v_hh_171, 0.13), 0.0, J.mul(v_PI_176, 2.0)])
			J.mc(_s70["ctx"], "fill", [])
			break
		if _t226 <= 10 and _t226 >= 0:
			v_i_234 = 0.0
			while true:
				if not J.cmp(v_i_234, 9.0, "<"): break
				v_q_235 = J.min_([1.0, (J.mul(v_k_166, 2.0) - J.mul(J.cl(v_R_177, null, [v_i_234]), 0.4))])
				if J.cmp(v_q_235, 0.0, "<="):
					v_i_234 = J.num(v_i_234) + 1.0
					continue
				v_px_236 = J.add(v_hx_172, (J.mul(J.sub(J.cl(v_R_177, null, [v_i_234]), 0.5), v_hh_171) * 0.8))
				v_py_237 = ((J.sub(v_hy_173, J.mul(v_hh_171, 0.3)) + (J.mul(v_q_235, v_hh_171) * 0.9)) - (J.mul(sin(J.num(J.mul(v_q_235, v_PI_176))), v_hh_171) * 0.3))
				var _t273 = _s70["ctx"]
				J.sp(_t273, "fillStyle", v_col_174)
				J.mc(_s70["ctx"], "save", [])
				J.mc(_s70["ctx"], "translate", [v_px_236, v_py_237])
				J.mc(_s70["ctx"], "rotate", [J.add(J.mul(v_t_165, 5.0), v_i_234)])
				J.mc(_s70["ctx"], "scale", [cos(J.num(J.add(J.mul(v_t_165, 8.0), v_i_234))), 1.0])
				J.mc(_s70["ctx"], "beginPath", [])
				J.mc(_s70["ctx"], "ellipse", [0.0, 0.0, 5.0, 5.0, 0.0, 0.0, J.mul(v_PI_176, 2.0)])
				J.mc(_s70["ctx"], "fill", [])
				J.mc(_s70["ctx"], "restore", [])
				v_i_234 = J.num(v_i_234) + 1.0
			J.cl(v_txt_178, null, ["叮噹", v_hx_172, J.sub(v_hy_173, J.mul(v_hh_171, 0.4)), J.mul(v_hh_171, 0.08), 1.0])
			break
		if _t226 <= 11 and _t226 >= 0:
			pass
		if _t226 <= 12 and _t226 >= 0:
			pass
		if _t226 <= 13 and _t226 >= 0:
			v_L1_238 = J.mul(v_hh_171, (0.2 + (0.8 * J.min_([1.0, J.mul(v_k_166, 2.5)]))))
			if J.seq(J.gp(v_f_164, "sig"), "tongue"):
				var _t274 = _s70["ctx"]
				var _t275 = ("#e04a5a" if J.seq(v_col_174, "#ffffff") else v_col_174)
				J.sp(_t274, "fillStyle", _t275)
				J.mc(_s70["ctx"], "beginPath", [])
				J.mc(_s70["ctx"], "moveTo", [J.sub(v_hx_172, 5.0), J.sub(v_hy_173, J.mul(v_hh_171, 1.2))])
				J.mc(_s70["ctx"], "quadraticCurveTo", [(J.sub(v_hx_172, 8.0) + (sin(J.num(J.mul(v_t_165, 3.0))) * 4.0)), (J.sub(v_hy_173, J.mul(v_hh_171, 1.2)) + J.mul(v_L1_238, 0.6)), v_hx_172, J.add(J.sub(v_hy_173, J.mul(v_hh_171, 1.2)), v_L1_238)])
				J.mc(_s70["ctx"], "quadraticCurveTo", [J.add(v_hx_172, 8.0), (J.sub(v_hy_173, J.mul(v_hh_171, 1.2)) + J.mul(v_L1_238, 0.6)), J.add(v_hx_172, 5.0), J.sub(v_hy_173, J.mul(v_hh_171, 1.2))])
				J.mc(_s70["ctx"], "fill", [])
			else:
				if J.seq(J.gp(v_f_164, "sig"), "veil"):
					v_vy_239 = (J.sub(v_hy_173, J.mul(v_hh_171, 0.9)) + (J.mul(J.min_([1.0, J.mul(v_k_166, 2.0)]), v_hh_171) * 0.75))
					var _t276 = _s70["ctx"]
					J.sp(_t276, "fillStyle", v_col_174)
					J.mc(_s70["ctx"], "beginPath", [])
					J.mc(_s70["ctx"], "moveTo", [J.sub(v_hx_172, J.mul(v_hh_171, 0.2)), v_vy_239])
					J.mc(_s70["ctx"], "quadraticCurveTo", [v_hx_172, J.sub(v_vy_239, J.mul(v_hh_171, 0.15)), J.add(v_hx_172, J.mul(v_hh_171, 0.2)), v_vy_239])
					J.mc(_s70["ctx"], "lineTo", [J.add(J.add(v_hx_172, J.mul(v_hh_171, 0.17)), (sin(J.num(J.mul(v_t_165, 4.0))) * 3.0)), J.add(v_vy_239, J.mul(v_hh_171, 0.22))])
					J.mc(_s70["ctx"], "lineTo", [J.sub(v_hx_172, J.mul(v_hh_171, 0.17)), J.add(v_vy_239, J.mul(v_hh_171, 0.22))])
					J.mc(_s70["ctx"], "fill", [])
					var _t277 = _s70["ctx"]
					J.sp(_t277, "fillStyle", "#ffd36a")
					J.mc(_s70["ctx"], "fillRect", [J.sub(v_hx_172, J.mul(v_hh_171, 0.17)), J.add(v_vy_239, J.mul(v_hh_171, 0.2)), J.mul(v_hh_171, 0.34), 3.0])
				else:
					var _t278 = _s70["ctx"]
					J.sp(_t278, "strokeStyle", v_col_174)
					var _t279 = _s70["ctx"]
					J.sp(_t279, "lineWidth", 2.5)
					v_i_240 = 0.0
					while true:
						if not J.cmp(v_i_240, 14.0, "<"): break
						v_sx_241 = J.add(v_hx_172, (J.mul(J.sub(v_i_240, 7.0), v_hh_171) * 0.025))
						J.mc(_s70["ctx"], "beginPath", [])
						J.mc(_s70["ctx"], "moveTo", [v_sx_241, J.sub(v_hy_173, J.mul(v_hh_171, 1.1))])
						J.mc(_s70["ctx"], "quadraticCurveTo", [J.add(v_sx_241, (sin(J.num(J.add(J.mul(v_t_165, 2.0), v_i_240))) * 6.0)), (J.sub(v_hy_173, J.mul(v_hh_171, 1.1)) + J.mul(v_L1_238, 0.5)), J.add(v_sx_241, (sin(J.num(J.add(J.mul(v_t_165, 1.5), v_i_240))) * 10.0)), J.add(J.sub(v_hy_173, J.mul(v_hh_171, 1.1)), v_L1_238)])
						J.mc(_s70["ctx"], "stroke", [])
						v_i_240 = J.num(v_i_240) + 1.0
			break
		if _t226 <= 14 and _t226 >= 0:
			v_i_242 = 0.0
			while true:
				if not J.cmp(v_i_242, 4.0, "<"): break
				v_px_243 = J.add(J.add(v_hx_172, (J.mul(J.sub(v_i_242, 1.5), v_hh_171) * 0.16)), (sin(J.num(J.add(J.mul(v_t_165, 20.0), v_i_242))) * 3.0))
				v_py_244 = (J.sub(v_hy_173, J.mul(v_hh_171, 0.25)) + (cos(J.num(J.add(J.mul(v_t_165, 17.0), v_i_242))) * 3.0))
				var _t280 = _s70["ctx"]
				J.sp(_t280, "fillStyle", v_col_174)
				J.mc(_s70["ctx"], "save", [])
				J.mc(_s70["ctx"], "translate", [v_px_243, v_py_244])
				J.mc(_s70["ctx"], "rotate", [J.add(v_i_242, (sin(J.num(J.mul(v_t_165, 10.0))) * 0.4))])
				J.mc(_s70["ctx"], "fillRect", [((-J.num(v_hh_171)) * 0.05), (-2.0), J.mul(v_hh_171, 0.1), 4.0])
				J.mc(_s70["ctx"], "beginPath", [])
				J.mc(_s70["ctx"], "arc", [((-J.num(v_hh_171)) * 0.05), 0.0, 3.5, 0.0, J.mul(v_PI_176, 2.0)])
				J.mc(_s70["ctx"], "arc", [J.mul(v_hh_171, 0.05), 0.0, 3.5, 0.0, J.mul(v_PI_176, 2.0)])
				J.mc(_s70["ctx"], "fill", [])
				J.mc(_s70["ctx"], "restore", [])
				v_i_242 = J.num(v_i_242) + 1.0
			J.cl(v_txt_178, null, ["咔咔咔", v_hx_172, J.sub(v_hy_173, J.mul(v_hh_171, 0.45)), J.mul(v_hh_171, 0.08), 1.0])
			break
		if _t226 <= 15 and _t226 >= 0:
			v_q_245 = J.mod(J.mul(v_k_166, 4.0), 1.0)
			var _t281 = _s70["ctx"]
			J.sp(_t281, "strokeStyle", "rgba(255,240,200,.8)")
			var _t282 = _s70["ctx"]
			J.sp(_t282, "lineWidth", 2.0)
			J.mc(_s70["ctx"], "beginPath", [])
			J.mc(_s70["ctx"], "ellipse", [v_hx_172, J.sub(v_hy_173, J.mul(v_hh_171, 0.5)), J.mul(v_hh_171, (0.1 + J.mul(v_q_245, 0.4))), J.mul(v_hh_171, (0.03 + J.mul(v_q_245, 0.08))), 0.0, 0.0, J.mul(v_PI_176, 2.0)])
			J.mc(_s70["ctx"], "stroke", [])
			J.cl(v_txt_178, null, ["咚！", J.add(v_hx_172, (J.mul(J.sub(J.cl(v_R_177, null, [floor(J.num(J.mul(v_k_166, 4.0)))]), 0.5), v_hh_171) * 0.4)), J.sub(v_hy_173, J.mul(v_hh_171, 0.55)), J.mul(v_hh_171, 0.13), (1.0 - J.mul(v_q_245, 0.5))])
			break
		if _t226 <= 16 and _t226 >= 0:
			v_on_246 = (sin(J.num(J.mul(v_t_165, 30.0))) > 0.2)
			if J.t(v_on_246):
				var _t283 = _s70["ctx"]
				J.sp(_t283, "globalCompositeOperation", "lighter")
				v_g_247 = J.mc(_s70["ctx"], "createRadialGradient", [v_hx_172, v_hy_173, 0.0, v_hx_172, v_hy_173, J.mul(v_hh_171, 1.4)])
				J.mc(v_g_247, "addColorStop", [0.0, J.add(v_col_174, "88")])
				J.mc(v_g_247, "addColorStop", [1.0, "rgba(0,0,0,0)"])
				var _t284 = _s70["ctx"]
				J.sp(_t284, "fillStyle", v_g_247)
				J.mc(_s70["ctx"], "fillRect", [J.sub(v_hx_172, J.mul(v_hh_171, 1.4)), J.sub(v_hy_173, J.mul(v_hh_171, 1.4)), J.mul(v_hh_171, 2.8), J.mul(v_hh_171, 2.8)])
			var _t285 = (not J.seq(J.typeof_(J.G.get("ART")), "undefined"))
			var _t286 = (J.gp(J.G.get("ART"), "portrait") if _t285 else _t285)
			var _t287 = (J.cmp(v_k_166, 0.3, ">") if J.t(_t286) else _t286)
			if J.t((J.cmp(v_k_166, 0.7, "<") if J.t(_t287) else _t287)):
				v_pc_248 = J.mc(J.G.get("ART"), "portrait", [J.gp(v_f_164, "ghost"), 96.0, {"tamed": true}])
				v_sz_249 = J.mul(v_hh_171, 0.45)
				var _t288 = _s70["ctx"]
				J.sp(_t288, "globalCompositeOperation", "source-over")
				var _t289 = _s70["ctx"]
				var _t290 = J.mul(v_e_175, 0.6)
				J.sp(_t289, "globalAlpha", _t290)
				var _t291 = J.gp(v_n_167, "dir")
				J.mc(_s70["ctx"], "drawImage", [v_pc_248, (J.sub(v_hx_172, (J.mul((_t291 if J.t(_t291) else 1.0), v_hh_171) * 0.45)) - J.div(v_sz_249, 2.0)), J.sub(v_hy_173, J.mul(v_hh_171, 0.45)), v_sz_249, v_sz_249])
			break
		if _t226 <= 17 and _t226 >= 0:
			v_i_250 = 0.0
			while true:
				if not J.cmp(v_i_250, 8.0, "<"): break
				v_q_251 = J.mod((J.mul(v_t_165, 0.9) + J.div(v_i_250, 8.0)), 1.0)
				v_px_252 = J.add(v_hx_172, (J.mul(J.sub(v_i_250, 4.0), v_hh_171) * 0.07))
				var _t292 = _s70["ctx"]
				var _t293 = ("rgba(255," + J.str((120.0 + J.mul(v_i_250, 10.0))) + ",60," + J.str((0.6 * J.sub(1.0, v_q_251))) + ")")
				J.sp(_t292, "strokeStyle", _t293)
				var _t294 = _s70["ctx"]
				J.sp(_t294, "lineWidth", 2.0)
				J.mc(_s70["ctx"], "beginPath", [])
				J.mc(_s70["ctx"], "moveTo", [v_px_252, J.sub(v_y_170, (J.mul(v_q_251, v_hh_171) * 1.1))])
				J.mc(_s70["ctx"], "quadraticCurveTo", [J.add(v_px_252, (sin(J.num(J.add(J.mul(v_t_165, 6.0), v_i_250))) * 6.0)), (J.sub(v_y_170, (J.mul(v_q_251, v_hh_171) * 1.1)) - 10.0), v_px_252, (J.sub(v_y_170, (J.mul(v_q_251, v_hh_171) * 1.1)) - 20.0)])
				J.mc(_s70["ctx"], "stroke", [])
				v_i_250 = J.num(v_i_250) + 1.0
			J.cl(v_txt_178, null, ["熱……", v_hx_172, J.sub(v_hy_173, J.mul(v_hh_171, 0.45)), J.mul(v_hh_171, 0.08), 1.0])
			break
		if _t226 <= 18 and _t226 >= 0:
			var _t295 = J.gp(v_n_167, "dir")
			v_px_253 = J.add(v_hx_172, (J.mul((_t295 if J.t(_t295) else 1.0), v_hh_171) * 0.25))
			v_py_254 = J.sub(v_hy_173, J.mul(v_hh_171, 0.15))
			v_sh_255 = (sin(J.num(J.mul(v_t_165, 40.0))) * 2.0)
			var _t296 = _s70["ctx"]
			J.sp(_t296, "fillStyle", "#222")
			J.mc(_s70["ctx"], "fillRect", [J.add(J.sub(v_px_253, 6.0), v_sh_255), J.sub(v_py_254, 10.0), 12.0, 20.0])
			var _t297 = _s70["ctx"]
			J.sp(_t297, "fillStyle", v_col_174)
			J.mc(_s70["ctx"], "fillRect", [J.add(J.sub(v_px_253, 4.0), v_sh_255), J.sub(v_py_254, 8.0), 8.0, 13.0])
			v_i_256 = 1.0
			while true:
				if not J.cmp(v_i_256, 3.0, "<="): break
				var _t298 = _s70["ctx"]
				var _t299 = ("rgba(255,255,255," + J.str((0.7 - J.mul(v_i_256, 0.18))) + ")")
				J.sp(_t298, "strokeStyle", _t299)
				var _t300 = _s70["ctx"]
				J.sp(_t300, "lineWidth", 1.5)
				J.mc(_s70["ctx"], "beginPath", [])
				J.mc(_s70["ctx"], "arc", [v_px_253, v_py_254, (8.0 + J.mul(v_i_256, 6.0)), (-0.8), 0.8])
				J.mc(_s70["ctx"], "stroke", [])
				J.mc(_s70["ctx"], "beginPath", [])
				J.mc(_s70["ctx"], "arc", [v_px_253, v_py_254, (8.0 + J.mul(v_i_256, 6.0)), J.sub(v_PI_176, 0.8), J.add(v_PI_176, 0.8)])
				J.mc(_s70["ctx"], "stroke", [])
				v_i_256 = J.num(v_i_256) + 1.0
			J.cl(v_txt_178, null, ["鈴鈴鈴", v_px_253, J.sub(v_py_254, 24.0), J.mul(v_hh_171, 0.07), 1.0])
			break
		if _t226 <= 19 and _t226 >= 0:
			v_i_257 = 0.0
			while true:
				if not J.cmp(v_i_257, 3.0, "<"): break
				v_q_258 = J.mod((J.mul(v_k_166, 1.3) + J.div(v_i_257, 3.0)), 1.0)
				var _t302 = ("唧" if J.seq(J.gp(v_f_164, "ghost"), "n30_pelesit") else "……")
				var _t301 = J.gp(v_n_167, "dir")
				J.cl(v_txt_178, null, [_t302, J.sub(v_hx_172, (J.mul((_t301 if J.t(_t301) else 1.0), v_hh_171) * (0.2 + J.mul(v_q_258, 0.3)))), (J.sub(v_hy_173, J.mul(v_hh_171, 0.1)) - (J.mul(v_q_258, v_hh_171) * 0.2)), J.mul(v_hh_171, 0.07), (sin(J.num(J.mul(v_q_258, v_PI_176))) * 0.8), v_col_174])
				v_i_257 = J.num(v_i_257) + 1.0
			break
		if _t226 <= 20 and _t226 >= 0:
			v_s_259 = (1.0 + (sin(J.num(J.mul(v_t_165, 25.0))) * 0.05))
			J.cl(v_txt_178, null, ["呀——！", J.add(v_hx_172, (sin(J.num(J.mul(v_t_165, 30.0))) * 3.0)), J.sub(v_hy_173, J.mul(v_hh_171, 0.5)), J.mul(J.mul(v_hh_171, 0.13), v_s_259), 1.0, v_col_174])
			break
		if _t226 <= 21 and _t226 >= 0:
			v_i_260 = 0.0
			while true:
				if not J.cmp(v_i_260, 5.0, "<"): break
				v_q_261 = J.min_([1.0, (J.mul(v_k_166, 3.0) - J.mul(v_i_260, 0.3))])
				if J.cmp(v_q_261, 0.0, "<="):
					v_i_260 = J.num(v_i_260) + 1.0
					continue
				var _t304 = (J.mul(J.sub(v_i_260, 2.5), v_hh_171) * 0.14)
				var _t303 = J.gp(v_n_167, "dir")
				v_px_262 = J.add(v_hx_172, (_t304 * (-J.num((_t303 if J.t(_t303) else 1.0)))))
				v_py_263 = J.add(v_y_170, (4.0 if J.t(J.mod(v_i_260, 2.0)) else (-4.0)))
				var _t305 = _s70["ctx"]
				var _t306 = (J.mul(v_e_175, v_q_261) * 0.8)
				J.sp(_t305, "globalAlpha", _t306)
				var _t307 = _s70["ctx"]
				J.sp(_t307, "fillStyle", v_col_174)
				J.mc(_s70["ctx"], "beginPath", [])
				J.mc(_s70["ctx"], "ellipse", [v_px_262, v_py_263, 5.0, 2.5, 0.0, 0.0, J.mul(v_PI_176, 2.0)])
				J.mc(_s70["ctx"], "fill", [])
				v_j_264 = 0.0
				while true:
					if not J.cmp(v_j_264, 3.0, "<"): break
					J.mc(_s70["ctx"], "beginPath", [])
					var _t308 = J.gp(v_n_167, "dir")
					J.mc(_s70["ctx"], "arc", [J.add(v_px_262, J.mul((_t308 if J.t(_t308) else 1.0), 6.0)), (J.sub(v_py_263, 2.0) + J.mul(v_j_264, 2.0)), 1.2, 0.0, J.mul(v_PI_176, 2.0)])
					J.mc(_s70["ctx"], "fill", [])
					v_j_264 = J.num(v_j_264) + 1.0
				v_i_260 = J.num(v_i_260) + 1.0
			break
		if _t226 <= 22 and _t226 >= 0:
			v_g_265 = J.mc(_s70["ctx"], "createRadialGradient", [v_hx_172, v_hy_173, J.mul(v_hh_171, 0.2), v_hx_172, v_hy_173, J.mul(v_hh_171, 1.3)])
			J.mc(v_g_265, "addColorStop", [0.0, "rgba(0,0,0,0)"])
			J.mc(v_g_265, "addColorStop", [1.0, "rgba(0,0,10,.75)"])
			var _t309 = _s70["ctx"]
			J.sp(_t309, "fillStyle", v_g_265)
			J.mc(_s70["ctx"], "fillRect", [J.sub(v_hx_172, J.mul(v_hh_171, 1.5)), J.sub(v_hy_173, J.mul(v_hh_171, 1.5)), J.mul(v_hh_171, 3.0), J.mul(v_hh_171, 3.0)])
			J.cl(v_txt_178, null, ["啪", v_hx_172, J.sub(v_hy_173, J.mul(v_hh_171, 0.6)), J.mul(v_hh_171, 0.1), 1.0])
			break
		break
	J.mc(_s70["ctx"], "restore", [])
	var _t310 = J.cmp(v_k_166, 0.1, ">")
	var _t311 = (J.cmp(v_k_166, 0.8, "<") if _t310 else _t310)
	if J.t((J.gp(v_f_164, "sigText") if _t311 else _t311)):
		var _t312 = _s70["__p"]["Lx"]
		J.cl(v_txt_178, null, [J.cl(_t312, null, [J.gp(v_f_164, "sigText")]), v_hx_172, J.add(v_y_170, J.mul(v_hh_171, 0.12)), J.max_([12.0, J.mul(v_hh_171, 0.075)]), J.min_([1.0, (J.sub(v_k_166, 0.1) * 6.0), (J.sub(0.8, v_k_166) * 6.0)]), "#e8c8ff"])

func _f34(this_, a: Array, env):
	var v_s_291 = null
	v_s_291 = J.arg(a, 0)
	var _t362 = env["__p"]["Lf"]
	var _t366 = env["who"]
	var _t367 = env["room"]
	var _t365 = env["trick"]
	if not J.t(_t365):
		var _t363 = env["__p"]["Lx"]
		var _t364 = env["__p"]["T"]
		_t365 = J.cl(_t363, null, [J.cl(_t364, null, ["有怪聲", "有怪聲"])])
	return J.cl(_t362, null, [v_s_291, {"who": _t366, "room": _t367, "trick": _t365, "v": env["views"]}])

func _f33(this_, a: Array, env):
	var v_Sc_268 = null; var v_stars_269 = null; var v_quit_270 = null; var v_N_271 = null; var v_loc_272 = null; var v_before_273 = null; var v_heat_274 = null; var v_after_275 = null; var v_up_276 = null; var v_ghosts_277 = null; var v_perGhost_278 = null; var v_b_279 = null; var v_P_284 = null; var v_fill_285 = null; var v_extra_286 = null; var v_pct_287 = null; var v_d_288 = null; var v_k_289 = null; var v_e_290 = null
	var _s126 = {"__p": env, "who": null, "room": null, "trick": null, "views": null}
	v_Sc_268 = J.arg(a, 0)
	v_stars_269 = J.arg(a, 1)
	v_quit_270 = J.arg(a, 2)
	var _t313 = J.gp(v_Sc_268, "night")
	v_N_271 = (_t313 if J.t(_t313) else {"per": {}, "types": J.new_("Set", []), "seen": 0.0, "nb": 0.0, "alone": 0.0, "inf": 0.0, "infFled": 0.0, "filmed": 0.0, "stole": 0.0, "bryanOut": 0.0, "foiled": 0.0})
	v_loc_272 = J.gp(v_Sc_268, "siteId")
	var _t314 = _s126["__p"]["legend"]
	v_before_273 = J.cl(_t314, null, [v_loc_272])
	v_heat_274 = (J.sub(J.add(J.add(J.add(J.add(((((J.div(J.gp(v_Sc_268, "kpi"), 120.0) + J.mul(8.0, J.gp(v_N_271, "nb"))) + J.mul(4.0, J.gp(v_N_271, "alone"))) + J.mul(2.0, J.gp(J.gp(v_N_271, "types"), "size"))) + (J.mul((-3.0), J.gp(v_N_271, "seen")) if J.t(J.gp(v_N_271, "seen")) else 6.0)), J.gp(v_N_271, "inf")), J.mul(20.0, J.gp(v_N_271, "infFled"))), J.mul(4.0, J.gp(v_N_271, "filmed"))), J.mul(5.0, J.gp(v_N_271, "bryanOut"))), (10.0 if J.t(J.gp(v_Sc_268, "expelled")) else 0.0)) - (5.0 if J.t(v_quit_270) else 0.0))
	var _t315 = J.max_([0.0, J.round(J.num(J.mul(v_heat_274, (1.2 if J.cmp(J.gp(v_before_273, "lv"), 5.0, ">=") else 1.0))))])
	v_heat_274 = _t315
	var _t316 = (not J.seq(J.typeof_(J.G.get("S")), "undefined"))
	if J.t((J.G.get("S") if _t316 else _t316)):
		var _t317 = J.G.get("S")
		var _t318 = J.gp(J.G.get("S"), "legend")
		var _t319 = (_t318 if J.t(_t318) else {})
		J.sp(_t317, "legend", _t319)
		var _t320 = J.gp(J.G.get("S"), "legend")
		var _t321 = J.gp(J.gp(J.G.get("S"), "legend"), v_loc_272)
		var _t322 = (_t321 if J.t(_t321) else {"heat": 0.0, "nights": 0.0})
		J.sp(_t320, v_loc_272, _t322)
		v_d_288 = _t322
		var _t323 = J.add(J.gp(v_d_288, "heat"), v_heat_274)
		J.sp(v_d_288, "heat", _t323)
		J.sp(v_d_288, "nights", J.num(J.gp(v_d_288, "nights")) + 1.0)
	var _t324 = _s126["__p"]["legend"]
	v_after_275 = J.cl(_t324, null, [v_loc_272])
	v_up_276 = J.cmp(J.gp(v_after_275, "lv"), J.gp(v_before_273, "lv"), ">")
	v_ghosts_277 = (J.mc(J.gp(v_Sc_268, "team"), "slice", []) if J.t(J.gp(v_Sc_268, "team")) else [])
	v_perGhost_278 = {}
	for _t325 in J.keys(J.gp(v_N_271, "per")):
		v_k_289 = _t325
		var _t326 = {"scares": J.gp(J.gp(J.gp(v_N_271, "per"), v_k_289), "scares"), "fear": J.round(J.num(J.gp(J.gp(J.gp(v_N_271, "per"), v_k_289), "fear")))}
		J.sp(v_perGhost_278, v_k_289, _t326)
	J.S_window_("dispatchEvent", [J.new_("CustomEvent", ["gb:nightEnd", {"detail": {"loc": v_loc_272, "score": J.gp(v_Sc_268, "kpi"), "stars": v_stars_269, "heat": v_heat_274, "legendLv": J.gp(v_after_275, "lv"), "ghosts": v_ghosts_277, "perGhost": v_perGhost_278, "exposed": J.cmp(J.gp(v_N_271, "seen"), 0.0, ">"), "exorcised": (not (not J.t(J.gp(v_Sc_268, "expelled")))), "bryanStole": J.gp(v_N_271, "stole")}}])])
	v_b_279 = J.gp(v_N_271, "best")
	var _t329 = null
	if J.t(v_b_279):
		_t329 = J.gp(v_b_279, "name")
	else:
		var _t327 = _s126["__p"]["Lx"]
		var _t328 = _s126["__p"]["T"]
		_t329 = J.cl(_t327, null, [J.cl(_t328, null, ["一個 OT 員工", "一個加班員工"])])
	_s126["who"] = _t329
	var _t332 = null
	if J.t((J.gp(v_b_279, "room") if J.t(v_b_279) else v_b_279)):
		_t332 = J.gp(v_b_279, "room")
	else:
		var _t330 = _s126["__p"]["Lx"]
		var _t331 = _s126["__p"]["T"]
		_t332 = J.cl(_t330, null, [J.cl(_t331, null, ["二十三樓", "二十三樓"])])
	_s126["room"] = _t332
	_s126["trick"] = (J.gp(J.gp(J.G.get("SCARE_GHOSTS"), J.gp(v_b_279, "ghost")), "skill") if J.t((J.gp(J.G.get("SCARE_GHOSTS"), J.gp(v_b_279, "ghost")) if J.t(v_b_279) else v_b_279)) else "")
	_s126["views"] = J.div(J.round(J.num(J.mul(J.add(J.gp(v_after_275, "heat"), 20.0), (3.0 + J.mul(J.gp(v_after_275, "lv"), 4.0))))), 10.0)
	var _t333 = _s126["__p"]["T"]
	var _t335 = J.cl(_t333, null, ["WhatsApp・公司 OT 群", "WhatsApp・公司加班群"])
	var _t334 = _s126["__p"]["T"]
	var _t337 = J.cl(_t334, null, ["{who}話喺{room}見到嘢，冇人信佢（笑）", "{who}說在{room}看到東西，沒人信他（笑）"])
	var _t336 = _s126["__p"]["T"]
	var _t343 = [_t335, _t337, J.cl(_t336, null, ["三個人已讀", "三人已讀"])]
	var _t338 = _s126["__p"]["T"]
	var _t340 = J.cl(_t338, null, ["連登・靈異台", "論壇・靈異版"])
	var _t339 = _s126["__p"]["T"]
	var _t342 = J.cl(_t339, null, ["【真人真事】我公司二十三樓半夜{trick}", "【真人真事】我公司二十三樓半夜{trick}"])
	var _t341 = _s126["__p"]["T"]
	var _t349 = [_t340, _t342, J.cl(_t341, null, ["{v} 千人睇過", "{v} 千人看過"])]
	var _t344 = _s126["__p"]["T"]
	var _t346 = J.cl(_t344, null, ["Threads・熱門", "Threads・熱門"])
	var _t345 = _s126["__p"]["T"]
	var _t348 = J.cl(_t345, null, ["#二十三樓有鬼　{who}嘅反應笑死，但係……後面嗰個係咩？", "#二十三樓有鬼　{who}的反應笑死，但是……後面那個是什麼？"])
	var _t347 = _s126["__p"]["T"]
	var _t355 = [_t346, _t348, J.cl(_t347, null, ["{v} 萬瀏覽", "{v} 萬瀏覽"])]
	var _t350 = _s126["__p"]["T"]
	var _t352 = J.cl(_t350, null, ["晚間新聞", "晚間新聞"])
	var _t351 = _s126["__p"]["T"]
	var _t354 = J.cl(_t351, null, ["【獨家】商廈二十三樓夜半怪事頻生　員工：「{trick}，唔係講笑」", "【獨家】商廈二十三樓夜半怪事頻生　員工：「{trick}，不是開玩笑」"])
	var _t353 = _s126["__p"]["T"]
	var _t361 = [_t352, _t354, J.cl(_t353, null, ["記者現場直擊", "記者現場直擊"])]
	var _t356 = _s126["__p"]["T"]
	var _t358 = J.cl(_t356, null, ["全城熱話", "全城熱話"])
	var _t357 = _s126["__p"]["T"]
	var _t360 = J.cl(_t357, null, ["旅行團排隊參觀「二十三樓」，陳總：「門票收一百蚊」", "旅行團排隊參觀「二十三樓」，陳總：「門票收一百塊」"])
	var _t359 = _s126["__p"]["T"]
	v_P_284 = J.gp([_t343, _t349, _t355, _t361, [_t358, _t360, J.cl(_t359, null, ["{v} 萬人討論", "{v} 萬人討論"])]], J.sub(J.gp(v_after_275, "lv"), 1.0))
	v_fill_285 = Callable(self, "_f34").bind(_s126)
	var _t370 = null
	if J.t(J.gp(v_N_271, "nb")):
		var _t368 = _s126["__p"]["Lf"]
		var _t369 = _s126["__p"]["T"]
		_t370 = J.cl(_t368, null, [J.cl(_t369, null, ["無人信佢 ×{n}", "沒人信他 ×{n}"]), {"n": J.gp(v_N_271, "nb")}])
	else:
		_t370 = ""
	var _t373 = null
	if J.t(J.gp(v_N_271, "alone")):
		var _t371 = _s126["__p"]["Lf"]
		var _t372 = _s126["__p"]["T"]
		_t373 = J.cl(_t371, null, [J.cl(_t372, null, ["落單爆點 ×{n}", "落單爆點 ×{n}"]), {"n": J.gp(v_N_271, "alone")}])
	else:
		_t373 = ""
	var _t376 = null
	if J.t(J.gp(J.gp(v_N_271, "types"), "size")):
		var _t374 = _s126["__p"]["Lf"]
		var _t375 = _s126["__p"]["T"]
		_t376 = J.cl(_t374, null, [J.cl(_t375, null, ["招式 {n} 種", "招式 {n} 種"]), {"n": J.gp(J.gp(v_N_271, "types"), "size")}])
	else:
		_t376 = ""
	var _t381 = null
	if J.t(J.gp(v_N_271, "seen")):
		var _t377 = _s126["__p"]["Lf"]
		var _t378 = _s126["__p"]["T"]
		_t381 = J.cl(_t377, null, [J.cl(_t378, null, ["穿崩 ×{n}", "穿幫 ×{n}"]), {"n": J.gp(v_N_271, "seen")}])
	else:
		var _t379 = _s126["__p"]["Lx"]
		var _t380 = _s126["__p"]["T"]
		_t381 = J.cl(_t379, null, [J.cl(_t380, null, ["冇穿崩", "沒穿幫"])])
	var _t384 = null
	if J.t(J.gp(v_N_271, "inf")):
		var _t382 = _s126["__p"]["Lx"]
		var _t383 = _s126["__p"]["T"]
		_t384 = J.cl(_t382, null, [J.cl(_t383, null, ["嚇到靈探 KOL", "嚇到靈探 KOL"])])
	else:
		_t384 = ""
	var _t387 = null
	if J.t(J.gp(v_N_271, "filmed")):
		var _t385 = _s126["__p"]["Lx"]
		var _t386 = _s126["__p"]["T"]
		_t387 = J.cl(_t385, null, [J.cl(_t386, null, ["俾 KOL 拍到", "被 KOL 拍到"])])
	else:
		_t387 = ""
	var _t390 = null
	if J.t(J.gp(v_N_271, "stole")):
		var _t388 = _s126["__p"]["Lf"]
		var _t389 = _s126["__p"]["T"]
		_t390 = J.cl(_t388, null, [J.cl(_t389, null, ["Bryan 搶咗 {n} 次", "Bryan 搶了 {n} 次"]), {"n": J.gp(v_N_271, "stole")}])
	else:
		_t390 = ""
	var _t393 = null
	if J.t(J.gp(v_N_271, "bryanOut")):
		var _t391 = _s126["__p"]["Lx"]
		var _t392 = _s126["__p"]["T"]
		_t393 = J.cl(_t391, null, [J.cl(_t392, null, ["Bryan 穿崩走佬", "Bryan 穿幫溜走"])])
	else:
		_t393 = ""
	var _t394 = [_t370, _t373, _t376, _t381, _t384, _t387, _t390, _t393]
	var _t395 = J.mc(_t394, "filter", [J.G.get("Boolean")])
	v_extra_286 = J.mc(_t395, "join", ["・"])
	v_pct_287 = (J.round(J.num((J.div(J.sub(J.gp(v_after_275, "heat"), J.gp(v_after_275, "prev")), J.sub(J.gp(v_after_275, "next"), J.gp(v_after_275, "prev"))) * 100.0))) if J.t(J.gp(v_after_275, "next")) else 100.0)
	var _t396 = _s126["__p"]["Lx"]
	var _t397 = _s126["__p"]["T"]
	var _t400 = J.cl(_t396, null, [J.cl(_t397, null, ["都市傳說", "都市傳說"])])
	var _t401 = J.gp(v_after_275, "lv")
	var _t402 = J.gp(v_after_275, "name")
	var _t398 = _s126["__p"]["Lx"]
	var _t399 = _s126["__p"]["T"]
	var _t409 = J.cl(_t398, null, [J.cl(_t399, null, ["熱度", "熱度"])])
	var _t408 = null
	if J.t(v_up_276):
		var _t403 = _s126["__p"]["Lx"]
		var _t404 = _s126["__p"]["T"]
		var _t407 = J.cl(_t403, null, [J.cl(_t404, null, ["傳說升級！", "傳說升級！"])])
		var _t406 = null
		if J.t(J.gp(_s126["__p"]["LVTWIST"], J.sub(J.gp(v_after_275, "lv"), 1.0))):
			var _t405 = _s126["__p"]["Lx"]
			_t406 = J.cl(_t405, null, [J.gp(_s126["__p"]["LVTWIST"], J.sub(J.gp(v_after_275, "lv"), 1.0))])
		else:
			_t406 = ""
		_t408 = ("<p class=\"scl-up\">" + J.str(_t407) + J.str(_t406) + "</p>")
	else:
		_t408 = ""
	var _t410 = _s126["__p"]["Lx"]
	return ("<div class=\"sc-legend\"><div class=\"scl-h\"><b>" + J.str(_t400) + "　Lv" + J.str(_t401) + "「" + J.str(_t402) + "」</b><span>" + J.str(_t409) + " +" + J.str(v_heat_274) + "</span></div>\n      <div class=\"scl-bar\"><i style=\"width:" + J.str(v_pct_287) + "%\"></i></div>" + _t408 + "\n      <div class=\"scl-post\"><small>" + J.str(J.cl(_t410, null, [J.gp(v_P_284, 0.0)])) + "</small><p>" + J.str(J.cl(v_fill_285, null, [J.gp(v_P_284, 1.0)])) + "</p><small>" + J.str(J.cl(v_fill_285, null, [J.gp(v_P_284, 2.0)])) + "</small></div><p class=\"scl-x\">" + J.str(v_extra_286) + "</p></div>")

func _f36(this_, a: Array, env):
	var v_d_303 = null
	v_d_303 = J.arg(a, 0)
	return (not J.t(J.gp(v_d_303, "guard")))

func _f38(this_, a: Array, env):
	var v_d_305 = null
	v_d_305 = J.arg(a, 0)
	var _t412 = J.gp(v_d_305, "weak")
	return J.mc(_t412, "includes", [env["t"]])

func _f37(this_, a: Array, env):
	var _s135 = {"__p": env, "t": null}
	_s135["t"] = J.arg(a, 0)
	return J.len(J.mc(_s135["__p"]["npcs"], "filter", [Callable(self, "_f38").bind(_s135)]))

func _f40(this_, a: Array, env):
	var v_d_307 = null
	v_d_307 = J.arg(a, 0)
	var _t413 = J.gp(v_d_307, "immune")
	return J.mc(_t413, "includes", [env["t"]])

func _f39(this_, a: Array, env):
	var _s137 = {"__p": env, "t": null}
	_s137["t"] = J.arg(a, 0)
	return J.len(J.mc(_s137["__p"]["npcs"], "filter", [Callable(self, "_f40").bind(_s137)]))

func _f43(this_, a: Array, env):
	var v_t_314 = null
	v_t_314 = J.arg(a, 0)
	var _t426 = J.gp(env["d"], "hide")
	var _t427 = (_t426 if J.t(_t426) else [])
	var _t431 = J.mc(_t427, "includes", [v_t_314])
	if J.t(_t431):
		var _t428 = J.gp(J.G.get("Scare"), "known")
		var _t429 = J.gp((_t428 if J.t(_t428) else {}), J.gp(env["d"], "k"))
		var _t430 = (_t429 if J.t(_t429) else J.new_("Set", []))
		_t431 = (not J.t(J.mc(_t430, "has", [v_t_314])))
	return ("？" if J.t(_t431) else J.gp(J.G.get("FEAR_WORD"), v_t_314))

func _f42(this_, a: Array, env):
	var _s140 = {"__p": env, "d": null}
	_s140["d"] = J.arg(a, 0)
	var _t433 = J.gp(_s140["d"], "name")
	var _t425 = J.gp(_s140["d"], "weak")
	var _t432 = J.mc(_t425, "map", [Callable(self, "_f43").bind(_s140)])
	return ("<span><b>" + J.str(_t433) + "</b> 怕 " + J.str(J.mc(_t432, "join", ["、"])) + "</span>")

func _f45(this_, a: Array, env):
	var v_s_321 = null; var v_t_322 = null
	v_s_321 = J.arg(a, 0)
	v_t_322 = J.arg(a, 1)
	var _t437 = env["__p"]["weakCount"]
	return J.add(v_s_321, J.cl(_t437, null, [v_t_322]))

func _f46(this_, a: Array, env):
	var v_t_323 = null
	v_t_323 = J.arg(a, 0)
	var _t438 = env["__p"]["immCount"]
	return J.cmp(J.cl(_t438, null, [v_t_323]), 0.0, ">")

func _f47(this_, a: Array, env):
	var v_x_324 = null
	v_x_324 = J.arg(a, 0)
	return J.seq(J.gp(v_x_324, "k"), "afu")

func _f48(this_, a: Array, env):
	var v_t_325 = null
	v_t_325 = J.arg(a, 0)
	return J.gp(J.G.get("FEAR_WORD"), v_t_325)

func _f44(this_, a: Array, env):
	var v_k_315 = null; var v_fixed_316 = null; var v_g_317 = null; var v_ts_318 = null; var v_w_319 = null; var v_im_320 = null
	v_k_315 = J.arg(a, 0)
	v_fixed_316 = J.arg(a, 1)
	v_g_317 = J.gp(J.G.get("SCARE_GHOSTS"), v_k_315)
	var _t436 = J.gp(v_g_317, "types")
	v_ts_318 = (_t436 if J.t(_t436) else [J.gp(v_g_317, "type")])
	v_w_319 = J.mc(v_ts_318, "reduce", [Callable(self, "_f45").bind(env), 0.0])
	var _t439 = J.mc(v_ts_318, "every", [Callable(self, "_f46").bind(env)])
	v_im_320 = (J.seq(v_w_319, 0.0) if J.t(_t439) else _t439)
	var _t442 = ("on" if J.t((v_fixed_316 if J.t(v_fixed_316) else J.mc(env["__p"]["chosen"], "includes", [v_k_315]))) else "")
	var _t443 = ("good" if J.cmp(v_w_319, 2.0, ">=") else ("bad" if J.t(v_im_320) else ""))
	var _t444 = ("disabled" if J.t(v_fixed_316) else "")
	var _t445 = J.gp(v_g_317, "name")
	var _t446 = J.gp(v_g_317, "skill")
	var _t440 = env["__p"]["__p"]["Lx"]
	var _t441 = env["__p"]["__p"]["T"]
	var _t449 = J.cl(_t440, null, [J.cl(_t441, null, ["鬼力", "鬼力"])])
	var _t448 = null
	if J.seq(v_k_315, "afu"):
		var _t447 = J.gp(J.G.get("S"), "ghosts")
		_t448 = J.mc(J.G.get("GP"), "pow", [J.mc(_t447, "find", [Callable(self, "_f47").bind(env)])])
	else:
		_t448 = J.mc(J.G.get("GP"), "kindPow", [v_k_315])
	var _t450 = env["__p"]["__p"]["Lx"]
	var _t451 = env["__p"]["__p"]["T"]
	var _t453 = J.cl(_t450, null, [J.cl(_t451, null, ["驚嚇", "驚嚇"])])
	var _t452 = (1.0 + (0.35 * J.sub(J.mc(J.G.get("Scare"), "gpq", [v_k_315]), 1.0)))
	var _t455 = J.mc(_t452, "toFixed", [2.0])
	var _t454 = J.mc(v_ts_318, "map", [Callable(self, "_f48").bind(env)])
	var _t457 = J.mc(_t454, "join", ["／"])
	var _t458 = ("・全場" if J.t(J.gp(v_g_317, "aoe")) else "")
	var _t456 = J.gp(v_g_317, "cost")
	return ("<button class=\"sq-g " + _t442 + " " + _t443 + "\" data-k=\"" + J.str(v_k_315) + "\" " + _t444 + "><canvas data-por=\"" + J.str(v_k_315) + "\"></canvas><b>" + J.str(_t445) + "</b><small>" + J.str(_t446) + "</small><small class=\"gp-sub\">" + J.str(_t449) + " " + J.str(_t448) + "<br>" + J.str(_t453) + " ×" + J.str(_t455) + "</small><i>" + J.str(_t457) + _t458 + "・" + J.str((_t456 if J.t(_t456) else 35.0)) + "</i>" + (("<em>" + J.str(v_w_319) + "人怕</em>") if J.t(v_w_319) else "") + "</button>")

func _f49(this_, a: Array, env):
	var v_k_326 = null
	v_k_326 = J.arg(a, 0)
	var _t460 = env["card"]
	return J.cl(_t460, null, [v_k_326])

func _f50(this_, a: Array, env):
	var v_k_327 = null
	v_k_327 = J.arg(a, 0)
	return J.gp(J.gp(J.G.get("SCARE_GHOSTS"), v_k_327), "name")

func _f41(this_, a: Array, env):
	var v_best_308 = null; var v_st_309 = null; var v_lg_310 = null; var v_h_311 = null
	var _s139 = {"__p": env, "card": null}
	var _t414 = J.gp(J.G.get("S"), "scare")
	var _t415 = (J.gp(J.gp(J.gp(J.G.get("S"), "scare"), "best"), _s139["__p"]["siteId"]) if J.t(_t414) else _t414)
	v_best_308 = (_t415 if J.t(_t415) else 0.0)
	v_st_309 = J.mc(J.G.get("Scare"), "starsOf", [_s139["__p"]["siteId"], v_best_308])
	var _t416 = _s139["__p"]["__p"]["legend"]
	v_lg_310 = J.cl(_t416, null, [_s139["__p"]["siteId"]])
	var _t419 = J.gp(_s139["__p"]["site"], "name")
	var _t417 = _s139["__p"]["__p"]["Lf"]
	var _t418 = _s139["__p"]["__p"]["T"]
	v_h_311 = ("<p class=\"desc\">" + J.str(_t419) + "。" + J.str(J.cl(_t417, null, [J.cl(_t418, null, ["揀今晚帶邊幾隻鬼：招式啱佢哋怕嘅嘢，先嚇得到人。阿福一定去，另外最多帶{n}隻。", "選今晚帶哪幾隻鬼：招式對上他們怕的東西，才嚇得到人。阿福一定去，另外最多帶{n}隻。"]), {"n": J.gp(_s139["__p"]["__p"]["CN"], J.cl(_s139["__p"]["__p"]["maxSq"], null, []))}])) + "</p>")
	var _t422 = J.mc("★", "repeat", [v_st_309])
	var _t423 = J.mc("☆", "repeat", [J.sub(3.0, v_st_309)])
	var _t420 = _s139["__p"]["__p"]["Lx"]
	var _t421 = _s139["__p"]["__p"]["T"]
	var _t424 = J.add(v_h_311, ("<p class=\"desc\">最高紀錄：" + J.str(v_best_308) + "　" + J.str(_t422) + J.str(_t423) + "　｜　" + J.str(J.cl(_t420, null, [J.cl(_t421, null, ["都市傳說", "都市傳說"])])) + " Lv" + J.str(J.gp(v_lg_310, "lv")) + "「" + J.str(J.gp(v_lg_310, "name")) + "」</p>"))
	v_h_311 = _t424
	var _t434 = J.mc(_s139["__p"]["npcs"], "map", [Callable(self, "_f42").bind(_s139)])
	var _t435 = J.add(v_h_311, ("<div class=\"sq-who\">" + J.str(J.mc(_t434, "join", [""])) + "</div>"))
	v_h_311 = _t435
	_s139["card"] = Callable(self, "_f44").bind(_s139)
	var _t459 = _s139["card"]
	var _t462 = J.cl(_t459, null, ["afu", true])
	var _t461 = J.mc(_s139["__p"]["opts"], "map", [Callable(self, "_f49").bind(_s139)])
	var _t463 = J.add(v_h_311, ("<div class=\"sq-grid\">" + J.str(_t462) + J.str(J.mc(_t461, "join", [""])) + "</div>"))
	v_h_311 = _t463
	var _t464 = _s139["__p"]["__p"]["Lx"]
	var _t465 = _s139["__p"]["__p"]["T"]
	var _t468 = J.cl(_t464, null, [J.cl(_t465, null, ["已揀", "已選"])])
	var _t469 = J.len(_s139["__p"]["chosen"])
	var _t470 = J.cl(_s139["__p"]["__p"]["maxSq"], null, [])
	var _t466 = J.mc(_s139["__p"]["chosen"], "map", [Callable(self, "_f50").bind(_s139)])
	var _t467 = J.mc(_t466, "join", ["、"])
	var _t471 = J.add(v_h_311, ("<p class=\"desc\">" + J.str(_t468) + " " + J.str(_t469) + "/" + J.str(_t470) + "：" + J.str((_t467 if J.t(_t467) else "—")) + "</p>" + J.str((J.mc(J.G.get("Rework"), "kitHTML", []) if (not J.seq(J.typeof_(J.G.get("Rework")), "undefined")) else "")) + "<button class=\"btn gold wide\" id=\"sc-go\">出發，回陽間</button>"))
	v_h_311 = _t471
	return v_h_311

func _f53(this_, a: Array, env):
	var v_k_329 = null; var v_sc_330 = null
	v_k_329 = J.gp(J.gp(env["b"], "dataset"), "k")
	if J.t(J.mc(env["__p"]["chosen"], "includes", [v_k_329])):
		J.mc(env["__p"]["chosen"], "splice", [J.mc(env["__p"]["chosen"], "indexOf", [v_k_329]), 1.0])
	else:
		if J.cmp(J.len(env["__p"]["chosen"]), J.cl(env["__p"]["__p"]["maxSq"], null, []), "<"):
			J.mc(env["__p"]["chosen"], "push", [v_k_329])
		else:
			var _t479 = env["__p"]["__p"]["Lf"]
			var _t480 = env["__p"]["__p"]["T"]
			J.mc(J.G.get("Fx"), "toast", [J.cl(_t479, null, [J.cl(_t480, null, ["最多帶{n}隻", "最多帶{n}隻"]), {"n": J.gp(env["__p"]["__p"]["CN"], J.cl(env["__p"]["__p"]["maxSq"], null, []))}])])
			return null
	var _t481 = J.G.get("$")
	v_sc_330 = J.gp(J.cl(_t481, null, ["#sheet .sh-body"]), "scrollTop")
	var _t482 = J.G.get("$")
	var _t483 = J.cl(_t482, null, ["#sheet .sh-body"])
	var _t484 = J.cl(env["__p"]["render"], null, [])
	J.sp(_t483, "innerHTML", _t484)
	var _t485 = J.G.get("$")
	var _t486 = J.cl(_t485, null, ["#sheet .sh-body"])
	J.sp(_t486, "scrollTop", v_sc_330)
	J.cl(env["__p"]["bind"], null, [])

func _f52(this_, a: Array, env):
	var _s150 = {"__p": env, "b": null}
	_s150["b"] = J.arg(a, 0)
	var _t478 = _s150["b"]
	var _t487 = Callable(self, "_f53").bind(_s150)
	J.sp(_t478, "onclick", _t487)
	return _t487

func _f54(this_, a: Array, env):
	J.mc(env["__p"]["squad"], "set", [env["chosen"]])
	J.mc(J.G.get("UI"), "close", [])
	var _t491 = env["siteId"]
	var _t490 = ["afu"]
	J.mc(J.G.get("Scare"), "start", [_t491, J.mc(_t490, "concat", [J.mc(env["__p"]["squad"], "get", [])])])

func _f51(this_, a: Array, env):
	var _t472 = J.G.get("paintPortraits")
	var _t473 = J.G.get("$")
	J.cl(_t472, null, [J.cl(_t473, null, ["#sheet"])])
	if (not J.seq(J.typeof_(J.G.get("Rework")), "undefined")):
		var _t474 = J.G.get("$")
		J.mc(J.G.get("Rework"), "bindKit", [J.cl(_t474, null, ["#sheet"])])
	var _t475 = J.G.get("$")
	var _t476 = J.cl(_t475, null, ["#sheet"])
	var _t477 = J.mc(_t476, "querySelectorAll", [".sq-g:not([disabled])"])
	J.mc(_t477, "forEach", [Callable(self, "_f52").bind(env)])
	var _t488 = J.G.get("$")
	var _t489 = J.cl(_t488, null, ["#sc-go"])
	var _t492 = Callable(self, "_f54").bind(env)
	J.sp(_t489, "onclick", _t492)

func _f35(this_, a: Array, env):
	var _s133 = {"__p": env, "siteId": null, "site": null, "opts": null, "chosen": null, "npcs": null, "weakCount": null, "immCount": null, "render": null, "bind": null}
	_s133["siteId"] = J.arg(a, 0)
	J.mc(J.G.get("Scare"), "migrate", [])
	_s133["site"] = J.gp(J.G.get("SCARE_SITES"), _s133["siteId"])
	_s133["opts"] = J.cl(_s133["__p"]["owned"], null, [])
	_s133["chosen"] = J.mc(J.mc(_s133["__p"]["squad"], "get", []), "slice", [])
	var _t411 = J.gp(_s133["site"], "npcs")
	_s133["npcs"] = J.mc(_t411, "filter", [Callable(self, "_f36").bind(_s133)])
	_s133["weakCount"] = Callable(self, "_f37").bind(_s133)
	_s133["immCount"] = Callable(self, "_f39").bind(_s133)
	_s133["render"] = Callable(self, "_f41").bind(_s133)
	_s133["bind"] = Callable(self, "_f51").bind(_s133)
	J.mc(J.G.get("UI"), "sheet", ["回陽間・帶隊出更", J.cl(_s133["render"], null, [])])
	J.cl(_s133["bind"], null, [])

func _f2(this_, a: Array, env):
	var v_yue_28 = null; var v_zh_29 = null
	v_yue_28 = J.arg(a, 0)
	v_zh_29 = J.arg(a, 1)
	var _t493 = (not J.seq(J.typeof_(J.G.get("LANG")), "undefined"))
	if J.t((v_zh_29 if _t493 else _t493)):
		J.mc(J.G.get("LANG"), "add", [{J.key(v_yue_28): v_zh_29}])
	return v_yue_28

func _f3(this_, a: Array, env):
	var v_s_30 = null
	v_s_30 = J.arg(a, 0)
	var _t495 = null
	if J.seq(J.typeof_(J.G.get("L")), "function"):
		var _t494 = J.G.get("L")
		_t495 = J.cl(_t494, null, [v_s_30])
	else:
		_t495 = v_s_30
	return _t495

func _f4(this_, a: Array, env):
	var v_s_31 = null; var v_v_32 = null; var v_r_33 = null; var v_k_34 = null
	v_s_31 = J.arg(a, 0)
	v_v_32 = J.arg(a, 1)
	var _t496 = env["Lx"]
	v_r_33 = J.cl(_t496, null, [v_s_31])
	for _t497 in J.keys((v_v_32 if J.t(v_v_32) else {})):
		v_k_34 = _t497
		var _t498 = J.mc(v_r_33, "split", [(J.add("{", v_k_34) + "}")])
		var _t499 = J.mc(_t498, "join", [J.gp(v_v_32, v_k_34)])
		v_r_33 = _t499
	return v_r_33

func _f5(this_, a: Array, env):
	return J.S_Object_("keys", [J.G.get("SCARE_GHOSTS")])

func _f6(this_, a: Array, env):
	var _t527 = env["MAXSQ_BASE"]
	var _t526 = (not J.seq(J.typeof_(J.G.get("Presence")), "undefined"))
	return J.add(_t527, (J.mc(J.G.get("Presence"), "perk", ["squad"]) if J.t((J.gp(J.G.get("Presence"), "perk") if _t526 else _t526)) else 0.0))

func _f7(this_, a: Array, env):
	var v_ks_48 = null; var v_g_49 = null
	var _t528 = J.seq(J.typeof_(J.G.get("S")), "undefined")
	var _t529 = (_t528 if _t528 else (not J.t(J.G.get("S"))))
	if (_t529 if _t529 else (not J.t(J.gp(J.G.get("S"), "ghosts")))):
		return []
	v_ks_48 = []
	for _t530 in J.iter(J.gp(J.G.get("S"), "ghosts")):
		v_g_49 = _t530
		var _t531 = (not J.seq(J.gp(v_g_49, "k"), "afu"))
		var _t532 = (J.gp(J.G.get("SCARE_GHOSTS"), J.gp(v_g_49, "k")) if _t531 else _t531)
		if J.t(((not J.t(J.mc(v_ks_48, "includes", [J.gp(v_g_49, "k")]))) if J.t(_t532) else _t532)):
			J.mc(v_ks_48, "push", [J.gp(v_g_49, "k")])
	return v_ks_48

func _f9(this_, a: Array, env):
	var v_k_54 = null
	v_k_54 = J.arg(a, 0)
	return J.mc(env["o"], "includes", [v_k_54])

func _f10(this_, a: Array, env):
	var v_k_55 = null
	v_k_55 = J.arg(a, 0)
	return J.mc(env["o"], "includes", [v_k_55])

func _f8(this_, a: Array, env):
	var v_s_53 = null
	var _s13 = {"__p": env, "o": null}
	_s13["o"] = J.cl(_s13["__p"]["owned"], null, [])
	var _t533 = (not J.seq(J.typeof_(J.G.get("S")), "undefined"))
	var _t534 = (J.G.get("S") if _t533 else _t533)
	var _t535 = (J.gp(J.G.get("S"), "scareSquad") if J.t(_t534) else _t534)
	v_s_53 = (_t535 if J.t(_t535) else null)
	if (not J.t(v_s_53)):
		var _t536 = ["tianhua", "pontianak"]
		var _t537 = J.mc(_t536, "filter", [Callable(self, "_f9").bind(_s13)])
		v_s_53 = _t537
	var _t538 = J.mc(v_s_53, "filter", [Callable(self, "_f10").bind(_s13)])
	var _t539 = J.mc(_t538, "slice", [0.0, J.cl(_s13["__p"]["maxSq"], null, [])])
	v_s_53 = _t539
	if (not J.t(J.len(v_s_53))):
		var _t540 = J.mc(_s13["o"], "slice", [0.0, 2.0])
		v_s_53 = _t540
	return v_s_53

func _f12(this_, a: Array, env):
	var v_k_60 = null; var v_i_61 = null; var v_a_62 = null
	v_k_60 = J.arg(a, 0)
	v_i_61 = J.arg(a, 1)
	v_a_62 = J.arg(a, 2)
	var _t544 = (not J.seq(v_k_60, "afu"))
	var _t545 = (J.mc(env["o"], "includes", [v_k_60]) if _t544 else _t544)
	return (J.seq(J.mc(v_a_62, "indexOf", [v_k_60]), v_i_61) if J.t(_t545) else _t545)

func _f11(this_, a: Array, env):
	var v_ids_58 = null
	var _s16 = {"__p": env, "o": null}
	v_ids_58 = J.arg(a, 0)
	var _t541 = J.seq(J.typeof_(J.G.get("S")), "undefined")
	if (_t541 if _t541 else (not J.t(J.G.get("S")))):
		return []
	_s16["o"] = J.cl(_s16["__p"]["owned"], null, [])
	var _t542 = J.G.get("S")
	var _t543 = (v_ids_58 if J.t(v_ids_58) else [])
	var _t546 = J.mc(_t543, "filter", [Callable(self, "_f12").bind(_s16)])
	var _t547 = J.mc(_t546, "slice", [0.0, J.cl(_s16["__p"]["maxSq"], null, [])])
	J.sp(_t542, "scareSquad", _t547)
	if J.seq(J.typeof_(J.G.get("save")), "function"):
		J.cl(J.G.get("save"), null, [])
	return J.mc(J.gp(J.G.get("S"), "scareSquad"), "slice", [])

func _f13(this_, a: Array, env):
	var _t548 = ["afu"]
	return J.mc(_t548, "concat", [J.mc(this_, "get", [])])

func _f15(this_, a: Array, env):
	var v_weak_70 = null
	v_weak_70 = J.arg(a, 0)
	var _t565 = env["T"]
	var _t567 = J.cl(_t565, null, ["靈探KOL・Kiki", "靈探KOL・Kiki"])
	var _t566 = env["T"]
	var _t579 = J.cl(_t566, null, ["追鬼直播主・二十萬訂閱", "追鬼直播主・二十萬訂閱"])
	var _t580 = [J.mc(J.G.get("OFFMAP"), "M", [0.4]), 0.88, "film"]
	var _t581 = [7.0, 11.0]
	var _t569 = J.gp(J.gp(J.G.get("OFFMAP"), "SPOT"), "micro")
	var _t570 = [5.0, 8.0]
	var _t568 = env["T"]
	var _t574 = ["pantry", 2.0, _t569, _t570, J.cl(_t568, null, ["呢度係茶水間，聽講微波爐會自己叮……", "這裡是茶水間，聽說微波爐會自己叮……"])]
	var _t572 = J.gp(J.gp(J.G.get("OFFMAP"), "SPOT"), "seat2")
	var _t573 = [5.0, 8.0]
	var _t571 = env["T"]
	var _t578 = ["meeting", 2.0, _t572, _t573, J.cl(_t571, null, ["會議室冇人，我哋入去睇睇。", "會議室沒人，我們進去看看。"])]
	var _t576 = J.gp(J.gp(J.G.get("OFFMAP"), "SPOT"), "bossVisit")
	var _t577 = [5.0, 8.0]
	var _t575 = env["T"]
	var _t587 = [_t574, _t578, ["boss", 1.5, _t576, _t577, J.cl(_t575, null, ["老細房，噓……", "老闆房，噓……"])]]
	var _t582 = env["T"]
	var _t584 = J.cl(_t582, null, ["大家記得 like 同 share！", "大家記得按讚分享！"])
	var _t583 = env["T"]
	var _t586 = J.cl(_t583, null, ["（對住手機）你哋聽唔聽到？", "（對著手機）你們聽到嗎？"])
	var _t585 = env["T"]
	var _t605 = {"work": [_t584, _t586, J.cl(_t585, null, ["留言話見到嘢？邊度邊度？", "留言說看到東西？哪裡哪裡？"])]}
	var _t606 = [v_weak_70]
	var _t607 = ["light", "cold", "breath"]
	var _t608 = [[J.mc(J.G.get("OFFMAP"), "M", [0.4]), 0.88, 6.0, "film"]]
	var _t588 = env["T"]
	var _t592 = J.cl(_t588, null, ["（對住鏡頭）呢啲效果做得唔錯喎。", "（對著鏡頭）這效果做得不錯嘛。"])
	var _t589 = env["T"]
	var _t591 = J.cl(_t589, null, ["應該係光暗問題。", "應該是光線問題。"])
	var _t590 = env["T"]
	var _t594 = [_t591, J.cl(_t590, null, ["呢條片一定爆！", "這條片一定爆！"])]
	var _t593 = env["T"]
	var _t598 = [J.cl(_t593, null, ["等陣……你哋見唔見到？！", "等等……你們看到了嗎？！"])]
	var _t595 = env["T"]
	var _t597 = J.cl(_t595, null, ["有嘢！真係有嘢！", "有東西！真的有東西！"])
	var _t596 = env["T"]
	var _t600 = [_t597, J.cl(_t596, null, ["（手機都跌埋）", "（手機都掉了）"])]
	var _t599 = env["T"]
	var _t602 = J.cl(_t599, null, ["（直播畫面突然雪花）", "（直播畫面突然雪花）"])
	var _t601 = env["T"]
	var _t604 = J.cl(_t601, null, ["直播完——！走——！", "直播結束——！快走——！"])
	var _t603 = env["T"]
	var _t614 = {"immune": _t592, "rational": _t594, "prime": _t598, "hit": _t600, "weak": _t602, "shout": _t604, "flee": J.cl(_t603, null, ["Kiki 一路尖叫一路直播衝入電梯，條片一晚三百萬 view。", "Kiki 一路尖叫一路直播衝進電梯，影片一晚三百萬觀看。"])}
	var _t609 = env["T"]
	var _t611 = ["Kiki", "23:50", J.cl(_t609, null, ["今晚探二十三樓！留言話見到咩就講！", "今晚探二十三樓！看到什麼就留言！"])]
	var _t610 = env["T"]
	var _t613 = ["觀眾", "00:12", J.cl(_t610, null, ["後面！後面！", "後面！後面！"])]
	var _t612 = env["T"]
	return {"k": "kol", "name": _t567, "role": _t579, "spr": "npc_it", "tint": "hue-rotate(155deg) saturate(1.25)", "speed": 0.07, "influencer": true, "phone": true, "post": _t580, "work": _t581, "trips": _t587, "lines": _t605, "calm": 4.0, "weak": _t606, "immune": _t607, "karma": 0.0, "route": _t608, "say": _t614, "chat": [_t611, _t613, ["Kiki", "00:13", J.cl(_t612, null, ["邊度？！", "哪裡？！"])]]}

func _f1(this_, a: Array, env):
	var v_SIG_5 = null; var v_TIERV_6 = null; var v_ALL_7 = null; var v_night_19 = null; var v_onHit_20 = null; var v_tick_22 = null; var v_draw_24 = null; var v_sigFx_25 = null; var v_finish_26 = null; var v_open_27 = null; var v_k_35 = null; var v_ty_36 = null; var v_fx_37 = null; var v_col_38 = null; var v_skill_39 = null; var v_yue_40 = null; var v_zh_41 = null; var v_aoe_42 = null; var v_tier_43 = null; var v_base_44 = null; var v_cost_45 = null; var v_types_46 = null; var v_name_47 = null
	var _s2 = {"__p": env, "T": null, "Lx": null, "Lf": null, "CN": null, "MAXSQ_BASE": null, "maxSq": null, "owned": null, "squad": null, "LV": null, "LVNAME": null, "LVTWIST": null, "legend": null, "KOL": null, "rng": null, "bryanSay": null, "resolve": null}
	_s2["legend"] = Callable(self, "_f14").bind(_s2)
	_s2["rng"] = Callable(self, "_f16").bind(_s2)
	v_night_19 = Callable(self, "_f18").bind(_s2)
	v_onHit_20 = Callable(self, "_f19").bind(_s2)
	_s2["bryanSay"] = Callable(self, "_f20").bind(_s2)
	v_tick_22 = Callable(self, "_f21").bind(_s2)
	_s2["resolve"] = Callable(self, "_f26").bind(_s2)
	v_draw_24 = Callable(self, "_f29").bind(_s2)
	v_sigFx_25 = Callable(self, "_f30").bind(_s2)
	v_finish_26 = Callable(self, "_f33").bind(_s2)
	v_open_27 = Callable(self, "_f35").bind(_s2)
	_s2["T"] = Callable(self, "_f2").bind(_s2)
	_s2["Lx"] = Callable(self, "_f3").bind(_s2)
	_s2["Lf"] = Callable(self, "_f4").bind(_s2)
	v_SIG_5 = {"toyol": ["sound", "coins", "#f0d060", "偷散紙", "（櫃桶啲散紙自己跳出嚟，叮叮噹噹）", "（抽屜的零錢自己跳出來，叮叮噹噹）"], "pocong": ["shadow", "shadow", "#e8e8f0", "布包跳", "（白布包喺佢後面一跳、一跳咁經過）", "（白布包在他身後一跳、一跳地經過）"], "mengpo": ["breath", "smoke", "#cfe8d8", "孟婆湯", "（佢杯茶變咗一碗冒煙嘅湯：「飲啦，飲完乜都唔記得。」）", "（他的茶變成一碗冒煙的湯：「喝吧，喝完什麼都忘了。」）"], "baiwu": ["face", "tongue", "#ffffff", "一見生財", "（長舌由天花垂落嚟：「一見生財～」）", "（長舌從天花板垂下：「一見生財～」）"], "heiwu": ["sound", "bones", "#9aa0b8", "鐵鏈拖地", "（背後傳嚟鐵鏈拖地聲：噹啷——噹啷——）", "（背後傳來鐵鏈拖地聲：噹啷——噹啷——）"], "n30_qionggui": ["paper", "coins", "#e8dcc0", "借錢單", "（一張張欠單飛埋嚟：「借我十蚊……」）", "（一張張欠單飛過來：「借我十塊……」）"], "n30_danxiao": ["sound", "scream", "#ffd0d0", "自己先嚇親", "（隻鬼自己先嗌：「呀——！有人呀！」）", "（那隻鬼自己先尖叫：「啊——！有人啊！」）"], "n30_maoshi": ["sound", "thump", "#d8c8a8", "跌爛嘢", "（成疊文件夾「乒乒乓乓」跌落地）", "（一疊文件夾「乒乒乓乓」掉到地上）"], "n30_yangui": ["breath", "smoke", "#b0b0b0", "二手煙", "（無端端一陣煙味，耳邊有人咳：咳咳咳）", "（突然一陣煙味，耳邊有人咳：咳咳咳）"], "n30_jiugui": ["breath", "smoke", "#e8a0a0", "一陣酒氣", "（耳邊一陣酒氣：「飲多杯啦……」）", "（耳邊一陣酒氣：「再喝一杯嘛……」）"], "n30_dugui": ["sound", "coins", "#ffe080", "擲骰仔", "（枱面骰仔自己轉：「大！大！大！」）", "（桌上骰子自己轉：「大！大！大！」）"], "n30_guhangui": ["light", "dark", "#202030", "熄燈慳電", "（「咁嘥電！」佢頭頂盞燈「啪」一聲熄咗）", "（「這麼浪費電！」他頭上的燈「啪」一聲熄了）"], "n30_taozhai": ["phone", "phone", "#ff9a7a", "追數電話", "（電話響：「你仲欠我三萬蚊……」）", "（電話響：「你還欠我三萬塊……」）"], "n30_diaosi": ["face", "tongue", "#ff6a7a", "長舌", "（一條長舌由天花垂到佢面前）", "（一條長舌從天花板垂到他面前）"], "n30_wutou": ["face", "copier", "#e0f0ff", "影印個頭", "（影印機玻璃上面，印咗個頭出嚟）", "（影印機玻璃上，印出了一個頭）"], "n30_changgui": ["sound", "whisper", "#c0d0ff", "叫你過去", "（有人輕輕叫佢個名：「過嚟呀……」）", "（有人輕輕叫他的名字：「過來呀……」）"], "n30_guixinniang": ["face", "veil", "#ff4a5a", "紅蓋頭", "（一塊紅蓋頭飄落佢個頭度）", "（一塊紅蓋頭飄落在他頭上）"], "n30_baigujing": ["face", "bones", "#f0ecd8", "杯中白骨", "（佢杯茶浮起一隻手指骨）", "（他的茶裡浮起一節指骨）"], "n30_shanxiao": ["sound", "thump", "#a08060", "單腳跳", "（天花板：咚、咚、咚，有人單腳跳）", "（天花板：咚、咚、咚，有人單腳跳）"], "n30_yecha": ["face", "flash", "#60e0a0", "青面獠牙", "（螢幕反光入面，多咗塊青面獠牙）", "（螢幕倒影裡，多了一張青面獠牙）"], "n30_hanba": ["light", "heat", "#ff8040", "大旱", "（冷氣停咗，佢周圍熱到冒煙）", "（冷氣停了，他周圍熱得冒煙）"], "n30_pelesit": ["sound", "whisper", "#b0e070", "蟋蟀叫", "（耳邊「唧唧唧」，越嚟越近）", "（耳邊「唧唧唧」，越來越近）"], "n30_polong": ["shadow", "smoke", "#a070d0", "樽入面有嘢", "（佢個水樽入面，有樣嘢郁咗一下）", "（他的水瓶裡，有東西動了一下）"], "n30_jenglot": ["face", "hair", "#3a2a20", "長指甲", "（鍵盤罅隙伸出幾隻長指甲）", "（鍵盤縫裡伸出幾根長指甲）"], "n30_hantugalah": ["shadow", "shadow", "#101018", "竹竿影", "（佢後面一條好高好高嘅影）", "（他身後一條很高很高的影子）"], "n30_jerangkung": ["sound", "bones", "#e8e0c8", "骨頭聲", "（咔、咔、咔，好似有人喺度郁骨）", "（咔、咔、咔，像有人在活動骨頭）"], "n30_bunian": ["sound", "whisper", "#a0f0c0", "隱形人傾偈", "（空嘅位傳出有人傾偈同笑聲）", "（空位置傳來有人聊天和笑聲）"], "n30_hanturaya": ["shadow", "shadow", "#000000", "影大咗兩倍", "（佢個影突然大咗兩倍，仲識自己郁）", "（他的影子突然大了兩倍，還會自己動）"], "n30_genderuwo": ["breath", "smoke", "#806048", "毛手", "（後頸俾一隻毛手掃咗一下）", "（後頸被一隻毛手掃了一下）"], "n30_phiam": ["breath", "smoke", "#7080a0", "壓胸口", "（胸口突然好重，透唔到氣）", "（胸口突然好重，喘不過氣）"], "n30_churel": ["shadow", "prints", "#c0a0ff", "倒轉腳印", "（地上一行濕腳印，腳趾向後）", "（地上一行濕腳印，腳趾朝後）"], "n30_tikbalang": ["sound", "thump", "#c09060", "馬蹄聲", "（走廊傳嚟馬蹄聲：躂躂、躂躂）", "（走廊傳來馬蹄聲：噠噠、噠噠）"], "n30_maenak": ["phone", "phone", "#ffb0d0", "鬼妻來電", "（電話：「老公，幾時返屋企呀……」）", "（電話：「老公，什麼時候回家呀……」）"], "n30_aswang": ["shadow", "shadow", "#302040", "影變大鳥", "（佢個影變咗一隻大鳥，拍一拍翼）", "（他的影子變成一隻大鳥，拍了拍翅膀）"], "n30_vetala": ["face", "hair", "#90a0b0", "倒吊", "（一個人倒吊喺佢面前，望住佢笑）", "（一個人倒吊在他面前，看著他笑）"], "n30_banshee": ["sound", "scream", "#d0e0ff", "報喪", "（窗外一聲好長好長嘅尖叫）", "（窗外一聲好長好長的尖叫）", true], "n30_kasaobake": ["shadow", "shadow", "#704030", "單腳傘", "（一把舊遮自己喺佢身邊跳過）", "（一把舊傘自己在他身邊跳過）"], "n30_chochin": ["light", "flash", "#ffa040", "燈籠口", "（檯燈變咗個開大口嘅燈籠）", "（檯燈變成一個張大嘴的燈籠）"], "n30_kappa": ["cold", "drip", "#80c0ff", "天花漏水", "（天花一滴一滴凍水滴落佢頭頂）", "（天花板一滴一滴冰水滴到他頭上）"], "n30_nopperabo": ["face", "screen", "#ffffff", "冇面", "（佢手機自拍鏡頭入面，佢自己冇咗塊面）", "（他手機自拍鏡頭裡，他自己沒有臉）"], "n30_rokurokubi": ["face", "hair", "#2a2020", "長頸", "（屏風後面伸出一條好長好長嘅頸）", "（屏風後面伸出一條很長很長的脖子）"], "n30_kuchisake": ["paper", "snip", "#e0e0e0", "較剪自己剪", "（枱上把較剪自己「咔嚓、咔嚓」）", "（桌上的剪刀自己「咔嚓、咔嚓」）"], "n30_yukionna": ["cold", "frost", "#d0f0ff", "凍咖啡", "（佢杯咖啡一秒結冰）", "（他的咖啡一秒結冰）"], "n30_hannya": ["face", "flash", "#ff6060", "般若面", "（玻璃反光：一塊長角嘅面）", "（玻璃反光：一張長角的臉）"], "n30_gashadokuro": ["shadow", "shadow", "#e8e0d0", "巨型骷髏手", "（窗外一隻巨型骷髏手慢慢掃過）", "（窗外一隻巨大的骷髏手慢慢掃過）"], "n30_zipai": ["phone", "screen", "#80d0ff", "自拍多個人", "（佢部手機自己開咗自拍，背後多咗個人）", "（他的手機自己開了自拍，背後多了一個人）"], "n30_xiaosi": ["sound", "laugh", "#ffe080", "罐頭笑聲", "（附近傳出罐頭笑聲：「哈哈哈哈哈」）", "（附近傳出罐頭笑聲：「哈哈哈哈哈」）"], "n30_yesi": ["sound", "pop", "#ffffff", "彈湯圓", "（微波爐「噗」一聲，彈咗粒湯圓出嚟）", "（微波爐「噗」一聲，彈出一顆湯圓）"], "n30_shidu": ["breath", "smoke", "#a0d070", "餿飯盒", "（雪櫃傳出一陣餿味）", "（冰箱傳出一陣餿味）"], "n30_daji": ["light|phone", "screen", "#ff5050", "GAME OVER", "（電腦突然彈出 GAME OVER：「再嚟一局？」）", "（電腦突然跳出 GAME OVER：「再來一局？」）"], "n30_xiasi": ["face", "flash", "#ffffff", "突然大叫", "（一塊驚到變形嘅面彈出嚟：「哇！」）", "（一張嚇到變形的臉彈出來：「哇！」）"], "n30_chehuo": ["light", "flash", "#fff8c0", "車頭燈", "（一對車頭燈喺走廊照過嚟）", "（一對車頭燈從走廊照過來）"], "n30_yezi": ["sound", "thump", "#a07040", "跌椰子", "（「咚！」天花跌咗粒椰子落嚟）", "（「咚！」天花板掉下一顆椰子）"], "n30_liulian": ["breath", "smoke", "#e0d060", "榴槤味", "（成間房突然一陣榴槤味）", "（整個房間突然一陣榴槤味）"], "n30_zhongshu": ["light", "heat", "#ff6030", "熱浪", "（佢周圍熱到冒煙，燈都閃埋）", "（他周圍熱得冒煙，燈也在閃）"], "n30_chengsi": ["sound", "pop", "#ffd0a0", "打嗝", "（一個好大嘅嗝喺佢耳邊：嗝——）", "（一個很大的嗝在他耳邊：嗝——）"], "n30_shedu": ["shadow", "shadow", "#304020", "蛇影", "（地上條電線好似蛇咁郁咗一下）", "（地上的電線像蛇一樣動了一下）"], "n30_diansi": ["light", "spark", "#80e0ff", "插蘇火花", "（拖板「啪」一聲噴火花）", "（插座「啪」一聲噴出火花）"], "n30_dongsi": ["cold", "frost", "#c0e8ff", "螢幕結霜", "（佢個螢幕結晒霜）", "（他的螢幕結滿了霜）"], "n30_leipi": ["light", "flash", "#ffffff", "閃電", "（窗外一下閃電，照到佢後面有人）", "（窗外一道閃電，照出他身後有人）"], "n30_xiangcai": ["paper", "snip", "#f0e8d0", "扁人", "（一張扁扁嘅「人」由門罅滑咗入嚟）", "（一張扁扁的「人」從門縫滑了進來）"], "youhun": ["breath", "smoke", "#c8d8ff", "飄過", "（一陣涼風由佢身邊飄過）", "（一陣涼風從他身邊飄過）"], "zhiren": ["paper", "snip", "#f0e0c0", "紙人企起身", "（枱面張紙自己摺咗個紙人企起身）", "（桌上的紙自己摺成一個紙人站起來）"], "egui": ["sound", "pop", "#ffd080", "偷食", "（佢個飯盒自己「咔嚓咔嚓」開咗）", "（他的飯盒自己「咔嚓咔嚓」打開了）"], "xiaogui": ["sound", "laugh", "#ffc0c0", "細路笑聲", "（枱底傳出細路仔笑聲：「嘻嘻」）", "（桌底傳出小孩笑聲：「嘻嘻」）"], "zombie": ["shadow", "thump", "#80a080", "一跳一跳", "（玻璃門外：一跳、一跳、一跳）", "（玻璃門外：一跳、一跳、一跳）"], "shuigui": ["cold", "drip", "#60a0d0", "濕腳印", "（地上一行濕腳印，凍冰冰）", "（地上一行濕腳印，冰冰涼涼）"]}
	v_TIERV_6 = {"1": [30.0, 30.0], "2": [34.0, 35.0], "3": [38.0, 40.0]}
	for _t500 in J.keys(v_SIG_5):
		v_k_35 = _t500
		var _t501 = J.gp(v_SIG_5, v_k_35)
		var _t502 = J.gp(_t501, 0.0)
		v_ty_36 = _t502
		var _t503 = J.gp(_t501, 1.0)
		v_fx_37 = _t503
		var _t504 = J.gp(_t501, 2.0)
		v_col_38 = _t504
		var _t505 = J.gp(_t501, 3.0)
		v_skill_39 = _t505
		var _t506 = J.gp(_t501, 4.0)
		v_yue_40 = _t506
		var _t507 = J.gp(_t501, 5.0)
		v_zh_41 = _t507
		var _t508 = J.gp(_t501, 6.0)
		v_aoe_42 = _t508
		var _t509 = J.mc(v_k_35, "startsWith", ["n30_"])
		var _t510 = ((not J.seq(J.typeof_(J.G.get("N30_G")), "undefined")) if J.t(_t509) else _t509)
		v_tier_43 = (J.gp(J.gp(J.G.get("N30_G"), v_k_35), "t") if J.t((J.gp(J.G.get("N30_G"), v_k_35) if J.t(_t510) else _t510)) else (0.0 if J.has((J.G.get("FODDER") if (not J.seq(J.typeof_(J.G.get("FODDER")), "undefined")) else {}), v_k_35) else 2.0))
		var _t511 = (J.gp(v_TIERV_6, v_tier_43) if J.t(v_tier_43) else [26.0, 28.0])
		var _t512 = J.gp(_t511, 0.0)
		v_base_44 = _t512
		var _t513 = J.gp(_t511, 1.0)
		v_cost_45 = _t513
		v_types_46 = J.mc(v_ty_36, "split", ["|"])
		var _t514 = (not J.seq(J.typeof_(J.G.get("GHOSTS")), "undefined"))
		var _t515 = (J.gp(J.G.get("GHOSTS"), v_k_35) if _t514 else _t514)
		var _t518 = (J.gp(J.gp(J.G.get("GHOSTS"), v_k_35), "name") if J.t(_t515) else _t515)
		if not J.t(_t518):
			var _t516 = (not J.seq(J.typeof_(J.G.get("FODDER")), "undefined"))
			var _t517 = (J.gp(J.G.get("FODDER"), v_k_35) if _t516 else _t516)
			_t518 = (J.gp(J.gp(J.G.get("FODDER"), v_k_35), "name") if J.t(_t517) else _t517)
		v_name_47 = (_t518 if J.t(_t518) else v_k_35)
		var _t519 = J.G.get("SCARE_GHOSTS")
		var _t521 = J.gp(v_types_46, 0.0)
		var _t522 = (v_types_46 if (J.len(v_types_46) > 1.0) else null)
		var _t523 = (15.0 if J.t(v_aoe_42) else v_base_44)
		var _t524 = (34.0 if J.t(v_aoe_42) else v_cost_45)
		var _t520 = _s2["T"]
		var _t525 = {"name": v_name_47, "skill": v_skill_39, "type": _t521, "types": _t522, "base": _t523, "cost": _t524, "line": J.cl(_t520, null, [v_yue_40, v_zh_41]), "aoe": (not (not J.t(v_aoe_42))), "fx": v_fx_37, "col": v_col_38, "fxText": v_skill_39}
		J.sp(_t519, v_k_35, _t525)
	v_ALL_7 = Callable(self, "_f5").bind(_s2)
	_s2["CN"] = ["零", "一", "兩", "三", "四", "五", "六"]
	_s2["MAXSQ_BASE"] = 3.0
	_s2["maxSq"] = Callable(self, "_f6").bind(_s2)
	_s2["owned"] = Callable(self, "_f7").bind(_s2)
	_s2["squad"] = {"options": _s2["owned"], "get": Callable(self, "_f8").bind(_s2), "set": Callable(self, "_f11").bind(_s2), "team": Callable(self, "_f13").bind(_s2)}
	_s2["LV"] = [0.0, 40.0, 110.0, 220.0, 380.0]
	var _t549 = _s2["T"]
	var _t551 = J.cl(_t549, null, ["二十三樓有鬼", "二十三樓有鬼"])
	var _t550 = _s2["T"]
	var _t553 = J.cl(_t550, null, ["公司群組傳開", "公司群組傳開"])
	var _t552 = _s2["T"]
	var _t555 = J.cl(_t552, null, ["網上瘋傳", "網上瘋傳"])
	var _t554 = _s2["T"]
	var _t557 = J.cl(_t554, null, ["上咗新聞", "上了新聞"])
	var _t556 = _s2["T"]
	_s2["LVNAME"] = [_t551, _t553, _t555, _t557, J.cl(_t556, null, ["全城都市傳說", "全城都市傳說"])]
	var _t558 = _s2["T"]
	var _t560 = J.cl(_t558, null, ["員工一開工已經心緒不寧", "員工一上班就心神不寧"])
	var _t559 = _s2["T"]
	var _t562 = J.cl(_t559, null, ["靈探 KOL 上嚟直播捉鬼", "靈探 KOL 上來直播抓鬼"])
	var _t561 = _s2["T"]
	var _t564 = J.cl(_t561, null, ["道士早啲到", "道士會早點到"])
	var _t563 = _s2["T"]
	_s2["LVTWIST"] = [null, _t560, _t562, _t564, J.cl(_t563, null, ["全城注目：熱度加兩成", "全城注目：熱度加兩成"])]
	_s2["KOL"] = Callable(self, "_f15").bind(_s2)
	var _t615 = J.G.get("Scare")
	var _t616 = _s2["squad"]
	J.sp(_t615, "squad", _t616)
	var _t617 = J.G.get("Scare")
	var _t618 = _s2["legend"]
	J.sp(_t617, "legend", _t618)
	return {"SIG": v_SIG_5, "open": v_open_27, "night": v_night_19, "tick": v_tick_22, "onHit": v_onHit_20, "draw": v_draw_24, "sigFx": v_sigFx_25, "finish": v_finish_26, "legend": _s2["legend"], "squad": _s2["squad"], "KOL": _s2["KOL"]}
