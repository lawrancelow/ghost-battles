# 自動轉譯自 bonds.js（tools/jsgd.js）——唔好直接改，改原 JS 再轉
extends RefCounted

func run(env):
	var this_ = null; var a = []
	J.G["Bonds"] = J.cl(Callable(self, "_f1").bind(env), null, [])
	J.cl(Callable(self, "_f79").bind(env), null, [])

func _f10(this_, a: Array, env):
	var v_g_52 = null
	v_g_52 = J.arg(a, 0)
	if J.t(J.gp(J.G.get("BOND_RECRUIT"), J.gp(v_g_52, "k"))):
		var _t6 = J.gp(J.gp(J.G.get("S"), "bonds"), "rec")
		var _t7 = J.gp(v_g_52, "k")
		J.sp(_t6, _t7, 1.0)

func _f9(this_, a: Array, env):
	var v_b_51 = null
	var _t1 = J.seq(J.typeof_(J.G.get("S")), "undefined")
	if (_t1 if _t1 else (not J.t(J.G.get("S")))):
		return null
	if (not J.t(J.gp(J.G.get("S"), "bonds"))):
		var _t2 = J.G.get("S")
		var _t3 = {"rec": {}, "pend": [], "feud": {}, "gap": 0.0}
		J.sp(_t2, "bonds", _t3)
		var _t4 = J.gp(J.G.get("S"), "ghosts")
		var _t5 = (_t4 if J.t(_t4) else [])
		J.mc(_t5, "forEach", [Callable(self, "_f10").bind(env)])
	v_b_51 = J.gp(J.G.get("S"), "bonds")
	var _t8 = J.gp(v_b_51, "rec")
	var _t9 = (_t8 if J.t(_t8) else {})
	J.sp(v_b_51, "rec", _t9)
	var _t10 = J.gp(v_b_51, "pend")
	var _t11 = (_t10 if J.t(_t10) else [])
	J.sp(v_b_51, "pend", _t11)
	var _t12 = J.gp(v_b_51, "feud")
	var _t13 = (_t12 if J.t(_t12) else {})
	J.sp(v_b_51, "feud", _t13)
	if (not J.seq(J.typeof_(J.gp(v_b_51, "gap")), "number")):
		J.sp(v_b_51, "gap", 0.0)
	return v_b_51

func _f11(this_, a: Array, env):
	var v_id_55 = null; var v_b_56 = null; var v_f_57 = null
	v_id_55 = J.arg(a, 0)
	v_b_56 = J.cl(env["st"], null, [])
	var _t14 = J.gp(v_b_56, "feud")
	var _t15 = J.gp(J.gp(v_b_56, "feud"), v_id_55)
	var _t16 = (_t15 if J.t(_t15) else {})
	J.sp(_t14, v_id_55, _t16)
	v_f_57 = _t16
	if (not J.seq(J.typeof_(J.gp(v_f_57, "st")), "number")):
		J.sp(v_f_57, "st", 0.0)
	var _t17 = J.gp(v_f_57, "picks")
	var _t18 = (_t17 if J.t(_t17) else [])
	J.sp(v_f_57, "picks", _t18)
	if (not J.seq(J.typeof_(J.gp(v_f_57, "wait")), "number")):
		J.sp(v_f_57, "wait", 0.0)
	var _t19 = J.gp(v_f_57, "end")
	var _t20 = (_t19 if J.t(_t19) else null)
	J.sp(v_f_57, "end", _t20)
	return v_f_57

func _f12(this_, a: Array, env):
	var v_name_60 = null; var v_k_61 = null
	v_name_60 = J.arg(a, 0)
	if J.t(J.gp(env["ART3"], v_name_60)):
		return J.gp(env["ART3"], v_name_60)
	if (not J.seq(J.typeof_(J.G.get("GHOSTS")), "undefined")):
		for _t21 in J.keys(J.G.get("GHOSTS")):
			v_k_61 = _t21
			if J.seq(J.gp(J.gp(J.G.get("GHOSTS"), v_k_61), "name"), v_name_60):
				return v_k_61
	return null

func _f14(this_, a: Array, env):
	var v_g_68 = null
	v_g_68 = J.arg(a, 0)
	return J.gp(v_g_68, "k")

func _f15(this_, a: Array, env):
	var v_x_69 = null
	v_x_69 = J.arg(a, 0)
	var _t28 = (not J.seq(v_x_69, env["k"]))
	var _t29 = ((not J.seq(v_x_69, "afu")) if _t28 else _t28)
	var _t31 = (J.gp(J.G.get("BOND_RECRUIT"), v_x_69) if _t29 else _t29)
	if J.t(_t31):
		var _t30 = env["__p"]["art"]
		_t31 = J.cl(_t30, null, [v_x_69])
	return _t31

func _f13(this_, a: Array, env):
	var v_rl_65 = null; var v_pool_66 = null; var v_r_67 = null
	var _s16 = {"__p": env, "k": null}
	_s16["k"] = J.arg(a, 0)
	v_rl_65 = J.arg(a, 1)
	for _t22 in J.iter((v_rl_65 if J.t(v_rl_65) else [])):
		v_r_67 = _t22
		var _t24 = (not J.seq(v_r_67, _s16["k"]))
		if J.t(_t24):
			var _t23 = _s16["__p"]["owned"]
			_t24 = J.cl(_t23, null, [v_r_67])
		if J.t(_t24):
			return v_r_67
	var _t25 = J.gp(J.G.get("S"), "ghosts")
	var _t26 = (_t25 if J.t(_t25) else [])
	var _t27 = J.mc(_t26, "map", [Callable(self, "_f14").bind(_s16)])
	v_pool_66 = J.mc(_t27, "filter", [Callable(self, "_f15").bind(_s16)])
	if J.t(J.len(v_pool_66)):
		return J.gp(v_pool_66, floor(J.num((randf() * J.len(v_pool_66)))))
	var _t32 = _s16["__p"]["owned"]
	var _t33 = J.cl(_t32, null, ["xiaozhi"])
	return ("xiaozhi" if J.t(((not J.seq(_s16["k"], "xiaozhi")) if J.t(_t33) else _t33)) else "afu")

func _f17(this_, a: Array, env):
	var v_l_74 = null; var v_who_75 = null; var v_text_76 = null; var v_act_77 = null; var v_re0_78 = null; var v_re_79 = null; var v_n_80 = null
	v_l_74 = J.arg(a, 0)
	var _t34 = J.gp(env["map"], J.gp(v_l_74, 0.0))
	v_who_75 = (_t34 if J.t(_t34) else J.gp(v_l_74, 0.0))
	var _t35 = J.cl(env["__p"]["zh"], null, [])
	v_text_76 = (J.gp(v_l_74, 2.0) if J.t((_t35 if J.t(_t35) else J.gp(env["__p"]["WRITTEN"], v_who_75))) else J.gp(v_l_74, 1.0))
	var _t36 = J.gp(v_l_74, 3.0)
	v_act_77 = (_t36 if J.t(_t36) else null)
	var _t37 = J.gp(v_l_74, 4.0)
	v_re0_78 = (_t37 if J.t(_t37) else null)
	v_re_79 = null
	if J.t(v_re0_78):
		var _t38 = {}
		v_re_79 = _t38
		for _t39 in J.keys(v_re0_78):
			v_n_80 = _t39
			var _t40 = J.gp(env["map"], v_n_80)
			var _t41 = (_t40 if J.t(_t40) else v_n_80)
			var _t42 = J.gp(v_re0_78, v_n_80)
			J.sp(v_re_79, _t41, _t42)
	var _t43 = (not J.t(v_act_77))
	var _t44 = (J.gp(env["__p"]["LOOK"], v_who_75) if _t43 else _t43)
	var _t45 = (J.mc(J.re("[！？]", ""), "test", [v_text_76]) if J.t(_t44) else _t44)
	if J.t(((randf() < 0.5) if J.t(_t45) else _t45)):
		var _t46 = ("ag:jump" if J.seq(v_who_75, "Bryan") else ("ag:yell" if J.seq(v_who_75, "龐總") else "ag:stamp"))
		v_act_77 = _t46
	var _t47 = J.gp(v_l_74, 5.0)
	return [v_who_75, v_text_76, v_act_77, v_re_79, (_t47 if J.t(_t47) else null)]

func _f16(this_, a: Array, env):
	var v_lines_72 = null
	var _s20 = {"__p": env, "map": null}
	v_lines_72 = J.arg(a, 0)
	_s20["map"] = J.arg(a, 1)
	return J.mc(v_lines_72, "map", [Callable(self, "_f17").bind(_s20)])

