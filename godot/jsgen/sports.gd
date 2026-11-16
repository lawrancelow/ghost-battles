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
	var v_ms_46 = null; var v_d_47 = null
	v_ms_46 = J.S_Date_("now", [])
	v_d_47 = J.new_("Date", [v_ms_46])
	return floor(J.num(J.div(J.sub(v_ms_46, J.mul(J.mc(v_d_47, "getTimezoneOffset", []), 60000.0)), env["DAY"])))

func _f8(this_, a: Array, env):
	var v_seed_50 = null; var v_a_51 = null; var v_t_52 = null
	v_seed_50 = J.arg(a, 0)
	v_a_51 = J.bor(v_seed_50, 0.0)
	var _t9 = J.bor(J.add(v_a_51, 1831565813.0), 0.0)
	v_a_51 = _t9
	v_t_52 = J.math("imul", [J.bxor(v_a_51, J.ushr(v_a_51, 15.0)), J.bor(1.0, v_a_51)])
	var _t10 = J.bxor(J.add(v_t_52, J.math("imul", [J.bxor(v_t_52, J.ushr(v_t_52, 7.0)), J.bor(61.0, v_t_52)])), v_t_52)
	v_t_52 = _t10
	return J.div(J.ushr(J.bxor(v_t_52, J.ushr(v_t_52, 14.0)), 0.0), 4294967296.0)

func _f9(this_, a: Array, env):
	var v_id_55 = null; var v_r_56 = null
	v_id_55 = J.arg(a, 0)
	var _t11 = env["rnd"]
	v_r_56 = J.cl(_t11, null, [(J.mul(J.cl(env["gday"], null, []), 7.0) + J.mul(J.mc(env["ORDER"], "indexOf", [v_id_55]), 131.0))])
	var _t16 = null
	if J.seq(v_id_55, "jump"):
		var _t12 = (5.6 + J.mul(v_r_56, 1.0))
		_t16 = J.num(J.mc(_t12, "toFixed", [2.0]))
	else:
		var _t15 = null
		if J.seq(v_id_55, "hang"):
			_t15 = J.round(J.num((22.0 + J.mul(v_r_56, 14.0))))
		else:
			var _t14 = null
			if J.seq(v_id_55, "swim"):
				var _t13 = (17.5 + J.mul(v_r_56, 4.0))
				_t14 = J.num(J.mc(_t13, "toFixed", [1.0]))
			else:
				_t14 = 0.0
			_t15 = _t14
		_t16 = _t15
	return _t16

func _f10(this_, a: Array, env):
	var v_a_59 = null; var v_e_60 = null
	v_a_59 = J.arg(a, 0)
	return ((1.0 + (0.12 * J.sub(J.mc(J.G.get("GP"), "grow", [J.gp(v_a_59, "g")]), 1.0))) if J.t((J.gp(v_a_59, "g") if J.t(v_a_59) else v_a_59)) else 1.0)

func _f12(this_, a: Array, env):
	var v_g_64 = null
	v_g_64 = J.arg(a, 0)
	return J.seq(J.gp(v_g_64, "k"), env["k"])

func _f11(this_, a: Array, env):
	var _s15 = {"__p": env, "k": null}
	_s15["k"] = J.arg(a, 0)
	var _t17 = J.gp(J.G.get("S"), "ghosts")
	var _t18 = J.mc(_t17, "find", [Callable(self, "_f12").bind(_s15)])
	return (_t18 if J.t(_t18) else null)

func _f14(this_, a: Array, env):
	var v_x_70 = null
	v_x_70 = J.arg(a, 0)
	return J.seq(J.gp(v_x_70, "k"), "afu")

func _f13(this_, a: Array, env):
	var v_id_67 = null; var v_E_68 = null; var v_g_69 = null
	v_id_67 = J.arg(a, 0)
	v_E_68 = J.gp(env["EV"], v_id_67)
	var _t19 = env["owned"]
	v_g_69 = J.cl(_t19, null, [J.gp(v_E_68, "who")])
	var _t21 = null
	if J.t(v_g_69):
		_t21 = {"k": J.gp(v_E_68, "who"), "g": v_g_69, "name": J.gp(v_g_69, "name"), "sub": false}
	else:
		var _t20 = J.gp(J.G.get("S"), "ghosts")
		_t21 = {"k": "afu", "g": J.mc(_t20, "find", [Callable(self, "_f14").bind(env)]), "name": "阿福", "sub": true}
	return _t21

func _f16(this_, a: Array, env):
	var v_id_75 = null; var v_a_76 = null; var v_b_77 = null
	v_id_75 = J.arg(a, 0)
	v_a_76 = J.arg(a, 1)
	v_b_77 = J.arg(a, 2)
	return (J.cmp(v_a_76, v_b_77, ">") if J.t(J.gp(J.gp(env["EV"], v_id_75), "hi")) else J.cmp(v_a_76, v_b_77, "<"))

func _f18(this_, a: Array, env):
	var v_id_83 = null; var v_E_84 = null; var v_a_85 = null; var v_won_86 = null; var v_best_87 = null; var v_goal_88 = null
	v_id_83 = J.arg(a, 0)
	v_E_84 = J.gp(env["__p"]["EV"], v_id_83)
	var _t24 = env["__p"]["athlete"]
	v_a_85 = J.cl(_t24, null, [v_id_83])
	v_won_86 = J.seq(J.gp(J.gp(env["s"], "won"), v_id_83), env["today"])
	v_best_87 = J.gp(J.gp(env["s"], "best"), v_id_83)
	var _t27 = null
	if J.seq(v_id_83, "tug"):
		_t27 = ("對手：" + J.str((J.gp(J.gp(J.G.get("GHOSTS"), J.gp(v_E_84, "foe")), "name") if J.t(J.gp(J.G.get("GHOSTS"), J.gp(v_E_84, "foe"))) else "轆轤首")))
	else:
		var _t25 = env["__p"]["fmtV"]
		var _t26 = env["__p"]["target"]
		_t27 = ("Bryan 今日紀錄：" + J.str(J.cl(_t25, null, [v_id_83, J.cl(_t26, null, [v_id_83])])))
	v_goal_88 = _t27
	var _t31 = ("won" if J.t(v_won_86) else "")
	var _t32 = J.gp(v_a_85, "k")
	var _t33 = J.gp(v_E_84, "name")
	var _t34 = J.gp(v_a_85, "name")
	var _t35 = ("（替補）" if J.t(J.gp(v_a_85, "sub")) else "")
	var _t30 = null
	if (not J.leq(v_best_87, null)):
		var _t29 = null
		if J.seq(v_id_83, "tug"):
			_t29 = J.add(v_best_87, " 勝")
		else:
			var _t28 = env["__p"]["fmtV"]
			_t29 = J.cl(_t28, null, [v_id_83, v_best_87])
		_t30 = ("你的最佳：" + J.str(_t29))
	else:
		_t30 = "未參賽"
	return ("<div class=\"sp-ev " + _t31 + "\"><canvas data-por=\"" + J.str(_t32) + "\"></canvas><div><b>" + J.str(_t33) + "</b><small>出賽：" + J.str(_t34) + _t35 + "　" + J.str(v_goal_88) + "</small><small>" + _t30 + ("　<em>今日已贏</em>" if J.t(v_won_86) else "") + "</small></div><button class=\"btn sm " + ("" if J.t(v_won_86) else "gold") + "\" data-sp=\"" + J.str(v_id_83) + "\">" + ("再玩" if J.t(v_won_86) else "參賽") + "</button></div>")

func _f20(this_, a: Array, env):
	J.mc(J.G.get("UI"), "close", [])
	var _t44 = env["__p"]["__p"]["start"]
	J.cl(_t44, null, [J.gp(J.gp(env["b"], "dataset"), "sp")])

func _f19(this_, a: Array, env):
	var _s23 = {"__p": env, "b": null}
	_s23["b"] = J.arg(a, 0)
	var _t43 = _s23["b"]
	var _t45 = Callable(self, "_f20").bind(_s23)
	J.sp(_t43, "onclick", _t45)
	return _t45

func _f17(this_, a: Array, env):
	var v_h_82 = null
	var _s21 = {"__p": env, "s": null, "today": null}
	var _t23 = (not J.seq(J.typeof_(J.G.get("__nat_menu")), "undefined"))
	if J.t(_t23):
		var _t22 = J.G.get("__nat_menu")
		_t23 = J.cl(_t22, null, ["sports"])
	if J.t(_t23):
		return null
	_s21["s"] = J.cl(_s21["__p"]["st"], null, [])
	_s21["today"] = J.cl(_s21["__p"]["gday"], null, [])
	v_h_82 = ("<p class=\"desc\">陰間運動會：靠鬼自己的怪癖比賽。每項每日第一次贏過 Bryan 的紀錄，出賽的鬼存在感 +12、全村 +3、合約 KPI +2、冥幣 60。</p>")
	var _t36 = J.mc(_s21["__p"]["ORDER"], "map", [Callable(self, "_f18").bind(_s21)])
	var _t37 = J.add(v_h_82, J.mc(_t36, "join", [""]))
	v_h_82 = _t37
	J.mc(J.G.get("UI"), "sheet", ["陰間運動會", v_h_82])
	var _t38 = J.G.get("paintPortraits")
	var _t39 = J.G.get("$")
	J.cl(_t38, null, [J.cl(_t39, null, ["#sheet"])])
	var _t40 = J.G.get("$")
	var _t41 = J.cl(_t40, null, ["#sheet"])
	var _t42 = J.mc(_t41, "querySelectorAll", ["[data-sp]"])
	J.mc(_t42, "forEach", [Callable(self, "_f19").bind(_s21)])

func _f21(this_, a: Array, env):
	var v_e_92 = null
	var _t46 = J.G.get("$")
	v_e_92 = J.cl(_t46, null, ["#sports"])
	if J.t(v_e_92):
		return v_e_92
	var _t47 = J.S_document_("createElement", ["div"])
	v_e_92 = _t47
	J.sp(v_e_92, "id", "sports")
	var _t48 = J.gp(J.G.get("document"), "body")
	J.mc(_t48, "appendChild", [v_e_92])
	return v_e_92

func _f23(this_, a: Array, env):
	return J.cl(env["close"], null, [])

func _f24(this_, a: Array, env):
	if J.t(env["G"]):
		J.cl(env["draw"], null, [])

func _f25(this_, a: Array, env):
	var v_e_101 = null
	v_e_101 = J.arg(a, 0)
	J.mc(v_e_101, "preventDefault", [])
	if J.t((J.gp(env["G"], "down") if J.t(env["G"]) else env["G"])):
		var _t81 = env["pt"]
		J.mc(env["G"], "down", [J.cl(_t81, null, [v_e_101])])

func _f26(this_, a: Array, env):
	var v_e_102 = null
	v_e_102 = J.arg(a, 0)
	if J.t((J.gp(env["G"], "move") if J.t(env["G"]) else env["G"])):
		var _t82 = env["pt"]
		J.mc(env["G"], "move", [J.cl(_t82, null, [v_e_102])])

func _f27(this_, a: Array, env):
	var v_e_103 = null
	v_e_103 = J.arg(a, 0)
	if J.t((J.gp(env["G"], "up") if J.t(env["G"]) else env["G"])):
		var _t83 = env["pt"]
		J.mc(env["G"], "up", [J.cl(_t83, null, [v_e_103])])

func _f22(this_, a: Array, env):
	var v_id_95 = null; var v_E_96 = null; var v_a_97 = null; var v_root_98 = null; var v_cv_99 = null; var v_up_100 = null; var v_e_104 = null
	v_id_95 = J.arg(a, 0)
	v_E_96 = J.gp(env["EV"], v_id_95)
	var _t49 = env["athlete"]
	v_a_97 = J.cl(_t49, null, [v_id_95])
	v_root_98 = J.cl(env["el"], null, [])
	var _t51 = []
	var _t50 = env["gpf"]
	var _t52 = {"id": v_id_95, "E": v_E_96, "a": v_a_97, "t": 0.0, "phase": "intro", "introT": 2.6, "done": false, "fx": _t51, "score": null, "msg": "", "msgT": 0.0, "gpf": J.cl(_t50, null, [v_a_97])}
	env["G"] = _t52
	var _t63 = J.gp(v_E_96, "name")
	var _t64 = J.gp(v_E_96, "rule")
	var _t65 = (("<br><i>" + J.str(J.gp(v_E_96, "sub")) + "</i>") if J.t(J.gp(v_a_97, "sub")) else "")
	var _t53 = (not J.seq(v_id_95, "hang"))
	var _t62 = null
	if J.t((J.gp(v_a_97, "g") if _t53 else _t53)):
		var _t54 = env["Lx"]
		var _t55 = env["D"]
		var _t58 = J.cl(_t54, null, [J.cl(_t55, null, ["鬼力", "鬼力"])])
		var _t59 = J.mc(J.G.get("GP"), "pow", [J.gp(v_a_97, "g")])
		var _t56 = env["Lx"]
		var _t57 = env["D"]
		var _t61 = J.cl(_t56, null, [J.cl(_t57, null, ["體能", "體能"])])
		var _t60 = J.gp(env["G"], "gpf")
		_t62 = ("<br><small class=\"gp-sub\">" + J.str(_t58) + " " + J.str(_t59) + "・" + J.str(_t61) + " ×" + J.str(J.mc(_t60, "toFixed", [2.0])) + "</small>")
	else:
		_t62 = ""
	var _t66 = ("<div id=\"sp-top\"><button class=\"btn sm ghost\" id=\"sp-quit\">收場</button><b>" + J.str(_t63) + "</b><span id=\"sp-hud\"></span></div>\n      <canvas id=\"sp-cvs\"></canvas><div id=\"sp-panel\"><p id=\"sp-rule\">" + J.str(_t64) + _t65 + _t62 + "</p><div id=\"sp-btns\"></div></div>")
	J.sp(v_root_98, "innerHTML", _t66)
	var _t67 = J.gp(v_root_98, "classList")
	J.mc(_t67, "add", ["on"])
	var _t68 = J.G.get("$")
	var _t69 = J.cl(_t68, null, ["#sp-quit"])
	var _t70 = Callable(self, "_f23").bind(env)
	J.sp(_t69, "onclick", _t70)
	var _t71 = J.G.get("$")
	v_cv_99 = J.cl(_t71, null, ["#sp-cvs"])
	var _t72 = env["G"]
	J.sp(_t72, "cv", v_cv_99)
	var _t73 = env["G"]
	var _t74 = J.mc(v_cv_99, "getContext", ["2d"])
	J.sp(_t73, "ctx", _t74)
	var _t75 = env["G"]
	var _t76 = Callable(self, "_f24").bind(env)
	J.sp(_t75, "_nd", _t76)
	var _t77 = env["G"]
	var _t79 = (not J.seq(J.typeof_(J.G.get("__nat_mini")), "undefined"))
	if J.t(_t79):
		var _t78 = J.G.get("__nat_mini")
		_t79 = J.cl(_t78, null, [env["G"], "#sp-cvs", "#sports", "_nd"])
	J.sp(_t77, "_nat", _t79)
	var _t80 = env["INIT"]
	J.mc(_t80, v_id_95, [env["G"]])
	J.cl(env["resize"], null, [])
	J.S_window_("addEventListener", ["resize", env["resize"]])
	J.mc(v_cv_99, "addEventListener", ["pointerdown", Callable(self, "_f25").bind(env)])
	J.mc(v_cv_99, "addEventListener", ["pointermove", Callable(self, "_f26").bind(env)])
	v_up_100 = Callable(self, "_f27").bind(env)
	J.mc(v_cv_99, "addEventListener", ["pointerup", v_up_100])
	J.mc(v_cv_99, "addEventListener", ["pointercancel", v_up_100])
	J.mc(v_cv_99, "addEventListener", ["pointerleave", v_up_100])
	J.mc(J.G.get("Sound"), "setMode", ["story"])
	var _t84 = env["G"]
	var _t85 = J.S_performance_("now", [])
	J.sp(_t84, "last", _t85)
	J.F_requestAnimationFrame([env["frame"]])

