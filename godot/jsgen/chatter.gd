# 自動轉譯自 chatter.js（tools/jsgd.js）——唔好直接改，改原 JS 再轉
extends RefCounted

func run(env):
	var this_ = null; var a = []
	J.G["Chatter"] = J.cl(Callable(self, "_f1").bind(env), null, [])
	J.cl(Callable(self, "_f89").bind(env), null, [])

func _f6(this_, a: Array, env):
	var v_c_53 = null
	var _t1 = J.seq(J.typeof_(J.G.get("S")), "undefined")
	if (_t1 if _t1 else (not J.t(J.G.get("S")))):
		return null
	var _t2 = J.G.get("S")
	var _t3 = J.gp(J.G.get("S"), "chat")
	var _t4 = (_t3 if J.t(_t3) else {})
	J.sp(_t2, "chat", _t4)
	v_c_53 = _t4
	var _t5 = J.gp(v_c_53, "u")
	var _t6 = (_t5 if J.t(_t5) else {})
	J.sp(v_c_53, "u", _t6)
	var _t7 = J.gp(v_c_53, "arc")
	var _t8 = (_t7 if J.t(_t7) else {})
	J.sp(v_c_53, "arc", _t8)
	var _t9 = J.gp(v_c_53, "c")
	var _t10 = (_t9 if J.t(_t9) else {})
	J.sp(v_c_53, "c", _t10)
	var _t11 = J.gp(v_c_53, "e")
	var _t12 = (_t11 if J.t(_t11) else {})
	J.sp(v_c_53, "e", _t12)
	var _t13 = J.gp(v_c_53, "ev")
	var _t14 = (_t13 if J.t(_t13) else {})
	J.sp(v_c_53, "ev", _t14)
	return v_c_53

func _f8(this_, a: Array, env):
	var v_s_57 = null; var v_h_58 = null; var v_i_59 = null
	v_s_57 = J.arg(a, 0)
	v_h_58 = 2166136261.0
	v_i_59 = 0.0
	while true:
		if not J.cmp(v_i_59, J.len(v_s_57), "<"): break
		var _t15 = J.bxor(v_h_58, J.mc(v_s_57, "charCodeAt", [v_i_59]))
		v_h_58 = _t15
		var _t16 = J.math("imul", [v_h_58, 16777619.0])
		v_h_58 = _t16
		v_i_59 = J.num(v_i_59) + 1.0
	return J.ushr(v_h_58, 0.0)

func _f9(this_, a: Array, env):
	var v_g_62 = null; var v_i_63 = null
	v_g_62 = J.arg(a, 0)
	var _t17 = J.gp(v_g_62, "name")
	v_i_63 = J.mc(_t17, "indexOf", ["・"])
	var _t19 = null
	if J.cmp(v_i_63, 0.0, ">="):
		var _t18 = J.gp(v_g_62, "name")
		_t19 = J.mc(_t18, "slice", [J.add(v_i_63, 1.0)])
	else:
		_t19 = J.gp(v_g_62, "name")
	return _t19

func _f12(this_, a: Array, env):
	var v_a_73 = null
	v_a_73 = J.arg(a, 0)
	return J.seq(J.gp(v_a_73, "id"), J.gp(env["g"], "arch"))

func _f13(this_, a: Array, env):
	var v_a_74 = null
	v_a_74 = J.arg(a, 0)
	return J.seq(J.gp(v_a_74, "id"), J.gp(env["g"], "arch"))

func _f14(this_, a: Array, env):
	var v_a_75 = null
	v_a_75 = J.arg(a, 0)
	return J.gp(v_a_75, "en")

func _f11(this_, a: Array, env):
	var v_fresh_68 = null; var v_list_69 = null; var v_en_70 = null; var v_enA_71 = null; var v_a_72 = null; var v_h_76 = null
	var _s14 = {"__p": env, "g": null}
	_s14["g"] = J.arg(a, 0)
	v_fresh_68 = J.arg(a, 1)
	var _t20 = _s14["__p"]["isFodder"]
	if (not J.t(J.cl(_t20, null, [_s14["g"]]))):
		return null
	v_list_69 = J.gp(J.gp(_s14["__p"]["D"], "arch"), J.gp(_s14["g"], "k"))
	var _t21 = J.gp(_s14["g"], "arch")
	if J.t((J.mc(v_list_69, "some", [Callable(self, "_f12").bind(_s14)]) if J.t(_t21) else _t21)):
		return J.mc(v_list_69, "find", [Callable(self, "_f13").bind(_s14)])
	var _t22 = _s14["__p"]["nick"]
	v_en_70 = J.mc(J.re("[A-Za-z]", ""), "test", [J.cl(_t22, null, [_s14["g"]])])
	v_enA_71 = J.mc(v_list_69, "filter", [Callable(self, "_f14").bind(_s14)])
	v_a_72 = null
	if J.t(v_fresh_68):
		var _t23 = (J.len(v_enA_71) if J.t(v_en_70) else v_en_70)
		var _t26 = null
		if J.t(((randf() < 0.6) if J.t(_t23) else _t23)):
			var _t24 = _s14["__p"]["rnd"]
			_t26 = J.cl(_t24, null, [v_enA_71])
		else:
			var _t25 = _s14["__p"]["rnd"]
			_t26 = J.cl(_t25, null, [v_list_69])
		v_a_72 = _t26
	else:
		var _t27 = _s14["__p"]["hash"]
		v_h_76 = J.cl(_t27, null, [J.add(J.add(J.gp(_s14["g"], "id"), "|"), J.gp(_s14["g"], "name"))])
		var _t28 = (J.len(v_enA_71) if J.t(v_en_70) else v_en_70)
		var _t29 = (J.gp(v_enA_71, J.mod(J.ushr(v_h_76, 3.0), J.len(v_enA_71))) if J.t(((J.band(v_h_76, 7.0) < 5.0) if J.t(_t28) else _t28)) else J.gp(v_list_69, J.mod(J.ushr(v_h_76, 3.0), J.len(v_list_69))))
		v_a_72 = _t29
	var _t30 = _s14["g"]
	var _t31 = J.gp(v_a_72, "id")
	J.sp(_t30, "arch", _t31)
	return v_a_72

func _f15(this_, a: Array, env):
	var v_g_79 = null; var v_a_80 = null; var v_l_81 = null
	v_g_79 = J.arg(a, 0)
	var _t32 = env["archOf"]
	v_a_80 = J.cl(_t32, null, [v_g_79])
	if (not J.t(v_a_80)):
		return ""
	v_l_81 = J.gp(J.gp(v_a_80, "lines"), 0.0)
	var _t33 = env["fill"]
	var _t34 = env["pickT"]
	return J.cl(_t33, null, [J.cl(_t34, null, [J.gp(v_l_81, 0.0), J.gp(v_l_81, 1.0)]), v_g_79])

func _f16(this_, a: Array, env):
	var v_k_84 = null; var v_c_85 = null; var v_e_86 = null
	v_k_84 = J.arg(a, 0)
	v_c_85 = J.cl(env["st"], null, [])
	v_e_86 = (J.gp(J.gp(v_c_85, "ev"), v_k_84) if J.t(v_c_85) else v_c_85)
	return (not (not J.t((J.cmp(J.sub(J.cl(env["now"], null, []), J.gp(v_e_86, "t")), J.gp(env["EV_LIFE"], v_k_84), "<") if J.t(v_e_86) else v_e_86))))

func _f17(this_, a: Array, env):
	var v_k_89 = null; var v_n_90 = null; var v_c_91 = null
	v_k_89 = J.arg(a, 0)
	v_n_90 = J.arg(a, 1)
	v_c_91 = J.cl(env["st"], null, [])
	if J.t(v_c_91):
		var _t35 = J.gp(v_c_91, "ev")
		var _t36 = {"t": J.cl(env["now"], null, []), "n": (v_n_90 if J.t(v_n_90) else "")}
		J.sp(_t35, v_k_89, _t36)

func _f18(this_, a: Array, env):
	return J.mc(J.new_("Date", []), "getHours", [])

func _f19(this_, a: Array, env):
	var v_tag_96 = null; var v_g_97 = null; var v_poolKey_98 = null; var v_t_99 = null; var v_h_100 = null; var v_h_101 = null; var v_id_102 = null; var v_n_103 = null
	v_tag_96 = J.arg(a, 0)
	v_g_97 = J.arg(a, 1)
	v_poolKey_98 = J.arg(a, 2)
	if (not J.t(v_tag_96)):
		return true
	for _t37 in J.iter(J.mc(v_tag_96, "split", [","])):
		v_t_99 = _t37
		if J.seq(v_t_99, "夜"):
			v_h_100 = J.cl(env["hour"], null, [])
			var _t38 = J.cmp(v_h_100, 23.0, ">=")
			if (not (_t38 if _t38 else J.cmp(v_h_100, 4.0, "<"))):
				return false
		else:
			if J.seq(v_t_99, "晨"):
				v_h_101 = J.cl(env["hour"], null, [])
				var _t39 = J.cmp(v_h_101, 5.0, ">=")
				if (not (J.cmp(v_h_101, 9.0, "<") if _t39 else _t39)):
					return false
			else:
				if J.seq(J.mc(v_t_99, "indexOf", ["p:"]), 0.0):
					var _t40 = (not J.t(v_g_97))
					if (_t40 if _t40 else (not J.seq(J.gp(v_g_97, "post"), J.mc(v_t_99, "slice", [2.0])))):
						return false
				else:
					if J.t(J.mc(env["EVENT_TAGS"], "includes", [v_t_99])):
						var _t41 = env["evOn"]
						if (not J.t(J.cl(_t41, null, [v_t_99]))):
							return false
					else:
						if J.seq(v_t_99, "early"):
							var _t42 = env["seen"]
							if J.t(J.cl(_t42, null, ["ch1_end"])):
								return false
						else:
							if J.seq(v_t_99, "mid"):
								var _t43 = env["seen"]
								if (not J.t(J.cl(_t43, null, ["ch3_end"]))):
									return false
							else:
								if J.seq(v_t_99, "late"):
									var _t45 = J.gp(J.G.get("S"), "ended")
									if not J.t(_t45):
										var _t44 = env["seen"]
										_t45 = J.cl(_t44, null, ["ch6_end"])
									if (not J.t(_t45)):
										return false
								else:
									if J.seq(J.mc(v_t_99, "indexOf", ["arc:"]), 0.0):
										var _t46 = J.mc(v_t_99, "split", [":"])
										var _t47 = J.gp(_t46, 1.0)
										v_id_102 = _t47
										var _t48 = J.gp(_t46, 2.0)
										v_n_103 = _t48
										var _t49 = J.gp(J.gp(J.cl(env["st"], null, []), "arc"), v_id_102)
										if (not J.seq(J.add((_t49 if J.t(_t49) else 0.0), 1.0), J.num(v_n_103))):
											return false
	return true