func _f19(this_, a: Array, env):
	var v_n_88 = null
	v_n_88 = J.arg(a, 0)
	var _t48 = ((not J.t(J.mc(env["names"], "includes", [v_n_88]))) if J.t(v_n_88) else v_n_88)
	var _t49 = ((not J.seq(v_n_88, "旁白")) if J.t(_t48) else _t48)
	var _t50 = ((not J.seq(v_n_88, "系統")) if J.t(_t49) else _t49)
	var _t52 = ((not J.seq(v_n_88, "主播")) if J.t(_t50) else _t50)
	if J.t(_t52):
		var _t51 = env["__p"]["keyOf"]
		_t52 = J.cl(_t51, null, [v_n_88])
	if J.t(_t52):
		J.mc(env["names"], "push", [v_n_88])

func _f20(this_, a: Array, env):
	var v_l_89 = null
	v_l_89 = J.arg(a, 0)
	var _t53 = env["add"]
	var _t54 = J.gp(env["map"], J.gp(v_l_89, 0.0))
	return J.cl(_t53, null, [(_t54 if J.t(_t54) else J.gp(v_l_89, 0.0))])

func _f21(this_, a: Array, env):
	var v_n_90 = null; var v_k_91 = null
	v_n_90 = J.arg(a, 0)
	var _t56 = env["__p"]["keyOf"]
	v_k_91 = J.cl(_t56, null, [v_n_90])
	return [v_n_90, v_k_91, (J.S_Object_("assign", [{}, J.gp(env["__p"]["LOOK"], v_n_90)]) if J.t(J.gp(env["__p"]["LOOK"], v_n_90)) else null)]

func _f18(this_, a: Array, env):
	var v_lines_83 = null; var v_first_84 = null
	var _s24 = {"__p": env, "map": null, "names": null, "add": null}
	v_lines_83 = J.arg(a, 0)
	v_first_84 = J.arg(a, 1)
	_s24["map"] = J.arg(a, 2)
	_s24["names"] = []
	_s24["add"] = Callable(self, "_f19").bind(_s24)
	J.mc(v_first_84, "forEach", [_s24["add"]])
	J.mc(v_lines_83, "forEach", [Callable(self, "_f20").bind(_s24)])
	var _t55 = J.mc(_s24["names"], "slice", [0.0, 4.0])
	return J.mc(_t55, "map", [Callable(self, "_f21").bind(_s24)])

func _f23(this_, a: Array, env):
	var v_res_105 = null
	v_res_105 = J.arg(a, 0)
	if J.t(env["cb"]):
		var _t64 = env["cb"]
		J.cl(_t64, null, [v_res_105])

func _f24(this_, a: Array, env):
	var v_l_110 = null; var v_who_111 = null; var v_t_112 = null
	v_l_110 = J.arg(a, 0)
	var _t68 = J.gp(env["__p"]["map"], J.gp(v_l_110, 0.0))
	v_who_111 = (_t68 if J.t(_t68) else J.gp(v_l_110, 0.0))
	var _t69 = J.cl(env["__p"]["__p"]["zh"], null, [])
	v_t_112 = (J.gp(v_l_110, 2.0) if J.t((_t69 if J.t(_t69) else J.gp(env["__p"]["__p"]["WRITTEN"], v_who_111))) else J.gp(v_l_110, 1.0))
	if (not J.seq(J.gp(env["__p"]["d"], "f"), "chat")):
		return [v_who_111, v_t_112]
	var _t70 = J.add(env["mm"], (1.0 + floor(J.num((randf() * 2.0)))))
	env["mm"] = _t70
	if J.cmp(env["mm"], 59.0, ">"):
		var _t71 = J.sub(env["mm"], 60.0)
		env["mm"] = _t71
		env["hh"] = J.num(env["hh"]) + 1.0
	var _t75 = null
	if J.seq(v_who_111, "旁白"):
		_t75 = v_t_112
	else:
		var _t72 = J.F_String([env["hh"]])
		var _t74 = J.mc(_t72, "padStart", [2.0, "0"])
		var _t73 = J.F_String([env["mm"]])
		_t75 = (J.str(_t74) + ":" + J.str(J.mc(_t73, "padStart", [2.0, "0"])) + "|" + J.str(v_t_112))
	return [v_who_111, _t75]

func _f25(this_, a: Array, env):
	var _t80 = env["__p"]["fin"]
	return J.cl(_t80, null, [{"skipped": false}])

func _f22(this_, a: Array, env):
	var v_k_94 = null; var v_opt_96 = null; var v_R_98 = null; var v_title_100 = null; var v_lines_102 = null; var v_first_103 = null; var v_cast_104 = null; var v_lines_108 = null; var v_sc_109 = null
	var _s28 = {"__p": env, "cb": null, "d": null, "map": null, "fin": null}
	v_k_94 = J.arg(a, 0)
	_s28["cb"] = J.arg(a, 1)
	v_opt_96 = J.arg(a, 2)
	_s28["d"] = J.gp(J.G.get("BOND_RECRUIT"), v_k_94)
	if (not J.t(_s28["d"])):
		if J.t(_s28["cb"]):
			J.cl(_s28["cb"], null, [])
		return false
	var _t57 = (v_opt_96 if J.t(v_opt_96) else {})
	v_opt_96 = _t57
	var _t59 = J.gp(v_opt_96, "r")
	if not J.t(_t59):
		var _t58 = _s28["__p"]["reactor"]
		_t59 = J.cl(_t58, null, [v_k_94, J.gp(_s28["d"], "r")])
	v_R_98 = _t59
	var _t60 = _s28["__p"]["gname"]
	var _t62 = J.cl(_t60, null, [v_k_94])
	var _t61 = _s28["__p"]["gname"]
	_s28["map"] = {"新": _t62, "R": J.cl(_t61, null, [v_R_98])}
	var _t63 = _s28["__p"]["gname"]
	v_title_100 = (J.str(J.cl(_t63, null, [v_k_94])) + "入村")
	_s28["fin"] = Callable(self, "_f23").bind(_s28)
	var _t65 = J.seq(J.gp(_s28["d"], "f"), "chat")
	var _t66 = (_t65 if _t65 else J.seq(J.gp(_s28["d"], "f"), "news"))
	if (_t66 if _t66 else J.seq(J.gp(_s28["d"], "f"), "sys")):
		var _s31 = {"__p": _s28, "hh": null, "mm": null}
		_s31["hh"] = 21.0
		_s31["mm"] = 3.0
		var _t67 = J.gp(_s31["__p"]["d"], "lines")
		v_lines_108 = J.mc(_t67, "map", [Callable(self, "_f24").bind(_s31)])
		var _t79 = null
		if J.seq(J.gp(_s31["__p"]["d"], "f"), "chat"):
			var _t76 = _s31["__p"]["__p"]["gname"]
			var _t78 = J.cl(_t76, null, [v_k_94])
			var _t77 = _s31["__p"]["__p"]["gname"]
			_t79 = {"style": "chat", "title": "落魄村村民群", "group": (J.str(_t78) + "、" + J.str(J.cl(_t77, null, [v_R_98])) + "、阿福…"), "av": ["村", "#3f6a5a"], "lines": v_lines_108}
		else:
			_t79 = ({"style": "news", "title": "陰間新聞台", "lines": v_lines_108} if J.seq(J.gp(_s31["__p"]["d"], "f"), "news") else {"style": "sys", "title": "陰司系統通知", "lines": v_lines_108})
		v_sc_109 = _t79
		J.mc(J.G.get("Story"), "queue", [v_sc_109, Callable(self, "_f25").bind(_s31)])
		return true
	var _t81 = _s28["__p"]["conv"]
	v_lines_102 = J.cl(_t81, null, [J.gp(_s28["d"], "lines"), _s28["map"]])
	v_first_103 = (["冼小姐", J.gp(_s28["map"], "新")] if J.seq(J.gp(_s28["d"], "f"), "hr") else (["龐總", J.gp(_s28["map"], "新")] if J.seq(J.gp(_s28["d"], "f"), "boss") else [J.gp(_s28["map"], "新")]))
	var _t82 = _s28["__p"]["castFor"]
	v_cast_104 = J.cl(_t82, null, [J.gp(_s28["d"], "lines"), v_first_103, _s28["map"]])
	var _t83 = J.gp(_s28["__p"]["TAG"], J.gp(_s28["d"], "f"))
	var _t85 = (_t83 if J.t(_t83) else "收服劇情")
	var _t84 = J.gp(_s28["__p"]["BG"], J.gp(_s28["d"], "f"))
	J.mc(J.G.get("Theater"), "play", [{"tag": _t85, "title": v_title_100, "bg": (_t84 if J.t(_t84) else "village"), "cast": v_cast_104, "lines": v_lines_102}, _s28["fin"]])
	return true