func _f28(this_, a: Array, env):
	var v_e_107 = null; var v_r_108 = null
	v_e_107 = J.arg(a, 0)
	v_r_108 = J.mc(J.gp(env["G"], "cv"), "getBoundingClientRect", [])
	return {"x": (J.div(J.sub(J.gp(v_e_107, "clientX"), J.gp(v_r_108, "left")), J.gp(v_r_108, "width")) * 390.0), "y": (J.div(J.sub(J.gp(v_e_107, "clientY"), J.gp(v_r_108, "top")), J.gp(v_r_108, "width")) * 390.0)}

func _f29(this_, a: Array, env):
	var v_r_111 = null; var v_d_112 = null
	if (not J.t(env["G"])):
		return null
	v_r_111 = J.mc(J.gp(env["G"], "cv"), "getBoundingClientRect", [])
	var _t88 = null
	if J.t(J.gp(env["G"], "_nat")):
		_t88 = 1.0
	else:
		var _t86 = J.gp(J.G.get("window"), "devicePixelRatio")
		var _t87 = J.gp(J.G.get("window"), "devicePixelRatio")
		_t88 = J.min_([2.0, (_t87 if J.t(_t87) else 1.0)])
	v_d_112 = _t88
	var _t89 = J.gp(env["G"], "cv")
	var _t90 = J.mul(J.gp(v_r_111, "width"), v_d_112)
	J.sp(_t89, "width", _t90)
	var _t91 = J.gp(env["G"], "cv")
	var _t92 = J.mul(J.gp(v_r_111, "height"), v_d_112)
	J.sp(_t91, "height", _t92)
	var _t93 = env["G"]
	var _t94 = J.div(J.mul(J.gp(v_r_111, "width"), v_d_112), 390.0)
	J.sp(_t93, "k", _t94)
	var _t95 = env["G"]
	var _t96 = (J.div(J.gp(v_r_111, "height"), J.gp(v_r_111, "width")) * 390.0)
	J.sp(_t95, "H", _t96)

func _f30(this_, a: Array, env):
	var v_e_115 = null; var v_e_116 = null
	var _t97 = (J.gp(env["G"], "_nat") if J.t(env["G"]) else env["G"])
	if J.t(((not J.seq(J.typeof_(J.G.get("__nat_miniEnd")), "undefined")) if J.t(_t97) else _t97)):
		var _t98 = J.G.get("__nat_miniEnd")
		J.cl(_t98, null, ["#sports"])
	env["G"] = null
	var _t99 = J.G.get("$")
	v_e_115 = J.cl(_t99, null, ["#sports"])
	if J.t(v_e_115):
		var _t100 = J.gp(v_e_115, "classList")
		J.mc(_t100, "remove", ["on"])
		J.sp(v_e_115, "innerHTML", "")
	J.mc(J.G.get("Sound"), "setMode", ["village"])
	J.cl(env["open"], null, [])

func _f32(this_, a: Array, env):
	var v_x_121 = null; var v_i_122 = null
	v_x_121 = J.arg(a, 0)
	v_i_122 = J.arg(a, 1)
	var _t102 = J.gp(v_x_121, 2.0)
	return ("<button class=\"btn " + J.str((_t102 if J.t(_t102) else "gold")) + " sp-b\" data-i=\"" + J.str(v_i_122) + "\">" + J.str(J.gp(v_x_121, 0.0)) + "</button>")

func _f34(this_, a: Array, env):
	var v_e_124 = null; var v_f_125 = null
	v_e_124 = J.arg(a, 0)
	J.mc(v_e_124, "preventDefault", [])
	v_f_125 = J.gp(J.gp(env["__p"]["list"], J.num(J.gp(J.gp(env["x"], "dataset"), "i"))), 1.0)
	if J.t((J.seq(J.gp(env["__p"]["__p"]["G"], "phase"), "play") if J.t(env["__p"]["__p"]["G"]) else env["__p"]["__p"]["G"])):
		J.cl(v_f_125, null, [])

func _f33(this_, a: Array, env):
	var _s44 = {"__p": env, "x": null}
	_s44["x"] = J.arg(a, 0)
	return J.mc(_s44["x"], "addEventListener", ["pointerdown", Callable(self, "_f34").bind(_s44)])

func _f31(this_, a: Array, env):
	var v_b_120 = null
	var _s42 = {"__p": env, "list": null}
	_s42["list"] = J.arg(a, 0)
	var _t101 = J.G.get("$")
	v_b_120 = J.cl(_t101, null, ["#sp-btns"])
	var _t103 = J.mc(_s42["list"], "map", [Callable(self, "_f32").bind(_s42)])
	var _t104 = J.mc(_t103, "join", [""])
	J.sp(v_b_120, "innerHTML", _t104)
	var _t105 = J.mc(v_b_120, "querySelectorAll", [".sp-b"])
	J.mc(_t105, "forEach", [Callable(self, "_f33").bind(_s42)])

func _f35(this_, a: Array, env):
	var v_m_128 = null; var v_t_129 = null
	v_m_128 = J.arg(a, 0)
	v_t_129 = J.arg(a, 1)
	var _t106 = env["G"]
	J.sp(_t106, "msg", v_m_128)
	var _t107 = env["G"]
	var _t108 = (v_t_129 if J.t(v_t_129) else 1.2)
	J.sp(_t107, "msgT", _t108)

func _f37(this_, a: Array, env):
	var v_f_135 = null
	v_f_135 = J.arg(a, 0)
	return J.cmp(J.gp(v_f_135, "t"), J.gp(v_f_135, "life"), "<")

func _f36(this_, a: Array, env):
	var v_now_132 = null; var v_dt_133 = null; var v_f_134 = null
	v_now_132 = J.arg(a, 0)
	if (not J.t(env["G"])):
		return null
	v_dt_133 = J.min_([0.05, J.div(J.sub(v_now_132, J.gp(env["G"], "last")), 1000.0)])
	var _t109 = env["G"]
	J.sp(_t109, "last", v_now_132)
	var _t110 = env["G"]
	var _t111 = J.add(J.gp(_t110, "t"), v_dt_133)
	J.sp(_t110, "t", _t111)
	if J.cmp(J.gp(env["G"], "msgT"), 0.0, ">"):
		var _t112 = env["G"]
		var _t113 = J.sub(J.gp(_t112, "msgT"), v_dt_133)
		J.sp(_t112, "msgT", _t113)
	if J.seq(J.gp(env["G"], "phase"), "intro"):
		var _t114 = env["G"]
		var _t115 = J.sub(J.gp(_t114, "introT"), v_dt_133)
		J.sp(_t114, "introT", _t115)
		if J.cmp(J.gp(env["G"], "introT"), 0.0, "<="):
			var _t116 = env["G"]
			J.sp(_t116, "phase", "play")
	var _t117 = J.seq(J.gp(env["G"], "phase"), "play")
	if J.t((J.gp(env["G"], "tick") if _t117 else _t117)):
		J.mc(env["G"], "tick", [v_dt_133])
	for _t118 in J.iter(J.gp(env["G"], "fx")):
		v_f_134 = _t118
		var _t119 = J.add(J.gp(v_f_134, "t"), v_dt_133)
		J.sp(v_f_134, "t", _t119)
	var _t120 = env["G"]
	var _t121 = J.gp(env["G"], "fx")
	var _t122 = J.mc(_t121, "filter", [Callable(self, "_f37").bind(env)])
	J.sp(_t120, "fx", _t122)
	if (not J.t(J.gp(env["G"], "_nat"))):
		J.cl(env["draw"], null, [])
	J.F_requestAnimationFrame([env["frame"]])

func _f38(this_, a: Array, env):
	var v_c_138 = null; var v_H_139 = null; var v_hud_140 = null; var v_f_141 = null; var v_q_142 = null
	var _t123 = J.gp(env["G"], "_nat")
	if J.t(((not J.t(J.gp(env["G"], "_natCtx"))) if J.t(_t123) else _t123)):
		return null
	var _t124 = J.gp(env["G"], "_natCtx")
	v_c_138 = (_t124 if J.t(_t124) else J.gp(env["G"], "ctx"))
	v_H_139 = J.gp(env["G"], "H")
	J.mc(v_c_138, "setTransform", [J.gp(env["G"], "k"), 0.0, 0.0, J.gp(env["G"], "k"), 0.0, 0.0])
	J.mc(v_c_138, "clearRect", [0.0, 0.0, 390.0, v_H_139])
	var _t125 = env["has"]
	var _t126 = J.cl(_t125, null, [J.G.get("SCENE")])
	if (not J.t((J.mc(J.G.get("SCENE"), "drawBg", [v_c_138, 390.0, v_H_139, J.gp(J.gp(env["G"], "E"), "bg")]) if J.t(_t126) else _t126))):
		J.sp(v_c_138, "fillStyle", "#1c1820")
		J.mc(v_c_138, "fillRect", [0.0, 0.0, 390.0, v_H_139])
	J.sp(v_c_138, "fillStyle", "rgba(10,8,16,.35)")
	J.mc(v_c_138, "fillRect", [0.0, 0.0, 390.0, v_H_139])
	J.mc(env["G"], "draw", [v_c_138, v_H_139])
	for _t127 in J.iter(J.gp(env["G"], "fx")):
		v_f_141 = _t127
		v_q_142 = J.div(J.gp(v_f_141, "t"), J.gp(v_f_141, "life"))
		J.mc(v_c_138, "save", [])
		var _t128 = J.sub(1.0, v_q_142)
		J.sp(v_c_138, "globalAlpha", _t128)
		var _t129 = J.gp(v_f_141, "size")
		var _t130 = ("bold " + J.str((_t129 if J.t(_t129) else 18.0)) + "px \"PingFang TC\",\"Noto Sans TC\",sans-serif")
		J.sp(v_c_138, "font", _t130)
		J.sp(v_c_138, "textAlign", "center")
		J.sp(v_c_138, "lineWidth", 4.0)
		J.sp(v_c_138, "strokeStyle", "rgba(0,0,0,.75)")
		var _t131 = J.gp(v_f_141, "col")
		var _t132 = (_t131 if J.t(_t131) else "#fff")
		J.sp(v_c_138, "fillStyle", _t132)
		J.mc(v_c_138, "strokeText", [J.gp(v_f_141, "text"), J.gp(v_f_141, "x"), J.sub(J.gp(v_f_141, "y"), J.mul(v_q_142, 26.0))])
		J.mc(v_c_138, "fillText", [J.gp(v_f_141, "text"), J.gp(v_f_141, "x"), J.sub(J.gp(v_f_141, "y"), J.mul(v_q_142, 26.0))])
		J.mc(v_c_138, "restore", [])
	if J.seq(J.gp(env["G"], "phase"), "intro"):
		var _t133 = env["banner"]
		var _t135 = J.gp(J.gp(env["G"], "E"), "name")
		var _t134 = env["Lx"]
		J.cl(_t133, null, [v_c_138, v_H_139, _t135, J.cl(_t134, null, [J.gp(env["BRYAN"], J.gp(env["G"], "id"))])])
	var _t136 = J.cmp(J.gp(env["G"], "msgT"), 0.0, ">")
	if J.t((J.gp(env["G"], "msg") if _t136 else _t136)):
		J.mc(v_c_138, "save", [])
		var _t137 = "bold 22px \"PingFang TC\",\"Noto Sans TC\",sans-serif"
		J.sp(v_c_138, "font", _t137)
		J.sp(v_c_138, "textAlign", "center")
		J.sp(v_c_138, "lineWidth", 5.0)
		J.sp(v_c_138, "strokeStyle", "rgba(0,0,0,.8)")
		J.sp(v_c_138, "fillStyle", "#ffd84a")
		J.mc(v_c_138, "strokeText", [J.gp(env["G"], "msg"), 195.0, J.mul(v_H_139, 0.2)])
		J.mc(v_c_138, "fillText", [J.gp(env["G"], "msg"), 195.0, J.mul(v_H_139, 0.2)])
		J.mc(v_c_138, "restore", [])
	var _t138 = J.G.get("$")
	v_hud_140 = J.cl(_t138, null, ["#sp-hud"])
	if J.t((J.gp(env["G"], "hud") if J.t(v_hud_140) else v_hud_140)):
		var _t139 = J.mc(env["G"], "hud", [])
		J.sp(v_hud_140, "textContent", _t139)

