# 自動轉譯自 daily_town.js（tools/jsgd.js）——唔好直接改，改原 JS 再轉
extends RefCounted

func run(env):
	var this_ = null; var a = []
	J.G["TOWN"] = J.cl(Callable(self, "_f1").bind(env), null, [])

func _f13(this_, a: Array, env):
	var v_u_112 = null; var v_v_113 = null
	v_u_112 = J.arg(a, 0)
	v_v_113 = J.arg(a, 1)
	return [J.mul(J.sub(v_u_112, 0.5), env["W"]), J.mul(J.sub(v_v_113, 1.0), env["H"])]

func _f12(this_, a: Array, env):
	var v_ctx_96 = null; var v_a_97 = null; var v_key_98 = null; var v_nr_99 = null; var v_opt_100 = null; var v_img_101 = null; var v_o_102 = null; var v_t_103 = null; var v_at_106 = null; var v_dur_107 = null; var v_env_108 = null; var v_z_109 = null; var v_flip_110 = null; var v_fy_111 = null
	var _s15 = {"__p": env, "H": null, "W": null}
	v_ctx_96 = J.arg(a, 0)
	v_a_97 = J.arg(a, 1)
	v_key_98 = J.arg(a, 2)
	v_nr_99 = J.arg(a, 3)
	v_opt_100 = J.arg(a, 4)
	var _t1 = _s15["__p"]["ok"]
	var _t2 = (not J.t(J.cl(_t1, null, [v_key_98])))
	if (_t2 if _t2 else J.seq(J.typeof_(J.G.get("MeshAnim")), "undefined")):
		return null
	v_img_101 = J.gp(J.G.get("SPR"), v_key_98)
	v_o_102 = J.gp(v_a_97, "o")
	var _t3 = J.gp(v_o_102, "t")
	v_t_103 = (_t3 if J.t(_t3) else 0.0)
	_s15["H"] = J.gp(v_a_97, "H")
	_s15["W"] = J.div(J.mul(_s15["H"], J.gp(v_img_101, "naturalWidth")), J.gp(v_img_101, "naturalHeight"))
	var _t4 = J.gp(v_o_102, "at")
	v_at_106 = (_t4 if J.t(_t4) else 0.0)
	var _t5 = J.gp(v_o_102, "adur")
	v_dur_107 = (_t5 if J.t(_t5) else 0.0)
	var _t6 = _s15["__p"]["ss"]
	v_env_108 = J.cl(_t6, null, [J.div(v_at_106, 0.35)])
	if J.t(v_dur_107):
		var _t7 = _s15["__p"]["ss"]
		var _t8 = _s15["__p"]["ss"]
		var _t9 = J.min_([v_env_108, J.cl(_t8, null, [J.div(J.sub(v_dur_107, v_at_106), 0.35)])])
		v_env_108 = _t9
	if (not J.leq(J.gp(v_o_102, "aw"), null)):
		var _t10 = _s15["__p"]["cl"]
		var _t11 = J.mul(v_env_108, J.cl(_t10, null, [J.gp(v_o_102, "aw")]))
		v_env_108 = _t11
	var _t12 = (not J.seq(J.gp(v_o_102, "shadow"), false))
	if J.t((J.gp(v_a_97, "shadow") if _t12 else _t12)):
		J.mc(v_a_97, "shadow", [J.gp(v_a_97, "x")])
	var _t13 = J.gp(J.G.get("MeshAnim"), "ANIM")
	v_z_109 = J.mc(_t13, "idle", [v_t_103])
	v_flip_110 = (not J.seq(J.gp(v_a_97, "faceRight"), (not (not J.t(v_nr_99)))))
	J.mc(v_ctx_96, "save", [])
	var _t16 = null
	if J.t(J.gp(v_a_97, "solid")):
		_t16 = 0.0
	else:
		var _t15 = (-(3.0 + (sin(J.num(J.mul(v_t_103, 2.4))) * 2.0)))
		var _t14 = J.gp(v_a_97, "s")
		_t16 = J.mul(_t15, (_t14 if J.t(_t14) else J.div(J.gp(v_a_97, "H"), 60.0)))
	v_fy_111 = _t16
	J.mc(v_ctx_96, "translate", [J.gp(v_a_97, "x"), J.add(J.gp(v_a_97, "y"), v_fy_111)])
	if J.t(v_flip_110):
		J.mc(v_ctx_96, "scale", [(-1.0), 1.0])
	J.mc(v_ctx_96, "translate", [0.0, J.mul((0.0 if J.t((J.gp(v_opt_100, "noLift") if J.t(v_opt_100) else v_opt_100)) else J.gp(v_z_109, "y")), _s15["H"])])
	J.mc(v_ctx_96, "scale", [J.gp(v_z_109, "sx"), J.gp(v_z_109, "sy")])
	return {"ctx": v_ctx_96, "a": v_a_97, "o": v_o_102, "t": v_t_103, "at": v_at_106, "dur": v_dur_107, "env": v_env_108, "H": _s15["H"], "W": _s15["W"], "z": v_z_109, "flip": v_flip_110, "fs": (1.0 if J.t(v_nr_99) else (-1.0)), "P": Callable(self, "_f13").bind(_s15), "walk": (not (not J.t(J.gp(v_o_102, "walk"))))}

func _f15(this_, a: Array, env):
	var v_S_117 = null; var v_add_118 = null; var v_z_119 = null; var v_k_120 = null
	v_S_117 = J.arg(a, 0)
	v_add_118 = J.arg(a, 1)
	var _t19 = {}
	var _t18 = null
	if J.t(J.gp(v_S_117, "walk")):
		var _t17 = J.gp(J.G.get("MeshAnim"), "ANIM")
		_t18 = J.mc(_t17, "walk", [J.gp(v_S_117, "t")])
	else:
		_t18 = J.gp(v_S_117, "z")
	v_z_119 = J.S_Object_("assign", [_t19, _t18])
	J.sp(v_z_119, "armF", 0.0)
	J.sp(v_z_119, "armB", 0.0)
	J.sp(v_z_119, "axe", 0.0)
	J.sp(v_z_119, "body", 0.0)
	J.sp(v_z_119, "x", 0.0)
	J.sp(v_z_119, "y", 0.0)
	J.sp(v_z_119, "sx", 1.0)
	J.sp(v_z_119, "sy", 1.0)
	J.sp(v_z_119, "rot", 0.0)
	if (not J.t(J.gp(v_S_117, "walk"))):
		J.sp(v_z_119, "legF", 0.0)
		J.sp(v_z_119, "legB", 0.0)
	if J.t(v_add_118):
		for _t20 in J.keys(v_add_118):
			v_k_120 = _t20
			var _t21 = J.gp(v_z_119, v_k_120)
			var _t22 = J.add((_t21 if J.t(_t21) else 0.0), J.gp(v_add_118, v_k_120))
			J.sp(v_z_119, v_k_120, _t22)
	return v_z_119

func _f16(this_, a: Array, env):
	var v_S_123 = null; var v_rig_124 = null; var v_key_125 = null; var v_add_126 = null
	v_S_123 = J.arg(a, 0)
	v_rig_124 = J.arg(a, 1)
	v_key_125 = J.arg(a, 2)
	v_add_126 = J.arg(a, 3)
	var _t24 = J.gp(v_S_123, "ctx")
	var _t25 = J.gp(v_S_123, "H")
	var _t23 = env["mpose"]
	J.mc(J.G.get("MeshAnim"), "drawBody", [_t24, v_rig_124, v_key_125, _t25, J.cl(_t23, null, [v_S_123, v_add_126])])

func _f17(this_, a: Array, env):
	var v_S_129 = null; var v_ang_130 = null; var v_ly_131 = null; var v_dx_132 = null; var v_dy_133 = null; var v_c_134 = null
	v_S_129 = J.arg(a, 0)
	v_ang_130 = J.arg(a, 1)
	v_ly_131 = J.arg(a, 2)
	v_dx_132 = J.arg(a, 3)
	v_dy_133 = J.arg(a, 4)
	v_c_134 = J.gp(v_S_129, "ctx")
	J.mc(v_c_134, "translate", [(v_dx_132 if J.t(v_dx_132) else 0.0), (v_dy_133 if J.t(v_dy_133) else 0.0)])
	J.mc(v_c_134, "translate", [0.0, J.mul((-J.num(J.gp(v_S_129, "H"))), (v_ly_131 if J.t(v_ly_131) else 0.35))])
	J.mc(v_c_134, "rotate", [v_ang_130])
	J.mc(v_c_134, "translate", [0.0, J.mul(J.gp(v_S_129, "H"), (v_ly_131 if J.t(v_ly_131) else 0.35))])

func _f19(this_, a: Array, env):
	var v_u_145 = null; var v_v_146 = null
	v_u_145 = J.arg(a, 0)
	v_v_146 = J.arg(a, 1)
	return [J.mul(J.sub(v_u_145, J.gp(env["pv"], 0.0)), J.gp(env["S"], "W")), J.mul(J.sub(v_v_146, J.gp(env["pv"], 1.0)), J.gp(env["S"], "H"))]

func _f18(this_, a: Array, env):
	var v_key_138 = null; var v_at_140 = null; var v_ang_141 = null; var v_sc_142 = null; var v_fn_143 = null; var v_c_144 = null
	var _s23 = {"__p": env, "S": null, "pv": null}
	_s23["S"] = J.arg(a, 0)
	v_key_138 = J.arg(a, 1)
	_s23["pv"] = J.arg(a, 2)
	v_at_140 = J.arg(a, 3)
	v_ang_141 = J.arg(a, 4)
	v_sc_142 = J.arg(a, 5)
	v_fn_143 = J.arg(a, 6)
	var _t26 = _s23["__p"]["ok"]
	if (not J.t(J.cl(_t26, null, [v_key_138]))):
		return null
	v_c_144 = J.gp(_s23["S"], "ctx")
	J.mc(v_c_144, "save", [])
	J.mc(v_c_144, "translate", [J.gp(v_at_140, 0.0), J.gp(v_at_140, 1.0)])
	J.mc(v_c_144, "rotate", [(v_ang_141 if J.t(v_ang_141) else 0.0)])
	if J.t(v_sc_142):
		J.mc(v_c_144, "scale", [v_sc_142, v_sc_142])
	J.mc(v_c_144, "drawImage", [J.gp(J.G.get("SPR"), v_key_138), J.mul((-J.num(J.gp(_s23["pv"], 0.0))), J.gp(_s23["S"], "W")), J.mul((-J.num(J.gp(_s23["pv"], 1.0))), J.gp(_s23["S"], "H")), J.gp(_s23["S"], "W"), J.gp(_s23["S"], "H")])
	if J.t(v_fn_143):
		J.cl(v_fn_143, null, [Callable(self, "_f19").bind(_s23)])
	J.mc(v_c_144, "restore", [])

func _f20(this_, a: Array, env):
	var v_ctx_149 = null; var v_key_150 = null; var v_x_151 = null; var v_y_152 = null; var v_w_153 = null; var v_ang_154 = null; var v_ax_155 = null; var v_ay_156 = null; var v_sx_157 = null; var v_sy_158 = null; var v_im_159 = null; var v_h_160 = null
	v_ctx_149 = J.arg(a, 0)
	v_key_150 = J.arg(a, 1)
	v_x_151 = J.arg(a, 2)
	v_y_152 = J.arg(a, 3)
	v_w_153 = J.arg(a, 4)
	v_ang_154 = J.arg(a, 5)
	v_ax_155 = J.arg(a, 6)
	v_ay_156 = J.arg(a, 7)
	v_sx_157 = J.arg(a, 8)
	v_sy_158 = J.arg(a, 9)
	var _t27 = env["ok"]
	if (not J.t(J.cl(_t27, null, [v_key_150]))):
		return null
	v_im_159 = J.gp(J.G.get("SPR"), v_key_150)
	v_h_160 = J.div(J.mul(v_w_153, J.gp(v_im_159, "naturalHeight")), J.gp(v_im_159, "naturalWidth"))
	J.mc(v_ctx_149, "save", [])
	J.mc(v_ctx_149, "translate", [v_x_151, v_y_152])
	J.mc(v_ctx_149, "rotate", [(v_ang_154 if J.t(v_ang_154) else 0.0)])
	J.mc(v_ctx_149, "scale", [(v_sx_157 if J.t(v_sx_157) else 1.0), (v_sy_158 if J.t(v_sy_158) else 1.0)])
	J.mc(v_ctx_149, "drawImage", [v_im_159, J.mul((-J.num((0.5 if J.leq(v_ax_155, null) else v_ax_155))), v_w_153), J.mul((-J.num((0.5 if J.leq(v_ay_156, null) else v_ay_156))), v_h_160), v_w_153, v_h_160])
	J.mc(v_ctx_149, "restore", [])

func _f24(this_, a: Array, env):
	var v_p_180 = null; var v_i_181 = null
	v_p_180 = J.arg(a, 0)
	v_i_181 = J.arg(a, 1)
	return (J.mc(env["ctx"], "lineTo", [J.gp(v_p_180, 0.0), J.gp(v_p_180, 1.0)]) if J.t(v_i_181) else J.mc(env["ctx"], "moveTo", [J.gp(v_p_180, 0.0), J.gp(v_p_180, 1.0)]))

func _f23(this_, a: Array, env):
	J.mc(env["ctx"], "beginPath", [])
	J.mc(env["pts"], "forEach", [Callable(self, "_f24").bind(env)])

func _f22(this_, a: Array, env):
	var v_w_176 = null; var v_col_177 = null; var v_out_178 = null; var v_path_179 = null
	var _s27 = {"__p": env, "ctx": null, "pts": null}
	_s27["ctx"] = J.arg(a, 0)
	_s27["pts"] = J.arg(a, 1)
	v_w_176 = J.arg(a, 2)
	v_col_177 = J.arg(a, 3)
	v_out_178 = J.arg(a, 4)
	v_path_179 = Callable(self, "_f23").bind(_s27)
	var _t28 = _s27["ctx"]
	J.sp(_t28, "lineCap", "round")
	var _t29 = _s27["ctx"]
	J.sp(_t29, "lineJoin", "round")
	if J.t(v_out_178):
		var _t30 = _s27["ctx"]
		J.sp(_t30, "strokeStyle", v_out_178)
		var _t31 = _s27["ctx"]
		var _t32 = J.mul(v_w_176, 2.0)
		J.sp(_t31, "lineWidth", _t32)
		J.cl(v_path_179, null, [])
		J.mc(_s27["ctx"], "stroke", [])
	var _t33 = _s27["ctx"]
	J.sp(_t33, "strokeStyle", v_col_177)
	var _t34 = _s27["ctx"]
	J.sp(_t34, "lineWidth", v_w_176)
	J.cl(v_path_179, null, [])
	J.mc(_s27["ctx"], "stroke", [])

func _f25(this_, a: Array, env):
	var v_S_184 = null; var v_x_185 = null; var v_y_186 = null; var v_txt_187 = null; var v_size_188 = null; var v_alpha_189 = null; var v_opt_190 = null; var v_c_191 = null
	v_S_184 = J.arg(a, 0)
	v_x_185 = J.arg(a, 1)
	v_y_186 = J.arg(a, 2)
	v_txt_187 = J.arg(a, 3)
	v_size_188 = J.arg(a, 4)
	v_alpha_189 = J.arg(a, 5)
	v_opt_190 = J.arg(a, 6)
	var _t35 = (v_opt_190 if J.t(v_opt_190) else {})
	v_opt_190 = _t35
	var _t37 = J.cmp(v_alpha_189, 0.01, "<=")
	if not J.t(_t37):
		var _t36 = J.gp(J.gp(v_S_184, "o"), "quiet")
		_t37 = ((not J.t(J.gp(v_opt_190, "fx"))) if J.t(_t36) else _t36)
	if J.t(_t37):
		return null
	v_c_191 = J.gp(v_S_184, "ctx")
	J.mc(v_c_191, "save", [])
	J.mc(v_c_191, "translate", [v_x_185, v_y_186])
	if J.t(J.gp(v_S_184, "flip")):
		J.mc(v_c_191, "scale", [(-1.0), 1.0])
	var _t38 = J.gp(v_opt_190, "rot")
	J.mc(v_c_191, "rotate", [(_t38 if J.t(_t38) else 0.0)])
	var _t39 = env["cl"]
	var _t40 = J.mul(J.gp(v_c_191, "globalAlpha"), J.cl(_t39, null, [v_alpha_189]))
	J.sp(v_c_191, "globalAlpha", _t40)
	var _t41 = ("900 " + J.str(v_size_188) + "px " + J.str(env["FONT"]))
	J.sp(v_c_191, "font", _t41)
	J.sp(v_c_191, "textAlign", "center")
	J.sp(v_c_191, "textBaseline", "middle")
	J.sp(v_c_191, "lineJoin", "round")
	var _t42 = J.gp(v_opt_190, "out")
	var _t43 = (_t42 if J.t(_t42) else "#2a1a22")
	J.sp(v_c_191, "strokeStyle", _t43)
	var _t44 = J.mul(v_size_188, 0.26)
	J.sp(v_c_191, "lineWidth", _t44)
	J.mc(v_c_191, "strokeText", [v_txt_187, 0.0, 0.0])
	var _t45 = J.gp(v_opt_190, "col")
	var _t46 = (_t45 if J.t(_t45) else "#fff3e8")
	J.sp(v_c_191, "fillStyle", _t46)
	J.mc(v_c_191, "fillText", [v_txt_187, 0.0, 0.0])
	J.mc(v_c_191, "restore", [])

func _f26(this_, a: Array, env):
	var v_ctx_194 = null; var v_x_195 = null; var v_y_196 = null; var v_r_197 = null; var v_k_198 = null; var v_seed_199 = null; var v_col_200 = null; var v_i_201 = null; var v_a_202 = null; var v_rr_203 = null; var v_px_204 = null; var v_py_205 = null
	v_ctx_194 = J.arg(a, 0)
	v_x_195 = J.arg(a, 1)
	v_y_196 = J.arg(a, 2)
	v_r_197 = J.arg(a, 3)
	v_k_198 = J.arg(a, 4)
	v_seed_199 = J.arg(a, 5)
	v_col_200 = J.arg(a, 6)
	var _t47 = J.cmp(v_k_198, 0.0, "<=")
	if (_t47 if _t47 else J.cmp(v_k_198, 1.0, ">=")):
		return null
	J.mc(v_ctx_194, "save", [])
	var _t48 = J.mul(J.gp(v_ctx_194, "globalAlpha"), (sin(J.num(J.mul(v_k_198, env["PI"]))) * 0.85))
	J.sp(v_ctx_194, "globalAlpha", _t48)
	v_i_201 = 0.0
	while true:
		if not J.cmp(v_i_201, 3.0, "<"): break
		var _t49 = env["rnd"]
		v_a_202 = J.mul(J.cl(_t49, null, [J.add(v_seed_199, v_i_201)]), 6.28)
		var _t50 = env["rnd"]
		v_rr_203 = (J.mul(v_r_197, (0.45 + J.mul(0.4, J.cl(_t50, null, [J.add(v_seed_199, J.mul(v_i_201, 3.0))])))) * (0.6 + J.mul(v_k_198, 0.6)))
		v_px_204 = J.add(J.add(v_x_195, J.mul((J.mul(cos(J.num(v_a_202)), v_r_197) * 0.5), v_k_198)), J.mul((J.mul(v_i_201, v_r_197) * 0.35), v_k_198))
		v_py_205 = J.sub(J.add(v_y_196, (J.mul(sin(J.num(v_a_202)), v_r_197) * 0.3)), (J.mul(v_k_198, v_r_197) * 0.4))
		var _t51 = (v_col_200 if J.t(v_col_200) else "rgba(245,245,250,.85)")
		J.sp(v_ctx_194, "fillStyle", _t51)
		J.sp(v_ctx_194, "strokeStyle", "rgba(60,60,80,.35)")
		var _t52 = J.max_([1.0, J.mul(v_r_197, 0.08)])
		J.sp(v_ctx_194, "lineWidth", _t52)
		J.mc(v_ctx_194, "beginPath", [])
		J.mc(v_ctx_194, "arc", [v_px_204, v_py_205, v_rr_203, 0.0, J.mul(env["PI"], 2.0)])
		J.mc(v_ctx_194, "fill", [])
		J.mc(v_ctx_194, "stroke", [])
		v_i_201 = J.num(v_i_201) + 1.0
	J.mc(v_ctx_194, "restore", [])

func _f27(this_, a: Array, env):
	var v_ctx_208 = null; var v_x_209 = null; var v_y_210 = null; var v_h_211 = null; var v_k_212 = null; var v_seed_213 = null; var v_a_214 = null; var v_pts_215 = null; var v_i_216 = null; var v_u_217 = null
	v_ctx_208 = J.arg(a, 0)
	v_x_209 = J.arg(a, 1)
	v_y_210 = J.arg(a, 2)
	v_h_211 = J.arg(a, 3)
	v_k_212 = J.arg(a, 4)
	v_seed_213 = J.arg(a, 5)
	v_a_214 = J.arg(a, 6)
	var _t53 = J.cmp(v_k_212, 0.0, "<=")
	if (_t53 if _t53 else J.cmp(v_k_212, 1.0, ">=")):
		return null
	J.mc(v_ctx_208, "save", [])
	var _t54 = J.mul(J.gp(v_ctx_208, "globalAlpha"), J.mul(sin(J.num(J.mul(v_k_212, env["PI"]))), (v_a_214 if J.t(v_a_214) else 0.75)))
	J.sp(v_ctx_208, "globalAlpha", _t54)
	v_pts_215 = []
	v_i_216 = 0.0
	while true:
		if not J.cmp(v_i_216, 10.0, "<="): break
		v_u_217 = J.div(v_i_216, 10.0)
		J.mc(v_pts_215, "push", [[J.add(v_x_209, (J.mul(sin(J.num(J.add(J.add(J.mul(v_u_217, 5.0), v_seed_213), J.mul(v_k_212, 5.0)))), v_h_211) * 0.12)), (J.sub(v_y_210, (J.mul(v_u_217, v_h_211) * (0.4 + J.mul(v_k_212, 0.6)))) - (J.mul(v_k_212, v_h_211) * 0.3))]])
		v_i_216 = J.num(v_i_216) + 1.0
	var _t55 = env["crayon"]
	J.cl(_t55, null, [v_ctx_208, v_pts_215, J.max_([1.4, J.mul(v_h_211, 0.06)]), "rgba(250,246,240,.9)", "rgba(60,50,60,.25)"])
	J.mc(v_ctx_208, "restore", [])

func _f28(this_, a: Array, env):
	var v_ctx_220 = null; var v_x_221 = null; var v_y_222 = null; var v_r_223 = null; var v_k_224 = null; var v_fall_225 = null; var v_py_226 = null
	v_ctx_220 = J.arg(a, 0)
	v_x_221 = J.arg(a, 1)
	v_y_222 = J.arg(a, 2)
	v_r_223 = J.arg(a, 3)
	v_k_224 = J.arg(a, 4)
	v_fall_225 = J.arg(a, 5)
	var _t56 = J.cmp(v_k_224, 0.0, "<=")
	if (_t56 if _t56 else J.cmp(v_k_224, 1.0, ">=")):
		return null
	v_py_226 = J.add(v_y_222, J.mul(J.mul(v_fall_225, v_k_224), v_k_224))
	J.mc(v_ctx_220, "save", [])
	var _t57 = J.mul(J.gp(v_ctx_220, "globalAlpha"), (1.0 - J.mul(v_k_224, 0.5)))
	J.sp(v_ctx_220, "globalAlpha", _t57)
	J.sp(v_ctx_220, "fillStyle", "rgba(30,60,72,.9)")
	J.mc(v_ctx_220, "beginPath", [])
	J.mc(v_ctx_220, "ellipse", [v_x_221, v_py_226, J.mul(v_r_223, 1.2), J.mul(v_r_223, 1.7), 0.0, 0.0, J.mul(env["PI"], 2.0)])
	J.mc(v_ctx_220, "fill", [])
	J.sp(v_ctx_220, "fillStyle", "rgba(165,215,232,.95)")
	J.mc(v_ctx_220, "beginPath", [])
	J.mc(v_ctx_220, "ellipse", [v_x_221, v_py_226, J.mul(v_r_223, 0.85), J.mul(v_r_223, 1.3), 0.0, 0.0, J.mul(env["PI"], 2.0)])
	J.mc(v_ctx_220, "fill", [])
	J.mc(v_ctx_220, "restore", [])

func _f29(this_, a: Array, env):
	var v_ctx_229 = null; var v_x_230 = null; var v_y_231 = null; var v_r_232 = null; var v_k_233 = null; var v_i_234 = null; var v_an_235 = null; var v_rr_236 = null
	v_ctx_229 = J.arg(a, 0)
	v_x_230 = J.arg(a, 1)
	v_y_231 = J.arg(a, 2)
	v_r_232 = J.arg(a, 3)
	v_k_233 = J.arg(a, 4)
	if J.cmp(v_k_233, 0.0, "<="):
		return null
	J.mc(v_ctx_229, "save", [])
	J.mc(v_ctx_229, "translate", [v_x_230, v_y_231])
	J.mc(v_ctx_229, "scale", [v_k_233, v_k_233])
	var _t58 = J.mul(J.gp(v_ctx_229, "globalAlpha"), J.min_([1.0, J.mul(v_k_233, 1.5)]))
	J.sp(v_ctx_229, "globalAlpha", _t58)
	J.mc(v_ctx_229, "beginPath", [])
	v_i_234 = 0.0
	while true:
		if not J.cmp(v_i_234, 8.0, "<"): break
		v_an_235 = (J.mul(J.div(v_i_234, 8.0), env["PI"]) * 2.0)
		v_rr_236 = (J.mul(v_r_232, 0.22) if J.t(J.mod(v_i_234, 2.0)) else v_r_232)
		J.mc(v_ctx_229, "lineTo", [J.mul(cos(J.num(v_an_235)), v_rr_236), J.mul(sin(J.num(v_an_235)), v_rr_236)])
		v_i_234 = J.num(v_i_234) + 1.0
	J.mc(v_ctx_229, "closePath", [])
	J.sp(v_ctx_229, "fillStyle", "#fffbe8")
	J.sp(v_ctx_229, "strokeStyle", "rgba(90,70,20,.6)")
	var _t59 = J.max_([1.0, J.mul(v_r_232, 0.12)])
	J.sp(v_ctx_229, "lineWidth", _t59)
	J.mc(v_ctx_229, "stroke", [])
	J.mc(v_ctx_229, "fill", [])
	J.mc(v_ctx_229, "restore", [])

func _f30(this_, a: Array, env):
	var v_S_239 = null; var v_x_240 = null; var v_y_241 = null; var v_size_242 = null; var v_t_243 = null; var v_a_244 = null; var v_i_245 = null; var v_q_246 = null
	v_S_239 = J.arg(a, 0)
	v_x_240 = J.arg(a, 1)
	v_y_241 = J.arg(a, 2)
	v_size_242 = J.arg(a, 3)
	v_t_243 = J.arg(a, 4)
	v_a_244 = J.arg(a, 5)
	v_i_245 = 0.0
	while true:
		if not J.cmp(v_i_245, 3.0, "<"): break
		v_q_246 = J.mod((J.mul(v_t_243, 0.45) + J.div(v_i_245, 3.0)), 1.0)
		var _t60 = env["text"]
		J.cl(_t60, null, [v_S_239, J.add(J.add(v_x_240, (J.mul(v_q_246, v_size_242) * 1.2)), (J.mul(sin(J.num(J.add(J.mul(v_q_246, 6.0), v_i_245))), v_size_242) * 0.2)), J.sub(v_y_241, (J.mul(v_q_246, v_size_242) * 2.2)), ("Z" if J.seq(v_i_245, 1.0) else "z"), J.mul(v_size_242, (0.6 + J.mul(v_q_246, 0.6))), J.mul(v_a_244, sin(J.num(J.mul(v_q_246, env["PI"])))), {"col": "#dfe8ff", "out": "#2a2a48", "fx": 1.0}])
		v_i_245 = J.num(v_i_245) + 1.0

func _f31(this_, a: Array, env):
	var v_ctx_249 = null; var v_x_250 = null; var v_y_251 = null; var v_r_252 = null; var v_k_253 = null; var v_col_254 = null; var v_i_255 = null; var v_an_256 = null
	v_ctx_249 = J.arg(a, 0)
	v_x_250 = J.arg(a, 1)
	v_y_251 = J.arg(a, 2)
	v_r_252 = J.arg(a, 3)
	v_k_253 = J.arg(a, 4)
	v_col_254 = J.arg(a, 5)
	if J.cmp(v_k_253, 0.0, "<="):
		return null
	J.mc(v_ctx_249, "save", [])
	var _t61 = J.mul(J.gp(v_ctx_249, "globalAlpha"), v_k_253)
	J.sp(v_ctx_249, "globalAlpha", _t61)
	v_i_255 = (-1.0)
	while true:
		if not J.cmp(v_i_255, 1.0, "<="): break
		v_an_256 = (J.div((-J.num(env["PI"])), 2.0) + J.mul(v_i_255, 0.55))
		var _t62 = env["crayon"]
		J.cl(_t62, null, [v_ctx_249, [[J.add(v_x_250, (J.mul(cos(J.num(v_an_256)), v_r_252) * 0.55)), J.add(v_y_251, (J.mul(sin(J.num(v_an_256)), v_r_252) * 0.55))], [J.add(v_x_250, J.mul(cos(J.num(v_an_256)), v_r_252)), J.add(v_y_251, J.mul(sin(J.num(v_an_256)), v_r_252))]], J.max_([1.5, J.mul(v_r_252, 0.12)]), (v_col_254 if J.t(v_col_254) else "#fff2c0"), "rgba(40,20,20,.6)"])
		v_i_255 = J.num(v_i_255) + 1.0
	J.mc(v_ctx_249, "restore", [])

