# 自動轉譯自 moves_spirit.js（tools/jsgd.js）——唔好直接改，改原 JS 再轉
extends RefCounted

func run(env):
	var this_ = null; var a = []
	J.cl(Callable(self, "_f1").bind(env), null, [])

func _f12(this_, a: Array, env):
	var v_o_74 = null; var v_p_75 = null
	v_o_74 = J.arg(a, 0)
	var _t1 = env["cl"]
	var _t2 = J.gp(v_o_74, "pt")
	v_p_75 = J.cl(_t1, null, [(_t2 if J.t(_t2) else 0.0)])
	var _t3 = J.gp(v_o_74, "pose")
	var _t4 = -1
	var _t5 = false
	if _t4 == -1 and J.seq(_t3, "windup"): _t4 = 0
	if _t4 == -1 and J.seq(_t3, "strike"): _t4 = 1
	if _t4 == -1 and J.seq(_t3, "follow"): _t4 = 2
	if _t4 == -1 and J.seq(_t3, "recover"): _t4 = 3
	while true:
		if _t4 <= 0 and _t4 >= 0:
			return J.mul(0.4, v_p_75)
		if _t4 <= 1 and _t4 >= 0:
			return (0.4 + J.mul(0.2, v_p_75))
		if _t4 <= 2 and _t4 >= 0:
			return 0.6
		if _t4 <= 3 and _t4 >= 0:
			return (0.6 + J.mul(0.4, v_p_75))
		break
	return 0.0

func _f13(this_, a: Array, env):
	var v_a_78 = null; var v_def_79 = null; var v_o_80 = null; var v_f_81 = null
	v_a_78 = J.arg(a, 0)
	v_def_79 = J.arg(a, 1)
	v_o_80 = J.gp(v_a_78, "o")
	v_f_81 = ((J.gp(v_o_80, "tdx") if J.t(J.gp(v_a_78, "faceRight")) else (-J.num(J.gp(v_o_80, "tdx")))) if (not J.leq(J.gp(v_o_80, "tdx"), null)) else J.mul(v_def_79, J.gp(v_a_78, "H")))
	var _t6 = J.max_([v_f_81, J.mul(J.gp(v_a_78, "H"), 0.3)])
	v_f_81 = _t6
	var _t8 = (-J.num(v_f_81))
	var _t7 = J.gp(v_o_80, "tdy")
	var _t10 = (_t7 if J.t(_t7) else 0.0)
	var _t9 = J.gp(v_a_78, "s")
	return {"x": _t8, "y": _t10, "h": J.mul(58.0, (_t9 if J.t(_t9) else J.div(J.gp(v_a_78, "H"), 60.0)))}

func _f23(this_, a: Array, env):
	var v_px_139 = null; var v_py_140 = null; var v_dx_141 = null; var v_dy_142 = null; var v_l_143 = null
	v_px_139 = J.arg(a, 0)
	v_py_140 = J.arg(a, 1)
	v_dx_141 = J.sub(v_px_139, env["cx"])
	v_dy_142 = J.sub(v_py_140, env["cy"])
	var _t23 = J.hypot_([v_dx_141, v_dy_142])
	v_l_143 = (_t23 if J.t(_t23) else 1.0)
	return [J.add(v_px_139, J.mul(J.div(v_dx_141, v_l_143), env["e"])), J.add(v_py_140, J.mul(J.div(v_dy_142, v_l_143), env["e"]))]

func _f22(this_, a: Array, env):
	var v_ctx_105 = null; var v_img_106 = null; var v_s0_107 = null; var v_s1_108 = null; var v_s2_109 = null; var v_d0_110 = null; var v_d1_111 = null; var v_d2_112 = null; var v_u0_113 = null; var v_v0_114 = null; var v_u1_115 = null; var v_v1_116 = null; var v_u2_117 = null; var v_v2_118 = null; var v_x0_119 = null; var v_y0_120 = null; var v_x1_121 = null; var v_y1_122 = null; var v_x2_123 = null; var v_y2_124 = null; var v_den_125 = null; var v_ex_129 = null; var v_A_130 = null; var v_B_131 = null; var v_C_132 = null; var v_m11_133 = null; var v_m12_134 = null; var v_m21_135 = null; var v_m22_136 = null; var v_dx_137 = null; var v_dy_138 = null
	var _s24 = {"__p": env, "cx": null, "cy": null, "e": null}
	v_ctx_105 = J.arg(a, 0)
	v_img_106 = J.arg(a, 1)
	v_s0_107 = J.arg(a, 2)
	v_s1_108 = J.arg(a, 3)
	v_s2_109 = J.arg(a, 4)
	v_d0_110 = J.arg(a, 5)
	v_d1_111 = J.arg(a, 6)
	v_d2_112 = J.arg(a, 7)
	var _t11 = J.gp(v_s0_107, 0.0)
	v_u0_113 = _t11
	var _t12 = J.gp(v_s0_107, 1.0)
	v_v0_114 = _t12
	var _t13 = J.gp(v_s1_108, 0.0)
	v_u1_115 = _t13
	var _t14 = J.gp(v_s1_108, 1.0)
	v_v1_116 = _t14
	var _t15 = J.gp(v_s2_109, 0.0)
	v_u2_117 = _t15
	var _t16 = J.gp(v_s2_109, 1.0)
	v_v2_118 = _t16
	var _t17 = J.gp(v_d0_110, 0.0)
	v_x0_119 = _t17
	var _t18 = J.gp(v_d0_110, 1.0)
	v_y0_120 = _t18
	var _t19 = J.gp(v_d1_111, 0.0)
	v_x1_121 = _t19
	var _t20 = J.gp(v_d1_111, 1.0)
	v_y1_122 = _t20
	var _t21 = J.gp(v_d2_112, 0.0)
	v_x2_123 = _t21
	var _t22 = J.gp(v_d2_112, 1.0)
	v_y2_124 = _t22
	v_den_125 = ((J.mul(v_u0_113, J.sub(v_v1_116, v_v2_118)) + J.mul(v_u1_115, J.sub(v_v2_118, v_v0_114))) + J.mul(v_u2_117, J.sub(v_v0_114, v_v1_116)))
	if (absf(J.num(v_den_125)) < 0.000001):
		return null
	_s24["cx"] = J.div(J.add(J.add(v_x0_119, v_x1_121), v_x2_123), 3.0)
	_s24["cy"] = J.div(J.add(J.add(v_y0_120, v_y1_122), v_y2_124), 3.0)
	_s24["e"] = 0.7
	v_ex_129 = Callable(self, "_f23").bind(_s24)
	v_A_130 = J.cl(v_ex_129, null, [v_x0_119, v_y0_120])
	v_B_131 = J.cl(v_ex_129, null, [v_x1_121, v_y1_122])
	v_C_132 = J.cl(v_ex_129, null, [v_x2_123, v_y2_124])
	J.mc(v_ctx_105, "save", [])
	J.mc(v_ctx_105, "beginPath", [])
	J.mc(v_ctx_105, "moveTo", [J.gp(v_A_130, 0.0), J.gp(v_A_130, 1.0)])
	J.mc(v_ctx_105, "lineTo", [J.gp(v_B_131, 0.0), J.gp(v_B_131, 1.0)])
	J.mc(v_ctx_105, "lineTo", [J.gp(v_C_132, 0.0), J.gp(v_C_132, 1.0)])
	J.mc(v_ctx_105, "closePath", [])
	J.mc(v_ctx_105, "clip", [])
	v_m11_133 = J.div(((J.mul(v_x0_119, J.sub(v_v1_116, v_v2_118)) + J.mul(v_x1_121, J.sub(v_v2_118, v_v0_114))) + J.mul(v_x2_123, J.sub(v_v0_114, v_v1_116))), v_den_125)
	v_m12_134 = J.div(((J.mul(v_y0_120, J.sub(v_v1_116, v_v2_118)) + J.mul(v_y1_122, J.sub(v_v2_118, v_v0_114))) + J.mul(v_y2_124, J.sub(v_v0_114, v_v1_116))), v_den_125)
	v_m21_135 = J.div(((J.mul(v_x0_119, J.sub(v_u2_117, v_u1_115)) + J.mul(v_x1_121, J.sub(v_u0_113, v_u2_117))) + J.mul(v_x2_123, J.sub(v_u1_115, v_u0_113))), v_den_125)
	v_m22_136 = J.div(((J.mul(v_y0_120, J.sub(v_u2_117, v_u1_115)) + J.mul(v_y1_122, J.sub(v_u0_113, v_u2_117))) + J.mul(v_y2_124, J.sub(v_u1_115, v_u0_113))), v_den_125)
	v_dx_137 = J.div(((J.mul(v_x0_119, (J.mul(v_u1_115, v_v2_118) - J.mul(v_u2_117, v_v1_116))) + J.mul(v_x1_121, (J.mul(v_u2_117, v_v0_114) - J.mul(v_u0_113, v_v2_118)))) + J.mul(v_x2_123, (J.mul(v_u0_113, v_v1_116) - J.mul(v_u1_115, v_v0_114)))), v_den_125)
	v_dy_138 = J.div(((J.mul(v_y0_120, (J.mul(v_u1_115, v_v2_118) - J.mul(v_u2_117, v_v1_116))) + J.mul(v_y1_122, (J.mul(v_u2_117, v_v0_114) - J.mul(v_u0_113, v_v2_118)))) + J.mul(v_y2_124, (J.mul(v_u0_113, v_v1_116) - J.mul(v_u1_115, v_v0_114)))), v_den_125)
	J.mc(v_ctx_105, "transform", [v_m11_133, v_m12_134, v_m21_135, v_m22_136, v_dx_137, v_dy_138])
	J.mc(v_ctx_105, "drawImage", [v_img_106, 0.0, 0.0])
	J.mc(v_ctx_105, "restore", [])

func _f24(this_, a: Array, env):
	var v_pts_146 = null; var v_n_147 = null; var v_L_148 = null; var v_tot_149 = null; var v_out_150 = null; var v_j_151 = null; var v_i_152 = null; var v_i_153 = null; var v_s_154 = null; var v_k_155 = null
	v_pts_146 = J.arg(a, 0)
	v_n_147 = J.arg(a, 1)
	v_L_148 = [0.0]
	v_i_152 = 1.0
	while true:
		if not J.cmp(v_i_152, J.len(v_pts_146), "<"): break
		J.mc(v_L_148, "push", [J.add(J.gp(v_L_148, J.sub(v_i_152, 1.0)), J.hypot_([J.sub(J.gp(J.gp(v_pts_146, v_i_152), 0.0), J.gp(J.gp(v_pts_146, J.sub(v_i_152, 1.0)), 0.0)), J.sub(J.gp(J.gp(v_pts_146, v_i_152), 1.0), J.gp(J.gp(v_pts_146, J.sub(v_i_152, 1.0)), 1.0))]))])
		v_i_152 = J.num(v_i_152) + 1.0
	var _t24 = J.gp(v_L_148, (J.len(v_L_148) - 1.0))
	v_tot_149 = (_t24 if J.t(_t24) else 1.0)
	v_out_150 = []
	v_j_151 = 0.0
	v_i_153 = 0.0
	while true:
		if not J.cmp(v_i_153, v_n_147, "<"): break
		v_s_154 = J.div(J.mul(v_tot_149, v_i_153), J.sub(v_n_147, 1.0))
		while true:
			var _t25 = J.cmp(v_j_151, (J.len(v_pts_146) - 2.0), "<")
			if not (J.cmp(J.gp(v_L_148, J.add(v_j_151, 1.0)), v_s_154, "<") if _t25 else _t25): break
			v_j_151 = J.num(v_j_151) + 1.0
		var _t27 = J.sub(v_s_154, J.gp(v_L_148, v_j_151))
		var _t26 = J.sub(J.gp(v_L_148, J.add(v_j_151, 1.0)), J.gp(v_L_148, v_j_151))
		v_k_155 = J.div(_t27, (_t26 if J.t(_t26) else 1.0))
		var _t28 = env["lerp"]
		var _t30 = J.cl(_t28, null, [J.gp(J.gp(v_pts_146, v_j_151), 0.0), J.gp(J.gp(v_pts_146, J.add(v_j_151, 1.0)), 0.0), v_k_155])
		var _t29 = env["lerp"]
		J.mc(v_out_150, "push", [[_t30, J.cl(_t29, null, [J.gp(J.gp(v_pts_146, v_j_151), 1.0), J.gp(J.gp(v_pts_146, J.add(v_j_151, 1.0)), 1.0), v_k_155])]])
		v_i_153 = J.num(v_i_153) + 1.0
	return {"pts": v_out_150, "len": v_tot_149}

func _f27(this_, a: Array, env):
	var v_ctx_166 = null; var v_img_167 = null; var v_src_168 = null; var v_sw_169 = null; var v_dst_170 = null; var v_wf_171 = null; var v_stretch_172 = null; var v_depth_173 = null; var v_S_174 = null; var v_SN_175 = null; var v_N_176 = null; var v_DN_177 = null; var v_acc_178 = null; var v_sp_179 = null; var v_a0_180 = null; var v_i_181 = null; var v_q_182 = null; var v_per_183 = null; var v_f_184 = null; var v_j_185 = null; var v_k_186 = null; var v_c_187 = null; var v_n_188 = null; var v_i_189 = null; var v_w0_190 = null; var v_w1_191 = null; var v_d_192 = null; var v_e_193 = null; var v_n0_194 = null; var v_n1_195 = null; var v_A_196 = null; var v_B_197 = null; var v_C_198 = null; var v_E_199 = null
	v_ctx_166 = J.arg(a, 0)
	v_img_167 = J.arg(a, 1)
	v_src_168 = J.arg(a, 2)
	v_sw_169 = J.arg(a, 3)
	v_dst_170 = J.arg(a, 4)
	v_wf_171 = J.arg(a, 5)
	v_stretch_172 = J.arg(a, 6)
	v_depth_173 = J.arg(a, 7)
	var _t31 = env["resample"]
	v_S_174 = J.cl(_t31, null, [v_src_168, 40.0])
	var _t32 = env["normals"]
	v_SN_175 = J.cl(_t32, null, [J.gp(v_S_174, "pts")])
	v_N_176 = J.len(v_dst_170)
	if J.cmp(v_N_176, 2.0, "<"):
		return null
	var _t33 = env["normals"]
	v_DN_177 = J.cl(_t33, null, [v_dst_170])
	v_acc_178 = 0.0
	v_sp_179 = []
	v_i_181 = 0.0
	while true:
		if not J.cmp(v_i_181, v_N_176, "<"): break
		if J.t(v_i_181):
			var _t34 = J.add(v_acc_178, J.hypot_([J.sub(J.gp(J.gp(v_dst_170, v_i_181), 0.0), J.gp(J.gp(v_dst_170, J.sub(v_i_181, 1.0)), 0.0)), J.sub(J.gp(J.gp(v_dst_170, v_i_181), 1.0), J.gp(J.gp(v_dst_170, J.sub(v_i_181, 1.0)), 1.0))]))
			v_acc_178 = _t34
		v_q_182 = J.div(v_acc_178, v_stretch_172)
		v_per_183 = J.gp(v_S_174, "len")
		var _t35 = J.mod(v_q_182, J.mul(2.0, v_per_183))
		v_q_182 = _t35
		if J.cmp(v_q_182, v_per_183, ">"):
			var _t36 = J.sub(J.mul(2.0, v_per_183), v_q_182)
			v_q_182 = _t36
		v_f_184 = (J.div(v_q_182, v_per_183) * (J.len(J.gp(v_S_174, "pts")) - 1.0))
		v_j_185 = J.min_([(J.len(J.gp(v_S_174, "pts")) - 2.0), floor(J.num(v_f_184))])
		v_k_186 = J.sub(v_f_184, v_j_185)
		var _t37 = env["lerp"]
		var _t39 = J.cl(_t37, null, [J.gp(J.gp(J.gp(v_S_174, "pts"), v_j_185), 0.0), J.gp(J.gp(J.gp(v_S_174, "pts"), J.add(v_j_185, 1.0)), 0.0), v_k_186])
		var _t38 = env["lerp"]
		v_c_187 = [_t39, J.cl(_t38, null, [J.gp(J.gp(J.gp(v_S_174, "pts"), v_j_185), 1.0), J.gp(J.gp(J.gp(v_S_174, "pts"), J.add(v_j_185, 1.0)), 1.0), v_k_186])]
		v_n_188 = J.gp(v_SN_175, v_j_185)
		J.mc(v_sp_179, "push", [[[J.add(J.gp(v_c_187, 0.0), J.mul(J.gp(v_n_188, 0.0), v_sw_169)), J.add(J.gp(v_c_187, 1.0), J.mul(J.gp(v_n_188, 1.0), v_sw_169))], [J.sub(J.gp(v_c_187, 0.0), J.mul(J.gp(v_n_188, 0.0), v_sw_169)), J.sub(J.gp(v_c_187, 1.0), J.mul(J.gp(v_n_188, 1.0), v_sw_169))]]])
		v_i_181 = J.num(v_i_181) + 1.0
	v_a0_180 = J.gp(v_ctx_166, "globalAlpha")
	v_i_189 = 0.0
	while true:
		if not J.cmp(v_i_189, J.sub(v_N_176, 1.0), "<"): break
		v_w0_190 = J.cl(v_wf_171, null, [v_i_189])
		v_w1_191 = J.cl(v_wf_171, null, [J.add(v_i_189, 1.0)])
		v_d_192 = J.gp(v_dst_170, v_i_189)
		v_e_193 = J.gp(v_dst_170, J.add(v_i_189, 1.0))
		v_n0_194 = J.gp(v_DN_177, v_i_189)
		v_n1_195 = J.gp(v_DN_177, J.add(v_i_189, 1.0))
		v_A_196 = [J.add(J.gp(v_d_192, 0.0), J.mul(J.gp(v_n0_194, 0.0), v_w0_190)), J.add(J.gp(v_d_192, 1.0), J.mul(J.gp(v_n0_194, 1.0), v_w0_190))]
		v_B_197 = [J.sub(J.gp(v_d_192, 0.0), J.mul(J.gp(v_n0_194, 0.0), v_w0_190)), J.sub(J.gp(v_d_192, 1.0), J.mul(J.gp(v_n0_194, 1.0), v_w0_190))]
		v_C_198 = [J.add(J.gp(v_e_193, 0.0), J.mul(J.gp(v_n1_195, 0.0), v_w1_191)), J.add(J.gp(v_e_193, 1.0), J.mul(J.gp(v_n1_195, 1.0), v_w1_191))]
		v_E_199 = [J.sub(J.gp(v_e_193, 0.0), J.mul(J.gp(v_n1_195, 0.0), v_w1_191)), J.sub(J.gp(v_e_193, 1.0), J.mul(J.gp(v_n1_195, 1.0), v_w1_191))]
		var _t40 = J.mul(v_a0_180, (J.cl(v_depth_173, null, [v_i_189]) if J.t(v_depth_173) else 1.0))
		J.sp(v_ctx_166, "globalAlpha", _t40)
		var _t41 = env["tri"]
		J.cl(_t41, null, [v_ctx_166, v_img_167, J.gp(J.gp(v_sp_179, v_i_189), 0.0), J.gp(J.gp(v_sp_179, v_i_189), 1.0), J.gp(J.gp(v_sp_179, J.add(v_i_189, 1.0)), 0.0), v_A_196, v_B_197, v_C_198])
		var _t42 = env["tri"]
		J.cl(_t42, null, [v_ctx_166, v_img_167, J.gp(J.gp(v_sp_179, v_i_189), 1.0), J.gp(J.gp(v_sp_179, J.add(v_i_189, 1.0)), 1.0), J.gp(J.gp(v_sp_179, J.add(v_i_189, 1.0)), 0.0), v_B_197, v_E_199, v_C_198])
		v_i_189 = J.num(v_i_189) + 1.0
	J.sp(v_ctx_166, "globalAlpha", v_a0_180)

func _f28(this_, a: Array, env):
	var v_ch_202 = null; var v_c1_203 = null; var v_c2_204 = null; var v_key_205 = null; var v_S_206 = null; var v_c_207 = null; var v_x_208 = null; var v_font_209 = null; var v_c2__210 = null; var v_y_211 = null; var v_g_212 = null; var v_i_213 = null; var v_r1_214 = null; var v_r2_215 = null; var v_r3_216 = null
	v_ch_202 = J.arg(a, 0)
	v_c1_203 = J.arg(a, 1)
	v_c2_204 = J.arg(a, 2)
	v_key_205 = J.add(J.add(v_ch_202, v_c1_203), v_c2_204)
	if J.t(J.gp(env["GLY"], v_key_205)):
		return J.gp(env["GLY"], v_key_205)
	v_S_206 = 168.0
	v_c_207 = J.S_document_("createElement", ["canvas"])
	J.sp(v_c_207, "height", v_S_206)
	J.sp(v_c_207, "width", v_S_206)
	v_x_208 = J.mc(v_c_207, "getContext", ["2d"])
	v_font_209 = "900 120px \"Noto Sans CJK TC\",\"Noto Sans TC\",\"PingFang TC\",\"Microsoft JhengHei\",\"Heiti TC\",sans-serif"
	J.sp(v_x_208, "font", v_font_209)
	J.sp(v_x_208, "textAlign", "center")
	J.sp(v_x_208, "textBaseline", "middle")
	J.sp(v_x_208, "lineJoin", "round")
	J.sp(v_x_208, "lineCap", "round")
	J.sp(v_x_208, "strokeStyle", "#2a120c")
	J.sp(v_x_208, "lineWidth", 24.0)
	J.mc(v_x_208, "strokeText", [v_ch_202, (J.div(v_S_206, 2.0) + 3.0), (J.div(v_S_206, 2.0) + 6.0)])
	J.sp(v_x_208, "lineWidth", 19.0)
	J.mc(v_x_208, "strokeText", [v_ch_202, (J.div(v_S_206, 2.0) - 1.0), (J.div(v_S_206, 2.0) + 2.0)])
	v_c2__210 = J.S_document_("createElement", ["canvas"])
	J.sp(v_c2__210, "height", v_S_206)
	J.sp(v_c2__210, "width", v_S_206)
	v_y_211 = J.mc(v_c2__210, "getContext", ["2d"])
	J.sp(v_y_211, "font", v_font_209)
	J.sp(v_y_211, "textAlign", "center")
	J.sp(v_y_211, "textBaseline", "middle")
	v_g_212 = J.mc(v_y_211, "createLinearGradient", [0.0, J.mul(v_S_206, 0.18), 0.0, J.mul(v_S_206, 0.85)])
	J.mc(v_g_212, "addColorStop", [0.0, v_c1_203])
	J.mc(v_g_212, "addColorStop", [1.0, v_c2_204])
	J.sp(v_y_211, "fillStyle", v_g_212)
	J.mc(v_y_211, "fillText", [v_ch_202, J.div(v_S_206, 2.0), (J.div(v_S_206, 2.0) + 2.0)])
	J.sp(v_y_211, "globalCompositeOperation", "source-atop")
	v_i_213 = 0.0
	while true:
		if not J.cmp(v_i_213, 1400.0, "<"): break
		var _t43 = env["rnd"]
		v_r1_214 = J.cl(_t43, null, [J.add(J.mul(v_i_213, 3.1), J.mc(v_ch_202, "charCodeAt", [0.0]))])
		var _t44 = env["rnd"]
		v_r2_215 = J.cl(_t44, null, [(J.mul(v_i_213, 7.7) + 1.0)])
		var _t45 = env["rnd"]
		v_r3_216 = J.cl(_t45, null, [(J.mul(v_i_213, 1.3) + 9.0)])
		var _t46 = ("rgba(255,248,215,.32)" if J.cmp(v_r3_216, 0.55, "<") else "rgba(110,20,0,.22)")
		J.sp(v_y_211, "fillStyle", _t46)
		J.mc(v_y_211, "save", [])
		J.mc(v_y_211, "translate", [J.mul(v_r1_214, v_S_206), J.mul(v_r2_215, v_S_206)])
		J.mc(v_y_211, "rotate", [(-0.5)])
		J.mc(v_y_211, "fillRect", [0.0, 0.0, (2.0 + J.mul(v_r3_216, 4.0)), 1.4])
		J.mc(v_y_211, "restore", [])
		v_i_213 = J.num(v_i_213) + 1.0
	J.sp(v_y_211, "fillStyle", "rgba(255,255,240,.28)")
	J.mc(v_y_211, "fillRect", [0.0, J.mul(v_S_206, 0.26), v_S_206, J.mul(v_S_206, 0.07)])
	J.mc(v_x_208, "drawImage", [v_c2__210, 0.0, 0.0])
	var _t47 = env["GLY"]
	J.sp(_t47, v_key_205, v_c_207)
	return v_c_207

