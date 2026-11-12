# 自動轉譯自 sports.js（tools/jsgd.js）——唔好直接改，改原 JS 再轉
extends RefCounted

func run(env):
	var this_ = null; var a = []
	J.G["Sports"] = J.cl(Callable(self, "_f1").bind(env), null, [])

func _f6(this_, a: Array, env):
	if (not J.t(J.gp(J.G.get("S"), "sports"))):
		var _t1 = J.G.get("S")
		var _t2 = {"best": {}, "won": {}, "plays": 0.0}
		J.sp(_t1, "sports", _t2)
	var _t3 = J.gp(J.G.get("S"), "sports")
	var _t4 = J.gp(J.gp(J.G.get("S"), "sports"), "best")
	var _t5 = (_t4 if J.t(_t4) else {})
	J.sp(_t3, "best", _t5)
	var _t6 = J.gp(J.G.get("S"), "sports")
	var _t7 = J.gp(J.gp(J.G.get("S"), "sports"), "won")
	var _t8 = (_t7 if J.t(_t7) else {})
	J.sp(_t6, "won", _t8)
	return J.gp(J.G.get("S"), "sports")

func _f7(this_, a: Array, env):
	var v_ms_45 = null; var v_d_46 = null
	v_ms_45 = J.S_Date_("now", [])
	v_d_46 = J.new_("Date", [v_ms_45])
	return floor(J.num(J.div(J.sub(v_ms_45, J.mul(J.mc(v_d_46, "getTimezoneOffset", []), 60000.0)), env["DAY"])))

func _f8(this_, a: Array, env):
	var v_seed_49 = null; var v_a_50 = null; var v_t_51 = null
	v_seed_49 = J.arg(a, 0)
	v_a_50 = J.bor(v_seed_49, 0.0)
	var _t9 = J.bor(J.add(v_a_50, 1831565813.0), 0.0)
	v_a_50 = _t9
	v_t_51 = J.math("imul", [J.bxor(v_a_50, J.ushr(v_a_50, 15.0)), J.bor(1.0, v_a_50)])
	var _t10 = J.bxor(J.add(v_t_51, J.math("imul", [J.bxor(v_t_51, J.ushr(v_t_51, 7.0)), J.bor(61.0, v_t_51)])), v_t_51)
	v_t_51 = _t10
	return J.div(J.ushr(J.bxor(v_t_51, J.ushr(v_t_51, 14.0)), 0.0), 4294967296.0)

func _f9(this_, a: Array, env):
	var v_id_54 = null; var v_r_55 = null
	v_id_54 = J.arg(a, 0)
	var _t11 = env["rnd"]
	v_r_55 = J.cl(_t11, null, [(J.mul(J.cl(env["gday"], null, []), 7.0) + J.mul(J.mc(env["ORDER"], "indexOf", [v_id_54]), 131.0))])
	var _t16 = null
	if J.seq(v_id_54, "jump"):
		var _t12 = (5.6 + J.mul(v_r_55, 1.0))
		_t16 = J.num(J.mc(_t12, "toFixed", [2.0]))
	else:
		var _t15 = null
		if J.seq(v_id_54, "hang"):
			_t15 = J.round(J.num((22.0 + J.mul(v_r_55, 14.0))))
		else:
			var _t14 = null
			if J.seq(v_id_54, "swim"):
				var _t13 = (17.5 + J.mul(v_r_55, 4.0))
				_t14 = J.num(J.mc(_t13, "toFixed", [1.0]))
			else:
				_t14 = 0.0
			_t15 = _t14
		_t16 = _t15
	return _t16

func _f10(this_, a: Array, env):
	var v_a_58 = null; var v_e_59 = null
	v_a_58 = J.arg(a, 0)
	return ((1.0 + (0.12 * J.sub(J.mc(J.G.get("GP"), "grow", [J.gp(v_a_58, "g")]), 1.0))) if J.t((J.gp(v_a_58, "g") if J.t(v_a_58) else v_a_58)) else 1.0)

func _f12(this_, a: Array, env):
	var v_g_63 = null
	v_g_63 = J.arg(a, 0)
	return J.seq(J.gp(v_g_63, "k"), env["k"])

func _f11(this_, a: Array, env):
	var _s15 = {"__p": env, "k": null}
	_s15["k"] = J.arg(a, 0)
	var _t17 = J.gp(J.G.get("S"), "ghosts")
	var _t18 = J.mc(_t17, "find", [Callable(self, "_f12").bind(_s15)])
	return (_t18 if J.t(_t18) else null)

func _f14(this_, a: Array, env):
	var v_x_69 = null
	v_x_69 = J.arg(a, 0)
	return J.seq(J.gp(v_x_69, "k"), "afu")

func _f13(this_, a: Array, env):
	var v_id_66 = null; var v_E_67 = null; var v_g_68 = null
	v_id_66 = J.arg(a, 0)
	v_E_67 = J.gp(env["EV"], v_id_66)
	var _t19 = env["owned"]
	v_g_68 = J.cl(_t19, null, [J.gp(v_E_67, "who")])
	var _t21 = null
	if J.t(v_g_68):
		_t21 = {"k": J.gp(v_E_67, "who"), "g": v_g_68, "name": J.gp(v_g_68, "name"), "sub": false}
	else:
		var _t20 = J.gp(J.G.get("S"), "ghosts")
		_t21 = {"k": "afu", "g": J.mc(_t20, "find", [Callable(self, "_f14").bind(env)]), "name": "阿福", "sub": true}
	return _t21

func _f16(this_, a: Array, env):
	var v_id_74 = null; var v_a_75 = null; var v_b_76 = null
	v_id_74 = J.arg(a, 0)
	v_a_75 = J.arg(a, 1)
	v_b_76 = J.arg(a, 2)
	return (J.cmp(v_a_75, v_b_76, ">") if J.t(J.gp(J.gp(env["EV"], v_id_74), "hi")) else J.cmp(v_a_75, v_b_76, "<"))

func _f18(this_, a: Array, env):
	var v_id_82 = null; var v_E_83 = null; var v_a_84 = null; var v_won_85 = null; var v_best_86 = null; var v_goal_87 = null
	v_id_82 = J.arg(a, 0)
	v_E_83 = J.gp(env["__p"]["EV"], v_id_82)
	var _t22 = env["__p"]["athlete"]
	v_a_84 = J.cl(_t22, null, [v_id_82])
	v_won_85 = J.seq(J.gp(J.gp(env["s"], "won"), v_id_82), env["today"])
	v_best_86 = J.gp(J.gp(env["s"], "best"), v_id_82)
	var _t25 = null
	if J.seq(v_id_82, "tug"):
		_t25 = ("對手：" + J.str((J.gp(J.gp(J.G.get("GHOSTS"), J.gp(v_E_83, "foe")), "name") if J.t(J.gp(J.G.get("GHOSTS"), J.gp(v_E_83, "foe"))) else "轆轤首")))
	else:
		var _t23 = env["__p"]["fmtV"]
		var _t24 = env["__p"]["target"]
		_t25 = ("Bryan 今日紀錄：" + J.str(J.cl(_t23, null, [v_id_82, J.cl(_t24, null, [v_id_82])])))
	v_goal_87 = _t25
	var _t29 = ("won" if J.t(v_won_85) else "")
	var _t30 = J.gp(v_a_84, "k")
	var _t31 = J.gp(v_E_83, "name")
	var _t32 = J.gp(v_a_84, "name")
	var _t33 = ("（替補）" if J.t(J.gp(v_a_84, "sub")) else "")
	var _t28 = null
	if (not J.leq(v_best_86, null)):
		var _t27 = null
		if J.seq(v_id_82, "tug"):
			_t27 = J.add(v_best_86, " 勝")
		else:
			var _t26 = env["__p"]["fmtV"]
			_t27 = J.cl(_t26, null, [v_id_82, v_best_86])
		_t28 = ("你的最佳：" + J.str(_t27))
	else:
		_t28 = "未參賽"
	return ("<div class=\"sp-ev " + _t29 + "\"><canvas data-por=\"" + J.str(_t30) + "\"></canvas><div><b>" + J.str(_t31) + "</b><small>出賽：" + J.str(_t32) + _t33 + "　" + J.str(v_goal_87) + "</small><small>" + _t28 + ("　<em>今日已贏</em>" if J.t(v_won_85) else "") + "</small></div><button class=\"btn sm " + ("" if J.t(v_won_85) else "gold") + "\" data-sp=\"" + J.str(v_id_82) + "\">" + ("再玩" if J.t(v_won_85) else "參賽") + "</button></div>")

func _f20(this_, a: Array, env):
	J.mc(J.G.get("UI"), "close", [])
	var _t42 = env["__p"]["__p"]["start"]
	J.cl(_t42, null, [J.gp(J.gp(env["b"], "dataset"), "sp")])

func _f19(this_, a: Array, env):
	var _s23 = {"__p": env, "b": null}
	_s23["b"] = J.arg(a, 0)
	var _t41 = _s23["b"]
	var _t43 = Callable(self, "_f20").bind(_s23)
	J.sp(_t41, "onclick", _t43)
	return _t43

func _f17(this_, a: Array, env):
	var v_h_81 = null
	var _s21 = {"__p": env, "s": null, "today": null}
	_s21["s"] = J.cl(_s21["__p"]["st"], null, [])
	_s21["today"] = J.cl(_s21["__p"]["gday"], null, [])
	v_h_81 = ("<p class=\"desc\">陰間運動會：靠鬼自己的怪癖比賽。每項每日第一次贏過 Bryan 的紀錄，出賽的鬼存在感 +12、全村 +3、合約 KPI +2、冥幣 60。</p>")
	var _t34 = J.mc(_s21["__p"]["ORDER"], "map", [Callable(self, "_f18").bind(_s21)])
	var _t35 = J.add(v_h_81, J.mc(_t34, "join", [""]))
	v_h_81 = _t35
	J.mc(J.G.get("UI"), "sheet", ["陰間運動會", v_h_81])
	var _t36 = J.G.get("paintPortraits")
	var _t37 = J.G.get("$")
	J.cl(_t36, null, [J.cl(_t37, null, ["#sheet"])])
	var _t38 = J.G.get("$")
	var _t39 = J.cl(_t38, null, ["#sheet"])
	var _t40 = J.mc(_t39, "querySelectorAll", ["[data-sp]"])
	J.mc(_t40, "forEach", [Callable(self, "_f19").bind(_s21)])

func _f21(this_, a: Array, env):
	var v_e_91 = null
	var _t44 = J.G.get("$")
	v_e_91 = J.cl(_t44, null, ["#sports"])
	if J.t(v_e_91):
		return v_e_91
	var _t45 = J.S_document_("createElement", ["div"])
	v_e_91 = _t45
	J.sp(v_e_91, "id", "sports")
	var _t46 = J.gp(J.G.get("document"), "body")
	J.mc(_t46, "appendChild", [v_e_91])
	return v_e_91

func _f23(this_, a: Array, env):
	return J.cl(env["close"], null, [])

func _f24(this_, a: Array, env):
	var v_e_100 = null
	v_e_100 = J.arg(a, 0)
	J.mc(v_e_100, "preventDefault", [])
	if J.t((J.gp(env["G"], "down") if J.t(env["G"]) else env["G"])):
		var _t74 = env["pt"]
		J.mc(env["G"], "down", [J.cl(_t74, null, [v_e_100])])

func _f25(this_, a: Array, env):
	var v_e_101 = null
	v_e_101 = J.arg(a, 0)
	if J.t((J.gp(env["G"], "move") if J.t(env["G"]) else env["G"])):
		var _t75 = env["pt"]
		J.mc(env["G"], "move", [J.cl(_t75, null, [v_e_101])])

func _f26(this_, a: Array, env):
	var v_e_102 = null
	v_e_102 = J.arg(a, 0)
	if J.t((J.gp(env["G"], "up") if J.t(env["G"]) else env["G"])):
		var _t76 = env["pt"]
		J.mc(env["G"], "up", [J.cl(_t76, null, [v_e_102])])