func _f39(this_, a: Array, env):
	var v_c_145 = null; var v_H_146 = null; var v_a_147 = null; var v_b_148 = null
	v_c_145 = J.arg(a, 0)
	v_H_146 = J.arg(a, 1)
	v_a_147 = J.arg(a, 2)
	v_b_148 = J.arg(a, 3)
	J.mc(v_c_145, "save", [])
	J.sp(v_c_145, "fillStyle", "rgba(0,0,0,.6)")
	J.mc(v_c_145, "fillRect", [0.0, J.mul(v_H_146, 0.32), 390.0, 92.0])
	J.sp(v_c_145, "textAlign", "center")
	J.sp(v_c_145, "fillStyle", "#ffd84a")
	var _t140 = "bold 26px \"PingFang TC\",\"Noto Sans TC\",sans-serif"
	J.sp(v_c_145, "font", _t140)
	J.mc(v_c_145, "fillText", [v_a_147, 195.0, (J.mul(v_H_146, 0.32) + 38.0)])
	J.sp(v_c_145, "fillStyle", "#eee")
	var _t141 = "14px \"PingFang TC\",\"Noto Sans TC\",sans-serif"
	J.sp(v_c_145, "font", _t141)
	var _t142 = env["wrap"]
	J.cl(_t142, null, [v_c_145, v_b_148, 195.0, (J.mul(v_H_146, 0.32) + 66.0), 350.0, 18.0])
	J.mc(v_c_145, "restore", [])

func _f40(this_, a: Array, env):
	var v_c_151 = null; var v_s_152 = null; var v_x_153 = null; var v_y_154 = null; var v_w_155 = null; var v_lh_156 = null; var v_line_157 = null; var v_yy_158 = null; var v_ch_159 = null
	v_c_151 = J.arg(a, 0)
	v_s_152 = J.arg(a, 1)
	v_x_153 = J.arg(a, 2)
	v_y_154 = J.arg(a, 3)
	v_w_155 = J.arg(a, 4)
	v_lh_156 = J.arg(a, 5)
	v_line_157 = ""
	v_yy_158 = v_y_154
	for _t143 in J.iter(v_s_152):
		v_ch_159 = _t143
		if J.cmp(J.gp(J.mc(v_c_151, "measureText", [J.add(v_line_157, v_ch_159)]), "width"), v_w_155, ">"):
			J.mc(v_c_151, "fillText", [v_line_157, v_x_153, v_yy_158])
			v_line_157 = v_ch_159
			var _t144 = J.add(v_yy_158, v_lh_156)
			v_yy_158 = _t144
		else:
			var _t145 = J.add(v_line_157, v_ch_159)
			v_line_157 = _t145
	J.mc(v_c_151, "fillText", [v_line_157, v_x_153, v_yy_158])

func _f41(this_, a: Array, env):
	var v_text_162 = null; var v_x_163 = null; var v_y_164 = null; var v_col_165 = null; var v_size_166 = null
	v_text_162 = J.arg(a, 0)
	v_x_163 = J.arg(a, 1)
	v_y_164 = J.arg(a, 2)
	v_col_165 = J.arg(a, 3)
	v_size_166 = J.arg(a, 4)
	var _t146 = J.gp(env["G"], "fx")
	J.mc(_t146, "push", [{"text": v_text_162, "x": v_x_163, "y": v_y_164, "col": v_col_165, "size": v_size_166, "t": 0.0, "life": 0.9}])

func _f42(this_, a: Array, env):
	var v_c_169 = null; var v_k_170 = null; var v_x_171 = null; var v_y_172 = null; var v_s_173 = null; var v_o_174 = null; var v_e_175 = null
	v_c_169 = J.arg(a, 0)
	v_k_170 = J.arg(a, 1)
	v_x_171 = J.arg(a, 2)
	v_y_172 = J.arg(a, 3)
	v_s_173 = J.arg(a, 4)
	v_o_174 = J.arg(a, 5)
	var _t147 = (J.gp(env["G"], "_nat") if J.t(env["G"]) else env["G"])
	var _t148 = (J.G.get("__nat_drawChar") if J.t(((not J.seq(J.typeof_(J.G.get("__nat_drawChar")), "undefined")) if J.t(_t147) else _t147)) else J.gp(J.G.get("ART"), "drawChar"))
	J.cl(_t148, null, [v_c_169, v_k_170, v_x_171, v_y_172, v_s_173, J.S_Object_("assign", [{"t": J.gp(env["G"], "t")}, (v_o_174 if J.t(v_o_174) else {})])])

func _f43(this_, a: Array, env):
	var v_c_178 = null; var v_x_179 = null; var v_y_180 = null; var v_h_181 = null; var v_state_182 = null; var v_o_183 = null; var v_e_184 = null
	v_c_178 = J.arg(a, 0)
	v_x_179 = J.arg(a, 1)
	v_y_180 = J.arg(a, 2)
	v_h_181 = J.arg(a, 3)
	v_state_182 = J.arg(a, 4)
	v_o_183 = J.arg(a, 5)
	J.mc(J.G.get("Antag"), "draw", [v_c_178, "npc_rival", v_x_179, v_y_180, v_h_181, (v_state_182 if J.t(v_state_182) else "idle"), J.gp(env["G"], "t"), J.S_Object_("assign", [{"shadow": false, "time": J.gp(env["G"], "t")}, (v_o_183 if J.t(v_o_183) else {})])])

func _f45(this_, a: Array, env):
	var _t191 = env["__p"]["start"]
	return J.cl(_t191, null, [env["id"]])

func _f46(this_, a: Array, env):
	return J.cl(env["__p"]["close"], null, [])

func _f44(this_, a: Array, env):
	var v_v_187 = null; var v_line_188 = null; var v_s_189 = null; var v_today_191 = null; var v_win_192 = null; var v_rec_193 = null; var v_rw_194 = null; var v_res_195 = null; var v_vs_196 = null; var v_p_197 = null; var v_got_198 = null; var v_g_199 = null
	var _s70 = {"__p": env, "id": null}
	v_v_187 = J.arg(a, 0)
	v_line_188 = J.arg(a, 1)
	if J.t(J.gp(_s70["__p"]["G"], "done")):
		return null
	var _t149 = _s70["__p"]["G"]
	J.sp(_t149, "done", true)
	var _t150 = _s70["__p"]["G"]
	J.sp(_t150, "phase", "end")
	v_s_189 = J.cl(_s70["__p"]["st"], null, [])
	_s70["id"] = J.gp(_s70["__p"]["G"], "id")
	v_today_191 = J.cl(_s70["__p"]["gday"], null, [])
	var _t151 = J.gp(v_s_189, "plays")
	var _t152 = J.add((_t151 if J.t(_t151) else 0.0), 1.0)
	J.sp(v_s_189, "plays", _t152)
	v_win_192 = null
	v_rec_193 = ""
	if J.seq(_s70["id"], "tug"):
		var _t153 = J.cmp(v_v_187, 0.0, ">")
		v_win_192 = _t153
		var _t154 = J.gp(v_s_189, "best")
		var _t155 = J.gp(J.gp(v_s_189, "best"), "tug")
		var _t156 = J.add((_t155 if J.t(_t155) else 0.0), (1.0 if J.t(v_win_192) else 0.0))
		J.sp(_t154, "tug", _t156)
	else:
		var _t160 = (not J.leq(v_v_187, null))
		if J.t(_t160):
			var _t157 = _s70["__p"]["better"]
			var _t159 = _s70["id"]
			var _t158 = _s70["__p"]["target"]
			_t160 = J.cl(_t157, null, [_t159, v_v_187, J.cl(_t158, null, [_s70["id"]])])
		v_win_192 = _t160
		var _t163 = (not J.leq(v_v_187, null))
		if J.t(_t163):
			var _t162 = J.leq(J.gp(J.gp(v_s_189, "best"), _s70["id"]), null)
			if not J.t(_t162):
				var _t161 = _s70["__p"]["better"]
				_t162 = J.cl(_t161, null, [_s70["id"], v_v_187, J.gp(J.gp(v_s_189, "best"), _s70["id"])])
			_t163 = _t162
		if J.t(_t163):
			var _t164 = J.gp(v_s_189, "best")
			var _t165 = _s70["id"]
			J.sp(_t164, _t165, v_v_187)
			v_rec_193 = "　<b>個人新紀錄！</b>"
	v_rw_194 = ""
	if J.t(((not J.seq(J.gp(J.gp(v_s_189, "won"), _s70["id"]), v_today_191)) if J.t(v_win_192) else v_win_192)):
		var _t166 = J.gp(v_s_189, "won")
		var _t167 = _s70["id"]
		J.sp(_t166, _t167, v_today_191)
		var _t168 = _s70["__p"]["has"]
		if J.t(J.cl(_t168, null, [J.G.get("Presence")])):
			if J.t(J.gp(J.gp(_s70["__p"]["G"], "a"), "g")):
				J.mc(J.G.get("Presence"), "add", [J.gp(J.gp(_s70["__p"]["G"], "a"), "g"), 12.0])
			for _t169 in J.iter(J.gp(J.G.get("S"), "ghosts")):
				v_g_199 = _t169
				if (not J.seq(v_g_199, J.gp(J.gp(_s70["__p"]["G"], "a"), "g"))):
					J.mc(J.G.get("Presence"), "add", [v_g_199, 3.0])
		var _t170 = J.gp(J.G.get("S"), "contract")
		if J.t((J.seq(J.gp(J.gp(J.G.get("S"), "contract"), "state"), "active") if J.t(_t170) else _t170)):
			var _t171 = J.gp(J.G.get("S"), "contract")
			var _t172 = J.add(J.gp(_t171, "kpi"), 2.0)
			J.sp(_t171, "kpi", _t172)
		var _t173 = J.G.get("give")
		v_got_198 = J.cl(_t173, null, [{"coins": 60.0}])
		var _t175 = J.gp(J.gp(_s70["__p"]["G"], "a"), "name")
		var _t174 = J.gp(J.G.get("S"), "contract")
		var _t176 = ("<p class=\"desc\">" + J.str(_t175) + " 存在感 +12，全村 +3" + ("，合約 KPI +2" if J.t((J.seq(J.gp(J.gp(J.G.get("S"), "contract"), "state"), "active") if J.t(_t174) else _t174)) else "") + "，" + J.str(v_got_198) + "</p>")
		v_rw_194 = _t176
	else:
		if J.t(v_win_192):
			v_rw_194 = "<p class=\"desc\">今日已經領過獎，這場算練習。</p>"
	J.cl(J.G.get("save"), null, [])
	var _t179 = null
	if J.seq(_s70["id"], "tug"):
		_t179 = ("贏了！" if J.t(v_win_192) else "輸了")
	else:
		var _t178 = null
		if J.leq(v_v_187, null):
			_t178 = "犯規"
		else:
			var _t177 = _s70["__p"]["fmtV"]
			_t178 = J.cl(_t177, null, [_s70["id"], v_v_187])
		_t179 = _t178
	v_res_195 = _t179
	var _t183 = null
	if J.seq(_s70["id"], "tug"):
		_t183 = ""
	else:
		var _t180 = _s70["__p"]["fmtV"]
		var _t182 = _s70["id"]
		var _t181 = _s70["__p"]["target"]
		_t183 = ("<p class=\"desc\">Bryan 今日紀錄：" + J.str(J.cl(_t180, null, [_t182, J.cl(_t181, null, [_s70["id"]])])) + J.str(v_rec_193) + "</p>")
	v_vs_196 = _t183
	var _t184 = J.G.get("$")
	v_p_197 = J.cl(_t184, null, ["#sp-panel"])
	if (not J.t(v_p_197)):
		return null
	var _t187 = ("贏了 Bryan！" if J.t(v_win_192) else ("被轆轤首拉過去了" if J.seq(_s70["id"], "tug") else "輸給 Bryan"))
	var _t186 = null
	if J.t(v_line_188):
		var _t185 = _s70["__p"]["Lx"]
		_t186 = ("<p class=\"desc\"><i>" + J.str(J.cl(_t185, null, [v_line_188])) + "</i></p>")
	else:
		_t186 = ""
	var _t188 = ("<div class=\"sp-end\"><h3>" + _t187 + "</h3><p class=\"sp-big\">" + J.str(v_res_195) + "</p>" + _t186 + J.str(v_vs_196) + J.str(v_rw_194) + "<div class=\"sp-endb\"><button class=\"btn\" id=\"sp-again\">再來一次</button><button class=\"btn gold\" id=\"sp-back\">回運動會</button></div></div>")
	J.sp(v_p_197, "innerHTML", _t188)
	var _t189 = J.G.get("$")
	var _t190 = J.cl(_t189, null, ["#sp-again"])
	var _t192 = Callable(self, "_f45").bind(_s70)
	J.sp(_t190, "onclick", _t192)
	var _t193 = J.G.get("$")
	var _t194 = J.cl(_t193, null, ["#sp-back"])
	var _t195 = Callable(self, "_f46").bind(_s70)
	J.sp(_t194, "onclick", _t195)

func _f2(this_, a: Array, env):
	var v_yue_38 = null; var v_zh_39 = null
	v_yue_38 = J.arg(a, 0)
	v_zh_39 = J.arg(a, 1)
	if (not J.seq(J.typeof_(J.G.get("LANG")), "undefined")):
		J.mc(J.G.get("LANG"), "add", [{J.key(v_yue_38): v_zh_39}])
	return v_yue_38

func _f3(this_, a: Array, env):
	if (not J.seq(J.typeof_(J.G.get("LANG")), "undefined")):
		J.mc(J.G.get("LANG"), "add", [{"繃緊！唔好拉！": "繃緊了！不要拉！"}])
	return "繃緊！唔好拉！"

func _f4(this_, a: Array, env):
	var v_o_40 = null
	v_o_40 = J.arg(a, 0)
	return (not J.seq(J.typeof_(v_o_40), "undefined"))

