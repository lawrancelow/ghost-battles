# 自動轉譯自 npc_antag.js（tools/jsgd.js）——唔好直接改，改原 JS 再轉
extends RefCounted

func run(env):
	var this_ = null; var a = []
	J.G["Antag"] = J.cl(Callable(self, "_f1").bind(env), null, [])

func _f7(this_, a: Array, env):
	var v_S_53 = null; var v_id_54 = null; var v_pk_55 = null; var v_p_56 = null; var v_im_57 = null; var v_H_58 = null
	v_S_53 = J.arg(a, 0)
	v_id_54 = J.arg(a, 1)
	v_pk_55 = J.arg(a, 2)
	v_p_56 = J.gp(J.gp(J.gp(env["P"], v_id_54), "poses"), v_pk_55)
	v_im_57 = J.gp(J.G.get("SPR"), J.gp(v_p_56, "img"))
	var _t1 = (not J.t(v_im_57))
	if (_t1 if _t1 else (not J.t(J.mc(env["N"], "ok", [J.gp(v_p_56, "img")])))):
		return null
	v_H_58 = J.mul(J.gp(v_S_53, "H"), J.gp(v_p_56, "k"))
	return J.S_Object_("assign", [{}, v_S_53, {"id": J.gp(v_p_56, "img"), "nr": (not (not J.t(J.gp(v_p_56, "nr")))), "H": v_H_58, "W": J.div(J.mul(v_H_58, J.gp(v_im_57, "naturalWidth")), J.gp(v_im_57, "naturalHeight")), "k": J.gp(v_p_56, "k")}])

func _f8(this_, a: Array, env):
	var v_S2_61 = null; var v_extra_62 = null; var v_walkT_63 = null; var v_idleK_64 = null; var v_z_65 = null; var v_n_66 = null; var v_n_67 = null
	v_S2_61 = J.arg(a, 0)
	v_extra_62 = J.arg(a, 1)
	v_walkT_63 = J.arg(a, 2)
	v_idleK_64 = J.arg(a, 3)
	v_z_65 = null
	if (not J.leq(v_walkT_63, null)):
		var _t2 = J.cl(env["A"], null, [])
		var _t3 = J.mc(_t2, "walk", [v_walkT_63])
		v_z_65 = _t3
		for _t4 in J.keys(v_z_65):
			v_n_66 = _t4
			var _t6 = J.seq(J.typeof_(J.gp(v_z_65, v_n_66)), "number")
			if J.t(_t6):
				var _t5 = ["y", "sx", "sy"]
				_t6 = (not J.t(J.mc(_t5, "includes", [v_n_66])))
			if ((not J.t(J.gp(v_S2_61, "nr"))) if _t6 else _t6):
				var _t7 = (-J.num(J.gp(v_z_65, v_n_66)))
				J.sp(v_z_65, v_n_66, _t7)
		J.sp(v_z_65, "x", 0.0)
		J.sp(v_z_65, "rot", 0.0)
	else:
		var _t8 = J.mc(env["N"], "pose", [v_S2_61, {}, (0.7 if J.leq(v_idleK_64, null) else v_idleK_64)])
		v_z_65 = _t8
	if J.t(v_extra_62):
		for _t9 in J.keys(v_extra_62):
			v_n_67 = _t9
			var _t10 = ["x", "y", "r", "px", "py", "sx", "sy", "a"]
			if (not J.t(J.mc(_t10, "includes", [v_n_67]))):
				var _t11 = J.gp(v_z_65, v_n_67)
				var _t12 = J.add((_t11 if J.t(_t11) else 0.0), (J.gp(v_extra_62, v_n_67) if J.t(J.gp(v_S2_61, "nr")) else (-J.num(J.gp(v_extra_62, v_n_67)))))
				J.sp(v_z_65, v_n_67, _t12)
	return v_z_65

func _f9(this_, a: Array, env):
	var v_ctx_70 = null; var v_S_71 = null; var v_id_72 = null; var v_pk_73 = null; var v_f_74 = null; var v_opt_75 = null; var v_S2_76 = null; var v_m_77 = null
	v_ctx_70 = J.arg(a, 0)
	v_S_71 = J.arg(a, 1)
	v_id_72 = J.arg(a, 2)
	v_pk_73 = J.arg(a, 3)
	v_f_74 = J.arg(a, 4)
	v_opt_75 = J.arg(a, 5)
	var _t13 = env["poseS"]
	v_S2_76 = J.cl(_t13, null, [v_S_71, v_id_72, v_pk_73])
	if (not J.t(v_S2_76)):
		return null
	var _t14 = (v_opt_75 if J.t(v_opt_75) else {})
	v_opt_75 = _t14
	v_m_77 = J.mc(env["N"], "bm", [v_S2_76, v_f_74])
	var _t15 = env["mp"]
	var _t18 = J.cl(_t15, null, [v_S2_76, v_f_74, J.gp(v_opt_75, "walkT"), J.gp(v_opt_75, "idleK")])
	var _t17 = null
	if J.t(J.gp(v_opt_75, "cut")):
		var _t16 = env["nb"]
		_t17 = J.cl(_t16, null, [J.gp(v_S2_76, "id")])
	else:
		_t17 = J.gp(v_S2_76, "id")
	J.mc(env["N"], "body", [v_ctx_70, v_S2_76, v_m_77, _t18, _t17, (J.gp(v_f_74, "a") if (not J.leq(J.gp(v_f_74, "a"), null)) else null)])
	return {"S2": v_S2_76, "m": v_m_77}

func _f10(this_, a: Array, env):
	var v_a_80 = null; var v_S_81 = null
	v_a_80 = J.arg(a, 0)
	v_S_81 = J.mc(env["N"], "setup", [v_a_80])
	return v_S_81

func _f11(this_, a: Array, env):
	var v_ctx_84 = null; var v_S_85 = null; var v_f_86 = null; var v_sk_87 = null
	v_ctx_84 = J.arg(a, 0)
	v_S_85 = J.arg(a, 1)
	v_f_86 = J.arg(a, 2)
	v_sk_87 = J.arg(a, 3)
	J.mc(v_ctx_84, "save", [])
	var _t19 = J.gp(env["N"], "K")
	J.mc(_t19, "enter", [v_ctx_84, v_S_85])
	var _t20 = (J.gp(v_f_86, "x") if J.t(v_f_86) else v_f_86)
	J.mc(env["N"], "shadow", [v_ctx_84, v_S_85, (_t20 if J.t(_t20) else 0.0), 0.0, v_sk_87])

func _f13(this_, a: Array, env):
	var v_ctx_91 = null; var v_S2_92 = null; var v_x_93 = null; var v_y_94 = null; var v_rot_95 = null; var v_sc_96 = null; var v_st_97 = null; var v_im_98 = null; var v_c_99 = null
	v_ctx_91 = J.arg(a, 0)
	v_S2_92 = J.arg(a, 1)
	v_x_93 = J.arg(a, 2)
	v_y_94 = J.arg(a, 3)
	v_rot_95 = J.arg(a, 4)
	v_sc_96 = J.arg(a, 5)
	v_st_97 = J.S_Object_("assign", [{}, v_S2_92, {"id": "npc_rival", "nr": false}])
	v_im_98 = J.gp(J.G.get("SPR"), "npc_rival")
	if (not J.t(v_im_98)):
		return null
	var _t21 = J.div(J.gp(v_S2_92, "H"), J.gp(v_S2_92, "k"))
	J.sp(v_st_97, "H", _t21)
	var _t22 = J.div(J.mul(J.gp(v_st_97, "H"), J.gp(v_im_98, "naturalWidth")), J.gp(v_im_98, "naturalHeight"))
	J.sp(v_st_97, "W", _t22)
	v_c_99 = J.gp(env["BALL"], "npc_rival")
	J.mc(env["N"], "pieceAt", [v_ctx_91, v_st_97, "ball", v_x_93, v_y_94, v_rot_95, J.gp(v_c_99, 0.0), J.gp(v_c_99, 1.0), (v_sc_96 if J.t(v_sc_96) else 1.0)])

func _f16(this_, a: Array, env):
	var v_ctx_105 = null; var v_S_106 = null; var v_x_107 = null; var v_y_108 = null; var v_size_109 = null; var v_txt_110 = null; var v_k_111 = null; var v_al_112 = null; var v_z_113 = null
	v_ctx_105 = J.arg(a, 0)
	v_S_106 = J.arg(a, 1)
	v_x_107 = J.arg(a, 2)
	v_y_108 = J.arg(a, 3)
	v_size_109 = J.arg(a, 4)
	v_txt_110 = J.arg(a, 5)
	v_k_111 = J.arg(a, 6)
	v_al_112 = J.arg(a, 7)
	if J.cmp(v_al_112, 0.0, "<="):
		return null
	v_z_113 = ((1.6 - J.mul(0.6, J.mc(env["E"], "o", [v_k_111]))) if J.cmp(v_k_111, 1.0, "<") else 1.0)
	J.mc(v_ctx_105, "save", [])
	J.mc(v_ctx_105, "translate", [v_x_107, v_y_108])
	J.mc(v_ctx_105, "scale", [J.gp(v_S_106, "fw"), 1.0])
	J.mc(v_ctx_105, "rotate", [(-0.18)])
	J.mc(v_ctx_105, "scale", [v_z_113, v_z_113])
	var _t23 = env["cl"]
	var _t24 = J.mul(J.gp(v_ctx_105, "globalAlpha"), J.cl(_t23, null, [v_al_112]))
	J.sp(v_ctx_105, "globalAlpha", _t24)
	J.sp(v_ctx_105, "strokeStyle", "#d0141e")
	var _t25 = J.mul(v_size_109, 0.09)
	J.sp(v_ctx_105, "lineWidth", _t25)
	J.sp(v_ctx_105, "lineJoin", "round")
	J.mc(v_ctx_105, "strokeRect", [((-J.num(v_size_109)) * 0.55), ((-J.num(v_size_109)) * 0.32), J.mul(v_size_109, 1.1), J.mul(v_size_109, 0.64)])
	J.mc(v_ctx_105, "strokeRect", [((-J.num(v_size_109)) * 0.48), ((-J.num(v_size_109)) * 0.25), J.mul(v_size_109, 0.96), J.mul(v_size_109, 0.5)])
	J.sp(v_ctx_105, "fillStyle", "#d0141e")
	var _t26 = ("900 " + J.str(J.mul(v_size_109, 0.42)) + "px \"PingFang TC\",\"Noto Sans TC\",\"Noto Sans CJK TC\",serif")
	J.sp(v_ctx_105, "font", _t26)
	J.sp(v_ctx_105, "textAlign", "center")
	J.sp(v_ctx_105, "textBaseline", "middle")
	J.mc(v_ctx_105, "fillText", [v_txt_110, 0.0, J.mul(v_size_109, 0.02)])
	J.mc(v_ctx_105, "restore", [])

