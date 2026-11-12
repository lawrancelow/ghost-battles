# 自動轉譯自 moves_chain.js（tools/jsgd.js）——唔好直接改，改原 JS 再轉
extends RefCounted

func run(env):
	var this_ = null; var a = []
	J.G["MoveKit"] = J.cl(Callable(self, "_f1").bind(env), null, [])
	var _t99 = J.G.get("MOVES")
	var _t147 = Callable(self, "_f43").bind(env)
	J.sp(_t99, "heiwu", _t147)

func _f13(this_, a: Array, env):
	var v_o_52 = null; var v_p_53 = null
	v_o_52 = J.arg(a, 0)
	var _t1 = env["cl"]
	var _t2 = J.gp(v_o_52, "pt")
	v_p_53 = J.cl(_t1, null, [(_t2 if J.t(_t2) else 0.0)])
	var _t3 = J.gp(v_o_52, "pose")
	var _t4 = -1
	var _t5 = false
	if _t4 == -1 and J.seq(_t3, "windup"): _t4 = 0
	if _t4 == -1 and J.seq(_t3, "strike"): _t4 = 1
	if _t4 == -1 and J.seq(_t3, "follow"): _t4 = 2
	if _t4 == -1 and J.seq(_t3, "recover"): _t4 = 3
	while true:
		if _t4 <= 0 and _t4 >= 0:
			return J.mul(v_p_53, env["TW"])
		if _t4 <= 1 and _t4 >= 0:
			return J.add(env["TW"], J.mul(v_p_53, env["TS"]))
		if _t4 <= 2 and _t4 >= 0:
			return J.add(env["TW"], J.mul((0.42 + J.mul(0.58, v_p_53)), env["TS"]))
		if _t4 <= 3 and _t4 >= 0:
			return J.add(J.add(env["TW"], env["TS"]), J.mul(v_p_53, env["TR"]))
		break
	return 0.0

func _f15(this_, a: Array, env):
	var v_q_62 = null
	v_q_62 = J.arg(a, 0)
	var _t8 = env["cl"]
	return (1.0 - pow(J.num(J.sub(1.0, J.cl(_t8, null, [v_q_62]))), J.num(3.0)))

func _f16(this_, a: Array, env):
	var v_q_63 = null
	v_q_63 = J.arg(a, 0)
	var _t9 = env["cl"]
	var _t10 = J.cl(_t9, null, [v_q_63])
	v_q_63 = _t10
	return (J.mul(J.mul(J.mul(4.0, v_q_63), v_q_63), v_q_63) if J.cmp(v_q_63, 0.5, "<") else (1.0 - J.div(pow(J.num((J.mul((-2.0), v_q_63) + 2.0)), J.num(3.0)), 2.0)))

func _f14(this_, a: Array, env):
	var v_o_56 = null; var v_s_57 = null; var v_p_58 = null; var v_eo_59 = null; var v_io_60 = null; var v_L_61 = null
	v_o_56 = J.arg(a, 0)
	v_s_57 = J.arg(a, 1)
	if J.leq(J.gp(v_o_56, "tdx"), null):
		return 0.0
	var _t6 = env["cl"]
	var _t7 = J.gp(v_o_56, "pt")
	v_p_58 = J.cl(_t6, null, [(_t7 if J.t(_t7) else 0.0)])
	v_eo_59 = Callable(self, "_f15").bind(env)
	v_io_60 = Callable(self, "_f16").bind(env)
	v_L_61 = (12.0 if J.cmp(v_s_57, 1.5, ">") else (6.0 if J.cmp(v_s_57, 1.0, "<") else 9.0))
	if J.seq(J.gp(v_o_56, "pose"), "windup"):
		return J.mul((-2.0), J.cl(v_eo_59, null, [v_p_58]))
	if J.seq(J.gp(v_o_56, "pose"), "strike"):
		return J.mul(v_L_61, J.cl(v_eo_59, null, [J.mul(v_p_58, 2.4)]))
	if J.seq(J.gp(v_o_56, "pose"), "follow"):
		return v_L_61
	if J.seq(J.gp(v_o_56, "pose"), "recover"):
		return J.mul(v_L_61, J.sub(1.0, J.cl(v_io_60, null, [v_p_58])))
	return 0.0

func _f18(this_, a: Array, env):
	var v_q_74 = null
	v_q_74 = J.arg(a, 0)
	return (1.0 - pow(J.num(J.sub(1.0, v_q_74)), J.num(3.0)))

func _f19(this_, a: Array, env):
	var v_q_75 = null
	v_q_75 = J.arg(a, 0)
	return (J.mul(J.mul(J.mul(4.0, v_q_75), v_q_75), v_q_75) if J.cmp(v_q_75, 0.5, "<") else (1.0 - J.div(pow(J.num((J.mul((-2.0), v_q_75) + 2.0)), J.num(3.0)), 2.0)))

func _f17(this_, a: Array, env):
	var v_tt_66 = null; var v_th_67 = null; var v_p_68 = null; var v_kb_69 = null; var v_p2_70 = null; var v_k_71 = null; var v_eo_72 = null; var v_io_73 = null
	v_tt_66 = J.arg(a, 0)
	v_th_67 = J.arg(a, 1)
	v_p_68 = J.div(J.sub(v_tt_66, env["TC"]), 0.3)
	if J.cmp(v_p_68, 0.0, "<="):
		return 0.0
	v_kb_69 = 0.0
	if J.cmp(v_p_68, 1.0, "<"):
		v_eo_72 = Callable(self, "_f18").bind(env)
		v_io_73 = Callable(self, "_f19").bind(env)
		var _t11 = (J.cl(v_eo_72, null, [J.div(v_p_68, 0.25)]) if J.cmp(v_p_68, 0.25, "<") else J.sub(1.0, J.cl(v_io_73, null, [J.div(J.sub(v_p_68, 0.25), 0.75)])))
		v_kb_69 = _t11
	v_p2_70 = J.div(J.sub(v_tt_66, env["TC"]), 0.25)
	v_k_71 = (0.0 if J.cmp(v_p2_70, 1.0, ">=") else (J.div(v_p2_70, 0.15) if J.cmp(v_p2_70, 0.15, "<") else J.max_([0.0, (1.0 - J.div(J.sub(v_p2_70, 0.15), 0.85))])))
	return (J.mul(v_kb_69, 9.0) + J.mul(J.mul(0.07, v_th_67), v_k_71))

func _f29(this_, a: Array, env):
	var v_a_118 = null; var v_id_119 = null; var v_o_120 = null; var v_img_121 = null; var v_fw_122 = null; var v_s_123 = null; var v_H_124 = null; var v_W_125 = null; var v_nr_126 = null; var v_tt_127 = null; var v_lg_128 = null; var v_th_129 = null; var v_tx_130 = null; var v_ty_131 = null; var v_fl_132 = null
	v_a_118 = J.arg(a, 0)
	v_id_119 = J.gp(v_a_118, "type")
	v_o_120 = J.gp(v_a_118, "o")
	v_img_121 = J.gp(J.G.get("SPR"), J.add(v_id_119, "__body"))
	var _t12 = env["ok"]
	var _t14 = (not J.t(J.cl(_t12, null, [J.add(v_id_119, "__body")])))
	if not J.t(_t14):
		var _t13 = env["ok"]
		_t14 = (not J.t(J.cl(_t13, null, [J.add(v_id_119, "__arm")])))
	var _t15 = (_t14 if _t14 else J.seq(J.typeof_(J.G.get("MeshAnim")), "undefined"))
	var _t16 = (_t15 if _t15 else J.seq(J.typeof_(J.G.get("LIMBS_DATA")), "undefined"))
	if (_t16 if _t16 else (not J.t(J.gp(J.gp(J.G.get("LIMBS_DATA"), "chars"), v_id_119)))):
		return null
	v_fw_122 = (1.0 if J.t(J.gp(v_a_118, "faceRight")) else (-1.0))
	v_s_123 = J.gp(v_a_118, "s")
	v_H_124 = J.gp(v_a_118, "H")
	v_W_125 = J.div(J.mul(v_H_124, J.gp(v_img_121, "naturalWidth")), J.gp(v_img_121, "naturalHeight"))
	var _t17 = J.gp(J.G.get("MeshAnim"), "NATIVE_R")
	var _t18 = J.gp((_t17 if J.t(_t17) else {}), v_id_119)
	v_nr_126 = (not (not J.t((_t18 if J.t(_t18) else J.gp(J.gp(J.gp(J.G.get("LIMBS_DATA"), "chars"), v_id_119), "nativeR")))))
	var _t19 = env["tau"]
	v_tt_127 = J.cl(_t19, null, [v_o_120])
	var _t20 = env["lungeOf"]
	v_lg_128 = J.cl(_t20, null, [v_o_120, v_s_123])
	v_th_129 = J.mul(58.0, v_s_123)
	v_tx_130 = J.sub((J.mul(J.gp(v_o_120, "tdx"), v_fw_122) if (not J.leq(J.gp(v_o_120, "tdx"), null)) else J.mul(44.0, v_s_123)), v_lg_128)
	var _t21 = J.gp(v_o_120, "tdy")
	v_ty_131 = (_t21 if J.t(_t21) else 0.0)
	var _t23 = null
	if J.t(J.gp(v_a_118, "solid")):
		_t23 = 0.0
	else:
		var _t22 = J.gp(v_o_120, "t")
		_t23 = J.mul((3.0 + (sin(J.num(J.mul((_t22 if J.t(_t22) else 0.0), 2.4))) * 2.0)), v_s_123)
	v_fl_132 = _t23
	var _t24 = J.gp(v_o_120, "t")
	return {"a": v_a_118, "id": v_id_119, "o": v_o_120, "fw": v_fw_122, "s": v_s_123, "H": v_H_124, "W": v_W_125, "nr": v_nr_126, "tt": v_tt_127, "tx": v_tx_130, "ty": v_ty_131, "th": v_th_129, "fl": v_fl_132, "t": (_t24 if J.t(_t24) else 0.0), "C": J.gp(J.gp(J.G.get("LIMBS_DATA"), "chars"), v_id_119), "solid": J.gp(v_a_118, "solid")}

