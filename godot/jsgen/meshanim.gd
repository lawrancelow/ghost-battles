# 自動轉譯自 meshanim.js（tools/jsgd.js）——唔好直接改，改原 JS 再轉
extends RefCounted

func run(env):
	var this_ = null; var a = []
	J.G["MeshAnim"] = J.cl(Callable(self, "_f1").bind(env), null, [])

func _f2(this_, a: Array, env):
	var v_o_30 = null; var v_B_31 = null; var v_top_32 = null; var v_tx_33 = null
	v_o_30 = J.arg(a, 0)
	v_B_31 = []
	v_top_32 = (J.gp(J.gp(v_o_30, "legs"), 0.0) if J.t(J.gp(v_o_30, "legs")) else 0.72)
	if J.t(J.gp(v_o_30, "legs")):
		J.mc(v_B_31, "push", [["hips", null, J.gp(v_o_30, "c"), J.gp(J.gp(v_o_30, "legs"), 0.0), J.gp(v_o_30, "c"), J.add(J.gp(v_o_30, "n"), 0.15), 0.22]])
		J.mc(v_B_31, "push", [["legF", "hips", J.gp(J.gp(v_o_30, "legs"), 1.0), J.add(J.gp(J.gp(v_o_30, "legs"), 0.0), 0.02), J.gp(J.gp(v_o_30, "legs"), 1.0), 0.98, 0.1], ["legB", "hips", J.gp(J.gp(v_o_30, "legs"), 2.0), J.add(J.gp(J.gp(v_o_30, "legs"), 0.0), 0.02), J.gp(J.gp(v_o_30, "legs"), 2.0), 0.98, 0.1]])
		J.mc(v_B_31, "push", [["body", "hips", J.gp(v_o_30, "c"), J.sub(J.gp(J.gp(v_o_30, "legs"), 0.0), 0.05), J.gp(v_o_30, "c"), J.gp(v_o_30, "n"), 0.26]])
	else:
		J.mc(v_B_31, "push", [["body", null, J.gp(v_o_30, "c"), v_top_32, J.gp(v_o_30, "c"), J.gp(v_o_30, "n"), 0.3]])
		v_tx_33 = (J.gp(v_o_30, "tail") if (not J.leq(J.gp(v_o_30, "tail"), null)) else J.gp(v_o_30, "c"))
		J.mc(v_B_31, "push", [["tail1", "body", J.gp(v_o_30, "c"), 0.8, J.div(J.add(J.gp(v_o_30, "c"), v_tx_33), 2.0), 0.9, 0.16], ["tail2", "tail1", J.div(J.add(J.gp(v_o_30, "c"), v_tx_33), 2.0), 0.9, v_tx_33, 1.0, 0.14]])
	var _t2 = (J.gp(v_o_30, "h") if (not J.leq(J.gp(v_o_30, "h"), null)) else J.gp(v_o_30, "c"))
	var _t3 = J.gp(v_o_30, "n")
	var _t4 = (J.gp(v_o_30, "h") if (not J.leq(J.gp(v_o_30, "h"), null)) else J.gp(v_o_30, "c"))
	var _t5 = (J.gp(v_o_30, "ht") if (not J.leq(J.gp(v_o_30, "ht"), null)) else 0.12)
	var _t1 = J.gp(v_o_30, "hr")
	J.mc(v_B_31, "push", [["head", "body", _t2, _t3, _t4, _t5, (_t1 if J.t(_t1) else 0.28)]])
	if J.t(J.gp(v_o_30, "L")):
		var _t7 = J.gp(J.gp(v_o_30, "L"), 0.0)
		var _t8 = J.gp(J.gp(v_o_30, "L"), 1.0)
		var _t9 = J.gp(J.gp(v_o_30, "L"), 2.0)
		var _t10 = J.gp(J.gp(v_o_30, "L"), 3.0)
		var _t6 = J.gp(v_o_30, "ar")
		J.mc(v_B_31, "push", [["armF", "body", _t7, _t8, _t9, _t10, (_t6 if J.t(_t6) else 0.12)]])
	if J.t(J.gp(v_o_30, "R")):
		var _t12 = J.gp(J.gp(v_o_30, "R"), 0.0)
		var _t13 = J.gp(J.gp(v_o_30, "R"), 1.0)
		var _t14 = J.gp(J.gp(v_o_30, "R"), 2.0)
		var _t15 = J.gp(J.gp(v_o_30, "R"), 3.0)
		var _t11 = J.gp(v_o_30, "ar")
		J.mc(v_B_31, "push", [["armB", "body", _t12, _t13, _t14, _t15, (_t11 if J.t(_t11) else 0.12)]])
	if J.t(J.gp(v_o_30, "hair")):
		J.mc(v_B_31, "push", [["hairL", "head", J.gp(J.gp(v_o_30, "hair"), 0.0), J.sub(J.gp(v_o_30, "n"), 0.02), J.sub(J.gp(J.gp(v_o_30, "hair"), 0.0), 0.05), J.add(J.gp(v_o_30, "n"), 0.3), 0.13], ["hairR", "head", J.gp(J.gp(v_o_30, "hair"), 1.0), J.sub(J.gp(v_o_30, "n"), 0.02), J.add(J.gp(J.gp(v_o_30, "hair"), 1.0), 0.05), J.add(J.gp(v_o_30, "n"), 0.3), 0.13]])
	return {"bones": v_B_31, "legs": (not (not J.t(J.gp(v_o_30, "legs")))), "hop": (not (not J.t(J.gp(v_o_30, "hop"))))}

func _f3(this_, a: Array, env):
	var v_px_36 = null; var v_py_37 = null; var v_ax_38 = null; var v_ay_39 = null; var v_bx_40 = null; var v_by_41 = null; var v_dx_42 = null; var v_dy_43 = null; var v_l_44 = null; var v_t_45 = null
	v_px_36 = J.arg(a, 0)
	v_py_37 = J.arg(a, 1)
	v_ax_38 = J.arg(a, 2)
	v_ay_39 = J.arg(a, 3)
	v_bx_40 = J.arg(a, 4)
	v_by_41 = J.arg(a, 5)
	v_dx_42 = J.sub(v_bx_40, v_ax_38)
	v_dy_43 = J.sub(v_by_41, v_ay_39)
	var _t16 = (J.mul(v_dx_42, v_dx_42) + J.mul(v_dy_43, v_dy_43))
	v_l_44 = (_t16 if J.t(_t16) else 0.000001)
	v_t_45 = J.max_([0.0, J.min_([1.0, J.div((J.mul(J.sub(v_px_36, v_ax_38), v_dx_42) + J.mul(J.sub(v_py_37, v_ay_39), v_dy_43)), v_l_44)])])
	return J.hypot_([(J.sub(v_px_36, v_ax_38) - J.mul(v_t_45, v_dx_42)), (J.sub(v_py_37, v_ay_39) - J.mul(v_t_45, v_dy_43))])

func _f5(this_, a: Array, env):
	var v_b_56 = null; var v_i_57 = null
	v_b_56 = J.arg(a, 0)
	v_i_57 = J.arg(a, 1)
	var _t17 = env["idx"]
	var _t18 = J.gp(v_b_56, 0.0)
	J.sp(_t17, _t18, v_i_57)
	return v_i_57

func _f6(this_, a: Array, env):
	var v_b_64 = null; var v_k_65 = null; var v_d_66 = null; var v_ww_67 = null
	v_b_64 = J.arg(a, 0)
	v_k_65 = J.arg(a, 1)
	var _t19 = env["__p"]["__p"]["segDist"]
	v_d_66 = J.div(J.cl(_t19, null, [env["u"], J.mul(env["v"], env["__p"]["ar"]), J.gp(v_b_64, 2.0), J.mul(J.gp(v_b_64, 3.0), env["__p"]["ar"]), J.gp(v_b_64, 4.0), J.mul(J.gp(v_b_64, 5.0), env["__p"]["ar"])]), J.gp(v_b_64, 6.0))
	v_ww_67 = exp(J.num((J.mul((-J.num(v_d_66)), v_d_66) * 2.2)))
	if J.seq(J.gp(v_b_64, 1.0), null):
		var _t20 = J.max_([v_ww_67, 0.05])
		v_ww_67 = _t20
	var _t21 = env["w"]
	J.sp(_t21, v_k_65, v_ww_67)
	var _t22 = J.add(env["sum"], v_ww_67)
	env["sum"] = _t22

func _f4(this_, a: Array, env):
	var v_id_48 = null; var v_img_49 = null; var v_R_50 = null; var v_B_52 = null; var v_verts_54 = null; var v_live_55 = null; var v_j_58 = null; var v_i_59 = null; var v_k_68 = null; var v_iw_69 = null; var v_ih_70 = null; var v_c_71 = null; var v_g_72 = null; var v_d_73 = null; var v_j_74 = null; var v_i_75 = null; var v_x0_76 = null; var v_x1_77 = null; var v_y0_78 = null; var v_y1_79 = null; var v_hit_80 = null; var v_y_81 = null; var v_x_82 = null; var v_e_83 = null
	var _s7 = {"__p": env, "ar": null, "idx": null}
	v_id_48 = J.arg(a, 0)
	v_img_49 = J.arg(a, 1)
	v_R_50 = J.gp(_s7["__p"]["RIG"], v_id_48)
	_s7["ar"] = J.div(J.gp(v_img_49, "naturalHeight"), J.gp(v_img_49, "naturalWidth"))
	v_B_52 = J.gp(v_R_50, "bones")
	_s7["idx"] = {}
	J.mc(v_B_52, "forEach", [Callable(self, "_f5").bind(_s7)])
	v_verts_54 = []
	v_j_58 = 0.0
	while true:
		if not J.cmp(v_j_58, _s7["__p"]["GY"], "<="): break
		v_i_59 = 0.0
		while true:
			if not J.cmp(v_i_59, _s7["__p"]["GX"], "<="): break
			var _s11 = {"__p": _s7, "u": null, "v": null, "w": null, "sum": null}
			_s11["u"] = J.div(v_i_59, _s11["__p"]["__p"]["GX"])
			_s11["v"] = J.div(v_j_58, _s11["__p"]["__p"]["GY"])
			_s11["w"] = J.new_("Float32Array", [J.len(v_B_52)])
			_s11["sum"] = 0.0
			J.mc(v_B_52, "forEach", [Callable(self, "_f6").bind(_s11)])
			v_k_68 = 0.0
			while true:
				if not J.cmp(v_k_68, J.len(_s11["w"]), "<"): break
				var _t23 = _s11["w"]
				var _t24 = J.div(J.gp(_t23, v_k_68), _s11["sum"])
				J.sp(_t23, v_k_68, _t24)
				v_k_68 = J.num(v_k_68) + 1.0
			J.mc(v_verts_54, "push", [{"u": _s11["u"], "v": _s11["v"], "w": _s11["w"]}])
			v_i_59 = J.num(v_i_59) + 1.0
		v_j_58 = J.num(v_j_58) + 1.0
	v_live_55 = null
	v_iw_69 = J.gp(v_img_49, "naturalWidth")
	v_ih_70 = J.gp(v_img_49, "naturalHeight")
	v_c_71 = J.S_document_("createElement", ["canvas"])
	J.sp(v_c_71, "width", v_iw_69)
	J.sp(v_c_71, "height", v_ih_70)
	v_g_72 = J.mc(v_c_71, "getContext", ["2d", {"willReadFrequently": true}])
	J.mc(v_g_72, "drawImage", [v_img_49, 0.0, 0.0])
	v_d_73 = J.gp(J.mc(v_g_72, "getImageData", [0.0, 0.0, v_iw_69, v_ih_70]), "data")
	var _t25 = J.new_("Uint8Array", [J.mul(_s7["__p"]["GX"], _s7["__p"]["GY"])])
	v_live_55 = _t25
	v_j_74 = 0.0
	while true:
		if not J.cmp(v_j_74, _s7["__p"]["GY"], "<"): break
		v_i_75 = 0.0
		while true:
			if not J.cmp(v_i_75, _s7["__p"]["GX"], "<"): break
			v_x0_76 = J.max_([0.0, (floor(J.num(J.mul(J.div(v_i_75, _s7["__p"]["GX"]), v_iw_69))) - 2.0)])
			v_x1_77 = J.min_([v_iw_69, (ceil(J.num(J.mul(J.div(J.add(v_i_75, 1.0), _s7["__p"]["GX"]), v_iw_69))) + 2.0)])
			v_y0_78 = J.max_([0.0, (floor(J.num(J.mul(J.div(v_j_74, _s7["__p"]["GY"]), v_ih_70))) - 2.0)])
			v_y1_79 = J.min_([v_ih_70, (ceil(J.num(J.mul(J.div(J.add(v_j_74, 1.0), _s7["__p"]["GY"]), v_ih_70))) + 2.0)])
			v_hit_80 = 0.0
			v_y_81 = v_y0_78
			while true:
				var _t26 = J.cmp(v_y_81, v_y1_79, "<")
				if not ((not J.t(v_hit_80)) if _t26 else _t26): break
				v_x_82 = v_x0_76
				while true:
					if not J.cmp(v_x_82, v_x1_77, "<"): break
					if J.cmp(J.gp(v_d_73, (J.mul(J.add(J.mul(v_y_81, v_iw_69), v_x_82), 4.0) + 3.0)), 4.0, ">"):
						v_hit_80 = 1.0
						break
					v_x_82 = J.num(v_x_82) + 1.0
				v_y_81 = J.num(v_y_81) + 1.0
			var _t27 = J.add(J.mul(v_j_74, _s7["__p"]["GX"]), v_i_75)
			J.sp(v_live_55, _t27, v_hit_80)
			v_i_75 = J.num(v_i_75) + 1.0
		v_j_74 = J.num(v_j_74) + 1.0
	var _t28 = _s7["__p"]["cache"]
	var _t29 = {"R": v_R_50, "verts": v_verts_54, "idx": _s7["idx"], "ar": _s7["ar"], "live": v_live_55}
	J.sp(_t28, v_id_48, _t29)
	return _t29