func _f5(this_, a: Array, env):
	var v_x_41 = null
	v_x_41 = J.arg(a, 0)
	var _t204 = null
	if J.seq(J.typeof_(J.G.get("L")), "function"):
		var _t203 = J.G.get("L")
		_t204 = J.cl(_t203, null, [v_x_41])
	else:
		_t204 = v_x_41
	return _t204

func _f15(this_, a: Array, env):
	var v_id_71 = null; var v_v_72 = null
	v_id_71 = J.arg(a, 0)
	v_v_72 = J.arg(a, 1)
	return ("" if J.seq(v_id_71, "tug") else (J.add(J.mc(v_v_72, "toFixed", [2.0]), " 米") if J.seq(v_id_71, "jump") else (J.add(J.mc(v_v_72, "toFixed", [1.0]), " 秒") if J.seq(v_id_71, "swim") else J.add(floor(J.num(v_v_72)), " 秒"))))

func _f48(this_, a: Array, env):
	return ("" if J.t(J.gp(env["G"], "fly")) else ("節奏 " + J.str(J.round(J.num(((0.6 + J.mul(0.4, J.cl(env["avg"], null, []))) * 100.0)))) + "%"))

func _f50(this_, a: Array, env):
	var v_s_207 = null; var v_v_208 = null
	v_s_207 = J.arg(a, 0)
	v_v_208 = J.arg(a, 1)
	return J.add(v_s_207, v_v_208)

func _f49(this_, a: Array, env):
	var _t211 = null
	if J.t(J.len(J.gp(env["G"], "acc"))):
		var _t210 = J.gp(env["G"], "acc")
		_t211 = J.div(J.mc(_t210, "reduce", [Callable(self, "_f50").bind(env), 0.0]), J.len(J.gp(env["G"], "acc")))
	else:
		_t211 = 0.0
	return _t211

func _f51(this_, a: Array, env):
	var v_land_209 = null; var v_early_210 = null; var v_d_211 = null; var v_i_212 = null; var v_q_213 = null
	var _t212 = J.gp(env["G"], "fly")
	if J.t((_t212 if J.t(_t212) else J.cmp(J.gp(env["G"], "hop"), env["HOPS"], ">="))):
		J.cl(env["takeoff"], null, [])
		return null
	v_land_209 = J.sub(env["T"], J.gp(env["G"], "hopT"))
	v_early_210 = J.gp(env["G"], "hopT")
	v_d_211 = J.min_([v_land_209, v_early_210])
	v_i_212 = (J.gp(env["G"], "hop") if J.cmp(v_land_209, v_early_210, "<") else J.sub(J.gp(env["G"], "hop"), 1.0))
	var _t213 = J.cmp(v_i_212, 0.0, "<")
	if J.t((_t213 if _t213 else J.gp(J.gp(env["G"], "tapped"), v_i_212))):
		return null
	var _t214 = J.gp(env["G"], "tapped")
	J.sp(_t214, v_i_212, 1.0)
	v_q_213 = (1.0 if J.cmp(v_d_211, 0.09, "<") else (0.7 if J.cmp(v_d_211, 0.17, "<") else 0.15))
	var _t215 = J.gp(env["G"], "acc")
	J.mc(_t215, "push", [v_q_213])
	var _t216 = env["__p"]["pop"]
	var _t219 = ("好節奏！" if J.seq(v_q_213, 1.0) else ("還可以" if J.cmp(v_q_213, 0.5, ">") else "亂跳"))
	var _t218 = J.gp(env["G"], "x")
	var _t217 = J.gp(env["G"], "cam")
	J.cl(_t216, null, [_t219, J.sub(_t218, (_t217 if J.t(_t217) else 0.0)), J.mul(J.gp(env["G"], "H"), 0.42), ("#ffd84a" if J.seq(v_q_213, 1.0) else "#ddd"), 16.0])

func _f52(this_, a: Array, env):
	var v_gap_214 = null; var v_sp_215 = null; var v_dist_216 = null
	var _t220 = J.gp(env["G"], "fly")
	if J.t((_t220 if J.t(_t220) else J.cmp(J.gp(env["G"], "hop"), env["HOPS"], "<"))):
		return null
	v_gap_214 = J.div(J.sub(J.gp(env["G"], "lineX"), J.gp(env["G"], "x")), env["PX"])
	v_sp_215 = (0.6 + J.mul(0.4, J.cl(env["avg"], null, [])))
	if J.cmp(v_gap_214, 0.0, "<"):
		var _t221 = env["G"]
		var _t222 = {"t": 0.0, "dist": 0.0, "foul": true}
		J.sp(_t221, "fly", _t222)
		var _t223 = env["__p"]["say"]
		J.cl(_t223, null, ["踩線犯規！", 1.6])
		return null
	v_dist_216 = J.max_([0.5, (J.mul(J.mul(v_sp_215, 7.6), J.gp(env["G"], "gpf")) - J.mul(v_gap_214, 1.2))])
	var _t224 = env["G"]
	var _t225 = {"t": 0.0, "dist": v_dist_216, "x0": J.gp(env["G"], "x"), "foul": false}
	J.sp(_t224, "fly", _t225)

func _f53(this_, a: Array, env):
	return J.cl(env["tapHop"], null, [])

func _f54(this_, a: Array, env):
	if J.seq(J.gp(env["G"], "phase"), "play"):
		J.cl(env["tapHop"], null, [])

func _f55(this_, a: Array, env):
	var v_dt_217 = null
	v_dt_217 = J.arg(a, 0)
	if J.t(J.gp(env["G"], "fly")):
		var _t230 = J.gp(env["G"], "fly")
		var _t231 = J.add(J.gp(_t230, "t"), v_dt_217)
		J.sp(_t230, "t", _t231)
		var _t232 = J.cmp(J.gp(J.gp(env["G"], "fly"), "t"), (1.2 if J.t(J.gp(J.gp(env["G"], "fly"), "foul")) else 1.4), ">")
		if ((not J.t(J.gp(env["G"], "done"))) if _t232 else _t232):
			var _t233 = env["__p"]["finish"]
			var _t235 = null
			if J.t(J.gp(J.gp(env["G"], "fly"), "foul")):
				_t235 = null
			else:
				var _t234 = J.gp(J.gp(env["G"], "fly"), "dist")
				_t235 = J.num(J.mc(_t234, "toFixed", [2.0]))
			var _t242 = null
			if J.t(J.gp(J.gp(env["G"], "fly"), "foul")):
				var _t236 = env["__p"]["D"]
				_t242 = J.cl(_t236, null, ["殭屍跳過咗龍，腳尖踩到白線。裁判（一隻雜鬼）舉紅旗。", "殭屍跳過了頭，腳尖踩到白線。裁判（一隻雜鬼）舉紅旗。"])
			else:
				var _t238 = J.gp(J.gp(env["G"], "fly"), "dist")
				var _t237 = env["__p"]["target"]
				var _t241 = null
				if J.cmp(_t238, J.cl(_t237, null, ["jump"]), ">"):
					var _t239 = env["__p"]["D"]
					_t241 = J.cl(_t239, null, ["落地姿勢：成條棍咁插落沙池。裁判俾滿分。", "落地姿勢：直挺挺插進沙池。裁判給滿分。"])
				else:
					var _t240 = env["__p"]["D"]
					_t241 = J.cl(_t240, null, ["膝頭太直，起跳差少少。", "膝蓋太直，起跳時差一點點。"])
				_t242 = _t241
			J.cl(_t233, null, [_t235, _t242])
		return null
	if J.cmp(J.gp(env["G"], "hop"), env["HOPS"], "<"):
		var _t243 = env["G"]
		var _t244 = J.add(J.gp(_t243, "hopT"), J.mul(v_dt_217, (0.85 + J.mul(0.3, J.gp(env["G"], "speed")))))
		J.sp(_t243, "hopT", _t244)
		if J.cmp(J.gp(env["G"], "hopT"), env["T"], ">="):
			var _t245 = env["G"]
			var _t246 = J.sub(J.gp(_t245, "hopT"), env["T"])
			J.sp(_t245, "hopT", _t246)
			var _t247 = env["G"]
			J.sp(_t247, "hop", J.num(J.gp(_t247, "hop")) + 1.0)
			if (not J.t(J.gp(J.gp(env["G"], "tapped"), J.sub(J.gp(env["G"], "hop"), 1.0)))):
				var _t248 = J.gp(env["G"], "acc")
				J.mc(_t248, "push", [0.0])
			var _t249 = env["G"]
			var _t250 = (0.6 + J.mul(0.4, J.cl(env["avg"], null, [])))
			J.sp(_t249, "speed", _t250)
		var _t251 = env["G"]
		var _t252 = (40.0 + J.mul(J.add(J.gp(env["G"], "hop"), J.div(J.gp(env["G"], "hopT"), env["T"])), 48.0))
		J.sp(_t251, "x", _t252)
	else:
		var _t253 = env["G"]
		var _t254 = J.add(J.gp(_t253, "x"), (J.mul(v_dt_217, 70.0) * (0.8 + J.mul(0.5, J.gp(env["G"], "speed")))))
		J.sp(_t253, "x", _t254)
		var _t255 = J.cmp(J.gp(env["G"], "x"), J.add(J.gp(env["G"], "lineX"), 40.0), ">")
		if ((not J.t(J.gp(env["G"], "fly"))) if _t255 else _t255):
			var _t256 = env["G"]
			var _t257 = {"t": 0.0, "dist": 0.0, "foul": true}
			J.sp(_t256, "fly", _t257)
			var _t258 = env["__p"]["say"]
			J.cl(_t258, null, ["踩線犯規！", 1.6])