func _f32(this_, a: Array, env):
	var v_ctx_259 = null; var v_x_260 = null; var v_y_261 = null; var v_r_262 = null; var v_k_263 = null; var v_i_264 = null
	v_ctx_259 = J.arg(a, 0)
	v_x_260 = J.arg(a, 1)
	v_y_261 = J.arg(a, 2)
	v_r_262 = J.arg(a, 3)
	v_k_263 = J.arg(a, 4)
	if J.cmp(v_k_263, 0.0, "<="):
		return null
	J.mc(v_ctx_259, "save", [])
	var _t63 = J.mul(J.gp(v_ctx_259, "globalAlpha"), v_k_263)
	J.sp(v_ctx_259, "globalAlpha", _t63)
	J.mc(v_ctx_259, "translate", [v_x_260, v_y_261])
	J.mc(v_ctx_259, "scale", [(0.7 + J.mul(0.3, v_k_263)), (0.7 + J.mul(0.3, v_k_263))])
	v_i_264 = 0.0
	while true:
		if not J.cmp(v_i_264, 4.0, "<"): break
		J.mc(v_ctx_259, "save", [])
		J.mc(v_ctx_259, "rotate", [(J.div(J.mul(v_i_264, env["PI"]), 2.0) + J.div(env["PI"], 4.0))])
		var _t64 = env["crayon"]
		J.cl(_t64, null, [v_ctx_259, [[J.mul(v_r_262, 0.2), ((-J.num(v_r_262)) * 0.35)], [J.mul(v_r_262, 0.55), ((-J.num(v_r_262)) * 0.1)], [J.mul(v_r_262, 0.55), J.mul(v_r_262, 0.3)]], J.max_([1.5, J.mul(v_r_262, 0.2)]), "#e8333a", "rgba(60,0,0,.5)"])
		J.mc(v_ctx_259, "restore", [])
		v_i_264 = J.num(v_i_264) + 1.0
	J.mc(v_ctx_259, "restore", [])

func _f33(this_, a: Array, env):
	var v_S_267 = null; var v_P_268 = null; var v_c_269 = null; var v_e_270 = null
	v_S_267 = J.arg(a, 0)
	v_P_268 = J.arg(a, 1)
	v_c_269 = J.gp(v_S_267, "ctx")
	J.mc(v_c_269, "save", [])
	var _t65 = env["lean"]
	var _t66 = J.gp(v_P_268, "lean")
	J.cl(_t65, null, [v_S_267, (_t66 if J.t(_t66) else 0.0), 0.35])
	var _t67 = env["body"]
	var _t68 = J.gp(v_P_268, "head")
	var _t70 = (_t68 if J.t(_t68) else 0.0)
	var _t69 = J.gp(v_P_268, "legF")
	var _t72 = (_t69 if J.t(_t69) else 0.0)
	var _t71 = J.gp(v_P_268, "legB")
	J.cl(_t67, null, [v_S_267, "npc_ken", "npc_ken__bodyF", {"head": _t70, "legF": _t72, "legB": (_t71 if J.t(_t71) else 0.0)}])
	v_e_270 = J.mc(v_S_267, "P", J.spread([J.SP(J.gp(env["KEN"], "ELB"))]))
	var _t73 = env["piece"]
	var _t79 = J.gp(env["KEN"], "ELB")
	var _t75 = J.gp(v_e_270, 0.0)
	var _t74 = J.gp(v_P_268, "fx")
	var _t78 = J.add(_t75, J.mul((_t74 if J.t(_t74) else 0.0), J.gp(v_S_267, "H")))
	var _t77 = J.gp(v_e_270, 1.0)
	var _t76 = J.gp(v_P_268, "lift")
	var _t81 = [_t78, J.sub(_t77, J.mul((_t76 if J.t(_t76) else 0.0), J.gp(v_S_267, "H")))]
	var _t80 = J.gp(v_P_268, "ang")
	var _t83 = (_t80 if J.t(_t80) else 0.0)
	var _t82 = J.gp(v_P_268, "sc")
	J.cl(_t73, null, [v_S_267, "npc_ken__fore", _t79, _t81, _t83, (_t82 if J.t(_t82) else 1.0)])
	J.mc(v_c_269, "restore", [])

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
	var v_after_324 = null; var v_c_325 = null; var v_el_327 = null; var v_gl_328 = null
	var _s59 = {"__p": env, "S": null, "P": null, "sh": null}
	_s59["S"] = J.arg(a, 0)
	_s59["P"] = J.arg(a, 1)
	v_after_324 = J.arg(a, 2)
	v_c_325 = J.gp(_s59["S"], "ctx")
	J.mc(v_c_325, "save", [])
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
	v_el_327 = J.mc(_s59["S"], "P", J.spread([J.SP(J.gp(_s59["__p"]["BOSS"], "EL"))]))
	v_gl_328 = Callable(self, "_f40").bind(_s59)
	if J.t(J.gp(_s59["P"], "gloveBack")):
		J.cl(v_gl_328, null, [])
	var _t104 = _s59["__p"]["piece"]
	var _t108 = _s59["S"]
	var _t109 = J.gp(_s59["__p"]["BOSS"], "EL")
	var _t107 = J.gp(v_el_327, 0.0)
	var _t106 = J.gp(v_el_327, 1.0)
	var _t105 = J.gp(_s59["P"], "elUp")
	var _t111 = [_t107, J.sub(_t106, J.mul((_t105 if J.t(_t105) else 0.0), J.gp(_s59["S"], "H")))]
	var _t110 = J.gp(_s59["P"], "ball")
	J.cl(_t104, null, [_t108, "npc_boss__arm", _t109, _t111, (_t110 if J.t(_t110) else 0.0), 1.0, J.gp(_s59["P"], "bfn")])
	if (not J.t(J.gp(_s59["P"], "gloveBack"))):
		J.cl(v_gl_328, null, [])
	if J.t(v_after_324):
		J.cl(v_after_324, null, [])
	J.mc(v_c_325, "restore", [])

func _f47(this_, a: Array, env):
	var v_S_381 = null; var v_P_382 = null; var v_after_383 = null; var v_c_384 = null; var v_sh_385 = null; var v_fl_386 = null; var v_wr_387 = null
	v_S_381 = J.arg(a, 0)
	v_P_382 = J.arg(a, 1)
	v_after_383 = J.arg(a, 2)
	v_c_384 = J.gp(v_S_381, "ctx")
	J.mc(v_c_384, "save", [])
	var _t112 = env["lean"]
	var _t113 = J.gp(v_P_382, "lean")
	var _t115 = (_t113 if J.t(_t113) else 0.0)
	var _t114 = J.gp(v_P_382, "dy")
	J.cl(_t112, null, [v_S_381, _t115, 0.4, 0.0, (_t114 if J.t(_t114) else 0.0)])
	var _t116 = env["body"]
	var _t117 = J.gp(v_P_382, "head")
	J.cl(_t116, null, [v_S_381, "npc_guard", "npc_guard__bodyN", {"head": (_t117 if J.t(_t117) else 0.0)}])
	v_sh_385 = J.mc(v_S_381, "P", J.spread([J.SP(J.gp(env["GU"], "SH"))]))
	v_fl_386 = J.mc(v_S_381, "P", J.spread([J.SP(J.gp(env["GU"], "FL"))]))
	var _t118 = env["rotP"]
	var _t120 = J.gp(J.gp(env["GU"], "SH"), 0.0)
	var _t121 = J.gp(J.gp(env["GU"], "SH"), 1.0)
	var _t119 = J.gp(v_P_382, "arm")
	v_wr_387 = J.cl(_t118, null, [v_S_381, _t120, _t121, v_sh_385, (_t119 if J.t(_t119) else 0.0), J.gp(J.gp(env["GU"], "WR"), 0.0), J.gp(J.gp(env["GU"], "WR"), 1.0)])
	var _t122 = env["piece"]
	var _t126 = J.gp(env["GU"], "WR")
	var _t123 = J.gp(v_P_382, "arm")
	var _t125 = (_t123 if J.t(_t123) else 0.0)
	var _t124 = J.gp(v_P_382, "wrist")
	J.cl(_t122, null, [v_S_381, "npc_guard__tea", _t126, v_wr_387, J.add(_t125, (_t124 if J.t(_t124) else 0.0)), 1.0, J.gp(v_P_382, "tfn")])
	var _t127 = env["piece"]
	var _t129 = J.gp(env["GU"], "SH")
	var _t128 = J.gp(v_P_382, "arm")
	J.cl(_t127, null, [v_S_381, "npc_guard__sleeve", _t129, v_sh_385, (_t128 if J.t(_t128) else 0.0)])
	var _t130 = env["piece"]
	var _t132 = J.gp(env["GU"], "FL")
	var _t131 = J.gp(v_P_382, "fl")
	J.cl(_t130, null, [v_S_381, "npc_guard__arm", _t132, v_fl_386, (_t131 if J.t(_t131) else 0.0), 1.0, J.gp(v_P_382, "ffn")])
	if J.t(v_after_383):
		J.cl(v_after_383, null, [])
	J.mc(v_c_384, "restore", [])

func _f48(this_, a: Array, env):
	var v_S_390 = null; var v_L_391 = null; var v_p_392 = null; var v_ctx_393 = null; var v_g_394 = null; var v_dx_395 = null; var v_sx_396 = null; var v_sy_397 = null; var v_gx_398 = null; var v_gy_399 = null; var v_gr_400 = null
	v_S_390 = J.arg(a, 0)
	v_L_391 = J.arg(a, 1)
	v_p_392 = J.cl(v_L_391, null, J.spread([J.SP(J.gp(env["GU"], "FTIP"))]))
	v_ctx_393 = J.gp(v_S_390, "ctx")
	v_g_394 = J.mc(v_ctx_393, "createRadialGradient", [0.0, 0.0, 0.0, 0.0, 0.0, 1.0])
	v_dx_395 = ((-J.num(J.gp(v_S_390, "H"))) * 1.0)
	v_sx_396 = J.add(J.add(J.gp(v_p_392, 0.0), J.mul(v_dx_395, 1.0)), J.mul(J.add(J.gp(v_p_392, 1.0), 0.0), 0.0))
	v_sy_397 = 0.0
	J.mc(v_ctx_393, "save", [])
	J.sp(v_ctx_393, "globalCompositeOperation", "lighter")
	var _t133 = J.mul(J.gp(v_ctx_393, "globalAlpha"), J.mul(0.5, J.gp(v_S_390, "env")))
	J.sp(v_ctx_393, "globalAlpha", _t133)
	v_gx_398 = J.sub(J.gp(v_p_392, 0.0), J.mul(J.gp(v_S_390, "H"), 0.95))
	v_gy_399 = ((-J.num(J.gp(v_S_390, "H"))) * 0.01)
	v_gr_400 = J.mc(v_ctx_393, "createRadialGradient", [v_gx_398, v_gy_399, 0.0, v_gx_398, v_gy_399, J.mul(J.gp(v_S_390, "H"), 0.25)])
	J.mc(v_gr_400, "addColorStop", [0.0, "rgba(255,240,170,.5)"])
	J.mc(v_gr_400, "addColorStop", [1.0, "rgba(255,240,170,0)"])
	J.sp(v_ctx_393, "fillStyle", v_gr_400)
	J.mc(v_ctx_393, "translate", [v_gx_398, v_gy_399])
	J.mc(v_ctx_393, "scale", [1.0, 0.28])
	J.mc(v_ctx_393, "translate", [(-J.num(v_gx_398)), (-J.num(v_gy_399))])
	J.mc(v_ctx_393, "beginPath", [])
	J.mc(v_ctx_393, "arc", [v_gx_398, v_gy_399, J.mul(J.gp(v_S_390, "H"), 0.25), 0.0, J.mul(env["PI"], 2.0)])
	J.mc(v_ctx_393, "fill", [])
	J.mc(v_ctx_393, "restore", [])

func _f51(this_, a: Array, env):
	var v_L_429 = null; var v_p_430 = null
	v_L_429 = J.arg(a, 0)
	v_p_430 = J.cl(v_L_429, null, J.spread([J.SP(J.gp(env["__p"]["GU"], "CAP"))]))
	var _t146 = env["__p"]["steamCurl"]
	J.cl(_t146, null, [J.gp(env["S"], "ctx"), J.gp(v_p_430, 0.0), J.sub(J.gp(v_p_430, 1.0), J.mul(J.gp(env["S"], "H"), 0.02)), J.mul(J.gp(env["S"], "H"), 0.18), J.mod(J.mul(env["t"], 0.9), 1.0), 2.1, J.mul(0.6, env["k"])])

func _f50(this_, a: Array, env):
	var v_up_414 = null; var v_drink_415 = null; var v_sh_416 = null; var v_m_417 = null; var v_tgt_418 = null; var v_ikK_419 = null; var v_best_420 = null; var v_be_421 = null; var v_A_422 = null; var v_f_423 = null; var v_a1_424 = null; var v_a2_425 = null; var v_w_426 = null; var v_c_427 = null; var v_e_428 = null
	var _s72 = {"__p": env, "S": null, "t": null, "k": null}
	_s72["S"] = J.arg(a, 0)
	_s72["t"] = J.gp(_s72["S"], "at")
	_s72["k"] = J.gp(_s72["S"], "env")
	var _t134 = _s72["__p"]["kf"]
	v_up_414 = J.cl(_t134, null, [[[0.0, 0.0], [0.7, 1.0], [2.3, 1.0], [2.9, 0.0]], (J.min_([_s72["t"], 3.3]) if J.t(J.gp(_s72["S"], "dur")) else _s72["t"])])
	var _t135 = _s72["__p"]["bump"]
	v_drink_415 = J.cl(_t135, null, [_s72["t"], 0.9, 1.2, 2.2])
	v_sh_416 = J.mc(_s72["S"], "P", J.spread([J.SP(J.gp(_s72["__p"]["GU"], "SH"))]))
	v_m_417 = J.mc(_s72["S"], "P", J.spread([J.SP(J.gp(_s72["__p"]["GU"], "MOUTH"))]))
	v_tgt_418 = [J.add(J.gp(v_m_417, 0.0), (J.mul(J.gp(_s72["S"], "fs"), J.gp(_s72["S"], "W")) * 0.02)), J.add(J.gp(v_m_417, 1.0), J.mul(J.gp(_s72["S"], "H"), 0.03))]
	var _t137 = J.add(J.gp(_s72["S"], "fs"), "|")
	var _t136 = J.div(J.gp(_s72["S"], "W"), J.gp(_s72["S"], "H"))
	v_ikK_419 = J.add(_t137, J.mc(_t136, "toFixed", [5.0]))
	v_best_420 = (J.mc(J.gp(_s72["__p"]["IKC"], v_ikK_419), "slice", []) if J.t(J.gp(_s72["__p"]["IKC"], v_ikK_419)) else [0.0, 0.0])
	v_be_421 = ((-1.0) if J.t(J.gp(_s72["__p"]["IKC"], v_ikK_419)) else 1000000000.0)
	if J.cmp(v_be_421, 0.0, ">"):
		v_a1_424 = 0.0
		while true:
			if not J.cmp(v_a1_424, 2.2, "<="): break
			v_a2_425 = (-2.4)
			while true:
				if not J.cmp(v_a2_425, 0.4, "<="): break
				var _t138 = _s72["__p"]["rotP"]
				v_w_426 = J.cl(_t138, null, [_s72["S"], J.gp(J.gp(_s72["__p"]["GU"], "SH"), 0.0), J.gp(J.gp(_s72["__p"]["GU"], "SH"), 1.0), v_sh_416, v_a1_424, J.gp(J.gp(_s72["__p"]["GU"], "WR"), 0.0), J.gp(J.gp(_s72["__p"]["GU"], "WR"), 1.0)])
				var _t139 = _s72["__p"]["rotP"]
				v_c_427 = J.cl(_t139, null, [_s72["S"], J.gp(J.gp(_s72["__p"]["GU"], "WR"), 0.0), J.gp(J.gp(_s72["__p"]["GU"], "WR"), 1.0), v_w_426, J.add(v_a1_424, v_a2_425), J.gp(J.gp(_s72["__p"]["GU"], "CAP"), 0.0), J.gp(J.gp(_s72["__p"]["GU"], "CAP"), 1.0)])
				v_e_428 = (J.hypot_([J.sub(J.gp(v_c_427, 0.0), J.gp(v_tgt_418, 0.0)), J.sub(J.gp(v_c_427, 1.0), J.gp(v_tgt_418, 1.0))]) + (J.mul(absf(J.num(J.sub(J.add(v_a1_424, v_a2_425), J.mul(J.gp(_s72["S"], "fs"), 0.55)))), J.gp(_s72["S"], "H")) * 0.03))
				if J.cmp(v_e_428, v_be_421, "<"):
					v_be_421 = v_e_428
					var _t140 = [v_a1_424, v_a2_425]
					v_best_420 = _t140
				var _t141 = J.add(v_a2_425, 0.05)
				v_a2_425 = _t141
			var _t142 = J.add(v_a1_424, 0.05)
			v_a1_424 = _t142
	var _t143 = _s72["__p"]["IKC"]
	var _t144 = J.mc(v_best_420, "slice", [])
	J.sp(_t143, v_ikK_419, _t144)
	v_A_422 = J.mul(_s72["k"], v_up_414)
	var _t145 = _s72["__p"]["guardDraw"]
	J.cl(_t145, null, [_s72["S"], {"arm": J.mul(J.gp(v_best_420, 0.0), v_A_422), "wrist": J.mul(J.sub(J.gp(v_best_420, 1.0), J.mul(v_drink_415, 0.25)), v_A_422), "head": (J.mul((-J.num(J.gp(_s72["S"], "fs"))), _s72["k"]) * (J.mul(v_up_414, 0.06) + J.mul(v_drink_415, 0.1))), "lean": (J.mul(J.mul((-J.num(J.gp(_s72["S"], "fs"))), _s72["k"]), v_drink_415) * 0.03), "fl": (J.mul(_s72["k"], v_up_414) * 0.05), "tfn": Callable(self, "_f51").bind(_s72)}])
	v_f_423 = J.mc(_s72["S"], "P", [0.45, 0.3])
	var _t147 = _s72["__p"]["puff"]
	var _t149 = J.gp(_s72["S"], "ctx")
	var _t150 = J.sub(J.gp(v_f_423, 0.0), (J.mul(J.gp(_s72["S"], "fs"), J.gp(_s72["S"], "W")) * 0.05))
	var _t151 = J.add(J.gp(v_f_423, 1.0), J.mul(J.gp(_s72["S"], "H"), 0.04))
	var _t152 = J.mul(J.gp(_s72["S"], "H"), 0.04)
	var _t148 = _s72["__p"]["seg"]
	J.cl(_t147, null, [_t149, _t150, _t151, _t152, J.cl(_t148, null, [_s72["t"], 2.3, 3.2]), 5.5])
	var _t153 = _s72["__p"]["text"]
	var _t155 = _s72["S"]
	var _t156 = J.sub(J.gp(v_f_423, 0.0), (J.mul(J.gp(_s72["S"], "fs"), J.gp(_s72["S"], "W")) * 0.35))
	var _t157 = J.sub(J.gp(v_f_423, 1.0), J.mul(J.gp(_s72["S"], "H"), 0.18))
	var _t158 = J.mul(J.gp(_s72["S"], "H"), 0.095)
	var _t154 = _s72["__p"]["bump"]
	J.cl(_t153, null, [_t155, _t156, _t157, "哈～", _t158, J.mul(J.cl(_t154, null, [_s72["t"], 2.3, 2.5, 3.1]), _s72["k"])])

func _f54(this_, a: Array, env):
	var v_S_448 = null; var v_ax_449 = null; var v_ay_450 = null; var v_L_451 = null
	v_S_448 = J.arg(a, 0)
	v_ax_449 = J.mul(J.sub(J.gp(J.gp(env["AU"], "BOT"), 0.0), J.gp(J.gp(env["AU"], "TOP"), 0.0)), J.gp(v_S_448, "W"))
	v_ay_450 = J.mul(J.sub(J.gp(J.gp(env["AU"], "BOT"), 1.0), J.gp(J.gp(env["AU"], "TOP"), 1.0)), J.gp(v_S_448, "H"))
	v_L_451 = J.hypot_([v_ax_449, v_ay_450])
	return {"ux": J.div(v_ax_449, v_L_451), "uy": J.div(v_ay_450, v_L_451), "L": v_L_451}

func _f55(this_, a: Array, env):
	var v_S_454 = null; var v_fx_455 = null; var v_fy_456 = null; var v_th_457 = null; var v_s_458 = null; var v_A_459 = null; var v_hx_460 = null; var v_hy_461 = null; var v_c_462 = null; var v_sn_463 = null
	v_S_454 = J.arg(a, 0)
	v_fx_455 = J.arg(a, 1)
	v_fy_456 = J.arg(a, 2)
	v_th_457 = J.arg(a, 3)
	v_s_458 = J.arg(a, 4)
	var _t159 = env["auAxis"]
	v_A_459 = J.cl(_t159, null, [v_S_454])
	v_hx_460 = (J.mul(J.sub(J.gp(J.gp(env["AU"], "HEAD"), 0.0), J.gp(J.gp(env["AU"], "FIST"), 0.0)), J.gp(v_S_454, "W")) - J.mul(J.mul(J.gp(v_A_459, "ux"), v_s_458), J.gp(v_A_459, "L")))
	v_hy_461 = (J.mul(J.sub(J.gp(J.gp(env["AU"], "HEAD"), 1.0), J.gp(J.gp(env["AU"], "FIST"), 1.0)), J.gp(v_S_454, "H")) - J.mul(J.mul(J.gp(v_A_459, "uy"), v_s_458), J.gp(v_A_459, "L")))
	v_c_462 = cos(J.num(v_th_457))
	v_sn_463 = sin(J.num(v_th_457))
	return [J.sub(J.add(v_fx_455, J.mul(v_hx_460, v_c_462)), J.mul(v_hy_461, v_sn_463)), J.add(J.add(v_fy_456, J.mul(v_hx_460, v_sn_463)), J.mul(v_hy_461, v_c_462))]

func _f56(this_, a: Array, env):
	var v_S_466 = null; var v_fx_467 = null; var v_fy_468 = null; var v_th_469 = null; var v_floor_470 = null; var v_h0_471 = null; var v_h1_472 = null
	v_S_466 = J.arg(a, 0)
	v_fx_467 = J.arg(a, 1)
	v_fy_468 = J.arg(a, 2)
	v_th_469 = J.arg(a, 3)
	v_floor_470 = J.arg(a, 4)
	var _t160 = env["auHead"]
	v_h0_471 = J.cl(_t160, null, [v_S_466, v_fx_467, v_fy_468, v_th_469, 0.0])
	var _t161 = env["auHead"]
	v_h1_472 = J.cl(_t161, null, [v_S_466, v_fx_467, v_fy_468, v_th_469, 1.0])
	var _t162 = env["cl"]
	var _t164 = J.sub(v_floor_470, J.gp(v_h0_471, 1.0))
	var _t163 = J.sub(J.gp(v_h1_472, 1.0), J.gp(v_h0_471, 1.0))
	return J.cl(_t162, null, [J.div(_t164, (_t163 if J.t(_t163) else 0.000001)), 0.0, 1.05])

func _f58(this_, a: Array, env):
	var v_u_483 = null; var v_v_484 = null
	v_u_483 = J.arg(a, 0)
	v_v_484 = J.arg(a, 1)
	return [J.mul(J.sub(v_u_483, J.gp(J.gp(env["__p"]["AU"], "FIST"), 0.0)), J.gp(env["S"], "W")), J.mul(J.sub(v_v_484, J.gp(J.gp(env["__p"]["AU"], "FIST"), 1.0)), J.gp(env["S"], "H"))]

func _f57(this_, a: Array, env):
	var v_fx_476 = null; var v_fy_477 = null; var v_th_478 = null; var v_s_479 = null; var v_wfn_480 = null; var v_ctx_481 = null; var v_A_482 = null
	var _s83 = {"__p": env, "S": null}
	_s83["S"] = J.arg(a, 0)
	v_fx_476 = J.arg(a, 1)
	v_fy_477 = J.arg(a, 2)
	v_th_478 = J.arg(a, 3)
	v_s_479 = J.arg(a, 4)
	v_wfn_480 = J.arg(a, 5)
	v_ctx_481 = J.gp(_s83["S"], "ctx")
	var _t165 = _s83["__p"]["auAxis"]
	v_A_482 = J.cl(_t165, null, [_s83["S"]])
	J.mc(v_ctx_481, "save", [])
	J.mc(v_ctx_481, "translate", [v_fx_476, v_fy_477])
	J.mc(v_ctx_481, "rotate", [v_th_478])
	J.mc(v_ctx_481, "translate", [J.mul(J.mul((-J.num(J.gp(v_A_482, "ux"))), v_s_479), J.gp(v_A_482, "L")), J.mul(J.mul((-J.num(J.gp(v_A_482, "uy"))), v_s_479), J.gp(v_A_482, "L"))])
	J.mc(v_ctx_481, "drawImage", [J.gp(J.G.get("SPR"), "npc_auntie__mop"), J.mul((-J.num(J.gp(J.gp(_s83["__p"]["AU"], "FIST"), 0.0))), J.gp(_s83["S"], "W")), J.mul((-J.num(J.gp(J.gp(_s83["__p"]["AU"], "FIST"), 1.0))), J.gp(_s83["S"], "H")), J.gp(_s83["S"], "W"), J.gp(_s83["S"], "H")])
	if J.t(v_wfn_480):
		J.cl(v_wfn_480, null, [Callable(self, "_f58").bind(_s83)])
	J.mc(v_ctx_481, "restore", [])

func _f60(this_, a: Array, env):
	var v_S_488 = null; var v_P_489 = null; var v_c_490 = null; var v_handOK_491 = null; var v_f_492 = null; var v_w_493 = null; var v_th_494 = null; var v_want_495 = null; var v_ha_496 = null; var v_cs_497 = null; var v_sn_498 = null; var v_rx_499 = null; var v_ry_500 = null; var v_fx_501 = null; var v_fy_502 = null; var v_s_503 = null
	v_S_488 = J.arg(a, 0)
	v_P_489 = J.arg(a, 1)
	v_c_490 = J.gp(v_S_488, "ctx")
	J.mc(v_c_490, "save", [])
	var _t166 = env["lean"]
	var _t167 = J.gp(v_P_489, "lean")
	var _t169 = (_t167 if J.t(_t167) else 0.0)
	var _t168 = J.gp(v_P_489, "dx")
	J.cl(_t166, null, [v_S_488, _t169, 0.35, (_t168 if J.t(_t168) else 0.0), 0.0])
	var _t170 = env["ok"]
	var _t172 = J.cl(_t170, null, ["npc_auntie__hand"])
	if J.t(_t172):
		var _t171 = env["ok"]
		_t172 = J.cl(_t171, null, ["npc_auntie__bodyM"])
	v_handOK_491 = _t172
	var _t173 = env["body"]
	var _t179 = ("npc_auntie__bodyM" if J.t(v_handOK_491) else "npc_auntie__bodyH")
	var _t174 = J.gp(v_P_489, "head")
	var _t176 = (_t174 if J.t(_t174) else 0.0)
	var _t175 = J.gp(v_P_489, "legF")
	var _t178 = (_t175 if J.t(_t175) else 0.0)
	var _t177 = J.gp(v_P_489, "legB")
	J.cl(_t173, null, [v_S_488, "npc_auntie", _t179, {"head": _t176, "legF": _t178, "legB": (_t177 if J.t(_t177) else 0.0)}])
	v_f_492 = J.mc(v_S_488, "P", J.spread([J.SP(J.gp(env["AU"], "FIST"))]))
	v_w_493 = J.mc(v_S_488, "P", J.spread([J.SP(env["WR"])]))
	var _t180 = J.gp(v_P_489, "th")
	v_th_494 = (_t180 if J.t(_t180) else 0.0)
	var _t182 = J.gp(v_f_492, 0.0)
	var _t181 = J.gp(v_P_489, "fx")
	var _t185 = J.add(_t182, J.mul((_t181 if J.t(_t181) else 0.0), J.gp(v_S_488, "H")))
	var _t184 = J.gp(v_f_492, 1.0)
	var _t183 = J.gp(v_P_489, "fy")
	v_want_495 = [_t185, J.add(_t184, J.mul((_t183 if J.t(_t183) else 0.0), J.gp(v_S_488, "H")))]
	v_ha_496 = (atan2(J.num(J.sub(J.gp(v_want_495, 1.0), J.gp(v_w_493, 1.0))), J.num(J.sub(J.gp(v_want_495, 0.0), J.gp(v_w_493, 0.0)))) - atan2(J.num(J.sub(J.gp(v_f_492, 1.0), J.gp(v_w_493, 1.0))), J.num(J.sub(J.gp(v_f_492, 0.0), J.gp(v_w_493, 0.0)))))
	while true:
		if not J.cmp(v_ha_496, env["PI"], ">"): break
		var _t186 = J.sub(v_ha_496, J.mul(2.0, env["PI"]))
		v_ha_496 = _t186
	while true:
		if not J.cmp(v_ha_496, (-J.num(env["PI"])), "<"): break
		var _t187 = J.add(v_ha_496, J.mul(2.0, env["PI"]))
		v_ha_496 = _t187
	var _t188 = env["cl"]
	var _t190 = J.cl(_t188, null, [v_ha_496, (-0.55), 0.55])
	var _t189 = J.gp(v_P_489, "fa")
	var _t191 = J.add(_t190, (_t189 if J.t(_t189) else 0.0))
	v_ha_496 = _t191
	v_cs_497 = cos(J.num(v_ha_496))
	v_sn_498 = sin(J.num(v_ha_496))
	v_rx_499 = J.sub(J.gp(v_f_492, 0.0), J.gp(v_w_493, 0.0))
	v_ry_500 = J.sub(J.gp(v_f_492, 1.0), J.gp(v_w_493, 1.0))
	v_fx_501 = (J.sub(J.add(J.gp(v_w_493, 0.0), J.mul(v_rx_499, v_cs_497)), J.mul(v_ry_500, v_sn_498)) if J.t(v_handOK_491) else J.gp(v_want_495, 0.0))
	v_fy_502 = (J.add(J.add(J.gp(v_w_493, 1.0), J.mul(v_rx_499, v_sn_498)), J.mul(v_ry_500, v_cs_497)) if J.t(v_handOK_491) else J.gp(v_want_495, 1.0))
	var _t192 = J.gp(v_P_489, "s")
	v_s_503 = (_t192 if J.t(_t192) else 0.0)
	if (not J.leq(J.gp(v_P_489, "floor"), null)):
		var _t193 = env["lerp"]
		var _t194 = env["auReach"]
		var _t195 = J.cl(_t193, null, [0.0, J.cl(_t194, null, [v_S_488, v_fx_501, v_fy_502, v_th_494, J.gp(v_P_489, "floor")]), (1.0 if J.leq(J.gp(v_P_489, "reach"), null) else J.gp(v_P_489, "reach"))])
		v_s_503 = _t195
	var _t196 = env["auMop"]
	J.cl(_t196, null, [v_S_488, v_fx_501, v_fy_502, v_th_494, v_s_503, J.gp(v_P_489, "mfn")])
	if J.t(v_handOK_491):
		var _t197 = env["piece"]
		J.cl(_t197, null, [v_S_488, "npc_auntie__hand", env["WR"], v_w_493, v_ha_496])
	else:
		var _t198 = env["piece"]
		var _t202 = J.gp(env["AU"], "FIST")
		var _t203 = [v_fx_501, v_fy_502]
		var _t199 = env["resid"]
		var _t201 = J.cl(_t199, null, [v_th_494])
		var _t200 = J.gp(v_P_489, "fa")
		J.cl(_t198, null, [v_S_488, "npc_auntie__fist", _t202, _t203, J.add(_t201, (_t200 if J.t(_t200) else 0.0))])
	if J.t(J.gp(v_P_489, "hip")):
		J.mc(v_P_489, "hip", [v_fx_501, v_fy_502, v_th_494, v_s_503])
	else:
		var _t204 = env["piece"]
		var _t206 = J.gp(env["AU"], "SH")
		var _t207 = J.mc(v_S_488, "P", J.spread([J.SP(J.gp(env["AU"], "SH"))]))
		var _t205 = J.gp(v_P_489, "hipA")
		J.cl(_t204, null, [v_S_488, "npc_auntie__hip", _t206, _t207, (_t205 if J.t(_t205) else 0.0)])
	J.mc(v_c_490, "restore", [])
	return {"fx": v_fx_501, "fy": v_fy_502, "th": v_th_494, "s": v_s_503}

