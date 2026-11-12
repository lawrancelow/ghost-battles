# 自動轉譯自 daily_town.js（tools/jsgd.js）——唔好直接改，改原 JS 再轉
extends RefCounted

func run(env):
	var this_ = null; var a = []
	J.G["TOWN"] = J.cl(Callable(self, "_f1").bind(env), null, [])

func _f13(this_, a: Array, env):
	var v_u_111 = null; var v_v_112 = null
	v_u_111 = J.arg(a, 0)
	v_v_112 = J.arg(a, 1)
	return [J.mul(J.sub(v_u_111, 0.5), env["W"]), J.mul(J.sub(v_v_112, 1.0), env["H"])]

func _f12(this_, a: Array, env):
	var v_ctx_95 = null; var v_a_96 = null; var v_key_97 = null; var v_nr_98 = null; var v_opt_99 = null; var v_img_100 = null; var v_o_101 = null; var v_t_102 = null; var v_at_105 = null; var v_dur_106 = null; var v_env_107 = null; var v_z_108 = null; var v_flip_109 = null; var v_fy_110 = null
	var _s15 = {"__p": env, "H": null, "W": null}
	v_ctx_95 = J.arg(a, 0)
	v_a_96 = J.arg(a, 1)
	v_key_97 = J.arg(a, 2)
	v_nr_98 = J.arg(a, 3)
	v_opt_99 = J.arg(a, 4)
	var _t1 = _s15["__p"]["ok"]
	var _t2 = (not J.t(J.cl(_t1, null, [v_key_97])))
	if (_t2 if _t2 else J.seq(J.typeof_(J.G.get("MeshAnim")), "undefined")):
		return null
	v_img_100 = J.gp(J.G.get("SPR"), v_key_97)
	v_o_101 = J.gp(v_a_96, "o")
	var _t3 = J.gp(v_o_101, "t")
	v_t_102 = (_t3 if J.t(_t3) else 0.0)
	_s15["H"] = J.gp(v_a_96, "H")
	_s15["W"] = J.div(J.mul(_s15["H"], J.gp(v_img_100, "naturalWidth")), J.gp(v_img_100, "naturalHeight"))
	var _t4 = J.gp(v_o_101, "at")
	v_at_105 = (_t4 if J.t(_t4) else 0.0)
	var _t5 = J.gp(v_o_101, "adur")
	v_dur_106 = (_t5 if J.t(_t5) else 0.0)
	var _t6 = _s15["__p"]["ss"]
	v_env_107 = J.cl(_t6, null, [J.div(v_at_105, 0.35)])
	if J.t(v_dur_106):
		var _t7 = _s15["__p"]["ss"]
		var _t8 = _s15["__p"]["ss"]
		var _t9 = J.min_([v_env_107, J.cl(_t8, null, [J.div(J.sub(v_dur_106, v_at_105), 0.35)])])
		v_env_107 = _t9
	if (not J.leq(J.gp(v_o_101, "aw"), null)):
		var _t10 = _s15["__p"]["cl"]
		var _t11 = J.mul(v_env_107, J.cl(_t10, null, [J.gp(v_o_101, "aw")]))
		v_env_107 = _t11
	var _t12 = (not J.seq(J.gp(v_o_101, "shadow"), false))
	if J.t((J.gp(v_a_96, "shadow") if _t12 else _t12)):
		J.mc(v_a_96, "shadow", [J.gp(v_a_96, "x")])
	var _t13 = J.gp(J.G.get("MeshAnim"), "ANIM")
	v_z_108 = J.mc(_t13, "idle", [v_t_102])
	v_flip_109 = (not J.seq(J.gp(v_a_96, "faceRight"), (not (not J.t(v_nr_98)))))
	J.mc(v_ctx_95, "save", [])
	var _t16 = null
	if J.t(J.gp(v_a_96, "solid")):
		_t16 = 0.0
	else:
		var _t15 = (-(3.0 + (sin(J.num(J.mul(v_t_102, 2.4))) * 2.0)))
		var _t14 = J.gp(v_a_96, "s")
		_t16 = J.mul(_t15, (_t14 if J.t(_t14) else J.div(J.gp(v_a_96, "H"), 60.0)))
	v_fy_110 = _t16
	J.mc(v_ctx_95, "translate", [J.gp(v_a_96, "x"), J.add(J.gp(v_a_96, "y"), v_fy_110)])
	if J.t(v_flip_109):
		J.mc(v_ctx_95, "scale", [(-1.0), 1.0])
	J.mc(v_ctx_95, "translate", [0.0, J.mul((0.0 if J.t((J.gp(v_opt_99, "noLift") if J.t(v_opt_99) else v_opt_99)) else J.gp(v_z_108, "y")), _s15["H"])])
	J.mc(v_ctx_95, "scale", [J.gp(v_z_108, "sx"), J.gp(v_z_108, "sy")])
	return {"ctx": v_ctx_95, "a": v_a_96, "o": v_o_101, "t": v_t_102, "at": v_at_105, "dur": v_dur_106, "env": v_env_107, "H": _s15["H"], "W": _s15["W"], "z": v_z_108, "flip": v_flip_109, "fs": (1.0 if J.t(v_nr_98) else (-1.0)), "P": Callable(self, "_f13").bind(_s15), "walk": (not (not J.t(J.gp(v_o_101, "walk"))))}

func _f15(this_, a: Array, env):
	var v_S_116 = null; var v_add_117 = null; var v_z_118 = null; var v_k_119 = null
	v_S_116 = J.arg(a, 0)
	v_add_117 = J.arg(a, 1)
	var _t19 = {}
	var _t18 = null
	if J.t(J.gp(v_S_116, "walk")):
		var _t17 = J.gp(J.G.get("MeshAnim"), "ANIM")
		_t18 = J.mc(_t17, "walk", [J.gp(v_S_116, "t")])
	else:
		_t18 = J.gp(v_S_116, "z")
	v_z_118 = J.S_Object_("assign", [_t19, _t18])
	J.sp(v_z_118, "armF", 0.0)
	J.sp(v_z_118, "armB", 0.0)
	J.sp(v_z_118, "axe", 0.0)
	J.sp(v_z_118, "body", 0.0)
	J.sp(v_z_118, "x", 0.0)
	J.sp(v_z_118, "y", 0.0)
	J.sp(v_z_118, "sx", 1.0)
	J.sp(v_z_118, "sy", 1.0)
	J.sp(v_z_118, "rot", 0.0)
	if (not J.t(J.gp(v_S_116, "walk"))):
		J.sp(v_z_118, "legF", 0.0)
		J.sp(v_z_118, "legB", 0.0)
	if J.t(v_add_117):
		for _t20 in J.keys(v_add_117):
			v_k_119 = _t20
			var _t21 = J.gp(v_z_118, v_k_119)
			var _t22 = J.add((_t21 if J.t(_t21) else 0.0), J.gp(v_add_117, v_k_119))
			J.sp(v_z_118, v_k_119, _t22)
	return v_z_118

func _f16(this_, a: Array, env):
	var v_S_122 = null; var v_rig_123 = null; var v_key_124 = null; var v_add_125 = null
	v_S_122 = J.arg(a, 0)
	v_rig_123 = J.arg(a, 1)
	v_key_124 = J.arg(a, 2)
	v_add_125 = J.arg(a, 3)
	var _t24 = J.gp(v_S_122, "ctx")
	var _t25 = J.gp(v_S_122, "H")
	var _t23 = env["mpose"]
	J.mc(J.G.get("MeshAnim"), "drawBody", [_t24, v_rig_123, v_key_124, _t25, J.cl(_t23, null, [v_S_122, v_add_125])])

func _f17(this_, a: Array, env):
	var v_S_128 = null; var v_ang_129 = null; var v_ly_130 = null; var v_dx_131 = null; var v_dy_132 = null; var v_c_133 = null
	v_S_128 = J.arg(a, 0)
	v_ang_129 = J.arg(a, 1)
	v_ly_130 = J.arg(a, 2)
	v_dx_131 = J.arg(a, 3)
	v_dy_132 = J.arg(a, 4)
	v_c_133 = J.gp(v_S_128, "ctx")
	J.mc(v_c_133, "translate", [(v_dx_131 if J.t(v_dx_131) else 0.0), (v_dy_132 if J.t(v_dy_132) else 0.0)])
	J.mc(v_c_133, "translate", [0.0, J.mul((-J.num(J.gp(v_S_128, "H"))), (v_ly_130 if J.t(v_ly_130) else 0.35))])
	J.mc(v_c_133, "rotate", [v_ang_129])
	J.mc(v_c_133, "translate", [0.0, J.mul(J.gp(v_S_128, "H"), (v_ly_130 if J.t(v_ly_130) else 0.35))])

func _f19(this_, a: Array, env):
	var v_u_144 = null; var v_v_145 = null
	v_u_144 = J.arg(a, 0)
	v_v_145 = J.arg(a, 1)
	return [J.mul(J.sub(v_u_144, J.gp(env["pv"], 0.0)), J.gp(env["S"], "W")), J.mul(J.sub(v_v_145, J.gp(env["pv"], 1.0)), J.gp(env["S"], "H"))]

func _f18(this_, a: Array, env):
	var v_key_137 = null; var v_at_139 = null; var v_ang_140 = null; var v_sc_141 = null; var v_fn_142 = null; var v_c_143 = null
	var _s23 = {"__p": env, "S": null, "pv": null}
	_s23["S"] = J.arg(a, 0)
	v_key_137 = J.arg(a, 1)
	_s23["pv"] = J.arg(a, 2)
	v_at_139 = J.arg(a, 3)
	v_ang_140 = J.arg(a, 4)
	v_sc_141 = J.arg(a, 5)
	v_fn_142 = J.arg(a, 6)
	var _t26 = _s23["__p"]["ok"]
	if (not J.t(J.cl(_t26, null, [v_key_137]))):
		return null
	v_c_143 = J.gp(_s23["S"], "ctx")
	J.mc(v_c_143, "save", [])
	J.mc(v_c_143, "translate", [J.gp(v_at_139, 0.0), J.gp(v_at_139, 1.0)])
	J.mc(v_c_143, "rotate", [(v_ang_140 if J.t(v_ang_140) else 0.0)])
	if J.t(v_sc_141):
		J.mc(v_c_143, "scale", [v_sc_141, v_sc_141])
	J.mc(v_c_143, "drawImage", [J.gp(J.G.get("SPR"), v_key_137), J.mul((-J.num(J.gp(_s23["pv"], 0.0))), J.gp(_s23["S"], "W")), J.mul((-J.num(J.gp(_s23["pv"], 1.0))), J.gp(_s23["S"], "H")), J.gp(_s23["S"], "W"), J.gp(_s23["S"], "H")])
	if J.t(v_fn_142):
		J.cl(v_fn_142, null, [Callable(self, "_f19").bind(_s23)])
	J.mc(v_c_143, "restore", [])

func _f20(this_, a: Array, env):
	var v_ctx_148 = null; var v_key_149 = null; var v_x_150 = null; var v_y_151 = null; var v_w_152 = null; var v_ang_153 = null; var v_ax_154 = null; var v_ay_155 = null; var v_sx_156 = null; var v_sy_157 = null; var v_im_158 = null; var v_h_159 = null
	v_ctx_148 = J.arg(a, 0)
	v_key_149 = J.arg(a, 1)
	v_x_150 = J.arg(a, 2)
	v_y_151 = J.arg(a, 3)
	v_w_152 = J.arg(a, 4)
	v_ang_153 = J.arg(a, 5)
	v_ax_154 = J.arg(a, 6)
	v_ay_155 = J.arg(a, 7)
	v_sx_156 = J.arg(a, 8)
	v_sy_157 = J.arg(a, 9)
	var _t27 = env["ok"]
	if (not J.t(J.cl(_t27, null, [v_key_149]))):
		return null
	v_im_158 = J.gp(J.G.get("SPR"), v_key_149)
	v_h_159 = J.div(J.mul(v_w_152, J.gp(v_im_158, "naturalHeight")), J.gp(v_im_158, "naturalWidth"))
	J.mc(v_ctx_148, "save", [])
	J.mc(v_ctx_148, "translate", [v_x_150, v_y_151])
	J.mc(v_ctx_148, "rotate", [(v_ang_153 if J.t(v_ang_153) else 0.0)])
	J.mc(v_ctx_148, "scale", [(v_sx_156 if J.t(v_sx_156) else 1.0), (v_sy_157 if J.t(v_sy_157) else 1.0)])
	J.mc(v_ctx_148, "drawImage", [v_im_158, J.mul((-J.num((0.5 if J.leq(v_ax_154, null) else v_ax_154))), v_w_152), J.mul((-J.num((0.5 if J.leq(v_ay_155, null) else v_ay_155))), v_h_159), v_w_152, v_h_159])
	J.mc(v_ctx_148, "restore", [])

func _f24(this_, a: Array, env):
	var v_p_179 = null; var v_i_180 = null
	v_p_179 = J.arg(a, 0)
	v_i_180 = J.arg(a, 1)
	return (J.mc(env["ctx"], "lineTo", [J.gp(v_p_179, 0.0), J.gp(v_p_179, 1.0)]) if J.t(v_i_180) else J.mc(env["ctx"], "moveTo", [J.gp(v_p_179, 0.0), J.gp(v_p_179, 1.0)]))

func _f23(this_, a: Array, env):
	J.mc(env["ctx"], "beginPath", [])
	J.mc(env["pts"], "forEach", [Callable(self, "_f24").bind(env)])

func _f22(this_, a: Array, env):
	var v_w_175 = null; var v_col_176 = null; var v_out_177 = null; var v_path_178 = null
	var _s27 = {"__p": env, "ctx": null, "pts": null}
	_s27["ctx"] = J.arg(a, 0)
	_s27["pts"] = J.arg(a, 1)
	v_w_175 = J.arg(a, 2)
	v_col_176 = J.arg(a, 3)
	v_out_177 = J.arg(a, 4)
	v_path_178 = Callable(self, "_f23").bind(_s27)
	var _t28 = _s27["ctx"]
	J.sp(_t28, "lineCap", "round")
	var _t29 = _s27["ctx"]
	J.sp(_t29, "lineJoin", "round")
	if J.t(v_out_177):
		var _t30 = _s27["ctx"]
		J.sp(_t30, "strokeStyle", v_out_177)
		var _t31 = _s27["ctx"]
		var _t32 = J.mul(v_w_175, 2.0)
		J.sp(_t31, "lineWidth", _t32)
		J.cl(v_path_178, null, [])
		J.mc(_s27["ctx"], "stroke", [])
	var _t33 = _s27["ctx"]
	J.sp(_t33, "strokeStyle", v_col_176)
	var _t34 = _s27["ctx"]
	J.sp(_t34, "lineWidth", v_w_175)
	J.cl(v_path_178, null, [])
	J.mc(_s27["ctx"], "stroke", [])

func _f25(this_, a: Array, env):
	var v_S_183 = null; var v_x_184 = null; var v_y_185 = null; var v_txt_186 = null; var v_size_187 = null; var v_alpha_188 = null; var v_opt_189 = null; var v_c_190 = null
	v_S_183 = J.arg(a, 0)
	v_x_184 = J.arg(a, 1)
	v_y_185 = J.arg(a, 2)
	v_txt_186 = J.arg(a, 3)
	v_size_187 = J.arg(a, 4)
	v_alpha_188 = J.arg(a, 5)
	v_opt_189 = J.arg(a, 6)
	var _t35 = (v_opt_189 if J.t(v_opt_189) else {})
	v_opt_189 = _t35
	var _t37 = J.cmp(v_alpha_188, 0.01, "<=")
	if not J.t(_t37):
		var _t36 = J.gp(J.gp(v_S_183, "o"), "quiet")
		_t37 = ((not J.t(J.gp(v_opt_189, "fx"))) if J.t(_t36) else _t36)
	if J.t(_t37):
		return null
	v_c_190 = J.gp(v_S_183, "ctx")
	J.mc(v_c_190, "save", [])
	J.mc(v_c_190, "translate", [v_x_184, v_y_185])
	if J.t(J.gp(v_S_183, "flip")):
		J.mc(v_c_190, "scale", [(-1.0), 1.0])
	var _t38 = J.gp(v_opt_189, "rot")
	J.mc(v_c_190, "rotate", [(_t38 if J.t(_t38) else 0.0)])
	var _t39 = env["cl"]
	var _t40 = J.mul(J.gp(v_c_190, "globalAlpha"), J.cl(_t39, null, [v_alpha_188]))
	J.sp(v_c_190, "globalAlpha", _t40)
	var _t41 = ("900 " + J.str(v_size_187) + "px " + J.str(env["FONT"]))
	J.sp(v_c_190, "font", _t41)
	J.sp(v_c_190, "textAlign", "center")
	J.sp(v_c_190, "textBaseline", "middle")
	J.sp(v_c_190, "lineJoin", "round")
	var _t42 = J.gp(v_opt_189, "out")
	var _t43 = (_t42 if J.t(_t42) else "#2a1a22")
	J.sp(v_c_190, "strokeStyle", _t43)
	var _t44 = J.mul(v_size_187, 0.26)
	J.sp(v_c_190, "lineWidth", _t44)
	J.mc(v_c_190, "strokeText", [v_txt_186, 0.0, 0.0])
	var _t45 = J.gp(v_opt_189, "col")
	var _t46 = (_t45 if J.t(_t45) else "#fff3e8")
	J.sp(v_c_190, "fillStyle", _t46)
	J.mc(v_c_190, "fillText", [v_txt_186, 0.0, 0.0])
	J.mc(v_c_190, "restore", [])

func _f26(this_, a: Array, env):
	var v_ctx_193 = null; var v_x_194 = null; var v_y_195 = null; var v_r_196 = null; var v_k_197 = null; var v_seed_198 = null; var v_col_199 = null; var v_i_200 = null; var v_a_201 = null; var v_rr_202 = null; var v_px_203 = null; var v_py_204 = null
	v_ctx_193 = J.arg(a, 0)
	v_x_194 = J.arg(a, 1)
	v_y_195 = J.arg(a, 2)
	v_r_196 = J.arg(a, 3)
	v_k_197 = J.arg(a, 4)
	v_seed_198 = J.arg(a, 5)
	v_col_199 = J.arg(a, 6)
	var _t47 = J.cmp(v_k_197, 0.0, "<=")
	if (_t47 if _t47 else J.cmp(v_k_197, 1.0, ">=")):
		return null
	J.mc(v_ctx_193, "save", [])
	var _t48 = J.mul(J.gp(v_ctx_193, "globalAlpha"), (sin(J.num(J.mul(v_k_197, env["PI"]))) * 0.85))
	J.sp(v_ctx_193, "globalAlpha", _t48)
	v_i_200 = 0.0
	while true:
		if not J.cmp(v_i_200, 3.0, "<"): break
		var _t49 = env["rnd"]
		v_a_201 = J.mul(J.cl(_t49, null, [J.add(v_seed_198, v_i_200)]), 6.28)
		var _t50 = env["rnd"]
		v_rr_202 = (J.mul(v_r_196, (0.45 + J.mul(0.4, J.cl(_t50, null, [J.add(v_seed_198, J.mul(v_i_200, 3.0))])))) * (0.6 + J.mul(v_k_197, 0.6)))
		v_px_203 = J.add(J.add(v_x_194, J.mul((J.mul(cos(J.num(v_a_201)), v_r_196) * 0.5), v_k_197)), J.mul((J.mul(v_i_200, v_r_196) * 0.35), v_k_197))
		v_py_204 = J.sub(J.add(v_y_195, (J.mul(sin(J.num(v_a_201)), v_r_196) * 0.3)), (J.mul(v_k_197, v_r_196) * 0.4))
		var _t51 = (v_col_199 if J.t(v_col_199) else "rgba(245,245,250,.85)")
		J.sp(v_ctx_193, "fillStyle", _t51)
		J.sp(v_ctx_193, "strokeStyle", "rgba(60,60,80,.35)")
		var _t52 = J.max_([1.0, J.mul(v_r_196, 0.08)])
		J.sp(v_ctx_193, "lineWidth", _t52)
		J.mc(v_ctx_193, "beginPath", [])
		J.mc(v_ctx_193, "arc", [v_px_203, v_py_204, v_rr_202, 0.0, J.mul(env["PI"], 2.0)])
		J.mc(v_ctx_193, "fill", [])
		J.mc(v_ctx_193, "stroke", [])
		v_i_200 = J.num(v_i_200) + 1.0
	J.mc(v_ctx_193, "restore", [])

func _f27(this_, a: Array, env):
	var v_ctx_207 = null; var v_x_208 = null; var v_y_209 = null; var v_h_210 = null; var v_k_211 = null; var v_seed_212 = null; var v_a_213 = null; var v_pts_214 = null; var v_i_215 = null; var v_u_216 = null
	v_ctx_207 = J.arg(a, 0)
	v_x_208 = J.arg(a, 1)
	v_y_209 = J.arg(a, 2)
	v_h_210 = J.arg(a, 3)
	v_k_211 = J.arg(a, 4)
	v_seed_212 = J.arg(a, 5)
	v_a_213 = J.arg(a, 6)
	var _t53 = J.cmp(v_k_211, 0.0, "<=")
	if (_t53 if _t53 else J.cmp(v_k_211, 1.0, ">=")):
		return null
	J.mc(v_ctx_207, "save", [])
	var _t54 = J.mul(J.gp(v_ctx_207, "globalAlpha"), J.mul(sin(J.num(J.mul(v_k_211, env["PI"]))), (v_a_213 if J.t(v_a_213) else 0.75)))
	J.sp(v_ctx_207, "globalAlpha", _t54)
	v_pts_214 = []
	v_i_215 = 0.0
	while true:
		if not J.cmp(v_i_215, 10.0, "<="): break
		v_u_216 = J.div(v_i_215, 10.0)
		J.mc(v_pts_214, "push", [[J.add(v_x_208, (J.mul(sin(J.num(J.add(J.add(J.mul(v_u_216, 5.0), v_seed_212), J.mul(v_k_211, 5.0)))), v_h_210) * 0.12)), (J.sub(v_y_209, (J.mul(v_u_216, v_h_210) * (0.4 + J.mul(v_k_211, 0.6)))) - (J.mul(v_k_211, v_h_210) * 0.3))]])
		v_i_215 = J.num(v_i_215) + 1.0
	var _t55 = env["crayon"]
	J.cl(_t55, null, [v_ctx_207, v_pts_214, J.max_([1.4, J.mul(v_h_210, 0.06)]), "rgba(250,246,240,.9)", "rgba(60,50,60,.25)"])
	J.mc(v_ctx_207, "restore", [])

func _f28(this_, a: Array, env):
	var v_ctx_219 = null; var v_x_220 = null; var v_y_221 = null; var v_r_222 = null; var v_k_223 = null; var v_fall_224 = null; var v_py_225 = null
	v_ctx_219 = J.arg(a, 0)
	v_x_220 = J.arg(a, 1)
	v_y_221 = J.arg(a, 2)
	v_r_222 = J.arg(a, 3)
	v_k_223 = J.arg(a, 4)
	v_fall_224 = J.arg(a, 5)
	var _t56 = J.cmp(v_k_223, 0.0, "<=")
	if (_t56 if _t56 else J.cmp(v_k_223, 1.0, ">=")):
		return null
	v_py_225 = J.add(v_y_221, J.mul(J.mul(v_fall_224, v_k_223), v_k_223))
	J.mc(v_ctx_219, "save", [])
	var _t57 = J.mul(J.gp(v_ctx_219, "globalAlpha"), (1.0 - J.mul(v_k_223, 0.5)))
	J.sp(v_ctx_219, "globalAlpha", _t57)
	J.sp(v_ctx_219, "fillStyle", "rgba(30,60,72,.9)")
	J.mc(v_ctx_219, "beginPath", [])
	J.mc(v_ctx_219, "ellipse", [v_x_220, v_py_225, J.mul(v_r_222, 1.2), J.mul(v_r_222, 1.7), 0.0, 0.0, J.mul(env["PI"], 2.0)])
	J.mc(v_ctx_219, "fill", [])
	J.sp(v_ctx_219, "fillStyle", "rgba(165,215,232,.95)")
	J.mc(v_ctx_219, "beginPath", [])
	J.mc(v_ctx_219, "ellipse", [v_x_220, v_py_225, J.mul(v_r_222, 0.85), J.mul(v_r_222, 1.3), 0.0, 0.0, J.mul(env["PI"], 2.0)])
	J.mc(v_ctx_219, "fill", [])
	J.mc(v_ctx_219, "restore", [])

func _f29(this_, a: Array, env):
	var v_ctx_228 = null; var v_x_229 = null; var v_y_230 = null; var v_r_231 = null; var v_k_232 = null; var v_i_233 = null; var v_an_234 = null; var v_rr_235 = null
	v_ctx_228 = J.arg(a, 0)
	v_x_229 = J.arg(a, 1)
	v_y_230 = J.arg(a, 2)
	v_r_231 = J.arg(a, 3)
	v_k_232 = J.arg(a, 4)
	if J.cmp(v_k_232, 0.0, "<="):
		return null
	J.mc(v_ctx_228, "save", [])
	J.mc(v_ctx_228, "translate", [v_x_229, v_y_230])
	J.mc(v_ctx_228, "scale", [v_k_232, v_k_232])
	var _t58 = J.mul(J.gp(v_ctx_228, "globalAlpha"), J.min_([1.0, J.mul(v_k_232, 1.5)]))
	J.sp(v_ctx_228, "globalAlpha", _t58)
	J.mc(v_ctx_228, "beginPath", [])
	v_i_233 = 0.0
	while true:
		if not J.cmp(v_i_233, 8.0, "<"): break
		v_an_234 = (J.mul(J.div(v_i_233, 8.0), env["PI"]) * 2.0)
		v_rr_235 = (J.mul(v_r_231, 0.22) if J.t(J.mod(v_i_233, 2.0)) else v_r_231)
		J.mc(v_ctx_228, "lineTo", [J.mul(cos(J.num(v_an_234)), v_rr_235), J.mul(sin(J.num(v_an_234)), v_rr_235)])
		v_i_233 = J.num(v_i_233) + 1.0
	J.mc(v_ctx_228, "closePath", [])
	J.sp(v_ctx_228, "fillStyle", "#fffbe8")
	J.sp(v_ctx_228, "strokeStyle", "rgba(90,70,20,.6)")
	var _t59 = J.max_([1.0, J.mul(v_r_231, 0.12)])
	J.sp(v_ctx_228, "lineWidth", _t59)
	J.mc(v_ctx_228, "stroke", [])
	J.mc(v_ctx_228, "fill", [])
	J.mc(v_ctx_228, "restore", [])

func _f30(this_, a: Array, env):
	var v_S_238 = null; var v_x_239 = null; var v_y_240 = null; var v_size_241 = null; var v_t_242 = null; var v_a_243 = null; var v_i_244 = null; var v_q_245 = null
	v_S_238 = J.arg(a, 0)
	v_x_239 = J.arg(a, 1)
	v_y_240 = J.arg(a, 2)
	v_size_241 = J.arg(a, 3)
	v_t_242 = J.arg(a, 4)
	v_a_243 = J.arg(a, 5)
	v_i_244 = 0.0
	while true:
		if not J.cmp(v_i_244, 3.0, "<"): break
		v_q_245 = J.mod((J.mul(v_t_242, 0.45) + J.div(v_i_244, 3.0)), 1.0)
		var _t60 = env["text"]
		J.cl(_t60, null, [v_S_238, J.add(J.add(v_x_239, (J.mul(v_q_245, v_size_241) * 1.2)), (J.mul(sin(J.num(J.add(J.mul(v_q_245, 6.0), v_i_244))), v_size_241) * 0.2)), J.sub(v_y_240, (J.mul(v_q_245, v_size_241) * 2.2)), ("Z" if J.seq(v_i_244, 1.0) else "z"), J.mul(v_size_241, (0.6 + J.mul(v_q_245, 0.6))), J.mul(v_a_243, sin(J.num(J.mul(v_q_245, env["PI"])))), {"col": "#dfe8ff", "out": "#2a2a48", "fx": 1.0}])
		v_i_244 = J.num(v_i_244) + 1.0

func _f31(this_, a: Array, env):
	var v_ctx_248 = null; var v_x_249 = null; var v_y_250 = null; var v_r_251 = null; var v_k_252 = null; var v_col_253 = null; var v_i_254 = null; var v_an_255 = null
	v_ctx_248 = J.arg(a, 0)
	v_x_249 = J.arg(a, 1)
	v_y_250 = J.arg(a, 2)
	v_r_251 = J.arg(a, 3)
	v_k_252 = J.arg(a, 4)
	v_col_253 = J.arg(a, 5)
	if J.cmp(v_k_252, 0.0, "<="):
		return null
	J.mc(v_ctx_248, "save", [])
	var _t61 = J.mul(J.gp(v_ctx_248, "globalAlpha"), v_k_252)
	J.sp(v_ctx_248, "globalAlpha", _t61)
	v_i_254 = (-1.0)
	while true:
		if not J.cmp(v_i_254, 1.0, "<="): break
		v_an_255 = (J.div((-J.num(env["PI"])), 2.0) + J.mul(v_i_254, 0.55))
		var _t62 = env["crayon"]
		J.cl(_t62, null, [v_ctx_248, [[J.add(v_x_249, (J.mul(cos(J.num(v_an_255)), v_r_251) * 0.55)), J.add(v_y_250, (J.mul(sin(J.num(v_an_255)), v_r_251) * 0.55))], [J.add(v_x_249, J.mul(cos(J.num(v_an_255)), v_r_251)), J.add(v_y_250, J.mul(sin(J.num(v_an_255)), v_r_251))]], J.max_([1.5, J.mul(v_r_251, 0.12)]), (v_col_253 if J.t(v_col_253) else "#fff2c0"), "rgba(40,20,20,.6)"])
		v_i_254 = J.num(v_i_254) + 1.0
	J.mc(v_ctx_248, "restore", [])

