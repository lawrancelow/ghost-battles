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
	if J.t(env["G"]):
		J.cl(env["draw"], null, [])

func _f25(this_, a: Array, env):
	var v_e_100 = null
	v_e_100 = J.arg(a, 0)
	J.mc(v_e_100, "preventDefault", [])
	if J.t((J.gp(env["G"], "down") if J.t(env["G"]) else env["G"])):
		var _t79 = env["pt"]
		J.mc(env["G"], "down", [J.cl(_t79, null, [v_e_100])])

func _f26(this_, a: Array, env):
	var v_e_101 = null
	v_e_101 = J.arg(a, 0)
	if J.t((J.gp(env["G"], "move") if J.t(env["G"]) else env["G"])):
		var _t80 = env["pt"]
		J.mc(env["G"], "move", [J.cl(_t80, null, [v_e_101])])

func _f27(this_, a: Array, env):
	var v_e_102 = null
	v_e_102 = J.arg(a, 0)
	if J.t((J.gp(env["G"], "up") if J.t(env["G"]) else env["G"])):
		var _t81 = env["pt"]
		J.mc(env["G"], "up", [J.cl(_t81, null, [v_e_102])])

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
	var _t73 = env["G"]
	var _t74 = Callable(self, "_f24").bind(env)
	J.sp(_t73, "_nd", _t74)
	var _t75 = env["G"]
	var _t77 = (not J.seq(J.typeof_(J.G.get("__nat_mini")), "undefined"))
	if J.t(_t77):
		var _t76 = J.G.get("__nat_mini")
		_t77 = J.cl(_t76, null, [env["G"], "#sp-cvs", "#sports", "_nd"])
	J.sp(_t75, "_nat", _t77)
	var _t78 = env["INIT"]
	J.mc(_t78, v_id_94, [env["G"]])
	J.cl(env["resize"], null, [])
	J.S_window_("addEventListener", ["resize", env["resize"]])
	J.mc(v_cv_98, "addEventListener", ["pointerdown", Callable(self, "_f25").bind(env)])
	J.mc(v_cv_98, "addEventListener", ["pointermove", Callable(self, "_f26").bind(env)])
	v_up_99 = Callable(self, "_f27").bind(env)
	J.mc(v_cv_98, "addEventListener", ["pointerup", v_up_99])
	J.mc(v_cv_98, "addEventListener", ["pointercancel", v_up_99])
	J.mc(v_cv_98, "addEventListener", ["pointerleave", v_up_99])
	J.mc(J.G.get("Sound"), "setMode", ["story"])
	var _t82 = env["G"]
	var _t83 = J.S_performance_("now", [])
	J.sp(_t82, "last", _t83)
	J.F_requestAnimationFrame([env["frame"]])

func _f28(this_, a: Array, env):
	var v_e_106 = null; var v_r_107 = null
	v_e_106 = J.arg(a, 0)
	v_r_107 = J.mc(J.gp(env["G"], "cv"), "getBoundingClientRect", [])
	return {"x": (J.div(J.sub(J.gp(v_e_106, "clientX"), J.gp(v_r_107, "left")), J.gp(v_r_107, "width")) * 390.0), "y": (J.div(J.sub(J.gp(v_e_106, "clientY"), J.gp(v_r_107, "top")), J.gp(v_r_107, "width")) * 390.0)}

func _f29(this_, a: Array, env):
	var v_r_110 = null; var v_d_111 = null
	if (not J.t(env["G"])):
		return null
	v_r_110 = J.mc(J.gp(env["G"], "cv"), "getBoundingClientRect", [])
	var _t86 = null
	if J.t(J.gp(env["G"], "_nat")):
		_t86 = 1.0
	else:
		var _t84 = J.gp(J.G.get("window"), "devicePixelRatio")
		var _t85 = J.gp(J.G.get("window"), "devicePixelRatio")
		_t86 = J.min_([2.0, (_t85 if J.t(_t85) else 1.0)])
	v_d_111 = _t86
	var _t87 = J.gp(env["G"], "cv")
	var _t88 = J.mul(J.gp(v_r_110, "width"), v_d_111)
	J.sp(_t87, "width", _t88)
	var _t89 = J.gp(env["G"], "cv")
	var _t90 = J.mul(J.gp(v_r_110, "height"), v_d_111)
	J.sp(_t89, "height", _t90)
	var _t91 = env["G"]
	var _t92 = J.div(J.mul(J.gp(v_r_110, "width"), v_d_111), 390.0)
	J.sp(_t91, "k", _t92)
	var _t93 = env["G"]
	var _t94 = (J.div(J.gp(v_r_110, "height"), J.gp(v_r_110, "width")) * 390.0)
	J.sp(_t93, "H", _t94)

func _f30(this_, a: Array, env):
	var v_e_114 = null; var v_e_115 = null
	var _t95 = (J.gp(env["G"], "_nat") if J.t(env["G"]) else env["G"])
	if J.t(((not J.seq(J.typeof_(J.G.get("__nat_miniEnd")), "undefined")) if J.t(_t95) else _t95)):
		J.cl(J.G.get("__nat_miniEnd"), null, [])
	env["G"] = null
	var _t96 = J.G.get("$")
	v_e_114 = J.cl(_t96, null, ["#sports"])
	if J.t(v_e_114):
		var _t97 = J.gp(v_e_114, "classList")
		J.mc(_t97, "remove", ["on"])
		J.sp(v_e_114, "innerHTML", "")
	J.mc(J.G.get("Sound"), "setMode", ["village"])
	J.cl(env["open"], null, [])

func _f32(this_, a: Array, env):
	var v_x_120 = null; var v_i_121 = null
	v_x_120 = J.arg(a, 0)
	v_i_121 = J.arg(a, 1)
	var _t99 = J.gp(v_x_120, 2.0)
	return ("<button class=\"btn " + J.str((_t99 if J.t(_t99) else "gold")) + " sp-b\" data-i=\"" + J.str(v_i_121) + "\">" + J.str(J.gp(v_x_120, 0.0)) + "</button>")

func _f34(this_, a: Array, env):
	var v_e_123 = null; var v_f_124 = null
	v_e_123 = J.arg(a, 0)
	J.mc(v_e_123, "preventDefault", [])
	v_f_124 = J.gp(J.gp(env["__p"]["list"], J.num(J.gp(J.gp(env["x"], "dataset"), "i"))), 1.0)
	if J.t((J.seq(J.gp(env["__p"]["__p"]["G"], "phase"), "play") if J.t(env["__p"]["__p"]["G"]) else env["__p"]["__p"]["G"])):
		J.cl(v_f_124, null, [])

func _f33(this_, a: Array, env):
	var _s44 = {"__p": env, "x": null}
	_s44["x"] = J.arg(a, 0)
	return J.mc(_s44["x"], "addEventListener", ["pointerdown", Callable(self, "_f34").bind(_s44)])

func _f31(this_, a: Array, env):
	var v_b_119 = null
	var _s42 = {"__p": env, "list": null}
	_s42["list"] = J.arg(a, 0)
	var _t98 = J.G.get("$")
	v_b_119 = J.cl(_t98, null, ["#sp-btns"])
	var _t100 = J.mc(_s42["list"], "map", [Callable(self, "_f32").bind(_s42)])
	var _t101 = J.mc(_t100, "join", [""])
	J.sp(v_b_119, "innerHTML", _t101)
	var _t102 = J.mc(v_b_119, "querySelectorAll", [".sp-b"])
	J.mc(_t102, "forEach", [Callable(self, "_f33").bind(_s42)])

func _f35(this_, a: Array, env):
	var v_m_127 = null; var v_t_128 = null
	v_m_127 = J.arg(a, 0)
	v_t_128 = J.arg(a, 1)
	var _t103 = env["G"]
	J.sp(_t103, "msg", v_m_127)
	var _t104 = env["G"]
	var _t105 = (v_t_128 if J.t(v_t_128) else 1.2)
	J.sp(_t104, "msgT", _t105)

func _f37(this_, a: Array, env):
	var v_f_134 = null
	v_f_134 = J.arg(a, 0)
	return J.cmp(J.gp(v_f_134, "t"), J.gp(v_f_134, "life"), "<")

func _f36(this_, a: Array, env):
	var v_now_131 = null; var v_dt_132 = null; var v_f_133 = null
	v_now_131 = J.arg(a, 0)
	if (not J.t(env["G"])):
		return null
	v_dt_132 = J.min_([0.05, J.div(J.sub(v_now_131, J.gp(env["G"], "last")), 1000.0)])
	var _t106 = env["G"]
	J.sp(_t106, "last", v_now_131)
	var _t107 = env["G"]
	var _t108 = J.add(J.gp(_t107, "t"), v_dt_132)
	J.sp(_t107, "t", _t108)
	if J.cmp(J.gp(env["G"], "msgT"), 0.0, ">"):
		var _t109 = env["G"]
		var _t110 = J.sub(J.gp(_t109, "msgT"), v_dt_132)
		J.sp(_t109, "msgT", _t110)
	if J.seq(J.gp(env["G"], "phase"), "intro"):
		var _t111 = env["G"]
		var _t112 = J.sub(J.gp(_t111, "introT"), v_dt_132)
		J.sp(_t111, "introT", _t112)
		if J.cmp(J.gp(env["G"], "introT"), 0.0, "<="):
			var _t113 = env["G"]
			J.sp(_t113, "phase", "play")
	var _t114 = J.seq(J.gp(env["G"], "phase"), "play")
	if J.t((J.gp(env["G"], "tick") if _t114 else _t114)):
		J.mc(env["G"], "tick", [v_dt_132])
	for _t115 in J.iter(J.gp(env["G"], "fx")):
		v_f_133 = _t115
		var _t116 = J.add(J.gp(v_f_133, "t"), v_dt_132)
		J.sp(v_f_133, "t", _t116)
	var _t117 = env["G"]
	var _t118 = J.gp(env["G"], "fx")
	var _t119 = J.mc(_t118, "filter", [Callable(self, "_f37").bind(env)])
	J.sp(_t117, "fx", _t119)
	if (not J.t(J.gp(env["G"], "_nat"))):
		J.cl(env["draw"], null, [])
	J.F_requestAnimationFrame([env["frame"]])