func _f77(this_, a: Array, env):
	var v_S_637 = null; var v_rig_638 = null; var v_key_639 = null; var v_add_640 = null; var v_z_641 = null; var v_k_642 = null
	v_S_637 = J.arg(a, 0)
	v_rig_638 = J.arg(a, 1)
	v_key_639 = J.arg(a, 2)
	v_add_640 = J.arg(a, 3)
	v_z_641 = J.S_Object_("assign", [{}, J.gp(v_S_637, "z")])
	J.sp(v_z_641, "x", 0.0)
	J.sp(v_z_641, "y", 0.0)
	J.sp(v_z_641, "sx", 1.0)
	J.sp(v_z_641, "sy", 1.0)
	J.sp(v_z_641, "rot", 0.0)
	J.sp(v_z_641, "legF", 0.0)
	J.sp(v_z_641, "legB", 0.0)
	for _t208 in J.keys(v_add_640):
		v_k_642 = _t208
		var _t209 = J.gp(v_z_641, v_k_642)
		var _t210 = J.add((_t209 if J.t(_t209) else 0.0), J.gp(v_add_640, v_k_642))
		J.sp(v_z_641, v_k_642, _t210)
	J.mc(J.G.get("MeshAnim"), "drawBody", [J.gp(v_S_637, "ctx"), v_rig_638, v_key_639, J.gp(v_S_637, "H"), v_z_641])

func _f91(this_, a: Array, env):
	var v_S_761 = null; var v_p_762 = null
	v_S_761 = J.arg(a, 0)
	var _t211 = J.gp(J.gp(v_S_761, "o"), "prop")
	v_p_762 = (_t211 if J.t(_t211) else {})
	if J.leq(J.gp(v_p_762, "potDX"), null):
		return [(J.mul(J.gp(v_S_761, "fs"), J.gp(v_S_761, "H")) * 0.42), ((-J.num(J.gp(v_S_761, "H"))) * 0.47)]
	return [J.div(J.mul(((-1.0) if J.t(J.gp(v_S_761, "flip")) else 1.0), J.gp(v_p_762, "potDX")), J.gp(J.gp(v_S_761, "z"), "sx")), J.div(J.sub(J.gp(v_p_762, "potDY"), J.mul(J.gp(J.gp(v_S_761, "z"), "y"), J.gp(v_S_761, "H"))), J.gp(J.gp(v_S_761, "z"), "sy"))]

func _f92(this_, a: Array, env):
	var v_ctx_765 = null; var v_x_766 = null; var v_y_767 = null; var v_s_768 = null; var v_k_769 = null; var v_t_770 = null; var v_i_771 = null; var v_ox_772 = null; var v_len_773 = null; var v_sw_774 = null
	v_ctx_765 = J.arg(a, 0)
	v_x_766 = J.arg(a, 1)
	v_y_767 = J.arg(a, 2)
	v_s_768 = J.arg(a, 3)
	v_k_769 = J.arg(a, 4)
	v_t_770 = J.arg(a, 5)
	if J.cmp(v_k_769, 0.0, "<="):
		return null
	J.mc(v_ctx_765, "save", [])
	var _t212 = env["cl"]
	var _t213 = J.mul(J.gp(v_ctx_765, "globalAlpha"), J.cl(_t212, null, [v_k_769]))
	J.sp(v_ctx_765, "globalAlpha", _t213)
	v_i_771 = 0.0
	while true:
		if not J.cmp(v_i_771, 6.0, "<"): break
		v_ox_772 = (J.mul(J.sub(v_i_771, 2.5), v_s_768) * 0.07)
		var _t214 = env["rnd"]
		v_len_773 = J.mul(v_s_768, (0.22 + J.mul(0.16, J.cl(_t214, null, [J.add(v_i_771, 3.0)]))))
		v_sw_774 = (J.mul(sin(J.num(J.add(J.mul(v_t_770, 6.0), v_i_771))), v_s_768) * 0.04)
		var _t215 = env["crayon"]
		J.cl(_t215, null, [v_ctx_765, [[J.add(v_x_766, v_ox_772), v_y_767], [J.add(J.add(v_x_766, v_ox_772), J.mul(v_sw_774, 0.5)), J.add(v_y_767, J.mul(v_len_773, 0.5))], [J.add(J.add(v_x_766, v_ox_772), v_sw_774), J.add(v_y_767, v_len_773)]], J.max_([1.2, J.mul(v_s_768, 0.03)]), "#f4d77a", "rgba(110,70,20,.55)"])
		v_i_771 = J.num(v_i_771) + 1.0
	J.mc(v_ctx_765, "restore", [])

func _f93(this_, a: Array, env):
	var v_S_777 = null; var v_hx_778 = null; var v_hy_779 = null; var v_ang_780 = null; var v_nood_781 = null; var v_t_782 = null; var v_clipY_783 = null; var v_ctx_784 = null; var v_im_785 = null; var v_h_786 = null; var v_w_787 = null; var v_net_788 = null; var v_c_789 = null; var v_s_790 = null
	v_S_777 = J.arg(a, 0)
	v_hx_778 = J.arg(a, 1)
	v_hy_779 = J.arg(a, 2)
	v_ang_780 = J.arg(a, 3)
	v_nood_781 = J.arg(a, 4)
	v_t_782 = J.arg(a, 5)
	v_clipY_783 = J.arg(a, 6)
	v_ctx_784 = J.gp(v_S_777, "ctx")
	var _t216 = env["ok"]
	if (not J.t(J.cl(_t216, null, ["street_strainer"]))):
		return null
	v_im_785 = J.gp(J.G.get("SPR"), "street_strainer")
	v_h_786 = J.mul(J.gp(v_S_777, "H"), 0.34)
	v_w_787 = J.div(J.mul(v_h_786, J.gp(v_im_785, "naturalWidth")), J.gp(v_im_785, "naturalHeight"))
	J.mc(v_ctx_784, "save", [])
	if (not J.leq(v_clipY_783, null)):
		J.mc(v_ctx_784, "beginPath", [])
		J.mc(v_ctx_784, "rect", [((-J.num(J.gp(v_S_777, "H"))) * 5.0), ((-J.num(J.gp(v_S_777, "H"))) * 5.0), J.mul(J.gp(v_S_777, "H"), 10.0), J.add(v_clipY_783, J.mul(J.gp(v_S_777, "H"), 5.0))])
		J.mc(v_ctx_784, "clip", [])
	J.mc(v_ctx_784, "translate", [v_hx_778, v_hy_779])
	J.mc(v_ctx_784, "rotate", [v_ang_780])
	J.mc(v_ctx_784, "drawImage", [v_im_785, J.div((-J.num(v_w_787)), 2.0), ((-J.num(v_h_786)) * 0.1), v_w_787, v_h_786])
	v_net_788 = [0.0, J.mul(v_h_786, 0.68)]
	if J.cmp(v_nood_781, 0.0, ">"):
		var _t217 = env["noodles"]
		J.cl(_t217, null, [v_ctx_784, J.gp(v_net_788, 0.0), J.add(J.gp(v_net_788, 1.0), J.mul(v_h_786, 0.12)), v_h_786, v_nood_781, v_t_782])
	v_c_789 = cos(J.num(v_ang_780))
	v_s_790 = sin(J.num(v_ang_780))
	J.mc(v_ctx_784, "restore", [])
	return {"x": J.sub(J.add(v_hx_778, J.mul(J.gp(v_net_788, 0.0), v_c_789)), J.mul(J.gp(v_net_788, 1.0), v_s_790)), "y": J.add(J.add(v_hy_779, J.mul(J.gp(v_net_788, 0.0), v_s_790)), J.mul(J.gp(v_net_788, 1.0), v_c_789))}

func _f94(this_, a: Array, env):
	var v_S_793 = null; var v_mode_794 = null; var v_ctx_795 = null; var v_t_796 = null; var v_k_797 = null; var v_pot_798 = null; var v_pv_799 = null; var v_at_800 = null; var v_G0_801 = null; var v_g0_802 = null; var v_tx_803 = null; var v_ty_804 = null; var v_sAng_805 = null; var v_nood_806 = null; var v_headA_807 = null; var v_txt_808 = null; var v_ta_809 = null; var v_clip_810 = null; var v_rot_811 = null; var v_dx_812 = null; var v_dy_813 = null; var v_ang_814 = null; var v_hp_815 = null; var v_an_816 = null; var v_q_817 = null; var v_lift_818 = null; var v_up_819 = null; var v_m_820 = null; var v_chew_821 = null; var v_look_822 = null; var v_net_823 = null; var v_h_824 = null
	v_S_793 = J.arg(a, 0)
	v_mode_794 = J.arg(a, 1)
	v_ctx_795 = J.gp(v_S_793, "ctx")
	v_t_796 = J.gp(v_S_793, "at")
	v_k_797 = J.gp(v_S_793, "env")
	var _t218 = env["eguiPot"]
	v_pot_798 = J.cl(_t218, null, [v_S_793])
	v_pv_799 = [0.12, 0.5]
	v_at_800 = J.mc(v_S_793, "P", J.spread([J.SP(v_pv_799)]))
	v_G0_801 = [0.1, 0.3]
	v_g0_802 = J.mc(v_S_793, "P", J.spread([J.SP(v_G0_801)]))
	v_tx_803 = J.gp(v_pot_798, 0.0)
	v_ty_804 = J.sub(J.gp(v_pot_798, 1.0), J.mul(J.gp(v_S_793, "H"), 0.31))
	v_sAng_805 = 0.0
	v_nood_806 = 0.0
	v_headA_807 = J.mul(J.gp(v_S_793, "fs"), 0.12)
	v_txt_808 = ""
	v_ta_809 = 0.0
	v_clip_810 = true
	v_rot_811 = 0.0
	if J.seq(v_mode_794, "stir"):
		v_an_816 = J.mul(v_t_796, 4.2)
		var _t219 = J.add(v_tx_803, (J.mul(cos(J.num(v_an_816)), J.gp(v_S_793, "H")) * 0.035))
		v_tx_803 = _t219
		var _t220 = J.add(v_ty_804, (J.mul(J.gp(v_S_793, "H"), 0.05) + (J.mul(sin(J.num(v_an_816)), J.gp(v_S_793, "H")) * 0.012)))
		v_ty_804 = _t220
		var _t221 = (cos(J.num(v_an_816)) * 0.15)
		v_sAng_805 = _t221
		var _t222 = J.mul(J.gp(v_S_793, "fs"), (0.14 + (sin(J.num(v_an_816)) * 0.02)))
		v_headA_807 = _t222
		var _t223 = (sin(J.num(v_an_816)) * 0.04)
		v_rot_811 = _t223
	if J.seq(v_mode_794, "ladle"):
		v_q_817 = J.mod(v_t_796, 3.0)
		var _t224 = env["kf"]
		v_lift_818 = J.cl(_t224, null, [[[0.0, 0.0], [0.5, 0.15], [0.9, (-0.1)], [1.4, 1.0], [2.4, 1.0], [3.0, 0.0]], v_q_817])
		var _t225 = J.add(v_ty_804, J.mul(J.gp(v_S_793, "H"), (0.06 - J.mul(v_lift_818, 0.16))))
		v_ty_804 = _t225
		var _t226 = (J.mul((-J.num(J.gp(v_S_793, "fs"))), v_lift_818) * 0.12)
		v_sAng_805 = _t226
		var _t227 = env["seg"]
		var _t229 = J.cl(_t227, null, [v_q_817, 1.0, 1.4])
		var _t228 = env["seg"]
		var _t230 = J.mul(_t229, J.sub(1.0, J.cl(_t228, null, [v_q_817, 2.5, 2.9])))
		v_nood_806 = _t230
		var _t231 = J.mul(J.gp(v_S_793, "fs"), (0.12 - J.mul(v_lift_818, 0.06)))
		v_headA_807 = _t231
		var _t232 = (J.mul((-J.num(J.gp(v_S_793, "fs"))), v_lift_818) * 0.1)
		v_rot_811 = _t232
	if J.seq(v_mode_794, "taste"):
		var _t233 = env["kf"]
		v_up_819 = J.cl(_t233, null, [[[0.0, 0.0], [0.5, 0.45], [1.0, 1.0], [2.2, 1.0], [2.6, 0.3], [3.3, 0.0]], v_t_796])
		v_m_820 = J.mc(v_S_793, "P", [0.47, 0.34])
		var _t235 = sin(J.num(J.mul(v_t_796, 14.0)))
		var _t234 = env["seg"]
		var _t237 = J.mul(_t235, J.cl(_t234, null, [v_t_796, 1.0, 1.1]))
		var _t236 = env["seg"]
		v_chew_821 = (_t237 * J.sub(1.0, J.cl(_t236, null, [v_t_796, 1.8, 1.9])))
		var _t239 = sin(J.num((J.sub(v_t_796, 1.9) * 8.0)))
		var _t238 = env["bump"]
		v_look_822 = J.mul(_t239, J.cl(_t238, null, [v_t_796, 1.9, 2.1, 2.7]))
		var _t240 = env["lerp"]
		var _t241 = J.cl(_t240, null, [v_tx_803, J.add(J.gp(v_m_820, 0.0), (J.mul(J.gp(v_S_793, "fs"), J.gp(v_S_793, "W")) * 0.1)), v_up_819])
		v_tx_803 = _t241
		var _t242 = env["lerp"]
		var _t243 = J.cl(_t242, null, [J.add(v_ty_804, J.mul(J.gp(v_S_793, "H"), 0.05)), J.sub(J.gp(v_m_820, 1.0), J.mul(J.gp(v_S_793, "H"), 0.22)), v_up_819])
		v_ty_804 = _t243
		var _t244 = (J.mul((-J.num(J.gp(v_S_793, "fs"))), v_up_819) * 0.6)
		v_sAng_805 = _t244
		var _t245 = env["seg"]
		var _t246 = (J.sub(1.0, J.cl(_t245, null, [v_t_796, 1.0, 1.15])) * J.min_([1.0, (J.div(v_t_796, 0.3) + 0.0001)]))
		v_nood_806 = _t246
		var _t247 = ((J.mul(J.gp(v_S_793, "fs"), (0.1 - J.mul(v_up_819, 0.1))) + J.mul(v_chew_821, 0.04)) + J.mul(v_look_822, 0.18))
		v_headA_807 = _t247
		var _t248 = ("嗯～" if J.cmp(v_t_796, 1.9, "<") else "……")
		v_txt_808 = _t248
		var _t249 = env["bump"]
		var _t251 = J.cl(_t249, null, [v_t_796, 1.1, 1.3, 2.0])
		var _t250 = env["bump"]
		var _t252 = J.add(_t251, J.mul(J.cl(_t250, null, [v_t_796, 2.0, 2.2, 2.7]), 0.8))
		v_ta_809 = _t252
		var _t253 = J.cmp(v_up_819, 0.2, "<")
		v_clip_810 = _t253
		var _t254 = (J.mul((-J.num(J.gp(v_S_793, "fs"))), v_up_819) * 0.25)
		v_rot_811 = _t254
	v_dx_812 = J.mul(J.sub(v_tx_803, J.gp(v_g0_802, 0.0)), v_k_797)
	v_dy_813 = J.mul(J.sub(v_ty_804, J.gp(v_g0_802, 1.0)), v_k_797)
	v_ang_814 = J.mul(v_rot_811, v_k_797)
	var _t255 = env["body"]
	J.cl(_t255, null, [v_S_793, "eguiking", "eguiking__body", {"head": J.mul(v_headA_807, v_k_797)}])
	var _t256 = env["rotP"]
	v_hp_815 = J.cl(_t256, null, [v_S_793, J.gp(v_pv_799, 0.0), J.gp(v_pv_799, 1.0), [J.add(J.gp(v_at_800, 0.0), v_dx_812), J.add(J.gp(v_at_800, 1.0), v_dy_813)], v_ang_814, J.gp(v_G0_801, 0.0), J.gp(v_G0_801, 1.0)])
	if J.cmp(v_k_797, 0.02, ">"):
		J.mc(v_ctx_795, "save", [])
		var _t257 = env["ss"]
		var _t258 = J.mul(J.gp(v_ctx_795, "globalAlpha"), J.cl(_t257, null, [J.mul(v_k_797, 1.5)]))
		J.sp(v_ctx_795, "globalAlpha", _t258)
		var _t259 = env["strainer"]
		v_net_823 = J.cl(_t259, null, [v_S_793, J.gp(v_hp_815, 0.0), J.gp(v_hp_815, 1.0), J.add(J.mul(v_sAng_805, v_k_797), v_ang_814), J.mul(v_nood_806, v_k_797), v_t_796, (J.gp(v_pot_798, 1.0) if J.t(v_clip_810) else null)])
		if J.t((J.cmp(v_nood_806, 0.0, ">") if J.t(v_net_823) else v_net_823)):
			var _t260 = env["steamCurl"]
			J.cl(_t260, null, [v_ctx_795, J.gp(v_net_823, "x"), J.sub(J.gp(v_net_823, "y"), J.mul(J.gp(v_S_793, "H"), 0.02)), J.mul(J.gp(v_S_793, "H"), 0.22), J.mod(J.mul(v_t_796, 0.8), 1.0), 1.7, J.mul(v_nood_806, v_k_797)])
			var _t261 = env["drop"]
			J.cl(_t261, null, [v_ctx_795, J.gp(v_net_823, "x"), J.add(J.gp(v_net_823, "y"), J.mul(J.gp(v_S_793, "H"), 0.06)), J.mul(J.gp(v_S_793, "H"), 0.008), J.mod(J.mul(v_t_796, 1.5), 1.0), J.mul(J.gp(v_S_793, "H"), 0.1)])
		var _t262 = J.seq(v_mode_794, "stir")
		if (J.cmp(v_k_797, 0.5, ">") if _t262 else _t262):
			var _t263 = env["steamCurl"]
			J.cl(_t263, null, [v_ctx_795, J.add(J.gp(v_pot_798, 0.0), (J.mul(sin(J.num(v_t_796)), J.gp(v_S_793, "H")) * 0.04)), J.sub(J.gp(v_pot_798, 1.0), J.mul(J.gp(v_S_793, "H"), 0.03)), J.mul(J.gp(v_S_793, "H"), 0.3), J.mod(J.mul(v_t_796, 0.5), 1.0), 4.4, 0.6])
		J.mc(v_ctx_795, "restore", [])
	var _t264 = env["piece"]
	J.cl(_t264, null, [v_S_793, "eguiking__hand", v_pv_799, [J.add(J.gp(v_at_800, 0.0), v_dx_812), J.add(J.gp(v_at_800, 1.0), v_dy_813)], v_ang_814])
	if J.cmp(v_ta_809, 0.0, ">"):
		v_h_824 = J.mc(v_S_793, "P", [0.5, 0.05])
		var _t265 = env["text"]
		J.cl(_t265, null, [v_S_793, J.sub(J.gp(v_h_824, 0.0), (J.mul(J.gp(v_S_793, "fs"), J.gp(v_S_793, "W")) * 0.35)), J.gp(v_h_824, 1.0), v_txt_808, J.mul(J.gp(v_S_793, "H"), 0.1), J.mul(v_ta_809, v_k_797)])

func _f100(this_, a: Array, env):
	var v_S_863 = null; var v_key_864 = null; var v_x_865 = null; var v_y_866 = null; var v_w_867 = null; var v_len_868 = null; var v_t_869 = null; var v_walk_870 = null; var v_ctx_871 = null; var v_sw_872 = null
	v_S_863 = J.arg(a, 0)
	v_key_864 = J.arg(a, 1)
	v_x_865 = J.arg(a, 2)
	v_y_866 = J.arg(a, 3)
	v_w_867 = J.arg(a, 4)
	v_len_868 = J.arg(a, 5)
	v_t_869 = J.arg(a, 6)
	v_walk_870 = J.arg(a, 7)
	v_ctx_871 = J.gp(v_S_863, "ctx")
	v_sw_872 = (((sin(J.num((J.mul(v_t_869, 7.0) - 0.9))) * 0.22) if J.t(v_walk_870) else (sin(J.num(J.mul(v_t_869, 1.7))) * 0.06)) + (((-J.num(J.gp(v_S_863, "fs"))) * 0.12) if J.t(v_walk_870) else 0.0))
	J.mc(v_ctx_871, "save", [])
	J.mc(v_ctx_871, "translate", [v_x_865, v_y_866])
	J.mc(v_ctx_871, "rotate", [v_sw_872])
	J.sp(v_ctx_871, "strokeStyle", "rgba(40,28,24,.9)")
	var _t266 = J.max_([1.0, J.mul(J.gp(v_S_863, "H"), 0.008)])
	J.sp(v_ctx_871, "lineWidth", _t266)
	J.mc(v_ctx_871, "beginPath", [])
	J.mc(v_ctx_871, "moveTo", [0.0, 0.0])
	J.mc(v_ctx_871, "lineTo", [0.0, v_len_868])
	J.mc(v_ctx_871, "stroke", [])
	var _t267 = env["prop"]
	J.cl(_t267, null, [v_ctx_871, v_key_864, 0.0, v_len_868, v_w_867, ((-J.num(v_sw_872)) * 0.4), 0.5, 0.04])
	J.mc(v_ctx_871, "restore", [])

func _f102(this_, a: Array, env):
	var v_L_886 = null; var v_h_887 = null
	v_L_886 = J.arg(a, 0)
	v_h_887 = J.cl(v_L_886, null, J.spread([J.SP(J.gp(env["G"], "tip"))]))
	var _t281 = J.seq(env["kind"], "lanternW")
	if (_t281 if _t281 else J.seq(env["kind"], "lanternR")):
		var _t282 = env["__p"]["hang"]
		var _t285 = env["S"]
		var _t286 = ("street_lanternW" if J.seq(env["kind"], "lanternW") else "street_lanternR")
		var _t287 = J.gp(v_h_887, 0.0)
		var _t288 = J.gp(v_h_887, 1.0)
		var _t284 = J.mul(J.gp(env["S"], "H"), 0.24)
		var _t283 = J.gp(env["pr"], "big")
		J.cl(_t282, null, [_t285, _t286, _t287, _t288, J.mul(_t284, (_t283 if J.t(_t283) else 1.0)), J.mul(J.gp(env["S"], "H"), 0.06), env["t"], J.gp(env["S"], "walk")])
	if J.seq(env["kind"], "bag"):
		var _t289 = env["__p"]["hang"]
		J.cl(_t289, null, [env["S"], "bun__basket", J.gp(v_h_887, 0.0), J.gp(v_h_887, 1.0), J.mul(J.gp(env["S"], "H"), 0.3), J.mul(J.gp(env["S"], "H"), 0.03), env["t"], J.gp(env["S"], "walk")])
	if J.seq(env["kind"], "phone"):
		var _t290 = env["__p"]["prop"]
		J.cl(_t290, null, [env["ctx"], "afu__phone", J.gp(v_h_887, 0.0), J.sub(J.gp(v_h_887, 1.0), J.mul(J.gp(env["S"], "H"), 0.03)), J.mul(J.gp(env["S"], "H"), 0.13), J.mul(J.gp(env["S"], "fs"), 0.2), 0.5, 0.6, (-J.num(J.gp(env["S"], "fs"))), 1.0])

func _f101(this_, a: Array, env):
	var v_P_877 = null; var v_k_881 = null; var v_ad_882 = null; var v_at_883 = null; var v_ang_885 = null; var v_q_888 = null; var v_lines_889 = null; var v_h_890 = null
	var _s149 = {"__p": env, "S": null, "G": null, "ctx": null, "t": null, "pr": null, "kind": null}
	_s149["S"] = J.arg(a, 0)
	_s149["G"] = J.arg(a, 1)
	v_P_877 = J.arg(a, 2)
	_s149["ctx"] = J.gp(_s149["S"], "ctx")
	_s149["t"] = J.gp(_s149["S"], "t")
	var _t268 = J.gp(J.gp(_s149["S"], "o"), "prop")
	_s149["pr"] = (_t268 if J.t(_t268) else {})
	v_k_881 = J.gp(_s149["S"], "env")
	J.mc(_s149["ctx"], "save", [])
	var _t269 = _s149["__p"]["lean"]
	var _t271 = _s149["S"]
	var _t270 = J.gp(v_P_877, "lean")
	var _t273 = (_t270 if J.t(_t270) else 0.0)
	var _t272 = J.gp(v_P_877, "dx")
	J.cl(_t269, null, [_t271, _t273, 0.3, (_t272 if J.t(_t272) else 0.0), 0.0])
	var _t274 = J.gp(v_P_877, "head")
	v_ad_882 = {"head": (_t274 if J.t(_t274) else 0.0)}
	if J.t(J.gp(_s149["G"], "still")):
		J.sp(v_ad_882, "head", 0.0)
	var _t275 = _s149["__p"]["body"]
	J.cl(_t275, null, [_s149["S"], J.gp(J.gp(_s149["S"], "a"), "type"), J.gp(_s149["G"], "key"), v_ad_882])
	v_at_883 = J.mc(_s149["S"], "P", J.spread([J.SP(J.gp(_s149["G"], "pv"))]))
	_s149["kind"] = J.gp(_s149["pr"], "kind")
	var _t276 = J.gp(v_P_877, "arm")
	v_ang_885 = (_t276 if J.t(_t276) else 0.0)
	if J.seq(_s149["kind"], "phone"):
		var _t277 = J.add(v_ang_885, J.mul(((-J.num(J.gp(_s149["S"], "fs"))) * 0.15), v_k_881))
		v_ang_885 = _t277
	var _t278 = J.seq(_s149["kind"], "lanternW")
	if (_t278 if _t278 else J.seq(_s149["kind"], "lanternR")):
		var _t279 = J.add(v_ang_885, (((sin(J.num(J.mul(_s149["t"], 7.0))) * 0.08) if J.t(J.gp(_s149["S"], "walk")) else 0.0) - J.mul(J.mul(J.gp(_s149["S"], "fs"), 0.1), v_k_881)))
		v_ang_885 = _t279
	var _t280 = _s149["__p"]["piece"]
	J.cl(_t280, null, [_s149["S"], J.gp(_s149["G"], "arm"), J.gp(_s149["G"], "pv"), v_at_883, v_ang_885, 1.0, Callable(self, "_f102").bind(_s149)])
	J.mc(_s149["ctx"], "restore", [])
	if J.seq(_s149["kind"], "phone"):
		var _t292 = J.mul(_s149["t"], 0.5)
		var _t291 = J.gp(_s149["pr"], "seed")
		v_q_888 = J.mod(J.add(_t292, (_t291 if J.t(_t291) else 0.0)), 1.0)
		var _t293 = J.gp(_s149["pr"], "lines")
		v_lines_889 = (_t293 if J.t(_t293) else ["喂？", "收到收到", "在路上了"])
		v_h_890 = J.mc(_s149["S"], "P", [0.5, 0.0])
		var _t294 = _s149["__p"]["text"]
		var _t297 = _s149["S"]
		var _t298 = J.sub(J.gp(v_h_890, 0.0), (J.mul(J.gp(_s149["S"], "fs"), J.gp(_s149["S"], "W")) * 0.1))
		var _t299 = J.sub(J.gp(v_h_890, 1.0), J.mul(J.gp(_s149["S"], "H"), 0.05))
		var _t296 = J.mul(_s149["t"], 0.5)
		var _t295 = J.gp(_s149["pr"], "seed")
		var _t301 = J.gp(v_lines_889, J.mod(floor(J.num(J.add(_t296, (_t295 if J.t(_t295) else 0.0)))), J.len(v_lines_889)))
		var _t302 = J.mul(J.gp(_s149["S"], "H"), 0.13)
		var _t300 = _s149["__p"]["bump"]
		J.cl(_t294, null, [_t297, _t298, _t299, _t301, _t302, (J.mul(J.cl(_t300, null, [v_q_888, 0.05, 0.2, 0.7]), v_k_881) * 0.95), {"col": "#e8fff0", "out": "#14281e"}])