func _f17(this_, a: Array, env):
	var v_ctx_116 = null; var v_x_117 = null; var v_y_118 = null; var v_w_119 = null; var v_k_120 = null; var v_seed_121 = null; var v_pts_122 = null; var v_n_123 = null; var v_e_124 = null; var v_p0_125 = null; var v_an_126 = null; var v_i_127 = null; var v_q_128 = null
	v_ctx_116 = J.arg(a, 0)
	v_x_117 = J.arg(a, 1)
	v_y_118 = J.arg(a, 2)
	v_w_119 = J.arg(a, 3)
	v_k_120 = J.arg(a, 4)
	v_seed_121 = J.arg(a, 5)
	if J.cmp(v_k_120, 0.0, "<="):
		return null
	v_pts_122 = []
	v_n_123 = 6.0
	v_i_127 = 0.0
	while true:
		if not J.cmp(v_i_127, v_n_123, "<="): break
		v_q_128 = J.div(v_i_127, v_n_123)
		if J.cmp(v_q_128, v_k_120, ">"):
			break
		J.mc(v_pts_122, "push", [[(J.sub(v_x_117, J.div(v_w_119, 2.0)) + J.mul(v_q_128, v_w_119)), ((J.sub(v_y_118, J.mul(v_w_119, 0.35)) + (J.mul(v_q_128, v_w_119) * 0.7)) + (((-J.num(v_w_119)) * 0.14) if J.t(J.mod(v_i_127, 2.0)) else J.mul(v_w_119, 0.06)))]])
		v_i_127 = J.num(v_i_127) + 1.0
	if (J.len(v_pts_122) < 2.0):
		return null
	J.mc(env["N"], "crayon", [v_ctx_116, v_pts_122, "#ffffff", J.mul(v_w_119, 0.1), v_seed_121])
	J.mc(env["N"], "crayon", [v_ctx_116, v_pts_122, "#e0202a", J.mul(v_w_119, 0.06), J.add(v_seed_121, 1.0)])
	v_e_124 = J.gp(v_pts_122, (J.len(v_pts_122) - 1.0))
	v_p0_125 = J.gp(v_pts_122, (J.len(v_pts_122) - 2.0))
	v_an_126 = atan2(J.num(J.sub(J.gp(v_e_124, 1.0), J.gp(v_p0_125, 1.0))), J.num(J.sub(J.gp(v_e_124, 0.0), J.gp(v_p0_125, 0.0))))
	J.mc(v_ctx_116, "save", [])
	J.mc(v_ctx_116, "translate", [J.gp(v_e_124, 0.0), J.gp(v_e_124, 1.0)])
	J.mc(v_ctx_116, "rotate", [v_an_126])
	J.sp(v_ctx_116, "fillStyle", "#e0202a")
	J.mc(v_ctx_116, "beginPath", [])
	J.mc(v_ctx_116, "moveTo", [J.mul(v_w_119, 0.12), 0.0])
	J.mc(v_ctx_116, "lineTo", [((-J.num(v_w_119)) * 0.04), ((-J.num(v_w_119)) * 0.08)])
	J.mc(v_ctx_116, "lineTo", [((-J.num(v_w_119)) * 0.04), J.mul(v_w_119, 0.08)])
	J.mc(v_ctx_116, "closePath", [])
	J.mc(v_ctx_116, "fill", [])
	J.mc(v_ctx_116, "restore", [])

func _f18(this_, a: Array, env):
	var v_ctx_131 = null; var v_x_132 = null; var v_y_133 = null; var v_r_134 = null; var v_k_135 = null; var v_col_136 = null; var v_i_137 = null; var v_q_138 = null
	v_ctx_131 = J.arg(a, 0)
	v_x_132 = J.arg(a, 1)
	v_y_133 = J.arg(a, 2)
	v_r_134 = J.arg(a, 3)
	v_k_135 = J.arg(a, 4)
	v_col_136 = J.arg(a, 5)
	v_i_137 = 0.0
	while true:
		if not J.cmp(v_i_137, 3.0, "<"): break
		var _t27 = env["cl"]
		v_q_138 = J.cl(_t27, null, [(J.mul(v_k_135, 1.4) - J.mul(v_i_137, 0.2))])
		var _t28 = J.cmp(v_q_138, 0.0, ">")
		if (J.cmp(v_q_138, 1.0, "<") if _t28 else _t28):
			J.mc(env["N"], "ring", [v_ctx_131, v_x_132, v_y_133, J.mul(v_r_134, J.add(0.3, v_q_138)), (J.mul(v_r_134, J.add(0.3, v_q_138)) * 0.8), v_col_136, ((J.mul(v_r_134, 0.06) * J.sub(1.0, v_q_138)) + 1.0), J.sub(1.0, v_q_138)])
		v_i_137 = J.num(v_i_137) + 1.0

func _f39(this_, a: Array, env):
	var v_id_309 = null; var v_st_310 = null; var v_p_311 = null
	v_id_309 = J.arg(a, 0)
	v_st_310 = J.arg(a, 1)
	v_p_311 = J.gp(env["PRE"], v_id_309)
	var _t30 = J.gp(env["ACT"], J.add(J.add(v_p_311, "_"), v_st_310))
	if not J.t(_t30):
		var _t29 = J.gp(env["STATES"], v_id_309)
		_t30 = (J.gp(env["ACT"], v_st_310) if J.t(J.mc(_t29, "includes", [v_st_310])) else null)
	return _t30

func _f40(this_, a: Array, env):
	var v_ctx_314 = null; var v_a_315 = null; var v_st_316 = null; var v_at_317 = null; var v_S_318 = null; var v_fn_319 = null; var v_dur_320 = null; var v_g_321 = null
	v_ctx_314 = J.arg(a, 0)
	v_a_315 = J.arg(a, 1)
	v_st_316 = J.arg(a, 2)
	v_at_317 = J.arg(a, 3)
	var _t31 = env["setup"]
	v_S_318 = J.cl(_t31, null, [v_a_315])
	if (not J.t(v_S_318)):
		return false
	var _t32 = env["actFn"]
	v_fn_319 = J.cl(_t32, null, [J.gp(v_a_315, "type"), v_st_316])
	if (not J.t(v_fn_319)):
		return false
	var _t33 = J.gp(env["DUR"], v_st_316)
	v_dur_320 = (_t33 if J.t(_t33) else 2.0)
	v_g_321 = J.div(J.mod((v_at_317 if J.t(v_at_317) else 0.0), v_dur_320), v_dur_320)
	var _t34 = env["begin"]
	J.cl(_t34, null, [v_ctx_314, v_S_318, null, (1.0 if J.t(J.gp(v_a_315, "solid")) else 0.8)])
	J.cl(v_fn_319, null, [v_ctx_314, v_S_318, v_g_321, (v_at_317 if J.t(v_at_317) else 0.0), false])
	var _t35 = env["end"]
	J.cl(_t35, null, [v_ctx_314])
	return true

func _f41(this_, a: Array, env):
	var v_ctx_324 = null; var v_a_325 = null; var v_o_326 = null; var v_ps_327 = null
	v_ctx_324 = J.arg(a, 0)
	v_a_325 = J.arg(a, 1)
	v_o_326 = J.gp(v_a_325, "o")
	v_ps_327 = J.gp(v_o_326, "pose")
	var _t37 = J.gp(v_o_326, "hurt")
	if not J.t(_t37):
		var _t36 = ["hurt", "die", "down", "air", "cast", "faint"]
		_t37 = J.mc(_t36, "includes", [v_ps_327])
	if J.t(_t37):
		return false
	var _t38 = ["scared", "startle", "tremble", "cower"]
	if J.t(J.mc(_t38, "includes", [v_ps_327])):
		var _t39 = env["run"]
		return J.cl(_t39, null, [v_ctx_324, v_a_325, "jump", J.gp(v_o_326, "t")])
	var _t40 = J.gp(v_o_326, "walk")
	var _t41 = (_t40 if J.t(_t40) else J.seq(v_ps_327, "move"))
	var _t42 = (_t41 if J.t(_t41) else J.seq(v_ps_327, "walk"))
	if J.t((_t42 if J.t(_t42) else J.seq(v_ps_327, "run"))):
		var _t43 = env["run"]
		return J.cl(_t43, null, [v_ctx_324, v_a_325, "walk", J.gp(v_o_326, "t")])
	var _t44 = env["run"]
	return J.cl(_t44, null, [v_ctx_324, v_a_325, "idle", J.gp(v_o_326, "t")])

func _f46(this_, a: Array, env):
	var v_ctx_387 = null; var v_id_388 = null; var v_x_389 = null; var v_y_390 = null; var v_h_391 = null; var v_state_392 = null; var v_t_393 = null; var v_opt_394 = null; var v_s_395 = null; var v_o_396 = null; var v_q_397 = null; var v_W_398 = null; var v_Sx_399 = null; var v_R_400 = null
	v_ctx_387 = J.arg(a, 0)
	v_id_388 = J.arg(a, 1)
	v_x_389 = J.arg(a, 2)
	v_y_390 = J.arg(a, 3)
	v_h_391 = J.arg(a, 4)
	v_state_392 = J.arg(a, 5)
	v_t_393 = J.arg(a, 6)
	v_opt_394 = J.arg(a, 7)
	if (not J.t(J.gp(env["P"], v_id_388))):
		return false
	var _t45 = (v_opt_394 if J.t(v_opt_394) else {})
	v_opt_394 = _t45
	v_s_395 = J.div(v_h_391, J.gp(J.gp(env["P"], v_id_388), "h"))
	v_o_396 = {"t": (J.gp(v_opt_394, "time") if (not J.leq(J.gp(v_opt_394, "time"), null)) else (v_t_393 if J.t(v_t_393) else 0.0)), "flip": J.seq(J.gp(v_opt_394, "faceRight"), false), "alpha": J.gp(v_opt_394, "alpha"), "shadow": J.gp(v_opt_394, "shadow"), "tamed": true}
	if J.seq(v_state_392, "attack"):
		v_q_397 = (v_t_393 if J.t(v_t_393) else 0.0)
		v_W_398 = 0.22
		v_Sx_399 = 0.12
		v_R_400 = 0.25
		if J.cmp(v_q_397, v_W_398, "<"):
			J.sp(v_o_396, "pose", "windup")
			var _t46 = J.div(v_q_397, v_W_398)
			J.sp(v_o_396, "pt", _t46)
		else:
			if J.cmp(v_q_397, J.add(v_W_398, v_Sx_399), "<"):
				J.sp(v_o_396, "pose", "strike")
				var _t47 = J.div(J.sub(v_q_397, v_W_398), v_Sx_399)
				J.sp(v_o_396, "pt", _t47)
			else:
				if J.cmp(v_q_397, J.add(J.add(v_W_398, v_Sx_399), v_R_400), "<"):
					J.sp(v_o_396, "pose", "recover")
					var _t48 = J.div(J.sub(J.sub(v_q_397, v_W_398), v_Sx_399), v_R_400)
					J.sp(v_o_396, "pt", _t48)
				else:
					J.sp(v_o_396, "pose", "idle")
		var _t49 = (J.gp(v_opt_394, "tdx") if (not J.leq(J.gp(v_opt_394, "tdx"), null)) else (J.mul((-0.75), v_h_391) if J.seq(J.gp(v_opt_394, "faceRight"), false) else J.mul(0.75, v_h_391)))
		J.sp(v_o_396, "tdx", _t49)
		var _t50 = J.gp(v_opt_394, "tdy")
		var _t51 = (_t50 if J.t(_t50) else 0.0)
		J.sp(v_o_396, "tdy", _t51)
	else:
		var _t52 = ["hurt", "die", "down", "scared"]
		if J.t(J.mc(_t52, "includes", [v_state_392])):
			J.sp(v_o_396, "pose", v_state_392)
			var _t57 = null
			if J.seq(v_state_392, "hurt"):
				var _t53 = env["cl"]
				_t57 = J.cl(_t53, null, [J.div((v_t_393 if J.t(v_t_393) else 0.0), 0.25)])
			else:
				var _t56 = null
				if J.seq(v_state_392, "die"):
					var _t54 = env["cl"]
					_t56 = J.cl(_t54, null, [J.div((v_t_393 if J.t(v_t_393) else 0.0), 0.8)])
				else:
					var _t55 = env["cl"]
					_t56 = J.cl(_t55, null, [J.div((v_t_393 if J.t(v_t_393) else 0.0), 1.8)])
				_t57 = _t56
			J.sp(v_o_396, "pt", _t57)
		else:
			if J.seq(v_state_392, "walk"):
				J.sp(v_o_396, "pose", "move")
				J.sp(v_o_396, "walk", true)
				var _t58 = (v_t_393 if J.t(v_t_393) else 0.0)
				J.sp(v_o_396, "t", _t58)
			else:
				var _t59 = J.seq(v_state_392, "idle")
				if (_t59 if _t59 else (not J.t(v_state_392))):
					J.sp(v_o_396, "pose", "idle")
					var _t60 = (J.gp(v_opt_394, "time") if (not J.leq(J.gp(v_opt_394, "time"), null)) else (v_t_393 if J.t(v_t_393) else 0.0))
					J.sp(v_o_396, "t", _t60)
				else:
					var _t61 = J.add("ag_", v_state_392)
					J.sp(v_o_396, "act", _t61)
					var _t62 = (v_t_393 if J.t(v_t_393) else 0.0)
					J.sp(v_o_396, "at", _t62)
	J.mc(J.G.get("ART"), "drawChar", [v_ctx_387, v_id_388, v_x_389, v_y_390, v_s_395, v_o_396])
	return true

