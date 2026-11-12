# 自動轉譯自 daily_plaza.js（tools/jsgd.js）——唔好直接改，改原 JS 再轉
extends RefCounted

func run(env):
	var this_ = null; var a = []
	J.G["PlazaLife"] = J.cl(Callable(self, "_f1").bind(env), null, [])

func _f12(this_, a: Array, env):
	var v_o_108 = null; var v_type_109 = null; var v_A_110 = null; var v_t_111 = null; var v_w_112 = null; var v_I_113 = null; var v_run_114 = null; var v_Wk_115 = null; var v_P_116 = null; var v_k_117 = null; var v_k_118 = null
	v_o_108 = J.arg(a, 0)
	v_type_109 = J.arg(a, 1)
	v_A_110 = J.gp(J.G.get("MeshAnim"), "ANIM")
	var _t1 = J.gp(v_o_108, "t")
	v_t_111 = (_t1 if J.t(_t1) else 0.0)
	var _t2 = env["cl"]
	var _t3 = J.gp(v_o_108, "w")
	v_w_112 = J.cl(_t2, null, [(_t3 if J.t(_t3) else 0.0)])
	v_I_113 = J.mc(v_A_110, "idle", [v_t_111])
	var _t4 = J.gp(env["HOPPER"], v_type_109)
	if J.t((_t4 if J.t(_t4) else J.cmp(v_w_112, 0.001, "<="))):
		return v_I_113
	var _t5 = J.gp(v_o_108, "run")
	v_run_114 = (_t5 if J.t(_t5) else 0.0)
	var _t6 = J.gp(v_o_108, "wph")
	v_Wk_115 = J.mc(v_A_110, "walk", [(_t6 if J.t(_t6) else 0.0)])
	if J.t(v_run_114):
		var _t7 = J.mul(J.gp(v_Wk_115, "legF"), (1.0 + J.mul(0.5, v_run_114)))
		J.sp(v_Wk_115, "legF", _t7)
		var _t8 = J.mul(J.gp(v_Wk_115, "legB"), (1.0 + J.mul(0.5, v_run_114)))
		J.sp(v_Wk_115, "legB", _t8)
		var _t9 = J.mul(J.gp(v_Wk_115, "armF"), (1.0 + J.mul(0.7, v_run_114)))
		J.sp(v_Wk_115, "armF", _t9)
		var _t10 = J.mul(J.gp(v_Wk_115, "armB"), (1.0 + J.mul(0.7, v_run_114)))
		J.sp(v_Wk_115, "armB", _t10)
		var _t11 = J.add(J.gp(v_Wk_115, "body"), J.mul(0.07, v_run_114))
		J.sp(v_Wk_115, "body", _t11)
	if J.t(J.gp(v_o_108, "stiff")):
		var _t12 = J.mul(J.gp(v_Wk_115, "armF"), 0.35)
		J.sp(v_Wk_115, "armF", _t12)
		var _t13 = J.mul(J.gp(v_Wk_115, "armB"), 0.35)
		J.sp(v_Wk_115, "armB", _t13)
		J.sp(v_Wk_115, "body", 0.03)
		J.sp(v_Wk_115, "head", 0.0)
	v_P_116 = {}
	for _t14 in J.keys(v_I_113):
		v_k_117 = _t14
		var _t15 = J.gp(v_I_113, v_k_117)
		J.sp(v_P_116, v_k_117, _t15)
	for _t16 in J.keys(v_Wk_115):
		v_k_118 = _t16
		var _t17 = env["lerp"]
		var _t18 = J.cl(_t17, null, [(J.gp(v_I_113, v_k_118) if (not J.leq(J.gp(v_I_113, v_k_118), null)) else 0.0), J.gp(v_Wk_115, v_k_118), v_w_112])
		J.sp(v_P_116, v_k_118, _t18)
	return v_P_116

func _f13(this_, a: Array, env):
	var v_p_121 = null; var v_d_122 = null; var v_k_123 = null
	v_p_121 = J.arg(a, 0)
	v_d_122 = J.arg(a, 1)
	for _t19 in J.keys(v_d_122):
		v_k_123 = _t19
		var _t20 = J.seq(v_k_123, "sx")
		if (_t20 if _t20 else J.seq(v_k_123, "sy")):
			var _t21 = J.mul((1.0 if J.leq(J.gp(v_p_121, v_k_123), null) else J.gp(v_p_121, v_k_123)), J.gp(v_d_122, v_k_123))
			J.sp(v_p_121, v_k_123, _t21)
		else:
			var _t22 = J.gp(v_p_121, v_k_123)
			var _t23 = J.add((_t22 if J.t(_t22) else 0.0), J.gp(v_d_122, v_k_123))
			J.sp(v_p_121, v_k_123, _t23)
	return v_p_121

func _f15(this_, a: Array, env):
	var v_ctx_127 = null; var v_a_128 = null; var v_lift_129 = null; var v_k_130 = null; var v_sk_131 = null
	v_ctx_127 = J.arg(a, 0)
	v_a_128 = J.arg(a, 1)
	v_lift_129 = J.arg(a, 2)
	v_k_130 = J.arg(a, 3)
	var _t25 = J.mul((1.0 if J.t(J.gp(v_a_128, "solid")) else 0.8), (1.0 if J.leq(v_k_130, null) else v_k_130))
	var _t24 = env["cl"]
	v_sk_131 = (_t25 * (1.0 - J.mul(0.5, J.cl(_t24, null, [J.div(v_lift_129, J.mul(J.gp(v_a_128, "H"), 0.9))]))))
	J.mc(v_ctx_127, "save", [])
	if (not J.t(J.gp(v_a_128, "solid"))):
		var _t26 = J.mul(J.gp(v_ctx_127, "globalAlpha"), 0.55)
		J.sp(v_ctx_127, "globalAlpha", _t26)
	var _t27 = env["cl"]
	var _t28 = J.mul(J.gp(v_ctx_127, "globalAlpha"), (1.0 - J.mul(0.4, J.cl(_t27, null, [J.div(v_lift_129, J.mul(J.gp(v_a_128, "H"), 0.9))]))))
	J.sp(v_ctx_127, "globalAlpha", _t28)
	J.mc(v_a_128, "shadow", [J.gp(v_a_128, "x"), v_sk_131])
	J.mc(v_ctx_127, "restore", [])

func _f16(this_, a: Array, env):
	var v_ctx_134 = null; var v_a_135 = null; var v_P_136 = null; var v_lift_137 = null; var v_shK_138 = null
	v_ctx_134 = J.arg(a, 0)
	v_a_135 = J.arg(a, 1)
	v_P_136 = J.arg(a, 2)
	v_lift_137 = J.arg(a, 3)
	v_shK_138 = J.arg(a, 4)
	var _t29 = (v_lift_137 if J.t(v_lift_137) else 0.0)
	v_lift_137 = _t29
	var _t30 = env["shadowAt"]
	J.cl(_t30, null, [v_ctx_134, v_a_135, v_lift_137, v_shK_138])
	var _t33 = J.gp(v_a_135, "type")
	var _t34 = J.gp(v_a_135, "x")
	var _t32 = J.gp(v_a_135, "y")
	var _t31 = env["floatY"]
	J.mc(J.G.get("MeshAnim"), "draw", [v_ctx_134, _t33, _t34, J.sub(J.sub(_t32, J.cl(_t31, null, [v_a_135])), v_lift_137), J.gp(v_a_135, "H"), v_P_136, J.gp(v_a_135, "faceRight")])

func _f17(this_, a: Array, env):
	var v_a_141 = null; var v_u_142 = null; var v_v_143 = null; var v_lift_144 = null; var v_img_145 = null; var v_W_146 = null; var v_nr_147 = null; var v_flip_148 = null
	v_a_141 = J.arg(a, 0)
	v_u_142 = J.arg(a, 1)
	v_v_143 = J.arg(a, 2)
	v_lift_144 = J.arg(a, 3)
	v_img_145 = J.gp(J.G.get("SPR"), J.gp(v_a_141, "type"))
	v_W_146 = J.div(J.mul(J.gp(v_a_141, "H"), J.gp(v_img_145, "naturalWidth")), J.gp(v_img_145, "naturalHeight"))
	v_nr_147 = (not (not J.t(J.gp(J.gp(J.G.get("MeshAnim"), "NATIVE_R"), J.gp(v_a_141, "type")))))
	v_flip_148 = (not J.seq(J.gp(v_a_141, "faceRight"), v_nr_147))
	var _t37 = J.add(J.gp(v_a_141, "x"), J.mul((((-1.0) if J.t(v_flip_148) else 1.0) * J.sub(v_u_142, 0.5)), v_W_146))
	var _t36 = J.gp(v_a_141, "y")
	var _t35 = env["floatY"]
	return [_t37, (J.sub(J.sub(J.sub(_t36, J.cl(_t35, null, [v_a_141])), (v_lift_144 if J.t(v_lift_144) else 0.0)), J.gp(v_a_141, "H")) + J.mul(v_v_143, J.gp(v_a_141, "H")))]

func _f19(this_, a: Array, env):
	var v_x_157 = null; var v_y_158 = null; var v_i_159 = null; var v_j_160 = null; var v_jx_161 = null; var v_jy_162 = null
	var _t45 = J.gp(J.arg(a, 0), 0.0)
	v_x_157 = _t45
	var _t46 = J.gp(J.arg(a, 0), 1.0)
	v_y_158 = _t46
	v_i_159 = J.arg(a, 1)
	v_j_160 = (J.mul(env["__p"]["w"], 0.35) if J.t(env["p"]) else 0.0)
	var _t47 = env["__p"]["__p"]["hash"]
	v_jx_161 = J.mul(J.sub(J.cl(_t47, null, [J.add(J.mul(v_i_159, 3.1), env["p"])]), 0.5), v_j_160)
	var _t48 = env["__p"]["__p"]["hash"]
	v_jy_162 = J.mul(J.sub(J.cl(_t48, null, [J.add(J.mul(v_i_159, 5.7), env["p"])]), 0.5), v_j_160)
	if J.t(v_i_159):
		J.mc(env["__p"]["ctx"], "lineTo", [J.add(v_x_157, v_jx_161), J.add(v_y_158, v_jy_162)])
	else:
		J.mc(env["__p"]["ctx"], "moveTo", [J.add(v_x_157, v_jx_161), J.add(v_y_158, v_jy_162)])

func _f18(this_, a: Array, env):
	var v_pts_152 = null; var v_col_154 = null; var v_g0_155 = null
	var _s25 = {"__p": env, "ctx": null, "w": null}
	_s25["ctx"] = J.arg(a, 0)
	v_pts_152 = J.arg(a, 1)
	_s25["w"] = J.arg(a, 2)
	v_col_154 = J.arg(a, 3)
	J.mc(_s25["ctx"], "save", [])
	var _t38 = _s25["ctx"]
	J.sp(_t38, "lineCap", "round")
	var _t39 = _s25["ctx"]
	J.sp(_t39, "lineJoin", "round")
	var _t40 = _s25["ctx"]
	J.sp(_t40, "strokeStyle", v_col_154)
	v_g0_155 = J.gp(_s25["ctx"], "globalAlpha")
	var _s26 = {"__p": _s25, "p": null}
	_s26["p"] = 0.0
	while true:
		_s26 = _s26.duplicate()
		if not J.cmp(_s26["p"], 2.0, "<"): break
		var _t41 = _s26["__p"]["ctx"]
		var _t42 = J.mul(v_g0_155, (0.5 if J.t(_s26["p"]) else 1.0))
		J.sp(_t41, "globalAlpha", _t42)
		var _t43 = _s26["__p"]["ctx"]
		var _t44 = J.mul(_s26["__p"]["w"], (0.55 if J.t(_s26["p"]) else 1.0))
		J.sp(_t43, "lineWidth", _t44)
		J.mc(_s26["__p"]["ctx"], "beginPath", [])
		J.mc(v_pts_152, "forEach", [Callable(self, "_f19").bind(_s26)])
		J.mc(_s26["__p"]["ctx"], "stroke", [])
		_s26["p"] = J.num(_s26["p"]) + 1.0
	J.mc(_s25["ctx"], "restore", [])

func _f20(this_, a: Array, env):
	var v_ctx_165 = null; var v_x_166 = null; var v_y_167 = null; var v_t_168 = null; var v_s_169 = null; var v_n_170 = null; var v_k_171 = null; var v_push_172 = null; var v_i_173 = null; var v_ph_174 = null; var v_al_175 = null; var v_pts_176 = null; var v_x0_177 = null; var v_j_178 = null; var v_q_179 = null; var v_h_180 = null
	v_ctx_165 = J.arg(a, 0)
	v_x_166 = J.arg(a, 1)
	v_y_167 = J.arg(a, 2)
	v_t_168 = J.arg(a, 3)
	v_s_169 = J.arg(a, 4)
	v_n_170 = J.arg(a, 5)
	v_k_171 = J.arg(a, 6)
	v_push_172 = J.arg(a, 7)
	v_i_173 = 0.0
	while true:
		if not J.cmp(v_i_173, v_n_170, "<"): break
		var _t50 = (J.mul(v_t_168, 0.5) + J.div(v_i_173, v_n_170))
		var _t49 = env["hash"]
		v_ph_174 = J.mod((_t50 + J.mul(J.cl(_t49, null, [v_i_173]), 0.2)), 1.0)
		v_al_175 = J.mul((sin(J.num(J.mul(v_ph_174, env["PI"]))) * 0.6), v_k_171)
		if J.cmp(v_al_175, 0.02, "<="):
			v_i_173 = J.num(v_i_173) + 1.0
			continue
		v_pts_176 = []
		v_x0_177 = J.add(v_x_166, J.mul((J.sub(v_i_173, J.div(J.sub(v_n_170, 1.0), 2.0)) * 3.0), v_s_169))
		v_j_178 = 0.0
		while true:
			if not J.cmp(v_j_178, 6.0, "<="): break
			v_q_179 = J.div(v_j_178, 6.0)
			v_h_180 = J.mul((J.mul(v_ph_174, 20.0) + J.mul(v_q_179, 9.0)), v_s_169)
			J.mc(v_pts_176, "push", [[J.add(J.add(v_x0_177, J.mul(J.mul((sin(J.num(((J.mul(v_q_179, 5.0) + J.mul(v_t_168, 2.3)) + J.mul(v_i_173, 2.0)))) * 2.0), v_s_169), J.add(0.4, v_q_179))), (J.mul((v_push_172 if J.t(v_push_172) else 0.0), v_h_180) * 0.9)), J.sub(v_y_167, v_h_180)]])
			v_j_178 = J.num(v_j_178) + 1.0
		J.mc(v_ctx_165, "save", [])
		var _t51 = J.mul(J.gp(v_ctx_165, "globalAlpha"), v_al_175)
		J.sp(v_ctx_165, "globalAlpha", _t51)
		var _t52 = env["crayon"]
		J.cl(_t52, null, [v_ctx_165, v_pts_176, J.mul(1.4, v_s_169), "#f3eee4"])
		J.mc(v_ctx_165, "restore", [])
		v_i_173 = J.num(v_i_173) + 1.0

func _f21(this_, a: Array, env):
	var v_ctx_183 = null; var v_x_184 = null; var v_y_185 = null; var v_str_186 = null; var v_size_187 = null; var v_col_188 = null; var v_k_189 = null; var v_wob_190 = null; var v_sc_191 = null
	v_ctx_183 = J.arg(a, 0)
	v_x_184 = J.arg(a, 1)
	v_y_185 = J.arg(a, 2)
	v_str_186 = J.arg(a, 3)
	v_size_187 = J.arg(a, 4)
	v_col_188 = J.arg(a, 5)
	v_k_189 = J.arg(a, 6)
	v_wob_190 = J.arg(a, 7)
	if J.cmp(v_k_189, 0.0, "<="):
		return null
	J.mc(v_ctx_183, "save", [])
	var _t53 = env["eo"]
	var _t54 = env["cl"]
	v_sc_191 = (0.55 + J.mul(0.45, J.cl(_t53, null, [J.cl(_t54, null, [J.mul(v_k_189, 2.2)])])))
	var _t55 = env["cl"]
	var _t56 = J.mul(J.gp(v_ctx_183, "globalAlpha"), J.cl(_t55, null, [J.mul(v_k_189, 3.0)]))
	J.sp(v_ctx_183, "globalAlpha", _t56)
	J.mc(v_ctx_183, "translate", [v_x_184, v_y_185])
	J.mc(v_ctx_183, "rotate", [J.mul((v_wob_190 if J.t(v_wob_190) else 0.0), 0.12)])
	J.mc(v_ctx_183, "scale", [v_sc_191, v_sc_191])
	var _t57 = ("900 " + J.str(v_size_187) + "px \"PingFang TC\",\"Noto Sans TC\",sans-serif")
	J.sp(v_ctx_183, "font", _t57)
	J.sp(v_ctx_183, "textAlign", "center")
	J.sp(v_ctx_183, "textBaseline", "middle")
	J.sp(v_ctx_183, "lineJoin", "round")
	var _t58 = J.mul(v_size_187, 0.28)
	J.sp(v_ctx_183, "lineWidth", _t58)
	J.sp(v_ctx_183, "strokeStyle", "rgba(28,18,30,.92)")
	J.mc(v_ctx_183, "strokeText", [v_str_186, 0.0, 0.0])
	J.sp(v_ctx_183, "fillStyle", v_col_188)
	J.mc(v_ctx_183, "fillText", [v_str_186, 0.0, 0.0])
	J.mc(v_ctx_183, "restore", [])

func _f22(this_, a: Array, env):
	var v_ctx_194 = null; var v_x_195 = null; var v_y_196 = null; var v_t_197 = null; var v_s_198 = null; var v_k_199 = null; var v_i_200 = null; var v_ph_201 = null; var v_al_202 = null
	v_ctx_194 = J.arg(a, 0)
	v_x_195 = J.arg(a, 1)
	v_y_196 = J.arg(a, 2)
	v_t_197 = J.arg(a, 3)
	v_s_198 = J.arg(a, 4)
	v_k_199 = J.arg(a, 5)
	v_i_200 = 0.0
	while true:
		if not J.cmp(v_i_200, 3.0, "<"): break
		v_ph_201 = J.mod((J.mul(v_t_197, 0.42) + J.div(v_i_200, 3.0)), 1.0)
		v_al_202 = J.mul(sin(J.num(J.mul(v_ph_201, env["PI"]))), v_k_199)
		if J.cmp(v_al_202, 0.02, "<="):
			v_i_200 = J.num(v_i_200) + 1.0
			continue
		J.mc(v_ctx_194, "save", [])
		var _t59 = J.mul(J.gp(v_ctx_194, "globalAlpha"), v_al_202)
		J.sp(v_ctx_194, "globalAlpha", _t59)
		var _t60 = env["txt"]
		J.cl(_t60, null, [v_ctx_194, J.add(J.add(v_x_195, J.mul(J.mul(v_ph_201, 11.0), v_s_198)), J.mul((sin(J.num(J.add(J.mul(v_ph_201, 6.0), v_i_200))) * 2.0), v_s_198)), J.sub(v_y_196, J.mul(J.mul(v_ph_201, 24.0), v_s_198)), "z", (J.mul((8.0 + J.mul(v_ph_201, 7.0)), v_s_198) * 1.4), "#d6e6ff", 1.0, sin(J.num(J.mul(v_ph_201, 4.0)))])
		J.mc(v_ctx_194, "restore", [])
		v_i_200 = J.num(v_i_200) + 1.0

func _f23(this_, a: Array, env):
	var v_ctx_205 = null; var v_x_206 = null; var v_y_207 = null; var v_r_208 = null; var v_rot_209 = null; var v_i_210 = null; var v_rr_211 = null; var v_an_212 = null
	v_ctx_205 = J.arg(a, 0)
	v_x_206 = J.arg(a, 1)
	v_y_207 = J.arg(a, 2)
	v_r_208 = J.arg(a, 3)
	v_rot_209 = J.arg(a, 4)
	J.mc(v_ctx_205, "save", [])
	J.mc(v_ctx_205, "translate", [v_x_206, v_y_207])
	J.mc(v_ctx_205, "rotate", [v_rot_209])
	J.mc(v_ctx_205, "beginPath", [])
	v_i_210 = 0.0
	while true:
		if not J.cmp(v_i_210, 10.0, "<"): break
		v_rr_211 = (J.mul(v_r_208, 0.45) if J.t(J.mod(v_i_210, 2.0)) else v_r_208)
		v_an_212 = (J.div(J.mul(v_i_210, env["PI"]), 5.0) - J.div(env["PI"], 2.0))
		J.mc(v_ctx_205, "lineTo", [J.mul(cos(J.num(v_an_212)), v_rr_211), J.mul(sin(J.num(v_an_212)), v_rr_211)])
		v_i_210 = J.num(v_i_210) + 1.0
	J.mc(v_ctx_205, "closePath", [])
	J.sp(v_ctx_205, "fillStyle", "#ffe27a")
	J.mc(v_ctx_205, "fill", [])
	var _t61 = J.mul(v_r_208, 0.3)
	J.sp(v_ctx_205, "lineWidth", _t61)
	J.sp(v_ctx_205, "strokeStyle", "#6a4a20")
	J.mc(v_ctx_205, "stroke", [])
	J.mc(v_ctx_205, "restore", [])

func _f24(this_, a: Array, env):
	var v_ctx_215 = null; var v_x_216 = null; var v_y_217 = null; var v_t_218 = null; var v_s_219 = null; var v_k_220 = null; var v_i_221 = null; var v_an_222 = null
	v_ctx_215 = J.arg(a, 0)
	v_x_216 = J.arg(a, 1)
	v_y_217 = J.arg(a, 2)
	v_t_218 = J.arg(a, 3)
	v_s_219 = J.arg(a, 4)
	v_k_220 = J.arg(a, 5)
	if J.cmp(v_k_220, 0.0, "<="):
		return null
	J.mc(v_ctx_215, "save", [])
	var _t62 = J.mul(J.gp(v_ctx_215, "globalAlpha"), v_k_220)
	J.sp(v_ctx_215, "globalAlpha", _t62)
	v_i_221 = 0.0
	while true:
		if not J.cmp(v_i_221, 3.0, "<"): break
		v_an_222 = (J.mul(v_t_218, 5.5) + J.div(J.mul(v_i_221, env["TAU"]), 3.0))
		var _t63 = env["star"]
		J.cl(_t63, null, [v_ctx_215, J.add(v_x_216, J.mul((cos(J.num(v_an_222)) * 11.0), v_s_219)), J.add(v_y_217, J.mul((sin(J.num(v_an_222)) * 3.5), v_s_219)), (J.mul((2.2 + (sin(J.num(v_an_222)) * 0.6)), v_s_219) * 1.3), J.add(J.mul(v_t_218, 3.0), v_i_221)])
		v_i_221 = J.num(v_i_221) + 1.0
	J.mc(v_ctx_215, "restore", [])

func _f25(this_, a: Array, env):
	var v_ctx_225 = null; var v_x_226 = null; var v_y_227 = null; var v_ch_228 = null; var v_s_229 = null; var v_k_230 = null; var v_sc_231 = null; var v_i_232 = null
	v_ctx_225 = J.arg(a, 0)
	v_x_226 = J.arg(a, 1)
	v_y_227 = J.arg(a, 2)
	v_ch_228 = J.arg(a, 3)
	v_s_229 = J.arg(a, 4)
	v_k_230 = J.arg(a, 5)
	if J.cmp(v_k_230, 0.0, "<="):
		return null
	J.mc(v_ctx_225, "save", [])
	var _t64 = env["cl"]
	var _t65 = J.mul(J.gp(v_ctx_225, "globalAlpha"), J.cl(_t64, null, [J.mul(v_k_230, 4.0)]))
	J.sp(v_ctx_225, "globalAlpha", _t65)
	var _t66 = env["eo"]
	var _t67 = env["cl"]
	v_sc_231 = (J.mul((0.6 + J.mul(0.4, J.cl(_t66, null, [J.cl(_t67, null, [J.mul(v_k_230, 3.0)])]))), v_s_229) * 1.7)
	J.mc(v_ctx_225, "translate", [v_x_226, v_y_227])
	J.mc(v_ctx_225, "scale", [v_sc_231, v_sc_231])
	J.mc(v_ctx_225, "beginPath", [])
	J.mc(v_ctx_225, "ellipse", [0.0, 0.0, 8.5, 6.5, 0.0, 0.0, env["TAU"]])
	J.sp(v_ctx_225, "fillStyle", "#ecd9a4")
	J.mc(v_ctx_225, "fill", [])
	J.sp(v_ctx_225, "lineWidth", 1.1)
	J.sp(v_ctx_225, "strokeStyle", "#5a4030")
	J.mc(v_ctx_225, "stroke", [])
	J.mc(v_ctx_225, "beginPath", [])
	J.mc(v_ctx_225, "moveTo", [(-2.5), 5.6])
	J.mc(v_ctx_225, "lineTo", [(-4.5), 10.0])
	J.mc(v_ctx_225, "lineTo", [1.0, 6.2])
	J.sp(v_ctx_225, "fillStyle", "#ecd9a4")
	J.mc(v_ctx_225, "fill", [])
	J.mc(v_ctx_225, "stroke", [])
	J.mc(v_ctx_225, "beginPath", [])
	J.mc(v_ctx_225, "ellipse", [0.0, 0.0, 7.6, 5.6, 0.0, 0.0, env["TAU"]])
	J.sp(v_ctx_225, "fillStyle", "#ecd9a4")
	J.mc(v_ctx_225, "fill", [])
	var _t68 = ("#c2362b" if J.seq(v_ch_228, "!") else ("#3a6aa8" if J.seq(v_ch_228, "♪") else "#2b1d12"))
	J.sp(v_ctx_225, "fillStyle", _t68)
	if J.seq(v_ch_228, "…"):
		v_i_232 = (-1.0)
		while true:
			if not J.cmp(v_i_232, 1.0, "<="): break
			J.mc(v_ctx_225, "beginPath", [])
			J.mc(v_ctx_225, "arc", [J.mul(v_i_232, 3.0), 0.5, 1.05, 0.0, env["TAU"]])
			J.mc(v_ctx_225, "fill", [])
			v_i_232 = J.num(v_i_232) + 1.0
	else:
		var _t69 = "900 9px \"PingFang TC\",\"Noto Sans TC\",sans-serif"
		J.sp(v_ctx_225, "font", _t69)
		J.sp(v_ctx_225, "textAlign", "center")
		J.sp(v_ctx_225, "textBaseline", "middle")
		J.mc(v_ctx_225, "fillText", [v_ch_228, 0.0, 0.6])
	J.mc(v_ctx_225, "restore", [])

func _f26(this_, a: Array, env):
	var v_ctx_235 = null; var v_x_236 = null; var v_y_237 = null; var v_tb_238 = null; var v_s_239 = null; var v_seed_240 = null; var v_fwd_241 = null; var v_i_242 = null; var v_vx_243 = null; var v_vy_244 = null; var v_px_245 = null; var v_py_246 = null; var v_al_247 = null; var v_r_248 = null
	v_ctx_235 = J.arg(a, 0)
	v_x_236 = J.arg(a, 1)
	v_y_237 = J.arg(a, 2)
	v_tb_238 = J.arg(a, 3)
	v_s_239 = J.arg(a, 4)
	v_seed_240 = J.arg(a, 5)
	v_fwd_241 = J.arg(a, 6)
	var _t70 = J.cmp(v_tb_238, 0.0, "<")
	if (_t70 if _t70 else J.cmp(v_tb_238, 0.65, ">")):
		return null
	v_i_242 = 0.0
	while true:
		if not J.cmp(v_i_242, 6.0, "<"): break
		var _t71 = env["hash"]
		var _t73 = (J.mul(J.mul(v_fwd_241, (6.0 + J.mul(J.cl(_t71, null, [J.add(v_seed_240, v_i_242)]), 26.0))), v_s_239) * 1.6)
		var _t72 = env["hash"]
		v_vx_243 = (_t73 * (1.0 if J.cmp(J.cl(_t72, null, [J.add(v_seed_240, J.mul(v_i_242, 2.0))]), 0.3, ">") else (-0.6)))
		var _t75 = (-26.0)
		var _t74 = env["hash"]
		v_vy_244 = (J.mul((_t75 - J.mul(J.cl(_t74, null, [J.add(v_seed_240, J.mul(v_i_242, 3.0))]), 24.0)), v_s_239) * 1.6)
		v_px_245 = J.add(v_x_236, J.mul(v_vx_243, v_tb_238))
		v_py_246 = J.add(J.add(v_y_237, J.mul(v_vy_244, v_tb_238)), J.mul(J.mul(J.mul(170.0, v_s_239), v_tb_238), v_tb_238))
		v_al_247 = (1.0 - J.div(v_tb_238, 0.65))
		J.mc(v_ctx_235, "save", [])
		var _t76 = J.mul(J.gp(v_ctx_235, "globalAlpha"), v_al_247)
		J.sp(v_ctx_235, "globalAlpha", _t76)
		J.mc(v_ctx_235, "translate", [v_px_245, v_py_246])
		J.mc(v_ctx_235, "rotate", [J.add(J.mul(v_tb_238, 9.0), v_i_242)])
		J.sp(v_ctx_235, "fillStyle", "#f4e7c6")
		J.sp(v_ctx_235, "strokeStyle", "#8a6a44")
		J.sp(v_ctx_235, "lineWidth", 0.35)
		var _t77 = env["hash"]
		v_r_248 = (J.mul((0.7 + J.mul(J.cl(_t77, null, [J.add(v_i_242, v_seed_240)]), 0.6)), v_s_239) * 1.6)
		J.mc(v_ctx_235, "beginPath", [])
		J.mc(v_ctx_235, "ellipse", [0.0, 0.0, v_r_248, J.mul(v_r_248, 0.75), 0.0, 0.0, env["TAU"]])
		J.mc(v_ctx_235, "fill", [])
		J.mc(v_ctx_235, "stroke", [])
		J.mc(v_ctx_235, "restore", [])
		v_i_242 = J.num(v_i_242) + 1.0

func _f27(this_, a: Array, env):
	var v_ctx_251 = null; var v_x_252 = null; var v_y_253 = null; var v_r_254 = null; var v_al_255 = null
	v_ctx_251 = J.arg(a, 0)
	v_x_252 = J.arg(a, 1)
	v_y_253 = J.arg(a, 2)
	v_r_254 = J.arg(a, 3)
	v_al_255 = J.arg(a, 4)
	J.mc(v_ctx_251, "save", [])
	var _t78 = J.mul(J.gp(v_ctx_251, "globalAlpha"), v_al_255)
	J.sp(v_ctx_251, "globalAlpha", _t78)
	J.sp(v_ctx_251, "fillStyle", "#9fd0e6")
	J.sp(v_ctx_251, "strokeStyle", "#2c5566")
	var _t79 = J.mul(v_r_254, 0.35)
	J.sp(v_ctx_251, "lineWidth", _t79)
	J.mc(v_ctx_251, "beginPath", [])
	J.mc(v_ctx_251, "moveTo", [v_x_252, J.sub(v_y_253, J.mul(v_r_254, 1.6))])
	J.mc(v_ctx_251, "quadraticCurveTo", [J.add(v_x_252, v_r_254), J.sub(v_y_253, J.mul(v_r_254, 0.2)), v_x_252, J.add(v_y_253, J.mul(v_r_254, 0.6))])
	J.mc(v_ctx_251, "quadraticCurveTo", [J.sub(v_x_252, v_r_254), J.sub(v_y_253, J.mul(v_r_254, 0.2)), v_x_252, J.sub(v_y_253, J.mul(v_r_254, 1.6))])
	J.mc(v_ctx_251, "fill", [])
	J.mc(v_ctx_251, "stroke", [])
	J.mc(v_ctx_251, "restore", [])

func _f28(this_, a: Array, env):
	var v_ctx_258 = null; var v_x_259 = null; var v_y_260 = null; var v_k_261 = null; var v_s_262 = null; var v_seed_263 = null; var v_i_264 = null; var v_an_265 = null; var v_r_266 = null
	v_ctx_258 = J.arg(a, 0)
	v_x_259 = J.arg(a, 1)
	v_y_260 = J.arg(a, 2)
	v_k_261 = J.arg(a, 3)
	v_s_262 = J.arg(a, 4)
	v_seed_263 = J.arg(a, 5)
	var _t80 = J.cmp(v_k_261, 0.0, "<=")
	if (_t80 if _t80 else J.cmp(v_k_261, 1.0, ">=")):
		return null
	v_i_264 = 0.0
	while true:
		if not J.cmp(v_i_264, 5.0, "<"): break
		var _t82 = J.add(env["PI"], J.mul(J.div(v_i_264, 4.0), env["PI"]))
		var _t81 = env["hash"]
		v_an_265 = J.add(_t82, (J.sub(J.cl(_t81, null, [J.add(v_seed_263, v_i_264)]), 0.5) * 0.5))
		var _t83 = env["eo"]
		var _t85 = J.mul((4.0 + J.mul(10.0, J.cl(_t83, null, [v_k_261]))), v_s_262)
		var _t84 = env["hash"]
		v_r_266 = (_t85 * (0.7 + J.mul(J.cl(_t84, null, [J.add(v_seed_263, J.mul(v_i_264, 2.0))]), 0.6)))
		J.mc(v_ctx_258, "save", [])
		var _t86 = J.mul(J.gp(v_ctx_258, "globalAlpha"), (J.sub(1.0, v_k_261) * 0.55))
		J.sp(v_ctx_258, "globalAlpha", _t86)
		J.sp(v_ctx_258, "fillStyle", "#cdbfa8")
		J.mc(v_ctx_258, "beginPath", [])
		J.mc(v_ctx_258, "arc", [J.add(v_x_259, (J.mul(cos(J.num(v_an_265)), v_r_266) * 1.4)), J.add(v_y_260, (J.mul(sin(J.num(v_an_265)), v_r_266) * 0.35)), J.mul((1.6 + J.mul(2.2, v_k_261)), v_s_262), 0.0, env["TAU"]])
		J.mc(v_ctx_258, "fill", [])
		J.mc(v_ctx_258, "restore", [])
		v_i_264 = J.num(v_i_264) + 1.0