func _f24(this_, a: Array, env):
	var v_s_110 = null; var v_g_111 = null; var v_c_112 = null; var v_nn_113 = null
	v_s_110 = J.arg(a, 0)
	v_g_111 = J.arg(a, 1)
	v_c_112 = J.cl(env["st"], null, [])
	var _t50 = (J.gp(J.gp(v_c_112, "ev"), "new") if J.t(v_c_112) else v_c_112)
	var _t51 = (J.gp(J.gp(J.gp(v_c_112, "ev"), "new"), "n") if J.t(_t50) else _t50)
	v_nn_113 = (_t51 if J.t(_t51) else "新同事")
	var _t52 = J.mc(v_s_110, "split", ["{N}"])
	var _t53 = J.mc(_t52, "join", [v_nn_113])
	var _t54 = J.mc(_t53, "split", ["{n}"])
	var _t58 = null
	if J.t(v_g_111):
		var _t55 = env["isFodder"]
		var _t57 = null
		if J.t(J.cl(_t55, null, [v_g_111])):
			var _t56 = env["nick"]
			_t57 = J.cl(_t56, null, [v_g_111])
		else:
			_t57 = J.gp(v_g_111, "name")
		_t58 = _t57
	else:
		_t58 = ""
	return J.mc(_t54, "join", [_t58])

func _f25(this_, a: Array, env):
	var v_g_116 = null; var v_a_117 = null
	v_g_116 = J.arg(a, 0)
	if (not J.t(v_g_116)):
		return null
	var _t60 = J.gp(J.gp(env["D"], "named"), J.gp(v_g_116, "k"))
	if J.t(_t60):
		var _t59 = env["isFodder"]
		_t60 = (not J.t(J.cl(_t59, null, [v_g_116])))
	if J.t(_t60):
		return {"key": J.add("n:", J.gp(v_g_116, "k")), "lines": J.gp(J.gp(env["D"], "named"), J.gp(v_g_116, "k"))}
	var _t61 = env["archOf"]
	v_a_117 = J.cl(_t61, null, [v_g_116])
	if J.t(v_a_117):
		return {"key": J.add((J.add("a:", J.gp(v_g_116, "k")) + ":"), J.gp(v_a_117, "id")), "lines": J.gp(v_a_117, "lines")}
	return null

func _f27(this_, a: Array, env):
	var v_l_129 = null; var v_i_130 = null
	v_l_129 = J.arg(a, 0)
	v_i_130 = J.arg(a, 1)
	return v_i_130

func _f28(this_, a: Array, env):
	var v_i_131 = null
	v_i_131 = J.arg(a, 0)
	var _t69 = (not J.t(J.mc(env["used"], "includes", [v_i_131])))
	if J.t(_t69):
		var _t68 = env["__p"]["tagOk"]
		_t69 = J.cl(_t68, null, [J.gp(J.gp(J.gp(env["pool"], "lines"), v_i_131), 2.0), env["g"]])
	return _t69

func _f30(this_, a: Array, env):
	var v_t_133 = null
	v_t_133 = J.arg(a, 0)
	if J.seq(J.mc(v_t_133, "indexOf", ["arc:"]), 0.0):
		var _t76 = J.gp(env["c"], "arc")
		var _t77 = J.gp(J.mc(v_t_133, "split", [":"]), 1.0)
		J.sp(_t76, _t77, 0.0)

func _f29(this_, a: Array, env):
	var v_l_132 = null
	v_l_132 = J.arg(a, 0)
	if J.t(J.gp(v_l_132, 2.0)):
		var _t74 = J.gp(v_l_132, 2.0)
		var _t75 = J.mc(_t74, "split", [","])
		J.mc(_t75, "forEach", [Callable(self, "_f30").bind(env)])

func _f31(this_, a: Array, env):
	var v_l_134 = null; var v_i_135 = null
	v_l_134 = J.arg(a, 0)
	v_i_135 = J.arg(a, 1)
	return v_i_135

func _f32(this_, a: Array, env):
	var v_i_136 = null
	v_i_136 = J.arg(a, 0)
	var _t80 = env["__p"]["tagOk"]
	return J.cl(_t80, null, [J.gp(J.gp(J.gp(env["pool"], "lines"), v_i_136), 2.0), env["g"]])

func _f33(this_, a: Array, env):
	var v_i_137 = null
	v_i_137 = J.arg(a, 0)
	var _t82 = env["__p"]["isEvent"]
	return J.cl(_t82, null, [J.gp(J.gp(J.gp(env["pool"], "lines"), v_i_137), 2.0)])

func _f34(this_, a: Array, env):
	var v_i_138 = null
	v_i_138 = J.arg(a, 0)
	var _t83 = env["__p"]["isCtx"]
	return J.cl(_t83, null, [J.gp(J.gp(J.gp(env["pool"], "lines"), v_i_138), 2.0)])

func _f35(this_, a: Array, env):
	var v_t_139 = null
	v_t_139 = J.arg(a, 0)
	if J.seq(J.mc(v_t_139, "indexOf", ["arc:"]), 0.0):
		var _t94 = J.gp(env["c"], "arc")
		var _t95 = J.gp(J.mc(v_t_139, "split", [":"]), 1.0)
		var _t96 = J.num(J.gp(J.mc(v_t_139, "split", [":"]), 2.0))
		J.sp(_t94, _t95, _t96)

func _f26(this_, a: Array, env):
	var v_ok_124 = null; var v_ev_125 = null; var v_cx_126 = null; var v_i_127 = null; var v_l_128 = null
	var _s40 = {"__p": env, "pool": null, "g": null, "c": null, "used": null}
	_s40["pool"] = J.arg(a, 0)
	_s40["g"] = J.arg(a, 1)
	_s40["c"] = J.cl(_s40["__p"]["st"], null, [])
	var _t62 = J.gp(_s40["c"], "u")
	var _t63 = J.gp(_s40["pool"], "key")
	var _t64 = J.gp(J.gp(_s40["c"], "u"), J.gp(_s40["pool"], "key"))
	var _t65 = (_t64 if J.t(_t64) else [])
	J.sp(_t62, _t63, _t65)
	_s40["used"] = _t65
	var _t66 = J.gp(_s40["pool"], "lines")
	var _t67 = J.mc(_t66, "map", [Callable(self, "_f27").bind(_s40)])
	v_ok_124 = J.mc(_t67, "filter", [Callable(self, "_f28").bind(_s40)])
	if (not J.t(J.len(v_ok_124))):
		var _t70 = J.gp(_s40["c"], "u")
		var _t71 = J.gp(_s40["pool"], "key")
		var _t72 = []
		J.sp(_t70, _t71, _t72)
		var _t73 = J.gp(_s40["pool"], "lines")
		J.mc(_t73, "forEach", [Callable(self, "_f29").bind(_s40)])
		var _t78 = J.gp(_s40["pool"], "lines")
		var _t79 = J.mc(_t78, "map", [Callable(self, "_f31").bind(_s40)])
		var _t81 = J.mc(_t79, "filter", [Callable(self, "_f32").bind(_s40)])
		v_ok_124 = _t81
		if (not J.t(J.len(v_ok_124))):
			return null
	v_ev_125 = J.mc(v_ok_124, "filter", [Callable(self, "_f33").bind(_s40)])
	v_cx_126 = J.mc(v_ok_124, "filter", [Callable(self, "_f34").bind(_s40)])
	var _t84 = J.len(v_ev_125)
	var _t90 = null
	if J.t(((randf() < 0.7) if J.t(_t84) else _t84)):
		var _t85 = _s40["__p"]["rnd"]
		_t90 = J.cl(_t85, null, [v_ev_125])
	else:
		var _t86 = J.len(v_cx_126)
		var _t89 = null
		if J.t(((randf() < 0.4) if J.t(_t86) else _t86)):
			var _t87 = _s40["__p"]["rnd"]
			_t89 = J.cl(_t87, null, [v_cx_126])
		else:
			var _t88 = _s40["__p"]["rnd"]
			_t89 = J.cl(_t88, null, [v_ok_124])
		_t90 = _t89
	v_i_127 = _t90
	var _t91 = J.gp(J.gp(_s40["c"], "u"), J.gp(_s40["pool"], "key"))
	J.mc(_t91, "push", [v_i_127])
	v_l_128 = J.gp(J.gp(_s40["pool"], "lines"), v_i_127)
	if J.t(J.gp(v_l_128, 2.0)):
		var _t92 = J.gp(v_l_128, 2.0)
		var _t93 = J.mc(_t92, "split", [","])
		J.mc(_t93, "forEach", [Callable(self, "_f35").bind(_s40)])
	var _t97 = _s40["__p"]["fill"]
	var _t98 = _s40["__p"]["pickT"]
	return J.cl(_t97, null, [J.cl(_t98, null, [J.gp(v_l_128, 0.0), J.gp(v_l_128, 1.0)]), _s40["g"]])

func _f36(this_, a: Array, env):
	var v_g_142 = null; var v_p_143 = null
	v_g_142 = J.arg(a, 0)
	var _t99 = env["poolOf"]
	v_p_143 = J.cl(_t99, null, [v_g_142])
	var _t101 = null
	if J.t(v_p_143):
		var _t100 = env["pickFrom"]
		_t101 = J.cl(_t100, null, [v_p_143, v_g_142])
	else:
		_t101 = null
	return _t101

func _f37(this_, a: Array, env):
	var v_a_146 = null; var v_b_147 = null; var v_F_148 = null; var v_ab_149 = null; var v_ba_150 = null; var v_f_151 = null
	v_a_146 = J.arg(a, 0)
	v_b_147 = J.arg(a, 1)
	var _t102 = J.seq(J.typeof_(J.G.get("BOND_FEUDS")), "undefined")
	if (_t102 if _t102 else (not J.t(J.gp(J.G.get("S"), "bonds")))):
		return null
	for _t103 in J.iter(J.G.get("BOND_FEUDS")):
		v_F_148 = _t103
		var _t104 = J.seq(J.gp(v_F_148, "a"), J.gp(v_a_146, "k"))
		v_ab_149 = (J.seq(J.gp(v_F_148, "b"), J.gp(v_b_147, "k")) if _t104 else _t104)
		var _t105 = J.seq(J.gp(v_F_148, "a"), J.gp(v_b_147, "k"))
		v_ba_150 = (J.seq(J.gp(v_F_148, "b"), J.gp(v_a_146, "k")) if _t105 else _t105)
		var _t106 = (not J.t(v_ab_149))
		if ((not J.t(v_ba_150)) if _t106 else _t106):
			continue
		var _t107 = J.gp(J.gp(J.G.get("S"), "bonds"), "feud")
		v_f_151 = (J.gp(J.gp(J.gp(J.G.get("S"), "bonds"), "feud"), J.gp(v_F_148, "id")) if J.t(_t107) else _t107)
		var _t108 = (not J.t(v_f_151))
		if (_t108 if _t108 else (not J.t(J.gp(v_f_151, "st")))):
			return null
		var _t109 = J.gp(v_f_151, "end")
		return {"F": v_F_148, "state": (_t109 if J.t(_t109) else "fight"), "A": (v_a_146 if J.t(v_ab_149) else v_b_147), "B": (v_b_147 if J.t(v_ab_149) else v_a_146)}
	return null

func _f39(this_, a: Array, env):
	var v_x_161 = null; var v_i_162 = null
	v_x_161 = J.arg(a, 0)
	v_i_162 = J.arg(a, 1)
	return v_i_162