func _f7(this_, a: Array, env):
	var v_R_86 = null; var v_pose_87 = null; var v_T_88 = null; var v_b_89 = null; var v_n_90 = null; var v_par_91 = null; var v_px_92 = null; var v_py_93 = null; var v_a_94 = null; var v_P_95 = null; var v_ppx_96 = null; var v_ppy_97 = null; var v_A_98 = null
	v_R_86 = J.arg(a, 0)
	v_pose_87 = J.arg(a, 1)
	v_T_88 = {}
	for _t30 in J.iter(J.gp(v_R_86, "bones")):
		v_b_89 = _t30
		var _t31 = J.gp(v_b_89, 0.0)
		v_n_90 = _t31
		var _t32 = J.gp(v_b_89, 1.0)
		v_par_91 = _t32
		var _t33 = J.gp(v_b_89, 2.0)
		v_px_92 = _t33
		var _t34 = J.gp(v_b_89, 3.0)
		v_py_93 = _t34
		var _t35 = J.gp(v_pose_87, v_n_90)
		v_a_94 = (_t35 if J.t(_t35) else 0.0)
		v_P_95 = (J.gp(v_T_88, v_par_91) if J.t(v_par_91) else {"a": 0.0, "tx": 0.0, "ty": 0.0})
		v_ppx_96 = J.add((J.mul(cos(J.num(J.gp(v_P_95, "a"))), v_px_92) - J.mul(sin(J.num(J.gp(v_P_95, "a"))), v_py_93)), J.gp(v_P_95, "tx"))
		v_ppy_97 = J.add((J.mul(sin(J.num(J.gp(v_P_95, "a"))), v_px_92) + J.mul(cos(J.num(J.gp(v_P_95, "a"))), v_py_93)), J.gp(v_P_95, "ty"))
		v_A_98 = J.add(J.gp(v_P_95, "a"), v_a_94)
		var _t36 = {"a": v_A_98, "tx": J.sub(v_ppx_96, (J.mul(cos(J.num(v_A_98)), v_px_92) - J.mul(sin(J.num(v_A_98)), v_py_93))), "ty": J.sub(v_ppy_97, (J.mul(sin(J.num(v_A_98)), v_px_92) + J.mul(cos(J.num(v_A_98)), v_py_93)))}
		J.sp(v_T_88, v_n_90, _t36)
	return v_T_88

func _f8(this_, a: Array, env):
	var v_ctx_101 = null; var v_id_102 = null; var v_x_103 = null; var v_y_104 = null; var v_h_105 = null; var v_pose_106 = null; var v_faceRight_107 = null; var v_nr_108 = null; var v_flip_109 = null; var v_m_110 = null; var v_k_111 = null
	v_ctx_101 = J.arg(a, 0)
	v_id_102 = J.arg(a, 1)
	v_x_103 = J.arg(a, 2)
	v_y_104 = J.arg(a, 3)
	v_h_105 = J.arg(a, 4)
	v_pose_106 = J.arg(a, 5)
	v_faceRight_107 = J.arg(a, 6)
	v_nr_108 = (not (not J.t(J.gp(env["NATIVE_R"], v_id_102))))
	v_flip_109 = (not J.seq(v_faceRight_107, v_nr_108))
	if (not J.t(v_nr_108)):
		v_m_110 = {}
		for _t37 in J.keys(v_pose_106):
			v_k_111 = _t37
			var _t38 = J.seq(J.typeof_(J.gp(v_pose_106, v_k_111)), "number")
			var _t39 = ((-J.num(J.gp(v_pose_106, v_k_111))) if ((not J.t(J.gp(env["KEEP"], v_k_111))) if _t38 else _t38) else J.gp(v_pose_106, v_k_111))
			J.sp(v_m_110, v_k_111, _t39)
		v_pose_106 = v_m_110
	var _t40 = env["drawRaw"]
	return J.cl(_t40, null, [v_ctx_101, v_id_102, v_x_103, v_y_104, v_h_105, v_pose_106, v_flip_109])

func _f18(this_, a: Array, env):
	var v_V_200 = null; var v_X_201 = null; var v_Y_202 = null; var v_vy_203 = null; var v_k_204 = null; var v_wk_205 = null; var v_t_206 = null; var v_c_207 = null; var v_s_208 = null
	v_V_200 = J.arg(a, 0)
	v_X_201 = 0.0
	v_Y_202 = 0.0
	v_vy_203 = J.mul(J.gp(v_V_200, "v"), env["ar"])
	v_k_204 = 0.0
	while true:
		if not J.cmp(v_k_204, J.len(env["bones"]), "<"): break
		v_wk_205 = J.gp(J.gp(v_V_200, "w"), v_k_204)
		if J.cmp(v_wk_205, 0.002, "<"):
			v_k_204 = J.num(v_k_204) + 1.0
			continue
		v_t_206 = J.gp(env["T"], J.gp(J.gp(env["bones"], v_k_204), 0.0))
		v_c_207 = cos(J.num(J.gp(v_t_206, "a")))
		v_s_208 = sin(J.num(J.gp(v_t_206, "a")))
		var _t80 = J.add(v_X_201, J.mul(v_wk_205, J.add((J.mul(v_c_207, J.gp(v_V_200, "u")) - J.mul(v_s_208, v_vy_203)), J.gp(v_t_206, "tx"))))
		v_X_201 = _t80
		var _t81 = J.add(v_Y_202, J.mul(v_wk_205, J.add((J.mul(v_s_208, J.gp(v_V_200, "u")) + J.mul(v_c_207, v_vy_203)), J.gp(v_t_206, "ty"))))
		v_Y_202 = _t81
		v_k_204 = J.num(v_k_204) + 1.0
	return [v_X_201, J.div(v_Y_202, env["ar"])]