func _f29(this_, a: Array, env):
	var v_ctx_269 = null; var v_x_270 = null; var v_y_271 = null; var v_t_272 = null; var v_s_273 = null; var v_fwd_274 = null; var v_i_275 = null; var v_ph_276 = null; var v_al_277 = null; var v_pts_278 = null; var v_j_279 = null; var v_q_280 = null
	v_ctx_269 = J.arg(a, 0)
	v_x_270 = J.arg(a, 1)
	v_y_271 = J.arg(a, 2)
	v_t_272 = J.arg(a, 3)
	v_s_273 = J.arg(a, 4)
	v_fwd_274 = J.arg(a, 5)
	v_i_275 = 0.0
	while true:
		if not J.cmp(v_i_275, 2.0, "<"): break
		v_ph_276 = J.mod((J.mul(v_t_272, 1.6) + J.mul(v_i_275, 0.5)), 1.0)
		v_al_277 = (sin(J.num(J.mul(v_ph_276, env["PI"]))) * 0.8)
		v_pts_278 = []
		v_j_279 = 0.0
		while true:
			if not J.cmp(v_j_279, 5.0, "<="): break
			v_q_280 = J.div(v_j_279, 5.0)
			J.mc(v_pts_278, "push", [[J.add(v_x_270, J.mul(J.mul(v_fwd_274, ((14.0 - J.mul(v_ph_276, 10.0)) - J.mul(v_q_280, 6.0))), v_s_273)), J.add(v_y_271, J.mul(((J.mul(v_i_275, 4.0) - 2.0) + (sin(J.num((J.mul(v_q_280, 6.0) + J.mul(v_t_272, 8.0)))) * 1.2)), v_s_273))]])
			v_j_279 = J.num(v_j_279) + 1.0
		J.mc(v_ctx_269, "save", [])
		var _t87 = J.mul(J.gp(v_ctx_269, "globalAlpha"), v_al_277)
		J.sp(v_ctx_269, "globalAlpha", _t87)
		var _t88 = env["crayon"]
		J.cl(_t88, null, [v_ctx_269, v_pts_278, J.mul(0.9, v_s_273), "#e9e2cf"])
		J.mc(v_ctx_269, "restore", [])
		v_i_275 = J.num(v_i_275) + 1.0

func _f30(this_, a: Array, env):
	var v_hp_283 = null; var v_H_284 = null; var v_P_285 = null; var v_c_286 = null; var v_air_287 = null; var v_land_288 = null; var v_up_289 = null
	v_hp_283 = J.arg(a, 0)
	v_H_284 = J.arg(a, 1)
	v_P_285 = J.arg(a, 2)
	var _t90 = env["PI"]
	var _t89 = env["seg"]
	var _t92 = env["PI"]
	var _t91 = env["seg"]
	v_c_286 = J.max_([(sin(J.num(J.mul(_t92, J.cl(_t91, null, [v_hp_283, 0.0, 0.24])))) * (1.0 if J.cmp(v_hp_283, 0.24, "<") else 0.0)), 0.0])
	var _t93 = env["seg"]
	v_air_287 = J.cl(_t93, null, [v_hp_283, 0.22, 0.9])
	var _t96 = null
	if J.cmp(v_hp_283, 0.9, ">"):
		var _t95 = env["PI"]
		var _t94 = env["seg"]
		_t96 = sin(J.num(J.mul(_t95, J.cl(_t94, null, [v_hp_283, 0.9, 1.0]))))
	else:
		_t96 = 0.0
	v_land_288 = _t96
	var _t98 = sin(J.num(J.mul(env["PI"], v_air_287)))
	var _t97 = J.cmp(v_hp_283, 0.22, ">=")
	v_up_289 = (_t98 * (1.0 if (J.cmp(v_hp_283, 0.9, "<=") if _t97 else _t97) else 0.0))
	var _t99 = env["add"]
	J.cl(_t99, null, [v_P_285, {"sy": (((1.0 - J.mul(0.1, v_c_286)) - J.mul(0.09, v_land_288)) + (J.mul(0.06, v_up_289) * J.sub(1.0, v_air_287))), "sx": (((1.0 + J.mul(0.06, v_c_286)) + J.mul(0.06, v_land_288)) - J.mul(0.03, v_up_289)), "body": J.mul(0.04, v_up_289), "head": (J.mul((-0.05), v_up_289) + J.mul(0.06, v_land_288)), "armF": (J.mul(0.08, v_up_289) - J.mul(0.06, v_land_288)), "armB": (J.mul((-0.08), v_up_289) + J.mul(0.06, v_land_288))}])
	return (J.mul(v_up_289, v_H_284) * 0.2)

func _f32(this_, a: Array, env):
	var v_nx_324 = null; var v_ny_325 = null
	var _t171 = env["__p"]["npt"]
	var _t172 = J.cl(_t171, null, [env["a"], (0.5 if J.t(J.gp(env["__p"]["PAPER"], env["type"])) else 0.62), 0.28])
	var _t173 = J.gp(_t172, 0.0)
	v_nx_324 = _t173
	var _t174 = J.gp(_t172, 1.0)
	v_ny_325 = _t174
	var _t175 = env["__p"]["sniffLines"]
	J.cl(_t175, null, [env["ctx"], v_nx_324, J.add(v_ny_325, J.mul(4.0, env["s"])), env["at"], env["s"], env["fwd"]])

func _f33(this_, a: Array, env):
	var v_hx_329 = null; var v_hy_330 = null
	var _t180 = env["__p"]["npt"]
	var _t181 = J.cl(_t180, null, [env["a"], 0.45, 0.02])
	var _t182 = J.gp(_t181, 0.0)
	v_hx_329 = _t182
	var _t183 = J.gp(_t181, 1.0)
	v_hy_330 = _t183
	var _t184 = env["__p"]["txt"]
	var _t186 = env["ctx"]
	var _t187 = J.add(v_hx_329, J.mul(J.mul(env["fwd"], 8.0), env["s"]))
	var _t188 = J.sub(v_hy_330, J.mul(8.0, env["s"]))
	var _t189 = (J.mul(12.0, env["s"]) * 1.3)
	var _t185 = env["__p"]["env"]
	J.cl(_t184, null, [_t186, _t187, _t188, "哎喲", _t189, "#ffd2d2", J.cl(_t185, null, [env["at"], 0.1, 0.25, 1.3, 1.6]), (sin(J.num(J.mul(env["at"], 9.0))) * 0.5)])

func _f34(this_, a: Array, env):
	var v_bx_336 = null; var v_by_337 = null
	var _t198 = env["__p"]["__p"]["npt"]
	var _t199 = J.cl(_t198, null, [env["__p"]["a"], 0.25, 0.47, 0.0])
	var _t200 = J.gp(_t199, 0.0)
	v_bx_336 = _t200
	var _t201 = J.gp(_t199, 1.0)
	v_by_337 = _t201
	var _t202 = env["__p"]["__p"]["steam"]
	J.cl(_t202, null, [env["__p"]["ctx"], v_bx_336, J.add(v_by_337, J.mul(J.mul(env["__p"]["H"], 0.07), env["k"])), env["__p"]["t"], env["__p"]["s"], 3.0, (0.55 + J.mul(0.6, env["blow"])), (J.mul(env["__p"]["fwd"], env["blow"]) * 0.8)])

func _f35(this_, a: Array, env):
	var v_hx_347 = null; var v_hy_348 = null; var v_i_349 = null; var v_e_350 = null; var v_an_351 = null; var v_v_352 = null
	var _t224 = env["__p"]["npt"]
	var _t225 = J.cl(_t224, null, [env["a"], 0.5, 0.3])
	var _t226 = J.gp(_t225, 0.0)
	v_hx_347 = _t226
	var _t227 = J.gp(_t225, 1.0)
	v_hy_348 = _t227
	v_i_349 = 0.0
	while true:
		if not J.cmp(v_i_349, 12.0, "<"): break
		v_e_350 = J.sub(env["at"], (0.3 + J.mul(v_i_349, 0.07)))
		var _t228 = J.cmp(v_e_350, 0.0, "<")
		if (_t228 if _t228 else J.cmp(v_e_350, 0.5, ">")):
			v_i_349 = J.num(v_i_349) + 1.0
			continue
		var _t230 = (-J.num(env["__p"]["PI"]))
		var _t229 = env["__p"]["hash"]
		v_an_351 = (_t230 * (0.1 + J.mul(0.8, J.cl(_t229, null, [J.mul(v_i_349, 7.7)]))))
		var _t231 = env["__p"]["hash"]
		v_v_352 = J.mul((36.0 + J.mul(J.cl(_t231, null, [v_i_349]), 34.0)), env["s"])
		var _t232 = env["__p"]["drop"]
		J.cl(_t232, null, [env["ctx"], J.add(v_hx_347, (J.mul(J.mul(cos(J.num(v_an_351)), v_v_352), v_e_350) * (1.0 if J.t(J.mod(v_i_349, 2.0)) else (-1.0)))), J.add(J.add(v_hy_348, J.mul(J.mul(sin(J.num(v_an_351)), v_v_352), v_e_350)), J.mul(J.mul(J.mul(140.0, env["s"]), v_e_350), v_e_350)), J.mul(1.6, env["s"]), (1.0 - J.div(v_e_350, 0.5))])
		v_i_349 = J.num(v_i_349) + 1.0

func _f36(this_, a: Array, env):
	var v_hx_357 = null; var v_hy_358 = null
	if J.cmp(env["at"], 1.3, ">"):
		var _t242 = env["__p"]["npt"]
		var _t243 = J.cl(_t242, null, [env["a"], 0.5, 0.0])
		var _t244 = J.gp(_t243, 0.0)
		v_hx_357 = _t244
		var _t245 = J.gp(_t243, 1.0)
		v_hy_358 = _t245
		var _t246 = env["__p"]["bubble"]
		var _t248 = env["ctx"]
		var _t249 = J.add(v_hx_357, J.mul(J.mul(env["fwd"], 10.0), env["s"]))
		var _t250 = J.sub(v_hy_358, J.mul(16.0, env["s"]))
		var _t251 = env["s"]
		var _t247 = env["__p"]["env"]
		J.cl(_t246, null, [_t248, _t249, _t250, "♪", _t251, J.cl(_t247, null, [env["at"], 1.3, 1.45, 2.0, 2.2])])

func _f37(this_, a: Array, env):
	var v_hx_362 = null; var v_hy_363 = null
	var _t259 = env["__p"]["npt"]
	var _t260 = J.cl(_t259, null, [env["a"], 0.5, 0.0])
	var _t261 = J.gp(_t260, 0.0)
	v_hx_362 = _t261
	var _t262 = J.gp(_t260, 1.0)
	v_hy_363 = _t262
	var _t263 = env["__p"]["txt"]
	var _t265 = env["ctx"]
	var _t266 = J.add(v_hx_362, J.mul(J.mul(env["fwd"], 12.0), env["s"]))
	var _t267 = J.sub(v_hy_363, J.mul(6.0, env["s"]))
	var _t268 = (J.mul(13.0, env["s"]) * 1.4)
	var _t264 = env["__p"]["env"]
	J.cl(_t263, null, [_t265, _t266, _t267, "哇！", _t268, "#ffe9a8", J.cl(_t264, null, [env["at"], 0.15, 0.25, 0.8, 1.0]), sin(J.num(J.mul(env["at"], 30.0)))])

func _f38(this_, a: Array, env):
	var v_hx_367 = null; var v_hy_368 = null
	var _t272 = env["__p"]["__p"]["npt"]
	var _t273 = J.cl(_t272, null, [env["__p"]["a"], 0.5, 0.05])
	var _t274 = J.gp(_t273, 0.0)
	v_hx_367 = _t274
	var _t275 = J.gp(_t273, 1.0)
	v_hy_368 = _t275
	var _t276 = env["__p"]["__p"]["txt"]
	J.cl(_t276, null, [env["__p"]["ctx"], J.sub(v_hx_367, J.mul(J.mul(env["__p"]["fwd"], 10.0), env["__p"]["s"])), (J.sub(v_hy_368, J.mul(4.0, env["__p"]["s"])) - J.mul(J.mul(env["b"], 2.0), env["__p"]["s"])), "嘻嘻", (J.mul(10.0, env["__p"]["s"]) * 1.4), "#c8f5b8", env["k"], sin(J.num(J.mul(env["__p"]["at"], 15.0)))])

func _f39(this_, a: Array, env):
	var v_hx_378 = null; var v_hy_379 = null
	var _t306 = env["__p"]["npt"]
	var _t307 = J.cl(_t306, null, [env["a"], 0.3, 0.2])
	var _t308 = J.gp(_t307, 0.0)
	v_hx_378 = _t308
	var _t309 = J.gp(_t307, 1.0)
	v_hy_379 = _t309
	var _t310 = env["__p"]["txt"]
	var _t312 = env["ctx"]
	var _t313 = J.add(v_hx_378, J.mul(J.mul(env["fwd"], 10.0), env["s"]))
	var _t314 = J.sub(v_hy_379, J.mul(4.0, env["s"]))
	var _t315 = (J.mul(11.0, env["s"]) * 1.4)
	var _t311 = env["__p"]["env"]
	J.cl(_t310, null, [_t312, _t313, _t314, "咚！", _t315, "#ffe9a8", J.cl(_t311, null, [env["at"], 0.0, 0.06, 0.45, 0.7]), 0.4])

func _f31(this_, a: Array, env):
	var v_o_294 = null; var v_pl_301 = null; var v_P_302 = null; var v_lift_303 = null; var v_shK_304 = null; var v_w_305 = null; var v_after_306 = null; var v_sn_307 = null; var v_b_308 = null; var v_n_309 = null; var v_k_310 = null; var v_d_311 = null; var v_k_312 = null; var v_deep_313 = null; var v_d_314 = null; var v_k_315 = null; var v_j_316 = null; var v_wake_317 = null; var v_br_318 = null; var v_k_319 = null; var v_d_320 = null; var v_k_321 = null; var v_q_322 = null; var v_sn_323 = null; var v_d_326 = null; var v_k_327 = null; var v_st_328 = null; var v_d_331 = null; var v_c_333 = null; var v_stir_335 = null; var v_c_338 = null; var v_up_339 = null; var v_down_340 = null; var v_rel_341 = null; var v_arm_342 = null; var v_pull_343 = null; var v_sh_344 = null; var v_amp_345 = null; var v_cr_346 = null; var v_q_353 = null; var v_cr_354 = null; var v_land_355 = null; var v_c_356 = null; var v_cr_359 = null; var v_k_360 = null; var v_tr_361 = null; var v_d_364 = null; var v_d_369 = null; var v_cr_370 = null; var v_j_371 = null; var v_tr_372 = null; var v_k_373 = null; var v_k_374 = null; var v_im_375 = null; var v_back_376 = null; var v_land_377 = null; var v_d_380 = null; var v_k_381 = null
	var _s62 = {"__p": env, "ctx": null, "a": null, "type": null, "at": null, "t": null, "fwd": null, "s": null, "H": null}
	_s62["ctx"] = J.arg(a, 0)
	_s62["a"] = J.arg(a, 1)
	v_o_294 = J.gp(_s62["a"], "o")
	_s62["type"] = J.gp(_s62["a"], "type")
	var _t100 = J.gp(v_o_294, "at")
	_s62["at"] = (_t100 if J.t(_t100) else 0.0)
	var _t101 = J.gp(v_o_294, "t")
	_s62["t"] = (_t101 if J.t(_t101) else 0.0)
	_s62["fwd"] = (1.0 if J.t(J.gp(_s62["a"], "faceRight")) else (-1.0))
	_s62["s"] = J.gp(_s62["a"], "s")
	_s62["H"] = J.gp(_s62["a"], "H")
	var _t102 = J.gp(v_o_294, "pl")
	v_pl_301 = (_t102 if J.t(_t102) else {})
	if (not J.t(J.mc(J.G.get("MeshAnim"), "has", [_s62["type"]]))):
		return false
	var _t103 = J.seq(J.gp(v_o_294, "act"), "plaza_eat")
	var _t105 = (J.seq(_s62["type"], "eguiking") if _t103 else _t103)
	if J.t(_t105):
		var _t104 = _s62["__p"]["eatDraw"]
		_t105 = (not J.seq(J.cl(_t104, null, [_s62["ctx"], _s62["a"]]), false))
	if _t105:
		return null
	var _t106 = J.seq(J.gp(v_o_294, "act"), "plaza_golf")
	var _t108 = (J.seq(_s62["type"], "huang") if _t106 else _t106)
	if J.t(_t108):
		var _t107 = _s62["__p"]["golfDraw"]
		_t108 = (not J.seq(J.cl(_t107, null, [_s62["ctx"], _s62["a"]]), false))
	if _t108:
		return null
	var _t109 = J.seq(J.gp(v_o_294, "act"), "plaza_hang")
	var _t111 = (J.seq(_s62["type"], "tianhua") if _t109 else _t109)
	if J.t(_t111):
		var _t110 = _s62["__p"]["hangDraw"]
		_t111 = (not J.seq(J.cl(_t110, null, [_s62["ctx"], _s62["a"]]), false))
	if _t111:
		return null
	var _t112 = _s62["__p"]["basePose"]
	v_P_302 = J.cl(_t112, null, [v_o_294, _s62["type"]])
	v_lift_303 = 0.0
	v_shK_304 = 1.0
	var _t113 = J.gp(_s62["__p"]["HOPPER"], _s62["type"])
	var _t114 = ((not J.leq(J.gp(v_o_294, "hp"), null)) if J.t(_t113) else _t113)
	var _t116 = (J.cmp(J.gp(v_o_294, "hp"), 0.0, ">=") if J.t(_t114) else _t114)
	if J.t(_t116):
		var _t115 = (not J.t(J.gp(v_o_294, "act")))
		_t116 = (_t115 if _t115 else J.seq(J.gp(v_o_294, "act"), "plaza_walk"))
	if J.t(_t116):
		var _t117 = _s62["__p"]["hopPose"]
		var _t118 = J.add(v_lift_303, J.cl(_t117, null, [J.gp(v_o_294, "hp"), _s62["H"], v_P_302]))
		v_lift_303 = _t118
	var _t119 = _s62["__p"]["cl"]
	var _t120 = J.gp(v_o_294, "w")
	v_w_305 = J.cl(_t119, null, [(_t120 if J.t(_t120) else 0.0)])
	var _t121 = J.gp(_s62["__p"]["PAPER"], _s62["type"])
	if J.t((J.cmp(v_w_305, 0.0, ">") if J.t(_t121) else _t121)):
		var _t122 = _s62["__p"]["add"]
		var _t124 = J.mul((sin(J.num(J.mul(_s62["t"], 31.0))) * 0.05), v_w_305)
		var _t125 = J.mul((sin(J.num((J.mul(_s62["t"], 27.0) + 1.0))) * 0.05), v_w_305)
		var _t126 = (1.0 + J.mul((sin(J.num(J.mul(_s62["t"], 23.0))) * 0.012), v_w_305))
		var _t123 = J.gp(v_o_294, "run")
		J.cl(_t122, null, [v_P_302, {"armF": _t124, "armB": _t125, "sx": _t126, "body": J.mul(0.04, (_t123 if J.t(_t123) else 0.0))}])
	if J.seq(_s62["type"], "youhun"):
		var _t127 = J.gp(v_P_302, "rot")
		var _t128 = J.add((_t127 if J.t(_t127) else 0.0), J.mul((sin(J.num(J.mul(_s62["t"], 1.7))) * 0.05), _s62["fwd"]))
		J.sp(v_P_302, "rot", _t128)
		var _t129 = J.add(v_lift_303, J.mul(((sin(J.num(J.mul(_s62["t"], 1.1))) + 1.0) * 1.2), _s62["s"]))
		v_lift_303 = _t129
	if J.seq(_s62["type"], "shuigui"):
		var _t130 = _s62["__p"]["add"]
		J.cl(_t130, null, [v_P_302, {"head": 0.07}])
	if J.t(J.gp(v_o_294, "sniff")):
		v_sn_307 = pow(J.num(J.max_([0.0, sin(J.num(J.mul(_s62["t"], 2.6)))])), J.num(6.0))
		var _t131 = _s62["__p"]["add"]
		J.cl(_t131, null, [v_P_302, {"head": (0.2 + J.mul((sin(J.num(J.mul(_s62["t"], 24.0))) * 0.05), v_sn_307)), "body": 0.1}])
	if J.t(J.gp(v_o_294, "sneak")):
		var _t132 = _s62["__p"]["add"]
		J.cl(_t132, null, [v_P_302, {"body": 0.2, "head": 0.06, "sy": 0.9, "sx": 1.05, "armF": (-0.32), "armB": 0.3}])
	v_after_306 = null
	var _t133 = J.gp(v_o_294, "act")
	var _t134 = -1
	var _t135 = false
	if _t134 == -1 and J.seq(_t133, "plaza_talk"): _t134 = 0
	if _t134 == -1 and J.seq(_t133, "plaza_argue"): _t134 = 1
	if _t134 == -1 and J.seq(_t133, "plaza_wave"): _t134 = 2
	if _t134 == -1 and J.seq(_t133, "plaza_bow"): _t134 = 3
	if _t134 == -1 and J.seq(_t133, "plaza_doze"): _t134 = 4
	if _t134 == -1 and J.seq(_t133, "plaza_look"): _t134 = 5
	if _t134 == -1 and J.seq(_t133, "plaza_stretch"): _t134 = 6
	if _t134 == -1 and J.seq(_t133, "plaza_sniff"): _t134 = 7
	if _t134 == -1 and J.seq(_t133, "plaza_backrub"): _t134 = 8
	if _t134 == -1 and J.seq(_t133, "plaza_soup"): _t134 = 9
	if _t134 == -1 and J.seq(_t133, "plaza_hair"): _t134 = 10
	if _t134 == -1 and J.seq(_t133, "plaza_shake"): _t134 = 11
	if _t134 == -1 and J.seq(_t133, "plaza_spin"): _t134 = 12
	if _t134 == -1 and J.seq(_t133, "plaza_boo"): _t134 = 13
	if _t134 == -1 and J.seq(_t133, "plaza_laugh"): _t134 = 14
	if _t134 == -1 and J.seq(_t133, "plaza_startle"): _t134 = 15
	if _t134 == -1 and J.seq(_t133, "plaza_eek"): _t134 = 16
	if _t134 == -1 and J.seq(_t133, "plaza_reach"): _t134 = 17
	if _t134 == -1 and J.seq(_t133, "plaza_bump"): _t134 = 18
	if _t134 == -1 and J.seq(_t133, "plaza_dizzy"): _t134 = 19
	while true:
		if _t134 <= 0 and _t134 >= 0:
			if J.t(J.gp(v_pl_301, "spk")):
				v_b_308 = J.max_([0.0, sin(J.num(J.mul(_s62["at"], 2.1)))])
				var _t136 = _s62["__p"]["add"]
				J.cl(_t136, null, [v_P_302, {"head": (0.02 + J.mul((sin(J.num(J.mul(_s62["at"], 8.5))) * 0.05), v_b_308)), "armF": J.mul(((-0.22) * (0.5 + (0.5 * sin(J.num(J.mul(_s62["at"], 3.2)))))), v_b_308), "body": J.mul(0.03, v_b_308)}])
			else:
				var _t138 = _s62["__p"]["PI"]
				var _t137 = _s62["__p"]["seg"]
				v_n_309 = sin(J.num(J.mul(_t138, J.cl(_t137, null, [J.mod(_s62["at"], 1.5), 0.2, 0.75]))))
				var _t139 = _s62["__p"]["add"]
				J.cl(_t139, null, [v_P_302, {"head": J.mul(0.08, v_n_309), "body": J.mul(0.01, v_n_309)}])
			break
		if _t134 <= 1 and _t134 >= 0:
			if J.t(J.gp(v_pl_301, "spk")):
				var _t140 = _s62["__p"]["add"]
				J.cl(_t140, null, [v_P_302, {"body": 0.09, "head": (0.07 + (sin(J.num(J.mul(_s62["at"], 12.0))) * 0.06)), "armF": ((-0.32) + (sin(J.num(J.mul(_s62["at"], 6.5))) * 0.18)), "sx": (1.0 + (absf(J.num(sin(J.num(J.mul(_s62["at"], 6.5))))) * 0.015))}])
			else:
				var _t141 = _s62["__p"]["add"]
				J.cl(_t141, null, [v_P_302, {"body": (-0.06), "head": ((-0.09) + (sin(J.num(J.mul(_s62["at"], 1.3))) * 0.02))}])
			break
		if _t134 <= 2 and _t134 >= 0:
			var _t142 = _s62["__p"]["env"]
			var _t144 = _s62["at"]
			var _t143 = J.gp(v_pl_301, "d")
			var _t146 = J.sub((_t143 if J.t(_t143) else 1.4), 0.35)
			var _t145 = J.gp(v_pl_301, "d")
			v_k_310 = J.cl(_t142, null, [_t144, 0.0, 0.28, _t146, (_t145 if J.t(_t145) else 1.4)])
			var _t147 = _s62["__p"]["add"]
			J.cl(_t147, null, [v_P_302, {"armF": J.mul(((-0.5) + (sin(J.num(J.mul(_s62["at"], 11.0))) * 0.16)), v_k_310), "body": J.mul((-0.03), v_k_310), "head": (J.mul(0.05, v_k_310) * sin(J.num(J.mul(_s62["at"], 5.5))))}])
			break
		if _t134 <= 3 and _t134 >= 0:
			var _t148 = J.gp(v_pl_301, "d")
			v_d_311 = (_t148 if J.t(_t148) else 1.2)
			var _t149 = _s62["__p"]["env"]
			v_k_312 = J.cl(_t149, null, [_s62["at"], 0.0, J.mul(v_d_311, 0.3), J.mul(v_d_311, 0.62), v_d_311])
			v_deep_313 = (1.0 if J.leq(J.gp(v_pl_301, "deep"), null) else J.gp(v_pl_301, "deep"))
			var _t150 = _s62["__p"]["add"]
			J.cl(_t150, null, [v_P_302, {"body": J.mul(J.mul(0.3, v_k_312), v_deep_313), "head": J.mul(J.mul(0.22, v_k_312), v_deep_313), "armF": J.mul(0.08, v_k_312), "armB": J.mul((-0.08), v_k_312), "sy": (1.0 - J.mul(0.02, v_k_312))}])
			break
		if _t134 <= 4 and _t134 >= 0:
			var _t151 = J.gp(v_pl_301, "d")
			v_d_314 = (_t151 if J.t(_t151) else 8.0)
			var _t152 = _s62["__p"]["env"]
			v_k_315 = J.cl(_t152, null, [_s62["at"], 0.0, 1.4, J.sub(v_d_314, 0.7), v_d_314])
			v_j_316 = J.mod(_s62["at"], 5.6)
			var _t153 = J.cmp(v_j_316, 4.3, ">")
			var _t156 = null
			if (J.cmp(v_j_316, 4.9, "<") if _t153 else _t153):
				var _t155 = _s62["__p"]["PI"]
				var _t154 = _s62["__p"]["seg"]
				_t156 = sin(J.num(J.mul(_t155, J.cl(_t154, null, [v_j_316, 4.3, 4.9]))))
			else:
				_t156 = 0.0
			v_wake_317 = _t156
			v_br_318 = sin(J.num(J.mul(_s62["t"], 1.1)))
			var _t157 = _s62["__p"]["add"]
			J.cl(_t157, null, [v_P_302, {"head": J.mul(((0.28 * (1.0 - J.mul(v_wake_317, 1.3))) + J.mul(v_br_318, 0.03)), v_k_315), "body": J.mul(0.07, v_k_315), "armF": J.mul(0.06, v_k_315), "armB": J.mul((-0.06), v_k_315), "sy": (1.0 + J.mul(J.mul(v_br_318, 0.018), v_k_315)), "hairL": J.mul(0.08, v_k_315), "hairR": J.mul(0.08, v_k_315)}])
			var _t158 = J.mul(v_k_315, J.sub(1.0, v_wake_317))
			J.sp(v_o_294, "_z", _t158)
			break
		if _t134 <= 5 and _t134 >= 0:
			var _t159 = _s62["__p"]["env"]
			var _t161 = _s62["at"]
			var _t160 = J.gp(v_pl_301, "d")
			var _t163 = J.sub((_t160 if J.t(_t160) else 2.0), 0.3)
			var _t162 = J.gp(v_pl_301, "d")
			v_k_319 = J.cl(_t159, null, [_t161, 0.0, 0.3, _t163, (_t162 if J.t(_t162) else 2.0)])
			var _t164 = _s62["__p"]["add"]
			J.cl(_t164, null, [v_P_302, {"head": J.mul(((-0.06) + (sin(J.num(J.mul(_s62["at"], 2.2))) * 0.04)), v_k_319), "body": J.mul((-0.02), v_k_319)}])
			break
		if _t134 <= 6 and _t134 >= 0:
			var _t165 = J.gp(v_pl_301, "d")
			v_d_320 = (_t165 if J.t(_t165) else 2.0)
			var _t166 = _s62["__p"]["env"]
			v_k_321 = J.cl(_t166, null, [_s62["at"], 0.0, 0.6, J.sub(v_d_320, 0.6), v_d_320])
			var _t168 = (sin(J.num(J.mul(_s62["t"], 30.0))) * 0.012)
			var _t167 = J.cmp(_s62["at"], 0.6, ">")
			v_q_322 = (_t168 * (1.0 if (J.cmp(_s62["at"], J.sub(v_d_320, 0.6), "<") if _t167 else _t167) else 0.0))
			var _t169 = _s62["__p"]["add"]
			J.cl(_t169, null, [v_P_302, {"armF": J.mul((-0.5), v_k_321), "armB": J.mul(0.5, v_k_321), "body": J.add(J.mul((-0.1), v_k_321), v_q_322), "head": J.mul((-0.12), v_k_321), "sy": (1.0 + J.mul(0.05, v_k_321)), "sx": (1.0 - J.mul(0.025, v_k_321))}])
			break
		if _t134 <= 7 and _t134 >= 0:
			v_sn_323 = pow(J.num(J.max_([0.0, sin(J.num(J.mul(_s62["at"], 3.1)))])), J.num(4.0))
			var _t170 = _s62["__p"]["add"]
			J.cl(_t170, null, [v_P_302, {"head": (0.24 + J.mul((sin(J.num(J.mul(_s62["at"], 24.0))) * 0.06), v_sn_323)), "body": 0.12, "sy": (1.0 - J.mul(0.02, v_sn_323))}])
			v_after_306 = Callable(self, "_f32").bind(_s62)
			break
		if _t134 <= 8 and _t134 >= 0:
			var _t176 = J.gp(v_pl_301, "d")
			v_d_326 = (_t176 if J.t(_t176) else 2.6)
			var _t177 = _s62["__p"]["env"]
			v_k_327 = J.cl(_t177, null, [_s62["at"], 0.0, 0.25, J.sub(v_d_326, 0.7), J.sub(v_d_326, 0.25)])
			var _t178 = _s62["__p"]["bump3"]
			v_st_328 = J.cl(_t178, null, [_s62["at"], J.sub(v_d_326, 0.75), J.sub(v_d_326, 0.45), v_d_326])
			var _t179 = _s62["__p"]["add"]
			J.cl(_t179, null, [v_P_302, {"body": ((J.mul(0.14, v_k_327) + J.mul((sin(J.num(J.mul(_s62["at"], 11.0))) * 0.015), v_k_327)) - J.mul(0.12, v_st_328)), "head": (J.mul(0.06, v_k_327) - J.mul(0.1, v_st_328)), "armB": J.mul((sin(J.num(J.mul(_s62["at"], 11.0))) * 0.11), v_k_327), "sy": ((1.0 - J.mul(0.03, v_k_327)) + J.mul(0.04, v_st_328)), "sx": (1.0 + J.mul((sin(J.num(J.mul(_s62["at"], 22.0))) * 0.01), v_k_327))}])
			v_after_306 = Callable(self, "_f33").bind(_s62)
			break
		if _t134 <= 9 and _t134 >= 0:
			var _s81 = {"__p": _s62, "k": null, "blow": null}
			var _t190 = J.gp(v_pl_301, "d")
			v_d_331 = (_t190 if J.t(_t190) else 10.0)
			var _t191 = _s81["__p"]["__p"]["env"]
			_s81["k"] = J.cl(_t191, null, [_s81["__p"]["at"], 0.0, 0.7, J.sub(v_d_331, 0.7), v_d_331])
			v_c_333 = J.mod(J.sub(_s81["__p"]["at"], 0.7), 4.4)
			var _t194 = null
			if J.cmp(_s81["__p"]["at"], 0.7, ">"):
				var _t193 = _s81["__p"]["__p"]["PI"]
				var _t192 = _s81["__p"]["__p"]["seg"]
				_t194 = sin(J.num(J.mul(_t193, J.cl(_t192, null, [v_c_333, 0.0, 1.0]))))
			else:
				_t194 = 0.0
			_s81["blow"] = _t194
			var _t196 = null
			if J.cmp(_s81["__p"]["at"], 0.7, ">"):
				var _t195 = _s81["__p"]["__p"]["env"]
				_t196 = J.cl(_t195, null, [v_c_333, 1.2, 1.5, 3.6, 4.0])
			else:
				_t196 = 0.0
			v_stir_335 = _t196
			J.sp(v_o_294, "sit", 1.0)
			var _t197 = _s81["__p"]["__p"]["add"]
			J.cl(_t197, null, [v_P_302, {"y": J.mul(0.07, _s81["k"]), "sy": (1.0 - J.mul(0.07, _s81["k"])), "sx": (1.0 + J.mul(0.04, _s81["k"])), "tail1": J.mul(0.3, _s81["k"]), "tail2": J.mul(0.45, _s81["k"]), "head": J.mul(0.12, _s81["blow"]), "body": (J.mul(0.05, _s81["blow"]) + J.mul((sin(J.num(J.mul(_s81["__p"]["at"], 5.0))) * 0.015), v_stir_335)), "armB": J.mul(((sin(J.num(J.mul(_s81["__p"]["at"], 5.0))) * 0.09) + 0.05), v_stir_335)}])
			v_after_306 = Callable(self, "_f34").bind(_s81)
			break
		if _t134 <= 10 and _t134 >= 0:
			v_c_338 = J.mod(_s62["at"], 2.3)
			var _t203 = _s62["__p"]["eio"]
			var _t204 = _s62["__p"]["seg"]
			v_up_339 = J.cl(_t203, null, [J.cl(_t204, null, [v_c_338, 0.0, 0.35])])
			var _t205 = _s62["__p"]["eio"]
			var _t206 = _s62["__p"]["seg"]
			v_down_340 = J.cl(_t205, null, [J.cl(_t206, null, [v_c_338, 0.35, 1.25])])
			var _t207 = _s62["__p"]["eio"]
			var _t208 = _s62["__p"]["seg"]
			v_rel_341 = J.cl(_t207, null, [J.cl(_t208, null, [v_c_338, 1.25, 2.0])])
			v_arm_342 = ((J.mul((-0.75), v_up_339) * J.sub(1.0, v_down_340)) + (J.mul(0.15, v_down_340) * J.sub(1.0, v_rel_341)))
			var _t210 = _s62["__p"]["PI"]
			var _t209 = _s62["__p"]["seg"]
			v_pull_343 = sin(J.num(J.mul(_t210, J.cl(_t209, null, [v_c_338, 0.35, 1.5]))))
			var _t211 = _s62["__p"]["add"]
			var _t215 = ((J.mul(0.16, v_up_339) * J.sub(1.0, v_rel_341)) + 0.04)
			var _t214 = J.mul(0.38, v_pull_343)
			var _t213 = _s62["__p"]["PI"]
			var _t212 = _s62["__p"]["seg"]
			J.cl(_t211, null, [v_P_302, {"armF": v_arm_342, "head": _t215, "hairL": (_t214 - (0.12 * sin(J.num(J.mul(_t213, J.cl(_t212, null, [v_c_338, 1.4, 2.3])))))), "hairR": ((sin(J.num(J.mul(_s62["at"], 1.7))) * 0.1) + J.mul(0.08, v_pull_343)), "body": (J.mul((-0.04), v_pull_343) + (J.mul(0.03, v_up_339) * J.sub(1.0, v_rel_341)))}])
			break
		if _t134 <= 11 and _t134 >= 0:
			var _t216 = _s62["__p"]["seg"]
			v_sh_344 = J.cl(_t216, null, [_s62["at"], 0.25, 1.25])
			var _t217 = J.cmp(_s62["at"], 0.25, ">")
			v_amp_345 = ((J.sub(1.0, v_sh_344) * sin(J.num(J.mul(_s62["__p"]["PI"], J.min_([1.0, J.mul(v_sh_344, 6.0)]))))) if (J.cmp(_s62["at"], 1.25, "<") if _t217 else _t217) else 0.0)
			var _t219 = _s62["__p"]["PI"]
			var _t218 = _s62["__p"]["seg"]
			v_cr_346 = (sin(J.num(J.mul(_t219, J.cl(_t218, null, [_s62["at"], 0.0, 0.3])))) * (1.0 if J.cmp(_s62["at"], 0.3, "<") else 0.0))
			var _t220 = _s62["__p"]["add"]
			var _t223 = J.mul((sin(J.num(J.mul(_s62["at"], 30.0))) * 0.1), v_amp_345)
			var _t222 = J.mul(((-sin(J.num(J.mul(_s62["at"], 30.0)))) * 0.12), v_amp_345)
			var _t221 = _s62["__p"]["seg"]
			J.cl(_t220, null, [v_P_302, {"rot": _t223, "head": (_t222 + J.mul(0.1, J.cl(_t221, null, [_s62["at"], 1.25, 1.6]))), "hairL": J.mul((sin(J.num((J.mul(_s62["at"], 30.0) + 1.0))) * 0.35), v_amp_345), "hairR": J.mul((sin(J.num((J.mul(_s62["at"], 30.0) + 2.0))) * 0.35), v_amp_345), "sy": (1.0 - J.mul(0.08, v_cr_346)), "sx": ((1.0 + J.mul(0.04, v_cr_346)) + J.mul(0.03, v_amp_345))}])
			v_after_306 = Callable(self, "_f35").bind(_s62)
			break
		if _t134 <= 12 and _t134 >= 0:
			var _t233 = _s62["__p"]["seg"]
			v_q_353 = J.cl(_t233, null, [_s62["at"], 0.25, 1.35])
			var _t235 = _s62["__p"]["PI"]
			var _t234 = _s62["__p"]["seg"]
			v_cr_354 = (sin(J.num(J.mul(_t235, J.cl(_t234, null, [_s62["at"], 0.0, 0.25])))) * (1.0 if J.cmp(_s62["at"], 0.25, "<") else 0.0))
			var _t237 = _s62["__p"]["PI"]
			var _t236 = _s62["__p"]["seg"]
			v_land_355 = (sin(J.num(J.mul(_t237, J.cl(_t236, null, [_s62["at"], 1.35, 1.75])))) * (1.0 if J.cmp(_s62["at"], 1.35, ">") else 0.0))
			v_c_356 = cos(J.num((J.mul(v_q_353, _s62["__p"]["TAU"]) * 2.0)))
			var _t238 = J.gp(v_P_302, "sx")
			var _t239 = ((J.mul((_t238 if J.t(_t238) else 1.0), signf(J.num((v_c_356 if J.t(v_c_356) else 1.0)))) * J.max_([0.07, absf(J.num(v_c_356))])) * (1.0 + J.mul(0.06, v_cr_354)))
			J.sp(v_P_302, "sx", _t239)
			var _t240 = _s62["__p"]["add"]
			J.cl(_t240, null, [v_P_302, {"sy": (((1.0 - J.mul(0.1, v_cr_354)) - J.mul(0.06, v_land_355)) + (0.05 * sin(J.num(J.mul(_s62["__p"]["PI"], v_q_353))))), "tail1": ((sin(J.num(J.mul(_s62["at"], 12.0))) * 0.3) * sin(J.num(J.mul(_s62["__p"]["PI"], v_q_353)))), "tail2": ((sin(J.num((J.mul(_s62["at"], 12.0) - 1.0))) * 0.45) * sin(J.num(J.mul(_s62["__p"]["PI"], v_q_353)))), "head": ((-0.08) * sin(J.num(J.mul(_s62["__p"]["PI"], v_q_353))))}])
			var _t241 = J.add(v_lift_303, J.mul((sin(J.num(J.mul(_s62["__p"]["PI"], v_q_353))) * 8.0), _s62["s"]))
			v_lift_303 = _t241
			v_after_306 = Callable(self, "_f36").bind(_s62)
			break
		if _t134 <= 13 and _t134 >= 0:
			var _t254 = null
			if J.cmp(_s62["at"], 0.15, "<"):
				var _t253 = _s62["__p"]["PI"]
				var _t252 = _s62["__p"]["seg"]
				_t254 = sin(J.num(J.mul(_t253, J.cl(_t252, null, [_s62["at"], 0.0, 0.15]))))
			else:
				_t254 = 0.0
			v_cr_359 = _t254
			var _t255 = _s62["__p"]["env"]
			v_k_360 = J.cl(_t255, null, [_s62["at"], 0.12, 0.26, 0.72, 0.95])
			var _t256 = J.cmp(_s62["at"], 0.26, ">")
			v_tr_361 = ((sin(J.num(J.mul(_s62["at"], 42.0))) * 0.03) if (J.cmp(_s62["at"], 0.72, "<") if _t256 else _t256) else 0.0)
			var _t257 = _s62["__p"]["add"]
			J.cl(_t257, null, [v_P_302, {"sy": ((1.0 - J.mul(0.13, v_cr_359)) + J.mul(0.12, v_k_360)), "sx": ((1.0 + J.mul(0.06, v_cr_359)) - J.mul(0.05, v_k_360)), "armF": J.add(J.mul((-0.6), v_k_360), v_tr_361), "armB": J.sub(J.mul(0.6, v_k_360), v_tr_361), "head": J.mul((-0.12), v_k_360), "body": (J.mul(0.12, v_k_360) + J.mul(0.08, v_cr_359)), "x": J.mul(0.05, v_k_360)}])
			var _t258 = J.add(v_lift_303, J.mul(J.mul(6.0, _s62["s"]), v_k_360))
			v_lift_303 = _t258
			v_after_306 = Callable(self, "_f37").bind(_s62)
			break
		if _t134 <= 14 and _t134 >= 0:
			var _s93 = {"__p": _s62, "k": null, "b": null}
			var _t269 = J.gp(v_pl_301, "d")
			v_d_364 = (_t269 if J.t(_t269) else 1.6)
			var _t270 = _s93["__p"]["__p"]["env"]
			_s93["k"] = J.cl(_t270, null, [_s93["__p"]["at"], 0.0, 0.15, J.sub(v_d_364, 0.3), v_d_364])
			_s93["b"] = absf(J.num(sin(J.num(J.mul(_s93["__p"]["at"], 15.0)))))
			var _t271 = _s93["__p"]["__p"]["add"]
			J.cl(_t271, null, [v_P_302, {"body": J.mul((0.16 + J.mul(_s93["b"], 0.05)), _s93["k"]), "head": J.mul((0.06 + (sin(J.num(J.mul(_s93["__p"]["at"], 15.0))) * 0.08)), _s93["k"]), "sy": (1.0 - J.mul(J.mul(_s93["b"], 0.04), _s93["k"])), "armB": J.mul(0.25, _s93["k"]), "armF": J.mul(0.2, _s93["k"])}])
			v_after_306 = Callable(self, "_f38").bind(_s93)
			break
		if _t134 <= 15 and _t134 >= 0:
			pass
		if _t134 <= 16 and _t134 >= 0:
			var _t277 = J.gp(v_pl_301, "d")
			v_d_369 = (_t277 if J.t(_t277) else (0.75 if J.seq(J.gp(v_o_294, "act"), "plaza_eek") else 1.3))
			var _t280 = null
			if J.cmp(_s62["at"], 0.08, "<"):
				var _t279 = _s62["__p"]["PI"]
				var _t278 = _s62["__p"]["seg"]
				_t280 = sin(J.num(J.mul(_t279, J.cl(_t278, null, [_s62["at"], 0.0, 0.08]))))
			else:
				_t280 = 0.0
			v_cr_370 = _t280
			var _t282 = _s62["__p"]["PI"]
			var _t281 = _s62["__p"]["seg"]
			var _t284 = sin(J.num(J.mul(_t282, J.cl(_t281, null, [_s62["at"], 0.06, 0.32]))))
			var _t283 = J.cmp(_s62["at"], 0.06, ">")
			v_j_371 = (_t284 * (1.0 if (J.cmp(_s62["at"], 0.32, "<") if _t283 else _t283) else 0.0))
			var _t287 = null
			if J.cmp(_s62["at"], 0.3, ">"):
				var _t286 = (sin(J.num(J.mul(_s62["at"], 45.0))) * 0.03)
				var _t285 = _s62["__p"]["seg"]
				_t287 = (_t286 * J.sub(1.0, J.cl(_t285, null, [_s62["at"], 0.3, v_d_369])))
			else:
				_t287 = 0.0
			v_tr_372 = _t287
			var _t288 = _s62["__p"]["eio"]
			var _t289 = _s62["__p"]["seg"]
			v_k_373 = J.sub(1.0, J.cl(_t288, null, [J.cl(_t289, null, [_s62["at"], J.mul(v_d_369, 0.65), v_d_369])]))
			var _t290 = _s62["__p"]["add"]
			J.cl(_t290, null, [v_P_302, {"sy": ((1.0 - J.mul(0.1, v_cr_370)) + J.mul(0.06, v_j_371)), "armF": J.add(J.mul((J.mul((-0.55), v_j_371) - 0.2), v_k_373), v_tr_372), "armB": J.sub(J.mul((J.mul(0.55, v_j_371) + 0.2), v_k_373), v_tr_372), "head": (J.mul((J.mul((-0.2), v_j_371) - 0.06), v_k_373) + J.mul(v_tr_372, 2.0)), "body": J.add(J.mul((J.mul((-0.1), v_j_371) - 0.04), v_k_373), v_tr_372), "hairL": J.mul((-0.25), v_j_371), "hairR": J.mul((-0.25), v_j_371)}])
			var _t291 = J.add(v_lift_303, J.mul(J.mul(v_j_371, 7.0), _s62["s"]))
			v_lift_303 = _t291
			break
		if _t134 <= 17 and _t134 >= 0:
			var _t292 = _s62["__p"]["env"]
			v_k_374 = J.cl(_t292, null, [_s62["at"], 0.0, 0.12, 0.3, 0.5])
			var _t293 = _s62["__p"]["add"]
			J.cl(_t293, null, [v_P_302, {"body": J.mul(0.18, v_k_374), "armF": J.mul((-0.55), v_k_374), "head": J.mul(0.05, v_k_374), "x": J.mul(0.05, v_k_374)}])
			break
		if _t134 <= 18 and _t134 >= 0:
			var _t296 = null
			if J.cmp(_s62["at"], 0.12, "<"):
				var _t295 = _s62["__p"]["PI"]
				var _t294 = _s62["__p"]["seg"]
				_t296 = sin(J.num(J.mul(_t295, J.cl(_t294, null, [_s62["at"], 0.0, 0.12]))))
			else:
				_t296 = 0.0
			v_im_375 = _t296
			var _t298 = _s62["__p"]["PI"]
			var _t297 = _s62["__p"]["seg"]
			var _t300 = sin(J.num(J.mul(_t298, J.cl(_t297, null, [_s62["at"], 0.1, 0.55]))))
			var _t299 = J.cmp(_s62["at"], 0.1, ">")
			v_back_376 = (_t300 * (1.0 if (J.cmp(_s62["at"], 0.55, "<") if _t299 else _t299) else 0.0))
			var _t303 = null
			if J.cmp(_s62["at"], 0.55, ">"):
				var _t302 = _s62["__p"]["PI"]
				var _t301 = _s62["__p"]["seg"]
				_t303 = sin(J.num(J.mul(_t302, J.cl(_t301, null, [_s62["at"], 0.55, 0.75]))))
			else:
				_t303 = 0.0
			v_land_377 = _t303
			var _t304 = _s62["__p"]["add"]
			J.cl(_t304, null, [v_P_302, {"sx": ((1.0 - J.mul(0.14, v_im_375)) + J.mul(0.08, v_land_377)), "sy": ((1.0 + J.mul(0.07, v_im_375)) - J.mul(0.1, v_land_377)), "body": (J.mul((-0.22), v_im_375) - J.mul(0.12, v_back_376)), "head": (J.mul((-0.2), v_im_375) - J.mul(0.1, v_back_376)), "armF": J.mul(0.25, v_im_375), "armB": J.mul((-0.25), v_im_375)}])
			var _t305 = J.add(v_lift_303, J.mul(J.mul(v_back_376, 7.0), _s62["s"]))
			v_lift_303 = _t305
			v_after_306 = Callable(self, "_f39").bind(_s62)
			break
		if _t134 <= 19 and _t134 >= 0:
			var _t316 = J.gp(v_pl_301, "d")
			v_d_380 = (_t316 if J.t(_t316) else 2.2)
			var _t317 = _s62["__p"]["eio"]
			var _t318 = _s62["__p"]["seg"]
			v_k_381 = J.sub(1.0, J.cl(_t317, null, [J.cl(_t318, null, [_s62["at"], J.sub(v_d_380, 0.6), v_d_380])]))
			var _t319 = _s62["__p"]["add"]
			J.cl(_t319, null, [v_P_302, {"rot": J.mul((sin(J.num(J.mul(_s62["at"], 6.0))) * 0.08), v_k_381), "head": J.mul((cos(J.num(J.mul(_s62["at"], 6.0))) * 0.12), v_k_381), "body": J.mul((sin(J.num((J.mul(_s62["at"], 6.0) + 1.0))) * 0.05), v_k_381), "armF": J.mul((sin(J.num(J.mul(_s62["at"], 6.0))) * 0.1), v_k_381), "armB": J.mul((cos(J.num(J.mul(_s62["at"], 6.0))) * 0.1), v_k_381)}])
			J.sp(v_o_294, "_stars", v_k_381)
			break
		break
	var _t320 = _s62["__p"]["drawM"]
	J.cl(_t320, null, [_s62["ctx"], _s62["a"], v_P_302, v_lift_303, v_shK_304])
	if J.t(v_after_306):
		J.cl(v_after_306, null, [])