func _f40(this_, a: Array, env):
	var v_i_163 = null
	v_i_163 = J.arg(a, 0)
	var _t116 = (not J.t(J.mc(env["used"], "includes", [v_i_163])))
	if J.t(_t116):
		var _t115 = (not J.t(env["ok"]))
		if not J.t(_t115):
			var _t114 = env["ok"]
			_t115 = J.cl(_t114, null, [J.gp(env["list"], v_i_163)])
		_t116 = _t115
	return _t116

func _f41(this_, a: Array, env):
	var v_x_164 = null; var v_i_165 = null
	v_x_164 = J.arg(a, 0)
	v_i_165 = J.arg(a, 1)
	return v_i_165

func _f42(this_, a: Array, env):
	var v_i_166 = null
	v_i_166 = J.arg(a, 0)
	var _t121 = (not J.t(env["ok"]))
	if not J.t(_t121):
		var _t120 = env["ok"]
		_t121 = J.cl(_t120, null, [J.gp(env["list"], v_i_166)])
	return _t121

func _f38(this_, a: Array, env):
	var v_key_154 = null; var v_c_157 = null; var v_idx_159 = null; var v_i_160 = null
	var _s55 = {"__p": env, "list": null, "ok": null, "used": null}
	v_key_154 = J.arg(a, 0)
	_s55["list"] = J.arg(a, 1)
	_s55["ok"] = J.arg(a, 2)
	v_c_157 = J.cl(_s55["__p"]["st"], null, [])
	var _t110 = J.gp(v_c_157, "c")
	var _t111 = J.gp(J.gp(v_c_157, "c"), v_key_154)
	var _t112 = (_t111 if J.t(_t111) else [])
	J.sp(_t110, v_key_154, _t112)
	_s55["used"] = _t112
	var _t113 = J.mc(_s55["list"], "map", [Callable(self, "_f39").bind(_s55)])
	v_idx_159 = J.mc(_t113, "filter", [Callable(self, "_f40").bind(_s55)])
	if (not J.t(J.len(v_idx_159))):
		var _t117 = J.gp(v_c_157, "c")
		var _t118 = []
		J.sp(_t117, v_key_154, _t118)
		var _t119 = J.mc(_s55["list"], "map", [Callable(self, "_f41").bind(_s55)])
		var _t122 = J.mc(_t119, "filter", [Callable(self, "_f42").bind(_s55)])
		v_idx_159 = _t122
	if (not J.t(J.len(v_idx_159))):
		return null
	var _t123 = _s55["__p"]["rnd"]
	v_i_160 = J.cl(_t123, null, [v_idx_159])
	var _t124 = J.gp(J.gp(v_c_157, "c"), v_key_154)
	J.mc(_t124, "push", [v_i_160])
	return J.gp(_s55["list"], v_i_160)

func _f44(this_, a: Array, env):
	var v_p_177 = null
	v_p_177 = J.arg(a, 0)
	var _t128 = J.seq(J.gp(v_p_177, "a"), J.gp(env["a"], "k"))
	var _t130 = (J.seq(J.gp(v_p_177, "b"), J.gp(env["b"], "k")) if _t128 else _t128)
	if not J.t(_t130):
		var _t129 = J.seq(J.gp(v_p_177, "a"), J.gp(env["b"], "k"))
		_t130 = (J.seq(J.gp(v_p_177, "b"), J.gp(env["a"], "k")) if _t129 else _t129)
	return _t130

func _f45(this_, a: Array, env):
	var v_x_179 = null
	v_x_179 = J.arg(a, 0)
	var _t139 = env["__p"]["tagOk"]
	return J.cl(_t139, null, [J.gp(v_x_179, "tag"), null])

func _f43(this_, a: Array, env):
	var v_fd_171 = null; var v_pairs_172 = null; var v_cv_173 = null; var v_key_174 = null; var v_list_175 = null; var v_cv_176 = null; var v_cv_178 = null
	var _s61 = {"__p": env, "a": null, "b": null}
	_s61["a"] = J.arg(a, 0)
	_s61["b"] = J.arg(a, 1)
	var _t125 = _s61["__p"]["feudOf"]
	v_fd_171 = J.cl(_t125, null, [_s61["a"], _s61["b"]])
	if J.t(v_fd_171):
		v_key_174 = J.add(J.add(J.gp(J.gp(v_fd_171, "F"), "id"), ":"), J.gp(v_fd_171, "state"))
		v_list_175 = J.gp(J.gp(_s61["__p"]["D"], "feud"), v_key_174)
		if J.t(((randf() < 0.85) if J.t(v_list_175) else v_list_175)):
			var _t126 = _s61["__p"]["takeConv"]
			v_cv_176 = J.cl(_t126, null, [J.add("f:", v_key_174), v_list_175])
			if J.t(v_cv_176):
				return {"cv": v_cv_176, "A": J.gp(v_fd_171, "A"), "B": J.gp(v_fd_171, "B")}
	var _t127 = J.gp(_s61["__p"]["D"], "pair")
	v_pairs_172 = J.mc(_t127, "filter", [Callable(self, "_f44").bind(_s61)])
	var _t131 = J.len(v_pairs_172)
	var _t133 = ((randf() < 0.7) if J.t(_t131) else _t131)
	if J.t(_t133):
		var _t132 = _s61["__p"]["isFodder"]
		_t133 = (not J.t(J.cl(_t132, null, [_s61["a"]])))
	var _t135 = _t133
	if J.t(_t135):
		var _t134 = _s61["__p"]["isFodder"]
		_t135 = (not J.t(J.cl(_t134, null, [_s61["b"]])))
	if J.t(_t135):
		var _t136 = _s61["__p"]["takeConv"]
		var _t137 = J.mc([J.gp(_s61["a"], "k"), J.gp(_s61["b"], "k")], "sort", [])
		v_cv_178 = J.cl(_t136, null, [J.add("p:", J.mc(_t137, "join", ["+"])), v_pairs_172])
		if J.t(v_cv_178):
			return {"cv": v_cv_178, "A": (_s61["a"] if J.seq(J.gp(v_cv_178, "a"), J.gp(_s61["a"], "k")) else _s61["b"]), "B": (_s61["b"] if J.seq(J.gp(v_cv_178, "a"), J.gp(_s61["a"], "k")) else _s61["a"])}
	var _t138 = _s61["__p"]["takeConv"]
	v_cv_173 = J.cl(_t138, null, ["g", J.gp(_s61["__p"]["D"], "gen"), Callable(self, "_f45").bind(_s61)])
	return ({"cv": v_cv_173, "A": _s61["a"], "B": _s61["b"]} if J.t(v_cv_173) else null)

func _f47(this_, a: Array, env):
	var v_l_185 = null
	v_l_185 = J.arg(a, 0)
	var _t147 = J.gp(v_l_185, 0.0)
	var _t141 = env["__p"]["fill"]
	var _t142 = env["__p"]["pickT"]
	var _t143 = J.cl(_t141, null, [J.cl(_t142, null, [J.gp(v_l_185, 1.0), J.gp(v_l_185, 2.0)]), null])
	var _t144 = J.mc(_t143, "split", ["{A}"])
	var _t145 = J.mc(_t144, "join", [J.gp(env["names"], "A")])
	var _t146 = J.mc(_t145, "split", ["{B}"])
	return {"who": _t147, "text": J.mc(_t146, "join", [J.gp(env["names"], "B")]), "g": (J.gp(env["r"], "A") if J.seq(J.gp(v_l_185, 0.0), "A") else (J.gp(env["r"], "B") if J.seq(J.gp(v_l_185, 0.0), "B") else null))}

func _f46(this_, a: Array, env):
	var v_V_183 = null
	var _s67 = {"__p": env, "r": null, "names": null}
	_s67["r"] = J.arg(a, 0)
	v_V_183 = J.G.get("Village")
	_s67["names"] = {"A": J.gp(J.gp(_s67["r"], "A"), "name"), "B": J.gp(J.gp(_s67["r"], "B"), "name")}
	var _t140 = J.gp(J.gp(_s67["r"], "cv"), "lines")
	var _t148 = J.mc(_t140, "map", [Callable(self, "_f47").bind(_s67)])
	_s67["__p"]["queue"] = _t148
	_s67["__p"]["qOwner"] = _s67["r"]
	var _t149 = _s67["__p"]["next"]
	J.cl(_t149, null, [v_V_183])

func _f49(this_, a: Array, env):
	var v_o_191 = null
	v_o_191 = J.arg(a, 0)
	var _t151 = J.gp(v_o_191, "g")
	var _t152 = (env["qOwner"] if J.t(_t151) else _t151)
	return (J.seq(J.gp(J.gp(v_o_191, "g"), "id"), J.gp(J.gp(env["qOwner"], "A"), "id")) if J.t(_t152) else _t152)

func _f48(this_, a: Array, env):
	var v_V_188 = null; var v_it_189 = null; var v_v_190 = null; var v_e_192 = null
	v_V_188 = J.arg(a, 0)
	v_it_189 = J.mc(env["queue"], "shift", [])
	if (not J.t(v_it_189)):
		env["qOwner"] = null
		return null
	if (not J.t(J.gp(v_it_189, "g"))):
		var _t150 = J.gp(v_V_188, "vis")
		v_v_190 = J.mc(_t150, "find", [Callable(self, "_f49").bind(env)])
		J.mc(J.G.get("Fx"), "float", [(J.gp(v_v_190, "x") if J.t(v_v_190) else 195.0), (J.sub(J.gp(v_v_190, "y"), 90.0) if J.t(v_v_190) else 400.0), J.gp(v_it_189, "text"), "#d9ccff"])
		var _t153 = J.add(J.cl(env["now"], null, []), 1800.0)
		env["holdUntil"] = _t153
		return null
	var _t154 = {"id": J.gp(J.gp(v_it_189, "g"), "id"), "hero": false, "text": J.gp(v_it_189, "text"), "t": 0.9}
	J.sp(v_V_188, "bubble", _t154)

func _f51(this_, a: Array, env):
	var v_v_201 = null
	v_v_201 = J.arg(a, 0)
	var _t158 = J.cmp(J.gp(v_v_201, "y"), J.add(env["top"], 120.0), ">")
	var _t159 = (J.cmp(J.gp(v_v_201, "y"), env["bot"], "<") if _t158 else _t158)
	var _t161 = (J.gp(v_v_201, "g") if _t159 else _t159)
	if J.t(_t161):
		var _t160 = env["__p"]["poolOf"]
		_t161 = J.cl(_t160, null, [J.gp(v_v_201, "g")])
	var _t163 = _t161
	if J.t(_t163):
		var _t162 = (not J.t(J.gp(v_v_201, "hero")))
		_t163 = (_t162 if _t162 else J.cmp(J.gp(J.G.get("S"), "qi"), 3.0, ">"))
	return _t163

func _f52(this_, a: Array, env):
	var v_v_204 = null
	v_v_204 = J.arg(a, 0)
	return (not J.t(J.gp(v_v_204, "hero")))