func _f22(this_, a: Array, env):
	var v_id_94 = null; var v_E_95 = null; var v_a_96 = null; var v_root_97 = null; var v_cv_98 = null; var v_up_99 = null; var v_e_103 = null
	v_id_94 = J.arg(a, 0)
	v_E_95 = J.gp(env["EV"], v_id_94)
	var _t47 = env["athlete"]
	v_a_96 = J.cl(_t47, null, [v_id_94])
	v_root_97 = J.cl(env["el"], null, [])
	var _t49 = []
	var _t48 = env["gpf"]
	var _t50 = {"id": v_id_94, "E": v_E_95, "a": v_a_96, "t": 0.0, "phase": "intro", "introT": 2.6, "done": false, "fx": _t49, "score": null, "msg": "", "msgT": 0.0, "gpf": J.cl(_t48, null, [v_a_96])}
	env["G"] = _t50
	var _t61 = J.gp(v_E_95, "name")
	var _t62 = J.gp(v_E_95, "rule")
	var _t63 = (("<br><i>" + J.str(J.gp(v_E_95, "sub")) + "</i>") if J.t(J.gp(v_a_96, "sub")) else "")
	var _t51 = (not J.seq(v_id_94, "hang"))
	var _t60 = null
	if J.t((J.gp(v_a_96, "g") if _t51 else _t51)):
		var _t52 = env["Lx"]
		var _t53 = env["D"]
		var _t56 = J.cl(_t52, null, [J.cl(_t53, null, ["鬼力", "鬼力"])])
		var _t57 = J.mc(J.G.get("GP"), "pow", [J.gp(v_a_96, "g")])
		var _t54 = env["Lx"]
		var _t55 = env["D"]
		var _t59 = J.cl(_t54, null, [J.cl(_t55, null, ["體能", "體能"])])
		var _t58 = J.gp(env["G"], "gpf")
		_t60 = ("<br><small class=\"gp-sub\">" + J.str(_t56) + " " + J.str(_t57) + "・" + J.str(_t59) + " ×" + J.str(J.mc(_t58, "toFixed", [2.0])) + "</small>")
	else:
		_t60 = ""
	var _t64 = ("<div id=\"sp-top\"><button class=\"btn sm ghost\" id=\"sp-quit\">收場</button><b>" + J.str(_t61) + "</b><span id=\"sp-hud\"></span></div>\n      <canvas id=\"sp-cvs\"></canvas><div id=\"sp-panel\"><p id=\"sp-rule\">" + J.str(_t62) + _t63 + _t60 + "</p><div id=\"sp-btns\"></div></div>")
	J.sp(v_root_97, "innerHTML", _t64)
	var _t65 = J.gp(v_root_97, "classList")
	J.mc(_t65, "add", ["on"])
	var _t66 = J.G.get("$")
	var _t67 = J.cl(_t66, null, ["#sp-quit"])
	var _t68 = Callable(self, "_f23").bind(env)
	J.sp(_t67, "onclick", _t68)
	var _t69 = J.G.get("$")
	v_cv_98 = J.cl(_t69, null, ["#sp-cvs"])
	var _t70 = env["G"]
	J.sp(_t70, "cv", v_cv_98)
	var _t71 = env["G"]
	var _t72 = J.mc(v_cv_98, "getContext", ["2d"])
	J.sp(_t71, "ctx", _t72)
	var _t73 = env["INIT"]
	J.mc(_t73, v_id_94, [env["G"]])
	J.cl(env["resize"], null, [])
	J.S_window_("addEventListener", ["resize", env["resize"]])
	J.mc(v_cv_98, "addEventListener", ["pointerdown", Callable(self, "_f24").bind(env)])
	J.mc(v_cv_98, "addEventListener", ["pointermove", Callable(self, "_f25").bind(env)])
	v_up_99 = Callable(self, "_f26").bind(env)
	J.mc(v_cv_98, "addEventListener", ["pointerup", v_up_99])
	J.mc(v_cv_98, "addEventListener", ["pointercancel", v_up_99])
	J.mc(v_cv_98, "addEventListener", ["pointerleave", v_up_99])
	J.mc(J.G.get("Sound"), "setMode", ["story"])
	var _t77 = env["G"]
	var _t78 = J.S_performance_("now", [])
	J.sp(_t77, "last", _t78)
	J.F_requestAnimationFrame([env["frame"]])

func _f27(this_, a: Array, env):
	var v_e_106 = null; var v_r_107 = null
	v_e_106 = J.arg(a, 0)
	v_r_107 = J.mc(J.gp(env["G"], "cv"), "getBoundingClientRect", [])
	return {"x": (J.div(J.sub(J.gp(v_e_106, "clientX"), J.gp(v_r_107, "left")), J.gp(v_r_107, "width")) * 390.0), "y": (J.div(J.sub(J.gp(v_e_106, "clientY"), J.gp(v_r_107, "top")), J.gp(v_r_107, "width")) * 390.0)}

func _f28(this_, a: Array, env):
	var v_r_110 = null; var v_d_111 = null
	if (not J.t(env["G"])):
		return null
	v_r_110 = J.mc(J.gp(env["G"], "cv"), "getBoundingClientRect", [])
	var _t79 = J.gp(J.G.get("window"), "devicePixelRatio")
	var _t80 = J.gp(J.G.get("window"), "devicePixelRatio")
	v_d_111 = J.min_([2.0, (_t80 if J.t(_t80) else 1.0)])
	var _t81 = J.gp(env["G"], "cv")
	var _t82 = J.mul(J.gp(v_r_110, "width"), v_d_111)
	J.sp(_t81, "width", _t82)
	var _t83 = J.gp(env["G"], "cv")
	var _t84 = J.mul(J.gp(v_r_110, "height"), v_d_111)
	J.sp(_t83, "height", _t84)
	var _t85 = env["G"]
	var _t86 = J.div(J.mul(J.gp(v_r_110, "width"), v_d_111), 390.0)
	J.sp(_t85, "k", _t86)
	var _t87 = env["G"]
	var _t88 = (J.div(J.gp(v_r_110, "height"), J.gp(v_r_110, "width")) * 390.0)
	J.sp(_t87, "H", _t88)

func _f29(this_, a: Array, env):
	var v_e_114 = null; var v_e_115 = null
	env["G"] = null
	var _t89 = J.G.get("$")
	v_e_114 = J.cl(_t89, null, ["#sports"])
	if J.t(v_e_114):
		var _t90 = J.gp(v_e_114, "classList")
		J.mc(_t90, "remove", ["on"])
		J.sp(v_e_114, "innerHTML", "")
	J.mc(J.G.get("Sound"), "setMode", ["village"])
	J.cl(env["open"], null, [])

func _f31(this_, a: Array, env):
	var v_x_120 = null; var v_i_121 = null
	v_x_120 = J.arg(a, 0)
	v_i_121 = J.arg(a, 1)
	var _t92 = J.gp(v_x_120, 2.0)
	return ("<button class=\"btn " + J.str((_t92 if J.t(_t92) else "gold")) + " sp-b\" data-i=\"" + J.str(v_i_121) + "\">" + J.str(J.gp(v_x_120, 0.0)) + "</button>")

func _f33(this_, a: Array, env):
	var v_e_123 = null; var v_f_124 = null
	v_e_123 = J.arg(a, 0)
	J.mc(v_e_123, "preventDefault", [])
	v_f_124 = J.gp(J.gp(env["__p"]["list"], J.num(J.gp(J.gp(env["x"], "dataset"), "i"))), 1.0)
	if J.t((J.seq(J.gp(env["__p"]["__p"]["G"], "phase"), "play") if J.t(env["__p"]["__p"]["G"]) else env["__p"]["__p"]["G"])):
		J.cl(v_f_124, null, [])

func _f32(this_, a: Array, env):
	var _s43 = {"__p": env, "x": null}
	_s43["x"] = J.arg(a, 0)
	return J.mc(_s43["x"], "addEventListener", ["pointerdown", Callable(self, "_f33").bind(_s43)])

func _f30(this_, a: Array, env):
	var v_b_119 = null
	var _s41 = {"__p": env, "list": null}
	_s41["list"] = J.arg(a, 0)
	var _t91 = J.G.get("$")
	v_b_119 = J.cl(_t91, null, ["#sp-btns"])
	var _t93 = J.mc(_s41["list"], "map", [Callable(self, "_f31").bind(_s41)])
	var _t94 = J.mc(_t93, "join", [""])
	J.sp(v_b_119, "innerHTML", _t94)
	var _t95 = J.mc(v_b_119, "querySelectorAll", [".sp-b"])
	J.mc(_t95, "forEach", [Callable(self, "_f32").bind(_s41)])

func _f34(this_, a: Array, env):
	var v_m_127 = null; var v_t_128 = null
	v_m_127 = J.arg(a, 0)
	v_t_128 = J.arg(a, 1)
	var _t96 = env["G"]
	J.sp(_t96, "msg", v_m_127)
	var _t97 = env["G"]
	var _t98 = (v_t_128 if J.t(v_t_128) else 1.2)
	J.sp(_t97, "msgT", _t98)

func _f36(this_, a: Array, env):
	var v_f_134 = null
	v_f_134 = J.arg(a, 0)
	return J.cmp(J.gp(v_f_134, "t"), J.gp(v_f_134, "life"), "<")

func _f35(this_, a: Array, env):
	var v_now_131 = null; var v_dt_132 = null; var v_f_133 = null
	v_now_131 = J.arg(a, 0)
	if (not J.t(env["G"])):
		return null
	v_dt_132 = J.min_([0.05, J.div(J.sub(v_now_131, J.gp(env["G"], "last")), 1000.0)])
	var _t99 = env["G"]
	J.sp(_t99, "last", v_now_131)
	var _t100 = env["G"]
	var _t101 = J.add(J.gp(_t100, "t"), v_dt_132)
	J.sp(_t100, "t", _t101)
	if J.cmp(J.gp(env["G"], "msgT"), 0.0, ">"):
		var _t102 = env["G"]
		var _t103 = J.sub(J.gp(_t102, "msgT"), v_dt_132)
		J.sp(_t102, "msgT", _t103)
	if J.seq(J.gp(env["G"], "phase"), "intro"):
		var _t104 = env["G"]
		var _t105 = J.sub(J.gp(_t104, "introT"), v_dt_132)
		J.sp(_t104, "introT", _t105)
		if J.cmp(J.gp(env["G"], "introT"), 0.0, "<="):
			var _t106 = env["G"]
			J.sp(_t106, "phase", "play")
	var _t107 = J.seq(J.gp(env["G"], "phase"), "play")
	if J.t((J.gp(env["G"], "tick") if _t107 else _t107)):
		J.mc(env["G"], "tick", [v_dt_132])
	for _t108 in J.iter(J.gp(env["G"], "fx")):
		v_f_133 = _t108
		var _t109 = J.add(J.gp(v_f_133, "t"), v_dt_132)
		J.sp(v_f_133, "t", _t109)
	var _t110 = env["G"]
	var _t111 = J.gp(env["G"], "fx")
	var _t112 = J.mc(_t111, "filter", [Callable(self, "_f36").bind(env)])
	J.sp(_t110, "fx", _t112)
	J.cl(env["draw"], null, [])
	J.F_requestAnimationFrame([env["frame"]])

func _f37(this_, a: Array, env):
	var v_c_137 = null; var v_H_138 = null; var v_hud_139 = null; var v_f_140 = null; var v_q_141 = null
	v_c_137 = J.gp(env["G"], "ctx")
	v_H_138 = J.gp(env["G"], "H")
	J.mc(v_c_137, "setTransform", [J.gp(env["G"], "k"), 0.0, 0.0, J.gp(env["G"], "k"), 0.0, 0.0])
	J.mc(v_c_137, "clearRect", [0.0, 0.0, 390.0, v_H_138])
	var _t113 = env["has"]
	var _t114 = J.cl(_t113, null, [J.G.get("SCENE")])
	if (not J.t((J.mc(J.G.get("SCENE"), "drawBg", [v_c_137, 390.0, v_H_138, J.gp(J.gp(env["G"], "E"), "bg")]) if J.t(_t114) else _t114))):
		J.sp(v_c_137, "fillStyle", "#1c1820")
		J.mc(v_c_137, "fillRect", [0.0, 0.0, 390.0, v_H_138])
	J.sp(v_c_137, "fillStyle", "rgba(10,8,16,.35)")
	J.mc(v_c_137, "fillRect", [0.0, 0.0, 390.0, v_H_138])
	J.mc(env["G"], "draw", [v_c_137, v_H_138])
	for _t115 in J.iter(J.gp(env["G"], "fx")):
		v_f_140 = _t115
		v_q_141 = J.div(J.gp(v_f_140, "t"), J.gp(v_f_140, "life"))
		J.mc(v_c_137, "save", [])
		var _t116 = J.sub(1.0, v_q_141)
		J.sp(v_c_137, "globalAlpha", _t116)
		var _t117 = J.gp(v_f_140, "size")
		var _t118 = ("bold " + J.str((_t117 if J.t(_t117) else 18.0)) + "px \"PingFang TC\",\"Noto Sans TC\",sans-serif")
		J.sp(v_c_137, "font", _t118)
		J.sp(v_c_137, "textAlign", "center")
		J.sp(v_c_137, "lineWidth", 4.0)
		J.sp(v_c_137, "strokeStyle", "rgba(0,0,0,.75)")
		var _t119 = J.gp(v_f_140, "col")
		var _t120 = (_t119 if J.t(_t119) else "#fff")
		J.sp(v_c_137, "fillStyle", _t120)
		J.mc(v_c_137, "strokeText", [J.gp(v_f_140, "text"), J.gp(v_f_140, "x"), J.sub(J.gp(v_f_140, "y"), J.mul(v_q_141, 26.0))])
		J.mc(v_c_137, "fillText", [J.gp(v_f_140, "text"), J.gp(v_f_140, "x"), J.sub(J.gp(v_f_140, "y"), J.mul(v_q_141, 26.0))])
		J.mc(v_c_137, "restore", [])
	if J.seq(J.gp(env["G"], "phase"), "intro"):
		var _t121 = env["banner"]
		var _t123 = J.gp(J.gp(env["G"], "E"), "name")
		var _t122 = env["Lx"]
		J.cl(_t121, null, [v_c_137, v_H_138, _t123, J.cl(_t122, null, [J.gp(env["BRYAN"], J.gp(env["G"], "id"))])])
	var _t124 = J.cmp(J.gp(env["G"], "msgT"), 0.0, ">")
	if J.t((J.gp(env["G"], "msg") if _t124 else _t124)):
		J.mc(v_c_137, "save", [])
		var _t125 = "bold 22px \"PingFang TC\",\"Noto Sans TC\",sans-serif"
		J.sp(v_c_137, "font", _t125)
		J.sp(v_c_137, "textAlign", "center")
		J.sp(v_c_137, "lineWidth", 5.0)
		J.sp(v_c_137, "strokeStyle", "rgba(0,0,0,.8)")
		J.sp(v_c_137, "fillStyle", "#ffd84a")
		J.mc(v_c_137, "strokeText", [J.gp(env["G"], "msg"), 195.0, J.mul(v_H_138, 0.2)])
		J.mc(v_c_137, "fillText", [J.gp(env["G"], "msg"), 195.0, J.mul(v_H_138, 0.2)])
		J.mc(v_c_137, "restore", [])
	var _t126 = J.G.get("$")
	v_hud_139 = J.cl(_t126, null, ["#sp-hud"])
	if J.t((J.gp(env["G"], "hud") if J.t(v_hud_139) else v_hud_139)):
		var _t127 = J.mc(env["G"], "hud", [])
		J.sp(v_hud_139, "textContent", _t127)