func _f40(this_, a: Array, env):
	var v_g_384 = null; var v_a_385 = null; var v_m_386 = null; var v_b_387 = null
	v_g_384 = J.arg(a, 0)
	v_a_385 = J.arg(a, 1)
	v_m_386 = J.arg(a, 2)
	v_b_387 = J.arg(a, 3)
	var _t321 = J.cmp(v_g_384, v_a_385, "<=")
	var _t325 = null
	if (_t321 if _t321 else J.cmp(v_g_384, v_b_387, ">=")):
		_t325 = 0.0
	else:
		var _t324 = null
		if J.cmp(v_g_384, v_m_386, "<"):
			var _t322 = env["eio"]
			_t324 = J.cl(_t322, null, [J.div(J.sub(v_g_384, v_a_385), J.sub(v_m_386, v_a_385))])
		else:
			var _t323 = env["eio"]
			_t324 = J.sub(1.0, J.cl(_t323, null, [J.div(J.sub(v_g_384, v_m_386), J.sub(v_b_387, v_m_386))]))
		_t325 = _t324
	return _t325

func _f41(this_, a: Array, env):
	var v_ctx_390 = null; var v_a_391 = null; var v_c_392 = null; var v_o_393 = null; var v_t_394 = null; var v_H_395 = null; var v_s_396 = null; var v_fwd_397 = null; var v_body_398 = null; var v_arm_399 = null; var v_W_400 = null; var v_P_401 = null; var v_cyc_402 = null; var v_ph_403 = null; var v_raise_404 = null; var v_away_405 = null; var v_lk_406 = null; var v_chomp_407 = null; var v_ck_408 = null; var v_chew_409 = null; var v_th_410 = null; var v_hx_411 = null; var v_hy_412 = null; var v_mp_413 = null; var v_fy_414 = null; var v_bA_415 = null; var v_bp_416 = null; var v_pv_417 = null; var v_rx_418 = null; var v_ry_419 = null; var v_px_420 = null; var v_py_421 = null; var v_m2_422 = null; var v_mx_423 = null; var v_my_424 = null; var v_k_425 = null
	v_ctx_390 = J.arg(a, 0)
	v_a_391 = J.arg(a, 1)
	var _t326 = (not J.seq(J.typeof_(J.G.get("LIMBS_DATA")), "undefined"))
	v_c_392 = (J.gp(J.gp(J.G.get("LIMBS_DATA"), "chars"), "eguiking") if _t326 else _t326)
	var _t328 = (not J.t(v_c_392))
	if not J.t(_t328):
		var _t327 = env["ok"]
		_t328 = (not J.t(J.cl(_t327, null, ["eguiking__body"])))
	var _t330 = _t328
	if not J.t(_t330):
		var _t329 = env["ok"]
		_t330 = (not J.t(J.cl(_t329, null, ["eguiking__arm"])))
	if _t330:
		return false
	v_o_393 = J.gp(v_a_391, "o")
	var _t331 = J.gp(v_o_393, "t")
	v_t_394 = (_t331 if J.t(_t331) else 0.0)
	v_H_395 = J.gp(v_a_391, "H")
	v_s_396 = J.gp(v_a_391, "s")
	v_fwd_397 = (1.0 if J.t(J.gp(v_a_391, "faceRight")) else (-1.0))
	v_body_398 = J.gp(J.G.get("SPR"), "eguiking__body")
	v_arm_399 = J.gp(J.G.get("SPR"), "eguiking__arm")
	v_W_400 = J.div(J.mul(v_H_395, J.gp(v_body_398, "naturalWidth")), J.gp(v_body_398, "naturalHeight"))
	var _t332 = env["basePose"]
	v_P_401 = J.cl(_t332, null, [v_o_393, "eguiking"])
	v_cyc_402 = 3.6
	var _t333 = J.gp(v_o_393, "at")
	v_ph_403 = J.mod(J.add((_t333 if J.t(_t333) else 0.0), 0.15), v_cyc_402)
	var _t334 = env["eio"]
	var _t335 = env["seg"]
	v_raise_404 = J.cl(_t334, null, [J.cl(_t335, null, [v_ph_403, 0.1, 0.62])])
	var _t336 = env["eio"]
	var _t337 = env["seg"]
	v_away_405 = J.cl(_t336, null, [J.cl(_t337, null, [v_ph_403, 0.86, 1.3])])
	v_lk_406 = J.mul(v_raise_404, J.sub(1.0, v_away_405))
	var _t338 = env["bump3"]
	v_chomp_407 = J.cl(_t338, null, [v_ph_403, 0.6, 0.67, 0.86])
	var _t339 = env["seg"]
	v_ck_408 = J.cl(_t339, null, [v_ph_403, 1.3, 2.7])
	var _t340 = J.cmp(v_ph_403, 1.3, ">")
	v_chew_409 = ((sin(J.num((J.mul(v_ck_408, env["PI"]) * 6.0))) * (1.0 - J.mul(v_ck_408, 0.4))) if (J.cmp(v_ph_403, 2.7, "<") if _t340 else _t340) else 0.0)
	var _t341 = env["add"]
	var _t343 = J.mul((-0.07), v_raise_404)
	var _t342 = env["seg"]
	J.cl(_t341, null, [v_P_401, {"head": (((_t343 * J.sub(1.0, J.cl(_t342, null, [v_ph_403, 0.55, 0.62]))) + J.mul(0.1, v_chomp_407)) + J.mul(0.035, v_chew_409)), "body": J.mul(0.04, v_chomp_407), "sy": ((1.0 - J.mul(0.025, v_chomp_407)) - (0.012 * absf(J.num(v_chew_409)))), "sx": (1.0 + (0.015 * absf(J.num(v_chew_409))))}])
	v_th_410 = (J.mul(58.0, v_lk_406) + J.mul(4.0, v_chomp_407))
	v_hx_411 = J.mul(0.06, v_lk_406)
	v_hy_412 = J.mul(0.045, v_lk_406)
	v_mp_413 = {}
	for _t344 in J.keys(v_P_401):
		v_k_425 = _t344
		var _t345 = J.seq(J.typeof_(J.gp(v_P_401, v_k_425)), "number")
		var _t346 = ((not J.seq(v_k_425, "y")) if _t345 else _t345)
		var _t347 = ((not J.seq(v_k_425, "sx")) if _t346 else _t346)
		var _t348 = ((-J.num(J.gp(v_P_401, v_k_425))) if ((not J.seq(v_k_425, "sy")) if _t347 else _t347) else J.gp(v_P_401, v_k_425))
		J.sp(v_mp_413, v_k_425, _t348)
	v_fy_414 = J.mul((3.0 + (sin(J.num(J.mul(v_t_394, 2.4))) * 2.0)), v_s_396)
	var _t349 = env["shadowAt"]
	J.cl(_t349, null, [v_ctx_390, v_a_391, 0.0, 1.0])
	J.mc(v_ctx_390, "save", [])
	J.mc(v_ctx_390, "translate", [J.gp(v_a_391, "x"), J.sub(J.gp(v_a_391, "y"), v_fy_414)])
	if J.t(J.gp(v_a_391, "faceRight")):
		J.mc(v_ctx_390, "scale", [(-1.0), 1.0])
	var _t350 = J.gp(v_mp_413, "x")
	var _t352 = J.mul((_t350 if J.t(_t350) else 0.0), v_W_400)
	var _t351 = J.gp(v_mp_413, "y")
	J.mc(v_ctx_390, "translate", [_t352, J.mul((_t351 if J.t(_t351) else 0.0), v_H_395)])
	var _t353 = J.gp(v_mp_413, "sx")
	var _t355 = (_t353 if J.t(_t353) else 1.0)
	var _t354 = J.gp(v_mp_413, "sy")
	J.mc(v_ctx_390, "scale", [_t355, (_t354 if J.t(_t354) else 1.0)])
	var _t356 = J.gp(v_mp_413, "body")
	v_bA_415 = (_t356 if J.t(_t356) else 0.0)
	v_bp_416 = [(J.mul(0.48, v_W_400) - J.div(v_W_400, 2.0)), J.sub(J.mul(0.7, v_H_395), v_H_395)]
	v_pv_417 = [(J.mul(J.gp(J.gp(v_c_392, "pivot"), 0.0), v_W_400) - J.div(v_W_400, 2.0)), J.sub(J.mul(J.gp(J.gp(v_c_392, "pivot"), 1.0), v_H_395), v_H_395)]
	v_rx_418 = J.sub(J.gp(v_pv_417, 0.0), J.gp(v_bp_416, 0.0))
	v_ry_419 = J.sub(J.gp(v_pv_417, 1.0), J.gp(v_bp_416, 1.0))
	v_px_420 = (J.sub(J.add(J.gp(v_bp_416, 0.0), J.mul(cos(J.num(v_bA_415)), v_rx_418)), J.mul(sin(J.num(v_bA_415)), v_ry_419)) + J.mul(v_hx_411, v_W_400))
	v_py_421 = J.sub(J.add(J.add(J.gp(v_bp_416, 1.0), J.mul(sin(J.num(v_bA_415)), v_rx_418)), J.mul(cos(J.num(v_bA_415)), v_ry_419)), J.mul(v_hy_412, v_H_395))
	v_m2_422 = J.S_Object_("assign", [{}, v_mp_413, {"x": 0.0, "y": 0.0, "sx": 1.0, "sy": 1.0, "rot": 0.0, "armF": 0.0}])
	J.mc(J.G.get("MeshAnim"), "drawBody", [v_ctx_390, "eguiking", "eguiking__body", v_H_395, v_m2_422])
	J.mc(v_ctx_390, "save", [])
	J.mc(v_ctx_390, "translate", [v_px_420, v_py_421])
	J.mc(v_ctx_390, "rotate", [J.add(v_bA_415, J.mul(v_th_410, env["D"]))])
	J.mc(v_ctx_390, "drawImage", [v_arm_399, J.mul((-J.num(J.gp(J.gp(v_c_392, "pivot"), 0.0))), v_W_400), J.mul((-J.num(J.gp(J.gp(v_c_392, "pivot"), 1.0))), v_H_395), v_W_400, v_H_395])
	J.mc(v_ctx_390, "restore", [])
	J.mc(v_ctx_390, "restore", [])
	v_mx_423 = J.sub(J.gp(v_a_391, "x"), J.mul(J.mul(v_fwd_397, 0.03), v_W_400))
	v_my_424 = (J.sub(J.gp(v_a_391, "y"), v_fy_414) - J.mul(0.66, v_H_395))
	var _t357 = env["crumbs"]
	var _t359 = J.sub(v_ph_403, 0.66)
	var _t358 = J.gp(v_o_393, "at")
	J.cl(_t357, null, [v_ctx_390, v_mx_423, v_my_424, _t359, v_s_396, ((floor(J.num(J.div(J.add((_t358 if J.t(_t358) else 0.0), 0.15), v_cyc_402))) * 13.0) + 3.0), v_fwd_397])

func _f42(this_, a: Array, env):
	var v_ctx_428 = null; var v_a_429 = null; var v_o_430 = null; var v_t_431 = null; var v_H_432 = null; var v_s_433 = null; var v_fwd_434 = null; var v_at_435 = null; var v_d_436 = null; var v_IN_437 = null; var v_L_438 = null; var v_n_439 = null; var v_last_440 = null; var v_pose_441 = null; var v_pt_442 = null; var v_c_443 = null; var v_ball_444 = null; var v_mp_445 = null; var v_fy_446 = null; var v_bx_447 = null; var v_by_448 = null; var v_e_449 = null; var v_x_450 = null; var v_y_451 = null
	v_ctx_428 = J.arg(a, 0)
	v_a_429 = J.arg(a, 1)
	var _t360 = J.seq(J.typeof_(J.G.get("Limbs")), "undefined")
	if (_t360 if _t360 else (not J.t(J.mc(J.G.get("Limbs"), "has", ["huang"])))):
		return false
	v_o_430 = J.gp(v_a_429, "o")
	var _t361 = J.gp(v_o_430, "t")
	v_t_431 = (_t361 if J.t(_t361) else 0.0)
	v_H_432 = J.gp(v_a_429, "H")
	v_s_433 = J.gp(v_a_429, "s")
	v_fwd_434 = (1.0 if J.t(J.gp(v_a_429, "faceRight")) else (-1.0))
	var _t362 = J.gp(v_o_430, "at")
	v_at_435 = (_t362 if J.t(_t362) else 0.0)
	var _t363 = J.gp(v_o_430, "pl")
	var _t364 = (J.gp(J.gp(v_o_430, "pl"), "d") if J.t(_t363) else _t363)
	v_d_436 = (_t364 if J.t(_t364) else 9.6)
	v_IN_437 = 0.9
	v_L_438 = 4.0
	v_n_439 = J.max_([1.0, floor(J.num((J.div((J.sub(v_d_436, v_IN_437) - 0.7), v_L_438) + 0.01)))])
	v_last_440 = J.cmp(v_at_435, J.add(v_IN_437, J.mul(J.sub(v_n_439, 1.0), v_L_438)), ">=")
	v_pose_441 = "recover"
	v_pt_442 = 0.0
	v_c_443 = (-1.0)
	v_ball_444 = 0.0
	if J.cmp(v_at_435, v_IN_437, "<"):
		if J.cmp(v_at_435, 0.5, "<"):
			v_pose_441 = "recover"
			var _t365 = env["eio"]
			var _t366 = env["seg"]
			var _t367 = J.sub(1.0, J.cl(_t365, null, [J.cl(_t366, null, [v_at_435, 0.0, 0.5])]))
			v_pt_442 = _t367
		else:
			v_pose_441 = "follow"
			var _t368 = env["eio"]
			var _t369 = env["seg"]
			var _t370 = J.sub(1.0, J.cl(_t368, null, [J.cl(_t369, null, [v_at_435, 0.5, v_IN_437])]))
			v_pt_442 = _t370
		var _t371 = env["seg"]
		var _t372 = J.cl(_t371, null, [v_at_435, 0.3, 0.8])
		v_ball_444 = _t372
	else:
		var _t373 = J.min_([J.add(J.mod(J.sub(v_at_435, v_IN_437), v_L_438), (v_L_438 if J.cmp(v_at_435, J.add(v_IN_437, J.mul(v_n_439, v_L_438)), ">=") else 0.0)), (99.0 if J.t(v_last_440) else J.sub(v_L_438, 0.000001))])
		v_c_443 = _t373
		if J.t(v_last_440):
			var _t374 = (J.sub(v_at_435, v_IN_437) - J.mul(J.sub(v_n_439, 1.0), v_L_438))
			v_c_443 = _t374
		if J.cmp(v_c_443, 1.0, "<"):
			v_pose_441 = "strike"
			var _t375 = (0.42 - ((0.035 * (0.5 - (0.5 * cos(J.num((J.mul(v_c_443, env["TAU"]) * 1.5)))))) * (1.0 if J.cmp(v_c_443, 0.95, "<") else 0.0)))
			v_pt_442 = _t375
			v_ball_444 = 1.0
		else:
			if J.cmp(v_c_443, 1.9, "<"):
				v_pose_441 = "strike"
				var _t376 = env["eio"]
				var _t377 = env["seg"]
				var _t378 = (0.42 * J.sub(1.0, J.cl(_t376, null, [J.cl(_t377, null, [v_c_443, 1.0, 1.9])])))
				v_pt_442 = _t378
				v_ball_444 = 1.0
			else:
				if J.cmp(v_c_443, 2.1, "<"):
					v_pose_441 = "strike"
					v_pt_442 = 0.0
					v_ball_444 = 1.0
				else:
					if J.cmp(v_c_443, 2.24, "<"):
						v_pose_441 = "strike"
						var _t379 = env["ei"]
						var _t380 = env["seg"]
						var _t381 = J.mul(0.42, J.cl(_t379, null, [J.cl(_t380, null, [v_c_443, 2.1, 2.24])]))
						v_pt_442 = _t381
						v_ball_444 = 1.0
					else:
						if J.cmp(v_c_443, 2.55, "<"):
							v_pose_441 = "follow"
							var _t382 = env["eo3"]
							var _t383 = env["seg"]
							var _t384 = J.cl(_t382, null, [J.cl(_t383, null, [v_c_443, 2.24, 2.55])])
							v_pt_442 = _t384
						else:
							var _t385 = J.cmp(v_c_443, 3.3, "<")
							if J.t((_t385 if _t385 else (J.cmp(v_c_443, 3.4, "<") if J.t(v_last_440) else v_last_440))):
								v_pose_441 = "follow"
								v_pt_442 = 1.0
							else:
								if (not J.t(v_last_440)):
									v_pose_441 = "follow"
									var _t386 = env["eio"]
									var _t387 = env["seg"]
									var _t388 = J.sub(1.0, J.cl(_t386, null, [J.cl(_t387, null, [v_c_443, 3.3, 4.0])]))
									v_pt_442 = _t388
									var _t389 = env["seg"]
									var _t390 = J.cl(_t389, null, [v_c_443, 3.5, 3.9])
									v_ball_444 = _t390
								else:
									v_pose_441 = "recover"
									var _t391 = env["eio"]
									var _t392 = env["seg"]
									var _t393 = J.cl(_t391, null, [J.cl(_t392, null, [v_c_443, 3.4, 4.1])])
									v_pt_442 = _t393
	var _t394 = J.gp(J.G.get("MeshAnim"), "ANIM")
	v_mp_445 = J.mc(_t394, "idle", [v_t_431])
	if J.cmp(v_c_443, 2.4, ">"):
		var _t396 = (-0.1)
		var _t395 = env["env"]
		var _t397 = J.mul(_t396, J.cl(_t395, null, [v_c_443, 2.4, 2.7, 3.1, 3.5]))
		J.sp(v_mp_445, "head", _t397)
	v_fy_446 = J.mul((3.0 + (sin(J.num(J.mul(v_t_431, 2.4))) * 2.0)), v_s_433)
	var _t398 = env["shadowAt"]
	J.cl(_t398, null, [v_ctx_428, v_a_429, 0.0, 1.0])
	J.mc(J.G.get("Limbs"), "draw", [v_ctx_428, "huang", J.gp(v_a_429, "x"), J.sub(J.gp(v_a_429, "y"), v_fy_446), v_H_432, {"pose": v_pose_441, "pt": v_pt_442, "t": v_t_431, "walk": false}, J.gp(v_a_429, "faceRight"), v_mp_445])
	v_bx_447 = J.add(J.gp(v_a_429, "x"), (J.mul(v_fwd_434, v_H_432) * 0.42))
	v_by_448 = J.gp(v_a_429, "y")
	if J.cmp(v_ball_444, 0.0, ">"):
		J.mc(v_ctx_428, "save", [])
		var _t399 = J.mul(J.gp(v_ctx_428, "globalAlpha"), v_ball_444)
		J.sp(v_ctx_428, "globalAlpha", _t399)
		J.sp(v_ctx_428, "fillStyle", "#fbfbf4")
		J.sp(v_ctx_428, "strokeStyle", "#555")
		J.sp(v_ctx_428, "lineWidth", 0.4)
		J.mc(v_ctx_428, "beginPath", [])
		J.mc(v_ctx_428, "arc", [v_bx_447, J.sub(v_by_448, J.mul(1.2, v_s_433)), J.mul(1.5, v_s_433), 0.0, env["TAU"]])
		J.mc(v_ctx_428, "fill", [])
		J.mc(v_ctx_428, "stroke", [])
		J.mc(v_ctx_428, "restore", [])
	var _t400 = J.cmp(v_c_443, 2.24, ">=")
	if (J.cmp(v_c_443, 3.3, "<") if _t400 else _t400):
		v_e_449 = J.sub(v_c_443, 2.24)
		v_x_450 = J.add(v_bx_447, J.mul(J.mul(J.mul(v_fwd_434, 150.0), v_s_433), v_e_449))
		v_y_451 = ((J.sub(v_by_448, J.mul(1.2, v_s_433)) - J.mul(J.mul(120.0, v_s_433), v_e_449)) + J.mul(J.mul(J.mul(70.0, v_s_433), v_e_449), v_e_449))
		J.mc(v_ctx_428, "save", [])
		var _t401 = env["seg"]
		var _t402 = J.mul(J.gp(v_ctx_428, "globalAlpha"), J.sub(1.0, J.cl(_t401, null, [v_e_449, 0.6, 1.0])))
		J.sp(v_ctx_428, "globalAlpha", _t402)
		J.sp(v_ctx_428, "fillStyle", "#fbfbf4")
		J.mc(v_ctx_428, "beginPath", [])
		J.mc(v_ctx_428, "arc", [v_x_450, v_y_451, (J.mul(1.5, v_s_433) * (1.0 - J.mul(0.4, v_e_449))), 0.0, env["TAU"]])
		J.mc(v_ctx_428, "fill", [])
		var _t403 = env["crayon"]
		J.cl(_t403, null, [v_ctx_428, [[J.sub(v_x_450, J.mul(J.mul(v_fwd_434, 8.0), v_s_433)), J.add(v_y_451, J.mul(5.0, v_s_433))], [J.sub(v_x_450, J.mul(J.mul(v_fwd_434, 2.0), v_s_433)), J.add(v_y_451, J.mul(1.0, v_s_433))]], J.mul(0.8, v_s_433), "rgba(255,255,255,.6)"])
		J.mc(v_ctx_428, "restore", [])
		var _t404 = env["dustPuff"]
		var _t405 = env["seg"]
		J.cl(_t404, null, [v_ctx_428, v_bx_447, v_by_448, J.cl(_t405, null, [v_e_449, 0.0, 0.5]), v_s_433, 4.0])

