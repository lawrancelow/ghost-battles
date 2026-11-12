# 自動轉譯自 daily_work.js（tools/jsgd.js）——唔好直接改，改原 JS 再轉
extends RefCounted

func run(env):
	var this_ = null; var a = []
	J.G["WORK"] = J.cl(Callable(self, "_f1").bind(env), null, [])

func _f16(this_, a: Array, env):
	var v_o_97 = null
	v_o_97 = J.arg(a, 0)
	return J.S_Object_("assign", [{}, env["DEF"], v_o_97])

func _f15(this_, a: Array, env):
	var v_keys_94 = null; var v_t_95 = null; var v_full_96 = null; var v_i_98 = null; var v_a_99 = null; var v_b_100 = null; var v_q_101 = null; var v_o_102 = null; var v_k_103 = null
	v_keys_94 = J.arg(a, 0)
	v_t_95 = J.arg(a, 1)
	v_full_96 = Callable(self, "_f16").bind(env)
	if J.cmp(v_t_95, J.gp(J.gp(v_keys_94, 0.0), 0.0), "<="):
		return J.cl(v_full_96, null, [J.gp(J.gp(v_keys_94, 0.0), 1.0)])
	v_i_98 = 1.0
	while true:
		if not J.cmp(v_i_98, J.len(v_keys_94), "<"): break
		if J.cmp(v_t_95, J.gp(J.gp(v_keys_94, v_i_98), 0.0), "<="):
			v_a_99 = J.cl(v_full_96, null, [J.gp(J.gp(v_keys_94, J.sub(v_i_98, 1.0)), 1.0)])
			v_b_100 = J.cl(v_full_96, null, [J.gp(J.gp(v_keys_94, v_i_98), 1.0)])
			var _t2 = env["E"]
			var _t1 = J.gp(J.gp(v_keys_94, v_i_98), 2.0)
			var _t3 = (_t1 if J.t(_t1) else "io")
			var _t5 = J.sub(v_t_95, J.gp(J.gp(v_keys_94, J.sub(v_i_98, 1.0)), 0.0))
			var _t4 = J.sub(J.gp(J.gp(v_keys_94, v_i_98), 0.0), J.gp(J.gp(v_keys_94, J.sub(v_i_98, 1.0)), 0.0))
			v_q_101 = J.mc(_t2, _t3, [J.div(_t5, (_t4 if J.t(_t4) else 1.0))])
			v_o_102 = {}
			for _t6 in J.keys(v_a_99):
				v_k_103 = _t6
				var _t7 = env["lerp"]
				var _t8 = J.cl(_t7, null, [J.gp(v_a_99, v_k_103), J.gp(v_b_100, v_k_103), v_q_101])
				J.sp(v_o_102, v_k_103, _t8)
			return v_o_102
		v_i_98 = J.num(v_i_98) + 1.0
	return J.cl(v_full_96, null, [J.gp(J.gp(v_keys_94, (J.len(v_keys_94) - 1.0)), 1.0)])

func _f20(this_, a: Array, env):
	var v_b_124 = null
	v_b_124 = J.arg(a, 0)
	return J.seq(J.gp(v_b_124, 0.0), env["n"])

func _f19(this_, a: Array, env):
	var _s25 = {"__p": env, "n": null}
	_s25["n"] = J.arg(a, 0)
	var _t20 = _s25["__p"]["RG"]
	if J.t(_t20):
		var _t19 = J.gp(_s25["__p"]["RG"], "bones")
		_t20 = J.mc(_t19, "find", [Callable(self, "_f20").bind(_s25)])
	return _t20

func _f18(this_, a: Array, env):
	var v_id_109 = null; var v_special_110 = null; var v_C_111 = null; var v_arm_112 = null; var v_bone_114 = null; var v_bb_115 = null; var v_hb_116 = null; var v_img_117 = null; var v_ar_118 = null; var v_nr_119 = null; var v_pv_120 = null; var v_gp_121 = null; var v_long_122 = null
	var _s24 = {"__p": env, "RG": null}
	v_id_109 = J.arg(a, 0)
	if J.t(J.gp(_s24["__p"]["RC"], v_id_109)):
		return J.gp(_s24["__p"]["RC"], v_id_109)
	var _t9 = (not J.seq(J.typeof_(J.G.get("SPECIAL")), "undefined"))
	v_special_110 = (J.mc(J.G.get("SPECIAL"), "has", [v_id_109]) if _t9 else _t9)
	v_C_111 = (J.gp(J.gp(J.G.get("LIMBS_DATA"), "chars"), v_id_109) if (not J.seq(J.typeof_(J.G.get("LIMBS_DATA")), "undefined")) else null)
	var _t10 = (not J.t(v_special_110))
	var _t12 = ((not (not J.t(v_C_111))) if _t10 else _t10)
	if J.t(_t12):
		var _t11 = _s24["__p"]["ok"]
		_t12 = J.cl(_t11, null, [J.add(v_id_109, "__body")])
	var _t14 = _t12
	if J.t(_t14):
		var _t13 = _s24["__p"]["ok"]
		_t14 = J.cl(_t13, null, [J.add(v_id_109, "__arm")])
	var _t17 = _t14
	if J.t(_t17):
		var _t16 = J.gp(v_C_111, "still")
		if J.t(_t16):
			var _t15 = J.gp(v_C_111, "still")
			_t16 = J.cmp(J.mc(_t15, "indexOf", ["head"]), 0.0, ">=")
		_t17 = (not J.t(_t16))
	v_arm_112 = ((not J.seq(J.typeof_(J.G.get("MoveKit")), "undefined")) if J.t(_t17) else _t17)
	var _t18 = (not J.t(v_special_110))
	_s24["RG"] = (J.gp(J.gp(J.G.get("MeshAnim"), "RIG"), v_id_109) if ((not J.seq(J.typeof_(J.G.get("MeshAnim")), "undefined")) if _t18 else _t18) else null)
	v_bone_114 = Callable(self, "_f19").bind(_s24)
	v_bb_115 = J.cl(v_bone_114, null, ["body"])
	v_hb_116 = J.cl(v_bone_114, null, ["head"])
	v_img_117 = J.gp(J.G.get("SPR"), (J.add(v_id_109, "__body") if J.t(v_arm_112) else v_id_109))
	var _t21 = (not J.t(v_img_117))
	if (_t21 if _t21 else (not J.t(J.gp(v_img_117, "naturalWidth")))):
		return null
	v_ar_118 = J.div(J.gp(v_img_117, "naturalWidth"), J.gp(v_img_117, "naturalHeight"))
	var _t22 = (not J.seq(J.typeof_(J.G.get("MeshAnim")), "undefined"))
	var _t23 = (J.gp(J.G.get("MeshAnim"), "NATIVE_R") if _t22 else _t22)
	var _t24 = J.gp((_t23 if J.t(_t23) else {}), v_id_109)
	v_nr_119 = (not (not J.t((_t24 if J.t(_t24) else (J.gp(v_C_111, "nativeR") if J.t(v_C_111) else v_C_111)))))
	v_pv_120 = (J.gp(v_C_111, "pivot") if J.t(v_arm_112) else null)
	var _t27 = null
	if J.t(v_arm_112):
		var _t25 = J.gp(v_C_111, "grip")
		var _t26 = (_t25 if J.t(_t25) else J.gp(v_C_111, "tip"))
		_t27 = (_t26 if J.t(_t26) else J.gp(v_C_111, "pivot"))
	else:
		_t27 = null
	v_gp_121 = _t27
	v_long_122 = ((J.hypot_([J.mul(J.sub(J.gp(J.gp(v_C_111, "tip"), 0.0), J.gp(J.gp(v_C_111, "pivot"), 0.0)), v_ar_118), J.sub(J.gp(J.gp(v_C_111, "tip"), 1.0), J.gp(J.gp(v_C_111, "pivot"), 1.0))]) > 0.12) if J.t(v_arm_112) else false)
	var _t28 = _s24["__p"]["RC"]
	var _t29 = (not J.t(v_special_110))
	var _t30 = {"id": v_id_109, "special": v_special_110, "arm": v_arm_112, "C": v_C_111, "nr": v_nr_119, "ar": v_ar_118, "pv": v_pv_120, "gp": v_gp_121, "long": v_long_122, "mesh": ((not (not J.t(_s24["RG"]))) if _t29 else _t29), "bp": ([J.gp(v_bb_115, 2.0), J.gp(v_bb_115, 3.0)] if J.t(v_bb_115) else [0.5, 0.66]), "hd": ([J.gp(v_hb_116, 4.0), J.gp(v_hb_116, 5.0)] if J.t(v_hb_116) else [0.5, 0.2]), "legs": (not (not J.t((J.gp(_s24["RG"], "legs") if J.t(_s24["RG"]) else _s24["RG"])))), "hop": (not (not J.t(J.gp(_s24["__p"]["HOPS"], v_id_109)))), "solid": (not (not J.t(J.gp(_s24["__p"]["SOLIDS"], v_id_109))))}
	J.sp(_t28, v_id_109, _t30)
	return _t30

func _f23(this_, a: Array, env):
	var v_u_155 = null; var v_v_156 = null
	v_u_155 = J.arg(a, 0)
	v_v_156 = J.arg(a, 1)
	return [J.mul(((1.0 if J.t(J.gp(env["R"], "nr")) else (-1.0)) * J.sub(v_u_155, 0.5)), env["W"]), J.mul(J.sub(v_v_156, 1.0), env["H"])]

func _f24(this_, a: Array, env):
	var v_u_157 = null; var v_du_158 = null
	v_u_157 = J.arg(a, 0)
	v_du_158 = J.arg(a, 1)
	return (J.add(v_u_157, v_du_158) if J.t(J.gp(env["R"], "nr")) else J.sub(v_u_157, v_du_158))

func _f25(this_, a: Array, env):
	var v_u_164 = null; var v_v_165 = null; var v_p_166 = null; var v_dx_167 = null; var v_dy2_168 = null
	v_u_164 = J.arg(a, 0)
	v_v_165 = J.arg(a, 1)
	var _t80 = env["ip"]
	v_p_166 = J.cl(_t80, null, [v_u_164, v_v_165])
	v_dx_167 = J.sub(J.gp(v_p_166, 0.0), J.gp(env["bpp"], 0.0))
	v_dy2_168 = J.sub(J.gp(v_p_166, 1.0), J.gp(env["bpp"], 1.0))
	return [J.sub(J.add(J.gp(env["bpp"], 0.0), J.mul(env["c"], v_dx_167)), J.mul(env["s"], v_dy2_168)), J.add(J.add(J.add(J.gp(env["bpp"], 1.0), J.mul(env["s"], v_dx_167)), J.mul(env["c"], v_dy2_168)), env["yoff"])]

func _f26(this_, a: Array, env):
	var v_p_169 = null
	v_p_169 = J.arg(a, 0)
	var _t82 = J.gp(env["P"], "bm")
	return J.mc(_t82, "pt", [J.gp(v_p_169, 0.0), J.gp(v_p_169, 1.0)])

func _f22(this_, a: Array, env):
	var v_a_127 = null; var v_fr_128 = null; var v_k_131 = null; var v_t_133 = null; var v_fwd_135 = null; var v_fl_136 = null; var v_dy_137 = null; var v_lean_138 = null; var v_legF_139 = null; var v_legB_140 = null; var v_sx_141 = null; var v_sy_142 = null; var v_lift_143 = null; var v_hip_144 = null; var v_bm_145 = null; var v_mp_147 = null; var v_bend_149 = null; var v_bodyPt_153 = null; var v_at_154 = null; var v_w_159 = null; var v_h_160 = null; var v_g_161 = null; var v_b2_162 = null; var v_z_163 = null; var v_hp_170 = null; var v_hmL_171 = null; var v_gl_172 = null; var v_T_173 = null; var v_img_174 = null; var v_th_175 = null; var v_tw_176 = null; var v_mx_177 = null; var v_tm_178 = null
	var _s28 = {"__p": env, "R": null, "H": null, "W": null, "ip": null, "P": null, "yoff": null, "c": null, "s": null, "bpp": null}
	v_a_127 = J.arg(a, 0)
	v_fr_128 = J.arg(a, 1)
	var _t31 = _s28["__p"]["rigOf"]
	_s28["R"] = J.cl(_t31, null, [J.gp(v_a_127, "type")])
	_s28["H"] = J.gp(v_a_127, "H")
	v_k_131 = J.gp(v_fr_128, "k")
	_s28["W"] = J.mul(_s28["H"], J.gp(_s28["R"], "ar"))
	var _t32 = J.gp(J.gp(v_a_127, "o"), "t")
	v_t_133 = (_t32 if J.t(_t32) else 0.0)
	_s28["ip"] = Callable(self, "_f23").bind(_s28)
	v_fwd_135 = Callable(self, "_f24").bind(_s28)
	var _t33 = J.gp(_s28["R"], "solid")
	v_fl_136 = (0.0 if J.t((_t33 if J.t(_t33) else J.gp(_s28["R"], "special"))) else J.mul((3.0 + (sin(J.num(J.mul(v_t_133, 2.4))) * 2.0)), J.gp(v_a_127, "s")))
	v_dy_137 = J.mul(J.gp(v_k_131, "dy"), _s28["H"])
	v_lean_138 = J.gp(v_k_131, "lean")
	v_legF_139 = 0.0
	v_legB_140 = 0.0
	v_sx_141 = J.gp(v_k_131, "sx")
	v_sy_142 = J.gp(v_k_131, "sy")
	v_lift_143 = (-J.num(J.gp(v_k_131, "dy")))
	if J.t(J.gp(v_fr_128, "walk")):
		v_w_159 = J.gp(v_fr_128, "walk")
		if J.t(J.gp(_s28["R"], "hop")):
			v_h_160 = absf(J.num(sin(J.num(J.mul(v_w_159, 5.5)))))
			var _t34 = J.sub(v_dy_137, J.mul(J.mul(v_h_160, 0.1), _s28["H"]))
			v_dy_137 = _t34
			var _t35 = J.add(v_lift_143, J.mul(v_h_160, 0.1))
			v_lift_143 = _t35
			v_g_161 = (1.0 - J.min_([1.0, J.mul(v_h_160, 6.0)]))
			var _t36 = J.mul(v_sy_142, (1.0 - J.mul(0.07, v_g_161)))
			v_sy_142 = _t36
			var _t37 = J.mul(v_sx_141, (1.0 + J.mul(0.05, v_g_161)))
			v_sx_141 = _t37
		else:
			if J.t(J.gp(_s28["R"], "legs")):
				var _t38 = (sin(J.num(J.mul(v_w_159, 8.0))) * 0.34)
				v_legF_139 = _t38
				v_legB_140 = (-J.num(v_legF_139))
				var _t39 = J.sub(v_dy_137, J.mul((absf(J.num(sin(J.num(J.mul(v_w_159, 8.0))))) * 0.022), _s28["H"]))
				v_dy_137 = _t39
			else:
				var _t40 = J.add(v_lean_138, 7.0)
				v_lean_138 = _t40
				var _t41 = J.sub(v_dy_137, J.mul((sin(J.num(J.mul(v_w_159, 4.0))) * 0.015), _s28["H"]))
				v_dy_137 = _t41
	v_hip_144 = (0.35 if J.t(J.gp(_s28["R"], "special")) else J.sub(1.0, J.gp(J.gp(_s28["R"], "bp"), 1.0)))
	var _t42 = J.cl(_s28["__p"]["M"], null, [])
	var _t43 = J.gp(v_fr_128, "ox")
	var _t45 = J.mul((_t43 if J.t(_t43) else 0.0), _s28["H"])
	var _t44 = J.gp(v_fr_128, "oy")
	var _t46 = J.mc(_t42, "t", [_t45, (_t44 if J.t(_t44) else 0.0)])
	var _t47 = J.gp(v_fr_128, "face")
	var _t48 = J.mc(_t46, "s", [(_t47 if J.t(_t47) else 1.0), 1.0])
	var _t49 = J.mc(_t48, "t", [J.mul(J.gp(v_k_131, "dx"), _s28["H"]), J.sub(v_dy_137, v_fl_136)])
	var _t50 = J.mc(_t49, "t", [0.0, J.mul((-J.num(v_hip_144)), _s28["H"])])
	var _t51 = J.mc(_t50, "r", [J.mul(v_lean_138, _s28["__p"]["D"])])
	var _t52 = J.mc(_t51, "t", [0.0, J.mul(v_hip_144, _s28["H"])])
	v_bm_145 = J.mc(_t52, "s", [v_sx_141, v_sy_142])
	_s28["P"] = {"R": _s28["R"], "H": _s28["H"], "W": _s28["W"], "bm": v_bm_145, "lift": v_lift_143, "legF": v_legF_139, "legB": v_legB_140, "fl": v_fl_136}
	if J.t(J.gp(_s28["R"], "special")):
		v_b2_162 = J.mul(J.gp(v_k_131, "bend"), 0.55)
		var _t53 = _s28["P"]
		var _t54 = J.mc(v_bm_145, "clone", [])
		var _t55 = J.mc(_t54, "t", [0.0, J.mul((-0.3), _s28["H"])])
		var _t56 = J.mc(_t55, "r", [J.mul(v_b2_162, _s28["__p"]["D"])])
		var _t57 = J.mc(_t56, "t", [0.0, J.mul(0.3, _s28["H"])])
		J.sp(_t53, "bm", _t57)
		var _t58 = _s28["P"]
		var _t59 = J.gp(_s28["P"], "bm")
		var _t60 = J.mc(_t59, "pt", [0.0, J.mul((-0.97), _s28["H"])])
		J.sp(_t58, "top", _t60)
		var _t61 = _s28["P"]
		var _t62 = J.gp(_s28["P"], "bm")
		var _t63 = J.mc(_t62, "pt", [J.mul(0.12, _s28["H"]), J.mul((-0.7), _s28["H"])])
		J.sp(_t61, "mouth", _t63)
		var _t64 = _s28["P"]
		var _t65 = J.gp(_s28["P"], "bm")
		var _t66 = J.mc(_t65, "pt", [J.mul(0.3, _s28["H"]), J.mul((-0.45), _s28["H"])])
		J.sp(_t64, "G", _t66)
		var _t67 = _s28["P"]
		var _t68 = J.gp(_s28["P"], "bm")
		var _t69 = J.mc(_t68, "pt", [J.mul(0.15, _s28["H"]), J.mul((-0.4), _s28["H"])])
		J.sp(_t67, "belly", _t69)
		return _s28["P"]
	var _t72 = null
	if J.t(J.gp(_s28["R"], "arm")):
		var _t70 = _s28["P"]
		var _t71 = {"id": J.gp(_s28["R"], "id"), "nr": J.gp(_s28["R"], "nr"), "W": _s28["W"], "H": _s28["H"], "C": J.gp(_s28["R"], "C"), "t": v_t_133, "o": J.gp(v_a_127, "o")}
		J.sp(_t70, "K", _t71)
		_t72 = J.mc(J.G.get("MoveKit"), "pose", [_t71, {"body": J.mul(J.gp(v_k_131, "bend"), _s28["__p"]["D"]), "head": J.mul(J.gp(v_k_131, "head"), _s28["__p"]["D"]), "legF": v_legF_139, "legB": v_legB_140}])
	else:
		_t72 = null
	v_mp_147 = _t72
	_s28["yoff"] = null
	if J.t(v_mp_147):
		var _t73 = J.gp(v_mp_147, "y")
		var _t74 = J.mul((_t73 if J.t(_t73) else 0.0), _s28["H"])
		_s28["yoff"] = _t74
	else:
		var _t75 = J.gp(J.G.get("MeshAnim"), "ANIM")
		v_z_163 = J.mc(_t75, "idle", [v_t_133])
		var _t76 = J.gp(v_z_163, "y")
		var _t77 = J.mul((_t76 if J.t(_t76) else 0.0), _s28["H"])
		_s28["yoff"] = _t77
	var _t78 = _s28["P"]
	J.sp(_t78, "mp", v_mp_147)
	v_bend_149 = J.mul(J.gp(v_k_131, "bend"), _s28["__p"]["D"])
	_s28["c"] = cos(J.num(v_bend_149))
	_s28["s"] = sin(J.num(v_bend_149))
	var _t79 = _s28["ip"]
	_s28["bpp"] = J.cl(_t79, null, [J.gp(J.gp(_s28["R"], "bp"), 0.0), J.mul(J.gp(J.gp(_s28["R"], "bp"), 1.0), J.gp(_s28["R"], "ar"))])
	v_bodyPt_153 = Callable(self, "_f25").bind(_s28)
	var _t81 = _s28["P"]
	J.sp(_t81, "bodyPt", v_bodyPt_153)
	v_at_154 = Callable(self, "_f26").bind(_s28)
	var _t83 = _s28["P"]
	var _t84 = J.cl(v_at_154, null, [J.cl(v_bodyPt_153, null, [J.gp(J.gp(_s28["R"], "hd"), 0.0), 0.02])])
	J.sp(_t83, "top", _t84)
	var _t85 = _s28["P"]
	var _t86 = J.cl(v_at_154, null, [J.cl(v_bodyPt_153, null, [J.cl(v_fwd_135, null, [J.gp(J.gp(_s28["R"], "hd"), 0.0), 0.13]), J.add(J.gp(J.gp(_s28["R"], "hd"), 1.0), 0.09)])])
	J.sp(_t85, "mouth", _t86)
	var _t87 = _s28["P"]
	var _t88 = J.cl(v_at_154, null, [J.cl(v_bodyPt_153, null, [J.cl(v_fwd_135, null, [J.gp(J.gp(_s28["R"], "bp"), 0.0), 0.18]), J.sub(J.gp(J.gp(_s28["R"], "bp"), 1.0), 0.1)])])
	J.sp(_t87, "belly", _t88)
	if J.t(J.gp(_s28["R"], "arm")):
		v_hp_170 = J.cl(v_bodyPt_153, null, [J.gp(J.gp(_s28["R"], "pv"), 0.0), J.gp(J.gp(_s28["R"], "pv"), 1.0)])
		var _t89 = J.cl(_s28["__p"]["M"], null, [])
		var _t90 = J.mc(_t89, "t", [J.add(J.gp(v_hp_170, 0.0), J.mul(J.gp(v_k_131, "hx"), _s28["H"])), J.add(J.gp(v_hp_170, 1.0), J.mul(J.gp(v_k_131, "hy"), _s28["H"]))])
		v_hmL_171 = J.mc(_t90, "r", [J.mul(J.add(J.gp(v_k_131, "hr"), J.gp(v_k_131, "bend")), _s28["__p"]["D"])])
		var _t91 = _s28["P"]
		var _t92 = J.mc(v_bm_145, "clone", [])
		var _t93 = J.mc(_t92, "mul", [v_hmL_171])
		J.sp(_t91, "hm", _t93)
		v_gl_172 = J.mc(v_hmL_171, "pt", [J.mul(((1.0 if J.t(J.gp(_s28["R"], "nr")) else (-1.0)) * J.sub(J.gp(J.gp(_s28["R"], "gp"), 0.0), J.gp(J.gp(_s28["R"], "pv"), 0.0))), _s28["W"]), J.mul(J.sub(J.gp(J.gp(_s28["R"], "gp"), 1.0), J.gp(J.gp(_s28["R"], "pv"), 1.0)), _s28["H"])])
		var _t94 = _s28["P"]
		var _t95 = J.cl(v_at_154, null, [v_gl_172])
		J.sp(_t94, "G", _t95)
		var _t96 = _s28["P"]
		J.sp(_t96, "gl", v_gl_172)
		if J.t(J.gp(v_fr_128, "tool")):
			v_T_173 = J.gp(_s28["__p"]["TOOLS"], J.gp(v_fr_128, "tool"))
			v_img_174 = J.gp(J.G.get("SPR"), J.gp(v_T_173, "key"))
			if J.t((J.gp(v_img_174, "naturalWidth") if J.t(v_img_174) else v_img_174)):
				v_th_175 = J.mul(J.gp(v_T_173, "len"), _s28["H"])
				v_tw_176 = J.div(J.mul(v_th_175, J.gp(v_img_174, "naturalWidth")), J.gp(v_img_174, "naturalHeight"))
				v_mx_177 = ((-1.0) if J.t(J.gp(v_T_173, "mir")) else 1.0)
				var _t97 = J.mc(v_bm_145, "clone", [])
				var _t98 = J.mc(_t97, "t", [J.gp(v_gl_172, 0.0), J.gp(v_gl_172, 1.0)])
				v_tm_178 = J.mc(_t98, "r", [J.mul(J.gp(v_k_131, "ang"), _s28["__p"]["D"])])
				var _t99 = _s28["P"]
				var _t100 = {"tm": v_tm_178, "img": v_img_174, "th": v_th_175, "tw": v_tw_176, "T": v_T_173, "mx": v_mx_177}
				J.sp(_t99, "tool", _t100)
				var _t101 = _s28["P"]
				var _t102 = J.mc(v_tm_178, "pt", [J.mul(J.mul(v_mx_177, J.sub(J.gp(J.gp(v_T_173, "head"), 0.0), J.gp(J.gp(v_T_173, "grip"), 0.0))), v_tw_176), J.mul(J.sub(J.gp(J.gp(v_T_173, "head"), 1.0), J.gp(J.gp(v_T_173, "grip"), 1.0)), v_th_175)])
				J.sp(_t101, "tip", _t102)
	else:
		var _t103 = _s28["P"]
		var _t104 = J.cl(v_at_154, null, [J.cl(v_bodyPt_153, null, [J.cl(v_fwd_135, null, [J.gp(J.gp(_s28["R"], "bp"), 0.0), 0.26]), 0.5])])
		J.sp(_t103, "G", _t104)
	return _s28["P"]

func _f27(this_, a: Array, env):
	var v_ctx_181 = null; var v_key_182 = null; var v_x_183 = null; var v_y_184 = null; var v_w_185 = null; var v_rot_186 = null; var v_o_187 = null; var v_img_188 = null; var v_h_189 = null; var v_an_190 = null
	v_ctx_181 = J.arg(a, 0)
	v_key_182 = J.arg(a, 1)
	v_x_183 = J.arg(a, 2)
	v_y_184 = J.arg(a, 3)
	v_w_185 = J.arg(a, 4)
	v_rot_186 = J.arg(a, 5)
	v_o_187 = J.arg(a, 6)
	v_img_188 = J.gp(J.G.get("SPR"), v_key_182)
	var _t105 = (not J.t(v_img_188))
	var _t106 = (_t105 if _t105 else (not J.t(J.gp(v_img_188, "naturalWidth"))))
	if (_t106 if _t106 else J.cmp(v_w_185, 0.0, "<=")):
		return null
	var _t107 = (v_o_187 if J.t(v_o_187) else {})
	v_o_187 = _t107
	v_h_189 = J.div(J.mul(v_w_185, J.gp(v_img_188, "naturalHeight")), J.gp(v_img_188, "naturalWidth"))
	var _t108 = J.gp(v_o_187, "an")
	v_an_190 = (_t108 if J.t(_t108) else [0.5, 1.0])
	J.mc(v_ctx_181, "save", [])
	if (not J.leq(J.gp(v_o_187, "alpha"), null)):
		var _t109 = env["cl"]
		var _t110 = J.mul(J.gp(v_ctx_181, "globalAlpha"), J.cl(_t109, null, [J.gp(v_o_187, "alpha")]))
		J.sp(v_ctx_181, "globalAlpha", _t110)
	J.mc(v_ctx_181, "translate", [v_x_183, v_y_184])
	if J.t(v_rot_186):
		J.mc(v_ctx_181, "rotate", [J.mul(v_rot_186, env["D"])])
	var _t111 = J.gp(v_o_187, "sx")
	if J.t((_t111 if J.t(_t111) else J.gp(v_o_187, "sy"))):
		var _t112 = J.gp(v_o_187, "sx")
		var _t114 = (_t112 if J.t(_t112) else 1.0)
		var _t113 = J.gp(v_o_187, "sy")
		J.mc(v_ctx_181, "scale", [_t114, (_t113 if J.t(_t113) else 1.0)])
	if J.t(J.gp(v_o_187, "flip")):
		J.mc(v_ctx_181, "scale", [(-1.0), 1.0])
	if J.t(J.gp(v_o_187, "clip")):
		J.mc(v_ctx_181, "beginPath", [])
		J.mc(v_ctx_181, "rect", [J.mul(J.sub(J.gp(J.gp(v_o_187, "clip"), 0.0), J.gp(v_an_190, 0.0)), v_w_185), (J.mul((-J.num(J.gp(v_an_190, 1.0))), v_h_189) - 2.0), J.mul(J.sub(J.gp(J.gp(v_o_187, "clip"), 1.0), J.gp(J.gp(v_o_187, "clip"), 0.0)), v_w_185), J.add(v_h_189, 4.0)])
		J.mc(v_ctx_181, "clip", [])
	J.mc(v_ctx_181, "drawImage", [v_img_188, J.mul((-J.num(J.gp(v_an_190, 0.0))), v_w_185), J.mul((-J.num(J.gp(v_an_190, 1.0))), v_h_189), v_w_185, v_h_189])
	J.mc(v_ctx_181, "restore", [])

func _f29(this_, a: Array, env):
	var v_ctx_196 = null; var v_a_197 = null; var v_P_198 = null; var v_x_199 = null; var v_k_200 = null; var v_r_201 = null
	v_ctx_196 = J.arg(a, 0)
	v_a_197 = J.arg(a, 1)
	v_P_198 = J.arg(a, 2)
	v_x_199 = J.arg(a, 3)
	if J.seq(J.gp(J.gp(v_a_197, "o"), "shadow"), false):
		return null
	v_k_200 = J.max_([0.45, (1.0 - J.mul(J.gp(v_P_198, "lift"), 1.6))])
	v_r_201 = J.mul((J.mul(14.0, J.gp(v_a_197, "s")) * (1.0 if J.t(J.gp(J.gp(v_P_198, "R"), "solid")) else 0.8)), v_k_200)
	J.mc(v_ctx_196, "save", [])
	if (not J.t(J.gp(J.gp(v_P_198, "R"), "solid"))):
		var _t115 = J.mul(J.gp(v_ctx_196, "globalAlpha"), 0.55)
		J.sp(v_ctx_196, "globalAlpha", _t115)
	J.sp(v_ctx_196, "fillStyle", "rgba(0,0,0,.35)")
	J.mc(v_ctx_196, "beginPath", [])
	J.mc(v_ctx_196, "ellipse", [v_x_199, J.mul(1.0, J.gp(v_a_197, "s")), v_r_201, J.mul(v_r_201, 0.29), 0.0, 0.0, env["TAU"]])
	J.mc(v_ctx_196, "fill", [])
	J.mc(v_ctx_196, "restore", [])

func _f30(this_, a: Array, env):
	var v_ctx_204 = null; var v_a_205 = null; var v_P_206 = null; var v_fr_207 = null; var v_R_208 = null; var v_H_209 = null; var v_k_210 = null; var v_z_211 = null; var v_ef_212 = null
	v_ctx_204 = J.arg(a, 0)
	v_a_205 = J.arg(a, 1)
	v_P_206 = J.arg(a, 2)
	v_fr_207 = J.arg(a, 3)
	v_R_208 = J.gp(v_P_206, "R")
	v_H_209 = J.gp(v_P_206, "H")
	v_k_210 = J.gp(v_fr_207, "k")
	if J.t(J.gp(v_R_208, "special")):
		J.mc(v_ctx_204, "save", [])
		var _t116 = J.gp(v_P_206, "bm")
		J.mc(_t116, "set", [v_ctx_204])
		var _t118 = (1.0 if J.t(J.gp(v_a_205, "faceRight")) else (-1.0))
		var _t117 = J.gp(v_fr_207, "face")
		v_ef_212 = J.mul(_t118, (_t117 if J.t(_t117) else 1.0))
		J.mc(v_ctx_204, "scale", [v_ef_212, 1.0])
		J.mc(J.G.get("ART"), "drawChar", [v_ctx_204, J.gp(v_R_208, "id"), 0.0, 0.0, J.gp(v_a_205, "s"), {"t": J.gp(J.gp(v_a_205, "o"), "t"), "flip": J.cmp(v_ef_212, 0.0, "<"), "shadow": false, "key": (J.add("w", J.gp(J.gp(v_a_205, "o"), "wkey")) if (not J.leq(J.gp(J.gp(v_a_205, "o"), "wkey"), null)) else null), "work": false}])
		J.mc(v_ctx_204, "restore", [])
		return null
	if J.t(J.gp(v_R_208, "arm")):
		J.mc(J.G.get("MoveKit"), "body", [v_ctx_204, J.gp(v_P_206, "K"), J.gp(v_P_206, "bm"), J.gp(v_P_206, "mp")])
		return null
	var _t119 = J.gp(J.G.get("MeshAnim"), "ANIM")
	var _t120 = J.gp(J.gp(v_a_205, "o"), "t")
	v_z_211 = J.mc(_t119, "idle", [(_t120 if J.t(_t120) else 0.0)])
	var _t121 = J.gp(v_z_211, "body")
	var _t122 = J.add((_t121 if J.t(_t121) else 0.0), J.mul(J.gp(v_k_210, "bend"), env["D"]))
	J.sp(v_z_211, "body", _t122)
	var _t123 = J.gp(v_z_211, "head")
	var _t124 = J.add((_t123 if J.t(_t123) else 0.0), J.mul(J.gp(v_k_210, "head"), env["D"]))
	J.sp(v_z_211, "head", _t124)
	var _t125 = J.gp(v_P_206, "legF")
	J.sp(v_z_211, "legF", _t125)
	var _t126 = J.gp(v_P_206, "legB")
	J.sp(v_z_211, "legB", _t126)
	J.mc(v_ctx_204, "save", [])
	var _t127 = J.gp(v_P_206, "bm")
	J.mc(_t127, "set", [v_ctx_204])
	J.mc(J.G.get("MeshAnim"), "draw", [v_ctx_204, J.gp(v_R_208, "id"), 0.0, 0.0, v_H_209, v_z_211, true])
	J.mc(v_ctx_204, "restore", [])