func _f17(this_, a: Array, env):
	var v_ctx_165 = null; var v_id_166 = null; var v_x_167 = null; var v_y_168 = null; var v_h_169 = null; var v_pose_170 = null; var v_flip_171 = null; var v_img_172 = null; var v_C_173 = null; var v_R_174 = null; var v_W_176 = null; var v_iw_177 = null; var v_ih_178 = null; var v_pts_181 = null; var v_live_182 = null; var v_cv_183 = null; var v_M_184 = null; var v_ar0_185 = null; var v_hw_186 = null; var v_ux0_187 = null; var v_ux1_188 = null; var v_uy0_189 = null; var v_uy1_190 = null; var v_bx0_191 = null; var v_by0_192 = null; var v_bx1_193 = null; var v_by1_194 = null; var v_b_195 = null; var v_ux_196 = null; var v_uy_197 = null; var v_X_198 = null; var v_Y_199 = null; var v_j_209 = null; var v_i_210 = null; var v_a_211 = null; var v_b_212 = null; var v_c_213 = null; var v_d_214 = null
	var _s49 = {"__p": env, "ar": null, "T": null, "bones": null}
	v_ctx_165 = J.arg(a, 0)
	v_id_166 = J.arg(a, 1)
	v_x_167 = J.arg(a, 2)
	v_y_168 = J.arg(a, 3)
	v_h_169 = J.arg(a, 4)
	v_pose_170 = J.arg(a, 5)
	v_flip_171 = J.arg(a, 6)
	var _t41 = J.G.get("__nat_meshDraw")
	return J.cl(_t41, null, [v_ctx_165, v_id_166, J.gp(_s49["__p"]["RIG"], v_id_166), v_x_167, v_y_168, v_h_169, v_pose_170, v_flip_171])
	v_img_172 = J.gp(J.G.get("SPR"), v_id_166)
	var _t42 = (not J.t(v_img_172))
	if (_t42 if _t42 else (not J.t(J.gp(_s49["__p"]["RIG"], v_id_166)))):
		return false
	var _t43 = ((not J.t(_s49["__p"]["NOGL"])) if J.t(_s49["__p"]["MGL"]) else _s49["__p"]["MGL"])
	var _t44 = (J.gp(v_ctx_165, "canvas") if J.t(_t43) else _t43)
	var _t46 = (J.gp(J.gp(v_ctx_165, "canvas"), "width") if J.t(_t44) else _t44)
	if J.t(_t46):
		var _t45 = _s49["__p"]["drawGL"]
		_t46 = J.cl(_t45, null, [v_ctx_165, v_img_172, v_id_166, v_x_167, v_y_168, v_h_169, v_pose_170, v_flip_171])
	if J.t(_t46):
		return true
	var _t47 = (J.cmp(J.gp(v_ctx_165, "globalAlpha"), 0.995, "<") if J.t(_s49["__p"]["MBUF"]) else _s49["__p"]["MBUF"])
	var _t48 = (J.gp(v_ctx_165, "canvas") if J.t(_t47) else _t47)
	var _t49 = ((not J.seq(J.gp(v_ctx_165, "canvas"), _s49["__p"]["MBUF"])) if J.t(_t48) else _t48)
	if J.t((J.gp(J.gp(v_ctx_165, "canvas"), "width") if J.t(_t49) else _t49)):
		v_cv_183 = J.gp(v_ctx_165, "canvas")
		var _t50 = (not J.seq(J.gp(_s49["__p"]["MBUF"], "width"), J.gp(v_cv_183, "width")))
		if (_t50 if _t50 else (not J.seq(J.gp(_s49["__p"]["MBUF"], "height"), J.gp(v_cv_183, "height")))):
			var _t51 = _s49["__p"]["MBUF"]
			var _t52 = J.gp(v_cv_183, "width")
			J.sp(_t51, "width", _t52)
			var _t53 = _s49["__p"]["MBUF"]
			var _t54 = J.gp(v_cv_183, "height")
			J.sp(_t53, "height", _t54)
		v_M_184 = J.mc(v_ctx_165, "getTransform", [])
		v_ar0_185 = J.div(J.gp(v_img_172, "naturalHeight"), J.gp(v_img_172, "naturalWidth"))
		var _t56 = (J.max_([J.div(v_h_169, v_ar0_185), v_h_169]) * 0.85)
		var _t55 = J.gp(v_pose_170, "x")
		v_hw_186 = (_t56 + J.div(J.mul(absf(J.num((_t55 if J.t(_t55) else 0.0))), v_h_169), v_ar0_185))
		v_ux0_187 = J.sub(v_x_167, v_hw_186)
		v_ux1_188 = J.add(v_x_167, v_hw_186)
		var _t59 = J.sub(v_y_168, J.mul(v_h_169, 1.45))
		var _t57 = J.gp(v_pose_170, "y")
		var _t58 = J.gp(v_pose_170, "y")
		v_uy0_189 = (_t59 + J.min_([0.0, J.mul((_t58 if J.t(_t58) else 0.0), v_h_169)]))
		var _t62 = J.add(v_y_168, J.mul(v_h_169, 0.35))
		var _t60 = J.gp(v_pose_170, "y")
		var _t61 = J.gp(v_pose_170, "y")
		v_uy1_190 = J.add(_t62, J.max_([0.0, J.mul((_t61 if J.t(_t61) else 0.0), v_h_169)]))
		v_bx0_191 = 1000000000.0
		v_by0_192 = 1000000000.0
		v_bx1_193 = (-1000000000.0)
		v_by1_194 = (-1000000000.0)
		for _t63 in J.iter([[v_ux0_187, v_uy0_189], [v_ux1_188, v_uy0_189], [v_ux0_187, v_uy1_190], [v_ux1_188, v_uy1_190]]):
			var _t64 = J.gp(_t63, 0.0)
			v_ux_196 = _t64
			var _t65 = J.gp(_t63, 1.0)
			v_uy_197 = _t65
			v_X_198 = J.add((J.mul(J.gp(v_M_184, "a"), v_ux_196) + J.mul(J.gp(v_M_184, "c"), v_uy_197)), J.gp(v_M_184, "e"))
			v_Y_199 = J.add((J.mul(J.gp(v_M_184, "b"), v_ux_196) + J.mul(J.gp(v_M_184, "d"), v_uy_197)), J.gp(v_M_184, "f"))
			var _t66 = J.min_([v_bx0_191, v_X_198])
			v_bx0_191 = _t66
			var _t67 = J.max_([v_bx1_193, v_X_198])
			v_bx1_193 = _t67
			var _t68 = J.min_([v_by0_192, v_Y_199])
			v_by0_192 = _t68
			var _t69 = J.max_([v_by1_194, v_Y_199])
			v_by1_194 = _t69
		var _t70 = J.max_([0.0, floor(J.num(v_bx0_191))])
		v_bx0_191 = _t70
		var _t71 = J.max_([0.0, floor(J.num(v_by0_192))])
		v_by0_192 = _t71
		var _t72 = J.min_([J.gp(v_cv_183, "width"), ceil(J.num(v_bx1_193))])
		v_bx1_193 = _t72
		var _t73 = J.min_([J.gp(v_cv_183, "height"), ceil(J.num(v_by1_194))])
		v_by1_194 = _t73
		var _t74 = J.cmp(v_bx1_193, v_bx0_191, "<=")
		if (_t74 if _t74 else J.cmp(v_by1_194, v_by0_192, "<=")):
			return true
		v_b_195 = J.mc(_s49["__p"]["MBUF"], "getContext", ["2d"])
		J.mc(v_b_195, "setTransform", [1.0, 0.0, 0.0, 1.0, 0.0, 0.0])
		J.mc(v_b_195, "clearRect", [v_bx0_191, v_by0_192, J.sub(v_bx1_193, v_bx0_191), J.sub(v_by1_194, v_by0_192)])
		J.sp(v_b_195, "globalAlpha", 1.0)
		J.sp(v_b_195, "globalCompositeOperation", "source-over")
		J.mc(v_b_195, "save", [])
		J.mc(v_b_195, "beginPath", [])
		J.mc(v_b_195, "rect", [v_bx0_191, v_by0_192, J.sub(v_bx1_193, v_bx0_191), J.sub(v_by1_194, v_by0_192)])
		J.mc(v_b_195, "clip", [])
		J.mc(v_b_195, "setTransform", [v_M_184])
		var _t75 = _s49["__p"]["drawRaw"]
		J.cl(_t75, null, [v_b_195, v_id_166, v_x_167, v_y_168, v_h_169, v_pose_170, v_flip_171])
		J.mc(v_b_195, "restore", [])
		J.mc(v_ctx_165, "save", [])
		J.mc(v_ctx_165, "setTransform", [1.0, 0.0, 0.0, 1.0, 0.0, 0.0])
		J.mc(v_ctx_165, "drawImage", [_s49["__p"]["MBUF"], v_bx0_191, v_by0_192, J.sub(v_bx1_193, v_bx0_191), J.sub(v_by1_194, v_by0_192), v_bx0_191, v_by0_192, J.sub(v_bx1_193, v_bx0_191), J.sub(v_by1_194, v_by0_192)])
		J.mc(v_ctx_165, "restore", [])
		return true
	var _t77 = J.gp(_s49["__p"]["cache"], v_id_166)
	if not J.t(_t77):
		var _t76 = _s49["__p"]["build"]
		_t77 = J.cl(_t76, null, [v_id_166, v_img_172])
	v_C_173 = _t77
	v_R_174 = J.gp(v_C_173, "R")
	_s49["ar"] = J.gp(v_C_173, "ar")
	v_W_176 = J.div(v_h_169, _s49["ar"])
	v_iw_177 = J.gp(v_img_172, "naturalWidth")
	v_ih_178 = J.gp(v_img_172, "naturalHeight")
	var _t78 = _s49["__p"]["solve"]
	_s49["T"] = J.cl(_t78, null, [v_R_174, v_pose_170])
	_s49["bones"] = J.gp(v_R_174, "bones")
	var _t79 = J.gp(v_C_173, "verts")
	v_pts_181 = J.mc(_t79, "map", [Callable(self, "_f18").bind(_s49)])
	J.mc(v_ctx_165, "save", [])
	var _t82 = J.gp(v_pose_170, "x")
	var _t84 = J.add(v_x_167, J.mul((_t82 if J.t(_t82) else 0.0), v_W_176))
	var _t83 = J.gp(v_pose_170, "y")
	J.mc(v_ctx_165, "translate", [_t84, J.add(v_y_168, J.mul((_t83 if J.t(_t83) else 0.0), v_h_169))])
	if J.t(v_flip_171):
		J.mc(v_ctx_165, "scale", [(-1.0), 1.0])
	if J.t(J.gp(v_pose_170, "rot")):
		J.mc(v_ctx_165, "translate", [0.0, ((-J.num(v_h_169)) * 0.35)])
		J.mc(v_ctx_165, "rotate", [J.gp(v_pose_170, "rot")])
		J.mc(v_ctx_165, "translate", [0.0, J.mul(v_h_169, 0.35)])
	var _t85 = J.gp(v_pose_170, "sx")
	var _t87 = (_t85 if J.t(_t85) else 1.0)
	var _t86 = J.gp(v_pose_170, "sy")
	J.mc(v_ctx_165, "scale", [_t87, (_t86 if J.t(_t86) else 1.0)])
	J.mc(v_ctx_165, "translate", [J.div((-J.num(v_W_176)), 2.0), (-J.num(v_h_169))])
	v_live_182 = J.gp(v_C_173, "live")
	v_j_209 = 0.0
	while true:
		if not J.cmp(v_j_209, _s49["__p"]["GY"], "<"): break
		v_i_210 = 0.0
		while true:
			if not J.cmp(v_i_210, _s49["__p"]["GX"], "<"): break
			if J.t(((not J.t(J.gp(v_live_182, J.add(J.mul(v_j_209, _s49["__p"]["GX"]), v_i_210)))) if J.t(v_live_182) else v_live_182)):
				v_i_210 = J.num(v_i_210) + 1.0
				continue
			v_a_211 = J.add(J.mul(v_j_209, J.add(_s49["__p"]["GX"], 1.0)), v_i_210)
			v_b_212 = J.add(v_a_211, 1.0)
			v_c_213 = J.add(J.add(v_a_211, _s49["__p"]["GX"]), 1.0)
			v_d_214 = J.add(v_c_213, 1.0)
			var _t88 = _s49["__p"]["tri"]
			J.cl(_t88, null, [v_ctx_165, v_img_172, v_iw_177, v_ih_178, v_W_176, v_h_169, J.gp(v_C_173, "verts"), v_pts_181, v_a_211, v_b_212, v_c_213])
			var _t89 = _s49["__p"]["tri"]
			J.cl(_t89, null, [v_ctx_165, v_img_172, v_iw_177, v_ih_178, v_W_176, v_h_169, J.gp(v_C_173, "verts"), v_pts_181, v_b_212, v_d_214, v_c_213])
			v_i_210 = J.num(v_i_210) + 1.0
		v_j_209 = J.num(v_j_209) + 1.0
	J.mc(v_ctx_165, "restore", [])
	return true

func _f20(this_, a: Array, env):
	var v_V_236 = null; var v_i_237 = null
	v_V_236 = J.arg(a, 0)
	v_i_237 = J.arg(a, 1)
	var _t96 = J.gp(env["C"], "uv")
	var _t97 = J.mul(v_i_237, 2.0)
	var _t98 = J.gp(v_V_236, "u")
	J.sp(_t96, _t97, _t98)
	var _t99 = J.gp(env["C"], "uv")
	var _t100 = (J.mul(v_i_237, 2.0) + 1.0)
	var _t101 = J.gp(v_V_236, "v")
	J.sp(_t99, _t100, _t101)

func _f21(this_, a: Array, env):
	var v_b_244 = null; var v_t_245 = null
	v_b_244 = J.arg(a, 0)
	v_t_245 = J.gp(env["T"], J.gp(v_b_244, 0.0))
	return [cos(J.num(J.gp(v_t_245, "a"))), sin(J.num(J.gp(v_t_245, "a"))), J.gp(v_t_245, "tx"), J.gp(v_t_245, "ty")]

func _f19(this_, a: Array, env):
	var v_ctx_217 = null; var v_img_218 = null; var v_id_219 = null; var v_x_220 = null; var v_y_221 = null; var v_h_222 = null; var v_pose_223 = null; var v_flip_224 = null; var v_R_226 = null; var v_ar_227 = null; var v_W_228 = null; var v_bones_230 = null; var v_NV_231 = null; var v_M_232 = null; var v_cs_233 = null; var v_dev_234 = null; var v_t_235 = null; var v_j_238 = null; var v_i_239 = null; var v_a_240 = null; var v_b_241 = null; var v_c_242 = null; var v_d_243 = null; var v_i_246 = null; var v_V_247 = null; var v_vy_248 = null; var v_X_249 = null; var v_Y_250 = null; var v_lx_251 = null; var v_ly_252 = null; var v_k_253 = null; var v_wk_254 = null; var v_q_255 = null
	var _s61 = {"__p": env, "C": null, "T": null}
	v_ctx_217 = J.arg(a, 0)
	v_img_218 = J.arg(a, 1)
	v_id_219 = J.arg(a, 2)
	v_x_220 = J.arg(a, 3)
	v_y_221 = J.arg(a, 4)
	v_h_222 = J.arg(a, 5)
	v_pose_223 = J.arg(a, 6)
	v_flip_224 = J.arg(a, 7)
	var _t91 = J.gp(_s61["__p"]["cache"], v_id_219)
	if not J.t(_t91):
		var _t90 = _s61["__p"]["build"]
		_t91 = J.cl(_t90, null, [v_id_219, v_img_218])
	_s61["C"] = _t91
	v_R_226 = J.gp(_s61["C"], "R")
	v_ar_227 = J.gp(_s61["C"], "ar")
	v_W_228 = J.div(v_h_222, v_ar_227)
	var _t92 = _s61["__p"]["solve"]
	_s61["T"] = J.cl(_t92, null, [v_R_226, v_pose_223])
	v_bones_230 = J.gp(v_R_226, "bones")
	v_NV_231 = J.len(J.gp(_s61["C"], "verts"))
	if (not J.t(J.gp(_s61["C"], "uv"))):
		var _t93 = _s61["C"]
		var _t94 = J.new_("Float32Array", [J.mul(v_NV_231, 2.0)])
		J.sp(_t93, "uv", _t94)
		var _t95 = J.gp(_s61["C"], "verts")
		J.mc(_t95, "forEach", [Callable(self, "_f20").bind(_s61)])
		v_t_235 = []
		v_j_238 = 0.0
		while true:
			if not J.cmp(v_j_238, _s61["__p"]["GY"], "<"): break
			v_i_239 = 0.0
			while true:
				if not J.cmp(v_i_239, _s61["__p"]["GX"], "<"): break
				var _t102 = J.gp(_s61["C"], "live")
				if J.t(((not J.t(J.gp(J.gp(_s61["C"], "live"), J.add(J.mul(v_j_238, _s61["__p"]["GX"]), v_i_239)))) if J.t(_t102) else _t102)):
					v_i_239 = J.num(v_i_239) + 1.0
					continue
				v_a_240 = J.add(J.mul(v_j_238, J.add(_s61["__p"]["GX"], 1.0)), v_i_239)
				v_b_241 = J.add(v_a_240, 1.0)
				v_c_242 = J.add(J.add(v_a_240, _s61["__p"]["GX"]), 1.0)
				v_d_243 = J.add(v_c_242, 1.0)
				J.mc(v_t_235, "push", [v_a_240, v_b_241, v_c_242, v_b_241, v_d_243, v_c_242])
				v_i_239 = J.num(v_i_239) + 1.0
			v_j_238 = J.num(v_j_238) + 1.0
		var _t103 = _s61["C"]
		var _t104 = J.new_("Uint16Array", [v_t_235])
		J.sp(_t103, "tris", _t104)
		var _t105 = _s61["C"]
		var _t106 = J.new_("Float32Array", [J.mul(v_NV_231, 2.0)])
		J.sp(_t105, "dev", _t106)
	J.mc(v_ctx_217, "save", [])
	var _t107 = J.gp(v_pose_223, "x")
	var _t109 = J.add(v_x_220, J.mul((_t107 if J.t(_t107) else 0.0), v_W_228))
	var _t108 = J.gp(v_pose_223, "y")
	J.mc(v_ctx_217, "translate", [_t109, J.add(v_y_221, J.mul((_t108 if J.t(_t108) else 0.0), v_h_222))])
	if J.t(v_flip_224):
		J.mc(v_ctx_217, "scale", [(-1.0), 1.0])
	if J.t(J.gp(v_pose_223, "rot")):
		J.mc(v_ctx_217, "translate", [0.0, ((-J.num(v_h_222)) * 0.35)])
		J.mc(v_ctx_217, "rotate", [J.gp(v_pose_223, "rot")])
		J.mc(v_ctx_217, "translate", [0.0, J.mul(v_h_222, 0.35)])
	var _t110 = J.gp(v_pose_223, "sx")
	var _t112 = (_t110 if J.t(_t110) else 1.0)
	var _t111 = J.gp(v_pose_223, "sy")
	J.mc(v_ctx_217, "scale", [_t112, (_t111 if J.t(_t111) else 1.0)])
	J.mc(v_ctx_217, "translate", [J.div((-J.num(v_W_228)), 2.0), (-J.num(v_h_222))])
	v_M_232 = J.mc(v_ctx_217, "getTransform", [])
	J.mc(v_ctx_217, "restore", [])
	v_cs_233 = J.mc(v_bones_230, "map", [Callable(self, "_f21").bind(_s61)])
	v_dev_234 = J.gp(_s61["C"], "dev")
	v_i_246 = 0.0
	while true:
		if not J.cmp(v_i_246, v_NV_231, "<"): break
		v_V_247 = J.gp(J.gp(_s61["C"], "verts"), v_i_246)
		v_vy_248 = J.mul(J.gp(v_V_247, "v"), v_ar_227)
		v_X_249 = 0.0
		v_Y_250 = 0.0
		v_k_253 = 0.0
		while true:
			if not J.cmp(v_k_253, J.len(v_bones_230), "<"): break
			v_wk_254 = J.gp(J.gp(v_V_247, "w"), v_k_253)
			if J.cmp(v_wk_254, 0.002, "<"):
				v_k_253 = J.num(v_k_253) + 1.0
				continue
			v_q_255 = J.gp(v_cs_233, v_k_253)
			var _t113 = J.add(v_X_249, J.mul(v_wk_254, J.add((J.mul(J.gp(v_q_255, 0.0), J.gp(v_V_247, "u")) - J.mul(J.gp(v_q_255, 1.0), v_vy_248)), J.gp(v_q_255, 2.0))))
			v_X_249 = _t113
			var _t114 = J.add(v_Y_250, J.mul(v_wk_254, J.add((J.mul(J.gp(v_q_255, 1.0), J.gp(v_V_247, "u")) + J.mul(J.gp(v_q_255, 0.0), v_vy_248)), J.gp(v_q_255, 3.0))))
			v_Y_250 = _t114
			v_k_253 = J.num(v_k_253) + 1.0
		v_lx_251 = J.mul(v_X_249, v_W_228)
		v_ly_252 = J.mul(J.div(v_Y_250, v_ar_227), v_h_222)
		var _t115 = J.mul(v_i_246, 2.0)
		var _t116 = J.add((J.mul(J.gp(v_M_232, "a"), v_lx_251) + J.mul(J.gp(v_M_232, "c"), v_ly_252)), J.gp(v_M_232, "e"))
		J.sp(v_dev_234, _t115, _t116)
		var _t117 = (J.mul(v_i_246, 2.0) + 1.0)
		var _t118 = J.add((J.mul(J.gp(v_M_232, "b"), v_lx_251) + J.mul(J.gp(v_M_232, "d"), v_ly_252)), J.gp(v_M_232, "f"))
		J.sp(v_dev_234, _t117, _t118)
		v_i_246 = J.num(v_i_246) + 1.0
	return J.mc(_s61["__p"]["MGL"], "draw", [v_ctx_217, v_img_218, v_dev_234, J.gp(_s61["C"], "uv"), J.gp(_s61["C"], "tris"), J.div(J.len(J.gp(_s61["C"], "tris")), 3.0)])