func _f43(this_, a: Array, env):
	var v_pl_454 = null; var v_hd_455 = null; var v_T1_456 = null; var v_T2_457 = null; var v_T3_458 = null; var v_T4_459 = null
	v_pl_454 = J.arg(a, 0)
	var _t406 = J.gp(v_pl_454, "hd")
	v_hd_455 = (_t406 if J.t(_t406) else 6.0)
	v_T1_456 = 0.85
	v_T2_457 = J.add(v_T1_456, v_hd_455)
	v_T3_458 = J.add(v_T2_457, 0.4)
	v_T4_459 = J.add(v_T3_458, 1.6)
	return {"T1": v_T1_456, "T2": v_T2_457, "T3": v_T3_458, "T4": v_T4_459}

func _f45(this_, a: Array, env):
	var v_lift_489 = null; var v_rot_490 = null; var v_P_491 = null; var v_cy_492 = null
	v_lift_489 = J.arg(a, 0)
	v_rot_490 = J.arg(a, 1)
	v_P_491 = J.arg(a, 2)
	var _t419 = J.gp(env["a"], "y")
	var _t418 = env["__p"]["floatY"]
	v_cy_492 = (J.sub(J.sub(_t419, J.cl(_t418, null, [env["a"]])), v_lift_489) - J.mul(env["H"], 0.5))
	J.mc(env["ctx"], "save", [])
	J.mc(env["ctx"], "translate", [J.gp(env["a"], "x"), v_cy_492])
	J.mc(env["ctx"], "rotate", [v_rot_490])
	J.mc(env["ctx"], "translate", [(-J.num(J.gp(env["a"], "x"))), (-J.num(v_cy_492))])
	var _t422 = env["ctx"]
	var _t423 = J.gp(env["a"], "x")
	var _t421 = J.gp(env["a"], "y")
	var _t420 = env["__p"]["floatY"]
	J.mc(J.G.get("MeshAnim"), "draw", [_t422, "tianhua", _t423, J.sub(J.sub(_t421, J.cl(_t420, null, [env["a"]])), v_lift_489), env["H"], v_P_491, J.gp(env["a"], "faceRight")])
	J.mc(env["ctx"], "restore", [])

func _f46(this_, a: Array, env):
	var v_y_493 = null; var v_ang_494 = null; var v_sy_495 = null
	v_y_493 = J.arg(a, 0)
	v_ang_494 = J.arg(a, 1)
	v_sy_495 = J.arg(a, 2)
	J.mc(env["ctx"], "save", [])
	J.mc(env["ctx"], "translate", [env["ax"], v_y_493])
	J.mc(env["ctx"], "rotate", [v_ang_494])
	J.mc(env["ctx"], "scale", [1.0, (v_sy_495 if J.t(v_sy_495) else 1.0)])
	if (not J.t(J.gp(env["a"], "faceRight"))):
		J.mc(env["ctx"], "scale", [(-1.0), 1.0])
	J.mc(env["ctx"], "drawImage", [env["hang"], J.mul((-0.72), env["hw"]), 0.0, env["hw"], env["hh"]])
	J.mc(env["ctx"], "restore", [])

func _f44(this_, a: Array, env):
	var v_o_464 = null; var v_at_465 = null; var v_t_466 = null; var v_s_468 = null; var v_fwd_469 = null; var v_pl_470 = null; var v_eh_471 = null; var v_T1_472 = null; var v_T2_473 = null; var v_T3_474 = null; var v_T4_475 = null; var v_ay_480 = null; var v_stand_481 = null; var v_hangImg_482 = null; var v_e_483 = null; var v_sq_484 = null; var v_k_485 = null; var v_P_486 = null; var v_hx_487 = null; var v_hy_488 = null; var v_cr_496 = null; var v_j_497 = null; var v_up_498 = null; var v_P_499 = null; var v_lift_500 = null; var v_rot_501 = null; var v_hx_502 = null; var v_hy_503 = null; var v_i_504 = null; var v_e_505 = null; var v_amp_506 = null; var v_sway_507 = null; var v_br_508 = null; var v_i_509 = null; var v_f_510 = null; var v_q_511 = null; var v_fall_512 = null; var v_lift_513 = null; var v_P_514 = null
	var _s120 = {"__p": env, "ctx": null, "a": null, "H": null, "hang": null, "hh": null, "hw": null, "ax": null}
	_s120["ctx"] = J.arg(a, 0)
	_s120["a"] = J.arg(a, 1)
	var _t407 = _s120["__p"]["ok"]
	if (not J.t(J.cl(_t407, null, ["tianhua_hang"]))):
		return false
	v_o_464 = J.gp(_s120["a"], "o")
	var _t408 = J.gp(v_o_464, "at")
	v_at_465 = (_t408 if J.t(_t408) else 0.0)
	var _t409 = J.gp(v_o_464, "t")
	v_t_466 = (_t409 if J.t(_t409) else 0.0)
	_s120["H"] = J.gp(_s120["a"], "H")
	v_s_468 = J.gp(_s120["a"], "s")
	v_fwd_469 = (1.0 if J.t(J.gp(_s120["a"], "faceRight")) else (-1.0))
	var _t410 = J.gp(v_o_464, "pl")
	v_pl_470 = (_t410 if J.t(_t410) else {})
	var _t411 = J.gp(v_pl_470, "eh")
	v_eh_471 = (_t411 if J.t(_t411) else J.mul(_s120["H"], 2.2))
	var _t412 = _s120["__p"]["hangTimes"]
	var _t413 = J.cl(_t412, null, [v_pl_470])
	var _t414 = J.gp(_t413, "T1")
	v_T1_472 = _t414
	var _t415 = J.gp(_t413, "T2")
	v_T2_473 = _t415
	var _t416 = J.gp(_t413, "T3")
	v_T3_474 = _t416
	var _t417 = J.gp(_t413, "T4")
	v_T4_475 = _t417
	_s120["hang"] = J.gp(J.G.get("SPR"), "tianhua_hang")
	_s120["hh"] = J.div(J.mul(_s120["H"], 645.0), 577.0)
	_s120["hw"] = J.div(J.mul(_s120["hh"], J.gp(_s120["hang"], "naturalWidth")), J.gp(_s120["hang"], "naturalHeight"))
	_s120["ax"] = J.gp(_s120["a"], "x")
	v_ay_480 = J.sub(J.gp(_s120["a"], "y"), v_eh_471)
	v_stand_481 = Callable(self, "_f45").bind(_s120)
	v_hangImg_482 = Callable(self, "_f46").bind(_s120)
	if J.cmp(v_at_465, v_T1_472, "<"):
		var _t424 = _s120["__p"]["eo"]
		var _t425 = _s120["__p"]["seg"]
		var _t427 = J.cl(_t424, null, [J.cl(_t425, null, [v_at_465, 0.0, 0.36])])
		var _t426 = _s120["__p"]["seg"]
		v_cr_496 = J.mul(_t427, J.sub(1.0, J.cl(_t426, null, [v_at_465, 0.4, 0.5])))
		var _t428 = _s120["__p"]["seg"]
		v_j_497 = J.cl(_t428, null, [v_at_465, 0.45, v_T1_472])
		var _t429 = _s120["__p"]["eo3"]
		v_up_498 = J.cl(_t429, null, [v_j_497])
		var _t430 = _s120["__p"]["add"]
		var _t431 = J.gp(J.G.get("MeshAnim"), "ANIM")
		v_P_499 = J.cl(_t430, null, [J.mc(_t431, "idle", [v_t_466]), {"body": J.mul(0.2, v_cr_496), "head": J.mul(0.12, v_cr_496), "sy": ((1.0 - J.mul(0.12, v_cr_496)) + ((0.16 * sin(J.num(J.mul(_s120["__p"]["PI"], v_j_497)))) * J.sub(1.0, v_j_497))), "sx": ((1.0 + J.mul(0.06, v_cr_496)) - (0.08 * sin(J.num(J.mul(_s120["__p"]["PI"], v_j_497))))), "armB": J.mul((sin(J.num(J.mul(v_at_465, 14.0))) * 0.08), v_cr_496), "hairL": ((-0.3) * sin(J.num(J.mul(_s120["__p"]["PI"], v_j_497)))), "hairR": ((-0.3) * sin(J.num(J.mul(_s120["__p"]["PI"], v_j_497))))}])
		v_lift_500 = J.mul(J.sub(v_eh_471, J.mul(_s120["H"], 0.55)), v_up_498)
		var _t434 = J.mul((-J.num(v_fwd_469)), _s120["__p"]["PI"])
		var _t432 = _s120["__p"]["eio"]
		var _t433 = _s120["__p"]["seg"]
		v_rot_501 = J.mul(_t434, J.cl(_t432, null, [J.cl(_t433, null, [v_at_465, 0.58, v_T1_472])]))
		var _t435 = _s120["__p"]["shadowAt"]
		J.cl(_t435, null, [_s120["ctx"], _s120["a"], v_lift_500, 1.0])
		J.cl(v_stand_481, null, [v_lift_500, v_rot_501, v_P_499])
		var _t436 = J.cmp(v_at_465, 0.45, ">")
		if (J.cmp(v_at_465, 0.7, "<") if _t436 else _t436):
			J.mc(_s120["ctx"], "save", [])
			var _t437 = _s120["ctx"]
			var _t438 = _s120["__p"]["seg"]
			var _t439 = J.mul(J.gp(_t437, "globalAlpha"), J.sub(1.0, J.cl(_t438, null, [v_at_465, 0.5, 0.7])))
			J.sp(_t437, "globalAlpha", _t439)
			v_i_504 = (-1.0)
			while true:
				if not J.cmp(v_i_504, 1.0, "<="): break
				var _t440 = _s120["__p"]["crayon"]
				J.cl(_t440, null, [_s120["ctx"], [[J.add(J.gp(_s120["a"], "x"), J.mul(J.mul(v_i_504, 6.0), v_s_468)), (J.sub(J.gp(_s120["a"], "y"), v_lift_500) + J.mul(4.0, v_s_468))], [J.add(J.gp(_s120["a"], "x"), J.mul(J.mul(v_i_504, 6.0), v_s_468)), (J.sub(J.gp(_s120["a"], "y"), v_lift_500) + J.mul(22.0, v_s_468))]], J.mul(0.8, v_s_468), "#e8dfd0"])
				v_i_504 = J.num(v_i_504) + 1.0
			J.mc(_s120["ctx"], "restore", [])
		var _t441 = _s120["__p"]["dustPuff"]
		var _t443 = _s120["ctx"]
		var _t444 = J.gp(_s120["a"], "x")
		var _t445 = J.gp(_s120["a"], "y")
		var _t442 = _s120["__p"]["seg"]
		J.cl(_t441, null, [_t443, _t444, _t445, J.cl(_t442, null, [v_at_465, 0.45, 0.9]), v_s_468, 2.0])
		var _t446 = _s120["__p"]["npt"]
		var _t447 = J.cl(_t446, null, [_s120["a"], 0.45, 0.0])
		var _t448 = J.gp(_t447, 0.0)
		v_hx_502 = _t448
		var _t449 = J.gp(_t447, 1.0)
		v_hy_503 = _t449
		var _t450 = _s120["__p"]["txt"]
		var _t452 = _s120["ctx"]
		var _t453 = J.add(v_hx_502, J.mul(J.mul(v_fwd_469, 9.0), v_s_468))
		var _t454 = J.sub(v_hy_503, J.mul(6.0, v_s_468))
		var _t455 = (J.mul(12.0, v_s_468) * 1.3)
		var _t451 = _s120["__p"]["env"]
		J.cl(_t450, null, [_t452, _t453, _t454, "哎喲", _t455, "#ffd2d2", J.cl(_t451, null, [v_at_465, 0.05, 0.15, 0.4, 0.5]), 0.3])
		return null
	if J.cmp(v_at_465, v_T2_473, "<"):
		v_e_505 = J.sub(v_at_465, v_T1_472)
		v_amp_506 = ((22.0 * exp(J.num(((-J.num(v_e_505)) * 1.7)))) * cos(J.num(J.mul(v_e_505, 4.6))))
		v_sway_507 = (sin(J.num(J.mul(v_t_466, 1.25))) * 2.2)
		v_br_508 = (1.0 + (sin(J.num(J.mul(v_t_466, 1.6))) * 0.012))
		J.mc(_s120["ctx"], "save", [])
		var _t456 = _s120["ctx"]
		var _t457 = J.mul(J.gp(_t456, "globalAlpha"), 0.35)
		J.sp(_t456, "globalAlpha", _t457)
		J.mc(_s120["a"], "shadow", [J.gp(_s120["a"], "x"), 0.5])
		J.mc(_s120["ctx"], "restore", [])
		J.cl(v_hangImg_482, null, [v_ay_480, J.mul(J.mul(J.add(v_amp_506, v_sway_507), _s120["__p"]["D"]), v_fwd_469), v_br_508])
		var _t458 = _s120["__p"]["dustPuff"]
		var _t460 = _s120["ctx"]
		var _t461 = _s120["ax"]
		var _t462 = J.add(v_ay_480, J.mul(2.0, v_s_468))
		var _t459 = _s120["__p"]["seg"]
		J.cl(_t458, null, [_t460, _t461, _t462, J.cl(_t459, null, [v_e_505, 0.0, 0.7]), v_s_468, 9.0])
		v_i_509 = 0.0
		while true:
			if not J.cmp(v_i_509, 4.0, "<"): break
			v_f_510 = J.sub(v_e_505, J.mul(v_i_509, 0.12))
			var _t463 = J.cmp(v_f_510, 0.0, "<")
			if (_t463 if _t463 else J.cmp(v_f_510, 0.8, ">")):
				v_i_509 = J.num(v_i_509) + 1.0
				continue
			J.mc(_s120["ctx"], "save", [])
			var _t464 = _s120["ctx"]
			var _t465 = J.mul(J.gp(_t464, "globalAlpha"), (1.0 - J.div(v_f_510, 0.8)))
			J.sp(_t464, "globalAlpha", _t465)
			var _t466 = _s120["ctx"]
			J.sp(_t466, "fillStyle", "#bfb29c")
			J.mc(_s120["ctx"], "beginPath", [])
			var _t468 = _s120["ax"]
			var _t467 = _s120["__p"]["hash"]
			J.mc(_s120["ctx"], "arc", [J.add(_t468, J.mul((J.sub(J.cl(_t467, null, [v_i_509]), 0.5) * 14.0), v_s_468)), J.add(J.add(v_ay_480, J.mul(2.0, v_s_468)), J.mul(J.mul(J.mul(60.0, v_s_468), v_f_510), v_f_510)), J.mul(0.8, v_s_468), 0.0, _s120["__p"]["TAU"]])
			J.mc(_s120["ctx"], "fill", [])
			J.mc(_s120["ctx"], "restore", [])
			v_i_509 = J.num(v_i_509) + 1.0
		var _t472 = null
		if J.cmp(v_e_505, 1.8, ">"):
			var _t469 = _s120["__p"]["seg"]
			var _t471 = J.cl(_t469, null, [v_e_505, 1.8, 2.4])
			var _t470 = _s120["__p"]["seg"]
			_t472 = J.mul(_t471, J.sub(1.0, J.cl(_t470, null, [v_at_465, J.sub(v_T2_473, 0.5), v_T2_473])))
		else:
			_t472 = 0.0
		J.sp(v_o_464, "_z", _t472)
		var _t473 = [J.sub(_s120["ax"], (J.mul(v_fwd_469, _s120["hw"]) * 0.35)), J.add(v_ay_480, J.mul(_s120["hh"], 0.75))]
		J.sp(v_o_464, "_zpos", _t473)
		return null
	if J.cmp(v_at_465, v_T3_474, "<"):
		var _t474 = _s120["__p"]["seg"]
		v_q_511 = J.cl(_t474, null, [v_at_465, v_T2_473, v_T3_474])
		var _t475 = _s120["__p"]["ei"]
		v_fall_512 = J.cl(_t475, null, [v_q_511])
		v_lift_513 = (J.sub(v_eh_471, J.mul(_s120["H"], 0.55)) * J.sub(1.0, v_fall_512))
		var _t476 = _s120["__p"]["add"]
		var _t477 = J.gp(J.G.get("MeshAnim"), "ANIM")
		v_P_514 = J.cl(_t476, null, [J.mc(_t477, "idle", [v_t_466]), {"hairL": 0.3, "hairR": 0.3, "sy": 1.05, "sx": 0.96}])
		var _t478 = _s120["__p"]["shadowAt"]
		J.cl(_t478, null, [_s120["ctx"], _s120["a"], v_lift_513, 1.0])
		if J.cmp(v_q_511, 0.18, "<"):
			J.cl(v_hangImg_482, null, [J.add(v_ay_480, J.mul(J.mul(30.0, v_s_468), v_q_511)), 0.0, 1.0])
		else:
			var _t481 = J.mul((-J.num(v_fwd_469)), _s120["__p"]["PI"])
			var _t479 = _s120["__p"]["eio"]
			var _t480 = _s120["__p"]["seg"]
			J.cl(v_stand_481, null, [v_lift_513, (_t481 * J.sub(1.0, J.cl(_t479, null, [J.cl(_t480, null, [v_q_511, 0.18, 1.0])]))), v_P_514])
		return null
	v_e_483 = J.sub(v_at_465, v_T3_474)
	var _t483 = _s120["__p"]["PI"]
	var _t482 = _s120["__p"]["seg"]
	v_sq_484 = (sin(J.num(J.mul(_t483, J.cl(_t482, null, [v_e_483, 0.0, 0.3])))) * (1.0 if J.cmp(v_e_483, 0.3, "<") else 0.0))
	var _t484 = _s120["__p"]["env"]
	v_k_485 = J.cl(_t484, null, [v_e_483, 0.15, 0.4, (J.sub(v_T4_475, v_T3_474) - 0.4), J.sub(v_T4_475, v_T3_474)])
	var _t485 = _s120["__p"]["add"]
	var _t486 = J.gp(J.G.get("MeshAnim"), "ANIM")
	v_P_486 = J.cl(_t485, null, [J.mc(_t486, "idle", [v_t_466]), {"sy": (1.0 - J.mul(0.16, v_sq_484)), "sx": (1.0 + J.mul(0.1, v_sq_484)), "body": (J.mul(0.2, v_sq_484) + J.mul(0.13, v_k_485)), "head": (J.mul(0.12, v_sq_484) + J.mul(0.06, v_k_485)), "armB": J.mul((sin(J.num(J.mul(v_e_483, 11.0))) * 0.11), v_k_485)}])
	var _t487 = _s120["__p"]["shadowAt"]
	J.cl(_t487, null, [_s120["ctx"], _s120["a"], 0.0, 1.0])
	var _t490 = _s120["ctx"]
	var _t491 = J.gp(_s120["a"], "x")
	var _t489 = J.gp(_s120["a"], "y")
	var _t488 = _s120["__p"]["floatY"]
	J.mc(J.G.get("MeshAnim"), "draw", [_t490, "tianhua", _t491, J.sub(_t489, J.cl(_t488, null, [_s120["a"]])), _s120["H"], v_P_486, J.gp(_s120["a"], "faceRight")])
	var _t492 = _s120["__p"]["dustPuff"]
	var _t494 = _s120["ctx"]
	var _t495 = J.gp(_s120["a"], "x")
	var _t496 = J.gp(_s120["a"], "y")
	var _t493 = _s120["__p"]["seg"]
	J.cl(_t492, null, [_t494, _t495, _t496, J.cl(_t493, null, [v_e_483, 0.0, 0.5]), v_s_468, 5.0])
	var _t497 = _s120["__p"]["npt"]
	var _t498 = J.cl(_t497, null, [_s120["a"], 0.45, 0.0])
	var _t499 = J.gp(_t498, 0.0)
	v_hx_487 = _t499
	var _t500 = J.gp(_t498, 1.0)
	v_hy_488 = _t500
	var _t501 = _s120["__p"]["txt"]
	var _t503 = _s120["ctx"]
	var _t504 = J.add(v_hx_487, J.mul(J.mul(v_fwd_469, 9.0), v_s_468))
	var _t505 = J.sub(v_hy_488, J.mul(8.0, v_s_468))
	var _t506 = (J.mul(12.0, v_s_468) * 1.3)
	var _t502 = _s120["__p"]["env"]
	J.cl(_t501, null, [_t503, _t504, _t505, "哎喲", _t506, "#ffd2d2", J.cl(_t502, null, [v_e_483, 0.1, 0.25, 1.1, 1.4]), (sin(J.num(J.mul(v_e_483, 9.0))) * 0.5)])

func _f48(this_, a: Array, env):
	var v_ctx_518 = null; var v_ag_519 = null; var v_t_520 = null; var v_k_521 = null; var v_s_522 = null; var v_H_523 = null; var v_at_524 = null; var v_fwd_525 = null; var v_act_526 = null; var v_pl_527 = null; var v_dx_528 = null; var v_dy_529 = null; var v_rot_530 = null; var v_sx_531 = null; var v_sy_532 = null; var v_walk_533 = null; var v_nr_534 = null; var v_d_535 = null; var v_kk_536 = null; var v_d_537 = null; var v_kk_538 = null; var v_j_539 = null; var v_kk_540 = null; var v_c_541 = null; var v_q_542 = null; var v_c_543 = null
	v_ctx_518 = J.arg(a, 0)
	v_ag_519 = J.arg(a, 1)
	v_t_520 = J.arg(a, 2)
	v_k_521 = J.gp(v_ag_519, "k")
	v_s_522 = env["SC"]
	var _t507 = J.gp(env["CH"], v_k_521)
	v_H_523 = J.mul((_t507 if J.t(_t507) else 50.0), v_s_522)
	v_at_524 = J.gp(v_ag_519, "at")
	v_fwd_525 = (1.0 if J.t(J.gp(v_ag_519, "face")) else (-1.0))
	v_act_526 = J.gp(v_ag_519, "act")
	var _t508 = J.gp(v_ag_519, "pl")
	v_pl_527 = (_t508 if J.t(_t508) else {})
	v_dx_528 = 0.0
	v_dy_529 = 0.0
	v_rot_530 = 0.0
	v_sx_531 = 1.0
	v_sy_532 = 1.0
	v_walk_533 = J.cmp(J.gp(v_ag_519, "w"), 0.3, ">")
	var _t509 = -1
	var _t510 = false
	if _t509 == -1 and J.seq(v_act_526, "plaza_talk"): _t509 = 0
	if _t509 == -1 and J.seq(v_act_526, "plaza_argue"): _t509 = 1
	if _t509 == -1 and J.seq(v_act_526, "plaza_wave"): _t509 = 2
	if _t509 == -1 and J.seq(v_act_526, "plaza_bow"): _t509 = 3
	if _t509 == -1 and J.seq(v_act_526, "plaza_doze"): _t509 = 4
	if _t509 == -1 and J.seq(v_act_526, "plaza_look"): _t509 = 5
	if _t509 == -1 and J.seq(v_act_526, "plaza_startle"): _t509 = 6
	if _t509 == -1 and J.seq(v_act_526, "plaza_eek"): _t509 = 7
	if _t509 == -1 and J.seq(v_act_526, "plaza_dizzy"): _t509 = 8
	if _t509 == -1 and J.seq(v_act_526, "plaza_stretch"): _t509 = 9
	if _t509 == -1 and J.seq(v_act_526, "plaza_hop"): _t509 = 10
	if _t509 == -1 and J.seq(v_act_526, "plaza_coins"): _t509 = 11
	if _t509 == -1 and J.seq(v_act_526, "plaza_spin"): _t509 = 12
	while true:
		if _t509 <= 0 and _t509 >= 0:
			pass
		if _t509 <= 1 and _t509 >= 0:
			if J.t(J.gp(v_pl_527, "spk")):
				var _t511 = J.mul(((-absf(J.num(sin(J.num(J.mul(v_at_524, 8.0)))))) * 1.6), v_s_522)
				v_dy_529 = _t511
				var _t512 = (sin(J.num(J.mul(v_at_524, 4.2))) * 0.05)
				v_rot_530 = _t512
			else:
				var _t514 = env["PI"]
				var _t513 = env["seg"]
				var _t515 = J.mul((0.05 * sin(J.num(J.mul(_t514, J.cl(_t513, null, [J.mod(v_at_524, 1.5), 0.2, 0.75]))))), v_fwd_525)
				v_rot_530 = _t515
			break
		if _t509 <= 2 and _t509 >= 0:
			var _t517 = (sin(J.num(J.mul(v_at_524, 9.0))) * 0.07)
			var _t516 = env["env"]
			var _t518 = J.mul(_t517, J.cl(_t516, null, [v_at_524, 0.0, 0.2, 1.1, 1.4]))
			v_rot_530 = _t518
			var _t519 = J.mul(((-absf(J.num(sin(J.num(J.mul(v_at_524, 9.0)))))) * 1.2), v_s_522)
			v_dy_529 = _t519
			break
		if _t509 <= 3 and _t509 >= 0:
			var _t520 = J.gp(v_pl_527, "d")
			v_d_535 = (_t520 if J.t(_t520) else 1.2)
			var _t521 = env["env"]
			v_kk_536 = J.cl(_t521, null, [v_at_524, 0.0, J.mul(v_d_535, 0.3), J.mul(v_d_535, 0.62), v_d_535])
			var _t522 = J.mul(J.mul(0.22, v_kk_536), v_fwd_525)
			v_rot_530 = _t522
			var _t523 = (1.0 - J.mul(0.04, v_kk_536))
			v_sy_532 = _t523
			break
		if _t509 <= 4 and _t509 >= 0:
			var _t524 = J.gp(v_pl_527, "d")
			v_d_537 = (_t524 if J.t(_t524) else 8.0)
			var _t525 = env["env"]
			v_kk_538 = J.cl(_t525, null, [v_at_524, 0.0, 1.4, J.sub(v_d_537, 0.7), v_d_537])
			var _t526 = (J.mul(J.mul(0.1, v_kk_538), v_fwd_525) + (sin(J.num(J.mul(v_t_520, 1.1))) * 0.015))
			v_rot_530 = _t526
			var _t527 = (1.0 + J.mul((sin(J.num(J.mul(v_t_520, 1.1))) * 0.015), v_kk_538))
			v_sy_532 = _t527
			J.sp(v_ag_519, "_z", v_kk_538)
			break
		if _t509 <= 5 and _t509 >= 0:
			var _t529 = J.mul((-0.05), v_fwd_525)
			var _t528 = env["env"]
			var _t530 = J.mul(_t529, J.cl(_t528, null, [v_at_524, 0.0, 0.3, 1.6, 2.0]))
			v_rot_530 = _t530
			break
		if _t509 <= 6 and _t509 >= 0:
			pass
		if _t509 <= 7 and _t509 >= 0:
			var _t532 = env["PI"]
			var _t531 = env["seg"]
			var _t534 = sin(J.num(J.mul(_t532, J.cl(_t531, null, [v_at_524, 0.06, 0.32]))))
			var _t533 = J.cmp(v_at_524, 0.06, ">")
			v_j_539 = (_t534 * (1.0 if (J.cmp(v_at_524, 0.32, "<") if _t533 else _t533) else 0.0))
			var _t535 = J.mul(((-J.num(v_j_539)) * 7.0), v_s_522)
			v_dy_529 = _t535
			var _t536 = (1.0 + J.mul(0.08, v_j_539))
			v_sy_532 = _t536
			var _t539 = null
			if J.cmp(v_at_524, 0.3, ">"):
				var _t538 = (sin(J.num(J.mul(v_at_524, 45.0))) * 0.03)
				var _t537 = env["seg"]
				_t539 = (_t538 * J.sub(1.0, J.cl(_t537, null, [v_at_524, 0.3, 1.2])))
			else:
				_t539 = 0.0
			v_rot_530 = _t539
			break
		if _t509 <= 8 and _t509 >= 0:
			var _t541 = (sin(J.num(J.mul(v_at_524, 6.0))) * 0.09)
			var _t540 = env["seg"]
			var _t542 = (_t541 * J.sub(1.0, J.cl(_t540, null, [v_at_524, 1.6, 2.2])))
			v_rot_530 = _t542
			var _t543 = env["seg"]
			var _t544 = J.sub(1.0, J.cl(_t543, null, [v_at_524, 1.6, 2.2]))
			J.sp(v_ag_519, "_stars", _t544)
			break
		if _t509 <= 9 and _t509 >= 0:
			var _t545 = env["env"]
			v_kk_540 = J.cl(_t545, null, [v_at_524, 0.0, 0.6, 1.4, 2.0])
			var _t546 = (1.0 + J.mul(0.07, v_kk_540))
			v_sy_532 = _t546
			var _t547 = (1.0 - J.mul(0.035, v_kk_540))
			v_sx_531 = _t547
			var _t548 = J.mul(J.mul((-0.05), v_kk_540), v_fwd_525)
			v_rot_530 = _t548
			break
		if _t509 <= 10 and _t509 >= 0:
			v_walk_533 = true
			break
		if _t509 <= 11 and _t509 >= 0:
			v_c_541 = J.mod(v_at_524, 1.1)
			var _t550 = env["PI"]
			var _t549 = env["seg"]
			var _t555 = J.mul((0.07 + (0.03 * sin(J.num(J.mul(_t550, J.cl(_t549, null, [v_c_541, 0.0, 0.3])))))), v_fwd_525)
			var _t551 = env["env"]
			var _t552 = J.gp(v_pl_527, "d")
			var _t554 = J.sub((_t552 if J.t(_t552) else 5.0), 0.3)
			var _t553 = J.gp(v_pl_527, "d")
			var _t556 = J.mul(_t555, J.cl(_t551, null, [v_at_524, 0.0, 0.3, _t554, (_t553 if J.t(_t553) else 5.0)]))
			v_rot_530 = _t556
			var _t558 = env["PI"]
			var _t557 = env["seg"]
			var _t559 = J.mul((sin(J.num(J.mul(_t558, J.cl(_t557, null, [v_c_541, 0.0, 0.3])))) * 0.8), v_s_522)
			v_dy_529 = _t559
			break
		if _t509 <= 12 and _t509 >= 0:
			var _t560 = env["seg"]
			v_q_542 = J.cl(_t560, null, [v_at_524, 0.25, 1.35])
			v_c_543 = cos(J.num((J.mul(v_q_542, env["TAU"]) * 2.0)))
			var _t561 = (signf(J.num((v_c_543 if J.t(v_c_543) else 1.0))) * J.max_([0.07, absf(J.num(v_c_543))]))
			v_sx_531 = _t561
			var _t562 = J.mul(((-sin(J.num(J.mul(env["PI"], v_q_542)))) * 8.0), v_s_522)
			v_dy_529 = _t562
			break
		break
	J.mc(v_ctx_518, "save", [])
	J.mc(v_ctx_518, "translate", [J.gp(v_ag_519, "x"), J.gp(v_ag_519, "y")])
	J.mc(v_ctx_518, "rotate", [v_rot_530])
	J.mc(v_ctx_518, "scale", [v_sx_531, v_sy_532])
	J.mc(v_ctx_518, "translate", [(-J.num(J.gp(v_ag_519, "x"))), (-J.num(J.gp(v_ag_519, "y")))])
	v_nr_534 = (not (not J.t(J.gp(J.gp(J.G.get("MeshAnim"), "NATIVE_R"), v_k_521))))
	J.mc(J.G.get("ART"), "drawChar", [v_ctx_518, v_k_521, J.add(J.gp(v_ag_519, "x"), v_dx_528), J.add(J.gp(v_ag_519, "y"), v_dy_529), v_s_522, {"t": J.add(v_t_520, J.gp(v_ag_519, "seed")), "walk": v_walk_533, "tamed": true, "untied": true, "flip": J.seq(J.gp(v_ag_519, "face"), v_nr_534), "key": J.add("plz", J.gp(v_ag_519, "id"))}])
	J.mc(v_ctx_518, "restore", [])
	if J.seq(v_act_526, "plaza_coins"):
		var _t563 = env["coinsFx"]
		J.cl(_t563, null, [v_ctx_518, v_ag_519, v_at_524, v_s_522, v_H_523, v_fwd_525, v_pl_527])