func _f38(this_, a: Array, env):
	var v_c_137 = null; var v_H_138 = null; var v_hud_139 = null; var v_f_140 = null; var v_q_141 = null
	var _t120 = J.gp(env["G"], "_nat")
	if J.t(((not J.t(J.gp(env["G"], "_natCtx"))) if J.t(_t120) else _t120)):
		return null
	var _t121 = J.gp(env["G"], "_natCtx")
	v_c_137 = (_t121 if J.t(_t121) else J.gp(env["G"], "ctx"))
	v_H_138 = J.gp(env["G"], "H")
	J.mc(v_c_137, "setTransform", [J.gp(env["G"], "k"), 0.0, 0.0, J.gp(env["G"], "k"), 0.0, 0.0])
	J.mc(v_c_137, "clearRect", [0.0, 0.0, 390.0, v_H_138])
	var _t122 = env["has"]
	var _t123 = J.cl(_t122, null, [J.G.get("SCENE")])
	if (not J.t((J.mc(J.G.get("SCENE"), "drawBg", [v_c_137, 390.0, v_H_138, J.gp(J.gp(env["G"], "E"), "bg")]) if J.t(_t123) else _t123))):
		J.sp(v_c_137, "fillStyle", "#1c1820")
		J.mc(v_c_137, "fillRect", [0.0, 0.0, 390.0, v_H_138])
	J.sp(v_c_137, "fillStyle", "rgba(10,8,16,.35)")
	J.mc(v_c_137, "fillRect", [0.0, 0.0, 390.0, v_H_138])
	J.mc(env["G"], "draw", [v_c_137, v_H_138])
	for _t124 in J.iter(J.gp(env["G"], "fx")):
		v_f_140 = _t124
		v_q_141 = J.div(J.gp(v_f_140, "t"), J.gp(v_f_140, "life"))
		J.mc(v_c_137, "save", [])
		var _t125 = J.sub(1.0, v_q_141)
		J.sp(v_c_137, "globalAlpha", _t125)
		var _t126 = J.gp(v_f_140, "size")
		var _t127 = ("bold " + J.str((_t126 if J.t(_t126) else 18.0)) + "px \"PingFang TC\",\"Noto Sans TC\",sans-serif")
		J.sp(v_c_137, "font", _t127)
		J.sp(v_c_137, "textAlign", "center")
		J.sp(v_c_137, "lineWidth", 4.0)
		J.sp(v_c_137, "strokeStyle", "rgba(0,0,0,.75)")
		var _t128 = J.gp(v_f_140, "col")
		var _t129 = (_t128 if J.t(_t128) else "#fff")
		J.sp(v_c_137, "fillStyle", _t129)
		J.mc(v_c_137, "strokeText", [J.gp(v_f_140, "text"), J.gp(v_f_140, "x"), J.sub(J.gp(v_f_140, "y"), J.mul(v_q_141, 26.0))])
		J.mc(v_c_137, "fillText", [J.gp(v_f_140, "text"), J.gp(v_f_140, "x"), J.sub(J.gp(v_f_140, "y"), J.mul(v_q_141, 26.0))])
		J.mc(v_c_137, "restore", [])
	if J.seq(J.gp(env["G"], "phase"), "intro"):
		var _t130 = env["banner"]
		var _t132 = J.gp(J.gp(env["G"], "E"), "name")
		var _t131 = env["Lx"]
		J.cl(_t130, null, [v_c_137, v_H_138, _t132, J.cl(_t131, null, [J.gp(env["BRYAN"], J.gp(env["G"], "id"))])])
	var _t133 = J.cmp(J.gp(env["G"], "msgT"), 0.0, ">")
	if J.t((J.gp(env["G"], "msg") if _t133 else _t133)):
		J.mc(v_c_137, "save", [])
		var _t134 = "bold 22px \"PingFang TC\",\"Noto Sans TC\",sans-serif"
		J.sp(v_c_137, "font", _t134)
		J.sp(v_c_137, "textAlign", "center")
		J.sp(v_c_137, "lineWidth", 5.0)
		J.sp(v_c_137, "strokeStyle", "rgba(0,0,0,.8)")
		J.sp(v_c_137, "fillStyle", "#ffd84a")
		J.mc(v_c_137, "strokeText", [J.gp(env["G"], "msg"), 195.0, J.mul(v_H_138, 0.2)])
		J.mc(v_c_137, "fillText", [J.gp(env["G"], "msg"), 195.0, J.mul(v_H_138, 0.2)])
		J.mc(v_c_137, "restore", [])
	var _t135 = J.G.get("$")
	v_hud_139 = J.cl(_t135, null, ["#sp-hud"])
	if J.t((J.gp(env["G"], "hud") if J.t(v_hud_139) else v_hud_139)):
		var _t136 = J.mc(env["G"], "hud", [])
		J.sp(v_hud_139, "textContent", _t136)

func _f39(this_, a: Array, env):
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
	var _t137 = "bold 26px \"PingFang TC\",\"Noto Sans TC\",sans-serif"
	J.sp(v_c_144, "font", _t137)
	J.mc(v_c_144, "fillText", [v_a_146, 195.0, (J.mul(v_H_145, 0.32) + 38.0)])
	J.sp(v_c_144, "fillStyle", "#eee")
	var _t138 = "14px \"PingFang TC\",\"Noto Sans TC\",sans-serif"
	J.sp(v_c_144, "font", _t138)
	var _t139 = env["wrap"]
	J.cl(_t139, null, [v_c_144, v_b_147, 195.0, (J.mul(v_H_145, 0.32) + 66.0), 350.0, 18.0])
	J.mc(v_c_144, "restore", [])

func _f40(this_, a: Array, env):
	var v_c_150 = null; var v_s_151 = null; var v_x_152 = null; var v_y_153 = null; var v_w_154 = null; var v_lh_155 = null; var v_line_156 = null; var v_yy_157 = null; var v_ch_158 = null
	v_c_150 = J.arg(a, 0)
	v_s_151 = J.arg(a, 1)
	v_x_152 = J.arg(a, 2)
	v_y_153 = J.arg(a, 3)
	v_w_154 = J.arg(a, 4)
	v_lh_155 = J.arg(a, 5)
	v_line_156 = ""
	v_yy_157 = v_y_153
	for _t140 in J.iter(v_s_151):
		v_ch_158 = _t140
		if J.cmp(J.gp(J.mc(v_c_150, "measureText", [J.add(v_line_156, v_ch_158)]), "width"), v_w_154, ">"):
			J.mc(v_c_150, "fillText", [v_line_156, v_x_152, v_yy_157])
			v_line_156 = v_ch_158
			var _t141 = J.add(v_yy_157, v_lh_155)
			v_yy_157 = _t141
		else:
			var _t142 = J.add(v_line_156, v_ch_158)
			v_line_156 = _t142
	J.mc(v_c_150, "fillText", [v_line_156, v_x_152, v_yy_157])

func _f41(this_, a: Array, env):
	var v_text_161 = null; var v_x_162 = null; var v_y_163 = null; var v_col_164 = null; var v_size_165 = null
	v_text_161 = J.arg(a, 0)
	v_x_162 = J.arg(a, 1)
	v_y_163 = J.arg(a, 2)
	v_col_164 = J.arg(a, 3)
	v_size_165 = J.arg(a, 4)
	var _t143 = J.gp(env["G"], "fx")
	J.mc(_t143, "push", [{"text": v_text_161, "x": v_x_162, "y": v_y_163, "col": v_col_164, "size": v_size_165, "t": 0.0, "life": 0.9}])

func _f42(this_, a: Array, env):
	var v_c_168 = null; var v_k_169 = null; var v_x_170 = null; var v_y_171 = null; var v_s_172 = null; var v_o_173 = null; var v_e_174 = null
	v_c_168 = J.arg(a, 0)
	v_k_169 = J.arg(a, 1)
	v_x_170 = J.arg(a, 2)
	v_y_171 = J.arg(a, 3)
	v_s_172 = J.arg(a, 4)
	v_o_173 = J.arg(a, 5)
	var _t144 = (J.gp(env["G"], "_nat") if J.t(env["G"]) else env["G"])
	var _t145 = (J.G.get("__nat_drawChar") if J.t(((not J.seq(J.typeof_(J.G.get("__nat_drawChar")), "undefined")) if J.t(_t144) else _t144)) else J.gp(J.G.get("ART"), "drawChar"))
	J.cl(_t145, null, [v_c_168, v_k_169, v_x_170, v_y_171, v_s_172, J.S_Object_("assign", [{"t": J.gp(env["G"], "t")}, (v_o_173 if J.t(v_o_173) else {})])])

func _f43(this_, a: Array, env):
	var v_c_177 = null; var v_x_178 = null; var v_y_179 = null; var v_h_180 = null; var v_state_181 = null; var v_o_182 = null; var v_e_183 = null
	v_c_177 = J.arg(a, 0)
	v_x_178 = J.arg(a, 1)
	v_y_179 = J.arg(a, 2)
	v_h_180 = J.arg(a, 3)
	v_state_181 = J.arg(a, 4)
	v_o_182 = J.arg(a, 5)
	J.mc(J.G.get("Antag"), "draw", [v_c_177, "npc_rival", v_x_178, v_y_179, v_h_180, (v_state_181 if J.t(v_state_181) else "idle"), J.gp(env["G"], "t"), J.S_Object_("assign", [{"shadow": false, "time": J.gp(env["G"], "t")}, (v_o_182 if J.t(v_o_182) else {})])])

func _f45(this_, a: Array, env):
	var _t188 = env["__p"]["start"]
	return J.cl(_t188, null, [env["id"]])

func _f46(this_, a: Array, env):
	return J.cl(env["__p"]["close"], null, [])