func _f32(this_, a: Array, env):
	var v_ctx_258 = null; var v_x_259 = null; var v_y_260 = null; var v_r_261 = null; var v_k_262 = null; var v_i_263 = null
	v_ctx_258 = J.arg(a, 0)
	v_x_259 = J.arg(a, 1)
	v_y_260 = J.arg(a, 2)
	v_r_261 = J.arg(a, 3)
	v_k_262 = J.arg(a, 4)
	if J.cmp(v_k_262, 0.0, "<="):
		return null
	J.mc(v_ctx_258, "save", [])
	var _t63 = J.mul(J.gp(v_ctx_258, "globalAlpha"), v_k_262)
	J.sp(v_ctx_258, "globalAlpha", _t63)
	J.mc(v_ctx_258, "translate", [v_x_259, v_y_260])
	J.mc(v_ctx_258, "scale", [(0.7 + J.mul(0.3, v_k_262)), (0.7 + J.mul(0.3, v_k_262))])
	v_i_263 = 0.0
	while true:
		if not J.cmp(v_i_263, 4.0, "<"): break
		J.mc(v_ctx_258, "save", [])
		J.mc(v_ctx_258, "rotate", [(J.div(J.mul(v_i_263, env["PI"]), 2.0) + J.div(env["PI"], 4.0))])
		var _t64 = env["crayon"]
		J.cl(_t64, null, [v_ctx_258, [[J.mul(v_r_261, 0.2), ((-J.num(v_r_261)) * 0.35)], [J.mul(v_r_261, 0.55), ((-J.num(v_r_261)) * 0.1)], [J.mul(v_r_261, 0.55), J.mul(v_r_261, 0.3)]], J.max_([1.5, J.mul(v_r_261, 0.2)]), "#e8333a", "rgba(60,0,0,.5)"])
		J.mc(v_ctx_258, "restore", [])
		v_i_263 = J.num(v_i_263) + 1.0
	J.mc(v_ctx_258, "restore", [])

func _f33(this_, a: Array, env):
	var v_S_266 = null; var v_P_267 = null; var v_c_268 = null; var v_e_269 = null
	v_S_266 = J.arg(a, 0)
	v_P_267 = J.arg(a, 1)
	v_c_268 = J.gp(v_S_266, "ctx")
	J.mc(v_c_268, "save", [])
	var _t65 = env["lean"]
	var _t66 = J.gp(v_P_267, "lean")
	J.cl(_t65, null, [v_S_266, (_t66 if J.t(_t66) else 0.0), 0.35])
	var _t67 = env["body"]
	var _t68 = J.gp(v_P_267, "head")
	var _t70 = (_t68 if J.t(_t68) else 0.0)
	var _t69 = J.gp(v_P_267, "legF")
	var _t72 = (_t69 if J.t(_t69) else 0.0)
	var _t71 = J.gp(v_P_267, "legB")
	J.cl(_t67, null, [v_S_266, "npc_ken", "npc_ken__bodyF", {"head": _t70, "legF": _t72, "legB": (_t71 if J.t(_t71) else 0.0)}])
	v_e_269 = J.mc(v_S_266, "P", J.spread([J.SP(J.gp(env["KEN"], "ELB"))]))
	var _t73 = env["piece"]
	var _t79 = J.gp(env["KEN"], "ELB")
	var _t75 = J.gp(v_e_269, 0.0)
	var _t74 = J.gp(v_P_267, "fx")
	var _t78 = J.add(_t75, J.mul((_t74 if J.t(_t74) else 0.0), J.gp(v_S_266, "H")))
	var _t77 = J.gp(v_e_269, 1.0)
	var _t76 = J.gp(v_P_267, "lift")
	var _t81 = [_t78, J.sub(_t77, J.mul((_t76 if J.t(_t76) else 0.0), J.gp(v_S_266, "H")))]
	var _t80 = J.gp(v_P_267, "ang")
	var _t83 = (_t80 if J.t(_t80) else 0.0)
	var _t82 = J.gp(v_P_267, "sc")
	J.cl(_t73, null, [v_S_266, "npc_ken__fore", _t79, _t81, _t83, (_t82 if J.t(_t82) else 1.0)])
	J.mc(v_c_268, "restore", [])

func _f40(this_, a: Array, env):
	var _t96 = env["__p"]["piece"]
	var _t100 = env["S"]
	var _t101 = J.gp(env["__p"]["BOSS"], "SH")
	var _t99 = J.gp(env["sh"], 0.0)
	var _t98 = J.gp(env["sh"], 1.0)
	var _t97 = J.gp(env["P"], "shUp")
	var _t103 = [_t99, J.sub(_t98, J.mul((_t97 if J.t(_t97) else 0.0), J.gp(env["S"], "H")))]
	var _t102 = J.gp(env["P"], "glove")
	return J.cl(_t96, null, [_t100, "npc_boss__point", _t101, _t103, (_t102 if J.t(_t102) else 0.0), 1.0, J.gp(env["P"], "gfn")])

func _f39(this_, a: Array, env):
	var v_after_323 = null; var v_c_324 = null; var v_el_326 = null; var v_gl_327 = null
	var _s59 = {"__p": env, "S": null, "P": null, "sh": null}
	_s59["S"] = J.arg(a, 0)
	_s59["P"] = J.arg(a, 1)
	v_after_323 = J.arg(a, 2)
	v_c_324 = J.gp(_s59["S"], "ctx")
	J.mc(v_c_324, "save", [])
	var _t84 = _s59["__p"]["lean"]
	var _t86 = _s59["S"]
	var _t85 = J.gp(_s59["P"], "lean")
	var _t88 = (_t85 if J.t(_t85) else 0.0)
	var _t87 = J.gp(_s59["P"], "dx")
	J.cl(_t84, null, [_t86, _t88, 0.35, (_t87 if J.t(_t87) else 0.0), 0.0])
	var _t89 = _s59["__p"]["body"]
	var _t95 = _s59["S"]
	var _t90 = J.gp(_s59["P"], "head")
	var _t92 = (_t90 if J.t(_t90) else 0.0)
	var _t91 = J.gp(_s59["P"], "legF")
	var _t94 = (_t91 if J.t(_t91) else 0.0)
	var _t93 = J.gp(_s59["P"], "legB")
	J.cl(_t89, null, [_t95, "npc_boss", "npc_boss__bodyN", {"head": _t92, "legF": _t94, "legB": (_t93 if J.t(_t93) else 0.0)}])
	_s59["sh"] = J.mc(_s59["S"], "P", J.spread([J.SP(J.gp(_s59["__p"]["BOSS"], "SH"))]))
	v_el_326 = J.mc(_s59["S"], "P", J.spread([J.SP(J.gp(_s59["__p"]["BOSS"], "EL"))]))
	v_gl_327 = Callable(self, "_f40").bind(_s59)
	if J.t(J.gp(_s59["P"], "gloveBack")):
		J.cl(v_gl_327, null, [])
	var _t104 = _s59["__p"]["piece"]
	var _t108 = _s59["S"]
	var _t109 = J.gp(_s59["__p"]["BOSS"], "EL")
	var _t107 = J.gp(v_el_326, 0.0)
	var _t106 = J.gp(v_el_326, 1.0)
	var _t105 = J.gp(_s59["P"], "elUp")
	var _t111 = [_t107, J.sub(_t106, J.mul((_t105 if J.t(_t105) else 0.0), J.gp(_s59["S"], "H")))]
	var _t110 = J.gp(_s59["P"], "ball")
	J.cl(_t104, null, [_t108, "npc_boss__arm", _t109, _t111, (_t110 if J.t(_t110) else 0.0), 1.0, J.gp(_s59["P"], "bfn")])
	if (not J.t(J.gp(_s59["P"], "gloveBack"))):
		J.cl(v_gl_327, null, [])
	if J.t(v_after_323):
		J.cl(v_after_323, null, [])
	J.mc(v_c_324, "restore", [])

func _f47(this_, a: Array, env):
	var v_S_380 = null; var v_P_381 = null; var v_after_382 = null; var v_c_383 = null; var v_sh_384 = null; var v_fl_385 = null; var v_wr_386 = null
	v_S_380 = J.arg(a, 0)
	v_P_381 = J.arg(a, 1)
	v_after_382 = J.arg(a, 2)
	v_c_383 = J.gp(v_S_380, "ctx")
	J.mc(v_c_383, "save", [])
	var _t112 = env["lean"]
	var _t113 = J.gp(v_P_381, "lean")
	var _t115 = (_t113 if J.t(_t113) else 0.0)
	var _t114 = J.gp(v_P_381, "dy")
	J.cl(_t112, null, [v_S_380, _t115, 0.4, 0.0, (_t114 if J.t(_t114) else 0.0)])
	var _t116 = env["body"]
	var _t117 = J.gp(v_P_381, "head")
	J.cl(_t116, null, [v_S_380, "npc_guard", "npc_guard__bodyN", {"head": (_t117 if J.t(_t117) else 0.0)}])
	v_sh_384 = J.mc(v_S_380, "P", J.spread([J.SP(J.gp(env["GU"], "SH"))]))
	v_fl_385 = J.mc(v_S_380, "P", J.spread([J.SP(J.gp(env["GU"], "FL"))]))
	var _t118 = env["rotP"]
	var _t120 = J.gp(J.gp(env["GU"], "SH"), 0.0)
	var _t121 = J.gp(J.gp(env["GU"], "SH"), 1.0)
	var _t119 = J.gp(v_P_381, "arm")
	v_wr_386 = J.cl(_t118, null, [v_S_380, _t120, _t121, v_sh_384, (_t119 if J.t(_t119) else 0.0), J.gp(J.gp(env["GU"], "WR"), 0.0), J.gp(J.gp(env["GU"], "WR"), 1.0)])
	var _t122 = env["piece"]
	var _t126 = J.gp(env["GU"], "WR")
	var _t123 = J.gp(v_P_381, "arm")
	var _t125 = (_t123 if J.t(_t123) else 0.0)
	var _t124 = J.gp(v_P_381, "wrist")
	J.cl(_t122, null, [v_S_380, "npc_guard__tea", _t126, v_wr_386, J.add(_t125, (_t124 if J.t(_t124) else 0.0)), 1.0, J.gp(v_P_381, "tfn")])
	var _t127 = env["piece"]
	var _t129 = J.gp(env["GU"], "SH")
	var _t128 = J.gp(v_P_381, "arm")
	J.cl(_t127, null, [v_S_380, "npc_guard__sleeve", _t129, v_sh_384, (_t128 if J.t(_t128) else 0.0)])
	var _t130 = env["piece"]
	var _t132 = J.gp(env["GU"], "FL")
	var _t131 = J.gp(v_P_381, "fl")
	J.cl(_t130, null, [v_S_380, "npc_guard__arm", _t132, v_fl_385, (_t131 if J.t(_t131) else 0.0), 1.0, J.gp(v_P_381, "ffn")])
	if J.t(v_after_382):
		J.cl(v_after_382, null, [])
	J.mc(v_c_383, "restore", [])

func _f48(this_, a: Array, env):
	var v_S_389 = null; var v_L_390 = null; var v_p_391 = null; var v_ctx_392 = null; var v_g_393 = null; var v_dx_394 = null; var v_sx_395 = null; var v_sy_396 = null; var v_gx_397 = null; var v_gy_398 = null; var v_gr_399 = null
	v_S_389 = J.arg(a, 0)
	v_L_390 = J.arg(a, 1)
	v_p_391 = J.cl(v_L_390, null, J.spread([J.SP(J.gp(env["GU"], "FTIP"))]))
	v_ctx_392 = J.gp(v_S_389, "ctx")
	v_g_393 = J.mc(v_ctx_392, "createRadialGradient", [0.0, 0.0, 0.0, 0.0, 0.0, 1.0])
	v_dx_394 = ((-J.num(J.gp(v_S_389, "H"))) * 1.0)
	v_sx_395 = J.add(J.add(J.gp(v_p_391, 0.0), J.mul(v_dx_394, 1.0)), J.mul(J.add(J.gp(v_p_391, 1.0), 0.0), 0.0))
	v_sy_396 = 0.0
	J.mc(v_ctx_392, "save", [])
	J.sp(v_ctx_392, "globalCompositeOperation", "lighter")
	var _t133 = J.mul(J.gp(v_ctx_392, "globalAlpha"), J.mul(0.5, J.gp(v_S_389, "env")))
	J.sp(v_ctx_392, "globalAlpha", _t133)
	v_gx_397 = J.sub(J.gp(v_p_391, 0.0), J.mul(J.gp(v_S_389, "H"), 0.95))
	v_gy_398 = ((-J.num(J.gp(v_S_389, "H"))) * 0.01)
	v_gr_399 = J.mc(v_ctx_392, "createRadialGradient", [v_gx_397, v_gy_398, 0.0, v_gx_397, v_gy_398, J.mul(J.gp(v_S_389, "H"), 0.25)])
	J.mc(v_gr_399, "addColorStop", [0.0, "rgba(255,240,170,.5)"])
	J.mc(v_gr_399, "addColorStop", [1.0, "rgba(255,240,170,0)"])
	J.sp(v_ctx_392, "fillStyle", v_gr_399)
	J.mc(v_ctx_392, "translate", [v_gx_397, v_gy_398])
	J.mc(v_ctx_392, "scale", [1.0, 0.28])
	J.mc(v_ctx_392, "translate", [(-J.num(v_gx_397)), (-J.num(v_gy_398))])
	J.mc(v_ctx_392, "beginPath", [])
	J.mc(v_ctx_392, "arc", [v_gx_397, v_gy_398, J.mul(J.gp(v_S_389, "H"), 0.25), 0.0, J.mul(env["PI"], 2.0)])
	J.mc(v_ctx_392, "fill", [])
	J.mc(v_ctx_392, "restore", [])

func _f51(this_, a: Array, env):
	var v_L_427 = null; var v_p_428 = null
	v_L_427 = J.arg(a, 0)
	v_p_428 = J.cl(v_L_427, null, J.spread([J.SP(J.gp(env["__p"]["GU"], "CAP"))]))
	var _t142 = env["__p"]["steamCurl"]
	J.cl(_t142, null, [J.gp(env["S"], "ctx"), J.gp(v_p_428, 0.0), J.sub(J.gp(v_p_428, 1.0), J.mul(J.gp(env["S"], "H"), 0.02)), J.mul(J.gp(env["S"], "H"), 0.18), J.mod(J.mul(env["t"], 0.9), 1.0), 2.1, J.mul(0.6, env["k"])])

func _f50(this_, a: Array, env):
	var v_up_413 = null; var v_drink_414 = null; var v_sh_415 = null; var v_m_416 = null; var v_tgt_417 = null; var v_best_418 = null; var v_be_419 = null; var v_A_420 = null; var v_f_421 = null; var v_a1_422 = null; var v_a2_423 = null; var v_w_424 = null; var v_c_425 = null; var v_e_426 = null
	var _s72 = {"__p": env, "S": null, "t": null, "k": null}
	_s72["S"] = J.arg(a, 0)
	_s72["t"] = J.gp(_s72["S"], "at")
	_s72["k"] = J.gp(_s72["S"], "env")
	var _t134 = _s72["__p"]["kf"]
	v_up_413 = J.cl(_t134, null, [[[0.0, 0.0], [0.7, 1.0], [2.3, 1.0], [2.9, 0.0]], (J.min_([_s72["t"], 3.3]) if J.t(J.gp(_s72["S"], "dur")) else _s72["t"])])
	var _t135 = _s72["__p"]["bump"]
	v_drink_414 = J.cl(_t135, null, [_s72["t"], 0.9, 1.2, 2.2])
	v_sh_415 = J.mc(_s72["S"], "P", J.spread([J.SP(J.gp(_s72["__p"]["GU"], "SH"))]))
	v_m_416 = J.mc(_s72["S"], "P", J.spread([J.SP(J.gp(_s72["__p"]["GU"], "MOUTH"))]))
	v_tgt_417 = [J.add(J.gp(v_m_416, 0.0), (J.mul(J.gp(_s72["S"], "fs"), J.gp(_s72["S"], "W")) * 0.02)), J.add(J.gp(v_m_416, 1.0), J.mul(J.gp(_s72["S"], "H"), 0.03))]
	v_best_418 = [0.0, 0.0]
	v_be_419 = 1000000000.0
	v_a1_422 = 0.0
	while true:
		if not J.cmp(v_a1_422, 2.2, "<="): break
		v_a2_423 = (-2.4)
		while true:
			if not J.cmp(v_a2_423, 0.4, "<="): break
			var _t136 = _s72["__p"]["rotP"]
			v_w_424 = J.cl(_t136, null, [_s72["S"], J.gp(J.gp(_s72["__p"]["GU"], "SH"), 0.0), J.gp(J.gp(_s72["__p"]["GU"], "SH"), 1.0), v_sh_415, v_a1_422, J.gp(J.gp(_s72["__p"]["GU"], "WR"), 0.0), J.gp(J.gp(_s72["__p"]["GU"], "WR"), 1.0)])
			var _t137 = _s72["__p"]["rotP"]
			v_c_425 = J.cl(_t137, null, [_s72["S"], J.gp(J.gp(_s72["__p"]["GU"], "WR"), 0.0), J.gp(J.gp(_s72["__p"]["GU"], "WR"), 1.0), v_w_424, J.add(v_a1_422, v_a2_423), J.gp(J.gp(_s72["__p"]["GU"], "CAP"), 0.0), J.gp(J.gp(_s72["__p"]["GU"], "CAP"), 1.0)])
			v_e_426 = (J.hypot_([J.sub(J.gp(v_c_425, 0.0), J.gp(v_tgt_417, 0.0)), J.sub(J.gp(v_c_425, 1.0), J.gp(v_tgt_417, 1.0))]) + (J.mul(absf(J.num(J.sub(J.add(v_a1_422, v_a2_423), J.mul(J.gp(_s72["S"], "fs"), 0.55)))), J.gp(_s72["S"], "H")) * 0.03))
			if J.cmp(v_e_426, v_be_419, "<"):
				v_be_419 = v_e_426
				var _t138 = [v_a1_422, v_a2_423]
				v_best_418 = _t138
			var _t139 = J.add(v_a2_423, 0.05)
			v_a2_423 = _t139
		var _t140 = J.add(v_a1_422, 0.05)
		v_a1_422 = _t140
	v_A_420 = J.mul(_s72["k"], v_up_413)
	var _t141 = _s72["__p"]["guardDraw"]
	J.cl(_t141, null, [_s72["S"], {"arm": J.mul(J.gp(v_best_418, 0.0), v_A_420), "wrist": J.mul(J.sub(J.gp(v_best_418, 1.0), J.mul(v_drink_414, 0.25)), v_A_420), "head": (J.mul((-J.num(J.gp(_s72["S"], "fs"))), _s72["k"]) * (J.mul(v_up_413, 0.06) + J.mul(v_drink_414, 0.1))), "lean": (J.mul(J.mul((-J.num(J.gp(_s72["S"], "fs"))), _s72["k"]), v_drink_414) * 0.03), "fl": (J.mul(_s72["k"], v_up_413) * 0.05), "tfn": Callable(self, "_f51").bind(_s72)}])
	v_f_421 = J.mc(_s72["S"], "P", [0.45, 0.3])
	var _t143 = _s72["__p"]["puff"]
	var _t145 = J.gp(_s72["S"], "ctx")
	var _t146 = J.sub(J.gp(v_f_421, 0.0), (J.mul(J.gp(_s72["S"], "fs"), J.gp(_s72["S"], "W")) * 0.05))
	var _t147 = J.add(J.gp(v_f_421, 1.0), J.mul(J.gp(_s72["S"], "H"), 0.04))
	var _t148 = J.mul(J.gp(_s72["S"], "H"), 0.04)
	var _t144 = _s72["__p"]["seg"]
	J.cl(_t143, null, [_t145, _t146, _t147, _t148, J.cl(_t144, null, [_s72["t"], 2.3, 3.2]), 5.5])
	var _t149 = _s72["__p"]["text"]
	var _t151 = _s72["S"]
	var _t152 = J.sub(J.gp(v_f_421, 0.0), (J.mul(J.gp(_s72["S"], "fs"), J.gp(_s72["S"], "W")) * 0.35))
	var _t153 = J.sub(J.gp(v_f_421, 1.0), J.mul(J.gp(_s72["S"], "H"), 0.18))
	var _t154 = J.mul(J.gp(_s72["S"], "H"), 0.095)
	var _t150 = _s72["__p"]["bump"]
	J.cl(_t149, null, [_t151, _t152, _t153, "哈～", _t154, J.mul(J.cl(_t150, null, [_s72["t"], 2.3, 2.5, 3.1]), _s72["k"])])

func _f54(this_, a: Array, env):
	var v_S_446 = null; var v_ax_447 = null; var v_ay_448 = null; var v_L_449 = null
	v_S_446 = J.arg(a, 0)
	v_ax_447 = J.mul(J.sub(J.gp(J.gp(env["AU"], "BOT"), 0.0), J.gp(J.gp(env["AU"], "TOP"), 0.0)), J.gp(v_S_446, "W"))
	v_ay_448 = J.mul(J.sub(J.gp(J.gp(env["AU"], "BOT"), 1.0), J.gp(J.gp(env["AU"], "TOP"), 1.0)), J.gp(v_S_446, "H"))
	v_L_449 = J.hypot_([v_ax_447, v_ay_448])
	return {"ux": J.div(v_ax_447, v_L_449), "uy": J.div(v_ay_448, v_L_449), "L": v_L_449}

func _f55(this_, a: Array, env):
	var v_S_452 = null; var v_fx_453 = null; var v_fy_454 = null; var v_th_455 = null; var v_s_456 = null; var v_A_457 = null; var v_hx_458 = null; var v_hy_459 = null; var v_c_460 = null; var v_sn_461 = null
	v_S_452 = J.arg(a, 0)
	v_fx_453 = J.arg(a, 1)
	v_fy_454 = J.arg(a, 2)
	v_th_455 = J.arg(a, 3)
	v_s_456 = J.arg(a, 4)
	var _t155 = env["auAxis"]
	v_A_457 = J.cl(_t155, null, [v_S_452])
	v_hx_458 = (J.mul(J.sub(J.gp(J.gp(env["AU"], "HEAD"), 0.0), J.gp(J.gp(env["AU"], "FIST"), 0.0)), J.gp(v_S_452, "W")) - J.mul(J.mul(J.gp(v_A_457, "ux"), v_s_456), J.gp(v_A_457, "L")))
	v_hy_459 = (J.mul(J.sub(J.gp(J.gp(env["AU"], "HEAD"), 1.0), J.gp(J.gp(env["AU"], "FIST"), 1.0)), J.gp(v_S_452, "H")) - J.mul(J.mul(J.gp(v_A_457, "uy"), v_s_456), J.gp(v_A_457, "L")))
	v_c_460 = cos(J.num(v_th_455))
	v_sn_461 = sin(J.num(v_th_455))
	return [J.sub(J.add(v_fx_453, J.mul(v_hx_458, v_c_460)), J.mul(v_hy_459, v_sn_461)), J.add(J.add(v_fy_454, J.mul(v_hx_458, v_sn_461)), J.mul(v_hy_459, v_c_460))]

func _f56(this_, a: Array, env):
	var v_S_464 = null; var v_fx_465 = null; var v_fy_466 = null; var v_th_467 = null; var v_floor_468 = null; var v_h0_469 = null; var v_h1_470 = null
	v_S_464 = J.arg(a, 0)
	v_fx_465 = J.arg(a, 1)
	v_fy_466 = J.arg(a, 2)
	v_th_467 = J.arg(a, 3)
	v_floor_468 = J.arg(a, 4)
	var _t156 = env["auHead"]
	v_h0_469 = J.cl(_t156, null, [v_S_464, v_fx_465, v_fy_466, v_th_467, 0.0])
	var _t157 = env["auHead"]
	v_h1_470 = J.cl(_t157, null, [v_S_464, v_fx_465, v_fy_466, v_th_467, 1.0])
	var _t158 = env["cl"]
	var _t160 = J.sub(v_floor_468, J.gp(v_h0_469, 1.0))
	var _t159 = J.sub(J.gp(v_h1_470, 1.0), J.gp(v_h0_469, 1.0))
	return J.cl(_t158, null, [J.div(_t160, (_t159 if J.t(_t159) else 0.000001)), 0.0, 1.05])

func _f58(this_, a: Array, env):
	var v_u_481 = null; var v_v_482 = null
	v_u_481 = J.arg(a, 0)
	v_v_482 = J.arg(a, 1)
	return [J.mul(J.sub(v_u_481, J.gp(J.gp(env["__p"]["AU"], "FIST"), 0.0)), J.gp(env["S"], "W")), J.mul(J.sub(v_v_482, J.gp(J.gp(env["__p"]["AU"], "FIST"), 1.0)), J.gp(env["S"], "H"))]

func _f57(this_, a: Array, env):
	var v_fx_474 = null; var v_fy_475 = null; var v_th_476 = null; var v_s_477 = null; var v_wfn_478 = null; var v_ctx_479 = null; var v_A_480 = null
	var _s83 = {"__p": env, "S": null}
	_s83["S"] = J.arg(a, 0)
	v_fx_474 = J.arg(a, 1)
	v_fy_475 = J.arg(a, 2)
	v_th_476 = J.arg(a, 3)
	v_s_477 = J.arg(a, 4)
	v_wfn_478 = J.arg(a, 5)
	v_ctx_479 = J.gp(_s83["S"], "ctx")
	var _t161 = _s83["__p"]["auAxis"]
	v_A_480 = J.cl(_t161, null, [_s83["S"]])
	J.mc(v_ctx_479, "save", [])
	J.mc(v_ctx_479, "translate", [v_fx_474, v_fy_475])
	J.mc(v_ctx_479, "rotate", [v_th_476])
	J.mc(v_ctx_479, "translate", [J.mul(J.mul((-J.num(J.gp(v_A_480, "ux"))), v_s_477), J.gp(v_A_480, "L")), J.mul(J.mul((-J.num(J.gp(v_A_480, "uy"))), v_s_477), J.gp(v_A_480, "L"))])
	J.mc(v_ctx_479, "drawImage", [J.gp(J.G.get("SPR"), "npc_auntie__mop"), J.mul((-J.num(J.gp(J.gp(_s83["__p"]["AU"], "FIST"), 0.0))), J.gp(_s83["S"], "W")), J.mul((-J.num(J.gp(J.gp(_s83["__p"]["AU"], "FIST"), 1.0))), J.gp(_s83["S"], "H")), J.gp(_s83["S"], "W"), J.gp(_s83["S"], "H")])
	if J.t(v_wfn_478):
		J.cl(v_wfn_478, null, [Callable(self, "_f58").bind(_s83)])
	J.mc(v_ctx_479, "restore", [])

func _f60(this_, a: Array, env):
	var v_S_486 = null; var v_P_487 = null; var v_c_488 = null; var v_handOK_489 = null; var v_f_490 = null; var v_w_491 = null; var v_th_492 = null; var v_want_493 = null; var v_ha_494 = null; var v_cs_495 = null; var v_sn_496 = null; var v_rx_497 = null; var v_ry_498 = null; var v_fx_499 = null; var v_fy_500 = null; var v_s_501 = null
	v_S_486 = J.arg(a, 0)
	v_P_487 = J.arg(a, 1)
	v_c_488 = J.gp(v_S_486, "ctx")
	J.mc(v_c_488, "save", [])
	var _t162 = env["lean"]
	var _t163 = J.gp(v_P_487, "lean")
	var _t165 = (_t163 if J.t(_t163) else 0.0)
	var _t164 = J.gp(v_P_487, "dx")
	J.cl(_t162, null, [v_S_486, _t165, 0.35, (_t164 if J.t(_t164) else 0.0), 0.0])
	var _t166 = env["ok"]
	var _t168 = J.cl(_t166, null, ["npc_auntie__hand"])
	if J.t(_t168):
		var _t167 = env["ok"]
		_t168 = J.cl(_t167, null, ["npc_auntie__bodyM"])
	v_handOK_489 = _t168
	var _t169 = env["body"]
	var _t175 = ("npc_auntie__bodyM" if J.t(v_handOK_489) else "npc_auntie__bodyH")
	var _t170 = J.gp(v_P_487, "head")
	var _t172 = (_t170 if J.t(_t170) else 0.0)
	var _t171 = J.gp(v_P_487, "legF")
	var _t174 = (_t171 if J.t(_t171) else 0.0)
	var _t173 = J.gp(v_P_487, "legB")
	J.cl(_t169, null, [v_S_486, "npc_auntie", _t175, {"head": _t172, "legF": _t174, "legB": (_t173 if J.t(_t173) else 0.0)}])
	v_f_490 = J.mc(v_S_486, "P", J.spread([J.SP(J.gp(env["AU"], "FIST"))]))
	v_w_491 = J.mc(v_S_486, "P", J.spread([J.SP(env["WR"])]))
	var _t176 = J.gp(v_P_487, "th")
	v_th_492 = (_t176 if J.t(_t176) else 0.0)
	var _t178 = J.gp(v_f_490, 0.0)
	var _t177 = J.gp(v_P_487, "fx")
	var _t181 = J.add(_t178, J.mul((_t177 if J.t(_t177) else 0.0), J.gp(v_S_486, "H")))
	var _t180 = J.gp(v_f_490, 1.0)
	var _t179 = J.gp(v_P_487, "fy")
	v_want_493 = [_t181, J.add(_t180, J.mul((_t179 if J.t(_t179) else 0.0), J.gp(v_S_486, "H")))]
	v_ha_494 = (atan2(J.num(J.sub(J.gp(v_want_493, 1.0), J.gp(v_w_491, 1.0))), J.num(J.sub(J.gp(v_want_493, 0.0), J.gp(v_w_491, 0.0)))) - atan2(J.num(J.sub(J.gp(v_f_490, 1.0), J.gp(v_w_491, 1.0))), J.num(J.sub(J.gp(v_f_490, 0.0), J.gp(v_w_491, 0.0)))))
	while true:
		if not J.cmp(v_ha_494, env["PI"], ">"): break
		var _t182 = J.sub(v_ha_494, J.mul(2.0, env["PI"]))
		v_ha_494 = _t182
	while true:
		if not J.cmp(v_ha_494, (-J.num(env["PI"])), "<"): break
		var _t183 = J.add(v_ha_494, J.mul(2.0, env["PI"]))
		v_ha_494 = _t183
	var _t184 = env["cl"]
	var _t186 = J.cl(_t184, null, [v_ha_494, (-0.55), 0.55])
	var _t185 = J.gp(v_P_487, "fa")
	var _t187 = J.add(_t186, (_t185 if J.t(_t185) else 0.0))
	v_ha_494 = _t187
	v_cs_495 = cos(J.num(v_ha_494))
	v_sn_496 = sin(J.num(v_ha_494))
	v_rx_497 = J.sub(J.gp(v_f_490, 0.0), J.gp(v_w_491, 0.0))
	v_ry_498 = J.sub(J.gp(v_f_490, 1.0), J.gp(v_w_491, 1.0))
	v_fx_499 = (J.sub(J.add(J.gp(v_w_491, 0.0), J.mul(v_rx_497, v_cs_495)), J.mul(v_ry_498, v_sn_496)) if J.t(v_handOK_489) else J.gp(v_want_493, 0.0))
	v_fy_500 = (J.add(J.add(J.gp(v_w_491, 1.0), J.mul(v_rx_497, v_sn_496)), J.mul(v_ry_498, v_cs_495)) if J.t(v_handOK_489) else J.gp(v_want_493, 1.0))
	var _t188 = J.gp(v_P_487, "s")
	v_s_501 = (_t188 if J.t(_t188) else 0.0)
	if (not J.leq(J.gp(v_P_487, "floor"), null)):
		var _t189 = env["lerp"]
		var _t190 = env["auReach"]
		var _t191 = J.cl(_t189, null, [0.0, J.cl(_t190, null, [v_S_486, v_fx_499, v_fy_500, v_th_492, J.gp(v_P_487, "floor")]), (1.0 if J.leq(J.gp(v_P_487, "reach"), null) else J.gp(v_P_487, "reach"))])
		v_s_501 = _t191
	var _t192 = env["auMop"]
	J.cl(_t192, null, [v_S_486, v_fx_499, v_fy_500, v_th_492, v_s_501, J.gp(v_P_487, "mfn")])
	if J.t(v_handOK_489):
		var _t193 = env["piece"]
		J.cl(_t193, null, [v_S_486, "npc_auntie__hand", env["WR"], v_w_491, v_ha_494])
	else:
		var _t194 = env["piece"]
		var _t198 = J.gp(env["AU"], "FIST")
		var _t199 = [v_fx_499, v_fy_500]
		var _t195 = env["resid"]
		var _t197 = J.cl(_t195, null, [v_th_492])
		var _t196 = J.gp(v_P_487, "fa")
		J.cl(_t194, null, [v_S_486, "npc_auntie__fist", _t198, _t199, J.add(_t197, (_t196 if J.t(_t196) else 0.0))])
	if J.t(J.gp(v_P_487, "hip")):
		J.mc(v_P_487, "hip", [v_fx_499, v_fy_500, v_th_492, v_s_501])
	else:
		var _t200 = env["piece"]
		var _t202 = J.gp(env["AU"], "SH")
		var _t203 = J.mc(v_S_486, "P", J.spread([J.SP(J.gp(env["AU"], "SH"))]))
		var _t201 = J.gp(v_P_487, "hipA")
		J.cl(_t200, null, [v_S_486, "npc_auntie__hip", _t202, _t203, (_t201 if J.t(_t201) else 0.0)])
	J.mc(v_c_488, "restore", [])
	return {"fx": v_fx_499, "fy": v_fy_500, "th": v_th_492, "s": v_s_501}