func _f30(this_, a: Array, env):
	var v_ctx_135 = null; var v_K_136 = null
	v_ctx_135 = J.arg(a, 0)
	v_K_136 = J.arg(a, 1)
	J.mc(v_ctx_135, "translate", [J.gp(J.gp(v_K_136, "a"), "x"), J.gp(J.gp(v_K_136, "a"), "y")])
	J.mc(v_ctx_135, "scale", [J.gp(v_K_136, "fw"), 1.0])

func _f32(this_, a: Array, env):
	var v_K_142 = null; var v_extra_143 = null; var v_idleK_144 = null; var v_z_145 = null; var v_k_146 = null; var v_b_147 = null; var v_k_148 = null; var v_v_149 = null
	v_K_142 = J.arg(a, 0)
	v_extra_143 = J.arg(a, 1)
	v_idleK_144 = J.arg(a, 2)
	var _t25 = J.gp(J.G.get("MeshAnim"), "ANIM")
	v_z_145 = J.mc(_t25, "idle", [J.gp(v_K_142, "t")])
	if (not J.leq(v_idleK_144, null)):
		for _t26 in J.keys(v_z_145):
			v_k_146 = _t26
			if J.seq(J.typeof_(J.gp(v_z_145, v_k_146)), "number"):
				var _t27 = J.seq(v_k_146, "sx")
				var _t28 = ((1.0 + J.mul(J.sub(J.gp(v_z_145, v_k_146), 1.0), v_idleK_144)) if (_t27 if _t27 else J.seq(v_k_146, "sy")) else J.mul(J.gp(v_z_145, v_k_146), v_idleK_144))
				J.sp(v_z_145, v_k_146, _t28)
	J.sp(v_z_145, "armF", 0.0)
	J.sp(v_z_145, "axe", 0.0)
	J.sp(v_z_145, "body", 0.0)
	J.sp(v_z_145, "x", 0.0)
	if J.t(J.gp(J.gp(v_K_142, "C"), "still")):
		for _t29 in J.iter(J.gp(J.gp(v_K_142, "C"), "still")):
			v_b_147 = _t29
			J.sp(v_z_145, v_b_147, 0.0)
	if J.t(v_extra_143):
		for _t30 in J.keys(v_extra_143):
			v_k_148 = _t30
			v_v_149 = J.gp(v_extra_143, v_k_148)
			var _t34 = null
			if J.t(J.gp(env["KEEP"], v_k_148)):
				var _t32 = null
				if J.seq(v_k_148, "y"):
					var _t31 = J.gp(v_z_145, v_k_148)
					_t32 = J.add((_t31 if J.t(_t31) else 0.0), v_v_149)
				else:
					_t32 = v_v_149
				_t34 = _t32
			else:
				var _t33 = J.gp(v_z_145, v_k_148)
				_t34 = J.add((_t33 if J.t(_t33) else 0.0), (v_v_149 if J.t(J.gp(v_K_142, "nr")) else (-J.num(v_v_149))))
			J.sp(v_z_145, v_k_148, _t34)
	return v_z_145

func _f33(this_, a: Array, env):
	var v_ctx_152 = null; var v_K_153 = null; var v_m_154 = null; var v_mp_155 = null; var v_key_156 = null
	v_ctx_152 = J.arg(a, 0)
	v_K_153 = J.arg(a, 1)
	v_m_154 = J.arg(a, 2)
	v_mp_155 = J.arg(a, 3)
	v_key_156 = J.arg(a, 4)
	J.mc(v_ctx_152, "save", [])
	J.mc(v_m_154, "set", [v_ctx_152])
	if (not J.t(J.gp(v_K_153, "nr"))):
		J.mc(v_ctx_152, "scale", [(-1.0), 1.0])
	J.mc(J.G.get("MeshAnim"), "drawBody", [v_ctx_152, J.gp(v_K_153, "id"), (v_key_156 if J.t(v_key_156) else J.add(J.gp(v_K_153, "id"), "__body")), J.gp(v_K_153, "H"), v_mp_155])
	J.mc(v_ctx_152, "restore", [])

func _f34(this_, a: Array, env):
	var v_ctx_159 = null; var v_K_160 = null; var v_key_161 = null; var v_m_162 = null; var v_pu_163 = null; var v_pv_164 = null; var v_alpha_165 = null
	v_ctx_159 = J.arg(a, 0)
	v_K_160 = J.arg(a, 1)
	v_key_161 = J.arg(a, 2)
	v_m_162 = J.arg(a, 3)
	v_pu_163 = J.arg(a, 4)
	v_pv_164 = J.arg(a, 5)
	v_alpha_165 = J.arg(a, 6)
	var _t35 = env["ok"]
	if (not J.t(J.cl(_t35, null, [v_key_161]))):
		return null
	J.mc(v_ctx_159, "save", [])
	J.mc(v_m_162, "set", [v_ctx_159])
	if (not J.t(J.gp(v_K_160, "nr"))):
		J.mc(v_ctx_159, "scale", [(-1.0), 1.0])
	if (not J.leq(v_alpha_165, null)):
		var _t36 = J.mul(J.gp(v_ctx_159, "globalAlpha"), v_alpha_165)
		J.sp(v_ctx_159, "globalAlpha", _t36)
	J.mc(v_ctx_159, "drawImage", [J.gp(J.G.get("SPR"), v_key_161), J.mul((-J.num(v_pu_163)), J.gp(v_K_160, "W")), J.mul((-J.num(v_pv_164)), J.gp(v_K_160, "H")), J.gp(v_K_160, "W"), J.gp(v_K_160, "H")])
	J.mc(v_ctx_159, "restore", [])

func _f36(this_, a: Array, env):
	var v_ctx_174 = null; var v_K_175 = null; var v_x_176 = null; var v_y_177 = null; var v_k_178 = null
	v_ctx_174 = J.arg(a, 0)
	v_K_175 = J.arg(a, 1)
	v_x_176 = J.arg(a, 2)
	v_y_177 = J.arg(a, 3)
	v_k_178 = J.arg(a, 4)
	if J.seq(J.gp(J.gp(v_K_175, "o"), "shadow"), false):
		return null
	J.mc(v_ctx_174, "save", [])
	if (not J.t(J.gp(v_K_175, "solid"))):
		var _t37 = J.mul(J.gp(v_ctx_174, "globalAlpha"), 0.55)
		J.sp(v_ctx_174, "globalAlpha", _t37)
	J.sp(v_ctx_174, "fillStyle", "rgba(0,0,0,.35)")
	J.mc(v_ctx_174, "beginPath", [])
	J.mc(v_ctx_174, "ellipse", [v_x_176, J.add(v_y_177, J.gp(v_K_175, "s")), J.mul(J.mul(14.0, J.gp(v_K_175, "s")), (v_k_178 if J.t(v_k_178) else (1.0 if J.t(J.gp(v_K_175, "solid")) else 0.8))), J.mul(J.mul(4.0, J.gp(v_K_175, "s")), (v_k_178 if J.t(v_k_178) else (1.0 if J.t(J.gp(v_K_175, "solid")) else 0.8))), 0.0, 0.0, 7.0])
	J.mc(v_ctx_174, "fill", [])
	J.mc(v_ctx_174, "restore", [])

func _f38(this_, a: Array, env):
	var v_ctx_183 = null; var v_e_184 = null
	v_ctx_183 = J.arg(a, 0)
	v_e_184 = J.arg(a, 1)
	J.mc(v_ctx_183, "beginPath", [])
	J.mc(v_ctx_183, "rect", [(-5000.0), (-5000.0), 10000.0, 10000.0])
	J.mc(v_ctx_183, "ellipse", [J.gp(v_e_184, "x"), J.gp(v_e_184, "y"), J.gp(v_e_184, "rx"), J.gp(v_e_184, "ry"), 0.0, 0.0, 7.0])
	J.mc(v_ctx_183, "clip", ["evenodd"])

func _f40(this_, a: Array, env):
	var v_p_194 = null; var v_i_195 = null; var v_j_196 = null
	v_p_194 = J.arg(a, 0)
	v_i_195 = J.arg(a, 1)
	var _t45 = env["__p"]["__p"]["rnd"]
	v_j_196 = (J.mul(J.sub(J.cl(_t45, null, [J.add(J.add(env["__p"]["seed"], J.mul(v_i_195, 7.0)), J.mul(env["pass"], 31.0))]), 0.5), env["__p"]["w"]) * 0.5)
	if J.t(v_i_195):
		J.mc(env["__p"]["ctx"], "lineTo", [J.add(J.gp(v_p_194, 0.0), v_j_196), J.sub(J.gp(v_p_194, 1.0), v_j_196)])
	else:
		J.mc(env["__p"]["ctx"], "moveTo", [J.add(J.gp(v_p_194, 0.0), v_j_196), J.add(J.gp(v_p_194, 1.0), v_j_196)])