func _f27(this_, a: Array, env):
	var v_x_117 = null
	v_x_117 = J.arg(a, 0)
	return (not J.seq(v_x_117, env["k"]))

func _f28(this_, a: Array, env):
	var v_e_118 = null
	var _t92 = J.gp(env["b"], "rec")
	var _t93 = env["k"]
	J.sp(_t92, _t93, 1.0)
	J.cl(J.G.get("save"), null, [])

func _f26(this_, a: Array, env):
	var _s35 = {"__p": env, "k": null, "b": null}
	_s35["k"] = J.arg(a, 0)
	_s35["b"] = J.cl(_s35["__p"]["st"], null, [])
	var _t86 = (not J.t(_s35["b"]))
	if J.t((_t86 if _t86 else J.gp(J.gp(_s35["b"], "rec"), _s35["k"]))):
		return false
	var _t87 = _s35["b"]
	var _t88 = J.gp(_s35["b"], "pend")
	var _t89 = J.mc(_t88, "filter", [Callable(self, "_f27").bind(_s35)])
	J.sp(_t87, "pend", _t89)
	var _t90 = _s35["b"]
	J.sp(_t90, "gap", 0.0)
	var _t91 = _s35["__p"]["playRecruit"]
	J.cl(_t91, null, [_s35["k"], Callable(self, "_f28").bind(_s35)])
	return true

func _f29(this_, a: Array, env):
	var v_picks_121 = null
	v_picks_121 = J.arg(a, 0)
	if J.t(J.mc(v_picks_121, "includes", ["c"])):
		return "united"
	return ("rivals" if J.seq(J.gp(v_picks_121, 0.0), J.gp(v_picks_121, 1.0)) else "friends")

func _f31(this_, a: Array, env):
	var v_picks2_140 = null; var v_e_141 = null; var v_out_142 = null
	v_picks2_140 = J.arg(a, 0)
	if J.seq(env["stage"], 1.0):
		var _t98 = env["__p"]["conv"]
		return J.cl(_t98, null, [[env["__p"]["TO_BE"]], env["map"]])
	var _t99 = env["__p"]["endOf"]
	v_e_141 = J.cl(_t99, null, [v_picks2_140])
	var _t100 = env["__p"]["conv"]
	v_out_142 = J.cl(_t100, null, [J.gp(J.gp(env["F"], "end"), v_e_141), env["map"]])
	J.mc(v_out_142, "push", [["旁白", ("【冤家結局：" + J.str(J.gp(env["__p"]["END_ZH"], v_e_141)) + "】"), null, ({J.key(env["A"]): "pose:strike", J.key(env["B"]): "pose:strike"} if J.seq(v_e_141, "rivals") else null), ("joss" if J.seq(v_e_141, "friends") else ("shake" if J.seq(v_e_141, "rivals") else "flash"))]])
	return v_out_142

func _f33(this_, a: Array, env):
	var v_p_145 = null
	v_p_145 = J.arg(a, 0)
	var _t102 = env["finish"]
	var _t104 = null
	if J.seq(env["stage"], 1.0):
		_t104 = v_p_145
	else:
		var _t103 = (env["picks"] if J.t(env["picks"]) else [])
		_t104 = J.mc(_t103, "concat", [v_p_145])
	return J.cl(_t102, null, [_t104])

func _f32(this_, a: Array, env):
	var v_k_143 = null; var v_o_144 = null
	v_k_143 = J.arg(a, 0)
	v_o_144 = J.gp(env["s"], v_k_143)
	var _t101 = env["__p"]["conv"]
	return {"lines": J.cl(_t101, null, [J.gp(v_o_144, "lines"), env["map"]]), "on": Callable(self, "_f33").bind(env)}

func _f34(this_, a: Array, env):
	var v_p_149 = null; var v_af_150 = null
	v_p_149 = J.arg(a, 0)
	var _t111 = env["__p"]["xa"]
	var _t112 = J.gp(env["__p"]["xa"], "home")
	J.sp(_t111, "tx", _t112)
	v_af_150 = J.gp(env["__p"]["c"], 1.0)
	if J.t(v_af_150):
		var _t113 = J.mul(J.gp(J.mc(J.G.get("Theater"), "size", []), "W"), 0.36)
		J.sp(v_af_150, "tx", _t113)
	var _t114 = env["oc"]
	return J.cl(_t114, null, [v_p_149])

func _f30(this_, a: Array, env):
	var v_cb_127 = null; var v_replay_128 = null; var v_X_131 = null; var v_lines_134 = null; var v_opt_136 = null; var v_xl_137 = null; var v_choice_138 = null; var v_cast_139 = null; var v_e_151 = null
	var _s42 = {"__p": env, "F": null, "stage": null, "picks": null, "A": null, "B": null, "map": null, "s": null, "finish": null}
	_s42["F"] = J.arg(a, 0)
	_s42["stage"] = J.arg(a, 1)
	_s42["picks"] = J.arg(a, 2)
	v_cb_127 = J.arg(a, 3)
	v_replay_128 = J.arg(a, 4)
	var _t94 = _s42["__p"]["gname"]
	_s42["A"] = J.cl(_t94, null, [J.gp(_s42["F"], "a")])
	var _t95 = _s42["__p"]["gname"]
	_s42["B"] = J.cl(_t95, null, [J.gp(_s42["F"], "b")])
	v_X_131 = J.gp(_s42["__p"]["XWHO"], J.gp(_s42["F"], "x"))
	_s42["map"] = {"A": _s42["A"], "B": _s42["B"]}
	_s42["s"] = J.gp(_s42["F"], J.add("s", _s42["stage"]))
	var _t96 = _s42["__p"]["conv"]
	var _t97 = [J.gp(_s42["__p"]["OPENERS"], J.mod(J.add(J.len(J.gp(_s42["F"], "id")), _s42["stage"]), J.len(_s42["__p"]["OPENERS"])))]
	v_lines_134 = J.cl(_t96, null, [J.mc(_t97, "concat", [J.gp(_s42["s"], "lines")]), _s42["map"]])
	_s42["finish"] = Callable(self, "_f31").bind(_s42)
	v_opt_136 = Callable(self, "_f32").bind(_s42)
	var _t106 = null
	if J.t(J.gp(J.gp(_s42["s"], "x"), "label")):
		var _t105 = J.gp(J.gp(J.gp(_s42["s"], "x"), "label"), 1.0)
		_t106 = (_t105 if J.t(_t105) else J.gp(J.gp(J.gp(_s42["s"], "x"), "label"), 0.0))
	else:
		_t106 = "交俾第三方"
	v_xl_137 = _t106
	v_choice_138 = {"q": (J.str(_s42["A"]) + "和" + J.str(_s42["B"]) + "吵起來了。阿福站哪一邊？"), "a": J.S_Object_("assign", [{"label": ("站" + J.str(_s42["A"]) + "那邊")}, J.cl(v_opt_136, null, ["a"])]), "b": J.S_Object_("assign", [{"label": ("站" + J.str(_s42["B"]) + "那邊")}, J.cl(v_opt_136, null, ["b"])]), "c": J.S_Object_("assign", [{"label": v_xl_137}, J.cl(v_opt_136, null, ["x"])]), "plain": true}
	v_cast_139 = [[_s42["A"], J.gp(_s42["F"], "a")], ["阿福", "afu"], [_s42["B"], J.gp(_s42["F"], "b")], [v_X_131, J.gp(_s42["__p"]["ART3"], v_X_131), J.S_Object_("assign", [{}, J.gp(_s42["__p"]["LOOK"], v_X_131)])]]
	var _t107 = _s42["__p"]["T"]
	J.mc(J.G.get("Theater"), "play", [{"tag": "冤家", "title": (J.str(J.cl(_t107, null, [J.gp(_s42["F"], "title")])) + "（" + J.str(_s42["stage"]) + "／2）"), "bg": "village", "cast": v_cast_139, "xs": [0.15, 0.4, 0.85, 0.63], "lines": v_lines_134, "choice": v_choice_138}, v_cb_127])
	var _s46 = {"__p": _s42, "c": null, "xa": null}
	_s46["c"] = J.mc(J.G.get("Theater"), "cast", [])
	_s46["xa"] = J.gp(_s46["c"], 3.0)
	if J.t(_s46["xa"]):
		var _s47 = {"__p": _s46, "oc": null}
		var _t108 = _s47["__p"]["xa"]
		var _t109 = J.gp(_s47["__p"]["xa"], "px")
		J.sp(_t108, "tx", _t109)
		_s47["oc"] = J.gp(J.gp(v_choice_138, "c"), "on")
		var _t110 = J.gp(v_choice_138, "c")
		var _t115 = Callable(self, "_f34").bind(_s47)
		J.sp(_t110, "on", _t115)