func _f23(this_, a: Array, env):
	var v_px_301 = null; var v_py_302 = null; var v_dx_303 = null; var v_dy_304 = null; var v_l_305 = null
	v_px_301 = J.arg(a, 0)
	v_py_302 = J.arg(a, 1)
	v_dx_303 = J.sub(v_px_301, env["cx"])
	v_dy_304 = J.sub(v_py_302, env["cy"])
	var _t119 = J.hypot_([v_dx_303, v_dy_304])
	v_l_305 = (_t119 if J.t(_t119) else 1.0)
	return [J.add(v_px_301, J.mul(J.div(v_dx_303, v_l_305), env["e"])), J.add(v_py_302, J.mul(J.div(v_dy_304, v_l_305), env["e"]))]

func _f22(this_, a: Array, env):
	var v_ctx_258 = null; var v_img_259 = null; var v_iw_260 = null; var v_ih_261 = null; var v_W_262 = null; var v_H_263 = null; var v_V_264 = null; var v_P_265 = null; var v_i0_266 = null; var v_i1_267 = null; var v_i2_268 = null; var v_s0_269 = null; var v_s1_270 = null; var v_s2_271 = null; var v_x0_272 = null; var v_y0_273 = null; var v_x1_274 = null; var v_y1_275 = null; var v_x2_276 = null; var v_y2_277 = null; var v_u0_278 = null; var v_v0_279 = null; var v_u1_280 = null; var v_v1_281 = null; var v_u2_282 = null; var v_v2_283 = null; var v_ex_287 = null; var v_a0_288 = null; var v_b0_289 = null; var v_a1_290 = null; var v_b1_291 = null; var v_a2_292 = null; var v_b2_293 = null; var v_den_294 = null; var v_m11_295 = null; var v_m12_296 = null; var v_m21_297 = null; var v_m22_298 = null; var v_dx_299 = null; var v_dy_300 = null
	var _s73 = {"__p": env, "cx": null, "cy": null, "e": null}
	v_ctx_258 = J.arg(a, 0)
	v_img_259 = J.arg(a, 1)
	v_iw_260 = J.arg(a, 2)
	v_ih_261 = J.arg(a, 3)
	v_W_262 = J.arg(a, 4)
	v_H_263 = J.arg(a, 5)
	v_V_264 = J.arg(a, 6)
	v_P_265 = J.arg(a, 7)
	v_i0_266 = J.arg(a, 8)
	v_i1_267 = J.arg(a, 9)
	v_i2_268 = J.arg(a, 10)
	v_s0_269 = J.gp(v_V_264, v_i0_266)
	v_s1_270 = J.gp(v_V_264, v_i1_267)
	v_s2_271 = J.gp(v_V_264, v_i2_268)
	v_x0_272 = J.mul(J.gp(J.gp(v_P_265, v_i0_266), 0.0), v_W_262)
	v_y0_273 = J.mul(J.gp(J.gp(v_P_265, v_i0_266), 1.0), v_H_263)
	v_x1_274 = J.mul(J.gp(J.gp(v_P_265, v_i1_267), 0.0), v_W_262)
	v_y1_275 = J.mul(J.gp(J.gp(v_P_265, v_i1_267), 1.0), v_H_263)
	v_x2_276 = J.mul(J.gp(J.gp(v_P_265, v_i2_268), 0.0), v_W_262)
	v_y2_277 = J.mul(J.gp(J.gp(v_P_265, v_i2_268), 1.0), v_H_263)
	v_u0_278 = J.mul(J.gp(v_s0_269, "u"), v_iw_260)
	v_v0_279 = J.mul(J.gp(v_s0_269, "v"), v_ih_261)
	v_u1_280 = J.mul(J.gp(v_s1_270, "u"), v_iw_260)
	v_v1_281 = J.mul(J.gp(v_s1_270, "v"), v_ih_261)
	v_u2_282 = J.mul(J.gp(v_s2_271, "u"), v_iw_260)
	v_v2_283 = J.mul(J.gp(v_s2_271, "v"), v_ih_261)
	_s73["cx"] = J.div(J.add(J.add(v_x0_272, v_x1_274), v_x2_276), 3.0)
	_s73["cy"] = J.div(J.add(J.add(v_y0_273, v_y1_275), v_y2_277), 3.0)
	_s73["e"] = 0.9
	v_ex_287 = Callable(self, "_f23").bind(_s73)
	var _t120 = J.cl(v_ex_287, null, [v_x0_272, v_y0_273])
	var _t121 = J.gp(_t120, 0.0)
	v_a0_288 = _t121
	var _t122 = J.gp(_t120, 1.0)
	v_b0_289 = _t122
	var _t123 = J.cl(v_ex_287, null, [v_x1_274, v_y1_275])
	var _t124 = J.gp(_t123, 0.0)
	v_a1_290 = _t124
	var _t125 = J.gp(_t123, 1.0)
	v_b1_291 = _t125
	var _t126 = J.cl(v_ex_287, null, [v_x2_276, v_y2_277])
	var _t127 = J.gp(_t126, 0.0)
	v_a2_292 = _t127
	var _t128 = J.gp(_t126, 1.0)
	v_b2_293 = _t128
	J.mc(v_ctx_258, "save", [])
	J.mc(v_ctx_258, "beginPath", [])
	J.mc(v_ctx_258, "moveTo", [v_a0_288, v_b0_289])
	J.mc(v_ctx_258, "lineTo", [v_a1_290, v_b1_291])
	J.mc(v_ctx_258, "lineTo", [v_a2_292, v_b2_293])
	J.mc(v_ctx_258, "closePath", [])
	J.mc(v_ctx_258, "clip", [])
	v_den_294 = ((J.mul(v_u0_278, J.sub(v_v1_281, v_v2_283)) + J.mul(v_u1_280, J.sub(v_v2_283, v_v0_279))) + J.mul(v_u2_282, J.sub(v_v0_279, v_v1_281)))
	if (absf(J.num(v_den_294)) < 0.000001):
		J.mc(v_ctx_258, "restore", [])
		return null
	v_m11_295 = J.div(((J.mul(v_x0_272, J.sub(v_v1_281, v_v2_283)) + J.mul(v_x1_274, J.sub(v_v2_283, v_v0_279))) + J.mul(v_x2_276, J.sub(v_v0_279, v_v1_281))), v_den_294)
	v_m12_296 = J.div(((J.mul(v_y0_273, J.sub(v_v1_281, v_v2_283)) + J.mul(v_y1_275, J.sub(v_v2_283, v_v0_279))) + J.mul(v_y2_277, J.sub(v_v0_279, v_v1_281))), v_den_294)
	v_m21_297 = J.div(((J.mul(v_x0_272, J.sub(v_u2_282, v_u1_280)) + J.mul(v_x1_274, J.sub(v_u0_278, v_u2_282))) + J.mul(v_x2_276, J.sub(v_u1_280, v_u0_278))), v_den_294)
	v_m22_298 = J.div(((J.mul(v_y0_273, J.sub(v_u2_282, v_u1_280)) + J.mul(v_y1_275, J.sub(v_u0_278, v_u2_282))) + J.mul(v_y2_277, J.sub(v_u1_280, v_u0_278))), v_den_294)
	v_dx_299 = J.div(((J.mul(v_x0_272, (J.mul(v_u1_280, v_v2_283) - J.mul(v_u2_282, v_v1_281))) + J.mul(v_x1_274, (J.mul(v_u2_282, v_v0_279) - J.mul(v_u0_278, v_v2_283)))) + J.mul(v_x2_276, (J.mul(v_u0_278, v_v1_281) - J.mul(v_u1_280, v_v0_279)))), v_den_294)
	v_dy_300 = J.div(((J.mul(v_y0_273, (J.mul(v_u1_280, v_v2_283) - J.mul(v_u2_282, v_v1_281))) + J.mul(v_y1_275, (J.mul(v_u2_282, v_v0_279) - J.mul(v_u0_278, v_v2_283)))) + J.mul(v_y2_277, (J.mul(v_u0_278, v_v1_281) - J.mul(v_u1_280, v_v0_279)))), v_den_294)
	J.mc(v_ctx_258, "transform", [v_m11_295, v_m12_296, v_m21_297, v_m22_298, v_dx_299, v_dy_300])
	J.mc(v_ctx_258, "drawImage", [v_img_259, 0.0, 0.0])
	J.mc(v_ctx_258, "restore", [])

func _f44(this_, a: Array, env):
	var v_b_369 = null
	v_b_369 = J.arg(a, 0)
	var _t132 = ["armF", "axe"]
	return (not J.t(J.mc(_t132, "includes", [J.gp(v_b_369, 0.0)])))