func _f49(this_, a: Array, env):
	var v_ctx_546 = null; var v_ag_547 = null; var v_at_548 = null; var v_s_549 = null; var v_H_550 = null; var v_fwd_551 = null; var v_pl_552 = null; var v_px_553 = null; var v_py_554 = null; var v_n_555 = null; var v_c_556 = null; var v_lost_557 = null; var v_e_558 = null; var v_x_559 = null; var v_y_560 = null; var v_sp_561 = null
	v_ctx_546 = J.arg(a, 0)
	v_ag_547 = J.arg(a, 1)
	v_at_548 = J.arg(a, 2)
	v_s_549 = J.arg(a, 3)
	v_H_550 = J.arg(a, 4)
	v_fwd_551 = J.arg(a, 5)
	v_pl_552 = J.arg(a, 6)
	v_px_553 = J.add(J.gp(v_ag_547, "x"), J.div((J.mul(J.mul(v_fwd_551, 0.27), v_H_550) * 337.0), 586.0))
	v_py_554 = J.sub(J.gp(v_ag_547, "y"), J.mul(0.58, v_H_550))
	v_n_555 = floor(J.num(J.div(v_at_548, 1.1)))
	v_c_556 = J.mod(v_at_548, 1.1)
	v_lost_557 = J.seq(J.mod(v_n_555, 5.0), 4.0)
	var _t565 = (not J.t(v_lost_557))
	if J.t(_t565):
		var _t564 = J.gp(v_pl_552, "d")
		_t565 = J.cmp(v_at_548, J.sub((_t564 if J.t(_t564) else 5.0), 0.4), "<")
	if _t565:
		var _t566 = env["seg"]
		v_e_558 = J.cl(_t566, null, [v_c_556, 0.05, 0.75])
		v_x_559 = J.add(v_px_553, J.mul((J.mul(v_fwd_551, sin(J.num(J.mul(env["PI"], v_e_558)))) * 3.0), v_s_549))
		v_y_560 = J.sub(v_py_554, J.mul((sin(J.num(J.mul(env["PI"], v_e_558))) * 15.0), v_s_549))
		var _t567 = J.cmp(v_c_556, 0.05, ">")
		if (J.cmp(v_c_556, 0.75, "<") if _t567 else _t567):
			v_sp_561 = cos(J.num((J.mul(v_e_558, env["TAU"]) * 2.0)))
			J.mc(v_ctx_546, "save", [])
			J.mc(v_ctx_546, "translate", [v_x_559, v_y_560])
			J.mc(v_ctx_546, "scale", [J.max_([0.15, absf(J.num(v_sp_561))]), 1.0])
			J.mc(v_ctx_546, "beginPath", [])
			J.mc(v_ctx_546, "arc", [0.0, 0.0, J.mul(2.6, v_s_549), 0.0, env["TAU"]])
			var _t568 = ("#f2c94c" if J.cmp(v_sp_561, 0.0, ">") else "#d9a62e")
			J.sp(v_ctx_546, "fillStyle", _t568)
			J.mc(v_ctx_546, "fill", [])
			var _t569 = J.mul(0.7, v_s_549)
			J.sp(v_ctx_546, "lineWidth", _t569)
			J.sp(v_ctx_546, "strokeStyle", "#6a4a14")
			J.mc(v_ctx_546, "stroke", [])
			J.sp(v_ctx_546, "fillStyle", "#6a4a14")
			J.mc(v_ctx_546, "fillRect", [J.mul((-0.7), v_s_549), J.mul((-0.7), v_s_549), J.mul(1.4, v_s_549), J.mul(1.4, v_s_549)])
			J.mc(v_ctx_546, "restore", [])
			if J.cmp(v_c_556, 0.5, ">"):
				J.mc(v_ctx_546, "save", [])
				var _t570 = env["seg"]
				var _t571 = J.mul(J.gp(v_ctx_546, "globalAlpha"), J.sub(1.0, J.cl(_t570, null, [v_c_556, 0.5, 0.75])))
				J.sp(v_ctx_546, "globalAlpha", _t571)
				var _t572 = env["star"]
				J.cl(_t572, null, [v_ctx_546, J.add(v_x_559, J.mul(3.0, v_s_549)), J.sub(v_y_560, J.mul(2.0, v_s_549)), J.mul(1.6, v_s_549), J.mul(v_c_556, 5.0)])
				J.mc(v_ctx_546, "restore", [])
		var _t573 = env["txt"]
		var _t576 = J.add(v_px_553, J.mul(J.mul(v_fwd_551, 12.0), v_s_549))
		var _t575 = J.sub(v_py_554, J.mul(14.0, v_s_549))
		var _t574 = env["seg"]
		var _t578 = (_t575 - J.mul(J.mul(J.cl(_t574, null, [v_c_556, 0.4, 1.1]), 6.0), v_s_549))
		var _t579 = J.F_String([(J.mod(v_n_555, 5.0) + 1.0)])
		var _t580 = (J.mul(10.0, v_s_549) * 1.4)
		var _t577 = env["env"]
		J.cl(_t573, null, [v_ctx_546, _t576, _t578, _t579, _t580, "#ffe9a8", J.cl(_t577, null, [v_c_556, 0.4, 0.5, 0.9, 1.1]), 0.0])
	else:
		if J.t(v_lost_557):
			var _t581 = env["bubble"]
			var _t583 = J.add(J.gp(v_ag_547, "x"), J.mul(J.mul(v_fwd_551, 6.0), v_s_549))
			var _t584 = (J.sub(J.gp(v_ag_547, "y"), v_H_550) - J.mul(10.0, v_s_549))
			var _t582 = env["env"]
			J.cl(_t581, null, [v_ctx_546, _t583, _t584, "?", v_s_549, J.cl(_t582, null, [v_c_556, 0.0, 0.15, 0.9, 1.1])])

func _f50(this_, a: Array, env):
	var v_aA_564 = null; var v_aB_565 = null; var v_Z_566 = null
	v_aA_564 = (J.sub(J.gp(env["ZA"], 1.0), J.gp(env["ZA"], 0.0)) * J.sub(J.gp(env["ZA"], 3.0), J.gp(env["ZA"], 2.0)))
	v_aB_565 = (J.sub(J.gp(env["ZB"], 1.0), J.gp(env["ZB"], 0.0)) * J.sub(J.gp(env["ZB"], 3.0), J.gp(env["ZB"], 2.0)))
	v_Z_566 = (env["ZA"] if J.cmp(J.mul(J.cl(env["R"], null, []), J.add(v_aA_564, v_aB_565)), v_aA_564, "<") else env["ZB"])
	return [J.add(J.gp(v_Z_566, 0.0), J.mul(J.cl(env["R"], null, []), J.sub(J.gp(v_Z_566, 1.0), J.gp(v_Z_566, 0.0)))), J.add(J.gp(v_Z_566, 2.0), J.mul(J.cl(env["R"], null, []), J.sub(J.gp(v_Z_566, 3.0), J.gp(v_Z_566, 2.0))))]

func _f51(this_, a: Array, env):
	var v_x_569 = null; var v_y_570 = null; var v_pa_571 = null; var v_pb_572 = null
	v_x_569 = J.arg(a, 0)
	v_y_570 = J.arg(a, 1)
	var _t585 = env["cl"]
	var _t587 = J.cl(_t585, null, [v_x_569, J.gp(env["ZA"], 0.0), J.gp(env["ZA"], 1.0)])
	var _t586 = env["cl"]
	v_pa_571 = [_t587, J.cl(_t586, null, [v_y_570, J.gp(env["ZA"], 2.0), J.gp(env["ZA"], 3.0)])]
	var _t588 = env["cl"]
	var _t590 = J.cl(_t588, null, [v_x_569, J.gp(env["ZB"], 0.0), J.gp(env["ZB"], 1.0)])
	var _t589 = env["cl"]
	v_pb_572 = [_t590, J.cl(_t589, null, [v_y_570, J.gp(env["ZB"], 2.0), J.gp(env["ZB"], 3.0)])]
	return (v_pa_571 if (J.hypot_([J.sub(J.gp(v_pa_571, 0.0), v_x_569), J.sub(J.gp(v_pa_571, 1.0), v_y_570)]) <= J.hypot_([J.sub(J.gp(v_pb_572, 0.0), v_x_569), J.sub(J.gp(v_pb_572, 1.0), v_y_570)])) else v_pb_572)

func _f52(this_, a: Array, env):
	var v_a_575 = null; var v_inA_576 = null; var v_inB_577 = null; var v_p_578 = null
	v_a_575 = J.arg(a, 0)
	var _t591 = J.cmp(J.gp(v_a_575, "x"), J.sub(J.gp(env["ZA"], 0.0), 4.0), ">")
	var _t592 = (J.cmp(J.gp(v_a_575, "x"), J.add(J.gp(env["ZA"], 1.0), 4.0), "<") if _t591 else _t591)
	v_inA_576 = (J.cmp(J.gp(v_a_575, "y"), J.sub(J.gp(env["ZA"], 2.0), 4.0), ">") if _t592 else _t592)
	var _t593 = J.cmp(J.gp(v_a_575, "y"), J.sub(J.gp(env["ZB"], 2.0), 4.0), ">")
	var _t594 = (J.cmp(J.gp(v_a_575, "x"), J.sub(J.gp(env["ZB"], 0.0), 4.0), ">") if _t593 else _t593)
	v_inB_577 = (J.cmp(J.gp(v_a_575, "x"), J.add(J.gp(env["ZB"], 1.0), 4.0), "<") if _t594 else _t594)
	var _t595 = (not J.t(v_inA_576))
	if ((not J.t(v_inB_577)) if _t595 else _t595):
		return null
	var _t596 = env["nearZ"]
	v_p_578 = J.cl(_t596, null, [J.gp(v_a_575, "x"), J.gp(v_a_575, "y")])
	var _t597 = J.gp(v_p_578, 0.0)
	J.sp(v_a_575, "x", _t597)
	var _t598 = J.gp(v_p_578, 1.0)
	J.sp(v_a_575, "y", _t598)

func _f54(this_, a: Array, env):
	var v_ax_582 = null; var v_ay_583 = null; var v_bx_584 = null; var v_by_585 = null; var v_sa_586 = null; var v_q_587 = null; var v_mx_588 = null
	v_ax_582 = J.arg(a, 0)
	v_ay_583 = J.arg(a, 1)
	v_bx_584 = J.arg(a, 2)
	v_by_585 = J.arg(a, 3)
	var _t599 = env["nearZ"]
	v_sa_586 = J.cl(_t599, null, [v_ax_582, v_ay_583])
	if (J.hypot_([J.sub(J.gp(v_sa_586, 0.0), v_ax_582), J.sub(J.gp(v_sa_586, 1.0), v_ay_583)]) > 3.0):
		var _t600 = env["nearZ"]
		v_q_587 = J.cl(_t600, null, [v_ax_582, J.add(v_ay_583, 40.0)])
		var _t601 = [[J.gp(v_q_587, 0.0), J.gp(v_q_587, 1.0)]]
		var _t602 = env["route"]
		return J.mc(_t601, "concat", [J.cl(_t602, null, [J.gp(v_q_587, 0.0), J.gp(v_q_587, 1.0), v_bx_584, v_by_585])])
	var _t604 = J.cmp(v_ay_583, J.sub(J.gp(env["ZB"], 2.0), 2.0), "<")
	if J.t(_t604):
		var _t603 = env["sideX"]
		_t604 = J.cl(_t603, null, [v_bx_584])
	var _t607 = _t604
	if not J.t(_t607):
		var _t606 = J.cmp(v_by_585, J.sub(J.gp(env["ZB"], 2.0), 2.0), "<")
		if J.t(_t606):
			var _t605 = env["sideX"]
			_t606 = J.cl(_t605, null, [v_ax_582])
		_t607 = _t606
	if J.t(_t607):
		var _t608 = env["cl"]
		v_mx_588 = J.cl(_t608, null, [(v_ax_582 if J.cmp(v_ay_583, J.sub(J.gp(env["ZB"], 2.0), 2.0), "<") else v_bx_584), J.add(J.gp(env["ZA"], 0.0), 6.0), J.sub(J.gp(env["ZA"], 1.0), 6.0)])
		return [[v_mx_588, (652.0 + J.mul(J.cl(env["R"], null, []), 14.0))], [v_bx_584, v_by_585]]
	return [[v_bx_584, v_by_585]]

func _f55(this_, a: Array, env):
	var v_W_591 = null; var v_me_592 = null; var v_near_593 = null; var v_best_594 = null; var v_bs_595 = null; var v_i_596 = null; var v_p_597 = null; var v_sc_598 = null; var v_o_599 = null; var v_d1_600 = null; var v_d2_601 = null; var v_d_602 = null
	v_W_591 = J.arg(a, 0)
	v_me_592 = J.arg(a, 1)
	v_near_593 = J.arg(a, 2)
	v_best_594 = null
	v_bs_595 = (-1000000000.0)
	v_i_596 = 0.0
	while true:
		if not J.cmp(v_i_596, 9.0, "<"): break
		v_p_597 = J.cl(env["zonePt"], null, [])
		v_sc_598 = 0.0
		for _t609 in J.iter(J.gp(v_W_591, "list")):
			v_o_599 = _t609
			if J.seq(v_o_599, v_me_592):
				continue
			v_d1_600 = J.hypot_([J.sub(J.gp(v_o_599, "x"), J.gp(v_p_597, 0.0)), J.sub(J.gp(v_o_599, "y"), J.gp(v_p_597, 1.0))])
			v_d2_601 = (J.hypot_([J.sub(J.gp(v_o_599, "tx"), J.gp(v_p_597, 0.0)), J.sub(J.gp(v_o_599, "ty"), J.gp(v_p_597, 1.0))]) if (not J.leq(J.gp(v_o_599, "tx"), null)) else 99.0)
			var _t610 = J.add(v_sc_598, ((-J.max_([0.0, (26.0 - J.min_([v_d1_600, v_d2_601]))])) * 3.0))
			v_sc_598 = _t610
		if J.t(v_me_592):
			v_d_602 = J.hypot_([J.sub(J.gp(v_me_592, "x"), J.gp(v_p_597, 0.0)), J.sub(J.gp(v_me_592, "y"), J.gp(v_p_597, 1.0))])
			var _t611 = J.add(v_sc_598, (((-absf(J.num(J.sub(v_d_602, v_near_593)))) * 0.5) if J.t(v_near_593) else (J.min_([v_d_602, 90.0]) * 0.15)))
			v_sc_598 = _t611
		if J.cmp(v_sc_598, v_bs_595, ">"):
			v_bs_595 = v_sc_598
			v_best_594 = v_p_597
		v_i_596 = J.num(v_i_596) + 1.0
	return v_best_594

func _f56(this_, a: Array, env):
	var v_g_605 = null; var v_i_606 = null; var v_W_607 = null; var v_p_608 = null; var v_ag_609 = null
	v_g_605 = J.arg(a, 0)
	v_i_606 = J.arg(a, 1)
	v_W_607 = J.arg(a, 2)
	var _t612 = env["freePt"]
	v_p_608 = J.cl(_t612, null, [v_W_607, null])
	var _t614 = J.gp(v_g_605, "id")
	var _t615 = J.gp(v_g_605, "k")
	var _t616 = J.gp(v_p_608, 0.0)
	var _t617 = J.gp(v_p_608, 1.0)
	var _t618 = J.cmp(J.cl(env["R"], null, []), 0.5, "<")
	var _t619 = J.mul(J.cl(env["R"], null, []), 9.0)
	var _t620 = (-1.0)
	var _t621 = J.mul(J.cl(env["R"], null, []), 50.0)
	var _t613 = J.gp(env["VMAX"], J.gp(v_g_605, "k"))
	v_ag_609 = {"id": _t614, "g": v_g_605, "k": _t615, "x": _t616, "y": _t617, "face": _t618, "want": null, "turnT": 9.0, "sp": 0.0, "w": 0.0, "wph": _t619, "hp": _t620, "seed": _t621, "vmax": (_t613 if J.t(_t613) else 15.0), "q": [], "cur": null, "st": "idle", "at": 0.0, "dur": ((0.3 + J.mul(J.cl(env["R"], null, []), 3.5)) + J.mul(v_i_606, 0.37)), "act": null, "pl": {}, "style": {}, "cd": {"talk": (2.0 + J.mul(J.cl(env["R"], null, []), 6.0)), "hero": 0.0, "prank": (6.0 + J.mul(J.cl(env["R"], null, []), 10.0)), "tag": (4.0 + J.mul(J.cl(env["R"], null, []), 8.0))}, "lock": null, "eatT": 0.0, "wetT": 0.0, "iconT": 9.0, "icon": null}
	var _t622 = J.gp(v_ag_609, "face")
	J.sp(v_ag_609, "want", _t622)
	var _t623 = J.gp(v_ag_609, "x")
	J.sp(v_ag_609, "tx", _t623)
	var _t624 = J.gp(v_ag_609, "y")
	J.sp(v_ag_609, "ty", _t624)
	J.sp(v_ag_609, "W", v_W_607)
	return v_ag_609

func _f58(this_, a: Array, env):
	var v_ag_613 = null; var v_steps_614 = null
	v_ag_613 = J.arg(a, 0)
	v_steps_614 = J.arg(a, 1)
	var _t625 = J.mc(v_steps_614, "slice", [])
	J.sp(v_ag_613, "q", _t625)
	var _t626 = env["next"]
	J.cl(_t626, null, [v_ag_613])

func _f59(this_, a: Array, env):
	var v_ag_617 = null; var v_c_618 = null
	v_ag_617 = J.arg(a, 0)
	var _t627 = J.mc(J.gp(v_ag_617, "q"), "shift", [])
	var _t628 = (_t627 if J.t(_t627) else null)
	J.sp(v_ag_617, "cur", _t628)
	v_c_618 = _t628
	J.sp(v_ag_617, "at", 0.0)
	if (not J.t(v_c_618)):
		J.sp(v_ag_617, "st", "idle")
		J.sp(v_ag_617, "act", null)
		var _t629 = {}
		J.sp(v_ag_617, "pl", _t629)
		var _t630 = {}
		J.sp(v_ag_617, "style", _t630)
		var _t631 = (0.8 + J.mul(J.cl(env["R"], null, []), 2.6))
		J.sp(v_ag_617, "dur", _t631)
		return null
	if J.t(J.gp(v_c_618, "fn")):
		J.mc(v_c_618, "fn", [v_ag_617])
		var _t632 = env["next"]
		return J.cl(_t632, null, [v_ag_617])
	if J.t(J.gp(v_c_618, "go")):
		J.sp(v_ag_617, "st", "go")
		var _t633 = J.gp(v_c_618, "style")
		var _t634 = (_t633 if J.t(_t633) else {})
		J.sp(v_ag_617, "style", _t634)
		var _t635 = J.gp(J.gp(v_ag_617, "style"), "act")
		var _t636 = (_t635 if J.t(_t635) else null)
		J.sp(v_ag_617, "act", _t636)
		var _t637 = {}
		J.sp(v_ag_617, "pl", _t637)
		var _t638 = J.gp(J.gp(v_c_618, "go"), 0.0)
		J.sp(v_ag_617, "tx", _t638)
		var _t639 = J.gp(J.gp(v_c_618, "go"), 1.0)
		J.sp(v_ag_617, "ty", _t639)
		return null
	var _t640 = ("act" if J.t(J.gp(v_c_618, "act")) else "idle")
	J.sp(v_ag_617, "st", _t640)
	var _t641 = J.gp(v_c_618, "act")
	var _t642 = (_t641 if J.t(_t641) else null)
	J.sp(v_ag_617, "act", _t642)
	var _t643 = J.gp(v_c_618, "d")
	J.sp(v_ag_617, "dur", _t643)
	var _t645 = {"d": J.gp(v_c_618, "d")}
	var _t644 = J.gp(v_c_618, "p")
	var _t646 = J.S_Object_("assign", [_t645, (_t644 if J.t(_t644) else {})])
	J.sp(v_ag_617, "pl", _t646)
	var _t647 = J.gp(v_c_618, "style")
	var _t648 = (_t647 if J.t(_t647) else {})
	J.sp(v_ag_617, "style", _t648)
	if (not J.leq(J.gp(v_c_618, "face"), null)):
		var _t649 = (J.cmp(J.gp(J.gp(v_c_618, "face"), "x"), J.gp(v_ag_617, "x"), ">") if J.seq(J.typeof_(J.gp(v_c_618, "face")), "object") else (not (not J.t(J.gp(v_c_618, "face")))))
		J.sp(v_ag_617, "want", _t649)

func _f61(this_, a: Array, env):
	var v_p_625 = null
	v_p_625 = J.arg(a, 0)
	return {"go": v_p_625, "style": env["style"]}

func _f60(this_, a: Array, env):
	var v_ag_621 = null; var v_x_622 = null; var v_y_623 = null
	var _s165 = {"__p": env, "style": null}
	v_ag_621 = J.arg(a, 0)
	v_x_622 = J.arg(a, 1)
	v_y_623 = J.arg(a, 2)
	_s165["style"] = J.arg(a, 3)
	var _t650 = _s165["__p"]["route"]
	var _t651 = J.cl(_t650, null, [J.gp(v_ag_621, "x"), J.gp(v_ag_621, "y"), v_x_622, v_y_623])
	return J.mc(_t651, "map", [Callable(self, "_f61").bind(_s165)])

func _f62(this_, a: Array, env):
	var v_arr_628 = null; var v_tot_629 = null; var v_r_630 = null; var v_e_631 = null; var v_e_632 = null
	v_arr_628 = J.arg(a, 0)
	v_tot_629 = 0.0
	for _t652 in J.iter(v_arr_628):
		v_e_631 = _t652
		var _t653 = J.add(v_tot_629, J.gp(v_e_631, 0.0))
		v_tot_629 = _t653
	v_r_630 = J.mul(J.cl(env["R"], null, []), v_tot_629)
	for _t654 in J.iter(v_arr_628):
		v_e_632 = _t654
		var _t655 = J.sub(v_r_630, J.gp(v_e_632, 0.0))
		v_r_630 = _t655
		if (v_r_630 <= 0.0):
			return J.gp(v_e_632, 1.0)
	return J.gp(J.gp(v_arr_628, (J.len(v_arr_628) - 1.0)), 1.0)

func _f66(this_, a: Array, env):
	var v_o_645 = null
	v_o_645 = J.arg(a, 0)
	var _t657 = (not J.seq(v_o_645, env["__p"]["ag"]))
	return (J.seq(J.gp(v_o_645, "act"), env["n"]) if _t657 else _t657)

func _f65(this_, a: Array, env):
	var _s173 = {"__p": env, "n": null}
	_s173["n"] = J.arg(a, 0)
	var _t656 = J.gp(_s173["__p"]["W"], "list")
	return pow(J.num(0.25), J.num(J.len(J.mc(_t656, "filter", [Callable(self, "_f66").bind(_s173)]))))

func _f68(this_, a: Array, env):
	var v_p_648 = null
	var _t658 = env["__p"]["__p"]["freePt"]
	v_p_648 = J.cl(_t658, null, [env["__p"]["W"], env["__p"]["ag"]])
	var _t659 = env["__p"]["__p"]["setPlan"]
	var _t662 = env["__p"]["ag"]
	var _t660 = env["__p"]["__p"]["goSteps"]
	var _t661 = J.cl(_t660, null, [env["__p"]["ag"], J.gp(v_p_648, 0.0), J.gp(v_p_648, 1.0), env["style"]])
	J.cl(_t659, null, [_t662, J.mc(_t661, "concat", [(env["after"] if J.t(env["after"]) else [])])])

func _f67(this_, a: Array, env):
	var _s175 = {"__p": env, "style": null, "after": null}
	_s175["style"] = J.arg(a, 0)
	_s175["after"] = J.arg(a, 1)
	return Callable(self, "_f68").bind(_s175)

func _f69(this_, a: Array, env):
	var _t663 = env["__p"]["setPlan"]
	return J.cl(_t663, null, [env["ag"], [{"act": "plaza_look", "d": J.add(1.8, J.cl(env["__p"]["R"], null, []))}]])

func _f70(this_, a: Array, env):
	var _t664 = env["__p"]["setPlan"]
	return J.cl(_t664, null, [env["ag"], [{"act": "plaza_stretch", "d": 2.0}]])

func _f71(this_, a: Array, env):
	var _t665 = env["__p"]["setPlan"]
	return J.cl(_t665, null, [env["ag"], [{"act": "plaza_doze", "d": (6.0 + J.mul(J.cl(env["__p"]["R"], null, []), 5.0))}]])

func _f72(this_, a: Array, env):
	var v_o_649 = null
	v_o_649 = J.arg(a, 0)
	var _t668 = (not J.seq(v_o_649, env["ag"]))
	if J.t(_t668):
		var _t667 = env["__p"]["isFree"]
		_t668 = J.cl(_t667, null, [v_o_649])
	return (J.cmp(J.gp(J.gp(v_o_649, "cd"), "talk"), 0.0, "<=") if J.t(_t668) else _t668)

func _f73(this_, a: Array, env):
	var v_G_650 = null
	v_G_650 = J.arg(a, 0)
	return J.seq(J.gp(v_G_650, "kind"), "talk")

func _f74(this_, a: Array, env):
	var v_o_651 = null; var v_dx_652 = null; var v_q_653 = null
	v_o_651 = J.gp(env["mate"], floor(J.num(J.mul(J.cl(env["__p"]["R"], null, []), J.len(env["mate"])))))
	v_dx_652 = ((-1.0) if J.cmp(J.gp(env["ag"], "x"), J.gp(v_o_651, "x"), "<") else 1.0)
	var _t672 = env["__p"]["nearZ"]
	v_q_653 = J.cl(_t672, null, [J.add(J.gp(v_o_651, "x"), J.mul(v_dx_652, 20.0)), J.add(J.gp(v_o_651, "y"), (J.sub(J.cl(env["__p"]["R"], null, []), 0.5) * 6.0))])
	var _t673 = env["__p"]["setPlan"]
	var _t675 = env["ag"]
	var _t674 = env["__p"]["goSteps"]
	J.cl(_t673, null, [_t675, J.cl(_t674, null, [env["ag"], J.gp(v_q_653, 0.0), J.gp(v_q_653, 1.0), {"seek": v_o_651}])])

func _f76(this_, a: Array, env):
	var v_o_655 = null
	v_o_655 = J.arg(a, 0)
	var _t677 = (not J.seq(v_o_655, env["__p"]["ag"]))
	var _t679 = (J.seq(J.gp(v_o_655, "k"), env["kk"]) if _t677 else _t677)
	if J.t(_t679):
		var _t678 = env["__p"]["__p"]["isFree"]
		_t679 = J.cl(_t678, null, [v_o_655])
	return _t679

func _f75(this_, a: Array, env):
	var _s184 = {"__p": env, "kk": null}
	_s184["kk"] = J.arg(a, 0)
	var _t676 = J.gp(_s184["__p"]["W"], "list")
	return J.mc(_t676, "find", [Callable(self, "_f76").bind(_s184)])

func _f77(this_, a: Array, env):
	var _t682 = env["__p"]["setPlan"]
	return J.cl(_t682, null, [env["ag"], [{"act": "plaza_eat", "d": (5.0 + J.mul(J.cl(env["__p"]["R"], null, []), 4.0))}]])

func _f78(this_, a: Array, env):
	var v_o_657 = null
	v_o_657 = J.arg(a, 0)
	var _t684 = J.seq(J.gp(v_o_657, "k"), "eguiking")
	return (J.seq(J.gp(v_o_657, "act"), "plaza_eat") if _t684 else _t684)

func _f79(this_, a: Array, env):
	var _t685 = env["__p"]["__p"]["setPlan"]
	return J.cl(_t685, null, [env["__p"]["ag"], [{"go": [J.gp(env["king"], "x"), J.gp(env["king"], "y")], "style": {"follow": env["king"], "sniff": 1.0, "purpose": 1.0}}, {"act": "plaza_sniff", "d": J.add(1.6, J.cl(env["__p"]["__p"]["R"], null, []))}]])

func _f80(this_, a: Array, env):
	var _t686 = env["__p"]["__p"]["setPlan"]
	return J.cl(_t686, null, [env["__p"]["ag"], [{"act": "plaza_sniff", "d": (2.0 + J.mul(J.cl(env["__p"]["__p"]["R"], null, []), 2.0))}]])

func _f81(this_, a: Array, env):
	var v_x_659 = null
	v_x_659 = J.arg(a, 0)
	var _t688 = (not J.seq(v_x_659, env["__p"]["ag"]))
	var _t690 = (J.gp(env["__p"]["__p"]["PAPER"], J.gp(v_x_659, "k")) if _t688 else _t688)
	if J.t(_t690):
		var _t689 = env["__p"]["__p"]["isFree"]
		_t690 = J.cl(_t689, null, [v_x_659])
	return (J.cmp(J.gp(J.gp(v_x_659, "cd"), "tag"), 0.0, "<=") if J.t(_t690) else _t690)

func _f82(this_, a: Array, env):
	var _t691 = env["__p"]["__p"]["startTag"]
	return J.cl(_t691, null, [env["__p"]["W"], env["__p"]["ag"], env["o"]])

func _f84(this_, a: Array, env):
	var v_a_661 = null
	v_a_661 = J.arg(a, 0)
	var _t695 = J.cmp(J.gp(env["b"], 2.0), 0.0, ">")
	J.sp(v_a_661, "want", _t695)

func _f83(this_, a: Array, env):
	var _s195 = {"__p": env, "b": null}
	_s195["b"] = J.gp(J.gp(_s195["__p"]["__p"]["SPOTS"], "bumps"), floor(J.num(J.mul(J.cl(_s195["__p"]["__p"]["R"], null, []), J.len(J.gp(_s195["__p"]["__p"]["SPOTS"], "bumps"))))))
	var _t692 = _s195["__p"]["__p"]["setPlan"]
	var _t696 = _s195["__p"]["ag"]
	var _t693 = _s195["__p"]["__p"]["goSteps"]
	var _t694 = J.cl(_t693, null, [_s195["__p"]["ag"], J.sub(J.gp(_s195["b"], 0.0), J.mul(J.gp(_s195["b"], 2.0), 30.0)), J.gp(_s195["b"], 1.0), {}])
	J.cl(_t692, null, [_t696, J.mc(_t694, "concat", [[{"go": [J.gp(_s195["b"], 0.0), J.gp(_s195["b"], 1.0)], "style": {"purpose": 1.0}}, {"fn": Callable(self, "_f84").bind(_s195)}, {"act": "plaza_bump", "d": 0.75, "p": {"dir": J.gp(_s195["b"], 2.0)}}, {"act": "plaza_dizzy", "d": 2.2}]])])

func _f85(this_, a: Array, env):
	var _t697 = env["__p"]["setPlan"]
	return J.cl(_t697, null, [env["ag"], [{"act": "plaza_backrub", "d": 2.6}]])

func _f86(this_, a: Array, env):
	var v_o_662 = null
	v_o_662 = J.arg(a, 0)
	var _t699 = (not J.seq(v_o_662, env["ag"]))
	return ((J.hypot_([J.sub(J.gp(v_o_662, "x"), J.gp(J.gp(env["__p"]["SPOTS"], "eave"), "x")), J.sub(J.gp(v_o_662, "y"), J.gp(J.gp(env["__p"]["SPOTS"], "eave"), "y"))]) < 18.0) if _t699 else _t699)

func _f87(this_, a: Array, env):
	var _t702 = env["__p"]["__p"]["setPlan"]
	var _t705 = env["__p"]["ag"]
	var _t703 = env["__p"]["__p"]["goSteps"]
	var _t704 = J.cl(_t703, null, [env["__p"]["ag"], J.gp(J.gp(env["__p"]["__p"]["SPOTS"], "eave"), "x"), J.gp(J.gp(env["__p"]["__p"]["SPOTS"], "eave"), "y"), {"purpose": 1.0}])
	return J.cl(_t702, null, [_t705, J.mc(_t704, "concat", [[{"act": "plaza_hang", "d": J.gp(env["T"], "T4"), "p": env["pl"], "face": J.cmp(J.cl(env["__p"]["__p"]["R"], null, []), 0.5, "<")}]])])

func _f88(this_, a: Array, env):
	var _t707 = env["__p"]["__p"]["startTalk"]
	return J.cl(_t707, null, [env["__p"]["W"], env["__p"]["ag"], env["o"], true])

func _f89(this_, a: Array, env):
	var _t708 = env["__p"]["__p"]["startPatrol"]
	return J.cl(_t708, null, [env["__p"]["W"], env["__p"]["ag"], env["o"]])

func _f90(this_, a: Array, env):
	var _t709 = env["__p"]["setPlan"]
	return J.cl(_t709, null, [env["ag"], [{"act": "plaza_golf", "d": ((0.9 + (4.0 * (1.0 + floor(J.num(J.mul(J.cl(env["__p"]["R"], null, []), 2.0)))))) + 0.7)}]])

func _f91(this_, a: Array, env):
	var _t710 = env["__p"]["__p"]["setPlan"]
	var _t713 = env["__p"]["ag"]
	var _t711 = env["__p"]["__p"]["goSteps"]
	var _t712 = J.cl(_t711, null, [env["__p"]["ag"], J.gp(env["b"], 0.0), J.gp(env["b"], 1.0), {"purpose": 1.0}])
	return J.cl(_t710, null, [_t713, J.mc(_t712, "concat", [[{"act": "plaza_hair", "d": (4.6 + J.mul(J.cl(env["__p"]["__p"]["R"], null, []), 4.0)), "face": J.cmp(J.gp(env["b"], 2.0), 0.0, ">")}]])])

func _f92(this_, a: Array, env):
	var _t714 = env["__p"]["__p"]["setPlan"]
	return J.cl(_t714, null, [env["__p"]["ag"], [{"act": "plaza_hair", "d": 4.6}]])

func _f93(this_, a: Array, env):
	var _t715 = env["__p"]["setPlan"]
	return J.cl(_t715, null, [env["ag"], [{"act": "plaza_shake", "d": 1.8}]])

func _f94(this_, a: Array, env):
	var _t716 = env["__p"]["setPlan"]
	return J.cl(_t716, null, [env["ag"], [{"act": "plaza_spin", "d": 2.2}]])

func _f95(this_, a: Array, env):
	var _t718 = env["__p"]["__p"]["startPrank"]
	return J.cl(_t718, null, [env["__p"]["W"], env["__p"]["ag"], env["v"]])

func _f96(this_, a: Array, env):
	var _t719 = env["__p"]["setPlan"]
	return J.cl(_t719, null, [env["ag"], [{"act": "plaza_coins", "d": (5.5 + J.mul(J.cl(env["__p"]["R"], null, []), 3.3))}]])

func _f97(this_, a: Array, env):
	var _t720 = env["__p"]["setPlan"]
	return J.cl(_t720, null, [env["ag"], [{"act": "plaza_hop", "d": (1.3 + J.mul(J.cl(env["__p"]["R"], null, []), 1.5))}]])