func _f39(this_, a: Array, env):
	var v_pts_188 = null; var v_col_189 = null; var v_alpha_192 = null
	var _s46 = {"__p": env, "ctx": null, "w": null, "seed": null}
	_s46["ctx"] = J.arg(a, 0)
	v_pts_188 = J.arg(a, 1)
	v_col_189 = J.arg(a, 2)
	_s46["w"] = J.arg(a, 3)
	_s46["seed"] = J.arg(a, 4)
	v_alpha_192 = J.arg(a, 5)
	if (J.len(v_pts_188) < 2.0):
		return null
	J.mc(_s46["ctx"], "save", [])
	var _t38 = _s46["ctx"]
	J.sp(_t38, "lineCap", "round")
	var _t39 = _s46["ctx"]
	J.sp(_t39, "lineJoin", "round")
	var _t40 = _s46["ctx"]
	J.sp(_t40, "strokeStyle", v_col_189)
	var _s47 = {"__p": _s46, "pass": null}
	_s47["pass"] = 0.0
	while true:
		_s47 = _s47.duplicate()
		if not J.cmp(_s47["pass"], 2.0, "<"): break
		var _t41 = _s47["__p"]["ctx"]
		var _t42 = J.mul(J.gp(_t41, "globalAlpha"), (0.55 if J.t(_s47["pass"]) else 1.0))
		J.sp(_t41, "globalAlpha", _t42)
		var _t43 = _s47["__p"]["ctx"]
		var _t44 = J.mul(_s47["__p"]["w"], (0.55 if J.t(_s47["pass"]) else 1.0))
		J.sp(_t43, "lineWidth", _t44)
		J.mc(_s47["__p"]["ctx"], "beginPath", [])
		J.mc(v_pts_188, "forEach", [Callable(self, "_f40").bind(_s47)])
		J.mc(_s47["__p"]["ctx"], "stroke", [])
		_s47["pass"] = J.num(_s47["pass"]) + 1.0
	J.mc(_s46["ctx"], "restore", [])

func _f41(this_, a: Array, env):
	var v_ctx_199 = null; var v_x_200 = null; var v_y_201 = null; var v_r_202 = null; var v_k_203 = null; var v_col_204 = null; var v_seed_205 = null; var v_n_206 = null; var v_i_207 = null; var v_an_208 = null; var v_r0_209 = null; var v_r1_210 = null
	v_ctx_199 = J.arg(a, 0)
	v_x_200 = J.arg(a, 1)
	v_y_201 = J.arg(a, 2)
	v_r_202 = J.arg(a, 3)
	v_k_203 = J.arg(a, 4)
	v_col_204 = J.arg(a, 5)
	v_seed_205 = J.arg(a, 6)
	v_n_206 = J.arg(a, 7)
	if J.cmp(v_k_203, 0.0, "<="):
		return null
	var _t46 = (v_n_206 if J.t(v_n_206) else 9.0)
	v_n_206 = _t46
	J.mc(v_ctx_199, "save", [])
	var _t47 = env["cl"]
	var _t48 = J.mul(J.gp(v_ctx_199, "globalAlpha"), J.cl(_t47, null, [v_k_203]))
	J.sp(v_ctx_199, "globalAlpha", _t48)
	v_i_207 = 0.0
	while true:
		if not J.cmp(v_i_207, v_n_206, "<"): break
		var _t50 = (J.div(v_i_207, v_n_206) * 6.283)
		var _t49 = env["rnd"]
		v_an_208 = (_t50 + J.mul(J.cl(_t49, null, [J.add(v_seed_205, v_i_207)]), 0.5))
		v_r0_209 = J.mul(v_r_202, (0.25 + (0.35 * J.sub(1.0, v_k_203))))
		var _t51 = env["rnd"]
		v_r1_210 = (J.mul(v_r_202, (0.7 + J.mul(0.5, J.cl(_t51, null, [J.add(J.add(v_seed_205, v_i_207), 9.0)])))) * (1.2 - J.mul(0.4, v_k_203)))
		var _t52 = env["crayon"]
		J.cl(_t52, null, [v_ctx_199, [[J.add(v_x_200, J.mul(cos(J.num(v_an_208)), v_r0_209)), J.add(v_y_201, J.mul(sin(J.num(v_an_208)), v_r0_209))], [J.add(v_x_200, J.mul(cos(J.num(v_an_208)), v_r1_210)), J.add(v_y_201, J.mul(sin(J.num(v_an_208)), v_r1_210))]], v_col_204, J.max_([1.0, J.mul(v_r_202, 0.09)]), J.add(v_seed_205, v_i_207)])
		v_i_207 = J.num(v_i_207) + 1.0
	J.mc(v_ctx_199, "restore", [])

func _f42(this_, a: Array, env):
	var v_ctx_213 = null; var v_x_214 = null; var v_y_215 = null; var v_dx_216 = null; var v_dy_217 = null; var v_len_218 = null; var v_spread_219 = null; var v_k_220 = null; var v_col_221 = null; var v_seed_222 = null; var v_n_223 = null; var v_l_224 = null; var v_ux_225 = null; var v_uy_226 = null; var v_i_227 = null; var v_o_228 = null; var v_L_229 = null; var v_b_230 = null; var v_px_231 = null; var v_py_232 = null
	v_ctx_213 = J.arg(a, 0)
	v_x_214 = J.arg(a, 1)
	v_y_215 = J.arg(a, 2)
	v_dx_216 = J.arg(a, 3)
	v_dy_217 = J.arg(a, 4)
	v_len_218 = J.arg(a, 5)
	v_spread_219 = J.arg(a, 6)
	v_k_220 = J.arg(a, 7)
	v_col_221 = J.arg(a, 8)
	v_seed_222 = J.arg(a, 9)
	v_n_223 = J.arg(a, 10)
	if J.cmp(v_k_220, 0.0, "<="):
		return null
	var _t53 = J.hypot_([v_dx_216, v_dy_217])
	v_l_224 = (_t53 if J.t(_t53) else 1.0)
	v_ux_225 = J.div(v_dx_216, v_l_224)
	v_uy_226 = J.div(v_dy_217, v_l_224)
	var _t54 = (v_n_223 if J.t(v_n_223) else 4.0)
	v_n_223 = _t54
	J.mc(v_ctx_213, "save", [])
	var _t55 = env["cl"]
	var _t56 = J.mul(J.gp(v_ctx_213, "globalAlpha"), J.cl(_t55, null, [v_k_220]))
	J.sp(v_ctx_213, "globalAlpha", _t56)
	v_i_227 = 0.0
	while true:
		if not J.cmp(v_i_227, v_n_223, "<"): break
		var _t58 = J.div(J.mul(J.sub(v_i_227, J.div(J.sub(v_n_223, 1.0), 2.0)), v_spread_219), v_n_223)
		var _t57 = env["rnd"]
		v_o_228 = (_t58 + (J.mul(J.sub(J.cl(_t57, null, [J.add(v_seed_222, v_i_227)]), 0.5), v_spread_219) * 0.2))
		var _t59 = env["rnd"]
		v_L_229 = J.mul(v_len_218, (0.6 + J.mul(0.4, J.cl(_t59, null, [J.add(J.add(v_seed_222, v_i_227), 4.0)]))))
		var _t61 = J.mul(v_len_218, 0.3)
		var _t60 = env["rnd"]
		v_b_230 = J.mul(_t61, J.cl(_t60, null, [J.add(J.add(v_seed_222, v_i_227), 8.0)]))
		v_px_231 = (J.sub(v_x_214, J.mul(v_uy_226, v_o_228)) - J.mul(v_ux_225, v_b_230))
		v_py_232 = J.sub(J.add(v_y_215, J.mul(v_ux_225, v_o_228)), J.mul(v_uy_226, v_b_230))
		var _t62 = env["crayon"]
		J.cl(_t62, null, [v_ctx_213, [[v_px_231, v_py_232], [J.sub(v_px_231, J.mul(v_ux_225, v_L_229)), J.sub(v_py_232, J.mul(v_uy_226, v_L_229))]], v_col_221, J.max_([1.0, J.mul(v_len_218, 0.06)]), J.add(v_seed_222, v_i_227)])
		v_i_227 = J.num(v_i_227) + 1.0
	J.mc(v_ctx_213, "restore", [])

func _f2(this_, a: Array, env):
	var v_v_31 = null; var v_a_32 = null; var v_b_33 = null
	v_v_31 = J.arg(a, 0)
	var _t63 = J.arg(a, 1)
	if _t63 == null:
		_t63 = 0.0
	v_a_32 = _t63
	var _t64 = J.arg(a, 2)
	if _t64 == null:
		_t64 = 1.0
	v_b_33 = _t64
	return (v_a_32 if J.cmp(v_v_31, v_a_32, "<") else (v_b_33 if J.cmp(v_v_31, v_b_33, ">") else v_v_31))

func _f3(this_, a: Array, env):
	var v_t_34 = null
	v_t_34 = J.arg(a, 0)
	return (1.0 - (J.sub(1.0, v_t_34) * J.sub(1.0, v_t_34)))

func _f4(this_, a: Array, env):
	var v_t_35 = null
	v_t_35 = J.arg(a, 0)
	return J.mul(v_t_35, v_t_35)

func _f5(this_, a: Array, env):
	var v_t_36 = null
	v_t_36 = J.arg(a, 0)
	return (J.mul(J.mul(2.0, v_t_36), v_t_36) if J.cmp(v_t_36, 0.5, "<") else (1.0 - ((2.0 * J.sub(1.0, v_t_36)) * J.sub(1.0, v_t_36))))

func _f6(this_, a: Array, env):
	var v_t_37 = null
	v_t_37 = J.arg(a, 0)
	return (1.0 - pow(J.num(J.sub(1.0, v_t_37)), J.num(3.0)))

func _f7(this_, a: Array, env):
	var v_t_38 = null
	v_t_38 = J.arg(a, 0)
	return J.mul(J.mul(v_t_38, v_t_38), v_t_38)

func _f8(this_, a: Array, env):
	var v_t_39 = null
	v_t_39 = J.arg(a, 0)
	return (0.5 - (0.5 * cos(J.num(J.mul(PI, v_t_39)))))