func _f43(this_, a: Array, env):
	var v_ctx_364 = null; var v_rigId_365 = null; var v_imgKey_366 = null; var v_h_367 = null; var v_pose_368 = null
	v_ctx_364 = J.arg(a, 0)
	v_rigId_365 = J.arg(a, 1)
	v_imgKey_366 = J.arg(a, 2)
	v_h_367 = J.arg(a, 3)
	v_pose_368 = J.arg(a, 4)
	var _t129 = (not J.t(J.gp(env["RIG"], v_imgKey_366)))
	if J.t((J.gp(env["RIG"], v_rigId_365) if _t129 else _t129)):
		var _t130 = env["RIG"]
		var _t131 = J.gp(J.gp(env["RIG"], v_rigId_365), "bones")
		var _t133 = {"bones": J.mc(_t131, "filter", [Callable(self, "_f44").bind(env)])}
		J.sp(_t130, v_imgKey_366, _t133)
	var _t134 = env["drawRaw"]
	return J.cl(_t134, null, [v_ctx_364, v_imgKey_366, 0.0, 0.0, v_h_367, v_pose_368, false])

func _f11(this_, a: Array, env):
	var v_type_129 = null; var v_src_130 = null; var v_o_131 = null
	v_type_129 = J.arg(a, 0)
	v_src_130 = J.arg(a, 1)
	v_o_131 = J.mc(env["gl"], "createShader", [v_type_129])
	J.mc(env["gl"], "shaderSource", [v_o_131, v_src_130])
	J.mc(env["gl"], "compileShader", [v_o_131])
	if (not J.t(J.mc(env["gl"], "getShaderParameter", [v_o_131, J.gp(env["gl"], "COMPILE_STATUS")]))):
		J.throw_(J.new_("Error", [J.mc(env["gl"], "getShaderInfoLog", [v_o_131])]))
		return null
	return v_o_131

func _f12(this_, a: Array, env):
	var v_e_132 = null
	v_e_132 = J.arg(a, 0)
	J.mc(v_e_132, "preventDefault", [])
	env["gl"] = null
	env["dead"] = true
	J.mc(env["texs"], "clear", [])

func _f10(this_, a: Array, env):
	var v_opt_127 = null; var v_sh_128 = null; var v_e_133 = null
	if J.t((env["gl"] if J.t(env["gl"]) else env["dead"])):
		return (not (not J.t(env["gl"])))
	var _t135 = J.S_document_("createElement", ["canvas"])
	env["cv"] = _t135
	var _t136 = env["cv"]
	var _t137 = env["cv"]
	J.sp(_t137, "height", 256.0)
	J.sp(_t136, "width", 256.0)
	v_opt_127 = {"alpha": true, "premultipliedAlpha": true, "antialias": false, "depth": false, "stencil": false, "preserveDrawingBuffer": false}
	var _t138 = J.mc(env["cv"], "getContext", ["webgl2", v_opt_127])
	env["gl"] = _t138
	env["isGL2"] = (not (not J.t(env["gl"])))
	if (not J.t(env["gl"])):
		var _t139 = J.mc(env["cv"], "getContext", ["webgl", v_opt_127])
		env["gl"] = _t139
	if (not J.t(env["gl"])):
		env["dead"] = true
		return false
	v_sh_128 = Callable(self, "_f11").bind(env)
	var _t140 = J.mc(env["gl"], "createProgram", [])
	env["prog"] = _t140
	J.mc(env["gl"], "attachShader", [env["prog"], J.cl(v_sh_128, null, [J.gp(env["gl"], "VERTEX_SHADER"), "attribute vec2 p;attribute vec2 u;varying vec2 v;void main(){v=u;gl_Position=vec4(p,0.0,1.0);}"])])
	J.mc(env["gl"], "attachShader", [env["prog"], J.cl(v_sh_128, null, [J.gp(env["gl"], "FRAGMENT_SHADER"), "precision mediump float;varying vec2 v;uniform sampler2D t;void main(){gl_FragColor=texture2D(t,v);}"])])
	J.mc(env["gl"], "linkProgram", [env["prog"]])
	if (not J.t(J.mc(env["gl"], "getProgramParameter", [env["prog"], J.gp(env["gl"], "LINK_STATUS")]))):
		J.throw_(J.new_("Error", ["link"]))
		return null
	J.mc(env["gl"], "useProgram", [env["prog"]])
	var _t141 = J.mc(env["gl"], "getAttribLocation", [env["prog"], "p"])
	env["aP"] = _t141
	var _t142 = J.mc(env["gl"], "getAttribLocation", [env["prog"], "u"])
	env["aU"] = _t142
	var _t143 = J.mc(env["gl"], "createBuffer", [])
	env["buf"] = _t143
	J.mc(env["gl"], "enable", [J.gp(env["gl"], "BLEND")])
	J.mc(env["gl"], "blendFunc", [J.gp(env["gl"], "ONE"), J.gp(env["gl"], "ONE_MINUS_SRC_ALPHA")])
	J.mc(env["gl"], "clearColor", [0.0, 0.0, 0.0, 0.0])
	J.mc(env["cv"], "addEventListener", ["webglcontextlost", Callable(self, "_f12").bind(env)])
	return true

func _f13(this_, a: Array, env):
	var v_img_136 = null; var v_t_137 = null
	v_img_136 = J.arg(a, 0)
	v_t_137 = J.mc(env["texs"], "get", [v_img_136])
	if J.t(v_t_137):
		return v_t_137
	var _t144 = J.mc(env["gl"], "createTexture", [])
	v_t_137 = _t144
	J.mc(env["gl"], "bindTexture", [J.gp(env["gl"], "TEXTURE_2D"), v_t_137])
	J.mc(env["gl"], "pixelStorei", [J.gp(env["gl"], "UNPACK_PREMULTIPLY_ALPHA_WEBGL"), true])
	J.mc(env["gl"], "pixelStorei", [J.gp(env["gl"], "UNPACK_FLIP_Y_WEBGL"), false])
	J.mc(env["gl"], "texImage2D", [J.gp(env["gl"], "TEXTURE_2D"), 0.0, J.gp(env["gl"], "RGBA"), J.gp(env["gl"], "RGBA"), J.gp(env["gl"], "UNSIGNED_BYTE"), v_img_136])
	J.mc(env["gl"], "texParameteri", [J.gp(env["gl"], "TEXTURE_2D"), J.gp(env["gl"], "TEXTURE_WRAP_S"), J.gp(env["gl"], "CLAMP_TO_EDGE")])
	J.mc(env["gl"], "texParameteri", [J.gp(env["gl"], "TEXTURE_2D"), J.gp(env["gl"], "TEXTURE_WRAP_T"), J.gp(env["gl"], "CLAMP_TO_EDGE")])
	J.mc(env["gl"], "texParameteri", [J.gp(env["gl"], "TEXTURE_2D"), J.gp(env["gl"], "TEXTURE_MAG_FILTER"), J.gp(env["gl"], "LINEAR")])
	J.mc(env["gl"], "texParameteri", [J.gp(env["gl"], "TEXTURE_2D"), J.gp(env["gl"], "TEXTURE_MIN_FILTER"), J.gp(env["gl"], "LINEAR")])
	J.mc(env["texs"], "set", [v_img_136, v_t_137])
	return v_t_137

func _f14(this_, a: Array, env):
	var v_ctx_140 = null; var v_img_141 = null; var v_dev_142 = null; var v_uv_143 = null; var v_tris_144 = null; var v_nTri_145 = null; var v_cw_146 = null; var v_ch_147 = null; var v_bx0_148 = null; var v_by0_149 = null; var v_bx1_150 = null; var v_by1_151 = null; var v_bw_152 = null; var v_bh_153 = null; var v_i_154 = null; var v_k_155 = null; var v_X_156 = null; var v_Y_157 = null; var v_need_158 = null; var v_i_159 = null; var v_k_160 = null; var v_o_161 = null; var v_e_162 = null
	v_ctx_140 = J.arg(a, 0)
	v_img_141 = J.arg(a, 1)
	v_dev_142 = J.arg(a, 2)
	v_uv_143 = J.arg(a, 3)
	v_tris_144 = J.arg(a, 4)
	v_nTri_145 = J.arg(a, 5)
	if (not J.t(J.cl(env["init"], null, []))):
		return false
	v_cw_146 = J.gp(J.gp(v_ctx_140, "canvas"), "width")
	v_ch_147 = J.gp(J.gp(v_ctx_140, "canvas"), "height")
	v_bx0_148 = 1000000000.0
	v_by0_149 = 1000000000.0
	v_bx1_150 = (-1000000000.0)
	v_by1_151 = (-1000000000.0)
	v_i_154 = 0.0
	while true:
		if not J.cmp(v_i_154, J.mul(v_nTri_145, 3.0), "<"): break
		v_k_155 = J.mul(J.gp(v_tris_144, v_i_154), 2.0)
		v_X_156 = J.gp(v_dev_142, v_k_155)
		v_Y_157 = J.gp(v_dev_142, J.add(v_k_155, 1.0))
		if J.cmp(v_X_156, v_bx0_148, "<"):
			v_bx0_148 = v_X_156
		if J.cmp(v_X_156, v_bx1_150, ">"):
			v_bx1_150 = v_X_156
		if J.cmp(v_Y_157, v_by0_149, "<"):
			v_by0_149 = v_Y_157
		if J.cmp(v_Y_157, v_by1_151, ">"):
			v_by1_151 = v_Y_157
		v_i_154 = J.num(v_i_154) + 1.0
	var _t145 = J.max_([0.0, (floor(J.num(v_bx0_148)) - 1.0)])
	v_bx0_148 = _t145
	var _t146 = J.max_([0.0, (floor(J.num(v_by0_149)) - 1.0)])
	v_by0_149 = _t146
	var _t147 = J.min_([v_cw_146, (ceil(J.num(v_bx1_150)) + 1.0)])
	v_bx1_150 = _t147
	var _t148 = J.min_([v_ch_147, (ceil(J.num(v_by1_151)) + 1.0)])
	v_by1_151 = _t148
	v_bw_152 = J.sub(v_bx1_150, v_bx0_148)
	v_bh_153 = J.sub(v_by1_151, v_by0_149)
	var _t149 = J.cmp(v_bw_152, 0.0, "<=")
	if (_t149 if _t149 else J.cmp(v_bh_153, 0.0, "<=")):
		return true
	var _t150 = J.cmp(v_bw_152, 4096.0, ">")
	if (_t150 if _t150 else J.cmp(v_bh_153, 4096.0, ">")):
		return false
	var _t151 = J.cmp(J.gp(env["cv"], "width"), v_bw_152, "<")
	if (_t151 if _t151 else J.cmp(J.gp(env["cv"], "height"), v_bh_153, "<")):
		var _t152 = env["cv"]
		var _t153 = J.max_([J.gp(env["cv"], "width"), (ceil(J.num(J.div(v_bw_152, 64.0))) * 64.0)])
		J.sp(_t152, "width", _t153)
		var _t154 = env["cv"]
		var _t155 = J.max_([J.gp(env["cv"], "height"), (ceil(J.num(J.div(v_bh_153, 64.0))) * 64.0)])
		J.sp(_t154, "height", _t155)
	v_need_158 = (J.mul(v_nTri_145, 3.0) * 4.0)
	if J.cmp(J.len(env["arr"]), v_need_158, "<"):
		var _t156 = J.new_("Float32Array", [v_need_158])
		env["arr"] = _t156
	v_i_159 = 0.0
	while true:
		if not J.cmp(v_i_159, J.mul(v_nTri_145, 3.0), "<"): break
		v_k_160 = J.mul(J.gp(v_tris_144, v_i_159), 2.0)
		v_o_161 = J.mul(v_i_159, 4.0)
		var _t157 = env["arr"]
		var _t158 = ((J.div(J.sub(J.gp(v_dev_142, v_k_160), v_bx0_148), v_bw_152) * 2.0) - 1.0)
		J.sp(_t157, v_o_161, _t158)
		var _t159 = env["arr"]
		var _t160 = J.add(v_o_161, 1.0)
		var _t161 = (1.0 - (J.div(J.sub(J.gp(v_dev_142, J.add(v_k_160, 1.0)), v_by0_149), v_bh_153) * 2.0))
		J.sp(_t159, _t160, _t161)
		var _t162 = env["arr"]
		var _t163 = J.add(v_o_161, 2.0)
		var _t164 = J.gp(v_uv_143, v_k_160)
		J.sp(_t162, _t163, _t164)
		var _t165 = env["arr"]
		var _t166 = J.add(v_o_161, 3.0)
		var _t167 = J.gp(v_uv_143, J.add(v_k_160, 1.0))
		J.sp(_t165, _t166, _t167)
		v_i_159 = J.num(v_i_159) + 1.0
	J.mc(env["gl"], "viewport", [0.0, J.sub(J.gp(env["cv"], "height"), v_bh_153), v_bw_152, v_bh_153])
	J.mc(env["gl"], "disable", [J.gp(env["gl"], "SCISSOR_TEST")])
	J.mc(env["gl"], "clear", [J.gp(env["gl"], "COLOR_BUFFER_BIT")])
	J.mc(env["gl"], "useProgram", [env["prog"]])
	J.mc(env["gl"], "activeTexture", [J.gp(env["gl"], "TEXTURE0")])
	var _t169 = J.gp(env["gl"], "TEXTURE_2D")
	var _t168 = env["tex"]
	J.mc(env["gl"], "bindTexture", [_t169, J.cl(_t168, null, [v_img_141])])
	J.mc(env["gl"], "bindBuffer", [J.gp(env["gl"], "ARRAY_BUFFER"), env["buf"]])
	J.mc(env["gl"], "bufferData", [J.gp(env["gl"], "ARRAY_BUFFER"), J.mc(env["arr"], "subarray", [0.0, v_need_158]), J.gp(env["gl"], "STREAM_DRAW")])
	J.mc(env["gl"], "enableVertexAttribArray", [env["aP"]])
	J.mc(env["gl"], "vertexAttribPointer", [env["aP"], 2.0, J.gp(env["gl"], "FLOAT"), false, 16.0, 0.0])
	J.mc(env["gl"], "enableVertexAttribArray", [env["aU"]])
	J.mc(env["gl"], "vertexAttribPointer", [env["aU"], 2.0, J.gp(env["gl"], "FLOAT"), false, 16.0, 8.0])
	J.mc(env["gl"], "drawArrays", [J.gp(env["gl"], "TRIANGLES"), 0.0, J.mul(v_nTri_145, 3.0)])
	J.mc(v_ctx_140, "save", [])
	J.mc(v_ctx_140, "setTransform", [1.0, 0.0, 0.0, 1.0, 0.0, 0.0])
	J.mc(v_ctx_140, "drawImage", [env["cv"], 0.0, 0.0, v_bw_152, v_bh_153, v_bx0_148, v_by0_149, v_bw_152, v_bh_153])
	J.mc(v_ctx_140, "restore", [])
	return true