func _f31(this_, a: Array, env):
	var v_ctx_215 = null; var v_P_216 = null; var v_T_217 = null
	v_ctx_215 = J.arg(a, 0)
	v_P_216 = J.arg(a, 1)
	v_T_217 = J.gp(v_P_216, "tool")
	if (not J.t(v_T_217)):
		return null
	J.mc(v_ctx_215, "save", [])
	var _t128 = J.gp(v_T_217, "tm")
	J.mc(_t128, "set", [v_ctx_215])
	J.mc(v_ctx_215, "scale", [J.gp(v_T_217, "mx"), 1.0])
	J.mc(v_ctx_215, "drawImage", [J.gp(v_T_217, "img"), J.mul((-J.num(J.gp(J.gp(J.gp(v_T_217, "T"), "grip"), 0.0))), J.gp(v_T_217, "tw")), J.mul((-J.num(J.gp(J.gp(J.gp(v_T_217, "T"), "grip"), 1.0))), J.gp(v_T_217, "th")), J.gp(v_T_217, "tw"), J.gp(v_T_217, "th")])
	J.mc(v_ctx_215, "restore", [])

func _f32(this_, a: Array, env):
	var v_ctx_220 = null; var v_P_221 = null; var v_key_222 = null
	v_ctx_220 = J.arg(a, 0)
	v_P_221 = J.arg(a, 1)
	v_key_222 = J.arg(a, 2)
	if (not J.t(J.gp(J.gp(v_P_221, "R"), "arm"))):
		return null
	J.mc(J.G.get("MoveKit"), "piece", [v_ctx_220, J.gp(v_P_221, "K"), (v_key_222 if J.t(v_key_222) else J.add(J.gp(J.gp(v_P_221, "R"), "id"), "__arm")), J.gp(v_P_221, "hm"), J.gp(J.gp(J.gp(v_P_221, "R"), "pv"), 0.0), J.gp(J.gp(J.gp(v_P_221, "R"), "pv"), 1.0)])

func _f33(this_, a: Array, env):
	var v_ctx_225 = null; var v_a_226 = null; var v_fr_227 = null; var v_P_228 = null
	v_ctx_225 = J.arg(a, 0)
	v_a_226 = J.arg(a, 1)
	v_fr_227 = J.arg(a, 2)
	var _t129 = env["solve"]
	v_P_228 = J.cl(_t129, null, [v_a_226, v_fr_227])
	J.mc(v_ctx_225, "save", [])
	J.mc(v_ctx_225, "translate", [J.gp(v_a_226, "x"), J.gp(v_a_226, "y")])
	J.mc(v_ctx_225, "scale", [(1.0 if J.t(J.gp(v_a_226, "faceRight")) else (-1.0)), 1.0])
	if J.t(J.gp(v_fr_227, "back0")):
		J.mc(v_fr_227, "back0", [v_ctx_225, v_P_228])
	var _t130 = env["shadow"]
	J.cl(_t130, null, [v_ctx_225, v_a_226, v_P_228, J.gp(J.gp(v_P_228, "bm"), "e")])
	if J.t(J.gp(v_fr_227, "back")):
		J.mc(v_fr_227, "back", [v_ctx_225, v_P_228])
	if J.t(J.gp(v_fr_227, "toolBehind")):
		var _t131 = env["drawTool"]
		J.cl(_t131, null, [v_ctx_225, v_P_228])
	var _t132 = env["drawBody"]
	J.cl(_t132, null, [v_ctx_225, v_a_226, v_P_228, v_fr_227])
	if J.t(J.gp(v_fr_227, "mid")):
		J.mc(v_fr_227, "mid", [v_ctx_225, v_P_228])
	if (not J.t(J.gp(v_fr_227, "toolBehind"))):
		var _t133 = env["drawTool"]
		J.cl(_t133, null, [v_ctx_225, v_P_228])
	if (not J.seq(J.gp(v_fr_227, "hand"), false)):
		var _t134 = env["drawHand"]
		var _t139 = J.gp(v_fr_227, "hand")
		if not J.t(_t139):
			var _t136 = J.seq(J.gp(J.gp(v_P_228, "R"), "id"), "eguiking")
			if J.t(_t136):
				var _t135 = J.gp(v_fr_227, "tool")
				_t136 = (_t135 if J.t(_t135) else J.gp(v_fr_227, "emptyHand"))
			var _t138 = _t136
			if J.t(_t138):
				var _t137 = env["ok"]
				_t138 = J.cl(_t137, null, ["eguiking__hand"])
			_t139 = ("eguiking__hand" if J.t(_t138) else null)
		J.cl(_t134, null, [v_ctx_225, v_P_228, _t139])
	if J.t(J.gp(v_fr_227, "front")):
		J.mc(v_fr_227, "front", [v_ctx_225, v_P_228])
	J.mc(v_ctx_225, "restore", [])
	return v_P_228

func _f35(this_, a: Array, env):
	var v_p_240 = null
	v_p_240 = J.arg(a, 0)
	return ([J.gp(v_p_240, 0.0), J.gp(v_p_240, 1.0)] if J.t(v_p_240) else null)

func _f36(this_, a: Array, env):
	var v_p_241 = null
	v_p_241 = J.arg(a, 0)
	return ([J.mul(J.gp(v_p_241, 0.0), env["H"]), J.mul(J.gp(v_p_241, 1.0), env["H"])] if J.t(v_p_241) else null)

func _f34(this_, a: Array, env):
	var v_a_231 = null; var v_name_232 = null; var v_fn_233 = null; var v_key_234 = null; var v_A_235 = null; var v_sc_237 = null; var v_P_238 = null; var v_pick_239 = null
	var _s53 = {"__p": env, "H": null}
	v_a_231 = J.arg(a, 0)
	v_name_232 = J.arg(a, 1)
	v_fn_233 = J.arg(a, 2)
	v_key_234 = J.add(J.add(J.gp(v_a_231, "type"), "|"), v_name_232)
	if (not J.t(J.gp(_s53["__p"]["AIM"], v_key_234))):
		var _t140 = _s53["__p"]["solve"]
		v_P_238 = J.cl(_t140, null, [{"type": J.gp(v_a_231, "type"), "x": 0.0, "y": 0.0, "s": J.div(J.gp(v_a_231, "s"), J.gp(v_a_231, "H")), "H": 1.0, "o": {"t": 0.0}, "faceRight": true}, J.cl(v_fn_233, null, [])])
		v_pick_239 = Callable(self, "_f35").bind(_s53)
		var _t141 = _s53["__p"]["AIM"]
		var _t142 = {"G": J.cl(v_pick_239, null, [J.gp(v_P_238, "G")]), "tip": J.cl(v_pick_239, null, [J.gp(v_P_238, "tip")]), "top": J.cl(v_pick_239, null, [J.gp(v_P_238, "top")]), "mouth": J.cl(v_pick_239, null, [J.gp(v_P_238, "mouth")]), "belly": J.cl(v_pick_239, null, [J.gp(v_P_238, "belly")])}
		J.sp(_t141, v_key_234, _t142)
	v_A_235 = J.gp(_s53["__p"]["AIM"], v_key_234)
	_s53["H"] = J.gp(v_a_231, "H")
	v_sc_237 = Callable(self, "_f36").bind(_s53)
	return {"G": J.cl(v_sc_237, null, [J.gp(v_A_235, "G")]), "tip": J.cl(v_sc_237, null, [J.gp(v_A_235, "tip")]), "top": J.cl(v_sc_237, null, [J.gp(v_A_235, "top")]), "mouth": J.cl(v_sc_237, null, [J.gp(v_A_235, "mouth")]), "belly": J.cl(v_sc_237, null, [J.gp(v_A_235, "belly")])}

func _f38(this_, a: Array, env):
	var v_ctx_250 = null; var v_x_251 = null; var v_y_252 = null; var v_age_253 = null; var v_life_254 = null; var v_n_255 = null; var v_seed_256 = null; var v_H_257 = null; var v_opt_258 = null; var v_drawOne_259 = null; var v_i_260 = null; var v_r1_261 = null; var v_r2_262 = null; var v_r3_263 = null; var v_vx_264 = null; var v_vy_265 = null; var v_g_266 = null; var v_px_267 = null; var v_py_268 = null; var v_al_269 = null
	v_ctx_250 = J.arg(a, 0)
	v_x_251 = J.arg(a, 1)
	v_y_252 = J.arg(a, 2)
	v_age_253 = J.arg(a, 3)
	v_life_254 = J.arg(a, 4)
	v_n_255 = J.arg(a, 5)
	v_seed_256 = J.arg(a, 6)
	v_H_257 = J.arg(a, 7)
	v_opt_258 = J.arg(a, 8)
	v_drawOne_259 = J.arg(a, 9)
	var _t143 = J.cmp(v_age_253, 0.0, "<")
	if (_t143 if _t143 else J.cmp(v_age_253, v_life_254, ">")):
		return null
	v_i_260 = 0.0
	while true:
		if not J.cmp(v_i_260, v_n_255, "<"): break
		var _t144 = env["rnd"]
		v_r1_261 = J.cl(_t144, null, [J.add(v_seed_256, J.mul(v_i_260, 3.1))])
		var _t145 = env["rnd"]
		v_r2_262 = J.cl(_t145, null, [J.add(J.add(v_seed_256, J.mul(v_i_260, 5.7)), 1.0)])
		var _t146 = env["rnd"]
		v_r3_263 = J.cl(_t146, null, [J.add(J.add(v_seed_256, J.mul(v_i_260, 9.3)), 2.0)])
		var _t147 = J.gp(v_opt_258, "dir")
		var _t150 = (_t147 if J.t(_t147) else 0.0)
		var _t149 = J.sub(v_r1_261, 0.5)
		var _t148 = J.gp(v_opt_258, "spread")
		var _t152 = J.mul(J.add(_t150, J.mul(_t149, (_t148 if J.t(_t148) else 1.6))), v_H_257)
		var _t151 = J.gp(v_opt_258, "v")
		v_vx_264 = J.mul(_t152, (_t151 if J.t(_t151) else 1.1))
		var _t154 = J.mul((-(0.6 + J.mul(v_r2_262, 0.9))), v_H_257)
		var _t153 = J.gp(v_opt_258, "up")
		v_vy_265 = J.mul(_t154, (_t153 if J.t(_t153) else 1.3))
		var _t155 = J.gp(v_opt_258, "g")
		v_g_266 = J.mul((_t155 if J.t(_t155) else 5.5), v_H_257)
		v_px_267 = J.add(v_x_251, J.mul(v_vx_264, v_age_253))
		v_py_268 = J.min_([(J.gp(v_opt_258, "floor") if (not J.leq(J.gp(v_opt_258, "floor"), null)) else 1000000000.0), J.add(J.add(v_y_252, J.mul(v_vy_265, v_age_253)), J.mul(J.mul(J.mul(0.5, v_g_266), v_age_253), v_age_253))])
		v_al_269 = (1.0 - pow(J.num(J.div(v_age_253, v_life_254)), J.num(2.0)))
		J.cl(v_drawOne_259, null, [v_ctx_250, v_px_267, v_py_268, v_i_260, v_al_269, v_r3_263, v_age_253])
		v_i_260 = J.num(v_i_260) + 1.0

func _f40(this_, a: Array, env):
	var v_c_279 = null; var v_px_280 = null; var v_py_281 = null; var v_i_282 = null; var v_al_283 = null; var v_r_284 = null; var v_ag_285 = null; var v_w_286 = null; var v_img_287 = null
	v_c_279 = J.arg(a, 0)
	v_px_280 = J.arg(a, 1)
	v_py_281 = J.arg(a, 2)
	v_i_282 = J.arg(a, 3)
	v_al_283 = J.arg(a, 4)
	v_r_284 = J.arg(a, 5)
	v_ag_285 = J.arg(a, 6)
	v_w_286 = J.mul(env["H"], (0.05 + J.mul(v_r_284, 0.035)))
	J.mc(v_c_279, "save", [])
	var _t157 = J.mul(J.gp(v_c_279, "globalAlpha"), v_al_283)
	J.sp(v_c_279, "globalAlpha", _t157)
	J.mc(v_c_279, "translate", [v_px_280, v_py_281])
	J.mc(v_c_279, "rotate", [((J.mul(v_r_284, 6.0) + J.mul(v_ag_285, (8.0 + J.mul(v_r_284, 10.0)))) * (1.0 if J.t(J.mod(v_i_282, 2.0)) else (-1.0)))])
	v_img_287 = J.gp(J.G.get("SPR"), "fx_chips")
	if J.t((J.gp(v_img_287, "naturalWidth") if J.t(v_img_287) else v_img_287)):
		J.mc(v_c_279, "drawImage", [v_img_287, J.div((-J.num(v_w_286)), 2.0), J.div((-J.num(v_w_286)), 2.0), v_w_286, v_w_286])
	J.mc(v_c_279, "restore", [])

func _f39(this_, a: Array, env):
	var v_ctx_272 = null; var v_x_273 = null; var v_y_274 = null; var v_age_275 = null; var v_seed_276 = null; var v_floor_278 = null
	var _s61 = {"__p": env, "H": null}
	v_ctx_272 = J.arg(a, 0)
	v_x_273 = J.arg(a, 1)
	v_y_274 = J.arg(a, 2)
	v_age_275 = J.arg(a, 3)
	v_seed_276 = J.arg(a, 4)
	_s61["H"] = J.arg(a, 5)
	v_floor_278 = J.arg(a, 6)
	var _t156 = _s61["__p"]["spray"]
	J.cl(_t156, null, [v_ctx_272, v_x_273, v_y_274, v_age_275, 0.55, 5.0, v_seed_276, _s61["H"], {"up": 1.1, "floor": v_floor_278}, Callable(self, "_f40").bind(_s61)])

func _f42(this_, a: Array, env):
	var v_c_297 = null; var v_px_298 = null; var v_py_299 = null; var v_i_300 = null; var v_al_301 = null; var v_r_302 = null
	v_c_297 = J.arg(a, 0)
	v_px_298 = J.arg(a, 1)
	v_py_299 = J.arg(a, 2)
	v_i_300 = J.arg(a, 3)
	v_al_301 = J.arg(a, 4)
	v_r_302 = J.arg(a, 5)
	J.mc(v_c_297, "save", [])
	var _t159 = J.mul(J.gp(v_c_297, "globalAlpha"), v_al_301)
	J.sp(v_c_297, "globalAlpha", _t159)
	var _t160 = env["__p"]["crayon"]
	J.cl(_t160, null, [v_c_297, [[v_px_298, v_py_299], [J.add(v_px_298, (J.mul(env["H"], 0.018) * J.sub(v_r_302, 0.5))), J.sub(v_py_299, J.mul(env["H"], 0.022))]], ("#f2cf5a" if J.t(J.mod(v_i_300, 3.0)) else "#c9a23a"), J.max_([1.0, J.mul(env["H"], 0.022)]), J.add(env["seed"], v_i_300)])
	J.mc(v_c_297, "restore", [])

func _f41(this_, a: Array, env):
	var v_ctx_290 = null; var v_x_291 = null; var v_y_292 = null; var v_age_293 = null; var v_dir_296 = null
	var _s63 = {"__p": env, "seed": null, "H": null}
	v_ctx_290 = J.arg(a, 0)
	v_x_291 = J.arg(a, 1)
	v_y_292 = J.arg(a, 2)
	v_age_293 = J.arg(a, 3)
	_s63["seed"] = J.arg(a, 4)
	_s63["H"] = J.arg(a, 5)
	v_dir_296 = J.arg(a, 6)
	var _t158 = _s63["__p"]["spray"]
	J.cl(_t158, null, [v_ctx_290, v_x_291, v_y_292, v_age_293, 0.6, 7.0, _s63["seed"], _s63["H"], {"up": 1.0, "v": 0.8, "dir": (v_dir_296 if J.t(v_dir_296) else 0.0), "spread": 1.4}, Callable(self, "_f42").bind(_s63)])

func _f43(this_, a: Array, env):
	var v_kind_305 = null; var v_img_306 = null; var v_c_307 = null; var v_x_308 = null
	v_kind_305 = J.arg(a, 0)
	v_img_306 = J.gp(J.G.get("SPR"), "fx_dust")
	var _t161 = (not J.t(v_img_306))
	if (_t161 if _t161 else (not J.t(J.gp(v_img_306, "naturalWidth")))):
		return null
	if J.t(J.gp(env["TINT"], v_kind_305)):
		return J.gp(env["TINT"], v_kind_305)
	v_c_307 = J.S_document_("createElement", ["canvas"])
	var _t162 = J.gp(v_img_306, "naturalWidth")
	J.sp(v_c_307, "width", _t162)
	var _t163 = J.gp(v_img_306, "naturalHeight")
	J.sp(v_c_307, "height", _t163)
	v_x_308 = J.mc(v_c_307, "getContext", ["2d"])
	J.mc(v_x_308, "drawImage", [v_img_306, 0.0, 0.0])
	J.sp(v_x_308, "globalCompositeOperation", "source-atop")
	J.sp(v_x_308, "fillStyle", "rgba(165,112,58,.5)")
	J.mc(v_x_308, "fillRect", [0.0, 0.0, J.gp(v_c_307, "width"), J.gp(v_c_307, "height")])
	var _t164 = env["TINT"]
	J.sp(_t164, v_kind_305, v_c_307)
	return v_c_307

func _f44(this_, a: Array, env):
	var v_ctx_311 = null; var v_x_312 = null; var v_y_313 = null; var v_age_314 = null; var v_life_315 = null; var v_w_316 = null; var v_seed_317 = null; var v_tint_318 = null; var v_q_319 = null; var v_img_320 = null; var v_ww_321 = null; var v_hh_322 = null
	v_ctx_311 = J.arg(a, 0)
	v_x_312 = J.arg(a, 1)
	v_y_313 = J.arg(a, 2)
	v_age_314 = J.arg(a, 3)
	v_life_315 = J.arg(a, 4)
	v_w_316 = J.arg(a, 5)
	v_seed_317 = J.arg(a, 6)
	v_tint_318 = J.arg(a, 7)
	var _t165 = J.cmp(v_age_314, 0.0, "<")
	if (_t165 if _t165 else J.cmp(v_age_314, v_life_315, ">")):
		return null
	v_q_319 = J.div(v_age_314, v_life_315)
	var _t167 = null
	if J.seq(v_tint_318, "wood"):
		var _t166 = env["tinted"]
		_t167 = J.cl(_t166, null, ["wood"])
	else:
		_t167 = J.gp(J.G.get("SPR"), "fx_dust")
	v_img_320 = _t167
	var _t168 = (not J.t(v_img_320))
	if (_t168 if _t168 else (not J.t(J.gp(v_img_320, "width")))):
		return null
	J.mc(v_ctx_311, "save", [])
	var _t169 = J.mul(J.gp(v_ctx_311, "globalAlpha"), (J.sub(1.0, v_q_319) * (0.85 if J.seq(v_tint_318, "flour") else (0.6 if J.seq(v_tint_318, "wood") else 0.4))))
	J.sp(v_ctx_311, "globalAlpha", _t169)
	v_ww_321 = J.mul(v_w_316, (0.6 + J.mul(0.7, J.mc(env["E"], "o", [v_q_319]))))
	v_hh_322 = J.div(J.mul(v_ww_321, J.gp(v_img_320, "height")), J.gp(v_img_320, "width"))
	var _t170 = env["rnd"]
	J.mc(v_ctx_311, "translate", [J.add(v_x_312, J.mul((J.mul(J.sub(J.cl(_t170, null, [v_seed_317]), 0.5), v_w_316) * 0.3), v_q_319)), J.sub(v_y_313, J.mul(J.mul(v_w_316, 0.35), v_q_319))])
	var _t171 = env["rnd"]
	if J.cmp(J.cl(_t171, null, [J.add(v_seed_317, 1.0)]), 0.5, "<"):
		J.mc(v_ctx_311, "scale", [(-1.0), 1.0])
	J.mc(v_ctx_311, "drawImage", [v_img_320, J.div((-J.num(v_ww_321)), 2.0), (-J.num(v_hh_322)), v_ww_321, v_hh_322])
	J.mc(v_ctx_311, "restore", [])

func _f45(this_, a: Array, env):
	var v_ctx_325 = null; var v_x_326 = null; var v_y_327 = null; var v_age_328 = null; var v_w_329 = null; var v_img_330 = null; var v_q_331 = null; var v_ww_332 = null
	v_ctx_325 = J.arg(a, 0)
	v_x_326 = J.arg(a, 1)
	v_y_327 = J.arg(a, 2)
	v_age_328 = J.arg(a, 3)
	v_w_329 = J.arg(a, 4)
	var _t172 = J.cmp(v_age_328, 0.0, "<")
	if (_t172 if _t172 else J.cmp(v_age_328, 0.16, ">")):
		return null
	v_img_330 = J.gp(J.G.get("SPR"), "fx_spark")
	var _t173 = (not J.t(v_img_330))
	if (_t173 if _t173 else (not J.t(J.gp(v_img_330, "naturalWidth")))):
		return null
	v_q_331 = J.div(v_age_328, 0.16)
	v_ww_332 = J.mul(v_w_329, (0.5 + J.mul(0.7, J.mc(env["E"], "o", [v_q_331]))))
	J.mc(v_ctx_325, "save", [])
	var _t174 = J.mul(J.gp(v_ctx_325, "globalAlpha"), J.sub(1.0, v_q_331))
	J.sp(v_ctx_325, "globalAlpha", _t174)
	J.mc(v_ctx_325, "translate", [v_x_326, v_y_327])
	J.mc(v_ctx_325, "rotate", [J.mul(v_q_331, 0.6)])
	J.mc(v_ctx_325, "drawImage", [v_img_330, J.div((-J.num(v_ww_332)), 2.0), J.div((-J.num(v_ww_332)), 2.0), v_ww_332, v_ww_332])
	J.mc(v_ctx_325, "restore", [])

func _f46(this_, a: Array, env):
	var v_ctx_335 = null; var v_x_336 = null; var v_y_337 = null; var v_age_338 = null; var v_life_339 = null; var v_H_340 = null; var v_seed_341 = null; var v_n_342 = null; var v_i_343 = null; var v_a0_344 = null; var v_q_345 = null; var v_ox_346 = null; var v_pts_347 = null; var v_j_348 = null; var v_f_349 = null
	v_ctx_335 = J.arg(a, 0)
	v_x_336 = J.arg(a, 1)
	v_y_337 = J.arg(a, 2)
	v_age_338 = J.arg(a, 3)
	v_life_339 = J.arg(a, 4)
	v_H_340 = J.arg(a, 5)
	v_seed_341 = J.arg(a, 6)
	v_n_342 = J.arg(a, 7)
	if J.cmp(v_age_338, 0.0, "<"):
		return null
	v_i_343 = 0.0
	while true:
		if not J.cmp(v_i_343, (v_n_342 if J.t(v_n_342) else 3.0), "<"): break
		v_a0_344 = J.sub(v_age_338, J.mul(v_i_343, 0.18))
		var _t175 = J.cmp(v_a0_344, 0.0, "<")
		if (_t175 if _t175 else J.cmp(v_a0_344, v_life_339, ">")):
			v_i_343 = J.num(v_i_343) + 1.0
			continue
		v_q_345 = J.div(v_a0_344, v_life_339)
		v_ox_346 = (J.mul(J.sub(v_i_343, 1.0), v_H_340) * 0.07)
		v_pts_347 = []
		v_j_348 = 0.0
		while true:
			if not J.cmp(v_j_348, 6.0, "<="): break
			v_f_349 = J.div(v_j_348, 6.0)
			J.mc(v_pts_347, "push", [[J.add(J.add(v_x_336, v_ox_346), J.mul((J.mul(sin(J.num(J.add((J.mul(v_f_349, 5.0) + J.mul(v_a0_344, 4.0)), v_i_343))), v_H_340) * 0.035), J.add(0.4, v_f_349))), (J.sub(v_y_337, J.mul(J.mul(v_H_340, (0.05 + J.mul(0.32, J.mc(env["E"], "o", [v_q_345])))), v_f_349)) - J.mul(J.mul(v_H_340, 0.25), v_q_345))]])
			v_j_348 = J.num(v_j_348) + 1.0
		J.mc(v_ctx_335, "save", [])
		var _t176 = J.mul(J.gp(v_ctx_335, "globalAlpha"), (J.sub(1.0, v_q_345) * 0.8))
		J.sp(v_ctx_335, "globalAlpha", _t176)
		var _t177 = env["crayon"]
		J.cl(_t177, null, [v_ctx_335, v_pts_347, "rgba(240,240,236,.95)", J.max_([1.2, (J.mul(v_H_340, 0.03) * (1.0 - J.mul(v_q_345, 0.5)))]), J.add(v_seed_341, J.mul(v_i_343, 13.0))])
		J.mc(v_ctx_335, "restore", [])
		v_i_343 = J.num(v_i_343) + 1.0

func _f47(this_, a: Array, env):
	var v_ctx_352 = null; var v_x_353 = null; var v_y_354 = null; var v_age_355 = null; var v_H_356 = null; var v_seed_357 = null; var v_i_358 = null; var v_q_359 = null; var v_dir_360 = null; var v_px_361 = null; var v_py_362 = null; var v_r_363 = null
	v_ctx_352 = J.arg(a, 0)
	v_x_353 = J.arg(a, 1)
	v_y_354 = J.arg(a, 2)
	v_age_355 = J.arg(a, 3)
	v_H_356 = J.arg(a, 4)
	v_seed_357 = J.arg(a, 5)
	var _t178 = J.cmp(v_age_355, 0.0, "<")
	if (_t178 if _t178 else J.cmp(v_age_355, 0.7, ">")):
		return null
	v_i_358 = 0.0
	while true:
		if not J.cmp(v_i_358, 2.0, "<"): break
		v_q_359 = J.div(v_age_355, 0.7)
		v_dir_360 = (1.0 if J.t(v_i_358) else (-0.6))
		v_px_361 = J.add(v_x_353, J.mul((J.mul(v_dir_360, v_H_356) * 0.12), v_q_359))
		v_py_362 = (J.sub(v_y_354, (J.mul(v_H_356, 0.08) * sin(J.num(J.mul(v_q_359, PI))))) + J.mul(J.mul(J.mul(v_H_356, 0.12), v_q_359), v_q_359))
		J.mc(v_ctx_352, "save", [])
		var _t179 = J.mul(J.gp(v_ctx_352, "globalAlpha"), (1.0 - J.mul(v_q_359, v_q_359)))
		J.sp(v_ctx_352, "globalAlpha", _t179)
		J.mc(v_ctx_352, "translate", [v_px_361, v_py_362])
		J.mc(v_ctx_352, "rotate", [J.mul(v_dir_360, 0.5)])
		v_r_363 = J.mul(v_H_356, 0.026)
		J.sp(v_ctx_352, "fillStyle", "#bfe6ff")
		J.sp(v_ctx_352, "strokeStyle", "#3a6e96")
		var _t180 = J.max_([0.8, J.mul(v_r_363, 0.35)])
		J.sp(v_ctx_352, "lineWidth", _t180)
		J.mc(v_ctx_352, "beginPath", [])
		J.mc(v_ctx_352, "moveTo", [0.0, ((-J.num(v_r_363)) * 1.7)])
		J.mc(v_ctx_352, "quadraticCurveTo", [J.mul(v_r_363, 1.1), ((-J.num(v_r_363)) * 0.1), 0.0, v_r_363])
		J.mc(v_ctx_352, "quadraticCurveTo", [((-J.num(v_r_363)) * 1.1), ((-J.num(v_r_363)) * 0.1), 0.0, ((-J.num(v_r_363)) * 1.7)])
		J.mc(v_ctx_352, "fill", [])
		J.mc(v_ctx_352, "stroke", [])
		J.mc(v_ctx_352, "restore", [])
		v_i_358 = J.num(v_i_358) + 1.0

func _f48(this_, a: Array, env):
	var v_ctx_366 = null; var v_x_367 = null; var v_y_368 = null; var v_H_369 = null; var v_rot_370 = null; var v_alpha_371 = null; var v_r_372 = null
	v_ctx_366 = J.arg(a, 0)
	v_x_367 = J.arg(a, 1)
	v_y_368 = J.arg(a, 2)
	v_H_369 = J.arg(a, 3)
	v_rot_370 = J.arg(a, 4)
	v_alpha_371 = J.arg(a, 5)
	v_r_372 = J.mul(v_H_369, 0.045)
	J.mc(v_ctx_366, "save", [])
	if (not J.leq(v_alpha_371, null)):
		var _t181 = env["cl"]
		var _t182 = J.mul(J.gp(v_ctx_366, "globalAlpha"), J.cl(_t181, null, [v_alpha_371]))
		J.sp(v_ctx_366, "globalAlpha", _t182)
	J.mc(v_ctx_366, "translate", [v_x_367, v_y_368])
	J.mc(v_ctx_366, "scale", [J.max_([0.15, absf(J.num(cos(J.num((v_rot_370 if J.t(v_rot_370) else 0.0)))))]), 1.0])
	J.sp(v_ctx_366, "fillStyle", "#f0c24a")
	J.sp(v_ctx_366, "strokeStyle", "#6b4a12")
	var _t183 = J.max_([0.8, J.mul(v_r_372, 0.28)])
	J.sp(v_ctx_366, "lineWidth", _t183)
	J.mc(v_ctx_366, "beginPath", [])
	J.mc(v_ctx_366, "arc", [0.0, 0.0, v_r_372, 0.0, env["TAU"]])
	J.mc(v_ctx_366, "fill", [])
	J.mc(v_ctx_366, "stroke", [])
	J.sp(v_ctx_366, "fillStyle", "#6b4a12")
	J.mc(v_ctx_366, "fillRect", [((-J.num(v_r_372)) * 0.28), ((-J.num(v_r_372)) * 0.28), J.mul(v_r_372, 0.56), J.mul(v_r_372, 0.56)])
	J.sp(v_ctx_366, "fillStyle", "rgba(255,250,210,.8)")
	J.mc(v_ctx_366, "beginPath", [])
	J.mc(v_ctx_366, "arc", [((-J.num(v_r_372)) * 0.45), ((-J.num(v_r_372)) * 0.45), J.mul(v_r_372, 0.22), 0.0, env["TAU"]])
	J.mc(v_ctx_366, "fill", [])
	J.mc(v_ctx_366, "restore", [])

func _f49(this_, a: Array, env):
	var v_ctx_375 = null; var v_x_376 = null; var v_y_377 = null; var v_H_378 = null; var v_alpha_379 = null; var v_r_380 = null
	v_ctx_375 = J.arg(a, 0)
	v_x_376 = J.arg(a, 1)
	v_y_377 = J.arg(a, 2)
	v_H_378 = J.arg(a, 3)
	v_alpha_379 = J.arg(a, 4)
	v_r_380 = J.mul(v_H_378, 0.045)
	J.mc(v_ctx_375, "save", [])
	if (not J.leq(v_alpha_379, null)):
		var _t184 = env["cl"]
		var _t185 = J.mul(J.gp(v_ctx_375, "globalAlpha"), J.cl(_t184, null, [v_alpha_379]))
		J.sp(v_ctx_375, "globalAlpha", _t185)
	J.sp(v_ctx_375, "fillStyle", "#d9a83a")
	J.sp(v_ctx_375, "strokeStyle", "#6b4a12")
	var _t186 = J.max_([0.8, J.mul(v_r_380, 0.25)])
	J.sp(v_ctx_375, "lineWidth", _t186)
	J.mc(v_ctx_375, "beginPath", [])
	J.mc(v_ctx_375, "ellipse", [v_x_376, v_y_377, v_r_380, J.mul(v_r_380, 0.38), 0.0, 0.0, env["TAU"]])
	J.mc(v_ctx_375, "fill", [])
	J.mc(v_ctx_375, "stroke", [])
	J.sp(v_ctx_375, "fillStyle", "rgba(255,240,180,.7)")
	J.mc(v_ctx_375, "beginPath", [])
	J.mc(v_ctx_375, "ellipse", [J.sub(v_x_376, J.mul(v_r_380, 0.3)), J.sub(v_y_377, J.mul(v_r_380, 0.08)), J.mul(v_r_380, 0.35), J.mul(v_r_380, 0.1), 0.0, 0.0, env["TAU"]])
	J.mc(v_ctx_375, "fill", [])
	J.mc(v_ctx_375, "restore", [])

func _f50(this_, a: Array, env):
	var v_ctx_383 = null; var v_x_384 = null; var v_y_385 = null; var v_age_386 = null; var v_H_387 = null; var v_seed_388 = null; var v_q_389 = null
	v_ctx_383 = J.arg(a, 0)
	v_x_384 = J.arg(a, 1)
	v_y_385 = J.arg(a, 2)
	v_age_386 = J.arg(a, 3)
	v_H_387 = J.arg(a, 4)
	v_seed_388 = J.arg(a, 5)
	var _t187 = J.cmp(v_age_386, 0.0, "<")
	if (_t187 if _t187 else J.cmp(v_age_386, 0.45, ">")):
		return null
	v_q_389 = J.div(v_age_386, 0.45)
	J.mc(J.G.get("MoveKit"), "burst", [v_ctx_383, v_x_384, v_y_385, J.mul(v_H_387, 0.12), J.sub(1.0, v_q_389), "#ffe9a0", v_seed_388, 6.0])