func _f64(this_, a: Array, env):
	var v_k_638 = null; var v_opts_639 = null; var v_busy_640 = null; var v_wander_641 = null; var v_free_643 = null; var v_hd_663 = null
	var _s172 = {"__p": env, "ag": null, "W": null, "mate": null}
	_s172["ag"] = J.arg(a, 0)
	_s172["W"] = J.arg(a, 1)
	v_k_638 = J.gp(_s172["ag"], "k")
	v_opts_639 = []
	v_busy_640 = Callable(self, "_f65").bind(_s172)
	v_wander_641 = Callable(self, "_f67").bind(_s172)
	J.mc(v_opts_639, "push", [[5.0, J.cl(v_wander_641, null, [])]])
	J.mc(v_opts_639, "push", [[J.mul(1.4, J.cl(v_busy_640, null, ["plaza_look"])), Callable(self, "_f69").bind(_s172)]])
	J.mc(v_opts_639, "push", [[J.mul(0.9, J.cl(v_busy_640, null, ["plaza_stretch"])), Callable(self, "_f70").bind(_s172)]])
	J.mc(v_opts_639, "push", [[J.mul((2.4 if J.t(J.cl(_s172["__p"]["night"], null, [])) else 0.7), J.cl(v_busy_640, null, ["plaza_doze"])), Callable(self, "_f71").bind(_s172)]])
	var _t666 = J.gp(_s172["W"], "list")
	_s172["mate"] = J.mc(_t666, "filter", [Callable(self, "_f72").bind(_s172)])
	var _t669 = J.len(_s172["mate"])
	var _t671 = (J.cmp(J.gp(J.gp(_s172["ag"], "cd"), "talk"), 0.0, "<=") if J.t(_t669) else _t669)
	if J.t(_t671):
		var _t670 = J.gp(_s172["W"], "games")
		_t671 = (J.len(J.mc(_t670, "filter", [Callable(self, "_f73").bind(_s172)])) < J.max_([1.0, J.round(J.num(J.div(J.len(J.gp(_s172["W"], "list")), 7.0)))]))
	if J.t(_t671):
		J.mc(v_opts_639, "push", [[1.6, Callable(self, "_f74").bind(_s172)]])
	v_free_643 = Callable(self, "_f75").bind(_s172)
	var _t680 = -1
	var _t681 = false
	if _t680 == -1 and J.seq(v_k_638, "eguiking"): _t680 = 0
	if _t680 == -1 and J.seq(v_k_638, "egui"): _t680 = 1
	if _t680 == -1 and J.seq(v_k_638, "xiaozhi"): _t680 = 2
	if _t680 == -1 and J.seq(v_k_638, "zhiren"): _t680 = 3
	if _t680 == -1 and J.seq(v_k_638, "laojiang"): _t680 = 4
	if _t680 == -1 and J.seq(v_k_638, "zombie"): _t680 = 5
	if _t680 == -1 and J.seq(v_k_638, "tianhua"): _t680 = 6
	if _t680 == -1 and J.seq(v_k_638, "mengpo"): _t680 = 7
	if _t680 == -1 and J.seq(v_k_638, "heiwu"): _t680 = 8
	if _t680 == -1 and J.seq(v_k_638, "baiwu"): _t680 = 9
	if _t680 == -1 and J.seq(v_k_638, "niutou"): _t680 = 10
	if _t680 == -1 and J.seq(v_k_638, "mamian"): _t680 = 11
	if _t680 == -1 and J.seq(v_k_638, "huang"): _t680 = 12
	if _t680 == -1 and J.seq(v_k_638, "pontianak"): _t680 = 13
	if _t680 == -1 and J.seq(v_k_638, "shuigui"): _t680 = 14
	if _t680 == -1 and J.seq(v_k_638, "youhun"): _t680 = 15
	if _t680 == -1 and J.seq(v_k_638, "xiaogui"): _t680 = 16
	if _t680 == -1 and J.seq(v_k_638, "toyol"): _t680 = 17
	if _t680 == -1 and J.seq(v_k_638, "pocong"): _t680 = 18
	while true:
		if _t680 <= 0 and _t680 >= 0:
			J.mc(v_opts_639, "push", [[5.0, J.cl(v_wander_641, null, [{"eat": 1.0, "act": "plaza_eat"}, [{"act": "plaza_eat", "d": (3.6 + J.mul(J.cl(_s172["__p"]["R"], null, []), 3.6))}]])], [2.0, Callable(self, "_f77").bind(_s172)]])
			break
		if _t680 <= 1 and _t680 >= 0:
			var _s188 = {"__p": _s172, "king": null}
			var _t683 = J.gp(_s188["__p"]["W"], "list")
			_s188["king"] = J.mc(_t683, "find", [Callable(self, "_f78").bind(_s188)])
			if J.t(_s188["king"]):
				J.mc(v_opts_639, "push", [[5.0, Callable(self, "_f79").bind(_s188)]])
			J.mc(v_opts_639, "push", [[2.0, Callable(self, "_f80").bind(_s188)], [1.5, J.cl(v_wander_641, null, [{"sniff": 1.0}])]])
			break
		if _t680 <= 2 and _t680 >= 0:
			pass
		if _t680 <= 3 and _t680 >= 0:
			var _s192 = {"__p": _s172, "o": null}
			var _t687 = J.gp(_s192["__p"]["W"], "list")
			_s192["o"] = J.mc(_t687, "find", [Callable(self, "_f81").bind(_s192)])
			if J.t((J.cmp(J.gp(J.gp(_s192["__p"]["ag"], "cd"), "tag"), 0.0, "<=") if J.t(_s192["o"]) else _s192["o"])):
				J.mc(v_opts_639, "push", [[4.0, Callable(self, "_f82").bind(_s192)]])
			break
		if _t680 <= 4 and _t680 >= 0:
			pass
		if _t680 <= 5 and _t680 >= 0:
			J.mc(v_opts_639, "push", [[1.8, Callable(self, "_f83").bind(_s172)]])
			break
		if _t680 <= 6 and _t680 >= 0:
			J.mc(v_opts_639, "push", [[2.5, Callable(self, "_f85").bind(_s172)]])
			var _t700 = J.gp(J.gp(_s172["W"], "bld"), "wood")
			if J.t(_t700):
				var _t698 = J.gp(_s172["W"], "list")
				_t700 = (not J.t(J.mc(_t698, "some", [Callable(self, "_f86").bind(_s172)])))
			if J.t(_t700):
				var _s200 = {"__p": _s172, "pl": null, "T": null}
				v_hd_663 = (5.0 + J.mul(J.cl(_s200["__p"]["__p"]["R"], null, []), 5.0))
				_s200["pl"] = {"eh": J.sub(J.gp(J.gp(_s200["__p"]["__p"]["SPOTS"], "eave"), "y"), J.gp(J.gp(_s200["__p"]["__p"]["SPOTS"], "eave"), "ey")), "hd": v_hd_663}
				var _t701 = _s200["__p"]["__p"]["hangTimes"]
				_s200["T"] = J.cl(_t701, null, [_s200["pl"]])
				J.mc(v_opts_639, "push", [[2.2, Callable(self, "_f87").bind(_s200)]])
			break
		if _t680 <= 7 and _t680 >= 0:
			J.mc(v_opts_639, "push", [[4.0, J.cl(v_wander_641, null, [{"purpose": 1.0}, [{"act": "plaza_soup", "d": (9.0 + J.mul(J.cl(_s172["__p"]["R"], null, []), 6.0))}]])]])
			break
		if _t680 <= 8 and _t680 >= 0:
			pass
		if _t680 <= 9 and _t680 >= 0:
			var _s202 = {"__p": _s172, "o": null}
			_s202["o"] = J.cl(v_free_643, null, [("baiwu" if J.seq(v_k_638, "heiwu") else "heiwu")])
			var _t706 = (J.cmp(J.gp(J.gp(_s202["__p"]["ag"], "cd"), "talk"), 0.0, "<=") if J.t(_s202["o"]) else _s202["o"])
			if J.t((J.cmp(J.gp(J.gp(_s202["o"], "cd"), "talk"), 0.0, "<=") if J.t(_t706) else _t706)):
				J.mc(v_opts_639, "push", [[4.0, Callable(self, "_f88").bind(_s202)]])
			break
		if _t680 <= 10 and _t680 >= 0:
			pass
		if _t680 <= 11 and _t680 >= 0:
			var _s204 = {"__p": _s172, "o": null}
			_s204["o"] = J.cl(v_free_643, null, [("mamian" if J.seq(v_k_638, "niutou") else "niutou")])
			if J.t(_s204["o"]):
				J.mc(v_opts_639, "push", [[4.0, Callable(self, "_f89").bind(_s204)]])
			break
		if _t680 <= 12 and _t680 >= 0:
			J.mc(v_opts_639, "push", [[4.0, Callable(self, "_f90").bind(_s172)]])
			break
		if _t680 <= 13 and _t680 >= 0:
			var _s207 = {"__p": _s172, "b": null}
			_s207["b"] = J.gp(J.gp(_s207["__p"]["__p"]["SPOTS"], "banana"), floor(J.num(J.mul(J.cl(_s207["__p"]["__p"]["R"], null, []), 2.0))))
			J.mc(v_opts_639, "push", [[3.0, Callable(self, "_f91").bind(_s207)], [1.5, Callable(self, "_f92").bind(_s207)]])
			break
		if _t680 <= 14 and _t680 >= 0:
			J.mc(v_opts_639, "push", [[2.0, Callable(self, "_f93").bind(_s172)]])
			break
		if _t680 <= 15 and _t680 >= 0:
			J.mc(v_opts_639, "push", [[2.2, Callable(self, "_f94").bind(_s172)], [2.0, J.cl(v_wander_641, null, [])]])
			break
		if _t680 <= 16 and _t680 >= 0:
			var _s212 = {"__p": _s172, "v": null}
			var _t717 = _s212["__p"]["__p"]["prankVictim"]
			_s212["v"] = J.cl(_t717, null, [_s212["__p"]["W"], _s212["__p"]["ag"]])
			if J.t((J.cmp(J.gp(J.gp(_s212["__p"]["ag"], "cd"), "prank"), 0.0, "<=") if J.t(_s212["v"]) else _s212["v"])):
				J.mc(v_opts_639, "push", [[4.0, Callable(self, "_f95").bind(_s212)]])
			break
		if _t680 <= 17 and _t680 >= 0:
			J.mc(v_opts_639, "push", [[4.0, Callable(self, "_f96").bind(_s172)]])
			break
		if _t680 <= 18 and _t680 >= 0:
			J.mc(v_opts_639, "push", [[2.0, Callable(self, "_f97").bind(_s172)]])
			break
		break
	var _t721 = _s172["__p"]["pickW"]
	J.cl(J.cl(_t721, null, [v_opts_639]), null, [])

func _f99(this_, a: Array, env):
	var v_x_687 = null
	v_x_687 = J.arg(a, 0)
	var _t736 = J.cmp(J.gp(env["b"], "x"), J.gp(v_x_687, "x"), ">")
	J.sp(v_x_687, "want", _t736)

func _f100(this_, a: Array, env):
	var v_x_688 = null
	v_x_688 = J.arg(a, 0)
	var _t738 = J.cmp(J.gp(env["a"], "x"), J.gp(v_x_688, "x"), ">")
	J.sp(v_x_688, "want", _t738)

func _f98(this_, a: Array, env):
	var v_W_672 = null; var v_argue_675 = null; var v_G_676 = null; var v_d_677 = null; var v_act_678 = null; var v_g1_679 = null; var v_g2_680 = null; var v_pre_681 = null; var v_mx_682 = null; var v_my_683 = null; var v_q_684 = null; var v_side_685 = null; var v_q_686 = null
	var _s216 = {"__p": env, "a": null, "b": null}
	v_W_672 = J.arg(a, 0)
	_s216["a"] = J.arg(a, 1)
	_s216["b"] = J.arg(a, 2)
	v_argue_675 = J.arg(a, 3)
	v_G_676 = {"kind": "talk", "a": _s216["a"], "b": _s216["b"], "argue": v_argue_675, "spk": (_s216["a"] if J.cmp(J.cl(_s216["__p"]["R"], null, []), 0.5, "<") else _s216["b"]), "sw": 0.8, "T": ((6.0 + J.mul(J.cl(_s216["__p"]["R"], null, []), 4.0)) if J.t(v_argue_675) else (3.5 + J.mul(J.cl(_s216["__p"]["R"], null, []), 3.0)))}
	var _t722 = _s216["a"]
	var _t723 = _s216["b"]
	J.sp(_t723, "lock", v_G_676)
	J.sp(_t722, "lock", v_G_676)
	var _t724 = J.gp(_s216["a"], "cd")
	var _t725 = J.gp(_s216["b"], "cd")
	J.sp(_t725, "talk", 99.0)
	J.sp(_t724, "talk", 99.0)
	v_d_677 = J.hypot_([J.sub(J.gp(_s216["a"], "x"), J.gp(_s216["b"], "x")), J.sub(J.gp(_s216["a"], "y"), J.gp(_s216["b"], "y"))])
	v_act_678 = ("plaza_argue" if J.t(v_argue_675) else "plaza_talk")
	v_g1_679 = ("plaza_wave" if J.cmp(J.cl(_s216["__p"]["R"], null, []), 0.5, "<") else "plaza_bow")
	v_g2_680 = ("plaza_wave" if J.cmp(J.cl(_s216["__p"]["R"], null, []), 0.5, "<") else "plaza_bow")
	v_pre_681 = []
	if J.t((J.cmp(v_d_677, 30.0, ">") if J.t(v_argue_675) else v_argue_675)):
		v_mx_682 = J.div(J.add(J.gp(_s216["a"], "x"), J.gp(_s216["b"], "x")), 2.0)
		v_my_683 = J.div(J.add(J.gp(_s216["a"], "y"), J.gp(_s216["b"], "y")), 2.0)
		var _t726 = _s216["__p"]["nearZ"]
		v_q_684 = J.cl(_t726, null, [J.add(v_mx_682, ((-11.0) if J.cmp(J.gp(_s216["a"], "x"), J.gp(_s216["b"], "x"), "<") else 11.0)), v_my_683])
		var _t727 = _s216["__p"]["goSteps"]
		var _t728 = J.cl(_t727, null, [_s216["a"], J.gp(v_q_684, 0.0), J.gp(v_q_684, 1.0), {"purpose": 1.0}])
		v_pre_681 = _t728
	else:
		var _t729 = J.cmp(v_d_677, 18.0, "<")
		if (_t729 if _t729 else (absf(J.num(J.sub(J.gp(_s216["a"], "y"), J.gp(_s216["b"], "y")))) > 6.0)):
			v_side_685 = ((-1.0) if J.cmp(J.gp(_s216["a"], "x"), J.gp(_s216["b"], "x"), "<") else 1.0)
			var _t730 = _s216["__p"]["nearZ"]
			v_q_686 = J.cl(_t730, null, [J.add(J.gp(_s216["b"], "x"), J.mul(v_side_685, 21.0)), J.add(J.gp(_s216["b"], "y"), (J.sub(J.cl(_s216["__p"]["R"], null, []), 0.5) * 3.0))])
			if (absf(J.num(J.sub(J.gp(v_q_686, 0.0), J.gp(_s216["b"], "x")))) < 15.0):
				v_side_685 = (-J.num(v_side_685))
				var _t731 = _s216["__p"]["nearZ"]
				var _t732 = J.cl(_t731, null, [J.add(J.gp(_s216["b"], "x"), J.mul(v_side_685, 21.0)), J.gp(_s216["b"], "y")])
				v_q_686 = _t732
			var _t733 = _s216["__p"]["goSteps"]
			var _t734 = J.cl(_t733, null, [_s216["a"], J.gp(v_q_686, 0.0), J.gp(v_q_686, 1.0), {"purpose": 1.0}])
			v_pre_681 = _t734
	J.sp(v_G_676, "t", 0.0)
	J.sp(v_G_676, "act", v_act_678)
	var _t735 = _s216["__p"]["setPlan"]
	J.cl(_t735, null, [_s216["a"], J.mc(v_pre_681, "concat", [[{"fn": Callable(self, "_f99").bind(_s216)}, ({"act": "plaza_look", "d": 0.5} if J.t(v_argue_675) else {"act": v_g1_679, "d": 1.3, "p": {"deep": 0.7}}), {"act": v_act_678, "d": 60.0, "p": {}}]])])
	var _t737 = _s216["__p"]["setPlan"]
	J.cl(_t737, null, [_s216["b"], [{"fn": Callable(self, "_f100").bind(_s216)}, {"d": (0.3 if J.t(v_argue_675) else 0.35)}, ({"act": "plaza_look", "d": 0.5} if J.t(v_argue_675) else {"act": v_g2_680, "d": 1.3, "p": {"deep": 0.7}}), {"act": v_act_678, "d": 60.0, "p": {}}]])
	var _t739 = J.gp(v_W_672, "games")
	J.mc(_t739, "push", [v_G_676])

func _f101(this_, a: Array, env):
	var v_W_691 = null; var v_ag_692 = null; var v_p_693 = null
	v_W_691 = J.arg(a, 0)
	v_ag_692 = J.arg(a, 1)
	J.sp(v_ag_692, "lock", null)
	var _t740 = J.gp(v_ag_692, "cd")
	var _t741 = (10.0 + J.mul(J.cl(env["R"], null, []), 12.0))
	J.sp(_t740, "talk", _t741)
	var _t742 = env["freePt"]
	v_p_693 = J.cl(_t742, null, [J.gp(v_ag_692, "W"), v_ag_692])
	var _t743 = env["goSteps"]
	var _t744 = J.cl(_t743, null, [v_ag_692, J.gp(v_p_693, 0.0), J.gp(v_p_693, 1.0)])
	J.sp(v_ag_692, "q", _t744)

func _f102(this_, a: Array, env):
	var v_W_696 = null; var v_a_697 = null; var v_b_698 = null; var v_G_699 = null
	v_W_696 = J.arg(a, 0)
	v_a_697 = J.arg(a, 1)
	v_b_698 = J.arg(a, 2)
	v_G_699 = {"kind": "tag", "ch": v_a_697, "ru": v_b_698, "T": (9.0 + J.mul(J.cl(env["R"], null, []), 5.0)), "t": 0.0, "pause": 0.0}
	J.sp(v_b_698, "lock", v_G_699)
	J.sp(v_a_697, "lock", v_G_699)
	var _t745 = J.gp(v_a_697, "cd")
	var _t746 = J.gp(v_b_698, "cd")
	J.sp(_t746, "tag", 99.0)
	J.sp(_t745, "tag", 99.0)
	var _t747 = []
	J.sp(v_a_697, "q", _t747)
	var _t748 = []
	J.sp(v_b_698, "q", _t748)
	J.sp(v_b_698, "cur", null)
	J.sp(v_a_697, "cur", null)
	var _t749 = J.gp(v_W_696, "games")
	J.mc(_t749, "push", [v_G_699])

func _f103(this_, a: Array, env):
	var v_W_702 = null; var v_G_703 = null; var v_dt_704 = null; var v_ch_705 = null; var v_ru_706 = null; var v_x_707 = null; var v_x_708 = null; var v_best_709 = null; var v_bs_710 = null; var v_i_711 = null; var v_p_712 = null; var v_sc_713 = null
	v_W_702 = J.arg(a, 0)
	v_G_703 = J.arg(a, 1)
	v_dt_704 = J.arg(a, 2)
	var _t750 = J.add(J.gp(v_G_703, "t"), v_dt_704)
	J.sp(v_G_703, "t", _t750)
	var _t751 = J.gp(v_G_703, "ch")
	v_ch_705 = _t751
	var _t752 = J.gp(v_G_703, "ru")
	v_ru_706 = _t752
	if J.cmp(J.gp(v_G_703, "pause"), 0.0, ">"):
		var _t753 = J.sub(J.gp(v_G_703, "pause"), v_dt_704)
		J.sp(v_G_703, "pause", _t753)
		if J.cmp(J.gp(v_G_703, "pause"), 0.0, "<="):
			v_x_707 = J.gp(v_G_703, "ch")
			var _t754 = J.gp(v_G_703, "ru")
			J.sp(v_G_703, "ch", _t754)
			J.sp(v_G_703, "ru", v_x_707)
		return null
	if J.cmp(J.gp(v_G_703, "t"), J.gp(v_G_703, "T"), ">"):
		for _t755 in J.iter([v_ch_705, v_ru_706]):
			v_x_708 = _t755
			J.sp(v_x_708, "lock", null)
			var _t756 = J.gp(v_x_708, "cd")
			var _t757 = (18.0 + J.mul(J.cl(env["R"], null, []), 14.0))
			J.sp(_t756, "tag", _t757)
			var _t758 = env["setPlan"]
			J.cl(_t758, null, [v_x_708, [{"act": "plaza_bow", "d": 1.4, "p": {"deep": 0.6}}]])
		J.sp(v_G_703, "done", 1.0)
		return null
	var _t759 = (not J.seq(J.gp(v_ru_706, "st"), "go"))
	if (_t759 if _t759 else (J.hypot_([J.sub(J.gp(v_ru_706, "x"), J.gp(v_ru_706, "tx")), J.sub(J.gp(v_ru_706, "y"), J.gp(v_ru_706, "ty"))]) < 6.0)):
		v_best_709 = null
		v_bs_710 = (-1.0)
		v_i_711 = 0.0
		while true:
			if not J.cmp(v_i_711, 6.0, "<"): break
			v_p_712 = J.cl(env["zonePt"], null, [])
			v_sc_713 = (J.hypot_([J.sub(J.gp(v_p_712, 0.0), J.gp(v_ch_705, "x")), J.sub(J.gp(v_p_712, 1.0), J.gp(v_ch_705, "y"))]) - (J.hypot_([J.sub(J.gp(v_p_712, 0.0), J.gp(v_ru_706, "x")), J.sub(J.gp(v_p_712, 1.0), J.gp(v_ru_706, "y"))]) * 0.3))
			if J.cmp(v_sc_713, v_bs_710, ">"):
				v_bs_710 = v_sc_713
				v_best_709 = v_p_712
			v_i_711 = J.num(v_i_711) + 1.0
		var _t760 = env["setPlan"]
		var _t761 = env["goSteps"]
		J.cl(_t760, null, [v_ru_706, J.cl(_t761, null, [v_ru_706, J.gp(v_best_709, 0.0), J.gp(v_best_709, 1.0), {"run": 1.0, "spd": 1.55, "purpose": 1.0}])])
	var _t762 = (not J.t(J.gp(v_ch_705, "cur")))
	var _t763 = (_t762 if _t762 else (not J.t(J.gp(J.gp(v_ch_705, "cur"), "go"))))
	if (_t763 if _t763 else (not J.seq(J.gp(J.gp(v_ch_705, "style"), "follow"), v_ru_706))):
		var _t764 = env["setPlan"]
		J.cl(_t764, null, [v_ch_705, [{"go": [J.gp(v_ru_706, "x"), J.gp(v_ru_706, "y")], "style": {"follow": v_ru_706, "chase": 1.0, "run": 1.0, "spd": 1.7, "purpose": 1.0}}]])
	if (J.hypot_([J.sub(J.gp(v_ch_705, "x"), J.gp(v_ru_706, "x")), (J.sub(J.gp(v_ch_705, "y"), J.gp(v_ru_706, "y")) * 1.4)]) < 11.0):
		var _t765 = J.cmp(J.gp(v_ru_706, "x"), J.gp(v_ch_705, "x"), ">")
		J.sp(v_ch_705, "want", _t765)
		var _t766 = J.cmp(J.gp(v_ch_705, "x"), J.gp(v_ru_706, "x"), ">")
		J.sp(v_ru_706, "want", _t766)
		var _t767 = env["setPlan"]
		J.cl(_t767, null, [v_ch_705, [{"act": "plaza_reach", "d": 0.5}, {"d": 0.5}]])
		var _t768 = env["setPlan"]
		J.cl(_t768, null, [v_ru_706, [{"act": "plaza_eek", "d": 0.75}, {"d": 0.25}]])
		var _t769 = {"s": "抓到！", "t": 0.0}
		J.sp(v_ch_705, "fxTxt", _t769)
		J.sp(v_G_703, "pause", 1.0)

func _f105(this_, a: Array, env):
	var v_o_719 = null
	v_o_719 = J.arg(a, 0)
	var _t771 = (not J.seq(v_o_719, env["x"]))
	var _t772 = ((not J.t(J.gp(v_o_719, "lock"))) if _t771 else _t771)
	var _t773 = ((not J.seq(J.gp(v_o_719, "k"), "xiaogui")) if _t772 else _t772)
	var _t777 = ((not J.seq(J.gp(v_o_719, "act"), "plaza_hang")) if _t773 else _t773)
	if J.t(_t777):
		var _t774 = J.seq(J.gp(v_o_719, "st"), "act")
		var _t776 = ((J.sub(J.gp(v_o_719, "dur"), J.gp(v_o_719, "at")) > 3.0) if _t774 else _t774)
		if not J.t(_t776):
			var _t775 = J.seq(J.gp(v_o_719, "st"), "idle")
			_t776 = ((J.sub(J.gp(v_o_719, "dur"), J.gp(v_o_719, "at")) > 1.5) if _t775 else _t775)
		_t777 = _t776
	return _t777

func _f104(this_, a: Array, env):
	var v_W_716 = null; var v_c_718 = null
	var _s235 = {"__p": env, "x": null}
	v_W_716 = J.arg(a, 0)
	_s235["x"] = J.arg(a, 1)
	var _t770 = J.gp(v_W_716, "list")
	v_c_718 = J.mc(_t770, "filter", [Callable(self, "_f105").bind(_s235)])
	return (J.gp(v_c_718, floor(J.num(J.mul(J.cl(_s235["__p"]["R"], null, []), J.len(v_c_718))))) if J.t(J.len(v_c_718)) else null)

func _f107(this_, a: Array, env):
	var v_a_730 = null
	v_a_730 = J.arg(a, 0)
	var _t792 = J.cmp(J.gp(env["v"], "x"), J.gp(v_a_730, "x"), ">")
	J.sp(v_a_730, "want", _t792)

func _f108(this_, a: Array, env):
	var _t793 = env["G"]
	J.sp(_t793, "boo", 1.0)

func _f109(this_, a: Array, env):
	var v_a_731 = null; var v_p_732 = null
	v_a_731 = J.arg(a, 0)
	J.sp(v_a_731, "lock", null)
	var _t794 = J.gp(v_a_731, "cd")
	var _t795 = (22.0 + J.mul(J.cl(env["__p"]["R"], null, []), 20.0))
	J.sp(_t794, "prank", _t795)
	var _t796 = env["__p"]["freePt"]
	v_p_732 = J.cl(_t796, null, [env["W"], v_a_731])
	var _t797 = env["__p"]["goSteps"]
	var _t798 = J.cl(_t797, null, [v_a_731, J.gp(v_p_732, 0.0), J.gp(v_p_732, 1.0), {"run": 1.0, "spd": 1.5}])
	J.sp(v_a_731, "q", _t798)

func _f106(this_, a: Array, env):
	var v_x_723 = null; var v_bx_726 = null; var v_by_727 = null; var v_dist_728 = null; var v_tt_729 = null
	var _s237 = {"__p": env, "W": null, "v": null, "G": null}
	_s237["W"] = J.arg(a, 0)
	v_x_723 = J.arg(a, 1)
	_s237["v"] = J.arg(a, 2)
	_s237["G"] = {"kind": "prank", "x": v_x_723, "v": _s237["v"], "vx": J.gp(_s237["v"], "x"), "vy": J.gp(_s237["v"], "y")}
	var _t778 = _s237["v"]
	var _t779 = _s237["G"]
	J.sp(_t778, "lock", _t779)
	J.sp(v_x_723, "lock", _t779)
	var _t780 = J.gp(v_x_723, "cd")
	J.sp(_t780, "prank", 99.0)
	var _t781 = _s237["__p"]["nearZ"]
	var _t782 = J.cl(_t781, null, [J.sub(J.gp(_s237["v"], "x"), ((1.0 if J.t(J.gp(_s237["v"], "face")) else (-1.0)) * 17.0)), J.add(J.gp(_s237["v"], "y"), 1.0)])
	var _t783 = J.gp(_t782, 0.0)
	v_bx_726 = _t783
	var _t784 = J.gp(_t782, 1.0)
	v_by_727 = _t784
	v_dist_728 = J.hypot_([J.sub(v_bx_726, J.gp(v_x_723, "x")), J.sub(v_by_727, J.gp(v_x_723, "y"))])
	v_tt_729 = (J.div(v_dist_728, J.mul(J.gp(v_x_723, "vmax"), 0.45)) + 1.5)
	if J.seq(J.gp(_s237["v"], "st"), "act"):
		var _t785 = _s237["v"]
		var _t786 = J.max_([J.gp(_s237["v"], "dur"), J.add(J.add(J.gp(_s237["v"], "at"), v_tt_729), 1.2)])
		J.sp(_t785, "dur", _t786)
	else:
		var _t787 = _s237["v"]
		var _t788 = J.max_([J.gp(_s237["v"], "dur"), J.add(J.add(J.gp(_s237["v"], "at"), v_tt_729), 1.2)])
		J.sp(_t787, "dur", _t788)
	var _t789 = _s237["__p"]["setPlan"]
	var _t790 = _s237["__p"]["goSteps"]
	var _t791 = J.cl(_t790, null, [v_x_723, v_bx_726, v_by_727, {"sneak": 1.0, "spd": 0.45, "purpose": 1.0}])
	J.cl(_t789, null, [v_x_723, J.mc(_t791, "concat", [[{"fn": Callable(self, "_f107").bind(_s237)}, {"d": 0.35}, {"fn": Callable(self, "_f108").bind(_s237)}, {"act": "plaza_boo", "d": 0.95}, {"act": "plaza_laugh", "d": 1.7}, {"fn": Callable(self, "_f109").bind(_s237)}]])])
	var _t799 = J.gp(_s237["W"], "games")
	J.mc(_t799, "push", [_s237["G"]])

func _f111(this_, a: Array, env):
	var v_a_739 = null
	v_a_739 = J.arg(a, 0)
	J.sp(v_a_739, "lock", null)

func _f110(this_, a: Array, env):
	var v_W_735 = null; var v_G_736 = null; var v_x_737 = null; var v_v_738 = null
	v_W_735 = J.arg(a, 0)
	v_G_736 = J.arg(a, 1)
	var _t800 = J.gp(v_G_736, "x")
	v_x_737 = _t800
	var _t801 = J.gp(v_G_736, "v")
	v_v_738 = _t801
	var _t802 = (not J.t(J.gp(v_G_736, "boo")))
	if ((J.hypot_([J.sub(J.gp(v_v_738, "x"), J.gp(v_G_736, "vx")), J.sub(J.gp(v_v_738, "y"), J.gp(v_G_736, "vy"))]) > 10.0) if _t802 else _t802):
		J.sp(v_v_738, "lock", null)
		J.sp(v_x_737, "lock", null)
		var _t803 = J.gp(v_x_737, "cd")
		J.sp(_t803, "prank", 10.0)
		var _t804 = env["setPlan"]
		J.cl(_t804, null, [v_x_737, [{"act": "plaza_look", "d": 1.6}]])
		J.sp(v_G_736, "done", 1.0)
		return null
	var _t805 = J.seq(J.gp(v_G_736, "boo"), 1.0)
	var _t806 = (J.seq(J.gp(v_x_737, "act"), "plaza_boo") if _t805 else _t805)
	if (J.cmp(J.gp(v_x_737, "at"), 0.2, ">") if _t806 else _t806):
		J.sp(v_G_736, "boo", 2.0)
		var _t807 = J.cmp(J.gp(v_x_737, "x"), J.gp(v_v_738, "x"), ">")
		J.sp(v_v_738, "want", _t807)
		var _t808 = env["setPlan"]
		J.cl(_t808, null, [v_v_738, [{"act": "plaza_startle", "d": 1.3}, {"act": "plaza_look", "d": 1.2}, {"fn": Callable(self, "_f111").bind(env)}]])
		J.sp(v_v_738, "icon", "!")
		J.sp(v_v_738, "iconT", 0.0)
		J.sp(v_G_736, "done", 1.0)

func _f113(this_, a: Array, env):
	var v_x_751 = null
	v_x_751 = J.arg(a, 0)
	J.sp(v_x_751, "lock", null)
	var _t811 = env["b"]
	J.sp(_t811, "lock", null)
	var _t812 = env["b"]
	var _t813 = []
	J.sp(_t812, "q", _t813)
	var _t814 = env["G"]
	J.sp(_t814, "done", 1.0)

func _f112(this_, a: Array, env):
	var v_W_742 = null; var v_a_743 = null; var v_pts_746 = null; var v_st_747 = null; var v_steps_748 = null; var v_i_749 = null; var v_p_750 = null
	var _s246 = {"__p": env, "b": null, "G": null}
	v_W_742 = J.arg(a, 0)
	v_a_743 = J.arg(a, 1)
	_s246["b"] = J.arg(a, 2)
	_s246["G"] = {"kind": "patrol", "a": v_a_743, "b": _s246["b"]}
	var _t809 = _s246["b"]
	var _t810 = _s246["G"]
	J.sp(_t809, "lock", _t810)
	J.sp(v_a_743, "lock", _t810)
	v_pts_746 = [[170.0, 560.0], [226.0, 650.0], [340.0, 656.0], [200.0, 668.0], [50.0, 656.0], [190.0, 600.0]]
	v_st_747 = floor(J.num(J.mul(J.cl(_s246["__p"]["R"], null, []), J.len(v_pts_746))))
	v_steps_748 = []
	v_i_749 = 0.0
	while true:
		if not J.cmp(v_i_749, 4.0, "<"): break
		v_p_750 = J.gp(v_pts_746, J.mod(J.add(v_st_747, v_i_749), J.len(v_pts_746)))
		J.mc(v_steps_748, "push", [{"go": v_p_750, "style": {"stiff": 1.0, "purpose": 1.0}}, {"act": "plaza_look", "d": 1.6}])
		v_i_749 = J.num(v_i_749) + 1.0
	J.mc(v_steps_748, "push", [{"fn": Callable(self, "_f113").bind(_s246)}])
	var _t815 = _s246["__p"]["setPlan"]
	J.cl(_t815, null, [v_a_743, v_steps_748])
	var _t816 = _s246["__p"]["setPlan"]
	J.cl(_t816, null, [_s246["b"], [{"go": [J.gp(v_a_743, "x"), J.gp(v_a_743, "y")], "style": {"follow": v_a_743, "stiff": 1.0, "side": 1.0, "purpose": 1.0, "keep": 1.0}}]])
	var _t817 = J.gp(v_W_742, "games")
	J.mc(_t817, "push", [_s246["G"]])

