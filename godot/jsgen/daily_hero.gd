# 自動轉譯自 daily_hero.js（tools/jsgd.js）——唔好直接改，改原 JS 再轉
extends RefCounted

func run(env):
	var this_ = null; var a = []
	J.G["HeroDaily"] = J.cl(Callable(self, "_f1").bind(env), null, [])

func _f16(this_, a: Array, env):
	var v_a_80 = null; var v_b_81 = null; var v_k_82 = null; var v_o_83 = null; var v_n_84 = null
	v_a_80 = J.arg(a, 0)
	v_b_81 = J.arg(a, 1)
	v_k_82 = J.arg(a, 2)
	v_o_83 = {}
	for _t1 in J.iter(env["F"]):
		v_n_84 = _t1
		var _t2 = J.gp(v_a_80, v_n_84)
		var _t6 = (_t2 if J.t(_t2) else 0.0)
		var _t3 = J.gp(v_b_81, v_n_84)
		var _t5 = (_t3 if J.t(_t3) else 0.0)
		var _t4 = J.gp(v_a_80, v_n_84)
		var _t7 = J.add(_t6, J.mul(J.sub(_t5, (_t4 if J.t(_t4) else 0.0)), v_k_82))
		J.sp(v_o_83, v_n_84, _t7)
	return v_o_83

func _f17(this_, a: Array, env):
	var v_a_87 = null; var v_b_88 = null; var v_o_89 = null; var v_n_90 = null
	v_a_87 = J.arg(a, 0)
	v_b_88 = J.arg(a, 1)
	v_o_89 = J.S_Object_("assign", [{}, v_a_87])
	for _t8 in J.iter(env["F"]):
		v_n_90 = _t8
		var _t9 = J.gp(v_a_87, v_n_90)
		var _t11 = (_t9 if J.t(_t9) else 0.0)
		var _t10 = J.gp(v_b_88, v_n_90)
		var _t12 = J.add(_t11, (_t10 if J.t(_t10) else 0.0))
		J.sp(v_o_89, v_n_90, _t12)
	return v_o_89

func _f18(this_, a: Array, env):
	var v_at_93 = null; var v_keys_94 = null; var v_i_95 = null; var v_t1_96 = null; var v_v1_97 = null; var v_e_98 = null; var v_t0_99 = null; var v_v0_100 = null; var v_k_101 = null
	v_at_93 = J.arg(a, 0)
	v_keys_94 = J.arg(a, 1)
	if J.cmp(v_at_93, J.gp(J.gp(v_keys_94, 0.0), 0.0), "<="):
		return J.S_Object_("assign", [J.cl(env["Z"], null, []), J.gp(J.gp(v_keys_94, 0.0), 1.0)])
	v_i_95 = 1.0
	while true:
		if not J.cmp(v_i_95, J.len(v_keys_94), "<"): break
		var _t13 = J.gp(v_keys_94, v_i_95)
		var _t14 = J.gp(_t13, 0.0)
		v_t1_96 = _t14
		var _t15 = J.gp(_t13, 1.0)
		v_v1_97 = _t15
		var _t16 = J.gp(_t13, 2.0)
		v_e_98 = _t16
		var _t17 = J.gp(v_keys_94, J.sub(v_i_95, 1.0))
		var _t18 = J.gp(_t17, 0.0)
		v_t0_99 = _t18
		var _t19 = J.gp(_t17, 1.0)
		v_v0_100 = _t19
		if J.cmp(v_at_93, v_t1_96, "<"):
			var _t20 = env["E"]
			var _t21 = (v_e_98 if J.t(v_e_98) else "io")
			var _t22 = env["cl"]
			v_k_101 = J.mc(_t20, _t21, [J.cl(_t22, null, [J.div(J.sub(v_at_93, v_t0_99), J.sub(v_t1_96, v_t0_99))])])
			var _t23 = env["lerpP"]
			return J.cl(_t23, null, [J.S_Object_("assign", [J.cl(env["Z"], null, []), v_v0_100]), J.S_Object_("assign", [J.cl(env["Z"], null, []), v_v1_97]), v_k_101])
		v_i_95 = J.num(v_i_95) + 1.0
	return J.S_Object_("assign", [J.cl(env["Z"], null, []), J.gp(J.gp(v_keys_94, (J.len(v_keys_94) - 1.0)), 1.0)])

func _f21(this_, a: Array, env):
	var v_t_111 = null
	v_t_111 = J.arg(a, 0)
	var _t24 = env["S"]
	var _t26 = J.mul(J.cl(_t24, null, [J.mul(v_t_111, 1.3)]), 0.05)
	var _t25 = env["S"]
	var _t28 = J.mul(J.cl(_t25, null, [(J.mul(v_t_111, 1.8) + 1.0)]), 0.06)
	var _t27 = env["S"]
	var _t30 = J.mul(J.cl(_t27, null, [J.mul(v_t_111, 5.0)]), 0.18)
	var _t29 = env["S"]
	var _t32 = J.mul(J.cl(_t29, null, [J.mul(v_t_111, 2.6)]), 0.12)
	var _t31 = env["S"]
	return {"head": _t26, "armB": _t28, "tie": _t30, "tail1": _t32, "tail2": J.mul(J.cl(_t31, null, [(J.mul(v_t_111, 2.6) - 1.0)]), 0.22)}

func _f23(this_, a: Array, env):
	var v_a_114 = null; var v_m_115 = null
	v_a_114 = J.arg(a, 0)
	var _t33 = J.cl(env["M"], null, [])
	v_m_115 = J.mc(_t33, "translate", [J.gp(v_a_114, "x"), J.gp(v_a_114, "y")])
	return (J.mc(v_m_115, "scale", [(-1.0), 1.0]) if J.t(J.gp(v_a_114, "faceRight")) else v_m_115)

func _f24(this_, a: Array, env):
	var v_a_118 = null; var v_P_119 = null; var v_t_120 = null; var v_H_121 = null; var v_b_122 = null; var v_W_123 = null; var v_c_124 = null; var v_bob_125 = null; var v_fl_126 = null; var v_my_127 = null; var v_G_128 = null; var v_Mb_129 = null; var v_th_130 = null; var v_lift_131 = null; var v_px_132 = null; var v_py_133 = null; var v_lx_134 = null; var v_ly_135 = null; var v_Ma_136 = null; var v_wp_137 = null; var v_ww_138 = null; var v_wh_139 = null; var v_ax_140 = null; var v_ay_141 = null; var v_al_142 = null; var v_Mg_143 = null
	v_a_118 = J.arg(a, 0)
	v_P_119 = J.arg(a, 1)
	v_t_120 = J.arg(a, 2)
	v_H_121 = J.gp(v_a_118, "H")
	v_b_122 = J.gp(J.G.get("SPR"), "afu__body")
	v_W_123 = J.div(J.mul(v_H_121, J.gp(v_b_122, "naturalWidth")), J.gp(v_b_122, "naturalHeight"))
	v_c_124 = J.cl(env["LD"], null, [])
	var _t34 = env["cl"]
	var _t35 = J.gp(v_P_119, "bob")
	v_bob_125 = J.cl(_t34, null, [J.add(1.0, (_t35 if J.t(_t35) else 0.0)), 0.0, 1.0])
	var _t37 = null
	if J.t(J.gp(v_a_118, "solid")):
		_t37 = 0.0
	else:
		var _t36 = env["S"]
		_t37 = J.mul((3.0 + J.mul(J.mul(J.cl(_t36, null, [J.mul(v_t_120, 2.4)]), 2.0), v_bob_125)), J.gp(v_a_118, "s"))
	v_fl_126 = _t37
	var _t39 = (-0.03)
	var _t38 = env["S"]
	v_my_127 = (_t39 - J.mul(J.mul(J.cl(_t38, null, [J.mul(v_t_120, 2.2)]), 0.02), v_bob_125))
	var _t40 = env["ground"]
	v_G_128 = J.cl(_t40, null, [v_a_118])
	var _t41 = J.mc(v_G_128, "translate", [0.0, (-J.num(v_fl_126))])
	var _t42 = J.gp(v_P_119, "dx")
	var _t44 = J.mul((-J.num((_t42 if J.t(_t42) else 0.0))), v_H_121)
	var _t43 = J.gp(v_P_119, "dy")
	var _t45 = J.mc(_t41, "translate", [_t44, J.mul((_t43 if J.t(_t43) else 0.0), v_H_121)])
	var _t46 = J.mc(_t45, "translate", [0.0, ((-J.num(v_H_121)) * 0.28)])
	var _t47 = J.gp(v_P_119, "lean")
	var _t48 = J.mc(_t46, "rotate", [(_t47 if J.t(_t47) else 0.0)])
	var _t49 = J.mc(_t48, "translate", [0.0, J.mul(v_H_121, 0.28)])
	var _t50 = J.gp(v_P_119, "sx")
	var _t52 = J.add(1.0, (_t50 if J.t(_t50) else 0.0))
	var _t51 = J.gp(v_P_119, "sy")
	v_Mb_129 = J.mc(_t49, "scale", [_t52, J.add(1.0, (_t51 if J.t(_t51) else 0.0))])
	var _t53 = J.gp(v_P_119, "th")
	v_th_130 = (_t53 if J.t(_t53) else 0.0)
	var _t54 = env["cl"]
	v_lift_131 = J.cl(_t54, null, [J.div(J.sub(v_th_130, 25.0), 40.0), 0.0, 1.0])
	v_px_132 = J.mul(J.sub(J.gp(J.gp(v_c_124, "pivot"), 0.0), 0.5), v_W_123)
	v_py_133 = (((-J.num(v_H_121)) + J.mul(J.gp(J.gp(v_c_124, "pivot"), 1.0), v_H_121)) + J.mul(v_my_127, v_H_121))
	var _t56 = J.mul(v_lift_131, J.gp(J.gp(v_c_124, "lift"), 0.0))
	var _t55 = J.gp(v_P_119, "hx")
	v_lx_134 = J.add(v_px_132, J.mul(J.add(_t56, (_t55 if J.t(_t55) else 0.0)), v_W_123))
	var _t58 = J.mul(v_lift_131, J.gp(J.gp(v_c_124, "lift"), 1.0))
	var _t57 = J.gp(v_P_119, "hy")
	v_ly_135 = J.sub(v_py_133, J.mul(J.add(_t58, (_t57 if J.t(_t57) else 0.0)), v_H_121))
	var _t59 = J.mc(v_Mb_129, "translate", [v_lx_134, v_ly_135])
	v_Ma_136 = J.mc(_t59, "rotate", [v_th_130])
	v_wp_137 = J.cl(env["WP"], null, [])
	v_ww_138 = J.mul(J.gp(v_wp_137, "w"), v_H_121)
	v_wh_139 = J.mul(J.gp(v_wp_137, "h"), v_H_121)
	v_ax_140 = J.mul(J.sub(J.gp(J.gp(v_wp_137, "tip"), 0.0), J.gp(J.gp(v_wp_137, "grip"), 0.0)), v_ww_138)
	v_ay_141 = J.mul(J.sub(J.gp(J.gp(v_wp_137, "tip"), 1.0), J.gp(J.gp(v_wp_137, "grip"), 1.0)), v_wh_139)
	v_al_142 = J.hypot_([v_ax_140, v_ay_141])
	var _t60 = J.mc(v_Ma_136, "translate", [J.mul(J.sub(J.gp(J.gp(v_c_124, "grip"), 0.0), J.gp(J.gp(v_c_124, "pivot"), 0.0)), v_W_123), J.mul(J.sub(J.gp(J.gp(v_c_124, "grip"), 1.0), J.gp(J.gp(v_c_124, "pivot"), 1.0)), v_H_121)])
	var _t61 = J.gp(v_P_119, "wr")
	var _t62 = J.mc(_t60, "rotate", [(_t61 if J.t(_t61) else 0.0)])
	var _t64 = J.div(v_ax_140, v_al_142)
	var _t63 = J.gp(v_P_119, "slide")
	var _t67 = J.mul(J.mul(_t64, (_t63 if J.t(_t63) else 0.0)), v_H_121)
	var _t66 = J.div(v_ay_141, v_al_142)
	var _t65 = J.gp(v_P_119, "slide")
	v_Mg_143 = J.mc(_t62, "translate", [_t67, J.mul(J.mul(_t66, (_t65 if J.t(_t65) else 0.0)), v_H_121)])
	return {"H": v_H_121, "W": v_W_123, "G": v_G_128, "Mb": v_Mb_129, "Ma": v_Ma_136, "Mg": v_Mg_143, "my": v_my_127, "fl": v_fl_126, "ww": v_ww_138, "wh": v_wh_139, "axU": [J.div(v_ax_140, v_al_142), J.div(v_ay_141, v_al_142)], "al": v_al_142}

func _f26(this_, a: Array, env):
	var v_b_158 = null
	v_b_158 = J.arg(a, 0)
	var _t69 = ["armF", "axe"]
	return (not J.t(J.mc(_t69, "includes", [J.gp(v_b_158, 0.0)])))

func _f25(this_, a: Array, env):
	var v_R_146 = null; var v_mp_147 = null; var v_u_148 = null; var v_v_149 = null; var v_img_150 = null; var v_ar_151 = null; var v_T_152 = null; var v_X_153 = null; var v_Y_154 = null; var v_sum_155 = null; var v_vy_156 = null; var v_p_157 = null; var v_b_159 = null; var v_n_160 = null; var v_par_161 = null; var v_px_162 = null; var v_py_163 = null; var v_A0_164 = null; var v_Pp_165 = null; var v_ppx_166 = null; var v_ppy_167 = null; var v_A_168 = null; var v_b_169 = null; var v_dx_170 = null; var v_dy_171 = null; var v_l_172 = null; var v_tt_173 = null; var v_d_174 = null; var v_w_175 = null; var v_tr_176 = null; var v_c_177 = null; var v_s_178 = null
	v_R_146 = J.arg(a, 0)
	v_mp_147 = J.arg(a, 1)
	v_u_148 = J.arg(a, 2)
	v_v_149 = J.arg(a, 3)
	v_img_150 = J.gp(J.G.get("SPR"), "afu__body")
	v_ar_151 = J.div(J.gp(v_img_150, "naturalHeight"), J.gp(v_img_150, "naturalWidth"))
	if (not J.t(env["RB"])):
		var _t68 = J.gp(J.gp(J.gp(J.G.get("MeshAnim"), "RIG"), "afu"), "bones")
		var _t70 = J.mc(_t68, "filter", [Callable(self, "_f26").bind(env)])
		env["RB"] = _t70
	v_T_152 = {}
	for _t71 in J.iter(env["RB"]):
		v_b_159 = _t71
		var _t72 = J.gp(v_b_159, 0.0)
		v_n_160 = _t72
		var _t73 = J.gp(v_b_159, 1.0)
		v_par_161 = _t73
		var _t74 = J.gp(v_b_159, 2.0)
		v_px_162 = _t74
		var _t75 = J.gp(v_b_159, 3.0)
		v_py_163 = _t75
		var _t76 = J.gp(v_mp_147, v_n_160)
		v_A0_164 = (_t76 if J.t(_t76) else 0.0)
		v_Pp_165 = (J.gp(v_T_152, v_par_161) if J.t(v_par_161) else {"a": 0.0, "tx": 0.0, "ty": 0.0})
		v_ppx_166 = J.add((J.mul(cos(J.num(J.gp(v_Pp_165, "a"))), v_px_162) - J.mul(sin(J.num(J.gp(v_Pp_165, "a"))), v_py_163)), J.gp(v_Pp_165, "tx"))
		v_ppy_167 = J.add((J.mul(sin(J.num(J.gp(v_Pp_165, "a"))), v_px_162) + J.mul(cos(J.num(J.gp(v_Pp_165, "a"))), v_py_163)), J.gp(v_Pp_165, "ty"))
		v_A_168 = J.add(J.gp(v_Pp_165, "a"), v_A0_164)
		var _t77 = {"a": v_A_168, "tx": J.sub(v_ppx_166, (J.mul(cos(J.num(v_A_168)), v_px_162) - J.mul(sin(J.num(v_A_168)), v_py_163))), "ty": J.sub(v_ppy_167, (J.mul(sin(J.num(v_A_168)), v_px_162) + J.mul(cos(J.num(v_A_168)), v_py_163)))}
		J.sp(v_T_152, v_n_160, _t77)
	v_X_153 = 0.0
	v_Y_154 = 0.0
	v_sum_155 = 0.0
	v_vy_156 = J.mul(v_v_149, v_ar_151)
	for _t78 in J.iter(env["RB"]):
		v_b_169 = _t78
		v_dx_170 = J.sub(J.gp(v_b_169, 4.0), J.gp(v_b_169, 2.0))
		v_dy_171 = J.mul(J.sub(J.gp(v_b_169, 5.0), J.gp(v_b_169, 3.0)), v_ar_151)
		var _t79 = (J.mul(v_dx_170, v_dx_170) + J.mul(v_dy_171, v_dy_171))
		v_l_172 = (_t79 if J.t(_t79) else 0.000001)
		var _t80 = env["cl"]
		v_tt_173 = J.cl(_t80, null, [J.div((J.mul(J.sub(v_u_148, J.gp(v_b_169, 2.0)), v_dx_170) + J.mul(J.sub(v_vy_156, J.mul(J.gp(v_b_169, 3.0), v_ar_151)), v_dy_171)), v_l_172)])
		v_d_174 = J.div(J.hypot_([(J.sub(v_u_148, J.gp(v_b_169, 2.0)) - J.mul(v_tt_173, v_dx_170)), (J.sub(v_vy_156, J.mul(J.gp(v_b_169, 3.0), v_ar_151)) - J.mul(v_tt_173, v_dy_171))]), J.gp(v_b_169, 6.0))
		v_w_175 = exp(J.num((J.mul((-J.num(v_d_174)), v_d_174) * 2.2)))
		if J.seq(J.gp(v_b_169, 1.0), null):
			var _t81 = J.max_([v_w_175, 0.05])
			v_w_175 = _t81
		v_tr_176 = J.gp(v_T_152, J.gp(v_b_169, 0.0))
		v_c_177 = cos(J.num(J.gp(v_tr_176, "a")))
		v_s_178 = sin(J.num(J.gp(v_tr_176, "a")))
		var _t82 = J.add(v_X_153, J.mul(v_w_175, J.add((J.mul(v_c_177, v_u_148) - J.mul(v_s_178, v_vy_156)), J.gp(v_tr_176, "tx"))))
		v_X_153 = _t82
		var _t83 = J.add(v_Y_154, J.mul(v_w_175, J.add((J.mul(v_s_178, v_u_148) + J.mul(v_c_177, v_vy_156)), J.gp(v_tr_176, "ty"))))
		v_Y_154 = _t83
		var _t84 = J.add(v_sum_155, v_w_175)
		v_sum_155 = _t84
	var _t85 = J.div(v_X_153, v_sum_155)
	v_X_153 = _t85
	var _t86 = J.div(J.div(v_Y_154, v_sum_155), v_ar_151)
	v_Y_154 = _t86
	var _t87 = J.gp(v_R_146, "Mb")
	var _t90 = J.mul(J.sub(v_X_153, 0.5), J.gp(v_R_146, "W"))
	var _t89 = J.mul(J.add(J.sub(v_Y_154, 1.0), J.gp(v_R_146, "my")), J.gp(v_R_146, "H"))
	var _t88 = J.gp(v_mp_147, "msy")
	v_p_157 = J.mc(_t87, "transformPoint", [J.construct(J.G.get("DOMPoint"), [_t90, J.mul(_t89, J.add(1.0, (_t88 if J.t(_t88) else 0.0)))])])
	return {"x": J.gp(v_p_157, "x"), "y": J.gp(v_p_157, "y")}

func _f29(this_, a: Array, env):
	var v_Mx_204 = null
	v_Mx_204 = J.arg(a, 0)
	return J.mc(env["ctx"], "setTransform", [J.mc(env["base"], "multiply", [v_Mx_204])])

func _f30(this_, a: Array, env):
	var _t111 = env["set"]
	J.cl(_t111, null, [J.gp(env["R"], "G")])
	J.mc(env["ctx"], "beginPath", [])
	J.mc(env["ctx"], "rect", [((-J.num(env["H"])) * 3.0), ((-J.num(env["H"])) * 3.0), J.mul(env["H"], 6.0), (J.mul(env["H"], 3.0) + J.mul(env["H"], 0.015))])
	J.mc(env["ctx"], "clip", [])

func _f31(this_, a: Array, env):
	var v_Mx_205 = null; var v_wp_206 = null; var v_im_207 = null
	v_Mx_205 = J.arg(a, 0)
	v_wp_206 = J.cl(env["__p"]["WP"], null, [])
	v_im_207 = J.cl(env["__p"]["AXE"], null, [])
	J.mc(env["ctx"], "save", [])
	J.cl(env["clipGround"], null, [])
	var _t112 = env["set"]
	J.cl(_t112, null, [v_Mx_205])
	J.mc(env["ctx"], "drawImage", [v_im_207, J.mul((-J.num(J.gp(J.gp(v_wp_206, "grip"), 0.0))), J.gp(env["R"], "ww")), J.mul((-J.num(J.gp(J.gp(v_wp_206, "grip"), 1.0))), J.gp(env["R"], "wh")), J.gp(env["R"], "ww"), J.gp(env["R"], "wh")])
	J.mc(env["ctx"], "restore", [])

func _f32(this_, a: Array, env):
	J.mc(env["ctx"], "save", [])
	var _t114 = env["set"]
	J.cl(_t114, null, [J.gp(env["R"], "Ma")])
	J.mc(env["ctx"], "drawImage", [env["arm"], J.mul((-J.num(J.gp(J.gp(env["c"], "pivot"), 0.0))), J.gp(env["R"], "W")), J.mul((-J.num(J.gp(J.gp(env["c"], "pivot"), 1.0))), J.gp(env["R"], "H")), J.gp(env["R"], "W"), J.gp(env["R"], "H")])
	J.mc(env["ctx"], "restore", [])
	if J.cmp(J.gp(env["st"], "phone"), 0.0, ">"):
		var _t115 = env["__p"]["drawPhoneInHand"]
		J.cl(_t115, null, [env["ctx"], env["base"], env["R"], env["st"], env["t"]])