func _f36(this_, a: Array, env):
	var v_f_160 = null
	v_f_160 = J.arg(a, 0)
	return J.seq(J.gp(v_f_160, "id"), env["id"])

func _f37(this_, a: Array, env):
	var v_res_161 = null; var v_c_162 = null; var v_e_163 = null; var v_e_164 = null; var v_e_165 = null
	v_res_161 = J.arg(a, 0)
	var _t123 = J.gp(env["opt"], "replay")
	var _t124 = (_t123 if J.t(_t123) else (not J.t(v_res_161)))
	var _t125 = (_t124 if J.t(_t124) else J.gp(v_res_161, "skipped"))
	if J.t((_t125 if J.t(_t125) else (not J.t(J.gp(v_res_161, "choice"))))):
		if J.t(env["cb"]):
			var _t126 = env["cb"]
			J.cl(_t126, null, [v_res_161])
		return null
	v_c_162 = J.gp(v_res_161, "choice")
	var _t127 = J.gp(env["f"], "picks")
	J.mc(_t127, "push", [v_c_162])
	var _t128 = env["f"]
	var _t129 = env["stage"]
	J.sp(_t128, "st", _t129)
	var _t130 = env["f"]
	J.sp(_t130, "wait", 0.0)
	if J.seq(env["stage"], 2.0):
		var _t131 = env["f"]
		var _t132 = env["__p"]["endOf"]
		var _t133 = J.cl(_t132, null, [J.gp(env["f"], "picks")])
		J.sp(_t131, "end", _t133)
		var _t134 = env["__p"]["endToast"]
		J.mc(J.G.get("Fx"), "toast", [J.cl(_t134, null, [env["F"], J.gp(env["f"], "end")])])
	J.cl(J.G.get("save"), null, [])
	if J.t(J.gp(J.G.get("UI"), "refresh")):
		J.mc(J.G.get("UI"), "refresh", [])
	if J.t(env["cb"]):
		var _t135 = env["cb"]
		J.cl(_t135, null, [v_res_161])

func _f35(this_, a: Array, env):
	var _s51 = {"__p": env, "id": null, "cb": null, "opt": null, "F": null, "f": null, "stage": null}
	_s51["id"] = J.arg(a, 0)
	_s51["cb"] = J.arg(a, 1)
	_s51["opt"] = J.arg(a, 2)
	var _t116 = (_s51["opt"] if J.t(_s51["opt"]) else {})
	_s51["opt"] = _t116
	_s51["F"] = J.mc(J.G.get("BOND_FEUDS"), "find", [Callable(self, "_f36").bind(_s51)])
	if (not J.t(_s51["F"])):
		return false
	var _t121 = null
	if J.t(J.gp(_s51["opt"], "replay")):
		var _t117 = J.gp(_s51["opt"], "stage")
		var _t119 = J.sub((_t117 if J.t(_t117) else 1.0), 1.0)
		var _t118 = J.gp(_s51["opt"], "picks")
		_t121 = {"st": _t119, "picks": J.mc((_t118 if J.t(_t118) else []), "slice", [])}
	else:
		var _t120 = _s51["__p"]["fs"]
		_t121 = J.cl(_t120, null, [_s51["id"]])
	_s51["f"] = _t121
	_s51["stage"] = J.add(J.gp(_s51["f"], "st"), 1.0)
	if J.cmp(_s51["stage"], 2.0, ">"):
		return false
	var _t122 = _s51["__p"]["feudScene"]
	J.cl(_t122, null, [_s51["F"], _s51["stage"], J.gp(_s51["f"], "picks"), Callable(self, "_f37").bind(_s51), J.gp(_s51["opt"], "replay")])
	return true

func _f38(this_, a: Array, env):
	var v_F_168 = null; var v_e_169 = null; var v_A_170 = null; var v_B_171 = null
	v_F_168 = J.arg(a, 0)
	v_e_169 = J.arg(a, 1)
	var _t136 = env["gname"]
	v_A_170 = J.cl(_t136, null, [J.gp(v_F_168, "a")])
	var _t137 = env["gname"]
	v_B_171 = J.cl(_t137, null, [J.gp(v_F_168, "b")])
	if J.seq(v_e_169, "friends"):
		return ("冤家和好：<b>" + J.str(v_A_170) + "＋" + J.str(v_B_171) + "</b>，同隊出陣攻擊、生命 +8%")
	if J.seq(v_e_169, "rivals"):
		return ("冤家變死對頭：<b>" + J.str(v_A_170) + "／" + J.str(v_B_171) + "</b>，同隊出陣攻擊 −3%（還會在戰場上吵架）")
	return ("同仇敵愾：<b>" + J.str(v_A_170) + "＋" + J.str(v_B_171) + "</b>，同隊出陣開場能量 +25")

func _f39(this_, a: Array, env):
	var v_F_174 = null; var v_b_175 = null; var v_f_176 = null
	v_F_174 = J.arg(a, 0)
	var _t138 = env["owned"]
	var _t140 = (not J.t(J.cl(_t138, null, [J.gp(v_F_174, "a")])))
	if not J.t(_t140):
		var _t139 = env["owned"]
		_t140 = (not J.t(J.cl(_t139, null, [J.gp(v_F_174, "b")])))
	var _t142 = _t140
	if not J.t(_t142):
		var _t141 = env["art"]
		_t142 = (not J.t(J.cl(_t141, null, [J.gp(v_F_174, "a")])))
	var _t144 = _t142
	if not J.t(_t144):
		var _t143 = env["art"]
		_t144 = (not J.t(J.cl(_t143, null, [J.gp(v_F_174, "b")])))
	var _t146 = _t144
	if not J.t(_t146):
		var _t145 = env["art"]
		_t146 = (not J.t(J.cl(_t145, null, [J.gp(env["ART3"], J.gp(env["XWHO"], J.gp(v_F_174, "x")))])))
	if _t146:
		return false
	v_b_175 = J.cl(env["st"], null, [])
	var _t147 = J.gp(J.G.get("BOND_RECRUIT"), J.gp(v_F_174, "a"))
	var _t149 = ((not J.t(J.gp(J.gp(v_b_175, "rec"), J.gp(v_F_174, "a")))) if J.t(_t147) else _t147)
	if not J.t(_t149):
		var _t148 = J.gp(J.G.get("BOND_RECRUIT"), J.gp(v_F_174, "b"))
		_t149 = ((not J.t(J.gp(J.gp(v_b_175, "rec"), J.gp(v_F_174, "b")))) if J.t(_t148) else _t148)
	if J.t(_t149):
		return false
	var _t150 = env["fs"]
	v_f_176 = J.cl(_t150, null, [J.gp(v_F_174, "id")])
	if J.cmp(J.gp(v_f_176, "st"), 2.0, ">="):
		return false
	return J.cmp(J.gp(v_f_176, "wait"), (env["GAP_FEUD1"] if J.seq(J.gp(v_f_176, "st"), 0.0) else env["GAP_FEUD2"]), ">=")

func _f41(this_, a: Array, env):
	var v_x_185 = null
	v_x_185 = J.arg(a, 0)
	var _t160 = env["art"]
	return J.cl(_t160, null, [v_x_185])

func _f40(this_, a: Array, env):
	var v_b_179 = null; var v_ready_180 = null; var v_F_181 = null; var v_F_182 = null; var v_f_183 = null; var v_k_184 = null
	v_b_179 = J.cl(env["st"], null, [])
	var _t152 = (not J.t(v_b_179))
	if not J.t(_t152):
		var _t151 = env["seen"]
		_t152 = (not J.t(J.cl(_t151, null, ["prologue_sys"])))
	if _t152:
		return false
	J.sp(v_b_179, "gap", J.num(J.gp(v_b_179, "gap")) + 1.0)
	for _t153 in J.iter(J.G.get("BOND_FEUDS")):
		v_F_182 = _t153
		var _t154 = env["owned"]
		var _t156 = J.cl(_t154, null, [J.gp(v_F_182, "a")])
		if J.t(_t156):
			var _t155 = env["owned"]
			_t156 = J.cl(_t155, null, [J.gp(v_F_182, "b")])
		if J.t(_t156):
			var _t157 = env["fs"]
			v_f_183 = J.cl(_t157, null, [J.gp(v_F_182, "id")])
			if J.cmp(J.gp(v_f_183, "st"), 2.0, "<"):
				J.sp(v_f_183, "wait", J.num(J.gp(v_f_183, "wait")) + 1.0)
	var _t158 = J.len(J.gp(v_b_179, "pend"))
	if J.t((J.cmp(J.gp(v_b_179, "gap"), 3.0, ">=") if J.t(_t158) else _t158)):
		var _t159 = J.gp(v_b_179, "pend")
		v_k_184 = J.mc(_t159, "find", [Callable(self, "_f41").bind(env)])
		if J.t(v_k_184):
			var _t161 = env["recruitNow"]
			return J.cl(_t161, null, [v_k_184])
	var _t163 = J.cmp(J.gp(v_b_179, "gap"), env["GAP_ANY"], "<")
	if not J.t(_t163):
		var _t162 = env["seen"]
		_t163 = (not J.t(J.cl(_t162, null, ["ch1_end"])))
	if _t163:
		return false
	v_ready_180 = J.mc(J.G.get("BOND_FEUDS"), "filter", [env["feudReady"]])
	if (not J.t(J.len(v_ready_180))):
		return false
	if (randf() > J.div(1.0, 30.0)):
		return false
	v_F_181 = J.gp(v_ready_180, floor(J.num((randf() * J.len(v_ready_180)))))
	J.sp(v_b_179, "gap", 0.0)
	var _t164 = env["playFeud"]
	return J.cl(_t164, null, [J.gp(v_F_181, "id")])