func _f30(this_, a: Array, env):
	var _t49 = env["ctx"]
	var _t50 = J.mul(J.gp(_t49, "globalAlpha"), env["alpha"])
	J.sp(_t49, "globalAlpha", _t50)
	J.mc(env["ctx"], "rotate", [((sin(J.num(J.mul(env["t"], 23.0))) * 0.06) - 0.08)])
	var _t51 = env["ctx"]
	var _t52 = ("900 " + J.str(env["size"]) + "px \"Noto Sans CJK TC\",\"Noto Sans TC\",\"PingFang TC\",sans-serif")
	J.sp(_t51, "font", _t52)
	var _t53 = env["ctx"]
	J.sp(_t53, "textAlign", "center")
	var _t54 = env["ctx"]
	J.sp(_t54, "textBaseline", "middle")
	var _t55 = env["ctx"]
	J.sp(_t55, "lineJoin", "round")
	var _t56 = env["ctx"]
	J.sp(_t56, "strokeStyle", "#2a1a22")
	var _t57 = env["ctx"]
	var _t58 = J.mul(env["size"], 0.28)
	J.sp(_t57, "lineWidth", _t58)
	J.mc(env["ctx"], "strokeText", [env["txt"], 0.0, 0.0])
	var _t59 = env["ctx"]
	J.sp(_t59, "fillStyle", "#fff3e8")
	J.mc(env["ctx"], "fillText", [env["txt"], 0.0, 0.0])

func _f29(this_, a: Array, env):
	var v_a_220 = null; var v_x_221 = null; var v_y_222 = null
	var _s40 = {"__p": env, "ctx": null, "txt": null, "size": null, "alpha": null, "t": null}
	_s40["ctx"] = J.arg(a, 0)
	v_a_220 = J.arg(a, 1)
	v_x_221 = J.arg(a, 2)
	v_y_222 = J.arg(a, 3)
	_s40["txt"] = J.arg(a, 4)
	_s40["size"] = J.arg(a, 5)
	_s40["alpha"] = J.arg(a, 6)
	_s40["t"] = J.arg(a, 7)
	if J.cmp(_s40["alpha"], 0.0, "<="):
		return null
	var _t48 = _s40["__p"]["upright"]
	J.cl(_t48, null, [_s40["ctx"], v_a_220, v_x_221, v_y_222, Callable(self, "_f30").bind(_s40)])

func _f33(this_, a: Array, env):
	var v_p_235 = null; var v_i_236 = null
	v_p_235 = J.arg(a, 0)
	v_i_236 = J.arg(a, 1)
	return (J.mc(env["ctx"], "lineTo", [J.gp(v_p_235, 0.0), J.gp(v_p_235, 1.0)]) if J.t(v_i_236) else J.mc(env["ctx"], "moveTo", [J.gp(v_p_235, 0.0), J.gp(v_p_235, 1.0)]))

func _f32(this_, a: Array, env):
	J.mc(env["ctx"], "beginPath", [])
	J.mc(env["pts"], "forEach", [Callable(self, "_f33").bind(env)])

func _f31(this_, a: Array, env):
	var v_w_231 = null; var v_col_232 = null; var v_outline_233 = null; var v_path_234 = null
	var _s42 = {"__p": env, "ctx": null, "pts": null}
	_s42["ctx"] = J.arg(a, 0)
	_s42["pts"] = J.arg(a, 1)
	v_w_231 = J.arg(a, 2)
	v_col_232 = J.arg(a, 3)
	v_outline_233 = J.arg(a, 4)
	v_path_234 = Callable(self, "_f32").bind(_s42)
	var _t60 = _s42["ctx"]
	J.sp(_t60, "lineCap", "round")
	var _t61 = _s42["ctx"]
	J.sp(_t61, "lineJoin", "round")
	if J.t(v_outline_233):
		var _t62 = _s42["ctx"]
		J.sp(_t62, "strokeStyle", v_outline_233)
		var _t63 = _s42["ctx"]
		var _t64 = J.mul(v_w_231, 2.1)
		J.sp(_t63, "lineWidth", _t64)
		J.cl(v_path_234, null, [])
		J.mc(_s42["ctx"], "stroke", [])
	var _t65 = _s42["ctx"]
	J.sp(_t65, "strokeStyle", v_col_232)
	var _t66 = _s42["ctx"]
	J.sp(_t66, "lineWidth", v_w_231)
	J.cl(v_path_234, null, [])
	J.mc(_s42["ctx"], "stroke", [])

func _f35(this_, a: Array, env):
	var v_rr_249 = null; var v_ryy_250 = null; var v_i_251 = null; var v_an_252 = null; var v_j_253 = null; var v_px_254 = null; var v_py_255 = null
	v_rr_249 = J.arg(a, 0)
	v_ryy_250 = J.arg(a, 1)
	J.mc(env["ctx"], "beginPath", [])
	v_i_251 = 0.0
	while true:
		if not J.cmp(v_i_251, 40.0, "<="): break
		v_an_252 = (J.mul(J.div(v_i_251, 40.0), env["__p"]["PI"]) * 2.0)
		v_j_253 = ((1.0 + (0.07 * sin(J.num(J.add(J.mul(v_an_252, 5.0), env["seed"]))))) + (0.04 * sin(J.num(((J.mul(v_an_252, 11.0) + J.mul(env["seed"], 2.0)) + J.mul(env["t"], 3.0))))))
		v_px_254 = J.add(env["x"], J.mul(J.mul(cos(J.num(v_an_252)), v_rr_249), v_j_253))
		v_py_255 = J.add(env["y"], J.mul(J.mul(sin(J.num(v_an_252)), v_ryy_250), v_j_253))
		if J.t(v_i_251):
			J.mc(env["ctx"], "lineTo", [v_px_254, v_py_255])
		else:
			J.mc(env["ctx"], "moveTo", [v_px_254, v_py_255])
		v_i_251 = J.num(v_i_251) + 1.0
	J.mc(env["ctx"], "closePath", [])

func _f34(this_, a: Array, env):
	var v_r_242 = null; var v_k_243 = null; var v_ry_246 = null; var v_path_247 = null; var v_g_248 = null; var v_i_256 = null; var v_q_257 = null
	var _s46 = {"__p": env, "ctx": null, "x": null, "y": null, "t": null, "seed": null}
	_s46["ctx"] = J.arg(a, 0)
	_s46["x"] = J.arg(a, 1)
	_s46["y"] = J.arg(a, 2)
	v_r_242 = J.arg(a, 3)
	v_k_243 = J.arg(a, 4)
	_s46["t"] = J.arg(a, 5)
	_s46["seed"] = J.arg(a, 6)
	if J.cmp(v_r_242, 0.5, "<="):
		return null
	v_ry_246 = J.mul(v_r_242, 0.27)
	v_path_247 = Callable(self, "_f35").bind(_s46)
	J.mc(_s46["ctx"], "save", [])
	var _t67 = _s46["ctx"]
	var _t68 = J.mul(J.gp(_t67, "globalAlpha"), v_k_243)
	J.sp(_t67, "globalAlpha", _t68)
	J.cl(v_path_247, null, [J.mul(v_r_242, 1.06), J.mul(v_ry_246, 1.1)])
	var _t69 = _s46["ctx"]
	J.sp(_t69, "fillStyle", "rgba(12,22,28,.55)")
	J.mc(_s46["ctx"], "fill", [])
	J.cl(v_path_247, null, [v_r_242, v_ry_246])
	v_g_248 = J.mc(_s46["ctx"], "createRadialGradient", [_s46["x"], _s46["y"], 0.0, _s46["x"], _s46["y"], v_r_242])
	J.mc(v_g_248, "addColorStop", [0.0, "rgba(6,14,20,.97)"])
	J.mc(v_g_248, "addColorStop", [0.7, "rgba(14,34,44,.94)"])
	J.mc(v_g_248, "addColorStop", [1.0, "rgba(34,66,80,.88)"])
	var _t70 = _s46["ctx"]
	J.sp(_t70, "fillStyle", v_g_248)
	J.mc(_s46["ctx"], "fill", [])
	var _t71 = _s46["ctx"]
	J.sp(_t71, "strokeStyle", "rgba(130,190,205,.55)")
	var _t72 = _s46["ctx"]
	var _t73 = J.max_([1.0, J.mul(v_r_242, 0.035)])
	J.sp(_t72, "lineWidth", _t73)
	v_i_256 = 0.0
	while true:
		if not J.cmp(v_i_256, 2.0, "<"): break
		v_q_257 = J.mod((J.mul(_s46["t"], 0.9) + J.mul(v_i_256, 0.5)), 1.0)
		var _t74 = _s46["ctx"]
		var _t75 = (J.mul(v_k_243, J.sub(1.0, v_q_257)) * 0.8)
		J.sp(_t74, "globalAlpha", _t75)
		J.mc(_s46["ctx"], "beginPath", [])
		J.mc(_s46["ctx"], "ellipse", [_s46["x"], _s46["y"], J.mul(v_r_242, (0.25 + J.mul(0.7, v_q_257))), J.mul(v_ry_246, (0.25 + J.mul(0.7, v_q_257))), 0.0, 0.0, J.mul(_s46["__p"]["PI"], 2.0)])
		J.mc(_s46["ctx"], "stroke", [])
		v_i_256 = J.num(v_i_256) + 1.0
	var _t76 = _s46["ctx"]
	var _t77 = J.mul(v_k_243, 0.6)
	J.sp(_t76, "globalAlpha", _t77)
	var _t78 = _s46["ctx"]
	J.sp(_t78, "strokeStyle", "rgba(190,230,240,.5)")
	J.mc(_s46["ctx"], "beginPath", [])
	J.mc(_s46["ctx"], "ellipse", [J.sub(_s46["x"], J.mul(v_r_242, 0.25)), J.sub(_s46["y"], J.mul(v_ry_246, 0.35)), J.mul(v_r_242, 0.3), J.mul(v_ry_246, 0.18), 0.0, J.mul(_s46["__p"]["PI"], 1.1), J.mul(_s46["__p"]["PI"], 1.8)])
	J.mc(_s46["ctx"], "stroke", [])
	J.mc(_s46["ctx"], "restore", [])

func _f36(this_, a: Array, env):
	var v_ctx_260 = null; var v_x_261 = null; var v_y_262 = null; var v_size_263 = null; var v_q_264 = null; var v_n_265 = null; var v_seed_266 = null; var v_up_267 = null; var v_i_268 = null; var v_r1_269 = null; var v_r2_270 = null; var v_an_271 = null; var v_sp_272 = null; var v_px_273 = null; var v_py_274 = null; var v_rr_275 = null
	v_ctx_260 = J.arg(a, 0)
	v_x_261 = J.arg(a, 1)
	v_y_262 = J.arg(a, 2)
	v_size_263 = J.arg(a, 3)
	v_q_264 = J.arg(a, 4)
	v_n_265 = J.arg(a, 5)
	v_seed_266 = J.arg(a, 6)
	v_up_267 = J.arg(a, 7)
	var _t79 = J.cmp(v_q_264, 0.0, "<=")
	if (_t79 if _t79 else J.cmp(v_q_264, 1.0, ">=")):
		return null
	J.mc(v_ctx_260, "save", [])
	v_i_268 = 0.0
	while true:
		if not J.cmp(v_i_268, v_n_265, "<"): break
		var _t80 = env["rnd"]
		v_r1_269 = J.cl(_t80, null, [J.add(v_seed_266, J.mul(v_i_268, 1.7))])
		var _t81 = env["rnd"]
		v_r2_270 = J.cl(_t81, null, [J.add(v_seed_266, J.mul(v_i_268, 3.3))])
		v_an_271 = (J.div((-J.num(env["PI"])), 2.0) + (J.sub(v_r1_269, 0.5) * (2.0 if J.t(v_up_267) else 2.8)))
		v_sp_272 = J.mul(v_size_263, (0.6 + J.mul(v_r2_270, 0.9)))
		v_px_273 = J.add(v_x_261, J.mul(J.mul(cos(J.num(v_an_271)), v_sp_272), v_q_264))
		v_py_274 = J.add(J.add(v_y_262, J.mul(J.mul(J.mul(sin(J.num(v_an_271)), v_sp_272), v_q_264), (v_up_267 if J.t(v_up_267) else 1.0))), J.mul(J.mul(J.mul(v_size_263, 1.6), v_q_264), v_q_264))
		v_rr_275 = (J.mul(v_size_263, (0.018 + J.mul(v_r2_270, 0.02))) * (1.0 - J.mul(v_q_264, 0.4)))
		if J.cmp(v_py_274, J.add(v_y_262, J.mul(v_size_263, 0.03)), ">"):
			v_i_268 = J.num(v_i_268) + 1.0
			continue
		var _t82 = (J.sub(1.0, v_q_264) * 0.95)
		J.sp(v_ctx_260, "globalAlpha", _t82)
		J.sp(v_ctx_260, "fillStyle", "rgba(30,60,72,.9)")
		J.mc(v_ctx_260, "beginPath", [])
		J.mc(v_ctx_260, "ellipse", [v_px_273, v_py_274, J.mul(v_rr_275, 1.25), J.mul(v_rr_275, 1.7), J.add(v_an_271, J.div(env["PI"], 2.0)), 0.0, J.mul(env["PI"], 2.0)])
		J.mc(v_ctx_260, "fill", [])
		J.sp(v_ctx_260, "fillStyle", "rgba(160,215,230,.95)")
		J.mc(v_ctx_260, "beginPath", [])
		J.mc(v_ctx_260, "ellipse", [v_px_273, v_py_274, v_rr_275, J.mul(v_rr_275, 1.4), J.add(v_an_271, J.div(env["PI"], 2.0)), 0.0, J.mul(env["PI"], 2.0)])
		J.mc(v_ctx_260, "fill", [])
		J.sp(v_ctx_260, "fillStyle", "rgba(255,255,255,.9)")
		J.mc(v_ctx_260, "beginPath", [])
		J.mc(v_ctx_260, "arc", [J.sub(v_px_273, J.mul(v_rr_275, 0.3)), J.sub(v_py_274, J.mul(v_rr_275, 0.4)), J.mul(v_rr_275, 0.35), 0.0, J.mul(env["PI"], 2.0)])
		J.mc(v_ctx_260, "fill", [])
		v_i_268 = J.num(v_i_268) + 1.0
	J.mc(v_ctx_260, "restore", [])

func _f37(this_, a: Array, env):
	var v_ctx_278 = null; var v_x0_279 = null; var v_y0_280 = null; var v_x1_281 = null; var v_y1_282 = null; var v_w_283 = null; var v_dx_284 = null; var v_dy_285 = null; var v_l_286 = null; var v_nx_287 = null; var v_ny_288 = null; var v_mx_289 = null; var v_my_290 = null
	v_ctx_278 = J.arg(a, 0)
	v_x0_279 = J.arg(a, 1)
	v_y0_280 = J.arg(a, 2)
	v_x1_281 = J.arg(a, 3)
	v_y1_282 = J.arg(a, 4)
	v_w_283 = J.arg(a, 5)
	v_dx_284 = J.sub(v_x1_281, v_x0_279)
	v_dy_285 = J.sub(v_y1_282, v_y0_280)
	var _t83 = J.hypot_([v_dx_284, v_dy_285])
	v_l_286 = (_t83 if J.t(_t83) else 1.0)
	v_nx_287 = J.mul(J.div((-J.num(v_dy_285)), v_l_286), v_w_283)
	v_ny_288 = J.mul(J.div(v_dx_284, v_l_286), v_w_283)
	v_mx_289 = J.div(J.add(v_x0_279, v_x1_281), 2.0)
	v_my_290 = J.div(J.add(v_y0_280, v_y1_282), 2.0)
	J.mc(v_ctx_278, "beginPath", [])
	J.mc(v_ctx_278, "moveTo", [v_x0_279, v_y0_280])
	J.mc(v_ctx_278, "quadraticCurveTo", [J.add(v_mx_289, J.mul(v_nx_287, 2.0)), J.add(v_my_290, J.mul(v_ny_288, 2.0)), v_x1_281, v_y1_282])
	J.mc(v_ctx_278, "quadraticCurveTo", [J.sub(v_mx_289, J.mul(v_nx_287, 2.0)), J.sub(v_my_290, J.mul(v_ny_288, 2.0)), v_x0_279, v_y0_280])
	J.mc(v_ctx_278, "closePath", [])
	J.sp(v_ctx_278, "lineJoin", "round")
	J.sp(v_ctx_278, "strokeStyle", "rgba(120,10,30,.75)")
	var _t84 = J.mul(v_w_283, 0.9)
	J.sp(v_ctx_278, "lineWidth", _t84)
	J.mc(v_ctx_278, "stroke", [])
	J.sp(v_ctx_278, "fillStyle", "#fff4f2")
	J.mc(v_ctx_278, "fill", [])

func _f38(this_, a: Array, env):
	var v_ctx_293 = null; var v_x_294 = null; var v_y_295 = null; var v_size_296 = null; var v_q_297 = null; var v_seed_298 = null; var v_rad_299 = null; var v_py_300 = null; var v_rr_301 = null
	v_ctx_293 = J.arg(a, 0)
	v_x_294 = J.arg(a, 1)
	v_y_295 = J.arg(a, 2)
	v_size_296 = J.arg(a, 3)
	v_q_297 = J.arg(a, 4)
	v_seed_298 = J.arg(a, 5)
	v_rad_299 = J.arg(a, 6)
	var _t85 = J.cmp(v_q_297, 0.0, "<=")
	if (_t85 if _t85 else J.cmp(v_q_297, 1.0, ">=")):
		return null
	v_py_300 = J.add(v_y_295, J.mul(J.mul(J.mul(v_size_296, 1.4), v_q_297), v_q_297))
	v_rr_301 = (v_rad_299 if J.t(v_rad_299) else J.mul(v_size_296, 0.03))
	J.mc(v_ctx_293, "save", [])
	var _t86 = (1.0 - J.mul(v_q_297, 0.6))
	J.sp(v_ctx_293, "globalAlpha", _t86)
	J.sp(v_ctx_293, "fillStyle", "rgba(30,60,72,.9)")
	J.mc(v_ctx_293, "beginPath", [])
	J.mc(v_ctx_293, "ellipse", [v_x_294, v_py_300, J.mul(v_rr_301, 1.2), J.mul(v_rr_301, 1.8), 0.0, 0.0, J.mul(env["PI"], 2.0)])
	J.mc(v_ctx_293, "fill", [])
	J.sp(v_ctx_293, "fillStyle", "rgba(165,215,232,.95)")
	J.mc(v_ctx_293, "beginPath", [])
	J.mc(v_ctx_293, "ellipse", [v_x_294, v_py_300, J.mul(v_rr_301, 0.9), J.mul(v_rr_301, 1.4), 0.0, 0.0, J.mul(env["PI"], 2.0)])
	J.mc(v_ctx_293, "fill", [])
	J.mc(v_ctx_293, "restore", [])

func _f39(this_, a: Array, env):
	var v_ctx_304 = null; var v_x_305 = null; var v_y0_306 = null; var v_y1_307 = null; var v_w_308 = null; var v_n_309 = null; var v_alpha_310 = null; var v_seed_311 = null; var v_i_312 = null; var v_xx_313 = null; var v_a_314 = null; var v_b_315 = null
	v_ctx_304 = J.arg(a, 0)
	v_x_305 = J.arg(a, 1)
	v_y0_306 = J.arg(a, 2)
	v_y1_307 = J.arg(a, 3)
	v_w_308 = J.arg(a, 4)
	v_n_309 = J.arg(a, 5)
	v_alpha_310 = J.arg(a, 6)
	v_seed_311 = J.arg(a, 7)
	if J.cmp(v_alpha_310, 0.0, "<="):
		return null
	J.mc(v_ctx_304, "save", [])
	var _t87 = J.mul(J.gp(v_ctx_304, "globalAlpha"), v_alpha_310)
	J.sp(v_ctx_304, "globalAlpha", _t87)
	J.sp(v_ctx_304, "lineCap", "round")
	v_i_312 = 0.0
	while true:
		if not J.cmp(v_i_312, v_n_309, "<"): break
		var _t88 = env["rnd"]
		v_xx_313 = J.add(v_x_305, J.mul(J.sub(J.cl(_t88, null, [J.add(v_seed_311, v_i_312)]), 0.5), v_w_308))
		var _t90 = J.sub(v_y1_307, v_y0_306)
		var _t89 = env["rnd"]
		v_a_314 = J.add(v_y0_306, (J.mul(_t90, J.cl(_t89, null, [J.add(v_seed_311, J.mul(v_i_312, 2.3))])) * 0.3))
		var _t92 = J.sub(v_y1_307, v_y0_306)
		var _t91 = env["rnd"]
		v_b_315 = J.sub(v_y1_307, (J.mul(_t92, J.cl(_t91, null, [J.add(v_seed_311, J.mul(v_i_312, 5.1))])) * 0.3))
		J.sp(v_ctx_304, "strokeStyle", "rgba(40,24,40,.5)")
		J.sp(v_ctx_304, "lineWidth", 4.0)
		J.mc(v_ctx_304, "beginPath", [])
		J.mc(v_ctx_304, "moveTo", [v_xx_313, v_a_314])
		J.mc(v_ctx_304, "lineTo", [v_xx_313, v_b_315])
		J.mc(v_ctx_304, "stroke", [])
		J.sp(v_ctx_304, "strokeStyle", "rgba(255,246,230,.85)")
		J.sp(v_ctx_304, "lineWidth", 1.8)
		J.mc(v_ctx_304, "beginPath", [])
		J.mc(v_ctx_304, "moveTo", [v_xx_313, v_a_314])
		J.mc(v_ctx_304, "lineTo", [v_xx_313, v_b_315])
		J.mc(v_ctx_304, "stroke", [])
		v_i_312 = J.num(v_i_312) + 1.0
	J.mc(v_ctx_304, "restore", [])

func _f40(this_, a: Array, env):
	var v_ctx_318 = null; var v_x_319 = null; var v_y_320 = null; var v_size_321 = null; var v_q_322 = null; var v_n_323 = null; var v_seed_324 = null; var v_i_325 = null; var v_r1_326 = null; var v_r2_327 = null; var v_px_328 = null; var v_py_329 = null
	v_ctx_318 = J.arg(a, 0)
	v_x_319 = J.arg(a, 1)
	v_y_320 = J.arg(a, 2)
	v_size_321 = J.arg(a, 3)
	v_q_322 = J.arg(a, 4)
	v_n_323 = J.arg(a, 5)
	v_seed_324 = J.arg(a, 6)
	var _t93 = J.cmp(v_q_322, 0.0, "<=")
	if (_t93 if _t93 else J.cmp(v_q_322, 1.0, ">=")):
		return null
	J.mc(v_ctx_318, "save", [])
	v_i_325 = 0.0
	while true:
		if not J.cmp(v_i_325, v_n_323, "<"): break
		var _t94 = env["rnd"]
		v_r1_326 = J.cl(_t94, null, [J.add(v_seed_324, v_i_325)])
		var _t95 = env["rnd"]
		v_r2_327 = J.cl(_t95, null, [J.add(v_seed_324, J.mul(v_i_325, 2.7))])
		v_px_328 = J.add(v_x_319, J.mul(J.mul(J.sub(v_r1_326, 0.5), v_size_321), J.add(0.6, v_q_322)))
		v_py_329 = J.sub(J.add(v_y_320, J.mul(J.mul(J.mul(J.mul(v_size_321, 0.8), v_q_322), v_q_322), J.add(0.5, v_r2_327))), J.mul(J.mul(v_size_321, 0.15), v_q_322))
		var _t96 = (J.sub(1.0, v_q_322) * 0.8)
		J.sp(v_ctx_318, "globalAlpha", _t96)
		var _t97 = ("rgba(205,190,170,.9)" if J.t(J.mod(v_i_325, 3.0)) else "rgba(120,100,90,.9)")
		J.sp(v_ctx_318, "fillStyle", _t97)
		J.mc(v_ctx_318, "beginPath", [])
		J.mc(v_ctx_318, "arc", [v_px_328, v_py_329, J.mul(v_size_321, (0.012 + J.mul(v_r2_327, 0.02))), 0.0, J.mul(env["PI"], 2.0)])
		J.mc(v_ctx_318, "fill", [])
		v_i_325 = J.num(v_i_325) + 1.0
	J.mc(v_ctx_318, "restore", [])

func _f54(this_, a: Array, env):
	var v_ctx_504 = null; var v_type_505 = null; var v_key_506 = null; var v_H_507 = null; var v_t_508 = null; var v_add_509 = null
	v_ctx_504 = J.arg(a, 0)
	v_type_505 = J.arg(a, 1)
	v_key_506 = J.arg(a, 2)
	v_H_507 = J.arg(a, 3)
	v_t_508 = J.arg(a, 4)
	v_add_509 = J.arg(a, 5)
	var _t98 = env["pz"]
	J.mc(J.G.get("MeshAnim"), "drawBody", [v_ctx_504, v_type_505, v_key_506, v_H_507, J.cl(_t98, null, [v_t_508, J.S_Object_("assign", [{"armF": 0.0, "armB": 0.0, "y": 0.0}, v_add_509])])])