func _f28(this_, a: Array, env):
	var v_a_186 = null; var v_P_187 = null; var v_body_194 = null; var v_mp_196 = null; var v_up_197 = null; var v_drawAxe_200 = null; var v_planted_201 = null; var v_drawArm_202 = null; var v_behind_203 = null
	var _s39 = {"__p": env, "ctx": null, "st": null, "t": null, "base": null, "R": null, "H": null, "c": null, "arm": null, "set": null, "clipGround": null}
	_s39["ctx"] = J.arg(a, 0)
	v_a_186 = J.arg(a, 1)
	v_P_187 = J.arg(a, 2)
	_s39["st"] = J.arg(a, 3)
	_s39["t"] = J.arg(a, 4)
	_s39["base"] = J.mc(_s39["ctx"], "getTransform", [])
	var _t91 = _s39["__p"]["solveRig"]
	_s39["R"] = J.cl(_t91, null, [v_a_186, v_P_187, _s39["t"]])
	_s39["H"] = J.gp(_s39["R"], "H")
	_s39["c"] = J.cl(_s39["__p"]["LD"], null, [])
	v_body_194 = J.gp(J.G.get("SPR"), "afu__body")
	_s39["arm"] = J.gp(J.G.get("SPR"), "afu__arm")
	var _t93 = J.gp(v_P_187, "head")
	var _t94 = J.gp(v_P_187, "armB")
	var _t95 = J.gp(v_P_187, "tie")
	var _t96 = J.gp(v_P_187, "tail1")
	var _t97 = J.gp(v_P_187, "tail2")
	var _t92 = J.gp(v_P_187, "mb")
	var _t99 = (_t92 if J.t(_t92) else 0.0)
	var _t100 = J.gp(_s39["R"], "my")
	var _t98 = J.gp(v_P_187, "msy")
	v_mp_196 = {"head": _t93, "armB": _t94, "tie": _t95, "tail1": _t96, "tail2": _t97, "body": _t99, "y": _t100, "sy": J.add(1.0, (_t98 if J.t(_t98) else 0.0))}
	var _t101 = J.gp(v_P_187, "dy")
	v_up_197 = (-J.num((_t101 if J.t(_t101) else 0.0)))
	J.mc(_s39["ctx"], "save", [])
	var _t102 = _s39["ctx"]
	var _t103 = _s39["__p"]["cl"]
	var _t104 = J.mul(J.gp(_t102, "globalAlpha"), J.mul(0.55, J.cl(_t103, null, [(1.0 - J.mul(v_up_197, 2.5)), 0.35, 1.0])))
	J.sp(_t102, "globalAlpha", _t104)
	var _t107 = J.gp(v_a_186, "x")
	var _t106 = ((-1.0) if J.t(J.gp(v_a_186, "faceRight")) else 1.0)
	var _t105 = J.gp(v_P_187, "dx")
	var _t110 = J.sub(_t107, (J.mul(J.mul(_t106, (_t105 if J.t(_t105) else 0.0)), _s39["H"]) * 0.5))
	var _t109 = (1.0 if J.t(J.gp(v_a_186, "solid")) else 0.8)
	var _t108 = _s39["__p"]["cl"]
	J.mc(v_a_186, "shadow", [_t110, J.mul(_t109, J.cl(_t108, null, [(1.0 - J.mul(v_up_197, 1.6)), 0.55, 1.1]))])
	J.mc(_s39["ctx"], "restore", [])
	_s39["set"] = Callable(self, "_f29").bind(_s39)
	_s39["clipGround"] = Callable(self, "_f30").bind(_s39)
	v_drawAxe_200 = Callable(self, "_f31").bind(_s39)
	var _t113 = J.seq(J.gp(_s39["st"], "axe"), "plant")
	v_planted_201 = (J.gp(_s39["st"], "plantM") if _t113 else _t113)
	v_drawArm_202 = Callable(self, "_f32").bind(_s39)
	var _t117 = null
	if J.t(J.gp(_s39["st"], "front")):
		_t117 = false
	else:
		var _t116 = J.gp(v_P_187, "th")
		_t117 = J.cmp((_t116 if J.t(_t116) else 0.0), J.gp(_s39["c"], "behind"), ">")
	v_behind_203 = _t117
	if J.t((J.gp(_s39["st"], "plantBehind") if J.t(v_planted_201) else v_planted_201)):
		var _t118 = J.gp(_s39["R"], "G")
		J.cl(v_drawAxe_200, null, [J.mc(_t118, "multiply", [J.gp(_s39["st"], "plantM")])])
	if J.t(v_behind_203):
		if J.seq(J.gp(_s39["st"], "axe"), "hand"):
			J.cl(v_drawAxe_200, null, [J.gp(_s39["R"], "Mg")])
		J.cl(v_drawArm_202, null, [])
	J.mc(_s39["ctx"], "save", [])
	var _t119 = _s39["set"]
	J.cl(_t119, null, [J.gp(_s39["R"], "Mb")])
	J.mc(J.G.get("MeshAnim"), "drawBody", [_s39["ctx"], "afu", "afu__body", _s39["H"], v_mp_196])
	J.mc(_s39["ctx"], "restore", [])
	if J.t(((not J.t(J.gp(_s39["st"], "plantBehind"))) if J.t(v_planted_201) else v_planted_201)):
		var _t120 = J.gp(_s39["R"], "G")
		J.cl(v_drawAxe_200, null, [J.mc(_t120, "multiply", [J.gp(_s39["st"], "plantM")])])
	if (not J.t(v_behind_203)):
		if J.seq(J.gp(_s39["st"], "axe"), "hand"):
			J.cl(v_drawAxe_200, null, [J.gp(_s39["R"], "Mg")])
		J.cl(v_drawArm_202, null, [])
	J.mc(_s39["ctx"], "setTransform", [_s39["base"]])
	var _t121 = _s39["R"]
	J.sp(_t121, "mp", v_mp_196)
	return _s39["R"]

func _f33(this_, a: Array, env):
	var v_ctx_210 = null; var v_base_211 = null; var v_R_212 = null; var v_st_213 = null; var v_t_214 = null; var v_im_215 = null; var v_k_216 = null; var v_H_217 = null; var v_c_218 = null; var v_ph_219 = null; var v_pw_220 = null; var v_Mf_221 = null; var v_W_222 = null
	v_ctx_210 = J.arg(a, 0)
	v_base_211 = J.arg(a, 1)
	v_R_212 = J.arg(a, 2)
	v_st_213 = J.arg(a, 3)
	v_t_214 = J.arg(a, 4)
	v_im_215 = J.gp(J.G.get("SPR"), "afu__phone")
	var _t123 = (not J.t(v_im_215))
	if not J.t(_t123):
		var _t122 = env["ok"]
		_t123 = (not J.t(J.cl(_t122, null, ["afu__phone"])))
	if _t123:
		return null
	v_k_216 = J.gp(v_st_213, "phone")
	v_H_217 = J.gp(v_R_212, "H")
	v_c_218 = J.cl(env["LD"], null, [])
	v_ph_219 = (J.mul(v_H_217, 0.2) * (0.55 + J.mul(0.45, v_k_216)))
	v_pw_220 = J.div(J.mul(v_ph_219, J.gp(v_im_215, "naturalWidth")), J.gp(v_im_215, "naturalHeight"))
	var _t124 = J.gp(v_R_212, "Ma")
	var _t125 = J.mc(_t124, "translate", [J.mul(J.sub(J.gp(env["FIST"], 0.0), J.gp(J.gp(v_c_218, "pivot"), 0.0)), J.gp(v_R_212, "W")), J.mul(J.sub(J.gp(env["FIST"], 1.0), J.gp(J.gp(v_c_218, "pivot"), 1.0)), J.gp(v_R_212, "H"))])
	v_Mf_221 = J.mc(_t125, "rotate", [(J.gp(v_st_213, "phoneRot") if (not J.leq(J.gp(v_st_213, "phoneRot"), null)) else (-20.0))])
	J.mc(v_ctx_210, "save", [])
	J.mc(v_ctx_210, "setTransform", [J.mc(v_base_211, "multiply", [v_Mf_221])])
	var _t126 = env["cl"]
	var _t127 = J.mul(J.gp(v_ctx_210, "globalAlpha"), J.cl(_t126, null, [J.mul(v_k_216, 3.0)]))
	J.sp(v_ctx_210, "globalAlpha", _t127)
	J.mc(v_ctx_210, "drawImage", [v_im_215, ((-J.num(v_pw_220)) * 0.5), ((-J.num(v_ph_219)) * 0.92), v_pw_220, v_ph_219])
	if J.t(J.gp(v_st_213, "glow")):
		J.sp(v_ctx_210, "globalCompositeOperation", "lighter")
		var _t128 = J.mul(J.gp(v_ctx_210, "globalAlpha"), J.mul(J.gp(v_st_213, "glow"), 0.5))
		J.sp(v_ctx_210, "globalAlpha", _t128)
		J.sp(v_ctx_210, "fillStyle", "#9fe6ff")
		J.mc(v_ctx_210, "beginPath", [])
		J.mc(v_ctx_210, "ellipse", [0.0, ((-J.num(v_ph_219)) * 0.48), J.mul(v_pw_220, 0.36), J.mul(v_ph_219, 0.38), 0.0, 0.0, 7.0])
		J.mc(v_ctx_210, "fill", [])
	J.mc(v_ctx_210, "restore", [])
	J.mc(v_ctx_210, "save", [])
	J.mc(v_ctx_210, "setTransform", [J.mc(v_base_211, "multiply", [J.gp(v_R_212, "Ma")])])
	v_W_222 = J.gp(v_R_212, "W")
	J.mc(v_ctx_210, "beginPath", [])
	J.mc(v_ctx_210, "ellipse", [J.mul(J.sub(0.245, J.gp(J.gp(v_c_218, "pivot"), 0.0)), v_W_222), J.mul(J.sub(0.515, J.gp(J.gp(v_c_218, "pivot"), 1.0)), v_H_217), J.mul(0.05, v_W_222), J.mul(0.04, v_H_217), (-0.3), 0.0, 7.0])
	J.mc(v_ctx_210, "clip", [])
	J.mc(v_ctx_210, "drawImage", [J.gp(J.G.get("SPR"), "afu__arm"), J.mul((-J.num(J.gp(J.gp(v_c_218, "pivot"), 0.0))), v_W_222), J.mul((-J.num(J.gp(J.gp(v_c_218, "pivot"), 1.0))), v_H_217), v_W_222, v_H_217])
	J.mc(v_ctx_210, "restore", [])

func _f35(this_, a: Array, env):
	var _t129 = J.mod((J.mul(env["s"], 9301.0) + 49297.0), 233280.0)
	env["s"] = _t129
	return J.div(env["s"], 233280.0)

func _f34(this_, a: Array, env):
	var v_seed_225 = null
	var _s48 = {"__p": env, "s": null}
	v_seed_225 = J.arg(a, 0)
	_s48["s"] = (J.mul(v_seed_225, 9301.0) + 49297.0)
	return Callable(self, "_f35").bind(_s48)

func _f36(this_, a: Array, env):
	var v_ctx_229 = null; var v_str_230 = null; var v_x_231 = null; var v_y_232 = null; var v_size_233 = null; var v_col_234 = null; var v_alpha_235 = null; var v_rot_236 = null
	v_ctx_229 = J.arg(a, 0)
	v_str_230 = J.arg(a, 1)
	v_x_231 = J.arg(a, 2)
	v_y_232 = J.arg(a, 3)
	v_size_233 = J.arg(a, 4)
	v_col_234 = J.arg(a, 5)
	v_alpha_235 = J.arg(a, 6)
	v_rot_236 = J.arg(a, 7)
	if J.cmp(v_alpha_235, 0.0, "<="):
		return null
	var _t130 = J.max_([v_size_233, 8.0])
	v_size_233 = _t130
	J.mc(v_ctx_229, "save", [])
	var _t131 = J.mul(J.gp(v_ctx_229, "globalAlpha"), v_alpha_235)
	J.sp(v_ctx_229, "globalAlpha", _t131)
	J.mc(v_ctx_229, "translate", [v_x_231, v_y_232])
	if J.t(v_rot_236):
		J.mc(v_ctx_229, "rotate", [v_rot_236])
	var _t132 = ("bold " + J.str(v_size_233) + "px \"PingFang TC\",\"Noto Sans TC\",\"Noto Sans CJK TC\",sans-serif")
	J.sp(v_ctx_229, "font", _t132)
	J.sp(v_ctx_229, "textAlign", "center")
	J.sp(v_ctx_229, "textBaseline", "middle")
	J.sp(v_ctx_229, "lineJoin", "round")
	var _t133 = J.max_([2.0, J.mul(v_size_233, 0.28)])
	J.sp(v_ctx_229, "lineWidth", _t133)
	J.sp(v_ctx_229, "strokeStyle", "rgba(28,18,26,.92)")
	J.mc(v_ctx_229, "strokeText", [v_str_230, 0.0, 0.0])
	J.sp(v_ctx_229, "fillStyle", v_col_234)
	J.mc(v_ctx_229, "fillText", [v_str_230, 0.0, 0.0])
	var _t134 = J.mul(J.gp(v_ctx_229, "globalAlpha"), 0.35)
	J.sp(v_ctx_229, "globalAlpha", _t134)
	J.sp(v_ctx_229, "fillStyle", "#fff")
	J.mc(v_ctx_229, "fillText", [v_str_230, ((-J.num(v_size_233)) * 0.04), ((-J.num(v_size_233)) * 0.05)])
	J.mc(v_ctx_229, "restore", [])

func _f37(this_, a: Array, env):
	var v_ctx_239 = null; var v_x_240 = null; var v_y_241 = null; var v_w_242 = null; var v_h_243 = null; var v_alpha_244 = null; var v_tailX_245 = null; var v_tailY_246 = null
	v_ctx_239 = J.arg(a, 0)
	v_x_240 = J.arg(a, 1)
	v_y_241 = J.arg(a, 2)
	v_w_242 = J.arg(a, 3)
	v_h_243 = J.arg(a, 4)
	v_alpha_244 = J.arg(a, 5)
	v_tailX_245 = J.arg(a, 6)
	v_tailY_246 = J.arg(a, 7)
	if J.cmp(v_alpha_244, 0.0, "<="):
		return null
	J.mc(v_ctx_239, "save", [])
	var _t135 = J.mul(J.gp(v_ctx_239, "globalAlpha"), v_alpha_244)
	J.sp(v_ctx_239, "globalAlpha", _t135)
	J.sp(v_ctx_239, "lineJoin", "round")
	J.mc(v_ctx_239, "beginPath", [])
	J.mc(v_ctx_239, "roundRect", [J.sub(v_x_240, J.div(v_w_242, 2.0)), J.sub(v_y_241, J.div(v_h_243, 2.0)), v_w_242, v_h_243, J.mul(v_h_243, 0.45)])
	if (not J.leq(v_tailX_245, null)):
		J.mc(v_ctx_239, "moveTo", [J.sub(v_x_240, J.mul(v_w_242, 0.12)), J.sub(J.add(v_y_241, J.div(v_h_243, 2.0)), 1.0)])
		J.mc(v_ctx_239, "lineTo", [v_tailX_245, v_tailY_246])
		J.mc(v_ctx_239, "lineTo", [J.add(v_x_240, J.mul(v_w_242, 0.08)), J.sub(J.add(v_y_241, J.div(v_h_243, 2.0)), 1.0)])
	J.sp(v_ctx_239, "fillStyle", "#fbf3e2")
	J.mc(v_ctx_239, "fill", [])
	var _t136 = J.max_([1.4, J.mul(v_h_243, 0.09)])
	J.sp(v_ctx_239, "lineWidth", _t136)
	J.sp(v_ctx_239, "strokeStyle", "#3a2a2e")
	J.mc(v_ctx_239, "stroke", [])
	J.mc(v_ctx_239, "restore", [])

func _f38(this_, a: Array, env):
	var v_ctx_249 = null; var v_str_250 = null; var v_x_251 = null; var v_y_252 = null; var v_size_253 = null; var v_col_254 = null; var v_alpha_255 = null; var v_tx_256 = null; var v_ty_257 = null; var v_w_258 = null
	v_ctx_249 = J.arg(a, 0)
	v_str_250 = J.arg(a, 1)
	v_x_251 = J.arg(a, 2)
	v_y_252 = J.arg(a, 3)
	v_size_253 = J.arg(a, 4)
	v_col_254 = J.arg(a, 5)
	v_alpha_255 = J.arg(a, 6)
	v_tx_256 = J.arg(a, 7)
	v_ty_257 = J.arg(a, 8)
	if J.cmp(v_alpha_255, 0.0, "<="):
		return null
	var _t137 = J.max_([v_size_253, 8.0])
	v_size_253 = _t137
	J.mc(v_ctx_249, "save", [])
	var _t138 = ("bold " + J.str(v_size_253) + "px \"PingFang TC\",\"Noto Sans TC\",\"Noto Sans CJK TC\",sans-serif")
	J.sp(v_ctx_249, "font", _t138)
	v_w_258 = J.add(J.gp(J.mc(v_ctx_249, "measureText", [v_str_250]), "width"), J.mul(v_size_253, 1.1))
	J.mc(v_ctx_249, "restore", [])
	var _t139 = env["bubble"]
	J.cl(_t139, null, [v_ctx_249, v_x_251, v_y_252, v_w_258, J.mul(v_size_253, 1.75), v_alpha_255, v_tx_256, v_ty_257])
	var _t140 = env["crayonText"]
	J.cl(_t140, null, [v_ctx_249, v_str_250, v_x_251, v_y_252, v_size_253, v_col_254, v_alpha_255])

func _f39(this_, a: Array, env):
	var v_ctx_261 = null; var v_x_262 = null; var v_y_263 = null; var v_r_264 = null; var v_rot_265 = null; var v_alpha_266 = null
	v_ctx_261 = J.arg(a, 0)
	v_x_262 = J.arg(a, 1)
	v_y_263 = J.arg(a, 2)
	v_r_264 = J.arg(a, 3)
	v_rot_265 = J.arg(a, 4)
	v_alpha_266 = J.arg(a, 5)
	if J.cmp(v_alpha_266, 0.0, "<="):
		return null
	J.mc(v_ctx_261, "save", [])
	var _t141 = J.mul(J.gp(v_ctx_261, "globalAlpha"), v_alpha_266)
	J.sp(v_ctx_261, "globalAlpha", _t141)
	J.mc(v_ctx_261, "translate", [v_x_262, v_y_263])
	J.mc(v_ctx_261, "rotate", [(v_rot_265 if J.t(v_rot_265) else 0.0)])
	J.mc(v_ctx_261, "beginPath", [])
	J.mc(v_ctx_261, "moveTo", [0.0, ((-J.num(v_r_264)) * 1.7)])
	J.mc(v_ctx_261, "quadraticCurveTo", [J.mul(v_r_264, 1.1), ((-J.num(v_r_264)) * 0.1), J.mul(v_r_264, 0.95), J.mul(v_r_264, 0.35)])
	J.mc(v_ctx_261, "arc", [0.0, J.mul(v_r_264, 0.35), J.mul(v_r_264, 0.95), 0.0, env["PI"]])
	J.mc(v_ctx_261, "quadraticCurveTo", [((-J.num(v_r_264)) * 1.1), ((-J.num(v_r_264)) * 0.1), 0.0, ((-J.num(v_r_264)) * 1.7)])
	J.mc(v_ctx_261, "closePath", [])
	J.sp(v_ctx_261, "fillStyle", "rgba(150,215,245,.92)")
	J.mc(v_ctx_261, "fill", [])
	var _t142 = J.max_([0.8, J.mul(v_r_264, 0.32)])
	J.sp(v_ctx_261, "lineWidth", _t142)
	J.sp(v_ctx_261, "strokeStyle", "#2f5568")
	J.mc(v_ctx_261, "stroke", [])
	J.sp(v_ctx_261, "fillStyle", "rgba(255,255,255,.85)")
	J.mc(v_ctx_261, "beginPath", [])
	J.mc(v_ctx_261, "ellipse", [((-J.num(v_r_264)) * 0.3), J.mul(v_r_264, 0.1), J.mul(v_r_264, 0.22), J.mul(v_r_264, 0.38), 0.3, 0.0, 7.0])
	J.mc(v_ctx_261, "fill", [])
	J.mc(v_ctx_261, "restore", [])

func _f40(this_, a: Array, env):
	var v_ctx_269 = null; var v_x_270 = null; var v_y_271 = null; var v_r_272 = null; var v_alpha_273 = null
	v_ctx_269 = J.arg(a, 0)
	v_x_270 = J.arg(a, 1)
	v_y_271 = J.arg(a, 2)
	v_r_272 = J.arg(a, 3)
	v_alpha_273 = J.arg(a, 4)
	var _t143 = J.cmp(v_alpha_273, 0.0, "<=")
	if (_t143 if _t143 else J.cmp(v_r_272, 0.2, "<=")):
		return null
	J.mc(v_ctx_269, "save", [])
	var _t144 = J.mul(J.gp(v_ctx_269, "globalAlpha"), v_alpha_273)
	J.sp(v_ctx_269, "globalAlpha", _t144)
	J.mc(v_ctx_269, "beginPath", [])
	J.mc(v_ctx_269, "arc", [v_x_270, v_y_271, v_r_272, 0.0, 7.0])
	J.sp(v_ctx_269, "fillStyle", "rgba(190,232,250,.45)")
	J.mc(v_ctx_269, "fill", [])
	var _t145 = J.max_([0.7, J.mul(v_r_272, 0.1)])
	J.sp(v_ctx_269, "lineWidth", _t145)
	J.sp(v_ctx_269, "strokeStyle", "rgba(70,120,150,.85)")
	J.mc(v_ctx_269, "stroke", [])
	J.sp(v_ctx_269, "fillStyle", "rgba(255,255,255,.9)")
	J.mc(v_ctx_269, "beginPath", [])
	J.mc(v_ctx_269, "ellipse", [J.sub(v_x_270, J.mul(v_r_272, 0.38)), J.sub(v_y_271, J.mul(v_r_272, 0.38)), J.mul(v_r_272, 0.2), J.mul(v_r_272, 0.13), (-0.7), 0.0, 7.0])
	J.mc(v_ctx_269, "fill", [])
	J.mc(v_ctx_269, "beginPath", [])
	J.mc(v_ctx_269, "arc", [J.add(v_x_270, J.mul(v_r_272, 0.3)), J.add(v_y_271, J.mul(v_r_272, 0.35)), J.mul(v_r_272, 0.07), 0.0, 7.0])
	J.mc(v_ctx_269, "fill", [])
	J.mc(v_ctx_269, "restore", [])

func _f41(this_, a: Array, env):
	var v_ctx_276 = null; var v_x_277 = null; var v_y_278 = null; var v_r_279 = null; var v_alpha_280 = null; var v_col_281 = null; var v_C3_282 = null; var v_I_283 = null; var v_sc_284 = null; var v_ox_285 = null; var v_oy_286 = null; var v_rr_287 = null
	v_ctx_276 = J.arg(a, 0)
	v_x_277 = J.arg(a, 1)
	v_y_278 = J.arg(a, 2)
	v_r_279 = J.arg(a, 3)
	v_alpha_280 = J.arg(a, 4)
	v_col_281 = J.arg(a, 5)
	if J.cmp(v_alpha_280, 0.0, "<="):
		return null
	var _t147 = J.leq(v_col_281, null)
	if J.t(_t147):
		var _t146 = env["ok"]
		_t147 = J.cl(_t146, null, ["fx_dust"])
	if J.t(_t147):
		v_I_283 = J.gp(J.G.get("SPR"), "fx_dust")
		v_sc_284 = J.div(J.mul(v_r_279, 2.0), J.max_([J.gp(v_I_283, "naturalWidth"), J.gp(v_I_283, "naturalHeight")]))
		J.mc(v_ctx_276, "save", [])
		var _t148 = J.mul(J.gp(v_ctx_276, "globalAlpha"), v_alpha_280)
		J.sp(v_ctx_276, "globalAlpha", _t148)
		J.mc(v_ctx_276, "drawImage", [v_I_283, J.sub(v_x_277, J.div(J.mul(J.gp(v_I_283, "naturalWidth"), v_sc_284), 2.0)), J.sub(v_y_278, J.div(J.mul(J.gp(v_I_283, "naturalHeight"), v_sc_284), 2.0)), J.mul(J.gp(v_I_283, "naturalWidth"), v_sc_284), J.mul(J.gp(v_I_283, "naturalHeight"), v_sc_284)])
		J.mc(v_ctx_276, "restore", [])
		return null
	J.mc(v_ctx_276, "save", [])
	var _t149 = J.mul(J.gp(v_ctx_276, "globalAlpha"), v_alpha_280)
	J.sp(v_ctx_276, "globalAlpha", _t149)
	v_C3_282 = [[0.0, 0.0, 0.55], [(-0.42), 0.12, 0.4], [0.42, 0.14, 0.42], [0.1, (-0.3), 0.38]]
	J.mc(v_ctx_276, "beginPath", [])
	for _t150 in J.iter(v_C3_282):
		var _t151 = J.gp(_t150, 0.0)
		v_ox_285 = _t151
		var _t152 = J.gp(_t150, 1.0)
		v_oy_286 = _t152
		var _t153 = J.gp(_t150, 2.0)
		v_rr_287 = _t153
		J.mc(v_ctx_276, "moveTo", [J.add(J.add(v_x_277, J.mul(v_ox_285, v_r_279)), J.mul(v_rr_287, v_r_279)), J.add(v_y_278, J.mul(v_oy_286, v_r_279))])
		J.mc(v_ctx_276, "arc", [J.add(v_x_277, J.mul(v_ox_285, v_r_279)), J.add(v_y_278, J.mul(v_oy_286, v_r_279)), J.mul(v_rr_287, v_r_279), 0.0, 7.0])
	var _t154 = J.max_([1.0, J.mul(v_r_279, 0.16)])
	J.sp(v_ctx_276, "lineWidth", _t154)
	J.sp(v_ctx_276, "strokeStyle", "rgba(70,70,85,.55)")
	J.mc(v_ctx_276, "stroke", [])
	var _t155 = (v_col_281 if J.t(v_col_281) else "rgba(230,225,210,.9)")
	J.sp(v_ctx_276, "fillStyle", _t155)
	J.mc(v_ctx_276, "fill", [])
	J.sp(v_ctx_276, "fillStyle", "rgba(255,255,255,.5)")
	J.mc(v_ctx_276, "beginPath", [])
	J.mc(v_ctx_276, "arc", [J.sub(v_x_277, J.mul(v_r_279, 0.15)), J.sub(v_y_278, J.mul(v_r_279, 0.22)), J.mul(v_r_279, 0.18), 0.0, 7.0])
	J.mc(v_ctx_276, "fill", [])
	J.mc(v_ctx_276, "restore", [])