func _f2(this_, a: Array, env):
	return J.gp(J.G.get("MeshAnim"), "ANIM")

func _f3(this_, a: Array, env):
	var v_g_37 = null; var v_n_38 = null; var v_ph_39 = null
	v_g_37 = J.arg(a, 0)
	v_n_38 = J.arg(a, 1)
	v_ph_39 = J.arg(a, 2)
	return sin(J.num(J.add(J.mul(J.mul(v_g_37, env["TAU"]), (v_n_38 if J.t(v_n_38) else 1.0)), (v_ph_39 if J.t(v_ph_39) else 0.0))))

func _f4(this_, a: Array, env):
	var v_g_40 = null; var v_a_41 = null; var v_b_42 = null
	v_g_40 = J.arg(a, 0)
	v_a_41 = J.arg(a, 1)
	v_b_42 = J.arg(a, 2)
	var _t69 = env["seg"]
	return sin(J.num(J.mul(J.cl(_t69, null, [v_g_40, v_a_41, v_b_42]), PI)))

func _f5(this_, a: Array, env):
	var v_ctx_48 = null; var v_a_49 = null
	v_ctx_48 = J.arg(a, 0)
	v_a_49 = J.arg(a, 1)
	var _t77 = env["custom"]
	return J.cl(_t77, null, [v_ctx_48, v_a_49])

func _f6(this_, a: Array, env):
	var v_img_50 = null
	v_img_50 = J.arg(a, 0)
	return (J.mc(J.G.get("N30"), "cutBody", [v_img_50, J.gp(env["CUTS"], v_img_50), J.add(v_img_50, "__nb")]) if J.t(J.gp(env["CUTS"], v_img_50)) else v_img_50)

func _f12(this_, a: Array, env):
	var v_ctx_88 = null
	v_ctx_88 = J.arg(a, 0)
	return J.mc(v_ctx_88, "restore", [])

func _f14(this_, a: Array, env):
	var v_S2_100 = null; var v_m_101 = null
	v_S2_100 = J.arg(a, 0)
	v_m_101 = J.arg(a, 1)
	return J.mc(env["N"], "at", [v_S2_100, v_m_101, J.gp(J.gp(env["BALL"], J.gp(v_S2_100, "id")), 0.0), J.gp(J.gp(env["BALL"], J.gp(v_S2_100, "id")), 1.0)])

func _f15(this_, a: Array, env):
	var v_S2_102 = null
	v_S2_102 = J.arg(a, 0)
	return J.div(J.mul((0.192 * J.div(J.gp(v_S2_102, "H"), J.gp(v_S2_102, "k"))), J.gp(J.gp(J.G.get("SPR"), "npc_rival"), "naturalWidth")), J.gp(J.gp(J.G.get("SPR"), "npc_rival"), "naturalHeight"))

func _f19(this_, a: Array, env):
	var v_ctx_141 = null; var v_S_142 = null; var v_g_143 = null; var v_t_144 = null; var v_r_145 = null; var v_c_146 = null
	v_ctx_141 = J.arg(a, 0)
	v_S_142 = J.arg(a, 1)
	v_g_143 = J.arg(a, 2)
	v_t_144 = J.arg(a, 3)
	var _t82 = env["drawPose"]
	v_r_145 = J.cl(_t82, null, [v_ctx_141, v_S_142, "npc_rival", "stand", {}, {"cut": true, "idleK": 0.8}])
	if (not J.t(v_r_145)):
		return null
	var _t83 = env["ballRest"]
	v_c_146 = J.cl(_t83, null, [J.gp(v_r_145, "S2"), J.gp(v_r_145, "m")])
	var _t84 = env["ball"]
	J.cl(_t84, null, [v_ctx_141, J.gp(v_r_145, "S2"), J.gp(v_c_146, 0.0), J.add(J.gp(v_c_146, 1.0), J.mul((sin(J.num(J.mul(v_t_144, 6.0))) * 0.004), J.gp(v_S_142, "H"))), J.mul(v_t_144, 360.0)])

func _f20(this_, a: Array, env):
	var v_ctx_149 = null; var v_S_150 = null; var v_g_151 = null; var v_t_152 = null; var v_r_153 = null; var v_c_154 = null; var v_sw2_155 = null
	v_ctx_149 = J.arg(a, 0)
	v_S_150 = J.arg(a, 1)
	v_g_151 = J.arg(a, 2)
	v_t_152 = J.arg(a, 3)
	var _t85 = env["drawPose"]
	var _t86 = env["sw"]
	var _t88 = J.mul(J.cl(_t86, null, [v_g_151, 2.0]), 0.05)
	var _t87 = env["sw"]
	v_r_153 = J.cl(_t85, null, [v_ctx_149, v_S_150, "npc_rival", "stand", {"head": _t88, "body": J.mul(J.cl(_t87, null, [v_g_151]), 0.02)}, {"cut": true}])
	if (not J.t(v_r_153)):
		return null
	var _t89 = env["ballRest"]
	v_c_154 = J.cl(_t89, null, [J.gp(v_r_153, "S2"), J.gp(v_r_153, "m")])
	var _t90 = env["ball"]
	var _t93 = J.gp(v_r_153, "S2")
	var _t94 = J.gp(v_c_154, 0.0)
	var _t92 = J.gp(v_c_154, 1.0)
	var _t91 = env["sw"]
	J.cl(_t90, null, [v_ctx_149, _t93, _t94, J.sub(_t92, J.mul((absf(J.num(J.cl(_t91, null, [v_g_151, 4.0]))) * 0.006), J.gp(v_S_150, "H"))), J.mul(v_t_152, 900.0)])
	v_sw2_155 = J.gp(v_r_153, "S2")
	J.mc(v_ctx_149, "save", [])
	J.mc(v_ctx_149, "translate", [J.gp(v_c_154, 0.0), J.gp(v_c_154, 1.0)])
	J.mc(v_ctx_149, "rotate", [J.mul(v_t_152, 6.0)])
	J.mc(v_ctx_149, "translate", [(-J.num(J.gp(v_c_154, 0.0))), (-J.num(J.gp(v_c_154, 1.0)))])
	J.mc(env["N"], "piece", [v_ctx_149, v_sw2_155, "swoosh", J.gp(v_r_153, "m"), 0.5, 1.0])
	J.mc(env["N"], "piece", [v_ctx_149, v_sw2_155, "swoosh2", J.gp(v_r_153, "m"), 0.5, 1.0])
	J.mc(v_ctx_149, "restore", [])

func _f21(this_, a: Array, env):
	var v_ctx_158 = null; var v_S_159 = null; var v_g_160 = null; var v_t_161 = null; var v_walk_162 = null; var v_ph_163 = null; var v_r_164 = null; var v_top_165 = null; var v_R_166 = null; var v_floor_167 = null; var v_q_168 = null; var v_by_169 = null; var v_squash_170 = null
	v_ctx_158 = J.arg(a, 0)
	v_S_159 = J.arg(a, 1)
	v_g_160 = J.arg(a, 2)
	v_t_161 = J.arg(a, 3)
	v_walk_162 = J.arg(a, 4)
	v_ph_163 = J.mod(J.mul(v_t_161, 2.4), 1.0)
	var _t95 = env["drawPose"]
	var _t97 = null
	if J.t(v_walk_162):
		_t97 = {"body": 0.05, "y": J.mul(((-absf(J.num(sin(J.num(J.mul(v_t_161, 3.0)))))) * 0.02), J.gp(v_S_159, "H")), "armF": ((-0.12) * cos(J.num(J.mul(v_ph_163, env["TAU"])))), "tail1": ((-0.2) + (sin(J.num(J.mul(v_t_161, 5.0))) * 0.1)), "tail2": ((-0.3) + (sin(J.num((J.mul(v_t_161, 5.0) - 1.0))) * 0.15))}
	else:
		var _t96 = env["sw"]
		_t97 = {"body": (0.04 + (0.03 * absf(J.num(J.cl(_t96, null, [v_ph_163]))))), "armF": ((-0.12) * cos(J.num(J.mul(v_ph_163, env["TAU"]))))}
	v_r_164 = J.cl(_t95, null, [v_ctx_158, v_S_159, "npc_rival", "walk", _t97, {"cut": true, "idleK": 1.0}])
	if (not J.t(v_r_164)):
		return null
	var _t98 = env["ballRest"]
	v_top_165 = J.cl(_t98, null, [J.gp(v_r_164, "S2"), J.gp(v_r_164, "m")])
	var _t99 = env["ballR"]
	v_R_166 = J.cl(_t99, null, [J.gp(v_r_164, "S2")])
	v_floor_167 = (-J.num(v_R_166))
	v_q_168 = absf(J.num(cos(J.num(J.mul(v_ph_163, PI)))))
	var _t100 = env["lerp"]
	v_by_169 = J.cl(_t100, null, [v_floor_167, J.gp(v_top_165, 1.0), v_q_168])
	v_squash_170 = ((1.0 - (J.sub(0.08, v_q_168) * 2.0)) if J.cmp(v_q_168, 0.08, "<") else 1.0)
	var _t101 = env["ball"]
	J.cl(_t101, null, [v_ctx_158, J.gp(v_r_164, "S2"), J.add(J.gp(v_top_165, 0.0), (0.0 if J.t(v_walk_162) else J.mul((sin(J.num(J.mul(v_t_161, 1.2))) * 0.04), J.gp(v_S_159, "H")))), v_by_169, J.mul(v_t_161, 120.0), 1.0])
	if J.cmp(v_squash_170, 1.0, "<"):
		J.mc(env["N"], "puff", [v_ctx_158, J.gp(v_top_165, 0.0), J.mul((-0.01), J.gp(v_S_159, "H")), J.mul(0.05, J.gp(v_S_159, "H")), J.mod(J.mul(v_ph_163, 2.0), 1.0), "rgba(200,190,170,.45)", 3.0, 3.0])
	if J.cmp(v_q_168, 0.15, "<"):
		J.mc(env["N"], "piece", [v_ctx_158, J.gp(v_r_164, "S2"), "fx", J.gp(v_r_164, "m"), 0.5, 1.0, (1.0 - J.div(v_q_168, 0.15))])

func _f22(this_, a: Array, env):
	var v_ctx_173 = null; var v_S_174 = null; var v_g_175 = null; var v_t_176 = null; var v_f_177 = null; var v_r_178 = null; var v_c0_179 = null; var v_bx_180 = null; var v_by_181 = null; var v_rot_182 = null; var v_q_183 = null
	v_ctx_173 = J.arg(a, 0)
	v_S_174 = J.arg(a, 1)
	v_g_175 = J.arg(a, 2)
	v_t_176 = J.arg(a, 3)
	v_f_177 = J.mc(env["N"], "kf", [v_g_175, [[0.0, {}], [0.18, {"sy": 0.9, "sx": 1.04, "armF": (-0.2)}], [0.32, {"y": J.mul((-0.28), J.gp(v_S_174, "H")), "sy": 1.05, "armF": (-0.6), "armB": (-0.4), "head": (-0.1)}, "o"], [0.48, {"y": 0.0, "sy": 0.94}, "i"], [0.6, {}]]])
	var _t102 = env["drawPose"]
	v_r_178 = J.cl(_t102, null, [v_ctx_173, v_S_174, "npc_rival", "stand", v_f_177, {"cut": true}])
	if (not J.t(v_r_178)):
		return null
	var _t103 = env["ballRest"]
	v_c0_179 = J.cl(_t103, null, [J.gp(v_r_178, "S2"), J.gp(v_r_178, "m")])
	v_bx_180 = J.gp(v_c0_179, 0.0)
	v_by_181 = J.gp(v_c0_179, 1.0)
	v_rot_182 = J.mul(v_t_176, 300.0)
	var _t104 = J.cmp(v_g_175, 0.3, ">")
	if (J.cmp(v_g_175, 0.9, "<") if _t104 else _t104):
		var _t105 = env["seg"]
		v_q_183 = J.cl(_t105, null, [v_g_175, 0.3, 0.9])
		var _t106 = J.add(J.gp(v_c0_179, 0.0), J.mul((sin(J.num(J.mul(v_q_183, PI))) * 0.6), J.gp(v_S_174, "H")))
		v_bx_180 = _t106
		var _t107 = J.sub(J.gp(v_c0_179, 1.0), J.mul((sin(J.num(J.mul(v_q_183, PI))) * 0.75), J.gp(v_S_174, "H")))
		v_by_181 = _t107
		var _t108 = J.mul(v_q_183, 900.0)
		v_rot_182 = _t108
	var _t109 = env["ball"]
	J.cl(_t109, null, [v_ctx_173, J.gp(v_r_178, "S2"), v_bx_180, v_by_181, v_rot_182])
	var _t110 = {}
	J.assign(_t110, [v_S_174])
	_t110["tt"] = v_g_175
	J.mc(env["N"], "pop", [v_ctx_173, _t110, J.mul(0.25, J.gp(v_S_174, "H")), J.mul((-1.15), J.gp(v_S_174, "H")), "三分！", J.mul(0.13, J.gp(v_S_174, "H")), "#ffb347", 0.5, 0.45])

