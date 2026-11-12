# 自動轉譯自 n30_daily.js（tools/jsgd.js）——唔好直接改，改原 JS 再轉
extends RefCounted

func run(env):
	var this_ = null; var a = []
	J.G["N30D"] = J.cl(Callable(self, "_f1").bind(env), null, [])

func _f6(this_, a: Array, env):
	var v_ctx_42 = null; var v_a_43 = null; var v_S_44 = null; var v_H_45 = null; var v_at_46 = null; var v_g_47 = null; var v_f_48 = null; var v_m_49 = null; var v_post_50 = null
	v_ctx_42 = J.arg(a, 0)
	v_a_43 = J.arg(a, 1)
	v_S_44 = J.mc(env["__p"]["N"], "setup", [v_a_43])
	if (not J.t(v_S_44)):
		return false
	v_H_45 = J.gp(v_S_44, "H")
	var _t5 = J.gp(J.gp(v_a_43, "o"), "at")
	v_at_46 = (_t5 if J.t(_t5) else 0.0)
	v_g_47 = J.div(J.mod(v_at_46, env["dur"]), env["dur"])
	var _t6 = env["fr"]
	var _t7 = J.cl(_t6, null, [v_g_47, v_H_45, v_S_44])
	v_f_48 = (_t7 if J.t(_t7) else {})
	v_m_49 = J.mc(env["__p"]["N"], "bm", [v_S_44, v_f_48])
	J.mc(v_ctx_42, "save", [])
	var _t8 = J.gp(env["__p"]["N"], "K")
	J.mc(_t8, "enter", [v_ctx_42, v_S_44])
	var _t9 = J.gp(v_f_48, "x")
	var _t11 = (_t9 if J.t(_t9) else 0.0)
	var _t10 = J.gp(v_f_48, "y")
	J.mc(env["__p"]["N"], "shadow", [v_ctx_42, v_S_44, _t11, 0.0, (1.0 - J.mul(J.mc(env["__p"]["N"], "cl", [J.div((-J.num((_t10 if J.t(_t10) else 0.0))), v_H_45)]), 0.5))])
	if J.t((J.gp(env["fx"], "pre") if J.t(env["fx"]) else env["fx"])):
		J.mc(env["fx"], "pre", [v_ctx_42, v_S_44, v_g_47, v_m_49, v_f_48, v_H_45])
	J.mc(env["__p"]["N"], "body", [v_ctx_42, v_S_44, v_m_49, J.mc(env["__p"]["N"], "pose", [v_S_44, v_f_48, (1.0 if J.leq(env["idleK"], null) else env["idleK"])]), null, (J.gp(v_f_48, "a") if (not J.leq(J.gp(v_f_48, "a"), null)) else null)])
	var _t13 = env["fx"]
	if J.t(_t13):
		var _t12 = J.gp(env["fx"], "post")
		_t13 = (_t12 if J.t(_t12) else (env["fx"] if J.seq(J.typeof_(env["fx"]), "function") else null))
	v_post_50 = _t13
	if J.t(v_post_50):
		J.cl(v_post_50, null, [v_ctx_42, v_S_44, v_g_47, v_m_49, v_f_48, v_H_45])
	J.mc(v_ctx_42, "restore", [])

func _f5(this_, a: Array, env):
	var v_id_31 = null; var v_act_32 = null; var v_zh_33 = null; var v_desc_35 = null; var v_key_39 = null
	var _s6 = {"__p": env, "dur": null, "fr": null, "fx": null, "idleK": null}
	v_id_31 = J.arg(a, 0)
	v_act_32 = J.arg(a, 1)
	v_zh_33 = J.arg(a, 2)
	_s6["dur"] = J.arg(a, 3)
	v_desc_35 = J.arg(a, 4)
	_s6["fr"] = J.arg(a, 5)
	_s6["fx"] = J.arg(a, 6)
	_s6["idleK"] = J.arg(a, 7)
	v_key_39 = J.add((J.add("n30_", v_id_31) + "_"), v_act_32)
	var _t1 = _s6["__p"]["ACTS"]
	var _t2 = J.gp(_s6["__p"]["ACTS"], v_id_31)
	var _t3 = (_t2 if J.t(_t2) else [])
	J.sp(_t1, v_id_31, _t3)
	J.mc(_t3, "push", [[v_key_39, v_zh_33, _s6["dur"], v_desc_35]])
	var _t4 = J.G.get("DAILY")
	var _t14 = Callable(self, "_f6").bind(_s6)
	J.sp(_t4, v_key_39, _t14)

func _f2(this_, a: Array, env):
	var v_g_18 = null; var v_n_19 = null; var v_ph_20 = null
	v_g_18 = J.arg(a, 0)
	v_n_19 = J.arg(a, 1)
	v_ph_20 = J.arg(a, 2)
	return sin(J.num(J.add(J.mul(J.mul(v_g_18, env["TAU"]), (v_n_19 if J.t(v_n_19) else 1.0)), (v_ph_20 if J.t(v_ph_20) else 0.0))))

func _f3(this_, a: Array, env):
	var v_g_21 = null; var v_a_22 = null; var v_b_23 = null; var v_c_24 = null; var v_d_25 = null
	v_g_21 = J.arg(a, 0)
	v_a_22 = J.arg(a, 1)
	v_b_23 = J.arg(a, 2)
	v_c_24 = J.arg(a, 3)
	v_d_25 = J.arg(a, 4)
	var _t15 = J.gp(env["N"], "E")
	var _t17 = J.mc(_t15, "io", [J.mc(env["N"], "seg", [v_g_21, v_a_22, v_b_23])])
	var _t16 = J.gp(env["N"], "E")
	return J.mul(_t17, J.sub(1.0, J.mc(_t16, "io", [J.mc(env["N"], "seg", [v_g_21, v_c_24, v_d_25])])))

func _f4(this_, a: Array, env):
	var v_g_26 = null; var v_a_27 = null; var v_b_28 = null
	v_g_26 = J.arg(a, 0)
	v_a_27 = J.arg(a, 1)
	v_b_28 = J.arg(a, 2)
	return sin(J.num(J.mul(J.mc(env["N"], "seg", [v_g_26, v_a_27, v_b_28]), env["PI"])))

func _f7(this_, a: Array, env):
	var v_ctx_51 = null; var v_S_52 = null; var v_x_53 = null; var v_y_54 = null; var v_s_55 = null; var v_str_56 = null; var v_col_57 = null; var v_al_58 = null
	v_ctx_51 = J.arg(a, 0)
	v_S_52 = J.arg(a, 1)
	v_x_53 = J.arg(a, 2)
	v_y_54 = J.arg(a, 3)
	v_s_55 = J.arg(a, 4)
	v_str_56 = J.arg(a, 5)
	v_col_57 = J.arg(a, 6)
	v_al_58 = J.arg(a, 7)
	return J.mc(env["N"], "txt", [v_ctx_51, v_S_52, v_x_53, v_y_54, v_str_56, v_s_55, v_col_57, v_al_58])

func _f8(this_, a: Array, env):
	var v_ctx_59 = null; var v_S_60 = null; var v_p_61 = null; var v_g_62 = null; var v_a_63 = null; var v_b_64 = null; var v_H_65 = null; var v_col_66 = null; var v_q_67 = null
	v_ctx_59 = J.arg(a, 0)
	v_S_60 = J.arg(a, 1)
	v_p_61 = J.arg(a, 2)
	v_g_62 = J.arg(a, 3)
	v_a_63 = J.arg(a, 4)
	v_b_64 = J.arg(a, 5)
	v_H_65 = J.arg(a, 6)
	v_col_66 = J.arg(a, 7)
	v_q_67 = J.mc(env["N"], "seg", [v_g_62, v_a_63, v_b_64])
	var _t18 = J.cmp(v_q_67, 0.0, ">")
	if (J.cmp(v_q_67, 1.0, "<") if _t18 else _t18):
		var _t19 = env["T"]
		J.cl(_t19, null, [v_ctx_59, v_S_60, J.add(J.gp(v_p_61, 0.0), J.mul(J.mul(v_q_67, 0.12), v_H_65)), J.sub(J.gp(v_p_61, 1.0), J.mul(J.mul(v_q_67, 0.2), v_H_65)), J.mul(0.09, v_H_65), ("♪" if J.cmp(v_q_67, 0.5, "<") else "♫"), (v_col_66 if J.t(v_col_66) else "#cfe8ff"), sin(J.num(J.mul(v_q_67, env["PI"])))])

func _f9(this_, a: Array, env):
	var v_ctx_68 = null; var v_S_69 = null; var v_p_70 = null; var v_g_71 = null; var v_H_72 = null; var v_i_73 = null; var v_q_74 = null
	v_ctx_68 = J.arg(a, 0)
	v_S_69 = J.arg(a, 1)
	v_p_70 = J.arg(a, 2)
	v_g_71 = J.arg(a, 3)
	v_H_72 = J.arg(a, 4)
	v_i_73 = 0.0
	while true:
		if not J.cmp(v_i_73, 3.0, "<"): break
		v_q_74 = J.mod((J.mul(v_g_71, 2.0) + J.div(v_i_73, 3.0)), 1.0)
		var _t20 = env["T"]
		J.cl(_t20, null, [v_ctx_68, v_S_69, J.add(J.gp(v_p_70, 0.0), J.mul(J.mul(v_q_74, 0.12), v_H_72)), J.sub(J.gp(v_p_70, 1.0), J.mul(J.mul(v_q_74, 0.25), v_H_72)), J.mul((0.06 + J.mul(v_i_73, 0.02)), v_H_72), "z", "#c8d8ff", sin(J.num(J.mul(v_q_74, env["PI"])))])
		v_i_73 = J.num(v_i_73) + 1.0

func _f10(this_, a: Array, env):
	var v_ctx_75 = null; var v_S_76 = null; var v_p_77 = null; var v_g_78 = null; var v_H_79 = null
	v_ctx_75 = J.arg(a, 0)
	v_S_76 = J.arg(a, 1)
	v_p_77 = J.arg(a, 2)
	v_g_78 = J.arg(a, 3)
	v_H_79 = J.arg(a, 4)
	return J.mc(env["N"], "drops", [v_ctx_75, J.gp(v_p_77, 0.0), J.gp(v_p_77, 1.0), J.mul(0.25, v_H_79), J.mod(J.mul(v_g_78, 3.0), 1.0), "rgba(150,210,255,.9)", (floor(J.num(J.mul(v_g_78, 3.0))) * 7.0), 3.0])

func _f11(this_, a: Array, env):
	var v_ctx_80 = null; var v_x_81 = null; var v_y_82 = null; var v_r_83 = null; var v_rot_84 = null; var v_al_85 = null; var v_k_86 = null; var v_an_87 = null
	v_ctx_80 = J.arg(a, 0)
	v_x_81 = J.arg(a, 1)
	v_y_82 = J.arg(a, 2)
	v_r_83 = J.arg(a, 3)
	v_rot_84 = J.arg(a, 4)
	v_al_85 = J.arg(a, 5)
	J.mc(v_ctx_80, "save", [])
	var _t21 = J.mul(J.gp(v_ctx_80, "globalAlpha"), v_al_85)
	J.sp(v_ctx_80, "globalAlpha", _t21)
	J.mc(v_ctx_80, "translate", [v_x_81, v_y_82])
	J.mc(v_ctx_80, "rotate", [v_rot_84])
	J.sp(v_ctx_80, "strokeStyle", "#eaf6ff")
	var _t22 = J.mul(v_r_83, 0.22)
	J.sp(v_ctx_80, "lineWidth", _t22)
	J.sp(v_ctx_80, "lineCap", "round")
	J.mc(v_ctx_80, "beginPath", [])
	v_k_86 = 0.0
	while true:
		if not J.cmp(v_k_86, 3.0, "<"): break
		v_an_87 = J.div(J.mul(v_k_86, env["PI"]), 3.0)
		J.mc(v_ctx_80, "moveTo", [J.mul((-cos(J.num(v_an_87))), v_r_83), J.mul((-sin(J.num(v_an_87))), v_r_83)])
		J.mc(v_ctx_80, "lineTo", [J.mul(cos(J.num(v_an_87)), v_r_83), J.mul(sin(J.num(v_an_87)), v_r_83)])
		v_k_86 = J.num(v_k_86) + 1.0
	J.mc(v_ctx_80, "stroke", [])
	J.mc(v_ctx_80, "restore", [])

func _f12(this_, a: Array, env):
	var v_ctx_88 = null; var v_x_89 = null; var v_y_90 = null; var v_r_91 = null; var v_sx_92 = null
	v_ctx_88 = J.arg(a, 0)
	v_x_89 = J.arg(a, 1)
	v_y_90 = J.arg(a, 2)
	v_r_91 = J.arg(a, 3)
	v_sx_92 = J.arg(a, 4)
	J.mc(v_ctx_88, "save", [])
	J.mc(v_ctx_88, "translate", [v_x_89, v_y_90])
	J.mc(v_ctx_88, "scale", [v_sx_92, 1.0])
	J.sp(v_ctx_88, "fillStyle", "#e8b84a")
	J.sp(v_ctx_88, "strokeStyle", "#6a4a10")
	var _t23 = J.mul(v_r_91, 0.18)
	J.sp(v_ctx_88, "lineWidth", _t23)
	J.mc(v_ctx_88, "beginPath", [])
	J.mc(v_ctx_88, "arc", [0.0, 0.0, v_r_91, 0.0, 7.0])
	J.mc(v_ctx_88, "fill", [])
	J.mc(v_ctx_88, "stroke", [])
	J.mc(v_ctx_88, "strokeRect", [((-J.num(v_r_91)) * 0.3), ((-J.num(v_r_91)) * 0.3), J.mul(v_r_91, 0.6), J.mul(v_r_91, 0.6)])
	J.mc(v_ctx_88, "restore", [])

func _f13(this_, a: Array, env):
	var v_ctx_93 = null; var v_x_94 = null; var v_y_95 = null; var v_w_96 = null; var v_rot_97 = null; var v_red_98 = null
	v_ctx_93 = J.arg(a, 0)
	v_x_94 = J.arg(a, 1)
	v_y_95 = J.arg(a, 2)
	v_w_96 = J.arg(a, 3)
	v_rot_97 = J.arg(a, 4)
	v_red_98 = J.arg(a, 5)
	J.mc(v_ctx_93, "save", [])
	J.mc(v_ctx_93, "translate", [v_x_94, v_y_95])
	J.mc(v_ctx_93, "rotate", [v_rot_97])
	J.sp(v_ctx_93, "fillStyle", "#fbf6ea")
	J.sp(v_ctx_93, "strokeStyle", "#3a2a2a")
	var _t24 = J.mul(v_w_96, 0.1)
	J.sp(v_ctx_93, "lineWidth", _t24)
	J.mc(v_ctx_93, "beginPath", [])
	J.mc(v_ctx_93, "roundRect", [J.div((-J.num(v_w_96)), 2.0), ((-J.num(v_w_96)) * 0.7), v_w_96, J.mul(v_w_96, 1.4), J.mul(v_w_96, 0.15)])
	J.mc(v_ctx_93, "fill", [])
	J.mc(v_ctx_93, "stroke", [])
	var _t25 = ("#c8202a" if J.t(v_red_98) else "#222")
	J.sp(v_ctx_93, "fillStyle", _t25)
	var _t26 = ("900 " + J.str(J.mul(v_w_96, 0.8)) + "px sans-serif")
	J.sp(v_ctx_93, "font", _t26)
	J.sp(v_ctx_93, "textAlign", "center")
	J.sp(v_ctx_93, "textBaseline", "middle")
	J.mc(v_ctx_93, "fillText", [("♥" if J.t(v_red_98) else "♠"), 0.0, 0.0])
	J.mc(v_ctx_93, "restore", [])

func _f14(this_, a: Array, env):
	var v_S_99 = null; var v_m_100 = null; var v_u_101 = null; var v_v_102 = null
	v_S_99 = J.arg(a, 0)
	v_m_100 = J.arg(a, 1)
	v_u_101 = J.arg(a, 2)
	v_v_102 = J.arg(a, 3)
	return J.mc(env["N"], "at", [v_S_99, v_m_100, v_u_101, v_v_102])

func _f15(this_, a: Array, env):
	var v_g_103 = null; var v_H_104 = null
	v_g_103 = J.arg(a, 0)
	v_H_104 = J.arg(a, 1)
	var _t27 = env["sw"]
	var _t29 = J.mul(J.cl(_t27, null, [v_g_103]), 6.0)
	var _t30 = J.mul((-1.2), v_H_104)
	var _t28 = env["sw"]
	var _t32 = J.mul(J.cl(_t28, null, [v_g_103, 1.0, 0.8]), 0.4)
	var _t31 = env["sw"]
	return {"r": _t29, "px": 0.0, "py": _t30, "rope": _t32, "head": J.mul(J.cl(_t31, null, [v_g_103, 1.0, 0.5]), 0.1)}

func _f16(this_, a: Array, env):
	var v_g_105 = null; var v_H_106 = null
	v_g_105 = J.arg(a, 0)
	v_H_106 = J.arg(a, 1)
	var _t33 = env["sw"]
	var _t35 = J.mul(J.cl(_t33, null, [v_g_105, 2.0]), 0.18)
	var _t34 = env["env"]
	var _t37 = J.mul(_t35, J.cl(_t34, null, [v_g_105, 0.0, 0.1, 0.8, 1.0]))
	var _t36 = env["sw"]
	return {"head": _t37, "body": J.mul(J.cl(_t36, null, [v_g_105, 2.0, 0.5]), 0.05)}

func _f17(this_, a: Array, env):
	var v_ctx_107 = null; var v_S_108 = null; var v_g_109 = null; var v_m_110 = null; var v_f_111 = null; var v_H_112 = null; var v_p_113 = null
	v_ctx_107 = J.arg(a, 0)
	v_S_108 = J.arg(a, 1)
	v_g_109 = J.arg(a, 2)
	v_m_110 = J.arg(a, 3)
	v_f_111 = J.arg(a, 4)
	v_H_112 = J.arg(a, 5)
	var _t38 = env["at"]
	v_p_113 = J.cl(_t38, null, [v_S_108, v_m_110, 0.42, 0.58])
	J.mc(env["N"], "drops", [v_ctx_107, J.gp(v_p_113, 0.0), J.gp(v_p_113, 1.0), J.mul(0.25, v_H_112), J.mod(J.mul(v_g_109, 2.0), 1.0), "rgba(200,235,255,.9)", (floor(J.num(J.mul(v_g_109, 2.0))) * 3.0), 4.0])

func _f18(this_, a: Array, env):
	var v_g_114 = null; var v_H_115 = null
	v_g_114 = J.arg(a, 0)
	v_H_115 = J.arg(a, 1)
	var _t39 = env["bump"]
	var _t41 = (1.0 - J.mul(0.04, J.cl(_t39, null, [v_g_114, 0.2, 0.8])))
	var _t40 = env["bump"]
	var _t43 = J.mul(0.2, J.cl(_t40, null, [v_g_114, 0.2, 0.9]))
	var _t42 = env["bump"]
	var _t46 = J.mul(0.1, J.cl(_t42, null, [v_g_114, 0.2, 0.8]))
	var _t45 = (-0.1)
	var _t44 = env["bump"]
	return {"sy": _t41, "head": _t43, "armF": _t46, "armB": J.mul(_t45, J.cl(_t44, null, [v_g_114, 0.2, 0.8]))}

func _f19(this_, a: Array, env):
	var v_ctx_116 = null; var v_S_117 = null; var v_g_118 = null; var v_m_119 = null; var v_f_120 = null; var v_H_121 = null
	v_ctx_116 = J.arg(a, 0)
	v_S_117 = J.arg(a, 1)
	v_g_118 = J.arg(a, 2)
	v_m_119 = J.arg(a, 3)
	v_f_120 = J.arg(a, 4)
	v_H_121 = J.arg(a, 5)
	var _t47 = env["T"]
	var _t49 = J.mul(0.25, v_H_121)
	var _t50 = J.mul((-1.05), v_H_121)
	var _t51 = J.mul(0.1, v_H_121)
	var _t48 = env["bump"]
	return J.cl(_t47, null, [v_ctx_116, v_S_117, _t49, _t50, _t51, "唉……", "#e0e0f0", J.cl(_t48, null, [v_g_118, 0.25, 0.85])])

func _f20(this_, a: Array, env):
	var v_g_122 = null; var v_H_123 = null
	v_g_122 = J.arg(a, 0)
	v_H_123 = J.arg(a, 1)
	var _t53 = (-0.6)
	var _t52 = env["sw"]
	var _t55 = (_t53 - J.mul(J.cl(_t52, null, [v_g_122, 4.0]), 0.2))
	var _t56 = (-0.04)
	var _t54 = env["sw"]
	return {"armF": _t55, "body": _t56, "held": J.mul(J.cl(_t54, null, [v_g_122, 4.0]), 0.04)}

func _f21(this_, a: Array, env):
	var v_ctx_124 = null; var v_S_125 = null; var v_g_126 = null; var v_m_127 = null; var v_f_128 = null; var v_H_129 = null
	v_ctx_124 = J.arg(a, 0)
	v_S_125 = J.arg(a, 1)
	v_g_126 = J.arg(a, 2)
	v_m_127 = J.arg(a, 3)
	v_f_128 = J.arg(a, 4)
	v_H_129 = J.arg(a, 5)
	if J.cmp(v_g_126, 0.7, ">"):
		var _t57 = env["at"]
		var _t59 = J.gp(J.cl(_t57, null, [v_S_125, v_m_127, 0.72, 0.38]), 0.0)
		var _t58 = env["at"]
		J.mc(env["N"], "burst", [v_ctx_124, _t59, J.gp(J.cl(_t58, null, [v_S_125, v_m_127, 0.72, 0.38]), 1.0), J.mul(0.1, v_H_129), (1.0 - J.div(J.sub(v_g_126, 0.7), 0.3)), "#fff6c0", 1.0, 6.0])

func _f22(this_, a: Array, env):
	var v_g_130 = null; var v_H_131 = null
	v_g_130 = J.arg(a, 0)
	v_H_131 = J.arg(a, 1)
	var _t60 = env["bump"]
	var _t62 = (1.0 + J.mul(0.03, J.cl(_t60, null, [v_g_130, 0.1, 0.4])))
	var _t61 = env["sw"]
	return {"sy": _t62, "head": J.mul(J.cl(_t61, null, [v_g_130, 2.0]), 0.1)}

func _f23(this_, a: Array, env):
	var v_ctx_132 = null; var v_S_133 = null; var v_g_134 = null; var v_m_135 = null; var v_f_136 = null; var v_H_137 = null; var v_p_138 = null; var v_i_139 = null
	v_ctx_132 = J.arg(a, 0)
	v_S_133 = J.arg(a, 1)
	v_g_134 = J.arg(a, 2)
	v_m_135 = J.arg(a, 3)
	v_f_136 = J.arg(a, 4)
	v_H_137 = J.arg(a, 5)
	var _t63 = env["at"]
	v_p_138 = J.cl(_t63, null, [v_S_133, v_m_135, 0.34, 0.2])
	v_i_139 = 0.0
	while true:
		if not J.cmp(v_i_139, 3.0, "<"): break
		J.mc(env["N"], "puff", [v_ctx_132, J.gp(v_p_138, 0.0), J.sub(J.gp(v_p_138, 1.0), J.mul(0.05, v_H_137)), J.mul(0.06, v_H_137), J.mod(J.add(v_g_134, J.div(v_i_139, 3.0)), 1.0), "rgba(200,200,215,.55)", J.mul(v_i_139, 9.0), 3.0])
		v_i_139 = J.num(v_i_139) + 1.0

func _f24(this_, a: Array, env):
	var v_g_140 = null; var v_H_141 = null
	v_g_140 = J.arg(a, 0)
	v_H_141 = J.arg(a, 1)
	var _t64 = env["sw"]
	var _t66 = J.mul(J.cl(_t64, null, [v_g_140, 2.0]), 0.12)
	var _t65 = env["env"]
	var _t70 = J.mul(_t66, J.cl(_t65, null, [v_g_140, 0.0, 0.1, 0.8, 1.0]))
	var _t67 = env["sw"]
	var _t69 = J.mul(J.cl(_t67, null, [v_g_140, 2.0, 0.5]), 0.15)
	var _t68 = env["env"]
	return {"armB": _t70, "held": J.mul(_t69, J.cl(_t68, null, [v_g_140, 0.0, 0.1, 0.8, 1.0]))}

func _f25(this_, a: Array, env):
	var v_g_142 = null; var v_H_143 = null; var v_k_144 = null
	v_g_142 = J.arg(a, 0)
	v_H_143 = J.arg(a, 1)
	var _t71 = env["env"]
	v_k_144 = J.cl(_t71, null, [v_g_142, 0.1, 0.3, 0.7, 0.9])
	var _t74 = (1.0 + J.mul(0.05, v_k_144))
	var _t75 = (1.0 + J.mul(0.02, v_k_144))
	var _t76 = J.mul((-0.25), v_k_144)
	var _t77 = J.mul(0.3, v_k_144)
	var _t73 = J.mul((-0.2), v_k_144)
	var _t72 = env["sw"]
	return {"sx": _t74, "sy": _t75, "armF": _t76, "armB": _t77, "hairL": (_t73 + J.mul(J.cl(_t72, null, [v_g_142, 3.0]), 0.05)), "hairR": J.mul((-0.2), v_k_144)}

func _f26(this_, a: Array, env):
	var v_ctx_145 = null; var v_S_146 = null; var v_g_147 = null; var v_m_148 = null; var v_f_149 = null; var v_H_150 = null
	v_ctx_145 = J.arg(a, 0)
	v_S_146 = J.arg(a, 1)
	v_g_147 = J.arg(a, 2)
	v_m_148 = J.arg(a, 3)
	v_f_149 = J.arg(a, 4)
	v_H_150 = J.arg(a, 5)
	var _t78 = J.cmp(v_g_147, 0.3, ">")
	if (J.cmp(v_g_147, 0.7, "<") if _t78 else _t78):
		J.mc(env["N"], "burst", [v_ctx_145, J.mul(0.3, v_H_150), J.mul((-0.7), v_H_150), J.mul(0.12, v_H_150), (1.0 - J.div(J.sub(v_g_147, 0.3), 0.4)), "#fff0a0", 3.0, 6.0])

func _f27(this_, a: Array, env):
	var v_g_151 = null; var v_H_152 = null
	v_g_151 = J.arg(a, 0)
	v_H_152 = J.arg(a, 1)
	var _t80 = (-0.3)
	var _t79 = env["sw"]
	var _t82 = (_t80 + J.mul(J.cl(_t79, null, [v_g_151, 5.0]), 0.12))
	var _t81 = env["sw"]
	var _t84 = J.mul(J.cl(_t81, null, [v_g_151, 5.0, 1.0]), 0.04)
	var _t83 = env["sw"]
	return {"armF": _t82, "body": _t84, "r": J.mul(J.cl(_t83, null, [v_g_151, 2.5]), 2.0)}

func _f28(this_, a: Array, env):
	var v_ctx_153 = null; var v_S_154 = null; var v_g_155 = null; var v_m_156 = null; var v_f_157 = null; var v_H_158 = null
	v_ctx_153 = J.arg(a, 0)
	v_S_154 = J.arg(a, 1)
	v_g_155 = J.arg(a, 2)
	v_m_156 = J.arg(a, 3)
	v_f_157 = J.arg(a, 4)
	v_H_158 = J.arg(a, 5)
	var _t85 = env["T"]
	var _t87 = J.mul((-0.1), v_H_158)
	var _t88 = J.mul((-1.05), v_H_158)
	var _t89 = J.mul(0.09, v_H_158)
	var _t86 = env["bump"]
	return J.cl(_t85, null, [v_ctx_153, v_S_154, _t87, _t88, _t89, "啊～", "#ffe0a0", J.cl(_t86, null, [v_g_155, 0.4, 0.9])])

func _f29(this_, a: Array, env):
	var v_g_159 = null; var v_H_160 = null; var v_k_161 = null
	v_g_159 = J.arg(a, 0)
	v_H_160 = J.arg(a, 1)
	var _t90 = env["bump"]
	v_k_161 = J.cl(_t90, null, [v_g_159, 0.15, 0.6])
	return {"head": J.mul((-0.3), v_k_161), "body": J.mul((-0.08), v_k_161), "armF": J.mul(0.1, v_k_161), "y": J.mul(J.mul((-0.02), v_H_160), v_k_161)}