func _f44(this_, a: Array, env):
	var v_v_186 = null; var v_line_187 = null; var v_s_188 = null; var v_today_190 = null; var v_win_191 = null; var v_rec_192 = null; var v_rw_193 = null; var v_res_194 = null; var v_vs_195 = null; var v_p_196 = null; var v_got_197 = null; var v_g_198 = null
	var _s70 = {"__p": env, "id": null}
	v_v_186 = J.arg(a, 0)
	v_line_187 = J.arg(a, 1)
	if J.t(J.gp(_s70["__p"]["G"], "done")):
		return null
	var _t146 = _s70["__p"]["G"]
	J.sp(_t146, "done", true)
	var _t147 = _s70["__p"]["G"]
	J.sp(_t147, "phase", "end")
	v_s_188 = J.cl(_s70["__p"]["st"], null, [])
	_s70["id"] = J.gp(_s70["__p"]["G"], "id")
	v_today_190 = J.cl(_s70["__p"]["gday"], null, [])
	var _t148 = J.gp(v_s_188, "plays")
	var _t149 = J.add((_t148 if J.t(_t148) else 0.0), 1.0)
	J.sp(v_s_188, "plays", _t149)
	v_win_191 = null
	v_rec_192 = ""
	if J.seq(_s70["id"], "tug"):
		var _t150 = J.cmp(v_v_186, 0.0, ">")
		v_win_191 = _t150
		var _t151 = J.gp(v_s_188, "best")
		var _t152 = J.gp(J.gp(v_s_188, "best"), "tug")
		var _t153 = J.add((_t152 if J.t(_t152) else 0.0), (1.0 if J.t(v_win_191) else 0.0))
		J.sp(_t151, "tug", _t153)
	else:
		var _t157 = (not J.leq(v_v_186, null))
		if J.t(_t157):
			var _t154 = _s70["__p"]["better"]
			var _t156 = _s70["id"]
			var _t155 = _s70["__p"]["target"]
			_t157 = J.cl(_t154, null, [_t156, v_v_186, J.cl(_t155, null, [_s70["id"]])])
		v_win_191 = _t157
		var _t160 = (not J.leq(v_v_186, null))
		if J.t(_t160):
			var _t159 = J.leq(J.gp(J.gp(v_s_188, "best"), _s70["id"]), null)
			if not J.t(_t159):
				var _t158 = _s70["__p"]["better"]
				_t159 = J.cl(_t158, null, [_s70["id"], v_v_186, J.gp(J.gp(v_s_188, "best"), _s70["id"])])
			_t160 = _t159
		if J.t(_t160):
			var _t161 = J.gp(v_s_188, "best")
			var _t162 = _s70["id"]
			J.sp(_t161, _t162, v_v_186)
			v_rec_192 = "　<b>個人新紀錄！</b>"
	v_rw_193 = ""
	if J.t(((not J.seq(J.gp(J.gp(v_s_188, "won"), _s70["id"]), v_today_190)) if J.t(v_win_191) else v_win_191)):
		var _t163 = J.gp(v_s_188, "won")
		var _t164 = _s70["id"]
		J.sp(_t163, _t164, v_today_190)
		var _t165 = _s70["__p"]["has"]
		if J.t(J.cl(_t165, null, [J.G.get("Presence")])):
			if J.t(J.gp(J.gp(_s70["__p"]["G"], "a"), "g")):
				J.mc(J.G.get("Presence"), "add", [J.gp(J.gp(_s70["__p"]["G"], "a"), "g"), 12.0])
			for _t166 in J.iter(J.gp(J.G.get("S"), "ghosts")):
				v_g_198 = _t166
				if (not J.seq(v_g_198, J.gp(J.gp(_s70["__p"]["G"], "a"), "g"))):
					J.mc(J.G.get("Presence"), "add", [v_g_198, 3.0])
		var _t167 = J.gp(J.G.get("S"), "contract")
		if J.t((J.seq(J.gp(J.gp(J.G.get("S"), "contract"), "state"), "active") if J.t(_t167) else _t167)):
			var _t168 = J.gp(J.G.get("S"), "contract")
			var _t169 = J.add(J.gp(_t168, "kpi"), 2.0)
			J.sp(_t168, "kpi", _t169)
		var _t170 = J.G.get("give")
		v_got_197 = J.cl(_t170, null, [{"coins": 60.0}])
		var _t172 = J.gp(J.gp(_s70["__p"]["G"], "a"), "name")
		var _t171 = J.gp(J.G.get("S"), "contract")
		var _t173 = ("<p class=\"desc\">" + J.str(_t172) + " 存在感 +12，全村 +3" + ("，合約 KPI +2" if J.t((J.seq(J.gp(J.gp(J.G.get("S"), "contract"), "state"), "active") if J.t(_t171) else _t171)) else "") + "，" + J.str(v_got_197) + "</p>")
		v_rw_193 = _t173
	else:
		if J.t(v_win_191):
			v_rw_193 = "<p class=\"desc\">今日已經領過獎，這場算練習。</p>"
	J.cl(J.G.get("save"), null, [])
	var _t176 = null
	if J.seq(_s70["id"], "tug"):
		_t176 = ("贏了！" if J.t(v_win_191) else "輸了")
	else:
		var _t175 = null
		if J.leq(v_v_186, null):
			_t175 = "犯規"
		else:
			var _t174 = _s70["__p"]["fmtV"]
			_t175 = J.cl(_t174, null, [_s70["id"], v_v_186])
		_t176 = _t175
	v_res_194 = _t176
	var _t180 = null
	if J.seq(_s70["id"], "tug"):
		_t180 = ""
	else:
		var _t177 = _s70["__p"]["fmtV"]
		var _t179 = _s70["id"]
		var _t178 = _s70["__p"]["target"]
		_t180 = ("<p class=\"desc\">Bryan 今日紀錄：" + J.str(J.cl(_t177, null, [_t179, J.cl(_t178, null, [_s70["id"]])])) + J.str(v_rec_192) + "</p>")
	v_vs_195 = _t180
	var _t181 = J.G.get("$")
	v_p_196 = J.cl(_t181, null, ["#sp-panel"])
	if (not J.t(v_p_196)):
		return null
	var _t184 = ("贏了 Bryan！" if J.t(v_win_191) else ("被轆轤首拉過去了" if J.seq(_s70["id"], "tug") else "輸給 Bryan"))
	var _t183 = null
	if J.t(v_line_187):
		var _t182 = _s70["__p"]["Lx"]
		_t183 = ("<p class=\"desc\"><i>" + J.str(J.cl(_t182, null, [v_line_187])) + "</i></p>")
	else:
		_t183 = ""
	var _t185 = ("<div class=\"sp-end\"><h3>" + _t184 + "</h3><p class=\"sp-big\">" + J.str(v_res_194) + "</p>" + _t183 + J.str(v_vs_195) + J.str(v_rw_193) + "<div class=\"sp-endb\"><button class=\"btn\" id=\"sp-again\">再來一次</button><button class=\"btn gold\" id=\"sp-back\">回運動會</button></div></div>")
	J.sp(v_p_196, "innerHTML", _t185)
	var _t186 = J.G.get("$")
	var _t187 = J.cl(_t186, null, ["#sp-again"])
	var _t189 = Callable(self, "_f45").bind(_s70)
	J.sp(_t187, "onclick", _t189)
	var _t190 = J.G.get("$")
	var _t191 = J.cl(_t190, null, ["#sp-back"])
	var _t192 = Callable(self, "_f46").bind(_s70)
	J.sp(_t191, "onclick", _t192)

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
	var _t201 = null
	if J.seq(J.typeof_(J.G.get("L")), "function"):
		var _t200 = J.G.get("L")
		_t201 = J.cl(_t200, null, [v_x_40])
	else:
		_t201 = v_x_40
	return _t201

func _f15(this_, a: Array, env):
	var v_id_70 = null; var v_v_71 = null
	v_id_70 = J.arg(a, 0)
	v_v_71 = J.arg(a, 1)
	return ("" if J.seq(v_id_70, "tug") else (J.add(J.mc(v_v_71, "toFixed", [2.0]), " 米") if J.seq(v_id_70, "jump") else (J.add(J.mc(v_v_71, "toFixed", [1.0]), " 秒") if J.seq(v_id_70, "swim") else J.add(floor(J.num(v_v_71)), " 秒"))))

func _f48(this_, a: Array, env):
	return ("" if J.t(J.gp(env["G"], "fly")) else ("節奏 " + J.str(J.round(J.num(((0.6 + J.mul(0.4, J.cl(env["avg"], null, []))) * 100.0)))) + "%"))

func _f50(this_, a: Array, env):
	var v_s_206 = null; var v_v_207 = null
	v_s_206 = J.arg(a, 0)
	v_v_207 = J.arg(a, 1)
	return J.add(v_s_206, v_v_207)

func _f49(this_, a: Array, env):
	var _t208 = null
	if J.t(J.len(J.gp(env["G"], "acc"))):
		var _t207 = J.gp(env["G"], "acc")
		_t208 = J.div(J.mc(_t207, "reduce", [Callable(self, "_f50").bind(env), 0.0]), J.len(J.gp(env["G"], "acc")))
	else:
		_t208 = 0.0
	return _t208

func _f51(this_, a: Array, env):
	var v_land_208 = null; var v_early_209 = null; var v_d_210 = null; var v_i_211 = null; var v_q_212 = null
	var _t209 = J.gp(env["G"], "fly")
	if J.t((_t209 if J.t(_t209) else J.cmp(J.gp(env["G"], "hop"), env["HOPS"], ">="))):
		J.cl(env["takeoff"], null, [])
		return null
	v_land_208 = J.sub(env["T"], J.gp(env["G"], "hopT"))
	v_early_209 = J.gp(env["G"], "hopT")
	v_d_210 = J.min_([v_land_208, v_early_209])
	v_i_211 = (J.gp(env["G"], "hop") if J.cmp(v_land_208, v_early_209, "<") else J.sub(J.gp(env["G"], "hop"), 1.0))
	var _t210 = J.cmp(v_i_211, 0.0, "<")
	if J.t((_t210 if _t210 else J.gp(J.gp(env["G"], "tapped"), v_i_211))):
		return null
	var _t211 = J.gp(env["G"], "tapped")
	J.sp(_t211, v_i_211, 1.0)
	v_q_212 = (1.0 if J.cmp(v_d_210, 0.09, "<") else (0.7 if J.cmp(v_d_210, 0.17, "<") else 0.15))
	var _t212 = J.gp(env["G"], "acc")
	J.mc(_t212, "push", [v_q_212])
	var _t213 = env["__p"]["pop"]
	var _t216 = ("好節奏！" if J.seq(v_q_212, 1.0) else ("還可以" if J.cmp(v_q_212, 0.5, ">") else "亂跳"))
	var _t215 = J.gp(env["G"], "x")
	var _t214 = J.gp(env["G"], "cam")
	J.cl(_t213, null, [_t216, J.sub(_t215, (_t214 if J.t(_t214) else 0.0)), J.mul(J.gp(env["G"], "H"), 0.42), ("#ffd84a" if J.seq(v_q_212, 1.0) else "#ddd"), 16.0])

func _f52(this_, a: Array, env):
	var v_gap_213 = null; var v_sp_214 = null; var v_dist_215 = null
	var _t217 = J.gp(env["G"], "fly")
	if J.t((_t217 if J.t(_t217) else J.cmp(J.gp(env["G"], "hop"), env["HOPS"], "<"))):
		return null
	v_gap_213 = J.div(J.sub(J.gp(env["G"], "lineX"), J.gp(env["G"], "x")), env["PX"])
	v_sp_214 = (0.6 + J.mul(0.4, J.cl(env["avg"], null, [])))
	if J.cmp(v_gap_213, 0.0, "<"):
		var _t218 = env["G"]
		var _t219 = {"t": 0.0, "dist": 0.0, "foul": true}
		J.sp(_t218, "fly", _t219)
		var _t220 = env["__p"]["say"]
		J.cl(_t220, null, ["踩線犯規！", 1.6])
		return null
	v_dist_215 = J.max_([0.5, (J.mul(J.mul(v_sp_214, 7.6), J.gp(env["G"], "gpf")) - J.mul(v_gap_213, 1.2))])
	var _t221 = env["G"]
	var _t222 = {"t": 0.0, "dist": v_dist_215, "x0": J.gp(env["G"], "x"), "foul": false}
	J.sp(_t221, "fly", _t222)