func _f114(this_, a: Array, env):
	var v_ag_754 = null; var v_dt_755 = null; var v_W_756 = null; var v_hopper_757 = null; var v_G_758 = null; var v_k_759 = null; var v_st_760 = null; var v_tx_761 = null; var v_ty_762 = null; var v_stopD_763 = null; var v_dx_764 = null; var v_dy_765 = null; var v_d_766 = null; var v_vm_767 = null; var v_tsp_768 = null; var v_mv_769 = null; var v_f_770 = null; var v_fd_771 = null; var v_f_772 = null; var v_q_773 = null; var v_air_774 = null; var v_nx_775 = null; var v_ny_776 = null; var v_z0_777 = null; var v_z1_778 = null; var v_q_779 = null; var v_k_780 = null; var v_dir_781 = null; var v_o_782 = null
	v_ag_754 = J.arg(a, 0)
	v_dt_755 = J.arg(a, 1)
	v_W_756 = J.arg(a, 2)
	var _t818 = J.add(J.gp(v_ag_754, "at"), v_dt_755)
	J.sp(v_ag_754, "at", _t818)
	for _t819 in J.keys(J.gp(v_ag_754, "cd")):
		v_k_759 = _t819
		var _t820 = J.gp(v_ag_754, "cd")
		var _t821 = J.sub(J.gp(_t820, v_k_759), v_dt_755)
		J.sp(_t820, v_k_759, _t821)
	var _t822 = J.add(J.gp(v_ag_754, "iconT"), v_dt_755)
	J.sp(v_ag_754, "iconT", _t822)
	if J.t(J.gp(v_ag_754, "fxTxt")):
		var _t823 = J.gp(v_ag_754, "fxTxt")
		var _t824 = J.add(J.gp(_t823, "t"), v_dt_755)
		J.sp(_t823, "t", _t824)
	v_hopper_757 = J.gp(env["HOPPER"], J.gp(v_ag_754, "k"))
	if J.seq(J.gp(v_ag_754, "st"), "go"):
		v_st_760 = J.gp(v_ag_754, "style")
		v_tx_761 = J.gp(v_ag_754, "tx")
		v_ty_762 = J.gp(v_ag_754, "ty")
		v_stopD_763 = 1.2
		if J.t(J.gp(v_st_760, "follow")):
			v_f_770 = J.gp(v_st_760, "follow")
			v_fd_771 = (1.0 if J.t(J.gp(v_f_770, "face")) else (-1.0))
			if J.t(J.gp(v_st_760, "chase")):
				v_tx_761 = J.gp(v_f_770, "x")
				v_ty_762 = J.gp(v_f_770, "y")
				v_stopD_763 = 0.0
			else:
				if J.t(J.gp(v_st_760, "side")):
					var _t825 = J.sub(J.gp(v_f_770, "x"), J.mul(v_fd_771, 8.0))
					v_tx_761 = _t825
					var _t826 = J.add(J.gp(v_f_770, "y"), 12.0)
					v_ty_762 = _t826
					v_stopD_763 = 3.0
				else:
					var _t827 = J.sub(J.gp(v_f_770, "x"), J.mul(v_fd_771, 24.0))
					v_tx_761 = _t827
					var _t828 = J.add(J.gp(v_f_770, "y"), 3.0)
					v_ty_762 = _t828
					v_stopD_763 = 4.0
		if J.t(J.gp(v_st_760, "seek")):
			v_f_772 = J.gp(v_st_760, "seek")
			var _t829 = J.gp(v_f_772, "lock")
			if J.t((_t829 if J.t(_t829) else J.cmp(J.gp(v_ag_754, "at"), 7.0, ">"))):
				var _t830 = env["next"]
				J.cl(_t830, null, [v_ag_754])
				return null
			var _t831 = J.add(J.gp(v_f_772, "x"), ((-20.0) if J.cmp(J.gp(v_ag_754, "x"), J.gp(v_f_772, "x"), "<") else 20.0))
			v_tx_761 = _t831
			v_ty_762 = J.gp(v_f_772, "y")
		var _t833 = J.gp(v_st_760, "seek")
		if not J.t(_t833):
			var _t832 = J.gp(v_st_760, "follow")
			_t833 = ((not J.t(J.gp(v_st_760, "chase"))) if J.t(_t832) else _t832)
		var _t835 = _t833
		if J.t(_t835):
			var _t834 = J.gp(v_st_760, "follow")
			_t835 = (not J.t((J.seq(J.gp(J.gp(v_st_760, "follow"), "act"), "plaza_hang") if J.t(_t834) else _t834)))
		if J.t(_t835):
			var _t836 = env["nearZ"]
			v_q_773 = J.cl(_t836, null, [v_tx_761, v_ty_762])
			v_tx_761 = J.gp(v_q_773, 0.0)
			v_ty_762 = J.gp(v_q_773, 1.0)
		v_dx_764 = J.sub(v_tx_761, J.gp(v_ag_754, "x"))
		v_dy_765 = J.sub(v_ty_762, J.gp(v_ag_754, "y"))
		v_d_766 = J.hypot_([v_dx_764, v_dy_765])
		var _t838 = J.gp(v_ag_754, "vmax")
		var _t837 = J.gp(v_st_760, "spd")
		v_vm_767 = J.mul(_t838, (_t837 if J.t(_t837) else 1.0))
		v_tsp_768 = (0.0 if J.cmp(v_d_766, v_stopD_763, "<=") else J.min_([v_vm_767, ((J.sub(v_d_766, v_stopD_763) * 2.4) + 2.0)]))
		var _t839 = J.gp(v_st_760, "follow")
		var _t840 = ((not J.t(J.gp(v_st_760, "chase"))) if J.t(_t839) else _t839)
		var _t842 = ((not J.t(J.gp(v_st_760, "keep"))) if J.t(_t840) else _t840)
		if J.t(_t842):
			var _t841 = J.cmp(J.gp(v_ag_754, "at"), 9.0, ">")
			_t842 = (_t841 if _t841 else (not J.seq(J.gp(J.gp(v_st_760, "follow"), "act"), "plaza_eat")))
		if J.t(_t842):
			var _t843 = env["next"]
			J.cl(_t843, null, [v_ag_754])
			return null
		var _t844 = J.add(J.gp(v_ag_754, "sp"), (J.sub(v_tsp_768, J.gp(v_ag_754, "sp")) * J.min_([1.0, J.mul(v_dt_755, (6.0 if J.cmp(v_tsp_768, J.gp(v_ag_754, "sp"), "<") else 3.5))])))
		J.sp(v_ag_754, "sp", _t844)
		v_mv_769 = J.mul(J.gp(v_ag_754, "sp"), v_dt_755)
		if J.t(v_hopper_757):
			if J.cmp(J.gp(v_ag_754, "hp"), 0.0, "<"):
				J.sp(v_ag_754, "hp", 0.0)
			var _t845 = J.cmp(J.gp(v_ag_754, "hp"), 0.22, ">=")
			v_air_774 = (J.cmp(J.gp(v_ag_754, "hp"), 0.9, "<=") if _t845 else _t845)
			var _t846 = (J.min_([v_d_766, J.div(J.mul(((1.0 if J.cmp(J.gp(v_ag_754, "sp"), 0.5, ">") else 0.0) * 13.0), v_dt_755), (0.68 * 0.62))]) if J.t(v_air_774) else 0.0)
			v_mv_769 = _t846
		if J.cmp(v_d_766, 0.01, ">"):
			v_nx_775 = J.add(J.gp(v_ag_754, "x"), (J.div(v_dx_764, v_d_766) * J.min_([v_mv_769, v_d_766])))
			v_ny_776 = J.add(J.gp(v_ag_754, "y"), (J.div(v_dy_765, v_d_766) * J.min_([v_mv_769, v_d_766])))
			var _t847 = env["nearZ"]
			v_z0_777 = J.cl(_t847, null, [J.gp(v_ag_754, "x"), J.gp(v_ag_754, "y")])
			var _t848 = env["nearZ"]
			v_z1_778 = J.cl(_t848, null, [v_tx_761, v_ty_762])
			var _t849 = (J.hypot_([J.sub(J.gp(v_z0_777, 0.0), J.gp(v_ag_754, "x")), J.sub(J.gp(v_z0_777, 1.0), J.gp(v_ag_754, "y"))]) < 0.5)
			if ((J.hypot_([J.sub(J.gp(v_z1_778, 0.0), v_tx_761), J.sub(J.gp(v_z1_778, 1.0), v_ty_762)]) < 0.5) if _t849 else _t849):
				var _t850 = env["nearZ"]
				v_q_779 = J.cl(_t850, null, [v_nx_775, v_ny_776])
				var _t851 = J.gp(v_q_779, 0.0)
				J.sp(v_ag_754, "x", _t851)
				var _t852 = J.gp(v_q_779, 1.0)
				J.sp(v_ag_754, "y", _t852)
			else:
				J.sp(v_ag_754, "x", v_nx_775)
				J.sp(v_ag_754, "y", v_ny_776)
		var _t853 = (absf(J.num(v_dx_764)) > 2.5)
		if (J.cmp(J.gp(v_ag_754, "sp"), 2.0, ">") if _t853 else _t853):
			var _t854 = J.cmp(v_dx_764, 0.0, ">")
			J.sp(v_ag_754, "want", _t854)
		var _t855 = (not J.t(J.gp(v_st_760, "follow")))
		if (J.cmp(v_d_766, 1.5, "<") if _t855 else _t855):
			var _t856 = (0.0 if J.t(v_hopper_757) else J.gp(v_ag_754, "sp"))
			J.sp(v_ag_754, "sp", _t856)
			var _t857 = env["next"]
			J.cl(_t857, null, [v_ag_754])
		var _t858 = J.gp(v_st_760, "follow")
		var _t859 = (J.gp(v_st_760, "side") if J.t(_t858) else _t858)
		if J.t(((not J.t(J.gp(J.gp(v_st_760, "follow"), "lock"))) if J.t(_t859) else _t859)):
			var _t860 = env["next"]
			J.cl(_t860, null, [v_ag_754])
	else:
		var _t861 = J.max_([0.0, J.sub(J.gp(v_ag_754, "sp"), (J.mul(v_dt_755, J.gp(v_ag_754, "vmax")) * 3.2))])
		J.sp(v_ag_754, "sp", _t861)
		var _t862 = J.seq(J.gp(v_ag_754, "st"), "act")
		if J.t((_t862 if _t862 else J.gp(v_ag_754, "cur"))):
			if J.cmp(J.gp(v_ag_754, "at"), J.gp(v_ag_754, "dur"), ">="):
				var _t863 = env["next"]
				J.cl(_t863, null, [v_ag_754])
		else:
			if J.cmp(J.gp(v_ag_754, "at"), J.gp(v_ag_754, "dur"), ">="):
				if J.t(J.len(J.gp(v_ag_754, "q"))):
					var _t864 = env["next"]
					J.cl(_t864, null, [v_ag_754])
				else:
					var _t865 = env["choose"]
					J.cl(_t865, null, [v_ag_754, v_W_756])
		if J.seq(J.gp(v_ag_754, "act"), "plaza_bump"):
			if (not J.seq(J.gp(v_ag_754, "_bkC"), J.gp(v_ag_754, "cur"))):
				var _t866 = J.gp(v_ag_754, "cur")
				J.sp(v_ag_754, "_bkC", _t866)
				J.sp(v_ag_754, "_bk", 0.0)
			var _t867 = env["eo"]
			var _t868 = env["seg"]
			v_k_780 = J.cl(_t867, null, [J.cl(_t868, null, [J.gp(v_ag_754, "at"), 0.1, 0.55])])
			var _t869 = J.gp(J.gp(v_ag_754, "pl"), "dir")
			v_dir_781 = (_t869 if J.t(_t869) else 1.0)
			var _t870 = J.sub(J.gp(v_ag_754, "x"), (J.mul(v_dir_781, 10.0) * J.sub(v_k_780, J.gp(v_ag_754, "_bk"))))
			J.sp(v_ag_754, "x", _t870)
			J.sp(v_ag_754, "_bk", v_k_780)
		var _t871 = J.seq(J.gp(v_ag_754, "act"), "plaza_look")
		var _t872 = (J.cmp(J.gp(v_ag_754, "at"), 0.75, ">") if _t871 else _t871)
		if ((not J.t(J.gp(v_ag_754, "_lk"))) if _t872 else _t872):
			J.sp(v_ag_754, "_lk", 1.0)
			if (not J.t(J.gp(v_ag_754, "lock"))):
				var _t873 = (not J.t(J.gp(v_ag_754, "face")))
				J.sp(v_ag_754, "want", _t873)
		if (not J.seq(J.gp(v_ag_754, "act"), "plaza_look")):
			J.sp(v_ag_754, "_lk", 0.0)
	if J.t(v_hopper_757):
		var _t874 = J.seq(J.gp(v_ag_754, "st"), "go")
		if (_t874 if _t874 else J.cmp(J.gp(v_ag_754, "hp"), 0.0, ">=")):
			var _t875 = J.add(J.gp(v_ag_754, "hp"), J.div(v_dt_755, 0.62))
			J.sp(v_ag_754, "hp", _t875)
			if J.cmp(J.gp(v_ag_754, "hp"), 1.0, ">="):
				var _t876 = (J.sub(J.gp(v_ag_754, "hp"), 1.0) if J.seq(J.gp(v_ag_754, "st"), "go") else (-1.0))
				J.sp(v_ag_754, "hp", _t876)
	var _t878 = null
	if J.t(v_hopper_757):
		_t878 = 0.0
	else:
		var _t877 = env["cl"]
		_t878 = J.cl(_t877, null, [J.div(J.gp(v_ag_754, "sp"), J.mul(J.gp(v_ag_754, "vmax"), 0.85))])
	J.sp(v_ag_754, "w", _t878)
	var _t879 = J.add(J.gp(v_ag_754, "wph"), (J.mul(v_dt_755, J.div(J.gp(v_ag_754, "sp"), J.gp(v_ag_754, "vmax"))) * (1.6 if J.t(J.gp(J.gp(v_ag_754, "style"), "run")) else (0.55 if J.t(J.gp(J.gp(v_ag_754, "style"), "sneak")) else 1.0))))
	J.sp(v_ag_754, "wph", _t879)
	var _t880 = J.seq(J.gp(v_ag_754, "act"), "plaza_eat")
	if J.t((_t880 if _t880 else J.gp(J.gp(v_ag_754, "style"), "eat"))):
		var _t881 = J.add(J.gp(v_ag_754, "eatT"), v_dt_755)
		J.sp(v_ag_754, "eatT", _t881)
	v_G_758 = J.gp(v_ag_754, "lock")
	if J.t((J.seq(J.gp(v_G_758, "kind"), "talk") if J.t(v_G_758) else v_G_758)):
		v_o_782 = (J.gp(v_G_758, "b") if J.seq(J.gp(v_G_758, "a"), v_ag_754) else J.gp(v_G_758, "a"))
		if (not J.seq(J.gp(v_ag_754, "st"), "go")):
			var _t882 = J.cmp(J.gp(v_o_782, "x"), J.gp(v_ag_754, "x"), ">")
			J.sp(v_ag_754, "want", _t882)
	var _t883 = (not J.seq(J.gp(v_ag_754, "want"), J.gp(v_ag_754, "face")))
	if (J.cmp(J.gp(v_ag_754, "turnT"), env["TURN"], ">=") if _t883 else _t883):
		J.sp(v_ag_754, "turnT", 0.0)
	if J.cmp(J.gp(v_ag_754, "turnT"), env["TURN"], "<"):
		var _t884 = J.add(J.gp(v_ag_754, "turnT"), v_dt_755)
		J.sp(v_ag_754, "turnT", _t884)
		var _t885 = J.cmp(J.gp(v_ag_754, "turnT"), J.div(env["TURN"], 2.0), ">=")
		if ((not J.t(J.gp(v_ag_754, "_flipped"))) if _t885 else _t885):
			var _t886 = J.gp(v_ag_754, "want")
			J.sp(v_ag_754, "face", _t886)
			J.sp(v_ag_754, "_flipped", 1.0)
		if J.cmp(J.gp(v_ag_754, "turnT"), env["TURN"], ">="):
			J.sp(v_ag_754, "_flipped", 0.0)
	if J.seq(J.gp(v_ag_754, "k"), "shuigui"):
		var _t887 = J.sub(J.gp(v_ag_754, "wetT"), v_dt_755)
		J.sp(v_ag_754, "wetT", _t887)
		if J.cmp(J.gp(v_ag_754, "wetT"), 0.0, "<="):
			var _t888 = (0.32 if J.cmp(J.gp(v_ag_754, "sp"), 3.0, ">") else (0.9 + J.mul(J.cl(env["R"], null, []), 0.6)))
			J.sp(v_ag_754, "wetT", _t888)
			var _t889 = J.gp(v_W_756, "wet")
			J.mc(_t889, "push", [{"x": J.add(J.gp(v_ag_754, "x"), (J.sub(J.cl(env["R"], null, []), 0.5) * 8.0)), "y": J.add(J.gp(v_ag_754, "y"), (J.sub(J.cl(env["R"], null, []), 0.5) * 3.0)), "t": 0.0, "life": (4.0 + J.mul(J.cl(env["R"], null, []), 2.0)), "r": (1.8 + J.mul(J.cl(env["R"], null, []), 1.6)), "d": 0.0}])

func _f117(this_, a: Array, env):
	var v_y_794 = null
	v_y_794 = J.arg(a, 0)
	var _t917 = env["__p"]["endSocial"]
	return J.cl(_t917, null, [null, v_y_794])

func _f116(this_, a: Array, env):
	var v_x_792 = null; var v_i_793 = null
	v_x_792 = J.arg(a, 0)
	v_i_793 = J.arg(a, 1)
	if J.seq(J.gp(v_x_792, "lock"), env["G"]):
		var _t916 = env["__p"]["setPlan"]
		J.cl(_t916, null, [v_x_792, [{"d": J.mul(v_i_793, 0.25)}, {"act": "plaza_bow", "d": 0.9, "p": {"deep": 0.45}}, {"fn": Callable(self, "_f117").bind(env)}]])

func _f115(this_, a: Array, env):
	var v_dt_786 = null; var v_a_787 = null; var v_b_788 = null; var v_on_789 = null; var v_pool_790 = null; var v_x_791 = null
	var _s280 = {"__p": env, "G": null}
	_s280["G"] = J.arg(a, 0)
	v_dt_786 = J.arg(a, 1)
	var _t890 = _s280["G"]
	var _t891 = J.gp(_t890, "a")
	v_a_787 = _t891
	var _t892 = J.gp(_t890, "b")
	v_b_788 = _t892
	var _t893 = _s280["G"]
	var _t894 = J.sub(J.gp(_t893, "sw"), v_dt_786)
	J.sp(_t893, "sw", _t894)
	var _t895 = J.seq(J.gp(v_a_787, "act"), "plaza_talk")
	var _t896 = (_t895 if _t895 else J.seq(J.gp(v_a_787, "act"), "plaza_argue"))
	var _t897 = (_t896 if _t896 else J.seq(J.gp(v_b_788, "act"), "plaza_talk"))
	v_on_789 = (_t897 if _t897 else J.seq(J.gp(v_b_788, "act"), "plaza_argue"))
	if J.t((J.cmp(J.gp(_s280["G"], "sw"), 0.0, "<=") if J.t(v_on_789) else v_on_789)):
		var _t898 = _s280["G"]
		var _t899 = ((v_b_788 if J.seq(J.gp(_s280["G"], "spk"), v_a_787) else v_a_787) if J.cmp(J.cl(_s280["__p"]["R"], null, []), 0.75, "<") else J.gp(_s280["G"], "spk"))
		J.sp(_t898, "spk", _t899)
		var _t900 = _s280["G"]
		var _t901 = ((0.6 + J.mul(J.cl(_s280["__p"]["R"], null, []), 0.9)) if J.t(J.gp(_s280["G"], "argue")) else (0.9 + J.mul(J.cl(_s280["__p"]["R"], null, []), 0.8)))
		J.sp(_t900, "sw", _t901)
		v_pool_790 = ((["…", "…", "!"] if J.seq(J.gp(J.gp(_s280["G"], "spk"), "k"), "heiwu") else ["!", "?", "!", "…"]) if J.t(J.gp(_s280["G"], "argue")) else ["…", "♪", "?", "!", "…"])
		var _t902 = J.gp(_s280["G"], "spk")
		var _t903 = J.gp(v_pool_790, floor(J.num(J.mul(J.cl(_s280["__p"]["R"], null, []), J.len(v_pool_790)))))
		J.sp(_t902, "icon", _t903)
		var _t904 = J.gp(_s280["G"], "spk")
		J.sp(_t904, "iconT", 0.0)
	for _t905 in J.iter([v_a_787, v_b_788]):
		v_x_791 = _t905
		var _t906 = J.seq(J.gp(v_x_791, "act"), "plaza_talk")
		if (_t906 if _t906 else J.seq(J.gp(v_x_791, "act"), "plaza_argue")):
			var _t907 = J.gp(v_x_791, "pl")
			var _t908 = J.seq(J.gp(_s280["G"], "spk"), v_x_791)
			J.sp(_t907, "spk", _t908)
	var _t909 = J.seq(J.gp(v_a_787, "act"), J.gp(_s280["G"], "act"))
	if (J.seq(J.gp(v_b_788, "act"), J.gp(_s280["G"], "act")) if _t909 else _t909):
		var _t910 = _s280["G"]
		var _t911 = J.add(J.gp(_t910, "t"), v_dt_786)
		J.sp(_t910, "t", _t911)
	var _t912 = J.cmp(J.gp(_s280["G"], "t"), J.gp(_s280["G"], "T"), ">=")
	var _t913 = (_t912 if _t912 else (not J.seq(J.gp(v_a_787, "lock"), _s280["G"])))
	if (_t913 if _t913 else (not J.seq(J.gp(v_b_788, "lock"), _s280["G"]))):
		var _t914 = _s280["G"]
		J.sp(_t914, "done", 1.0)
		var _t915 = [v_a_787, v_b_788]
		J.mc(_t915, "forEach", [Callable(self, "_f116").bind(_s280)])

func _f119(this_, a: Array, env):
	var v_G_804 = null
	v_G_804 = J.arg(a, 0)
	return (not J.t(J.gp(v_G_804, "done")))

func _f120(this_, a: Array, env):
	var v_G_805 = null
	v_G_805 = J.arg(a, 0)
	return J.seq(J.gp(v_G_805, "kind"), "talk")

func _f121(this_, a: Array, env):
	var v_o_819 = null
	v_o_819 = J.arg(a, 0)
	var _t960 = J.seq(J.gp(v_o_819, "st"), "idle")
	var _t961 = ((not J.t(J.gp(v_o_819, "lock"))) if _t960 else _t960)
	var _t962 = ((not J.t(J.len(J.gp(v_o_819, "q")))) if _t961 else _t961)
	var _t963 = (J.cmp(J.gp(J.gp(v_o_819, "cd"), "hero"), 0.0, "<=") if _t962 else _t962)
	return ((J.hypot_([J.sub(J.gp(v_o_819, "x"), J.gp(env["hero"], "x")), (J.sub(J.gp(v_o_819, "y"), J.gp(env["hero"], "y")) * 1.5)]) < 46.0) if _t963 else _t963)

func _f122(this_, a: Array, env):
	var v_w_822 = null
	v_w_822 = J.arg(a, 0)
	return J.cmp(J.gp(v_w_822, "t"), J.gp(v_w_822, "life"), "<")

func _f118(this_, a: Array, env):
	var v_W_797 = null; var v_dt_798 = null; var v_talks_800 = null; var v_maxTalk_801 = null; var v_ag_802 = null; var v_G_803 = null; var v_L_806 = null; var v_i_807 = null; var v_j_808 = null; var v_a_809 = null; var v_b_810 = null; var v_a_811 = null; var v_b_812 = null; var v_dx_813 = null; var v_dy_814 = null; var v_d_815 = null; var v_rr_816 = null; var v_k_817 = null; var v_c_818 = null; var v_o_820 = null; var v_w_821 = null
	var _s286 = {"__p": env, "hero": null}
	v_W_797 = J.arg(a, 0)
	v_dt_798 = J.arg(a, 1)
	_s286["hero"] = J.arg(a, 2)
	for _t918 in J.iter(J.gp(v_W_797, "list")):
		v_ag_802 = _t918
		var _t919 = _s286["__p"]["tick"]
		J.cl(_t919, null, [v_ag_802, v_dt_798, v_W_797])
	for _t920 in J.iter(J.gp(v_W_797, "games")):
		v_G_803 = _t920
		if J.t(J.gp(v_G_803, "done")):
			continue
		if J.seq(J.gp(v_G_803, "kind"), "tag"):
			var _t921 = _s286["__p"]["tagTick"]
			J.cl(_t921, null, [v_W_797, v_G_803, v_dt_798])
		else:
			if J.seq(J.gp(v_G_803, "kind"), "prank"):
				var _t922 = _s286["__p"]["prankTick"]
				J.cl(_t922, null, [v_W_797, v_G_803])
			else:
				if J.seq(J.gp(v_G_803, "kind"), "talk"):
					var _t923 = _s286["__p"]["talkTick"]
					J.cl(_t923, null, [v_G_803, v_dt_798])
				else:
					var _t924 = J.seq(J.gp(v_G_803, "kind"), "patrol")
					if ((not J.t(J.gp(J.gp(v_G_803, "a"), "lock"))) if _t924 else _t924):
						J.sp(v_G_803, "done", 1.0)
	var _t925 = J.gp(v_W_797, "games")
	var _t926 = J.mc(_t925, "filter", [Callable(self, "_f119").bind(_s286)])
	J.sp(v_W_797, "games", _t926)
	var _t927 = J.sub(J.gp(v_W_797, "socT"), v_dt_798)
	J.sp(v_W_797, "socT", _t927)
	var _t928 = J.gp(v_W_797, "games")
	v_talks_800 = J.len(J.mc(_t928, "filter", [Callable(self, "_f120").bind(_s286)]))
	v_maxTalk_801 = J.max_([1.0, J.round(J.num(J.div(J.len(J.gp(v_W_797, "list")), 7.0)))])
	var _t929 = J.cmp(J.gp(v_W_797, "socT"), 0.0, "<=")
	if (J.cmp(v_talks_800, v_maxTalk_801, "<") if _t929 else _t929):
		J.sp(v_W_797, "socT", 0.25)
		v_L_806 = J.gp(v_W_797, "list")
		v_i_807 = 0.0
		while true:
			if not J.cmp(v_i_807, J.len(v_L_806), "<"): break
			v_j_808 = J.add(v_i_807, 1.0)
			while true:
				if not J.cmp(v_j_808, J.len(v_L_806), "<"): break
				v_a_809 = J.gp(v_L_806, v_i_807)
				v_b_810 = J.gp(v_L_806, v_j_808)
				var _t930 = _s286["__p"]["isFree"]
				var _t932 = (not J.t(J.cl(_t930, null, [v_a_809])))
				if not J.t(_t932):
					var _t931 = _s286["__p"]["isFree"]
					_t932 = (not J.t(J.cl(_t931, null, [v_b_810])))
				var _t933 = (_t932 if _t932 else J.cmp(J.gp(J.gp(v_a_809, "cd"), "talk"), 0.0, ">"))
				if (_t933 if _t933 else J.cmp(J.gp(J.gp(v_b_810, "cd"), "talk"), 0.0, ">")):
					v_j_808 = J.num(v_j_808) + 1.0
					continue
				var _t937 = (J.hypot_([J.sub(J.gp(v_a_809, "x"), J.gp(v_b_810, "x")), (J.sub(J.gp(v_a_809, "y"), J.gp(v_b_810, "y")) * 1.6)]) < 30.0)
				if J.t(_t937):
					var _t934 = J.seq(J.gp(v_a_809, "st"), "go")
					var _t936 = (_t934 if _t934 else J.seq(J.gp(v_b_810, "st"), "go"))
					if not J.t(_t936):
						var _t935 = J.seq(J.gp(J.gp(v_a_809, "style"), "seek"), v_b_810)
						_t936 = (_t935 if _t935 else J.seq(J.gp(J.gp(v_b_810, "style"), "seek"), v_a_809))
					_t937 = _t936
				var _t940 = _t937
				if J.t(_t940):
					var _t938 = J.seq(J.gp(J.gp(v_a_809, "style"), "seek"), v_b_810)
					var _t939 = (_t938 if _t938 else J.seq(J.gp(J.gp(v_b_810, "style"), "seek"), v_a_809))
					_t940 = (_t939 if _t939 else J.cmp(J.cl(_s286["__p"]["R"], null, []), 0.12, "<"))
				if _t940:
					var _t941 = _s286["__p"]["startTalk"]
					var _t942 = J.seq(J.gp(v_a_809, "k"), "heiwu")
					var _t944 = (J.seq(J.gp(v_b_810, "k"), "baiwu") if _t942 else _t942)
					if not J.t(_t944):
						var _t943 = J.seq(J.gp(v_a_809, "k"), "baiwu")
						_t944 = (J.seq(J.gp(v_b_810, "k"), "heiwu") if _t943 else _t943)
					J.cl(_t941, null, [v_W_797, v_a_809, v_b_810, _t944])
					v_i_807 = J.len(v_L_806)
					break
				v_j_808 = J.num(v_j_808) + 1.0
			v_i_807 = J.num(v_i_807) + 1.0
	for _t945 in J.iter(J.gp(v_W_797, "list")):
		v_a_811 = _t945
		for _t946 in J.iter(J.gp(v_W_797, "list")):
			v_b_812 = _t946
			var _t947 = J.seq(v_a_811, v_b_812)
			var _t948 = (_t947 if _t947 else J.seq(J.gp(v_a_811, "st"), "go"))
			var _t951 = (_t948 if _t948 else J.seq(J.gp(v_a_811, "act"), "plaza_hang"))
			if not J.t(_t951):
				var _t949 = J.gp(v_a_811, "lock")
				var _t950 = (J.seq(J.gp(v_a_811, "lock"), J.gp(v_b_812, "lock")) if J.t(_t949) else _t949)
				_t951 = ((not J.seq(J.gp(J.gp(v_a_811, "lock"), "kind"), "talk")) if J.t(_t950) else _t950)
			if J.t(_t951):
				continue
			v_dx_813 = J.sub(J.gp(v_a_811, "x"), J.gp(v_b_812, "x"))
			v_dy_814 = (J.sub(J.gp(v_a_811, "y"), J.gp(v_b_812, "y")) * 1.8)
			v_d_815 = J.hypot_([v_dx_813, v_dy_814])
			var _t952 = J.gp(v_a_811, "lock")
			v_rr_816 = (15.0 if J.t((J.seq(J.gp(v_a_811, "lock"), J.gp(v_b_812, "lock")) if J.t(_t952) else _t952)) else 19.0)
			var _t953 = J.cmp(v_d_815, v_rr_816, ">")
			if (_t953 if _t953 else J.cmp(v_d_815, 0.01, "<")):
				continue
			v_k_817 = (J.mul(J.sub(v_rr_816, v_d_815), v_dt_798) * 1.2)
			var _t954 = J.add(J.gp(v_a_811, "x"), J.mul(J.div(v_dx_813, v_d_815), v_k_817))
			J.sp(v_a_811, "x", _t954)
			var _t955 = J.add(J.gp(v_a_811, "y"), (J.mul(J.div(v_dy_814, v_d_815), v_k_817) * 0.4))
			J.sp(v_a_811, "y", _t955)
			var _t956 = _s286["__p"]["clampZ"]
			J.cl(_t956, null, [v_a_811])
	var _t957 = J.sub(J.gp(v_W_797, "heroT"), v_dt_798)
	J.sp(v_W_797, "heroT", _t957)
	var _t958 = (J.gp(_s286["hero"], "walking") if J.t(_s286["hero"]) else _s286["hero"])
	if J.t((J.cmp(J.gp(v_W_797, "heroT"), 0.0, "<=") if J.t(_t958) else _t958)):
		var _t959 = J.gp(v_W_797, "list")
		v_c_818 = J.mc(_t959, "filter", [Callable(self, "_f121").bind(_s286)])
		if J.t(J.len(v_c_818)):
			v_o_820 = J.gp(v_c_818, floor(J.num(J.mul(J.cl(_s286["__p"]["R"], null, []), J.len(v_c_818)))))
			var _t964 = J.gp(v_o_820, "cd")
			var _t965 = (25.0 + J.mul(J.cl(_s286["__p"]["R"], null, []), 20.0))
			J.sp(_t964, "hero", _t965)
			J.sp(v_W_797, "heroT", 4.0)
			var _t966 = _s286["__p"]["setPlan"]
			J.cl(_t966, null, [v_o_820, [{"act": ("plaza_wave" if J.cmp(J.cl(_s286["__p"]["R"], null, []), 0.7, "<") else "plaza_bow"), "d": 1.4, "face": _s286["hero"], "p": {"deep": 0.6}}]])
	for _t967 in J.iter(J.gp(v_W_797, "wet")):
		v_w_821 = _t967
		var _t968 = J.add(J.gp(v_w_821, "t"), v_dt_798)
		J.sp(v_w_821, "t", _t968)
	var _t969 = J.gp(v_W_797, "wet")
	var _t970 = J.mc(_t969, "filter", [Callable(self, "_f122").bind(_s286)])
	J.sp(v_W_797, "wet", _t970)

func _f123(this_, a: Array, env):
	var v_ag_825 = null
	v_ag_825 = J.arg(a, 0)
	var _t972 = J.gp(v_ag_825, "y")
	var _t971 = J.gp(env["CH"], J.gp(v_ag_825, "k"))
	return (J.sub(_t972, J.mul((_t971 if J.t(_t971) else 50.0), env["SC"])) - (0.0 if J.t(J.gp(env["SOLID"], J.gp(v_ag_825, "k"))) else 4.0))