func _f55(this_, a: Array, env):
	var v_ctx_512 = null; var v_img_513 = null; var v_W_514 = null; var v_H_515 = null; var v_pv_516 = null; var v_at_517 = null; var v_ang_518 = null; var v_sx_519 = null
	v_ctx_512 = J.arg(a, 0)
	v_img_513 = J.arg(a, 1)
	v_W_514 = J.arg(a, 2)
	v_H_515 = J.arg(a, 3)
	v_pv_516 = J.arg(a, 4)
	v_at_517 = J.arg(a, 5)
	v_ang_518 = J.arg(a, 6)
	v_sx_519 = J.arg(a, 7)
	J.mc(v_ctx_512, "save", [])
	J.mc(v_ctx_512, "translate", [J.gp(v_at_517, 0.0), J.gp(v_at_517, 1.0)])
	J.mc(v_ctx_512, "rotate", [v_ang_518])
	if J.t(v_sx_519):
		J.mc(v_ctx_512, "scale", [v_sx_519, v_sx_519])
	J.mc(v_ctx_512, "drawImage", [v_img_513, J.mul((-J.num(J.gp(v_pv_516, 0.0))), v_W_514), J.mul((-J.num(J.gp(v_pv_516, 1.0))), v_H_515), v_W_514, v_H_515])
	J.mc(v_ctx_512, "restore", [])

func _f59(this_, a: Array, env):
	var v_ctx_534 = null; var v_x_535 = null; var v_y_536 = null; var v_vx_537 = null; var v_vy_538 = null; var v_size_539 = null; var v_q_540 = null; var v_n_541 = null; var v_seed_542 = null; var v_i_543 = null; var v_r1_544 = null; var v_r2_545 = null; var v_sp_546 = null; var v_sd_547 = null; var v_px_548 = null; var v_py_549 = null; var v_rr_550 = null; var v_an_551 = null
	v_ctx_534 = J.arg(a, 0)
	v_x_535 = J.arg(a, 1)
	v_y_536 = J.arg(a, 2)
	v_vx_537 = J.arg(a, 3)
	v_vy_538 = J.arg(a, 4)
	v_size_539 = J.arg(a, 5)
	v_q_540 = J.arg(a, 6)
	v_n_541 = J.arg(a, 7)
	v_seed_542 = J.arg(a, 8)
	var _t99 = J.cmp(v_q_540, 0.0, "<=")
	if (_t99 if _t99 else J.cmp(v_q_540, 1.0, ">=")):
		return null
	J.mc(v_ctx_534, "save", [])
	v_i_543 = 0.0
	while true:
		if not J.cmp(v_i_543, v_n_541, "<"): break
		var _t100 = env["rnd"]
		v_r1_544 = J.cl(_t100, null, [J.add(v_seed_542, J.mul(v_i_543, 1.9))])
		var _t101 = env["rnd"]
		v_r2_545 = J.cl(_t101, null, [J.add(v_seed_542, J.mul(v_i_543, 4.1))])
		v_sp_546 = (0.55 + J.mul(v_r1_544, 0.8))
		v_sd_547 = (J.sub(v_r2_545, 0.5) * 0.9)
		v_px_548 = J.add(v_x_535, J.mul(J.mul((J.mul(v_vx_537, v_sp_546) - J.mul(v_vy_538, v_sd_547)), v_size_539), v_q_540))
		v_py_549 = J.add(J.add(v_y_536, J.mul(J.mul((J.mul(v_vy_538, v_sp_546) + J.mul(v_vx_537, v_sd_547)), v_size_539), v_q_540)), J.mul(J.mul(J.mul(v_size_539, 1.3), v_q_540), v_q_540))
		v_rr_550 = (J.mul(v_size_539, (0.022 + J.mul(v_r2_545, 0.022))) * (1.0 - J.mul(v_q_540, 0.35)))
		var _t102 = J.min_([1.0, (J.sub(1.0, v_q_540) * 1.6)])
		J.sp(v_ctx_534, "globalAlpha", _t102)
		v_an_551 = atan2(J.num(J.add(v_vy_538, J.mul(2.6, v_q_540))), J.num(v_vx_537))
		J.sp(v_ctx_534, "fillStyle", "#4a2a10")
		J.mc(v_ctx_534, "beginPath", [])
		J.mc(v_ctx_534, "ellipse", [v_px_548, v_py_549, J.mul(v_rr_550, 1.7), J.mul(v_rr_550, 1.15), v_an_551, 0.0, J.mul(env["PI"], 2.0)])
		J.mc(v_ctx_534, "fill", [])
		J.sp(v_ctx_534, "fillStyle", "#c98a2e")
		J.mc(v_ctx_534, "beginPath", [])
		J.mc(v_ctx_534, "ellipse", [v_px_548, v_py_549, J.mul(v_rr_550, 1.35), J.mul(v_rr_550, 0.82), v_an_551, 0.0, J.mul(env["PI"], 2.0)])
		J.mc(v_ctx_534, "fill", [])
		J.sp(v_ctx_534, "fillStyle", "rgba(255,240,200,.9)")
		J.mc(v_ctx_534, "beginPath", [])
		J.mc(v_ctx_534, "arc", [J.sub(v_px_548, J.mul(v_rr_550, 0.3)), J.sub(v_py_549, J.mul(v_rr_550, 0.3)), J.mul(v_rr_550, 0.3), 0.0, J.mul(env["PI"], 2.0)])
		J.mc(v_ctx_534, "fill", [])
		v_i_543 = J.num(v_i_543) + 1.0
	J.mc(v_ctx_534, "restore", [])

func _f60(this_, a: Array, env):
	var v_ctx_554 = null; var v_x_555 = null; var v_y_556 = null; var v_size_557 = null; var v_q_558 = null; var v_seed_559 = null; var v_k_560 = null; var v_pts_561 = null; var v_i_562 = null; var v_u_563 = null
	v_ctx_554 = J.arg(a, 0)
	v_x_555 = J.arg(a, 1)
	v_y_556 = J.arg(a, 2)
	v_size_557 = J.arg(a, 3)
	v_q_558 = J.arg(a, 4)
	v_seed_559 = J.arg(a, 5)
	var _t103 = J.cmp(v_q_558, 0.0, "<=")
	if (_t103 if _t103 else J.cmp(v_q_558, 1.0, ">=")):
		return null
	J.mc(v_ctx_554, "save", [])
	var _t104 = J.mul(J.gp(v_ctx_554, "globalAlpha"), (J.sub(1.0, v_q_558) * 0.8))
	J.sp(v_ctx_554, "globalAlpha", _t104)
	v_k_560 = 0.0
	while true:
		if not J.cmp(v_k_560, 2.0, "<"): break
		v_pts_561 = []
		v_i_562 = 0.0
		while true:
			if not J.cmp(v_i_562, 10.0, "<="): break
			v_u_563 = J.div(v_i_562, 10.0)
			J.mc(v_pts_561, "push", [[J.add(J.add(v_x_555, (J.mul(sin(J.num(J.add(J.add(J.add(J.mul(v_u_563, 5.0), v_seed_559), J.mul(v_k_560, 2.0)), J.mul(v_q_558, 6.0)))), v_size_557) * 0.12)), (J.mul(J.sub(v_k_560, 0.5), v_size_557) * 0.16)), (J.sub(v_y_556, (J.mul(v_u_563, v_size_557) * (0.5 + J.mul(v_q_558, 0.6)))) - (J.mul(v_q_558, v_size_557) * 0.2))]])
			v_i_562 = J.num(v_i_562) + 1.0
		var _t105 = env["crayonLine"]
		J.cl(_t105, null, [v_ctx_554, v_pts_561, J.max_([1.5, J.mul(v_size_557, 0.05)]), "rgba(250,246,240,.9)", "rgba(60,50,60,.35)"])
		v_k_560 = J.num(v_k_560) + 1.0
	J.mc(v_ctx_554, "restore", [])

func _f62(this_, a: Array, env):
	var v_s_573 = null; var v_gr_574 = null
	var _t107 = env["__p"]["backOut"]
	v_s_573 = (0.6 + J.mul(0.55, J.cl(_t107, null, [J.min_([1.0, J.mul(env["k"], 1.8)])])))
	J.mc(env["ctx"], "scale", [v_s_573, v_s_573])
	J.mc(env["ctx"], "rotate", [env["rot"]])
	var _t108 = env["ctx"]
	var _t109 = J.mul(J.gp(_t108, "globalAlpha"), J.min_([1.0, (J.sub(1.0, env["k"]) * 4.0)]))
	J.sp(_t108, "globalAlpha", _t109)
	var _t110 = env["ctx"]
	var _t111 = ("900 " + J.str(env["size"]) + "px \"Noto Sans CJK TC\",\"Noto Sans TC\",\"PingFang TC\",\"Microsoft JhengHei\",sans-serif")
	J.sp(_t110, "font", _t111)
	var _t112 = env["ctx"]
	J.sp(_t112, "textAlign", "center")
	var _t113 = env["ctx"]
	J.sp(_t113, "textBaseline", "middle")
	var _t114 = env["ctx"]
	J.sp(_t114, "lineJoin", "round")
	var _t115 = env["ctx"]
	J.sp(_t115, "strokeStyle", "#2a1608")
	var _t116 = env["ctx"]
	var _t117 = J.mul(env["size"], 0.2)
	J.sp(_t116, "lineWidth", _t117)
	J.mc(env["ctx"], "strokeText", ["鏗！", 0.0, 0.0])
	v_gr_574 = J.mc(env["ctx"], "createLinearGradient", [0.0, ((-J.num(env["size"])) * 0.5), 0.0, J.mul(env["size"], 0.5)])
	J.mc(v_gr_574, "addColorStop", [0.0, "#fffbe6"])
	J.mc(v_gr_574, "addColorStop", [1.0, "#ffc93a"])
	var _t118 = env["ctx"]
	J.sp(_t118, "fillStyle", v_gr_574)
	J.mc(env["ctx"], "fillText", ["鏗！", 0.0, 0.0])

func _f61(this_, a: Array, env):
	var v_a_567 = null; var v_x_568 = null; var v_y_569 = null
	var _s118 = {"__p": env, "ctx": null, "size": null, "k": null, "rot": null}
	_s118["ctx"] = J.arg(a, 0)
	v_a_567 = J.arg(a, 1)
	v_x_568 = J.arg(a, 2)
	v_y_569 = J.arg(a, 3)
	_s118["size"] = J.arg(a, 4)
	_s118["k"] = J.arg(a, 5)
	_s118["rot"] = J.arg(a, 6)
	if J.cmp(_s118["k"], 0.0, "<="):
		return null
	var _t106 = _s118["__p"]["upright"]
	J.cl(_t106, null, [_s118["ctx"], v_a_567, v_x_568, v_y_569, Callable(self, "_f62").bind(_s118)])

func _f63(this_, a: Array, env):
	var v_ctx_577 = null; var v_x_578 = null; var v_y_579 = null; var v_r_580 = null; var v_k_581 = null; var v_seed_582 = null; var v_i_583 = null; var v_an_584 = null; var v_r0_585 = null; var v_r1_586 = null; var v_p_587 = null
	v_ctx_577 = J.arg(a, 0)
	v_x_578 = J.arg(a, 1)
	v_y_579 = J.arg(a, 2)
	v_r_580 = J.arg(a, 3)
	v_k_581 = J.arg(a, 4)
	v_seed_582 = J.arg(a, 5)
	var _t119 = J.cmp(v_k_581, 0.0, "<=")
	if (_t119 if _t119 else J.cmp(v_k_581, 1.0, ">=")):
		return null
	J.mc(v_ctx_577, "save", [])
	var _t120 = J.mul(J.gp(v_ctx_577, "globalAlpha"), J.sub(1.0, v_k_581))
	J.sp(v_ctx_577, "globalAlpha", _t120)
	J.sp(v_ctx_577, "lineCap", "round")
	v_i_583 = 0.0
	while true:
		if not J.cmp(v_i_583, 8.0, "<"): break
		v_an_584 = J.add((J.mul(J.div(v_i_583, 8.0), env["PI"]) * 2.0), v_seed_582)
		v_r0_585 = J.mul(v_r_580, (0.35 + J.mul(0.5, v_k_581)))
		v_r1_586 = (J.mul(v_r_580, (0.75 + J.mul(0.6, v_k_581))) * (0.75 if J.t(J.mod(v_i_583, 2.0)) else 1.0))
		v_p_587 = [[J.add(v_x_578, J.mul(cos(J.num(v_an_584)), v_r0_585)), J.add(v_y_579, J.mul(sin(J.num(v_an_584)), v_r0_585))], [J.add(v_x_578, J.mul(cos(J.num(v_an_584)), v_r1_586)), J.add(v_y_579, J.mul(sin(J.num(v_an_584)), v_r1_586))]]
		var _t121 = env["crayonLine"]
		J.cl(_t121, null, [v_ctx_577, v_p_587, J.max_([2.0, J.mul(v_r_580, 0.09)]), "#fff3c4", "rgba(60,30,10,.75)"])
		v_i_583 = J.num(v_i_583) + 1.0
	J.mc(v_ctx_577, "restore", [])

func _f67(this_, a: Array, env):
	var v_ctx_653 = null; var v_x_654 = null; var v_y_655 = null; var v_r_656 = null; var v_a_657 = null; var v_i_658 = null; var v_an_659 = null; var v_rr_660 = null
	v_ctx_653 = J.arg(a, 0)
	v_x_654 = J.arg(a, 1)
	v_y_655 = J.arg(a, 2)
	v_r_656 = J.arg(a, 3)
	v_a_657 = J.arg(a, 4)
	J.mc(v_ctx_653, "save", [])
	J.mc(v_ctx_653, "translate", [v_x_654, v_y_655])
	J.mc(v_ctx_653, "rotate", [v_a_657])
	J.mc(v_ctx_653, "beginPath", [])
	v_i_658 = 0.0
	while true:
		if not J.cmp(v_i_658, 10.0, "<"): break
		v_an_659 = (J.mul(J.div(v_i_658, 10.0), env["PI"]) * 2.0)
		v_rr_660 = (J.mul(v_r_656, 0.45) if J.t(J.mod(v_i_658, 2.0)) else v_r_656)
		J.mc(v_ctx_653, "lineTo", [J.mul(cos(J.num(v_an_659)), v_rr_660), J.mul(sin(J.num(v_an_659)), v_rr_660)])
		v_i_658 = J.num(v_i_658) + 1.0
	J.mc(v_ctx_653, "closePath", [])
	J.sp(v_ctx_653, "lineJoin", "round")
	J.sp(v_ctx_653, "strokeStyle", "#3a2410")
	var _t122 = J.mul(v_r_656, 0.35)
	J.sp(v_ctx_653, "lineWidth", _t122)
	J.mc(v_ctx_653, "stroke", [])
	J.sp(v_ctx_653, "fillStyle", "#ffd84a")
	J.mc(v_ctx_653, "fill", [])
	J.mc(v_ctx_653, "restore", [])

func _f2(this_, a: Array, env):
	var v_v_52 = null; var v_a_53 = null; var v_b_54 = null
	v_v_52 = J.arg(a, 0)
	var _t123 = J.arg(a, 1)
	if _t123 == null:
		_t123 = 0.0
	v_a_53 = _t123
	var _t124 = J.arg(a, 2)
	if _t124 == null:
		_t124 = 1.0
	v_b_54 = _t124
	return J.max_([v_a_53, J.min_([v_b_54, v_v_52])])

func _f3(this_, a: Array, env):
	var v_a_55 = null; var v_b_56 = null; var v_k_57 = null
	v_a_55 = J.arg(a, 0)
	v_b_56 = J.arg(a, 1)
	v_k_57 = J.arg(a, 2)
	return J.add(v_a_55, J.mul(J.sub(v_b_56, v_a_55), v_k_57))

func _f4(this_, a: Array, env):
	var v_t_58 = null
	v_t_58 = J.arg(a, 0)
	return (1.0 - (J.sub(1.0, v_t_58) * J.sub(1.0, v_t_58)))

func _f5(this_, a: Array, env):
	var v_t_59 = null
	v_t_59 = J.arg(a, 0)
	return J.mul(v_t_59, v_t_59)

func _f6(this_, a: Array, env):
	var v_t_60 = null
	v_t_60 = J.arg(a, 0)
	return (J.mul(J.mul(2.0, v_t_60), v_t_60) if J.cmp(v_t_60, 0.5, "<") else (1.0 - ((2.0 * J.sub(1.0, v_t_60)) * J.sub(1.0, v_t_60))))

func _f7(this_, a: Array, env):
	var v_t_61 = null
	v_t_61 = J.arg(a, 0)
	return (1.0 - pow(J.num(J.sub(1.0, v_t_61)), J.num(3.0)))

func _f8(this_, a: Array, env):
	var v_t_62 = null; var v_c_63 = null
	v_t_62 = J.arg(a, 0)
	v_c_63 = 1.7
	return ((1.0 + J.mul(J.add(v_c_63, 1.0), pow(J.num(J.sub(v_t_62, 1.0)), J.num(3.0)))) + J.mul(v_c_63, pow(J.num(J.sub(v_t_62, 1.0)), J.num(2.0))))

func _f9(this_, a: Array, env):
	var v_g_64 = null; var v_a_65 = null; var v_b_66 = null
	v_g_64 = J.arg(a, 0)
	v_a_65 = J.arg(a, 1)
	v_b_66 = J.arg(a, 2)
	var _t125 = env["cl"]
	return J.cl(_t125, null, [J.div(J.sub(v_g_64, v_a_65), J.sub(v_b_66, v_a_65))])

func _f10(this_, a: Array, env):
	var v_g_67 = null; var v_a_68 = null; var v_m_69 = null; var v_b_70 = null
	v_g_67 = J.arg(a, 0)
	v_a_68 = J.arg(a, 1)
	v_m_69 = J.arg(a, 2)
	v_b_70 = J.arg(a, 3)
	var _t126 = J.cmp(v_g_67, v_a_68, "<")
	var _t130 = null
	if (_t126 if _t126 else J.cmp(v_g_67, v_b_70, ">")):
		_t130 = 0.0
	else:
		var _t129 = null
		if J.cmp(v_g_67, v_m_69, "<"):
			var _t127 = env["eo"]
			_t129 = J.cl(_t127, null, [J.div(J.sub(v_g_67, v_a_68), J.sub(v_m_69, v_a_68))])
		else:
			var _t128 = env["eio"]
			_t129 = J.sub(1.0, J.cl(_t128, null, [J.div(J.sub(v_g_67, v_m_69), J.sub(v_b_70, v_m_69))]))
		_t130 = _t129
	return _t130

func _f11(this_, a: Array, env):
	var v_k_71 = null
	v_k_71 = J.arg(a, 0)
	var _t132 = J.seq(J.typeof_(J.G.get("sprOk")), "function")
	if J.t(_t132):
		var _t131 = J.G.get("sprOk")
		_t132 = J.cl(_t131, null, [v_k_71])
	return _t132

func _f14(this_, a: Array, env):
	var v_x_82 = null; var v_y_83 = null; var v_a_84 = null; var v_c_85 = null; var v_s_86 = null
	v_x_82 = J.arg(a, 0)
	v_y_83 = J.arg(a, 1)
	v_a_84 = J.arg(a, 2)
	v_c_85 = cos(J.num(v_a_84))
	v_s_86 = sin(J.num(v_a_84))
	return [(J.mul(v_x_82, v_c_85) - J.mul(v_y_83, v_s_86)), (J.mul(v_x_82, v_s_86) + J.mul(v_y_83, v_c_85))]

func _f15(this_, a: Array, env):
	var v_ctx_87 = null; var v_a_88 = null
	v_ctx_87 = J.arg(a, 0)
	v_a_88 = J.arg(a, 1)
	J.mc(v_ctx_87, "save", [])
	J.mc(v_ctx_87, "translate", [J.gp(v_a_88, "x"), J.gp(v_a_88, "y")])
	if J.t(J.gp(v_a_88, "faceRight")):
		J.mc(v_ctx_87, "scale", [(-1.0), 1.0])

func _f16(this_, a: Array, env):
	var v_a_89 = null; var v_x_90 = null; var v_y_91 = null
	v_a_89 = J.arg(a, 0)
	v_x_90 = J.arg(a, 1)
	v_y_91 = J.arg(a, 2)
	return [J.add(J.gp(v_a_89, "x"), ((-J.num(v_x_90)) if J.t(J.gp(v_a_89, "faceRight")) else v_x_90)), J.add(J.gp(v_a_89, "y"), v_y_91)]

func _f17(this_, a: Array, env):
	var v_a_92 = null
	v_a_92 = J.arg(a, 0)
	var _t136 = null
	if J.t(J.gp(v_a_92, "solid")):
		_t136 = 0.0
	else:
		var _t133 = J.gp(J.gp(v_a_92, "o"), "t")
		var _t135 = (-(3.0 + (sin(J.num(J.mul((_t133 if J.t(_t133) else 0.0), 2.4))) * 2.0)))
		var _t134 = J.gp(v_a_92, "s")
		_t136 = J.mul(_t135, (_t134 if J.t(_t134) else J.div(J.gp(v_a_92, "H"), 60.0)))
	return _t136

func _f18(this_, a: Array, env):
	var v_t_93 = null
	v_t_93 = J.arg(a, 0)
	var _t137 = J.gp(J.G.get("MeshAnim"), "ANIM")
	return J.mc(_t137, "idle", [(v_t_93 if J.t(v_t_93) else 0.0)])

func _f19(this_, a: Array, env):
	var v_t_94 = null; var v_add_95 = null
	v_t_94 = J.arg(a, 0)
	v_add_95 = J.arg(a, 1)
	var _t138 = env["base"]
	return J.S_Object_("assign", [J.cl(_t138, null, [v_t_94]), (v_add_95 if J.t(v_add_95) else {})])

func _f20(this_, a: Array, env):
	var v_ctx_96 = null; var v_a_97 = null; var v_x_98 = null; var v_y_99 = null; var v_fn_100 = null
	v_ctx_96 = J.arg(a, 0)
	v_a_97 = J.arg(a, 1)
	v_x_98 = J.arg(a, 2)
	v_y_99 = J.arg(a, 3)
	v_fn_100 = J.arg(a, 4)
	J.mc(v_ctx_96, "save", [])
	J.mc(v_ctx_96, "translate", [v_x_98, v_y_99])
	if J.t(J.gp(v_a_97, "faceRight")):
		J.mc(v_ctx_96, "scale", [(-1.0), 1.0])
	J.cl(v_fn_100, null, [])
	J.mc(v_ctx_96, "restore", [])

func _f21(this_, a: Array, env):
	var v_s_101 = null; var v_x_102 = null
	v_s_101 = J.arg(a, 0)
	v_x_102 = (sin(J.num((J.mul(v_s_101, 127.1) + 311.7))) * 43758.5453)
	return J.sub(v_x_102, floor(J.num(v_x_102)))

func _f26(this_, a: Array, env):
	var v_p_157 = null; var v_i_158 = null; var v_a_159 = null; var v_b_160 = null; var v_dx_161 = null; var v_dy_162 = null; var v_l_163 = null
	v_p_157 = J.arg(a, 0)
	v_i_158 = J.arg(a, 1)
	v_a_159 = J.gp(env["P"], J.max_([0.0, J.sub(v_i_158, 1.0)]))
	v_b_160 = J.gp(env["P"], J.min_([(J.len(env["P"]) - 1.0), J.add(v_i_158, 1.0)]))
	v_dx_161 = J.sub(J.gp(v_b_160, 0.0), J.gp(v_a_159, 0.0))
	v_dy_162 = J.sub(J.gp(v_b_160, 1.0), J.gp(v_a_159, 1.0))
	var _t139 = J.hypot_([v_dx_161, v_dy_162])
	v_l_163 = (_t139 if J.t(_t139) else 1.0)
	return [J.div((-J.num(v_dy_162)), v_l_163), J.div(v_dx_161, v_l_163)]

func _f25(this_, a: Array, env):
	var _s30 = {"__p": env, "P": null}
	_s30["P"] = J.arg(a, 0)
	return J.mc(_s30["P"], "map", [Callable(self, "_f26").bind(_s30)])

func _f42(this_, a: Array, env):
	var v_fx_361 = null; var v_fy_362 = null
	v_fx_361 = J.arg(a, 0)
	v_fy_362 = J.arg(a, 1)
	return [J.add(env["ox"], J.mul(J.sub(v_fx_361, 0.5), env["W"])), (J.sub(env["oy"], env["H"]) + J.mul(v_fy_362, env["H"]))]