func _f77(this_, a: Array, env):
	var v_S_635 = null; var v_rig_636 = null; var v_key_637 = null; var v_add_638 = null; var v_z_639 = null; var v_k_640 = null
	v_S_635 = J.arg(a, 0)
	v_rig_636 = J.arg(a, 1)
	v_key_637 = J.arg(a, 2)
	v_add_638 = J.arg(a, 3)
	v_z_639 = J.S_Object_("assign", [{}, J.gp(v_S_635, "z")])
	J.sp(v_z_639, "x", 0.0)
	J.sp(v_z_639, "y", 0.0)
	J.sp(v_z_639, "sx", 1.0)
	J.sp(v_z_639, "sy", 1.0)
	J.sp(v_z_639, "rot", 0.0)
	J.sp(v_z_639, "legF", 0.0)
	J.sp(v_z_639, "legB", 0.0)
	for _t204 in J.keys(v_add_638):
		v_k_640 = _t204
		var _t205 = J.gp(v_z_639, v_k_640)
		var _t206 = J.add((_t205 if J.t(_t205) else 0.0), J.gp(v_add_638, v_k_640))
		J.sp(v_z_639, v_k_640, _t206)
	J.mc(J.G.get("MeshAnim"), "drawBody", [J.gp(v_S_635, "ctx"), v_rig_636, v_key_637, J.gp(v_S_635, "H"), v_z_639])

func _f91(this_, a: Array, env):
	var v_S_759 = null; var v_p_760 = null
	v_S_759 = J.arg(a, 0)
	var _t207 = J.gp(J.gp(v_S_759, "o"), "prop")
	v_p_760 = (_t207 if J.t(_t207) else {})
	if J.leq(J.gp(v_p_760, "potDX"), null):
		return [(J.mul(J.gp(v_S_759, "fs"), J.gp(v_S_759, "H")) * 0.42), ((-J.num(J.gp(v_S_759, "H"))) * 0.47)]
	return [J.div(J.mul(((-1.0) if J.t(J.gp(v_S_759, "flip")) else 1.0), J.gp(v_p_760, "potDX")), J.gp(J.gp(v_S_759, "z"), "sx")), J.div(J.sub(J.gp(v_p_760, "potDY"), J.mul(J.gp(J.gp(v_S_759, "z"), "y"), J.gp(v_S_759, "H"))), J.gp(J.gp(v_S_759, "z"), "sy"))]

func _f92(this_, a: Array, env):
	var v_ctx_763 = null; var v_x_764 = null; var v_y_765 = null; var v_s_766 = null; var v_k_767 = null; var v_t_768 = null; var v_i_769 = null; var v_ox_770 = null; var v_len_771 = null; var v_sw_772 = null
	v_ctx_763 = J.arg(a, 0)
	v_x_764 = J.arg(a, 1)
	v_y_765 = J.arg(a, 2)
	v_s_766 = J.arg(a, 3)
	v_k_767 = J.arg(a, 4)
	v_t_768 = J.arg(a, 5)
	if J.cmp(v_k_767, 0.0, "<="):
		return null
	J.mc(v_ctx_763, "save", [])
	var _t208 = env["cl"]
	var _t209 = J.mul(J.gp(v_ctx_763, "globalAlpha"), J.cl(_t208, null, [v_k_767]))
	J.sp(v_ctx_763, "globalAlpha", _t209)
	v_i_769 = 0.0
	while true:
		if not J.cmp(v_i_769, 6.0, "<"): break
		v_ox_770 = (J.mul(J.sub(v_i_769, 2.5), v_s_766) * 0.07)
		var _t210 = env["rnd"]
		v_len_771 = J.mul(v_s_766, (0.22 + J.mul(0.16, J.cl(_t210, null, [J.add(v_i_769, 3.0)]))))
		v_sw_772 = (J.mul(sin(J.num(J.add(J.mul(v_t_768, 6.0), v_i_769))), v_s_766) * 0.04)
		var _t211 = env["crayon"]
		J.cl(_t211, null, [v_ctx_763, [[J.add(v_x_764, v_ox_770), v_y_765], [J.add(J.add(v_x_764, v_ox_770), J.mul(v_sw_772, 0.5)), J.add(v_y_765, J.mul(v_len_771, 0.5))], [J.add(J.add(v_x_764, v_ox_770), v_sw_772), J.add(v_y_765, v_len_771)]], J.max_([1.2, J.mul(v_s_766, 0.03)]), "#f4d77a", "rgba(110,70,20,.55)"])
		v_i_769 = J.num(v_i_769) + 1.0
	J.mc(v_ctx_763, "restore", [])

func _f93(this_, a: Array, env):
	var v_S_775 = null; var v_hx_776 = null; var v_hy_777 = null; var v_ang_778 = null; var v_nood_779 = null; var v_t_780 = null; var v_clipY_781 = null; var v_ctx_782 = null; var v_im_783 = null; var v_h_784 = null; var v_w_785 = null; var v_net_786 = null; var v_c_787 = null; var v_s_788 = null
	v_S_775 = J.arg(a, 0)
	v_hx_776 = J.arg(a, 1)
	v_hy_777 = J.arg(a, 2)
	v_ang_778 = J.arg(a, 3)
	v_nood_779 = J.arg(a, 4)
	v_t_780 = J.arg(a, 5)
	v_clipY_781 = J.arg(a, 6)
	v_ctx_782 = J.gp(v_S_775, "ctx")
	var _t212 = env["ok"]
	if (not J.t(J.cl(_t212, null, ["street_strainer"]))):
		return null
	v_im_783 = J.gp(J.G.get("SPR"), "street_strainer")
	v_h_784 = J.mul(J.gp(v_S_775, "H"), 0.34)
	v_w_785 = J.div(J.mul(v_h_784, J.gp(v_im_783, "naturalWidth")), J.gp(v_im_783, "naturalHeight"))
	J.mc(v_ctx_782, "save", [])
	if (not J.leq(v_clipY_781, null)):
		J.mc(v_ctx_782, "beginPath", [])
		J.mc(v_ctx_782, "rect", [((-J.num(J.gp(v_S_775, "H"))) * 5.0), ((-J.num(J.gp(v_S_775, "H"))) * 5.0), J.mul(J.gp(v_S_775, "H"), 10.0), J.add(v_clipY_781, J.mul(J.gp(v_S_775, "H"), 5.0))])
		J.mc(v_ctx_782, "clip", [])
	J.mc(v_ctx_782, "translate", [v_hx_776, v_hy_777])
	J.mc(v_ctx_782, "rotate", [v_ang_778])
	J.mc(v_ctx_782, "drawImage", [v_im_783, J.div((-J.num(v_w_785)), 2.0), ((-J.num(v_h_784)) * 0.1), v_w_785, v_h_784])
	v_net_786 = [0.0, J.mul(v_h_784, 0.68)]
	if J.cmp(v_nood_779, 0.0, ">"):
		var _t213 = env["noodles"]
		J.cl(_t213, null, [v_ctx_782, J.gp(v_net_786, 0.0), J.add(J.gp(v_net_786, 1.0), J.mul(v_h_784, 0.12)), v_h_784, v_nood_779, v_t_780])
	v_c_787 = cos(J.num(v_ang_778))
	v_s_788 = sin(J.num(v_ang_778))
	J.mc(v_ctx_782, "restore", [])
	return {"x": J.sub(J.add(v_hx_776, J.mul(J.gp(v_net_786, 0.0), v_c_787)), J.mul(J.gp(v_net_786, 1.0), v_s_788)), "y": J.add(J.add(v_hy_777, J.mul(J.gp(v_net_786, 0.0), v_s_788)), J.mul(J.gp(v_net_786, 1.0), v_c_787))}

func _f94(this_, a: Array, env):
	var v_S_791 = null; var v_mode_792 = null; var v_ctx_793 = null; var v_t_794 = null; var v_k_795 = null; var v_pot_796 = null; var v_pv_797 = null; var v_at_798 = null; var v_G0_799 = null; var v_g0_800 = null; var v_tx_801 = null; var v_ty_802 = null; var v_sAng_803 = null; var v_nood_804 = null; var v_headA_805 = null; var v_txt_806 = null; var v_ta_807 = null; var v_clip_808 = null; var v_rot_809 = null; var v_dx_810 = null; var v_dy_811 = null; var v_ang_812 = null; var v_hp_813 = null; var v_an_814 = null; var v_q_815 = null; var v_lift_816 = null; var v_up_817 = null; var v_m_818 = null; var v_chew_819 = null; var v_look_820 = null; var v_net_821 = null; var v_h_822 = null
	v_S_791 = J.arg(a, 0)
	v_mode_792 = J.arg(a, 1)
	v_ctx_793 = J.gp(v_S_791, "ctx")
	v_t_794 = J.gp(v_S_791, "at")
	v_k_795 = J.gp(v_S_791, "env")
	var _t214 = env["eguiPot"]
	v_pot_796 = J.cl(_t214, null, [v_S_791])
	v_pv_797 = [0.12, 0.5]
	v_at_798 = J.mc(v_S_791, "P", J.spread([J.SP(v_pv_797)]))
	v_G0_799 = [0.1, 0.3]
	v_g0_800 = J.mc(v_S_791, "P", J.spread([J.SP(v_G0_799)]))
	v_tx_801 = J.gp(v_pot_796, 0.0)
	v_ty_802 = J.sub(J.gp(v_pot_796, 1.0), J.mul(J.gp(v_S_791, "H"), 0.31))
	v_sAng_803 = 0.0
	v_nood_804 = 0.0
	v_headA_805 = J.mul(J.gp(v_S_791, "fs"), 0.12)
	v_txt_806 = ""
	v_ta_807 = 0.0
	v_clip_808 = true
	v_rot_809 = 0.0
	if J.seq(v_mode_792, "stir"):
		v_an_814 = J.mul(v_t_794, 4.2)
		var _t215 = J.add(v_tx_801, (J.mul(cos(J.num(v_an_814)), J.gp(v_S_791, "H")) * 0.035))
		v_tx_801 = _t215
		var _t216 = J.add(v_ty_802, (J.mul(J.gp(v_S_791, "H"), 0.05) + (J.mul(sin(J.num(v_an_814)), J.gp(v_S_791, "H")) * 0.012)))
		v_ty_802 = _t216
		var _t217 = (cos(J.num(v_an_814)) * 0.15)
		v_sAng_803 = _t217
		var _t218 = J.mul(J.gp(v_S_791, "fs"), (0.14 + (sin(J.num(v_an_814)) * 0.02)))
		v_headA_805 = _t218
		var _t219 = (sin(J.num(v_an_814)) * 0.04)
		v_rot_809 = _t219
	if J.seq(v_mode_792, "ladle"):
		v_q_815 = J.mod(v_t_794, 3.0)
		var _t220 = env["kf"]
		v_lift_816 = J.cl(_t220, null, [[[0.0, 0.0], [0.5, 0.15], [0.9, (-0.1)], [1.4, 1.0], [2.4, 1.0], [3.0, 0.0]], v_q_815])
		var _t221 = J.add(v_ty_802, J.mul(J.gp(v_S_791, "H"), (0.06 - J.mul(v_lift_816, 0.16))))
		v_ty_802 = _t221
		var _t222 = (J.mul((-J.num(J.gp(v_S_791, "fs"))), v_lift_816) * 0.12)
		v_sAng_803 = _t222
		var _t223 = env["seg"]
		var _t225 = J.cl(_t223, null, [v_q_815, 1.0, 1.4])
		var _t224 = env["seg"]
		var _t226 = J.mul(_t225, J.sub(1.0, J.cl(_t224, null, [v_q_815, 2.5, 2.9])))
		v_nood_804 = _t226
		var _t227 = J.mul(J.gp(v_S_791, "fs"), (0.12 - J.mul(v_lift_816, 0.06)))
		v_headA_805 = _t227
		var _t228 = (J.mul((-J.num(J.gp(v_S_791, "fs"))), v_lift_816) * 0.1)
		v_rot_809 = _t228
	if J.seq(v_mode_792, "taste"):
		var _t229 = env["kf"]
		v_up_817 = J.cl(_t229, null, [[[0.0, 0.0], [0.5, 0.45], [1.0, 1.0], [2.2, 1.0], [2.6, 0.3], [3.3, 0.0]], v_t_794])
		v_m_818 = J.mc(v_S_791, "P", [0.47, 0.34])
		var _t231 = sin(J.num(J.mul(v_t_794, 14.0)))
		var _t230 = env["seg"]
		var _t233 = J.mul(_t231, J.cl(_t230, null, [v_t_794, 1.0, 1.1]))
		var _t232 = env["seg"]
		v_chew_819 = (_t233 * J.sub(1.0, J.cl(_t232, null, [v_t_794, 1.8, 1.9])))
		var _t235 = sin(J.num((J.sub(v_t_794, 1.9) * 8.0)))
		var _t234 = env["bump"]
		v_look_820 = J.mul(_t235, J.cl(_t234, null, [v_t_794, 1.9, 2.1, 2.7]))
		var _t236 = env["lerp"]
		var _t237 = J.cl(_t236, null, [v_tx_801, J.add(J.gp(v_m_818, 0.0), (J.mul(J.gp(v_S_791, "fs"), J.gp(v_S_791, "W")) * 0.1)), v_up_817])
		v_tx_801 = _t237
		var _t238 = env["lerp"]
		var _t239 = J.cl(_t238, null, [J.add(v_ty_802, J.mul(J.gp(v_S_791, "H"), 0.05)), J.sub(J.gp(v_m_818, 1.0), J.mul(J.gp(v_S_791, "H"), 0.22)), v_up_817])
		v_ty_802 = _t239
		var _t240 = (J.mul((-J.num(J.gp(v_S_791, "fs"))), v_up_817) * 0.6)
		v_sAng_803 = _t240
		var _t241 = env["seg"]
		var _t242 = (J.sub(1.0, J.cl(_t241, null, [v_t_794, 1.0, 1.15])) * J.min_([1.0, (J.div(v_t_794, 0.3) + 0.0001)]))
		v_nood_804 = _t242
		var _t243 = ((J.mul(J.gp(v_S_791, "fs"), (0.1 - J.mul(v_up_817, 0.1))) + J.mul(v_chew_819, 0.04)) + J.mul(v_look_820, 0.18))
		v_headA_805 = _t243
		var _t244 = ("嗯～" if J.cmp(v_t_794, 1.9, "<") else "……")
		v_txt_806 = _t244
		var _t245 = env["bump"]
		var _t247 = J.cl(_t245, null, [v_t_794, 1.1, 1.3, 2.0])
		var _t246 = env["bump"]
		var _t248 = J.add(_t247, J.mul(J.cl(_t246, null, [v_t_794, 2.0, 2.2, 2.7]), 0.8))
		v_ta_807 = _t248
		var _t249 = J.cmp(v_up_817, 0.2, "<")
		v_clip_808 = _t249
		var _t250 = (J.mul((-J.num(J.gp(v_S_791, "fs"))), v_up_817) * 0.25)
		v_rot_809 = _t250
	v_dx_810 = J.mul(J.sub(v_tx_801, J.gp(v_g0_800, 0.0)), v_k_795)
	v_dy_811 = J.mul(J.sub(v_ty_802, J.gp(v_g0_800, 1.0)), v_k_795)
	v_ang_812 = J.mul(v_rot_809, v_k_795)
	var _t251 = env["body"]
	J.cl(_t251, null, [v_S_791, "eguiking", "eguiking__body", {"head": J.mul(v_headA_805, v_k_795)}])
	var _t252 = env["rotP"]
	v_hp_813 = J.cl(_t252, null, [v_S_791, J.gp(v_pv_797, 0.0), J.gp(v_pv_797, 1.0), [J.add(J.gp(v_at_798, 0.0), v_dx_810), J.add(J.gp(v_at_798, 1.0), v_dy_811)], v_ang_812, J.gp(v_G0_799, 0.0), J.gp(v_G0_799, 1.0)])
	if J.cmp(v_k_795, 0.02, ">"):
		J.mc(v_ctx_793, "save", [])
		var _t253 = env["ss"]
		var _t254 = J.mul(J.gp(v_ctx_793, "globalAlpha"), J.cl(_t253, null, [J.mul(v_k_795, 1.5)]))
		J.sp(v_ctx_793, "globalAlpha", _t254)
		var _t255 = env["strainer"]
		v_net_821 = J.cl(_t255, null, [v_S_791, J.gp(v_hp_813, 0.0), J.gp(v_hp_813, 1.0), J.add(J.mul(v_sAng_803, v_k_795), v_ang_812), J.mul(v_nood_804, v_k_795), v_t_794, (J.gp(v_pot_796, 1.0) if J.t(v_clip_808) else null)])
		if J.t((J.cmp(v_nood_804, 0.0, ">") if J.t(v_net_821) else v_net_821)):
			var _t256 = env["steamCurl"]
			J.cl(_t256, null, [v_ctx_793, J.gp(v_net_821, "x"), J.sub(J.gp(v_net_821, "y"), J.mul(J.gp(v_S_791, "H"), 0.02)), J.mul(J.gp(v_S_791, "H"), 0.22), J.mod(J.mul(v_t_794, 0.8), 1.0), 1.7, J.mul(v_nood_804, v_k_795)])
			var _t257 = env["drop"]
			J.cl(_t257, null, [v_ctx_793, J.gp(v_net_821, "x"), J.add(J.gp(v_net_821, "y"), J.mul(J.gp(v_S_791, "H"), 0.06)), J.mul(J.gp(v_S_791, "H"), 0.008), J.mod(J.mul(v_t_794, 1.5), 1.0), J.mul(J.gp(v_S_791, "H"), 0.1)])
		var _t258 = J.seq(v_mode_792, "stir")
		if (J.cmp(v_k_795, 0.5, ">") if _t258 else _t258):
			var _t259 = env["steamCurl"]
			J.cl(_t259, null, [v_ctx_793, J.add(J.gp(v_pot_796, 0.0), (J.mul(sin(J.num(v_t_794)), J.gp(v_S_791, "H")) * 0.04)), J.sub(J.gp(v_pot_796, 1.0), J.mul(J.gp(v_S_791, "H"), 0.03)), J.mul(J.gp(v_S_791, "H"), 0.3), J.mod(J.mul(v_t_794, 0.5), 1.0), 4.4, 0.6])
		J.mc(v_ctx_793, "restore", [])
	var _t260 = env["piece"]
	J.cl(_t260, null, [v_S_791, "eguiking__hand", v_pv_797, [J.add(J.gp(v_at_798, 0.0), v_dx_810), J.add(J.gp(v_at_798, 1.0), v_dy_811)], v_ang_812])
	if J.cmp(v_ta_807, 0.0, ">"):
		v_h_822 = J.mc(v_S_791, "P", [0.5, 0.05])
		var _t261 = env["text"]
		J.cl(_t261, null, [v_S_791, J.sub(J.gp(v_h_822, 0.0), (J.mul(J.gp(v_S_791, "fs"), J.gp(v_S_791, "W")) * 0.35)), J.gp(v_h_822, 1.0), v_txt_806, J.mul(J.gp(v_S_791, "H"), 0.1), J.mul(v_ta_807, v_k_795)])

func _f100(this_, a: Array, env):
	var v_S_861 = null; var v_key_862 = null; var v_x_863 = null; var v_y_864 = null; var v_w_865 = null; var v_len_866 = null; var v_t_867 = null; var v_walk_868 = null; var v_ctx_869 = null; var v_sw_870 = null
	v_S_861 = J.arg(a, 0)
	v_key_862 = J.arg(a, 1)
	v_x_863 = J.arg(a, 2)
	v_y_864 = J.arg(a, 3)
	v_w_865 = J.arg(a, 4)
	v_len_866 = J.arg(a, 5)
	v_t_867 = J.arg(a, 6)
	v_walk_868 = J.arg(a, 7)
	v_ctx_869 = J.gp(v_S_861, "ctx")
	v_sw_870 = (((sin(J.num((J.mul(v_t_867, 7.0) - 0.9))) * 0.22) if J.t(v_walk_868) else (sin(J.num(J.mul(v_t_867, 1.7))) * 0.06)) + (((-J.num(J.gp(v_S_861, "fs"))) * 0.12) if J.t(v_walk_868) else 0.0))
	J.mc(v_ctx_869, "save", [])
	J.mc(v_ctx_869, "translate", [v_x_863, v_y_864])
	J.mc(v_ctx_869, "rotate", [v_sw_870])
	J.sp(v_ctx_869, "strokeStyle", "rgba(40,28,24,.9)")
	var _t262 = J.max_([1.0, J.mul(J.gp(v_S_861, "H"), 0.008)])
	J.sp(v_ctx_869, "lineWidth", _t262)
	J.mc(v_ctx_869, "beginPath", [])
	J.mc(v_ctx_869, "moveTo", [0.0, 0.0])
	J.mc(v_ctx_869, "lineTo", [0.0, v_len_866])
	J.mc(v_ctx_869, "stroke", [])
	var _t263 = env["prop"]
	J.cl(_t263, null, [v_ctx_869, v_key_862, 0.0, v_len_866, v_w_865, ((-J.num(v_sw_870)) * 0.4), 0.5, 0.04])
	J.mc(v_ctx_869, "restore", [])

func _f102(this_, a: Array, env):
	var v_L_884 = null; var v_h_885 = null
	v_L_884 = J.arg(a, 0)
	v_h_885 = J.cl(v_L_884, null, J.spread([J.SP(J.gp(env["G"], "tip"))]))
	var _t277 = J.seq(env["kind"], "lanternW")
	if (_t277 if _t277 else J.seq(env["kind"], "lanternR")):
		var _t278 = env["__p"]["hang"]
		var _t281 = env["S"]
		var _t282 = ("street_lanternW" if J.seq(env["kind"], "lanternW") else "street_lanternR")
		var _t283 = J.gp(v_h_885, 0.0)
		var _t284 = J.gp(v_h_885, 1.0)
		var _t280 = J.mul(J.gp(env["S"], "H"), 0.24)
		var _t279 = J.gp(env["pr"], "big")
		J.cl(_t278, null, [_t281, _t282, _t283, _t284, J.mul(_t280, (_t279 if J.t(_t279) else 1.0)), J.mul(J.gp(env["S"], "H"), 0.06), env["t"], J.gp(env["S"], "walk")])
	if J.seq(env["kind"], "bag"):
		var _t285 = env["__p"]["hang"]
		J.cl(_t285, null, [env["S"], "bun__basket", J.gp(v_h_885, 0.0), J.gp(v_h_885, 1.0), J.mul(J.gp(env["S"], "H"), 0.3), J.mul(J.gp(env["S"], "H"), 0.03), env["t"], J.gp(env["S"], "walk")])
	if J.seq(env["kind"], "phone"):
		var _t286 = env["__p"]["prop"]
		J.cl(_t286, null, [env["ctx"], "afu__phone", J.gp(v_h_885, 0.0), J.sub(J.gp(v_h_885, 1.0), J.mul(J.gp(env["S"], "H"), 0.03)), J.mul(J.gp(env["S"], "H"), 0.13), J.mul(J.gp(env["S"], "fs"), 0.2), 0.5, 0.6, (-J.num(J.gp(env["S"], "fs"))), 1.0])

func _f101(this_, a: Array, env):
	var v_P_875 = null; var v_k_879 = null; var v_ad_880 = null; var v_at_881 = null; var v_ang_883 = null; var v_q_886 = null; var v_lines_887 = null; var v_h_888 = null
	var _s149 = {"__p": env, "S": null, "G": null, "ctx": null, "t": null, "pr": null, "kind": null}
	_s149["S"] = J.arg(a, 0)
	_s149["G"] = J.arg(a, 1)
	v_P_875 = J.arg(a, 2)
	_s149["ctx"] = J.gp(_s149["S"], "ctx")
	_s149["t"] = J.gp(_s149["S"], "t")
	var _t264 = J.gp(J.gp(_s149["S"], "o"), "prop")
	_s149["pr"] = (_t264 if J.t(_t264) else {})
	v_k_879 = J.gp(_s149["S"], "env")
	J.mc(_s149["ctx"], "save", [])
	var _t265 = _s149["__p"]["lean"]
	var _t267 = _s149["S"]
	var _t266 = J.gp(v_P_875, "lean")
	var _t269 = (_t266 if J.t(_t266) else 0.0)
	var _t268 = J.gp(v_P_875, "dx")
	J.cl(_t265, null, [_t267, _t269, 0.3, (_t268 if J.t(_t268) else 0.0), 0.0])
	var _t270 = J.gp(v_P_875, "head")
	v_ad_880 = {"head": (_t270 if J.t(_t270) else 0.0)}
	if J.t(J.gp(_s149["G"], "still")):
		J.sp(v_ad_880, "head", 0.0)
	var _t271 = _s149["__p"]["body"]
	J.cl(_t271, null, [_s149["S"], J.gp(J.gp(_s149["S"], "a"), "type"), J.gp(_s149["G"], "key"), v_ad_880])
	v_at_881 = J.mc(_s149["S"], "P", J.spread([J.SP(J.gp(_s149["G"], "pv"))]))
	_s149["kind"] = J.gp(_s149["pr"], "kind")
	var _t272 = J.gp(v_P_875, "arm")
	v_ang_883 = (_t272 if J.t(_t272) else 0.0)
	if J.seq(_s149["kind"], "phone"):
		var _t273 = J.add(v_ang_883, J.mul(((-J.num(J.gp(_s149["S"], "fs"))) * 0.15), v_k_879))
		v_ang_883 = _t273
	var _t274 = J.seq(_s149["kind"], "lanternW")
	if (_t274 if _t274 else J.seq(_s149["kind"], "lanternR")):
		var _t275 = J.add(v_ang_883, (((sin(J.num(J.mul(_s149["t"], 7.0))) * 0.08) if J.t(J.gp(_s149["S"], "walk")) else 0.0) - J.mul(J.mul(J.gp(_s149["S"], "fs"), 0.1), v_k_879)))
		v_ang_883 = _t275
	var _t276 = _s149["__p"]["piece"]
	J.cl(_t276, null, [_s149["S"], J.gp(_s149["G"], "arm"), J.gp(_s149["G"], "pv"), v_at_881, v_ang_883, 1.0, Callable(self, "_f102").bind(_s149)])
	J.mc(_s149["ctx"], "restore", [])
	if J.seq(_s149["kind"], "phone"):
		var _t288 = J.mul(_s149["t"], 0.5)
		var _t287 = J.gp(_s149["pr"], "seed")
		v_q_886 = J.mod(J.add(_t288, (_t287 if J.t(_t287) else 0.0)), 1.0)
		var _t289 = J.gp(_s149["pr"], "lines")
		v_lines_887 = (_t289 if J.t(_t289) else ["喂？", "收到收到", "在路上了"])
		v_h_888 = J.mc(_s149["S"], "P", [0.5, 0.0])
		var _t290 = _s149["__p"]["text"]
		var _t293 = _s149["S"]
		var _t294 = J.sub(J.gp(v_h_888, 0.0), (J.mul(J.gp(_s149["S"], "fs"), J.gp(_s149["S"], "W")) * 0.1))
		var _t295 = J.sub(J.gp(v_h_888, 1.0), J.mul(J.gp(_s149["S"], "H"), 0.05))
		var _t292 = J.mul(_s149["t"], 0.5)
		var _t291 = J.gp(_s149["pr"], "seed")
		var _t297 = J.gp(v_lines_887, J.mod(floor(J.num(J.add(_t292, (_t291 if J.t(_t291) else 0.0)))), J.len(v_lines_887)))
		var _t298 = J.mul(J.gp(_s149["S"], "H"), 0.13)
		var _t296 = _s149["__p"]["bump"]
		J.cl(_t290, null, [_t293, _t294, _t295, _t297, _t298, (J.mul(J.cl(_t296, null, [v_q_886, 0.05, 0.2, 0.7]), v_k_879) * 0.95), {"col": "#e8fff0", "out": "#14281e"}])