func _f38(this_, a: Array, env):
	var v_c_144 = null; var v_H_145 = null; var v_a_146 = null; var v_b_147 = null
	v_c_144 = J.arg(a, 0)
	v_H_145 = J.arg(a, 1)
	v_a_146 = J.arg(a, 2)
	v_b_147 = J.arg(a, 3)
	J.mc(v_c_144, "save", [])
	J.sp(v_c_144, "fillStyle", "rgba(0,0,0,.6)")
	J.mc(v_c_144, "fillRect", [0.0, J.mul(v_H_145, 0.32), 390.0, 92.0])
	J.sp(v_c_144, "textAlign", "center")
	J.sp(v_c_144, "fillStyle", "#ffd84a")
	var _t128 = "bold 26px \"PingFang TC\",\"Noto Sans TC\",sans-serif"
	J.sp(v_c_144, "font", _t128)
	J.mc(v_c_144, "fillText", [v_a_146, 195.0, (J.mul(v_H_145, 0.32) + 38.0)])
	J.sp(v_c_144, "fillStyle", "#eee")
	var _t129 = "14px \"PingFang TC\",\"Noto Sans TC\",sans-serif"
	J.sp(v_c_144, "font", _t129)
	var _t130 = env["wrap"]
	J.cl(_t130, null, [v_c_144, v_b_147, 195.0, (J.mul(v_H_145, 0.32) + 66.0), 350.0, 18.0])
	J.mc(v_c_144, "restore", [])

func _f39(this_, a: Array, env):
	var v_c_150 = null; var v_s_151 = null; var v_x_152 = null; var v_y_153 = null; var v_w_154 = null; var v_lh_155 = null; var v_line_156 = null; var v_yy_157 = null; var v_ch_158 = null
	v_c_150 = J.arg(a, 0)
	v_s_151 = J.arg(a, 1)
	v_x_152 = J.arg(a, 2)
	v_y_153 = J.arg(a, 3)
	v_w_154 = J.arg(a, 4)
	v_lh_155 = J.arg(a, 5)
	v_line_156 = ""
	v_yy_157 = v_y_153
	for _t131 in J.iter(v_s_151):
		v_ch_158 = _t131
		if J.cmp(J.gp(J.mc(v_c_150, "measureText", [J.add(v_line_156, v_ch_158)]), "width"), v_w_154, ">"):
			J.mc(v_c_150, "fillText", [v_line_156, v_x_152, v_yy_157])
			v_line_156 = v_ch_158
			var _t132 = J.add(v_yy_157, v_lh_155)
			v_yy_157 = _t132
		else:
			var _t133 = J.add(v_line_156, v_ch_158)
			v_line_156 = _t133
	J.mc(v_c_150, "fillText", [v_line_156, v_x_152, v_yy_157])

func _f40(this_, a: Array, env):
	var v_text_161 = null; var v_x_162 = null; var v_y_163 = null; var v_col_164 = null; var v_size_165 = null
	v_text_161 = J.arg(a, 0)
	v_x_162 = J.arg(a, 1)
	v_y_163 = J.arg(a, 2)
	v_col_164 = J.arg(a, 3)
	v_size_165 = J.arg(a, 4)
	var _t134 = J.gp(env["G"], "fx")
	J.mc(_t134, "push", [{"text": v_text_161, "x": v_x_162, "y": v_y_163, "col": v_col_164, "size": v_size_165, "t": 0.0, "life": 0.9}])

func _f41(this_, a: Array, env):
	var v_c_168 = null; var v_k_169 = null; var v_x_170 = null; var v_y_171 = null; var v_s_172 = null; var v_o_173 = null; var v_e_174 = null
	v_c_168 = J.arg(a, 0)
	v_k_169 = J.arg(a, 1)
	v_x_170 = J.arg(a, 2)
	v_y_171 = J.arg(a, 3)
	v_s_172 = J.arg(a, 4)
	v_o_173 = J.arg(a, 5)
	J.mc(J.G.get("ART"), "drawChar", [v_c_168, v_k_169, v_x_170, v_y_171, v_s_172, J.S_Object_("assign", [{"t": J.gp(env["G"], "t")}, (v_o_173 if J.t(v_o_173) else {})])])

func _f42(this_, a: Array, env):
	var v_c_177 = null; var v_x_178 = null; var v_y_179 = null; var v_h_180 = null; var v_state_181 = null; var v_o_182 = null; var v_e_183 = null
	v_c_177 = J.arg(a, 0)
	v_x_178 = J.arg(a, 1)
	v_y_179 = J.arg(a, 2)
	v_h_180 = J.arg(a, 3)
	v_state_181 = J.arg(a, 4)
	v_o_182 = J.arg(a, 5)
	J.mc(J.G.get("Antag"), "draw", [v_c_177, "npc_rival", v_x_178, v_y_179, v_h_180, (v_state_181 if J.t(v_state_181) else "idle"), J.gp(env["G"], "t"), J.S_Object_("assign", [{"shadow": false, "time": J.gp(env["G"], "t")}, (v_o_182 if J.t(v_o_182) else {})])])

func _f44(this_, a: Array, env):
	var _t177 = env["__p"]["start"]
	return J.cl(_t177, null, [env["id"]])

func _f45(this_, a: Array, env):
	return J.cl(env["__p"]["close"], null, [])

func _f43(this_, a: Array, env):
	var v_v_186 = null; var v_line_187 = null; var v_s_188 = null; var v_today_190 = null; var v_win_191 = null; var v_rec_192 = null; var v_rw_193 = null; var v_res_194 = null; var v_vs_195 = null; var v_p_196 = null; var v_got_197 = null; var v_g_198 = null
	var _s69 = {"__p": env, "id": null}
	v_v_186 = J.arg(a, 0)
	v_line_187 = J.arg(a, 1)
	if J.t(J.gp(_s69["__p"]["G"], "done")):
		return null
	var _t135 = _s69["__p"]["G"]
	J.sp(_t135, "done", true)
	var _t136 = _s69["__p"]["G"]
	J.sp(_t136, "phase", "end")
	v_s_188 = J.cl(_s69["__p"]["st"], null, [])
	_s69["id"] = J.gp(_s69["__p"]["G"], "id")
	v_today_190 = J.cl(_s69["__p"]["gday"], null, [])
	var _t137 = J.gp(v_s_188, "plays")
	var _t138 = J.add((_t137 if J.t(_t137) else 0.0), 1.0)
	J.sp(v_s_188, "plays", _t138)
	v_win_191 = null
	v_rec_192 = ""
	if J.seq(_s69["id"], "tug"):
		var _t139 = J.cmp(v_v_186, 0.0, ">")
		v_win_191 = _t139
		var _t140 = J.gp(v_s_188, "best")
		var _t141 = J.gp(J.gp(v_s_188, "best"), "tug")
		var _t142 = J.add((_t141 if J.t(_t141) else 0.0), (1.0 if J.t(v_win_191) else 0.0))
		J.sp(_t140, "tug", _t142)
	else:
		var _t146 = (not J.leq(v_v_186, null))
		if J.t(_t146):
			var _t143 = _s69["__p"]["better"]
			var _t145 = _s69["id"]
			var _t144 = _s69["__p"]["target"]
			_t146 = J.cl(_t143, null, [_t145, v_v_186, J.cl(_t144, null, [_s69["id"]])])
		v_win_191 = _t146
		var _t149 = (not J.leq(v_v_186, null))
		if J.t(_t149):
			var _t148 = J.leq(J.gp(J.gp(v_s_188, "best"), _s69["id"]), null)
			if not J.t(_t148):
				var _t147 = _s69["__p"]["better"]
				_t148 = J.cl(_t147, null, [_s69["id"], v_v_186, J.gp(J.gp(v_s_188, "best"), _s69["id"])])
			_t149 = _t148
		if J.t(_t149):
			var _t150 = J.gp(v_s_188, "best")
			var _t151 = _s69["id"]
			J.sp(_t150, _t151, v_v_186)
			v_rec_192 = "　<b>個人新紀錄！</b>"
	v_rw_193 = ""
	if J.t(((not J.seq(J.gp(J.gp(v_s_188, "won"), _s69["id"]), v_today_190)) if J.t(v_win_191) else v_win_191)):
		var _t152 = J.gp(v_s_188, "won")
		var _t153 = _s69["id"]
		J.sp(_t152, _t153, v_today_190)
		var _t154 = _s69["__p"]["has"]
		if J.t(J.cl(_t154, null, [J.G.get("Presence")])):
			if J.t(J.gp(J.gp(_s69["__p"]["G"], "a"), "g")):
				J.mc(J.G.get("Presence"), "add", [J.gp(J.gp(_s69["__p"]["G"], "a"), "g"), 12.0])
			for _t155 in J.iter(J.gp(J.G.get("S"), "ghosts")):
				v_g_198 = _t155
				if (not J.seq(v_g_198, J.gp(J.gp(_s69["__p"]["G"], "a"), "g"))):
					J.mc(J.G.get("Presence"), "add", [v_g_198, 3.0])
		var _t156 = J.gp(J.G.get("S"), "contract")
		if J.t((J.seq(J.gp(J.gp(J.G.get("S"), "contract"), "state"), "active") if J.t(_t156) else _t156)):
			var _t157 = J.gp(J.G.get("S"), "contract")
			var _t158 = J.add(J.gp(_t157, "kpi"), 2.0)
			J.sp(_t157, "kpi", _t158)
		var _t159 = J.G.get("give")
		v_got_197 = J.cl(_t159, null, [{"coins": 60.0}])
		var _t161 = J.gp(J.gp(_s69["__p"]["G"], "a"), "name")
		var _t160 = J.gp(J.G.get("S"), "contract")
		var _t162 = ("<p class=\"desc\">" + J.str(_t161) + " 存在感 +12，全村 +3" + ("，合約 KPI +2" if J.t((J.seq(J.gp(J.gp(J.G.get("S"), "contract"), "state"), "active") if J.t(_t160) else _t160)) else "") + "，" + J.str(v_got_197) + "</p>")
		v_rw_193 = _t162
	else:
		if J.t(v_win_191):
			v_rw_193 = "<p class=\"desc\">今日已經領過獎，這場算練習。</p>"
	J.cl(J.G.get("save"), null, [])
	var _t165 = null
	if J.seq(_s69["id"], "tug"):
		_t165 = ("贏了！" if J.t(v_win_191) else "輸了")
	else:
		var _t164 = null
		if J.leq(v_v_186, null):
			_t164 = "犯規"
		else:
			var _t163 = _s69["__p"]["fmtV"]
			_t164 = J.cl(_t163, null, [_s69["id"], v_v_186])
		_t165 = _t164
	v_res_194 = _t165
	var _t169 = null
	if J.seq(_s69["id"], "tug"):
		_t169 = ""
	else:
		var _t166 = _s69["__p"]["fmtV"]
		var _t168 = _s69["id"]
		var _t167 = _s69["__p"]["target"]
		_t169 = ("<p class=\"desc\">Bryan 今日紀錄：" + J.str(J.cl(_t166, null, [_t168, J.cl(_t167, null, [_s69["id"]])])) + J.str(v_rec_192) + "</p>")
	v_vs_195 = _t169
	var _t170 = J.G.get("$")
	v_p_196 = J.cl(_t170, null, ["#sp-panel"])
	if (not J.t(v_p_196)):
		return null
	var _t173 = ("贏了 Bryan！" if J.t(v_win_191) else ("被轆轤首拉過去了" if J.seq(_s69["id"], "tug") else "輸給 Bryan"))
	var _t172 = null
	if J.t(v_line_187):
		var _t171 = _s69["__p"]["Lx"]
		_t172 = ("<p class=\"desc\"><i>" + J.str(J.cl(_t171, null, [v_line_187])) + "</i></p>")
	else:
		_t172 = ""
	var _t174 = ("<div class=\"sp-end\"><h3>" + _t173 + "</h3><p class=\"sp-big\">" + J.str(v_res_194) + "</p>" + _t172 + J.str(v_vs_195) + J.str(v_rw_193) + "<div class=\"sp-endb\"><button class=\"btn\" id=\"sp-again\">再來一次</button><button class=\"btn gold\" id=\"sp-back\">回運動會</button></div></div>")
	J.sp(v_p_196, "innerHTML", _t174)
	var _t175 = J.G.get("$")
	var _t176 = J.cl(_t175, null, ["#sp-again"])
	var _t178 = Callable(self, "_f44").bind(_s69)
	J.sp(_t176, "onclick", _t178)
	var _t179 = J.G.get("$")
	var _t180 = J.cl(_t179, null, ["#sp-back"])
	var _t181 = Callable(self, "_f45").bind(_s69)
	J.sp(_t180, "onclick", _t181)

func _f2(this_, a: Array, env):
	var v_yue_37 = null; var v_zh_38 = null
	v_yue_37 = J.arg(a, 0)
	v_zh_38 = J.arg(a, 1)
	if (not J.seq(J.typeof_(J.G.get("LANG")), "undefined")):
		J.mc(J.G.get("LANG"), "add", [{J.key(v_yue_37): v_zh_38}])
	return v_yue_37

func _f3(this_, a: Array, env):
	if (not J.seq(J.typeof_(J.G.get("LANG")), "undefined")):
		J.mc(J.G.get("LANG"), "add", [{"繃緊！唔好拉！": "繃緊了！不要拉！"}])
	return "繃緊！唔好拉！"

func _f4(this_, a: Array, env):
	var v_o_39 = null
	v_o_39 = J.arg(a, 0)
	return (not J.seq(J.typeof_(v_o_39), "undefined"))

func _f5(this_, a: Array, env):
	var v_x_40 = null
	v_x_40 = J.arg(a, 0)
	var _t190 = null
	if J.seq(J.typeof_(J.G.get("L")), "function"):
		var _t189 = J.G.get("L")
		_t190 = J.cl(_t189, null, [v_x_40])
	else:
		_t190 = v_x_40
	return _t190

func _f15(this_, a: Array, env):
	var v_id_70 = null; var v_v_71 = null
	v_id_70 = J.arg(a, 0)
	v_v_71 = J.arg(a, 1)
	return ("" if J.seq(v_id_70, "tug") else (J.add(J.mc(v_v_71, "toFixed", [2.0]), " 米") if J.seq(v_id_70, "jump") else (J.add(J.mc(v_v_71, "toFixed", [1.0]), " 秒") if J.seq(v_id_70, "swim") else J.add(floor(J.num(v_v_71)), " 秒"))))

func _f47(this_, a: Array, env):
	return ("" if J.t(J.gp(env["G"], "fly")) else ("節奏 " + J.str(J.round(J.num(((0.6 + J.mul(0.4, J.cl(env["avg"], null, []))) * 100.0)))) + "%"))