func _f56(this_, a: Array, env):
	var v_c_218 = null; var v_H_219 = null; var v_gy_220 = null; var v_SC_221 = null; var v_fx_222 = null; var v_cam_223 = null; var v_bx_224 = null; var v_x_225 = null; var v_y_226 = null; var v_pose_227 = null; var v_pt_228 = null; var v_m_229 = null; var v_x_230 = null; var v_p_231 = null; var v_p_232 = null; var v_p_233 = null; var v_r_234 = null; var v_t_235 = null
	v_c_218 = J.arg(a, 0)
	v_H_219 = J.arg(a, 1)
	v_gy_220 = J.mul(v_H_219, 0.66)
	v_SC_221 = 1.6
	var _t261 = J.gp(env["G"], "fly")
	v_fx_222 = (J.add(J.gp(env["G"], "lineX"), (J.mul(J.gp(J.gp(env["G"], "fly"), "dist"), env["PX"]) * J.min_([1.0, J.div(J.gp(J.gp(env["G"], "fly"), "t"), 0.9)]))) if J.t(((not J.t(J.gp(J.gp(env["G"], "fly"), "foul"))) if J.t(_t261) else _t261)) else J.gp(env["G"], "x"))
	v_cam_223 = J.max_([0.0, J.min_([J.sub(J.add(J.gp(env["G"], "lineX"), J.mul(9.5, env["PX"])), 390.0), J.sub(v_fx_222, 150.0)])])
	var _t262 = env["G"]
	J.sp(_t262, "cam", v_cam_223)
	J.mc(v_c_218, "save", [])
	J.mc(v_c_218, "translate", [(-J.num(v_cam_223)), 0.0])
	J.sp(v_c_218, "fillStyle", "rgba(140,90,60,.6)")
	J.mc(v_c_218, "fillRect", [0.0, J.sub(v_gy_220, 8.0), J.add(J.gp(env["G"], "lineX"), J.mul(12.0, env["PX"])), 26.0])
	J.sp(v_c_218, "fillStyle", "rgba(225,195,125,.6)")
	J.mc(v_c_218, "fillRect", [J.gp(env["G"], "lineX"), J.sub(v_gy_220, 8.0), J.mul(10.0, env["PX"]), 26.0])
	J.sp(v_c_218, "fillStyle", "#f4f0e0")
	J.mc(v_c_218, "fillRect", [J.sub(J.gp(env["G"], "lineX"), 2.0), J.sub(v_gy_220, 10.0), 5.0, 30.0])
	J.sp(v_c_218, "font", "bold 11px sans-serif")
	J.sp(v_c_218, "textAlign", "center")
	v_m_229 = 1.0
	while true:
		if not J.cmp(v_m_229, 9.0, "<="): break
		v_x_230 = J.add(J.gp(env["G"], "lineX"), J.mul(v_m_229, env["PX"]))
		J.sp(v_c_218, "fillStyle", "rgba(255,255,255,.6)")
		J.mc(v_c_218, "fillRect", [v_x_230, J.add(v_gy_220, 18.0), 1.5, 7.0])
		J.mc(v_c_218, "fillText", [J.add(v_m_229, "米"), v_x_230, J.add(v_gy_220, 38.0)])
		v_m_229 = J.num(v_m_229) + 1.0
	var _t264 = J.gp(env["G"], "lineX")
	var _t263 = env["__p"]["target"]
	v_bx_224 = J.add(_t264, J.mul(J.cl(_t263, null, ["jump"]), env["PX"]))
	J.sp(v_c_218, "fillStyle", "#c0392b")
	J.mc(v_c_218, "fillRect", [v_bx_224, J.sub(v_gy_220, 44.0), 3.0, 44.0])
	J.mc(v_c_218, "fillRect", [J.add(v_bx_224, 3.0), J.sub(v_gy_220, 44.0), 30.0, 16.0])
	J.sp(v_c_218, "fillStyle", "#fff")
	J.sp(v_c_218, "font", "bold 10px sans-serif")
	J.sp(v_c_218, "textAlign", "left")
	J.mc(v_c_218, "fillText", ["Bryan", J.add(v_bx_224, 4.0), J.sub(v_gy_220, 32.0)])
	v_x_225 = J.gp(env["G"], "x")
	v_y_226 = v_gy_220
	v_pose_227 = null
	v_pt_228 = 0.0
	var _t265 = J.gp(env["G"], "fly")
	if J.t(((not J.t(J.gp(J.gp(env["G"], "fly"), "foul"))) if J.t(_t265) else _t265)):
		v_p_231 = J.min_([1.0, J.div(J.gp(J.gp(env["G"], "fly"), "t"), 0.9)])
		v_x_225 = v_fx_222
		var _t266 = J.sub(v_gy_220, (sin(J.num(J.mul(v_p_231, PI))) * 110.0))
		v_y_226 = _t266
		var _t267 = ("air" if J.cmp(v_p_231, 1.0, "<") else null)
		v_pose_227 = _t267
		v_pt_228 = v_p_231
	else:
		var _t268 = (not J.t(J.gp(env["G"], "fly")))
		if (J.cmp(J.gp(env["G"], "hop"), env["HOPS"], "<") if _t268 else _t268):
			v_p_232 = J.div(J.gp(env["G"], "hopT"), env["T"])
			var _t269 = J.sub(v_gy_220, (sin(J.num(J.mul(v_p_232, PI))) * 34.0))
			v_y_226 = _t269
	var _t270 = (not J.t(J.gp(env["G"], "fly")))
	if (J.cmp(J.gp(env["G"], "hop"), env["HOPS"], "<") if _t270 else _t270):
		v_p_233 = J.div(J.gp(env["G"], "hopT"), env["T"])
		v_r_234 = (10.0 + (J.sub(1.0, v_p_233) * 34.0))
		var _t271 = ("#ffd84a" if J.cmp(v_p_233, 0.75, ">") else "rgba(255,255,255,.55)")
		J.sp(v_c_218, "strokeStyle", _t271)
		J.sp(v_c_218, "lineWidth", 3.0)
		J.mc(v_c_218, "beginPath", [])
		J.mc(v_c_218, "ellipse", [J.gp(env["G"], "x"), J.add(v_gy_220, 4.0), v_r_234, J.mul(v_r_234, 0.32), 0.0, 0.0, (PI * 2.0)])
		J.mc(v_c_218, "stroke", [])
	var _t272 = env["__p"]["char"]
	J.cl(_t272, null, [v_c_218, J.gp(J.gp(env["G"], "a"), "k"), v_x_225, v_y_226, v_SC_221, {"pose": v_pose_227, "pt": v_pt_228, "shadow": false}])
	var _t273 = J.gp(env["G"], "fly")
	var _t274 = ((not J.t(J.gp(J.gp(env["G"], "fly"), "foul"))) if J.t(_t273) else _t273)
	if J.t((J.cmp(J.gp(J.gp(env["G"], "fly"), "t"), 0.9, ">") if J.t(_t274) else _t274)):
		J.sp(v_c_218, "fillStyle", "#ffd84a")
		J.mc(v_c_218, "fillRect", [J.sub(v_fx_222, 1.0), J.sub(v_gy_220, 6.0), 3.0, 22.0])
	J.mc(v_c_218, "restore", [])
	var _t275 = (not J.t(J.gp(env["G"], "fly")))
	if (J.cmp(J.gp(env["G"], "hop"), env["HOPS"], ">=") if _t275 else _t275):
		J.mc(v_c_218, "save", [])
		J.sp(v_c_218, "font", "bold 24px sans-serif")
		J.sp(v_c_218, "textAlign", "center")
		J.sp(v_c_218, "lineWidth", 5.0)
		J.sp(v_c_218, "strokeStyle", "#000")
		J.sp(v_c_218, "fillStyle", "#ffd84a")
		J.mc(v_c_218, "strokeText", ["起跳！", 195.0, J.mul(v_H_219, 0.3)])
		J.mc(v_c_218, "fillText", ["起跳！", 195.0, J.mul(v_H_219, 0.3)])
		J.mc(v_c_218, "restore", [])
	var _t276 = J.gp(env["G"], "fly")
	var _t277 = ((not J.t(J.gp(J.gp(env["G"], "fly"), "foul"))) if J.t(_t276) else _t276)
	if J.t((J.cmp(J.gp(J.gp(env["G"], "fly"), "t"), 0.9, ">") if J.t(_t277) else _t277)):
		J.mc(v_c_218, "save", [])
		J.sp(v_c_218, "font", "bold 30px sans-serif")
		J.sp(v_c_218, "textAlign", "center")
		J.sp(v_c_218, "lineWidth", 6.0)
		J.sp(v_c_218, "strokeStyle", "#000")
		J.sp(v_c_218, "fillStyle", "#fff")
		var _t278 = J.gp(J.gp(env["G"], "fly"), "dist")
		v_t_235 = J.add(J.mc(_t278, "toFixed", [2.0]), " 米")
		J.mc(v_c_218, "strokeText", [v_t_235, 195.0, J.mul(v_H_219, 0.3)])
		J.mc(v_c_218, "fillText", [v_t_235, 195.0, J.mul(v_H_219, 0.3)])
		J.mc(v_c_218, "restore", [])

func _f47(this_, a: Array, env):
	var _s79 = {"__p": env, "G": null, "T": null, "HOPS": null, "PX": null, "avg": null, "tapHop": null, "takeoff": null}
	_s79["G"] = J.arg(a, 0)
	_s79["T"] = 0.56
	_s79["HOPS"] = 6.0
	_s79["PX"] = 30.0
	J.S_Object_("assign", [_s79["G"], {"x": 40.0, "hop": 0.0, "hopT": 0.0, "acc": [], "speed": 0.6, "line": 0.0, "fly": null, "tapped": {}, "lineX": 0.0, "cam": 0.0}])
	var _t206 = _s79["G"]
	var _t207 = ((40.0 + J.mul(_s79["HOPS"], 48.0)) + 40.0)
	J.sp(_t206, "lineX", _t207)
	var _t208 = _s79["G"]
	var _t209 = Callable(self, "_f48").bind(_s79)
	J.sp(_t208, "hud", _t209)
	_s79["avg"] = Callable(self, "_f49").bind(_s79)
	_s79["tapHop"] = Callable(self, "_f51").bind(_s79)
	_s79["takeoff"] = Callable(self, "_f52").bind(_s79)
	var _t226 = _s79["__p"]["btns"]
	J.cl(_t226, null, [[["跳", Callable(self, "_f53").bind(_s79)]]])
	var _t227 = _s79["G"]
	var _t228 = Callable(self, "_f54").bind(_s79)
	J.sp(_t227, "down", _t228)
	var _t229 = _s79["G"]
	var _t259 = Callable(self, "_f55").bind(_s79)
	J.sp(_t229, "tick", _t259)
	var _t260 = _s79["G"]
	var _t279 = Callable(self, "_f56").bind(_s79)
	J.sp(_t260, "draw", _t279)

func _f58(this_, a: Array, env):
	return ("剩 " + J.str(J.max_([0.0, ceil(J.num(J.gp(env["G"], "time")))])) + " 秒")

func _f59(this_, a: Array, env):
	if J.t(J.gp(env["G"], "done")):
		return null
	if J.cmp(J.gp(env["G"], "taut"), 0.0, ">"):
		var _t284 = env["G"]
		var _t285 = J.sub(J.gp(_t284, "p"), 0.07)
		J.sp(_t284, "p", _t285)
		var _t286 = env["G"]
		J.sp(_t286, "slip", 0.5)
		var _t287 = env["__p"]["pop"]
		J.cl(_t287, null, ["舌頭打滑！", 120.0, J.mul(J.gp(env["G"], "H"), 0.42), "#ff8080", 16.0])
		return null
	var _t288 = env["G"]
	var _t289 = J.add(J.gp(_t288, "p"), J.mul(0.032, J.gp(env["G"], "gpf")))
	J.sp(_t288, "p", _t289)
	if (randf() < 0.25):
		var _t290 = env["__p"]["pop"]
		J.cl(_t290, null, ["拉！", (90.0 + (randf() * 40.0)), J.mul(J.gp(env["G"], "H"), 0.46), "#ffe8a0", 14.0])

func _f60(this_, a: Array, env):
	if J.seq(J.gp(env["G"], "phase"), "play"):
		J.cl(env["pull"], null, [])

func _f61(this_, a: Array, env):
	var v_dt_238 = null; var v_surge_239 = null
	v_dt_238 = J.arg(a, 0)
	if J.t(J.gp(env["G"], "done")):
		return null
	var _t295 = env["G"]
	var _t296 = J.sub(J.gp(_t295, "time"), v_dt_238)
	J.sp(_t295, "time", _t296)
	var _t297 = env["G"]
	var _t298 = J.max_([0.0, J.sub(J.gp(env["G"], "slip"), v_dt_238)])
	J.sp(_t297, "slip", _t298)
	v_surge_239 = (0.22 if (sin(J.num(J.mul(J.gp(env["G"], "t"), 1.3))) > 0.85) else 0.0)
	var _t299 = env["G"]
	var _t300 = J.sub(J.gp(_t299, "p"), J.mul(v_dt_238, J.add(J.add(J.gp(env["G"], "ai"), v_surge_239), (J.max_([0.0, J.sub(J.gp(env["G"], "t"), 8.0)]) * 0.004))))
	J.sp(_t299, "p", _t300)
	var _t301 = env["G"]
	var _t302 = J.sub(J.gp(_t301, "tautT"), v_dt_238)
	J.sp(_t301, "tautT", _t302)
	if J.cmp(J.gp(env["G"], "tautT"), 0.0, "<="):
		var _t303 = env["G"]
		J.sp(_t303, "taut", 0.85)
		var _t304 = env["G"]
		var _t305 = (1.8 + (randf() * 1.8))
		J.sp(_t304, "tautT", _t305)
	if J.cmp(J.gp(env["G"], "taut"), 0.0, ">"):
		var _t306 = env["G"]
		var _t307 = J.sub(J.gp(_t306, "taut"), v_dt_238)
		J.sp(_t306, "taut", _t307)
	if J.cmp(J.gp(env["G"], "p"), 1.0, ">="):
		var _t308 = env["__p"]["finish"]
		var _t309 = env["__p"]["D"]
		J.cl(_t308, null, [1.0, J.cl(_t309, null, ["轆轤首條頸拉到打咗個結。佢話下年再嚟。", "轆轤首的脖子被拉到打了個結。她說明年再來。"])])
	else:
		if J.cmp(J.gp(env["G"], "p"), (-1.0), "<="):
			var _t310 = env["__p"]["finish"]
			var _t311 = env["__p"]["D"]
			J.cl(_t310, null, [0.0, J.cl(_t311, null, ["條脷被拉咗過對面，要行過去執返。", "舌頭被拉到對面，要走過去撿回來。"])])
		else:
			if J.cmp(J.gp(env["G"], "time"), 0.0, "<="):
				var _t312 = env["__p"]["finish"]
				var _t316 = (1.0 if J.cmp(J.gp(env["G"], "p"), 0.0, ">") else 0.0)
				var _t315 = null
				if J.cmp(J.gp(env["G"], "p"), 0.0, ">"):
					var _t313 = env["__p"]["D"]
					_t315 = J.cl(_t313, null, ["夠鐘，面旗喺你嗰邊。險勝。", "時間到，旗子在你這邊。險勝。"])
				else:
					var _t314 = env["__p"]["D"]
					_t315 = J.cl(_t314, null, ["夠鐘，面旗喺對面。差少少。", "時間到，旗子在對面。差一點。"])
				J.cl(_t312, null, [_t316, _t315])