func _f107(this_, a: Array, env):
	var v_e_928 = null
	v_e_928 = J.arg(a, 0)
	var _t308 = (not J.t(env["walk"]))
	return (_t308 if _t308 else J.seq(J.gp(v_e_928, 4.0), "walk"))

func _f108(this_, a: Array, env):
	var v_e_929 = null
	v_e_929 = J.arg(a, 0)
	return J.seq(J.gp(v_e_929, 0.0), J.gp(env["st"], "act"))

func _f109(this_, a: Array, env):
	var v_e_931 = null
	v_e_931 = J.arg(a, 0)
	var _t331 = env["can"]
	var _t333 = J.cl(_t331, null, [v_e_931])
	if J.t(_t333):
		var _t332 = J.gp(J.gp(env["st"], "cd"), J.gp(v_e_931, 0.0))
		_t333 = J.cmp((_t332 if J.t(_t332) else 0.0), 0.0, "<=")
	var _t335 = _t333
	if J.t(_t335):
		var _t334 = (not J.seq(J.gp(v_e_931, 0.0), J.gp(env["st"], "act")))
		_t335 = (_t334 if _t334 else J.seq(J.len(J.mc(env["L"], "filter", [env["can"]])), 1.0))
	return _t335

func _f110(this_, a: Array, env):
	var v_s_934 = null; var v_e_935 = null
	v_s_934 = J.arg(a, 0)
	v_e_935 = J.arg(a, 1)
	return J.add(v_s_934, J.gp(v_e_935, 1.0))

func _f106(this_, a: Array, env):
	var v_id_918 = null; var v_dt_919 = null; var v_eligible_920 = null; var v_force_922 = null; var v_cur_925 = null; var v_want_926 = null; var v_k_927 = null; var v_opts_930 = null; var v_r_932 = null; var v_e_933 = null; var v_o_936 = null
	var _s156 = {"__p": env, "st": null, "walk": null, "L": null, "can": null}
	_s156["st"] = J.arg(a, 0)
	v_id_918 = J.arg(a, 1)
	v_dt_919 = J.arg(a, 2)
	v_eligible_920 = J.arg(a, 3)
	_s156["walk"] = J.arg(a, 4)
	v_force_922 = J.arg(a, 5)
	var _t299 = J.gp(_s156["__p"]["LIST"], v_id_918)
	_s156["L"] = (_t299 if J.t(_t299) else [])
	var _t300 = (_s156["st"] if J.t(_s156["st"]) else {"act": null, "at": 0.0, "dur": 0.0, "w": 0.0, "cd": {}})
	_s156["st"] = _t300
	var _t301 = (not J.t(v_force_922))
	if J.t((J.gp(_s156["st"], "forced") if _t301 else _t301)):
		var _t302 = _s156["st"]
		J.sp(_t302, "forced", false)
		var _t303 = _s156["st"]
		var _t304 = J.min_([J.gp(_s156["st"], "dur"), J.add(J.gp(_s156["st"], "at"), 0.35)])
		J.sp(_t303, "dur", _t304)
	for _t305 in J.keys(J.gp(_s156["st"], "cd")):
		v_k_927 = _t305
		var _t306 = J.gp(_s156["st"], "cd")
		var _t307 = J.sub(J.gp(_t306, v_k_927), v_dt_919)
		J.sp(_t306, v_k_927, _t307)
	_s156["can"] = Callable(self, "_f107").bind(_s156)
	var _t310 = v_force_922
	if J.t(_t310):
		var _t309 = (not J.seq(J.gp(_s156["st"], "act"), J.gp(v_force_922, 0.0)))
		_t310 = (_t309 if _t309 else J.cmp(J.gp(_s156["st"], "at"), J.gp(_s156["st"], "dur"), ">"))
	if J.t(_t310):
		var _t311 = _s156["st"]
		var _t312 = J.gp(v_force_922, 0.0)
		J.sp(_t311, "act", _t312)
		var _t313 = _s156["st"]
		J.sp(_t313, "at", 0.0)
		var _t314 = _s156["st"]
		var _t315 = J.gp(v_force_922, 1.0)
		J.sp(_t314, "dur", _t315)
		var _t316 = _s156["st"]
		J.sp(_t316, "forced", true)
	var _t317 = _s156["st"]
	var _t318 = J.add(J.gp(_t317, "at"), v_dt_919)
	J.sp(_t317, "at", _t318)
	v_cur_925 = J.mc(_s156["L"], "find", [Callable(self, "_f108").bind(_s156)])
	var _t322 = v_eligible_920
	if J.t(_t322):
		var _t319 = J.gp(_s156["st"], "act")
		var _t321 = null
		if J.t((v_cur_925 if J.t(_t319) else _t319)):
			var _t320 = _s156["can"]
			_t321 = J.cl(_t320, null, [v_cur_925])
		else:
			_t321 = true
		_t322 = _t321
	v_want_926 = _t322
	var _t323 = _s156["st"]
	var _t324 = _s156["__p"]["cl"]
	var _t325 = J.cl(_t324, null, [J.add(J.gp(_s156["st"], "w"), J.div(J.mul((1.0 if J.t(v_want_926) else (-1.0)), v_dt_919), 0.25))])
	J.sp(_t323, "w", _t325)
	var _t330 = v_eligible_920
	if J.t(_t330):
		var _t326 = (not J.t(J.gp(_s156["st"], "act")))
		var _t329 = (_t326 if _t326 else J.cmp(J.gp(_s156["st"], "at"), J.gp(_s156["st"], "dur"), ">="))
		if not J.t(_t329):
			var _t328 = v_cur_925
			if J.t(_t328):
				var _t327 = _s156["can"]
				_t328 = (not J.t(J.cl(_t327, null, [v_cur_925])))
			_t329 = (J.cmp(J.gp(_s156["st"], "w"), 0.0, "<=") if J.t(_t328) else _t328)
		_t330 = _t329
	if J.t(_t330):
		v_opts_930 = J.mc(_s156["L"], "filter", [Callable(self, "_f109").bind(_s156)])
		if J.t(J.len(v_opts_930)):
			v_r_932 = J.mul(randf(), J.mc(v_opts_930, "reduce", [Callable(self, "_f110").bind(_s156), 0.0]))
			v_e_933 = J.gp(v_opts_930, 0.0)
			for _t336 in J.iter(v_opts_930):
				v_o_936 = _t336
				var _t337 = J.sub(v_r_932, J.gp(v_o_936, 1.0))
				v_r_932 = _t337
				if J.cmp(v_r_932, 0.0, "<="):
					v_e_933 = v_o_936
					break
			var _t338 = _s156["st"]
			var _t339 = J.gp(v_e_933, 0.0)
			J.sp(_t338, "act", _t339)
			var _t340 = _s156["st"]
			J.sp(_t340, "at", 0.0)
			var _t341 = _s156["st"]
			var _t342 = J.add(J.gp(J.gp(v_e_933, 2.0), 0.0), (randf() * J.sub(J.gp(J.gp(v_e_933, 2.0), 1.0), J.gp(J.gp(v_e_933, 2.0), 0.0))))
			J.sp(_t341, "dur", _t342)
			var _t343 = J.gp(_s156["st"], "cd")
			var _t344 = J.gp(v_e_933, 0.0)
			var _t345 = J.add(J.gp(v_e_933, 3.0), J.gp(_s156["st"], "dur"))
			J.sp(_t343, _t344, _t345)
	var _t346 = (not J.t(v_eligible_920))
	if (J.cmp(J.gp(_s156["st"], "w"), 0.0, "<=") if _t346 else _t346):
		var _t347 = _s156["st"]
		J.sp(_t347, "act", null)
	return _s156["st"]

func _f112(this_, a: Array, env):
	var v_n_940 = null; var v_dt_941 = null; var v_scare_942 = null; var v_d_943 = null; var v_rx_944 = null; var v_calm_945 = null; var v_walk_946 = null; var v_force_947 = null; var v_fa_948 = null
	v_n_940 = J.arg(a, 0)
	v_dt_941 = J.arg(a, 1)
	v_scare_942 = J.arg(a, 2)
	v_d_943 = J.gp(v_n_940, "d")
	var _t348 = J.gp(v_n_940, "rx")
	v_rx_944 = (J.gp(v_n_940, "rx") if J.t((J.cmp(J.gp(J.gp(v_n_940, "rx"), "t"), 0.0, ">=") if J.t(_t348) else _t348)) else null)
	var _t349 = (not J.t(J.gp(v_n_940, "fleeing")))
	var _t350 = ((not J.t(J.gp(v_n_940, "gone"))) if _t349 else _t349)
	var _t353 = (J.cmp(J.gp(v_n_940, "fear"), 25.0, "<") if _t350 else _t350)
	if J.t(_t353):
		var _t351 = (not J.t(v_rx_944))
		var _t352 = (_t351 if _t351 else J.seq(J.gp(v_rx_944, "k"), "numb"))
		_t353 = (_t352 if _t352 else J.seq(J.gp(v_rx_944, "k"), "sip"))
	v_calm_945 = _t353
	v_walk_946 = J.seq(J.gp(v_n_940, "act"), "walk")
	var _t354 = (J.seq(J.gp(v_rx_944, "k"), "sip") if J.t(v_rx_944) else v_rx_944)
	v_force_947 = (["town_guard_sip", J.max_([3.3, J.add(J.gp(v_rx_944, "dur"), 0.4)])] if J.t((J.seq(J.gp(v_d_943, "spr"), "npc_guard") if J.t(_t354) else _t354)) else null)
	var _t355 = (not J.t(v_force_947))
	var _t356 = ((not J.t(v_walk_946)) if _t355 else _t355)
	var _t357 = (J.gp(env["ACT"], J.gp(v_d_943, "spr")) if _t356 else _t356)
	v_fa_948 = (J.gp(J.gp(env["ACT"], J.gp(v_d_943, "spr")), J.gp(v_n_940, "act")) if J.t(_t357) else _t357)
	if J.t(v_fa_948):
		var _t358 = [v_fa_948, (3.6 if J.seq(J.gp(v_n_940, "act"), "pack") else 1000000000.0)]
		v_force_947 = _t358
	var _t359 = env["tick"]
	var _t360 = J.cl(_t359, null, [J.gp(v_n_940, "daily"), J.gp(v_d_943, "spr"), v_dt_941, v_calm_945, v_walk_946, v_force_947])
	J.sp(v_n_940, "daily", _t360)

func _f2(this_, a: Array, env):
	var v_v_68 = null; var v_a_69 = null; var v_b_70 = null
	v_v_68 = J.arg(a, 0)
	var _t361 = J.arg(a, 1)
	if _t361 == null:
		_t361 = 0.0
	v_a_69 = _t361
	var _t362 = J.arg(a, 2)
	if _t362 == null:
		_t362 = 1.0
	v_b_70 = _t362
	return (v_a_69 if J.cmp(v_v_68, v_a_69, "<") else (v_b_70 if J.cmp(v_v_68, v_b_70, ">") else v_v_68))

func _f3(this_, a: Array, env):
	var v_a_71 = null; var v_b_72 = null; var v_k_73 = null
	v_a_71 = J.arg(a, 0)
	v_b_72 = J.arg(a, 1)
	v_k_73 = J.arg(a, 2)
	return J.add(v_a_71, J.mul(J.sub(v_b_72, v_a_71), v_k_73))

func _f4(this_, a: Array, env):
	var v_t_74 = null
	v_t_74 = J.arg(a, 0)
	var _t363 = env["cl"]
	var _t364 = J.cl(_t363, null, [v_t_74])
	v_t_74 = _t364
	return (J.mul(v_t_74, v_t_74) * (3.0 - J.mul(2.0, v_t_74)))

func _f5(this_, a: Array, env):
	var v_t_75 = null; var v_a_76 = null; var v_b_77 = null
	v_t_75 = J.arg(a, 0)
	v_a_76 = J.arg(a, 1)
	v_b_77 = J.arg(a, 2)
	var _t365 = env["cl"]
	return J.cl(_t365, null, [J.div(J.sub(v_t_75, v_a_76), J.sub(v_b_77, v_a_76))])

func _f6(this_, a: Array, env):
	var v_t_78 = null
	v_t_78 = J.arg(a, 0)
	var _t366 = env["cl"]
	var _t368 = J.sub(1.0, J.cl(_t366, null, [v_t_78]))
	var _t367 = env["cl"]
	return (1.0 - (_t368 * J.sub(1.0, J.cl(_t367, null, [v_t_78]))))

func _f7(this_, a: Array, env):
	var v_t_79 = null
	v_t_79 = J.arg(a, 0)
	var _t369 = env["cl"]
	return (1.0 - pow(J.num(J.sub(1.0, J.cl(_t369, null, [v_t_79]))), J.num(3.0)))

func _f8(this_, a: Array, env):
	var v_t_80 = null; var v_a_81 = null; var v_m_82 = null; var v_b_83 = null
	v_t_80 = J.arg(a, 0)
	v_a_81 = J.arg(a, 1)
	v_m_82 = J.arg(a, 2)
	v_b_83 = J.arg(a, 3)
	var _t370 = J.cmp(v_t_80, v_a_81, "<=")
	var _t374 = null
	if (_t370 if _t370 else J.cmp(v_t_80, v_b_83, ">=")):
		_t374 = 0.0
	else:
		var _t373 = null
		if J.cmp(v_t_80, v_m_82, "<"):
			var _t371 = env["ss"]
			_t373 = J.cl(_t371, null, [J.div(J.sub(v_t_80, v_a_81), J.sub(v_m_82, v_a_81))])
		else:
			var _t372 = env["ss"]
			_t373 = J.sub(1.0, J.cl(_t372, null, [J.div(J.sub(v_t_80, v_m_82), J.sub(v_b_83, v_m_82))]))
		_t374 = _t373
	return _t374

func _f9(this_, a: Array, env):
	var v_K_84 = null; var v_t_85 = null; var v_i_86 = null; var v_a_87 = null; var v_b_88 = null; var v_q_89 = null
	v_K_84 = J.arg(a, 0)
	v_t_85 = J.arg(a, 1)
	if J.cmp(v_t_85, J.gp(J.gp(v_K_84, 0.0), 0.0), "<="):
		return J.gp(J.gp(v_K_84, 0.0), 1.0)
	v_i_86 = 1.0
	while true:
		if not J.cmp(v_i_86, J.len(v_K_84), "<"): break
		if J.cmp(v_t_85, J.gp(J.gp(v_K_84, v_i_86), 0.0), "<="):
			v_a_87 = J.gp(v_K_84, J.sub(v_i_86, 1.0))
			v_b_88 = J.gp(v_K_84, v_i_86)
			v_q_89 = J.div(J.sub(v_t_85, J.gp(v_a_87, 0.0)), J.sub(J.gp(v_b_88, 0.0), J.gp(v_a_87, 0.0)))
			return J.add(J.gp(v_a_87, 1.0), (J.sub(J.gp(v_b_88, 1.0), J.gp(v_a_87, 1.0)) * (0.5 - (0.5 * cos(J.num(J.mul(env["PI"], v_q_89)))))))
		v_i_86 = J.num(v_i_86) + 1.0
	return J.gp(J.gp(v_K_84, (J.len(v_K_84) - 1.0)), 1.0)

func _f10(this_, a: Array, env):
	var v_s_90 = null; var v_x_91 = null
	v_s_90 = J.arg(a, 0)
	v_x_91 = (sin(J.num((J.mul(v_s_90, 127.1) + 311.7))) * 43758.5453)
	return J.sub(v_x_91, floor(J.num(v_x_91)))

func _f11(this_, a: Array, env):
	var v_k_92 = null
	v_k_92 = J.arg(a, 0)
	var _t376 = J.seq(J.typeof_(J.G.get("sprOk")), "function")
	if J.t(_t376):
		var _t375 = J.G.get("sprOk")
		_t376 = J.cl(_t375, null, [v_k_92])
	return _t376

func _f14(this_, a: Array, env):
	var v_S_113 = null
	v_S_113 = J.arg(a, 0)
	return J.mc(J.gp(v_S_113, "ctx"), "restore", [])

func _f21(this_, a: Array, env):
	var v_S_160 = null; var v_pu_161 = null; var v_pv_162 = null; var v_at_163 = null; var v_ang_164 = null; var v_u_165 = null; var v_v_166 = null; var v_x_167 = null; var v_y_168 = null; var v_c_169 = null; var v_s_170 = null
	v_S_160 = J.arg(a, 0)
	v_pu_161 = J.arg(a, 1)
	v_pv_162 = J.arg(a, 2)
	v_at_163 = J.arg(a, 3)
	v_ang_164 = J.arg(a, 4)
	v_u_165 = J.arg(a, 5)
	v_v_166 = J.arg(a, 6)
	v_x_167 = J.mul(J.sub(v_u_165, v_pu_161), J.gp(v_S_160, "W"))
	v_y_168 = J.mul(J.sub(v_v_166, v_pv_162), J.gp(v_S_160, "H"))
	v_c_169 = cos(J.num(v_ang_164))
	v_s_170 = sin(J.num(v_ang_164))
	return [J.sub(J.add(J.gp(v_at_163, 0.0), J.mul(v_x_167, v_c_169)), J.mul(v_y_168, v_s_170)), J.add(J.add(J.gp(v_at_163, 1.0), J.mul(v_x_167, v_s_170)), J.mul(v_y_168, v_c_169))]

func _f34(this_, a: Array, env):
	var v_S_270 = null; var v_P_271 = null; var v_l_272 = null; var v_p_273 = null; var v_r_274 = null; var v_cs_275 = null; var v_sn_276 = null
	v_S_270 = J.arg(a, 0)
	v_P_271 = J.arg(a, 1)
	var _t377 = J.gp(v_P_271, "lean")
	v_l_272 = (_t377 if J.t(_t377) else 0.0)
	v_p_273 = J.mc(v_S_270, "P", [0.4, 0.33])
	v_r_274 = [J.gp(v_p_273, 0.0), J.add(J.gp(v_p_273, 1.0), J.mul(J.gp(v_S_270, "H"), 0.35))]
	v_cs_275 = cos(J.num(v_l_272))
	v_sn_276 = sin(J.num(v_l_272))
	return [(J.mul(J.gp(v_r_274, 0.0), v_cs_275) - J.mul(J.gp(v_r_274, 1.0), v_sn_276)), ((J.mul(J.gp(v_r_274, 0.0), v_sn_276) + J.mul(J.gp(v_r_274, 1.0), v_cs_275)) - J.mul(J.gp(v_S_270, "H"), 0.35))]

func _f35(this_, a: Array, env):
	var v_ctx_279 = null; var v_a_280 = null; var v_S_281 = null; var v_k_282 = null; var v_q_283 = null; var v_fl_284 = null; var v_h_285 = null
	v_ctx_279 = J.arg(a, 0)
	v_a_280 = J.arg(a, 1)
	var _t379 = env["begin"]
	v_S_281 = J.cl(_t379, null, [v_ctx_279, v_a_280, "npc_ken__bodyF", false])
	if (not J.t(v_S_281)):
		return false
	v_k_282 = J.gp(v_S_281, "env")
	v_q_283 = J.div(J.mod(J.gp(v_S_281, "at"), 1.1), 1.1)
	var _t380 = env["bump"]
	v_fl_284 = J.cl(_t380, null, [v_q_283, 0.55, 0.66, 0.85])
	var _t381 = env["kenDraw"]
	J.cl(_t381, null, [v_S_281, {"ang": J.mul(v_k_282, (J.mul(0.035, v_fl_284) + (0.01 * sin(J.num(J.mul(J.gp(v_S_281, "at"), 1.7)))))), "head": (J.mul(v_k_282, J.gp(v_S_281, "fs")) * (0.05 + J.mul(0.02, v_fl_284))), "lean": (J.mul(v_k_282, J.gp(v_S_281, "fs")) * 0.02)}])
	if J.cmp(v_fl_284, 0.2, ">"):
		v_h_285 = J.mc(v_S_281, "P", [0.3, 0.445])
		J.mc(v_ctx_279, "save", [])
		var _t382 = J.mul(J.gp(v_ctx_279, "globalAlpha"), (J.mul(v_k_282, v_fl_284) * 0.7))
		J.sp(v_ctx_279, "globalAlpha", _t382)
		var _t383 = env["crayon"]
		J.cl(_t383, null, [v_ctx_279, [[J.sub(J.gp(v_h_285, 0.0), J.mul(J.gp(v_S_281, "W"), 0.05)), J.add(J.gp(v_h_285, 1.0), J.mul(J.gp(v_S_281, "H"), 0.012))], [J.gp(v_h_285, 0.0), J.sub(J.gp(v_h_285, 1.0), J.mul(J.gp(v_S_281, "H"), 0.004))], [J.add(J.gp(v_h_285, 0.0), J.mul(J.gp(v_S_281, "W"), 0.04)), J.sub(J.gp(v_h_285, 1.0), J.mul(J.gp(v_S_281, "H"), 0.02))]], J.max_([1.0, J.mul(J.gp(v_S_281, "H"), 0.008)]), "rgba(255,255,255,.9)"])
		J.mc(v_ctx_279, "restore", [])
	var _t384 = env["end"]
	J.cl(_t384, null, [v_S_281])
	return true

func _f36(this_, a: Array, env):
	var v_ctx_288 = null; var v_a_289 = null; var v_S_290 = null; var v_t_291 = null; var v_k_292 = null; var v_up_293 = null; var v_back_294 = null; var v_sy_295 = null; var v_f_296 = null; var v_hk_297 = null; var v_tk_298 = null; var v_e_299 = null
	v_ctx_288 = J.arg(a, 0)
	v_a_289 = J.arg(a, 1)
	var _t387 = env["begin"]
	v_S_290 = J.cl(_t387, null, [v_ctx_288, v_a_289, "npc_ken__bodyF", false])
	if (not J.t(v_S_290)):
		return false
	v_t_291 = J.gp(v_S_290, "at")
	v_k_292 = J.gp(v_S_290, "env")
	var _t388 = env["kf"]
	v_up_293 = J.cl(_t388, null, [[[0.0, 0.0], [0.7, 1.0], [2.2, 1.0], [2.8, 0.0]], v_t_291])
	var _t389 = env["kf"]
	v_back_294 = J.cl(_t389, null, [[[0.0, 0.0], [0.5, 0.3], [0.9, 1.0], [2.0, 1.0], [2.6, 0.0], [2.9, (-0.25)], [3.2, 0.0]], v_t_291])
	var _t390 = env["kf"]
	v_sy_295 = (1.0 + J.mul(J.mul(0.045, J.cl(_t390, null, [[[0.0, 0.0], [0.6, 1.0], [1.9, 1.15], [2.6, 0.0], [2.9, (-0.3)], [3.3, 0.0]], v_t_291])), v_k_292))
	J.mc(v_ctx_288, "save", [])
	J.mc(v_ctx_288, "scale", [J.div(1.0, sqrt(J.num(v_sy_295))), v_sy_295])
	var _t391 = env["kenDraw"]
	var _t397 = (J.mul(v_k_292, v_up_293) * 0.62)
	var _t398 = (J.mul(v_k_292, v_up_293) * 0.035)
	var _t399 = (J.mul(v_k_292, v_up_293) * 0.02)
	var _t400 = (1.0 + J.mul(J.mul(0.05, v_up_293), v_k_292))
	var _t396 = (J.mul(J.mul((-J.num(J.gp(v_S_290, "fs"))), v_k_292), v_back_294) * 0.16)
	var _t393 = ((J.mul(J.gp(v_S_290, "fs"), v_k_292) * 0.05) * sin(J.num((J.max_([0.0, J.sub(v_t_291, 2.6)]) * 18.0))))
	var _t392 = env["seg"]
	var _t395 = J.mul(_t393, J.cl(_t392, null, [v_t_291, 2.6, 2.75]))
	var _t394 = env["seg"]
	J.cl(_t391, null, [v_S_290, {"ang": _t397, "lift": _t398, "fx": _t399, "sc": _t400, "head": (_t396 + (_t395 * J.sub(1.0, J.cl(_t394, null, [v_t_291, 2.95, 3.2])))), "lean": (J.mul(J.mul((-J.num(J.gp(v_S_290, "fs"))), v_k_292), v_back_294) * 0.03)}])
	J.mc(v_ctx_288, "restore", [])
	var _t401 = env["kenFace"]
	v_f_296 = J.cl(_t401, null, [v_S_290, {}])
	var _t402 = env["bump"]
	v_hk_297 = J.mul(J.cl(_t402, null, [v_t_291, 0.6, 1.0, 2.3]), v_k_292)
	var _t403 = env["text"]
	J.cl(_t403, null, [v_S_290, J.sub(J.gp(v_f_296, 0.0), (J.mul(J.gp(v_S_290, "fs"), J.gp(v_S_290, "H")) * 0.32)), (J.sub(J.gp(v_f_296, 1.0), J.mul(J.gp(v_S_290, "H"), 0.25)) - (J.mul(v_hk_297, J.gp(v_S_290, "H")) * 0.04)), "哈～", J.mul(J.gp(v_S_290, "H"), 0.11), v_hk_297, {"rot": (-0.1)}])
	var _t404 = env["bump"]
	v_tk_298 = J.mul(J.cl(_t404, null, [v_t_291, 1.2, 1.6, 2.8]), v_k_292)
	if J.cmp(v_tk_298, 0.0, ">"):
		v_e_299 = J.mc(v_S_290, "P", [0.25, 0.33])
		J.mc(v_ctx_288, "save", [])
		var _t405 = J.mul(J.gp(v_ctx_288, "globalAlpha"), v_tk_298)
		J.sp(v_ctx_288, "globalAlpha", _t405)
		J.sp(v_ctx_288, "fillStyle", "rgba(170,220,255,.95)")
		J.sp(v_ctx_288, "strokeStyle", "rgba(40,70,110,.6)")
		J.sp(v_ctx_288, "lineWidth", 1.0)
		J.mc(v_ctx_288, "beginPath", [])
		J.mc(v_ctx_288, "ellipse", [J.gp(v_e_299, 0.0), J.add(J.gp(v_e_299, 1.0), (J.mul(v_tk_298, J.gp(v_S_290, "H")) * 0.01)), J.mul(J.gp(v_S_290, "H"), 0.008), J.mul(J.gp(v_S_290, "H"), 0.012), 0.0, 0.0, J.mul(env["PI"], 2.0)])
		J.mc(v_ctx_288, "fill", [])
		J.mc(v_ctx_288, "stroke", [])
		J.mc(v_ctx_288, "restore", [])
	var _t406 = env["end"]
	J.cl(_t406, null, [v_S_290])
	return true

func _f37(this_, a: Array, env):
	var v_ctx_302 = null; var v_a_303 = null; var v_S_304 = null; var v_t_305 = null; var v_k_306 = null; var v_up_307 = null; var v_rb_308 = null; var v_wig_309 = null
	v_ctx_302 = J.arg(a, 0)
	v_a_303 = J.arg(a, 1)
	var _t409 = env["begin"]
	v_S_304 = J.cl(_t409, null, [v_ctx_302, v_a_303, "npc_ken__bodyF", false])
	if (not J.t(v_S_304)):
		return false
	v_t_305 = J.gp(v_S_304, "at")
	v_k_306 = J.gp(v_S_304, "env")
	var _t410 = env["kf"]
	v_up_307 = J.cl(_t410, null, [[[0.0, 0.0], [0.6, 1.0], [2.2, 1.0], [2.8, 0.0]], v_t_305])
	var _t411 = env["seg"]
	var _t413 = J.cl(_t411, null, [v_t_305, 0.6, 2.2])
	var _t412 = env["seg"]
	v_rb_308 = J.mul(_t413, J.sub(1.0, J.cl(_t412, null, [v_t_305, 2.1, 2.3])))
	v_wig_309 = J.mul(sin(J.num(J.mul(v_t_305, 15.0))), v_rb_308)
	var _t414 = env["kenDraw"]
	J.cl(_t414, null, [v_S_304, {"ang": J.mul(v_k_306, (J.mul(v_up_307, 0.8) + J.mul(v_wig_309, 0.035))), "lift": J.mul(v_k_306, (J.mul(v_up_307, 0.1) + (J.mul(cos(J.num(J.mul(v_t_305, 15.0))), v_rb_308) * 0.006))), "fx": (J.mul(v_k_306, v_up_307) * 0.03), "sc": (1.0 + J.mul(J.mul(0.06, v_up_307), v_k_306)), "head": (J.mul(J.mul(J.gp(v_S_304, "fs"), v_k_306), v_up_307) * 0.09), "lean": (J.mul(J.mul(J.gp(v_S_304, "fs"), v_k_306), v_up_307) * 0.025)}])
	var _t415 = env["end"]
	J.cl(_t415, null, [v_S_304])
	return true