func _f43(this_, a: Array, env):
	var v_u_192 = null
	v_u_192 = J.arg(a, 0)
	var _t165 = J.seq(J.gp(v_u_192, "side"), 0.0)
	return ((not J.t(J.gp(v_u_192, "minion"))) if _t165 else _t165)

func _f44(this_, a: Array, env):
	var v_u_193 = null
	v_u_193 = J.arg(a, 0)
	return J.gp(v_u_193, "k")

func _f42(this_, a: Array, env):
	var v_units_188 = null; var v_ks_189 = null; var v_b_190 = null; var v_out_191 = null; var v_F_194 = null; var v_f_195 = null
	v_units_188 = J.arg(a, 0)
	var _t166 = J.mc(v_units_188, "filter", [Callable(self, "_f43").bind(env)])
	v_ks_189 = J.new_("Set", [J.mc(_t166, "map", [Callable(self, "_f44").bind(env)])])
	v_b_190 = J.cl(env["st"], null, [])
	v_out_191 = []
	if (not J.t(v_b_190)):
		return v_out_191
	for _t167 in J.iter(J.G.get("BOND_FEUDS")):
		v_F_194 = _t167
		v_f_195 = J.gp(J.gp(v_b_190, "feud"), J.gp(v_F_194, "id"))
		var _t168 = (J.gp(v_f_195, "end") if J.t(v_f_195) else v_f_195)
		var _t169 = (J.mc(v_ks_189, "has", [J.gp(v_F_194, "a")]) if J.t(_t168) else _t168)
		if J.t((J.mc(v_ks_189, "has", [J.gp(v_F_194, "b")]) if J.t(_t169) else _t169)):
			J.mc(v_out_191, "push", [[v_F_194, J.gp(v_f_195, "end")]])
	return v_out_191

func _f46(this_, a: Array, env):
	var v_u_204 = null
	v_u_204 = J.arg(a, 0)
	var _t175 = J.seq(J.gp(v_u_204, "side"), 0.0)
	if J.t(_t175):
		var _t174 = J.seq(J.gp(v_u_204, "k"), J.gp(env["F"], "a"))
		_t175 = (_t174 if _t174 else J.seq(J.gp(v_u_204, "k"), J.gp(env["F"], "b")))
	return _t175

func _f47(this_, a: Array, env):
	var v_u_205 = null
	v_u_205 = J.arg(a, 0)
	var _t176 = J.mul(J.gp(v_u_205, "atk"), 1.08)
	J.sp(v_u_205, "atk", _t176)
	var _t177 = J.mul(J.gp(v_u_205, "maxhp"), 1.08)
	J.sp(v_u_205, "maxhp", _t177)
	var _t178 = J.mul(J.gp(v_u_205, "hp"), 1.08)
	J.sp(v_u_205, "hp", _t178)

func _f48(this_, a: Array, env):
	var v_u_206 = null
	v_u_206 = J.arg(a, 0)
	var _t182 = J.gp(v_u_206, "energy")
	var _t183 = J.gp(v_u_206, "energy")
	var _t184 = J.min_([100.0, J.add((_t183 if J.t(_t183) else 0.0), 25.0)])
	J.sp(v_u_206, "energy", _t184)
	return _t184

func _f49(this_, a: Array, env):
	var v_u_208 = null
	v_u_208 = J.arg(a, 0)
	var _t188 = J.mul(J.gp(v_u_208, "atk"), 0.97)
	J.sp(v_u_208, "atk", _t188)
	return _t188

func _f51(this_, a: Array, env):
	var v_v_211 = null
	v_v_211 = J.arg(a, 0)
	var _t194 = J.seq(J.gp(v_v_211, "side"), 0.0)
	var _t195 = (J.seq(J.gp(v_v_211, "k"), (J.gp(env["__p"]["__p"]["F"], "b") if J.t(J.mod(env["n"], 2.0)) else J.gp(env["__p"]["__p"]["F"], "a"))) if _t194 else _t194)
	return (J.cmp(J.gp(v_v_211, "hp"), 0.0, ">") if _t195 else _t195)

func _f50(this_, a: Array, env):
	var v_u_210 = null; var v_e_212 = null
	var _s87 = {"__p": env, "n": null}
	_s87["n"] = J.arg(a, 0)
	var _t192 = J.seq(J.typeof_(J.G.get("Battle")), "undefined")
	if (_t192 if _t192 else (not J.t(J.gp(J.G.get("Battle"), "active")))):
		return null
	var _t193 = J.gp(J.G.get("Battle"), "units")
	v_u_210 = J.mc(_t193, "find", [Callable(self, "_f51").bind(_s87)])
	if (not J.t(v_u_210)):
		return null
	var _t196 = J.gp(J.G.get("Battle"), "fx")
	var _t198 = J.gp(v_u_210, "x")
	var _t199 = J.sub(J.mc(J.G.get("Battle"), "uy", [v_u_210]), 125.0)
	var _t197 = _s87["__p"]["__p"]["__p"]["T"]
	J.mc(_t196, "push", [{"x": _t198, "y": _t199, "text": J.cl(_t197, null, [J.gp(_s87["__p"]["__p"]["F"], "rb")]), "col": "#ffd0a0", "t": 0.0, "life": 2.2, "skill": true}])

func _f52(this_, a: Array, env):
	var _t200 = env["say"]
	return J.cl(_t200, null, [0.0])

func _f53(this_, a: Array, env):
	var _t201 = env["say"]
	return J.cl(_t201, null, [1.0])

func _f54(this_, a: Array, env):
	var _t202 = env["say"]
	return J.cl(_t202, null, [2.0])

func _f45(this_, a: Array, env):
	var v_units_198 = null; var v_pairs_199 = null; var v_msgs_200 = null; var v_e_202 = null; var v_us_203 = null; var v_e_213 = null
	v_units_198 = J.arg(a, 0)
	var _t170 = env["teamPairs"]
	v_pairs_199 = J.cl(_t170, null, [v_units_198])
	if (not J.t(J.len(v_pairs_199))):
		return null
	v_msgs_200 = []
	for _t171 in J.iter(v_pairs_199):
		var _s78 = {"__p": env, "F": null}
		var _t172 = J.gp(_t171, 0.0)
		_s78["F"] = _t172
		var _t173 = J.gp(_t171, 1.0)
		v_e_202 = _t173
		v_us_203 = J.mc(v_units_198, "filter", [Callable(self, "_f46").bind(_s78)])
		if J.seq(v_e_202, "friends"):
			J.mc(v_us_203, "forEach", [Callable(self, "_f47").bind(_s78)])
			var _t179 = _s78["__p"]["gname"]
			var _t181 = J.cl(_t179, null, [J.gp(_s78["F"], "a")])
			var _t180 = _s78["__p"]["gname"]
			J.mc(v_msgs_200, "push", [("冤家同隊 " + J.str(_t181) + "＋" + J.str(J.cl(_t180, null, [J.gp(_s78["F"], "b")])) + "：攻擊、生命 +8%")])
		else:
			if J.seq(v_e_202, "united"):
				J.mc(v_us_203, "forEach", [Callable(self, "_f48").bind(_s78)])
				var _t185 = _s78["__p"]["gname"]
				var _t187 = J.cl(_t185, null, [J.gp(_s78["F"], "a")])
				var _t186 = _s78["__p"]["gname"]
				J.mc(v_msgs_200, "push", [("同仇敵愾 " + J.str(_t187) + "＋" + J.str(J.cl(_t186, null, [J.gp(_s78["F"], "b")])) + "：開場能量 +25")])
			else:
				var _s85 = {"__p": _s78, "say": null}
				J.mc(v_us_203, "forEach", [Callable(self, "_f49").bind(_s85)])
				var _t189 = _s85["__p"]["__p"]["gname"]
				var _t191 = J.cl(_t189, null, [J.gp(_s85["__p"]["F"], "a")])
				var _t190 = _s85["__p"]["__p"]["gname"]
				J.mc(v_msgs_200, "push", [("死對頭同隊 " + J.str(_t191) + "／" + J.str(J.cl(_t190, null, [J.gp(_s85["__p"]["F"], "b")])) + "：攻擊 −3%")])
				_s85["say"] = Callable(self, "_f50").bind(_s85)
				J.F_setTimeout([Callable(self, "_f52").bind(_s85), 1800.0])
				J.F_setTimeout([Callable(self, "_f53").bind(_s85), 3600.0])
				J.F_setTimeout([Callable(self, "_f54").bind(_s85), 14000.0])
	J.mc(J.G.get("Fx"), "toast", [J.mc(v_msgs_200, "join", ["<br>"])])