func _f44(this_, a: Array, env):
	var v_p_388 = null; var v_i_389 = null
	v_p_388 = J.arg(a, 0)
	v_i_389 = J.arg(a, 1)
	var _t167 = null
	if J.cmp(v_i_389, J.len(env["app"]), "<"):
		var _t166 = J.cmp(J.gp(v_p_388, 0.0), J.add(J.gp(env["__p"]["C"], 0.0), J.mul(env["rx"], 0.2)), "<")
		_t167 = (0.4 if (J.cmp(J.gp(v_p_388, 1.0), J.sub(J.gp(env["__p"]["C"], 1.0), J.mul(env["__p"]["__p"]["Ht"], 1.0)), ">") if _t166 else _t166) else 1.0)
	else:
		_t167 = (1.0 if (sin(J.num(J.sub(env["__p"]["__p"]["__p"]["PI"], (J.mul(J.mul(J.div((J.sub(v_i_389, J.len(env["app"])) + 1.0), env["NT"]), J.gp(env["d"], "turns")), env["__p"]["__p"]["__p"]["PI"]) * 2.0)))) >= 0.0) else 0.4)
	return _t167

func _f45(this_, a: Array, env):
	var v_p_390 = null; var v_i_391 = null; var v_u_392 = null; var v_wv_393 = null
	v_p_390 = J.arg(a, 0)
	v_i_391 = J.arg(a, 1)
	if J.cmp(v_i_391, J.len(env["app"]), ">="):
		return v_p_390
	v_u_392 = J.div(v_i_391, J.len(env["app"]))
	v_wv_393 = (((J.mul(sin(J.num(J.add(((J.mul(v_u_392, env["__p"]["__p"]["__p"]["PI"]) * 2.2) - J.mul(env["__p"]["__p"]["t"], 14.0)), J.gp(env["d"], "ph")))), env["__p"]["__p"]["H"]) * 0.07) * (1.0 - J.mul(env["__p"]["__p"]["ext"], 0.85))) * sin(J.num(J.mul(v_u_392, env["__p"]["__p"]["__p"]["PI"]))))
	return [J.gp(v_p_390, 0.0), J.add(J.gp(v_p_390, 1.0), v_wv_393)]

func _f46(this_, a: Array, env):
	var v_x_394 = null; var v_y_395 = null
	var _t169 = J.gp(J.arg(a, 0), 0.0)
	v_x_394 = _t169
	var _t170 = J.gp(J.arg(a, 0), 1.0)
	v_y_395 = _t170
	return [J.mul(J.add(v_x_394, J.gp(env["d"], "sh")), env["__p"]["__p"]["iw"]), J.mul(v_y_395, env["__p"]["__p"]["ih"])]

func _f43(this_, a: Array, env):
	var v_k_367 = null; var v_r0_368 = null; var v_cy_369 = null; var v_ry_371 = null; var v_s0_372 = null; var v_c1_373 = null; var v_c2_374 = null; var v_wrap_376 = null; var v_full_378 = null; var v_dep_379 = null; var v_n_380 = null; var v_show_381 = null; var v_pts_382 = null; var v_i_383 = null; var v_u_384 = null; var v_v_385 = null; var v_i_386 = null; var v_an_387 = null
	var _s66 = {"__p": env, "d": null, "rx": null, "app": null, "NT": null}
	_s66["d"] = J.arg(a, 0)
	v_k_367 = J.arg(a, 1)
	var _t165 = _s66["__p"]["__p"]["P"]
	v_r0_368 = J.cl(_t165, null, [J.gp(J.gp(_s66["d"], "root"), 0.0), J.gp(J.gp(_s66["d"], "root"), 1.0)])
	v_cy_369 = J.sub(J.gp(_s66["__p"]["C"], 1.0), J.mul(_s66["__p"]["__p"]["Ht"], J.gp(_s66["d"], "h")))
	_s66["rx"] = J.mul(_s66["__p"]["rx0"], (1.0 - J.mul(v_k_367, 0.06)))
	v_ry_371 = J.mul(_s66["__p"]["__p"]["Ht"], 0.055)
	v_s0_372 = [J.sub(J.gp(_s66["__p"]["C"], 0.0), _s66["rx"]), v_cy_369]
	v_c1_373 = [J.sub(J.gp(v_r0_368, 0.0), J.mul(_s66["__p"]["__p"]["H"], 0.12)), J.sub(J.gp(v_r0_368, 1.0), J.mul(_s66["__p"]["__p"]["H"], (0.32 + J.mul(0.07, v_k_367))))]
	v_c2_374 = [J.sub(J.gp(_s66["__p"]["C"], 0.0), J.mul(_s66["rx"], 1.6)), J.sub(J.gp(_s66["__p"]["C"], 1.0), J.mul(_s66["__p"]["__p"]["Ht"], (1.15 + J.mul(0.05, v_k_367))))]
	_s66["app"] = []
	v_i_383 = 0.0
	while true:
		if not J.cmp(v_i_383, 26.0, "<="): break
		v_u_384 = J.div(v_i_383, 26.0)
		v_v_385 = J.sub(1.0, v_u_384)
		J.mc(_s66["app"], "push", [[(((J.mul(J.mul(J.mul(v_v_385, v_v_385), v_v_385), J.gp(v_r0_368, 0.0)) + J.mul(J.mul(J.mul(J.mul(3.0, v_u_384), v_v_385), v_v_385), J.gp(v_c1_373, 0.0))) + J.mul(J.mul(J.mul(J.mul(3.0, v_u_384), v_u_384), v_v_385), J.gp(v_c2_374, 0.0))) + J.mul(J.mul(J.mul(v_u_384, v_u_384), v_u_384), J.gp(v_s0_372, 0.0))), (((J.mul(J.mul(J.mul(v_v_385, v_v_385), v_v_385), J.gp(v_r0_368, 1.0)) + J.mul(J.mul(J.mul(J.mul(3.0, v_u_384), v_v_385), v_v_385), J.gp(v_c1_373, 1.0))) + J.mul(J.mul(J.mul(J.mul(3.0, v_u_384), v_u_384), v_v_385), J.gp(v_c2_374, 1.0))) + J.mul(J.mul(J.mul(v_u_384, v_u_384), v_u_384), J.gp(v_s0_372, 1.0)))]])
		v_i_383 = J.num(v_i_383) + 1.0
	v_wrap_376 = []
	_s66["NT"] = J.round(J.num(J.mul(28.0, J.gp(_s66["d"], "turns"))))
	v_i_386 = 1.0
	while true:
		if not J.cmp(v_i_386, _s66["NT"], "<="): break
		v_an_387 = J.sub(_s66["__p"]["__p"]["__p"]["PI"], (J.mul(J.mul(J.div(v_i_386, _s66["NT"]), J.gp(_s66["d"], "turns")), _s66["__p"]["__p"]["__p"]["PI"]) * 2.0))
		J.mc(v_wrap_376, "push", [[J.add(J.gp(_s66["__p"]["C"], 0.0), J.mul(_s66["rx"], cos(J.num(v_an_387)))), J.sub(J.add(v_cy_369, J.mul(v_ry_371, sin(J.num(v_an_387)))), (J.mul(_s66["__p"]["__p"]["Ht"], 0.06) * J.mul(J.div(v_i_386, _s66["NT"]), J.gp(_s66["d"], "turns"))))]])
		v_i_386 = J.num(v_i_386) + 1.0
	v_full_378 = J.mc(_s66["app"], "concat", [v_wrap_376])
	v_dep_379 = J.mc(v_full_378, "map", [Callable(self, "_f44").bind(_s66)])
	v_n_380 = J.len(v_full_378)
	v_show_381 = J.max_([2.0, J.round(J.num(J.mul(v_n_380, _s66["__p"]["__p"]["ext"])))])
	var _t168 = J.mc(v_full_378, "slice", [0.0, v_show_381])
	v_pts_382 = J.mc(_t168, "map", [Callable(self, "_f45").bind(_s66)])
	J.mc(_s66["__p"]["__p"]["strands"], "push", [{"pts": v_pts_382, "dep": v_dep_379, "w": J.mul(_s66["__p"]["__p"]["H"], J.gp(_s66["d"], "w")), "k": v_k_367, "src": J.mc(_s66["__p"]["__p"]["__p"]["PT_SRC"], "map", [Callable(self, "_f46").bind(_s66)])}])

func _f48(this_, a: Array, env):
	var v_i_401 = null; var v_u_402 = null
	v_i_401 = J.arg(a, 0)
	v_u_402 = J.div(J.add(env["from"], v_i_401), J.max_([1.0, J.sub(env["n"], 1.0)]))
	return (J.mul(J.gp(env["s"], "w"), (0.95 - J.mul(0.5, v_u_402))) * ((0.75 + J.mul(v_u_402, 5.0)) if J.cmp(v_u_402, 0.05, "<") else 1.0))

func _f49(this_, a: Array, env):
	var v_i_403 = null
	v_i_403 = J.arg(a, 0)
	return (J.gp(J.gp(env["s"], "dep"), J.add(env["from"], v_i_403)) if (not J.leq(J.gp(J.gp(env["s"], "dep"), J.add(env["from"], v_i_403)), null)) else 1.0)

func _f47(this_, a: Array, env):
	var v_to_398 = null; var v_seg__399 = null
	var _s74 = {"__p": env, "s": null, "from": null, "n": null}
	_s74["s"] = J.arg(a, 0)
	_s74["from"] = J.arg(a, 1)
	v_to_398 = J.arg(a, 2)
	var _t171 = J.gp(_s74["s"], "pts")
	v_seg__399 = J.mc(_t171, "slice", [_s74["from"], J.add(v_to_398, 1.0)])
	if (J.len(v_seg__399) < 2.0):
		return null
	_s74["n"] = J.len(J.gp(_s74["s"], "pts"))
	var _t172 = _s74["__p"]["__p"]["ribbon"]
	J.cl(_t172, null, [_s74["__p"]["ctx"], _s74["__p"]["img"], J.gp(_s74["s"], "src"), J.mul(_s74["__p"]["iw"], 0.06), v_seg__399, Callable(self, "_f48").bind(_s74), (J.div(_s74["__p"]["H"], _s74["__p"]["ih"]) * 1.3), Callable(self, "_f49").bind(_s74)])

func _f50(this_, a: Array, env):
	var v_s_404 = null
	v_s_404 = J.arg(a, 0)
	return J.min_([(J.len(J.gp(v_s_404, "pts")) - 1.0), 6.0])

func _f41(this_, a: Array, env):
	var v_a_333 = null; var v_o_334 = null; var v_g_337 = null; var v_F_338 = null; var v_rear_344 = null; var v_go_345 = null; var v_back_346 = null; var v_fwd_347 = null; var v_dx_348 = null; var v_dy_349 = null; var v_shake_350 = null; var v_pose_351 = null; var v_sq_356 = null; var v_drawStrand_358 = null; var v_split_359 = null; var v_sk_360 = null; var v_defs_365 = null; var v_s_405 = null; var v_s_406 = null; var v_m_407 = null; var v_i_408 = null; var v_q_409 = null; var v_r_410 = null; var v_pts_411 = null; var v_j_412 = null; var v_an_413 = null; var v_rr_414 = null
	var _s63 = {"__p": env, "ctx": null, "H": null, "t": null, "img": null, "W": null, "iw": null, "ih": null, "Ht": null, "ox": null, "oy": null, "P": null, "ext": null, "strands": null}
	_s63["ctx"] = J.arg(a, 0)
	v_a_333 = J.arg(a, 1)
	var _t141 = _s63["__p"]["ok"]
	var _t142 = (not J.t(J.cl(_t141, null, ["pontianak"])))
	if (_t142 if _t142 else (not J.t(J.gp(J.gp(J.G.get("MeshAnim"), "RIG"), "pontianak")))):
		return false
	v_o_334 = J.gp(v_a_333, "o")
	_s63["H"] = J.gp(v_a_333, "H")
	var _t143 = J.gp(v_o_334, "t")
	_s63["t"] = (_t143 if J.t(_t143) else 0.0)
	var _t144 = _s63["__p"]["prog"]
	v_g_337 = J.cl(_t144, null, [v_o_334])
	var _t145 = _s63["__p"]["foe"]
	v_F_338 = J.cl(_t145, null, [v_a_333, 0.68])
	_s63["img"] = J.gp(J.G.get("SPR"), "pontianak")
	_s63["W"] = J.div(J.mul(_s63["H"], J.gp(_s63["img"], "naturalWidth")), J.gp(_s63["img"], "naturalHeight"))
	_s63["iw"] = J.gp(_s63["img"], "naturalWidth")
	_s63["ih"] = J.gp(_s63["img"], "naturalHeight")
	_s63["Ht"] = J.gp(v_F_338, "h")
	var _t146 = _s63["__p"]["eio"]
	var _t147 = _s63["__p"]["seg"]
	v_rear_344 = J.cl(_t146, null, [J.cl(_t147, null, [v_g_337, 0.0, 0.34])])
	var _t148 = _s63["__p"]["eo3"]
	var _t149 = _s63["__p"]["seg"]
	v_go_345 = J.cl(_t148, null, [J.cl(_t149, null, [v_g_337, 0.32, _s63["__p"]["HIT"]])])
	var _t150 = _s63["__p"]["eio"]
	var _t151 = _s63["__p"]["seg"]
	v_back_346 = J.cl(_t150, null, [J.cl(_t151, null, [v_g_337, 0.66, 1.0])])
	v_fwd_347 = J.min_([J.mul(_s63["H"], 0.22), J.max_([0.0, ((-J.num(J.gp(v_F_338, "x"))) - J.mul(_s63["H"], 0.55))])])
	v_dx_348 = (((J.mul(J.mul(_s63["H"], 0.06), v_rear_344) * J.sub(1.0, v_go_345)) - J.mul(J.add(v_fwd_347, J.mul(_s63["H"], 0.04)), v_go_345)) * J.sub(1.0, v_back_346))
	var _t152 = _s63["__p"]["floatY"]
	v_dy_349 = J.sub(J.cl(_t152, null, [v_a_333]), (J.mul(_s63["H"], (J.mul(0.05, v_rear_344) + J.mul(0.04, v_go_345))) * J.sub(1.0, v_back_346)))
	var _t153 = J.cmp(v_g_337, 0.22, ">")
	v_shake_350 = ((J.mul(sin(J.num(J.mul(_s63["t"], 60.0))), _s63["H"]) * 0.006) if (J.cmp(v_g_337, 0.66, "<") if _t153 else _t153) else 0.0)
	var _t154 = _s63["__p"]["pz"]
	v_pose_351 = J.cl(_t154, null, [_s63["t"], {"body": ((J.mul(0.1, v_rear_344) - J.mul(0.16, v_go_345)) * J.sub(1.0, v_back_346)), "head": ((J.mul((-0.14), v_rear_344) - J.mul(0.06, v_go_345)) * J.sub(1.0, v_back_346)), "hairL": ((J.mul(0.35, v_rear_344) - J.mul(0.25, v_go_345)) * J.sub(1.0, v_back_346)), "hairR": ((J.mul((-0.3), v_rear_344) + J.mul(0.2, v_go_345)) * J.sub(1.0, v_back_346)), "armF": (J.mul(0.4, v_rear_344) * J.sub(1.0, v_back_346)), "armB": (J.mul((-0.4), v_rear_344) * J.sub(1.0, v_back_346)), "sy": ((1.0 + J.mul(0.04, v_rear_344)) - J.mul(0.03, v_go_345)), "sx": ((1.0 - J.mul(0.03, v_rear_344)) + J.mul(0.03, v_go_345))}])
	var _t155 = _s63["__p"]["world"]
	J.mc(v_a_333, "shadow", [J.gp(J.cl(_t155, null, [v_a_333, v_dx_348, 0.0]), 0.0), 0.8])
	var _t156 = _s63["__p"]["begin"]
	J.cl(_t156, null, [_s63["ctx"], v_a_333])
	_s63["ox"] = J.add(v_dx_348, v_shake_350)
	_s63["oy"] = v_dy_349
	_s63["P"] = Callable(self, "_f42").bind(_s63)
	var _t162 = null
	if J.cmp(v_g_337, _s63["__p"]["HIT"], "<"):
		var _t157 = _s63["__p"]["eo"]
		var _t158 = _s63["__p"]["seg"]
		_t162 = J.cl(_t157, null, [J.cl(_t158, null, [v_g_337, 0.37, _s63["__p"]["HIT"]])])
	else:
		var _t161 = null
		if J.cmp(v_g_337, 0.64, "<"):
			_t161 = 1.0
		else:
			var _t159 = _s63["__p"]["eio"]
			var _t160 = _s63["__p"]["seg"]
			_t161 = J.sub(1.0, J.cl(_t159, null, [J.cl(_t160, null, [v_g_337, 0.64, 0.92])]))
		_t162 = _t161
	_s63["ext"] = _t162
	var _t163 = _s63["__p"]["bump"]
	v_sq_356 = J.cl(_t163, null, [v_g_337, _s63["__p"]["HIT"], 0.52, 0.66])
	var _t164 = {"sq": v_sq_356, "shake": v_sq_356}
	J.sp(v_o_334, "vic", _t164)
	_s63["strands"] = []
	if J.cmp(_s63["ext"], 0.01, ">"):
		var _s65 = {"__p": _s63, "C": null, "rx0": null}
		_s65["C"] = [J.gp(v_F_338, "x"), J.gp(v_F_338, "y")]
		_s65["rx0"] = (J.mul(_s65["__p"]["Ht"], 0.2) * (1.0 - J.mul(0.2, v_sq_356)))
		v_defs_365 = [{"root": [0.27, 0.2], "h": 0.5, "turns": 1.25, "w": 0.075, "sh": 0.0, "ph": 0.0}, {"root": [0.24, 0.27], "h": 0.7, "turns": 1.1, "w": 0.068, "sh": (-0.025), "ph": 1.7}, {"root": [0.22, 0.34], "h": 0.33, "turns": 1.0, "w": 0.062, "sh": 0.02, "ph": 3.1}]
		J.mc(v_defs_365, "forEach", [Callable(self, "_f43").bind(_s65)])
	v_drawStrand_358 = Callable(self, "_f47").bind(_s63)
	v_split_359 = Callable(self, "_f50").bind(_s63)
	for _t173 in J.iter(_s63["strands"]):
		v_s_405 = _t173
		J.cl(v_drawStrand_358, null, [v_s_405, 0.0, J.cl(v_split_359, null, [v_s_405])])
	J.mc(_s63["ctx"], "save", [])
	J.mc(_s63["ctx"], "translate", [_s63["ox"], _s63["oy"]])
	J.mc(J.G.get("MeshAnim"), "drawBody", [_s63["ctx"], "pontianak", "pontianak", _s63["H"], v_pose_351])
	J.mc(_s63["ctx"], "restore", [])
	for _t174 in J.iter(_s63["strands"]):
		v_s_406 = _t174
		J.cl(v_drawStrand_358, null, [v_s_406, J.cl(v_split_359, null, [v_s_406]), (J.len(J.gp(v_s_406, "pts")) - 1.0)])
	var _t175 = _s63["__p"]["bump"]
	v_sk_360 = J.cl(_t175, null, [v_g_337, 0.2, 0.36, 0.7])
	if J.cmp(v_sk_360, 0.0, ">"):
		var _t176 = _s63["P"]
		v_m_407 = J.cl(_t176, null, [0.43, 0.29])
		v_i_408 = 0.0
		while true:
			if not J.cmp(v_i_408, 3.0, "<"): break
			v_q_409 = J.mod(((J.sub(v_g_337, 0.2) * 4.2) + J.div(v_i_408, 3.0)), 1.0)
			v_r_410 = J.mul(_s63["H"], (0.1 + J.mul(0.5, v_q_409)))
			v_pts_411 = []
			v_j_412 = 0.0
			while true:
				if not J.cmp(v_j_412, 16.0, "<="): break
				v_an_413 = J.add(_s63["__p"]["PI"], ((J.div(v_j_412, 16.0) - 0.5) * 1.5))
				v_rr_414 = J.mul(v_r_410, (1.0 + (0.012 * sin(J.num((J.mul(v_j_412, 1.3) + J.mul(_s63["t"], 40.0)))))))
				J.mc(v_pts_411, "push", [[J.add(J.gp(v_m_407, 0.0), J.mul(cos(J.num(v_an_413)), v_rr_414)), J.add(J.gp(v_m_407, 1.0), J.mul(sin(J.num(v_an_413)), v_rr_414))]])
				v_j_412 = J.num(v_j_412) + 1.0
			J.mc(_s63["ctx"], "save", [])
			var _t177 = _s63["ctx"]
			var _t178 = J.mul(J.gp(_t177, "globalAlpha"), J.mul(v_sk_360, J.min_([1.0, (J.sub(1.0, v_q_409) * 1.6)])))
			J.sp(_t177, "globalAlpha", _t178)
			var _t179 = _s63["__p"]["crayonLine"]
			J.cl(_t179, null, [_s63["ctx"], v_pts_411, J.max_([2.0, J.mul(_s63["H"], 0.024)]), "#f4f8ff", "rgba(40,24,70,.7)"])
			J.mc(_s63["ctx"], "restore", [])
			v_i_408 = J.num(v_i_408) + 1.0
	J.mc(_s63["ctx"], "restore", [])
	var _t180 = J.cmp(v_g_337, _s63["__p"]["HIT"], ">=")
	if (J.cmp(v_g_337, J.add(_s63["__p"]["HIT"], 0.02), "<") if _t180 else _t180):
		var _t181 = _s63["__p"]["world"]
		var _t182 = J.cl(_t181, null, [v_a_333, J.add(J.gp(v_F_338, "x"), J.mul(_s63["Ht"], 0.1)), J.sub(J.gp(v_F_338, "y"), J.mul(_s63["Ht"], 0.6))])
		J.sp(v_o_334, "hitP", _t182)
	return true

func _f52(this_, a: Array, env):
	var v_p_464 = null; var v_i_465 = null
	v_p_464 = J.arg(a, 0)
	v_i_465 = J.arg(a, 1)
	return (J.mc(env["ctx"], "lineTo", [J.gp(v_p_464, 0.0), J.gp(v_p_464, 1.0)]) if J.t(v_i_465) else J.mc(env["ctx"], "moveTo", [J.gp(v_p_464, 0.0), J.gp(v_p_464, 1.0)]))