func _f53(this_, a: Array, env):
	return J.cl(env["tapHop"], null, [])

func _f54(this_, a: Array, env):
	if J.seq(J.gp(env["G"], "phase"), "play"):
		J.cl(env["tapHop"], null, [])

func _f55(this_, a: Array, env):
	var v_dt_216 = null
	v_dt_216 = J.arg(a, 0)
	if J.t(J.gp(env["G"], "fly")):
		var _t227 = J.gp(env["G"], "fly")
		var _t228 = J.add(J.gp(_t227, "t"), v_dt_216)
		J.sp(_t227, "t", _t228)
		var _t229 = J.cmp(J.gp(J.gp(env["G"], "fly"), "t"), (1.2 if J.t(J.gp(J.gp(env["G"], "fly"), "foul")) else 1.4), ">")
		if ((not J.t(J.gp(env["G"], "done"))) if _t229 else _t229):
			var _t230 = env["__p"]["finish"]
			var _t232 = null
			if J.t(J.gp(J.gp(env["G"], "fly"), "foul")):
				_t232 = null
			else:
				var _t231 = J.gp(J.gp(env["G"], "fly"), "dist")
				_t232 = J.num(J.mc(_t231, "toFixed", [2.0]))
			var _t239 = null
			if J.t(J.gp(J.gp(env["G"], "fly"), "foul")):
				var _t233 = env["__p"]["D"]
				_t239 = J.cl(_t233, null, ["殭屍跳過咗龍，腳尖踩到白線。裁判（一隻雜鬼）舉紅旗。", "殭屍跳過了頭，腳尖踩到白線。裁判（一隻雜鬼）舉紅旗。"])
			else:
				var _t235 = J.gp(J.gp(env["G"], "fly"), "dist")
				var _t234 = env["__p"]["target"]
				var _t238 = null
				if J.cmp(_t235, J.cl(_t234, null, ["jump"]), ">"):
					var _t236 = env["__p"]["D"]
					_t238 = J.cl(_t236, null, ["落地姿勢：成條棍咁插落沙池。裁判俾滿分。", "落地姿勢：直挺挺插進沙池。裁判給滿分。"])
				else:
					var _t237 = env["__p"]["D"]
					_t238 = J.cl(_t237, null, ["膝頭太直，起跳差少少。", "膝蓋太直，起跳時差一點點。"])
				_t239 = _t238
			J.cl(_t230, null, [_t232, _t239])
		return null
	if J.cmp(J.gp(env["G"], "hop"), env["HOPS"], "<"):
		var _t240 = env["G"]
		var _t241 = J.add(J.gp(_t240, "hopT"), J.mul(v_dt_216, (0.85 + J.mul(0.3, J.gp(env["G"], "speed")))))
		J.sp(_t240, "hopT", _t241)
		if J.cmp(J.gp(env["G"], "hopT"), env["T"], ">="):
			var _t242 = env["G"]
			var _t243 = J.sub(J.gp(_t242, "hopT"), env["T"])
			J.sp(_t242, "hopT", _t243)
			var _t244 = env["G"]
			J.sp(_t244, "hop", J.num(J.gp(_t244, "hop")) + 1.0)
			if (not J.t(J.gp(J.gp(env["G"], "tapped"), J.sub(J.gp(env["G"], "hop"), 1.0)))):
				var _t245 = J.gp(env["G"], "acc")
				J.mc(_t245, "push", [0.0])
			var _t246 = env["G"]
			var _t247 = (0.6 + J.mul(0.4, J.cl(env["avg"], null, [])))
			J.sp(_t246, "speed", _t247)
		var _t248 = env["G"]
		var _t249 = (40.0 + J.mul(J.add(J.gp(env["G"], "hop"), J.div(J.gp(env["G"], "hopT"), env["T"])), 48.0))
		J.sp(_t248, "x", _t249)
	else:
		var _t250 = env["G"]
		var _t251 = J.add(J.gp(_t250, "x"), (J.mul(v_dt_216, 70.0) * (0.8 + J.mul(0.5, J.gp(env["G"], "speed")))))
		J.sp(_t250, "x", _t251)
		var _t252 = J.cmp(J.gp(env["G"], "x"), J.add(J.gp(env["G"], "lineX"), 40.0), ">")
		if ((not J.t(J.gp(env["G"], "fly"))) if _t252 else _t252):
			var _t253 = env["G"]
			var _t254 = {"t": 0.0, "dist": 0.0, "foul": true}
			J.sp(_t253, "fly", _t254)
			var _t255 = env["__p"]["say"]
			J.cl(_t255, null, ["踩線犯規！", 1.6])

func _f56(this_, a: Array, env):
	var v_c_217 = null; var v_H_218 = null; var v_gy_219 = null; var v_SC_220 = null; var v_fx_221 = null; var v_cam_222 = null; var v_bx_223 = null; var v_x_224 = null; var v_y_225 = null; var v_pose_226 = null; var v_pt_227 = null; var v_m_228 = null; var v_x_229 = null; var v_p_230 = null; var v_p_231 = null; var v_p_232 = null; var v_r_233 = null; var v_t_234 = null
	v_c_217 = J.arg(a, 0)
	v_H_218 = J.arg(a, 1)
	v_gy_219 = J.mul(v_H_218, 0.66)
	v_SC_220 = 1.6
	var _t258 = J.gp(env["G"], "fly")
	v_fx_221 = (J.add(J.gp(env["G"], "lineX"), (J.mul(J.gp(J.gp(env["G"], "fly"), "dist"), env["PX"]) * J.min_([1.0, J.div(J.gp(J.gp(env["G"], "fly"), "t"), 0.9)]))) if J.t(((not J.t(J.gp(J.gp(env["G"], "fly"), "foul"))) if J.t(_t258) else _t258)) else J.gp(env["G"], "x"))
	v_cam_222 = J.max_([0.0, J.min_([J.sub(J.add(J.gp(env["G"], "lineX"), J.mul(9.5, env["PX"])), 390.0), J.sub(v_fx_221, 150.0)])])
	var _t259 = env["G"]
	J.sp(_t259, "cam", v_cam_222)
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
	var _t261 = J.gp(env["G"], "lineX")
	var _t260 = env["__p"]["target"]
	v_bx_223 = J.add(_t261, J.mul(J.cl(_t260, null, ["jump"]), env["PX"]))
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
	var _t262 = J.gp(env["G"], "fly")
	if J.t(((not J.t(J.gp(J.gp(env["G"], "fly"), "foul"))) if J.t(_t262) else _t262)):
		v_p_230 = J.min_([1.0, J.div(J.gp(J.gp(env["G"], "fly"), "t"), 0.9)])
		v_x_224 = v_fx_221
		var _t263 = J.sub(v_gy_219, (sin(J.num(J.mul(v_p_230, PI))) * 110.0))
		v_y_225 = _t263
		var _t264 = ("air" if J.cmp(v_p_230, 1.0, "<") else null)
		v_pose_226 = _t264
		v_pt_227 = v_p_230
	else:
		var _t265 = (not J.t(J.gp(env["G"], "fly")))
		if (J.cmp(J.gp(env["G"], "hop"), env["HOPS"], "<") if _t265 else _t265):
			v_p_231 = J.div(J.gp(env["G"], "hopT"), env["T"])
			var _t266 = J.sub(v_gy_219, (sin(J.num(J.mul(v_p_231, PI))) * 34.0))
			v_y_225 = _t266
	var _t267 = (not J.t(J.gp(env["G"], "fly")))
	if (J.cmp(J.gp(env["G"], "hop"), env["HOPS"], "<") if _t267 else _t267):
		v_p_232 = J.div(J.gp(env["G"], "hopT"), env["T"])
		v_r_233 = (10.0 + (J.sub(1.0, v_p_232) * 34.0))
		var _t268 = ("#ffd84a" if J.cmp(v_p_232, 0.75, ">") else "rgba(255,255,255,.55)")
		J.sp(v_c_217, "strokeStyle", _t268)
		J.sp(v_c_217, "lineWidth", 3.0)
		J.mc(v_c_217, "beginPath", [])
		J.mc(v_c_217, "ellipse", [J.gp(env["G"], "x"), J.add(v_gy_219, 4.0), v_r_233, J.mul(v_r_233, 0.32), 0.0, 0.0, (PI * 2.0)])
		J.mc(v_c_217, "stroke", [])
	var _t269 = env["__p"]["char"]
	J.cl(_t269, null, [v_c_217, J.gp(J.gp(env["G"], "a"), "k"), v_x_224, v_y_225, v_SC_220, {"pose": v_pose_226, "pt": v_pt_227, "shadow": false}])
	var _t270 = J.gp(env["G"], "fly")
	var _t271 = ((not J.t(J.gp(J.gp(env["G"], "fly"), "foul"))) if J.t(_t270) else _t270)
	if J.t((J.cmp(J.gp(J.gp(env["G"], "fly"), "t"), 0.9, ">") if J.t(_t271) else _t271)):
		J.sp(v_c_217, "fillStyle", "#ffd84a")
		J.mc(v_c_217, "fillRect", [J.sub(v_fx_221, 1.0), J.sub(v_gy_219, 6.0), 3.0, 22.0])
	J.mc(v_c_217, "restore", [])
	var _t272 = (not J.t(J.gp(env["G"], "fly")))
	if (J.cmp(J.gp(env["G"], "hop"), env["HOPS"], ">=") if _t272 else _t272):
		J.mc(v_c_217, "save", [])
		J.sp(v_c_217, "font", "bold 24px sans-serif")
		J.sp(v_c_217, "textAlign", "center")
		J.sp(v_c_217, "lineWidth", 5.0)
		J.sp(v_c_217, "strokeStyle", "#000")
		J.sp(v_c_217, "fillStyle", "#ffd84a")
		J.mc(v_c_217, "strokeText", ["起跳！", 195.0, J.mul(v_H_218, 0.3)])
		J.mc(v_c_217, "fillText", ["起跳！", 195.0, J.mul(v_H_218, 0.3)])
		J.mc(v_c_217, "restore", [])
	var _t273 = J.gp(env["G"], "fly")
	var _t274 = ((not J.t(J.gp(J.gp(env["G"], "fly"), "foul"))) if J.t(_t273) else _t273)
	if J.t((J.cmp(J.gp(J.gp(env["G"], "fly"), "t"), 0.9, ">") if J.t(_t274) else _t274)):
		J.mc(v_c_217, "save", [])
		J.sp(v_c_217, "font", "bold 30px sans-serif")
		J.sp(v_c_217, "textAlign", "center")
		J.sp(v_c_217, "lineWidth", 6.0)
		J.sp(v_c_217, "strokeStyle", "#000")
		J.sp(v_c_217, "fillStyle", "#fff")
		var _t275 = J.gp(J.gp(env["G"], "fly"), "dist")
		v_t_234 = J.add(J.mc(_t275, "toFixed", [2.0]), " 米")
		J.mc(v_c_217, "strokeText", [v_t_234, 195.0, J.mul(v_H_218, 0.3)])
		J.mc(v_c_217, "fillText", [v_t_234, 195.0, J.mul(v_H_218, 0.3)])
		J.mc(v_c_217, "restore", [])