func _f42(this_, a: Array, env):
	var v_ctx_290 = null; var v_x_291 = null; var v_y_292 = null; var v_r_293 = null; var v_n_294 = null; var v_a0_295 = null; var v_a1_296 = null; var v_alpha_297 = null; var v_col_298 = null; var v_w_299 = null; var v_i_300 = null; var v_an_301 = null
	v_ctx_290 = J.arg(a, 0)
	v_x_291 = J.arg(a, 1)
	v_y_292 = J.arg(a, 2)
	v_r_293 = J.arg(a, 3)
	v_n_294 = J.arg(a, 4)
	v_a0_295 = J.arg(a, 5)
	v_a1_296 = J.arg(a, 6)
	v_alpha_297 = J.arg(a, 7)
	v_col_298 = J.arg(a, 8)
	v_w_299 = J.arg(a, 9)
	if J.cmp(v_alpha_297, 0.0, "<="):
		return null
	J.mc(v_ctx_290, "save", [])
	var _t156 = J.mul(J.gp(v_ctx_290, "globalAlpha"), v_alpha_297)
	J.sp(v_ctx_290, "globalAlpha", _t156)
	var _t157 = (v_col_298 if J.t(v_col_298) else "#fff3c4")
	J.sp(v_ctx_290, "strokeStyle", _t157)
	var _t158 = (v_w_299 if J.t(v_w_299) else J.max_([1.2, J.mul(v_r_293, 0.12)]))
	J.sp(v_ctx_290, "lineWidth", _t158)
	J.sp(v_ctx_290, "lineCap", "round")
	v_i_300 = 0.0
	while true:
		if not J.cmp(v_i_300, v_n_294, "<"): break
		v_an_301 = J.add(v_a0_295, (J.sub(v_a1_296, v_a0_295) * (0.5 if J.seq(v_n_294, 1.0) else J.div(v_i_300, J.sub(v_n_294, 1.0)))))
		J.mc(v_ctx_290, "beginPath", [])
		J.mc(v_ctx_290, "moveTo", [J.add(v_x_291, (J.mul(cos(J.num(v_an_301)), v_r_293) * 0.55)), J.add(v_y_292, (J.mul(sin(J.num(v_an_301)), v_r_293) * 0.55))])
		J.mc(v_ctx_290, "lineTo", [J.add(v_x_291, J.mul(cos(J.num(v_an_301)), v_r_293)), J.add(v_y_292, J.mul(sin(J.num(v_an_301)), v_r_293))])
		J.mc(v_ctx_290, "stroke", [])
		v_i_300 = J.num(v_i_300) + 1.0
	J.mc(v_ctx_290, "restore", [])

func _f43(this_, a: Array, env):
	var v_ctx_304 = null; var v_x_305 = null; var v_y_306 = null; var v_r_307 = null; var v_alpha_308 = null; var v_I_309 = null; var v_sc_310 = null
	v_ctx_304 = J.arg(a, 0)
	v_x_305 = J.arg(a, 1)
	v_y_306 = J.arg(a, 2)
	v_r_307 = J.arg(a, 3)
	v_alpha_308 = J.arg(a, 4)
	if J.cmp(v_alpha_308, 0.0, "<="):
		return null
	var _t159 = env["ok"]
	if J.t(J.cl(_t159, null, ["fx_spark"])):
		v_I_309 = J.gp(J.G.get("SPR"), "fx_spark")
		v_sc_310 = J.div(J.mul(v_r_307, 2.0), J.max_([J.gp(v_I_309, "naturalWidth"), J.gp(v_I_309, "naturalHeight")]))
		J.mc(v_ctx_304, "save", [])
		var _t160 = J.mul(J.gp(v_ctx_304, "globalAlpha"), v_alpha_308)
		J.sp(v_ctx_304, "globalAlpha", _t160)
		J.mc(v_ctx_304, "drawImage", [v_I_309, J.sub(v_x_305, J.div(J.mul(J.gp(v_I_309, "naturalWidth"), v_sc_310), 2.0)), J.sub(v_y_306, J.div(J.mul(J.gp(v_I_309, "naturalHeight"), v_sc_310), 2.0)), J.mul(J.gp(v_I_309, "naturalWidth"), v_sc_310), J.mul(J.gp(v_I_309, "naturalHeight"), v_sc_310)])
		J.mc(v_ctx_304, "restore", [])
		return null
	var _t161 = env["lines"]
	J.cl(_t161, null, [v_ctx_304, v_x_305, v_y_306, v_r_307, 4.0, 0.0, J.mul(env["PI"], 1.5), v_alpha_308])

func _f44(this_, a: Array, env):
	var v_ctx_313 = null; var v_p_314 = null; var v_w_315 = null; var v_h_316 = null; var v_rot_317 = null; var v_alpha_318 = null
	v_ctx_313 = J.arg(a, 0)
	v_p_314 = J.arg(a, 1)
	v_w_315 = J.arg(a, 2)
	v_h_316 = J.arg(a, 3)
	v_rot_317 = J.arg(a, 4)
	v_alpha_318 = J.arg(a, 5)
	var _t162 = J.cmp(v_alpha_318, 0.0, "<=")
	if (_t162 if _t162 else J.cmp(v_h_316, 0.3, "<=")):
		return null
	J.mc(v_ctx_313, "save", [])
	var _t163 = J.mul(J.gp(v_ctx_313, "globalAlpha"), v_alpha_318)
	J.sp(v_ctx_313, "globalAlpha", _t163)
	J.mc(v_ctx_313, "translate", [J.gp(v_p_314, "x"), J.gp(v_p_314, "y")])
	J.mc(v_ctx_313, "rotate", [(v_rot_317 if J.t(v_rot_317) else 0.0)])
	J.mc(v_ctx_313, "beginPath", [])
	J.mc(v_ctx_313, "ellipse", [0.0, J.mul(v_h_316, 0.25), v_w_315, v_h_316, 0.0, 0.0, 7.0])
	J.sp(v_ctx_313, "fillStyle", "#4a2027")
	J.mc(v_ctx_313, "fill", [])
	var _t164 = J.max_([0.9, J.mul(v_w_315, 0.32)])
	J.sp(v_ctx_313, "lineWidth", _t164)
	J.sp(v_ctx_313, "strokeStyle", "#33221f")
	J.mc(v_ctx_313, "stroke", [])
	J.mc(v_ctx_313, "beginPath", [])
	J.mc(v_ctx_313, "ellipse", [0.0, (J.mul(v_h_316, 0.25) + J.mul(v_h_316, 0.5)), J.mul(v_w_315, 0.6), J.mul(v_h_316, 0.35), 0.0, env["PI"], J.mul(2.0, env["PI"])])
	J.sp(v_ctx_313, "fillStyle", "#b8565c")
	J.mc(v_ctx_313, "fill", [])
	J.mc(v_ctx_313, "restore", [])

func _f46(this_, a: Array, env):
	var v_a_323 = null; var v_k_324 = null
	v_a_323 = J.arg(a, 0)
	var _t165 = J.gp(J.gp(v_a_323, "o"), "hid")
	v_k_324 = (_t165 if J.t(_t165) else "hero")
	var _t168 = J.gp(env["MEM"], v_k_324)
	if not J.t(_t168):
		var _t166 = env["MEM"]
		var _t167 = {"name": null, "P": null, "st": null, "from": null, "fromSt": null}
		J.sp(_t166, v_k_324, _t167)
		_t168 = _t167
	return _t168

func _f48(this_, a: Array, env):
	var v_a_329 = null; var v_R_330 = null
	v_a_329 = J.arg(a, 0)
	var _t169 = env["solveRig"]
	var _t170 = env["addP"]
	v_R_330 = J.cl(_t169, null, [v_a_329, J.cl(_t170, null, [J.cl(env["Z"], null, []), env["PLANT"]]), 0.0])
	var _t171 = J.mc(J.gp(v_R_330, "G"), "inverse", [])
	return J.mc(_t171, "multiply", [J.gp(v_R_330, "Mg")])

func _f64(this_, a: Array, env):
	var v_t0_464 = null
	v_t0_464 = J.arg(a, 0)
	return [[0.0, {}], [J.add(v_t0_464, 0.38), {"th": 62.0, "lean": 7.0, "dx": (-0.03), "dy": (-0.02), "sx": (-0.03), "sy": 0.04, "head": 0.05, "bob": (-0.6)}, "o"], [J.add(v_t0_464, 0.52), J.S_Object_("assign", [{}, env["PLANT"]]), "i"]]

func _f67(this_, a: Array, env):
	var v_ctx_496 = null; var v_a_497 = null; var v_R_498 = null; var v_at_499 = null; var v_tHit_500 = null; var v_s_501 = null; var v_g_502 = null; var v_k_503 = null; var v_sd_504 = null
	v_ctx_496 = J.arg(a, 0)
	v_a_497 = J.arg(a, 1)
	v_R_498 = J.arg(a, 2)
	v_at_499 = J.arg(a, 3)
	v_tHit_500 = J.arg(a, 4)
	v_s_501 = J.gp(v_R_498, "H")
	var _t172 = J.gp(v_R_498, "G")
	var _t173 = env["plantM"]
	var _t174 = J.mc(_t172, "multiply", [J.cl(_t173, null, [v_a_497])])
	v_g_502 = J.mc(_t174, "transformPoint", [J.construct(J.G.get("DOMPoint"), [J.mul(J.gp(J.gp(v_R_498, "axU"), 0.0), J.gp(v_R_498, "al")), J.mul(J.gp(J.gp(v_R_498, "axU"), 1.0), J.gp(v_R_498, "al"))])])
	var _t175 = env["seg"]
	v_k_503 = J.cl(_t175, null, [v_at_499, v_tHit_500, J.add(v_tHit_500, 0.55)])
	var _t176 = J.cmp(v_k_503, 0.0, ">")
	if (J.cmp(v_k_503, 1.0, "<") if _t176 else _t176):
		for _t177 in J.iter([(-1.0), 1.0]):
			v_sd_504 = _t177
			var _t178 = env["puff"]
			J.cl(_t178, null, [v_ctx_496, J.add(J.gp(v_g_502, "x"), (J.mul(v_sd_504, v_s_501) * (0.05 + J.mul(v_k_503, 0.1)))), (J.sub(J.gp(v_g_502, "y"), J.mul(v_s_501, 0.02)) - (J.mul(v_k_503, v_s_501) * 0.05)), J.mul(v_s_501, (0.04 + J.mul(v_k_503, 0.06))), (J.sub(1.0, v_k_503) * 0.9)])
		var _t179 = env["lines"]
		var _t181 = J.gp(v_g_502, "x")
		var _t182 = J.sub(J.gp(v_g_502, "y"), J.mul(v_s_501, 0.02))
		var _t183 = J.mul(v_s_501, 0.14)
		var _t184 = ((-J.num(env["PI"])) * 0.95)
		var _t185 = ((-J.num(env["PI"])) * 0.05)
		var _t180 = env["cl"]
		J.cl(_t179, null, [v_ctx_496, _t181, _t182, _t183, 5.0, _t184, _t185, J.cl(_t180, null, [(J.sub(0.25, v_k_503) * 4.0)]), "#fff1c8"])
	if J.cmp(v_at_499, v_tHit_500, ">="):
		J.mc(v_ctx_496, "save", [])
		var _t186 = J.mul(J.gp(v_ctx_496, "globalAlpha"), 0.8)
		J.sp(v_ctx_496, "globalAlpha", _t186)
		J.sp(v_ctx_496, "strokeStyle", "rgba(30,22,18,.75)")
		var _t187 = J.max_([1.0, J.mul(v_s_501, 0.012)])
		J.sp(v_ctx_496, "lineWidth", _t187)
		J.sp(v_ctx_496, "lineCap", "round")
		J.mc(v_ctx_496, "beginPath", [])
		J.mc(v_ctx_496, "moveTo", [J.sub(J.gp(v_g_502, "x"), J.mul(v_s_501, 0.07)), J.add(J.gp(v_g_502, "y"), J.mul(v_s_501, 0.005))])
		J.mc(v_ctx_496, "quadraticCurveTo", [J.gp(v_g_502, "x"), J.sub(J.gp(v_g_502, "y"), J.mul(v_s_501, 0.012)), J.add(J.gp(v_g_502, "x"), J.mul(v_s_501, 0.07)), J.add(J.gp(v_g_502, "y"), J.mul(v_s_501, 0.005))])
		J.mc(v_ctx_496, "stroke", [])
		J.mc(v_ctx_496, "restore", [])

func _f73(this_, a: Array, env):
	var v_name_548 = null; var v_ctx_549 = null; var v_a_550 = null; var v_o_551 = null; var v_t_552 = null; var v_at_553 = null; var v_m_554 = null; var v_r_555 = null; var v_P_556 = null; var v_st_557 = null; var v_bk_558 = null; var v_R_559 = null; var v_k_560 = null; var v_k_561 = null
	v_name_548 = J.arg(a, 0)
	v_ctx_549 = J.arg(a, 1)
	v_a_550 = J.arg(a, 2)
	var _t188 = env["ok"]
	var _t190 = (not J.t(J.cl(_t188, null, ["afu__body"])))
	if not J.t(_t190):
		var _t189 = env["ok"]
		_t190 = (not J.t(J.cl(_t189, null, ["afu__arm"])))
	var _t194 = _t190
	if not J.t(_t194):
		var _t191 = env["ok"]
		var _t193 = J.cl(_t191, null, ["afu__axe"])
		if not J.t(_t193):
			var _t192 = env["ok"]
			_t193 = J.cl(_t192, null, ["afu__wpn"])
		_t194 = (not J.t(_t193))
	var _t195 = (_t194 if _t194 else (not J.seq(J.gp(v_a_550, "type"), "afu")))
	if (_t195 if _t195 else J.seq(J.typeof_(J.G.get("LIMBS_DATA")), "undefined")):
		return false
	v_o_551 = J.gp(v_a_550, "o")
	var _t196 = J.gp(v_o_551, "t")
	v_t_552 = (_t196 if J.t(_t196) else 0.0)
	var _t197 = J.gp(v_o_551, "at")
	v_at_553 = (_t197 if J.t(_t197) else 0.0)
	var _t198 = env["mem"]
	v_m_554 = J.cl(_t198, null, [v_a_550])
	var _t199 = env["ACT"]
	v_r_555 = J.mc(_t199, v_name_548, [v_a_550, v_at_553, v_t_552])
	var _t200 = env["addP"]
	var _t201 = env["rest"]
	v_P_556 = J.cl(_t200, null, [J.cl(_t201, null, [v_t_552]), J.gp(v_r_555, "P")])
	v_st_557 = J.gp(v_r_555, "st")
	if (not J.seq(J.gp(v_m_554, "name"), v_name_548)):
		if J.t(J.gp(v_m_554, "P")):
			var _t202 = J.gp(v_m_554, "P")
			J.sp(v_m_554, "from", _t202)
			var _t203 = J.gp(v_m_554, "st")
			J.sp(v_m_554, "fromSt", _t203)
			J.sp(v_m_554, "fromT", v_t_552)
			J.sp(v_m_554, "fromAt", v_at_553)
		J.sp(v_m_554, "name", v_name_548)
	var _t205 = null
	if J.t(J.gp(v_m_554, "from")):
		var _t204 = env["cl"]
		_t205 = J.cl(_t204, null, [J.div(J.sub(v_t_552, J.gp(v_m_554, "fromT")), env["BLEND"])])
	else:
		_t205 = 1.0
	v_bk_558 = _t205
	var _t206 = J.gp(v_m_554, "from")
	if J.t((J.cmp(v_bk_558, 1.0, "<") if J.t(_t206) else _t206)):
		v_k_560 = J.mc(env["E"], "io", [v_bk_558])
		var _t207 = env["lerpP"]
		var _t208 = J.cl(_t207, null, [J.gp(v_m_554, "from"), v_P_556, v_k_560])
		v_P_556 = _t208
		var _t209 = J.gp(v_m_554, "fromSt")
		var _t210 = (J.seq(J.gp(J.gp(v_m_554, "fromSt"), "axe"), "plant") if J.t(_t209) else _t209)
		if J.t((J.seq(J.gp(v_st_557, "axe"), "hand") if J.t(_t210) else _t210)):
			var _t211 = J.S_Object_("assign", [{}, v_st_557, {"axe": "hand", "axeBlend": {"M": J.gp(J.gp(v_m_554, "fromSt"), "plantM"), "k": v_k_560}}])
			v_st_557 = _t211
		var _t212 = J.gp(v_m_554, "fromSt")
		var _t213 = (J.cmp(J.gp(J.gp(v_m_554, "fromSt"), "phone"), 0.0, ">") if J.t(_t212) else _t212)
		if J.t(((not J.cmp(J.gp(v_st_557, "phone"), 0.0, ">")) if J.t(_t213) else _t213)):
			var _t214 = J.S_Object_("assign", [{}, v_st_557, {"phone": J.mul(J.gp(J.gp(v_m_554, "fromSt"), "phone"), J.sub(1.0, v_k_560))}])
			v_st_557 = _t214
	else:
		J.sp(v_m_554, "from", null)
	J.sp(v_m_554, "P", v_P_556)
	J.sp(v_m_554, "st", v_st_557)
	var _t215 = (not J.leq(J.gp(v_m_554, "lx"), null))
	if (J.cmp(v_t_552, J.gp(v_m_554, "lt"), ">") if _t215 else _t215):
		var _t216 = env["cl"]
		v_k_561 = J.cl(_t216, null, [(J.sub(v_t_552, J.gp(v_m_554, "lt")) * 6.0)])
		var _t217 = J.gp(v_m_554, "vx")
		var _t218 = (J.mul((_t217 if J.t(_t217) else 0.0), J.sub(1.0, v_k_561)) + J.mul(J.div(J.sub(J.gp(v_a_550, "x"), J.gp(v_m_554, "lx")), J.sub(v_t_552, J.gp(v_m_554, "lt"))), v_k_561))
		J.sp(v_m_554, "vx", _t218)
		var _t219 = J.gp(v_m_554, "vy")
		var _t220 = (J.mul((_t219 if J.t(_t219) else 0.0), J.sub(1.0, v_k_561)) + J.mul(J.div(J.sub(J.gp(v_a_550, "y"), J.gp(v_m_554, "ly")), J.sub(v_t_552, J.gp(v_m_554, "lt"))), v_k_561))
		J.sp(v_m_554, "vy", _t220)
	var _t221 = J.gp(v_a_550, "x")
	J.sp(v_m_554, "lx", _t221)
	var _t222 = J.gp(v_a_550, "y")
	J.sp(v_m_554, "ly", _t222)
	J.sp(v_m_554, "lt", v_t_552)
	if J.t(J.gp(v_r_555, "stone")):
		var _t223 = env["drawStone"]
		J.cl(_t223, null, [v_ctx_549, v_a_550, J.gp(v_r_555, "stone"), v_m_554])
	if J.t(J.gp(v_st_557, "axeBlend")):
		var _t224 = env["renderBlendAxe"]
		return J.cl(_t224, null, [v_ctx_549, v_a_550, v_P_556, v_st_557, v_t_552, v_r_555])
	var _t225 = env["render"]
	v_R_559 = J.cl(_t225, null, [v_ctx_549, v_a_550, v_P_556, v_st_557, v_t_552])
	if J.t(J.gp(v_r_555, "fx")):
		J.mc(v_ctx_549, "save", [])
		J.mc(v_r_555, "fx", [v_ctx_549, v_R_559])
		J.mc(v_ctx_549, "restore", [])
	return true

func _f75(this_, a: Array, env):
	var v_m_587 = null
	v_m_587 = J.arg(a, 0)
	return atan2(J.num(J.gp(v_m_587, "b")), J.num(J.gp(v_m_587, "a")))

func _f74(this_, a: Array, env):
	var v_ctx_564 = null; var v_a_565 = null; var v_P_566 = null; var v_st_567 = null; var v_t_568 = null; var v_r_569 = null; var v_s2_570 = null; var v_R_571 = null; var v_A_572 = null; var v_B_573 = null; var v_k_574 = null; var v_ang_575 = null; var v_a0_576 = null; var v_a1_577 = null; var v_da_578 = null; var v_sxA_579 = null; var v_an_580 = null; var v_sc_581 = null; var v_det_582 = null; var v_Mx_583 = null; var v_base_584 = null; var v_wp_585 = null; var v_c_586 = null
	v_ctx_564 = J.arg(a, 0)
	v_a_565 = J.arg(a, 1)
	v_P_566 = J.arg(a, 2)
	v_st_567 = J.arg(a, 3)
	v_t_568 = J.arg(a, 4)
	v_r_569 = J.arg(a, 5)
	v_s2_570 = J.S_Object_("assign", [{}, v_st_567, {"axe": "none"}])
	var _t226 = env["render"]
	v_R_571 = J.cl(_t226, null, [v_ctx_564, v_a_565, v_P_566, v_s2_570, v_t_568])
	var _t227 = J.gp(v_R_571, "G")
	v_A_572 = J.mc(_t227, "multiply", [J.gp(J.gp(v_st_567, "axeBlend"), "M")])
	v_B_573 = J.gp(v_R_571, "Mg")
	v_k_574 = J.gp(J.gp(v_st_567, "axeBlend"), "k")
	v_ang_575 = Callable(self, "_f75").bind(env)
	v_a0_576 = J.cl(v_ang_575, null, [v_A_572])
	v_a1_577 = J.cl(v_ang_575, null, [v_B_573])
	v_da_578 = J.sub(v_a1_577, v_a0_576)
	while true:
		if not J.cmp(v_da_578, env["PI"], ">"): break
		var _t228 = J.sub(v_da_578, J.mul(2.0, env["PI"]))
		v_da_578 = _t228
	while true:
		if not J.cmp(v_da_578, (-J.num(env["PI"])), "<"): break
		var _t229 = J.add(v_da_578, J.mul(2.0, env["PI"]))
		v_da_578 = _t229
	v_sxA_579 = (J.hypot_([J.gp(v_A_572, "a"), J.gp(v_A_572, "b")]) * signf(J.num((J.mul(J.gp(v_A_572, "a"), J.gp(v_A_572, "d")) - J.mul(J.gp(v_A_572, "b"), J.gp(v_A_572, "c"))))))
	v_an_580 = J.add(v_a0_576, J.mul(v_da_578, v_k_574))
	v_sc_581 = (J.hypot_([J.gp(v_A_572, "a"), J.gp(v_A_572, "b")]) + J.mul((J.hypot_([J.gp(v_B_573, "a"), J.gp(v_B_573, "b")]) - J.hypot_([J.gp(v_A_572, "a"), J.gp(v_A_572, "b")])), v_k_574))
	v_det_582 = signf(J.num((J.mul(J.gp(v_B_573, "a"), J.gp(v_B_573, "d")) - J.mul(J.gp(v_B_573, "b"), J.gp(v_B_573, "c")))))
	v_Mx_583 = J.construct(J.G.get("DOMMatrix"), [[J.mul(cos(J.num(v_an_580)), v_sc_581), J.mul(sin(J.num(v_an_580)), v_sc_581), J.mul(J.mul((-sin(J.num(v_an_580))), v_sc_581), v_det_582), J.mul(J.mul(cos(J.num(v_an_580)), v_sc_581), v_det_582), J.add(J.gp(v_A_572, "e"), J.mul(J.sub(J.gp(v_B_573, "e"), J.gp(v_A_572, "e")), v_k_574)), J.add(J.gp(v_A_572, "f"), J.mul(J.sub(J.gp(v_B_573, "f"), J.gp(v_A_572, "f")), v_k_574))]])
	v_base_584 = J.mc(v_ctx_564, "getTransform", [])
	v_wp_585 = J.cl(env["WP"], null, [])
	J.mc(v_ctx_564, "save", [])
	J.mc(v_ctx_564, "setTransform", [J.mc(v_base_584, "multiply", [v_Mx_583])])
	J.mc(v_ctx_564, "drawImage", [J.cl(env["AXE"], null, []), J.mul((-J.num(J.gp(J.gp(v_wp_585, "grip"), 0.0))), J.gp(v_R_571, "ww")), J.mul((-J.num(J.gp(J.gp(v_wp_585, "grip"), 1.0))), J.gp(v_R_571, "wh")), J.gp(v_R_571, "ww"), J.gp(v_R_571, "wh")])
	J.mc(v_ctx_564, "restore", [])
	J.mc(v_ctx_564, "save", [])
	J.mc(v_ctx_564, "setTransform", [J.mc(v_base_584, "multiply", [J.gp(v_R_571, "Ma")])])
	v_c_586 = J.cl(env["LD"], null, [])
	J.mc(v_ctx_564, "drawImage", [J.gp(J.G.get("SPR"), "afu__arm"), J.mul((-J.num(J.gp(J.gp(v_c_586, "pivot"), 0.0))), J.gp(v_R_571, "W")), J.mul((-J.num(J.gp(J.gp(v_c_586, "pivot"), 1.0))), J.gp(v_R_571, "H")), J.gp(v_R_571, "W"), J.gp(v_R_571, "H")])
	J.mc(v_ctx_564, "restore", [])
	if J.t(J.gp(v_r_569, "fx")):
		J.mc(v_ctx_564, "save", [])
		J.mc(v_r_569, "fx", [v_ctx_564, v_R_571])
		J.mc(v_ctx_564, "restore", [])
	return true