func _f49(this_, a: Array, env):
	var v_s_206 = null; var v_v_207 = null
	v_s_206 = J.arg(a, 0)
	v_v_207 = J.arg(a, 1)
	return J.add(v_s_206, v_v_207)

func _f48(this_, a: Array, env):
	var _t197 = null
	if J.t(J.len(J.gp(env["G"], "acc"))):
		var _t196 = J.gp(env["G"], "acc")
		_t197 = J.div(J.mc(_t196, "reduce", [Callable(self, "_f49").bind(env), 0.0]), J.len(J.gp(env["G"], "acc")))
	else:
		_t197 = 0.0
	return _t197

func _f50(this_, a: Array, env):
	var v_land_208 = null; var v_early_209 = null; var v_d_210 = null; var v_i_211 = null; var v_q_212 = null
	var _t198 = J.gp(env["G"], "fly")
	if J.t((_t198 if J.t(_t198) else J.cmp(J.gp(env["G"], "hop"), env["HOPS"], ">="))):
		J.cl(env["takeoff"], null, [])
		return null
	v_land_208 = J.sub(env["T"], J.gp(env["G"], "hopT"))
	v_early_209 = J.gp(env["G"], "hopT")
	v_d_210 = J.min_([v_land_208, v_early_209])
	v_i_211 = (J.gp(env["G"], "hop") if J.cmp(v_land_208, v_early_209, "<") else J.sub(J.gp(env["G"], "hop"), 1.0))
	var _t199 = J.cmp(v_i_211, 0.0, "<")
	if J.t((_t199 if _t199 else J.gp(J.gp(env["G"], "tapped"), v_i_211))):
		return null
	var _t200 = J.gp(env["G"], "tapped")
	J.sp(_t200, v_i_211, 1.0)
	v_q_212 = (1.0 if J.cmp(v_d_210, 0.09, "<") else (0.7 if J.cmp(v_d_210, 0.17, "<") else 0.15))
	var _t201 = J.gp(env["G"], "acc")
	J.mc(_t201, "push", [v_q_212])
	var _t202 = env["__p"]["pop"]
	var _t205 = ("好節奏！" if J.seq(v_q_212, 1.0) else ("還可以" if J.cmp(v_q_212, 0.5, ">") else "亂跳"))
	var _t204 = J.gp(env["G"], "x")
	var _t203 = J.gp(env["G"], "cam")
	J.cl(_t202, null, [_t205, J.sub(_t204, (_t203 if J.t(_t203) else 0.0)), J.mul(J.gp(env["G"], "H"), 0.42), ("#ffd84a" if J.seq(v_q_212, 1.0) else "#ddd"), 16.0])

func _f51(this_, a: Array, env):
	var v_gap_213 = null; var v_sp_214 = null; var v_dist_215 = null
	var _t206 = J.gp(env["G"], "fly")
	if J.t((_t206 if J.t(_t206) else J.cmp(J.gp(env["G"], "hop"), env["HOPS"], "<"))):
		return null
	v_gap_213 = J.div(J.sub(J.gp(env["G"], "lineX"), J.gp(env["G"], "x")), env["PX"])
	v_sp_214 = (0.6 + J.mul(0.4, J.cl(env["avg"], null, [])))
	if J.cmp(v_gap_213, 0.0, "<"):
		var _t207 = env["G"]
		var _t208 = {"t": 0.0, "dist": 0.0, "foul": true}
		J.sp(_t207, "fly", _t208)
		var _t209 = env["__p"]["say"]
		J.cl(_t209, null, ["踩線犯規！", 1.6])
		return null
	v_dist_215 = J.max_([0.5, (J.mul(J.mul(v_sp_214, 7.6), J.gp(env["G"], "gpf")) - J.mul(v_gap_213, 1.2))])
	var _t210 = env["G"]
	var _t211 = {"t": 0.0, "dist": v_dist_215, "x0": J.gp(env["G"], "x"), "foul": false}
	J.sp(_t210, "fly", _t211)

func _f52(this_, a: Array, env):
	return J.cl(env["tapHop"], null, [])

func _f53(this_, a: Array, env):
	if J.seq(J.gp(env["G"], "phase"), "play"):
		J.cl(env["tapHop"], null, [])

func _f54(this_, a: Array, env):
	var v_dt_216 = null
	v_dt_216 = J.arg(a, 0)
	if J.t(J.gp(env["G"], "fly")):
		var _t216 = J.gp(env["G"], "fly")
		var _t217 = J.add(J.gp(_t216, "t"), v_dt_216)
		J.sp(_t216, "t", _t217)
		var _t218 = J.cmp(J.gp(J.gp(env["G"], "fly"), "t"), (1.2 if J.t(J.gp(J.gp(env["G"], "fly"), "foul")) else 1.4), ">")
		if ((not J.t(J.gp(env["G"], "done"))) if _t218 else _t218):
			var _t219 = env["__p"]["finish"]
			var _t221 = null
			if J.t(J.gp(J.gp(env["G"], "fly"), "foul")):
				_t221 = null
			else:
				var _t220 = J.gp(J.gp(env["G"], "fly"), "dist")
				_t221 = J.num(J.mc(_t220, "toFixed", [2.0]))
			var _t228 = null
			if J.t(J.gp(J.gp(env["G"], "fly"), "foul")):
				var _t222 = env["__p"]["D"]
				_t228 = J.cl(_t222, null, ["殭屍跳過咗龍，腳尖踩到白線。裁判（一隻雜鬼）舉紅旗。", "殭屍跳過了頭，腳尖踩到白線。裁判（一隻雜鬼）舉紅旗。"])
			else:
				var _t224 = J.gp(J.gp(env["G"], "fly"), "dist")
				var _t223 = env["__p"]["target"]
				var _t227 = null
				if J.cmp(_t224, J.cl(_t223, null, ["jump"]), ">"):
					var _t225 = env["__p"]["D"]
					_t227 = J.cl(_t225, null, ["落地姿勢：成條棍咁插落沙池。裁判俾滿分。", "落地姿勢：直挺挺插進沙池。裁判給滿分。"])
				else:
					var _t226 = env["__p"]["D"]
					_t227 = J.cl(_t226, null, ["膝頭太直，起跳差少少。", "膝蓋太直，起跳時差一點點。"])
				_t228 = _t227
			J.cl(_t219, null, [_t221, _t228])
		return null
	if J.cmp(J.gp(env["G"], "hop"), env["HOPS"], "<"):
		var _t229 = env["G"]
		var _t230 = J.add(J.gp(_t229, "hopT"), J.mul(v_dt_216, (0.85 + J.mul(0.3, J.gp(env["G"], "speed")))))
		J.sp(_t229, "hopT", _t230)
		if J.cmp(J.gp(env["G"], "hopT"), env["T"], ">="):
			var _t231 = env["G"]
			var _t232 = J.sub(J.gp(_t231, "hopT"), env["T"])
			J.sp(_t231, "hopT", _t232)
			var _t233 = env["G"]
			J.sp(_t233, "hop", J.num(J.gp(_t233, "hop")) + 1.0)
			if (not J.t(J.gp(J.gp(env["G"], "tapped"), J.sub(J.gp(env["G"], "hop"), 1.0)))):
				var _t234 = J.gp(env["G"], "acc")
				J.mc(_t234, "push", [0.0])
			var _t235 = env["G"]
			var _t236 = (0.6 + J.mul(0.4, J.cl(env["avg"], null, [])))
			J.sp(_t235, "speed", _t236)
		var _t237 = env["G"]
		var _t238 = (40.0 + J.mul(J.add(J.gp(env["G"], "hop"), J.div(J.gp(env["G"], "hopT"), env["T"])), 48.0))
		J.sp(_t237, "x", _t238)
	else:
		var _t239 = env["G"]
		var _t240 = J.add(J.gp(_t239, "x"), (J.mul(v_dt_216, 70.0) * (0.8 + J.mul(0.5, J.gp(env["G"], "speed")))))
		J.sp(_t239, "x", _t240)
		var _t241 = J.cmp(J.gp(env["G"], "x"), J.add(J.gp(env["G"], "lineX"), 40.0), ">")
		if ((not J.t(J.gp(env["G"], "fly"))) if _t241 else _t241):
			var _t242 = env["G"]
			var _t243 = {"t": 0.0, "dist": 0.0, "foul": true}
			J.sp(_t242, "fly", _t243)
			var _t244 = env["__p"]["say"]
			J.cl(_t244, null, ["踩線犯規！", 1.6])

func _f55(this_, a: Array, env):
	var v_c_217 = null; var v_H_218 = null; var v_gy_219 = null; var v_SC_220 = null; var v_fx_221 = null; var v_cam_222 = null; var v_bx_223 = null; var v_x_224 = null; var v_y_225 = null; var v_pose_226 = null; var v_pt_227 = null; var v_m_228 = null; var v_x_229 = null; var v_p_230 = null; var v_p_231 = null; var v_p_232 = null; var v_r_233 = null; var v_t_234 = null
	v_c_217 = J.arg(a, 0)
	v_H_218 = J.arg(a, 1)
	v_gy_219 = J.mul(v_H_218, 0.66)
	v_SC_220 = 1.6
	var _t247 = J.gp(env["G"], "fly")
	v_fx_221 = (J.add(J.gp(env["G"], "lineX"), (J.mul(J.gp(J.gp(env["G"], "fly"), "dist"), env["PX"]) * J.min_([1.0, J.div(J.gp(J.gp(env["G"], "fly"), "t"), 0.9)]))) if J.t(((not J.t(J.gp(J.gp(env["G"], "fly"), "foul"))) if J.t(_t247) else _t247)) else J.gp(env["G"], "x"))
	v_cam_222 = J.max_([0.0, J.min_([J.sub(J.add(J.gp(env["G"], "lineX"), J.mul(9.5, env["PX"])), 390.0), J.sub(v_fx_221, 150.0)])])
	var _t248 = env["G"]
	J.sp(_t248, "cam", v_cam_222)
	J.mc(v_c_217, "save", [])
	J.mc(v_c_217, "translate", [(-J.num(v_cam_222)), 0.0])
	J.sp(v_c_217, "fillStyle", "rgba(140,90,60,.6)")
	J.mc(v_c_217, "fillRect", [0.0, J.sub(v_gy_219, 8.0), J.add(J.gp(env["G"], "lineX"), J.mul(12.0, env["PX"])), 26.0])
	J.sp(v_c_217, "fillStyle", "rgba(225,195,125,.6)")
	J.mc(v_c_217, "fillRect", [J.gp(env["G"], "lineX"), J.sub(v_gy_219, 8.0), J.mul(10.0, env["PX"]), 26.0])
	J.sp(v_c_217, "fillStyle", "#f4f0e0")
	J.mc(v_c_217, "fillRect", [J.sub(J.gp(env["G"], "lineX"), 2.0), J.sub(v_gy_219, 10.0), 5.0, 30.0])
	J.sp(v_c_217, "font", "bold 11px sans-serif")
	J.sp(v_c_217, "textAlign", "center")
	v_m_228 = 1.0
	while true:
		if not J.cmp(v_m_228, 9.0, "<="): break
		v_x_229 = J.add(J.gp(env["G"], "lineX"), J.mul(v_m_228, env["PX"]))
		J.sp(v_c_217, "fillStyle", "rgba(255,255,255,.6)")
		J.mc(v_c_217, "fillRect", [v_x_229, J.add(v_gy_219, 18.0), 1.5, 7.0])
		J.mc(v_c_217, "fillText", [J.add(v_m_228, "米"), v_x_229, J.add(v_gy_219, 38.0)])
		v_m_228 = J.num(v_m_228) + 1.0
	var _t250 = J.gp(env["G"], "lineX")
	var _t249 = env["__p"]["target"]
	v_bx_223 = J.add(_t250, J.mul(J.cl(_t249, null, ["jump"]), env["PX"]))
	J.sp(v_c_217, "fillStyle", "#c0392b")
	J.mc(v_c_217, "fillRect", [v_bx_223, J.sub(v_gy_219, 44.0), 3.0, 44.0])
	J.mc(v_c_217, "fillRect", [J.add(v_bx_223, 3.0), J.sub(v_gy_219, 44.0), 30.0, 16.0])
	J.sp(v_c_217, "fillStyle", "#fff")
	J.sp(v_c_217, "font", "bold 10px sans-serif")
	J.sp(v_c_217, "textAlign", "left")
	J.mc(v_c_217, "fillText", ["Bryan", J.add(v_bx_223, 4.0), J.sub(v_gy_219, 32.0)])
	v_x_224 = J.gp(env["G"], "x")
	v_y_225 = v_gy_219
	v_pose_226 = null
	v_pt_227 = 0.0
	var _t251 = J.gp(env["G"], "fly")
	if J.t(((not J.t(J.gp(J.gp(env["G"], "fly"), "foul"))) if J.t(_t251) else _t251)):
		v_p_230 = J.min_([1.0, J.div(J.gp(J.gp(env["G"], "fly"), "t"), 0.9)])
		v_x_224 = v_fx_221
		var _t252 = J.sub(v_gy_219, (sin(J.num(J.mul(v_p_230, PI))) * 110.0))
		v_y_225 = _t252
		var _t253 = ("air" if J.cmp(v_p_230, 1.0, "<") else null)
		v_pose_226 = _t253
		v_pt_227 = v_p_230
	else:
		var _t254 = (not J.t(J.gp(env["G"], "fly")))
		if (J.cmp(J.gp(env["G"], "hop"), env["HOPS"], "<") if _t254 else _t254):
			v_p_231 = J.div(J.gp(env["G"], "hopT"), env["T"])
			var _t255 = J.sub(v_gy_219, (sin(J.num(J.mul(v_p_231, PI))) * 34.0))
			v_y_225 = _t255
	var _t256 = (not J.t(J.gp(env["G"], "fly")))
	if (J.cmp(J.gp(env["G"], "hop"), env["HOPS"], "<") if _t256 else _t256):
		v_p_232 = J.div(J.gp(env["G"], "hopT"), env["T"])
		v_r_233 = (10.0 + (J.sub(1.0, v_p_232) * 34.0))
		var _t257 = ("#ffd84a" if J.cmp(v_p_232, 0.75, ">") else "rgba(255,255,255,.55)")
		J.sp(v_c_217, "strokeStyle", _t257)
		J.sp(v_c_217, "lineWidth", 3.0)
		J.mc(v_c_217, "beginPath", [])
		J.mc(v_c_217, "ellipse", [J.gp(env["G"], "x"), J.add(v_gy_219, 4.0), v_r_233, J.mul(v_r_233, 0.32), 0.0, 0.0, (PI * 2.0)])
		J.mc(v_c_217, "stroke", [])
	var _t258 = env["__p"]["char"]
	J.cl(_t258, null, [v_c_217, J.gp(J.gp(env["G"], "a"), "k"), v_x_224, v_y_225, v_SC_220, {"pose": v_pose_226, "pt": v_pt_227, "shadow": false}])
	var _t259 = J.gp(env["G"], "fly")
	var _t260 = ((not J.t(J.gp(J.gp(env["G"], "fly"), "foul"))) if J.t(_t259) else _t259)
	if J.t((J.cmp(J.gp(J.gp(env["G"], "fly"), "t"), 0.9, ">") if J.t(_t260) else _t260)):
		J.sp(v_c_217, "fillStyle", "#ffd84a")
		J.mc(v_c_217, "fillRect", [J.sub(v_fx_221, 1.0), J.sub(v_gy_219, 6.0), 3.0, 22.0])
	J.mc(v_c_217, "restore", [])
	var _t261 = (not J.t(J.gp(env["G"], "fly")))
	if (J.cmp(J.gp(env["G"], "hop"), env["HOPS"], ">=") if _t261 else _t261):
		J.mc(v_c_217, "save", [])
		J.sp(v_c_217, "font", "bold 24px sans-serif")
		J.sp(v_c_217, "textAlign", "center")
		J.sp(v_c_217, "lineWidth", 5.0)
		J.sp(v_c_217, "strokeStyle", "#000")
		J.sp(v_c_217, "fillStyle", "#ffd84a")
		J.mc(v_c_217, "strokeText", ["起跳！", 195.0, J.mul(v_H_218, 0.3)])
		J.mc(v_c_217, "fillText", ["起跳！", 195.0, J.mul(v_H_218, 0.3)])
		J.mc(v_c_217, "restore", [])
	var _t262 = J.gp(env["G"], "fly")
	var _t263 = ((not J.t(J.gp(J.gp(env["G"], "fly"), "foul"))) if J.t(_t262) else _t262)
	if J.t((J.cmp(J.gp(J.gp(env["G"], "fly"), "t"), 0.9, ">") if J.t(_t263) else _t263)):
		J.mc(v_c_217, "save", [])
		J.sp(v_c_217, "font", "bold 30px sans-serif")
		J.sp(v_c_217, "textAlign", "center")
		J.sp(v_c_217, "lineWidth", 6.0)
		J.sp(v_c_217, "strokeStyle", "#000")
		J.sp(v_c_217, "fillStyle", "#fff")
		var _t264 = J.gp(J.gp(env["G"], "fly"), "dist")
		v_t_234 = J.add(J.mc(_t264, "toFixed", [2.0]), " 米")
		J.mc(v_c_217, "strokeText", [v_t_234, 195.0, J.mul(v_H_218, 0.3)])
		J.mc(v_c_217, "fillText", [v_t_234, 195.0, J.mul(v_H_218, 0.3)])
		J.mc(v_c_217, "restore", [])