func _f30(this_, a: Array, env):
	var v_ctx_162 = null; var v_S_163 = null; var v_g_164 = null; var v_m_165 = null; var v_f_166 = null; var v_H_167 = null
	v_ctx_162 = J.arg(a, 0)
	v_S_163 = J.arg(a, 1)
	v_g_164 = J.arg(a, 2)
	v_m_165 = J.arg(a, 3)
	v_f_166 = J.arg(a, 4)
	v_H_167 = J.arg(a, 5)
	var _t91 = env["T"]
	var _t93 = J.mul(0.15, v_H_167)
	var _t94 = J.mul((-1.1), v_H_167)
	var _t95 = J.mul(0.14, v_H_167)
	var _t92 = env["bump"]
	return J.cl(_t91, null, [v_ctx_162, v_S_163, _t93, _t94, _t95, "吼！", "#ff9a6a", J.cl(_t92, null, [v_g_164, 0.2, 0.65])])

func _f31(this_, a: Array, env):
	var v_g_168 = null; var v_H_169 = null
	v_g_168 = J.arg(a, 0)
	v_H_169 = J.arg(a, 1)
	var _t97 = (-0.8)
	var _t96 = env["sw"]
	return {"armF": (_t97 + J.mul(J.cl(_t96, null, [v_g_168, 6.0]), 0.25)), "head": (-0.05)}

func _f32(this_, a: Array, env):
	var v_ctx_170 = null; var v_S_171 = null; var v_g_172 = null; var v_m_173 = null; var v_f_174 = null; var v_H_175 = null
	v_ctx_170 = J.arg(a, 0)
	v_S_171 = J.arg(a, 1)
	v_g_172 = J.arg(a, 2)
	v_m_173 = J.arg(a, 3)
	v_f_174 = J.arg(a, 4)
	v_H_175 = J.arg(a, 5)
	var _t98 = env["sweat"]
	var _t99 = env["at"]
	J.cl(_t98, null, [v_ctx_170, v_S_171, J.cl(_t99, null, [v_S_171, v_m_173, 0.5, 0.15]), v_g_172, v_H_175])
	J.mc(env["N"], "puff", [v_ctx_170, J.mul(0.1, v_H_175), J.mul((-0.03), v_H_175), J.mul(0.06, v_H_175), v_g_172, "rgba(255,220,180,.4)", 7.0, 3.0])

func _f33(this_, a: Array, env):
	var v_g_176 = null; var v_H_177 = null
	v_g_176 = J.arg(a, 0)
	v_H_177 = J.arg(a, 1)
	var _t100 = env["sw"]
	var _t102 = J.mul(J.cl(_t100, null, [v_g_176, 1.0]), 0.15)
	var _t101 = env["sw"]
	return {"head": _t102, "body": J.mul(J.cl(_t101, null, [v_g_176, 1.0, 0.3]), 0.04)}

func _f34(this_, a: Array, env):
	var v_ctx_178 = null; var v_S_179 = null; var v_g_180 = null; var v_m_181 = null; var v_f_182 = null; var v_H_183 = null
	v_ctx_178 = J.arg(a, 0)
	v_S_179 = J.arg(a, 1)
	v_g_180 = J.arg(a, 2)
	v_m_181 = J.arg(a, 3)
	v_f_182 = J.arg(a, 4)
	v_H_183 = J.arg(a, 5)
	var _t103 = env["T"]
	var _t105 = J.mul(0.3, v_H_183)
	var _t106 = J.mul((-1.05), v_H_183)
	var _t107 = J.mul(0.1, v_H_183)
	var _t104 = env["bump"]
	return J.cl(_t103, null, [v_ctx_178, v_S_179, _t105, _t106, _t107, "水……", "#ffd0a0", J.cl(_t104, null, [v_g_180, 0.3, 0.9])])

func _f35(this_, a: Array, env):
	var v_g_184 = null; var v_H_185 = null
	v_g_184 = J.arg(a, 0)
	v_H_185 = J.arg(a, 1)
	var _t109 = (-0.25)
	var _t108 = env["sw"]
	var _t111 = (_t109 - J.mul(J.cl(_t108, null, [v_g_184, 3.0]), 0.08))
	var _t112 = (-0.08)
	var _t110 = env["sw"]
	return {"armB": _t111, "body": _t112, "tiger": J.mul(J.cl(_t110, null, [v_g_184, 3.0, 1.0]), 0.08)}

func _f36(this_, a: Array, env):
	var v_ctx_186 = null; var v_S_187 = null; var v_g_188 = null; var v_m_189 = null; var v_f_190 = null; var v_H_191 = null; var v_p_192 = null
	v_ctx_186 = J.arg(a, 0)
	v_S_187 = J.arg(a, 1)
	v_g_188 = J.arg(a, 2)
	v_m_189 = J.arg(a, 3)
	v_f_190 = J.arg(a, 4)
	v_H_191 = J.arg(a, 5)
	var _t113 = env["at"]
	v_p_192 = J.cl(_t113, null, [v_S_187, v_m_189, 0.8, 0.68])
	var _t114 = env["T"]
	J.cl(_t114, null, [v_ctx_186, v_S_187, J.gp(v_p_192, 0.0), J.sub(J.gp(v_p_192, 1.0), J.mul((J.mod(v_g_188, 0.5) * 0.3), v_H_191)), J.mul(0.08, v_H_191), "♥", "#ff8aa8", sin(J.num(J.mul((J.mod(v_g_188, 0.5) * 2.0), env["PI"])))])

func _f37(this_, a: Array, env):
	var v_g_193 = null; var v_H_194 = null
	v_g_193 = J.arg(a, 0)
	v_H_194 = J.arg(a, 1)
	var _t116 = (-0.7)
	var _t117 = (-0.06)
	var _t115 = env["sw"]
	return {"armF": _t116, "head": _t117, "tiger": J.mul(J.cl(_t115, null, [v_g_193, 4.0]), 0.06)}

func _f38(this_, a: Array, env):
	var v_ctx_195 = null; var v_S_196 = null; var v_g_197 = null; var v_m_198 = null; var v_f_199 = null; var v_H_200 = null; var v_p_201 = null
	v_ctx_195 = J.arg(a, 0)
	v_S_196 = J.arg(a, 1)
	v_g_197 = J.arg(a, 2)
	v_m_198 = J.arg(a, 3)
	v_f_199 = J.arg(a, 4)
	v_H_200 = J.arg(a, 5)
	var _t118 = env["at"]
	v_p_201 = J.cl(_t118, null, [v_S_196, v_m_198, 0.25, 0.33])
	var _t119 = env["note"]
	J.cl(_t119, null, [v_ctx_195, v_S_196, v_p_201, v_g_197, 0.0, 0.5, v_H_200])
	var _t120 = env["note"]
	J.cl(_t120, null, [v_ctx_195, v_S_196, v_p_201, v_g_197, 0.4, 0.9, v_H_200])

func _f39(this_, a: Array, env):
	var v_g_202 = null; var v_H_203 = null; var v_k_204 = null
	v_g_202 = J.arg(a, 0)
	v_H_203 = J.arg(a, 1)
	var _t121 = env["env"]
	v_k_204 = J.cl(_t121, null, [v_g_202, 0.1, 0.3, 0.7, 0.9])
	var _t123 = J.mul((-0.5), v_k_204)
	var _t124 = J.mul((-0.5), v_k_204)
	var _t122 = env["sw"]
	var _t126 = J.mul(J.cl(_t122, null, [v_g_202, 2.0]), 0.08)
	var _t125 = env["sw"]
	return {"armF": _t123, "armB": _t124, "hairL": _t126, "hairR": J.mul(J.cl(_t125, null, [v_g_202, 2.0, 1.0]), 0.08), "head": J.mul((-0.05), v_k_204)}

func _f40(this_, a: Array, env):
	var v_g_205 = null; var v_H_206 = null
	v_g_205 = J.arg(a, 0)
	v_H_206 = J.arg(a, 1)
	var _t128 = (cos(J.num(J.mul(J.mc(env["N"], "seg", [v_g_205, 0.2, 0.7]), env["TAU"]))) * 0.85)
	var _t127 = cos(J.num(J.mul(J.mc(env["N"], "seg", [v_g_205, 0.2, 0.7]), env["TAU"])))
	var _t131 = (_t128 + (0.15 * signf(J.num((_t127 if J.t(_t127) else 1.0)))))
	var _t130 = (-0.2)
	var _t129 = env["bump"]
	var _t134 = J.mul(_t130, J.cl(_t129, null, [v_g_205, 0.2, 0.7]))
	var _t133 = (-0.2)
	var _t132 = env["bump"]
	return {"sx": _t131, "hairL": _t134, "hairR": J.mul(_t133, J.cl(_t132, null, [v_g_205, 0.2, 0.7]))}

func _f41(this_, a: Array, env):
	var v_ctx_207 = null; var v_S_208 = null; var v_g_209 = null; var v_m_210 = null; var v_f_211 = null; var v_H_212 = null; var v_i_213 = null; var v_q_214 = null
	v_ctx_207 = J.arg(a, 0)
	v_S_208 = J.arg(a, 1)
	v_g_209 = J.arg(a, 2)
	v_m_210 = J.arg(a, 3)
	v_f_211 = J.arg(a, 4)
	v_H_212 = J.arg(a, 5)
	v_i_213 = 0.0
	while true:
		if not J.cmp(v_i_213, 5.0, "<"): break
		v_q_214 = J.mod(J.add(v_g_209, J.div(v_i_213, 5.0)), 1.0)
		J.mc(v_ctx_207, "save", [])
		var _t135 = J.mul(J.gp(v_ctx_207, "globalAlpha"), (sin(J.num(J.mul(v_q_214, env["PI"]))) * 0.8))
		J.sp(v_ctx_207, "globalAlpha", _t135)
		J.sp(v_ctx_207, "fillStyle", "#e8303a")
		J.mc(v_ctx_207, "beginPath", [])
		J.mc(v_ctx_207, "ellipse", [(J.mul((J.sub(v_i_213, 2.0) * 0.12), v_H_212) + J.mul((sin(J.num(J.mul(v_q_214, 6.0))) * 0.03), v_H_212)), (J.mul((-1.0), v_H_212) + J.mul(J.mul(v_q_214, 0.9), v_H_212)), J.mul(0.02, v_H_212), J.mul(0.012, v_H_212), J.mul(v_q_214, 6.0), 0.0, 7.0])
		J.mc(v_ctx_207, "fill", [])
		J.mc(v_ctx_207, "restore", [])
		v_i_213 = J.num(v_i_213) + 1.0

func _f42(this_, a: Array, env):
	var v_g_215 = null; var v_H_216 = null
	v_g_215 = J.arg(a, 0)
	v_H_216 = J.arg(a, 1)
	var _t137 = J.mul((-0.02), v_H_216)
	var _t136 = env["bump"]
	var _t142 = J.mul(_t137, J.cl(_t136, null, [v_g_215, 0.1, 0.6]))
	var _t139 = (-0.1)
	var _t138 = env["bump"]
	var _t141 = J.mul(_t139, J.cl(_t138, null, [v_g_215, 0.1, 0.6]))
	var _t140 = env["sw"]
	return {"y": _t142, "head": (_t141 + J.mul(J.cl(_t140, null, [v_g_215, 1.0]), 0.05))}

func _f43(this_, a: Array, env):
	var v_ctx_217 = null; var v_S_218 = null; var v_g_219 = null; var v_m_220 = null; var v_f_221 = null; var v_H_222 = null
	v_ctx_217 = J.arg(a, 0)
	v_S_218 = J.arg(a, 1)
	v_g_219 = J.arg(a, 2)
	v_m_220 = J.arg(a, 3)
	v_f_221 = J.arg(a, 4)
	v_H_222 = J.arg(a, 5)
	var _t143 = env["T"]
	var _t145 = J.mul(0.2, v_H_222)
	var _t146 = J.mul((-1.08), v_H_222)
	var _t147 = J.mul(0.09, v_H_222)
	var _t144 = env["bump"]
	return J.cl(_t143, null, [v_ctx_217, v_S_218, _t145, _t146, _t147, "老公呢……", "#ffb0b0", J.cl(_t144, null, [v_g_219, 0.4, 0.95])])

func _f44(this_, a: Array, env):
	var v_g_223 = null; var v_H_224 = null; var v_u_225 = null
	v_g_223 = J.arg(a, 0)
	v_H_224 = J.arg(a, 1)
	var _t148 = env["sw"]
	v_u_225 = absf(J.num(J.cl(_t148, null, [v_g_223, 2.0])))
	return {"y": J.mul(J.mul((-0.1), v_H_224), v_u_225), "sy": ((1.0 + J.mul(0.03, v_u_225)) - (0.06 if J.cmp(v_u_225, 0.15, "<") else 0.0)), "armF": J.mul(v_u_225, 0.3), "armB": ((-J.num(v_u_225)) * 0.3)}

func _f45(this_, a: Array, env):
	var v_g_226 = null; var v_H_227 = null
	v_g_226 = J.arg(a, 0)
	v_H_227 = J.arg(a, 1)
	var _t150 = (-1.0)
	var _t149 = env["sw"]
	var _t152 = (_t150 - J.mul(J.cl(_t149, null, [v_g_226, 6.0]), 0.15))
	var _t151 = env["sw"]
	return {"armB": _t152, "head": (0.1 + J.mul(J.cl(_t151, null, [v_g_226, 6.0]), 0.04))}

func _f46(this_, a: Array, env):
	var v_ctx_228 = null; var v_S_229 = null; var v_g_230 = null; var v_m_231 = null; var v_f_232 = null; var v_H_233 = null
	v_ctx_228 = J.arg(a, 0)
	v_S_229 = J.arg(a, 1)
	v_g_230 = J.arg(a, 2)
	v_m_231 = J.arg(a, 3)
	v_f_232 = J.arg(a, 4)
	v_H_233 = J.arg(a, 5)
	var _t153 = env["at"]
	var _t155 = J.gp(J.cl(_t153, null, [v_S_229, v_m_231, 0.5, 0.05]), 0.0)
	var _t154 = env["at"]
	return J.mc(env["N"], "puff", [v_ctx_228, _t155, J.gp(J.cl(_t154, null, [v_S_229, v_m_231, 0.5, 0.05]), 1.0), J.mul(0.05, v_H_233), J.mod(J.mul(v_g_230, 2.0), 1.0), "rgba(160,150,100,.5)", 9.0, 4.0])

func _f47(this_, a: Array, env):
	var v_g_234 = null; var v_H_235 = null
	v_g_234 = J.arg(a, 0)
	v_H_235 = J.arg(a, 1)
	var _t157 = (-0.6)
	var _t156 = env["sw"]
	return {"armF": _t157, "armB": 0.6, "r": J.mul(J.cl(_t156, null, [v_g_234]), 7.0), "px": 0.0, "py": 0.0}

func _f48(this_, a: Array, env):
	var v_g_236 = null; var v_H_237 = null
	v_g_236 = J.arg(a, 0)
	v_H_237 = J.arg(a, 1)
	var _t159 = (-0.4)
	var _t158 = env["env"]
	var _t162 = J.mul(_t159, J.cl(_t158, null, [v_g_236, 0.1, 0.35, 0.6, 0.85]))
	var _t161 = (-0.08)
	var _t160 = env["bump"]
	var _t164 = J.mul(_t161, J.cl(_t160, null, [v_g_236, 0.1, 0.85]))
	var _t163 = env["sw"]
	return {"armF": _t162, "head": _t164, "orn": J.mul(J.cl(_t163, null, [v_g_236, 2.0]), 0.2)}

func _f49(this_, a: Array, env):
	var v_g_238 = null; var v_H_239 = null
	v_g_238 = J.arg(a, 0)
	v_H_239 = J.arg(a, 1)
	var _t168 = (-0.3)
	var _t165 = env["sw"]
	var _t167 = J.mul(J.cl(_t165, null, [v_g_238, 6.0]), 0.03)
	var _t166 = env["bump"]
	var _t170 = J.mul(_t167, J.cl(_t166, null, [v_g_238, 0.1, 0.8]))
	var _t169 = env["sw"]
	return {"armF": _t168, "body": _t170, "head": J.mul(J.cl(_t169, null, [v_g_238, 6.0]), 0.04)}

func _f50(this_, a: Array, env):
	var v_ctx_240 = null; var v_S_241 = null; var v_g_242 = null; var v_m_243 = null; var v_f_244 = null; var v_H_245 = null
	v_ctx_240 = J.arg(a, 0)
	v_S_241 = J.arg(a, 1)
	v_g_242 = J.arg(a, 2)
	v_m_243 = J.arg(a, 3)
	v_f_244 = J.arg(a, 4)
	v_H_245 = J.arg(a, 5)
	var _t171 = env["T"]
	var _t173 = J.mul(0.25, v_H_245)
	var _t174 = J.mul((-1.05), v_H_245)
	var _t175 = J.mul(0.09, v_H_245)
	var _t172 = env["bump"]
	return J.cl(_t171, null, [v_ctx_240, v_S_241, _t173, _t174, _t175, "呵呵呵", "#f0e0f0", J.cl(_t172, null, [v_g_242, 0.1, 0.85])])

func _f51(this_, a: Array, env):
	var v_g_246 = null; var v_H_247 = null; var v_k_248 = null
	v_g_246 = J.arg(a, 0)
	v_H_247 = J.arg(a, 1)
	var _t176 = env["env"]
	v_k_248 = J.cl(_t176, null, [v_g_246, 0.1, 0.3, 0.7, 0.9])
	return {"r": J.mul((-5.0), v_k_248), "head": J.mul(0.15, v_k_248), "body": J.mul((-0.06), v_k_248), "armB": J.mul(0.2, v_k_248)}

func _f52(this_, a: Array, env):
	var v_ctx_249 = null; var v_S_250 = null; var v_g_251 = null; var v_m_252 = null; var v_f_253 = null; var v_H_254 = null
	v_ctx_249 = J.arg(a, 0)
	v_S_250 = J.arg(a, 1)
	v_g_251 = J.arg(a, 2)
	v_m_252 = J.arg(a, 3)
	v_f_253 = J.arg(a, 4)
	v_H_254 = J.arg(a, 5)
	var _t177 = J.cmp(v_g_251, 0.3, ">")
	if (J.cmp(v_g_251, 0.6, "<") if _t177 else _t177):
		var _t178 = env["at"]
		var _t180 = J.gp(J.cl(_t178, null, [v_S_250, v_m_252, 0.45, 0.18]), 0.0)
		var _t179 = env["at"]
		J.mc(env["N"], "burst", [v_ctx_249, _t180, J.gp(J.cl(_t179, null, [v_S_250, v_m_252, 0.45, 0.18]), 1.0), J.mul(0.12, v_H_254), (1.0 - J.div(J.sub(v_g_251, 0.3), 0.3)), "#ffe0f0", 11.0, 6.0])

func _f53(this_, a: Array, env):
	var v_g_255 = null; var v_H_256 = null
	v_g_255 = J.arg(a, 0)
	v_H_256 = J.arg(a, 1)
	var _t181 = env["sw"]
	var _t184 = (0.15 + J.mul(J.cl(_t181, null, [v_g_255, 4.0]), 0.08))
	var _t183 = (-0.15)
	var _t182 = env["sw"]
	var _t186 = (_t183 - J.mul(J.cl(_t182, null, [v_g_255, 4.0]), 0.08))
	var _t185 = env["sw"]
	return {"armF": _t184, "armB": _t186, "sy": (1.0 + J.mul(J.cl(_t185, null, [v_g_255, 4.0]), 0.01))}

func _f54(this_, a: Array, env):
	var v_ctx_257 = null; var v_S_258 = null; var v_g_259 = null; var v_m_260 = null; var v_f_261 = null; var v_H_262 = null
	v_ctx_257 = J.arg(a, 0)
	v_S_258 = J.arg(a, 1)
	v_g_259 = J.arg(a, 2)
	v_m_260 = J.arg(a, 3)
	v_f_261 = J.arg(a, 4)
	v_H_262 = J.arg(a, 5)
	var _t187 = env["at"]
	var _t189 = J.gp(J.cl(_t187, null, [v_S_258, v_m_260, 0.13, 0.66]), 0.0)
	var _t188 = env["at"]
	J.mc(env["N"], "puff", [v_ctx_257, _t189, J.gp(J.cl(_t188, null, [v_S_258, v_m_260, 0.13, 0.66]), 1.0), J.mul(0.05, v_H_262), J.mod(J.mul(v_g_259, 2.0), 1.0), "rgba(190,175,150,.5)", 13.0, 3.0])
	var _t190 = env["at"]
	var _t192 = J.gp(J.cl(_t190, null, [v_S_258, v_m_260, 0.66, 0.66]), 0.0)
	var _t191 = env["at"]
	J.mc(env["N"], "puff", [v_ctx_257, _t192, J.gp(J.cl(_t191, null, [v_S_258, v_m_260, 0.66, 0.66]), 1.0), J.mul(0.05, v_H_262), J.mod((J.mul(v_g_259, 2.0) + 0.5), 1.0), "rgba(190,175,150,.5)", 14.0, 3.0])

func _f55(this_, a: Array, env):
	var v_g_263 = null; var v_H_264 = null
	v_g_263 = J.arg(a, 0)
	v_H_264 = J.arg(a, 1)
	var _t194 = (-0.5)
	var _t193 = env["env"]
	return {"armF": J.mul(_t194, J.cl(_t193, null, [v_g_263, 0.05, 0.2, 0.8, 0.95])), "head": 0.12}

func _f56(this_, a: Array, env):
	var v_ctx_265 = null; var v_S_266 = null; var v_g_267 = null; var v_m_268 = null; var v_f_269 = null; var v_H_270 = null; var v_k_271 = null
	v_ctx_265 = J.arg(a, 0)
	v_S_266 = J.arg(a, 1)
	v_g_267 = J.arg(a, 2)
	v_m_268 = J.arg(a, 3)
	v_f_269 = J.arg(a, 4)
	v_H_270 = J.arg(a, 5)
	var _t195 = env["env"]
	v_k_271 = J.cl(_t195, null, [v_g_267, 0.05, 0.2, 0.8, 0.95])
	if J.cmp(v_k_271, 0.1, ">"):
		var _t196 = env["coin"]
		var _t197 = env["at"]
		var _t199 = J.gp(J.cl(_t197, null, [v_S_266, v_m_268, 0.2, 0.45]), 0.0)
		var _t198 = env["at"]
		J.cl(_t196, null, [v_ctx_265, _t199, J.sub(J.gp(J.cl(_t198, null, [v_S_266, v_m_268, 0.2, 0.45]), 1.0), J.mul(J.mul(0.05, v_H_270), v_k_271)), J.mul(0.035, v_H_270), cos(J.num(J.mul(v_g_267, 20.0)))])
	var _t200 = env["T"]
	var _t202 = J.mul(0.2, v_H_270)
	var _t203 = J.mul((-1.0), v_H_270)
	var _t204 = J.mul(0.09, v_H_270)
	var _t201 = env["bump"]
	J.cl(_t200, null, [v_ctx_265, v_S_266, _t202, _t203, _t204, "得一個……", "#e8dcc0", J.cl(_t201, null, [v_g_267, 0.3, 0.9])])

func _f57(this_, a: Array, env):
	var v_g_272 = null; var v_H_273 = null
	v_g_272 = J.arg(a, 0)
	v_H_273 = J.arg(a, 1)
	var _t206 = (-0.2)
	var _t205 = env["sw"]
	var _t208 = (_t206 + J.mul(J.cl(_t205, null, [v_g_272, 4.0]), 0.05))
	var _t207 = env["sw"]
	return {"armF": _t208, "armB": (0.15 - J.mul(J.cl(_t207, null, [v_g_272, 4.0]), 0.05))}

func _f58(this_, a: Array, env):
	var v_ctx_274 = null; var v_S_275 = null; var v_g_276 = null; var v_m_277 = null; var v_f_278 = null; var v_H_279 = null; var v_A0_280 = null; var v_B0_281 = null; var v_i_282 = null; var v_q_283 = null
	v_ctx_274 = J.arg(a, 0)
	v_S_275 = J.arg(a, 1)
	v_g_276 = J.arg(a, 2)
	v_m_277 = J.arg(a, 3)
	v_f_278 = J.arg(a, 4)
	v_H_279 = J.arg(a, 5)
	var _t209 = env["at"]
	v_A0_280 = J.cl(_t209, null, [v_S_275, v_m_277, 0.18, 0.5])
	var _t210 = env["at"]
	v_B0_281 = J.cl(_t210, null, [v_S_275, v_m_277, 0.83, 0.43])
	v_i_282 = 0.0
	while true:
		if not J.cmp(v_i_282, 3.0, "<"): break
		v_q_283 = J.mod((J.mul(v_g_276, 3.0) + J.div(v_i_282, 3.0)), 1.0)
		var _t211 = env["card"]
		J.cl(_t211, null, [v_ctx_274, J.mc(env["N"], "lerp", [J.gp(v_B0_281, 0.0), J.gp(v_A0_280, 0.0), v_q_283]), J.sub(J.mc(env["N"], "lerp", [J.gp(v_B0_281, 1.0), J.gp(v_A0_280, 1.0), v_q_283]), J.mul((sin(J.num(J.mul(v_q_283, env["PI"]))) * 0.15), v_H_279)), J.mul(0.05, v_H_279), J.mul(v_q_283, 6.0), J.mod(v_i_282, 2.0)])
		v_i_282 = J.num(v_i_282) + 1.0

func _f59(this_, a: Array, env):
	var v_g_284 = null; var v_H_285 = null
	v_g_284 = J.arg(a, 0)
	v_H_285 = J.arg(a, 1)
	var _t213 = (0.3 if J.cmp(v_g_284, 0.2, "<") else (-0.3))
	var _t212 = env["bump"]
	var _t216 = J.mul(0.1, J.cl(_t212, null, [v_g_284, 0.3, 0.9]))
	var _t215 = J.mul((-0.03), v_H_285)
	var _t214 = env["bump"]
	return {"armF": _t213, "head": _t216, "y": J.mul(_t215, J.cl(_t214, null, [v_g_284, 0.6, 0.8]))}

func _f60(this_, a: Array, env):
	var v_ctx_286 = null; var v_S_287 = null; var v_g_288 = null; var v_m_289 = null; var v_f_290 = null; var v_H_291 = null; var v_q_292 = null; var v_i_293 = null; var v_x_294 = null; var v_y_295 = null
	v_ctx_286 = J.arg(a, 0)
	v_S_287 = J.arg(a, 1)
	v_g_288 = J.arg(a, 2)
	v_m_289 = J.arg(a, 3)
	v_f_290 = J.arg(a, 4)
	v_H_291 = J.arg(a, 5)
	v_q_292 = J.mc(env["N"], "seg", [v_g_288, 0.2, 0.55])
	if J.cmp(v_q_292, 0.0, ">"):
		v_i_293 = 0.0
		while true:
			if not J.cmp(v_i_293, 2.0, "<"): break
			v_x_294 = ((J.mul(0.15, v_H_291) + J.mul(J.mul(v_q_292, 0.3), v_H_291)) + J.mul(J.mul(v_i_293, 0.06), v_H_291))
			v_y_295 = (J.mul(((-absf(J.num(sin(J.num(J.mul(J.mul(v_q_292, 3.0), env["PI"])))))) * 0.12), v_H_291) * J.sub(1.0, v_q_292))
			J.mc(v_ctx_286, "save", [])
			J.mc(v_ctx_286, "translate", [v_x_294, J.sub(v_y_295, J.mul(0.02, v_H_291))])
			J.mc(v_ctx_286, "rotate", [(J.mul(v_q_292, 12.0) * J.sub(1.0, v_q_292))])
			J.sp(v_ctx_286, "fillStyle", "#fbf6ea")
			J.sp(v_ctx_286, "strokeStyle", "#3a2a2a")
			var _t217 = J.mul(0.004, v_H_291)
			J.sp(v_ctx_286, "lineWidth", _t217)
			J.mc(v_ctx_286, "fillRect", [J.mul((-0.02), v_H_291), J.mul((-0.02), v_H_291), J.mul(0.04, v_H_291), J.mul(0.04, v_H_291)])
			J.mc(v_ctx_286, "strokeRect", [J.mul((-0.02), v_H_291), J.mul((-0.02), v_H_291), J.mul(0.04, v_H_291), J.mul(0.04, v_H_291)])
			J.mc(v_ctx_286, "restore", [])
			v_i_293 = J.num(v_i_293) + 1.0
	var _t218 = env["T"]
	var _t220 = J.mul(0.3, v_H_291)
	var _t221 = J.mul((-1.05), v_H_291)
	var _t222 = J.mul(0.12, v_H_291)
	var _t219 = env["bump"]
	J.cl(_t218, null, [v_ctx_286, v_S_287, _t220, _t221, _t222, "六！", "#ffd84a", J.cl(_t219, null, [v_g_288, 0.6, 0.95])])

func _f61(this_, a: Array, env):
	var v_g_296 = null; var v_H_297 = null
	v_g_296 = J.arg(a, 0)
	v_H_297 = J.arg(a, 1)
	var _t224 = (-0.45)
	var _t223 = env["sw"]
	var _t226 = (0.08 * absf(J.num(J.cl(_t223, null, [v_g_296, 1.5]))))
	var _t225 = env["sw"]
	return {"armF": _t224, "armB": 0.45, "body": _t226, "head": (0.1 * absf(J.num(J.cl(_t225, null, [v_g_296, 1.5]))))}