func _f9(this_, a: Array, env):
	var v_t_40 = null; var v_c_41 = null
	v_t_40 = J.arg(a, 0)
	v_c_41 = 1.6
	return ((1.0 + J.mul(J.add(v_c_41, 1.0), pow(J.num(J.sub(v_t_40, 1.0)), J.num(3.0)))) + J.mul(v_c_41, pow(J.num(J.sub(v_t_40, 1.0)), J.num(2.0))))

func _f10(this_, a: Array, env):
	var v_t_42 = null; var v_a_43 = null; var v_b_44 = null
	v_t_42 = J.arg(a, 0)
	v_a_43 = J.arg(a, 1)
	v_b_44 = J.arg(a, 2)
	var _t65 = env["cl"]
	return J.cl(_t65, null, [J.div(J.sub(v_t_42, v_a_43), J.sub(v_b_44, v_a_43))])

func _f11(this_, a: Array, env):
	var v_a_45 = null; var v_b_46 = null; var v_k_47 = null
	v_a_45 = J.arg(a, 0)
	v_b_46 = J.arg(a, 1)
	v_k_47 = J.arg(a, 2)
	return J.add(v_a_45, J.mul(J.sub(v_b_46, v_a_45), v_k_47))

func _f12(this_, a: Array, env):
	var v_i_48 = null; var v_v_49 = null
	v_i_48 = J.arg(a, 0)
	v_v_49 = (sin(J.num((J.mul(v_i_48, 127.1) + 311.7))) * 43758.5453)
	return J.sub(v_v_49, floor(J.num(v_v_49)))

func _f21(this_, a: Array, env):
	return J.construct(env["M"], [J.gp(this_, "a"), J.gp(this_, "b"), J.gp(this_, "c"), J.gp(this_, "d"), J.gp(this_, "e"), J.gp(this_, "f")])

func _f22(this_, a: Array, env):
	var v_n_88 = null; var v_a_89 = null; var v_b_90 = null; var v_c_91 = null; var v_d_92 = null; var v_e_93 = null; var v_f_94 = null
	v_n_88 = J.arg(a, 0)
	var _t66 = this_
	var _t67 = J.gp(_t66, "a")
	v_a_89 = _t67
	var _t68 = J.gp(_t66, "b")
	v_b_90 = _t68
	var _t69 = J.gp(_t66, "c")
	v_c_91 = _t69
	var _t70 = J.gp(_t66, "d")
	v_d_92 = _t70
	var _t71 = J.gp(_t66, "e")
	v_e_93 = _t71
	var _t72 = J.gp(_t66, "f")
	v_f_94 = _t72
	var _t73 = this_
	var _t74 = (J.mul(v_a_89, J.gp(v_n_88, "a")) + J.mul(v_c_91, J.gp(v_n_88, "b")))
	J.sp(_t73, "a", _t74)
	var _t75 = this_
	var _t76 = (J.mul(v_b_90, J.gp(v_n_88, "a")) + J.mul(v_d_92, J.gp(v_n_88, "b")))
	J.sp(_t75, "b", _t76)
	var _t77 = this_
	var _t78 = (J.mul(v_a_89, J.gp(v_n_88, "c")) + J.mul(v_c_91, J.gp(v_n_88, "d")))
	J.sp(_t77, "c", _t78)
	var _t79 = this_
	var _t80 = (J.mul(v_b_90, J.gp(v_n_88, "c")) + J.mul(v_d_92, J.gp(v_n_88, "d")))
	J.sp(_t79, "d", _t80)
	var _t81 = this_
	var _t82 = J.add((J.mul(v_a_89, J.gp(v_n_88, "e")) + J.mul(v_c_91, J.gp(v_n_88, "f"))), v_e_93)
	J.sp(_t81, "e", _t82)
	var _t83 = this_
	var _t84 = J.add((J.mul(v_b_90, J.gp(v_n_88, "e")) + J.mul(v_d_92, J.gp(v_n_88, "f"))), v_f_94)
	J.sp(_t83, "f", _t84)
	return this_

func _f23(this_, a: Array, env):
	var v_x_97 = null; var v_y_98 = null
	v_x_97 = J.arg(a, 0)
	v_y_98 = J.arg(a, 1)
	return J.mc(this_, "mul", [J.construct(env["M"], [1.0, 0.0, 0.0, 1.0, v_x_97, v_y_98])])

func _f24(this_, a: Array, env):
	var v_an_101 = null; var v_c_102 = null; var v_s_103 = null
	v_an_101 = J.arg(a, 0)
	v_c_102 = cos(J.num(v_an_101))
	v_s_103 = sin(J.num(v_an_101))
	return J.mc(this_, "mul", [J.construct(env["M"], [v_c_102, v_s_103, (-J.num(v_s_103)), v_c_102, 0.0, 0.0])])

func _f25(this_, a: Array, env):
	var v_x_106 = null; var v_y_107 = null
	v_x_106 = J.arg(a, 0)
	v_y_107 = J.arg(a, 1)
	return J.mc(this_, "mul", [J.construct(env["M"], [v_x_106, 0.0, 0.0, (v_x_106 if J.leq(v_y_107, null) else v_y_107), 0.0, 0.0])])

func _f26(this_, a: Array, env):
	var v_x_110 = null; var v_y_111 = null
	v_x_110 = J.arg(a, 0)
	v_y_111 = J.arg(a, 1)
	return [J.add((J.mul(J.gp(this_, "a"), v_x_110) + J.mul(J.gp(this_, "c"), v_y_111)), J.gp(this_, "e")), J.add((J.mul(J.gp(this_, "b"), v_x_110) + J.mul(J.gp(this_, "d"), v_y_111)), J.gp(this_, "f"))]

func _f27(this_, a: Array, env):
	var v_ctx_114 = null
	v_ctx_114 = J.arg(a, 0)
	J.mc(v_ctx_114, "transform", [J.gp(this_, "a"), J.gp(this_, "b"), J.gp(this_, "c"), J.gp(this_, "d"), J.gp(this_, "e"), J.gp(this_, "f")])

func _f20(this_, a: Array, env):
	var v_a_78 = null; var v_b_79 = null; var v_c_80 = null; var v_d_81 = null; var v_e_82 = null; var v_f_83 = null
	var _t85 = J.arg(a, 0)
	if _t85 == null:
		_t85 = 1.0
	v_a_78 = _t85
	var _t86 = J.arg(a, 1)
	if _t86 == null:
		_t86 = 0.0
	v_b_79 = _t86
	var _t87 = J.arg(a, 2)
	if _t87 == null:
		_t87 = 0.0
	v_c_80 = _t87
	var _t88 = J.arg(a, 3)
	if _t88 == null:
		_t88 = 1.0
	v_d_81 = _t88
	var _t89 = J.arg(a, 4)
	if _t89 == null:
		_t89 = 0.0
	v_e_82 = _t89
	var _t90 = J.arg(a, 5)
	if _t90 == null:
		_t90 = 0.0
	v_f_83 = _t90
	var _t91 = this_
	J.sp(_t91, "a", v_a_78)
	var _t92 = this_
	J.sp(_t92, "b", v_b_79)
	var _t93 = this_
	J.sp(_t93, "c", v_c_80)
	var _t94 = this_
	J.sp(_t94, "d", v_d_81)
	var _t95 = this_
	J.sp(_t95, "e", v_e_82)
	var _t96 = this_
	J.sp(_t96, "f", v_f_83)

func _f28(this_, a: Array, env):
	var v_k_115 = null
	v_k_115 = J.arg(a, 0)
	var _t98 = J.seq(J.typeof_(J.G.get("sprOk")), "function")
	if J.t(_t98):
		var _t97 = J.G.get("sprOk")
		_t98 = J.cl(_t97, null, [v_k_115])
	return _t98

func _f31(this_, a: Array, env):
	var v_K_137 = null; var v_u_138 = null; var v_v_139 = null
	v_K_137 = J.arg(a, 0)
	v_u_138 = J.arg(a, 1)
	v_v_139 = J.arg(a, 2)
	return [J.mul(((1.0 if J.t(J.gp(v_K_137, "nr")) else (-1.0)) * J.sub(v_u_138, 0.5)), J.gp(v_K_137, "W")), J.mul(J.sub(v_v_139, 1.0), J.gp(v_K_137, "H"))]

func _f35(this_, a: Array, env):
	var v_K_166 = null; var v_m_167 = null; var v_pu_168 = null; var v_pv_169 = null; var v_u_170 = null; var v_v_171 = null
	v_K_166 = J.arg(a, 0)
	v_m_167 = J.arg(a, 1)
	v_pu_168 = J.arg(a, 2)
	v_pv_169 = J.arg(a, 3)
	v_u_170 = J.arg(a, 4)
	v_v_171 = J.arg(a, 5)
	return J.mc(v_m_167, "pt", [J.mul(((1.0 if J.t(J.gp(v_K_166, "nr")) else (-1.0)) * J.sub(v_u_170, v_pu_168)), J.gp(v_K_166, "W")), J.mul(J.sub(v_v_171, v_pv_169), J.gp(v_K_166, "H"))])

func _f37(this_, a: Array, env):
	var v_K_179 = null; var v_back_180 = null
	v_K_179 = J.arg(a, 0)
	v_back_180 = J.arg(a, 1)
	return {"x": J.add(J.gp(v_K_179, "tx"), (v_back_180 if J.t(v_back_180) else 0.0)), "y": J.sub(J.gp(v_K_179, "ty"), J.mul(0.5, J.gp(v_K_179, "th"))), "rx": J.mul(0.25, J.gp(v_K_179, "th")), "ry": J.mul(0.5, J.gp(v_K_179, "th"))}