func _f51(this_, a: Array, env):
	var v_a_418 = null; var v_o_419 = null; var v_H_420 = null; var v_t_421 = null; var v_g_422 = null; var v_F_423 = null; var v_img_424 = null; var v_W_425 = null; var v_Ht_426 = null; var v_sink_427 = null; var v_myP_428 = null; var v_tp_429 = null; var v_rise_430 = null; var v_pull_431 = null; var v_tx_432 = null; var v_ty_433 = null; var v_rP_434 = null; var v_dy_435 = null; var v_lean_436 = null; var v_i_437 = null; var v_yy_438 = null; var v_arm_439 = null; var v_k_440 = null; var v_PVx_441 = null; var v_PVy_442 = null; var v_len_443 = null; var v_up_444 = null; var v_ang_445 = null; var v_reachY_446 = null; var v_px_447 = null; var v_py_448 = null; var v_ux_449 = null; var v_uy_450 = null; var v_s0_451 = null; var v_s1_452 = null; var v_nx_453 = null; var v_ny_454 = null; var v_pts_455 = null; var v_i_456 = null; var v_q_457 = null; var v_sp_458 = null; var v_w_459 = null; var v_i_460 = null; var v_q_461 = null; var v_sp_462 = null; var v_w_463 = null; var v_i_466 = null
	var _s85 = {"__p": env, "ctx": null}
	_s85["ctx"] = J.arg(a, 0)
	v_a_418 = J.arg(a, 1)
	var _t185 = _s85["__p"]["ok"]
	var _t187 = (not J.t(J.cl(_t185, null, ["shuigui"])))
	if not J.t(_t187):
		var _t186 = _s85["__p"]["ok"]
		_t187 = (not J.t(J.cl(_t186, null, ["shuigui__arm"])))
	if _t187:
		return false
	v_o_419 = J.gp(v_a_418, "o")
	v_H_420 = J.gp(v_a_418, "H")
	var _t188 = J.gp(v_o_419, "t")
	v_t_421 = (_t188 if J.t(_t188) else 0.0)
	var _t189 = _s85["__p"]["prog"]
	v_g_422 = J.cl(_t189, null, [v_o_419])
	var _t190 = _s85["__p"]["foe"]
	v_F_423 = J.cl(_t190, null, [v_a_418, 0.68])
	v_img_424 = J.gp(J.G.get("SPR"), "shuigui")
	v_W_425 = J.div(J.mul(v_H_420, J.gp(v_img_424, "naturalWidth")), J.gp(v_img_424, "naturalHeight"))
	v_Ht_426 = J.gp(v_F_423, "h")
	var _t195 = null
	if J.cmp(v_g_422, 0.6, "<"):
		var _t191 = _s85["__p"]["eio"]
		var _t192 = _s85["__p"]["seg"]
		_t195 = J.cl(_t191, null, [J.cl(_t192, null, [v_g_422, 0.04, 0.34])])
	else:
		var _t193 = _s85["__p"]["eo3"]
		var _t194 = _s85["__p"]["seg"]
		_t195 = J.sub(1.0, J.cl(_t193, null, [J.cl(_t194, null, [v_g_422, 0.74, 0.98])]))
	v_sink_427 = _t195
	var _t196 = _s85["__p"]["bump"]
	var _t199 = J.cl(_t196, null, [v_g_422, 0.0, 0.12, 1.0])
	var _t198 = null
	if J.cmp(v_g_422, 0.9, ">"):
		var _t197 = _s85["__p"]["seg"]
		_t198 = J.sub(1.0, J.cl(_t197, null, [v_g_422, 0.9, 1.0]))
	else:
		_t198 = 1.0
	v_myP_428 = J.mul(_t199, _t198)
	var _t204 = null
	if J.cmp(v_g_422, 0.7, "<"):
		var _t200 = _s85["__p"]["eo"]
		var _t201 = _s85["__p"]["seg"]
		_t204 = J.cl(_t200, null, [J.cl(_t201, null, [v_g_422, 0.16, 0.42])])
	else:
		var _t202 = _s85["__p"]["eio"]
		var _t203 = _s85["__p"]["seg"]
		_t204 = J.sub(1.0, J.cl(_t202, null, [J.cl(_t203, null, [v_g_422, 0.72, 0.96])]))
	v_tp_429 = _t204
	var _t207 = null
	if J.cmp(v_g_422, _s85["__p"]["HIT"], "<"):
		var _t205 = _s85["__p"]["backOut"]
		var _t206 = _s85["__p"]["seg"]
		_t207 = J.cl(_t205, null, [J.cl(_t206, null, [v_g_422, 0.4, _s85["__p"]["HIT"]])])
	else:
		_t207 = 1.0
	v_rise_430 = _t207
	var _t208 = _s85["__p"]["eio"]
	var _t209 = _s85["__p"]["seg"]
	v_pull_431 = J.cl(_t208, null, [J.cl(_t209, null, [v_g_422, 0.53, 0.76])])
	var _t210 = _s85["__p"]["seg"]
	var _t212 = (J.mul(v_pull_431, J.sub(1.0, J.cl(_t210, null, [v_g_422, 0.8, 0.98]))) * 0.32)
	var _t211 = _s85["__p"]["bump"]
	var _t213 = {"sink": _t212, "shake": J.cl(_t211, null, [v_g_422, _s85["__p"]["HIT"], 0.5, 0.62])}
	J.sp(v_o_419, "vic", _t213)
	if J.cmp(v_sink_427, 0.95, "<"):
		J.mc(v_a_418, "shadow", [J.gp(v_a_418, "x"), (0.8 * J.sub(1.0, v_sink_427))])
	var _t214 = _s85["__p"]["begin"]
	J.cl(_t214, null, [_s85["ctx"], v_a_418])
	var _t215 = _s85["__p"]["puddle"]
	var _t219 = _s85["ctx"]
	var _t218 = J.mul(v_H_420, 0.27)
	var _t216 = _s85["__p"]["eo"]
	var _t217 = _s85["__p"]["cl"]
	J.cl(_t215, null, [_t219, 0.0, 0.0, J.mul(_t218, J.cl(_t216, null, [J.cl(_t217, null, [J.mul(v_myP_428, 1.6)])])), 1.0, v_t_421, 1.3])
	if J.cmp(v_sink_427, 0.995, "<"):
		J.mc(_s85["ctx"], "save", [])
		J.mc(_s85["ctx"], "beginPath", [])
		J.mc(_s85["ctx"], "rect", [((-J.num(v_H_420)) * 3.0), ((-J.num(v_H_420)) * 4.0), J.mul(v_H_420, 6.0), (J.mul(v_H_420, 4.0) + J.mul(v_H_420, 0.01))])
		J.mc(_s85["ctx"], "clip", [])
		var _t220 = _s85["__p"]["floatY"]
		v_dy_435 = (J.mul(J.cl(_t220, null, [v_a_418]), J.sub(1.0, v_sink_427)) + (J.mul(v_sink_427, v_H_420) * 1.02))
		v_lean_436 = (J.mul(0.12, v_sink_427) if J.cmp(v_g_422, 0.6, "<") else J.mul((-0.1), v_sink_427))
		J.mc(_s85["ctx"], "translate", [0.0, v_dy_435])
		J.mc(_s85["ctx"], "scale", [(-1.0), 1.0])
		var _t222 = _s85["ctx"]
		var _t221 = _s85["__p"]["pz"]
		J.mc(J.G.get("MeshAnim"), "drawBody", [_t222, "shuigui", "shuigui", v_H_420, J.cl(_t221, null, [v_t_421, {"body": v_lean_436, "head": J.mul((-0.1), v_sink_427), "armB": J.mul((-0.5), v_sink_427), "armF": J.mul(0.4, v_sink_427), "hairL": J.mul(0.3, v_sink_427), "hairR": J.mul((-0.3), v_sink_427), "sy": (1.0 + J.mul(0.06, v_sink_427)), "sx": (1.0 - J.mul(0.04, v_sink_427))}])])
		J.mc(_s85["ctx"], "restore", [])
		if J.cmp(v_g_422, 0.74, ">"):
			v_i_437 = 0.0
			while true:
				if not J.cmp(v_i_437, 6.0, "<"): break
				var _t224 = (-J.num(v_H_420))
				var _t223 = _s85["__p"]["rnd"]
				v_yy_438 = ((_t224 * (0.25 + J.mul(J.cl(_t223, null, [J.mul(v_i_437, 2.1)]), 0.5))) * J.sub(1.0, v_sink_427))
				var _t225 = _s85["__p"]["drip"]
				var _t227 = _s85["ctx"]
				var _t226 = _s85["__p"]["rnd"]
				var _t230 = (J.mul(J.sub(J.cl(_t226, null, [J.add(v_i_437, 3.0)]), 0.5), v_W_425) * 0.6)
				var _t231 = J.div((-J.num(v_yy_438)), 1.4)
				var _t229 = (J.sub(v_g_422, 0.74) * 4.0)
				var _t228 = _s85["__p"]["rnd"]
				J.cl(_t225, null, [_t227, _t230, v_yy_438, _t231, J.mod(J.add(_t229, J.cl(_t228, null, [J.mul(v_i_437, 5.3)])), 1.0), v_i_437, J.mul(v_H_420, 0.016)])
				v_i_437 = J.num(v_i_437) + 1.0
	var _t232 = _s85["__p"]["splash"]
	var _t234 = _s85["ctx"]
	var _t235 = J.mul(v_H_420, 0.5)
	var _t233 = _s85["__p"]["seg"]
	J.cl(_t232, null, [_t234, 0.0, 0.0, _t235, J.cl(_t233, null, [v_g_422, 0.2, 0.42]), 7.0, 2.2])
	v_tx_432 = J.gp(v_F_423, "x")
	v_ty_433 = J.gp(v_F_423, "y")
	v_rP_434 = J.mul(J.mul(v_Ht_426, 0.4), v_tp_429)
	var _t236 = _s85["__p"]["puddle"]
	J.cl(_t236, null, [_s85["ctx"], v_tx_432, J.add(v_ty_433, J.mul(v_Ht_426, 0.01)), v_rP_434, 1.0, v_t_421, 4.1])
	var _t237 = J.cmp(v_g_422, 0.36, ">")
	if (J.cmp(v_g_422, 0.86, "<") if _t237 else _t237):
		v_arm_439 = J.gp(J.G.get("SPR"), "shuigui__arm")
		v_k_440 = 2.1
		v_PVx_441 = 0.72
		v_PVy_442 = 0.53
		v_len_443 = J.mul(J.mul(J.sub(0.95, v_PVx_441), v_W_425), v_k_440)
		v_up_444 = J.mul(v_rise_430, (1.0 - J.mul(v_pull_431, 0.85)))
		var _t238 = _s85["__p"]["cl"]
		v_ang_445 = J.mul(((90.0 - J.mul(14.0, J.cl(_t238, null, [v_rise_430]))) + J.mul(10.0, v_pull_431)), _s85["__p"]["D"])
		v_reachY_446 = J.sub(v_ty_433, J.mul(v_Ht_426, 0.48))
		v_px_447 = J.add(J.add(v_tx_432, J.mul(v_Ht_426, 0.14)), J.mul(cos(J.num(v_ang_445)), v_len_443))
		var _t239 = _s85["__p"]["lerp"]
		v_py_448 = J.cl(_t239, null, [J.add(v_ty_433, J.mul(v_len_443, 1.1)), J.add(v_reachY_446, J.mul(v_len_443, sin(J.num(v_ang_445)))), v_up_444])
		J.mc(_s85["ctx"], "save", [])
		J.mc(_s85["ctx"], "beginPath", [])
		J.mc(_s85["ctx"], "rect", [J.sub(v_tx_432, J.mul(v_Ht_426, 2.0)), J.sub(v_ty_433, J.mul(v_Ht_426, 3.0)), J.mul(v_Ht_426, 4.0), (J.mul(v_Ht_426, 3.0) + J.mul(v_Ht_426, 0.012))])
		J.mc(_s85["ctx"], "clip", [])
		J.mc(_s85["ctx"], "save", [])
		J.mc(_s85["ctx"], "translate", [v_px_447, v_py_448])
		J.mc(_s85["ctx"], "rotate", [v_ang_445])
		J.mc(_s85["ctx"], "scale", [(-J.num(v_k_440)), v_k_440])
		J.mc(_s85["ctx"], "drawImage", [v_arm_439, J.mul((-J.num(v_PVx_441)), v_W_425), J.mul((-J.num(v_PVy_442)), v_H_420), v_W_425, v_H_420])
		J.mc(_s85["ctx"], "restore", [])
		v_ux_449 = (-cos(J.num(v_ang_445)))
		v_uy_450 = (-sin(J.num(v_ang_445)))
		v_s0_451 = J.div(J.sub(v_py_448, v_ty_433), (-J.num(v_uy_450)))
		var _t241 = J.mul(v_len_443, 0.25)
		var _t240 = _s85["__p"]["cl"]
		var _t243 = J.mul(v_len_443, 0.25)
		var _t242 = _s85["__p"]["cl"]
		v_s1_452 = J.max_([J.add(v_s0_451, J.mul(_t243, J.cl(_t242, null, [J.mul(v_up_444, 2.0)]))), J.mul(v_len_443, 0.3)])
		if J.cmp(v_s1_452, J.add(v_s0_451, 1.0), ">"):
			v_nx_453 = (-J.num(v_uy_450))
			v_ny_454 = v_ux_449
			v_pts_455 = []
			v_i_456 = 0.0
			while true:
				if not J.cmp(v_i_456, 8.0, "<="): break
				v_q_457 = J.div(v_i_456, 8.0)
				var _t244 = _s85["__p"]["lerp"]
				v_sp_458 = J.cl(_t244, null, [v_s0_451, v_s1_452, v_q_457])
				v_w_459 = (J.mul(v_Ht_426, (0.085 - J.mul(0.06, v_q_457))) * (1.0 + (0.15 * sin(J.num((J.mul(v_t_421, 9.0) + J.mul(v_i_456, 1.7)))))))
				J.mc(v_pts_455, "push", [[J.add(J.add(v_px_447, J.mul(v_ux_449, v_sp_458)), J.mul(v_nx_453, v_w_459)), J.add(J.add(v_py_448, J.mul(v_uy_450, v_sp_458)), J.mul(v_ny_454, v_w_459))]])
				v_i_456 = J.num(v_i_456) + 1.0
			v_i_460 = 8.0
			while true:
				if not J.cmp(v_i_460, 0.0, ">="): break
				v_q_461 = J.div(v_i_460, 8.0)
				var _t245 = _s85["__p"]["lerp"]
				v_sp_462 = J.cl(_t245, null, [v_s0_451, v_s1_452, v_q_461])
				v_w_463 = (J.mul(v_Ht_426, (0.085 - J.mul(0.06, v_q_461))) * (1.0 + (0.15 * sin(J.num(((J.mul(v_t_421, 9.0) + J.mul(v_i_460, 2.3)) + 1.0))))))
				J.mc(v_pts_455, "push", [[J.sub(J.add(v_px_447, J.mul(v_ux_449, v_sp_462)), J.mul(v_nx_453, v_w_463)), J.sub(J.add(v_py_448, J.mul(v_uy_450, v_sp_462)), J.mul(v_ny_454, v_w_463))]])
				v_i_460 = J.num(v_i_460) + -1.0
			J.mc(_s85["ctx"], "beginPath", [])
			J.mc(v_pts_455, "forEach", [Callable(self, "_f52").bind(_s85)])
			J.mc(_s85["ctx"], "closePath", [])
			var _t246 = _s85["ctx"]
			J.sp(_t246, "fillStyle", "rgba(10,26,34,.88)")
			J.mc(_s85["ctx"], "fill", [])
			var _t247 = _s85["ctx"]
			J.sp(_t247, "strokeStyle", "rgba(130,190,205,.55)")
			var _t248 = _s85["ctx"]
			var _t249 = J.max_([1.0, J.mul(v_Ht_426, 0.012)])
			J.sp(_t248, "lineWidth", _t249)
			J.mc(_s85["ctx"], "stroke", [])
		J.mc(_s85["ctx"], "restore", [])
		var _t250 = _s85["__p"]["splash"]
		var _t252 = _s85["ctx"]
		var _t253 = J.add(v_tx_432, J.mul(v_Ht_426, 0.12))
		var _t254 = J.mul(v_Ht_426, 0.8)
		var _t251 = _s85["__p"]["seg"]
		J.cl(_t250, null, [_t252, _t253, v_ty_433, _t254, J.cl(_t251, null, [v_g_422, 0.4, 0.62]), 12.0, 7.7])
		var _t255 = _s85["__p"]["splash"]
		var _t257 = _s85["ctx"]
		var _t258 = J.mul(v_Ht_426, 0.6)
		var _t256 = _s85["__p"]["seg"]
		J.cl(_t255, null, [_t257, v_tx_432, v_ty_433, _t258, J.cl(_t256, null, [v_g_422, 0.56, 0.8]), 9.0, 12.9, 0.7])
		v_i_466 = 0.0
		while true:
			if not J.cmp(v_i_466, 3.0, "<"): break
			var _t259 = _s85["__p"]["drip"]
			J.cl(_t259, null, [_s85["ctx"], J.add(v_tx_432, J.mul(v_Ht_426, (0.06 + J.mul(0.06, v_i_466)))), J.sub(v_ty_433, J.mul(J.mul(v_Ht_426, 0.45), v_up_444)), J.div(J.mul(J.mul(v_Ht_426, 0.45), v_up_444), 1.4), J.mod(((J.sub(v_g_422, 0.45) * 3.5) + J.div(v_i_466, 3.0)), 1.0), J.add(v_i_466, 20.0), J.mul(v_Ht_426, 0.016)])
			v_i_466 = J.num(v_i_466) + 1.0
	J.mc(_s85["ctx"], "restore", [])
	var _t260 = J.cmp(v_g_422, _s85["__p"]["HIT"], ">=")
	if (J.cmp(v_g_422, J.add(_s85["__p"]["HIT"], 0.02), "<") if _t260 else _t260):
		var _t261 = _s85["__p"]["world"]
		var _t262 = J.cl(_t261, null, [v_a_418, J.add(J.gp(v_F_423, "x"), J.mul(v_Ht_426, 0.08)), J.sub(J.gp(v_F_423, "y"), J.mul(v_Ht_426, 0.22))])
		J.sp(v_o_419, "hitP", _t262)
	return true

func _f53(this_, a: Array, env):
	var v_ctx_469 = null; var v_a_470 = null; var v_o_471 = null; var v_H_472 = null; var v_t_473 = null; var v_g_474 = null; var v_F_475 = null; var v_Ht_476 = null; var v_hang_477 = null; var v_hh_478 = null; var v_hw_479 = null; var v_OUT_480 = null; var v_gy_481 = null; var v_ps_482 = null; var v_ouch_483 = null; var v_claw_484 = null; var v_ax_485 = null; var v_ay_486 = null; var v_hy_487 = null; var v_sw_488 = null; var v_crouch_489 = null; var v_jump_490 = null; var v_fall_491 = null; var v_land_492 = null; var v_sq_493 = null; var v_drop_494 = null; var v_up_495 = null; var v_topY_496 = null; var v_ck_497 = null; var v_cx_498 = null; var v_cy_499 = null; var v_grow_500 = null; var v_i_501 = null
	v_ctx_469 = J.arg(a, 0)
	v_a_470 = J.arg(a, 1)
	var _t265 = env["ok"]
	var _t267 = (not J.t(J.cl(_t265, null, ["tianhua"])))
	if not J.t(_t267):
		var _t266 = env["ok"]
		_t267 = (not J.t(J.cl(_t266, null, ["tianhua_hang"])))
	if _t267:
		return false
	v_o_471 = J.gp(v_a_470, "o")
	v_H_472 = J.gp(v_a_470, "H")
	var _t268 = J.gp(v_o_471, "t")
	v_t_473 = (_t268 if J.t(_t268) else 0.0)
	var _t269 = env["prog"]
	v_g_474 = J.cl(_t269, null, [v_o_471])
	var _t270 = env["foe"]
	v_F_475 = J.cl(_t270, null, [v_a_470, 1.9])
	v_Ht_476 = J.gp(v_F_475, "h")
	v_hang_477 = J.gp(J.G.get("SPR"), "tianhua_hang")
	v_hh_478 = J.div(J.mul(v_H_472, 645.0), 577.0)
	v_hw_479 = J.div(J.mul(v_hh_478, J.gp(v_hang_477, "naturalWidth")), J.gp(v_hang_477, "naturalHeight"))
	v_OUT_480 = J.mul(v_H_472, 5.0)
	v_gy_481 = null
	v_ps_482 = null
	v_ouch_483 = 0.0
	if J.cmp(v_g_474, 0.32, "<"):
		var _t271 = env["eo"]
		var _t272 = env["seg"]
		v_crouch_489 = J.cl(_t271, null, [J.cl(_t272, null, [v_g_474, 0.0, 0.14])])
		var _t273 = env["ei"]
		var _t274 = env["seg"]
		v_jump_490 = J.cl(_t273, null, [J.cl(_t274, null, [v_g_474, 0.15, 0.32])])
		var _t275 = J.mul((-J.num(v_OUT_480)), v_jump_490)
		v_gy_481 = _t275
		var _t276 = env["bump"]
		var _t277 = J.cl(_t276, null, [v_g_474, 0.0, 0.05, 0.22])
		v_ouch_483 = _t277
		var _t278 = {"body": (J.mul(0.18, v_crouch_489) * J.sub(1.0, v_jump_490)), "head": J.mul(0.12, v_crouch_489), "sy": ((1.0 - (J.mul(0.1, v_crouch_489) * J.sub(1.0, v_jump_490))) + J.mul(0.25, v_jump_490)), "sx": ((1.0 + (J.mul(0.06, v_crouch_489) * J.sub(1.0, v_jump_490))) - J.mul(0.12, v_jump_490)), "y": (J.mul(0.02, v_crouch_489) * J.sub(1.0, v_jump_490))}
		v_ps_482 = _t278
	else:
		if J.cmp(v_g_474, 0.8, ">"):
			var _t279 = env["seg"]
			v_fall_491 = J.cl(_t279, null, [v_g_474, 0.8, 0.9])
			var _t280 = env["seg"]
			v_land_492 = J.cl(_t280, null, [v_g_474, 0.9, 1.0])
			var _t282 = ((-J.num(v_OUT_480)) * 0.5)
			var _t281 = env["ei"]
			var _t283 = (_t282 * J.sub(1.0, J.cl(_t281, null, [v_fall_491])))
			v_gy_481 = _t283
			var _t285 = null
			if J.cmp(v_g_474, 0.9, ">"):
				var _t284 = env["bump"]
				_t285 = (J.mul(J.cl(_t284, null, [v_g_474, 0.9, 0.93, 1.0]), 1.0) + 0.001)
			else:
				_t285 = 0.0
			v_ouch_483 = _t285
			v_sq_493 = ((sin(J.num(J.mul(v_land_492, env["PI"]))) * (1.0 - J.mul(v_land_492, 0.5))) if J.cmp(v_g_474, 0.9, ">") else 0.0)
			var _t286 = {"body": J.mul(0.22, v_sq_493), "head": J.mul(0.15, v_sq_493), "sy": ((1.0 - J.mul(0.16, v_sq_493)) + (0.12 if J.cmp(v_g_474, 0.9, "<") else 0.0)), "sx": ((1.0 + J.mul(0.1, v_sq_493)) - (0.06 if J.cmp(v_g_474, 0.9, "<") else 0.0)), "y": J.mul(0.02, v_sq_493)}
			v_ps_482 = _t286
	if (not J.leq(v_gy_481, null)):
		J.mc(v_a_470, "shadow", [J.gp(v_a_470, "x"), J.max_([0.2, (1.0 + J.div(v_gy_481, J.mul(v_H_472, 1.5)))])])
	v_claw_484 = [J.mul((-(0.82 - 0.72)), v_hw_479), J.mul(0.86, v_hh_478)]
	v_ax_485 = J.sub(J.add(J.gp(v_F_475, "x"), J.mul(v_Ht_476, 0.04)), J.gp(v_claw_484, 0.0))
	v_ay_486 = J.sub(J.sub(J.gp(v_F_475, "y"), J.mul(v_Ht_476, 0.86)), J.gp(v_claw_484, 1.0))
	v_hy_487 = null
	v_sw_488 = 0.0
	var _t287 = J.cmp(v_g_474, 0.38, ">=")
	if (J.cmp(v_g_474, 0.8, "<=") if _t287 else _t287):
		var _t288 = env["backOut"]
		var _t289 = env["seg"]
		v_drop_494 = J.cl(_t288, null, [J.cl(_t289, null, [v_g_474, 0.38, env["HIT"]])])
		var _t290 = env["ei"]
		var _t291 = env["seg"]
		v_up_495 = J.cl(_t290, null, [J.cl(_t291, null, [v_g_474, 0.64, 0.8])])
		var _t292 = (J.sub(v_ay_486, J.mul(v_OUT_480, J.sub(1.0, v_drop_494))) - J.mul(v_OUT_480, v_up_495))
		v_hy_487 = _t292
		var _t303 = null
		if J.cmp(v_g_474, env["HIT"], "<"):
			var _t294 = (-26.0)
			var _t293 = env["seg"]
			_t303 = J.mul(_t294, J.cl(_t293, null, [v_g_474, 0.38, env["HIT"]]))
		else:
			var _t302 = null
			if J.cmp(v_g_474, 0.6, "<"):
				var _t295 = env["lerp"]
				var _t298 = (-26.0)
				var _t296 = env["eo3"]
				var _t297 = env["seg"]
				_t302 = J.cl(_t295, null, [_t298, 30.0, J.cl(_t296, null, [J.cl(_t297, null, [v_g_474, J.sub(env["HIT"], 0.03), 0.58])])])
			else:
				var _t299 = env["lerp"]
				var _t300 = env["eio"]
				var _t301 = env["seg"]
				_t302 = J.cl(_t299, null, [30.0, 0.0, J.cl(_t300, null, [J.cl(_t301, null, [v_g_474, 0.6, 0.7])])])
			_t303 = _t302
		v_sw_488 = _t303
		if J.cmp(v_g_474, env["HIT"], "<"):
			var _t306 = (-26.0)
			var _t304 = env["eo"]
			var _t305 = env["seg"]
			var _t309 = J.mul(_t306, J.cl(_t304, null, [J.cl(_t305, null, [v_g_474, 0.4, 0.46])]))
			var _t307 = env["ei"]
			var _t308 = env["seg"]
			var _t310 = (_t309 + (J.mul(26.0, J.cl(_t307, null, [J.cl(_t308, null, [v_g_474, 0.46, env["HIT"]])])) * 0.9))
			v_sw_488 = _t310
	var _t311 = env["bump"]
	var _t312 = {"shake": J.cl(_t311, null, [v_g_474, env["HIT"], 0.5, 0.6])}
	J.sp(v_o_471, "vic", _t312)
	if (not J.leq(v_hy_487, null)):
		J.mc(v_a_470, "shadow", [J.add(J.gp(v_a_470, "x"), J.mul(((-1.0) if J.t(J.gp(v_a_470, "faceRight")) else 1.0), v_ax_485)), 0.5])
	var _t313 = env["begin"]
	J.cl(_t313, null, [v_ctx_469, v_a_470])
	if (not J.leq(v_gy_481, null)):
		J.mc(v_ctx_469, "save", [])
		var _t314 = env["floatY"]
		J.mc(v_ctx_469, "translate", [0.0, J.add(v_gy_481, J.cl(_t314, null, [v_a_470]))])
		var _t315 = env["pz"]
		J.mc(J.G.get("MeshAnim"), "drawBody", [v_ctx_469, "tianhua", "tianhua", v_H_472, J.cl(_t315, null, [v_t_473, v_ps_482])])
		J.mc(v_ctx_469, "restore", [])
		var _t316 = J.cmp(v_g_474, 0.14, ">")
		if (J.cmp(v_g_474, 0.34, "<") if _t316 else _t316):
			var _t317 = env["streaks"]
			var _t321 = J.sub(v_gy_481, J.mul(v_H_472, 0.2))
			var _t322 = J.add(v_gy_481, J.mul(v_H_472, 1.2))
			var _t323 = J.mul(v_H_472, 0.5)
			var _t318 = env["seg"]
			var _t320 = J.cl(_t318, null, [v_g_474, 0.14, 0.2])
			var _t319 = env["seg"]
			J.cl(_t317, null, [v_ctx_469, 0.0, _t321, _t322, _t323, 7.0, J.mul(_t320, J.sub(1.0, J.cl(_t319, null, [v_g_474, 0.3, 0.34]))), 5.0])
		var _t324 = J.cmp(v_g_474, 0.8, ">")
		if (J.cmp(v_g_474, 0.92, "<") if _t324 else _t324):
			var _t325 = env["streaks"]
			J.cl(_t325, null, [v_ctx_469, 0.0, J.sub(v_gy_481, J.mul(v_H_472, 1.6)), J.sub(v_gy_481, J.mul(v_H_472, 0.9)), J.mul(v_H_472, 0.5), 6.0, 0.8, 9.0])
		var _t326 = env["dust"]
		var _t328 = J.mul(v_H_472, 0.6)
		var _t327 = env["seg"]
		J.cl(_t326, null, [v_ctx_469, 0.0, 0.0, _t328, J.cl(_t327, null, [v_g_474, 0.15, 0.4]), 8.0, 3.3])
		var _t329 = env["dust"]
		var _t331 = J.mul(v_H_472, 0.6)
		var _t330 = env["seg"]
		J.cl(_t329, null, [v_ctx_469, 0.0, 0.0, _t331, J.cl(_t330, null, [v_g_474, 0.9, 1.0]), 8.0, 6.1])
		if J.cmp(v_ouch_483, 0.0, ">"):
			var _t332 = env["smallText"]
			J.cl(_t332, null, [v_ctx_469, v_a_470, J.mul(v_H_472, 0.2), J.sub(v_gy_481, J.mul(v_H_472, 1.08)), "哎喲", J.mul(v_H_472, 0.2), J.min_([1.0, J.mul(v_ouch_483, 2.0)]), v_t_473])
	var _t333 = env["dust"]
	var _t335 = J.gp(v_F_475, "x")
	var _t336 = J.sub(J.gp(v_F_475, "y"), J.mul(v_Ht_476, 2.1))
	var _t337 = J.mul(v_Ht_476, 1.2)
	var _t334 = env["seg"]
	J.cl(_t333, null, [v_ctx_469, _t335, _t336, _t337, J.cl(_t334, null, [v_g_474, 0.27, 0.45]), 9.0, 14.2])
	if (not J.leq(v_hy_487, null)):
		v_topY_496 = v_hy_487
		if J.cmp(v_g_474, J.add(env["HIT"], 0.04), "<"):
			var _t338 = env["streaks"]
			var _t342 = J.sub(v_topY_496, J.mul(v_H_472, 1.6))
			var _t343 = J.add(v_topY_496, J.mul(v_hh_478, 0.4))
			var _t344 = J.mul(v_hw_479, 0.7)
			var _t339 = env["seg"]
			var _t341 = J.cl(_t339, null, [v_g_474, 0.38, 0.42])
			var _t340 = env["seg"]
			J.cl(_t338, null, [v_ctx_469, v_ax_485, _t342, _t343, _t344, 8.0, J.mul(_t341, J.sub(1.0, J.cl(_t340, null, [v_g_474, env["HIT"], J.add(env["HIT"], 0.04)]))), 2.0])
		if J.cmp(v_g_474, 0.64, ">"):
			var _t345 = env["streaks"]
			var _t347 = J.sub(v_topY_496, J.mul(v_H_472, 0.3))
			var _t348 = J.add(v_topY_496, J.mul(v_hh_478, 0.9))
			var _t349 = J.mul(v_hw_479, 0.7)
			var _t346 = env["seg"]
			J.cl(_t345, null, [v_ctx_469, v_ax_485, _t347, _t348, _t349, 8.0, J.sub(1.0, J.cl(_t346, null, [v_g_474, 0.74, 0.8])), 4.0])
		var _t350 = env["dust"]
		var _t352 = J.mul(v_H_472, 0.9)
		var _t351 = env["seg"]
		J.cl(_t350, null, [v_ctx_469, v_ax_485, v_ay_486, _t352, J.cl(_t351, null, [v_g_474, J.sub(env["HIT"], 0.02), 0.7]), 10.0, 8.8])
		J.mc(v_ctx_469, "save", [])
		J.mc(v_ctx_469, "translate", [v_ax_485, v_hy_487])
		J.mc(v_ctx_469, "rotate", [(J.mul(v_sw_488, env["D"]) + (sin(J.num(J.mul(v_t_473, 3.0))) * 0.03))])
		J.mc(v_ctx_469, "scale", [(-1.0), 1.0])
		J.mc(v_ctx_469, "drawImage", [v_hang_477, J.mul((-0.72), v_hw_479), 0.0, v_hw_479, v_hh_478])
		J.mc(v_ctx_469, "restore", [])
		var _t353 = env["bump"]
		v_ck_497 = J.cl(_t353, null, [v_g_474, J.sub(env["HIT"], 0.01), J.add(env["HIT"], 0.02), 0.62])
		if J.cmp(v_ck_497, 0.0, ">"):
			J.mc(v_ctx_469, "save", [])
			var _t354 = J.mul(J.gp(v_ctx_469, "globalAlpha"), v_ck_497)
			J.sp(v_ctx_469, "globalAlpha", _t354)
			v_cx_498 = J.add(J.gp(v_F_475, "x"), J.mul(v_Ht_476, 0.02))
			v_cy_499 = J.sub(J.gp(v_F_475, "y"), J.mul(v_Ht_476, 0.78))
			var _t355 = env["eo"]
			var _t356 = env["seg"]
			v_grow_500 = J.cl(_t355, null, [J.cl(_t356, null, [v_g_474, J.sub(env["HIT"], 0.01), J.add(env["HIT"], 0.03)])])
			v_i_501 = (-1.0)
			while true:
				if not J.cmp(v_i_501, 1.0, "<="): break
				var _t357 = env["slash"]
				J.cl(_t357, null, [v_ctx_469, J.add(v_cx_498, J.mul(v_Ht_476, (0.08 + J.mul(v_i_501, 0.055)))), J.sub(v_cy_499, J.mul(v_Ht_476, 0.12)), J.add(J.add(v_cx_498, J.mul(v_Ht_476, (0.08 + J.mul(v_i_501, 0.055)))), J.mul(J.mul(v_Ht_476, (-0.1)), v_grow_500)), (J.sub(v_cy_499, J.mul(v_Ht_476, 0.12)) + J.mul(J.mul(v_Ht_476, 0.3), v_grow_500)), J.mul(v_Ht_476, 0.014)])
				v_i_501 = J.num(v_i_501) + 1.0
			J.mc(v_ctx_469, "restore", [])
	J.mc(v_ctx_469, "restore", [])
	var _t358 = J.cmp(v_g_474, env["HIT"], ">=")
	if (J.cmp(v_g_474, J.add(env["HIT"], 0.02), "<") if _t358 else _t358):
		var _t359 = env["world"]
		var _t360 = J.cl(_t359, null, [v_a_470, J.gp(v_F_475, "x"), J.sub(J.gp(v_F_475, "y"), J.mul(v_Ht_476, 0.8))])
		J.sp(v_o_471, "hitP", _t360)
	return true