func _f62(this_, a: Array, env):
	var v_ctx_298 = null; var v_S_299 = null; var v_g_300 = null; var v_m_301 = null; var v_f_302 = null; var v_H_303 = null
	v_ctx_298 = J.arg(a, 0)
	v_S_299 = J.arg(a, 1)
	v_g_300 = J.arg(a, 2)
	v_m_301 = J.arg(a, 3)
	v_f_302 = J.arg(a, 4)
	v_H_303 = J.arg(a, 5)
	var _t227 = env["T"]
	var _t229 = J.mul(0.25, v_H_303)
	var _t230 = J.mul((-1.05), v_H_303)
	var _t231 = J.mul(0.09, v_H_303)
	var _t228 = env["bump"]
	return J.cl(_t227, null, [v_ctx_298, v_S_299, _t229, _t230, _t231, "發發發", "#ffd84a", J.cl(_t228, null, [v_g_300, 0.1, 0.9])])

func _f63(this_, a: Array, env):
	var v_g_304 = null; var v_H_305 = null; var v_k_306 = null
	v_g_304 = J.arg(a, 0)
	v_H_305 = J.arg(a, 1)
	var _t232 = env["env"]
	v_k_306 = J.cl(_t232, null, [v_g_304, 0.1, 0.3, 0.55, 0.7])
	return {"r": J.mul((-12.0), v_k_306), "head": J.mul((-0.3), v_k_306), "armF": J.mul((-0.3), v_k_306), "armB": J.mul((-0.3), v_k_306)}

func _f64(this_, a: Array, env):
	var v_ctx_307 = null; var v_S_308 = null; var v_g_309 = null; var v_m_310 = null; var v_f_311 = null; var v_H_312 = null; var v_p_313 = null; var v_i_314 = null; var v_q_315 = null
	v_ctx_307 = J.arg(a, 0)
	v_S_308 = J.arg(a, 1)
	v_g_309 = J.arg(a, 2)
	v_m_310 = J.arg(a, 3)
	v_f_311 = J.arg(a, 4)
	v_H_312 = J.arg(a, 5)
	var _t233 = env["T"]
	var _t235 = J.mul(0.2, v_H_312)
	var _t236 = J.mul((-1.0), v_H_312)
	var _t237 = J.mul(0.11, v_H_312)
	var _t234 = env["bump"]
	J.cl(_t233, null, [v_ctx_307, v_S_308, _t235, _t236, _t237, "嗝～", "#ffb0c8", J.cl(_t234, null, [v_g_309, 0.7, 0.98])])
	var _t238 = env["at"]
	v_p_313 = J.cl(_t238, null, [v_S_308, v_m_310, 0.3, 0.3])
	v_i_314 = 0.0
	while true:
		if not J.cmp(v_i_314, 3.0, "<"): break
		v_q_315 = J.mc(env["N"], "seg", [v_g_309, (0.7 + J.mul(v_i_314, 0.05)), 1.0])
		var _t239 = J.cmp(v_q_315, 0.0, ">")
		if (J.cmp(v_q_315, 1.0, "<") if _t239 else _t239):
			J.mc(env["N"], "ring", [v_ctx_307, J.gp(v_p_313, 0.0), J.sub(J.gp(v_p_313, 1.0), J.mul(J.mul(v_q_315, 0.3), v_H_312)), J.mul(0.025, v_H_312), J.mul(0.025, v_H_312), "rgba(200,220,255,.8)", J.mul(0.007, v_H_312), J.sub(1.0, v_q_315)])
		v_i_314 = J.num(v_i_314) + 1.0

func _f65(this_, a: Array, env):
	var v_g_316 = null; var v_H_317 = null
	v_g_316 = J.arg(a, 0)
	v_H_317 = J.arg(a, 1)
	var _t240 = env["sw"]
	var _t242 = J.mul(J.cl(_t240, null, [v_g_316]), 10.0)
	var _t241 = env["sw"]
	var _t244 = (_t242 + J.mul(J.cl(_t241, null, [v_g_316, 3.0]), 3.0))
	var _t243 = env["sw"]
	return {"r": _t244, "px": 0.0, "py": 0.0, "head": J.mul(J.cl(_t243, null, [v_g_316, 1.0, 1.0]), 0.15)}

func _f66(this_, a: Array, env):
	var v_g_318 = null; var v_H_319 = null
	v_g_318 = J.arg(a, 0)
	v_H_319 = J.arg(a, 1)
	var _t245 = env["sw"]
	var _t247 = J.mul(J.cl(_t245, null, [v_g_318, 4.0]), 0.1)
	var _t246 = env["sw"]
	return {"head": _t247, "body": J.mul(J.cl(_t246, null, [v_g_318, 4.0]), 0.03)}

func _f67(this_, a: Array, env):
	var v_ctx_320 = null; var v_S_321 = null; var v_g_322 = null; var v_m_323 = null; var v_f_324 = null; var v_H_325 = null; var v_p_326 = null
	v_ctx_320 = J.arg(a, 0)
	v_S_321 = J.arg(a, 1)
	v_g_322 = J.arg(a, 2)
	v_m_323 = J.arg(a, 3)
	v_f_324 = J.arg(a, 4)
	v_H_325 = J.arg(a, 5)
	var _t248 = env["at"]
	v_p_326 = J.cl(_t248, null, [v_S_321, v_m_323, 0.28, 0.28])
	var _t249 = env["note"]
	J.cl(_t249, null, [v_ctx_320, v_S_321, v_p_326, v_g_322, 0.0, 0.5, v_H_325, "#ffd0e0"])
	var _t250 = env["note"]
	J.cl(_t250, null, [v_ctx_320, v_S_321, v_p_326, v_g_322, 0.45, 0.95, v_H_325, "#ffd0e0"])

func _f68(this_, a: Array, env):
	var v_g_327 = null; var v_H_328 = null
	v_g_327 = J.arg(a, 0)
	v_H_328 = J.arg(a, 1)
	var _t252 = (-0.25)
	var _t251 = env["env"]
	var _t254 = J.mul(_t252, J.cl(_t251, null, [v_g_327, 0.05, 0.2, 0.35, 0.5]))
	var _t253 = env["bump"]
	return {"armB": _t254, "sy": (1.0 + J.mul(0.03, J.cl(_t253, null, [v_g_327, 0.1, 0.4])))}

func _f69(this_, a: Array, env):
	var v_ctx_329 = null; var v_S_330 = null; var v_g_331 = null; var v_m_332 = null; var v_f_333 = null; var v_H_334 = null; var v_p_335 = null; var v_i_336 = null; var v_q_337 = null
	v_ctx_329 = J.arg(a, 0)
	v_S_330 = J.arg(a, 1)
	v_g_331 = J.arg(a, 2)
	v_m_332 = J.arg(a, 3)
	v_f_333 = J.arg(a, 4)
	v_H_334 = J.arg(a, 5)
	var _t255 = env["at"]
	v_p_335 = J.cl(_t255, null, [v_S_330, v_m_332, 0.56, 0.36])
	v_i_336 = 0.0
	while true:
		if not J.cmp(v_i_336, 3.0, "<"): break
		v_q_337 = J.mc(env["N"], "seg", [v_g_331, (0.45 + J.mul(v_i_336, 0.08)), 1.0])
		var _t256 = J.cmp(v_q_337, 0.0, ">")
		if (J.cmp(v_q_337, 1.0, "<") if _t256 else _t256):
			J.mc(env["N"], "ring", [v_ctx_329, J.add(J.gp(v_p_335, 0.0), J.mul(J.mul(v_q_337, 0.4), v_H_334)), J.sub(J.gp(v_p_335, 1.0), J.mul(J.mul(v_q_337, 0.3), v_H_334)), J.mul(J.mul(0.04, v_H_334), J.add(1.0, v_q_337)), J.mul(J.mul(0.02, v_H_334), J.add(1.0, v_q_337)), "rgba(210,210,220,.85)", J.mul(0.015, v_H_334), J.sub(1.0, v_q_337)])
		v_i_336 = J.num(v_i_336) + 1.0

func _f70(this_, a: Array, env):
	var v_g_338 = null; var v_H_339 = null
	v_g_338 = J.arg(a, 0)
	v_H_339 = J.arg(a, 1)
	var _t257 = env["sw"]
	var _t259 = (0.15 * absf(J.num(J.cl(_t257, null, [v_g_338, 3.0]))))
	var _t258 = env["sw"]
	var _t261 = (0.15 * absf(J.num(J.cl(_t258, null, [v_g_338, 3.0]))))
	var _t260 = env["sw"]
	return {"body": _t259, "head": _t261, "r": (3.0 * absf(J.num(J.cl(_t260, null, [v_g_338, 3.0]))))}

func _f71(this_, a: Array, env):
	var v_ctx_340 = null; var v_S_341 = null; var v_g_342 = null; var v_m_343 = null; var v_f_344 = null; var v_H_345 = null
	v_ctx_340 = J.arg(a, 0)
	v_S_341 = J.arg(a, 1)
	v_g_342 = J.arg(a, 2)
	v_m_343 = J.arg(a, 3)
	v_f_344 = J.arg(a, 4)
	v_H_345 = J.arg(a, 5)
	var _t262 = env["T"]
	var _t264 = J.mul(0.3, v_H_345)
	var _t265 = J.mul((-0.95), v_H_345)
	var _t266 = J.mul(0.1, v_H_345)
	var _t263 = env["sw"]
	return J.cl(_t262, null, [v_ctx_340, v_S_341, _t264, _t265, _t266, "咳咳！", "#d0d0d8", absf(J.num(J.cl(_t263, null, [v_g_342, 1.5])))])

func _f72(this_, a: Array, env):
	var v_g_346 = null; var v_H_347 = null
	v_g_346 = J.arg(a, 0)
	v_H_347 = J.arg(a, 1)
	var _t268 = (-0.2)
	var _t267 = env["sw"]
	return {"armF": (_t268 + J.mul(J.cl(_t267, null, [v_g_346, 3.0]), 0.08)), "head": (-0.05)}

func _f73(this_, a: Array, env):
	var v_ctx_348 = null; var v_S_349 = null; var v_g_350 = null; var v_m_351 = null; var v_f_352 = null; var v_H_353 = null; var v_p_354 = null
	v_ctx_348 = J.arg(a, 0)
	v_S_349 = J.arg(a, 1)
	v_g_350 = J.arg(a, 2)
	v_m_351 = J.arg(a, 3)
	v_f_352 = J.arg(a, 4)
	v_H_353 = J.arg(a, 5)
	var _t269 = env["at"]
	v_p_354 = J.cl(_t269, null, [v_S_349, v_m_351, 0.18, 0.36])
	var _t270 = env["sw"]
	if J.cmp(J.cl(_t270, null, [v_g_350, 3.0]), 0.7, ">"):
		var _t272 = J.gp(v_p_354, 0.0)
		var _t273 = J.gp(v_p_354, 1.0)
		var _t274 = J.mul(0.08, v_H_353)
		var _t271 = env["sw"]
		J.mc(env["N"], "burst", [v_ctx_348, _t272, _t273, _t274, J.div(J.sub(J.cl(_t271, null, [v_g_350, 3.0]), 0.7), 0.3), "#fff0a0", 17.0, 6.0])
	var _t275 = env["T"]
	J.cl(_t275, null, [v_ctx_348, v_S_349, J.mul(0.25, v_H_353), J.mul((-1.05), v_H_353), J.mul(0.09, v_H_353), J.add(J.gp(["一", "二", "三"], floor(J.num(J.mul(v_g_350, 3.0)))), "……"), "#ffe08a", 0.9])

func _f74(this_, a: Array, env):
	var v_g_355 = null; var v_H_356 = null
	v_g_355 = J.arg(a, 0)
	v_H_356 = J.arg(a, 1)
	var _t276 = env["sw"]
	return {"armB": J.mul(J.cl(_t276, null, [v_g_355, 8.0]), 0.05), "head": 0.08}

func _f75(this_, a: Array, env):
	var v_ctx_357 = null; var v_S_358 = null; var v_g_359 = null; var v_m_360 = null; var v_f_361 = null; var v_H_362 = null
	v_ctx_357 = J.arg(a, 0)
	v_S_358 = J.arg(a, 1)
	v_g_359 = J.arg(a, 2)
	v_m_360 = J.arg(a, 3)
	v_f_361 = J.arg(a, 4)
	v_H_362 = J.arg(a, 5)
	var _t277 = env["T"]
	var _t278 = env["at"]
	var _t280 = J.gp(J.cl(_t278, null, [v_S_358, v_m_360, 0.66, 0.4]), 0.0)
	var _t279 = env["at"]
	var _t282 = J.sub(J.gp(J.cl(_t279, null, [v_S_358, v_m_360, 0.66, 0.4]), 1.0), J.mul(0.12, v_H_362))
	var _t283 = J.mul(0.07, v_H_362)
	var _t281 = env["sw"]
	return J.cl(_t277, null, [v_ctx_357, v_S_358, _t280, _t282, _t283, "啪", "#ffe08a", absf(J.num(J.cl(_t281, null, [v_g_359, 4.0])))])

func _f76(this_, a: Array, env):
	var v_g_363 = null; var v_H_364 = null; var v_k_365 = null
	v_g_363 = J.arg(a, 0)
	v_H_364 = J.arg(a, 1)
	var _t284 = env["env"]
	v_k_365 = J.cl(_t284, null, [v_g_363, 0.1, 0.3, 0.6, 0.8])
	var _t287 = J.mul((-0.6), v_k_365)
	var _t286 = J.mul(0.1, v_k_365)
	var _t285 = env["bump"]
	return {"armF": _t287, "head": (_t286 + J.mul(0.1, J.cl(_t285, null, [v_g_363, 0.75, 0.95])))}

func _f77(this_, a: Array, env):
	var v_ctx_366 = null; var v_S_367 = null; var v_g_368 = null; var v_m_369 = null; var v_f_370 = null; var v_H_371 = null
	v_ctx_366 = J.arg(a, 0)
	v_S_367 = J.arg(a, 1)
	v_g_368 = J.arg(a, 2)
	v_m_369 = J.arg(a, 3)
	v_f_370 = J.arg(a, 4)
	v_H_371 = J.arg(a, 5)
	var _t288 = env["T"]
	var _t290 = J.mul(0.2, v_H_371)
	var _t291 = J.mul((-1.05), v_H_371)
	var _t292 = J.mul(0.09, v_H_371)
	var _t289 = env["bump"]
	return J.cl(_t288, null, [v_ctx_366, v_S_367, _t290, _t291, _t292, "真㗎！", "#ffe08a", J.cl(_t289, null, [v_g_368, 0.7, 1.0])])

func _f78(this_, a: Array, env):
	var v_g_372 = null; var v_H_373 = null
	v_g_372 = J.arg(a, 0)
	v_H_373 = J.arg(a, 1)
	var _t293 = env["sw"]
	var _t295 = J.mul(J.cl(_t293, null, [v_g_372, 6.0]), 0.1)
	var _t294 = env["sw"]
	return {"armF": _t295, "paper": J.mul(J.cl(_t294, null, [v_g_372, 6.0, 1.0]), 0.2), "head": 0.05}

func _f79(this_, a: Array, env):
	var v_g_374 = null; var v_H_375 = null
	v_g_374 = J.arg(a, 0)
	v_H_375 = J.arg(a, 1)
	var _t299 = (-0.6)
	var _t296 = env["sw"]
	var _t298 = (absf(J.num(J.cl(_t296, null, [v_g_374, 3.0]))) * 0.3)
	var _t297 = env["env"]
	return {"armB": (_t299 + J.mul(_t298, J.cl(_t297, null, [v_g_374, 0.0, 0.1, 0.7, 0.9]))), "r": 2.0}

func _f80(this_, a: Array, env):
	var v_ctx_376 = null; var v_S_377 = null; var v_g_378 = null; var v_m_379 = null; var v_f_380 = null; var v_H_381 = null
	v_ctx_376 = J.arg(a, 0)
	v_S_377 = J.arg(a, 1)
	v_g_378 = J.arg(a, 2)
	v_m_379 = J.arg(a, 3)
	v_f_380 = J.arg(a, 4)
	v_H_381 = J.arg(a, 5)
	var _t300 = env["T"]
	var _t302 = J.mul(0.35, v_H_381)
	var _t303 = J.mul((-1.05), v_H_381)
	var _t304 = J.mul(0.1, v_H_381)
	var _t301 = env["bump"]
	return J.cl(_t300, null, [v_ctx_376, v_S_377, _t302, _t303, _t304, "開門！還錢！", "#ff5050", J.cl(_t301, null, [v_g_378, 0.1, 0.9])])

func _f81(this_, a: Array, env):
	var v_g_382 = null; var v_H_383 = null
	v_g_382 = J.arg(a, 0)
	v_H_383 = J.arg(a, 1)
	var _t306 = (-0.3)
	var _t305 = env["sw"]
	return {"armB": (_t306 - J.mul(J.cl(_t305, null, [v_g_382, 3.0]), 0.2)), "body": 0.12, "head": 0.1}

func _f82(this_, a: Array, env):
	var v_ctx_384 = null; var v_S_385 = null; var v_g_386 = null; var v_m_387 = null; var v_f_388 = null; var v_H_389 = null
	v_ctx_384 = J.arg(a, 0)
	v_S_385 = J.arg(a, 1)
	v_g_386 = J.arg(a, 2)
	v_m_387 = J.arg(a, 3)
	v_f_388 = J.arg(a, 4)
	v_H_389 = J.arg(a, 5)
	var _t307 = env["T"]
	return J.cl(_t307, null, [v_ctx_384, v_S_385, J.mul(0.45, v_H_389), J.mul((-0.04), v_H_389), J.mul(0.12, v_H_389), "債", "#c8141e", J.mc(env["N"], "cl", [J.mul(v_g_386, 1.5)])])

func _f83(this_, a: Array, env):
	var v_g_390 = null; var v_H_391 = null
	v_g_390 = J.arg(a, 0)
	v_H_391 = J.arg(a, 1)
	var _t308 = env["sw"]
	var _t310 = J.mul(J.mul(J.cl(_t308, null, [v_g_390, 18.0]), 0.012), v_H_391)
	var _t309 = env["sw"]
	return {"x": _t310, "head": J.mul(J.cl(_t309, null, [v_g_390, 15.0]), 0.03), "sy": (1.0 - 0.02)}

func _f84(this_, a: Array, env):
	var v_ctx_392 = null; var v_S_393 = null; var v_g_394 = null; var v_m_395 = null; var v_f_396 = null; var v_H_397 = null
	v_ctx_392 = J.arg(a, 0)
	v_S_393 = J.arg(a, 1)
	v_g_394 = J.arg(a, 2)
	v_m_395 = J.arg(a, 3)
	v_f_396 = J.arg(a, 4)
	v_H_397 = J.arg(a, 5)
	var _t311 = env["sweat"]
	var _t312 = env["at"]
	return J.cl(_t311, null, [v_ctx_392, v_S_393, J.cl(_t312, null, [v_S_393, v_m_395, 0.5, 0.15]), v_g_394, v_H_397])

func _f85(this_, a: Array, env):
	var v_g_398 = null; var v_H_399 = null; var v_k_400 = null
	v_g_398 = J.arg(a, 0)
	v_H_399 = J.arg(a, 1)
	var _t313 = env["env"]
	v_k_400 = J.cl(_t313, null, [v_g_398, 0.1, 0.4, 0.7, 0.9])
	return {"r": J.mul(8.0, v_k_400), "head": J.mul(0.2, v_k_400), "x": J.mul(J.mul(0.03, v_H_399), v_k_400)}

func _f86(this_, a: Array, env):
	var v_ctx_401 = null; var v_S_402 = null; var v_g_403 = null; var v_m_404 = null; var v_f_405 = null; var v_H_406 = null
	v_ctx_401 = J.arg(a, 0)
	v_S_402 = J.arg(a, 1)
	v_g_403 = J.arg(a, 2)
	v_m_404 = J.arg(a, 3)
	v_f_405 = J.arg(a, 4)
	v_H_406 = J.arg(a, 5)
	var _t314 = env["T"]
	var _t316 = J.mul(0.35, v_H_406)
	var _t317 = J.mul((-1.05), v_H_406)
	var _t318 = J.mul(0.09, v_H_406)
	var _t315 = env["bump"]
	return J.cl(_t314, null, [v_ctx_401, v_S_402, _t316, _t317, _t318, "有、有鬼呀？", "#bfe0ff", J.cl(_t315, null, [v_g_403, 0.35, 0.85])])

func _f87(this_, a: Array, env):
	var v_g_407 = null; var v_H_408 = null; var v_j_409 = null
	v_g_407 = J.arg(a, 0)
	v_H_408 = J.arg(a, 1)
	var _t319 = env["bump"]
	v_j_409 = J.cl(_t319, null, [v_g_407, 0.2, 0.45])
	return {"y": J.mul(J.mul((-0.18), v_H_408), v_j_409), "armF": J.mul((-0.6), v_j_409), "armB": J.mul(0.6, v_j_409), "sy": (1.0 + J.mul(0.06, v_j_409))}

func _f88(this_, a: Array, env):
	var v_ctx_410 = null; var v_S_411 = null; var v_g_412 = null; var v_m_413 = null; var v_f_414 = null; var v_H_415 = null
	v_ctx_410 = J.arg(a, 0)
	v_S_411 = J.arg(a, 1)
	v_g_412 = J.arg(a, 2)
	v_m_413 = J.arg(a, 3)
	v_f_414 = J.arg(a, 4)
	v_H_415 = J.arg(a, 5)
	var _t320 = env["T"]
	var _t322 = J.mul(0.25, v_H_415)
	var _t323 = J.mul((-1.15), v_H_415)
	var _t324 = J.mul(0.12, v_H_415)
	var _t321 = env["bump"]
	return J.cl(_t320, null, [v_ctx_410, v_S_411, _t322, _t323, _t324, "哇！", "#ffffff", J.cl(_t321, null, [v_g_412, 0.2, 0.6])])

func _f89(this_, a: Array, env):
	var v_g_416 = null; var v_H_417 = null; var v_d_418 = null
	v_g_416 = J.arg(a, 0)
	v_H_417 = J.arg(a, 1)
	var _t325 = env["env"]
	v_d_418 = J.cl(_t325, null, [v_g_416, 0.1, 0.3, 0.6, 0.85])
	return {"r": J.mul(70.0, v_d_418), "px": 0.0, "py": 0.0, "x": J.mul(J.mul(0.15, v_H_417), v_d_418), "armF": J.mul((-0.8), v_d_418), "armB": J.mul((-0.6), v_d_418)}

func _f90(this_, a: Array, env):
	var v_ctx_419 = null; var v_S_420 = null; var v_g_421 = null; var v_m_422 = null; var v_f_423 = null; var v_H_424 = null
	v_ctx_419 = J.arg(a, 0)
	v_S_420 = J.arg(a, 1)
	v_g_421 = J.arg(a, 2)
	v_m_422 = J.arg(a, 3)
	v_f_423 = J.arg(a, 4)
	v_H_424 = J.arg(a, 5)
	J.mc(env["N"], "puff", [v_ctx_419, J.mul(0.5, v_H_424), J.mul((-0.03), v_H_424), J.mul(0.08, v_H_424), J.mc(env["N"], "seg", [v_g_421, 0.25, 0.6]), "rgba(200,190,170,.55)", 19.0, 4.0])
	var _t326 = env["T"]
	var _t328 = J.mul(0.3, v_H_424)
	var _t329 = J.mul((-1.0), v_H_424)
	var _t330 = J.mul(0.1, v_H_424)
	var _t327 = env["bump"]
	J.cl(_t326, null, [v_ctx_419, v_S_420, _t328, _t329, _t330, "哎喲！", "#ffe066", J.cl(_t327, null, [v_g_421, 0.15, 0.45])])

func _f91(this_, a: Array, env):
	var v_g_425 = null; var v_H_426 = null
	v_g_425 = J.arg(a, 0)
	v_H_426 = J.arg(a, 1)
	var _t332 = (-1.0)
	var _t331 = env["sw"]
	return {"armB": _t332, "head": (0.08 + J.mul(J.cl(_t331, null, [v_g_425, 4.0]), 0.03))}

func _f92(this_, a: Array, env):
	var v_ctx_427 = null; var v_S_428 = null; var v_g_429 = null; var v_m_430 = null; var v_f_431 = null; var v_H_432 = null
	v_ctx_427 = J.arg(a, 0)
	v_S_428 = J.arg(a, 1)
	v_g_429 = J.arg(a, 2)
	v_m_430 = J.arg(a, 3)
	v_f_431 = J.arg(a, 4)
	v_H_432 = J.arg(a, 5)
	var _t333 = env["at"]
	var _t335 = J.gp(J.cl(_t333, null, [v_S_428, v_m_430, 0.4, 0.05]), 0.0)
	var _t334 = env["at"]
	return J.mc(env["N"], "stars", [v_ctx_427, _t335, J.gp(J.cl(_t334, null, [v_S_428, v_m_430, 0.4, 0.05]), 1.0), J.mul(0.12, v_H_432), J.mul(v_g_429, 3.0), 0.9])

func _f93(this_, a: Array, env):
	var v_g_433 = null; var v_H_434 = null; var v_k_435 = null
	v_g_433 = J.arg(a, 0)
	v_H_434 = J.arg(a, 1)
	var _t336 = env["bump"]
	v_k_435 = J.cl(_t336, null, [v_g_433, 0.1, 0.9])
	return {"sy": (1.0 + J.mul(0.1, v_k_435)), "sx": (1.0 + J.mul(0.05, v_k_435)), "hairL": J.mul(0.2, v_k_435), "hairR": J.mul(0.2, v_k_435)}

func _f94(this_, a: Array, env):
	var v_ctx_436 = null; var v_S_437 = null; var v_g_438 = null; var v_m_439 = null; var v_f_440 = null; var v_H_441 = null; var v_gr_442 = null
	v_ctx_436 = J.arg(a, 0)
	v_S_437 = J.arg(a, 1)
	v_g_438 = J.arg(a, 2)
	v_m_439 = J.arg(a, 3)
	v_f_440 = J.arg(a, 4)
	v_H_441 = J.arg(a, 5)
	v_gr_442 = J.mc(v_ctx_436, "createRadialGradient", [0.0, J.mul((-0.5), v_H_441), 0.0, 0.0, J.mul((-0.5), v_H_441), J.mul(0.7, v_H_441)])
	var _t337 = env["bump"]
	J.mc(v_gr_442, "addColorStop", [0.0, ("rgba(40,20,60," + J.str(J.mul(0.35, J.cl(_t337, null, [v_g_438, 0.1, 0.9]))) + ")")])
	J.mc(v_gr_442, "addColorStop", [1.0, "rgba(40,20,60,0)"])
	J.sp(v_ctx_436, "fillStyle", v_gr_442)
	J.mc(v_ctx_436, "fillRect", [J.mul((-0.8), v_H_441), J.mul((-1.3), v_H_441), J.mul(1.6, v_H_441), J.mul(1.4, v_H_441)])

func _f95(this_, a: Array, env):
	var v_g_443 = null; var v_H_444 = null
	v_g_443 = J.arg(a, 0)
	v_H_444 = J.arg(a, 1)
	var _t338 = env["sw"]
	var _t340 = J.mul(J.cl(_t338, null, [v_g_443, 2.0]), 0.15)
	var _t339 = env["sw"]
	return {"hairL": _t340, "hairR": J.mul(J.cl(_t339, null, [v_g_443, 2.0, 1.0]), 0.15)}

func _f96(this_, a: Array, env):
	var v_ctx_445 = null; var v_S_446 = null; var v_g_447 = null; var v_m_448 = null; var v_f_449 = null; var v_H_450 = null; var v_i_451 = null
	v_ctx_445 = J.arg(a, 0)
	v_S_446 = J.arg(a, 1)
	v_g_447 = J.arg(a, 2)
	v_m_448 = J.arg(a, 3)
	v_f_449 = J.arg(a, 4)
	v_H_450 = J.arg(a, 5)
	v_i_451 = 0.0
	while true:
		if not J.cmp(v_i_451, 4.0, "<"): break
		J.mc(env["N"], "puff", [v_ctx_445, J.mul((J.sub(v_i_451, 1.5) * 0.25), v_H_450), J.mul((-0.85), v_H_450), J.mul(0.08, v_H_450), J.mod(J.add(v_g_447, J.div(v_i_451, 4.0)), 1.0), "rgba(50,30,70,.45)", J.add(21.0, v_i_451), 3.0])
		v_i_451 = J.num(v_i_451) + 1.0