func _f76(this_, a: Array, env):
	var v_ctx_590 = null; var v_a_591 = null; var v_st_592 = null; var v_m_593 = null; var v_key_594 = null; var v_H_595 = null; var v_s_596 = null; var v_al_597 = null; var v_T_598 = null; var v_vx_599 = null; var v_vy_600 = null; var v_sp_601 = null; var v_dx_602 = null; var v_dy_603 = null
	v_ctx_590 = J.arg(a, 0)
	v_a_591 = J.arg(a, 1)
	v_st_592 = J.arg(a, 2)
	v_m_593 = J.arg(a, 3)
	var _t230 = J.gp(J.gp(v_a_591, "o"), "hid")
	v_key_594 = (_t230 if J.t(_t230) else "hero")
	v_H_595 = J.gp(v_a_591, "H")
	v_s_596 = J.gp(env["stones"], v_key_594)
	var _t231 = (not J.t(v_s_596))
	if (_t231 if _t231 else J.cmp(J.gp(v_st_592, "k"), J.sub(J.gp(v_s_596, "k"), 0.01), "<")):
		v_T_598 = (J.sub(0.45, J.gp(v_st_592, "k")) * 0.55)
		var _t232 = J.gp(v_m_593, "vx")
		v_vx_599 = (_t232 if J.t(_t232) else 0.0)
		var _t233 = J.gp(v_m_593, "vy")
		v_vy_600 = (_t233 if J.t(_t233) else 0.0)
		v_sp_601 = J.hypot_([v_vx_599, v_vy_600])
		v_dx_602 = (J.mul(v_vx_599, v_T_598) if J.cmp(v_sp_601, 3.0, ">") else (J.mul((1.0 if J.t(J.gp(v_a_591, "faceRight")) else (-1.0)), v_H_595) * 0.3))
		v_dy_603 = (J.mul(v_vy_600, v_T_598) if J.cmp(v_sp_601, 3.0, ">") else 0.0)
		var _t234 = env["stones"]
		var _t235 = {"x": J.add(J.gp(v_a_591, "x"), v_dx_602), "y": J.add(J.add(J.gp(v_a_591, "y"), v_dy_603), J.mul(v_H_595, 0.01)), "k": J.gp(v_st_592, "k")}
		J.sp(_t234, v_key_594, _t235)
		v_s_596 = _t235
	var _t236 = J.gp(v_st_592, "k")
	J.sp(v_s_596, "k", _t236)
	var _t237 = env["cl"]
	var _t239 = J.cl(_t237, null, [(1.0 - J.div(absf(J.num(J.sub(J.gp(v_st_592, "k"), 0.2))), 1.4))])
	var _t238 = env["cl"]
	v_al_597 = J.mul(_t239, J.cl(_t238, null, [(J.sub(1.6, J.gp(v_st_592, "k")) * 3.0)]))
	if J.cmp(v_al_597, 0.0, "<="):
		return null
	J.mc(v_ctx_590, "save", [])
	var _t240 = J.mul(J.gp(v_ctx_590, "globalAlpha"), v_al_597)
	J.sp(v_ctx_590, "globalAlpha", _t240)
	J.mc(v_ctx_590, "translate", [J.gp(v_s_596, "x"), J.gp(v_s_596, "y")])
	J.mc(v_ctx_590, "scale", [1.35, 1.35])
	J.sp(v_ctx_590, "fillStyle", "rgba(0,0,0,.28)")
	J.mc(v_ctx_590, "beginPath", [])
	J.mc(v_ctx_590, "ellipse", [0.0, J.mul(v_H_595, 0.012), J.mul(v_H_595, 0.07), J.mul(v_H_595, 0.02), 0.0, 0.0, 7.0])
	J.mc(v_ctx_590, "fill", [])
	J.mc(v_ctx_590, "beginPath", [])
	J.mc(v_ctx_590, "moveTo", [((-J.num(v_H_595)) * 0.06), 0.0])
	J.mc(v_ctx_590, "quadraticCurveTo", [((-J.num(v_H_595)) * 0.055), ((-J.num(v_H_595)) * 0.05), ((-J.num(v_H_595)) * 0.01), ((-J.num(v_H_595)) * 0.055)])
	J.mc(v_ctx_590, "quadraticCurveTo", [J.mul(v_H_595, 0.05), ((-J.num(v_H_595)) * 0.05), J.mul(v_H_595, 0.06), ((-J.num(v_H_595)) * 0.005)])
	J.mc(v_ctx_590, "quadraticCurveTo", [0.0, J.mul(v_H_595, 0.012), ((-J.num(v_H_595)) * 0.06), 0.0])
	J.mc(v_ctx_590, "closePath", [])
	J.sp(v_ctx_590, "fillStyle", "#86828a")
	J.mc(v_ctx_590, "fill", [])
	var _t241 = J.max_([0.8, J.mul(v_H_595, 0.012)])
	J.sp(v_ctx_590, "lineWidth", _t241)
	J.sp(v_ctx_590, "strokeStyle", "#2a2428")
	J.mc(v_ctx_590, "stroke", [])
	J.sp(v_ctx_590, "fillStyle", "rgba(255,255,255,.18)")
	J.mc(v_ctx_590, "beginPath", [])
	J.mc(v_ctx_590, "ellipse", [((-J.num(v_H_595)) * 0.015), ((-J.num(v_H_595)) * 0.035), J.mul(v_H_595, 0.025), J.mul(v_H_595, 0.01), (-0.2), 0.0, 7.0])
	J.mc(v_ctx_590, "fill", [])
	J.mc(v_ctx_590, "restore", [])

func _f78(this_, a: Array, env):
	var v_n_609 = null
	v_n_609 = J.arg(a, 0)
	var _t242 = env["Q"]
	J.sp(_t242, "cur", v_n_609)
	var _t243 = env["Q"]
	J.sp(_t243, "at", 0.0)
	if J.t(J.gp(env["COOL"], v_n_609)):
		var _t244 = J.gp(env["Q"], "cool")
		var _t245 = J.mul(J.gp(env["COOL"], v_n_609), (0.8 + (randf() * 0.5)))
		J.sp(_t244, v_n_609, _t245)
	var _t246 = env["Q"]
	J.sp(_t246, "last", v_n_609)
	if J.seq(v_n_609, "doze"):
		var _t247 = env["Q"]
		var _t248 = (14.0 + (randf() * 10.0))
		J.sp(_t247, "dozeEnd", _t248)

func _f79(this_, a: Array, env):
	var _t249 = env["Q"]
	J.sp(_t249, "cur", null)
	var _t250 = env["Q"]
	J.sp(_t250, "at", 0.0)
	var _t251 = env["Q"]
	J.sp(_t251, "idle", 0.0)
	var _t252 = env["Q"]
	var _t253 = (3.0 + (randf() * 4.0))
	J.sp(_t252, "next", _t253)

func _f81(this_, a: Array, env):
	var v_n_623 = null
	var _t288 = J.gp(J.arg(a, 0), 0.0)
	v_n_623 = _t288
	var _t289 = (not J.cmp(J.gp(J.gp(env["Q"], "cool"), v_n_623), 0.0, ">"))
	var _t291 = ((not J.seq(v_n_623, J.gp(env["Q"], "last"))) if _t289 else _t289)
	if J.t(_t291):
		var _t290 = (not J.seq(v_n_623, "doze"))
		_t291 = (_t290 if _t290 else J.cmp(J.gp(env["Q"], "idle"), 8.0, ">"))
	return _t291

func _f82(this_, a: Array, env):
	var v_s_624 = null; var v_x_625 = null
	v_s_624 = J.arg(a, 0)
	v_x_625 = J.arg(a, 1)
	return J.add(v_s_624, J.gp(v_x_625, 1.0))

func _f80(this_, a: Array, env):
	var v_V_614 = null; var v_dt_615 = null; var v_H_616 = null; var v_pr_617 = null; var v_ak_618 = null; var v_k_619 = null; var v_nx_620 = null; var v_c_621 = null; var v_r_622 = null; var v_n_626 = null; var v_w_627 = null
	v_V_614 = J.arg(a, 0)
	v_dt_615 = J.arg(a, 1)
	v_H_616 = J.gp(v_V_614, "hero")
	for _t254 in J.keys(J.gp(env["Q"], "cool")):
		v_k_619 = _t254
		var _t255 = J.gp(env["Q"], "cool")
		var _t256 = J.sub(J.gp(_t255, v_k_619), v_dt_615)
		J.sp(_t255, v_k_619, _t256)
	var _t257 = J.gp(v_V_614, "proudT")
	v_pr_617 = (_t257 if J.t(_t257) else 0.0)
	v_ak_618 = (J.gp(J.gp(v_H_616, "act"), "kind") if J.t(J.gp(v_H_616, "act")) else null)
	var _t258 = J.cmp(v_pr_617, 0.0, ">")
	if (J.cmp(J.gp(env["Q"], "prevProud"), 0.0, "<=") if _t258 else _t258):
		var _t259 = env["start"]
		J.cl(_t259, null, ["proud"])
		var _t260 = env["Q"]
		var _t261 = (("sweat" if (randf() < 0.65) else null) if J.seq(J.gp(env["Q"], "lastKind"), "tree") else ("dust" if (randf() < 0.6) else "sweat"))
		J.sp(_t260, "after", _t261)
	else:
		var _t262 = J.gp(env["Q"], "hadAct")
		var _t263 = ((not J.t(v_ak_618)) if J.t(_t262) else _t262)
		var _t264 = ((not J.t(J.gp(v_H_616, "walking"))) if J.t(_t263) else _t263)
		var _t265 = ((not J.t(J.gp(v_H_616, "target"))) if J.t(_t264) else _t264)
		if J.t((J.seq(J.gp(env["Q"], "lastKind"), "craft") if J.t(_t265) else _t265)):
			var _t266 = env["start"]
			J.cl(_t266, null, [("dust" if (randf() < 0.65) else "sweat")])
	var _t267 = env["Q"]
	J.sp(_t267, "prevProud", v_pr_617)
	var _t268 = env["Q"]
	var _t269 = (not (not J.t(v_ak_618)))
	J.sp(_t268, "hadAct", _t269)
	if J.t(v_ak_618):
		var _t270 = env["Q"]
		J.sp(_t270, "lastKind", v_ak_618)
	if J.t(J.gp(v_H_616, "walking")):
		if J.t(J.gp(env["Q"], "cur")):
			var _t271 = env["Q"]
			J.sp(_t271, "cur", null)
		var _t272 = env["Q"]
		var _t273 = J.add(J.gp(_t272, "walkT"), v_dt_615)
		J.sp(_t272, "walkT", _t273)
		var _t274 = env["Q"]
		J.sp(_t274, "idle", 0.0)
		return null
	var _t275 = env["Q"]
	J.sp(_t275, "walkT", 0.0)
	if J.t(J.gp(v_H_616, "act")):
		var _t276 = env["Q"]
		J.sp(_t276, "cur", null)
		var _t277 = env["Q"]
		J.sp(_t277, "idle", 0.0)
		return null
	if J.t(J.gp(env["Q"], "cur")):
		var _t278 = env["Q"]
		var _t279 = J.add(J.gp(_t278, "at"), v_dt_615)
		J.sp(_t278, "at", _t279)
		if J.seq(J.gp(env["Q"], "cur"), "doze"):
			if J.cmp(J.gp(env["Q"], "at"), J.add(1.8, J.gp(env["Q"], "dozeEnd")), ">"):
				var _t280 = env["start"]
				J.cl(_t280, null, ["wake"])
			return null
		if J.cmp(J.gp(env["Q"], "at"), J.gp(env["LEN"], J.gp(env["Q"], "cur")), ">="):
			v_nx_620 = J.gp(env["Q"], "after")
			var _t281 = env["Q"]
			J.sp(_t281, "after", null)
			if J.t((J.seq(J.gp(env["Q"], "cur"), "proud") if J.t(v_nx_620) else v_nx_620)):
				var _t282 = env["start"]
				J.cl(_t282, null, [v_nx_620])
			else:
				J.cl(env["stop"], null, [])
		return null
	var _t283 = env["Q"]
	var _t284 = J.add(J.gp(_t283, "idle"), v_dt_615)
	J.sp(_t283, "idle", _t284)
	var _t287 = J.cmp(J.gp(env["Q"], "idle"), J.gp(env["Q"], "next"), ">=")
	if J.t(_t287):
		var _t285 = (not J.seq(J.typeof_(J.G.get("Story")), "undefined"))
		var _t286 = (J.gp(J.G.get("Story"), "busy") if _t285 else _t285)
		_t287 = (not J.t((J.mc(J.G.get("Story"), "busy", []) if J.t(_t286) else _t286)))
	if _t287:
		v_c_621 = J.mc(env["PICK"], "filter", [Callable(self, "_f81").bind(env)])
		if (not J.t(J.len(v_c_621))):
			var _t292 = env["Q"]
			var _t293 = J.add(J.gp(env["Q"], "idle"), 2.0)
			J.sp(_t292, "next", _t293)
			return null
		v_r_622 = J.mul(randf(), J.mc(v_c_621, "reduce", [Callable(self, "_f82").bind(env), 0.0]))
		for _t294 in J.iter(v_c_621):
			var _t295 = J.gp(_t294, 0.0)
			v_n_626 = _t295
			var _t296 = J.gp(_t294, 1.0)
			v_w_627 = _t296
			var _t297 = J.sub(v_r_622, v_w_627)
			v_r_622 = _t297
			if (v_r_622 <= 0.0):
				var _t298 = env["start"]
				J.cl(_t298, null, [v_n_626])
				break

func _f83(this_, a: Array, env):
	var v_V_630 = null; var v_x_631 = null; var v_y_632 = null; var v_H_633 = null
	v_V_630 = J.arg(a, 0)
	v_x_631 = J.arg(a, 1)
	v_y_632 = J.arg(a, 2)
	v_H_633 = J.gp(v_V_630, "hero")
	var _t299 = J.seq(J.gp(env["Q"], "cur"), "doze")
	if (J.cmp(J.gp(env["Q"], "at"), 0.75, ">") if _t299 else _t299):
		var _t300 = env["start"]
		J.cl(_t300, null, ["wake"])
		return (J.hypot_([J.sub(v_x_631, J.gp(v_H_633, "x")), J.sub(v_y_632, J.sub(J.gp(v_H_633, "y"), 22.0))]) < 40.0)
	return false

func _f84(this_, a: Array, env):
	var v_V_636 = null; var v_H_637 = null
	v_V_636 = J.arg(a, 0)
	v_H_637 = J.gp(v_V_636, "hero")
	if J.t(J.gp(v_H_637, "walking")):
		return {"act": "hero_walk", "at": J.gp(env["Q"], "walkT")}
	if J.t(J.gp(v_H_637, "act")):
		return null
	if J.t(J.gp(env["Q"], "cur")):
		return {"act": J.add("hero_", J.gp(env["Q"], "cur")), "at": J.gp(env["Q"], "at")}
	return {"act": "hero_idle", "at": J.gp(env["Q"], "idle")}

func _f2(this_, a: Array, env):
	var v_v_63 = null; var v_a_64 = null; var v_b_65 = null
	v_v_63 = J.arg(a, 0)
	v_a_64 = J.arg(a, 1)
	v_b_65 = J.arg(a, 2)
	return J.max_([(0.0 if J.leq(v_a_64, null) else v_a_64), J.min_([(1.0 if J.leq(v_b_65, null) else v_b_65), v_v_63])])

func _f3(this_, a: Array, env):
	var v_t_66 = null
	v_t_66 = J.arg(a, 0)
	return v_t_66

func _f4(this_, a: Array, env):
	var v_t_67 = null
	v_t_67 = J.arg(a, 0)
	return J.mul(v_t_67, v_t_67)

func _f5(this_, a: Array, env):
	var v_t_68 = null
	v_t_68 = J.arg(a, 0)
	return (1.0 - (J.sub(1.0, v_t_68) * J.sub(1.0, v_t_68)))

func _f6(this_, a: Array, env):
	var v_t_69 = null
	v_t_69 = J.arg(a, 0)
	return (J.mul(J.mul(2.0, v_t_69), v_t_69) if J.cmp(v_t_69, 0.5, "<") else (1.0 - ((2.0 * J.sub(1.0, v_t_69)) * J.sub(1.0, v_t_69))))

func _f7(this_, a: Array, env):
	var v_t_70 = null
	v_t_70 = J.arg(a, 0)
	return (1.0 - pow(J.num(J.sub(1.0, v_t_70)), J.num(3.0)))

func _f8(this_, a: Array, env):
	var v_t_71 = null
	v_t_71 = J.arg(a, 0)
	return J.mul(J.mul(v_t_71, v_t_71), v_t_71)

func _f9(this_, a: Array, env):
	var v_t_72 = null; var v_c1_73 = null; var v_c3_74 = null
	v_t_72 = J.arg(a, 0)
	v_c1_73 = 1.70158
	v_c3_74 = J.add(v_c1_73, 1.0)
	return ((1.0 + J.mul(v_c3_74, pow(J.num(J.sub(v_t_72, 1.0)), J.num(3.0)))) + J.mul(v_c1_73, pow(J.num(J.sub(v_t_72, 1.0)), J.num(2.0))))

func _f10(this_, a: Array, env):
	return 0.0

func _f11(this_, a: Array, env):
	var v_k_75 = null
	v_k_75 = J.arg(a, 0)
	var _t302 = J.seq(J.typeof_(J.G.get("sprOk")), "function")
	if J.t(_t302):
		var _t301 = J.G.get("sprOk")
		_t302 = J.cl(_t301, null, [v_k_75])
	return _t302

func _f12(this_, a: Array, env):
	return J.gp(J.gp(J.G.get("LIMBS_DATA"), "chars"), "afu")

func _f13(this_, a: Array, env):
	return J.gp(J.gp(J.G.get("LIMBS_DATA"), "weapons"), "axe")

func _f14(this_, a: Array, env):
	var _t303 = env["ok"]
	return (J.gp(J.G.get("SPR"), "afu__axe") if J.t(J.cl(_t303, null, ["afu__axe"])) else J.gp(J.G.get("SPR"), "afu__wpn"))

func _f15(this_, a: Array, env):
	var v_o_76 = null; var v_k_77 = null
	v_o_76 = {}
	for _t304 in J.iter(env["F"]):
		v_k_77 = _t304
		J.sp(v_o_76, v_k_77, 0.0)
	return v_o_76

func _f19(this_, a: Array, env):
	var v_at_102 = null; var v_t0_103 = null; var v_t1_104 = null
	v_at_102 = J.arg(a, 0)
	v_t0_103 = J.arg(a, 1)
	v_t1_104 = J.arg(a, 2)
	var _t305 = env["cl"]
	return J.cl(_t305, null, [J.div(J.sub(v_at_102, v_t0_103), J.sub(v_t1_104, v_t0_103))])

func _f20(this_, a: Array, env):
	var v_at_105 = null; var v_t0_106 = null; var v_t1_107 = null; var v_k_108 = null
	v_at_105 = J.arg(a, 0)
	v_t0_106 = J.arg(a, 1)
	v_t1_107 = J.arg(a, 2)
	var _t306 = env["seg"]
	v_k_108 = J.cl(_t306, null, [v_at_105, v_t0_106, v_t1_107])
	var _t307 = J.cmp(v_k_108, 0.0, "<=")
	var _t309 = null
	if (_t307 if _t307 else J.cmp(v_k_108, 1.0, ">=")):
		_t309 = 0.0
	else:
		var _t308 = env["S"]
		_t309 = J.cl(_t308, null, [J.mul(v_k_108, env["PI"])])
	return _t309

func _f22(this_, a: Array, env):
	return J.construct(J.G.get("DOMMatrix"), [])

func _f27(this_, a: Array, env):
	var v_Mx_179 = null; var v_x_180 = null; var v_y_181 = null; var v_p_182 = null
	v_Mx_179 = J.arg(a, 0)
	v_x_180 = J.arg(a, 1)
	v_y_181 = J.arg(a, 2)
	v_p_182 = J.mc(v_Mx_179, "transformPoint", [J.construct(J.G.get("DOMPoint"), [v_x_180, v_y_181])])
	return {"x": J.gp(v_p_182, "x"), "y": J.gp(v_p_182, "y")}

func _f45(this_, a: Array, env):
	var v_R_319 = null; var v_k_320 = null
	v_R_319 = J.arg(a, 0)
	v_k_320 = J.arg(a, 1)
	var _t310 = env["meshPt"]
	return J.cl(_t310, null, [v_R_319, J.gp(v_R_319, "mp"), J.gp(J.gp(env["FACE"], v_k_320), 0.0), J.gp(J.gp(env["FACE"], v_k_320), 1.0)])

func _f47(this_, a: Array, env):
	var v_n_325 = null; var v_x_326 = null
	v_n_325 = J.arg(a, 0)
	var _t311 = env["S"]
	v_x_326 = J.mul(J.cl(_t311, null, [(J.mul(v_n_325, 127.1) + 311.7)]), 43758.5453)
	return J.sub(v_x_326, floor(J.num(v_x_326)))