func _f51(this_, a: Array, env):
	var v_ctx_392 = null; var v_x_393 = null; var v_y_394 = null; var v_age_395 = null; var v_life_396 = null; var v_H_397 = null; var v_seed_398 = null; var v_q_399 = null; var v_k_400 = null; var v_i_401 = null; var v_ox_402 = null; var v_hh_403 = null; var v_sw_404 = null
	v_ctx_392 = J.arg(a, 0)
	v_x_393 = J.arg(a, 1)
	v_y_394 = J.arg(a, 2)
	v_age_395 = J.arg(a, 3)
	v_life_396 = J.arg(a, 4)
	v_H_397 = J.arg(a, 5)
	v_seed_398 = J.arg(a, 6)
	var _t188 = J.cmp(v_age_395, 0.0, "<")
	if (_t188 if _t188 else J.cmp(v_age_395, v_life_396, ">")):
		return null
	v_q_399 = J.div(v_age_395, v_life_396)
	v_k_400 = (sin(J.num(((J.min_([1.0, J.mul(v_q_399, 2.2)]) * PI) * 0.5))) * J.sub(1.0, J.mc(env["E"], "i", [v_q_399])))
	v_i_401 = 0.0
	while true:
		if not J.cmp(v_i_401, 4.0, "<"): break
		v_ox_402 = (J.mul(J.sub(v_i_401, 1.5), v_H_397) * 0.05)
		var _t189 = env["rnd"]
		v_hh_403 = J.mul(J.mul(v_H_397, (0.12 + J.mul(0.12, J.cl(_t189, null, [J.add(v_seed_398, v_i_401)])))), v_k_400)
		v_sw_404 = (J.mul(sin(J.num((J.mul(v_age_395, 25.0) + J.mul(v_i_401, 2.0)))), v_H_397) * 0.02)
		var _t190 = env["crayon"]
		J.cl(_t190, null, [v_ctx_392, [[J.add(v_x_393, v_ox_402), v_y_394], [J.add(J.add(v_x_393, J.mul(v_ox_402, 1.2)), v_sw_404), J.sub(v_y_394, J.mul(v_hh_403, 0.6))], [J.sub(J.add(v_x_393, J.mul(v_ox_402, 0.6)), v_sw_404), J.sub(v_y_394, v_hh_403)]], ("#ffb43a" if J.t(J.mod(v_i_401, 2.0)) else "#ff6a2a"), J.max_([1.2, J.mul(J.mul(v_H_397, 0.035), v_k_400)]), J.add(v_seed_398, J.mul(v_i_401, 7.0))])
		v_i_401 = J.num(v_i_401) + 1.0
	var _t191 = env["spark"]
	J.cl(_t191, null, [v_ctx_392, v_x_393, J.sub(v_y_394, J.mul(v_H_397, 0.08)), v_age_395, J.mul(v_H_397, 0.22)])

func _f52(this_, a: Array, env):
	var v_ctx_407 = null; var v_from_408 = null; var v_to_409 = null; var v_H_410 = null; var v_seed_411 = null; var v_alpha_412 = null; var v_mx_413 = null; var v_my_414 = null; var v_pts_415 = null; var v_j_416 = null; var v_f_417 = null; var v_x_418 = null; var v_y_419 = null
	v_ctx_407 = J.arg(a, 0)
	v_from_408 = J.arg(a, 1)
	v_to_409 = J.arg(a, 2)
	v_H_410 = J.arg(a, 3)
	v_seed_411 = J.arg(a, 4)
	v_alpha_412 = J.arg(a, 5)
	J.mc(v_ctx_407, "save", [])
	var _t192 = env["cl"]
	var _t193 = J.mul(J.gp(v_ctx_407, "globalAlpha"), J.mul(0.45, J.cl(_t192, null, [(1.0 if J.leq(v_alpha_412, null) else v_alpha_412)])))
	J.sp(v_ctx_407, "globalAlpha", _t193)
	v_mx_413 = J.div(J.add(J.gp(v_from_408, 0.0), J.gp(v_to_409, 0.0)), 2.0)
	v_my_414 = (J.min_([J.gp(v_from_408, 1.0), J.gp(v_to_409, 1.0)]) - J.mul(v_H_410, 0.08))
	v_pts_415 = []
	v_j_416 = 0.0
	while true:
		if not J.cmp(v_j_416, 8.0, "<="): break
		v_f_417 = J.div(v_j_416, 8.0)
		v_x_418 = ((J.mul((J.sub(1.0, v_f_417) * J.sub(1.0, v_f_417)), J.gp(v_from_408, 0.0)) + J.mul(J.mul((2.0 * J.sub(1.0, v_f_417)), v_f_417), v_mx_413)) + J.mul(J.mul(v_f_417, v_f_417), J.gp(v_to_409, 0.0)))
		v_y_419 = ((J.mul((J.sub(1.0, v_f_417) * J.sub(1.0, v_f_417)), J.gp(v_from_408, 1.0)) + J.mul(J.mul((2.0 * J.sub(1.0, v_f_417)), v_f_417), v_my_414)) + J.mul(J.mul(v_f_417, v_f_417), J.gp(v_to_409, 1.0)))
		J.mc(v_pts_415, "push", [[v_x_418, J.add(v_y_419, (J.mul(sin(J.num(J.add(J.mul(v_f_417, 9.0), v_seed_411))), v_H_410) * 0.01))]])
		v_j_416 = J.num(v_j_416) + 1.0
	var _t194 = env["crayon"]
	J.cl(_t194, null, [v_ctx_407, v_pts_415, "rgba(160,230,220,.9)", J.max_([1.0, J.mul(v_H_410, 0.02)]), v_seed_411])
	J.mc(v_ctx_407, "restore", [])

func _f53(this_, a: Array, env):
	var v_ctx_422 = null; var v_x_423 = null; var v_y_424 = null; var v_H_425 = null; var v_k_426 = null; var v_seed_427 = null
	v_ctx_422 = J.arg(a, 0)
	v_x_423 = J.arg(a, 1)
	v_y_424 = J.arg(a, 2)
	v_H_425 = J.arg(a, 3)
	v_k_426 = J.arg(a, 4)
	v_seed_427 = J.arg(a, 5)
	if J.cmp(v_k_426, 0.0, "<="):
		return null
	J.mc(v_ctx_422, "save", [])
	var _t195 = env["cl"]
	var _t196 = J.mul(J.gp(v_ctx_422, "globalAlpha"), J.cl(_t195, null, [v_k_426]))
	J.sp(v_ctx_422, "globalAlpha", _t196)
	var _t197 = env["crayon"]
	J.cl(_t197, null, [v_ctx_422, [[v_x_423, J.sub(v_y_424, J.mul(v_H_425, 0.16))], [J.add(v_x_423, J.mul(v_H_425, 0.01)), J.sub(v_y_424, J.mul(v_H_425, 0.05))]], "#ffe27a", J.max_([1.5, J.mul(v_H_425, 0.04)]), v_seed_427])
	var _t198 = env["crayon"]
	J.cl(_t198, null, [v_ctx_422, [[J.add(v_x_423, J.mul(v_H_425, 0.012)), J.sub(v_y_424, J.mul(v_H_425, 0.012))], [J.add(v_x_423, J.mul(v_H_425, 0.014)), v_y_424]], "#ffe27a", J.max_([1.5, J.mul(v_H_425, 0.045)]), J.add(v_seed_427, 3.0)])
	J.mc(v_ctx_422, "restore", [])

func _f55(this_, a: Array, env):
	var v_R_431 = null; var v_p_432 = null
	v_R_431 = J.arg(a, 0)
	v_p_432 = J.arg(a, 1)
	if J.t(J.gp(v_R_431, "arm")):
		var _t199 = env["kf"]
		return J.cl(_t199, null, [[[0.0, {"ang": 45.0}], [0.36, {"ang": (-76.0), "hy": (-0.07), "hx": (-0.03), "lean": (-8.0), "dx": (-0.03), "dy": (-0.02), "sy": 1.05, "sx": 0.96, "bend": (-6.0), "head": (-6.0)}, "o"], [0.5, {"ang": (-84.0), "hy": (-0.075), "hx": (-0.035), "lean": (-9.0), "dx": (-0.035), "dy": (-0.025), "sy": 1.06, "sx": 0.955, "bend": (-7.0), "head": (-8.0)}, "io"], [0.6, {"ang": 94.0, "hy": 0.03, "hx": 0.05, "lean": 11.0, "dx": 0.05, "sx": 1.05, "sy": 0.95, "bend": 14.0, "head": 6.0}, "i3"], [0.76, {"ang": 92.0, "hy": 0.03, "hx": 0.05, "lean": 10.0, "dx": 0.05, "sx": 1.02, "sy": 0.98, "bend": 13.0, "head": 5.0}, "o"], [1.0, {"ang": 45.0}, "io"]], v_p_432])
	var _t200 = env["kf"]
	return J.cl(_t200, null, [[[0.0, {}], [0.3, {"sy": 0.86, "sx": 1.1, "lean": (-4.0)}, "o"], [0.5, {"dy": (-0.36), "dx": 0.22, "sy": 1.1, "sx": 0.93, "lean": 8.0}, "o"], [0.6, {"dy": (-0.2), "dx": 0.4, "sy": 0.8, "sx": 1.2, "lean": 4.0}, "i3"], [0.72, {"dy": (-0.2), "dx": 0.4, "sy": 0.9, "sx": 1.1}, "o"], [0.86, {"dy": (-0.3), "dx": 0.22, "sy": 1.05, "sx": 0.96}, "o"], [1.0, {}, "io"]], v_p_432])

func _f56(this_, a: Array, env):
	var v_R_435 = null; var v_k_436 = null; var v_ang0_437 = null
	v_R_435 = J.arg(a, 0)
	v_k_436 = J.arg(a, 1)
	v_ang0_437 = J.arg(a, 2)
	if J.t(J.gp(v_R_435, "arm")):
		var _t201 = J.add(J.gp(v_k_436, "hr"), (J.sub(J.gp(v_k_436, "ang"), v_ang0_437) * (0.55 if J.t(J.gp(v_R_435, "long")) else 0.2)))
		J.sp(v_k_436, "hr", _t201)
	return v_k_436

func _f64(this_, a: Array, env):
	var v_v_480 = null
	v_v_480 = J.arg(a, 0)
	var _t202 = env["__p"]["sp"]
	return J.div(5.2, J.cl(_t202, null, [v_v_480]))

func _f66(this_, a: Array, env):
	var v_P_503 = null
	v_P_503 = J.arg(a, 0)
	return ([J.gp(J.gp(v_P_503, "G"), 0.0), J.sub(J.gp(J.gp(v_P_503, "G"), 1.0), J.mul(0.02, env["H"]))] if J.t(env["armC"]) else [J.gp(J.gp(v_P_503, "top"), 0.0), J.add(J.gp(J.gp(v_P_503, "top"), 1.0), J.mul(0.02, env["H"]))])

func _f67(this_, a: Array, env):
	var v_ctx_504 = null; var v_P_505 = null; var v_al_506 = null
	v_ctx_504 = J.arg(a, 0)
	v_P_505 = J.arg(a, 1)
	var _t223 = env["__p"]["__p"]["prop"]
	J.cl(_t223, null, [v_ctx_504, env["__p"]["pileKey"], env["pileX"], 0.5, J.mul(env["pw"], 1.05), 0.0, {"an": [0.5, 1.0]}])
	var _t224 = env["__p"]["__p"]["prop"]
	J.cl(_t224, null, [v_ctx_504, env["__p"]["pileKey"], J.sub(env["pileX"], J.mul(0.06, env["H"])), ((-J.num(env["ph"])) * 0.72), J.mul(env["pw"], 0.95), (4.0 if J.seq(env["__p"]["pileKey"], "wood__log") else (-3.0)), {"an": [0.5, 1.0]}])
	if J.cmp(env["t"], 3.3, ">"):
		var _t225 = env["__p"]["__p"]["seg"]
		v_al_506 = J.sub(1.0, J.cl(_t225, null, [env["t"], 4.6, 5.0]))
		var _t226 = env["__p"]["__p"]["prop"]
		J.cl(_t226, null, [v_ctx_504, env["__p"]["key"], J.add(env["pileX"], J.mul(0.05, env["H"])), J.sub(env["pileTop"], J.mul(env["ph"], 0.62)), J.mul(env["pw"], 0.9), ((-5.0) if J.seq(env["__p"]["pileKey"], "wood__log") else 2.0), {"an": [0.5, 1.0], "alpha": v_al_506}])
	if J.cmp(env["t"], 0.62, "<"):
		var _t227 = env["__p"]["__p"]["prop"]
		J.cl(_t227, null, [v_ctx_504, env["__p"]["key"], env["gx"], 0.5, env["pw"], 0.0, {"an": [0.5, 1.0]}])
	if J.cmp(env["t"], 4.6, ">"):
		var _t228 = env["__p"]["__p"]["prop"]
		var _t231 = env["__p"]["key"]
		var _t232 = env["gx"]
		var _t230 = env["pw"]
		var _t229 = env["__p"]["__p"]["seg"]
		J.cl(_t228, null, [v_ctx_504, _t231, _t232, 0.5, J.mul(_t230, J.mc(env["__p"]["__p"]["E"], "back", [J.cl(_t229, null, [env["t"], 4.6, 5.0])])), 0.0, {"an": [0.5, 1.0]}])

func _f68(this_, a: Array, env):
	var v_ctx_507 = null; var v_P_508 = null; var v_q_509 = null; var v_tp_510 = null; var v_from_511 = null; var v_x_512 = null; var v_y_513 = null; var v_q_514 = null; var v_tp_515 = null; var v_to_516 = null
	v_ctx_507 = J.arg(a, 0)
	v_P_508 = J.arg(a, 1)
	var _t234 = J.cmp(env["t"], 0.62, ">=")
	if (J.cmp(env["t"], 3.05, "<") if _t234 else _t234):
		var _t235 = env["__p"]["__p"]["seg"]
		v_q_509 = J.mc(env["__p"]["__p"]["E"], "io", [J.cl(_t235, null, [env["t"], 0.62, 0.95])])
		var _t236 = env["pick"]
		v_tp_510 = J.cl(_t236, null, [v_P_508])
		v_from_511 = [env["gx"], 0.0]
		var _t237 = env["__p"]["__p"]["lerp"]
		v_x_512 = J.cl(_t237, null, [J.gp(v_from_511, 0.0), J.gp(v_tp_510, 0.0), v_q_509])
		var _t238 = env["__p"]["__p"]["lerp"]
		v_y_513 = J.sub(J.cl(_t238, null, [J.gp(v_from_511, 1.0), J.gp(v_tp_510, 1.0), v_q_509]), J.mul((sin(J.num(J.mul(v_q_509, PI))) * 0.12), env["H"]))
		var _t239 = env["__p"]["__p"]["prop"]
		J.cl(_t239, null, [v_ctx_507, env["__p"]["key"], v_x_512, v_y_513, env["pw"], (((1.0 if J.cmp(env["face"], 0.0, "<") else (-1.0)) * sin(J.num(J.mul(env["t"], 6.0)))) * 1.5), {"an": [0.5, 1.0]}])
		var _t241 = (not J.t(J.gp(env["R"], "arm")))
		if not J.t(_t241):
			var _t240 = J.gp(env["R"], "special")
			_t241 = ((not J.t(env["armC"])) if J.t(_t240) else _t240)
		if J.t(_t241):
			pass
	else:
		var _t242 = J.cmp(env["t"], 3.05, ">=")
		if (J.cmp(env["t"], 3.3, "<") if _t242 else _t242):
			var _t243 = env["__p"]["__p"]["seg"]
			v_q_514 = J.cl(_t243, null, [env["t"], 3.05, 3.3])
			var _t244 = env["pick"]
			v_tp_515 = J.cl(_t244, null, [v_P_508])
			v_to_516 = [J.add(env["pileX"], J.mul(0.05, env["H"])), J.sub(env["pileTop"], J.mul(env["ph"], 0.62))]
			var _t245 = env["__p"]["__p"]["prop"]
			var _t247 = env["__p"]["key"]
			var _t246 = env["__p"]["__p"]["lerp"]
			var _t249 = J.cl(_t246, null, [J.gp(v_tp_515, 0.0), J.gp(v_to_516, 0.0), J.mc(env["__p"]["__p"]["E"], "o", [v_q_514])])
			var _t248 = env["__p"]["__p"]["lerp"]
			J.cl(_t245, null, [v_ctx_507, _t247, _t249, J.sub(J.cl(_t248, null, [J.gp(v_tp_515, 1.0), J.gp(v_to_516, 1.0), J.mc(env["__p"]["__p"]["E"], "i", [v_q_514])]), J.mul((sin(J.num(J.mul(v_q_514, PI))) * 0.15), env["H"])), J.mul(env["pw"], 0.95), ((-J.num(v_q_514)) * 12.0), {"an": [0.5, 1.0]}])
	var _t250 = env["__p"]["__p"]["puff"]
	J.cl(_t250, null, [v_ctx_507, env["pileX"], J.mul(env["pileTop"], 0.4), J.sub(env["t"], 3.3), 0.5, J.mul(0.35, env["H"]), J.add(3.0, J.gp(env["v"], "seed")), ("wood" if J.seq(env["__p"]["key"], "wood__log") else null)])
	var _t251 = env["__p"]["__p"]["puff"]
	J.cl(_t251, null, [v_ctx_507, env["gx"], 0.0, J.sub(env["t"], 0.6), 0.45, J.mul(0.25, env["H"]), J.add(9.0, J.gp(env["v"], "seed"))])

func _f65(this_, a: Array, env):
	var v_a_483 = null; var v_at_485 = null; var v_s_487 = null; var v_k_491 = null; var v_ox_493 = null; var v_walk_494 = null; var v_X1_495 = null; var v_fr_500 = null
	var _s103 = {"__p": env, "R": null, "v": null, "t": null, "H": null, "armC": null, "face": null, "pw": null, "ph": null, "pileX": null, "gx": null, "pick": null, "pileTop": null}
	v_a_483 = J.arg(a, 0)
	_s103["R"] = J.arg(a, 1)
	v_at_485 = J.arg(a, 2)
	_s103["v"] = J.arg(a, 3)
	var _t203 = _s103["__p"]["__p"]["sp"]
	v_s_487 = J.cl(_t203, null, [_s103["v"]])
	_s103["t"] = J.mul(v_at_485, v_s_487)
	_s103["H"] = J.gp(v_a_483, "H")
	var _t204 = (not (not J.t(J.gp(_s103["__p"]["__p"]["ARMCARRY"], J.gp(_s103["R"], "id")))))
	_s103["armC"] = (J.gp(_s103["R"], "arm") if _t204 else _t204)
	var _t205 = _s103["__p"]["__p"]["kf"]
	v_k_491 = J.cl(_t205, null, [[[0.0, {}], [0.5, {"bend": 34.0, "lean": 8.0, "head": 10.0, "sy": 0.96, "hy": 0.05}, "io"], [0.62, {"bend": 30.0, "lean": 6.0, "sy": 0.88, "sx": 1.08, "hy": 0.05}, "o"], [0.9, {"bend": (-4.0), "lean": (-3.0), "sy": 1.06, "sx": 0.96, "hy": (0.0 if J.t(_s103["armC"]) else (-0.03))}, "o"], [1.1, {"sy": 0.93, "sx": 1.05, "hy": (0.0 if J.t(_s103["armC"]) else (-0.03))}, "io"], [1.3, {"sy": 0.96, "sx": 1.02}], [2.75, {"sy": 0.96, "sx": 1.02}], [2.9, {"lean": (-6.0), "sy": 1.02}, "o"], [3.05, {"lean": 12.0, "sy": 0.95, "sx": 1.04}, "i"], [3.3, {}, "io"]], _s103["t"]])
	_s103["face"] = 1.0
	v_ox_493 = 0.0
	v_walk_494 = 0.0
	var _t206 = J.cmp(_s103["t"], 1.15, ">")
	if (J.cmp(_s103["t"], 3.35, "<") if _t206 else _t206):
		_s103["face"] = (-1.0)
	v_X1_495 = (-0.62)
	var _t207 = J.cmp(_s103["t"], 1.3, ">")
	if (J.cmp(_s103["t"], 2.7, "<") if _t207 else _t207):
		var _t208 = _s103["__p"]["__p"]["lerp"]
		var _t209 = _s103["__p"]["__p"]["seg"]
		var _t210 = J.cl(_t208, null, [0.0, v_X1_495, J.mc(_s103["__p"]["__p"]["E"], "sin", [J.cl(_t209, null, [_s103["t"], 1.3, 2.7])])])
		v_ox_493 = _t210
		v_walk_494 = _s103["t"]
	else:
		var _t211 = J.cmp(_s103["t"], 2.7, ">=")
		if (J.cmp(_s103["t"], 3.5, "<") if _t211 else _t211):
			v_ox_493 = v_X1_495
		else:
			var _t212 = J.cmp(_s103["t"], 3.5, ">=")
			if (J.cmp(_s103["t"], 4.9, "<") if _t212 else _t212):
				var _t213 = _s103["__p"]["__p"]["lerp"]
				var _t214 = _s103["__p"]["__p"]["seg"]
				var _t215 = J.cl(_t213, null, [v_X1_495, 0.0, J.mc(_s103["__p"]["__p"]["E"], "sin", [J.cl(_t214, null, [_s103["t"], 3.5, 4.9])])])
				v_ox_493 = _t215
				v_walk_494 = _s103["t"]
	var _t216 = J.cmp(_s103["t"], 1.1, ">")
	if (J.cmp(_s103["t"], 1.3, "<") if _t216 else _t216):
		var _t217 = _s103["__p"]["__p"]["add"]
		var _t218 = _s103["__p"]["__p"]["seg"]
		J.cl(_t217, null, [v_k_491, {"sy": (1.0 - (0.05 * sin(J.num(J.mul(J.cl(_t218, null, [_s103["t"], 1.1, 1.3]), PI)))))}])
	var _t219 = J.cmp(_s103["t"], 3.3, ">")
	if (J.cmp(_s103["t"], 3.5, "<") if _t219 else _t219):
		var _t220 = _s103["__p"]["__p"]["add"]
		var _t221 = _s103["__p"]["__p"]["seg"]
		J.cl(_t220, null, [v_k_491, {"sy": (1.0 - (0.04 * sin(J.num(J.mul(J.cl(_t221, null, [_s103["t"], 3.3, 3.5]), PI)))))}])
	_s103["pw"] = J.mul(_s103["__p"]["w"], _s103["H"])
	var _t222 = _s103["__p"]["__p"]["propH"]
	_s103["ph"] = J.cl(_t222, null, [_s103["__p"]["key"], _s103["pw"]])
	_s103["pileX"] = J.mul(J.sub(v_X1_495, 0.42), _s103["H"])
	_s103["gx"] = J.mul(0.3, _s103["H"])
	v_fr_500 = {"k": v_k_491, "face": _s103["face"], "ox": v_ox_493, "walk": (J.mul(v_walk_494, 1.0) if J.t(v_walk_494) else 0.0)}
	_s103["pick"] = Callable(self, "_f66").bind(_s103)
	_s103["pileTop"] = (((-J.num(_s103["ph"])) * 0.72) * (1.25 if J.seq(_s103["__p"]["pileKey"], "store__crate") else 1.0))
	var _t233 = Callable(self, "_f67").bind(_s103)
	J.sp(v_fr_500, "back", _t233)
	var _t252 = Callable(self, "_f68").bind(_s103)
	J.sp(v_fr_500, "front", _t252)
	return v_fr_500

func _f63(this_, a: Array, env):
	var _s101 = {"__p": env, "key": null, "w": null, "pileKey": null}
	_s101["key"] = J.arg(a, 0)
	_s101["w"] = J.arg(a, 1)
	_s101["pileKey"] = J.arg(a, 2)
	return {"dur": Callable(self, "_f64").bind(_s101), "f": Callable(self, "_f65").bind(_s101)}

func _f72(this_, a: Array, env):
	var v_R_533 = null; var v_p_534 = null
	v_R_533 = J.arg(a, 0)
	v_p_534 = J.arg(a, 1)
	if J.t(J.gp(v_R_533, "arm")):
		var _t253 = env["kf"]
		return J.cl(_t253, null, [[[0.0, {"bend": 28.0, "lean": 8.0, "head": 8.0, "ang": 120.0, "hx": 0.05, "hy": 0.04}], [0.4, {"bend": 32.0, "lean": 10.0, "head": 10.0, "ang": 150.0, "hx": 0.08, "hy": 0.06, "sy": 0.97}, "o"], [0.58, {"bend": 26.0, "lean": 6.0, "head": 6.0, "ang": 205.0, "hx": (-0.03), "hy": 0.05, "sy": 0.95, "sx": 1.04}, "i3"], [0.72, {"bend": 25.0, "lean": 5.0, "head": 6.0, "ang": 210.0, "hx": (-0.035), "hy": 0.04}, "o"], [1.0, {"bend": 28.0, "lean": 8.0, "head": 8.0, "ang": 120.0, "hx": 0.05, "hy": 0.04}, "io"]], v_p_534])
	var _t254 = env["kf"]
	return J.cl(_t254, null, [[[0.0, {"bend": 20.0, "lean": 10.0, "head": 10.0}], [0.4, {"bend": 34.0, "lean": 16.0, "head": 16.0, "sy": 0.94, "dx": 0.03}, "o"], [0.58, {"bend": 14.0, "lean": 2.0, "head": (-6.0), "sy": 1.04, "dx": (-0.02)}, "i3"], [0.75, {"bend": 16.0, "lean": 6.0, "head": 4.0}, "o"], [1.0, {"bend": 20.0, "lean": 10.0, "head": 10.0}, "io"]], v_p_534])

func _f79(this_, a: Array, env):
	var v_R_588 = null; var v_p_589 = null
	v_R_588 = J.arg(a, 0)
	v_p_589 = J.arg(a, 1)
	if J.t(J.gp(v_R_588, "arm")):
		var _t255 = env["kf"]
		return J.cl(_t255, null, [[[0.0, {"bend": 12.0, "lean": 4.0, "ang": 60.0}], [0.18, {"bend": 13.0, "lean": 5.0, "ang": 10.0, "hy": (-0.02)}, "o"], [0.26, {"bend": 15.0, "lean": 6.0, "ang": 98.0, "hy": 0.01}, "i"], [0.36, {"bend": 13.0, "lean": 5.0, "ang": 15.0, "hy": (-0.02)}, "o"], [0.44, {"bend": 15.0, "lean": 6.0, "ang": 98.0, "hy": 0.01}, "i"], [0.85, {"bend": 2.0, "lean": (-6.0), "ang": (-62.0), "hy": (-0.07), "hx": (-0.02), "dy": (-0.02), "sy": 1.05, "sx": 0.97, "head": (-6.0)}, "o"], [0.98, {"bend": 1.0, "lean": (-7.0), "ang": (-70.0), "hy": (-0.075), "hx": (-0.025), "dy": (-0.025), "sy": 1.06, "sx": 0.96, "head": (-8.0)}], [1.08, {"bend": 18.0, "lean": 9.0, "ang": 100.0, "hy": 0.02, "hx": 0.03, "sy": 0.94, "sx": 1.05, "head": 8.0}, "i3"], [1.25, {"bend": 17.0, "lean": 8.0, "ang": 98.0, "hy": 0.02, "hx": 0.03, "sy": 0.97, "sx": 1.02, "head": 6.0}, "o"], [1.6, {"bend": 12.0, "lean": 4.0, "ang": 60.0}, "io"]], v_p_589])
	var _t256 = env["kf"]
	return J.cl(_t256, null, [[[0.0, {"bend": 10.0}], [0.18, {"bend": 4.0, "dy": (-0.04)}, "o"], [0.26, {"bend": 20.0, "lean": 8.0, "sy": 0.95}, "i"], [0.36, {"bend": 4.0, "dy": (-0.04)}, "o"], [0.44, {"bend": 20.0, "lean": 8.0, "sy": 0.95}, "i"], [0.85, {"bend": (-8.0), "lean": (-10.0), "dy": (-0.08), "sy": 1.08, "sx": 0.95}, "o"], [0.98, {"bend": (-9.0), "lean": (-11.0), "dy": (-0.09), "sy": 1.09, "sx": 0.94}], [1.08, {"bend": 28.0, "lean": 16.0, "sy": 0.88, "sx": 1.1, "dx": 0.04}, "i3"], [1.25, {"bend": 26.0, "lean": 14.0, "sy": 0.93, "sx": 1.05, "dx": 0.04}, "o"], [1.6, {"bend": 10.0}, "io"]], v_p_589])

func _f82(this_, a: Array, env):
	var _t258 = env["__p"]["hamRot"]
	var _t260 = env["R"]
	var _t259 = env["__p"]["hammerKeys"]
	return {"k": J.cl(_t258, null, [_t260, J.cl(_t259, null, [env["R"], 1.08])]), "tool": "mallet"}

func _f81(this_, a: Array, env):
	var v_a_594 = null; var v_H_596 = null; var v_A_597 = null
	var _s137 = {"__p": env, "R": null}
	v_a_594 = J.arg(a, 0)
	_s137["R"] = J.arg(a, 1)
	v_H_596 = J.gp(v_a_594, "H")
	var _t257 = _s137["__p"]["aim"]
	v_A_597 = J.cl(_t257, null, [v_a_594, "hammer", Callable(self, "_f82").bind(_s137)])
	if J.t(J.gp(_s137["R"], "arm")):
		var _t261 = _s137["__p"]["cl"]
		var _t263 = J.cl(_t261, null, [J.add(J.gp(J.gp(v_A_597, "tip"), 0.0), J.mul(0.04, v_H_596)), J.mul(0.42, v_H_596), J.mul(0.75, v_H_596)])
		var _t262 = _s137["__p"]["cl"]
		return {"x": _t263, "top": J.cl(_t262, null, [((-J.num(J.gp(J.gp(v_A_597, "tip"), 1.0))) - J.mul(0.06, v_H_596)), J.mul(0.14, v_H_596), J.mul(0.42, v_H_596)])}
	var _t264 = _s137["__p"]["cl"]
	var _t266 = J.cl(_t264, null, [J.add(J.gp(J.gp(v_A_597, "mouth"), 0.0), J.mul(0.12, v_H_596)), J.mul(0.42, v_H_596), J.mul(0.75, v_H_596)])
	var _t265 = _s137["__p"]["cl"]
	return {"x": _t266, "top": J.cl(_t265, null, [((-J.num(J.gp(J.gp(v_A_597, "mouth"), 1.0))) - J.mul(0.1, v_H_596)), J.mul(0.14, v_H_596), J.mul(0.4, v_H_596)])}

func _f83(this_, a: Array, env):
	var v_ctx_600 = null; var v_B_601 = null; var v_H_602 = null; var v_shake_603 = null; var v_plankLift_604 = null; var v_cw_605 = null; var v_chH_606 = null; var v_sc_607 = null
	v_ctx_600 = J.arg(a, 0)
	v_B_601 = J.arg(a, 1)
	v_H_602 = J.arg(a, 2)
	v_shake_603 = J.arg(a, 3)
	v_plankLift_604 = J.arg(a, 4)
	v_cw_605 = J.mul(0.2, v_H_602)
	var _t267 = env["propH"]
	v_chH_606 = J.cl(_t267, null, ["store__crate", v_cw_605])
	v_sc_607 = J.div(J.gp(v_B_601, "top"), J.mul(v_chH_606, 0.92))
	var _t268 = env["prop"]
	J.cl(_t268, null, [v_ctx_600, "store__crate", J.sub(J.gp(v_B_601, "x"), J.mul(0.2, v_H_602)), 0.5, J.mul(v_cw_605, J.min_([1.4, v_sc_607])), 0.0, {"an": [0.5, 1.0], "sy": J.div(v_sc_607, J.min_([1.4, v_sc_607]))}])
	var _t269 = env["prop"]
	J.cl(_t269, null, [v_ctx_600, "store__crate", J.add(J.gp(v_B_601, "x"), J.mul(0.2, v_H_602)), 0.5, J.mul(v_cw_605, J.min_([1.4, v_sc_607])), 0.0, {"an": [0.5, 1.0], "sy": J.div(v_sc_607, J.min_([1.4, v_sc_607])), "flip": true}])
	if (not J.t(v_plankLift_604)):
		var _t270 = env["prop"]
		J.cl(_t270, null, [v_ctx_600, "fx_plank", J.gp(v_B_601, "x"), J.add(((-J.num(J.gp(v_B_601, "top"))) + J.mul(0.06, v_H_602)), (v_shake_603 if J.t(v_shake_603) else 0.0)), J.mul(0.52, v_H_602), 0.0, {"an": [0.5, 0.8]}])

func _f97(this_, a: Array, env):
	return {"k": J.S_Object_("assign", [{}, env["DEF"], {"bend": 16.0, "lean": 8.0, "hy": 0.04, "sy": 0.95}])}

func _f96(this_, a: Array, env):
	var v_a_691 = null; var v_R_692 = null; var v_H_693 = null; var v_A_694 = null
	v_a_691 = J.arg(a, 0)
	v_R_692 = J.arg(a, 1)
	v_H_693 = J.gp(v_a_691, "H")
	if (not J.t(J.gp(v_R_692, "arm"))):
		return {"x": J.mul(0.4, v_H_693), "top": J.mul(0.26, v_H_693)}
	var _t271 = env["aim"]
	v_A_694 = J.cl(_t271, null, [v_a_691, "knead", Callable(self, "_f97").bind(env)])
	var _t272 = env["cl"]
	var _t274 = J.cl(_t272, null, [J.add(J.gp(J.gp(v_A_694, "G"), 0.0), J.mul(0.02, v_H_693)), J.mul(0.22, v_H_693), J.mul(0.6, v_H_693)])
	var _t273 = env["cl"]
	return {"x": _t274, "top": J.cl(_t273, null, [((-J.num(J.gp(J.gp(v_A_694, "G"), 1.0))) - J.mul(0.04, v_H_693)), J.mul(0.16, v_H_693), J.mul(0.42, v_H_693)])}

func _f98(this_, a: Array, env):
	var v_ctx_697 = null; var v_C_698 = null; var v_H_699 = null; var v_withLid_700 = null; var v_sw_701 = null; var v_sh_702 = null; var v_sc_703 = null
	v_ctx_697 = J.arg(a, 0)
	v_C_698 = J.arg(a, 1)
	v_H_699 = J.arg(a, 2)
	v_withLid_700 = J.arg(a, 3)
	v_sw_701 = J.mul(0.36, v_H_699)
	var _t275 = env["propH"]
	v_sh_702 = J.cl(_t275, null, ["bun__steamer", v_sw_701])
	v_sc_703 = J.div(J.gp(v_C_698, "top"), J.mul(v_sh_702, 0.95))
	var _t276 = env["prop"]
	J.cl(_t276, null, [v_ctx_697, "bun__steamer", J.gp(v_C_698, "x"), 0.5, v_sw_701, 0.0, {"an": [0.5, 1.0], "sy": v_sc_703}])