func _f97(this_, a: Array, env):
	var v_g_452 = null; var v_H_453 = null
	v_g_452 = J.arg(a, 0)
	v_H_453 = J.arg(a, 1)
	var _t342 = (-0.15)
	var _t341 = env["bump"]
	var _t345 = J.mul(_t342, J.cl(_t341, null, [v_g_452, 0.1, 0.5]))
	var _t344 = (-0.2)
	var _t343 = env["bump"]
	var _t347 = J.mul(_t344, J.cl(_t343, null, [v_g_452, 0.1, 0.5]))
	var _t346 = env["sw"]
	return {"tail1": _t345, "tail2": _t347, "head": J.mul(J.cl(_t346, null, [v_g_452, 1.5]), 0.15)}

func _f98(this_, a: Array, env):
	var v_g_454 = null; var v_H_455 = null; var v_u_456 = null
	v_g_454 = J.arg(a, 0)
	v_H_455 = J.arg(a, 1)
	var _t348 = env["sw"]
	v_u_456 = absf(J.num(J.cl(_t348, null, [v_g_454, 2.0])))
	var _t350 = J.mul(J.mul((-0.08), v_H_455), v_u_456)
	var _t351 = ((1.0 + J.mul(0.04, v_u_456)) - (0.06 if J.cmp(v_u_456, 0.15, "<") else 0.0))
	var _t349 = env["sw"]
	return {"y": _t350, "sy": _t351, "tail1": J.mul(J.cl(_t349, null, [v_g_454, 2.0]), 0.1)}

func _f99(this_, a: Array, env):
	var v_g_457 = null; var v_H_458 = null
	v_g_457 = J.arg(a, 0)
	v_H_458 = J.arg(a, 1)
	var _t352 = env["sw"]
	var _t354 = J.mul(J.cl(_t352, null, [v_g_457, 20.0]), 0.08)
	var _t353 = env["sw"]
	var _t356 = J.mul(J.cl(_t353, null, [v_g_457, 3.0]), 0.15)
	var _t355 = env["sw"]
	return {"cape": _t354, "hairL": _t356, "hairR": J.mul(J.cl(_t355, null, [v_g_457, 3.0, 1.0]), 0.15)}

func _f100(this_, a: Array, env):
	var v_ctx_459 = null; var v_S_460 = null; var v_g_461 = null; var v_m_462 = null; var v_f_463 = null; var v_H_464 = null
	v_ctx_459 = J.arg(a, 0)
	v_S_460 = J.arg(a, 1)
	v_g_461 = J.arg(a, 2)
	v_m_462 = J.arg(a, 3)
	v_f_463 = J.arg(a, 4)
	v_H_464 = J.arg(a, 5)
	var _t357 = env["T"]
	var _t359 = J.mul(0.1, v_H_464)
	var _t360 = J.mul((-1.1), v_H_464)
	var _t361 = J.mul(0.18, v_H_464)
	var _t358 = env["sw"]
	return J.cl(_t357, null, [v_ctx_459, v_S_460, _t359, _t360, _t361, "唧唧", "#d8e8a0", absf(J.num(J.cl(_t358, null, [v_g_461, 1.0])))])

func _f101(this_, a: Array, env):
	var v_g_465 = null; var v_H_466 = null; var v_k_467 = null
	v_g_465 = J.arg(a, 0)
	v_H_466 = J.arg(a, 1)
	var _t362 = env["env"]
	v_k_467 = J.cl(_t362, null, [v_g_465, 0.1, 0.3, 0.7, 0.9])
	var _t365 = J.mul(0.2, v_k_467)
	var _t366 = J.mul(0.5, v_k_467)
	var _t367 = J.mul(0.3, v_k_467)
	var _t364 = J.mul((-0.2), v_k_467)
	var _t363 = env["sw"]
	return {"head": _t365, "hairL": _t366, "hairR": _t367, "legF": (_t364 + J.mul(J.mul(J.cl(_t363, null, [v_g_465, 4.0]), 0.05), v_k_467))}

func _f102(this_, a: Array, env):
	var v_g_468 = null; var v_H_469 = null; var v_j_470 = null
	v_g_468 = J.arg(a, 0)
	v_H_469 = J.arg(a, 1)
	var _t368 = env["bump"]
	v_j_470 = J.cl(_t368, null, [v_g_468, 0.15, 0.6])
	var _t370 = J.mul(J.mul((-0.35), v_H_469), v_j_470)
	var _t371 = J.mul((-10.0), v_j_470)
	var _t372 = J.mul((-0.3), v_j_470)
	var _t369 = env["bump"]
	return {"y": _t370, "r": _t371, "legB": _t372, "sy": (1.0 - J.mul(0.12, J.cl(_t369, null, [v_g_468, 0.0, 0.15])))}

func _f103(this_, a: Array, env):
	var v_g_471 = null; var v_H_472 = null; var v_k_473 = null
	v_g_471 = J.arg(a, 0)
	v_H_472 = J.arg(a, 1)
	var _t373 = env["bump"]
	v_k_473 = J.cl(_t373, null, [v_g_471, 0.1, 0.6])
	return {"head": J.mul(0.2, v_k_473), "hairL": J.mul((-0.4), v_k_473), "hairR": J.mul((-0.4), v_k_473), "r": J.mul(4.0, v_k_473)}

func _f104(this_, a: Array, env):
	var v_g_474 = null; var v_H_475 = null
	v_g_474 = J.arg(a, 0)
	v_H_475 = J.arg(a, 1)
	var _t375 = (-0.1)
	var _t376 = (-0.3)
	var _t374 = env["sw"]
	return {"sy": 0.95, "head": _t375, "armF": _t376, "armB": 0.3, "x": J.mul(J.mul(J.cl(_t374, null, [v_g_474, 10.0]), 0.005), v_H_475)}

func _f105(this_, a: Array, env):
	var v_ctx_476 = null; var v_S_477 = null; var v_g_478 = null; var v_m_479 = null; var v_f_480 = null; var v_H_481 = null
	v_ctx_476 = J.arg(a, 0)
	v_S_477 = J.arg(a, 1)
	v_g_478 = J.arg(a, 2)
	v_m_479 = J.arg(a, 3)
	v_f_480 = J.arg(a, 4)
	v_H_481 = J.arg(a, 5)
	var _t377 = env["T"]
	var _t379 = J.mul(0.25, v_H_481)
	var _t380 = J.mul((-0.95), v_H_481)
	var _t381 = J.mul(0.1, v_H_481)
	var _t378 = env["bump"]
	return J.cl(_t377, null, [v_ctx_476, v_S_477, _t379, _t380, _t381, "嘶——", "#d8c8b8", J.cl(_t378, null, [v_g_478, 0.1, 0.9])])

func _f106(this_, a: Array, env):
	var v_g_482 = null; var v_H_483 = null
	v_g_482 = J.arg(a, 0)
	v_H_483 = J.arg(a, 1)
	var _t383 = (-0.9)
	var _t382 = env["sw"]
	return {"armB": _t383, "head": J.mul(J.cl(_t382, null, [v_g_482, 1.0]), 0.12), "body": 0.05}

func _f107(this_, a: Array, env):
	var v_g_484 = null; var v_H_485 = null; var v_k_486 = null
	v_g_484 = J.arg(a, 0)
	v_H_485 = J.arg(a, 1)
	var _t384 = env["env"]
	v_k_486 = J.cl(_t384, null, [v_g_484, 0.1, 0.4, 0.6, 0.9])
	return {"sy": (1.0 + J.mul(0.06, v_k_486)), "armF": J.mul((-0.7), v_k_486), "armB": J.mul(0.7, v_k_486), "head": J.mul((-0.15), v_k_486)}

func _f108(this_, a: Array, env):
	var v_g_487 = null; var v_H_488 = null
	v_g_487 = J.arg(a, 0)
	v_H_488 = J.arg(a, 1)
	var _t385 = env["sw"]
	var _t387 = J.mul(J.mul(J.cl(_t385, null, [v_g_487, 14.0]), 0.008), v_H_488)
	var _t386 = env["sw"]
	var _t389 = J.mul(J.cl(_t386, null, [v_g_487, 11.0]), 0.05)
	var _t388 = env["sw"]
	var _t391 = J.mul(J.cl(_t388, null, [v_g_487, 9.0]), 0.08)
	var _t390 = env["sw"]
	return {"x": _t387, "head": _t389, "armF": _t391, "armB": J.mul(J.cl(_t390, null, [v_g_487, 10.0]), 0.08)}

func _f109(this_, a: Array, env):
	var v_ctx_489 = null; var v_S_490 = null; var v_g_491 = null; var v_m_492 = null; var v_f_493 = null; var v_H_494 = null
	v_ctx_489 = J.arg(a, 0)
	v_S_490 = J.arg(a, 1)
	v_g_491 = J.arg(a, 2)
	v_m_492 = J.arg(a, 3)
	v_f_493 = J.arg(a, 4)
	v_H_494 = J.arg(a, 5)
	var _t392 = env["T"]
	var _t394 = J.mul(0.25, v_H_494)
	var _t395 = J.mul((-1.0), v_H_494)
	var _t396 = J.mul(0.09, v_H_494)
	var _t393 = env["sw"]
	return J.cl(_t392, null, [v_ctx_489, v_S_490, _t394, _t395, _t396, "喀喀", "#f6efd8", absf(J.num(J.cl(_t393, null, [v_g_491, 1.0])))])

func _f110(this_, a: Array, env):
	var v_g_495 = null; var v_H_496 = null
	v_g_495 = J.arg(a, 0)
	v_H_496 = J.arg(a, 1)
	var _t397 = env["sw"]
	var _t399 = J.mul(J.cl(_t397, null, [v_g_495, 2.0]), 6.0)
	var _t398 = env["sw"]
	var _t401 = J.mul(J.cl(_t398, null, [v_g_495, 2.0]), 0.5)
	var _t400 = env["sw"]
	var _t403 = ((-J.num(J.cl(_t400, null, [v_g_495, 2.0]))) * 0.5)
	var _t402 = env["sw"]
	var _t405 = J.mul(J.cl(_t402, null, [v_g_495, 2.0]), 0.2)
	var _t404 = env["sw"]
	var _t407 = ((-J.num(J.cl(_t404, null, [v_g_495, 2.0]))) * 0.2)
	var _t406 = env["sw"]
	return {"r": _t399, "px": 0.0, "py": 0.0, "armF": _t401, "armB": _t403, "legF": _t405, "legB": _t407, "y": J.mul(((-absf(J.num(J.cl(_t406, null, [v_g_495, 4.0])))) * 0.03), v_H_496)}

func _f111(this_, a: Array, env):
	var v_ctx_497 = null; var v_S_498 = null; var v_g_499 = null; var v_m_500 = null; var v_f_501 = null; var v_H_502 = null
	v_ctx_497 = J.arg(a, 0)
	v_S_498 = J.arg(a, 1)
	v_g_499 = J.arg(a, 2)
	v_m_500 = J.arg(a, 3)
	v_f_501 = J.arg(a, 4)
	v_H_502 = J.arg(a, 5)
	var _t408 = env["note"]
	return J.cl(_t408, null, [v_ctx_497, v_S_498, [J.mul(0.2, v_H_502), J.mul((-0.9), v_H_502)], v_g_499, 0.0, 0.9, v_H_502, "#f6efd8"])

func _f112(this_, a: Array, env):
	var v_g_503 = null; var v_H_504 = null
	v_g_503 = J.arg(a, 0)
	v_H_504 = J.arg(a, 1)
	var _t411 = (-0.5)
	var _t409 = env["sw"]
	var _t410 = env["sw"]
	var _t414 = (_t411 - (J.max_([0.0, J.cl(_t410, null, [v_g_503, 3.0])]) * 0.4))
	var _t412 = env["sw"]
	var _t413 = env["sw"]
	return {"armF": _t414, "armB": (0.5 + (J.max_([0.0, (-J.num(J.cl(_t413, null, [v_g_503, 3.0])))]) * 0.4)), "head": (-0.1)}

func _f113(this_, a: Array, env):
	var v_ctx_505 = null; var v_S_506 = null; var v_g_507 = null; var v_m_508 = null; var v_f_509 = null; var v_H_510 = null
	v_ctx_505 = J.arg(a, 0)
	v_S_506 = J.arg(a, 1)
	v_g_507 = J.arg(a, 2)
	v_m_508 = J.arg(a, 3)
	v_f_509 = J.arg(a, 4)
	v_H_510 = J.arg(a, 5)
	var _t415 = env["T"]
	var _t417 = J.mul(0.3, v_H_510)
	var _t418 = J.mul((-1.05), v_H_510)
	var _t419 = J.mul(0.1, v_H_510)
	var _t416 = env["sw"]
	return J.cl(_t415, null, [v_ctx_505, v_S_506, _t417, _t418, _t419, "咚咚", "#ffcf80", absf(J.num(J.cl(_t416, null, [v_g_507, 3.0])))])

func _f114(this_, a: Array, env):
	var v_g_511 = null; var v_H_512 = null
	v_g_511 = J.arg(a, 0)
	v_H_512 = J.arg(a, 1)
	var _t421 = (-0.2)
	var _t420 = env["sw"]
	return {"armF": (_t421 + (J.mul(J.cl(_t420, null, [v_g_511, 6.0]), 0.1) * (1.0 if J.cmp(v_g_511, 0.7, "<") else 0.0))), "body": 0.08, "head": 0.15}

func _f115(this_, a: Array, env):
	var v_ctx_513 = null; var v_S_514 = null; var v_g_515 = null; var v_m_516 = null; var v_f_517 = null; var v_H_518 = null; var v_q_519 = null
	v_ctx_513 = J.arg(a, 0)
	v_S_514 = J.arg(a, 1)
	v_g_515 = J.arg(a, 2)
	v_m_516 = J.arg(a, 3)
	v_f_517 = J.arg(a, 4)
	v_H_518 = J.arg(a, 5)
	if J.cmp(v_g_515, 0.7, ">"):
		v_q_519 = J.div(J.sub(v_g_515, 0.7), 0.3)
		J.sp(v_ctx_513, "fillStyle", "#2a1a10")
		J.mc(v_ctx_513, "beginPath", [])
		J.mc(v_ctx_513, "arc", [(J.mul(0.2, v_H_518) + J.mul(J.mul(v_q_519, 0.3), v_H_518)), (J.mul((-0.5), v_H_518) - J.mul((sin(J.num(J.mul(v_q_519, env["PI"]))) * 0.2), v_H_518)), J.mul(0.008, v_H_518), 0.0, 7.0])
		J.mc(v_ctx_513, "fill", [])

func _f116(this_, a: Array, env):
	var v_g_520 = null; var v_H_521 = null
	v_g_520 = J.arg(a, 0)
	v_H_521 = J.arg(a, 1)
	return {"a": (0.35 + (0.65 * (0.5 + (0.5 * cos(J.num(J.mul(v_g_520, env["TAU"])))))))}

func _f117(this_, a: Array, env):
	var v_ctx_522 = null; var v_S_523 = null; var v_g_524 = null; var v_m_525 = null; var v_f_526 = null; var v_H_527 = null; var v_i_528 = null; var v_q_529 = null
	v_ctx_522 = J.arg(a, 0)
	v_S_523 = J.arg(a, 1)
	v_g_524 = J.arg(a, 2)
	v_m_525 = J.arg(a, 3)
	v_f_526 = J.arg(a, 4)
	v_H_527 = J.arg(a, 5)
	v_i_528 = 0.0
	while true:
		if not J.cmp(v_i_528, 6.0, "<"): break
		v_q_529 = J.mod(J.add(v_g_524, J.div(v_i_528, 6.0)), 1.0)
		J.mc(v_ctx_522, "save", [])
		var _t422 = J.mul(J.gp(v_ctx_522, "globalAlpha"), sin(J.num(J.mul(v_q_529, env["PI"]))))
		J.sp(v_ctx_522, "globalAlpha", _t422)
		J.sp(v_ctx_522, "fillStyle", "#ffe28a")
		J.mc(v_ctx_522, "beginPath", [])
		J.mc(v_ctx_522, "arc", [J.mul((J.sub(J.mc(env["N"], "rnd", [v_i_528]), 0.5) * 0.6), v_H_527), (J.mul((-0.2), v_H_527) - J.mul(J.mul(v_q_529, 0.8), v_H_527)), J.mul(0.012, v_H_527), 0.0, 7.0])
		J.mc(v_ctx_522, "fill", [])
		J.mc(v_ctx_522, "restore", [])
		v_i_528 = J.num(v_i_528) + 1.0

func _f118(this_, a: Array, env):
	var v_g_530 = null; var v_H_531 = null; var v_k_532 = null
	v_g_530 = J.arg(a, 0)
	v_H_531 = J.arg(a, 1)
	var _t423 = env["env"]
	v_k_532 = J.cl(_t423, null, [v_g_530, 0.1, 0.35, 0.65, 0.9])
	return {"head": J.mul(0.15, v_k_532), "armB": J.mul((-0.4), v_k_532), "hairL": J.mul(0.1, v_k_532)}

func _f119(this_, a: Array, env):
	var v_ctx_533 = null; var v_S_534 = null; var v_g_535 = null; var v_m_536 = null; var v_f_537 = null; var v_H_538 = null
	v_ctx_533 = J.arg(a, 0)
	v_S_534 = J.arg(a, 1)
	v_g_535 = J.arg(a, 2)
	v_m_536 = J.arg(a, 3)
	v_f_537 = J.arg(a, 4)
	v_H_538 = J.arg(a, 5)
	var _t424 = env["T"]
	var _t426 = J.mul(0.1, v_H_538)
	var _t427 = J.mul((-1.08), v_H_538)
	var _t428 = J.mul(0.08, v_H_538)
	var _t425 = env["bump"]
	return J.cl(_t424, null, [v_ctx_533, v_S_534, _t426, _t427, _t428, "～♪", "#ffe28a", J.cl(_t425, null, [v_g_535, 0.3, 0.8])])

func _f120(this_, a: Array, env):
	var v_g_539 = null; var v_H_540 = null; var v_k_541 = null
	v_g_539 = J.arg(a, 0)
	v_H_540 = J.arg(a, 1)
	var _t429 = env["env"]
	v_k_541 = J.cl(_t429, null, [v_g_539, 0.1, 0.35, 0.6, 0.85])
	return {"armF": J.mul(0.7, v_k_541), "head": J.mul((-0.1), v_k_541)}

func _f121(this_, a: Array, env):
	var v_g_542 = null; var v_H_543 = null
	v_g_542 = J.arg(a, 0)
	v_H_543 = J.arg(a, 1)
	var _t430 = env["sw"]
	var _t432 = J.mul(J.cl(_t430, null, [v_g_542]), 3.0)
	var _t431 = env["sw"]
	var _t434 = J.mul(J.cl(_t431, null, [v_g_542, 1.0, 0.5]), 0.08)
	var _t433 = env["sw"]
	return {"r": _t432, "px": 0.0, "py": 0.0, "head": _t434, "hairL": J.mul(J.cl(_t433, null, [v_g_542, 1.0]), 0.06)}

func _f122(this_, a: Array, env):
	var v_ctx_544 = null; var v_S_545 = null; var v_g_546 = null; var v_m_547 = null; var v_f_548 = null; var v_H_549 = null; var v_p_550 = null
	v_ctx_544 = J.arg(a, 0)
	v_S_545 = J.arg(a, 1)
	v_g_546 = J.arg(a, 2)
	v_m_547 = J.arg(a, 3)
	v_f_548 = J.arg(a, 4)
	v_H_549 = J.arg(a, 5)
	var _t435 = env["at"]
	v_p_550 = J.cl(_t435, null, [v_S_545, v_m_547, 0.6, 0.27])
	var _t436 = env["note"]
	J.cl(_t436, null, [v_ctx_544, v_S_545, v_p_550, v_g_546, 0.0, 0.5, v_H_549, "#e8d0ff"])
	var _t437 = env["note"]
	J.cl(_t437, null, [v_ctx_544, v_S_545, v_p_550, v_g_546, 0.5, 1.0, v_H_549, "#e8d0ff"])

func _f123(this_, a: Array, env):
	var v_g_551 = null; var v_H_552 = null
	v_g_551 = J.arg(a, 0)
	v_H_552 = J.arg(a, 1)
	var _t439 = (-0.08)
	var _t438 = env["sw"]
	return {"head": (_t439 + J.mul(J.cl(_t438, null, [v_g_551, 1.0]), 0.04))}

func _f124(this_, a: Array, env):
	var v_ctx_553 = null; var v_S_554 = null; var v_g_555 = null; var v_m_556 = null; var v_f_557 = null; var v_H_558 = null
	v_ctx_553 = J.arg(a, 0)
	v_S_554 = J.arg(a, 1)
	v_g_555 = J.arg(a, 2)
	v_m_556 = J.arg(a, 3)
	v_f_557 = J.arg(a, 4)
	v_H_558 = J.arg(a, 5)
	var _t440 = env["T"]
	var _t442 = J.mul(0.15, v_H_558)
	var _t443 = J.mul((-1.05), v_H_558)
	var _t444 = J.mul(0.09, v_H_558)
	var _t441 = env["bump"]
	return J.cl(_t440, null, [v_ctx_553, v_S_554, _t442, _t443, _t444, "Mak……", "#e8d0ff", J.cl(_t441, null, [v_g_555, 0.3, 0.9])])

func _f125(this_, a: Array, env):
	var v_g_559 = null; var v_H_560 = null; var v_k_561 = null
	v_g_559 = J.arg(a, 0)
	v_H_560 = J.arg(a, 1)
	var _t445 = env["bump"]
	v_k_561 = J.cl(_t445, null, [v_g_559, 0.1, 0.7])
	var _t447 = J.mul((-0.25), v_k_561)
	var _t448 = (1.0 + J.mul(0.05, v_k_561))
	var _t449 = J.mul((-0.3), v_k_561)
	var _t450 = J.mul(0.3, v_k_561)
	var _t446 = env["sw"]
	return {"head": _t447, "sy": _t448, "armF": _t449, "armB": _t450, "tie": J.mul(J.cl(_t446, null, [v_g_559, 2.0]), 0.2)}

func _f126(this_, a: Array, env):
	var v_ctx_562 = null; var v_S_563 = null; var v_g_564 = null; var v_m_565 = null; var v_f_566 = null; var v_H_567 = null
	v_ctx_562 = J.arg(a, 0)
	v_S_563 = J.arg(a, 1)
	v_g_564 = J.arg(a, 2)
	v_m_565 = J.arg(a, 3)
	v_f_566 = J.arg(a, 4)
	v_H_567 = J.arg(a, 5)
	var _t451 = env["T"]
	var _t453 = J.mul(0.3, v_H_567)
	var _t454 = J.mul((-0.95), v_H_567)
	var _t455 = J.mul(0.1, v_H_567)
	var _t452 = env["bump"]
	return J.cl(_t451, null, [v_ctx_562, v_S_563, _t453, _t454, _t455, "呵～", "#ffd8f0", J.cl(_t452, null, [v_g_564, 0.2, 0.7])])

func _f127(this_, a: Array, env):
	var v_g_568 = null; var v_H_569 = null
	v_g_568 = J.arg(a, 0)
	v_H_569 = J.arg(a, 1)
	var _t458 = null
	if J.cmp(v_g_568, 0.8, "<"):
		_t458 = J.mul(0.25, J.mc(env["N"], "seg", [v_g_568, 0.0, 0.7]))
	else:
		var _t457 = (-0.15)
		var _t456 = env["bump"]
		_t458 = J.mul(_t457, J.cl(_t456, null, [v_g_568, 0.8, 1.0]))
	var _t461 = null
	if J.cmp(v_g_568, 0.8, ">"):
		var _t460 = J.mul((-0.05), v_H_569)
		var _t459 = env["bump"]
		_t461 = J.mul(_t460, J.cl(_t459, null, [v_g_568, 0.8, 0.95]))
	else:
		_t461 = 0.0
	return {"head": _t458, "y": _t461}

func _f128(this_, a: Array, env):
	var v_ctx_570 = null; var v_S_571 = null; var v_g_572 = null; var v_m_573 = null; var v_f_574 = null; var v_H_575 = null
	v_ctx_570 = J.arg(a, 0)
	v_S_571 = J.arg(a, 1)
	v_g_572 = J.arg(a, 2)
	v_m_573 = J.arg(a, 3)
	v_f_574 = J.arg(a, 4)
	v_H_575 = J.arg(a, 5)
	if J.cmp(v_g_572, 0.8, "<"):
		var _t462 = env["zz"]
		J.cl(_t462, null, [v_ctx_570, v_S_571, [J.mul(0.15, v_H_575), J.mul((-0.85), v_H_575)], v_g_572, v_H_575])

func _f129(this_, a: Array, env):
	var v_g_576 = null; var v_H_577 = null; var v_k_578 = null
	v_g_576 = J.arg(a, 0)
	v_H_577 = J.arg(a, 1)
	var _t463 = env["bump"]
	v_k_578 = J.cl(_t463, null, [v_g_576, 0.1, 0.6])
	return {"armF": J.mul((-0.8), v_k_578), "hairL": J.mul((-0.3), v_k_578), "hairR": J.mul(0.2, v_k_578), "head": J.mul((-0.1), v_k_578)}

func _f130(this_, a: Array, env):
	var v_ctx_579 = null; var v_S_580 = null; var v_g_581 = null; var v_m_582 = null; var v_f_583 = null; var v_H_584 = null
	v_ctx_579 = J.arg(a, 0)
	v_S_580 = J.arg(a, 1)
	v_g_581 = J.arg(a, 2)
	v_m_582 = J.arg(a, 3)
	v_f_583 = J.arg(a, 4)
	v_H_584 = J.arg(a, 5)
	var _t464 = env["T"]
	var _t466 = J.mul(0.2, v_H_584)
	var _t467 = J.mul((-1.0), v_H_584)
	var _t468 = J.mul(0.07, v_H_584)
	var _t465 = env["bump"]
	return J.cl(_t464, null, [v_ctx_579, v_S_580, _t466, _t467, _t468, "叮", "#ffd27a", J.cl(_t465, null, [v_g_581, 0.3, 0.6])])

func _f131(this_, a: Array, env):
	var v_g_585 = null; var v_H_586 = null
	v_g_585 = J.arg(a, 0)
	v_H_586 = J.arg(a, 1)
	var _t469 = env["sw"]
	var _t472 = J.mul(J.cl(_t469, null, [v_g_585, 2.0]), 5.0)
	var _t471 = (-0.4)
	var _t470 = env["sw"]
	var _t474 = (_t471 + J.mul(J.cl(_t470, null, [v_g_585, 2.0]), 0.3))
	var _t473 = env["sw"]
	var _t476 = (0.4 + J.mul(J.cl(_t473, null, [v_g_585, 2.0]), 0.3))
	var _t475 = env["sw"]
	return {"r": _t472, "px": 0.0, "py": 0.0, "armF": _t474, "armB": _t476, "y": J.mul(((-absf(J.num(J.cl(_t475, null, [v_g_585, 4.0])))) * 0.02), v_H_586)}

func _f132(this_, a: Array, env):
	var v_ctx_587 = null; var v_S_588 = null; var v_g_589 = null; var v_m_590 = null; var v_f_591 = null; var v_H_592 = null
	v_ctx_587 = J.arg(a, 0)
	v_S_588 = J.arg(a, 1)
	v_g_589 = J.arg(a, 2)
	v_m_590 = J.arg(a, 3)
	v_f_591 = J.arg(a, 4)
	v_H_592 = J.arg(a, 5)
	var _t477 = env["note"]
	return J.cl(_t477, null, [v_ctx_587, v_S_588, [J.mul(0.2, v_H_592), J.mul((-0.9), v_H_592)], v_g_589, 0.0, 0.9, v_H_592, "#ffd27a"])

func _f133(this_, a: Array, env):
	var v_g_593 = null; var v_H_594 = null
	v_g_593 = J.arg(a, 0)
	v_H_594 = J.arg(a, 1)
	var _t478 = env["sw"]
	return {"head": (0.15 + (absf(J.num(J.cl(_t478, null, [v_g_593, 2.0]))) * 0.1)), "body": 0.05}

func _f134(this_, a: Array, env):
	var v_ctx_595 = null; var v_S_596 = null; var v_g_597 = null; var v_m_598 = null; var v_f_599 = null; var v_H_600 = null
	v_ctx_595 = J.arg(a, 0)
	v_S_596 = J.arg(a, 1)
	v_g_597 = J.arg(a, 2)
	v_m_598 = J.arg(a, 3)
	v_f_599 = J.arg(a, 4)
	v_H_600 = J.arg(a, 5)
	var _t479 = env["zz"]
	return J.cl(_t479, null, [v_ctx_595, v_S_596, [J.mul(0.1, v_H_600), J.mul((-0.9), v_H_600)], v_g_597, v_H_600])

func _f135(this_, a: Array, env):
	var v_g_601 = null; var v_H_602 = null
	v_g_601 = J.arg(a, 0)
	v_H_602 = J.arg(a, 1)
	var _t481 = (-0.8)
	var _t480 = env["env"]
	var _t483 = J.mul(_t481, J.cl(_t480, null, [v_g_601, 0.05, 0.2, 0.8, 0.95]))
	var _t482 = env["sw"]
	return {"armB": (_t483 + J.mul(J.cl(_t482, null, [v_g_601, 4.0]), 0.08)), "head": (-0.1)}

