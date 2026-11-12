# 自動轉譯自 n30_moves.js（tools/jsgd.js）——唔好直接改，改原 JS 再轉
extends RefCounted

func run(env):
	var this_ = null; var a = []
	J.G["N30K"] = J.cl(Callable(self, "_f1").bind(env), null, [])
	J.G["N30M"] = {"begin": Callable(self, "_f35").bind(env), "end": Callable(self, "_f36").bind(env), "line": Callable(self, "_f37").bind(env)}
	var _t139 = J.G.get("MOVES")
	var _t145 = Callable(self, "_f38").bind(env)
	J.sp(_t139, "n30_diaosi", _t145)
	var _t146 = J.G.get("MOVES")
	var _t151 = Callable(self, "_f40").bind(env)
	J.sp(_t146, "n30_wutou", _t151)
	var _t152 = J.G.get("MOVES")
	var _t156 = Callable(self, "_f41").bind(env)
	J.sp(_t152, "n30_yecha", _t156)
	var _t157 = J.G.get("MOVES")
	var _t162 = Callable(self, "_f42").bind(env)
	J.sp(_t157, "n30_hanba", _t162)
	var _t163 = J.G.get("MOVES")
	var _t179 = Callable(self, "_f43").bind(env)
	J.sp(_t163, "n30_changgui", _t179)
	var _t180 = J.G.get("MOVES")
	var _t200 = Callable(self, "_f44").bind(env)
	J.sp(_t180, "n30_guixinniang", _t200)
	var _t201 = J.G.get("MOVES")
	var _t207 = Callable(self, "_f46").bind(env)
	J.sp(_t201, "n30_shanxiao", _t207)
	var _t208 = J.G.get("MOVES")
	var _t215 = Callable(self, "_f47").bind(env)
	J.sp(_t208, "n30_baigujing", _t215)
	var _t216 = J.G.get("MOVES")
	var _t234 = Callable(self, "_f48").bind(env)
	J.sp(_t216, "n30_qionggui", _t234)
	var _t235 = J.G.get("MOVES")
	var _t253 = Callable(self, "_f51").bind(env)
	J.sp(_t235, "n30_dugui", _t253)
	var _t254 = J.G.get("MOVES")
	var _t260 = Callable(self, "_f52").bind(env)
	J.sp(_t254, "n30_jiugui", _t260)
	var _t261 = J.G.get("MOVES")
	var _t270 = Callable(self, "_f53").bind(env)
	J.sp(_t261, "n30_yangui", _t270)
	var _t271 = J.G.get("MOVES")
	var _t277 = Callable(self, "_f54").bind(env)
	J.sp(_t271, "n30_guhangui", _t277)
	var _t278 = J.G.get("MOVES")
	var _t283 = Callable(self, "_f55").bind(env)
	J.sp(_t278, "n30_taozhai", _t283)
	var _t284 = J.G.get("MOVES")
	var _t292 = Callable(self, "_f56").bind(env)
	J.sp(_t284, "n30_danxiao", _t292)
	var _t293 = J.G.get("MOVES")
	var _t298 = Callable(self, "_f57").bind(env)
	J.sp(_t293, "n30_maoshi", _t298)
	var _t299 = J.G.get("MOVES")
	var _t307 = Callable(self, "_f58").bind(env)
	J.sp(_t299, "n30_hanturaya", _t307)
	var _t308 = J.G.get("MOVES")
	var _t314 = Callable(self, "_f59").bind(env)
	J.sp(_t308, "n30_polong", _t314)
	var _t315 = J.G.get("MOVES")
	var _t319 = Callable(self, "_f61").bind(env)
	J.sp(_t315, "n30_pelesit", _t319)
	var _t320 = J.G.get("MOVES")
	var _t326 = Callable(self, "_f62").bind(env)
	J.sp(_t320, "n30_jenglot", _t326)
	var _t327 = J.G.get("MOVES")
	var _t331 = Callable(self, "_f63").bind(env)
	J.sp(_t327, "n30_hantugalah", _t331)
	var _t332 = J.G.get("MOVES")
	var _t345 = Callable(self, "_f64").bind(env)
	J.sp(_t332, "n30_jerangkung", _t345)
	var _t346 = J.G.get("MOVES")
	var _t354 = Callable(self, "_f65").bind(env)
	J.sp(_t346, "n30_genderuwo", _t354)
	var _t355 = J.G.get("MOVES")
	var _t365 = Callable(self, "_f66").bind(env)
	J.sp(_t355, "n30_bunian", _t365)
	var _t366 = J.G.get("MOVES")
	var _t370 = Callable(self, "_f68").bind(env)
	J.sp(_t366, "n30_maenak", _t370)
	var _t371 = J.G.get("MOVES")
	var _t376 = Callable(self, "_f70").bind(env)
	J.sp(_t371, "n30_phiam", _t376)
	var _t377 = J.G.get("MOVES")
	var _t388 = Callable(self, "_f71").bind(env)
	J.sp(_t377, "n30_churel", _t388)
	var _t389 = J.G.get("MOVES")
	var _t400 = Callable(self, "_f72").bind(env)
	J.sp(_t389, "n30_vetala", _t400)
	var _t401 = J.G.get("MOVES")
	var _t405 = Callable(self, "_f73").bind(env)
	J.sp(_t401, "n30_kappa", _t405)
	var _t406 = J.G.get("MOVES")
	var _t410 = Callable(self, "_f74").bind(env)
	J.sp(_t406, "n30_rokurokubi", _t410)
	var _t411 = J.G.get("MOVES")
	var _t416 = Callable(self, "_f75").bind(env)
	J.sp(_t411, "n30_kuchisake", _t416)
	var _t417 = J.G.get("MOVES")
	var _t431 = Callable(self, "_f76").bind(env)
	J.sp(_t417, "n30_yukionna", _t431)
	var _t432 = J.G.get("MOVES")
	var _t441 = Callable(self, "_f77").bind(env)
	J.sp(_t432, "n30_kasaobake", _t441)
	var _t442 = J.G.get("MOVES")
	var _t448 = Callable(self, "_f78").bind(env)
	J.sp(_t442, "n30_nopperabo", _t448)
	var _t449 = J.G.get("MOVES")
	var _t461 = Callable(self, "_f79").bind(env)
	J.sp(_t449, "n30_chochin", _t461)
	var _t462 = J.G.get("MOVES")
	var _t467 = Callable(self, "_f80").bind(env)
	J.sp(_t462, "n30_gashadokuro", _t467)
	var _t468 = J.G.get("MOVES")
	var _t477 = Callable(self, "_f81").bind(env)
	J.sp(_t468, "n30_banshee", _t477)
	var _t478 = J.G.get("MOVES")
	var _t489 = Callable(self, "_f82").bind(env)
	J.sp(_t478, "n30_hannya", _t489)
	var _t490 = J.G.get("MOVES")
	var _t499 = Callable(self, "_f83").bind(env)
	J.sp(_t490, "n30_aswang", _t499)
	var _t500 = J.G.get("MOVES")
	var _t506 = Callable(self, "_f85").bind(env)
	J.sp(_t500, "n30_tikbalang", _t506)
	var _t507 = J.G.get("N30M")
	var _t509 = Callable(self, "_f86").bind(env)
	J.sp(_t507, "bolt", _t509)
	var _t510 = J.G.get("N30M")
	var _t520 = Callable(self, "_f87").bind(env)
	J.sp(_t510, "cloud", _t520)
	var _t521 = J.G.get("MOVES")
	var _t537 = Callable(self, "_f89").bind(env)
	J.sp(_t521, "n30_chehuo", _t537)
	var _t538 = J.G.get("MOVES")
	var _t545 = Callable(self, "_f90").bind(env)
	J.sp(_t538, "n30_diansi", _t545)
	var _t546 = J.G.get("MOVES")
	var _t553 = Callable(self, "_f91").bind(env)
	J.sp(_t546, "n30_dongsi", _t553)
	var _t554 = J.G.get("MOVES")
	var _t564 = Callable(self, "_f92").bind(env)
	J.sp(_t554, "n30_yezi", _t564)
	var _t565 = J.G.get("MOVES")
	var _t581 = Callable(self, "_f93").bind(env)
	J.sp(_t565, "n30_liulian", _t581)
	var _t582 = J.G.get("MOVES")
	var _t591 = Callable(self, "_f94").bind(env)
	J.sp(_t582, "n30_yesi", _t591)
	var _t592 = J.G.get("MOVES")
	var _t602 = Callable(self, "_f96").bind(env)
	J.sp(_t592, "n30_xiaosi", _t602)
	var _t603 = J.G.get("MOVES")
	var _t610 = Callable(self, "_f97").bind(env)
	J.sp(_t603, "n30_xiasi", _t610)
	var _t611 = J.G.get("MOVES")
	var _t615 = Callable(self, "_f98").bind(env)
	J.sp(_t611, "n30_leipi", _t615)
	var _t616 = J.G.get("MOVES")
	var _t620 = Callable(self, "_f99").bind(env)
	J.sp(_t616, "n30_zipai", _t620)
	var _t621 = J.G.get("MOVES")
	var _t631 = Callable(self, "_f100").bind(env)
	J.sp(_t621, "n30_zhongshu", _t631)
	var _t632 = J.G.get("MOVES")
	var _t637 = Callable(self, "_f101").bind(env)
	J.sp(_t632, "n30_chengsi", _t637)
	var _t638 = J.G.get("MOVES")
	var _t653 = Callable(self, "_f102").bind(env)
	J.sp(_t638, "n30_shedu", _t653)
	var _t654 = J.G.get("MOVES")
	var _t666 = Callable(self, "_f103").bind(env)
	J.sp(_t654, "n30_shidu", _t666)
	var _t667 = J.G.get("MOVES")
	var _t684 = Callable(self, "_f104").bind(env)
	J.sp(_t667, "n30_daji", _t684)
	var _t685 = J.G.get("MOVES")
	var _t695 = Callable(self, "_f106").bind(env)
	J.sp(_t685, "n30_xiangcai", _t695)

func _f3(this_, a: Array, env):
	var v_a_51 = null; var v_id_52 = null; var v_o_53 = null; var v_img_54 = null; var v_fw_55 = null; var v_s_56 = null; var v_H_57 = null; var v_W_58 = null; var v_nr_59 = null; var v_tt_60 = null; var v_lg_61 = null; var v_th_62 = null; var v_tx_63 = null; var v_ty_64 = null; var v_fl_65 = null
	v_a_51 = J.arg(a, 0)
	v_id_52 = J.gp(v_a_51, "type")
	v_o_53 = J.gp(v_a_51, "o")
	var _t1 = env["ok"]
	var _t2 = (not J.t(J.cl(_t1, null, [v_id_52])))
	if (_t2 if _t2 else J.seq(J.typeof_(J.G.get("MeshAnim")), "undefined")):
		return null
	v_img_54 = J.gp(J.G.get("SPR"), v_id_52)
	v_fw_55 = (1.0 if J.t(J.gp(v_a_51, "faceRight")) else (-1.0))
	v_s_56 = J.gp(v_a_51, "s")
	v_H_57 = J.gp(v_a_51, "H")
	v_W_58 = J.div(J.mul(v_H_57, J.gp(v_img_54, "naturalWidth")), J.gp(v_img_54, "naturalHeight"))
	v_nr_59 = (not (not J.t(J.gp(J.gp(J.G.get("MeshAnim"), "NATIVE_R"), v_id_52))))
	v_tt_60 = J.mc(env["K"], "tau", [v_o_53])
	v_lg_61 = J.mc(env["K"], "lungeOf", [v_o_53, v_s_56])
	v_th_62 = J.mul(58.0, v_s_56)
	v_tx_63 = J.max_([J.mul(0.3, v_H_57), J.sub((J.mul(J.gp(v_o_53, "tdx"), v_fw_55) if (not J.leq(J.gp(v_o_53, "tdx"), null)) else J.mul(44.0, v_s_56)), v_lg_61)])
	var _t3 = J.gp(v_o_53, "tdy")
	v_ty_64 = (_t3 if J.t(_t3) else 0.0)
	var _t5 = null
	if J.t(J.gp(v_a_51, "solid")):
		_t5 = 0.0
	else:
		var _t4 = J.gp(v_o_53, "t")
		_t5 = J.mul((3.0 + (sin(J.num(J.mul((_t4 if J.t(_t4) else 0.0), 2.4))) * 2.0)), v_s_56)
	v_fl_65 = _t5
	var _t6 = J.gp(v_o_53, "t")
	return {"a": v_a_51, "id": v_id_52, "o": v_o_53, "fw": v_fw_55, "s": v_s_56, "H": v_H_57, "W": v_W_58, "nr": v_nr_59, "tt": v_tt_60, "tx": v_tx_63, "ty": v_ty_64, "th": v_th_62, "fl": v_fl_65, "t": (_t6 if J.t(_t6) else 0.0), "solid": J.gp(v_a_51, "solid"), "back": J.mc(env["K"], "tgtBack", [v_tt_60, v_th_62]), "img": v_img_54}

func _f4(this_, a: Array, env):
	var v_t_68 = null; var v_keys_69 = null; var v_i_70 = null; var v_t0_71 = null; var v_A_72 = null; var v_t1_73 = null; var v_B_74 = null; var v_ez_75 = null; var v_p_76 = null; var v_k_77 = null; var v_r_78 = null; var v_n_79 = null; var v_n_80 = null
	v_t_68 = J.arg(a, 0)
	v_keys_69 = J.arg(a, 1)
	if J.cmp(v_t_68, J.gp(J.gp(v_keys_69, 0.0), 0.0), "<="):
		return J.S_Object_("assign", [{}, J.gp(J.gp(v_keys_69, 0.0), 1.0)])
	v_i_70 = 0.0
	while true:
		if not J.cmp(v_i_70, (J.len(v_keys_69) - 1.0), "<"): break
		var _t7 = J.gp(v_keys_69, v_i_70)
		var _t8 = J.gp(_t7, 0.0)
		v_t0_71 = _t8
		var _t9 = J.gp(_t7, 1.0)
		v_A_72 = _t9
		var _t10 = J.gp(v_keys_69, J.add(v_i_70, 1.0))
		var _t11 = J.gp(_t10, 0.0)
		v_t1_73 = _t11
		var _t12 = J.gp(_t10, 1.0)
		v_B_74 = _t12
		var _t13 = J.gp(_t10, 2.0)
		v_ez_75 = _t13
		if J.cmp(v_t_68, v_t1_73, "<="):
			var _t15 = J.sub(v_t_68, v_t0_71)
			var _t14 = J.sub(v_t1_73, v_t0_71)
			v_p_76 = J.div(_t15, (_t14 if J.t(_t14) else 1.0))
			v_k_77 = (v_p_76 if J.seq(v_ez_75, "lin") else (J.mc(env["E"], "o", [v_p_76]) if J.seq(v_ez_75, "o") else (J.mc(env["E"], "i", [v_p_76]) if J.seq(v_ez_75, "i") else (J.mc(env["E"], "back", [v_p_76]) if J.seq(v_ez_75, "back") else J.mc(env["E"], "io", [v_p_76])))))
			v_r_78 = {}
			for _t16 in J.keys(v_A_72):
				v_n_79 = _t16
				var _t17 = env["lerp"]
				var _t20 = J.gp(v_A_72, v_n_79)
				var _t19 = null
				if (not J.leq(J.gp(v_B_74, v_n_79), null)):
					_t19 = J.gp(v_B_74, v_n_79)
				else:
					var _t18 = J.gp(env["ONE"], v_n_79)
					_t19 = (_t18 if J.t(_t18) else 0.0)
				var _t21 = J.cl(_t17, null, [_t20, _t19, v_k_77])
				J.sp(v_r_78, v_n_79, _t21)
			for _t22 in J.keys(v_B_74):
				v_n_80 = _t22
				if (not J.has(v_A_72, v_n_80)):
					var _t23 = env["lerp"]
					var _t24 = J.gp(env["ONE"], v_n_80)
					var _t25 = J.cl(_t23, null, [(_t24 if J.t(_t24) else 0.0), J.gp(v_B_74, v_n_80), v_k_77])
					J.sp(v_r_78, v_n_80, _t25)
			return v_r_78
		v_i_70 = J.num(v_i_70) + 1.0
	return J.S_Object_("assign", [{}, J.gp(J.gp(v_keys_69, (J.len(v_keys_69) - 1.0)), 1.0)])

func _f5(this_, a: Array, env):
	var v_S_83 = null; var v_f_84 = null; var v_px_85 = null; var v_py_86 = null
	v_S_83 = J.arg(a, 0)
	v_f_84 = J.arg(a, 1)
	v_px_85 = (J.gp(v_f_84, "px") if (not J.leq(J.gp(v_f_84, "px"), null)) else 0.0)
	v_py_86 = (J.gp(v_f_84, "py") if (not J.leq(J.gp(v_f_84, "py"), null)) else J.mul((-0.45), J.gp(v_S_83, "H")))
	var _t26 = J.construct(env["M"], [])
	var _t27 = J.gp(v_f_84, "x")
	var _t29 = (_t27 if J.t(_t27) else 0.0)
	var _t28 = J.gp(v_f_84, "y")
	var _t30 = J.mc(_t26, "t", [_t29, J.sub((_t28 if J.t(_t28) else 0.0), J.gp(v_S_83, "fl"))])
	var _t31 = J.mc(_t30, "t", [v_px_85, v_py_86])
	var _t32 = J.gp(v_f_84, "r")
	var _t33 = J.mc(_t31, "r", [J.mul((_t32 if J.t(_t32) else 0.0), env["D"])])
	var _t34 = J.mc(_t33, "t", [(-J.num(v_px_85)), (-J.num(v_py_86))])
	return J.mc(_t34, "s", [(J.gp(v_f_84, "sx") if (not J.leq(J.gp(v_f_84, "sx"), null)) else 1.0), (J.gp(v_f_84, "sy") if (not J.leq(J.gp(v_f_84, "sy"), null)) else 1.0)])

func _f6(this_, a: Array, env):
	var v_S_89 = null; var v_f_90 = null; var v_idleK_91 = null; var v_z_92 = null; var v_k_93 = null; var v_n_94 = null; var v_n_95 = null
	v_S_89 = J.arg(a, 0)
	v_f_90 = J.arg(a, 1)
	v_idleK_91 = J.arg(a, 2)
	var _t35 = J.gp(J.G.get("MeshAnim"), "ANIM")
	v_z_92 = J.mc(_t35, "idle", [J.gp(v_S_89, "t")])
	v_k_93 = (0.5 if J.leq(v_idleK_91, null) else v_idleK_91)
	for _t36 in J.keys(v_z_92):
		v_n_94 = _t36
		if J.seq(J.typeof_(J.gp(v_z_92, v_n_94)), "number"):
			var _t37 = J.seq(v_n_94, "sx")
			var _t38 = ((1.0 + J.mul(J.sub(J.gp(v_z_92, v_n_94), 1.0), v_k_93)) if (_t37 if _t37 else J.seq(v_n_94, "sy")) else J.mul(J.gp(v_z_92, v_n_94), v_k_93))
			J.sp(v_z_92, v_n_94, _t38)
	J.sp(v_z_92, "x", 0.0)
	J.sp(v_z_92, "rot", 0.0)
	for _t39 in J.keys(v_f_90):
		v_n_95 = _t39
		if (not J.t(J.gp(env["TF"], v_n_95))):
			var _t40 = J.gp(v_z_92, v_n_95)
			var _t41 = J.add((_t40 if J.t(_t40) else 0.0), (J.gp(v_f_90, v_n_95) if J.t(J.gp(v_S_89, "nr")) else (-J.num(J.gp(v_f_90, v_n_95)))))
			J.sp(v_z_92, v_n_95, _t41)
	return v_z_92

func _f7(this_, a: Array, env):
	var v_ctx_98 = null; var v_S_99 = null; var v_m_100 = null; var v_mp_101 = null; var v_key_102 = null; var v_alpha_103 = null
	v_ctx_98 = J.arg(a, 0)
	v_S_99 = J.arg(a, 1)
	v_m_100 = J.arg(a, 2)
	v_mp_101 = J.arg(a, 3)
	v_key_102 = J.arg(a, 4)
	v_alpha_103 = J.arg(a, 5)
	J.mc(v_ctx_98, "save", [])
	J.mc(v_m_100, "set", [v_ctx_98])
	if (not J.t(J.gp(v_S_99, "nr"))):
		J.mc(v_ctx_98, "scale", [(-1.0), 1.0])
	if (not J.leq(v_alpha_103, null)):
		var _t42 = J.mul(J.gp(v_ctx_98, "globalAlpha"), v_alpha_103)
		J.sp(v_ctx_98, "globalAlpha", _t42)
	J.mc(J.G.get("MeshAnim"), "drawBody", [v_ctx_98, J.gp(v_S_99, "id"), (v_key_102 if J.t(v_key_102) else J.gp(v_S_99, "id")), J.gp(v_S_99, "H"), v_mp_101])
	J.mc(v_ctx_98, "restore", [])

func _f8(this_, a: Array, env):
	var v_ctx_106 = null; var v_S_107 = null; var v_f_108 = null; var v_key_109 = null; var v_idleK_110 = null
	v_ctx_106 = J.arg(a, 0)
	v_S_107 = J.arg(a, 1)
	v_f_108 = J.arg(a, 2)
	v_key_109 = J.arg(a, 3)
	v_idleK_110 = J.arg(a, 4)
	var _t43 = env["body"]
	var _t44 = env["bm"]
	var _t46 = J.cl(_t44, null, [v_S_107, v_f_108])
	var _t45 = env["pose"]
	J.cl(_t43, null, [v_ctx_106, v_S_107, _t46, J.cl(_t45, null, [v_S_107, v_f_108, v_idleK_110]), v_key_109, (J.gp(v_f_108, "a") if (not J.leq(J.gp(v_f_108, "a"), null)) else null)])

func _f11(this_, a: Array, env):
	var v_ctx_121 = null; var v_S_122 = null; var v_name_123 = null; var v_m_124 = null; var v_pu_125 = null; var v_pv_126 = null; var v_alpha_127 = null
	v_ctx_121 = J.arg(a, 0)
	v_S_122 = J.arg(a, 1)
	v_name_123 = J.arg(a, 2)
	v_m_124 = J.arg(a, 3)
	v_pu_125 = J.arg(a, 4)
	v_pv_126 = J.arg(a, 5)
	v_alpha_127 = J.arg(a, 6)
	J.mc(env["K"], "piece", [v_ctx_121, v_S_122, J.add(J.add(J.gp(v_S_122, "id"), "__"), v_name_123), v_m_124, v_pu_125, v_pv_126, v_alpha_127])

func _f12(this_, a: Array, env):
	var v_ctx_130 = null; var v_S_131 = null; var v_name_132 = null; var v_x_133 = null; var v_y_134 = null; var v_r_135 = null; var v_pu_136 = null; var v_pv_137 = null; var v_sx_138 = null; var v_sy_139 = null; var v_alpha_140 = null
	v_ctx_130 = J.arg(a, 0)
	v_S_131 = J.arg(a, 1)
	v_name_132 = J.arg(a, 2)
	v_x_133 = J.arg(a, 3)
	v_y_134 = J.arg(a, 4)
	v_r_135 = J.arg(a, 5)
	v_pu_136 = J.arg(a, 6)
	v_pv_137 = J.arg(a, 7)
	v_sx_138 = J.arg(a, 8)
	v_sy_139 = J.arg(a, 9)
	v_alpha_140 = J.arg(a, 10)
	var _t47 = env["piece"]
	var _t48 = J.construct(env["M"], [])
	var _t49 = J.mc(_t48, "t", [v_x_133, v_y_134])
	var _t50 = J.mc(_t49, "r", [J.mul((v_r_135 if J.t(v_r_135) else 0.0), env["D"])])
	J.cl(_t47, null, [v_ctx_130, v_S_131, v_name_132, J.mc(_t50, "s", [(v_sx_138 if J.t(v_sx_138) else 1.0), ((v_sx_138 if J.t(v_sx_138) else 1.0) if J.leq(v_sy_139, null) else v_sy_139)]), v_pu_136, v_pv_137, v_alpha_140])

func _f14(this_, a: Array, env):
	var v_px_177 = null; var v_py_178 = null; var v_dx_179 = null; var v_dy_180 = null; var v_l_181 = null
	v_px_177 = J.arg(a, 0)
	v_py_178 = J.arg(a, 1)
	v_dx_179 = J.sub(v_px_177, env["cx"])
	v_dy_180 = J.sub(v_py_178, env["cy"])
	var _t63 = J.hypot_([v_dx_179, v_dy_180])
	v_l_181 = (_t63 if J.t(_t63) else 1.0)
	return [J.add(v_px_177, J.mul(J.div(v_dx_179, v_l_181), env["e"])), J.add(v_py_178, J.mul(J.div(v_dy_180, v_l_181), env["e"]))]

func _f13(this_, a: Array, env):
	var v_ctx_143 = null; var v_img_144 = null; var v_s0_145 = null; var v_s1_146 = null; var v_s2_147 = null; var v_d0_148 = null; var v_d1_149 = null; var v_d2_150 = null; var v_u0_151 = null; var v_v0_152 = null; var v_u1_153 = null; var v_v1_154 = null; var v_u2_155 = null; var v_v2_156 = null; var v_x0_157 = null; var v_y0_158 = null; var v_x1_159 = null; var v_y1_160 = null; var v_x2_161 = null; var v_y2_162 = null; var v_den_163 = null; var v_ex_167 = null; var v_A_168 = null; var v_B_169 = null; var v_C_170 = null; var v_m11_171 = null; var v_m12_172 = null; var v_m21_173 = null; var v_m22_174 = null; var v_dx_175 = null; var v_dy_176 = null
	var _s21 = {"__p": env, "cx": null, "cy": null, "e": null}
	v_ctx_143 = J.arg(a, 0)
	v_img_144 = J.arg(a, 1)
	v_s0_145 = J.arg(a, 2)
	v_s1_146 = J.arg(a, 3)
	v_s2_147 = J.arg(a, 4)
	v_d0_148 = J.arg(a, 5)
	v_d1_149 = J.arg(a, 6)
	v_d2_150 = J.arg(a, 7)
	var _t51 = J.gp(v_s0_145, 0.0)
	v_u0_151 = _t51
	var _t52 = J.gp(v_s0_145, 1.0)
	v_v0_152 = _t52
	var _t53 = J.gp(v_s1_146, 0.0)
	v_u1_153 = _t53
	var _t54 = J.gp(v_s1_146, 1.0)
	v_v1_154 = _t54
	var _t55 = J.gp(v_s2_147, 0.0)
	v_u2_155 = _t55
	var _t56 = J.gp(v_s2_147, 1.0)
	v_v2_156 = _t56
	var _t57 = J.gp(v_d0_148, 0.0)
	v_x0_157 = _t57
	var _t58 = J.gp(v_d0_148, 1.0)
	v_y0_158 = _t58
	var _t59 = J.gp(v_d1_149, 0.0)
	v_x1_159 = _t59
	var _t60 = J.gp(v_d1_149, 1.0)
	v_y1_160 = _t60
	var _t61 = J.gp(v_d2_150, 0.0)
	v_x2_161 = _t61
	var _t62 = J.gp(v_d2_150, 1.0)
	v_y2_162 = _t62
	v_den_163 = ((J.mul(v_u0_151, J.sub(v_v1_154, v_v2_156)) + J.mul(v_u1_153, J.sub(v_v2_156, v_v0_152))) + J.mul(v_u2_155, J.sub(v_v0_152, v_v1_154)))
	if (absf(J.num(v_den_163)) < 0.000001):
		return null
	_s21["cx"] = J.div(J.add(J.add(v_x0_157, v_x1_159), v_x2_161), 3.0)
	_s21["cy"] = J.div(J.add(J.add(v_y0_158, v_y1_160), v_y2_162), 3.0)
	_s21["e"] = 0.6
	v_ex_167 = Callable(self, "_f14").bind(_s21)
	v_A_168 = J.cl(v_ex_167, null, [v_x0_157, v_y0_158])
	v_B_169 = J.cl(v_ex_167, null, [v_x1_159, v_y1_160])
	v_C_170 = J.cl(v_ex_167, null, [v_x2_161, v_y2_162])
	J.mc(v_ctx_143, "save", [])
	J.mc(v_ctx_143, "beginPath", [])
	J.mc(v_ctx_143, "moveTo", [J.gp(v_A_168, 0.0), J.gp(v_A_168, 1.0)])
	J.mc(v_ctx_143, "lineTo", [J.gp(v_B_169, 0.0), J.gp(v_B_169, 1.0)])
	J.mc(v_ctx_143, "lineTo", [J.gp(v_C_170, 0.0), J.gp(v_C_170, 1.0)])
	J.mc(v_ctx_143, "closePath", [])
	J.mc(v_ctx_143, "clip", [])
	v_m11_171 = J.div(((J.mul(v_x0_157, J.sub(v_v1_154, v_v2_156)) + J.mul(v_x1_159, J.sub(v_v2_156, v_v0_152))) + J.mul(v_x2_161, J.sub(v_v0_152, v_v1_154))), v_den_163)
	v_m12_172 = J.div(((J.mul(v_y0_158, J.sub(v_v1_154, v_v2_156)) + J.mul(v_y1_160, J.sub(v_v2_156, v_v0_152))) + J.mul(v_y2_162, J.sub(v_v0_152, v_v1_154))), v_den_163)
	v_m21_173 = J.div(((J.mul(v_x0_157, J.sub(v_u2_155, v_u1_153)) + J.mul(v_x1_159, J.sub(v_u0_151, v_u2_155))) + J.mul(v_x2_161, J.sub(v_u1_153, v_u0_151))), v_den_163)
	v_m22_174 = J.div(((J.mul(v_y0_158, J.sub(v_u2_155, v_u1_153)) + J.mul(v_y1_160, J.sub(v_u0_151, v_u2_155))) + J.mul(v_y2_162, J.sub(v_u1_153, v_u0_151))), v_den_163)
	v_dx_175 = J.div(((J.mul(v_x0_157, (J.mul(v_u1_153, v_v2_156) - J.mul(v_u2_155, v_v1_154))) + J.mul(v_x1_159, (J.mul(v_u2_155, v_v0_152) - J.mul(v_u0_151, v_v2_156)))) + J.mul(v_x2_161, (J.mul(v_u0_151, v_v1_154) - J.mul(v_u1_153, v_v0_152)))), v_den_163)
	v_dy_176 = J.div(((J.mul(v_y0_158, (J.mul(v_u1_153, v_v2_156) - J.mul(v_u2_155, v_v1_154))) + J.mul(v_y1_160, (J.mul(v_u2_155, v_v0_152) - J.mul(v_u0_151, v_v2_156)))) + J.mul(v_y2_162, (J.mul(v_u0_151, v_v1_154) - J.mul(v_u1_153, v_v0_152)))), v_den_163)
	J.mc(v_ctx_143, "transform", [v_m11_171, v_m12_172, v_m21_173, v_m22_174, v_dx_175, v_dy_176])
	J.mc(v_ctx_143, "drawImage", [v_img_144, 0.0, 0.0])
	J.mc(v_ctx_143, "restore", [])

func _f15(this_, a: Array, env):
	var v_pts_184 = null; var v_n_185 = null; var v_L_186 = null; var v_tot_187 = null; var v_out_188 = null; var v_j_189 = null; var v_i_190 = null; var v_i_191 = null; var v_s_192 = null; var v_k_193 = null
	v_pts_184 = J.arg(a, 0)
	v_n_185 = J.arg(a, 1)
	v_L_186 = [0.0]
	v_i_190 = 1.0
	while true:
		if not J.cmp(v_i_190, J.len(v_pts_184), "<"): break
		J.mc(v_L_186, "push", [J.add(J.gp(v_L_186, J.sub(v_i_190, 1.0)), J.hypot_([J.sub(J.gp(J.gp(v_pts_184, v_i_190), 0.0), J.gp(J.gp(v_pts_184, J.sub(v_i_190, 1.0)), 0.0)), J.sub(J.gp(J.gp(v_pts_184, v_i_190), 1.0), J.gp(J.gp(v_pts_184, J.sub(v_i_190, 1.0)), 1.0))]))])
		v_i_190 = J.num(v_i_190) + 1.0
	var _t64 = J.gp(v_L_186, (J.len(v_L_186) - 1.0))
	v_tot_187 = (_t64 if J.t(_t64) else 1.0)
	v_out_188 = []
	v_j_189 = 0.0
	v_i_191 = 0.0
	while true:
		if not J.cmp(v_i_191, v_n_185, "<"): break
		v_s_192 = J.div(J.mul(v_tot_187, v_i_191), J.sub(v_n_185, 1.0))
		while true:
			var _t65 = J.cmp(v_j_189, (J.len(v_pts_184) - 2.0), "<")
			if not (J.cmp(J.gp(v_L_186, J.add(v_j_189, 1.0)), v_s_192, "<") if _t65 else _t65): break
			v_j_189 = J.num(v_j_189) + 1.0
		var _t67 = J.sub(v_s_192, J.gp(v_L_186, v_j_189))
		var _t66 = J.sub(J.gp(v_L_186, J.add(v_j_189, 1.0)), J.gp(v_L_186, v_j_189))
		v_k_193 = J.div(_t67, (_t66 if J.t(_t66) else 1.0))
		var _t68 = env["lerp"]
		var _t70 = J.cl(_t68, null, [J.gp(J.gp(v_pts_184, v_j_189), 0.0), J.gp(J.gp(v_pts_184, J.add(v_j_189, 1.0)), 0.0), v_k_193])
		var _t69 = env["lerp"]
		J.mc(v_out_188, "push", [[_t70, J.cl(_t69, null, [J.gp(J.gp(v_pts_184, v_j_189), 1.0), J.gp(J.gp(v_pts_184, J.add(v_j_189, 1.0)), 1.0), v_k_193])]])
		v_i_191 = J.num(v_i_191) + 1.0
	return {"pts": v_out_188, "len": v_tot_187}

func _f19(this_, a: Array, env):
	var v_p_223 = null
	v_p_223 = J.arg(a, 0)
	return [J.mul(J.gp(v_p_223, 0.0), env["iw"]), J.mul(J.gp(v_p_223, 1.0), env["ih"])]

func _f18(this_, a: Array, env):
	var v_ctx_204 = null; var v_S_205 = null; var v_name_206 = null; var v_srcUV_207 = null; var v_hw_208 = null; var v_dst_209 = null; var v_wk_210 = null; var v_key_211 = null; var v_img_212 = null; var v_N_215 = null; var v_Sp_216 = null; var v_SN_217 = null; var v_Dp_218 = null; var v_DN_219 = null; var v_sw_220 = null; var v_dw_221 = null; var v_flip_222 = null; var v_i_224 = null; var v_w0_225 = null; var v_w1_226 = null; var v_sa_227 = null; var v_sb_228 = null; var v_sc_229 = null; var v_sd_230 = null; var v_n0_231 = null; var v_n1_232 = null; var v_da_233 = null; var v_db_234 = null; var v_dc_235 = null; var v_dd_236 = null
	var _s29 = {"__p": env, "iw": null, "ih": null}
	v_ctx_204 = J.arg(a, 0)
	v_S_205 = J.arg(a, 1)
	v_name_206 = J.arg(a, 2)
	v_srcUV_207 = J.arg(a, 3)
	v_hw_208 = J.arg(a, 4)
	v_dst_209 = J.arg(a, 5)
	v_wk_210 = J.arg(a, 6)
	v_key_211 = J.add(J.add(J.gp(v_S_205, "id"), "__"), v_name_206)
	var _t71 = _s29["__p"]["ok"]
	if (not J.t(J.cl(_t71, null, [v_key_211]))):
		return null
	v_img_212 = J.gp(J.G.get("SPR"), v_key_211)
	_s29["iw"] = J.gp(v_img_212, "naturalWidth")
	_s29["ih"] = J.gp(v_img_212, "naturalHeight")
	v_N_215 = 28.0
	var _t72 = _s29["__p"]["resample"]
	v_Sp_216 = J.gp(J.cl(_t72, null, [J.mc(v_srcUV_207, "map", [Callable(self, "_f19").bind(_s29)]), v_N_215]), "pts")
	var _t73 = _s29["__p"]["normals"]
	v_SN_217 = J.cl(_t73, null, [v_Sp_216])
	var _t74 = _s29["__p"]["resample"]
	v_Dp_218 = J.gp(J.cl(_t74, null, [v_dst_209, v_N_215]), "pts")
	var _t75 = _s29["__p"]["normals"]
	v_DN_219 = J.cl(_t75, null, [v_Dp_218])
	v_sw_220 = J.mul(v_hw_208, _s29["ih"])
	v_dw_221 = J.mul(v_hw_208, J.gp(v_S_205, "H"))
	v_flip_222 = (1.0 if J.t(J.gp(v_S_205, "nr")) else (-1.0))
	v_i_224 = 0.0
	while true:
		if not J.cmp(v_i_224, J.sub(v_N_215, 1.0), "<"): break
		v_w0_225 = J.mul(v_dw_221, (J.cl(v_wk_210, null, [v_i_224, v_N_215]) if J.t(v_wk_210) else 1.0))
		v_w1_226 = J.mul(v_dw_221, (J.cl(v_wk_210, null, [J.add(v_i_224, 1.0), v_N_215]) if J.t(v_wk_210) else 1.0))
		v_sa_227 = [J.add(J.gp(J.gp(v_Sp_216, v_i_224), 0.0), J.mul(J.gp(J.gp(v_SN_217, v_i_224), 0.0), v_sw_220)), J.add(J.gp(J.gp(v_Sp_216, v_i_224), 1.0), J.mul(J.gp(J.gp(v_SN_217, v_i_224), 1.0), v_sw_220))]
		v_sb_228 = [J.sub(J.gp(J.gp(v_Sp_216, v_i_224), 0.0), J.mul(J.gp(J.gp(v_SN_217, v_i_224), 0.0), v_sw_220)), J.sub(J.gp(J.gp(v_Sp_216, v_i_224), 1.0), J.mul(J.gp(J.gp(v_SN_217, v_i_224), 1.0), v_sw_220))]
		v_sc_229 = [J.add(J.gp(J.gp(v_Sp_216, J.add(v_i_224, 1.0)), 0.0), J.mul(J.gp(J.gp(v_SN_217, J.add(v_i_224, 1.0)), 0.0), v_sw_220)), J.add(J.gp(J.gp(v_Sp_216, J.add(v_i_224, 1.0)), 1.0), J.mul(J.gp(J.gp(v_SN_217, J.add(v_i_224, 1.0)), 1.0), v_sw_220))]
		v_sd_230 = [J.sub(J.gp(J.gp(v_Sp_216, J.add(v_i_224, 1.0)), 0.0), J.mul(J.gp(J.gp(v_SN_217, J.add(v_i_224, 1.0)), 0.0), v_sw_220)), J.sub(J.gp(J.gp(v_Sp_216, J.add(v_i_224, 1.0)), 1.0), J.mul(J.gp(J.gp(v_SN_217, J.add(v_i_224, 1.0)), 1.0), v_sw_220))]
		v_n0_231 = J.gp(v_DN_219, v_i_224)
		v_n1_232 = J.gp(v_DN_219, J.add(v_i_224, 1.0))
		v_da_233 = [J.add(J.gp(J.gp(v_Dp_218, v_i_224), 0.0), J.mul(J.mul(J.gp(v_n0_231, 0.0), v_w0_225), v_flip_222)), J.add(J.gp(J.gp(v_Dp_218, v_i_224), 1.0), J.mul(J.mul(J.gp(v_n0_231, 1.0), v_w0_225), v_flip_222))]
		v_db_234 = [J.sub(J.gp(J.gp(v_Dp_218, v_i_224), 0.0), J.mul(J.mul(J.gp(v_n0_231, 0.0), v_w0_225), v_flip_222)), J.sub(J.gp(J.gp(v_Dp_218, v_i_224), 1.0), J.mul(J.mul(J.gp(v_n0_231, 1.0), v_w0_225), v_flip_222))]
		v_dc_235 = [J.add(J.gp(J.gp(v_Dp_218, J.add(v_i_224, 1.0)), 0.0), J.mul(J.mul(J.gp(v_n1_232, 0.0), v_w1_226), v_flip_222)), J.add(J.gp(J.gp(v_Dp_218, J.add(v_i_224, 1.0)), 1.0), J.mul(J.mul(J.gp(v_n1_232, 1.0), v_w1_226), v_flip_222))]
		v_dd_236 = [J.sub(J.gp(J.gp(v_Dp_218, J.add(v_i_224, 1.0)), 0.0), J.mul(J.mul(J.gp(v_n1_232, 0.0), v_w1_226), v_flip_222)), J.sub(J.gp(J.gp(v_Dp_218, J.add(v_i_224, 1.0)), 1.0), J.mul(J.mul(J.gp(v_n1_232, 1.0), v_w1_226), v_flip_222))]
		var _t76 = _s29["__p"]["tri"]
		J.cl(_t76, null, [v_ctx_204, v_img_212, v_sa_227, v_sb_228, v_sc_229, v_da_233, v_db_234, v_dc_235])
		var _t77 = _s29["__p"]["tri"]
		J.cl(_t77, null, [v_ctx_204, v_img_212, v_sb_228, v_sd_230, v_sc_229, v_db_234, v_dd_236, v_dc_235])
		v_i_224 = J.num(v_i_224) + 1.0

func _f26(this_, a: Array, env):
	var v_ctx_258 = null; var v_S_259 = null; var v_x_260 = null; var v_y_261 = null; var v_str_262 = null; var v_size_263 = null; var v_col_264 = null; var v_al_265 = null; var v_rot_266 = null; var v_z_267 = null
	v_ctx_258 = J.arg(a, 0)
	v_S_259 = J.arg(a, 1)
	v_x_260 = J.arg(a, 2)
	v_y_261 = J.arg(a, 3)
	v_str_262 = J.arg(a, 4)
	v_size_263 = J.arg(a, 5)
	v_col_264 = J.arg(a, 6)
	v_al_265 = J.arg(a, 7)
	v_rot_266 = J.arg(a, 8)
	var _t78 = J.seq(J.typeof_(v_str_262), "number")
	if (J.seq(J.typeof_(v_size_263), "string") if _t78 else _t78):
		v_z_267 = v_str_262
		v_str_262 = v_size_263
		v_size_263 = v_z_267
	if J.seq(J.typeof_(J.G.get("L")), "function"):
		var _t79 = J.G.get("L")
		var _t80 = J.cl(_t79, null, [v_str_262])
		v_str_262 = _t80
	var _t81 = (not J.leq(v_al_265, null))
	if (J.cmp(v_al_265, 0.0, "<=") if _t81 else _t81):
		return null
	J.mc(v_ctx_258, "save", [])
	J.mc(v_ctx_258, "translate", [v_x_260, v_y_261])
	J.mc(v_ctx_258, "scale", [J.gp(v_S_259, "fw"), 1.0])
	if J.t(v_rot_266):
		J.mc(v_ctx_258, "rotate", [v_rot_266])
	if (not J.leq(v_al_265, null)):
		var _t82 = env["cl"]
		var _t83 = J.mul(J.gp(v_ctx_258, "globalAlpha"), J.cl(_t82, null, [v_al_265]))
		J.sp(v_ctx_258, "globalAlpha", _t83)
	var _t84 = ("900 " + J.str(v_size_263) + "px \"PingFang TC\",\"Noto Sans TC\",\"Noto Sans CJK TC\",sans-serif")
	J.sp(v_ctx_258, "font", _t84)
	J.sp(v_ctx_258, "textAlign", "center")
	J.sp(v_ctx_258, "textBaseline", "middle")
	J.sp(v_ctx_258, "lineJoin", "round")
	var _t85 = J.max_([2.0, J.mul(v_size_263, 0.22)])
	J.sp(v_ctx_258, "lineWidth", _t85)
	J.sp(v_ctx_258, "strokeStyle", "rgba(26,20,38,.92)")
	J.mc(v_ctx_258, "strokeText", [v_str_262, 0.0, 0.0])
	var _t86 = (v_col_264 if J.t(v_col_264) else "#fff3d6")
	J.sp(v_ctx_258, "fillStyle", _t86)
	J.mc(v_ctx_258, "fillText", [v_str_262, 0.0, 0.0])
	J.mc(v_ctx_258, "restore", [])

func _f27(this_, a: Array, env):
	var v_ctx_270 = null; var v_S_271 = null; var v_x_272 = null; var v_y_273 = null; var v_str_274 = null; var v_size_275 = null; var v_col_276 = null; var v_t0_277 = null; var v_dur_278 = null; var v_p_279 = null; var v_z_280 = null
	v_ctx_270 = J.arg(a, 0)
	v_S_271 = J.arg(a, 1)
	v_x_272 = J.arg(a, 2)
	v_y_273 = J.arg(a, 3)
	v_str_274 = J.arg(a, 4)
	v_size_275 = J.arg(a, 5)
	v_col_276 = J.arg(a, 6)
	v_t0_277 = J.arg(a, 7)
	v_dur_278 = J.arg(a, 8)
	v_p_279 = J.div(J.sub(J.gp(v_S_271, "tt"), v_t0_277), v_dur_278)
	var _t87 = J.cmp(v_p_279, 0.0, "<")
	if (_t87 if _t87 else J.cmp(v_p_279, 1.0, ">")):
		return null
	v_z_280 = ((0.4 + (J.div(v_p_279, 0.15) * 0.75)) if J.cmp(v_p_279, 0.15, "<") else ((1.15 - (J.div(J.sub(v_p_279, 0.15), 0.1) * 0.15)) if J.cmp(v_p_279, 0.25, "<") else 1.0))
	J.mc(v_ctx_270, "save", [])
	J.mc(v_ctx_270, "translate", [v_x_272, J.sub(v_y_273, J.mul(J.mul(v_p_279, 0.08), J.gp(v_S_271, "H")))])
	J.mc(v_ctx_270, "scale", [v_z_280, v_z_280])
	var _t88 = env["txt"]
	var _t90 = (J.div(J.sub(1.0, v_p_279), 0.25) if J.cmp(v_p_279, 0.75, ">") else 1.0)
	var _t89 = env["rnd"]
	J.cl(_t88, null, [v_ctx_270, v_S_271, 0.0, 0.0, v_str_274, v_size_275, v_col_276, _t90, (J.sub(J.cl(_t89, null, [J.len(v_str_274)]), 0.5) * 0.25)])
	J.mc(v_ctx_270, "restore", [])

func _f28(this_, a: Array, env):
	var v_ctx_283 = null; var v_x_284 = null; var v_y_285 = null; var v_r_286 = null; var v_k_287 = null; var v_col_288 = null; var v_seed_289 = null; var v_n_290 = null; var v_i_291 = null; var v_an_292 = null; var v_d_293 = null; var v_rr_294 = null
	v_ctx_283 = J.arg(a, 0)
	v_x_284 = J.arg(a, 1)
	v_y_285 = J.arg(a, 2)
	v_r_286 = J.arg(a, 3)
	v_k_287 = J.arg(a, 4)
	v_col_288 = J.arg(a, 5)
	v_seed_289 = J.arg(a, 6)
	v_n_290 = J.arg(a, 7)
	var _t91 = J.cmp(v_k_287, 0.0, "<=")
	if (_t91 if _t91 else J.cmp(v_k_287, 1.0, ">=")):
		return null
	var _t92 = (v_n_290 if J.t(v_n_290) else 5.0)
	v_n_290 = _t92
	J.mc(v_ctx_283, "save", [])
	var _t93 = J.mul(J.gp(v_ctx_283, "globalAlpha"), (sin(J.num(J.mul(v_k_287, PI))) * 0.85))
	J.sp(v_ctx_283, "globalAlpha", _t93)
	v_i_291 = 0.0
	while true:
		if not J.cmp(v_i_291, v_n_290, "<"): break
		var _t94 = env["rnd"]
		v_an_292 = J.mul(J.cl(_t94, null, [J.add(v_seed_289, v_i_291)]), 6.28)
		var _t96 = J.mul(v_r_286, J.add(0.3, v_k_287))
		var _t95 = env["rnd"]
		v_d_293 = J.mul(_t96, J.cl(_t95, null, [J.add(J.add(v_seed_289, v_i_291), 3.0)]))
		var _t97 = env["rnd"]
		v_rr_294 = J.mul(J.mul(v_r_286, (0.35 + J.mul(0.4, J.cl(_t97, null, [J.add(J.add(v_seed_289, v_i_291), 7.0)])))), J.add(0.6, v_k_287))
		J.sp(v_ctx_283, "fillStyle", v_col_288)
		J.mc(v_ctx_283, "beginPath", [])
		J.mc(v_ctx_283, "arc", [J.add(v_x_284, J.mul(cos(J.num(v_an_292)), v_d_293)), J.sub(J.add(v_y_285, (J.mul(sin(J.num(v_an_292)), v_d_293) * 0.6)), (J.mul(v_k_287, v_r_286) * 0.5)), v_rr_294, 0.0, 7.0])
		J.mc(v_ctx_283, "fill", [])
		J.sp(v_ctx_283, "strokeStyle", "rgba(60,50,70,.35)")
		var _t98 = J.max_([0.6, J.mul(v_r_286, 0.05)])
		J.sp(v_ctx_283, "lineWidth", _t98)
		J.mc(v_ctx_283, "stroke", [])
		v_i_291 = J.num(v_i_291) + 1.0
	J.mc(v_ctx_283, "restore", [])

func _f29(this_, a: Array, env):
	var v_ctx_297 = null; var v_x_298 = null; var v_y_299 = null; var v_r_300 = null; var v_k_301 = null; var v_col_302 = null; var v_seed_303 = null; var v_n_304 = null; var v_up_305 = null; var v_i_306 = null; var v_an_307 = null; var v_sp_308 = null; var v_px_309 = null; var v_py_310 = null
	v_ctx_297 = J.arg(a, 0)
	v_x_298 = J.arg(a, 1)
	v_y_299 = J.arg(a, 2)
	v_r_300 = J.arg(a, 3)
	v_k_301 = J.arg(a, 4)
	v_col_302 = J.arg(a, 5)
	v_seed_303 = J.arg(a, 6)
	v_n_304 = J.arg(a, 7)
	v_up_305 = J.arg(a, 8)
	var _t99 = J.cmp(v_k_301, 0.0, "<=")
	if (_t99 if _t99 else J.cmp(v_k_301, 1.0, ">=")):
		return null
	var _t100 = (v_n_304 if J.t(v_n_304) else 7.0)
	v_n_304 = _t100
	J.mc(v_ctx_297, "save", [])
	var _t101 = J.mul(J.gp(v_ctx_297, "globalAlpha"), (1.0 - J.mul(v_k_301, 0.7)))
	J.sp(v_ctx_297, "globalAlpha", _t101)
	v_i_306 = 0.0
	while true:
		if not J.cmp(v_i_306, v_n_304, "<"): break
		var _t103 = J.div((-PI), 2.0)
		var _t102 = env["rnd"]
		v_an_307 = (_t103 + J.mul(J.sub(J.cl(_t102, null, [J.add(v_seed_303, v_i_306)]), 0.5), (v_up_305 if J.t(v_up_305) else 2.6)))
		var _t104 = env["rnd"]
		v_sp_308 = J.mul(v_r_300, J.add(0.6, J.cl(_t104, null, [J.add(J.add(v_seed_303, v_i_306), 5.0)])))
		v_px_309 = J.add(v_x_298, J.mul(J.mul(cos(J.num(v_an_307)), v_sp_308), v_k_301))
		v_py_310 = J.add(J.add(v_y_299, J.mul(J.mul(sin(J.num(v_an_307)), v_sp_308), v_k_301)), J.mul(J.mul(J.mul(v_r_300, 2.2), v_k_301), v_k_301))
		J.sp(v_ctx_297, "fillStyle", v_col_302)
		J.mc(v_ctx_297, "beginPath", [])
		J.mc(v_ctx_297, "ellipse", [v_px_309, v_py_310, J.mul(v_r_300, 0.09), J.mul(v_r_300, 0.13), J.add(v_an_307, J.div(PI, 2.0)), 0.0, 7.0])
		J.mc(v_ctx_297, "fill", [])
		J.sp(v_ctx_297, "strokeStyle", "rgba(30,30,50,.5)")
		var _t105 = J.max_([0.5, J.mul(v_r_300, 0.025)])
		J.sp(v_ctx_297, "lineWidth", _t105)
		J.mc(v_ctx_297, "stroke", [])
		v_i_306 = J.num(v_i_306) + 1.0
	J.mc(v_ctx_297, "restore", [])

func _f30(this_, a: Array, env):
	var v_ctx_313 = null; var v_x_314 = null; var v_y_315 = null; var v_r_316 = null; var v_t_317 = null; var v_k_318 = null; var v_i_319 = null; var v_an_320 = null; var v_px_321 = null; var v_py_322 = null; var v_j_323 = null; var v_a2_324 = null; var v_rr_325 = null
	v_ctx_313 = J.arg(a, 0)
	v_x_314 = J.arg(a, 1)
	v_y_315 = J.arg(a, 2)
	v_r_316 = J.arg(a, 3)
	v_t_317 = J.arg(a, 4)
	v_k_318 = J.arg(a, 5)
	if J.cmp(v_k_318, 0.0, "<="):
		return null
	J.mc(v_ctx_313, "save", [])
	var _t106 = env["cl"]
	var _t107 = J.mul(J.gp(v_ctx_313, "globalAlpha"), J.cl(_t106, null, [v_k_318]))
	J.sp(v_ctx_313, "globalAlpha", _t107)
	v_i_319 = 0.0
	while true:
		if not J.cmp(v_i_319, 3.0, "<"): break
		v_an_320 = (J.mul(v_t_317, 7.0) + J.mul(v_i_319, 2.09))
		v_px_321 = J.add(v_x_314, J.mul(cos(J.num(v_an_320)), v_r_316))
		v_py_322 = J.add(v_y_315, (J.mul(sin(J.num(v_an_320)), v_r_316) * 0.35))
		J.sp(v_ctx_313, "fillStyle", "#ffd84a")
		J.sp(v_ctx_313, "strokeStyle", "#5a3a10")
		var _t108 = J.max_([0.6, J.mul(v_r_316, 0.06)])
		J.sp(v_ctx_313, "lineWidth", _t108)
		J.mc(v_ctx_313, "beginPath", [])
		v_j_323 = 0.0
		while true:
			if not J.cmp(v_j_323, 10.0, "<"): break
			v_a2_324 = (J.div(J.mul(v_j_323, PI), 5.0) - J.div(PI, 2.0))
			v_rr_325 = (J.mul(v_r_316, 0.12) if J.t(J.mod(v_j_323, 2.0)) else J.mul(v_r_316, 0.28))
			J.mc(v_ctx_313, "lineTo", [J.add(v_px_321, J.mul(cos(J.num(v_a2_324)), v_rr_325)), J.add(v_py_322, J.mul(sin(J.num(v_a2_324)), v_rr_325))])
			v_j_323 = J.num(v_j_323) + 1.0
		J.mc(v_ctx_313, "closePath", [])
		J.mc(v_ctx_313, "fill", [])
		J.mc(v_ctx_313, "stroke", [])
		v_i_319 = J.num(v_i_319) + 1.0
	J.mc(v_ctx_313, "restore", [])

func _f31(this_, a: Array, env):
	var v_ctx_328 = null; var v_x_329 = null; var v_y_330 = null; var v_r_331 = null; var v_k_332 = null; var v_seed_333 = null; var v_i_334 = null; var v_an_335 = null; var v_pts_336 = null; var v_px_337 = null; var v_py_338 = null; var v_j_339 = null
	v_ctx_328 = J.arg(a, 0)
	v_x_329 = J.arg(a, 1)
	v_y_330 = J.arg(a, 2)
	v_r_331 = J.arg(a, 3)
	v_k_332 = J.arg(a, 4)
	v_seed_333 = J.arg(a, 5)
	if J.cmp(v_k_332, 0.0, "<="):
		return null
	J.mc(v_ctx_328, "save", [])
	var _t109 = env["cl"]
	var _t110 = J.mul(J.gp(v_ctx_328, "globalAlpha"), J.cl(_t109, null, [v_k_332]))
	J.sp(v_ctx_328, "globalAlpha", _t110)
	v_i_334 = 0.0
	while true:
		if not J.cmp(v_i_334, 6.0, "<"): break
		var _t112 = ((J.div(v_i_334, 6.0) * PI) * 2.0)
		var _t111 = env["rnd"]
		v_an_335 = J.add(_t112, J.cl(_t111, null, [J.add(v_seed_333, v_i_334)]))
		v_pts_336 = [[v_x_329, v_y_330]]
		v_px_337 = v_x_329
		v_py_338 = v_y_330
		v_j_339 = 1.0
		while true:
			if not J.cmp(v_j_339, 3.0, "<="): break
			var _t113 = env["rnd"]
			var _t114 = J.add(v_px_337, (J.mul(cos(J.num(J.add(v_an_335, J.sub(J.cl(_t113, null, [J.add(J.add(v_seed_333, J.mul(v_i_334, 3.0)), v_j_339)]), 0.5)))), v_r_331) * 0.33))
			v_px_337 = _t114
			var _t115 = env["rnd"]
			var _t116 = J.add(v_py_338, (J.mul(sin(J.num(J.add(v_an_335, J.sub(J.cl(_t115, null, [J.add(J.add(v_seed_333, J.mul(v_i_334, 3.0)), v_j_339)]), 0.5)))), v_r_331) * 0.12))
			v_py_338 = _t116
			J.mc(v_pts_336, "push", [[v_px_337, v_py_338]])
			v_j_339 = J.num(v_j_339) + 1.0
		var _t117 = env["crayon"]
		J.cl(_t117, null, [v_ctx_328, v_pts_336, "rgba(40,28,22,.85)", J.max_([1.0, J.mul(v_r_331, 0.05)]), J.add(v_seed_333, v_i_334)])
		v_i_334 = J.num(v_i_334) + 1.0
	J.mc(v_ctx_328, "restore", [])

func _f32(this_, a: Array, env):
	var v_ctx_342 = null; var v_x_343 = null; var v_y_344 = null; var v_rx_345 = null; var v_ry_346 = null; var v_col_347 = null; var v_w_348 = null; var v_al_349 = null
	v_ctx_342 = J.arg(a, 0)
	v_x_343 = J.arg(a, 1)
	v_y_344 = J.arg(a, 2)
	v_rx_345 = J.arg(a, 3)
	v_ry_346 = J.arg(a, 4)
	v_col_347 = J.arg(a, 5)
	v_w_348 = J.arg(a, 6)
	v_al_349 = J.arg(a, 7)
	if J.cmp(v_al_349, 0.0, "<="):
		return null
	J.mc(v_ctx_342, "save", [])
	var _t118 = env["cl"]
	var _t119 = J.mul(J.gp(v_ctx_342, "globalAlpha"), J.cl(_t118, null, [v_al_349]))
	J.sp(v_ctx_342, "globalAlpha", _t119)
	J.sp(v_ctx_342, "strokeStyle", v_col_347)
	J.sp(v_ctx_342, "lineWidth", v_w_348)
	J.mc(v_ctx_342, "beginPath", [])
	J.mc(v_ctx_342, "ellipse", [v_x_343, v_y_344, J.max_([0.1, v_rx_345]), J.max_([0.1, v_ry_346]), 0.0, 0.0, 7.0])
	J.mc(v_ctx_342, "stroke", [])
	J.mc(v_ctx_342, "restore", [])

func _f2(this_, a: Array, env):
	var v_k_48 = null
	v_k_48 = J.arg(a, 0)
	var _t128 = J.seq(J.typeof_(J.G.get("sprOk")), "function")
	if J.t(_t128):
		var _t127 = J.G.get("sprOk")
		_t128 = J.cl(_t127, null, [v_k_48])
	return _t128

func _f9(this_, a: Array, env):
	var v_S_111 = null; var v_u_112 = null; var v_v_113 = null
	v_S_111 = J.arg(a, 0)
	v_u_112 = J.arg(a, 1)
	v_v_113 = J.arg(a, 2)
	return [J.mul(((1.0 if J.t(J.gp(v_S_111, "nr")) else (-1.0)) * J.sub(v_u_112, 0.5)), J.gp(v_S_111, "W")), J.mul(J.sub(v_v_113, 1.0), J.gp(v_S_111, "H"))]

func _f10(this_, a: Array, env):
	var v_S_114 = null; var v_m_115 = null; var v_u_116 = null; var v_v_117 = null; var v_p_118 = null
	v_S_114 = J.arg(a, 0)
	v_m_115 = J.arg(a, 1)
	v_u_116 = J.arg(a, 2)
	v_v_117 = J.arg(a, 3)
	var _t129 = env["ip"]
	v_p_118 = J.cl(_t129, null, [v_S_114, v_u_116, v_v_117])
	return J.mc(v_m_115, "pt", [J.gp(v_p_118, 0.0), J.gp(v_p_118, 1.0)])

func _f17(this_, a: Array, env):
	var v_p_195 = null; var v_i_196 = null; var v_a_197 = null; var v_b_198 = null; var v_dx_199 = null; var v_dy_200 = null; var v_l_201 = null
	v_p_195 = J.arg(a, 0)
	v_i_196 = J.arg(a, 1)
	v_a_197 = J.gp(env["P"], J.max_([0.0, J.sub(v_i_196, 1.0)]))
	v_b_198 = J.gp(env["P"], J.min_([(J.len(env["P"]) - 1.0), J.add(v_i_196, 1.0)]))
	v_dx_199 = J.sub(J.gp(v_b_198, 0.0), J.gp(v_a_197, 0.0))
	v_dy_200 = J.sub(J.gp(v_b_198, 1.0), J.gp(v_a_197, 1.0))
	var _t130 = J.hypot_([v_dx_199, v_dy_200])
	v_l_201 = (_t130 if J.t(_t130) else 1.0)
	return [J.div((-J.num(v_dy_200)), v_l_201), J.div(v_dx_199, v_l_201)]

func _f16(this_, a: Array, env):
	var _s27 = {"__p": env, "P": null}
	_s27["P"] = J.arg(a, 0)
	return J.mc(_s27["P"], "map", [Callable(self, "_f17").bind(_s27)])

func _f21(this_, a: Array, env):
	var v_p_240 = null
	v_p_240 = J.arg(a, 0)
	var _t131 = env["__p"]["at"]
	return J.cl(_t131, null, [env["S"], env["m"], J.gp(v_p_240, 0.0), J.gp(v_p_240, 1.0)])

func _f20(this_, a: Array, env):
	var v_uv_239 = null
	var _s33 = {"__p": env, "S": null, "m": null}
	_s33["S"] = J.arg(a, 0)
	_s33["m"] = J.arg(a, 1)
	v_uv_239 = J.arg(a, 2)
	return J.mc(v_uv_239, "map", [Callable(self, "_f21").bind(_s33)])

func _f23(this_, a: Array, env):
	var v_p_244 = null; var v_i_245 = null
	v_p_244 = J.arg(a, 0)
	v_i_245 = J.arg(a, 1)
	var _t132 = env["__p"]["lerp"]
	var _t134 = J.cl(_t132, null, [J.gp(v_p_244, 0.0), J.gp(J.gp(env["B"], v_i_245), 0.0), env["k"]])
	var _t133 = env["__p"]["lerp"]
	return [_t134, J.cl(_t133, null, [J.gp(v_p_244, 1.0), J.gp(J.gp(env["B"], v_i_245), 1.0), env["k"]])]

func _f22(this_, a: Array, env):
	var v_A_241 = null
	var _s35 = {"__p": env, "B": null, "k": null}
	v_A_241 = J.arg(a, 0)
	_s35["B"] = J.arg(a, 1)
	_s35["k"] = J.arg(a, 2)
	return J.mc(v_A_241, "map", [Callable(self, "_f23").bind(_s35)])

func _f24(this_, a: Array, env):
	var v_a_246 = null; var v_c_247 = null; var v_b_248 = null; var v_n_249 = null; var v_o_250 = null; var v_i_251 = null; var v_t_252 = null; var v_u_253 = null
	v_a_246 = J.arg(a, 0)
	v_c_247 = J.arg(a, 1)
	v_b_248 = J.arg(a, 2)
	v_n_249 = J.arg(a, 3)
	v_o_250 = []
	v_i_251 = 0.0
	while true:
		if not J.cmp(v_i_251, v_n_249, "<"): break
		v_t_252 = J.div(v_i_251, J.sub(v_n_249, 1.0))
		v_u_253 = J.sub(1.0, v_t_252)
		J.mc(v_o_250, "push", [[((J.mul(J.mul(v_u_253, v_u_253), J.gp(v_a_246, 0.0)) + J.mul(J.mul(J.mul(2.0, v_u_253), v_t_252), J.gp(v_c_247, 0.0))) + J.mul(J.mul(v_t_252, v_t_252), J.gp(v_b_248, 0.0))), ((J.mul(J.mul(v_u_253, v_u_253), J.gp(v_a_246, 1.0)) + J.mul(J.mul(J.mul(2.0, v_u_253), v_t_252), J.gp(v_c_247, 1.0))) + J.mul(J.mul(v_t_252, v_t_252), J.gp(v_b_248, 1.0)))]])
		v_i_251 = J.num(v_i_251) + 1.0
	return v_o_250

func _f25(this_, a: Array, env):
	var v_pts_254 = null; var v_n_255 = null
	v_pts_254 = J.arg(a, 0)
	v_n_255 = J.arg(a, 1)
	var _t135 = env["resample"]
	return J.gp(J.cl(_t135, null, [v_pts_254, v_n_255]), "pts")

func _f33(this_, a: Array, env):
	var v_S_350 = null; var v_x_351 = null; var v_y_352 = null
	v_S_350 = J.arg(a, 0)
	v_x_351 = J.arg(a, 1)
	v_y_352 = J.arg(a, 2)
	if J.t(J.gp(J.gp(v_S_350, "o"), "hitOut")):
		var _t136 = J.gp(J.gp(v_S_350, "o"), "hitOut")
		var _t137 = {"x": J.add(J.gp(J.gp(v_S_350, "a"), "x"), J.mul(J.gp(v_S_350, "fw"), v_x_351)), "y": J.add(J.gp(J.gp(v_S_350, "a"), "y"), v_y_352)}
		J.sp(_t136, "p", _t137)

func _f34(this_, a: Array, env):
	var v_S_353 = null; var v_f_354 = null
	v_S_353 = J.arg(a, 0)
	v_f_354 = J.arg(a, 1)
	return [J.add(J.gp(v_S_353, "tx"), J.gp(v_S_353, "back")), J.sub(J.gp(v_S_353, "ty"), J.mul(v_f_354, J.gp(v_S_353, "th")))]

func _f1(this_, a: Array, env):
	var v_seg_5 = null; var v_TW_10 = null; var v_TC_11 = null; var v_TS_12 = null; var v_TE_13 = null; var v_setup_16 = null; var v_kf_18 = null; var v_whole_23 = null; var v_pieceAt_27 = null; var v_ribbon_31 = null; var v_restLine_32 = null; var v_lerpLine_33 = null; var v_quad_34 = null; var v_same_35 = null; var v_burst_37 = null; var v_speed_38 = null; var v_pop_40 = null; var v_puff_41 = null; var v_drops_42 = null; var v_stars_43 = null; var v_cracks_44 = null; var v_ring_45 = null; var v_hit_46 = null; var v_tgt_47 = null
	var _s2 = {"__p": env, "K": null, "E": null, "lerp": null, "cl": null, "rnd": null, "M": null, "D": null, "ok": null, "ONE": null, "TF": null, "bm": null, "pose": null, "body": null, "ip": null, "at": null, "piece": null, "tri": null, "resample": null, "normals": null, "crayon": null, "txt": null}
	v_setup_16 = Callable(self, "_f3").bind(_s2)
	v_kf_18 = Callable(self, "_f4").bind(_s2)
	_s2["bm"] = Callable(self, "_f5").bind(_s2)
	_s2["pose"] = Callable(self, "_f6").bind(_s2)
	_s2["body"] = Callable(self, "_f7").bind(_s2)
	v_whole_23 = Callable(self, "_f8").bind(_s2)
	_s2["piece"] = Callable(self, "_f11").bind(_s2)
	v_pieceAt_27 = Callable(self, "_f12").bind(_s2)
	_s2["tri"] = Callable(self, "_f13").bind(_s2)
	_s2["resample"] = Callable(self, "_f15").bind(_s2)
	v_ribbon_31 = Callable(self, "_f18").bind(_s2)
	_s2["txt"] = Callable(self, "_f26").bind(_s2)
	v_pop_40 = Callable(self, "_f27").bind(_s2)
	v_puff_41 = Callable(self, "_f28").bind(_s2)
	v_drops_42 = Callable(self, "_f29").bind(_s2)
	v_stars_43 = Callable(self, "_f30").bind(_s2)
	v_cracks_44 = Callable(self, "_f31").bind(_s2)
	v_ring_45 = Callable(self, "_f32").bind(_s2)
	_s2["K"] = J.G.get("MoveKit")
	var _t120 = _s2["K"]
	var _t121 = J.gp(_t120, "E")
	_s2["E"] = _t121
	var _t122 = J.gp(_t120, "seg")
	v_seg_5 = _t122
	var _t123 = J.gp(_t120, "lerp")
	_s2["lerp"] = _t123
	var _t124 = J.gp(_t120, "cl")
	_s2["cl"] = _t124
	var _t125 = J.gp(_t120, "rnd")
	_s2["rnd"] = _t125
	var _t126 = J.gp(_t120, "M")
	_s2["M"] = _t126
	v_TW_10 = J.gp(_s2["K"], "TW")
	v_TC_11 = J.gp(_s2["K"], "TC")
	v_TS_12 = J.add(J.gp(_s2["K"], "TW"), J.gp(_s2["K"], "TS"))
	v_TE_13 = J.gp(_s2["K"], "TE")
	_s2["D"] = J.div(PI, 180.0)
	_s2["ok"] = Callable(self, "_f2").bind(_s2)
	_s2["ONE"] = {"sx": 1.0, "sy": 1.0, "a": 1.0}
	_s2["TF"] = {"x": 1.0, "y": 1.0, "r": 1.0, "px": 1.0, "py": 1.0, "sx": 1.0, "sy": 1.0, "a": 1.0}
	_s2["ip"] = Callable(self, "_f9").bind(_s2)
	_s2["at"] = Callable(self, "_f10").bind(_s2)
	_s2["normals"] = Callable(self, "_f16").bind(_s2)
	v_restLine_32 = Callable(self, "_f20").bind(_s2)
	v_lerpLine_33 = Callable(self, "_f22").bind(_s2)
	v_quad_34 = Callable(self, "_f24").bind(_s2)
	v_same_35 = Callable(self, "_f25").bind(_s2)
	_s2["crayon"] = J.gp(_s2["K"], "crayon")
	v_burst_37 = J.gp(_s2["K"], "burst")
	v_speed_38 = J.gp(_s2["K"], "speed")
	v_hit_46 = Callable(self, "_f33").bind(_s2)
	v_tgt_47 = Callable(self, "_f34").bind(_s2)
	return {"K": _s2["K"], "E": _s2["E"], "seg": v_seg_5, "lerp": _s2["lerp"], "cl": _s2["cl"], "rnd": _s2["rnd"], "M": _s2["M"], "D": _s2["D"], "TW": v_TW_10, "TC": v_TC_11, "TS": v_TS_12, "TE": v_TE_13, "setup": v_setup_16, "kf": v_kf_18, "bm": _s2["bm"], "pose": _s2["pose"], "body": _s2["body"], "whole": v_whole_23, "ip": _s2["ip"], "at": _s2["at"], "piece": _s2["piece"], "pieceAt": v_pieceAt_27, "ribbon": v_ribbon_31, "restLine": v_restLine_32, "lerpLine": v_lerpLine_33, "quad": v_quad_34, "same": v_same_35, "resample": _s2["resample"], "crayon": _s2["crayon"], "burst": v_burst_37, "speed": v_speed_38, "txt": _s2["txt"], "pop": v_pop_40, "puff": v_puff_41, "drops": v_drops_42, "stars": v_stars_43, "cracks": v_cracks_44, "ring": v_ring_45, "hit": v_hit_46, "tgt": v_tgt_47, "shadow": J.gp(_s2["K"], "shadow"), "ok": _s2["ok"]}

func _f35(this_, a: Array, env):
	var v_ctx_357 = null; var v_S_358 = null; var v_sx_359 = null; var v_sk_360 = null
	v_ctx_357 = J.arg(a, 0)
	v_S_358 = J.arg(a, 1)
	v_sx_359 = J.arg(a, 2)
	v_sk_360 = J.arg(a, 3)
	J.mc(v_ctx_357, "save", [])
	var _t138 = J.gp(J.G.get("N30K"), "K")
	J.mc(_t138, "enter", [v_ctx_357, v_S_358])
	J.mc(J.G.get("N30K"), "shadow", [v_ctx_357, v_S_358, (v_sx_359 if J.t(v_sx_359) else 0.0), 0.0, v_sk_360])

func _f36(this_, a: Array, env):
	var v_ctx_363 = null
	v_ctx_363 = J.arg(a, 0)
	J.mc(v_ctx_363, "restore", [])

func _f37(this_, a: Array, env):
	var v_S_366 = null; var v_m_367 = null; var v_src_368 = null; var v_root_369 = null; var v_ctrl_370 = null; var v_tip_371 = null; var v_b_372 = null; var v_N_373 = null; var v_rest_374 = null; var v_cur_375 = null
	v_S_366 = J.arg(a, 0)
	v_m_367 = J.arg(a, 1)
	v_src_368 = J.arg(a, 2)
	v_root_369 = J.arg(a, 3)
	v_ctrl_370 = J.arg(a, 4)
	v_tip_371 = J.arg(a, 5)
	v_b_372 = J.arg(a, 6)
	v_N_373 = J.G.get("N30K")
	v_rest_374 = J.mc(v_N_373, "same", [J.mc(v_N_373, "restLine", [v_S_366, v_m_367, v_src_368]), 14.0])
	v_cur_375 = J.mc(v_N_373, "quad", [(v_root_369 if J.t(v_root_369) else J.gp(v_rest_374, 0.0)), v_ctrl_370, v_tip_371, 14.0])
	return J.mc(v_N_373, "lerpLine", [v_rest_374, v_cur_375, J.mc(v_N_373, "cl", [v_b_372])])

func _f39(this_, a: Array, env):
	var v_i_402 = null; var v_n_403 = null
	v_i_402 = J.arg(a, 0)
	v_n_403 = J.arg(a, 1)
	return (1.0 - J.div(J.mul(J.mul(0.18, env["b"]), v_i_402), v_n_403))

func _f38(this_, a: Array, env):
	var v_ctx_378 = null; var v_a_379 = null; var v_N_380 = null; var v_S_381 = null; var v_key_382 = null; var v_t_383 = null; var v_H_384 = null; var v_th_385 = null; var v_E_386 = null; var v_seg_387 = null; var v_f_388 = null; var v_m_389 = null; var v_SRC_390 = null; var v_root_391 = null; var v_hd_392 = null; var v_T_393 = null; var v_bend_395 = null; var v_tip_396 = null; var v_mid_397 = null; var v_L_398 = null; var v_wob_399 = null; var v_ctrl_400 = null; var v_p_401 = null
	var _s66 = {"__p": env, "b": null}
	v_ctx_378 = J.arg(a, 0)
	v_a_379 = J.arg(a, 1)
	v_N_380 = J.G.get("N30K")
	v_S_381 = J.mc(v_N_380, "setup", [v_a_379])
	if (not J.t(v_S_381)):
		return false
	v_key_382 = J.mc(J.G.get("N30"), "body", [J.gp(v_S_381, "id")])
	if (not J.t(v_key_382)):
		return false
	v_t_383 = J.gp(v_S_381, "tt")
	v_H_384 = J.gp(v_S_381, "H")
	v_th_385 = J.gp(v_S_381, "th")
	var _t140 = J.gp(v_N_380, "E")
	v_E_386 = _t140
	var _t141 = J.gp(v_N_380, "seg")
	v_seg_387 = _t141
	v_f_388 = J.mc(v_N_380, "kf", [v_t_383, [[0.0, {}], [0.16, {"r": (-9.0), "head": (-0.22), "body": (-0.08), "armF": 0.35, "armB": (-0.35), "rope": 0.35, "hairL": 0.2, "hairR": 0.2}], [0.25, {"r": 9.0, "head": 0.18, "body": 0.1, "x": J.mul(0.05, v_H_384), "rope": (-0.45), "hairL": (-0.25), "hairR": (-0.25)}, "o"], [0.36, {"r": 6.0, "head": 0.12, "body": 0.08, "x": J.mul(0.05, v_H_384), "rope": (-0.2)}], [0.59, {}]]])
	v_m_389 = J.mc(v_N_380, "bm", [v_S_381, v_f_388])
	J.mc(J.G.get("N30M"), "begin", [v_ctx_378, v_S_381, J.gp(v_f_388, "x")])
	J.mc(v_N_380, "body", [v_ctx_378, v_S_381, v_m_389, J.mc(v_N_380, "pose", [v_S_381, v_f_388, 0.3]), v_key_382])
	v_SRC_390 = [[0.415, 0.36], [0.418, 0.45], [0.415, 0.52], [0.42, 0.59]]
	v_root_391 = J.mc(v_N_380, "at", [v_S_381, v_m_389, 0.415, 0.36])
	v_hd_392 = J.mc(v_N_380, "tgt", [v_S_381, 0.78])
	v_T_393 = J.mc(v_N_380, "kf", [v_t_383, [[0.0, {"x": J.gp(J.mc(v_N_380, "at", [v_S_381, v_m_389, 0.42, 0.59]), 0.0), "y": J.gp(J.mc(v_N_380, "at", [v_S_381, v_m_389, 0.42, 0.59]), 1.0)}], [0.17, {"x": J.sub(J.gp(v_root_391, 0.0), J.mul(0.3, v_H_384)), "y": J.sub(J.gp(v_root_391, 1.0), J.mul(0.42, v_H_384))}], [J.gp(v_N_380, "TC"), {"x": J.gp(v_hd_392, 0.0), "y": J.gp(v_hd_392, 1.0)}, "i"], [0.3, {"x": J.sub(J.gp(v_hd_392, 0.0), J.mul(0.04, v_H_384)), "y": J.add(J.gp(v_hd_392, 1.0), J.mul(0.06, v_H_384))}], [0.36, {"x": J.add(J.gp(v_hd_392, 0.0), J.mul(0.02, v_H_384)), "y": J.add(J.gp(v_hd_392, 1.0), J.mul(0.02, v_H_384))}], [0.52, {"x": J.add(J.gp(v_root_391, 0.0), J.mul(0.12, v_H_384)), "y": J.add(J.gp(v_root_391, 1.0), J.mul(0.25, v_H_384))}], [0.59, {"x": J.gp(J.mc(v_N_380, "at", [v_S_381, v_m_389, 0.42, 0.59]), 0.0), "y": J.gp(J.mc(v_N_380, "at", [v_S_381, v_m_389, 0.42, 0.59]), 1.0)}]]])
	_s66["b"] = J.gp(J.mc(v_N_380, "kf", [v_t_383, [[0.0, {"v": 0.0}], [0.06, {"v": 1.0}], [0.53, {"v": 1.0}], [0.59, {"v": 0.0}]]]), "v")
	v_bend_395 = J.gp(J.mc(v_N_380, "kf", [v_t_383, [[0.0, {"v": 0.0}], [0.17, {"v": (-0.55)}], [J.gp(v_N_380, "TC"), {"v": (-0.25)}], [0.36, {"v": 0.1}], [0.59, {"v": 0.0}]]]), "v")
	v_tip_396 = [J.gp(v_T_393, "x"), J.gp(v_T_393, "y")]
	v_mid_397 = [J.div(J.add(J.gp(v_root_391, 0.0), J.gp(v_tip_396, 0.0)), 2.0), J.div(J.add(J.gp(v_root_391, 1.0), J.gp(v_tip_396, 1.0)), 2.0)]
	v_L_398 = J.hypot_([J.sub(J.gp(v_tip_396, 0.0), J.gp(v_root_391, 0.0)), J.sub(J.gp(v_tip_396, 1.0), J.gp(v_root_391, 1.0))])
	var _t142 = J.cmp(v_t_383, J.gp(v_N_380, "TC"), ">")
	v_wob_399 = (J.mul((sin(J.num(J.mul(v_t_383, 90.0))) * 0.06), v_H_384) if (J.cmp(v_t_383, 0.36, "<") if _t142 else _t142) else 0.0)
	v_ctrl_400 = [J.add(J.gp(v_mid_397, 0.0), (J.mul(v_bend_395, v_L_398) * 0.2)), J.add(J.add(J.gp(v_mid_397, 1.0), (J.mul(v_bend_395, v_L_398) * 0.9)), v_wob_399)]
	var _t143 = J.cmp(v_t_383, 0.12, ">")
	if (J.cmp(v_t_383, J.gp(v_N_380, "TC"), "<") if _t143 else _t143):
		J.mc(v_N_380, "speed", [v_ctx_378, J.gp(v_tip_396, 0.0), J.gp(v_tip_396, 1.0), J.sub(J.gp(v_tip_396, 0.0), J.gp(v_root_391, 0.0)), (J.sub(J.gp(v_tip_396, 1.0), J.gp(v_root_391, 1.0)) + J.mul(0.3, v_H_384)), J.mul(0.18, v_H_384), J.mul(0.1, v_H_384), J.cl(v_seg_387, null, [v_t_383, 0.12, 0.2]), "rgba(255,220,220,.7)", 3.0, 3.0])
	J.mc(v_N_380, "ribbon", [v_ctx_378, v_S_381, "tongue", v_SRC_390, 0.05, J.mc(J.G.get("N30M"), "line", [v_S_381, v_m_389, v_SRC_390, v_root_391, v_ctrl_400, v_tip_396, _s66["b"]]), Callable(self, "_f39").bind(_s66)])
	v_p_401 = J.sub(v_t_383, J.gp(v_N_380, "TC"))
	var _t144 = J.cmp(v_p_401, 0.0, ">=")
	if (J.cmp(v_p_401, 0.14, "<") if _t144 else _t144):
		J.mc(v_N_380, "burst", [v_ctx_378, J.gp(v_hd_392, 0.0), J.gp(v_hd_392, 1.0), J.mul(0.35, v_th_385), (1.0 - J.div(v_p_401, 0.14)), "#ffe4e4", 11.0, 10.0])
	J.mc(v_N_380, "drops", [v_ctx_378, J.gp(v_hd_392, 0.0), J.gp(v_hd_392, 1.0), J.mul(0.5, v_th_385), J.mc(v_N_380, "seg", [v_t_383, J.gp(v_N_380, "TC"), 0.5]), "rgba(200,235,255,.9)", 3.0, 8.0])
	J.mc(v_N_380, "pop", [v_ctx_378, v_S_381, J.gp(v_hd_392, 0.0), J.sub(J.gp(v_hd_392, 1.0), J.mul(0.32, v_th_385)), "啪！", J.mul(0.26, v_th_385), "#ffd0d0", J.gp(v_N_380, "TC"), 0.3])
	J.mc(v_N_380, "hit", [v_S_381, J.gp(v_hd_392, 0.0), J.gp(v_hd_392, 1.0)])
	J.mc(J.G.get("N30M"), "end", [v_ctx_378])

func _f40(this_, a: Array, env):
	var v_ctx_406 = null; var v_a_407 = null; var v_N_408 = null; var v_S_409 = null; var v_key_410 = null; var v_t_411 = null; var v_H_412 = null; var v_th_413 = null; var v_f_414 = null; var v_m_415 = null; var v_HC_416 = null; var v_R_417 = null; var v_rest_418 = null; var v_gy_419 = null; var v_hitX_420 = null; var v_P_421 = null; var v_inHand_422 = null; var v_p_423 = null; var v_i_424 = null
	v_ctx_406 = J.arg(a, 0)
	v_a_407 = J.arg(a, 1)
	v_N_408 = J.G.get("N30K")
	v_S_409 = J.mc(v_N_408, "setup", [v_a_407])
	if (not J.t(v_S_409)):
		return false
	v_key_410 = J.mc(J.G.get("N30"), "body", [J.gp(v_S_409, "id")])
	if (not J.t(v_key_410)):
		return false
	v_t_411 = J.gp(v_S_409, "tt")
	v_H_412 = J.gp(v_S_409, "H")
	v_th_413 = J.gp(v_S_409, "th")
	v_f_414 = J.mc(v_N_408, "kf", [v_t_411, [[0.0, {}], [0.15, {"r": (-6.0), "body": (-0.12), "armB": 0.55, "armF": (-0.25), "x": J.mul((-0.03), v_H_412)}], [0.21, {"r": 12.0, "body": 0.18, "armB": (-0.65), "armF": 0.2, "x": J.mul(0.05, v_H_412), "sy": 0.97}, "o"], [0.34, {"r": 10.0, "body": 0.15, "armB": (-0.6), "x": J.mul(0.05, v_H_412)}], [0.5, {"r": 2.0, "body": 0.03, "armB": (-0.2)}], [0.59, {}]]])
	v_m_415 = J.mc(v_N_408, "bm", [v_S_409, v_f_414])
	J.mc(J.G.get("N30M"), "begin", [v_ctx_406, v_S_409, J.gp(v_f_414, "x")])
	v_HC_416 = [0.775, 0.5]
	v_R_417 = J.mul(0.165, v_H_412)
	v_rest_418 = J.mc(v_N_408, "at", [v_S_409, v_m_415, J.gp(v_HC_416, 0.0), J.gp(v_HC_416, 1.0)])
	v_gy_419 = J.add((-J.num(v_R_417)), J.gp(v_S_409, "fl"))
	v_hitX_420 = J.add(J.sub(J.gp(v_S_409, "tx"), J.mul(0.12, v_th_413)), J.gp(v_S_409, "back"))
	v_P_421 = J.mc(v_N_408, "kf", [v_t_411, [[0.0, {"x": J.gp(v_rest_418, 0.0), "y": J.gp(v_rest_418, 1.0), "r": 0.0}], [0.15, {"x": J.sub(J.gp(v_rest_418, 0.0), J.mul(0.12, v_H_412)), "y": J.add(J.gp(v_rest_418, 1.0), J.mul(0.1, v_H_412)), "r": (-35.0)}], [0.2, {"x": J.add(J.gp(v_rest_418, 0.0), J.mul(0.12, v_H_412)), "y": v_gy_419, "r": 30.0}, "i"], [J.gp(v_N_408, "TC"), {"x": v_hitX_420, "y": v_gy_419, "r": (30.0 + J.div(J.div(J.sub(v_hitX_420, J.gp(v_rest_418, 0.0)), v_R_417), J.gp(v_N_408, "D")))}, "lin"], [0.33, {"x": J.sub(v_hitX_420, J.mul(0.14, v_H_412)), "y": J.sub(v_gy_419, J.mul(0.12, v_H_412)), "r": (-60.0)}, "o"], [0.36, {"x": J.sub(v_hitX_420, J.mul(0.2, v_H_412)), "y": v_gy_419, "r": (-90.0)}], [0.5, {"x": J.mul(0.12, v_H_412), "y": v_gy_419, "r": ((-90.0) - J.div(J.div(J.sub(v_hitX_420, J.mul(0.32, v_H_412)), v_R_417), J.gp(v_N_408, "D")))}, "lin"], [0.59, {"x": J.gp(v_rest_418, 0.0), "y": J.gp(v_rest_418, 1.0), "r": 0.0}, "back"]]])
	var _t147 = J.cmp(v_t_411, 0.15, "<")
	v_inHand_422 = (_t147 if _t147 else J.cmp(v_t_411, 0.585, ">"))
	J.mc(v_N_408, "body", [v_ctx_406, v_S_409, v_m_415, J.mc(v_N_408, "pose", [v_S_409, v_f_414, 0.3]), v_key_410])
	var _t148 = J.cmp(v_t_411, 0.19, ">")
	if (J.cmp(v_t_411, J.add(J.gp(v_N_408, "TC"), 0.02), "<") if _t148 else _t148):
		v_i_424 = 0.0
		while true:
			if not J.cmp(v_i_424, 4.0, "<"): break
			J.mc(v_N_408, "puff", [v_ctx_406, J.sub(J.gp(v_P_421, "x"), J.mul(J.mul(J.add(v_i_424, 1.0), 0.09), v_H_412)), J.mul((-0.02), v_H_412), J.mul(0.06, v_H_412), J.mc(v_N_408, "cl", [((J.sub(v_t_411, 0.19) * 6.0) - J.mul(v_i_424, 0.12))]), "rgba(200,190,170,.5)", J.mul(v_i_424, 7.0), 3.0])
			v_i_424 = J.num(v_i_424) + 1.0
		J.mc(v_N_408, "speed", [v_ctx_406, J.sub(J.gp(v_P_421, "x"), v_R_417), J.gp(v_P_421, "y"), 1.0, 0.0, J.mul(0.25, v_H_412), J.mul(0.18, v_H_412), 1.0, "rgba(240,240,255,.7)", 5.0, 3.0])
	J.mc(v_N_408, "pieceAt", [v_ctx_406, v_S_409, "head", J.gp(v_P_421, "x"), J.gp(v_P_421, "y"), (0.0 if J.t(v_inHand_422) else J.gp(v_P_421, "r")), J.gp(v_HC_416, 0.0), J.gp(v_HC_416, 1.0)])
	v_p_423 = J.sub(v_t_411, J.gp(v_N_408, "TC"))
	var _t149 = J.cmp(v_p_423, 0.0, ">=")
	if (J.cmp(v_p_423, 0.15, "<") if _t149 else _t149):
		J.mc(v_N_408, "burst", [v_ctx_406, J.add(v_hitX_420, J.mul(0.05, v_th_413)), v_gy_419, J.mul(0.4, v_th_413), (1.0 - J.div(v_p_423, 0.15)), "#fff2c0", 21.0, 11.0])
	J.mc(v_N_408, "pop", [v_ctx_406, v_S_409, v_hitX_420, J.sub(J.gp(v_S_409, "ty"), J.mul(0.95, v_th_413)), "全倒！", J.mul(0.24, v_th_413), "#ffe066", J.gp(v_N_408, "TC"), 0.32])
	var _t150 = J.cmp(v_t_411, J.gp(v_N_408, "TC"), ">")
	if (J.cmp(v_t_411, 0.5, "<") if _t150 else _t150):
		J.mc(v_N_408, "stars", [v_ctx_406, J.gp(v_P_421, "x"), J.sub(J.gp(v_P_421, "y"), J.mul(v_R_417, 1.1)), J.mul(v_R_417, 0.9), v_t_411, J.sub(1.0, J.mc(v_N_408, "seg", [v_t_411, 0.42, 0.5]))])
	J.mc(v_N_408, "hit", [v_S_409, v_hitX_420, J.sub(J.gp(v_S_409, "ty"), J.mul(0.1, v_th_413))])
	J.mc(J.G.get("N30M"), "end", [v_ctx_406])

func _f41(this_, a: Array, env):
	var v_ctx_427 = null; var v_a_428 = null; var v_N_429 = null; var v_S_430 = null; var v_key_431 = null; var v_t_432 = null; var v_H_433 = null; var v_th_434 = null; var v_PV_435 = null; var v_f_436 = null; var v_m_437 = null; var v_w0_438 = null; var v_tip_439 = null; var v_reach_440 = null; var v_W_441 = null; var v_p_442 = null; var v_i_443 = null
	v_ctx_427 = J.arg(a, 0)
	v_a_428 = J.arg(a, 1)
	v_N_429 = J.G.get("N30K")
	v_S_430 = J.mc(v_N_429, "setup", [v_a_428])
	if (not J.t(v_S_430)):
		return false
	v_key_431 = J.mc(J.G.get("N30"), "body", [J.gp(v_S_430, "id")])
	if (not J.t(v_key_431)):
		return false
	v_t_432 = J.gp(v_S_430, "tt")
	v_H_433 = J.gp(v_S_430, "H")
	v_th_434 = J.gp(v_S_430, "th")
	v_PV_435 = [0.31, 0.5]
	v_f_436 = J.mc(v_N_429, "kf", [v_t_432, [[0.0, {}], [0.17, {"r": (-5.0), "x": J.mul((-0.06), v_H_433), "sy": 0.96, "sx": 1.03, "body": (-0.06), "armF": 0.3, "legF": (-0.15), "legB": 0.1, "hairL": 0.15, "hairR": 0.15}], [J.gp(v_N_429, "TC"), {"r": 8.0, "x": J.mul(0.1, v_H_433), "sy": 1.02, "body": 0.12, "armF": (-0.5), "legF": 0.3, "legB": (-0.2), "hairL": (-0.3), "hairR": (-0.35)}, "i"], [0.36, {"r": 7.0, "x": J.mul(0.1, v_H_433), "body": 0.1, "armF": (-0.45), "legF": 0.28, "legB": (-0.18), "hairL": (-0.25), "hairR": (-0.3)}], [0.59, {}]]])
	v_m_437 = J.mc(v_N_429, "bm", [v_S_430, v_f_436])
	v_w0_438 = J.mc(v_N_429, "at", [v_S_430, v_m_437, J.gp(v_PV_435, 0.0), J.gp(v_PV_435, 1.0)])
	v_tip_439 = J.mc(v_N_429, "tgt", [v_S_430, 0.55])
	v_reach_440 = J.mul(0.47, J.gp(v_S_430, "H"))
	v_W_441 = J.mc(v_N_429, "kf", [v_t_432, [[0.0, {"x": J.gp(v_w0_438, 0.0), "y": J.gp(v_w0_438, 1.0), "r": 0.0}], [0.17, {"x": J.sub(J.gp(v_w0_438, 0.0), J.mul(0.14, v_H_433)), "y": J.sub(J.gp(v_w0_438, 1.0), J.mul(0.02, v_H_433)), "r": 84.0}], [J.gp(v_N_429, "TC"), {"x": (J.sub(J.gp(v_tip_439, 0.0), v_reach_440) + J.mul(0.05, v_th_434)), "y": J.gp(v_tip_439, 1.0), "r": 90.0}, "i"], [0.33, {"x": (J.sub(J.gp(v_tip_439, 0.0), v_reach_440) + J.mul(0.05, v_th_434)), "y": J.gp(v_tip_439, 1.0), "r": (90.0 + (sin(J.num(J.mul(v_t_432, 80.0))) * 5.0))}], [0.4, {"x": J.add(J.gp(v_w0_438, 0.0), J.mul(0.02, v_H_433)), "y": J.gp(v_w0_438, 1.0), "r": 70.0}], [0.59, {"x": J.gp(v_w0_438, 0.0), "y": J.gp(v_w0_438, 1.0), "r": 0.0}]]])
	J.mc(J.G.get("N30M"), "begin", [v_ctx_427, v_S_430, J.gp(v_f_436, "x")])
	J.mc(v_N_429, "body", [v_ctx_427, v_S_430, v_m_437, J.mc(v_N_429, "pose", [v_S_430, v_f_436, 0.3]), v_key_431])
	var _t153 = J.cmp(v_t_432, 0.2, ">")
	if (J.cmp(v_t_432, 0.3, "<") if _t153 else _t153):
		J.mc(v_N_429, "speed", [v_ctx_427, J.add(J.gp(v_W_441, "x"), J.mul(v_reach_440, 0.7)), J.gp(v_W_441, "y"), 1.0, 0.0, J.mul(0.5, v_H_433), J.mul(0.12, v_H_433), J.mul(J.mc(v_N_429, "seg", [v_t_432, 0.2, 0.24]), J.sub(1.0, J.mc(v_N_429, "seg", [v_t_432, 0.28, 0.3]))), "rgba(255,240,200,.75)", 9.0, 5.0])
	J.mc(v_N_429, "pieceAt", [v_ctx_427, v_S_430, "trident", J.gp(v_W_441, "x"), J.gp(v_W_441, "y"), J.gp(v_W_441, "r"), J.gp(v_PV_435, 0.0), J.gp(v_PV_435, 1.0)])
	v_p_442 = J.sub(v_t_432, J.gp(v_N_429, "TC"))
	var _t154 = J.cmp(v_p_442, 0.0, ">=")
	if (J.cmp(v_p_442, 0.14, "<") if _t154 else _t154):
		J.mc(v_N_429, "burst", [v_ctx_427, J.gp(v_tip_439, 0.0), J.gp(v_tip_439, 1.0), J.mul(0.36, v_th_434), (1.0 - J.div(v_p_442, 0.14)), "#fff6c8", 31.0, 12.0])
	var _t155 = J.cmp(v_p_442, 0.0, ">")
	if (J.cmp(v_p_442, 0.3, "<") if _t155 else _t155):
		v_i_443 = (-1.0)
		while true:
			if not J.cmp(v_i_443, 1.0, "<="): break
			J.mc(v_N_429, "crayon", [v_ctx_427, [[J.sub(J.gp(v_tip_439, 0.0), J.mul(0.02, v_th_434)), J.add(J.gp(v_tip_439, 1.0), J.mul(J.mul(v_i_443, 0.07), v_th_434))], [J.add(J.gp(v_tip_439, 0.0), J.mul(0.04, v_th_434)), J.add(J.gp(v_tip_439, 1.0), J.mul(J.mul(v_i_443, 0.07), v_th_434))]], "rgba(150,30,30,.8)", J.mul(0.02, v_th_434), J.add(40.0, v_i_443)])
			v_i_443 = J.num(v_i_443) + 1.0
	J.mc(v_N_429, "pop", [v_ctx_427, v_S_430, J.gp(v_tip_439, 0.0), J.sub(J.gp(v_tip_439, 1.0), J.mul(0.5, v_th_434)), "叉！", J.mul(0.24, v_th_434), "#ffd27a", J.gp(v_N_429, "TC"), 0.3])
	J.mc(v_N_429, "hit", [v_S_430, J.gp(v_tip_439, 0.0), J.gp(v_tip_439, 1.0)])
	J.mc(J.G.get("N30M"), "end", [v_ctx_427])

func _f42(this_, a: Array, env):
	var v_ctx_446 = null; var v_a_447 = null; var v_N_448 = null; var v_S_449 = null; var v_t_450 = null; var v_H_451 = null; var v_th_452 = null; var v_f_453 = null; var v_m_454 = null; var v_glow_455 = null; var v_o_456 = null; var v_T_457 = null; var v_p_458 = null; var v_u_459 = null; var v_e_460 = null; var v_g_461 = null; var v_i_462 = null; var v_q_463 = null; var v_x_464 = null; var v_hh_465 = null; var v_pts_466 = null; var v_j_467 = null; var v_v_468 = null; var v_i_469 = null; var v_i_470 = null
	v_ctx_446 = J.arg(a, 0)
	v_a_447 = J.arg(a, 1)
	v_N_448 = J.G.get("N30K")
	v_S_449 = J.mc(v_N_448, "setup", [v_a_447])
	if (not J.t(v_S_449)):
		return false
	v_t_450 = J.gp(v_S_449, "tt")
	v_H_451 = J.gp(v_S_449, "H")
	v_th_452 = J.gp(v_S_449, "th")
	v_f_453 = J.mc(v_N_448, "kf", [v_t_450, [[0.0, {}], [0.18, {"r": (-6.0), "y": J.mul((-0.04), v_H_451), "sy": 1.05, "armF": (-0.9), "armB": 0.9, "head": (-0.18), "hairL": 0.3, "hairR": 0.3}], [0.25, {"r": 7.0, "x": J.mul(0.04, v_H_451), "armF": (-0.7), "armB": (-0.5), "head": 0.12, "hairL": (-0.3), "hairR": (-0.3)}, "o"], [0.4, {"r": 6.0, "x": J.mul(0.04, v_H_451), "armF": (-0.65), "armB": (-0.45), "head": 0.1}], [0.59, {}]]])
	J.mc(J.G.get("N30M"), "begin", [v_ctx_446, v_S_449, J.gp(v_f_453, "x")])
	v_m_454 = J.mc(v_N_448, "bm", [v_S_449, v_f_453])
	J.mc(v_N_448, "whole", [v_ctx_446, v_S_449, v_f_453, null, 0.3])
	v_glow_455 = J.gp(J.mc(v_N_448, "kf", [v_t_450, [[0.0, {"v": 0.0}], [0.15, {"v": 1.0}], [0.42, {"v": 1.0}], [0.59, {"v": 0.0}]]]), "v")
	if J.cmp(v_glow_455, 0.0, ">"):
		for _t158 in J.iter([0.41, 0.56]):
			v_u_459 = _t158
			v_e_460 = J.mc(v_N_448, "at", [v_S_449, v_m_454, v_u_459, 0.205])
			v_g_461 = J.mc(v_ctx_446, "createRadialGradient", [J.gp(v_e_460, 0.0), J.gp(v_e_460, 1.0), 0.0, J.gp(v_e_460, 0.0), J.gp(v_e_460, 1.0), J.mul(0.08, v_H_451)])
			J.mc(v_g_461, "addColorStop", [0.0, ("rgba(255,60,40," + J.str(J.mul(0.7, v_glow_455)) + ")")])
			J.mc(v_g_461, "addColorStop", [1.0, "rgba(255,60,40,0)"])
			J.sp(v_ctx_446, "fillStyle", v_g_461)
			J.mc(v_ctx_446, "fillRect", [J.sub(J.gp(v_e_460, 0.0), J.mul(0.08, v_H_451)), J.sub(J.gp(v_e_460, 1.0), J.mul(0.08, v_H_451)), J.mul(0.16, v_H_451), J.mul(0.16, v_H_451)])
	v_o_456 = J.mc(v_N_448, "at", [v_S_449, v_m_454, 0.5, 0.45])
	v_T_457 = J.mc(v_N_448, "tgt", [v_S_449, 0.5])
	v_i_462 = 0.0
	while true:
		if not J.cmp(v_i_462, 4.0, "<"): break
		v_q_463 = J.mc(v_N_448, "seg", [v_t_450, (0.2 + J.mul(v_i_462, 0.03)), J.add(J.add(J.gp(v_N_448, "TC"), 0.06), J.mul(v_i_462, 0.03))])
		var _t159 = J.cmp(v_q_463, 0.0, "<=")
		if (_t159 if _t159 else J.cmp(v_q_463, 1.0, ">=")):
			v_i_462 = J.num(v_i_462) + 1.0
			continue
		v_x_464 = J.mc(v_N_448, "lerp", [J.add(J.gp(v_o_456, 0.0), J.mul(0.1, v_H_451)), J.gp(v_T_457, 0.0), v_q_463])
		v_hh_465 = J.mul((0.25 + J.mul(0.35, v_q_463)), v_H_451)
		v_pts_466 = []
		v_j_467 = 0.0
		while true:
			if not J.cmp(v_j_467, 10.0, "<="): break
			v_v_468 = (J.div(v_j_467, 10.0) - 0.5)
			J.mc(v_pts_466, "push", [[J.add(J.add(v_x_464, J.mul((sin(J.num(J.add((J.mul(v_v_468, 9.0) + J.mul(v_t_450, 40.0)), v_i_462))) * 0.03), v_H_451)), J.mul((absf(J.num(v_v_468)) * (-0.12)), v_H_451)), J.add(J.gp(v_T_457, 1.0), J.mul(v_v_468, v_hh_465))]])
			v_j_467 = J.num(v_j_467) + 1.0
		J.mc(v_ctx_446, "save", [])
		var _t160 = J.mul(J.gp(v_ctx_446, "globalAlpha"), sin(J.num(J.mul(v_q_463, PI))))
		J.sp(v_ctx_446, "globalAlpha", _t160)
		J.mc(v_N_448, "crayon", [v_ctx_446, v_pts_466, ("rgba(255,150,60,.85)" if J.t(J.mod(v_i_462, 2.0)) else "rgba(255,90,40,.8)"), J.mul(0.03, v_H_451), J.add(50.0, v_i_462)])
		J.mc(v_ctx_446, "restore", [])
		v_i_462 = J.num(v_i_462) + 1.0
	v_i_469 = 0.0
	while true:
		if not J.cmp(v_i_469, 3.0, "<"): break
		J.mc(v_N_448, "puff", [v_ctx_446, J.mul((J.sub(v_i_469, 1.0) * 0.15), v_H_451), J.mul((-0.02), v_H_451), J.mul(0.06, v_H_451), J.mc(v_N_448, "seg", [v_t_450, (0.05 + J.mul(v_i_469, 0.04)), 0.5]), "rgba(230,200,170,.45)", J.add(60.0, v_i_469), 3.0])
		v_i_469 = J.num(v_i_469) + 1.0
	v_p_458 = J.sub(v_t_450, J.gp(v_N_448, "TC"))
	J.mc(v_N_448, "cracks", [v_ctx_446, J.add(J.gp(v_S_449, "tx"), J.gp(v_S_449, "back")), J.gp(v_S_449, "ty"), J.mul(0.5, v_th_452), J.mul(J.mc(v_N_448, "seg", [v_t_450, J.gp(v_N_448, "TC"), J.add(J.gp(v_N_448, "TC"), 0.05)]), J.sub(1.0, J.mc(v_N_448, "seg", [v_t_450, 0.5, 0.59]))), 70.0])
	v_i_470 = 0.0
	while true:
		if not J.cmp(v_i_470, 3.0, "<"): break
		J.mc(v_N_448, "puff", [v_ctx_446, J.add(J.add(J.gp(v_S_449, "tx"), J.gp(v_S_449, "back")), J.mul((J.sub(v_i_470, 1.0) * 0.15), v_th_452)), J.sub(J.gp(v_S_449, "ty"), J.mul((0.5 + J.mul(v_i_470, 0.15)), v_th_452)), J.mul(0.1, v_th_452), J.mc(v_N_448, "seg", [v_t_450, J.add(J.gp(v_N_448, "TC"), J.mul(v_i_470, 0.03)), 0.55]), "rgba(255,255,255,.55)", J.add(80.0, v_i_470), 3.0])
		v_i_470 = J.num(v_i_470) + 1.0
	var _t161 = J.cmp(v_p_458, 0.0, ">=")
	if (J.cmp(v_p_458, 0.14, "<") if _t161 else _t161):
		J.mc(v_N_448, "burst", [v_ctx_446, J.gp(v_T_457, 0.0), J.gp(v_T_457, 1.0), J.mul(0.35, v_th_452), (1.0 - J.div(v_p_458, 0.14)), "#ffb070", 81.0, 10.0])
	J.mc(v_N_448, "pop", [v_ctx_446, v_S_449, J.gp(v_T_457, 0.0), J.sub(J.gp(v_T_457, 1.0), J.mul(0.5, v_th_452)), "好熱呀！", J.mul(0.22, v_th_452), "#ff9a50", J.gp(v_N_448, "TC"), 0.32])
	J.mc(v_N_448, "hit", [v_S_449, J.gp(v_T_457, 0.0), J.gp(v_T_457, 1.0)])
	J.mc(J.G.get("N30M"), "end", [v_ctx_446])

func _f43(this_, a: Array, env):
	var v_ctx_473 = null; var v_a_474 = null; var v_N_475 = null; var v_S_476 = null; var v_key_477 = null; var v_t_478 = null; var v_H_479 = null; var v_th_480 = null; var v_TP_481 = null; var v_f_482 = null; var v_m_483 = null; var v_home_484 = null; var v_land_485 = null; var v_x_486 = null; var v_y_487 = null; var v_r_488 = null; var v_sx_489 = null; var v_sy_490 = null; var v_mo_491 = null; var v_T_492 = null; var v_p_493 = null; var v_k_494 = null; var v_q_495 = null; var v_q_496 = null; var v_hop_497 = null; var v_i_498 = null; var v_q_499 = null; var v_i_500 = null
	v_ctx_473 = J.arg(a, 0)
	v_a_474 = J.arg(a, 1)
	v_N_475 = J.G.get("N30K")
	v_S_476 = J.mc(v_N_475, "setup", [v_a_474])
	if (not J.t(v_S_476)):
		return false
	v_key_477 = J.mc(J.G.get("N30"), "body", [J.gp(v_S_476, "id")])
	if (not J.t(v_key_477)):
		return false
	v_t_478 = J.gp(v_S_476, "tt")
	v_H_479 = J.gp(v_S_476, "H")
	v_th_480 = J.gp(v_S_476, "th")
	v_TP_481 = [0.8, 0.99]
	v_f_482 = J.mc(v_N_475, "kf", [v_t_478, [[0.0, {}], [0.12, {"armF": (-0.8), "head": (-0.12), "r": (-3.0)}], [0.22, {"armF": (-0.85), "head": (-0.15), "r": (-3.0)}], [0.3, {"armF": 0.3, "head": 0.1, "r": 4.0}], [0.59, {}]]])
	v_m_483 = J.mc(v_N_475, "bm", [v_S_476, v_f_482])
	v_home_484 = J.mc(v_N_475, "at", [v_S_476, J.mc(v_N_475, "bm", [v_S_476, {}]), J.gp(v_TP_481, 0.0), J.gp(v_TP_481, 1.0)])
	v_land_485 = [J.add(J.sub(J.gp(v_S_476, "tx"), J.mul(0.28, v_th_480)), J.gp(v_S_476, "back")), J.gp(v_S_476, "ty")]
	v_x_486 = null
	v_y_487 = null
	v_r_488 = 0.0
	v_sx_489 = 1.0
	v_sy_490 = 1.0
	if J.cmp(v_t_478, 0.14, "<"):
		var _t164 = J.gp(v_N_475, "E")
		v_k_494 = J.mc(_t164, "o", [J.mc(v_N_475, "seg", [v_t_478, 0.04, 0.14])])
		v_x_486 = J.gp(v_home_484, 0.0)
		v_y_487 = J.gp(v_home_484, 1.0)
		var _t165 = (1.0 - J.mul(0.18, v_k_494))
		v_sy_490 = _t165
		var _t166 = (1.0 + J.mul(0.1, v_k_494))
		v_sx_489 = _t166
	else:
		if J.cmp(v_t_478, J.gp(v_N_475, "TC"), "<"):
			v_q_495 = J.mc(v_N_475, "seg", [v_t_478, 0.14, J.gp(v_N_475, "TC")])
			var _t167 = J.mc(v_N_475, "lerp", [J.gp(v_home_484, 0.0), J.gp(v_land_485, 0.0), v_q_495])
			v_x_486 = _t167
			var _t168 = J.sub(J.mc(v_N_475, "lerp", [J.gp(v_home_484, 1.0), J.gp(v_land_485, 1.0), v_q_495]), (J.mul((J.mul(0.55, v_H_479) * 4.0), v_q_495) * J.sub(1.0, v_q_495)))
			v_y_487 = _t168
			var _t169 = J.mc(v_N_475, "lerp", [(-25.0), 30.0, v_q_495])
			v_r_488 = _t169
			var _t170 = (1.0 + (0.12 * sin(J.num(J.mul(v_q_495, PI)))))
			v_sy_490 = _t170
		else:
			if J.cmp(v_t_478, 0.36, "<"):
				v_x_486 = J.gp(v_land_485, 0.0)
				v_y_487 = J.gp(v_land_485, 1.0)
				var _t171 = (30.0 - J.mul(30.0, J.mc(v_N_475, "seg", [v_t_478, J.gp(v_N_475, "TC"), 0.31])))
				v_r_488 = _t171
				var _t172 = (1.0 - (0.12 * sin(J.num(J.mul(J.mc(v_N_475, "seg", [v_t_478, J.gp(v_N_475, "TC"), 0.31]), PI)))))
				v_sy_490 = _t172
			else:
				v_q_496 = J.mc(v_N_475, "seg", [v_t_478, 0.36, 0.59])
				v_hop_497 = absf(J.num(sin(J.num((J.mul(v_q_496, PI) * 2.0)))))
				var _t173 = J.mc(v_N_475, "lerp", [J.gp(v_land_485, 0.0), J.gp(v_home_484, 0.0), v_q_496])
				v_x_486 = _t173
				var _t174 = J.sub(J.gp(v_home_484, 1.0), J.mul(J.mul(v_hop_497, 0.18), v_H_479))
				v_y_487 = _t174
				var _t175 = J.mul((-10.0), v_hop_497)
				v_r_488 = _t175
	J.mc(J.G.get("N30M"), "begin", [v_ctx_473, v_S_476, J.gp(v_f_482, "x")])
	J.mc(v_N_475, "body", [v_ctx_473, v_S_476, v_m_483, J.mc(v_N_475, "pose", [v_S_476, v_f_482, 0.3]), v_key_477])
	J.mc(v_N_475, "pieceAt", [v_ctx_473, v_S_476, "tiger", v_x_486, v_y_487, v_r_488, J.gp(v_TP_481, 0.0), J.gp(v_TP_481, 1.0), v_sx_489, v_sy_490])
	v_mo_491 = J.mc(v_N_475, "at", [v_S_476, v_m_483, 0.25, 0.33])
	v_i_498 = 0.0
	while true:
		if not J.cmp(v_i_498, 3.0, "<"): break
		v_q_499 = J.mc(v_N_475, "seg", [v_t_478, (0.04 + J.mul(v_i_498, 0.05)), (0.22 + J.mul(v_i_498, 0.05))])
		var _t176 = J.cmp(v_q_499, 0.0, ">")
		if (J.cmp(v_q_499, 1.0, "<") if _t176 else _t176):
			J.mc(v_N_475, "txt", [v_ctx_473, v_S_476, J.add(J.gp(v_mo_491, 0.0), J.mul(J.mul(v_q_499, 0.25), v_H_479)), (J.sub(J.gp(v_mo_491, 1.0), J.mul(J.mul(v_q_499, 0.25), v_H_479)) - J.mul(J.mul(v_i_498, 0.03), v_H_479)), ("♫" if J.t(J.mod(v_i_498, 2.0)) else "♪"), J.mul(0.1, v_H_479), "#bfe8ff", sin(J.num(J.mul(v_q_499, PI)))])
		v_i_498 = J.num(v_i_498) + 1.0
	v_T_492 = J.mc(v_N_475, "tgt", [v_S_476, 0.6])
	v_p_493 = J.sub(v_t_478, J.gp(v_N_475, "TC"))
	var _t177 = J.cmp(v_p_493, 0.0, ">=")
	if (J.cmp(v_p_493, 0.25, "<") if _t177 else _t177):
		v_i_500 = 0.0
		while true:
			if not J.cmp(v_i_500, 3.0, "<"): break
			J.mc(v_N_475, "crayon", [v_ctx_473, [[(J.sub(J.gp(v_T_492, 0.0), J.mul(0.12, v_th_480)) + J.mul(J.mul(v_i_500, 0.07), v_th_480)), J.sub(J.gp(v_T_492, 1.0), J.mul(0.15, v_th_480))], [(J.sub(J.gp(v_T_492, 0.0), J.mul(0.18, v_th_480)) + J.mul(J.mul(v_i_500, 0.07), v_th_480)), J.add(J.gp(v_T_492, 1.0), J.mul(0.12, v_th_480))]], "rgba(255,240,230,.9)", J.mul(0.025, v_th_480), J.add(90.0, v_i_500), (1.0 - J.div(v_p_493, 0.25))])
			v_i_500 = J.num(v_i_500) + 1.0
	var _t178 = J.cmp(v_p_493, 0.0, ">=")
	if (J.cmp(v_p_493, 0.13, "<") if _t178 else _t178):
		J.mc(v_N_475, "burst", [v_ctx_473, J.gp(v_T_492, 0.0), J.gp(v_T_492, 1.0), J.mul(0.3, v_th_480), (1.0 - J.div(v_p_493, 0.13)), "#ffd27a", 95.0, 9.0])
	J.mc(v_N_475, "pop", [v_ctx_473, v_S_476, J.gp(v_T_492, 0.0), J.sub(J.gp(v_T_492, 1.0), J.mul(0.45, v_th_480)), "嗷！", J.mul(0.24, v_th_480), "#ffb347", J.gp(v_N_475, "TC"), 0.3])
	J.mc(v_N_475, "hit", [v_S_476, J.gp(v_T_492, 0.0), J.gp(v_T_492, 1.0)])
	J.mc(J.G.get("N30M"), "end", [v_ctx_473])

func _f45(this_, a: Array, env):
	var v_p_529 = null
	v_p_529 = J.arg(a, 0)
	return [J.gp(v_p_529, 0.0), J.add(J.gp(v_p_529, 1.0), J.mul(0.02, env["H"]))]

func _f44(this_, a: Array, env):
	var v_ctx_503 = null; var v_a_504 = null; var v_N_505 = null; var v_S_506 = null; var v_key_507 = null; var v_t_508 = null; var v_th_510 = null; var v_BC_511 = null; var v_f_512 = null; var v_m_513 = null; var v_rest_514 = null; var v_up_515 = null; var v_T_516 = null; var v_P_517 = null; var v_bx_518 = null; var v_by_519 = null; var v_br_520 = null; var v_bs_521 = null; var v_p_522 = null; var v_q_523 = null; var v_q_524 = null; var v_q_525 = null; var v_pts_526 = null; var v_i_527 = null; var v_k_528 = null; var v_i_530 = null; var v_an_531 = null; var v_d_532 = null
	var _s91 = {"__p": env, "H": null}
	v_ctx_503 = J.arg(a, 0)
	v_a_504 = J.arg(a, 1)
	v_N_505 = J.G.get("N30K")
	v_S_506 = J.mc(v_N_505, "setup", [v_a_504])
	if (not J.t(v_S_506)):
		return false
	v_key_507 = J.mc(J.G.get("N30"), "body", [J.gp(v_S_506, "id")])
	if (not J.t(v_key_507)):
		return false
	v_t_508 = J.gp(v_S_506, "tt")
	_s91["H"] = J.gp(v_S_506, "H")
	v_th_510 = J.gp(v_S_506, "th")
	v_BC_511 = [0.39, 0.63]
	v_f_512 = J.mc(v_N_505, "kf", [v_t_508, [[0.0, {}], [0.15, {"r": (-7.0), "armF": (-1.0), "armB": (-0.9), "head": (-0.12), "hairL": 0.25, "hairR": 0.25, "y": J.mul((-0.03), _s91["H"])}], [0.22, {"r": 8.0, "armF": (-0.6), "armB": (-0.5), "head": 0.1, "hairL": (-0.3), "hairR": (-0.3)}, "o"], [0.45, {"r": 2.0, "armF": (-0.2), "armB": (-0.2)}], [0.59, {}]]])
	v_m_513 = J.mc(v_N_505, "bm", [v_S_506, v_f_512])
	v_rest_514 = J.mc(v_N_505, "at", [v_S_506, v_m_513, J.gp(v_BC_511, 0.0), J.gp(v_BC_511, 1.0)])
	v_up_515 = J.mc(v_N_505, "at", [v_S_506, v_m_513, 0.42, 0.05])
	v_T_516 = J.mc(v_N_505, "tgt", [v_S_506, 0.82])
	v_P_517 = J.mc(v_N_505, "kf", [v_t_508, [[0.0, {"x": J.gp(v_rest_514, 0.0), "y": J.gp(v_rest_514, 1.0), "r": 0.0}], [0.15, {"x": J.sub(J.gp(v_up_515, 0.0), J.mul(0.05, _s91["H"])), "y": J.gp(v_up_515, 1.0), "r": (-20.0)}], [0.17, {"x": J.gp(v_up_515, 0.0), "y": J.gp(v_up_515, 1.0), "r": (-10.0)}]]])
	v_bx_518 = J.gp(v_P_517, "x")
	v_by_519 = J.gp(v_P_517, "y")
	v_br_520 = J.gp(v_P_517, "r")
	v_bs_521 = 1.0
	var _t181 = J.cmp(v_t_508, 0.17, ">=")
	if (J.cmp(v_t_508, J.gp(v_N_505, "TC"), "<") if _t181 else _t181):
		v_q_523 = J.mc(v_N_505, "seg", [v_t_508, 0.17, J.gp(v_N_505, "TC")])
		var _t182 = J.mc(v_N_505, "lerp", [J.gp(v_up_515, 0.0), J.gp(v_T_516, 0.0), v_q_523])
		v_bx_518 = _t182
		var _t183 = J.sub(J.mc(v_N_505, "lerp", [J.gp(v_up_515, 1.0), J.gp(v_T_516, 1.0), v_q_523]), (J.mul((J.mul(0.3, _s91["H"]) * 4.0), v_q_523) * J.sub(1.0, v_q_523)))
		v_by_519 = _t183
		var _t184 = J.mul(v_q_523, 300.0)
		v_br_520 = _t184
	else:
		var _t185 = J.cmp(v_t_508, J.gp(v_N_505, "TC"), ">=")
		if (J.cmp(v_t_508, 0.4, "<") if _t185 else _t185):
			v_q_524 = J.mc(v_N_505, "seg", [v_t_508, J.gp(v_N_505, "TC"), 0.4])
			var _t186 = J.sub(J.gp(v_T_516, 0.0), J.mul(J.mul(v_q_524, 0.15), v_th_510))
			v_bx_518 = _t186
			var _t187 = J.sub(J.gp(v_T_516, 1.0), (J.mul(0.45, v_th_510) * sin(J.num(J.mul(v_q_524, PI)))))
			v_by_519 = _t187
			var _t188 = (300.0 + J.mul(v_q_524, 200.0))
			v_br_520 = _t188
			var _t189 = ((1.0 - (0.25 * sin(J.num((J.div(v_q_524, 0.12) * PI))))) if J.cmp(v_q_524, 0.12, "<") else 1.0)
			v_bs_521 = _t189
		else:
			if J.cmp(v_t_508, 0.4, ">="):
				var _t190 = J.gp(v_N_505, "E")
				v_q_525 = J.mc(_t190, "io", [J.mc(v_N_505, "seg", [v_t_508, 0.4, 0.56])])
				var _t191 = J.mc(v_N_505, "lerp", [J.sub(J.gp(v_T_516, 0.0), J.mul(0.15, v_th_510)), J.gp(v_rest_514, 0.0), v_q_525])
				v_bx_518 = _t191
				var _t192 = J.sub(J.mc(v_N_505, "lerp", [J.gp(v_T_516, 1.0), J.gp(v_rest_514, 1.0), v_q_525]), (J.mul((J.mul(0.35, _s91["H"]) * 4.0), v_q_525) * J.sub(1.0, v_q_525)))
				v_by_519 = _t192
				var _t193 = (500.0 + J.mul(v_q_525, 220.0))
				v_br_520 = _t193
				if J.cmp(v_t_508, 0.56, ">"):
					v_bx_518 = J.gp(v_rest_514, 0.0)
					v_by_519 = J.gp(v_rest_514, 1.0)
					v_br_520 = 0.0
	J.mc(J.G.get("N30M"), "begin", [v_ctx_503, v_S_506, J.gp(v_f_512, "x")])
	J.mc(v_N_505, "body", [v_ctx_503, v_S_506, v_m_513, J.mc(v_N_505, "pose", [v_S_506, v_f_512, 0.3]), v_key_507])
	var _t194 = J.cmp(v_t_508, 0.17, ">")
	if (J.cmp(v_t_508, 0.56, "<") if _t194 else _t194):
		v_pts_526 = []
		v_i_527 = 0.0
		while true:
			if not J.cmp(v_i_527, 8.0, "<"): break
			v_k_528 = J.div(v_i_527, 7.0)
			J.mc(v_pts_526, "push", [[(J.sub(v_bx_518, J.mul((J.sub(v_bx_518, J.gp(v_up_515, 0.0)) * 0.35), v_k_528)) + J.mul((sin(J.num((J.mul(v_t_508, 30.0) + J.mul(v_k_528, 5.0)))) * 0.03), _s91["H"])), (J.sub(v_by_519, J.mul((J.sub(v_by_519, J.gp(v_up_515, 1.0)) * 0.35), v_k_528)) + J.mul(J.mul(v_k_528, 0.08), _s91["H"]))]])
			v_i_527 = J.num(v_i_527) + 1.0
		J.mc(v_ctx_503, "save", [])
		var _t195 = J.mul(J.gp(v_ctx_503, "globalAlpha"), 0.85)
		J.sp(v_ctx_503, "globalAlpha", _t195)
		J.mc(v_N_505, "crayon", [v_ctx_503, v_pts_526, "#d8252e", J.mul(0.035, _s91["H"]), 7.0])
		J.mc(v_N_505, "crayon", [v_ctx_503, J.mc(v_pts_526, "map", [Callable(self, "_f45").bind(_s91)]), "#ff6a5a", J.mul(0.015, _s91["H"]), 8.0])
		J.mc(v_ctx_503, "restore", [])
	J.mc(v_N_505, "pieceAt", [v_ctx_503, v_S_506, "ball", v_bx_518, v_by_519, v_br_520, J.gp(v_BC_511, 0.0), J.gp(v_BC_511, 1.0), v_bs_521, J.sub(2.0, v_bs_521)])
	v_p_522 = J.sub(v_t_508, J.gp(v_N_505, "TC"))
	var _t196 = J.cmp(v_p_522, 0.0, ">=")
	if (J.cmp(v_p_522, 0.3, "<") if _t196 else _t196):
		v_i_530 = 0.0
		while true:
			if not J.cmp(v_i_530, 9.0, "<"): break
			v_an_531 = J.mul(J.mc(v_N_505, "rnd", [v_i_530]), 6.28)
			v_d_532 = J.mul(J.mul((0.1 + J.mul(v_p_522, 1.3)), v_th_510), J.add(0.5, J.mc(v_N_505, "rnd", [J.add(v_i_530, 3.0)])))
			J.mc(v_ctx_503, "save", [])
			var _t197 = J.mul(J.gp(v_ctx_503, "globalAlpha"), (1.0 - J.div(v_p_522, 0.3)))
			J.sp(v_ctx_503, "globalAlpha", _t197)
			var _t198 = ("#e8303a" if J.t(J.mod(v_i_530, 2.0)) else "#ff8a80")
			J.sp(v_ctx_503, "fillStyle", _t198)
			J.mc(v_ctx_503, "beginPath", [])
			J.mc(v_ctx_503, "ellipse", [J.add(J.gp(v_T_516, 0.0), J.mul(cos(J.num(v_an_531)), v_d_532)), J.add(J.add(J.gp(v_T_516, 1.0), J.mul(sin(J.num(v_an_531)), v_d_532)), J.mul((J.mul(v_p_522, v_p_522) * 2.0), v_th_510)), J.mul(0.03, v_th_510), J.mul(0.018, v_th_510), J.add(v_an_531, J.mul(v_t_508, 9.0)), 0.0, 7.0])
			J.mc(v_ctx_503, "fill", [])
			J.mc(v_ctx_503, "restore", [])
			v_i_530 = J.num(v_i_530) + 1.0
	var _t199 = J.cmp(v_p_522, 0.0, ">=")
	if (J.cmp(v_p_522, 0.13, "<") if _t199 else _t199):
		J.mc(v_N_505, "burst", [v_ctx_503, J.gp(v_T_516, 0.0), J.gp(v_T_516, 1.0), J.mul(0.3, v_th_510), (1.0 - J.div(v_p_522, 0.13)), "#ffd0d0", 99.0, 9.0])
	J.mc(v_N_505, "pop", [v_ctx_503, v_S_506, J.gp(v_T_516, 0.0), J.sub(J.gp(v_T_516, 1.0), J.mul(0.35, v_th_510)), "嫁畀我！", J.mul(0.2, v_th_510), "#ff8a8a", J.gp(v_N_505, "TC"), 0.32])
	J.mc(v_N_505, "hit", [v_S_506, J.gp(v_T_516, 0.0), J.gp(v_T_516, 1.0)])
	J.mc(J.G.get("N30M"), "end", [v_ctx_503])

func _f46(this_, a: Array, env):
	var v_ctx_535 = null; var v_a_536 = null; var v_N_537 = null; var v_S_538 = null; var v_t_539 = null; var v_H_540 = null; var v_th_541 = null; var v_D2_542 = null; var v_f_543 = null; var v_T_544 = null; var v_p_545 = null; var v_i_546 = null
	v_ctx_535 = J.arg(a, 0)
	v_a_536 = J.arg(a, 1)
	v_N_537 = J.G.get("N30K")
	v_S_538 = J.mc(v_N_537, "setup", [v_a_536])
	if (not J.t(v_S_538)):
		return false
	v_t_539 = J.gp(v_S_538, "tt")
	v_H_540 = J.gp(v_S_538, "H")
	v_th_541 = J.gp(v_S_538, "th")
	v_D2_542 = J.max_([0.0, (J.sub(J.gp(v_S_538, "tx"), J.mul(0.45, v_th_541)) - J.mul(0.25, v_H_540))])
	v_f_543 = J.mc(v_N_537, "kf", [v_t_539, [[0.0, {}], [0.14, {"sy": 0.88, "sx": 1.06, "armF": 0.9, "armB": 0.5, "body": (-0.1), "head": (-0.1), "hairL": 0.2, "hairR": 0.2}], [0.2, {"y": J.mul((-0.16), v_H_540), "x": J.mul(v_D2_542, 0.6), "sy": 1.05, "armF": 0.8, "armB": 0.4, "r": (-6.0)}, "o"], [J.gp(v_N_537, "TC"), {"x": v_D2_542, "y": 0.0, "sy": 0.94, "armF": (-0.9), "armB": (-0.3), "body": 0.15, "head": 0.1, "r": 10.0, "hairL": (-0.3), "hairR": (-0.3)}, "i"], [0.36, {"x": v_D2_542, "sy": 0.96, "armF": (-1.0), "armB": (-0.4), "body": 0.15, "r": 8.0}], [0.46, {"x": J.mul(v_D2_542, 0.5), "y": J.mul((-0.12), v_H_540), "armF": (-0.2)}], [0.52, {"x": J.mul(v_D2_542, 0.3), "y": 0.0}], [0.56, {"x": J.mul(v_D2_542, 0.1), "y": J.mul((-0.06), v_H_540)}], [0.59, {}]]])
	var _t203 = J.gp(v_f_543, "x")
	var _t202 = J.gp(v_f_543, "y")
	J.mc(J.G.get("N30M"), "begin", [v_ctx_535, v_S_538, _t203, J.sub(1.0, J.mc(v_N_537, "cl", [J.div((-J.num((_t202 if J.t(_t202) else 0.0))), v_H_540)]))])
	J.mc(v_N_537, "whole", [v_ctx_535, v_S_538, v_f_543, null, 0.3])
	v_T_544 = J.mc(v_N_537, "tgt", [v_S_538, 0.55])
	v_p_545 = J.sub(v_t_539, J.gp(v_N_537, "TC"))
	var _t204 = J.cmp(v_t_539, 0.2, ">")
	if (J.cmp(v_t_539, 0.3, "<") if _t204 else _t204):
		J.mc(v_N_537, "speed", [v_ctx_535, J.sub(J.gp(v_T_544, 0.0), J.mul(0.1, v_th_541)), J.sub(J.gp(v_T_544, 1.0), J.mul(0.1, v_th_541)), 0.3, 1.0, J.mul(0.4, v_H_540), J.mul(0.2, v_H_540), J.mc(v_N_537, "seg", [v_t_539, 0.2, 0.24]), "rgba(220,240,200,.7)", 12.0, 4.0])
	var _t205 = J.cmp(v_p_545, 0.0, ">=")
	if (J.cmp(v_p_545, 0.28, "<") if _t205 else _t205):
		v_i_546 = 0.0
		while true:
			if not J.cmp(v_i_546, 3.0, "<"): break
			J.mc(v_N_537, "crayon", [v_ctx_535, [[(J.sub(J.gp(v_T_544, 0.0), J.mul(0.15, v_th_541)) + J.mul(J.mul(v_i_546, 0.08), v_th_541)), J.sub(J.gp(v_T_544, 1.0), J.mul(0.25, v_th_541))], [(J.sub(J.gp(v_T_544, 0.0), J.mul(0.05, v_th_541)) + J.mul(J.mul(v_i_546, 0.08), v_th_541)), J.add(J.gp(v_T_544, 1.0), J.mul(0.2, v_th_541))]], "rgba(255,245,235,.95)", J.mul(0.03, v_th_541), J.add(110.0, v_i_546), (1.0 - J.div(v_p_545, 0.28))])
			v_i_546 = J.num(v_i_546) + 1.0
	var _t206 = J.cmp(v_p_545, 0.0, ">=")
	if (J.cmp(v_p_545, 0.13, "<") if _t206 else _t206):
		J.mc(v_N_537, "burst", [v_ctx_535, J.gp(v_T_544, 0.0), J.gp(v_T_544, 1.0), J.mul(0.32, v_th_541), (1.0 - J.div(v_p_545, 0.13)), "#e9ffd0", 113.0, 9.0])
	J.mc(v_N_537, "hit", [v_S_538, J.gp(v_T_544, 0.0), J.gp(v_T_544, 1.0)])
	J.mc(J.G.get("N30M"), "end", [v_ctx_535])

func _f47(this_, a: Array, env):
	var v_ctx_549 = null; var v_a_550 = null; var v_N_551 = null; var v_S_552 = null; var v_t_553 = null; var v_H_554 = null; var v_th_555 = null; var v_f_556 = null; var v_m_557 = null; var v_lip_558 = null; var v_T_559 = null; var v_q_560 = null; var v_x_561 = null; var v_y_562 = null; var v_p_563 = null; var v_r_564 = null; var v_i_565 = null; var v_k_566 = null; var v_r_567 = null; var v_bite_568 = null; var v_i_569 = null
	v_ctx_549 = J.arg(a, 0)
	v_a_550 = J.arg(a, 1)
	v_N_551 = J.G.get("N30K")
	v_S_552 = J.mc(v_N_551, "setup", [v_a_550])
	if (not J.t(v_S_552)):
		return false
	v_t_553 = J.gp(v_S_552, "tt")
	v_H_554 = J.gp(v_S_552, "H")
	v_th_555 = J.gp(v_S_552, "th")
	v_f_556 = J.mc(v_N_551, "kf", [v_t_553, [[0.0, {}], [0.15, {"r": (-5.0), "armF": (-0.25), "head": (-0.15), "body": (-0.08), "orn": 0.3}], [0.22, {"r": 6.0, "armF": (-0.9), "head": 0.12, "body": 0.08, "orn": (-0.3)}, "o"], [0.4, {"r": 3.0, "armF": (-0.5), "head": 0.05}], [0.59, {}]]])
	v_m_557 = J.mc(v_N_551, "bm", [v_S_552, v_f_556])
	J.mc(J.G.get("N30M"), "begin", [v_ctx_549, v_S_552, J.gp(v_f_556, "x")])
	J.mc(v_N_551, "whole", [v_ctx_549, v_S_552, v_f_556, null, 0.3])
	v_lip_558 = J.mc(v_N_551, "at", [v_S_552, v_m_557, 0.33, 0.235])
	v_T_559 = J.mc(v_N_551, "tgt", [v_S_552, 0.8])
	v_q_560 = J.mc(v_N_551, "seg", [v_t_553, 0.19, J.gp(v_N_551, "TC")])
	v_x_561 = J.mc(v_N_551, "lerp", [J.gp(v_lip_558, 0.0), J.gp(v_T_559, 0.0), v_q_560])
	v_y_562 = J.add(J.mc(v_N_551, "lerp", [J.gp(v_lip_558, 1.0), J.gp(v_T_559, 1.0), v_q_560]), J.mul((sin(J.num(J.mul(v_q_560, 9.0))) * 0.03), v_H_554))
	var _t209 = J.cmp(v_t_553, 0.19, ">")
	if (J.cmp(v_t_553, J.add(J.gp(v_N_551, "TC"), 0.01), "<") if _t209 else _t209):
		v_r_564 = J.mul((0.04 + J.mul(0.04, v_q_560)), v_H_554)
		J.mc(v_ctx_549, "save", [])
		J.mc(v_ctx_549, "translate", [v_x_561, v_y_562])
		J.mc(v_ctx_549, "rotate", [(sin(J.num(J.mul(v_t_553, 20.0))) * 0.2)])
		J.sp(v_ctx_549, "fillStyle", "#ff7aa8")
		J.sp(v_ctx_549, "strokeStyle", "#5a1a30")
		var _t210 = J.mul(v_r_564, 0.15)
		J.sp(v_ctx_549, "lineWidth", _t210)
		J.mc(v_ctx_549, "beginPath", [])
		J.mc(v_ctx_549, "moveTo", [0.0, J.mul(v_r_564, 0.9)])
		J.mc(v_ctx_549, "bezierCurveTo", [((-J.num(v_r_564)) * 1.4), ((-J.num(v_r_564)) * 0.1), ((-J.num(v_r_564)) * 0.6), ((-J.num(v_r_564)) * 1.1), 0.0, ((-J.num(v_r_564)) * 0.35)])
		J.mc(v_ctx_549, "bezierCurveTo", [J.mul(v_r_564, 0.6), ((-J.num(v_r_564)) * 1.1), J.mul(v_r_564, 1.4), ((-J.num(v_r_564)) * 0.1), 0.0, J.mul(v_r_564, 0.9)])
		J.mc(v_ctx_549, "fill", [])
		J.mc(v_ctx_549, "stroke", [])
		J.mc(v_ctx_549, "restore", [])
		v_i_565 = 0.0
		while true:
			if not J.cmp(v_i_565, 3.0, "<"): break
			J.mc(v_N_551, "txt", [v_ctx_549, v_S_552, J.sub(v_x_561, J.mul(J.mul(J.add(v_i_565, 1.0), 0.06), v_H_554)), J.add(v_y_562, J.mul((sin(J.num((J.mul(v_i_565, 2.0) + J.mul(v_t_553, 10.0)))) * 0.03), v_H_554)), "♥", J.mul(0.05, v_H_554), "#ffb3cc", (0.6 - J.mul(v_i_565, 0.18))])
			v_i_565 = J.num(v_i_565) + 1.0
	v_p_563 = J.sub(v_t_553, J.gp(v_N_551, "TC"))
	var _t211 = J.cmp(v_p_563, 0.0, ">=")
	if (J.cmp(v_p_563, 0.26, "<") if _t211 else _t211):
		v_k_566 = J.div(v_p_563, 0.26)
		v_r_567 = (J.mul(0.16, v_th_555) * (J.div(v_p_563, 0.04) if J.cmp(v_p_563, 0.04, "<") else 1.0))
		v_bite_568 = (J.mul(absf(J.num(sin(J.num(J.mul(v_p_563, 40.0))))), v_r_567) * 0.25)
		J.mc(v_ctx_549, "save", [])
		var _t212 = J.mul(J.gp(v_ctx_549, "globalAlpha"), (J.div(J.sub(1.0, v_k_566), 0.25) if J.cmp(v_k_566, 0.75, ">") else 1.0))
		J.sp(v_ctx_549, "globalAlpha", _t212)
		J.mc(v_ctx_549, "translate", [J.gp(v_T_559, 0.0), J.gp(v_T_559, 1.0)])
		var _t213 = J.mul(v_r_567, 0.12)
		J.sp(v_ctx_549, "lineWidth", _t213)
		J.sp(v_ctx_549, "strokeStyle", "#3a2a2a")
		J.sp(v_ctx_549, "fillStyle", "#f4efe2")
		J.mc(v_ctx_549, "beginPath", [])
		J.mc(v_ctx_549, "arc", [0.0, ((-J.num(v_bite_568)) * 0.5), v_r_567, (PI * 0.95), (PI * 2.05)])
		J.mc(v_ctx_549, "lineTo", [J.mul(v_r_567, 0.6), (J.mul(v_r_567, 0.25) - J.mul(v_bite_568, 0.5))])
		J.mc(v_ctx_549, "lineTo", [((-J.num(v_r_567)) * 0.6), (J.mul(v_r_567, 0.25) - J.mul(v_bite_568, 0.5))])
		J.mc(v_ctx_549, "closePath", [])
		J.mc(v_ctx_549, "fill", [])
		J.mc(v_ctx_549, "stroke", [])
		J.sp(v_ctx_549, "fillStyle", "#2a1a1a")
		J.mc(v_ctx_549, "beginPath", [])
		J.mc(v_ctx_549, "ellipse", [((-J.num(v_r_567)) * 0.38), (((-J.num(v_r_567)) * 0.2) - J.mul(v_bite_568, 0.5)), J.mul(v_r_567, 0.22), J.mul(v_r_567, 0.26), 0.0, 0.0, 7.0])
		J.mc(v_ctx_549, "ellipse", [J.mul(v_r_567, 0.38), (((-J.num(v_r_567)) * 0.2) - J.mul(v_bite_568, 0.5)), J.mul(v_r_567, 0.22), J.mul(v_r_567, 0.26), 0.0, 0.0, 7.0])
		J.mc(v_ctx_549, "fill", [])
		J.sp(v_ctx_549, "fillStyle", "#f4efe2")
		J.mc(v_ctx_549, "beginPath", [])
		J.mc(v_ctx_549, "rect", [((-J.num(v_r_567)) * 0.5), (J.mul(v_r_567, 0.3) + J.mul(v_bite_568, 0.5)), v_r_567, J.mul(v_r_567, 0.35)])
		J.mc(v_ctx_549, "fill", [])
		J.mc(v_ctx_549, "stroke", [])
		v_i_569 = (-1.0)
		while true:
			if not J.cmp(v_i_569, 1.0, "<="): break
			J.mc(v_ctx_549, "beginPath", [])
			J.mc(v_ctx_549, "moveTo", [(J.mul(v_i_569, v_r_567) * 0.25), (J.mul(v_r_567, 0.3) + J.mul(v_bite_568, 0.5))])
			J.mc(v_ctx_549, "lineTo", [(J.mul(v_i_569, v_r_567) * 0.25), (J.mul(v_r_567, 0.65) + J.mul(v_bite_568, 0.5))])
			J.mc(v_ctx_549, "stroke", [])
			v_i_569 = J.num(v_i_569) + 1.0
		J.mc(v_ctx_549, "restore", [])
	var _t214 = J.cmp(v_p_563, 0.0, ">=")
	if (J.cmp(v_p_563, 0.12, "<") if _t214 else _t214):
		J.mc(v_N_551, "burst", [v_ctx_549, J.gp(v_T_559, 0.0), J.gp(v_T_559, 1.0), J.mul(0.3, v_th_555), (1.0 - J.div(v_p_563, 0.12)), "#ffd6e6", 121.0, 9.0])
	J.mc(v_N_551, "pop", [v_ctx_549, v_S_552, J.gp(v_T_559, 0.0), J.sub(J.gp(v_T_559, 1.0), J.mul(0.35, v_th_555)), "啵！", J.mul(0.22, v_th_555), "#ffb3cc", J.sub(J.gp(v_N_551, "TC"), 0.01), 0.3])
	J.mc(v_N_551, "hit", [v_S_552, J.gp(v_T_559, 0.0), J.gp(v_T_559, 1.0)])
	J.mc(J.G.get("N30M"), "end", [v_ctx_549])

func _f49(this_, a: Array, env):
	var v_o_589 = null; var v_i_590 = null
	v_o_589 = J.arg(a, 0)
	v_i_590 = J.arg(a, 1)
	return J.mc(env["N"], "puff", [env["ctx"], J.gp(v_o_589, 0.0), J.gp(v_o_589, 1.0), J.mul(0.06, env["H"]), J.mc(env["N"], "seg", [env["t"], 0.15, 0.4]), "rgba(190,175,150,.55)", J.add(130.0, v_i_590), 4.0])

func _f50(this_, a: Array, env):
	var v_x_591 = null; var v_y_592 = null; var v_s_593 = null; var v_ph_594 = null; var v_fl_595 = null; var v_sg_596 = null
	v_x_591 = J.arg(a, 0)
	v_y_592 = J.arg(a, 1)
	v_s_593 = J.arg(a, 2)
	v_ph_594 = J.arg(a, 3)
	v_fl_595 = absf(J.num(sin(J.num(J.add(J.mul(env["t"], 45.0), v_ph_594)))))
	J.mc(env["ctx"], "save", [])
	J.mc(env["ctx"], "translate", [v_x_591, v_y_592])
	var _t217 = env["ctx"]
	J.sp(_t217, "fillStyle", "#c9b08a")
	var _t218 = env["ctx"]
	J.sp(_t218, "strokeStyle", "#4a3a28")
	var _t219 = env["ctx"]
	var _t220 = J.mul(v_s_593, 0.12)
	J.sp(_t219, "lineWidth", _t220)
	for _t221 in J.iter([(-1.0), 1.0]):
		v_sg_596 = _t221
		J.mc(env["ctx"], "beginPath", [])
		J.mc(env["ctx"], "ellipse", [(J.mul(v_sg_596, v_s_593) * 0.45), ((-J.num(v_s_593)) * 0.1), J.mul(v_s_593, 0.5), J.mul(J.mul(v_s_593, 0.35), J.add(0.3, v_fl_595)), J.mul(v_sg_596, 0.5), 0.0, 7.0])
		J.mc(env["ctx"], "fill", [])
		J.mc(env["ctx"], "stroke", [])
	var _t222 = env["ctx"]
	J.sp(_t222, "fillStyle", "#5a4630")
	J.mc(env["ctx"], "beginPath", [])
	J.mc(env["ctx"], "ellipse", [0.0, 0.0, J.mul(v_s_593, 0.12), J.mul(v_s_593, 0.3), 0.0, 0.0, 7.0])
	J.mc(env["ctx"], "fill", [])
	J.mc(env["ctx"], "restore", [])

func _f48(this_, a: Array, env):
	var v_a_573 = null; var v_S_575 = null; var v_key_576 = null; var v_th_579 = null; var v_MC_580 = null; var v_f_581 = null; var v_m_582 = null; var v_home_583 = null; var v_T_584 = null; var v_pk_585 = null; var v_moth_586 = null; var v_L_587 = null; var v_p_588 = null; var v_i_597 = null; var v_o_598 = null; var v_st_599 = null; var v_q_600 = null; var v_an_601 = null; var v_rad_602 = null; var v_x_603 = null; var v_y_604 = null; var v_sc_605 = null
	var _s110 = {"__p": env, "ctx": null, "N": null, "t": null, "H": null}
	_s110["ctx"] = J.arg(a, 0)
	v_a_573 = J.arg(a, 1)
	_s110["N"] = J.G.get("N30K")
	v_S_575 = J.mc(_s110["N"], "setup", [v_a_573])
	if (not J.t(v_S_575)):
		return false
	v_key_576 = J.mc(J.G.get("N30"), "body", [J.gp(v_S_575, "id")])
	if (not J.t(v_key_576)):
		return false
	_s110["t"] = J.gp(v_S_575, "tt")
	_s110["H"] = J.gp(v_S_575, "H")
	v_th_579 = J.gp(v_S_575, "th")
	v_MC_580 = [0.84, 0.455]
	v_f_581 = J.mc(_s110["N"], "kf", [_s110["t"], [[0.0, {}], [0.15, {"armF": 0.4, "armB": (-0.4), "y": J.mul((-0.04), _s110["H"]), "sy": 1.04, "head": (-0.1)}], [0.24, {"armF": 0.55, "armB": (-0.55), "y": J.mul((-0.02), _s110["H"]), "r": 5.0, "head": 0.1}], [0.45, {"armF": 0.3, "armB": (-0.3)}], [0.59, {}]]])
	v_m_582 = J.mc(_s110["N"], "bm", [v_S_575, v_f_581])
	v_home_583 = J.mc(_s110["N"], "at", [v_S_575, v_m_582, J.gp(v_MC_580, 0.0), J.gp(v_MC_580, 1.0)])
	v_T_584 = J.mc(_s110["N"], "tgt", [v_S_575, 0.78])
	v_pk_585 = [J.mc(_s110["N"], "at", [v_S_575, v_m_582, 0.13, 0.62]), J.mc(_s110["N"], "at", [v_S_575, v_m_582, 0.66, 0.62])]
	J.mc(J.G.get("N30M"), "begin", [_s110["ctx"], v_S_575, J.gp(v_f_581, "x")])
	J.mc(_s110["N"], "body", [_s110["ctx"], v_S_575, v_m_582, J.mc(_s110["N"], "pose", [v_S_575, v_f_581, 0.3]), v_key_576])
	J.mc(v_pk_585, "forEach", [Callable(self, "_f49").bind(_s110)])
	v_moth_586 = Callable(self, "_f50").bind(_s110)
	v_i_597 = 0.0
	while true:
		if not J.cmp(v_i_597, 9.0, "<"): break
		v_o_598 = J.gp(v_pk_585, J.mod(v_i_597, 2.0))
		v_st_599 = (0.17 + J.mul(J.mc(_s110["N"], "rnd", [v_i_597]), 0.04))
		v_q_600 = J.mc(_s110["N"], "seg", [_s110["t"], v_st_599, J.gp(_s110["N"], "TC")])
		v_an_601 = (J.mul(_s110["t"], 9.0) + J.mul(v_i_597, 0.7))
		v_rad_602 = J.mul((0.12 + J.mul(J.mc(_s110["N"], "rnd", [J.add(v_i_597, 9.0)]), 0.12)), v_th_579)
		if J.cmp(_s110["t"], v_st_599, "<"):
			v_i_597 = J.num(v_i_597) + 1.0
			continue
		var _t224 = J.gp(v_o_598, 0.0)
		var _t225 = J.add(J.gp(v_T_584, 0.0), J.mul(cos(J.num(v_an_601)), v_rad_602))
		var _t223 = J.gp(_s110["N"], "E")
		v_x_603 = J.mc(_s110["N"], "lerp", [_t224, _t225, J.mc(_t223, "o", [v_q_600])])
		var _t227 = J.gp(v_o_598, 1.0)
		var _t228 = J.add(J.gp(v_T_584, 1.0), (J.mul(sin(J.num(v_an_601)), v_rad_602) * 0.6))
		var _t226 = J.gp(_s110["N"], "E")
		v_y_604 = J.sub(J.mc(_s110["N"], "lerp", [_t227, _t228, J.mc(_t226, "o", [v_q_600])]), J.mul((sin(J.num(J.mul(v_q_600, PI))) * 0.15), _s110["H"]))
		v_sc_605 = J.mc(_s110["N"], "seg", [_s110["t"], 0.42, 0.59])
		var _t229 = J.add(v_x_603, J.mul((J.mul(v_sc_605, J.sub(J.mc(_s110["N"], "rnd", [J.add(v_i_597, 2.0)]), 0.3)) * 0.8), _s110["H"]))
		v_x_603 = _t229
		var _t230 = J.sub(v_y_604, J.mul(J.mul(v_sc_605, (0.3 + J.mul(J.mc(_s110["N"], "rnd", [J.add(v_i_597, 4.0)]), 0.4))), _s110["H"]))
		v_y_604 = _t230
		J.mc(_s110["ctx"], "save", [])
		var _t231 = _s110["ctx"]
		var _t232 = J.mul(J.gp(_t231, "globalAlpha"), J.sub(1.0, v_sc_605))
		J.sp(_t231, "globalAlpha", _t232)
		J.cl(v_moth_586, null, [v_x_603, v_y_604, J.mul(0.045, _s110["H"]), v_i_597])
		J.mc(_s110["ctx"], "restore", [])
		v_i_597 = J.num(v_i_597) + 1.0
	v_L_587 = J.mc(_s110["N"], "kf", [_s110["t"], [[0.0, {"x": J.gp(v_home_583, 0.0), "y": J.gp(v_home_583, 1.0)}], [0.15, {"x": J.gp(v_home_583, 0.0), "y": J.sub(J.gp(v_home_583, 1.0), J.mul(0.06, _s110["H"]))}], [J.gp(_s110["N"], "TC"), {"x": J.gp(v_T_584, 0.0), "y": J.sub(J.gp(v_T_584, 1.0), J.mul(0.08, v_th_579))}, "i"], [0.4, {"x": J.add(J.gp(v_T_584, 0.0), J.mul(0.1, v_th_579)), "y": J.sub(J.gp(v_T_584, 1.0), J.mul(0.2, v_th_579))}], [0.59, {"x": J.gp(v_home_583, 0.0), "y": J.gp(v_home_583, 1.0)}]]])
	J.mc(_s110["N"], "pieceAt", [_s110["ctx"], v_S_575, "moth", J.add(J.gp(v_L_587, "x"), J.mul((sin(J.num(J.mul(_s110["t"], 25.0))) * 0.01), _s110["H"])), J.gp(v_L_587, "y"), (sin(J.num(J.mul(_s110["t"], 30.0))) * 12.0), J.gp(v_MC_580, 0.0), J.gp(v_MC_580, 1.0)])
	v_p_588 = J.sub(_s110["t"], J.gp(_s110["N"], "TC"))
	var _t233 = J.cmp(v_p_588, 0.0, ">=")
	if (J.cmp(v_p_588, 0.12, "<") if _t233 else _t233):
		J.mc(_s110["N"], "burst", [_s110["ctx"], J.gp(v_T_584, 0.0), J.gp(v_T_584, 1.0), J.mul(0.28, v_th_579), (1.0 - J.div(v_p_588, 0.12)), "#e8dcc0", 141.0, 8.0])
	J.mc(_s110["N"], "pop", [_s110["ctx"], v_S_575, J.gp(v_T_584, 0.0), J.sub(J.gp(v_T_584, 1.0), J.mul(0.4, v_th_579)), "一毫都冇！", J.mul(0.17, v_th_579), "#e8dcc0", J.gp(_s110["N"], "TC"), 0.32])
	J.mc(_s110["N"], "hit", [v_S_575, J.gp(v_T_584, 0.0), J.gp(v_T_584, 1.0)])
	J.mc(J.G.get("N30M"), "end", [_s110["ctx"]])

func _f51(this_, a: Array, env):
	var v_ctx_608 = null; var v_a_609 = null; var v_N_610 = null; var v_S_611 = null; var v_key_612 = null; var v_t_613 = null; var v_H_614 = null; var v_th_615 = null; var v_DC_616 = null; var v_shake_617 = null; var v_f_618 = null; var v_m_619 = null; var v_hand_620 = null; var v_T_621 = null; var v_C_622 = null; var v_dx_623 = null; var v_dy_624 = null; var v_dr_625 = null; var v_ds_626 = null; var v_cardO_627 = null; var v_p_628 = null; var v_q_629 = null; var v_q_630 = null; var v_i_631 = null; var v_st_632 = null; var v_q_633 = null; var v_stick_634 = null; var v_tx2_635 = null; var v_ty2_636 = null; var v_x_637 = null; var v_y_638 = null; var v_al_639 = null; var v_w_640 = null; var v_h_641 = null
	v_ctx_608 = J.arg(a, 0)
	v_a_609 = J.arg(a, 1)
	v_N_610 = J.G.get("N30K")
	v_S_611 = J.mc(v_N_610, "setup", [v_a_609])
	if (not J.t(v_S_611)):
		return false
	v_key_612 = J.mc(J.G.get("N30"), "body", [J.gp(v_S_611, "id")])
	if (not J.t(v_key_612)):
		return false
	v_t_613 = J.gp(v_S_611, "tt")
	v_H_614 = J.gp(v_S_611, "H")
	v_th_615 = J.gp(v_S_611, "th")
	v_DC_616 = [0.125, 0.49]
	v_shake_617 = ((sin(J.num(J.mul(v_t_613, 90.0))) * 0.12) if J.cmp(v_t_613, 0.15, "<") else 0.0)
	v_f_618 = J.mc(v_N_610, "kf", [v_t_613, [[0.0, {}], [0.15, {"armF": 0.5, "armB": (-0.4), "r": (-5.0), "head": (-0.1)}], [0.22, {"armF": (-0.9), "armB": (-0.6), "r": 7.0, "x": J.mul(0.03, v_H_614), "head": 0.1}, "o"], [0.4, {"armF": (-0.5), "armB": (-0.4), "r": 4.0}], [0.59, {}]]])
	var _t236 = J.add(J.gp(v_f_618, "armF"), v_shake_617)
	J.sp(v_f_618, "armF", _t236)
	v_m_619 = J.mc(v_N_610, "bm", [v_S_611, v_f_618])
	v_hand_620 = J.mc(v_N_610, "at", [v_S_611, v_m_619, J.gp(v_DC_616, 0.0), J.gp(v_DC_616, 1.0)])
	v_T_621 = J.mc(v_N_610, "tgt", [v_S_611, 0.8])
	v_C_622 = J.mc(v_N_610, "tgt", [v_S_611, 0.5])
	J.mc(J.G.get("N30M"), "begin", [v_ctx_608, v_S_611, J.gp(v_f_618, "x")])
	J.mc(v_N_610, "body", [v_ctx_608, v_S_611, v_m_619, J.mc(v_N_610, "pose", [v_S_611, v_f_618, 0.3]), v_key_612])
	v_dx_623 = J.gp(v_hand_620, 0.0)
	v_dy_624 = J.gp(v_hand_620, 1.0)
	v_dr_625 = J.mul(v_shake_617, 60.0)
	v_ds_626 = 1.0
	var _t237 = J.cmp(v_t_613, 0.18, ">=")
	if (J.cmp(v_t_613, J.gp(v_N_610, "TC"), "<") if _t237 else _t237):
		v_q_629 = J.mc(v_N_610, "seg", [v_t_613, 0.18, J.gp(v_N_610, "TC")])
		var _t238 = J.mc(v_N_610, "lerp", [J.gp(v_hand_620, 0.0), J.gp(v_T_621, 0.0), v_q_629])
		v_dx_623 = _t238
		var _t239 = J.sub(J.mc(v_N_610, "lerp", [J.gp(v_hand_620, 1.0), J.gp(v_T_621, 1.0), v_q_629]), (J.mul((J.mul(0.2, v_H_614) * 4.0), v_q_629) * J.sub(1.0, v_q_629)))
		v_dy_624 = _t239
		var _t240 = J.mul(v_q_629, 720.0)
		v_dr_625 = _t240
	else:
		var _t241 = J.cmp(v_t_613, J.gp(v_N_610, "TC"), ">=")
		if (J.cmp(v_t_613, 0.45, "<") if _t241 else _t241):
			v_q_630 = J.mc(v_N_610, "seg", [v_t_613, J.gp(v_N_610, "TC"), 0.45])
			var _t242 = J.add(J.gp(v_T_621, 0.0), J.mul(J.mul(v_q_630, 0.3), v_th_615))
			v_dx_623 = _t242
			var _t243 = (J.sub(J.gp(v_T_621, 1.0), (J.mul(0.4, v_th_615) * sin(J.num(J.mul(v_q_630, PI))))) + J.mul((J.mul(v_q_630, v_q_630) * 0.8), v_th_615))
			v_dy_624 = _t243
			var _t244 = (720.0 + J.mul(v_q_630, 500.0))
			v_dr_625 = _t244
			var _t245 = J.sub(1.0, v_q_630)
			v_ds_626 = _t245
		else:
			if J.cmp(v_t_613, 0.45, ">="):
				var _t246 = J.gp(v_N_610, "E")
				var _t247 = J.mc(_t246, "back", [J.mc(v_N_610, "seg", [v_t_613, 0.47, 0.57])])
				v_ds_626 = _t247
	if J.cmp(v_ds_626, 0.02, ">"):
		J.mc(v_N_610, "pieceAt", [v_ctx_608, v_S_611, "dice", v_dx_623, v_dy_624, v_dr_625, J.gp(v_DC_616, 0.0), J.gp(v_DC_616, 1.0), v_ds_626])
	v_cardO_627 = J.mc(v_N_610, "at", [v_S_611, v_m_619, 0.83, 0.42])
	v_i_631 = 0.0
	while true:
		if not J.cmp(v_i_631, 3.0, "<"): break
		v_st_632 = (0.2 + J.mul(v_i_631, 0.015))
		v_q_633 = J.mc(v_N_610, "seg", [v_t_613, v_st_632, J.add(J.gp(v_N_610, "TC"), 0.01)])
		if J.cmp(v_q_633, 0.0, "<="):
			v_i_631 = J.num(v_i_631) + 1.0
			continue
		v_stick_634 = J.cmp(v_t_613, J.add(J.gp(v_N_610, "TC"), 0.01), ">")
		v_tx2_635 = J.sub(J.gp(v_C_622, 0.0), J.mul(0.05, v_th_615))
		v_ty2_636 = J.add(J.gp(v_C_622, 1.0), J.mul((J.sub(v_i_631, 1.0) * 0.15), v_th_615))
		v_x_637 = (J.add(v_tx2_635, J.mul(J.gp(v_S_611, "back"), 0.0)) if J.t(v_stick_634) else J.mc(v_N_610, "lerp", [J.gp(v_cardO_627, 0.0), v_tx2_635, v_q_633]))
		v_y_638 = (v_ty2_636 if J.t(v_stick_634) else J.sub(J.mc(v_N_610, "lerp", [J.gp(v_cardO_627, 1.0), v_ty2_636, v_q_633]), (J.mul(0.1, v_H_614) * sin(J.num(J.mul(v_q_633, PI))))))
		v_al_639 = J.sub(1.0, J.mc(v_N_610, "seg", [v_t_613, 0.45, 0.55]))
		if J.cmp(v_al_639, 0.0, "<="):
			v_i_631 = J.num(v_i_631) + 1.0
			continue
		J.mc(v_ctx_608, "save", [])
		var _t248 = J.mul(J.gp(v_ctx_608, "globalAlpha"), v_al_639)
		J.sp(v_ctx_608, "globalAlpha", _t248)
		J.mc(v_ctx_608, "translate", [v_x_637, v_y_638])
		J.mc(v_ctx_608, "rotate", [((0.5 + J.mul(v_i_631, 0.3)) if J.t(v_stick_634) else J.add(J.mul(v_q_633, 20.0), v_i_631))])
		v_w_640 = J.mul(0.07, v_H_614)
		v_h_641 = J.mul(0.1, v_H_614)
		J.sp(v_ctx_608, "fillStyle", "#fbf6ea")
		J.sp(v_ctx_608, "strokeStyle", "#3a2a2a")
		var _t249 = J.mul(v_w_640, 0.1)
		J.sp(v_ctx_608, "lineWidth", _t249)
		J.mc(v_ctx_608, "beginPath", [])
		J.mc(v_ctx_608, "roundRect", [J.div((-J.num(v_w_640)), 2.0), J.div((-J.num(v_h_641)), 2.0), v_w_640, v_h_641, J.mul(v_w_640, 0.15)])
		J.mc(v_ctx_608, "fill", [])
		J.mc(v_ctx_608, "stroke", [])
		var _t250 = ("#222" if J.seq(v_i_631, 1.0) else "#c8202a")
		J.sp(v_ctx_608, "fillStyle", _t250)
		var _t251 = ("900 " + J.str(J.mul(v_h_641, 0.55)) + "px sans-serif")
		J.sp(v_ctx_608, "font", _t251)
		J.sp(v_ctx_608, "textAlign", "center")
		J.sp(v_ctx_608, "textBaseline", "middle")
		J.mc(v_ctx_608, "fillText", [("♠" if J.seq(v_i_631, 1.0) else "♥"), 0.0, 0.0])
		J.mc(v_ctx_608, "restore", [])
		v_i_631 = J.num(v_i_631) + 1.0
	v_p_628 = J.sub(v_t_613, J.gp(v_N_610, "TC"))
	var _t252 = J.cmp(v_p_628, 0.0, ">=")
	if (J.cmp(v_p_628, 0.13, "<") if _t252 else _t252):
		J.mc(v_N_610, "burst", [v_ctx_608, J.gp(v_T_621, 0.0), J.gp(v_T_621, 1.0), J.mul(0.3, v_th_615), (1.0 - J.div(v_p_628, 0.13)), "#fff0b0", 151.0, 9.0])
	J.mc(v_N_610, "pop", [v_ctx_608, v_S_611, J.gp(v_T_621, 0.0), J.sub(J.gp(v_T_621, 1.0), J.mul(0.35, v_th_615)), "梭哈！", J.mul(0.22, v_th_615), "#ffd84a", J.gp(v_N_610, "TC"), 0.32])
	J.mc(v_N_610, "hit", [v_S_611, J.gp(v_T_621, 0.0), J.gp(v_T_621, 1.0)])
	J.mc(J.G.get("N30M"), "end", [v_ctx_608])

func _f52(this_, a: Array, env):
	var v_ctx_644 = null; var v_a_645 = null; var v_N_646 = null; var v_S_647 = null; var v_t_648 = null; var v_H_649 = null; var v_th_650 = null; var v_D2_651 = null; var v_f_652 = null; var v_T_653 = null; var v_p_654 = null; var v_m_655 = null; var v_mo_656 = null; var v_i_657 = null; var v_an_658 = null; var v_sp_659 = null; var v_px_660 = null; var v_py_661 = null; var v_i_662 = null; var v_q_663 = null
	v_ctx_644 = J.arg(a, 0)
	v_a_645 = J.arg(a, 1)
	v_N_646 = J.G.get("N30K")
	v_S_647 = J.mc(v_N_646, "setup", [v_a_645])
	if (not J.t(v_S_647)):
		return false
	v_t_648 = J.gp(v_S_647, "tt")
	v_H_649 = J.gp(v_S_647, "H")
	v_th_650 = J.gp(v_S_647, "th")
	v_D2_651 = J.max_([0.0, (J.sub(J.gp(v_S_647, "tx"), J.mul(0.55, v_th_650)) - J.mul(0.25, v_H_649))])
	v_f_652 = J.mc(v_N_646, "kf", [v_t_648, [[0.0, {}], [0.16, {"r": (-16.0), "x": J.mul((-0.04), v_H_649), "y": J.mul((-0.03), v_H_649), "armF": (-0.4), "armB": (-0.4), "head": (-0.15)}], [J.gp(v_N_646, "TC"), {"r": 28.0, "x": v_D2_651, "y": J.mul((-0.02), v_H_649), "armF": (-0.6), "armB": (-0.6), "head": 0.15, "sy": 0.95}, "i"], [0.33, {"r": 22.0, "x": v_D2_651, "armF": (-0.5), "armB": (-0.5)}], [0.4, {"r": (-8.0), "x": J.mul(v_D2_651, 0.7)}], [0.47, {"r": 10.0, "x": J.mul(v_D2_651, 0.4)}], [0.53, {"r": (-6.0), "x": J.mul(v_D2_651, 0.15)}], [0.59, {}]]])
	J.mc(J.G.get("N30M"), "begin", [v_ctx_644, v_S_647, J.gp(v_f_652, "x")])
	J.mc(v_N_646, "whole", [v_ctx_644, v_S_647, v_f_652, null, 0.3])
	v_T_653 = J.mc(v_N_646, "tgt", [v_S_647, 0.82])
	v_p_654 = J.sub(v_t_648, J.gp(v_N_646, "TC"))
	var _t255 = J.cmp(v_p_654, 0.0, ">=")
	if (J.cmp(v_p_654, 0.35, "<") if _t255 else _t255):
		v_i_657 = 0.0
		while true:
			if not J.cmp(v_i_657, 14.0, "<"): break
			v_an_658 = ((-PI) * (0.1 + J.mul(0.8, J.mc(v_N_646, "rnd", [v_i_657]))))
			v_sp_659 = J.mul(J.mul(J.add(0.5, J.mc(v_N_646, "rnd", [J.add(v_i_657, 4.0)])), 1.4), v_th_650)
			v_px_660 = J.add(J.gp(v_T_653, 0.0), J.mul(J.mul(cos(J.num(v_an_658)), v_sp_659), v_p_654))
			v_py_661 = J.add(J.add(J.gp(v_T_653, 1.0), J.mul(J.mul(sin(J.num(v_an_658)), v_sp_659), v_p_654)), J.mul(J.mul(J.mul(3.0, v_th_650), v_p_654), v_p_654))
			J.mc(v_ctx_644, "save", [])
			var _t256 = J.mul(J.gp(v_ctx_644, "globalAlpha"), (1.0 - J.div(v_p_654, 0.35)))
			J.sp(v_ctx_644, "globalAlpha", _t256)
			var _t257 = ("rgba(170,60,90,.85)" if J.t(J.mod(v_i_657, 3.0)) else "rgba(240,220,160,.9)")
			J.sp(v_ctx_644, "fillStyle", _t257)
			J.mc(v_ctx_644, "beginPath", [])
			J.mc(v_ctx_644, "ellipse", [v_px_660, v_py_661, J.mul(0.025, v_th_650), J.mul(0.035, v_th_650), v_an_658, 0.0, 7.0])
			J.mc(v_ctx_644, "fill", [])
			J.mc(v_ctx_644, "restore", [])
			v_i_657 = J.num(v_i_657) + 1.0
	var _t258 = J.cmp(v_p_654, 0.0, ">=")
	if (J.cmp(v_p_654, 0.13, "<") if _t258 else _t258):
		J.mc(v_N_646, "burst", [v_ctx_644, J.gp(v_T_653, 0.0), J.gp(v_T_653, 1.0), J.mul(0.34, v_th_650), (1.0 - J.div(v_p_654, 0.13)), "#ffe0f0", 161.0, 10.0])
	J.mc(v_N_646, "pop", [v_ctx_644, v_S_647, J.sub(J.gp(v_T_653, 0.0), J.mul(0.2, v_th_650)), J.sub(J.gp(v_T_653, 1.0), J.mul(0.35, v_th_650)), "嗝～", J.mul(0.24, v_th_650), "#ffb0c8", J.add(J.gp(v_N_646, "TC"), 0.02), 0.36])
	v_m_655 = J.mc(v_N_646, "bm", [v_S_647, v_f_652])
	v_mo_656 = J.mc(v_N_646, "at", [v_S_647, v_m_655, 0.3, 0.3])
	v_i_662 = 0.0
	while true:
		if not J.cmp(v_i_662, 3.0, "<"): break
		v_q_663 = J.mc(v_N_646, "seg", [v_t_648, (0.3 + J.mul(v_i_662, 0.06)), 0.59])
		var _t259 = J.cmp(v_q_663, 0.0, ">")
		if (J.cmp(v_q_663, 1.0, "<") if _t259 else _t259):
			J.mc(v_N_646, "ring", [v_ctx_644, J.add(J.gp(v_mo_656, 0.0), J.mul(J.mul(v_i_662, 0.03), v_H_649)), J.sub(J.gp(v_mo_656, 1.0), J.mul(J.mul(v_q_663, 0.3), v_H_649)), (J.mul(0.025, v_H_649) * (1.0 + J.mul(v_i_662, 0.3))), (J.mul(0.025, v_H_649) * (1.0 + J.mul(v_i_662, 0.3))), "rgba(200,220,255,.8)", J.mul(0.008, v_H_649), J.sub(1.0, v_q_663)])
		v_i_662 = J.num(v_i_662) + 1.0
	J.mc(v_N_646, "hit", [v_S_647, J.gp(v_T_653, 0.0), J.gp(v_T_653, 1.0)])
	J.mc(J.G.get("N30M"), "end", [v_ctx_644])

func _f53(this_, a: Array, env):
	var v_ctx_666 = null; var v_a_667 = null; var v_N_668 = null; var v_S_669 = null; var v_t_670 = null; var v_H_671 = null; var v_th_672 = null; var v_f_673 = null; var v_m_674 = null; var v_mo_675 = null; var v_T_676 = null; var v_q_677 = null; var v_x_678 = null; var v_y_679 = null; var v_shrink_680 = null; var v_rr_681 = null; var v_al_682 = null
	v_ctx_666 = J.arg(a, 0)
	v_a_667 = J.arg(a, 1)
	v_N_668 = J.G.get("N30K")
	v_S_669 = J.mc(v_N_668, "setup", [v_a_667])
	if (not J.t(v_S_669)):
		return false
	v_t_670 = J.gp(v_S_669, "tt")
	v_H_671 = J.gp(v_S_669, "H")
	v_th_672 = J.gp(v_S_669, "th")
	v_f_673 = J.mc(v_N_668, "kf", [v_t_670, [[0.0, {}], [0.16, {"armB": (-0.35), "armF": (-0.2), "sy": 1.05, "sx": 1.04, "head": (-0.12), "r": (-4.0)}], [0.22, {"armB": 0.1, "sy": 0.97, "head": 0.15, "r": 6.0, "x": J.mul(0.02, v_H_671)}, "o"], [0.4, {"r": 3.0}], [0.46, {"r": 9.0, "head": 0.25, "sy": 0.95}], [0.52, {"r": 2.0}], [0.56, {"r": 8.0, "head": 0.2}], [0.59, {}]]])
	v_m_674 = J.mc(v_N_668, "bm", [v_S_669, v_f_673])
	v_mo_675 = J.mc(v_N_668, "at", [v_S_669, v_m_674, 0.56, 0.36])
	v_T_676 = J.mc(v_N_668, "tgt", [v_S_669, 0.84])
	J.mc(J.G.get("N30M"), "begin", [v_ctx_666, v_S_669, J.gp(v_f_673, "x")])
	J.mc(v_N_668, "whole", [v_ctx_666, v_S_669, v_f_673, null, 0.3])
	v_q_677 = J.mc(v_N_668, "seg", [v_t_670, 0.2, J.gp(v_N_668, "TC")])
	if J.cmp(v_t_670, 0.2, ">"):
		var _t265 = null
		if J.cmp(v_t_670, J.gp(v_N_668, "TC"), "<"):
			var _t263 = J.gp(v_mo_675, 0.0)
			var _t264 = J.gp(v_T_676, 0.0)
			var _t262 = J.gp(v_N_668, "E")
			_t265 = J.mc(v_N_668, "lerp", [_t263, _t264, J.mc(_t262, "o", [v_q_677])])
		else:
			_t265 = J.add(J.gp(v_T_676, 0.0), J.mul(J.gp(v_S_669, "back"), 0.0))
		v_x_678 = _t265
		var _t269 = null
		if J.cmp(v_t_670, J.gp(v_N_668, "TC"), "<"):
			var _t267 = J.gp(v_mo_675, 1.0)
			var _t268 = J.gp(v_T_676, 1.0)
			var _t266 = J.gp(v_N_668, "E")
			_t269 = J.mc(v_N_668, "lerp", [_t267, _t268, J.mc(_t266, "o", [v_q_677])])
		else:
			_t269 = J.gp(v_T_676, 1.0)
		v_y_679 = _t269
		v_shrink_680 = (0.0 if J.cmp(v_t_670, J.gp(v_N_668, "TC"), "<") else J.mc(v_N_668, "seg", [v_t_670, J.gp(v_N_668, "TC"), 0.36]))
		v_rr_681 = J.mul(((0.06 + J.mul(0.12, v_q_677)) - J.mul(0.07, v_shrink_680)), v_H_671)
		v_al_682 = J.sub(1.0, J.mc(v_N_668, "seg", [v_t_670, 0.42, 0.59]))
		J.mc(v_N_668, "ring", [v_ctx_666, v_x_678, v_y_679, v_rr_681, J.mul(v_rr_681, 0.45), "rgba(210,210,220,.85)", J.mul(0.035, v_H_671), v_al_682])
		J.mc(v_N_668, "ring", [v_ctx_666, v_x_678, v_y_679, J.mul(v_rr_681, 0.92), J.mul(v_rr_681, 0.4), "rgba(255,255,255,.5)", J.mul(0.012, v_H_671), v_al_682])
		if J.cmp(v_t_670, J.gp(v_N_668, "TC"), "<"):
			J.mc(v_N_668, "puff", [v_ctx_666, J.sub(v_x_678, J.mul(0.12, v_H_671)), v_y_679, J.mul(0.05, v_H_671), v_q_677, "rgba(220,220,230,.6)", 171.0, 3.0])
	if J.cmp(v_t_670, 0.18, "<"):
		J.mc(v_N_668, "puff", [v_ctx_666, J.add(J.gp(v_mo_675, 0.0), J.mul(0.12, v_H_671)), J.sub(J.gp(v_mo_675, 1.0), J.mul(0.05, v_H_671)), J.mul(0.04, v_H_671), J.mc(v_N_668, "seg", [v_t_670, 0.02, 0.18]), "rgba(210,210,220,.5)", 172.0, 3.0])
	J.mc(v_N_668, "pop", [v_ctx_666, v_S_669, J.gp(v_T_676, 0.0), J.sub(J.gp(v_T_676, 1.0), J.mul(0.3, v_th_672)), "咳咳！", J.mul(0.2, v_th_672), "#e0e0ea", J.add(J.gp(v_N_668, "TC"), 0.02), 0.3])
	J.mc(v_N_668, "pop", [v_ctx_666, v_S_669, J.gp(v_mo_675, 0.0), J.sub(J.gp(v_mo_675, 1.0), J.mul(0.18, v_H_671)), "咳…", J.mul(0.12, v_H_671), "#cfcfd8", 0.44, 0.15])
	J.mc(v_N_668, "hit", [v_S_669, J.gp(v_T_676, 0.0), J.gp(v_T_676, 1.0)])
	J.mc(J.G.get("N30M"), "end", [v_ctx_666])

func _f54(this_, a: Array, env):
	var v_ctx_685 = null; var v_a_686 = null; var v_N_687 = null; var v_S_688 = null; var v_key_689 = null; var v_t_690 = null; var v_H_691 = null; var v_th_692 = null; var v_PV_693 = null; var v_f_694 = null; var v_m_695 = null; var v_w0_696 = null; var v_T_697 = null; var v_A_698 = null; var v_p_699 = null; var v_i_700 = null; var v_an_701 = null; var v_sp_702 = null; var v_px_703 = null; var v_py_704 = null
	v_ctx_685 = J.arg(a, 0)
	v_a_686 = J.arg(a, 1)
	v_N_687 = J.G.get("N30K")
	v_S_688 = J.mc(v_N_687, "setup", [v_a_686])
	if (not J.t(v_S_688)):
		return false
	v_key_689 = J.mc(J.G.get("N30"), "body", [J.gp(v_S_688, "id")])
	if (not J.t(v_key_689)):
		return false
	v_t_690 = J.gp(v_S_688, "tt")
	v_H_691 = J.gp(v_S_688, "H")
	v_th_692 = J.gp(v_S_688, "th")
	v_PV_693 = [0.74, 0.64]
	v_f_694 = J.mc(v_N_687, "kf", [v_t_690, [[0.0, {}], [0.16, {"r": (-7.0), "x": J.mul((-0.03), v_H_691), "head": (-0.12), "armF": 0.2, "orn": 0.3}], [J.gp(v_N_687, "TC"), {"r": 10.0, "x": J.mul(0.08, v_H_691), "head": 0.12, "orn": (-0.4)}, "i"], [0.36, {"r": 8.0, "x": J.mul(0.08, v_H_691)}], [0.59, {}]]])
	v_m_695 = J.mc(v_N_687, "bm", [v_S_688, v_f_694])
	v_w0_696 = J.mc(v_N_687, "at", [v_S_688, v_m_695, J.gp(v_PV_693, 0.0), J.gp(v_PV_693, 1.0)])
	v_T_697 = J.mc(v_N_687, "tgt", [v_S_688, 0.78])
	v_A_698 = J.mc(v_N_687, "kf", [v_t_690, [[0.0, {"x": J.gp(v_w0_696, 0.0), "y": J.gp(v_w0_696, 1.0), "r": 0.0}], [0.16, {"x": J.sub(J.gp(v_w0_696, 0.0), J.mul(0.02, v_H_691)), "y": J.sub(J.gp(v_w0_696, 1.0), J.mul(0.42, v_H_691)), "r": (-150.0)}], [J.gp(v_N_687, "TC"), {"x": J.sub(J.gp(v_T_697, 0.0), J.mul(0.28, v_H_691)), "y": J.add(J.gp(v_T_697, 1.0), J.mul(0.1, v_H_691)), "r": (-55.0)}, "i"], [0.33, {"x": J.sub(J.gp(v_T_697, 0.0), J.mul(0.26, v_H_691)), "y": J.add(J.gp(v_T_697, 1.0), J.mul(0.16, v_H_691)), "r": (-35.0)}], [0.45, {"x": J.add(J.gp(v_w0_696, 0.0), J.mul(0.05, v_H_691)), "y": J.sub(J.gp(v_w0_696, 1.0), J.mul(0.05, v_H_691)), "r": (-15.0)}], [0.59, {"x": J.gp(v_w0_696, 0.0), "y": J.gp(v_w0_696, 1.0), "r": 0.0}]]])
	J.mc(J.G.get("N30M"), "begin", [v_ctx_685, v_S_688, J.gp(v_f_694, "x")])
	J.mc(v_N_687, "body", [v_ctx_685, v_S_688, v_m_695, J.mc(v_N_687, "pose", [v_S_688, v_f_694, 0.3]), v_key_689])
	var _t272 = J.cmp(v_t_690, 0.18, ">")
	if (J.cmp(v_t_690, 0.29, "<") if _t272 else _t272):
		J.mc(v_N_687, "speed", [v_ctx_685, J.add(J.gp(v_A_698, "x"), J.mul(0.1, v_H_691)), J.sub(J.gp(v_A_698, "y"), J.mul(0.15, v_H_691)), 1.0, 0.8, J.mul(0.3, v_H_691), J.mul(0.15, v_H_691), J.mc(v_N_687, "seg", [v_t_690, 0.18, 0.22]), "rgba(255,240,200,.7)", 181.0, 4.0])
	J.mc(v_N_687, "pieceAt", [v_ctx_685, v_S_688, "abacus", J.gp(v_A_698, "x"), J.gp(v_A_698, "y"), J.gp(v_A_698, "r"), J.gp(v_PV_693, 0.0), J.gp(v_PV_693, 1.0)])
	v_p_699 = J.sub(v_t_690, J.gp(v_N_687, "TC"))
	var _t273 = J.cmp(v_p_699, 0.0, ">=")
	if (J.cmp(v_p_699, 0.35, "<") if _t273 else _t273):
		v_i_700 = 0.0
		while true:
			if not J.cmp(v_i_700, 10.0, "<"): break
			v_an_701 = J.mul((-PI), J.mc(v_N_687, "rnd", [J.add(v_i_700, 1.0)]))
			v_sp_702 = J.mul(J.mul(J.add(0.4, J.mc(v_N_687, "rnd", [J.add(v_i_700, 5.0)])), 1.3), v_th_692)
			v_px_703 = J.add(J.gp(v_T_697, 0.0), J.mul(J.mul(cos(J.num(v_an_701)), v_sp_702), v_p_699))
			v_py_704 = J.add(J.add(J.gp(v_T_697, 1.0), J.mul(J.mul(sin(J.num(v_an_701)), v_sp_702), v_p_699)), J.mul(J.mul(J.mul(3.0, v_th_692), v_p_699), v_p_699))
			J.mc(v_ctx_685, "save", [])
			var _t274 = J.mul(J.gp(v_ctx_685, "globalAlpha"), (1.0 - J.div(v_p_699, 0.35)))
			J.sp(v_ctx_685, "globalAlpha", _t274)
			J.sp(v_ctx_685, "fillStyle", "#e8b84a")
			J.sp(v_ctx_685, "strokeStyle", "#5a3a10")
			var _t275 = J.mul(0.008, v_th_692)
			J.sp(v_ctx_685, "lineWidth", _t275)
			J.mc(v_ctx_685, "beginPath", [])
			J.mc(v_ctx_685, "ellipse", [v_px_703, v_py_704, J.mul(0.03, v_th_692), J.mul(0.02, v_th_692), 0.0, 0.0, 7.0])
			J.mc(v_ctx_685, "fill", [])
			J.mc(v_ctx_685, "stroke", [])
			J.mc(v_ctx_685, "restore", [])
			v_i_700 = J.num(v_i_700) + 1.0
	var _t276 = J.cmp(v_p_699, 0.0, ">=")
	if (J.cmp(v_p_699, 0.13, "<") if _t276 else _t276):
		J.mc(v_N_687, "burst", [v_ctx_685, J.gp(v_T_697, 0.0), J.gp(v_T_697, 1.0), J.mul(0.32, v_th_692), (1.0 - J.div(v_p_699, 0.13)), "#fff0c0", 191.0, 10.0])
	J.mc(v_N_687, "pop", [v_ctx_685, v_S_688, J.gp(v_T_697, 0.0), J.sub(J.gp(v_T_697, 1.0), J.mul(0.35, v_th_692)), "計清楚！", J.mul(0.2, v_th_692), "#ffd27a", J.gp(v_N_687, "TC"), 0.32])
	J.mc(v_N_687, "hit", [v_S_688, J.gp(v_T_697, 0.0), J.gp(v_T_697, 1.0)])
	J.mc(J.G.get("N30M"), "end", [v_ctx_685])

func _f55(this_, a: Array, env):
	var v_ctx_707 = null; var v_a_708 = null; var v_N_709 = null; var v_S_710 = null; var v_key_711 = null; var v_t_712 = null; var v_H_713 = null; var v_th_714 = null; var v_PV_715 = null; var v_f_716 = null; var v_m_717 = null; var v_w0_718 = null; var v_T_719 = null; var v_B_720 = null; var v_mouth_721 = null; var v_q_722 = null; var v_p_723 = null; var v_i_724 = null; var v_k_725 = null; var v_x_726 = null; var v_y_727 = null; var v_al_728 = null; var v_C_729 = null; var v_i_730 = null; var v_an_731 = null; var v_d_732 = null; var v_i_733 = null; var v_x_734 = null; var v_l_735 = null
	v_ctx_707 = J.arg(a, 0)
	v_a_708 = J.arg(a, 1)
	v_N_709 = J.G.get("N30K")
	v_S_710 = J.mc(v_N_709, "setup", [v_a_708])
	if (not J.t(v_S_710)):
		return false
	v_key_711 = J.mc(J.G.get("N30"), "body", [J.gp(v_S_710, "id")])
	if (not J.t(v_key_711)):
		return false
	v_t_712 = J.gp(v_S_710, "tt")
	v_H_713 = J.gp(v_S_710, "H")
	v_th_714 = J.gp(v_S_710, "th")
	v_PV_715 = [0.8, 0.58]
	v_f_716 = J.mc(v_N_709, "kf", [v_t_712, [[0.0, {}], [0.16, {"r": (-6.0), "x": J.mul((-0.03), v_H_713), "armF": 0.3, "paper": 0.4, "head": (-0.1)}], [0.24, {"r": 8.0, "x": J.mul(0.05, v_H_713), "armF": (-0.3), "paper": (-0.5), "head": 0.12}, "o"], [0.4, {"r": 5.0, "x": J.mul(0.04, v_H_713), "paper": 0.3}], [0.59, {}]]])
	v_m_717 = J.mc(v_N_709, "bm", [v_S_710, v_f_716])
	v_w0_718 = J.mc(v_N_709, "at", [v_S_710, v_m_717, J.gp(v_PV_715, 0.0), J.gp(v_PV_715, 1.0)])
	v_T_719 = J.mc(v_N_709, "tgt", [v_S_710, 0.6])
	v_B_720 = J.mc(v_N_709, "kf", [v_t_712, [[0.0, {"x": J.gp(v_w0_718, 0.0), "y": J.gp(v_w0_718, 1.0), "r": 0.0}], [0.16, {"x": J.sub(J.gp(v_w0_718, 0.0), J.mul(0.12, v_H_713)), "y": J.add(J.gp(v_w0_718, 1.0), J.mul(0.02, v_H_713)), "r": 55.0}], [0.24, {"x": J.add(J.gp(v_w0_718, 0.0), J.mul(0.14, v_H_713)), "y": J.sub(J.gp(v_w0_718, 1.0), J.mul(0.12, v_H_713)), "r": (-120.0)}, "o"], [0.36, {"x": J.add(J.gp(v_w0_718, 0.0), J.mul(0.12, v_H_713)), "y": J.sub(J.gp(v_w0_718, 1.0), J.mul(0.1, v_H_713)), "r": (-110.0)}], [0.59, {"x": J.gp(v_w0_718, 0.0), "y": J.gp(v_w0_718, 1.0), "r": 0.0}]]])
	J.mc(J.G.get("N30M"), "begin", [v_ctx_707, v_S_710, J.gp(v_f_716, "x")])
	J.mc(v_N_709, "body", [v_ctx_707, v_S_710, v_m_717, J.mc(v_N_709, "pose", [v_S_710, v_f_716, 0.3]), v_key_711])
	J.mc(v_N_709, "pieceAt", [v_ctx_707, v_S_710, "bucket", J.gp(v_B_720, "x"), J.gp(v_B_720, "y"), J.gp(v_B_720, "r"), J.gp(v_PV_715, 0.0), J.gp(v_PV_715, 1.0)])
	v_mouth_721 = [J.add(J.gp(v_B_720, "x"), J.mul(0.15, v_H_713)), J.sub(J.gp(v_B_720, "y"), J.mul(0.15, v_H_713))]
	v_q_722 = J.mc(v_N_709, "seg", [v_t_712, 0.2, J.gp(v_N_709, "TC")])
	var _t279 = J.cmp(v_t_712, 0.2, ">")
	if (J.cmp(v_t_712, J.add(J.gp(v_N_709, "TC"), 0.02), "<") if _t279 else _t279):
		v_i_724 = 0.0
		while true:
			if not J.cmp(v_i_724, 9.0, "<"): break
			v_k_725 = J.mc(v_N_709, "cl", [J.sub(v_q_722, J.mul(v_i_724, 0.04))])
			v_x_726 = J.mc(v_N_709, "lerp", [J.gp(v_mouth_721, 0.0), J.gp(v_T_719, 0.0), v_k_725])
			v_y_727 = J.sub(J.mc(v_N_709, "lerp", [J.gp(v_mouth_721, 1.0), J.add(J.gp(v_T_719, 1.0), J.mul((J.sub(J.mc(v_N_709, "rnd", [v_i_724]), 0.5) * 0.4), v_th_714)), v_k_725]), (J.mul(0.15, v_H_713) * sin(J.num(J.mul(v_k_725, PI)))))
			J.sp(v_ctx_707, "fillStyle", "#c8141e")
			J.sp(v_ctx_707, "strokeStyle", "#4a0a0a")
			var _t280 = J.mul(0.006, v_H_713)
			J.sp(v_ctx_707, "lineWidth", _t280)
			J.mc(v_ctx_707, "beginPath", [])
			J.mc(v_ctx_707, "ellipse", [v_x_726, v_y_727, J.mul((0.035 + J.mul(J.mc(v_N_709, "rnd", [J.add(v_i_724, 3.0)]), 0.03)), v_H_713), J.mul(0.025, v_H_713), 0.3, 0.0, 7.0])
			J.mc(v_ctx_707, "fill", [])
			J.mc(v_ctx_707, "stroke", [])
			v_i_724 = J.num(v_i_724) + 1.0
	v_p_723 = J.sub(v_t_712, J.gp(v_N_709, "TC"))
	if J.cmp(v_p_723, 0.0, ">="):
		v_al_728 = J.sub(1.0, J.mc(v_N_709, "seg", [v_t_712, 0.5, 0.59]))
		J.mc(v_ctx_707, "save", [])
		var _t281 = J.mul(J.gp(v_ctx_707, "globalAlpha"), v_al_728)
		J.sp(v_ctx_707, "globalAlpha", _t281)
		v_C_729 = [J.add(J.gp(v_T_719, 0.0), J.mul(J.gp(v_S_710, "back"), 0.0)), J.gp(v_T_719, 1.0)]
		v_i_730 = 0.0
		while true:
			if not J.cmp(v_i_730, 7.0, "<"): break
			v_an_731 = J.mul(J.mc(v_N_709, "rnd", [J.add(v_i_730, 11.0)]), 6.28)
			v_d_732 = J.mul(J.mul(J.mc(v_N_709, "rnd", [J.add(v_i_730, 13.0)]), 0.22), v_th_714)
			J.sp(v_ctx_707, "fillStyle", "#c8141e")
			J.mc(v_ctx_707, "beginPath", [])
			J.mc(v_ctx_707, "ellipse", [J.add(J.gp(v_C_729, 0.0), J.mul(cos(J.num(v_an_731)), v_d_732)), J.add(J.gp(v_C_729, 1.0), (J.mul(sin(J.num(v_an_731)), v_d_732) * 1.4)), J.mul(J.mul(0.07, v_th_714), J.add(0.6, J.mc(v_N_709, "rnd", [v_i_730]))), J.mul(0.05, v_th_714), v_an_731, 0.0, 7.0])
			J.mc(v_ctx_707, "fill", [])
			v_i_730 = J.num(v_i_730) + 1.0
		v_i_733 = 0.0
		while true:
			if not J.cmp(v_i_733, 4.0, "<"): break
			v_x_734 = J.add(J.gp(v_C_729, 0.0), J.mul((J.sub(v_i_733, 1.5) * 0.08), v_th_714))
			v_l_735 = J.mul(J.mul(J.mc(v_N_709, "cl", [J.mul(v_p_723, 4.0)]), (0.15 + J.mul(J.mc(v_N_709, "rnd", [J.add(v_i_733, 20.0)]), 0.2))), v_th_714)
			J.mc(v_N_709, "crayon", [v_ctx_707, [[v_x_734, J.gp(v_C_729, 1.0)], [v_x_734, J.add(J.gp(v_C_729, 1.0), v_l_735)]], "#b0101a", J.mul(0.025, v_th_714), J.add(200.0, v_i_733)])
			v_i_733 = J.num(v_i_733) + 1.0
		J.mc(v_ctx_707, "restore", [])
	var _t282 = J.cmp(v_p_723, 0.0, ">=")
	if (J.cmp(v_p_723, 0.12, "<") if _t282 else _t282):
		J.mc(v_N_709, "burst", [v_ctx_707, J.gp(v_T_719, 0.0), J.gp(v_T_719, 1.0), J.mul(0.3, v_th_714), (1.0 - J.div(v_p_723, 0.12)), "#ffb0a0", 201.0, 9.0])
	J.mc(v_N_709, "pop", [v_ctx_707, v_S_710, J.gp(v_T_719, 0.0), J.sub(J.gp(v_T_719, 1.0), J.mul(0.6, v_th_714)), "還錢！", J.mul(0.3, v_th_714), "#ff3a3a", J.gp(v_N_709, "TC"), 0.32])
	J.mc(v_N_709, "hit", [v_S_710, J.gp(v_T_719, 0.0), J.gp(v_T_719, 1.0)])
	J.mc(J.G.get("N30M"), "end", [v_ctx_707])

func _f56(this_, a: Array, env):
	var v_ctx_738 = null; var v_a_739 = null; var v_N_740 = null; var v_S_741 = null; var v_t_742 = null; var v_H_743 = null; var v_th_744 = null; var v_D2_745 = null; var v_sh_746 = null; var v_flail_747 = null; var v_f_748 = null; var v_m_749 = null; var v_hd_750 = null; var v_T_751 = null; var v_p_752 = null
	v_ctx_738 = J.arg(a, 0)
	v_a_739 = J.arg(a, 1)
	v_N_740 = J.G.get("N30K")
	v_S_741 = J.mc(v_N_740, "setup", [v_a_739])
	if (not J.t(v_S_741)):
		return false
	v_t_742 = J.gp(v_S_741, "tt")
	v_H_743 = J.gp(v_S_741, "H")
	v_th_744 = J.gp(v_S_741, "th")
	v_D2_745 = J.max_([0.0, (J.sub(J.gp(v_S_741, "tx"), J.mul(0.42, v_th_744)) - J.mul(0.25, v_H_743))])
	v_sh_746 = J.mul((sin(J.num(J.mul(v_t_742, 60.0))) * 0.006), v_H_743)
	var _t285 = J.cmp(v_t_742, 0.15, ">")
	v_flail_747 = (J.mul(v_t_742, 55.0) if (J.cmp(v_t_742, 0.38, "<") if _t285 else _t285) else 0.0)
	v_f_748 = J.mc(v_N_740, "kf", [v_t_742, [[0.0, {}], [0.14, {"sy": 0.88, "sx": 1.05, "head": (-0.15), "r": (-4.0)}], [J.gp(v_N_740, "TC"), {"x": v_D2_745, "sy": 1.02, "r": 10.0, "head": 0.1}, "i"], [0.34, {"x": v_D2_745, "r": 8.0}], [0.42, {"x": J.mul(v_D2_745, 0.3), "y": J.mul((-0.08), v_H_743), "r": (-12.0), "sy": 0.9}, "o"], [0.59, {}]]])
	var _t286 = J.gp(v_f_748, "x")
	var _t287 = J.add((_t286 if J.t(_t286) else 0.0), v_sh_746)
	J.sp(v_f_748, "x", _t287)
	if J.t(v_flail_747):
		var _t288 = (sin(J.num(v_flail_747)) * 1.3)
		J.sp(v_f_748, "armF", _t288)
		var _t289 = (sin(J.num(J.add(v_flail_747, 3.1))) * 1.3)
		J.sp(v_f_748, "armB", _t289)
	else:
		if J.cmp(v_t_742, 0.15, "<"):
			J.sp(v_f_748, "armF", 0.0)
			J.sp(v_f_748, "armB", 0.0)
	J.mc(J.G.get("N30M"), "begin", [v_ctx_738, v_S_741, J.gp(v_f_748, "x")])
	J.mc(v_N_740, "whole", [v_ctx_738, v_S_741, v_f_748, null, 0.2])
	v_m_749 = J.mc(v_N_740, "bm", [v_S_741, v_f_748])
	v_hd_750 = J.mc(v_N_740, "at", [v_S_741, v_m_749, 0.5, 0.2])
	v_T_751 = J.mc(v_N_740, "tgt", [v_S_741, 0.6])
	var _t290 = J.cmp(v_t_742, 0.1, ">")
	if (J.cmp(v_t_742, 0.45, "<") if _t290 else _t290):
		J.mc(v_N_740, "drops", [v_ctx_738, J.gp(v_hd_750, 0.0), J.gp(v_hd_750, 1.0), J.mul(0.3, v_H_743), J.mod(J.mul(v_t_742, 4.0), 1.0), "rgba(150,210,255,.9)", (floor(J.num(J.mul(v_t_742, 4.0))) * 5.0), 4.0])
	J.mc(v_N_740, "pop", [v_ctx_738, v_S_741, J.gp(v_hd_750, 0.0), J.sub(J.gp(v_hd_750, 1.0), J.mul(0.3, v_H_743)), "哇啊啊！", J.mul(0.13, v_H_743), "#bfe0ff", 0.12, 0.3])
	v_p_752 = J.sub(v_t_742, J.gp(v_N_740, "TC"))
	var _t291 = J.cmp(v_p_752, 0.0, ">=")
	if (J.cmp(v_p_752, 0.13, "<") if _t291 else _t291):
		J.mc(v_N_740, "burst", [v_ctx_738, J.gp(v_T_751, 0.0), J.gp(v_T_751, 1.0), J.mul(0.3, v_th_744), (1.0 - J.div(v_p_752, 0.13)), "#e0f0ff", 211.0, 9.0])
	J.mc(v_N_740, "pop", [v_ctx_738, v_S_741, J.gp(v_T_751, 0.0), J.sub(J.gp(v_T_751, 1.0), J.mul(0.4, v_th_744)), "咦？中咗？", J.mul(0.16, v_th_744), "#ffffff", J.add(J.gp(v_N_740, "TC"), 0.03), 0.3])
	J.mc(v_N_740, "hit", [v_S_741, J.gp(v_T_751, 0.0), J.gp(v_T_751, 1.0)])
	J.mc(J.G.get("N30M"), "end", [v_ctx_738])

func _f57(this_, a: Array, env):
	var v_ctx_755 = null; var v_a_756 = null; var v_N_757 = null; var v_S_758 = null; var v_t_759 = null; var v_H_760 = null; var v_th_761 = null; var v_D2_762 = null; var v_f_763 = null; var v_T_764 = null; var v_p_765 = null; var v_i_766 = null
	v_ctx_755 = J.arg(a, 0)
	v_a_756 = J.arg(a, 1)
	v_N_757 = J.G.get("N30K")
	v_S_758 = J.mc(v_N_757, "setup", [v_a_756])
	if (not J.t(v_S_758)):
		return false
	v_t_759 = J.gp(v_S_758, "tt")
	v_H_760 = J.gp(v_S_758, "H")
	v_th_761 = J.gp(v_S_758, "th")
	v_D2_762 = (J.sub(J.gp(v_S_758, "tx"), J.mul(0.12, v_th_761)) - (J.mul(0.8, v_H_760) * sin(J.num(J.mul(70.0, J.gp(v_N_757, "D"))))))
	v_f_763 = J.mc(v_N_757, "kf", [v_t_759, [[0.0, {}], [0.12, {"x": J.mul(0.03, v_H_760), "r": (-10.0), "armF": 0.4, "armB": (-0.6), "head": (-0.15)}], [0.18, {"x": J.mul(0.06, v_H_760), "r": 25.0, "armF": (-1.0), "armB": (-0.9), "head": 0.1}], [J.gp(v_N_757, "TC"), {"x": v_D2_762, "r": 70.0, "px": 0.0, "py": 0.0, "y": J.mul((-0.02), v_H_760), "armF": (-1.2), "armB": (-1.1), "legF": (-0.3), "legB": 0.4, "head": 0.2}, "i"], [0.36, {"x": J.add(v_D2_762, J.mul(0.02, v_H_760)), "r": 74.0, "px": 0.0, "py": 0.0, "armF": (-1.1), "armB": (-1.0), "head": 0.2}], [0.46, {"x": J.mul(v_D2_762, 0.4), "y": J.mul((-0.15), v_H_760), "r": 20.0, "sy": 1.05}, "o"], [0.59, {}]]])
	J.sp(v_f_763, "px", 0.0)
	J.sp(v_f_763, "py", 0.0)
	J.mc(J.G.get("N30M"), "begin", [v_ctx_755, v_S_758, J.gp(v_f_763, "x")])
	J.mc(v_N_757, "whole", [v_ctx_755, v_S_758, v_f_763, null, 0.2])
	v_T_764 = J.mc(v_N_757, "tgt", [v_S_758, 0.5])
	v_p_765 = J.sub(v_t_759, J.gp(v_N_757, "TC"))
	J.mc(v_N_757, "pop", [v_ctx_755, v_S_758, J.mul(0.15, v_H_760), J.mul((-0.95), v_H_760), "哎！", J.mul(0.12, v_H_760), "#ffe066", 0.1, 0.18])
	var _t294 = J.cmp(v_t_759, 0.18, ">")
	if (J.cmp(v_t_759, J.gp(v_N_757, "TC"), "<") if _t294 else _t294):
		v_i_766 = 0.0
		while true:
			if not J.cmp(v_i_766, 3.0, "<"): break
			var _t295 = J.gp(v_f_763, "x")
			J.mc(v_N_757, "puff", [v_ctx_755, J.sub(J.add((_t295 if J.t(_t295) else 0.0), J.mul(0.2, v_H_760)), J.mul(J.mul(v_i_766, 0.12), v_H_760)), J.mul((-0.03), v_H_760), J.mul(0.05, v_H_760), J.mc(v_N_757, "seg", [v_t_759, (0.18 + J.mul(v_i_766, 0.02)), 0.4]), "rgba(200,190,170,.55)", J.add(220.0, v_i_766), 3.0])
			v_i_766 = J.num(v_i_766) + 1.0
	var _t296 = J.cmp(v_p_765, 0.0, ">=")
	if (J.cmp(v_p_765, 0.13, "<") if _t296 else _t296):
		J.mc(v_N_757, "burst", [v_ctx_755, J.gp(v_T_764, 0.0), J.gp(v_T_764, 1.0), J.mul(0.32, v_th_761), (1.0 - J.div(v_p_765, 0.13)), "#fff4c0", 221.0, 10.0])
	var _t297 = J.cmp(v_t_759, J.gp(v_N_757, "TC"), ">")
	if (J.cmp(v_t_759, 0.5, "<") if _t297 else _t297):
		J.mc(v_N_757, "stars", [v_ctx_755, J.sub(J.gp(v_T_764, 0.0), J.mul(0.1, v_th_761)), J.mul((-0.35), v_H_760), J.mul(0.15, v_H_760), v_t_759, J.sub(1.0, J.mc(v_N_757, "seg", [v_t_759, 0.44, 0.5]))])
	J.mc(v_N_757, "pop", [v_ctx_755, v_S_758, J.gp(v_T_764, 0.0), J.sub(J.gp(v_T_764, 1.0), J.mul(0.45, v_th_761)), "咚！", J.mul(0.24, v_th_761), "#ffe066", J.gp(v_N_757, "TC"), 0.3])
	J.mc(v_N_757, "hit", [v_S_758, J.gp(v_T_764, 0.0), J.gp(v_T_764, 1.0)])
	J.mc(J.G.get("N30M"), "end", [v_ctx_755])

func _f58(this_, a: Array, env):
	var v_ctx_769 = null; var v_a_770 = null; var v_N_771 = null; var v_S_772 = null; var v_t_773 = null; var v_H_774 = null; var v_th_775 = null; var v_D2_776 = null; var v_f_777 = null; var v_aura_778 = null; var v_T_779 = null; var v_p_780 = null; var v_g_781 = null; var v_k_782 = null; var v_i_783 = null
	v_ctx_769 = J.arg(a, 0)
	v_a_770 = J.arg(a, 1)
	v_N_771 = J.G.get("N30K")
	v_S_772 = J.mc(v_N_771, "setup", [v_a_770])
	if (not J.t(v_S_772)):
		return false
	v_t_773 = J.gp(v_S_772, "tt")
	v_H_774 = J.gp(v_S_772, "H")
	v_th_775 = J.gp(v_S_772, "th")
	v_D2_776 = J.max_([0.0, (J.sub(J.gp(v_S_772, "tx"), J.mul(0.4, v_th_775)) - J.mul(0.3, v_H_774))])
	v_f_777 = J.mc(v_N_771, "kf", [v_t_773, [[0.0, {}], [0.18, {"sy": 1.22, "sx": 1.1, "armF": (-1.0), "armB": (-0.7), "head": (-0.15), "hairL": 0.3, "hairR": 0.3, "r": (-4.0)}], [J.gp(v_N_771, "TC"), {"sy": 1.05, "sx": 1.12, "x": v_D2_776, "r": 22.0, "armF": (-0.3), "armB": (-0.2), "head": 0.2, "hairL": (-0.4), "hairR": (-0.4)}, "i"], [0.36, {"sy": 1.0, "sx": 1.1, "x": v_D2_776, "r": 20.0, "armF": (-0.25), "armB": (-0.15)}], [0.59, {}]]])
	v_aura_778 = J.gp(J.mc(v_N_771, "kf", [v_t_773, [[0.0, {"v": 0.0}], [0.18, {"v": 1.0}], [0.4, {"v": 0.8}], [0.59, {"v": 0.0}]]]), "v")
	J.mc(J.G.get("N30M"), "begin", [v_ctx_769, v_S_772, J.gp(v_f_777, "x"), (1.0 + J.mul(v_aura_778, 0.6))])
	if J.cmp(v_aura_778, 0.0, ">"):
		var _t300 = J.gp(v_f_777, "x")
		var _t302 = (_t300 if J.t(_t300) else 0.0)
		var _t303 = J.mul((-0.5), v_H_774)
		var _t301 = J.gp(v_f_777, "x")
		v_g_781 = J.mc(v_ctx_769, "createRadialGradient", [_t302, _t303, 0.0, (_t301 if J.t(_t301) else 0.0), J.mul((-0.5), v_H_774), J.mul(0.75, v_H_774)])
		J.mc(v_g_781, "addColorStop", [0.0, ("rgba(40,20,60," + J.str(J.mul(0.45, v_aura_778)) + ")")])
		J.mc(v_g_781, "addColorStop", [1.0, "rgba(40,20,60,0)"])
		J.sp(v_ctx_769, "fillStyle", v_g_781)
		var _t304 = J.gp(v_f_777, "x")
		J.mc(v_ctx_769, "fillRect", [J.sub((_t304 if J.t(_t304) else 0.0), J.mul(0.8, v_H_774)), J.mul((-1.3), v_H_774), J.mul(1.6, v_H_774), J.mul(1.4, v_H_774)])
	J.mc(v_N_771, "whole", [v_ctx_769, v_S_772, v_f_777, null, 0.3])
	v_T_779 = J.mc(v_N_771, "tgt", [v_S_772, 0.5])
	v_p_780 = J.sub(v_t_773, J.gp(v_N_771, "TC"))
	var _t305 = J.cmp(v_p_780, 0.0, ">=")
	if (J.cmp(v_p_780, 0.3, "<") if _t305 else _t305):
		v_k_782 = J.div(v_p_780, 0.3)
		J.mc(v_N_771, "ring", [v_ctx_769, J.gp(v_T_779, 0.0), J.gp(v_S_772, "ty"), J.mul((0.2 + J.mul(v_k_782, 0.8)), v_th_775), J.mul((0.06 + J.mul(v_k_782, 0.2)), v_th_775), "rgba(120,70,170,.9)", (J.mul(0.05, v_th_775) * J.sub(1.0, v_k_782)), J.sub(1.0, v_k_782)])
		J.mc(v_N_771, "ring", [v_ctx_769, J.gp(v_T_779, 0.0), J.gp(v_S_772, "ty"), J.mul((0.1 + J.mul(v_k_782, 0.5)), v_th_775), J.mul((0.03 + J.mul(v_k_782, 0.12)), v_th_775), "rgba(30,10,40,.9)", (J.mul(0.04, v_th_775) * J.sub(1.0, v_k_782)), J.sub(1.0, v_k_782)])
	v_i_783 = 0.0
	while true:
		if not J.cmp(v_i_783, 5.0, "<"): break
		J.mc(v_N_771, "puff", [v_ctx_769, J.add(J.gp(v_T_779, 0.0), J.mul((J.sub(v_i_783, 2.0) * 0.15), v_th_775)), J.sub(J.gp(v_S_772, "ty"), J.mul(0.1, v_th_775)), J.mul(0.08, v_th_775), J.mc(v_N_771, "seg", [v_t_773, J.add(J.gp(v_N_771, "TC"), J.mul(v_i_783, 0.01)), 0.5]), "rgba(60,30,80,.5)", J.add(230.0, v_i_783), 3.0])
		v_i_783 = J.num(v_i_783) + 1.0
	var _t306 = J.cmp(v_p_780, 0.0, ">=")
	if (J.cmp(v_p_780, 0.13, "<") if _t306 else _t306):
		J.mc(v_N_771, "burst", [v_ctx_769, J.gp(v_T_779, 0.0), J.sub(J.gp(v_T_779, 1.0), J.mul(0.2, v_th_775)), J.mul(0.4, v_th_775), (1.0 - J.div(v_p_780, 0.13)), "#c9a0ff", 231.0, 12.0])
	J.mc(v_N_771, "hit", [v_S_772, J.gp(v_T_779, 0.0), J.gp(v_T_779, 1.0)])
	J.mc(J.G.get("N30M"), "end", [v_ctx_769])

func _f60(this_, a: Array, env):
	var v_q_804 = null
	v_q_804 = J.arg(a, 0)
	return [J.gp(v_q_804, 0.0), J.sub(J.gp(v_q_804, 1.0), J.mul(0.012, env["H"]))]

func _f59(this_, a: Array, env):
	var v_ctx_786 = null; var v_a_787 = null; var v_N_788 = null; var v_S_789 = null; var v_key_790 = null; var v_t_791 = null; var v_th_793 = null; var v_PV_794 = null; var v_f_795 = null; var v_m_796 = null; var v_mouth_797 = null; var v_T_798 = null; var v_ho_799 = null; var v_goal_800 = null; var v_P_801 = null; var v_p_802 = null; var v_pts_803 = null; var v_sg_805 = null; var v_g_806 = null; var v_pts_807 = null; var v_j_808 = null
	var _s151 = {"__p": env, "H": null}
	v_ctx_786 = J.arg(a, 0)
	v_a_787 = J.arg(a, 1)
	v_N_788 = J.G.get("N30K")
	v_S_789 = J.mc(v_N_788, "setup", [v_a_787])
	if (not J.t(v_S_789)):
		return false
	v_key_790 = J.mc(J.G.get("N30"), "body", [J.gp(v_S_789, "id")])
	if (not J.t(v_key_790)):
		return false
	v_t_791 = J.gp(v_S_789, "tt")
	_s151["H"] = J.gp(v_S_789, "H")
	v_th_793 = J.gp(v_S_789, "th")
	v_PV_794 = [0.47, 0.565]
	v_f_795 = J.mc(v_N_788, "kf", [v_t_791, [[0.0, {}], [0.06, {"r": (-6.0)}], [0.12, {"r": 6.0}], [0.18, {"r": (-3.0)}], [0.24, {"r": 2.0}], [0.5, {"r": 0.0}], [0.54, {"y": J.mul((-0.06), _s151["H"]), "sy": 1.05}], [0.59, {}]]])
	v_m_796 = J.mc(v_N_788, "bm", [v_S_789, v_f_795])
	v_mouth_797 = J.mc(v_N_788, "at", [v_S_789, v_m_796, J.gp(v_PV_794, 0.0), J.gp(v_PV_794, 1.0)])
	v_T_798 = J.mc(v_N_788, "tgt", [v_S_789, 0.8])
	v_ho_799 = [J.mul(((1.0 if J.t(J.gp(v_S_789, "nr")) else (-1.0)) * J.sub(0.33, J.gp(v_PV_794, 0.0))), J.gp(v_S_789, "W")), J.mul(J.sub(0.2, J.gp(v_PV_794, 1.0)), J.gp(v_S_789, "H"))]
	v_goal_800 = [(J.sub(J.gp(v_T_798, 0.0), J.gp(v_ho_799, 0.0)) - J.mul(0.03, v_th_793)), J.sub(J.gp(v_T_798, 1.0), J.gp(v_ho_799, 1.0))]
	v_P_801 = J.mc(v_N_788, "kf", [v_t_791, [[0.0, {"x": J.gp(v_mouth_797, 0.0), "y": J.gp(v_mouth_797, 1.0), "r": 0.0, "s": 1.0}], [0.16, {"x": J.gp(v_mouth_797, 0.0), "y": J.add(J.gp(v_mouth_797, 1.0), J.mul(0.04, _s151["H"])), "r": (-8.0), "s": 0.82}], [J.gp(v_N_788, "TC"), {"x": J.gp(v_goal_800, 0.0), "y": J.gp(v_goal_800, 1.0), "r": 25.0, "s": 1.0}, "i"], [0.36, {"x": J.add(J.gp(v_goal_800, 0.0), J.mul(0.01, _s151["H"])), "y": J.add(J.gp(v_goal_800, 1.0), J.mul(0.02, _s151["H"])), "r": 30.0, "s": 1.0}], [0.52, {"x": J.gp(v_mouth_797, 0.0), "y": J.add(J.gp(v_mouth_797, 1.0), J.mul(0.02, _s151["H"])), "r": 0.0, "s": 0.8}, "i"], [0.59, {"x": J.gp(v_mouth_797, 0.0), "y": J.gp(v_mouth_797, 1.0), "r": 0.0, "s": 1.0}]]])
	J.mc(J.G.get("N30M"), "begin", [v_ctx_786, v_S_789, J.gp(v_f_795, "x")])
	var _t309 = J.cmp(v_t_791, 0.18, ">")
	if (J.cmp(v_t_791, 0.52, "<") if _t309 else _t309):
		v_pts_803 = J.mc(v_N_788, "quad", [v_mouth_797, [J.div(J.add(J.gp(v_mouth_797, 0.0), J.gp(v_P_801, "x")), 2.0), (J.min_([J.gp(v_mouth_797, 1.0), J.gp(v_P_801, "y")]) - J.mul(0.25, _s151["H"]))], [J.gp(v_P_801, "x"), J.add(J.gp(v_P_801, "y"), J.mul(0.02, _s151["H"]))], 10.0])
		J.mc(v_N_788, "crayon", [v_ctx_786, v_pts_803, "#8a1a24", J.mul(0.04, _s151["H"]), 241.0])
		J.mc(v_N_788, "crayon", [v_ctx_786, J.mc(v_pts_803, "map", [Callable(self, "_f60").bind(_s151)]), "#d04050", J.mul(0.015, _s151["H"]), 242.0])
	J.mc(v_N_788, "body", [v_ctx_786, v_S_789, v_m_796, J.mc(v_N_788, "pose", [v_S_789, v_f_795, 0.3]), v_key_790])
	J.mc(v_N_788, "pieceAt", [v_ctx_786, v_S_789, "spirit", J.gp(v_P_801, "x"), J.gp(v_P_801, "y"), J.gp(v_P_801, "r"), J.gp(v_PV_794, 0.0), J.gp(v_PV_794, 1.0), J.gp(v_P_801, "s"), ((2.0 - J.mul(J.gp(v_P_801, "s"), 0.9)) - 0.1)])
	var _t310 = J.cmp(v_t_791, 0.18, ">")
	if (J.cmp(v_t_791, J.gp(v_N_788, "TC"), "<") if _t310 else _t310):
		J.mc(v_N_788, "speed", [v_ctx_786, J.gp(v_P_801, "x"), J.sub(J.gp(v_P_801, "y"), J.mul(0.25, _s151["H"])), J.sub(J.gp(v_P_801, "x"), J.gp(v_mouth_797, 0.0)), J.sub(J.gp(v_P_801, "y"), J.gp(v_mouth_797, 1.0)), J.mul(0.3, _s151["H"]), J.mul(0.15, _s151["H"]), J.mc(v_N_788, "seg", [v_t_791, 0.18, 0.22]), "rgba(255,200,210,.7)", 243.0, 4.0])
	v_p_802 = J.sub(v_t_791, J.gp(v_N_788, "TC"))
	var _t311 = J.cmp(v_p_802, 0.0, ">=")
	if (J.cmp(v_p_802, 0.25, "<") if _t311 else _t311):
		for _t312 in J.iter([(-1.0), 1.0]):
			v_sg_805 = _t312
			v_g_806 = (J.mul(0.05, v_th_793) * (1.0 - J.min_([1.0, J.mul(v_p_802, 8.0)])))
			v_pts_807 = []
			v_j_808 = 0.0
			while true:
				if not J.cmp(v_j_808, 5.0, "<="): break
				J.mc(v_pts_807, "push", [[(J.sub(J.gp(v_T_798, 0.0), J.mul(0.1, v_th_793)) + J.mul(J.mul(v_j_808, 0.04), v_th_793)), J.add(J.gp(v_T_798, 1.0), J.mul(v_sg_805, J.add(v_g_806, (J.mul(0.02, v_th_793) if J.t(J.mod(v_j_808, 2.0)) else 0.0))))]])
				v_j_808 = J.num(v_j_808) + 1.0
			J.mc(v_N_788, "crayon", [v_ctx_786, v_pts_807, "#fffaf0", J.mul(0.02, v_th_793), J.add(245.0, v_sg_805), (1.0 - J.div(v_p_802, 0.25))])
	var _t313 = J.cmp(v_p_802, 0.0, ">=")
	if (J.cmp(v_p_802, 0.13, "<") if _t313 else _t313):
		J.mc(v_N_788, "burst", [v_ctx_786, J.gp(v_T_798, 0.0), J.gp(v_T_798, 1.0), J.mul(0.3, v_th_793), (1.0 - J.div(v_p_802, 0.13)), "#ffc0c8", 247.0, 9.0])
	J.mc(v_N_788, "pop", [v_ctx_786, v_S_789, J.gp(v_mouth_797, 0.0), J.sub(J.gp(v_mouth_797, 1.0), J.mul(0.15, _s151["H"])), "啵！", J.mul(0.12, _s151["H"]), "#ffd0d8", 0.52, 0.07])
	J.mc(v_N_788, "hit", [v_S_789, J.gp(v_T_798, 0.0), J.gp(v_T_798, 1.0)])
	J.mc(J.G.get("N30M"), "end", [v_ctx_786])

func _f61(this_, a: Array, env):
	var v_ctx_811 = null; var v_a_812 = null; var v_N_813 = null; var v_S_814 = null; var v_t_815 = null; var v_H_816 = null; var v_th_817 = null; var v_D2_818 = null; var v_f_819 = null; var v_T_820 = null; var v_p_821 = null
	v_ctx_811 = J.arg(a, 0)
	v_a_812 = J.arg(a, 1)
	v_N_813 = J.G.get("N30K")
	v_S_814 = J.mc(v_N_813, "setup", [v_a_812])
	if (not J.t(v_S_814)):
		return false
	v_t_815 = J.gp(v_S_814, "tt")
	v_H_816 = J.gp(v_S_814, "H")
	v_th_817 = J.gp(v_S_814, "th")
	v_D2_818 = J.max_([0.0, (J.sub(J.gp(v_S_814, "tx"), J.mul(0.25, v_th_817)) - J.mul(0.4, J.gp(v_S_814, "W")))])
	v_f_819 = J.mc(v_N_813, "kf", [v_t_815, [[0.0, {}], [0.14, {"sy": 0.82, "sx": 1.08, "legB": 0.35, "legF": 0.2, "hairL": 0.3, "hairR": 0.3, "r": 4.0}], [0.2, {"x": J.mul(v_D2_818, 0.55), "y": J.mul((-0.75), v_H_816), "sy": 1.1, "r": (-25.0), "legB": (-0.4), "legF": (-0.3)}, "o"], [J.gp(v_N_813, "TC"), {"x": v_D2_818, "y": J.mul((-0.45), v_th_817), "r": (-30.0), "legB": (-0.3), "legF": (-0.4), "head": 0.2}], [0.34, {"x": v_D2_818, "y": J.mul((-0.4), v_th_817), "r": (-25.0), "head": (-0.1)}], [0.42, {"x": J.mul(v_D2_818, 0.6), "y": J.mul((-0.3), v_H_816), "r": (-5.0)}, "o"], [0.48, {"x": J.mul(v_D2_818, 0.35), "y": 0.0, "sy": 0.9}, "i"], [0.54, {"x": J.mul(v_D2_818, 0.12), "y": J.mul((-0.2), v_H_816)}, "o"], [0.59, {}, "i"]]])
	var _t317 = J.gp(v_f_819, "x")
	var _t316 = J.gp(v_f_819, "y")
	J.mc(J.G.get("N30M"), "begin", [v_ctx_811, v_S_814, _t317, (1.0 - J.mul(J.mc(v_N_813, "cl", [J.div((-J.num((_t316 if J.t(_t316) else 0.0))), v_H_816)]), 0.6))])
	J.mc(v_N_813, "whole", [v_ctx_811, v_S_814, v_f_819, null, 0.3])
	v_T_820 = J.mc(v_N_813, "tgt", [v_S_814, 0.72])
	v_p_821 = J.sub(v_t_815, J.gp(v_N_813, "TC"))
	var _t318 = J.cmp(v_p_821, 0.0, ">=")
	if (J.cmp(v_p_821, 0.13, "<") if _t318 else _t318):
		J.mc(v_N_813, "burst", [v_ctx_811, J.gp(v_T_820, 0.0), J.gp(v_T_820, 1.0), J.mul(0.3, v_th_817), (1.0 - J.div(v_p_821, 0.13)), "#f0e0b0", 251.0, 9.0])
	J.mc(v_N_813, "pop", [v_ctx_811, v_S_814, J.gp(v_T_820, 0.0), J.sub(J.gp(v_T_820, 1.0), J.mul(0.35, v_th_817)), "喀！", J.mul(0.22, v_th_817), "#f0e0b0", J.gp(v_N_813, "TC"), 0.25])
	J.mc(v_N_813, "pop", [v_ctx_811, v_S_814, 0.0, J.mul((-1.1), v_H_816), "唧唧", J.mul(0.2, v_H_816), "#d8e8a0", 0.46, 0.13])
	J.mc(v_N_813, "hit", [v_S_814, J.gp(v_T_820, 0.0), J.gp(v_T_820, 1.0)])
	J.mc(J.G.get("N30M"), "end", [v_ctx_811])

func _f62(this_, a: Array, env):
	var v_ctx_824 = null; var v_a_825 = null; var v_N_826 = null; var v_S_827 = null; var v_t_828 = null; var v_H_829 = null; var v_th_830 = null; var v_D2_831 = null; var v_spin_832 = null; var v_sx_833 = null; var v_f_834 = null; var v_T_835 = null; var v_hd_836 = null; var v_p_837 = null; var v_i_838 = null; var v_k_839 = null; var v_pts_840 = null; var v_j_841 = null; var v_q_842 = null
	v_ctx_824 = J.arg(a, 0)
	v_a_825 = J.arg(a, 1)
	v_N_826 = J.G.get("N30K")
	v_S_827 = J.mc(v_N_826, "setup", [v_a_825])
	if (not J.t(v_S_827)):
		return false
	v_t_828 = J.gp(v_S_827, "tt")
	v_H_829 = J.gp(v_S_827, "H")
	v_th_830 = J.gp(v_S_827, "th")
	v_D2_831 = J.max_([0.0, (J.sub(J.gp(v_S_827, "tx"), J.mul(0.5, v_th_830)) - J.mul(0.35, v_H_829))])
	v_spin_832 = J.mc(v_N_826, "seg", [v_t_828, 0.17, 0.255])
	v_sx_833 = cos(J.num((J.mul(v_spin_832, PI) * 2.0)))
	v_f_834 = J.mc(v_N_826, "kf", [v_t_828, [[0.0, {}], [0.15, {"sy": 0.9, "r": (-8.0), "hairL": 0.45, "hairR": 0.45, "head": (-0.15)}], [J.gp(v_N_826, "TC"), {"x": v_D2_831, "r": 8.0, "hairL": (-0.7), "hairR": (-0.7), "head": 0.15}, "i"], [0.36, {"x": v_D2_831, "r": 6.0, "hairL": (-0.5), "hairR": (-0.5)}], [0.5, {"hairL": 0.2, "hairR": 0.2}], [0.59, {}]]])
	var _t321 = J.gp(v_f_834, "sx")
	var _t322 = J.mul((_t321 if J.t(_t321) else 1.0), ((0.15 * signf(J.num((v_sx_833 if J.t(v_sx_833) else 1.0)))) if (absf(J.num(v_sx_833)) < 0.15) else v_sx_833))
	J.sp(v_f_834, "sx", _t322)
	J.mc(J.G.get("N30M"), "begin", [v_ctx_824, v_S_827, J.gp(v_f_834, "x")])
	J.mc(v_N_826, "whole", [v_ctx_824, v_S_827, v_f_834, null, 0.3])
	v_T_835 = J.mc(v_N_826, "tgt", [v_S_827, 0.6])
	var _t323 = J.gp(v_f_834, "x")
	v_hd_836 = [(_t323 if J.t(_t323) else 0.0), J.mul((-0.75), v_H_829)]
	var _t324 = J.cmp(v_t_828, 0.2, ">")
	if (J.cmp(v_t_828, 0.36, "<") if _t324 else _t324):
		v_i_838 = 0.0
		while true:
			if not J.cmp(v_i_838, 4.0, "<"): break
			v_k_839 = J.mc(v_N_826, "seg", [v_t_828, 0.2, J.gp(v_N_826, "TC")])
			v_pts_840 = []
			v_j_841 = 0.0
			while true:
				if not J.cmp(v_j_841, 8.0, "<="): break
				v_q_842 = J.div(v_j_841, 8.0)
				J.mc(v_pts_840, "push", [[J.mc(v_N_826, "lerp", [J.gp(v_hd_836, 0.0), J.add(J.gp(v_T_835, 0.0), J.mul(0.05, v_th_830)), J.mul(v_q_842, v_k_839)]), J.add(J.add(J.add(J.gp(v_hd_836, 1.0), J.mul((J.sub(v_i_838, 1.5) * 0.05), v_H_829)), J.mul(J.mul((sin(J.num(J.add((J.mul(v_q_842, 6.0) + J.mul(v_t_828, 30.0)), v_i_838))) * 0.04), v_H_829), v_q_842)), J.mul(v_q_842, J.sub(J.gp(v_T_835, 1.0), J.gp(v_hd_836, 1.0))))]])
				v_j_841 = J.num(v_j_841) + 1.0
			J.mc(v_N_826, "crayon", [v_ctx_824, v_pts_840, "rgba(25,18,15,.85)", J.mul(0.018, v_H_829), J.add(261.0, v_i_838), J.sub(1.0, J.mc(v_N_826, "seg", [v_t_828, 0.32, 0.36]))])
			v_i_838 = J.num(v_i_838) + 1.0
	v_p_837 = J.sub(v_t_828, J.gp(v_N_826, "TC"))
	var _t325 = J.cmp(v_p_837, 0.0, ">=")
	if (J.cmp(v_p_837, 0.13, "<") if _t325 else _t325):
		J.mc(v_N_826, "burst", [v_ctx_824, J.gp(v_T_835, 0.0), J.gp(v_T_835, 1.0), J.mul(0.3, v_th_830), (1.0 - J.div(v_p_837, 0.13)), "#e8d8c8", 265.0, 9.0])
	J.mc(v_N_826, "pop", [v_ctx_824, v_S_827, J.gp(v_T_835, 0.0), J.sub(J.gp(v_T_835, 1.0), J.mul(0.4, v_th_830)), "嘶！", J.mul(0.22, v_th_830), "#d8c8b8", J.gp(v_N_826, "TC"), 0.3])
	J.mc(v_N_826, "hit", [v_S_827, J.gp(v_T_835, 0.0), J.gp(v_T_835, 1.0)])
	J.mc(J.G.get("N30M"), "end", [v_ctx_824])

func _f63(this_, a: Array, env):
	var v_ctx_845 = null; var v_a_846 = null; var v_N_847 = null; var v_S_848 = null; var v_t_849 = null; var v_H_850 = null; var v_th_851 = null; var v_D2_852 = null; var v_f_853 = null; var v_T_854 = null; var v_p_855 = null
	v_ctx_845 = J.arg(a, 0)
	v_a_846 = J.arg(a, 1)
	v_N_847 = J.G.get("N30K")
	v_S_848 = J.mc(v_N_847, "setup", [v_a_846])
	if (not J.t(v_S_848)):
		return false
	v_t_849 = J.gp(v_S_848, "tt")
	v_H_850 = J.gp(v_S_848, "H")
	v_th_851 = J.gp(v_S_848, "th")
	v_D2_852 = J.max_([0.0, (J.sub(J.gp(v_S_848, "tx"), J.mul(0.35, v_th_851)) - J.mul(0.35, v_H_850))])
	v_f_853 = J.mc(v_N_847, "kf", [v_t_849, [[0.0, {}], [0.16, {"r": (-6.0), "legB": (-0.22), "legF": 0.08, "head": (-0.1), "armB": 0.3}], [J.gp(v_N_847, "TC"), {"x": v_D2_852, "r": 22.0, "py": J.mul((-0.5), v_H_850), "body": 0.35, "head": 0.35, "legB": (-0.08), "legF": 0.12, "armB": (-0.6), "armF": 0.3}, "i"], [0.36, {"x": v_D2_852, "r": 20.0, "py": J.mul((-0.5), v_H_850), "body": 0.33, "head": 0.32, "armB": (-0.4)}], [0.48, {"x": J.mul(v_D2_852, 0.5), "legF": (-0.12), "legB": 0.1, "r": 5.0, "py": J.mul((-0.5), v_H_850)}], [0.59, {}]]])
	J.sp(v_f_853, "px", 0.0)
	var _t328 = J.mul((-0.5), v_H_850)
	J.sp(v_f_853, "py", _t328)
	J.mc(J.G.get("N30M"), "begin", [v_ctx_845, v_S_848, J.gp(v_f_853, "x")])
	J.mc(v_N_847, "whole", [v_ctx_845, v_S_848, v_f_853, null, 0.3])
	v_T_854 = J.mc(v_N_847, "tgt", [v_S_848, 0.88])
	v_p_855 = J.sub(v_t_849, J.gp(v_N_847, "TC"))
	var _t329 = J.cmp(v_p_855, 0.0, ">=")
	if (J.cmp(v_p_855, 0.13, "<") if _t329 else _t329):
		J.mc(v_N_847, "burst", [v_ctx_845, J.gp(v_T_854, 0.0), J.gp(v_T_854, 1.0), J.mul(0.25, v_th_851), (1.0 - J.div(v_p_855, 0.13)), "#fff", 271.0, 8.0])
	var _t330 = J.cmp(v_p_855, 0.0, ">=")
	if (J.cmp(v_p_855, 0.3, "<") if _t330 else _t330):
		J.mc(v_N_847, "stars", [v_ctx_845, J.gp(v_T_854, 0.0), J.sub(J.gp(v_T_854, 1.0), J.mul(0.1, v_th_851)), J.mul(0.15, v_th_851), v_t_849, (1.0 - J.div(v_p_855, 0.3))])
	J.mc(v_N_847, "pop", [v_ctx_845, v_S_848, J.gp(v_T_854, 0.0), J.sub(J.gp(v_T_854, 1.0), J.mul(0.3, v_th_851)), "彈！", J.mul(0.22, v_th_851), "#ffffff", J.gp(v_N_847, "TC"), 0.28])
	J.mc(v_N_847, "hit", [v_S_848, J.gp(v_T_854, 0.0), J.gp(v_T_854, 1.0)])
	J.mc(J.G.get("N30M"), "end", [v_ctx_845])

func _f64(this_, a: Array, env):
	var v_ctx_858 = null; var v_a_859 = null; var v_N_860 = null; var v_S_861 = null; var v_key_862 = null; var v_t_863 = null; var v_H_864 = null; var v_th_865 = null; var v_PV_866 = null; var v_AC_867 = null; var v_f_868 = null; var v_m_869 = null; var v_el_870 = null; var v_T_871 = null; var v_off_872 = null; var v_x_873 = null; var v_y_874 = null; var v_r_875 = null; var v_p_876 = null; var v_k_877 = null; var v_q_878 = null; var v_q_879 = null; var v_bx_880 = null; var v_by_881 = null; var v_c_882 = null
	v_ctx_858 = J.arg(a, 0)
	v_a_859 = J.arg(a, 1)
	v_N_860 = J.G.get("N30K")
	v_S_861 = J.mc(v_N_860, "setup", [v_a_859])
	if (not J.t(v_S_861)):
		return false
	v_key_862 = J.mc(J.G.get("N30"), "body", [J.gp(v_S_861, "id")])
	if (not J.t(v_key_862)):
		return false
	v_t_863 = J.gp(v_S_861, "tt")
	v_H_864 = J.gp(v_S_861, "H")
	v_th_865 = J.gp(v_S_861, "th")
	v_PV_866 = [0.63, 0.47]
	v_AC_867 = [0.8, 0.44]
	v_f_868 = J.mc(v_N_860, "kf", [v_t_863, [[0.0, {}], [0.15, {"r": (-7.0), "head": (-0.15), "body": (-0.05)}], [0.2, {"r": 9.0, "head": 0.15, "body": 0.1, "x": J.mul(0.03, v_H_864)}, "o"], [0.45, {"r": 2.0}], [0.55, {"r": (-4.0), "head": (-0.1)}], [0.59, {}]]])
	v_m_869 = J.mc(v_N_860, "bm", [v_S_861, v_f_868])
	v_el_870 = J.mc(v_N_860, "at", [v_S_861, v_m_869, J.gp(v_PV_866, 0.0), J.gp(v_PV_866, 1.0)])
	v_T_871 = J.mc(v_N_860, "tgt", [v_S_861, 0.82])
	v_off_872 = [J.mul(((1.0 if J.t(J.gp(v_S_861, "nr")) else (-1.0)) * J.sub(J.gp(v_AC_867, 0.0), J.gp(v_PV_866, 0.0))), J.gp(v_S_861, "W")), J.mul(J.sub(J.gp(v_AC_867, 1.0), J.gp(v_PV_866, 1.0)), J.gp(v_S_861, "H"))]
	v_x_873 = null
	v_y_874 = null
	v_r_875 = null
	if J.cmp(v_t_863, 0.16, "<"):
		var _t333 = J.gp(v_N_860, "E")
		v_k_877 = J.mc(_t333, "io", [J.mc(v_N_860, "seg", [v_t_863, 0.02, 0.16])])
		var _t334 = J.mul((-130.0), v_k_877)
		v_r_875 = _t334
		v_x_873 = J.gp(v_el_870, 0.0)
		v_y_874 = J.gp(v_el_870, 1.0)
	else:
		if J.cmp(v_t_863, J.gp(v_N_860, "TC"), "<"):
			v_q_878 = J.mc(v_N_860, "seg", [v_t_863, 0.16, J.gp(v_N_860, "TC")])
			var _t335 = J.mc(v_N_860, "lerp", [J.gp(v_el_870, 0.0), J.sub(J.gp(v_T_871, 0.0), J.gp(v_off_872, 0.0)), v_q_878])
			v_x_873 = _t335
			var _t336 = J.sub(J.mc(v_N_860, "lerp", [J.gp(v_el_870, 1.0), J.sub(J.gp(v_T_871, 1.0), J.gp(v_off_872, 1.0)), v_q_878]), (J.mul(0.15, v_H_864) * sin(J.num(J.mul(v_q_878, PI)))))
			v_y_874 = _t336
			var _t337 = ((-130.0) + J.mul(v_q_878, 900.0))
			v_r_875 = _t337
		else:
			if J.cmp(v_t_863, 0.55, "<"):
				v_q_879 = J.mc(v_N_860, "seg", [v_t_863, J.gp(v_N_860, "TC"), 0.55])
				v_bx_880 = J.sub(J.gp(v_T_871, 0.0), J.gp(v_off_872, 0.0))
				v_by_881 = J.sub(J.gp(v_T_871, 1.0), J.gp(v_off_872, 1.0))
				var _t338 = J.add(J.mc(v_N_860, "lerp", [v_bx_880, J.gp(v_el_870, 0.0), v_q_879]), J.mul((sin(J.num(J.mul(v_q_879, PI))) * 0.1), v_H_864))
				v_x_873 = _t338
				var _t339 = J.sub(J.mc(v_N_860, "lerp", [v_by_881, J.gp(v_el_870, 1.0), v_q_879]), J.mul((sin(J.num(J.mul(v_q_879, PI))) * 0.4), v_H_864))
				v_y_874 = _t339
				var _t340 = ((770.0 + J.mul(v_q_879, 1060.0)) - (0.0 if J.cmp(v_q_879, 0.85, ">") else 0.0))
				v_r_875 = _t340
			else:
				v_x_873 = J.gp(v_el_870, 0.0)
				v_y_874 = J.gp(v_el_870, 1.0)
				v_r_875 = 0.0
	if J.cmp(v_t_863, 0.55, ">="):
		v_r_875 = 0.0
	else:
		if J.cmp(v_t_863, 0.5, ">"):
			var _t341 = (J.mod(v_r_875, 360.0) * J.sub(1.0, J.mc(v_N_860, "seg", [v_t_863, 0.5, 0.55])))
			v_r_875 = _t341
	J.mc(J.G.get("N30M"), "begin", [v_ctx_858, v_S_861, J.gp(v_f_868, "x")])
	J.mc(v_N_860, "body", [v_ctx_858, v_S_861, v_m_869, J.mc(v_N_860, "pose", [v_S_861, v_f_868, 0.3]), v_key_862])
	var _t342 = J.cmp(v_t_863, 0.16, ">")
	if (J.cmp(v_t_863, 0.55, "<") if _t342 else _t342):
		J.mc(v_N_860, "speed", [v_ctx_858, v_x_873, v_y_874, 1.0, 0.0, J.mul(0.12, v_H_864), J.mul(0.08, v_H_864), 0.6, "rgba(255,250,230,.5)", 281.0, 3.0])
	var _t343 = J.cmp(v_t_863, 0.16, "<")
	if (_t343 if _t343 else J.cmp(v_t_863, 0.55, ">=")):
		J.mc(v_N_860, "pieceAt", [v_ctx_858, v_S_861, "arm", v_x_873, v_y_874, v_r_875, J.gp(v_PV_866, 0.0), J.gp(v_PV_866, 1.0)])
	else:
		v_c_882 = [J.add(v_x_873, J.gp(v_off_872, 0.0)), J.add(v_y_874, J.gp(v_off_872, 1.0))]
		J.mc(v_N_860, "pieceAt", [v_ctx_858, v_S_861, "arm", J.gp(v_c_882, 0.0), J.gp(v_c_882, 1.0), v_r_875, J.gp(v_AC_867, 0.0), J.gp(v_AC_867, 1.0)])
	v_p_876 = J.sub(v_t_863, J.gp(v_N_860, "TC"))
	var _t344 = J.cmp(v_p_876, 0.0, ">=")
	if (J.cmp(v_p_876, 0.13, "<") if _t344 else _t344):
		J.mc(v_N_860, "burst", [v_ctx_858, J.gp(v_T_871, 0.0), J.gp(v_T_871, 1.0), J.mul(0.3, v_th_865), (1.0 - J.div(v_p_876, 0.13)), "#fffbe8", 285.0, 9.0])
	J.mc(v_N_860, "pop", [v_ctx_858, v_S_861, J.gp(v_T_871, 0.0), J.sub(J.gp(v_T_871, 1.0), J.mul(0.3, v_th_865)), "喀啦！", J.mul(0.2, v_th_865), "#f6efd8", J.gp(v_N_860, "TC"), 0.28])
	J.mc(v_N_860, "pop", [v_ctx_858, v_S_861, J.gp(v_el_870, 0.0), J.sub(J.gp(v_el_870, 1.0), J.mul(0.12, v_H_864)), "喀", J.mul(0.1, v_H_864), "#f6efd8", 0.55, 0.04])
	J.mc(v_N_860, "hit", [v_S_861, J.gp(v_T_871, 0.0), J.gp(v_T_871, 1.0)])
	J.mc(J.G.get("N30M"), "end", [v_ctx_858])

func _f65(this_, a: Array, env):
	var v_ctx_885 = null; var v_a_886 = null; var v_N_887 = null; var v_S_888 = null; var v_t_889 = null; var v_H_890 = null; var v_th_891 = null; var v_D2_892 = null; var v_f_893 = null; var v_T_894 = null; var v_p_895 = null; var v_fx_896 = null; var v_k_897 = null; var v_al_898 = null; var v_pts_899 = null; var v_j_900 = null; var v_q_901 = null; var v_i_902 = null; var v_an_903 = null; var v_sp_904 = null; var v_px_905 = null; var v_py_906 = null; var v_i_907 = null
	v_ctx_885 = J.arg(a, 0)
	v_a_886 = J.arg(a, 1)
	v_N_887 = J.G.get("N30K")
	v_S_888 = J.mc(v_N_887, "setup", [v_a_886])
	if (not J.t(v_S_888)):
		return false
	v_t_889 = J.gp(v_S_888, "tt")
	v_H_890 = J.gp(v_S_888, "H")
	v_th_891 = J.gp(v_S_888, "th")
	v_D2_892 = J.max_([0.0, (J.sub(J.gp(v_S_888, "tx"), J.mul(0.7, v_th_891)) - J.mul(0.3, v_H_890))])
	v_f_893 = J.mc(v_N_887, "kf", [v_t_889, [[0.0, {}], [0.06, {"sy": 0.88, "sx": 1.06}], [0.17, {"y": J.mul((-0.25), v_H_890), "x": J.mul(v_D2_892, 0.6), "sy": 1.06, "armF": (-0.6), "armB": (-0.5), "head": (-0.15)}, "o"], [J.gp(v_N_887, "TC"), {"y": 0.0, "x": v_D2_892, "sy": 0.84, "sx": 1.1, "armF": (-0.25), "armB": (-0.2), "r": 12.0, "head": 0.2}, "i"], [0.36, {"x": v_D2_892, "sy": 0.9, "sx": 1.06, "r": 10.0, "armF": (-0.2), "armB": (-0.15)}], [0.5, {"x": J.mul(v_D2_892, 0.3), "armF": (-0.5), "armB": 0.4}], [0.59, {}]]])
	var _t348 = J.gp(v_f_893, "x")
	var _t347 = J.gp(v_f_893, "y")
	J.mc(J.G.get("N30M"), "begin", [v_ctx_885, v_S_888, _t348, J.sub(1.0, J.mc(v_N_887, "cl", [J.div((-J.num((_t347 if J.t(_t347) else 0.0))), v_H_890)]))])
	J.mc(v_N_887, "whole", [v_ctx_885, v_S_888, v_f_893, null, 0.3])
	v_T_894 = J.mc(v_N_887, "tgt", [v_S_888, 0.4])
	v_p_895 = J.sub(v_t_889, J.gp(v_N_887, "TC"))
	var _t349 = J.gp(v_f_893, "x")
	v_fx_896 = J.add((_t349 if J.t(_t349) else 0.0), J.mul(0.35, v_H_890))
	if J.cmp(v_p_895, 0.0, ">="):
		v_k_897 = J.mc(v_N_887, "seg", [v_t_889, J.gp(v_N_887, "TC"), J.add(J.gp(v_N_887, "TC"), 0.06)])
		v_al_898 = J.sub(1.0, J.mc(v_N_887, "seg", [v_t_889, 0.5, 0.59]))
		v_pts_899 = []
		v_j_900 = 0.0
		while true:
			if not J.cmp(v_j_900, 8.0, "<="): break
			v_q_901 = J.mul(J.div(v_j_900, 8.0), v_k_897)
			J.mc(v_pts_899, "push", [[J.mc(v_N_887, "lerp", [v_fx_896, J.add(J.gp(v_S_888, "tx"), J.gp(v_S_888, "back")), v_q_901]), (J.mul(J.gp(v_S_888, "ty"), v_q_901) + J.mul((sin(J.num(J.mul(v_j_900, 2.3))) * 0.02), v_H_890))]])
			v_j_900 = J.num(v_j_900) + 1.0
		J.mc(v_ctx_885, "save", [])
		var _t350 = J.mul(J.gp(v_ctx_885, "globalAlpha"), v_al_898)
		J.sp(v_ctx_885, "globalAlpha", _t350)
		J.mc(v_N_887, "crayon", [v_ctx_885, v_pts_899, "rgba(40,28,22,.9)", J.mul(0.02, v_H_890), 291.0])
		J.mc(v_ctx_885, "restore", [])
		J.mc(v_N_887, "cracks", [v_ctx_885, J.add(J.gp(v_S_888, "tx"), J.gp(v_S_888, "back")), J.gp(v_S_888, "ty"), J.mul(0.4, v_th_891), J.mul(v_al_898, v_k_897), 292.0])
	var _t351 = J.cmp(v_p_895, 0.0, ">=")
	if (J.cmp(v_p_895, 0.35, "<") if _t351 else _t351):
		v_i_902 = 0.0
		while true:
			if not J.cmp(v_i_902, 9.0, "<"): break
			v_an_903 = ((-PI) * (0.15 + J.mul(0.7, J.mc(v_N_887, "rnd", [v_i_902]))))
			v_sp_904 = J.mul(J.mul(J.add(0.4, J.mc(v_N_887, "rnd", [J.add(v_i_902, 4.0)])), 1.4), v_th_891)
			v_px_905 = J.add(J.add(v_fx_896, (J.mul(J.mul(cos(J.num(v_an_903)), v_sp_904), v_p_895) * (1.0 if J.t(J.mod(v_i_902, 2.0)) else 0.4))), (J.mul(J.sub(J.gp(v_S_888, "tx"), v_fx_896), J.mc(v_N_887, "cl", [J.mul(v_p_895, 6.0)])) if J.t(J.mod(v_i_902, 2.0)) else 0.0))
			v_py_906 = (J.mul(J.mul(sin(J.num(v_an_903)), v_sp_904), v_p_895) + J.mul(J.mul(J.mul(3.0, v_th_891), v_p_895), v_p_895))
			J.mc(v_ctx_885, "save", [])
			var _t352 = J.mul(J.gp(v_ctx_885, "globalAlpha"), (1.0 - J.div(v_p_895, 0.35)))
			J.sp(v_ctx_885, "globalAlpha", _t352)
			J.sp(v_ctx_885, "fillStyle", "#7a6a5a")
			J.sp(v_ctx_885, "strokeStyle", "#3a2a1a")
			var _t353 = J.mul(0.01, v_th_891)
			J.sp(v_ctx_885, "lineWidth", _t353)
			J.mc(v_ctx_885, "beginPath", [])
			J.mc(v_ctx_885, "moveTo", [v_px_905, J.sub(v_py_906, J.mul(0.03, v_th_891))])
			J.mc(v_ctx_885, "lineTo", [J.add(v_px_905, J.mul(0.03, v_th_891)), v_py_906])
			J.mc(v_ctx_885, "lineTo", [v_px_905, J.add(v_py_906, J.mul(0.025, v_th_891))])
			J.mc(v_ctx_885, "lineTo", [J.sub(v_px_905, J.mul(0.03, v_th_891)), J.add(v_py_906, J.mul(0.005, v_th_891))])
			J.mc(v_ctx_885, "closePath", [])
			J.mc(v_ctx_885, "fill", [])
			J.mc(v_ctx_885, "stroke", [])
			J.mc(v_ctx_885, "restore", [])
			v_i_902 = J.num(v_i_902) + 1.0
	v_i_907 = 0.0
	while true:
		if not J.cmp(v_i_907, 4.0, "<"): break
		J.mc(v_N_887, "puff", [v_ctx_885, J.add(v_fx_896, J.mul((J.sub(v_i_907, 1.5) * 0.18), v_H_890)), J.mul((-0.03), v_H_890), J.mul(0.08, v_H_890), J.mc(v_N_887, "seg", [v_t_889, J.add(J.gp(v_N_887, "TC"), J.mul(v_i_907, 0.01)), 0.5]), "rgba(190,170,150,.6)", J.add(295.0, v_i_907), 3.0])
		v_i_907 = J.num(v_i_907) + 1.0
	J.mc(v_N_887, "pop", [v_ctx_885, v_S_888, J.gp(v_T_894, 0.0), J.sub(J.gp(v_T_894, 1.0), J.mul(0.55, v_th_891)), "轟！", J.mul(0.3, v_th_891), "#ffcf80", J.gp(v_N_887, "TC"), 0.32])
	J.mc(v_N_887, "hit", [v_S_888, J.gp(v_T_894, 0.0), J.gp(v_T_894, 1.0)])
	J.mc(J.G.get("N30M"), "end", [v_ctx_885])

func _f67(this_, a: Array, env):
	var v_x_923 = null; var v_y_924 = null; var v_k_925 = null; var v_seed_926 = null; var v_i_927 = null; var v_an_928 = null; var v_d_929 = null
	v_x_923 = J.arg(a, 0)
	v_y_924 = J.arg(a, 1)
	v_k_925 = J.arg(a, 2)
	v_seed_926 = J.arg(a, 3)
	var _t359 = J.cmp(v_k_925, 0.0, "<=")
	if (_t359 if _t359 else J.cmp(v_k_925, 1.0, ">=")):
		return null
	v_i_927 = 0.0
	while true:
		if not J.cmp(v_i_927, 10.0, "<"): break
		v_an_928 = J.mul(J.mc(env["N"], "rnd", [J.add(v_seed_926, v_i_927)]), 6.28)
		v_d_929 = J.mul(J.mul((0.1 + J.mul(v_k_925, 0.4)), env["H"]), J.mc(env["N"], "rnd", [J.add(J.add(v_seed_926, v_i_927), 3.0)]))
		J.mc(env["ctx"], "save", [])
		var _t360 = env["ctx"]
		var _t361 = J.mul(J.gp(_t360, "globalAlpha"), sin(J.num(J.mul(v_k_925, PI))))
		J.sp(_t360, "globalAlpha", _t361)
		var _t362 = env["ctx"]
		var _t363 = ("#ffe28a" if J.t(J.mod(v_i_927, 2.0)) else "#fff6c8")
		J.sp(_t362, "fillStyle", _t363)
		J.mc(env["ctx"], "beginPath", [])
		J.mc(env["ctx"], "arc", [J.add(v_x_923, J.mul(cos(J.num(v_an_928)), v_d_929)), J.sub(J.add(v_y_924, J.mul(sin(J.num(v_an_928)), v_d_929)), J.mul(J.mul(v_k_925, 0.2), env["H"])), J.mul(0.012, env["H"]), 0.0, 7.0])
		J.mc(env["ctx"], "fill", [])
		J.mc(env["ctx"], "restore", [])
		v_i_927 = J.num(v_i_927) + 1.0

func _f66(this_, a: Array, env):
	var v_a_911 = null; var v_S_913 = null; var v_t_914 = null; var v_th_916 = null; var v_BX_917 = null; var v_behind_918 = null; var v_f_919 = null; var v_spark_920 = null; var v_T_921 = null; var v_p_922 = null
	var _s178 = {"__p": env, "ctx": null, "N": null, "H": null}
	_s178["ctx"] = J.arg(a, 0)
	v_a_911 = J.arg(a, 1)
	_s178["N"] = J.G.get("N30K")
	v_S_913 = J.mc(_s178["N"], "setup", [v_a_911])
	if (not J.t(v_S_913)):
		return false
	v_t_914 = J.gp(v_S_913, "tt")
	_s178["H"] = J.gp(v_S_913, "H")
	v_th_916 = J.gp(v_S_913, "th")
	v_BX_917 = J.add(J.add(J.gp(v_S_913, "tx"), J.mul(0.45, v_th_916)), J.mul(0.15, _s178["H"]))
	var _t356 = J.cmp(v_t_914, 0.2, ">=")
	v_behind_918 = (J.cmp(v_t_914, 0.43, "<") if _t356 else _t356)
	v_f_919 = (J.mc(_s178["N"], "kf", [v_t_914, [[0.2, {"x": v_BX_917, "sx": (-1.0), "a": 0.0, "r": 0.0}], [0.24, {"x": v_BX_917, "sx": (-1.0), "a": 1.0, "r": (-4.0)}], [J.gp(_s178["N"], "TC"), {"x": J.sub(v_BX_917, J.mul(0.08, _s178["H"])), "sx": (-1.0), "a": 1.0, "r": 10.0, "armB": (-0.9), "armF": 0.3}, "i"], [0.36, {"x": J.sub(v_BX_917, J.mul(0.08, _s178["H"])), "sx": (-1.0), "a": 1.0, "r": 8.0, "armB": (-0.7)}], [0.43, {"x": v_BX_917, "sx": (-1.0), "a": 0.0}]]]) if J.t(v_behind_918) else (J.mc(_s178["N"], "kf", [v_t_914, [[0.0, {}], [0.05, {"r": (-3.0), "sy": 1.03}], [0.18, {"a": 0.0, "sy": 1.08, "sx": 0.9, "y": J.mul((-0.05), _s178["H"])}]]]) if J.cmp(v_t_914, 0.2, "<") else J.mc(_s178["N"], "kf", [v_t_914, [[0.43, {"a": 0.0, "sy": 1.08, "sx": 0.9}], [0.59, {}]]])))
	var _t358 = _s178["ctx"]
	var _t357 = J.gp(v_f_919, "x")
	J.mc(J.G.get("N30M"), "begin", [_t358, v_S_913, (_t357 if J.t(_t357) else 0.0), ((0.3 + J.mul(0.7, J.gp(v_f_919, "a"))) if (not J.leq(J.gp(v_f_919, "a"), null)) else 1.0)])
	J.mc(_s178["N"], "whole", [_s178["ctx"], v_S_913, v_f_919, null, 0.4])
	v_spark_920 = Callable(self, "_f67").bind(_s178)
	J.cl(v_spark_920, null, [0.0, J.mul((-0.5), _s178["H"]), J.mc(_s178["N"], "seg", [v_t_914, 0.06, 0.26]), 301.0])
	J.cl(v_spark_920, null, [v_BX_917, J.mul((-0.5), _s178["H"]), J.mc(_s178["N"], "seg", [v_t_914, 0.18, 0.3]), 311.0])
	J.cl(v_spark_920, null, [v_BX_917, J.mul((-0.5), _s178["H"]), J.mc(_s178["N"], "seg", [v_t_914, 0.38, 0.5]), 321.0])
	J.cl(v_spark_920, null, [0.0, J.mul((-0.5), _s178["H"]), J.mc(_s178["N"], "seg", [v_t_914, 0.44, 0.59]), 331.0])
	v_T_921 = [J.add(J.add(J.gp(v_S_913, "tx"), J.gp(v_S_913, "back")), J.mul(0.12, v_th_916)), J.sub(J.gp(v_S_913, "ty"), J.mul(0.75, v_th_916))]
	v_p_922 = J.sub(v_t_914, J.gp(_s178["N"], "TC"))
	var _t364 = J.cmp(v_p_922, 0.0, ">=")
	if (J.cmp(v_p_922, 0.15, "<") if _t364 else _t364):
		J.mc(_s178["N"], "burst", [_s178["ctx"], J.gp(v_T_921, 0.0), J.gp(v_T_921, 1.0), J.mul(0.3, v_th_916), (1.0 - J.div(v_p_922, 0.15)), "#ffe28a", 341.0, 10.0])
	J.mc(_s178["N"], "pop", [_s178["ctx"], v_S_913, J.gp(v_T_921, 0.0), J.sub(J.gp(v_T_921, 1.0), J.mul(0.3, v_th_916)), "噗～", J.mul(0.2, v_th_916), "#ffe28a", J.gp(_s178["N"], "TC"), 0.28])
	J.mc(_s178["N"], "hit", [v_S_913, J.gp(v_T_921, 0.0), J.gp(v_T_921, 1.0)])
	J.mc(J.G.get("N30M"), "end", [_s178["ctx"]])

func _f69(this_, a: Array, env):
	var v_i_960 = null; var v_n_961 = null
	v_i_960 = J.arg(a, 0)
	v_n_961 = J.arg(a, 1)
	return (1.0 - (J.mul(J.mul(0.15, env["b"]), J.mc(env["N"], "cl", [J.div(J.hypot_([J.sub(J.gp(env["wr"], 0.0), J.gp(env["w0"], 0.0)), J.sub(J.gp(env["wr"], 1.0), J.gp(env["w0"], 1.0))]), env["H"])])) * sin(J.num((J.div(v_i_960, v_n_961) * PI)))))

func _f68(this_, a: Array, env):
	var v_ctx_932 = null; var v_a_933 = null; var v_S_935 = null; var v_key_936 = null; var v_t_937 = null; var v_th_939 = null; var v_WP_940 = null; var v_f_941 = null; var v_m_942 = null; var v_SRC_943 = null; var v_sh_944 = null; var v_T_946 = null; var v_handLen_947 = null; var v_goal_948 = null; var v_W_949 = null; var v_mid_952 = null; var v_line_953 = null; var v_end_954 = null; var v_prev_955 = null; var v_restA_956 = null; var v_curA_957 = null; var v_grip_958 = null; var v_p_959 = null
	var _s182 = {"__p": env, "N": null, "H": null, "w0": null, "b": null, "wr": null}
	v_ctx_932 = J.arg(a, 0)
	v_a_933 = J.arg(a, 1)
	_s182["N"] = J.G.get("N30K")
	v_S_935 = J.mc(_s182["N"], "setup", [v_a_933])
	if (not J.t(v_S_935)):
		return false
	v_key_936 = J.mc(J.G.get("N30"), "body", [J.gp(v_S_935, "id")])
	if (not J.t(v_key_936)):
		return false
	v_t_937 = J.gp(v_S_935, "tt")
	_s182["H"] = J.gp(v_S_935, "H")
	v_th_939 = J.gp(v_S_935, "th")
	v_WP_940 = [0.205, 0.45]
	v_f_941 = J.mc(_s182["N"], "kf", [v_t_937, [[0.0, {}], [0.16, {"r": (-4.0), "head": (-0.1)}], [J.gp(_s182["N"], "TC"), {"r": 5.0, "head": 0.1, "x": J.mul(0.02, _s182["H"])}, "i"], [0.36, {"r": (-2.0), "head": (-0.05)}], [0.59, {}]]])
	v_m_942 = J.mc(_s182["N"], "bm", [v_S_935, v_f_941])
	v_SRC_943 = [[0.56, 0.405], [0.45, 0.4], [0.33, 0.4], [0.24, 0.41], [0.19, 0.43]]
	v_sh_944 = J.mc(_s182["N"], "at", [v_S_935, v_m_942, 0.56, 0.405])
	_s182["w0"] = J.mc(_s182["N"], "at", [v_S_935, v_m_942, 0.19, 0.43])
	v_T_946 = J.mc(_s182["N"], "tgt", [v_S_935, 0.82])
	v_handLen_947 = J.mul(0.15, J.gp(v_S_935, "W"))
	v_goal_948 = [J.sub(J.gp(v_T_946, 0.0), v_handLen_947), J.add(J.gp(v_T_946, 1.0), J.mul(0.02, v_th_939))]
	v_W_949 = J.mc(_s182["N"], "kf", [v_t_937, [[0.0, {"x": J.gp(_s182["w0"], 0.0), "y": J.gp(_s182["w0"], 1.0)}], [0.16, {"x": J.sub(J.gp(_s182["w0"], 0.0), J.mul(0.08, _s182["H"])), "y": J.sub(J.gp(_s182["w0"], 1.0), J.mul(0.03, _s182["H"]))}], [J.gp(_s182["N"], "TC"), {"x": J.gp(v_goal_948, 0.0), "y": J.gp(v_goal_948, 1.0)}, "i"], [0.31, {"x": J.sub(J.gp(v_goal_948, 0.0), J.mul(0.02, _s182["H"])), "y": J.add(J.gp(v_goal_948, 1.0), J.mul(0.01, _s182["H"]))}], [0.36, {"x": J.sub(J.gp(v_goal_948, 0.0), J.mul(0.08, _s182["H"])), "y": J.gp(v_goal_948, 1.0)}], [0.59, {"x": J.gp(_s182["w0"], 0.0), "y": J.gp(_s182["w0"], 1.0)}, "io"]]])
	_s182["b"] = J.gp(J.mc(_s182["N"], "kf", [v_t_937, [[0.0, {"v": 0.0}], [0.05, {"v": 1.0}], [0.55, {"v": 1.0}], [0.59, {"v": 0.0}]]]), "v")
	_s182["wr"] = [J.gp(v_W_949, "x"), J.gp(v_W_949, "y")]
	v_mid_952 = [J.div(J.add(J.gp(v_sh_944, 0.0), J.gp(_s182["wr"], 0.0)), 2.0), (J.div(J.add(J.gp(v_sh_944, 1.0), J.gp(_s182["wr"], 1.0)), 2.0) + (J.mul(0.03, _s182["H"]) * J.sub(1.0, J.mc(_s182["N"], "seg", [v_t_937, 0.16, J.gp(_s182["N"], "TC")]))))]
	J.mc(J.G.get("N30M"), "begin", [v_ctx_932, v_S_935, J.gp(v_f_941, "x")])
	J.mc(_s182["N"], "body", [v_ctx_932, v_S_935, v_m_942, J.mc(_s182["N"], "pose", [v_S_935, v_f_941, 0.25]), v_key_936])
	v_line_953 = J.mc(J.G.get("N30M"), "line", [v_S_935, v_m_942, v_SRC_943, v_sh_944, v_mid_952, _s182["wr"], _s182["b"]])
	var _t367 = J.cmp(v_t_937, 0.17, ">")
	if (J.cmp(v_t_937, J.gp(_s182["N"], "TC"), "<") if _t367 else _t367):
		J.mc(_s182["N"], "speed", [v_ctx_932, J.gp(_s182["wr"], 0.0), J.gp(_s182["wr"], 1.0), 1.0, 0.0, J.mul(0.3, _s182["H"]), J.mul(0.08, _s182["H"]), 0.8, "rgba(240,230,255,.6)", 351.0, 3.0])
	J.mc(_s182["N"], "ribbon", [v_ctx_932, v_S_935, "arm", v_SRC_943, 0.034, v_line_953, Callable(self, "_f69").bind(_s182)])
	v_end_954 = J.gp(v_line_953, (J.len(v_line_953) - 1.0))
	v_prev_955 = J.gp(v_line_953, (J.len(v_line_953) - 3.0))
	v_restA_956 = atan2(J.num(J.sub(J.gp(_s182["w0"], 1.0), J.gp(J.mc(_s182["N"], "at", [v_S_935, v_m_942, 0.24, 0.41]), 1.0))), J.num(J.sub(J.gp(_s182["w0"], 0.0), J.gp(J.mc(_s182["N"], "at", [v_S_935, v_m_942, 0.24, 0.41]), 0.0))))
	v_curA_957 = atan2(J.num(J.sub(J.gp(v_end_954, 1.0), J.gp(v_prev_955, 1.0))), J.num(J.sub(J.gp(v_end_954, 0.0), J.gp(v_prev_955, 0.0))))
	var _t368 = J.cmp(v_t_937, J.gp(_s182["N"], "TC"), ">")
	v_grip_958 = ((-12.0) if (J.cmp(v_t_937, 0.4, "<") if _t368 else _t368) else 0.0)
	J.mc(_s182["N"], "pieceAt", [v_ctx_932, v_S_935, "hand", J.gp(v_end_954, 0.0), J.gp(v_end_954, 1.0), J.add(J.div(J.sub(v_curA_957, v_restA_956), J.gp(_s182["N"], "D")), v_grip_958), J.gp(v_WP_940, 0.0), J.gp(v_WP_940, 1.0)])
	v_p_959 = J.sub(v_t_937, J.gp(_s182["N"], "TC"))
	var _t369 = J.cmp(v_p_959, 0.0, ">=")
	if (J.cmp(v_p_959, 0.13, "<") if _t369 else _t369):
		J.mc(_s182["N"], "burst", [v_ctx_932, J.gp(v_T_946, 0.0), J.gp(v_T_946, 1.0), J.mul(0.3, v_th_939), (1.0 - J.div(v_p_959, 0.13)), "#efe0ff", 355.0, 9.0])
	J.mc(_s182["N"], "pop", [v_ctx_932, v_S_935, J.gp(v_T_946, 0.0), J.sub(J.gp(v_T_946, 1.0), J.mul(0.35, v_th_939)), "捉到你～", J.mul(0.18, v_th_939), "#e8d0ff", J.gp(_s182["N"], "TC"), 0.32])
	J.mc(_s182["N"], "hit", [v_S_935, J.gp(v_T_946, 0.0), J.gp(v_T_946, 1.0)])
	J.mc(J.G.get("N30M"), "end", [v_ctx_932])

func _f70(this_, a: Array, env):
	var v_ctx_964 = null; var v_a_965 = null; var v_N_966 = null; var v_S_967 = null; var v_t_968 = null; var v_H_969 = null; var v_th_970 = null; var v_D2_971 = null; var v_SY_972 = null; var v_f_973 = null; var v_T_974 = null; var v_p_975 = null; var v_i_976 = null; var v_q_977 = null
	v_ctx_964 = J.arg(a, 0)
	v_a_965 = J.arg(a, 1)
	v_N_966 = J.G.get("N30K")
	v_S_967 = J.mc(v_N_966, "setup", [v_a_965])
	if (not J.t(v_S_967)):
		return false
	v_t_968 = J.gp(v_S_967, "tt")
	v_H_969 = J.gp(v_S_967, "H")
	v_th_970 = J.gp(v_S_967, "th")
	v_D2_971 = J.sub(J.add(J.gp(v_S_967, "tx"), J.mul(J.gp(v_S_967, "back"), 0.5)), J.mul(0.05, v_th_970))
	v_SY_972 = J.sub(J.gp(v_S_967, "ty"), J.mul(0.55, v_th_970))
	v_f_973 = J.mc(v_N_966, "kf", [v_t_968, [[0.0, {}], [0.15, {"sy": 0.78, "sx": 1.12, "armF": 0.3, "armB": (-0.3)}], [0.21, {"x": J.mul(v_D2_971, 0.5), "y": J.mul((-0.7), v_H_969), "sy": 1.12, "sx": 0.92, "armF": (-0.6), "armB": 0.6, "r": (-10.0)}, "o"], [J.gp(v_N_966, "TC"), {"x": v_D2_971, "y": v_SY_972, "sy": 0.8, "sx": 1.15, "armF": (-0.3), "armB": 0.3}, "i"], [0.36, {"x": v_D2_971, "y": v_SY_972, "sy": 0.9, "sx": 1.08, "r": 4.0}], [0.4, {"x": v_D2_971, "y": v_SY_972, "sy": 0.88, "sx": 1.1, "r": (-4.0)}], [0.48, {"x": J.mul(v_D2_971, 0.5), "y": J.mul((-0.45), v_H_969), "sy": 1.05}, "o"], [0.59, {}, "i"]]])
	var _t373 = J.gp(v_f_973, "x")
	var _t372 = J.gp(v_f_973, "y")
	J.mc(J.G.get("N30M"), "begin", [v_ctx_964, v_S_967, _t373, (1.0 - J.mul(J.mc(v_N_966, "cl", [J.div((-J.num((_t372 if J.t(_t372) else 0.0))), v_H_969)]), 0.5))])
	J.mc(v_N_966, "whole", [v_ctx_964, v_S_967, v_f_973, null, 0.3])
	v_T_974 = J.mc(v_N_966, "tgt", [v_S_967, 0.55])
	v_p_975 = J.sub(v_t_968, J.gp(v_N_966, "TC"))
	var _t374 = J.cmp(v_p_975, 0.0, ">=")
	if (J.cmp(v_p_975, 0.13, "<") if _t374 else _t374):
		J.mc(v_N_966, "burst", [v_ctx_964, J.gp(v_T_974, 0.0), v_SY_972, J.mul(0.45, v_th_970), (1.0 - J.div(v_p_975, 0.13)), "#ffd8f0", 361.0, 12.0])
	v_i_976 = 0.0
	while true:
		if not J.cmp(v_i_976, 3.0, "<"): break
		v_q_977 = J.mc(v_N_966, "seg", [v_t_968, J.add(J.gp(v_N_966, "TC"), J.mul(v_i_976, 0.04)), 0.55])
		var _t375 = J.cmp(v_q_977, 0.0, ">")
		if (J.cmp(v_q_977, 1.0, "<") if _t375 else _t375):
			J.mc(v_N_966, "txt", [v_ctx_964, v_S_967, J.add(J.add(v_D2_971, J.mul(0.2, v_H_969)), J.mul(J.mul(v_q_977, 0.15), v_H_969)), ((J.sub(v_SY_972, J.mul(0.9, v_H_969)) - J.mul(J.mul(v_q_977, 0.3), v_H_969)) - J.mul(J.mul(v_i_976, 0.05), v_H_969)), "Z", J.mul((0.12 + J.mul(v_i_976, 0.04)), v_H_969), "#c8d8ff", sin(J.num(J.mul(v_q_977, PI)))])
		v_i_976 = J.num(v_i_976) + 1.0
	J.mc(v_N_966, "pop", [v_ctx_964, v_S_967, J.gp(v_T_974, 0.0), J.sub(v_SY_972, J.mul(1.05, v_H_969)), "坐低！", J.mul(0.14, v_H_969), "#ffd8f0", J.gp(v_N_966, "TC"), 0.3])
	J.mc(v_N_966, "hit", [v_S_967, J.gp(v_T_974, 0.0), J.gp(v_T_974, 1.0)])
	J.mc(J.G.get("N30M"), "end", [v_ctx_964])

func _f71(this_, a: Array, env):
	var v_ctx_980 = null; var v_a_981 = null; var v_N_982 = null; var v_S_983 = null; var v_t_984 = null; var v_H_985 = null; var v_th_986 = null; var v_D2_987 = null; var v_turn_988 = null; var v_f_989 = null; var v_T_990 = null; var v_p_991 = null; var v_i_992 = null
	v_ctx_980 = J.arg(a, 0)
	v_a_981 = J.arg(a, 1)
	v_N_982 = J.G.get("N30K")
	v_S_983 = J.mc(v_N_982, "setup", [v_a_981])
	if (not J.t(v_S_983)):
		return false
	v_t_984 = J.gp(v_S_983, "tt")
	v_H_985 = J.gp(v_S_983, "H")
	v_th_986 = J.gp(v_S_983, "th")
	v_D2_987 = J.max_([0.0, (J.sub(J.gp(v_S_983, "tx"), J.mul(0.3, v_th_986)) - J.mul(0.25, v_H_985))])
	v_turn_988 = (cos(J.num(J.mul(J.mc(v_N_982, "seg", [v_t_984, 0.05, 0.11]), PI))) if J.cmp(v_t_984, 0.12, "<") else ((-cos(J.num(J.mul(J.mc(v_N_982, "seg", [v_t_984, 0.5, 0.56]), PI)))) if J.cmp(v_t_984, 0.45, ">") else (-1.0)))
	v_f_989 = J.mc(v_N_982, "kf", [v_t_984, [[0.0, {}], [0.12, {"r": 3.0}], [J.gp(v_N_982, "TC"), {"x": v_D2_987, "r": (-10.0)}, "i"], [0.34, {"x": v_D2_987, "r": (-14.0)}], [0.45, {"x": J.mul(v_D2_987, 0.6)}], [0.59, {}]]])
	var _t378 = ((0.15 * signf(J.num((v_turn_988 if J.t(v_turn_988) else 1.0)))) if (absf(J.num(v_turn_988)) < 0.15) else v_turn_988)
	J.sp(v_f_989, "sx", _t378)
	var _t379 = J.cmp(v_t_984, 0.12, ">")
	if (J.cmp(v_t_984, J.gp(v_N_982, "TC"), "<") if _t379 else _t379):
		var _t380 = (sin(J.num(J.mul(v_t_984, 60.0))) * 0.45)
		J.sp(v_f_989, "legF", _t380)
		var _t381 = ((-sin(J.num(J.mul(v_t_984, 60.0)))) * 0.45)
		J.sp(v_f_989, "legB", _t381)
		var _t382 = (sin(J.num(J.mul(v_t_984, 60.0))) * 0.3)
		J.sp(v_f_989, "armF", _t382)
		var _t383 = ((-sin(J.num(J.mul(v_t_984, 60.0)))) * 0.3)
		J.sp(v_f_989, "armB", _t383)
		var _t384 = J.mul(((-absf(J.num(sin(J.num(J.mul(v_t_984, 60.0)))))) * 0.03), v_H_985)
		J.sp(v_f_989, "y", _t384)
		J.sp(v_f_989, "hairL", 0.3)
		J.sp(v_f_989, "hairR", 0.3)
	J.mc(J.G.get("N30M"), "begin", [v_ctx_980, v_S_983, J.gp(v_f_989, "x")])
	J.mc(v_N_982, "whole", [v_ctx_980, v_S_983, v_f_989, null, 0.3])
	var _t385 = J.cmp(v_t_984, 0.12, ">")
	if (J.cmp(v_t_984, J.gp(v_N_982, "TC"), "<") if _t385 else _t385):
		v_i_992 = 0.0
		while true:
			if not J.cmp(v_i_992, 3.0, "<"): break
			var _t386 = J.gp(v_f_989, "x")
			J.mc(v_N_982, "puff", [v_ctx_980, J.sub((_t386 if J.t(_t386) else 0.0), J.mul(J.mul(J.add(v_i_992, 1.0), 0.1), v_H_985)), J.mul((-0.02), v_H_985), J.mul(0.05, v_H_985), J.mc(v_N_982, "cl", [((J.sub(v_t_984, 0.12) * 7.0) - J.mul(v_i_992, 0.2))]), "rgba(200,180,160,.5)", J.add(370.0, v_i_992), 3.0])
			v_i_992 = J.num(v_i_992) + 1.0
	v_T_990 = J.mc(v_N_982, "tgt", [v_S_983, 0.5])
	v_p_991 = J.sub(v_t_984, J.gp(v_N_982, "TC"))
	var _t387 = J.cmp(v_p_991, 0.0, ">=")
	if (J.cmp(v_p_991, 0.13, "<") if _t387 else _t387):
		J.mc(v_N_982, "burst", [v_ctx_980, J.gp(v_T_990, 0.0), J.gp(v_T_990, 1.0), J.mul(0.32, v_th_986), (1.0 - J.div(v_p_991, 0.13)), "#ffd8c8", 375.0, 10.0])
	J.mc(v_N_982, "pop", [v_ctx_980, v_S_983, J.gp(v_T_990, 0.0), J.sub(J.gp(v_T_990, 1.0), J.mul(0.45, v_th_986)), "咚！", J.mul(0.24, v_th_986), "#ffc0a8", J.gp(v_N_982, "TC"), 0.28])
	J.mc(v_N_982, "pop", [v_ctx_980, v_S_983, J.mul(0.1, v_H_985), J.mul((-1.05), v_H_985), "倒住跑！", J.mul(0.11, v_H_985), "#ffd8c8", 0.08, 0.2])
	J.mc(v_N_982, "hit", [v_S_983, J.gp(v_T_990, 0.0), J.gp(v_T_990, 1.0)])
	J.mc(J.G.get("N30M"), "end", [v_ctx_980])

func _f72(this_, a: Array, env):
	var v_ctx_995 = null; var v_a_996 = null; var v_N_997 = null; var v_S_998 = null; var v_t_999 = null; var v_H_1000 = null; var v_th_1001 = null; var v_HX_1002 = null; var v_HY_1003 = null; var v_swing_1004 = null; var v_f_1005 = null; var v_T_1006 = null; var v_p_1007 = null; var v_m_1008 = null; var v_ft_1009 = null; var v_top_1010 = null; var v_i_1011 = null; var v_k_1012 = null
	v_ctx_995 = J.arg(a, 0)
	v_a_996 = J.arg(a, 1)
	v_N_997 = J.G.get("N30K")
	v_S_998 = J.mc(v_N_997, "setup", [v_a_996])
	if (not J.t(v_S_998)):
		return false
	v_t_999 = J.gp(v_S_998, "tt")
	v_H_1000 = J.gp(v_S_998, "H")
	v_th_1001 = J.gp(v_S_998, "th")
	v_HX_1002 = J.sub(J.gp(v_S_998, "tx"), J.mul(0.3, v_th_1001))
	v_HY_1003 = J.sub(J.gp(v_S_998, "ty"), J.mul(0.62, v_th_1001))
	var _t390 = J.cmp(v_t_999, 0.22, ">")
	v_swing_1004 = (((sin(J.num((J.sub(v_t_999, 0.22) * 22.0))) * 10.0) * J.sub(1.0, J.mc(v_N_997, "seg", [v_t_999, 0.3, 0.45]))) if (J.cmp(v_t_999, 0.45, "<") if _t390 else _t390) else 0.0)
	v_f_1005 = J.mc(v_N_997, "kf", [v_t_999, [[0.0, {}], [0.08, {"sy": 0.85, "sx": 1.05}], [0.16, {"y": J.mul((-1.5), v_H_1000), "x": J.mul(v_HX_1002, 0.5), "r": 90.0, "sy": 1.05}, "o"], [0.22, {"y": J.add(v_HY_1003, J.mul(0.02, v_H_1000)), "x": v_HX_1002, "r": 180.0}, "i"], [J.gp(v_N_997, "TC"), {"y": J.add(v_HY_1003, J.mul(0.1, v_H_1000)), "x": v_HX_1002, "r": 185.0, "head": 0.2}], [0.4, {"y": J.add(v_HY_1003, J.mul(0.08, v_H_1000)), "x": v_HX_1002, "r": 180.0}], [0.48, {"y": J.mul((-1.6), v_H_1000), "x": J.mul(v_HX_1002, 0.5), "r": 250.0}, "i"], [0.54, {"y": J.mul((-0.25), v_H_1000), "x": 0.0, "r": 360.0}, "o"], [0.59, {"r": 360.0}]]])
	var _t391 = J.gp(v_f_1005, "r")
	var _t392 = J.add((_t391 if J.t(_t391) else 0.0), v_swing_1004)
	J.sp(v_f_1005, "r", _t392)
	J.sp(v_f_1005, "px", 0.0)
	var _t393 = J.mul((-0.5), v_H_1000)
	J.sp(v_f_1005, "py", _t393)
	var _t395 = J.gp(v_f_1005, "x")
	var _t394 = J.gp(v_f_1005, "y")
	J.mc(J.G.get("N30M"), "begin", [v_ctx_995, v_S_998, _t395, J.sub(1.0, J.mc(v_N_997, "cl", [J.div((-J.num((_t394 if J.t(_t394) else 0.0))), J.mul(1.5, v_H_1000))]))])
	var _t396 = J.cmp(v_t_999, 0.19, ">")
	if (J.cmp(v_t_999, 0.47, "<") if _t396 else _t396):
		v_m_1008 = J.mc(v_N_997, "bm", [v_S_998, v_f_1005])
		v_ft_1009 = J.mc(v_m_1008, "pt", [0.0, 0.0])
		v_top_1010 = [J.sub(J.gp(v_ft_1009, 0.0), J.mul((sin(J.num(J.mul(v_swing_1004, J.gp(v_N_997, "D")))) * 0.6), v_H_1000)), J.sub(J.gp(v_ft_1009, 1.0), J.mul(1.8, v_H_1000))]
		J.mc(v_N_997, "crayon", [v_ctx_995, [v_ft_1009, [(J.div(J.add(J.gp(v_ft_1009, 0.0), J.gp(v_top_1010, 0.0)), 2.0) + J.mul(0.03, v_H_1000)), J.div(J.add(J.gp(v_ft_1009, 1.0), J.gp(v_top_1010, 1.0)), 2.0)], v_top_1010], "#6a4a2a", J.mul(0.03, v_H_1000), 381.0])
		J.mc(v_N_997, "crayon", [v_ctx_995, [[J.sub(J.gp(v_top_1010, 0.0), J.mul(0.4, v_H_1000)), J.add(J.gp(v_top_1010, 1.0), J.mul(0.05, v_H_1000))], [J.add(J.gp(v_top_1010, 0.0), J.mul(0.4, v_H_1000)), J.sub(J.gp(v_top_1010, 1.0), J.mul(0.04, v_H_1000))]], "#5a3a1a", J.mul(0.06, v_H_1000), 382.0])
	J.mc(v_N_997, "whole", [v_ctx_995, v_S_998, v_f_1005, null, 0.3])
	v_T_1006 = J.mc(v_N_997, "tgt", [v_S_998, 0.75])
	v_p_1007 = J.sub(v_t_999, J.gp(v_N_997, "TC"))
	var _t397 = J.cmp(v_p_1007, 0.0, ">=")
	if (J.cmp(v_p_1007, 0.3, "<") if _t397 else _t397):
		v_i_1011 = 0.0
		while true:
			if not J.cmp(v_i_1011, 3.0, "<"): break
			v_k_1012 = J.mc(v_N_997, "cl", [(J.div(v_p_1007, 0.3) - J.mul(v_i_1011, 0.15))])
			var _t398 = J.cmp(v_k_1012, 0.0, ">")
			if (J.cmp(v_k_1012, 1.0, "<") if _t398 else _t398):
				J.mc(v_N_997, "ring", [v_ctx_995, J.sub(J.gp(v_T_1006, 0.0), J.mul(0.2, v_th_1001)), J.gp(v_T_1006, 1.0), J.mul((0.1 + J.mul(v_k_1012, 0.35)), v_th_1001), J.mul((0.15 + J.mul(v_k_1012, 0.5)), v_th_1001), "rgba(220,255,220,.8)", J.mul(0.02, v_th_1001), J.sub(1.0, v_k_1012)])
			v_i_1011 = J.num(v_i_1011) + 1.0
	var _t399 = J.cmp(v_p_1007, 0.0, ">=")
	if (J.cmp(v_p_1007, 0.13, "<") if _t399 else _t399):
		J.mc(v_N_997, "burst", [v_ctx_995, J.gp(v_T_1006, 0.0), J.gp(v_T_1006, 1.0), J.mul(0.3, v_th_1001), (1.0 - J.div(v_p_1007, 0.13)), "#e0ffd8", 385.0, 9.0])
	J.mc(v_N_997, "pop", [v_ctx_995, v_S_998, J.gp(v_T_1006, 0.0), J.sub(J.gp(v_T_1006, 1.0), J.mul(0.4, v_th_1001)), "嘎！", J.mul(0.26, v_th_1001), "#d8ffc8", J.gp(v_N_997, "TC"), 0.3])
	J.mc(v_N_997, "hit", [v_S_998, J.gp(v_T_1006, 0.0), J.gp(v_T_1006, 1.0)])
	J.mc(J.G.get("N30M"), "end", [v_ctx_995])

func _f73(this_, a: Array, env):
	var v_ctx_1015 = null; var v_a_1016 = null; var v_N_1017 = null; var v_S_1018 = null; var v_t_1019 = null; var v_H_1020 = null; var v_th_1021 = null; var v_f_1022 = null; var v_m_1023 = null; var v_dish_1024 = null; var v_T_1025 = null; var v_q_1026 = null; var v_p_1027 = null; var v_i_1028 = null; var v_k_1029 = null; var v_x_1030 = null; var v_y_1031 = null
	v_ctx_1015 = J.arg(a, 0)
	v_a_1016 = J.arg(a, 1)
	v_N_1017 = J.G.get("N30K")
	v_S_1018 = J.mc(v_N_1017, "setup", [v_a_1016])
	if (not J.t(v_S_1018)):
		return false
	v_t_1019 = J.gp(v_S_1018, "tt")
	v_H_1020 = J.gp(v_S_1018, "H")
	v_th_1021 = J.gp(v_S_1018, "th")
	v_f_1022 = J.mc(v_N_1017, "kf", [v_t_1019, [[0.0, {}], [0.1, {"r": (-5.0), "head": (-0.1)}], [0.24, {"r": 28.0, "body": 0.35, "head": 0.35, "armF": 0.4, "armB": (-0.3), "x": J.mul(0.04, v_H_1020)}, "o"], [0.36, {"r": 26.0, "body": 0.3, "head": 0.3, "x": J.mul(0.04, v_H_1020)}], [0.5, {"r": (-3.0), "head": (-0.05), "armF": (-0.9)}], [0.59, {}]]])
	J.sp(v_f_1022, "px", 0.0)
	J.sp(v_f_1022, "py", 0.0)
	J.mc(J.G.get("N30M"), "begin", [v_ctx_1015, v_S_1018, J.gp(v_f_1022, "x")])
	J.mc(v_N_1017, "whole", [v_ctx_1015, v_S_1018, v_f_1022, null, 0.3])
	v_m_1023 = J.mc(v_N_1017, "bm", [v_S_1018, v_f_1022])
	v_dish_1024 = J.mc(v_N_1017, "at", [v_S_1018, v_m_1023, 0.47, 0.05])
	v_T_1025 = J.mc(v_N_1017, "tgt", [v_S_1018, 0.75])
	v_q_1026 = J.mc(v_N_1017, "seg", [v_t_1019, 0.2, J.gp(v_N_1017, "TC")])
	var _t402 = J.cmp(v_t_1019, 0.2, ">")
	if (J.cmp(v_t_1019, J.add(J.gp(v_N_1017, "TC"), 0.02), "<") if _t402 else _t402):
		v_i_1028 = 0.0
		while true:
			if not J.cmp(v_i_1028, 10.0, "<"): break
			v_k_1029 = J.mc(v_N_1017, "cl", [J.sub(v_q_1026, J.mul(v_i_1028, 0.04))])
			v_x_1030 = J.mc(v_N_1017, "lerp", [J.gp(v_dish_1024, 0.0), J.gp(v_T_1025, 0.0), v_k_1029])
			v_y_1031 = J.sub(J.mc(v_N_1017, "lerp", [J.gp(v_dish_1024, 1.0), J.add(J.gp(v_T_1025, 1.0), J.mul((J.sub(J.mc(v_N_1017, "rnd", [v_i_1028]), 0.5) * 0.3), v_th_1021)), v_k_1029]), (J.mul(0.18, v_H_1020) * sin(J.num(J.mul(v_k_1029, PI)))))
			J.sp(v_ctx_1015, "fillStyle", "rgba(120,190,240,.85)")
			J.sp(v_ctx_1015, "strokeStyle", "rgba(30,70,110,.7)")
			var _t403 = J.mul(0.006, v_H_1020)
			J.sp(v_ctx_1015, "lineWidth", _t403)
			J.mc(v_ctx_1015, "beginPath", [])
			J.mc(v_ctx_1015, "ellipse", [v_x_1030, v_y_1031, J.mul((0.03 + J.mul(J.mc(v_N_1017, "rnd", [J.add(v_i_1028, 3.0)]), 0.025)), v_H_1020), J.mul(0.022, v_H_1020), 0.4, 0.0, 7.0])
			J.mc(v_ctx_1015, "fill", [])
			J.mc(v_ctx_1015, "stroke", [])
			v_i_1028 = J.num(v_i_1028) + 1.0
	v_p_1027 = J.sub(v_t_1019, J.gp(v_N_1017, "TC"))
	J.mc(v_N_1017, "drops", [v_ctx_1015, J.gp(v_T_1025, 0.0), J.gp(v_T_1025, 1.0), J.mul(0.6, v_th_1021), J.mc(v_N_1017, "seg", [v_t_1019, J.gp(v_N_1017, "TC"), 0.5]), "rgba(130,200,250,.95)", 391.0, 12.0, 3.2])
	var _t404 = J.cmp(v_p_1027, 0.0, ">=")
	if (J.cmp(v_p_1027, 0.13, "<") if _t404 else _t404):
		J.mc(v_N_1017, "burst", [v_ctx_1015, J.gp(v_T_1025, 0.0), J.gp(v_T_1025, 1.0), J.mul(0.35, v_th_1021), (1.0 - J.div(v_p_1027, 0.13)), "#c8ecff", 393.0, 10.0])
	J.mc(v_N_1017, "pop", [v_ctx_1015, v_S_1018, J.gp(v_T_1025, 0.0), J.sub(J.gp(v_T_1025, 1.0), J.mul(0.4, v_th_1021)), "嘩啦！", J.mul(0.22, v_th_1021), "#a8dcff", J.gp(v_N_1017, "TC"), 0.3])
	J.mc(v_N_1017, "pop", [v_ctx_1015, v_S_1018, J.gp(v_dish_1024, 0.0), J.sub(J.gp(v_dish_1024, 1.0), J.mul(0.12, v_H_1020)), "我啲水呀！", J.mul(0.1, v_H_1020), "#a8dcff", 0.47, 0.12])
	J.mc(v_N_1017, "hit", [v_S_1018, J.gp(v_T_1025, 0.0), J.gp(v_T_1025, 1.0)])
	J.mc(J.G.get("N30M"), "end", [v_ctx_1015])

func _f74(this_, a: Array, env):
	var v_ctx_1034 = null; var v_a_1035 = null; var v_N_1036 = null; var v_S_1037 = null; var v_key_1038 = null; var v_t_1039 = null; var v_H_1040 = null; var v_th_1041 = null; var v_AP_1042 = null; var v_HC_1043 = null; var v_SRC_1044 = null; var v_f_1045 = null; var v_m_1046 = null; var v_A0_1047 = null; var v_B_1048 = null; var v_T_1049 = null; var v_ho_1050 = null; var v_G_1051 = null; var v_wob_1052 = null; var v_P_1053 = null; var v_b_1054 = null; var v_Ap_1055 = null; var v_ctrl_1056 = null; var v_p_1057 = null
	v_ctx_1034 = J.arg(a, 0)
	v_a_1035 = J.arg(a, 1)
	v_N_1036 = J.G.get("N30K")
	v_S_1037 = J.mc(v_N_1036, "setup", [v_a_1035])
	if (not J.t(v_S_1037)):
		return false
	v_key_1038 = J.mc(J.G.get("N30"), "body", [J.gp(v_S_1037, "id")])
	if (not J.t(v_key_1038)):
		return false
	v_t_1039 = J.gp(v_S_1037, "tt")
	v_H_1040 = J.gp(v_S_1037, "H")
	v_th_1041 = J.gp(v_S_1037, "th")
	v_AP_1042 = [0.43, 0.3]
	v_HC_1043 = [0.22, 0.27]
	v_SRC_1044 = [[0.43, 0.3], [0.52, 0.275], [0.61, 0.265], [0.7, 0.285], [0.735, 0.345], [0.715, 0.41], [0.66, 0.46], [0.615, 0.51], [0.6, 0.585]]
	v_f_1045 = J.mc(v_N_1036, "kf", [v_t_1039, [[0.0, {}], [0.16, {"r": (-4.0), "armF": 0.2, "armB": (-0.2)}], [J.gp(v_N_1036, "TC"), {"r": 6.0, "x": J.mul(0.02, v_H_1040)}, "i"], [0.59, {}]]])
	v_m_1046 = J.mc(v_N_1036, "bm", [v_S_1037, v_f_1045])
	v_A0_1047 = J.mc(v_N_1036, "at", [v_S_1037, v_m_1046, J.gp(v_AP_1042, 0.0), J.gp(v_AP_1042, 1.0)])
	v_B_1048 = J.mc(v_N_1036, "at", [v_S_1037, v_m_1046, 0.6, 0.585])
	v_T_1049 = J.mc(v_N_1036, "tgt", [v_S_1037, 0.85])
	v_ho_1050 = [J.mul(((1.0 if J.t(J.gp(v_S_1037, "nr")) else (-1.0)) * J.sub(J.gp(v_HC_1043, 0.0), J.gp(v_AP_1042, 0.0))), J.gp(v_S_1037, "W")), J.mul(J.sub(J.gp(v_HC_1043, 1.0), J.gp(v_AP_1042, 1.0)), J.gp(v_S_1037, "H"))]
	v_G_1051 = [(J.sub(J.gp(v_T_1049, 0.0), J.gp(v_ho_1050, 0.0)) - J.mul(0.12, v_th_1041)), J.sub(J.gp(v_T_1049, 1.0), J.gp(v_ho_1050, 1.0))]
	var _t407 = J.cmp(v_t_1039, J.gp(v_N_1036, "TC"), ">")
	v_wob_1052 = ((J.mul((sin(J.num((J.sub(v_t_1039, J.gp(v_N_1036, "TC")) * 40.0))) * 0.05), v_H_1040) * J.sub(1.0, J.mc(v_N_1036, "seg", [v_t_1039, J.gp(v_N_1036, "TC"), 0.45]))) if (J.cmp(v_t_1039, 0.45, "<") if _t407 else _t407) else 0.0)
	v_P_1053 = J.mc(v_N_1036, "kf", [v_t_1039, [[0.0, {"x": J.gp(v_A0_1047, 0.0), "y": J.gp(v_A0_1047, 1.0), "r": 0.0}], [0.16, {"x": J.sub(J.gp(v_A0_1047, 0.0), J.mul(0.1, v_H_1040)), "y": J.sub(J.gp(v_A0_1047, 1.0), J.mul(0.22, v_H_1040)), "r": (-15.0)}], [J.gp(v_N_1036, "TC"), {"x": J.gp(v_G_1051, 0.0), "y": J.gp(v_G_1051, 1.0), "r": 18.0}, "i"], [0.33, {"x": J.sub(J.gp(v_G_1051, 0.0), J.mul(0.03, v_H_1040)), "y": J.sub(J.gp(v_G_1051, 1.0), J.mul(0.02, v_H_1040)), "r": 8.0}], [0.59, {"x": J.gp(v_A0_1047, 0.0), "y": J.gp(v_A0_1047, 1.0), "r": 0.0}]]])
	v_b_1054 = J.gp(J.mc(v_N_1036, "kf", [v_t_1039, [[0.0, {"v": 0.0}], [0.05, {"v": 1.0}], [0.54, {"v": 1.0}], [0.59, {"v": 0.0}]]]), "v")
	v_Ap_1055 = [J.gp(v_P_1053, "x"), J.add(J.gp(v_P_1053, "y"), v_wob_1052)]
	v_ctrl_1056 = [(J.div(J.add(J.gp(v_Ap_1055, 0.0), J.gp(v_B_1048, 0.0)), 2.0) + J.mul(0.05, v_H_1040)), (J.min_([J.gp(v_Ap_1055, 1.0), J.gp(v_B_1048, 1.0)]) - (J.mul(0.25, v_H_1040) * (1.0 - J.mul(J.mc(v_N_1036, "seg", [v_t_1039, 0.16, J.gp(v_N_1036, "TC")]), 0.6))))]
	J.mc(J.G.get("N30M"), "begin", [v_ctx_1034, v_S_1037, J.gp(v_f_1045, "x")])
	J.mc(v_N_1036, "body", [v_ctx_1034, v_S_1037, v_m_1046, J.mc(v_N_1036, "pose", [v_S_1037, v_f_1045, 0.3]), v_key_1038])
	J.mc(v_N_1036, "ribbon", [v_ctx_1034, v_S_1037, "neck", v_SRC_1044, 0.03, J.mc(J.G.get("N30M"), "line", [v_S_1037, v_m_1046, v_SRC_1044, v_Ap_1055, v_ctrl_1056, v_B_1048, v_b_1054])])
	J.mc(v_N_1036, "pieceAt", [v_ctx_1034, v_S_1037, "head", J.gp(v_Ap_1055, 0.0), J.gp(v_Ap_1055, 1.0), J.gp(v_P_1053, "r"), J.gp(v_AP_1042, 0.0), J.gp(v_AP_1042, 1.0)])
	v_p_1057 = J.sub(v_t_1039, J.gp(v_N_1036, "TC"))
	var _t408 = J.cmp(v_p_1057, 0.0, ">=")
	if (J.cmp(v_p_1057, 0.13, "<") if _t408 else _t408):
		J.mc(v_N_1036, "burst", [v_ctx_1034, J.sub(J.gp(v_T_1049, 0.0), J.mul(0.1, v_th_1041)), J.gp(v_T_1049, 1.0), J.mul(0.3, v_th_1041), (1.0 - J.div(v_p_1057, 0.13)), "#ffe8f0", 401.0, 10.0])
	var _t409 = J.cmp(v_p_1057, 0.0, ">=")
	if (J.cmp(v_p_1057, 0.3, "<") if _t409 else _t409):
		J.mc(v_N_1036, "stars", [v_ctx_1034, J.gp(v_T_1049, 0.0), J.sub(J.gp(v_T_1049, 1.0), J.mul(0.2, v_th_1041)), J.mul(0.18, v_th_1041), v_t_1039, (1.0 - J.div(v_p_1057, 0.3))])
	J.mc(v_N_1036, "pop", [v_ctx_1034, v_S_1037, J.gp(v_T_1049, 0.0), J.sub(J.gp(v_T_1049, 1.0), J.mul(0.45, v_th_1041)), "咚！", J.mul(0.24, v_th_1041), "#ffd0e0", J.gp(v_N_1036, "TC"), 0.28])
	J.mc(v_N_1036, "hit", [v_S_1037, J.gp(v_T_1049, 0.0), J.gp(v_T_1049, 1.0)])
	J.mc(J.G.get("N30M"), "end", [v_ctx_1034])

func _f75(this_, a: Array, env):
	var v_ctx_1060 = null; var v_a_1061 = null; var v_N_1062 = null; var v_S_1063 = null; var v_key_1064 = null; var v_t_1065 = null; var v_H_1066 = null; var v_th_1067 = null; var v_PV_1068 = null; var v_f_1069 = null; var v_m_1070 = null; var v_w0_1071 = null; var v_T_1072 = null; var v_L_1073 = null; var v_ang_1074 = null; var v_dir_1075 = null; var v_G_1076 = null; var v_W_1077 = null; var v_hd_1078 = null; var v_p_1079 = null; var v_k_1080 = null; var v_al_1081 = null; var v_r_1082 = null; var v_sg_1083 = null; var v_i_1084 = null
	v_ctx_1060 = J.arg(a, 0)
	v_a_1061 = J.arg(a, 1)
	v_N_1062 = J.G.get("N30K")
	v_S_1063 = J.mc(v_N_1062, "setup", [v_a_1061])
	if (not J.t(v_S_1063)):
		return false
	v_key_1064 = J.mc(J.G.get("N30"), "body", [J.gp(v_S_1063, "id")])
	if (not J.t(v_key_1064)):
		return false
	v_t_1065 = J.gp(v_S_1063, "tt")
	v_H_1066 = J.gp(v_S_1063, "H")
	v_th_1067 = J.gp(v_S_1063, "th")
	v_PV_1068 = [0.21, 0.53]
	v_f_1069 = J.mc(v_N_1062, "kf", [v_t_1065, [[0.0, {}], [0.16, {"head": (-0.25), "r": (-4.0), "hairL": 0.1, "hairR": 0.1}], [J.gp(v_N_1062, "TC"), {"head": 0.12, "r": 9.0, "x": J.mul(0.12, v_H_1066), "legF": 0.25, "legB": (-0.15), "hairL": (-0.25), "hairR": (-0.3)}, "i"], [0.36, {"head": 0.1, "r": 8.0, "x": J.mul(0.12, v_H_1066), "legF": 0.22, "legB": (-0.12)}], [0.59, {}]]])
	v_m_1070 = J.mc(v_N_1062, "bm", [v_S_1063, v_f_1069])
	v_w0_1071 = J.mc(v_N_1062, "at", [v_S_1063, v_m_1070, J.gp(v_PV_1068, 0.0), J.gp(v_PV_1068, 1.0)])
	v_T_1072 = J.mc(v_N_1062, "tgt", [v_S_1063, 0.72])
	v_L_1073 = J.mul(0.32, v_H_1066)
	v_ang_1074 = 40.0
	v_dir_1075 = J.mul(J.add((-60.0), v_ang_1074), J.gp(v_N_1062, "D"))
	v_G_1076 = [J.sub(J.gp(v_T_1072, 0.0), J.mul(v_L_1073, cos(J.num(v_dir_1075)))), J.sub(J.gp(v_T_1072, 1.0), J.mul(v_L_1073, sin(J.num(v_dir_1075))))]
	v_W_1077 = J.mc(v_N_1062, "kf", [v_t_1065, [[0.0, {"x": J.gp(v_w0_1071, 0.0), "y": J.gp(v_w0_1071, 1.0), "r": 0.0}], [0.16, {"x": J.sub(J.gp(v_w0_1071, 0.0), J.mul(0.05, v_H_1066)), "y": J.sub(J.gp(v_w0_1071, 1.0), J.mul(0.12, v_H_1066)), "r": (-25.0)}], [J.gp(v_N_1062, "TC"), {"x": J.gp(v_G_1076, 0.0), "y": J.gp(v_G_1076, 1.0), "r": v_ang_1074}, "i"], [0.36, {"x": J.sub(J.gp(v_G_1076, 0.0), J.mul(0.02, v_H_1066)), "y": J.gp(v_G_1076, 1.0), "r": J.sub(v_ang_1074, 5.0)}], [0.59, {"x": J.gp(v_w0_1071, 0.0), "y": J.gp(v_w0_1071, 1.0), "r": 0.0}]]])
	J.mc(J.G.get("N30M"), "begin", [v_ctx_1060, v_S_1063, J.gp(v_f_1069, "x")])
	J.mc(v_N_1062, "body", [v_ctx_1060, v_S_1063, v_m_1070, J.mc(v_N_1062, "pose", [v_S_1063, v_f_1069, 0.3]), v_key_1064])
	J.mc(v_N_1062, "pieceAt", [v_ctx_1060, v_S_1063, "scissors", J.gp(v_W_1077, "x"), J.gp(v_W_1077, "y"), J.gp(v_W_1077, "r"), J.gp(v_PV_1068, 0.0), J.gp(v_PV_1068, 1.0)])
	v_hd_1078 = J.mc(v_N_1062, "at", [v_S_1063, v_m_1070, 0.45, 0.12])
	J.mc(v_N_1062, "pop", [v_ctx_1060, v_S_1063, J.sub(J.gp(v_hd_1078, 0.0), J.mul(0.05, v_H_1066)), J.sub(J.gp(v_hd_1078, 1.0), J.mul(0.12, v_H_1066)), "我靚唔靚？", J.mul(0.1, v_H_1066), "#ffe0e0", 0.02, 0.24])
	v_p_1079 = J.sub(v_t_1065, J.gp(v_N_1062, "TC"))
	var _t412 = J.cmp(v_p_1079, 0.0, ">=")
	if (J.cmp(v_p_1079, 0.2, "<") if _t412 else _t412):
		v_k_1080 = J.min_([1.0, J.div(v_p_1079, 0.05)])
		v_al_1081 = (1.0 - J.div(v_p_1079, 0.2))
		v_r_1082 = J.mul(0.2, v_th_1067)
		for _t413 in J.iter([(-1.0), 1.0]):
			v_sg_1083 = _t413
			J.mc(v_N_1062, "crayon", [v_ctx_1060, [[J.sub(J.gp(v_T_1072, 0.0), v_r_1082), J.add(J.gp(v_T_1072, 1.0), (J.mul(v_sg_1083, v_r_1082) * J.sub(1.0, v_k_1080)))], [J.add(J.gp(v_T_1072, 0.0), v_r_1082), J.sub(J.gp(v_T_1072, 1.0), (J.mul(v_sg_1083, v_r_1082) * J.sub(1.0, v_k_1080)))]], "rgba(255,255,255,.95)", J.mul(0.03, v_th_1067), J.add(411.0, v_sg_1083), v_al_1081])
	var _t414 = J.cmp(v_p_1079, 0.0, ">=")
	if (J.cmp(v_p_1079, 0.35, "<") if _t414 else _t414):
		v_i_1084 = 0.0
		while true:
			if not J.cmp(v_i_1084, 4.0, "<"): break
			J.mc(v_N_1062, "crayon", [v_ctx_1060, [[J.add(J.gp(v_T_1072, 0.0), J.mul((J.sub(v_i_1084, 1.5) * 0.04), v_th_1067)), J.add(J.add(J.gp(v_T_1072, 1.0), J.mul(J.mul(v_p_1079, 0.6), v_th_1067)), J.mul(J.mul(v_i_1084, 0.02), v_th_1067))], [J.add(J.add(J.gp(v_T_1072, 0.0), J.mul((J.sub(v_i_1084, 1.5) * 0.04), v_th_1067)), J.mul(0.05, v_th_1067)), J.add(J.add(J.gp(v_T_1072, 1.0), J.mul(J.mul(v_p_1079, 0.6), v_th_1067)), J.mul(0.06, v_th_1067))]], "#2a2020", J.mul(0.008, v_th_1067), J.add(415.0, v_i_1084), (1.0 - J.div(v_p_1079, 0.35))])
			v_i_1084 = J.num(v_i_1084) + 1.0
	var _t415 = J.cmp(v_p_1079, 0.0, ">=")
	if (J.cmp(v_p_1079, 0.12, "<") if _t415 else _t415):
		J.mc(v_N_1062, "burst", [v_ctx_1060, J.gp(v_T_1072, 0.0), J.gp(v_T_1072, 1.0), J.mul(0.28, v_th_1067), (1.0 - J.div(v_p_1079, 0.12)), "#ffffff", 419.0, 8.0])
	J.mc(v_N_1062, "pop", [v_ctx_1060, v_S_1063, J.gp(v_T_1072, 0.0), J.sub(J.gp(v_T_1072, 1.0), J.mul(0.38, v_th_1067)), "咔嚓！", J.mul(0.22, v_th_1067), "#ffffff", J.gp(v_N_1062, "TC"), 0.3])
	J.mc(v_N_1062, "hit", [v_S_1063, J.gp(v_T_1072, 0.0), J.gp(v_T_1072, 1.0)])
	J.mc(J.G.get("N30M"), "end", [v_ctx_1060])

func _f76(this_, a: Array, env):
	var v_ctx_1087 = null; var v_a_1088 = null; var v_N_1089 = null; var v_S_1090 = null; var v_t_1091 = null; var v_H_1092 = null; var v_th_1093 = null; var v_f_1094 = null; var v_m_1095 = null; var v_mo_1096 = null; var v_T_1097 = null; var v_reach_1098 = null; var v_fade_1099 = null; var v_p_1100 = null; var v_ex_1101 = null; var v_ey_1102 = null; var v_i_1103 = null; var v_pts_1104 = null; var v_j_1105 = null; var v_q_1106 = null; var v_w_1107 = null; var v_i_1108 = null; var v_q_1109 = null; var v_x_1110 = null; var v_y_1111 = null; var v_r_1112 = null; var v_k_1113 = null; var v_an_1114 = null; var v_al_1115 = null; var v_k_1116 = null; var v_i_1117 = null; var v_x_1118 = null; var v_y_1119 = null; var v_h_1120 = null; var v_an_1121 = null
	v_ctx_1087 = J.arg(a, 0)
	v_a_1088 = J.arg(a, 1)
	v_N_1089 = J.G.get("N30K")
	v_S_1090 = J.mc(v_N_1089, "setup", [v_a_1088])
	if (not J.t(v_S_1090)):
		return false
	v_t_1091 = J.gp(v_S_1090, "tt")
	v_H_1092 = J.gp(v_S_1090, "H")
	v_th_1093 = J.gp(v_S_1090, "th")
	v_f_1094 = J.mc(v_N_1089, "kf", [v_t_1091, [[0.0, {}], [0.17, {"sy": 1.05, "head": (-0.18), "r": (-4.0), "hairR": 0.2}], [0.24, {"sy": 0.98, "head": 0.15, "r": 6.0, "x": J.mul(0.02, v_H_1092), "hairR": (-0.15)}, "o"], [0.42, {"head": 0.12, "r": 5.0}], [0.59, {}]]])
	J.mc(J.G.get("N30M"), "begin", [v_ctx_1087, v_S_1090, J.gp(v_f_1094, "x")])
	J.mc(v_N_1089, "whole", [v_ctx_1087, v_S_1090, v_f_1094, null, 0.35])
	v_m_1095 = J.mc(v_N_1089, "bm", [v_S_1090, v_f_1094])
	v_mo_1096 = J.mc(v_N_1089, "at", [v_S_1090, v_m_1095, 0.42, 0.255])
	v_T_1097 = J.mc(v_N_1089, "tgt", [v_S_1090, 0.65])
	v_reach_1098 = J.mc(v_N_1089, "seg", [v_t_1091, 0.2, J.gp(v_N_1089, "TC")])
	v_fade_1099 = J.sub(1.0, J.mc(v_N_1089, "seg", [v_t_1091, 0.4, 0.55]))
	var _t418 = J.cmp(v_t_1091, 0.2, ">")
	if (J.cmp(v_fade_1099, 0.0, ">") if _t418 else _t418):
		var _t420 = J.gp(v_mo_1096, 0.0)
		var _t421 = J.gp(v_T_1097, 0.0)
		var _t419 = J.gp(v_N_1089, "E")
		v_ex_1101 = J.mc(v_N_1089, "lerp", [_t420, _t421, J.mc(_t419, "o", [v_reach_1098])])
		var _t423 = J.gp(v_mo_1096, 1.0)
		var _t424 = J.gp(v_T_1097, 1.0)
		var _t422 = J.gp(v_N_1089, "E")
		v_ey_1102 = J.mc(v_N_1089, "lerp", [_t423, _t424, J.mc(_t422, "o", [v_reach_1098])])
		v_i_1103 = 0.0
		while true:
			if not J.cmp(v_i_1103, 4.0, "<"): break
			v_pts_1104 = []
			v_j_1105 = 0.0
			while true:
				if not J.cmp(v_j_1105, 10.0, "<="): break
				v_q_1106 = J.div(v_j_1105, 10.0)
				v_w_1107 = J.mul((0.02 + J.mul(v_q_1106, 0.12)), v_H_1092)
				J.mc(v_pts_1104, "push", [[J.mc(v_N_1089, "lerp", [J.gp(v_mo_1096, 0.0), v_ex_1101, v_q_1106]), J.add(J.add(J.mc(v_N_1089, "lerp", [J.gp(v_mo_1096, 1.0), v_ey_1102, v_q_1106]), (J.mul(sin(J.num(((J.mul(v_q_1106, 8.0) + J.mul(v_t_1091, 30.0)) + J.mul(v_i_1103, 1.6)))), v_w_1107) * 0.5)), (J.mul(J.sub(v_i_1103, 1.5), v_w_1107) * 0.4))]])
				v_j_1105 = J.num(v_j_1105) + 1.0
			J.mc(v_ctx_1087, "save", [])
			var _t425 = J.mul(J.gp(v_ctx_1087, "globalAlpha"), J.mul(v_fade_1099, 0.8))
			J.sp(v_ctx_1087, "globalAlpha", _t425)
			J.mc(v_N_1089, "crayon", [v_ctx_1087, v_pts_1104, ("rgba(220,240,255,.85)" if J.t(J.mod(v_i_1103, 2.0)) else "rgba(170,215,255,.8)"), J.mul(0.025, v_H_1092), J.add(421.0, v_i_1103)])
			J.mc(v_ctx_1087, "restore", [])
			v_i_1103 = J.num(v_i_1103) + 1.0
		v_i_1108 = 0.0
		while true:
			if not J.cmp(v_i_1108, 6.0, "<"): break
			v_q_1109 = J.mc(v_N_1089, "cl", [(J.mul(v_reach_1098, 1.1) - J.mul(v_i_1108, 0.12))])
			v_x_1110 = J.mc(v_N_1089, "lerp", [J.gp(v_mo_1096, 0.0), v_ex_1101, v_q_1109])
			v_y_1111 = J.add(J.mc(v_N_1089, "lerp", [J.gp(v_mo_1096, 1.0), v_ey_1102, v_q_1109]), J.mul((sin(J.num((J.mul(v_i_1108, 2.0) + J.mul(v_t_1091, 12.0)))) * 0.05), v_H_1092))
			v_r_1112 = J.mul(0.03, v_H_1092)
			J.mc(v_ctx_1087, "save", [])
			var _t426 = J.mul(J.gp(v_ctx_1087, "globalAlpha"), v_fade_1099)
			J.sp(v_ctx_1087, "globalAlpha", _t426)
			J.mc(v_ctx_1087, "translate", [v_x_1110, v_y_1111])
			J.mc(v_ctx_1087, "rotate", [J.add(J.mul(v_t_1091, 5.0), v_i_1108)])
			J.sp(v_ctx_1087, "strokeStyle", "#eaf6ff")
			var _t427 = J.mul(v_r_1112, 0.25)
			J.sp(v_ctx_1087, "lineWidth", _t427)
			J.mc(v_ctx_1087, "beginPath", [])
			v_k_1113 = 0.0
			while true:
				if not J.cmp(v_k_1113, 3.0, "<"): break
				v_an_1114 = J.div(J.mul(v_k_1113, PI), 3.0)
				J.mc(v_ctx_1087, "moveTo", [J.mul((-cos(J.num(v_an_1114))), v_r_1112), J.mul((-sin(J.num(v_an_1114))), v_r_1112)])
				J.mc(v_ctx_1087, "lineTo", [J.mul(cos(J.num(v_an_1114)), v_r_1112), J.mul(sin(J.num(v_an_1114)), v_r_1112)])
				v_k_1113 = J.num(v_k_1113) + 1.0
			J.mc(v_ctx_1087, "stroke", [])
			J.mc(v_ctx_1087, "restore", [])
			v_i_1108 = J.num(v_i_1108) + 1.0
	v_p_1100 = J.sub(v_t_1091, J.gp(v_N_1089, "TC"))
	if J.cmp(v_p_1100, 0.0, ">="):
		v_al_1115 = J.sub(1.0, J.mc(v_N_1089, "seg", [v_t_1091, 0.48, 0.59]))
		v_k_1116 = J.mc(v_N_1089, "cl", [J.div(v_p_1100, 0.06)])
		J.mc(v_ctx_1087, "save", [])
		var _t428 = J.mul(J.gp(v_ctx_1087, "globalAlpha"), v_al_1115)
		J.sp(v_ctx_1087, "globalAlpha", _t428)
		v_i_1117 = 0.0
		while true:
			if not J.cmp(v_i_1117, 7.0, "<"): break
			v_x_1118 = J.add(J.gp(v_T_1097, 0.0), J.mul((J.sub(J.mc(v_N_1089, "rnd", [J.add(v_i_1117, 430.0)]), 0.5) * 0.4), v_th_1093))
			v_y_1119 = J.add(J.gp(v_T_1097, 1.0), J.mul((J.sub(J.mc(v_N_1089, "rnd", [J.add(v_i_1117, 440.0)]), 0.5) * 0.7), v_th_1093))
			v_h_1120 = J.mul(J.mul((0.08 + J.mul(J.mc(v_N_1089, "rnd", [J.add(v_i_1117, 450.0)]), 0.1)), v_th_1093), v_k_1116)
			v_an_1121 = (J.sub(J.mc(v_N_1089, "rnd", [J.add(v_i_1117, 460.0)]), 0.5) * 1.2)
			J.mc(v_ctx_1087, "save", [])
			J.mc(v_ctx_1087, "translate", [v_x_1118, v_y_1119])
			J.mc(v_ctx_1087, "rotate", [v_an_1121])
			J.sp(v_ctx_1087, "fillStyle", "rgba(200,235,255,.8)")
			J.sp(v_ctx_1087, "strokeStyle", "rgba(80,140,200,.9)")
			var _t429 = J.mul(0.01, v_th_1093)
			J.sp(v_ctx_1087, "lineWidth", _t429)
			J.mc(v_ctx_1087, "beginPath", [])
			J.mc(v_ctx_1087, "moveTo", [0.0, (-J.num(v_h_1120))])
			J.mc(v_ctx_1087, "lineTo", [J.mul(v_h_1120, 0.35), 0.0])
			J.mc(v_ctx_1087, "lineTo", [0.0, J.mul(v_h_1120, 0.4)])
			J.mc(v_ctx_1087, "lineTo", [((-J.num(v_h_1120)) * 0.35), 0.0])
			J.mc(v_ctx_1087, "closePath", [])
			J.mc(v_ctx_1087, "fill", [])
			J.mc(v_ctx_1087, "stroke", [])
			J.mc(v_ctx_1087, "restore", [])
			v_i_1117 = J.num(v_i_1117) + 1.0
		J.mc(v_ctx_1087, "restore", [])
	var _t430 = J.cmp(v_p_1100, 0.0, ">=")
	if (J.cmp(v_p_1100, 0.13, "<") if _t430 else _t430):
		J.mc(v_N_1089, "burst", [v_ctx_1087, J.gp(v_T_1097, 0.0), J.gp(v_T_1097, 1.0), J.mul(0.33, v_th_1093), (1.0 - J.div(v_p_1100, 0.13)), "#e8f6ff", 471.0, 10.0])
	J.mc(v_N_1089, "pop", [v_ctx_1087, v_S_1090, J.gp(v_T_1097, 0.0), J.sub(J.gp(v_T_1097, 1.0), J.mul(0.5, v_th_1093)), "凍！", J.mul(0.24, v_th_1093), "#c8e8ff", J.gp(v_N_1089, "TC"), 0.3])
	J.mc(v_N_1089, "hit", [v_S_1090, J.gp(v_T_1097, 0.0), J.gp(v_T_1097, 1.0)])
	J.mc(J.G.get("N30M"), "end", [v_ctx_1087])

func _f77(this_, a: Array, env):
	var v_ctx_1124 = null; var v_a_1125 = null; var v_N_1126 = null; var v_S_1127 = null; var v_key_1128 = null; var v_t_1129 = null; var v_H_1130 = null; var v_th_1131 = null; var v_D2_1132 = null; var v_SRC_1133 = null; var v_f_1134 = null; var v_m_1135 = null; var v_root_1136 = null; var v_T0_1137 = null; var v_T1_1138 = null; var v_tipR_1139 = null; var v_P_1140 = null; var v_b_1141 = null; var v_tip_1142 = null; var v_ctrl_1143 = null; var v_p_1144 = null
	v_ctx_1124 = J.arg(a, 0)
	v_a_1125 = J.arg(a, 1)
	v_N_1126 = J.G.get("N30K")
	v_S_1127 = J.mc(v_N_1126, "setup", [v_a_1125])
	if (not J.t(v_S_1127)):
		return false
	v_key_1128 = J.mc(J.G.get("N30"), "body", [J.gp(v_S_1127, "id")])
	if (not J.t(v_key_1128)):
		return false
	v_t_1129 = J.gp(v_S_1127, "tt")
	v_H_1130 = J.gp(v_S_1127, "H")
	v_th_1131 = J.gp(v_S_1127, "th")
	v_D2_1132 = J.max_([0.0, (J.sub(J.gp(v_S_1127, "tx"), J.mul(0.35, v_th_1131)) - J.mul(0.35, J.gp(v_S_1127, "W")))])
	v_SRC_1133 = [[0.52, 0.475], [0.6, 0.49], [0.68, 0.53], [0.73, 0.6], [0.735, 0.67], [0.73, 0.72]]
	v_f_1134 = J.mc(v_N_1126, "kf", [v_t_1129, [[0.0, {}], [0.12, {"sy": 0.85, "sx": 1.08, "head": (-0.06)}], [0.19, {"x": J.mul(v_D2_1132, 0.6), "y": J.mul((-0.3), v_H_1130), "sy": 1.08, "sx": 0.95, "r": (-8.0)}, "o"], [0.24, {"x": v_D2_1132, "y": 0.0, "sy": 0.9, "sx": 1.06, "r": 6.0}, "i"], [0.36, {"x": v_D2_1132, "sy": 1.0, "r": 4.0}], [0.46, {"x": J.mul(v_D2_1132, 0.5), "y": J.mul((-0.22), v_H_1130), "sy": 1.05}, "o"], [0.52, {"x": J.mul(v_D2_1132, 0.3), "y": 0.0, "sy": 0.92}, "i"], [0.56, {"x": J.mul(v_D2_1132, 0.1), "y": J.mul((-0.1), v_H_1130)}, "o"], [0.59, {}, "i"]]])
	v_m_1135 = J.mc(v_N_1126, "bm", [v_S_1127, v_f_1134])
	v_root_1136 = J.mc(v_N_1126, "at", [v_S_1127, v_m_1135, 0.52, 0.475])
	v_T0_1137 = J.mc(v_N_1126, "tgt", [v_S_1127, 0.6])
	v_T1_1138 = J.mc(v_N_1126, "tgt", [v_S_1127, 0.95])
	v_tipR_1139 = J.mc(v_N_1126, "at", [v_S_1127, v_m_1135, 0.73, 0.72])
	v_P_1140 = J.mc(v_N_1126, "kf", [v_t_1129, [[0.0, {"x": J.gp(v_tipR_1139, 0.0), "y": J.gp(v_tipR_1139, 1.0)}], [0.22, {"x": J.gp(v_tipR_1139, 0.0), "y": J.gp(v_tipR_1139, 1.0)}], [J.gp(v_N_1126, "TC"), {"x": J.gp(v_T0_1137, 0.0), "y": J.gp(v_T0_1137, 1.0)}, "i"], [0.36, {"x": J.add(J.gp(v_T1_1138, 0.0), J.mul(0.05, v_th_1131)), "y": J.gp(v_T1_1138, 1.0)}], [0.44, {"x": J.gp(v_tipR_1139, 0.0), "y": J.gp(v_tipR_1139, 1.0)}]]])
	if J.cmp(v_t_1129, 0.44, ">"):
		var _t433 = J.gp(v_tipR_1139, 0.0)
		J.sp(v_P_1140, "x", _t433)
		var _t434 = J.gp(v_tipR_1139, 1.0)
		J.sp(v_P_1140, "y", _t434)
	v_b_1141 = J.gp(J.mc(v_N_1126, "kf", [v_t_1129, [[0.0, {"v": 0.0}], [0.22, {"v": 0.0}], [0.25, {"v": 1.0}], [0.4, {"v": 1.0}], [0.44, {"v": 0.0}]]]), "v")
	v_tip_1142 = [J.gp(v_P_1140, "x"), J.gp(v_P_1140, "y")]
	v_ctrl_1143 = [J.div(J.add(J.gp(v_root_1136, 0.0), J.gp(v_tip_1142, 0.0)), 2.0), (J.max_([J.gp(v_root_1136, 1.0), J.gp(v_tip_1142, 1.0)]) + J.mul(0.12, v_H_1130))]
	var _t436 = J.gp(v_f_1134, "x")
	var _t435 = J.gp(v_f_1134, "y")
	J.mc(J.G.get("N30M"), "begin", [v_ctx_1124, v_S_1127, _t436, (1.0 - J.mul(J.mc(v_N_1126, "cl", [J.div((-J.num((_t435 if J.t(_t435) else 0.0))), v_H_1130)]), 0.6))])
	J.mc(v_N_1126, "body", [v_ctx_1124, v_S_1127, v_m_1135, J.mc(v_N_1126, "pose", [v_S_1127, v_f_1134, 0.3]), v_key_1128])
	J.mc(v_N_1126, "ribbon", [v_ctx_1124, v_S_1127, "tongue", v_SRC_1133, 0.045, J.mc(J.G.get("N30M"), "line", [v_S_1127, v_m_1135, v_SRC_1133, v_root_1136, v_ctrl_1143, v_tip_1142, v_b_1141])])
	v_p_1144 = J.sub(v_t_1129, J.gp(v_N_1126, "TC"))
	J.mc(v_N_1126, "drops", [v_ctx_1124, J.gp(v_T0_1137, 0.0), J.gp(v_T0_1137, 1.0), J.mul(0.4, v_th_1131), J.mc(v_N_1126, "seg", [v_t_1129, J.gp(v_N_1126, "TC"), 0.5]), "rgba(220,240,255,.9)", 481.0, 7.0, 1.4])
	var _t437 = J.cmp(v_p_1144, 0.0, ">")
	if (J.cmp(v_p_1144, 0.3, "<") if _t437 else _t437):
		J.mc(v_ctx_1124, "save", [])
		var _t438 = J.mul(J.gp(v_ctx_1124, "globalAlpha"), (1.0 - J.div(v_p_1144, 0.3)))
		J.sp(v_ctx_1124, "globalAlpha", _t438)
		J.sp(v_ctx_1124, "strokeStyle", "rgba(230,245,255,.8)")
		var _t439 = J.mul(0.012, v_th_1131)
		J.sp(v_ctx_1124, "lineWidth", _t439)
		J.mc(v_ctx_1124, "beginPath", [])
		J.mc(v_ctx_1124, "moveTo", [J.gp(v_T0_1137, 0.0), J.gp(v_T0_1137, 1.0)])
		J.mc(v_ctx_1124, "quadraticCurveTo", [J.add(J.gp(v_T0_1137, 0.0), J.mul(0.02, v_th_1131)), J.add(J.gp(v_T0_1137, 1.0), J.mul(0.25, v_th_1131)), J.add(J.gp(v_T0_1137, 0.0), J.mul(0.05, v_th_1131)), J.add(J.gp(v_T0_1137, 1.0), J.mul(0.12, v_th_1131))])
		J.mc(v_ctx_1124, "stroke", [])
		J.mc(v_ctx_1124, "restore", [])
	var _t440 = J.cmp(v_p_1144, 0.0, ">=")
	if (J.cmp(v_p_1144, 0.13, "<") if _t440 else _t440):
		J.mc(v_N_1126, "burst", [v_ctx_1124, J.gp(v_T0_1137, 0.0), J.gp(v_T0_1137, 1.0), J.mul(0.28, v_th_1131), (1.0 - J.div(v_p_1144, 0.13)), "#ffd0d0", 485.0, 8.0])
	J.mc(v_N_1126, "pop", [v_ctx_1124, v_S_1127, J.gp(v_T1_1138, 0.0), J.sub(J.gp(v_T1_1138, 1.0), J.mul(0.2, v_th_1131)), "舔～", J.mul(0.24, v_th_1131), "#ffb0b8", J.add(J.gp(v_N_1126, "TC"), 0.02), 0.3])
	J.mc(v_N_1126, "hit", [v_S_1127, J.gp(v_T0_1137, 0.0), J.gp(v_T0_1137, 1.0)])
	J.mc(J.G.get("N30M"), "end", [v_ctx_1124])

func _f78(this_, a: Array, env):
	var v_ctx_1147 = null; var v_a_1148 = null; var v_N_1149 = null; var v_S_1150 = null; var v_key_1151 = null; var v_t_1152 = null; var v_H_1153 = null; var v_th_1154 = null; var v_PV_1155 = null; var v_f_1156 = null; var v_m_1157 = null; var v_w0_1158 = null; var v_T_1159 = null; var v_RT_1160 = null; var v_v_1161 = null; var v_s_1162 = null; var v_c_1163 = null; var v_G_1164 = null; var v_W_1165 = null; var v_p_1166 = null; var v_i_1167 = null; var v_an_1168 = null; var v_sp_1169 = null; var v_x_1170 = null; var v_y_1171 = null; var v_k_1172 = null
	v_ctx_1147 = J.arg(a, 0)
	v_a_1148 = J.arg(a, 1)
	v_N_1149 = J.G.get("N30K")
	v_S_1150 = J.mc(v_N_1149, "setup", [v_a_1148])
	if (not J.t(v_S_1150)):
		return false
	v_key_1151 = J.mc(J.G.get("N30"), "body", [J.gp(v_S_1150, "id")])
	if (not J.t(v_key_1151)):
		return false
	v_t_1152 = J.gp(v_S_1150, "tt")
	v_H_1153 = J.gp(v_S_1150, "H")
	v_th_1154 = J.gp(v_S_1150, "th")
	v_PV_1155 = [0.24, 0.66]
	v_f_1156 = J.mc(v_N_1149, "kf", [v_t_1152, [[0.0, {}], [0.16, {"r": (-6.0), "x": J.mul((-0.03), v_H_1153), "armF": 0.35, "head": (-0.08)}], [J.gp(v_N_1149, "TC"), {"r": 9.0, "x": J.mul(0.1, v_H_1153), "armF": (-0.4), "head": 0.1, "legF": 0.25, "legB": (-0.15)}, "i"], [0.36, {"r": 8.0, "x": J.mul(0.1, v_H_1153), "armF": (-0.45), "legF": 0.22, "legB": (-0.12)}], [0.59, {}]]])
	v_m_1157 = J.mc(v_N_1149, "bm", [v_S_1150, v_f_1156])
	v_w0_1158 = J.mc(v_N_1149, "at", [v_S_1150, v_m_1157, J.gp(v_PV_1155, 0.0), J.gp(v_PV_1155, 1.0)])
	v_T_1159 = J.mc(v_N_1149, "tgt", [v_S_1150, 0.72])
	v_RT_1160 = (-120.0)
	v_v_1161 = J.mul(0.16, v_H_1153)
	v_s_1162 = sin(J.num(J.mul(v_RT_1160, J.gp(v_N_1149, "D"))))
	v_c_1163 = cos(J.num(J.mul(v_RT_1160, J.gp(v_N_1149, "D"))))
	v_G_1164 = [J.sub(J.add(J.gp(v_T_1159, 0.0), J.mul(v_v_1161, v_s_1162)), J.mul(0.04, v_th_1154)), J.sub(J.gp(v_T_1159, 1.0), J.mul(v_v_1161, v_c_1163))]
	v_W_1165 = J.mc(v_N_1149, "kf", [v_t_1152, [[0.0, {"x": J.gp(v_w0_1158, 0.0), "y": J.gp(v_w0_1158, 1.0), "r": 0.0}], [0.16, {"x": J.sub(J.gp(v_w0_1158, 0.0), J.mul(0.12, v_H_1153)), "y": J.sub(J.gp(v_w0_1158, 1.0), J.mul(0.04, v_H_1153)), "r": 75.0}], [J.gp(v_N_1149, "TC"), {"x": J.gp(v_G_1164, 0.0), "y": J.gp(v_G_1164, 1.0), "r": v_RT_1160}, "i"], [0.36, {"x": J.add(J.gp(v_G_1164, 0.0), J.mul(0.02, v_H_1153)), "y": J.sub(J.gp(v_G_1164, 1.0), J.mul(0.03, v_H_1153)), "r": J.sub(v_RT_1160, 15.0)}], [0.59, {"x": J.gp(v_w0_1158, 0.0), "y": J.gp(v_w0_1158, 1.0), "r": 0.0}]]])
	J.mc(J.G.get("N30M"), "begin", [v_ctx_1147, v_S_1150, J.gp(v_f_1156, "x")])
	J.mc(v_N_1149, "body", [v_ctx_1147, v_S_1150, v_m_1157, J.mc(v_N_1149, "pose", [v_S_1150, v_f_1156, 0.3]), v_key_1151])
	var _t443 = J.cmp(v_t_1152, 0.17, ">")
	if (J.cmp(v_t_1152, 0.3, "<") if _t443 else _t443):
		J.mc(v_N_1149, "speed", [v_ctx_1147, J.gp(v_W_1165, "x"), J.sub(J.gp(v_W_1165, "y"), J.mul(0.1, v_H_1153)), 0.6, (-1.0), J.mul(0.3, v_H_1153), J.mul(0.15, v_H_1153), J.mc(v_N_1149, "seg", [v_t_1152, 0.17, 0.21]), "rgba(230,230,240,.7)", 491.0, 4.0])
	J.mc(v_N_1149, "pieceAt", [v_ctx_1147, v_S_1150, "case", J.gp(v_W_1165, "x"), J.gp(v_W_1165, "y"), J.gp(v_W_1165, "r"), J.gp(v_PV_1155, 0.0), J.gp(v_PV_1155, 1.0)])
	v_p_1166 = J.sub(v_t_1152, J.gp(v_N_1149, "TC"))
	var _t444 = J.cmp(v_p_1166, 0.0, ">=")
	if (J.cmp(v_p_1166, 0.4, "<") if _t444 else _t444):
		v_i_1167 = 0.0
		while true:
			if not J.cmp(v_i_1167, 6.0, "<"): break
			v_an_1168 = ((-PI) * (0.2 + J.mul(0.6, J.mc(v_N_1149, "rnd", [J.add(v_i_1167, 500.0)]))))
			v_sp_1169 = J.mul(J.mul(J.add(0.5, J.mc(v_N_1149, "rnd", [J.add(v_i_1167, 510.0)])), 1.0), v_th_1154)
			v_x_1170 = J.add(J.gp(v_T_1159, 0.0), J.mul(J.mul(cos(J.num(v_an_1168)), v_sp_1169), v_p_1166))
			v_y_1171 = J.add(J.add(J.gp(v_T_1159, 1.0), J.mul(J.mul(sin(J.num(v_an_1168)), v_sp_1169), v_p_1166)), J.mul(J.mul(J.mul(1.5, v_th_1154), v_p_1166), v_p_1166))
			J.mc(v_ctx_1147, "save", [])
			var _t445 = J.mul(J.gp(v_ctx_1147, "globalAlpha"), (1.0 - J.div(v_p_1166, 0.4)))
			J.sp(v_ctx_1147, "globalAlpha", _t445)
			J.mc(v_ctx_1147, "translate", [v_x_1170, v_y_1171])
			J.mc(v_ctx_1147, "rotate", [J.add(J.mul(v_p_1166, 12.0), v_i_1167)])
			J.sp(v_ctx_1147, "fillStyle", "#fbfbf6")
			J.sp(v_ctx_1147, "strokeStyle", "#4a4a5a")
			var _t446 = J.mul(0.008, v_th_1154)
			J.sp(v_ctx_1147, "lineWidth", _t446)
			J.mc(v_ctx_1147, "fillRect", [J.mul((-0.05), v_th_1154), J.mul((-0.065), v_th_1154), J.mul(0.1, v_th_1154), J.mul(0.13, v_th_1154)])
			J.mc(v_ctx_1147, "strokeRect", [J.mul((-0.05), v_th_1154), J.mul((-0.065), v_th_1154), J.mul(0.1, v_th_1154), J.mul(0.13, v_th_1154)])
			J.mc(v_ctx_1147, "beginPath", [])
			v_k_1172 = 0.0
			while true:
				if not J.cmp(v_k_1172, 3.0, "<"): break
				J.mc(v_ctx_1147, "moveTo", [J.mul((-0.03), v_th_1154), (J.mul((-0.03), v_th_1154) + J.mul(J.mul(v_k_1172, 0.03), v_th_1154))])
				J.mc(v_ctx_1147, "lineTo", [J.mul(0.03, v_th_1154), (J.mul((-0.03), v_th_1154) + J.mul(J.mul(v_k_1172, 0.03), v_th_1154))])
				v_k_1172 = J.num(v_k_1172) + 1.0
			J.mc(v_ctx_1147, "stroke", [])
			J.mc(v_ctx_1147, "restore", [])
			v_i_1167 = J.num(v_i_1167) + 1.0
	var _t447 = J.cmp(v_p_1166, 0.0, ">=")
	if (J.cmp(v_p_1166, 0.13, "<") if _t447 else _t447):
		J.mc(v_N_1149, "burst", [v_ctx_1147, J.gp(v_T_1159, 0.0), J.gp(v_T_1159, 1.0), J.mul(0.3, v_th_1154), (1.0 - J.div(v_p_1166, 0.13)), "#f0f0ff", 521.0, 9.0])
	J.mc(v_N_1149, "pop", [v_ctx_1147, v_S_1150, J.gp(v_T_1159, 0.0), J.sub(J.gp(v_T_1159, 1.0), J.mul(0.45, v_th_1154)), "返工！", J.mul(0.22, v_th_1154), "#e8e8ff", J.gp(v_N_1149, "TC"), 0.3])
	J.mc(v_N_1149, "hit", [v_S_1150, J.gp(v_T_1159, 0.0), J.gp(v_T_1159, 1.0)])
	J.mc(J.G.get("N30M"), "end", [v_ctx_1147])

func _f79(this_, a: Array, env):
	var v_ctx_1175 = null; var v_a_1176 = null; var v_N_1177 = null; var v_S_1178 = null; var v_t_1179 = null; var v_H_1180 = null; var v_th_1181 = null; var v_D2_1182 = null; var v_f_1183 = null; var v_glow_1184 = null; var v_T_1185 = null; var v_p_1186 = null; var v_g_1187 = null; var v_i_1188 = null; var v_k_1189 = null; var v_x_1190 = null; var v_y_1191 = null; var v_r_1192 = null
	v_ctx_1175 = J.arg(a, 0)
	v_a_1176 = J.arg(a, 1)
	v_N_1177 = J.G.get("N30K")
	v_S_1178 = J.mc(v_N_1177, "setup", [v_a_1176])
	if (not J.t(v_S_1178)):
		return false
	v_t_1179 = J.gp(v_S_1178, "tt")
	v_H_1180 = J.gp(v_S_1178, "H")
	v_th_1181 = J.gp(v_S_1178, "th")
	v_D2_1182 = J.max_([0.0, (J.sub(J.gp(v_S_1178, "tx"), J.mul(0.3, v_th_1181)) - J.mul(0.4, J.gp(v_S_1178, "W")))])
	v_f_1183 = J.mc(v_N_1177, "kf", [v_t_1179, [[0.0, {}], [0.17, {"sx": 1.12, "sy": 1.1, "r": (-8.0), "x": J.mul((-0.03), v_H_1180), "tongue": 0.3, "flame": 0.3}], [0.24, {"sx": 1.08, "sy": 1.15, "r": 10.0, "x": J.mul(v_D2_1182, 0.8), "tongue": (-0.3)}, "o"], [J.gp(v_N_1177, "TC"), {"sx": 1.15, "sy": 0.78, "r": 12.0, "x": v_D2_1182, "tongue": 0.1}, "i"], [0.36, {"sx": 1.0, "sy": 1.05, "r": 8.0, "x": v_D2_1182}], [0.59, {}]]])
	J.sp(v_f_1183, "px", 0.0)
	var _t450 = J.mul((-0.5), v_H_1180)
	J.sp(v_f_1183, "py", _t450)
	J.mc(J.G.get("N30M"), "begin", [v_ctx_1175, v_S_1178, J.gp(v_f_1183, "x")])
	v_glow_1184 = J.gp(J.mc(v_N_1177, "kf", [v_t_1179, [[0.0, {"v": 0.0}], [0.17, {"v": 1.0}], [0.36, {"v": 1.0}], [0.59, {"v": 0.0}]]]), "v")
	if J.cmp(v_glow_1184, 0.0, ">"):
		var _t451 = J.gp(v_f_1183, "x")
		var _t453 = (_t451 if J.t(_t451) else 0.0)
		var _t454 = J.mul((-0.5), v_H_1180)
		var _t452 = J.gp(v_f_1183, "x")
		v_g_1187 = J.mc(v_ctx_1175, "createRadialGradient", [_t453, _t454, 0.0, (_t452 if J.t(_t452) else 0.0), J.mul((-0.5), v_H_1180), J.mul(0.6, v_H_1180)])
		J.mc(v_g_1187, "addColorStop", [0.0, ("rgba(255,170,60," + J.str(J.mul(0.4, v_glow_1184)) + ")")])
		J.mc(v_g_1187, "addColorStop", [1.0, "rgba(255,170,60,0)"])
		J.sp(v_ctx_1175, "fillStyle", v_g_1187)
		var _t455 = J.gp(v_f_1183, "x")
		J.mc(v_ctx_1175, "fillRect", [J.sub((_t455 if J.t(_t455) else 0.0), J.mul(0.6, v_H_1180)), J.mul((-1.1), v_H_1180), J.mul(1.2, v_H_1180), J.mul(1.2, v_H_1180)])
	J.mc(v_N_1177, "whole", [v_ctx_1175, v_S_1178, v_f_1183, null, 0.3])
	v_T_1185 = J.mc(v_N_1177, "tgt", [v_S_1178, 0.6])
	v_p_1186 = J.sub(v_t_1179, J.gp(v_N_1177, "TC"))
	var _t456 = J.cmp(v_p_1186, 0.0, ">=")
	if (J.cmp(v_p_1186, 0.35, "<") if _t456 else _t456):
		v_i_1188 = 0.0
		while true:
			if not J.cmp(v_i_1188, 7.0, "<"): break
			v_k_1189 = J.div(v_p_1186, 0.35)
			v_x_1190 = J.add(J.gp(v_T_1185, 0.0), J.mul((J.sub(J.mc(v_N_1177, "rnd", [J.add(v_i_1188, 530.0)]), 0.5) * 0.4), v_th_1181))
			v_y_1191 = (J.sub(J.gp(v_T_1185, 1.0), J.mul(J.mul(v_k_1189, 0.4), v_th_1181)) - J.mul(J.mul(J.mc(v_N_1177, "rnd", [J.add(v_i_1188, 540.0)]), 0.2), v_th_1181))
			v_r_1192 = (J.mul((0.08 + J.mul(J.mc(v_N_1177, "rnd", [J.add(v_i_1188, 550.0)]), 0.06)), v_th_1181) * (1.0 - J.mul(v_k_1189, 0.6)))
			J.mc(v_ctx_1175, "save", [])
			var _t457 = J.mul(J.gp(v_ctx_1175, "globalAlpha"), J.sub(1.0, v_k_1189))
			J.sp(v_ctx_1175, "globalAlpha", _t457)
			J.mc(v_ctx_1175, "translate", [v_x_1190, v_y_1191])
			var _t458 = ("#ffb030" if J.t(J.mod(v_i_1188, 2.0)) else "#ff6a20")
			J.sp(v_ctx_1175, "fillStyle", _t458)
			J.sp(v_ctx_1175, "strokeStyle", "#7a2a08")
			var _t459 = J.mul(v_r_1192, 0.1)
			J.sp(v_ctx_1175, "lineWidth", _t459)
			J.mc(v_ctx_1175, "beginPath", [])
			J.mc(v_ctx_1175, "moveTo", [0.0, ((-J.num(v_r_1192)) * 1.4)])
			J.mc(v_ctx_1175, "quadraticCurveTo", [v_r_1192, ((-J.num(v_r_1192)) * 0.2), J.mul(v_r_1192, 0.6), J.mul(v_r_1192, 0.5)])
			J.mc(v_ctx_1175, "quadraticCurveTo", [0.0, v_r_1192, ((-J.num(v_r_1192)) * 0.6), J.mul(v_r_1192, 0.5)])
			J.mc(v_ctx_1175, "quadraticCurveTo", [(-J.num(v_r_1192)), ((-J.num(v_r_1192)) * 0.2), 0.0, ((-J.num(v_r_1192)) * 1.4)])
			J.mc(v_ctx_1175, "fill", [])
			J.mc(v_ctx_1175, "stroke", [])
			J.sp(v_ctx_1175, "fillStyle", "#ffe680")
			J.mc(v_ctx_1175, "beginPath", [])
			J.mc(v_ctx_1175, "ellipse", [0.0, J.mul(v_r_1192, 0.2), J.mul(v_r_1192, 0.3), J.mul(v_r_1192, 0.4), 0.0, 0.0, 7.0])
			J.mc(v_ctx_1175, "fill", [])
			J.mc(v_ctx_1175, "restore", [])
			v_i_1188 = J.num(v_i_1188) + 1.0
	var _t460 = J.cmp(v_p_1186, 0.0, ">=")
	if (J.cmp(v_p_1186, 0.13, "<") if _t460 else _t460):
		J.mc(v_N_1177, "burst", [v_ctx_1175, J.gp(v_T_1185, 0.0), J.gp(v_T_1185, 1.0), J.mul(0.34, v_th_1181), (1.0 - J.div(v_p_1186, 0.13)), "#ffd27a", 561.0, 10.0])
	J.mc(v_N_1177, "pop", [v_ctx_1175, v_S_1178, J.gp(v_T_1185, 0.0), J.sub(J.gp(v_T_1185, 1.0), J.mul(0.5, v_th_1181)), "啊嗚！", J.mul(0.24, v_th_1181), "#ffb050", J.sub(J.gp(v_N_1177, "TC"), 0.02), 0.3])
	J.mc(v_N_1177, "puff", [v_ctx_1175, J.mul(0.2, v_H_1180), J.mul((-0.7), v_H_1180), J.mul(0.08, v_H_1180), J.mc(v_N_1177, "seg", [v_t_1179, 0.44, 0.59]), "rgba(120,110,110,.5)", 562.0, 4.0])
	J.mc(v_N_1177, "hit", [v_S_1178, J.gp(v_T_1185, 0.0), J.gp(v_T_1185, 1.0)])
	J.mc(J.G.get("N30M"), "end", [v_ctx_1175])

func _f80(this_, a: Array, env):
	var v_ctx_1195 = null; var v_a_1196 = null; var v_N_1197 = null; var v_S_1198 = null; var v_t_1199 = null; var v_H_1200 = null; var v_th_1201 = null; var v_D2_1202 = null; var v_f_1203 = null; var v_T_1204 = null; var v_p_1205 = null; var v_i_1206 = null
	v_ctx_1195 = J.arg(a, 0)
	v_a_1196 = J.arg(a, 1)
	v_N_1197 = J.G.get("N30K")
	v_S_1198 = J.mc(v_N_1197, "setup", [v_a_1196])
	if (not J.t(v_S_1198)):
		return false
	v_t_1199 = J.gp(v_S_1198, "tt")
	v_H_1200 = J.gp(v_S_1198, "H")
	v_th_1201 = J.gp(v_S_1198, "th")
	v_D2_1202 = J.max_([0.0, (J.sub(J.gp(v_S_1198, "tx"), J.mul(0.4, v_th_1201)) - J.mul(0.45, J.gp(v_S_1198, "W")))])
	v_f_1203 = J.mc(v_N_1197, "kf", [v_t_1199, [[0.0, {}], [0.17, {"r": (-8.0), "armF": (-0.9), "armB": (-0.2), "head": (-0.15), "x": J.mul((-0.03), v_H_1200)}], [J.gp(v_N_1197, "TC"), {"r": 10.0, "armF": 0.15, "armB": 0.1, "head": 0.15, "x": v_D2_1202, "sy": 0.95}, "i"], [0.36, {"r": 9.0, "armF": 0.2, "head": 0.12, "x": v_D2_1202, "sy": 0.96}], [0.59, {}]]])
	var _t463 = J.mul(0.2, v_H_1200)
	J.sp(v_f_1203, "px", _t463)
	J.sp(v_f_1203, "py", 0.0)
	J.mc(J.G.get("N30M"), "begin", [v_ctx_1195, v_S_1198, J.gp(v_f_1203, "x")])
	J.mc(v_N_1197, "whole", [v_ctx_1195, v_S_1198, v_f_1203, null, 0.3])
	v_T_1204 = J.mc(v_N_1197, "tgt", [v_S_1198, 0.5])
	v_p_1205 = J.sub(v_t_1199, J.gp(v_N_1197, "TC"))
	var _t464 = J.cmp(v_t_1199, 0.18, ">")
	if (J.cmp(v_t_1199, 0.29, "<") if _t464 else _t464):
		J.mc(v_N_1197, "speed", [v_ctx_1195, J.gp(v_T_1204, 0.0), J.sub(J.gp(v_T_1204, 1.0), J.mul(0.3, v_th_1201)), 0.5, 1.0, J.mul(0.5, v_H_1200), J.mul(0.3, v_H_1200), J.mc(v_N_1197, "seg", [v_t_1199, 0.18, 0.22]), "rgba(245,240,225,.6)", 571.0, 5.0])
	v_i_1206 = 0.0
	while true:
		if not J.cmp(v_i_1206, 5.0, "<"): break
		J.mc(v_N_1197, "puff", [v_ctx_1195, J.add(J.gp(v_T_1204, 0.0), J.mul((J.sub(v_i_1206, 2.0) * 0.18), v_th_1201)), J.sub(J.gp(v_S_1198, "ty"), J.mul(0.05, v_th_1201)), J.mul(0.1, v_th_1201), J.mc(v_N_1197, "seg", [v_t_1199, J.add(J.gp(v_N_1197, "TC"), J.mul(v_i_1206, 0.01)), 0.52]), "rgba(200,190,170,.6)", J.add(575.0, v_i_1206), 3.0])
		v_i_1206 = J.num(v_i_1206) + 1.0
	var _t465 = J.cmp(v_p_1205, 0.0, ">=")
	if (J.cmp(v_p_1205, 0.14, "<") if _t465 else _t465):
		J.mc(v_N_1197, "burst", [v_ctx_1195, J.gp(v_T_1204, 0.0), J.gp(v_T_1204, 1.0), J.mul(0.45, v_th_1201), (1.0 - J.div(v_p_1205, 0.14)), "#fff6e0", 581.0, 12.0])
	var _t466 = J.gp(v_f_1203, "x")
	J.mc(v_N_1197, "pop", [v_ctx_1195, v_S_1198, J.sub((_t466 if J.t(_t466) else 0.0), J.mul(0.1, v_H_1200)), J.mul((-1.0), v_H_1200), "喀喀喀", J.mul(0.12, v_H_1200), "#f6efd8", 0.05, 0.2])
	J.mc(v_N_1197, "pop", [v_ctx_1195, v_S_1198, J.gp(v_T_1204, 0.0), J.sub(J.gp(v_T_1204, 1.0), J.mul(0.6, v_th_1201)), "啪！", J.mul(0.28, v_th_1201), "#fff6e0", J.gp(v_N_1197, "TC"), 0.3])
	J.mc(v_N_1197, "hit", [v_S_1198, J.gp(v_T_1204, 0.0), J.gp(v_T_1204, 1.0)])
	J.mc(J.G.get("N30M"), "end", [v_ctx_1195])

func _f81(this_, a: Array, env):
	var v_ctx_1209 = null; var v_a_1210 = null; var v_N_1211 = null; var v_S_1212 = null; var v_t_1213 = null; var v_H_1214 = null; var v_th_1215 = null; var v_sh_1216 = null; var v_f_1217 = null; var v_m_1218 = null; var v_mo_1219 = null; var v_T_1220 = null; var v_p_1221 = null; var v_i_1222 = null; var v_q_1223 = null; var v_x_1224 = null; var v_r_1225 = null
	v_ctx_1209 = J.arg(a, 0)
	v_a_1210 = J.arg(a, 1)
	v_N_1211 = J.G.get("N30K")
	v_S_1212 = J.mc(v_N_1211, "setup", [v_a_1210])
	if (not J.t(v_S_1212)):
		return false
	v_t_1213 = J.gp(v_S_1212, "tt")
	v_H_1214 = J.gp(v_S_1212, "H")
	v_th_1215 = J.gp(v_S_1212, "th")
	var _t469 = J.cmp(v_t_1213, 0.2, ">")
	v_sh_1216 = (J.mul((sin(J.num(J.mul(v_t_1213, 120.0))) * 0.008), v_H_1214) if (J.cmp(v_t_1213, 0.42, "<") if _t469 else _t469) else 0.0)
	v_f_1217 = J.mc(v_N_1211, "kf", [v_t_1213, [[0.0, {}], [0.17, {"head": (-0.3), "body": (-0.1), "sy": 1.06, "hairL": 0.35, "hairR": 0.35, "armF": 0.3, "armB": (-0.3), "y": J.mul((-0.03), v_H_1214)}], [0.23, {"head": 0.2, "body": 0.1, "r": 6.0, "hairL": (-0.5), "hairR": (-0.5), "armF": (-0.4), "armB": 0.4}, "o"], [0.42, {"head": 0.15, "r": 5.0, "hairL": (-0.4), "hairR": (-0.4)}], [0.59, {}]]])
	var _t470 = J.gp(v_f_1217, "x")
	var _t471 = J.add((_t470 if J.t(_t470) else 0.0), v_sh_1216)
	J.sp(v_f_1217, "x", _t471)
	J.mc(J.G.get("N30M"), "begin", [v_ctx_1209, v_S_1212, J.gp(v_f_1217, "x")])
	J.mc(v_N_1211, "whole", [v_ctx_1209, v_S_1212, v_f_1217, null, 0.3])
	v_m_1218 = J.mc(v_N_1211, "bm", [v_S_1212, v_f_1217])
	v_mo_1219 = J.mc(v_N_1211, "at", [v_S_1212, v_m_1218, 0.5, 0.26])
	v_T_1220 = J.mc(v_N_1211, "tgt", [v_S_1212, 0.7])
	v_i_1222 = 0.0
	while true:
		if not J.cmp(v_i_1222, 5.0, "<"): break
		v_q_1223 = J.mc(v_N_1211, "seg", [v_t_1213, (0.2 + J.mul(v_i_1222, 0.03)), J.add(J.add(J.gp(v_N_1211, "TC"), J.mul(v_i_1222, 0.03)), 0.02)])
		var _t472 = J.cmp(v_q_1223, 0.0, "<=")
		if (_t472 if _t472 else J.cmp(v_q_1223, 1.0, ">=")):
			v_i_1222 = J.num(v_i_1222) + 1.0
			continue
		v_x_1224 = J.mc(v_N_1211, "lerp", [J.add(J.gp(v_mo_1219, 0.0), J.mul(0.05, v_H_1214)), J.add(J.gp(v_T_1220, 0.0), J.mul(0.1, v_th_1215)), v_q_1223])
		v_r_1225 = J.mul((0.08 + J.mul(v_q_1223, 0.3)), v_H_1214)
		J.mc(v_ctx_1209, "save", [])
		var _t473 = J.mul(J.gp(v_ctx_1209, "globalAlpha"), sin(J.num(J.mul(v_q_1223, PI))))
		J.sp(v_ctx_1209, "globalAlpha", _t473)
		var _t474 = ("rgba(200,220,255,.95)" if J.t(J.mod(v_i_1222, 2.0)) else "rgba(255,255,255,.95)")
		J.sp(v_ctx_1209, "strokeStyle", _t474)
		var _t475 = J.mul(0.045, v_H_1214)
		J.sp(v_ctx_1209, "lineWidth", _t475)
		J.mc(v_ctx_1209, "beginPath", [])
		J.mc(v_ctx_1209, "arc", [J.sub(v_x_1224, v_r_1225), J.mc(v_N_1211, "lerp", [J.gp(v_mo_1219, 1.0), J.gp(v_T_1220, 1.0), v_q_1223]), v_r_1225, (-0.6), 0.6])
		J.mc(v_ctx_1209, "stroke", [])
		J.mc(v_ctx_1209, "restore", [])
		v_i_1222 = J.num(v_i_1222) + 1.0
	v_p_1221 = J.sub(v_t_1213, J.gp(v_N_1211, "TC"))
	var _t476 = J.cmp(v_p_1221, 0.0, ">=")
	if (J.cmp(v_p_1221, 0.13, "<") if _t476 else _t476):
		J.mc(v_N_1211, "burst", [v_ctx_1209, J.gp(v_T_1220, 0.0), J.gp(v_T_1220, 1.0), J.mul(0.35, v_th_1215), (1.0 - J.div(v_p_1221, 0.13)), "#dfe8ff", 591.0, 10.0])
	J.mc(v_N_1211, "pop", [v_ctx_1209, v_S_1212, J.add(J.gp(v_mo_1219, 0.0), J.mul(0.1, v_H_1214)), J.sub(J.gp(v_mo_1219, 1.0), J.mul(0.3, v_H_1214)), "啊——！", J.mul(0.14, v_H_1214), "#dfe8ff", 0.2, 0.3])
	J.mc(v_N_1211, "hit", [v_S_1212, J.gp(v_T_1220, 0.0), J.gp(v_T_1220, 1.0)])
	J.mc(J.G.get("N30M"), "end", [v_ctx_1209])

func _f82(this_, a: Array, env):
	var v_ctx_1228 = null; var v_a_1229 = null; var v_N_1230 = null; var v_S_1231 = null; var v_t_1232 = null; var v_H_1233 = null; var v_th_1234 = null; var v_D2_1235 = null; var v_sh_1236 = null; var v_keys_1237 = null; var v_f_1238 = null; var v_fire_1239 = null; var v_m_1240 = null; var v_T_1241 = null; var v_p_1242 = null; var v_i_1243 = null; var v_g_1244 = null; var v_u_1245 = null; var v_hn_1246 = null; var v_i_1247 = null; var v_k_1248 = null; var v_r_1249 = null; var v_sg_1250 = null; var v_i_1251 = null; var v_k_1252 = null; var v_o_1253 = null; var v_A_1254 = null; var v_B_1255 = null
	v_ctx_1228 = J.arg(a, 0)
	v_a_1229 = J.arg(a, 1)
	v_N_1230 = J.G.get("N30K")
	v_S_1231 = J.mc(v_N_1230, "setup", [v_a_1229])
	if (not J.t(v_S_1231)):
		return false
	v_t_1232 = J.gp(v_S_1231, "tt")
	v_H_1233 = J.gp(v_S_1231, "H")
	v_th_1234 = J.gp(v_S_1231, "th")
	v_D2_1235 = J.max_([0.0, (J.sub(J.gp(v_S_1231, "tx"), J.mul(0.35, v_th_1234)) - J.mul(0.35, v_H_1233))])
	v_sh_1236 = (J.mul(J.mul((sin(J.num(J.mul(v_t_1232, 110.0))) * 0.01), v_H_1233), J.mc(v_N_1230, "seg", [v_t_1232, 0.0, 0.1])) if J.cmp(v_t_1232, 0.2, "<") else 0.0)
	v_keys_1237 = [[0.0, {}], [0.18, {"r": (-6.0), "armF": (-0.9), "armB": (-0.7), "head": (-0.1), "sy": 1.04}], [J.gp(v_N_1230, "TC"), {"r": 14.0, "x": v_D2_1235, "armF": (-0.5), "armB": (-0.4), "head": 0.15}, "i"], [0.36, {"r": 12.0, "x": v_D2_1235, "armF": (-0.3), "armB": (-0.2), "head": 0.1}], [0.59, {}]]
	v_f_1238 = J.mc(v_N_1230, "kf", [v_t_1232, v_keys_1237])
	var _t479 = J.gp(v_f_1238, "x")
	var _t480 = J.add((_t479 if J.t(_t479) else 0.0), v_sh_1236)
	J.sp(v_f_1238, "x", _t480)
	J.mc(J.G.get("N30M"), "begin", [v_ctx_1228, v_S_1231, J.gp(v_f_1238, "x")])
	var _t481 = J.cmp(v_t_1232, 0.2, ">")
	if (J.cmp(v_t_1232, 0.36, "<") if _t481 else _t481):
		v_i_1243 = 2.0
		while true:
			if not J.cmp(v_i_1243, 1.0, ">="): break
			v_g_1244 = J.mc(v_N_1230, "kf", [J.sub(v_t_1232, J.mul(v_i_1243, 0.025)), v_keys_1237])
			J.mc(v_ctx_1228, "save", [])
			var _t482 = J.mul(J.gp(v_ctx_1228, "globalAlpha"), J.div((0.22 * J.sub(3.0, v_i_1243)), 2.0))
			J.sp(v_ctx_1228, "globalAlpha", _t482)
			J.mc(v_N_1230, "whole", [v_ctx_1228, v_S_1231, v_g_1244, null, 0.3])
			J.mc(v_ctx_1228, "restore", [])
			v_i_1243 = J.num(v_i_1243) + -1.0
	v_fire_1239 = J.gp(J.mc(v_N_1230, "kf", [v_t_1232, [[0.0, {"v": 0.0}], [0.12, {"v": 1.0}], [0.4, {"v": 1.0}], [0.59, {"v": 0.0}]]]), "v")
	v_m_1240 = J.mc(v_N_1230, "bm", [v_S_1231, v_f_1238])
	J.mc(v_N_1230, "whole", [v_ctx_1228, v_S_1231, v_f_1238, null, 0.3])
	if J.cmp(v_fire_1239, 0.0, ">"):
		for _t483 in J.iter([0.18, 0.62]):
			v_u_1245 = _t483
			v_hn_1246 = J.mc(v_N_1230, "at", [v_S_1231, v_m_1240, v_u_1245, 0.04])
			v_i_1247 = 0.0
			while true:
				if not J.cmp(v_i_1247, 3.0, "<"): break
				v_k_1248 = J.mod((J.mul(v_t_1232, 4.0) + J.div(v_i_1247, 3.0)), 1.0)
				v_r_1249 = J.mul((J.mul(0.05, v_H_1233) * J.sub(1.0, v_k_1248)), v_fire_1239)
				J.mc(v_ctx_1228, "save", [])
				var _t484 = J.mul(J.gp(v_ctx_1228, "globalAlpha"), J.mul(J.sub(1.0, v_k_1248), v_fire_1239))
				J.sp(v_ctx_1228, "globalAlpha", _t484)
				var _t485 = ("#ff4020" if J.t(J.mod(v_i_1247, 2.0)) else "#ff9a30")
				J.sp(v_ctx_1228, "fillStyle", _t485)
				J.mc(v_ctx_1228, "beginPath", [])
				J.mc(v_ctx_1228, "ellipse", [J.add(J.gp(v_hn_1246, 0.0), J.mul((sin(J.num(J.add(J.mul(v_t_1232, 20.0), v_i_1247))) * 0.02), v_H_1233)), J.sub(J.gp(v_hn_1246, 1.0), J.mul(J.mul(v_k_1248, 0.15), v_H_1233)), J.mul(v_r_1249, 0.6), v_r_1249, 0.0, 0.0, 7.0])
				J.mc(v_ctx_1228, "fill", [])
				J.mc(v_ctx_1228, "restore", [])
				v_i_1247 = J.num(v_i_1247) + 1.0
	J.mc(v_N_1230, "puff", [v_ctx_1228, J.gp(J.mc(v_N_1230, "at", [v_S_1231, v_m_1240, 0.42, 0.02]), 0.0), J.gp(J.mc(v_N_1230, "at", [v_S_1231, v_m_1240, 0.42, 0.02]), 1.0), J.mul(0.06, v_H_1233), J.mc(v_N_1230, "seg", [v_t_1232, 0.02, 0.3]), "rgba(240,240,240,.5)", 601.0, 3.0])
	v_T_1241 = J.mc(v_N_1230, "tgt", [v_S_1231, 0.62])
	v_p_1242 = J.sub(v_t_1232, J.gp(v_N_1230, "TC"))
	var _t486 = J.cmp(v_p_1242, 0.0, ">=")
	if (J.cmp(v_p_1242, 0.3, "<") if _t486 else _t486):
		for _t487 in J.iter([(-1.0), 1.0]):
			v_sg_1250 = _t487
			v_i_1251 = 0.0
			while true:
				if not J.cmp(v_i_1251, 3.0, "<"): break
				v_k_1252 = J.min_([1.0, J.div(v_p_1242, 0.05)])
				v_o_1253 = J.mul((J.sub(v_i_1251, 1.0) * 0.06), v_th_1234)
				v_A_1254 = [J.add(J.sub(J.gp(v_T_1241, 0.0), J.mul(J.mul(0.2, v_th_1234), v_sg_1250)), v_o_1253), J.sub(J.gp(v_T_1241, 1.0), J.mul(0.22, v_th_1234))]
				v_B_1255 = [J.add(J.add(J.gp(v_T_1241, 0.0), J.mul(J.mul(0.2, v_th_1234), v_sg_1250)), v_o_1253), J.add(J.gp(v_T_1241, 1.0), J.mul(0.22, v_th_1234))]
				J.mc(v_N_1230, "crayon", [v_ctx_1228, [v_A_1254, [J.mc(v_N_1230, "lerp", [J.gp(v_A_1254, 0.0), J.gp(v_B_1255, 0.0), v_k_1252]), J.mc(v_N_1230, "lerp", [J.gp(v_A_1254, 1.0), J.gp(v_B_1255, 1.0), v_k_1252])]], "rgba(230,40,50,.9)", J.mul(0.025, v_th_1234), J.add(J.add(611.0, v_i_1251), J.mul(v_sg_1250, 5.0)), (1.0 - J.div(v_p_1242, 0.3))])
				v_i_1251 = J.num(v_i_1251) + 1.0
	var _t488 = J.cmp(v_p_1242, 0.0, ">=")
	if (J.cmp(v_p_1242, 0.13, "<") if _t488 else _t488):
		J.mc(v_N_1230, "burst", [v_ctx_1228, J.gp(v_T_1241, 0.0), J.gp(v_T_1241, 1.0), J.mul(0.32, v_th_1234), (1.0 - J.div(v_p_1242, 0.13)), "#ffb0b0", 621.0, 9.0])
	J.mc(v_N_1230, "pop", [v_ctx_1228, v_S_1231, J.gp(v_T_1241, 0.0), J.sub(J.gp(v_T_1241, 1.0), J.mul(0.45, v_th_1234)), "妒忌！", J.mul(0.22, v_th_1234), "#ff6060", J.gp(v_N_1230, "TC"), 0.3])
	J.mc(v_N_1230, "hit", [v_S_1231, J.gp(v_T_1241, 0.0), J.gp(v_T_1241, 1.0)])
	J.mc(J.G.get("N30M"), "end", [v_ctx_1228])

func _f84(this_, a: Array, env):
	var v_i_1279 = null; var v_n_1280 = null
	v_i_1279 = J.arg(a, 0)
	v_n_1280 = J.arg(a, 1)
	return (1.0 + ((0.9 * exp(J.num(J.div((-pow(J.num((J.div(v_i_1279, v_n_1280) - J.sub(1.0, env["suck"]))), J.num(2.0))), 0.006)))) if J.cmp(env["suck"], 0.0, ">=") else 0.0))

func _f83(this_, a: Array, env):
	var v_ctx_1258 = null; var v_a_1259 = null; var v_N_1260 = null; var v_S_1261 = null; var v_key_1262 = null; var v_t_1263 = null; var v_H_1264 = null; var v_th_1265 = null; var v_SRC_1266 = null; var v_flap_1267 = null; var v_f_1268 = null; var v_m_1269 = null; var v_root_1270 = null; var v_T_1271 = null; var v_tipR_1272 = null; var v_P_1273 = null; var v_b_1274 = null; var v_tip_1275 = null; var v_ctrl_1276 = null; var v_p_1278 = null
	var _s242 = {"__p": env, "suck": null}
	v_ctx_1258 = J.arg(a, 0)
	v_a_1259 = J.arg(a, 1)
	v_N_1260 = J.G.get("N30K")
	v_S_1261 = J.mc(v_N_1260, "setup", [v_a_1259])
	if (not J.t(v_S_1261)):
		return false
	v_key_1262 = J.mc(J.G.get("N30"), "body", [J.gp(v_S_1261, "id")])
	if (not J.t(v_key_1262)):
		return false
	v_t_1263 = J.gp(v_S_1261, "tt")
	v_H_1264 = J.gp(v_S_1261, "H")
	v_th_1265 = J.gp(v_S_1261, "th")
	v_SRC_1266 = [[0.235, 0.335], [0.2, 0.39], [0.15, 0.45], [0.1, 0.52], [0.095, 0.58], [0.1, 0.62]]
	v_flap_1267 = (sin(J.num(J.mul(v_t_1263, 30.0))) * 0.25)
	v_f_1268 = J.mc(v_N_1260, "kf", [v_t_1263, [[0.0, {}], [0.16, {"r": (-5.0), "head": (-0.12), "cape": (-0.5)}], [J.gp(v_N_1260, "TC"), {"r": 8.0, "head": 0.12, "cape": 0.3, "x": J.mul(0.03, v_H_1264)}, "i"], [0.42, {"r": 6.0, "head": 0.1, "x": J.mul(0.03, v_H_1264)}], [0.59, {}]]])
	var _t491 = J.gp(v_f_1268, "cape")
	var _t493 = (_t491 if J.t(_t491) else 0.0)
	var _t492 = J.cmp(v_t_1263, 0.1, ">")
	var _t494 = J.add(_t493, (v_flap_1267 if (J.cmp(v_t_1263, 0.5, "<") if _t492 else _t492) else 0.0))
	J.sp(v_f_1268, "cape", _t494)
	v_m_1269 = J.mc(v_N_1260, "bm", [v_S_1261, v_f_1268])
	v_root_1270 = J.mc(v_N_1260, "at", [v_S_1261, v_m_1269, 0.235, 0.335])
	v_T_1271 = J.mc(v_N_1260, "tgt", [v_S_1261, 0.7])
	v_tipR_1272 = J.mc(v_N_1260, "at", [v_S_1261, v_m_1269, 0.1, 0.62])
	v_P_1273 = J.mc(v_N_1260, "kf", [v_t_1263, [[0.0, {"x": J.gp(v_tipR_1272, 0.0), "y": J.gp(v_tipR_1272, 1.0)}], [0.16, {"x": J.add(J.gp(v_root_1270, 0.0), J.mul(0.08, v_H_1264)), "y": J.add(J.gp(v_root_1270, 1.0), J.mul(0.12, v_H_1264))}], [J.gp(v_N_1260, "TC"), {"x": J.gp(v_T_1271, 0.0), "y": J.gp(v_T_1271, 1.0)}, "i"], [0.42, {"x": J.gp(v_T_1271, 0.0), "y": J.gp(v_T_1271, 1.0)}], [0.55, {"x": J.gp(v_tipR_1272, 0.0), "y": J.gp(v_tipR_1272, 1.0)}]]])
	if J.cmp(v_t_1263, 0.55, ">"):
		var _t495 = J.gp(v_tipR_1272, 0.0)
		J.sp(v_P_1273, "x", _t495)
		var _t496 = J.gp(v_tipR_1272, 1.0)
		J.sp(v_P_1273, "y", _t496)
	v_b_1274 = J.gp(J.mc(v_N_1260, "kf", [v_t_1263, [[0.0, {"v": 0.0}], [0.08, {"v": 1.0}], [0.5, {"v": 1.0}], [0.56, {"v": 0.0}]]]), "v")
	v_tip_1275 = [J.gp(v_P_1273, "x"), J.gp(v_P_1273, "y")]
	v_ctrl_1276 = [J.div(J.add(J.gp(v_root_1270, 0.0), J.gp(v_tip_1275, 0.0)), 2.0), (J.div(J.add(J.gp(v_root_1270, 1.0), J.gp(v_tip_1275, 1.0)), 2.0) - J.mul(0.06, v_H_1264))]
	var _t497 = J.cmp(v_t_1263, J.add(J.gp(v_N_1260, "TC"), 0.01), ">")
	_s242["suck"] = (J.mod((J.sub(v_t_1263, J.gp(v_N_1260, "TC")) * 6.0), 1.0) if (J.cmp(v_t_1263, 0.44, "<") if _t497 else _t497) else (-1.0))
	J.mc(J.G.get("N30M"), "begin", [v_ctx_1258, v_S_1261, J.gp(v_f_1268, "x")])
	J.mc(v_N_1260, "body", [v_ctx_1258, v_S_1261, v_m_1269, J.mc(v_N_1260, "pose", [v_S_1261, v_f_1268, 0.3]), v_key_1262])
	J.mc(v_N_1260, "ribbon", [v_ctx_1258, v_S_1261, "tongue", v_SRC_1266, 0.04, J.mc(J.G.get("N30M"), "line", [v_S_1261, v_m_1269, v_SRC_1266, v_root_1270, v_ctrl_1276, v_tip_1275, v_b_1274]), Callable(self, "_f84").bind(_s242)])
	v_p_1278 = J.sub(v_t_1263, J.gp(v_N_1260, "TC"))
	var _t498 = J.cmp(v_p_1278, 0.0, ">=")
	if (J.cmp(v_p_1278, 0.13, "<") if _t498 else _t498):
		J.mc(v_N_1260, "burst", [v_ctx_1258, J.gp(v_T_1271, 0.0), J.gp(v_T_1271, 1.0), J.mul(0.28, v_th_1265), (1.0 - J.div(v_p_1278, 0.13)), "#ffc8c8", 631.0, 9.0])
	J.mc(v_N_1260, "pop", [v_ctx_1258, v_S_1261, J.gp(v_T_1271, 0.0), J.sub(J.gp(v_T_1271, 1.0), J.mul(0.35, v_th_1265)), "啾啾～", J.mul(0.2, v_th_1265), "#ff9aa8", J.add(J.gp(v_N_1260, "TC"), 0.02), 0.3])
	J.mc(v_N_1260, "hit", [v_S_1261, J.gp(v_T_1271, 0.0), J.gp(v_T_1271, 1.0)])
	J.mc(J.G.get("N30M"), "end", [v_ctx_1258])

func _f85(this_, a: Array, env):
	var v_ctx_1283 = null; var v_a_1284 = null; var v_N_1285 = null; var v_S_1286 = null; var v_t_1287 = null; var v_H_1288 = null; var v_th_1289 = null; var v_D2_1290 = null; var v_turn_1291 = null; var v_f_1292 = null; var v_m0_1293 = null; var v_cg_1294 = null; var v_T_1295 = null; var v_p_1296 = null
	v_ctx_1283 = J.arg(a, 0)
	v_a_1284 = J.arg(a, 1)
	v_N_1285 = J.G.get("N30K")
	v_S_1286 = J.mc(v_N_1285, "setup", [v_a_1284])
	if (not J.t(v_S_1286)):
		return false
	v_t_1287 = J.gp(v_S_1286, "tt")
	v_H_1288 = J.gp(v_S_1286, "H")
	v_th_1289 = J.gp(v_S_1286, "th")
	v_D2_1290 = J.max_([0.0, (J.sub(J.gp(v_S_1286, "tx"), J.mul(0.25, v_th_1289)) - J.mul(0.4, v_H_1288))])
	v_turn_1291 = (cos(J.num(J.mul(J.mc(v_N_1285, "seg", [v_t_1287, 0.06, 0.12]), PI))) if J.cmp(v_t_1287, 0.13, "<") else ((-cos(J.num(J.mul(J.mc(v_N_1285, "seg", [v_t_1287, 0.49, 0.55]), PI)))) if J.cmp(v_t_1287, 0.44, ">") else (-1.0)))
	v_f_1292 = J.mc(v_N_1285, "kf", [v_t_1287, [[0.0, {}], [0.13, {"x": J.mul(v_D2_1290, 0.5)}], [0.2, {"x": J.mul(v_D2_1290, 0.8), "r": (-6.0), "legF": (-0.2), "legB": (-0.2), "head": 0.1}], [J.gp(v_N_1285, "TC"), {"x": v_D2_1290, "r": (-22.0), "legF": 0.9, "legB": 0.75, "head": 0.25, "body": 0.15, "cape": 0.4}, "i"], [0.36, {"x": v_D2_1290, "r": (-20.0), "legF": 0.85, "legB": 0.7, "head": 0.2, "body": 0.12}], [0.44, {"x": J.mul(v_D2_1290, 0.6)}], [0.59, {}]]])
	var _t501 = ((0.15 * signf(J.num((v_turn_1291 if J.t(v_turn_1291) else 1.0)))) if (absf(J.num(v_turn_1291)) < 0.15) else v_turn_1291)
	J.sp(v_f_1292, "sx", _t501)
	J.sp(v_f_1292, "px", 0.0)
	var _t502 = J.mul((-0.5), v_H_1288)
	J.sp(v_f_1292, "py", _t502)
	J.mc(J.G.get("N30M"), "begin", [v_ctx_1283, v_S_1286, J.gp(v_f_1292, "x")])
	J.mc(v_N_1285, "whole", [v_ctx_1283, v_S_1286, v_f_1292, null, 0.3])
	v_m0_1293 = J.mc(v_N_1285, "bm", [v_S_1286, {}])
	v_cg_1294 = J.mc(v_N_1285, "at", [v_S_1286, v_m0_1293, 0.06, 0.29])
	J.mc(v_N_1285, "puff", [v_ctx_1283, J.gp(v_cg_1294, 0.0), J.sub(J.gp(v_cg_1294, 1.0), J.mul(0.05, v_H_1288)), J.mul(0.06, v_H_1288), J.mc(v_N_1285, "seg", [v_t_1287, 0.0, 0.2]), "rgba(200,200,210,.55)", 641.0, 4.0])
	v_T_1295 = J.mc(v_N_1285, "tgt", [v_S_1286, 0.45])
	v_p_1296 = J.sub(v_t_1287, J.gp(v_N_1285, "TC"))
	var _t503 = J.cmp(v_t_1287, 0.2, ">")
	if (J.cmp(v_t_1287, 0.3, "<") if _t503 else _t503):
		J.mc(v_N_1285, "speed", [v_ctx_1283, J.gp(v_T_1295, 0.0), J.gp(v_T_1295, 1.0), 1.0, (-0.2), J.mul(0.3, v_H_1288), J.mul(0.2, v_H_1288), J.mc(v_N_1285, "seg", [v_t_1287, 0.2, 0.24]), "rgba(255,240,220,.7)", 643.0, 4.0])
	var _t504 = J.cmp(v_p_1296, 0.0, ">=")
	if (J.cmp(v_p_1296, 0.14, "<") if _t504 else _t504):
		J.mc(v_N_1285, "burst", [v_ctx_1283, J.gp(v_T_1295, 0.0), J.gp(v_T_1295, 1.0), J.mul(0.36, v_th_1289), (1.0 - J.div(v_p_1296, 0.14)), "#ffe0b0", 645.0, 11.0])
	var _t505 = J.cmp(v_p_1296, 0.0, ">=")
	if (J.cmp(v_p_1296, 0.3, "<") if _t505 else _t505):
		J.mc(v_N_1285, "stars", [v_ctx_1283, J.gp(v_T_1295, 0.0), J.sub(J.gp(v_T_1295, 1.0), J.mul(0.45, v_th_1289)), J.mul(0.15, v_th_1289), v_t_1287, (1.0 - J.div(v_p_1296, 0.3))])
	J.mc(v_N_1285, "pop", [v_ctx_1283, v_S_1286, J.gp(v_T_1295, 0.0), J.sub(J.gp(v_T_1295, 1.0), J.mul(0.55, v_th_1289)), "踢！", J.mul(0.26, v_th_1289), "#ffd090", J.gp(v_N_1285, "TC"), 0.28])
	J.mc(v_N_1285, "hit", [v_S_1286, J.gp(v_T_1295, 0.0), J.gp(v_T_1295, 1.0)])
	J.mc(J.G.get("N30M"), "end", [v_ctx_1283])

func _f86(this_, a: Array, env):
	var v_ctx_1299 = null; var v_a_1300 = null; var v_b_1301 = null; var v_w_1302 = null; var v_seed_1303 = null; var v_col_1304 = null; var v_al_1305 = null; var v_N_1306 = null; var v_pts_1307 = null; var v_n_1308 = null; var v_i_1309 = null; var v_k_1310 = null
	v_ctx_1299 = J.arg(a, 0)
	v_a_1300 = J.arg(a, 1)
	v_b_1301 = J.arg(a, 2)
	v_w_1302 = J.arg(a, 3)
	v_seed_1303 = J.arg(a, 4)
	v_col_1304 = J.arg(a, 5)
	v_al_1305 = J.arg(a, 6)
	v_N_1306 = J.G.get("N30K")
	v_pts_1307 = [v_a_1300]
	v_n_1308 = 7.0
	v_i_1309 = 1.0
	while true:
		if not J.cmp(v_i_1309, v_n_1308, "<"): break
		v_k_1310 = J.div(v_i_1309, v_n_1308)
		J.mc(v_pts_1307, "push", [[J.add(J.mc(v_N_1306, "lerp", [J.gp(v_a_1300, 0.0), J.gp(v_b_1301, 0.0), v_k_1310]), (J.mul(J.sub(J.mc(v_N_1306, "rnd", [J.add(v_seed_1303, v_i_1309)]), 0.5), v_w_1302) * 6.0)), J.add(J.mc(v_N_1306, "lerp", [J.gp(v_a_1300, 1.0), J.gp(v_b_1301, 1.0), v_k_1310]), (J.mul(J.sub(J.mc(v_N_1306, "rnd", [J.add(J.add(v_seed_1303, v_i_1309), 9.0)]), 0.5), v_w_1302) * 2.0))]])
		v_i_1309 = J.num(v_i_1309) + 1.0
	J.mc(v_pts_1307, "push", [v_b_1301])
	J.mc(v_ctx_1299, "save", [])
	var _t508 = J.mul(J.gp(v_ctx_1299, "globalAlpha"), (1.0 if J.leq(v_al_1305, null) else v_al_1305))
	J.sp(v_ctx_1299, "globalAlpha", _t508)
	J.mc(v_N_1306, "crayon", [v_ctx_1299, v_pts_1307, "rgba(255,255,255,.95)", J.mul(v_w_1302, 1.6), v_seed_1303])
	J.mc(v_N_1306, "crayon", [v_ctx_1299, v_pts_1307, (v_col_1304 if J.t(v_col_1304) else "#ffe14a"), v_w_1302, J.add(v_seed_1303, 3.0)])
	J.mc(v_ctx_1299, "restore", [])

func _f88(this_, a: Array, env):
	var v_k_1321 = null; var v_dx_1322 = null; var v_dy_1323 = null; var v_rr_1324 = null
	v_k_1321 = J.arg(a, 0)
	J.mc(env["ctx"], "beginPath", [])
	for _t513 in J.iter(env["C"]):
		var _t514 = J.gp(_t513, 0.0)
		v_dx_1322 = _t514
		var _t515 = J.gp(_t513, 1.0)
		v_dy_1323 = _t515
		var _t516 = J.gp(_t513, 2.0)
		v_rr_1324 = _t516
		J.mc(env["ctx"], "moveTo", [J.add(J.add(J.add(env["x"], J.mul(v_dx_1322, env["r"])), J.mul(v_rr_1324, env["r"])), v_k_1321), J.add(env["y"], J.mul(v_dy_1323, env["r"]))])
		J.mc(env["ctx"], "arc", [J.add(env["x"], J.mul(v_dx_1322, env["r"])), J.add(env["y"], J.mul(v_dy_1323, env["r"])), J.add(J.mul(v_rr_1324, env["r"]), v_k_1321), 0.0, 7.0])

func _f87(this_, a: Array, env):
	var v_al_1317 = null; var v_col_1318 = null; var v_path_1320 = null
	var _s249 = {"__p": env, "ctx": null, "x": null, "y": null, "r": null, "C": null}
	_s249["ctx"] = J.arg(a, 0)
	_s249["x"] = J.arg(a, 1)
	_s249["y"] = J.arg(a, 2)
	_s249["r"] = J.arg(a, 3)
	v_al_1317 = J.arg(a, 4)
	v_col_1318 = J.arg(a, 5)
	if J.cmp(v_al_1317, 0.0, "<="):
		return null
	J.mc(_s249["ctx"], "save", [])
	var _t511 = _s249["ctx"]
	var _t512 = J.mul(J.gp(_t511, "globalAlpha"), v_al_1317)
	J.sp(_t511, "globalAlpha", _t512)
	_s249["C"] = [[(-0.6), 0.1, 0.45], [(-0.2), (-0.15), 0.55], [0.3, (-0.1), 0.5], [0.7, 0.1, 0.4], [0.1, 0.2, 0.5]]
	v_path_1320 = Callable(self, "_f88").bind(_s249)
	J.cl(v_path_1320, null, [J.mul(_s249["r"], 0.05)])
	var _t517 = _s249["ctx"]
	J.sp(_t517, "fillStyle", "rgba(20,16,30,.85)")
	J.mc(_s249["ctx"], "fill", [])
	J.cl(v_path_1320, null, [0.0])
	var _t518 = _s249["ctx"]
	var _t519 = (v_col_1318 if J.t(v_col_1318) else "#4a4458")
	J.sp(_t518, "fillStyle", _t519)
	J.mc(_s249["ctx"], "fill", [])
	J.mc(_s249["ctx"], "restore", [])

func _f89(this_, a: Array, env):
	var v_ctx_1327 = null; var v_a_1328 = null; var v_N_1329 = null; var v_S_1330 = null; var v_t_1331 = null; var v_H_1332 = null; var v_th_1333 = null; var v_D2_1334 = null; var v_vib_1335 = null; var v_f_1336 = null; var v_T_1337 = null; var v_p_1338 = null; var v_al_1339 = null; var v_x1_1340 = null; var v_dy_1341 = null; var v_i_1342 = null; var v_i_1343 = null; var v_an_1344 = null; var v_sp_1345 = null; var v_x_1346 = null; var v_y_1347 = null
	v_ctx_1327 = J.arg(a, 0)
	v_a_1328 = J.arg(a, 1)
	v_N_1329 = J.G.get("N30K")
	v_S_1330 = J.mc(v_N_1329, "setup", [v_a_1328])
	if (not J.t(v_S_1330)):
		return false
	v_t_1331 = J.gp(v_S_1330, "tt")
	v_H_1332 = J.gp(v_S_1330, "H")
	v_th_1333 = J.gp(v_S_1330, "th")
	v_D2_1334 = J.max_([0.0, (J.sub(J.gp(v_S_1330, "tx"), J.mul(0.35, v_th_1333)) - J.mul(0.3, v_H_1332))])
	v_vib_1335 = (J.mul((sin(J.num(J.mul(v_t_1331, 140.0))) * 0.006), v_H_1332) if J.cmp(v_t_1331, 0.2, "<") else 0.0)
	v_f_1336 = J.mc(v_N_1329, "kf", [v_t_1331, [[0.0, {}], [0.16, {"r": 8.0, "sy": 0.95, "armF": (-0.5), "armB": (-0.4), "head": 0.08, "x": J.mul((-0.03), v_H_1332)}], [J.gp(v_N_1329, "TC"), {"r": 14.0, "x": v_D2_1334, "armF": (-0.6), "armB": (-0.5), "head": 0.1, "legF": (-0.2), "legB": 0.2}, "i"], [0.33, {"r": (-6.0), "x": J.sub(v_D2_1334, J.mul(0.03, v_H_1332)), "sy": 1.03}], [0.45, {"r": 5.0, "x": J.mul(v_D2_1334, 0.5)}], [0.59, {}]]])
	var _t522 = J.gp(v_f_1336, "x")
	var _t523 = J.add((_t522 if J.t(_t522) else 0.0), v_vib_1335)
	J.sp(v_f_1336, "x", _t523)
	J.sp(v_f_1336, "px", 0.0)
	J.sp(v_f_1336, "py", 0.0)
	J.mc(J.G.get("N30M"), "begin", [v_ctx_1327, v_S_1330, J.gp(v_f_1336, "x")])
	if J.cmp(v_t_1331, 0.2, ">"):
		v_al_1339 = J.sub(1.0, J.mc(v_N_1329, "seg", [v_t_1331, 0.45, 0.59]))
		var _t524 = J.gp(v_f_1336, "x")
		var _t525 = J.gp(v_f_1336, "x")
		v_x1_1340 = J.min_([(_t525 if J.t(_t525) else 0.0), v_D2_1334])
		for _t526 in J.iter([(-0.012), 0.012]):
			v_dy_1341 = _t526
			J.mc(v_ctx_1327, "save", [])
			var _t527 = J.mul(J.gp(v_ctx_1327, "globalAlpha"), J.mul(v_al_1339, 0.8))
			J.sp(v_ctx_1327, "globalAlpha", _t527)
			J.sp(v_ctx_1327, "strokeStyle", "rgba(30,24,20,.85)")
			var _t528 = J.mul(0.02, v_H_1332)
			J.sp(v_ctx_1327, "lineWidth", _t528)
			J.mc(v_ctx_1327, "setLineDash", [[J.mul(0.03, v_H_1332), J.mul(0.02, v_H_1332)]])
			J.mc(v_ctx_1327, "beginPath", [])
			J.mc(v_ctx_1327, "moveTo", [J.mul((-0.1), v_H_1332), J.mul(v_dy_1341, v_H_1332)])
			J.mc(v_ctx_1327, "lineTo", [J.add(v_x1_1340, J.mul(0.1, v_H_1332)), J.mul(v_dy_1341, v_H_1332)])
			J.mc(v_ctx_1327, "stroke", [])
			J.mc(v_ctx_1327, "restore", [])
	J.mc(v_N_1329, "whole", [v_ctx_1327, v_S_1330, v_f_1336, null, 0.3])
	v_i_1342 = 0.0
	while true:
		if not J.cmp(v_i_1342, 3.0, "<"): break
		var _t529 = J.gp(v_f_1336, "x")
		J.mc(v_N_1329, "puff", [v_ctx_1327, (J.sub((_t529 if J.t(_t529) else 0.0), J.mul(0.35, v_H_1332)) - J.mul(J.mul(v_i_1342, 0.05), v_H_1332)), J.mul((-0.2), v_H_1332), J.mul(0.06, v_H_1332), J.mc(v_N_1329, "cl", [J.mod((J.mul(v_t_1331, 5.0) + J.div(v_i_1342, 3.0)), 1.0)]), "rgba(70,64,70,.55)", J.add(700.0, v_i_1342), 3.0])
		v_i_1342 = J.num(v_i_1342) + 1.0
	var _t530 = J.cmp(v_t_1331, 0.18, ">")
	if (J.cmp(v_t_1331, J.gp(v_N_1329, "TC"), "<") if _t530 else _t530):
		var _t531 = J.gp(v_f_1336, "x")
		J.mc(v_N_1329, "speed", [v_ctx_1327, J.sub((_t531 if J.t(_t531) else 0.0), J.mul(0.3, v_H_1332)), J.mul((-0.5), v_H_1332), 1.0, 0.0, J.mul(0.4, v_H_1332), J.mul(0.5, v_H_1332), 1.0, "rgba(240,240,255,.7)", 703.0, 5.0])
	J.mc(v_N_1329, "pop", [v_ctx_1327, v_S_1330, J.mul((-0.1), v_H_1332), J.mul((-1.05), v_H_1332), "叭叭！", J.mul(0.12, v_H_1332), "#ffe066", 0.02, 0.2])
	v_T_1337 = J.mc(v_N_1329, "tgt", [v_S_1330, 0.55])
	v_p_1338 = J.sub(v_t_1331, J.gp(v_N_1329, "TC"))
	var _t532 = J.cmp(v_p_1338, 0.0, ">=")
	if (J.cmp(v_p_1338, 0.35, "<") if _t532 else _t532):
		v_i_1343 = 0.0
		while true:
			if not J.cmp(v_i_1343, 6.0, "<"): break
			v_an_1344 = ((-PI) * (0.1 + J.mul(0.8, J.mc(v_N_1329, "rnd", [J.add(v_i_1343, 710.0)]))))
			v_sp_1345 = J.mul(J.mul(J.add(0.5, J.mc(v_N_1329, "rnd", [J.add(v_i_1343, 720.0)])), 1.2), v_th_1333)
			v_x_1346 = J.add(J.gp(v_T_1337, 0.0), J.mul(J.mul(cos(J.num(v_an_1344)), v_sp_1345), v_p_1338))
			v_y_1347 = J.add(J.add(J.gp(v_T_1337, 1.0), J.mul(J.mul(sin(J.num(v_an_1344)), v_sp_1345), v_p_1338)), J.mul(J.mul(J.mul(3.0, v_th_1333), v_p_1338), v_p_1338))
			J.mc(v_ctx_1327, "save", [])
			var _t533 = J.mul(J.gp(v_ctx_1327, "globalAlpha"), (1.0 - J.div(v_p_1338, 0.35)))
			J.sp(v_ctx_1327, "globalAlpha", _t533)
			J.mc(v_ctx_1327, "translate", [v_x_1346, v_y_1347])
			J.mc(v_ctx_1327, "rotate", [J.add(J.mul(v_p_1338, 15.0), v_i_1343)])
			var _t534 = ("#9aa0ae" if J.t(J.mod(v_i_1343, 2.0)) else "#d0d4dc")
			J.sp(v_ctx_1327, "fillStyle", _t534)
			J.sp(v_ctx_1327, "strokeStyle", "#3a3a44")
			var _t535 = J.mul(0.008, v_th_1333)
			J.sp(v_ctx_1327, "lineWidth", _t535)
			J.mc(v_ctx_1327, "beginPath", [])
			J.mc(v_ctx_1327, "arc", [0.0, 0.0, J.mul(0.025, v_th_1333), 0.0, 7.0])
			J.mc(v_ctx_1327, "fill", [])
			J.mc(v_ctx_1327, "stroke", [])
			J.sp(v_ctx_1327, "fillStyle", "#3a3a44")
			J.mc(v_ctx_1327, "fillRect", [J.mul((-0.008), v_th_1333), J.mul((-0.008), v_th_1333), J.mul(0.016, v_th_1333), J.mul(0.016, v_th_1333)])
			J.mc(v_ctx_1327, "restore", [])
			v_i_1343 = J.num(v_i_1343) + 1.0
	var _t536 = J.cmp(v_p_1338, 0.0, ">=")
	if (J.cmp(v_p_1338, 0.14, "<") if _t536 else _t536):
		J.mc(v_N_1329, "burst", [v_ctx_1327, J.gp(v_T_1337, 0.0), J.gp(v_T_1337, 1.0), J.mul(0.4, v_th_1333), (1.0 - J.div(v_p_1338, 0.14)), "#fff0b0", 731.0, 12.0])
	J.mc(v_N_1329, "pop", [v_ctx_1327, v_S_1330, J.gp(v_T_1337, 0.0), J.sub(J.gp(v_T_1337, 1.0), J.mul(0.5, v_th_1333)), "碰！", J.mul(0.28, v_th_1333), "#ffe066", J.gp(v_N_1329, "TC"), 0.3])
	J.mc(v_N_1329, "hit", [v_S_1330, J.gp(v_T_1337, 0.0), J.gp(v_T_1337, 1.0)])
	J.mc(J.G.get("N30M"), "end", [v_ctx_1327])

func _f90(this_, a: Array, env):
	var v_ctx_1350 = null; var v_a_1351 = null; var v_N_1352 = null; var v_S_1353 = null; var v_t_1354 = null; var v_H_1355 = null; var v_th_1356 = null; var v_jit_1357 = null; var v_f_1358 = null; var v_m_1359 = null; var v_plug_1360 = null; var v_T_1361 = null; var v_p_1362 = null; var v_i_1363 = null; var v_an_1364 = null; var v_k_1365 = null; var v_end_1366 = null; var v_sd_1367 = null; var v_al_1368 = null; var v_i_1369 = null; var v_an_1370 = null; var v_r1_1371 = null; var v_r2_1372 = null
	v_ctx_1350 = J.arg(a, 0)
	v_a_1351 = J.arg(a, 1)
	v_N_1352 = J.G.get("N30K")
	v_S_1353 = J.mc(v_N_1352, "setup", [v_a_1351])
	if (not J.t(v_S_1353)):
		return false
	v_t_1354 = J.gp(v_S_1353, "tt")
	v_H_1355 = J.gp(v_S_1353, "H")
	v_th_1356 = J.gp(v_S_1353, "th")
	var _t539 = J.cmp(v_t_1354, 0.22, ">")
	v_jit_1357 = (J.mul((sin(J.num(J.mul(v_t_1354, 160.0))) * 0.01), v_H_1355) if (J.cmp(v_t_1354, 0.4, "<") if _t539 else _t539) else 0.0)
	v_f_1358 = J.mc(v_N_1352, "kf", [v_t_1354, [[0.0, {}], [0.16, {"armF": (-0.55), "head": (-0.1), "hairL": 0.25, "hairR": 0.25, "r": (-3.0)}], [J.gp(v_N_1352, "TC"), {"armF": (-0.75), "head": 0.08, "hairL": 0.35, "hairR": 0.35, "r": 5.0, "x": J.mul(0.02, v_H_1355)}, "o"], [0.4, {"armF": (-0.6), "hairL": 0.3, "hairR": 0.3}], [0.5, {"head": 0.15, "sy": 0.96}], [0.59, {}]]])
	var _t540 = J.gp(v_f_1358, "x")
	var _t541 = J.add((_t540 if J.t(_t540) else 0.0), v_jit_1357)
	J.sp(v_f_1358, "x", _t541)
	J.mc(J.G.get("N30M"), "begin", [v_ctx_1350, v_S_1353, J.gp(v_f_1358, "x")])
	J.mc(v_N_1352, "whole", [v_ctx_1350, v_S_1353, v_f_1358, null, 0.3])
	v_m_1359 = J.mc(v_N_1352, "bm", [v_S_1353, v_f_1358])
	v_plug_1360 = J.mc(v_N_1352, "at", [v_S_1353, v_m_1359, 0.14, 0.32])
	v_T_1361 = J.mc(v_N_1352, "tgt", [v_S_1353, 0.55])
	if J.cmp(v_t_1354, 0.22, "<"):
		v_i_1363 = 0.0
		while true:
			if not J.cmp(v_i_1363, 4.0, "<"): break
			v_an_1364 = J.mul(J.mc(v_N_1352, "rnd", [J.add(floor(J.num(J.mul(v_t_1354, 40.0))), v_i_1363)]), 6.28)
			J.mc(v_N_1352, "crayon", [v_ctx_1350, [v_plug_1360, [J.add(J.gp(v_plug_1360, 0.0), J.mul((cos(J.num(v_an_1364)) * 0.08), v_H_1355)), J.add(J.gp(v_plug_1360, 1.0), J.mul((sin(J.num(v_an_1364)) * 0.08), v_H_1355))]], "#ffe14a", J.mul(0.012, v_H_1355), J.add(740.0, v_i_1363), J.mc(v_N_1352, "seg", [v_t_1354, 0.03, 0.15])])
			v_i_1363 = J.num(v_i_1363) + 1.0
	var _t542 = J.cmp(v_t_1354, 0.2, ">")
	if (J.cmp(v_t_1354, 0.42, "<") if _t542 else _t542):
		v_k_1365 = J.mc(v_N_1352, "seg", [v_t_1354, 0.2, J.gp(v_N_1352, "TC")])
		v_end_1366 = [J.mc(v_N_1352, "lerp", [J.gp(v_plug_1360, 0.0), J.gp(v_T_1361, 0.0), v_k_1365]), J.mc(v_N_1352, "lerp", [J.gp(v_plug_1360, 1.0), J.gp(v_T_1361, 1.0), v_k_1365])]
		v_sd_1367 = floor(J.num(J.mul(v_t_1354, 50.0)))
		J.mc(J.G.get("N30M"), "bolt", [v_ctx_1350, v_plug_1360, v_end_1366, J.mul(0.02, v_H_1355), J.add(750.0, v_sd_1367), "#ffe14a", J.sub(1.0, J.mc(v_N_1352, "seg", [v_t_1354, 0.36, 0.42]))])
		J.mc(J.G.get("N30M"), "bolt", [v_ctx_1350, v_plug_1360, v_end_1366, J.mul(0.012, v_H_1355), J.add(760.0, v_sd_1367), "#9fe8ff", (0.8 * J.sub(1.0, J.mc(v_N_1352, "seg", [v_t_1354, 0.36, 0.42])))])
	v_p_1362 = J.sub(v_t_1354, J.gp(v_N_1352, "TC"))
	var _t543 = J.cmp(v_p_1362, 0.0, ">=")
	if (J.cmp(v_p_1362, 0.22, "<") if _t543 else _t543):
		v_al_1368 = (1.0 - J.div(v_p_1362, 0.22))
		v_i_1369 = 0.0
		while true:
			if not J.cmp(v_i_1369, 6.0, "<"): break
			v_an_1370 = ((J.div(v_i_1369, 6.0) * 6.28) + J.mul(v_p_1362, 20.0))
			v_r1_1371 = J.mul(0.3, v_th_1356)
			v_r2_1372 = J.mul(0.42, v_th_1356)
			J.mc(J.G.get("N30M"), "bolt", [v_ctx_1350, [J.add(J.gp(v_T_1361, 0.0), (J.mul(cos(J.num(v_an_1370)), v_r1_1371) * 0.6)), J.add(J.gp(v_T_1361, 1.0), J.mul(sin(J.num(v_an_1370)), v_r1_1371))], [J.add(J.gp(v_T_1361, 0.0), (J.mul(cos(J.num(J.add(v_an_1370, 0.4))), v_r2_1372) * 0.6)), J.add(J.gp(v_T_1361, 1.0), J.mul(sin(J.num(J.add(v_an_1370, 0.4))), v_r2_1372))], J.mul(0.012, v_th_1356), J.add(J.add(770.0, v_i_1369), floor(J.num(J.mul(v_p_1362, 40.0)))), "#ffe14a", v_al_1368])
			v_i_1369 = J.num(v_i_1369) + 1.0
	var _t544 = J.cmp(v_p_1362, 0.0, ">=")
	if (J.cmp(v_p_1362, 0.12, "<") if _t544 else _t544):
		J.mc(v_N_1352, "burst", [v_ctx_1350, J.gp(v_T_1361, 0.0), J.gp(v_T_1361, 1.0), J.mul(0.36, v_th_1356), (1.0 - J.div(v_p_1362, 0.12)), "#fffbd0", 781.0, 10.0])
	J.mc(v_N_1352, "pop", [v_ctx_1350, v_S_1353, J.gp(v_T_1361, 0.0), J.sub(J.gp(v_T_1361, 1.0), J.mul(0.55, v_th_1356)), "滋滋滋！", J.mul(0.2, v_th_1356), "#ffe14a", J.gp(v_N_1352, "TC"), 0.32])
	J.mc(v_N_1352, "puff", [v_ctx_1350, J.gp(J.mc(v_N_1352, "at", [v_S_1353, v_m_1359, 0.55, 0.05]), 0.0), J.gp(J.mc(v_N_1352, "at", [v_S_1353, v_m_1359, 0.55, 0.05]), 1.0), J.mul(0.07, v_H_1355), J.mc(v_N_1352, "seg", [v_t_1354, 0.42, 0.59]), "rgba(110,100,100,.55)", 782.0, 4.0])
	J.mc(v_N_1352, "hit", [v_S_1353, J.gp(v_T_1361, 0.0), J.gp(v_T_1361, 1.0)])
	J.mc(J.G.get("N30M"), "end", [v_ctx_1350])

func _f91(this_, a: Array, env):
	var v_ctx_1375 = null; var v_a_1376 = null; var v_N_1377 = null; var v_S_1378 = null; var v_t_1379 = null; var v_H_1380 = null; var v_th_1381 = null; var v_f_1382 = null; var v_m_1383 = null; var v_nose_1384 = null; var v_T_1385 = null; var v_p_1386 = null; var v_k_1387 = null; var v_x_1388 = null; var v_y_1389 = null; var v_L_1390 = null; var v_C_1391 = null; var v_w_1392 = null; var v_h_1393 = null; var v_crack_1394 = null; var v_al_1395 = null
	v_ctx_1375 = J.arg(a, 0)
	v_a_1376 = J.arg(a, 1)
	v_N_1377 = J.G.get("N30K")
	v_S_1378 = J.mc(v_N_1377, "setup", [v_a_1376])
	if (not J.t(v_S_1378)):
		return false
	v_t_1379 = J.gp(v_S_1378, "tt")
	v_H_1380 = J.gp(v_S_1378, "H")
	v_th_1381 = J.gp(v_S_1378, "th")
	v_f_1382 = J.mc(v_N_1377, "kf", [v_t_1379, [[0.0, {}], [0.08, {"head": (-0.12), "r": (-2.0)}], [0.12, {"head": (-0.06)}], [0.19, {"head": (-0.25), "r": (-6.0), "sy": 1.04, "body": (-0.08)}], [0.23, {"head": 0.25, "r": 9.0, "sy": 0.96, "body": 0.12, "x": J.mul(0.03, v_H_1380)}, "o"], [0.4, {"head": 0.15, "r": 6.0, "x": J.mul(0.03, v_H_1380)}], [0.59, {}]]])
	J.mc(J.G.get("N30M"), "begin", [v_ctx_1375, v_S_1378, J.gp(v_f_1382, "x")])
	J.mc(v_N_1377, "whole", [v_ctx_1375, v_S_1378, v_f_1382, null, 0.3])
	v_m_1383 = J.mc(v_N_1377, "bm", [v_S_1378, v_f_1382])
	v_nose_1384 = J.mc(v_N_1377, "at", [v_S_1378, v_m_1383, 0.4, 0.3])
	v_T_1385 = J.mc(v_N_1377, "tgt", [v_S_1378, 0.75])
	J.mc(v_N_1377, "pop", [v_ctx_1375, v_S_1378, J.gp(v_nose_1384, 0.0), J.sub(J.gp(v_nose_1384, 1.0), J.mul(0.3, v_H_1380)), "哈……", J.mul(0.1, v_H_1380), "#cfeaff", 0.02, 0.18])
	J.mc(v_N_1377, "pop", [v_ctx_1375, v_S_1378, J.add(J.gp(v_nose_1384, 0.0), J.mul(0.1, v_H_1380)), J.sub(J.gp(v_nose_1384, 1.0), J.mul(0.3, v_H_1380)), "哈啾！", J.mul(0.14, v_H_1380), "#ffffff", 0.2, 0.2])
	var _t547 = J.cmp(v_t_1379, 0.21, ">")
	if (J.cmp(v_t_1379, J.add(J.gp(v_N_1377, "TC"), 0.01), "<") if _t547 else _t547):
		v_k_1387 = J.mc(v_N_1377, "seg", [v_t_1379, 0.21, J.gp(v_N_1377, "TC")])
		v_x_1388 = J.mc(v_N_1377, "lerp", [J.gp(v_nose_1384, 0.0), J.gp(v_T_1385, 0.0), v_k_1387])
		v_y_1389 = J.mc(v_N_1377, "lerp", [J.gp(v_nose_1384, 1.0), J.gp(v_T_1385, 1.0), v_k_1387])
		v_L_1390 = J.mul(0.16, v_H_1380)
		J.mc(v_ctx_1375, "save", [])
		J.mc(v_ctx_1375, "translate", [v_x_1388, v_y_1389])
		J.mc(v_ctx_1375, "rotate", [atan2(J.num(J.sub(J.gp(v_T_1385, 1.0), J.gp(v_nose_1384, 1.0))), J.num(J.sub(J.gp(v_T_1385, 0.0), J.gp(v_nose_1384, 0.0))))])
		J.sp(v_ctx_1375, "fillStyle", "rgba(210,240,255,.95)")
		J.sp(v_ctx_1375, "strokeStyle", "#4a8ac8")
		var _t548 = J.mul(0.008, v_H_1380)
		J.sp(v_ctx_1375, "lineWidth", _t548)
		J.mc(v_ctx_1375, "beginPath", [])
		J.mc(v_ctx_1375, "moveTo", [J.mul(v_L_1390, 0.5), 0.0])
		J.mc(v_ctx_1375, "lineTo", [((-J.num(v_L_1390)) * 0.5), J.mul((-0.03), v_H_1380)])
		J.mc(v_ctx_1375, "lineTo", [((-J.num(v_L_1390)) * 0.45), J.mul(0.03, v_H_1380)])
		J.mc(v_ctx_1375, "closePath", [])
		J.mc(v_ctx_1375, "fill", [])
		J.mc(v_ctx_1375, "stroke", [])
		J.mc(v_ctx_1375, "restore", [])
		J.mc(v_N_1377, "speed", [v_ctx_1375, v_x_1388, v_y_1389, 1.0, 0.0, J.mul(0.25, v_H_1380), J.mul(0.06, v_H_1380), 0.8, "rgba(220,240,255,.8)", 790.0, 3.0])
	v_p_1386 = J.sub(v_t_1379, J.gp(v_N_1377, "TC"))
	var _t549 = J.cmp(v_p_1386, 0.0, ">=")
	if (J.cmp(v_p_1386, 0.3, "<") if _t549 else _t549):
		v_C_1391 = [J.add(J.gp(v_S_1378, "tx"), J.gp(v_S_1378, "back")), J.gp(v_S_1378, "ty")]
		v_w_1392 = J.mul(0.62, v_th_1381)
		v_h_1393 = J.mul(1.05, v_th_1381)
		v_crack_1394 = J.mc(v_N_1377, "seg", [v_p_1386, 0.15, 0.3])
		v_al_1395 = J.sub(1.0, v_crack_1394)
		J.mc(v_ctx_1375, "save", [])
		var _t550 = J.mul(J.gp(v_ctx_1375, "globalAlpha"), J.mul(v_al_1395, 0.75))
		J.sp(v_ctx_1375, "globalAlpha", _t550)
		J.sp(v_ctx_1375, "fillStyle", "rgba(190,230,255,.55)")
		J.sp(v_ctx_1375, "strokeStyle", "#6aaee0")
		var _t551 = J.mul(0.02, v_th_1381)
		J.sp(v_ctx_1375, "lineWidth", _t551)
		J.mc(v_ctx_1375, "beginPath", [])
		J.mc(v_ctx_1375, "roundRect", [J.sub(J.gp(v_C_1391, 0.0), J.div(v_w_1392, 2.0)), J.sub(J.gp(v_C_1391, 1.0), v_h_1393), v_w_1392, v_h_1393, J.mul(0.05, v_th_1381)])
		J.mc(v_ctx_1375, "fill", [])
		J.mc(v_ctx_1375, "stroke", [])
		J.sp(v_ctx_1375, "strokeStyle", "rgba(255,255,255,.9)")
		J.mc(v_ctx_1375, "beginPath", [])
		J.mc(v_ctx_1375, "moveTo", [J.sub(J.gp(v_C_1391, 0.0), J.mul(v_w_1392, 0.35)), J.sub(J.gp(v_C_1391, 1.0), J.mul(v_h_1393, 0.85))])
		J.mc(v_ctx_1375, "lineTo", [J.sub(J.gp(v_C_1391, 0.0), J.mul(v_w_1392, 0.2)), J.sub(J.gp(v_C_1391, 1.0), J.mul(v_h_1393, 0.55))])
		J.mc(v_ctx_1375, "stroke", [])
		if J.cmp(v_crack_1394, 0.0, ">"):
			J.mc(v_N_1377, "crayon", [v_ctx_1375, [[J.gp(v_C_1391, 0.0), J.sub(J.gp(v_C_1391, 1.0), v_h_1393)], [J.sub(J.gp(v_C_1391, 0.0), J.mul(0.05, v_th_1381)), J.sub(J.gp(v_C_1391, 1.0), J.mul(v_h_1393, 0.6))], [J.add(J.gp(v_C_1391, 0.0), J.mul(0.06, v_th_1381)), J.sub(J.gp(v_C_1391, 1.0), J.mul(v_h_1393, 0.3))], [J.gp(v_C_1391, 0.0), J.gp(v_C_1391, 1.0)]], "#ffffff", J.mul(0.015, v_th_1381), 795.0])
		J.mc(v_ctx_1375, "restore", [])
	var _t552 = J.cmp(v_p_1386, 0.0, ">=")
	if (J.cmp(v_p_1386, 0.12, "<") if _t552 else _t552):
		J.mc(v_N_1377, "burst", [v_ctx_1375, J.gp(v_T_1385, 0.0), J.gp(v_T_1385, 1.0), J.mul(0.3, v_th_1381), (1.0 - J.div(v_p_1386, 0.12)), "#e8f6ff", 797.0, 9.0])
	J.mc(v_N_1377, "pop", [v_ctx_1375, v_S_1378, J.gp(v_T_1385, 0.0), J.sub(J.gp(v_T_1385, 1.0), J.mul(0.45, v_th_1381)), "凍親！", J.mul(0.2, v_th_1381), "#c8e8ff", J.gp(v_N_1377, "TC"), 0.3])
	J.mc(v_N_1377, "hit", [v_S_1378, J.gp(v_T_1385, 0.0), J.gp(v_T_1385, 1.0)])
	J.mc(J.G.get("N30M"), "end", [v_ctx_1375])

func _f92(this_, a: Array, env):
	var v_ctx_1398 = null; var v_a_1399 = null; var v_N_1400 = null; var v_S_1401 = null; var v_t_1402 = null; var v_H_1403 = null; var v_th_1404 = null; var v_CC_1405 = null; var v_f_1406 = null; var v_T_1407 = null; var v_top_1408 = null; var v_m_1409 = null; var v_hd_1410 = null; var v_p_1411 = null; var v_x_1412 = null; var v_y_1413 = null; var v_r_1414 = null; var v_k_1415 = null; var v_q_1416 = null
	v_ctx_1398 = J.arg(a, 0)
	v_a_1399 = J.arg(a, 1)
	v_N_1400 = J.G.get("N30K")
	v_S_1401 = J.mc(v_N_1400, "setup", [v_a_1399])
	if (not J.t(v_S_1401)):
		return false
	v_t_1402 = J.gp(v_S_1401, "tt")
	v_H_1403 = J.gp(v_S_1401, "H")
	v_th_1404 = J.gp(v_S_1401, "th")
	v_CC_1405 = [0.2, 0.585]
	v_f_1406 = J.mc(v_N_1400, "kf", [v_t_1402, [[0.0, {}], [0.12, {"head": (-0.25), "armB": (-0.9), "r": (-4.0)}], [0.24, {"head": (-0.15), "armB": (-0.8)}], [J.gp(v_N_1400, "TC"), {"head": 0.1, "armB": (-0.2), "sy": 0.95}, "o"], [0.4, {"head": 0.15, "sy": 0.96}], [0.59, {}]]])
	J.mc(J.G.get("N30M"), "begin", [v_ctx_1398, v_S_1401, J.gp(v_f_1406, "x")])
	J.mc(v_N_1400, "whole", [v_ctx_1398, v_S_1401, v_f_1406, null, 0.3])
	v_T_1407 = J.mc(v_N_1400, "tgt", [v_S_1401, 0.95])
	v_top_1408 = [J.gp(v_T_1407, 0.0), J.sub(J.gp(v_T_1407, 1.0), J.mul(1.8, v_H_1403))]
	var _t555 = J.cmp(v_t_1402, 0.08, ">")
	if (J.cmp(v_t_1402, 0.5, "<") if _t555 else _t555):
		v_x_1412 = null
		v_y_1413 = null
		v_r_1414 = null
		if J.cmp(v_t_1402, J.gp(v_N_1400, "TC"), "<"):
			var _t556 = J.gp(v_N_1400, "E")
			v_k_1415 = J.mc(_t556, "i", [J.mc(v_N_1400, "seg", [v_t_1402, 0.1, J.gp(v_N_1400, "TC")])])
			v_x_1412 = J.gp(v_top_1408, 0.0)
			var _t557 = J.mc(v_N_1400, "lerp", [J.gp(v_top_1408, 1.0), J.sub(J.gp(v_T_1407, 1.0), J.mul(0.1, v_th_1404)), v_k_1415])
			v_y_1413 = _t557
			var _t558 = J.mul(v_k_1415, 90.0)
			v_r_1414 = _t558
		else:
			v_q_1416 = J.mc(v_N_1400, "seg", [v_t_1402, J.gp(v_N_1400, "TC"), 0.5])
			var _t559 = J.add(J.gp(v_T_1407, 0.0), J.mul(J.mul(v_q_1416, 0.6), v_th_1404))
			v_x_1412 = _t559
			var _t560 = ((J.sub(J.gp(v_T_1407, 1.0), J.mul(0.1, v_th_1404)) - (J.mul(0.5, v_th_1404) * sin(J.num(J.mul(v_q_1416, PI))))) + J.mul((J.mul(v_q_1416, v_q_1416) * 0.9), v_th_1404))
			v_y_1413 = _t560
			var _t561 = (90.0 + J.mul(v_q_1416, 400.0))
			v_r_1414 = _t561
		J.mc(v_N_1400, "pieceAt", [v_ctx_1398, v_S_1401, "coconut", v_x_1412, v_y_1413, v_r_1414, J.gp(v_CC_1405, 0.0), J.gp(v_CC_1405, 1.0), 1.0, 1.0, J.sub(1.0, J.mc(v_N_1400, "seg", [v_t_1402, 0.45, 0.5]))])
		if J.cmp(v_t_1402, J.gp(v_N_1400, "TC"), "<"):
			J.mc(v_N_1400, "speed", [v_ctx_1398, v_x_1412, J.sub(v_y_1413, J.mul(0.1, v_H_1403)), 0.0, (-1.0), J.mul(0.25, v_H_1403), J.mul(0.12, v_H_1403), J.mc(v_N_1400, "seg", [v_t_1402, 0.18, 0.24]), "rgba(255,255,255,.7)", 800.0, 3.0])
	v_m_1409 = J.mc(v_N_1400, "bm", [v_S_1401, v_f_1406])
	v_hd_1410 = J.mc(v_N_1400, "at", [v_S_1401, v_m_1409, 0.42, 0.1])
	J.mc(v_N_1400, "pop", [v_ctx_1398, v_S_1401, J.gp(v_hd_1410, 0.0), J.sub(J.gp(v_hd_1410, 1.0), J.mul(0.15, v_H_1403)), "小心頭頂！", J.mul(0.1, v_H_1403), "#ffe066", 0.06, 0.2])
	v_p_1411 = J.sub(v_t_1402, J.gp(v_N_1400, "TC"))
	var _t562 = J.cmp(v_p_1411, 0.0, ">=")
	if (J.cmp(v_p_1411, 0.13, "<") if _t562 else _t562):
		J.mc(v_N_1400, "burst", [v_ctx_1398, J.gp(v_T_1407, 0.0), J.gp(v_T_1407, 1.0), J.mul(0.32, v_th_1404), (1.0 - J.div(v_p_1411, 0.13)), "#fff0c0", 805.0, 10.0])
	var _t563 = J.cmp(v_p_1411, 0.0, ">=")
	if (J.cmp(v_p_1411, 0.3, "<") if _t563 else _t563):
		J.mc(v_N_1400, "stars", [v_ctx_1398, J.gp(v_T_1407, 0.0), J.sub(J.gp(v_T_1407, 1.0), J.mul(0.05, v_th_1404)), J.mul(0.2, v_th_1404), v_t_1402, (1.0 - J.div(v_p_1411, 0.3))])
	J.mc(v_N_1400, "pop", [v_ctx_1398, v_S_1401, J.gp(v_T_1407, 0.0), J.sub(J.gp(v_T_1407, 1.0), J.mul(0.25, v_th_1404)), "咚！", J.mul(0.26, v_th_1404), "#ffe066", J.gp(v_N_1400, "TC"), 0.26])
	J.mc(v_N_1400, "pop", [v_ctx_1398, v_S_1401, J.gp(v_hd_1410, 0.0), J.sub(J.gp(v_hd_1410, 1.0), J.mul(0.15, v_H_1403)), "好痛呀……", J.mul(0.1, v_H_1403), "#ffd0d0", 0.42, 0.17])
	J.mc(v_N_1400, "hit", [v_S_1401, J.gp(v_T_1407, 0.0), J.add(J.gp(v_T_1407, 1.0), J.mul(0.1, v_th_1404))])
	J.mc(J.G.get("N30M"), "end", [v_ctx_1398])

func _f93(this_, a: Array, env):
	var v_ctx_1419 = null; var v_a_1420 = null; var v_N_1421 = null; var v_S_1422 = null; var v_t_1423 = null; var v_H_1424 = null; var v_th_1425 = null; var v_DC_1426 = null; var v_f_1427 = null; var v_m_1428 = null; var v_back_1429 = null; var v_T_1430 = null; var v_x_1431 = null; var v_y_1432 = null; var v_r_1433 = null; var v_s_1434 = null; var v_al_1435 = null; var v_behind_1436 = null; var v_p_1437 = null; var v_k_1438 = null; var v_q_1439 = null; var v_st_1440 = null; var v_q_1441 = null; var v_i_1442 = null; var v_an_1443 = null; var v_r0_1444 = null; var v_r1_1445 = null; var v_i_1446 = null; var v_q_1447 = null; var v_pts_1448 = null; var v_j_1449 = null
	v_ctx_1419 = J.arg(a, 0)
	v_a_1420 = J.arg(a, 1)
	v_N_1421 = J.G.get("N30K")
	v_S_1422 = J.mc(v_N_1421, "setup", [v_a_1420])
	if (not J.t(v_S_1422)):
		return false
	v_t_1423 = J.gp(v_S_1422, "tt")
	v_H_1424 = J.gp(v_S_1422, "H")
	v_th_1425 = J.gp(v_S_1422, "th")
	v_DC_1426 = [0.16, 0.56]
	v_f_1427 = J.mc(v_N_1421, "kf", [v_t_1423, [[0.0, {}], [0.15, {"armB": 0.9, "r": (-8.0), "body": (-0.1), "head": (-0.08)}], [0.21, {"armB": (-1.0), "r": 10.0, "body": 0.15, "x": J.mul(0.04, v_H_1424)}, "o"], [0.38, {"armB": (-0.6), "r": 6.0, "x": J.mul(0.03, v_H_1424)}], [0.59, {}]]])
	J.mc(J.G.get("N30M"), "begin", [v_ctx_1419, v_S_1422, J.gp(v_f_1427, "x")])
	v_m_1428 = J.mc(v_N_1421, "bm", [v_S_1422, v_f_1427])
	v_back_1429 = J.mc(v_N_1421, "at", [v_S_1422, v_m_1428, 0.82, 0.5])
	v_T_1430 = J.mc(v_N_1421, "tgt", [v_S_1422, 0.6])
	v_x_1431 = null
	v_y_1432 = null
	v_r_1433 = null
	v_s_1434 = 1.0
	v_al_1435 = 1.0
	if J.cmp(v_t_1423, 0.17, "<"):
		var _t566 = J.gp(v_N_1421, "E")
		v_k_1438 = J.mc(_t566, "back", [J.mc(v_N_1421, "seg", [v_t_1423, 0.04, 0.15])])
		v_x_1431 = J.gp(v_back_1429, 0.0)
		var _t567 = J.sub(J.gp(v_back_1429, 1.0), J.mul(0.05, v_H_1424))
		v_y_1432 = _t567
		v_r_1433 = (-20.0)
		var _t568 = J.mul(0.85, v_k_1438)
		v_s_1434 = _t568
	else:
		if J.cmp(v_t_1423, J.gp(v_N_1421, "TC"), "<"):
			v_q_1439 = J.mc(v_N_1421, "seg", [v_t_1423, 0.17, J.gp(v_N_1421, "TC")])
			v_st_1440 = J.mc(v_N_1421, "at", [v_S_1422, v_m_1428, 0.6, 0.15])
			var _t569 = J.mc(v_N_1421, "lerp", [J.gp(v_st_1440, 0.0), J.gp(v_T_1430, 0.0), v_q_1439])
			v_x_1431 = _t569
			var _t570 = J.sub(J.mc(v_N_1421, "lerp", [J.gp(v_st_1440, 1.0), J.gp(v_T_1430, 1.0), v_q_1439]), (J.mul((J.mul(0.3, v_H_1424) * 4.0), v_q_1439) * J.sub(1.0, v_q_1439)))
			v_y_1432 = _t570
			var _t571 = J.mul(v_q_1439, 400.0)
			v_r_1433 = _t571
			v_s_1434 = 0.85
		else:
			v_q_1441 = J.mc(v_N_1421, "seg", [v_t_1423, J.gp(v_N_1421, "TC"), 0.55])
			var _t572 = J.sub(J.add(J.gp(v_T_1430, 0.0), J.mul(0.1, v_th_1425)), J.mul(J.mul(v_q_1441, 0.2), v_th_1425))
			v_x_1431 = _t572
			var _t574 = J.gp(v_T_1430, 1.0)
			var _t575 = J.sub(J.gp(v_S_1422, "ty"), J.mul(0.15, v_th_1425))
			var _t573 = J.gp(v_N_1421, "E")
			var _t576 = J.mc(v_N_1421, "lerp", [_t574, _t575, J.mc(_t573, "i", [J.min_([1.0, J.mul(v_q_1441, 2.0)])])])
			v_y_1432 = _t576
			var _t577 = (400.0 + J.mul(v_q_1441, 200.0))
			v_r_1433 = _t577
			v_s_1434 = 0.85
			var _t578 = J.sub(1.0, J.mc(v_N_1421, "seg", [v_t_1423, 0.5, 0.56]))
			v_al_1435 = _t578
	v_behind_1436 = J.cmp(v_t_1423, 0.17, "<")
	if J.t((J.cmp(v_s_1434, 0.02, ">") if J.t(v_behind_1436) else v_behind_1436)):
		J.mc(v_N_1421, "pieceAt", [v_ctx_1419, v_S_1422, "durian", v_x_1431, v_y_1432, v_r_1433, J.gp(v_DC_1426, 0.0), J.gp(v_DC_1426, 1.0), v_s_1434, v_s_1434, v_al_1435])
	J.mc(v_N_1421, "whole", [v_ctx_1419, v_S_1422, v_f_1427, null, 0.3])
	var _t579 = (not J.t(v_behind_1436))
	if (J.cmp(v_al_1435, 0.0, ">") if _t579 else _t579):
		J.mc(v_N_1421, "pieceAt", [v_ctx_1419, v_S_1422, "durian", v_x_1431, v_y_1432, v_r_1433, J.gp(v_DC_1426, 0.0), J.gp(v_DC_1426, 1.0), v_s_1434, v_s_1434, v_al_1435])
	v_p_1437 = J.sub(v_t_1423, J.gp(v_N_1421, "TC"))
	var _t580 = J.cmp(v_p_1437, 0.0, ">=")
	if (J.cmp(v_p_1437, 0.25, "<") if _t580 else _t580):
		v_i_1442 = 0.0
		while true:
			if not J.cmp(v_i_1442, 10.0, "<"): break
			v_an_1443 = (J.div(v_i_1442, 10.0) * 6.28)
			v_r0_1444 = J.mul(0.15, v_th_1425)
			v_r1_1445 = J.mul(J.add(0.25, v_p_1437), v_th_1425)
			J.mc(v_N_1421, "crayon", [v_ctx_1419, [[J.add(J.gp(v_T_1430, 0.0), J.mul(cos(J.num(v_an_1443)), v_r0_1444)), J.add(J.gp(v_T_1430, 1.0), J.mul(sin(J.num(v_an_1443)), v_r0_1444))], [J.add(J.gp(v_T_1430, 0.0), J.mul(cos(J.num(v_an_1443)), v_r1_1445)), J.add(J.gp(v_T_1430, 1.0), J.mul(sin(J.num(v_an_1443)), v_r1_1445))]], "#c8d060", J.mul(0.02, v_th_1425), J.add(810.0, v_i_1442), (1.0 - J.div(v_p_1437, 0.25))])
			v_i_1442 = J.num(v_i_1442) + 1.0
	if J.cmp(v_p_1437, 0.0, ">="):
		v_i_1446 = 0.0
		while true:
			if not J.cmp(v_i_1446, 3.0, "<"): break
			v_q_1447 = J.mc(v_N_1421, "seg", [v_t_1423, J.add(J.gp(v_N_1421, "TC"), J.mul(v_i_1446, 0.04)), 0.59])
			v_pts_1448 = []
			v_j_1449 = 0.0
			while true:
				if not J.cmp(v_j_1449, 6.0, "<="): break
				J.mc(v_pts_1448, "push", [[J.add(J.add(J.gp(v_T_1430, 0.0), J.mul((J.sub(v_i_1446, 1.0) * 0.12), v_th_1425)), J.mul((sin(J.num(J.add(J.add(v_j_1449, J.mul(v_t_1423, 12.0)), v_i_1446))) * 0.03), v_th_1425)), (J.sub(J.gp(v_T_1430, 1.0), J.mul(J.mul(v_j_1449, 0.06), v_th_1425)) - J.mul(J.mul(v_q_1447, 0.2), v_th_1425))]])
				v_j_1449 = J.num(v_j_1449) + 1.0
			J.mc(v_N_1421, "crayon", [v_ctx_1419, v_pts_1448, "rgba(150,190,80,.75)", J.mul(0.015, v_th_1425), J.add(820.0, v_i_1446), sin(J.num(J.mul(v_q_1447, PI)))])
			v_i_1446 = J.num(v_i_1446) + 1.0
	J.mc(v_N_1421, "pop", [v_ctx_1419, v_S_1422, J.gp(v_T_1430, 0.0), J.sub(J.gp(v_T_1430, 1.0), J.mul(0.5, v_th_1425)), "拮！", J.mul(0.26, v_th_1425), "#d8e070", J.gp(v_N_1421, "TC"), 0.28])
	J.mc(v_N_1421, "hit", [v_S_1422, J.gp(v_T_1430, 0.0), J.gp(v_T_1430, 1.0)])
	J.mc(J.G.get("N30M"), "end", [v_ctx_1419])

func _f95(this_, a: Array, env):
	var v_x_1467 = null; var v_y_1468 = null; var v_r_1469 = null
	v_x_1467 = J.arg(a, 0)
	v_y_1468 = J.arg(a, 1)
	v_r_1469 = J.arg(a, 2)
	J.mc(env["ctx"], "save", [])
	J.mc(env["ctx"], "translate", [v_x_1467, v_y_1468])
	var _t583 = env["ctx"]
	J.sp(_t583, "fillStyle", "#fbf8f0")
	var _t584 = env["ctx"]
	J.sp(_t584, "strokeStyle", "#4a3a3a")
	var _t585 = env["ctx"]
	var _t586 = J.mul(v_r_1469, 0.15)
	J.sp(_t585, "lineWidth", _t586)
	J.mc(env["ctx"], "beginPath", [])
	J.mc(env["ctx"], "arc", [0.0, 0.0, v_r_1469, 0.0, 7.0])
	J.mc(env["ctx"], "fill", [])
	J.mc(env["ctx"], "stroke", [])
	var _t587 = env["ctx"]
	J.sp(_t587, "fillStyle", "rgba(255,255,255,.9)")
	J.mc(env["ctx"], "beginPath", [])
	J.mc(env["ctx"], "arc", [((-J.num(v_r_1469)) * 0.35), ((-J.num(v_r_1469)) * 0.35), J.mul(v_r_1469, 0.25), 0.0, 7.0])
	J.mc(env["ctx"], "fill", [])
	J.mc(env["ctx"], "restore", [])

func _f94(this_, a: Array, env):
	var v_a_1453 = null; var v_N_1454 = null; var v_S_1455 = null; var v_t_1456 = null; var v_H_1457 = null; var v_th_1458 = null; var v_f_1459 = null; var v_m_1460 = null; var v_mo_1461 = null; var v_T_1462 = null; var v_shake_1463 = null; var v_ball_1464 = null; var v_R_1465 = null; var v_p_1466 = null; var v_k_1470 = null; var v_q_1471 = null
	var _s283 = {"__p": env, "ctx": null}
	_s283["ctx"] = J.arg(a, 0)
	v_a_1453 = J.arg(a, 1)
	v_N_1454 = J.G.get("N30K")
	v_S_1455 = J.mc(v_N_1454, "setup", [v_a_1453])
	if (not J.t(v_S_1455)):
		return false
	v_t_1456 = J.gp(v_S_1455, "tt")
	v_H_1457 = J.gp(v_S_1455, "H")
	v_th_1458 = J.gp(v_S_1455, "th")
	v_f_1459 = J.mc(v_N_1454, "kf", [v_t_1456, [[0.0, {}], [0.17, {"r": (-9.0), "head": (-0.25), "body": (-0.1), "armF": (-0.6), "sy": 1.04}], [0.22, {"r": 12.0, "head": 0.3, "body": 0.18, "armF": 0.2, "sy": 0.95, "x": J.mul(0.03, v_H_1457)}, "o"], [0.4, {"r": 8.0, "head": 0.2, "body": 0.1}], [0.59, {}]]])
	J.mc(J.G.get("N30M"), "begin", [_s283["ctx"], v_S_1455, J.gp(v_f_1459, "x")])
	J.mc(v_N_1454, "whole", [_s283["ctx"], v_S_1455, v_f_1459, null, 0.3])
	v_m_1460 = J.mc(v_N_1454, "bm", [v_S_1455, v_f_1459])
	v_mo_1461 = J.mc(v_N_1454, "at", [v_S_1455, v_m_1460, 0.48, 0.24])
	v_T_1462 = J.mc(v_N_1454, "tgt", [v_S_1455, 0.86])
	v_shake_1463 = (J.mul((sin(J.num(J.mul(v_t_1456, 90.0))) * 0.01), v_H_1457) if J.cmp(v_t_1456, 0.2, "<") else 0.0)
	v_ball_1464 = Callable(self, "_f95").bind(_s283)
	v_R_1465 = J.mul(0.045, v_H_1457)
	var _t588 = J.cmp(v_t_1456, 0.2, ">")
	if (J.cmp(v_t_1456, J.gp(v_N_1454, "TC"), "<") if _t588 else _t588):
		v_k_1470 = J.mc(v_N_1454, "seg", [v_t_1456, 0.2, J.gp(v_N_1454, "TC")])
		J.cl(v_ball_1464, null, [J.mc(v_N_1454, "lerp", [J.gp(v_mo_1461, 0.0), J.gp(v_T_1462, 0.0), v_k_1470]), J.mc(v_N_1454, "lerp", [J.gp(v_mo_1461, 1.0), J.gp(v_T_1462, 1.0), v_k_1470]), v_R_1465])
		J.mc(v_N_1454, "speed", [_s283["ctx"], J.mc(v_N_1454, "lerp", [J.gp(v_mo_1461, 0.0), J.gp(v_T_1462, 0.0), v_k_1470]), J.mc(v_N_1454, "lerp", [J.gp(v_mo_1461, 1.0), J.gp(v_T_1462, 1.0), v_k_1470]), J.sub(J.gp(v_T_1462, 0.0), J.gp(v_mo_1461, 0.0)), J.sub(J.gp(v_T_1462, 1.0), J.gp(v_mo_1461, 1.0)), J.mul(0.2, v_H_1457), J.mul(0.06, v_H_1457), 0.9, "rgba(255,255,255,.8)", 830.0, 3.0])
	else:
		var _t589 = J.cmp(v_t_1456, J.gp(v_N_1454, "TC"), ">=")
		if (J.cmp(v_t_1456, 0.5, "<") if _t589 else _t589):
			v_q_1471 = J.mc(v_N_1454, "seg", [v_t_1456, J.gp(v_N_1454, "TC"), 0.5])
			J.cl(v_ball_1464, null, [J.sub(J.gp(v_T_1462, 0.0), J.mul(J.mul(v_q_1471, 0.4), v_th_1458)), (J.sub(J.gp(v_T_1462, 1.0), (J.mul(0.4, v_th_1458) * sin(J.num(J.mul(v_q_1471, PI))))) + J.mul((J.mul(v_q_1471, v_q_1471) * 0.9), v_th_1458)), v_R_1465])
	J.mc(v_N_1454, "pop", [_s283["ctx"], v_S_1455, J.add(J.gp(v_mo_1461, 0.0), v_shake_1463), J.sub(J.gp(v_mo_1461, 1.0), J.mul(0.25, v_H_1457)), "咳！", J.mul(0.14, v_H_1457), "#ffffff", 0.19, 0.18])
	v_p_1466 = J.sub(v_t_1456, J.gp(v_N_1454, "TC"))
	var _t590 = J.cmp(v_p_1466, 0.0, ">=")
	if (J.cmp(v_p_1466, 0.13, "<") if _t590 else _t590):
		J.mc(v_N_1454, "burst", [_s283["ctx"], J.gp(v_T_1462, 0.0), J.gp(v_T_1462, 1.0), J.mul(0.3, v_th_1458), (1.0 - J.div(v_p_1466, 0.13)), "#ffffff", 835.0, 9.0])
	J.mc(v_N_1454, "pop", [_s283["ctx"], v_S_1455, J.gp(v_T_1462, 0.0), J.sub(J.gp(v_T_1462, 1.0), J.mul(0.3, v_th_1458)), "噗！", J.mul(0.24, v_th_1458), "#ffffff", J.gp(v_N_1454, "TC"), 0.28])
	J.mc(v_N_1454, "pop", [_s283["ctx"], v_S_1455, J.gp(v_mo_1461, 0.0), J.sub(J.gp(v_mo_1461, 1.0), J.mul(0.25, v_H_1457)), "呼～", J.mul(0.11, v_H_1457), "#d8f0ff", 0.44, 0.15])
	J.mc(v_N_1454, "hit", [v_S_1455, J.gp(v_T_1462, 0.0), J.gp(v_T_1462, 1.0)])
	J.mc(J.G.get("N30M"), "end", [_s283["ctx"]])

func _f96(this_, a: Array, env):
	var v_ctx_1474 = null; var v_a_1475 = null; var v_N_1476 = null; var v_S_1477 = null; var v_t_1478 = null; var v_H_1479 = null; var v_th_1480 = null; var v_lb_1481 = null; var v_f_1482 = null; var v_m_1483 = null; var v_mo_1484 = null; var v_T_1485 = null; var v_p_1486 = null; var v_i_1487 = null; var v_q_1488 = null; var v_k_1489 = null; var v_j_1490 = null; var v_an_1491 = null; var v_r_1492 = null
	v_ctx_1474 = J.arg(a, 0)
	v_a_1475 = J.arg(a, 1)
	v_N_1476 = J.G.get("N30K")
	v_S_1477 = J.mc(v_N_1476, "setup", [v_a_1475])
	if (not J.t(v_S_1477)):
		return false
	v_t_1478 = J.gp(v_S_1477, "tt")
	v_H_1479 = J.gp(v_S_1477, "H")
	v_th_1480 = J.gp(v_S_1477, "th")
	v_lb_1481 = absf(J.num(sin(J.num(J.mul(v_t_1478, 40.0)))))
	v_f_1482 = J.mc(v_N_1476, "kf", [v_t_1478, [[0.0, {}], [0.16, {"r": (-6.0), "head": (-0.15), "sy": 1.03}], [0.24, {"r": 14.0, "head": 0.25, "body": 0.2, "x": J.mul(0.02, v_H_1479)}, "o"], [0.45, {"r": 10.0, "head": 0.2, "body": 0.15}], [0.59, {}]]])
	var _t593 = J.gp(v_f_1482, "y")
	var _t594 = J.sub((_t593 if J.t(_t593) else 0.0), J.mul(J.mul(v_lb_1481, 0.015), v_H_1479))
	J.sp(v_f_1482, "y", _t594)
	var _t595 = J.gp(v_f_1482, "head")
	var _t596 = J.add((_t595 if J.t(_t595) else 0.0), J.mul(v_lb_1481, 0.06))
	J.sp(v_f_1482, "head", _t596)
	J.mc(J.G.get("N30M"), "begin", [v_ctx_1474, v_S_1477, J.gp(v_f_1482, "x")])
	J.mc(v_N_1476, "whole", [v_ctx_1474, v_S_1477, v_f_1482, null, 0.3])
	v_m_1483 = J.mc(v_N_1476, "bm", [v_S_1477, v_f_1482])
	v_mo_1484 = J.mc(v_N_1476, "at", [v_S_1477, v_m_1483, 0.3, 0.3])
	v_T_1485 = J.mc(v_N_1476, "tgt", [v_S_1477, 0.8])
	v_i_1487 = 0.0
	while true:
		if not J.cmp(v_i_1487, 6.0, "<"): break
		v_q_1488 = J.mc(v_N_1476, "seg", [v_t_1478, (0.18 + J.mul(v_i_1487, 0.012)), J.add(J.gp(v_N_1476, "TC"), J.mul(v_i_1487, 0.012))])
		var _t597 = J.cmp(v_q_1488, 0.0, "<=")
		if (_t597 if _t597 else J.cmp(v_q_1488, 1.0, ">=")):
			v_i_1487 = J.num(v_i_1487) + 1.0
			continue
		J.mc(v_N_1476, "txt", [v_ctx_1474, v_S_1477, J.mc(v_N_1476, "lerp", [J.gp(v_mo_1484, 0.0), J.gp(v_T_1485, 0.0), v_q_1488]), J.add(J.mc(v_N_1476, "lerp", [J.gp(v_mo_1484, 1.0), J.gp(v_T_1485, 1.0), v_q_1488]), J.mul((sin(J.num(J.add(J.mul(v_q_1488, 12.0), v_i_1487))) * 0.06), v_H_1479)), (J.mul(0.1, v_H_1479) * (0.8 + J.mul(0.4, v_q_1488))), "哈", ("#ffe066" if J.t(J.mod(v_i_1487, 2.0)) else "#ffb347"), (1.0 - J.mul(v_q_1488, 0.3)), (J.sub(J.mc(v_N_1476, "rnd", [v_i_1487]), 0.5) * 0.6)])
		v_i_1487 = J.num(v_i_1487) + 1.0
	if J.cmp(v_t_1478, 0.2, "<"):
		J.mc(v_N_1476, "pop", [v_ctx_1474, v_S_1477, J.gp(v_mo_1484, 0.0), J.sub(J.gp(v_mo_1484, 1.0), J.mul(0.25, v_H_1479)), "噗…", J.mul(0.1, v_H_1479), "#ffe066", 0.03, 0.16])
	v_p_1486 = J.sub(v_t_1478, J.gp(v_N_1476, "TC"))
	var _t598 = J.cmp(v_p_1486, 0.0, ">=")
	if (J.cmp(v_p_1486, 0.3, "<") if _t598 else _t598):
		v_k_1489 = J.div(v_p_1486, 0.3)
		J.mc(v_N_1476, "txt", [v_ctx_1474, v_S_1477, J.gp(v_T_1485, 0.0), J.sub(J.gp(v_T_1485, 1.0), J.mul(0.35, v_th_1480)), J.mul(0.18, v_th_1480), "哈…哈哈！", "#ffe066", J.sub(1.0, v_k_1489)])
		J.mc(v_N_1476, "drops", [v_ctx_1474, J.gp(v_T_1485, 0.0), J.gp(v_T_1485, 1.0), J.mul(0.3, v_th_1480), J.mod(J.mul(v_p_1486, 3.0), 1.0), "rgba(150,210,255,.9)", (840.0 + floor(J.num(J.mul(v_p_1486, 3.0)))), 4.0])
		J.mc(v_ctx_1474, "save", [])
		var _t599 = J.mul(J.gp(v_ctx_1474, "globalAlpha"), J.sub(1.0, v_k_1489))
		J.sp(v_ctx_1474, "globalAlpha", _t599)
		J.sp(v_ctx_1474, "strokeStyle", "#ffe066")
		var _t600 = J.mul(0.015, v_th_1480)
		J.sp(v_ctx_1474, "lineWidth", _t600)
		J.mc(v_ctx_1474, "beginPath", [])
		v_j_1490 = 0.0
		while true:
			if not J.cmp(v_j_1490, 40.0, "<"): break
			v_an_1491 = (J.mul(v_j_1490, 0.4) + J.mul(v_t_1478, 10.0))
			v_r_1492 = J.mul(J.mul(v_j_1490, 0.004), v_th_1480)
			J.mc(v_ctx_1474, "lineTo", [J.add(J.gp(v_T_1485, 0.0), J.mul(cos(J.num(v_an_1491)), v_r_1492)), (J.sub(J.gp(v_T_1485, 1.0), J.mul(0.1, v_th_1480)) + (J.mul(sin(J.num(v_an_1491)), v_r_1492) * 0.5))])
			v_j_1490 = J.num(v_j_1490) + 1.0
		J.mc(v_ctx_1474, "stroke", [])
		J.mc(v_ctx_1474, "restore", [])
	var _t601 = J.cmp(v_p_1486, 0.0, ">=")
	if (J.cmp(v_p_1486, 0.12, "<") if _t601 else _t601):
		J.mc(v_N_1476, "burst", [v_ctx_1474, J.gp(v_T_1485, 0.0), J.gp(v_T_1485, 1.0), J.mul(0.28, v_th_1480), (1.0 - J.div(v_p_1486, 0.12)), "#fff3b0", 845.0, 9.0])
	J.mc(v_N_1476, "hit", [v_S_1477, J.gp(v_T_1485, 0.0), J.gp(v_T_1485, 1.0)])
	J.mc(J.G.get("N30M"), "end", [v_ctx_1474])

func _f97(this_, a: Array, env):
	var v_ctx_1495 = null; var v_a_1496 = null; var v_N_1497 = null; var v_S_1498 = null; var v_t_1499 = null; var v_H_1500 = null; var v_th_1501 = null; var v_D2_1502 = null; var v_f_1503 = null; var v_sc_1504 = null; var v_T_1505 = null; var v_p_1506 = null; var v_C_1507 = null; var v_r_1508 = null; var v_i_1509 = null; var v_an_1510 = null; var v_rr_1511 = null
	v_ctx_1495 = J.arg(a, 0)
	v_a_1496 = J.arg(a, 1)
	v_N_1497 = J.G.get("N30K")
	v_S_1498 = J.mc(v_N_1497, "setup", [v_a_1496])
	if (not J.t(v_S_1498)):
		return false
	v_t_1499 = J.gp(v_S_1498, "tt")
	v_H_1500 = J.gp(v_S_1498, "H")
	v_th_1501 = J.gp(v_S_1498, "th")
	v_D2_1502 = J.max_([0.0, (J.sub(J.gp(v_S_1498, "tx"), J.mul(0.4, v_th_1501)) - J.mul(0.3, v_H_1500))])
	v_f_1503 = J.mc(v_N_1497, "kf", [v_t_1499, [[0.0, {}], [0.18, {"sy": 0.82, "sx": 1.04, "head": 0.12, "armF": 0.3, "armB": (-0.3), "hairL": 0.2, "hairR": 0.2}], [0.235, {"sy": 1.22, "sx": 1.12, "y": J.mul((-0.06), v_H_1500), "x": v_D2_1502, "armF": (-0.7), "armB": 0.7, "head": (-0.1), "hairL": (-0.45), "hairR": (-0.45), "r": 6.0}, "back"], [0.38, {"sy": 1.15, "sx": 1.1, "y": J.mul((-0.03), v_H_1500), "x": v_D2_1502, "armF": (-0.6), "armB": 0.6, "r": 5.0}], [0.59, {}]]])
	J.mc(J.G.get("N30M"), "begin", [v_ctx_1495, v_S_1498, J.gp(v_f_1503, "x")])
	v_sc_1504 = J.mul(J.mc(v_N_1497, "seg", [v_t_1499, 0.2, 0.235]), J.sub(1.0, J.mc(v_N_1497, "seg", [v_t_1499, 0.38, 0.5])))
	if J.cmp(v_sc_1504, 0.0, ">"):
		var _t604 = J.gp(v_f_1503, "x")
		v_C_1507 = [(_t604 if J.t(_t604) else 0.0), J.mul((-0.6), v_H_1500)]
		v_r_1508 = (J.mul(0.65, v_H_1500) * (0.6 + J.mul(0.4, v_sc_1504)))
		J.mc(v_ctx_1495, "save", [])
		var _t605 = J.mul(J.gp(v_ctx_1495, "globalAlpha"), J.mul(v_sc_1504, 0.9))
		J.sp(v_ctx_1495, "globalAlpha", _t605)
		J.sp(v_ctx_1495, "fillStyle", "#ffe14a")
		J.sp(v_ctx_1495, "strokeStyle", "#5a3a10")
		var _t606 = J.mul(0.012, v_H_1500)
		J.sp(v_ctx_1495, "lineWidth", _t606)
		J.mc(v_ctx_1495, "beginPath", [])
		v_i_1509 = 0.0
		while true:
			if not J.cmp(v_i_1509, 24.0, "<"): break
			v_an_1510 = (J.div(v_i_1509, 24.0) * 6.283)
			v_rr_1511 = (J.mul(v_r_1508, 0.72) if J.t(J.mod(v_i_1509, 2.0)) else v_r_1508)
			J.mc(v_ctx_1495, "lineTo", [J.add(J.gp(v_C_1507, 0.0), J.mul(cos(J.num(v_an_1510)), v_rr_1511)), J.add(J.gp(v_C_1507, 1.0), (J.mul(sin(J.num(v_an_1510)), v_rr_1511) * 0.85))])
			v_i_1509 = J.num(v_i_1509) + 1.0
		J.mc(v_ctx_1495, "closePath", [])
		J.mc(v_ctx_1495, "fill", [])
		J.mc(v_ctx_1495, "stroke", [])
		J.mc(v_ctx_1495, "restore", [])
	J.mc(v_N_1497, "whole", [v_ctx_1495, v_S_1498, v_f_1503, null, 0.3])
	v_T_1505 = J.mc(v_N_1497, "tgt", [v_S_1498, 0.7])
	v_p_1506 = J.sub(v_t_1499, J.gp(v_N_1497, "TC"))
	var _t607 = J.gp(v_f_1503, "x")
	J.mc(v_N_1497, "pop", [v_ctx_1495, v_S_1498, (_t607 if J.t(_t607) else 0.0), J.mul((-1.35), v_H_1500), "哇！！", J.mul(0.2, v_H_1500), "#ff5050", 0.21, 0.3])
	var _t608 = J.cmp(v_p_1506, 0.0, ">=")
	if (J.cmp(v_p_1506, 0.3, "<") if _t608 else _t608):
		J.mc(v_N_1497, "txt", [v_ctx_1495, v_S_1498, J.add(J.gp(v_T_1505, 0.0), J.mul(0.15, v_th_1501)), (J.sub(J.gp(v_T_1505, 1.0), J.mul(0.45, v_th_1501)) - J.mul(J.mul(v_p_1506, 0.3), v_th_1501)), J.mul(0.3, v_th_1501), "！", "#ffffff", (1.0 - J.div(v_p_1506, 0.3))])
		J.mc(v_N_1497, "drops", [v_ctx_1495, J.gp(v_T_1505, 0.0), J.sub(J.gp(v_T_1505, 1.0), J.mul(0.2, v_th_1501)), J.mul(0.3, v_th_1501), J.div(v_p_1506, 0.3), "rgba(150,210,255,.9)", 850.0, 5.0])
	var _t609 = J.cmp(v_p_1506, 0.0, ">=")
	if (J.cmp(v_p_1506, 0.12, "<") if _t609 else _t609):
		J.mc(v_N_1497, "burst", [v_ctx_1495, J.gp(v_T_1505, 0.0), J.gp(v_T_1505, 1.0), J.mul(0.3, v_th_1501), (1.0 - J.div(v_p_1506, 0.12)), "#ffffff", 851.0, 9.0])
	J.mc(v_N_1497, "hit", [v_S_1498, J.gp(v_T_1505, 0.0), J.gp(v_T_1505, 1.0)])
	J.mc(J.G.get("N30M"), "end", [v_ctx_1495])

func _f98(this_, a: Array, env):
	var v_ctx_1514 = null; var v_a_1515 = null; var v_N_1516 = null; var v_S_1517 = null; var v_t_1518 = null; var v_H_1519 = null; var v_th_1520 = null; var v_f_1521 = null; var v_T_1522 = null; var v_cl_1523 = null; var v_ca_1524 = null; var v_p_1525 = null; var v_m_1526 = null; var v_um_1527 = null; var v_al_1528 = null; var v_g_1529 = null; var v_i_1530 = null
	v_ctx_1514 = J.arg(a, 0)
	v_a_1515 = J.arg(a, 1)
	v_N_1516 = J.G.get("N30K")
	v_S_1517 = J.mc(v_N_1516, "setup", [v_a_1515])
	if (not J.t(v_S_1517)):
		return false
	v_t_1518 = J.gp(v_S_1517, "tt")
	v_H_1519 = J.gp(v_S_1517, "H")
	v_th_1520 = J.gp(v_S_1517, "th")
	v_f_1521 = J.mc(v_N_1516, "kf", [v_t_1518, [[0.0, {}], [0.17, {"armB": (-0.6), "umb": (-0.2), "head": (-0.2), "r": (-4.0), "y": J.mul((-0.03), v_H_1519)}], [J.gp(v_N_1516, "TC"), {"armB": (-0.5), "umb": (-0.1), "head": (-0.1)}], [0.44, {"armB": (-0.5)}], [0.48, {"armB": 0.1, "sy": 0.92, "head": 0.2}, "o"], [0.59, {}]]])
	J.mc(J.G.get("N30M"), "begin", [v_ctx_1514, v_S_1517, J.gp(v_f_1521, "x")])
	v_T_1522 = J.mc(v_N_1516, "tgt", [v_S_1517, 0.5])
	v_cl_1523 = [J.add(J.gp(v_S_1517, "tx"), J.gp(v_S_1517, "back")), J.sub(J.gp(v_S_1517, "ty"), J.mul(1.45, v_th_1520))]
	v_ca_1524 = J.mul(J.mc(v_N_1516, "seg", [v_t_1518, 0.05, 0.2]), J.sub(1.0, J.mc(v_N_1516, "seg", [v_t_1518, 0.45, 0.59])))
	J.mc(J.G.get("N30M"), "cloud", [v_ctx_1514, J.gp(v_cl_1523, 0.0), J.gp(v_cl_1523, 1.0), (J.mul(0.3, v_th_1520) * (0.6 + J.mul(0.4, v_ca_1524))), v_ca_1524])
	J.mc(v_N_1516, "whole", [v_ctx_1514, v_S_1517, v_f_1521, null, 0.3])
	v_p_1525 = J.sub(v_t_1518, J.gp(v_N_1516, "TC"))
	var _t612 = J.cmp(v_p_1525, (-0.02), ">=")
	if (J.cmp(v_p_1525, 0.16, "<") if _t612 else _t612):
		v_al_1528 = J.sub(1.0, J.mc(v_N_1516, "seg", [v_p_1525, 0.06, 0.16]))
		J.mc(J.G.get("N30M"), "bolt", [v_ctx_1514, [J.gp(v_cl_1523, 0.0), J.add(J.gp(v_cl_1523, 1.0), J.mul(0.15, v_th_1520))], [J.gp(v_T_1522, 0.0), J.sub(J.gp(v_S_1517, "ty"), J.mul(0.4, v_th_1520))], J.mul(0.04, v_th_1520), (860.0 + floor(J.num(J.mul(v_t_1518, 40.0)))), "#ffe14a", v_al_1528])
		J.mc(v_ctx_1514, "save", [])
		var _t613 = J.mul(J.gp(v_ctx_1514, "globalAlpha"), J.mul(v_al_1528, 0.5))
		J.sp(v_ctx_1514, "globalAlpha", _t613)
		v_g_1529 = J.mc(v_ctx_1514, "createRadialGradient", [J.gp(v_T_1522, 0.0), J.gp(v_T_1522, 1.0), 0.0, J.gp(v_T_1522, 0.0), J.gp(v_T_1522, 1.0), J.mul(1.2, v_th_1520)])
		J.mc(v_g_1529, "addColorStop", [0.0, "rgba(255,251,220,.9)"])
		J.mc(v_g_1529, "addColorStop", [1.0, "rgba(255,251,220,0)"])
		J.sp(v_ctx_1514, "fillStyle", v_g_1529)
		J.mc(v_ctx_1514, "fillRect", [J.sub(J.gp(v_T_1522, 0.0), J.mul(1.2, v_th_1520)), J.sub(J.gp(v_T_1522, 1.0), J.mul(1.2, v_th_1520)), J.mul(2.4, v_th_1520), J.mul(2.4, v_th_1520)])
		J.mc(v_ctx_1514, "restore", [])
	v_i_1530 = 0.0
	while true:
		if not J.cmp(v_i_1530, 3.0, "<"): break
		J.mc(v_N_1516, "puff", [v_ctx_1514, J.add(J.gp(v_T_1522, 0.0), J.mul((J.sub(v_i_1530, 1.0) * 0.12), v_th_1520)), J.sub(J.gp(v_T_1522, 1.0), J.mul(0.4, v_th_1520)), J.mul(0.1, v_th_1520), J.mc(v_N_1516, "seg", [v_t_1518, J.add(J.gp(v_N_1516, "TC"), J.mul(v_i_1530, 0.03)), 0.59]), "rgba(80,70,70,.55)", J.add(865.0, v_i_1530), 3.0])
		v_i_1530 = J.num(v_i_1530) + 1.0
	v_m_1526 = J.mc(v_N_1516, "bm", [v_S_1517, v_f_1521])
	v_um_1527 = J.mc(v_N_1516, "at", [v_S_1517, v_m_1526, 0.75, 0.2])
	var _t614 = J.cmp(v_t_1518, 0.43, ">")
	if (J.cmp(v_t_1518, 0.5, "<") if _t614 else _t614):
		J.mc(J.G.get("N30M"), "bolt", [v_ctx_1514, [J.gp(v_um_1527, 0.0), J.sub(J.gp(v_um_1527, 1.0), J.mul(0.6, v_H_1519))], v_um_1527, J.mul(0.02, v_H_1519), 870.0, "#ffe14a", J.sub(1.0, J.mc(v_N_1516, "seg", [v_t_1518, 0.47, 0.5]))])
	J.mc(v_N_1516, "puff", [v_ctx_1514, J.gp(J.mc(v_N_1516, "at", [v_S_1517, v_m_1526, 0.35, 0.05]), 0.0), J.gp(J.mc(v_N_1516, "at", [v_S_1517, v_m_1526, 0.35, 0.05]), 1.0), J.mul(0.07, v_H_1519), J.mc(v_N_1516, "seg", [v_t_1518, 0.46, 0.59]), "rgba(80,70,70,.6)", 872.0, 4.0])
	J.mc(v_N_1516, "pop", [v_ctx_1514, v_S_1517, J.gp(v_T_1522, 0.0), J.sub(J.gp(v_T_1522, 1.0), J.mul(0.6, v_th_1520)), "轟隆！", J.mul(0.24, v_th_1520), "#ffe14a", J.gp(v_N_1516, "TC"), 0.28])
	J.mc(v_N_1516, "pop", [v_ctx_1514, v_S_1517, J.mul((-0.1), v_H_1519), J.mul((-1.1), v_H_1519), "又嚟！", J.mul(0.12, v_H_1519), "#ffd0a0", 0.46, 0.13])
	J.mc(v_N_1516, "hit", [v_S_1517, J.gp(v_T_1522, 0.0), J.gp(v_T_1522, 1.0)])
	J.mc(J.G.get("N30M"), "end", [v_ctx_1514])

func _f99(this_, a: Array, env):
	var v_ctx_1533 = null; var v_a_1534 = null; var v_N_1535 = null; var v_S_1536 = null; var v_t_1537 = null; var v_H_1538 = null; var v_th_1539 = null; var v_D2_1540 = null; var v_f_1541 = null; var v_m0_1542 = null; var v_ph_1543 = null; var v_T_1544 = null; var v_fl_1545 = null; var v_p_1546 = null; var v_g_1547 = null
	v_ctx_1533 = J.arg(a, 0)
	v_a_1534 = J.arg(a, 1)
	v_N_1535 = J.G.get("N30K")
	v_S_1536 = J.mc(v_N_1535, "setup", [v_a_1534])
	if (not J.t(v_S_1536)):
		return false
	v_t_1537 = J.gp(v_S_1536, "tt")
	v_H_1538 = J.gp(v_S_1536, "H")
	v_th_1539 = J.gp(v_S_1536, "th")
	v_D2_1540 = J.max_([0.0, (J.sub(J.gp(v_S_1536, "tx"), J.mul(0.25, v_th_1539)) - J.mul(0.25, v_H_1538))])
	v_f_1541 = J.mc(v_N_1535, "kf", [v_t_1537, [[0.0, {}], [0.14, {"armB": (-0.25), "stick": (-0.1), "head": (-0.08), "r": (-3.0)}], [0.19, {"armB": (-0.25), "r": (-3.0)}], [J.gp(v_N_1535, "TC"), {"r": (-55.0), "px": 0.0, "py": 0.0, "x": v_D2_1540, "y": J.mul((-0.05), v_H_1538), "armB": 0.3, "armF": (-0.6), "stick": 0.3}, "i"], [0.36, {"r": (-60.0), "px": 0.0, "py": 0.0, "x": v_D2_1540, "y": J.mul((-0.03), v_H_1538), "armB": 0.3, "armF": (-0.6)}], [0.48, {"r": (-15.0), "px": 0.0, "py": 0.0, "x": J.mul(v_D2_1540, 0.4)}], [0.59, {}]]])
	J.sp(v_f_1541, "px", 0.0)
	J.sp(v_f_1541, "py", 0.0)
	J.mc(J.G.get("N30M"), "begin", [v_ctx_1533, v_S_1536, J.gp(v_f_1541, "x")])
	J.mc(v_N_1535, "whole", [v_ctx_1533, v_S_1536, v_f_1541, null, 0.3])
	v_m0_1542 = J.mc(v_N_1535, "bm", [v_S_1536, J.mc(v_N_1535, "kf", [J.min_([v_t_1537, 0.19]), [[0.0, {}], [0.14, {"armB": (-0.25), "r": (-3.0)}]]])])
	v_ph_1543 = J.mc(v_N_1535, "at", [v_S_1536, v_m0_1542, 0.8, 0.14])
	v_T_1544 = J.mc(v_N_1535, "tgt", [v_S_1536, 0.5])
	J.mc(v_N_1535, "pop", [v_ctx_1533, v_S_1536, J.mul((-0.05), v_H_1538), J.mul((-1.1), v_H_1538), "茄子～", J.mul(0.12, v_H_1538), "#ffe0f0", 0.02, 0.17])
	v_fl_1545 = J.mul(J.mc(v_N_1535, "seg", [v_t_1537, 0.18, 0.2]), J.sub(1.0, J.mc(v_N_1535, "seg", [v_t_1537, 0.2, 0.3])))
	if J.cmp(v_fl_1545, 0.0, ">"):
		v_g_1547 = J.mc(v_ctx_1533, "createRadialGradient", [J.gp(v_ph_1543, 0.0), J.gp(v_ph_1543, 1.0), 0.0, J.gp(v_ph_1543, 0.0), J.gp(v_ph_1543, 1.0), J.mul(0.9, v_H_1538)])
		J.mc(v_g_1547, "addColorStop", [0.0, ("rgba(255,255,255," + J.str(J.mul(0.95, v_fl_1545)) + ")")])
		J.mc(v_g_1547, "addColorStop", [1.0, "rgba(255,255,255,0)"])
		J.sp(v_ctx_1533, "fillStyle", v_g_1547)
		J.mc(v_ctx_1533, "fillRect", [J.sub(J.gp(v_ph_1543, 0.0), v_H_1538), J.sub(J.gp(v_ph_1543, 1.0), v_H_1538), J.mul(2.0, v_H_1538), J.mul(2.0, v_H_1538)])
		J.mc(v_N_1535, "burst", [v_ctx_1533, J.gp(v_ph_1543, 0.0), J.gp(v_ph_1543, 1.0), J.mul(0.2, v_H_1538), v_fl_1545, "#ffffff", 880.0, 10.0])
	J.mc(v_N_1535, "pop", [v_ctx_1533, v_S_1536, J.gp(v_ph_1543, 0.0), J.sub(J.gp(v_ph_1543, 1.0), J.mul(0.12, v_H_1538)), "咔嚓", J.mul(0.1, v_H_1538), "#ffffff", 0.18, 0.12])
	var _t617 = J.cmp(v_t_1537, 0.2, ">")
	if (J.cmp(v_t_1537, J.gp(v_N_1535, "TC"), "<") if _t617 else _t617):
		var _t618 = J.gp(v_f_1541, "x")
		J.mc(v_N_1535, "speed", [v_ctx_1533, (_t618 if J.t(_t618) else 0.0), J.mul((-0.1), v_H_1538), 1.0, 0.0, J.mul(0.3, v_H_1538), J.mul(0.12, v_H_1538), 0.8, "rgba(255,240,180,.7)", 882.0, 3.0])
	v_p_1546 = J.sub(v_t_1537, J.gp(v_N_1535, "TC"))
	var _t619 = J.cmp(v_p_1546, 0.0, ">=")
	if (J.cmp(v_p_1546, 0.13, "<") if _t619 else _t619):
		J.mc(v_N_1535, "burst", [v_ctx_1533, J.gp(v_T_1544, 0.0), J.gp(v_T_1544, 1.0), J.mul(0.3, v_th_1539), (1.0 - J.div(v_p_1546, 0.13)), "#fff8d0", 885.0, 9.0])
	J.mc(v_N_1535, "pop", [v_ctx_1533, v_S_1536, J.gp(v_T_1544, 0.0), J.sub(J.gp(v_T_1544, 1.0), J.mul(0.5, v_th_1539)), "哎吔！", J.mul(0.2, v_th_1539), "#ffe066", J.gp(v_N_1535, "TC"), 0.28])
	J.mc(v_N_1535, "hit", [v_S_1536, J.gp(v_T_1544, 0.0), J.gp(v_T_1544, 1.0)])
	J.mc(J.G.get("N30M"), "end", [v_ctx_1533])

func _f100(this_, a: Array, env):
	var v_ctx_1550 = null; var v_a_1551 = null; var v_N_1552 = null; var v_S_1553 = null; var v_t_1554 = null; var v_H_1555 = null; var v_th_1556 = null; var v_f_1557 = null; var v_T_1558 = null; var v_sun_1559 = null; var v_k_1560 = null; var v_p_1561 = null; var v_b_1562 = null; var v_i_1563 = null; var v_an_1564 = null; var v_g_1565 = null
	v_ctx_1550 = J.arg(a, 0)
	v_a_1551 = J.arg(a, 1)
	v_N_1552 = J.G.get("N30K")
	v_S_1553 = J.mc(v_N_1552, "setup", [v_a_1551])
	if (not J.t(v_S_1553)):
		return false
	v_t_1554 = J.gp(v_S_1553, "tt")
	v_H_1555 = J.gp(v_S_1553, "H")
	v_th_1556 = J.gp(v_S_1553, "th")
	v_f_1557 = J.mc(v_N_1552, "kf", [v_t_1554, [[0.0, {}], [0.16, {"armF": (-0.7), "head": 0.1}], [J.gp(v_N_1552, "TC"), {"armF": (-0.2), "head": (-0.15), "r": (-3.0)}], [0.36, {"sy": 0.72, "sx": 1.22, "head": 0.2, "armF": 0.3, "armB": (-0.3)}, "o"], [0.46, {"sy": 0.75, "sx": 1.2}], [0.59, {}, "back"]]])
	var _t623 = J.gp(v_f_1557, "x")
	var _t622 = J.gp(v_f_1557, "sy")
	J.mc(J.G.get("N30M"), "begin", [v_ctx_1550, v_S_1553, _t623, (1.0 + (J.sub(1.0, (_t622 if J.t(_t622) else 1.0)) * 1.5))])
	J.mc(v_N_1552, "whole", [v_ctx_1550, v_S_1553, v_f_1557, null, 0.3])
	v_T_1558 = J.mc(v_N_1552, "tgt", [v_S_1553, 0.6])
	v_sun_1559 = [J.gp(v_T_1558, 0.0), J.sub(J.gp(v_S_1553, "ty"), J.mul(1.6, v_th_1556))]
	v_k_1560 = J.mul(J.mc(v_N_1552, "seg", [v_t_1554, 0.12, J.gp(v_N_1552, "TC")]), J.sub(1.0, J.mc(v_N_1552, "seg", [v_t_1554, 0.42, 0.59])))
	if J.cmp(v_k_1560, 0.0, ">"):
		J.mc(v_ctx_1550, "save", [])
		var _t624 = J.mul(J.gp(v_ctx_1550, "globalAlpha"), v_k_1560)
		J.sp(v_ctx_1550, "globalAlpha", _t624)
		J.sp(v_ctx_1550, "fillStyle", "#ffb030")
		J.sp(v_ctx_1550, "strokeStyle", "#a05a10")
		var _t625 = J.mul(0.015, v_th_1556)
		J.sp(v_ctx_1550, "lineWidth", _t625)
		J.mc(v_ctx_1550, "beginPath", [])
		J.mc(v_ctx_1550, "arc", [J.gp(v_sun_1559, 0.0), J.gp(v_sun_1559, 1.0), J.mul(0.14, v_th_1556), 0.0, 7.0])
		J.mc(v_ctx_1550, "fill", [])
		J.mc(v_ctx_1550, "stroke", [])
		v_i_1563 = 0.0
		while true:
			if not J.cmp(v_i_1563, 10.0, "<"): break
			v_an_1564 = ((J.div(v_i_1563, 10.0) * 6.28) + J.mul(v_t_1554, 2.0))
			J.mc(v_N_1552, "crayon", [v_ctx_1550, [[J.add(J.gp(v_sun_1559, 0.0), J.mul((cos(J.num(v_an_1564)) * 0.19), v_th_1556)), J.add(J.gp(v_sun_1559, 1.0), J.mul((sin(J.num(v_an_1564)) * 0.19), v_th_1556))], [J.add(J.gp(v_sun_1559, 0.0), J.mul((cos(J.num(v_an_1564)) * 0.28), v_th_1556)), J.add(J.gp(v_sun_1559, 1.0), J.mul((sin(J.num(v_an_1564)) * 0.28), v_th_1556))]], "#ffb030", J.mul(0.025, v_th_1556), J.add(890.0, v_i_1563)])
			v_i_1563 = J.num(v_i_1563) + 1.0
		J.mc(v_ctx_1550, "restore", [])
		v_b_1562 = J.mul(J.mc(v_N_1552, "seg", [v_t_1554, 0.2, J.gp(v_N_1552, "TC")]), J.sub(1.0, J.mc(v_N_1552, "seg", [v_t_1554, 0.4, 0.5])))
		if J.cmp(v_b_1562, 0.0, ">"):
			J.mc(v_ctx_1550, "save", [])
			var _t626 = J.mul(J.gp(v_ctx_1550, "globalAlpha"), J.mul(v_b_1562, 0.5))
			J.sp(v_ctx_1550, "globalAlpha", _t626)
			v_g_1565 = J.mc(v_ctx_1550, "createLinearGradient", [0.0, J.gp(v_sun_1559, 1.0), 0.0, J.gp(v_S_1553, "ty")])
			J.mc(v_g_1565, "addColorStop", [0.0, "rgba(255,220,100,.9)"])
			J.mc(v_g_1565, "addColorStop", [1.0, "rgba(255,170,60,.2)"])
			J.sp(v_ctx_1550, "fillStyle", v_g_1565)
			J.mc(v_ctx_1550, "beginPath", [])
			J.mc(v_ctx_1550, "moveTo", [J.sub(J.gp(v_sun_1559, 0.0), J.mul(0.1, v_th_1556)), J.gp(v_sun_1559, 1.0)])
			J.mc(v_ctx_1550, "lineTo", [J.add(J.gp(v_sun_1559, 0.0), J.mul(0.1, v_th_1556)), J.gp(v_sun_1559, 1.0)])
			J.mc(v_ctx_1550, "lineTo", [J.add(J.gp(v_T_1558, 0.0), J.mul(0.32, v_th_1556)), J.gp(v_S_1553, "ty")])
			J.mc(v_ctx_1550, "lineTo", [J.sub(J.gp(v_T_1558, 0.0), J.mul(0.32, v_th_1556)), J.gp(v_S_1553, "ty")])
			J.mc(v_ctx_1550, "closePath", [])
			J.mc(v_ctx_1550, "fill", [])
			J.mc(v_ctx_1550, "restore", [])
	v_p_1561 = J.sub(v_t_1554, J.gp(v_N_1552, "TC"))
	if J.cmp(v_p_1561, 0.0, ">="):
		J.mc(v_N_1552, "drops", [v_ctx_1550, J.gp(v_T_1558, 0.0), J.sub(J.gp(v_T_1558, 1.0), J.mul(0.3, v_th_1556)), J.mul(0.4, v_th_1556), J.mc(v_N_1552, "seg", [v_p_1561, 0.0, 0.3]), "rgba(150,210,255,.9)", 900.0, 6.0])
		J.mc(v_N_1552, "puff", [v_ctx_1550, J.gp(v_T_1558, 0.0), J.sub(J.gp(v_T_1558, 1.0), J.mul(0.5, v_th_1556)), J.mul(0.1, v_th_1556), J.mc(v_N_1552, "seg", [v_p_1561, 0.0, 0.3]), "rgba(255,255,255,.5)", 901.0, 3.0])
	var _t627 = J.cmp(v_t_1554, 0.3, ">")
	if (J.cmp(v_t_1554, 0.55, "<") if _t627 else _t627):
		J.mc(v_ctx_1550, "save", [])
		var _t628 = J.mul(J.gp(v_ctx_1550, "globalAlpha"), (0.6 * sin(J.num(J.mul(J.mc(v_N_1552, "seg", [v_t_1554, 0.3, 0.55]), PI)))))
		J.sp(v_ctx_1550, "globalAlpha", _t628)
		J.sp(v_ctx_1550, "fillStyle", "rgba(230,120,100,.5)")
		J.mc(v_ctx_1550, "beginPath", [])
		var _t629 = J.gp(v_f_1557, "x")
		J.mc(v_ctx_1550, "ellipse", [(_t629 if J.t(_t629) else 0.0), 0.0, J.mul(0.35, v_H_1555), J.mul(0.04, v_H_1555), 0.0, 0.0, 7.0])
		J.mc(v_ctx_1550, "fill", [])
		J.mc(v_ctx_1550, "restore", [])
	var _t630 = J.cmp(v_p_1561, 0.0, ">=")
	if (J.cmp(v_p_1561, 0.12, "<") if _t630 else _t630):
		J.mc(v_N_1552, "burst", [v_ctx_1550, J.gp(v_T_1558, 0.0), J.gp(v_T_1558, 1.0), J.mul(0.3, v_th_1556), (1.0 - J.div(v_p_1561, 0.12)), "#ffd080", 905.0, 9.0])
	J.mc(v_N_1552, "pop", [v_ctx_1550, v_S_1553, J.gp(v_T_1558, 0.0), J.sub(J.gp(v_T_1558, 1.0), J.mul(0.5, v_th_1556)), "曬！", J.mul(0.24, v_th_1556), "#ffb030", J.gp(v_N_1552, "TC"), 0.3])
	J.mc(v_N_1552, "hit", [v_S_1553, J.gp(v_T_1558, 0.0), J.gp(v_T_1558, 1.0)])
	J.mc(J.G.get("N30M"), "end", [v_ctx_1550])

func _f101(this_, a: Array, env):
	var v_ctx_1568 = null; var v_a_1569 = null; var v_N_1570 = null; var v_S_1571 = null; var v_t_1572 = null; var v_H_1573 = null; var v_th_1574 = null; var v_D2_1575 = null; var v_f_1576 = null; var v_T_1577 = null; var v_p_1578 = null; var v_m_1579 = null; var v_pl_1580 = null; var v_i_1581 = null; var v_an_1582 = null; var v_sp_1583 = null; var v_x_1584 = null; var v_y_1585 = null
	v_ctx_1568 = J.arg(a, 0)
	v_a_1569 = J.arg(a, 1)
	v_N_1570 = J.G.get("N30K")
	v_S_1571 = J.mc(v_N_1570, "setup", [v_a_1569])
	if (not J.t(v_S_1571)):
		return false
	v_t_1572 = J.gp(v_S_1571, "tt")
	v_H_1573 = J.gp(v_S_1571, "H")
	v_th_1574 = J.gp(v_S_1571, "th")
	v_D2_1575 = J.max_([0.0, (J.sub(J.gp(v_S_1571, "tx"), J.mul(0.3, v_th_1574)) - J.mul(0.45, J.gp(v_S_1571, "W")))])
	v_f_1576 = J.mc(v_N_1570, "kf", [v_t_1572, [[0.0, {}], [0.16, {"r": (-12.0), "sx": 1.1, "sy": 1.02, "x": J.mul((-0.03), v_H_1573), "head": (-0.15), "armF": 0.3, "armB": (-0.2)}], [J.gp(v_N_1570, "TC"), {"r": (-6.0), "sx": 1.16, "sy": 0.94, "x": v_D2_1575, "head": (-0.05)}, "i"], [0.32, {"r": (-4.0), "sx": 0.96, "sy": 1.04, "x": J.sub(v_D2_1575, J.mul(0.02, v_H_1573))}], [0.4, {"sx": 1.04, "sy": 0.98, "x": J.mul(v_D2_1575, 0.6)}], [0.59, {}]]])
	J.sp(v_f_1576, "px", 0.0)
	J.sp(v_f_1576, "py", 0.0)
	J.mc(J.G.get("N30M"), "begin", [v_ctx_1568, v_S_1571, J.gp(v_f_1576, "x")])
	J.mc(v_N_1570, "whole", [v_ctx_1568, v_S_1571, v_f_1576, null, 0.3])
	v_T_1577 = J.mc(v_N_1570, "tgt", [v_S_1571, 0.5])
	v_p_1578 = J.sub(v_t_1572, J.gp(v_N_1570, "TC"))
	v_m_1579 = J.mc(v_N_1570, "bm", [v_S_1571, v_f_1576])
	v_pl_1580 = J.mc(v_N_1570, "at", [v_S_1571, v_m_1579, 0.82, 0.22])
	var _t633 = J.cmp(v_p_1578, 0.0, ">=")
	if (J.cmp(v_p_1578, 0.35, "<") if _t633 else _t633):
		v_i_1581 = 0.0
		while true:
			if not J.cmp(v_i_1581, 7.0, "<"): break
			v_an_1582 = ((-PI) * (0.2 + J.mul(0.6, J.mc(v_N_1570, "rnd", [J.add(v_i_1581, 910.0)]))))
			v_sp_1583 = J.mul(J.mul(J.add(0.3, J.mc(v_N_1570, "rnd", [J.add(v_i_1581, 920.0)])), 1.0), v_H_1573)
			v_x_1584 = J.add(J.gp(v_pl_1580, 0.0), J.mul(J.mul(cos(J.num(v_an_1582)), v_sp_1583), v_p_1578))
			v_y_1585 = J.add(J.add(J.gp(v_pl_1580, 1.0), J.mul(J.mul(sin(J.num(v_an_1582)), v_sp_1583), v_p_1578)), J.mul(J.mul(J.mul(2.5, v_H_1573), v_p_1578), v_p_1578))
			J.mc(v_ctx_1568, "save", [])
			var _t634 = J.mul(J.gp(v_ctx_1568, "globalAlpha"), (1.0 - J.div(v_p_1578, 0.35)))
			J.sp(v_ctx_1568, "globalAlpha", _t634)
			var _t635 = J.gp(["#e8a050", "#7ac060", "#f0d080", "#d05040"], J.mod(v_i_1581, 4.0))
			J.sp(v_ctx_1568, "fillStyle", _t635)
			J.mc(v_ctx_1568, "beginPath", [])
			J.mc(v_ctx_1568, "ellipse", [v_x_1584, v_y_1585, J.mul(0.02, v_H_1573), J.mul(0.014, v_H_1573), v_i_1581, 0.0, 7.0])
			J.mc(v_ctx_1568, "fill", [])
			J.mc(v_ctx_1568, "restore", [])
			v_i_1581 = J.num(v_i_1581) + 1.0
	var _t636 = J.cmp(v_p_1578, 0.0, ">=")
	if (J.cmp(v_p_1578, 0.14, "<") if _t636 else _t636):
		J.mc(v_N_1570, "burst", [v_ctx_1568, J.sub(J.gp(v_T_1577, 0.0), J.mul(0.15, v_th_1574)), J.gp(v_T_1577, 1.0), J.mul(0.4, v_th_1574), (1.0 - J.div(v_p_1578, 0.14)), "#fff0d0", 925.0, 11.0])
	J.mc(v_N_1570, "pop", [v_ctx_1568, v_S_1571, J.gp(v_T_1577, 0.0), J.sub(J.gp(v_T_1577, 1.0), J.mul(0.55, v_th_1574)), "嘭！", J.mul(0.28, v_th_1574), "#ffd27a", J.gp(v_N_1570, "TC"), 0.28])
	J.mc(v_N_1570, "pop", [v_ctx_1568, v_S_1571, J.mul((-0.1), v_H_1573), J.mul((-1.05), v_H_1573), "嗝～", J.mul(0.12, v_H_1573), "#ffe0b0", 0.44, 0.15])
	J.mc(v_N_1570, "hit", [v_S_1571, J.gp(v_T_1577, 0.0), J.gp(v_T_1577, 1.0)])
	J.mc(J.G.get("N30M"), "end", [v_ctx_1568])

func _f102(this_, a: Array, env):
	var v_ctx_1588 = null; var v_a_1589 = null; var v_N_1590 = null; var v_S_1591 = null; var v_key_1592 = null; var v_t_1593 = null; var v_H_1594 = null; var v_th_1595 = null; var v_PV_1596 = null; var v_f_1597 = null; var v_m_1598 = null; var v_home_1599 = null; var v_T_1600 = null; var v_x_1601 = null; var v_y_1602 = null; var v_r_1603 = null; var v_sx_1604 = null; var v_p_1605 = null; var v_k_1606 = null; var v_q_1607 = null; var v_q_1608 = null
	v_ctx_1588 = J.arg(a, 0)
	v_a_1589 = J.arg(a, 1)
	v_N_1590 = J.G.get("N30K")
	v_S_1591 = J.mc(v_N_1590, "setup", [v_a_1589])
	if (not J.t(v_S_1591)):
		return false
	v_key_1592 = J.mc(J.G.get("N30"), "body", [J.gp(v_S_1591, "id")])
	if (not J.t(v_key_1592)):
		return false
	v_t_1593 = J.gp(v_S_1591, "tt")
	v_H_1594 = J.gp(v_S_1591, "H")
	v_th_1595 = J.gp(v_S_1591, "th")
	v_PV_1596 = [0.7, 0.575]
	v_f_1597 = J.mc(v_N_1590, "kf", [v_t_1593, [[0.0, {}], [0.1, {"y": J.mul((-0.06), v_H_1594), "r": (-4.0)}], [0.18, {"y": 0.0, "sy": 0.95}], [0.44, {"r": 3.0}], [0.5, {"y": J.mul((-0.08), v_H_1594), "r": (-6.0), "armF": (-0.3)}, "o"], [0.59, {}]]])
	v_m_1598 = J.mc(v_N_1590, "bm", [v_S_1591, v_f_1597])
	v_home_1599 = J.mc(v_N_1590, "at", [v_S_1591, v_m_1598, J.gp(v_PV_1596, 0.0), J.gp(v_PV_1596, 1.0)])
	v_T_1600 = J.mc(v_N_1590, "tgt", [v_S_1591, 0.72])
	v_x_1601 = null
	v_y_1602 = null
	v_r_1603 = null
	v_sx_1604 = 1.0
	if J.cmp(v_t_1593, 0.15, "<"):
		var _t639 = J.gp(v_N_1590, "E")
		v_k_1606 = J.mc(_t639, "o", [J.mc(v_N_1590, "seg", [v_t_1593, 0.0, 0.15])])
		var _t640 = J.sub(J.gp(v_home_1599, 0.0), J.mul(J.mul(0.03, v_H_1594), v_k_1606))
		v_x_1601 = _t640
		var _t641 = J.add(J.gp(v_home_1599, 1.0), J.mul(J.mul(0.02, v_H_1594), v_k_1606))
		v_y_1602 = _t641
		var _t642 = J.mul(15.0, v_k_1606)
		v_r_1603 = _t642
		var _t643 = (1.0 - J.mul(0.1, v_k_1606))
		v_sx_1604 = _t643
	else:
		if J.cmp(v_t_1593, J.gp(v_N_1590, "TC"), "<"):
			v_q_1607 = J.mc(v_N_1590, "seg", [v_t_1593, 0.15, J.gp(v_N_1590, "TC")])
			var _t644 = J.mc(v_N_1590, "lerp", [J.gp(v_home_1599, 0.0), J.sub(J.gp(v_T_1600, 0.0), J.mul(0.05, v_th_1595)), v_q_1607])
			v_x_1601 = _t644
			var _t645 = J.sub(J.mc(v_N_1590, "lerp", [J.gp(v_home_1599, 1.0), J.gp(v_T_1600, 1.0), v_q_1607]), (J.mul((J.mul(0.55, v_H_1594) * 4.0), v_q_1607) * J.sub(1.0, v_q_1607)))
			v_y_1602 = _t645
			var _t646 = J.mc(v_N_1590, "lerp", [15.0, (-150.0), v_q_1607])
			v_r_1603 = _t646
		else:
			if J.cmp(v_t_1593, 0.38, "<"):
				var _t647 = (J.sub(J.gp(v_T_1600, 0.0), J.mul(0.05, v_th_1595)) + J.mul((sin(J.num(J.mul(v_t_1593, 90.0))) * 0.01), v_H_1594))
				v_x_1601 = _t647
				v_y_1602 = J.gp(v_T_1600, 1.0)
				v_r_1603 = (-150.0)
			else:
				var _t648 = J.gp(v_N_1590, "E")
				v_q_1608 = J.mc(_t648, "io", [J.mc(v_N_1590, "seg", [v_t_1593, 0.38, 0.52])])
				var _t649 = J.mc(v_N_1590, "lerp", [J.sub(J.gp(v_T_1600, 0.0), J.mul(0.05, v_th_1595)), J.gp(v_home_1599, 0.0), v_q_1608])
				v_x_1601 = _t649
				var _t650 = J.sub(J.mc(v_N_1590, "lerp", [J.gp(v_T_1600, 1.0), J.gp(v_home_1599, 1.0), v_q_1608]), (J.mul((J.mul(0.4, v_H_1594) * 4.0), v_q_1608) * J.sub(1.0, v_q_1608)))
				v_y_1602 = _t650
				var _t651 = J.mc(v_N_1590, "lerp", [(-150.0), 0.0, v_q_1608])
				v_r_1603 = _t651
				if J.cmp(v_t_1593, 0.52, ">"):
					v_x_1601 = J.gp(v_home_1599, 0.0)
					v_y_1602 = J.gp(v_home_1599, 1.0)
					v_r_1603 = 0.0
	J.mc(J.G.get("N30M"), "begin", [v_ctx_1588, v_S_1591, J.gp(v_f_1597, "x")])
	J.mc(v_N_1590, "body", [v_ctx_1588, v_S_1591, v_m_1598, J.mc(v_N_1590, "pose", [v_S_1591, v_f_1597, 0.3]), v_key_1592])
	J.mc(v_N_1590, "pieceAt", [v_ctx_1588, v_S_1591, "snake", v_x_1601, v_y_1602, v_r_1603, J.gp(v_PV_1596, 0.0), J.gp(v_PV_1596, 1.0), v_sx_1604, 1.0])
	v_p_1605 = J.sub(v_t_1593, J.gp(v_N_1590, "TC"))
	var _t652 = J.cmp(v_p_1605, 0.0, ">=")
	if (J.cmp(v_p_1605, 0.13, "<") if _t652 else _t652):
		J.mc(v_N_1590, "burst", [v_ctx_1588, J.gp(v_T_1600, 0.0), J.gp(v_T_1600, 1.0), J.mul(0.3, v_th_1595), (1.0 - J.div(v_p_1605, 0.13)), "#e8f0a0", 935.0, 9.0])
	J.mc(v_N_1590, "pop", [v_ctx_1588, v_S_1591, J.gp(v_T_1600, 0.0), J.sub(J.gp(v_T_1600, 1.0), J.mul(0.4, v_th_1595)), "嘶！", J.mul(0.24, v_th_1595), "#d8e870", J.gp(v_N_1590, "TC"), 0.28])
	J.mc(v_N_1590, "pop", [v_ctx_1588, v_S_1591, J.mul((-0.1), v_H_1594), J.mul((-1.1), v_H_1594), "哎喲！", J.mul(0.12, v_H_1594), "#ffe066", 0.5, 0.09])
	J.mc(v_N_1590, "hit", [v_S_1591, J.gp(v_T_1600, 0.0), J.gp(v_T_1600, 1.0)])
	J.mc(J.G.get("N30M"), "end", [v_ctx_1588])

func _f103(this_, a: Array, env):
	var v_ctx_1611 = null; var v_a_1612 = null; var v_N_1613 = null; var v_S_1614 = null; var v_t_1615 = null; var v_H_1616 = null; var v_th_1617 = null; var v_turn_1618 = null; var v_f_1619 = null; var v_T_1620 = null; var v_src_1621 = null; var v_i_1622 = null; var v_q_1623 = null; var v_x_1624 = null; var v_y_1625 = null; var v_al_1626 = null; var v_i_1627 = null; var v_q_1628 = null; var v_pts_1629 = null; var v_j_1630 = null
	v_ctx_1611 = J.arg(a, 0)
	v_a_1612 = J.arg(a, 1)
	v_N_1613 = J.G.get("N30K")
	v_S_1614 = J.mc(v_N_1613, "setup", [v_a_1612])
	if (not J.t(v_S_1614)):
		return false
	v_t_1615 = J.gp(v_S_1614, "tt")
	v_H_1616 = J.gp(v_S_1614, "H")
	v_th_1617 = J.gp(v_S_1614, "th")
	v_turn_1618 = (cos(J.num(J.mul(J.mc(v_N_1613, "seg", [v_t_1615, 0.05, 0.11]), PI))) if J.cmp(v_t_1615, 0.12, "<") else ((-cos(J.num(J.mul(J.mc(v_N_1613, "seg", [v_t_1615, 0.5, 0.56]), PI)))) if J.cmp(v_t_1615, 0.45, ">") else (-1.0)))
	v_f_1619 = J.mc(v_N_1613, "kf", [v_t_1615, [[0.0, {}], [0.12, {"body": 0.1, "head": 0.1}], [0.2, {"body": 0.25, "head": 0.15, "sy": 0.95, "r": (-6.0)}], [0.24, {"body": 0.2, "sy": 1.03, "r": (-3.0)}, "o"], [0.45, {"body": 0.1}], [0.59, {}]]])
	var _t655 = ((0.15 * signf(J.num((v_turn_1618 if J.t(v_turn_1618) else 1.0)))) if (absf(J.num(v_turn_1618)) < 0.15) else v_turn_1618)
	J.sp(v_f_1619, "sx", _t655)
	J.sp(v_f_1619, "px", 0.0)
	var _t656 = J.mul((-0.4), v_H_1616)
	J.sp(v_f_1619, "py", _t656)
	J.mc(J.G.get("N30M"), "begin", [v_ctx_1611, v_S_1614, J.gp(v_f_1619, "x")])
	J.mc(v_N_1613, "whole", [v_ctx_1611, v_S_1614, v_f_1619, null, 0.3])
	v_T_1620 = J.mc(v_N_1613, "tgt", [v_S_1614, 0.6])
	v_src_1621 = [J.mul(0.12, v_H_1616), J.mul((-0.45), v_H_1616)]
	v_i_1622 = 0.0
	while true:
		if not J.cmp(v_i_1622, 6.0, "<"): break
		v_q_1623 = J.mc(v_N_1613, "seg", [v_t_1615, (0.2 + J.mul(v_i_1622, 0.01)), J.add(J.add(J.gp(v_N_1613, "TC"), 0.02), J.mul(v_i_1622, 0.01))])
		var _t658 = J.gp(v_src_1621, 0.0)
		var _t659 = J.add(J.gp(v_T_1620, 0.0), J.mul((J.sub(v_i_1622, 2.5) * 0.06), v_th_1617))
		var _t657 = J.gp(v_N_1613, "E")
		v_x_1624 = J.mc(v_N_1613, "lerp", [_t658, _t659, J.mc(_t657, "o", [v_q_1623])])
		var _t661 = J.gp(v_src_1621, 1.0)
		var _t662 = J.add(J.gp(v_T_1620, 1.0), J.mul((J.sub(J.mc(v_N_1613, "rnd", [v_i_1622]), 0.5) * 0.3), v_th_1617))
		var _t660 = J.gp(v_N_1613, "E")
		v_y_1625 = J.mc(v_N_1613, "lerp", [_t661, _t662, J.mc(_t660, "o", [v_q_1623])])
		v_al_1626 = J.sub(1.0, J.mc(v_N_1613, "seg", [v_t_1615, 0.45, 0.59]))
		if J.cmp(v_q_1623, 0.0, "<="):
			v_i_1622 = J.num(v_i_1622) + 1.0
			continue
		J.mc(v_ctx_1611, "save", [])
		var _t663 = J.mul(J.gp(v_ctx_1611, "globalAlpha"), J.mul(v_al_1626, 0.85))
		J.sp(v_ctx_1611, "globalAlpha", _t663)
		var _t664 = ("rgba(140,190,70,.8)" if J.t(J.mod(v_i_1622, 2.0)) else "rgba(110,160,60,.8)")
		J.sp(v_ctx_1611, "fillStyle", _t664)
		J.sp(v_ctx_1611, "strokeStyle", "rgba(50,80,30,.7)")
		var _t665 = J.mul(0.008, v_H_1616)
		J.sp(v_ctx_1611, "lineWidth", _t665)
		J.mc(v_ctx_1611, "beginPath", [])
		J.mc(v_ctx_1611, "arc", [v_x_1624, v_y_1625, J.mul((0.05 + J.mul(0.07, v_q_1623)), v_H_1616), 0.0, 7.0])
		J.mc(v_ctx_1611, "fill", [])
		J.mc(v_ctx_1611, "stroke", [])
		J.mc(v_ctx_1611, "restore", [])
		v_i_1622 = J.num(v_i_1622) + 1.0
	if J.cmp(v_t_1615, J.gp(v_N_1613, "TC"), ">"):
		v_i_1627 = 0.0
		while true:
			if not J.cmp(v_i_1627, 3.0, "<"): break
			v_q_1628 = J.mc(v_N_1613, "seg", [v_t_1615, J.add(J.gp(v_N_1613, "TC"), J.mul(v_i_1627, 0.03)), 0.59])
			v_pts_1629 = []
			v_j_1630 = 0.0
			while true:
				if not J.cmp(v_j_1630, 6.0, "<="): break
				J.mc(v_pts_1629, "push", [[J.add(J.add(J.gp(v_T_1620, 0.0), J.mul((J.sub(v_i_1627, 1.0) * 0.12), v_th_1617)), J.mul((sin(J.num(J.add(J.add(v_j_1630, J.mul(v_t_1615, 14.0)), v_i_1627))) * 0.03), v_th_1617)), ((J.sub(J.gp(v_T_1620, 1.0), J.mul(0.2, v_th_1617)) - J.mul(J.mul(v_j_1630, 0.06), v_th_1617)) - J.mul(J.mul(v_q_1628, 0.2), v_th_1617))]])
				v_j_1630 = J.num(v_j_1630) + 1.0
			J.mc(v_N_1613, "crayon", [v_ctx_1611, v_pts_1629, "rgba(120,170,60,.85)", J.mul(0.018, v_th_1617), J.add(940.0, v_i_1627), sin(J.num(J.mul(v_q_1628, PI)))])
			v_i_1627 = J.num(v_i_1627) + 1.0
	J.mc(v_N_1613, "pop", [v_ctx_1611, v_S_1614, J.add(J.gp(v_src_1621, 0.0), J.mul(0.1, v_H_1616)), J.sub(J.gp(v_src_1621, 1.0), J.mul(0.1, v_H_1616)), "噗——", J.mul(0.12, v_H_1616), "#b8e070", 0.2, 0.2])
	J.mc(v_N_1613, "pop", [v_ctx_1611, v_S_1614, J.gp(v_T_1620, 0.0), J.sub(J.gp(v_T_1620, 1.0), J.mul(0.55, v_th_1617)), "臭！", J.mul(0.26, v_th_1617), "#b8e070", J.add(J.gp(v_N_1613, "TC"), 0.02), 0.3])
	J.mc(v_N_1613, "hit", [v_S_1614, J.gp(v_T_1620, 0.0), J.gp(v_T_1620, 1.0)])
	J.mc(J.G.get("N30M"), "end", [v_ctx_1611])

func _f105(this_, a: Array, env):
	var v_c_1649 = null; var v_i_1650 = null; var v_q_1651 = null
	v_c_1649 = J.arg(a, 0)
	v_i_1650 = J.arg(a, 1)
	v_q_1651 = J.mc(env["N"], "seg", [env["t"], (0.02 + J.mul(v_i_1650, 0.025)), 0.25])
	var _t672 = J.cmp(v_q_1651, 0.0, ">")
	if (J.cmp(v_q_1651, 1.0, "<") if _t672 else _t672):
		J.mc(env["N"], "txt", [env["ctx"], env["S"], J.add(J.gp(env["hd"], 0.0), J.mul((J.sub(v_i_1650, 2.5) * 0.08), env["H"])), (J.sub(J.gp(env["hd"], 1.0), J.mul(0.1, env["H"])) - J.mul(J.mul(v_q_1651, 0.06), env["H"])), J.mul(0.08, env["H"]), v_c_1649, "#9fe8ff", sin(J.num(J.mul(v_q_1651, PI)))])

func _f104(this_, a: Array, env):
	var v_a_1634 = null; var v_th_1639 = null; var v_mash_1640 = null; var v_f_1641 = null; var v_m_1642 = null; var v_pad_1643 = null; var v_T_1645 = null; var v_ar_1646 = null; var v_B_1647 = null; var v_p_1648 = null; var v_i_1652 = null; var v_q_1653 = null; var v_x_1654 = null; var v_y_1655 = null; var v_r_1656 = null; var v_c_1657 = null; var v_col_1658 = null; var v_i_1659 = null; var v_an_1660 = null; var v_d_1661 = null; var v_s_1662 = null
	var _s325 = {"__p": env, "ctx": null, "N": null, "S": null, "t": null, "H": null, "hd": null}
	_s325["ctx"] = J.arg(a, 0)
	v_a_1634 = J.arg(a, 1)
	_s325["N"] = J.G.get("N30K")
	_s325["S"] = J.mc(_s325["N"], "setup", [v_a_1634])
	if (not J.t(_s325["S"])):
		return false
	_s325["t"] = J.gp(_s325["S"], "tt")
	_s325["H"] = J.gp(_s325["S"], "H")
	v_th_1639 = J.gp(_s325["S"], "th")
	v_mash_1640 = (sin(J.num(J.mul(_s325["t"], 70.0))) * 0.06)
	v_f_1641 = J.mc(_s325["N"], "kf", [_s325["t"], [[0.0, {}], [0.16, {"head": 0.1, "body": 0.08, "r": 2.0}], [J.gp(_s325["N"], "TC"), {"head": (-0.05), "body": (-0.05), "r": (-4.0), "x": J.mul(0.02, _s325["H"])}], [0.59, {}]]])
	if J.cmp(_s325["t"], 0.4, "<"):
		var _t668 = J.gp(v_f_1641, "armF")
		var _t669 = J.add((_t668 if J.t(_t668) else 0.0), v_mash_1640)
		J.sp(v_f_1641, "armF", _t669)
		var _t670 = J.gp(v_f_1641, "armB")
		var _t671 = J.sub((_t670 if J.t(_t670) else 0.0), v_mash_1640)
		J.sp(v_f_1641, "armB", _t671)
	J.mc(J.G.get("N30M"), "begin", [_s325["ctx"], _s325["S"], J.gp(v_f_1641, "x")])
	J.mc(_s325["N"], "whole", [_s325["ctx"], _s325["S"], v_f_1641, null, 0.3])
	v_m_1642 = J.mc(_s325["N"], "bm", [_s325["S"], v_f_1641])
	v_pad_1643 = J.mc(_s325["N"], "at", [_s325["S"], v_m_1642, 0.4, 0.6])
	_s325["hd"] = J.mc(_s325["N"], "at", [_s325["S"], v_m_1642, 0.42, 0.02])
	v_T_1645 = J.mc(_s325["N"], "tgt", [_s325["S"], 0.6])
	v_ar_1646 = ["↑", "↑", "↓", "↓", "←", "→"]
	J.mc(v_ar_1646, "forEach", [Callable(self, "_f105").bind(_s325)])
	v_B_1647 = [["A", "#4ac060"], ["B", "#e84a4a"], ["X", "#4a8ae8"], ["Y", "#e8c84a"]]
	v_i_1652 = 0.0
	while true:
		if not J.cmp(v_i_1652, 8.0, "<"): break
		v_q_1653 = J.mc(_s325["N"], "seg", [_s325["t"], (0.18 + J.mul(v_i_1652, 0.008)), J.add(J.gp(_s325["N"], "TC"), J.mul(v_i_1652, 0.008))])
		var _t673 = J.cmp(v_q_1653, 0.0, "<=")
		if (_t673 if _t673 else J.cmp(v_q_1653, 1.0, ">=")):
			v_i_1652 = J.num(v_i_1652) + 1.0
			continue
		v_x_1654 = J.mc(_s325["N"], "lerp", [J.gp(v_pad_1643, 0.0), J.gp(v_T_1645, 0.0), v_q_1653])
		v_y_1655 = J.sub(J.mc(_s325["N"], "lerp", [J.gp(v_pad_1643, 1.0), J.add(J.gp(v_T_1645, 1.0), J.mul(((J.mod(v_i_1652, 3.0) - 1.0) * 0.1), v_th_1639)), v_q_1653]), J.mul((sin(J.num(J.mul(v_q_1653, PI))) * 0.1), _s325["H"]))
		v_r_1656 = J.mul(0.035, _s325["H"])
		var _t674 = J.gp(v_B_1647, J.mod(v_i_1652, 4.0))
		var _t675 = J.gp(_t674, 0.0)
		v_c_1657 = _t675
		var _t676 = J.gp(_t674, 1.0)
		v_col_1658 = _t676
		J.mc(_s325["ctx"], "save", [])
		var _t677 = _s325["ctx"]
		J.sp(_t677, "fillStyle", v_col_1658)
		var _t678 = _s325["ctx"]
		J.sp(_t678, "strokeStyle", "#1a1a2a")
		var _t679 = _s325["ctx"]
		var _t680 = J.mul(v_r_1656, 0.2)
		J.sp(_t679, "lineWidth", _t680)
		J.mc(_s325["ctx"], "beginPath", [])
		J.mc(_s325["ctx"], "arc", [v_x_1654, v_y_1655, v_r_1656, 0.0, 7.0])
		J.mc(_s325["ctx"], "fill", [])
		J.mc(_s325["ctx"], "stroke", [])
		J.mc(_s325["ctx"], "restore", [])
		J.mc(_s325["N"], "txt", [_s325["ctx"], _s325["S"], v_x_1654, v_y_1655, J.mul(v_r_1656, 1.3), v_c_1657, "#ffffff"])
		v_i_1652 = J.num(v_i_1652) + 1.0
	v_p_1648 = J.sub(_s325["t"], J.gp(_s325["N"], "TC"))
	var _t681 = J.cmp(v_p_1648, 0.0, ">=")
	if (J.cmp(v_p_1648, 0.3, "<") if _t681 else _t681):
		v_i_1659 = 0.0
		while true:
			if not J.cmp(v_i_1659, 12.0, "<"): break
			v_an_1660 = J.mul(J.mc(_s325["N"], "rnd", [J.add(v_i_1659, 950.0)]), 6.28)
			v_d_1661 = J.mul(J.mul((0.1 + J.mul(v_p_1648, 1.2)), v_th_1639), J.add(0.5, J.mc(_s325["N"], "rnd", [J.add(v_i_1659, 960.0)])))
			v_s_1662 = (J.mul(0.035, v_th_1639) * (1.0 - J.div(v_p_1648, 0.3)))
			var _t682 = _s325["ctx"]
			var _t683 = J.gp(["#ffe14a", "#ff5a8a", "#5ae8ff"], J.mod(v_i_1659, 3.0))
			J.sp(_t682, "fillStyle", _t683)
			J.mc(_s325["ctx"], "fillRect", [J.sub(J.add(J.gp(v_T_1645, 0.0), J.mul(cos(J.num(v_an_1660)), v_d_1661)), J.div(v_s_1662, 2.0)), J.sub(J.add(J.gp(v_T_1645, 1.0), J.mul(sin(J.num(v_an_1660)), v_d_1661)), J.div(v_s_1662, 2.0)), v_s_1662, v_s_1662])
			v_i_1659 = J.num(v_i_1659) + 1.0
	J.mc(_s325["N"], "pop", [_s325["ctx"], _s325["S"], J.gp(v_T_1645, 0.0), J.sub(J.gp(v_T_1645, 1.0), J.mul(0.5, v_th_1639)), "COMBO ×8", J.mul(0.16, v_th_1639), "#ffe14a", J.gp(_s325["N"], "TC"), 0.3])
	J.mc(_s325["N"], "pop", [_s325["ctx"], _s325["S"], J.gp(_s325["hd"], 0.0), J.sub(J.gp(_s325["hd"], 1.0), J.mul(0.1, _s325["H"])), "GG", J.mul(0.12, _s325["H"]), "#9fe8ff", 0.45, 0.14])
	J.mc(_s325["N"], "hit", [_s325["S"], J.gp(v_T_1645, 0.0), J.gp(v_T_1645, 1.0)])
	J.mc(J.G.get("N30M"), "end", [_s325["ctx"]])

func _f106(this_, a: Array, env):
	var v_ctx_1665 = null; var v_a_1666 = null; var v_N_1667 = null; var v_S_1668 = null; var v_t_1669 = null; var v_H_1670 = null; var v_th_1671 = null; var v_D2_1672 = null; var v_fl_1673 = null; var v_f_1674 = null; var v_T_1675 = null; var v_p_1676 = null; var v_k_1677 = null
	v_ctx_1665 = J.arg(a, 0)
	v_a_1666 = J.arg(a, 1)
	v_N_1667 = J.G.get("N30K")
	v_S_1668 = J.mc(v_N_1667, "setup", [v_a_1666])
	if (not J.t(v_S_1668)):
		return false
	v_t_1669 = J.gp(v_S_1668, "tt")
	v_H_1670 = J.gp(v_S_1668, "H")
	v_th_1671 = J.gp(v_S_1668, "th")
	v_D2_1672 = J.sub(J.gp(v_S_1668, "tx"), J.mul(0.1, v_th_1671))
	v_fl_1673 = (sin(J.num(J.mul(v_t_1669, 30.0))) * 0.06)
	v_f_1674 = J.mc(v_N_1667, "kf", [v_t_1669, [[0.0, {}], [0.1, {"y": J.mul((-0.25), v_H_1670), "r": (-8.0), "sy": 1.08}], [0.19, {"y": J.mul((-0.6), v_H_1670), "sy": 0.14, "r": 0.0}], [J.gp(v_N_1667, "TC"), {"y": J.mul((-0.6), v_H_1670), "sy": 0.12, "x": v_D2_1672, "r": 4.0}, "i"], [0.34, {"y": J.mul((-0.6), v_H_1670), "sy": 0.14, "x": J.add(v_D2_1672, J.mul(0.1, v_H_1670))}], [0.44, {"y": J.mul((-0.35), v_H_1670), "sy": 0.7, "x": J.mul(v_D2_1672, 0.5), "r": (-10.0)}], [0.52, {"y": J.mul((-0.1), v_H_1670), "sy": 1.05, "x": J.mul(v_D2_1672, 0.15), "r": 6.0}], [0.59, {}]]])
	J.sp(v_f_1674, "px", 0.0)
	var _t686 = J.mul((-0.5), v_H_1670)
	J.sp(v_f_1674, "py", _t686)
	if J.cmp(v_t_1669, 0.5, "<"):
		var _t687 = J.mul(v_fl_1673, 2.0)
		J.sp(v_f_1674, "armF", _t687)
	var _t688 = ((-J.num(v_fl_1673)) * 2.0)
	J.sp(v_f_1674, "armB", _t688)
	var _t690 = J.gp(v_f_1674, "x")
	var _t689 = J.gp(v_f_1674, "y")
	J.mc(J.G.get("N30M"), "begin", [v_ctx_1665, v_S_1668, _t690, (1.0 - J.mul(J.mc(v_N_1667, "cl", [J.div((-J.num((_t689 if J.t(_t689) else 0.0))), v_H_1670)]), 0.6))])
	var _t691 = J.cmp(v_t_1669, 0.19, ">")
	if (J.cmp(v_t_1669, J.add(J.gp(v_N_1667, "TC"), 0.02), "<") if _t691 else _t691):
		var _t692 = J.gp(v_f_1674, "x")
		J.mc(v_N_1667, "speed", [v_ctx_1665, J.sub((_t692 if J.t(_t692) else 0.0), J.mul(0.4, J.gp(v_S_1668, "W"))), J.sub(J.gp(v_f_1674, "y"), J.mul(0.5, v_H_1670)), 1.0, 0.0, J.mul(0.5, v_H_1670), J.mul(0.06, v_H_1670), 1.0, "rgba(240,240,255,.8)", 970.0, 3.0])
	J.mc(v_N_1667, "whole", [v_ctx_1665, v_S_1668, v_f_1674, null, 0.3])
	v_T_1675 = J.mc(v_N_1667, "tgt", [v_S_1668, 0.6])
	v_p_1676 = J.sub(v_t_1669, J.gp(v_N_1667, "TC"))
	var _t693 = J.cmp(v_p_1676, 0.0, ">=")
	if (J.cmp(v_p_1676, 0.2, "<") if _t693 else _t693):
		v_k_1677 = J.min_([1.0, J.div(v_p_1676, 0.04)])
		J.mc(v_N_1667, "crayon", [v_ctx_1665, [[J.sub(J.gp(v_T_1675, 0.0), J.mul(0.35, v_th_1671)), J.sub(J.gp(v_T_1675, 1.0), J.mul(0.05, v_th_1671))], [(J.sub(J.gp(v_T_1675, 0.0), J.mul(0.35, v_th_1671)) + J.mul(J.mul(0.7, v_th_1671), v_k_1677)), J.add(J.gp(v_T_1675, 1.0), J.mul(0.05, v_th_1671))]], "rgba(255,255,255,.95)", J.mul(0.03, v_th_1671), 975.0, (1.0 - J.div(v_p_1676, 0.2))])
	var _t694 = J.cmp(v_p_1676, 0.0, ">=")
	if (J.cmp(v_p_1676, 0.12, "<") if _t694 else _t694):
		J.mc(v_N_1667, "burst", [v_ctx_1665, J.gp(v_T_1675, 0.0), J.gp(v_T_1675, 1.0), J.mul(0.3, v_th_1671), (1.0 - J.div(v_p_1676, 0.12)), "#ffffff", 977.0, 9.0])
	J.mc(v_N_1667, "pop", [v_ctx_1665, v_S_1668, J.gp(v_T_1675, 0.0), J.sub(J.gp(v_T_1675, 1.0), J.mul(0.45, v_th_1671)), "唰！", J.mul(0.24, v_th_1671), "#ffffff", J.gp(v_N_1667, "TC"), 0.28])
	J.mc(v_N_1667, "hit", [v_S_1668, J.gp(v_T_1675, 0.0), J.gp(v_T_1675, 1.0)])
	J.mc(J.G.get("N30M"), "end", [v_ctx_1665])