func _f148(this_, a: Array, env):
	var v_name_1026 = null; var v_ctx_1027 = null; var v_a_1028 = null; var v_R_1029 = null; var v_v_1030 = null; var v_at_1031 = null; var v_fr_1032 = null
	v_name_1026 = J.arg(a, 0)
	v_ctx_1027 = J.arg(a, 1)
	v_a_1028 = J.arg(a, 2)
	var _t277 = env["rigOf"]
	v_R_1029 = J.cl(_t277, null, [J.gp(v_a_1028, "type")])
	var _t278 = (not J.t(v_R_1029))
	if (_t278 if _t278 else J.seq(J.typeof_(J.G.get("MoveKit")), "undefined")):
		return false
	var _t279 = (not J.t(J.gp(v_R_1029, "special")))
	if ((not J.t(J.gp(v_R_1029, "mesh"))) if _t279 else _t279):
		return false
	var _t281 = J.gp(J.gp(v_a_1028, "o"), "wv")
	if not J.t(_t281):
		var _t280 = env["defaults"]
		_t281 = J.cl(_t280, null, [v_name_1026, J.gp(v_a_1028, "type"), 1.0])
	v_v_1030 = _t281
	var _t282 = J.gp(J.gp(v_a_1028, "o"), "at")
	var _t283 = J.gp(J.gp(v_a_1028, "o"), "at")
	v_at_1031 = J.max_([0.0, (_t283 if J.t(_t283) else 0.0)])
	var _t284 = J.gp(env["ACT"], v_name_1026)
	v_fr_1032 = J.mc(_t284, "f", [v_a_1028, v_R_1029, v_at_1031, v_v_1030])
	var _t285 = env["render"]
	J.cl(_t285, null, [v_ctx_1027, v_a_1028, v_fr_1032])
	return true

func _f151(this_, a: Array, env):
	var v_x_1043 = null
	v_x_1043 = J.arg(a, 0)
	var _t286 = env["__p"]["rnd"]
	return J.cl(_t286, null, [(J.mul(env["r"], 13.7) + J.mul(v_x_1043, 7.1))])

func _f150(this_, a: Array, env):
	var v_name_1038 = null; var v_type_1039 = null; var v_R_1041 = null; var v_v_1042 = null
	var _s259 = {"__p": env, "r": null}
	v_name_1038 = J.arg(a, 0)
	v_type_1039 = J.arg(a, 1)
	_s259["r"] = J.arg(a, 2)
	v_R_1041 = Callable(self, "_f151").bind(_s259)
	v_v_1042 = {"sp": (0.88 + J.mul(J.cl(v_R_1041, null, [1.0]), 0.24)), "seed": floor(J.num(J.mul(J.cl(v_R_1041, null, [2.0]), 100.0)))}
	if J.seq(v_name_1038, "chop"):
		var _t287 = (3.0 + floor(J.num(J.mul(J.cl(v_R_1041, null, [3.0]), 2.0))))
		J.sp(v_v_1042, "n", _t287)
	if J.seq(v_name_1038, "reap"):
		var _t288 = (3.0 + floor(J.num(J.mul(J.cl(v_R_1041, null, [3.0]), 2.0))))
		J.sp(v_v_1042, "n", _t288)
	if J.seq(v_name_1038, "plant"):
		J.sp(v_v_1042, "n", 3.0)
	if J.seq(v_name_1038, "hammer"):
		var _t289 = (2.0 + floor(J.num(J.mul(J.cl(v_R_1041, null, [3.0]), 2.0))))
		J.sp(v_v_1042, "n", _t289)
	if J.seq(v_name_1038, "sand"):
		var _t290 = (4.0 + floor(J.num(J.mul(J.cl(v_R_1041, null, [3.0]), 2.0))))
		J.sp(v_v_1042, "n", _t290)
	if J.seq(v_name_1038, "knead"):
		var _t291 = (4.0 + floor(J.num(J.mul(J.cl(v_R_1041, null, [3.0]), 3.0))))
		J.sp(v_v_1042, "n", _t291)
	if J.seq(v_name_1038, "coins"):
		var _t292 = (4.0 + floor(J.num(J.mul(J.cl(v_R_1041, null, [3.0]), 2.0))))
		J.sp(v_v_1042, "n", _t292)
	if J.seq(v_name_1038, "burn"):
		var _t293 = (2.0 + floor(J.num(J.mul(J.cl(v_R_1041, null, [3.0]), 2.0))))
		J.sp(v_v_1042, "n", _t293)
	if J.seq(v_name_1038, "march"):
		var _t294 = (8.0 + (2.0 * floor(J.num(J.mul(J.cl(v_R_1041, null, [3.0]), 3.0)))))
		J.sp(v_v_1042, "n", _t294)
	if J.seq(v_name_1038, "boo"):
		J.sp(v_v_1042, "n", 2.0)
	if J.seq(v_name_1038, "drill"):
		J.sp(v_v_1042, "n", 3.0)
	return v_v_1042

func _f153(this_, a: Array, env):
	var v_e_1054 = null
	v_e_1054 = J.arg(a, 0)
	return (not J.seq(J.gp(v_e_1054, 0.0), env["prev"]))

func _f154(this_, a: Array, env):
	var v_e_1055 = null
	v_e_1055 = J.arg(a, 0)
	return (not J.seq(J.gp(v_e_1055, 0.0), "burn"))

func _f155(this_, a: Array, env):
	var v_e_1056 = null
	v_e_1056 = J.arg(a, 0)
	var _t302 = J.gp(v_e_1056, 1.0)
	var _t301 = J.seq(J.gp(v_e_1056, 0.0), "sneak")
	var _t304 = J.mul(_t302, (4.0 if J.t((J.gp(env["__p"]["GLUTTON"], env["type"]) if _t301 else _t301)) else 1.0))
	var _t303 = J.seq(J.gp(v_e_1056, 0.0), "coins")
	return (_t304 * (2.0 if (J.seq(env["type"], "toyol") if _t303 else _t303) else 1.0))

func _f152(this_, a: Array, env):
	var v_post_1046 = null; var v_ctxInfo_1049 = null; var v_list_1050 = null; var v_wt_1051 = null; var v_sum_1052 = null; var v_r_1053 = null; var v_e_1057 = null; var v_e_1058 = null
	var _s261 = {"__p": env, "type": null, "prev": null}
	v_post_1046 = J.arg(a, 0)
	_s261["type"] = J.arg(a, 1)
	_s261["prev"] = J.arg(a, 2)
	v_ctxInfo_1049 = J.arg(a, 3)
	var _t295 = J.gp(_s261["__p"]["POST_ACTS"], v_post_1046)
	var _t296 = (_t295 if J.t(_t295) else [["rest", 1.0]])
	v_list_1050 = J.mc(_t296, "filter", [Callable(self, "_f153").bind(_s261)])
	var _t297 = (not J.t(v_ctxInfo_1049))
	if (_t297 if _t297 else (not J.t(J.gp(v_ctxInfo_1049, "furnace")))):
		var _t298 = J.mc(v_list_1050, "filter", [Callable(self, "_f154").bind(_s261)])
		v_list_1050 = _t298
	if (not J.t(J.len(v_list_1050))):
		var _t299 = J.gp(_s261["__p"]["POST_ACTS"], v_post_1046)
		var _t300 = (_t299 if J.t(_t299) else [["rest", 1.0]])
		v_list_1050 = _t300
	v_wt_1051 = Callable(self, "_f155").bind(_s261)
	v_sum_1052 = 0.0
	for _t305 in J.iter(v_list_1050):
		v_e_1057 = _t305
		var _t306 = J.add(v_sum_1052, J.cl(v_wt_1051, null, [v_e_1057]))
		v_sum_1052 = _t306
	v_r_1053 = J.mul(randf(), v_sum_1052)
	for _t307 in J.iter(v_list_1050):
		v_e_1058 = _t307
		var _t308 = J.sub(v_r_1053, J.cl(v_wt_1051, null, [v_e_1058]))
		v_r_1053 = _t308
		if J.cmp(v_r_1053, 0.0, "<="):
			return J.gp(v_e_1058, 0.0)
	return J.gp(J.gp(v_list_1050, 0.0), 0.0)

func _f157(this_, a: Array, env):
	var v_prev_1068 = null; var v_act_1069 = null; var v_v_1070 = null; var v_fw_1071 = null; var v_px_1072 = null; var v_side_1073 = null
	v_prev_1068 = J.arg(a, 0)
	var _t313 = env["__p"]["pickNext"]
	v_act_1069 = J.cl(_t313, null, [J.gp(env["s"], "post"), J.gp(env["g"], "k"), v_prev_1068, env["info"]])
	var _t314 = env["__p"]["defaults"]
	v_v_1070 = J.cl(_t314, null, [v_act_1069, J.gp(env["g"], "k"), ((randf() * 1000.0) + 1.0)])
	var _t315 = J.seq(v_act_1069, "haul")
	if (_t315 if _t315 else J.seq(v_act_1069, "crate")):
		v_fw_1071 = ((-1.0) if J.t(J.gp(env["s"], "flip")) else 1.0)
		v_px_1072 = J.sub(J.gp(env["s"], "x"), J.mul(v_fw_1071, 58.0))
		var _t316 = J.cmp(v_px_1072, 14.0, "<")
		var _t317 = (_t316 if _t316 else J.cmp(v_px_1072, 376.0, ">"))
		J.sp(v_v_1070, "mirror", _t317)
	if J.seq(v_act_1069, "burn"):
		J.sp(v_v_1070, "walk", 1.0)
		v_side_1073 = ((-1.0) if J.cmp(J.gp(J.gp(env["info"], "furnace"), 0.0), J.gp(env["s"], "x"), ">=") else 1.0)
		var _t318 = [J.sub(J.add(J.gp(J.gp(env["info"], "furnace"), 0.0), J.mul(v_side_1073, 30.0)), J.gp(env["s"], "x")), J.sub(J.add(J.gp(J.gp(env["info"], "furnace"), 1.0), 16.0), J.gp(env["s"], "y"))]
		J.sp(v_v_1070, "stand", _t318)
	return {"act": v_act_1069, "v": v_v_1070}

func _f156(this_, a: Array, env):
	var v_t_1062 = null; var v_id_1065 = null; var v_st_1066 = null; var v_fresh_1067 = null; var v_n_1074 = null; var v_n_1075 = null
	var _s268 = {"__p": env, "s": null, "info": null, "g": null}
	_s268["s"] = J.arg(a, 0)
	v_t_1062 = J.arg(a, 1)
	_s268["info"] = J.arg(a, 2)
	_s268["g"] = J.gp(_s268["s"], "g")
	var _t309 = J.gp(_s268["g"], "id")
	v_id_1065 = (_t309 if J.t(_t309) else J.gp(_s268["g"], "k"))
	v_st_1066 = J.mc(_s268["__p"]["STATE"], "get", [v_id_1065])
	var _t312 = v_st_1066
	if J.t(_t312):
		var _t310 = (not J.seq(J.gp(v_st_1066, "post"), J.gp(_s268["s"], "post")))
		var _t311 = (_t310 if _t310 else J.cmp(v_t_1062, J.sub(J.gp(v_st_1066, "t0"), 1.0), "<"))
		_t312 = (_t311 if _t311 else (not J.seq(J.gp(v_st_1066, "k"), J.gp(_s268["g"], "k"))))
	if J.t(_t312):
		v_st_1066 = null
	v_fresh_1067 = Callable(self, "_f157").bind(_s268)
	if (not J.t(v_st_1066)):
		v_n_1074 = J.cl(v_fresh_1067, null, [null])
		var _t320 = J.gp(_s268["s"], "post")
		var _t321 = J.gp(_s268["g"], "k")
		var _t322 = J.gp(v_n_1074, "act")
		var _t323 = J.gp(v_n_1074, "v")
		var _t319 = J.gp(_s268["__p"]["ACT"], J.gp(v_n_1074, "act"))
		var _t324 = {"post": _t320, "k": _t321, "act": _t322, "v": _t323, "dur": J.mc(_t319, "dur", [J.gp(v_n_1074, "v")])}
		v_st_1066 = _t324
		var _t325 = J.sub(v_t_1062, (J.mul(randf(), J.gp(v_st_1066, "dur")) * 0.9))
		J.sp(v_st_1066, "t0", _t325)
		J.mc(_s268["__p"]["STATE"], "set", [v_id_1065, v_st_1066])
	if J.cmp(J.sub(v_t_1062, J.gp(v_st_1066, "t0")), J.gp(v_st_1066, "dur"), ">="):
		v_n_1075 = J.cl(v_fresh_1067, null, [J.gp(v_st_1066, "act")])
		var _t326 = J.gp(v_n_1075, "act")
		J.sp(v_st_1066, "act", _t326)
		var _t327 = J.gp(v_n_1075, "v")
		J.sp(v_st_1066, "v", _t327)
		var _t328 = J.add(v_t_1062, (randf() * 0.35))
		J.sp(v_st_1066, "t0", _t328)
		var _t329 = J.gp(_s268["__p"]["ACT"], J.gp(v_n_1075, "act"))
		var _t330 = J.mc(_t329, "dur", [J.gp(v_n_1075, "v")])
		J.sp(v_st_1066, "dur", _t330)
	return v_st_1066

func _f158(this_, a: Array, env):
	var v_ctx_1078 = null; var v_s_1079 = null; var v_t_1080 = null; var v_scale_1081 = null; var v_info_1082 = null; var v_g_1083 = null; var v_k_1084 = null; var v_sc_1085 = null; var v_st_1086 = null; var v_at_1087 = null; var v_o_1088 = null
	v_ctx_1078 = J.arg(a, 0)
	v_s_1079 = J.arg(a, 1)
	v_t_1080 = J.arg(a, 2)
	v_scale_1081 = J.arg(a, 3)
	v_info_1082 = J.arg(a, 4)
	var _t331 = (v_info_1082 if J.t(v_info_1082) else {})
	v_info_1082 = _t331
	v_g_1083 = J.gp(v_s_1079, "g")
	v_k_1084 = J.gp(v_g_1083, "k")
	v_sc_1085 = (v_scale_1081 if J.t(v_scale_1081) else 0.62)
	var _t332 = env["plan"]
	v_st_1086 = J.cl(_t332, null, [v_s_1079, v_t_1080, v_info_1082])
	v_at_1087 = J.max_([0.0, J.sub(v_t_1080, J.gp(v_st_1086, "t0"))])
	var _t333 = J.gp(v_s_1079, "ph")
	v_o_1088 = {"t": J.add(v_t_1080, (_t333 if J.t(_t333) else 0.0)), "flip": ((not J.t(J.gp(v_s_1079, "flip"))) if J.t(J.gp(J.gp(v_st_1086, "v"), "mirror")) else J.gp(v_s_1079, "flip")), "tamed": true, "untied": true, "act": J.add("work_", J.gp(v_st_1086, "act")), "at": v_at_1087, "wv": J.gp(v_st_1086, "v"), "wkey": J.gp(v_g_1083, "id")}
	var _t334 = J.seq(J.gp(v_st_1086, "act"), "burn")
	var _t335 = (J.gp(J.gp(v_st_1086, "v"), "stand") if _t334 else _t334)
	if J.t((J.gp(v_info_1082, "furnace") if J.t(_t335) else _t335)):
		var _t336 = [J.sub(J.gp(J.gp(v_info_1082, "furnace"), 0.0), J.add(J.gp(v_s_1079, "x"), J.gp(J.gp(J.gp(v_st_1086, "v"), "stand"), 0.0))), J.sub(J.gp(J.gp(v_info_1082, "furnace"), 1.0), J.add(J.gp(v_s_1079, "y"), J.gp(J.gp(J.gp(v_st_1086, "v"), "stand"), 1.0)))]
		J.sp(v_o_1088, "wtarget", _t336)
	var _t337 = (not J.seq(J.typeof_(J.G.get("SPECIAL")), "undefined"))
	if J.t((J.mc(J.G.get("SPECIAL"), "has", [v_k_1084]) if _t337 else _t337)):
		var _t338 = J.G.get("DAILY")
		var _t339 = J.gp(v_o_1088, "act")
		var _t341 = J.gp(v_s_1079, "x")
		var _t342 = J.gp(v_s_1079, "y")
		var _t340 = J.gp(env["SPECIAL_H"], v_k_1084)
		if (not J.t(J.mc(_t338, _t339, [v_ctx_1078, {"type": v_k_1084, "x": _t341, "y": _t342, "s": v_sc_1085, "H": J.mul((_t340 if J.t(_t340) else 50.0), v_sc_1085), "o": v_o_1088, "faceRight": (not J.t(J.gp(v_o_1088, "flip"))), "solid": true}]))):
			J.mc(J.G.get("ART"), "drawChar", [v_ctx_1078, v_k_1084, J.gp(v_s_1079, "x"), J.gp(v_s_1079, "y"), v_sc_1085, {"t": J.gp(v_o_1088, "t"), "work": true, "flip": J.gp(v_s_1079, "flip"), "tamed": true, "untied": true}])
		return v_st_1086
	J.mc(J.G.get("ART"), "drawChar", [v_ctx_1078, v_k_1084, J.gp(v_s_1079, "x"), J.gp(v_s_1079, "y"), v_sc_1085, v_o_1088])
	return v_st_1086

func _f159(this_, a: Array, env):
	var v_ctx_1091 = null; var v_type_1092 = null; var v_x_1093 = null; var v_y_1094 = null; var v_sc_1095 = null; var v_act_1096 = null; var v_at_1097 = null; var v_o2_1098 = null; var v_v_1099 = null; var v_o_1100 = null
	v_ctx_1091 = J.arg(a, 0)
	v_type_1092 = J.arg(a, 1)
	v_x_1093 = J.arg(a, 2)
	v_y_1094 = J.arg(a, 3)
	v_sc_1095 = J.arg(a, 4)
	v_act_1096 = J.arg(a, 5)
	v_at_1097 = J.arg(a, 6)
	v_o2_1098 = J.arg(a, 7)
	var _t344 = (J.gp(v_o2_1098, "wv") if J.t(v_o2_1098) else v_o2_1098)
	if not J.t(_t344):
		var _t343 = env["defaults"]
		_t344 = J.cl(_t343, null, [v_act_1096, v_type_1092, 1.0])
	v_v_1099 = _t344
	v_o_1100 = J.S_Object_("assign", [{"t": v_at_1097, "act": J.add("work_", v_act_1096), "at": v_at_1097, "wv": v_v_1099}, (v_o2_1098 if J.t(v_o2_1098) else {})])
	var _t345 = (not J.seq(J.typeof_(J.G.get("SPECIAL")), "undefined"))
	if J.t((J.mc(J.G.get("SPECIAL"), "has", [v_type_1092]) if _t345 else _t345)):
		var _t346 = J.G.get("DAILY")
		var _t347 = J.gp(v_o_1100, "act")
		var _t348 = J.gp(env["SPECIAL_H"], v_type_1092)
		if (not J.t(J.mc(_t346, _t347, [v_ctx_1091, {"type": v_type_1092, "x": v_x_1093, "y": v_y_1094, "s": v_sc_1095, "H": J.mul((_t348 if J.t(_t348) else 50.0), v_sc_1095), "o": v_o_1100, "faceRight": (not J.t(J.gp(v_o_1100, "flip"))), "solid": true}]))):
			J.mc(J.G.get("ART"), "drawChar", [v_ctx_1091, v_type_1092, v_x_1093, v_y_1094, v_sc_1095, v_o_1100])
		return null
	J.mc(J.G.get("ART"), "drawChar", [v_ctx_1091, v_type_1092, v_x_1093, v_y_1094, v_sc_1095, v_o_1100])

func _f2(this_, a: Array, env):
	var v_v_71 = null; var v_a_72 = null; var v_b_73 = null
	v_v_71 = J.arg(a, 0)
	var _t349 = J.arg(a, 1)
	if _t349 == null:
		_t349 = 0.0
	v_a_72 = _t349
	var _t350 = J.arg(a, 2)
	if _t350 == null:
		_t350 = 1.0
	v_b_73 = _t350
	return (v_a_72 if J.cmp(v_v_71, v_a_72, "<") else (v_b_73 if J.cmp(v_v_71, v_b_73, ">") else v_v_71))

func _f3(this_, a: Array, env):
	var v_a_74 = null; var v_b_75 = null; var v_k_76 = null
	v_a_74 = J.arg(a, 0)
	v_b_75 = J.arg(a, 1)
	v_k_76 = J.arg(a, 2)
	return J.add(v_a_74, J.mul(J.sub(v_b_75, v_a_74), v_k_76))

func _f4(this_, a: Array, env):
	var v_t_77 = null; var v_a_78 = null; var v_b_79 = null
	v_t_77 = J.arg(a, 0)
	v_a_78 = J.arg(a, 1)
	v_b_79 = J.arg(a, 2)
	var _t351 = env["cl"]
	return J.cl(_t351, null, [J.div(J.sub(v_t_77, v_a_78), J.sub(v_b_79, v_a_78))])

func _f5(this_, a: Array, env):
	var v_t_80 = null
	v_t_80 = J.arg(a, 0)
	return v_t_80

func _f6(this_, a: Array, env):
	var v_t_81 = null
	v_t_81 = J.arg(a, 0)
	return (1.0 - (J.sub(1.0, v_t_81) * J.sub(1.0, v_t_81)))

func _f7(this_, a: Array, env):
	var v_t_82 = null
	v_t_82 = J.arg(a, 0)
	return J.mul(v_t_82, v_t_82)

func _f8(this_, a: Array, env):
	var v_t_83 = null
	v_t_83 = J.arg(a, 0)
	return (J.mul(J.mul(2.0, v_t_83), v_t_83) if J.cmp(v_t_83, 0.5, "<") else (1.0 - ((2.0 * J.sub(1.0, v_t_83)) * J.sub(1.0, v_t_83))))

func _f9(this_, a: Array, env):
	var v_t_84 = null
	v_t_84 = J.arg(a, 0)
	return (1.0 - pow(J.num(J.sub(1.0, v_t_84)), J.num(3.0)))

func _f10(this_, a: Array, env):
	var v_t_85 = null
	v_t_85 = J.arg(a, 0)
	return J.mul(J.mul(v_t_85, v_t_85), v_t_85)

func _f11(this_, a: Array, env):
	var v_t_86 = null
	v_t_86 = J.arg(a, 0)
	return (0.5 - (0.5 * cos(J.num(J.mul(PI, v_t_86)))))

func _f12(this_, a: Array, env):
	var v_t_87 = null; var v_c_88 = null
	v_t_87 = J.arg(a, 0)
	v_c_88 = 1.7
	return ((1.0 + J.mul(J.add(v_c_88, 1.0), pow(J.num(J.sub(v_t_87, 1.0)), J.num(3.0)))) + J.mul(v_c_88, pow(J.num(J.sub(v_t_87, 1.0)), J.num(2.0))))

func _f13(this_, a: Array, env):
	var v_i_89 = null; var v_v_90 = null
	v_i_89 = J.arg(a, 0)
	v_v_90 = (sin(J.num((J.mul(v_i_89, 127.1) + 311.7))) * 43758.5453)
	return J.sub(v_v_90, floor(J.num(v_v_90)))

func _f14(this_, a: Array, env):
	var v_k_91 = null
	v_k_91 = J.arg(a, 0)
	var _t353 = J.seq(J.typeof_(J.G.get("sprOk")), "function")
	if J.t(_t353):
		var _t352 = J.G.get("sprOk")
		_t353 = J.cl(_t352, null, [v_k_91])
	return _t353

func _f17(this_, a: Array, env):
	var v_k_104 = null; var v_o_105 = null; var v_n_106 = null
	v_k_104 = J.arg(a, 0)
	v_o_105 = J.arg(a, 1)
	for _t354 in J.keys(v_o_105):
		v_n_106 = _t354
		var _t355 = J.seq(v_n_106, "sx")
		var _t356 = (J.mul(J.gp(v_k_104, v_n_106), J.gp(v_o_105, v_n_106)) if (_t355 if _t355 else J.seq(v_n_106, "sy")) else J.add(J.gp(v_k_104, v_n_106), J.gp(v_o_105, v_n_106)))
		J.sp(v_k_104, v_n_106, _t356)
	return v_k_104

func _f21(this_, a: Array, env):
	return J.construct(J.gp(J.G.get("MoveKit"), "M"), [])

func _f28(this_, a: Array, env):
	var v_key_191 = null; var v_w_192 = null; var v_img_193 = null
	v_key_191 = J.arg(a, 0)
	v_w_192 = J.arg(a, 1)
	v_img_193 = J.gp(J.G.get("SPR"), v_key_191)
	return (J.div(J.mul(v_w_192, J.gp(v_img_193, "naturalHeight")), J.gp(v_img_193, "naturalWidth")) if J.t((J.gp(v_img_193, "naturalWidth") if J.t(v_img_193) else v_img_193)) else J.mul(v_w_192, 0.6))

func _f37(this_, a: Array, env):
	var v_ctx_242 = null; var v_pts_243 = null; var v_col_244 = null; var v_w_245 = null; var v_seed_246 = null; var v_alpha_247 = null
	v_ctx_242 = J.arg(a, 0)
	v_pts_243 = J.arg(a, 1)
	v_col_244 = J.arg(a, 2)
	v_w_245 = J.arg(a, 3)
	v_seed_246 = J.arg(a, 4)
	v_alpha_247 = J.arg(a, 5)
	return J.mc(J.G.get("MoveKit"), "crayon", [v_ctx_242, v_pts_243, v_col_244, v_w_245, v_seed_246, v_alpha_247])

func _f54(this_, a: Array, env):
	var v_v_428 = null
	v_v_428 = J.arg(a, 0)
	var _t357 = (J.gp(v_v_428, "sp") if J.t(v_v_428) else v_v_428)
	return (_t357 if J.t(_t357) else 1.0)

func _f57(this_, a: Array, env):
	var v_v_438 = null
	v_v_438 = J.arg(a, 0)
	var _t360 = J.mul(J.gp(v_v_438, "n"), env["CHOP_T"])
	var _t359 = env["sp"]
	return (J.div(_t360, J.cl(_t359, null, [v_v_438])) + 1.0)

func _f59(this_, a: Array, env):
	var _t374 = env["__p"]["handRot"]
	var _t376 = env["R"]
	var _t375 = env["__p"]["chopKeys"]
	return {"k": J.cl(_t374, null, [_t376, J.cl(_t375, null, [env["R"], 0.6]), 45.0]), "tool": "axe"}

func _f60(this_, a: Array, env):
	var v_j_461 = null
	v_j_461 = J.arg(a, 0)
	return J.sub(env["at"], (J.mul(v_j_461, env["T"]) + J.mul(0.6, env["T"])))

func _f61(this_, a: Array, env):
	var v_ctx_462 = null; var v_ly_463 = null; var v_bounce_464 = null; var v_gL_465 = null; var v_j_466 = null; var v_g_467 = null; var v_pop_468 = null; var v_q_469 = null; var v_fall_470 = null; var v_al_471 = null
	v_ctx_462 = J.arg(a, 0)
	var _t379 = env["__p"]["prop"]
	J.cl(_t379, null, [v_ctx_462, "stump", env["hitX"], 0.5, env["sw"], 0.0, {"an": [0.5, 0.97]}])
	v_ly_463 = ((-J.num(env["top"])) + J.mul(0.02, env["H"]))
	v_bounce_464 = 0.0
	v_j_466 = 0.0
	while true:
		if not J.cmp(v_j_466, env["n"], "<"): break
		var _t380 = env["hitAge"]
		v_g_467 = J.cl(_t380, null, [v_j_466])
		var _t381 = J.cmp(v_g_467, 0.0, ">")
		if (J.cmp(v_g_467, 0.2, "<") if _t381 else _t381):
			var _t382 = (J.mul(((-sin(J.num((J.div(v_g_467, 0.2) * PI)))) * 0.025), env["H"]) * (0.0 if J.seq(v_j_466, J.sub(env["n"], 1.0)) else 1.0))
			v_bounce_464 = _t382
		v_j_466 = J.num(v_j_466) + 1.0
	var _t383 = env["hitAge"]
	v_gL_465 = J.cl(_t383, null, [J.sub(env["n"], 1.0)])
	if J.cmp(v_gL_465, 0.0, "<"):
		var _t384 = env["__p"]["seg"]
		v_pop_468 = J.mc(env["__p"]["E"], "back", [J.cl(_t384, null, [env["at"], 0.0, 0.3])])
		var _t385 = env["__p"]["prop"]
		J.cl(_t385, null, [v_ctx_462, "wood__log", env["hitX"], J.add(v_ly_463, v_bounce_464), J.mul(env["logW"], v_pop_468), 0.0, {"an": [0.5, 1.0]}])
	else:
		var _t386 = env["__p"]["seg"]
		v_q_469 = J.cl(_t386, null, [v_gL_465, 0.0, 0.5])
		v_fall_470 = J.mc(env["__p"]["E"], "i", [v_q_469])
		var _t387 = env["__p"]["seg"]
		v_al_471 = J.sub(1.0, J.cl(_t387, null, [v_gL_465, 0.6, 0.95]))
		var _t388 = env["__p"]["prop"]
		var _t390 = J.sub(env["hitX"], J.mul(J.mul(v_fall_470, 0.16), env["H"]))
		var _t389 = env["__p"]["lerp"]
		J.cl(_t388, null, [v_ctx_462, "wood__log", _t390, J.cl(_t389, null, [v_ly_463, 0.0, v_fall_470]), env["logW"], ((-J.num(v_fall_470)) * 70.0), {"an": [1.0, 1.0], "clip": [0.0, 0.5], "alpha": v_al_471}])
		var _t391 = env["__p"]["prop"]
		var _t393 = J.add(env["hitX"], J.mul(J.mul(v_fall_470, 0.16), env["H"]))
		var _t392 = env["__p"]["lerp"]
		J.cl(_t391, null, [v_ctx_462, "wood__log", _t393, J.cl(_t392, null, [v_ly_463, 0.0, v_fall_470]), env["logW"], J.mul(v_fall_470, 70.0), {"an": [0.0, 1.0], "clip": [0.5, 1.0], "alpha": v_al_471}])

func _f62(this_, a: Array, env):
	var v_ctx_472 = null; var v_j_473 = null; var v_g_474 = null
	v_ctx_472 = J.arg(a, 0)
	v_j_473 = 0.0
	while true:
		if not J.cmp(v_j_473, env["n"], "<"): break
		var _t394 = env["hitAge"]
		v_g_474 = J.cl(_t394, null, [v_j_473])
		var _t395 = env["__p"]["chips"]
		J.cl(_t395, null, [v_ctx_472, env["hitX"], (-J.num(env["top"])), v_g_474, J.add((11.0 + J.mul(v_j_473, 7.0)), J.gp(env["v"], "seed")), env["H"], 0.0])
		if J.seq(v_j_473, J.sub(env["n"], 1.0)):
			var _t396 = env["__p"]["puff"]
			J.cl(_t396, null, [v_ctx_472, env["hitX"], 0.0, J.sub(v_g_474, 0.25), 0.5, J.mul(0.3, env["H"]), J.add(5.0, J.gp(env["v"], "seed")), "wood"])
		v_j_473 = J.num(v_j_473) + 1.0

func _f58(this_, a: Array, env):
	var v_a_441 = null; var v_i_448 = null; var v_p_449 = null; var v_tail_450 = null; var v_k_451 = null; var v_A_452 = null; var v_logT_454 = null; var v_back_459 = null; var v_front_460 = null
	var _s90 = {"__p": env, "R": null, "at": null, "v": null, "T": null, "H": null, "n": null, "hitX": null, "top": null, "sw": null, "logW": null, "hitAge": null}
	v_a_441 = J.arg(a, 0)
	_s90["R"] = J.arg(a, 1)
	_s90["at"] = J.arg(a, 2)
	_s90["v"] = J.arg(a, 3)
	var _t362 = _s90["__p"]["CHOP_T"]
	var _t361 = _s90["__p"]["sp"]
	_s90["T"] = J.div(_t362, J.cl(_t361, null, [_s90["v"]]))
	_s90["H"] = J.gp(v_a_441, "H")
	_s90["n"] = J.gp(_s90["v"], "n")
	v_i_448 = J.min_([J.sub(_s90["n"], 1.0), floor(J.num(J.div(_s90["at"], _s90["T"])))])
	v_p_449 = (J.div(J.sub(_s90["at"], J.mul(v_i_448, _s90["T"])), _s90["T"]) if J.cmp(_s90["at"], J.mul(_s90["n"], _s90["T"]), "<") else 1.0)
	v_tail_450 = J.sub(_s90["at"], J.mul(_s90["n"], _s90["T"]))
	var _t363 = _s90["__p"]["handRot"]
	var _t365 = _s90["R"]
	var _t364 = _s90["__p"]["chopKeys"]
	v_k_451 = J.cl(_t363, null, [_t365, J.cl(_t364, null, [_s90["R"], v_p_449]), 45.0])
	var _t366 = J.gp(_s90["R"], "arm")
	var _t367 = (J.cmp(v_p_449, 0.6, ">") if J.t(_t366) else _t366)
	if J.t((J.cmp(v_p_449, 0.7, "<") if J.t(_t367) else _t367)):
		var _t368 = J.add(J.gp(v_k_451, "ang"), ((sin(J.num((J.mul(J.sub(v_p_449, 0.6), _s90["T"]) * 90.0))) * 4.0) * (1.0 - J.div(J.sub(v_p_449, 0.6), 0.1))))
		J.sp(v_k_451, "ang", _t368)
	if J.cmp(v_tail_450, 0.0, ">"):
		var _t369 = _s90["__p"]["add"]
		var _t370 = _s90["__p"]["seg"]
		var _t372 = (sin(J.num(J.mul(J.cl(_t370, null, [v_tail_450, 0.2, 0.7]), PI))) * 8.0)
		var _t371 = _s90["__p"]["seg"]
		J.cl(_t369, null, [v_k_451, {"head": _t372, "sy": (1.0 + (sin(J.num(J.mul(J.cl(_t371, null, [v_tail_450, 0.2, 0.7]), PI))) * 0.02))}])
	var _t373 = _s90["__p"]["aim"]
	v_A_452 = J.cl(_t373, null, [v_a_441, "chop", Callable(self, "_f59").bind(_s90)])
	_s90["hitX"] = (J.gp(J.gp(v_A_452, "tip"), 0.0) if J.t(J.gp(_s90["R"], "arm")) else J.mul(0.4, _s90["H"]))
	v_logT_454 = J.mul(0.12, _s90["H"])
	var _t378 = null
	if J.t(J.gp(_s90["R"], "arm")):
		var _t377 = _s90["__p"]["cl"]
		_t378 = J.cl(_t377, null, [((-J.num(J.gp(J.gp(v_A_452, "tip"), 1.0))) - J.mul(v_logT_454, 0.55)), J.mul(0.16, _s90["H"]), J.mul(0.42, _s90["H"])])
	else:
		_t378 = J.mul(0.2, _s90["H"])
	_s90["top"] = _t378
	_s90["sw"] = J.div((J.div(_s90["top"], 0.84) * 620.0), 408.0)
	_s90["logW"] = J.min_([J.mul(0.34, _s90["H"]), J.mul(_s90["sw"], 0.8)])
	_s90["hitAge"] = Callable(self, "_f60").bind(_s90)
	v_back_459 = Callable(self, "_f61").bind(_s90)
	v_front_460 = Callable(self, "_f62").bind(_s90)
	var _t397 = J.gp(_s90["R"], "arm")
	return {"k": v_k_451, "tool": "axe", "back": v_back_459, "front": v_front_460, "toolBehind": (J.cmp(J.gp(v_k_451, "ang"), (-12.0), "<") if J.t(_t397) else _t397)}