func _f49(this_, a: Array, env):
	var v_a_331 = null; var v_at_332 = null; var v_t_333 = null; var v_w_334 = null; var v_r_335 = null; var v_P_336 = null; var v_gi_337 = null; var v_gk_338 = null; var v_g_339 = null; var v_look_340 = null; var v_ease_341 = null; var v_hp_342 = null; var v_stone_343 = null; var v_base_344 = null; var v_i_345 = null; var v_c_346 = null; var v_q_347 = null; var v_q_348 = null; var v_up_349 = null; var v_sq_350 = null; var v_u_351 = null
	v_a_331 = J.arg(a, 0)
	v_at_332 = J.arg(a, 1)
	v_t_333 = J.arg(a, 2)
	var _t313 = J.gp(J.G.get("MeshAnim"), "ANIM")
	v_w_334 = J.mc(_t313, "walk", [v_t_333])
	var _t314 = env["rest"]
	v_r_335 = J.cl(_t314, null, [v_t_333])
	v_P_336 = J.cl(env["Z"], null, [])
	var _t315 = J.sub(J.gp(v_w_334, "head"), J.gp(v_r_335, "head"))
	J.sp(v_P_336, "head", _t315)
	var _t316 = J.sub(J.gp(v_w_334, "armB"), J.gp(v_r_335, "armB"))
	J.sp(v_P_336, "armB", _t316)
	var _t318 = J.sub(J.gp(v_w_334, "tie"), J.gp(v_r_335, "tie"))
	var _t317 = env["S"]
	var _t319 = (_t318 + J.mul(J.cl(_t317, null, [J.mul(v_t_333, 13.0)]), 0.08))
	J.sp(v_P_336, "tie", _t319)
	var _t320 = J.sub(J.gp(v_w_334, "tail1"), J.gp(v_r_335, "tail1"))
	J.sp(v_P_336, "tail1", _t320)
	var _t321 = J.sub(J.gp(v_w_334, "tail2"), J.gp(v_r_335, "tail2"))
	J.sp(v_P_336, "tail2", _t321)
	var _t322 = env["S"]
	var _t323 = J.mul(J.cl(_t322, null, [J.mul(v_t_333, 7.0)]), 5.0)
	J.sp(v_P_336, "th", _t323)
	var _t324 = env["S"]
	var _t325 = J.mul(J.cl(_t324, null, [(J.mul(v_t_333, 7.0) - 0.6)]), 4.0)
	J.sp(v_P_336, "wr", _t325)
	var _t326 = (-3.0)
	J.sp(v_P_336, "lean", _t326)
	var _t327 = env["S"]
	var _t328 = ((-absf(J.num(J.cl(_t327, null, [J.mul(v_t_333, 7.0)])))) * 0.02)
	J.sp(v_P_336, "dy", _t328)
	v_gi_337 = floor(J.num(J.div(J.add(v_at_332, 0.8), 2.6)))
	v_gk_338 = J.div(J.mod(J.add(v_at_332, 0.8), 2.6), 2.6)
	var _t329 = env["hash"]
	v_g_339 = J.cl(_t329, null, [J.add(v_gi_337, 3.0)])
	var _t330 = env["bell"]
	v_look_340 = J.cl(_t330, null, [v_gk_338, 0.15, 0.85])
	var _t331 = env["cl"]
	v_ease_341 = J.mc(env["E"], "io", [J.cl(_t331, null, [J.mul(v_look_340, 1.6)])])
	if J.cmp(v_g_339, 0.4, "<"):
		var _t332 = J.add(J.gp(v_P_336, "head"), J.mul((-0.16), v_ease_341))
		J.sp(v_P_336, "head", _t332)
		var _t333 = J.add(J.gp(v_P_336, "dx"), J.mul(0.02, v_ease_341))
		J.sp(v_P_336, "dx", _t333)
	else:
		if J.cmp(v_g_339, 0.75, "<"):
			var _t334 = J.add(J.gp(v_P_336, "head"), J.mul(0.15, v_ease_341))
			J.sp(v_P_336, "head", _t334)
			var _t335 = J.add(J.gp(v_P_336, "lean"), J.mul(3.0, v_ease_341))
			J.sp(v_P_336, "lean", _t335)
		else:
			var _t336 = env["S"]
			var _t337 = J.add(J.gp(v_P_336, "head"), J.mul(J.mul(J.cl(_t336, null, [(J.mul(v_gk_338, env["PI"]) * 4.0)]), 0.08), v_look_340))
			J.sp(v_P_336, "head", _t337)
	v_hp_342 = (-9.0)
	v_stone_343 = null
	v_base_344 = floor(J.num(J.div(J.sub(v_at_332, 2.4), 4.5)))
	v_i_345 = J.max_([0.0, J.sub(v_base_344, 1.0)])
	while true:
		if not J.cmp(v_i_345, J.add(v_base_344, 1.0), "<="): break
		var _t339 = (2.4 + J.mul(v_i_345, 4.5))
		var _t338 = env["hash"]
		v_c_346 = (_t339 + J.mul(J.cl(_t338, null, [J.add(v_i_345, 17.0)]), 1.5))
		v_q_347 = J.div(J.sub(v_at_332, v_c_346), 0.55)
		var _t340 = J.cmp(v_q_347, (-1.2), ">")
		if (J.cmp(v_q_347, 1.6, "<") if _t340 else _t340):
			v_hp_342 = v_q_347
		v_i_345 = J.num(v_i_345) + 1.0
	var _t341 = J.cmp(v_hp_342, (-1.2), ">")
	if (J.cmp(v_hp_342, 1.6, "<") if _t341 else _t341):
		var _t342 = {"k": v_hp_342}
		v_stone_343 = _t342
	var _t343 = J.cmp(v_hp_342, 0.0, ">=")
	if (J.cmp(v_hp_342, 1.0, "<") if _t343 else _t343):
		v_q_348 = v_hp_342
		v_up_349 = 0.0
		v_sq_350 = 0.0
		if J.cmp(v_q_348, 0.18, "<"):
			var _t344 = J.mc(env["E"], "o", [J.div(v_q_348, 0.18)])
			v_sq_350 = _t344
		else:
			if J.cmp(v_q_348, 0.75, "<"):
				v_u_351 = J.div(J.sub(v_q_348, 0.18), 0.57)
				var _t345 = env["S"]
				var _t346 = J.cl(_t345, null, [J.mul(v_u_351, env["PI"])])
				v_up_349 = _t346
				var _t348 = (-0.6)
				var _t347 = env["S"]
				var _t349 = (J.mul(_t348, J.cl(_t347, null, [J.mul(v_u_351, env["PI"])])) + ((1.0 - J.div(v_u_351, 0.15)) if J.cmp(v_u_351, 0.15, "<") else 0.0))
				v_sq_350 = _t349
			else:
				var _t350 = env["S"]
				var _t351 = J.mul(J.cl(_t350, null, [J.mul(J.div(J.sub(v_q_348, 0.75), 0.25), env["PI"])]), 0.8)
				v_sq_350 = _t351
		var _t352 = J.add(J.gp(v_P_336, "dy"), J.mul((-0.2), v_up_349))
		J.sp(v_P_336, "dy", _t352)
		var _t353 = J.add(J.gp(v_P_336, "sy"), J.mul((-0.07), v_sq_350))
		J.sp(v_P_336, "sy", _t353)
		var _t354 = J.add(J.gp(v_P_336, "sx"), J.mul(0.06, v_sq_350))
		J.sp(v_P_336, "sx", _t354)
		var _t355 = J.add(J.gp(v_P_336, "lean"), J.mul((-6.0), v_up_349))
		J.sp(v_P_336, "lean", _t355)
		var _t356 = J.add(J.gp(v_P_336, "tie"), J.mul(0.35, v_up_349))
		J.sp(v_P_336, "tie", _t356)
		var _t357 = J.add(J.gp(v_P_336, "tail1"), J.mul(0.25, v_up_349))
		J.sp(v_P_336, "tail1", _t357)
		var _t358 = J.add(J.gp(v_P_336, "tail2"), J.mul(0.45, v_up_349))
		J.sp(v_P_336, "tail2", _t358)
		var _t359 = J.add(J.gp(v_P_336, "th"), J.mul(14.0, v_up_349))
		J.sp(v_P_336, "th", _t359)
		var _t360 = J.add(J.gp(v_P_336, "head"), J.mul((-0.06), v_sq_350))
		J.sp(v_P_336, "head", _t360)
	return {"P": v_P_336, "st": {"axe": "hand"}, "stone": v_stone_343}

func _f51(this_, a: Array, env):
	var v_ctx_358 = null; var v_R_359 = null; var v_m_360 = null; var v_s_361 = null; var v_ht_362 = null; var v_tk_363 = null; var v_e_364 = null
	v_ctx_358 = J.arg(a, 0)
	v_R_359 = J.arg(a, 1)
	var _t377 = env["__p"]["fp"]
	v_m_360 = J.cl(_t377, null, [v_R_359, "mouth"])
	v_s_361 = J.gp(v_R_359, "H")
	var _t378 = env["__p"]["mouthO"]
	var _t380 = (J.mul(v_s_361, 0.026) * (0.6 + J.mul(0.4, env["open"])))
	var _t381 = J.mul(J.mul(v_s_361, 0.034), env["open"])
	var _t382 = (((-J.num(J.add(J.gp(env["P"], "head"), J.gp(J.gp(v_R_359, "mp"), "head")))) * 0.5) * ((-1.0) if J.t(J.gp(env["a"], "faceRight")) else 1.0))
	var _t379 = env["__p"]["cl"]
	J.cl(_t378, null, [v_ctx_358, v_m_360, _t380, _t381, _t382, J.cl(_t379, null, [J.mul(env["open"], 4.0)])])
	var _t383 = env["__p"]["seg"]
	v_ht_362 = J.cl(_t383, null, [env["at"], 1.0, 2.6])
	var _t384 = env["__p"]["crayonText"]
	var _t388 = J.add(J.gp(v_m_360, "x"), (J.mul((1.0 if J.t(J.gp(env["a"], "faceRight")) else (-1.0)), v_s_361) * (0.32 + J.mul(v_ht_362, 0.12))))
	var _t389 = J.sub(J.gp(v_m_360, "y"), J.mul(v_s_361, (0.18 + J.mul(v_ht_362, 0.15))))
	var _t390 = J.mul(v_s_361, 0.2)
	var _t385 = env["__p"]["bell"]
	var _t387 = null
	if (J.mul(J.cl(_t385, null, [env["at"], 1.0, 2.6]), 1.6) > 1.0):
		_t387 = 1.0
	else:
		var _t386 = env["__p"]["bell"]
		_t387 = J.mul(J.cl(_t386, null, [env["at"], 1.0, 2.6]), 1.6)
	J.cl(_t384, null, [v_ctx_358, "哈～", _t388, _t389, _t390, "#fff4d0", _t387])
	var _t391 = env["__p"]["seg"]
	v_tk_363 = J.cl(_t391, null, [env["at"], 2.55, 3.55])
	var _t392 = env["__p"]["meshPt"]
	v_e_364 = J.cl(_t392, null, [v_R_359, J.gp(v_R_359, "mp"), 0.345, 0.315])
	var _t393 = J.cmp(v_tk_363, 0.0, ">")
	if (J.cmp(v_tk_363, 1.0, "<") if _t393 else _t393):
		var _t394 = env["__p"]["drop"]
		var _t396 = J.gp(v_e_364, "x")
		var _t397 = J.add(J.gp(v_e_364, "y"), (J.mul(v_tk_363, v_s_361) * 0.04))
		var _t398 = (J.mul(v_s_361, 0.014) * (J.div(v_tk_363, 0.2) if J.cmp(v_tk_363, 0.2, "<") else 1.0))
		var _t395 = env["__p"]["seg"]
		J.cl(_t394, null, [v_ctx_358, _t396, _t397, _t398, 0.0, J.sub(1.0, J.mc(env["__p"]["E"], "i", [J.cl(_t395, null, [env["at"], 3.2, 3.55])]))])

func _f50(this_, a: Array, env):
	var v_L_354 = null; var v_shake_356 = null
	var _s79 = {"__p": env, "a": null, "at": null, "P": null, "open": null}
	_s79["a"] = J.arg(a, 0)
	_s79["at"] = J.arg(a, 1)
	v_L_354 = 3.6
	var _t363 = _s79["__p"]["track"]
	_s79["P"] = J.cl(_t363, null, [_s79["at"], [[0.0, {}], [0.45, {"sy": (-0.03), "sx": 0.02, "head": (-0.08), "dy": 0.01}, "io"], [1.25, {"sy": 0.07, "sx": (-0.03), "dy": (-0.03), "lean": 7.0, "head": 0.22, "th": 94.0, "hx": 0.04, "hy": 0.05, "armB": (-0.32), "tail1": (-0.15), "tail2": (-0.25), "tie": 0.15}, "o3"], [2.15, {"sy": 0.08, "sx": (-0.035), "dy": (-0.035), "lean": 8.0, "head": 0.25, "th": 98.0, "hx": 0.04, "hy": 0.05, "armB": (-0.36), "tail1": (-0.18), "tail2": (-0.3), "tie": 0.2}, "l"], [2.75, {"sy": (-0.04), "sx": 0.03, "dy": 0.01, "lean": (-4.0), "head": (-0.1), "th": (-6.0), "armB": 0.08, "tail1": 0.08, "tail2": 0.12}, "io"], [3.2, {"sy": 0.005, "head": 0.02}, "io"], [v_L_354, {}, "io"]]])
	var _t364 = _s79["__p"]["bell"]
	v_shake_356 = J.cl(_t364, null, [_s79["at"], 1.35, 2.15])
	var _t365 = _s79["P"]
	var _t366 = _s79["__p"]["S"]
	var _t367 = J.add(J.gp(_t365, "head"), J.mul(J.mul(J.cl(_t366, null, [J.mul(_s79["at"], 38.0)]), 0.015), v_shake_356))
	J.sp(_t365, "head", _t367)
	var _t368 = _s79["P"]
	var _t369 = _s79["__p"]["S"]
	var _t370 = J.add(J.gp(_t368, "th"), J.mul(J.mul(J.cl(_t369, null, [J.mul(_s79["at"], 31.0)]), 1.6), v_shake_356))
	J.sp(_t368, "th", _t370)
	var _t371 = _s79["__p"]["bell"]
	var _t376 = null
	if J.cmp(J.cl(_t371, null, [_s79["at"], 0.6, 2.75]), 0.0, ">"):
		var _t372 = _s79["__p"]["cl"]
		var _t373 = _s79["__p"]["seg"]
		var _t375 = J.cl(_t372, null, [J.cl(_t373, null, [_s79["at"], 0.6, 1.2])])
		var _t374 = _s79["__p"]["seg"]
		_t376 = J.mul(_t375, J.sub(1.0, J.cl(_t374, null, [_s79["at"], 2.2, 2.75])))
	else:
		_t376 = 0.0
	_s79["open"] = J.mc(_s79["__p"]["E"], "io", [_t376])
	return {"P": _s79["P"], "st": {"axe": "hand"}, "L": v_L_354, "fx": Callable(self, "_f51").bind(_s79)}

func _f53(this_, a: Array, env):
	var v_ctx_370 = null; var v_R_371 = null; var v_s_372 = null; var v_top_373 = null; var v_k_374 = null; var v_m_375 = null; var v_pk_376 = null
	v_ctx_370 = J.arg(a, 0)
	v_R_371 = J.arg(a, 1)
	v_s_372 = J.gp(v_R_371, "H")
	var _t405 = env["__p"]["fp"]
	v_top_373 = J.cl(_t405, null, [v_R_371, "top"])
	var _t406 = env["__p"]["seg"]
	v_k_374 = J.cl(_t406, null, [env["at"], 2.0, 2.55])
	var _t407 = env["__p"]["crayonText"]
	var _t411 = J.add(J.gp(v_top_373, "x"), (J.mul(((-1.0) if J.t(J.gp(env["a"], "faceRight")) else 1.0), v_s_372) * 0.28))
	var _t412 = J.sub(J.add(J.gp(v_top_373, "y"), J.mul(v_s_372, 0.25)), (J.mul(v_k_374, v_s_372) * 0.12))
	var _t413 = J.mul(v_s_372, 0.17)
	var _t408 = env["__p"]["bell"]
	var _t410 = null
	if (J.mul(J.cl(_t408, null, [env["at"], 2.0, 2.6]), 1.8) > 1.0):
		_t410 = 1.0
	else:
		var _t409 = env["__p"]["bell"]
		_t410 = J.mul(J.cl(_t409, null, [env["at"], 2.0, 2.6]), 1.8)
	J.cl(_t407, null, [v_ctx_370, "喀", _t411, _t412, _t413, "#ffe6a8", _t410, 0.2])
	var _t414 = env["__p"]["lines"]
	var _t416 = J.add(J.gp(v_top_373, "x"), (J.mul(((-1.0) if J.t(J.gp(env["a"], "faceRight")) else 1.0), v_s_372) * 0.18))
	var _t417 = J.add(J.gp(v_top_373, "y"), J.mul(v_s_372, 0.35))
	var _t418 = J.mul(v_s_372, 0.12)
	var _t419 = (-2.4)
	var _t420 = (-1.2)
	var _t415 = env["__p"]["bell"]
	J.cl(_t414, null, [v_ctx_370, _t416, _t417, _t418, 3.0, _t419, _t420, J.cl(_t415, null, [env["at"], 2.0, 2.3]), "#fff3c4"])
	var _t421 = env["__p"]["fp"]
	v_m_375 = J.cl(_t421, null, [v_R_371, "mouth"])
	var _t422 = env["__p"]["seg"]
	v_pk_376 = J.cl(_t422, null, [env["at"], 2.6, 3.4])
	var _t423 = env["__p"]["puff"]
	var _t425 = J.add(J.gp(v_m_375, "x"), (J.mul((1.0 if J.t(J.gp(env["a"], "faceRight")) else (-1.0)), v_s_372) * (0.12 + J.mul(v_pk_376, 0.15))))
	var _t426 = J.sub(J.add(J.gp(v_m_375, "y"), J.mul(v_s_372, 0.02)), (J.mul(v_pk_376, v_s_372) * 0.05))
	var _t427 = J.mul(v_s_372, (0.05 + J.mul(v_pk_376, 0.05)))
	var _t424 = env["__p"]["bell"]
	J.cl(_t423, null, [v_ctx_370, _t425, _t426, _t427, J.mul(J.cl(_t424, null, [env["at"], 2.6, 3.4]), 0.9), "rgba(235,240,245,.9)"])

func _f52(this_, a: Array, env):
	var v_L_367 = null; var v_P_368 = null; var v_shake_369 = null
	var _s81 = {"__p": env, "a": null, "at": null}
	_s81["a"] = J.arg(a, 0)
	_s81["at"] = J.arg(a, 1)
	v_L_367 = 3.6
	var _t401 = _s81["__p"]["track"]
	v_P_368 = J.cl(_t401, null, [_s81["at"], [[0.0, {}], [0.4, {"sy": (-0.05), "sx": 0.03, "dy": 0.015, "head": (-0.06), "th": (-8.0)}, "io"], [1.0, {"sy": 0.1, "sx": (-0.05), "dy": (-0.05), "lean": 12.0, "head": 0.18, "th": 96.0, "hx": 0.04, "hy": 0.06, "armB": (-0.5), "wr": 8.0, "tail1": (-0.22), "tail2": (-0.38), "tie": 0.25}, "o3"], [1.45, {"sy": 0.11, "sx": (-0.055), "dy": (-0.055), "lean": (-6.0), "head": 0.08, "th": 100.0, "hx": 0.04, "hy": 0.07, "armB": (-0.42), "wr": 10.0, "tail1": 0.2, "tail2": 0.35, "tie": (-0.15)}, "io"], [1.9, {"sy": 0.11, "sx": (-0.055), "dy": (-0.055), "lean": 14.0, "head": 0.2, "th": 98.0, "hx": 0.04, "hy": 0.07, "armB": (-0.55), "wr": 6.0, "tail1": (-0.25), "tail2": (-0.4), "tie": 0.3}, "io"], [2.2, {"sy": 0.11, "sx": (-0.05), "dy": (-0.05), "lean": 12.0, "head": 0.22, "th": 100.0, "hx": 0.04, "hy": 0.07, "armB": (-0.55), "wr": 8.0, "tail1": (-0.2), "tail2": (-0.35), "tie": 0.25}, "l"], [2.75, {"sy": (-0.06), "sx": 0.04, "dy": 0.02, "lean": (-5.0), "head": (-0.12), "th": (-10.0), "armB": 0.1, "tail1": 0.1, "tail2": 0.15, "tie": (-0.1)}, "io"], [3.2, {"sy": 0.01, "head": 0.02}, "io"], [v_L_367, {}, "io"]]])
	var _t402 = _s81["__p"]["bell"]
	v_shake_369 = J.cl(_t402, null, [_s81["at"], 1.9, 2.25])
	var _t403 = _s81["__p"]["S"]
	var _t404 = J.add(J.gp(v_P_368, "lean"), J.mul(J.mul(J.cl(_t403, null, [J.mul(_s81["at"], 40.0)]), 1.2), v_shake_369))
	J.sp(v_P_368, "lean", _t404)
	return {"P": v_P_368, "st": {"axe": "hand"}, "L": v_L_367, "fx": Callable(self, "_f53").bind(_s81)}

func _f55(this_, a: Array, env):
	var v_ctx_382 = null; var v_R_383 = null; var v_s_384 = null; var v_top_385 = null; var v_al_386 = null
	v_ctx_382 = J.arg(a, 0)
	v_R_383 = J.arg(a, 1)
	v_s_384 = J.gp(v_R_383, "H")
	var _t445 = env["__p"]["fp"]
	v_top_385 = J.cl(_t445, null, [v_R_383, "top"])
	var _t446 = env["__p"]["cl"]
	var _t447 = env["__p"]["bell"]
	v_al_386 = J.cl(_t446, null, [J.mul(J.cl(_t447, null, [env["at"], 0.8, 2.6]), 2.0)])
	var _t448 = env["__p"]["crayonText"]
	var _t453 = J.add(J.gp(v_top_385, "x"), (J.mul((1.0 if J.t(J.gp(env["a"], "faceRight")) else (-1.0)), v_s_384) * 0.22))
	var _t450 = J.sub(J.gp(v_top_385, "y"), J.mul(v_s_384, 0.08))
	var _t449 = env["__p"]["seg"]
	var _t452 = (_t450 - (J.mul(J.cl(_t449, null, [env["at"], 0.8, 1.2]), v_s_384) * 0.06))
	var _t451 = env["__p"]["S"]
	J.cl(_t448, null, [v_ctx_382, "？", _t453, (_t452 + (J.mul(J.cl(_t451, null, [J.mul(env["at"], 6.0)]), v_s_384) * 0.01)), J.mul(v_s_384, 0.24), "#ffe9a8", v_al_386, ((1.0 if J.t(J.gp(env["a"], "faceRight")) else (-1.0)) * (-0.15))])
	if J.cmp(env["sc"], 0.2, ">"):
		var _t454 = env["__p"]["lines"]
		var _t457 = J.add(J.gp(v_top_385, "x"), (J.mul(((-1.0) if J.t(J.gp(env["a"], "faceRight")) else 1.0), v_s_384) * 0.3))
		var _t458 = J.add(J.gp(v_top_385, "y"), J.mul(v_s_384, 0.18))
		var _t459 = J.mul(v_s_384, 0.1)
		var _t456 = (-2.6)
		var _t455 = env["__p"]["S"]
		J.cl(_t454, null, [v_ctx_382, _t457, _t458, _t459, 2.0, (_t456 + J.mul(J.cl(_t455, null, [J.mul(env["at"], 26.0)]), 0.3)), (-1.9), J.mul(env["sc"], 0.8), "#e8dfcf"])

func _f54(this_, a: Array, env):
	var v_L_379 = null; var v_P_380 = null
	var _s83 = {"__p": env, "a": null, "at": null, "sc": null}
	_s83["a"] = J.arg(a, 0)
	_s83["at"] = J.arg(a, 1)
	v_L_379 = 3.0
	var _t430 = _s83["__p"]["track"]
	v_P_380 = J.cl(_t430, null, [_s83["at"], [[0.0, {}], [0.35, {"th": (-6.0), "head": (-0.03), "sy": (-0.015)}, "io"], [0.8, {"th": 80.0, "hx": 0.26, "hy": (-0.08), "head": (-0.1), "lean": (-3.0), "wr": 20.0, "armB": (-0.05)}, "o3"], [2.2, {"th": 80.0, "hx": 0.26, "hy": (-0.08), "head": (-0.12), "lean": (-3.0), "wr": 20.0, "armB": (-0.05)}, "l"], [2.65, {"th": (-4.0), "head": (-0.02)}, "io"], [v_L_379, {}, "io"]]])
	var _t431 = _s83["__p"]["bell"]
	var _t436 = null
	if J.cmp(J.cl(_t431, null, [_s83["at"], 0.75, 2.25]), 0.0, ">"):
		var _t432 = _s83["__p"]["cl"]
		var _t433 = _s83["__p"]["seg"]
		var _t435 = J.cl(_t432, null, [J.cl(_t433, null, [_s83["at"], 0.75, 0.95])])
		var _t434 = _s83["__p"]["seg"]
		_t436 = J.mul(_t435, J.sub(1.0, J.cl(_t434, null, [_s83["at"], 2.05, 2.25])))
	else:
		_t436 = 0.0
	_s83["sc"] = _t436
	var _t437 = _s83["__p"]["S"]
	var _t438 = J.add(J.gp(v_P_380, "th"), J.mul(J.mul(J.cl(_t437, null, [J.mul(_s83["at"], 24.0)]), 6.0), _s83["sc"]))
	J.sp(v_P_380, "th", _t438)
	var _t439 = _s83["__p"]["S"]
	var _t440 = J.add(J.gp(v_P_380, "hy"), J.mul(J.mul(J.cl(_t439, null, [(J.mul(_s83["at"], 24.0) + 1.2)]), 0.02), _s83["sc"]))
	J.sp(v_P_380, "hy", _t440)
	var _t441 = _s83["__p"]["S"]
	var _t442 = J.add(J.gp(v_P_380, "wr"), J.mul(J.mul(J.cl(_t441, null, [J.mul(_s83["at"], 24.0)]), 5.0), _s83["sc"]))
	J.sp(v_P_380, "wr", _t442)
	var _t443 = _s83["__p"]["S"]
	var _t444 = J.add(J.gp(v_P_380, "head"), J.mul(J.mul(J.cl(_t443, null, [J.mul(_s83["at"], 12.0)]), 0.025), _s83["sc"]))
	J.sp(v_P_380, "head", _t444)
	return {"P": v_P_380, "st": {"axe": "hand"}, "L": v_L_379, "fx": Callable(self, "_f55").bind(_s83)}