func _f107(this_, a: Array, env):
	var v_e_930 = null
	v_e_930 = J.arg(a, 0)
	var _t312 = (not J.t(env["walk"]))
	return (_t312 if _t312 else J.seq(J.gp(v_e_930, 4.0), "walk"))

func _f108(this_, a: Array, env):
	var v_e_931 = null
	v_e_931 = J.arg(a, 0)
	return J.seq(J.gp(v_e_931, 0.0), J.gp(env["st"], "act"))

func _f109(this_, a: Array, env):
	var v_e_933 = null
	v_e_933 = J.arg(a, 0)
	var _t335 = env["can"]
	var _t337 = J.cl(_t335, null, [v_e_933])
	if J.t(_t337):
		var _t336 = J.gp(J.gp(env["st"], "cd"), J.gp(v_e_933, 0.0))
		_t337 = J.cmp((_t336 if J.t(_t336) else 0.0), 0.0, "<=")
	var _t339 = _t337
	if J.t(_t339):
		var _t338 = (not J.seq(J.gp(v_e_933, 0.0), J.gp(env["st"], "act")))
		_t339 = (_t338 if _t338 else J.seq(J.len(J.mc(env["L"], "filter", [env["can"]])), 1.0))
	return _t339

func _f110(this_, a: Array, env):
	var v_s_936 = null; var v_e_937 = null
	v_s_936 = J.arg(a, 0)
	v_e_937 = J.arg(a, 1)
	return J.add(v_s_936, J.gp(v_e_937, 1.0))

func _f106(this_, a: Array, env):
	var v_id_920 = null; var v_dt_921 = null; var v_eligible_922 = null; var v_force_924 = null; var v_cur_927 = null; var v_want_928 = null; var v_k_929 = null; var v_opts_932 = null; var v_r_934 = null; var v_e_935 = null; var v_o_938 = null
	var _s156 = {"__p": env, "st": null, "walk": null, "L": null, "can": null}
	_s156["st"] = J.arg(a, 0)
	v_id_920 = J.arg(a, 1)
	v_dt_921 = J.arg(a, 2)
	v_eligible_922 = J.arg(a, 3)
	_s156["walk"] = J.arg(a, 4)
	v_force_924 = J.arg(a, 5)
	var _t303 = J.gp(_s156["__p"]["LIST"], v_id_920)
	_s156["L"] = (_t303 if J.t(_t303) else [])
	var _t304 = (_s156["st"] if J.t(_s156["st"]) else {"act": null, "at": 0.0, "dur": 0.0, "w": 0.0, "cd": {}})
	_s156["st"] = _t304
	var _t305 = (not J.t(v_force_924))
	if J.t((J.gp(_s156["st"], "forced") if _t305 else _t305)):
		var _t306 = _s156["st"]
		J.sp(_t306, "forced", false)
		var _t307 = _s156["st"]
		var _t308 = J.min_([J.gp(_s156["st"], "dur"), J.add(J.gp(_s156["st"], "at"), 0.35)])
		J.sp(_t307, "dur", _t308)
	for _t309 in J.keys(J.gp(_s156["st"], "cd")):
		v_k_929 = _t309
		var _t310 = J.gp(_s156["st"], "cd")
		var _t311 = J.sub(J.gp(_t310, v_k_929), v_dt_921)
		J.sp(_t310, v_k_929, _t311)
	_s156["can"] = Callable(self, "_f107").bind(_s156)
	var _t314 = v_force_924
	if J.t(_t314):
		var _t313 = (not J.seq(J.gp(_s156["st"], "act"), J.gp(v_force_924, 0.0)))
		_t314 = (_t313 if _t313 else J.cmp(J.gp(_s156["st"], "at"), J.gp(_s156["st"], "dur"), ">"))
	if J.t(_t314):
		var _t315 = _s156["st"]
		var _t316 = J.gp(v_force_924, 0.0)
		J.sp(_t315, "act", _t316)
		var _t317 = _s156["st"]
		J.sp(_t317, "at", 0.0)
		var _t318 = _s156["st"]
		var _t319 = J.gp(v_force_924, 1.0)
		J.sp(_t318, "dur", _t319)
		var _t320 = _s156["st"]
		J.sp(_t320, "forced", true)
	var _t321 = _s156["st"]
	var _t322 = J.add(J.gp(_t321, "at"), v_dt_921)
	J.sp(_t321, "at", _t322)
	v_cur_927 = J.mc(_s156["L"], "find", [Callable(self, "_f108").bind(_s156)])
	var _t326 = v_eligible_922
	if J.t(_t326):
		var _t323 = J.gp(_s156["st"], "act")
		var _t325 = null
		if J.t((v_cur_927 if J.t(_t323) else _t323)):
			var _t324 = _s156["can"]
			_t325 = J.cl(_t324, null, [v_cur_927])
		else:
			_t325 = true
		_t326 = _t325
	v_want_928 = _t326
	var _t327 = _s156["st"]
	var _t328 = _s156["__p"]["cl"]
	var _t329 = J.cl(_t328, null, [J.add(J.gp(_s156["st"], "w"), J.div(J.mul((1.0 if J.t(v_want_928) else (-1.0)), v_dt_921), 0.25))])
	J.sp(_t327, "w", _t329)
	var _t334 = v_eligible_922
	if J.t(_t334):
		var _t330 = (not J.t(J.gp(_s156["st"], "act")))
		var _t333 = (_t330 if _t330 else J.cmp(J.gp(_s156["st"], "at"), J.gp(_s156["st"], "dur"), ">="))
		if not J.t(_t333):
			var _t332 = v_cur_927
			if J.t(_t332):
				var _t331 = _s156["can"]
				_t332 = (not J.t(J.cl(_t331, null, [v_cur_927])))
			_t333 = (J.cmp(J.gp(_s156["st"], "w"), 0.0, "<=") if J.t(_t332) else _t332)
		_t334 = _t333
	if J.t(_t334):
		v_opts_932 = J.mc(_s156["L"], "filter", [Callable(self, "_f109").bind(_s156)])
		if J.t(J.len(v_opts_932)):
			v_r_934 = J.mul(randf(), J.mc(v_opts_932, "reduce", [Callable(self, "_f110").bind(_s156), 0.0]))
			v_e_935 = J.gp(v_opts_932, 0.0)
			for _t340 in J.iter(v_opts_932):
				v_o_938 = _t340
				var _t341 = J.sub(v_r_934, J.gp(v_o_938, 1.0))
				v_r_934 = _t341
				if J.cmp(v_r_934, 0.0, "<="):
					v_e_935 = v_o_938
					break
			var _t342 = _s156["st"]
			var _t343 = J.gp(v_e_935, 0.0)
			J.sp(_t342, "act", _t343)
			var _t344 = _s156["st"]
			J.sp(_t344, "at", 0.0)
			var _t345 = _s156["st"]
			var _t346 = J.add(J.gp(J.gp(v_e_935, 2.0), 0.0), (randf() * J.sub(J.gp(J.gp(v_e_935, 2.0), 1.0), J.gp(J.gp(v_e_935, 2.0), 0.0))))
			J.sp(_t345, "dur", _t346)
			var _t347 = J.gp(_s156["st"], "cd")
			var _t348 = J.gp(v_e_935, 0.0)
			var _t349 = J.add(J.gp(v_e_935, 3.0), J.gp(_s156["st"], "dur"))
			J.sp(_t347, _t348, _t349)
	var _t350 = (not J.t(v_eligible_922))
	if (J.cmp(J.gp(_s156["st"], "w"), 0.0, "<=") if _t350 else _t350):
		var _t351 = _s156["st"]
		J.sp(_t351, "act", null)
	return _s156["st"]

func _f112(this_, a: Array, env):
	var v_n_942 = null; var v_dt_943 = null; var v_scare_944 = null; var v_d_945 = null; var v_rx_946 = null; var v_calm_947 = null; var v_walk_948 = null; var v_force_949 = null; var v_fa_950 = null
	v_n_942 = J.arg(a, 0)
	v_dt_943 = J.arg(a, 1)
	v_scare_944 = J.arg(a, 2)
	v_d_945 = J.gp(v_n_942, "d")
	var _t352 = J.gp(v_n_942, "rx")
	v_rx_946 = (J.gp(v_n_942, "rx") if J.t((J.cmp(J.gp(J.gp(v_n_942, "rx"), "t"), 0.0, ">=") if J.t(_t352) else _t352)) else null)
	var _t353 = (not J.t(J.gp(v_n_942, "fleeing")))
	var _t354 = ((not J.t(J.gp(v_n_942, "gone"))) if _t353 else _t353)
	var _t357 = (J.cmp(J.gp(v_n_942, "fear"), 25.0, "<") if _t354 else _t354)
	if J.t(_t357):
		var _t355 = (not J.t(v_rx_946))
		var _t356 = (_t355 if _t355 else J.seq(J.gp(v_rx_946, "k"), "numb"))
		_t357 = (_t356 if _t356 else J.seq(J.gp(v_rx_946, "k"), "sip"))
	v_calm_947 = _t357
	v_walk_948 = J.seq(J.gp(v_n_942, "act"), "walk")
	var _t358 = (J.seq(J.gp(v_rx_946, "k"), "sip") if J.t(v_rx_946) else v_rx_946)
	v_force_949 = (["town_guard_sip", J.max_([3.3, J.add(J.gp(v_rx_946, "dur"), 0.4)])] if J.t((J.seq(J.gp(v_d_945, "spr"), "npc_guard") if J.t(_t358) else _t358)) else null)
	var _t359 = (not J.t(v_force_949))
	var _t360 = ((not J.t(v_walk_948)) if _t359 else _t359)
	var _t361 = (J.gp(env["ACT"], J.gp(v_d_945, "spr")) if _t360 else _t360)
	v_fa_950 = (J.gp(J.gp(env["ACT"], J.gp(v_d_945, "spr")), J.gp(v_n_942, "act")) if J.t(_t361) else _t361)
	if J.t(v_fa_950):
		var _t362 = [v_fa_950, (3.6 if J.seq(J.gp(v_n_942, "act"), "pack") else 1000000000.0)]
		v_force_949 = _t362
	var _t363 = env["tick"]
	var _t364 = J.cl(_t363, null, [J.gp(v_n_942, "daily"), J.gp(v_d_945, "spr"), v_dt_943, v_calm_947, v_walk_948, v_force_949])
	J.sp(v_n_942, "daily", _t364)

func _f2(this_, a: Array, env):
	var v_v_69 = null; var v_a_70 = null; var v_b_71 = null
	v_v_69 = J.arg(a, 0)
	var _t365 = J.arg(a, 1)
	if _t365 == null:
		_t365 = 0.0
	v_a_70 = _t365
	var _t366 = J.arg(a, 2)
	if _t366 == null:
		_t366 = 1.0
	v_b_71 = _t366
	return (v_a_70 if J.cmp(v_v_69, v_a_70, "<") else (v_b_71 if J.cmp(v_v_69, v_b_71, ">") else v_v_69))

func _f3(this_, a: Array, env):
	var v_a_72 = null; var v_b_73 = null; var v_k_74 = null
	v_a_72 = J.arg(a, 0)
	v_b_73 = J.arg(a, 1)
	v_k_74 = J.arg(a, 2)
	return J.add(v_a_72, J.mul(J.sub(v_b_73, v_a_72), v_k_74))

func _f4(this_, a: Array, env):
	var v_t_75 = null
	v_t_75 = J.arg(a, 0)
	var _t367 = env["cl"]
	var _t368 = J.cl(_t367, null, [v_t_75])
	v_t_75 = _t368
	return (J.mul(v_t_75, v_t_75) * (3.0 - J.mul(2.0, v_t_75)))

func _f5(this_, a: Array, env):
	var v_t_76 = null; var v_a_77 = null; var v_b_78 = null
	v_t_76 = J.arg(a, 0)
	v_a_77 = J.arg(a, 1)
	v_b_78 = J.arg(a, 2)
	var _t369 = env["cl"]
	return J.cl(_t369, null, [J.div(J.sub(v_t_76, v_a_77), J.sub(v_b_78, v_a_77))])

func _f6(this_, a: Array, env):
	var v_t_79 = null
	v_t_79 = J.arg(a, 0)
	var _t370 = env["cl"]
	var _t372 = J.sub(1.0, J.cl(_t370, null, [v_t_79]))
	var _t371 = env["cl"]
	return (1.0 - (_t372 * J.sub(1.0, J.cl(_t371, null, [v_t_79]))))

func _f7(this_, a: Array, env):
	var v_t_80 = null
	v_t_80 = J.arg(a, 0)
	var _t373 = env["cl"]
	return (1.0 - pow(J.num(J.sub(1.0, J.cl(_t373, null, [v_t_80]))), J.num(3.0)))

func _f8(this_, a: Array, env):
	var v_t_81 = null; var v_a_82 = null; var v_m_83 = null; var v_b_84 = null
	v_t_81 = J.arg(a, 0)
	v_a_82 = J.arg(a, 1)
	v_m_83 = J.arg(a, 2)
	v_b_84 = J.arg(a, 3)
	var _t374 = J.cmp(v_t_81, v_a_82, "<=")
	var _t378 = null
	if (_t374 if _t374 else J.cmp(v_t_81, v_b_84, ">=")):
		_t378 = 0.0
	else:
		var _t377 = null
		if J.cmp(v_t_81, v_m_83, "<"):
			var _t375 = env["ss"]
			_t377 = J.cl(_t375, null, [J.div(J.sub(v_t_81, v_a_82), J.sub(v_m_83, v_a_82))])
		else:
			var _t376 = env["ss"]
			_t377 = J.sub(1.0, J.cl(_t376, null, [J.div(J.sub(v_t_81, v_m_83), J.sub(v_b_84, v_m_83))]))
		_t378 = _t377
	return _t378

func _f9(this_, a: Array, env):
	var v_K_85 = null; var v_t_86 = null; var v_i_87 = null; var v_a_88 = null; var v_b_89 = null; var v_q_90 = null
	v_K_85 = J.arg(a, 0)
	v_t_86 = J.arg(a, 1)
	if J.cmp(v_t_86, J.gp(J.gp(v_K_85, 0.0), 0.0), "<="):
		return J.gp(J.gp(v_K_85, 0.0), 1.0)
	v_i_87 = 1.0
	while true:
		if not J.cmp(v_i_87, J.len(v_K_85), "<"): break
		if J.cmp(v_t_86, J.gp(J.gp(v_K_85, v_i_87), 0.0), "<="):
			v_a_88 = J.gp(v_K_85, J.sub(v_i_87, 1.0))
			v_b_89 = J.gp(v_K_85, v_i_87)
			v_q_90 = J.div(J.sub(v_t_86, J.gp(v_a_88, 0.0)), J.sub(J.gp(v_b_89, 0.0), J.gp(v_a_88, 0.0)))
			return J.add(J.gp(v_a_88, 1.0), (J.sub(J.gp(v_b_89, 1.0), J.gp(v_a_88, 1.0)) * (0.5 - (0.5 * cos(J.num(J.mul(env["PI"], v_q_90)))))))
		v_i_87 = J.num(v_i_87) + 1.0
	return J.gp(J.gp(v_K_85, (J.len(v_K_85) - 1.0)), 1.0)

func _f10(this_, a: Array, env):
	var v_s_91 = null; var v_x_92 = null
	v_s_91 = J.arg(a, 0)
	v_x_92 = (sin(J.num((J.mul(v_s_91, 127.1) + 311.7))) * 43758.5453)
	return J.sub(v_x_92, floor(J.num(v_x_92)))

func _f11(this_, a: Array, env):
	var v_k_93 = null
	v_k_93 = J.arg(a, 0)
	var _t380 = J.seq(J.typeof_(J.G.get("sprOk")), "function")
	if J.t(_t380):
		var _t379 = J.G.get("sprOk")
		_t380 = J.cl(_t379, null, [v_k_93])
	return _t380

func _f14(this_, a: Array, env):
	var v_S_114 = null
	v_S_114 = J.arg(a, 0)
	return J.mc(J.gp(v_S_114, "ctx"), "restore", [])

func _f21(this_, a: Array, env):
	var v_S_161 = null; var v_pu_162 = null; var v_pv_163 = null; var v_at_164 = null; var v_ang_165 = null; var v_u_166 = null; var v_v_167 = null; var v_x_168 = null; var v_y_169 = null; var v_c_170 = null; var v_s_171 = null
	v_S_161 = J.arg(a, 0)
	v_pu_162 = J.arg(a, 1)
	v_pv_163 = J.arg(a, 2)
	v_at_164 = J.arg(a, 3)
	v_ang_165 = J.arg(a, 4)
	v_u_166 = J.arg(a, 5)
	v_v_167 = J.arg(a, 6)
	v_x_168 = J.mul(J.sub(v_u_166, v_pu_162), J.gp(v_S_161, "W"))
	v_y_169 = J.mul(J.sub(v_v_167, v_pv_163), J.gp(v_S_161, "H"))
	v_c_170 = cos(J.num(v_ang_165))
	v_s_171 = sin(J.num(v_ang_165))
	return [J.sub(J.add(J.gp(v_at_164, 0.0), J.mul(v_x_168, v_c_170)), J.mul(v_y_169, v_s_171)), J.add(J.add(J.gp(v_at_164, 1.0), J.mul(v_x_168, v_s_171)), J.mul(v_y_169, v_c_170))]

func _f34(this_, a: Array, env):
	var v_S_271 = null; var v_P_272 = null; var v_l_273 = null; var v_p_274 = null; var v_r_275 = null; var v_cs_276 = null; var v_sn_277 = null
	v_S_271 = J.arg(a, 0)
	v_P_272 = J.arg(a, 1)
	var _t381 = J.gp(v_P_272, "lean")
	v_l_273 = (_t381 if J.t(_t381) else 0.0)
	v_p_274 = J.mc(v_S_271, "P", [0.4, 0.33])
	v_r_275 = [J.gp(v_p_274, 0.0), J.add(J.gp(v_p_274, 1.0), J.mul(J.gp(v_S_271, "H"), 0.35))]
	v_cs_276 = cos(J.num(v_l_273))
	v_sn_277 = sin(J.num(v_l_273))
	return [(J.mul(J.gp(v_r_275, 0.0), v_cs_276) - J.mul(J.gp(v_r_275, 1.0), v_sn_277)), ((J.mul(J.gp(v_r_275, 0.0), v_sn_277) + J.mul(J.gp(v_r_275, 1.0), v_cs_276)) - J.mul(J.gp(v_S_271, "H"), 0.35))]

func _f35(this_, a: Array, env):
	var v_ctx_280 = null; var v_a_281 = null; var v_S_282 = null; var v_k_283 = null; var v_q_284 = null; var v_fl_285 = null; var v_h_286 = null
	v_ctx_280 = J.arg(a, 0)
	v_a_281 = J.arg(a, 1)
	var _t383 = env["begin"]
	v_S_282 = J.cl(_t383, null, [v_ctx_280, v_a_281, "npc_ken__bodyF", false])
	if (not J.t(v_S_282)):
		return false
	v_k_283 = J.gp(v_S_282, "env")
	v_q_284 = J.div(J.mod(J.gp(v_S_282, "at"), 1.1), 1.1)
	var _t384 = env["bump"]
	v_fl_285 = J.cl(_t384, null, [v_q_284, 0.55, 0.66, 0.85])
	var _t385 = env["kenDraw"]
	J.cl(_t385, null, [v_S_282, {"ang": J.mul(v_k_283, (J.mul(0.035, v_fl_285) + (0.01 * sin(J.num(J.mul(J.gp(v_S_282, "at"), 1.7)))))), "head": (J.mul(v_k_283, J.gp(v_S_282, "fs")) * (0.05 + J.mul(0.02, v_fl_285))), "lean": (J.mul(v_k_283, J.gp(v_S_282, "fs")) * 0.02)}])
	if J.cmp(v_fl_285, 0.2, ">"):
		v_h_286 = J.mc(v_S_282, "P", [0.3, 0.445])
		J.mc(v_ctx_280, "save", [])
		var _t386 = J.mul(J.gp(v_ctx_280, "globalAlpha"), (J.mul(v_k_283, v_fl_285) * 0.7))
		J.sp(v_ctx_280, "globalAlpha", _t386)
		var _t387 = env["crayon"]
		J.cl(_t387, null, [v_ctx_280, [[J.sub(J.gp(v_h_286, 0.0), J.mul(J.gp(v_S_282, "W"), 0.05)), J.add(J.gp(v_h_286, 1.0), J.mul(J.gp(v_S_282, "H"), 0.012))], [J.gp(v_h_286, 0.0), J.sub(J.gp(v_h_286, 1.0), J.mul(J.gp(v_S_282, "H"), 0.004))], [J.add(J.gp(v_h_286, 0.0), J.mul(J.gp(v_S_282, "W"), 0.04)), J.sub(J.gp(v_h_286, 1.0), J.mul(J.gp(v_S_282, "H"), 0.02))]], J.max_([1.0, J.mul(J.gp(v_S_282, "H"), 0.008)]), "rgba(255,255,255,.9)"])
		J.mc(v_ctx_280, "restore", [])
	var _t388 = env["end"]
	J.cl(_t388, null, [v_S_282])
	return true

func _f36(this_, a: Array, env):
	var v_ctx_289 = null; var v_a_290 = null; var v_S_291 = null; var v_t_292 = null; var v_k_293 = null; var v_up_294 = null; var v_back_295 = null; var v_sy_296 = null; var v_f_297 = null; var v_hk_298 = null; var v_tk_299 = null; var v_e_300 = null
	v_ctx_289 = J.arg(a, 0)
	v_a_290 = J.arg(a, 1)
	var _t391 = env["begin"]
	v_S_291 = J.cl(_t391, null, [v_ctx_289, v_a_290, "npc_ken__bodyF", false])
	if (not J.t(v_S_291)):
		return false
	v_t_292 = J.gp(v_S_291, "at")
	v_k_293 = J.gp(v_S_291, "env")
	var _t392 = env["kf"]
	v_up_294 = J.cl(_t392, null, [[[0.0, 0.0], [0.7, 1.0], [2.2, 1.0], [2.8, 0.0]], v_t_292])
	var _t393 = env["kf"]
	v_back_295 = J.cl(_t393, null, [[[0.0, 0.0], [0.5, 0.3], [0.9, 1.0], [2.0, 1.0], [2.6, 0.0], [2.9, (-0.25)], [3.2, 0.0]], v_t_292])
	var _t394 = env["kf"]
	v_sy_296 = (1.0 + J.mul(J.mul(0.045, J.cl(_t394, null, [[[0.0, 0.0], [0.6, 1.0], [1.9, 1.15], [2.6, 0.0], [2.9, (-0.3)], [3.3, 0.0]], v_t_292])), v_k_293))
	J.mc(v_ctx_289, "save", [])
	J.mc(v_ctx_289, "scale", [J.div(1.0, sqrt(J.num(v_sy_296))), v_sy_296])
	var _t395 = env["kenDraw"]
	var _t401 = (J.mul(v_k_293, v_up_294) * 0.62)
	var _t402 = (J.mul(v_k_293, v_up_294) * 0.035)
	var _t403 = (J.mul(v_k_293, v_up_294) * 0.02)
	var _t404 = (1.0 + J.mul(J.mul(0.05, v_up_294), v_k_293))
	var _t400 = (J.mul(J.mul((-J.num(J.gp(v_S_291, "fs"))), v_k_293), v_back_295) * 0.16)
	var _t397 = ((J.mul(J.gp(v_S_291, "fs"), v_k_293) * 0.05) * sin(J.num((J.max_([0.0, J.sub(v_t_292, 2.6)]) * 18.0))))
	var _t396 = env["seg"]
	var _t399 = J.mul(_t397, J.cl(_t396, null, [v_t_292, 2.6, 2.75]))
	var _t398 = env["seg"]
	J.cl(_t395, null, [v_S_291, {"ang": _t401, "lift": _t402, "fx": _t403, "sc": _t404, "head": (_t400 + (_t399 * J.sub(1.0, J.cl(_t398, null, [v_t_292, 2.95, 3.2])))), "lean": (J.mul(J.mul((-J.num(J.gp(v_S_291, "fs"))), v_k_293), v_back_295) * 0.03)}])
	J.mc(v_ctx_289, "restore", [])
	var _t405 = env["kenFace"]
	v_f_297 = J.cl(_t405, null, [v_S_291, {}])
	var _t406 = env["bump"]
	v_hk_298 = J.mul(J.cl(_t406, null, [v_t_292, 0.6, 1.0, 2.3]), v_k_293)
	var _t407 = env["text"]
	J.cl(_t407, null, [v_S_291, J.sub(J.gp(v_f_297, 0.0), (J.mul(J.gp(v_S_291, "fs"), J.gp(v_S_291, "H")) * 0.32)), (J.sub(J.gp(v_f_297, 1.0), J.mul(J.gp(v_S_291, "H"), 0.25)) - (J.mul(v_hk_298, J.gp(v_S_291, "H")) * 0.04)), "哈～", J.mul(J.gp(v_S_291, "H"), 0.11), v_hk_298, {"rot": (-0.1)}])
	var _t408 = env["bump"]
	v_tk_299 = J.mul(J.cl(_t408, null, [v_t_292, 1.2, 1.6, 2.8]), v_k_293)
	if J.cmp(v_tk_299, 0.0, ">"):
		v_e_300 = J.mc(v_S_291, "P", [0.25, 0.33])
		J.mc(v_ctx_289, "save", [])
		var _t409 = J.mul(J.gp(v_ctx_289, "globalAlpha"), v_tk_299)
		J.sp(v_ctx_289, "globalAlpha", _t409)
		J.sp(v_ctx_289, "fillStyle", "rgba(170,220,255,.95)")
		J.sp(v_ctx_289, "strokeStyle", "rgba(40,70,110,.6)")
		J.sp(v_ctx_289, "lineWidth", 1.0)
		J.mc(v_ctx_289, "beginPath", [])
		J.mc(v_ctx_289, "ellipse", [J.gp(v_e_300, 0.0), J.add(J.gp(v_e_300, 1.0), (J.mul(v_tk_299, J.gp(v_S_291, "H")) * 0.01)), J.mul(J.gp(v_S_291, "H"), 0.008), J.mul(J.gp(v_S_291, "H"), 0.012), 0.0, 0.0, J.mul(env["PI"], 2.0)])
		J.mc(v_ctx_289, "fill", [])
		J.mc(v_ctx_289, "stroke", [])
		J.mc(v_ctx_289, "restore", [])
	var _t410 = env["end"]
	J.cl(_t410, null, [v_S_291])
	return true

func _f37(this_, a: Array, env):
	var v_ctx_303 = null; var v_a_304 = null; var v_S_305 = null; var v_t_306 = null; var v_k_307 = null; var v_up_308 = null; var v_rb_309 = null; var v_wig_310 = null
	v_ctx_303 = J.arg(a, 0)
	v_a_304 = J.arg(a, 1)
	var _t413 = env["begin"]
	v_S_305 = J.cl(_t413, null, [v_ctx_303, v_a_304, "npc_ken__bodyF", false])
	if (not J.t(v_S_305)):
		return false
	v_t_306 = J.gp(v_S_305, "at")
	v_k_307 = J.gp(v_S_305, "env")
	var _t414 = env["kf"]
	v_up_308 = J.cl(_t414, null, [[[0.0, 0.0], [0.6, 1.0], [2.2, 1.0], [2.8, 0.0]], v_t_306])
	var _t415 = env["seg"]
	var _t417 = J.cl(_t415, null, [v_t_306, 0.6, 2.2])
	var _t416 = env["seg"]
	v_rb_309 = J.mul(_t417, J.sub(1.0, J.cl(_t416, null, [v_t_306, 2.1, 2.3])))
	v_wig_310 = J.mul(sin(J.num(J.mul(v_t_306, 15.0))), v_rb_309)
	var _t418 = env["kenDraw"]
	J.cl(_t418, null, [v_S_305, {"ang": J.mul(v_k_307, (J.mul(v_up_308, 0.8) + J.mul(v_wig_310, 0.035))), "lift": J.mul(v_k_307, (J.mul(v_up_308, 0.1) + (J.mul(cos(J.num(J.mul(v_t_306, 15.0))), v_rb_309) * 0.006))), "fx": (J.mul(v_k_307, v_up_308) * 0.03), "sc": (1.0 + J.mul(J.mul(0.06, v_up_308), v_k_307)), "head": (J.mul(J.mul(J.gp(v_S_305, "fs"), v_k_307), v_up_308) * 0.09), "lean": (J.mul(J.mul(J.gp(v_S_305, "fs"), v_k_307), v_up_308) * 0.025)}])
	var _t419 = env["end"]
	J.cl(_t419, null, [v_S_305])
	return true