func _f69(this_, a: Array, env):
	var v_v_517 = null
	v_v_517 = J.arg(a, 0)
	var _t404 = env["sp"]
	return J.div(3.6, J.cl(_t404, null, [v_v_517]))

func _f71(this_, a: Array, env):
	var v_ctx_529 = null; var v_P_530 = null
	v_ctx_529 = J.arg(a, 0)
	v_P_530 = J.arg(a, 1)
	var _t420 = env["__p"]["sweat"]
	J.cl(_t420, null, [v_ctx_529, J.add(J.gp(J.gp(v_P_530, "top"), 0.0), J.mul(0.08, env["H"])), J.add(J.gp(J.gp(v_P_530, "top"), 1.0), J.mul(0.14, env["H"])), J.sub(env["t"], 1.1), env["H"], J.add(7.0, J.gp(env["v"], "seed"))])

func _f70(this_, a: Array, env):
	var v_a_520 = null; var v_R_521 = null; var v_at_522 = null; var v_wipe_526 = null; var v_k_527 = null; var v_front_528 = null
	var _s114 = {"__p": env, "v": null, "t": null, "H": null}
	v_a_520 = J.arg(a, 0)
	v_R_521 = J.arg(a, 1)
	v_at_522 = J.arg(a, 2)
	_s114["v"] = J.arg(a, 3)
	var _t405 = _s114["__p"]["sp"]
	_s114["t"] = J.mul(v_at_522, J.cl(_t405, null, [_s114["v"]]))
	_s114["H"] = J.gp(v_a_520, "H")
	v_wipe_526 = (({"hr": (-75.0), "hx": 0.02, "hy": (-0.08), "head": 10.0} if J.t(J.gp(v_R_521, "long")) else {"hy": (-0.05), "hx": (-0.01), "hr": (-20.0), "head": 16.0, "bend": 10.0}) if J.t(J.gp(v_R_521, "arm")) else {"head": 14.0, "bend": 8.0, "sy": 0.97})
	var _t406 = _s114["__p"]["kf"]
	var _t411 = [0.0, {}]
	var _t412 = [0.35, {"lean": (-3.0), "sy": 1.02}]
	var _t413 = [0.75, v_wipe_526, "io"]
	var _t410 = {}
	var _t407 = J.gp(v_wipe_526, "hx")
	var _t409 = J.sub((_t407 if J.t(_t407) else 0.0), 0.03)
	var _t408 = J.gp(v_wipe_526, "hr")
	var _t416 = [1.0, J.S_Object_("assign", [_t410, v_wipe_526, {"hx": _t409, "hr": J.sub((_t408 if J.t(_t408) else 0.0), 12.0)}]), "io"]
	var _t415 = {}
	var _t414 = J.gp(v_wipe_526, "hx")
	v_k_527 = J.cl(_t406, null, [[_t411, _t412, _t413, _t416, [1.25, J.S_Object_("assign", [_t415, v_wipe_526, {"hx": J.add((_t414 if J.t(_t414) else 0.0), 0.02)}]), "io"], [1.55, {}, "io"], [2.15, {"lean": (-10.0), "bend": (-14.0), "head": (-14.0), "sy": 1.07, "sx": 0.96, "hy": (-0.03), "dy": (-0.01)}, "o"], [2.5, {"lean": (-11.0), "bend": (-15.0), "head": (-16.0), "sy": 1.08, "sx": 0.955, "hy": (-0.035), "dy": (-0.012)}], [2.95, {"sy": 0.94, "sx": 1.04, "head": 6.0}, "io"], [3.6, {}, "io"]], _s114["t"]])
	var _t417 = J.cmp(_s114["t"], 2.95, ">")
	if (J.cmp(_s114["t"], 3.4, "<") if _t417 else _t417):
		var _t418 = _s114["__p"]["seg"]
		var _t419 = J.add(J.gp(v_k_527, "sy"), (sin(J.num((J.mul(J.cl(_t418, null, [_s114["t"], 2.95, 3.4]), PI) * 2.0))) * 0.01))
		J.sp(v_k_527, "sy", _t419)
	v_front_528 = Callable(self, "_f71").bind(_s114)
	return {"k": v_k_527, "front": v_front_528}

func _f73(this_, a: Array, env):
	var v_v_535 = null
	v_v_535 = J.arg(a, 0)
	var _t424 = J.mul(J.gp(v_v_535, "n"), env["REAP_T"])
	var _t423 = env["sp"]
	return (J.div(_t424, J.cl(_t423, null, [v_v_535])) + 1.4)

func _f75(this_, a: Array, env):
	var v_ctx_552 = null; var v_P_553 = null; var v_j_554 = null; var v_g_555 = null; var v_x_556 = null; var v_j_557 = null
	v_ctx_552 = J.arg(a, 0)
	v_P_553 = J.arg(a, 1)
	v_j_554 = 0.0
	while true:
		if not J.cmp(v_j_554, env["n"], "<"): break
		v_g_555 = J.sub(env["body"], (J.mul(v_j_554, env["T"]) + J.mul(0.55, env["T"])))
		v_x_556 = J.mul((0.3 - J.mul(v_j_554, 0.06)), env["H"])
		var _t441 = env["__p"]["grains"]
		J.cl(_t441, null, [v_ctx_552, v_x_556, J.mul((-0.18), env["H"]), v_g_555, J.add((21.0 + J.mul(v_j_554, 5.0)), J.gp(env["v"], "seed")), env["H"], (-0.6)])
		v_j_554 = J.num(v_j_554) + 1.0
	if (not J.t(J.gp(env["R"], "arm"))):
		v_j_557 = 0.0
		while true:
			if not J.cmp(v_j_557, env["n"], "<"): break
			var _t442 = env["__p"]["grains"]
			J.cl(_t442, null, [v_ctx_552, J.gp(J.gp(v_P_553, "mouth"), 0.0), J.gp(J.gp(v_P_553, "mouth"), 1.0), J.sub(env["body"], (J.mul(v_j_557, env["T"]) + J.mul(0.5, env["T"]))), J.add(J.add(33.0, v_j_557), J.gp(env["v"], "seed")), env["H"], 0.2])
			v_j_557 = J.num(v_j_557) + 1.0

func _f74(this_, a: Array, env):
	var v_a_538 = null; var v_at_540 = null; var v_in0_545 = null; var v_k_547 = null; var v_front_548 = null; var v_i_549 = null; var v_p_550 = null; var v_q_551 = null
	var _s118 = {"__p": env, "R": null, "v": null, "T": null, "H": null, "n": null, "body": null}
	v_a_538 = J.arg(a, 0)
	_s118["R"] = J.arg(a, 1)
	v_at_540 = J.arg(a, 2)
	_s118["v"] = J.arg(a, 3)
	var _t426 = _s118["__p"]["REAP_T"]
	var _t425 = _s118["__p"]["sp"]
	_s118["T"] = J.div(_t426, J.cl(_t425, null, [_s118["v"]]))
	_s118["H"] = J.gp(v_a_538, "H")
	_s118["n"] = J.gp(_s118["v"], "n")
	v_in0_545 = 0.5
	_s118["body"] = J.sub(v_at_540, v_in0_545)
	v_k_547 = null
	if J.cmp(_s118["body"], 0.0, "<"):
		var _t427 = _s118["__p"]["kf"]
		var _t428 = J.cl(_t427, null, [[[0.0, {}], [v_in0_545, ({"bend": 28.0, "lean": 8.0, "head": 8.0, "ang": 120.0, "hx": 0.05, "hy": 0.04} if J.t(J.gp(_s118["R"], "arm")) else {"bend": 20.0, "lean": 10.0, "head": 10.0}), "io"]], v_at_540])
		v_k_547 = _t428
	else:
		if J.cmp(_s118["body"], J.mul(_s118["n"], _s118["T"]), "<"):
			v_i_549 = floor(J.num(J.div(_s118["body"], _s118["T"])))
			v_p_550 = J.div(J.sub(_s118["body"], J.mul(v_i_549, _s118["T"])), _s118["T"])
			var _t429 = _s118["__p"]["reapKeys"]
			var _t430 = J.cl(_t429, null, [_s118["R"], v_p_550])
			v_k_547 = _t430
			var _t432 = ((-J.num(v_i_549)) * 0.06)
			var _t431 = _s118["__p"]["seg"]
			var _t433 = J.add(J.gp(v_k_547, "dx"), (_t432 - J.mul(J.mc(_s118["__p"]["E"], "io", [J.cl(_t431, null, [v_p_550, 0.75, 1.0])]), 0.06)))
			J.sp(v_k_547, "dx", _t433)
		else:
			v_q_551 = J.sub(_s118["body"], J.mul(_s118["n"], _s118["T"]))
			var _t434 = _s118["__p"]["kf"]
			var _t435 = _s118["__p"]["reapKeys"]
			var _t436 = J.cl(_t434, null, [[[0.0, J.S_Object_("assign", [J.cl(_t435, null, [_s118["R"], 1.0]), {}])], [0.5, {"lean": (-6.0), "bend": (-8.0), "head": (-8.0), "sy": 1.04}, "o"], [0.9, {}, "io"]], v_q_551])
			v_k_547 = _t436
			var _t438 = ((-J.num(_s118["n"])) * 0.06)
			var _t437 = _s118["__p"]["seg"]
			var _t439 = J.add(J.gp(v_k_547, "dx"), (_t438 * J.sub(1.0, J.mc(_s118["__p"]["E"], "io", [J.cl(_t437, null, [v_q_551, 0.2, 0.9])]))))
			J.sp(v_k_547, "dx", _t439)
	if J.t(J.gp(_s118["R"], "arm")):
		var _t440 = J.add(J.gp(v_k_547, "hr"), (J.sub(J.gp(v_k_547, "ang"), 120.0) * (0.4 if J.t(J.gp(_s118["R"], "long")) else 0.15)))
		J.sp(v_k_547, "hr", _t440)
	v_front_548 = Callable(self, "_f75").bind(_s118)
	return {"k": v_k_547, "tool": "sickle", "front": v_front_548}

func _f76(this_, a: Array, env):
	var v_v_558 = null
	v_v_558 = J.arg(a, 0)
	var _t446 = J.mul(J.gp(v_v_558, "n"), 1.0)
	var _t445 = env["sp"]
	return (J.div(_t446, J.cl(_t445, null, [v_v_558])) + 1.6)

func _f78(this_, a: Array, env):
	var v_ctx_578 = null; var v_P_579 = null; var v_j_580 = null; var v_g_581 = null; var v_x_582 = null; var v_al_583 = null; var v_gr_584 = null; var v_m_585 = null
	v_ctx_578 = J.arg(a, 0)
	v_P_579 = J.arg(a, 1)
	v_j_580 = 0.0
	while true:
		if not J.cmp(v_j_580, env["n"], "<"): break
		v_g_581 = J.sub(env["body"], (J.mul(v_j_580, env["T"]) + J.mul(0.42, env["T"])))
		if J.cmp(v_g_581, 0.0, "<"):
			v_j_580 = J.num(v_j_580) + 1.0
			continue
		v_x_582 = (J.mul((0.3 - J.mul(v_j_580, 0.07)), env["H"]) + J.mul(J.gp(env["k"], "dx"), 0.0))
		var _t465 = env["__p"]["seg"]
		v_al_583 = J.sub(1.0, J.cl(_t465, null, [env["at"], J.sub(J.mc(env["this"], "dur", [env["v"]]), 0.6), J.mc(env["this"], "dur", [env["v"]])]))
		if J.cmp(v_g_581, 0.6, "<"):
			J.mc(v_ctx_578, "save", [])
			var _t466 = J.mul(J.gp(v_ctx_578, "globalAlpha"), ((1.0 - J.div(v_g_581, 0.6)) * 0.7))
			J.sp(v_ctx_578, "globalAlpha", _t466)
			J.sp(v_ctx_578, "strokeStyle", "#a9d6e6")
			var _t467 = J.max_([1.0, J.mul(0.015, env["H"])])
			J.sp(v_ctx_578, "lineWidth", _t467)
			J.mc(v_ctx_578, "beginPath", [])
			J.mc(v_ctx_578, "ellipse", [v_x_582, 0.0, (J.mul(0.05, env["H"]) + J.mul(J.mul(v_g_581, 0.14), env["H"])), (J.mul(0.015, env["H"]) + J.mul(J.mul(v_g_581, 0.04), env["H"])), 0.0, 0.0, env["__p"]["TAU"]])
			J.mc(v_ctx_578, "stroke", [])
			J.mc(v_ctx_578, "restore", [])
		var _t468 = env["__p"]["seg"]
		v_gr_584 = J.mc(env["__p"]["E"], "back", [J.cl(_t468, null, [v_g_581, 0.0, 0.25])])
		J.mc(v_ctx_578, "save", [])
		var _t469 = J.mul(J.gp(v_ctx_578, "globalAlpha"), v_al_583)
		J.sp(v_ctx_578, "globalAlpha", _t469)
		v_m_585 = 0.0
		while true:
			if not J.cmp(v_m_585, 3.0, "<"): break
			var _t470 = env["__p"]["crayon"]
			J.cl(_t470, null, [v_ctx_578, [[J.add(v_x_582, J.mul((J.sub(v_m_585, 1.0) * 0.012), env["H"])), 0.0], [J.add(J.add(v_x_582, J.mul((J.sub(v_m_585, 1.0) * 0.03), env["H"])), J.mul((sin(J.num(J.add(J.add(J.mul(env["at"], 2.0), v_m_585), v_j_580))) * 0.006), env["H"])), (J.mul(J.mul((-0.09), env["H"]), v_gr_584) * (1.2 if J.seq(v_m_585, 1.0) else 1.0))]], ("#7fbf4a" if J.seq(v_m_585, 1.0) else "#5f9a38"), J.max_([1.0, J.mul(0.02, env["H"])]), J.add((50.0 + J.mul(v_j_580, 3.0)), v_m_585)])
			v_m_585 = J.num(v_m_585) + 1.0
		J.mc(v_ctx_578, "restore", [])
		v_j_580 = J.num(v_j_580) + 1.0

func _f77(this_, a: Array, env):
	var v_a_561 = null; var v_R_562 = null; var v_in0_568 = null; var v_dip_570 = null; var v_up_571 = null; var v_step_573 = null; var v_front_574 = null; var v_i_575 = null; var v_p_576 = null; var v_q_577 = null
	var _s127 = {"__p": env, "this": null, "at": null, "v": null, "T": null, "H": null, "n": null, "body": null, "k": null}
	_s127["this"] = this_
	v_a_561 = J.arg(a, 0)
	v_R_562 = J.arg(a, 1)
	_s127["at"] = J.arg(a, 2)
	_s127["v"] = J.arg(a, 3)
	var _t447 = _s127["__p"]["sp"]
	_s127["T"] = J.div(1.0, J.cl(_t447, null, [_s127["v"]]))
	_s127["H"] = J.gp(v_a_561, "H")
	_s127["n"] = J.gp(_s127["v"], "n")
	v_in0_568 = 0.5
	_s127["body"] = J.sub(_s127["at"], v_in0_568)
	v_dip_570 = (({"bend": 30.0, "lean": 10.0, "head": 8.0, "hr": 35.0, "hy": 0.06, "hx": 0.03} if J.t(J.gp(v_R_562, "long")) else {"bend": 40.0, "lean": 14.0, "head": 10.0, "hy": 0.05, "hx": 0.03}) if J.t(J.gp(v_R_562, "arm")) else {"bend": 36.0, "lean": 20.0, "head": 16.0, "sy": 0.92})
	v_up_571 = ({"bend": 22.0, "lean": 6.0, "head": 4.0, "hy": 0.0} if J.t(J.gp(v_R_562, "arm")) else {"bend": 16.0, "lean": 6.0, "head": 4.0})
	_s127["k"] = null
	v_step_573 = 0.0
	if J.cmp(_s127["body"], 0.0, "<"):
		var _t448 = _s127["__p"]["kf"]
		var _t449 = J.cl(_t448, null, [[[0.0, {}], [v_in0_568, v_up_571, "io"]], _s127["at"]])
		_s127["k"] = _t449
	else:
		if J.cmp(_s127["body"], J.mul(_s127["n"], _s127["T"]), "<"):
			v_i_575 = floor(J.num(J.div(_s127["body"], _s127["T"])))
			v_p_576 = J.div(J.sub(_s127["body"], J.mul(v_i_575, _s127["T"])), _s127["T"])
			var _t450 = _s127["__p"]["kf"]
			var _t453 = [0.0, v_up_571]
			var _t454 = [0.35, v_dip_570, "io"]
			var _t452 = {}
			var _t451 = J.gp(v_dip_570, "sy")
			var _t455 = J.cl(_t450, null, [[_t453, _t454, [0.5, J.S_Object_("assign", [_t452, v_dip_570, {"sy": J.mul((_t451 if J.t(_t451) else 1.0), 0.97)}]), "o"], [0.75, v_up_571, "o"], [1.0, v_up_571]], v_p_576])
			_s127["k"] = _t455
			var _t456 = _s127["__p"]["seg"]
			var _t457 = J.add(v_i_575, J.mc(_s127["__p"]["E"], "io", [J.cl(_t456, null, [v_p_576, 0.75, 1.0])]))
			v_step_573 = _t457
		else:
			v_q_577 = J.sub(_s127["body"], J.mul(_s127["n"], _s127["T"]))
			var _t458 = _s127["__p"]["kf"]
			var _t459 = J.cl(_t458, null, [[[0.0, v_up_571], [0.6, {"lean": (-8.0), "bend": (-10.0), "head": (-10.0), "sy": 1.05, "hy": (-0.02)}, "o"], [1.1, {}, "io"]], v_q_577])
			_s127["k"] = _t459
			var _t461 = _s127["n"]
			var _t460 = _s127["__p"]["seg"]
			var _t462 = J.mul(_t461, J.sub(1.0, J.mc(_s127["__p"]["E"], "io", [J.cl(_t460, null, [v_q_577, 0.4, 1.1])])))
			v_step_573 = _t462
	var _t463 = _s127["k"]
	var _t464 = J.sub(J.gp(_t463, "dx"), J.mul(v_step_573, 0.07))
	J.sp(_t463, "dx", _t464)
	v_front_574 = Callable(self, "_f78").bind(_s127)
	return {"k": _s127["k"], "front": v_front_574}

func _f80(this_, a: Array, env):
	var v_R_590 = null; var v_k_591 = null
	v_R_590 = J.arg(a, 0)
	v_k_591 = J.arg(a, 1)
	if J.t(J.gp(v_R_590, "arm")):
		var _t472 = J.add(J.gp(v_k_591, "hr"), (J.sub(J.gp(v_k_591, "ang"), 60.0) * (0.45 if J.t(J.gp(v_R_590, "long")) else 0.15)))
		J.sp(v_k_591, "hr", _t472)
	return v_k_591

func _f84(this_, a: Array, env):
	var v_v_608 = null
	v_v_608 = J.arg(a, 0)
	var _t475 = (J.mul(J.gp(v_v_608, "n"), 1.6) + 0.6)
	var _t474 = env["sp"]
	return J.div(_t475, J.cl(_t474, null, [v_v_608]))

func _f86(this_, a: Array, env):
	var v_ctx_628 = null; var v_sh_629 = null; var v_ht_630 = null; var v_pw_631 = null; var v_g_632 = null
	v_ctx_628 = J.arg(a, 0)
	v_sh_629 = 0.0
	for _t485 in J.iter(env["hits"]):
		var _t486 = J.gp(_t485, 0.0)
		v_ht_630 = _t486
		var _t487 = J.gp(_t485, 1.0)
		v_pw_631 = _t487
		v_g_632 = J.sub(env["at"], v_ht_630)
		var _t488 = J.cmp(v_g_632, 0.0, ">")
		if (J.cmp(v_g_632, 0.12, "<") if _t488 else _t488):
			var _t489 = J.mul(J.mul((sin(J.num(((J.div(v_g_632, 0.12) * PI) * 2.0))) * 0.012), env["H"]), v_pw_631)
			v_sh_629 = _t489
	var _t490 = env["__p"]["drawBench"]
	J.cl(_t490, null, [v_ctx_628, env["B"], env["H"], v_sh_629])

func _f87(this_, a: Array, env):
	var v_ctx_633 = null; var v_P_634 = null; var v_hx_635 = null; var v_ht_636 = null; var v_pw_637 = null; var v_g_638 = null
	v_ctx_633 = J.arg(a, 0)
	v_P_634 = J.arg(a, 1)
	v_hx_635 = (J.gp(J.gp(v_P_634, "tip"), 0.0) if J.t(J.gp(v_P_634, "tip")) else J.gp(J.gp(v_P_634, "mouth"), 0.0))
	for _t491 in J.iter(env["hits"]):
		var _t492 = J.gp(_t491, 0.0)
		v_ht_636 = _t492
		var _t493 = J.gp(_t491, 1.0)
		v_pw_637 = _t493
		v_g_638 = J.sub(env["at"], v_ht_636)
		var _t494 = env["__p"]["spark"]
		J.cl(_t494, null, [v_ctx_633, v_hx_635, ((-J.num(J.gp(env["B"], "top"))) + J.mul(0.02, env["H"])), v_g_638, J.mul((0.3 if J.cmp(v_pw_637, 0.5, ">") else 0.16), env["H"])])
		if J.cmp(v_pw_637, 0.5, ">"):
			var _t495 = env["__p"]["puff"]
			J.cl(_t495, null, [v_ctx_633, v_hx_635, ((-J.num(J.gp(env["B"], "top"))) + J.mul(0.04, env["H"])), v_g_638, 0.45, J.mul(0.22, env["H"]), (4.0 + J.mul(v_ht_636, 10.0)), "wood"])

func _f85(this_, a: Array, env):
	var v_a_611 = null; var v_R_612 = null; var v_v_614 = null; var v_s_615 = null; var v_t_616 = null; var v_T_619 = null; var v_i_620 = null; var v_p_621 = null; var v_k_622 = null; var v_back_624 = null; var v_front_625 = null; var v_j_626 = null; var v_b_627 = null
	var _s141 = {"__p": env, "at": null, "H": null, "B": null, "hits": null}
	v_a_611 = J.arg(a, 0)
	v_R_612 = J.arg(a, 1)
	_s141["at"] = J.arg(a, 2)
	v_v_614 = J.arg(a, 3)
	var _t476 = _s141["__p"]["sp"]
	v_s_615 = J.cl(_t476, null, [v_v_614])
	v_t_616 = J.mul(_s141["at"], v_s_615)
	_s141["H"] = J.gp(v_a_611, "H")
	var _t477 = _s141["__p"]["benchOf"]
	_s141["B"] = J.cl(_t477, null, [v_a_611, v_R_612])
	v_T_619 = 1.6
	v_i_620 = floor(J.num(J.div(v_t_616, v_T_619)))
	v_p_621 = J.sub(v_t_616, J.mul(v_i_620, v_T_619))
	v_k_622 = null
	_s141["hits"] = []
	if J.cmp(v_i_620, J.gp(v_v_614, "n"), "<"):
		var _t478 = _s141["__p"]["hamRot"]
		var _t479 = _s141["__p"]["hammerKeys"]
		var _t480 = J.cl(_t478, null, [v_R_612, J.cl(_t479, null, [v_R_612, v_p_621])])
		v_k_622 = _t480
	else:
		var _t481 = _s141["__p"]["hamRot"]
		var _t482 = _s141["__p"]["kf"]
		var _t483 = _s141["__p"]["hammerKeys"]
		var _t484 = J.cl(_t481, null, [v_R_612, J.cl(_t482, null, [[[0.0, J.cl(_t483, null, [v_R_612, 1.6])], [0.6, ({"ang": 45.0} if J.t(J.gp(v_R_612, "arm")) else {}), "io"]], v_p_621])])
		v_k_622 = _t484
	v_j_626 = 0.0
	while true:
		if not J.cmp(v_j_626, J.gp(v_v_614, "n"), "<"): break
		v_b_627 = J.mul(v_j_626, v_T_619)
		J.mc(_s141["hits"], "push", [[J.div(J.add(v_b_627, 0.26), v_s_615), 0.4], [J.div(J.add(v_b_627, 0.44), v_s_615), 0.4], [J.div(J.add(v_b_627, 1.08), v_s_615), 1.0]])
		v_j_626 = J.num(v_j_626) + 1.0
	v_back_624 = Callable(self, "_f86").bind(_s141)
	v_front_625 = Callable(self, "_f87").bind(_s141)
	var _t496 = J.gp(v_R_612, "arm")
	return {"k": v_k_622, "tool": "mallet", "back": v_back_624, "front": v_front_625, "toolBehind": (J.cmp(J.gp(v_k_622, "ang"), (-20.0), "<") if J.t(_t496) else _t496)}

func _f88(this_, a: Array, env):
	var v_v_639 = null
	v_v_639 = J.arg(a, 0)
	var _t500 = (J.mul(J.gp(v_v_639, "n"), 0.9) + 0.8)
	var _t499 = env["sp"]
	return J.div(_t500, J.cl(_t499, null, [v_v_639]))

func _f90(this_, a: Array, env):
	var v_ctx_661 = null
	v_ctx_661 = J.arg(a, 0)
	var _t509 = env["__p"]["drawBench"]
	return J.cl(_t509, null, [v_ctx_661, env["B"], env["H"], 0.0])

func _f91(this_, a: Array, env):
	var v_ctx_662 = null; var v_P_663 = null; var v_j_664 = null; var v_g_665 = null; var v_x_666 = null
	v_ctx_662 = J.arg(a, 0)
	v_P_663 = J.arg(a, 1)
	v_j_664 = 0.0
	while true:
		if not J.cmp(v_j_664, env["n"], "<"): break
		v_g_665 = J.div(J.sub(env["b"], (J.mul(v_j_664, env["T"]) + J.mul(0.45, env["T"]))), env["s"])
		v_x_666 = J.add(J.gp(env["B"], "x"), J.mul(0.18, env["H"]))
		var _t510 = env["__p"]["puff"]
		J.cl(_t510, null, [v_ctx_662, J.add(v_x_666, J.mul((J.mod(v_j_664, 2.0) * 0.04), env["H"])), ((-J.num(J.gp(env["B"], "top"))) + J.mul(0.03, env["H"])), v_g_665, 0.55, J.mul(0.2, env["H"]), J.add(J.add(30.0, v_j_664), J.gp(env["v"], "seed")), "wood"])
		v_j_664 = J.num(v_j_664) + 1.0

func _f89(this_, a: Array, env):
	var v_a_642 = null; var v_R_643 = null; var v_at_644 = null; var v_t_647 = null; var v_in0_652 = null; var v_rest_654 = null; var v_push_655 = null; var v_pull_656 = null; var v_k_657 = null; var v_back_658 = null; var v_front_659 = null; var v_p_660 = null
	var _s151 = {"__p": env, "v": null, "s": null, "H": null, "B": null, "T": null, "n": null, "b": null}
	v_a_642 = J.arg(a, 0)
	v_R_643 = J.arg(a, 1)
	v_at_644 = J.arg(a, 2)
	_s151["v"] = J.arg(a, 3)
	var _t501 = _s151["__p"]["sp"]
	_s151["s"] = J.cl(_t501, null, [_s151["v"]])
	v_t_647 = J.mul(v_at_644, _s151["s"])
	_s151["H"] = J.gp(v_a_642, "H")
	var _t502 = _s151["__p"]["benchOf"]
	_s151["B"] = J.cl(_t502, null, [v_a_642, v_R_643])
	_s151["T"] = 0.9
	_s151["n"] = J.gp(_s151["v"], "n")
	v_in0_652 = 0.4
	_s151["b"] = J.sub(v_t_647, v_in0_652)
	v_rest_654 = ({"bend": 14.0, "lean": 6.0, "hy": 0.02} if J.t(J.gp(v_R_643, "arm")) else {"bend": 18.0, "lean": 10.0})
	v_push_655 = ({"bend": 20.0, "lean": 12.0, "dx": 0.06, "hx": 0.06, "hy": 0.03, "sy": 0.96, "sx": 1.03, "head": 6.0} if J.t(J.gp(v_R_643, "arm")) else {"bend": 24.0, "lean": 16.0, "dx": 0.1, "sy": 0.94, "sx": 1.05, "head": 8.0})
	v_pull_656 = ({"bend": 12.0, "lean": 3.0, "dx": (-0.02), "hx": (-0.02), "hy": 0.02, "head": 2.0} if J.t(J.gp(v_R_643, "arm")) else {"bend": 14.0, "lean": 6.0, "dx": (-0.02)})
	v_k_657 = null
	if J.cmp(_s151["b"], 0.0, "<"):
		var _t503 = _s151["__p"]["kf"]
		var _t504 = J.cl(_t503, null, [[[0.0, {}], [v_in0_652, v_rest_654]], v_t_647])
		v_k_657 = _t504
	else:
		if J.cmp(_s151["b"], J.mul(_s151["n"], _s151["T"]), "<"):
			v_p_660 = J.div(J.mod(_s151["b"], _s151["T"]), _s151["T"])
			var _t505 = _s151["__p"]["kf"]
			var _t506 = J.cl(_t505, null, [[[0.0, v_pull_656], [0.45, v_push_655, "io"], [0.6, v_push_655], [1.0, v_pull_656, "io"]], v_p_660])
			v_k_657 = _t506
		else:
			var _t507 = _s151["__p"]["kf"]
			var _t508 = J.cl(_t507, null, [[[0.0, v_pull_656], [0.4, {}, "io"]], J.sub(_s151["b"], J.mul(_s151["n"], _s151["T"]))])
			v_k_657 = _t508
	v_back_658 = Callable(self, "_f90").bind(_s151)
	v_front_659 = Callable(self, "_f91").bind(_s151)
	return {"k": v_k_657, "back": v_back_658, "front": v_front_659}

func _f92(this_, a: Array, env):
	var v_v_667 = null
	v_v_667 = J.arg(a, 0)
	var _t513 = env["sp"]
	return J.div(3.4, J.cl(_t513, null, [v_v_667]))

func _f94(this_, a: Array, env):
	var v_ctx_681 = null
	v_ctx_681 = J.arg(a, 0)
	var _t518 = env["__p"]["drawBench"]
	return J.cl(_t518, null, [v_ctx_681, env["B"], env["H"], 0.0, env["lifted"]])

func _f95(this_, a: Array, env):
	var v_ctx_682 = null; var v_P_683 = null; var v_q_684 = null; var v_hold_685 = null; var v_rest_686 = null; var v_x_687 = null; var v_y_688 = null
	v_ctx_682 = J.arg(a, 0)
	v_P_683 = J.arg(a, 1)
	if (not J.t(env["lifted"])):
		return null
	var _t519 = env["__p"]["seg"]
	var _t521 = J.mc(env["__p"]["E"], "io", [J.cl(_t519, null, [env["t"], 0.62, 1.2])])
	var _t520 = env["__p"]["seg"]
	v_q_684 = J.mul(_t521, J.sub(1.0, J.mc(env["__p"]["E"], "io", [J.cl(_t520, null, [env["t"], 2.3, 2.85])])))
	v_hold_685 = [J.add(J.gp(J.gp(v_P_683, "G"), 0.0), J.mul(0.05, env["H"])), J.sub(J.gp(J.gp(v_P_683, "G"), 1.0), J.mul(0.02, env["H"]))]
	v_rest_686 = [J.gp(env["B"], "x"), ((-J.num(J.gp(env["B"], "top"))) + J.mul(0.06, env["H"]))]
	var _t522 = env["__p"]["lerp"]
	v_x_687 = J.cl(_t522, null, [J.gp(v_rest_686, 0.0), J.gp(v_hold_685, 0.0), v_q_684])
	var _t523 = env["__p"]["lerp"]
	v_y_688 = J.cl(_t523, null, [J.gp(v_rest_686, 1.0), J.gp(v_hold_685, 1.0), v_q_684])
	var _t524 = env["__p"]["prop"]
	J.cl(_t524, null, [v_ctx_682, "fx_plank", v_x_687, v_y_688, (J.mul(0.52, env["H"]) * (1.0 - J.mul(0.3, v_q_684))), ((-J.num(v_q_684)) * 62.0), {"an": [0.5, 0.8]}])
	if (not J.t(J.gp(env["R"], "arm"))):
		var _t525 = env["__p"]["wisp"]
		J.cl(_t525, null, [v_ctx_682, J.gp(v_P_683, "belly"), [v_x_687, v_y_688], env["H"], 3.0, v_q_684])