func _f62(this_, a: Array, env):
	var v_c_240 = null; var v_H_241 = null; var v_gy_242 = null; var v_cx_243 = null; var v_ry_244 = null; var v_LH_245 = null; var v_RH_246 = null; var v_ropeCol_247 = null; var v_tx_248 = null
	v_c_240 = J.arg(a, 0)
	v_H_241 = J.arg(a, 1)
	v_gy_242 = J.mul(v_H_241, 0.68)
	v_cx_243 = (195.0 + J.mul(J.gp(env["G"], "p"), 100.0))
	v_ry_244 = J.sub(v_gy_242, 66.0)
	var _t319 = (not J.seq(J.typeof_(J.G.get("CHAR_H")), "undefined"))
	var _t320 = (J.gp(J.G.get("CHAR_H"), J.gp(J.gp(env["G"], "a"), "k")) if _t319 else _t319)
	v_LH_245 = J.mul((_t320 if J.t(_t320) else 56.0), 1.6)
	var _t321 = (not J.seq(J.typeof_(J.G.get("CHAR_H")), "undefined"))
	var _t322 = (J.gp(J.G.get("CHAR_H"), J.gp(J.gp(env["G"], "E"), "foe")) if _t321 else _t321)
	v_RH_246 = J.mul((_t322 if J.t(_t322) else 56.0), 1.6)
	J.sp(v_c_240, "fillStyle", "rgba(255,255,255,.75)")
	J.mc(v_c_240, "fillRect", [94.0, J.sub(v_ry_244, 24.0), 3.0, 40.0])
	J.mc(v_c_240, "fillRect", [293.0, J.sub(v_ry_244, 24.0), 3.0, 40.0])
	J.sp(v_c_240, "fillStyle", "rgba(255,255,255,.3)")
	J.mc(v_c_240, "fillRect", [194.0, J.sub(v_ry_244, 18.0), 2.0, 34.0])
	v_ropeCol_247 = ("#ff4040" if J.cmp(J.gp(env["G"], "taut"), 0.0, ">") else ("#c0392b" if J.seq(J.gp(J.gp(env["G"], "a"), "k"), "afu") else "#d86a7a"))
	J.sp(v_c_240, "strokeStyle", v_ropeCol_247)
	var _t323 = (6.0 if J.cmp(J.gp(env["G"], "taut"), 0.0, ">") else 5.0)
	J.sp(v_c_240, "lineWidth", _t323)
	J.mc(v_c_240, "beginPath", [])
	J.mc(v_c_240, "moveTo", [70.0, J.sub(v_gy_242, J.mul(v_LH_245, 0.62))])
	J.mc(v_c_240, "quadraticCurveTo", [J.sub(v_cx_243, 50.0), J.add(J.add(v_ry_244, 8.0), (sin(J.num(J.mul(J.gp(env["G"], "t"), 9.0))) * (1.0 if J.cmp(J.gp(env["G"], "taut"), 0.0, ">") else 4.0))), v_cx_243, v_ry_244])
	J.mc(v_c_240, "stroke", [])
	J.sp(v_c_240, "strokeStyle", "#e8dcc8")
	J.sp(v_c_240, "lineWidth", 7.0)
	J.mc(v_c_240, "beginPath", [])
	J.mc(v_c_240, "moveTo", [v_cx_243, v_ry_244])
	J.mc(v_c_240, "quadraticCurveTo", [J.add(v_cx_243, 60.0), J.sub(v_ry_244, 4.0), 326.0, J.sub(v_gy_242, J.mul(v_RH_246, 0.82))])
	J.mc(v_c_240, "stroke", [])
	J.sp(v_c_240, "fillStyle", "#ffd84a")
	J.mc(v_c_240, "beginPath", [])
	J.mc(v_c_240, "moveTo", [v_cx_243, v_ry_244])
	J.mc(v_c_240, "lineTo", [v_cx_243, J.sub(v_ry_244, 32.0)])
	J.mc(v_c_240, "lineTo", [J.add(v_cx_243, 20.0), J.sub(v_ry_244, 24.0)])
	J.mc(v_c_240, "lineTo", [v_cx_243, J.sub(v_ry_244, 16.0)])
	J.mc(v_c_240, "fill", [])
	J.sp(v_c_240, "fillStyle", "#5a3a1a")
	J.mc(v_c_240, "fillRect", [J.sub(v_cx_243, 1.0), J.sub(v_ry_244, 32.0), 2.0, 32.0])
	var _t324 = env["__p"]["char"]
	J.cl(_t324, null, [v_c_240, J.gp(J.gp(env["G"], "a"), "k"), 58.0, v_gy_242, 1.6, {"pose": ("hurt" if J.cmp(J.gp(env["G"], "slip"), 0.0, ">") else null), "pt": 0.5, "shadow": false, "rot": ((-0.15) - (0.0 if J.cmp(J.gp(env["G"], "taut"), 0.0, ">") else 0.05))}])
	var _t325 = env["__p"]["char"]
	J.cl(_t325, null, [v_c_240, J.gp(J.gp(env["G"], "E"), "foe"), 338.0, v_gy_242, 1.6, {"flip": true, "shadow": false, "rot": 0.15}])
	if J.cmp(J.gp(env["G"], "taut"), 0.0, ">"):
		J.mc(v_c_240, "save", [])
		J.sp(v_c_240, "font", "bold 20px sans-serif")
		J.sp(v_c_240, "textAlign", "center")
		J.sp(v_c_240, "fillStyle", "#ff6060")
		J.sp(v_c_240, "lineWidth", 4.0)
		J.sp(v_c_240, "strokeStyle", "#000")
		var _t326 = env["__p"]["Lx"]
		v_tx_248 = J.cl(_t326, null, [env["__p"]["TAUT"]])
		J.mc(v_c_240, "strokeText", [v_tx_248, 195.0, J.mul(v_H_241, 0.3)])
		J.mc(v_c_240, "fillText", [v_tx_248, 195.0, J.mul(v_H_241, 0.3)])
		J.mc(v_c_240, "restore", [])

func _f57(this_, a: Array, env):
	var _s105 = {"__p": env, "G": null, "pull": null}
	_s105["G"] = J.arg(a, 0)
	J.S_Object_("assign", [_s105["G"], {"p": 0.0, "ai": 0.12, "taut": 0.0, "tautT": 2.2, "time": 30.0, "slip": 0.0}])
	var _t282 = _s105["G"]
	var _t283 = Callable(self, "_f58").bind(_s105)
	J.sp(_t282, "hud", _t283)
	_s105["pull"] = Callable(self, "_f59").bind(_s105)
	var _t291 = _s105["__p"]["btns"]
	J.cl(_t291, null, [[["拉", _s105["pull"]]]])
	var _t292 = _s105["G"]
	var _t293 = Callable(self, "_f60").bind(_s105)
	J.sp(_t292, "down", _t293)
	var _t294 = _s105["G"]
	var _t317 = Callable(self, "_f61").bind(_s105)
	J.sp(_t294, "tick", _t317)
	var _t318 = _s105["G"]
	var _t327 = Callable(self, "_f62").bind(_s105)
	J.sp(_t318, "draw", _t327)

func _f64(this_, a: Array, env):
	return (J.str(floor(J.num(J.gp(env["G"], "time")))) + " 秒")

func _f65(this_, a: Array, env):
	var v_p_250 = null
	v_p_250 = J.arg(a, 0)
	var _t337 = (not J.seq(J.gp(env["G"], "phase"), "play"))
	if J.t((_t337 if _t337 else J.gp(env["G"], "fall"))):
		return null
	var _t338 = env["G"]
	J.sp(_t338, "hold", true)
	var _t339 = env["G"]
	var _t340 = J.gp(v_p_250, "x")
	J.sp(_t339, "fx0", _t340)
	var _t341 = env["G"]
	J.sp(_t341, "dx", 0.0)

func _f66(this_, a: Array, env):
	var v_p_251 = null
	v_p_251 = J.arg(a, 0)
	var _t344 = J.gp(env["G"], "hold")
	if J.t(((not J.leq(J.gp(env["G"], "fx0"), null)) if J.t(_t344) else _t344)):
		var _t345 = env["G"]
		var _t346 = J.div(J.sub(J.gp(v_p_251, "x"), J.gp(env["G"], "fx0")), 90.0)
		J.sp(_t345, "dx", _t346)

func _f67(this_, a: Array, env):
	var _t349 = J.gp(env["G"], "hold")
	var _t350 = ((not J.t(J.gp(env["G"], "done"))) if J.t(_t349) else _t349)
	var _t351 = ((not J.t(J.gp(env["G"], "fall"))) if J.t(_t350) else _t350)
	if J.t((J.cmp(J.gp(env["G"], "time"), 0.3, ">") if J.t(_t351) else _t351)):
		var _t352 = env["G"]
		var _t353 = {"t": 0.0}
		J.sp(_t352, "fall", _t353)
		var _t354 = env["__p"]["say"]
		J.cl(_t354, null, ["放手了！", 1.4])
	var _t355 = env["G"]
	J.sp(_t355, "hold", false)

func _f68(this_, a: Array, env):
	var v_dt_252 = null; var v_lv_253 = null; var v_f_254 = null
	v_dt_252 = J.arg(a, 0)
	if J.t(J.gp(env["G"], "fall")):
		var _t358 = J.gp(env["G"], "fall")
		var _t359 = J.add(J.gp(_t358, "t"), v_dt_252)
		J.sp(_t358, "t", _t359)
		var _t360 = J.cmp(J.gp(J.gp(env["G"], "fall"), "t"), 1.0, ">")
		if ((not J.t(J.gp(env["G"], "done"))) if _t360 else _t360):
			var _t361 = env["__p"]["finish"]
			var _t362 = J.gp(env["G"], "time")
			var _t368 = J.num(J.mc(_t362, "toFixed", [1.0]))
			var _t364 = J.gp(env["G"], "time")
			var _t363 = env["__p"]["target"]
			var _t367 = null
			if J.cmp(_t364, J.cl(_t363, null, ["hang"]), ">"):
				var _t365 = env["__p"]["D"]
				_t367 = J.cl(_t365, null, ["跌落嚟嗰陣，啱啱壓住 Bryan 塊紀錄牌。", "掉下來的時候，剛好壓住 Bryan 的紀錄牌。"])
			else:
				var _t366 = env["__p"]["D"]
				_t367 = J.cl(_t366, null, ["落地。清潔安娣：「又係你，日日都跌落嚟。」", "落地。清潔安娣：「又是你，每天都掉下來。」"])
			J.cl(_t361, null, [_t368, _t367])
		return null
	if (not J.t(J.gp(env["G"], "hold"))):
		return null
	var _t369 = env["G"]
	var _t370 = J.add(J.gp(_t369, "time"), v_dt_252)
	J.sp(_t369, "time", _t370)
	v_lv_253 = (1.0 + J.div(J.gp(env["G"], "time"), 20.0))
	var _t371 = env["G"]
	var _t372 = J.sub(J.gp(_t371, "evT"), v_dt_252)
	J.sp(_t371, "evT", _t372)
	if J.cmp(J.gp(env["G"], "evT"), 0.0, "<="):
		var _t373 = env["G"]
		var _t374 = {"k": ("fan" if (randf() < 0.5) else "broom"), "t": 0.0, "dir": ((-1.0) if (randf() < 0.5) else 1.0)}
		J.sp(_t373, "ev", _t374)
		var _t375 = env["G"]
		var _t376 = (3.0 + J.div((randf() * 3.0), v_lv_253))
		J.sp(_t375, "evT", _t376)
		var _t377 = env["__p"]["pop"]
		J.cl(_t377, null, [("風扇開了！" if J.seq(J.gp(J.gp(env["G"], "ev"), "k"), "fan") else "安娣的掃把！"), 195.0, J.mul(J.gp(env["G"], "H"), 0.62), "#ffe8a0", 16.0])
	v_f_254 = (J.mul((sin(J.num(J.mul(J.gp(env["G"], "t"), 1.7))) * 0.35), v_lv_253) + J.mul((sin(J.num((J.mul(J.gp(env["G"], "t"), 0.63) + 1.0))) * 0.25), v_lv_253))
	if J.t(J.gp(env["G"], "ev")):
		var _t378 = J.gp(env["G"], "ev")
		var _t379 = J.add(J.gp(_t378, "t"), v_dt_252)
		J.sp(_t378, "t", _t379)
		var _t380 = J.add(v_f_254, (J.mul(J.mul(J.gp(J.gp(env["G"], "ev"), "dir"), (1.1 if J.seq(J.gp(J.gp(env["G"], "ev"), "k"), "fan") else 2.2)), v_lv_253) * (J.max_([0.0, (1.0 - (absf(J.num(J.sub(J.gp(J.gp(env["G"], "ev"), "t"), 0.4))) * 3.0))]) if J.seq(J.gp(J.gp(env["G"], "ev"), "k"), "broom") else 1.0)))
		v_f_254 = _t380
		if J.cmp(J.gp(J.gp(env["G"], "ev"), "t"), (1.8 if J.seq(J.gp(J.gp(env["G"], "ev"), "k"), "fan") else 0.9), ">"):
			var _t381 = env["G"]
			J.sp(_t381, "ev", null)
	var _t382 = env["G"]
	var _t383 = J.add(J.gp(_t382, "v"), J.mul((J.sub(v_f_254, J.mul(J.gp(env["G"], "dx"), 2.6)) - J.mul(J.gp(env["G"], "sw"), 0.6)), v_dt_252))
	J.sp(_t382, "v", _t383)
	var _t384 = env["G"]
	var _t385 = J.mul(J.gp(_t384, "v"), 0.985)
	J.sp(_t384, "v", _t385)
	var _t386 = env["G"]
	var _t387 = J.add(J.gp(_t386, "sw"), (J.mul(J.gp(env["G"], "v"), v_dt_252) * 1.6))
	J.sp(_t386, "sw", _t387)
	if (absf(J.num(J.gp(env["G"], "sw"))) > 1.0):
		var _t388 = env["G"]
		var _t389 = {"t": 0.0}
		J.sp(_t388, "fall", _t389)
		var _t390 = env["__p"]["say"]
		J.cl(_t390, null, ["甩下來了！", 1.4])