func _f1(this_, a: Array, env):
	var v_TE_6 = null; var v_E_8 = null; var v_seg_9 = null; var v_lerp_10 = null; var v_tgtBack_14 = null; var v_setup_17 = null; var v_enter_18 = null; var v_ip_19 = null; var v_pose_21 = null; var v_body_22 = null; var v_piece_23 = null; var v_ppt_24 = null; var v_shadow_25 = null; var v_tgtBody_26 = null; var v_clipOut_27 = null; var v_burst_29 = null; var v_speed_30 = null
	var _s2 = {"__p": env, "TW": null, "TS": null, "TR": null, "TC": null, "cl": null, "rnd": null, "tau": null, "lungeOf": null, "M": null, "ok": null, "KEEP": null, "crayon": null}
	_s2["tau"] = Callable(self, "_f13").bind(_s2)
	_s2["lungeOf"] = Callable(self, "_f14").bind(_s2)
	v_tgtBack_14 = Callable(self, "_f17").bind(_s2)
	v_setup_17 = Callable(self, "_f29").bind(_s2)
	v_enter_18 = Callable(self, "_f30").bind(_s2)
	v_pose_21 = Callable(self, "_f32").bind(_s2)
	v_body_22 = Callable(self, "_f33").bind(_s2)
	v_piece_23 = Callable(self, "_f34").bind(_s2)
	v_shadow_25 = Callable(self, "_f36").bind(_s2)
	v_clipOut_27 = Callable(self, "_f38").bind(_s2)
	_s2["crayon"] = Callable(self, "_f39").bind(_s2)
	v_burst_29 = Callable(self, "_f41").bind(_s2)
	v_speed_30 = Callable(self, "_f42").bind(_s2)
	_s2["TW"] = 0.22
	_s2["TS"] = 0.12
	_s2["TR"] = 0.25
	_s2["TC"] = J.add(_s2["TW"], J.mul(0.42, _s2["TS"]))
	v_TE_6 = J.add(J.add(_s2["TW"], _s2["TS"]), _s2["TR"])
	_s2["cl"] = Callable(self, "_f2").bind(_s2)
	v_E_8 = {"o": Callable(self, "_f3").bind(_s2), "i": Callable(self, "_f4").bind(_s2), "io": Callable(self, "_f5").bind(_s2), "o3": Callable(self, "_f6").bind(_s2), "i3": Callable(self, "_f7").bind(_s2), "sin": Callable(self, "_f8").bind(_s2), "back": Callable(self, "_f9").bind(_s2)}
	v_seg_9 = Callable(self, "_f10").bind(_s2)
	v_lerp_10 = Callable(self, "_f11").bind(_s2)
	_s2["rnd"] = Callable(self, "_f12").bind(_s2)
	J.G["M"] = {"__class": true, "ctor": Callable(self, "_f20").bind(_s2), "proto": {"clone": Callable(self, "_f21").bind(_s2), "mul": Callable(self, "_f22").bind(_s2), "t": Callable(self, "_f23").bind(_s2), "r": Callable(self, "_f24").bind(_s2), "s": Callable(self, "_f25").bind(_s2), "pt": Callable(self, "_f26").bind(_s2), "set": Callable(self, "_f27").bind(_s2)}}
	_s2["ok"] = Callable(self, "_f28").bind(_s2)
	v_ip_19 = Callable(self, "_f31").bind(_s2)
	_s2["KEEP"] = {"y": 1.0, "sx": 1.0, "sy": 1.0}
	v_ppt_24 = Callable(self, "_f35").bind(_s2)
	v_tgtBody_26 = Callable(self, "_f37").bind(_s2)
	return {"TW": _s2["TW"], "TS": _s2["TS"], "TR": _s2["TR"], "TC": _s2["TC"], "TE": v_TE_6, "cl": _s2["cl"], "E": v_E_8, "seg": v_seg_9, "lerp": v_lerp_10, "rnd": _s2["rnd"], "tau": _s2["tau"], "lungeOf": _s2["lungeOf"], "tgtBack": v_tgtBack_14, "M": _s2["M"], "ok": _s2["ok"], "setup": v_setup_17, "enter": v_enter_18, "ip": v_ip_19, "pose": v_pose_21, "body": v_body_22, "piece": v_piece_23, "ppt": v_ppt_24, "shadow": v_shadow_25, "tgtBody": v_tgtBody_26, "clipOut": v_clipOut_27, "crayon": _s2["crayon"], "burst": v_burst_29, "speed": v_speed_30}

func _f48(this_, a: Array, env):
	var v_s_368 = null; var v_l_369 = null; var v_f_370 = null
	v_s_368 = J.arg(a, 0)
	while true:
		var _t105 = J.cmp(env["j"], (J.len(env["cum"]) - 2.0), "<")
		if not (J.cmp(J.gp(env["cum"], J.add(env["j"], 1.0)), v_s_368, "<") if _t105 else _t105): break
		env["j"] = J.num(env["j"]) + 1.0
	while true:
		var _t106 = J.cmp(env["j"], 0.0, ">")
		if not (J.cmp(J.gp(env["cum"], env["j"]), v_s_368, ">") if _t106 else _t106): break
		env["j"] = J.num(env["j"]) + -1.0
	var _t107 = J.sub(J.gp(env["cum"], J.add(env["j"], 1.0)), J.gp(env["cum"], env["j"]))
	v_l_369 = (_t107 if J.t(_t107) else 1.0)
	v_f_370 = J.max_([0.0, J.min_([1.0, J.div(J.sub(v_s_368, J.gp(env["cum"], env["j"])), v_l_369)])])
	return [J.add(J.gp(J.gp(env["P"], env["j"]), 0.0), J.mul(J.sub(J.gp(J.gp(env["P"], J.add(env["j"], 1.0)), 0.0), J.gp(J.gp(env["P"], env["j"]), 0.0)), v_f_370)), J.add(J.gp(J.gp(env["P"], env["j"]), 1.0), J.mul(J.sub(J.gp(J.gp(env["P"], J.add(env["j"], 1.0)), 1.0), J.gp(J.gp(env["P"], env["j"]), 1.0)), v_f_370)), (J.gp(J.gp(env["P"], env["j"]), 2.0) if J.cmp(v_f_370, 0.5, "<") else J.gp(J.gp(env["P"], J.add(env["j"], 1.0)), 2.0))]

func _f47(this_, a: Array, env):
	var v_ctx_341 = null; var v_S_342 = null; var v_img_344 = null; var v_upx_345 = null; var v_R_346 = null; var v_tb_347 = null; var v_R0_348 = null; var v_RH_349 = null; var v_RT_350 = null; var v_RE_351 = null; var v_PER_352 = null; var v_iw_353 = null; var v_cxp_354 = null; var v_Lu_356 = null; var v_Lpx_357 = null; var v_head_358 = null; var v_tail_359 = null; var v_n_360 = null; var v_texL_361 = null; var v_k_362 = null; var v_step_363 = null; var v_at_365 = null; var v_clipped_366 = null; var v_i_367 = null; var v_tx_371 = null; var v_st_372 = null; var v_row_373 = null; var v_s0_374 = null; var v_s1_375 = null; var v_p0_376 = null; var v_p1_377 = null; var v_bk_378 = null; var v_an_379 = null; var v_len_380 = null
	var _s76 = {"__p": env, "P": null, "cum": null, "j": null}
	v_ctx_341 = J.arg(a, 0)
	v_S_342 = J.arg(a, 1)
	_s76["P"] = J.arg(a, 2)
	v_img_344 = J.arg(a, 3)
	v_upx_345 = J.arg(a, 4)
	v_R_346 = J.arg(a, 5)
	v_tb_347 = J.arg(a, 6)
	var _t100 = J.gp(v_R_346, 0.0)
	v_R0_348 = _t100
	var _t101 = J.gp(v_R_346, 1.0)
	v_RH_349 = _t101
	var _t102 = J.gp(v_R_346, 2.0)
	v_RT_350 = _t102
	var _t103 = J.gp(v_R_346, 3.0)
	v_RE_351 = _t103
	var _t104 = J.gp(v_R_346, 4.0)
	v_PER_352 = _t104
	v_iw_353 = J.gp(v_img_344, "naturalWidth")
	v_cxp_354 = J.mul(0.43, v_iw_353)
	_s76["cum"] = [0.0]
	v_i_367 = 1.0
	while true:
		if not J.cmp(v_i_367, J.len(_s76["P"]), "<"): break
		J.mc(_s76["cum"], "push", [J.add(J.gp(_s76["cum"], J.sub(v_i_367, 1.0)), J.hypot_([J.sub(J.gp(J.gp(_s76["P"], v_i_367), 0.0), J.gp(J.gp(_s76["P"], J.sub(v_i_367, 1.0)), 0.0)), J.sub(J.gp(J.gp(_s76["P"], v_i_367), 1.0), J.gp(J.gp(_s76["P"], J.sub(v_i_367, 1.0)), 1.0))]))])
		v_i_367 = J.num(v_i_367) + 1.0
	v_Lu_356 = J.gp(_s76["cum"], (J.len(_s76["cum"]) - 1.0))
	if J.cmp(v_Lu_356, 1.0, "<"):
		return null
	v_Lpx_357 = J.div(v_Lu_356, v_upx_345)
	v_head_358 = J.sub(v_RH_349, v_R0_348)
	v_tail_359 = J.sub(v_RE_351, v_RT_350)
	v_n_360 = J.max_([0.0, J.round(J.num(J.div(J.sub(J.sub(v_Lpx_357, v_head_358), v_tail_359), v_PER_352)))])
	v_texL_361 = J.add(J.add(v_head_358, v_tail_359), J.mul(v_n_360, v_PER_352))
	v_k_362 = J.div(v_texL_361, v_Lpx_357)
	v_step_363 = J.div(v_PER_352, 6.0)
	_s76["j"] = 0.0
	v_at_365 = Callable(self, "_f48").bind(_s76)
	v_clipped_366 = false
	J.mc(v_ctx_341, "save", [])
	v_tx_371 = 0.0
	while true:
		if not J.cmp(v_tx_371, J.sub(v_texL_361, 0.01), "<"): break
		v_st_372 = J.min_([v_step_363, J.sub(v_texL_361, v_tx_371)])
		v_row_373 = (J.add(v_R0_348, v_tx_371) if J.cmp(v_tx_371, v_head_358, "<") else (J.add(v_RH_349, J.mod(J.sub(v_tx_371, v_head_358), v_PER_352)) if J.cmp(v_tx_371, J.add(v_head_358, J.mul(v_n_360, v_PER_352)), "<") else J.add(v_RT_350, (J.sub(v_tx_371, v_head_358) - J.mul(v_n_360, v_PER_352)))))
		v_s0_374 = J.mul(J.div(v_tx_371, v_k_362), v_upx_345)
		v_s1_375 = J.mul(J.div(J.add(v_tx_371, v_st_372), v_k_362), v_upx_345)
		v_p0_376 = J.cl(v_at_365, null, [v_s0_374])
		v_p1_377 = J.cl(v_at_365, null, [v_s1_375])
		var _t108 = J.gp(v_p0_376, 2.0)
		v_bk_378 = (not (not J.t((_t108 if J.t(_t108) else J.gp(v_p1_377, 2.0)))))
		if (not J.seq(v_bk_378, v_clipped_366)):
			J.mc(v_ctx_341, "restore", [])
			J.mc(v_ctx_341, "save", [])
			if J.t(v_bk_378):
				J.mc(J.G.get("MoveKit"), "clipOut", [v_ctx_341, v_tb_347])
			v_clipped_366 = v_bk_378
		v_an_379 = atan2(J.num(J.sub(J.gp(v_p1_377, 1.0), J.gp(v_p0_376, 1.0))), J.num(J.sub(J.gp(v_p1_377, 0.0), J.gp(v_p0_376, 0.0))))
		v_len_380 = J.hypot_([J.sub(J.gp(v_p1_377, 0.0), J.gp(v_p0_376, 0.0)), J.sub(J.gp(v_p1_377, 1.0), J.gp(v_p0_376, 1.0))])
		J.mc(v_ctx_341, "save", [])
		J.mc(v_ctx_341, "translate", [J.gp(v_p0_376, 0.0), J.gp(v_p0_376, 1.0)])
		J.mc(v_ctx_341, "rotate", [J.sub(v_an_379, J.div(PI, 2.0))])
		J.mc(v_ctx_341, "drawImage", [v_img_344, 0.0, v_row_373, v_iw_353, J.min_([J.add(v_st_372, 0.8), J.sub(_s76["__p"]["ih"], v_row_373)]), J.mul((-J.num(v_cxp_354)), v_upx_345), 0.0, J.mul(v_iw_353, v_upx_345), J.add(v_len_380, J.mul(0.8, v_upx_345))])
		J.mc(v_ctx_341, "restore", [])
		var _t109 = J.add(v_tx_371, v_step_363)
		v_tx_371 = _t109
	J.mc(v_ctx_341, "restore", [])