func _f23(this_, a: Array, env):
	var v_ctx_186 = null; var v_S_187 = null; var v_g_188 = null; var v_t_189 = null; var v_r_190 = null; var v_mo_191 = null; var v_lines_192 = null; var v_i_193 = null; var v_q_194 = null
	v_ctx_186 = J.arg(a, 0)
	v_S_187 = J.arg(a, 1)
	v_g_188 = J.arg(a, 2)
	v_t_189 = J.arg(a, 3)
	var _t111 = env["drawPose"]
	var _t112 = env["sw"]
	var _t114 = J.mul(J.cl(_t112, null, [v_g_188, 3.0]), 0.04)
	var _t113 = env["sw"]
	var _t116 = (0.03 + J.mul(J.cl(_t113, null, [v_g_188, 1.5]), 0.02))
	var _t115 = env["sw"]
	v_r_190 = J.cl(_t111, null, [v_ctx_186, v_S_187, "npc_rival", "gossip", {"head": _t114, "body": _t116, "armF": J.mul(J.cl(_t115, null, [v_g_188, 6.0]), 0.03)}])
	if (not J.t(v_r_190)):
		return null
	v_mo_191 = J.mc(env["N"], "at", [J.gp(v_r_190, "S2"), J.gp(v_r_190, "m"), 0.2, 0.3])
	v_lines_192 = ["聽講……", "佢呀……", "咪講畀人知"]
	v_i_193 = J.mod(floor(J.num(J.mul(v_g_188, 3.0))), 3.0)
	v_q_194 = J.mod(J.mul(v_g_188, 3.0), 1.0)
	J.mc(env["N"], "txt", [v_ctx_186, v_S_187, (J.sub(J.gp(v_mo_191, 0.0), J.mul(J.gp(v_S_187, "fw"), 0.0)) - J.mul(0.12, J.gp(v_S_187, "H"))), (J.sub(J.gp(v_mo_191, 1.0), J.mul(0.1, J.gp(v_S_187, "H"))) - J.mul(J.mul(v_q_194, 0.06), J.gp(v_S_187, "H"))), J.mul(0.085, J.gp(v_S_187, "H")), J.gp(v_lines_192, v_i_193), "#f0e0ff", sin(J.num(J.mul(v_q_194, PI)))])

func _f24(this_, a: Array, env):
	var v_ctx_197 = null; var v_S_198 = null; var v_g_199 = null; var v_t_200 = null
	v_ctx_197 = J.arg(a, 0)
	v_S_198 = J.arg(a, 1)
	v_g_199 = J.arg(a, 2)
	v_t_200 = J.arg(a, 3)
	J.mc(env["ACT"], "dribble", [v_ctx_197, v_S_198, v_g_199, v_t_200, true])

func _f25(this_, a: Array, env):
	var v_ctx_203 = null; var v_S_204 = null; var v_g_205 = null; var v_t_206 = null; var v_j_207 = null
	v_ctx_203 = J.arg(a, 0)
	v_S_204 = J.arg(a, 1)
	v_g_205 = J.arg(a, 2)
	v_t_206 = J.arg(a, 3)
	var _t117 = env["bump"]
	v_j_207 = J.cl(_t117, null, [v_g_205, 0.0, 0.35])
	var _t118 = env["drawPose"]
	J.cl(_t118, null, [v_ctx_203, v_S_204, "npc_rival", "jump", {"y": J.mul(J.mul((-0.12), J.gp(v_S_204, "H")), v_j_207), "x": (J.mul((sin(J.num(J.mul(v_t_206, 50.0))) * 0.006), J.gp(v_S_204, "H")) * J.sub(1.0, v_j_207)), "sy": (1.0 + J.mul(0.04, v_j_207))}])

func _f26(this_, a: Array, env):
	var v_ctx_210 = null; var v_S_211 = null; var v_g_212 = null; var v_t_213 = null
	v_ctx_210 = J.arg(a, 0)
	v_S_211 = J.arg(a, 1)
	v_g_212 = J.arg(a, 2)
	v_t_213 = J.arg(a, 3)
	var _t119 = env["drawPose"]
	J.cl(_t119, null, [v_ctx_210, v_S_211, "npc_hr", "stand", {}, {"idleK": 0.8}])

func _f27(this_, a: Array, env):
	var v_ctx_216 = null; var v_S_217 = null; var v_g_218 = null; var v_t_219 = null; var v_k_220 = null; var v_r_221 = null; var v_cb_222 = null; var v_i_223 = null; var v_q_224 = null
	v_ctx_216 = J.arg(a, 0)
	v_S_217 = J.arg(a, 1)
	v_g_218 = J.arg(a, 2)
	v_t_219 = J.arg(a, 3)
	var _t120 = J.gp(env["N"], "E")
	var _t121 = env["seg"]
	var _t124 = J.mc(_t120, "io", [J.cl(_t121, null, [v_g_218, 0.05, 0.2])])
	var _t122 = J.gp(env["N"], "E")
	var _t123 = env["seg"]
	v_k_220 = J.mul(_t124, J.sub(1.0, J.mc(_t122, "io", [J.cl(_t123, null, [v_g_218, 0.85, 1.0])])))
	var _t125 = env["drawPose"]
	var _t128 = J.mul(0.18, v_k_220)
	var _t129 = J.mul(0.04, v_k_220)
	var _t127 = J.mul((-0.12), v_k_220)
	var _t126 = env["sw"]
	v_r_221 = J.cl(_t125, null, [v_ctx_216, v_S_217, "npc_hr", "stand", {"head": _t128, "body": _t129, "armB": (_t127 + J.mul(J.mul(J.cl(_t126, null, [v_g_218, 6.0]), 0.03), v_k_220))}])
	if (not J.t(v_r_221)):
		return null
	v_cb_222 = J.mc(env["N"], "at", [J.gp(v_r_221, "S2"), J.gp(v_r_221, "m"), 0.55, 0.52])
	v_i_223 = 0.0
	while true:
		if not J.cmp(v_i_223, 3.0, "<"): break
		var _t130 = env["seg"]
		v_q_224 = J.cl(_t130, null, [v_g_218, (0.25 + J.mul(v_i_223, 0.18)), (0.45 + J.mul(v_i_223, 0.18))])
		var _t131 = J.cmp(v_q_224, 0.0, ">")
		if (J.cmp(v_q_224, 1.0, "<") if _t131 else _t131):
			J.mc(env["N"], "txt", [v_ctx_216, v_S_217, J.add(J.gp(v_cb_222, 0.0), J.mul((J.sub(v_i_223, 1.0) * 0.06), J.gp(v_S_217, "H"))), (J.sub(J.gp(v_cb_222, 1.0), J.mul(0.05, J.gp(v_S_217, "H"))) - J.mul(J.mul(v_q_224, 0.06), J.gp(v_S_217, "H"))), J.mul(0.07, J.gp(v_S_217, "H")), ("✗" if J.seq(v_i_223, 2.0) else "✓"), ("#ff5050" if J.seq(v_i_223, 2.0) else "#9ff0a0"), sin(J.num(J.mul(v_q_224, PI)))])
		v_i_223 = J.num(v_i_223) + 1.0

func _f28(this_, a: Array, env):
	var v_ctx_227 = null; var v_S_228 = null; var v_g_229 = null; var v_t_230 = null; var v_k_231 = null; var v_r_232 = null; var v_p_233 = null
	v_ctx_227 = J.arg(a, 0)
	v_S_228 = J.arg(a, 1)
	v_g_229 = J.arg(a, 2)
	v_t_230 = J.arg(a, 3)
	var _t132 = env["bump"]
	v_k_231 = J.cl(_t132, null, [v_g_229, 0.1, 0.7])
	var _t133 = env["drawPose"]
	v_r_232 = J.cl(_t133, null, [v_ctx_227, v_S_228, "npc_hr", "stand", {"head": J.mul((-0.1), v_k_231), "armB": J.mul((-0.35), v_k_231)}])
	if (not J.t(v_r_232)):
		return null
	var _t134 = J.cmp(v_g_229, 0.35, ">")
	if (J.cmp(v_g_229, 0.6, "<") if _t134 else _t134):
		v_p_233 = J.mc(env["N"], "at", [J.gp(v_r_232, "S2"), J.gp(v_r_232, "m"), 0.35, 0.3])
		var _t136 = J.gp(v_p_233, 0.0)
		var _t137 = J.gp(v_p_233, 1.0)
		var _t138 = J.mul(0.08, J.gp(v_S_228, "H"))
		var _t135 = env["seg"]
		J.mc(env["N"], "burst", [v_ctx_227, _t136, _t137, _t138, J.sub(1.0, J.cl(_t135, null, [v_g_229, 0.35, 0.6])), "#ffffff", 5.0, 6.0])
	var _t140 = J.mul(0.15, J.gp(v_S_228, "H"))
	var _t141 = J.mul((-1.05), J.gp(v_S_228, "H"))
	var _t142 = J.mul(0.08, J.gp(v_S_228, "H"))
	var _t139 = env["bump"]
	J.mc(env["N"], "txt", [v_ctx_227, v_S_228, _t140, _t141, _t142, "嗯哼～", "#ffd0e0", J.cl(_t139, null, [v_g_229, 0.4, 0.95])])