func _f124(this_, a: Array, env):
	var v_ctx_828 = null; var v_ag_829 = null; var v_t_830 = null; var v_opt_831 = null; var v_k_832 = null; var v_T_833 = null; var v_tk_834 = null; var v_act_835 = null; var v_hy_836 = null; var v_s_837 = null; var v_fwd_838 = null; var v_o_839 = null; var v_H_840 = null; var v_p_841 = null; var v_k2_842 = null
	v_ctx_828 = J.arg(a, 0)
	v_ag_829 = J.arg(a, 1)
	v_t_830 = J.arg(a, 2)
	v_opt_831 = J.arg(a, 3)
	v_k_832 = J.gp(v_ag_829, "k")
	v_T_833 = J.add(v_t_830, J.gp(v_ag_829, "seed"))
	v_tk_834 = (J.max_([0.08, absf(J.num(cos(J.num(J.div(J.mul(env["PI"], J.gp(v_ag_829, "turnT")), env["TURN"])))))]) if J.cmp(J.gp(v_ag_829, "turnT"), env["TURN"], "<") else 1.0)
	J.mc(v_ctx_828, "save", [])
	J.mc(v_ctx_828, "translate", [J.gp(v_ag_829, "x"), 0.0])
	J.mc(v_ctx_828, "scale", [v_tk_834, 1.0])
	J.mc(v_ctx_828, "translate", [(-J.num(J.gp(v_ag_829, "x"))), 0.0])
	var _t973 = J.gp(v_ag_829, "act")
	v_act_835 = (_t973 if J.t(_t973) else ("plaza_eat" if J.t(J.gp(J.gp(v_ag_829, "style"), "eat")) else "plaza_walk"))
	J.sp(v_ag_829, "_z", 0.0)
	J.sp(v_ag_829, "_stars", 0.0)
	var _t975 = J.mc(J.G.get("MeshAnim"), "has", [v_k_832])
	if J.t(_t975):
		var _t974 = (not J.seq(J.typeof_(J.G.get("SPECIAL")), "undefined"))
		_t975 = (not J.t((J.mc(J.G.get("SPECIAL"), "has", [v_k_832]) if _t974 else _t974)))
	if J.t(_t975):
		var _t978 = (J.gp(v_ag_829, "eatT") if J.seq(v_act_835, "plaza_eat") else J.gp(v_ag_829, "at"))
		var _t979 = J.gp(v_ag_829, "w")
		var _t980 = J.gp(v_ag_829, "wph")
		var _t981 = J.gp(v_ag_829, "hp")
		var _t977 = null
		if J.t(J.gp(J.gp(v_ag_829, "style"), "run")):
			var _t976 = env["cl"]
			_t977 = J.cl(_t976, null, [J.gp(v_ag_829, "w")])
		else:
			_t977 = 0.0
		v_o_839 = {"t": v_T_833, "act": v_act_835, "at": _t978, "w": _t979, "wph": _t980, "hp": _t981, "run": _t977, "sniff": J.gp(J.gp(v_ag_829, "style"), "sniff"), "sneak": J.gp(J.gp(v_ag_829, "style"), "sneak"), "stiff": J.gp(J.gp(v_ag_829, "style"), "stiff"), "pl": J.gp(v_ag_829, "pl"), "flip": (not J.t(J.gp(v_ag_829, "face"))), "tamed": true, "untied": true}
		J.mc(J.G.get("ART"), "drawChar", [v_ctx_828, v_k_832, J.gp(v_ag_829, "x"), J.gp(v_ag_829, "y"), env["SC"], v_o_839])
		var _t982 = J.gp(v_o_839, "_z")
		var _t983 = (_t982 if J.t(_t982) else 0.0)
		J.sp(v_ag_829, "_z", _t983)
		var _t984 = J.gp(v_o_839, "_stars")
		var _t985 = (_t984 if J.t(_t984) else 0.0)
		J.sp(v_ag_829, "_stars", _t985)
		var _t986 = J.gp(v_o_839, "_zpos")
		J.sp(v_ag_829, "_zpos", _t986)
	else:
		var _t987 = env["drawSpecial"]
		J.cl(_t987, null, [v_ctx_828, v_ag_829, v_T_833])
	J.mc(v_ctx_828, "restore", [])
	var _t988 = env["headY"]
	v_hy_836 = J.cl(_t988, null, [v_ag_829])
	v_s_837 = env["SC"]
	v_fwd_838 = (1.0 if J.t(J.gp(v_ag_829, "face")) else (-1.0))
	if J.cmp(J.gp(v_ag_829, "_z"), 0.05, ">"):
		var _t989 = J.gp(env["CH"], v_k_832)
		v_H_840 = J.mul((_t989 if J.t(_t989) else 50.0), env["SC"])
		var _t993 = J.gp(v_ag_829, "_zpos")
		if not J.t(_t993):
			var _t992 = J.add(J.gp(v_ag_829, "x"), J.mul(v_fwd_838, 9.0))
			var _t991 = J.gp(v_ag_829, "y")
			var _t990 = J.gp(env["FACEV"], v_k_832)
			_t993 = [_t992, (J.sub(_t991, J.mul(v_H_840, J.sub(1.0, (_t990 if J.t(_t990) else 0.3)))) - (2.0 if J.t(J.gp(env["SOLID"], v_k_832)) else 6.0))]
		v_p_841 = _t993
		var _t994 = env["zzz"]
		J.cl(_t994, null, [v_ctx_828, J.gp(v_p_841, 0.0), J.gp(v_p_841, 1.0), v_T_833, v_s_837, J.gp(v_ag_829, "_z")])
	if J.cmp(J.gp(v_ag_829, "_stars"), 0.0, ">"):
		var _t995 = env["stars"]
		J.cl(_t995, null, [v_ctx_828, J.gp(v_ag_829, "x"), J.add(v_hy_836, 2.0), v_T_833, v_s_837, J.gp(v_ag_829, "_stars")])
	var _t996 = J.gp(v_ag_829, "icon")
	var _t997 = (J.cmp(J.gp(v_ag_829, "iconT"), 1.25, "<") if J.t(_t996) else _t996)
	if J.t(((not J.t((J.gp(v_opt_831, "noIcon") if J.t(v_opt_831) else v_opt_831))) if J.t(_t997) else _t997)):
		v_k2_842 = J.min_([1.0, J.mul(J.gp(v_ag_829, "iconT"), 6.0), (J.sub(1.25, J.gp(v_ag_829, "iconT")) * 5.0)])
		var _t998 = env["bubble"]
		J.cl(_t998, null, [v_ctx_828, J.add(J.gp(v_ag_829, "x"), J.mul(v_fwd_838, 7.0)), (J.sub(v_hy_836, 7.0) - (sin(J.num(J.mul(J.min_([1.0, J.mul(J.gp(v_ag_829, "iconT"), 3.0)]), env["PI"]))) * 2.0)), J.gp(v_ag_829, "icon"), v_s_837, v_k2_842])
	var _t999 = J.gp(v_ag_829, "fxTxt")
	if J.t((J.cmp(J.gp(J.gp(v_ag_829, "fxTxt"), "t"), 1.0, "<") if J.t(_t999) else _t999)):
		var _t1000 = env["txt"]
		J.cl(_t1000, null, [v_ctx_828, J.gp(v_ag_829, "x"), (J.sub(v_hy_836, 6.0) - J.mul(J.gp(J.gp(v_ag_829, "fxTxt"), "t"), 8.0)), J.gp(J.gp(v_ag_829, "fxTxt"), "s"), (J.mul(10.0, v_s_837) * 1.4), "#ffe9a8", J.min_([1.0, (J.sub(1.0, J.gp(J.gp(v_ag_829, "fxTxt"), "t")) * 3.0)]), 0.2])

func _f125(this_, a: Array, env):
	var v_ctx_845 = null; var v_w_846 = null; var v_k_847 = null; var v_g_848 = null
	v_ctx_845 = J.arg(a, 0)
	v_w_846 = J.arg(a, 1)
	v_k_847 = (1.0 - J.div(J.gp(v_w_846, "t"), J.gp(v_w_846, "life")))
	v_g_848 = J.min_([1.0, J.mul(J.gp(v_w_846, "t"), 6.0)])
	J.mc(v_ctx_845, "save", [])
	var _t1001 = J.mul(J.gp(v_ctx_845, "globalAlpha"), J.mul(0.5, v_k_847))
	J.sp(v_ctx_845, "globalAlpha", _t1001)
	J.sp(v_ctx_845, "fillStyle", "#1d3440")
	J.mc(v_ctx_845, "beginPath", [])
	J.mc(v_ctx_845, "ellipse", [J.gp(v_w_846, "x"), J.gp(v_w_846, "y"), J.mul(J.gp(v_w_846, "r"), (0.6 + J.mul(0.4, v_g_848))), (J.mul(J.gp(v_w_846, "r"), 0.42) * (0.6 + J.mul(0.4, v_g_848))), 0.0, 0.0, env["TAU"]])
	J.mc(v_ctx_845, "fill", [])
	var _t1002 = J.mul(J.gp(v_ctx_845, "globalAlpha"), 0.8)
	J.sp(v_ctx_845, "globalAlpha", _t1002)
	J.sp(v_ctx_845, "fillStyle", "#6fa6bd")
	J.mc(v_ctx_845, "beginPath", [])
	J.mc(v_ctx_845, "ellipse", [J.sub(J.gp(v_w_846, "x"), J.mul(J.gp(v_w_846, "r"), 0.25)), J.sub(J.gp(v_w_846, "y"), J.mul(J.gp(v_w_846, "r"), 0.1)), J.mul(J.gp(v_w_846, "r"), 0.3), J.mul(J.gp(v_w_846, "r"), 0.1), 0.0, 0.0, env["TAU"]])
	J.mc(v_ctx_845, "fill", [])
	if J.cmp(J.gp(v_w_846, "t"), 0.35, "<"):
		var _t1003 = (0.7 * (1.0 - J.div(J.gp(v_w_846, "t"), 0.35)))
		J.sp(v_ctx_845, "globalAlpha", _t1003)
		J.sp(v_ctx_845, "strokeStyle", "#9fd0e6")
		J.sp(v_ctx_845, "lineWidth", 0.6)
		J.mc(v_ctx_845, "beginPath", [])
		J.mc(v_ctx_845, "ellipse", [J.gp(v_w_846, "x"), J.gp(v_w_846, "y"), J.mul(J.gp(v_w_846, "r"), (1.0 + J.mul(J.gp(v_w_846, "t"), 6.0))), (J.mul(J.gp(v_w_846, "r"), 0.42) * (1.0 + J.mul(J.gp(v_w_846, "t"), 6.0))), 0.0, 0.0, env["TAU"]])
		J.mc(v_ctx_845, "stroke", [])
	J.mc(v_ctx_845, "restore", [])

func _f126(this_, a: Array, env):
	var v_ctx_851 = null; var v_ag_852 = null; var v_t_853 = null; var v_H_854 = null; var v_i_855 = null; var v_ph_856 = null; var v_x_857 = null; var v_y0_858 = null
	v_ctx_851 = J.arg(a, 0)
	v_ag_852 = J.arg(a, 1)
	v_t_853 = J.arg(a, 2)
	v_H_854 = J.mul(J.gp(env["CH"], "shuigui"), env["SC"])
	v_i_855 = 0.0
	while true:
		if not J.cmp(v_i_855, 3.0, "<"): break
		v_ph_856 = J.mod(J.add((J.mul(v_t_853, 0.9) + J.mul(v_i_855, 0.37)), J.gp(v_ag_852, "seed")), 1.0)
		var _t1005 = J.gp(v_ag_852, "x")
		var _t1004 = env["hash"]
		v_x_857 = J.add(_t1005, (J.mul(J.sub(J.cl(_t1004, null, [J.add(v_i_855, floor(J.num(J.add((J.mul(v_t_853, 0.9) + J.mul(v_i_855, 0.37)), J.gp(v_ag_852, "seed")))))]), 0.5), v_H_854) * 0.5))
		var _t1007 = J.gp(v_ag_852, "y")
		var _t1006 = env["hash"]
		v_y0_858 = J.sub(_t1007, J.mul(v_H_854, (0.35 + J.mul(0.2, J.cl(_t1006, null, [J.mul(v_i_855, 3.0)])))))
		var _t1008 = env["drop"]
		var _t1010 = J.sub(J.gp(v_ag_852, "y"), v_y0_858)
		var _t1009 = env["ei"]
		var _t1012 = J.add(v_y0_858, J.mul(_t1010, J.cl(_t1009, null, [v_ph_856])))
		var _t1011 = env["seg"]
		J.cl(_t1008, null, [v_ctx_851, v_x_857, _t1012, 1.1, (0.8 * J.sub(1.0, J.cl(_t1011, null, [v_ph_856, 0.85, 1.0])))])
		v_i_855 = J.num(v_i_855) + 1.0

func _f127(this_, a: Array, env):
	return {"list": [], "games": [], "wet": [], "socT": 1.0, "heroT": 2.0, "last": null, "bld": {"wood": 1.0}}

func _f129(this_, a: Array, env):
	var v_g_873 = null
	v_g_873 = J.arg(a, 0)
	return J.gp(v_g_873, "id")

func _f130(this_, a: Array, env):
	var v_a_874 = null; var v_G_875 = null; var v_o_876 = null
	v_a_874 = J.arg(a, 0)
	if J.t(J.mc(env["ids"], "has", [J.gp(v_a_874, "id")])):
		return true
	for _t1025 in J.iter(J.gp(env["W"], "games")):
		v_G_875 = _t1025
		var _t1026 = J.seq(J.gp(v_G_875, "a"), v_a_874)
		var _t1027 = (_t1026 if _t1026 else J.seq(J.gp(v_G_875, "b"), v_a_874))
		var _t1028 = (_t1027 if _t1027 else J.seq(J.gp(v_G_875, "ch"), v_a_874))
		var _t1029 = (_t1028 if _t1028 else J.seq(J.gp(v_G_875, "ru"), v_a_874))
		var _t1030 = (_t1029 if _t1029 else J.seq(J.gp(v_G_875, "x"), v_a_874))
		if (_t1030 if _t1030 else J.seq(J.gp(v_G_875, "v"), v_a_874)):
			J.sp(v_G_875, "done", 1.0)
			for _t1031 in J.iter([J.gp(v_G_875, "a"), J.gp(v_G_875, "b"), J.gp(v_G_875, "ch"), J.gp(v_G_875, "ru"), J.gp(v_G_875, "x"), J.gp(v_G_875, "v")]):
				v_o_876 = _t1031
				if J.t(((not J.seq(v_o_876, v_a_874)) if J.t(v_o_876) else v_o_876)):
					J.sp(v_o_876, "lock", null)
					var _t1032 = []
					J.sp(v_o_876, "q", _t1032)
					J.sp(v_o_876, "cur", null)
					J.sp(v_o_876, "st", "idle")
					J.sp(v_o_876, "act", null)
					J.sp(v_o_876, "at", 0.0)
					J.sp(v_o_876, "dur", 0.5)
					var _t1033 = {}
					J.sp(v_o_876, "style", _t1033)
	return false

func _f131(this_, a: Array, env):
	var v_a_877 = null
	v_a_877 = J.arg(a, 0)
	return J.gp(v_a_877, "id")

func _f132(this_, a: Array, env):
	var v_g_878 = null; var v_i_879 = null
	v_g_878 = J.arg(a, 0)
	v_i_879 = J.arg(a, 1)
	if (not J.t(J.mc(env["have"], "has", [J.gp(v_g_878, "id")]))):
		var _t1036 = J.gp(env["W"], "list")
		var _t1037 = env["__p"]["mkAgent"]
		J.mc(_t1036, "push", [J.cl(_t1037, null, [v_g_878, J.len(J.gp(env["W"], "list")), env["W"]])])

func _f133(this_, a: Array, env):
	var v_g_881 = null
	v_g_881 = J.arg(a, 0)
	return J.seq(J.gp(v_g_881, "id"), J.gp(env["a"], "id"))

func _f134(this_, a: Array, env):
	var _t1044 = env["__p"]["__p"]["drawWet"]
	return J.cl(_t1044, null, [env["__p"]["ctx"], env["w"]])

func _f135(this_, a: Array, env):
	var _t1048 = env["__p"]["__p"]["__p"]["drawAgent"]
	J.cl(_t1048, null, [env["__p"]["__p"]["ctx"], env["__p"]["ag"], env["__p"]["__p"]["t"], {"noIcon": env["mute"]}])
	if J.seq(J.gp(env["__p"]["ag"], "k"), "shuigui"):
		var _t1049 = env["__p"]["__p"]["__p"]["drawDrips"]
		J.cl(_t1049, null, [env["__p"]["__p"]["ctx"], env["__p"]["ag"], J.add(env["__p"]["__p"]["t"], J.gp(env["__p"]["ag"], "seed"))])

func _f128(this_, a: Array, env):
	var v_V_863 = null; var v_ghosts_864 = null; var v_items_865 = null; var v_vis_866 = null; var v_dt_870 = null
	var _s316 = {"__p": env, "ctx": null, "t": null, "W": null, "ids": null, "have": null}
	v_V_863 = J.arg(a, 0)
	v_ghosts_864 = J.arg(a, 1)
	v_items_865 = J.arg(a, 2)
	v_vis_866 = J.arg(a, 3)
	_s316["ctx"] = J.arg(a, 4)
	_s316["t"] = J.arg(a, 5)
	var _t1014 = J.gp(v_V_863, "plaza")
	if not J.t(_t1014):
		var _t1013 = J.cl(_s316["__p"]["newWorld"], null, [])
		J.sp(v_V_863, "plaza", _t1013)
		_t1014 = _t1013
	_s316["W"] = _t1014
	v_dt_870 = (0.0 if J.leq(J.gp(_s316["W"], "last"), null) else J.sub(_s316["t"], J.gp(_s316["W"], "last")))
	var _t1015 = _s316["W"]
	var _t1016 = _s316["t"]
	J.sp(_t1015, "last", _t1016)
	var _t1017 = _s316["__p"]["cl"]
	var _t1018 = J.cl(_t1017, null, [v_dt_870, 0.0, 0.1])
	v_dt_870 = _t1018
	var _t1019 = _s316["W"]
	var _t1020 = (not J.seq(J.typeof_(J.G.get("S")), "undefined"))
	var _t1021 = (J.gp(J.G.get("S"), "bld") if _t1020 else _t1020)
	var _t1022 = (_t1021 if J.t(_t1021) else J.gp(_s316["W"], "bld"))
	J.sp(_t1019, "bld", _t1022)
	_s316["ids"] = J.new_("Set", [J.mc(v_ghosts_864, "map", [Callable(self, "_f129").bind(_s316)])])
	var _t1023 = _s316["W"]
	var _t1024 = J.gp(_s316["W"], "list")
	var _t1034 = J.mc(_t1024, "filter", [Callable(self, "_f130").bind(_s316)])
	J.sp(_t1023, "list", _t1034)
	var _t1035 = J.gp(_s316["W"], "list")
	_s316["have"] = J.new_("Set", [J.mc(_t1035, "map", [Callable(self, "_f131").bind(_s316)])])
	J.mc(v_ghosts_864, "forEach", [Callable(self, "_f132").bind(_s316)])
	for _t1038 in J.iter(J.gp(_s316["W"], "list")):
		var _s325 = {"__p": _s316, "a": null}
		_s325["a"] = _t1038
		var _t1039 = _s325["a"]
		var _t1040 = J.mc(v_ghosts_864, "find", [Callable(self, "_f133").bind(_s325)])
		var _t1041 = (_t1040 if J.t(_t1040) else J.gp(_s325["a"], "g"))
		J.sp(_t1039, "g", _t1041)
	var _t1042 = _s316["__p"]["update"]
	J.cl(_t1042, null, [_s316["W"], v_dt_870, J.gp(v_V_863, "hero")])
	for _t1043 in J.iter(J.gp(_s316["W"], "wet")):
		var _s327 = {"__p": _s316, "w": null}
		_s327["w"] = _t1043
		J.mc(v_items_865, "push", [{"y": J.sub(J.gp(_s327["w"], "y"), 40.0), "f": Callable(self, "_f134").bind(_s327)}])
	for _t1045 in J.iter(J.gp(_s316["W"], "list")):
		var _s329 = {"__p": _s316, "ag": null}
		_s329["ag"] = _t1045
		var _s330 = {"__p": _s329, "mute": null}
		J.mc(v_vis_866, "push", [{"g": J.gp(_s330["__p"]["ag"], "g"), "x": J.gp(_s330["__p"]["ag"], "x"), "y": J.gp(_s330["__p"]["ag"], "y")}])
		var _t1046 = J.gp(v_V_863, "bubble")
		var _t1047 = (J.seq(J.gp(J.gp(v_V_863, "bubble"), "id"), J.gp(J.gp(_s330["__p"]["ag"], "g"), "id")) if J.t(_t1046) else _t1046)
		_s330["mute"] = ((not J.t(J.gp(J.gp(v_V_863, "bubble"), "hero"))) if J.t(_t1047) else _t1047)
		J.mc(v_items_865, "push", [{"y": J.gp(_s330["__p"]["ag"], "y"), "f": Callable(self, "_f135").bind(_s330)}])

func _f2(this_, a: Array, env):
	var v_v_85 = null; var v_a_86 = null; var v_b_87 = null
	v_v_85 = J.arg(a, 0)
	var _t1050 = J.arg(a, 1)
	if _t1050 == null:
		_t1050 = 0.0
	v_a_86 = _t1050
	var _t1051 = J.arg(a, 2)
	if _t1051 == null:
		_t1051 = 1.0
	v_b_87 = _t1051
	return (v_a_86 if J.cmp(v_v_85, v_a_86, "<") else (v_b_87 if J.cmp(v_v_85, v_b_87, ">") else v_v_85))

func _f3(this_, a: Array, env):
	var v_a_88 = null; var v_b_89 = null; var v_k_90 = null
	v_a_88 = J.arg(a, 0)
	v_b_89 = J.arg(a, 1)
	v_k_90 = J.arg(a, 2)
	return J.add(v_a_88, J.mul(J.sub(v_b_89, v_a_88), v_k_90))

func _f4(this_, a: Array, env):
	var v_t_91 = null
	v_t_91 = J.arg(a, 0)
	return (1.0 - (J.sub(1.0, v_t_91) * J.sub(1.0, v_t_91)))

func _f5(this_, a: Array, env):
	var v_t_92 = null
	v_t_92 = J.arg(a, 0)
	return J.mul(v_t_92, v_t_92)

func _f6(this_, a: Array, env):
	var v_t_93 = null
	v_t_93 = J.arg(a, 0)
	return (J.mul(J.mul(2.0, v_t_93), v_t_93) if J.cmp(v_t_93, 0.5, "<") else (1.0 - ((2.0 * J.sub(1.0, v_t_93)) * J.sub(1.0, v_t_93))))

func _f7(this_, a: Array, env):
	var v_t_94 = null
	v_t_94 = J.arg(a, 0)
	return (1.0 - pow(J.num(J.sub(1.0, v_t_94)), J.num(3.0)))

func _f8(this_, a: Array, env):
	var v_g_95 = null; var v_a_96 = null; var v_b_97 = null
	v_g_95 = J.arg(a, 0)
	v_a_96 = J.arg(a, 1)
	v_b_97 = J.arg(a, 2)
	var _t1052 = env["cl"]
	return J.cl(_t1052, null, [J.div(J.sub(v_g_95, v_a_96), J.sub(v_b_97, v_a_96))])

func _f9(this_, a: Array, env):
	var v_g_98 = null; var v_a_99 = null; var v_b_100 = null; var v_c_101 = null; var v_d_102 = null
	v_g_98 = J.arg(a, 0)
	v_a_99 = J.arg(a, 1)
	v_b_100 = J.arg(a, 2)
	v_c_101 = J.arg(a, 3)
	v_d_102 = J.arg(a, 4)
	var _t1053 = env["eio"]
	var _t1054 = env["seg"]
	var _t1057 = J.cl(_t1053, null, [J.cl(_t1054, null, [v_g_98, v_a_99, v_b_100])])
	var _t1055 = env["eio"]
	var _t1056 = env["seg"]
	return J.mul(_t1057, J.sub(1.0, J.cl(_t1055, null, [J.cl(_t1056, null, [v_g_98, v_c_101, v_d_102])])))

func _f10(this_, a: Array, env):
	var v_i_103 = null; var v_v_104 = null
	v_i_103 = J.arg(a, 0)
	v_v_104 = (sin(J.num((J.mul(v_i_103, 127.1) + 311.7))) * 43758.5453)
	return J.sub(v_v_104, floor(J.num(v_v_104)))

func _f11(this_, a: Array, env):
	var v_k_105 = null
	v_k_105 = J.arg(a, 0)
	var _t1059 = J.seq(J.typeof_(J.G.get("sprOk")), "function")
	if J.t(_t1059):
		var _t1058 = J.G.get("sprOk")
		_t1059 = J.cl(_t1058, null, [v_k_105])
	return _t1059

func _f14(this_, a: Array, env):
	var v_a_124 = null
	v_a_124 = J.arg(a, 0)
	var _t1061 = null
	if J.t(J.gp(v_a_124, "solid")):
		_t1061 = 0.0
	else:
		var _t1060 = J.gp(J.gp(v_a_124, "o"), "t")
		_t1061 = (J.mul((3.0 + (sin(J.num(J.mul((_t1060 if J.t(_t1060) else 0.0), 2.4))) * 2.0)), J.gp(v_a_124, "s")) * (0.25 if J.t(J.gp(J.gp(v_a_124, "o"), "sit")) else 1.0))
	return _t1061

func _f47(this_, a: Array, env):
	var v_n_515 = null
	v_n_515 = J.arg(a, 0)
	var _t1062 = J.G.get("DAILY")
	var _t1063 = J.add("plaza_", v_n_515)
	var _t1064 = env["body"]
	J.sp(_t1062, _t1063, _t1064)

func _f53(this_, a: Array, env):
	var v_x_579 = null
	v_x_579 = J.arg(a, 0)
	var _t1065 = J.cmp(v_x_579, J.sub(J.gp(env["ZA"], 0.0), 2.0), "<")
	return (_t1065 if _t1065 else J.cmp(v_x_579, J.add(J.gp(env["ZA"], 1.0), 2.0), ">"))

func _f57(this_, a: Array, env):
	var v_ag_610 = null
	v_ag_610 = J.arg(a, 0)
	var _t1068 = (not J.t(J.gp(v_ag_610, "lock")))
	if J.t(_t1068):
		var _t1067 = J.seq(J.gp(v_ag_610, "st"), "idle")
		if not J.t(_t1067):
			var _t1066 = J.seq(J.gp(v_ag_610, "st"), "go")
			_t1067 = ((not J.t(J.gp(J.gp(v_ag_610, "style"), "purpose"))) if _t1066 else _t1066)
		_t1068 = _t1067
	return _t1068

func _f63(this_, a: Array, env):
	var v_h_633 = null
	v_h_633 = J.mc(J.new_("Date", []), "getHours", [])
	var _t1069 = J.cmp(v_h_633, 22.0, ">=")
	return (_t1069 if _t1069 else J.cmp(v_h_633, 6.0, "<"))

func _f1(this_, a: Array, env):
	var v_NAMES_46 = null; var v_frame_84 = null
	var _s2 = {"__p": env, "PI": null, "TAU": null, "D": null, "cl": null, "lerp": null, "eo": null, "ei": null, "eio": null, "eo3": null, "seg": null, "env": null, "hash": null, "ok": null, "R": null, "HOPPER": null, "PAPER": null, "SOLID": null, "CH": null, "FACEV": null, "SC": null, "basePose": null, "add": null, "floatY": null, "shadowAt": null, "drawM": null, "npt": null, "crayon": null, "steam": null, "txt": null, "zzz": null, "star": null, "stars": null, "bubble": null, "crumbs": null, "drop": null, "dustPuff": null, "sniffLines": null, "hopPose": null, "body": null, "bump3": null, "eatDraw": null, "golfDraw": null, "hangTimes": null, "hangDraw": null, "drawSpecial": null, "coinsFx": null, "ZA": null, "ZB": null, "SPOTS": null, "zonePt": null, "nearZ": null, "clampZ": null, "sideX": null, "route": null, "freePt": null, "VMAX": null, "mkAgent": null, "isFree": null, "setPlan": null, "next": null, "goSteps": null, "pickW": null, "night": null, "choose": null, "startTalk": null, "endSocial": null, "startTag": null, "tagTick": null, "prankVictim": null, "startPrank": null, "prankTick": null, "startPatrol": null, "TURN": null, "tick": null, "talkTick": null, "update": null, "headY": null, "drawAgent": null, "drawWet": null, "drawDrips": null, "newWorld": null}
	_s2["basePose"] = Callable(self, "_f12").bind(_s2)
	_s2["add"] = Callable(self, "_f13").bind(_s2)
	_s2["shadowAt"] = Callable(self, "_f15").bind(_s2)
	_s2["drawM"] = Callable(self, "_f16").bind(_s2)
	_s2["npt"] = Callable(self, "_f17").bind(_s2)
	_s2["crayon"] = Callable(self, "_f18").bind(_s2)
	_s2["steam"] = Callable(self, "_f20").bind(_s2)
	_s2["txt"] = Callable(self, "_f21").bind(_s2)
	_s2["zzz"] = Callable(self, "_f22").bind(_s2)
	_s2["star"] = Callable(self, "_f23").bind(_s2)
	_s2["stars"] = Callable(self, "_f24").bind(_s2)
	_s2["bubble"] = Callable(self, "_f25").bind(_s2)
	_s2["crumbs"] = Callable(self, "_f26").bind(_s2)
	_s2["drop"] = Callable(self, "_f27").bind(_s2)
	_s2["dustPuff"] = Callable(self, "_f28").bind(_s2)
	_s2["sniffLines"] = Callable(self, "_f29").bind(_s2)
	_s2["hopPose"] = Callable(self, "_f30").bind(_s2)
	_s2["body"] = Callable(self, "_f31").bind(_s2)
	_s2["bump3"] = Callable(self, "_f40").bind(_s2)
	_s2["eatDraw"] = Callable(self, "_f41").bind(_s2)
	_s2["golfDraw"] = Callable(self, "_f42").bind(_s2)
	_s2["hangTimes"] = Callable(self, "_f43").bind(_s2)
	_s2["hangDraw"] = Callable(self, "_f44").bind(_s2)
	_s2["drawSpecial"] = Callable(self, "_f48").bind(_s2)
	_s2["coinsFx"] = Callable(self, "_f49").bind(_s2)
	_s2["zonePt"] = Callable(self, "_f50").bind(_s2)
	_s2["nearZ"] = Callable(self, "_f51").bind(_s2)
	_s2["clampZ"] = Callable(self, "_f52").bind(_s2)
	_s2["route"] = Callable(self, "_f54").bind(_s2)
	_s2["freePt"] = Callable(self, "_f55").bind(_s2)
	_s2["mkAgent"] = Callable(self, "_f56").bind(_s2)
	_s2["setPlan"] = Callable(self, "_f58").bind(_s2)
	_s2["next"] = Callable(self, "_f59").bind(_s2)
	_s2["goSteps"] = Callable(self, "_f60").bind(_s2)
	_s2["pickW"] = Callable(self, "_f62").bind(_s2)
	_s2["choose"] = Callable(self, "_f64").bind(_s2)
	_s2["startTalk"] = Callable(self, "_f98").bind(_s2)
	_s2["endSocial"] = Callable(self, "_f101").bind(_s2)
	_s2["startTag"] = Callable(self, "_f102").bind(_s2)
	_s2["tagTick"] = Callable(self, "_f103").bind(_s2)
	_s2["prankVictim"] = Callable(self, "_f104").bind(_s2)
	_s2["startPrank"] = Callable(self, "_f106").bind(_s2)
	_s2["prankTick"] = Callable(self, "_f110").bind(_s2)
	_s2["startPatrol"] = Callable(self, "_f112").bind(_s2)
	_s2["tick"] = Callable(self, "_f114").bind(_s2)
	_s2["talkTick"] = Callable(self, "_f115").bind(_s2)
	_s2["update"] = Callable(self, "_f118").bind(_s2)
	_s2["headY"] = Callable(self, "_f123").bind(_s2)
	_s2["drawAgent"] = Callable(self, "_f124").bind(_s2)
	_s2["drawWet"] = Callable(self, "_f125").bind(_s2)
	_s2["drawDrips"] = Callable(self, "_f126").bind(_s2)
	_s2["newWorld"] = Callable(self, "_f127").bind(_s2)
	v_frame_84 = Callable(self, "_f128").bind(_s2)
	_s2["PI"] = PI
	_s2["TAU"] = J.mul(_s2["PI"], 2.0)
	_s2["D"] = J.div(_s2["PI"], 180.0)
	_s2["cl"] = Callable(self, "_f2").bind(_s2)
	_s2["lerp"] = Callable(self, "_f3").bind(_s2)
	_s2["eo"] = Callable(self, "_f4").bind(_s2)
	_s2["ei"] = Callable(self, "_f5").bind(_s2)
	_s2["eio"] = Callable(self, "_f6").bind(_s2)
	_s2["eo3"] = Callable(self, "_f7").bind(_s2)
	_s2["seg"] = Callable(self, "_f8").bind(_s2)
	_s2["env"] = Callable(self, "_f9").bind(_s2)
	_s2["hash"] = Callable(self, "_f10").bind(_s2)
	_s2["ok"] = Callable(self, "_f11").bind(_s2)
	_s2["R"] = J.gp(J.G.get("Math"), "random")
	_s2["HOPPER"] = {"laojiang": 1.0, "zombie": 1.0}
	_s2["PAPER"] = {"xiaozhi": 1.0, "zhiren": 1.0}
	_s2["SOLID"] = {"laojiang": 1.0, "zombie": 1.0, "pocong": 1.0, "xiaozhi": 1.0, "zhiren": 1.0, "penanggal": 1.0}
	_s2["CH"] = {"xiaozhi": 54.0, "egui": 54.0, "eguiking": 66.0, "xiaogui": 46.0, "toyol": 46.0, "laojiang": 58.0, "zombie": 54.0, "shuigui": 56.0, "pontianak": 60.0, "pocong": 54.0, "penanggal": 52.0, "mengpo": 56.0, "youhun": 46.0, "baiwu": 76.0, "heiwu": 76.0, "niutou": 64.0, "mamian": 64.0, "huang": 62.0, "zhiren": 54.0, "tianhua": 60.0}
	_s2["FACEV"] = {"heiwu": 0.5, "baiwu": 0.45, "niutou": 0.3, "mamian": 0.3, "eguiking": 0.28, "huang": 0.3, "laojiang": 0.35, "zombie": 0.35, "toyol": 0.3}
	_s2["SC"] = 0.58
	_s2["floatY"] = Callable(self, "_f14").bind(_s2)
	v_NAMES_46 = ["walk", "eat", "golf", "hang", "talk", "argue", "wave", "bow", "doze", "look", "stretch", "sniff", "backrub", "soup", "hair", "shake", "spin", "boo", "laugh", "startle", "eek", "reach", "bump", "dizzy"]
	if (not J.seq(J.typeof_(J.G.get("DAILY")), "undefined")):
		J.mc(v_NAMES_46, "forEach", [Callable(self, "_f47").bind(_s2)])
	_s2["ZA"] = [158.0, 232.0, 534.0, 676.0]
	_s2["ZB"] = [24.0, 366.0, 636.0, 676.0]
	_s2["SPOTS"] = {"eave": {"x": 124.0, "y": 640.0, "ey": 556.0}, "banana": [[368.0, 590.0, (-1.0)], [34.0, 640.0, 1.0]], "bumps": [[160.0, 600.0, (-1.0)], [234.0, 606.0, 1.0], [172.0, 674.0, (-1.0)], [218.0, 674.0, 1.0]]}
	_s2["sideX"] = Callable(self, "_f53").bind(_s2)
	_s2["VMAX"] = {"eguiking": 13.0, "egui": 17.0, "xiaozhi": 20.0, "zhiren": 20.0, "laojiang": 15.0, "zombie": 15.0, "tianhua": 14.0, "mengpo": 12.0, "heiwu": 15.0, "baiwu": 16.0, "niutou": 17.0, "mamian": 17.0, "huang": 14.0, "pontianak": 14.0, "shuigui": 13.0, "youhun": 11.0, "xiaogui": 19.0, "toyol": 17.0, "pocong": 14.0, "penanggal": 15.0}
	_s2["isFree"] = Callable(self, "_f57").bind(_s2)
	_s2["night"] = Callable(self, "_f63").bind(_s2)
	_s2["TURN"] = 0.22
	return {"frame": v_frame_84, "newWorld": _s2["newWorld"], "update": _s2["update"], "drawAgent": _s2["drawAgent"], "drawWet": _s2["drawWet"], "drawDrips": _s2["drawDrips"], "mkAgent": _s2["mkAgent"], "setPlan": _s2["setPlan"], "choose": _s2["choose"], "startTalk": _s2["startTalk"], "startTag": _s2["startTag"], "startPrank": _s2["startPrank"], "startPatrol": _s2["startPatrol"], "hangTimes": _s2["hangTimes"], "SPOTS": _s2["SPOTS"], "ZA": _s2["ZA"], "ZB": _s2["ZB"], "SC": _s2["SC"]}