func _f136(this_, a: Array, env):
	var v_ctx_603 = null; var v_S_604 = null; var v_g_605 = null; var v_m_606 = null; var v_f_607 = null; var v_H_608 = null
	v_ctx_603 = J.arg(a, 0)
	v_S_604 = J.arg(a, 1)
	v_g_605 = J.arg(a, 2)
	v_m_606 = J.arg(a, 3)
	v_f_607 = J.arg(a, 4)
	v_H_608 = J.arg(a, 5)
	var _t484 = env["T"]
	var _t486 = J.mul(0.2, v_H_608)
	var _t487 = J.mul((-1.05), v_H_608)
	var _t488 = J.mul(0.09, v_H_608)
	var _t485 = env["bump"]
	return J.cl(_t484, null, [v_ctx_603, v_S_604, _t486, _t487, _t488, "估吓先？", "#d8ffc8", J.cl(_t485, null, [v_g_605, 0.1, 0.9])])

func _f137(this_, a: Array, env):
	var v_g_609 = null; var v_H_610 = null; var v_k_611 = null
	v_g_609 = J.arg(a, 0)
	v_H_610 = J.arg(a, 1)
	var _t489 = env["env"]
	v_k_611 = J.cl(_t489, null, [v_g_609, 0.1, 0.3, 0.6, 0.8])
	return {"armB": J.mul((-1.0), v_k_611), "head": J.mul((-0.08), v_k_611)}

func _f138(this_, a: Array, env):
	var v_ctx_612 = null; var v_S_613 = null; var v_g_614 = null; var v_m_615 = null; var v_f_616 = null; var v_H_617 = null; var v_p_618 = null; var v_q_619 = null
	v_ctx_612 = J.arg(a, 0)
	v_S_613 = J.arg(a, 1)
	v_g_614 = J.arg(a, 2)
	v_m_615 = J.arg(a, 3)
	v_f_616 = J.arg(a, 4)
	v_H_617 = J.arg(a, 5)
	var _t490 = env["at"]
	v_p_618 = J.cl(_t490, null, [v_S_613, v_m_615, 0.47, 0.04])
	var _t491 = J.cmp(v_g_614, 0.35, ">")
	if (J.cmp(v_g_614, 0.75, "<") if _t491 else _t491):
		v_q_619 = J.div(J.sub(v_g_614, 0.35), 0.4)
		J.mc(env["N"], "ring", [v_ctx_612, J.gp(v_p_618, 0.0), J.gp(v_p_618, 1.0), J.mul(J.mul(0.05, v_H_617), J.add(0.3, v_q_619)), J.mul(J.mul(0.015, v_H_617), J.add(0.3, v_q_619)), "rgba(150,210,255,.9)", J.mul(0.006, v_H_617), J.sub(1.0, v_q_619)])
		J.mc(env["N"], "drops", [v_ctx_612, J.gp(v_p_618, 0.0), J.sub(J.gp(v_p_618, 1.0), J.mul(0.05, v_H_617)), J.mul(0.15, v_H_617), v_q_619, "rgba(150,210,255,.9)", 23.0, 3.0])

func _f139(this_, a: Array, env):
	var v_g_620 = null; var v_H_621 = null
	v_g_620 = J.arg(a, 0)
	v_H_621 = J.arg(a, 1)
	var _t493 = (-0.35)
	var _t492 = env["sw"]
	var _t495 = (_t493 - (absf(J.num(J.cl(_t492, null, [v_g_620, 3.0]))) * 0.1))
	var _t494 = env["sw"]
	return {"armF": _t495, "head": (0.08 + J.mul(J.cl(_t494, null, [v_g_620, 6.0]), 0.03))}

func _f140(this_, a: Array, env):
	var v_ctx_622 = null; var v_S_623 = null; var v_g_624 = null; var v_m_625 = null; var v_f_626 = null; var v_H_627 = null
	v_ctx_622 = J.arg(a, 0)
	v_S_623 = J.arg(a, 1)
	v_g_624 = J.arg(a, 2)
	v_m_625 = J.arg(a, 3)
	v_f_626 = J.arg(a, 4)
	v_H_627 = J.arg(a, 5)
	var _t496 = env["T"]
	var _t498 = J.mul(0.25, v_H_627)
	var _t499 = J.mul((-1.0), v_H_627)
	var _t500 = J.mul(0.08, v_H_627)
	var _t497 = env["sw"]
	J.cl(_t496, null, [v_ctx_622, v_S_623, _t498, _t499, _t500, "喀嚓", "#c8f0a0", absf(J.num(J.cl(_t497, null, [v_g_624, 1.5])))])
	var _t501 = env["at"]
	var _t503 = J.gp(J.cl(_t501, null, [v_S_623, v_m_625, 0.25, 0.32]), 0.0)
	var _t502 = env["at"]
	J.mc(env["N"], "drops", [v_ctx_622, _t503, J.gp(J.cl(_t502, null, [v_S_623, v_m_625, 0.25, 0.32]), 1.0), J.mul(0.12, v_H_627), J.mod(J.mul(v_g_624, 3.0), 1.0), "#9ad070", 25.0, 3.0])

func _f141(this_, a: Array, env):
	var v_g_628 = null; var v_H_629 = null; var v_k_630 = null
	v_g_628 = J.arg(a, 0)
	v_H_629 = J.arg(a, 1)
	var _t504 = env["env"]
	v_k_630 = J.cl(_t504, null, [v_g_628, 0.1, 0.35, 0.65, 0.9])
	var _t507 = J.mul((-0.2), v_k_630)
	var _t506 = J.mul((-0.15), v_k_630)
	var _t505 = env["sw"]
	var _t509 = (_t506 + J.mul(J.mul(J.cl(_t505, null, [v_g_628, 2.0]), 0.12), v_k_630))
	var _t508 = env["sw"]
	return {"neck1": _t507, "neck2": _t509, "head": J.mul(J.mul(J.cl(_t508, null, [v_g_628, 2.0, 1.0]), 0.12), v_k_630)}

func _f142(this_, a: Array, env):
	var v_g_631 = null; var v_H_632 = null; var v_k_633 = null
	v_g_631 = J.arg(a, 0)
	v_H_632 = J.arg(a, 1)
	var _t510 = env["bump"]
	v_k_633 = J.cl(_t510, null, [v_g_631, 0.1, 0.7])
	return {"head": J.mul((-0.3), v_k_633), "neck2": J.mul(0.1, v_k_633), "armF": J.mul((-0.2), v_k_633)}

func _f143(this_, a: Array, env):
	var v_ctx_634 = null; var v_S_635 = null; var v_g_636 = null; var v_m_637 = null; var v_f_638 = null; var v_H_639 = null
	v_ctx_634 = J.arg(a, 0)
	v_S_635 = J.arg(a, 1)
	v_g_636 = J.arg(a, 2)
	v_m_637 = J.arg(a, 3)
	v_f_638 = J.arg(a, 4)
	v_H_639 = J.arg(a, 5)
	var _t511 = env["T"]
	var _t513 = J.mul((-0.2), v_H_639)
	var _t514 = J.mul((-1.05), v_H_639)
	var _t515 = J.mul(0.1, v_H_639)
	var _t512 = env["bump"]
	return J.cl(_t511, null, [v_ctx_634, v_S_635, _t513, _t514, _t515, "呵～", "#ffd0e0", J.cl(_t512, null, [v_g_636, 0.2, 0.7])])

func _f144(this_, a: Array, env):
	var v_g_640 = null; var v_H_641 = null
	v_g_640 = J.arg(a, 0)
	v_H_641 = J.arg(a, 1)
	var _t517 = (-0.2)
	var _t516 = env["sw"]
	return {"armF": (_t517 + (absf(J.num(J.cl(_t516, null, [v_g_640, 2.0]))) * 0.1)), "head": 0.05}

func _f145(this_, a: Array, env):
	var v_ctx_642 = null; var v_S_643 = null; var v_g_644 = null; var v_m_645 = null; var v_f_646 = null; var v_H_647 = null
	v_ctx_642 = J.arg(a, 0)
	v_S_643 = J.arg(a, 1)
	v_g_644 = J.arg(a, 2)
	v_m_645 = J.arg(a, 3)
	v_f_646 = J.arg(a, 4)
	v_H_647 = J.arg(a, 5)
	var _t518 = env["T"]
	var _t519 = env["at"]
	var _t521 = J.gp(J.cl(_t519, null, [v_S_643, v_m_645, 0.05, 0.25]), 0.0)
	var _t520 = env["at"]
	var _t523 = J.sub(J.gp(J.cl(_t520, null, [v_S_643, v_m_645, 0.05, 0.25]), 1.0), J.mul(0.08, v_H_647))
	var _t524 = J.mul(0.08, v_H_647)
	var _t522 = env["sw"]
	return J.cl(_t518, null, [v_ctx_642, v_S_643, _t521, _t523, _t524, "咔嚓", "#ffffff", absf(J.num(J.cl(_t522, null, [v_g_644, 2.0])))])

func _f146(this_, a: Array, env):
	var v_g_648 = null; var v_H_649 = null
	v_g_648 = J.arg(a, 0)
	v_H_649 = J.arg(a, 1)
	var _t526 = (-0.2)
	var _t525 = env["env"]
	var _t529 = J.mul(_t526, J.cl(_t525, null, [v_g_648, 0.1, 0.3, 0.75, 0.95]))
	var _t528 = (-3.0)
	var _t527 = env["env"]
	return {"head": _t529, "r": J.mul(_t528, J.cl(_t527, null, [v_g_648, 0.1, 0.3, 0.75, 0.95]))}

func _f147(this_, a: Array, env):
	var v_ctx_650 = null; var v_S_651 = null; var v_g_652 = null; var v_m_653 = null; var v_f_654 = null; var v_H_655 = null
	v_ctx_650 = J.arg(a, 0)
	v_S_651 = J.arg(a, 1)
	v_g_652 = J.arg(a, 2)
	v_m_653 = J.arg(a, 3)
	v_f_654 = J.arg(a, 4)
	v_H_655 = J.arg(a, 5)
	var _t530 = env["T"]
	var _t532 = J.mul(0.25, v_H_655)
	var _t533 = J.mul((-1.05), v_H_655)
	var _t534 = J.mul(0.09, v_H_655)
	var _t531 = env["bump"]
	return J.cl(_t530, null, [v_ctx_650, v_S_651, _t532, _t533, _t534, "我靚唔靚？", "#ffe0e0", J.cl(_t531, null, [v_g_652, 0.2, 0.95])])

func _f148(this_, a: Array, env):
	var v_g_656 = null; var v_H_657 = null
	v_g_656 = J.arg(a, 0)
	v_H_657 = J.arg(a, 1)
	var _t536 = (-0.5)
	var _t535 = env["env"]
	return {"armF": J.mul(_t536, J.cl(_t535, null, [v_g_656, 0.05, 0.2, 0.75, 0.9])), "head": 0.1}

func _f149(this_, a: Array, env):
	var v_ctx_658 = null; var v_S_659 = null; var v_g_660 = null; var v_m_661 = null; var v_f_662 = null; var v_H_663 = null; var v_p_664 = null; var v_q_665 = null
	v_ctx_658 = J.arg(a, 0)
	v_S_659 = J.arg(a, 1)
	v_g_660 = J.arg(a, 2)
	v_m_661 = J.arg(a, 3)
	v_f_662 = J.arg(a, 4)
	v_H_663 = J.arg(a, 5)
	var _t537 = env["at"]
	v_p_664 = J.cl(_t537, null, [v_S_659, v_m_661, 0.25, 0.45])
	v_q_665 = J.mc(env["N"], "seg", [v_g_660, 0.2, 0.9])
	var _t538 = J.cmp(v_q_665, 0.0, ">")
	if (J.cmp(v_q_665, 1.0, "<") if _t538 else _t538):
		var _t539 = env["flake"]
		J.cl(_t539, null, [v_ctx_658, J.add(J.gp(v_p_664, 0.0), J.mul(J.mul(v_q_665, 0.1), v_H_663)), (J.sub(J.gp(v_p_664, 1.0), J.mul(0.06, v_H_663)) - J.mul(J.mul(v_q_665, 0.3), v_H_663)), (J.mul(0.05, v_H_663) * J.min_([1.0, J.mul(v_q_665, 3.0)])), J.mul(v_q_665, 6.0), J.sub(1.0, J.mc(env["N"], "seg", [v_q_665, 0.7, 1.0]))])

func _f150(this_, a: Array, env):
	var v_g_666 = null; var v_H_667 = null
	v_g_666 = J.arg(a, 0)
	v_H_667 = J.arg(a, 1)
	var _t540 = env["bump"]
	var _t542 = J.mul(0.1, J.cl(_t540, null, [v_g_666, 0.2, 0.7]))
	var _t541 = env["bump"]
	return {"head": _t542, "sy": (1.0 + J.mul(0.02, J.cl(_t541, null, [v_g_666, 0.0, 0.2])))}

func _f151(this_, a: Array, env):
	var v_ctx_668 = null; var v_S_669 = null; var v_g_670 = null; var v_m_671 = null; var v_f_672 = null; var v_H_673 = null; var v_p_674 = null
	v_ctx_668 = J.arg(a, 0)
	v_S_669 = J.arg(a, 1)
	v_g_670 = J.arg(a, 2)
	v_m_671 = J.arg(a, 3)
	v_f_672 = J.arg(a, 4)
	v_H_673 = J.arg(a, 5)
	var _t543 = env["at"]
	v_p_674 = J.cl(_t543, null, [v_S_669, v_m_671, 0.42, 0.255])
	J.mc(env["N"], "puff", [v_ctx_668, J.add(J.gp(v_p_674, 0.0), J.mul(0.1, v_H_673)), J.gp(v_p_674, 1.0), J.mul(0.06, v_H_673), J.mc(env["N"], "seg", [v_g_670, 0.2, 0.9]), "rgba(220,240,255,.6)", 27.0, 4.0])

func _f152(this_, a: Array, env):
	var v_g_675 = null; var v_H_676 = null; var v_u_677 = null
	v_g_675 = J.arg(a, 0)
	v_H_676 = J.arg(a, 1)
	var _t544 = env["sw"]
	v_u_677 = absf(J.num(J.cl(_t544, null, [v_g_675, 2.0])))
	return {"y": J.mul(J.mul((-0.12), v_H_676), v_u_677), "sy": ((1.0 + J.mul(0.03, v_u_677)) - (0.07 if J.cmp(v_u_677, 0.15, "<") else 0.0)), "tie": J.mul(v_u_677, 0.3), "tongue": J.mul(v_u_677, 0.2)}

func _f153(this_, a: Array, env):
	var v_g_678 = null; var v_H_679 = null
	v_g_678 = J.arg(a, 0)
	v_H_679 = J.arg(a, 1)
	var _t545 = env["sw"]
	var _t547 = J.mul(J.cl(_t545, null, [v_g_678, 2.0]), 0.35)
	var _t546 = env["bump"]
	var _t549 = J.mul(_t547, J.cl(_t546, null, [v_g_678, 0.0, 1.0]))
	var _t548 = env["sw"]
	return {"tongue": _t549, "head": J.mul(J.cl(_t548, null, [v_g_678, 2.0, 1.0]), 0.04)}

func _f154(this_, a: Array, env):
	var v_g_680 = null; var v_H_681 = null; var v_c_682 = null
	v_g_680 = J.arg(a, 0)
	v_H_681 = J.arg(a, 1)
	v_c_682 = cos(J.num(J.mul(J.mc(env["N"], "seg", [v_g_680, 0.15, 0.75]), env["TAU"])))
	var _t551 = ((0.12 * signf(J.num((v_c_682 if J.t(v_c_682) else 1.0)))) if (absf(J.num(v_c_682)) < 0.12) else v_c_682)
	var _t550 = env["bump"]
	return {"sx": _t551, "tie": J.mul(0.3, J.cl(_t550, null, [v_g_680, 0.15, 0.75]))}

func _f155(this_, a: Array, env):
	var v_g_683 = null; var v_H_684 = null; var v_k_685 = null
	v_g_683 = J.arg(a, 0)
	v_H_684 = J.arg(a, 1)
	var _t552 = env["env"]
	v_k_685 = J.cl(_t552, null, [v_g_683, 0.05, 0.2, 0.75, 0.9])
	var _t555 = J.mul((-0.9), v_k_685)
	var _t556 = J.mul(0.12, v_k_685)
	var _t554 = J.mul((-0.01), v_H_684)
	var _t553 = env["sw"]
	return {"armB": _t555, "head": _t556, "y": J.mul((_t554 * absf(J.num(J.cl(_t553, null, [v_g_683, 4.0])))), v_k_685)}

func _f156(this_, a: Array, env):
	var v_ctx_686 = null; var v_S_687 = null; var v_g_688 = null; var v_m_689 = null; var v_f_690 = null; var v_H_691 = null
	v_ctx_686 = J.arg(a, 0)
	v_S_687 = J.arg(a, 1)
	v_g_688 = J.arg(a, 2)
	v_m_689 = J.arg(a, 3)
	v_f_690 = J.arg(a, 4)
	v_H_691 = J.arg(a, 5)
	var _t557 = env["T"]
	var _t559 = J.mul(0.25, v_H_691)
	var _t560 = J.mul((-1.05), v_H_691)
	var _t561 = J.mul(0.09, v_H_691)
	var _t558 = env["bump"]
	return J.cl(_t557, null, [v_ctx_686, v_S_687, _t559, _t560, _t561, "遲到喇！", "#e8e8ff", J.cl(_t558, null, [v_g_688, 0.3, 0.9])])

func _f157(this_, a: Array, env):
	var v_g_692 = null; var v_H_693 = null; var v_k_694 = null
	v_g_692 = J.arg(a, 0)
	v_H_693 = J.arg(a, 1)
	var _t562 = env["env"]
	v_k_694 = J.cl(_t562, null, [v_g_692, 0.1, 0.3, 0.7, 0.9])
	var _t564 = J.mul((-0.6), v_k_694)
	var _t563 = env["sw"]
	return {"armB": (_t564 + J.mul(J.mul(J.cl(_t563, null, [v_g_692, 4.0]), 0.05), v_k_694)), "head": J.mul((-0.08), v_k_694), "sy": (1.0 + J.mul(0.02, v_k_694))}

func _f158(this_, a: Array, env):
	var v_g_695 = null; var v_H_696 = null
	v_g_695 = J.arg(a, 0)
	v_H_696 = J.arg(a, 1)
	var _t565 = env["sw"]
	var _t567 = J.mul(J.cl(_t565, null, [v_g_695, 3.0]), 0.2)
	var _t566 = env["sw"]
	return {"flame": _t567, "sy": (1.0 + J.mul(J.cl(_t566, null, [v_g_695, 2.0]), 0.02))}

func _f159(this_, a: Array, env):
	var v_ctx_697 = null; var v_S_698 = null; var v_g_699 = null; var v_m_700 = null; var v_f_701 = null; var v_H_702 = null; var v_k_703 = null; var v_gr_704 = null
	v_ctx_697 = J.arg(a, 0)
	v_S_698 = J.arg(a, 1)
	v_g_699 = J.arg(a, 2)
	v_m_700 = J.arg(a, 3)
	v_f_701 = J.arg(a, 4)
	v_H_702 = J.arg(a, 5)
	var _t568 = env["sw"]
	v_k_703 = (0.5 + J.mul(0.5, J.cl(_t568, null, [v_g_699, 3.0])))
	v_gr_704 = J.mc(v_ctx_697, "createRadialGradient", [0.0, J.mul((-0.5), v_H_702), 0.0, 0.0, J.mul((-0.5), v_H_702), J.mul(0.5, v_H_702)])
	J.mc(v_gr_704, "addColorStop", [0.0, ("rgba(255,180,80," + J.str((0.25 + J.mul(0.2, v_k_703))) + ")")])
	J.mc(v_gr_704, "addColorStop", [1.0, "rgba(255,180,80,0)"])
	J.sp(v_ctx_697, "fillStyle", v_gr_704)
	J.mc(v_ctx_697, "fillRect", [J.mul((-0.5), v_H_702), J.mul((-1.0), v_H_702), v_H_702, v_H_702])

func _f160(this_, a: Array, env):
	var v_g_705 = null; var v_H_706 = null
	v_g_705 = J.arg(a, 0)
	v_H_706 = J.arg(a, 1)
	var _t569 = env["sw"]
	var _t571 = J.mul(J.cl(_t569, null, [v_g_705, 2.0]), 0.3)
	var _t570 = env["bump"]
	return {"tongue": _t571, "sx": (1.0 + J.mul(0.03, J.cl(_t570, null, [v_g_705, 0.0, 0.5])))}

func _f161(this_, a: Array, env):
	var v_g_707 = null; var v_H_708 = null
	v_g_707 = J.arg(a, 0)
	v_H_708 = J.arg(a, 1)
	var _t572 = env["sw"]
	var _t574 = J.mul(J.mul(J.cl(_t572, null, [v_g_707, 12.0]), 0.006), v_H_708)
	var _t573 = env["sw"]
	var _t576 = J.mul(J.cl(_t573, null, [v_g_707, 9.0]), 0.05)
	var _t575 = env["sw"]
	return {"x": _t574, "head": _t576, "armF": J.mul(J.cl(_t575, null, [v_g_707, 7.0]), 0.04)}

func _f162(this_, a: Array, env):
	var v_ctx_709 = null; var v_S_710 = null; var v_g_711 = null; var v_m_712 = null; var v_f_713 = null; var v_H_714 = null
	v_ctx_709 = J.arg(a, 0)
	v_S_710 = J.arg(a, 1)
	v_g_711 = J.arg(a, 2)
	v_m_712 = J.arg(a, 3)
	v_f_713 = J.arg(a, 4)
	v_H_714 = J.arg(a, 5)
	var _t577 = env["T"]
	var _t579 = J.mul(0.1, v_H_714)
	var _t580 = J.mul((-1.05), v_H_714)
	var _t581 = J.mul(0.1, v_H_714)
	var _t578 = env["sw"]
	return J.cl(_t577, null, [v_ctx_709, v_S_710, _t579, _t580, _t581, "喀喀喀", "#f6efd8", absf(J.num(J.cl(_t578, null, [v_g_711, 1.0])))])

func _f163(this_, a: Array, env):
	var v_g_715 = null; var v_H_716 = null
	v_g_715 = J.arg(a, 0)
	v_H_716 = J.arg(a, 1)
	var _t582 = env["sw"]
	var _t584 = J.mul(J.cl(_t582, null, [v_g_715, 1.0]), 0.15)
	var _t583 = env["sw"]
	return {"head": _t584, "body": J.mul(J.cl(_t583, null, [v_g_715, 1.0, 0.5]), 0.04)}

func _f164(this_, a: Array, env):
	var v_ctx_717 = null; var v_S_718 = null; var v_g_719 = null; var v_m_720 = null; var v_f_721 = null; var v_H_722 = null
	v_ctx_717 = J.arg(a, 0)
	v_S_718 = J.arg(a, 1)
	v_g_719 = J.arg(a, 2)
	v_m_720 = J.arg(a, 3)
	v_f_721 = J.arg(a, 4)
	v_H_722 = J.arg(a, 5)
	var _t585 = env["T"]
	var _t587 = J.mul((-0.1), v_H_722)
	var _t588 = J.mul((-1.05), v_H_722)
	var _t589 = J.mul(0.1, v_H_722)
	var _t586 = env["bump"]
	return J.cl(_t585, null, [v_ctx_717, v_S_718, _t587, _t588, _t589, "餓……", "#f6efd8", J.cl(_t586, null, [v_g_719, 0.3, 0.9])])

func _f165(this_, a: Array, env):
	var v_g_723 = null; var v_H_724 = null
	v_g_723 = J.arg(a, 0)
	v_H_724 = J.arg(a, 1)
	var _t591 = (-0.6)
	var _t590 = env["sw"]
	var _t593 = (_t591 + J.mul(J.cl(_t590, null, [v_g_723, 2.0]), 0.2))
	var _t592 = env["sw"]
	return {"armF": _t593, "hairL": J.mul(J.cl(_t592, null, [v_g_723, 2.0, 1.0]), 0.1), "head": 0.08}

func _f166(this_, a: Array, env):
	var v_g_725 = null; var v_H_726 = null
	v_g_725 = J.arg(a, 0)
	v_H_726 = J.arg(a, 1)
	var _t594 = env["sw"]
	var _t596 = (0.05 + (absf(J.num(J.cl(_t594, null, [v_g_725, 3.0]))) * 0.03))
	var _t595 = env["sw"]
	return {"head": 0.2, "body": _t596, "sy": (1.0 - (absf(J.num(J.cl(_t595, null, [v_g_725, 3.0]))) * 0.015))}

func _f167(this_, a: Array, env):
	var v_ctx_727 = null; var v_S_728 = null; var v_g_729 = null; var v_m_730 = null; var v_f_731 = null; var v_H_732 = null; var v_p_733 = null
	v_ctx_727 = J.arg(a, 0)
	v_S_728 = J.arg(a, 1)
	v_g_729 = J.arg(a, 2)
	v_m_730 = J.arg(a, 3)
	v_f_731 = J.arg(a, 4)
	v_H_732 = J.arg(a, 5)
	var _t597 = env["at"]
	v_p_733 = J.cl(_t597, null, [v_S_728, v_m_730, 0.5, 0.22])
	J.mc(env["N"], "drops", [v_ctx_727, J.gp(v_p_733, 0.0), J.gp(v_p_733, 1.0), J.mul(0.15, v_H_732), J.mod(J.mul(v_g_729, 2.0), 1.0), "rgba(180,210,255,.9)", 29.0, 2.0, 0.6])

func _f168(this_, a: Array, env):
	var v_g_734 = null; var v_H_735 = null
	v_g_734 = J.arg(a, 0)
	v_H_735 = J.arg(a, 1)
	var _t598 = env["sw"]
	return {"x": J.mul(J.mul(J.cl(_t598, null, [v_g_734, 16.0]), 0.006), v_H_735), "head": (-0.05), "armF": (-0.3), "armB": 0.3}

func _f169(this_, a: Array, env):
	var v_ctx_736 = null; var v_S_737 = null; var v_g_738 = null; var v_m_739 = null; var v_f_740 = null; var v_H_741 = null; var v_p_742 = null
	v_ctx_736 = J.arg(a, 0)
	v_S_737 = J.arg(a, 1)
	v_g_738 = J.arg(a, 2)
	v_m_739 = J.arg(a, 3)
	v_f_740 = J.arg(a, 4)
	v_H_741 = J.arg(a, 5)
	var _t599 = env["at"]
	v_p_742 = J.cl(_t599, null, [v_S_737, v_m_739, 0.42, 0.02])
	J.mc(env["N"], "puff", [v_ctx_736, J.gp(v_p_742, 0.0), J.gp(v_p_742, 1.0), J.mul(0.06, v_H_741), v_g_738, "rgba(240,240,240,.55)", 31.0, 3.0])
	J.mc(env["N"], "puff", [v_ctx_736, J.add(J.gp(v_p_742, 0.0), J.mul(0.05, v_H_741)), J.gp(v_p_742, 1.0), J.mul(0.05, v_H_741), J.mod(J.add(v_g_738, 0.5), 1.0), "rgba(240,240,240,.55)", 32.0, 3.0])

func _f170(this_, a: Array, env):
	var v_g_743 = null; var v_H_744 = null
	v_g_743 = J.arg(a, 0)
	v_H_744 = J.arg(a, 1)
	var _t601 = (-0.25)
	var _t600 = env["env"]
	var _t604 = J.mul(_t601, J.cl(_t600, null, [v_g_743, 0.1, 0.2, 0.7, 0.9]))
	var _t603 = (-3.0)
	var _t602 = env["env"]
	return {"head": _t604, "r": J.mul(_t603, J.cl(_t602, null, [v_g_743, 0.1, 0.2, 0.7, 0.9]))}

func _f171(this_, a: Array, env):
	var v_ctx_745 = null; var v_S_746 = null; var v_g_747 = null; var v_m_748 = null; var v_f_749 = null; var v_H_750 = null
	v_ctx_745 = J.arg(a, 0)
	v_S_746 = J.arg(a, 1)
	v_g_747 = J.arg(a, 2)
	v_m_748 = J.arg(a, 3)
	v_f_749 = J.arg(a, 4)
	v_H_750 = J.arg(a, 5)
	var _t605 = env["T"]
	var _t607 = J.mul((-0.2), v_H_750)
	var _t608 = J.mul((-1.05), v_H_750)
	var _t609 = J.mul(0.11, v_H_750)
	var _t606 = env["bump"]
	return J.cl(_t605, null, [v_ctx_745, v_S_746, _t607, _t608, _t609, "哼！", "#ff7070", J.cl(_t606, null, [v_g_747, 0.15, 0.75])])