func _f55(this_, a: Array, env):
	var v_k_216 = null; var v_b_217 = null; var v_out_218 = null; var v_F_219 = null; var v_f_220 = null; var v_o_221 = null
	v_k_216 = J.arg(a, 0)
	v_b_217 = J.cl(env["st"], null, [])
	if (not J.t(v_b_217)):
		return ""
	v_out_218 = []
	for _t203 in J.iter(J.G.get("BOND_FEUDS")):
		v_F_219 = _t203
		var _t204 = (not J.seq(J.gp(v_F_219, "a"), v_k_216))
		if ((not J.seq(J.gp(v_F_219, "b"), v_k_216)) if _t204 else _t204):
			continue
		v_f_220 = J.gp(J.gp(v_b_217, "feud"), J.gp(v_F_219, "id"))
		var _t205 = (not J.t(v_f_220))
		if (_t205 if _t205 else (not J.t(J.gp(v_f_220, "st")))):
			continue
		v_o_221 = (J.gp(v_F_219, "b") if J.seq(J.gp(v_F_219, "a"), v_k_216) else J.gp(v_F_219, "a"))
		var _t206 = env["gname"]
		J.mc(v_out_218, "push", [("冤家：" + J.str(J.cl(_t206, null, [v_o_221])) + "（" + J.str((J.gp(env["END_ZH"], J.gp(v_f_220, "end")) if J.t(J.gp(v_f_220, "end")) else "吵架中")) + "）")])
	return J.mc(v_out_218, "join", ["　"])

func _f57(this_, a: Array, env):
	var v_c_225 = null; var v_cv_226 = null; var v_main_227 = null; var v_t_228 = null; var v_e_229 = null
	v_c_225 = J.arg(a, 0)
	if J.t(J.mc(v_c_225, "querySelector", [".bondln"])):
		return null
	v_cv_226 = J.mc(v_c_225, "querySelector", ["canvas[data-por]"])
	v_main_227 = J.mc(v_c_225, "querySelector", [".gc-main"])
	var _t208 = (not J.t(v_cv_226))
	if (_t208 if _t208 else (not J.t(v_main_227))):
		return null
	var _t209 = env["bondLine"]
	v_t_228 = J.cl(_t209, null, [J.gp(J.gp(v_cv_226, "dataset"), "por")])
	if (not J.t(v_t_228)):
		return null
	v_e_229 = J.S_document_("createElement", ["small"])
	J.sp(v_e_229, "className", "tr bondln")
	var _t210 = J.gp(v_e_229, "style")
	J.sp(_t210, "color", "#ffb4a0")
	J.sp(v_e_229, "textContent", v_t_228)
	J.mc(v_main_227, "appendChild", [v_e_229])

func _f56(this_, a: Array, env):
	var v_sh_224 = null
	v_sh_224 = J.S_document_("querySelector", ["#sheet"])
	if (not J.t(v_sh_224)):
		return null
	var _t207 = J.mc(v_sh_224, "querySelectorAll", [".gcard"])
	J.mc(_t207, "forEach", [Callable(self, "_f57").bind(env)])

func _f59(this_, a: Array, env):
	var v_k_238 = null
	v_k_238 = J.arg(a, 0)
	var _t213 = J.gp(J.gp(env["b"], "rec"), v_k_238)
	if J.t(_t213):
		var _t212 = env["__p"]["owned"]
		_t213 = J.cl(_t212, null, [v_k_238])
	return _t213

func _f60(this_, a: Array, env):
	var v_F_239 = null
	v_F_239 = J.arg(a, 0)
	var _t214 = J.gp(J.gp(env["b"], "feud"), J.gp(v_F_239, "id"))
	return (J.cmp(J.gp(J.gp(J.gp(env["b"], "feud"), J.gp(v_F_239, "id")), "st"), 1.0, ">=") if J.t(_t214) else _t214)

func _f61(this_, a: Array, env):
	var v_k_240 = null
	v_k_240 = J.arg(a, 0)
	var _t215 = env["__p"]["gname"]
	return ("<button class=\"btn wide\" data-brec=\"" + J.str(v_k_240) + "\">" + J.str(J.cl(_t215, null, [v_k_240])) + "入村</button>")

func _f62(this_, a: Array, env):
	var v_F_241 = null; var v_f_242 = null
	v_F_241 = J.arg(a, 0)
	v_f_242 = J.gp(J.gp(env["b"], "feud"), J.gp(v_F_241, "id"))
	var _t219 = J.gp(v_F_241, "id")
	var _t218 = env["__p"]["T"]
	return ("<button class=\"btn wide\" data-bfeud=\"" + J.str(_t219) + "\">冤家：" + J.str(J.cl(_t218, null, [J.gp(v_F_241, "title")])) + "（" + J.str((J.gp(env["__p"]["END_ZH"], J.gp(v_f_242, "end")) if J.t(J.gp(v_f_242, "end")) else "吵架中")) + "）</button>")

func _f65(this_, a: Array, env):
	var _t226 = env["__p"]["__p"]["playRecruit"]
	return J.cl(_t226, null, [J.gp(J.gp(env["x"], "dataset"), "brec")])

func _f64(this_, a: Array, env):
	J.mc(J.G.get("UI"), "close", [])
	J.F_setTimeout([Callable(self, "_f65").bind(env), 60.0])

func _f63(this_, a: Array, env):
	var _s108 = {"__p": env, "x": null}
	_s108["x"] = J.arg(a, 0)
	var _t225 = _s108["x"]
	var _t227 = Callable(self, "_f64").bind(_s108)
	J.sp(_t225, "onclick", _t227)
	return _t227

func _f70(this_, a: Array, env):
	var _t233 = env["__p"]["__p"]["__p"]["playFeud"]
	return J.cl(_t233, null, [J.gp(J.gp(env["__p"]["x"], "dataset"), "bfeud"), null, {"replay": true, "stage": 2.0, "picks": [J.gp(J.gp(env["f"], "picks"), 0.0)]}])

func _f69(this_, a: Array, env):
	var v_r_246 = null
	v_r_246 = J.arg(a, 0)
	var _t231 = J.cmp(J.gp(env["f"], "st"), 2.0, ">=")
	var _t232 = (v_r_246 if _t231 else _t231)
	if J.t(((not J.t(J.gp(v_r_246, "skipped"))) if J.t(_t232) else _t232)):
		J.F_setTimeout([Callable(self, "_f70").bind(env), 300.0])

func _f68(this_, a: Array, env):
	var _t230 = env["__p"]["__p"]["__p"]["playFeud"]
	return J.cl(_t230, null, [J.gp(J.gp(env["__p"]["x"], "dataset"), "bfeud"), Callable(self, "_f69").bind(env), {"replay": true, "stage": 1.0}])

func _f67(this_, a: Array, env):
	var _s112 = {"__p": env, "f": null}
	J.mc(J.G.get("UI"), "close", [])
	_s112["f"] = J.gp(J.gp(_s112["__p"]["__p"]["b"], "feud"), J.gp(J.gp(_s112["__p"]["x"], "dataset"), "bfeud"))
	J.F_setTimeout([Callable(self, "_f68").bind(_s112), 60.0])

func _f66(this_, a: Array, env):
	var _s111 = {"__p": env, "x": null}
	_s111["x"] = J.arg(a, 0)
	var _t229 = _s111["x"]
	var _t234 = Callable(self, "_f67").bind(_s111)
	J.sp(_t229, "onclick", _t234)
	return _t234