func _f46(this_, a: Array, env):
	var _s78 = {"__p": env, "G": null, "T": null, "HOPS": null, "PX": null, "avg": null, "tapHop": null, "takeoff": null}
	_s78["G"] = J.arg(a, 0)
	_s78["T"] = 0.56
	_s78["HOPS"] = 6.0
	_s78["PX"] = 30.0
	J.S_Object_("assign", [_s78["G"], {"x": 40.0, "hop": 0.0, "hopT": 0.0, "acc": [], "speed": 0.6, "line": 0.0, "fly": null, "tapped": {}, "lineX": 0.0, "cam": 0.0}])
	var _t192 = _s78["G"]
	var _t193 = ((40.0 + J.mul(_s78["HOPS"], 48.0)) + 40.0)
	J.sp(_t192, "lineX", _t193)
	var _t194 = _s78["G"]
	var _t195 = Callable(self, "_f47").bind(_s78)
	J.sp(_t194, "hud", _t195)
	_s78["avg"] = Callable(self, "_f48").bind(_s78)
	_s78["tapHop"] = Callable(self, "_f50").bind(_s78)
	_s78["takeoff"] = Callable(self, "_f51").bind(_s78)
	var _t212 = _s78["__p"]["btns"]
	J.cl(_t212, null, [[["跳", Callable(self, "_f52").bind(_s78)]]])
	var _t213 = _s78["G"]
	var _t214 = Callable(self, "_f53").bind(_s78)
	J.sp(_t213, "down", _t214)
	var _t215 = _s78["G"]
	var _t245 = Callable(self, "_f54").bind(_s78)
	J.sp(_t215, "tick", _t245)
	var _t246 = _s78["G"]
	var _t265 = Callable(self, "_f55").bind(_s78)
	J.sp(_t246, "draw", _t265)

func _f57(this_, a: Array, env):
	return ("剩 " + J.str(J.max_([0.0, ceil(J.num(J.gp(env["G"], "time")))])) + " 秒")

func _f58(this_, a: Array, env):
	if J.t(J.gp(env["G"], "done")):
		return null
	if J.cmp(J.gp(env["G"], "taut"), 0.0, ">"):
		var _t270 = env["G"]
		var _t271 = J.sub(J.gp(_t270, "p"), 0.07)
		J.sp(_t270, "p", _t271)
		var _t272 = env["G"]
		J.sp(_t272, "slip", 0.5)
		var _t273 = env["__p"]["pop"]
		J.cl(_t273, null, ["舌頭打滑！", 120.0, J.mul(J.gp(env["G"], "H"), 0.42), "#ff8080", 16.0])
		return null
	var _t274 = env["G"]
	var _t275 = J.add(J.gp(_t274, "p"), J.mul(0.032, J.gp(env["G"], "gpf")))
	J.sp(_t274, "p", _t275)
	if (randf() < 0.25):
		var _t276 = env["__p"]["pop"]
		J.cl(_t276, null, ["拉！", (90.0 + (randf() * 40.0)), J.mul(J.gp(env["G"], "H"), 0.46), "#ffe8a0", 14.0])

func _f59(this_, a: Array, env):
	if J.seq(J.gp(env["G"], "phase"), "play"):
		J.cl(env["pull"], null, [])

func _f60(this_, a: Array, env):
	var v_dt_237 = null; var v_surge_238 = null
	v_dt_237 = J.arg(a, 0)
	if J.t(J.gp(env["G"], "done")):
		return null
	var _t281 = env["G"]
	var _t282 = J.sub(J.gp(_t281, "time"), v_dt_237)
	J.sp(_t281, "time", _t282)
	var _t283 = env["G"]
	var _t284 = J.max_([0.0, J.sub(J.gp(env["G"], "slip"), v_dt_237)])
	J.sp(_t283, "slip", _t284)
	v_surge_238 = (0.22 if (sin(J.num(J.mul(J.gp(env["G"], "t"), 1.3))) > 0.85) else 0.0)
	var _t285 = env["G"]
	var _t286 = J.sub(J.gp(_t285, "p"), J.mul(v_dt_237, J.add(J.add(J.gp(env["G"], "ai"), v_surge_238), (J.max_([0.0, J.sub(J.gp(env["G"], "t"), 8.0)]) * 0.004))))
	J.sp(_t285, "p", _t286)
	var _t287 = env["G"]
	var _t288 = J.sub(J.gp(_t287, "tautT"), v_dt_237)
	J.sp(_t287, "tautT", _t288)
	if J.cmp(J.gp(env["G"], "tautT"), 0.0, "<="):
		var _t289 = env["G"]
		J.sp(_t289, "taut", 0.85)
		var _t290 = env["G"]
		var _t291 = (1.8 + (randf() * 1.8))
		J.sp(_t290, "tautT", _t291)
	if J.cmp(J.gp(env["G"], "taut"), 0.0, ">"):
		var _t292 = env["G"]
		var _t293 = J.sub(J.gp(_t292, "taut"), v_dt_237)
		J.sp(_t292, "taut", _t293)
	if J.cmp(J.gp(env["G"], "p"), 1.0, ">="):
		var _t294 = env["__p"]["finish"]
		var _t295 = env["__p"]["D"]
		J.cl(_t294, null, [1.0, J.cl(_t295, null, ["轆轤首條頸拉到打咗個結。佢話下年再嚟。", "轆轤首的脖子被拉到打了個結。她說明年再來。"])])
	else:
		if J.cmp(J.gp(env["G"], "p"), (-1.0), "<="):
			var _t296 = env["__p"]["finish"]
			var _t297 = env["__p"]["D"]
			J.cl(_t296, null, [0.0, J.cl(_t297, null, ["條脷被拉咗過對面，要行過去執返。", "舌頭被拉到對面，要走過去撿回來。"])])
		else:
			if J.cmp(J.gp(env["G"], "time"), 0.0, "<="):
				var _t298 = env["__p"]["finish"]
				var _t302 = (1.0 if J.cmp(J.gp(env["G"], "p"), 0.0, ">") else 0.0)
				var _t301 = null
				if J.cmp(J.gp(env["G"], "p"), 0.0, ">"):
					var _t299 = env["__p"]["D"]
					_t301 = J.cl(_t299, null, ["夠鐘，面旗喺你嗰邊。險勝。", "時間到，旗子在你這邊。險勝。"])
				else:
					var _t300 = env["__p"]["D"]
					_t301 = J.cl(_t300, null, ["夠鐘，面旗喺對面。差少少。", "時間到，旗子在對面。差一點。"])
				J.cl(_t298, null, [_t302, _t301])

func _f61(this_, a: Array, env):
	var v_c_239 = null; var v_H_240 = null; var v_gy_241 = null; var v_cx_242 = null; var v_ry_243 = null; var v_LH_244 = null; var v_RH_245 = null; var v_ropeCol_246 = null; var v_tx_247 = null
	v_c_239 = J.arg(a, 0)
	v_H_240 = J.arg(a, 1)
	v_gy_241 = J.mul(v_H_240, 0.68)
	v_cx_242 = (195.0 + J.mul(J.gp(env["G"], "p"), 100.0))
	v_ry_243 = J.sub(v_gy_241, 66.0)
	var _t305 = (not J.seq(J.typeof_(J.G.get("CHAR_H")), "undefined"))
	var _t306 = (J.gp(J.G.get("CHAR_H"), J.gp(J.gp(env["G"], "a"), "k")) if _t305 else _t305)
	v_LH_244 = J.mul((_t306 if J.t(_t306) else 56.0), 1.6)
	var _t307 = (not J.seq(J.typeof_(J.G.get("CHAR_H")), "undefined"))
	var _t308 = (J.gp(J.G.get("CHAR_H"), J.gp(J.gp(env["G"], "E"), "foe")) if _t307 else _t307)
	v_RH_245 = J.mul((_t308 if J.t(_t308) else 56.0), 1.6)
	J.sp(v_c_239, "fillStyle", "rgba(255,255,255,.75)")
	J.mc(v_c_239, "fillRect", [94.0, J.sub(v_ry_243, 24.0), 3.0, 40.0])
	J.mc(v_c_239, "fillRect", [293.0, J.sub(v_ry_243, 24.0), 3.0, 40.0])
	J.sp(v_c_239, "fillStyle", "rgba(255,255,255,.3)")
	J.mc(v_c_239, "fillRect", [194.0, J.sub(v_ry_243, 18.0), 2.0, 34.0])
	v_ropeCol_246 = ("#ff4040" if J.cmp(J.gp(env["G"], "taut"), 0.0, ">") else ("#c0392b" if J.seq(J.gp(J.gp(env["G"], "a"), "k"), "afu") else "#d86a7a"))
	J.sp(v_c_239, "strokeStyle", v_ropeCol_246)
	var _t309 = (6.0 if J.cmp(J.gp(env["G"], "taut"), 0.0, ">") else 5.0)
	J.sp(v_c_239, "lineWidth", _t309)
	J.mc(v_c_239, "beginPath", [])
	J.mc(v_c_239, "moveTo", [70.0, J.sub(v_gy_241, J.mul(v_LH_244, 0.62))])
	J.mc(v_c_239, "quadraticCurveTo", [J.sub(v_cx_242, 50.0), J.add(J.add(v_ry_243, 8.0), (sin(J.num(J.mul(J.gp(env["G"], "t"), 9.0))) * (1.0 if J.cmp(J.gp(env["G"], "taut"), 0.0, ">") else 4.0))), v_cx_242, v_ry_243])
	J.mc(v_c_239, "stroke", [])
	J.sp(v_c_239, "strokeStyle", "#e8dcc8")
	J.sp(v_c_239, "lineWidth", 7.0)
	J.mc(v_c_239, "beginPath", [])
	J.mc(v_c_239, "moveTo", [v_cx_242, v_ry_243])
	J.mc(v_c_239, "quadraticCurveTo", [J.add(v_cx_242, 60.0), J.sub(v_ry_243, 4.0), 326.0, J.sub(v_gy_241, J.mul(v_RH_245, 0.82))])
	J.mc(v_c_239, "stroke", [])
	J.sp(v_c_239, "fillStyle", "#ffd84a")
	J.mc(v_c_239, "beginPath", [])
	J.mc(v_c_239, "moveTo", [v_cx_242, v_ry_243])
	J.mc(v_c_239, "lineTo", [v_cx_242, J.sub(v_ry_243, 32.0)])
	J.mc(v_c_239, "lineTo", [J.add(v_cx_242, 20.0), J.sub(v_ry_243, 24.0)])
	J.mc(v_c_239, "lineTo", [v_cx_242, J.sub(v_ry_243, 16.0)])
	J.mc(v_c_239, "fill", [])
	J.sp(v_c_239, "fillStyle", "#5a3a1a")
	J.mc(v_c_239, "fillRect", [J.sub(v_cx_242, 1.0), J.sub(v_ry_243, 32.0), 2.0, 32.0])
	var _t310 = env["__p"]["char"]
	J.cl(_t310, null, [v_c_239, J.gp(J.gp(env["G"], "a"), "k"), 58.0, v_gy_241, 1.6, {"pose": ("hurt" if J.cmp(J.gp(env["G"], "slip"), 0.0, ">") else null), "pt": 0.5, "shadow": false, "rot": ((-0.15) - (0.0 if J.cmp(J.gp(env["G"], "taut"), 0.0, ">") else 0.05))}])
	var _t311 = env["__p"]["char"]
	J.cl(_t311, null, [v_c_239, J.gp(J.gp(env["G"], "E"), "foe"), 338.0, v_gy_241, 1.6, {"flip": true, "shadow": false, "rot": 0.15}])
	if J.cmp(J.gp(env["G"], "taut"), 0.0, ">"):
		J.mc(v_c_239, "save", [])
		J.sp(v_c_239, "font", "bold 20px sans-serif")
		J.sp(v_c_239, "textAlign", "center")
		J.sp(v_c_239, "fillStyle", "#ff6060")
		J.sp(v_c_239, "lineWidth", 4.0)
		J.sp(v_c_239, "strokeStyle", "#000")
		var _t312 = env["__p"]["Lx"]
		v_tx_247 = J.cl(_t312, null, [env["__p"]["TAUT"]])
		J.mc(v_c_239, "strokeText", [v_tx_247, 195.0, J.mul(v_H_240, 0.3)])
		J.mc(v_c_239, "fillText", [v_tx_247, 195.0, J.mul(v_H_240, 0.3)])
		J.mc(v_c_239, "restore", [])