func _f38(this_, a: Array, env):
	var v_ctx_312 = null; var v_a_313 = null; var v_S_314 = null; var v_t_315 = null; var v_k_316 = null; var v_inh_317 = null; var v_f_318 = null
	v_ctx_312 = J.arg(a, 0)
	v_a_313 = J.arg(a, 1)
	var _t418 = env["begin"]
	v_S_314 = J.cl(_t418, null, [v_ctx_312, v_a_313, "npc_ken__bodyF", false])
	if (not J.t(v_S_314)):
		return false
	v_t_315 = J.gp(v_S_314, "at")
	v_k_316 = J.gp(v_S_314, "env")
	var _t419 = env["kf"]
	v_inh_317 = J.cl(_t419, null, [[[0.0, 0.0], [0.7, 1.0], [1.0, 1.0], [1.5, (-0.6)], [2.6, (-0.5)], [3.0, 0.0]], v_t_315])
	J.mc(v_ctx_312, "save", [])
	J.mc(v_ctx_312, "scale", [1.0, (1.0 + J.mul(J.mul(0.03, v_inh_317), v_k_316))])
	var _t420 = env["kenDraw"]
	J.cl(_t420, null, [v_S_314, {"ang": J.mul(v_k_316, J.mul(0.05, v_inh_317)), "head": (J.mul(J.gp(v_S_314, "fs"), v_k_316) * (((-0.05) * J.max_([0.0, v_inh_317])) + (0.14 * J.max_([0.0, (-J.num(v_inh_317))])))), "lean": ((J.mul(J.gp(v_S_314, "fs"), v_k_316) * 0.03) * J.max_([0.0, (-J.num(v_inh_317))]))}])
	J.mc(v_ctx_312, "restore", [])
	var _t421 = env["kenFace"]
	v_f_318 = J.cl(_t421, null, [v_S_314, {}])
	var _t422 = env["puff"]
	var _t424 = J.add(J.gp(v_f_318, 0.0), (J.mul(J.gp(v_S_314, "fs"), J.gp(v_S_314, "H")) * 0.04))
	var _t425 = J.add(J.gp(v_f_318, 1.0), J.mul(J.gp(v_S_314, "H"), 0.06))
	var _t426 = J.mul(J.gp(v_S_314, "H"), 0.05)
	var _t423 = env["seg"]
	J.cl(_t422, null, [v_ctx_312, _t424, _t425, _t426, J.cl(_t423, null, [v_t_315, 1.0, 2.2]), 3.1])
	var _t427 = env["text"]
	var _t429 = J.sub(J.gp(v_f_318, 0.0), (J.mul(J.gp(v_S_314, "fs"), J.gp(v_S_314, "H")) * 0.3))
	var _t430 = J.sub(J.gp(v_f_318, 1.0), J.mul(J.gp(v_S_314, "H"), 0.22))
	var _t431 = J.mul(J.gp(v_S_314, "H"), 0.1)
	var _t428 = env["bump"]
	J.cl(_t427, null, [v_S_314, _t429, _t430, "唉……", _t431, J.mul(J.cl(_t428, null, [v_t_315, 1.0, 1.4, 2.6]), v_k_316), {"col": "#cfd8ff", "out": "#1e2238"}])
	var _t432 = env["end"]
	J.cl(_t432, null, [v_S_314])
	return true

func _f42(this_, a: Array, env):
	var v_L_339 = null; var v_p_340 = null; var v_fog_341 = null; var v_r_342 = null; var v_an_343 = null
	v_L_339 = J.arg(a, 0)
	v_p_340 = J.cl(v_L_339, null, J.spread([J.SP(J.gp(env["__p"]["BOSS"], "BALL"))]))
	var _t446 = [J.gp(v_p_340, 0.0), J.gp(v_p_340, 1.0)]
	env["ballPos"] = _t446
	var _t447 = env["__p"]["bump"]
	v_fog_341 = J.mul(J.cl(_t447, null, [env["t"], 0.9, 1.25, 2.4]), env["k"])
	if J.cmp(v_fog_341, 0.0, ">"):
		J.mc(env["ctx"], "save", [])
		var _t448 = env["ctx"]
		var _t449 = J.mul(J.gp(_t448, "globalAlpha"), J.mul(v_fog_341, 0.55))
		J.sp(_t448, "globalAlpha", _t449)
		var _t450 = env["ctx"]
		J.sp(_t450, "fillStyle", "rgba(235,240,250,.9)")
		J.mc(env["ctx"], "beginPath", [])
		J.mc(env["ctx"], "arc", [J.gp(v_p_340, 0.0), J.gp(v_p_340, 1.0), J.mul(J.gp(env["S"], "W"), 0.1), 0.0, J.mul(env["__p"]["PI"], 2.0)])
		J.mc(env["ctx"], "fill", [])
		J.mc(env["ctx"], "restore", [])
	if J.cmp(env["rub"], 0.0, ">"):
		J.mc(env["ctx"], "save", [])
		var _t451 = env["ctx"]
		var _t452 = J.mul(J.gp(_t451, "globalAlpha"), (J.mul(env["rub"], env["k"]) * 0.8))
		J.sp(_t451, "globalAlpha", _t452)
		v_r_342 = J.mul(J.gp(env["S"], "W"), 0.07)
		v_an_343 = J.mul(env["t"], 13.0)
		var _t453 = env["__p"]["crayon"]
		J.cl(_t453, null, [env["ctx"], [[J.add(J.gp(v_p_340, 0.0), J.mul(cos(J.num(v_an_343)), v_r_342)), J.add(J.gp(v_p_340, 1.0), (J.mul(sin(J.num(v_an_343)), v_r_342) * 0.7))], [J.add(J.gp(v_p_340, 0.0), J.mul(cos(J.num(J.add(v_an_343, 0.9))), v_r_342)), J.add(J.gp(v_p_340, 1.0), (J.mul(sin(J.num(J.add(v_an_343, 0.9))), v_r_342) * 0.7))]], J.max_([1.0, J.mul(J.gp(env["S"], "H"), 0.008)]), "rgba(255,255,255,.9)"])
		J.mc(env["ctx"], "restore", [])
	var _t454 = env["__p"]["sparkle"]
	var _t456 = env["ctx"]
	var _t457 = J.add(J.gp(v_p_340, 0.0), J.mul(J.gp(env["S"], "W"), 0.04))
	var _t458 = J.sub(J.gp(v_p_340, 1.0), J.mul(J.gp(env["S"], "W"), 0.05))
	var _t459 = J.mul(J.gp(env["S"], "H"), 0.05)
	var _t455 = env["__p"]["bump"]
	J.cl(_t454, null, [_t456, _t457, _t458, _t459, J.mul(J.cl(_t455, null, [env["t"], 2.75, 2.9, 3.4]), env["k"])])

func _f41(this_, a: Array, env):
	var v_a_331 = null; var v_near_335 = null; var v_m_338 = null
	var _s61 = {"__p": env, "ctx": null, "S": null, "t": null, "k": null, "rub": null, "ballPos": null}
	_s61["ctx"] = J.arg(a, 0)
	v_a_331 = J.arg(a, 1)
	var _t435 = _s61["__p"]["begin"]
	_s61["S"] = J.cl(_t435, null, [_s61["ctx"], v_a_331, "npc_boss__bodyN", false])
	if (not J.t(_s61["S"])):
		return false
	_s61["t"] = J.gp(_s61["S"], "at")
	_s61["k"] = J.gp(_s61["S"], "env")
	var _t436 = _s61["__p"]["kf"]
	v_near_335 = J.cl(_t436, null, [[[0.0, 0.0], [0.6, 1.0], [3.1, 1.0], [3.6, 0.0]], _s61["t"]])
	var _t437 = _s61["__p"]["seg"]
	var _t439 = J.cl(_t437, null, [_s61["t"], 1.3, 2.7])
	var _t438 = _s61["__p"]["seg"]
	_s61["rub"] = J.mul(_t439, J.sub(1.0, J.cl(_t438, null, [_s61["t"], 2.6, 2.8])))
	_s61["ballPos"] = null
	var _t440 = _s61["__p"]["bossDraw"]
	var _t460 = _s61["S"]
	var _t444 = J.mul(_s61["k"], (J.mul(v_near_335, 0.13) + J.mul((sin(J.num(J.mul(_s61["t"], 13.0))) * 0.03), _s61["rub"])))
	var _t445 = (J.mul(_s61["k"], v_near_335) * 0.015)
	var _t443 = J.mul(J.gp(_s61["S"], "fs"), _s61["k"])
	var _t442 = J.mul(v_near_335, 0.1)
	var _t441 = _s61["__p"]["bump"]
	J.cl(_t440, null, [_t460, {"ball": _t444, "elUp": _t445, "head": (_t443 * (_t442 - J.mul(0.06, J.cl(_t441, null, [_s61["t"], 2.9, 3.1, 3.4])))), "lean": (J.mul(J.mul(J.gp(_s61["S"], "fs"), _s61["k"]), v_near_335) * 0.025), "bfn": Callable(self, "_f42").bind(_s61)}])
	v_m_338 = J.mc(_s61["S"], "P", J.spread([J.SP(J.gp(_s61["__p"]["BOSS"], "MOUTH"))]))
	var _t461 = _s61["__p"]["puff"]
	var _t466 = _s61["ctx"]
	var _t462 = _s61["__p"]["lerp"]
	var _t464 = J.gp(v_m_338, 0.0)
	var _t465 = J.add(J.gp(v_m_338, 0.0), (J.mul(J.gp(_s61["S"], "fs"), J.gp(_s61["S"], "W")) * 0.12))
	var _t463 = _s61["__p"]["seg"]
	var _t468 = J.cl(_t462, null, [_t464, _t465, J.cl(_t463, null, [_s61["t"], 0.75, 1.2])])
	var _t469 = J.gp(v_m_338, 1.0)
	var _t470 = J.mul(J.gp(_s61["S"], "H"), 0.035)
	var _t467 = _s61["__p"]["seg"]
	J.cl(_t461, null, [_t466, _t468, _t469, _t470, J.cl(_t467, null, [_s61["t"], 0.7, 1.3]), 7.7])
	var _t471 = _s61["__p"]["text"]
	var _t473 = _s61["S"]
	var _t474 = J.sub(J.gp(v_m_338, 0.0), (J.mul(J.gp(_s61["S"], "fs"), J.gp(_s61["S"], "W")) * 0.3))
	var _t475 = J.sub(J.gp(v_m_338, 1.0), J.mul(J.gp(_s61["S"], "H"), 0.17))
	var _t476 = J.mul(J.gp(_s61["S"], "H"), 0.085)
	var _t472 = _s61["__p"]["bump"]
	J.cl(_t471, null, [_t473, _t474, _t475, "哈——", _t476, J.mul(J.cl(_t472, null, [_s61["t"], 0.7, 0.85, 1.3]), _s61["k"])])
	var _t477 = _s61["__p"]["end"]
	J.cl(_t477, null, [_s61["S"]])
	return true

func _f43(this_, a: Array, env):
	var v_ctx_346 = null; var v_a_347 = null; var v_S_348 = null; var v_t_349 = null; var v_k_350 = null; var v_up_351 = null; var v_flick_352 = null; var v_tap_353 = null; var v_m_354 = null
	v_ctx_346 = J.arg(a, 0)
	v_a_347 = J.arg(a, 1)
	var _t480 = env["begin"]
	v_S_348 = J.cl(_t480, null, [v_ctx_346, v_a_347, "npc_boss__bodyN", false])
	if (not J.t(v_S_348)):
		return false
	v_t_349 = J.gp(v_S_348, "at")
	v_k_350 = J.gp(v_S_348, "env")
	var _t481 = env["kf"]
	v_up_351 = J.cl(_t481, null, [[[0.0, 0.0], [0.5, 1.0], [2.2, 1.0], [2.7, 0.0]], v_t_349])
	var _t483 = sin(J.num((J.max_([0.0, J.sub(v_t_349, 0.5)]) * 30.0)))
	var _t482 = env["bump"]
	v_flick_352 = J.mul(_t483, J.cl(_t482, null, [v_t_349, 0.5, 0.55, 0.75]))
	var _t485 = J.max_([0.0, sin(J.num(J.mul(v_t_349, 9.0)))])
	var _t484 = env["seg"]
	var _t487 = J.mul(_t485, J.cl(_t484, null, [v_t_349, 1.2, 1.4]))
	var _t486 = env["seg"]
	v_tap_353 = (_t487 * J.sub(1.0, J.cl(_t486, null, [v_t_349, 2.3, 2.5])))
	var _t488 = env["bossDraw"]
	J.cl(_t488, null, [v_S_348, {"glove": J.mul(v_k_350, (J.mul(v_up_351, 1.45) + J.mul(v_flick_352, 0.05))), "shUp": (J.mul(v_k_350, v_up_351) * 0.01), "head": (J.mul(J.mul(J.gp(v_S_348, "fs"), v_k_350), v_up_351) * 0.16), "lean": (J.mul(J.mul(J.gp(v_S_348, "fs"), v_k_350), v_up_351) * 0.02), "legF": ((J.mul(v_k_350, v_tap_353) * 0.12) * (-J.num(J.gp(v_S_348, "fs"))))}])
	v_m_354 = J.mc(v_S_348, "P", [0.5, 0.0])
	var _t489 = env["text"]
	var _t491 = J.sub(J.gp(v_m_354, 0.0), (J.mul(J.gp(v_S_348, "fs"), J.gp(v_S_348, "W")) * 0.42))
	var _t492 = J.add(J.gp(v_m_354, 1.0), J.mul(J.gp(v_S_348, "H"), 0.04))
	var _t493 = J.mul(J.gp(v_S_348, "H"), 0.11)
	var _t490 = env["bump"]
	J.cl(_t489, null, [v_S_348, _t491, _t492, "嘖", _t493, J.mul(J.cl(_t490, null, [v_t_349, 1.4, 1.6, 2.3]), v_k_350)])
	var _t494 = env["end"]
	J.cl(_t494, null, [v_S_348])
	return true

func _f45(this_, a: Array, env):
	var v_L_369 = null; var v_p_370 = null
	v_L_369 = J.arg(a, 0)
	v_p_370 = J.cl(v_L_369, null, J.spread([J.SP(J.gp(env["__p"]["BOSS"], "HAND"))]))
	var _t503 = env["__p"]["prop"]
	J.cl(_t503, null, [env["ctx"], "afu__phone", J.add(J.gp(v_p_370, 0.0), (J.mul(J.gp(env["S"], "fs"), J.gp(env["S"], "W")) * 0.02)), J.sub(J.gp(v_p_370, 1.0), J.mul(J.gp(env["S"], "H"), 0.04)), (J.mul(J.mul(J.mul(J.gp(env["S"], "H"), 0.14), env["up"]), env["k"]) + 0.0001), (((-J.num(J.gp(env["S"], "fs"))) * 0.3) - J.mul(J.mul(env["up"], 1.75), env["k"])), 0.5, 0.6, (-J.num(J.gp(env["S"], "fs"))), 1.0])

func _f44(this_, a: Array, env):
	var v_a_358 = null; var v_t_360 = null; var v_yell_363 = null; var v_jab_364 = null; var v_sh_365 = null; var v_m_366 = null; var v_words_367 = null; var v_wi_368 = null
	var _s66 = {"__p": env, "ctx": null, "S": null, "k": null, "up": null}
	_s66["ctx"] = J.arg(a, 0)
	v_a_358 = J.arg(a, 1)
	var _t497 = _s66["__p"]["begin"]
	_s66["S"] = J.cl(_t497, null, [_s66["ctx"], v_a_358, "npc_boss__bodyN", false])
	if (not J.t(_s66["S"])):
		return false
	v_t_360 = J.gp(_s66["S"], "at")
	_s66["k"] = J.gp(_s66["S"], "env")
	var _t498 = _s66["__p"]["kf"]
	_s66["up"] = J.cl(_t498, null, [[[0.0, 0.0], [0.5, 1.0], [3.4, 1.0], [3.9, 0.0]], v_t_360])
	var _t499 = _s66["__p"]["seg"]
	var _t501 = J.cl(_t499, null, [v_t_360, 0.8, 1.0])
	var _t500 = _s66["__p"]["seg"]
	v_yell_363 = J.mul(_t501, J.sub(1.0, J.cl(_t500, null, [v_t_360, 3.2, 3.5])))
	v_jab_364 = J.mul(J.max_([0.0, sin(J.num(J.mul(v_t_360, 7.5)))]), v_yell_363)
	v_sh_365 = J.mul((sin(J.num(J.mul(v_t_360, 40.0))) * 0.008), v_yell_363)
	var _t502 = _s66["__p"]["bossDraw"]
	J.cl(_t502, null, [_s66["S"], {"glove": J.mul(_s66["k"], (J.mul(_s66["up"], 1.75) + J.mul(v_jab_364, 0.06))), "shUp": (J.mul(_s66["k"], _s66["up"]) * 0.03), "head": J.add((J.mul(J.gp(_s66["S"], "fs"), _s66["k"]) * (J.mul(_s66["up"], 0.06) + J.mul(v_jab_364, 0.08))), v_sh_365), "lean": (J.mul(J.gp(_s66["S"], "fs"), _s66["k"]) * J.mul(v_jab_364, 0.04)), "dx": (J.mul(J.mul(J.mul(J.gp(_s66["S"], "fs"), _s66["k"]), v_jab_364), J.gp(_s66["S"], "H")) * 0.01), "gfn": Callable(self, "_f45").bind(_s66)}])
	v_m_366 = J.mc(_s66["S"], "P", J.spread([J.SP(J.gp(_s66["__p"]["BOSS"], "MOUTH"))]))
	v_words_367 = ["喂？！", "我不管！", "明天交！"]
	v_wi_368 = J.min_([2.0, floor(J.num(J.div(J.max_([0.0, J.sub(v_t_360, 0.9)]), 0.85)))])
	var _t504 = _s66["__p"]["text"]
	J.cl(_t504, null, [_s66["S"], J.add(J.gp(v_m_366, 0.0), (J.mul(J.gp(_s66["S"], "fs"), J.gp(_s66["S"], "W")) * 0.55)), (J.sub(J.gp(v_m_366, 1.0), J.mul(J.gp(_s66["S"], "H"), 0.3)) - (J.mul(v_jab_364, J.gp(_s66["S"], "H")) * 0.02)), J.gp(v_words_367, v_wi_368), J.mul(J.gp(_s66["S"], "H"), 0.1), J.mul(v_yell_363, _s66["k"]), {"col": "#ffe0d8", "rot": (-0.08)}])
	var _t505 = _s66["__p"]["anger"]
	J.cl(_t505, null, [_s66["ctx"], J.gp(J.mc(_s66["S"], "P", [0.66, 0.08]), 0.0), J.gp(J.mc(_s66["S"], "P", [0.66, 0.08]), 1.0), J.mul(J.gp(_s66["S"], "H"), 0.07), (J.mul(v_yell_363, _s66["k"]) * (0.8 + (0.2 * sin(J.num(J.mul(v_t_360, 12.0))))))])
	var _t506 = _s66["__p"]["end"]
	J.cl(_t506, null, [_s66["S"]])
	return true

func _f46(this_, a: Array, env):
	var v_ctx_373 = null; var v_a_374 = null; var v_S_375 = null; var v_t_376 = null; var v_k_377 = null
	v_ctx_373 = J.arg(a, 0)
	v_a_374 = J.arg(a, 1)
	var _t509 = env["begin"]
	v_S_375 = J.cl(_t509, null, [v_ctx_373, v_a_374, "npc_boss__bodyN", false])
	if (not J.t(v_S_375)):
		return false
	v_t_376 = J.gp(v_S_375, "at")
	v_k_377 = J.gp(v_S_375, "env")
	var _t510 = env["bossDraw"]
	J.cl(_t510, null, [v_S_375, {"ball": (J.mul(v_k_377, sin(J.num(J.mul(v_t_376, 1.6)))) * 0.06), "head": (J.mul(J.gp(v_S_375, "fs"), v_k_377) * (0.05 + (sin(J.num((J.mul(v_t_376, 1.6) + 0.4))) * 0.025)))}])
	var _t511 = env["end"]
	J.cl(_t511, null, [v_S_375])
	return true

func _f49(this_, a: Array, env):
	var v_ctx_402 = null; var v_a_403 = null; var v_S_404 = null; var v_t_405 = null; var v_k_406 = null; var v_sw_407 = null
	v_ctx_402 = J.arg(a, 0)
	v_a_403 = J.arg(a, 1)
	var _t514 = env["begin"]
	v_S_404 = J.cl(_t514, null, [v_ctx_402, v_a_403, "npc_guard__bodyN", false])
	if (not J.t(v_S_404)):
		return false
	v_t_405 = J.gp(v_S_404, "at")
	v_k_406 = J.gp(v_S_404, "env")
	v_sw_407 = ((sin(J.num(J.mul(v_t_405, 1.9))) * 0.16) + (sin(J.num(J.mul(v_t_405, 0.7))) * 0.05))
	var _t515 = env["guardDraw"]
	J.cl(_t515, null, [v_S_404, {"fl": J.mul(v_k_406, J.add(v_sw_407, 0.04)), "head": (J.mul(J.gp(v_S_404, "fs"), v_k_406) * (((-J.num(v_sw_407)) * 0.35) + 0.02)), "arm": ((J.mul(v_k_406, sin(J.num(J.mul(J.gp(v_S_404, "t"), 7.0)))) * 0.05) * (1.0 if J.t(J.gp(v_S_404, "walk")) else 0.0))}])
	var _t516 = env["end"]
	J.cl(_t516, null, [v_S_404])
	return true

func _f52(this_, a: Array, env):
	var v_ctx_431 = null; var v_a_432 = null; var v_S_433 = null
	v_ctx_431 = J.arg(a, 0)
	v_a_432 = J.arg(a, 1)
	var _t519 = env["begin"]
	v_S_433 = J.cl(_t519, null, [v_ctx_431, v_a_432, "npc_guard__bodyN", false])
	if (not J.t(v_S_433)):
		return false
	var _t520 = env["guardSip"]
	J.cl(_t520, null, [v_S_433])
	var _t521 = env["end"]
	J.cl(_t521, null, [v_S_433])
	return true

func _f53(this_, a: Array, env):
	var v_ctx_436 = null; var v_a_437 = null; var v_S_438 = null; var v_t_439 = null; var v_k_440 = null; var v_nod_441 = null; var v_jerk_442 = null; var v_h_443 = null
	v_ctx_436 = J.arg(a, 0)
	v_a_437 = J.arg(a, 1)
	var _t524 = env["begin"]
	v_S_438 = J.cl(_t524, null, [v_ctx_436, v_a_437, "npc_guard__bodyN", false])
	if (not J.t(v_S_438)):
		return false
	v_t_439 = J.gp(v_S_438, "at")
	v_k_440 = J.gp(v_S_438, "env")
	var _t525 = env["kf"]
	v_nod_441 = J.cl(_t525, null, [[[0.0, 0.0], [1.2, 0.6], [1.5, 0.5], [2.6, 1.0], [3.2, 1.0], [3.35, (-0.25)], [3.7, 0.05], [4.2, 0.0]], v_t_439])
	var _t526 = env["bump"]
	v_jerk_442 = J.cl(_t526, null, [v_t_439, 3.2, 3.35, 3.7])
	J.mc(v_ctx_436, "save", [])
	J.mc(v_ctx_436, "scale", [1.0, (1.0 - J.mul((0.03 * J.max_([0.0, v_nod_441])), v_k_440))])
	var _t527 = env["guardDraw"]
	J.cl(_t527, null, [v_S_438, {"head": (J.mul(J.mul(J.gp(v_S_438, "fs"), v_k_440), v_nod_441) * 0.5), "lean": (J.mul(J.mul(J.gp(v_S_438, "fs"), v_k_440), v_nod_441) * 0.06), "dy": J.mul(v_k_440, ((J.mul(J.max_([0.0, v_nod_441]), J.gp(v_S_438, "H")) * 0.015) - (J.mul(v_jerk_442, J.gp(v_S_438, "H")) * 0.03))), "fl": (((-J.num(v_k_440)) * J.max_([0.0, v_nod_441])) * 0.45), "arm": (((-J.num(v_k_440)) * J.max_([0.0, v_nod_441])) * 0.06)}])
	J.mc(v_ctx_436, "restore", [])
	v_h_443 = J.mc(v_S_438, "P", [0.3, 0.12])
	var _t528 = env["zzz"]
	var _t532 = J.sub(J.gp(v_h_443, 0.0), (J.mul(J.gp(v_S_438, "fs"), J.gp(v_S_438, "W")) * 0.15))
	var _t533 = J.gp(v_h_443, 1.0)
	var _t534 = J.mul(J.gp(v_S_438, "H"), 0.09)
	var _t529 = env["seg"]
	var _t531 = J.cl(_t529, null, [v_t_439, 1.0, 1.5])
	var _t530 = env["seg"]
	J.cl(_t528, null, [v_S_438, _t532, _t533, _t534, v_t_439, J.mul(J.mul(_t531, J.sub(1.0, J.cl(_t530, null, [v_t_439, 3.1, 3.25]))), v_k_440)])
	var _t535 = env["marks"]
	J.cl(_t535, null, [v_ctx_436, J.gp(J.mc(v_S_438, "P", [0.5, 0.05]), 0.0), J.sub(J.gp(J.mc(v_S_438, "P", [0.5, 0.05]), 1.0), J.mul(J.gp(v_S_438, "H"), 0.03)), J.mul(J.gp(v_S_438, "H"), 0.09), J.mul(v_jerk_442, v_k_440)])
	var _t536 = env["end"]
	J.cl(_t536, null, [v_S_438])
	return true

func _f59(this_, a: Array, env):
	var v_th_483 = null
	v_th_483 = J.arg(a, 0)
	return J.sub(v_th_483, J.mul(J.round(J.num(J.div(v_th_483, env["PI"]))), env["PI"]))

func _f61(this_, a: Array, env):
	var v_S_502 = null; var v_down_503 = null; var v_want_504 = null; var v_th_505 = null
	v_S_502 = J.arg(a, 0)
	v_down_503 = J.arg(a, 1)
	v_want_504 = (v_down_503 if J.cmp(J.gp(v_S_502, "fs"), 0.0, ">") else J.sub(env["PI"], v_down_503))
	v_th_505 = J.sub(v_want_504, env["HEAD0"])
	while true:
		if not J.cmp(v_th_505, env["PI"], ">"): break
		var _t538 = J.sub(v_th_505, J.mul(2.0, env["PI"]))
		v_th_505 = _t538
	while true:
		if not J.cmp(v_th_505, (-J.num(env["PI"])), "<"): break
		var _t539 = J.add(v_th_505, J.mul(2.0, env["PI"]))
		v_th_505 = _t539
	return v_th_505

func _f63(this_, a: Array, env):
	var v_L_519 = null; var v_h_520 = null; var v_i_521 = null
	v_L_519 = J.arg(a, 0)
	if J.cmp(env["k"], 0.5, "<"):
		return null
	v_h_520 = J.cl(v_L_519, null, J.spread([J.SP(J.gp(env["__p"]["AU"], "HEAD"))]))
	v_i_521 = 0.0
	while true:
		if not J.cmp(v_i_521, 2.0, "<"): break
		var _t548 = env["__p"]["drop"]
		J.cl(_t548, null, [env["ctx"], J.add(J.gp(v_h_520, 0.0), (J.mul(J.sub(v_i_521, 0.5), J.gp(env["S"], "H")) * 0.05)), J.gp(v_h_520, 1.0), J.mul(J.gp(env["S"], "H"), 0.009), J.mod((J.mul(env["t"], 0.7) + J.mul(v_i_521, 0.5)), 1.0), J.mul(J.gp(env["S"], "H"), 0.04)])
		v_i_521 = J.num(v_i_521) + 1.0

func _f62(this_, a: Array, env):
	var v_a_509 = null; var v_push_513 = null; var v_q_514 = null; var v_th_515 = null; var v_fx_516 = null; var v_fy_517 = null; var v_g_518 = null
	var _s88 = {"__p": env, "ctx": null, "S": null, "t": null, "k": null}
	_s88["ctx"] = J.arg(a, 0)
	v_a_509 = J.arg(a, 1)
	var _t541 = _s88["__p"]["begin"]
	_s88["S"] = J.cl(_t541, null, [_s88["ctx"], v_a_509, "npc_auntie__bodyH", false])
	if (not J.t(_s88["S"])):
		return false
	_s88["t"] = J.gp(_s88["S"], "at")
	_s88["k"] = J.gp(_s88["S"], "env")
	v_push_513 = sin(J.num(J.mul(_s88["t"], 3.4)))
	var _t542 = _s88["__p"]["ss"]
	v_q_514 = J.cl(_t542, null, [_s88["k"]])
	var _t543 = _s88["__p"]["auTh"]
	v_th_515 = J.mul(J.cl(_t543, null, [_s88["S"], (0.62 + J.mul(v_push_513, 0.06))]), v_q_514)
	v_fx_516 = (J.mul(v_q_514, J.gp(_s88["S"], "fs")) * (0.03 + J.mul(v_push_513, 0.05)))
	v_fy_517 = J.mul(v_q_514, (0.05 - J.mul(v_push_513, 0.01)))
	if J.cmp(_s88["k"], 0.3, ">"):
		v_g_518 = J.add(J.gp(J.mc(_s88["S"], "P", J.spread([J.SP(J.gp(_s88["__p"]["AU"], "FIST"))])), 0.0), (J.mul(J.gp(_s88["S"], "fs"), J.gp(_s88["S"], "H")) * 0.42))
		J.mc(_s88["ctx"], "save", [])
		var _t544 = _s88["ctx"]
		var _t545 = J.mul(J.gp(_t544, "globalAlpha"), (J.sub(_s88["k"], 0.3) * 0.8))
		J.sp(_t544, "globalAlpha", _t545)
		var _t546 = _s88["ctx"]
		J.sp(_t546, "fillStyle", "rgba(160,210,230,.2)")
		J.mc(_s88["ctx"], "beginPath", [])
		J.mc(_s88["ctx"], "ellipse", [v_g_518, ((-J.num(J.gp(_s88["S"], "H"))) * 0.004), J.mul(J.gp(_s88["S"], "H"), 0.28), J.mul(J.gp(_s88["S"], "H"), 0.035), 0.0, 0.0, J.mul(_s88["__p"]["PI"], 2.0)])
		J.mc(_s88["ctx"], "fill", [])
		J.mc(_s88["ctx"], "restore", [])
	var _t547 = _s88["__p"]["auntieDraw"]
	J.cl(_t547, null, [_s88["S"], {"th": v_th_515, "fx": v_fx_516, "fy": v_fy_517, "floor": ((-J.num(J.gp(_s88["S"], "H"))) * 0.045), "reach": v_q_514, "lean": (J.mul(J.gp(_s88["S"], "fs"), _s88["k"]) * (0.05 + J.mul(v_push_513, 0.025))), "head": (J.mul(J.gp(_s88["S"], "fs"), _s88["k"]) * (0.08 + J.mul(v_push_513, 0.02))), "legF": (0.0 if J.t(J.gp(_s88["S"], "walk")) else 0.0), "mfn": Callable(self, "_f63").bind(_s88)}])
	var _t549 = _s88["__p"]["end"]
	J.cl(_t549, null, [_s88["S"]])
	return true