func _f47(this_, a: Array, env):
	var _s79 = {"__p": env, "G": null, "T": null, "HOPS": null, "PX": null, "avg": null, "tapHop": null, "takeoff": null}
	_s79["G"] = J.arg(a, 0)
	_s79["T"] = 0.56
	_s79["HOPS"] = 6.0
	_s79["PX"] = 30.0
	J.S_Object_("assign", [_s79["G"], {"x": 40.0, "hop": 0.0, "hopT": 0.0, "acc": [], "speed": 0.6, "line": 0.0, "fly": null, "tapped": {}, "lineX": 0.0, "cam": 0.0}])
	var _t203 = _s79["G"]
	var _t204 = ((40.0 + J.mul(_s79["HOPS"], 48.0)) + 40.0)
	J.sp(_t203, "lineX", _t204)
	var _t205 = _s79["G"]
	var _t206 = Callable(self, "_f48").bind(_s79)
	J.sp(_t205, "hud", _t206)
	_s79["avg"] = Callable(self, "_f49").bind(_s79)
	_s79["tapHop"] = Callable(self, "_f51").bind(_s79)
	_s79["takeoff"] = Callable(self, "_f52").bind(_s79)
	var _t223 = _s79["__p"]["btns"]
	J.cl(_t223, null, [[["跳", Callable(self, "_f53").bind(_s79)]]])
	var _t224 = _s79["G"]
	var _t225 = Callable(self, "_f54").bind(_s79)
	J.sp(_t224, "down", _t225)
	var _t226 = _s79["G"]
	var _t256 = Callable(self, "_f55").bind(_s79)
	J.sp(_t226, "tick", _t256)
	var _t257 = _s79["G"]
	var _t276 = Callable(self, "_f56").bind(_s79)
	J.sp(_t257, "draw", _t276)

func _f58(this_, a: Array, env):
	return ("剩 " + J.str(J.max_([0.0, ceil(J.num(J.gp(env["G"], "time")))])) + " 秒")

func _f59(this_, a: Array, env):
	if J.t(J.gp(env["G"], "done")):
		return null
	if J.cmp(J.gp(env["G"], "taut"), 0.0, ">"):
		var _t281 = env["G"]
		var _t282 = J.sub(J.gp(_t281, "p"), 0.07)
		J.sp(_t281, "p", _t282)
		var _t283 = env["G"]
		J.sp(_t283, "slip", 0.5)
		var _t284 = env["__p"]["pop"]
		J.cl(_t284, null, ["舌頭打滑！", 120.0, J.mul(J.gp(env["G"], "H"), 0.42), "#ff8080", 16.0])
		return null
	var _t285 = env["G"]
	var _t286 = J.add(J.gp(_t285, "p"), J.mul(0.032, J.gp(env["G"], "gpf")))
	J.sp(_t285, "p", _t286)
	if (randf() < 0.25):
		var _t287 = env["__p"]["pop"]
		J.cl(_t287, null, ["拉！", (90.0 + (randf() * 40.0)), J.mul(J.gp(env["G"], "H"), 0.46), "#ffe8a0", 14.0])

func _f60(this_, a: Array, env):
	if J.seq(J.gp(env["G"], "phase"), "play"):
		J.cl(env["pull"], null, [])

func _f61(this_, a: Array, env):
	var v_dt_237 = null; var v_surge_238 = null
	v_dt_237 = J.arg(a, 0)
	if J.t(J.gp(env["G"], "done")):
		return null
	var _t292 = env["G"]
	var _t293 = J.sub(J.gp(_t292, "time"), v_dt_237)
	J.sp(_t292, "time", _t293)
	var _t294 = env["G"]
	var _t295 = J.max_([0.0, J.sub(J.gp(env["G"], "slip"), v_dt_237)])
	J.sp(_t294, "slip", _t295)
	v_surge_238 = (0.22 if (sin(J.num(J.mul(J.gp(env["G"], "t"), 1.3))) > 0.85) else 0.0)
	var _t296 = env["G"]
	var _t297 = J.sub(J.gp(_t296, "p"), J.mul(v_dt_237, J.add(J.add(J.gp(env["G"], "ai"), v_surge_238), (J.max_([0.0, J.sub(J.gp(env["G"], "t"), 8.0)]) * 0.004))))
	J.sp(_t296, "p", _t297)
	var _t298 = env["G"]
	var _t299 = J.sub(J.gp(_t298, "tautT"), v_dt_237)
	J.sp(_t298, "tautT", _t299)
	if J.cmp(J.gp(env["G"], "tautT"), 0.0, "<="):
		var _t300 = env["G"]
		J.sp(_t300, "taut", 0.85)
		var _t301 = env["G"]
		var _t302 = (1.8 + (randf() * 1.8))
		J.sp(_t301, "tautT", _t302)
	if J.cmp(J.gp(env["G"], "taut"), 0.0, ">"):
		var _t303 = env["G"]
		var _t304 = J.sub(J.gp(_t303, "taut"), v_dt_237)
		J.sp(_t303, "taut", _t304)
	if J.cmp(J.gp(env["G"], "p"), 1.0, ">="):
		var _t305 = env["__p"]["finish"]
		var _t306 = env["__p"]["D"]
		J.cl(_t305, null, [1.0, J.cl(_t306, null, ["轆轤首條頸拉到打咗個結。佢話下年再嚟。", "轆轤首的脖子被拉到打了個結。她說明年再來。"])])
	else:
		if J.cmp(J.gp(env["G"], "p"), (-1.0), "<="):
			var _t307 = env["__p"]["finish"]
			var _t308 = env["__p"]["D"]
			J.cl(_t307, null, [0.0, J.cl(_t308, null, ["條脷被拉咗過對面，要行過去執返。", "舌頭被拉到對面，要走過去撿回來。"])])
		else:
			if J.cmp(J.gp(env["G"], "time"), 0.0, "<="):
				var _t309 = env["__p"]["finish"]
				var _t313 = (1.0 if J.cmp(J.gp(env["G"], "p"), 0.0, ">") else 0.0)
				var _t312 = null
				if J.cmp(J.gp(env["G"], "p"), 0.0, ">"):
					var _t310 = env["__p"]["D"]
					_t312 = J.cl(_t310, null, ["夠鐘，面旗喺你嗰邊。險勝。", "時間到，旗子在你這邊。險勝。"])
				else:
					var _t311 = env["__p"]["D"]
					_t312 = J.cl(_t311, null, ["夠鐘，面旗喺對面。差少少。", "時間到，旗子在對面。差一點。"])
				J.cl(_t309, null, [_t313, _t312])

func _f62(this_, a: Array, env):
	var v_c_239 = null; var v_H_240 = null; var v_gy_241 = null; var v_cx_242 = null; var v_ry_243 = null; var v_LH_244 = null; var v_RH_245 = null; var v_ropeCol_246 = null; var v_tx_247 = null
	v_c_239 = J.arg(a, 0)
	v_H_240 = J.arg(a, 1)
	v_gy_241 = J.mul(v_H_240, 0.68)
	v_cx_242 = (195.0 + J.mul(J.gp(env["G"], "p"), 100.0))
	v_ry_243 = J.sub(v_gy_241, 66.0)
	var _t316 = (not J.seq(J.typeof_(J.G.get("CHAR_H")), "undefined"))
	var _t317 = (J.gp(J.G.get("CHAR_H"), J.gp(J.gp(env["G"], "a"), "k")) if _t316 else _t316)
	v_LH_244 = J.mul((_t317 if J.t(_t317) else 56.0), 1.6)
	var _t318 = (not J.seq(J.typeof_(J.G.get("CHAR_H")), "undefined"))
	var _t319 = (J.gp(J.G.get("CHAR_H"), J.gp(J.gp(env["G"], "E"), "foe")) if _t318 else _t318)
	v_RH_245 = J.mul((_t319 if J.t(_t319) else 56.0), 1.6)
	J.sp(v_c_239, "fillStyle", "rgba(255,255,255,.75)")
	J.mc(v_c_239, "fillRect", [94.0, J.sub(v_ry_243, 24.0), 3.0, 40.0])
	J.mc(v_c_239, "fillRect", [293.0, J.sub(v_ry_243, 24.0), 3.0, 40.0])
	J.sp(v_c_239, "fillStyle", "rgba(255,255,255,.3)")
	J.mc(v_c_239, "fillRect", [194.0, J.sub(v_ry_243, 18.0), 2.0, 34.0])
	v_ropeCol_246 = ("#ff4040" if J.cmp(J.gp(env["G"], "taut"), 0.0, ">") else ("#c0392b" if J.seq(J.gp(J.gp(env["G"], "a"), "k"), "afu") else "#d86a7a"))
	J.sp(v_c_239, "strokeStyle", v_ropeCol_246)
	var _t320 = (6.0 if J.cmp(J.gp(env["G"], "taut"), 0.0, ">") else 5.0)
	J.sp(v_c_239, "lineWidth", _t320)
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
	var _t321 = env["__p"]["char"]
	J.cl(_t321, null, [v_c_239, J.gp(J.gp(env["G"], "a"), "k"), 58.0, v_gy_241, 1.6, {"pose": ("hurt" if J.cmp(J.gp(env["G"], "slip"), 0.0, ">") else null), "pt": 0.5, "shadow": false, "rot": ((-0.15) - (0.0 if J.cmp(J.gp(env["G"], "taut"), 0.0, ">") else 0.05))}])
	var _t322 = env["__p"]["char"]
	J.cl(_t322, null, [v_c_239, J.gp(J.gp(env["G"], "E"), "foe"), 338.0, v_gy_241, 1.6, {"flip": true, "shadow": false, "rot": 0.15}])
	if J.cmp(J.gp(env["G"], "taut"), 0.0, ">"):
		J.mc(v_c_239, "save", [])
		J.sp(v_c_239, "font", "bold 20px sans-serif")
		J.sp(v_c_239, "textAlign", "center")
		J.sp(v_c_239, "fillStyle", "#ff6060")
		J.sp(v_c_239, "lineWidth", 4.0)
		J.sp(v_c_239, "strokeStyle", "#000")
		var _t323 = env["__p"]["Lx"]
		v_tx_247 = J.cl(_t323, null, [env["__p"]["TAUT"]])
		J.mc(v_c_239, "strokeText", [v_tx_247, 195.0, J.mul(v_H_240, 0.3)])
		J.mc(v_c_239, "fillText", [v_tx_247, 195.0, J.mul(v_H_240, 0.3)])
		J.mc(v_c_239, "restore", [])