func _f57(this_, a: Array, env):
	var v_x_524 = null; var v_y_525 = null; var v_p_526 = null
	v_x_524 = J.arg(a, 0)
	v_y_525 = J.arg(a, 1)
	var _t362 = env["__p"]["rot"]
	v_p_526 = J.cl(_t362, null, [v_x_524, J.add(v_y_525, J.mul(env["H"], env["__p"]["LEANY"])), env["lean"]])
	return [J.add(J.gp(v_p_526, 0.0), env["dx"]), J.add(J.sub(J.gp(v_p_526, 1.0), J.mul(env["H"], env["__p"]["LEANY"])), env["dy"])]

func _f56(this_, a: Array, env):
	var _s107 = {"__p": env, "H": null, "lean": null, "dx": null, "dy": null}
	_s107["H"] = J.arg(a, 0)
	_s107["lean"] = J.arg(a, 1)
	_s107["dx"] = J.arg(a, 2)
	_s107["dy"] = J.arg(a, 3)
	return Callable(self, "_f57").bind(_s107)

func _f58(this_, a: Array, env):
	var v_ctx_527 = null; var v_H_528 = null; var v_lean_529 = null; var v_dx_530 = null; var v_dy_531 = null
	v_ctx_527 = J.arg(a, 0)
	v_H_528 = J.arg(a, 1)
	v_lean_529 = J.arg(a, 2)
	v_dx_530 = J.arg(a, 3)
	v_dy_531 = J.arg(a, 4)
	J.mc(v_ctx_527, "translate", [v_dx_530, v_dy_531])
	J.mc(v_ctx_527, "translate", [0.0, J.mul((-J.num(v_H_528)), env["LEANY"])])
	J.mc(v_ctx_527, "rotate", [v_lean_529])
	J.mc(v_ctx_527, "translate", [0.0, J.mul(v_H_528, env["LEANY"])])

func _f65(this_, a: Array, env):
	var v_p_625 = null
	v_p_625 = J.arg(a, 0)
	return [J.mul(J.sub(J.gp(v_p_625, 0.0), 0.5), env["W"]), ((-J.num(env["H"])) + J.mul(J.gp(v_p_625, 1.0), env["H"]))]

func _f66(this_, a: Array, env):
	var v_th_626 = null; var v_lean_627 = null; var v_dx_628 = null; var v_r_629 = null; var v_p_630 = null
	v_th_626 = J.arg(a, 0)
	v_lean_627 = J.arg(a, 1)
	v_dx_628 = J.arg(a, 2)
	var _t370 = env["__p"]["rot"]
	v_r_629 = J.cl(_t370, null, [J.gp(env["vT"], 0.0), J.gp(env["vT"], 1.0), v_th_626])
	var _t371 = env["__p"]["bodyXf"]
	var _t372 = J.cl(_t371, null, [env["H"], v_lean_627, 0.0, 0.0])
	v_p_630 = J.cl(_t372, null, [J.add(J.gp(env["pv"], 0.0), J.gp(v_r_629, 0.0)), J.add(J.gp(env["pv"], 1.0), J.gp(v_r_629, 1.0))])
	return [J.add((-J.num(J.gp(v_p_630, 0.0))), v_dx_628), J.gp(v_p_630, 1.0)]

func _f64(this_, a: Array, env):
	var v_ctx_590 = null; var v_a_591 = null; var v_o_592 = null; var v_t_594 = null; var v_g_595 = null; var v_F_596 = null; var v_img_597 = null; var v_Ht_599 = null; var v_L_600 = null; var v_want_603 = null; var v_leanHit_604 = null; var v_tipAt_605 = null; var v_thHit_606 = null; var v_be_607 = null; var v_Lg_608 = null; var v_TH0_609 = null; var v_THF_610 = null; var v_turn_611 = null; var v_cs_612 = null; var v_fx_613 = null; var v_hopT_614 = null; var v_th_615 = null; var v_lean_616 = null; var v_dx_617 = null; var v_walk_618 = null; var v_mv_619 = null; var v_trail_620 = null; var v_hk0_621 = null; var v_hp_622 = null; var v_hk_623 = null; var v_stk_624 = null; var v_d_631 = null; var v_e_632 = null; var v_k_633 = null; var v_k_634 = null; var v_m_635 = null; var v_k_636 = null; var v_k_637 = null; var v_q_638 = null; var v_sw_639 = null; var v_th2_640 = null; var v_thA_641 = null; var v_pts_642 = null; var v_i_643 = null; var v_r_644 = null; var v_c_645 = null; var v_i_646 = null; var v_an_647 = null; var v_r_648 = null; var v_q_649 = null; var v_cp_650 = null
	var _s123 = {"__p": env, "H": null, "W": null, "pv": null, "vT": null}
	v_ctx_590 = J.arg(a, 0)
	v_a_591 = J.arg(a, 1)
	var _t364 = _s123["__p"]["ok"]
	var _t366 = (not J.t(J.cl(_t364, null, ["npc_guard__bodyC"])))
	if not J.t(_t366):
		var _t365 = _s123["__p"]["ok"]
		_t366 = (not J.t(J.cl(_t365, null, ["npc_guard__club"])))
	if _t366:
		return false
	v_o_592 = J.gp(v_a_591, "o")
	_s123["H"] = J.gp(v_a_591, "H")
	var _t367 = J.gp(v_o_592, "t")
	v_t_594 = (_t367 if J.t(_t367) else 0.0)
	var _t368 = _s123["__p"]["prog"]
	v_g_595 = J.cl(_t368, null, [v_o_592])
	var _t369 = _s123["__p"]["foe"]
	v_F_596 = J.cl(_t369, null, [v_a_591, 0.68])
	v_img_597 = J.gp(J.G.get("SPR"), "npc_guard__bodyC")
	_s123["W"] = J.div(J.mul(_s123["H"], J.gp(v_img_597, "naturalWidth")), J.gp(v_img_597, "naturalHeight"))
	v_Ht_599 = J.gp(v_F_596, "h")
	v_L_600 = Callable(self, "_f65").bind(_s123)
	_s123["pv"] = J.cl(v_L_600, null, [J.gp(_s123["__p"]["GD"], "PV")])
	_s123["vT"] = [J.mul(J.sub(J.gp(J.gp(_s123["__p"]["GD"], "TIP"), 0.0), J.gp(J.gp(_s123["__p"]["GD"], "PV"), 0.0)), _s123["W"]), J.mul(J.sub(J.gp(J.gp(_s123["__p"]["GD"], "TIP"), 1.0), J.gp(J.gp(_s123["__p"]["GD"], "PV"), 1.0)), _s123["H"])]
	v_want_603 = [J.add(J.gp(v_F_596, "x"), J.mul(v_Ht_599, 0.12)), J.sub(J.gp(v_F_596, "y"), J.mul(v_Ht_599, 0.66))]
	v_leanHit_604 = J.mul(7.0, _s123["__p"]["D"])
	v_tipAt_605 = Callable(self, "_f66").bind(_s123)
	v_thHit_606 = J.mul((-105.0), _s123["__p"]["D"])
	v_be_607 = 1000000000.0
	v_d_631 = (-40.0)
	while true:
		if not J.cmp(v_d_631, (-150.0), ">="): break
		v_e_632 = absf(J.num(J.sub(J.gp(J.cl(v_tipAt_605, null, [J.mul(v_d_631, _s123["__p"]["D"]), v_leanHit_604, 0.0]), 1.0), J.gp(v_want_603, 1.0))))
		if J.cmp(v_e_632, v_be_607, "<"):
			v_be_607 = v_e_632
			var _t373 = J.mul(v_d_631, _s123["__p"]["D"])
			v_thHit_606 = _t373
		if J.cmp(J.gp(J.cl(v_tipAt_605, null, [J.mul(v_d_631, _s123["__p"]["D"]), v_leanHit_604, 0.0]), 1.0), J.gp(v_want_603, 1.0), "<="):
			break
		v_d_631 = J.num(v_d_631) + -1.0
	var _t374 = _s123["__p"]["cl"]
	v_Lg_608 = J.cl(_t374, null, [J.sub(J.gp(J.cl(v_tipAt_605, null, [v_thHit_606, v_leanHit_604, 0.0]), 0.0), J.gp(v_want_603, 0.0)), ((-J.num(_s123["H"])) * 0.15), J.mul(_s123["H"], 0.6)])
	v_TH0_609 = J.mul(38.0, _s123["__p"]["D"])
	v_THF_610 = J.sub(v_thHit_606, J.mul(22.0, _s123["__p"]["D"]))
	var _t379 = null
	if J.cmp(v_g_595, 0.6, "<"):
		var _t375 = _s123["__p"]["eio"]
		var _t376 = _s123["__p"]["seg"]
		_t379 = J.cl(_t375, null, [J.cl(_t376, null, [v_g_595, 0.03, 0.17])])
	else:
		var _t377 = _s123["__p"]["eio"]
		var _t378 = _s123["__p"]["seg"]
		_t379 = J.sub(1.0, J.cl(_t377, null, [J.cl(_t378, null, [v_g_595, 0.72, 0.9])]))
	v_turn_611 = _t379
	v_cs_612 = cos(J.num(J.mul(v_turn_611, _s123["__p"]["PI"])))
	v_fx_613 = ((1.0 if J.cmp(v_cs_612, 0.0, ">=") else (-1.0)) * (0.32 + (0.68 * absf(J.num(v_cs_612)))))
	v_hopT_614 = (J.mul(sin(J.num(J.mul(v_turn_611, _s123["__p"]["PI"]))), _s123["H"]) * 0.025)
	v_th_615 = null
	v_lean_616 = null
	v_dx_617 = null
	if J.cmp(v_g_595, 0.4, "<"):
		var _t380 = _s123["__p"]["eio"]
		var _t381 = _s123["__p"]["seg"]
		v_k_633 = J.cl(_t380, null, [J.cl(_t381, null, [v_g_595, 0.14, 0.38])])
		var _t382 = J.mul(v_TH0_609, v_k_633)
		v_th_615 = _t382
		var _t383 = J.mul(J.mul((-6.0), _s123["__p"]["D"]), v_k_633)
		v_lean_616 = _t383
		var _t386 = ((-J.num(v_Lg_608)) * 0.4)
		var _t384 = _s123["__p"]["eio"]
		var _t385 = _s123["__p"]["seg"]
		var _t387 = J.mul(_t386, J.cl(_t384, null, [J.cl(_t385, null, [v_g_595, 0.05, 0.38])]))
		v_dx_617 = _t387
	else:
		if J.cmp(v_g_595, _s123["__p"]["HIT"], "<"):
			var _t388 = _s123["__p"]["ei"]
			var _t389 = _s123["__p"]["seg"]
			v_k_634 = J.cl(_t388, null, [J.cl(_t389, null, [v_g_595, 0.4, _s123["__p"]["HIT"]])])
			var _t390 = _s123["__p"]["eo"]
			var _t391 = _s123["__p"]["seg"]
			v_m_635 = J.cl(_t390, null, [J.cl(_t391, null, [v_g_595, 0.4, _s123["__p"]["HIT"]])])
			var _t392 = _s123["__p"]["lerp"]
			var _t393 = J.cl(_t392, null, [v_TH0_609, v_thHit_606, v_k_634])
			v_th_615 = _t393
			var _t394 = _s123["__p"]["lerp"]
			var _t395 = J.cl(_t394, null, [J.mul((-6.0), _s123["__p"]["D"]), v_leanHit_604, v_m_635])
			v_lean_616 = _t395
			var _t396 = _s123["__p"]["lerp"]
			var _t397 = J.cl(_t396, null, [((-J.num(v_Lg_608)) * 0.4), (-J.num(v_Lg_608)), v_m_635])
			v_dx_617 = _t397
		else:
			if J.cmp(v_g_595, 0.6, "<"):
				var _t398 = _s123["__p"]["eo3"]
				var _t399 = _s123["__p"]["seg"]
				v_k_636 = J.cl(_t398, null, [J.cl(_t399, null, [v_g_595, _s123["__p"]["HIT"], 0.6])])
				var _t400 = _s123["__p"]["lerp"]
				var _t401 = J.cl(_t400, null, [v_thHit_606, v_THF_610, v_k_636])
				v_th_615 = _t401
				var _t402 = J.add(v_leanHit_604, J.mul(J.mul(2.0, _s123["__p"]["D"]), v_k_636))
				v_lean_616 = _t402
				v_dx_617 = (-J.num(v_Lg_608))
			else:
				var _t403 = _s123["__p"]["seg"]
				v_k_637 = J.cl(_t403, null, [v_g_595, 0.6, 1.0])
				var _t404 = _s123["__p"]["eio"]
				var _t405 = _s123["__p"]["seg"]
				v_q_638 = J.cl(_t404, null, [J.cl(_t405, null, [v_k_637, 0.0, 0.45])])
				v_sw_639 = (J.mul(((sin(J.num((J.mul(J.div(J.sub(v_k_637, 0.4), 0.6), _s123["__p"]["PI"]) * 2.4))) * (1.0 - J.div(J.sub(v_k_637, 0.4), 0.6))) * 10.0), _s123["__p"]["D"]) if J.cmp(v_k_637, 0.4, ">") else 0.0)
				var _t406 = _s123["__p"]["lerp"]
				var _t407 = J.add(J.cl(_t406, null, [v_THF_610, 0.0, v_q_638]), v_sw_639)
				v_th_615 = _t407
				var _t408 = _s123["__p"]["lerp"]
				var _t411 = J.add(v_leanHit_604, J.mul(2.0, _s123["__p"]["D"]))
				var _t409 = _s123["__p"]["eio"]
				var _t410 = _s123["__p"]["seg"]
				var _t412 = J.cl(_t408, null, [_t411, 0.0, J.cl(_t409, null, [J.cl(_t410, null, [v_k_637, 0.0, 0.6])])])
				v_lean_616 = _t412
				var _t413 = _s123["__p"]["lerp"]
				var _t416 = (-J.num(v_Lg_608))
				var _t414 = _s123["__p"]["eio"]
				var _t415 = _s123["__p"]["seg"]
				var _t417 = J.cl(_t413, null, [_t416, 0.0, J.cl(_t414, null, [J.cl(_t415, null, [v_k_637, 0.15, 1.0])])])
				v_dx_617 = _t417
	v_walk_618 = J.mul(J.div(absf(J.num(v_dx_617)), J.mul(_s123["H"], 0.12)), _s123["__p"]["PI"])
	v_mv_619 = (1.0 if J.cmp(v_g_595, 0.6, "<") else 0.8)
	var _t418 = _s123["__p"]["bump"]
	var _t419 = {"shake": J.cl(_t418, null, [v_g_595, _s123["__p"]["HIT"], 0.5, 0.6])}
	J.sp(v_o_592, "vic", _t419)
	var _t420 = _s123["__p"]["world"]
	J.mc(v_a_591, "shadow", [J.gp(J.cl(_t420, null, [v_a_591, v_dx_617, 0.0]), 0.0)])
	var _t421 = _s123["__p"]["begin"]
	J.cl(_t421, null, [v_ctx_590, v_a_591])
	J.mc(v_ctx_590, "translate", [v_dx_617, (-J.num(v_hopT_614))])
	J.mc(v_ctx_590, "scale", [v_fx_613, 1.0])
	var _t422 = _s123["__p"]["pushBody"]
	J.cl(_t422, null, [v_ctx_590, _s123["H"], v_lean_616, 0.0, 0.0])
	var _t423 = _s123["__p"]["npcBody"]
	var _t430 = _s123["H"]
	var _t428 = J.mul((sin(J.num(v_walk_618)) * 0.2), v_mv_619)
	var _t429 = J.mul(((-sin(J.num(v_walk_618))) * 0.2), v_mv_619)
	var _t424 = J.cmp(v_g_595, 0.4, ">=")
	var _t427 = null
	if (J.cmp(v_g_595, 0.66, "<") if _t424 else _t424):
		var _t426 = (-0.06)
		var _t425 = _s123["__p"]["bump"]
		_t427 = J.mul(_t426, J.cl(_t425, null, [v_g_595, 0.4, _s123["__p"]["HIT"], 0.66]))
	else:
		_t427 = 0.0
	J.cl(_t423, null, [v_ctx_590, "npc_guard", "npc_guard__bodyC", _t430, v_t_594, {"legF": _t428, "legB": _t429, "head": _t427, "body": 0.0}])
	var _t431 = J.cmp(v_g_595, 0.42, ">")
	var _t435 = null
	if (J.cmp(v_g_595, 0.56, "<") if _t431 else _t431):
		var _t434 = null
		if J.cmp(v_g_595, _s123["__p"]["HIT"], "<"):
			var _t432 = _s123["__p"]["seg"]
			_t434 = J.cl(_t432, null, [v_g_595, 0.42, 0.45])
		else:
			var _t433 = _s123["__p"]["seg"]
			_t434 = J.sub(1.0, J.cl(_t433, null, [v_g_595, _s123["__p"]["HIT"], 0.56]))
		_t435 = _t434
	else:
		_t435 = 0.0
	v_trail_620 = _t435
	if J.cmp(v_trail_620, 0.0, ">"):
		v_th2_640 = (v_th_615 if J.cmp(v_g_595, _s123["__p"]["HIT"], "<") else v_thHit_606)
		v_thA_641 = J.add(v_th2_640, J.mul(70.0, _s123["__p"]["D"]))
		v_pts_642 = []
		v_i_643 = 0.0
		while true:
			if not J.cmp(v_i_643, 14.0, "<="): break
			var _t436 = _s123["__p"]["rot"]
			var _t438 = J.gp(_s123["vT"], 0.0)
			var _t439 = J.gp(_s123["vT"], 1.0)
			var _t437 = _s123["__p"]["lerp"]
			v_r_644 = J.cl(_t436, null, [_t438, _t439, J.cl(_t437, null, [v_thA_641, v_th2_640, J.div(v_i_643, 14.0)])])
			J.mc(v_pts_642, "push", [[J.add(J.gp(_s123["pv"], 0.0), J.gp(v_r_644, 0.0)), J.add(J.gp(_s123["pv"], 1.0), J.gp(v_r_644, 1.0))]])
			v_i_643 = J.num(v_i_643) + 1.0
		J.mc(v_ctx_590, "save", [])
		var _t440 = J.mul(J.gp(v_ctx_590, "globalAlpha"), J.mul(0.6, v_trail_620))
		J.sp(v_ctx_590, "globalAlpha", _t440)
		var _t441 = _s123["__p"]["crayonLine"]
		J.cl(_t441, null, [v_ctx_590, v_pts_642, J.mul(_s123["H"], 0.045), "rgba(255,248,226,.85)", "rgba(70,60,40,.25)"])
		J.mc(v_ctx_590, "restore", [])
	var _t442 = _s123["__p"]["piece"]
	J.cl(_t442, null, [v_ctx_590, J.gp(J.G.get("SPR"), "npc_guard__club"), _s123["W"], _s123["H"], J.gp(_s123["__p"]["GD"], "PV"), _s123["pv"], v_th_615])
	J.mc(v_ctx_590, "restore", [])
	var _t443 = _s123["__p"]["bump"]
	v_hk0_621 = J.cl(_t443, null, [v_g_595, 0.16, 0.24, 0.4])
	if J.cmp(v_hk0_621, 0.0, ">"):
		var _t444 = _s123["__p"]["begin"]
		J.cl(_t444, null, [v_ctx_590, v_a_591])
		var _t445 = _s123["__p"]["smallText"]
		J.cl(_t445, null, [v_ctx_590, v_a_591, J.add(v_dx_617, J.mul(_s123["H"], 0.2)), ((-J.num(_s123["H"])) * 1.0), "哼", J.mul(_s123["H"], 0.12), v_hk0_621, v_t_594])
		J.mc(v_ctx_590, "restore", [])
	v_hp_622 = v_want_603
	var _t446 = _s123["__p"]["seg"]
	v_hk_623 = J.cl(_t446, null, [v_g_595, _s123["__p"]["HIT"], J.add(_s123["__p"]["HIT"], 0.12)])
	var _t447 = J.cmp(v_g_595, _s123["__p"]["HIT"], ">=")
	if (J.cmp(v_g_595, J.add(_s123["__p"]["HIT"], 0.12), "<") if _t447 else _t447):
		var _t448 = _s123["__p"]["begin"]
		J.cl(_t448, null, [v_ctx_590, v_a_591])
		var _t449 = _s123["__p"]["burst"]
		J.cl(_t449, null, [v_ctx_590, J.gp(v_hp_622, 0.0), J.gp(v_hp_622, 1.0), J.mul(v_Ht_599, 0.24), v_hk_623, 0.4])
		var _t450 = _s123["__p"]["clank"]
		J.cl(_t450, null, [v_ctx_590, v_a_591, J.add(J.gp(v_hp_622, 0.0), J.mul(v_Ht_599, 0.05)), J.sub(J.gp(v_hp_622, 1.0), J.mul(v_Ht_599, 0.4)), J.mul(v_Ht_599, 0.2), v_hk_623, (-0.12)])
		J.mc(v_ctx_590, "restore", [])
	var _t451 = _s123["__p"]["bump"]
	v_stk_624 = J.cl(_t451, null, [v_g_595, _s123["__p"]["HIT"], J.add(_s123["__p"]["HIT"], 0.03), 0.66])
	if J.cmp(v_stk_624, 0.0, ">"):
		var _t452 = _s123["__p"]["begin"]
		J.cl(_t452, null, [v_ctx_590, v_a_591])
		var _t453 = J.mul(J.gp(v_ctx_590, "globalAlpha"), v_stk_624)
		J.sp(v_ctx_590, "globalAlpha", _t453)
		v_c_645 = [J.add(J.gp(v_F_596, "x"), J.mul(v_Ht_599, 0.04)), J.sub(J.gp(v_F_596, "y"), J.mul(v_Ht_599, 1.02))]
		v_i_646 = 0.0
		while true:
			if not J.cmp(v_i_646, 3.0, "<"): break
			v_an_647 = ((J.sub(v_g_595, _s123["__p"]["HIT"]) * 9.0) + J.div((J.mul(v_i_646, _s123["__p"]["PI"]) * 2.0), 3.0))
			v_r_648 = J.mul(v_Ht_599, 0.17)
			var _t454 = _s123["__p"]["star"]
			J.cl(_t454, null, [v_ctx_590, J.add(J.gp(v_c_645, 0.0), J.mul(cos(J.num(v_an_647)), v_r_648)), J.add(J.gp(v_c_645, 1.0), (J.mul(sin(J.num(v_an_647)), v_r_648) * 0.35)), J.mul(v_Ht_599, 0.055), v_an_647])
			v_i_646 = J.num(v_i_646) + 1.0
		J.mc(v_ctx_590, "restore", [])
	var _t455 = J.cmp(v_g_595, J.sub(_s123["__p"]["HIT"], 0.005), ">=")
	if (J.cmp(v_g_595, 0.75, "<") if _t455 else _t455):
		var _t456 = _s123["__p"]["seg"]
		v_q_649 = J.cl(_t456, null, [v_g_595, J.sub(_s123["__p"]["HIT"], 0.005), 0.72])
		v_cp_650 = [J.add(J.gp(v_hp_622, 0.0), J.mul(v_Ht_599, 0.06)), J.add(J.gp(v_hp_622, 1.0), J.mul(v_Ht_599, 0.02))]
		var _t457 = _s123["__p"]["begin"]
		J.cl(_t457, null, [v_ctx_590, v_a_591])
		var _t458 = _s123["__p"]["teaDrops"]
		J.cl(_t458, null, [v_ctx_590, J.gp(v_cp_650, 0.0), J.gp(v_cp_650, 1.0), (-0.8), (-0.85), J.mul(v_Ht_599, 0.6), (0.06 + J.mul(v_q_649, 0.94)), 6.0, 7.3])
		var _t459 = _s123["__p"]["steam"]
		var _t461 = J.add(J.gp(v_cp_650, 0.0), J.mul(v_Ht_599, 0.04))
		var _t462 = J.sub(J.gp(v_cp_650, 1.0), J.mul(v_Ht_599, 0.04))
		var _t463 = J.mul(v_Ht_599, 0.35)
		var _t460 = _s123["__p"]["seg"]
		J.cl(_t459, null, [v_ctx_590, _t461, _t462, _t463, J.cl(_t460, null, [v_g_595, _s123["__p"]["HIT"], 0.64]), 1.3])
		J.mc(v_ctx_590, "restore", [])
	var _t464 = J.cmp(v_g_595, _s123["__p"]["HIT"], ">=")
	if (J.cmp(v_g_595, J.add(_s123["__p"]["HIT"], 0.02), "<") if _t464 else _t464):
		var _t465 = _s123["__p"]["world"]
		var _t466 = J.cl(_t465, null, [v_a_591, J.gp(v_hp_622, 0.0), J.gp(v_hp_622, 1.0)])
		J.sp(v_o_592, "hitP", _t466)
	return true