func _f65(this_, a: Array, env):
	var v_FX_536 = null; var v_FY_537 = null; var v_TH_538 = null; var v_s_539 = null; var v_sh_540 = null; var v_H0_541 = null; var v_h0_542 = null; var v_A_543 = null; var v_c_544 = null; var v_sn_545 = null; var v_up_546 = null; var v_g_547 = null; var v_a0_548 = null; var v_ang_549 = null; var v_r_550 = null; var v_fix_551 = null
	v_FX_536 = J.arg(a, 0)
	v_FY_537 = J.arg(a, 1)
	v_TH_538 = J.arg(a, 2)
	v_s_539 = J.arg(a, 3)
	v_sh_540 = J.mc(env["S"], "P", J.spread([J.SP(J.gp(env["__p"]["AU"], "SH"))]))
	v_H0_541 = J.mc(env["S"], "P", J.spread([J.SP(J.gp(env["__p"]["AU"], "HAND"))]))
	v_h0_542 = [J.sub(J.gp(v_H0_541, 0.0), J.gp(v_sh_540, 0.0)), J.sub(J.gp(v_H0_541, 1.0), J.gp(v_sh_540, 1.0))]
	var _t559 = env["__p"]["auAxis"]
	v_A_543 = J.cl(_t559, null, [env["S"]])
	v_c_544 = cos(J.num(v_TH_538))
	v_sn_545 = sin(J.num(v_TH_538))
	v_up_546 = [(-(J.mul(J.gp(v_A_543, "ux"), v_c_544) - J.mul(J.gp(v_A_543, "uy"), v_sn_545))), (-(J.mul(J.gp(v_A_543, "ux"), v_sn_545) + J.mul(J.gp(v_A_543, "uy"), v_c_544)))]
	v_g_547 = [J.sub(v_FX_536, (J.mul(J.gp(v_up_546, 0.0), J.gp(env["S"], "H")) * 0.12)), J.sub(v_FY_537, (J.mul(J.gp(v_up_546, 1.0), J.gp(env["S"], "H")) * 0.12))]
	v_a0_548 = atan2(J.num(J.gp(v_h0_542, 1.0)), J.num(J.gp(v_h0_542, 0.0)))
	v_ang_549 = J.sub(atan2(J.num(J.sub(J.gp(v_g_547, 1.0), J.gp(v_sh_540, 1.0))), J.num(J.sub(J.gp(v_g_547, 0.0), J.gp(v_sh_540, 0.0)))), v_a0_548)
	v_r_550 = J.hypot_([J.gp(v_h0_542, 0.0), J.gp(v_h0_542, 1.0)])
	v_fix_551 = [J.sub(J.gp(v_g_547, 0.0), J.add(J.gp(v_sh_540, 0.0), J.mul(cos(J.num(J.add(v_ang_549, v_a0_548))), v_r_550))), J.sub(J.gp(v_g_547, 1.0), J.add(J.gp(v_sh_540, 1.0), J.mul(sin(J.num(J.add(v_ang_549, v_a0_548))), v_r_550)))]
	var _t560 = env["__p"]["piece"]
	J.cl(_t560, null, [env["S"], "npc_auntie__hip", J.gp(env["__p"]["AU"], "SH"), [J.add(J.gp(v_sh_540, 0.0), J.mul(J.gp(v_fix_551, 0.0), env["q"])), J.add(J.gp(v_sh_540, 1.0), J.mul(J.gp(v_fix_551, 1.0), env["q"]))], (J.mul(v_ang_549, env["q"]) - J.mul(J.mul(env["tw"], 0.06), env["q"]))])

func _f66(this_, a: Array, env):
	var v_L_552 = null; var v_h_553 = null; var v_sq_554 = null; var v_i_555 = null
	v_L_552 = J.arg(a, 0)
	if J.cmp(env["k"], 0.5, "<"):
		return null
	v_h_553 = J.cl(v_L_552, null, J.spread([J.SP(J.gp(env["__p"]["AU"], "HEAD"))]))
	v_sq_554 = absf(J.num(env["tw"]))
	v_i_555 = 0.0
	while true:
		if not J.cmp(v_i_555, 4.0, "<"): break
		var _t562 = env["__p"]["drop"]
		var _t565 = env["ctx"]
		var _t564 = J.gp(v_h_553, 0.0)
		var _t563 = env["__p"]["rnd"]
		J.cl(_t562, null, [_t565, J.add(_t564, (J.mul(J.sub(J.cl(_t563, null, [v_i_555]), 0.5), J.gp(env["S"], "H")) * 0.1)), J.add(J.gp(v_h_553, 1.0), J.mul(J.gp(env["S"], "H"), 0.01)), J.mul(J.gp(env["S"], "H"), 0.01), J.mod((J.mul(env["t"], 1.7) + J.div(v_i_555, 4.0)), 1.0), J.mul(J.mul(J.gp(env["S"], "H"), 0.05), J.add(0.4, v_sq_554))])
		v_i_555 = J.num(v_i_555) + 1.0

func _f64(this_, a: Array, env):
	var v_a_525 = null; var v_th_531 = null; var v_fx_532 = null; var v_fy_533 = null; var v_hipF_534 = null; var v_hip_535 = null
	var _s92 = {"__p": env, "ctx": null, "S": null, "t": null, "k": null, "q": null, "tw": null}
	_s92["ctx"] = J.arg(a, 0)
	v_a_525 = J.arg(a, 1)
	var _t552 = _s92["__p"]["begin"]
	_s92["S"] = J.cl(_t552, null, [_s92["ctx"], v_a_525, "npc_auntie__bodyH", false])
	if (not J.t(_s92["S"])):
		return false
	_s92["t"] = J.gp(_s92["S"], "at")
	_s92["k"] = J.gp(_s92["S"], "env")
	var _t553 = _s92["__p"]["ss"]
	_s92["q"] = J.cl(_t553, null, [_s92["k"]])
	var _t555 = sin(J.num(J.mul(_s92["t"], 8.0)))
	var _t554 = _s92["__p"]["seg"]
	var _t557 = J.mul(_t555, J.cl(_t554, null, [_s92["t"], 0.45, 0.65]))
	var _t556 = _s92["__p"]["seg"]
	_s92["tw"] = (_t557 * J.sub(1.0, J.cl(_t556, null, [_s92["t"], 1.8, 2.0])))
	var _t558 = _s92["__p"]["auTh"]
	v_th_531 = (J.mul(J.cl(_t558, null, [_s92["S"], (J.div(_s92["__p"]["PI"], 2.0) + J.mul(J.gp(_s92["S"], "fs"), 0.12))]), _s92["q"]) + J.mul(_s92["tw"], 0.04))
	v_fx_532 = (J.mul(_s92["q"], J.gp(_s92["S"], "fs")) * 0.05)
	v_fy_533 = J.mul(_s92["q"], 0.04)
	v_hipF_534 = null
	v_hip_535 = Callable(self, "_f65").bind(_s92)
	var _t561 = _s92["__p"]["auntieDraw"]
	J.cl(_t561, null, [_s92["S"], {"th": v_th_531, "fx": v_fx_532, "fy": v_fy_533, "floor": ((-J.num(J.gp(_s92["S"], "H"))) * 0.06), "reach": _s92["q"], "fa": J.mul(_s92["tw"], 0.08), "lean": (J.mul(J.gp(_s92["S"], "fs"), _s92["k"]) * 0.06), "head": (J.mul(J.gp(_s92["S"], "fs"), _s92["k"]) * 0.12), "hip": v_hip_535, "mfn": Callable(self, "_f66").bind(_s92)}])
	var _t566 = _s92["__p"]["end"]
	J.cl(_t566, null, [_s92["S"]])
	return true

func _f67(this_, a: Array, env):
	var v_ctx_558 = null; var v_a_559 = null; var v_S_560 = null; var v_t_561 = null; var v_k_562 = null; var v_tap_563 = null; var v_shake_564 = null; var v_h_565 = null
	v_ctx_558 = J.arg(a, 0)
	v_a_559 = J.arg(a, 1)
	var _t569 = env["begin"]
	v_S_560 = J.cl(_t569, null, [v_ctx_558, v_a_559, "npc_auntie__bodyH", false])
	if (not J.t(v_S_560)):
		return false
	v_t_561 = J.gp(v_S_560, "at")
	v_k_562 = J.gp(v_S_560, "env")
	var _t571 = J.max_([0.0, sin(J.num(J.mul(v_t_561, 7.0)))])
	var _t570 = env["seg"]
	var _t573 = J.mul(_t571, J.cl(_t570, null, [v_t_561, 0.2, 0.4]))
	var _t572 = env["seg"]
	v_tap_563 = (_t573 * J.sub(1.0, J.cl(_t572, null, [v_t_561, 1.0, 1.2])))
	var _t575 = sin(J.num(J.mul(v_t_561, 9.0)))
	var _t574 = env["seg"]
	var _t577 = J.mul(_t575, J.cl(_t574, null, [v_t_561, 1.1, 1.3]))
	var _t576 = env["seg"]
	v_shake_564 = (_t577 * J.sub(1.0, J.cl(_t576, null, [v_t_561, 2.0, 2.2])))
	var _t578 = env["auntieDraw"]
	J.cl(_t578, null, [v_S_560, {"fy": (J.mul((-J.num(v_k_562)), v_tap_563) * 0.025), "head": J.mul(v_k_562, (J.mul(v_shake_564, 0.1) + J.mul(J.gp(v_S_560, "fs"), 0.03))), "lean": (J.mul((-J.num(J.gp(v_S_560, "fs"))), v_k_562) * 0.02)}])
	v_h_565 = J.mc(v_S_560, "P", [0.45, 0.12])
	var _t579 = env["text"]
	var _t583 = J.sub(J.gp(v_h_565, 0.0), (J.mul(J.gp(v_S_560, "fs"), J.gp(v_S_560, "W")) * 0.42))
	var _t584 = J.sub(J.gp(v_h_565, 1.0), J.mul(J.gp(v_S_560, "H"), 0.05))
	var _t585 = ("哼！" if J.cmp(v_t_561, 1.1, "<") else "嘖嘖……")
	var _t586 = J.mul(J.gp(v_S_560, "H"), 0.1)
	var _t580 = env["bump"]
	var _t582 = J.cl(_t580, null, [v_t_561, 0.15, 0.3, 1.0])
	var _t581 = env["bump"]
	J.cl(_t579, null, [v_S_560, _t583, _t584, _t585, _t586, J.mul(J.add(_t582, J.cl(_t581, null, [v_t_561, 1.1, 1.3, 2.2])), v_k_562)])
	var _t587 = env["anger"]
	var _t589 = J.gp(J.mc(v_S_560, "P", [0.7, 0.1]), 0.0)
	var _t590 = J.gp(J.mc(v_S_560, "P", [0.7, 0.1]), 1.0)
	var _t591 = J.mul(J.gp(v_S_560, "H"), 0.075)
	var _t588 = env["bump"]
	J.cl(_t587, null, [v_ctx_558, _t589, _t590, _t591, J.mul(J.cl(_t588, null, [v_t_561, 0.2, 0.4, 2.1]), v_k_562)])
	var _t592 = env["end"]
	J.cl(_t592, null, [v_S_560])
	return true

func _f68(this_, a: Array, env):
	var v_t_566 = null; var v_T_567 = null
	v_t_566 = J.arg(a, 0)
	v_T_567 = J.arg(a, 1)
	return J.mod(J.add(J.mod(v_t_566, v_T_567), v_T_567), v_T_567)

func _f69(this_, a: Array, env):
	var v_ctx_570 = null; var v_a_571 = null; var v_S_572 = null; var v_t_573 = null; var v_k_574 = null; var v_q_575 = null; var v_up_576 = null; var v_jab_577 = null; var v_look_578 = null
	v_ctx_570 = J.arg(a, 0)
	v_a_571 = J.arg(a, 1)
	var _t595 = env["begin"]
	v_S_572 = J.cl(_t595, null, [v_ctx_570, v_a_571, "npc_boss__bodyN", false])
	if (not J.t(v_S_572)):
		return false
	v_t_573 = J.gp(v_S_572, "at")
	v_k_574 = J.gp(v_S_572, "env")
	var _t596 = env["loop"]
	v_q_575 = J.cl(_t596, null, [v_t_573, 5.2])
	var _t597 = env["kf"]
	v_up_576 = J.cl(_t597, null, [[[0.0, 0.55], [0.6, 1.0], [3.6, 1.0], [4.3, 0.55], [5.2, 0.55]], v_q_575])
	var _t599 = J.max_([0.0, sin(J.num(J.mul(v_t_573, 6.5)))])
	var _t598 = env["bump"]
	v_jab_577 = J.mul(_t599, J.cl(_t598, null, [v_q_575, 0.8, 1.2, 3.2]))
	v_look_578 = sin(J.num(J.mul(v_t_573, 0.9)))
	var _t600 = env["bossDraw"]
	J.cl(_t600, null, [v_S_572, {"glove": ((-J.num(v_k_574)) * (J.mul(v_up_576, 2.3) + J.mul(v_jab_577, 0.1))), "shUp": (J.mul(v_k_574, v_up_576) * 0.012), "head": (J.mul(J.gp(v_S_572, "fs"), v_k_574) * (J.mul((-0.05), v_up_576) + J.mul(0.04, v_look_578))), "lean": (J.mul(J.mul((-J.num(J.gp(v_S_572, "fs"))), v_k_574), v_jab_577) * 0.012), "ball": (J.mul(v_k_574, 0.04) * sin(J.num(J.mul(v_t_573, 1.3))))}])
	var _t601 = env["end"]
	J.cl(_t601, null, [v_S_572])
	return true

func _f71(this_, a: Array, env):
	var v_L_589 = null; var v_p_590 = null
	v_L_589 = J.arg(a, 0)
	v_p_590 = J.cl(v_L_589, null, J.spread([J.SP(J.gp(env["__p"]["BOSS"], "HAND"))]))
	var _t608 = env["__p"]["prop"]
	J.cl(_t608, null, [env["ctx"], "op_paper_fly", J.add(J.gp(v_p_590, 0.0), (J.mul(J.gp(env["S"], "fs"), J.gp(env["S"], "W")) * 0.03)), J.sub(J.gp(v_p_590, 1.0), J.mul(J.gp(env["S"], "H"), 0.05)), (J.mul(J.mul(J.gp(env["S"], "H"), 0.22), env["k"]) + 0.0001), (((-J.num(J.gp(env["S"], "fs"))) * 0.15) - J.mul(1.25, env["k"])), 0.5, 0.6, ((1.0 - J.mul(env["flip"], 1.6)) * (1.0 if J.cmp(J.gp(env["S"], "fs"), 0.0, ">") else (-1.0))), 1.0])

func _f70(this_, a: Array, env):
	var v_a_582 = null; var v_t_584 = null; var v_q_586 = null; var v_scan_588 = null
	var _s99 = {"__p": env, "ctx": null, "S": null, "k": null, "flip": null}
	_s99["ctx"] = J.arg(a, 0)
	v_a_582 = J.arg(a, 1)
	var _t604 = _s99["__p"]["begin"]
	_s99["S"] = J.cl(_t604, null, [_s99["ctx"], v_a_582, "npc_boss__bodyN", false])
	if (not J.t(_s99["S"])):
		return false
	v_t_584 = J.gp(_s99["S"], "at")
	_s99["k"] = J.gp(_s99["S"], "env")
	var _t605 = _s99["__p"]["loop"]
	v_q_586 = J.cl(_t605, null, [v_t_584, 4.6])
	var _t606 = _s99["__p"]["bump"]
	_s99["flip"] = J.cl(_t606, null, [v_q_586, 3.6, 3.85, 4.2])
	v_scan_588 = J.mod(J.div(v_q_586, 3.6), 1.0)
	var _t607 = _s99["__p"]["bossDraw"]
	J.cl(_t607, null, [_s99["S"], {"glove": J.mul(_s99["k"], ((1.25 + (0.04 * sin(J.num(J.mul(v_t_584, 1.1))))) - J.mul(_s99["flip"], 0.12))), "shUp": J.mul(_s99["k"], 0.012), "head": (J.mul(J.gp(_s99["S"], "fs"), _s99["k"]) * (0.13 + J.mul(v_scan_588, 0.05))), "lean": (J.mul(J.gp(_s99["S"], "fs"), _s99["k"]) * 0.02), "gfn": Callable(self, "_f71").bind(_s99)}])
	var _t609 = _s99["__p"]["end"]
	J.cl(_t609, null, [_s99["S"]])
	return true

func _f73(this_, a: Array, env):
	var v_L_601 = null; var v_p_602 = null
	v_L_601 = J.arg(a, 0)
	v_p_602 = J.cl(v_L_601, null, J.spread([J.SP(J.gp(env["__p"]["BOSS"], "HAND"))]))
	var _t616 = env["__p"]["prop"]
	J.cl(_t616, null, [env["ctx"], "afu__phone", J.add(J.gp(v_p_602, 0.0), (J.mul(J.gp(env["S"], "fs"), J.gp(env["S"], "W")) * 0.01)), J.sub(J.gp(v_p_602, 1.0), J.mul(J.gp(env["S"], "H"), 0.035)), (J.mul(J.mul(J.gp(env["S"], "H"), 0.12), env["k"]) + 0.0001), (((-J.num(J.gp(env["S"], "fs"))) * 0.5) - J.mul(2.55, env["k"])), 0.5, 0.6, (-J.num(J.gp(env["S"], "fs"))), 1.0])

func _f72(this_, a: Array, env):
	var v_a_594 = null; var v_t_596 = null; var v_q_598 = null; var v_rant_599 = null; var v_nod_600 = null
	var _s101 = {"__p": env, "ctx": null, "S": null, "k": null}
	_s101["ctx"] = J.arg(a, 0)
	v_a_594 = J.arg(a, 1)
	var _t612 = _s101["__p"]["begin"]
	_s101["S"] = J.cl(_t612, null, [_s101["ctx"], v_a_594, "npc_boss__bodyN", false])
	if (not J.t(_s101["S"])):
		return false
	v_t_596 = J.gp(_s101["S"], "at")
	_s101["k"] = J.gp(_s101["S"], "env")
	var _t613 = _s101["__p"]["loop"]
	v_q_598 = J.cl(_t613, null, [v_t_596, 7.0])
	var _t614 = _s101["__p"]["bump"]
	v_rant_599 = J.cl(_t614, null, [v_q_598, 4.6, 5.0, 6.2])
	v_nod_600 = (J.max_([0.0, sin(J.num(J.mul(v_t_596, 2.2)))]) * J.sub(1.0, v_rant_599))
	var _t615 = _s101["__p"]["bossDraw"]
	J.cl(_t615, null, [_s101["S"], {"glove": J.mul(_s101["k"], ((2.55 - J.mul(v_rant_599, 0.25)) + J.mul((sin(J.num(J.mul(v_t_596, 9.0))) * 0.03), v_rant_599))), "shUp": J.mul(_s101["k"], 0.04), "head": (J.mul(J.gp(_s101["S"], "fs"), _s101["k"]) * (((-0.1) + J.mul(v_nod_600, 0.05)) - J.mul(v_rant_599, 0.04))), "lean": (J.mul(J.mul((-J.num(J.gp(_s101["S"], "fs"))), _s101["k"]), v_rant_599) * 0.02), "ball": J.mul(_s101["k"], (J.mul(v_rant_599, 0.12) * sin(J.num(J.mul(v_t_596, 6.0))))), "gfn": Callable(self, "_f73").bind(_s101)}])
	var _t617 = _s101["__p"]["end"]
	J.cl(_t617, null, [_s101["S"]])
	return true

func _f74(this_, a: Array, env):
	var v_ctx_605 = null; var v_a_606 = null; var v_S_607 = null; var v_t_608 = null; var v_k_609 = null; var v_sweep_610 = null; var v_watch_611 = null
	v_ctx_605 = J.arg(a, 0)
	v_a_606 = J.arg(a, 1)
	var _t620 = env["begin"]
	v_S_607 = J.cl(_t620, null, [v_ctx_605, v_a_606, "npc_boss__bodyN", false])
	if (not J.t(v_S_607)):
		return false
	v_t_608 = J.gp(v_S_607, "at")
	v_k_609 = J.gp(v_S_607, "env")
	var _t622 = sin(J.num(J.mul(v_t_608, 4.5)))
	var _t621 = env["bump"]
	v_sweep_610 = J.mul(_t622, J.cl(_t621, null, [v_t_608, 0.3, 0.6, 2.0]))
	var _t623 = env["kf"]
	v_watch_611 = J.cl(_t623, null, [[[0.0, 0.0], [2.1, 0.0], [2.5, 1.0], [3.5, 1.0]], v_t_608])
	var _t624 = env["bossDraw"]
	var _t625 = env["lerp"]
	J.cl(_t624, null, [v_S_607, {"glove": J.mul(v_k_609, J.cl(_t625, null, [((-0.45) + J.mul(v_sweep_610, 0.25)), 1.45, v_watch_611])), "shUp": (J.mul(v_k_609, v_watch_611) * 0.01), "ball": J.mul(v_k_609, 0.22), "elUp": J.mul(v_k_609, 0.01), "head": (J.mul(J.gp(v_S_607, "fs"), v_k_609) * (0.12 + J.mul(v_watch_611, 0.05))), "lean": ((J.mul(J.gp(v_S_607, "fs"), v_k_609) * 0.05) * J.sub(1.0, v_watch_611))}])
	var _t626 = env["end"]
	J.cl(_t626, null, [v_S_607])
	return true

func _f75(this_, a: Array, env):
	var v_ctx_614 = null; var v_a_615 = null; var v_S_616 = null; var v_t_617 = null; var v_k_618 = null; var v_q_619 = null; var v_br_620 = null; var v_nod_621 = null; var v_jerk_622 = null; var v_h_623 = null
	v_ctx_614 = J.arg(a, 0)
	v_a_615 = J.arg(a, 1)
	var _t629 = env["begin"]
	v_S_616 = J.cl(_t629, null, [v_ctx_614, v_a_615, "npc_guard__bodyN", false])
	if (not J.t(v_S_616)):
		return false
	v_t_617 = J.gp(v_S_616, "at")
	v_k_618 = J.gp(v_S_616, "env")
	var _t630 = env["loop"]
	v_q_619 = J.cl(_t630, null, [v_t_617, 8.0])
	v_br_620 = sin(J.num(J.mul(v_t_617, 1.5)))
	var _t631 = env["kf"]
	v_nod_621 = J.add(J.cl(_t631, null, [[[0.0, 0.25], [1.6, 0.85], [5.9, 1.0], [6.15, 1.12], [6.3, (-0.2)], [6.8, 0.1], [8.0, 0.25]], v_q_619]), J.mul(v_br_620, 0.04))
	var _t632 = env["bump"]
	v_jerk_622 = J.cl(_t632, null, [v_q_619, 6.15, 6.3, 6.8])
	J.mc(v_ctx_614, "save", [])
	J.mc(v_ctx_614, "scale", [1.0, ((1.0 - J.mul((0.025 * J.max_([0.0, v_nod_621])), v_k_618)) + J.mul(J.mul(0.006, v_br_620), v_k_618))])
	var _t633 = env["guardDraw"]
	J.cl(_t633, null, [v_S_616, {"head": (J.mul(J.mul(J.gp(v_S_616, "fs"), v_k_618), v_nod_621) * 0.45), "lean": (J.mul(J.mul(J.gp(v_S_616, "fs"), v_k_618), v_nod_621) * 0.05), "dy": J.mul(v_k_618, ((J.mul(J.max_([0.0, v_nod_621]), J.gp(v_S_616, "H")) * 0.012) - (J.mul(v_jerk_622, J.gp(v_S_616, "H")) * 0.02))), "fl": (((-J.num(v_k_618)) * J.max_([0.0, v_nod_621])) * 0.32)}])
	J.mc(v_ctx_614, "restore", [])
	v_h_623 = J.mc(v_S_616, "P", [0.3, 0.12])
	var _t634 = env["zzz"]
	var _t636 = J.sub(J.gp(v_h_623, 0.0), (J.mul(J.gp(v_S_616, "fs"), J.gp(v_S_616, "W")) * 0.15))
	var _t637 = J.gp(v_h_623, 1.0)
	var _t638 = J.mul(J.gp(v_S_616, "H"), 0.09)
	var _t635 = env["bump"]
	J.cl(_t634, null, [v_S_616, _t636, _t637, _t638, v_t_617, J.mul(J.sub(1.0, J.cl(_t635, null, [v_q_619, 6.0, 6.3, 7.2])), v_k_618)])
	var _t639 = env["marks"]
	J.cl(_t639, null, [v_ctx_614, J.gp(J.mc(v_S_616, "P", [0.5, 0.05]), 0.0), J.sub(J.gp(J.mc(v_S_616, "P", [0.5, 0.05]), 1.0), J.mul(J.gp(v_S_616, "H"), 0.03)), J.mul(J.gp(v_S_616, "H"), 0.09), J.mul(v_jerk_622, v_k_618)])
	var _t640 = env["end"]
	J.cl(_t640, null, [v_S_616])
	return true

func _f76(this_, a: Array, env):
	var v_ctx_626 = null; var v_a_627 = null; var v_S_628 = null; var v_t_629 = null; var v_k_630 = null; var v_br_631 = null; var v_h_632 = null
	v_ctx_626 = J.arg(a, 0)
	v_a_627 = J.arg(a, 1)
	var _t643 = env["begin"]
	v_S_628 = J.cl(_t643, null, [v_ctx_626, v_a_627, "npc_ken__bodyF", false, {"noLift": 1.0}])
	if (not J.t(v_S_628)):
		return false
	v_t_629 = J.gp(v_S_628, "at")
	v_k_630 = J.gp(v_S_628, "env")
	v_br_631 = sin(J.num(J.mul(v_t_629, 1.25)))
	J.mc(v_ctx_626, "save", [])
	J.mc(v_ctx_626, "scale", [1.0, (1.0 + J.mul(J.mul(0.012, v_br_631), v_k_630))])
	var _t644 = env["kenDraw"]
	J.cl(_t644, null, [v_S_628, {"lean": (J.mul(J.gp(v_S_628, "fs"), v_k_630) * (0.42 + J.mul(0.012, v_br_631))), "head": (J.mul(J.gp(v_S_628, "fs"), v_k_630) * (0.75 + J.mul(0.02, v_br_631))), "ang": ((-J.num(v_k_630)) * 0.55)}])
	J.mc(v_ctx_626, "restore", [])
	v_h_632 = J.mc(v_S_628, "P", [0.45, 0.4])
	var _t645 = env["zzz"]
	J.cl(_t645, null, [v_S_628, J.add(J.gp(v_h_632, 0.0), (J.mul(J.gp(v_S_628, "fs"), J.gp(v_S_628, "W")) * 0.55)), J.sub(J.gp(v_h_632, 1.0), J.mul(J.gp(v_S_628, "H"), 0.05)), J.mul(J.gp(v_S_628, "H"), 0.1), J.mul(v_t_629, 0.7), v_k_630])
	var _t646 = env["end"]
	J.cl(_t646, null, [v_S_628])
	return true

func _f78(this_, a: Array, env):
	var v_ctx_643 = null; var v_a_644 = null; var v_S_645 = null; var v_t_646 = null; var v_k_647 = null; var v_q_648 = null; var v_look_649 = null; var v_tap_650 = null
	v_ctx_643 = J.arg(a, 0)
	v_a_644 = J.arg(a, 1)
	var _t649 = env["begin"]
	v_S_645 = J.cl(_t649, null, [v_ctx_643, v_a_644, "npc_it", true])
	if (not J.t(v_S_645)):
		return false
	v_t_646 = J.gp(v_S_645, "at")
	v_k_647 = J.gp(v_S_645, "env")
	var _t650 = env["loop"]
	v_q_648 = J.cl(_t650, null, [v_t_646, 6.0])
	var _t651 = env["bump"]
	v_look_649 = J.cl(_t651, null, [v_q_648, 4.2, 4.6, 5.5])
	v_tap_650 = (sin(J.num(J.mul(v_t_646, 14.0))) * J.sub(1.0, v_look_649))
	var _t652 = env["meshBody"]
	J.cl(_t652, null, [v_S_645, "npc_it", "npc_it", {"head": (J.mul(J.gp(v_S_645, "fs"), v_k_647) * (0.26 - J.mul(v_look_649, 0.34))), "body": ((J.mul(J.gp(v_S_645, "fs"), v_k_647) * 0.04) * J.sub(1.0, v_look_649)), "armF": (J.mul(J.gp(v_S_645, "fs"), v_k_647) * (0.1 + J.mul(v_tap_650, 0.03))), "armB": (J.mul(J.gp(v_S_645, "fs"), v_k_647) * (0.08 + J.mul(v_tap_650, 0.02)))}])
	var _t653 = env["end"]
	J.cl(_t653, null, [v_S_645])
	return true

func _f79(this_, a: Array, env):
	var v_ctx_653 = null; var v_a_654 = null; var v_S_655 = null; var v_t_656 = null; var v_k_657 = null; var v_bend_658 = null; var v_sw_659 = null
	v_ctx_653 = J.arg(a, 0)
	v_a_654 = J.arg(a, 1)
	var _t656 = env["begin"]
	v_S_655 = J.cl(_t656, null, [v_ctx_653, v_a_654, "npc_it", true])
	if (not J.t(v_S_655)):
		return false
	v_t_656 = J.gp(v_S_655, "at")
	v_k_657 = J.gp(v_S_655, "env")
	var _t657 = env["bump"]
	v_bend_658 = J.cl(_t657, null, [v_t_656, 0.2, 0.7, 2.2])
	v_sw_659 = J.mul(sin(J.num(J.mul(v_t_656, 7.0))), v_bend_658)
	var _t658 = env["meshBody"]
	var _t661 = J.mul(J.gp(v_S_655, "fs"), v_k_657)
	var _t660 = J.mul(v_bend_658, 0.22)
	var _t659 = env["bump"]
	J.cl(_t658, null, [v_S_655, "npc_it", "npc_it", {"head": (_t661 * (_t660 - J.mul(J.cl(_t659, null, [v_t_656, 2.3, 2.8, 3.5]), 0.12))), "body": (J.mul(J.mul(J.gp(v_S_655, "fs"), v_k_657), v_bend_658) * 0.12), "armF": (J.mul((-J.num(J.gp(v_S_655, "fs"))), v_k_657) * (J.mul(0.25, v_bend_658) + J.mul(v_sw_659, 0.06))), "armB": (J.mul(J.gp(v_S_655, "fs"), v_k_657) * (J.mul(0.18, v_bend_658) + J.mul(v_sw_659, 0.05)))}])
	var _t662 = env["end"]
	J.cl(_t662, null, [v_S_655])
	return true