func _f15(this_, a: Array, env):
	env["dead"] = true
	env["gl"] = null

func _f16(this_, a: Array, env):
	return J.cl(env["init"], null, [])

func _f9(this_, a: Array, env):
	var v_draw_124 = null
	var _s29 = {"__p": env, "cv": null, "gl": null, "isGL2": null, "prog": null, "buf": null, "aP": null, "aU": null, "dead": null, "texs": null, "init": null, "tex": null, "arr": null}
	_s29["init"] = Callable(self, "_f10").bind(_s29)
	_s29["tex"] = Callable(self, "_f13").bind(_s29)
	v_draw_124 = Callable(self, "_f14").bind(_s29)
	if J.seq(J.typeof_(J.G.get("document")), "undefined"):
		return null
	_s29["cv"] = null
	_s29["gl"] = null
	_s29["isGL2"] = false
	_s29["prog"] = null
	_s29["buf"] = null
	_s29["aP"] = (-1.0)
	_s29["aU"] = (-1.0)
	_s29["dead"] = false
	_s29["texs"] = J.new_("Map", [])
	_s29["arr"] = J.new_("Float32Array", [0.0])
	return {"draw": v_draw_124, "off": Callable(self, "_f15").bind(_s29), "ok": Callable(self, "_f16").bind(_s29)}

func _f24(this_, a: Array, env):
	var v_t_306 = null
	v_t_306 = J.arg(a, 0)
	return (J.mul(J.mul(2.0, v_t_306), v_t_306) if J.cmp(v_t_306, 0.5, "<") else (1.0 - ((2.0 * J.sub(1.0, v_t_306)) * J.sub(1.0, v_t_306))))

func _f25(this_, a: Array, env):
	var v_t_307 = null; var v_k_308 = null
	v_t_307 = J.arg(a, 0)
	v_k_308 = J.arg(a, 1)
	var _t171 = env["S"]
	var _t173 = J.mul(J.mul(J.cl(_t171, null, [J.mul(v_t_307, 2.6)]), 0.12), v_k_308)
	var _t172 = env["S"]
	return {"tail1": _t173, "tail2": J.mul(J.mul(J.cl(_t172, null, [(J.mul(v_t_307, 2.6) - 1.0)]), 0.22), v_k_308)}

func _f26(this_, a: Array, env):
	var v_t_309 = null
	v_t_309 = J.arg(a, 0)
	var _t174 = env["S"]
	var _t176 = J.mul(J.cl(_t174, null, [J.mul(v_t_309, 1.8)]), 0.025)
	var _t175 = env["S"]
	var _t178 = J.mul(J.cl(_t175, null, [J.mul(v_t_309, 1.3)]), 0.05)
	var _t177 = env["S"]
	var _t180 = J.mul(J.cl(_t177, null, [(J.mul(v_t_309, 1.8) + 0.5)]), 0.05)
	var _t179 = env["S"]
	var _t182 = J.mul(J.cl(_t179, null, [(J.mul(v_t_309, 1.8) + 1.0)]), 0.06)
	var _t181 = env["S"]
	var _t184 = J.mul(J.cl(_t181, null, [J.mul(v_t_309, 5.0)]), 0.18)
	var _t183 = env["S"]
	var _t186 = J.mul(J.cl(_t183, null, [J.mul(v_t_309, 2.0)]), 0.06)
	var _t185 = env["S"]
	var _t188 = J.mul(J.cl(_t185, null, [J.mul(v_t_309, 1.6)]), 0.07)
	var _t187 = env["S"]
	var _t190 = J.mul(J.cl(_t187, null, [(J.mul(v_t_309, 1.6) + 1.0)]), 0.07)
	var _t189 = env["S"]
	var _t192 = (1.0 + J.mul(J.cl(_t189, null, [J.mul(v_t_309, 1.8)]), 0.015))
	var _t191 = env["S"]
	var _t195 = (1.0 - J.mul(J.cl(_t191, null, [J.mul(v_t_309, 1.8)]), 0.008))
	var _t194 = (-0.03)
	var _t193 = env["S"]
	var _t197 = {"body": _t176, "head": _t178, "armF": _t180, "armB": _t182, "tie": _t184, "cape": _t186, "hairL": _t188, "hairR": _t190, "sy": _t192, "sx": _t195, "y": (_t194 - J.mul(J.cl(_t193, null, [J.mul(v_t_309, 2.2)]), 0.02)), "legF": 0.0, "legB": 0.0}
	var _t196 = env["tail"]
	return J.S_Object_("assign", [_t197, J.cl(_t196, null, [v_t_309, 1.0])])

func _f27(this_, a: Array, env):
	var v_t_310 = null
	v_t_310 = J.arg(a, 0)
	var _t199 = (-0.04)
	var _t198 = env["S"]
	var _t201 = (_t199 + J.mul(J.cl(_t198, null, [J.mul(v_t_310, 7.0)]), 0.03))
	var _t200 = env["S"]
	var _t203 = J.mul(J.cl(_t200, null, [J.mul(v_t_310, 7.0)]), 0.22)
	var _t202 = env["S"]
	var _t206 = ((-J.num(J.cl(_t202, null, [J.mul(v_t_310, 7.0)]))) * 0.22)
	var _t205 = (-0.3)
	var _t204 = env["S"]
	var _t209 = (_t205 + J.mul(J.cl(_t204, null, [J.mul(v_t_310, 9.0)]), 0.2))
	var _t208 = (-0.15)
	var _t207 = env["S"]
	var _t211 = (_t208 + J.mul(J.cl(_t207, null, [J.mul(v_t_310, 7.0)]), 0.08))
	var _t212 = (-0.12)
	var _t213 = (-0.18)
	var _t210 = env["S"]
	var _t215 = J.mul(J.cl(_t210, null, [J.mul(v_t_310, 7.0)]), 0.32)
	var _t214 = env["S"]
	var _t217 = ((-J.num(J.cl(_t214, null, [J.mul(v_t_310, 7.0)]))) * 0.32)
	var _t216 = env["S"]
	var _t219 = {"body": 0.1, "head": _t201, "armF": _t203, "armB": _t206, "tie": _t209, "cape": _t211, "hairL": _t212, "hairR": _t213, "legF": _t215, "legB": _t217, "y": (((-absf(J.num(J.cl(_t216, null, [J.mul(v_t_310, 7.0)])))) * 0.02) - 0.03)}
	var _t218 = env["tail"]
	return J.S_Object_("assign", [_t219, J.cl(_t218, null, [J.mul(v_t_310, 2.0), 1.6])])

func _f28(this_, a: Array, env):
	var v_t_311 = null; var v_p_312 = null; var v_k_313 = null
	v_t_311 = J.arg(a, 0)
	v_p_312 = J.div(J.mod(v_t_311, 1.4), 1.4)
	v_k_313 = null
	if J.cmp(v_p_312, 0.4, "<"):
		var _t220 = env["ease"]
		var _t221 = (-J.num(J.cl(_t220, null, [J.div(v_p_312, 0.4)])))
		v_k_313 = _t221
	else:
		if J.cmp(v_p_312, 0.5, "<"):
			var _t222 = ((-1.0) + (2.4 * J.div(J.sub(v_p_312, 0.4), 0.1)))
			v_k_313 = _t222
		else:
			if J.cmp(v_p_312, 0.62, "<"):
				v_k_313 = 1.4
			else:
				var _t223 = env["ease"]
				var _t224 = (1.4 * J.sub(1.0, J.cl(_t223, null, [J.div(J.sub(v_p_312, 0.62), 0.38)])))
				v_k_313 = _t224
	var _t226 = {"body": J.mul(0.12, v_k_313), "head": J.mul(0.06, v_k_313), "armF": (J.mul((-0.9), v_k_313) if J.cmp(v_k_313, 0.0, ">") else J.mul((-1.0), v_k_313)), "axe": (J.mul((-0.5), v_k_313) if J.cmp(v_k_313, 0.0, ">") else J.mul((-0.3), v_k_313)), "armB": J.mul(0.25, v_k_313), "tie": ((-0.3) * absf(J.num(v_k_313))), "cape": J.mul((-0.2), v_k_313), "hairL": J.mul((-0.15), v_k_313), "hairR": J.mul((-0.2), v_k_313), "x": (0.1 * J.max_([0.0, v_k_313])), "sx": (1.0 + (0.05 * J.max_([0.0, v_k_313]))), "sy": (1.0 - (0.04 * J.max_([0.0, v_k_313]))), "y": (-0.03), "legF": J.mul(0.2, v_k_313), "legB": J.mul((-0.1), v_k_313)}
	var _t225 = env["tail"]
	return J.S_Object_("assign", [_t226, J.cl(_t225, null, [v_t_311, (1.0 + absf(J.num(v_k_313)))])])

func _f29(this_, a: Array, env):
	var v_t_314 = null; var v_p_315 = null; var v_k_316 = null
	v_t_314 = J.arg(a, 0)
	v_p_315 = J.div(J.mod(v_t_314, 1.2), 1.2)
	v_k_316 = (J.div(v_p_315, 0.08) if J.cmp(v_p_315, 0.08, "<") else J.max_([0.0, (1.0 - J.div(J.sub(v_p_315, 0.08), 0.5))]))
	var _t229 = J.mul((-0.18), v_k_316)
	var _t228 = J.mul((-0.25), v_k_316)
	var _t227 = env["S"]
	var _t231 = {"body": _t229, "head": (_t228 + J.mul(J.mul(J.cl(_t227, null, [J.mul(v_t_314, 40.0)]), 0.04), v_k_316)), "armF": J.mul(0.4, v_k_316), "armB": J.mul((-0.4), v_k_316), "tie": J.mul(0.4, v_k_316), "x": J.mul((-0.08), v_k_316), "sx": (1.0 - J.mul(0.05, v_k_316)), "sy": (1.0 + J.mul(0.05, v_k_316)), "y": ((-0.03) - J.mul(0.03, v_k_316))}
	var _t230 = env["tail"]
	return J.S_Object_("assign", [_t231, J.cl(_t230, null, [v_t_314, 1.0])])