func _f56(this_, a: Array, env):
	var _s104 = {"__p": env, "G": null, "pull": null}
	_s104["G"] = J.arg(a, 0)
	J.S_Object_("assign", [_s104["G"], {"p": 0.0, "ai": 0.12, "taut": 0.0, "tautT": 2.2, "time": 30.0, "slip": 0.0}])
	var _t268 = _s104["G"]
	var _t269 = Callable(self, "_f57").bind(_s104)
	J.sp(_t268, "hud", _t269)
	_s104["pull"] = Callable(self, "_f58").bind(_s104)
	var _t277 = _s104["__p"]["btns"]
	J.cl(_t277, null, [[["拉", _s104["pull"]]]])
	var _t278 = _s104["G"]
	var _t279 = Callable(self, "_f59").bind(_s104)
	J.sp(_t278, "down", _t279)
	var _t280 = _s104["G"]
	var _t303 = Callable(self, "_f60").bind(_s104)
	J.sp(_t280, "tick", _t303)
	var _t304 = _s104["G"]
	var _t313 = Callable(self, "_f61").bind(_s104)
	J.sp(_t304, "draw", _t313)

func _f63(this_, a: Array, env):
	return (J.str(floor(J.num(J.gp(env["G"], "time")))) + " 秒")

func _f64(this_, a: Array, env):
	var v_p_249 = null
	v_p_249 = J.arg(a, 0)
	var _t323 = (not J.seq(J.gp(env["G"], "phase"), "play"))
	if J.t((_t323 if _t323 else J.gp(env["G"], "fall"))):
		return null
	var _t324 = env["G"]
	J.sp(_t324, "hold", true)
	var _t325 = env["G"]
	var _t326 = J.gp(v_p_249, "x")
	J.sp(_t325, "fx0", _t326)
	var _t327 = env["G"]
	J.sp(_t327, "dx", 0.0)

func _f65(this_, a: Array, env):
	var v_p_250 = null
	v_p_250 = J.arg(a, 0)
	var _t330 = J.gp(env["G"], "hold")
	if J.t(((not J.leq(J.gp(env["G"], "fx0"), null)) if J.t(_t330) else _t330)):
		var _t331 = env["G"]
		var _t332 = J.div(J.sub(J.gp(v_p_250, "x"), J.gp(env["G"], "fx0")), 90.0)
		J.sp(_t331, "dx", _t332)

func _f66(this_, a: Array, env):
	var _t335 = J.gp(env["G"], "hold")
	var _t336 = ((not J.t(J.gp(env["G"], "done"))) if J.t(_t335) else _t335)
	var _t337 = ((not J.t(J.gp(env["G"], "fall"))) if J.t(_t336) else _t336)
	if J.t((J.cmp(J.gp(env["G"], "time"), 0.3, ">") if J.t(_t337) else _t337)):
		var _t338 = env["G"]
		var _t339 = {"t": 0.0}
		J.sp(_t338, "fall", _t339)
		var _t340 = env["__p"]["say"]
		J.cl(_t340, null, ["放手了！", 1.4])
	var _t341 = env["G"]
	J.sp(_t341, "hold", false)

func _f67(this_, a: Array, env):
	var v_dt_251 = null; var v_lv_252 = null; var v_f_253 = null
	v_dt_251 = J.arg(a, 0)
	if J.t(J.gp(env["G"], "fall")):
		var _t344 = J.gp(env["G"], "fall")
		var _t345 = J.add(J.gp(_t344, "t"), v_dt_251)
		J.sp(_t344, "t", _t345)
		var _t346 = J.cmp(J.gp(J.gp(env["G"], "fall"), "t"), 1.0, ">")
		if ((not J.t(J.gp(env["G"], "done"))) if _t346 else _t346):
			var _t347 = env["__p"]["finish"]
			var _t348 = J.gp(env["G"], "time")
			var _t354 = J.num(J.mc(_t348, "toFixed", [1.0]))
			var _t350 = J.gp(env["G"], "time")
			var _t349 = env["__p"]["target"]
			var _t353 = null
			if J.cmp(_t350, J.cl(_t349, null, ["hang"]), ">"):
				var _t351 = env["__p"]["D"]
				_t353 = J.cl(_t351, null, ["跌落嚟嗰陣，啱啱壓住 Bryan 塊紀錄牌。", "掉下來的時候，剛好壓住 Bryan 的紀錄牌。"])
			else:
				var _t352 = env["__p"]["D"]
				_t353 = J.cl(_t352, null, ["落地。清潔安娣：「又係你，日日都跌落嚟。」", "落地。清潔安娣：「又是你，每天都掉下來。」"])
			J.cl(_t347, null, [_t354, _t353])
		return null
	if (not J.t(J.gp(env["G"], "hold"))):
		return null
	var _t355 = env["G"]
	var _t356 = J.add(J.gp(_t355, "time"), v_dt_251)
	J.sp(_t355, "time", _t356)
	v_lv_252 = (1.0 + J.div(J.gp(env["G"], "time"), 20.0))
	var _t357 = env["G"]
	var _t358 = J.sub(J.gp(_t357, "evT"), v_dt_251)
	J.sp(_t357, "evT", _t358)
	if J.cmp(J.gp(env["G"], "evT"), 0.0, "<="):
		var _t359 = env["G"]
		var _t360 = {"k": ("fan" if (randf() < 0.5) else "broom"), "t": 0.0, "dir": ((-1.0) if (randf() < 0.5) else 1.0)}
		J.sp(_t359, "ev", _t360)
		var _t361 = env["G"]
		var _t362 = (3.0 + J.div((randf() * 3.0), v_lv_252))
		J.sp(_t361, "evT", _t362)
		var _t363 = env["__p"]["pop"]
		J.cl(_t363, null, [("風扇開了！" if J.seq(J.gp(J.gp(env["G"], "ev"), "k"), "fan") else "安娣的掃把！"), 195.0, J.mul(J.gp(env["G"], "H"), 0.62), "#ffe8a0", 16.0])
	v_f_253 = (J.mul((sin(J.num(J.mul(J.gp(env["G"], "t"), 1.7))) * 0.35), v_lv_252) + J.mul((sin(J.num((J.mul(J.gp(env["G"], "t"), 0.63) + 1.0))) * 0.25), v_lv_252))
	if J.t(J.gp(env["G"], "ev")):
		var _t364 = J.gp(env["G"], "ev")
		var _t365 = J.add(J.gp(_t364, "t"), v_dt_251)
		J.sp(_t364, "t", _t365)
		var _t366 = J.add(v_f_253, (J.mul(J.mul(J.gp(J.gp(env["G"], "ev"), "dir"), (1.1 if J.seq(J.gp(J.gp(env["G"], "ev"), "k"), "fan") else 2.2)), v_lv_252) * (J.max_([0.0, (1.0 - (absf(J.num(J.sub(J.gp(J.gp(env["G"], "ev"), "t"), 0.4))) * 3.0))]) if J.seq(J.gp(J.gp(env["G"], "ev"), "k"), "broom") else 1.0)))
		v_f_253 = _t366
		if J.cmp(J.gp(J.gp(env["G"], "ev"), "t"), (1.8 if J.seq(J.gp(J.gp(env["G"], "ev"), "k"), "fan") else 0.9), ">"):
			var _t367 = env["G"]
			J.sp(_t367, "ev", null)
	var _t368 = env["G"]
	var _t369 = J.add(J.gp(_t368, "v"), J.mul((J.sub(v_f_253, J.mul(J.gp(env["G"], "dx"), 2.6)) - J.mul(J.gp(env["G"], "sw"), 0.6)), v_dt_251))
	J.sp(_t368, "v", _t369)
	var _t370 = env["G"]
	var _t371 = J.mul(J.gp(_t370, "v"), 0.985)
	J.sp(_t370, "v", _t371)
	var _t372 = env["G"]
	var _t373 = J.add(J.gp(_t372, "sw"), (J.mul(J.gp(env["G"], "v"), v_dt_251) * 1.6))
	J.sp(_t372, "sw", _t373)
	if (absf(J.num(J.gp(env["G"], "sw"))) > 1.0):
		var _t374 = env["G"]
		var _t375 = {"t": 0.0}
		J.sp(_t374, "fall", _t375)
		var _t376 = env["__p"]["say"]
		J.cl(_t376, null, ["甩下來了！", 1.4])

func _f68(this_, a: Array, env):
	var v_c_254 = null; var v_H_255 = null; var v_cy_256 = null; var v_ang_257 = null; var v_fy_258 = null; var v_x_259 = null; var v_i_260 = null; var v_x_261 = null
	v_c_254 = J.arg(a, 0)
	v_H_255 = J.arg(a, 1)
	v_cy_256 = J.mul(v_H_255, 0.18)
	J.sp(v_c_254, "fillStyle", "rgba(60,50,70,.9)")
	J.mc(v_c_254, "fillRect", [0.0, 0.0, 390.0, v_cy_256])
	J.sp(v_c_254, "fillStyle", "rgba(255,255,255,.08)")
	v_x_259 = 0.0
	while true:
		if not J.cmp(v_x_259, 390.0, "<"): break
		J.mc(v_c_254, "fillRect", [v_x_259, J.sub(v_cy_256, 2.0), 46.0, 2.0])
		var _t379 = J.add(v_x_259, 48.0)
		v_x_259 = _t379
	J.sp(v_c_254, "fillStyle", "rgba(0,0,0,.5)")
	J.mc(v_c_254, "fillRect", [95.0, J.mul(v_H_255, 0.84), 200.0, 10.0])
	J.sp(v_c_254, "fillStyle", "rgba(120,220,120,.6)")
	J.mc(v_c_254, "fillRect", [165.0, J.mul(v_H_255, 0.84), 60.0, 10.0])
	var _t380 = ("#ff5050" if (absf(J.num(J.gp(env["G"], "sw"))) > 0.7) else "#ffd84a")
	J.sp(v_c_254, "fillStyle", _t380)
	J.mc(v_c_254, "fillRect", [((195.0 + J.mul(J.gp(env["G"], "sw"), 100.0)) - 3.0), (J.mul(v_H_255, 0.84) - 4.0), 6.0, 18.0])
	v_ang_257 = J.mul(J.gp(env["G"], "sw"), 0.6)
	v_fy_258 = (J.min_([J.mul(v_H_255, 0.72), J.add(v_cy_256, (J.mul(J.gp(J.gp(env["G"], "fall"), "t"), J.gp(J.gp(env["G"], "fall"), "t")) * 900.0))]) if J.t(J.gp(env["G"], "fall")) else v_cy_256)
	J.mc(v_c_254, "save", [])
	J.mc(v_c_254, "translate", [195.0, v_fy_258])
	J.mc(v_c_254, "rotate", [J.add(PI, v_ang_257)])
	var _t381 = env["__p"]["char"]
	J.cl(_t381, null, [v_c_254, J.gp(J.gp(env["G"], "a"), "k"), 0.0, 0.0, 2.0, {"shadow": false, "pose": ("hurt" if J.t(J.gp(env["G"], "fall")) else null), "pt": 0.5}])
	J.mc(v_c_254, "restore", [])
	var _t382 = (not J.t(J.gp(env["G"], "hold")))
	var _t383 = ((not J.t(J.gp(env["G"], "fall"))) if _t382 else _t382)
	if (J.seq(J.gp(env["G"], "phase"), "play") if _t383 else _t383):
		J.mc(v_c_254, "save", [])
		J.sp(v_c_254, "font", "bold 18px sans-serif")
		J.sp(v_c_254, "textAlign", "center")
		J.sp(v_c_254, "fillStyle", "#fff")
		J.mc(v_c_254, "fillText", ["按住畫面抓實天花板", 195.0, J.mul(v_H_255, 0.55)])
		J.mc(v_c_254, "restore", [])
	var _t384 = J.gp(env["G"], "ev")
	if J.t((J.seq(J.gp(J.gp(env["G"], "ev"), "k"), "fan") if J.t(_t384) else _t384)):
		J.mc(v_c_254, "save", [])
		J.mc(v_c_254, "translate", [(370.0 if J.cmp(J.gp(J.gp(env["G"], "ev"), "dir"), 0.0, "<") else 20.0), J.mul(v_H_255, 0.4)])
		J.mc(v_c_254, "rotate", [J.mul(J.gp(env["G"], "t"), 20.0)])
		J.sp(v_c_254, "strokeStyle", "rgba(255,255,255,.6)")
		J.sp(v_c_254, "lineWidth", 4.0)
		v_i_260 = 0.0
		while true:
			if not J.cmp(v_i_260, 3.0, "<"): break
			J.mc(v_c_254, "rotate", [J.div((PI * 2.0), 3.0)])
			J.mc(v_c_254, "beginPath", [])
			J.mc(v_c_254, "moveTo", [0.0, 0.0])
			J.mc(v_c_254, "lineTo", [22.0, 0.0])
			J.mc(v_c_254, "stroke", [])
			v_i_260 = J.num(v_i_260) + 1.0
		J.mc(v_c_254, "restore", [])
	var _t385 = J.gp(env["G"], "ev")
	if J.t((J.seq(J.gp(J.gp(env["G"], "ev"), "k"), "broom") if J.t(_t385) else _t385)):
		v_x_261 = (195.0 - J.mul(J.gp(J.gp(env["G"], "ev"), "dir"), (160.0 - J.mul(J.gp(J.gp(env["G"], "ev"), "t"), 300.0))))
		J.mc(v_c_254, "save", [])
		J.sp(v_c_254, "strokeStyle", "#8a6a3a")
		J.sp(v_c_254, "lineWidth", 5.0)
		J.mc(v_c_254, "beginPath", [])
		J.mc(v_c_254, "moveTo", [v_x_261, J.mul(v_H_255, 0.75)])
		J.mc(v_c_254, "lineTo", [J.add(v_x_261, J.mul(J.gp(J.gp(env["G"], "ev"), "dir"), 20.0)), J.mul(v_H_255, 0.32)])
		J.mc(v_c_254, "stroke", [])
		J.sp(v_c_254, "fillStyle", "#c8a860")
		J.mc(v_c_254, "fillRect", [J.sub(J.add(v_x_261, J.mul(J.gp(J.gp(env["G"], "ev"), "dir"), 20.0)), 14.0), J.mul(v_H_255, 0.28), 28.0, 10.0])
		J.mc(v_c_254, "restore", [])
	J.mc(v_c_254, "save", [])
	J.sp(v_c_254, "font", "12px sans-serif")
	J.sp(v_c_254, "textAlign", "right")
	J.sp(v_c_254, "fillStyle", "#ffd0c0")
	var _t386 = env["__p"]["target"]
	J.mc(v_c_254, "fillText", [("Bryan：" + J.str(J.cl(_t386, null, ["hang"])) + " 秒"), 380.0, J.mul(v_H_255, 0.82)])
	J.mc(v_c_254, "restore", [])