func _f93(this_, a: Array, env):
	var v_a_670 = null; var v_at_672 = null; var v_v_673 = null; var v_k_677 = null; var v_back_679 = null; var v_front_680 = null
	var _s158 = {"__p": env, "R": null, "t": null, "H": null, "B": null, "lifted": null}
	v_a_670 = J.arg(a, 0)
	_s158["R"] = J.arg(a, 1)
	v_at_672 = J.arg(a, 2)
	v_v_673 = J.arg(a, 3)
	var _t514 = _s158["__p"]["sp"]
	_s158["t"] = J.mul(v_at_672, J.cl(_t514, null, [v_v_673]))
	_s158["H"] = J.gp(v_a_670, "H")
	var _t515 = _s158["__p"]["benchOf"]
	_s158["B"] = J.cl(_t515, null, [v_a_670, _s158["R"]])
	var _t516 = _s158["__p"]["kf"]
	v_k_677 = J.cl(_t516, null, [[[0.0, {}], [0.5, {"bend": 14.0, "lean": 6.0, "hy": 0.03}, "io"], [0.75, {"bend": 10.0, "lean": 2.0, "sy": 0.95}, "o"], [1.2, {"bend": (-6.0), "lean": (-5.0), "head": (-12.0), "hy": (-0.06), "sy": 1.03}, "o"], [1.7, {"bend": (-7.0), "lean": (-6.0), "head": (-4.0), "hy": (-0.06)}, "io"], [2.0, {"bend": (-7.0), "lean": (-6.0), "head": (-16.0), "hy": (-0.06)}, "io"], [2.2, {"bend": (-6.0), "lean": (-5.0), "head": (-8.0), "hy": (-0.06)}, "io"], [2.85, {"bend": 14.0, "lean": 6.0, "hy": 0.03}, "io"], [3.4, {}, "io"]], _s158["t"]])
	var _t517 = J.cmp(_s158["t"], 0.62, ">")
	_s158["lifted"] = (J.cmp(_s158["t"], 2.85, "<") if _t517 else _t517)
	v_back_679 = Callable(self, "_f94").bind(_s158)
	v_front_680 = Callable(self, "_f95").bind(_s158)
	return {"k": v_k_677, "back": v_back_679, "front": v_front_680}

func _f99(this_, a: Array, env):
	var v_v_704 = null
	v_v_704 = J.arg(a, 0)
	var _t529 = (J.mul(J.gp(v_v_704, "n"), 0.85) + 0.9)
	var _t528 = env["sp"]
	return J.div(_t529, J.cl(_t528, null, [v_v_704]))

func _f101(this_, a: Array, env):
	var v_ctx_730 = null
	v_ctx_730 = J.arg(a, 0)
	var _t552 = env["__p"]["drawCounter"]
	return J.cl(_t552, null, [v_ctx_730, env["C"], env["H"]])

func _f102(this_, a: Array, env):
	var v_ctx_731 = null; var v_dw_732 = null
	v_ctx_731 = J.arg(a, 0)
	v_dw_732 = J.mul(0.26, env["H"])
	var _t553 = env["__p"]["prop"]
	J.cl(_t553, null, [v_ctx_731, "fx_dough", J.add(J.gp(env["C"], "x"), J.mul(J.mul(env["roll"], 0.04), env["H"])), ((-J.num(J.gp(env["C"], "top"))) + J.mul(0.03, env["H"])), J.mul(v_dw_732, (1.0 + J.mul(0.3, env["dq"]))), J.mul(env["roll"], 8.0), {"an": [0.5, 0.9], "sy": (1.0 - J.mul(0.4, env["dq"]))}])

func _f103(this_, a: Array, env):
	var v_ctx_733 = null; var v_j_734 = null
	v_ctx_733 = J.arg(a, 0)
	v_j_734 = 0.0
	while true:
		if not J.cmp(v_j_734, env["n"], "<"): break
		var _t554 = env["__p"]["puff"]
		J.cl(_t554, null, [v_ctx_733, J.gp(env["C"], "x"), (-J.num(J.gp(env["C"], "top"))), J.div(J.sub(env["b"], (J.mul(v_j_734, env["T"]) + J.mul(0.32, env["T"]))), env["s"]), 0.5, J.mul(0.22, env["H"]), J.add(J.add(40.0, v_j_734), J.gp(env["v"], "seed")), "flour"])
		v_j_734 = J.num(v_j_734) + 1.0

func _f104(this_, a: Array, env):
	var v_c_735 = null
	v_c_735 = J.arg(a, 0)
	var _t555 = env["back"]
	J.cl(_t555, null, [v_c_735])
	var _t556 = env["dough"]
	J.cl(_t556, null, [v_c_735])

func _f105(this_, a: Array, env):
	var v_c_736 = null
	v_c_736 = J.arg(a, 0)
	var _t557 = env["back"]
	J.cl(_t557, null, [v_c_736])
	var _t558 = env["dough"]
	J.cl(_t558, null, [v_c_736])

func _f100(this_, a: Array, env):
	var v_a_707 = null; var v_R_708 = null; var v_at_709 = null; var v_t_712 = null; var v_in0_717 = null; var v_k_719 = null; var v_front_724 = null; var v_up_725 = null; var v_press_726 = null; var v_p_727 = null; var v_sit_728 = null; var v_p_729 = null
	var _s165 = {"__p": env, "v": null, "s": null, "H": null, "C": null, "T": null, "n": null, "b": null, "dq": null, "roll": null, "back": null, "dough": null}
	v_a_707 = J.arg(a, 0)
	v_R_708 = J.arg(a, 1)
	v_at_709 = J.arg(a, 2)
	_s165["v"] = J.arg(a, 3)
	var _t530 = _s165["__p"]["sp"]
	_s165["s"] = J.cl(_t530, null, [_s165["v"]])
	v_t_712 = J.mul(v_at_709, _s165["s"])
	_s165["H"] = J.gp(v_a_707, "H")
	var _t531 = _s165["__p"]["counterOf"]
	_s165["C"] = J.cl(_t531, null, [v_a_707, v_R_708])
	_s165["T"] = 0.85
	_s165["n"] = J.gp(_s165["v"], "n")
	v_in0_717 = 0.45
	_s165["b"] = J.sub(v_t_712, v_in0_717)
	v_k_719 = null
	_s165["dq"] = 0.0
	_s165["roll"] = 0.0
	if J.t(J.gp(v_R_708, "arm")):
		v_up_725 = {"bend": 10.0, "lean": 4.0, "hy": 0.0}
		v_press_726 = {"bend": 18.0, "lean": 9.0, "hy": 0.05, "sy": 0.93, "sx": 1.04, "dy": 0.01, "head": 6.0}
		if J.cmp(_s165["b"], 0.0, "<"):
			var _t532 = _s165["__p"]["kf"]
			var _t533 = J.cl(_t532, null, [[[0.0, {}], [v_in0_717, v_up_725]], v_t_712])
			v_k_719 = _t533
		else:
			if J.cmp(_s165["b"], J.mul(_s165["n"], _s165["T"]), "<"):
				v_p_727 = J.div(J.mod(_s165["b"], _s165["T"]), _s165["T"])
				var _t534 = _s165["__p"]["kf"]
				var _t535 = J.cl(_t534, null, [[[0.0, v_up_725], [0.32, v_press_726, "i"], [0.45, v_press_726], [0.62, v_up_725, "o"], [0.8, J.S_Object_("assign", [{}, v_up_725, {"hx": 0.04, "hy": 0.02}]), "io"], [1.0, v_up_725, "io"]], v_p_727])
				v_k_719 = _t535
				var _t536 = _s165["__p"]["seg"]
				var _t537 = _s165["__p"]["seg"]
				var _t538 = J.max_([0.0, sin(J.num(J.mul(J.cl(_t537, null, [v_p_727, 0.2, 0.6]), PI)))])
				_s165["dq"] = _t538
				var _t539 = _s165["__p"]["seg"]
				var _t540 = sin(J.num(J.mul(J.cl(_t539, null, [v_p_727, 0.62, 1.0]), PI)))
				_s165["roll"] = _t540
			else:
				var _t541 = _s165["__p"]["kf"]
				var _t542 = J.cl(_t541, null, [[[0.0, v_up_725], [0.45, {}, "io"]], J.sub(_s165["b"], J.mul(_s165["n"], _s165["T"]))])
				v_k_719 = _t542
	else:
		v_sit_728 = {"dy": (J.div((-J.num(J.gp(_s165["C"], "top"))), _s165["H"]) + 0.06), "dx": 0.4, "sy": 0.84, "sx": 1.15}
		if J.cmp(_s165["b"], 0.0, "<"):
			var _t543 = _s165["__p"]["kf"]
			var _t544 = J.cl(_t543, null, [[[0.0, {}], [J.mul(v_in0_717, 0.6), {"sy": 0.88, "sx": 1.08}, "o"], [v_in0_717, {"dy": (J.div((-J.num(J.gp(_s165["C"], "top"))), _s165["H"]) - 0.12), "dx": 0.3, "sy": 1.08}, "o"]], v_t_712])
			v_k_719 = _t544
		else:
			if J.cmp(_s165["b"], J.mul(_s165["n"], _s165["T"]), "<"):
				v_p_729 = J.div(J.mod(_s165["b"], _s165["T"]), _s165["T"])
				var _t545 = _s165["__p"]["kf"]
				var _t546 = J.cl(_t545, null, [[[0.0, {"dy": (J.div((-J.num(J.gp(_s165["C"], "top"))), _s165["H"]) - 0.12), "dx": 0.38, "sy": 1.06}], [0.35, v_sit_728, "i3"], [0.5, J.S_Object_("assign", [{}, v_sit_728, {"sy": 0.9}]), "o"], [1.0, {"dy": (J.div((-J.num(J.gp(_s165["C"], "top"))), _s165["H"]) - 0.12), "dx": 0.38, "sy": 1.06}, "o"]], v_p_729])
				v_k_719 = _t546
				var _t547 = _s165["__p"]["seg"]
				var _t548 = _s165["__p"]["seg"]
				var _t549 = J.max_([0.0, sin(J.num(J.mul(J.cl(_t548, null, [v_p_729, 0.3, 0.7]), PI)))])
				_s165["dq"] = _t549
			else:
				var _t550 = _s165["__p"]["kf"]
				var _t551 = J.cl(_t550, null, [[[0.0, {"dy": (J.div((-J.num(J.gp(_s165["C"], "top"))), _s165["H"]) - 0.12), "dx": 0.38}], [0.5, {}, "io"], [0.7, {"sy": 0.94}, "o"], [0.9, {}, "io"]], J.sub(_s165["b"], J.mul(_s165["n"], _s165["T"]))])
				v_k_719 = _t551
	_s165["back"] = Callable(self, "_f101").bind(_s165)
	_s165["dough"] = Callable(self, "_f102").bind(_s165)
	v_front_724 = Callable(self, "_f103").bind(_s165)
	return ({"k": v_k_719, "back": Callable(self, "_f104").bind(_s165), "front": v_front_724} if J.t(J.gp(v_R_708, "arm")) else {"k": v_k_719, "back": Callable(self, "_f105").bind(_s165), "front": v_front_724})

func _f106(this_, a: Array, env):
	var v_v_737 = null
	v_v_737 = J.arg(a, 0)
	var _t561 = env["sp"]
	return J.div(3.6, J.cl(_t561, null, [v_v_737]))

func _f108(this_, a: Array, env):
	var v_ctx_756 = null
	v_ctx_756 = J.arg(a, 0)
	var _t567 = env["__p"]["prop"]
	var _t571 = env["cx"]
	var _t572 = J.mul(0.26, env["H"])
	var _t570 = [0.5, 1.0]
	var _t569 = env["baseTop"]
	var _t568 = env["__p"]["propH"]
	J.cl(_t567, null, [v_ctx_756, "store__crate", _t571, 0.5, _t572, 0.0, {"an": _t570, "sy": J.div(_t569, J.mul(J.cl(_t568, null, ["store__crate", J.mul(0.26, env["H"])]), 0.9))}])
	var _t573 = env["__p"]["prop"]
	J.cl(_t573, null, [v_ctx_756, "bun__basket", env["cx"], ((-J.num(env["baseTop"])) + J.mul(0.01, env["H"])), env["bw"], 0.0, {"an": [0.5, 0.95]}])

func _f109(this_, a: Array, env):
	var v_ctx_757 = null; var v_P_758 = null; var v_q_759 = null; var v_rest_760 = null; var v_hold_761 = null; var v_x_762 = null; var v_y_763 = null
	v_ctx_757 = J.arg(a, 0)
	v_P_758 = J.arg(a, 1)
	var _t574 = env["__p"]["seg"]
	var _t576 = J.mc(env["__p"]["E"], "io", [J.cl(_t574, null, [env["t"], 0.62, 0.95])])
	var _t575 = env["__p"]["seg"]
	v_q_759 = J.mul(_t576, J.sub(1.0, J.mc(env["__p"]["E"], "io", [J.cl(_t575, null, [env["t"], 2.4, 2.9])])))
	v_rest_760 = [env["cx"], ((-J.num(env["baseTop"])) - J.mul(env["bh"], 0.62))]
	v_hold_761 = ([J.add(J.gp(J.gp(v_P_758, "G"), 0.0), J.mul(0.02, env["H"])), J.add(J.gp(J.gp(v_P_758, "G"), 1.0), J.mul(0.06, env["H"]))] if J.t(J.gp(env["R"], "arm")) else [J.sub(env["cx"], J.mul(0.02, env["H"])), (J.sub((-J.num(env["baseTop"])), env["bh"]) - J.mul(0.3, env["H"]))])
	var _t577 = env["__p"]["lerp"]
	v_x_762 = J.cl(_t577, null, [J.gp(v_rest_760, 0.0), J.gp(v_hold_761, 0.0), v_q_759])
	var _t578 = env["__p"]["lerp"]
	v_y_763 = J.cl(_t578, null, [J.gp(v_rest_760, 1.0), J.gp(v_hold_761, 1.0), v_q_759])
	var _t579 = env["__p"]["steam"]
	J.cl(_t579, null, [v_ctx_757, env["cx"], ((-J.num(env["baseTop"])) - J.mul(env["bh"], 0.5)), J.sub(env["t"], 0.85), 1.2, env["H"], J.add(60.0, J.gp(env["v"], "seed")), 4.0])
	var _t580 = env["__p"]["prop"]
	var _t583 = env["lidW"]
	var _t582 = J.mul(v_q_759, ((-10.0) if J.t(J.gp(env["R"], "arm")) else 6.0))
	var _t581 = J.cmp(env["t"], 2.9, ">")
	J.cl(_t580, null, [v_ctx_757, "bun__steamer", v_x_762, v_y_763, _t583, (_t582 + ((sin(J.num((J.sub(env["t"], 2.9) * 60.0))) * 2.0) if (J.cmp(env["t"], 3.1, "<") if _t581 else _t581) else 0.0)), {"an": [0.5, 1.0]}])
	var _t584 = (not J.t(J.gp(env["R"], "arm")))
	if (J.cmp(v_q_759, 0.02, ">") if _t584 else _t584):
		var _t585 = env["__p"]["wisp"]
		J.cl(_t585, null, [v_ctx_757, J.gp(v_P_758, "top"), [v_x_762, J.sub(v_y_763, J.mul(env["lidH"], 0.3))], env["H"], 8.0, v_q_759])

func _f107(this_, a: Array, env):
	var v_a_740 = null; var v_at_742 = null; var v_C_746 = null; var v_k_748 = null; var v_back_754 = null; var v_front_755 = null
	var _s177 = {"__p": env, "R": null, "v": null, "t": null, "H": null, "cx": null, "bw": null, "bh": null, "baseTop": null, "lidW": null, "lidH": null}
	v_a_740 = J.arg(a, 0)
	_s177["R"] = J.arg(a, 1)
	v_at_742 = J.arg(a, 2)
	_s177["v"] = J.arg(a, 3)
	var _t562 = _s177["__p"]["sp"]
	_s177["t"] = J.mul(v_at_742, J.cl(_t562, null, [_s177["v"]]))
	_s177["H"] = J.gp(v_a_740, "H")
	var _t563 = _s177["__p"]["counterOf"]
	v_C_746 = J.cl(_t563, null, [v_a_740, _s177["R"]])
	_s177["cx"] = (J.gp(v_C_746, "x") if J.t(J.gp(_s177["R"], "arm")) else J.mul(0.36, _s177["H"]))
	var _t564 = _s177["__p"]["kf"]
	v_k_748 = J.cl(_t564, null, [[[0.0, {}], [0.45, {"bend": 12.0, "lean": 5.0, "hy": 0.03}, "io"], [0.65, {"bend": 8.0, "lean": 2.0, "sy": 0.95}, "o"], [0.95, {"bend": (-2.0), "lean": (-2.0), "hy": (-0.06), "sy": 1.03}, "o"], [1.1, {"bend": (-12.0), "lean": (-14.0), "head": (-16.0), "dx": (-0.06), "hy": (-0.06), "sy": 1.06, "sx": 0.95}, "o"], [1.6, {"bend": (-8.0), "lean": (-8.0), "head": (-10.0), "dx": (-0.05), "hy": (-0.04), "hr": 25.0}, "io"], [1.8, {"bend": (-8.0), "lean": (-8.0), "head": (-10.0), "dx": (-0.05), "hy": (-0.04), "hr": (-25.0)}, "io"], [2.0, {"bend": (-8.0), "lean": (-8.0), "head": (-10.0), "dx": (-0.05), "hy": (-0.04), "hr": 25.0}, "io"], [2.2, {"bend": (-6.0), "lean": (-6.0), "head": (-6.0), "dx": (-0.04), "hy": (-0.04)}, "io"], [2.9, {"bend": 12.0, "lean": 5.0, "hy": 0.03}, "io"], [3.6, {}, "io"]], _s177["t"]])
	if (not J.t(J.gp(_s177["R"], "arm"))):
		J.sp(v_k_748, "hr", 0.0)
	_s177["bw"] = J.mul(0.34, _s177["H"])
	var _t565 = _s177["__p"]["propH"]
	_s177["bh"] = J.cl(_t565, null, ["bun__basket", _s177["bw"]])
	_s177["baseTop"] = J.mul(0.12, _s177["H"])
	_s177["lidW"] = J.mul(0.32, _s177["H"])
	var _t566 = _s177["__p"]["propH"]
	_s177["lidH"] = J.cl(_t566, null, ["bun__steamer", _s177["lidW"]])
	v_back_754 = Callable(self, "_f108").bind(_s177)
	v_front_755 = Callable(self, "_f109").bind(_s177)
	return {"k": v_k_748, "back": v_back_754, "front": v_front_755}

func _f110(this_, a: Array, env):
	var v_v_764 = null
	v_v_764 = J.arg(a, 0)
	var _t588 = env["sp"]
	return J.div(5.0, J.cl(_t588, null, [v_v_764]))

func _f112(this_, a: Array, env):
	var v_ctx_785 = null
	v_ctx_785 = J.arg(a, 0)
	var _t612 = env["__p"]["prop"]
	var _t616 = env["bx"]
	var _t617 = J.mul(0.26, env["H"])
	var _t615 = [0.5, 1.0]
	var _t614 = env["baseTop"]
	var _t613 = env["__p"]["propH"]
	J.cl(_t612, null, [v_ctx_785, "store__crate", _t616, 0.5, _t617, 0.0, {"an": _t615, "sy": J.div(_t614, J.mul(J.cl(_t613, null, ["store__crate", J.mul(0.26, env["H"])]), 0.9))}])
	var _t618 = env["__p"]["prop"]
	J.cl(_t618, null, [v_ctx_785, "bun__basket", env["bx"], ((-J.num(env["baseTop"])) + J.mul(0.01, env["H"])), J.mul(0.34, env["H"]), 0.0, {"an": [0.5, 0.95]}])

func _f114(this_, a: Array, env):
	var v_c_793 = null; var v_px_794 = null; var v_py_795 = null; var v_i_796 = null; var v_al_797 = null
	v_c_793 = J.arg(a, 0)
	v_px_794 = J.arg(a, 1)
	v_py_795 = J.arg(a, 2)
	v_i_796 = J.arg(a, 3)
	v_al_797 = J.arg(a, 4)
	J.mc(v_c_793, "save", [])
	var _t629 = J.mul(J.gp(v_c_793, "globalAlpha"), v_al_797)
	J.sp(v_c_793, "globalAlpha", _t629)
	J.sp(v_c_793, "fillStyle", "#f4ead8")
	J.mc(v_c_793, "beginPath", [])
	J.mc(v_c_793, "arc", [v_px_794, v_py_795, J.mul(env["H"], 0.012), 0.0, env["__p"]["TAU"]])
	J.mc(v_c_793, "fill", [])
	J.mc(v_c_793, "restore", [])

func _f113(this_, a: Array, env):
	var v_ctx_786 = null; var v_P_787 = null; var v_g_788 = null; var v_from_789 = null; var v_to_790 = null; var v_p_791 = null; var v_j_792 = null
	v_ctx_786 = J.arg(a, 0)
	v_P_787 = J.arg(a, 1)
	var _t619 = J.cmp(env["t"], 1.85, ">")
	var _t620 = (J.cmp(env["t"], 3.6, "<") if _t619 else _t619)
	if (J.cmp(env["bs"], 0.0, ">") if _t620 else _t620):
		var _t621 = env["__p"]["seg"]
		v_g_788 = J.cl(_t621, null, [env["t"], 1.85, 2.3])
		v_from_789 = [env["bx"], ((-J.num(env["baseTop"])) - J.mul(0.08, env["H"]))]
		v_to_790 = ([J.gp(J.gp(v_P_787, "G"), 0.0), J.gp(J.gp(v_P_787, "G"), 1.0)] if J.t(J.gp(env["R"], "arm")) else [J.add(J.gp(J.gp(v_P_787, "mouth"), 0.0), J.mul(0.02, env["H"])), J.add(J.gp(J.gp(v_P_787, "mouth"), 1.0), J.mul(0.02, env["H"]))])
		var _t625 = null
		if J.t(J.gp(env["R"], "arm")):
			_t625 = v_to_790
		else:
			var _t622 = env["__p"]["lerp"]
			var _t624 = J.cl(_t622, null, [J.gp(v_from_789, 0.0), J.gp(v_to_790, 0.0), J.mc(env["__p"]["E"], "io", [v_g_788])])
			var _t623 = env["__p"]["lerp"]
			_t625 = [_t624, J.sub(J.cl(_t623, null, [J.gp(v_from_789, 1.0), J.gp(v_to_790, 1.0), J.mc(env["__p"]["E"], "io", [v_g_788])]), J.mul((sin(J.num(J.mul(v_g_788, PI))) * 0.05), env["H"]))]
		v_p_791 = _t625
		var _t626 = env["__p"]["prop"]
		J.cl(_t626, null, [v_ctx_786, "bun__bun", J.gp(v_p_791, 0.0), J.gp(v_p_791, 1.0), J.mul(env["bunW"], env["bs"]), 0.0, {"an": [0.5, 0.6]}])
		if (not J.t(J.gp(env["R"], "arm"))):
			var _t627 = env["__p"]["wisp"]
			J.cl(_t627, null, [v_ctx_786, J.gp(v_P_787, "mouth"), v_p_791, env["H"], 5.0, J.sub(1.0, v_g_788)])
	v_j_792 = 0.0
	while true:
		if not J.cmp(v_j_792, 3.0, "<"): break
		var _t628 = env["__p"]["spray"]
		J.cl(_t628, null, [v_ctx_786, J.gp(J.gp(v_P_787, "mouth"), 0.0), J.add(J.gp(J.gp(v_P_787, "mouth"), 1.0), J.mul(0.03, env["H"])), J.sub(env["t"], (2.5 + J.mul(v_j_792, 0.38))), 0.4, 3.0, J.add(70.0, v_j_792), env["H"], {"up": 0.3, "v": 0.5, "g": 4.0}, Callable(self, "_f114").bind(env)])
		v_j_792 = J.num(v_j_792) + 1.0
	if J.cmp(env["t"], 4.0, ">"):
		var _t630 = env["__p"]["twinkle"]
		J.cl(_t630, null, [v_ctx_786, J.add(J.gp(J.gp(v_P_787, "top"), 0.0), J.mul(0.1, env["H"])), J.add(J.gp(J.gp(v_P_787, "top"), 1.0), J.mul(0.1, env["H"])), J.sub(env["t"], 4.0), env["H"], 9.0])

func _f116(this_, a: Array, env):
	var v_c_805 = null; var v_px_806 = null; var v_py_807 = null; var v_i_808 = null; var v_al_809 = null
	v_c_805 = J.arg(a, 0)
	v_px_806 = J.arg(a, 1)
	v_py_807 = J.arg(a, 2)
	v_i_808 = J.arg(a, 3)
	v_al_809 = J.arg(a, 4)
	J.mc(v_c_805, "save", [])
	var _t640 = J.mul(J.gp(v_c_805, "globalAlpha"), v_al_809)
	J.sp(v_c_805, "globalAlpha", _t640)
	J.sp(v_c_805, "fillStyle", "#f4ead8")
	J.mc(v_c_805, "beginPath", [])
	J.mc(v_c_805, "arc", [v_px_806, v_py_807, J.mul(env["H"], 0.012), 0.0, env["__p"]["TAU"]])
	J.mc(v_c_805, "fill", [])
	J.mc(v_c_805, "restore", [])

func _f115(this_, a: Array, env):
	var v_ctx_799 = null; var v_P_800 = null; var v_BC_801 = null; var v_kb_802 = null; var v_c_803 = null; var v_j_804 = null
	v_ctx_799 = J.arg(a, 0)
	v_P_800 = J.arg(a, 1)
	v_BC_801 = [0.1329, 0.2928]
	var _t638 = null
	if J.cmp(env["t"], 2.4, "<"):
		_t638 = 1.0
	else:
		var _t637 = null
		if J.cmp(env["t"], 3.5, "<"):
			_t637 = env["bs"]
		else:
			var _t636 = null
			if J.cmp(env["t"], 4.3, "<"):
				_t636 = 0.0
			else:
				var _t635 = env["__p"]["seg"]
				_t636 = J.mc(env["__p"]["E"], "back", [J.cl(_t635, null, [env["t"], 4.3, 4.6])])
			_t637 = _t636
		_t638 = _t637
	v_kb_802 = _t638
	if J.cmp(v_kb_802, 0.0, ">"):
		v_c_803 = J.mc(J.G.get("MoveKit"), "ppt", [J.gp(v_P_800, "K"), J.gp(v_P_800, "hm"), J.gp(J.gp(J.gp(v_P_800, "R"), "pv"), 0.0), J.gp(J.gp(J.gp(v_P_800, "R"), "pv"), 1.0), J.gp(v_BC_801, 0.0), J.gp(v_BC_801, 1.0)])
		J.mc(v_ctx_799, "save", [])
		J.mc(v_ctx_799, "translate", [J.gp(v_c_803, 0.0), J.gp(v_c_803, 1.0)])
		J.mc(v_ctx_799, "scale", [v_kb_802, v_kb_802])
		J.mc(v_ctx_799, "translate", [(-J.num(J.gp(v_c_803, 0.0))), (-J.num(J.gp(v_c_803, 1.0)))])
		J.mc(J.G.get("MoveKit"), "piece", [v_ctx_799, J.gp(v_P_800, "K"), "eguiking__bun", J.gp(v_P_800, "hm"), J.gp(J.gp(J.gp(v_P_800, "R"), "pv"), 0.0), J.gp(J.gp(J.gp(v_P_800, "R"), "pv"), 1.0)])
		J.mc(v_ctx_799, "restore", [])
	v_j_804 = 0.0
	while true:
		if not J.cmp(v_j_804, 3.0, "<"): break
		var _t639 = env["__p"]["spray"]
		J.cl(_t639, null, [v_ctx_799, J.gp(J.gp(v_P_800, "mouth"), 0.0), J.add(J.gp(J.gp(v_P_800, "mouth"), 1.0), J.mul(0.03, env["H"])), J.sub(env["t"], (2.5 + J.mul(v_j_804, 0.38))), 0.4, 3.0, J.add(70.0, v_j_804), env["H"], {"up": 0.3, "v": 0.5, "g": 4.0}, Callable(self, "_f116").bind(env)])
		v_j_804 = J.num(v_j_804) + 1.0
	if J.cmp(env["t"], 4.0, ">"):
		var _t641 = env["__p"]["twinkle"]
		J.cl(_t641, null, [v_ctx_799, J.add(J.gp(J.gp(v_P_800, "top"), 0.0), J.mul(0.1, env["H"])), J.add(J.gp(J.gp(v_P_800, "top"), 1.0), J.mul(0.1, env["H"])), J.sub(env["t"], 4.0), env["H"], 9.0])

func _f111(this_, a: Array, env):
	var v_a_767 = null; var v_at_769 = null; var v_v_770 = null; var v_face_775 = null; var v_eat_776 = null; var v_k_777 = null; var v_bites_778 = null; var v_kingHand_781 = null; var v_back_782 = null; var v_front_783 = null; var v_c_784 = null; var v_fr_798 = null
	var _s182 = {"__p": env, "R": null, "t": null, "H": null, "bx": null, "baseTop": null, "bunW": null, "bs": null}
	v_a_767 = J.arg(a, 0)
	_s182["R"] = J.arg(a, 1)
	v_at_769 = J.arg(a, 2)
	v_v_770 = J.arg(a, 3)
	var _t589 = _s182["__p"]["sp"]
	_s182["t"] = J.mul(v_at_769, J.cl(_t589, null, [v_v_770]))
	_s182["H"] = J.gp(v_a_767, "H")
	_s182["bx"] = J.mul(0.34, _s182["H"])
	_s182["baseTop"] = J.mul(0.12, _s182["H"])
	v_face_775 = 1.0
	var _t590 = J.cmp(_s182["t"], 0.3, ">")
	var _t592 = (J.cmp(_s182["t"], 0.75, "<") if _t590 else _t590)
	if not J.t(_t592):
		var _t591 = J.cmp(_s182["t"], 1.05, ">")
		_t592 = (J.cmp(_s182["t"], 1.3, "<") if _t591 else _t591)
	if _t592:
		v_face_775 = (-1.0)
	v_eat_776 = (({"hr": (-55.0), "hy": (-0.06), "hx": 0.0, "bend": 8.0, "head": 12.0} if J.t(J.gp(_s182["R"], "long")) else {"hy": (-0.04), "hx": (-0.01), "bend": 26.0, "lean": 10.0, "head": 18.0}) if J.t(J.gp(_s182["R"], "arm")) else {"bend": 22.0, "lean": 12.0, "head": 16.0})
	var _t593 = _s182["__p"]["kf"]
	var _t598 = [0.0, {}]
	var _t599 = [0.25, {"head": (-6.0), "sy": 0.97}, "o"]
	var _t600 = [0.75, {"head": (-6.0), "sy": 0.97}]
	var _t601 = [1.0, {"head": (-4.0), "sy": 0.96}]
	var _t602 = [1.3, {"head": (-4.0), "sy": 0.96}]
	var _t603 = [1.45, {"sy": 0.95}]
	var _t604 = [1.75, {"bend": 14.0, "lean": 8.0, "hx": 0.05, "hy": 0.04, "head": 6.0}, "io"]
	var _t605 = [1.9, {"bend": 12.0, "lean": 6.0, "hx": 0.05, "hy": 0.03, "sy": 0.96}, "o"]
	var _t606 = [2.3, v_eat_776, "io"]
	var _t607 = [3.5, v_eat_776]
	var _t597 = {}
	var _t594 = J.gp(v_eat_776, "head")
	var _t596 = J.sub((_t594 if J.t(_t594) else 0.0), 18.0)
	var _t595 = J.gp(v_eat_776, "bend")
	v_k_777 = J.cl(_t593, null, [[_t598, _t599, _t600, _t601, _t602, _t603, _t604, _t605, _t606, _t607, [3.75, J.S_Object_("assign", [_t597, v_eat_776, {"head": _t596, "sy": 1.06, "sx": 0.96, "bend": J.sub((_t595 if J.t(_t595) else 0.0), 10.0)}]), "o"], [4.3, {"head": (-8.0), "sy": 1.04, "lean": (-4.0)}, "io"], [5.0, {}, "io"]], _s182["t"]])
	var _t608 = J.cmp(_s182["t"], 2.3, ">")
	if (J.cmp(_s182["t"], 3.5, "<") if _t608 else _t608):
		v_c_784 = absf(J.num(sin(J.num(((J.sub(_s182["t"], 2.3) * PI) * 2.5)))))
		var _t609 = J.add(J.gp(v_k_777, "head"), J.mul(v_c_784, 7.0))
		J.sp(v_k_777, "head", _t609)
		var _t610 = J.mul(J.gp(v_k_777, "sy"), (1.0 - J.mul(v_c_784, 0.02)))
		J.sp(v_k_777, "sy", _t610)
	var _t611 = _s182["__p"]["seg"]
	v_bites_778 = floor(J.num((J.mul(J.cl(_t611, null, [_s182["t"], 2.4, 3.5]), 3.0) + (1.0 if J.cmp(_s182["t"], 2.4, ">") else 0.0))))
	_s182["bunW"] = J.mul(0.16, _s182["H"])
	_s182["bs"] = (J.gp([1.0, 0.75, 0.5, 0.3], J.min_([3.0, v_bites_778])) if J.cmp(_s182["t"], 3.5, "<") else 0.0)
	v_kingHand_781 = J.seq(J.gp(_s182["R"], "id"), "eguiking")
	v_back_782 = Callable(self, "_f112").bind(_s182)
	v_front_783 = Callable(self, "_f113").bind(_s182)
	var _t632 = v_kingHand_781
	if J.t(_t632):
		var _t631 = _s182["__p"]["ok"]
		_t632 = J.cl(_t631, null, ["eguiking__hand"])
	var _t634 = _t632
	if J.t(_t634):
		var _t633 = _s182["__p"]["ok"]
		_t634 = J.cl(_t633, null, ["eguiking__bun"])
	if J.t(_t634):
		v_fr_798 = {"k": v_k_777, "face": v_face_775, "back": v_back_782, "hand": "eguiking__hand"}
		var _t642 = Callable(self, "_f115").bind(_s182)
		J.sp(v_fr_798, "front", _t642)
		return v_fr_798
	return {"k": v_k_777, "face": v_face_775, "back": v_back_782, "front": v_front_783}

func _f117(this_, a: Array, env):
	var v_v_810 = null
	v_v_810 = J.arg(a, 0)
	var _t646 = (J.mul(J.gp(v_v_810, "n"), 0.9) + 1.6)
	var _t645 = env["sp"]
	return J.div(_t646, J.cl(_t645, null, [v_v_810]))

func _f119(this_, a: Array, env):
	var v_ctx_839 = null
	v_ctx_839 = J.arg(a, 0)
	var _t670 = env["__p"]["prop"]
	J.cl(_t670, null, [v_ctx_839, "store__sack", env["sx0"], 0.5, J.mul(0.36, env["H"]), 0.0, {"an": [0.5, 1.0]}])