func _f172(this_, a: Array, env):
	var v_g_751 = null; var v_H_752 = null
	v_g_751 = J.arg(a, 0)
	v_H_752 = J.arg(a, 1)
	var _t610 = env["sw"]
	var _t612 = J.mul(J.cl(_t610, null, [v_g_751, 4.0]), 0.35)
	var _t611 = env["sw"]
	return {"cape": _t612, "y": J.mul(((-absf(J.num(J.cl(_t611, null, [v_g_751, 4.0])))) * 0.015), v_H_752)}

func _f173(this_, a: Array, env):
	var v_g_753 = null; var v_H_754 = null
	v_g_753 = J.arg(a, 0)
	v_H_754 = J.arg(a, 1)
	var _t613 = env["sw"]
	return {"head": (0.15 + (absf(J.num(J.cl(_t613, null, [v_g_753, 4.0]))) * 0.06)), "body": 0.08, "r": 3.0}

func _f174(this_, a: Array, env):
	var v_ctx_755 = null; var v_S_756 = null; var v_g_757 = null; var v_m_758 = null; var v_f_759 = null; var v_H_760 = null; var v_p_761 = null; var v_i_762 = null
	v_ctx_755 = J.arg(a, 0)
	v_S_756 = J.arg(a, 1)
	v_g_757 = J.arg(a, 2)
	v_m_758 = J.arg(a, 3)
	v_f_759 = J.arg(a, 4)
	v_H_760 = J.arg(a, 5)
	var _t614 = env["at"]
	v_p_761 = J.cl(_t614, null, [v_S_756, v_m_758, 0.15, 0.25])
	v_i_762 = 0.0
	while true:
		if not J.cmp(v_i_762, 3.0, "<"): break
		var _t616 = [[J.add(J.add(J.gp(v_p_761, 0.0), J.mul(0.05, v_H_760)), J.mul(J.mul(v_i_762, 0.03), v_H_760)), J.sub(J.gp(v_p_761, 1.0), J.mul(0.03, v_H_760))], [J.add(J.add(J.gp(v_p_761, 0.0), J.mul(0.08, v_H_760)), J.mul(J.mul(v_i_762, 0.03), v_H_760)), J.add(J.gp(v_p_761, 1.0), J.mul(0.03, v_H_760))]]
		var _t617 = J.mul(0.01, v_H_760)
		var _t618 = J.add(33.0, v_i_762)
		var _t615 = env["sw"]
		J.mc(env["N"], "crayon", [v_ctx_755, _t616, "rgba(220,220,230,.7)", _t617, _t618, absf(J.num(J.cl(_t615, null, [v_g_757, 4.0])))])
		v_i_762 = J.num(v_i_762) + 1.0

func _f175(this_, a: Array, env):
	var v_g_763 = null; var v_H_764 = null
	v_g_763 = J.arg(a, 0)
	v_H_764 = J.arg(a, 1)
	var _t620 = (-0.1)
	var _t619 = env["bump"]
	var _t622 = J.mul(_t620, J.cl(_t619, null, [v_g_763, 0.1, 0.4]))
	var _t621 = env["bump"]
	return {"head": _t622, "sy": (1.0 + J.mul(0.02, J.cl(_t621, null, [v_g_763, 0.1, 0.4])))}

func _f176(this_, a: Array, env):
	var v_ctx_765 = null; var v_S_766 = null; var v_g_767 = null; var v_m_768 = null; var v_f_769 = null; var v_H_770 = null; var v_p_771 = null
	v_ctx_765 = J.arg(a, 0)
	v_S_766 = J.arg(a, 1)
	v_g_767 = J.arg(a, 2)
	v_m_768 = J.arg(a, 3)
	v_f_769 = J.arg(a, 4)
	v_H_770 = J.arg(a, 5)
	var _t623 = env["at"]
	v_p_771 = J.cl(_t623, null, [v_S_766, v_m_768, 0.08, 0.27])
	J.mc(env["N"], "puff", [v_ctx_765, J.gp(v_p_771, 0.0), J.gp(v_p_771, 1.0), J.mul(0.06, v_H_770), J.mc(env["N"], "seg", [v_g_767, 0.45, 1.0]), "rgba(210,210,220,.6)", 35.0, 4.0])

func _f177(this_, a: Array, env):
	var v_g_772 = null; var v_H_773 = null
	v_g_772 = J.arg(a, 0)
	v_H_773 = J.arg(a, 1)
	var _t626 = (-0.25)
	var _t624 = env["sw"]
	var _t625 = env["sw"]
	return {"legF": (_t626 * J.max_([0.0, J.cl(_t625, null, [v_g_772, 2.0])])), "head": 0.05}

func _f178(this_, a: Array, env):
	var v_ctx_774 = null; var v_S_775 = null; var v_g_776 = null; var v_m_777 = null; var v_f_778 = null; var v_H_779 = null
	v_ctx_774 = J.arg(a, 0)
	v_S_775 = J.arg(a, 1)
	v_g_776 = J.arg(a, 2)
	v_m_777 = J.arg(a, 3)
	v_f_778 = J.arg(a, 4)
	v_H_779 = J.arg(a, 5)
	return J.mc(env["N"], "puff", [v_ctx_774, J.mul(0.15, v_H_779), J.mul((-0.02), v_H_779), J.mul(0.05, v_H_779), J.mod(J.mul(v_g_776, 2.0), 1.0), "rgba(190,170,150,.55)", 37.0, 3.0])

func _f179(this_, a: Array, env):
	var v_g_780 = null; var v_H_781 = null; var v_k_782 = null
	v_g_780 = J.arg(a, 0)
	v_H_781 = J.arg(a, 1)
	var _t627 = env["bump"]
	v_k_782 = J.cl(_t627, null, [v_g_780, 0.1, 0.6])
	var _t628 = env["sw"]
	return {"head": J.mul(J.mul(J.cl(_t628, null, [v_g_780, 2.0]), 0.15), v_k_782), "hairL": J.mul((-0.3), v_k_782), "hairR": J.mul((-0.3), v_k_782), "cape": J.mul(0.3, v_k_782)}

func _f180(this_, a: Array, env):
	var v_g_783 = null; var v_H_784 = null
	v_g_783 = J.arg(a, 0)
	v_H_784 = J.arg(a, 1)
	var _t630 = (-0.35)
	var _t629 = env["env"]
	var _t635 = J.mul(_t630, J.cl(_t629, null, [v_g_783, 0.05, 0.2, 0.8, 0.95]))
	var _t632 = (-0.1)
	var _t631 = env["env"]
	var _t634 = J.mul(_t632, J.cl(_t631, null, [v_g_783, 0.05, 0.2, 0.8, 0.95]))
	var _t633 = env["sw"]
	return {"armF": _t635, "head": (_t634 + J.mul(J.cl(_t633, null, [v_g_783, 2.0]), 0.04))}

func _f181(this_, a: Array, env):
	var v_g_785 = null; var v_H_786 = null
	v_g_785 = J.arg(a, 0)
	v_H_786 = J.arg(a, 1)
	var _t637 = (-0.45)
	var _t636 = env["sw"]
	var _t639 = (_t637 + J.mul(J.cl(_t636, null, [v_g_785, 6.0]), 0.05))
	var _t640 = (-0.35)
	var _t638 = env["sw"]
	return {"armF": _t639, "armB": _t640, "r": 3.0, "px": 0.0, "py": 0.0, "x": J.mul(J.mul(J.cl(_t638, null, [v_g_785, 30.0]), 0.004), v_H_786)}

func _f182(this_, a: Array, env):
	var v_ctx_787 = null; var v_S_788 = null; var v_g_789 = null; var v_m_790 = null; var v_f_791 = null; var v_H_792 = null
	v_ctx_787 = J.arg(a, 0)
	v_S_788 = J.arg(a, 1)
	v_g_789 = J.arg(a, 2)
	v_m_790 = J.arg(a, 3)
	v_f_791 = J.arg(a, 4)
	v_H_792 = J.arg(a, 5)
	J.mc(env["N"], "puff", [v_ctx_787, J.mul((-0.3), v_H_792), J.mul((-0.2), v_H_792), J.mul(0.06, v_H_792), J.mod(J.mul(v_g_789, 2.0), 1.0), "rgba(70,64,70,.5)", 41.0, 3.0])
	var _t641 = env["T"]
	var _t643 = J.mul(0.25, v_H_792)
	var _t644 = J.mul((-1.05), v_H_792)
	var _t645 = J.mul(0.09, v_H_792)
	var _t642 = env["bump"]
	J.cl(_t641, null, [v_ctx_787, v_S_788, _t643, _t644, _t645, "嗚嗚～", "#ffe066", J.cl(_t642, null, [v_g_789, 0.2, 0.9])])

func _f183(this_, a: Array, env):
	var v_g_793 = null; var v_H_794 = null; var v_j_795 = null
	v_g_793 = J.arg(a, 0)
	v_H_794 = J.arg(a, 1)
	var _t646 = J.cmp(v_g_793, 0.3, ">")
	v_j_795 = (sin(J.num(J.mul(v_g_793, 300.0))) if (J.cmp(v_g_793, 0.45, "<") if _t646 else _t646) else 0.0)
	var _t648 = J.mul(J.mul(v_j_795, 0.01), v_H_794)
	var _t647 = env["bump"]
	var _t650 = J.mul(0.2, J.cl(_t647, null, [v_g_793, 0.3, 0.6]))
	var _t649 = env["bump"]
	return {"x": _t648, "hairL": _t650, "hairR": J.mul(0.2, J.cl(_t649, null, [v_g_793, 0.3, 0.6])), "head": J.mul(v_j_795, 0.08)}

func _f184(this_, a: Array, env):
	var v_ctx_796 = null; var v_S_797 = null; var v_g_798 = null; var v_m_799 = null; var v_f_800 = null; var v_H_801 = null; var v_p_802 = null; var v_i_803 = null
	v_ctx_796 = J.arg(a, 0)
	v_S_797 = J.arg(a, 1)
	v_g_798 = J.arg(a, 2)
	v_m_799 = J.arg(a, 3)
	v_f_800 = J.arg(a, 4)
	v_H_801 = J.arg(a, 5)
	var _t651 = env["at"]
	v_p_802 = J.cl(_t651, null, [v_S_797, v_m_799, 0.14, 0.32])
	var _t652 = J.cmp(v_g_798, 0.28, ">")
	if (J.cmp(v_g_798, 0.45, "<") if _t652 else _t652):
		v_i_803 = 0.0
		while true:
			if not J.cmp(v_i_803, 3.0, "<"): break
			J.mc(J.G.get("N30M"), "bolt", [v_ctx_796, v_p_802, [J.add(J.gp(v_p_802, 0.0), J.mul((J.sub(J.mc(env["N"], "rnd", [v_i_803]), 0.5) * 0.2), v_H_801)), J.sub(J.gp(v_p_802, 1.0), J.mul(0.15, v_H_801))], J.mul(0.008, v_H_801), J.add(J.add(43.0, v_i_803), floor(J.num(J.mul(v_g_798, 30.0)))), "#ffe14a", 1.0])
			v_i_803 = J.num(v_i_803) + 1.0
	var _t653 = env["at"]
	var _t655 = J.gp(J.cl(_t653, null, [v_S_797, v_m_799, 0.55, 0.05]), 0.0)
	var _t654 = env["at"]
	J.mc(env["N"], "puff", [v_ctx_796, _t655, J.gp(J.cl(_t654, null, [v_S_797, v_m_799, 0.55, 0.05]), 1.0), J.mul(0.06, v_H_801), J.mc(env["N"], "seg", [v_g_798, 0.45, 1.0]), "rgba(110,100,100,.5)", 44.0, 3.0])

func _f185(this_, a: Array, env):
	var v_g_804 = null; var v_H_805 = null
	v_g_804 = J.arg(a, 0)
	v_H_805 = J.arg(a, 1)
	var _t657 = (-0.3)
	var _t656 = env["sw"]
	var _t659 = (_t657 + J.mul(J.cl(_t656, null, [v_g_804, 2.0]), 0.1))
	var _t658 = env["sw"]
	return {"armF": _t659, "head": J.mul(J.cl(_t658, null, [v_g_804, 1.0]), 0.15)}

func _f186(this_, a: Array, env):
	var v_ctx_806 = null; var v_S_807 = null; var v_g_808 = null; var v_m_809 = null; var v_f_810 = null; var v_H_811 = null
	v_ctx_806 = J.arg(a, 0)
	v_S_807 = J.arg(a, 1)
	v_g_808 = J.arg(a, 2)
	v_m_809 = J.arg(a, 3)
	v_f_810 = J.arg(a, 4)
	v_H_811 = J.arg(a, 5)
	var _t660 = env["T"]
	var _t662 = J.mul(0.25, v_H_811)
	var _t663 = J.mul((-1.05), v_H_811)
	var _t664 = J.mul(0.09, v_H_811)
	var _t661 = env["bump"]
	return J.cl(_t660, null, [v_ctx_806, v_S_807, _t662, _t663, _t664, "插蘇喺邊？", "#ffe14a", J.cl(_t661, null, [v_g_808, 0.3, 0.9])])

func _f187(this_, a: Array, env):
	var v_g_812 = null; var v_H_813 = null
	v_g_812 = J.arg(a, 0)
	v_H_813 = J.arg(a, 1)
	var _t665 = env["sw"]
	var _t667 = J.mul(J.mul(J.cl(_t665, null, [v_g_812, 20.0]), 0.008), v_H_813)
	var _t666 = env["sw"]
	return {"x": _t667, "head": J.mul(J.cl(_t666, null, [v_g_812, 16.0]), 0.03), "sy": 0.98}

func _f188(this_, a: Array, env):
	var v_ctx_814 = null; var v_S_815 = null; var v_g_816 = null; var v_m_817 = null; var v_f_818 = null; var v_H_819 = null; var v_i_820 = null; var v_q_821 = null
	v_ctx_814 = J.arg(a, 0)
	v_S_815 = J.arg(a, 1)
	v_g_816 = J.arg(a, 2)
	v_m_817 = J.arg(a, 3)
	v_f_818 = J.arg(a, 4)
	v_H_819 = J.arg(a, 5)
	v_i_820 = 0.0
	while true:
		if not J.cmp(v_i_820, 2.0, "<"): break
		v_q_821 = J.mod(J.add(v_g_816, J.div(v_i_820, 2.0)), 1.0)
		var _t668 = env["flake"]
		J.cl(_t668, null, [v_ctx_814, J.mul((J.sub(v_i_820, 0.5) * 0.4), v_H_819), (J.mul((-1.0), v_H_819) + J.mul(J.mul(v_q_821, 0.8), v_H_819)), J.mul(0.03, v_H_819), J.mul(v_q_821, 5.0), sin(J.num(J.mul(v_q_821, env["PI"])))])
		v_i_820 = J.num(v_i_820) + 1.0

func _f189(this_, a: Array, env):
	var v_g_822 = null; var v_H_823 = null; var v_k_824 = null; var v_s2_825 = null
	v_g_822 = J.arg(a, 0)
	v_H_823 = J.arg(a, 1)
	var _t669 = env["bump"]
	v_k_824 = J.cl(_t669, null, [v_g_822, 0.1, 0.5])
	var _t670 = env["bump"]
	v_s2_825 = J.cl(_t670, null, [v_g_822, 0.5, 0.65])
	return {"head": (J.mul((-0.2), v_k_824) + J.mul(0.25, v_s2_825)), "body": J.mul(0.1, v_s2_825)}

func _f190(this_, a: Array, env):
	var v_ctx_826 = null; var v_S_827 = null; var v_g_828 = null; var v_m_829 = null; var v_f_830 = null; var v_H_831 = null; var v_p_832 = null; var v_i_833 = null
	v_ctx_826 = J.arg(a, 0)
	v_S_827 = J.arg(a, 1)
	v_g_828 = J.arg(a, 2)
	v_m_829 = J.arg(a, 3)
	v_f_830 = J.arg(a, 4)
	v_H_831 = J.arg(a, 5)
	var _t671 = env["T"]
	var _t673 = J.mul(0.25, v_H_831)
	var _t674 = J.mul((-1.05), v_H_831)
	var _t675 = J.mul(0.1, v_H_831)
	var _t676 = ("哈……" if J.cmp(v_g_828, 0.5, "<") else "哈啾！")
	var _t672 = env["bump"]
	J.cl(_t671, null, [v_ctx_826, v_S_827, _t673, _t674, _t675, _t676, "#cfeaff", J.cl(_t672, null, [v_g_828, 0.1, 0.9])])
	var _t677 = env["at"]
	v_p_832 = J.cl(_t677, null, [v_S_827, v_m_829, 0.4, 0.3])
	if J.cmp(v_g_828, 0.5, ">"):
		v_i_833 = 0.0
		while true:
			if not J.cmp(v_i_833, 4.0, "<"): break
			var _t678 = env["flake"]
			J.cl(_t678, null, [v_ctx_826, J.add(J.add(J.gp(v_p_832, 0.0), J.mul((J.sub(v_g_828, 0.5) * 0.6), v_H_831)), J.mul(J.mul(v_i_833, 0.03), v_H_831)), J.add(J.gp(v_p_832, 1.0), J.mul((J.sub(v_i_833, 1.5) * 0.04), v_H_831)), J.mul(0.025, v_H_831), J.add(J.mul(v_g_828, 8.0), v_i_833), J.sub(1.0, J.mc(env["N"], "seg", [v_g_828, 0.7, 1.0]))])
			v_i_833 = J.num(v_i_833) + 1.0

func _f191(this_, a: Array, env):
	var v_g_834 = null; var v_H_835 = null
	v_g_834 = J.arg(a, 0)
	v_H_835 = J.arg(a, 1)
	var _t679 = env["sw"]
	var _t681 = J.mul(J.cl(_t679, null, [v_g_834]), 6.0)
	var _t680 = env["sw"]
	return {"r": _t681, "px": 0.0, "py": 0.0, "head": J.mul(J.cl(_t680, null, [v_g_834, 1.0, 1.0]), 0.1)}

func _f192(this_, a: Array, env):
	var v_ctx_836 = null; var v_S_837 = null; var v_g_838 = null; var v_m_839 = null; var v_f_840 = null; var v_H_841 = null
	v_ctx_836 = J.arg(a, 0)
	v_S_837 = J.arg(a, 1)
	v_g_838 = J.arg(a, 2)
	v_m_839 = J.arg(a, 3)
	v_f_840 = J.arg(a, 4)
	v_H_841 = J.arg(a, 5)
	var _t682 = env["at"]
	var _t684 = J.gp(J.cl(_t682, null, [v_S_837, v_m_839, 0.42, 0.05]), 0.0)
	var _t683 = env["at"]
	return J.mc(env["N"], "stars", [v_ctx_836, _t684, J.gp(J.cl(_t683, null, [v_S_837, v_m_839, 0.42, 0.05]), 1.0), J.mul(0.15, v_H_841), J.mul(v_g_838, 6.0), 0.9])

func _f193(this_, a: Array, env):
	var v_g_842 = null; var v_H_843 = null
	v_g_842 = J.arg(a, 0)
	v_H_843 = J.arg(a, 1)
	var _t686 = (-0.2)
	var _t685 = env["env"]
	var _t688 = J.mul(_t686, J.cl(_t685, null, [v_g_842, 0.1, 0.3, 0.7, 0.9]))
	var _t687 = env["sw"]
	var _t690 = (_t688 + J.mul(J.cl(_t687, null, [v_g_842, 3.0]), 0.03))
	var _t689 = env["env"]
	return {"head": _t690, "sy": (1.0 - J.mul(0.03, J.cl(_t689, null, [v_g_842, 0.1, 0.3, 0.7, 0.9])))}

func _f194(this_, a: Array, env):
	var v_ctx_844 = null; var v_S_845 = null; var v_g_846 = null; var v_m_847 = null; var v_f_848 = null; var v_H_849 = null
	v_ctx_844 = J.arg(a, 0)
	v_S_845 = J.arg(a, 1)
	v_g_846 = J.arg(a, 2)
	v_m_847 = J.arg(a, 3)
	v_f_848 = J.arg(a, 4)
	v_H_849 = J.arg(a, 5)
	var _t691 = env["T"]
	var _t693 = J.mul(0.25, v_H_849)
	var _t694 = J.mul((-1.1), v_H_849)
	var _t695 = J.mul(0.1, v_H_849)
	var _t692 = env["bump"]
	return J.cl(_t691, null, [v_ctx_844, v_S_845, _t693, _t694, _t695, "……！", "#ffe066", J.cl(_t692, null, [v_g_846, 0.3, 0.8])])

func _f195(this_, a: Array, env):
	var v_g_850 = null; var v_H_851 = null; var v_k_852 = null
	v_g_850 = J.arg(a, 0)
	v_H_851 = J.arg(a, 1)
	var _t696 = env["env"]
	v_k_852 = J.cl(_t696, null, [v_g_850, 0.1, 0.3, 0.7, 0.9])
	return {"armF": J.mul((-0.3), v_k_852), "head": J.mul(0.12, v_k_852)}

func _f196(this_, a: Array, env):
	var v_ctx_853 = null; var v_S_854 = null; var v_g_855 = null; var v_m_856 = null; var v_f_857 = null; var v_H_858 = null; var v_i_859 = null; var v_q_860 = null; var v_pts_861 = null; var v_j_862 = null
	v_ctx_853 = J.arg(a, 0)
	v_S_854 = J.arg(a, 1)
	v_g_855 = J.arg(a, 2)
	v_m_856 = J.arg(a, 3)
	v_f_857 = J.arg(a, 4)
	v_H_858 = J.arg(a, 5)
	var _t697 = env["T"]
	var _t699 = J.mul(0.25, v_H_858)
	var _t700 = J.mul((-1.05), v_H_858)
	var _t701 = J.mul(0.09, v_H_858)
	var _t698 = env["bump"]
	J.cl(_t697, null, [v_ctx_853, v_S_854, _t699, _t700, _t701, "好香～", "#d8e070", J.cl(_t698, null, [v_g_855, 0.3, 0.85])])
	v_i_859 = 0.0
	while true:
		if not J.cmp(v_i_859, 2.0, "<"): break
		v_q_860 = J.mod(J.add(v_g_855, J.div(v_i_859, 2.0)), 1.0)
		v_pts_861 = []
		v_j_862 = 0.0
		while true:
			if not J.cmp(v_j_862, 5.0, "<="): break
			J.mc(v_pts_861, "push", [[((J.mul((-0.25), v_H_858) + J.mul(J.mul(v_i_859, 0.08), v_H_858)) + J.mul((sin(J.num(J.add(v_j_862, J.mul(v_g_855, 12.0)))) * 0.02), v_H_858)), ((J.mul((-0.6), v_H_858) - J.mul(J.mul(v_j_862, 0.05), v_H_858)) - J.mul(J.mul(v_q_860, 0.1), v_H_858))]])
			v_j_862 = J.num(v_j_862) + 1.0
		J.mc(env["N"], "crayon", [v_ctx_853, v_pts_861, "rgba(150,190,80,.7)", J.mul(0.012, v_H_858), J.add(47.0, v_i_859), sin(J.num(J.mul(v_q_860, env["PI"])))])
		v_i_859 = J.num(v_i_859) + 1.0

func _f197(this_, a: Array, env):
	var v_g_863 = null; var v_H_864 = null
	v_g_863 = J.arg(a, 0)
	v_H_864 = J.arg(a, 1)
	var _t703 = (-0.9)
	var _t702 = env["sw"]
	return {"armB": (_t703 + J.mul(J.cl(_t702, null, [v_g_863, 4.0]), 0.08)), "head": 0.1}

func _f198(this_, a: Array, env):
	var v_ctx_865 = null; var v_S_866 = null; var v_g_867 = null; var v_m_868 = null; var v_f_869 = null; var v_H_870 = null
	v_ctx_865 = J.arg(a, 0)
	v_S_866 = J.arg(a, 1)
	v_g_867 = J.arg(a, 2)
	v_m_868 = J.arg(a, 3)
	v_f_869 = J.arg(a, 4)
	v_H_870 = J.arg(a, 5)
	var _t704 = env["T"]
	var _t706 = J.mul(0.25, v_H_870)
	var _t707 = J.mul((-1.05), v_H_870)
	var _t708 = J.mul(0.09, v_H_870)
	var _t705 = env["sw"]
	return J.cl(_t704, null, [v_ctx_865, v_S_866, _t706, _t707, _t708, "痛痛痛", "#ffd0d0", absf(J.num(J.cl(_t705, null, [v_g_867, 1.5])))])

func _f199(this_, a: Array, env):
	var v_g_871 = null; var v_H_872 = null; var v_k_873 = null
	v_g_871 = J.arg(a, 0)
	v_H_872 = J.arg(a, 1)
	var _t709 = env["env"]
	v_k_873 = J.cl(_t709, null, [v_g_871, 0.05, 0.25, 0.4, 0.55])
	var _t712 = J.mul((-0.6), v_k_873)
	var _t711 = J.mul((-0.1), v_k_873)
	var _t710 = env["bump"]
	var _t714 = (_t711 + J.mul(0.1, J.cl(_t710, null, [v_g_871, 0.55, 0.9])))
	var _t713 = env["sw"]
	return {"armF": _t712, "head": _t714, "armB": ((0.1 * absf(J.num(J.cl(_t713, null, [v_g_871, 4.0])))) * (1.0 if J.cmp(v_g_871, 0.55, ">") else 0.0))}

func _f200(this_, a: Array, env):
	var v_ctx_874 = null; var v_S_875 = null; var v_g_876 = null; var v_m_877 = null; var v_f_878 = null; var v_H_879 = null
	v_ctx_874 = J.arg(a, 0)
	v_S_875 = J.arg(a, 1)
	v_g_876 = J.arg(a, 2)
	v_m_877 = J.arg(a, 3)
	v_f_878 = J.arg(a, 4)
	v_H_879 = J.arg(a, 5)
	var _t715 = env["T"]
	var _t717 = J.mul(0.25, v_H_879)
	var _t718 = J.mul((-1.05), v_H_879)
	var _t719 = J.mul(0.09, v_H_879)
	var _t716 = env["bump"]
	return J.cl(_t715, null, [v_ctx_874, v_S_875, _t717, _t718, _t719, "噎……！", "#ffffff", J.cl(_t716, null, [v_g_876, 0.55, 0.95])])

func _f201(this_, a: Array, env):
	var v_g_880 = null; var v_H_881 = null
	v_g_880 = J.arg(a, 0)
	v_H_881 = J.arg(a, 1)
	var _t720 = env["sw"]
	var _t722 = (0.12 * absf(J.num(J.cl(_t720, null, [v_g_880, 2.0]))))
	var _t721 = env["sw"]
	return {"body": _t722, "head": (0.15 * absf(J.num(J.cl(_t721, null, [v_g_880, 2.0]))))}

func _f202(this_, a: Array, env):
	var v_ctx_882 = null; var v_S_883 = null; var v_g_884 = null; var v_m_885 = null; var v_f_886 = null; var v_H_887 = null
	v_ctx_882 = J.arg(a, 0)
	v_S_883 = J.arg(a, 1)
	v_g_884 = J.arg(a, 2)
	v_m_885 = J.arg(a, 3)
	v_f_886 = J.arg(a, 4)
	v_H_887 = J.arg(a, 5)
	var _t723 = env["T"]
	var _t725 = J.mul(0.25, v_H_887)
	var _t726 = J.mul((-1.0), v_H_887)
	var _t727 = J.mul(0.1, v_H_887)
	var _t724 = env["sw"]
	return J.cl(_t723, null, [v_ctx_882, v_S_883, _t725, _t726, _t727, "咳！", "#ffffff", absf(J.num(J.cl(_t724, null, [v_g_884, 1.0])))])

func _f203(this_, a: Array, env):
	var v_g_888 = null; var v_H_889 = null
	v_g_888 = J.arg(a, 0)
	v_H_889 = J.arg(a, 1)
	var _t728 = env["sw"]
	var _t730 = (0.15 + (absf(J.num(J.cl(_t728, null, [v_g_888, 5.0]))) * 0.08))
	var _t729 = env["sw"]
	var _t732 = (0.15 + (absf(J.num(J.cl(_t729, null, [v_g_888, 5.0]))) * 0.1))
	var _t731 = env["sw"]
	return {"body": _t730, "head": _t732, "y": J.mul(((-absf(J.num(J.cl(_t731, null, [v_g_888, 5.0])))) * 0.02), v_H_889)}