func _f57(this_, a: Array, env):
	var _s105 = {"__p": env, "G": null, "pull": null}
	_s105["G"] = J.arg(a, 0)
	J.S_Object_("assign", [_s105["G"], {"p": 0.0, "ai": 0.12, "taut": 0.0, "tautT": 2.2, "time": 30.0, "slip": 0.0}])
	var _t279 = _s105["G"]
	var _t280 = Callable(self, "_f58").bind(_s105)
	J.sp(_t279, "hud", _t280)
	_s105["pull"] = Callable(self, "_f59").bind(_s105)
	var _t288 = _s105["__p"]["btns"]
	J.cl(_t288, null, [[["拉", _s105["pull"]]]])
	var _t289 = _s105["G"]
	var _t290 = Callable(self, "_f60").bind(_s105)
	J.sp(_t289, "down", _t290)
	var _t291 = _s105["G"]
	var _t314 = Callable(self, "_f61").bind(_s105)
	J.sp(_t291, "tick", _t314)
	var _t315 = _s105["G"]
	var _t324 = Callable(self, "_f62").bind(_s105)
	J.sp(_t315, "draw", _t324)

func _f64(this_, a: Array, env):
	return (J.str(floor(J.num(J.gp(env["G"], "time")))) + " 秒")

func _f65(this_, a: Array, env):
	var v_p_249 = null
	v_p_249 = J.arg(a, 0)
	var _t334 = (not J.seq(J.gp(env["G"], "phase"), "play"))
	if J.t((_t334 if _t334 else J.gp(env["G"], "fall"))):
		return null
	var _t335 = env["G"]
	J.sp(_t335, "hold", true)
	var _t336 = env["G"]
	var _t337 = J.gp(v_p_249, "x")
	J.sp(_t336, "fx0", _t337)
	var _t338 = env["G"]
	J.sp(_t338, "dx", 0.0)

func _f66(this_, a: Array, env):
	var v_p_250 = null
	v_p_250 = J.arg(a, 0)
	var _t341 = J.gp(env["G"], "hold")
	if J.t(((not J.leq(J.gp(env["G"], "fx0"), null)) if J.t(_t341) else _t341)):
		var _t342 = env["G"]
		var _t343 = J.div(J.sub(J.gp(v_p_250, "x"), J.gp(env["G"], "fx0")), 90.0)
		J.sp(_t342, "dx", _t343)

func _f67(this_, a: Array, env):
	var _t346 = J.gp(env["G"], "hold")
	var _t347 = ((not J.t(J.gp(env["G"], "done"))) if J.t(_t346) else _t346)
	var _t348 = ((not J.t(J.gp(env["G"], "fall"))) if J.t(_t347) else _t347)
	if J.t((J.cmp(J.gp(env["G"], "time"), 0.3, ">") if J.t(_t348) else _t348)):
		var _t349 = env["G"]
		var _t350 = {"t": 0.0}
		J.sp(_t349, "fall", _t350)
		var _t351 = env["__p"]["say"]
		J.cl(_t351, null, ["放手了！", 1.4])
	var _t352 = env["G"]
	J.sp(_t352, "hold", false)

func _f68(this_, a: Array, env):
	var v_dt_251 = null; var v_lv_252 = null; var v_f_253 = null
	v_dt_251 = J.arg(a, 0)
	if J.t(J.gp(env["G"], "fall")):
		var _t355 = J.gp(env["G"], "fall")
		var _t356 = J.add(J.gp(_t355, "t"), v_dt_251)
		J.sp(_t355, "t", _t356)
		var _t357 = J.cmp(J.gp(J.gp(env["G"], "fall"), "t"), 1.0, ">")
		if ((not J.t(J.gp(env["G"], "done"))) if _t357 else _t357):
			var _t358 = env["__p"]["finish"]
			var _t359 = J.gp(env["G"], "time")
			var _t365 = J.num(J.mc(_t359, "toFixed", [1.0]))
			var _t361 = J.gp(env["G"], "time")
			var _t360 = env["__p"]["target"]
			var _t364 = null
			if J.cmp(_t361, J.cl(_t360, null, ["hang"]), ">"):
				var _t362 = env["__p"]["D"]
				_t364 = J.cl(_t362, null, ["跌落嚟嗰陣，啱啱壓住 Bryan 塊紀錄牌。", "掉下來的時候，剛好壓住 Bryan 的紀錄牌。"])
			else:
				var _t363 = env["__p"]["D"]
				_t364 = J.cl(_t363, null, ["落地。清潔安娣：「又係你，日日都跌落嚟。」", "落地。清潔安娣：「又是你，每天都掉下來。」"])
			J.cl(_t358, null, [_t365, _t364])
		return null
	if (not J.t(J.gp(env["G"], "hold"))):
		return null
	var _t366 = env["G"]
	var _t367 = J.add(J.gp(_t366, "time"), v_dt_251)
	J.sp(_t366, "time", _t367)
	v_lv_252 = (1.0 + J.div(J.gp(env["G"], "time"), 20.0))
	var _t368 = env["G"]
	var _t369 = J.sub(J.gp(_t368, "evT"), v_dt_251)
	J.sp(_t368, "evT", _t369)
	if J.cmp(J.gp(env["G"], "evT"), 0.0, "<="):
		var _t370 = env["G"]
		var _t371 = {"k": ("fan" if (randf() < 0.5) else "broom"), "t": 0.0, "dir": ((-1.0) if (randf() < 0.5) else 1.0)}
		J.sp(_t370, "ev", _t371)
		var _t372 = env["G"]
		var _t373 = (3.0 + J.div((randf() * 3.0), v_lv_252))
		J.sp(_t372, "evT", _t373)
		var _t374 = env["__p"]["pop"]
		J.cl(_t374, null, [("風扇開了！" if J.seq(J.gp(J.gp(env["G"], "ev"), "k"), "fan") else "安娣的掃把！"), 195.0, J.mul(J.gp(env["G"], "H"), 0.62), "#ffe8a0", 16.0])
	v_f_253 = (J.mul((sin(J.num(J.mul(J.gp(env["G"], "t"), 1.7))) * 0.35), v_lv_252) + J.mul((sin(J.num((J.mul(J.gp(env["G"], "t"), 0.63) + 1.0))) * 0.25), v_lv_252))
	if J.t(J.gp(env["G"], "ev")):
		var _t375 = J.gp(env["G"], "ev")
		var _t376 = J.add(J.gp(_t375, "t"), v_dt_251)
		J.sp(_t375, "t", _t376)
		var _t377 = J.add(v_f_253, (J.mul(J.mul(J.gp(J.gp(env["G"], "ev"), "dir"), (1.1 if J.seq(J.gp(J.gp(env["G"], "ev"), "k"), "fan") else 2.2)), v_lv_252) * (J.max_([0.0, (1.0 - (absf(J.num(J.sub(J.gp(J.gp(env["G"], "ev"), "t"), 0.4))) * 3.0))]) if J.seq(J.gp(J.gp(env["G"], "ev"), "k"), "broom") else 1.0)))
		v_f_253 = _t377
		if J.cmp(J.gp(J.gp(env["G"], "ev"), "t"), (1.8 if J.seq(J.gp(J.gp(env["G"], "ev"), "k"), "fan") else 0.9), ">"):
			var _t378 = env["G"]
			J.sp(_t378, "ev", null)
	var _t379 = env["G"]
	var _t380 = J.add(J.gp(_t379, "v"), J.mul((J.sub(v_f_253, J.mul(J.gp(env["G"], "dx"), 2.6)) - J.mul(J.gp(env["G"], "sw"), 0.6)), v_dt_251))
	J.sp(_t379, "v", _t380)
	var _t381 = env["G"]
	var _t382 = J.mul(J.gp(_t381, "v"), 0.985)
	J.sp(_t381, "v", _t382)
	var _t383 = env["G"]
	var _t384 = J.add(J.gp(_t383, "sw"), (J.mul(J.gp(env["G"], "v"), v_dt_251) * 1.6))
	J.sp(_t383, "sw", _t384)
	if (absf(J.num(J.gp(env["G"], "sw"))) > 1.0):
		var _t385 = env["G"]
		var _t386 = {"t": 0.0}
		J.sp(_t385, "fall", _t386)
		var _t387 = env["__p"]["say"]
		J.cl(_t387, null, ["甩下來了！", 1.4])