func _f120(this_, a: Array, env):
	var v_ctx_840 = null; var v_P_841 = null; var v_stacked_842 = null; var v_sweep_843 = null; var v_j_844 = null; var v_j_845 = null; var v_j_846 = null; var v_p_847 = null; var v_c_848 = null; var v_q_849 = null; var v_from_850 = null; var v_to_851 = null
	v_ctx_840 = J.arg(a, 0)
	v_P_841 = J.arg(a, 1)
	v_stacked_842 = 0.0
	v_j_844 = 0.0
	while true:
		if not J.cmp(v_j_844, env["n"], "<"): break
		var _t671 = J.cmp(env["b"], (J.mul(v_j_844, env["T"]) + J.mul(0.95, env["T"])), ">")
		if ((not J.t((J.seq(v_j_844, env["ts"]) if J.t(env["thief"]) else env["thief"]))) if _t671 else _t671):
			v_stacked_842 = J.num(v_stacked_842) + 1.0
		v_j_844 = J.num(v_j_844) + 1.0
	var _t673 = null
	if J.cmp(env["b"], J.mul(env["n"], env["T"]), ">"):
		var _t672 = env["__p"]["seg"]
		_t673 = J.cl(_t672, null, [J.sub(env["b"], J.mul(env["n"], env["T"])), 0.4, 0.8])
	else:
		_t673 = 0.0
	v_sweep_843 = _t673
	v_j_845 = 0.0
	while true:
		if not J.cmp(v_j_845, v_stacked_842, "<"): break
		var _t674 = env["__p"]["coinFlat"]
		var _t675 = env["__p"]["lerp"]
		var _t677 = J.add(J.cl(_t675, null, [env["stackX"], env["sx0"], J.mc(env["__p"]["E"], "i", [v_sweep_843])]), J.mul((0.006 if J.t(J.mod(v_j_845, 2.0)) else (-0.004)), env["H"]))
		var _t678 = ((J.mul((-0.012), env["H"]) - J.mul(J.mul(v_j_845, 0.024), env["H"])) - J.mul((sin(J.num(J.mul(v_sweep_843, PI))) * 0.08), env["H"]))
		var _t679 = env["H"]
		var _t676 = env["__p"]["seg"]
		J.cl(_t674, null, [v_ctx_840, _t677, _t678, _t679, J.sub(1.0, J.cl(_t676, null, [v_sweep_843, 0.7, 1.0]))])
		v_j_845 = J.num(v_j_845) + 1.0
	var _t680 = J.cmp(env["b"], 0.0, ">=")
	if (J.cmp(env["b"], J.mul(env["n"], env["T"]), "<") if _t680 else _t680):
		v_j_846 = floor(J.num(J.div(env["b"], env["T"])))
		v_p_847 = J.div(J.mod(env["b"], env["T"]), env["T"])
		if J.cmp(v_p_847, 0.22, ">"):
			v_c_848 = null
			if J.cmp(v_p_847, 0.82, "<"):
				var _t690 = null
				if J.t(J.gp(env["R"], "arm")):
					_t690 = [J.gp(J.gp(v_P_841, "G"), 0.0), J.sub(J.gp(J.gp(v_P_841, "G"), 1.0), J.mul(0.02, env["H"]))]
				else:
					var _t681 = env["__p"]["lerp"]
					var _t683 = env["sx0"]
					var _t684 = J.add(J.gp(J.gp(v_P_841, "mouth"), 0.0), J.mul(0.12, env["H"]))
					var _t682 = env["__p"]["seg"]
					var _t689 = J.cl(_t681, null, [_t683, _t684, J.mc(env["__p"]["E"], "io", [J.cl(_t682, null, [v_p_847, 0.22, 0.5])])])
					var _t685 = env["__p"]["lerp"]
					var _t687 = J.mul((-0.2), env["H"])
					var _t688 = J.add(J.gp(J.gp(v_P_841, "mouth"), 1.0), J.mul(0.04, env["H"]))
					var _t686 = env["__p"]["seg"]
					_t690 = [_t689, J.cl(_t685, null, [_t687, _t688, J.mc(env["__p"]["E"], "io", [J.cl(_t686, null, [v_p_847, 0.22, 0.5])])])]
				v_c_848 = _t690
			else:
				var _t691 = env["__p"]["seg"]
				v_q_849 = J.cl(_t691, null, [v_p_847, 0.82, 1.0])
				v_from_850 = ([J.gp(J.gp(v_P_841, "G"), 0.0), J.gp(J.gp(v_P_841, "G"), 1.0)] if J.t(J.gp(env["R"], "arm")) else [J.add(J.gp(J.gp(v_P_841, "mouth"), 0.0), J.mul(0.12, env["H"])), J.add(J.gp(J.gp(v_P_841, "mouth"), 1.0), J.mul(0.04, env["H"]))])
				v_to_851 = ([J.add(J.gp(J.gp(v_P_841, "belly"), 0.0), J.mul(0.02, env["H"])), J.gp(J.gp(v_P_841, "belly"), 1.0)] if J.t((J.seq(v_j_846, env["ts"]) if J.t(env["thief"]) else env["thief"])) else [env["stackX"], (J.mul((-0.012), env["H"]) - J.mul(J.mul(v_stacked_842, 0.022), env["H"]))])
				var _t692 = env["__p"]["lerp"]
				var _t694 = J.cl(_t692, null, [J.gp(v_from_850, 0.0), J.gp(v_to_851, 0.0), v_q_849])
				var _t693 = env["__p"]["lerp"]
				var _t695 = [_t694, J.sub(J.cl(_t693, null, [J.gp(v_from_850, 1.0), J.gp(v_to_851, 1.0), J.mc(env["__p"]["E"], "i", [v_q_849])]), J.mul((sin(J.num(J.mul(v_q_849, PI))) * 0.1), env["H"]))]
				v_c_848 = _t695
			var _t696 = env["__p"]["coin"]
			J.cl(_t696, null, [v_ctx_840, J.gp(v_c_848, 0.0), J.gp(v_c_848, 1.0), env["H"], J.add(J.mul(v_p_847, 9.0), v_j_846), 1.0])
			var _t697 = (not J.t(J.gp(env["R"], "arm")))
			if (J.cmp(v_p_847, 0.82, "<") if _t697 else _t697):
				var _t698 = env["__p"]["wisp"]
				J.cl(_t698, null, [v_ctx_840, J.gp(v_P_841, "mouth"), v_c_848, env["H"], J.add(11.0, v_j_846), 1.0])
		var _t699 = J.cmp(v_p_847, 0.55, ">")
		if (J.cmp(v_p_847, 0.7, "<") if _t699 else _t699):
			var _t700 = env["__p"]["twinkle"]
			J.cl(_t700, null, [v_ctx_840, (J.gp(J.gp(v_P_841, "G"), 0.0) if J.t(J.gp(env["R"], "arm")) else J.add(J.gp(J.gp(v_P_841, "mouth"), 0.0), J.mul(0.12, env["H"]))), J.sub((J.gp(J.gp(v_P_841, "G"), 1.0) if J.t(J.gp(env["R"], "arm")) else J.gp(J.gp(v_P_841, "mouth"), 1.0)), J.mul(0.04, env["H"])), J.div(J.mul(J.sub(v_p_847, 0.55), env["T"]), env["s"]), J.mul(env["H"], 0.7), v_j_846])
	if J.t(env["thief"]):
		var _t701 = env["__p"]["twinkle"]
		J.cl(_t701, null, [v_ctx_840, J.gp(J.gp(v_P_841, "belly"), 0.0), J.gp(J.gp(v_P_841, "belly"), 1.0), J.div(J.sub(env["b"], J.add(J.mul(env["ts"], env["T"]), env["T"])), env["s"]), env["H"], 77.0])

func _f118(this_, a: Array, env):
	var v_a_813 = null; var v_at_815 = null; var v_v_816 = null; var v_t_818 = null; var v_in0_822 = null; var v_dip_828 = null; var v_look_829 = null; var v_k_830 = null; var v_face_831 = null; var v_tt0_832 = null; var v_back_833 = null; var v_front_834 = null; var v_p_835 = null; var v_q_836 = null; var v_q_837 = null; var v_c_838 = null
	var _s195 = {"__p": env, "R": null, "s": null, "H": null, "n": null, "T": null, "b": null, "sx0": null, "stackX": null, "thief": null, "ts": null}
	v_a_813 = J.arg(a, 0)
	_s195["R"] = J.arg(a, 1)
	v_at_815 = J.arg(a, 2)
	v_v_816 = J.arg(a, 3)
	var _t647 = _s195["__p"]["sp"]
	_s195["s"] = J.cl(_t647, null, [v_v_816])
	v_t_818 = J.mul(v_at_815, _s195["s"])
	_s195["H"] = J.gp(v_a_813, "H")
	_s195["n"] = J.gp(v_v_816, "n")
	_s195["T"] = 0.9
	v_in0_822 = 0.4
	_s195["b"] = J.sub(v_t_818, v_in0_822)
	_s195["sx0"] = J.mul(0.36, _s195["H"])
	_s195["stackX"] = J.mul(0.7, _s195["H"])
	_s195["thief"] = J.seq(J.gp(_s195["R"], "id"), "toyol")
	_s195["ts"] = floor(J.num(J.div(_s195["n"], 2.0)))
	v_dip_828 = ({"bend": 18.0, "lean": 8.0, "hx": 0.05, "hy": 0.05} if J.t(J.gp(_s195["R"], "arm")) else {"bend": 16.0, "lean": 8.0, "head": 8.0})
	v_look_829 = ({"bend": 2.0, "hy": (-0.03), "hx": 0.0, "head": 4.0, "hr": (-15.0)} if J.t(J.gp(_s195["R"], "arm")) else {"bend": 0.0, "head": 6.0})
	v_k_830 = null
	v_face_831 = 1.0
	if J.cmp(_s195["b"], 0.0, "<"):
		var _t648 = _s195["__p"]["kf"]
		var _t649 = J.cl(_t648, null, [[[0.0, {}], [v_in0_822, v_look_829]], v_t_818])
		v_k_830 = _t649
	else:
		if J.cmp(_s195["b"], J.mul(_s195["n"], _s195["T"]), "<"):
			v_p_835 = J.div(J.mod(_s195["b"], _s195["T"]), _s195["T"])
			var _t650 = _s195["__p"]["kf"]
			var _t653 = [0.0, v_look_829]
			var _t654 = [0.25, v_dip_828, "io"]
			var _t655 = [0.5, v_look_829, "io"]
			var _t652 = {}
			var _t651 = J.gp(v_look_829, "head")
			var _t658 = [0.62, J.S_Object_("assign", [_t652, v_look_829, {"head": J.add((_t651 if J.t(_t651) else 0.0), 10.0)}]), "o"]
			var _t659 = [0.75, v_look_829, "io"]
			var _t657 = {}
			var _t656 = J.gp(v_look_829, "hx")
			var _t660 = J.cl(_t650, null, [[_t653, _t654, _t655, _t658, _t659, [0.9, J.S_Object_("assign", [_t657, v_look_829, {"hx": J.sub((_t656 if J.t(_t656) else 0.0), 0.03)}]), "o"], [1.0, v_look_829, "io"]], v_p_835])
			v_k_830 = _t660
		else:
			v_q_836 = J.sub(_s195["b"], J.mul(_s195["n"], _s195["T"]))
			var _t661 = _s195["__p"]["kf"]
			var _t662 = J.cl(_t661, null, [[[0.0, v_look_829], [0.4, {"bend": 16.0, "lean": 8.0, "hx": 0.0, "hy": 0.05}, "io"], [0.8, {"bend": 14.0, "lean": 6.0, "hx": 0.07, "hy": 0.05}, "io"], [1.2, {}, "io"]], v_q_836])
			v_k_830 = _t662
	v_tt0_832 = J.add(v_in0_822, J.mul(_s195["ts"], _s195["T"]))
	var _t663 = (J.cmp(_s195["b"], (J.mul(_s195["ts"], _s195["T"]) - 0.6), ">") if J.t(_s195["thief"]) else _s195["thief"])
	if J.t((J.cmp(_s195["b"], J.mul(_s195["ts"], _s195["T"]), "<") if J.t(_t663) else _t663)):
		v_q_837 = J.div(J.sub(_s195["b"], (J.mul(_s195["ts"], _s195["T"]) - 0.6)), 0.6)
		var _t664 = J.cmp(v_q_837, 0.25, ">")
		var _t665 = ((-1.0) if (J.cmp(v_q_837, 0.6, "<") if _t664 else _t664) else 1.0)
		v_face_831 = _t665
		var _t666 = J.mul(J.gp(v_k_830, "sy"), 0.96)
		J.sp(v_k_830, "sy", _t666)
	var _t667 = (J.cmp(_s195["b"], (J.mul(_s195["ts"], _s195["T"]) + 0.6), ">") if J.t(_s195["thief"]) else _s195["thief"])
	if J.t((J.cmp(_s195["b"], (J.mul(_s195["ts"], _s195["T"]) + 0.95), "<") if J.t(_t667) else _t667)):
		var _t668 = _s195["__p"]["seg"]
		v_c_838 = sin(J.num((J.mul(J.cl(_t668, null, [_s195["b"], (J.mul(_s195["ts"], _s195["T"]) + 0.6), (J.mul(_s195["ts"], _s195["T"]) + 0.95)]), PI) * 3.0)))
		var _t669 = J.mul(J.gp(v_k_830, "sy"), (1.0 + (0.03 * absf(J.num(v_c_838)))))
		J.sp(v_k_830, "sy", _t669)
	v_back_833 = Callable(self, "_f119").bind(_s195)
	v_front_834 = Callable(self, "_f120").bind(_s195)
	return {"k": v_k_830, "face": v_face_831, "back": v_back_833, "front": v_front_834}

func _f121(this_, a: Array, env):
	var v_v_852 = null
	v_v_852 = J.arg(a, 0)
	var _t704 = env["sp"]
	return J.div(3.4, J.cl(_t704, null, [v_v_852]))

func _f123(this_, a: Array, env):
	var v_ctx_865 = null
	v_ctx_865 = J.arg(a, 0)
	var _t712 = env["__p"]["prop"]
	J.cl(_t712, null, [v_ctx_865, "store__sack", J.mul(J.add(0.42, env["slide"]), env["H"]), 0.5, J.mul(0.38, env["H"]), 0.0, {"an": [0.5, 1.0]}])

func _f124(this_, a: Array, env):
	var v_ctx_866 = null
	v_ctx_866 = J.arg(a, 0)
	var _t713 = env["__p"]["puff"]
	J.cl(_t713, null, [v_ctx_866, J.mul(0.5, env["H"]), 0.0, J.sub(env["t"], 1.1), 0.5, J.mul(0.25, env["H"]), 81.0])
	var _t714 = env["__p"]["puff"]
	J.cl(_t714, null, [v_ctx_866, J.mul(0.56, env["H"]), 0.0, J.sub(env["t"], 1.45), 0.5, J.mul(0.22, env["H"]), 82.0])

func _f122(this_, a: Array, env):
	var v_a_855 = null; var v_R_856 = null; var v_at_857 = null; var v_v_858 = null; var v_k_861 = null; var v_back_863 = null; var v_front_864 = null
	var _s209 = {"__p": env, "t": null, "H": null, "slide": null}
	v_a_855 = J.arg(a, 0)
	v_R_856 = J.arg(a, 1)
	v_at_857 = J.arg(a, 2)
	v_v_858 = J.arg(a, 3)
	var _t705 = _s209["__p"]["sp"]
	_s209["t"] = J.mul(v_at_857, J.cl(_t705, null, [v_v_858]))
	_s209["H"] = J.gp(v_a_855, "H")
	var _t706 = _s209["__p"]["kf"]
	v_k_861 = J.cl(_t706, null, [[[0.0, {}], [0.4, {"lean": (-4.0), "bend": (-4.0), "sy": 1.03}, "o"], [0.8, {"lean": 18.0, "bend": 16.0, "dx": 0.08, "sy": 0.93, "sx": 1.05, "hx": 0.05}, "i"], [1.6, {"lean": 20.0, "bend": 18.0, "dx": 0.2, "sy": 0.92, "sx": 1.06, "hx": 0.05}, "io"], [1.9, {"lean": 12.0, "bend": 10.0, "dx": 0.2, "sy": 0.97, "hx": 0.03}, "o"], [2.3, {"lean": (-6.0), "bend": (-6.0), "dx": 0.18, "sy": 1.04, "head": (-6.0)}, "o"], [2.8, {"dx": 0.08, "sy": 0.98}, "io"], [3.4, {}, "io"]], _s209["t"]])
	var _t707 = J.cmp(_s209["t"], 0.8, ">")
	if (J.cmp(_s209["t"], 1.6, "<") if _t707 else _t707):
		var _t708 = J.add(J.gp(v_k_861, "dx"), (sin(J.num((J.sub(_s209["t"], 0.8) * 30.0))) * 0.004))
		J.sp(v_k_861, "dx", _t708)
	var _t709 = _s209["__p"]["seg"]
	var _t711 = J.mul(0.12, J.mc(_s209["__p"]["E"], "io", [J.cl(_t709, null, [_s209["t"], 0.85, 1.6])]))
	var _t710 = _s209["__p"]["seg"]
	_s209["slide"] = (_t711 * J.sub(1.0, J.mc(_s209["__p"]["E"], "io", [J.cl(_t710, null, [_s209["t"], 2.6, 3.4])])))
	v_back_863 = Callable(self, "_f123").bind(_s209)
	v_front_864 = Callable(self, "_f124").bind(_s209)
	return {"k": v_k_861, "back": v_back_863, "front": v_front_864}

func _f125(this_, a: Array, env):
	var v_v_867 = null
	v_v_867 = J.arg(a, 0)
	var _t717 = env["sp"]
	return J.div(4.6, J.cl(_t717, null, [v_v_867]))

func _f127(this_, a: Array, env):
	var v_ctx_881 = null; var v_P_882 = null
	v_ctx_881 = J.arg(a, 0)
	v_P_882 = J.arg(a, 1)
	var _t740 = env["__p"]["bang"]
	var _t744 = J.add(J.gp(J.gp(v_P_882, "top"), 0.0), J.mul(0.14, env["H"]))
	var _t745 = J.add(J.gp(J.gp(v_P_882, "top"), 1.0), J.mul(0.02, env["H"]))
	var _t746 = env["H"]
	var _t741 = env["__p"]["seg"]
	var _t743 = J.cl(_t741, null, [env["t"], 2.8, 2.9])
	var _t742 = env["__p"]["seg"]
	J.cl(_t740, null, [v_ctx_881, _t744, _t745, _t746, J.mul(_t743, J.sub(1.0, J.cl(_t742, null, [env["t"], 3.6, 3.9]))), 5.0])

func _f126(this_, a: Array, env):
	var v_a_870 = null; var v_R_871 = null; var v_at_872 = null; var v_v_873 = null; var v_face_876 = null; var v_point_877 = null; var v_k_878 = null; var v_front_879 = null; var v_c_880 = null
	var _s213 = {"__p": env, "t": null, "H": null}
	v_a_870 = J.arg(a, 0)
	v_R_871 = J.arg(a, 1)
	v_at_872 = J.arg(a, 2)
	v_v_873 = J.arg(a, 3)
	var _t718 = _s213["__p"]["sp"]
	_s213["t"] = J.mul(v_at_872, J.cl(_t718, null, [v_v_873]))
	_s213["H"] = J.gp(v_a_870, "H")
	v_face_876 = 1.0
	var _t719 = J.cmp(_s213["t"], 0.6, ">")
	if (J.cmp(_s213["t"], 1.4, "<") if _t719 else _t719):
		v_face_876 = (-1.0)
	v_point_877 = (({"hr": (-70.0), "hx": 0.03, "hy": (-0.02), "lean": 4.0, "head": (-4.0)} if J.t(J.gp(v_R_871, "long")) else {"hx": 0.05, "hy": (-0.04), "hr": (-30.0), "lean": 6.0, "head": (-4.0)}) if J.t(J.gp(v_R_871, "arm")) else {"lean": 10.0, "dx": 0.03, "head": (-6.0)})
	var _t720 = _s213["__p"]["kf"]
	var _t723 = [0.0, {}]
	var _t724 = [0.5, {"head": (-6.0)}]
	var _t725 = [0.7, {"head": 4.0}, "o"]
	var _t726 = [1.3, {"head": 4.0}]
	var _t727 = [1.5, {"head": (-2.0)}, "o"]
	var _t728 = [1.8, {"head": 8.0}, "io"]
	var _t729 = [2.0, {"head": (-2.0)}, "io"]
	var _t730 = [2.2, {"head": 8.0}, "io"]
	var _t731 = [2.5, {}, "io"]
	var _t732 = [2.8, v_point_877, "o"]
	var _t722 = {}
	var _t721 = J.gp(v_point_877, "dx")
	var _t735 = [3.0, J.S_Object_("assign", [_t722, v_point_877, {"dx": J.add((_t721 if J.t(_t721) else 0.0), 0.02)}]), "o"]
	var _t736 = [3.15, v_point_877, "io"]
	var _t734 = {}
	var _t733 = J.gp(v_point_877, "dx")
	v_k_878 = J.cl(_t720, null, [[_t723, _t724, _t725, _t726, _t727, _t728, _t729, _t730, _t731, _t732, _t735, _t736, [3.3, J.S_Object_("assign", [_t734, v_point_877, {"dx": J.add((_t733 if J.t(_t733) else 0.0), 0.02)}]), "o"], [3.7, v_point_877], [4.2, {}, "io"]], _s213["t"]])
	var _t737 = J.cmp(_s213["t"], 1.5, ">")
	if (J.cmp(_s213["t"], 2.5, "<") if _t737 else _t737):
		v_c_880 = absf(J.num(sin(J.num(((J.sub(_s213["t"], 1.5) * PI) * 4.0)))))
		var _t738 = J.sub(J.gp(v_k_878, "dy"), J.mul(v_c_880, 0.012))
		J.sp(v_k_878, "dy", _t738)
		var _t739 = J.mul(J.gp(v_k_878, "sy"), (1.0 - (J.sub(1.0, v_c_880) * 0.015)))
		J.sp(v_k_878, "sy", _t739)
	v_front_879 = Callable(self, "_f127").bind(_s213)
	return {"k": v_k_878, "face": v_face_876, "front": v_front_879}

func _f128(this_, a: Array, env):
	var v_v_883 = null
	v_v_883 = J.arg(a, 0)
	var _t751 = (4.0 if J.t(J.gp(v_v_883, "walk")) else 0.0)
	var _t750 = (J.mul(J.gp(v_v_883, "n"), 1.4) + 0.6)
	var _t749 = env["sp"]
	return (_t751 + J.div(_t750, J.cl(_t749, null, [v_v_883])))

func _f130(this_, a: Array, env):
	var v_ctx_915 = null; var v_P_916 = null; var v_i_917 = null; var v_p_918 = null; var v_mouth_919 = null; var v_hand_920 = null; var v_q_921 = null; var v_j_922 = null
	v_ctx_915 = J.arg(a, 0)
	v_P_916 = J.arg(a, 1)
	var _t766 = J.cmp(env["bt"], 0.0, "<")
	if (_t766 if _t766 else J.cmp(env["bt"], env["total"], ">")):
		return null
	v_i_917 = floor(J.num(J.div(env["b"], env["T"])))
	v_p_918 = J.div(J.mod(env["b"], env["T"]), env["T"])
	v_mouth_919 = [J.add(J.gp(env["st"], 0.0), J.gp(env["tg"], 0.0)), J.add(J.gp(env["st"], 1.0), J.gp(env["tg"], 1.0))]
	if J.cmp(v_i_917, J.gp(env["v"], "n"), "<"):
		v_hand_920 = ([J.gp(J.gp(v_P_916, "G"), 0.0), J.sub(J.gp(J.gp(v_P_916, "G"), 1.0), J.mul(0.02, env["H"]))] if J.t(J.gp(env["R"], "arm")) else [J.add(J.gp(J.gp(v_P_916, "belly"), 0.0), J.mul(J.mul(0.08, env["H"]), env["face"])), J.sub(J.gp(J.gp(v_P_916, "belly"), 1.0), J.mul(0.08, env["H"]))])
		if J.cmp(v_p_918, 0.45, "<"):
			var _t767 = env["__p"]["prop"]
			var _t770 = J.gp(v_hand_920, 0.0)
			var _t771 = J.gp(v_hand_920, 1.0)
			var _t769 = J.mul(0.13, env["H"])
			var _t768 = env["__p"]["seg"]
			J.cl(_t767, null, [v_ctx_915, "furnace__paper", _t770, _t771, J.mul(_t769, J.mc(env["__p"]["E"], "back", [J.cl(_t768, null, [v_p_918, 0.0, 0.15])])), (-20.0), {"an": [0.5, 0.5]}])
		else:
			if J.cmp(v_p_918, 0.7, "<"):
				var _t772 = env["__p"]["seg"]
				v_q_921 = J.cl(_t772, null, [v_p_918, 0.45, 0.7])
				var _t773 = env["__p"]["prop"]
				var _t774 = env["__p"]["lerp"]
				var _t776 = J.cl(_t774, null, [J.gp(v_hand_920, 0.0), J.gp(v_mouth_919, 0.0), v_q_921])
				var _t775 = env["__p"]["lerp"]
				J.cl(_t773, null, [v_ctx_915, "furnace__paper", _t776, J.sub(J.cl(_t775, null, [J.gp(v_hand_920, 1.0), J.gp(v_mouth_919, 1.0), v_q_921]), J.mul((sin(J.num(J.mul(v_q_921, PI))) * 0.14), env["H"])), (J.mul(0.13, env["H"]) * (1.0 - J.mul(0.4, v_q_921))), ((-20.0) + J.mul(v_q_921, 260.0)), {"an": [0.5, 0.5]}])
		var _t777 = (not J.t(J.gp(env["R"], "arm")))
		if (J.cmp(v_p_918, 0.7, "<") if _t777 else _t777):
			var _t778 = env["__p"]["wisp"]
			J.cl(_t778, null, [v_ctx_915, J.gp(v_P_916, "belly"), v_hand_920, env["H"], 4.0, 1.0])
	v_j_922 = 0.0
	while true:
		if not J.cmp(v_j_922, J.gp(env["v"], "n"), "<"): break
		var _t779 = env["__p"]["flame"]
		J.cl(_t779, null, [v_ctx_915, J.gp(v_mouth_919, 0.0), J.add(J.gp(v_mouth_919, 1.0), J.mul(0.05, env["H"])), J.div(J.sub(env["b"], (J.mul(v_j_922, env["T"]) + J.mul(0.68, env["T"]))), env["s"]), 0.55, J.mul(env["H"], (1.15 if J.t(env["paper"]) else 1.0)), J.add(90.0, v_j_922)])
		v_j_922 = J.num(v_j_922) + 1.0

func _f129(this_, a: Array, env):
	var v_a_886 = null; var v_at_888 = null; var v_wk_892 = null; var v_fw_894 = null; var v_tw_896 = null; var v_dirOut_900 = null; var v_faceB_901 = null; var v_ox_902 = null; var v_oy_903 = null; var v_walk_905 = null; var v_k_908 = null; var v_fr_909 = null; var v_q_910 = null; var v_q_911 = null; var v_i_912 = null; var v_p_913 = null; var v_flinch_914 = null
	var _s217 = {"__p": env, "R": null, "v": null, "H": null, "s": null, "paper": null, "st": null, "tg": null, "bt": null, "total": null, "face": null, "b": null, "T": null}
	v_a_886 = J.arg(a, 0)
	_s217["R"] = J.arg(a, 1)
	v_at_888 = J.arg(a, 2)
	_s217["v"] = J.arg(a, 3)
	_s217["H"] = J.gp(v_a_886, "H")
	var _t752 = _s217["__p"]["sp"]
	_s217["s"] = J.cl(_t752, null, [_s217["v"]])
	v_wk_892 = (2.0 if J.t(J.gp(_s217["v"], "walk")) else 0.0)
	_s217["paper"] = (not (not J.t(J.gp(_s217["__p"]["PAPER"], J.gp(_s217["R"], "id")))))
	v_fw_894 = (1.0 if J.t(J.gp(v_a_886, "faceRight")) else (-1.0))
	_s217["st"] = ([J.mul(J.gp(J.gp(_s217["v"], "stand"), 0.0), v_fw_894), J.gp(J.gp(_s217["v"], "stand"), 1.0)] if J.t(J.gp(_s217["v"], "stand")) else [0.0, 0.0])
	var _t753 = J.gp(J.gp(v_a_886, "o"), "wtarget")
	v_tw_896 = (_t753 if J.t(_t753) else [J.mul(J.mul(0.75, _s217["H"]), v_fw_894), J.mul((-0.12), _s217["H"])])
	_s217["tg"] = [J.mul(J.gp(v_tw_896, 0.0), v_fw_894), J.gp(v_tw_896, 1.0)]
	_s217["bt"] = J.sub(v_at_888, v_wk_892)
	_s217["total"] = J.div((J.mul(J.gp(_s217["v"], "n"), 1.4) + 0.6), _s217["s"])
	v_dirOut_900 = (1.0 if J.cmp(J.gp(_s217["st"], 0.0), 0.0, ">=") else (-1.0))
	v_faceB_901 = (1.0 if J.cmp(J.gp(_s217["tg"], 0.0), 0.0, ">=") else (-1.0))
	v_ox_902 = 0.0
	v_oy_903 = 0.0
	_s217["face"] = v_faceB_901
	v_walk_905 = 0.0
	if J.t(v_wk_892):
		if J.cmp(v_at_888, v_wk_892, "<"):
			var _t754 = _s217["__p"]["seg"]
			v_q_910 = J.mc(_s217["__p"]["E"], "sin", [J.cl(_t754, null, [v_at_888, 0.0, v_wk_892])])
			var _t755 = J.mul(J.div(J.gp(_s217["st"], 0.0), _s217["H"]), v_q_910)
			v_ox_902 = _t755
			var _t756 = J.mul(J.gp(_s217["st"], 1.0), v_q_910)
			v_oy_903 = _t756
			v_walk_905 = v_at_888
			_s217["face"] = v_dirOut_900
		else:
			if J.cmp(_s217["bt"], _s217["total"], ">"):
				var _t757 = _s217["__p"]["seg"]
				v_q_911 = J.mc(_s217["__p"]["E"], "sin", [J.cl(_t757, null, [J.sub(_s217["bt"], _s217["total"]), 0.0, v_wk_892])])
				var _t758 = (J.div(J.gp(_s217["st"], 0.0), _s217["H"]) * J.sub(1.0, v_q_911))
				v_ox_902 = _t758
				var _t759 = J.mul(J.gp(_s217["st"], 1.0), J.sub(1.0, v_q_911))
				v_oy_903 = _t759
				v_walk_905 = v_at_888
				_s217["face"] = (-J.num(v_dirOut_900))
			else:
				var _t760 = J.div(J.gp(_s217["st"], 0.0), _s217["H"])
				v_ox_902 = _t760
				v_oy_903 = J.gp(_s217["st"], 1.0)
	_s217["b"] = J.mul(_s217["bt"], _s217["s"])
	_s217["T"] = 1.4
	v_k_908 = J.S_Object_("assign", [{}, _s217["__p"]["DEF"]])
	var _t761 = J.cmp(_s217["bt"], 0.0, ">=")
	if (J.cmp(_s217["bt"], _s217["total"], "<=") if _t761 else _t761):
		v_i_912 = floor(J.num(J.div(_s217["b"], _s217["T"])))
		v_p_913 = J.div(J.mod(_s217["b"], _s217["T"]), _s217["T"])
		if J.cmp(v_i_912, J.gp(_s217["v"], "n"), "<"):
			v_flinch_914 = ({"lean": (-18.0), "bend": (-12.0), "head": (-18.0), "dx": (-0.12), "dy": (-0.06), "sy": 1.08, "sx": 0.94} if J.t(_s217["paper"]) else {"lean": (-10.0), "bend": (-6.0), "head": (-10.0), "dx": (-0.05), "sy": 0.95, "sx": 1.04})
			var _t762 = _s217["__p"]["kf"]
			var _t763 = J.cl(_t762, null, [[[0.0, {}], [0.3, {"lean": (-6.0), "bend": (-4.0), "hx": (-0.04), "hy": (-0.02), "hr": (-25.0), "sy": 1.03}, "o"], [0.45, {"lean": 8.0, "bend": 8.0, "hx": 0.05, "hy": (-0.03), "hr": 30.0, "sy": 0.97}, "i"], [0.62, {"lean": 5.0, "bend": 5.0, "hx": 0.03, "hr": 15.0}, "o"], [0.72, v_flinch_914, "o"], [0.9, v_flinch_914], [1.0, {}, "io"]], v_p_913])
			v_k_908 = _t763
			var _t764 = (J.cmp(v_p_913, 0.72, ">") if J.t(_s217["paper"]) else _s217["paper"])
			if J.t((J.cmp(v_p_913, 0.92, "<") if J.t(_t764) else _t764)):
				var _t765 = J.add(J.gp(v_k_908, "dx"), (sin(J.num(J.mul(v_p_913, 120.0))) * 0.006))
				J.sp(v_k_908, "dx", _t765)
	v_fr_909 = {"k": v_k_908, "face": _s217["face"], "ox": v_ox_902, "oy": v_oy_903, "walk": v_walk_905}
	var _t780 = Callable(self, "_f130").bind(_s217)
	J.sp(v_fr_909, "front", _t780)
	return v_fr_909

func _f131(this_, a: Array, env):
	var v_v_923 = null
	v_v_923 = J.arg(a, 0)
	var _t784 = (J.mul(J.gp(v_v_923, "n"), 0.5) + 0.8)
	var _t783 = env["sp"]
	return J.div(_t784, J.cl(_t783, null, [v_v_923]))

func _f133(this_, a: Array, env):
	var v_ctx_941 = null
	v_ctx_941 = J.arg(a, 0)
	if J.cmp(env["b"], J.mul(env["n"], 0.5), ">"):
		var _t800 = env["__p"]["puff"]
		J.cl(_t800, null, [v_ctx_941, 0.0, 0.0, J.div((J.sub(env["b"], J.mul(env["n"], 0.5)) - 0.22), env["s"]), 0.45, J.mul(0.3, env["H"]), 12.0])