func _f204(this_, a: Array, env):
	var v_ctx_890 = null; var v_S_891 = null; var v_g_892 = null; var v_m_893 = null; var v_f_894 = null; var v_H_895 = null
	v_ctx_890 = J.arg(a, 0)
	v_S_891 = J.arg(a, 1)
	v_g_892 = J.arg(a, 2)
	v_m_893 = J.arg(a, 3)
	v_f_894 = J.arg(a, 4)
	v_H_895 = J.arg(a, 5)
	var _t733 = env["T"]
	J.cl(_t733, null, [v_ctx_890, v_S_891, J.mul(0.2, v_H_895), J.mul((-1.0), v_H_895), J.mul(0.1, v_H_895), "哈哈哈", "#ffe066", 0.9])
	var _t734 = env["at"]
	var _t736 = J.gp(J.cl(_t734, null, [v_S_891, v_m_893, 0.3, 0.2]), 0.0)
	var _t735 = env["at"]
	J.mc(env["N"], "drops", [v_ctx_890, _t736, J.gp(J.cl(_t735, null, [v_S_891, v_m_893, 0.3, 0.2]), 1.0), J.mul(0.2, v_H_895), J.mod(J.mul(v_g_892, 2.0), 1.0), "rgba(150,210,255,.9)", 49.0, 3.0])

func _f205(this_, a: Array, env):
	var v_g_896 = null; var v_H_897 = null
	v_g_896 = J.arg(a, 0)
	v_H_897 = J.arg(a, 1)
	var _t737 = env["sw"]
	var _t738 = env["sw"]
	return {"armB": (0.3 * J.max_([0.0, J.cl(_t738, null, [v_g_896, 3.0])])), "body": 0.1, "head": 0.1}

func _f206(this_, a: Array, env):
	var v_ctx_898 = null; var v_S_899 = null; var v_g_900 = null; var v_m_901 = null; var v_f_902 = null; var v_H_903 = null
	v_ctx_898 = J.arg(a, 0)
	v_S_899 = J.arg(a, 1)
	v_g_900 = J.arg(a, 2)
	v_m_901 = J.arg(a, 3)
	v_f_902 = J.arg(a, 4)
	v_H_903 = J.arg(a, 5)
	var _t739 = env["T"]
	var _t742 = J.mul(0.3, v_H_903)
	var _t743 = J.mul((-0.6), v_H_903)
	var _t744 = J.mul(0.08, v_H_903)
	var _t740 = env["sw"]
	var _t741 = env["sw"]
	return J.cl(_t739, null, [v_ctx_898, v_S_899, _t742, _t743, _t744, "啪", "#ffe066", J.max_([0.0, J.cl(_t741, null, [v_g_900, 3.0])])])

func _f207(this_, a: Array, env):
	var v_g_904 = null; var v_H_905 = null; var v_j_906 = null
	v_g_904 = J.arg(a, 0)
	v_H_905 = J.arg(a, 1)
	var _t745 = env["bump"]
	v_j_906 = J.cl(_t745, null, [v_g_904, 0.2, 0.45])
	return {"y": J.mul(J.mul((-0.15), v_H_905), v_j_906), "hairL": J.mul((-0.3), v_j_906), "hairR": J.mul((-0.3), v_j_906), "armF": J.mul((-0.4), v_j_906), "armB": J.mul(0.4, v_j_906)}

func _f208(this_, a: Array, env):
	var v_ctx_907 = null; var v_S_908 = null; var v_g_909 = null; var v_m_910 = null; var v_f_911 = null; var v_H_912 = null
	v_ctx_907 = J.arg(a, 0)
	v_S_908 = J.arg(a, 1)
	v_g_909 = J.arg(a, 2)
	v_m_910 = J.arg(a, 3)
	v_f_911 = J.arg(a, 4)
	v_H_912 = J.arg(a, 5)
	var _t746 = env["T"]
	var _t748 = J.mul(0.2, v_H_912)
	var _t749 = J.mul((-1.15), v_H_912)
	var _t750 = J.mul(0.12, v_H_912)
	var _t747 = env["bump"]
	return J.cl(_t746, null, [v_ctx_907, v_S_908, _t748, _t749, _t750, "哇！", "#ff5050", J.cl(_t747, null, [v_g_909, 0.2, 0.6])])

func _f209(this_, a: Array, env):
	var v_g_913 = null; var v_H_914 = null
	v_g_913 = J.arg(a, 0)
	v_H_914 = J.arg(a, 1)
	var _t751 = env["sw"]
	var _t753 = J.mul(J.cl(_t751, null, [v_g_913, 2.0]), 0.15)
	var _t752 = env["sw"]
	return {"head": _t753, "x": J.mul(J.mul(J.cl(_t752, null, [v_g_913, 25.0]), 0.003), v_H_914)}

func _f210(this_, a: Array, env):
	var v_g_915 = null; var v_H_916 = null
	v_g_915 = J.arg(a, 0)
	v_H_916 = J.arg(a, 1)
	var _t754 = env["bump"]
	return {"head": (0.05 + J.mul(0.1, J.cl(_t754, null, [v_g_915, 0.6, 0.8])))}

func _f211(this_, a: Array, env):
	var v_ctx_917 = null; var v_S_918 = null; var v_g_919 = null; var v_m_920 = null; var v_f_921 = null; var v_H_922 = null; var v_i_923 = null
	v_ctx_917 = J.arg(a, 0)
	v_S_918 = J.arg(a, 1)
	v_g_919 = J.arg(a, 2)
	v_m_920 = J.arg(a, 3)
	v_f_921 = J.arg(a, 4)
	v_H_922 = J.arg(a, 5)
	v_i_923 = 0.0
	while true:
		if not J.cmp(v_i_923, 2.0, "<"): break
		var _t755 = env["at"]
		var _t757 = J.add(J.gp(J.cl(_t755, null, [v_S_918, v_m_920, 0.35, 0.05]), 0.0), J.mul(J.mul(v_i_923, 0.05), v_H_922))
		var _t756 = env["at"]
		J.mc(env["N"], "puff", [v_ctx_917, _t757, J.gp(J.cl(_t756, null, [v_S_918, v_m_920, 0.35, 0.05]), 1.0), J.mul(0.06, v_H_922), J.mod(J.add(v_g_919, J.div(v_i_923, 2.0)), 1.0), "rgba(80,70,70,.5)", J.add(51.0, v_i_923), 3.0])
		v_i_923 = J.num(v_i_923) + 1.0

func _f212(this_, a: Array, env):
	var v_g_924 = null; var v_H_925 = null
	v_g_924 = J.arg(a, 0)
	v_H_925 = J.arg(a, 1)
	var _t759 = (-0.4)
	var _t758 = env["env"]
	return {"armB": J.mul(_t759, J.cl(_t758, null, [v_g_924, 0.1, 0.3, 0.7, 0.9])), "umb": (-0.1), "head": (-0.15)}

func _f213(this_, a: Array, env):
	var v_ctx_926 = null; var v_S_927 = null; var v_g_928 = null; var v_m_929 = null; var v_f_930 = null; var v_H_931 = null
	v_ctx_926 = J.arg(a, 0)
	v_S_927 = J.arg(a, 1)
	v_g_928 = J.arg(a, 2)
	v_m_929 = J.arg(a, 3)
	v_f_930 = J.arg(a, 4)
	v_H_931 = J.arg(a, 5)
	var _t760 = env["T"]
	var _t762 = J.mul(0.2, v_H_931)
	var _t763 = J.mul((-1.1), v_H_931)
	var _t764 = J.mul(0.08, v_H_931)
	var _t761 = env["bump"]
	return J.cl(_t760, null, [v_ctx_926, v_S_927, _t762, _t763, _t764, "唔會再行雷啩…", "#ffe14a", J.cl(_t761, null, [v_g_928, 0.3, 0.9])])

func _f214(this_, a: Array, env):
	var v_g_932 = null; var v_H_933 = null
	v_g_932 = J.arg(a, 0)
	v_H_933 = J.arg(a, 1)
	var _t767 = (-0.2)
	var _t766 = (-0.08)
	var _t765 = env["bump"]
	return {"armF": _t767, "head": (_t766 + J.mul(0.06, J.cl(_t765, null, [v_g_932, 0.5, 0.6])))}

func _f215(this_, a: Array, env):
	var v_ctx_934 = null; var v_S_935 = null; var v_g_936 = null; var v_m_937 = null; var v_f_938 = null; var v_H_939 = null; var v_p_940 = null
	v_ctx_934 = J.arg(a, 0)
	v_S_935 = J.arg(a, 1)
	v_g_936 = J.arg(a, 2)
	v_m_937 = J.arg(a, 3)
	v_f_938 = J.arg(a, 4)
	v_H_939 = J.arg(a, 5)
	var _t768 = J.cmp(v_g_936, 0.5, ">")
	if (J.cmp(v_g_936, 0.62, "<") if _t768 else _t768):
		var _t769 = env["at"]
		v_p_940 = J.cl(_t769, null, [v_S_935, v_m_937, 0.8, 0.14])
		J.mc(env["N"], "burst", [v_ctx_934, J.gp(v_p_940, 0.0), J.gp(v_p_940, 1.0), J.mul(0.15, v_H_939), (1.0 - J.div(J.sub(v_g_936, 0.5), 0.12)), "#ffffff", 53.0, 8.0])
	var _t770 = env["T"]
	var _t772 = J.mul((-0.1), v_H_939)
	var _t773 = J.mul((-1.05), v_H_939)
	var _t774 = J.mul(0.09, v_H_939)
	var _t771 = env["bump"]
	J.cl(_t770, null, [v_ctx_934, v_S_935, _t772, _t773, _t774, "茄子～", "#ffe0f0", J.cl(_t771, null, [v_g_936, 0.1, 0.55])])

func _f216(this_, a: Array, env):
	var v_g_941 = null; var v_H_942 = null
	v_g_941 = J.arg(a, 0)
	v_H_942 = J.arg(a, 1)
	var _t775 = env["env"]
	var _t777 = J.mul(0.3, J.cl(_t775, null, [v_g_941, 0.1, 0.3, 0.7, 0.9]))
	var _t776 = env["env"]
	return {"armB": _t777, "stick": J.mul(0.2, J.cl(_t776, null, [v_g_941, 0.1, 0.3, 0.7, 0.9])), "head": 0.1}

func _f217(this_, a: Array, env):
	var v_ctx_943 = null; var v_S_944 = null; var v_g_945 = null; var v_m_946 = null; var v_f_947 = null; var v_H_948 = null
	v_ctx_943 = J.arg(a, 0)
	v_S_944 = J.arg(a, 1)
	v_g_945 = J.arg(a, 2)
	v_m_946 = J.arg(a, 3)
	v_f_947 = J.arg(a, 4)
	v_H_948 = J.arg(a, 5)
	var _t778 = env["T"]
	var _t780 = J.mul(0.2, v_H_948)
	var _t781 = J.mul((-1.05), v_H_948)
	var _t782 = J.mul(0.09, v_H_948)
	var _t779 = env["bump"]
	return J.cl(_t778, null, [v_ctx_943, v_S_944, _t780, _t781, _t782, "正！", "#ffe0f0", J.cl(_t779, null, [v_g_945, 0.5, 0.95])])

func _f218(this_, a: Array, env):
	var v_g_949 = null; var v_H_950 = null
	v_g_949 = J.arg(a, 0)
	v_H_950 = J.arg(a, 1)
	var _t784 = (-0.6)
	var _t783 = env["env"]
	return {"armF": J.mul(_t784, J.cl(_t783, null, [v_g_949, 0.1, 0.3, 0.5, 0.7])), "head": 0.08}

func _f219(this_, a: Array, env):
	var v_ctx_951 = null; var v_S_952 = null; var v_g_953 = null; var v_m_954 = null; var v_f_955 = null; var v_H_956 = null
	v_ctx_951 = J.arg(a, 0)
	v_S_952 = J.arg(a, 1)
	v_g_953 = J.arg(a, 2)
	v_m_954 = J.arg(a, 3)
	v_f_955 = J.arg(a, 4)
	v_H_956 = J.arg(a, 5)
	var _t785 = env["at"]
	var _t787 = J.gp(J.cl(_t785, null, [v_S_952, v_m_954, 0.45, 0.2]), 0.0)
	var _t786 = env["at"]
	return J.mc(env["N"], "drops", [v_ctx_951, _t787, J.gp(J.cl(_t786, null, [v_S_952, v_m_954, 0.45, 0.2]), 1.0), J.mul(0.25, v_H_956), J.mc(env["N"], "seg", [v_g_953, 0.45, 0.9]), "rgba(150,210,255,.9)", 55.0, 5.0])

func _f220(this_, a: Array, env):
	var v_g_957 = null; var v_H_958 = null
	v_g_957 = J.arg(a, 0)
	v_H_958 = J.arg(a, 1)
	var _t789 = (-0.3)
	var _t788 = env["env"]
	return {"armB": J.mul(_t789, J.cl(_t788, null, [v_g_957, 0.1, 0.3, 0.6, 0.8])), "head": (-0.08)}

func _f221(this_, a: Array, env):
	var v_ctx_959 = null; var v_S_960 = null; var v_g_961 = null; var v_m_962 = null; var v_f_963 = null; var v_H_964 = null; var v_p_965 = null
	v_ctx_959 = J.arg(a, 0)
	v_S_960 = J.arg(a, 1)
	v_g_961 = J.arg(a, 2)
	v_m_962 = J.arg(a, 3)
	v_f_963 = J.arg(a, 4)
	v_H_964 = J.arg(a, 5)
	var _t790 = env["at"]
	v_p_965 = J.cl(_t790, null, [v_S_960, v_m_962, 0.75, 0.45])
	J.mc(env["N"], "drops", [v_ctx_959, J.gp(v_p_965, 0.0), J.gp(v_p_965, 1.0), J.mul(0.12, v_H_964), J.mod(J.mul(v_g_961, 2.0), 1.0), "rgba(255,160,110,.9)", 57.0, 2.0, 0.5])

func _f222(this_, a: Array, env):
	var v_g_966 = null; var v_H_967 = null
	v_g_966 = J.arg(a, 0)
	v_H_967 = J.arg(a, 1)
	var _t792 = (-0.3)
	var _t791 = env["sw"]
	var _t794 = (_t792 * absf(J.num(J.cl(_t791, null, [v_g_966, 2.0]))))
	var _t793 = env["sw"]
	return {"armF": _t794, "head": J.mul(J.cl(_t793, null, [v_g_966, 6.0]), 0.04)}

func _f223(this_, a: Array, env):
	var v_ctx_968 = null; var v_S_969 = null; var v_g_970 = null; var v_m_971 = null; var v_f_972 = null; var v_H_973 = null
	v_ctx_968 = J.arg(a, 0)
	v_S_969 = J.arg(a, 1)
	v_g_970 = J.arg(a, 2)
	v_m_971 = J.arg(a, 3)
	v_f_972 = J.arg(a, 4)
	v_H_973 = J.arg(a, 5)
	var _t795 = env["T"]
	return J.cl(_t795, null, [v_ctx_968, v_S_969, J.mul(0.15, v_H_973), J.mul((-1.05), v_H_973), J.mul(0.08, v_H_973), "嚼嚼", "#ffe0b0", 0.8])

func _f224(this_, a: Array, env):
	var v_g_974 = null; var v_H_975 = null; var v_k_976 = null
	v_g_974 = J.arg(a, 0)
	v_H_975 = J.arg(a, 1)
	var _t796 = env["bump"]
	v_k_976 = J.cl(_t796, null, [v_g_974, 0.3, 0.6])
	return {"sx": (1.0 + J.mul(0.05, v_k_976)), "sy": (1.0 - J.mul(0.02, v_k_976)), "head": J.mul((-0.15), v_k_976)}

func _f225(this_, a: Array, env):
	var v_ctx_977 = null; var v_S_978 = null; var v_g_979 = null; var v_m_980 = null; var v_f_981 = null; var v_H_982 = null
	v_ctx_977 = J.arg(a, 0)
	v_S_978 = J.arg(a, 1)
	v_g_979 = J.arg(a, 2)
	v_m_980 = J.arg(a, 3)
	v_f_981 = J.arg(a, 4)
	v_H_982 = J.arg(a, 5)
	var _t797 = env["T"]
	var _t799 = J.mul(0.2, v_H_982)
	var _t800 = J.mul((-1.05), v_H_982)
	var _t801 = J.mul(0.11, v_H_982)
	var _t798 = env["bump"]
	return J.cl(_t797, null, [v_ctx_977, v_S_978, _t799, _t800, _t801, "嗝～", "#ffe0b0", J.cl(_t798, null, [v_g_979, 0.3, 0.75])])

func _f226(this_, a: Array, env):
	var v_g_983 = null; var v_H_984 = null; var v_u_985 = null
	v_g_983 = J.arg(a, 0)
	v_H_984 = J.arg(a, 1)
	var _t802 = env["sw"]
	v_u_985 = absf(J.num(J.cl(_t802, null, [v_g_983, 2.0])))
	var _t804 = J.mul(J.mul((-0.08), v_H_984), v_u_985)
	var _t805 = J.mul((-0.3), v_u_985)
	var _t803 = env["sw"]
	return {"y": _t804, "armF": _t805, "snake": J.mul(J.cl(_t803, null, [v_g_983, 2.0]), 0.1)}

func _f227(this_, a: Array, env):
	var v_ctx_986 = null; var v_S_987 = null; var v_g_988 = null; var v_m_989 = null; var v_f_990 = null; var v_H_991 = null
	v_ctx_986 = J.arg(a, 0)
	v_S_987 = J.arg(a, 1)
	v_g_988 = J.arg(a, 2)
	v_m_989 = J.arg(a, 3)
	v_f_990 = J.arg(a, 4)
	v_H_991 = J.arg(a, 5)
	var _t806 = env["T"]
	return J.cl(_t806, null, [v_ctx_986, v_S_987, J.mul(0.15, v_H_991), J.mul((-1.1), v_H_991), J.mul(0.09, v_H_991), "哎喲哎喲", "#ffe066", 0.9])

func _f228(this_, a: Array, env):
	var v_g_992 = null; var v_H_993 = null
	v_g_992 = J.arg(a, 0)
	v_H_993 = J.arg(a, 1)
	var _t807 = env["sw"]
	var _t809 = J.mul(J.cl(_t807, null, [v_g_992, 3.0]), 5.0)
	var _t808 = env["sw"]
	return {"r": _t809, "px": 0.0, "py": 0.0, "snake": J.mul(J.cl(_t808, null, [v_g_992, 3.0, 1.0]), 0.2)}

func _f229(this_, a: Array, env):
	var v_g_994 = null; var v_H_995 = null
	v_g_994 = J.arg(a, 0)
	v_H_995 = J.arg(a, 1)
	var _t810 = env["sw"]
	return {"body": (0.15 + (absf(J.num(J.cl(_t810, null, [v_g_994, 2.0]))) * 0.05)), "head": 0.15, "sy": 0.97}

func _f230(this_, a: Array, env):
	var v_ctx_996 = null; var v_S_997 = null; var v_g_998 = null; var v_m_999 = null; var v_f_1000 = null; var v_H_1001 = null
	v_ctx_996 = J.arg(a, 0)
	v_S_997 = J.arg(a, 1)
	v_g_998 = J.arg(a, 2)
	v_m_999 = J.arg(a, 3)
	v_f_1000 = J.arg(a, 4)
	v_H_1001 = J.arg(a, 5)
	var _t811 = env["T"]
	var _t813 = J.mul(0.2, v_H_1001)
	var _t814 = J.mul((-1.0), v_H_1001)
	var _t815 = J.mul(0.09, v_H_1001)
	var _t812 = env["bump"]
	return J.cl(_t811, null, [v_ctx_996, v_S_997, _t813, _t814, _t815, "咕嚕嚕", "#b8e070", J.cl(_t812, null, [v_g_998, 0.1, 0.9])])

func _f231(this_, a: Array, env):
	var v_g_1002 = null; var v_H_1003 = null
	v_g_1002 = J.arg(a, 0)
	v_H_1003 = J.arg(a, 1)
	var _t816 = env["sw"]
	var _t818 = J.mul(J.cl(_t816, null, [v_g_1002, 6.0]), 0.2)
	var _t817 = env["sw"]
	var _t820 = ((-J.num(J.cl(_t817, null, [v_g_1002, 6.0]))) * 0.2)
	var _t819 = env["sw"]
	var _t822 = J.mul(J.cl(_t819, null, [v_g_1002, 1.0]), 0.15)
	var _t821 = env["sw"]
	return {"legF": _t818, "legB": _t820, "head": _t822, "y": J.mul(((-absf(J.num(J.cl(_t821, null, [v_g_1002, 6.0])))) * 0.015), v_H_1003)}

func _f232(this_, a: Array, env):
	var v_ctx_1004 = null; var v_S_1005 = null; var v_g_1006 = null; var v_m_1007 = null; var v_f_1008 = null; var v_H_1009 = null
	v_ctx_1004 = J.arg(a, 0)
	v_S_1005 = J.arg(a, 1)
	v_g_1006 = J.arg(a, 2)
	v_m_1007 = J.arg(a, 3)
	v_f_1008 = J.arg(a, 4)
	v_H_1009 = J.arg(a, 5)
	var _t823 = env["T"]
	return J.cl(_t823, null, [v_ctx_1004, v_S_1005, J.mul(0.2, v_H_1009), J.mul((-1.05), v_H_1009), J.mul(0.09, v_H_1009), "廁所喺邊！", "#b8e070", 0.9])

func _f233(this_, a: Array, env):
	var v_g_1010 = null; var v_H_1011 = null
	v_g_1010 = J.arg(a, 0)
	v_H_1011 = J.arg(a, 1)
	var _t824 = env["sw"]
	var _t826 = J.mul(J.cl(_t824, null, [v_g_1010, 20.0]), 0.04)
	var _t825 = env["sw"]
	return {"armF": _t826, "armB": ((-J.num(J.cl(_t825, null, [v_g_1010, 20.0]))) * 0.04), "head": 0.1}

func _f234(this_, a: Array, env):
	var v_ctx_1012 = null; var v_S_1013 = null; var v_g_1014 = null; var v_m_1015 = null; var v_f_1016 = null; var v_H_1017 = null
	v_ctx_1012 = J.arg(a, 0)
	v_S_1013 = J.arg(a, 1)
	v_g_1014 = J.arg(a, 2)
	v_m_1015 = J.arg(a, 3)
	v_f_1016 = J.arg(a, 4)
	v_H_1017 = J.arg(a, 5)
	var _t827 = env["T"]
	return J.cl(_t827, null, [v_ctx_1012, v_S_1013, J.mul(0.15, v_H_1017), J.mul((-1.05), v_H_1017), J.mul(0.08, v_H_1017), J.gp(["↑", "↓", "A", "B"], J.mod(floor(J.num(J.mul(v_g_1014, 8.0))), 4.0)), "#9fe8ff", 0.9])

func _f235(this_, a: Array, env):
	var v_g_1018 = null; var v_H_1019 = null; var v_k_1020 = null
	v_g_1018 = J.arg(a, 0)
	v_H_1019 = J.arg(a, 1)
	var _t828 = env["bump"]
	v_k_1020 = J.cl(_t828, null, [v_g_1018, 0.1, 0.6])
	return {"armF": J.mul((-0.6), v_k_1020), "armB": J.mul(0.6, v_k_1020), "head": J.mul((-0.2), v_k_1020), "sy": (1.0 + J.mul(0.03, v_k_1020))}

func _f236(this_, a: Array, env):
	var v_ctx_1021 = null; var v_S_1022 = null; var v_g_1023 = null; var v_m_1024 = null; var v_f_1025 = null; var v_H_1026 = null
	v_ctx_1021 = J.arg(a, 0)
	v_S_1022 = J.arg(a, 1)
	v_g_1023 = J.arg(a, 2)
	v_m_1024 = J.arg(a, 3)
	v_f_1025 = J.arg(a, 4)
	v_H_1026 = J.arg(a, 5)
	var _t829 = env["T"]
	var _t831 = J.mul(0.2, v_H_1026)
	var _t832 = J.mul((-1.05), v_H_1026)
	var _t833 = J.mul(0.1, v_H_1026)
	var _t830 = env["bump"]
	return J.cl(_t829, null, [v_ctx_1021, v_S_1022, _t831, _t832, _t833, "呵～", "#9fe8ff", J.cl(_t830, null, [v_g_1023, 0.15, 0.6])])

func _f237(this_, a: Array, env):
	var v_g_1027 = null; var v_H_1028 = null
	v_g_1027 = J.arg(a, 0)
	v_H_1028 = J.arg(a, 1)
	var _t834 = env["sw"]
	var _t836 = (1.0 + J.mul(J.cl(_t834, null, [v_g_1027, 2.0]), 0.1))
	var _t835 = env["sw"]
	var _t838 = J.mul(J.cl(_t835, null, [v_g_1027, 2.0, 1.0]), 6.0)
	var _t839 = J.mul((-0.3), v_H_1028)
	var _t837 = env["sw"]
	var _t841 = J.mul(J.cl(_t837, null, [v_g_1027, 4.0]), 0.2)
	var _t840 = env["sw"]
	return {"sy": _t836, "r": _t838, "px": 0.0, "py": _t839, "armF": _t841, "armB": ((-J.num(J.cl(_t840, null, [v_g_1027, 4.0]))) * 0.2), "y": J.mul((-0.03), v_H_1028)}

func _f238(this_, a: Array, env):
	var v_g_1029 = null; var v_H_1030 = null; var v_k_1031 = null
	v_g_1029 = J.arg(a, 0)
	v_H_1030 = J.arg(a, 1)
	var _t842 = env["bump"]
	v_k_1031 = J.cl(_t842, null, [v_g_1029, 0.1, 0.6])
	return {"sy": (1.0 + J.mul(0.35, v_k_1031)), "sx": (1.0 - J.mul(0.1, v_k_1031))}

func _f239(this_, a: Array, env):
	var v_ctx_1032 = null; var v_S_1033 = null; var v_g_1034 = null; var v_m_1035 = null; var v_f_1036 = null; var v_H_1037 = null
	v_ctx_1032 = J.arg(a, 0)
	v_S_1033 = J.arg(a, 1)
	v_g_1034 = J.arg(a, 2)
	v_m_1035 = J.arg(a, 3)
	v_f_1036 = J.arg(a, 4)
	v_H_1037 = J.arg(a, 5)
	var _t843 = env["T"]
	var _t845 = J.mul(0.25, v_H_1037)
	var _t846 = J.mul((-1.2), v_H_1037)
	var _t847 = J.mul(0.1, v_H_1037)
	var _t848 = ("呼——" if J.cmp(v_g_1034, 0.6, "<") else "噗")
	var _t844 = env["bump"]
	return J.cl(_t843, null, [v_ctx_1032, v_S_1033, _t845, _t846, _t847, _t848, "#ffffff", J.cl(_t844, null, [v_g_1034, 0.1, 0.8])])