func _f38(this_, a: Array, env):
	var v_ctx_313 = null; var v_a_314 = null; var v_S_315 = null; var v_t_316 = null; var v_k_317 = null; var v_inh_318 = null; var v_f_319 = null
	v_ctx_313 = J.arg(a, 0)
	v_a_314 = J.arg(a, 1)
	var _t422 = env["begin"]
	v_S_315 = J.cl(_t422, null, [v_ctx_313, v_a_314, "npc_ken__bodyF", false])
	if (not J.t(v_S_315)):
		return false
	v_t_316 = J.gp(v_S_315, "at")
	v_k_317 = J.gp(v_S_315, "env")
	var _t423 = env["kf"]
	v_inh_318 = J.cl(_t423, null, [[[0.0, 0.0], [0.7, 1.0], [1.0, 1.0], [1.5, (-0.6)], [2.6, (-0.5)], [3.0, 0.0]], v_t_316])
	J.mc(v_ctx_313, "save", [])
	J.mc(v_ctx_313, "scale", [1.0, (1.0 + J.mul(J.mul(0.03, v_inh_318), v_k_317))])
	var _t424 = env["kenDraw"]
	J.cl(_t424, null, [v_S_315, {"ang": J.mul(v_k_317, J.mul(0.05, v_inh_318)), "head": (J.mul(J.gp(v_S_315, "fs"), v_k_317) * (((-0.05) * J.max_([0.0, v_inh_318])) + (0.14 * J.max_([0.0, (-J.num(v_inh_318))])))), "lean": ((J.mul(J.gp(v_S_315, "fs"), v_k_317) * 0.03) * J.max_([0.0, (-J.num(v_inh_318))]))}])
	J.mc(v_ctx_313, "restore", [])
	var _t425 = env["kenFace"]
	v_f_319 = J.cl(_t425, null, [v_S_315, {}])
	var _t426 = env["puff"]
	var _t428 = J.add(J.gp(v_f_319, 0.0), (J.mul(J.gp(v_S_315, "fs"), J.gp(v_S_315, "H")) * 0.04))
	var _t429 = J.add(J.gp(v_f_319, 1.0), J.mul(J.gp(v_S_315, "H"), 0.06))
	var _t430 = J.mul(J.gp(v_S_315, "H"), 0.05)
	var _t427 = env["seg"]
	J.cl(_t426, null, [v_ctx_313, _t428, _t429, _t430, J.cl(_t427, null, [v_t_316, 1.0, 2.2]), 3.1])
	var _t431 = env["text"]
	var _t433 = J.sub(J.gp(v_f_319, 0.0), (J.mul(J.gp(v_S_315, "fs"), J.gp(v_S_315, "H")) * 0.3))
	var _t434 = J.sub(J.gp(v_f_319, 1.0), J.mul(J.gp(v_S_315, "H"), 0.22))
	var _t435 = J.mul(J.gp(v_S_315, "H"), 0.1)
	var _t432 = env["bump"]
	J.cl(_t431, null, [v_S_315, _t433, _t434, "唉……", _t435, J.mul(J.cl(_t432, null, [v_t_316, 1.0, 1.4, 2.6]), v_k_317), {"col": "#cfd8ff", "out": "#1e2238"}])
	var _t436 = env["end"]
	J.cl(_t436, null, [v_S_315])
	return true

func _f42(this_, a: Array, env):
	var v_L_340 = null; var v_p_341 = null; var v_fog_342 = null; var v_r_343 = null; var v_an_344 = null
	v_L_340 = J.arg(a, 0)
	v_p_341 = J.cl(v_L_340, null, J.spread([J.SP(J.gp(env["__p"]["BOSS"], "BALL"))]))
	var _t450 = [J.gp(v_p_341, 0.0), J.gp(v_p_341, 1.0)]
	env["ballPos"] = _t450
	var _t451 = env["__p"]["bump"]
	v_fog_342 = J.mul(J.cl(_t451, null, [env["t"], 0.9, 1.25, 2.4]), env["k"])
	if J.cmp(v_fog_342, 0.0, ">"):
		J.mc(env["ctx"], "save", [])
		var _t452 = env["ctx"]
		var _t453 = J.mul(J.gp(_t452, "globalAlpha"), J.mul(v_fog_342, 0.55))
		J.sp(_t452, "globalAlpha", _t453)
		var _t454 = env["ctx"]
		J.sp(_t454, "fillStyle", "rgba(235,240,250,.9)")
		J.mc(env["ctx"], "beginPath", [])
		J.mc(env["ctx"], "arc", [J.gp(v_p_341, 0.0), J.gp(v_p_341, 1.0), J.mul(J.gp(env["S"], "W"), 0.1), 0.0, J.mul(env["__p"]["PI"], 2.0)])
		J.mc(env["ctx"], "fill", [])
		J.mc(env["ctx"], "restore", [])
	if J.cmp(env["rub"], 0.0, ">"):
		J.mc(env["ctx"], "save", [])
		var _t455 = env["ctx"]
		var _t456 = J.mul(J.gp(_t455, "globalAlpha"), (J.mul(env["rub"], env["k"]) * 0.8))
		J.sp(_t455, "globalAlpha", _t456)
		v_r_343 = J.mul(J.gp(env["S"], "W"), 0.07)
		v_an_344 = J.mul(env["t"], 13.0)
		var _t457 = env["__p"]["crayon"]
		J.cl(_t457, null, [env["ctx"], [[J.add(J.gp(v_p_341, 0.0), J.mul(cos(J.num(v_an_344)), v_r_343)), J.add(J.gp(v_p_341, 1.0), (J.mul(sin(J.num(v_an_344)), v_r_343) * 0.7))], [J.add(J.gp(v_p_341, 0.0), J.mul(cos(J.num(J.add(v_an_344, 0.9))), v_r_343)), J.add(J.gp(v_p_341, 1.0), (J.mul(sin(J.num(J.add(v_an_344, 0.9))), v_r_343) * 0.7))]], J.max_([1.0, J.mul(J.gp(env["S"], "H"), 0.008)]), "rgba(255,255,255,.9)"])
		J.mc(env["ctx"], "restore", [])
	var _t458 = env["__p"]["sparkle"]
	var _t460 = env["ctx"]
	var _t461 = J.add(J.gp(v_p_341, 0.0), J.mul(J.gp(env["S"], "W"), 0.04))
	var _t462 = J.sub(J.gp(v_p_341, 1.0), J.mul(J.gp(env["S"], "W"), 0.05))
	var _t463 = J.mul(J.gp(env["S"], "H"), 0.05)
	var _t459 = env["__p"]["bump"]
	J.cl(_t458, null, [_t460, _t461, _t462, _t463, J.mul(J.cl(_t459, null, [env["t"], 2.75, 2.9, 3.4]), env["k"])])

func _f41(this_, a: Array, env):
	var v_a_332 = null; var v_near_336 = null; var v_m_339 = null
	var _s61 = {"__p": env, "ctx": null, "S": null, "t": null, "k": null, "rub": null, "ballPos": null}
	_s61["ctx"] = J.arg(a, 0)
	v_a_332 = J.arg(a, 1)
	var _t439 = _s61["__p"]["begin"]
	_s61["S"] = J.cl(_t439, null, [_s61["ctx"], v_a_332, "npc_boss__bodyN", false])
	if (not J.t(_s61["S"])):
		return false
	_s61["t"] = J.gp(_s61["S"], "at")
	_s61["k"] = J.gp(_s61["S"], "env")
	var _t440 = _s61["__p"]["kf"]
	v_near_336 = J.cl(_t440, null, [[[0.0, 0.0], [0.6, 1.0], [3.1, 1.0], [3.6, 0.0]], _s61["t"]])
	var _t441 = _s61["__p"]["seg"]
	var _t443 = J.cl(_t441, null, [_s61["t"], 1.3, 2.7])
	var _t442 = _s61["__p"]["seg"]
	_s61["rub"] = J.mul(_t443, J.sub(1.0, J.cl(_t442, null, [_s61["t"], 2.6, 2.8])))
	_s61["ballPos"] = null
	var _t444 = _s61["__p"]["bossDraw"]
	var _t464 = _s61["S"]
	var _t448 = J.mul(_s61["k"], (J.mul(v_near_336, 0.13) + J.mul((sin(J.num(J.mul(_s61["t"], 13.0))) * 0.03), _s61["rub"])))
	var _t449 = (J.mul(_s61["k"], v_near_336) * 0.015)
	var _t447 = J.mul(J.gp(_s61["S"], "fs"), _s61["k"])
	var _t446 = J.mul(v_near_336, 0.1)
	var _t445 = _s61["__p"]["bump"]
	J.cl(_t444, null, [_t464, {"ball": _t448, "elUp": _t449, "head": (_t447 * (_t446 - J.mul(0.06, J.cl(_t445, null, [_s61["t"], 2.9, 3.1, 3.4])))), "lean": (J.mul(J.mul(J.gp(_s61["S"], "fs"), _s61["k"]), v_near_336) * 0.025), "bfn": Callable(self, "_f42").bind(_s61)}])
	v_m_339 = J.mc(_s61["S"], "P", J.spread([J.SP(J.gp(_s61["__p"]["BOSS"], "MOUTH"))]))
	var _t465 = _s61["__p"]["puff"]
	var _t470 = _s61["ctx"]
	var _t466 = _s61["__p"]["lerp"]
	var _t468 = J.gp(v_m_339, 0.0)
	var _t469 = J.add(J.gp(v_m_339, 0.0), (J.mul(J.gp(_s61["S"], "fs"), J.gp(_s61["S"], "W")) * 0.12))
	var _t467 = _s61["__p"]["seg"]
	var _t472 = J.cl(_t466, null, [_t468, _t469, J.cl(_t467, null, [_s61["t"], 0.75, 1.2])])
	var _t473 = J.gp(v_m_339, 1.0)
	var _t474 = J.mul(J.gp(_s61["S"], "H"), 0.035)
	var _t471 = _s61["__p"]["seg"]
	J.cl(_t465, null, [_t470, _t472, _t473, _t474, J.cl(_t471, null, [_s61["t"], 0.7, 1.3]), 7.7])
	var _t475 = _s61["__p"]["text"]
	var _t477 = _s61["S"]
	var _t478 = J.sub(J.gp(v_m_339, 0.0), (J.mul(J.gp(_s61["S"], "fs"), J.gp(_s61["S"], "W")) * 0.3))
	var _t479 = J.sub(J.gp(v_m_339, 1.0), J.mul(J.gp(_s61["S"], "H"), 0.17))
	var _t480 = J.mul(J.gp(_s61["S"], "H"), 0.085)
	var _t476 = _s61["__p"]["bump"]
	J.cl(_t475, null, [_t477, _t478, _t479, "哈——", _t480, J.mul(J.cl(_t476, null, [_s61["t"], 0.7, 0.85, 1.3]), _s61["k"])])
	var _t481 = _s61["__p"]["end"]
	J.cl(_t481, null, [_s61["S"]])
	return true

func _f43(this_, a: Array, env):
	var v_ctx_347 = null; var v_a_348 = null; var v_S_349 = null; var v_t_350 = null; var v_k_351 = null; var v_up_352 = null; var v_flick_353 = null; var v_tap_354 = null; var v_m_355 = null
	v_ctx_347 = J.arg(a, 0)
	v_a_348 = J.arg(a, 1)
	var _t484 = env["begin"]
	v_S_349 = J.cl(_t484, null, [v_ctx_347, v_a_348, "npc_boss__bodyN", false])
	if (not J.t(v_S_349)):
		return false
	v_t_350 = J.gp(v_S_349, "at")
	v_k_351 = J.gp(v_S_349, "env")
	var _t485 = env["kf"]
	v_up_352 = J.cl(_t485, null, [[[0.0, 0.0], [0.5, 1.0], [2.2, 1.0], [2.7, 0.0]], v_t_350])
	var _t487 = sin(J.num((J.max_([0.0, J.sub(v_t_350, 0.5)]) * 30.0)))
	var _t486 = env["bump"]
	v_flick_353 = J.mul(_t487, J.cl(_t486, null, [v_t_350, 0.5, 0.55, 0.75]))
	var _t489 = J.max_([0.0, sin(J.num(J.mul(v_t_350, 9.0)))])
	var _t488 = env["seg"]
	var _t491 = J.mul(_t489, J.cl(_t488, null, [v_t_350, 1.2, 1.4]))
	var _t490 = env["seg"]
	v_tap_354 = (_t491 * J.sub(1.0, J.cl(_t490, null, [v_t_350, 2.3, 2.5])))
	var _t492 = env["bossDraw"]
	J.cl(_t492, null, [v_S_349, {"glove": J.mul(v_k_351, (J.mul(v_up_352, 1.45) + J.mul(v_flick_353, 0.05))), "shUp": (J.mul(v_k_351, v_up_352) * 0.01), "head": (J.mul(J.mul(J.gp(v_S_349, "fs"), v_k_351), v_up_352) * 0.16), "lean": (J.mul(J.mul(J.gp(v_S_349, "fs"), v_k_351), v_up_352) * 0.02), "legF": ((J.mul(v_k_351, v_tap_354) * 0.12) * (-J.num(J.gp(v_S_349, "fs"))))}])
	v_m_355 = J.mc(v_S_349, "P", [0.5, 0.0])
	var _t493 = env["text"]
	var _t495 = J.sub(J.gp(v_m_355, 0.0), (J.mul(J.gp(v_S_349, "fs"), J.gp(v_S_349, "W")) * 0.42))
	var _t496 = J.add(J.gp(v_m_355, 1.0), J.mul(J.gp(v_S_349, "H"), 0.04))
	var _t497 = J.mul(J.gp(v_S_349, "H"), 0.11)
	var _t494 = env["bump"]
	J.cl(_t493, null, [v_S_349, _t495, _t496, "嘖", _t497, J.mul(J.cl(_t494, null, [v_t_350, 1.4, 1.6, 2.3]), v_k_351)])
	var _t498 = env["end"]
	J.cl(_t498, null, [v_S_349])
	return true

func _f45(this_, a: Array, env):
	var v_L_370 = null; var v_p_371 = null
	v_L_370 = J.arg(a, 0)
	v_p_371 = J.cl(v_L_370, null, J.spread([J.SP(J.gp(env["__p"]["BOSS"], "HAND"))]))
	var _t507 = env["__p"]["prop"]
	J.cl(_t507, null, [env["ctx"], "afu__phone", J.add(J.gp(v_p_371, 0.0), (J.mul(J.gp(env["S"], "fs"), J.gp(env["S"], "W")) * 0.02)), J.sub(J.gp(v_p_371, 1.0), J.mul(J.gp(env["S"], "H"), 0.04)), (J.mul(J.mul(J.mul(J.gp(env["S"], "H"), 0.14), env["up"]), env["k"]) + 0.0001), (((-J.num(J.gp(env["S"], "fs"))) * 0.3) - J.mul(J.mul(env["up"], 1.75), env["k"])), 0.5, 0.6, (-J.num(J.gp(env["S"], "fs"))), 1.0])

func _f44(this_, a: Array, env):
	var v_a_359 = null; var v_t_361 = null; var v_yell_364 = null; var v_jab_365 = null; var v_sh_366 = null; var v_m_367 = null; var v_words_368 = null; var v_wi_369 = null
	var _s66 = {"__p": env, "ctx": null, "S": null, "k": null, "up": null}
	_s66["ctx"] = J.arg(a, 0)
	v_a_359 = J.arg(a, 1)
	var _t501 = _s66["__p"]["begin"]
	_s66["S"] = J.cl(_t501, null, [_s66["ctx"], v_a_359, "npc_boss__bodyN", false])
	if (not J.t(_s66["S"])):
		return false
	v_t_361 = J.gp(_s66["S"], "at")
	_s66["k"] = J.gp(_s66["S"], "env")
	var _t502 = _s66["__p"]["kf"]
	_s66["up"] = J.cl(_t502, null, [[[0.0, 0.0], [0.5, 1.0], [3.4, 1.0], [3.9, 0.0]], v_t_361])
	var _t503 = _s66["__p"]["seg"]
	var _t505 = J.cl(_t503, null, [v_t_361, 0.8, 1.0])
	var _t504 = _s66["__p"]["seg"]
	v_yell_364 = J.mul(_t505, J.sub(1.0, J.cl(_t504, null, [v_t_361, 3.2, 3.5])))
	v_jab_365 = J.mul(J.max_([0.0, sin(J.num(J.mul(v_t_361, 7.5)))]), v_yell_364)
	v_sh_366 = J.mul((sin(J.num(J.mul(v_t_361, 40.0))) * 0.008), v_yell_364)
	var _t506 = _s66["__p"]["bossDraw"]
	J.cl(_t506, null, [_s66["S"], {"glove": J.mul(_s66["k"], (J.mul(_s66["up"], 1.75) + J.mul(v_jab_365, 0.06))), "shUp": (J.mul(_s66["k"], _s66["up"]) * 0.03), "head": J.add((J.mul(J.gp(_s66["S"], "fs"), _s66["k"]) * (J.mul(_s66["up"], 0.06) + J.mul(v_jab_365, 0.08))), v_sh_366), "lean": (J.mul(J.gp(_s66["S"], "fs"), _s66["k"]) * J.mul(v_jab_365, 0.04)), "dx": (J.mul(J.mul(J.mul(J.gp(_s66["S"], "fs"), _s66["k"]), v_jab_365), J.gp(_s66["S"], "H")) * 0.01), "gfn": Callable(self, "_f45").bind(_s66)}])
	v_m_367 = J.mc(_s66["S"], "P", J.spread([J.SP(J.gp(_s66["__p"]["BOSS"], "MOUTH"))]))
	v_words_368 = ["喂？！", "我不管！", "明天交！"]
	v_wi_369 = J.min_([2.0, floor(J.num(J.div(J.max_([0.0, J.sub(v_t_361, 0.9)]), 0.85)))])
	var _t508 = _s66["__p"]["text"]
	J.cl(_t508, null, [_s66["S"], J.add(J.gp(v_m_367, 0.0), (J.mul(J.gp(_s66["S"], "fs"), J.gp(_s66["S"], "W")) * 0.55)), (J.sub(J.gp(v_m_367, 1.0), J.mul(J.gp(_s66["S"], "H"), 0.3)) - (J.mul(v_jab_365, J.gp(_s66["S"], "H")) * 0.02)), J.gp(v_words_368, v_wi_369), J.mul(J.gp(_s66["S"], "H"), 0.1), J.mul(v_yell_364, _s66["k"]), {"col": "#ffe0d8", "rot": (-0.08)}])
	var _t509 = _s66["__p"]["anger"]
	J.cl(_t509, null, [_s66["ctx"], J.gp(J.mc(_s66["S"], "P", [0.66, 0.08]), 0.0), J.gp(J.mc(_s66["S"], "P", [0.66, 0.08]), 1.0), J.mul(J.gp(_s66["S"], "H"), 0.07), (J.mul(v_yell_364, _s66["k"]) * (0.8 + (0.2 * sin(J.num(J.mul(v_t_361, 12.0))))))])
	var _t510 = _s66["__p"]["end"]
	J.cl(_t510, null, [_s66["S"]])
	return true

func _f46(this_, a: Array, env):
	var v_ctx_374 = null; var v_a_375 = null; var v_S_376 = null; var v_t_377 = null; var v_k_378 = null
	v_ctx_374 = J.arg(a, 0)
	v_a_375 = J.arg(a, 1)
	var _t513 = env["begin"]
	v_S_376 = J.cl(_t513, null, [v_ctx_374, v_a_375, "npc_boss__bodyN", false])
	if (not J.t(v_S_376)):
		return false
	v_t_377 = J.gp(v_S_376, "at")
	v_k_378 = J.gp(v_S_376, "env")
	var _t514 = env["bossDraw"]
	J.cl(_t514, null, [v_S_376, {"ball": (J.mul(v_k_378, sin(J.num(J.mul(v_t_377, 1.6)))) * 0.06), "head": (J.mul(J.gp(v_S_376, "fs"), v_k_378) * (0.05 + (sin(J.num((J.mul(v_t_377, 1.6) + 0.4))) * 0.025)))}])
	var _t515 = env["end"]
	J.cl(_t515, null, [v_S_376])
	return true

func _f49(this_, a: Array, env):
	var v_ctx_403 = null; var v_a_404 = null; var v_S_405 = null; var v_t_406 = null; var v_k_407 = null; var v_sw_408 = null
	v_ctx_403 = J.arg(a, 0)
	v_a_404 = J.arg(a, 1)
	var _t518 = env["begin"]
	v_S_405 = J.cl(_t518, null, [v_ctx_403, v_a_404, "npc_guard__bodyN", false])
	if (not J.t(v_S_405)):
		return false
	v_t_406 = J.gp(v_S_405, "at")
	v_k_407 = J.gp(v_S_405, "env")
	v_sw_408 = ((sin(J.num(J.mul(v_t_406, 1.9))) * 0.16) + (sin(J.num(J.mul(v_t_406, 0.7))) * 0.05))
	var _t519 = env["guardDraw"]
	J.cl(_t519, null, [v_S_405, {"fl": J.mul(v_k_407, J.add(v_sw_408, 0.04)), "head": (J.mul(J.gp(v_S_405, "fs"), v_k_407) * (((-J.num(v_sw_408)) * 0.35) + 0.02)), "arm": ((J.mul(v_k_407, sin(J.num(J.mul(J.gp(v_S_405, "t"), 7.0)))) * 0.05) * (1.0 if J.t(J.gp(v_S_405, "walk")) else 0.0))}])
	var _t520 = env["end"]
	J.cl(_t520, null, [v_S_405])
	return true

func _f52(this_, a: Array, env):
	var v_ctx_433 = null; var v_a_434 = null; var v_S_435 = null
	v_ctx_433 = J.arg(a, 0)
	v_a_434 = J.arg(a, 1)
	var _t523 = env["begin"]
	v_S_435 = J.cl(_t523, null, [v_ctx_433, v_a_434, "npc_guard__bodyN", false])
	if (not J.t(v_S_435)):
		return false
	var _t524 = env["guardSip"]
	J.cl(_t524, null, [v_S_435])
	var _t525 = env["end"]
	J.cl(_t525, null, [v_S_435])
	return true

func _f53(this_, a: Array, env):
	var v_ctx_438 = null; var v_a_439 = null; var v_S_440 = null; var v_t_441 = null; var v_k_442 = null; var v_nod_443 = null; var v_jerk_444 = null; var v_h_445 = null
	v_ctx_438 = J.arg(a, 0)
	v_a_439 = J.arg(a, 1)
	var _t528 = env["begin"]
	v_S_440 = J.cl(_t528, null, [v_ctx_438, v_a_439, "npc_guard__bodyN", false])
	if (not J.t(v_S_440)):
		return false
	v_t_441 = J.gp(v_S_440, "at")
	v_k_442 = J.gp(v_S_440, "env")
	var _t529 = env["kf"]
	v_nod_443 = J.cl(_t529, null, [[[0.0, 0.0], [1.2, 0.6], [1.5, 0.5], [2.6, 1.0], [3.2, 1.0], [3.35, (-0.25)], [3.7, 0.05], [4.2, 0.0]], v_t_441])
	var _t530 = env["bump"]
	v_jerk_444 = J.cl(_t530, null, [v_t_441, 3.2, 3.35, 3.7])
	J.mc(v_ctx_438, "save", [])
	J.mc(v_ctx_438, "scale", [1.0, (1.0 - J.mul((0.03 * J.max_([0.0, v_nod_443])), v_k_442))])
	var _t531 = env["guardDraw"]
	J.cl(_t531, null, [v_S_440, {"head": (J.mul(J.mul(J.gp(v_S_440, "fs"), v_k_442), v_nod_443) * 0.5), "lean": (J.mul(J.mul(J.gp(v_S_440, "fs"), v_k_442), v_nod_443) * 0.06), "dy": J.mul(v_k_442, ((J.mul(J.max_([0.0, v_nod_443]), J.gp(v_S_440, "H")) * 0.015) - (J.mul(v_jerk_444, J.gp(v_S_440, "H")) * 0.03))), "fl": (((-J.num(v_k_442)) * J.max_([0.0, v_nod_443])) * 0.45), "arm": (((-J.num(v_k_442)) * J.max_([0.0, v_nod_443])) * 0.06)}])
	J.mc(v_ctx_438, "restore", [])
	v_h_445 = J.mc(v_S_440, "P", [0.3, 0.12])
	var _t532 = env["zzz"]
	var _t536 = J.sub(J.gp(v_h_445, 0.0), (J.mul(J.gp(v_S_440, "fs"), J.gp(v_S_440, "W")) * 0.15))
	var _t537 = J.gp(v_h_445, 1.0)
	var _t538 = J.mul(J.gp(v_S_440, "H"), 0.09)
	var _t533 = env["seg"]
	var _t535 = J.cl(_t533, null, [v_t_441, 1.0, 1.5])
	var _t534 = env["seg"]
	J.cl(_t532, null, [v_S_440, _t536, _t537, _t538, v_t_441, J.mul(J.mul(_t535, J.sub(1.0, J.cl(_t534, null, [v_t_441, 3.1, 3.25]))), v_k_442)])
	var _t539 = env["marks"]
	J.cl(_t539, null, [v_ctx_438, J.gp(J.mc(v_S_440, "P", [0.5, 0.05]), 0.0), J.sub(J.gp(J.mc(v_S_440, "P", [0.5, 0.05]), 1.0), J.mul(J.gp(v_S_440, "H"), 0.03)), J.mul(J.gp(v_S_440, "H"), 0.09), J.mul(v_jerk_444, v_k_442)])
	var _t540 = env["end"]
	J.cl(_t540, null, [v_S_440])
	return true

func _f59(this_, a: Array, env):
	var v_th_485 = null
	v_th_485 = J.arg(a, 0)
	return J.sub(v_th_485, J.mul(J.round(J.num(J.div(v_th_485, env["PI"]))), env["PI"]))

func _f61(this_, a: Array, env):
	var v_S_504 = null; var v_down_505 = null; var v_want_506 = null; var v_th_507 = null
	v_S_504 = J.arg(a, 0)
	v_down_505 = J.arg(a, 1)
	v_want_506 = (v_down_505 if J.cmp(J.gp(v_S_504, "fs"), 0.0, ">") else J.sub(env["PI"], v_down_505))
	v_th_507 = J.sub(v_want_506, env["HEAD0"])
	while true:
		if not J.cmp(v_th_507, env["PI"], ">"): break
		var _t542 = J.sub(v_th_507, J.mul(2.0, env["PI"]))
		v_th_507 = _t542
	while true:
		if not J.cmp(v_th_507, (-J.num(env["PI"])), "<"): break
		var _t543 = J.add(v_th_507, J.mul(2.0, env["PI"]))
		v_th_507 = _t543
	return v_th_507

func _f63(this_, a: Array, env):
	var v_L_521 = null; var v_h_522 = null; var v_i_523 = null
	v_L_521 = J.arg(a, 0)
	if J.cmp(env["k"], 0.5, "<"):
		return null
	v_h_522 = J.cl(v_L_521, null, J.spread([J.SP(J.gp(env["__p"]["AU"], "HEAD"))]))
	v_i_523 = 0.0
	while true:
		if not J.cmp(v_i_523, 2.0, "<"): break
		var _t552 = env["__p"]["drop"]
		J.cl(_t552, null, [env["ctx"], J.add(J.gp(v_h_522, 0.0), (J.mul(J.sub(v_i_523, 0.5), J.gp(env["S"], "H")) * 0.05)), J.gp(v_h_522, 1.0), J.mul(J.gp(env["S"], "H"), 0.009), J.mod((J.mul(env["t"], 0.7) + J.mul(v_i_523, 0.5)), 1.0), J.mul(J.gp(env["S"], "H"), 0.04)])
		v_i_523 = J.num(v_i_523) + 1.0

func _f62(this_, a: Array, env):
	var v_a_511 = null; var v_push_515 = null; var v_q_516 = null; var v_th_517 = null; var v_fx_518 = null; var v_fy_519 = null; var v_g_520 = null
	var _s88 = {"__p": env, "ctx": null, "S": null, "t": null, "k": null}
	_s88["ctx"] = J.arg(a, 0)
	v_a_511 = J.arg(a, 1)
	var _t545 = _s88["__p"]["begin"]
	_s88["S"] = J.cl(_t545, null, [_s88["ctx"], v_a_511, "npc_auntie__bodyH", false])
	if (not J.t(_s88["S"])):
		return false
	_s88["t"] = J.gp(_s88["S"], "at")
	_s88["k"] = J.gp(_s88["S"], "env")
	v_push_515 = sin(J.num(J.mul(_s88["t"], 3.4)))
	var _t546 = _s88["__p"]["ss"]
	v_q_516 = J.cl(_t546, null, [_s88["k"]])
	var _t547 = _s88["__p"]["auTh"]
	v_th_517 = J.mul(J.cl(_t547, null, [_s88["S"], (0.62 + J.mul(v_push_515, 0.06))]), v_q_516)
	v_fx_518 = (J.mul(v_q_516, J.gp(_s88["S"], "fs")) * (0.03 + J.mul(v_push_515, 0.05)))
	v_fy_519 = J.mul(v_q_516, (0.05 - J.mul(v_push_515, 0.01)))
	if J.cmp(_s88["k"], 0.3, ">"):
		v_g_520 = J.add(J.gp(J.mc(_s88["S"], "P", J.spread([J.SP(J.gp(_s88["__p"]["AU"], "FIST"))])), 0.0), (J.mul(J.gp(_s88["S"], "fs"), J.gp(_s88["S"], "H")) * 0.42))
		J.mc(_s88["ctx"], "save", [])
		var _t548 = _s88["ctx"]
		var _t549 = J.mul(J.gp(_t548, "globalAlpha"), (J.sub(_s88["k"], 0.3) * 0.8))
		J.sp(_t548, "globalAlpha", _t549)
		var _t550 = _s88["ctx"]
		J.sp(_t550, "fillStyle", "rgba(160,210,230,.2)")
		J.mc(_s88["ctx"], "beginPath", [])
		J.mc(_s88["ctx"], "ellipse", [v_g_520, ((-J.num(J.gp(_s88["S"], "H"))) * 0.004), J.mul(J.gp(_s88["S"], "H"), 0.28), J.mul(J.gp(_s88["S"], "H"), 0.035), 0.0, 0.0, J.mul(_s88["__p"]["PI"], 2.0)])
		J.mc(_s88["ctx"], "fill", [])
		J.mc(_s88["ctx"], "restore", [])
	var _t551 = _s88["__p"]["auntieDraw"]
	J.cl(_t551, null, [_s88["S"], {"th": v_th_517, "fx": v_fx_518, "fy": v_fy_519, "floor": ((-J.num(J.gp(_s88["S"], "H"))) * 0.045), "reach": v_q_516, "lean": (J.mul(J.gp(_s88["S"], "fs"), _s88["k"]) * (0.05 + J.mul(v_push_515, 0.025))), "head": (J.mul(J.gp(_s88["S"], "fs"), _s88["k"]) * (0.08 + J.mul(v_push_515, 0.02))), "legF": (0.0 if J.t(J.gp(_s88["S"], "walk")) else 0.0), "mfn": Callable(self, "_f63").bind(_s88)}])
	var _t553 = _s88["__p"]["end"]
	J.cl(_t553, null, [_s88["S"]])
	return true