func _f53(this_, a: Array, env):
	var v_x_210 = null; var v_y_211 = null
	v_x_210 = J.arg(a, 0)
	v_y_211 = J.arg(a, 1)
	var _t165 = env["__p"]["feudOf"]
	var _t167 = (1.0 if J.t(J.cl(_t165, null, [J.gp(v_y_211, 0.0), J.gp(v_y_211, 1.0)])) else 0.0)
	var _t166 = env["__p"]["feudOf"]
	var _t168 = (_t167 - (1.0 if J.t(J.cl(_t166, null, [J.gp(v_x_210, 0.0), J.gp(v_x_210, 1.0)])) else 0.0))
	return (_t168 if J.t(_t168) else J.sub(J.gp(v_x_210, 2.0), J.gp(v_y_211, 2.0)))

func _f50(this_, a: Array, env):
	var v_V_195 = null; var v_cand_198 = null; var v_v_199 = null; var v_line_200 = null; var v_np_202 = null; var v_pairs_203 = null; var v_i_205 = null; var v_j_206 = null; var v_d_207 = null; var v_p_208 = null; var v_r_209 = null
	var _s76 = {"__p": env, "top": null, "bot": null}
	v_V_195 = this_
	var _t155 = J.len(_s76["__p"]["queue"])
	if J.t((_t155 if J.t(_t155) else J.cmp(J.cl(_s76["__p"]["now"], null, []), _s76["__p"]["holdUntil"], "<"))):
		return null
	_s76["top"] = J.add(J.gp(v_V_195, "camY"), 60.0)
	_s76["bot"] = J.sub(J.add(J.gp(v_V_195, "camY"), J.div(J.gp(v_V_195, "h"), J.gp(v_V_195, "scale"))), 20.0)
	var _t156 = J.mc(J.G.get("Story"), "busy", [])
	if J.t((_t156 if J.t(_t156) else J.mc(J.G.get("UI"), "modalOpen", []))):
		return null
	var _t157 = J.gp(v_V_195, "vis")
	v_cand_198 = J.mc(_t157, "filter", [Callable(self, "_f51").bind(_s76)])
	if (not J.t(J.len(v_cand_198))):
		return null
	if (randf() < 0.38):
		v_np_202 = J.mc(v_cand_198, "filter", [Callable(self, "_f52").bind(_s76)])
		v_pairs_203 = []
		v_i_205 = 0.0
		while true:
			if not J.cmp(v_i_205, J.len(v_np_202), "<"): break
			v_j_206 = J.add(v_i_205, 1.0)
			while true:
				if not J.cmp(v_j_206, J.len(v_np_202), "<"): break
				v_d_207 = J.hypot_([J.sub(J.gp(J.gp(v_np_202, v_i_205), "x"), J.gp(J.gp(v_np_202, v_j_206), "x")), J.sub(J.gp(J.gp(v_np_202, v_i_205), "y"), J.gp(J.gp(v_np_202, v_j_206), "y"))])
				var _t164 = J.cmp(v_d_207, 130.0, "<")
				if ((not J.seq(J.gp(J.gp(J.gp(v_np_202, v_i_205), "g"), "id"), J.gp(J.gp(J.gp(v_np_202, v_j_206), "g"), "id"))) if _t164 else _t164):
					J.mc(v_pairs_203, "push", [[J.gp(J.gp(v_np_202, v_i_205), "g"), J.gp(J.gp(v_np_202, v_j_206), "g"), v_d_207]])
				v_j_206 = J.num(v_j_206) + 1.0
			v_i_205 = J.num(v_i_205) + 1.0
		if J.t(J.len(v_pairs_203)):
			J.mc(v_pairs_203, "sort", [Callable(self, "_f53").bind(_s76)])
			var _t170 = null
			if (randf() < 0.6):
				_t170 = J.gp(v_pairs_203, 0.0)
			else:
				var _t169 = _s76["__p"]["rnd"]
				_t170 = J.cl(_t169, null, [v_pairs_203])
			v_p_208 = _t170
			var _t171 = _s76["__p"]["convFor"]
			v_r_209 = J.cl(_t171, null, [J.gp(v_p_208, 0.0), J.gp(v_p_208, 1.0)])
			if J.t(v_r_209):
				var _t172 = _s76["__p"]["startConv"]
				J.cl(_t172, null, [v_r_209])
				var _t173 = (9.0 + (randf() * 5.0))
				J.sp(v_V_195, "chatT", _t173)
				return null
	var _t174 = _s76["__p"]["rnd"]
	v_v_199 = J.cl(_t174, null, [v_cand_198])
	var _t175 = _s76["__p"]["lineFor"]
	v_line_200 = J.cl(_t175, null, [J.gp(v_v_199, "g")])
	if (not J.t(v_line_200)):
		return null
	var _t176 = {"id": J.gp(J.gp(v_v_199, "g"), "id"), "hero": (not (not J.t(J.gp(v_v_199, "hero")))), "text": v_line_200, "t": 0.0}
	J.sp(v_V_195, "bubble", _t176)

func _f55(this_, a: Array, env):
	var v_e_222 = null; var v_i_223 = null
	v_e_222 = J.arg(a, 0)
	v_i_223 = J.arg(a, 1)
	return v_i_223

func _f56(this_, a: Array, env):
	var v_i_224 = null
	v_i_224 = J.arg(a, 0)
	var _t186 = (not J.t(J.mc(env["used"], "includes", [v_i_224])))
	if J.t(_t186):
		var _t185 = (not J.t(J.gp(J.gp(env["list"], v_i_224), "arch")))
		if not J.t(_t185):
			var _t184 = env["a"]
			if J.t(_t184):
				var _t183 = J.gp(J.gp(env["list"], v_i_224), "arch")
				_t184 = J.mc(_t183, "includes", [J.gp(env["a"], "id")])
			_t185 = _t184
		_t186 = _t185
	return _t186

func _f57(this_, a: Array, env):
	var v_e_225 = null; var v_i_226 = null
	v_e_225 = J.arg(a, 0)
	v_i_226 = J.arg(a, 1)
	return v_i_226

func _f58(this_, a: Array, env):
	var v_i_227 = null
	v_i_227 = J.arg(a, 0)
	var _t193 = (not J.t(J.gp(J.gp(env["list"], v_i_227), "arch")))
	if not J.t(_t193):
		var _t192 = env["a"]
		if J.t(_t192):
			var _t191 = J.gp(J.gp(env["list"], v_i_227), "arch")
			_t192 = J.mc(_t191, "includes", [J.gp(env["a"], "id")])
		_t193 = _t192
	return _t193

func _f59(this_, a: Array, env):
	var v_i_228 = null
	v_i_228 = J.arg(a, 0)
	return J.gp(J.gp(env["list"], v_i_228), "arch")

func _f54(this_, a: Array, env):
	var v_g_214 = null; var v_c_217 = null; var v_idx_219 = null; var v_mine_220 = null; var v_i_221 = null
	var _s86 = {"__p": env, "list": null, "a": null, "used": null}
	v_g_214 = J.arg(a, 0)
	_s86["list"] = J.gp(J.gp(_s86["__p"]["D"], "enter"), J.gp(v_g_214, "k"))
	if (not J.t(_s86["list"])):
		return null
	var _t177 = _s86["__p"]["archOf"]
	_s86["a"] = J.cl(_t177, null, [v_g_214])
	v_c_217 = J.cl(_s86["__p"]["st"], null, [])
	var _t178 = J.gp(v_c_217, "e")
	var _t179 = J.gp(v_g_214, "k")
	var _t180 = J.gp(J.gp(v_c_217, "e"), J.gp(v_g_214, "k"))
	var _t181 = (_t180 if J.t(_t180) else [])
	J.sp(_t178, _t179, _t181)
	_s86["used"] = _t181
	var _t182 = J.mc(_s86["list"], "map", [Callable(self, "_f55").bind(_s86)])
	v_idx_219 = J.mc(_t182, "filter", [Callable(self, "_f56").bind(_s86)])
	if (not J.t(J.len(v_idx_219))):
		var _t187 = J.gp(v_c_217, "e")
		var _t188 = J.gp(v_g_214, "k")
		var _t189 = []
		J.sp(_t187, _t188, _t189)
		var _t190 = J.mc(_s86["list"], "map", [Callable(self, "_f57").bind(_s86)])
		var _t194 = J.mc(_t190, "filter", [Callable(self, "_f58").bind(_s86)])
		v_idx_219 = _t194
	v_mine_220 = J.mc(v_idx_219, "filter", [Callable(self, "_f59").bind(_s86)])
	var _t195 = J.len(v_mine_220)
	var _t198 = null
	if J.t(((randf() < 0.55) if J.t(_t195) else _t195)):
		var _t196 = _s86["__p"]["rnd"]
		_t198 = J.cl(_t196, null, [v_mine_220])
	else:
		var _t197 = _s86["__p"]["rnd"]
		_t198 = J.cl(_t197, null, [v_idx_219])
	v_i_221 = _t198
	var _t199 = J.gp(J.gp(v_c_217, "e"), J.gp(v_g_214, "k"))
	J.mc(_t199, "push", [v_i_221])
	return J.gp(_s86["list"], v_i_221)

func _f60(this_, a: Array, env):
	var v_s_231 = null
	if J.t(J.S_document_("getElementById", ["gjoin-css"])):
		return null
	v_s_231 = J.S_document_("createElement", ["style"])
	J.sp(v_s_231, "id", "gjoin-css")
	var _t200 = ("#gjoin{position:absolute;left:10px;right:10px;top:calc(env(safe-area-inset-top) + 8px);z-index:62;display:none;background:linear-gradient(#2a2133,#1b1522);border-radius:12px;box-shadow:0 8px 24px rgba(0,0,0,.6),inset 0 0 0 1.5px #6a5236;color:#f4e6c4;overflow:hidden;cursor:pointer}\n#gjoin.on{display:flex;animation:gjin .25s ease-out}@keyframes gjin{from{transform:translateY(-30px);opacity:0}to{transform:none;opacity:1}}\n#gjoin canvas{width:118px;height:118px;flex:0 0 118px;background:radial-gradient(circle at 50% 70%,#3d3247,#1d1724)}\n#gjoin .gj-b{flex:1;padding:9px 34px 9px 10px;display:flex;flex-direction:column;justify-content:center;min-height:118px;box-sizing:border-box}\n#gjoin .gj-t{font-size:12px;color:#d9b36a;font-weight:800;letter-spacing:1px;margin-bottom:3px}\n#gjoin .gj-w{font-size:13px;color:#ff9f8a;font-weight:800}\n#gjoin .gj-x{font-size:15.5px;line-height:1.45;font-weight:700}\n#gjoin .gj-x.narr{color:#cbbfe0;font-weight:600;font-size:14.5px}\n#gjoin .gj-k{position:absolute;right:6px;top:6px;width:26px;height:26px;border-radius:13px;background:rgba(0,0,0,.35);color:#f4e6c4;font-size:15px;line-height:26px;text-align:center}\n#gjoin .gj-n{position:absolute;right:10px;bottom:6px;font-size:11px;color:#9c8fae}")
	J.sp(v_s_231, "textContent", _t200)
	var _t201 = J.gp(J.G.get("document"), "head")
	J.mc(_t201, "appendChild", [v_s_231])