func _f44(this_, a: Array, env):
	var v_an_294 = null; var v_R_295 = null; var v_lag_296 = null; var v_wave_297 = null; var v_N_298 = null; var v_i_299 = null; var v_f_300 = null; var v_A_301 = null; var v_w_302 = null
	v_an_294 = J.arg(a, 0)
	v_R_295 = J.arg(a, 1)
	v_lag_296 = J.arg(a, 2)
	v_wave_297 = J.arg(a, 3)
	v_N_298 = 26.0
	v_i_299 = 0.0
	while true:
		if not J.cmp(v_i_299, v_N_298, "<="): break
		v_f_300 = J.div(v_i_299, v_N_298)
		v_A_301 = J.sub(v_an_294, J.mul(v_lag_296, pow(J.num(v_f_300), J.num(1.4))))
		v_w_302 = ((J.mul(J.mul(v_wave_297, sin(J.num((J.mul(v_f_300, 9.0) - J.mul(env["tt"], 70.0))))), v_f_300) * J.sub(1.0, v_f_300)) * 4.0)
		J.mc(env["pts"], "push", [[J.sub(J.add(J.gp(env["G"], 0.0), J.mul(J.mul(cos(J.num(v_A_301)), v_R_295), v_f_300)), J.mul(sin(J.num(v_A_301)), v_w_302)), J.add(J.add(J.gp(env["G"], 1.0), J.mul(J.mul(sin(J.num(v_A_301)), v_R_295), v_f_300)), J.mul(cos(J.num(v_A_301)), v_w_302)), 0.0]])
		v_i_299 = J.num(v_i_299) + 1.0

func _f45(this_, a: Array, env):
	var v_a_314 = null; var v_b_315 = null; var v_c_316 = null; var v_k_317 = null
	v_a_314 = J.arg(a, 0)
	v_b_315 = J.arg(a, 1)
	v_c_316 = J.arg(a, 2)
	v_k_317 = J.arg(a, 3)
	return ((J.mul((J.sub(1.0, v_k_317) * J.sub(1.0, v_k_317)), v_a_314) + J.mul(J.mul((2.0 * J.sub(1.0, v_k_317)), v_k_317), v_b_315)) + J.mul(J.mul(v_k_317, v_k_317), v_c_316))

func _f46(this_, a: Array, env):
	var _t141 = env["chain"]
	return J.cl(_t141, null, [env["ctx"], env["S"], env["pts"], env["img"], env["upx"], [env["R0"], env["RH"], env["RT"], env["RE"], env["PER"]], J.mc(env["K"], "tgtBody", [env["S"], env["back"]])])