func _f57(this_, a: Array, env):
	var v_ctx_395 = null; var v_R_396 = null; var v_s_397 = null; var v_g_398 = null; var v_m_399 = null; var v_k_400 = null; var v_top_401 = null
	v_ctx_395 = J.arg(a, 0)
	v_R_396 = J.arg(a, 1)
	v_s_397 = J.gp(v_R_396, "H")
	var _t479 = J.gp(v_R_396, "G")
	v_g_398 = J.mc(_t479, "transformPoint", [J.construct(J.G.get("DOMPoint"), [J.mul(J.gp(v_R_396, "H"), 0.02), 0.0])])
	var _t480 = J.cmp(env["on"], 0.5, ">")
	if (J.cmp(env["beat"], 0.3, "<") if _t480 else _t480):
		var _t481 = env["__p"]["puff"]
		J.cl(_t481, null, [v_ctx_395, J.add(J.gp(v_g_398, "x"), (J.mul(((-1.0) if J.t(J.gp(env["a"], "faceRight")) else 1.0), v_s_397) * 0.05)), J.sub(J.gp(v_g_398, "y"), J.mul(v_s_397, 0.02)), J.mul(v_s_397, (0.04 + J.mul(env["beat"], 0.12))), (J.div(J.sub(0.3, env["beat"]), 0.3) * 0.7)])
	var _t482 = env["__p"]["fp"]
	v_m_399 = J.cl(_t482, null, [v_R_396, "mouth"])
	var _t483 = env["__p"]["seg"]
	v_k_400 = J.cl(_t483, null, [env["at"], 1.2, 2.2])
	var _t484 = env["__p"]["crayonText"]
	var _t487 = J.sub(J.gp(v_m_399, "x"), (J.mul((1.0 if J.t(J.gp(env["a"], "faceRight")) else (-1.0)), v_s_397) * (0.32 + J.mul(v_k_400, 0.05))))
	var _t488 = (J.sub(J.gp(v_m_399, "y"), J.mul(v_s_397, 0.12)) - (J.mul(v_k_400, v_s_397) * 0.08))
	var _t489 = J.mul(v_s_397, 0.17)
	var _t485 = env["__p"]["cl"]
	var _t486 = env["__p"]["bell"]
	J.cl(_t484, null, [v_ctx_395, "嘖", _t487, _t488, _t489, "#ffd2b0", J.cl(_t485, null, [J.mul(J.cl(_t486, null, [env["at"], 1.2, 2.3]), 2.0)])])
	var _t490 = env["__p"]["fp"]
	v_top_401 = J.cl(_t490, null, [v_R_396, "top"])
	var _t491 = env["__p"]["crayonText"]
	var _t497 = J.add(J.gp(v_top_401, "x"), (J.mul((1.0 if J.t(J.gp(env["a"], "faceRight")) else (-1.0)), v_s_397) * 0.2))
	var _t498 = J.sub(J.gp(v_top_401, "y"), J.mul(v_s_397, 0.02))
	var _t499 = J.mul(v_s_397, 0.2)
	var _t492 = env["__p"]["cl"]
	var _t493 = env["__p"]["bell"]
	var _t496 = J.cl(_t492, null, [J.mul(J.cl(_t493, null, [env["at"], 0.4, 1.3]), 2.0)])
	var _t494 = env["__p"]["cl"]
	var _t495 = env["__p"]["bell"]
	J.cl(_t491, null, [v_ctx_395, "…", _t497, _t498, _t499, "#fff", J.add(_t496, J.cl(_t494, null, [J.mul(J.cl(_t495, null, [env["at"], 2.3, 3.2]), 2.0)]))])

func _f56(this_, a: Array, env):
	var v_L_389 = null; var v_P_390 = null; var v_kick_393 = null
	var _s85 = {"__p": env, "a": null, "at": null, "on": null, "beat": null, "beatN": null}
	_s85["a"] = J.arg(a, 0)
	_s85["at"] = J.arg(a, 1)
	v_L_389 = 3.4
	var _t462 = _s85["__p"]["track"]
	v_P_390 = J.cl(_t462, null, [_s85["at"], [[0.0, {}], [0.35, {"lean": 4.0, "head": 0.1, "th": 6.0, "sy": 0.01}, "io"], [3.0, {"lean": 4.0, "head": 0.1, "th": 6.0, "sy": 0.01}, "l"], [v_L_389, {}, "io"]]])
	var _t463 = _s85["__p"]["bell"]
	var _t468 = null
	if J.cmp(J.cl(_t463, null, [_s85["at"], 0.3, 3.1]), 0.0, ">"):
		var _t464 = _s85["__p"]["cl"]
		var _t465 = _s85["__p"]["seg"]
		var _t467 = J.cl(_t464, null, [J.cl(_t465, null, [_s85["at"], 0.3, 0.6])])
		var _t466 = _s85["__p"]["seg"]
		_t468 = J.mul(_t467, J.sub(1.0, J.cl(_t466, null, [_s85["at"], 2.8, 3.1])))
	else:
		_t468 = 0.0
	_s85["on"] = _t468
	_s85["beat"] = J.mod(J.mul(_s85["at"], 3.2), 1.0)
	v_kick_393 = (J.mc(_s85["__p"]["E"], "o", [J.div(_s85["beat"], 0.35)]) if J.cmp(_s85["beat"], 0.35, "<") else J.sub(1.0, J.mc(_s85["__p"]["E"], "io", [J.div(J.sub(_s85["beat"], 0.35), 0.65)])))
	var _t469 = J.add(J.gp(v_P_390, "tail1"), J.mul(((-0.35) + J.mul(0.45, v_kick_393)), _s85["on"]))
	J.sp(v_P_390, "tail1", _t469)
	var _t470 = J.add(J.gp(v_P_390, "tail2"), J.mul(((-0.9) + J.mul(1.2, v_kick_393)), _s85["on"]))
	J.sp(v_P_390, "tail2", _t470)
	var _t471 = J.add(J.gp(v_P_390, "dy"), J.mul(((-0.006) * J.sub(1.0, v_kick_393)), _s85["on"]))
	J.sp(v_P_390, "dy", _t471)
	var _t472 = J.add(J.gp(v_P_390, "sy"), J.mul((0.012 * J.sub(1.0, v_kick_393)), _s85["on"]))
	J.sp(v_P_390, "sy", _t472)
	var _t473 = _s85["__p"]["S"]
	var _t474 = J.add(J.gp(v_P_390, "wr"), J.mul(J.mul(J.cl(_t473, null, [J.mul(_s85["at"], 6.4)]), 9.0), _s85["on"]))
	J.sp(v_P_390, "wr", _t474)
	var _t475 = _s85["__p"]["S"]
	var _t476 = J.add(J.gp(v_P_390, "th"), J.mul(J.mul(J.cl(_t475, null, [(J.mul(_s85["at"], 6.4) + 0.8)]), 4.0), _s85["on"]))
	J.sp(v_P_390, "th", _t476)
	var _t477 = _s85["__p"]["S"]
	var _t478 = J.add(J.gp(v_P_390, "head"), J.mul(J.mul(J.cl(_t477, null, [J.mul(J.mul(_s85["at"], 3.2), _s85["__p"]["PI"])]), 0.02), _s85["on"]))
	J.sp(v_P_390, "head", _t478)
	_s85["beatN"] = floor(J.num(J.mul(_s85["at"], 3.2)))
	return {"P": v_P_390, "st": {"axe": "hand"}, "L": v_L_389, "fx": Callable(self, "_f57").bind(_s85)}

func _f59(this_, a: Array, env):
	var v_ctx_406 = null; var v_R_407 = null; var v_s_408 = null; var v_b_409 = null; var v_dir_410 = null; var v_wiped_411 = null; var v_fk_412 = null; var v_m_413 = null; var v_pk_414 = null; var v_i_415 = null; var v_al_416 = null; var v_h0_417 = null; var v_i_418 = null; var v_vx_419 = null; var v_vy_420 = null
	v_ctx_406 = J.arg(a, 0)
	v_R_407 = J.arg(a, 1)
	v_s_408 = J.gp(v_R_407, "H")
	var _t504 = env["__p"]["fp"]
	v_b_409 = J.cl(_t504, null, [v_R_407, "brow"])
	v_dir_410 = (1.0 if J.t(J.gp(env["a"], "faceRight")) else (-1.0))
	var _t505 = env["__p"]["seg"]
	v_wiped_411 = J.cl(_t505, null, [env["at"], 0.8, 1.25])
	v_i_415 = 0.0
	while true:
		if not J.cmp(v_i_415, 3.0, "<"): break
		var _t506 = env["__p"]["seg"]
		var _t508 = J.sub(1.0, J.cl(_t506, null, [env["at"], (0.85 + J.mul(v_i_415, 0.12)), (1.0 + J.mul(v_i_415, 0.12))]))
		var _t507 = env["__p"]["cl"]
		v_al_416 = J.mul(_t508, J.cl(_t507, null, [J.div(env["at"], 0.25)]))
		var _t509 = env["__p"]["drop"]
		J.cl(_t509, null, [v_ctx_406, J.add(J.gp(v_b_409, "x"), J.mul(J.mul(v_dir_410, (0.04 - J.mul(v_i_415, 0.07))), v_s_408)), J.add(J.gp(v_b_409, "y"), J.mul(J.gp([0.0, 0.035, (-0.01)], v_i_415), v_s_408)), J.mul(v_s_408, J.gp([0.016, 0.012, 0.014], v_i_415)), 0.0, v_al_416])
		v_i_415 = J.num(v_i_415) + 1.0
	var _t510 = env["__p"]["seg"]
	v_fk_412 = J.cl(_t510, null, [env["at"], 1.5, 2.2])
	var _t511 = J.cmp(v_fk_412, 0.0, ">")
	if (J.cmp(v_fk_412, 1.0, "<") if _t511 else _t511):
		var _t512 = J.gp(v_R_407, "Ma")
		v_h0_417 = J.mc(_t512, "transformPoint", [J.construct(J.G.get("DOMPoint"), [J.mul(J.sub(J.gp(env["__p"]["FIST"], 0.0), J.gp(J.gp(J.cl(env["__p"]["LD"], null, []), "pivot"), 0.0)), J.gp(v_R_407, "W")), J.mul(J.sub(J.gp(env["__p"]["FIST"], 1.0), J.gp(J.gp(J.cl(env["__p"]["LD"], null, []), "pivot"), 1.0)), J.gp(v_R_407, "H"))])])
		v_i_418 = 0.0
		while true:
			if not J.cmp(v_i_418, 3.0, "<"): break
			v_vx_419 = J.mul(v_dir_410, (-(0.25 + J.mul(v_i_418, 0.12))))
			v_vy_420 = ((-0.35) + J.mul(v_i_418, 0.12))
			var _t513 = env["__p"]["drop"]
			J.cl(_t513, null, [v_ctx_406, J.add(J.gp(v_h0_417, "x"), J.mul(J.mul(v_vx_419, v_fk_412), v_s_408)), J.add(J.gp(v_h0_417, "y"), J.mul((J.mul(v_vy_420, v_fk_412) + J.mul(J.mul(0.9, v_fk_412), v_fk_412)), v_s_408)), J.mul(v_s_408, 0.016), (atan2(J.num(J.add(v_vy_420, J.mul(1.8, v_fk_412))), J.num(v_vx_419)) + J.div(env["__p"]["PI"], 2.0)), J.sub(1.0, v_fk_412)])
			v_i_418 = J.num(v_i_418) + 1.0
	var _t514 = env["__p"]["fp"]
	v_m_413 = J.cl(_t514, null, [v_R_407, "mouth"])
	var _t515 = env["__p"]["seg"]
	v_pk_414 = J.cl(_t515, null, [env["at"], 1.75, 2.6])
	var _t516 = env["__p"]["puff"]
	var _t518 = J.add(J.gp(v_m_413, "x"), (J.mul(v_dir_410, v_s_408) * (0.1 + J.mul(v_pk_414, 0.14))))
	var _t519 = J.add(J.add(J.gp(v_m_413, "y"), J.mul(v_s_408, 0.03)), (J.mul(v_pk_414, v_s_408) * 0.02))
	var _t520 = J.mul(v_s_408, (0.04 + J.mul(v_pk_414, 0.05)))
	var _t517 = env["__p"]["bell"]
	J.cl(_t516, null, [v_ctx_406, _t518, _t519, _t520, J.cl(_t517, null, [env["at"], 1.75, 2.6]), "rgba(235,240,245,.9)"])
	var _t521 = env["__p"]["crayonText"]
	var _t524 = J.add(J.gp(v_m_413, "x"), (J.mul(v_dir_410, v_s_408) * (0.34 + J.mul(v_pk_414, 0.06))))
	var _t525 = (J.sub(J.gp(v_m_413, "y"), J.mul(v_s_408, 0.08)) - (J.mul(v_pk_414, v_s_408) * 0.06))
	var _t526 = J.mul(v_s_408, 0.16)
	var _t522 = env["__p"]["cl"]
	var _t523 = env["__p"]["bell"]
	J.cl(_t521, null, [v_ctx_406, "呼～", _t524, _t525, _t526, "#eaf6ff", J.cl(_t522, null, [J.mul(J.cl(_t523, null, [env["at"], 1.8, 2.7]), 2.0)])])

func _f58(this_, a: Array, env):
	var v_L_404 = null; var v_P_405 = null
	var _s87 = {"__p": env, "a": null, "at": null}
	_s87["a"] = J.arg(a, 0)
	_s87["at"] = J.arg(a, 1)
	v_L_404 = 2.8
	var _t502 = _s87["__p"]["track"]
	v_P_405 = J.cl(_t502, null, [_s87["at"], [[0.0, {}], [0.3, {"th": (-4.0), "head": (-0.04), "sy": (-0.01)}, "io"], [0.75, {"th": 50.0, "hx": (-0.1), "hy": 0.0, "head": 0.08, "wr": (-40.0), "lean": (-2.0)}, "o3"], [1.3, {"th": 60.0, "hx": 0.1, "hy": 0.02, "head": 0.16, "wr": (-32.0), "lean": 4.0}, "io"], [1.6, {"th": 80.0, "hx": 0.27, "hy": (-0.06), "head": 0.1, "wr": 16.0, "lean": 3.0}, "o"], [2.0, {"th": (-6.0), "head": (-0.08), "sy": (-0.03), "dy": 0.01, "lean": (-3.0)}, "io"], [2.4, {"head": 0.01}, "io"], [v_L_404, {}, "io"]]])
	var _t503 = J.cmp(_s87["at"], 0.35, ">")
	return {"P": v_P_405, "st": {"axe": "hand", "front": (J.cmp(_s87["at"], 1.55, "<") if _t503 else _t503)}, "L": v_L_404, "fx": Callable(self, "_f59").bind(_s87)}

func _f61(this_, a: Array, env):
	var v_ctx_426 = null; var v_R_427 = null; var v_s_428 = null; var v_c_429 = null; var v_dir_430 = null; var v_m_431 = null; var v_bk_432 = null; var v_t0_433 = null; var v_j_434 = null; var v_k_435 = null; var v_i_436 = null; var v_R2_437 = null; var v_i_438 = null; var v_y0_439 = null; var v_x0_440 = null; var v_i_441 = null; var v_q_442 = null; var v_x_443 = null; var v_y_444 = null
	v_ctx_426 = J.arg(a, 0)
	v_R_427 = J.arg(a, 1)
	v_s_428 = J.gp(v_R_427, "H")
	var _t533 = env["__p"]["fp"]
	v_c_429 = J.cl(_t533, null, [v_R_427, "chest"])
	v_dir_430 = (1.0 if J.t(J.gp(env["a"], "faceRight")) else (-1.0))
	for _t534 in J.iter([[0.42, 0.0], [0.78, 1.0]]):
		var _t535 = J.gp(_t534, 0.0)
		v_t0_433 = _t535
		var _t536 = J.gp(_t534, 1.0)
		v_j_434 = _t536
		var _t537 = env["__p"]["seg"]
		v_k_435 = J.cl(_t537, null, [env["at"], v_t0_433, J.add(v_t0_433, 0.5)])
		var _t538 = J.cmp(v_k_435, 0.0, ">")
		if (J.cmp(v_k_435, 1.0, "<") if _t538 else _t538):
			v_i_436 = 0.0
			while true:
				if not J.cmp(v_i_436, 2.0, "<"): break
				var _t539 = env["__p"]["puff"]
				J.cl(_t539, null, [v_ctx_426, (J.sub(J.gp(v_c_429, "x"), (J.mul(v_dir_430, v_s_428) * ((0.08 + J.mul(v_i_436, 0.07)) + J.mul(v_j_434, 0.03)))) - (J.mul(J.mul(v_dir_430, v_k_435), v_s_428) * 0.1)), J.sub(J.add(J.gp(v_c_429, "y"), J.mul(v_s_428, (0.08 + J.mul(v_i_436, 0.05)))), (J.mul(v_k_435, v_s_428) * 0.06)), J.mul(v_s_428, (0.05 + J.mul(v_k_435, 0.07))), (J.sub(1.0, v_k_435) * 0.85)])
				v_i_436 = J.num(v_i_436) + 1.0
	var _t540 = env["__p"]["fp"]
	v_m_431 = J.cl(_t540, null, [v_R_427, "mouth"])
	var _t541 = env["__p"]["seg"]
	v_bk_432 = J.cl(_t541, null, [env["at"], 1.55, 2.3])
	var _t542 = J.cmp(v_bk_432, 0.0, ">")
	if (J.cmp(v_bk_432, 1.0, "<") if _t542 else _t542):
		J.mc(v_ctx_426, "save", [])
		var _t543 = J.mul(J.gp(v_ctx_426, "globalAlpha"), (J.sub(1.0, v_bk_432) * 0.9))
		J.sp(v_ctx_426, "globalAlpha", _t543)
		J.sp(v_ctx_426, "strokeStyle", "rgba(235,245,250,.95)")
		var _t544 = J.max_([1.0, J.mul(v_s_428, 0.012)])
		J.sp(v_ctx_426, "lineWidth", _t544)
		J.sp(v_ctx_426, "lineCap", "round")
		v_i_438 = 0.0
		while true:
			if not J.cmp(v_i_438, 3.0, "<"): break
			v_y0_439 = J.add(J.gp(v_m_431, "y"), (J.mul(J.sub(v_i_438, 1.0), v_s_428) * 0.025))
			v_x0_440 = J.add(J.gp(v_m_431, "x"), (J.mul(v_dir_430, v_s_428) * 0.05))
			J.mc(v_ctx_426, "beginPath", [])
			J.mc(v_ctx_426, "moveTo", [v_x0_440, v_y0_439])
			var _t546 = J.add(v_x0_440, (J.mul(v_dir_430, v_s_428) * 0.12))
			var _t547 = J.sub(v_y0_439, J.mul(v_s_428, 0.02))
			var _t548 = J.add(v_x0_440, (J.mul(v_dir_430, v_s_428) * (0.2 + J.mul(v_bk_432, 0.12))))
			var _t545 = env["__p"]["S"]
			J.mc(v_ctx_426, "quadraticCurveTo", [_t546, _t547, _t548, J.add(v_y0_439, (J.mul(J.cl(_t545, null, [J.add(J.mul(v_bk_432, 9.0), v_i_438)]), v_s_428) * 0.02))])
			J.mc(v_ctx_426, "stroke", [])
			v_i_438 = J.num(v_i_438) + 1.0
		J.mc(v_ctx_426, "restore", [])
		var _t549 = J.gp(v_R_427, "Mg")
		v_R2_437 = J.mc(_t549, "transformPoint", [J.construct(J.G.get("DOMPoint"), [(J.mul(J.gp(J.gp(v_R_427, "axU"), 0.0), J.gp(v_R_427, "al")) * 0.9), (J.mul(J.gp(J.gp(v_R_427, "axU"), 1.0), J.gp(v_R_427, "al")) * 0.9)])])
		v_i_441 = 0.0
		while true:
			if not J.cmp(v_i_441, 5.0, "<"): break
			var _t550 = env["__p"]["cl"]
			v_q_442 = J.cl(_t550, null, [(J.mul(v_bk_432, 1.3) - J.mul(v_i_441, 0.06))])
			var _t551 = J.cmp(v_q_442, 0.0, "<=")
			if (_t551 if _t551 else J.cmp(v_q_442, 1.0, ">=")):
				v_i_441 = J.num(v_i_441) + 1.0
				continue
			v_x_443 = J.add(J.gp(v_R2_437, "x"), J.mul(J.mul(v_dir_430, (0.05 + J.mul(v_q_442, (0.25 + J.mul(v_i_441, 0.05))))), v_s_428))
			v_y_444 = J.add(J.gp(v_R2_437, "y"), J.mul((((-0.04) + J.mul(v_i_441, 0.02)) + (J.mul(v_q_442, v_q_442) * 0.25)), v_s_428))
			J.mc(v_ctx_426, "save", [])
			var _t552 = J.mul(J.gp(v_ctx_426, "globalAlpha"), J.sub(1.0, v_q_442))
			J.sp(v_ctx_426, "globalAlpha", _t552)
			var _t553 = J.gp(["#c8955a", "#a8743e", "#e0b47a"], J.mod(v_i_441, 3.0))
			J.sp(v_ctx_426, "fillStyle", _t553)
			J.mc(v_ctx_426, "translate", [v_x_443, v_y_444])
			J.mc(v_ctx_426, "rotate", [J.add(J.mul(v_q_442, 9.0), v_i_441)])
			J.mc(v_ctx_426, "fillRect", [((-J.num(v_s_428)) * 0.012), ((-J.num(v_s_428)) * 0.006), J.mul(v_s_428, 0.024), J.mul(v_s_428, 0.012)])
			J.mc(v_ctx_426, "restore", [])
			v_i_441 = J.num(v_i_441) + 1.0

func _f60(this_, a: Array, env):
	var v_L_423 = null; var v_P_424 = null; var v_blow_425 = null
	var _s94 = {"__p": env, "a": null, "at": null}
	_s94["a"] = J.arg(a, 0)
	_s94["at"] = J.arg(a, 1)
	v_L_423 = 3.0
	var _t529 = _s94["__p"]["track"]
	v_P_424 = J.cl(_t529, null, [_s94["at"], [[0.0, {}], [0.25, {"armB": 0.25, "head": (-0.12), "lean": (-3.0)}, "io"], [0.42, {"armB": (-0.18), "head": (-0.14), "lean": (-4.0)}, "o"], [0.6, {"armB": 0.28, "head": (-0.14), "lean": (-4.0)}, "io"], [0.78, {"armB": (-0.2), "head": (-0.14), "lean": (-4.0)}, "o"], [0.95, {"armB": 0.0, "head": (-0.05)}, "io"], [1.4, {"th": 30.0, "hx": (-0.05), "hy": 0.02, "wr": (-18.0), "head": (-0.02), "lean": (-4.0), "dx": 0.01}, "o3"], [2.2, {"th": 32.0, "hx": (-0.05), "hy": 0.02, "wr": (-20.0), "head": (-0.06), "lean": (-7.0), "dx": 0.02}, "l"], [2.65, {"th": (-3.0), "head": 0.02}, "io"], [v_L_423, {}, "io"]]])
	var _t530 = _s94["__p"]["bell"]
	v_blow_425 = J.cl(_t530, null, [_s94["at"], 1.55, 2.2])
	var _t531 = J.add(J.gp(v_P_424, "sy"), J.mul((-0.02), v_blow_425))
	J.sp(v_P_424, "sy", _t531)
	var _t532 = J.add(J.gp(v_P_424, "sx"), J.mul(0.015, v_blow_425))
	J.sp(v_P_424, "sx", _t532)
	return {"P": v_P_424, "st": {"axe": "hand", "front": true}, "L": v_L_423, "fx": Callable(self, "_f61").bind(_s94)}