func _f69(this_, a: Array, env):
	var v_p_712 = null
	v_p_712 = J.arg(a, 0)
	return [J.mul(J.sub(J.gp(v_p_712, 0.0), 0.5), env["W"]), ((-J.num(env["H"])) + J.mul(J.gp(v_p_712, 1.0), env["H"]))]

func _f68(this_, a: Array, env):
	var v_ctx_663 = null; var v_a_664 = null; var v_o_665 = null; var v_t_667 = null; var v_g_668 = null; var v_F_669 = null; var v_img_670 = null; var v_Ht_672 = null; var v_FIST_673 = null; var v_TOP_674 = null; var v_BOT_675 = null; var v_HEAD_676 = null; var v_SH_677 = null; var v_HAND_678 = null; var v_L_679 = null; var v_fist_680 = null; var v_axisUp_681 = null; var v_axAng_682 = null; var v_thT_683 = null; var v_hold_684 = null; var v_pullB_685 = null; var v_poke_686 = null; var v_th_687 = null; var v_headV_688 = null; var v_leanHit_689 = null; var v_rh_690 = null; var v_hit0_691 = null; var v_want_692 = null; var v_Lg_693 = null; var v_lean_694 = null; var v_dx_695 = null; var v_jab_696 = null; var v_fx_697 = null; var v_fy_698 = null; var v_ub_699 = null; var v_ul_700 = null; var v_sh_701 = null; var v_hand0_702 = null; var v_reach_703 = null; var v_bestS_704 = null; var v_be_705 = null; var v_grip_706 = null; var v_ang_707 = null; var v_r_708 = null; var v_fixv_709 = null; var v_hv_710 = null; var v_hp_711 = null; var v_s_713 = null; var v_p_714 = null; var v_e_715 = null; var v_i_716 = null; var v_q_717 = null; var v_w_718 = null
	var _s145 = {"__p": env, "H": null, "W": null}
	v_ctx_663 = J.arg(a, 0)
	v_a_664 = J.arg(a, 1)
	var _t469 = _s145["__p"]["ok"]
	var _t471 = (not J.t(J.cl(_t469, null, ["npc_auntie__bodyH"])))
	if not J.t(_t471):
		var _t470 = _s145["__p"]["ok"]
		_t471 = (not J.t(J.cl(_t470, null, ["npc_auntie__arm"])))
	var _t473 = _t471
	if not J.t(_t473):
		var _t472 = _s145["__p"]["ok"]
		_t473 = (not J.t(J.cl(_t472, null, ["npc_auntie__hip"])))
	if _t473:
		return false
	v_o_665 = J.gp(v_a_664, "o")
	_s145["H"] = J.gp(v_a_664, "H")
	var _t474 = J.gp(v_o_665, "t")
	v_t_667 = (_t474 if J.t(_t474) else 0.0)
	var _t475 = _s145["__p"]["prog"]
	v_g_668 = J.cl(_t475, null, [v_o_665])
	var _t476 = _s145["__p"]["foe"]
	v_F_669 = J.cl(_t476, null, [v_a_664, 0.68])
	v_img_670 = J.gp(J.G.get("SPR"), "npc_auntie__bodyH")
	_s145["W"] = J.div(J.mul(_s145["H"], J.gp(v_img_670, "naturalWidth")), J.gp(v_img_670, "naturalHeight"))
	v_Ht_672 = J.gp(v_F_669, "h")
	v_FIST_673 = [0.275, 0.515]
	v_TOP_674 = [0.235, 0.34]
	v_BOT_675 = [0.37, 0.95]
	v_HEAD_676 = [0.1, 0.36]
	v_SH_677 = [0.765, 0.43]
	v_HAND_678 = [0.735, 0.595]
	v_L_679 = Callable(self, "_f69").bind(_s145)
	v_fist_680 = J.cl(v_L_679, null, [v_FIST_673])
	v_axisUp_681 = [J.mul(J.sub(J.gp(v_TOP_674, 0.0), J.gp(v_BOT_675, 0.0)), _s145["W"]), J.mul(J.sub(J.gp(v_TOP_674, 1.0), J.gp(v_BOT_675, 1.0)), _s145["H"])]
	v_axAng_682 = atan2(J.num(J.gp(v_axisUp_681, 1.0)), J.num(J.gp(v_axisUp_681, 0.0)))
	v_thT_683 = (J.sub((-J.num(_s145["__p"]["PI"])), v_axAng_682) + J.mul(6.0, _s145["__p"]["D"]))
	var _t481 = null
	if J.cmp(v_g_668, 0.6, "<"):
		var _t477 = _s145["__p"]["eio"]
		var _t478 = _s145["__p"]["seg"]
		_t481 = J.cl(_t477, null, [J.cl(_t478, null, [v_g_668, 0.0, 0.26])])
	else:
		var _t479 = _s145["__p"]["eio"]
		var _t480 = _s145["__p"]["seg"]
		_t481 = J.sub(1.0, J.cl(_t479, null, [J.cl(_t480, null, [v_g_668, 0.68, 1.0])]))
	v_hold_684 = _t481
	var _t487 = null
	if J.cmp(v_g_668, 0.4, "<"):
		var _t482 = _s145["__p"]["eio"]
		var _t483 = _s145["__p"]["seg"]
		_t487 = J.cl(_t482, null, [J.cl(_t483, null, [v_g_668, 0.14, 0.38])])
	else:
		var _t486 = null
		if J.cmp(v_g_668, _s145["__p"]["HIT"], "<"):
			var _t484 = _s145["__p"]["ei"]
			var _t485 = _s145["__p"]["seg"]
			_t486 = J.sub(1.0, J.cl(_t484, null, [J.cl(_t485, null, [v_g_668, 0.4, _s145["__p"]["HIT"]])]))
		else:
			_t486 = 0.0
		_t487 = _t486
	v_pullB_685 = _t487
	var _t493 = null
	if J.cmp(v_g_668, _s145["__p"]["HIT"], "<"):
		var _t488 = _s145["__p"]["ei"]
		var _t489 = _s145["__p"]["seg"]
		_t493 = J.cl(_t488, null, [J.cl(_t489, null, [v_g_668, 0.4, _s145["__p"]["HIT"]])])
	else:
		var _t492 = null
		if J.cmp(v_g_668, 0.6, "<"):
			_t492 = 1.0
		else:
			var _t490 = _s145["__p"]["eio"]
			var _t491 = _s145["__p"]["seg"]
			_t492 = J.sub(1.0, J.cl(_t490, null, [J.cl(_t491, null, [v_g_668, 0.6, 0.95])]))
		_t493 = _t492
	v_poke_686 = _t493
	v_th_687 = J.mul(v_thT_683, v_hold_684)
	v_headV_688 = [J.mul(J.sub(J.gp(v_HEAD_676, 0.0), J.gp(v_FIST_673, 0.0)), _s145["W"]), J.mul(J.sub(J.gp(v_HEAD_676, 1.0), J.gp(v_FIST_673, 1.0)), _s145["H"])]
	v_leanHit_689 = J.mul((-10.0), _s145["__p"]["D"])
	var _t494 = _s145["__p"]["rot"]
	v_rh_690 = J.cl(_t494, null, [J.gp(v_headV_688, 0.0), J.gp(v_headV_688, 1.0), v_thT_683])
	var _t495 = _s145["__p"]["bodyXf"]
	var _t496 = J.cl(_t495, null, [_s145["H"], v_leanHit_689, 0.0, 0.0])
	v_hit0_691 = J.cl(_t496, null, [J.sub(J.add(J.gp(v_fist_680, 0.0), J.gp(v_rh_690, 0.0)), J.mul(_s145["H"], 0.04)), J.add(J.gp(v_fist_680, 1.0), J.gp(v_rh_690, 1.0))])
	v_want_692 = J.add(J.gp(v_F_669, "x"), J.mul(v_Ht_672, 0.16))
	v_Lg_693 = J.max_([0.0, J.sub(J.gp(v_hit0_691, 0.0), v_want_692)])
	v_lean_694 = (J.mul(J.mul(10.0, _s145["__p"]["D"]), v_pullB_685) + J.mul(v_leanHit_689, v_poke_686))
	v_dx_695 = (J.mul(J.mul(_s145["H"], 0.1), v_pullB_685) - J.mul(v_Lg_693, v_poke_686))
	v_jab_696 = (J.mul(((-J.num(_s145["H"])) * 0.06), v_poke_686) + J.mul(J.mul(_s145["H"], 0.05), v_pullB_685))
	var _t497 = _s145["__p"]["bump"]
	var _t498 = {"shake": J.cl(_t497, null, [v_g_668, _s145["__p"]["HIT"], 0.5, 0.6])}
	J.sp(v_o_665, "vic", _t498)
	var _t499 = _s145["__p"]["world"]
	J.mc(v_a_664, "shadow", [J.gp(J.cl(_t499, null, [v_a_664, v_dx_695, 0.0]), 0.0)])
	var _t500 = _s145["__p"]["begin"]
	J.cl(_t500, null, [v_ctx_663, v_a_664])
	var _t501 = _s145["__p"]["pushBody"]
	J.cl(_t501, null, [v_ctx_663, _s145["H"], v_lean_694, v_dx_695, 0.0])
	var _t502 = _s145["__p"]["npcBody"]
	J.cl(_t502, null, [v_ctx_663, "npc_auntie", "npc_auntie__bodyH", _s145["H"], v_t_667, {"legF": J.mul((-0.2), v_poke_686), "legB": J.mul(0.15, v_poke_686), "head": (J.mul((-0.06), v_poke_686) + J.mul(0.05, v_pullB_685))}])
	v_fx_697 = J.add(J.gp(v_fist_680, 0.0), v_jab_696)
	v_fy_698 = J.add(J.gp(v_fist_680, 1.0), J.mul(J.mul(_s145["H"], 0.01), v_hold_684))
	var _t503 = _s145["__p"]["piece"]
	J.cl(_t503, null, [v_ctx_663, J.gp(J.G.get("SPR"), "npc_auntie__arm"), _s145["W"], _s145["H"], v_FIST_673, [v_fx_697, v_fy_698], v_th_687])
	var _t504 = _s145["__p"]["rot"]
	v_ub_699 = J.cl(_t504, null, [(-J.num(J.gp(v_axisUp_681, 0.0))), (-J.num(J.gp(v_axisUp_681, 1.0))), v_th_687])
	v_ul_700 = J.hypot_([J.gp(v_ub_699, 0.0), J.gp(v_ub_699, 1.0)])
	var _t505 = J.div(J.gp(v_ub_699, 0.0), v_ul_700)
	J.sp(v_ub_699, 0.0, _t505)
	var _t506 = J.div(J.gp(v_ub_699, 1.0), v_ul_700)
	J.sp(v_ub_699, 1.0, _t506)
	v_sh_701 = J.cl(v_L_679, null, [v_SH_677])
	v_hand0_702 = [J.sub(J.gp(J.cl(v_L_679, null, [v_HAND_678]), 0.0), J.gp(v_sh_701, 0.0)), J.sub(J.gp(J.cl(v_L_679, null, [v_HAND_678]), 1.0), J.gp(v_sh_701, 1.0))]
	v_reach_703 = J.hypot_([J.gp(v_hand0_702, 0.0), J.gp(v_hand0_702, 1.0)])
	v_bestS_704 = 0.0
	v_be_705 = 1000000000.0
	v_s_713 = J.mul(_s145["H"], 0.06)
	while true:
		if not J.cmp(v_s_713, J.mul(_s145["H"], 0.45), "<"): break
		v_p_714 = [J.add(v_fx_697, J.mul(J.gp(v_ub_699, 0.0), v_s_713)), J.add(v_fy_698, J.mul(J.gp(v_ub_699, 1.0), v_s_713))]
		v_e_715 = absf(J.num((J.hypot_([J.sub(J.gp(v_p_714, 0.0), J.gp(v_sh_701, 0.0)), J.sub(J.gp(v_p_714, 1.0), J.gp(v_sh_701, 1.0))]) - J.mul(v_reach_703, 0.95))))
		if J.cmp(v_e_715, v_be_705, "<"):
			v_be_705 = v_e_715
			v_bestS_704 = v_s_713
		var _t507 = J.add(v_s_713, J.mul(_s145["H"], 0.01))
		v_s_713 = _t507
	v_grip_706 = [J.add(v_fx_697, J.mul(J.gp(v_ub_699, 0.0), v_bestS_704)), J.add(v_fy_698, J.mul(J.gp(v_ub_699, 1.0), v_bestS_704))]
	v_ang_707 = (atan2(J.num(J.sub(J.gp(v_grip_706, 1.0), J.gp(v_sh_701, 1.0))), J.num(J.sub(J.gp(v_grip_706, 0.0), J.gp(v_sh_701, 0.0)))) - atan2(J.num(J.gp(v_hand0_702, 1.0)), J.num(J.gp(v_hand0_702, 0.0))))
	var _t508 = _s145["__p"]["rot"]
	v_r_708 = J.cl(_t508, null, [J.gp(v_hand0_702, 0.0), J.gp(v_hand0_702, 1.0), v_ang_707])
	v_fixv_709 = [J.sub(J.gp(v_grip_706, 0.0), J.add(J.gp(v_sh_701, 0.0), J.gp(v_r_708, 0.0))), J.sub(J.gp(v_grip_706, 1.0), J.add(J.gp(v_sh_701, 1.0), J.gp(v_r_708, 1.0)))]
	var _t509 = _s145["__p"]["piece"]
	J.cl(_t509, null, [v_ctx_663, J.gp(J.G.get("SPR"), "npc_auntie__hip"), _s145["W"], _s145["H"], v_SH_677, [J.add(J.gp(v_sh_701, 0.0), J.mul(J.gp(v_fixv_709, 0.0), v_hold_684)), J.add(J.gp(v_sh_701, 1.0), J.mul(J.gp(v_fixv_709, 1.0), v_hold_684))], J.mul(v_ang_707, v_hold_684)])
	var _t510 = _s145["__p"]["rot"]
	v_hv_710 = J.cl(_t510, null, [J.gp(v_headV_688, 0.0), J.gp(v_headV_688, 1.0), v_th_687])
	v_hp_711 = [J.add(v_fx_697, J.gp(v_hv_710, 0.0)), J.add(v_fy_698, J.gp(v_hv_710, 1.0))]
	if J.cmp(v_hold_684, 0.5, ">"):
		v_i_716 = 0.0
		while true:
			if not J.cmp(v_i_716, 3.0, "<"): break
			var _t511 = _s145["__p"]["drip"]
			J.cl(_t511, null, [v_ctx_663, J.add(J.gp(v_hp_711, 0.0), (J.mul(_s145["H"], J.sub(v_i_716, 1.0)) * 0.04)), J.add(J.gp(v_hp_711, 1.0), J.mul(_s145["H"], 0.05)), J.div(J.max_([1.0, (-J.num(J.add(J.gp(v_hp_711, 1.0), J.mul(_s145["H"], 0.05))))]), 1.4), J.mod((J.mul(v_t_667, 1.4) + J.div(v_i_716, 3.0)), 1.0), J.add(v_i_716, 40.0), J.mul(_s145["H"], 0.018)])
			v_i_716 = J.num(v_i_716) + 1.0
	J.mc(v_ctx_663, "restore", [])
	var _t512 = J.cmp(v_g_668, J.sub(_s145["__p"]["HIT"], 0.01), ">=")
	if (J.cmp(v_g_668, 0.75, "<") if _t512 else _t512):
		var _t513 = _s145["__p"]["seg"]
		v_q_717 = J.cl(_t513, null, [v_g_668, J.sub(_s145["__p"]["HIT"], 0.01), 0.72])
		var _t514 = _s145["__p"]["world"]
		v_w_718 = J.cl(_t514, null, [v_a_664, v_want_692, J.sub(J.gp(v_F_669, "y"), J.mul(v_Ht_672, 0.48))])
		J.mc(v_ctx_663, "save", [])
		J.mc(v_ctx_663, "translate", [J.gp(v_w_718, 0.0), J.gp(v_w_718, 1.0)])
		if (not J.t(J.gp(v_a_664, "faceRight"))):
			J.mc(v_ctx_663, "scale", [(-1.0), 1.0])
		J.mc(v_ctx_663, "rotate", [(J.div(_s145["__p"]["PI"], 2.0) + 0.2)])
		var _t515 = _s145["__p"]["splash"]
		J.cl(_t515, null, [v_ctx_663, 0.0, 0.0, J.mul(v_Ht_672, 0.5), v_q_717, 12.0, 31.3, 0.8])
		J.mc(v_ctx_663, "restore", [])
	var _t516 = J.cmp(v_g_668, _s145["__p"]["HIT"], ">=")
	if (J.cmp(v_g_668, J.add(_s145["__p"]["HIT"], 0.02), "<") if _t516 else _t516):
		var _t517 = _s145["__p"]["world"]
		var _t518 = J.cl(_t517, null, [v_a_664, v_want_692, J.sub(J.gp(v_F_669, "y"), J.mul(v_Ht_672, 0.48))])
		J.sp(v_o_665, "hitP", _t518)
	return true

func _f71(this_, a: Array, env):
	var v_p_755 = null
	v_p_755 = J.arg(a, 0)
	return [J.mul(J.sub(J.gp(v_p_755, 0.0), 0.5), env["W"]), ((-J.num(env["H"])) + J.mul(J.gp(v_p_755, 1.0), env["H"]))]