func _f65(this_, a: Array, env):
	var v_FX_538 = null; var v_FY_539 = null; var v_TH_540 = null; var v_s_541 = null; var v_sh_542 = null; var v_H0_543 = null; var v_h0_544 = null; var v_A_545 = null; var v_c_546 = null; var v_sn_547 = null; var v_up_548 = null; var v_g_549 = null; var v_a0_550 = null; var v_ang_551 = null; var v_r_552 = null; var v_fix_553 = null
	v_FX_538 = J.arg(a, 0)
	v_FY_539 = J.arg(a, 1)
	v_TH_540 = J.arg(a, 2)
	v_s_541 = J.arg(a, 3)
	v_sh_542 = J.mc(env["S"], "P", J.spread([J.SP(J.gp(env["__p"]["AU"], "SH"))]))
	v_H0_543 = J.mc(env["S"], "P", J.spread([J.SP(J.gp(env["__p"]["AU"], "HAND"))]))
	v_h0_544 = [J.sub(J.gp(v_H0_543, 0.0), J.gp(v_sh_542, 0.0)), J.sub(J.gp(v_H0_543, 1.0), J.gp(v_sh_542, 1.0))]
	var _t563 = env["__p"]["auAxis"]
	v_A_545 = J.cl(_t563, null, [env["S"]])
	v_c_546 = cos(J.num(v_TH_540))
	v_sn_547 = sin(J.num(v_TH_540))
	v_up_548 = [(-(J.mul(J.gp(v_A_545, "ux"), v_c_546) - J.mul(J.gp(v_A_545, "uy"), v_sn_547))), (-(J.mul(J.gp(v_A_545, "ux"), v_sn_547) + J.mul(J.gp(v_A_545, "uy"), v_c_546)))]
	v_g_549 = [J.sub(v_FX_538, (J.mul(J.gp(v_up_548, 0.0), J.gp(env["S"], "H")) * 0.12)), J.sub(v_FY_539, (J.mul(J.gp(v_up_548, 1.0), J.gp(env["S"], "H")) * 0.12))]
	v_a0_550 = atan2(J.num(J.gp(v_h0_544, 1.0)), J.num(J.gp(v_h0_544, 0.0)))
	v_ang_551 = J.sub(atan2(J.num(J.sub(J.gp(v_g_549, 1.0), J.gp(v_sh_542, 1.0))), J.num(J.sub(J.gp(v_g_549, 0.0), J.gp(v_sh_542, 0.0)))), v_a0_550)
	v_r_552 = J.hypot_([J.gp(v_h0_544, 0.0), J.gp(v_h0_544, 1.0)])
	v_fix_553 = [J.sub(J.gp(v_g_549, 0.0), J.add(J.gp(v_sh_542, 0.0), J.mul(cos(J.num(J.add(v_ang_551, v_a0_550))), v_r_552))), J.sub(J.gp(v_g_549, 1.0), J.add(J.gp(v_sh_542, 1.0), J.mul(sin(J.num(J.add(v_ang_551, v_a0_550))), v_r_552)))]
	var _t564 = env["__p"]["piece"]
	J.cl(_t564, null, [env["S"], "npc_auntie__hip", J.gp(env["__p"]["AU"], "SH"), [J.add(J.gp(v_sh_542, 0.0), J.mul(J.gp(v_fix_553, 0.0), env["q"])), J.add(J.gp(v_sh_542, 1.0), J.mul(J.gp(v_fix_553, 1.0), env["q"]))], (J.mul(v_ang_551, env["q"]) - J.mul(J.mul(env["tw"], 0.06), env["q"]))])

func _f66(this_, a: Array, env):
	var v_L_554 = null; var v_h_555 = null; var v_sq_556 = null; var v_i_557 = null
	v_L_554 = J.arg(a, 0)
	if J.cmp(env["k"], 0.5, "<"):
		return null
	v_h_555 = J.cl(v_L_554, null, J.spread([J.SP(J.gp(env["__p"]["AU"], "HEAD"))]))
	v_sq_556 = absf(J.num(env["tw"]))
	v_i_557 = 0.0
	while true:
		if not J.cmp(v_i_557, 4.0, "<"): break
		var _t566 = env["__p"]["drop"]
		var _t569 = env["ctx"]
		var _t568 = J.gp(v_h_555, 0.0)
		var _t567 = env["__p"]["rnd"]
		J.cl(_t566, null, [_t569, J.add(_t568, (J.mul(J.sub(J.cl(_t567, null, [v_i_557]), 0.5), J.gp(env["S"], "H")) * 0.1)), J.add(J.gp(v_h_555, 1.0), J.mul(J.gp(env["S"], "H"), 0.01)), J.mul(J.gp(env["S"], "H"), 0.01), J.mod((J.mul(env["t"], 1.7) + J.div(v_i_557, 4.0)), 1.0), J.mul(J.mul(J.gp(env["S"], "H"), 0.05), J.add(0.4, v_sq_556))])
		v_i_557 = J.num(v_i_557) + 1.0

func _f64(this_, a: Array, env):
	var v_a_527 = null; var v_th_533 = null; var v_fx_534 = null; var v_fy_535 = null; var v_hipF_536 = null; var v_hip_537 = null
	var _s92 = {"__p": env, "ctx": null, "S": null, "t": null, "k": null, "q": null, "tw": null}
	_s92["ctx"] = J.arg(a, 0)
	v_a_527 = J.arg(a, 1)
	var _t556 = _s92["__p"]["begin"]
	_s92["S"] = J.cl(_t556, null, [_s92["ctx"], v_a_527, "npc_auntie__bodyH", false])
	if (not J.t(_s92["S"])):
		return false
	_s92["t"] = J.gp(_s92["S"], "at")
	_s92["k"] = J.gp(_s92["S"], "env")
	var _t557 = _s92["__p"]["ss"]
	_s92["q"] = J.cl(_t557, null, [_s92["k"]])
	var _t559 = sin(J.num(J.mul(_s92["t"], 8.0)))
	var _t558 = _s92["__p"]["seg"]
	var _t561 = J.mul(_t559, J.cl(_t558, null, [_s92["t"], 0.45, 0.65]))
	var _t560 = _s92["__p"]["seg"]
	_s92["tw"] = (_t561 * J.sub(1.0, J.cl(_t560, null, [_s92["t"], 1.8, 2.0])))
	var _t562 = _s92["__p"]["auTh"]
	v_th_533 = (J.mul(J.cl(_t562, null, [_s92["S"], (J.div(_s92["__p"]["PI"], 2.0) + J.mul(J.gp(_s92["S"], "fs"), 0.12))]), _s92["q"]) + J.mul(_s92["tw"], 0.04))
	v_fx_534 = (J.mul(_s92["q"], J.gp(_s92["S"], "fs")) * 0.05)
	v_fy_535 = J.mul(_s92["q"], 0.04)
	v_hipF_536 = null
	v_hip_537 = Callable(self, "_f65").bind(_s92)
	var _t565 = _s92["__p"]["auntieDraw"]
	J.cl(_t565, null, [_s92["S"], {"th": v_th_533, "fx": v_fx_534, "fy": v_fy_535, "floor": ((-J.num(J.gp(_s92["S"], "H"))) * 0.06), "reach": _s92["q"], "fa": J.mul(_s92["tw"], 0.08), "lean": (J.mul(J.gp(_s92["S"], "fs"), _s92["k"]) * 0.06), "head": (J.mul(J.gp(_s92["S"], "fs"), _s92["k"]) * 0.12), "hip": v_hip_537, "mfn": Callable(self, "_f66").bind(_s92)}])
	var _t570 = _s92["__p"]["end"]
	J.cl(_t570, null, [_s92["S"]])
	return true

func _f67(this_, a: Array, env):
	var v_ctx_560 = null; var v_a_561 = null; var v_S_562 = null; var v_t_563 = null; var v_k_564 = null; var v_tap_565 = null; var v_shake_566 = null; var v_h_567 = null
	v_ctx_560 = J.arg(a, 0)
	v_a_561 = J.arg(a, 1)
	var _t573 = env["begin"]
	v_S_562 = J.cl(_t573, null, [v_ctx_560, v_a_561, "npc_auntie__bodyH", false])
	if (not J.t(v_S_562)):
		return false
	v_t_563 = J.gp(v_S_562, "at")
	v_k_564 = J.gp(v_S_562, "env")
	var _t575 = J.max_([0.0, sin(J.num(J.mul(v_t_563, 7.0)))])
	var _t574 = env["seg"]
	var _t577 = J.mul(_t575, J.cl(_t574, null, [v_t_563, 0.2, 0.4]))
	var _t576 = env["seg"]
	v_tap_565 = (_t577 * J.sub(1.0, J.cl(_t576, null, [v_t_563, 1.0, 1.2])))
	var _t579 = sin(J.num(J.mul(v_t_563, 9.0)))
	var _t578 = env["seg"]
	var _t581 = J.mul(_t579, J.cl(_t578, null, [v_t_563, 1.1, 1.3]))
	var _t580 = env["seg"]
	v_shake_566 = (_t581 * J.sub(1.0, J.cl(_t580, null, [v_t_563, 2.0, 2.2])))
	var _t582 = env["auntieDraw"]
	J.cl(_t582, null, [v_S_562, {"fy": (J.mul((-J.num(v_k_564)), v_tap_565) * 0.025), "head": J.mul(v_k_564, (J.mul(v_shake_566, 0.1) + J.mul(J.gp(v_S_562, "fs"), 0.03))), "lean": (J.mul((-J.num(J.gp(v_S_562, "fs"))), v_k_564) * 0.02)}])
	v_h_567 = J.mc(v_S_562, "P", [0.45, 0.12])
	var _t583 = env["text"]
	var _t587 = J.sub(J.gp(v_h_567, 0.0), (J.mul(J.gp(v_S_562, "fs"), J.gp(v_S_562, "W")) * 0.42))
	var _t588 = J.sub(J.gp(v_h_567, 1.0), J.mul(J.gp(v_S_562, "H"), 0.05))
	var _t589 = ("哼！" if J.cmp(v_t_563, 1.1, "<") else "嘖嘖……")
	var _t590 = J.mul(J.gp(v_S_562, "H"), 0.1)
	var _t584 = env["bump"]
	var _t586 = J.cl(_t584, null, [v_t_563, 0.15, 0.3, 1.0])
	var _t585 = env["bump"]
	J.cl(_t583, null, [v_S_562, _t587, _t588, _t589, _t590, J.mul(J.add(_t586, J.cl(_t585, null, [v_t_563, 1.1, 1.3, 2.2])), v_k_564)])
	var _t591 = env["anger"]
	var _t593 = J.gp(J.mc(v_S_562, "P", [0.7, 0.1]), 0.0)
	var _t594 = J.gp(J.mc(v_S_562, "P", [0.7, 0.1]), 1.0)
	var _t595 = J.mul(J.gp(v_S_562, "H"), 0.075)
	var _t592 = env["bump"]
	J.cl(_t591, null, [v_ctx_560, _t593, _t594, _t595, J.mul(J.cl(_t592, null, [v_t_563, 0.2, 0.4, 2.1]), v_k_564)])
	var _t596 = env["end"]
	J.cl(_t596, null, [v_S_562])
	return true

func _f68(this_, a: Array, env):
	var v_t_568 = null; var v_T_569 = null
	v_t_568 = J.arg(a, 0)
	v_T_569 = J.arg(a, 1)
	return J.mod(J.add(J.mod(v_t_568, v_T_569), v_T_569), v_T_569)

func _f69(this_, a: Array, env):
	var v_ctx_572 = null; var v_a_573 = null; var v_S_574 = null; var v_t_575 = null; var v_k_576 = null; var v_q_577 = null; var v_up_578 = null; var v_jab_579 = null; var v_look_580 = null
	v_ctx_572 = J.arg(a, 0)
	v_a_573 = J.arg(a, 1)
	var _t599 = env["begin"]
	v_S_574 = J.cl(_t599, null, [v_ctx_572, v_a_573, "npc_boss__bodyN", false])
	if (not J.t(v_S_574)):
		return false
	v_t_575 = J.gp(v_S_574, "at")
	v_k_576 = J.gp(v_S_574, "env")
	var _t600 = env["loop"]
	v_q_577 = J.cl(_t600, null, [v_t_575, 5.2])
	var _t601 = env["kf"]
	v_up_578 = J.cl(_t601, null, [[[0.0, 0.55], [0.6, 1.0], [3.6, 1.0], [4.3, 0.55], [5.2, 0.55]], v_q_577])
	var _t603 = J.max_([0.0, sin(J.num(J.mul(v_t_575, 6.5)))])
	var _t602 = env["bump"]
	v_jab_579 = J.mul(_t603, J.cl(_t602, null, [v_q_577, 0.8, 1.2, 3.2]))
	v_look_580 = sin(J.num(J.mul(v_t_575, 0.9)))
	var _t604 = env["bossDraw"]
	J.cl(_t604, null, [v_S_574, {"glove": ((-J.num(v_k_576)) * (J.mul(v_up_578, 2.3) + J.mul(v_jab_579, 0.1))), "shUp": (J.mul(v_k_576, v_up_578) * 0.012), "head": (J.mul(J.gp(v_S_574, "fs"), v_k_576) * (J.mul((-0.05), v_up_578) + J.mul(0.04, v_look_580))), "lean": (J.mul(J.mul((-J.num(J.gp(v_S_574, "fs"))), v_k_576), v_jab_579) * 0.012), "ball": (J.mul(v_k_576, 0.04) * sin(J.num(J.mul(v_t_575, 1.3))))}])
	var _t605 = env["end"]
	J.cl(_t605, null, [v_S_574])
	return true

func _f71(this_, a: Array, env):
	var v_L_591 = null; var v_p_592 = null
	v_L_591 = J.arg(a, 0)
	v_p_592 = J.cl(v_L_591, null, J.spread([J.SP(J.gp(env["__p"]["BOSS"], "HAND"))]))
	var _t612 = env["__p"]["prop"]
	J.cl(_t612, null, [env["ctx"], "op_paper_fly", J.add(J.gp(v_p_592, 0.0), (J.mul(J.gp(env["S"], "fs"), J.gp(env["S"], "W")) * 0.03)), J.sub(J.gp(v_p_592, 1.0), J.mul(J.gp(env["S"], "H"), 0.05)), (J.mul(J.mul(J.gp(env["S"], "H"), 0.22), env["k"]) + 0.0001), (((-J.num(J.gp(env["S"], "fs"))) * 0.15) - J.mul(1.25, env["k"])), 0.5, 0.6, ((1.0 - J.mul(env["flip"], 1.6)) * (1.0 if J.cmp(J.gp(env["S"], "fs"), 0.0, ">") else (-1.0))), 1.0])

func _f70(this_, a: Array, env):
	var v_a_584 = null; var v_t_586 = null; var v_q_588 = null; var v_scan_590 = null
	var _s99 = {"__p": env, "ctx": null, "S": null, "k": null, "flip": null}
	_s99["ctx"] = J.arg(a, 0)
	v_a_584 = J.arg(a, 1)
	var _t608 = _s99["__p"]["begin"]
	_s99["S"] = J.cl(_t608, null, [_s99["ctx"], v_a_584, "npc_boss__bodyN", false])
	if (not J.t(_s99["S"])):
		return false
	v_t_586 = J.gp(_s99["S"], "at")
	_s99["k"] = J.gp(_s99["S"], "env")
	var _t609 = _s99["__p"]["loop"]
	v_q_588 = J.cl(_t609, null, [v_t_586, 4.6])
	var _t610 = _s99["__p"]["bump"]
	_s99["flip"] = J.cl(_t610, null, [v_q_588, 3.6, 3.85, 4.2])
	v_scan_590 = J.mod(J.div(v_q_588, 3.6), 1.0)
	var _t611 = _s99["__p"]["bossDraw"]
	J.cl(_t611, null, [_s99["S"], {"glove": J.mul(_s99["k"], ((1.25 + (0.04 * sin(J.num(J.mul(v_t_586, 1.1))))) - J.mul(_s99["flip"], 0.12))), "shUp": J.mul(_s99["k"], 0.012), "head": (J.mul(J.gp(_s99["S"], "fs"), _s99["k"]) * (0.13 + J.mul(v_scan_590, 0.05))), "lean": (J.mul(J.gp(_s99["S"], "fs"), _s99["k"]) * 0.02), "gfn": Callable(self, "_f71").bind(_s99)}])
	var _t613 = _s99["__p"]["end"]
	J.cl(_t613, null, [_s99["S"]])
	return true

func _f73(this_, a: Array, env):
	var v_L_603 = null; var v_p_604 = null
	v_L_603 = J.arg(a, 0)
	v_p_604 = J.cl(v_L_603, null, J.spread([J.SP(J.gp(env["__p"]["BOSS"], "HAND"))]))
	var _t620 = env["__p"]["prop"]
	J.cl(_t620, null, [env["ctx"], "afu__phone", J.add(J.gp(v_p_604, 0.0), (J.mul(J.gp(env["S"], "fs"), J.gp(env["S"], "W")) * 0.01)), J.sub(J.gp(v_p_604, 1.0), J.mul(J.gp(env["S"], "H"), 0.035)), (J.mul(J.mul(J.gp(env["S"], "H"), 0.12), env["k"]) + 0.0001), (((-J.num(J.gp(env["S"], "fs"))) * 0.5) - J.mul(2.55, env["k"])), 0.5, 0.6, (-J.num(J.gp(env["S"], "fs"))), 1.0])

func _f72(this_, a: Array, env):
	var v_a_596 = null; var v_t_598 = null; var v_q_600 = null; var v_rant_601 = null; var v_nod_602 = null
	var _s101 = {"__p": env, "ctx": null, "S": null, "k": null}
	_s101["ctx"] = J.arg(a, 0)
	v_a_596 = J.arg(a, 1)
	var _t616 = _s101["__p"]["begin"]
	_s101["S"] = J.cl(_t616, null, [_s101["ctx"], v_a_596, "npc_boss__bodyN", false])
	if (not J.t(_s101["S"])):
		return false
	v_t_598 = J.gp(_s101["S"], "at")
	_s101["k"] = J.gp(_s101["S"], "env")
	var _t617 = _s101["__p"]["loop"]
	v_q_600 = J.cl(_t617, null, [v_t_598, 7.0])
	var _t618 = _s101["__p"]["bump"]
	v_rant_601 = J.cl(_t618, null, [v_q_600, 4.6, 5.0, 6.2])
	v_nod_602 = (J.max_([0.0, sin(J.num(J.mul(v_t_598, 2.2)))]) * J.sub(1.0, v_rant_601))
	var _t619 = _s101["__p"]["bossDraw"]
	J.cl(_t619, null, [_s101["S"], {"glove": J.mul(_s101["k"], ((2.55 - J.mul(v_rant_601, 0.25)) + J.mul((sin(J.num(J.mul(v_t_598, 9.0))) * 0.03), v_rant_601))), "shUp": J.mul(_s101["k"], 0.04), "head": (J.mul(J.gp(_s101["S"], "fs"), _s101["k"]) * (((-0.1) + J.mul(v_nod_602, 0.05)) - J.mul(v_rant_601, 0.04))), "lean": (J.mul(J.mul((-J.num(J.gp(_s101["S"], "fs"))), _s101["k"]), v_rant_601) * 0.02), "ball": J.mul(_s101["k"], (J.mul(v_rant_601, 0.12) * sin(J.num(J.mul(v_t_598, 6.0))))), "gfn": Callable(self, "_f73").bind(_s101)}])
	var _t621 = _s101["__p"]["end"]
	J.cl(_t621, null, [_s101["S"]])
	return true

func _f74(this_, a: Array, env):
	var v_ctx_607 = null; var v_a_608 = null; var v_S_609 = null; var v_t_610 = null; var v_k_611 = null; var v_sweep_612 = null; var v_watch_613 = null
	v_ctx_607 = J.arg(a, 0)
	v_a_608 = J.arg(a, 1)
	var _t624 = env["begin"]
	v_S_609 = J.cl(_t624, null, [v_ctx_607, v_a_608, "npc_boss__bodyN", false])
	if (not J.t(v_S_609)):
		return false
	v_t_610 = J.gp(v_S_609, "at")
	v_k_611 = J.gp(v_S_609, "env")
	var _t626 = sin(J.num(J.mul(v_t_610, 4.5)))
	var _t625 = env["bump"]
	v_sweep_612 = J.mul(_t626, J.cl(_t625, null, [v_t_610, 0.3, 0.6, 2.0]))
	var _t627 = env["kf"]
	v_watch_613 = J.cl(_t627, null, [[[0.0, 0.0], [2.1, 0.0], [2.5, 1.0], [3.5, 1.0]], v_t_610])
	var _t628 = env["bossDraw"]
	var _t629 = env["lerp"]
	J.cl(_t628, null, [v_S_609, {"glove": J.mul(v_k_611, J.cl(_t629, null, [((-0.45) + J.mul(v_sweep_612, 0.25)), 1.45, v_watch_613])), "shUp": (J.mul(v_k_611, v_watch_613) * 0.01), "ball": J.mul(v_k_611, 0.22), "elUp": J.mul(v_k_611, 0.01), "head": (J.mul(J.gp(v_S_609, "fs"), v_k_611) * (0.12 + J.mul(v_watch_613, 0.05))), "lean": ((J.mul(J.gp(v_S_609, "fs"), v_k_611) * 0.05) * J.sub(1.0, v_watch_613))}])
	var _t630 = env["end"]
	J.cl(_t630, null, [v_S_609])
	return true

func _f75(this_, a: Array, env):
	var v_ctx_616 = null; var v_a_617 = null; var v_S_618 = null; var v_t_619 = null; var v_k_620 = null; var v_q_621 = null; var v_br_622 = null; var v_nod_623 = null; var v_jerk_624 = null; var v_h_625 = null
	v_ctx_616 = J.arg(a, 0)
	v_a_617 = J.arg(a, 1)
	var _t633 = env["begin"]
	v_S_618 = J.cl(_t633, null, [v_ctx_616, v_a_617, "npc_guard__bodyN", false])
	if (not J.t(v_S_618)):
		return false
	v_t_619 = J.gp(v_S_618, "at")
	v_k_620 = J.gp(v_S_618, "env")
	var _t634 = env["loop"]
	v_q_621 = J.cl(_t634, null, [v_t_619, 8.0])
	v_br_622 = sin(J.num(J.mul(v_t_619, 1.5)))
	var _t635 = env["kf"]
	v_nod_623 = J.add(J.cl(_t635, null, [[[0.0, 0.25], [1.6, 0.85], [5.9, 1.0], [6.15, 1.12], [6.3, (-0.2)], [6.8, 0.1], [8.0, 0.25]], v_q_621]), J.mul(v_br_622, 0.04))
	var _t636 = env["bump"]
	v_jerk_624 = J.cl(_t636, null, [v_q_621, 6.15, 6.3, 6.8])
	J.mc(v_ctx_616, "save", [])
	J.mc(v_ctx_616, "scale", [1.0, ((1.0 - J.mul((0.025 * J.max_([0.0, v_nod_623])), v_k_620)) + J.mul(J.mul(0.006, v_br_622), v_k_620))])
	var _t637 = env["guardDraw"]
	J.cl(_t637, null, [v_S_618, {"head": (J.mul(J.mul(J.gp(v_S_618, "fs"), v_k_620), v_nod_623) * 0.45), "lean": (J.mul(J.mul(J.gp(v_S_618, "fs"), v_k_620), v_nod_623) * 0.05), "dy": J.mul(v_k_620, ((J.mul(J.max_([0.0, v_nod_623]), J.gp(v_S_618, "H")) * 0.012) - (J.mul(v_jerk_624, J.gp(v_S_618, "H")) * 0.02))), "fl": (((-J.num(v_k_620)) * J.max_([0.0, v_nod_623])) * 0.32)}])
	J.mc(v_ctx_616, "restore", [])
	v_h_625 = J.mc(v_S_618, "P", [0.3, 0.12])
	var _t638 = env["zzz"]
	var _t640 = J.sub(J.gp(v_h_625, 0.0), (J.mul(J.gp(v_S_618, "fs"), J.gp(v_S_618, "W")) * 0.15))
	var _t641 = J.gp(v_h_625, 1.0)
	var _t642 = J.mul(J.gp(v_S_618, "H"), 0.09)
	var _t639 = env["bump"]
	J.cl(_t638, null, [v_S_618, _t640, _t641, _t642, v_t_619, J.mul(J.sub(1.0, J.cl(_t639, null, [v_q_621, 6.0, 6.3, 7.2])), v_k_620)])
	var _t643 = env["marks"]
	J.cl(_t643, null, [v_ctx_616, J.gp(J.mc(v_S_618, "P", [0.5, 0.05]), 0.0), J.sub(J.gp(J.mc(v_S_618, "P", [0.5, 0.05]), 1.0), J.mul(J.gp(v_S_618, "H"), 0.03)), J.mul(J.gp(v_S_618, "H"), 0.09), J.mul(v_jerk_624, v_k_620)])
	var _t644 = env["end"]
	J.cl(_t644, null, [v_S_618])
	return true

func _f76(this_, a: Array, env):
	var v_ctx_628 = null; var v_a_629 = null; var v_S_630 = null; var v_t_631 = null; var v_k_632 = null; var v_br_633 = null; var v_h_634 = null
	v_ctx_628 = J.arg(a, 0)
	v_a_629 = J.arg(a, 1)
	var _t647 = env["begin"]
	v_S_630 = J.cl(_t647, null, [v_ctx_628, v_a_629, "npc_ken__bodyF", false, {"noLift": 1.0}])
	if (not J.t(v_S_630)):
		return false
	v_t_631 = J.gp(v_S_630, "at")
	v_k_632 = J.gp(v_S_630, "env")
	v_br_633 = sin(J.num(J.mul(v_t_631, 1.25)))
	J.mc(v_ctx_628, "save", [])
	J.mc(v_ctx_628, "scale", [1.0, (1.0 + J.mul(J.mul(0.012, v_br_633), v_k_632))])
	var _t648 = env["kenDraw"]
	J.cl(_t648, null, [v_S_630, {"lean": (J.mul(J.gp(v_S_630, "fs"), v_k_632) * (0.42 + J.mul(0.012, v_br_633))), "head": (J.mul(J.gp(v_S_630, "fs"), v_k_632) * (0.75 + J.mul(0.02, v_br_633))), "ang": ((-J.num(v_k_632)) * 0.55)}])
	J.mc(v_ctx_628, "restore", [])
	v_h_634 = J.mc(v_S_630, "P", [0.45, 0.4])
	var _t649 = env["zzz"]
	J.cl(_t649, null, [v_S_630, J.add(J.gp(v_h_634, 0.0), (J.mul(J.gp(v_S_630, "fs"), J.gp(v_S_630, "W")) * 0.55)), J.sub(J.gp(v_h_634, 1.0), J.mul(J.gp(v_S_630, "H"), 0.05)), J.mul(J.gp(v_S_630, "H"), 0.1), J.mul(v_t_631, 0.7), v_k_632])
	var _t650 = env["end"]
	J.cl(_t650, null, [v_S_630])
	return true

func _f78(this_, a: Array, env):
	var v_ctx_645 = null; var v_a_646 = null; var v_S_647 = null; var v_t_648 = null; var v_k_649 = null; var v_q_650 = null; var v_look_651 = null; var v_tap_652 = null
	v_ctx_645 = J.arg(a, 0)
	v_a_646 = J.arg(a, 1)
	var _t653 = env["begin"]
	v_S_647 = J.cl(_t653, null, [v_ctx_645, v_a_646, "npc_it", true])
	if (not J.t(v_S_647)):
		return false
	v_t_648 = J.gp(v_S_647, "at")
	v_k_649 = J.gp(v_S_647, "env")
	var _t654 = env["loop"]
	v_q_650 = J.cl(_t654, null, [v_t_648, 6.0])
	var _t655 = env["bump"]
	v_look_651 = J.cl(_t655, null, [v_q_650, 4.2, 4.6, 5.5])
	v_tap_652 = (sin(J.num(J.mul(v_t_648, 14.0))) * J.sub(1.0, v_look_651))
	var _t656 = env["meshBody"]
	J.cl(_t656, null, [v_S_647, "npc_it", "npc_it", {"head": (J.mul(J.gp(v_S_647, "fs"), v_k_649) * (0.26 - J.mul(v_look_651, 0.34))), "body": ((J.mul(J.gp(v_S_647, "fs"), v_k_649) * 0.04) * J.sub(1.0, v_look_651)), "armF": (J.mul(J.gp(v_S_647, "fs"), v_k_649) * (0.1 + J.mul(v_tap_652, 0.03))), "armB": (J.mul(J.gp(v_S_647, "fs"), v_k_649) * (0.08 + J.mul(v_tap_652, 0.02)))}])
	var _t657 = env["end"]
	J.cl(_t657, null, [v_S_647])
	return true