func _f80(this_, a: Array, env):
	var v_ctx_662 = null; var v_a_663 = null; var v_S_664 = null; var v_t_665 = null; var v_k_666 = null; var v_q_667 = null; var v_bend_668 = null; var v_rub_669 = null
	v_ctx_662 = J.arg(a, 0)
	v_a_663 = J.arg(a, 1)
	var _t665 = env["begin"]
	v_S_664 = J.cl(_t665, null, [v_ctx_662, v_a_663, "npc_auntie__bodyH", false])
	if (not J.t(v_S_664)):
		return false
	v_t_665 = J.gp(v_S_664, "at")
	v_k_666 = J.gp(v_S_664, "env")
	var _t666 = env["ss"]
	v_q_667 = J.cl(_t666, null, [v_k_666])
	var _t667 = env["bump"]
	var _t669 = J.cl(_t667, null, [v_t_665, 0.2, 0.7, 1.4])
	var _t668 = env["bump"]
	v_bend_668 = J.add(_t669, J.cl(_t668, null, [v_t_665, 1.3, 1.8, 2.5]))
	var _t670 = env["bump"]
	v_rub_669 = J.cl(_t670, null, [v_t_665, 2.5, 2.8, 3.5])
	var _t671 = env["auntieDraw"]
	var _t672 = env["auTh"]
	J.cl(_t671, null, [v_S_664, {"th": J.mul(J.cl(_t672, null, [v_S_664, (J.div(env["PI"], 2.0) + J.mul(J.gp(v_S_664, "fs"), 0.12))]), v_q_667), "fx": (J.mul(v_q_667, J.gp(v_S_664, "fs")) * 0.05), "fy": J.mul(v_q_667, 0.04), "floor": ((-J.num(J.gp(v_S_664, "H"))) * 0.06), "reach": v_q_667, "lean": (J.mul(J.gp(v_S_664, "fs"), v_k_666) * (J.mul(0.16, v_bend_668) - J.mul(0.05, v_rub_669))), "head": (J.mul(J.gp(v_S_664, "fs"), v_k_666) * (J.mul(0.22, v_bend_668) - J.mul(0.08, v_rub_669))), "hipA": ((J.mul(v_k_666, v_rub_669) * sin(J.num(J.mul(v_t_665, 16.0)))) * 0.12)}])
	var _t673 = env["end"]
	J.cl(_t673, null, [v_S_664])
	return true

func _f82(this_, a: Array, env):
	var v_L_682 = null; var v_h_683 = null; var v_w_684 = null; var v_sx_685 = null; var v_sy_686 = null
	v_L_682 = J.arg(a, 0)
	v_h_683 = J.cl(v_L_682, null, [0.16, 0.71])
	v_w_684 = J.mul(J.mul(J.gp(env["S"], "H"), 0.26), env["k"])
	v_sx_685 = (cos(J.num(J.mul(env["fold"], env["__p"]["PI"]))) * (1.0 if (J.mod(J.gp(env["S"], "at"), 4.8) < 2.4) else (-1.0)))
	v_sy_686 = (1.0 - J.mul(0.35, env["fold"]))
	var _t685 = env["__p"]["prop"]
	J.cl(_t685, null, [env["ctx"], "furnace__paper", J.gp(v_h_683, 0.0), J.sub(J.gp(v_h_683, 1.0), J.mul(J.gp(env["S"], "H"), 0.02)), v_w_684, J.mul(J.gp(env["S"], "fs"), 0.5), 0.5, 0.6, (0.08 if (absf(J.num(v_sx_685)) < 0.08) else v_sx_685), v_sy_686])

func _f81(this_, a: Array, env):
	var v_a_673 = null; var v_t_675 = null; var v_up_677 = null; var v_pat_679 = null; var v_pv_680 = null; var v_at_681 = null
	var _s111 = {"__p": env, "ctx": null, "S": null, "k": null, "fold": null}
	_s111["ctx"] = J.arg(a, 0)
	v_a_673 = J.arg(a, 1)
	var _t676 = _s111["__p"]["begin"]
	_s111["S"] = J.cl(_t676, null, [_s111["ctx"], v_a_673, "xiaozhi__body", false])
	if (not J.t(_s111["S"])):
		return false
	v_t_675 = J.mod(J.gp(_s111["S"], "at"), 2.4)
	_s111["k"] = J.gp(_s111["S"], "env")
	var _t678 = _s111["k"]
	var _t677 = _s111["__p"]["kf"]
	v_up_677 = J.mul(_t678, J.cl(_t677, null, [[[0.0, 0.6], [0.4, 1.0], [1.6, 1.0], [2.0, 0.75], [2.4, 0.6]], v_t_675]))
	var _t679 = _s111["__p"]["seg"]
	_s111["fold"] = J.cl(_t679, null, [v_t_675, 0.5, 0.9])
	var _t680 = _s111["__p"]["bump"]
	var _t682 = J.cl(_t680, null, [v_t_675, 1.2, 1.3, 1.45])
	var _t681 = _s111["__p"]["bump"]
	v_pat_679 = J.add(_t682, J.cl(_t681, null, [v_t_675, 1.5, 1.6, 1.75]))
	v_pv_680 = [0.315, 0.535]
	v_at_681 = J.mc(_s111["S"], "P", J.spread([J.SP(v_pv_680)]))
	var _t683 = _s111["__p"]["body"]
	J.cl(_t683, null, [_s111["S"], "xiaozhi", "xiaozhi__body", {"head": (J.mul(J.gp(_s111["S"], "fs"), _s111["k"]) * (0.08 + J.mul(0.03, v_pat_679)))}])
	var _t684 = _s111["__p"]["piece"]
	J.cl(_t684, null, [_s111["S"], "xiaozhi__arm", v_pv_680, [J.gp(v_at_681, 0.0), J.sub(J.gp(v_at_681, 1.0), (J.mul(v_pat_679, J.gp(_s111["S"], "H")) * 0.01))], (((-J.num(J.gp(_s111["S"], "fs"))) * (J.mul(v_up_677, 0.55) + J.mul(v_pat_679, 0.05))) * 1.0), 1.0, Callable(self, "_f82").bind(_s111)])
	var _t686 = _s111["__p"]["end"]
	J.cl(_t686, null, [_s111["S"]])
	return true

func _f83(this_, a: Array, env):
	var v_ctx_689 = null; var v_a_690 = null; var v_S_691 = null; var v_t_692 = null; var v_k_693 = null; var v_tap_694 = null; var v_nod_695 = null; var v_pv_696 = null; var v_at_697 = null; var v_st_698 = null
	v_ctx_689 = J.arg(a, 0)
	v_a_690 = J.arg(a, 1)
	var _t689 = env["begin"]
	v_S_691 = J.cl(_t689, null, [v_ctx_689, v_a_690, "xiaozhi__body", false])
	if (not J.t(v_S_691)):
		return false
	v_t_692 = J.mod(J.gp(v_S_691, "at"), 2.2)
	v_k_693 = J.gp(v_S_691, "env")
	var _t690 = env["bump"]
	var _t692 = J.cl(_t690, null, [v_t_692, 0.3, 0.42, 0.55])
	var _t691 = env["bump"]
	v_tap_694 = J.add(_t692, J.cl(_t691, null, [v_t_692, 0.7, 0.82, 0.95]))
	var _t693 = env["bump"]
	v_nod_695 = J.cl(_t693, null, [v_t_692, 1.3, 1.5, 1.8])
	v_pv_696 = [0.315, 0.535]
	v_at_697 = J.mc(v_S_691, "P", J.spread([J.SP(v_pv_696)]))
	var _t694 = env["body"]
	J.cl(_t694, null, [v_S_691, "xiaozhi", "xiaozhi__body", {"head": (J.mul(J.gp(v_S_691, "fs"), v_k_693) * (0.06 + J.mul(0.1, v_nod_695)))}])
	v_st_698 = J.mc(v_S_691, "P", [0.18, 0.75])
	var _t695 = env["prop"]
	J.cl(_t695, null, [v_ctx_689, "furnace__stack", J.gp(v_st_698, 0.0), J.sub(J.add(J.gp(v_st_698, 1.0), J.mul((J.mul(v_tap_694, J.gp(v_S_691, "H")) * 0.03), v_k_693)), J.mul(J.mul(J.gp(v_S_691, "H"), 0.04), v_k_693)), (J.mul(J.mul(J.gp(v_S_691, "H"), 0.36), v_k_693) + 0.001), 0.0, 0.5, 0.5])
	var _t696 = env["piece"]
	J.cl(_t696, null, [v_S_691, "xiaozhi__arm", v_pv_696, [J.gp(v_at_697, 0.0), J.add(J.gp(v_at_697, 1.0), J.mul((J.mul(v_tap_694, J.gp(v_S_691, "H")) * 0.03), v_k_693))], (J.mul((-J.num(J.gp(v_S_691, "fs"))), v_k_693) * 0.1)])
	var _t697 = env["end"]
	J.cl(_t697, null, [v_S_691])
	return true

func _f85(this_, a: Array, env):
	var v_L_709 = null; var v_p_710 = null
	v_L_709 = J.arg(a, 0)
	v_p_710 = J.cl(v_L_709, null, [0.93, 0.58])
	if (sin(J.num(env["an"])) > 0.6):
		var _t703 = env["__p"]["sparkle"]
		J.cl(_t703, null, [env["ctx"], J.add(J.gp(v_p_710, 0.0), J.mul(J.gp(env["S"], "H"), 0.05)), J.add(J.gp(v_p_710, 1.0), J.mul(J.gp(env["S"], "H"), 0.01)), J.mul(J.gp(env["S"], "H"), 0.035), J.mul(((sin(J.num(env["an"])) - 0.6) * 2.5), env["k"])])

func _f84(this_, a: Array, env):
	var v_a_702 = null; var v_t_704 = null; var v_pv_707 = null; var v_at_708 = null
	var _s114 = {"__p": env, "ctx": null, "S": null, "k": null, "an": null}
	_s114["ctx"] = J.arg(a, 0)
	v_a_702 = J.arg(a, 1)
	var _t700 = _s114["__p"]["begin"]
	_s114["S"] = J.cl(_t700, null, [_s114["ctx"], v_a_702, "xiaogui__body", true])
	if (not J.t(_s114["S"])):
		return false
	v_t_704 = J.gp(_s114["S"], "at")
	_s114["k"] = J.gp(_s114["S"], "env")
	_s114["an"] = J.mul(v_t_704, 7.0)
	v_pv_707 = [0.61, 0.585]
	v_at_708 = J.mc(_s114["S"], "P", J.spread([J.SP(v_pv_707)]))
	var _t701 = _s114["__p"]["body"]
	J.cl(_t701, null, [_s114["S"], "xiaogui", "xiaogui__body", {"head": (J.mul(J.gp(_s114["S"], "fs"), _s114["k"]) * (0.1 + (sin(J.num(_s114["an"])) * 0.02))), "tail1": J.mul((sin(J.num(_s114["an"])) * 0.05), _s114["k"])}])
	var _t702 = _s114["__p"]["piece"]
	J.cl(_t702, null, [_s114["S"], "xiaogui__arm", v_pv_707, [J.add(J.gp(v_at_708, 0.0), J.mul((J.mul(cos(J.num(_s114["an"])), J.gp(_s114["S"], "H")) * 0.03), _s114["k"])), J.add(J.gp(v_at_708, 1.0), J.mul(J.mul((0.04 + (sin(J.num(_s114["an"])) * 0.015)), J.gp(_s114["S"], "H")), _s114["k"]))], (J.mul(J.gp(_s114["S"], "fs"), _s114["k"]) * (0.25 + (sin(J.num(_s114["an"])) * 0.06))), 1.0, Callable(self, "_f85").bind(_s114)])
	var _t704 = _s114["__p"]["end"]
	J.cl(_t704, null, [_s114["S"]])
	return true

func _f87(this_, a: Array, env):
	var v_L_723 = null; var v_p_724 = null
	v_L_723 = J.arg(a, 0)
	v_p_724 = J.cl(v_L_723, null, [0.95, 0.55])
	var _t715 = env["__p"]["prop"]
	J.cl(_t715, null, [env["ctx"], "furnace__paper", J.add(J.gp(v_p_724, 0.0), (J.mul(J.gp(env["S"], "fs"), J.gp(env["S"], "W")) * 0.06)), J.sub(J.gp(v_p_724, 1.0), J.mul(J.gp(env["S"], "H"), 0.03)), (J.mul(J.mul(J.gp(env["S"], "H"), 0.22), env["up"]) + 0.001), J.mul(J.gp(env["S"], "fs"), (0.3 + J.mul(env["look"], 0.1))), 0.5, 0.7])

func _f86(this_, a: Array, env):
	var v_a_714 = null; var v_t_716 = null; var v_k_717 = null; var v_pv_720 = null; var v_at_721 = null; var v_h_722 = null
	var _s116 = {"__p": env, "ctx": null, "S": null, "up": null, "look": null}
	_s116["ctx"] = J.arg(a, 0)
	v_a_714 = J.arg(a, 1)
	var _t707 = _s116["__p"]["begin"]
	_s116["S"] = J.cl(_t707, null, [_s116["ctx"], v_a_714, "xiaogui__body", true])
	if (not J.t(_s116["S"])):
		return false
	v_t_716 = J.gp(_s116["S"], "at")
	v_k_717 = J.gp(_s116["S"], "env")
	var _t708 = _s116["__p"]["kf"]
	_s116["up"] = J.mul(v_k_717, J.cl(_t708, null, [[[0.0, 0.0], [0.5, 1.0], [2.6, 1.0], [3.0, 0.0]], v_t_716]))
	var _t710 = sin(J.num(J.mul(v_t_716, 2.2)))
	var _t709 = _s116["__p"]["seg"]
	var _t712 = J.mul(_t710, J.cl(_t709, null, [v_t_716, 0.8, 1.0]))
	var _t711 = _s116["__p"]["seg"]
	_s116["look"] = (_t712 * J.sub(1.0, J.cl(_t711, null, [v_t_716, 2.3, 2.6])))
	v_pv_720 = [0.61, 0.585]
	v_at_721 = J.mc(_s116["S"], "P", J.spread([J.SP(v_pv_720)]))
	var _t713 = _s116["__p"]["body"]
	J.cl(_t713, null, [_s116["S"], "xiaogui", "xiaogui__body", {"head": J.mul(J.gp(_s116["S"], "fs"), (J.mul(_s116["up"], 0.14) + J.mul(_s116["look"], 0.05)))}])
	var _t714 = _s116["__p"]["piece"]
	J.cl(_t714, null, [_s116["S"], "xiaogui__arm", v_pv_720, [J.add(J.gp(v_at_721, 0.0), (J.mul(J.mul(J.gp(_s116["S"], "fs"), _s116["up"]), J.gp(_s116["S"], "W")) * 0.06)), J.sub(J.gp(v_at_721, 1.0), (J.mul(_s116["up"], J.gp(_s116["S"], "H")) * 0.05))], (J.mul((-J.num(J.gp(_s116["S"], "fs"))), _s116["up"]) * 0.45), 1.0, Callable(self, "_f87").bind(_s116)])
	v_h_722 = J.mc(_s116["S"], "P", [0.6, 0.15])
	var _t716 = _s116["__p"]["text"]
	var _t718 = _s116["S"]
	var _t719 = J.add(J.gp(v_h_722, 0.0), (J.mul(J.gp(_s116["S"], "fs"), J.gp(_s116["S"], "W")) * 0.2))
	var _t720 = J.sub(J.gp(v_h_722, 1.0), J.mul(J.gp(_s116["S"], "H"), 0.08))
	var _t721 = J.mul(J.gp(_s116["S"], "H"), 0.11)
	var _t717 = _s116["__p"]["bump"]
	J.cl(_t716, null, [_t718, _t719, _t720, "嗯……", _t721, J.mul(J.cl(_t717, null, [v_t_716, 1.0, 1.3, 2.6]), v_k_717)])
	var _t722 = _s116["__p"]["end"]
	J.cl(_t722, null, [_s116["S"]])
	return true

func _f89(this_, a: Array, env):
	var v_L_738 = null; var v_h_739 = null; var v_i_740 = null; var v_top_741 = null; var v_an_742 = null
	v_L_738 = J.arg(a, 0)
	v_h_739 = J.cl(v_L_738, null, [0.27, 0.62])
	if J.cmp(env["lick"], 0.5, "<"):
		v_i_740 = 0.0
		while true:
			if not J.cmp(v_i_740, 5.0, "<"): break
			v_top_741 = J.seq(v_i_740, 4.0)
			var _t734 = (J.sub(v_i_740, 2.0) * 0.16)
			var _t733 = null
			if J.t(v_top_741):
				var _t732 = (-0.32)
				var _t731 = env["__p"]["ss"]
				_t733 = J.mul(_t732, J.cl(_t731, null, [env["fq"]]))
			else:
				_t733 = 0.0
			v_an_742 = (_t734 + _t733)
			var _t735 = env["__p"]["prop"]
			J.cl(_t735, null, [env["ctx"], "furnace__paper", J.gp(v_h_739, 0.0), J.gp(v_h_739, 1.0), ((J.mul(J.mul(J.gp(env["S"], "H"), 0.22), env["k"]) * J.sub(1.0, env["lick"])) + 0.001), J.add(J.mul(J.gp(env["S"], "fs"), 0.15), v_an_742), 0.5, 0.9])
			v_i_740 = J.num(v_i_740) + 1.0

func _f88(this_, a: Array, env):
	var v_a_728 = null; var v_t_730 = null; var v_pv_732 = null; var v_at_733 = null; var v_flipN_735 = null; var v_g_737 = null
	var _s118 = {"__p": env, "ctx": null, "S": null, "k": null, "lick": null, "fq": null}
	_s118["ctx"] = J.arg(a, 0)
	v_a_728 = J.arg(a, 1)
	var _t725 = _s118["__p"]["begin"]
	_s118["S"] = J.cl(_t725, null, [_s118["ctx"], v_a_728, "baiwu__body", false])
	if (not J.t(_s118["S"])):
		return false
	v_t_730 = J.gp(_s118["S"], "at")
	_s118["k"] = J.gp(_s118["S"], "env")
	v_pv_732 = [0.32, 0.655]
	v_at_733 = J.mc(_s118["S"], "P", J.spread([J.SP(v_pv_732)]))
	var _t726 = _s118["__p"]["bump"]
	_s118["lick"] = J.cl(_t726, null, [J.mod(v_t_730, 3.6), 2.4, 2.65, 3.0])
	v_flipN_735 = floor(J.num(J.mul(v_t_730, 2.6)))
	_s118["fq"] = J.mod(J.mul(v_t_730, 2.6), 1.0)
	var _t727 = _s118["__p"]["ok"]
	if J.t(J.cl(_t727, null, ["baiwu__wpn"])):
		v_g_737 = J.mc(_s118["S"], "P", [0.12, 1.0])
		var _t728 = _s118["__p"]["prop"]
		J.cl(_t728, null, [_s118["ctx"], "baiwu__wpn", J.add(J.gp(v_g_737, 0.0), (J.mul(J.gp(_s118["S"], "fs"), J.gp(_s118["S"], "W")) * 0.05)), J.gp(v_g_737, 1.0), J.mul(J.gp(_s118["S"], "H"), 0.42), J.mul(((-J.num(J.gp(_s118["S"], "fs"))) * 0.12), _s118["k"]), 0.5, 1.0])
	var _t729 = _s118["__p"]["body"]
	J.cl(_t729, null, [_s118["S"], "baiwu", "baiwu__body", {"head": (J.mul(J.gp(_s118["S"], "fs"), _s118["k"]) * ((0.1 - J.mul(_s118["lick"], 0.12)) + (0.02 * sin(J.num(J.mul(v_t_730, 5.2))))))}])
	var _t730 = _s118["__p"]["piece"]
	J.cl(_t730, null, [_s118["S"], "baiwu__arm", v_pv_732, [J.add(J.gp(v_at_733, 0.0), J.mul(J.mul(J.mul(J.gp(_s118["S"], "fs"), (0.03 + J.mul(_s118["lick"], 0.03))), J.gp(_s118["S"], "W")), _s118["k"])), J.sub(J.gp(v_at_733, 1.0), J.mul(J.mul((0.01 + J.mul(_s118["lick"], 0.13)), J.gp(_s118["S"], "H")), _s118["k"]))], (J.mul((-J.num(J.gp(_s118["S"], "fs"))), _s118["k"]) * ((0.12 + J.mul(_s118["lick"], 0.55)) + (0.04 * sin(J.num(J.mul(_s118["fq"], _s118["__p"]["PI"])))))), 1.0, Callable(self, "_f89").bind(_s118)])
	if J.cmp(_s118["k"], 0.5, ">"):
		var _t736 = _s118["__p"]["text"]
		J.cl(_t736, null, [_s118["S"], J.add(J.gp(J.mc(_s118["S"], "P", [0.5, 0.1]), 0.0), (J.mul(J.gp(_s118["S"], "fs"), J.gp(_s118["S"], "W")) * 0.4)), J.gp(J.mc(_s118["S"], "P", [0.5, 0.1]), 1.0), J.gp(["一", "二", "三", "四", "五", "六"], J.mod(v_flipN_735, 6.0)), J.mul(J.gp(_s118["S"], "H"), 0.07), (((J.sub(1.0, _s118["fq"]) * J.sub(1.0, _s118["lick"])) * J.sub(_s118["k"], 0.5)) * 2.0), {"col": "#ffe08a"}])
	var _t737 = _s118["__p"]["end"]
	J.cl(_t737, null, [_s118["S"]])
	return true

func _f90(this_, a: Array, env):
	var v_ctx_745 = null; var v_a_746 = null; var v_S_747 = null; var v_t_748 = null; var v_k_749 = null; var v_pv_750 = null; var v_at_751 = null; var v_lift_752 = null; var v_n_753 = null; var v_hit_754 = null; var v_hit2_755 = null; var v_g_756 = null
	v_ctx_745 = J.arg(a, 0)
	v_a_746 = J.arg(a, 1)
	var _t740 = env["begin"]
	v_S_747 = J.cl(_t740, null, [v_ctx_745, v_a_746, "baiwu__body", false])
	if (not J.t(v_S_747)):
		return false
	v_t_748 = J.gp(v_S_747, "at")
	v_k_749 = J.gp(v_S_747, "env")
	v_pv_750 = [0.32, 0.655]
	v_at_751 = J.mc(v_S_747, "P", J.spread([J.SP(v_pv_750)]))
	var _t741 = env["kf"]
	v_lift_752 = J.cl(_t741, null, [[[0.0, 0.0], [0.5, 1.0], [0.7, 1.1], [0.8, (-0.2)], [1.0, 0.0], [1.3, 0.8], [1.45, (-0.2)], [1.6, 0.0], [2.0, 0.0]], v_t_748])
	var _t742 = env["ok"]
	if J.t(J.cl(_t742, null, ["baiwu__wpn"])):
		v_g_756 = J.mc(v_S_747, "P", [0.12, 1.0])
		var _t743 = env["prop"]
		J.cl(_t743, null, [v_ctx_745, "baiwu__wpn", J.add(J.gp(v_g_756, 0.0), (J.mul(J.gp(v_S_747, "fs"), J.gp(v_S_747, "W")) * 0.05)), J.gp(v_g_756, 1.0), J.mul(J.gp(v_S_747, "H"), 0.42), J.mul(((-J.num(J.gp(v_S_747, "fs"))) * 0.12), v_k_749), 0.5, 1.0])
	var _t744 = env["body"]
	J.cl(_t744, null, [v_S_747, "baiwu", "baiwu__body", {"head": (J.mul(J.gp(v_S_747, "fs"), v_k_749) * (0.14 - J.mul(v_lift_752, 0.04)))}])
	v_n_753 = J.mc(v_S_747, "P", [0.18, 0.8])
	var _t745 = env["prop"]
	J.cl(_t745, null, [v_ctx_745, "furnace__paper", J.gp(v_n_753, 0.0), J.gp(v_n_753, 1.0), (J.mul(J.mul(J.gp(v_S_747, "H"), 0.24), v_k_749) + 0.001), 0.1, 0.5, 0.5])
	v_hit_754 = (1.0 if J.cmp(v_t_748, 0.8, ">") else 0.0)
	v_hit2_755 = (1.0 if J.cmp(v_t_748, 1.45, ">") else 0.0)
	if J.t(v_hit_754):
		J.mc(v_ctx_745, "save", [])
		var _t746 = J.mul(J.gp(v_ctx_745, "globalAlpha"), J.mul(v_k_749, 0.85))
		J.sp(v_ctx_745, "globalAlpha", _t746)
		J.mc(v_ctx_745, "translate", [J.gp(v_n_753, 0.0), J.gp(v_n_753, 1.0)])
		J.mc(v_ctx_745, "rotate", [(-0.2)])
		J.sp(v_ctx_745, "strokeStyle", "#c8202a")
		var _t747 = J.mul(J.gp(v_S_747, "H"), 0.008)
		J.sp(v_ctx_745, "lineWidth", _t747)
		J.mc(v_ctx_745, "strokeRect", [((-J.num(J.gp(v_S_747, "H"))) * 0.035), ((-J.num(J.gp(v_S_747, "H"))) * 0.035), J.mul(J.gp(v_S_747, "H"), 0.07), J.mul(J.gp(v_S_747, "H"), 0.07)])
		var _t748 = ("900 " + J.str(J.mul(J.gp(v_S_747, "H"), 0.05)) + "px " + J.str(env["FONT"]))
		J.sp(v_ctx_745, "font", _t748)
		J.sp(v_ctx_745, "fillStyle", "#c8202a")
		J.sp(v_ctx_745, "textAlign", "center")
		J.sp(v_ctx_745, "textBaseline", "middle")
		if J.t(J.gp(v_S_747, "flip")):
			J.mc(v_ctx_745, "scale", [(-1.0), 1.0])
		J.mc(v_ctx_745, "fillText", ["冥", 0.0, J.mul(J.gp(v_S_747, "H"), 0.002)])
		J.mc(v_ctx_745, "restore", [])
	var _t749 = env["piece"]
	J.cl(_t749, null, [v_S_747, "baiwu__arm", v_pv_750, [J.sub(J.gp(v_at_751, 0.0), J.mul((J.mul(J.gp(v_S_747, "fs"), J.gp(v_S_747, "W")) * 0.02), v_k_749)), (J.sub(J.gp(v_at_751, 1.0), J.mul((J.mul(v_lift_752, J.gp(v_S_747, "H")) * 0.06), v_k_749)) + J.mul(J.mul(J.gp(v_S_747, "H"), 0.03), v_k_749))], (J.mul((-J.num(J.gp(v_S_747, "fs"))), v_k_749) * (0.15 + J.mul(v_lift_752, 0.25)))])
	var _t750 = env["marks"]
	var _t754 = J.gp(v_n_753, 0.0)
	var _t755 = J.sub(J.gp(v_n_753, 1.0), J.mul(J.gp(v_S_747, "H"), 0.05))
	var _t756 = J.mul(J.gp(v_S_747, "H"), 0.06)
	var _t751 = env["bump"]
	var _t753 = J.cl(_t751, null, [v_t_748, 0.78, 0.82, 1.0])
	var _t752 = env["bump"]
	J.cl(_t750, null, [v_ctx_745, _t754, _t755, _t756, J.mul(J.add(_t753, J.cl(_t752, null, [v_t_748, 1.43, 1.47, 1.65])), v_k_749)])
	var _t757 = env["end"]
	J.cl(_t757, null, [v_S_747])
	return true

func _f95(this_, a: Array, env):
	var v_ctx_825 = null; var v_a_826 = null; var v_S_827 = null
	v_ctx_825 = J.arg(a, 0)
	v_a_826 = J.arg(a, 1)
	var _t760 = env["begin"]
	v_S_827 = J.cl(_t760, null, [v_ctx_825, v_a_826, "eguiking__body", false])
	if (not J.t(v_S_827)):
		return false
	var _t761 = env["eguiCook"]
	J.cl(_t761, null, [v_S_827, "stir"])
	var _t762 = env["end"]
	J.cl(_t762, null, [v_S_827])
	return true

func _f96(this_, a: Array, env):
	var v_ctx_830 = null; var v_a_831 = null; var v_S_832 = null
	v_ctx_830 = J.arg(a, 0)
	v_a_831 = J.arg(a, 1)
	var _t765 = env["begin"]
	v_S_832 = J.cl(_t765, null, [v_ctx_830, v_a_831, "eguiking__body", false])
	if (not J.t(v_S_832)):
		return false
	var _t766 = env["eguiCook"]
	J.cl(_t766, null, [v_S_832, "ladle"])
	var _t767 = env["end"]
	J.cl(_t767, null, [v_S_832])
	return true

func _f97(this_, a: Array, env):
	var v_ctx_835 = null; var v_a_836 = null; var v_S_837 = null
	v_ctx_835 = J.arg(a, 0)
	v_a_836 = J.arg(a, 1)
	var _t770 = env["begin"]
	v_S_837 = J.cl(_t770, null, [v_ctx_835, v_a_836, "eguiking__body", false])
	if (not J.t(v_S_837)):
		return false
	var _t771 = env["eguiCook"]
	J.cl(_t771, null, [v_S_837, "taste"])
	var _t772 = env["end"]
	J.cl(_t772, null, [v_S_837])
	return true

func _f99(this_, a: Array, env):
	var v_L_853 = null; var v_h_854 = null; var v_W_855 = null; var v_im_856 = null; var v_ww_857 = null; var v_wh_858 = null
	v_L_853 = J.arg(a, 0)
	v_h_854 = J.cl(v_L_853, null, [0.275, 0.625])
	v_W_855 = J.gp(J.gp(J.G.get("LIMBS_DATA"), "weapons"), J.gp(J.gp(J.gp(J.G.get("LIMBS_DATA"), "chars"), "baiwu"), "weapon"))
	var _t791 = v_W_855
	if J.t(_t791):
		var _t790 = env["__p"]["ok"]
		_t791 = J.cl(_t790, null, [J.gp(v_W_855, "img")])
	if J.t(_t791):
		v_im_856 = J.gp(J.G.get("SPR"), J.gp(v_W_855, "img"))
		v_ww_857 = J.mul(J.gp(v_W_855, "w"), J.gp(env["S"], "H"))
		v_wh_858 = J.mul(J.gp(v_W_855, "h"), J.gp(env["S"], "H"))
		J.mc(env["c"], "save", [])
		J.mc(env["c"], "translate", [J.gp(v_h_854, 0.0), J.gp(v_h_854, 1.0)])
		J.mc(env["c"], "drawImage", [v_im_856, J.mul((-J.num(J.gp(J.gp(v_W_855, "grip"), 0.0))), v_ww_857), J.mul((-J.num(J.gp(J.gp(v_W_855, "grip"), 1.0))), v_wh_858), v_ww_857, v_wh_858])
		J.mc(env["c"], "restore", [])