func _f1(this_, a: Array, env):
	var v_A_9 = null
	var _s2 = {"__p": env, "ACTS": null, "N": null, "PI": null, "TAU": null, "sw": null, "env": null, "bump": null, "T": null, "note": null, "zz": null, "sweat": null, "flake": null, "coin": null, "card": null, "at": null}
	v_A_9 = Callable(self, "_f5").bind(_s2)
	_s2["ACTS"] = {}
	_s2["N"] = J.G.get("N30K")
	_s2["PI"] = PI
	_s2["TAU"] = J.mul(_s2["PI"], 2.0)
	_s2["sw"] = Callable(self, "_f2").bind(_s2)
	_s2["env"] = Callable(self, "_f3").bind(_s2)
	_s2["bump"] = Callable(self, "_f4").bind(_s2)
	_s2["T"] = Callable(self, "_f7").bind(_s2)
	_s2["note"] = Callable(self, "_f8").bind(_s2)
	_s2["zz"] = Callable(self, "_f9").bind(_s2)
	_s2["sweat"] = Callable(self, "_f10").bind(_s2)
	_s2["flake"] = Callable(self, "_f11").bind(_s2)
	_s2["coin"] = Callable(self, "_f12").bind(_s2)
	_s2["card"] = Callable(self, "_f13").bind(_s2)
	_s2["at"] = Callable(self, "_f14").bind(_s2)
	J.cl(v_A_9, null, ["diaosi", "swing", "晃來晃去", 3.6, "像還吊著一樣，整個人慢慢鐘擺晃，繩子跟著甩。", Callable(self, "_f15").bind(_s2)])
	J.cl(v_A_9, null, ["diaosi", "tongue", "甩舌頭", 2.4, "頭左右甩，長舌頭跟著甩，口水亂噴。", Callable(self, "_f16").bind(_s2), Callable(self, "_f17").bind(_s2)])
	J.cl(v_A_9, null, ["diaosi", "sigh", "嘆氣", 3.2, "肩膀一垂、頭低下去「唉……」。", Callable(self, "_f18").bind(_s2), Callable(self, "_f19").bind(_s2)])
	J.cl(v_A_9, null, ["wutou", "polish", "擦亮自己的頭", 3.0, "另一隻手在捧著的頭上來回擦，擦到發亮。", Callable(self, "_f20").bind(_s2), Callable(self, "_f21").bind(_s2)])
	J.cl(v_A_9, null, ["wutou", "smoke", "脖子冒煙", 3.4, "領口一陣一陣冒煙，聳聳肩。", Callable(self, "_f22").bind(_s2), Callable(self, "_f23").bind(_s2)])
	J.cl(v_A_9, null, ["wutou", "nod", "捧著頭點頭", 2.2, "用手把自己的頭上下點兩下，像在跟人打招呼。", Callable(self, "_f24").bind(_s2)])
	J.cl(v_A_9, null, ["yecha", "flex", "秀肌肉", 2.8, "雙臂一夾、胸口鼓起，紅毛一抖。", Callable(self, "_f25").bind(_s2), Callable(self, "_f26").bind(_s2)])
	J.cl(v_A_9, null, ["yecha", "scratch", "用叉搔背", 3.0, "鋼叉舉到背後上下搔，舒服到瞇眼扭身。", Callable(self, "_f27").bind(_s2), Callable(self, "_f28").bind(_s2)])
	J.cl(v_A_9, null, ["yecha", "roar", "仰天吼", 2.4, "頭往後一仰「吼！」，叉子往地上一頓。", Callable(self, "_f29").bind(_s2), Callable(self, "_f30").bind(_s2)])
	J.cl(v_A_9, null, ["hanba", "fan", "熱到搧風", 2.4, "用手拚命搧臉，滿頭大汗，地上冒熱氣。", Callable(self, "_f31").bind(_s2), Callable(self, "_f32").bind(_s2)])
	J.cl(v_A_9, null, ["hanba", "thirst", "找水喝", 3.4, "東張西望，舔舔乾裂的嘴「水……」。", Callable(self, "_f33").bind(_s2), Callable(self, "_f34").bind(_s2)])
	J.cl(v_A_9, null, ["changgui", "pet", "摸小老虎", 3.0, "彎腰摸摸小老虎的頭，老虎蹭回去，冒愛心。", Callable(self, "_f35").bind(_s2), Callable(self, "_f36").bind(_s2)])
	J.cl(v_A_9, null, ["changgui", "whistle", "吹口哨", 2.6, "手指放嘴邊吹口哨，小老虎跟著搖頭。", Callable(self, "_f37").bind(_s2), Callable(self, "_f38").bind(_s2)])
	J.cl(v_A_9, null, ["guixinniang", "veil", "整理紅蓋頭", 3.2, "雙手扶一扶蓋頭兩邊，蓋頭輕飄。", Callable(self, "_f39").bind(_s2)])
	J.cl(v_A_9, null, ["guixinniang", "twirl", "轉一圈", 2.6, "捧著繡球原地轉一圈，裙襬飄、花瓣落。", Callable(self, "_f40").bind(_s2), Callable(self, "_f41").bind(_s2)])
	J.cl(v_A_9, null, ["guixinniang", "wait", "等新郎", 3.6, "踮著望遠方，嘆一句「良人呢……」。", Callable(self, "_f42").bind(_s2), Callable(self, "_f43").bind(_s2)])
	J.cl(v_A_9, null, ["shanxiao", "hop", "原地單腳跳", 1.6, "單腳一蹦一蹦，長手跟著甩。", Callable(self, "_f44").bind(_s2)])
	J.cl(v_A_9, null, ["shanxiao", "scratch", "抓癢", 2.6, "長手伸到頭頂抓抓抓，毛屑飛。", Callable(self, "_f45").bind(_s2), Callable(self, "_f46").bind(_s2)])
	J.cl(v_A_9, null, ["shanxiao", "balance", "金雞獨立", 3.0, "單腳站著兩手張開，晃來晃去保持平衡。", Callable(self, "_f47").bind(_s2)])
	J.cl(v_A_9, null, ["baigujing", "hair", "攏頭髮", 3.0, "手指慢慢攏一下鬢髮，髮簪的墜子晃。", Callable(self, "_f48").bind(_s2)])
	J.cl(v_A_9, null, ["baigujing", "laugh", "掩嘴笑", 2.4, "手掩著嘴「呵呵呵」，肩膀抖。", Callable(self, "_f49").bind(_s2), Callable(self, "_f50").bind(_s2)])
	J.cl(v_A_9, null, ["baigujing", "pose", "擺姿勢", 3.0, "腰一扭、頭一側，自我欣賞。", Callable(self, "_f51").bind(_s2), Callable(self, "_f52").bind(_s2)])
	J.cl(v_A_9, null, ["qionggui", "pockets", "翻空口袋", 2.8, "把兩個口袋翻出來抖一抖，只抖出灰塵。", Callable(self, "_f53").bind(_s2), Callable(self, "_f54").bind(_s2)])
	J.cl(v_A_9, null, ["qionggui", "coin", "只剩一個銅板", 3.2, "翻出一個銅板，對著它嘆氣「一個……」。", Callable(self, "_f55").bind(_s2), Callable(self, "_f56").bind(_s2)])
	J.cl(v_A_9, null, ["dugui", "shuffle", "洗牌", 2.0, "兩手之間一張張牌飛過去（洗牌），一臉老手。", Callable(self, "_f57").bind(_s2), Callable(self, "_f58").bind(_s2)])
	J.cl(v_A_9, null, ["dugui", "dice", "擲骰子", 2.8, "骰子往地上一擲，滾幾下，看點數，「六！」興奮。", Callable(self, "_f59").bind(_s2), Callable(self, "_f60").bind(_s2)])
	J.cl(v_A_9, null, ["dugui", "pray", "求神拜佛", 2.6, "雙手合十拜三拜「發發發……」。", Callable(self, "_f61").bind(_s2), Callable(self, "_f62").bind(_s2)])
	J.cl(v_A_9, null, ["jiugui", "drink", "喝一口", 3.0, "抱著酒埕仰頭灌一口，「嗝～」冒泡泡。", Callable(self, "_f63").bind(_s2), Callable(self, "_f64").bind(_s2)])
	J.cl(v_A_9, null, ["jiugui", "sway", "醉醺醺晃", 3.4, "東倒西歪，差點跌倒又站穩。", Callable(self, "_f65").bind(_s2)])
	J.cl(v_A_9, null, ["jiugui", "sing", "唱歌", 2.8, "抱著酒埕打拍子唱歌，頭一點一點。", Callable(self, "_f66").bind(_s2), Callable(self, "_f67").bind(_s2)])
	J.cl(v_A_9, null, ["yangui", "puff", "吐煙圈", 3.2, "煙斗湊到嘴邊吸一口，吐出三個煙圈慢慢飄走。", Callable(self, "_f68").bind(_s2), Callable(self, "_f69").bind(_s2)])
	J.cl(v_A_9, null, ["yangui", "cough", "咳不停", 2.4, "彎腰咳咳咳，咳到整個人抖。", Callable(self, "_f70").bind(_s2), Callable(self, "_f71").bind(_s2)])
	J.cl(v_A_9, null, ["guhangui", "count", "數錢", 3.0, "銅錢舉起來對著光看，一枚一枚數「一、二……」。", Callable(self, "_f72").bind(_s2), Callable(self, "_f73").bind(_s2)])
	J.cl(v_A_9, null, ["guhangui", "abacus", "打算盤", 2.4, "算盤搖得嘩啦響，手指撥珠「啪啪啪」。", Callable(self, "_f74").bind(_s2), Callable(self, "_f75").bind(_s2)])
	J.cl(v_A_9, null, ["guhangui", "bite", "咬錢驗真", 2.8, "銅錢放到嘴邊咬一口驗真假，滿意點頭。", Callable(self, "_f76").bind(_s2), Callable(self, "_f77").bind(_s2)])
	J.cl(v_A_9, null, ["taozhai", "shake", "抖欠單", 2.4, "欠單舉高猛抖，一臉兇。", Callable(self, "_f78").bind(_s2)])
	J.cl(v_A_9, null, ["taozhai", "knock", "拍門追數", 2.8, "對著空氣拍門「開門！還錢！」。", Callable(self, "_f79").bind(_s2), Callable(self, "_f80").bind(_s2)])
	J.cl(v_A_9, null, ["taozhai", "paint", "刷紅油", 3.0, "油漆刷沾一沾，在地上刷個「債」字。", Callable(self, "_f81").bind(_s2), Callable(self, "_f82").bind(_s2)])
	J.cl(v_A_9, null, ["danxiao", "shiver", "抖抖抖", 2.0, "抱著自己猛抖，汗一直流。", Callable(self, "_f83").bind(_s2), Callable(self, "_f84").bind(_s2)])
	J.cl(v_A_9, null, ["danxiao", "peek", "偷看", 3.0, "慢慢探頭往前看……「有、有鬼？」。", Callable(self, "_f85").bind(_s2), Callable(self, "_f86").bind(_s2)])
	J.cl(v_A_9, null, ["danxiao", "startle", "自己嚇自己", 2.2, "踩到自己影子嚇一跳「哇！」跳起來。", Callable(self, "_f87").bind(_s2), Callable(self, "_f88").bind(_s2)])
	J.cl(v_A_9, null, ["maoshi", "trip", "跌倒又爬起", 3.0, "腳一絆整個人往前撲，趴一下，拍拍灰爬起來。", Callable(self, "_f89").bind(_s2), Callable(self, "_f90").bind(_s2)])
	J.cl(v_A_9, null, ["maoshi", "rub", "揉頭上的包", 2.6, "手按著頭上的包揉，眼冒金星。", Callable(self, "_f91").bind(_s2), Callable(self, "_f92").bind(_s2)])
	J.cl(v_A_9, null, ["hanturaya", "loom", "漲大又縮回", 3.4, "黑影慢慢膨脹變高，再縮回來，邊緣黑煙翻滾。", Callable(self, "_f93").bind(_s2), {"pre": Callable(self, "_f94").bind(_s2)}])
	J.cl(v_A_9, null, ["hanturaya", "wisp", "冒黑煙", 2.8, "肩上一縷縷黑煙往上飄。", Callable(self, "_f95").bind(_s2), Callable(self, "_f96").bind(_s2)])
	J.cl(v_A_9, null, ["polong", "bob", "在瓶口探頭", 3.0, "縮回瓶口又探出來，左右張望。", Callable(self, "_f97").bind(_s2)])
	J.cl(v_A_9, null, ["polong", "hop", "瓶子跳一跳", 1.8, "整個瓶子蹦兩下，裡面的血絲晃。", Callable(self, "_f98").bind(_s2)])
	J.cl(v_A_9, null, ["pelesit", "chirp", "唧唧叫", 2.2, "翅膀快速磨擦「唧唧」，觸鬚抖。", Callable(self, "_f99").bind(_s2), Callable(self, "_f100").bind(_s2)])
	J.cl(v_A_9, null, ["pelesit", "clean", "洗觸鬚", 2.8, "低頭用前腳把觸鬚拉下來清一清。", Callable(self, "_f101").bind(_s2)])
	J.cl(v_A_9, null, ["pelesit", "hop", "蹦一下", 1.6, "後腿一彈，原地蹦起來。", Callable(self, "_f102").bind(_s2)])
	J.cl(v_A_9, null, ["jenglot", "hairflip", "甩頭髮", 2.6, "一甩頭，整頭長髮甩到一邊再落回。", Callable(self, "_f103").bind(_s2)])
	J.cl(v_A_9, null, ["jenglot", "hiss", "嘶嘶叫", 2.4, "縮著身子露出尖牙「嘶——」。", Callable(self, "_f104").bind(_s2), Callable(self, "_f105").bind(_s2)])
	J.cl(v_A_9, null, ["hantugalah", "peer", "從高處張望", 3.2, "手搭眉毛從很高的地方往遠處看。", Callable(self, "_f106").bind(_s2)])
	J.cl(v_A_9, null, ["hantugalah", "stretch", "伸懶腰", 3.0, "本來就很高，伸個懶腰又更高。", Callable(self, "_f107").bind(_s2)])
	J.cl(v_A_9, null, ["jerangkung", "rattle", "骨頭喀喀抖", 2.0, "全身骨頭抖一抖、喀喀響。", Callable(self, "_f108").bind(_s2), Callable(self, "_f109").bind(_s2)])
	J.cl(v_A_9, null, ["jerangkung", "dance", "骷髏舞", 2.4, "扭腰甩手跳一段骷髏舞。", Callable(self, "_f110").bind(_s2), Callable(self, "_f111").bind(_s2)])
	J.cl(v_A_9, null, ["genderuwo", "chest", "搥胸", 2.2, "兩手輪流搥胸口「咚咚咚」。", Callable(self, "_f112").bind(_s2), Callable(self, "_f113").bind(_s2)])
	J.cl(v_A_9, null, ["genderuwo", "scratch", "抓跳蚤", 2.8, "撓撓肚子，抓到一隻跳蚤彈走。", Callable(self, "_f114").bind(_s2), Callable(self, "_f115").bind(_s2)])
	J.cl(v_A_9, null, ["bunian", "flicker", "時隱時現", 3.2, "身子一下透明一下現形，周圍金色光點飄。", Callable(self, "_f116").bind(_s2), Callable(self, "_f117").bind(_s2)])
	J.cl(v_A_9, null, ["bunian", "flower", "聞花", 3.0, "低頭聞頭上的花，閉眼一笑。", Callable(self, "_f118").bind(_s2), Callable(self, "_f119").bind(_s2)])
	J.cl(v_A_9, null, ["maenak", "reach", "伸手摘芒果", 3.2, "長手往上一伸，在空中摘了什麼，收回來聞一聞。", Callable(self, "_f120").bind(_s2)])
	J.cl(v_A_9, null, ["maenak", "hum", "哼歌搖擺", 3.0, "輕輕左右搖，哼著歌。", Callable(self, "_f121").bind(_s2), Callable(self, "_f122").bind(_s2)])
	J.cl(v_A_9, null, ["maenak", "wait", "等老公", 3.6, "望著遠方輕聲叫「Mak……」。", Callable(self, "_f123").bind(_s2), Callable(self, "_f124").bind(_s2)])
	J.cl(v_A_9, null, ["phiam", "yawn", "打哈欠", 3.0, "大大一個哈欠，睡帽的球甩一下。", Callable(self, "_f125").bind(_s2), Callable(self, "_f126").bind(_s2)])
	J.cl(v_A_9, null, ["phiam", "doze", "打瞌睡", 3.6, "頭慢慢垂下去、Zzz，突然驚醒。", Callable(self, "_f127").bind(_s2), Callable(self, "_f128").bind(_s2)])
	J.cl(v_A_9, null, ["churel", "hair", "撥頭髮", 2.6, "手往後一撥長髮，手環叮噹響。", Callable(self, "_f129").bind(_s2), Callable(self, "_f130").bind(_s2)])
	J.cl(v_A_9, null, ["churel", "dance", "跳舞", 2.4, "扭腰擺手跳一小段舞，腳鈴叮叮響。", Callable(self, "_f131").bind(_s2), Callable(self, "_f132").bind(_s2)])
	J.cl(v_A_9, null, ["vetala", "doze", "拄杖打瞌睡", 3.6, "靠著樹枝杖，頭一點一點打瞌睡。", Callable(self, "_f133").bind(_s2), Callable(self, "_f134").bind(_s2)])
	J.cl(v_A_9, null, ["vetala", "riddle", "出謎題", 3.0, "舉起手指搖一搖「猜猜看？」（屍鬼最愛出謎題）。", Callable(self, "_f135").bind(_s2), Callable(self, "_f136").bind(_s2)])
	J.cl(v_A_9, null, ["kappa", "refill", "補頭上的水", 3.0, "手捧一點水澆到頭頂的碟子，碟裡漾起水紋。", Callable(self, "_f137").bind(_s2), Callable(self, "_f138").bind(_s2)])
	J.cl(v_A_9, null, ["kappa", "cucumber", "啃青瓜", 2.6, "青瓜送到嘴邊「喀嚓喀嚓」啃。", Callable(self, "_f139").bind(_s2), Callable(self, "_f140").bind(_s2)])
	J.cl(v_A_9, null, ["rokurokubi", "stretch", "伸長脖子張望", 3.4, "脖子往上一伸，頭左右張望，再縮回來。", Callable(self, "_f141").bind(_s2)])
	J.cl(v_A_9, null, ["rokurokubi", "yawn", "打哈欠", 3.0, "頭往後一仰打個哈欠，脖子跟著扭。", Callable(self, "_f142").bind(_s2), Callable(self, "_f143").bind(_s2)])
	J.cl(v_A_9, null, ["kuchisake", "snip", "空剪", 2.2, "剪刀在空中咔嚓咔嚓剪兩下。", Callable(self, "_f144").bind(_s2), Callable(self, "_f145").bind(_s2)])
	J.cl(v_A_9, null, ["kuchisake", "ask", "「我漂亮嗎？」", 3.2, "頭一歪，慢慢問「我漂亮嗎？」。", Callable(self, "_f146").bind(_s2), Callable(self, "_f147").bind(_s2)])
	J.cl(v_A_9, null, ["yukionna", "snow", "變出雪花", 3.2, "手心向上，一朵雪花慢慢長大、轉著飄走。", Callable(self, "_f148").bind(_s2), Callable(self, "_f149").bind(_s2)])
	J.cl(v_A_9, null, ["yukionna", "breath", "呵一口冷氣", 2.8, "輕輕呵一口白氣，氣裡結出小冰晶。", Callable(self, "_f150").bind(_s2), Callable(self, "_f151").bind(_s2)])
	J.cl(v_A_9, null, ["kasaobake", "hop", "單腳跳", 1.6, "木屐一蹦一蹦，傘面跟著掀。", Callable(self, "_f152").bind(_s2)])
	J.cl(v_A_9, null, ["kasaobake", "lick", "舔舔嘴", 2.4, "長舌頭甩上來舔一圈。", Callable(self, "_f153").bind(_s2)])
	J.cl(v_A_9, null, ["kasaobake", "spin", "原地轉傘", 2.2, "整把傘原地轉一圈，破紙條飄。", Callable(self, "_f154").bind(_s2)])
	J.cl(v_A_9, null, ["nopperabo", "watch", "看手錶", 2.8, "舉起手腕看錶，跺腳「遲到了！」。", Callable(self, "_f155").bind(_s2), Callable(self, "_f156").bind(_s2)])
	J.cl(v_A_9, null, ["nopperabo", "tie", "整理領帶", 2.6, "兩手拉一拉領帶，挺胸。", Callable(self, "_f157").bind(_s2)])
	J.cl(v_A_9, null, ["chochin", "flicker", "火光忽明忽暗", 2.4, "燈籠裡的火一閃一閃，旁邊的鬼火繞著飄。", Callable(self, "_f158").bind(_s2), {"pre": Callable(self, "_f159").bind(_s2)}])
	J.cl(v_A_9, null, ["chochin", "tongue", "吐舌頭", 2.4, "大舌頭甩出來晃兩下又收回去。", Callable(self, "_f160").bind(_s2)])
	J.cl(v_A_9, null, ["gashadokuro", "rattle", "骨頭喀喀響", 2.4, "整副大骨架抖一抖，喀喀作響。", Callable(self, "_f161").bind(_s2), Callable(self, "_f162").bind(_s2)])
	J.cl(v_A_9, null, ["gashadokuro", "hungry", "肚子餓張望", 3.4, "頭慢慢左右轉，下巴一開一合「餓……」。", Callable(self, "_f163").bind(_s2), Callable(self, "_f164").bind(_s2)])
	J.cl(v_A_9, null, ["banshee", "comb", "梳頭", 3.2, "（傳說她拿著梳子）手一下一下順著長髮往下梳。", Callable(self, "_f165").bind(_s2)])
	J.cl(v_A_9, null, ["banshee", "weep", "低頭哭", 3.2, "低頭啜泣，肩膀一抖一抖，眼淚往下掉。", Callable(self, "_f166").bind(_s2), Callable(self, "_f167").bind(_s2)])
	J.cl(v_A_9, null, ["hannya", "fume", "氣到冒煙", 2.6, "氣得發抖，頭頂冒煙、角尖冒火星。", Callable(self, "_f168").bind(_s2), Callable(self, "_f169").bind(_s2)])
	J.cl(v_A_9, null, ["hannya", "sulk", "哼！", 2.4, "把頭撇到一邊「哼！」。", Callable(self, "_f170").bind(_s2), Callable(self, "_f171").bind(_s2)])
	J.cl(v_A_9, null, ["aswang", "flap", "拍翅膀", 2.0, "背上的翅膀拍幾下，身子跟著一起一伏。", Callable(self, "_f172").bind(_s2)])
	J.cl(v_A_9, null, ["aswang", "sniff", "嗅味道", 3.0, "頭往前伸，一下一下嗅空氣，舌頭甩。", Callable(self, "_f173").bind(_s2), Callable(self, "_f174").bind(_s2)])
	J.cl(v_A_9, null, ["tikbalang", "smoke", "抽雪茄", 3.2, "深吸一口雪茄，鼻孔噴出兩道煙。", Callable(self, "_f175").bind(_s2), Callable(self, "_f176").bind(_s2)])
	J.cl(v_A_9, null, ["tikbalang", "stomp", "踏蹄", 2.2, "前蹄在地上刨兩下，塵土飛。", Callable(self, "_f177").bind(_s2), Callable(self, "_f178").bind(_s2)])
	J.cl(v_A_9, null, ["tikbalang", "mane", "甩鬃毛", 2.4, "頭一甩，鬃毛和尾巴一起甩。", Callable(self, "_f179").bind(_s2)])
	J.cl(v_A_9, null, ["chehuo", "mirror", "照倒後鏡", 2.8, "舉起手上那塊倒後鏡照一照，整理裂開的安全帽。", Callable(self, "_f180").bind(_s2)])
	J.cl(v_A_9, null, ["chehuo", "rev", "催油門", 2.2, "雙手握著空氣車把「嗚嗚～叭叭！」，屁股冒煙。", Callable(self, "_f181").bind(_s2), Callable(self, "_f182").bind(_s2)])
	J.cl(v_A_9, null, ["diansi", "zap", "又被電一下", 2.6, "插頭一閃，全身一抽、頭髮炸更高，冒一縷煙。", Callable(self, "_f183").bind(_s2), Callable(self, "_f184").bind(_s2)])
	J.cl(v_A_9, null, ["diansi", "plug", "找插座", 3.0, "拿著插頭東張西望，想找地方插。", Callable(self, "_f185").bind(_s2), Callable(self, "_f186").bind(_s2)])
	J.cl(v_A_9, null, ["dongsi", "shiver", "冷到發抖", 2.2, "抱緊毯子猛抖，鼻涕冰柱晃。", Callable(self, "_f187").bind(_s2), Callable(self, "_f188").bind(_s2)])
	J.cl(v_A_9, null, ["dongsi", "sneeze", "打噴嚏", 2.4, "「哈……哈啾！」噴出一團雪花。", Callable(self, "_f189").bind(_s2), Callable(self, "_f190").bind(_s2)])
	J.cl(v_A_9, null, ["yezi", "dizzy", "頭暈轉圈", 2.6, "眼冒金星，整個人晃來晃去。", Callable(self, "_f191").bind(_s2), Callable(self, "_f192").bind(_s2)])
	J.cl(v_A_9, null, ["yezi", "lookup", "緊張看天", 3.0, "抱著椰子緊張地抬頭看，怕再掉一顆。", Callable(self, "_f193").bind(_s2), Callable(self, "_f194").bind(_s2)])
	J.cl(v_A_9, null, ["liulian", "sniff", "聞榴槤", 2.8, "把榴槤湊到鼻子前聞一聞，陶醉。", Callable(self, "_f195").bind(_s2), Callable(self, "_f196").bind(_s2)])
	J.cl(v_A_9, null, ["liulian", "rub", "揉頭上的刺孔", 2.6, "手摸摸頭上被刺的地方「痛痛痛」。", Callable(self, "_f197").bind(_s2), Callable(self, "_f198").bind(_s2)])
	J.cl(v_A_9, null, ["yesi", "eat", "又夾一顆湯圓", 3.0, "筷子夾起碗裡的湯圓送進嘴，卡住，捶胸口。", Callable(self, "_f199").bind(_s2), Callable(self, "_f200").bind(_s2)])
	J.cl(v_A_9, null, ["yesi", "cough", "咳咳", 2.2, "彎腰用力咳。", Callable(self, "_f201").bind(_s2), Callable(self, "_f202").bind(_s2)])
	J.cl(v_A_9, null, ["xiaosi", "laugh", "笑到停不下", 2.4, "抱著肚子笑到彎腰、眼淚噴。", Callable(self, "_f203").bind(_s2), Callable(self, "_f204").bind(_s2)])
	J.cl(v_A_9, null, ["xiaosi", "slap", "拍大腿", 2.6, "笑到拍大腿。", Callable(self, "_f205").bind(_s2), Callable(self, "_f206").bind(_s2)])
	J.cl(v_A_9, null, ["xiasi", "jump", "自己嚇自己", 2.2, "聽到聲音嚇到彈起來，頭髮再炸一次。", Callable(self, "_f207").bind(_s2), Callable(self, "_f208").bind(_s2)])
	J.cl(v_A_9, null, ["xiasi", "look", "左顧右盼", 3.0, "緊張地左看右看。", Callable(self, "_f209").bind(_s2)])
	J.cl(v_A_9, null, ["leipi", "smoke", "頭頂冒煙", 2.8, "焦黑的頭冒著煙，咳出一團黑煙。", Callable(self, "_f210").bind(_s2), Callable(self, "_f211").bind(_s2)])
	J.cl(v_A_9, null, ["leipi", "umbrella", "撐破傘", 3.0, "把破傘撐高看天「今天不會再打雷吧……」。", Callable(self, "_f212").bind(_s2), Callable(self, "_f213").bind(_s2)])
	J.cl(v_A_9, null, ["zipai", "selfie", "自拍", 2.6, "舉高自拍棒擺個 YA，「咔嚓」閃一下。", Callable(self, "_f214").bind(_s2), Callable(self, "_f215").bind(_s2)])
	J.cl(v_A_9, null, ["zipai", "check", "看照片", 3.0, "把手機拉回來看照片，點點頭「讚！」。", Callable(self, "_f216").bind(_s2), Callable(self, "_f217").bind(_s2)])
	J.cl(v_A_9, null, ["zhongshu", "wipe", "抹汗", 2.6, "毛巾抹一把臉上的汗，汗水甩出去。", Callable(self, "_f218").bind(_s2), Callable(self, "_f219").bind(_s2)])
	J.cl(v_A_9, null, ["zhongshu", "lick", "舔雪條", 2.8, "雪條在融，趕快舔一口，滴得到處都是。", Callable(self, "_f220").bind(_s2), Callable(self, "_f221").bind(_s2)])
	J.cl(v_A_9, null, ["chengsi", "eat", "繼續吃", 2.4, "叉子叉一口塞進嘴，嚼嚼嚼。", Callable(self, "_f222").bind(_s2), Callable(self, "_f223").bind(_s2)])
	J.cl(v_A_9, null, ["chengsi", "burp", "打飽嗝", 2.6, "肚子一挺「嗝～」，腰帶快爆開。", Callable(self, "_f224").bind(_s2), Callable(self, "_f225").bind(_s2)])
	J.cl(v_A_9, null, ["shedu", "hop", "痛到跳腳", 2.0, "被咬著屁股一跳一跳。", Callable(self, "_f226").bind(_s2), Callable(self, "_f227").bind(_s2)])
	J.cl(v_A_9, null, ["shedu", "shake", "甩蛇", 2.6, "扭屁股想把蛇甩掉，甩不掉。", Callable(self, "_f228").bind(_s2)])
	J.cl(v_A_9, null, ["shidu", "cramp", "肚子痛", 2.6, "抱著肚子彎腰，臉更綠。", Callable(self, "_f229").bind(_s2), Callable(self, "_f230").bind(_s2)])
	J.cl(v_A_9, null, ["shidu", "run", "急著找廁所", 2.0, "抱著廁紙原地小碎步，左右張望。", Callable(self, "_f231").bind(_s2), Callable(self, "_f232").bind(_s2)])
	J.cl(v_A_9, null, ["daji", "play", "狂按手掣", 2.2, "低頭狂按，嘴巴開著流口水。", Callable(self, "_f233").bind(_s2), Callable(self, "_f234").bind(_s2)])
	J.cl(v_A_9, null, ["daji", "yawn", "通宵打呵欠", 3.0, "伸懶腰打個大呵欠，再拿起能量飲料。", Callable(self, "_f235").bind(_s2), Callable(self, "_f236").bind(_s2)])
	J.cl(v_A_9, null, ["xiangcai", "flap", "被風吹", 2.4, "扁扁的身體被風吹得一飄一飄。", Callable(self, "_f237").bind(_s2)])
	J.cl(v_A_9, null, ["xiangcai", "inflate", "吹氣復原", 3.0, "拼命吸氣想鼓回原形，鼓一下又扁回去。", Callable(self, "_f238").bind(_s2), Callable(self, "_f239").bind(_s2)])
	return {"ACTS": _s2["ACTS"]}