func _f69(this_, a: Array, env):
	var v_c_255 = null; var v_H_256 = null; var v_cy_257 = null; var v_ang_258 = null; var v_fy_259 = null; var v_x_260 = null; var v_i_261 = null; var v_x_262 = null
	v_c_255 = J.arg(a, 0)
	v_H_256 = J.arg(a, 1)
	v_cy_257 = J.mul(v_H_256, 0.18)
	J.sp(v_c_255, "fillStyle", "rgba(60,50,70,.9)")
	J.mc(v_c_255, "fillRect", [0.0, 0.0, 390.0, v_cy_257])
	J.sp(v_c_255, "fillStyle", "rgba(255,255,255,.08)")
	v_x_260 = 0.0
	while true:
		if not J.cmp(v_x_260, 390.0, "<"): break
		J.mc(v_c_255, "fillRect", [v_x_260, J.sub(v_cy_257, 2.0), 46.0, 2.0])
		var _t393 = J.add(v_x_260, 48.0)
		v_x_260 = _t393
	J.sp(v_c_255, "fillStyle", "rgba(0,0,0,.5)")
	J.mc(v_c_255, "fillRect", [95.0, J.mul(v_H_256, 0.84), 200.0, 10.0])
	J.sp(v_c_255, "fillStyle", "rgba(120,220,120,.6)")
	J.mc(v_c_255, "fillRect", [165.0, J.mul(v_H_256, 0.84), 60.0, 10.0])
	var _t394 = ("#ff5050" if (absf(J.num(J.gp(env["G"], "sw"))) > 0.7) else "#ffd84a")
	J.sp(v_c_255, "fillStyle", _t394)
	J.mc(v_c_255, "fillRect", [((195.0 + J.mul(J.gp(env["G"], "sw"), 100.0)) - 3.0), (J.mul(v_H_256, 0.84) - 4.0), 6.0, 18.0])
	v_ang_258 = J.mul(J.gp(env["G"], "sw"), 0.6)
	v_fy_259 = (J.min_([J.mul(v_H_256, 0.72), J.add(v_cy_257, (J.mul(J.gp(J.gp(env["G"], "fall"), "t"), J.gp(J.gp(env["G"], "fall"), "t")) * 900.0))]) if J.t(J.gp(env["G"], "fall")) else v_cy_257)
	J.mc(v_c_255, "save", [])
	J.mc(v_c_255, "translate", [195.0, v_fy_259])
	J.mc(v_c_255, "rotate", [J.add(PI, v_ang_258)])
	var _t395 = env["__p"]["char"]
	J.cl(_t395, null, [v_c_255, J.gp(J.gp(env["G"], "a"), "k"), 0.0, 0.0, 2.0, {"shadow": false, "pose": ("hurt" if J.t(J.gp(env["G"], "fall")) else null), "pt": 0.5}])
	J.mc(v_c_255, "restore", [])
	var _t396 = (not J.t(J.gp(env["G"], "hold")))
	var _t397 = ((not J.t(J.gp(env["G"], "fall"))) if _t396 else _t396)
	if (J.seq(J.gp(env["G"], "phase"), "play") if _t397 else _t397):
		J.mc(v_c_255, "save", [])
		J.sp(v_c_255, "font", "bold 18px sans-serif")
		J.sp(v_c_255, "textAlign", "center")
		J.sp(v_c_255, "fillStyle", "#fff")
		J.mc(v_c_255, "fillText", ["按住畫面抓實天花板", 195.0, J.mul(v_H_256, 0.55)])
		J.mc(v_c_255, "restore", [])
	var _t398 = J.gp(env["G"], "ev")
	if J.t((J.seq(J.gp(J.gp(env["G"], "ev"), "k"), "fan") if J.t(_t398) else _t398)):
		J.mc(v_c_255, "save", [])
		J.mc(v_c_255, "translate", [(370.0 if J.cmp(J.gp(J.gp(env["G"], "ev"), "dir"), 0.0, "<") else 20.0), J.mul(v_H_256, 0.4)])
		J.mc(v_c_255, "rotate", [J.mul(J.gp(env["G"], "t"), 20.0)])
		J.sp(v_c_255, "strokeStyle", "rgba(255,255,255,.6)")
		J.sp(v_c_255, "lineWidth", 4.0)
		v_i_261 = 0.0
		while true:
			if not J.cmp(v_i_261, 3.0, "<"): break
			J.mc(v_c_255, "rotate", [J.div((PI * 2.0), 3.0)])
			J.mc(v_c_255, "beginPath", [])
			J.mc(v_c_255, "moveTo", [0.0, 0.0])
			J.mc(v_c_255, "lineTo", [22.0, 0.0])
			J.mc(v_c_255, "stroke", [])
			v_i_261 = J.num(v_i_261) + 1.0
		J.mc(v_c_255, "restore", [])
	var _t399 = J.gp(env["G"], "ev")
	if J.t((J.seq(J.gp(J.gp(env["G"], "ev"), "k"), "broom") if J.t(_t399) else _t399)):
		v_x_262 = (195.0 - J.mul(J.gp(J.gp(env["G"], "ev"), "dir"), (160.0 - J.mul(J.gp(J.gp(env["G"], "ev"), "t"), 300.0))))
		J.mc(v_c_255, "save", [])
		J.sp(v_c_255, "strokeStyle", "#8a6a3a")
		J.sp(v_c_255, "lineWidth", 5.0)
		J.mc(v_c_255, "beginPath", [])
		J.mc(v_c_255, "moveTo", [v_x_262, J.mul(v_H_256, 0.75)])
		J.mc(v_c_255, "lineTo", [J.add(v_x_262, J.mul(J.gp(J.gp(env["G"], "ev"), "dir"), 20.0)), J.mul(v_H_256, 0.32)])
		J.mc(v_c_255, "stroke", [])
		J.sp(v_c_255, "fillStyle", "#c8a860")
		J.mc(v_c_255, "fillRect", [J.sub(J.add(v_x_262, J.mul(J.gp(J.gp(env["G"], "ev"), "dir"), 20.0)), 14.0), J.mul(v_H_256, 0.28), 28.0, 10.0])
		J.mc(v_c_255, "restore", [])
	J.mc(v_c_255, "save", [])
	J.sp(v_c_255, "font", "12px sans-serif")
	J.sp(v_c_255, "textAlign", "right")
	J.sp(v_c_255, "fillStyle", "#ffd0c0")
	var _t400 = env["__p"]["target"]
	J.mc(v_c_255, "fillText", [("Bryan：" + J.str(J.cl(_t400, null, ["hang"])) + " 秒"), 380.0, J.mul(v_H_256, 0.82)])
	J.mc(v_c_255, "restore", [])

func _f63(this_, a: Array, env):
	var _s114 = {"__p": env, "G": null}
	_s114["G"] = J.arg(a, 0)
	J.S_Object_("assign", [_s114["G"], {"hold": false, "sw": 0.0, "v": 0.0, "fx0": null, "time": 0.0, "push": 0.0, "evT": 4.0, "ev": null, "fall": null}])
	var _t330 = _s114["G"]
	var _t331 = Callable(self, "_f64").bind(_s114)
	J.sp(_t330, "hud", _t331)
	var _t332 = _s114["__p"]["btns"]
	J.cl(_t332, null, [[]])
	var _t333 = J.G.get("$")
	var _t334 = J.cl(_t333, null, ["#sp-btns"])
	var _t335 = "<p class=\"sp-tip\">按住畫面開始，左右拖動保持平衡</p>"
	J.sp(_t334, "innerHTML", _t335)
	var _t336 = _s114["G"]
	var _t342 = Callable(self, "_f65").bind(_s114)
	J.sp(_t336, "down", _t342)
	var _t343 = _s114["G"]
	var _t347 = Callable(self, "_f66").bind(_s114)
	J.sp(_t343, "move", _t347)
	var _t348 = _s114["G"]
	var _t356 = Callable(self, "_f67").bind(_s114)
	J.sp(_t348, "up", _t356)
	var _t357 = _s114["G"]
	var _t391 = Callable(self, "_f68").bind(_s114)
	J.sp(_t357, "tick", _t391)
	var _t392 = _s114["G"]
	var _t401 = Callable(self, "_f69").bind(_s114)
	J.sp(_t392, "draw", _t401)

func _f71(this_, a: Array, env):
	var _t406 = J.min_([50.0, floor(J.num(J.gp(env["G"], "dist")))])
	var _t405 = J.gp(env["G"], "time")
	return (J.str(_t406) + "／50 米　" + J.str(J.mc(_t405, "toFixed", [1.0])) + " 秒")

func _f72(this_, a: Array, env):
	var v_side_265 = null; var v_gap_266 = null; var v_same_267 = null; var v_power_268 = null; var v_kick_269 = null
	v_side_265 = J.arg(a, 0)
	if J.t(J.gp(env["G"], "finished")):
		return null
	v_gap_266 = J.sub(J.gp(env["G"], "t"), J.gp(env["G"], "lastT"))
	var _t408 = env["G"]
	var _t409 = J.gp(env["G"], "t")
	J.sp(_t408, "lastT", _t409)
	v_same_267 = J.seq(v_side_265, J.gp(env["G"], "lastSide"))
	var _t410 = env["G"]
	J.sp(_t410, "lastSide", v_side_265)
	var _t411 = env["G"]
	J.sp(_t411, "stroke", 0.35)
	v_power_268 = (1.0 if J.cmp(J.gp(env["G"], "water"), 0.25, ">") else 0.45)
	var _t412 = env["G"]
	var _t413 = J.add(J.gp(_t412, "vel"), J.mul((J.mul((0.5 if J.t(v_same_267) else 2.1), v_power_268) * (0.6 if J.cmp(v_gap_266, 0.22, "<") else 1.0)), J.gp(env["G"], "gpf")))
	J.sp(_t412, "vel", _t413)
	v_kick_269 = (0.9 if J.t(v_same_267) else 0.35)
	if J.cmp(v_gap_266, 0.22, "<"):
		var _t414 = J.add(v_kick_269, 0.6)
		v_kick_269 = _t414
	var _t415 = env["G"]
	var _t416 = J.add(J.gp(_t415, "sv"), J.mul(v_side_265, v_kick_269))
	J.sp(_t415, "sv", _t416)
	if J.t(v_same_267):
		var _t417 = env["__p"]["pop"]
		J.cl(_t417, null, ["同一邊！", (195.0 + J.mul(v_side_265, 70.0)), J.mul(J.gp(env["G"], "H"), 0.38), "#ffb0a0", 14.0])

func _f73(this_, a: Array, env):
	var _t419 = env["stroke"]
	return J.cl(_t419, null, [(-1.0)])

func _f74(this_, a: Array, env):
	var _t420 = env["stroke"]
	return J.cl(_t420, null, [1.0])

func _f75(this_, a: Array, env):
	var v_dt_270 = null; var v_loss_271 = null
	v_dt_270 = J.arg(a, 0)
	if J.t(J.gp(env["G"], "finished")):
		return null
	var _t424 = env["G"]
	var _t425 = J.add(J.gp(_t424, "time"), v_dt_270)
	J.sp(_t424, "time", _t425)
	var _t426 = env["G"]
	var _t427 = J.max_([0.0, J.sub(J.gp(env["G"], "stroke"), v_dt_270)])
	J.sp(_t426, "stroke", _t427)
	var _t428 = env["G"]
	var _t429 = J.mul(J.gp(_t428, "vel"), pow(J.num(0.35), J.num(v_dt_270)))
	J.sp(_t428, "vel", _t429)
	var _t430 = env["G"]
	var _t431 = J.add(J.gp(_t430, "dist"), (J.mul(J.gp(env["G"], "vel"), v_dt_270) * 0.5))
	J.sp(_t430, "dist", _t431)
	var _t432 = env["G"]
	var _t433 = J.add(J.gp(_t432, "sv"), J.mul(((-J.num(J.gp(env["G"], "slosh"))) * 14.0), v_dt_270))
	J.sp(_t432, "sv", _t433)
	var _t434 = env["G"]
	var _t435 = J.mul(J.gp(_t434, "sv"), pow(J.num(0.4), J.num(v_dt_270)))
	J.sp(_t434, "sv", _t435)
	var _t436 = env["G"]
	var _t437 = J.add(J.gp(_t436, "slosh"), (J.mul(J.gp(env["G"], "sv"), v_dt_270) * 3.0))
	J.sp(_t436, "slosh", _t437)
	if (absf(J.num(J.gp(env["G"], "slosh"))) > 0.55):
		v_loss_271 = (J.mul((absf(J.num(J.gp(env["G"], "slosh"))) - 0.55), v_dt_270) * 0.9)
		var _t438 = env["G"]
		var _t439 = J.max_([0.0, J.sub(J.gp(env["G"], "water"), v_loss_271)])
		J.sp(_t438, "water", _t439)
		if (randf() < J.mul(v_dt_270, 6.0)):
			var _t440 = env["__p"]["pop"]
			J.cl(_t440, null, ["水灑了！", 195.0, J.mul(J.gp(env["G"], "H"), 0.33), "#9fd8ff", 13.0])
	if J.cmp(J.gp(env["G"], "dist"), 50.0, ">="):
		var _t441 = env["G"]
		J.sp(_t441, "finished", true)
		var _t442 = env["__p"]["finish"]
		var _t443 = J.gp(env["G"], "time")
		var _t449 = J.num(J.mc(_t443, "toFixed", [1.0]))
		var _t448 = null
		if J.cmp(J.gp(env["G"], "water"), 0.6, ">"):
			var _t444 = env["__p"]["D"]
			_t448 = J.cl(_t444, null, ["游完，頭頂碟水仲有大半。河童協會頒發「穩陣獎」。", "游完，頭頂碟水還有大半。河童協會頒發「穩健獎」。"])
		else:
			var _t447 = null
			if J.cmp(J.gp(env["G"], "water"), 0.25, ">"):
				var _t445 = env["__p"]["D"]
				_t447 = J.cl(_t445, null, ["游完，碟水剩返一半，個頭有啲暈。", "游完了，碟裡的水剩一半，頭有點暈。"])
			else:
				var _t446 = env["__p"]["D"]
				_t447 = J.cl(_t446, null, ["碟水乾晒，最後幾米係爬上岸。", "碟水全乾了，最後幾米是爬上岸的。"])
			_t448 = _t447
		J.cl(_t442, null, [_t449, _t448])
	var _t450 = J.cmp(J.gp(env["G"], "time"), 60.0, ">")
	if ((not J.t(J.gp(env["G"], "finished"))) if _t450 else _t450):
		var _t451 = env["G"]
		J.sp(_t451, "finished", true)
		var _t452 = env["__p"]["finish"]
		var _t453 = env["__p"]["D"]
		J.cl(_t452, null, [null, J.cl(_t453, null, ["一分鐘都未游完。救生員（一隻水鬼）將你撈咗上岸。", "一分鐘都沒游完。救生員（一隻水鬼）把你撈上岸。"])])