func _f30(this_, a: Array, env):
	var v_t_317 = null; var v_p_318 = null; var v_jump_319 = null; var v_sq_320 = null; var v_sh_321 = null
	v_t_317 = J.arg(a, 0)
	v_p_318 = J.div(J.mod(v_t_317, 1.6), 1.6)
	v_jump_319 = 0.0
	v_sq_320 = 0.0
	if J.cmp(v_p_318, 0.1, "<"):
		var _t232 = J.div(v_p_318, 0.1)
		v_sq_320 = _t232
	else:
		if J.cmp(v_p_318, 0.35, "<"):
			var _t233 = sin(J.num((J.div(J.sub(v_p_318, 0.1), 0.25) * PI)))
			v_jump_319 = _t233
			var _t234 = ((-J.num(v_jump_319)) * 0.6)
			v_sq_320 = _t234
		else:
			v_sq_320 = 0.0
	var _t236 = null
	if J.cmp(v_p_318, 0.35, ">"):
		var _t235 = env["S"]
		_t236 = J.mul(J.cl(_t235, null, [J.mul(v_t_317, 45.0)]), 0.03)
	else:
		_t236 = 0.0
	v_sh_321 = _t236
	var _t238 = {"body": J.add(J.mul((-0.1), v_jump_319), v_sh_321), "head": (J.mul((-0.2), v_jump_319) + J.mul(v_sh_321, 2.0)), "armF": J.add(J.mul(0.6, v_jump_319), v_sh_321), "armB": J.sub(J.mul((-0.6), v_jump_319), v_sh_321), "legF": J.mul(0.25, v_jump_319), "legB": J.mul((-0.2), v_jump_319), "hairL": J.mul((-0.3), v_jump_319), "hairR": J.mul((-0.3), v_jump_319), "x": J.mul(v_sh_321, 0.4), "y": (J.mul((-0.16), v_jump_319) - 0.02), "sx": (1.0 + J.mul(0.08, v_sq_320)), "sy": (1.0 - J.mul(0.1, v_sq_320))}
	var _t237 = env["tail"]
	return J.S_Object_("assign", [_t238, J.cl(_t237, null, [v_t_317, 1.5])])

func _f31(this_, a: Array, env):
	var v_t_322 = null
	v_t_322 = J.arg(a, 0)
	return J.mc(env["ANIM"], "idle", [v_t_322])

func _f32(this_, a: Array, env):
	var v_a_323 = null; var v_b_324 = null; var v_o_325 = null; var v_k_326 = null
	v_a_323 = J.arg(a, 0)
	v_b_324 = J.arg(a, 1)
	v_o_325 = J.S_Object_("assign", [{}, v_a_323])
	for _t239 in J.keys(v_b_324):
		v_k_326 = _t239
		var _t240 = J.seq(J.typeof_(J.gp(v_b_324, v_k_326)), "number")
		var _t242 = (J.seq(J.typeof_(J.gp(v_a_323, v_k_326)), "number") if _t240 else _t240)
		if J.t(_t242):
			var _t241 = ["sx", "sy"]
			_t242 = (not J.t(J.mc(_t241, "includes", [v_k_326])))
		var _t243 = (J.add(J.gp(v_a_323, v_k_326), J.gp(v_b_324, v_k_326)) if _t242 else J.gp(v_b_324, v_k_326))
		J.sp(v_o_325, v_k_326, _t243)
	return v_o_325

func _f33(this_, a: Array, env):
	var v_id_327 = null; var v_k_328 = null
	v_id_327 = J.arg(a, 0)
	v_k_328 = J.arg(a, 1)
	return ({"armF": (((-0.75) * J.min_([v_k_328, 1.0])) - (0.15 * J.max_([0.0, J.sub(v_k_328, 1.0)]))), "axe": ((-0.45) * J.min_([v_k_328, 1.2]))} if J.seq(v_id_327, "afu") else ({"armB": J.mul((-0.9), v_k_328), "armF": J.mul(0.3, v_k_328)} if J.t(J.gp(env["BIG"], v_id_327)) else {"armB": J.mul((-0.6), v_k_328), "armF": J.mul(0.18, v_k_328)}))

func _f34(this_, a: Array, env):
	var v_p_329 = null; var v_t_330 = null; var v_id_331 = null; var v_k_332 = null
	v_p_329 = J.arg(a, 0)
	v_t_330 = J.arg(a, 1)
	v_id_331 = J.arg(a, 2)
	var _t244 = env["ease"]
	v_k_332 = J.cl(_t244, null, [J.min_([1.0, v_p_329])])
	var _t245 = env["add"]
	var _t246 = env["base"]
	var _t249 = J.cl(_t246, null, [v_t_330])
	var _t248 = {"body": J.mul((-0.14), v_k_332), "head": J.mul((-0.1), v_k_332), "x": J.mul((-0.05), v_k_332), "sx": (1.0 - J.mul(0.05, v_k_332)), "sy": (1.0 + J.mul(0.05, v_k_332)), "legF": J.mul((-0.15), v_k_332), "legB": J.mul(0.12, v_k_332), "hairL": J.mul(0.1, v_k_332), "hairR": J.mul(0.1, v_k_332)}
	var _t247 = env["swing"]
	return J.cl(_t245, null, [_t249, J.S_Object_("assign", [_t248, J.cl(_t247, null, [v_id_331, J.mul((-0.9), v_k_332)])])])

func _f35(this_, a: Array, env):
	var v_p_333 = null; var v_t_334 = null; var v_id_335 = null; var v_k_336 = null; var v_e_337 = null
	v_p_333 = J.arg(a, 0)
	v_t_334 = J.arg(a, 1)
	v_id_335 = J.arg(a, 2)
	v_k_336 = J.min_([1.0, J.mul(v_p_333, 1.8)])
	v_e_337 = (1.0 - (J.sub(1.0, v_k_336) * J.sub(1.0, v_k_336)))
	var _t250 = env["add"]
	var _t251 = env["base"]
	var _t254 = J.cl(_t251, null, [v_t_334])
	var _t253 = {"body": J.mul(0.2, v_e_337), "head": J.mul(0.1, v_e_337), "x": J.mul(0.18, v_e_337), "sx": (1.0 + J.mul(0.08, v_e_337)), "sy": (1.0 - J.mul(0.06, v_e_337)), "legF": J.mul(0.14, v_e_337), "legB": J.mul((-0.12), v_e_337), "hairL": J.mul((-0.2), v_e_337), "hairR": J.mul((-0.25), v_e_337), "tie": J.mul((-0.4), v_e_337), "cape": J.mul((-0.3), v_e_337)}
	var _t252 = env["swing"]
	return J.cl(_t250, null, [_t254, J.S_Object_("assign", [_t253, J.cl(_t252, null, [v_id_335, ((-0.9) + J.mul(2.2, v_e_337))])])])

func _f36(this_, a: Array, env):
	var v_p_338 = null; var v_t_339 = null; var v_id_340 = null; var v_q_341 = null; var v_e_342 = null
	v_p_338 = J.arg(a, 0)
	v_t_339 = J.arg(a, 1)
	v_id_340 = J.arg(a, 2)
	v_q_341 = J.min_([1.0, v_p_338])
	v_e_342 = (1.0 - pow(J.num(J.sub(1.0, v_q_341)), J.num(3.0)))
	var _t255 = env["add"]
	var _t256 = env["base"]
	var _t259 = J.cl(_t256, null, [v_t_339])
	var _t258 = {"body": (0.2 + J.mul(0.1, v_e_342)), "head": (0.1 + J.mul(0.08, v_e_342)), "x": (0.18 + J.mul(0.04, v_e_342)), "sx": ((1.0 + 0.08) - J.mul(0.05, v_e_342)), "sy": ((1.0 - 0.06) + J.mul(0.04, v_e_342)), "legF": (0.14 + J.mul(0.06, v_e_342)), "legB": ((-0.12) - J.mul(0.06, v_e_342)), "hairL": ((-0.2) - J.mul(0.15, v_e_342)), "hairR": ((-0.25) - J.mul(0.15, v_e_342)), "tie": ((-0.4) - J.mul(0.3, v_e_342)), "cape": ((-0.3) - J.mul(0.2, v_e_342))}
	var _t257 = env["swing"]
	return J.cl(_t255, null, [_t259, J.S_Object_("assign", [_t258, J.cl(_t257, null, [v_id_340, (1.3 + J.mul(0.75, v_e_342))])])])

func _f37(this_, a: Array, env):
	var v_p_343 = null; var v_t_344 = null; var v_id_345 = null; var v_k_346 = null
	v_p_343 = J.arg(a, 0)
	v_t_344 = J.arg(a, 1)
	v_id_345 = J.arg(a, 2)
	var _t260 = env["ease"]
	v_k_346 = J.sub(1.0, J.cl(_t260, null, [J.min_([1.0, v_p_343])]))
	var _t261 = env["add"]
	var _t262 = env["base"]
	var _t265 = J.cl(_t262, null, [v_t_344])
	var _t264 = {"body": J.mul(0.3, v_k_346), "head": J.mul(0.18, v_k_346), "x": J.mul(0.22, v_k_346), "legF": J.mul(0.2, v_k_346), "legB": J.mul((-0.18), v_k_346), "hairL": J.mul((-0.35), v_k_346), "hairR": J.mul((-0.4), v_k_346)}
	var _t263 = env["swing"]
	return J.cl(_t261, null, [_t265, J.S_Object_("assign", [_t264, J.cl(_t263, null, [v_id_345, J.mul(2.05, v_k_346)])])])

func _f38(this_, a: Array, env):
	var v_p_347 = null; var v_t_348 = null; var v_k_349 = null
	v_p_347 = J.arg(a, 0)
	v_t_348 = J.arg(a, 1)
	v_k_349 = (J.div(v_p_347, 0.15) if J.cmp(v_p_347, 0.15, "<") else J.max_([0.0, (1.0 - J.div(J.sub(v_p_347, 0.15), 0.85))]))
	var _t266 = env["add"]
	var _t267 = env["base"]
	return J.cl(_t266, null, [J.cl(_t267, null, [v_t_348]), {"body": J.mul((-0.22), v_k_349), "head": (J.mul((-0.3), v_k_349) + J.mul((sin(J.num(J.mul(v_t_348, 50.0))) * 0.05), v_k_349)), "armF": J.mul(0.5, v_k_349), "armB": J.mul((-0.5), v_k_349), "x": J.mul((-0.1), v_k_349), "sx": (1.0 - J.mul(0.07, v_k_349)), "sy": (1.0 + J.mul(0.06, v_k_349)), "hairL": J.mul(0.3, v_k_349), "hairR": J.mul(0.3, v_k_349)}])

func _f39(this_, a: Array, env):
	var v_p_350 = null; var v_t_351 = null; var v_k_352 = null; var v_sh_353 = null
	v_p_350 = J.arg(a, 0)
	v_t_351 = J.arg(a, 1)
	var _t268 = env["ease"]
	v_k_352 = J.cl(_t268, null, [J.min_([1.0, J.mul(v_p_350, 1.4)])])
	v_sh_353 = J.mul((sin(J.num(J.mul(v_t_351, 30.0))) * 0.03), v_k_352)
	var _t269 = env["add"]
	var _t270 = env["base"]
	return J.cl(_t269, null, [J.cl(_t270, null, [v_t_351]), {"body": J.add(J.mul((-0.08), v_k_352), v_sh_353), "head": J.mul((-0.18), v_k_352), "armF": J.mul(0.85, v_k_352), "armB": J.mul((-0.85), v_k_352), "y": J.mul((-0.06), v_k_352), "sx": (1.0 + J.mul(0.04, v_k_352)), "sy": (1.0 + J.mul(0.06, v_k_352)), "hairL": J.mul((-0.4), v_k_352), "hairR": J.mul(0.4, v_k_352), "legF": J.mul(0.15, v_k_352), "legB": J.mul((-0.15), v_k_352)}])

func _f40(this_, a: Array, env):
	var v_p_354 = null; var v_t_355 = null; var v_k_356 = null
	v_p_354 = J.arg(a, 0)
	v_t_355 = J.arg(a, 1)
	var _t271 = env["ease"]
	v_k_356 = J.cl(_t271, null, [J.min_([1.0, v_p_354])])
	var _t272 = env["add"]
	var _t273 = env["base"]
	return J.cl(_t272, null, [J.cl(_t273, null, [0.0]), {"body": J.mul((-0.2), v_k_356), "head": J.mul((-0.4), v_k_356), "armF": J.mul(0.8, v_k_356), "armB": J.mul((-0.8), v_k_356), "rot": J.mul((-1.35), v_k_356), "x": J.mul((-0.25), v_k_356), "y": J.mul(0.02, v_k_356)}])

func _f41(this_, a: Array, env):
	var v_p_357 = null; var v_t_358 = null; var v_k_359 = null
	v_p_357 = J.arg(a, 0)
	v_t_358 = J.arg(a, 1)
	v_k_359 = sin(J.num((J.min_([1.0, v_p_357]) * PI)))
	var _t274 = env["add"]
	var _t275 = env["base"]
	return J.cl(_t274, null, [J.cl(_t275, null, [v_t_358]), {"rot": ((-J.min_([1.0, v_p_357])) * 6.283), "y": J.mul((-0.55), v_k_359), "armF": 0.9, "armB": (-0.9), "head": (-0.3), "legF": 0.4, "legB": (-0.4)}])