func _f58(this_, a: Array, env):
	var v_body_232 = null; var v_hr_233 = null; var v_rec_235 = null; var v_fds_236 = null; var v_div_237 = null
	var _s103 = {"__p": env, "b": null}
	v_body_232 = J.S_document_("querySelector", ["#sheet .sh-body"])
	v_hr_233 = (J.mc(v_body_232, "querySelector", ["hr"]) if J.t(v_body_232) else v_body_232)
	if (not J.t(v_hr_233)):
		return null
	_s103["b"] = J.cl(_s103["__p"]["st"], null, [])
	if (not J.t(_s103["b"])):
		return null
	var _t211 = J.S_Object_("keys", [J.G.get("BOND_RECRUIT")])
	v_rec_235 = J.mc(_t211, "filter", [Callable(self, "_f59").bind(_s103)])
	v_fds_236 = J.mc(J.G.get("BOND_FEUDS"), "filter", [Callable(self, "_f60").bind(_s103)])
	v_div_237 = J.S_document_("createElement", ["div"])
	var _t217 = ("<h4 class=\"stand-h\">收服劇情・冤家</h4><p class=\"desc\">收服名鬼後會上演入村劇情；有些鬼天生不和，日後會吵起來（" + J.str(J.len(v_fds_236)) + "/" + J.str(J.len(J.G.get("BOND_FEUDS"))) + "）。</p><div class=\"slist\">")
	var _t216 = J.mc(v_rec_235, "map", [Callable(self, "_f61").bind(_s103)])
	var _t221 = J.add(_t217, J.mc(_t216, "join", [""]))
	var _t220 = J.mc(v_fds_236, "map", [Callable(self, "_f62").bind(_s103)])
	var _t222 = ((J.add(_t221, J.mc(_t220, "join", [""])) + ("" if J.t((J.len(v_rec_235) + J.len(v_fds_236))) else "<p class=\"desc\">還沒有。去收服幾隻名鬼吧。</p>")) + "</div>")
	J.sp(v_div_237, "innerHTML", _t222)
	var _t223 = J.gp(v_hr_233, "parentNode")
	J.mc(_t223, "insertBefore", [v_div_237, v_hr_233])
	var _t224 = J.mc(v_div_237, "querySelectorAll", ["[data-brec]"])
	J.mc(_t224, "forEach", [Callable(self, "_f63").bind(_s103)])
	var _t228 = J.mc(v_div_237, "querySelectorAll", ["[data-bfeud]"])
	J.mc(_t228, "forEach", [Callable(self, "_f66").bind(_s103)])

func _f72(this_, a: Array, env):
	var v_k_253 = null; var v_b_254 = null; var v_had_255 = null; var v_r_256 = null
	v_k_253 = J.arg(a, 0)
	v_b_254 = J.cl(env["__p"]["__p"]["st"], null, [])
	var _t235 = env["__p"]["__p"]["owned"]
	v_had_255 = J.cl(_t235, null, [v_k_253])
	v_r_256 = J.mc(env["oj"], "apply", [this_, a])
	var _t237 = ((not J.t(v_had_255)) if J.t(v_b_254) else v_b_254)
	if J.t(_t237):
		var _t236 = env["__p"]["__p"]["owned"]
		_t237 = J.cl(_t236, null, [v_k_253])
	var _t238 = (J.gp(J.G.get("BOND_RECRUIT"), v_k_253) if J.t(_t237) else _t237)
	var _t240 = ((not J.t(J.gp(J.gp(v_b_254, "rec"), v_k_253))) if J.t(_t238) else _t238)
	if J.t(_t240):
		var _t239 = J.gp(v_b_254, "pend")
		_t240 = (not J.t(J.mc(_t239, "includes", [v_k_253])))
	if J.t(_t240):
		var _t241 = J.gp(v_b_254, "pend")
		J.mc(_t241, "push", [v_k_253])
		var _t242 = J.min_([J.gp(v_b_254, "gap"), 0.0])
		J.sp(v_b_254, "gap", _t242)
	return v_r_256

func _f73(this_, a: Array, env):
	if J.t(J.cl(env["__p"]["__p"]["tick"], null, [])):
		return true
	return J.mc(env["ot"], "apply", [this_, a])

func _f74(this_, a: Array, env):
	var v_units_264 = null; var v_r_265 = null; var v_e_266 = null
	v_units_264 = J.arg(a, 0)
	v_r_265 = J.mc(env["ob"], "apply", [this_, a])
	var _t251 = env["__p"]["__p"]["battleFx"]
	J.cl(_t251, null, [(v_units_264 if J.t(v_units_264) else [])])
	return v_r_265

func _f75(this_, a: Array, env):
	var v_r_270 = null; var v_e_271 = null
	v_r_270 = J.mc(env["os"], "apply", [this_, a])
	J.cl(env["__p"]["__p"]["storyHook"], null, [])
	return v_r_270

func _f76(this_, a: Array, env):
	if J.t(J.mc(env["sh"], "querySelector", [".gcard"])):
		J.cl(env["__p"]["paintRoster"], null, [])

func _f71(this_, a: Array, env):
	var v_e_257 = null
	var _s116 = {"__p": env, "sh": null}
	if J.t(_s116["__p"]["started"]):
		return null
	_s116["__p"]["started"] = true
	if J.seq(J.typeof_(J.G.get("joinGhost")), "function"):
		var _s117 = {"__p": _s116, "oj": null}
		_s117["oj"] = J.G.get("joinGhost")
		J.G["joinGhost"] = Callable(self, "_f72").bind(_s117)
		var _t243 = J.gp(J.G.get("window"), "G")
		if J.t((J.gp(J.gp(J.G.get("window"), "G"), "joinGhost") if J.t(_t243) else _t243)):
			var _t244 = J.gp(J.G.get("window"), "G")
			var _t245 = J.G.get("joinGhost")
			J.sp(_t244, "joinGhost", _t245)
	var _t246 = (not J.seq(J.typeof_(J.G.get("Rivals")), "undefined"))
	if J.t((J.gp(J.G.get("Rivals"), "tick") if _t246 else _t246)):
		var _s123 = {"__p": _s116, "ot": null}
		_s123["ot"] = J.gp(J.G.get("Rivals"), "tick")
		var _t247 = J.G.get("Rivals")
		var _t248 = Callable(self, "_f73").bind(_s123)
		J.sp(_t247, "tick", _t248)
	var _t249 = (not J.seq(J.typeof_(J.G.get("GhostStreet")), "undefined"))
	if J.t((J.gp(J.G.get("GhostStreet"), "battleBuffs") if _t249 else _t249)):
		var _s125 = {"__p": _s116, "ob": null}
		_s125["ob"] = J.gp(J.G.get("GhostStreet"), "battleBuffs")
		var _t250 = J.G.get("GhostStreet")
		var _t252 = Callable(self, "_f74").bind(_s125)
		J.sp(_t250, "battleBuffs", _t252)
	var _t253 = (not J.seq(J.typeof_(J.G.get("UI")), "undefined"))
	if J.t((J.gp(J.G.get("UI"), "openStory") if _t253 else _t253)):
		var _s130 = {"__p": _s116, "os": null}
		_s130["os"] = J.gp(J.G.get("UI"), "openStory")
		var _t254 = J.G.get("UI")
		var _t255 = Callable(self, "_f75").bind(_s130)
		J.sp(_t254, "openStory", _t255)
	_s116["sh"] = J.S_document_("querySelector", ["#sheet"])
	if J.t(((not J.seq(J.typeof_(J.G.get("MutationObserver")), "undefined")) if J.t(_s116["sh"]) else _s116["sh"])):
		var _t256 = J.new_("MutationObserver", [Callable(self, "_f76").bind(_s116)])
		_s116["__p"]["mo"] = _t256
		J.mc(_s116["__p"]["mo"], "observe", [_s116["sh"], {"childList": true, "subtree": true}])

func _f2(this_, a: Array, env):
	var v_id_43 = null
	v_id_43 = J.arg(a, 0)
	var _t257 = (J.gp(J.G.get("S"), "seen") if J.t(J.G.get("S")) else J.G.get("S"))
	return (not (not J.t((J.gp(J.gp(J.G.get("S"), "seen"), v_id_43) if J.t(_t257) else _t257))))

func _f4(this_, a: Array, env):
	var v_g_45 = null
	v_g_45 = J.arg(a, 0)
	return J.seq(J.gp(v_g_45, "k"), env["k"])

func _f3(this_, a: Array, env):
	var _s4 = {"__p": env, "k": null}
	_s4["k"] = J.arg(a, 0)
	var _t259 = (J.gp(J.G.get("S"), "ghosts") if J.t(J.G.get("S")) else J.G.get("S"))
	if J.t(_t259):
		var _t258 = J.gp(J.G.get("S"), "ghosts")
		_t259 = J.mc(_t258, "some", [Callable(self, "_f4").bind(_s4)])
	return (not (not J.t(_t259)))