func _f62(this_, a: Array, env):
	var _s113 = {"__p": env, "G": null}
	_s113["G"] = J.arg(a, 0)
	J.S_Object_("assign", [_s113["G"], {"hold": false, "sw": 0.0, "v": 0.0, "fx0": null, "time": 0.0, "push": 0.0, "evT": 4.0, "ev": null, "fall": null}])
	var _t316 = _s113["G"]
	var _t317 = Callable(self, "_f63").bind(_s113)
	J.sp(_t316, "hud", _t317)
	var _t318 = _s113["__p"]["btns"]
	J.cl(_t318, null, [[]])
	var _t319 = J.G.get("$")
	var _t320 = J.cl(_t319, null, ["#sp-btns"])
	var _t321 = "<p class=\"sp-tip\">按住畫面開始，左右拖動保持平衡</p>"
	J.sp(_t320, "innerHTML", _t321)
	var _t322 = _s113["G"]
	var _t328 = Callable(self, "_f64").bind(_s113)
	J.sp(_t322, "down", _t328)
	var _t329 = _s113["G"]
	var _t333 = Callable(self, "_f65").bind(_s113)
	J.sp(_t329, "move", _t333)
	var _t334 = _s113["G"]
	var _t342 = Callable(self, "_f66").bind(_s113)
	J.sp(_t334, "up", _t342)
	var _t343 = _s113["G"]
	var _t377 = Callable(self, "_f67").bind(_s113)
	J.sp(_t343, "tick", _t377)
	var _t378 = _s113["G"]
	var _t387 = Callable(self, "_f68").bind(_s113)
	J.sp(_t378, "draw", _t387)

func _f70(this_, a: Array, env):
	var _t392 = J.min_([50.0, floor(J.num(J.gp(env["G"], "dist")))])
	var _t391 = J.gp(env["G"], "time")
	return (J.str(_t392) + "／50 米　" + J.str(J.mc(_t391, "toFixed", [1.0])) + " 秒")

func _f71(this_, a: Array, env):
	var v_side_264 = null; var v_gap_265 = null; var v_same_266 = null; var v_power_267 = null; var v_kick_268 = null
	v_side_264 = J.arg(a, 0)
	if J.t(J.gp(env["G"], "finished")):
		return null
	v_gap_265 = J.sub(J.gp(env["G"], "t"), J.gp(env["G"], "lastT"))
	var _t394 = env["G"]
	var _t395 = J.gp(env["G"], "t")
	J.sp(_t394, "lastT", _t395)
	v_same_266 = J.seq(v_side_264, J.gp(env["G"], "lastSide"))
	var _t396 = env["G"]
	J.sp(_t396, "lastSide", v_side_264)
	var _t397 = env["G"]
	J.sp(_t397, "stroke", 0.35)
	v_power_267 = (1.0 if J.cmp(J.gp(env["G"], "water"), 0.25, ">") else 0.45)
	var _t398 = env["G"]
	var _t399 = J.add(J.gp(_t398, "vel"), J.mul((J.mul((0.5 if J.t(v_same_266) else 2.1), v_power_267) * (0.6 if J.cmp(v_gap_265, 0.22, "<") else 1.0)), J.gp(env["G"], "gpf")))
	J.sp(_t398, "vel", _t399)
	v_kick_268 = (0.9 if J.t(v_same_266) else 0.35)
	if J.cmp(v_gap_265, 0.22, "<"):
		var _t400 = J.add(v_kick_268, 0.6)
		v_kick_268 = _t400
	var _t401 = env["G"]
	var _t402 = J.add(J.gp(_t401, "sv"), J.mul(v_side_264, v_kick_268))
	J.sp(_t401, "sv", _t402)
	if J.t(v_same_266):
		var _t403 = env["__p"]["pop"]
		J.cl(_t403, null, ["同一邊！", (195.0 + J.mul(v_side_264, 70.0)), J.mul(J.gp(env["G"], "H"), 0.38), "#ffb0a0", 14.0])

func _f72(this_, a: Array, env):
	var _t405 = env["stroke"]
	return J.cl(_t405, null, [(-1.0)])

func _f73(this_, a: Array, env):
	var _t406 = env["stroke"]
	return J.cl(_t406, null, [1.0])

func _f74(this_, a: Array, env):
	var v_dt_269 = null; var v_loss_270 = null
	v_dt_269 = J.arg(a, 0)
	if J.t(J.gp(env["G"], "finished")):
		return null
	var _t410 = env["G"]
	var _t411 = J.add(J.gp(_t410, "time"), v_dt_269)
	J.sp(_t410, "time", _t411)
	var _t412 = env["G"]
	var _t413 = J.max_([0.0, J.sub(J.gp(env["G"], "stroke"), v_dt_269)])
	J.sp(_t412, "stroke", _t413)
	var _t414 = env["G"]
	var _t415 = J.mul(J.gp(_t414, "vel"), pow(J.num(0.35), J.num(v_dt_269)))
	J.sp(_t414, "vel", _t415)
	var _t416 = env["G"]
	var _t417 = J.add(J.gp(_t416, "dist"), (J.mul(J.gp(env["G"], "vel"), v_dt_269) * 0.5))
	J.sp(_t416, "dist", _t417)
	var _t418 = env["G"]
	var _t419 = J.add(J.gp(_t418, "sv"), J.mul(((-J.num(J.gp(env["G"], "slosh"))) * 14.0), v_dt_269))
	J.sp(_t418, "sv", _t419)
	var _t420 = env["G"]
	var _t421 = J.mul(J.gp(_t420, "sv"), pow(J.num(0.4), J.num(v_dt_269)))
	J.sp(_t420, "sv", _t421)
	var _t422 = env["G"]
	var _t423 = J.add(J.gp(_t422, "slosh"), (J.mul(J.gp(env["G"], "sv"), v_dt_269) * 3.0))
	J.sp(_t422, "slosh", _t423)
	if (absf(J.num(J.gp(env["G"], "slosh"))) > 0.55):
		v_loss_270 = (J.mul((absf(J.num(J.gp(env["G"], "slosh"))) - 0.55), v_dt_269) * 0.9)
		var _t424 = env["G"]
		var _t425 = J.max_([0.0, J.sub(J.gp(env["G"], "water"), v_loss_270)])
		J.sp(_t424, "water", _t425)
		if (randf() < J.mul(v_dt_269, 6.0)):
			var _t426 = env["__p"]["pop"]
			J.cl(_t426, null, ["水灑了！", 195.0, J.mul(J.gp(env["G"], "H"), 0.33), "#9fd8ff", 13.0])
	if J.cmp(J.gp(env["G"], "dist"), 50.0, ">="):
		var _t427 = env["G"]
		J.sp(_t427, "finished", true)
		var _t428 = env["__p"]["finish"]
		var _t429 = J.gp(env["G"], "time")
		var _t435 = J.num(J.mc(_t429, "toFixed", [1.0]))
		var _t434 = null
		if J.cmp(J.gp(env["G"], "water"), 0.6, ">"):
			var _t430 = env["__p"]["D"]
			_t434 = J.cl(_t430, null, ["游完，頭頂碟水仲有大半。河童協會頒發「穩陣獎」。", "游完，頭頂碟水還有大半。河童協會頒發「穩健獎」。"])
		else:
			var _t433 = null
			if J.cmp(J.gp(env["G"], "water"), 0.25, ">"):
				var _t431 = env["__p"]["D"]
				_t433 = J.cl(_t431, null, ["游完，碟水剩返一半，個頭有啲暈。", "游完了，碟裡的水剩一半，頭有點暈。"])
			else:
				var _t432 = env["__p"]["D"]
				_t433 = J.cl(_t432, null, ["碟水乾晒，最後幾米係爬上岸。", "碟水全乾了，最後幾米是爬上岸的。"])
			_t434 = _t433
		J.cl(_t428, null, [_t435, _t434])
	var _t436 = J.cmp(J.gp(env["G"], "time"), 60.0, ">")
	if ((not J.t(J.gp(env["G"], "finished"))) if _t436 else _t436):
		var _t437 = env["G"]
		J.sp(_t437, "finished", true)
		var _t438 = env["__p"]["finish"]
		var _t439 = env["__p"]["D"]
		J.cl(_t438, null, [null, J.cl(_t439, null, ["一分鐘都未游完。救生員（一隻水鬼）將你撈咗上岸。", "一分鐘都沒游完。救生員（一隻水鬼）把你撈上岸。"])])