func _f72(this_, a: Array, env):
	var v_k_756 = null; var v_A_757 = null; var v_B_758 = null
	v_k_756 = J.arg(a, 0)
	var _t535 = env["L"]
	v_A_757 = J.cl(_t535, null, [env["SH"]])
	var _t536 = env["L"]
	v_B_758 = J.cl(_t536, null, [env["SHF"]])
	var _t537 = env["__p"]["lerp"]
	var _t539 = J.cl(_t537, null, [J.gp(v_A_757, 0.0), J.gp(v_B_758, 0.0), v_k_756])
	var _t538 = env["__p"]["lerp"]
	return [_t539, J.cl(_t538, null, [J.gp(v_A_757, 1.0), J.gp(v_B_758, 1.0), v_k_756])]

func _f73(this_, a: Array, env):
	var v_h_759 = null
	v_h_759 = J.arg(a, 0)
	var _t547 = env["__p"]["bump"]
	return J.cl(_t547, null, [env["g"], v_h_759, J.add(v_h_759, 0.015), J.add(v_h_759, 0.1)])

func _f74(this_, a: Array, env):
	var v_ch_764 = null; var v_i_765 = null; var v_hitG_766 = null; var v_st_767 = null; var v_fly_768 = null; var v_aft_769 = null; var v_end_770 = null; var v_e_771 = null; var v_x_772 = null; var v_y_773 = null; var v_s_774 = null; var v_r_775 = null; var v_sx_776 = null; var v_sy_777 = null; var v_al_778 = null; var v_pk_779 = null; var v_j_780 = null; var v_an_781 = null; var v_r0_782 = null; var v_r1_783 = null
	v_ch_764 = J.arg(a, 0)
	v_i_765 = J.arg(a, 1)
	v_hitG_766 = J.gp(env["__p"]["BOSS_HITS"], v_i_765)
	v_st_767 = J.sub(v_hitG_766, 0.13)
	if J.cmp(env["g"], v_st_767, "<"):
		return null
	var _t565 = env["__p"]["seg"]
	v_fly_768 = J.cl(_t565, null, [env["g"], v_st_767, v_hitG_766])
	var _t566 = env["__p"]["seg"]
	v_aft_769 = J.cl(_t566, null, [env["g"], v_hitG_766, J.add(v_hitG_766, 0.14)])
	if J.cmp(v_aft_769, 1.0, ">="):
		return null
	v_end_770 = [J.add(J.gp(env["tgt"], 0.0), J.mul(env["Ht"], (0.06 + J.mul(v_i_765, 0.03)))), J.add(J.gp(env["tgt"], 1.0), J.mul(env["Ht"], ((-0.08) + J.mul(v_i_765, 0.12))))]
	var _t567 = env["__p"]["ei"]
	v_e_771 = (J.mul(J.cl(_t567, null, [v_fly_768]), 0.6) + J.mul(v_fly_768, 0.4))
	var _t568 = env["__p"]["lerp"]
	v_x_772 = J.cl(_t568, null, [J.sub(J.gp(env["m"], 0.0), J.mul(env["H"], 0.2)), J.gp(v_end_770, 0.0), v_e_771])
	var _t569 = env["__p"]["lerp"]
	v_y_773 = J.sub(J.cl(_t569, null, [J.sub(J.gp(env["m"], 1.0), J.mul(env["H"], 0.12)), J.gp(v_end_770, 1.0), v_e_771]), (J.mul(sin(J.num(J.mul(v_fly_768, env["__p"]["PI"]))), env["H"]) * 0.14))
	var _t572 = env["S0"]
	var _t570 = env["__p"]["backOut"]
	var _t571 = env["__p"]["cl"]
	v_s_774 = J.mul(_t572, (0.35 + J.mul(0.65, J.cl(_t570, null, [J.cl(_t571, null, [J.mul(v_fly_768, 2.2)])]))))
	v_r_775 = ((sin(J.num((J.mul(env["t"], 18.0) + J.mul(v_i_765, 2.0)))) * 0.16) - 0.1)
	v_sx_776 = 1.0
	v_sy_777 = 1.0
	v_al_778 = 1.0
	if J.cmp(v_aft_769, 0.0, ">"):
		var _t573 = (1.0 + ((0.5 * J.sub(1.0, v_aft_769)) * (J.div(v_aft_769, 0.3) if J.cmp(v_aft_769, 0.3, "<") else 1.0)))
		v_sx_776 = _t573
		var _t574 = (1.0 - (0.35 * J.sub(1.0, v_aft_769)))
		v_sy_777 = _t574
		var _t576 = J.mul(env["H"], 0.25)
		var _t575 = env["__p"]["eo"]
		var _t577 = J.add(v_x_772, (J.mul(_t576, J.cl(_t575, null, [v_aft_769])) * 0.5))
		v_x_772 = _t577
		var _t579 = J.mul(env["H"], 0.3)
		var _t578 = env["__p"]["eo"]
		var _t580 = J.sub(v_y_773, (J.mul(_t579, J.cl(_t578, null, [v_aft_769])) - J.mul(J.mul(J.mul(env["H"], 0.4), v_aft_769), v_aft_769)))
		v_y_773 = _t580
		var _t581 = J.add(v_r_775, J.mul(v_aft_769, 2.0))
		v_r_775 = _t581
		var _t582 = env["__p"]["ei"]
		var _t583 = J.sub(1.0, J.cl(_t582, null, [v_aft_769]))
		v_al_778 = _t583
	J.mc(env["ctx"], "save", [])
	J.mc(env["ctx"], "translate", [v_x_772, v_y_773])
	if J.t(J.gp(env["a"], "faceRight")):
		J.mc(env["ctx"], "scale", [(-1.0), 1.0])
	J.mc(env["ctx"], "rotate", [v_r_775])
	J.mc(env["ctx"], "scale", [v_sx_776, v_sy_777])
	var _t584 = env["ctx"]
	var _t585 = J.mul(J.gp(_t584, "globalAlpha"), v_al_778)
	J.sp(_t584, "globalAlpha", _t585)
	var _t586 = env["__p"]["glyph"]
	J.mc(env["ctx"], "drawImage", [J.cl(_t586, null, [v_ch_764, "#ff5a3a", "#ffcf3a"]), J.div((-J.num(v_s_774)), 2.0), J.div((-J.num(v_s_774)), 2.0), v_s_774, v_s_774])
	J.mc(env["ctx"], "restore", [])
	var _t587 = env["__p"]["bump"]
	v_pk_779 = J.cl(_t587, null, [env["g"], v_hitG_766, J.add(v_hitG_766, 0.01), J.add(v_hitG_766, 0.08)])
	if J.cmp(v_pk_779, 0.0, ">"):
		J.mc(env["ctx"], "save", [])
		var _t588 = env["ctx"]
		var _t589 = J.mul(J.gp(_t588, "globalAlpha"), v_pk_779)
		J.sp(_t588, "globalAlpha", _t589)
		v_j_780 = 0.0
		while true:
			if not J.cmp(v_j_780, 8.0, "<"): break
			v_an_781 = J.add((J.mul(J.div(v_j_780, 8.0), env["__p"]["PI"]) * 2.0), v_i_765)
			v_r0_782 = J.mul(env["Ht"], 0.08)
			v_r1_783 = J.mul(env["Ht"], (0.14 + (0.1 * J.sub(1.0, v_pk_779))))
			var _t590 = env["__p"]["crayonLine"]
			J.cl(_t590, null, [env["ctx"], [[J.add(J.gp(v_end_770, 0.0), J.mul(cos(J.num(v_an_781)), v_r0_782)), J.add(J.gp(v_end_770, 1.0), J.mul(sin(J.num(v_an_781)), v_r0_782))], [J.add(J.gp(v_end_770, 0.0), J.mul(cos(J.num(v_an_781)), v_r1_783)), J.add(J.gp(v_end_770, 1.0), J.mul(sin(J.num(v_an_781)), v_r1_783))]], J.max_([1.5, J.mul(env["Ht"], 0.02)]), "#ffe58a", "rgba(80,20,0,.8)"])
			v_j_780 = J.num(v_j_780) + 1.0
		J.mc(env["ctx"], "restore", [])

func _f70(this_, a: Array, env):
	var v_o_723 = null; var v_F_727 = null; var v_img_728 = null; var v_HAND_732 = null; var v_MOUTH_733 = null; var v_point_735 = null; var v_yell_736 = null; var v_lean_737 = null; var v_dx_738 = null; var v_aim_740 = null; var v_shP_742 = null; var v_xf_743 = null; var v_shL_744 = null; var v_sh_745 = null; var v_hd_746 = null; var v_sh0_747 = null; var v_ang0_748 = null; var v_want_749 = null; var v_dA_750 = null; var v_jolt_751 = null; var v_CH_753 = null; var v_i_760 = null; var v_an_761 = null; var v_r0_762 = null; var v_r1_763 = null; var v_h_784 = null
	var _s152 = {"__p": env, "ctx": null, "a": null, "H": null, "t": null, "g": null, "W": null, "Ht": null, "SH": null, "L": null, "tgt": null, "SHF": null, "m": null, "S0": null}
	_s152["ctx"] = J.arg(a, 0)
	_s152["a"] = J.arg(a, 1)
	var _t521 = _s152["__p"]["ok"]
	var _t523 = (not J.t(J.cl(_t521, null, ["npc_boss__bodyP"])))
	if not J.t(_t523):
		var _t522 = _s152["__p"]["ok"]
		_t523 = (not J.t(J.cl(_t522, null, ["npc_boss__point"])))
	if _t523:
		return false
	v_o_723 = J.gp(_s152["a"], "o")
	_s152["H"] = J.gp(_s152["a"], "H")
	var _t524 = J.gp(v_o_723, "t")
	_s152["t"] = (_t524 if J.t(_t524) else 0.0)
	var _t525 = _s152["__p"]["prog"]
	_s152["g"] = J.cl(_t525, null, [v_o_723])
	var _t526 = _s152["__p"]["foe"]
	v_F_727 = J.cl(_t526, null, [_s152["a"], 1.2])
	v_img_728 = J.gp(J.G.get("SPR"), "npc_boss__bodyP")
	_s152["W"] = J.div(J.mul(_s152["H"], J.gp(v_img_728, "naturalWidth")), J.gp(v_img_728, "naturalHeight"))
	_s152["Ht"] = J.gp(v_F_727, "h")
	_s152["SH"] = [0.775, 0.475]
	v_HAND_732 = [0.835, 0.75]
	v_MOUTH_733 = [0.39, 0.315]
	_s152["L"] = Callable(self, "_f71").bind(_s152)
	var _t531 = null
	if J.cmp(_s152["g"], 0.6, "<"):
		var _t527 = _s152["__p"]["backOut"]
		var _t528 = _s152["__p"]["seg"]
		_t531 = J.cl(_t527, null, [J.cl(_t528, null, [_s152["g"], 0.04, 0.26])])
	else:
		var _t529 = _s152["__p"]["eio"]
		var _t530 = _s152["__p"]["seg"]
		_t531 = J.sub(1.0, J.cl(_t529, null, [J.cl(_t530, null, [_s152["g"], 0.84, 1.0])]))
	v_point_735 = _t531
	var _t532 = _s152["__p"]["bump"]
	v_yell_736 = J.cl(_t532, null, [_s152["g"], 0.26, 0.32, 0.86])
	var _t534 = J.mul(J.mul((-6.0), _s152["__p"]["D"]), v_point_735)
	var _t533 = J.cmp(_s152["g"], 0.26, ">")
	v_lean_737 = (_t534 + ((J.mul((-3.0), _s152["__p"]["D"]) * absf(J.num(sin(J.num((J.sub(_s152["g"], 0.26) * 26.0)))))) if (J.cmp(_s152["g"], 0.86, "<") if _t533 else _t533) else 0.0))
	v_dx_738 = J.mul(((-J.num(_s152["H"])) * 0.04), v_point_735)
	_s152["tgt"] = [J.add(J.gp(v_F_727, "x"), J.mul(_s152["Ht"], 0.05)), J.sub(J.gp(v_F_727, "y"), J.mul(_s152["Ht"], 0.62))]
	v_aim_740 = [J.add(J.gp(v_F_727, "x"), J.mul(_s152["Ht"], 0.05)), J.sub(J.gp(v_F_727, "y"), J.mul(_s152["Ht"], 0.42))]
	_s152["SHF"] = [0.38, 0.45]
	v_shP_742 = Callable(self, "_f72").bind(_s152)
	var _t540 = _s152["__p"]["bodyXf"]
	v_xf_743 = J.cl(_t540, null, [_s152["H"], v_lean_737, v_dx_738, 0.0])
	var _t541 = _s152["__p"]["cl"]
	v_shL_744 = J.cl(v_shP_742, null, [J.cl(_t541, null, [v_point_735])])
	v_sh_745 = J.cl(v_xf_743, null, J.spread([J.SP(v_shL_744)]))
	var _t542 = _s152["L"]
	v_hd_746 = J.cl(_t542, null, [v_HAND_732])
	var _t543 = _s152["L"]
	v_sh0_747 = J.cl(_t543, null, [_s152["SH"]])
	v_ang0_748 = atan2(J.num(J.sub(J.gp(v_hd_746, 1.0), J.gp(v_sh0_747, 1.0))), J.num(J.sub(J.gp(v_hd_746, 0.0), J.gp(v_sh0_747, 0.0))))
	v_want_749 = J.sub(atan2(J.num(J.sub(J.gp(v_aim_740, 1.0), J.gp(v_sh_745, 1.0))), J.num(J.sub(J.gp(v_aim_740, 0.0), J.gp(v_sh_745, 0.0)))), v_lean_737)
	v_dA_750 = J.sub(v_want_749, v_ang0_748)
	while true:
		if not J.cmp(v_dA_750, 0.0, "<"): break
		var _t544 = J.add(v_dA_750, J.mul(_s152["__p"]["PI"], 2.0))
		v_dA_750 = _t544
	while true:
		if not J.cmp(v_dA_750, J.mul(_s152["__p"]["PI"], 2.0), ">"): break
		var _t545 = J.sub(v_dA_750, J.mul(_s152["__p"]["PI"], 2.0))
		v_dA_750 = _t545
	var _t546 = J.cmp(_s152["g"], 0.26, ">")
	v_jolt_751 = (J.mul((sin(J.num((J.sub(_s152["g"], 0.26) * 40.0))) * 0.08), v_yell_736) if (J.cmp(_s152["g"], 0.86, "<") if _t546 else _t546) else 0.0)
	var _t548 = {"shake": J.max_(J.spread([J.SP(J.mc(_s152["__p"]["BOSS_HITS"], "map", [Callable(self, "_f73").bind(_s152)]))]))}
	J.sp(v_o_723, "vic", _t548)
	var _t549 = _s152["__p"]["world"]
	J.mc(_s152["a"], "shadow", [J.gp(J.cl(_t549, null, [_s152["a"], v_dx_738, 0.0]), 0.0)])
	var _t550 = _s152["__p"]["begin"]
	J.cl(_t550, null, [_s152["ctx"], _s152["a"]])
	J.mc(_s152["ctx"], "save", [])
	var _t551 = _s152["__p"]["pushBody"]
	J.cl(_t551, null, [_s152["ctx"], _s152["H"], v_lean_737, v_dx_738, 0.0])
	var _t552 = _s152["__p"]["npcBody"]
	J.cl(_t552, null, [_s152["ctx"], "npc_boss", "npc_boss__bodyP", _s152["H"], _s152["t"], {"head": J.sub(J.mul((-0.16), v_yell_736), v_jolt_751), "body": J.mul((-0.04), v_yell_736), "sy": (1.0 + J.mul(0.03, v_yell_736)), "legF": J.mul((-0.1), v_point_735), "legB": J.mul(0.08, v_point_735)}])
	var _t553 = _s152["__p"]["piece"]
	var _t555 = _s152["ctx"]
	var _t556 = J.gp(J.G.get("SPR"), "npc_boss__point")
	var _t557 = _s152["W"]
	var _t558 = _s152["H"]
	var _t559 = _s152["SH"]
	var _t560 = (J.mul(v_dA_750, v_point_735) + J.mul((sin(J.num(J.mul(_s152["t"], 30.0))) * 0.03), v_yell_736))
	var _t554 = _s152["__p"]["cl"]
	J.cl(_t553, null, [_t555, _t556, _t557, _t558, _t559, v_shL_744, _t560, (1.0 + J.mul(0.1, J.cl(_t554, null, [v_point_735])))])
	J.mc(_s152["ctx"], "restore", [])
	var _t561 = _s152["L"]
	_s152["m"] = J.cl(v_xf_743, null, J.spread([J.SP(J.cl(_t561, null, [v_MOUTH_733]))]))
	if J.cmp(v_yell_736, 0.0, ">"):
		J.mc(_s152["ctx"], "save", [])
		var _t562 = _s152["ctx"]
		var _t563 = J.mul(J.gp(_t562, "globalAlpha"), v_yell_736)
		J.sp(_t562, "globalAlpha", _t563)
		v_i_760 = 0.0
		while true:
			if not J.cmp(v_i_760, 6.0, "<"): break
			v_an_761 = (J.sub(J.add(_s152["__p"]["PI"], 0.95), J.mul(v_i_760, 0.24)) + (sin(J.num(J.add(J.mul(_s152["t"], 40.0), v_i_760))) * 0.05))
			v_r0_762 = J.mul(_s152["H"], 0.2)
			v_r1_763 = (J.mul(_s152["H"], (0.3 + (0.07 * J.mod(v_i_760, 2.0)))) * (0.8 + (0.2 * sin(J.num((J.mul(_s152["t"], 50.0) + J.mul(v_i_760, 2.0)))))))
			var _t564 = _s152["__p"]["crayonLine"]
			J.cl(_t564, null, [_s152["ctx"], [[J.add(J.gp(_s152["m"], 0.0), J.mul(cos(J.num(v_an_761)), v_r0_762)), J.add(J.gp(_s152["m"], 1.0), J.mul(sin(J.num(v_an_761)), v_r0_762))], [J.add(J.gp(_s152["m"], 0.0), J.mul(cos(J.num(v_an_761)), v_r1_763)), J.add(J.gp(_s152["m"], 1.0), J.mul(sin(J.num(v_an_761)), v_r1_763))]], J.max_([1.5, J.mul(_s152["H"], 0.02)]), "#fff6d8", "rgba(60,20,10,.85)"])
			v_i_760 = J.num(v_i_760) + 1.0
		J.mc(_s152["ctx"], "restore", [])
	v_CH_753 = ["扣", "工", "資"]
	_s152["S0"] = J.mul(_s152["H"], 0.3)
	J.mc(v_CH_753, "forEach", [Callable(self, "_f74").bind(_s152)])
	J.mc(_s152["ctx"], "restore", [])
	for _t591 in J.iter(_s152["__p"]["BOSS_HITS"]):
		v_h_784 = _t591
		var _t592 = J.cmp(_s152["g"], v_h_784, ">=")
		if (J.cmp(_s152["g"], J.add(v_h_784, 0.02), "<") if _t592 else _t592):
			var _t593 = _s152["__p"]["world"]
			var _t594 = J.cl(_t593, null, [_s152["a"], J.gp(_s152["tgt"], 0.0), J.gp(_s152["tgt"], 1.0)])
			J.sp(v_o_723, "hitP", _t594)
	return true

func _f1(this_, a: Array, env):
	var v_R_23 = null
	var _s2 = {"__p": env, "PI": null, "D": null, "cl": null, "lerp": null, "eo": null, "ei": null, "eio": null, "eo3": null, "backOut": null, "seg": null, "bump": null, "ok": null, "HIT": null, "prog": null, "foe": null, "rot": null, "begin": null, "world": null, "floatY": null, "base": null, "pz": null, "upright": null, "rnd": null, "tri": null, "resample": null, "normals": null, "ribbon": null, "GLY": null, "glyph": null, "smallText": null, "crayonLine": null, "puddle": null, "splash": null, "slash": null, "drip": null, "streaks": null, "dust": null, "PT_SRC": null, "npcBody": null, "piece": null, "LEANY": null, "bodyXf": null, "pushBody": null, "GD": null, "teaDrops": null, "steam": null, "clank": null, "burst": null, "star": null, "BOSS_HITS": null}
	_s2["prog"] = Callable(self, "_f12").bind(_s2)
	_s2["foe"] = Callable(self, "_f13").bind(_s2)
	_s2["tri"] = Callable(self, "_f22").bind(_s2)
	_s2["resample"] = Callable(self, "_f24").bind(_s2)
	_s2["ribbon"] = Callable(self, "_f27").bind(_s2)
	_s2["glyph"] = Callable(self, "_f28").bind(_s2)
	_s2["smallText"] = Callable(self, "_f29").bind(_s2)
	_s2["crayonLine"] = Callable(self, "_f31").bind(_s2)
	_s2["puddle"] = Callable(self, "_f34").bind(_s2)
	_s2["splash"] = Callable(self, "_f36").bind(_s2)
	_s2["slash"] = Callable(self, "_f37").bind(_s2)
	_s2["drip"] = Callable(self, "_f38").bind(_s2)
	_s2["streaks"] = Callable(self, "_f39").bind(_s2)
	_s2["dust"] = Callable(self, "_f40").bind(_s2)
	_s2["npcBody"] = Callable(self, "_f54").bind(_s2)
	_s2["piece"] = Callable(self, "_f55").bind(_s2)
	_s2["teaDrops"] = Callable(self, "_f59").bind(_s2)
	_s2["steam"] = Callable(self, "_f60").bind(_s2)
	_s2["clank"] = Callable(self, "_f61").bind(_s2)
	_s2["burst"] = Callable(self, "_f63").bind(_s2)
	_s2["star"] = Callable(self, "_f67").bind(_s2)
	_s2["PI"] = PI
	_s2["D"] = J.div(_s2["PI"], 180.0)
	_s2["cl"] = Callable(self, "_f2").bind(_s2)
	_s2["lerp"] = Callable(self, "_f3").bind(_s2)
	_s2["eo"] = Callable(self, "_f4").bind(_s2)
	_s2["ei"] = Callable(self, "_f5").bind(_s2)
	_s2["eio"] = Callable(self, "_f6").bind(_s2)
	_s2["eo3"] = Callable(self, "_f7").bind(_s2)
	_s2["backOut"] = Callable(self, "_f8").bind(_s2)
	_s2["seg"] = Callable(self, "_f9").bind(_s2)
	_s2["bump"] = Callable(self, "_f10").bind(_s2)
	_s2["ok"] = Callable(self, "_f11").bind(_s2)
	_s2["HIT"] = (0.4 + (0.2 * 0.42))
	_s2["rot"] = Callable(self, "_f14").bind(_s2)
	_s2["begin"] = Callable(self, "_f15").bind(_s2)
	_s2["world"] = Callable(self, "_f16").bind(_s2)
	_s2["floatY"] = Callable(self, "_f17").bind(_s2)
	_s2["base"] = Callable(self, "_f18").bind(_s2)
	_s2["pz"] = Callable(self, "_f19").bind(_s2)
	_s2["upright"] = Callable(self, "_f20").bind(_s2)
	v_R_23 = 1.0
	_s2["rnd"] = Callable(self, "_f21").bind(_s2)
	_s2["normals"] = Callable(self, "_f25").bind(_s2)
	_s2["GLY"] = {}
	_s2["PT_SRC"] = [[0.3, 0.14], [0.22, 0.27], [0.15, 0.4], [0.11, 0.52], [0.11, 0.64], [0.15, 0.76]]
	var _t140 = J.G.get("MOVES")
	var _t183 = Callable(self, "_f41").bind(_s2)
	J.sp(_t140, "pontianak", _t183)
	var _t184 = J.G.get("MOVES")
	var _t263 = Callable(self, "_f51").bind(_s2)
	J.sp(_t184, "shuigui", _t263)
	var _t264 = J.G.get("MOVES")
	var _t361 = Callable(self, "_f53").bind(_s2)
	J.sp(_t264, "tianhua", _t361)
	_s2["LEANY"] = 0.3
	_s2["bodyXf"] = Callable(self, "_f56").bind(_s2)
	_s2["pushBody"] = Callable(self, "_f58").bind(_s2)
	_s2["GD"] = {"PV": [0.882, 0.4565], "TIP": [0.752, 0.725]}
	var _t363 = J.G.get("MOVES")
	var _t467 = Callable(self, "_f64").bind(_s2)
	J.sp(_t363, "npc_guard", _t467)
	var _t468 = J.G.get("MOVES")
	var _t519 = Callable(self, "_f68").bind(_s2)
	J.sp(_t468, "npc_auntie", _t519)
	_s2["BOSS_HITS"] = [_s2["HIT"], 0.6, 0.72]
	var _t520 = J.G.get("MOVES")
	var _t595 = Callable(self, "_f70").bind(_s2)
	J.sp(_t520, "npc_boss", _t595)
	var _t596 = J.gp(J.G.get("MOVES"), "npc_boss")
	var _t597 = _s2["BOSS_HITS"]
	J.sp(_t596, "hits", _t597)