func _f5(this_, a: Array, env):
	var v_k_46 = null
	v_k_46 = J.arg(a, 0)
	var _t260 = (not J.seq(J.typeof_(J.G.get("GHOSTS")), "undefined"))
	var _t261 = (J.gp(J.G.get("GHOSTS"), v_k_46) if _t260 else _t260)
	var _t262 = (J.gp(J.gp(J.G.get("GHOSTS"), v_k_46), "name") if J.t(_t261) else _t261)
	return (_t262 if J.t(_t262) else v_k_46)

func _f6(this_, a: Array, env):
	var _t263 = J.seq(J.typeof_(J.G.get("LANG")), "undefined")
	return (_t263 if _t263 else (not J.seq(J.gp(J.G.get("LANG"), "cur"), "yue")))

func _f7(this_, a: Array, env):
	var v_p_47 = null
	v_p_47 = J.arg(a, 0)
	return (((J.gp(v_p_47, 1.0) if (not J.leq(J.gp(v_p_47, 1.0), null)) else J.gp(v_p_47, 0.0)) if J.t(J.cl(env["zh"], null, [])) else J.gp(v_p_47, 0.0)) if J.t(J.S_Array_("isArray", [v_p_47])) else v_p_47)

func _f8(this_, a: Array, env):
	var v_k_48 = null
	v_k_48 = J.arg(a, 0)
	var _t265 = (not J.seq(J.typeof_(J.G.get("sprOk")), "function"))
	if not J.t(_t265):
		var _t264 = J.G.get("sprOk")
		_t265 = J.cl(_t264, null, [v_k_48])
	return _t265

func _f77(this_, a: Array, env):
	var v_k_274 = null; var v_r_275 = null
	v_k_274 = J.arg(a, 0)
	v_r_275 = J.arg(a, 1)
	var _t266 = env["playRecruit"]
	return J.cl(_t266, null, [v_k_274, null, {"r": v_r_275}])

func _f78(this_, a: Array, env):
	var v_id_278 = null; var v_stage_279 = null; var v_first_280 = null
	v_id_278 = J.arg(a, 0)
	v_stage_279 = J.arg(a, 1)
	v_first_280 = J.arg(a, 2)
	var _t267 = env["playFeud"]
	return J.cl(_t267, null, [v_id_278, null, {"replay": true, "stage": (v_stage_279 if J.t(v_stage_279) else 1.0), "picks": ([v_first_280] if J.t(v_first_280) else [])}])

func _f1(this_, a: Array, env):
	var v_init_41 = null; var v_demo_42 = null
	var _s2 = {"__p": env, "ART3": null, "LOOK": null, "WRITTEN": null, "XWHO": null, "END_ZH": null, "GAP_ANY": null, "GAP_FEUD1": null, "GAP_FEUD2": null, "seen": null, "owned": null, "gname": null, "zh": null, "T": null, "art": null, "started": null, "mo": null, "st": null, "fs": null, "keyOf": null, "reactor": null, "conv": null, "castFor": null, "TAG": null, "BG": null, "playRecruit": null, "recruitNow": null, "OPENERS": null, "TO_BE": null, "endOf": null, "feudScene": null, "playFeud": null, "endToast": null, "feudReady": null, "tick": null, "teamPairs": null, "battleFx": null, "bondLine": null, "paintRoster": null, "storyHook": null}
	_s2["st"] = Callable(self, "_f9").bind(_s2)
	_s2["fs"] = Callable(self, "_f11").bind(_s2)
	_s2["keyOf"] = Callable(self, "_f12").bind(_s2)
	_s2["reactor"] = Callable(self, "_f13").bind(_s2)
	_s2["conv"] = Callable(self, "_f16").bind(_s2)
	_s2["castFor"] = Callable(self, "_f18").bind(_s2)
	_s2["playRecruit"] = Callable(self, "_f22").bind(_s2)
	_s2["recruitNow"] = Callable(self, "_f26").bind(_s2)
	_s2["endOf"] = Callable(self, "_f29").bind(_s2)
	_s2["feudScene"] = Callable(self, "_f30").bind(_s2)
	_s2["playFeud"] = Callable(self, "_f35").bind(_s2)
	_s2["endToast"] = Callable(self, "_f38").bind(_s2)
	_s2["feudReady"] = Callable(self, "_f39").bind(_s2)
	_s2["tick"] = Callable(self, "_f40").bind(_s2)
	_s2["teamPairs"] = Callable(self, "_f42").bind(_s2)
	_s2["battleFx"] = Callable(self, "_f45").bind(_s2)
	_s2["bondLine"] = Callable(self, "_f55").bind(_s2)
	_s2["paintRoster"] = Callable(self, "_f56").bind(_s2)
	_s2["storyHook"] = Callable(self, "_f58").bind(_s2)
	v_init_41 = Callable(self, "_f71").bind(_s2)
	_s2["ART3"] = {"阿福": "afu", "冼小姐": "npc_hr", "龐總": "npc_kpiboss", "Bryan": "npc_rival"}
	_s2["LOOK"] = {"龐總": {"base": "ag:inspect", "talk": "ag:tap"}, "Bryan": {"base": "ag:spin", "talk": "ag:dribble"}, "冼小姐": {"base": "ag:clip", "talk": "ag:glasses"}}
	_s2["WRITTEN"] = {"旁白": 1.0, "系統": 1.0, "主播": 1.0}
	_s2["XWHO"] = {"hr": "冼小姐", "boss": "龐總", "bryan": "Bryan"}
	_s2["END_ZH"] = {"friends": "和好", "rivals": "死對頭", "united": "同仇敵愾"}
	_s2["GAP_ANY"] = 150.0
	_s2["GAP_FEUD1"] = 260.0
	_s2["GAP_FEUD2"] = 420.0
	_s2["seen"] = Callable(self, "_f2").bind(_s2)
	_s2["owned"] = Callable(self, "_f3").bind(_s2)
	_s2["gname"] = Callable(self, "_f5").bind(_s2)
	_s2["zh"] = Callable(self, "_f6").bind(_s2)
	_s2["T"] = Callable(self, "_f7").bind(_s2)
	_s2["art"] = Callable(self, "_f8").bind(_s2)
	_s2["started"] = false
	_s2["mo"] = null
	_s2["TAG"] = {"stage": "收服劇情", "hr": "入職面試", "boss": "入職 KPI", "chat": "村民群組", "news": "陰間新聞台", "sys": "系統通知"}
	_s2["BG"] = {"stage": "village", "hr": "hq", "boss": "hq"}
	_s2["OPENERS"] = [["旁白", "兩隻鬼對望，擺好架勢。", "兩隻鬼對望，擺好架勢。", null, {"A": "pose:strike", "B": "pose:strike"}, "shake"], ["旁白", "空氣突然靜咗。遠處有隻烏鴉，識趣咁飛走咗。", "空氣突然安靜下來。遠處有一隻烏鴉，識趣地飛走了。", null, {"A": "pose:strike", "B": "pose:strike"}, "shake"], ["旁白", "兩隻鬼同時出招——停喺半空，邊個都冇打落去。", "兩隻鬼同時出招——停在半空，誰都沒打下去。", null, {"A": "pose:strike", "B": "pose:strike"}, "shake,flash"]]
	_s2["TO_BE"] = ["旁白", "（兩隻鬼約好：下次再嘈。）", "（兩隻鬼約好了：下次再吵。）"]
	v_demo_42 = {"recruit": Callable(self, "_f77").bind(_s2), "feud": Callable(self, "_f78").bind(_s2)}
	return {"st": _s2["st"], "init": v_init_41, "tick": _s2["tick"], "playRecruit": _s2["playRecruit"], "playFeud": _s2["playFeud"], "recruitNow": _s2["recruitNow"], "bondLine": _s2["bondLine"], "battleFx": _s2["battleFx"], "endOf": _s2["endOf"], "demo": v_demo_42, "list": J.G.get("BOND_FEUDS"), "recruits": J.G.get("BOND_RECRUIT")}

func _f79(this_, a: Array, env):
	var v_bondsBoot_283 = null; var v_e_284 = null
	v_bondsBoot_283 = Callable(self, "_f79").bind(env)
	var _t268 = J.seq(J.typeof_(J.G.get("S")), "undefined")
	if (_t268 if _t268 else (not J.t(J.S_document_("querySelector", ["#sheet"])))):
		J.F_setTimeout([v_bondsBoot_283, 300.0])
		return null
	J.mc(J.G.get("Bonds"), "init", [])