func _f29(this_, a: Array, env):
	var v_ctx_236 = null; var v_S_237 = null; var v_g_238 = null; var v_t_239 = null; var v_ph_240 = null; var v_hit_241 = null; var v_k_242 = null; var v_r_243 = null; var v_sp_244 = null
	v_ctx_236 = J.arg(a, 0)
	v_S_237 = J.arg(a, 1)
	v_g_238 = J.arg(a, 2)
	v_t_239 = J.arg(a, 3)
	v_ph_240 = J.mod(J.mul(v_g_238, 2.0), 1.0)
	var _t143 = J.cmp(v_ph_240, 0.45, ">")
	v_hit_241 = (J.cmp(v_ph_240, 0.6, "<") if _t143 else _t143)
	var _t146 = null
	if J.cmp(v_ph_240, 0.4, "<"):
		_t146 = (-J.num(J.mc(env["E"], "o", [J.div(v_ph_240, 0.4)])))
	else:
		var _t145 = null
		if J.cmp(v_ph_240, 0.5, "<"):
			_t145 = ((-1.0) + J.mul(2.0, J.mc(env["E"], "i", [J.div(J.sub(v_ph_240, 0.4), 0.1)])))
		else:
			var _t144 = env["seg"]
			_t145 = J.sub(1.0, J.mc(env["E"], "io", [J.cl(_t144, null, [v_ph_240, 0.5, 1.0])]))
		_t146 = _t145
	v_k_242 = _t146
	var _t147 = env["drawPose"]
	v_r_243 = J.cl(_t147, null, [v_ctx_236, v_S_237, "npc_hr", "stamp", {"armF": J.mul((-0.25), v_k_242), "body": J.mul(0.05, v_k_242), "head": J.mul(0.04, v_k_242), "x": (J.mul((sin(J.num(J.mul(v_t_239, 90.0))) * 0.004), J.gp(v_S_237, "H")) if J.t(v_hit_241) else 0.0), "sy": (1.0 - (0.03 * J.max_([0.0, v_k_242])))}])
	if (not J.t(v_r_243)):
		return null
	v_sp_244 = J.mc(env["N"], "at", [J.gp(v_r_243, "S2"), J.gp(v_r_243, "m"), 0.4, 0.86])
	if J.cmp(v_ph_240, 0.48, ">"):
		var _t148 = env["seal"]
		var _t150 = J.sub(J.gp(v_sp_244, 0.0), J.mul(J.gp(v_S_237, "fw"), 0.0))
		var _t151 = J.sub(J.gp(v_sp_244, 1.0), J.mul(0.01, J.gp(v_S_237, "H")))
		var _t152 = J.mul(0.12, J.gp(v_S_237, "H"))
		var _t149 = env["seg"]
		var _t154 = J.cl(_t149, null, [v_ph_240, 0.48, 0.55])
		var _t153 = env["seg"]
		J.cl(_t148, null, [v_ctx_236, v_S_237, _t150, _t151, _t152, "批", _t154, J.sub(1.0, J.cl(_t153, null, [v_ph_240, 0.85, 1.0]))])
		var _t156 = J.gp(v_sp_244, 0.0)
		var _t157 = J.sub(J.gp(v_sp_244, 1.0), J.mul(0.05, J.gp(v_S_237, "H")))
		var _t158 = J.mul(0.12, J.gp(v_S_237, "H"))
		var _t155 = env["seg"]
		J.mc(env["N"], "burst", [v_ctx_236, _t156, _t157, _t158, J.sub(1.0, J.cl(_t155, null, [v_ph_240, 0.48, 0.65])), "#ffe14a", 7.0, 7.0])

func _f30(this_, a: Array, env):
	var v_ctx_247 = null; var v_S_248 = null; var v_g_249 = null; var v_t_250 = null
	v_ctx_247 = J.arg(a, 0)
	v_S_248 = J.arg(a, 1)
	v_g_249 = J.arg(a, 2)
	v_t_250 = J.arg(a, 3)
	var _t159 = env["drawPose"]
	J.cl(_t159, null, [v_ctx_247, v_S_248, "npc_hr", "walk", {"body": 0.05, "y": J.mul(((-absf(J.num(sin(J.num(J.mul(v_t_250, 3.0)))))) * 0.02), J.gp(v_S_248, "H")), "tail1": ((-0.2) + (sin(J.num(J.mul(v_t_250, 5.0))) * 0.1)), "tail2": ((-0.3) + (sin(J.num((J.mul(v_t_250, 5.0) - 1.0))) * 0.15))}, {"idleK": 1.0}])

func _f31(this_, a: Array, env):
	var v_ctx_253 = null; var v_S_254 = null; var v_g_255 = null; var v_t_256 = null; var v_j_257 = null
	v_ctx_253 = J.arg(a, 0)
	v_S_254 = J.arg(a, 1)
	v_g_255 = J.arg(a, 2)
	v_t_256 = J.arg(a, 3)
	var _t160 = env["bump"]
	v_j_257 = J.cl(_t160, null, [v_g_255, 0.0, 0.35])
	var _t161 = env["drawPose"]
	J.cl(_t161, null, [v_ctx_253, v_S_254, "npc_hr", "jump", {"y": J.mul(J.mul((-0.1), J.gp(v_S_254, "H")), v_j_257), "x": (J.mul((sin(J.num(J.mul(v_t_256, 50.0))) * 0.006), J.gp(v_S_254, "H")) * J.sub(1.0, v_j_257))}])

func _f32(this_, a: Array, env):
	var v_ctx_260 = null; var v_S_261 = null; var v_g_262 = null; var v_t_263 = null
	v_ctx_260 = J.arg(a, 0)
	v_S_261 = J.arg(a, 1)
	v_g_262 = J.arg(a, 2)
	v_t_263 = J.arg(a, 3)
	var _t162 = env["drawPose"]
	J.cl(_t162, null, [v_ctx_260, v_S_261, "npc_kpiboss", "stand", {"y": J.mul(((-sin(J.num(J.mul(v_t_263, 1.6)))) * 0.01), J.gp(v_S_261, "H"))}, {"idleK": 0.8}])

func _f33(this_, a: Array, env):
	var v_ctx_266 = null; var v_S_267 = null; var v_g_268 = null; var v_t_269 = null
	v_ctx_266 = J.arg(a, 0)
	v_S_267 = J.arg(a, 1)
	v_g_268 = J.arg(a, 2)
	v_t_269 = J.arg(a, 3)
	var _t163 = env["drawPose"]
	var _t164 = env["sw"]
	var _t166 = J.mul(J.cl(_t164, null, [v_g_268]), 0.12)
	var _t165 = env["sw"]
	var _t168 = J.mul(J.cl(_t165, null, [v_g_268, 1.0, 0.5]), 0.03)
	var _t167 = env["sw"]
	J.cl(_t163, null, [v_ctx_266, v_S_267, "npc_kpiboss", "stand", {"head": _t166, "body": _t168, "x": J.mul(J.mul(J.cl(_t167, null, [v_g_268]), 0.04), J.gp(v_S_267, "H"))}])
	var _t170 = J.mul(0.25, J.gp(v_S_267, "H"))
	var _t171 = J.mul((-1.1), J.gp(v_S_267, "H"))
	var _t172 = J.mul(0.085, J.gp(v_S_267, "H"))
	var _t169 = env["bump"]
	J.mc(env["N"], "txt", [v_ctx_266, v_S_267, _t170, _t171, _t172, "嗯……", "#e8e8f0", J.cl(_t169, null, [v_g_268, 0.3, 0.8])])

func _f34(this_, a: Array, env):
	var v_ctx_272 = null; var v_S_273 = null; var v_g_274 = null; var v_t_275 = null; var v_r_276 = null; var v_tb_277 = null
	v_ctx_272 = J.arg(a, 0)
	v_S_273 = J.arg(a, 1)
	v_g_274 = J.arg(a, 2)
	v_t_275 = J.arg(a, 3)
	var _t173 = env["drawPose"]
	var _t174 = env["sw"]
	var _t175 = env["sw"]
	v_r_276 = J.cl(_t173, null, [v_ctx_272, v_S_273, "npc_kpiboss", "walk", {"armF": (J.max_([0.0, J.cl(_t175, null, [v_g_274, 4.0])]) * 0.08), "head": 0.06}])
	if (not J.t(v_r_276)):
		return null
	v_tb_277 = J.mc(env["N"], "at", [J.gp(v_r_276, "S2"), J.gp(v_r_276, "m"), 0.8, 0.42])
	var _t176 = env["crash"]
	var _t178 = J.gp(v_tb_277, 0.0)
	var _t179 = J.sub(J.gp(v_tb_277, 1.0), J.mul(0.32, J.gp(v_S_273, "H")))
	var _t180 = J.mul(0.22, J.gp(v_S_273, "H"))
	var _t177 = env["seg"]
	J.cl(_t176, null, [v_ctx_272, _t178, _t179, _t180, J.cl(_t177, null, [v_g_274, 0.1, 0.6]), 11.0])
	var _t182 = J.gp(v_tb_277, 0.0)
	var _t183 = J.sub(J.gp(v_tb_277, 1.0), J.mul(0.55, J.gp(v_S_273, "H")))
	var _t184 = J.mul(0.08, J.gp(v_S_273, "H"))
	var _t181 = env["bump"]
	J.mc(env["N"], "txt", [v_ctx_272, v_S_273, _t182, _t183, _t184, "又跌？", "#ff7070", J.cl(_t181, null, [v_g_274, 0.5, 0.95])])

func _f35(this_, a: Array, env):
	var v_ctx_280 = null; var v_S_281 = null; var v_g_282 = null; var v_t_283 = null; var v_k_284 = null
	v_ctx_280 = J.arg(a, 0)
	v_S_281 = J.arg(a, 1)
	v_g_282 = J.arg(a, 2)
	v_t_283 = J.arg(a, 3)
	var _t185 = env["bump"]
	v_k_284 = J.cl(_t185, null, [v_g_282, 0.15, 0.9])
	var _t186 = env["drawPose"]
	J.cl(_t186, null, [v_ctx_280, v_S_281, "npc_kpiboss", "stand", {"head": J.mul(0.15, v_k_284), "sy": (1.0 - J.mul(0.04, v_k_284)), "y": J.mul(J.mul(0.02, J.gp(v_S_281, "H")), v_k_284)}])
	var _t188 = J.mul(0.2, J.gp(v_S_281, "H"))
	var _t189 = J.mul((-0.75), J.gp(v_S_281, "H"))
	var _t190 = J.mul(0.06, J.gp(v_S_281, "H"))
	var _t187 = env["seg"]
	J.mc(env["N"], "puff", [v_ctx_280, _t188, _t189, _t190, J.cl(_t187, null, [v_g_282, 0.3, 0.9]), "rgba(220,220,230,.55)", 13.0, 4.0])
	var _t192 = J.mul(0.25, J.gp(v_S_281, "H"))
	var _t193 = J.mul((-1.05), J.gp(v_S_281, "H"))
	var _t194 = J.mul(0.09, J.gp(v_S_281, "H"))
	var _t191 = env["bump"]
	J.mc(env["N"], "txt", [v_ctx_280, v_S_281, _t192, _t193, _t194, "唉……", "#e0e0ea", J.cl(_t191, null, [v_g_282, 0.3, 0.9])])

func _f36(this_, a: Array, env):
	var v_ctx_287 = null; var v_S_288 = null; var v_g_289 = null; var v_t_290 = null; var v_sh_291 = null; var v_r_292 = null; var v_mo_293 = null
	v_ctx_287 = J.arg(a, 0)
	v_S_288 = J.arg(a, 1)
	v_g_289 = J.arg(a, 2)
	v_t_290 = J.arg(a, 3)
	v_sh_291 = J.mul((sin(J.num(J.mul(v_t_290, 70.0))) * 0.006), J.gp(v_S_288, "H"))
	var _t195 = env["drawPose"]
	var _t196 = env["sw"]
	v_r_292 = J.cl(_t195, null, [v_ctx_287, v_S_288, "npc_kpiboss", "yell", {"x": v_sh_291, "head": J.mul(J.cl(_t196, null, [v_g_289, 3.0]), 0.04)}])
	if (not J.t(v_r_292)):
		return null
	v_mo_293 = J.mc(env["N"], "at", [J.gp(v_r_292, "S2"), J.gp(v_r_292, "m"), 0.62, 0.36])
	var _t197 = env["rings"]
	J.cl(_t197, null, [v_ctx_287, J.add(J.gp(v_mo_293, 0.0), J.mul(0.1, J.gp(v_S_288, "H"))), J.gp(v_mo_293, 1.0), J.mul(0.3, J.gp(v_S_288, "H")), J.mod(J.mul(v_g_289, 2.0), 1.0), "rgba(255,240,240,.9)"])
	J.mc(env["N"], "txt", [v_ctx_287, v_S_288, J.mul(0.15, J.gp(v_S_288, "H")), J.mul((-1.15), J.gp(v_S_288, "H")), J.mul(0.11, J.gp(v_S_288, "H")), "KPI 呢？！", "#ff5050", 0.95])

func _f37(this_, a: Array, env):
	var v_ctx_296 = null; var v_S_297 = null; var v_g_298 = null; var v_t_299 = null
	v_ctx_296 = J.arg(a, 0)
	v_S_297 = J.arg(a, 1)
	v_g_298 = J.arg(a, 2)
	v_t_299 = J.arg(a, 3)
	var _t198 = env["drawPose"]
	J.cl(_t198, null, [v_ctx_296, v_S_297, "npc_kpiboss", "walk", {"body": 0.05, "y": J.mul(((-absf(J.num(sin(J.num(J.mul(v_t_299, 3.0)))))) * 0.02), J.gp(v_S_297, "H")), "tail1": ((-0.2) + (sin(J.num(J.mul(v_t_299, 5.0))) * 0.1)), "tail2": ((-0.3) + (sin(J.num((J.mul(v_t_299, 5.0) - 1.0))) * 0.15))}, {"idleK": 1.0}])