func _f42(this_, a: Array, env):
	var v_p_360 = null; var v_t_361 = null
	v_p_360 = J.arg(a, 0)
	v_t_361 = J.arg(a, 1)
	var _t276 = env["add"]
	var _t277 = env["base"]
	return J.cl(_t276, null, [J.cl(_t277, null, [J.mul(v_t_361, 0.3)]), {"rot": (-1.5), "x": (-0.2), "y": 0.03, "head": (-0.2), "armF": 0.4, "armB": (-0.3)}])

func _f45(this_, a: Array, env):
	var v_on_370 = null
	v_on_370 = J.arg(a, 0)
	env["NOGL"] = (not J.t(v_on_370))

func _f46(this_, a: Array, env):
	var v_id_371 = null
	v_id_371 = J.arg(a, 0)
	var _t278 = (not (not J.t(J.gp(env["RIG"], v_id_371))))
	var _t280 = (J.seq(J.typeof_(J.G.get("sprOk")), "function") if _t278 else _t278)
	if J.t(_t280):
		var _t279 = J.G.get("sprOk")
		_t280 = J.cl(_t279, null, [v_id_371])
	return _t280

func _f1(this_, a: Array, env):
	var v_mk_3 = null; var v_draw_12 = null; var v_drawBody_27 = null
	var _s2 = {"__p": env, "RIG": null, "GX": null, "GY": null, "cache": null, "segDist": null, "build": null, "solve": null, "NATIVE_R": null, "KEEP": null, "MBUF": null, "MGL": null, "drawRaw": null, "NOGL": null, "drawGL": null, "tri": null, "S": null, "ease": null, "tail": null, "ANIM": null, "base": null, "add": null, "BIG": null, "swing": null}
	v_mk_3 = Callable(self, "_f2").bind(_s2)
	_s2["segDist"] = Callable(self, "_f3").bind(_s2)
	_s2["build"] = Callable(self, "_f4").bind(_s2)
	_s2["solve"] = Callable(self, "_f7").bind(_s2)
	v_draw_12 = Callable(self, "_f8").bind(_s2)
	_s2["drawRaw"] = Callable(self, "_f17").bind(_s2)
	_s2["drawGL"] = Callable(self, "_f19").bind(_s2)
	_s2["tri"] = Callable(self, "_f22").bind(_s2)
	v_drawBody_27 = Callable(self, "_f43").bind(_s2)
	_s2["RIG"] = {"afu": {"bones": [["body", null, 0.5, 0.72, 0.5, 0.42, 0.3], ["tail1", "body", 0.48, 0.8, 0.48, 0.9, 0.16], ["tail2", "tail1", 0.48, 0.9, 0.48, 1.0, 0.14], ["head", "body", 0.5, 0.42, 0.48, 0.1, 0.3], ["armF", "body", 0.38, 0.46, 0.27, 0.52, 0.13], ["axe", "armF", 0.27, 0.52, 0.12, 0.3, 0.2], ["armB", "body", 0.66, 0.5, 0.72, 0.72, 0.11], ["tie", "body", 0.62, 0.42, 0.9, 0.44, 0.12]], "hold": "axe"}, "eguiking": {"bones": [["body", null, 0.48, 0.7, 0.5, 0.42, 0.34], ["tail1", "body", 0.5, 0.8, 0.5, 0.9, 0.16], ["tail2", "tail1", 0.5, 0.9, 0.5, 1.0, 0.14], ["head", "body", 0.55, 0.38, 0.5, 0.12, 0.28], ["armF", "body", 0.38, 0.45, 0.2, 0.3, 0.15], ["armB", "body", 0.62, 0.48, 0.52, 0.55, 0.12], ["cape", "body", 0.78, 0.45, 0.9, 0.65, 0.14]]}, "npc_ken": {"bones": [["hips", null, 0.52, 0.72, 0.52, 0.55, 0.22], ["legF", "hips", 0.42, 0.74, 0.4, 0.97, 0.12], ["legB", "hips", 0.62, 0.74, 0.64, 0.97, 0.12], ["body", "hips", 0.52, 0.66, 0.5, 0.42, 0.26], ["head", "body", 0.5, 0.43, 0.5, 0.12, 0.3], ["armF", "body", 0.32, 0.5, 0.4, 0.52, 0.12], ["armB", "body", 0.7, 0.52, 0.55, 0.56, 0.12]], "legs": true}, "pontianak": {"bones": [["body", null, 0.48, 0.66, 0.48, 0.38, 0.3], ["tail1", "body", 0.48, 0.78, 0.48, 0.88, 0.17], ["tail2", "tail1", 0.48, 0.88, 0.48, 1.0, 0.15], ["head", "body", 0.48, 0.38, 0.48, 0.12, 0.26], ["hairL", "head", 0.25, 0.4, 0.1, 0.7, 0.14], ["hairR", "head", 0.72, 0.4, 0.9, 0.7, 0.14], ["armF", "body", 0.36, 0.46, 0.28, 0.6, 0.12], ["armB", "body", 0.62, 0.46, 0.7, 0.58, 0.12]]}}
	J.S_Object_("assign", [_s2["RIG"], {"xiaozhi": J.cl(v_mk_3, null, [{"c": 0.5, "n": 0.44, "L": [0.3, 0.5, 0.13, 0.68], "R": [0.7, 0.5, 0.86, 0.68], "legs": [0.86, 0.42, 0.58]}]), "egui": J.cl(v_mk_3, null, [{"c": 0.55, "n": 0.4, "L": [0.42, 0.5, 0.4, 0.72], "R": [0.68, 0.5, 0.84, 0.64], "tail": 0.4}]), "xiaogui": J.cl(v_mk_3, null, [{"c": 0.45, "n": 0.46, "h": 0.5, "R": [0.62, 0.55, 0.92, 0.55], "L": [0.4, 0.56, 0.36, 0.64], "tail": 0.3}]), "laojiang": J.cl(v_mk_3, null, [{"c": 0.47, "n": 0.5, "h": 0.47, "L": [0.52, 0.54, 0.1, 0.56], "R": [0.66, 0.55, 0.62, 0.62], "legs": [0.83, 0.42, 0.55], "hop": true}]), "zombie": J.cl(v_mk_3, null, [{"c": 0.45, "n": 0.52, "L": [0.5, 0.55, 0.06, 0.58], "R": [0.66, 0.56, 0.62, 0.62], "legs": [0.86, 0.38, 0.5], "hop": true}]), "shuigui": J.cl(v_mk_3, null, [{"c": 0.5, "n": 0.45, "L": [0.44, 0.56, 0.4, 0.66], "R": [0.62, 0.54, 0.95, 0.5], "tail": 0.45, "hair": [0.18, 0.84]}]), "mengpo": J.cl(v_mk_3, null, [{"c": 0.47, "n": 0.43, "L": [0.32, 0.5, 0.1, 0.44], "R": [0.66, 0.5, 0.62, 0.66], "ar": 0.14}]), "youhun": J.cl(v_mk_3, null, [{"c": 0.45, "n": 0.46, "L": [0.26, 0.56, 0.05, 0.56], "R": [0.64, 0.56, 0.86, 0.6], "tail": 0.45, "hr": 0.32}]), "baiwu": J.cl(v_mk_3, null, [{"c": 0.52, "n": 0.52, "h": 0.55, "ht": 0.1, "hr": 0.34, "L": [0.36, 0.6, 0.24, 0.66], "R": [0.68, 0.6, 0.78, 0.66]}]), "heiwu": J.cl(v_mk_3, null, [{"c": 0.5, "n": 0.56, "ht": 0.1, "hr": 0.36, "L": [0.33, 0.64, 0.16, 0.7], "R": [0.67, 0.64, 0.84, 0.7]}]), "niutou": J.cl(v_mk_3, null, [{"c": 0.56, "n": 0.48, "h": 0.6, "L": [0.36, 0.55, 0.22, 0.6], "R": [0.76, 0.56, 0.86, 0.66], "ar": 0.14}]), "mamian": J.cl(v_mk_3, null, [{"c": 0.46, "n": 0.46, "h": 0.44, "L": [0.26, 0.6, 0.18, 0.66], "R": [0.7, 0.55, 0.85, 0.6], "ar": 0.14}]), "huang": J.cl(v_mk_3, null, [{"c": 0.45, "n": 0.46, "L": [0.3, 0.5, 0.08, 0.5], "R": [0.64, 0.55, 0.72, 0.66], "tail": 0.42}]), "zhiren": J.cl(v_mk_3, null, [{"c": 0.5, "n": 0.47, "L": [0.3, 0.6, 0.12, 0.72], "R": [0.7, 0.6, 0.88, 0.72], "legs": [0.88, 0.42, 0.58]}]), "tianhua": J.cl(v_mk_3, null, [{"c": 0.5, "n": 0.4, "h": 0.4, "L": [0.35, 0.5, 0.2, 0.62], "R": [0.64, 0.42, 0.74, 0.26], "hair": [0.18, 0.62]}]), "npc_ken": J.cl(v_mk_3, null, [{"c": 0.42, "n": 0.4, "h": 0.42, "ht": 0.08, "L": [0.22, 0.48, 0.12, 0.5], "R": [0.62, 0.48, 0.5, 0.5], "legs": [0.66, 0.3, 0.55]}]), "npc_boss": J.cl(v_mk_3, null, [{"c": 0.56, "n": 0.45, "h": 0.58, "L": [0.36, 0.5, 0.15, 0.38], "R": [0.78, 0.5, 0.86, 0.72], "legs": [0.66, 0.48, 0.66]}]), "npc_guard": J.cl(v_mk_3, null, [{"c": 0.5, "n": 0.45, "L": [0.3, 0.55, 0.08, 0.65], "R": [0.7, 0.55, 0.8, 0.62], "legs": [0.7, 0.42, 0.6]}]), "npc_auntie": J.cl(v_mk_3, null, [{"c": 0.55, "n": 0.42, "L": [0.32, 0.48, 0.2, 0.56], "R": [0.75, 0.48, 0.82, 0.6], "legs": [0.72, 0.45, 0.62]}])}])
	_s2["GX"] = 14.0
	_s2["GY"] = 20.0
	_s2["cache"] = {}
	_s2["NATIVE_R"] = {"egui": 1.0, "xiaogui": 1.0, "shuigui": 1.0, "toyol": 1.0, "mamian": 1.0}
	_s2["KEEP"] = {"y": 1.0, "sx": 1.0, "sy": 1.0}
	_s2["MBUF"] = (J.S_document_("createElement", ["canvas"]) if (not J.seq(J.typeof_(J.G.get("document")), "undefined")) else null)
	_s2["MGL"] = J.cl(Callable(self, "_f9").bind(_s2), null, [])
	var _t170 = (not J.seq(J.typeof_(J.G.get("location")), "undefined"))
	_s2["NOGL"] = (J.mc(J.re("[?&]nogl\\b", ""), "test", [J.gp(J.G.get("location"), "search")]) if _t170 else _t170)
	_s2["S"] = J.gp(J.G.get("Math"), "sin")
	_s2["ease"] = Callable(self, "_f24").bind(_s2)
	_s2["tail"] = Callable(self, "_f25").bind(_s2)
	_s2["ANIM"] = {"idle": Callable(self, "_f26").bind(_s2), "walk": Callable(self, "_f27").bind(_s2), "attack": Callable(self, "_f28").bind(_s2), "hurt": Callable(self, "_f29").bind(_s2), "scared": Callable(self, "_f30").bind(_s2)}
	_s2["base"] = Callable(self, "_f31").bind(_s2)
	_s2["add"] = Callable(self, "_f32").bind(_s2)
	_s2["BIG"] = {"afu": 1.0, "xiaozhi": 1.0, "zhiren": 1.0, "youhun": 1.0, "laojiang": 1.0, "zombie": 1.0}
	_s2["swing"] = Callable(self, "_f33").bind(_s2)
	J.S_Object_("assign", [_s2["ANIM"], {"windup": Callable(self, "_f34").bind(_s2), "strike": Callable(self, "_f35").bind(_s2), "follow": Callable(self, "_f36").bind(_s2), "recover": Callable(self, "_f37").bind(_s2), "hurtP": Callable(self, "_f38").bind(_s2), "cast": Callable(self, "_f39").bind(_s2), "die": Callable(self, "_f40").bind(_s2), "air": Callable(self, "_f41").bind(_s2), "down": Callable(self, "_f42").bind(_s2)}])
	return {"drawBody": v_drawBody_27, "draw": v_draw_12, "ANIM": _s2["ANIM"], "RIG": _s2["RIG"], "NATIVE_R": _s2["NATIVE_R"], "mk": v_mk_3, "gl": Callable(self, "_f45").bind(_s2), "has": Callable(self, "_f46").bind(_s2)}