func _f62(this_, a: Array, env):
	var v_l_243 = null
	v_l_243 = J.arg(a, 0)
	var _t218 = J.gp(v_l_243, 0.0)
	var _t216 = env["__p"]["fill"]
	var _t217 = env["__p"]["pickT"]
	return {"who": _t218, "text": J.cl(_t216, null, [J.cl(_t217, null, [J.gp(v_l_243, 1.0), J.gp(v_l_243, 2.0)]), env["g"]])}

func _f63(this_, a: Array, env):
	var v_l_244 = null; var v_w_245 = null; var v_x_246 = null
	if (not J.t(env["__p"]["ej"])):
		return null
	var _t221 = env["__p"]["ej"]
	J.sp(_t221, "i", J.num(J.gp(_t221, "i")) + 1.0)
	var _t222 = env["__p"]["ej"]
	J.sp(_t222, "lt", 0.0)
	if J.cmp(J.gp(env["__p"]["ej"], "i"), J.len(J.gp(env["__p"]["ej"], "lines")), ">="):
		J.cl(env["__p"]["closeEnter"], null, [])
		return null
	v_l_244 = J.gp(J.gp(env["__p"]["ej"], "lines"), J.gp(env["__p"]["ej"], "i"))
	v_w_245 = J.mc(env["el"], "querySelector", [".gj-w"])
	v_x_246 = J.mc(env["el"], "querySelector", [".gj-x"])
	var _t223 = ("" if J.seq(J.gp(v_l_244, "who"), "旁白") else (J.gp(env["g"], "name") if J.seq(J.gp(v_l_244, "who"), "G") else J.gp(v_l_244, "who")))
	J.sp(v_w_245, "textContent", _t223)
	var _t224 = ("gj-x" + (" narr" if J.seq(J.gp(v_l_244, "who"), "旁白") else ""))
	J.sp(v_x_246, "className", _t224)
	var _t225 = J.gp(v_l_244, "text")
	J.sp(v_x_246, "textContent", _t225)
	var _t226 = J.mc(env["el"], "querySelector", [".gj-n"])
	var _t227 = J.add(J.add(J.add(J.gp(env["__p"]["ej"], "i"), 1.0), "／"), J.len(J.gp(env["__p"]["ej"], "lines")))
	J.sp(_t226, "textContent", _t227)

func _f64(this_, a: Array, env):
	var v_ev_247 = null
	v_ev_247 = J.arg(a, 0)
	J.mc(v_ev_247, "stopPropagation", [])
	var _t231 = J.gp(J.gp(v_ev_247, "target"), "classList")
	if J.t(J.mc(_t231, "contains", ["gj-k"])):
		J.cl(env["__p"]["closeEnter"], null, [])
		return null
	J.cl(env["adv"], null, [])

func _f65(this_, a: Array, env):
	var v_tm_248 = null; var v_dt_249 = null
	v_tm_248 = J.arg(a, 0)
	if (not J.t(env["__p"]["ej"])):
		return null
	v_dt_249 = J.min_([0.05, J.div(J.sub(v_tm_248, J.gp(env["__p"]["ej"], "last")), 1000.0)])
	var _t233 = env["__p"]["ej"]
	J.sp(_t233, "last", v_tm_248)
	var _t234 = env["__p"]["ej"]
	var _t235 = J.add(J.gp(_t234, "t"), v_dt_249)
	J.sp(_t234, "t", _t235)
	var _t236 = env["__p"]["ej"]
	var _t237 = J.add(J.gp(_t236, "lt"), v_dt_249)
	J.sp(_t236, "lt", _t237)
	J.cl(env["__p"]["drawEnter"], null, [])
	if J.cmp(J.gp(env["__p"]["ej"], "lt"), J.max_([2.6, (J.len(J.gp(J.gp(J.gp(env["__p"]["ej"], "lines"), J.gp(env["__p"]["ej"], "i")), "text")) * 0.11)]), ">"):
		J.cl(env["adv"], null, [])
	if J.t(env["__p"]["ej"]):
		var _t238 = env["__p"]["ej"]
		var _t239 = J.F_requestAnimationFrame([env["loop"]])
		J.sp(_t238, "raf", _t239)

func _f61(this_, a: Array, env):
	var v_e_235 = null; var v_cv_237 = null; var v_dpr_238 = null; var v_a_239 = null; var v_lines_240 = null
	var _s94 = {"__p": env, "g": null, "el": null, "adv": null, "loop": null}
	_s94["g"] = J.arg(a, 0)
	v_e_235 = J.arg(a, 1)
	J.cl(_s94["__p"]["css"], null, [])
	_s94["el"] = J.S_document_("getElementById", ["gjoin"])
	if (not J.t(_s94["el"])):
		var _t202 = J.S_document_("createElement", ["div"])
		_s94["el"] = _t202
		var _t203 = _s94["el"]
		J.sp(_t203, "id", "gjoin")
		var _t204 = _s94["el"]
		var _t205 = "<canvas></canvas><div class=\"gj-b\"><div class=\"gj-t\"></div><div class=\"gj-w\"></div><div class=\"gj-x\"></div></div><div class=\"gj-k\">✕</div><div class=\"gj-n\"></div>"
		J.sp(_t204, "innerHTML", _t205)
		var _t206 = J.S_document_("getElementById", ["app"])
		var _t207 = (_t206 if J.t(_t206) else J.gp(J.G.get("document"), "body"))
		J.mc(_t207, "appendChild", [_s94["el"]])
	v_cv_237 = J.mc(_s94["el"], "querySelector", ["canvas"])
	var _t208 = J.gp(J.G.get("window"), "devicePixelRatio")
	var _t209 = J.gp(J.G.get("window"), "devicePixelRatio")
	v_dpr_238 = J.min_([2.0, (_t209 if J.t(_t209) else 1.0)])
	var _t210 = J.mul(118.0, v_dpr_238)
	J.sp(v_cv_237, "width", _t210)
	var _t211 = J.mul(118.0, v_dpr_238)
	J.sp(v_cv_237, "height", _t211)
	var _t212 = _s94["__p"]["archOf"]
	v_a_239 = J.cl(_t212, null, [_s94["g"]])
	var _t213 = J.mc(_s94["el"], "querySelector", [".gj-t"])
	var _t214 = ("新鬼入村・" + J.str(J.gp(_s94["g"], "name")) + ((J.add("（", J.gp(v_a_239, "label")) + "）") if J.t(v_a_239) else ""))
	J.sp(_t213, "textContent", _t214)
	var _t215 = J.gp(v_e_235, "lines")
	v_lines_240 = J.mc(_t215, "map", [Callable(self, "_f62").bind(_s94)])
	var _t219 = {"g": _s94["g"], "e": v_e_235, "lines": v_lines_240, "i": (-1.0), "t": 0.0, "lt": 0.0, "el": _s94["el"], "cv": v_cv_237, "dpr": v_dpr_238, "raf": 0.0, "last": J.S_performance_("now", [])}
	_s94["__p"]["ej"] = _t219
	_s94["__p"]["enterBusy"] = true
	var _t220 = _s94["el"]
	J.sp(_t220, "className", "on")
	_s94["adv"] = Callable(self, "_f63").bind(_s94)
	var _t228 = _s94["__p"]["ej"]
	var _t229 = _s94["adv"]
	J.sp(_t228, "adv", _t229)
	J.cl(_s94["adv"], null, [])
	var _t230 = _s94["el"]
	var _t232 = Callable(self, "_f64").bind(_s94)
	J.sp(_t230, "onclick", _t232)
	_s94["loop"] = Callable(self, "_f65").bind(_s94)
	var _t240 = _s94["__p"]["ej"]
	var _t241 = J.F_requestAnimationFrame([_s94["loop"]])
	J.sp(_t240, "raf", _t241)

func _f66(this_, a: Array, env):
	if (not J.t(env["ej"])):
		return null
	J.F_cancelAnimationFrame([J.gp(env["ej"], "raf")])
	var _t242 = J.gp(env["ej"], "el")
	J.sp(_t242, "className", "")
	env["ej"] = null
	env["enterBusy"] = false

func _f68(this_, a: Array, env):
	var v_dx_276 = null; var v_a2_277 = null; var v_px_278 = null; var v_py_279 = null; var v_err_280 = null
	v_dx_276 = J.arg(a, 0)
	v_a2_277 = J.arg(a, 1)
	J.mc(env["ctx"], "save", [])
	J.mc(env["ctx"], "setTransform", [J.mul(env["dpr"], env["K"]), 0.0, 0.0, J.mul(env["dpr"], env["K"]), 0.0, 0.0])
	var _t285 = env["ctx"]
	var _t286 = J.mul(env["alpha"], v_a2_277)
	J.sp(_t285, "globalAlpha", _t286)
	v_px_278 = J.div(J.add(env["x"], v_dx_276), env["K"])
	v_py_279 = J.div(env["y"], env["K"])
	J.mc(env["ctx"], "translate", [v_px_278, v_py_279])
	J.mc(env["ctx"], "rotate", [env["rot"]])
	J.mc(env["ctx"], "translate", [(-J.num(v_px_278)), (-J.num(v_py_279))])
	J.mc(J.G.get("ART"), "drawChar", [env["ctx"], J.gp(env["g"], "k"), v_px_278, v_py_279, env["SC"], {"t": J.mul(env["t"], 1.3), "walk": env["walk"], "flip": env["flip"], "tamed": true, "untied": true, "act": ("plaza_sniff" if J.seq(env["mo"], "sniff") else (null if J.seq(env["mo"], "run") else null)), "at": env["t"]}])
	J.mc(env["ctx"], "restore", [])