func _f38(this_, a: Array, env):
	var v_ctx_302 = null; var v_S_303 = null; var v_g_304 = null; var v_t_305 = null; var v_j_306 = null
	v_ctx_302 = J.arg(a, 0)
	v_S_303 = J.arg(a, 1)
	v_g_304 = J.arg(a, 2)
	v_t_305 = J.arg(a, 3)
	var _t199 = env["bump"]
	v_j_306 = J.cl(_t199, null, [v_g_304, 0.0, 0.35])
	var _t200 = env["drawPose"]
	J.cl(_t200, null, [v_ctx_302, v_S_303, "npc_kpiboss", "jump", {"y": J.mul(J.mul((-0.12), J.gp(v_S_303, "H")), v_j_306), "x": (J.mul((sin(J.num(J.mul(v_t_305, 50.0))) * 0.006), J.gp(v_S_303, "H")) * J.sub(1.0, v_j_306))}])

func _f42(this_, a: Array, env):
	var v_ctx_329 = null; var v_a_330 = null
	v_ctx_329 = J.arg(a, 0)
	v_a_330 = J.arg(a, 1)
	var _t207 = null
	if J.t(J.gp(env["__p"]["P"], J.gp(v_a_330, "type"))):
		var _t204 = env["__p"]["run"]
		var _t206 = env["st"]
		var _t205 = J.gp(J.gp(v_a_330, "o"), "at")
		_t207 = J.cl(_t204, null, [v_ctx_329, v_a_330, _t206, (_t205 if J.t(_t205) else 0.0)])
	else:
		_t207 = false
	return _t207

func _f43(this_, a: Array, env):
	var v_ctx_333 = null; var v_a_334 = null; var v_S_335 = null; var v_t_336 = null; var v_H_337 = null; var v_th_338 = null; var v_D2_339 = null; var v_f_340 = null; var v_r_341 = null; var v_c0_342 = null; var v_hd_343 = null; var v_chest_344 = null; var v_R_345 = null; var v_bx_346 = null; var v_by_347 = null; var v_rot_348 = null; var v_p_349 = null; var v_q_350 = null; var v_up_351 = null; var v_up_352 = null; var v_q_353 = null; var v_q_354 = null; var v_q_355 = null; var v_rest_356 = null
	v_ctx_333 = J.arg(a, 0)
	v_a_334 = J.arg(a, 1)
	var _t210 = env["setup"]
	v_S_335 = J.cl(_t210, null, [v_a_334])
	if (not J.t(v_S_335)):
		return false
	v_t_336 = J.gp(v_S_335, "tt")
	v_H_337 = J.gp(v_S_335, "H")
	v_th_338 = J.gp(v_S_335, "th")
	v_D2_339 = J.max_([0.0, (J.sub(J.gp(v_S_335, "tx"), J.mul(0.45, v_th_338)) - J.mul(0.25, v_H_337))])
	v_f_340 = J.mc(env["N"], "kf", [v_t_336, [[0.0, {}], [0.16, {"sy": 0.88, "sx": 1.05, "armF": 0.3, "armB": 0.3, "head": 0.06}], [0.22, {"y": J.mul((-0.35), v_H_337), "x": J.mul(v_D2_339, 0.6), "sy": 1.06, "armF": (-0.8), "armB": (-0.5), "head": (-0.1)}, "o"], [J.gp(env["N"], "TC"), {"y": J.mul((-0.18), v_H_337), "x": v_D2_339, "armF": (-0.2), "armB": (-0.1), "r": 10.0, "head": 0.12}, "i"], [0.36, {"y": 0.0, "x": v_D2_339, "sy": 0.93}, "i"], [0.59, {}]]])
	var _t211 = env["begin"]
	var _t212 = env["cl"]
	var _t213 = J.gp(v_f_340, "y")
	J.cl(_t211, null, [v_ctx_333, v_S_335, v_f_340, (1.0 - J.mul(J.cl(_t212, null, [J.div((-J.num((_t213 if J.t(_t213) else 0.0))), v_H_337)]), 0.6))])
	var _t214 = env["drawPose"]
	v_r_341 = J.cl(_t214, null, [v_ctx_333, v_S_335, "npc_rival", "stand", v_f_340, {"cut": true}])
	if (not J.t(v_r_341)):
		var _t215 = env["end"]
		J.cl(_t215, null, [v_ctx_333])
		return false
	var _t216 = env["ballRest"]
	v_c0_342 = J.cl(_t216, null, [J.gp(v_r_341, "S2"), J.gp(v_r_341, "m")])
	v_hd_343 = J.mc(env["N"], "tgt", [v_S_335, 0.95])
	v_chest_344 = J.mc(env["N"], "at", [J.gp(v_r_341, "S2"), J.gp(v_r_341, "m"), 0.45, 0.42])
	var _t217 = env["ballR"]
	v_R_345 = J.cl(_t217, null, [J.gp(v_r_341, "S2")])
	v_bx_346 = null
	v_by_347 = null
	v_rot_348 = J.mul(v_t_336, 600.0)
	if J.cmp(v_t_336, 0.16, "<"):
		var _t218 = env["seg"]
		v_q_350 = J.mc(env["E"], "io", [J.cl(_t218, null, [v_t_336, 0.02, 0.16])])
		var _t219 = env["lerp"]
		var _t220 = J.cl(_t219, null, [J.gp(v_c0_342, 0.0), J.gp(v_chest_344, 0.0), v_q_350])
		v_bx_346 = _t220
		var _t221 = env["lerp"]
		var _t222 = J.cl(_t221, null, [J.gp(v_c0_342, 1.0), J.gp(v_chest_344, 1.0), v_q_350])
		v_by_347 = _t222
	else:
		if J.cmp(v_t_336, 0.22, "<"):
			v_up_351 = J.mc(env["N"], "at", [J.gp(v_r_341, "S2"), J.gp(v_r_341, "m"), 0.3, 0.0])
			var _t223 = env["lerp"]
			var _t225 = J.gp(v_chest_344, 0.0)
			var _t226 = J.gp(v_up_351, 0.0)
			var _t224 = env["seg"]
			var _t227 = J.cl(_t223, null, [_t225, _t226, J.mc(env["E"], "o", [J.cl(_t224, null, [v_t_336, 0.16, 0.22])])])
			v_bx_346 = _t227
			var _t228 = env["lerp"]
			var _t230 = J.gp(v_chest_344, 1.0)
			var _t231 = J.gp(v_up_351, 1.0)
			var _t229 = env["seg"]
			var _t232 = J.cl(_t228, null, [_t230, _t231, J.mc(env["E"], "o", [J.cl(_t229, null, [v_t_336, 0.16, 0.22])])])
			v_by_347 = _t232
		else:
			if J.cmp(v_t_336, J.gp(env["N"], "TC"), "<"):
				v_up_352 = J.mc(env["N"], "at", [J.gp(v_r_341, "S2"), J.gp(v_r_341, "m"), 0.3, 0.0])
				var _t233 = env["seg"]
				v_q_353 = J.mc(env["E"], "i", [J.cl(_t233, null, [v_t_336, 0.22, J.gp(env["N"], "TC")])])
				var _t234 = env["lerp"]
				var _t235 = J.cl(_t234, null, [J.gp(v_up_352, 0.0), J.gp(v_hd_343, 0.0), v_q_353])
				v_bx_346 = _t235
				var _t236 = env["lerp"]
				var _t237 = J.cl(_t236, null, [J.gp(v_up_352, 1.0), J.sub(J.gp(v_hd_343, 1.0), v_R_345), v_q_353])
				v_by_347 = _t237
			else:
				if J.cmp(v_t_336, 0.4, "<"):
					var _t238 = env["seg"]
					v_q_354 = J.cl(_t238, null, [v_t_336, J.gp(env["N"], "TC"), 0.4])
					var _t239 = J.add(J.gp(v_hd_343, 0.0), J.mul(J.mul(v_q_354, 0.1), v_th_338))
					v_bx_346 = _t239
					var _t240 = env["lerp"]
					var _t241 = J.cl(_t240, null, [J.sub(J.gp(v_hd_343, 1.0), v_R_345), (-J.num(v_R_345)), J.mc(env["E"], "i", [v_q_354])])
					v_by_347 = _t241
				else:
					var _t242 = env["seg"]
					v_q_355 = J.cl(_t242, null, [v_t_336, 0.4, 0.59])
					var _t243 = env["ballRest"]
					v_rest_356 = J.cl(_t243, null, [J.gp(v_r_341, "S2"), J.mc(env["N"], "bm", [J.gp(v_r_341, "S2"), {}])])
					var _t244 = env["lerp"]
					var _t245 = J.cl(_t244, null, [J.add(J.gp(v_hd_343, 0.0), J.mul(0.1, v_th_338)), J.gp(v_rest_356, 0.0), J.mc(env["E"], "io", [v_q_355])])
					v_bx_346 = _t245
					var _t246 = env["lerp"]
					var _t247 = J.sub(J.cl(_t246, null, [(-J.num(v_R_345)), J.gp(v_rest_356, 1.0), J.mc(env["E"], "o", [v_q_355])]), J.mul((sin(J.num(J.mul(v_q_355, PI))) * 0.3), v_H_337))
					v_by_347 = _t247
	var _t248 = env["ball"]
	J.cl(_t248, null, [v_ctx_333, J.gp(v_r_341, "S2"), v_bx_346, v_by_347, v_rot_348])
	var _t249 = J.cmp(v_t_336, 0.2, ">")
	if (J.cmp(v_t_336, J.gp(env["N"], "TC"), "<") if _t249 else _t249):
		J.mc(env["N"], "speed", [v_ctx_333, v_bx_346, J.sub(v_by_347, v_R_345), 0.3, 1.0, J.mul(0.3, v_H_337), J.mul(0.15, v_H_337), 0.8, "rgba(255,240,220,.7)", 21.0, 4.0])
	v_p_349 = J.sub(v_t_336, J.gp(env["N"], "TC"))
	var _t250 = J.cmp(v_p_349, 0.0, ">=")
	if (J.cmp(v_p_349, 0.14, "<") if _t250 else _t250):
		J.mc(env["N"], "burst", [v_ctx_333, J.gp(v_hd_343, 0.0), J.gp(v_hd_343, 1.0), J.mul(0.4, v_th_338), (1.0 - J.div(v_p_349, 0.14)), "#ffd27a", 23.0, 11.0])
	var _t251 = J.cmp(v_t_336, 0.36, ">")
	if (J.cmp(v_t_336, 0.42, "<") if _t251 else _t251):
		var _t253 = J.mul((-0.02), v_H_337)
		var _t254 = J.mul(0.06, v_H_337)
		var _t252 = env["seg"]
		J.mc(env["N"], "puff", [v_ctx_333, v_bx_346, _t253, _t254, J.cl(_t252, null, [v_t_336, 0.36, 0.42]), "rgba(200,190,170,.5)", 25.0, 3.0])
	J.mc(env["N"], "pop", [v_ctx_333, v_S_335, J.gp(v_hd_343, 0.0), J.sub(J.gp(v_hd_343, 1.0), J.mul(0.35, v_th_338)), "入波！", J.mul(0.26, v_th_338), "#ffb347", J.gp(env["N"], "TC"), 0.3])
	J.mc(env["N"], "hit", [v_S_335, J.gp(v_hd_343, 0.0), J.gp(v_hd_343, 1.0)])
	var _t255 = env["end"]
	J.cl(_t255, null, [v_ctx_333])