func _f132(this_, a: Array, env):
	var v_a_926 = null; var v_R_927 = null; var v_at_928 = null; var v_v_929 = null; var v_t_931 = null; var v_k_935 = null; var v_fr_936 = null; var v_ph_937 = null; var v_c_938 = null; var v_h_939 = null; var v_q_940 = null
	var _s230 = {"__p": env, "s": null, "H": null, "n": null, "b": null}
	v_a_926 = J.arg(a, 0)
	v_R_927 = J.arg(a, 1)
	v_at_928 = J.arg(a, 2)
	v_v_929 = J.arg(a, 3)
	var _t785 = _s230["__p"]["sp"]
	_s230["s"] = J.cl(_t785, null, [v_v_929])
	v_t_931 = J.mul(v_at_928, _s230["s"])
	_s230["H"] = J.gp(v_a_926, "H")
	_s230["n"] = J.gp(v_v_929, "n")
	_s230["b"] = J.sub(v_t_931, 0.3)
	var _t786 = _s230["__p"]["kf"]
	v_k_935 = J.cl(_t786, null, [[[0.0, {}], [0.3, {"head": (-6.0), "sy": 1.03}]], v_t_931])
	var _t787 = J.cmp(_s230["b"], 0.0, ">")
	if (J.cmp(_s230["b"], J.mul(_s230["n"], 0.5), "<") if _t787 else _t787):
		v_ph_937 = (J.div(_s230["b"], 0.5) * PI)
		v_c_938 = sin(J.num(v_ph_937))
		var _t788 = J.S_Object_("assign", [{}, _s230["__p"]["DEF"], {"head": (-6.0), "hx": J.mul(v_c_938, 0.03), "hr": J.mul(v_c_938, (30.0 if J.t(J.gp(v_R_927, "long")) else 12.0)), "lean": 2.0}])
		v_k_935 = _t788
		if J.t(J.gp(v_R_927, "hop")):
			v_h_939 = absf(J.num(v_c_938))
			var _t789 = ((-J.num(v_h_939)) * 0.08)
			J.sp(v_k_935, "dy", _t789)
			var _t790 = (1.0 - ((1.0 - J.min_([1.0, J.mul(v_h_939, 5.0)])) * 0.06))
			J.sp(v_k_935, "sy", _t790)
		else:
			if (not J.t(J.gp(v_R_927, "legs"))):
				var _t791 = ((-absf(J.num(v_c_938))) * 0.035)
				J.sp(v_k_935, "dy", _t791)
				var _t792 = J.add(J.gp(v_k_935, "lean"), J.mul(v_c_938, 3.0))
				J.sp(v_k_935, "lean", _t792)
				var _t793 = (1.0 + (absf(J.num(v_c_938)) * 0.02))
				J.sp(v_k_935, "sy", _t793)
			else:
				var _t794 = ((-absf(J.num(v_c_938))) * 0.02)
				J.sp(v_k_935, "dy", _t794)
	else:
		if J.cmp(_s230["b"], J.mul(_s230["n"], 0.5), ">="):
			v_q_940 = J.sub(_s230["b"], J.mul(_s230["n"], 0.5))
			var _t795 = _s230["__p"]["kf"]
			var _t796 = J.cl(_t795, null, [[[0.0, {"head": (-6.0)}], [0.12, {"dy": (-0.03), "head": (-8.0), "sy": 1.05}, "o"], [0.25, {"sy": 0.92, "sx": 1.05, "head": (-4.0)}, "i"], [0.5, {}, "io"]], v_q_940])
			v_k_935 = _t796
	v_fr_936 = {"k": v_k_935}
	var _t797 = J.gp(v_R_927, "legs")
	var _t798 = (J.cmp(_s230["b"], 0.0, ">") if J.t(_t797) else _t797)
	if J.t((J.cmp(_s230["b"], J.mul(_s230["n"], 0.5), "<") if J.t(_t798) else _t798)):
		var _t799 = (J.div((J.div(J.mul(_s230["b"], 0.5), 0.5) * PI), 8.0) * 2.0)
		J.sp(v_fr_936, "walk", _t799)
	var _t801 = Callable(self, "_f133").bind(_s230)
	J.sp(v_fr_936, "front", _t801)
	return v_fr_936

func _f134(this_, a: Array, env):
	var v_v_942 = null
	v_v_942 = J.arg(a, 0)
	var _t804 = env["sp"]
	return J.div(3.2, J.cl(_t804, null, [v_v_942]))

func _f135(this_, a: Array, env):
	var v_a_945 = null; var v_R_946 = null; var v_at_947 = null; var v_v_948 = null; var v_t_949 = null; var v_H_950 = null; var v_sal_951 = null; var v_k_952 = null
	v_a_945 = J.arg(a, 0)
	v_R_946 = J.arg(a, 1)
	v_at_947 = J.arg(a, 2)
	v_v_948 = J.arg(a, 3)
	var _t805 = env["sp"]
	v_t_949 = J.mul(v_at_947, J.cl(_t805, null, [v_v_948]))
	v_H_950 = J.gp(v_a_945, "H")
	v_sal_951 = (({"hr": (-115.0), "hx": 0.02, "hy": (-0.05), "head": (-6.0)} if J.t(J.gp(v_R_946, "long")) else {"hx": (-0.03), "hy": (-0.06), "hr": (-20.0), "head": (-4.0)}) if J.t(J.gp(v_R_946, "arm")) else {"head": (-8.0)})
	var _t806 = env["kf"]
	v_k_952 = J.cl(_t806, null, [[[0.0, {}], [0.25, {"dy": (-0.03), "sy": 1.06, "sx": 0.95, "head": (-8.0)}, "o"], [0.4, {"sy": 1.04, "sx": 0.97, "head": (-8.0)}, "io"], [0.6, J.S_Object_("assign", [{"sy": 1.04}, v_sal_951]), "o"], [1.5, J.S_Object_("assign", [{"sy": 1.04}, v_sal_951])], [1.75, {"sy": 1.02, "head": (-4.0)}, "io"], [2.15, {"bend": 30.0, "lean": 10.0, "head": 14.0, "sy": 0.98}, "io"], [2.45, {"bend": 31.0, "lean": 10.0, "head": 15.0}], [2.85, {"head": (-4.0)}, "io"], [3.2, {}, "io"]], v_t_949])
	return {"k": v_k_952}

func _f136(this_, a: Array, env):
	var v_v_953 = null
	v_v_953 = J.arg(a, 0)
	var _t810 = (J.mul(J.gp(v_v_953, "n"), 0.9) + 0.5)
	var _t809 = env["sp"]
	return J.div(_t810, J.cl(_t809, null, [v_v_953]))

func _f138(this_, a: Array, env):
	var v_ctx_969 = null; var v_P_970 = null; var v_j_971 = null; var v_g_972 = null; var v_pt_973 = null
	v_ctx_969 = J.arg(a, 0)
	v_P_970 = J.arg(a, 1)
	v_j_971 = 0.0
	while true:
		if not J.cmp(v_j_971, env["n"], "<"): break
		v_g_972 = J.div(J.sub(env["t"], (J.mul(v_j_971, env["T"]) + J.mul(0.52, env["T"]))), env["s"])
		var _t814 = J.cmp(v_g_972, 0.0, "<")
		if (_t814 if _t814 else J.cmp(v_g_972, 0.3, ">")):
			v_j_971 = J.num(v_j_971) + 1.0
			continue
		v_pt_973 = (J.gp(v_P_970, "G") if J.t(J.gp(env["R"], "arm")) else J.gp(v_P_970, "mouth"))
		J.mc(J.G.get("MoveKit"), "speed", [v_ctx_969, J.add(J.gp(v_pt_973, 0.0), J.mul(0.04, env["H"])), J.gp(v_pt_973, 1.0), 1.0, 0.0, J.mul(0.18, env["H"]), J.mul(0.08, env["H"]), (1.0 - J.div(v_g_972, 0.3)), "rgba(255,240,210,.85)", J.add(20.0, v_j_971), 3.0])
		J.mc(J.G.get("MoveKit"), "burst", [v_ctx_969, J.add(J.gp(v_pt_973, 0.0), J.mul(0.14, env["H"])), J.gp(v_pt_973, 1.0), J.mul(0.1, env["H"]), (1.0 - J.div(v_g_972, 0.3)), "#ffe9a0", J.add(30.0, v_j_971), 7.0])
		v_j_971 = J.num(v_j_971) + 1.0

func _f137(this_, a: Array, env):
	var v_a_956 = null; var v_at_958 = null; var v_v_959 = null; var v_i_965 = null; var v_p_966 = null; var v_k_967 = null; var v_front_968 = null
	var _s239 = {"__p": env, "R": null, "s": null, "t": null, "H": null, "n": null, "T": null}
	v_a_956 = J.arg(a, 0)
	_s239["R"] = J.arg(a, 1)
	v_at_958 = J.arg(a, 2)
	v_v_959 = J.arg(a, 3)
	var _t811 = _s239["__p"]["sp"]
	_s239["s"] = J.cl(_t811, null, [v_v_959])
	_s239["t"] = J.mul(v_at_958, _s239["s"])
	_s239["H"] = J.gp(v_a_956, "H")
	_s239["n"] = J.gp(v_v_959, "n")
	_s239["T"] = 0.9
	v_i_965 = floor(J.num(J.div(_s239["t"], _s239["T"])))
	v_p_966 = J.div(J.mod(_s239["t"], _s239["T"]), _s239["T"])
	v_k_967 = J.S_Object_("assign", [{}, _s239["__p"]["DEF"]])
	if J.cmp(v_i_965, _s239["n"], "<"):
		var _t812 = _s239["__p"]["kf"]
		var _t813 = J.cl(_t812, null, [[[0.0, {}], [0.4, {"lean": (-8.0), "bend": (-6.0), "dx": (-0.04), "hx": (-0.03), "hr": (-20.0), "sy": 1.03, "sx": 0.97, "head": (-4.0)}, "o"], [0.52, {"lean": 14.0, "bend": 10.0, "dx": 0.1, "hx": 0.05, "hr": (45.0 if J.t(J.gp(_s239["R"], "long")) else 15.0), "sy": 0.95, "sx": 1.05, "head": 4.0}, "i3"], [0.7, {"lean": 12.0, "bend": 9.0, "dx": 0.1, "hx": 0.05, "hr": (42.0 if J.t(J.gp(_s239["R"], "long")) else 14.0), "sy": 0.97, "sx": 1.03}, "o"], [1.0, {}, "io"]], v_p_966])
		v_k_967 = _t813
	v_front_968 = Callable(self, "_f138").bind(_s239)
	return {"k": v_k_967, "front": v_front_968}

func _f139(this_, a: Array, env):
	var v_v_974 = null
	v_v_974 = J.arg(a, 0)
	var _t818 = (J.mul(J.gp(v_v_974, "n"), 1.7) + 0.3)
	var _t817 = env["sp"]
	return J.div(_t818, J.cl(_t817, null, [v_v_974]))

func _f141(this_, a: Array, env):
	var v_ctx_990 = null; var v_P_991 = null; var v_j_992 = null; var v_g_993 = null
	v_ctx_990 = J.arg(a, 0)
	v_P_991 = J.arg(a, 1)
	v_j_992 = 0.0
	while true:
		if not J.cmp(v_j_992, env["n"], "<"): break
		v_g_993 = J.div(J.sub(env["t"], (J.mul(v_j_992, env["T"]) + 0.86)), env["s"])
		var _t822 = J.cmp(v_g_993, 0.0, "<")
		if (_t822 if _t822 else J.cmp(v_g_993, 0.35, ">")):
			v_j_992 = J.num(v_j_992) + 1.0
			continue
		J.mc(J.G.get("MoveKit"), "burst", [v_ctx_990, J.add(J.gp(J.gp(v_P_991, "mouth"), 0.0), J.mul(0.1, env["H"])), J.sub(J.gp(J.gp(v_P_991, "mouth"), 1.0), J.mul(0.02, env["H"])), J.mul(0.13, env["H"]), (1.0 - J.div(v_g_993, 0.35)), "#e8d0ff", J.add(40.0, v_j_992), 8.0])
		v_j_992 = J.num(v_j_992) + 1.0

func _f140(this_, a: Array, env):
	var v_a_977 = null; var v_R_978 = null; var v_at_979 = null; var v_v_980 = null; var v_i_986 = null; var v_p_987 = null; var v_k_988 = null; var v_front_989 = null
	var _s244 = {"__p": env, "s": null, "t": null, "H": null, "n": null, "T": null}
	v_a_977 = J.arg(a, 0)
	v_R_978 = J.arg(a, 1)
	v_at_979 = J.arg(a, 2)
	v_v_980 = J.arg(a, 3)
	var _t819 = _s244["__p"]["sp"]
	_s244["s"] = J.cl(_t819, null, [v_v_980])
	_s244["t"] = J.mul(v_at_979, _s244["s"])
	_s244["H"] = J.gp(v_a_977, "H")
	_s244["n"] = J.gp(v_v_980, "n")
	_s244["T"] = 1.7
	v_i_986 = floor(J.num(J.div(_s244["t"], _s244["T"])))
	v_p_987 = J.mod(_s244["t"], _s244["T"])
	v_k_988 = J.S_Object_("assign", [{}, _s244["__p"]["DEF"]])
	if J.cmp(v_i_986, _s244["n"], "<"):
		var _t820 = _s244["__p"]["kf"]
		var _t821 = J.cl(_t820, null, [[[0.0, {}], [0.45, {"sy": 0.9, "sx": 1.06, "bend": 22.0, "lean": 6.0, "head": 12.0, "hx": (-0.02), "hy": 0.03}, "io"], [0.75, {"sy": 0.9, "sx": 1.06, "bend": 24.0, "lean": 7.0, "head": 14.0, "hx": (-0.02), "hy": 0.03}], [0.86, {"dy": (-0.07), "sy": 1.12, "sx": 0.92, "bend": (-6.0), "lean": (-4.0), "head": (-12.0), "hx": 0.03, "hy": (-0.1), "hr": ((-70.0) if J.t(J.gp(v_R_978, "long")) else (-30.0))}, "o"], [1.25, {"dy": (-0.05), "sy": 1.08, "sx": 0.95, "bend": (-5.0), "lean": (-3.0), "head": (-10.0), "hx": 0.03, "hy": (-0.09), "hr": ((-66.0) if J.t(J.gp(v_R_978, "long")) else (-28.0))}], [1.7, {}, "io"]], v_p_987])
		v_k_988 = _t821
	v_front_989 = Callable(self, "_f141").bind(_s244)
	return {"k": v_k_988, "front": v_front_989}

func _f142(this_, a: Array, env):
	var v_v_994 = null
	v_v_994 = J.arg(a, 0)
	var _t825 = env["sp"]
	return J.div(2.8, J.cl(_t825, null, [v_v_994]))

func _f144(this_, a: Array, env):
	var v_ctx_1007 = null; var v_P_1008 = null
	v_ctx_1007 = J.arg(a, 0)
	v_P_1008 = J.arg(a, 1)
	var _t828 = J.cmp(env["e"], 0.5, ">")
	if ((absf(J.num(env["w"])) > 0.92) if _t828 else _t828):
		J.mc(J.G.get("MoveKit"), "burst", [v_ctx_1007, J.add(J.gp(J.gp(v_P_1008, "mouth"), 0.0), (J.mul(0.06, env["H"]) * signf(J.num(env["w"])))), J.sub(J.gp(J.gp(v_P_1008, "mouth"), 1.0), J.mul(0.05, env["H"])), J.mul(0.06, env["H"]), 0.6, "#ffe0f0", (60.0 + J.round(J.num(J.mul(env["t"], 3.0)))), 5.0])

func _f143(this_, a: Array, env):
	var v_a_997 = null; var v_R_998 = null; var v_at_999 = null; var v_v_1000 = null; var v_k_1005 = null; var v_front_1006 = null
	var _s249 = {"__p": env, "t": null, "H": null, "w": null, "e": null}
	v_a_997 = J.arg(a, 0)
	v_R_998 = J.arg(a, 1)
	v_at_999 = J.arg(a, 2)
	v_v_1000 = J.arg(a, 3)
	var _t826 = _s249["__p"]["sp"]
	_s249["t"] = J.mul(v_at_999, J.cl(_t826, null, [v_v_1000]))
	_s249["H"] = J.gp(v_a_997, "H")
	var _t827 = J.cmp(_s249["t"], 0.3, ">")
	_s249["w"] = (sin(J.num((J.sub(_s249["t"], 0.3) * 7.5))) if (J.cmp(_s249["t"], 2.4, "<") if _t827 else _t827) else 0.0)
	_s249["e"] = (J.min_([1.0, J.max_([0.0, (J.sub(_s249["t"], 0.3) * 4.0)])]) * J.min_([1.0, J.max_([0.0, (J.sub(2.4, _s249["t"]) * 4.0)])]))
	v_k_1005 = J.S_Object_("assign", [{}, _s249["__p"]["DEF"], {"head": (J.mul(J.mul(_s249["w"], 14.0), _s249["e"]) - J.mul(4.0, _s249["e"])), "lean": J.mul(J.mul(_s249["w"], 4.0), _s249["e"]), "sx": (1.0 + J.mul(J.mul(0.05, _s249["w"]), _s249["e"])), "sy": (1.0 - J.mul(J.mul(0.05, _s249["w"]), _s249["e"])), "hx": J.mul(0.02, _s249["e"]), "hy": J.mul((-0.04), _s249["e"]), "hr": J.mul(((-40.0) if J.t(J.gp(v_R_998, "long")) else (-14.0)), _s249["e"])}])
	v_front_1006 = Callable(self, "_f144").bind(_s249)
	return {"k": v_k_1005, "front": v_front_1006}

func _f145(this_, a: Array, env):
	var v_v_1009 = null
	v_v_1009 = J.arg(a, 0)
	var _t831 = env["sp"]
	return J.div(2.6, J.cl(_t831, null, [v_v_1009]))

func _f147(this_, a: Array, env):
	var v_ctx_1020 = null; var v_P_1021 = null; var v_j_1022 = null; var v_g_1023 = null
	v_ctx_1020 = J.arg(a, 0)
	v_P_1021 = J.arg(a, 1)
	v_j_1022 = 0.0
	while true:
		if not J.cmp(v_j_1022, 4.0, "<"): break
		v_g_1023 = (J.sub(env["t"], 0.6) - J.mul(v_j_1022, 0.25))
		var _t834 = env["__p"]["puff"]
		J.cl(_t834, null, [v_ctx_1020, J.add(J.add(J.gp(J.gp(v_P_1021, "mouth"), 0.0), J.mul(0.05, env["H"])), J.mul((J.max_([0.0, v_g_1023]) * 0.25), env["H"])), J.gp(J.gp(v_P_1021, "mouth"), 1.0), v_g_1023, 0.9, J.mul(0.22, env["H"]), J.add(80.0, v_j_1022)])
		v_j_1022 = J.num(v_j_1022) + 1.0

func _f146(this_, a: Array, env):
	var v_a_1012 = null; var v_R_1013 = null; var v_at_1014 = null; var v_v_1015 = null; var v_k_1018 = null; var v_front_1019 = null
	var _s252 = {"__p": env, "t": null, "H": null}
	v_a_1012 = J.arg(a, 0)
	v_R_1013 = J.arg(a, 1)
	v_at_1014 = J.arg(a, 2)
	v_v_1015 = J.arg(a, 3)
	var _t832 = _s252["__p"]["sp"]
	_s252["t"] = J.mul(v_at_1014, J.cl(_t832, null, [v_v_1015]))
	_s252["H"] = J.gp(v_a_1012, "H")
	var _t833 = _s252["__p"]["kf"]
	v_k_1018 = J.cl(_t833, null, [[[0.0, {}], [0.4, {"dy": 0.01, "sy": 1.04, "sx": 0.97, "bend": (-6.0), "head": (-8.0)}, "io"], [0.6, {"lean": 14.0, "bend": 12.0, "head": 8.0, "sy": 0.96, "sx": 1.03, "dx": 0.03}, "o"], [1.8, {"lean": 15.0, "bend": 13.0, "head": 9.0, "sy": 0.97, "sx": 1.02, "dx": 0.035}], [2.6, {}, "io"]], _s252["t"]])
	v_front_1019 = Callable(self, "_f147").bind(_s252)
	return {"k": v_k_1018, "front": v_front_1019}

func _f149(this_, a: Array, env):
	var v_ctx_1034 = null; var v_a_1035 = null
	v_ctx_1034 = J.arg(a, 0)
	v_a_1035 = J.arg(a, 1)
	var _t839 = env["__p"]["run"]
	return J.cl(_t839, null, [env["n"], v_ctx_1034, v_a_1035])

func _f1(this_, a: Array, env):
	var v_carry_53 = null; var v_drawWorker_69 = null; var v_drawAct_70 = null
	var _s2 = {"__p": env, "D": null, "TAU": null, "cl": null, "lerp": null, "seg": null, "E": null, "rnd": null, "ok": null, "DEF": null, "kf": null, "add": null, "HOPS": null, "ARMCARRY": null, "PAPER": null, "GLUTTON": null, "SOLIDS": null, "RC": null, "rigOf": null, "TOOLS": null, "M": null, "solve": null, "prop": null, "propH": null, "shadow": null, "drawBody": null, "drawTool": null, "drawHand": null, "render": null, "AIM": null, "aim": null, "crayon": null, "spray": null, "chips": null, "grains": null, "TINT": null, "tinted": null, "puff": null, "spark": null, "steam": null, "sweat": null, "coin": null, "coinFlat": null, "twinkle": null, "flame": null, "wisp": null, "bang": null, "sp": null, "ACT": null, "CHOP_T": null, "chopKeys": null, "handRot": null, "REAP_T": null, "reapKeys": null, "hammerKeys": null, "hamRot": null, "benchOf": null, "drawBench": null, "counterOf": null, "drawCounter": null, "run": null, "POST_ACTS": null, "defaults": null, "STATE": null, "pickNext": null, "plan": null, "SPECIAL_H": null}
	_s2["kf"] = Callable(self, "_f15").bind(_s2)
	_s2["rigOf"] = Callable(self, "_f18").bind(_s2)
	_s2["solve"] = Callable(self, "_f22").bind(_s2)
	_s2["prop"] = Callable(self, "_f27").bind(_s2)
	_s2["shadow"] = Callable(self, "_f29").bind(_s2)
	_s2["drawBody"] = Callable(self, "_f30").bind(_s2)
	_s2["drawTool"] = Callable(self, "_f31").bind(_s2)
	_s2["drawHand"] = Callable(self, "_f32").bind(_s2)
	_s2["render"] = Callable(self, "_f33").bind(_s2)
	_s2["aim"] = Callable(self, "_f34").bind(_s2)
	_s2["spray"] = Callable(self, "_f38").bind(_s2)
	_s2["chips"] = Callable(self, "_f39").bind(_s2)
	_s2["grains"] = Callable(self, "_f41").bind(_s2)
	_s2["tinted"] = Callable(self, "_f43").bind(_s2)
	_s2["puff"] = Callable(self, "_f44").bind(_s2)
	_s2["spark"] = Callable(self, "_f45").bind(_s2)
	_s2["steam"] = Callable(self, "_f46").bind(_s2)
	_s2["sweat"] = Callable(self, "_f47").bind(_s2)
	_s2["coin"] = Callable(self, "_f48").bind(_s2)
	_s2["coinFlat"] = Callable(self, "_f49").bind(_s2)
	_s2["twinkle"] = Callable(self, "_f50").bind(_s2)
	_s2["flame"] = Callable(self, "_f51").bind(_s2)
	_s2["wisp"] = Callable(self, "_f52").bind(_s2)
	_s2["bang"] = Callable(self, "_f53").bind(_s2)
	_s2["chopKeys"] = Callable(self, "_f55").bind(_s2)
	_s2["handRot"] = Callable(self, "_f56").bind(_s2)
	v_carry_53 = Callable(self, "_f63").bind(_s2)
	_s2["reapKeys"] = Callable(self, "_f72").bind(_s2)
	_s2["hammerKeys"] = Callable(self, "_f79").bind(_s2)
	_s2["benchOf"] = Callable(self, "_f81").bind(_s2)
	_s2["drawBench"] = Callable(self, "_f83").bind(_s2)
	_s2["counterOf"] = Callable(self, "_f96").bind(_s2)
	_s2["drawCounter"] = Callable(self, "_f98").bind(_s2)
	_s2["run"] = Callable(self, "_f148").bind(_s2)
	_s2["defaults"] = Callable(self, "_f150").bind(_s2)
	_s2["pickNext"] = Callable(self, "_f152").bind(_s2)
	_s2["plan"] = Callable(self, "_f156").bind(_s2)
	v_drawWorker_69 = Callable(self, "_f158").bind(_s2)
	v_drawAct_70 = Callable(self, "_f159").bind(_s2)
	_s2["D"] = J.div(PI, 180.0)
	_s2["TAU"] = (PI * 2.0)
	_s2["cl"] = Callable(self, "_f2").bind(_s2)
	_s2["lerp"] = Callable(self, "_f3").bind(_s2)
	_s2["seg"] = Callable(self, "_f4").bind(_s2)
	_s2["E"] = {"lin": Callable(self, "_f5").bind(_s2), "o": Callable(self, "_f6").bind(_s2), "i": Callable(self, "_f7").bind(_s2), "io": Callable(self, "_f8").bind(_s2), "o3": Callable(self, "_f9").bind(_s2), "i3": Callable(self, "_f10").bind(_s2), "sin": Callable(self, "_f11").bind(_s2), "back": Callable(self, "_f12").bind(_s2)}
	_s2["rnd"] = Callable(self, "_f13").bind(_s2)
	_s2["ok"] = Callable(self, "_f14").bind(_s2)
	_s2["DEF"] = {"lean": 0.0, "dx": 0.0, "dy": 0.0, "sx": 1.0, "sy": 1.0, "bend": 0.0, "head": 0.0, "hx": 0.0, "hy": 0.0, "hr": 0.0, "ang": 0.0}
	_s2["add"] = Callable(self, "_f17").bind(_s2)
	_s2["HOPS"] = {"laojiang": 1.0, "zombie": 1.0, "pocong": 1.0}
	_s2["ARMCARRY"] = {"laojiang": 1.0, "zombie": 1.0}
	_s2["PAPER"] = {"zhiren": 1.0, "xiaozhi": 1.0}
	_s2["GLUTTON"] = {"egui": 1.0, "eguiking": 1.0}
	_s2["SOLIDS"] = {"laojiang": 1.0, "zombie": 1.0, "pocong": 1.0, "xiaozhi": 1.0, "zhiren": 1.0, "penanggal": 1.0, "npc_ken": 1.0, "npc_boss": 1.0, "npc_guard": 1.0, "npc_auntie": 1.0}
	_s2["RC"] = {}
	_s2["TOOLS"] = {"axe": {"key": "tool_axe", "len": 0.44, "grip": [0.5, 0.86], "head": [0.42, 0.2], "mir": true}, "mallet": {"key": "tool_mallet", "len": 0.34, "grip": [0.5, 0.86], "head": [0.5, 0.18], "mir": false}, "sickle": {"key": "tool_sickle", "len": 0.32, "grip": [0.13, 0.86], "head": [0.6, 0.2], "mir": false}}
	_s2["M"] = Callable(self, "_f21").bind(_s2)
	_s2["propH"] = Callable(self, "_f28").bind(_s2)
	_s2["AIM"] = {}
	_s2["crayon"] = Callable(self, "_f37").bind(_s2)
	_s2["TINT"] = {}
	_s2["sp"] = Callable(self, "_f54").bind(_s2)
	_s2["ACT"] = {}
	_s2["CHOP_T"] = 1.25
	var _t358 = _s2["ACT"]
	var _t398 = {"dur": Callable(self, "_f57").bind(_s2), "f": Callable(self, "_f58").bind(_s2)}
	J.sp(_t358, "chop", _t398)
	var _t399 = _s2["ACT"]
	var _t400 = J.cl(v_carry_53, null, ["wood__log", 0.4, "wood__log"])
	J.sp(_t399, "haul", _t400)
	var _t401 = _s2["ACT"]
	var _t402 = J.cl(v_carry_53, null, ["store__crate", 0.3, "store__crate"])
	J.sp(_t401, "crate", _t402)
	var _t403 = _s2["ACT"]
	var _t421 = {"dur": Callable(self, "_f69").bind(_s2), "f": Callable(self, "_f70").bind(_s2)}
	J.sp(_t403, "rest", _t421)
	_s2["REAP_T"] = 0.95
	var _t422 = _s2["ACT"]
	var _t443 = {"dur": Callable(self, "_f73").bind(_s2), "f": Callable(self, "_f74").bind(_s2)}
	J.sp(_t422, "reap", _t443)
	var _t444 = _s2["ACT"]
	var _t471 = {"dur": Callable(self, "_f76").bind(_s2), "f": Callable(self, "_f77").bind(_s2)}
	J.sp(_t444, "plant", _t471)
	_s2["hamRot"] = Callable(self, "_f80").bind(_s2)
	var _t473 = _s2["ACT"]
	var _t497 = {"dur": Callable(self, "_f84").bind(_s2), "f": Callable(self, "_f85").bind(_s2)}
	J.sp(_t473, "hammer", _t497)
	var _t498 = _s2["ACT"]
	var _t511 = {"dur": Callable(self, "_f88").bind(_s2), "f": Callable(self, "_f89").bind(_s2)}
	J.sp(_t498, "sand", _t511)
	var _t512 = _s2["ACT"]
	var _t526 = {"dur": Callable(self, "_f92").bind(_s2), "f": Callable(self, "_f93").bind(_s2)}
	J.sp(_t512, "sight", _t526)
	var _t527 = _s2["ACT"]
	var _t559 = {"dur": Callable(self, "_f99").bind(_s2), "f": Callable(self, "_f100").bind(_s2)}
	J.sp(_t527, "knead", _t559)
	var _t560 = _s2["ACT"]
	var _t586 = {"dur": Callable(self, "_f106").bind(_s2), "f": Callable(self, "_f107").bind(_s2)}
	J.sp(_t560, "steam", _t586)
	var _t587 = _s2["ACT"]
	var _t643 = {"dur": Callable(self, "_f110").bind(_s2), "f": Callable(self, "_f111").bind(_s2)}
	J.sp(_t587, "sneak", _t643)
	var _t644 = _s2["ACT"]
	var _t702 = {"dur": Callable(self, "_f117").bind(_s2), "f": Callable(self, "_f118").bind(_s2)}
	J.sp(_t644, "coins", _t702)
	var _t703 = _s2["ACT"]
	var _t715 = {"dur": Callable(self, "_f121").bind(_s2), "f": Callable(self, "_f122").bind(_s2)}
	J.sp(_t703, "push", _t715)
	var _t716 = _s2["ACT"]
	var _t747 = {"dur": Callable(self, "_f125").bind(_s2), "f": Callable(self, "_f126").bind(_s2)}
	J.sp(_t716, "inspect", _t747)
	var _t748 = _s2["ACT"]
	var _t781 = {"dur": Callable(self, "_f128").bind(_s2), "f": Callable(self, "_f129").bind(_s2)}
	J.sp(_t748, "burn", _t781)
	var _t782 = _s2["ACT"]
	var _t802 = {"dur": Callable(self, "_f131").bind(_s2), "f": Callable(self, "_f132").bind(_s2)}
	J.sp(_t782, "march", _t802)
	var _t803 = _s2["ACT"]
	var _t807 = {"dur": Callable(self, "_f134").bind(_s2), "f": Callable(self, "_f135").bind(_s2)}
	J.sp(_t803, "salute", _t807)
	var _t808 = _s2["ACT"]
	var _t815 = {"dur": Callable(self, "_f136").bind(_s2), "f": Callable(self, "_f137").bind(_s2)}
	J.sp(_t808, "drill", _t815)
	var _t816 = _s2["ACT"]
	var _t823 = {"dur": Callable(self, "_f139").bind(_s2), "f": Callable(self, "_f140").bind(_s2)}
	J.sp(_t816, "boo", _t823)
	var _t824 = _s2["ACT"]
	var _t829 = {"dur": Callable(self, "_f142").bind(_s2), "f": Callable(self, "_f143").bind(_s2)}
	J.sp(_t824, "grimace", _t829)
	var _t830 = _s2["ACT"]
	var _t835 = {"dur": Callable(self, "_f145").bind(_s2), "f": Callable(self, "_f146").bind(_s2)}
	J.sp(_t830, "blow", _t835)
	for _t836 in J.keys(_s2["ACT"]):
		var _s257 = {"__p": _s2, "n": null}
		_s257["n"] = _t836
		var _t837 = J.G.get("DAILY")
		var _t838 = J.add("work_", _s257["n"])
		var _t840 = Callable(self, "_f149").bind(_s257)
		J.sp(_t837, _t838, _t840)
	_s2["POST_ACTS"] = {"wood": [["chop", 5.0], ["haul", 3.0], ["rest", 1.4]], "rice": [["reap", 5.0], ["plant", 4.0], ["rest", 1.4]], "plank": [["hammer", 5.0], ["sand", 3.0], ["sight", 2.0], ["rest", 0.8]], "bun": [["knead", 5.0], ["steam", 3.0], ["sneak", 1.5]], "store": [["crate", 4.0], ["coins", 4.0], ["push", 2.0]], "boss": [["inspect", 5.0], ["burn", 2.5], ["rest", 1.0]], "camp": [["boo", 4.0], ["grimace", 3.0], ["blow", 3.0]]}
	_s2["STATE"] = J.new_("Map", [])
	_s2["SPECIAL_H"] = {"toyol": 46.0, "pocong": 54.0, "penanggal": 52.0}
	return {"drawWorker": v_drawWorker_69, "drawAct": v_drawAct_70, "ACT": _s2["ACT"], "POST_ACTS": _s2["POST_ACTS"], "defaults": _s2["defaults"], "rigOf": _s2["rigOf"], "STATE": _s2["STATE"], "render": _s2["render"], "kf": _s2["kf"]}