func _f67(this_, a: Array, env):
	var v_cv_254 = null; var v_e_257 = null; var v_W_260 = null; var v_H_261 = null; var v_ch_263 = null; var v_enterP_266 = null; var v_ease_267 = null; var v_draw_274 = null; var v_p_275 = null; var v_i_281 = null; var v_yy_282 = null
	var _s103 = {"__p": env, "dpr": null, "g": null, "t": null, "ctx": null, "SC": null, "K": null, "mo": null, "x": null, "y": null, "rot": null, "alpha": null, "walk": null, "flip": null}
	var _t243 = _s103["__p"]["ej"]
	var _t244 = J.gp(_t243, "cv")
	v_cv_254 = _t244
	var _t245 = J.gp(_t243, "dpr")
	_s103["dpr"] = _t245
	var _t246 = J.gp(_t243, "g")
	_s103["g"] = _t246
	var _t247 = J.gp(_t243, "e")
	v_e_257 = _t247
	var _t248 = J.gp(_t243, "t")
	_s103["t"] = _t248
	_s103["ctx"] = J.mc(v_cv_254, "getContext", ["2d"])
	v_W_260 = 118.0
	v_H_261 = 118.0
	_s103["SC"] = (J.gp(J.G.get("PlazaLife"), "SC") if (not J.seq(J.typeof_(J.G.get("PlazaLife")), "undefined")) else 0.58)
	J.mc(_s103["ctx"], "setTransform", [_s103["dpr"], 0.0, 0.0, _s103["dpr"], 0.0, 0.0])
	J.mc(_s103["ctx"], "clearRect", [0.0, 0.0, v_W_260, v_H_261])
	var _t249 = _s103["ctx"]
	J.sp(_t249, "fillStyle", "rgba(0,0,0,.35)")
	J.mc(_s103["ctx"], "beginPath", [])
	J.mc(_s103["ctx"], "ellipse", [J.div(v_W_260, 2.0), J.sub(v_H_261, 14.0), 26.0, 6.0, 0.0, 0.0, (PI * 2.0)])
	J.mc(_s103["ctx"], "fill", [])
	var _t250 = (not J.seq(J.typeof_(J.G.get("ART")), "undefined"))
	var _t251 = (J.gp(J.G.get("ART"), "CHAR_H") if _t250 else _t250)
	var _t252 = (J.gp(J.gp(J.G.get("ART"), "CHAR_H"), J.gp(_s103["g"], "k")) if J.t(_t251) else _t251)
	v_ch_263 = J.mul((_t252 if J.t(_t252) else 56.0), _s103["SC"])
	_s103["K"] = J.div(78.0, v_ch_263)
	_s103["mo"] = J.gp(v_e_257, "mo")
	v_enterP_266 = J.min_([1.0, J.div(_s103["t"], 0.9)])
	v_ease_267 = (1.0 - pow(J.num(J.sub(1.0, v_enterP_266)), J.num(3.0)))
	_s103["x"] = J.div(v_W_260, 2.0)
	_s103["y"] = J.sub(v_H_261, 14.0)
	_s103["rot"] = 0.0
	_s103["alpha"] = 1.0
	_s103["walk"] = J.cmp(v_enterP_266, 1.0, "<")
	_s103["flip"] = false
	if J.seq(_s103["mo"], "fall"):
		var _t253 = ((-10.0) + J.mul(J.sub(v_H_261, 4.0), v_ease_267))
		_s103["y"] = _t253
		var _t254 = (J.mul(_s103["t"], 9.0) if J.cmp(v_enterP_266, 1.0, "<") else 0.0)
		_s103["rot"] = _t254
	else:
		if J.seq(_s103["mo"], "wind"):
			var _t255 = ((-30.0) + J.mul((J.div(v_W_260, 2.0) + 30.0), v_ease_267))
			_s103["x"] = _t255
			var _t256 = (J.sub(v_H_261, 14.0) - ((sin(J.num(J.mul(_s103["t"], 3.0))) * 6.0) * (1.0 - J.mul(v_enterP_266, 0.5))))
			_s103["y"] = _t256
			var _t257 = (sin(J.num(J.mul(_s103["t"], 4.0))) * 0.25)
			_s103["rot"] = _t257
		else:
			var _t258 = J.seq(_s103["mo"], "rise")
			if (_t258 if _t258 else J.seq(_s103["mo"], "pop")):
				var _t259 = J.sub(J.add(v_H_261, 70.0), J.mul(84.0, v_ease_267))
				_s103["y"] = _t259
			else:
				if J.seq(_s103["mo"], "fast"):
					v_p_275 = J.min_([1.0, J.div(_s103["t"], 0.5)])
					var _t260 = (((-40.0) + J.mul((J.div(v_W_260, 2.0) + 70.0), v_p_275)) - (J.max_([0.0, (30.0 - (J.sub(_s103["t"], 0.5) * 60.0))]) if J.cmp(v_p_275, 1.0, ">=") else 0.0))
					_s103["x"] = _t260
				else:
					if J.seq(_s103["mo"], "float"):
						var _t261 = ((-30.0) + J.mul((J.div(v_W_260, 2.0) + 30.0), v_ease_267))
						_s103["x"] = _t261
						var _t262 = (J.sub(v_H_261, 18.0) - (sin(J.num(J.mul(_s103["t"], 2.2))) * 4.0))
						_s103["y"] = _t262
						_s103["alpha"] = 0.85
					else:
						var _t263 = ((-30.0) + J.mul((J.div(v_W_260, 2.0) + 30.0), v_ease_267))
						_s103["x"] = _t263
	var _t264 = J.seq(_s103["mo"], "hop")
	var _t265 = (_t264 if _t264 else J.seq(_s103["mo"], "crash"))
	var _t266 = (_t265 if _t265 else J.seq(_s103["mo"], "row"))
	var _t267 = (_t266 if _t266 else J.seq(_s103["mo"], "bow"))
	var _t268 = (_t267 if _t267 else J.seq(_s103["mo"], "blind"))
	var _t269 = (_t268 if _t268 else J.seq(_s103["mo"], "resume"))
	if (_t269 if _t269 else J.seq(_s103["mo"], "dance")):
		var _t271 = absf(J.num(sin(J.num(J.mul(_s103["t"], 6.0)))))
		var _t270 = J.cmp(v_enterP_266, 1.0, "<")
		var _t272 = J.sub(_s103["y"], (_t271 * (12.0 if (_t270 if _t270 else J.seq(_s103["mo"], "dance")) else 3.0)))
		_s103["y"] = _t272
		_s103["walk"] = false
	var _t273 = J.seq(_s103["mo"], "crash")
	var _t274 = (J.cmp(_s103["t"], 0.9, ">") if _t273 else _t273)
	if (J.cmp(_s103["t"], 1.3, "<") if _t274 else _t274):
		var _t275 = J.add(_s103["x"], (sin(J.num(J.mul(_s103["t"], 80.0))) * 3.0))
		_s103["x"] = _t275
		if J.cmp(_s103["t"], 1.25, "<"):
			var _t276 = _s103["ctx"]
			J.sp(_t276, "fillStyle", "#ffe9a8")
			var _t277 = _s103["ctx"]
			J.sp(_t277, "font", "900 18px sans-serif")
			J.mc(_s103["ctx"], "fillText", ["咚！", (J.div(v_W_260, 2.0) + 8.0), 26.0])
	var _t278 = J.seq(_s103["mo"], "bow")
	if (J.cmp(_s103["t"], 1.1, ">") if _t278 else _t278):
		var _t279 = J.min_([0.9, (J.sub(_s103["t"], 1.1) * 2.0)])
		_s103["rot"] = _t279
	if J.seq(_s103["mo"], "dance"):
		var _t280 = (sin(J.num(J.mul(_s103["t"], 5.0))) * 0.2)
		_s103["rot"] = _t280
		var _t281 = (sin(J.num(J.mul(_s103["t"], 2.5))) > 0.0)
		_s103["flip"] = _t281
	var _t282 = J.seq(_s103["mo"], "grab")
	if (J.cmp(_s103["t"], 1.2, "<") if _t282 else _t282):
		var _t283 = _s103["ctx"]
		J.sp(_t283, "fillStyle", "#4caf50")
		J.mc(_s103["ctx"], "fillRect", [((J.mul(v_W_260, J.div(_s103["t"], 1.2)) * 1.4) - 70.0), J.sub(v_H_261, 32.0), 52.0, 18.0])
		var _t284 = _s103["ctx"]
		J.sp(_t284, "fillStyle", "#222")
		J.mc(_s103["ctx"], "beginPath", [])
		J.mc(_s103["ctx"], "arc", [((J.mul(v_W_260, J.div(_s103["t"], 1.2)) * 1.4) - 58.0), J.sub(v_H_261, 13.0), 5.0, 0.0, 7.0])
		J.mc(_s103["ctx"], "arc", [((J.mul(v_W_260, J.div(_s103["t"], 1.2)) * 1.4) - 28.0), J.sub(v_H_261, 13.0), 5.0, 0.0, 7.0])
		J.mc(_s103["ctx"], "fill", [])
	v_draw_274 = Callable(self, "_f68").bind(_s103)
	if J.seq(_s103["mo"], "row"):
		if J.cmp(_s103["t"], 2.2, "<"):
			J.cl(v_draw_274, null, [(-34.0), 0.55])
			J.cl(v_draw_274, null, [34.0, 0.55])
	J.cl(v_draw_274, null, [0.0, 1.0])
	var _t287 = J.seq(_s103["mo"], "drip")
	if (_t287 if _t287 else J.seq(_s103["mo"], "rise")):
		var _t288 = _s103["ctx"]
		J.sp(_t288, "fillStyle", "rgba(150,200,255,.8)")
		v_i_281 = 0.0
		while true:
			if not J.cmp(v_i_281, 3.0, "<"): break
			v_yy_282 = (J.sub(v_H_261, 60.0) + J.mod((J.mul(_s103["t"], 40.0) + J.mul(v_i_281, 17.0)), 40.0))
			J.mc(_s103["ctx"], "fillRect", [(J.sub(_s103["x"], 10.0) + J.mul(v_i_281, 9.0)), v_yy_282, 2.0, 4.0])
			v_i_281 = J.num(v_i_281) + 1.0
	if J.seq(_s103["mo"], "blind"):
		var _t289 = _s103["ctx"]
		J.sp(_t289, "fillStyle", "#ffe9a8")
		var _t290 = _s103["ctx"]
		J.sp(_t290, "font", "900 12px sans-serif")
		J.mc(_s103["ctx"], "fillText", ["？", J.add(_s103["x"], 18.0), (J.sub(_s103["y"], 70.0) + (sin(J.num(J.mul(_s103["t"], 3.0))) * 3.0))])
	var _t291 = J.seq(_s103["mo"], "resume")
	if (J.cmp(_s103["t"], 0.9, ">") if _t291 else _t291):
		var _t292 = _s103["ctx"]
		J.sp(_t292, "fillStyle", "#f4ecd6")
		J.mc(_s103["ctx"], "fillRect", [J.add(_s103["x"], 16.0), J.sub(_s103["y"], 52.0), 16.0, 20.0])
		var _t293 = _s103["ctx"]
		J.sp(_t293, "strokeStyle", "#8a7a5a")
		J.mc(_s103["ctx"], "strokeRect", [J.add(_s103["x"], 16.0), J.sub(_s103["y"], 52.0), 16.0, 20.0])

func _f70(this_, a: Array, env):
	var v_x_289 = null
	v_x_289 = J.arg(a, 0)
	return (J.sub(env["t"], v_x_289) < 15000.0)

func _f71(this_, a: Array, env):
	var _t309 = env["__p"]["playEnter"]
	return J.cl(_t309, null, [env["g"], env["e"]])