func _f76(this_, a: Array, env):
	var v_c_272 = null; var v_H_273 = null; var v_top_274 = null; var v_bot_275 = null; var v_off_276 = null; var v_bd_277 = null; var v_bx_278 = null; var v_y_279 = null; var v_lean_280 = null; var v_SC_281 = null; var v_HH_282 = null; var v_fx_283 = null; var v_i_284 = null; var v_y_285 = null; var v_x_286 = null; var v_x_287 = null; var v_q_288 = null
	v_c_272 = J.arg(a, 0)
	v_H_273 = J.arg(a, 1)
	v_top_274 = J.mul(v_H_273, 0.4)
	v_bot_275 = J.mul(v_H_273, 0.78)
	J.sp(v_c_272, "fillStyle", "rgba(40,90,120,.75)")
	J.mc(v_c_272, "fillRect", [0.0, v_top_274, 390.0, J.sub(v_bot_275, v_top_274)])
	v_i_284 = 0.0
	while true:
		if not J.cmp(v_i_284, 6.0, "<"): break
		J.sp(v_c_272, "strokeStyle", "rgba(255,255,255,.12)")
		J.mc(v_c_272, "beginPath", [])
		v_y_285 = J.add(J.add(v_top_274, 12.0), J.div(J.mul(v_i_284, J.sub(v_bot_275, v_top_274)), 6.0))
		v_x_286 = 0.0
		while true:
			if not J.cmp(v_x_286, 390.0, "<="): break
			J.mc(v_c_272, "lineTo", [v_x_286, J.add(v_y_285, (sin(J.num(J.add((J.mul(v_x_286, 0.05) + J.mul(J.gp(env["G"], "t"), 2.0)), v_i_284))) * 2.0))])
			var _t456 = J.add(v_x_286, 12.0)
			v_x_286 = _t456
		J.mc(v_c_272, "stroke", [])
		v_i_284 = J.num(v_i_284) + 1.0
	v_off_276 = J.mod(J.mul(J.gp(env["G"], "dist"), 24.0), 48.0)
	J.sp(v_c_272, "fillStyle", "#e05050")
	v_x_287 = (-J.num(v_off_276))
	while true:
		if not J.cmp(v_x_287, 400.0, "<"): break
		J.mc(v_c_272, "beginPath", [])
		J.mc(v_c_272, "arc", [v_x_287, J.add(v_top_274, 4.0), 4.0, 0.0, (PI * 2.0)])
		J.mc(v_c_272, "arc", [J.add(v_x_287, 24.0), J.sub(v_bot_275, 4.0), 4.0, 0.0, (PI * 2.0)])
		J.mc(v_c_272, "fill", [])
		var _t457 = J.add(v_x_287, 48.0)
		v_x_287 = _t457
	var _t459 = J.gp(env["G"], "time")
	var _t458 = env["__p"]["target"]
	var _t461 = J.gp(env["G"], "time")
	var _t460 = env["__p"]["target"]
	v_bd_277 = J.min_([50.0, (J.div(_t461, J.cl(_t460, null, ["swim"])) * 50.0)])
	v_bx_278 = (150.0 + (J.sub(v_bd_277, J.gp(env["G"], "dist")) * 24.0))
	var _t462 = J.cmp(v_bx_278, (-40.0), ">")
	if (J.cmp(v_bx_278, 430.0, "<") if _t462 else _t462):
		J.mc(v_c_272, "save", [])
		J.sp(v_c_272, "globalAlpha", 0.5)
		J.mc(v_c_272, "beginPath", [])
		J.mc(v_c_272, "rect", [0.0, 0.0, 390.0, J.add(v_top_274, 30.0)])
		J.mc(v_c_272, "clip", [])
		var _t463 = env["__p"]["bryan"]
		J.cl(_t463, null, [v_c_272, v_bx_278, J.add(v_top_274, 60.0), 96.0, "walk", {"faceRight": true}])
		J.mc(v_c_272, "restore", [])
		J.mc(v_c_272, "save", [])
		J.sp(v_c_272, "font", "bold 11px sans-serif")
		J.sp(v_c_272, "textAlign", "center")
		J.sp(v_c_272, "fillStyle", "#ffd0c0")
		J.mc(v_c_272, "fillText", ["Bryan", v_bx_278, J.sub(v_top_274, 46.0)])
		J.mc(v_c_272, "restore", [])
	v_y_279 = ((J.div(J.add(v_top_274, v_bot_275), 2.0) + 40.0) + (sin(J.num(J.mul(J.gp(env["G"], "t"), 7.0))) * (3.0 if J.cmp(J.gp(env["G"], "vel"), 0.5, ">") else 1.5)))
	v_lean_280 = J.min_([0.35, J.mul(J.gp(env["G"], "vel"), 0.05)])
	v_SC_281 = 1.5
	var _t464 = (not J.seq(J.typeof_(J.G.get("CHAR_H")), "undefined"))
	var _t465 = (J.gp(J.G.get("CHAR_H"), J.gp(J.gp(env["G"], "a"), "k")) if _t464 else _t464)
	v_HH_282 = ((J.mul((_t465 if J.t(_t465) else 56.0), v_SC_281) + J.mul(4.0, v_SC_281)) - 7.0)
	J.mc(v_c_272, "save", [])
	J.mc(v_c_272, "beginPath", [])
	J.mc(v_c_272, "rect", [0.0, 0.0, 390.0, J.sub(v_y_279, 22.0)])
	J.mc(v_c_272, "clip", [])
	J.mc(v_c_272, "save", [])
	J.mc(v_c_272, "translate", [150.0, v_y_279])
	J.mc(v_c_272, "rotate", [v_lean_280])
	var _t466 = env["__p"]["char"]
	J.cl(_t466, null, [v_c_272, J.gp(J.gp(env["G"], "a"), "k"), 0.0, 0.0, v_SC_281, {"shadow": false, "walk": J.cmp(J.gp(env["G"], "vel"), 0.5, ">")}])
	J.mc(v_c_272, "translate", [0.0, (-J.num(v_HH_282))])
	J.mc(v_c_272, "rotate", [J.mul(J.gp(env["G"], "slosh"), 0.6)])
	J.sp(v_c_272, "fillStyle", "#c8c0a8")
	J.sp(v_c_272, "strokeStyle", "rgba(0,0,0,.4)")
	J.sp(v_c_272, "lineWidth", 1.5)
	J.mc(v_c_272, "beginPath", [])
	J.mc(v_c_272, "ellipse", [0.0, 0.0, 22.0, 6.5, 0.0, 0.0, (PI * 2.0)])
	J.mc(v_c_272, "fill", [])
	J.mc(v_c_272, "stroke", [])
	if J.cmp(J.gp(env["G"], "water"), 0.0, ">"):
		J.sp(v_c_272, "fillStyle", "rgba(120,200,255,.9)")
		J.mc(v_c_272, "beginPath", [])
		J.mc(v_c_272, "ellipse", [J.mul(J.gp(env["G"], "slosh"), 6.0), (-1.5), (18.0 * sqrt(J.num(J.gp(env["G"], "water")))), (4.2 * sqrt(J.num(J.gp(env["G"], "water")))), 0.0, 0.0, (PI * 2.0)])
		J.mc(v_c_272, "fill", [])
	J.mc(v_c_272, "restore", [])
	J.mc(v_c_272, "restore", [])
	J.sp(v_c_272, "fillStyle", "rgba(40,90,120,.55)")
	J.mc(v_c_272, "fillRect", [0.0, J.sub(v_y_279, 22.0), 390.0, (J.sub(v_bot_275, v_y_279) + 22.0)])
	if J.cmp(J.gp(env["G"], "stroke"), 0.0, ">"):
		v_q_288 = (1.0 - J.div(J.gp(env["G"], "stroke"), 0.35))
		var _t467 = ("rgba(255,255,255," + J.str((0.7 * J.sub(1.0, v_q_288))) + ")")
		J.sp(v_c_272, "strokeStyle", _t467)
		J.sp(v_c_272, "lineWidth", 2.0)
		J.mc(v_c_272, "beginPath", [])
		J.mc(v_c_272, "ellipse", [(150.0 + J.mul(J.gp(env["G"], "lastSide"), 30.0)), J.sub(v_y_279, 20.0), (12.0 + J.mul(v_q_288, 22.0)), (4.0 + J.mul(v_q_288, 6.0)), 0.0, 0.0, (PI * 2.0)])
		J.mc(v_c_272, "stroke", [])
	J.sp(v_c_272, "fillStyle", "rgba(0,0,0,.5)")
	J.mc(v_c_272, "fillRect", [20.0, J.mul(v_H_273, 0.86), 120.0, 9.0])
	var _t468 = ("#7fd0ff" if J.cmp(J.gp(env["G"], "water"), 0.25, ">") else "#ff7070")
	J.sp(v_c_272, "fillStyle", _t468)
	J.mc(v_c_272, "fillRect", [20.0, J.mul(v_H_273, 0.86), J.mul(120.0, J.gp(env["G"], "water")), 9.0])
	J.sp(v_c_272, "fillStyle", "#fff")
	J.sp(v_c_272, "font", "11px sans-serif")
	J.sp(v_c_272, "textAlign", "left")
	J.mc(v_c_272, "fillText", ["頭頂碟水", 20.0, (J.mul(v_H_273, 0.86) - 4.0)])
	v_fx_283 = (150.0 + (J.sub(50.0, J.gp(env["G"], "dist")) * 24.0))
	if J.cmp(v_fx_283, 400.0, "<"):
		J.sp(v_c_272, "fillStyle", "#fff")
		J.mc(v_c_272, "fillRect", [v_fx_283, v_top_274, 4.0, J.sub(v_bot_275, v_top_274)])

func _f70(this_, a: Array, env):
	var _s133 = {"__p": env, "G": null, "stroke": null}
	_s133["G"] = J.arg(a, 0)
	J.S_Object_("assign", [_s133["G"], {"dist": 0.0, "vel": 0.0, "water": 1.0, "slosh": 0.0, "sv": 0.0, "lastSide": 0.0, "lastT": (-9.0), "time": 0.0, "finished": false, "stroke": 0.0}])
	var _t404 = _s133["G"]
	var _t407 = Callable(self, "_f71").bind(_s133)
	J.sp(_t404, "hud", _t407)
	_s133["stroke"] = Callable(self, "_f72").bind(_s133)
	var _t418 = _s133["__p"]["btns"]
	J.cl(_t418, null, [[["左划", Callable(self, "_f73").bind(_s133), ""], ["右划", Callable(self, "_f74").bind(_s133), ""]]])
	var _t421 = _s133["G"]
	var _t422 = _s133["stroke"]
	J.sp(_t421, "stroke_", _t422)
	var _t423 = _s133["G"]
	var _t454 = Callable(self, "_f75").bind(_s133)
	J.sp(_t423, "tick", _t454)
	var _t455 = _s133["G"]
	var _t469 = Callable(self, "_f76").bind(_s133)
	J.sp(_t455, "draw", _t469)

func _f78(this_, a: Array, env):
	var v_id_293 = null; var v_E_294 = null; var v_a_295 = null; var v_best_296 = null
	v_id_293 = J.arg(a, 0)
	v_E_294 = J.gp(env["__p"]["EV"], v_id_293)
	var _t471 = env["__p"]["athlete"]
	v_a_295 = J.cl(_t471, null, [v_id_293])
	v_best_296 = J.gp(J.gp(env["s"], "best"), v_id_293)
	var _t475 = J.gp(v_E_294, "name")
	var _t476 = J.gp(v_a_295, "k")
	var _t477 = J.gp(v_a_295, "name")
	var _t478 = (not (not J.t(J.gp(v_a_295, "sub"))))
	var _t474 = null
	if J.seq(v_id_293, "tug"):
		_t474 = ("對手：" + J.str((J.gp(J.gp(J.G.get("GHOSTS"), J.gp(v_E_294, "foe")), "name") if J.t(J.gp(J.G.get("GHOSTS"), J.gp(v_E_294, "foe"))) else "轆轤首")))
	else:
		var _t472 = env["__p"]["fmtV"]
		var _t473 = env["__p"]["target"]
		_t474 = ("Bryan 今日紀錄：" + J.str(J.cl(_t472, null, [v_id_293, J.cl(_t473, null, [v_id_293])])))
	var _t481 = null
	if (not J.leq(v_best_296, null)):
		var _t480 = null
		if J.seq(v_id_293, "tug"):
			_t480 = J.add(v_best_296, " 勝")
		else:
			var _t479 = env["__p"]["fmtV"]
			_t480 = J.cl(_t479, null, [v_id_293, v_best_296])
		_t481 = _t480
	else:
		_t481 = null
	return {"id": v_id_293, "name": _t475, "k": _t476, "who": _t477, "sub": _t478, "goal": _t474, "best": _t481, "won": J.seq(J.gp(J.gp(env["s"], "won"), v_id_293), env["today"])}

func _f77(this_, a: Array, env):
	var _s152 = {"__p": env, "s": null, "today": null}
	_s152["s"] = J.cl(_s152["__p"]["st"], null, [])
	_s152["today"] = J.cl(_s152["__p"]["gday"], null, [])
	return {"list": J.mc(_s152["__p"]["ORDER"], "map", [Callable(self, "_f78").bind(_s152)])}

func _f79(this_, a: Array, env):
	var v_id_299 = null
	v_id_299 = J.arg(a, 0)
	J.mc(J.G.get("UI"), "close", [])
	var _t482 = env["start"]
	J.cl(_t482, null, [v_id_299])

func _f80(this_, a: Array, env):
	return env["G"]

func _f1(this_, a: Array, env):
	var v__n_37 = null
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
	var _t196 = _s2["D"]
	var _t198 = J.cl(_t196, null, ["Bryan：「我籃球跳投出身，跳遠？小意思。」", "Bryan：「我打籃球跳投出身，跳遠？小意思。」"])
	var _t197 = _s2["D"]
	var _t200 = J.cl(_t197, null, ["轆轤首：「我條頸三米長，你有幾長？」", "轆轤首：「我的脖子三米長，你有多長？」"])
	var _t199 = _s2["D"]
	var _t202 = J.cl(_t199, null, ["Bryan：「倒掛？我喺公司掛名都掛咗三年。」", "Bryan：「倒掛？我在公司掛名都掛了三年。」"])
	var _t201 = _s2["D"]
	_s2["BRYAN"] = {"jump": _t198, "tug": _t200, "hang": _t202, "swim": J.cl(_t201, null, ["Bryan：「我游水唔使碟，因為我頭頂冇嘢。等陣，唔係咁講……」", "Bryan：「我游泳不用碟子，因為我頭上沒東西。等等，不是這樣說……」"])}
	_s2["has"] = Callable(self, "_f4").bind(_s2)
	_s2["Lx"] = Callable(self, "_f5").bind(_s2)
	_s2["fmtV"] = Callable(self, "_f15").bind(_s2)
	_s2["G"] = null
	_s2["INIT"] = {}
	var _t205 = _s2["INIT"]
	var _t280 = Callable(self, "_f47").bind(_s2)
	J.sp(_t205, "jump", _t280)
	var _t281 = _s2["INIT"]
	var _t328 = Callable(self, "_f57").bind(_s2)
	J.sp(_t281, "tug", _t328)
	var _t329 = _s2["INIT"]
	var _t402 = Callable(self, "_f63").bind(_s2)
	J.sp(_t329, "hang", _t402)
	var _t403 = _s2["INIT"]
	var _t470 = Callable(self, "_f70").bind(_s2)
	J.sp(_t403, "swim", _t470)
	v__n_37 = {"panel": Callable(self, "_f77").bind(_s2), "go": Callable(self, "_f79").bind(_s2)}
	return {"open": _s2["open"], "start": _s2["start"], "EV": _s2["EV"], "target": _s2["target"], "st": _s2["st"], "athlete": _s2["athlete"], "_n": v__n_37, "_g": Callable(self, "_f80").bind(_s2)}