func _f63(this_, a: Array, env):
	var v_ctx_450 = null; var v_R_451 = null; var v_s_452 = null; var v_top_453 = null; var v_dir_454 = null; var v_tip_455 = null; var v_sk_456 = null; var v_g_457 = null; var v_lk_458 = null; var v_i_459 = null; var v_k_460 = null; var v_sd_461 = null
	v_ctx_450 = J.arg(a, 0)
	v_R_451 = J.arg(a, 1)
	v_s_452 = J.gp(v_R_451, "H")
	var _t560 = env["__p"]["fp"]
	v_top_453 = J.cl(_t560, null, [v_R_451, "top"])
	v_dir_454 = (1.0 if J.t(J.gp(env["a"], "faceRight")) else (-1.0))
	var _t561 = J.gp(v_R_451, "Mg")
	v_tip_455 = J.mc(_t561, "transformPoint", [J.construct(J.G.get("DOMPoint"), [J.mul(J.gp(J.gp(v_R_451, "axU"), 0.0), J.gp(v_R_451, "al")), J.mul(J.gp(J.gp(v_R_451, "axU"), 1.0), J.gp(v_R_451, "al"))])])
	var _t562 = env["__p"]["seg"]
	v_sk_456 = J.cl(_t562, null, [env["at"], 0.42, 1.0])
	var _t563 = J.cmp(v_sk_456, 0.0, ">")
	if (J.cmp(v_sk_456, 1.0, "<") if _t563 else _t563):
		var _t564 = env["__p"]["sparkle"]
		var _t566 = J.gp(v_tip_455, "x")
		var _t567 = J.gp(v_tip_455, "y")
		var _t565 = env["__p"]["S"]
		var _t569 = J.mul(v_s_452, (0.03 + J.mul(0.05, J.cl(_t565, null, [J.mul(v_sk_456, env["__p"]["PI"])]))))
		var _t568 = env["__p"]["S"]
		J.cl(_t564, null, [v_ctx_450, _t566, _t567, _t569, J.cl(_t568, null, [J.mul(v_sk_456, env["__p"]["PI"])])])
	v_i_459 = 0.0
	while true:
		if not J.cmp(v_i_459, 3.0, "<"): break
		var _t570 = env["__p"]["seg"]
		v_k_460 = J.cl(_t570, null, [env["at"], (1.0 + J.mul(v_i_459, 0.15)), (1.6 + J.mul(v_i_459, 0.15))])
		var _t571 = J.cmp(v_k_460, 0.0, ">")
		if (J.cmp(v_k_460, 1.0, "<") if _t571 else _t571):
			var _t572 = env["__p"]["sparkle"]
			var _t575 = J.add(J.gp(v_top_453, "x"), (J.mul(v_dir_454, v_s_452) * ((-0.3) + J.mul(v_i_459, 0.3))))
			var _t576 = (J.sub(J.gp(v_top_453, "y"), J.mul(v_s_452, (0.0 + (J.mod(v_i_459, 2.0) * 0.07)))) - (J.mul(v_k_460, v_s_452) * 0.05))
			var _t574 = J.mul(v_s_452, 0.035)
			var _t573 = env["__p"]["S"]
			var _t578 = J.mul(_t574, J.cl(_t573, null, [J.mul(v_k_460, env["__p"]["PI"])]))
			var _t577 = env["__p"]["S"]
			J.cl(_t572, null, [v_ctx_450, _t575, _t576, _t578, J.cl(_t577, null, [J.mul(v_k_460, env["__p"]["PI"])])])
		v_i_459 = J.num(v_i_459) + 1.0
	var _t579 = J.gp(v_R_451, "G")
	v_g_457 = J.mc(_t579, "transformPoint", [J.construct(J.G.get("DOMPoint"), [0.0, 0.0])])
	var _t580 = env["__p"]["seg"]
	v_lk_458 = J.cl(_t580, null, [env["at"], 0.76, 1.2])
	var _t581 = J.cmp(v_lk_458, 0.0, ">")
	if (J.cmp(v_lk_458, 1.0, "<") if _t581 else _t581):
		for _t582 in J.iter([(-1.0), 1.0]):
			v_sd_461 = _t582
			var _t583 = env["__p"]["puff"]
			J.cl(_t583, null, [v_ctx_450, J.add(J.gp(v_g_457, "x"), (J.mul(v_sd_461, v_s_452) * (0.12 + J.mul(v_lk_458, 0.12)))), (J.sub(J.gp(v_g_457, "y"), J.mul(v_s_452, 0.02)) - (J.mul(v_lk_458, v_s_452) * 0.03)), J.mul(v_s_452, (0.05 + J.mul(v_lk_458, 0.06))), (J.sub(1.0, v_lk_458) * 0.8)])

func _f62(this_, a: Array, env):
	var v_L_447 = null; var v_P_448 = null; var v_chest_449 = null
	var _s104 = {"__p": env, "a": null, "at": null}
	_s104["a"] = J.arg(a, 0)
	_s104["at"] = J.arg(a, 1)
	v_L_447 = 2.2
	var _t556 = _s104["__p"]["track"]
	v_P_448 = J.cl(_t556, null, [_s104["at"], [[0.0, {}], [0.2, {"sy": (-0.07), "sx": 0.05, "dy": 0.02, "head": (-0.1), "th": (-10.0), "lean": (-3.0)}, "o"], [0.48, {"sy": 0.08, "sx": (-0.04), "dy": (-0.2), "head": 0.18, "th": 110.0, "hx": 0.0, "hy": 0.1, "wr": (-20.0), "lean": 6.0, "armB": (-0.45), "tie": 0.4, "tail1": (-0.2), "tail2": (-0.4)}, "o3"], [0.62, {"sy": 0.04, "sx": (-0.02), "dy": (-0.17), "head": 0.16, "th": 112.0, "hx": 0.0, "hy": 0.1, "wr": (-20.0), "lean": 6.0, "armB": (-0.45), "tie": 0.35, "tail1": (-0.1), "tail2": (-0.2)}, "l"], [0.78, {"sy": (-0.08), "sx": 0.06, "dy": 0.015, "head": 0.0, "th": 60.0, "hx": (-0.03), "hy": 0.1, "wr": 0.0, "lean": 2.0, "armB": (-0.2), "tie": (-0.1), "tail1": 0.15, "tail2": 0.3}, "i"], [1.0, {"sy": 0.02, "sx": (-0.01), "dy": 0.0, "head": 0.14, "th": 10.0, "hx": (-0.06), "hy": 0.12, "wr": 15.0, "lean": 7.0, "armB": (-0.12), "tie": 0.1}, "o"], [1.75, {"sy": 0.025, "sx": (-0.012), "head": 0.15, "th": 12.0, "hx": (-0.06), "hy": 0.13, "wr": 15.0, "lean": 7.0, "armB": (-0.12)}, "l"], [2.0, {"head": 0.02, "th": (-4.0)}, "io"], [v_L_447, {}, "io"]]])
	var _t557 = _s104["__p"]["bell"]
	v_chest_449 = J.cl(_t557, null, [_s104["at"], 1.0, 1.75])
	var _t558 = _s104["__p"]["S"]
	var _t559 = J.add(J.gp(v_P_448, "sy"), J.mul(J.mul(J.cl(_t558, null, [J.mul(_s104["at"], 9.0)]), 0.006), v_chest_449))
	J.sp(v_P_448, "sy", _t559)
	return {"P": v_P_448, "st": {"axe": "hand"}, "L": v_L_447, "fx": Callable(self, "_f63").bind(_s104)}

func _f66(this_, a: Array, env):
	var v_ctx_474 = null; var v_R_475 = null; var v_s_476 = null; var v_dir_477 = null; var v_pp_478 = null; var v_dk_479 = null; var v_top_480 = null; var v_bk_481 = null; var v_bx_482 = null; var v_by_483 = null; var v_mk_484 = null; var v_m_485 = null; var v_sk_486 = null; var v_k_487 = null; var v_g_488 = null; var v_I_489 = null; var v_sc_490 = null; var v_pop_491 = null; var v_cx_492 = null; var v_y_493 = null
	v_ctx_474 = J.arg(a, 0)
	v_R_475 = J.arg(a, 1)
	v_s_476 = J.gp(v_R_475, "H")
	v_dir_477 = (1.0 if J.t(J.gp(env["a"], "faceRight")) else (-1.0))
	var _t598 = env["__p"]["plantFx"]
	J.cl(_t598, null, [v_ctx_474, env["a"], v_R_475, env["at"], 0.52])
	var _t599 = J.cmp(env["at"], 6.95, ">")
	if (J.cmp(env["at"], 7.6, "<") if _t599 else _t599):
		var _t600 = env["__p"]["seg"]
		v_k_487 = J.cl(_t600, null, [env["at"], 7.0, 7.5])
		var _t601 = J.gp(v_R_475, "G")
		var _t602 = env["__p"]["plantM"]
		var _t603 = J.mc(_t601, "multiply", [J.cl(_t602, null, [env["a"]])])
		v_g_488 = J.mc(_t603, "transformPoint", [J.construct(J.G.get("DOMPoint"), [J.mul(J.gp(J.gp(v_R_475, "axU"), 0.0), J.gp(v_R_475, "al")), J.mul(J.gp(J.gp(v_R_475, "axU"), 1.0), J.gp(v_R_475, "al"))])])
		var _t604 = env["__p"]["puff"]
		J.cl(_t604, null, [v_ctx_474, J.gp(v_g_488, "x"), (J.sub(J.gp(v_g_488, "y"), J.mul(v_s_476, 0.02)) - (J.mul(v_k_487, v_s_476) * 0.04)), J.mul(v_s_476, (0.05 + J.mul(v_k_487, 0.06))), (J.sub(1.0, v_k_487) * 0.8)])
	var _t605 = J.gp(v_R_475, "Ma")
	var _t606 = J.mc(_t605, "translate", [J.mul(J.sub(J.gp(env["__p"]["FIST"], 0.0), J.gp(J.gp(J.cl(env["__p"]["LD"], null, []), "pivot"), 0.0)), J.gp(v_R_475, "W")), J.mul(J.sub(J.gp(env["__p"]["FIST"], 1.0), J.gp(J.gp(J.cl(env["__p"]["LD"], null, []), "pivot"), 1.0)), J.gp(v_R_475, "H"))])
	v_pp_478 = J.mc(_t606, "transformPoint", [J.construct(J.G.get("DOMPoint"), [0.0, ((-J.num(v_s_476)) * 0.15)])])
	var _t607 = env["__p"]["seg"]
	v_dk_479 = J.cl(_t607, null, [env["at"], 2.6, 3.6])
	var _t608 = J.cmp(v_dk_479, 0.0, ">")
	var _t610 = (J.cmp(v_dk_479, 1.0, "<") if _t608 else _t608)
	if J.t(_t610):
		var _t609 = env["__p"]["ok"]
		_t610 = J.cl(_t609, null, ["afu__ring"])
	if J.t(_t610):
		v_I_489 = J.gp(J.G.get("SPR"), "afu__ring")
		var _t612 = J.div(J.mul(v_s_476, 0.14), J.gp(v_I_489, "naturalHeight"))
		var _t611 = env["__p"]["S"]
		v_sc_490 = (_t612 * (1.0 + J.mul(0.15, J.cl(_t611, null, [J.mul(v_dk_479, 30.0)]))))
		J.mc(v_ctx_474, "save", [])
		var _t613 = env["__p"]["cl"]
		var _t614 = J.mul(J.gp(v_ctx_474, "globalAlpha"), J.cl(_t613, null, [(J.sub(1.0, v_dk_479) * 3.0)]))
		J.sp(v_ctx_474, "globalAlpha", _t614)
		J.mc(v_ctx_474, "translate", [J.add(J.gp(v_pp_478, "x"), (J.mul(v_dir_477, v_s_476) * 0.02)), J.sub(J.gp(v_pp_478, "y"), J.mul(v_s_476, 0.02))])
		if J.cmp(v_dir_477, 0.0, "<"):
			J.mc(v_ctx_474, "scale", [(-1.0), 1.0])
		J.mc(v_ctx_474, "drawImage", [v_I_489, 0.0, (J.mul((-J.num(J.gp(v_I_489, "naturalHeight"))), v_sc_490) * 0.6), J.mul(J.gp(v_I_489, "naturalWidth"), v_sc_490), J.mul(J.gp(v_I_489, "naturalHeight"), v_sc_490)])
		J.mc(v_ctx_474, "restore", [])
	var _t615 = env["__p"]["fp"]
	v_top_480 = J.cl(_t615, null, [v_R_475, "top"])
	var _t616 = env["__p"]["cl"]
	var _t617 = env["__p"]["bell"]
	v_bk_481 = J.cl(_t616, null, [J.mul(J.cl(_t617, null, [env["at"], 2.6, 3.4]), 3.0)])
	v_bx_482 = J.add(J.gp(v_top_480, "x"), (J.mul(v_dir_477, v_s_476) * 0.34))
	v_by_483 = J.sub(J.gp(v_top_480, "y"), J.mul(v_s_476, 0.02))
	if J.cmp(v_bk_481, 0.0, ">"):
		var _t619 = null
		if J.cmp(env["at"], 2.8, "<"):
			var _t618 = env["__p"]["seg"]
			_t619 = J.mc(env["__p"]["E"], "back", [J.cl(_t618, null, [env["at"], 2.6, 2.8])])
		else:
			_t619 = 1.0
		v_pop_491 = _t619
		J.mc(v_ctx_474, "save", [])
		J.mc(v_ctx_474, "translate", [v_bx_482, v_by_483])
		J.mc(v_ctx_474, "scale", [v_pop_491, v_pop_491])
		var _t620 = env["__p"]["say"]
		J.cl(_t620, null, [v_ctx_474, "叮！", 0.0, 0.0, J.mul(v_s_476, 0.13), "#d8402e", v_bk_481, (J.mul((-J.num(v_dir_477)), v_s_476) * 0.1), J.mul(v_s_476, 0.2)])
		J.mc(v_ctx_474, "restore", [])
	var _t621 = env["__p"]["cl"]
	var _t622 = env["__p"]["bell"]
	v_mk_484 = J.cl(_t621, null, [J.mul(J.cl(_t622, null, [env["at"], 3.3, 4.8]), 3.0)])
	if J.cmp(v_mk_484, 0.0, ">"):
		v_cx_492 = J.add(J.gp(v_pp_478, "x"), J.mul(v_dir_477, J.max_([J.mul(v_s_476, 0.5), 38.0])))
		var _t624 = J.gp(v_pp_478, "y")
		var _t623 = env["__p"]["seg"]
		v_y_493 = J.sub(_t624, J.mul(v_s_476, (0.12 + J.mul(J.cl(_t623, null, [env["at"], 3.3, 3.6]), 0.05))))
		var _t625 = env["__p"]["say"]
		J.cl(_t625, null, [v_ctx_474, "老闆：今晚加班", v_cx_492, v_y_493, J.mul(v_s_476, 0.1), "#3a2a2e", v_mk_484, J.add(J.gp(v_pp_478, "x"), (J.mul(v_dir_477, v_s_476) * 0.08)), J.sub(J.gp(v_pp_478, "y"), J.mul(v_s_476, 0.02))])
	var _t626 = env["__p"]["fp"]
	v_m_485 = J.cl(_t626, null, [v_R_475, "mouth"])
	var _t627 = env["__p"]["seg"]
	v_sk_486 = J.cl(_t627, null, [env["at"], 4.7, 5.9])
	var _t628 = env["__p"]["puff"]
	var _t630 = J.add(J.gp(v_m_485, "x"), (J.mul(v_dir_477, v_s_476) * (0.12 + J.mul(v_sk_486, 0.2))))
	var _t631 = J.add(J.add(J.gp(v_m_485, "y"), J.mul(v_s_476, 0.05)), (J.mul(v_sk_486, v_s_476) * 0.06))
	var _t632 = J.mul(v_s_476, (0.05 + J.mul(v_sk_486, 0.07)))
	var _t629 = env["__p"]["bell"]
	J.cl(_t628, null, [v_ctx_474, _t630, _t631, _t632, J.cl(_t629, null, [env["at"], 4.7, 5.9]), "rgba(225,235,240,.9)"])
	var _t633 = env["__p"]["crayonText"]
	var _t636 = J.add(J.gp(v_m_485, "x"), (J.mul(v_dir_477, v_s_476) * (0.5 + J.mul(v_sk_486, 0.08))))
	var _t637 = (J.sub(J.gp(v_m_485, "y"), J.mul(v_s_476, 0.12)) + (J.mul(v_sk_486, v_s_476) * 0.04))
	var _t638 = J.mul(v_s_476, 0.17)
	var _t634 = env["__p"]["cl"]
	var _t635 = env["__p"]["bell"]
	J.cl(_t633, null, [v_ctx_474, "唉——", _t636, _t637, _t638, "#cfe0ff", J.cl(_t634, null, [J.mul(J.cl(_t635, null, [env["at"], 4.75, 6.1]), 2.0)])])

func _f65(this_, a: Array, env):
	var v_L_467 = null; var v_pk_468 = null; var v_HOLD_469 = null; var v_P_470 = null; var v_hasAxeInHand_471 = null; var v_ph_472 = null; var v_scroll_473 = null
	var _s111 = {"__p": env, "a": null, "at": null}
	_s111["a"] = J.arg(a, 0)
	_s111["at"] = J.arg(a, 1)
	v_L_467 = 7.6
	var _t586 = _s111["__p"]["plantKeys"]
	v_pk_468 = J.cl(_t586, null, [0.0])
	v_HOLD_469 = {"th": 5.0, "hx": 0.18, "hy": (-0.12), "head": (-0.15), "lean": (-3.0), "armB": 0.05}
	var _t587 = _s111["__p"]["track"]
	v_P_470 = J.cl(_t587, null, [_s111["at"], J.mc(v_pk_468, "concat", [[[0.75, J.S_Object_("assign", [{}, _s111["__p"]["PLANT"]]), "l"], [1.0, {"th": (-60.0), "hx": (-0.02), "hy": 0.02, "lean": (-6.0), "dx": 0.04, "head": (-0.06), "bob": (-0.3)}, "io"], [1.35, {"th": (-12.0), "hx": 0.3, "hy": (-0.1), "lean": (-4.0), "dx": 0.02, "head": (-0.12)}, "io"], [1.85, v_HOLD_469, "back"], [2.6, J.S_Object_("assign", [{}, v_HOLD_469, {"head": (-0.16)}]), "l"], [2.75, J.S_Object_("assign", [{}, v_HOLD_469, {"head": (-0.11), "dy": (-0.012), "th": 9.0, "sy": 0.015}]), "o"], [3.1, J.S_Object_("assign", [{}, v_HOLD_469, {"head": (-0.17)}]), "io"], [4.2, J.S_Object_("assign", [{}, v_HOLD_469, {"head": (-0.2), "th": 3.0}]), "l"], [4.65, J.S_Object_("assign", [{}, v_HOLD_469, {"head": 0.06, "sy": 0.05, "dy": (-0.025), "lean": 3.0, "th": 2.0, "hy": (-0.14)}]), "io"], [5.4, J.S_Object_("assign", [{}, v_HOLD_469, {"head": (-0.24), "sy": (-0.06), "sx": 0.03, "dy": 0.025, "lean": (-7.0), "th": (-8.0), "hy": (-0.16), "armB": 0.12, "tie": (-0.15)}]), "o"], [5.7, J.S_Object_("assign", [{}, v_HOLD_469, {"head": (-0.22), "sy": (-0.05), "sx": 0.025, "dy": 0.02, "lean": (-6.0), "th": (-8.0), "hy": (-0.16), "armB": 0.12}]), "l"], [6.05, {"th": (-12.0), "hx": 0.3, "hy": (-0.1), "lean": (-4.0), "dx": 0.02, "head": (-0.1)}, "io"], [6.45, {"th": (-60.0), "hx": (-0.02), "hy": 0.02, "lean": (-6.0), "dx": 0.04, "head": (-0.04), "bob": (-0.6)}, "io"], [6.8, J.S_Object_("assign", [{}, _s111["__p"]["PLANT"], {"head": (-0.06)}]), "io"], [6.95, J.S_Object_("assign", [{}, _s111["__p"]["PLANT"], {"sy": (-0.07), "sx": 0.05, "dy": 0.04, "head": (-0.06)}]), "io"], [7.15, {"th": 20.0, "lean": 4.0, "dy": (-0.03), "sy": 0.05, "sx": (-0.03), "head": 0.06}, "o3"], [v_L_467, {}, "io"]]])])
	var _t588 = J.cmp(_s111["at"], 0.75, "<")
	v_hasAxeInHand_471 = (_t588 if _t588 else J.cmp(_s111["at"], 6.8, ">="))
	v_ph_472 = (0.0 if J.cmp(_s111["at"], 1.35, "<") else (J.mc(_s111["__p"]["E"], "o", [J.div(J.sub(_s111["at"], 1.35), 0.25)]) if J.cmp(_s111["at"], 1.6, "<") else (1.0 if J.cmp(_s111["at"], 5.85, "<") else (J.sub(1.0, J.mc(_s111["__p"]["E"], "i", [J.div(J.sub(_s111["at"], 5.85), 0.2)])) if J.cmp(_s111["at"], 6.05, "<") else 0.0))))
	var _t589 = _s111["__p"]["bell"]
	var _t591 = J.cl(_t589, null, [_s111["at"], 1.9, 2.6])
	var _t590 = _s111["__p"]["bell"]
	v_scroll_473 = J.add(_t591, J.cl(_t590, null, [_s111["at"], 3.1, 4.2]))
	var _t592 = _s111["__p"]["S"]
	var _t593 = J.add(J.gp(v_P_470, "th"), J.mul(J.mul(J.cl(_t592, null, [J.mul(_s111["at"], 9.0)]), 1.5), v_scroll_473))
	J.sp(v_P_470, "th", _t593)
	var _t595 = ("hand" if J.t(v_hasAxeInHand_471) else "plant")
	var _t594 = _s111["__p"]["plantM"]
	var _t597 = J.cl(_t594, null, [_s111["a"]])
	var _t596 = _s111["__p"]["bell"]
	return {"P": v_P_470, "st": {"axe": _t595, "plantM": _t597, "phone": v_ph_472, "glow": J.mul(v_ph_472, (0.6 + J.mul(0.4, J.cl(_t596, null, [_s111["at"], 2.6, 3.0])))), "phoneRot": (-15.0)}, "L": v_L_467, "fx": Callable(self, "_f66").bind(_s111)}

func _f69(this_, a: Array, env):
	var v_ctx_515 = null; var v_R_516 = null; var v_s_517 = null; var v_dir_518 = null; var v_n_519 = null; var v_r_520 = null; var v_top_521 = null; var v_i_522 = null; var v_k_523 = null
	v_ctx_515 = J.arg(a, 0)
	v_R_516 = J.arg(a, 1)
	v_s_517 = J.gp(v_R_516, "H")
	v_dir_518 = (1.0 if J.t(J.gp(env["a"], "faceRight")) else (-1.0))
	var _t654 = env["__p"]["plantFx"]
	J.cl(_t654, null, [v_ctx_515, env["a"], v_R_516, env["at"], 0.52])
	if J.cmp(env["sl"], 0.0, "<="):
		return null
	var _t655 = env["__p"]["fp"]
	v_n_519 = J.cl(_t655, null, [v_R_516, "nose"])
	var _t657 = J.mul(J.mul(v_s_517, (0.025 + (0.045 * (0.5 + J.mul(0.5, env["br"]))))), env["sl"])
	var _t656 = J.cmp(env["nodP"], 4.3, ">")
	v_r_520 = (_t657 * (0.6 if (J.cmp(env["nodP"], 4.5, "<") if _t656 else _t656) else 1.0))
	var _t658 = env["__p"]["snot"]
	J.cl(_t658, null, [v_ctx_515, J.add(J.gp(v_n_519, "x"), (J.mul(v_dir_518, v_r_520) * 0.55)), J.add(J.gp(v_n_519, "y"), J.mul(v_r_520, 0.75)), v_r_520, env["sl"]])
	var _t659 = env["__p"]["fp"]
	v_top_521 = J.cl(_t659, null, [v_R_516, "top"])
	v_i_522 = 0.0
	while true:
		if not J.cmp(v_i_522, 3.0, "<"): break
		v_k_523 = J.mod((J.mul(env["at"], 0.45) + J.div(v_i_522, 3.0)), 1.0)
		var _t660 = env["__p"]["crayonText"]
		var _t663 = ("Z" if J.seq(v_i_522, 1.0) else "z")
		var _t662 = J.sub(J.gp(v_top_521, "x"), (J.mul(v_dir_518, v_s_517) * (0.3 + J.mul(v_k_523, 0.25))))
		var _t661 = env["__p"]["S"]
		var _t665 = (_t662 + (J.mul(J.cl(_t661, null, [J.add(J.mul(v_k_523, 6.0), v_i_522)]), v_s_517) * 0.03))
		var _t666 = J.sub(J.add(J.gp(v_top_521, "y"), J.mul(v_s_517, 0.02)), (J.mul(v_k_523, v_s_517) * 0.4))
		var _t667 = J.mul(v_s_517, (0.1 + J.mul(v_k_523, 0.08)))
		var _t664 = env["__p"]["S"]
		J.cl(_t660, null, [v_ctx_515, _t663, _t665, _t666, _t667, "#e8e4ff", J.mul(J.cl(_t664, null, [J.mul(v_k_523, env["__p"]["PI"])]), env["sl"]), J.mul((-0.25), v_dir_518)])
		v_i_522 = J.num(v_i_522) + 1.0