func _f79(this_, a: Array, env):
	var v_ctx_655 = null; var v_a_656 = null; var v_S_657 = null; var v_t_658 = null; var v_k_659 = null; var v_bend_660 = null; var v_sw_661 = null
	v_ctx_655 = J.arg(a, 0)
	v_a_656 = J.arg(a, 1)
	var _t660 = env["begin"]
	v_S_657 = J.cl(_t660, null, [v_ctx_655, v_a_656, "npc_it", true])
	if (not J.t(v_S_657)):
		return false
	v_t_658 = J.gp(v_S_657, "at")
	v_k_659 = J.gp(v_S_657, "env")
	var _t661 = env["bump"]
	v_bend_660 = J.cl(_t661, null, [v_t_658, 0.2, 0.7, 2.2])
	v_sw_661 = J.mul(sin(J.num(J.mul(v_t_658, 7.0))), v_bend_660)
	var _t662 = env["meshBody"]
	var _t665 = J.mul(J.gp(v_S_657, "fs"), v_k_659)
	var _t664 = J.mul(v_bend_660, 0.22)
	var _t663 = env["bump"]
	J.cl(_t662, null, [v_S_657, "npc_it", "npc_it", {"head": (_t665 * (_t664 - J.mul(J.cl(_t663, null, [v_t_658, 2.3, 2.8, 3.5]), 0.12))), "body": (J.mul(J.mul(J.gp(v_S_657, "fs"), v_k_659), v_bend_660) * 0.12), "armF": (J.mul((-J.num(J.gp(v_S_657, "fs"))), v_k_659) * (J.mul(0.25, v_bend_660) + J.mul(v_sw_661, 0.06))), "armB": (J.mul(J.gp(v_S_657, "fs"), v_k_659) * (J.mul(0.18, v_bend_660) + J.mul(v_sw_661, 0.05)))}])
	var _t666 = env["end"]
	J.cl(_t666, null, [v_S_657])
	return true

func _f80(this_, a: Array, env):
	var v_ctx_664 = null; var v_a_665 = null; var v_S_666 = null; var v_t_667 = null; var v_k_668 = null; var v_q_669 = null; var v_bend_670 = null; var v_rub_671 = null
	v_ctx_664 = J.arg(a, 0)
	v_a_665 = J.arg(a, 1)
	var _t669 = env["begin"]
	v_S_666 = J.cl(_t669, null, [v_ctx_664, v_a_665, "npc_auntie__bodyH", false])
	if (not J.t(v_S_666)):
		return false
	v_t_667 = J.gp(v_S_666, "at")
	v_k_668 = J.gp(v_S_666, "env")
	var _t670 = env["ss"]
	v_q_669 = J.cl(_t670, null, [v_k_668])
	var _t671 = env["bump"]
	var _t673 = J.cl(_t671, null, [v_t_667, 0.2, 0.7, 1.4])
	var _t672 = env["bump"]
	v_bend_670 = J.add(_t673, J.cl(_t672, null, [v_t_667, 1.3, 1.8, 2.5]))
	var _t674 = env["bump"]
	v_rub_671 = J.cl(_t674, null, [v_t_667, 2.5, 2.8, 3.5])
	var _t675 = env["auntieDraw"]
	var _t676 = env["auTh"]
	J.cl(_t675, null, [v_S_666, {"th": J.mul(J.cl(_t676, null, [v_S_666, (J.div(env["PI"], 2.0) + J.mul(J.gp(v_S_666, "fs"), 0.12))]), v_q_669), "fx": (J.mul(v_q_669, J.gp(v_S_666, "fs")) * 0.05), "fy": J.mul(v_q_669, 0.04), "floor": ((-J.num(J.gp(v_S_666, "H"))) * 0.06), "reach": v_q_669, "lean": (J.mul(J.gp(v_S_666, "fs"), v_k_668) * (J.mul(0.16, v_bend_670) - J.mul(0.05, v_rub_671))), "head": (J.mul(J.gp(v_S_666, "fs"), v_k_668) * (J.mul(0.22, v_bend_670) - J.mul(0.08, v_rub_671))), "hipA": ((J.mul(v_k_668, v_rub_671) * sin(J.num(J.mul(v_t_667, 16.0)))) * 0.12)}])
	var _t677 = env["end"]
	J.cl(_t677, null, [v_S_666])
	return true

func _f82(this_, a: Array, env):
	var v_L_684 = null; var v_h_685 = null; var v_w_686 = null; var v_sx_687 = null; var v_sy_688 = null
	v_L_684 = J.arg(a, 0)
	v_h_685 = J.cl(v_L_684, null, [0.16, 0.71])
	v_w_686 = J.mul(J.mul(J.gp(env["S"], "H"), 0.26), env["k"])
	v_sx_687 = (cos(J.num(J.mul(env["fold"], env["__p"]["PI"]))) * (1.0 if (J.mod(J.gp(env["S"], "at"), 4.8) < 2.4) else (-1.0)))
	v_sy_688 = (1.0 - J.mul(0.35, env["fold"]))
	var _t689 = env["__p"]["prop"]
	J.cl(_t689, null, [env["ctx"], "furnace__paper", J.gp(v_h_685, 0.0), J.sub(J.gp(v_h_685, 1.0), J.mul(J.gp(env["S"], "H"), 0.02)), v_w_686, J.mul(J.gp(env["S"], "fs"), 0.5), 0.5, 0.6, (0.08 if (absf(J.num(v_sx_687)) < 0.08) else v_sx_687), v_sy_688])

func _f81(this_, a: Array, env):
	var v_a_675 = null; var v_t_677 = null; var v_up_679 = null; var v_pat_681 = null; var v_pv_682 = null; var v_at_683 = null
	var _s111 = {"__p": env, "ctx": null, "S": null, "k": null, "fold": null}
	_s111["ctx"] = J.arg(a, 0)
	v_a_675 = J.arg(a, 1)
	var _t680 = _s111["__p"]["begin"]
	_s111["S"] = J.cl(_t680, null, [_s111["ctx"], v_a_675, "xiaozhi__body", false])
	if (not J.t(_s111["S"])):
		return false
	v_t_677 = J.mod(J.gp(_s111["S"], "at"), 2.4)
	_s111["k"] = J.gp(_s111["S"], "env")
	var _t682 = _s111["k"]
	var _t681 = _s111["__p"]["kf"]
	v_up_679 = J.mul(_t682, J.cl(_t681, null, [[[0.0, 0.6], [0.4, 1.0], [1.6, 1.0], [2.0, 0.75], [2.4, 0.6]], v_t_677]))
	var _t683 = _s111["__p"]["seg"]
	_s111["fold"] = J.cl(_t683, null, [v_t_677, 0.5, 0.9])
	var _t684 = _s111["__p"]["bump"]
	var _t686 = J.cl(_t684, null, [v_t_677, 1.2, 1.3, 1.45])
	var _t685 = _s111["__p"]["bump"]
	v_pat_681 = J.add(_t686, J.cl(_t685, null, [v_t_677, 1.5, 1.6, 1.75]))
	v_pv_682 = [0.315, 0.535]
	v_at_683 = J.mc(_s111["S"], "P", J.spread([J.SP(v_pv_682)]))
	var _t687 = _s111["__p"]["body"]
	J.cl(_t687, null, [_s111["S"], "xiaozhi", "xiaozhi__body", {"head": (J.mul(J.gp(_s111["S"], "fs"), _s111["k"]) * (0.08 + J.mul(0.03, v_pat_681)))}])
	var _t688 = _s111["__p"]["piece"]
	J.cl(_t688, null, [_s111["S"], "xiaozhi__arm", v_pv_682, [J.gp(v_at_683, 0.0), J.sub(J.gp(v_at_683, 1.0), (J.mul(v_pat_681, J.gp(_s111["S"], "H")) * 0.01))], (((-J.num(J.gp(_s111["S"], "fs"))) * (J.mul(v_up_679, 0.55) + J.mul(v_pat_681, 0.05))) * 1.0), 1.0, Callable(self, "_f82").bind(_s111)])
	var _t690 = _s111["__p"]["end"]
	J.cl(_t690, null, [_s111["S"]])
	return true

func _f83(this_, a: Array, env):
	var v_ctx_691 = null; var v_a_692 = null; var v_S_693 = null; var v_t_694 = null; var v_k_695 = null; var v_tap_696 = null; var v_nod_697 = null; var v_pv_698 = null; var v_at_699 = null; var v_st_700 = null
	v_ctx_691 = J.arg(a, 0)
	v_a_692 = J.arg(a, 1)
	var _t693 = env["begin"]
	v_S_693 = J.cl(_t693, null, [v_ctx_691, v_a_692, "xiaozhi__body", false])
	if (not J.t(v_S_693)):
		return false
	v_t_694 = J.mod(J.gp(v_S_693, "at"), 2.2)
	v_k_695 = J.gp(v_S_693, "env")
	var _t694 = env["bump"]
	var _t696 = J.cl(_t694, null, [v_t_694, 0.3, 0.42, 0.55])
	var _t695 = env["bump"]
	v_tap_696 = J.add(_t696, J.cl(_t695, null, [v_t_694, 0.7, 0.82, 0.95]))
	var _t697 = env["bump"]
	v_nod_697 = J.cl(_t697, null, [v_t_694, 1.3, 1.5, 1.8])
	v_pv_698 = [0.315, 0.535]
	v_at_699 = J.mc(v_S_693, "P", J.spread([J.SP(v_pv_698)]))
	var _t698 = env["body"]
	J.cl(_t698, null, [v_S_693, "xiaozhi", "xiaozhi__body", {"head": (J.mul(J.gp(v_S_693, "fs"), v_k_695) * (0.06 + J.mul(0.1, v_nod_697)))}])
	v_st_700 = J.mc(v_S_693, "P", [0.18, 0.75])
	var _t699 = env["prop"]
	J.cl(_t699, null, [v_ctx_691, "furnace__stack", J.gp(v_st_700, 0.0), J.sub(J.add(J.gp(v_st_700, 1.0), J.mul((J.mul(v_tap_696, J.gp(v_S_693, "H")) * 0.03), v_k_695)), J.mul(J.mul(J.gp(v_S_693, "H"), 0.04), v_k_695)), (J.mul(J.mul(J.gp(v_S_693, "H"), 0.36), v_k_695) + 0.001), 0.0, 0.5, 0.5])
	var _t700 = env["piece"]
	J.cl(_t700, null, [v_S_693, "xiaozhi__arm", v_pv_698, [J.gp(v_at_699, 0.0), J.add(J.gp(v_at_699, 1.0), J.mul((J.mul(v_tap_696, J.gp(v_S_693, "H")) * 0.03), v_k_695))], (J.mul((-J.num(J.gp(v_S_693, "fs"))), v_k_695) * 0.1)])
	var _t701 = env["end"]
	J.cl(_t701, null, [v_S_693])
	return true

func _f85(this_, a: Array, env):
	var v_L_711 = null; var v_p_712 = null
	v_L_711 = J.arg(a, 0)
	v_p_712 = J.cl(v_L_711, null, [0.93, 0.58])
	if (sin(J.num(env["an"])) > 0.6):
		var _t707 = env["__p"]["sparkle"]
		J.cl(_t707, null, [env["ctx"], J.add(J.gp(v_p_712, 0.0), J.mul(J.gp(env["S"], "H"), 0.05)), J.add(J.gp(v_p_712, 1.0), J.mul(J.gp(env["S"], "H"), 0.01)), J.mul(J.gp(env["S"], "H"), 0.035), J.mul(((sin(J.num(env["an"])) - 0.6) * 2.5), env["k"])])

func _f84(this_, a: Array, env):
	var v_a_704 = null; var v_t_706 = null; var v_pv_709 = null; var v_at_710 = null
	var _s114 = {"__p": env, "ctx": null, "S": null, "k": null, "an": null}
	_s114["ctx"] = J.arg(a, 0)
	v_a_704 = J.arg(a, 1)
	var _t704 = _s114["__p"]["begin"]
	_s114["S"] = J.cl(_t704, null, [_s114["ctx"], v_a_704, "xiaogui__body", true])
	if (not J.t(_s114["S"])):
		return false
	v_t_706 = J.gp(_s114["S"], "at")
	_s114["k"] = J.gp(_s114["S"], "env")
	_s114["an"] = J.mul(v_t_706, 7.0)
	v_pv_709 = [0.61, 0.585]
	v_at_710 = J.mc(_s114["S"], "P", J.spread([J.SP(v_pv_709)]))
	var _t705 = _s114["__p"]["body"]
	J.cl(_t705, null, [_s114["S"], "xiaogui", "xiaogui__body", {"head": (J.mul(J.gp(_s114["S"], "fs"), _s114["k"]) * (0.1 + (sin(J.num(_s114["an"])) * 0.02))), "tail1": J.mul((sin(J.num(_s114["an"])) * 0.05), _s114["k"])}])
	var _t706 = _s114["__p"]["piece"]
	J.cl(_t706, null, [_s114["S"], "xiaogui__arm", v_pv_709, [J.add(J.gp(v_at_710, 0.0), J.mul((J.mul(cos(J.num(_s114["an"])), J.gp(_s114["S"], "H")) * 0.03), _s114["k"])), J.add(J.gp(v_at_710, 1.0), J.mul(J.mul((0.04 + (sin(J.num(_s114["an"])) * 0.015)), J.gp(_s114["S"], "H")), _s114["k"]))], (J.mul(J.gp(_s114["S"], "fs"), _s114["k"]) * (0.25 + (sin(J.num(_s114["an"])) * 0.06))), 1.0, Callable(self, "_f85").bind(_s114)])
	var _t708 = _s114["__p"]["end"]
	J.cl(_t708, null, [_s114["S"]])
	return true

func _f87(this_, a: Array, env):
	var v_L_725 = null; var v_p_726 = null
	v_L_725 = J.arg(a, 0)
	v_p_726 = J.cl(v_L_725, null, [0.95, 0.55])
	var _t719 = env["__p"]["prop"]
	J.cl(_t719, null, [env["ctx"], "furnace__paper", J.add(J.gp(v_p_726, 0.0), (J.mul(J.gp(env["S"], "fs"), J.gp(env["S"], "W")) * 0.06)), J.sub(J.gp(v_p_726, 1.0), J.mul(J.gp(env["S"], "H"), 0.03)), (J.mul(J.mul(J.gp(env["S"], "H"), 0.22), env["up"]) + 0.001), J.mul(J.gp(env["S"], "fs"), (0.3 + J.mul(env["look"], 0.1))), 0.5, 0.7])

func _f86(this_, a: Array, env):
	var v_a_716 = null; var v_t_718 = null; var v_k_719 = null; var v_pv_722 = null; var v_at_723 = null; var v_h_724 = null
	var _s116 = {"__p": env, "ctx": null, "S": null, "up": null, "look": null}
	_s116["ctx"] = J.arg(a, 0)
	v_a_716 = J.arg(a, 1)
	var _t711 = _s116["__p"]["begin"]
	_s116["S"] = J.cl(_t711, null, [_s116["ctx"], v_a_716, "xiaogui__body", true])
	if (not J.t(_s116["S"])):
		return false
	v_t_718 = J.gp(_s116["S"], "at")
	v_k_719 = J.gp(_s116["S"], "env")
	var _t712 = _s116["__p"]["kf"]
	_s116["up"] = J.mul(v_k_719, J.cl(_t712, null, [[[0.0, 0.0], [0.5, 1.0], [2.6, 1.0], [3.0, 0.0]], v_t_718]))
	var _t714 = sin(J.num(J.mul(v_t_718, 2.2)))
	var _t713 = _s116["__p"]["seg"]
	var _t716 = J.mul(_t714, J.cl(_t713, null, [v_t_718, 0.8, 1.0]))
	var _t715 = _s116["__p"]["seg"]
	_s116["look"] = (_t716 * J.sub(1.0, J.cl(_t715, null, [v_t_718, 2.3, 2.6])))
	v_pv_722 = [0.61, 0.585]
	v_at_723 = J.mc(_s116["S"], "P", J.spread([J.SP(v_pv_722)]))
	var _t717 = _s116["__p"]["body"]
	J.cl(_t717, null, [_s116["S"], "xiaogui", "xiaogui__body", {"head": J.mul(J.gp(_s116["S"], "fs"), (J.mul(_s116["up"], 0.14) + J.mul(_s116["look"], 0.05)))}])
	var _t718 = _s116["__p"]["piece"]
	J.cl(_t718, null, [_s116["S"], "xiaogui__arm", v_pv_722, [J.add(J.gp(v_at_723, 0.0), (J.mul(J.mul(J.gp(_s116["S"], "fs"), _s116["up"]), J.gp(_s116["S"], "W")) * 0.06)), J.sub(J.gp(v_at_723, 1.0), (J.mul(_s116["up"], J.gp(_s116["S"], "H")) * 0.05))], (J.mul((-J.num(J.gp(_s116["S"], "fs"))), _s116["up"]) * 0.45), 1.0, Callable(self, "_f87").bind(_s116)])
	v_h_724 = J.mc(_s116["S"], "P", [0.6, 0.15])
	var _t720 = _s116["__p"]["text"]
	var _t722 = _s116["S"]
	var _t723 = J.add(J.gp(v_h_724, 0.0), (J.mul(J.gp(_s116["S"], "fs"), J.gp(_s116["S"], "W")) * 0.2))
	var _t724 = J.sub(J.gp(v_h_724, 1.0), J.mul(J.gp(_s116["S"], "H"), 0.08))
	var _t725 = J.mul(J.gp(_s116["S"], "H"), 0.11)
	var _t721 = _s116["__p"]["bump"]
	J.cl(_t720, null, [_t722, _t723, _t724, "嗯……", _t725, J.mul(J.cl(_t721, null, [v_t_718, 1.0, 1.3, 2.6]), v_k_719)])
	var _t726 = _s116["__p"]["end"]
	J.cl(_t726, null, [_s116["S"]])
	return true

func _f89(this_, a: Array, env):
	var v_L_740 = null; var v_h_741 = null; var v_i_742 = null; var v_top_743 = null; var v_an_744 = null
	v_L_740 = J.arg(a, 0)
	v_h_741 = J.cl(v_L_740, null, [0.27, 0.62])
	if J.cmp(env["lick"], 0.5, "<"):
		v_i_742 = 0.0
		while true:
			if not J.cmp(v_i_742, 5.0, "<"): break
			v_top_743 = J.seq(v_i_742, 4.0)
			var _t738 = (J.sub(v_i_742, 2.0) * 0.16)
			var _t737 = null
			if J.t(v_top_743):
				var _t736 = (-0.32)
				var _t735 = env["__p"]["ss"]
				_t737 = J.mul(_t736, J.cl(_t735, null, [env["fq"]]))
			else:
				_t737 = 0.0
			v_an_744 = (_t738 + _t737)
			var _t739 = env["__p"]["prop"]
			J.cl(_t739, null, [env["ctx"], "furnace__paper", J.gp(v_h_741, 0.0), J.gp(v_h_741, 1.0), ((J.mul(J.mul(J.gp(env["S"], "H"), 0.22), env["k"]) * J.sub(1.0, env["lick"])) + 0.001), J.add(J.mul(J.gp(env["S"], "fs"), 0.15), v_an_744), 0.5, 0.9])
			v_i_742 = J.num(v_i_742) + 1.0

func _f88(this_, a: Array, env):
	var v_a_730 = null; var v_t_732 = null; var v_pv_734 = null; var v_at_735 = null; var v_flipN_737 = null; var v_g_739 = null
	var _s118 = {"__p": env, "ctx": null, "S": null, "k": null, "lick": null, "fq": null}
	_s118["ctx"] = J.arg(a, 0)
	v_a_730 = J.arg(a, 1)
	var _t729 = _s118["__p"]["begin"]
	_s118["S"] = J.cl(_t729, null, [_s118["ctx"], v_a_730, "baiwu__body", false])
	if (not J.t(_s118["S"])):
		return false
	v_t_732 = J.gp(_s118["S"], "at")
	_s118["k"] = J.gp(_s118["S"], "env")
	v_pv_734 = [0.32, 0.655]
	v_at_735 = J.mc(_s118["S"], "P", J.spread([J.SP(v_pv_734)]))
	var _t730 = _s118["__p"]["bump"]
	_s118["lick"] = J.cl(_t730, null, [J.mod(v_t_732, 3.6), 2.4, 2.65, 3.0])
	v_flipN_737 = floor(J.num(J.mul(v_t_732, 2.6)))
	_s118["fq"] = J.mod(J.mul(v_t_732, 2.6), 1.0)
	var _t731 = _s118["__p"]["ok"]
	if J.t(J.cl(_t731, null, ["baiwu__wpn"])):
		v_g_739 = J.mc(_s118["S"], "P", [0.12, 1.0])
		var _t732 = _s118["__p"]["prop"]
		J.cl(_t732, null, [_s118["ctx"], "baiwu__wpn", J.add(J.gp(v_g_739, 0.0), (J.mul(J.gp(_s118["S"], "fs"), J.gp(_s118["S"], "W")) * 0.05)), J.gp(v_g_739, 1.0), J.mul(J.gp(_s118["S"], "H"), 0.42), J.mul(((-J.num(J.gp(_s118["S"], "fs"))) * 0.12), _s118["k"]), 0.5, 1.0])
	var _t733 = _s118["__p"]["body"]
	J.cl(_t733, null, [_s118["S"], "baiwu", "baiwu__body", {"head": (J.mul(J.gp(_s118["S"], "fs"), _s118["k"]) * ((0.1 - J.mul(_s118["lick"], 0.12)) + (0.02 * sin(J.num(J.mul(v_t_732, 5.2))))))}])
	var _t734 = _s118["__p"]["piece"]
	J.cl(_t734, null, [_s118["S"], "baiwu__arm", v_pv_734, [J.add(J.gp(v_at_735, 0.0), J.mul(J.mul(J.mul(J.gp(_s118["S"], "fs"), (0.03 + J.mul(_s118["lick"], 0.03))), J.gp(_s118["S"], "W")), _s118["k"])), J.sub(J.gp(v_at_735, 1.0), J.mul(J.mul((0.01 + J.mul(_s118["lick"], 0.13)), J.gp(_s118["S"], "H")), _s118["k"]))], (J.mul((-J.num(J.gp(_s118["S"], "fs"))), _s118["k"]) * ((0.12 + J.mul(_s118["lick"], 0.55)) + (0.04 * sin(J.num(J.mul(_s118["fq"], _s118["__p"]["PI"])))))), 1.0, Callable(self, "_f89").bind(_s118)])
	if J.cmp(_s118["k"], 0.5, ">"):
		var _t740 = _s118["__p"]["text"]
		J.cl(_t740, null, [_s118["S"], J.add(J.gp(J.mc(_s118["S"], "P", [0.5, 0.1]), 0.0), (J.mul(J.gp(_s118["S"], "fs"), J.gp(_s118["S"], "W")) * 0.4)), J.gp(J.mc(_s118["S"], "P", [0.5, 0.1]), 1.0), J.gp(["一", "二", "三", "四", "五", "六"], J.mod(v_flipN_737, 6.0)), J.mul(J.gp(_s118["S"], "H"), 0.07), (((J.sub(1.0, _s118["fq"]) * J.sub(1.0, _s118["lick"])) * J.sub(_s118["k"], 0.5)) * 2.0), {"col": "#ffe08a"}])
	var _t741 = _s118["__p"]["end"]
	J.cl(_t741, null, [_s118["S"]])
	return true

func _f90(this_, a: Array, env):
	var v_ctx_747 = null; var v_a_748 = null; var v_S_749 = null; var v_t_750 = null; var v_k_751 = null; var v_pv_752 = null; var v_at_753 = null; var v_lift_754 = null; var v_n_755 = null; var v_hit_756 = null; var v_hit2_757 = null; var v_g_758 = null
	v_ctx_747 = J.arg(a, 0)
	v_a_748 = J.arg(a, 1)
	var _t744 = env["begin"]
	v_S_749 = J.cl(_t744, null, [v_ctx_747, v_a_748, "baiwu__body", false])
	if (not J.t(v_S_749)):
		return false
	v_t_750 = J.gp(v_S_749, "at")
	v_k_751 = J.gp(v_S_749, "env")
	v_pv_752 = [0.32, 0.655]
	v_at_753 = J.mc(v_S_749, "P", J.spread([J.SP(v_pv_752)]))
	var _t745 = env["kf"]
	v_lift_754 = J.cl(_t745, null, [[[0.0, 0.0], [0.5, 1.0], [0.7, 1.1], [0.8, (-0.2)], [1.0, 0.0], [1.3, 0.8], [1.45, (-0.2)], [1.6, 0.0], [2.0, 0.0]], v_t_750])
	var _t746 = env["ok"]
	if J.t(J.cl(_t746, null, ["baiwu__wpn"])):
		v_g_758 = J.mc(v_S_749, "P", [0.12, 1.0])
		var _t747 = env["prop"]
		J.cl(_t747, null, [v_ctx_747, "baiwu__wpn", J.add(J.gp(v_g_758, 0.0), (J.mul(J.gp(v_S_749, "fs"), J.gp(v_S_749, "W")) * 0.05)), J.gp(v_g_758, 1.0), J.mul(J.gp(v_S_749, "H"), 0.42), J.mul(((-J.num(J.gp(v_S_749, "fs"))) * 0.12), v_k_751), 0.5, 1.0])
	var _t748 = env["body"]
	J.cl(_t748, null, [v_S_749, "baiwu", "baiwu__body", {"head": (J.mul(J.gp(v_S_749, "fs"), v_k_751) * (0.14 - J.mul(v_lift_754, 0.04)))}])
	v_n_755 = J.mc(v_S_749, "P", [0.18, 0.8])
	var _t749 = env["prop"]
	J.cl(_t749, null, [v_ctx_747, "furnace__paper", J.gp(v_n_755, 0.0), J.gp(v_n_755, 1.0), (J.mul(J.mul(J.gp(v_S_749, "H"), 0.24), v_k_751) + 0.001), 0.1, 0.5, 0.5])
	v_hit_756 = (1.0 if J.cmp(v_t_750, 0.8, ">") else 0.0)
	v_hit2_757 = (1.0 if J.cmp(v_t_750, 1.45, ">") else 0.0)
	if J.t(v_hit_756):
		J.mc(v_ctx_747, "save", [])
		var _t750 = J.mul(J.gp(v_ctx_747, "globalAlpha"), J.mul(v_k_751, 0.85))
		J.sp(v_ctx_747, "globalAlpha", _t750)
		J.mc(v_ctx_747, "translate", [J.gp(v_n_755, 0.0), J.gp(v_n_755, 1.0)])
		J.mc(v_ctx_747, "rotate", [(-0.2)])
		J.sp(v_ctx_747, "strokeStyle", "#c8202a")
		var _t751 = J.mul(J.gp(v_S_749, "H"), 0.008)
		J.sp(v_ctx_747, "lineWidth", _t751)
		J.mc(v_ctx_747, "strokeRect", [((-J.num(J.gp(v_S_749, "H"))) * 0.035), ((-J.num(J.gp(v_S_749, "H"))) * 0.035), J.mul(J.gp(v_S_749, "H"), 0.07), J.mul(J.gp(v_S_749, "H"), 0.07)])
		var _t752 = ("900 " + J.str(J.mul(J.gp(v_S_749, "H"), 0.05)) + "px " + J.str(env["FONT"]))
		J.sp(v_ctx_747, "font", _t752)
		J.sp(v_ctx_747, "fillStyle", "#c8202a")
		J.sp(v_ctx_747, "textAlign", "center")
		J.sp(v_ctx_747, "textBaseline", "middle")
		if J.t(J.gp(v_S_749, "flip")):
			J.mc(v_ctx_747, "scale", [(-1.0), 1.0])
		J.mc(v_ctx_747, "fillText", ["冥", 0.0, J.mul(J.gp(v_S_749, "H"), 0.002)])
		J.mc(v_ctx_747, "restore", [])
	var _t753 = env["piece"]
	J.cl(_t753, null, [v_S_749, "baiwu__arm", v_pv_752, [J.sub(J.gp(v_at_753, 0.0), J.mul((J.mul(J.gp(v_S_749, "fs"), J.gp(v_S_749, "W")) * 0.02), v_k_751)), (J.sub(J.gp(v_at_753, 1.0), J.mul((J.mul(v_lift_754, J.gp(v_S_749, "H")) * 0.06), v_k_751)) + J.mul(J.mul(J.gp(v_S_749, "H"), 0.03), v_k_751))], (J.mul((-J.num(J.gp(v_S_749, "fs"))), v_k_751) * (0.15 + J.mul(v_lift_754, 0.25)))])
	var _t754 = env["marks"]
	var _t758 = J.gp(v_n_755, 0.0)
	var _t759 = J.sub(J.gp(v_n_755, 1.0), J.mul(J.gp(v_S_749, "H"), 0.05))
	var _t760 = J.mul(J.gp(v_S_749, "H"), 0.06)
	var _t755 = env["bump"]
	var _t757 = J.cl(_t755, null, [v_t_750, 0.78, 0.82, 1.0])
	var _t756 = env["bump"]
	J.cl(_t754, null, [v_ctx_747, _t758, _t759, _t760, J.mul(J.add(_t757, J.cl(_t756, null, [v_t_750, 1.43, 1.47, 1.65])), v_k_751)])
	var _t761 = env["end"]
	J.cl(_t761, null, [v_S_749])
	return true