func _f69(this_, a: Array, env):
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
		var _t390 = J.add(v_x_259, 48.0)
		v_x_259 = _t390
	J.sp(v_c_254, "fillStyle", "rgba(0,0,0,.5)")
	J.mc(v_c_254, "fillRect", [95.0, J.mul(v_H_255, 0.84), 200.0, 10.0])
	J.sp(v_c_254, "fillStyle", "rgba(120,220,120,.6)")
	J.mc(v_c_254, "fillRect", [165.0, J.mul(v_H_255, 0.84), 60.0, 10.0])
	var _t391 = ("#ff5050" if (absf(J.num(J.gp(env["G"], "sw"))) > 0.7) else "#ffd84a")
	J.sp(v_c_254, "fillStyle", _t391)
	J.mc(v_c_254, "fillRect", [((195.0 + J.mul(J.gp(env["G"], "sw"), 100.0)) - 3.0), (J.mul(v_H_255, 0.84) - 4.0), 6.0, 18.0])
	v_ang_257 = J.mul(J.gp(env["G"], "sw"), 0.6)
	v_fy_258 = (J.min_([J.mul(v_H_255, 0.72), J.add(v_cy_256, (J.mul(J.gp(J.gp(env["G"], "fall"), "t"), J.gp(J.gp(env["G"], "fall"), "t")) * 900.0))]) if J.t(J.gp(env["G"], "fall")) else v_cy_256)
	J.mc(v_c_254, "save", [])
	J.mc(v_c_254, "translate", [195.0, v_fy_258])
	J.mc(v_c_254, "rotate", [J.add(PI, v_ang_257)])
	var _t392 = env["__p"]["char"]
	J.cl(_t392, null, [v_c_254, J.gp(J.gp(env["G"], "a"), "k"), 0.0, 0.0, 2.0, {"shadow": false, "pose": ("hurt" if J.t(J.gp(env["G"], "fall")) else null), "pt": 0.5}])
	J.mc(v_c_254, "restore", [])
	var _t393 = (not J.t(J.gp(env["G"], "hold")))
	var _t394 = ((not J.t(J.gp(env["G"], "fall"))) if _t393 else _t393)
	if (J.seq(J.gp(env["G"], "phase"), "play") if _t394 else _t394):
		J.mc(v_c_254, "save", [])
		J.sp(v_c_254, "font", "bold 18px sans-serif")
		J.sp(v_c_254, "textAlign", "center")
		J.sp(v_c_254, "fillStyle", "#fff")
		J.mc(v_c_254, "fillText", ["按住畫面抓實天花板", 195.0, J.mul(v_H_255, 0.55)])
		J.mc(v_c_254, "restore", [])
	var _t395 = J.gp(env["G"], "ev")
	if J.t((J.seq(J.gp(J.gp(env["G"], "ev"), "k"), "fan") if J.t(_t395) else _t395)):
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
	var _t396 = J.gp(env["G"], "ev")
	if J.t((J.seq(J.gp(J.gp(env["G"], "ev"), "k"), "broom") if J.t(_t396) else _t396)):
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
	var _t397 = env["__p"]["target"]
	J.mc(v_c_254, "fillText", [("Bryan：" + J.str(J.cl(_t397, null, ["hang"])) + " 秒"), 380.0, J.mul(v_H_255, 0.82)])
	J.mc(v_c_254, "restore", [])

func _f63(this_, a: Array, env):
	var _s114 = {"__p": env, "G": null}
	_s114["G"] = J.arg(a, 0)
	J.S_Object_("assign", [_s114["G"], {"hold": false, "sw": 0.0, "v": 0.0, "fx0": null, "time": 0.0, "push": 0.0, "evT": 4.0, "ev": null, "fall": null}])
	var _t327 = _s114["G"]
	var _t328 = Callable(self, "_f64").bind(_s114)
	J.sp(_t327, "hud", _t328)
	var _t329 = _s114["__p"]["btns"]
	J.cl(_t329, null, [[]])
	var _t330 = J.G.get("$")
	var _t331 = J.cl(_t330, null, ["#sp-btns"])
	var _t332 = "<p class=\"sp-tip\">按住畫面開始，左右拖動保持平衡</p>"
	J.sp(_t331, "innerHTML", _t332)
	var _t333 = _s114["G"]
	var _t339 = Callable(self, "_f65").bind(_s114)
	J.sp(_t333, "down", _t339)
	var _t340 = _s114["G"]
	var _t344 = Callable(self, "_f66").bind(_s114)
	J.sp(_t340, "move", _t344)
	var _t345 = _s114["G"]
	var _t353 = Callable(self, "_f67").bind(_s114)
	J.sp(_t345, "up", _t353)
	var _t354 = _s114["G"]
	var _t388 = Callable(self, "_f68").bind(_s114)
	J.sp(_t354, "tick", _t388)
	var _t389 = _s114["G"]
	var _t398 = Callable(self, "_f69").bind(_s114)
	J.sp(_t389, "draw", _t398)

func _f71(this_, a: Array, env):
	var _t403 = J.min_([50.0, floor(J.num(J.gp(env["G"], "dist")))])
	var _t402 = J.gp(env["G"], "time")
	return (J.str(_t403) + "／50 米　" + J.str(J.mc(_t402, "toFixed", [1.0])) + " 秒")

func _f72(this_, a: Array, env):
	var v_side_264 = null; var v_gap_265 = null; var v_same_266 = null; var v_power_267 = null; var v_kick_268 = null
	v_side_264 = J.arg(a, 0)
	if J.t(J.gp(env["G"], "finished")):
		return null
	v_gap_265 = J.sub(J.gp(env["G"], "t"), J.gp(env["G"], "lastT"))
	var _t405 = env["G"]
	var _t406 = J.gp(env["G"], "t")
	J.sp(_t405, "lastT", _t406)
	v_same_266 = J.seq(v_side_264, J.gp(env["G"], "lastSide"))
	var _t407 = env["G"]
	J.sp(_t407, "lastSide", v_side_264)
	var _t408 = env["G"]
	J.sp(_t408, "stroke", 0.35)
	v_power_267 = (1.0 if J.cmp(J.gp(env["G"], "water"), 0.25, ">") else 0.45)
	var _t409 = env["G"]
	var _t410 = J.add(J.gp(_t409, "vel"), J.mul((J.mul((0.5 if J.t(v_same_266) else 2.1), v_power_267) * (0.6 if J.cmp(v_gap_265, 0.22, "<") else 1.0)), J.gp(env["G"], "gpf")))
	J.sp(_t409, "vel", _t410)
	v_kick_268 = (0.9 if J.t(v_same_266) else 0.35)
	if J.cmp(v_gap_265, 0.22, "<"):
		var _t411 = J.add(v_kick_268, 0.6)
		v_kick_268 = _t411
	var _t412 = env["G"]
	var _t413 = J.add(J.gp(_t412, "sv"), J.mul(v_side_264, v_kick_268))
	J.sp(_t412, "sv", _t413)
	if J.t(v_same_266):
		var _t414 = env["__p"]["pop"]
		J.cl(_t414, null, ["同一邊！", (195.0 + J.mul(v_side_264, 70.0)), J.mul(J.gp(env["G"], "H"), 0.38), "#ffb0a0", 14.0])

func _f73(this_, a: Array, env):
	var _t416 = env["stroke"]
	return J.cl(_t416, null, [(-1.0)])

func _f74(this_, a: Array, env):
	var _t417 = env["stroke"]
	return J.cl(_t417, null, [1.0])

func _f75(this_, a: Array, env):
	var v_dt_269 = null; var v_loss_270 = null
	v_dt_269 = J.arg(a, 0)
	if J.t(J.gp(env["G"], "finished")):
		return null
	var _t421 = env["G"]
	var _t422 = J.add(J.gp(_t421, "time"), v_dt_269)
	J.sp(_t421, "time", _t422)
	var _t423 = env["G"]
	var _t424 = J.max_([0.0, J.sub(J.gp(env["G"], "stroke"), v_dt_269)])
	J.sp(_t423, "stroke", _t424)
	var _t425 = env["G"]
	var _t426 = J.mul(J.gp(_t425, "vel"), pow(J.num(0.35), J.num(v_dt_269)))
	J.sp(_t425, "vel", _t426)
	var _t427 = env["G"]
	var _t428 = J.add(J.gp(_t427, "dist"), (J.mul(J.gp(env["G"], "vel"), v_dt_269) * 0.5))
	J.sp(_t427, "dist", _t428)
	var _t429 = env["G"]
	var _t430 = J.add(J.gp(_t429, "sv"), J.mul(((-J.num(J.gp(env["G"], "slosh"))) * 14.0), v_dt_269))
	J.sp(_t429, "sv", _t430)
	var _t431 = env["G"]
	var _t432 = J.mul(J.gp(_t431, "sv"), pow(J.num(0.4), J.num(v_dt_269)))
	J.sp(_t431, "sv", _t432)
	var _t433 = env["G"]
	var _t434 = J.add(J.gp(_t433, "slosh"), (J.mul(J.gp(env["G"], "sv"), v_dt_269) * 3.0))
	J.sp(_t433, "slosh", _t434)
	if (absf(J.num(J.gp(env["G"], "slosh"))) > 0.55):
		v_loss_270 = (J.mul((absf(J.num(J.gp(env["G"], "slosh"))) - 0.55), v_dt_269) * 0.9)
		var _t435 = env["G"]
		var _t436 = J.max_([0.0, J.sub(J.gp(env["G"], "water"), v_loss_270)])
		J.sp(_t435, "water", _t436)
		if (randf() < J.mul(v_dt_269, 6.0)):
			var _t437 = env["__p"]["pop"]
			J.cl(_t437, null, ["水灑了！", 195.0, J.mul(J.gp(env["G"], "H"), 0.33), "#9fd8ff", 13.0])
	if J.cmp(J.gp(env["G"], "dist"), 50.0, ">="):
		var _t438 = env["G"]
		J.sp(_t438, "finished", true)
		var _t439 = env["__p"]["finish"]
		var _t440 = J.gp(env["G"], "time")
		var _t446 = J.num(J.mc(_t440, "toFixed", [1.0]))
		var _t445 = null
		if J.cmp(J.gp(env["G"], "water"), 0.6, ">"):
			var _t441 = env["__p"]["D"]
			_t445 = J.cl(_t441, null, ["游完，頭頂碟水仲有大半。河童協會頒發「穩陣獎」。", "游完，頭頂碟水還有大半。河童協會頒發「穩健獎」。"])
		else:
			var _t444 = null
			if J.cmp(J.gp(env["G"], "water"), 0.25, ">"):
				var _t442 = env["__p"]["D"]
				_t444 = J.cl(_t442, null, ["游完，碟水剩返一半，個頭有啲暈。", "游完了，碟裡的水剩一半，頭有點暈。"])
			else:
				var _t443 = env["__p"]["D"]
				_t444 = J.cl(_t443, null, ["碟水乾晒，最後幾米係爬上岸。", "碟水全乾了，最後幾米是爬上岸的。"])
			_t445 = _t444
		J.cl(_t439, null, [_t446, _t445])
	var _t447 = J.cmp(J.gp(env["G"], "time"), 60.0, ">")
	if ((not J.t(J.gp(env["G"], "finished"))) if _t447 else _t447):
		var _t448 = env["G"]
		J.sp(_t448, "finished", true)
		var _t449 = env["__p"]["finish"]
		var _t450 = env["__p"]["D"]
		J.cl(_t449, null, [null, J.cl(_t450, null, ["一分鐘都未游完。救生員（一隻水鬼）將你撈咗上岸。", "一分鐘都沒游完。救生員（一隻水鬼）把你撈上岸。"])])