func _f68(this_, a: Array, env):
	var v_t_507 = null; var v_pk_508 = null; var v_LEAN_509 = null; var v_P_510 = null; var v_nod_514 = null
	var _s121 = {"__p": env, "a": null, "at": null, "sl": null, "br": null, "nodP": null}
	_s121["a"] = J.arg(a, 0)
	_s121["at"] = J.arg(a, 1)
	v_t_507 = J.arg(a, 2)
	var _t641 = _s121["__p"]["plantKeys"]
	v_pk_508 = J.cl(_t641, null, [0.0])
	v_LEAN_509 = J.S_Object_("assign", [{}, _s121["__p"]["PLANT"], {"head": (-0.22), "msy": (-0.025), "tail1": 0.12, "tail2": 0.2, "tie": (-0.12)}])
	var _t642 = _s121["__p"]["track"]
	v_P_510 = J.cl(_t642, null, [_s121["at"], J.mc(v_pk_508, "concat", [[[0.75, J.S_Object_("assign", [{}, _s121["__p"]["PLANT"]]), "l"], [1.8, v_LEAN_509, "io"]]])])
	var _t643 = _s121["__p"]["cl"]
	_s121["sl"] = J.cl(_t643, null, [J.div(J.sub(_s121["at"], 1.6), 0.8)])
	var _t644 = _s121["__p"]["S"]
	_s121["br"] = J.cl(_t644, null, [J.mul(_s121["at"], 1.6)])
	_s121["nodP"] = J.mod((J.mod(J.sub(_s121["at"], 1.8), 5.2) + 5.2), 5.2)
	var _t646 = null
	if J.cmp(_s121["nodP"], 4.3, "<"):
		_t646 = J.mc(_s121["__p"]["E"], "io", [J.div(_s121["nodP"], 4.3)])
	else:
		var _t645 = _s121["__p"]["cl"]
		_t646 = J.sub(1.0, J.mc(_s121["__p"]["E"], "back", [J.cl(_t645, null, [J.div(J.sub(_s121["nodP"], 4.3), 0.35)])]))
	v_nod_514 = _t646
	var _t647 = J.add(J.gp(v_P_510, "msy"), J.mul(J.mul(_s121["br"], 0.012), _s121["sl"]))
	J.sp(v_P_510, "msy", _t647)
	var _t648 = J.add(J.gp(v_P_510, "head"), J.mul((J.mul((-0.1), v_nod_514) + J.mul(_s121["br"], 0.015)), _s121["sl"]))
	J.sp(v_P_510, "head", _t648)
	var _t649 = _s121["__p"]["S"]
	var _t650 = J.add(J.gp(v_P_510, "tie"), J.mul(J.mul(J.cl(_t649, null, [J.mul(_s121["at"], 2.0)]), 0.05), _s121["sl"]))
	J.sp(v_P_510, "tie", _t650)
	var _t651 = _s121["__p"]["S"]
	var _t652 = J.add(J.gp(v_P_510, "tail2"), J.mul(J.mul(J.cl(_t651, null, [J.mul(_s121["at"], 1.2)]), 0.08), _s121["sl"]))
	J.sp(v_P_510, "tail2", _t652)
	var _t653 = _s121["__p"]["plantM"]
	return {"P": v_P_510, "st": {"axe": "hand", "plantM": J.cl(_t653, null, [_s121["a"]])}, "fx": Callable(self, "_f69").bind(_s121)}

func _f71(this_, a: Array, env):
	var v_ctx_530 = null; var v_R_531 = null; var v_s_532 = null; var v_dir_533 = null; var v_n_534 = null; var v_pk_535 = null; var v_top_536 = null; var v_ek_537 = null; var v_g_538 = null; var v_dk_539 = null; var v_lk_540 = null; var v_g0_541 = null; var v_i_542 = null; var v_k_543 = null; var v_sd_544 = null; var v_sd_545 = null
	v_ctx_530 = J.arg(a, 0)
	v_R_531 = J.arg(a, 1)
	v_s_532 = J.gp(v_R_531, "H")
	v_dir_533 = (1.0 if J.t(J.gp(env["a"], "faceRight")) else (-1.0))
	var _t674 = env["__p"]["fp"]
	v_n_534 = J.cl(_t674, null, [v_R_531, "nose"])
	var _t675 = env["__p"]["seg"]
	v_pk_535 = J.cl(_t675, null, [env["at"], 0.0, 0.18])
	if J.cmp(v_pk_535, 1.0, "<"):
		if J.cmp(env["at"], 0.06, "<"):
			var _t676 = env["__p"]["snot"]
			J.cl(_t676, null, [v_ctx_530, J.add(J.gp(v_n_534, "x"), (J.mul(v_dir_533, v_s_532) * 0.035)), J.add(J.gp(v_n_534, "y"), J.mul(v_s_532, 0.05)), (J.mul(v_s_532, 0.07) * (1.0 + J.mul(env["at"], 3.0))), 1.0])
		else:
			var _t677 = env["__p"]["lines"]
			J.cl(_t677, null, [v_ctx_530, J.add(J.gp(v_n_534, "x"), (J.mul(v_dir_533, v_s_532) * 0.035)), J.add(J.gp(v_n_534, "y"), J.mul(v_s_532, 0.05)), J.mul(J.mul(v_s_532, 0.1), J.add(0.7, v_pk_535)), 7.0, 0.0, J.mul(env["__p"]["PI"], 2.0), J.sub(1.0, v_pk_535), "rgba(200,236,252,.95)"])
	var _t678 = env["__p"]["crayonText"]
	var _t681 = J.add(J.gp(v_n_534, "x"), (J.mul(v_dir_533, v_s_532) * 0.18))
	var _t682 = J.sub(J.add(J.gp(v_n_534, "y"), J.mul(v_s_532, 0.02)), (J.mul(v_pk_535, v_s_532) * 0.05))
	var _t683 = J.mul(v_s_532, 0.13)
	var _t679 = env["__p"]["cl"]
	var _t680 = env["__p"]["bell"]
	J.cl(_t678, null, [v_ctx_530, "啵", _t681, _t682, _t683, "#cdeeff", J.cl(_t679, null, [J.mul(J.cl(_t680, null, [env["at"], 0.02, 0.5]), 2.0)])])
	var _t684 = env["__p"]["fp"]
	v_top_536 = J.cl(_t684, null, [v_R_531, "top"])
	var _t685 = env["__p"]["seg"]
	v_ek_537 = J.cl(_t685, null, [env["at"], 0.25, 0.4])
	var _t686 = env["__p"]["crayonText"]
	var _t689 = J.add(J.gp(v_top_536, "x"), (J.mul(v_dir_533, v_s_532) * 0.18))
	var _t690 = J.sub(J.gp(v_top_536, "y"), J.mul(v_s_532, 0.08))
	var _t691 = J.mul(J.mul(v_s_532, 0.28), (J.mc(env["__p"]["E"], "back", [v_ek_537]) if J.cmp(env["at"], 0.4, "<") else 1.0))
	var _t687 = env["__p"]["cl"]
	var _t688 = env["__p"]["bell"]
	J.cl(_t686, null, [v_ctx_530, "！", _t689, _t690, _t691, "#ff6a4a", J.cl(_t687, null, [J.mul(J.cl(_t688, null, [env["at"], 0.22, 1.4]), 2.5)])])
	var _t692 = env["__p"]["lines"]
	var _t695 = J.gp(v_top_536, "x")
	var _t696 = J.add(J.gp(v_top_536, "y"), J.mul(v_s_532, 0.12))
	var _t697 = J.mul(v_s_532, 0.3)
	var _t698 = ((-J.num(env["__p"]["PI"])) * 0.95)
	var _t699 = ((-J.num(env["__p"]["PI"])) * 0.05)
	var _t693 = env["__p"]["cl"]
	var _t694 = env["__p"]["bell"]
	J.cl(_t692, null, [v_ctx_530, _t695, _t696, _t697, 7.0, _t698, _t699, J.cl(_t693, null, [J.mul(J.cl(_t694, null, [env["at"], 0.25, 0.6]), 2.0)]), "#fff3c4", J.max_([1.0, J.mul(v_s_532, 0.012)])])
	v_i_542 = 0.0
	while true:
		if not J.cmp(v_i_542, 2.0, "<"): break
		var _t700 = env["__p"]["seg"]
		v_k_543 = J.cl(_t700, null, [env["at"], (0.35 + J.mul(v_i_542, 0.1)), (0.9 + J.mul(v_i_542, 0.1))])
		var _t701 = J.cmp(v_k_543, 0.0, ">")
		if (J.cmp(v_k_543, 1.0, "<") if _t701 else _t701):
			var _t702 = env["__p"]["drop"]
			J.cl(_t702, null, [v_ctx_530, (J.sub(J.gp(v_top_536, "x"), (J.mul(v_dir_533, v_s_532) * (0.25 + J.mul(v_i_542, 0.05)))) - (J.mul(J.mul(v_dir_533, v_k_543), v_s_532) * 0.12)), J.add(J.add(J.gp(v_top_536, "y"), J.mul(v_s_532, (0.2 + J.mul(v_i_542, 0.06)))), (J.mul(J.mul(v_k_543, v_k_543), v_s_532) * 0.2)), J.mul(v_s_532, 0.022), ((-J.num(v_dir_533)) * 0.6), J.sub(1.0, v_k_543)])
		v_i_542 = J.num(v_i_542) + 1.0
	var _t703 = J.gp(v_R_531, "G")
	var _t704 = env["__p"]["plantM"]
	var _t705 = J.mc(_t703, "multiply", [J.cl(_t704, null, [env["a"]])])
	v_g_538 = J.mc(_t705, "transformPoint", [J.construct(J.G.get("DOMPoint"), [J.mul(J.gp(J.gp(v_R_531, "axU"), 0.0), J.gp(v_R_531, "al")), J.mul(J.gp(J.gp(v_R_531, "axU"), 1.0), J.gp(v_R_531, "al"))])])
	var _t706 = env["__p"]["seg"]
	v_dk_539 = J.cl(_t706, null, [env["at"], 0.12, 0.6])
	var _t707 = J.cmp(v_dk_539, 0.0, ">")
	if (J.cmp(v_dk_539, 1.0, "<") if _t707 else _t707):
		for _t708 in J.iter([(-1.0), 1.0]):
			v_sd_544 = _t708
			var _t709 = env["__p"]["puff"]
			J.cl(_t709, null, [v_ctx_530, J.add(J.gp(v_g_538, "x"), (J.mul(v_sd_544, v_s_532) * (0.05 + J.mul(v_dk_539, 0.1)))), (J.sub(J.gp(v_g_538, "y"), J.mul(v_s_532, 0.02)) - (J.mul(v_dk_539, v_s_532) * 0.06)), J.mul(v_s_532, (0.04 + J.mul(v_dk_539, 0.07))), (J.sub(1.0, v_dk_539) * 0.85)])
	var _t710 = env["__p"]["seg"]
	v_lk_540 = J.cl(_t710, null, [env["at"], 0.72, 1.2])
	var _t711 = J.gp(v_R_531, "G")
	v_g0_541 = J.mc(_t711, "transformPoint", [J.construct(J.G.get("DOMPoint"), [0.0, 0.0])])
	var _t712 = J.cmp(v_lk_540, 0.0, ">")
	if (J.cmp(v_lk_540, 1.0, "<") if _t712 else _t712):
		for _t713 in J.iter([(-1.0), 1.0]):
			v_sd_545 = _t713
			var _t714 = env["__p"]["puff"]
			J.cl(_t714, null, [v_ctx_530, J.add(J.gp(v_g0_541, "x"), (J.mul(v_sd_545, v_s_532) * (0.12 + J.mul(v_lk_540, 0.1)))), J.sub(J.gp(v_g0_541, "y"), J.mul(v_s_532, 0.02)), J.mul(v_s_532, (0.04 + J.mul(v_lk_540, 0.05))), (J.sub(1.0, v_lk_540) * 0.7)])

func _f70(this_, a: Array, env):
	var v_L_526 = null; var v_SLEEP_527 = null; var v_P_528 = null; var v_sh_529 = null
	var _s125 = {"__p": env, "a": null, "at": null}
	_s125["a"] = J.arg(a, 0)
	_s125["at"] = J.arg(a, 1)
	v_L_526 = 2.4
	v_SLEEP_527 = J.S_Object_("assign", [{}, _s125["__p"]["PLANT"], {"head": (-0.28), "msy": (-0.025), "tail1": 0.12, "tail2": 0.2, "tie": (-0.12)}])
	var _t670 = _s125["__p"]["track"]
	v_P_528 = J.cl(_t670, null, [_s125["at"], [[0.0, v_SLEEP_527], [0.12, J.S_Object_("assign", [{}, v_SLEEP_527, {"head": (-0.3), "sy": (-0.07), "sx": 0.04}]), "o"], [0.36, {"th": 70.0, "hx": 0.02, "hy": 0.05, "lean": (-8.0), "dy": (-0.24), "sy": 0.1, "sx": (-0.06), "head": 0.2, "armB": (-0.6), "tie": 0.5, "tail1": (-0.3), "tail2": (-0.5)}, "o3"], [0.55, {"th": 60.0, "lean": (-4.0), "dy": (-0.2), "sy": 0.05, "sx": (-0.03), "head": 0.16, "armB": (-0.5), "tie": 0.4, "tail1": (-0.15), "tail2": (-0.3)}, "l"], [0.75, {"th": 10.0, "dy": 0.01, "sy": (-0.08), "sx": 0.06, "head": (-0.04), "armB": 0.1, "tie": (-0.2), "tail1": 0.2, "tail2": 0.35}, "i"], [0.95, {"th": 4.0, "head": 0.06, "sy": 0.01}, "o"], [1.25, {"th": 4.0, "head": (-0.17), "dx": 0.03, "lean": (-3.0), "armB": 0.1}, "io"], [1.65, {"th": 4.0, "head": 0.18, "lean": 4.0, "dx": (-0.01), "armB": (-0.1)}, "io"], [2.0, {"th": 0.0, "head": 0.0}, "io"], [v_L_526, {}, "io"]]])
	var _t671 = _s125["__p"]["bell"]
	v_sh_529 = J.cl(_t671, null, [_s125["at"], 0.4, 1.0])
	var _t672 = _s125["__p"]["S"]
	var _t673 = J.add(J.gp(v_P_528, "lean"), J.mul(J.mul(J.cl(_t672, null, [J.mul(_s125["at"], 50.0)]), 1.5), v_sh_529))
	J.sp(v_P_528, "lean", _t673)
	return {"P": v_P_528, "st": {"axe": "hand"}, "L": v_L_526, "fx": Callable(self, "_f71").bind(_s125)}

func _f72(this_, a: Array, env):
	return {"P": J.cl(env["Z"], null, []), "st": {"axe": "hand"}}

func _f77(this_, a: Array, env):
	var v_ctx_605 = null; var v_a_606 = null
	v_ctx_605 = J.arg(a, 0)
	v_a_606 = J.arg(a, 1)
	var _t721 = env["__p"]["drawAct"]
	return J.cl(_t721, null, [env["n"], v_ctx_605, v_a_606])

func _f1(this_, a: Array, env):
	var v_D_2 = null; var v_wpt_24 = null; var v_jitter_28 = null; var v_plantCache_44 = null; var v_update_60 = null; var v_tap_61 = null; var v_opts_62 = null
	var _s2 = {"__p": env, "S": null, "PI": null, "cl": null, "E": null, "ok": null, "LD": null, "WP": null, "AXE": null, "F": null, "Z": null, "lerpP": null, "addP": null, "track": null, "seg": null, "bell": null, "rest": null, "M": null, "ground": null, "solveRig": null, "RB": null, "meshPt": null, "render": null, "FIST": null, "drawPhoneInHand": null, "crayonText": null, "bubble": null, "say": null, "drop": null, "snot": null, "puff": null, "lines": null, "sparkle": null, "mouthO": null, "FACE": null, "fp": null, "MEM": null, "mem": null, "hash": null, "PLANT": null, "plantM": null, "ACT": null, "plantKeys": null, "plantFx": null, "BLEND": null, "drawAct": null, "renderBlendAxe": null, "stones": null, "drawStone": null, "LEN": null, "PICK": null, "COOL": null, "Q": null, "start": null, "stop": null}
	_s2["lerpP"] = Callable(self, "_f16").bind(_s2)
	_s2["addP"] = Callable(self, "_f17").bind(_s2)
	_s2["track"] = Callable(self, "_f18").bind(_s2)
	_s2["rest"] = Callable(self, "_f21").bind(_s2)
	_s2["ground"] = Callable(self, "_f23").bind(_s2)
	_s2["solveRig"] = Callable(self, "_f24").bind(_s2)
	_s2["meshPt"] = Callable(self, "_f25").bind(_s2)
	_s2["render"] = Callable(self, "_f28").bind(_s2)
	_s2["drawPhoneInHand"] = Callable(self, "_f33").bind(_s2)
	v_jitter_28 = Callable(self, "_f34").bind(_s2)
	_s2["crayonText"] = Callable(self, "_f36").bind(_s2)
	_s2["bubble"] = Callable(self, "_f37").bind(_s2)
	_s2["say"] = Callable(self, "_f38").bind(_s2)
	_s2["drop"] = Callable(self, "_f39").bind(_s2)
	_s2["snot"] = Callable(self, "_f40").bind(_s2)
	_s2["puff"] = Callable(self, "_f41").bind(_s2)
	_s2["lines"] = Callable(self, "_f42").bind(_s2)
	_s2["sparkle"] = Callable(self, "_f43").bind(_s2)
	_s2["mouthO"] = Callable(self, "_f44").bind(_s2)
	_s2["mem"] = Callable(self, "_f46").bind(_s2)
	_s2["plantM"] = Callable(self, "_f48").bind(_s2)
	_s2["plantKeys"] = Callable(self, "_f64").bind(_s2)
	_s2["plantFx"] = Callable(self, "_f67").bind(_s2)
	_s2["drawAct"] = Callable(self, "_f73").bind(_s2)
	_s2["renderBlendAxe"] = Callable(self, "_f74").bind(_s2)
	_s2["drawStone"] = Callable(self, "_f76").bind(_s2)
	_s2["start"] = Callable(self, "_f78").bind(_s2)
	_s2["stop"] = Callable(self, "_f79").bind(_s2)
	v_update_60 = Callable(self, "_f80").bind(_s2)
	v_tap_61 = Callable(self, "_f83").bind(_s2)
	v_opts_62 = Callable(self, "_f84").bind(_s2)
	v_D_2 = J.div(PI, 180.0)
	_s2["S"] = J.gp(J.G.get("Math"), "sin")
	_s2["PI"] = PI
	_s2["cl"] = Callable(self, "_f2").bind(_s2)
	_s2["E"] = {"l": Callable(self, "_f3").bind(_s2), "i": Callable(self, "_f4").bind(_s2), "o": Callable(self, "_f5").bind(_s2), "io": Callable(self, "_f6").bind(_s2), "o3": Callable(self, "_f7").bind(_s2), "i3": Callable(self, "_f8").bind(_s2), "back": Callable(self, "_f9").bind(_s2), "hold": Callable(self, "_f10").bind(_s2)}
	_s2["ok"] = Callable(self, "_f11").bind(_s2)
	_s2["LD"] = Callable(self, "_f12").bind(_s2)
	_s2["WP"] = Callable(self, "_f13").bind(_s2)
	_s2["AXE"] = Callable(self, "_f14").bind(_s2)
	_s2["F"] = ["dx", "dy", "lean", "sx", "sy", "th", "hx", "hy", "wr", "slide", "head", "armB", "tie", "tail1", "tail2", "mb", "bob", "msy"]
	_s2["Z"] = Callable(self, "_f15").bind(_s2)
	_s2["seg"] = Callable(self, "_f19").bind(_s2)
	_s2["bell"] = Callable(self, "_f20").bind(_s2)
	_s2["M"] = Callable(self, "_f22").bind(_s2)
	_s2["RB"] = null
	v_wpt_24 = Callable(self, "_f27").bind(_s2)
	_s2["FIST"] = [0.245, 0.505]
	_s2["FACE"] = {"mouth": [0.51, 0.378], "nose": [0.49, 0.352], "brow": [0.42, 0.235], "eyeL": [0.4, 0.305], "eyeR": [0.59, 0.29], "top": [0.47, 0.06], "cheek": [0.36, 0.34], "pocket": [0.6, 0.56], "chest": [0.5, 0.58]}
	_s2["fp"] = Callable(self, "_f45").bind(_s2)
	_s2["MEM"] = {}
	_s2["hash"] = Callable(self, "_f47").bind(_s2)
	_s2["PLANT"] = {"th": (-122.0), "lean": (-17.0), "dx": 0.1, "dy": 0.03, "sx": 0.03, "sy": (-0.04), "slide": 0.07, "wr": (-6.0), "bob": (-1.0), "head": (-0.1)}
	v_plantCache_44 = {}
	_s2["ACT"] = {}
	var _t312 = _s2["ACT"]
	var _t361 = Callable(self, "_f49").bind(_s2)
	J.sp(_t312, "walk", _t361)
	var _t362 = _s2["ACT"]
	var _t399 = Callable(self, "_f50").bind(_s2)
	J.sp(_t362, "yawn", _t399)
	var _t400 = _s2["ACT"]
	var _t428 = Callable(self, "_f52").bind(_s2)
	J.sp(_t400, "stretch", _t428)
	var _t429 = _s2["ACT"]
	var _t460 = Callable(self, "_f54").bind(_s2)
	J.sp(_t429, "scratch", _t460)
	var _t461 = _s2["ACT"]
	var _t500 = Callable(self, "_f56").bind(_s2)
	J.sp(_t461, "tap", _t500)
	var _t501 = _s2["ACT"]
	var _t527 = Callable(self, "_f58").bind(_s2)
	J.sp(_t501, "sweat", _t527)
	var _t528 = _s2["ACT"]
	var _t554 = Callable(self, "_f60").bind(_s2)
	J.sp(_t528, "dust", _t554)
	var _t555 = _s2["ACT"]
	var _t584 = Callable(self, "_f62").bind(_s2)
	J.sp(_t555, "proud", _t584)
	var _t585 = _s2["ACT"]
	var _t639 = Callable(self, "_f65").bind(_s2)
	J.sp(_t585, "phone", _t639)
	var _t640 = _s2["ACT"]
	var _t668 = Callable(self, "_f68").bind(_s2)
	J.sp(_t640, "doze", _t668)
	var _t669 = _s2["ACT"]
	var _t715 = Callable(self, "_f70").bind(_s2)
	J.sp(_t669, "wake", _t715)
	var _t716 = _s2["ACT"]
	var _t717 = Callable(self, "_f72").bind(_s2)
	J.sp(_t716, "idle", _t717)
	_s2["BLEND"] = 0.28
	_s2["stones"] = {}
	for _t718 in J.keys(_s2["ACT"]):
		var _s144 = {"__p": _s2, "n": null}
		_s144["n"] = _t718
		var _t719 = J.G.get("DAILY")
		var _t720 = J.add("hero_", _s144["n"])
		var _t722 = Callable(self, "_f77").bind(_s144)
		J.sp(_t719, _t720, _t722)
	_s2["LEN"] = {"yawn": 3.6, "stretch": 3.6, "scratch": 3.0, "tap": 3.4, "sweat": 2.8, "dust": 3.0, "proud": 2.2, "phone": 7.6, "wake": 2.4}
	_s2["PICK"] = [["yawn", 3.0], ["stretch", 2.0], ["phone", 2.2], ["scratch", 2.0], ["tap", 2.0], ["doze", 1.4]]
	_s2["COOL"] = {"yawn": 25.0, "stretch": 30.0, "phone": 35.0, "scratch": 22.0, "tap": 22.0, "doze": 50.0, "sweat": 10.0, "dust": 10.0}
	_s2["Q"] = {"cur": null, "at": 0.0, "idle": 0.0, "next": 4.0, "cool": {}, "last": null, "walkT": 0.0, "prevProud": 0.0, "hadAct": false, "lastKind": null, "dozeEnd": 0.0, "after": null}
	return {"update": v_update_60, "tap": v_tap_61, "opts": v_opts_62, "ACT": _s2["ACT"], "LEN": _s2["LEN"], "Q": _s2["Q"], "rest": _s2["rest"], "track": _s2["track"], "render": _s2["render"]}