func _f69(this_, a: Array, env):
	var v_busy_288 = null; var v_s_290 = null; var v_er_291 = null
	var _s126 = {"__p": env, "g": null, "t": null, "e": null}
	_s126["g"] = J.arg(a, 0)
	var _t295 = (not J.t(_s126["g"]))
	if not J.t(_t295):
		var _t294 = _s126["__p"]["isFodder"]
		_t295 = (not J.t(J.cl(_t294, null, [_s126["g"]])))
	if _t295:
		return null
	var _t296 = _s126["__p"]["archOf"]
	J.cl(_t296, null, [_s126["g"], true])
	var _t297 = _s126["__p"]["mark"]
	J.cl(_t297, null, ["new", J.gp(_s126["g"], "name")])
	_s126["t"] = J.cl(_s126["__p"]["now"], null, [])
	var _t298 = J.mc(_s126["__p"]["recent"], "filter", [Callable(self, "_f70").bind(_s126)])
	_s126["__p"]["recent"] = _t298
	J.mc(_s126["__p"]["recent"], "push", [_s126["t"]])
	var _t299 = _s126["__p"]["enterFor"]
	_s126["e"] = J.cl(_t299, null, [_s126["g"]])
	if (not J.t(_s126["e"])):
		return null
	var _t301 = (_s126["__p"]["enterBusy"] if J.t(_s126["__p"]["enterBusy"]) else (J.len(_s126["__p"]["recent"]) >= 3.0))
	if not J.t(_t301):
		var _t300 = (not J.seq(J.typeof_(J.G.get("Battle")), "undefined"))
		_t301 = (J.gp(J.G.get("Battle"), "active") if _t300 else _t300)
	var _t303 = _t301
	if not J.t(_t303):
		var _t302 = (not J.seq(J.typeof_(J.G.get("Theater")), "undefined"))
		_t303 = (J.gp(J.G.get("Theater"), "on") if _t302 else _t302)
	v_busy_288 = _t303
	if J.t(v_busy_288):
		var _t306 = null
		if J.t(J.gp(_s126["e"], "toast")):
			var _t304 = _s126["__p"]["pickT"]
			_t306 = J.cl(_t304, null, [J.gp(J.gp(_s126["e"], "toast"), 0.0), J.gp(J.gp(_s126["e"], "toast"), 1.0)])
		else:
			var _t305 = J.gp(J.gp(_s126["e"], "lines"), (J.len(J.gp(_s126["e"], "lines")) - 1.0))
			_t306 = J.gp((_t305 if J.t(_t305) else []), 2.0)
		v_s_290 = _t306
		var _t308 = J.gp(_s126["g"], "name")
		var _t307 = _s126["__p"]["fill"]
		J.mc(J.G.get("Fx"), "toast", [("<b>" + J.str(_t308) + "</b>：" + J.str(J.cl(_t307, null, [v_s_290, _s126["g"]])))])
		return null
	J.F_setTimeout([Callable(self, "_f71").bind(_s126), 250.0])

func _f74(this_, a: Array, env):
	var v_x_302 = null
	v_x_302 = J.arg(a, 0)
	return J.seq(J.gp(v_x_302, "id"), env["id"])

func _f75(this_, a: Array, env):
	var v_x_304 = null
	v_x_304 = J.arg(a, 0)
	return J.seq(J.gp(v_x_304, "name"), J.gp(env["nm"], "textContent"))

func _f73(this_, a: Array, env):
	var v_c_295 = null; var v_up_296 = null; var v_main_297 = null; var v_g_298 = null; var v_a_300 = null; var v_e_301 = null
	var _s134 = {"__p": env, "id": null}
	v_c_295 = J.arg(a, 0)
	if J.t(J.mc(v_c_295, "querySelector", [".archln"])):
		return null
	v_up_296 = J.mc(v_c_295, "querySelector", ["[data-up],[data-rel]"])
	v_main_297 = J.mc(v_c_295, "querySelector", [".gc-main"])
	if (not J.t(v_main_297)):
		return null
	v_g_298 = null
	var _t313 = v_up_296
	if J.t(_t313):
		var _t312 = J.gp(J.gp(v_up_296, "dataset"), "up")
		_t313 = (_t312 if J.t(_t312) else J.gp(J.gp(v_up_296, "dataset"), "rel"))
	_s134["id"] = _t313
	if J.t(_s134["id"]):
		var _t314 = J.gp(J.G.get("S"), "ghosts")
		var _t315 = J.mc(_t314, "find", [Callable(self, "_f74").bind(_s134)])
		v_g_298 = _t315
	if (not J.t(v_g_298)):
		var _s136 = {"__p": _s134, "nm": null}
		_s136["nm"] = J.mc(v_main_297, "querySelector", ["b"])
		var _t317 = _s136["nm"]
		if J.t(_t317):
			var _t316 = J.gp(J.G.get("S"), "ghosts")
			_t317 = J.mc(_t316, "find", [Callable(self, "_f75").bind(_s136)])
		v_g_298 = _t317
	var _t318 = _s134["__p"]["isFodder"]
	if (not J.t(J.cl(_t318, null, [v_g_298]))):
		return null
	var _t319 = _s134["__p"]["archOf"]
	v_a_300 = J.cl(_t319, null, [v_g_298])
	v_e_301 = J.S_document_("createElement", ["small"])
	J.sp(v_e_301, "className", "tr archln")
	var _t320 = J.gp(v_e_301, "style")
	J.sp(_t320, "color", "#7a4a9a")
	var _t322 = J.gp(v_a_300, "label")
	var _t321 = _s134["__p"]["sample"]
	var _t323 = ("性格：" + J.str(_t322) + "　「" + J.str(J.cl(_t321, null, [v_g_298])) + "」")
	J.sp(v_e_301, "textContent", _t323)
	J.mc(v_main_297, "appendChild", [v_e_301])

func _f72(this_, a: Array, env):
	var v_sh_294 = null
	v_sh_294 = J.S_document_("querySelector", ["#sheet"])
	var _t310 = (not J.t(v_sh_294))
	if (_t310 if _t310 else (not J.t(J.G.get("S")))):
		return null
	var _t311 = J.mc(v_sh_294, "querySelectorAll", [".gcard"])
	J.mc(_t311, "forEach", [Callable(self, "_f73").bind(env)])

func _f77(this_, a: Array, env):
	var v_r_311 = null; var v_e_312 = null
	v_r_311 = J.mc(env["ou"], "apply", [this_, a])
	var _t327 = J.len(env["__p"]["__p"]["queue"])
	var _t328 = ((not J.t(J.gp(this_, "bubble"))) if J.t(_t327) else _t327)
	if J.t((J.cmp(J.cl(env["__p"]["__p"]["now"], null, []), env["__p"]["__p"]["holdUntil"], ">=") if J.t(_t328) else _t328)):
		var _t329 = env["__p"]["__p"]["next"]
		J.cl(_t329, null, [this_])
	return v_r_311

func _f78(this_, a: Array, env):
	var v_g_316 = null; var v_e_317 = null
	v_g_316 = J.mc(env["orf"], "apply", [this_, a])
	var _t331 = env["__p"]["__p"]["onRecruit"]
	J.cl(_t331, null, [v_g_316])
	return v_g_316

func _f80(this_, a: Array, env):
	var v_g_325 = null
	v_g_325 = J.arg(a, 0)
	return J.seq(J.gp(v_g_325, "k"), env["k"])

func _f81(this_, a: Array, env):
	var v_g_326 = null
	v_g_326 = J.arg(a, 0)
	return J.seq(J.gp(v_g_326, "k"), env["k"])

func _f79(this_, a: Array, env):
	var v_had_323 = null; var v_r_324 = null
	var _s153 = {"__p": env, "k": null}
	_s153["k"] = J.arg(a, 0)
	var _t335 = J.gp(J.G.get("S"), "ghosts")
	v_had_323 = J.mc(_t335, "some", [Callable(self, "_f80").bind(_s153)])
	v_r_324 = J.mc(_s153["__p"]["oj"], "apply", [this_, a])
	var _t337 = (not J.t(v_had_323))
	if J.t(_t337):
		var _t336 = J.gp(J.G.get("S"), "ghosts")
		_t337 = J.mc(_t336, "some", [Callable(self, "_f81").bind(_s153)])
	if J.t(_t337):
		var _t338 = _s153["__p"]["__p"]["__p"]["mark"]
		J.cl(_t338, null, ["new", (J.gp(J.gp(J.G.get("GHOSTS"), _s153["k"]), "name") if J.t(J.gp(J.G.get("GHOSTS"), _s153["k"])) else _s153["k"])])
	return v_r_324

func _f82(this_, a: Array, env):
	var v_win_331 = null; var v_e_332 = null
	v_win_331 = J.arg(a, 0)
	if (not J.t(J.gp(this_, "result"))):
		var _t344 = env["__p"]["__p"]["mark"]
		J.cl(_t344, null, [("win" if J.t(v_win_331) else "lose")])
	return J.mc(env["of"], "apply", [this_, a])

func _f84(this_, a: Array, env):
	var v_c_338 = null
	v_c_338 = J.arg(a, 0)
	return J.gp(v_c_338, 0.0)

func _f83(this_, a: Array, env):
	var v_sc_336 = null; var v_n_337 = null; var v_e_339 = null
	v_sc_336 = J.arg(a, 0)
	var _t348 = (J.gp(v_sc_336, "cast") if J.t(v_sc_336) else v_sc_336)
	var _t349 = (_t348 if J.t(_t348) else [])
	v_n_337 = J.mc(_t349, "map", [Callable(self, "_f84").bind(env)])
	if J.t(J.mc(v_n_337, "includes", ["龐總"])):
		var _t350 = env["__p"]["__p"]["mark"]
		J.cl(_t350, null, ["boss"])
	if J.t(J.mc(v_n_337, "includes", ["Bryan"])):
		var _t351 = env["__p"]["__p"]["mark"]
		J.cl(_t351, null, ["rival"])
	if J.t(J.mc(v_n_337, "includes", ["冼小姐"])):
		var _t352 = env["__p"]["__p"]["mark"]
		J.cl(_t352, null, ["hr"])
	return J.mc(env["op"], "apply", [this_, a])

func _f85(this_, a: Array, env):
	var v_g_340 = null
	v_g_340 = J.arg(a, 0)
	var _t356 = env["__p"]["isFodder"]
	if J.t(J.cl(_t356, null, [v_g_340])):
		var _t357 = env["__p"]["archOf"]
		J.cl(_t357, null, [v_g_340])

func _f86(this_, a: Array, env):
	if J.t(J.mc(env["sh"], "querySelector", [".gcard"])):
		J.cl(env["__p"]["paintRoster"], null, [])