func _f76(this_, a: Array, env):
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
			var _t453 = J.add(v_x_285, 12.0)
			v_x_285 = _t453
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
		var _t454 = J.add(v_x_286, 48.0)
		v_x_286 = _t454
	var _t456 = J.gp(env["G"], "time")
	var _t455 = env["__p"]["target"]
	var _t458 = J.gp(env["G"], "time")
	var _t457 = env["__p"]["target"]
	v_bd_276 = J.min_([50.0, (J.div(_t458, J.cl(_t457, null, ["swim"])) * 50.0)])
	v_bx_277 = (150.0 + (J.sub(v_bd_276, J.gp(env["G"], "dist")) * 24.0))
	var _t459 = J.cmp(v_bx_277, (-40.0), ">")
	if (J.cmp(v_bx_277, 430.0, "<") if _t459 else _t459):
		J.mc(v_c_271, "save", [])
		J.sp(v_c_271, "globalAlpha", 0.5)
		J.mc(v_c_271, "beginPath", [])
		J.mc(v_c_271, "rect", [0.0, 0.0, 390.0, J.add(v_top_273, 30.0)])
		J.mc(v_c_271, "clip", [])
		var _t460 = env["__p"]["bryan"]
		J.cl(_t460, null, [v_c_271, v_bx_277, J.add(v_top_273, 60.0), 96.0, "walk", {"faceRight": true}])
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
	var _t461 = (not J.seq(J.typeof_(J.G.get("CHAR_H")), "undefined"))
	var _t462 = (J.gp(J.G.get("CHAR_H"), J.gp(J.gp(env["G"], "a"), "k")) if _t461 else _t461)
	v_HH_281 = ((J.mul((_t462 if J.t(_t462) else 56.0), v_SC_280) + J.mul(4.0, v_SC_280)) - 7.0)
	J.mc(v_c_271, "save", [])
	J.mc(v_c_271, "beginPath", [])
	J.mc(v_c_271, "rect", [0.0, 0.0, 390.0, J.sub(v_y_278, 22.0)])
	J.mc(v_c_271, "clip", [])
	J.mc(v_c_271, "save", [])
	J.mc(v_c_271, "translate", [150.0, v_y_278])
	J.mc(v_c_271, "rotate", [v_lean_279])
	var _t463 = env["__p"]["char"]
	J.cl(_t463, null, [v_c_271, J.gp(J.gp(env["G"], "a"), "k"), 0.0, 0.0, v_SC_280, {"shadow": false, "walk": J.cmp(J.gp(env["G"], "vel"), 0.5, ">")}])
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
		var _t464 = ("rgba(255,255,255," + J.str((0.7 * J.sub(1.0, v_q_287))) + ")")
		J.sp(v_c_271, "strokeStyle", _t464)
		J.sp(v_c_271, "lineWidth", 2.0)
		J.mc(v_c_271, "beginPath", [])
		J.mc(v_c_271, "ellipse", [(150.0 + J.mul(J.gp(env["G"], "lastSide"), 30.0)), J.sub(v_y_278, 20.0), (12.0 + J.mul(v_q_287, 22.0)), (4.0 + J.mul(v_q_287, 6.0)), 0.0, 0.0, (PI * 2.0)])
		J.mc(v_c_271, "stroke", [])
	J.sp(v_c_271, "fillStyle", "rgba(0,0,0,.5)")
	J.mc(v_c_271, "fillRect", [20.0, J.mul(v_H_272, 0.86), 120.0, 9.0])
	var _t465 = ("#7fd0ff" if J.cmp(J.gp(env["G"], "water"), 0.25, ">") else "#ff7070")
	J.sp(v_c_271, "fillStyle", _t465)
	J.mc(v_c_271, "fillRect", [20.0, J.mul(v_H_272, 0.86), J.mul(120.0, J.gp(env["G"], "water")), 9.0])
	J.sp(v_c_271, "fillStyle", "#fff")
	J.sp(v_c_271, "font", "11px sans-serif")
	J.sp(v_c_271, "textAlign", "left")
	J.mc(v_c_271, "fillText", ["頭頂碟水", 20.0, (J.mul(v_H_272, 0.86) - 4.0)])
	v_fx_282 = (150.0 + (J.sub(50.0, J.gp(env["G"], "dist")) * 24.0))
	if J.cmp(v_fx_282, 400.0, "<"):
		J.sp(v_c_271, "fillStyle", "#fff")
		J.mc(v_c_271, "fillRect", [v_fx_282, v_top_273, 4.0, J.sub(v_bot_274, v_top_273)])

func _f70(this_, a: Array, env):
	var _s133 = {"__p": env, "G": null, "stroke": null}
	_s133["G"] = J.arg(a, 0)
	J.S_Object_("assign", [_s133["G"], {"dist": 0.0, "vel": 0.0, "water": 1.0, "slosh": 0.0, "sv": 0.0, "lastSide": 0.0, "lastT": (-9.0), "time": 0.0, "finished": false, "stroke": 0.0}])
	var _t401 = _s133["G"]
	var _t404 = Callable(self, "_f71").bind(_s133)
	J.sp(_t401, "hud", _t404)
	_s133["stroke"] = Callable(self, "_f72").bind(_s133)
	var _t415 = _s133["__p"]["btns"]
	J.cl(_t415, null, [[["左划", Callable(self, "_f73").bind(_s133), ""], ["右划", Callable(self, "_f74").bind(_s133), ""]]])
	var _t418 = _s133["G"]
	var _t419 = _s133["stroke"]
	J.sp(_t418, "stroke_", _t419)
	var _t420 = _s133["G"]
	var _t451 = Callable(self, "_f75").bind(_s133)
	J.sp(_t420, "tick", _t451)
	var _t452 = _s133["G"]
	var _t466 = Callable(self, "_f76").bind(_s133)
	J.sp(_t452, "draw", _t466)

func _f77(this_, a: Array, env):
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
	_s2["pt"] = Callable(self, "_f28").bind(_s2)
	_s2["resize"] = Callable(self, "_f29").bind(_s2)
	_s2["close"] = Callable(self, "_f30").bind(_s2)
	_s2["btns"] = Callable(self, "_f31").bind(_s2)
	_s2["say"] = Callable(self, "_f35").bind(_s2)
	_s2["frame"] = Callable(self, "_f36").bind(_s2)
	_s2["draw"] = Callable(self, "_f38").bind(_s2)
	_s2["banner"] = Callable(self, "_f39").bind(_s2)
	_s2["wrap"] = Callable(self, "_f40").bind(_s2)
	_s2["pop"] = Callable(self, "_f41").bind(_s2)
	_s2["char"] = Callable(self, "_f42").bind(_s2)
	_s2["bryan"] = Callable(self, "_f43").bind(_s2)
	_s2["finish"] = Callable(self, "_f44").bind(_s2)
	_s2["D"] = Callable(self, "_f2").bind(_s2)
	_s2["DAY"] = 86400000.0
	_s2["EV"] = {"jump": {"name": "殭屍跳遠", "who": "laojiang", "bg": "field", "unit": "米", "hi": true, "rule": "膝蓋不能彎，只能一跳一跳助跑。著地那一下點「跳」，節奏越準越快；最後在白線前點「起跳」，越貼線越遠，踩線犯規。", "sub": "阿福頂上：他膝蓋可以彎，所以要自己忍住。"}, "tug": {"name": "舌頭對脖子拔河", "who": "n30_diaosi", "foe": "n30_rokurokubi", "bg": "kampung", "unit": "", "hi": true, "rule": "狂點「拉」把繩拉過來。繩子變紅就是繃緊了，這時候還拉，舌頭會打滑倒退。把旗拉到你這邊的線就贏。", "sub": "吊死鬼不在，阿福用領帶頂上。"}, "hang": {"name": "天花板倒掛耐力賽", "who": "tianhua", "bg": "hq", "unit": "秒", "hi": true, "rule": "按住畫面才抓得住天花板，放手就掉下來。左右拖動手指，把搖擺拉回中間；風扇和掃把會來搞你。", "sub": "天花姐不在，阿福倒掛（領帶垂下來了）。"}, "swim": {"name": "河童游泳", "who": "n30_kappa", "bg": "banana", "unit": "秒", "hi": false, "rule": "左右輪流划水向前游。划得太急、同一邊連划，頭頂碟裡的水會晃出去；水乾了河童就沒力。游完 50 米，越快越好。", "sub": "河童不在，阿福頂著一碟水游。"}}
	_s2["ORDER"] = ["jump", "tug", "hang", "swim"]
	_s2["TAUT"] = J.cl(Callable(self, "_f3").bind(_s2), null, [])
	var _t193 = _s2["D"]
	var _t195 = J.cl(_t193, null, ["Bryan：「我籃球跳投出身，跳遠？小意思。」", "Bryan：「我打籃球跳投出身，跳遠？小意思。」"])
	var _t194 = _s2["D"]
	var _t197 = J.cl(_t194, null, ["轆轤首：「我條頸三米長，你有幾長？」", "轆轤首：「我的脖子三米長，你有多長？」"])
	var _t196 = _s2["D"]
	var _t199 = J.cl(_t196, null, ["Bryan：「倒掛？我喺公司掛名都掛咗三年。」", "Bryan：「倒掛？我在公司掛名都掛了三年。」"])
	var _t198 = _s2["D"]
	_s2["BRYAN"] = {"jump": _t195, "tug": _t197, "hang": _t199, "swim": J.cl(_t198, null, ["Bryan：「我游水唔使碟，因為我頭頂冇嘢。等陣，唔係咁講……」", "Bryan：「我游泳不用碟子，因為我頭上沒東西。等等，不是這樣說……」"])}
	_s2["has"] = Callable(self, "_f4").bind(_s2)
	_s2["Lx"] = Callable(self, "_f5").bind(_s2)
	_s2["fmtV"] = Callable(self, "_f15").bind(_s2)
	_s2["G"] = null
	_s2["INIT"] = {}
	var _t202 = _s2["INIT"]
	var _t277 = Callable(self, "_f47").bind(_s2)
	J.sp(_t202, "jump", _t277)
	var _t278 = _s2["INIT"]
	var _t325 = Callable(self, "_f57").bind(_s2)
	J.sp(_t278, "tug", _t325)
	var _t326 = _s2["INIT"]
	var _t399 = Callable(self, "_f63").bind(_s2)
	J.sp(_t326, "hang", _t399)
	var _t400 = _s2["INIT"]
	var _t467 = Callable(self, "_f70").bind(_s2)
	J.sp(_t400, "swim", _t467)
	return {"open": _s2["open"], "start": _s2["start"], "EV": _s2["EV"], "target": _s2["target"], "st": _s2["st"], "athlete": _s2["athlete"], "_g": Callable(self, "_f77").bind(_s2)}