func _f44(this_, a: Array, env):
	var v_ctx_359 = null; var v_a_360 = null; var v_S_361 = null; var v_t_362 = null; var v_H_363 = null; var v_th_364 = null; var v_T_365 = null; var v_D2_366 = null; var v_p_367 = null; var v_k_368 = null; var v_f_369 = null
	v_ctx_359 = J.arg(a, 0)
	v_a_360 = J.arg(a, 1)
	var _t258 = env["setup"]
	v_S_361 = J.cl(_t258, null, [v_a_360])
	if (not J.t(v_S_361)):
		return false
	v_t_362 = J.gp(v_S_361, "tt")
	v_H_363 = J.gp(v_S_361, "H")
	v_th_364 = J.gp(v_S_361, "th")
	v_T_365 = J.mc(env["N"], "tgt", [v_S_361, 0.55])
	v_D2_366 = J.max_([0.0, (J.sub(J.gp(v_S_361, "tx"), J.mul(0.42, v_th_364)) - J.mul(0.18, v_H_363))])
	var _t259 = env["begin"]
	J.cl(_t259, null, [v_ctx_359, v_S_361, null, 1.0])
	var _t260 = J.cmp(v_t_362, 0.2, "<")
	if (_t260 if _t260 else J.cmp(v_t_362, 0.46, ">")):
		var _t263 = null
		if J.cmp(v_t_362, 0.2, "<"):
			var _t261 = env["seg"]
			_t263 = J.mc(env["E"], "o", [J.cl(_t261, null, [v_t_362, 0.0, 0.18])])
		else:
			var _t262 = env["seg"]
			_t263 = J.sub(1.0, J.mc(env["E"], "io", [J.cl(_t262, null, [v_t_362, 0.46, 0.59])]))
		v_k_368 = _t263
		var _t264 = env["drawPose"]
		J.cl(_t264, null, [v_ctx_359, v_S_361, "npc_hr", "stand", ({"r": J.mul((-8.0), v_k_368), "armF": J.mul(0.6, v_k_368), "head": J.mul((-0.1), v_k_368), "x": J.mul(J.mul((-0.03), v_H_363), v_k_368)} if J.cmp(v_t_362, 0.2, "<") else {"x": J.mul(J.mul(v_D2_366, 0.3), v_k_368), "r": J.mul(3.0, v_k_368)})])
	else:
		v_f_369 = J.mc(env["N"], "kf", [v_t_362, [[0.2, {"x": J.mul(v_D2_366, 0.6), "y": J.mul((-0.04), v_H_363), "armF": 0.35, "sy": 1.03}], [J.gp(env["N"], "TC"), {"x": v_D2_366, "armF": (-0.25), "sy": 0.95, "body": 0.05}, "i"], [0.36, {"x": v_D2_366, "armF": (-0.2), "sy": 0.97}], [0.46, {"x": J.mul(v_D2_366, 0.6)}]]])
		var _t265 = J.cmp(v_t_362, J.gp(env["N"], "TC"), ">")
		if (J.cmp(v_t_362, 0.34, "<") if _t265 else _t265):
			var _t266 = J.add(J.gp(v_f_369, "x"), J.mul((sin(J.num(J.mul(v_t_362, 120.0))) * 0.004), v_H_363))
			J.sp(v_f_369, "x", _t266)
		var _t267 = env["drawPose"]
		J.cl(_t267, null, [v_ctx_359, v_S_361, "npc_hr", "stamp", v_f_369])
	v_p_367 = J.sub(v_t_362, J.gp(env["N"], "TC"))
	if J.cmp(v_p_367, 0.0, ">="):
		var _t268 = env["seal"]
		var _t270 = J.gp(v_T_365, 0.0)
		var _t271 = J.gp(v_T_365, 1.0)
		var _t272 = J.mul(0.36, v_th_364)
		var _t269 = env["seg"]
		var _t274 = J.cl(_t269, null, [v_p_367, 0.0, 0.06])
		var _t273 = env["seg"]
		J.cl(_t268, null, [v_ctx_359, v_S_361, _t270, _t271, _t272, "警告", _t274, J.sub(1.0, J.cl(_t273, null, [v_t_362, 0.5, 0.59]))])
	var _t275 = J.cmp(v_p_367, 0.0, ">=")
	if (J.cmp(v_p_367, 0.14, "<") if _t275 else _t275):
		J.mc(env["N"], "burst", [v_ctx_359, J.gp(v_T_365, 0.0), J.gp(v_T_365, 1.0), J.mul(0.38, v_th_364), (1.0 - J.div(v_p_367, 0.14)), "#ffd0d0", 31.0, 11.0])
	J.mc(env["N"], "pop", [v_ctx_359, v_S_361, J.gp(v_T_365, 0.0), J.sub(J.gp(v_T_365, 1.0), J.mul(0.6, v_th_364)), "扣你假！", J.mul(0.2, v_th_364), "#ff6060", J.add(J.gp(env["N"], "TC"), 0.02), 0.3])
	J.mc(env["N"], "hit", [v_S_361, J.gp(v_T_365, 0.0), J.gp(v_T_365, 1.0)])
	var _t276 = env["end"]
	J.cl(_t276, null, [v_ctx_359])

func _f45(this_, a: Array, env):
	var v_ctx_372 = null; var v_a_373 = null; var v_S_374 = null; var v_t_375 = null; var v_H_376 = null; var v_th_377 = null; var v_D2_378 = null; var v_T_379 = null; var v_p_380 = null; var v_f_381 = null; var v_k_382 = null; var v_y0_383 = null; var v_y_384 = null
	v_ctx_372 = J.arg(a, 0)
	v_a_373 = J.arg(a, 1)
	var _t279 = env["setup"]
	v_S_374 = J.cl(_t279, null, [v_a_373])
	if (not J.t(v_S_374)):
		return false
	v_t_375 = J.gp(v_S_374, "tt")
	v_H_376 = J.gp(v_S_374, "H")
	v_th_377 = J.gp(v_S_374, "th")
	v_D2_378 = J.max_([0.0, (J.sub(J.gp(v_S_374, "tx"), J.mul(0.45, v_th_377)) - J.mul(0.25, v_H_376))])
	v_T_379 = J.mc(env["N"], "tgt", [v_S_374, 0.6])
	var _t280 = env["begin"]
	J.cl(_t280, null, [v_ctx_372, v_S_374, null, 0.9])
	if J.cmp(v_t_375, 0.2, "<"):
		var _t281 = env["drawPose"]
		var _t282 = env["seg"]
		var _t285 = J.mul(0.1, J.mc(env["E"], "o", [J.cl(_t282, null, [v_t_375, 0.0, 0.18])]))
		var _t284 = J.mul((-0.04), v_H_376)
		var _t283 = env["seg"]
		var _t288 = J.mul(_t284, J.mc(env["E"], "o", [J.cl(_t283, null, [v_t_375, 0.0, 0.18])]))
		var _t287 = J.mul((sin(J.num(J.mul(v_t_375, 80.0))) * 0.004), v_H_376)
		var _t286 = env["seg"]
		J.cl(_t281, null, [v_ctx_372, v_S_374, "npc_kpiboss", "walk", {"head": _t285, "y": _t288, "x": J.mul(_t287, J.cl(_t286, null, [v_t_375, 0.08, 0.2]))}])
	else:
		if J.cmp(v_t_375, 0.46, "<"):
			v_f_381 = J.mc(env["N"], "kf", [v_t_375, [[0.2, {"x": J.mul(v_D2_378, 0.5), "y": J.mul((-0.08), v_H_376)}], [J.gp(env["N"], "TC"), {"x": v_D2_378, "y": J.mul(0.02, v_H_376), "sy": 0.94, "r": 6.0}, "i"], [0.36, {"x": v_D2_378, "sy": 0.97, "r": 4.0}], [0.46, {"x": J.mul(v_D2_378, 0.6)}]]])
			var _t289 = J.cmp(v_t_375, J.gp(env["N"], "TC"), ">")
			if (J.cmp(v_t_375, 0.36, "<") if _t289 else _t289):
				var _t290 = J.add(J.gp(v_f_381, "x"), J.mul((sin(J.num(J.mul(v_t_375, 110.0))) * 0.005), v_H_376))
				J.sp(v_f_381, "x", _t290)
			var _t291 = env["drawPose"]
			J.cl(_t291, null, [v_ctx_372, v_S_374, "npc_kpiboss", "yell", v_f_381])
		else:
			var _t292 = env["drawPose"]
			var _t294 = J.mul(v_D2_378, 0.6)
			var _t293 = env["seg"]
			J.cl(_t292, null, [v_ctx_372, v_S_374, "npc_kpiboss", "stand", {"x": (_t294 * J.sub(1.0, J.mc(env["E"], "io", [J.cl(_t293, null, [v_t_375, 0.46, 0.59])])))}])
	v_p_380 = J.sub(v_t_375, J.gp(env["N"], "TC"))
	var _t295 = J.cmp(v_p_380, (-0.06), ">=")
	if (J.cmp(v_t_375, 0.5, "<") if _t295 else _t295):
		var _t296 = env["seg"]
		v_k_382 = J.cl(_t296, null, [v_t_375, J.sub(J.gp(env["N"], "TC"), 0.06), J.gp(env["N"], "TC")])
		v_y0_383 = J.sub(J.gp(v_T_379, 1.0), J.mul(0.85, v_th_377))
		var _t297 = env["lerp"]
		v_y_384 = J.cl(_t297, null, [v_y0_383, J.sub(J.gp(v_T_379, 1.0), J.mul(0.25, v_th_377)), J.mc(env["E"], "i", [v_k_382])])
		J.mc(v_ctx_372, "save", [])
		var _t298 = env["seg"]
		var _t299 = J.mul(J.gp(v_ctx_372, "globalAlpha"), J.sub(1.0, J.cl(_t298, null, [v_t_375, 0.42, 0.5])))
		J.sp(v_ctx_372, "globalAlpha", _t299)
		var _t300 = env["crash"]
		J.cl(_t300, null, [v_ctx_372, J.add(J.gp(v_T_379, 0.0), J.mul(0.05, v_th_377)), v_y_384, J.mul(0.36, v_th_377), 1.0, 41.0])
		J.mc(v_ctx_372, "restore", [])
	if J.cmp(v_p_380, 0.0, ">="):
		var _t301 = env["rings"]
		var _t303 = J.sub(J.gp(v_T_379, 0.0), J.mul(0.2, v_th_377))
		var _t304 = J.sub(J.gp(v_S_374, "ty"), J.mul(0.05, v_th_377))
		var _t305 = J.mul(0.6, v_th_377)
		var _t302 = env["seg"]
		J.cl(_t301, null, [v_ctx_372, _t303, _t304, _t305, J.cl(_t302, null, [v_p_380, 0.0, 0.3]), "rgba(255,220,220,.9)"])
	var _t306 = J.cmp(v_p_380, 0.0, ">=")
	if (J.cmp(v_p_380, 0.14, "<") if _t306 else _t306):
		J.mc(env["N"], "burst", [v_ctx_372, J.gp(v_T_379, 0.0), J.gp(v_T_379, 1.0), J.mul(0.4, v_th_377), (1.0 - J.div(v_p_380, 0.14)), "#ffb0b0", 43.0, 12.0])
	J.mc(env["N"], "pop", [v_ctx_372, v_S_374, J.sub(J.gp(v_T_379, 0.0), J.mul(0.15, v_th_377)), J.sub(J.gp(v_T_379, 1.0), J.mul(0.95, v_th_377)), "KPI 呢？！", J.mul(0.2, v_th_377), "#ff5050", J.gp(env["N"], "TC"), 0.32])
	J.mc(env["N"], "hit", [v_S_374, J.gp(v_T_379, 0.0), J.gp(v_T_379, 1.0)])
	var _t307 = env["end"]
	J.cl(_t307, null, [v_ctx_372])

func _f47(this_, a: Array, env):
	var v_id_401 = null; var v_st_402 = null
	v_id_401 = J.arg(a, 0)
	v_st_402 = J.arg(a, 1)
	var _t309 = J.gp(env["DUR"], v_st_402)
	return (_t309 if J.t(_t309) else (0.59 if J.seq(v_st_402, "attack") else 2.0))