func _f75(this_, a: Array, env):
	var v_c_271 = null; var v_H_272 = null; var v_top_273 = null; var v_bot_274 = null; var v_off_275 = null; var v_bd_276 = null; var v_bx_277 = null; var v_y_278 = null; var v_lean_279 = null; var v_SC_280 = null; var v_HH_281 = null; var v_fx_282 = null; var v_i_283 = null; var v_y_284 = null; var v_x_285 = null; var v_x_286 = null; var v_q_287 = null
	v_c_271 = J.arg(a, 0)
	v_H_272 = J.arg(a, 1)
	v_top_273 = J.mul(v_H_272, 0.4)
	v_bot_274 = J.mul(v_H_272, 0.78)
	J.sp(v_c_271, "fillStyle", "rgba(40,90,120,.75)")
	J.mc(v_c_271, "fillRect", [0.0, v_top_273, 390.0, J.sub(v_bot_274, v_top_273)])
	v_i_283 = 0.0
	while true:
		if not J.cmp(v_i_283, 6.0, "<"): break
		J.sp(v_c_271, "strokeStyle", "rgba(255,255,255,.12)")
		J.mc(v_c_271, "beginPath", [])
		v_y_284 = J.add(J.add(v_top_273, 12.0), J.div(J.mul(v_i_283, J.sub(v_bot_274, v_top_273)), 6.0))
		v_x_285 = 0.0
		while true:
			if not J.cmp(v_x_285, 390.0, "<="): break
			J.mc(v_c_271, "lineTo", [v_x_285, J.add(v_y_284, (sin(J.num(J.add((J.mul(v_x_285, 0.05) + J.mul(J.gp(env["G"], "t"), 2.0)), v_i_283))) * 2.0))])
			var _t442 = J.add(v_x_285, 12.0)
			v_x_285 = _t442
		J.mc(v_c_271, "stroke", [])
		v_i_283 = J.num(v_i_283) + 1.0
	v_off_275 = J.mod(J.mul(J.gp(env["G"], "dist"), 24.0), 48.0)
	J.sp(v_c_271, "fillStyle", "#e05050")
	v_x_286 = (-J.num(v_off_275))
	while true:
		if not J.cmp(v_x_286, 400.0, "<"): break
		J.mc(v_c_271, "beginPath", [])
		J.mc(v_c_271, "arc", [v_x_286, J.add(v_top_273, 4.0), 4.0, 0.0, (PI * 2.0)])
		J.mc(v_c_271, "arc", [J.add(v_x_286, 24.0), J.sub(v_bot_274, 4.0), 4.0, 0.0, (PI * 2.0)])
		J.mc(v_c_271, "fill", [])
		var _t443 = J.add(v_x_286, 48.0)
		v_x_286 = _t443
	var _t445 = J.gp(env["G"], "time")
	var _t444 = env["__p"]["target"]
	var _t447 = J.gp(env["G"], "time")
	var _t446 = env["__p"]["target"]
	v_bd_276 = J.min_([50.0, (J.div(_t447, J.cl(_t446, null, ["swim"])) * 50.0)])
	v_bx_277 = (150.0 + (J.sub(v_bd_276, J.gp(env["G"], "dist")) * 24.0))
	var _t448 = J.cmp(v_bx_277, (-40.0), ">")
	if (J.cmp(v_bx_277, 430.0, "<") if _t448 else _t448):
		J.mc(v_c_271, "save", [])
		J.sp(v_c_271, "globalAlpha", 0.5)
		J.mc(v_c_271, "beginPath", [])
		J.mc(v_c_271, "rect", [0.0, 0.0, 390.0, J.add(v_top_273, 30.0)])
		J.mc(v_c_271, "clip", [])
		var _t449 = env["__p"]["bryan"]
		J.cl(_t449, null, [v_c_271, v_bx_277, J.add(v_top_273, 60.0), 96.0, "walk", {"faceRight": true}])
		J.mc(v_c_271, "restore", [])
		J.mc(v_c_271, "save", [])
		J.sp(v_c_271, "font", "bold 11px sans-serif")
		J.sp(v_c_271, "textAlign", "center")
		J.sp(v_c_271, "fillStyle", "#ffd0c0")
		J.mc(v_c_271, "fillText", ["Bryan", v_bx_277, J.sub(v_top_273, 46.0)])
		J.mc(v_c_271, "restore", [])
	v_y_278 = ((J.div(J.add(v_top_273, v_bot_274), 2.0) + 40.0) + (sin(J.num(J.mul(J.gp(env["G"], "t"), 7.0))) * (3.0 if J.cmp(J.gp(env["G"], "vel"), 0.5, ">") else 1.5)))
	v_lean_279 = J.min_([0.35, J.mul(J.gp(env["G"], "vel"), 0.05)])
	v_SC_280 = 1.5
	var _t450 = (not J.seq(J.typeof_(J.G.get("CHAR_H")), "undefined"))
	var _t451 = (J.gp(J.G.get("CHAR_H"), J.gp(J.gp(env["G"], "a"), "k")) if _t450 else _t450)
	v_HH_281 = ((J.mul((_t451 if J.t(_t451) else 56.0), v_SC_280) + J.mul(4.0, v_SC_280)) - 7.0)
	J.mc(v_c_271, "save", [])
	J.mc(v_c_271, "beginPath", [])
	J.mc(v_c_271, "rect", [0.0, 0.0, 390.0, J.sub(v_y_278, 22.0)])
	J.mc(v_c_271, "clip", [])
	J.mc(v_c_271, "save", [])
	J.mc(v_c_271, "translate", [150.0, v_y_278])
	J.mc(v_c_271, "rotate", [v_lean_279])
	var _t452 = env["__p"]["char"]
	J.cl(_t452, null, [v_c_271, J.gp(J.gp(env["G"], "a"), "k"), 0.0, 0.0, v_SC_280, {"shadow": false, "walk": J.cmp(J.gp(env["G"], "vel"), 0.5, ">")}])
	J.mc(v_c_271, "translate", [0.0, (-J.num(v_HH_281))])
	J.mc(v_c_271, "rotate", [J.mul(J.gp(env["G"], "slosh"), 0.6)])
	J.sp(v_c_271, "fillStyle", "#c8c0a8")
	J.sp(v_c_271, "strokeStyle", "rgba(0,0,0,.4)")
	J.sp(v_c_271, "lineWidth", 1.5)
	J.mc(v_c_271, "beginPath", [])
	J.mc(v_c_271, "ellipse", [0.0, 0.0, 22.0, 6.5, 0.0, 0.0, (PI * 2.0)])
	J.mc(v_c_271, "fill", [])
	J.mc(v_c_271, "stroke", [])
	if J.cmp(J.gp(env["G"], "water"), 0.0, ">"):
		J.sp(v_c_271, "fillStyle", "rgba(120,200,255,.9)")
		J.mc(v_c_271, "beginPath", [])
		J.mc(v_c_271, "ellipse", [J.mul(J.gp(env["G"], "slosh"), 6.0), (-1.5), (18.0 * sqrt(J.num(J.gp(env["G"], "water")))), (4.2 * sqrt(J.num(J.gp(env["G"], "water")))), 0.0, 0.0, (PI * 2.0)])
		J.mc(v_c_271, "fill", [])
	J.mc(v_c_271, "restore", [])
	J.mc(v_c_271, "restore", [])
	J.sp(v_c_271, "fillStyle", "rgba(40,90,120,.55)")
	J.mc(v_c_271, "fillRect", [0.0, J.sub(v_y_278, 22.0), 390.0, (J.sub(v_bot_274, v_y_278) + 22.0)])
	if J.cmp(J.gp(env["G"], "stroke"), 0.0, ">"):
		v_q_287 = (1.0 - J.div(J.gp(env["G"], "stroke"), 0.35))
		var _t453 = ("rgba(255,255,255," + J.str((0.7 * J.sub(1.0, v_q_287))) + ")")
		J.sp(v_c_271, "strokeStyle", _t453)
		J.sp(v_c_271, "lineWidth", 2.0)
		J.mc(v_c_271, "beginPath", [])
		J.mc(v_c_271, "ellipse", [(150.0 + J.mul(J.gp(env["G"], "lastSide"), 30.0)), J.sub(v_y_278, 20.0), (12.0 + J.mul(v_q_287, 22.0)), (4.0 + J.mul(v_q_287, 6.0)), 0.0, 0.0, (PI * 2.0)])
		J.mc(v_c_271, "stroke", [])
	J.sp(v_c_271, "fillStyle", "rgba(0,0,0,.5)")
	J.mc(v_c_271, "fillRect", [20.0, J.mul(v_H_272, 0.86), 120.0, 9.0])
	var _t454 = ("#7fd0ff" if J.cmp(J.gp(env["G"], "water"), 0.25, ">") else "#ff7070")
	J.sp(v_c_271, "fillStyle", _t454)
	J.mc(v_c_271, "fillRect", [20.0, J.mul(v_H_272, 0.86), J.mul(120.0, J.gp(env["G"], "water")), 9.0])
	J.sp(v_c_271, "fillStyle", "#fff")
	J.sp(v_c_271, "font", "11px sans-serif")
	J.sp(v_c_271, "textAlign", "left")
	J.mc(v_c_271, "fillText", ["頭頂碟水", 20.0, (J.mul(v_H_272, 0.86) - 4.0)])
	v_fx_282 = (150.0 + (J.sub(50.0, J.gp(env["G"], "dist")) * 24.0))
	if J.cmp(v_fx_282, 400.0, "<"):
		J.sp(v_c_271, "fillStyle", "#fff")
		J.mc(v_c_271, "fillRect", [v_fx_282, v_top_273, 4.0, J.sub(v_bot_274, v_top_273)])

func _f69(this_, a: Array, env):
	var _s132 = {"__p": env, "G": null, "stroke": null}
	_s132["G"] = J.arg(a, 0)
	J.S_Object_("assign", [_s132["G"], {"dist": 0.0, "vel": 0.0, "water": 1.0, "slosh": 0.0, "sv": 0.0, "lastSide": 0.0, "lastT": (-9.0), "time": 0.0, "finished": false, "stroke": 0.0}])
	var _t390 = _s132["G"]
	var _t393 = Callable(self, "_f70").bind(_s132)
	J.sp(_t390, "hud", _t393)
	_s132["stroke"] = Callable(self, "_f71").bind(_s132)
	var _t404 = _s132["__p"]["btns"]
	J.cl(_t404, null, [[["左划", Callable(self, "_f72").bind(_s132), ""], ["右划", Callable(self, "_f73").bind(_s132), ""]]])
	var _t407 = _s132["G"]
	var _t408 = _s132["stroke"]
	J.sp(_t407, "stroke_", _t408)
	var _t409 = _s132["G"]
	var _t440 = Callable(self, "_f74").bind(_s132)
	J.sp(_t409, "tick", _t440)
	var _t441 = _s132["G"]
	var _t455 = Callable(self, "_f75").bind(_s132)
	J.sp(_t441, "draw", _t455)

func _f76(this_, a: Array, env):
	return env["G"]

func _f1(this_, a: Array, env):
	var _s2 = {"__p": env, "D": null, "DAY": null, "EV": null, "ORDER": null, "TAUT": null, "BRYAN": null, "has": null, "Lx": null, "st": null, "gday": null, "rnd": null, "target": null, "gpf": null, "owned": null, "athlete": null, "fmtV": null, "better": null, "open": null, "G": null, "el": null, "start": null, "pt": null, "resize": null, "close": null, "btns": null, "say": null, "frame": null, "draw": null, "banner": null, "wrap": null, "pop": null, "char": null, "bryan": null, "finish": null, "INIT": null}
	_s2["st"] = Callable(self, "_f6").bind(_s2)
	_s2["gday"] = Callable(self, "_f7").bind(_s2)
	_s2["rnd"] = Callable(self, "_f8").bind(_s2)
	_s2["target"] = Callable(self, "_f9").bind(_s2)
	_s2["gpf"] = Callable(self, "_f10").bind(_s2)
	_s2["owned"] = Callable(self, "_f11").bind(_s2)
	_s2["athlete"] = Callable(self, "_f13").bind(_s2)
	_s2["better"] = Callable(self, "_f16").bind(_s2)
	_s2["open"] = Callable(self, "_f17").bind(_s2)
	_s2["el"] = Callable(self, "_f21").bind(_s2)
	_s2["start"] = Callable(self, "_f22").bind(_s2)
	_s2["pt"] = Callable(self, "_f27").bind(_s2)
	_s2["resize"] = Callable(self, "_f28").bind(_s2)
	_s2["close"] = Callable(self, "_f29").bind(_s2)
	_s2["btns"] = Callable(self, "_f30").bind(_s2)
	_s2["say"] = Callable(self, "_f34").bind(_s2)
	_s2["frame"] = Callable(self, "_f35").bind(_s2)
	_s2["draw"] = Callable(self, "_f37").bind(_s2)
	_s2["banner"] = Callable(self, "_f38").bind(_s2)
	_s2["wrap"] = Callable(self, "_f39").bind(_s2)
	_s2["pop"] = Callable(self, "_f40").bind(_s2)
	_s2["char"] = Callable(self, "_f41").bind(_s2)
	_s2["bryan"] = Callable(self, "_f42").bind(_s2)
	_s2["finish"] = Callable(self, "_f43").bind(_s2)
	_s2["D"] = Callable(self, "_f2").bind(_s2)
	_s2["DAY"] = 86400000.0
	_s2["EV"] = {"jump": {"name": "殭屍跳遠", "who": "laojiang", "bg": "field", "unit": "米", "hi": true, "rule": "膝蓋不能彎，只能一跳一跳助跑。著地那一下點「跳」，節奏越準越快；最後在白線前點「起跳」，越貼線越遠，踩線犯規。", "sub": "阿福頂上：他膝蓋可以彎，所以要自己忍住。"}, "tug": {"name": "舌頭對脖子拔河", "who": "n30_diaosi", "foe": "n30_rokurokubi", "bg": "kampung", "unit": "", "hi": true, "rule": "狂點「拉」把繩拉過來。繩子變紅就是繃緊了，這時候還拉，舌頭會打滑倒退。把旗拉到你這邊的線就贏。", "sub": "吊死鬼不在，阿福用領帶頂上。"}, "hang": {"name": "天花板倒掛耐力賽", "who": "tianhua", "bg": "hq", "unit": "秒", "hi": true, "rule": "按住畫面才抓得住天花板，放手就掉下來。左右拖動手指，把搖擺拉回中間；風扇和掃把會來搞你。", "sub": "天花姐不在，阿福倒掛（領帶垂下來了）。"}, "swim": {"name": "河童游泳", "who": "n30_kappa", "bg": "banana", "unit": "秒", "hi": false, "rule": "左右輪流划水向前游。划得太急、同一邊連划，頭頂碟裡的水會晃出去；水乾了河童就沒力。游完 50 米，越快越好。", "sub": "河童不在，阿福頂著一碟水游。"}}
	_s2["ORDER"] = ["jump", "tug", "hang", "swim"]
	_s2["TAUT"] = J.cl(Callable(self, "_f3").bind(_s2), null, [])
	var _t182 = _s2["D"]
	var _t184 = J.cl(_t182, null, ["Bryan：「我籃球跳投出身，跳遠？小意思。」", "Bryan：「我打籃球跳投出身，跳遠？小意思。」"])
	var _t183 = _s2["D"]
	var _t186 = J.cl(_t183, null, ["轆轤首：「我條頸三米長，你有幾長？」", "轆轤首：「我的脖子三米長，你有多長？」"])
	var _t185 = _s2["D"]
	var _t188 = J.cl(_t185, null, ["Bryan：「倒掛？我喺公司掛名都掛咗三年。」", "Bryan：「倒掛？我在公司掛名都掛了三年。」"])
	var _t187 = _s2["D"]
	_s2["BRYAN"] = {"jump": _t184, "tug": _t186, "hang": _t188, "swim": J.cl(_t187, null, ["Bryan：「我游水唔使碟，因為我頭頂冇嘢。等陣，唔係咁講……」", "Bryan：「我游泳不用碟子，因為我頭上沒東西。等等，不是這樣說……」"])}
	_s2["has"] = Callable(self, "_f4").bind(_s2)
	_s2["Lx"] = Callable(self, "_f5").bind(_s2)
	_s2["fmtV"] = Callable(self, "_f15").bind(_s2)
	_s2["G"] = null
	_s2["INIT"] = {}
	var _t191 = _s2["INIT"]
	var _t266 = Callable(self, "_f46").bind(_s2)
	J.sp(_t191, "jump", _t266)
	var _t267 = _s2["INIT"]
	var _t314 = Callable(self, "_f56").bind(_s2)
	J.sp(_t267, "tug", _t314)
	var _t315 = _s2["INIT"]
	var _t388 = Callable(self, "_f62").bind(_s2)
	J.sp(_t315, "hang", _t388)
	var _t389 = _s2["INIT"]
	var _t456 = Callable(self, "_f69").bind(_s2)
	J.sp(_t389, "swim", _t456)
	return {"open": _s2["open"], "start": _s2["start"], "EV": _s2["EV"], "target": _s2["target"], "st": _s2["st"], "athlete": _s2["athlete"], "_g": Callable(self, "_f76").bind(_s2)}