func _f98(this_, a: Array, env):
	var v_ctx_840 = null; var v_a_841 = null; var v_G_842 = null; var v_t_844 = null; var v_k_845 = null; var v_up_847 = null; var v_w_848 = null; var v_at_849 = null; var v_deep_850 = null; var v_b_851 = null; var v_at_852 = null
	var _s142 = {"__p": env, "S": null, "c": null}
	v_ctx_840 = J.arg(a, 0)
	v_a_841 = J.arg(a, 1)
	v_G_842 = J.gp(_s142["__p"]["GREET"], J.gp(v_a_841, "type"))
	if (not J.t(v_G_842)):
		return false
	var _t775 = _s142["__p"]["begin"]
	_s142["S"] = J.cl(_t775, null, [v_ctx_840, v_a_841, J.gp(v_G_842, "key"), J.gp(v_G_842, "nr")])
	if (not J.t(_s142["S"])):
		return false
	v_t_844 = J.gp(_s142["S"], "at")
	v_k_845 = J.gp(_s142["S"], "env")
	_s142["c"] = J.gp(_s142["S"], "ctx")
	if J.t(J.gp(v_G_842, "wave")):
		var _t776 = _s142["__p"]["kf"]
		v_up_847 = J.mul(v_k_845, J.cl(_t776, null, [[[0.0, 0.0], [0.35, 1.0], [1.4, 1.0], [1.7, 0.2]], v_t_844]))
		var _t778 = sin(J.num(J.mul(v_t_844, 11.0)))
		var _t777 = _s142["__p"]["seg"]
		var _t780 = J.mul(_t778, J.cl(_t777, null, [v_t_844, 0.3, 0.4]))
		var _t779 = _s142["__p"]["seg"]
		v_w_848 = (_t780 * J.sub(1.0, J.cl(_t779, null, [v_t_844, 1.3, 1.5])))
		var _t781 = _s142["__p"]["body"]
		J.cl(_t781, null, [_s142["S"], J.gp(v_a_841, "type"), J.gp(v_G_842, "key"), {"head": (J.mul(J.gp(_s142["S"], "fs"), v_k_845) * ((-0.06) + J.mul(0.03, v_w_848)))}])
		v_at_849 = J.mc(_s142["S"], "P", J.spread([J.SP(J.gp(v_G_842, "pv"))]))
		var _t782 = _s142["__p"]["piece"]
		J.cl(_t782, null, [_s142["S"], J.gp(v_G_842, "arm"), J.gp(v_G_842, "pv"), [J.gp(v_at_849, 0.0), J.sub(J.gp(v_at_849, 1.0), (J.mul(v_up_847, J.gp(_s142["S"], "H")) * 0.04))], (((J.mul(J.gp(_s142["S"], "fs"), v_up_847) * 0.4) if J.seq(J.gp(v_a_841, "type"), "eguiking") else (J.mul((-J.num(J.gp(_s142["S"], "fs"))), v_up_847) * 1.9)) + J.mul(J.mul(v_w_848, 0.22), v_up_847))])
	else:
		v_deep_850 = (0.38 if J.seq(J.gp(v_a_841, "type"), "baiwu") else 0.16)
		var _t783 = _s142["__p"]["kf"]
		v_b_851 = J.mul(v_k_845, J.cl(_t783, null, [[[0.0, 0.0], [0.4, 1.0], [0.9, 1.0], [1.4, 0.0]], v_t_844]))
		J.mc(_s142["c"], "save", [])
		var _t784 = _s142["__p"]["lean"]
		J.cl(_t784, null, [_s142["S"], J.mul(J.mul(J.gp(_s142["S"], "fs"), v_b_851), v_deep_850), 0.25])
		var _t785 = _s142["__p"]["body"]
		J.cl(_t785, null, [_s142["S"], J.gp(v_a_841, "type"), J.gp(v_G_842, "key"), {"head": (J.mul(J.gp(_s142["S"], "fs"), v_b_851) * 0.1)}])
		v_at_852 = J.mc(_s142["S"], "P", J.spread([J.SP(J.gp(v_G_842, "pv"))]))
		var _t786 = J.gp(v_G_842, "staff")
		var _t787 = ((not J.seq(J.typeof_(J.G.get("Limbs")), "undefined")) if J.t(_t786) else _t786)
		if J.t((J.mc(J.G.get("Limbs"), "has", ["baiwu"]) if J.t(_t787) else _t787)):
			J.mc(_s142["c"], "restore", [])
			J.mc(_s142["c"], "save", [])
			var _t788 = _s142["__p"]["lean"]
			J.cl(_t788, null, [_s142["S"], J.mul(J.mul(J.gp(_s142["S"], "fs"), v_b_851), v_deep_850), 0.25])
		var _t789 = _s142["__p"]["piece"]
		J.cl(_t789, null, [_s142["S"], J.gp(v_G_842, "arm"), J.gp(v_G_842, "pv"), v_at_852, 0.0, 1.0, (Callable(self, "_f99").bind(_s142) if J.t(J.gp(v_G_842, "staff")) else null)])
		J.mc(_s142["c"], "restore", [])
	var _t792 = _s142["__p"]["end"]
	J.cl(_t792, null, [_s142["S"]])
	return true

func _f103(this_, a: Array, env):
	var v_ctx_891 = null; var v_a_892 = null; var v_G_893 = null; var v_S_894 = null
	v_ctx_891 = J.arg(a, 0)
	v_a_892 = J.arg(a, 1)
	v_G_893 = J.gp(env["WALK"], J.gp(v_a_892, "type"))
	if (not J.t(v_G_893)):
		return false
	var _t795 = env["begin"]
	v_S_894 = J.cl(_t795, null, [v_ctx_891, v_a_892, J.gp(v_G_893, "key"), J.gp(v_G_893, "nr")])
	if (not J.t(v_S_894)):
		return false
	var _t796 = J.max_([J.gp(v_S_894, "env"), 0.999])
	J.sp(v_S_894, "env", _t796)
	var _t797 = env["walker"]
	J.cl(_t797, null, [v_S_894, v_G_893, {"head": 0.0}])
	var _t798 = env["end"]
	J.cl(_t798, null, [v_S_894])
	return true

func _f104(this_, a: Array, env):
	var v_ctx_897 = null; var v_a_898 = null; var v_G_899 = null; var v_S_900 = null; var v_t_901 = null; var v_rec_902 = null; var v_bow_903 = null; var v_tt_904 = null
	v_ctx_897 = J.arg(a, 0)
	v_a_898 = J.arg(a, 1)
	v_G_899 = J.gp(env["WALK"], J.gp(v_a_898, "type"))
	if (not J.t(v_G_899)):
		return false
	var _t801 = env["begin"]
	v_S_900 = J.cl(_t801, null, [v_ctx_897, v_a_898, J.gp(v_G_899, "key"), J.gp(v_G_899, "nr")])
	if (not J.t(v_S_900)):
		return false
	v_t_901 = J.gp(v_S_900, "at")
	var _t802 = env["kf"]
	v_rec_902 = J.cl(_t802, null, [[[0.0, 0.0], [0.12, 1.0], [0.45, 0.6], [0.6, 0.0]], v_t_901])
	var _t803 = env["bump"]
	var _t805 = J.cl(_t803, null, [v_t_901, 0.6, 0.8, 1.05])
	var _t804 = env["bump"]
	v_bow_903 = J.add(_t805, J.cl(_t804, null, [v_t_901, 1.05, 1.25, 1.5]))
	J.sp(v_S_900, "env", 1.0)
	var _t806 = env["walker"]
	J.cl(_t806, null, [v_S_900, v_G_899, {"lean": ((J.mul((-J.num(J.gp(v_S_900, "fs"))), v_rec_902) * 0.2) + (J.mul(J.gp(v_S_900, "fs"), v_bow_903) * 0.3)), "dx": (J.mul(J.mul((-J.num(J.gp(v_S_900, "fs"))), v_rec_902), J.gp(v_S_900, "H")) * 0.06), "head": (J.mul(J.gp(v_S_900, "fs"), v_bow_903) * 0.15)}])
	var _t807 = env["marks"]
	var _t809 = J.gp(J.mc(v_S_900, "P", [0.5, 0.02]), 0.0)
	var _t810 = J.sub(J.gp(J.mc(v_S_900, "P", [0.5, 0.02]), 1.0), J.mul(J.gp(v_S_900, "H"), 0.04))
	var _t811 = J.mul(J.gp(v_S_900, "H"), 0.12)
	var _t808 = env["bump"]
	J.cl(_t807, null, [v_ctx_897, _t809, _t810, _t811, J.cl(_t808, null, [v_t_901, 0.08, 0.15, 0.55])])
	var _t812 = J.gp(J.gp(v_a_898, "o"), "prop")
	var _t813 = (J.gp(J.gp(J.gp(v_a_898, "o"), "prop"), "sorry") if J.t(_t812) else _t812)
	v_tt_904 = (_t813 if J.t(_t813) else "不好意思")
	var _t814 = env["text"]
	var _t816 = J.gp(J.mc(v_S_900, "P", [0.5, 0.0]), 0.0)
	var _t817 = J.sub(J.gp(J.mc(v_S_900, "P", [0.5, 0.0]), 1.0), J.mul(J.gp(v_S_900, "H"), 0.2))
	var _t818 = J.mul(J.gp(v_S_900, "H"), 0.13)
	var _t815 = env["bump"]
	J.cl(_t814, null, [v_S_900, _t816, _t817, v_tt_904, _t818, J.cl(_t815, null, [v_t_901, 0.65, 0.8, 1.7]), {"col": "#fff6dc"}])
	var _t819 = env["end"]
	J.cl(_t819, null, [v_S_900])
	return true

func _f105(this_, a: Array, env):
	var v_ctx_907 = null; var v_a_908 = null; var v_G_909 = null; var v_S_910 = null; var v_t_911 = null; var v_k_912 = null; var v_scan_913 = null; var v_inq_914 = null
	v_ctx_907 = J.arg(a, 0)
	v_a_908 = J.arg(a, 1)
	v_G_909 = J.gp(env["WALK"], J.gp(v_a_908, "type"))
	if (not J.t(v_G_909)):
		return false
	var _t822 = env["begin"]
	v_S_910 = J.cl(_t822, null, [v_ctx_907, v_a_908, J.gp(v_G_909, "key"), J.gp(v_G_909, "nr")])
	if (not J.t(v_S_910)):
		return false
	v_t_911 = J.gp(v_S_910, "at")
	v_k_912 = J.gp(v_S_910, "env")
	v_scan_913 = sin(J.num(J.mul(v_t_911, 1.6)))
	var _t823 = env["bump"]
	v_inq_914 = J.cl(_t823, null, [v_t_911, 1.6, 1.9, 2.8])
	var _t824 = env["walker"]
	J.cl(_t824, null, [v_S_910, v_G_909, {"lean": (J.mul(J.gp(v_S_910, "fs"), v_k_912) * (0.06 + J.mul(v_inq_914, 0.05))), "head": ((J.mul(J.gp(v_S_910, "fs"), v_k_912) * (0.08 + J.mul(v_scan_913, 0.06))) - (J.mul(v_k_912, v_inq_914) * 0.08)), "arm": (J.mul((-J.num(J.gp(v_S_910, "fs"))), v_k_912) * (0.3 + (0.05 * sin(J.num(J.mul(v_t_911, 3.0))))))}])
	var _t825 = env["text"]
	J.cl(_t825, null, [v_S_910, J.add(J.gp(J.mc(v_S_910, "P", [0.5, 0.0]), 0.0), (J.mul(J.gp(v_S_910, "fs"), J.gp(v_S_910, "W")) * 0.2)), J.sub(J.gp(J.mc(v_S_910, "P", [0.5, 0.0]), 1.0), J.mul(J.gp(v_S_910, "H"), 0.08)), "哦？", J.mul(J.gp(v_S_910, "H"), 0.13), J.mul(v_inq_914, v_k_912)])
	var _t826 = env["end"]
	J.cl(_t826, null, [v_S_910])
	return true

func _f111(this_, a: Array, env):
	var v_st_937 = null
	v_st_937 = J.arg(a, 0)
	var _t828 = (J.gp(v_st_937, "act") if J.t(v_st_937) else v_st_937)
	var _t833 = null
	if J.t((J.cmp(J.gp(v_st_937, "w"), 0.0, ">") if J.t(_t828) else _t828)):
		var _t830 = J.gp(v_st_937, "act")
		var _t831 = J.gp(v_st_937, "at")
		var _t832 = J.gp(v_st_937, "dur")
		var _t829 = env["ss"]
		_t833 = {"act": _t830, "at": _t831, "adur": _t832, "aw": J.cl(_t829, null, [J.gp(v_st_937, "w")])}
	else:
		_t833 = {}
	return _t833

func _f113(this_, a: Array, env):
	var v_n_949 = null; var v_o_950 = null
	v_n_949 = J.arg(a, 0)
	var _t834 = env["opts"]
	v_o_950 = J.cl(_t834, null, [J.gp(v_n_949, "daily")])
	var _t835 = J.gp(v_o_950, "act")
	var _t836 = (J.gp(v_n_949, "bub") if J.t(_t835) else _t835)
	if J.t((J.cmp(J.gp(v_n_949, "bubT"), 0.0, ">") if J.t(_t836) else _t836)):
		J.sp(v_o_950, "quiet", true)
	return v_o_950

func _f114(this_, a: Array, env):
	var v_n_951 = null
	v_n_951 = J.arg(a, 0)
	var _t837 = J.gp(env["ACT"], J.gp(J.gp(v_n_951, "d"), "spr"))
	var _t838 = J.gp((_t837 if J.t(_t837) else {}), J.gp(v_n_951, "act"))
	return (_t838 if J.t(_t838) else null)

func _f1(this_, a: Array, env):
	var v_D_3 = null; var v_eo_8 = null; var v_eo3_9 = null; var v_beamSpot_39 = null; var v_npcTick_65 = null; var v_npcOpts_66 = null; var v_actAnim_67 = null
	var _s2 = {"__p": env, "PI": null, "cl": null, "lerp": null, "ss": null, "seg": null, "bump": null, "kf": null, "rnd": null, "ok": null, "FONT": null, "begin": null, "end": null, "mpose": null, "body": null, "lean": null, "piece": null, "prop": null, "rotP": null, "crayon": null, "text": null, "puff": null, "steamCurl": null, "drop": null, "sparkle": null, "zzz": null, "marks": null, "anger": null, "KEN": null, "kenDraw": null, "kenFace": null, "BOSS": null, "bossDraw": null, "GU": null, "guardDraw": null, "guardSip": null, "AU": null, "auAxis": null, "auHead": null, "auReach": null, "HEAD0": null, "auMop": null, "resid": null, "WR": null, "auntieDraw": null, "auTh": null, "loop": null, "meshBody": null, "eguiPot": null, "noodles": null, "strainer": null, "eguiCook": null, "GREET": null, "WALK": null, "hang": null, "walker": null, "LIST": null, "tick": null, "opts": null, "ACT": null}
	_s2["begin"] = Callable(self, "_f12").bind(_s2)
	_s2["mpose"] = Callable(self, "_f15").bind(_s2)
	_s2["body"] = Callable(self, "_f16").bind(_s2)
	_s2["lean"] = Callable(self, "_f17").bind(_s2)
	_s2["piece"] = Callable(self, "_f18").bind(_s2)
	_s2["prop"] = Callable(self, "_f20").bind(_s2)
	_s2["crayon"] = Callable(self, "_f22").bind(_s2)
	_s2["text"] = Callable(self, "_f25").bind(_s2)
	_s2["puff"] = Callable(self, "_f26").bind(_s2)
	_s2["steamCurl"] = Callable(self, "_f27").bind(_s2)
	_s2["drop"] = Callable(self, "_f28").bind(_s2)
	_s2["sparkle"] = Callable(self, "_f29").bind(_s2)
	_s2["zzz"] = Callable(self, "_f30").bind(_s2)
	_s2["marks"] = Callable(self, "_f31").bind(_s2)
	_s2["anger"] = Callable(self, "_f32").bind(_s2)
	_s2["kenDraw"] = Callable(self, "_f33").bind(_s2)
	_s2["bossDraw"] = Callable(self, "_f39").bind(_s2)
	_s2["guardDraw"] = Callable(self, "_f47").bind(_s2)
	v_beamSpot_39 = Callable(self, "_f48").bind(_s2)
	_s2["guardSip"] = Callable(self, "_f50").bind(_s2)
	_s2["auAxis"] = Callable(self, "_f54").bind(_s2)
	_s2["auHead"] = Callable(self, "_f55").bind(_s2)
	_s2["auReach"] = Callable(self, "_f56").bind(_s2)
	_s2["auMop"] = Callable(self, "_f57").bind(_s2)
	_s2["auntieDraw"] = Callable(self, "_f60").bind(_s2)
	_s2["meshBody"] = Callable(self, "_f77").bind(_s2)
	_s2["eguiPot"] = Callable(self, "_f91").bind(_s2)
	_s2["noodles"] = Callable(self, "_f92").bind(_s2)
	_s2["strainer"] = Callable(self, "_f93").bind(_s2)
	_s2["eguiCook"] = Callable(self, "_f94").bind(_s2)
	_s2["hang"] = Callable(self, "_f100").bind(_s2)
	_s2["walker"] = Callable(self, "_f101").bind(_s2)
	_s2["tick"] = Callable(self, "_f106").bind(_s2)
	v_npcTick_65 = Callable(self, "_f112").bind(_s2)
	_s2["PI"] = PI
	v_D_3 = J.div(_s2["PI"], 180.0)
	_s2["cl"] = Callable(self, "_f2").bind(_s2)
	_s2["lerp"] = Callable(self, "_f3").bind(_s2)
	_s2["ss"] = Callable(self, "_f4").bind(_s2)
	_s2["seg"] = Callable(self, "_f5").bind(_s2)
	v_eo_8 = Callable(self, "_f6").bind(_s2)
	v_eo3_9 = Callable(self, "_f7").bind(_s2)
	_s2["bump"] = Callable(self, "_f8").bind(_s2)
	_s2["kf"] = Callable(self, "_f9").bind(_s2)
	_s2["rnd"] = Callable(self, "_f10").bind(_s2)
	_s2["ok"] = Callable(self, "_f11").bind(_s2)
	_s2["FONT"] = "\"Noto Sans CJK TC\",\"Noto Sans TC\",\"PingFang TC\",\"Microsoft JhengHei\",sans-serif"
	_s2["end"] = Callable(self, "_f14").bind(_s2)
	_s2["rotP"] = Callable(self, "_f21").bind(_s2)
	_s2["KEN"] = {"ELB": [0.69, 0.565], "HAND": [0.33, 0.5], "MOUTH": [0.37, 0.355], "EYE": [0.43, 0.305], "PHONE": [0.16, 0.43]}
	_s2["kenFace"] = Callable(self, "_f34").bind(_s2)
	var _t378 = J.G.get("DAILY")
	var _t385 = Callable(self, "_f35").bind(_s2)
	J.sp(_t378, "town_ken_scroll", _t385)
	var _t386 = J.G.get("DAILY")
	var _t407 = Callable(self, "_f36").bind(_s2)
	J.sp(_t386, "town_ken_yawn", _t407)
	var _t408 = J.G.get("DAILY")
	var _t416 = Callable(self, "_f37").bind(_s2)
	J.sp(_t408, "town_ken_rub", _t416)
	var _t417 = J.G.get("DAILY")
	var _t433 = Callable(self, "_f38").bind(_s2)
	J.sp(_t417, "town_ken_sigh", _t433)
	_s2["BOSS"] = {"EL": [0.23, 0.56], "BALL": [0.12, 0.27], "SH": [0.775, 0.475], "HAND": [0.835, 0.75], "WATCH": [0.8, 0.63], "MOUTH": [0.39, 0.315]}
	var _t434 = J.G.get("DAILY")
	var _t478 = Callable(self, "_f41").bind(_s2)
	J.sp(_t434, "town_boss_polish", _t478)
	var _t479 = J.G.get("DAILY")
	var _t495 = Callable(self, "_f43").bind(_s2)
	J.sp(_t479, "town_boss_watch", _t495)
	var _t496 = J.G.get("DAILY")
	var _t507 = Callable(self, "_f44").bind(_s2)
	J.sp(_t496, "town_boss_call", _t507)
	var _t508 = J.G.get("DAILY")
	var _t512 = Callable(self, "_f46").bind(_s2)
	J.sp(_t508, "town_boss_admire", _t512)
	_s2["GU"] = {"FL": [0.33, 0.53], "FTIP": [0.06, 0.66], "SH": [0.882, 0.4565], "WR": [0.885, 0.578], "CAP": [0.745, 0.465], "MOUTH": [0.5, 0.335]}
	var _t513 = J.G.get("DAILY")
	var _t517 = Callable(self, "_f49").bind(_s2)
	J.sp(_t513, "town_guard_patrol", _t517)
	var _t518 = J.G.get("DAILY")
	var _t522 = Callable(self, "_f52").bind(_s2)
	J.sp(_t518, "town_guard_sip", _t522)
	var _t523 = J.G.get("DAILY")
	var _t537 = Callable(self, "_f53").bind(_s2)
	J.sp(_t523, "town_guard_doze", _t537)
	_s2["AU"] = {"FIST": [0.275, 0.512], "TOP": [0.235, 0.34], "BOT": [0.37, 0.95], "HEAD": [0.1, 0.4], "SH": [0.765, 0.43], "HAND": [0.735, 0.595]}
	_s2["HEAD0"] = atan2(J.num(J.sub(J.gp(J.gp(_s2["AU"], "TOP"), 1.0), J.gp(J.gp(_s2["AU"], "FIST"), 1.0))), J.num(J.sub(J.gp(J.gp(_s2["AU"], "TOP"), 0.0), J.gp(J.gp(_s2["AU"], "FIST"), 0.0))))
	_s2["resid"] = Callable(self, "_f59").bind(_s2)
	_s2["WR"] = [0.386, 0.526]
	_s2["auTh"] = Callable(self, "_f61").bind(_s2)
	var _t540 = J.G.get("DAILY")
	var _t550 = Callable(self, "_f62").bind(_s2)
	J.sp(_t540, "town_auntie_mop", _t550)
	var _t551 = J.G.get("DAILY")
	var _t567 = Callable(self, "_f64").bind(_s2)
	J.sp(_t551, "town_auntie_wring", _t567)
	var _t568 = J.G.get("DAILY")
	var _t593 = Callable(self, "_f67").bind(_s2)
	J.sp(_t568, "town_auntie_grumble", _t593)
	_s2["loop"] = Callable(self, "_f68").bind(_s2)
	var _t594 = J.G.get("DAILY")
	var _t602 = Callable(self, "_f69").bind(_s2)
	J.sp(_t594, "office_boss_present", _t602)
	var _t603 = J.G.get("DAILY")
	var _t610 = Callable(self, "_f70").bind(_s2)
	J.sp(_t603, "office_boss_read", _t610)
	var _t611 = J.G.get("DAILY")
	var _t618 = Callable(self, "_f72").bind(_s2)
	J.sp(_t611, "office_boss_phone", _t618)
	var _t619 = J.G.get("DAILY")
	var _t627 = Callable(self, "_f74").bind(_s2)
	J.sp(_t619, "office_boss_pack", _t627)
	var _t628 = J.G.get("DAILY")
	var _t641 = Callable(self, "_f75").bind(_s2)
	J.sp(_t628, "town_guard_dozeL", _t641)
	var _t642 = J.G.get("DAILY")
	var _t647 = Callable(self, "_f76").bind(_s2)
	J.sp(_t642, "office_ken_nap", _t647)
	var _t648 = J.G.get("DAILY")
	var _t654 = Callable(self, "_f78").bind(_s2)
	J.sp(_t648, "office_it_notes", _t654)
	var _t655 = J.G.get("DAILY")
	var _t663 = Callable(self, "_f79").bind(_s2)
	J.sp(_t655, "office_it_pack", _t663)
	var _t664 = J.G.get("DAILY")
	var _t674 = Callable(self, "_f80").bind(_s2)
	J.sp(_t664, "office_auntie_pack", _t674)
	var _t675 = J.G.get("DAILY")
	var _t687 = Callable(self, "_f81").bind(_s2)
	J.sp(_t675, "town_paper_fold", _t687)
	var _t688 = J.G.get("DAILY")
	var _t698 = Callable(self, "_f83").bind(_s2)
	J.sp(_t688, "town_paper_arrange", _t698)
	var _t699 = J.G.get("DAILY")
	var _t705 = Callable(self, "_f84").bind(_s2)
	J.sp(_t699, "town_haggle_polish", _t705)
	var _t706 = J.G.get("DAILY")
	var _t723 = Callable(self, "_f86").bind(_s2)
	J.sp(_t706, "town_haggle_squint", _t723)
	var _t724 = J.G.get("DAILY")
	var _t738 = Callable(self, "_f88").bind(_s2)
	J.sp(_t724, "town_exch_count", _t738)
	var _t739 = J.G.get("DAILY")
	var _t758 = Callable(self, "_f90").bind(_s2)
	J.sp(_t739, "town_exch_stamp", _t758)
	var _t759 = J.G.get("DAILY")
	var _t763 = Callable(self, "_f95").bind(_s2)
	J.sp(_t759, "town_food_stir", _t763)
	var _t764 = J.G.get("DAILY")
	var _t768 = Callable(self, "_f96").bind(_s2)
	J.sp(_t764, "town_food_ladle", _t768)
	var _t769 = J.G.get("DAILY")
	var _t773 = Callable(self, "_f97").bind(_s2)
	J.sp(_t769, "town_food_taste", _t773)
	_s2["GREET"] = {"xiaozhi": {"key": "xiaozhi__body", "arm": "xiaozhi__arm", "pv": [0.315, 0.535], "nr": false, "wave": 1.0}, "xiaogui": {"key": "xiaogui__body", "arm": "xiaogui__arm", "pv": [0.61, 0.585], "nr": true, "wave": 0.0}, "baiwu": {"key": "baiwu__body", "arm": "baiwu__arm", "pv": [0.32, 0.655], "nr": false, "wave": 0.0, "staff": 1.0}, "eguiking": {"key": "eguiking__body", "arm": "eguiking__arm", "pv": [0.12, 0.5], "nr": false, "wave": 1.0}}
	var _t774 = J.G.get("DAILY")
	var _t793 = Callable(self, "_f98").bind(_s2)
	J.sp(_t774, "town_greet", _t793)
	_s2["WALK"] = {"youhun": {"key": "youhun__body", "arm": "youhun__arm", "pv": [0.245, 0.47], "tip": [0.04, 0.55], "nr": false}, "egui": {"key": "egui__body", "arm": "egui__arm", "pv": [0.56, 0.44], "tip": [0.74, 0.27], "nr": true}, "zombie": {"key": "zombie__body", "arm": "zombie__arm", "pv": [0.27, 0.56], "tip": [0.06, 0.57], "nr": false}, "shuigui": {"key": "shuigui__body", "arm": "shuigui__arm", "pv": [0.72, 0.53], "tip": [0.92, 0.53], "nr": true}}
	var _t794 = J.G.get("DAILY")
	var _t799 = Callable(self, "_f103").bind(_s2)
	J.sp(_t794, "town_walk", _t799)
	var _t800 = J.G.get("DAILY")
	var _t820 = Callable(self, "_f104").bind(_s2)
	J.sp(_t800, "town_bump", _t820)
	var _t821 = J.G.get("DAILY")
	var _t827 = Callable(self, "_f105").bind(_s2)
	J.sp(_t821, "town_look", _t827)
	_s2["LIST"] = {"npc_ken": [["town_ken_scroll", 5.0, [4.0, 7.0], 0.0], ["town_ken_yawn", 1.3, [3.3, 3.3], 9.0], ["town_ken_rub", 1.1, [2.9, 2.9], 8.0], ["town_ken_sigh", 1.1, [3.1, 3.1], 8.0]], "npc_boss": [["town_boss_admire", 2.5, [2.5, 4.5], 0.0], ["town_boss_polish", 2.0, [3.7, 3.7], 6.0], ["town_boss_watch", 1.5, [2.9, 2.9], 8.0], ["town_boss_call", 1.2, [4.0, 4.0], 12.0]], "npc_guard": [["town_guard_patrol", 3.0, [3.0, 5.0], 0.0, "walk"], ["town_guard_sip", 1.5, [3.3, 3.3], 8.0], ["town_guard_doze", 1.0, [4.3, 4.3], 14.0]], "npc_auntie": [["town_auntie_mop", 2.0, [2.2, 3.5], 0.0, "walk"], ["town_auntie_wring", 1.5, [2.3, 2.3], 6.0], ["town_auntie_grumble", 1.4, [2.3, 2.3], 7.0]], "xiaozhi": [["town_paper_fold", 3.0, [4.8, 7.2], 0.0], ["town_paper_arrange", 2.0, [4.4, 6.6], 4.0]], "xiaogui": [["town_haggle_polish", 3.0, [3.0, 5.0], 0.0], ["town_haggle_squint", 2.0, [3.1, 3.1], 6.0]], "baiwu": [["town_exch_count", 3.0, [3.6, 7.2], 0.0], ["town_exch_stamp", 1.5, [2.1, 2.1], 5.0]], "eguiking": [["town_food_stir", 3.0, [3.0, 5.0], 0.0], ["town_food_ladle", 2.0, [3.0, 6.0], 3.0], ["town_food_taste", 1.3, [3.3, 3.3], 10.0]]}
	_s2["opts"] = Callable(self, "_f111").bind(_s2)
	_s2["ACT"] = {"npc_boss": {"present": "office_boss_present", "read": "office_boss_read", "call": "office_boss_phone", "pack": "office_boss_pack"}, "npc_guard": {"doze": "town_guard_dozeL"}, "npc_ken": {"brk_nap": "office_ken_nap"}, "npc_it": {"notes": "office_it_notes", "pack": "office_it_pack"}, "npc_auntie": {"pack": "office_auntie_pack"}}
	v_npcOpts_66 = Callable(self, "_f113").bind(_s2)
	v_actAnim_67 = Callable(self, "_f114").bind(_s2)
	return {"tick": _s2["tick"], "opts": _s2["opts"], "npcTick": v_npcTick_65, "npcOpts": v_npcOpts_66, "LIST": _s2["LIST"], "ACT": _s2["ACT"], "actAnim": v_actAnim_67}