func _f1(this_, a: Array, env):
	var v_D_4 = null; var v_rnd_10 = null; var v_draw_36 = null; var v_id_43 = null; var v_d_44 = null; var v_k_45 = null; var v_p_46 = null; var v_R_47 = null
	var _s2 = {"__p": env, "N": null, "A": null, "TAU": null, "E": null, "seg": null, "lerp": null, "cl": null, "sw": null, "bump": null, "P": null, "CUTS": null, "BALL": null, "nb": null, "poseS": null, "mp": null, "drawPose": null, "setup": null, "begin": null, "end": null, "ball": null, "ballRest": null, "ballR": null, "seal": null, "crash": null, "rings": null, "ACT": null, "PRE": null, "DUR": null, "STATES": null, "actFn": null, "run": null, "custom": null}
	_s2["poseS"] = Callable(self, "_f7").bind(_s2)
	_s2["mp"] = Callable(self, "_f8").bind(_s2)
	_s2["drawPose"] = Callable(self, "_f9").bind(_s2)
	_s2["setup"] = Callable(self, "_f10").bind(_s2)
	_s2["begin"] = Callable(self, "_f11").bind(_s2)
	_s2["ball"] = Callable(self, "_f13").bind(_s2)
	_s2["seal"] = Callable(self, "_f16").bind(_s2)
	_s2["crash"] = Callable(self, "_f17").bind(_s2)
	_s2["rings"] = Callable(self, "_f18").bind(_s2)
	_s2["actFn"] = Callable(self, "_f39").bind(_s2)
	_s2["run"] = Callable(self, "_f40").bind(_s2)
	_s2["custom"] = Callable(self, "_f41").bind(_s2)
	v_draw_36 = Callable(self, "_f46").bind(_s2)
	_s2["N"] = J.G.get("N30K")
	_s2["A"] = Callable(self, "_f2").bind(_s2)
	v_D_4 = J.div(PI, 180.0)
	_s2["TAU"] = (PI * 2.0)
	var _t63 = _s2["N"]
	var _t64 = J.gp(_t63, "E")
	_s2["E"] = _t64
	var _t65 = J.gp(_t63, "seg")
	_s2["seg"] = _t65
	var _t66 = J.gp(_t63, "lerp")
	_s2["lerp"] = _t66
	var _t67 = J.gp(_t63, "cl")
	_s2["cl"] = _t67
	var _t68 = J.gp(_t63, "rnd")
	v_rnd_10 = _t68
	_s2["sw"] = Callable(self, "_f3").bind(_s2)
	_s2["bump"] = Callable(self, "_f4").bind(_s2)
	_s2["P"] = {"npc_rival": {"h": 66.0, "solid": 0.0, "zh": "籃球仔", "poses": {"stand": {"img": "npc_rival", "k": 1.0, "nr": 0.0, "rig": {"c": 0.55, "n": 0.38, "h": 0.58, "ht": 0.03, "hr": 0.24, "L": [0.45, 0.43, 0.25, 0.3], "R": [0.72, 0.43, 0.74, 0.7], "tail": 0.72}}, "walk": {"img": "npc_rival_walk", "k": 0.91, "nr": 0.0, "rig": {"c": 0.55, "n": 0.38, "h": 0.48, "ht": 0.03, "hr": 0.24, "L": [0.45, 0.46, 0.25, 0.58], "R": [0.72, 0.46, 0.92, 0.76], "tail": 0.75}}, "gossip": {"img": "npc_rival_gossip", "k": 0.88, "nr": 0.0, "rig": {"c": 0.55, "n": 0.42, "h": 0.35, "ht": 0.03, "hr": 0.26, "L": [0.42, 0.46, 0.24, 0.36], "R": [0.74, 0.44, 0.7, 0.3], "tail": 0.4}}, "jump": {"img": "npc_rival_jump", "k": 0.74, "nr": 0.0, "rig": {"c": 0.45, "n": 0.46, "h": 0.42, "ht": 0.05, "hr": 0.24, "L": [0.38, 0.52, 0.1, 0.32], "R": [0.55, 0.52, 0.5, 0.45], "tail": 0.62}}}}, "npc_hr": {"h": 60.0, "solid": 0.0, "zh": "HR 姐", "poses": {"stand": {"img": "npc_hr", "k": 1.0, "nr": 0.0, "rig": {"c": 0.52, "n": 0.46, "h": 0.42, "ht": 0.02, "hr": 0.32, "L": [0.3, 0.52, 0.12, 0.6], "R": [0.72, 0.52, 0.55, 0.52], "tail": 0.88}}, "walk": {"img": "npc_hr_walk", "k": 0.81, "nr": 0.0, "rig": {"c": 0.5, "n": 0.46, "h": 0.45, "ht": 0.02, "hr": 0.3, "L": [0.35, 0.52, 0.08, 0.53], "R": [0.72, 0.54, 0.55, 0.62], "tail": 0.75}}, "stamp": {"img": "npc_hr_stamp", "k": 0.83, "nr": 0.0, "rig": {"c": 0.55, "n": 0.5, "h": 0.45, "ht": 0.04, "hr": 0.3, "L": [0.4, 0.56, 0.38, 0.76], "R": [0.74, 0.6, 0.62, 0.76], "tail": 0.8}}, "jump": {"img": "npc_hr_jump", "k": 0.75, "nr": 0.0, "rig": {"c": 0.6, "n": 0.5, "h": 0.55, "ht": 0.03, "hr": 0.28, "L": [0.45, 0.55, 0.22, 0.55], "R": [0.8, 0.56, 0.8, 0.66], "tail": 0.45}}}}, "npc_kpiboss": {"h": 66.0, "solid": 0.0, "zh": "陰間大老闆", "poses": {"stand": {"img": "npc_kpiboss", "k": 1.0, "nr": 1.0, "rig": {"c": 0.5, "n": 0.43, "h": 0.52, "ht": 0.04, "hr": 0.32, "L": [0.22, 0.46, 0.12, 0.64], "R": [0.8, 0.46, 0.9, 0.64], "tail": 0.32}}, "walk": {"img": "npc_kpiboss_walk", "k": 1.03, "nr": 1.0, "rig": {"c": 0.45, "n": 0.43, "h": 0.48, "ht": 0.04, "hr": 0.3, "L": [0.3, 0.46, 0.55, 0.55], "R": [0.74, 0.5, 0.86, 0.48], "tail": 0.12}}, "yell": {"img": "npc_kpiboss_yell", "k": 0.9, "nr": 1.0, "rig": {"c": 0.4, "n": 0.46, "h": 0.52, "ht": 0.04, "hr": 0.3, "L": [0.18, 0.5, 0.14, 0.66], "R": [0.6, 0.55, 0.7, 0.86], "tail": 0.1}}, "jump": {"img": "npc_kpiboss_jump", "k": 1.0, "nr": 1.0, "rig": {"c": 0.45, "n": 0.43, "h": 0.48, "ht": 0.04, "hr": 0.3, "L": [0.3, 0.5, 0.26, 0.56], "R": [0.76, 0.5, 0.86, 0.44], "tail": 0.2}}}}}
	_s2["CUTS"] = {"npc_rival": ["ball", "swoosh", "swoosh2"], "npc_rival_walk": ["ball", "fx"]}
	_s2["BALL"] = {"npc_rival": [0.228, 0.158], "npc_rival_walk": [0.205, 0.71]}
	for _t70 in J.keys(_s2["P"]):
		v_id_43 = _t70
		v_d_44 = J.gp(_s2["P"], v_id_43)
		for _t71 in J.keys(J.gp(v_d_44, "poses")):
			v_k_45 = _t71
			v_p_46 = J.gp(J.gp(v_d_44, "poses"), v_k_45)
			v_R_47 = J.mc(J.G.get("MeshAnim"), "mk", [J.gp(v_p_46, "rig")])
			var _t72 = J.gp(J.G.get("MeshAnim"), "RIG")
			var _t73 = J.gp(v_p_46, "img")
			J.sp(_t72, _t73, v_R_47)
			if J.t(J.gp(v_p_46, "nr")):
				var _t74 = J.gp(J.G.get("MeshAnim"), "NATIVE_R")
				var _t75 = J.gp(v_p_46, "img")
				J.sp(_t74, _t75, 1.0)
		var _t76 = J.gp(J.gp(J.G.get("MeshAnim"), "RIG"), v_id_43)
		var _t78 = Callable(self, "_f5").bind(_s2)
		J.sp(_t76, "custom", _t78)
		var _t79 = J.gp(J.G.get("ART"), "CHAR_H")
		var _t80 = J.gp(v_d_44, "h")
		J.sp(_t79, v_id_43, _t80)
		if J.t(J.gp(v_d_44, "solid")):
			var _t81 = J.gp(J.G.get("ART"), "SOLID")
			J.sp(_t81, v_id_43, 1.0)
	_s2["nb"] = Callable(self, "_f6").bind(_s2)
	_s2["end"] = Callable(self, "_f12").bind(_s2)
	_s2["ballRest"] = Callable(self, "_f14").bind(_s2)
	_s2["ballR"] = Callable(self, "_f15").bind(_s2)
	_s2["ACT"] = {"rival_idle": Callable(self, "_f19").bind(_s2), "spin": Callable(self, "_f20").bind(_s2), "dribble": Callable(self, "_f21").bind(_s2), "jumpshot": Callable(self, "_f22").bind(_s2), "gossip": Callable(self, "_f23").bind(_s2), "rival_walk": Callable(self, "_f24").bind(_s2), "rival_jump": Callable(self, "_f25").bind(_s2), "hr_idle": Callable(self, "_f26").bind(_s2), "clip": Callable(self, "_f27").bind(_s2), "glasses": Callable(self, "_f28").bind(_s2), "stamp": Callable(self, "_f29").bind(_s2), "hr_walk": Callable(self, "_f30").bind(_s2), "hr_jump": Callable(self, "_f31").bind(_s2), "kpi_idle": Callable(self, "_f32").bind(_s2), "inspect": Callable(self, "_f33").bind(_s2), "tap": Callable(self, "_f34").bind(_s2), "sigh": Callable(self, "_f35").bind(_s2), "yell": Callable(self, "_f36").bind(_s2), "kpi_walk": Callable(self, "_f37").bind(_s2), "kpi_jump": Callable(self, "_f38").bind(_s2)}
	_s2["PRE"] = {"npc_rival": "rival", "npc_hr": "hr", "npc_kpiboss": "kpi"}
	_s2["DUR"] = {"spin": 2.4, "dribble": 2.5, "jumpshot": 2.2, "gossip": 3.6, "clip": 3.2, "glasses": 2.6, "stamp": 2.0, "inspect": 4.0, "tap": 3.0, "sigh": 3.2, "yell": 2.2, "jump": 1.4, "idle": 4.0, "walk": 2.0}
	_s2["STATES"] = {"npc_rival": ["idle", "walk", "spin", "dribble", "jumpshot", "gossip", "jump", "attack", "hurt", "scared", "down", "die"], "npc_hr": ["idle", "walk", "clip", "glasses", "stamp", "jump", "attack", "hurt", "scared", "down", "die"], "npc_kpiboss": ["idle", "walk", "inspect", "tap", "sigh", "yell", "jump", "attack", "hurt", "scared", "down", "die"]}
	for _t201 in J.iter(["spin", "dribble", "jumpshot", "gossip", "clip", "glasses", "stamp", "inspect", "tap", "sigh", "yell", "jump", "walk", "idle"]):
		var _s59 = {"__p": _s2, "st": null}
		_s59["st"] = _t201
		var _t202 = J.G.get("DAILY")
		var _t203 = J.add("ag_", _s59["st"])
		var _t208 = Callable(self, "_f42").bind(_s59)
		J.sp(_t202, _t203, _t208)
	var _t209 = J.G.get("MOVES")
	var _t256 = Callable(self, "_f43").bind(_s2)
	J.sp(_t209, "npc_rival", _t256)
	var _t257 = J.G.get("MOVES")
	var _t277 = Callable(self, "_f44").bind(_s2)
	J.sp(_t257, "npc_hr", _t277)
	var _t278 = J.G.get("MOVES")
	var _t308 = Callable(self, "_f45").bind(_s2)
	J.sp(_t278, "npc_kpiboss", _t308)
	return {"draw": v_draw_36, "STATES": _s2["STATES"], "ZH": {"npc_rival": "籃球仔", "npc_hr": "HR 姐", "npc_kpiboss": "陰間大老闆"}, "dur": Callable(self, "_f47").bind(_s2), "P": _s2["P"]}