func _f95(this_, a: Array, env):
	var v_ctx_827 = null; var v_a_828 = null; var v_S_829 = null
	v_ctx_827 = J.arg(a, 0)
	v_a_828 = J.arg(a, 1)
	var _t764 = env["begin"]
	v_S_829 = J.cl(_t764, null, [v_ctx_827, v_a_828, "eguiking__body", false])
	if (not J.t(v_S_829)):
		return false
	var _t765 = env["eguiCook"]
	J.cl(_t765, null, [v_S_829, "stir"])
	var _t766 = env["end"]
	J.cl(_t766, null, [v_S_829])
	return true

func _f96(this_, a: Array, env):
	var v_ctx_832 = null; var v_a_833 = null; var v_S_834 = null
	v_ctx_832 = J.arg(a, 0)
	v_a_833 = J.arg(a, 1)
	var _t769 = env["begin"]
	v_S_834 = J.cl(_t769, null, [v_ctx_832, v_a_833, "eguiking__body", false])
	if (not J.t(v_S_834)):
		return false
	var _t770 = env["eguiCook"]
	J.cl(_t770, null, [v_S_834, "ladle"])
	var _t771 = env["end"]
	J.cl(_t771, null, [v_S_834])
	return true

func _f97(this_, a: Array, env):
	var v_ctx_837 = null; var v_a_838 = null; var v_S_839 = null
	v_ctx_837 = J.arg(a, 0)
	v_a_838 = J.arg(a, 1)
	var _t774 = env["begin"]
	v_S_839 = J.cl(_t774, null, [v_ctx_837, v_a_838, "eguiking__body", false])
	if (not J.t(v_S_839)):
		return false
	var _t775 = env["eguiCook"]
	J.cl(_t775, null, [v_S_839, "taste"])
	var _t776 = env["end"]
	J.cl(_t776, null, [v_S_839])
	return true

func _f99(this_, a: Array, env):
	var v_L_855 = null; var v_h_856 = null; var v_W_857 = null; var v_im_858 = null; var v_ww_859 = null; var v_wh_860 = null
	v_L_855 = J.arg(a, 0)
	v_h_856 = J.cl(v_L_855, null, [0.275, 0.625])
	v_W_857 = J.gp(J.gp(J.G.get("LIMBS_DATA"), "weapons"), J.gp(J.gp(J.gp(J.G.get("LIMBS_DATA"), "chars"), "baiwu"), "weapon"))
	var _t795 = v_W_857
	if J.t(_t795):
		var _t794 = env["__p"]["ok"]
		_t795 = J.cl(_t794, null, [J.gp(v_W_857, "img")])
	if J.t(_t795):
		v_im_858 = J.gp(J.G.get("SPR"), J.gp(v_W_857, "img"))
		v_ww_859 = J.mul(J.gp(v_W_857, "w"), J.gp(env["S"], "H"))
		v_wh_860 = J.mul(J.gp(v_W_857, "h"), J.gp(env["S"], "H"))
		J.mc(env["c"], "save", [])
		J.mc(env["c"], "translate", [J.gp(v_h_856, 0.0), J.gp(v_h_856, 1.0)])
		J.mc(env["c"], "drawImage", [v_im_858, J.mul((-J.num(J.gp(J.gp(v_W_857, "grip"), 0.0))), v_ww_859), J.mul((-J.num(J.gp(J.gp(v_W_857, "grip"), 1.0))), v_wh_860), v_ww_859, v_wh_860])
		J.mc(env["c"], "restore", [])

func _f98(this_, a: Array, env):
	var v_ctx_842 = null; var v_a_843 = null; var v_G_844 = null; var v_t_846 = null; var v_k_847 = null; var v_up_849 = null; var v_w_850 = null; var v_at_851 = null; var v_deep_852 = null; var v_b_853 = null; var v_at_854 = null
	var _s142 = {"__p": env, "S": null, "c": null}
	v_ctx_842 = J.arg(a, 0)
	v_a_843 = J.arg(a, 1)
	v_G_844 = J.gp(_s142["__p"]["GREET"], J.gp(v_a_843, "type"))
	if (not J.t(v_G_844)):
		return false
	var _t779 = _s142["__p"]["begin"]
	_s142["S"] = J.cl(_t779, null, [v_ctx_842, v_a_843, J.gp(v_G_844, "key"), J.gp(v_G_844, "nr")])
	if (not J.t(_s142["S"])):
		return false
	v_t_846 = J.gp(_s142["S"], "at")
	v_k_847 = J.gp(_s142["S"], "env")
	_s142["c"] = J.gp(_s142["S"], "ctx")
	if J.t(J.gp(v_G_844, "wave")):
		var _t780 = _s142["__p"]["kf"]
		v_up_849 = J.mul(v_k_847, J.cl(_t780, null, [[[0.0, 0.0], [0.35, 1.0], [1.4, 1.0], [1.7, 0.2]], v_t_846]))
		var _t782 = sin(J.num(J.mul(v_t_846, 11.0)))
		var _t781 = _s142["__p"]["seg"]
		var _t784 = J.mul(_t782, J.cl(_t781, null, [v_t_846, 0.3, 0.4]))
		var _t783 = _s142["__p"]["seg"]
		v_w_850 = (_t784 * J.sub(1.0, J.cl(_t783, null, [v_t_846, 1.3, 1.5])))
		var _t785 = _s142["__p"]["body"]
		J.cl(_t785, null, [_s142["S"], J.gp(v_a_843, "type"), J.gp(v_G_844, "key"), {"head": (J.mul(J.gp(_s142["S"], "fs"), v_k_847) * ((-0.06) + J.mul(0.03, v_w_850)))}])
		v_at_851 = J.mc(_s142["S"], "P", J.spread([J.SP(J.gp(v_G_844, "pv"))]))
		var _t786 = _s142["__p"]["piece"]
		J.cl(_t786, null, [_s142["S"], J.gp(v_G_844, "arm"), J.gp(v_G_844, "pv"), [J.gp(v_at_851, 0.0), J.sub(J.gp(v_at_851, 1.0), (J.mul(v_up_849, J.gp(_s142["S"], "H")) * 0.04))], (((J.mul(J.gp(_s142["S"], "fs"), v_up_849) * 0.4) if J.seq(J.gp(v_a_843, "type"), "eguiking") else (J.mul((-J.num(J.gp(_s142["S"], "fs"))), v_up_849) * 1.9)) + J.mul(J.mul(v_w_850, 0.22), v_up_849))])
	else:
		v_deep_852 = (0.38 if J.seq(J.gp(v_a_843, "type"), "baiwu") else 0.16)
		var _t787 = _s142["__p"]["kf"]
		v_b_853 = J.mul(v_k_847, J.cl(_t787, null, [[[0.0, 0.0], [0.4, 1.0], [0.9, 1.0], [1.4, 0.0]], v_t_846]))
		J.mc(_s142["c"], "save", [])
		var _t788 = _s142["__p"]["lean"]
		J.cl(_t788, null, [_s142["S"], J.mul(J.mul(J.gp(_s142["S"], "fs"), v_b_853), v_deep_852), 0.25])
		var _t789 = _s142["__p"]["body"]
		J.cl(_t789, null, [_s142["S"], J.gp(v_a_843, "type"), J.gp(v_G_844, "key"), {"head": (J.mul(J.gp(_s142["S"], "fs"), v_b_853) * 0.1)}])
		v_at_854 = J.mc(_s142["S"], "P", J.spread([J.SP(J.gp(v_G_844, "pv"))]))
		var _t790 = J.gp(v_G_844, "staff")
		var _t791 = ((not J.seq(J.typeof_(J.G.get("Limbs")), "undefined")) if J.t(_t790) else _t790)
		if J.t((J.mc(J.G.get("Limbs"), "has", ["baiwu"]) if J.t(_t791) else _t791)):
			J.mc(_s142["c"], "restore", [])
			J.mc(_s142["c"], "save", [])
			var _t792 = _s142["__p"]["lean"]
			J.cl(_t792, null, [_s142["S"], J.mul(J.mul(J.gp(_s142["S"], "fs"), v_b_853), v_deep_852), 0.25])
		var _t793 = _s142["__p"]["piece"]
		J.cl(_t793, null, [_s142["S"], J.gp(v_G_844, "arm"), J.gp(v_G_844, "pv"), v_at_854, 0.0, 1.0, (Callable(self, "_f99").bind(_s142) if J.t(J.gp(v_G_844, "staff")) else null)])
		J.mc(_s142["c"], "restore", [])
	var _t796 = _s142["__p"]["end"]
	J.cl(_t796, null, [_s142["S"]])
	return true

func _f103(this_, a: Array, env):
	var v_ctx_893 = null; var v_a_894 = null; var v_G_895 = null; var v_S_896 = null
	v_ctx_893 = J.arg(a, 0)
	v_a_894 = J.arg(a, 1)
	v_G_895 = J.gp(env["WALK"], J.gp(v_a_894, "type"))
	if (not J.t(v_G_895)):
		return false
	var _t799 = env["begin"]
	v_S_896 = J.cl(_t799, null, [v_ctx_893, v_a_894, J.gp(v_G_895, "key"), J.gp(v_G_895, "nr")])
	if (not J.t(v_S_896)):
		return false
	var _t800 = J.max_([J.gp(v_S_896, "env"), 0.999])
	J.sp(v_S_896, "env", _t800)
	var _t801 = env["walker"]
	J.cl(_t801, null, [v_S_896, v_G_895, {"head": 0.0}])
	var _t802 = env["end"]
	J.cl(_t802, null, [v_S_896])
	return true

func _f104(this_, a: Array, env):
	var v_ctx_899 = null; var v_a_900 = null; var v_G_901 = null; var v_S_902 = null; var v_t_903 = null; var v_rec_904 = null; var v_bow_905 = null; var v_tt_906 = null
	v_ctx_899 = J.arg(a, 0)
	v_a_900 = J.arg(a, 1)
	v_G_901 = J.gp(env["WALK"], J.gp(v_a_900, "type"))
	if (not J.t(v_G_901)):
		return false
	var _t805 = env["begin"]
	v_S_902 = J.cl(_t805, null, [v_ctx_899, v_a_900, J.gp(v_G_901, "key"), J.gp(v_G_901, "nr")])
	if (not J.t(v_S_902)):
		return false
	v_t_903 = J.gp(v_S_902, "at")
	var _t806 = env["kf"]
	v_rec_904 = J.cl(_t806, null, [[[0.0, 0.0], [0.12, 1.0], [0.45, 0.6], [0.6, 0.0]], v_t_903])
	var _t807 = env["bump"]
	var _t809 = J.cl(_t807, null, [v_t_903, 0.6, 0.8, 1.05])
	var _t808 = env["bump"]
	v_bow_905 = J.add(_t809, J.cl(_t808, null, [v_t_903, 1.05, 1.25, 1.5]))
	J.sp(v_S_902, "env", 1.0)
	var _t810 = env["walker"]
	J.cl(_t810, null, [v_S_902, v_G_901, {"lean": ((J.mul((-J.num(J.gp(v_S_902, "fs"))), v_rec_904) * 0.2) + (J.mul(J.gp(v_S_902, "fs"), v_bow_905) * 0.3)), "dx": (J.mul(J.mul((-J.num(J.gp(v_S_902, "fs"))), v_rec_904), J.gp(v_S_902, "H")) * 0.06), "head": (J.mul(J.gp(v_S_902, "fs"), v_bow_905) * 0.15)}])
	var _t811 = env["marks"]
	var _t813 = J.gp(J.mc(v_S_902, "P", [0.5, 0.02]), 0.0)
	var _t814 = J.sub(J.gp(J.mc(v_S_902, "P", [0.5, 0.02]), 1.0), J.mul(J.gp(v_S_902, "H"), 0.04))
	var _t815 = J.mul(J.gp(v_S_902, "H"), 0.12)
	var _t812 = env["bump"]
	J.cl(_t811, null, [v_ctx_899, _t813, _t814, _t815, J.cl(_t812, null, [v_t_903, 0.08, 0.15, 0.55])])
	var _t816 = J.gp(J.gp(v_a_900, "o"), "prop")
	var _t817 = (J.gp(J.gp(J.gp(v_a_900, "o"), "prop"), "sorry") if J.t(_t816) else _t816)
	v_tt_906 = (_t817 if J.t(_t817) else "不好意思")
	var _t818 = env["text"]
	var _t820 = J.gp(J.mc(v_S_902, "P", [0.5, 0.0]), 0.0)
	var _t821 = J.sub(J.gp(J.mc(v_S_902, "P", [0.5, 0.0]), 1.0), J.mul(J.gp(v_S_902, "H"), 0.2))
	var _t822 = J.mul(J.gp(v_S_902, "H"), 0.13)
	var _t819 = env["bump"]
	J.cl(_t818, null, [v_S_902, _t820, _t821, v_tt_906, _t822, J.cl(_t819, null, [v_t_903, 0.65, 0.8, 1.7]), {"col": "#fff6dc"}])
	var _t823 = env["end"]
	J.cl(_t823, null, [v_S_902])
	return true

func _f105(this_, a: Array, env):
	var v_ctx_909 = null; var v_a_910 = null; var v_G_911 = null; var v_S_912 = null; var v_t_913 = null; var v_k_914 = null; var v_scan_915 = null; var v_inq_916 = null
	v_ctx_909 = J.arg(a, 0)
	v_a_910 = J.arg(a, 1)
	v_G_911 = J.gp(env["WALK"], J.gp(v_a_910, "type"))
	if (not J.t(v_G_911)):
		return false
	var _t826 = env["begin"]
	v_S_912 = J.cl(_t826, null, [v_ctx_909, v_a_910, J.gp(v_G_911, "key"), J.gp(v_G_911, "nr")])
	if (not J.t(v_S_912)):
		return false
	v_t_913 = J.gp(v_S_912, "at")
	v_k_914 = J.gp(v_S_912, "env")
	v_scan_915 = sin(J.num(J.mul(v_t_913, 1.6)))
	var _t827 = env["bump"]
	v_inq_916 = J.cl(_t827, null, [v_t_913, 1.6, 1.9, 2.8])
	var _t828 = env["walker"]
	J.cl(_t828, null, [v_S_912, v_G_911, {"lean": (J.mul(J.gp(v_S_912, "fs"), v_k_914) * (0.06 + J.mul(v_inq_916, 0.05))), "head": ((J.mul(J.gp(v_S_912, "fs"), v_k_914) * (0.08 + J.mul(v_scan_915, 0.06))) - (J.mul(v_k_914, v_inq_916) * 0.08)), "arm": (J.mul((-J.num(J.gp(v_S_912, "fs"))), v_k_914) * (0.3 + (0.05 * sin(J.num(J.mul(v_t_913, 3.0))))))}])
	var _t829 = env["text"]
	J.cl(_t829, null, [v_S_912, J.add(J.gp(J.mc(v_S_912, "P", [0.5, 0.0]), 0.0), (J.mul(J.gp(v_S_912, "fs"), J.gp(v_S_912, "W")) * 0.2)), J.sub(J.gp(J.mc(v_S_912, "P", [0.5, 0.0]), 1.0), J.mul(J.gp(v_S_912, "H"), 0.08)), "哦？", J.mul(J.gp(v_S_912, "H"), 0.13), J.mul(v_inq_916, v_k_914)])
	var _t830 = env["end"]
	J.cl(_t830, null, [v_S_912])
	return true

func _f111(this_, a: Array, env):
	var v_st_939 = null
	v_st_939 = J.arg(a, 0)
	var _t832 = (J.gp(v_st_939, "act") if J.t(v_st_939) else v_st_939)
	var _t837 = null
	if J.t((J.cmp(J.gp(v_st_939, "w"), 0.0, ">") if J.t(_t832) else _t832)):
		var _t834 = J.gp(v_st_939, "act")
		var _t835 = J.gp(v_st_939, "at")
		var _t836 = J.gp(v_st_939, "dur")
		var _t833 = env["ss"]
		_t837 = {"act": _t834, "at": _t835, "adur": _t836, "aw": J.cl(_t833, null, [J.gp(v_st_939, "w")])}
	else:
		_t837 = {}
	return _t837

func _f113(this_, a: Array, env):
	var v_n_951 = null; var v_o_952 = null
	v_n_951 = J.arg(a, 0)
	var _t838 = env["opts"]
	v_o_952 = J.cl(_t838, null, [J.gp(v_n_951, "daily")])
	var _t839 = J.gp(v_o_952, "act")
	var _t840 = (J.gp(v_n_951, "bub") if J.t(_t839) else _t839)
	if J.t((J.cmp(J.gp(v_n_951, "bubT"), 0.0, ">") if J.t(_t840) else _t840)):
		J.sp(v_o_952, "quiet", true)
	return v_o_952

func _f114(this_, a: Array, env):
	var v_n_953 = null
	v_n_953 = J.arg(a, 0)
	var _t841 = J.gp(env["ACT"], J.gp(J.gp(v_n_953, "d"), "spr"))
	var _t842 = J.gp((_t841 if J.t(_t841) else {}), J.gp(v_n_953, "act"))
	return (_t842 if J.t(_t842) else null)

func _f1(this_, a: Array, env):
	var v_D_3 = null; var v_eo_8 = null; var v_eo3_9 = null; var v_beamSpot_39 = null; var v_npcTick_66 = null; var v_npcOpts_67 = null; var v_actAnim_68 = null
	var _s2 = {"__p": env, "PI": null, "cl": null, "lerp": null, "ss": null, "seg": null, "bump": null, "kf": null, "rnd": null, "ok": null, "FONT": null, "begin": null, "end": null, "mpose": null, "body": null, "lean": null, "piece": null, "prop": null, "rotP": null, "crayon": null, "text": null, "puff": null, "steamCurl": null, "drop": null, "sparkle": null, "zzz": null, "marks": null, "anger": null, "KEN": null, "kenDraw": null, "kenFace": null, "BOSS": null, "bossDraw": null, "GU": null, "guardDraw": null, "IKC": null, "guardSip": null, "AU": null, "auAxis": null, "auHead": null, "auReach": null, "HEAD0": null, "auMop": null, "resid": null, "WR": null, "auntieDraw": null, "auTh": null, "loop": null, "meshBody": null, "eguiPot": null, "noodles": null, "strainer": null, "eguiCook": null, "GREET": null, "WALK": null, "hang": null, "walker": null, "LIST": null, "tick": null, "opts": null, "ACT": null}
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
	v_npcTick_66 = Callable(self, "_f112").bind(_s2)
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
	var _t382 = J.G.get("DAILY")
	var _t389 = Callable(self, "_f35").bind(_s2)
	J.sp(_t382, "town_ken_scroll", _t389)
	var _t390 = J.G.get("DAILY")
	var _t411 = Callable(self, "_f36").bind(_s2)
	J.sp(_t390, "town_ken_yawn", _t411)
	var _t412 = J.G.get("DAILY")
	var _t420 = Callable(self, "_f37").bind(_s2)
	J.sp(_t412, "town_ken_rub", _t420)
	var _t421 = J.G.get("DAILY")
	var _t437 = Callable(self, "_f38").bind(_s2)
	J.sp(_t421, "town_ken_sigh", _t437)
	_s2["BOSS"] = {"EL": [0.23, 0.56], "BALL": [0.12, 0.27], "SH": [0.775, 0.475], "HAND": [0.835, 0.75], "WATCH": [0.8, 0.63], "MOUTH": [0.39, 0.315]}
	var _t438 = J.G.get("DAILY")
	var _t482 = Callable(self, "_f41").bind(_s2)
	J.sp(_t438, "town_boss_polish", _t482)
	var _t483 = J.G.get("DAILY")
	var _t499 = Callable(self, "_f43").bind(_s2)
	J.sp(_t483, "town_boss_watch", _t499)
	var _t500 = J.G.get("DAILY")
	var _t511 = Callable(self, "_f44").bind(_s2)
	J.sp(_t500, "town_boss_call", _t511)
	var _t512 = J.G.get("DAILY")
	var _t516 = Callable(self, "_f46").bind(_s2)
	J.sp(_t512, "town_boss_admire", _t516)
	_s2["GU"] = {"FL": [0.33, 0.53], "FTIP": [0.06, 0.66], "SH": [0.882, 0.4565], "WR": [0.885, 0.578], "CAP": [0.745, 0.465], "MOUTH": [0.5, 0.335]}
	var _t517 = J.G.get("DAILY")
	var _t521 = Callable(self, "_f49").bind(_s2)
	J.sp(_t517, "town_guard_patrol", _t521)
	_s2["IKC"] = {}
	var _t522 = J.G.get("DAILY")
	var _t526 = Callable(self, "_f52").bind(_s2)
	J.sp(_t522, "town_guard_sip", _t526)
	var _t527 = J.G.get("DAILY")
	var _t541 = Callable(self, "_f53").bind(_s2)
	J.sp(_t527, "town_guard_doze", _t541)
	_s2["AU"] = {"FIST": [0.275, 0.512], "TOP": [0.235, 0.34], "BOT": [0.37, 0.95], "HEAD": [0.1, 0.4], "SH": [0.765, 0.43], "HAND": [0.735, 0.595]}
	_s2["HEAD0"] = atan2(J.num(J.sub(J.gp(J.gp(_s2["AU"], "TOP"), 1.0), J.gp(J.gp(_s2["AU"], "FIST"), 1.0))), J.num(J.sub(J.gp(J.gp(_s2["AU"], "TOP"), 0.0), J.gp(J.gp(_s2["AU"], "FIST"), 0.0))))
	_s2["resid"] = Callable(self, "_f59").bind(_s2)
	_s2["WR"] = [0.386, 0.526]
	_s2["auTh"] = Callable(self, "_f61").bind(_s2)
	var _t544 = J.G.get("DAILY")
	var _t554 = Callable(self, "_f62").bind(_s2)
	J.sp(_t544, "town_auntie_mop", _t554)
	var _t555 = J.G.get("DAILY")
	var _t571 = Callable(self, "_f64").bind(_s2)
	J.sp(_t555, "town_auntie_wring", _t571)
	var _t572 = J.G.get("DAILY")
	var _t597 = Callable(self, "_f67").bind(_s2)
	J.sp(_t572, "town_auntie_grumble", _t597)
	_s2["loop"] = Callable(self, "_f68").bind(_s2)
	var _t598 = J.G.get("DAILY")
	var _t606 = Callable(self, "_f69").bind(_s2)
	J.sp(_t598, "office_boss_present", _t606)
	var _t607 = J.G.get("DAILY")
	var _t614 = Callable(self, "_f70").bind(_s2)
	J.sp(_t607, "office_boss_read", _t614)
	var _t615 = J.G.get("DAILY")
	var _t622 = Callable(self, "_f72").bind(_s2)
	J.sp(_t615, "office_boss_phone", _t622)
	var _t623 = J.G.get("DAILY")
	var _t631 = Callable(self, "_f74").bind(_s2)
	J.sp(_t623, "office_boss_pack", _t631)
	var _t632 = J.G.get("DAILY")
	var _t645 = Callable(self, "_f75").bind(_s2)
	J.sp(_t632, "town_guard_dozeL", _t645)
	var _t646 = J.G.get("DAILY")
	var _t651 = Callable(self, "_f76").bind(_s2)
	J.sp(_t646, "office_ken_nap", _t651)
	var _t652 = J.G.get("DAILY")
	var _t658 = Callable(self, "_f78").bind(_s2)
	J.sp(_t652, "office_it_notes", _t658)
	var _t659 = J.G.get("DAILY")
	var _t667 = Callable(self, "_f79").bind(_s2)
	J.sp(_t659, "office_it_pack", _t667)
	var _t668 = J.G.get("DAILY")
	var _t678 = Callable(self, "_f80").bind(_s2)
	J.sp(_t668, "office_auntie_pack", _t678)
	var _t679 = J.G.get("DAILY")
	var _t691 = Callable(self, "_f81").bind(_s2)
	J.sp(_t679, "town_paper_fold", _t691)
	var _t692 = J.G.get("DAILY")
	var _t702 = Callable(self, "_f83").bind(_s2)
	J.sp(_t692, "town_paper_arrange", _t702)
	var _t703 = J.G.get("DAILY")
	var _t709 = Callable(self, "_f84").bind(_s2)
	J.sp(_t703, "town_haggle_polish", _t709)
	var _t710 = J.G.get("DAILY")
	var _t727 = Callable(self, "_f86").bind(_s2)
	J.sp(_t710, "town_haggle_squint", _t727)
	var _t728 = J.G.get("DAILY")
	var _t742 = Callable(self, "_f88").bind(_s2)
	J.sp(_t728, "town_exch_count", _t742)
	var _t743 = J.G.get("DAILY")
	var _t762 = Callable(self, "_f90").bind(_s2)
	J.sp(_t743, "town_exch_stamp", _t762)
	var _t763 = J.G.get("DAILY")
	var _t767 = Callable(self, "_f95").bind(_s2)
	J.sp(_t763, "town_food_stir", _t767)
	var _t768 = J.G.get("DAILY")
	var _t772 = Callable(self, "_f96").bind(_s2)
	J.sp(_t768, "town_food_ladle", _t772)
	var _t773 = J.G.get("DAILY")
	var _t777 = Callable(self, "_f97").bind(_s2)
	J.sp(_t773, "town_food_taste", _t777)
	_s2["GREET"] = {"xiaozhi": {"key": "xiaozhi__body", "arm": "xiaozhi__arm", "pv": [0.315, 0.535], "nr": false, "wave": 1.0}, "xiaogui": {"key": "xiaogui__body", "arm": "xiaogui__arm", "pv": [0.61, 0.585], "nr": true, "wave": 0.0}, "baiwu": {"key": "baiwu__body", "arm": "baiwu__arm", "pv": [0.32, 0.655], "nr": false, "wave": 0.0, "staff": 1.0}, "eguiking": {"key": "eguiking__body", "arm": "eguiking__arm", "pv": [0.12, 0.5], "nr": false, "wave": 1.0}}
	var _t778 = J.G.get("DAILY")
	var _t797 = Callable(self, "_f98").bind(_s2)
	J.sp(_t778, "town_greet", _t797)
	_s2["WALK"] = {"youhun": {"key": "youhun__body", "arm": "youhun__arm", "pv": [0.245, 0.47], "tip": [0.04, 0.55], "nr": false}, "egui": {"key": "egui__body", "arm": "egui__arm", "pv": [0.56, 0.44], "tip": [0.74, 0.27], "nr": true}, "zombie": {"key": "zombie__body", "arm": "zombie__arm", "pv": [0.27, 0.56], "tip": [0.06, 0.57], "nr": false}, "shuigui": {"key": "shuigui__body", "arm": "shuigui__arm", "pv": [0.72, 0.53], "tip": [0.92, 0.53], "nr": true}}
	var _t798 = J.G.get("DAILY")
	var _t803 = Callable(self, "_f103").bind(_s2)
	J.sp(_t798, "town_walk", _t803)
	var _t804 = J.G.get("DAILY")
	var _t824 = Callable(self, "_f104").bind(_s2)
	J.sp(_t804, "town_bump", _t824)
	var _t825 = J.G.get("DAILY")
	var _t831 = Callable(self, "_f105").bind(_s2)
	J.sp(_t825, "town_look", _t831)
	_s2["LIST"] = {"npc_ken": [["town_ken_scroll", 5.0, [4.0, 7.0], 0.0], ["town_ken_yawn", 1.3, [3.3, 3.3], 9.0], ["town_ken_rub", 1.1, [2.9, 2.9], 8.0], ["town_ken_sigh", 1.1, [3.1, 3.1], 8.0]], "npc_boss": [["town_boss_admire", 2.5, [2.5, 4.5], 0.0], ["town_boss_polish", 2.0, [3.7, 3.7], 6.0], ["town_boss_watch", 1.5, [2.9, 2.9], 8.0], ["town_boss_call", 1.2, [4.0, 4.0], 12.0]], "npc_guard": [["town_guard_patrol", 3.0, [3.0, 5.0], 0.0, "walk"], ["town_guard_sip", 1.5, [3.3, 3.3], 8.0], ["town_guard_doze", 1.0, [4.3, 4.3], 14.0]], "npc_auntie": [["town_auntie_mop", 2.0, [2.2, 3.5], 0.0, "walk"], ["town_auntie_wring", 1.5, [2.3, 2.3], 6.0], ["town_auntie_grumble", 1.4, [2.3, 2.3], 7.0]], "xiaozhi": [["town_paper_fold", 3.0, [4.8, 7.2], 0.0], ["town_paper_arrange", 2.0, [4.4, 6.6], 4.0]], "xiaogui": [["town_haggle_polish", 3.0, [3.0, 5.0], 0.0], ["town_haggle_squint", 2.0, [3.1, 3.1], 6.0]], "baiwu": [["town_exch_count", 3.0, [3.6, 7.2], 0.0], ["town_exch_stamp", 1.5, [2.1, 2.1], 5.0]], "eguiking": [["town_food_stir", 3.0, [3.0, 5.0], 0.0], ["town_food_ladle", 2.0, [3.0, 6.0], 3.0], ["town_food_taste", 1.3, [3.3, 3.3], 10.0]]}
	_s2["opts"] = Callable(self, "_f111").bind(_s2)
	_s2["ACT"] = {"npc_boss": {"present": "office_boss_present", "read": "office_boss_read", "call": "office_boss_phone", "pack": "office_boss_pack"}, "npc_guard": {"doze": "town_guard_dozeL"}, "npc_ken": {"brk_nap": "office_ken_nap"}, "npc_it": {"notes": "office_it_notes", "pack": "office_it_pack"}, "npc_auntie": {"pack": "office_auntie_pack"}}
	v_npcOpts_67 = Callable(self, "_f113").bind(_s2)
	v_actAnim_68 = Callable(self, "_f114").bind(_s2)
	return {"tick": _s2["tick"], "opts": _s2["opts"], "npcTick": v_npcTick_66, "npcOpts": v_npcOpts_67, "LIST": _s2["LIST"], "ACT": _s2["ACT"], "actAnim": v_actAnim_68}