func _f43(this_, a: Array, env):
	var v_a_236 = null; var v_E_239 = null; var v_seg_240 = null; var v_lerp_241 = null; var v_M_242 = null; var v_H_244 = null; var v_th_245 = null; var v_wp_246 = null; var v_PV_247 = null; var v_GR_248 = null; var v_TP_249 = null; var v_kW_250 = null; var v_kL_251 = null; var v_kY_252 = null; var v_kR_253 = null; var v_lean_254 = null; var v_bdx_255 = null; var v_shake_256 = null; var v_bp_257 = null; var v_bm_258 = null; var v_fx_259 = null; var v_fy_260 = null; var v_fr_261 = null; var v_pv_262 = null; var v_fm_263 = null; var v_Lr_273 = null; var v_restTip_274 = null; var v_restG_275 = null; var v_a0_276 = null; var v_tight_278 = null; var v_cx_279 = null; var v_yc0_280 = null; var v_rx_281 = null; var v_ry_282 = null; var v_pitch_283 = null; var v_Tn_284 = null; var v_aT_285 = null; var v_dT_286 = null; var v_umax_288 = null; var v_behind_289 = null; var v_polar_290 = null; var v_drawChain_291 = null; var v_hk_292 = null; var v_q_303 = null; var v_an_304 = null; var v_q_305 = null; var v_qa_306 = null; var v_s0_307 = null; var v_c1_308 = null; var v_bz_309 = null; var v_tip_310 = null; var v_mid_311 = null; var v_ctl_312 = null; var v_N_313 = null; var v_i_318 = null; var v_f_319 = null; var v_w_320 = null; var v_sag_321 = null; var v_vib_322 = null; var v_N_323 = null; var v_n_324 = null; var v_i_325 = null; var v_f_326 = null; var v_i_327 = null; var v_u_328 = null; var v_ph_329 = null; var v_j_330 = null; var v_q_331 = null; var v_an_332 = null; var v_R_333 = null; var v_p_334 = null; var v_q_335 = null; var v_k_336 = null; var v_i_337 = null; var v_yy_338 = null
	var _s56 = {"__p": env, "ctx": null, "K": null, "S": null, "tt": null, "G": null, "img": null, "ih": null, "upx": null, "R0": null, "RH": null, "RT": null, "RE": null, "PER": null, "back": null, "pts": null, "chain": null}
	_s56["ctx"] = J.arg(a, 0)
	v_a_236 = J.arg(a, 1)
	_s56["chain"] = Callable(self, "_f47").bind(_s56)
	_s56["K"] = J.G.get("MoveKit")
	_s56["S"] = J.mc(_s56["K"], "setup", [v_a_236])
	var _t110 = (not J.t(_s56["S"]))
	if (_t110 if _t110 else (not J.t(J.mc(_s56["K"], "ok", ["heiwu__wpn"])))):
		return false
	var _t111 = _s56["K"]
	var _t112 = J.gp(_t111, "E")
	v_E_239 = _t112
	var _t113 = J.gp(_t111, "seg")
	v_seg_240 = _t113
	var _t114 = J.gp(_t111, "lerp")
	v_lerp_241 = _t114
	var _t115 = J.gp(_t111, "M")
	v_M_242 = _t115
	_s56["tt"] = J.gp(_s56["S"], "tt")
	v_H_244 = J.gp(_s56["S"], "H")
	v_th_245 = J.gp(_s56["S"], "th")
	v_wp_246 = J.gp(J.gp(J.G.get("LIMBS_DATA"), "weapons"), "iron_chain")
	if (not J.t(v_wp_246)):
		return false
	v_PV_247 = J.gp(J.gp(_s56["S"], "C"), "pivot")
	v_GR_248 = J.gp(J.gp(_s56["S"], "C"), "grip")
	v_TP_249 = J.gp(J.gp(_s56["S"], "C"), "tip")
	v_kW_250 = J.mc(v_E_239, "o", [J.cl(v_seg_240, null, [_s56["tt"], 0.0, 0.15])])
	v_kL_251 = J.mc(v_E_239, "o3", [J.cl(v_seg_240, null, [_s56["tt"], 0.15, 0.22])])
	v_kY_252 = J.mc(v_E_239, "back", [J.cl(v_seg_240, null, [_s56["tt"], 0.345, 0.4])])
	v_kR_253 = J.mc(v_E_239, "io", [J.cl(v_seg_240, null, [_s56["tt"], 0.46, 0.59])])
	v_lean_254 = J.mul((-9.0), v_kW_250)
	v_bdx_255 = J.mul((-0.03), v_kW_250)
	var _t116 = J.cl(v_lerp_241, null, [v_lean_254, 8.0, v_kL_251])
	v_lean_254 = _t116
	var _t117 = J.cl(v_lerp_241, null, [v_bdx_255, 0.035, v_kL_251])
	v_bdx_255 = _t117
	var _t118 = J.cl(v_lerp_241, null, [v_lean_254, (-13.0), v_kY_252])
	v_lean_254 = _t118
	var _t119 = J.cl(v_lerp_241, null, [v_bdx_255, (-0.05), v_kY_252])
	v_bdx_255 = _t119
	var _t120 = J.mul(v_lean_254, J.sub(1.0, v_kR_253))
	v_lean_254 = _t120
	var _t121 = J.mul(v_bdx_255, J.sub(1.0, v_kR_253))
	v_bdx_255 = _t121
	var _t122 = J.cmp(_s56["tt"], 0.36, ">")
	v_shake_256 = (J.mul((sin(J.num(J.mul(_s56["tt"], 260.0))) * 0.004), v_H_244) if (J.cmp(_s56["tt"], 0.46, "<") if _t122 else _t122) else 0.0)
	v_bp_257 = J.mc(_s56["K"], "ip", [_s56["S"], 0.5, 0.78])
	var _t123 = J.construct(v_M_242, [])
	var _t124 = J.mc(_t123, "t", [J.add(J.mul(v_bdx_255, v_H_244), v_shake_256), (-J.num(J.gp(_s56["S"], "fl")))])
	var _t125 = J.mc(_t124, "t", [J.gp(v_bp_257, 0.0), J.gp(v_bp_257, 1.0)])
	var _t126 = J.mc(_t125, "r", [J.div(J.mul(v_lean_254, PI), 180.0)])
	v_bm_258 = J.mc(_t126, "t", [(-J.num(J.gp(v_bp_257, 0.0))), (-J.num(J.gp(v_bp_257, 1.0)))])
	v_fx_259 = J.cl(v_lerp_241, null, [0.0, (-0.05), v_kW_250])
	v_fy_260 = J.cl(v_lerp_241, null, [0.0, (-0.11), v_kW_250])
	v_fr_261 = J.cl(v_lerp_241, null, [0.0, (-25.0), v_kW_250])
	var _t127 = J.cl(v_lerp_241, null, [v_fx_259, 0.05, v_kL_251])
	v_fx_259 = _t127
	var _t128 = J.cl(v_lerp_241, null, [v_fy_260, (-0.05), v_kL_251])
	v_fy_260 = _t128
	var _t129 = J.cl(v_lerp_241, null, [v_fr_261, 15.0, v_kL_251])
	v_fr_261 = _t129
	var _t130 = J.cl(v_lerp_241, null, [v_fx_259, (-0.06), v_kY_252])
	v_fx_259 = _t130
	var _t131 = J.cl(v_lerp_241, null, [v_fy_260, 0.03, v_kY_252])
	v_fy_260 = _t131
	var _t132 = J.cl(v_lerp_241, null, [v_fr_261, (-10.0), v_kY_252])
	v_fr_261 = _t132
	var _t133 = J.mul(v_fx_259, J.sub(1.0, v_kR_253))
	v_fx_259 = _t133
	var _t134 = J.mul(v_fy_260, J.sub(1.0, v_kR_253))
	v_fy_260 = _t134
	var _t135 = J.mul(v_fr_261, J.sub(1.0, v_kR_253))
	v_fr_261 = _t135
	v_pv_262 = J.mc(_s56["K"], "ip", [_s56["S"], J.gp(v_PV_247, 0.0), J.gp(v_PV_247, 1.0)])
	var _t136 = J.mc(v_bm_258, "clone", [])
	var _t137 = J.mc(_t136, "t", [J.add(J.gp(v_pv_262, 0.0), J.mul(v_fx_259, v_H_244)), J.add(J.gp(v_pv_262, 1.0), J.mul(v_fy_260, v_H_244))])
	v_fm_263 = J.mc(_t137, "r", [J.div(J.mul(v_fr_261, PI), 180.0)])
	_s56["G"] = J.mc(_s56["K"], "ppt", [_s56["S"], v_fm_263, J.gp(v_PV_247, 0.0), J.gp(v_PV_247, 1.0), J.gp(v_GR_248, 0.0), J.gp(v_GR_248, 1.0)])
	_s56["img"] = J.gp(J.G.get("SPR"), "heiwu__wpn")
	_s56["ih"] = J.gp(_s56["img"], "naturalHeight")
	_s56["upx"] = J.div(J.mul(J.gp(v_wp_246, "h"), v_H_244), _s56["ih"])
	_s56["R0"] = J.mul(0.098, _s56["ih"])
	_s56["RH"] = J.mul(0.4126, _s56["ih"])
	_s56["RT"] = J.mul(0.6084, _s56["ih"])
	_s56["RE"] = J.mul(0.979, _s56["ih"])
	_s56["PER"] = J.sub(_s56["RT"], _s56["RH"])
	v_Lr_273 = J.mul(J.sub(_s56["RE"], _s56["R0"]), _s56["upx"])
	v_restTip_274 = J.mc(_s56["K"], "ip", [_s56["S"], J.gp(v_TP_249, 0.0), J.gp(v_TP_249, 1.0)])
	v_restG_275 = J.mc(_s56["K"], "ip", [_s56["S"], J.gp(v_GR_248, 0.0), J.gp(v_GR_248, 1.0)])
	v_a0_276 = atan2(J.num(J.sub(J.gp(v_restTip_274, 1.0), J.gp(v_restG_275, 1.0))), J.num(J.sub(J.gp(v_restTip_274, 0.0), J.gp(v_restG_275, 0.0))))
	_s56["back"] = J.mc(_s56["K"], "tgtBack", [_s56["tt"], v_th_245])
	v_tight_278 = (1.0 - (J.mul(0.16, J.mc(v_E_239, "sin", [J.cl(v_seg_240, null, [_s56["tt"], 0.345, 0.4])])) * J.sub(1.0, J.cl(v_seg_240, null, [_s56["tt"], 0.44, 0.48]))))
	v_cx_279 = J.add(J.gp(_s56["S"], "tx"), _s56["back"])
	v_yc0_280 = J.sub(J.gp(_s56["S"], "ty"), J.mul(0.6, v_th_245))
	v_rx_281 = J.mul(J.mul(0.205, v_th_245), v_tight_278)
	v_ry_282 = J.mul(J.mul(0.06, v_th_245), v_tight_278)
	v_pitch_283 = J.mul(0.075, v_th_245)
	v_Tn_284 = [J.add(v_cx_279, v_rx_281), v_yc0_280]
	v_aT_285 = (atan2(J.num(J.sub(J.gp(v_Tn_284, 1.0), J.gp(_s56["G"], 1.0))), J.num(J.sub(J.gp(v_Tn_284, 0.0), J.gp(_s56["G"], 0.0)))) + (2.0 * PI))
	v_dT_286 = J.hypot_([J.sub(J.gp(v_Tn_284, 0.0), J.gp(_s56["G"], 0.0)), J.sub(J.gp(v_Tn_284, 1.0), J.gp(_s56["G"], 1.0))])
	_s56["pts"] = []
	v_umax_288 = 0.0
	v_behind_289 = false
	v_polar_290 = Callable(self, "_f44").bind(_s56)
	if J.cmp(_s56["tt"], 0.15, "<"):
		v_q_303 = J.mc(v_E_239, "io", [J.cl(v_seg_240, null, [_s56["tt"], 0.0, 0.15])])
		v_an_304 = J.cl(v_lerp_241, null, [v_a0_276, J.add(v_a0_276, 2.65), v_q_303])
		J.cl(v_polar_290, null, [v_an_304, v_Lr_273, (0.9 * sin(J.num(J.mul(v_q_303, PI)))), J.mul(0.02, v_H_244)])
	else:
		if J.cmp(_s56["tt"], 0.27, "<"):
			v_q_305 = J.mc(v_E_239, "o", [J.cl(v_seg_240, null, [_s56["tt"], 0.15, 0.27])])
			v_qa_306 = (J.mul(J.mc(v_E_239, "sin", [J.cl(v_seg_240, null, [_s56["tt"], 0.15, 0.27])]), 0.5) + J.mul(v_q_305, 0.5))
			v_s0_307 = [J.add(J.gp(_s56["G"], 0.0), J.mul(cos(J.num(J.add(v_a0_276, 2.65))), v_Lr_273)), J.add(J.gp(_s56["G"], 1.0), J.mul(sin(J.num(J.add(v_a0_276, 2.65))), v_Lr_273))]
			v_c1_308 = [(J.max_([J.gp(_s56["G"], 0.0), J.gp(v_Tn_284, 0.0)]) + J.mul(0.22, v_H_244)), (J.min_([J.gp(_s56["G"], 1.0), J.gp(v_Tn_284, 1.0)]) - J.mul(0.75, v_H_244))]
			v_bz_309 = Callable(self, "_f45").bind(_s56)
			v_tip_310 = [J.cl(v_bz_309, null, [J.gp(v_s0_307, 0.0), J.gp(v_c1_308, 0.0), J.gp(v_Tn_284, 0.0), v_qa_306]), J.cl(v_bz_309, null, [J.gp(v_s0_307, 1.0), J.gp(v_c1_308, 1.0), J.gp(v_Tn_284, 1.0), v_qa_306])]
			v_mid_311 = [J.div(J.add(J.gp(_s56["G"], 0.0), J.gp(v_tip_310, 0.0)), 2.0), J.div(J.add(J.gp(_s56["G"], 1.0), J.gp(v_tip_310, 1.0)), 2.0)]
			v_ctl_312 = [J.cl(v_lerp_241, null, [J.gp(v_mid_311, 0.0), J.gp(v_c1_308, 0.0), (0.55 * J.sub(1.0, v_q_305))]), J.cl(v_lerp_241, null, [J.gp(v_mid_311, 1.0), J.gp(v_c1_308, 1.0), (0.55 * J.sub(1.0, v_q_305))])]
			v_N_313 = 30.0
			v_i_318 = 0.0
			while true:
				if not J.cmp(v_i_318, v_N_313, "<="): break
				v_f_319 = J.div(v_i_318, v_N_313)
				v_w_320 = (((J.mul(0.03, v_H_244) * J.sub(1.0, v_q_305)) * sin(J.num((J.mul(v_f_319, 10.0) - J.mul(_s56["tt"], 80.0))))) * sin(J.num(J.mul(v_f_319, PI))))
				J.mc(_s56["pts"], "push", [[J.cl(v_bz_309, null, [J.gp(_s56["G"], 0.0), J.gp(v_ctl_312, 0.0), J.gp(v_tip_310, 0.0), v_f_319]), J.add(J.cl(v_bz_309, null, [J.gp(_s56["G"], 1.0), J.gp(v_ctl_312, 1.0), J.gp(v_tip_310, 1.0), v_f_319]), v_w_320), 0.0]])
				v_i_318 = J.num(v_i_318) + 1.0
		else:
			if J.cmp(_s56["tt"], 0.53, "<"):
				v_sag_321 = ((J.mul(0.05, v_H_244) * J.sub(1.0, J.mc(v_E_239, "o", [J.cl(v_seg_240, null, [_s56["tt"], 0.33, 0.37])]))) + (J.mul(J.mul(0.06, v_H_244), J.cl(v_seg_240, null, [_s56["tt"], 0.46, 0.53])) if J.cmp(_s56["tt"], 0.46, ">") else 0.0))
				var _t138 = J.cmp(_s56["tt"], 0.355, ">")
				v_vib_322 = ((J.mul(0.006, v_H_244) * sin(J.num(J.mul(_s56["tt"], 300.0)))) if (J.cmp(_s56["tt"], 0.47, "<") if _t138 else _t138) else 0.0)
				v_N_323 = 22.0
				v_i_325 = 0.0
				while true:
					if not J.cmp(v_i_325, v_N_323, "<="): break
					v_f_326 = J.div(v_i_325, v_N_323)
					J.mc(_s56["pts"], "push", [[J.cl(v_lerp_241, null, [J.gp(_s56["G"], 0.0), J.gp(v_Tn_284, 0.0), v_f_326]), J.add(J.add(J.cl(v_lerp_241, null, [J.gp(_s56["G"], 1.0), J.gp(v_Tn_284, 1.0), v_f_326]), (J.mul(J.mul(v_sag_321, 4.0), v_f_326) * J.sub(1.0, v_f_326))), J.mul(v_vib_322, sin(J.num((J.mul(v_f_326, PI) * 3.0))))), 0.0]])
					v_i_325 = J.num(v_i_325) + 1.0
				var _t139 = J.mul(((2.5 * 2.0) * PI), (J.mc(v_E_239, "o", [J.cl(v_seg_240, null, [_s56["tt"], 0.27, 0.345])]) if J.cmp(_s56["tt"], 0.46, "<") else J.sub(1.0, J.mc(v_E_239, "i", [J.cl(v_seg_240, null, [_s56["tt"], 0.46, 0.53])]))))
				v_umax_288 = _t139
				v_n_324 = ceil(J.num(J.div(v_umax_288, J.div(PI, 12.0))))
				v_i_327 = 1.0
				while true:
					if not J.cmp(v_i_327, v_n_324, "<="): break
					v_u_328 = J.min_([v_umax_288, J.div(J.mul(v_i_327, PI), 12.0)])
					v_ph_329 = v_u_328
					var _t140 = J.cmp(_s56["tt"], 0.36, ">")
					v_j_330 = (J.mul((sin(J.num(J.add(J.mul(_s56["tt"], 220.0), v_i_327))) * 0.006), v_th_245) if (J.cmp(_s56["tt"], 0.45, "<") if _t140 else _t140) else 0.0)
					J.mc(_s56["pts"], "push", [[J.add(J.add(v_cx_279, J.mul(cos(J.num(v_ph_329)), v_rx_281)), v_j_330), J.add(J.add(v_yc0_280, J.mul(J.div(v_u_328, (2.0 * PI)), v_pitch_283)), J.mul(sin(J.num(v_ph_329)), v_ry_282)), (1.0 if (sin(J.num(v_ph_329)) < (-0.05)) else 0.0)]])
					v_i_327 = J.num(v_i_327) + 1.0
			else:
				v_q_331 = J.mc(v_E_239, "o3", [J.cl(v_seg_240, null, [_s56["tt"], 0.53, 0.59])])
				v_an_332 = J.cl(v_lerp_241, null, [J.sub(v_aT_285, (2.0 * PI)), v_a0_276, v_q_331])
				v_R_333 = J.cl(v_lerp_241, null, [v_dT_286, v_Lr_273, v_q_331])
				J.cl(v_polar_290, null, [v_an_332, v_R_333, ((-0.8) * sin(J.num(J.mul(v_q_331, PI)))), (J.mul(0.04, v_H_244) * J.sub(1.0, v_q_331))])
	J.mc(_s56["ctx"], "save", [])
	J.mc(_s56["K"], "enter", [_s56["ctx"], _s56["S"]])
	J.mc(_s56["K"], "shadow", [_s56["ctx"], _s56["S"], J.mul(v_bdx_255, v_H_244), 0.0])
	v_drawChain_291 = Callable(self, "_f46").bind(_s56)
	if J.t(v_behind_289):
		J.cl(v_drawChain_291, null, [])
	J.mc(_s56["K"], "body", [_s56["ctx"], _s56["S"], v_bm_258, J.mc(_s56["K"], "pose", [_s56["S"], {"head": J.mul(v_lean_254, (-0.004))}])])
	if (not J.t(v_behind_289)):
		J.cl(v_drawChain_291, null, [])
	J.mc(_s56["K"], "piece", [_s56["ctx"], _s56["S"], "heiwu__arm", v_fm_263, J.gp(v_PV_247, 0.0), J.gp(v_PV_247, 1.0)])
	var _t142 = J.cmp(_s56["tt"], 0.17, ">")
	if (J.cmp(_s56["tt"], 0.27, "<") if _t142 else _t142):
		v_p_334 = J.gp(_s56["pts"], (J.len(_s56["pts"]) - 1.0))
		v_q_335 = J.gp(_s56["pts"], (J.len(_s56["pts"]) - 4.0))
		J.mc(_s56["K"], "speed", [_s56["ctx"], J.gp(v_p_334, 0.0), J.gp(v_p_334, 1.0), J.sub(J.gp(v_p_334, 0.0), J.gp(v_q_335, 0.0)), J.sub(J.gp(v_p_334, 1.0), J.gp(v_q_335, 1.0)), J.mul(0.16, v_H_244), J.mul(0.06, v_H_244), 1.0, "rgba(235,235,245,.8)", 3.0])
	v_hk_292 = J.sub(1.0, J.cl(v_seg_240, null, [_s56["tt"], J.gp(_s56["K"], "TC"), J.add(J.gp(_s56["K"], "TC"), 0.12)]))
	var _t143 = J.cmp(_s56["tt"], J.gp(_s56["K"], "TC"), ">=")
	if (J.cmp(v_hk_292, 0.0, ">") if _t143 else _t143):
		J.mc(_s56["K"], "burst", [_s56["ctx"], J.gp(v_Tn_284, 0.0), J.gp(v_Tn_284, 1.0), J.mul(0.16, v_th_245), v_hk_292, "#fff2c0", 11.0])
	var _t144 = J.cmp(_s56["tt"], 0.345, ">")
	if (J.cmp(_s56["tt"], 0.47, "<") if _t144 else _t144):
		v_k_336 = sin(J.num(J.mul(J.cl(v_seg_240, null, [_s56["tt"], 0.345, 0.47]), PI)))
		v_i_337 = 0.0
		while true:
			if not J.cmp(v_i_337, 3.0, "<"): break
			v_yy_338 = J.add(v_yc0_280, J.mul((J.sub(v_i_337, 1.0) * 0.12), v_th_245))
			J.mc(_s56["K"], "speed", [_s56["ctx"], J.sub(v_cx_279, J.mul(v_rx_281, 1.2)), v_yy_338, (-1.0), (0.05 * J.sub(v_i_337, 1.0)), J.mul(0.12, v_H_244), J.mul(0.03, v_H_244), J.mul(v_k_336, 0.9), "rgba(255,240,200,.85)", J.add(20.0, v_i_337), 2.0])
			v_i_337 = J.num(v_i_337) + 1.0
		J.mc(_s56["K"], "burst", [_s56["ctx"], v_cx_279, J.add(v_yc0_280, v_pitch_283), J.mul(0.3, v_th_245), J.mul(v_k_336, 0.6), "rgba(210,230,255,.9)", 41.0, 7.0])
	if J.t(J.gp(J.gp(_s56["S"], "o"), "hitOut")):
		var _t145 = J.gp(J.gp(_s56["S"], "o"), "hitOut")
		var _t146 = {"x": J.add(J.gp(J.gp(_s56["S"], "a"), "x"), J.mul(J.gp(_s56["S"], "fw"), J.gp(v_Tn_284, 0.0))), "y": J.add(J.gp(J.gp(_s56["S"], "a"), "y"), J.gp(v_Tn_284, 1.0))}
		J.sp(_t145, "p", _t146)
	J.mc(_s56["ctx"], "restore", [])