func _f76(this_, a: Array, env):
	var v_e_318 = null; var v_e_327 = null
	var _s138 = {"__p": env, "sh": null}
	if J.t(_s138["__p"]["started"]):
		return null
	_s138["__p"]["started"] = true
	if (not J.seq(J.typeof_(J.G.get("Village")), "undefined")):
		var _s139 = {"__p": _s138, "ou": null}
		var _t324 = J.G.get("Village")
		var _t325 = _s139["__p"]["__p"]["pickChatter"]
		J.sp(_t324, "pickChatter", _t325)
		_s139["ou"] = J.gp(J.G.get("Village"), "update")
		if J.t(_s139["ou"]):
			var _t326 = J.G.get("Village")
			var _t330 = Callable(self, "_f77").bind(_s139)
			J.sp(_t326, "update", _t330)
	if J.seq(J.typeof_(J.G.get("recruitFodder")), "function"):
		var _s144 = {"__p": _s138, "orf": null}
		_s144["orf"] = J.G.get("recruitFodder")
		J.G["recruitFodder"] = Callable(self, "_f78").bind(_s144)
		var _t332 = J.gp(J.G.get("window"), "G")
		if J.t((J.gp(J.gp(J.G.get("window"), "G"), "recruitFodder") if J.t(_t332) else _t332)):
			var _t333 = J.gp(J.G.get("window"), "G")
			var _t334 = J.G.get("recruitFodder")
			J.sp(_t333, "recruitFodder", _t334)
	if J.seq(J.typeof_(J.G.get("joinGhost")), "function"):
		var _s152 = {"__p": _s138, "oj": null}
		_s152["oj"] = J.G.get("joinGhost")
		J.G["joinGhost"] = Callable(self, "_f79").bind(_s152)
		var _t339 = J.gp(J.G.get("window"), "G")
		if J.t((J.gp(J.gp(J.G.get("window"), "G"), "joinGhost") if J.t(_t339) else _t339)):
			var _t340 = J.gp(J.G.get("window"), "G")
			var _t341 = J.G.get("joinGhost")
			J.sp(_t340, "joinGhost", _t341)
	var _t342 = (not J.seq(J.typeof_(J.G.get("Battle")), "undefined"))
	if J.t((J.gp(J.G.get("Battle"), "finish") if _t342 else _t342)):
		var _s159 = {"__p": _s138, "of": null}
		_s159["of"] = J.gp(J.G.get("Battle"), "finish")
		var _t343 = J.G.get("Battle")
		var _t345 = Callable(self, "_f82").bind(_s159)
		J.sp(_t343, "finish", _t345)
	var _t346 = (not J.seq(J.typeof_(J.G.get("Theater")), "undefined"))
	if J.t((J.gp(J.G.get("Theater"), "play") if _t346 else _t346)):
		var _s164 = {"__p": _s138, "op": null}
		_s164["op"] = J.gp(J.G.get("Theater"), "play")
		var _t347 = J.G.get("Theater")
		var _t353 = Callable(self, "_f83").bind(_s164)
		J.sp(_t347, "play", _t353)
	var _t354 = (J.gp(J.G.get("S"), "ghosts") if J.t(J.G.get("S")) else J.G.get("S"))
	var _t355 = (_t354 if J.t(_t354) else [])
	J.mc(_t355, "forEach", [Callable(self, "_f85").bind(_s138)])
	_s138["sh"] = J.S_document_("querySelector", ["#sheet"])
	if J.t(((not J.seq(J.typeof_(J.G.get("MutationObserver")), "undefined")) if J.t(_s138["sh"]) else _s138["sh"])):
		var _t358 = J.new_("MutationObserver", [Callable(self, "_f86").bind(_s138)])
		J.mc(_t358, "observe", [_s138["sh"], {"childList": true, "subtree": true}])

func _f2(this_, a: Array, env):
	var _t359 = J.seq(J.typeof_(J.G.get("LANG")), "undefined")
	return (_t359 if _t359 else (not J.seq(J.gp(J.G.get("LANG"), "cur"), "yue")))

func _f3(this_, a: Array, env):
	var v_y_48 = null; var v_z_49 = null
	v_y_48 = J.arg(a, 0)
	v_z_49 = J.arg(a, 1)
	return (v_z_49 if J.t(J.cl(env["zh"], null, [])) else v_y_48)

func _f4(this_, a: Array, env):
	var v_a_50 = null
	v_a_50 = J.arg(a, 0)
	return J.gp(v_a_50, floor(J.num((randf() * J.len(v_a_50)))))

func _f5(this_, a: Array, env):
	return J.S_Date_("now", [])

func _f7(this_, a: Array, env):
	var v_id_54 = null
	v_id_54 = J.arg(a, 0)
	var _t360 = (J.gp(J.G.get("S"), "seen") if J.t(J.G.get("S")) else J.G.get("S"))
	return (not (not J.t((J.gp(J.gp(J.G.get("S"), "seen"), v_id_54) if J.t(_t360) else _t360))))

func _f10(this_, a: Array, env):
	var v_g_64 = null
	v_g_64 = J.arg(a, 0)
	var _t362 = v_g_64
	if J.t(_t362):
		var _t361 = J.seq(J.gp(v_g_64, "q"), "藍")
		_t362 = (_t361 if _t361 else J.seq(J.gp(v_g_64, "q"), "紫"))
	return (J.gp(J.gp(env["D"], "arch"), J.gp(v_g_64, "k")) if J.t(_t362) else _t362)

func _f21(this_, a: Array, env):
	var v_t_105 = null
	v_t_105 = J.arg(a, 0)
	return J.mc(env["EVENT_TAGS"], "includes", [v_t_105])

func _f20(this_, a: Array, env):
	var v_tag_104 = null
	v_tag_104 = J.arg(a, 0)
	var _t364 = v_tag_104
	if J.t(_t364):
		var _t363 = J.mc(v_tag_104, "split", [","])
		_t364 = J.mc(_t363, "some", [Callable(self, "_f21").bind(env)])
	return _t364

func _f23(this_, a: Array, env):
	var v_t_107 = null
	v_t_107 = J.arg(a, 0)
	var _t366 = J.seq(v_t_107, "夜")
	var _t367 = (_t366 if _t366 else J.seq(v_t_107, "晨"))
	var _t368 = (_t367 if _t367 else J.seq(J.mc(v_t_107, "indexOf", ["p:"]), 0.0))
	return (_t368 if _t368 else J.seq(J.mc(v_t_107, "indexOf", ["arc:"]), 0.0))

func _f22(this_, a: Array, env):
	var v_tag_106 = null
	v_tag_106 = J.arg(a, 0)
	var _t369 = v_tag_106
	if J.t(_t369):
		var _t365 = J.mc(v_tag_106, "split", [","])
		_t369 = J.mc(_t365, "some", [Callable(self, "_f23").bind(env)])
	return _t369

func _f87(this_, a: Array, env):
	var v_a_341 = null; var v_b_342 = null; var v_r_343 = null
	v_a_341 = J.arg(a, 0)
	v_b_342 = J.arg(a, 1)
	var _t370 = env["convFor"]
	v_r_343 = J.cl(_t370, null, [v_a_341, v_b_342])
	if J.t(v_r_343):
		var _t371 = env["startConv"]
		J.cl(_t371, null, [v_r_343])
	return v_r_343

func _f88(this_, a: Array, env):
	return env["enterBusy"]

func _f1(this_, a: Array, env):
	var v_init_46 = null; var v_demo_47 = null
	var _s2 = {"__p": env, "D": null, "zh": null, "pickT": null, "rnd": null, "now": null, "EV_LIFE": null, "EVENT_TAGS": null, "started": null, "queue": null, "qOwner": null, "enterBusy": null, "recent": null, "holdUntil": null, "st": null, "seen": null, "hash": null, "nick": null, "isFodder": null, "archOf": null, "sample": null, "evOn": null, "mark": null, "hour": null, "tagOk": null, "isEvent": null, "isCtx": null, "fill": null, "poolOf": null, "pickFrom": null, "lineFor": null, "feudOf": null, "takeConv": null, "convFor": null, "startConv": null, "next": null, "pickChatter": null, "enterFor": null, "css": null, "ej": null, "playEnter": null, "closeEnter": null, "drawEnter": null, "onRecruit": null, "paintRoster": null}
	_s2["st"] = Callable(self, "_f6").bind(_s2)
	_s2["hash"] = Callable(self, "_f8").bind(_s2)
	_s2["nick"] = Callable(self, "_f9").bind(_s2)
	_s2["archOf"] = Callable(self, "_f11").bind(_s2)
	_s2["sample"] = Callable(self, "_f15").bind(_s2)
	_s2["evOn"] = Callable(self, "_f16").bind(_s2)
	_s2["mark"] = Callable(self, "_f17").bind(_s2)
	_s2["hour"] = Callable(self, "_f18").bind(_s2)
	_s2["tagOk"] = Callable(self, "_f19").bind(_s2)
	_s2["fill"] = Callable(self, "_f24").bind(_s2)
	_s2["poolOf"] = Callable(self, "_f25").bind(_s2)
	_s2["pickFrom"] = Callable(self, "_f26").bind(_s2)
	_s2["lineFor"] = Callable(self, "_f36").bind(_s2)
	_s2["feudOf"] = Callable(self, "_f37").bind(_s2)
	_s2["takeConv"] = Callable(self, "_f38").bind(_s2)
	_s2["convFor"] = Callable(self, "_f43").bind(_s2)
	_s2["startConv"] = Callable(self, "_f46").bind(_s2)
	_s2["next"] = Callable(self, "_f48").bind(_s2)
	_s2["pickChatter"] = Callable(self, "_f50").bind(_s2)
	_s2["enterFor"] = Callable(self, "_f54").bind(_s2)
	_s2["css"] = Callable(self, "_f60").bind(_s2)
	_s2["playEnter"] = Callable(self, "_f61").bind(_s2)
	_s2["closeEnter"] = Callable(self, "_f66").bind(_s2)
	_s2["drawEnter"] = Callable(self, "_f67").bind(_s2)
	_s2["onRecruit"] = Callable(self, "_f69").bind(_s2)
	_s2["paintRoster"] = Callable(self, "_f72").bind(_s2)
	v_init_46 = Callable(self, "_f76").bind(_s2)
	_s2["D"] = J.G.get("CHAT_DATA")
	_s2["zh"] = Callable(self, "_f2").bind(_s2)
	_s2["pickT"] = Callable(self, "_f3").bind(_s2)
	_s2["rnd"] = Callable(self, "_f4").bind(_s2)
	_s2["now"] = Callable(self, "_f5").bind(_s2)
	_s2["EV_LIFE"] = {"win": 180000.0, "lose": 180000.0, "new": 240000.0, "boss": 300000.0, "rival": 300000.0, "hr": 300000.0}
	_s2["EVENT_TAGS"] = ["win", "lose", "new", "boss", "rival", "hr"]
	_s2["started"] = false
	_s2["queue"] = []
	_s2["qOwner"] = null
	_s2["enterBusy"] = false
	_s2["recent"] = []
	_s2["holdUntil"] = 0.0
	_s2["seen"] = Callable(self, "_f7").bind(_s2)
	_s2["isFodder"] = Callable(self, "_f10").bind(_s2)
	_s2["isEvent"] = Callable(self, "_f20").bind(_s2)
	_s2["isCtx"] = Callable(self, "_f22").bind(_s2)
	_s2["ej"] = null
	v_demo_47 = {"lineFor": _s2["lineFor"], "convFor": _s2["convFor"], "startConv": Callable(self, "_f87").bind(_s2), "playEnter": _s2["playEnter"], "enterFor": _s2["enterFor"], "onRecruit": _s2["onRecruit"], "mark": _s2["mark"]}
	return {"st": _s2["st"], "init": v_init_46, "archOf": _s2["archOf"], "sample": _s2["sample"], "lineFor": _s2["lineFor"], "poolOf": _s2["poolOf"], "pickFrom": _s2["pickFrom"], "tagOk": _s2["tagOk"], "convFor": _s2["convFor"], "enterFor": _s2["enterFor"], "onRecruit": _s2["onRecruit"], "demo": v_demo_47, "close": _s2["closeEnter"], "__getters": {"busy": Callable(self, "_f88").bind(_s2)}}

func _f89(this_, a: Array, env):
	var v_chatterBoot_348 = null; var v_e_349 = null
	v_chatterBoot_348 = Callable(self, "_f89").bind(env)
	var _t372 = J.seq(J.typeof_(J.G.get("S")), "undefined")
	var _t373 = (_t372 if _t372 else (not J.t(J.G.get("S"))))
	var _t374 = (_t373 if _t373 else J.seq(J.typeof_(J.G.get("Village")), "undefined"))
	if (_t374 if _t374 else (not J.t(J.S_document_("querySelector", ["#sheet"])))):
		J.F_setTimeout([v_chatterBoot_348, 300.0])
		return null
	J.mc(J.G.get("Chatter"), "init", [])
