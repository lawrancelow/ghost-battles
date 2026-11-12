# 自動轉譯自 moves_beast.js（tools/jsgd.js）——唔好直接改，改原 JS 再轉
extends RefCounted

func run(env):
	var this_ = null; var a = []
	J.G["jiangshiMove"] = Callable(self, "_f12").bind(env)
	var _t37 = J.G.get("MOVES")
	var _t136 = Callable(self, "_f1").bind(env)
	J.sp(_t37, "eguiking", _t136)
	var _t137 = J.G.get("MOVES")
	var _t216 = Callable(self, "_f7").bind(env)
	J.sp(_t137, "egui", _t216)
	var _t217 = J.G.get("MOVES")
	var _t287 = Callable(self, "_f10").bind(env)
	J.sp(_t217, "xiaogui", _t287)
	var _t288 = J.G.get("MOVES")
	var _t289 = J.G.get("jiangshiMove")
	J.sp(_t288, "laojiang", _t289)
	var _t290 = J.G.get("MOVES")
	var _t291 = J.G.get("jiangshiMove")
	J.sp(_t290, "zombie", _t291)

func _f12(this_, a: Array, env):
	var v_ctx_230 = null; var v_a_231 = null; var v_K_232 = null; var v_S_233 = null; var v_E_234 = null; var v_seg_235 = null; var v_lerp_236 = null; var v_M_237 = null; var v_tt_238 = null; var v_H_239 = null; var v_th_240 = null; var v_D_241 = null; var v_PV_242 = null; var v_TIP_243 = null; var v_tip0_244 = null; var v_EXT_245 = null; var v_Jx_246 = null; var v_Dx_247 = null; var v_Dy_248 = null; var v_HOPS_249 = null; var v_f_250 = null; var v_hy_251 = null; var v_sx_252 = null; var v_sy_253 = null; var v_kJ_254 = null; var v_kH_255 = null; var v_jab_256 = null; var v_jit_257 = null; var v_lean_258 = null; var v_push_259 = null; var v_dx_260 = null; var v_dy_261 = null; var v_stiff_262 = null; var v_bm_263 = null; var v_pv_264 = null; var v_am_265 = null; var v_tp_266 = null; var v_hk_267 = null; var v_t0_268 = null; var v_t1_269 = null; var v_t2_270 = null; var v_t3_271 = null; var v_f0_272 = null; var v_f1_273 = null; var v_hh_274 = null; var v_k_275 = null; var v_q_276 = null; var v_st_277 = null; var v_k_278 = null; var v_tp_279 = null; var v_k_280 = null; var v_o_281 = null
	v_ctx_230 = J.arg(a, 0)
	v_a_231 = J.arg(a, 1)
	v_K_232 = J.G.get("MoveKit")
	v_S_233 = J.mc(v_K_232, "setup", [v_a_231])
	if (not J.t(v_S_233)):
		return false
	var _t1 = J.gp(v_K_232, "E")
	v_E_234 = _t1
	var _t2 = J.gp(v_K_232, "seg")
	v_seg_235 = _t2
	var _t3 = J.gp(v_K_232, "lerp")
	v_lerp_236 = _t3
	var _t4 = J.gp(v_K_232, "M")
	v_M_237 = _t4
	v_tt_238 = J.gp(v_S_233, "tt")
	v_H_239 = J.gp(v_S_233, "H")
	v_th_240 = J.gp(v_S_233, "th")
	v_D_241 = J.div(PI, 180.0)
	v_PV_242 = J.gp(J.gp(v_S_233, "C"), "pivot")
	v_TIP_243 = J.gp(J.gp(v_S_233, "C"), "tip")
	v_tip0_244 = J.mc(v_K_232, "ip", [v_S_233, J.gp(v_TIP_243, 0.0), J.gp(v_TIP_243, 1.0)])
	v_EXT_245 = J.mul(0.17, J.gp(v_S_233, "W"))
	v_Jx_246 = J.sub(J.gp(v_S_233, "tx"), J.mul(0.06, v_th_240))
	v_Dx_247 = J.max_([J.mul((-0.04), v_H_239), J.sub(v_Jx_246, J.add(J.add(J.gp(v_tip0_244, 0.0), v_EXT_245), J.mul(0.04, v_H_239)))])
	v_Dy_248 = J.gp(v_S_233, "ty")
	v_HOPS_249 = [[0.0, 0.03, 0.11, 0.13, 0.0, 0.5, 0.2], [0.13, 0.155, 0.25, 0.2704, 0.5, 1.0, 0.16], [0.355, 0.375, 0.455, 0.47, 1.0, 0.45, 0.14], [0.47, 0.49, 0.565, 0.59, 0.45, 0.0, 0.12]]
	v_f_250 = (0.0 if J.cmp(v_tt_238, 0.13, "<") else ((0.5 if J.cmp(v_tt_238, 0.2704, "<") else 1.0) if J.cmp(v_tt_238, 0.355, "<") else (1.0 if J.cmp(v_tt_238, 0.47, "<") else (0.45 if J.cmp(v_tt_238, 0.59, "<") else 0.0))))
	v_hy_251 = 0.0
	v_sx_252 = 1.0
	v_sy_253 = 1.0
	for _t5 in J.iter(v_HOPS_249):
		var _t6 = J.gp(_t5, 0.0)
		v_t0_268 = _t6
		var _t7 = J.gp(_t5, 1.0)
		v_t1_269 = _t7
		var _t8 = J.gp(_t5, 2.0)
		v_t2_270 = _t8
		var _t9 = J.gp(_t5, 3.0)
		v_t3_271 = _t9
		var _t10 = J.gp(_t5, 4.0)
		v_f0_272 = _t10
		var _t11 = J.gp(_t5, 5.0)
		v_f1_273 = _t11
		var _t12 = J.gp(_t5, 6.0)
		v_hh_274 = _t12
		var _t13 = J.cmp(v_tt_238, v_t0_268, "<")
		if (_t13 if _t13 else J.cmp(v_tt_238, v_t3_271, ">=")):
			continue
		if J.cmp(v_tt_238, v_t1_269, "<"):
			v_k_275 = sin(J.num((J.mul(J.cl(v_seg_235, null, [v_tt_238, v_t0_268, v_t1_269]), PI) * 0.5)))
			var _t14 = (1.0 + J.mul(0.08, v_k_275))
			v_sx_252 = _t14
			var _t15 = (1.0 - J.mul(0.1, v_k_275))
			v_sy_253 = _t15
			v_f_250 = v_f0_272
		else:
			if J.cmp(v_tt_238, v_t2_270, "<"):
				v_q_276 = J.cl(v_seg_235, null, [v_tt_238, v_t1_269, v_t2_270])
				var _t16 = J.cl(v_lerp_236, null, [v_f0_272, v_f1_273, v_q_276])
				v_f_250 = _t16
				var _t17 = (J.mul((J.mul((-J.num(v_hh_274)), v_H_239) * 4.0), v_q_276) * J.sub(1.0, v_q_276))
				v_hy_251 = _t17
				v_st_277 = sin(J.num(J.mul(v_q_276, PI)))
				var _t18 = (1.0 - J.mul(0.05, v_st_277))
				v_sx_252 = _t18
				var _t19 = (1.0 + J.mul(0.07, v_st_277))
				v_sy_253 = _t19
			else:
				v_k_278 = sin(J.num(J.mul(J.cl(v_seg_235, null, [v_tt_238, v_t2_270, v_t3_271]), PI)))
				var _t20 = (1.0 + J.mul(0.09, v_k_278))
				v_sx_252 = _t20
				var _t21 = (1.0 - J.mul(0.11, v_k_278))
				v_sy_253 = _t21
				v_f_250 = v_f1_273
	v_kJ_254 = J.mc(v_E_234, "o3", [J.cl(v_seg_235, null, [v_tt_238, 0.235, J.gp(v_K_232, "TC")])])
	v_kH_255 = J.sub(1.0, J.mc(v_E_234, "io", [J.cl(v_seg_235, null, [v_tt_238, 0.33, 0.37])]))
	v_jab_256 = J.mul(v_kJ_254, v_kH_255)
	var _t22 = J.cmp(v_tt_238, J.gp(v_K_232, "TC"), ">")
	v_jit_257 = (J.mul((sin(J.num(J.mul(v_tt_238, 210.0))) * 0.004), v_H_239) if (J.cmp(v_tt_238, 0.33, "<") if _t22 else _t22) else 0.0)
	v_lean_258 = J.mul(7.0, v_jab_256)
	v_push_259 = J.mul(J.mul(0.03, v_H_239), v_jab_256)
	v_dx_260 = J.add(J.add(J.mul(v_Dx_247, v_f_250), v_push_259), v_jit_257)
	v_dy_261 = J.mul(v_Dy_248, v_f_250)
	v_stiff_262 = (1.0 - J.mul(J.cl(v_seg_235, null, [v_tt_238, 0.0, 0.04]), J.sub(1.0, J.cl(v_seg_235, null, [v_tt_238, 0.55, 0.59]))))
	var _t23 = J.construct(v_M_237, [])
	var _t24 = J.mc(_t23, "t", [v_dx_260, J.add(v_dy_261, v_hy_251)])
	var _t25 = J.mc(_t24, "r", [J.mul(v_lean_258, v_D_241)])
	v_bm_263 = J.mc(_t25, "s", [v_sx_252, v_sy_253])
	v_pv_264 = J.mc(v_K_232, "ip", [v_S_233, J.gp(v_PV_242, 0.0), J.gp(v_PV_242, 1.0)])
	var _t26 = J.mc(v_bm_263, "clone", [])
	var _t27 = J.mc(_t26, "t", [J.add(J.gp(v_pv_264, 0.0), J.mul(v_EXT_245, v_jab_256)), J.sub(J.gp(v_pv_264, 1.0), J.mul(J.mul(0.01, v_H_239), v_jab_256))])
	v_am_265 = J.mc(_t27, "r", [J.mul((J.mul((-4.0), v_jab_256) + ((-3.0) if J.cmp(v_hy_251, 0.0, "<") else 0.0)), v_D_241)])
	J.mc(v_ctx_230, "save", [])
	J.mc(v_K_232, "enter", [v_ctx_230, v_S_233])
	J.mc(v_K_232, "shadow", [v_ctx_230, v_S_233, v_dx_260, v_dy_261, (1.0 - (0.4 * J.min_([1.0, J.div((-J.num(v_hy_251)), J.mul(0.2, v_H_239))])))])
	if J.cmp(v_jab_256, 0.2, ">"):
		v_tp_279 = J.mc(v_K_232, "ppt", [v_S_233, v_am_265, J.gp(v_PV_242, 0.0), J.gp(v_PV_242, 1.0), J.gp(v_TIP_243, 0.0), J.gp(v_TIP_243, 1.0)])
		J.mc(v_K_232, "speed", [v_ctx_230, J.sub(J.gp(v_tp_279, 0.0), J.mul(0.08, v_H_239)), J.gp(v_tp_279, 1.0), 1.0, 0.0, J.mul(0.18, v_H_239), J.mul(0.1, v_H_239), J.mul(v_jab_256, J.sub(1.0, J.cl(v_seg_235, null, [v_tt_238, 0.29, 0.33]))), "rgba(240,235,220,.8)", 13.0, 3.0])
	J.mc(v_K_232, "body", [v_ctx_230, v_S_233, v_bm_263, J.mc(v_K_232, "pose", [v_S_233, null, v_stiff_262])])
	J.mc(v_K_232, "piece", [v_ctx_230, v_S_233, J.add(J.gp(v_S_233, "id"), "__arm"), v_am_265, J.gp(v_PV_242, 0.0), J.gp(v_PV_242, 1.0)])
	v_tp_266 = J.mc(v_K_232, "ppt", [v_S_233, v_am_265, J.gp(v_PV_242, 0.0), J.gp(v_PV_242, 1.0), J.gp(v_TIP_243, 0.0), J.gp(v_TIP_243, 1.0)])
	v_hk_267 = J.sub(1.0, J.cl(v_seg_235, null, [v_tt_238, J.gp(v_K_232, "TC"), J.add(J.gp(v_K_232, "TC"), 0.12)]))
	var _t28 = J.cmp(v_tt_238, J.gp(v_K_232, "TC"), ">=")
	if (J.cmp(v_hk_267, 0.0, ">") if _t28 else _t28):
		J.mc(v_K_232, "burst", [v_ctx_230, J.add(J.gp(v_tp_266, 0.0), J.mul(0.02, v_H_239)), J.gp(v_tp_266, 1.0), J.mul(0.2, v_th_240), v_hk_267, "#fff0c8", 44.0, 10.0])
	var _t29 = J.cmp(v_tt_238, J.sub(J.gp(v_K_232, "TC"), 0.01), ">=")
	if (J.cmp(v_tt_238, 0.33, "<") if _t29 else _t29):
		v_k_280 = J.cl(v_seg_235, null, [v_tt_238, J.sub(J.gp(v_K_232, "TC"), 0.01), 0.33])
		J.mc(v_ctx_230, "save", [])
		var _t30 = J.mul(J.gp(v_ctx_230, "globalAlpha"), J.sub(1.0, v_k_280))
		J.sp(v_ctx_230, "globalAlpha", _t30)
		J.sp(v_ctx_230, "strokeStyle", "#fff6dc")
		var _t31 = J.mul(0.02, v_th_240)
		J.sp(v_ctx_230, "lineWidth", _t31)
		for _t32 in J.iter([(-0.07), 0.03]):
			v_o_281 = _t32
			J.mc(v_ctx_230, "beginPath", [])
			J.mc(v_ctx_230, "ellipse", [J.add(J.gp(v_tp_266, 0.0), J.mul(0.03, v_H_239)), J.add(J.gp(v_tp_266, 1.0), J.mul(v_o_281, v_H_239)), (J.mul(0.03, v_th_240) + J.mul(J.mul(v_k_280, 0.12), v_th_240)), (J.mul(0.08, v_th_240) + J.mul(J.mul(v_k_280, 0.1), v_th_240)), 0.0, (-1.2), 1.2])
			J.mc(v_ctx_230, "stroke", [])
		J.mc(v_ctx_230, "restore", [])
	var _t33 = J.cmp(v_tt_238, 0.13, ">")
	var _t34 = (J.cmp(v_tt_238, 0.25, "<") if _t33 else _t33)
	if (J.cmp(v_hy_251, J.mul((-0.02), v_H_239), "<") if _t34 else _t34):
		J.mc(v_K_232, "speed", [v_ctx_230, J.sub(v_dx_260, J.mul(0.25, J.gp(v_S_233, "W"))), J.sub(J.add(v_dy_261, v_hy_251), J.mul(0.5, v_H_239)), 1.0, 0.3, J.mul(0.12, v_H_239), J.mul(0.4, v_H_239), 0.6, "rgba(230,225,215,.5)", 21.0, 3.0])
	if J.t(J.gp(J.gp(v_S_233, "o"), "hitOut")):
		var _t35 = J.gp(J.gp(v_S_233, "o"), "hitOut")
		var _t36 = {"x": J.add(J.gp(J.gp(v_S_233, "a"), "x"), J.mul(J.gp(v_S_233, "fw"), J.gp(v_tp_266, 0.0))), "y": J.add(J.gp(J.gp(v_S_233, "a"), "y"), J.gp(v_tp_266, 1.0))}
		J.sp(_t35, "p", _t36)
	J.mc(v_ctx_230, "restore", [])

func _f2(this_, a: Array, env):
	var v_t_32 = null; var v_kB_33 = null; var v_kT_34 = null; var v_kF_35 = null; var v_kG_36 = null; var v_kU_37 = null; var v_lean_38 = null; var v_bdx_39 = null; var v_rot_40 = null; var v_wx_41 = null; var v_wy_42 = null; var v_head_43 = null; var v_bp_44 = null; var v_bm_45 = null; var v_pv_46 = null; var v_hm_47 = null
	v_t_32 = J.arg(a, 0)
	var _t38 = env["seg"]
	v_kB_33 = J.mc(env["E"], "o", [J.cl(_t38, null, [v_t_32, 0.0, 0.11])])
	var _t39 = env["seg"]
	v_kT_34 = J.mc(env["E"], "i", [J.cl(_t39, null, [v_t_32, 0.11, 0.18])])
	var _t40 = env["seg"]
	v_kF_35 = J.mc(env["E"], "o", [J.cl(_t40, null, [v_t_32, 0.2, 0.3])])
	var _t41 = env["seg"]
	v_kG_36 = J.mc(env["E"], "io", [J.cl(_t41, null, [v_t_32, 0.34, 0.44])])
	var _t42 = env["seg"]
	v_kU_37 = J.mc(env["E"], "io", [J.cl(_t42, null, [v_t_32, 0.44, 0.59])])
	v_lean_38 = J.mul((-10.0), v_kB_33)
	v_bdx_39 = J.mul((-0.035), v_kB_33)
	v_rot_40 = J.mul((-32.0), v_kB_33)
	v_wx_41 = J.mul((-0.02), v_kB_33)
	v_wy_42 = J.mul((-0.045), v_kB_33)
	v_head_43 = J.mul((-0.1), v_kB_33)
	var _t43 = env["lerp"]
	var _t44 = J.cl(_t43, null, [v_lean_38, 10.0, v_kT_34])
	v_lean_38 = _t44
	var _t45 = env["lerp"]
	var _t46 = J.cl(_t45, null, [v_bdx_39, 0.045, v_kT_34])
	v_bdx_39 = _t46
	var _t47 = env["lerp"]
	var _t48 = J.cl(_t47, null, [v_rot_40, 95.0, v_kT_34])
	v_rot_40 = _t48
	var _t49 = env["lerp"]
	var _t50 = J.cl(_t49, null, [v_wx_41, 0.015, v_kT_34])
	v_wx_41 = _t50
	var _t51 = env["lerp"]
	var _t52 = J.cl(_t51, null, [v_wy_42, 0.0, v_kT_34])
	v_wy_42 = _t52
	var _t53 = env["lerp"]
	var _t54 = J.cl(_t53, null, [v_head_43, 0.1, v_kT_34])
	v_head_43 = _t54
	var _t55 = env["lerp"]
	var _t56 = J.cl(_t55, null, [v_rot_40, 120.0, v_kF_35])
	v_rot_40 = _t56
	var _t57 = env["lerp"]
	var _t58 = J.cl(_t57, null, [v_lean_38, 3.0, v_kG_36])
	v_lean_38 = _t58
	var _t59 = env["lerp"]
	var _t60 = J.cl(_t59, null, [v_bdx_39, 0.01, v_kG_36])
	v_bdx_39 = _t60
	var _t61 = env["lerp"]
	var _t62 = J.cl(_t61, null, [v_rot_40, 172.0, v_kG_36])
	v_rot_40 = _t62
	var _t63 = env["lerp"]
	var _t64 = J.cl(_t63, null, [v_wx_41, 0.01, v_kG_36])
	v_wx_41 = _t64
	var _t65 = env["lerp"]
	var _t66 = J.cl(_t65, null, [v_wy_42, 0.01, v_kG_36])
	v_wy_42 = _t66
	var _t67 = env["lerp"]
	var _t68 = J.cl(_t67, null, [v_head_43, 0.06, v_kG_36])
	v_head_43 = _t68
	var _t69 = J.mul(v_lean_38, J.sub(1.0, v_kU_37))
	v_lean_38 = _t69
	var _t70 = J.mul(v_bdx_39, J.sub(1.0, v_kU_37))
	v_bdx_39 = _t70
	var _t71 = J.mul(v_rot_40, J.sub(1.0, v_kU_37))
	v_rot_40 = _t71
	var _t72 = J.mul(v_wx_41, J.sub(1.0, v_kU_37))
	v_wx_41 = _t72
	var _t73 = J.mul(v_wy_42, J.sub(1.0, v_kU_37))
	v_wy_42 = _t73
	var _t74 = J.mul(v_head_43, J.sub(1.0, v_kU_37))
	v_head_43 = _t74
	v_bp_44 = J.mc(env["K"], "ip", [env["S"], 0.5, 0.8])
	var _t75 = J.construct(env["M"], [])
	var _t76 = J.mc(_t75, "t", [J.mul(v_bdx_39, env["H"]), (-J.num(J.gp(env["S"], "fl")))])
	var _t77 = J.mc(_t76, "t", [J.gp(v_bp_44, 0.0), J.gp(v_bp_44, 1.0)])
	var _t78 = J.mc(_t77, "r", [J.mul(v_lean_38, env["D"])])
	v_bm_45 = J.mc(_t78, "t", [(-J.num(J.gp(v_bp_44, 0.0))), (-J.num(J.gp(v_bp_44, 1.0)))])
	v_pv_46 = J.mc(env["K"], "ip", [env["S"], J.gp(env["PV"], 0.0), J.gp(env["PV"], 1.0)])
	var _t79 = J.mc(v_bm_45, "clone", [])
	var _t80 = J.mc(_t79, "t", [J.add(J.gp(v_pv_46, 0.0), J.mul(v_wx_41, env["H"])), J.add(J.gp(v_pv_46, 1.0), J.mul(v_wy_42, env["H"]))])
	v_hm_47 = J.mc(_t80, "r", [J.mul(v_rot_40, env["D"])])
	var _t81 = J.cmp(v_t_32, 0.37, ">")
	return {"bm": v_bm_45, "hm": v_hm_47, "head": v_head_43, "behind": (J.cmp(v_t_32, 0.455, "<") if _t81 else _t81)}

func _f6(this_, a: Array, env):
	var v_ctx_78 = null; var v_x_79 = null; var v_y_80 = null; var v_h_81 = null; var v_q_82 = null; var v_seed_83 = null; var v_al_84 = null; var v_i_85 = null; var v_ox_86 = null; var v_pts_87 = null; var v_j_88 = null; var v_f_89 = null
	v_ctx_78 = J.arg(a, 0)
	v_x_79 = J.arg(a, 1)
	v_y_80 = J.arg(a, 2)
	v_h_81 = J.arg(a, 3)
	v_q_82 = J.arg(a, 4)
	v_seed_83 = J.arg(a, 5)
	var _t82 = J.cmp(v_q_82, 0.0, "<=")
	if (_t82 if _t82 else J.cmp(v_q_82, 1.0, ">=")):
		return null
	v_al_84 = (sin(J.num(J.mul(v_q_82, PI))) * 0.8)
	v_i_85 = 0.0
	while true:
		if not J.cmp(v_i_85, 3.0, "<"): break
		v_ox_86 = (J.mul(J.sub(v_i_85, 1.0), v_h_81) * 0.28)
		v_pts_87 = []
		v_j_88 = 0.0
		while true:
			if not J.cmp(v_j_88, 8.0, "<="): break
			v_f_89 = J.div(v_j_88, 8.0)
			J.mc(v_pts_87, "push", [[J.add(J.add(v_x_79, v_ox_86), J.mul((J.mul(sin(J.num(((J.mul(v_f_89, 6.0) + J.mul(v_i_85, 2.0)) + J.mul(v_q_82, 8.0)))), v_h_81) * 0.08), J.add(0.4, v_f_89))), (J.sub(v_y_80, (J.mul(v_f_89, v_h_81) * (0.5 + J.mul(v_q_82, 0.7)))) - (J.mul(v_q_82, v_h_81) * 0.3))]])
			v_j_88 = J.num(v_j_88) + 1.0
		J.mc(v_ctx_78, "save", [])
		var _t83 = J.mul(J.gp(v_ctx_78, "globalAlpha"), J.mul(v_al_84, (0.6 + J.mul(0.4, J.mc(env["K"], "rnd", [J.add(v_seed_83, v_i_85)])))))
		J.sp(v_ctx_78, "globalAlpha", _t83)
		J.mc(env["K"], "crayon", [v_ctx_78, v_pts_87, "rgba(250,250,250,.85)", J.mul(v_h_81, 0.07), J.add(v_seed_83, J.mul(v_i_85, 5.0))])
		J.mc(v_ctx_78, "restore", [])
		v_i_85 = J.num(v_i_85) + 1.0

func _f3(this_, a: Array, env):
	var v_m_48 = null; var v_sc_49 = null; var v_c_50 = null
	v_m_48 = J.arg(a, 0)
	v_sc_49 = J.arg(a, 1)
	v_c_50 = J.mc(env["K"], "ppt", [env["S"], v_m_48, J.gp(env["PV"], 0.0), J.gp(env["PV"], 1.0), J.gp(env["BC"], 0.0), J.gp(env["BC"], 1.0)])
	var _t92 = J.mc(v_m_48, "clone", [])
	var _t93 = J.mc(_t92, "t", [J.mul(((1.0 if J.t(J.gp(env["S"], "nr")) else (-1.0)) * J.sub(J.gp(env["BC"], 0.0), J.gp(env["PV"], 0.0))), J.gp(env["S"], "W")), J.mul(J.sub(J.gp(env["BC"], 1.0), J.gp(env["PV"], 1.0)), J.gp(env["S"], "H"))])
	return {"c": v_c_50, "m": J.mc(_t93, "s", [v_sc_49])}

func _f4(this_, a: Array, env):
	var v_b_51 = null
	if J.cmp(env["grow"], 0.01, ">"):
		var _t97 = env["bunAt"]
		v_b_51 = J.cl(_t97, null, [J.gp(env["R"], "hm"), env["grow"]])
		J.mc(env["K"], "piece", [env["ctx"], env["S"], "eguiking__bun", J.gp(v_b_51, "m"), J.gp(env["BC"], 0.0), J.gp(env["BC"], 1.0)])
	J.mc(env["K"], "piece", [env["ctx"], env["S"], "eguiking__hand", J.gp(env["R"], "hm"), J.gp(env["PV"], 0.0), J.gp(env["PV"], 1.0)])

func _f5(this_, a: Array, env):
	var v_x_53 = null; var v_y_54 = null; var v_rot_55 = null; var v_sx_56 = null; var v_sy_57 = null; var v_al_58 = null; var v_m_59 = null
	v_x_53 = J.arg(a, 0)
	v_y_54 = J.arg(a, 1)
	v_rot_55 = J.arg(a, 2)
	v_sx_56 = J.arg(a, 3)
	v_sy_57 = J.arg(a, 4)
	v_al_58 = J.arg(a, 5)
	var _t105 = J.construct(env["M"], [])
	var _t106 = J.mc(_t105, "t", [v_x_53, v_y_54])
	var _t107 = J.mc(_t106, "r", [v_rot_55])
	v_m_59 = J.mc(_t107, "s", [v_sx_56, v_sy_57])
	J.mc(env["K"], "piece", [env["ctx"], env["S"], "eguiking__bun", v_m_59, J.gp(env["BC"], 0.0), J.gp(env["BC"], 1.0), v_al_58])

func _f1(this_, a: Array, env):
	var v_a_5 = null; var v_cl_12 = null; var v_tt_13 = null; var v_th_15 = null; var v_REL_19 = null; var v_rig_20 = null; var v_back_22 = null; var v_Tp_23 = null; var v_R0_24 = null; var v_drawHand_27 = null; var v_bunPiece_28 = null; var v_steam_29 = null; var v_b_52 = null; var v_q_60 = null; var v_x_61 = null; var v_y_62 = null; var v_q2_63 = null; var v_x2_64 = null; var v_y2_65 = null; var v_p_66 = null; var v_bx_67 = null; var v_k_68 = null; var v_k_69 = null; var v_q_70 = null; var v_i_71 = null; var v_an_72 = null; var v_sp_73 = null; var v_px_74 = null; var v_py_75 = null
	var _s2 = {"__p": env, "ctx": null, "K": null, "S": null, "E": null, "seg": null, "lerp": null, "M": null, "H": null, "D": null, "PV": null, "BC": null, "R": null, "bunAt": null, "grow": null}
	_s2["ctx"] = J.arg(a, 0)
	v_a_5 = J.arg(a, 1)
	v_rig_20 = Callable(self, "_f2").bind(_s2)
	v_steam_29 = Callable(self, "_f6").bind(_s2)
	_s2["K"] = J.G.get("MoveKit")
	_s2["S"] = J.mc(_s2["K"], "setup", [v_a_5])
	var _t84 = (not J.t(_s2["S"]))
	var _t85 = (_t84 if _t84 else (not J.t(J.mc(_s2["K"], "ok", ["eguiking__bun"]))))
	if (_t85 if _t85 else (not J.t(J.mc(_s2["K"], "ok", ["eguiking__hand"])))):
		return false
	var _t86 = _s2["K"]
	var _t87 = J.gp(_t86, "E")
	_s2["E"] = _t87
	var _t88 = J.gp(_t86, "seg")
	_s2["seg"] = _t88
	var _t89 = J.gp(_t86, "lerp")
	_s2["lerp"] = _t89
	var _t90 = J.gp(_t86, "M")
	_s2["M"] = _t90
	var _t91 = J.gp(_t86, "cl")
	v_cl_12 = _t91
	v_tt_13 = J.gp(_s2["S"], "tt")
	_s2["H"] = J.gp(_s2["S"], "H")
	v_th_15 = J.gp(_s2["S"], "th")
	_s2["D"] = J.div(PI, 180.0)
	_s2["PV"] = J.gp(J.gp(_s2["S"], "C"), "pivot")
	_s2["BC"] = [0.1329, 0.2928]
	v_REL_19 = 0.145
	_s2["R"] = J.cl(v_rig_20, null, [v_tt_13])
	v_back_22 = J.mc(_s2["K"], "tgtBack", [v_tt_13, v_th_15])
	v_Tp_23 = [J.sub(J.gp(_s2["S"], "tx"), J.mul(0.06, v_th_15)), J.sub(J.gp(_s2["S"], "ty"), J.mul(0.8, v_th_15))]
	v_R0_24 = J.mc(_s2["K"], "ppt", [_s2["S"], J.gp(J.cl(v_rig_20, null, [v_REL_19]), "hm"), J.gp(_s2["PV"], 0.0), J.gp(_s2["PV"], 1.0), J.gp(_s2["BC"], 0.0), J.gp(_s2["BC"], 1.0)])
	_s2["bunAt"] = Callable(self, "_f3").bind(_s2)
	J.mc(_s2["ctx"], "save", [])
	J.mc(_s2["K"], "enter", [_s2["ctx"], _s2["S"]])
	J.mc(_s2["K"], "shadow", [_s2["ctx"], _s2["S"], 0.0, 0.0])
	var _t96 = null
	if J.cmp(v_tt_13, v_REL_19, "<"):
		_t96 = 1.0
	else:
		var _t95 = null
		if J.cmp(v_tt_13, 0.44, "<"):
			_t95 = 0.0
		else:
			var _t94 = _s2["seg"]
			_t95 = J.mc(_s2["E"], "back", [J.cl(_t94, null, [v_tt_13, 0.44, 0.53])])
		_t96 = _t95
	_s2["grow"] = _t96
	v_drawHand_27 = Callable(self, "_f4").bind(_s2)
	if J.t(J.gp(_s2["R"], "behind")):
		J.cl(v_drawHand_27, null, [])
	J.mc(_s2["K"], "body", [_s2["ctx"], _s2["S"], J.gp(_s2["R"], "bm"), J.mc(_s2["K"], "pose", [_s2["S"], {"head": J.gp(_s2["R"], "head")}])])
	if (not J.t(J.gp(_s2["R"], "behind"))):
		J.cl(v_drawHand_27, null, [])
	var _t98 = J.cmp(v_tt_13, 0.45, ">")
	if (J.cmp(v_tt_13, 0.59, "<") if _t98 else _t98):
		var _t99 = _s2["bunAt"]
		v_b_52 = J.cl(_t99, null, [J.gp(_s2["R"], "hm"), 1.0])
		var _t101 = _s2["ctx"]
		var _t102 = J.gp(J.gp(v_b_52, "c"), 0.0)
		var _t103 = J.sub(J.gp(J.gp(v_b_52, "c"), 1.0), J.mul(0.05, _s2["H"]))
		var _t104 = J.mul(0.1, _s2["H"])
		var _t100 = _s2["seg"]
		J.cl(v_steam_29, null, [_t101, _t102, _t103, _t104, J.cl(_t100, null, [v_tt_13, 0.45, 0.59]), 5.0])
	v_bunPiece_28 = Callable(self, "_f5").bind(_s2)
	var _t108 = J.cmp(v_tt_13, v_REL_19, ">=")
	if (J.cmp(v_tt_13, J.gp(_s2["K"], "TC"), "<") if _t108 else _t108):
		var _t109 = _s2["seg"]
		var _t111 = J.mul(J.mc(_s2["E"], "sin", [J.cl(_t109, null, [v_tt_13, v_REL_19, J.gp(_s2["K"], "TC")])]), 0.3)
		var _t110 = _s2["seg"]
		v_q_60 = (_t111 + J.mul(J.cl(_t110, null, [v_tt_13, v_REL_19, J.gp(_s2["K"], "TC")]), 0.7))
		var _t112 = _s2["lerp"]
		v_x_61 = J.cl(_t112, null, [J.gp(v_R0_24, 0.0), J.gp(v_Tp_23, 0.0), v_q_60])
		var _t113 = _s2["lerp"]
		v_y_62 = J.sub(J.cl(_t113, null, [J.gp(v_R0_24, 1.0), J.gp(v_Tp_23, 1.0), v_q_60]), (J.mul((J.mul(0.42, _s2["H"]) * 4.0), v_q_60) * J.sub(1.0, v_q_60)))
		v_q2_63 = J.max_([0.0, J.sub(v_q_60, 0.12)])
		var _t114 = _s2["lerp"]
		v_x2_64 = J.cl(_t114, null, [J.gp(v_R0_24, 0.0), J.gp(v_Tp_23, 0.0), v_q2_63])
		var _t115 = _s2["lerp"]
		v_y2_65 = J.sub(J.cl(_t115, null, [J.gp(v_R0_24, 1.0), J.gp(v_Tp_23, 1.0), v_q2_63]), (J.mul((J.mul(0.42, _s2["H"]) * 4.0), v_q2_63) * J.sub(1.0, v_q2_63)))
		J.mc(_s2["K"], "speed", [_s2["ctx"], v_x_61, v_y_62, J.sub(v_x_61, v_x2_64), J.sub(v_y_62, v_y2_65), J.mul(0.13, _s2["H"]), J.mul(0.07, _s2["H"]), 0.9, "rgba(255,248,230,.75)", 7.0, 3.0])
		J.cl(v_bunPiece_28, null, [v_x_61, v_y_62, J.mul(v_q_60, 7.5), 1.0, 1.0])
	else:
		var _t116 = J.cmp(v_tt_13, J.gp(_s2["K"], "TC"), ">=")
		if (J.cmp(v_tt_13, 0.47, "<") if _t116 else _t116):
			v_p_66 = J.sub(v_tt_13, J.gp(_s2["K"], "TC"))
			v_bx_67 = J.add(J.gp(v_Tp_23, 0.0), v_back_22)
			if J.cmp(v_p_66, 0.035, "<"):
				v_k_69 = sin(J.num(((J.div(v_p_66, 0.035) * PI) * 0.5)))
				J.cl(v_bunPiece_28, null, [v_bx_67, J.add(J.gp(v_Tp_23, 1.0), J.mul(J.mul(0.02, _s2["H"]), v_k_69)), 0.0, (1.0 + J.mul(0.32, v_k_69)), (1.0 - J.mul(0.45, v_k_69))])
			else:
				v_q_70 = J.sub(v_p_66, 0.035)
				var _t118 = J.sub(v_bx_67, J.mul(J.mul(v_q_70, 0.35), _s2["H"]))
				var _t119 = J.sub(J.add(J.add(J.gp(v_Tp_23, 1.0), J.mul(0.02, _s2["H"])), J.mul((J.mul(v_q_70, v_q_70) * 9.0), _s2["H"])), J.mul(J.mul(v_q_70, 0.5), _s2["H"]))
				var _t120 = ((-J.num(v_q_70)) * 9.0)
				var _t121 = (1.32 - J.min_([0.3, J.mul(v_q_70, 3.0)]))
				var _t122 = (0.55 + J.min_([0.4, J.mul(v_q_70, 4.0)]))
				var _t117 = _s2["seg"]
				J.cl(v_bunPiece_28, null, [_t118, _t119, _t120, _t121, _t122, J.sub(1.0, J.cl(_t117, null, [v_tt_13, 0.4, 0.47]))])
			var _t123 = _s2["seg"]
			v_k_68 = J.sub(1.0, J.cl(_t123, null, [v_tt_13, J.add(J.gp(_s2["K"], "TC"), 0.15), J.add(J.gp(_s2["K"], "TC"), 0.26)]))
			J.mc(_s2["ctx"], "save", [])
			var _t124 = _s2["ctx"]
			var _t125 = J.mul(J.gp(_t124, "globalAlpha"), v_k_68)
			J.sp(_t124, "globalAlpha", _t125)
			v_i_71 = 0.0
			while true:
				if not J.cmp(v_i_71, 14.0, "<"): break
				v_an_72 = ((-2.7) + J.mul(J.mc(_s2["K"], "rnd", [v_i_71]), 3.6))
				v_sp_73 = J.mul(J.mul(J.add(0.5, J.mc(_s2["K"], "rnd", [J.add(v_i_71, 30.0)])), 1.25), _s2["H"])
				v_px_74 = J.sub(J.add(v_bx_67, J.mul(J.mul(cos(J.num(v_an_72)), v_sp_73), v_p_66)), J.mul(J.mul(0.15, _s2["H"]), v_p_66))
				v_py_75 = J.add(J.add(J.gp(v_Tp_23, 1.0), J.mul(J.mul(sin(J.num(v_an_72)), v_sp_73), v_p_66)), J.mul(J.mul(J.mul(2.6, _s2["H"]), v_p_66), v_p_66))
				var _t126 = _s2["ctx"]
				var _t127 = ("#8a5a3a" if J.seq(J.mod(v_i_71, 4.0), 3.0) else ("#f6ead6" if J.t(J.mod(v_i_71, 2.0)) else "#eedcc0"))
				J.sp(_t126, "fillStyle", _t127)
				var _t128 = _s2["ctx"]
				J.sp(_t128, "strokeStyle", "rgba(90,60,40,.7)")
				var _t129 = _s2["ctx"]
				J.sp(_t129, "lineWidth", 0.5)
				J.mc(_s2["ctx"], "beginPath", [])
				J.mc(_s2["ctx"], "ellipse", [v_px_74, v_py_75, J.mul(J.mul(0.014, _s2["H"]), J.add(1.0, J.mc(_s2["K"], "rnd", [J.add(v_i_71, 5.0)]))), J.mul(J.mul(0.01, _s2["H"]), J.add(1.0, J.mc(_s2["K"], "rnd", [J.add(v_i_71, 6.0)]))), v_i_71, 0.0, 7.0])
				J.mc(_s2["ctx"], "fill", [])
				J.mc(_s2["ctx"], "stroke", [])
				v_i_71 = J.num(v_i_71) + 1.0
			J.mc(_s2["ctx"], "restore", [])
			if J.cmp(v_p_66, 0.12, "<"):
				J.mc(_s2["K"], "burst", [_s2["ctx"], v_bx_67, J.gp(v_Tp_23, 1.0), J.mul(0.17, v_th_15), (1.0 - J.div(v_p_66, 0.12)), "#fff3d6", 23.0, 10.0])
			var _t131 = _s2["ctx"]
			var _t132 = J.sub(J.gp(v_Tp_23, 1.0), J.mul(0.04, _s2["H"]))
			var _t133 = J.mul(0.16, _s2["H"])
			var _t130 = _s2["seg"]
			J.cl(v_steam_29, null, [_t131, v_bx_67, _t132, _t133, J.cl(_t130, null, [v_tt_13, J.gp(_s2["K"], "TC"), 0.5]), 17.0])
	if J.t(J.gp(J.gp(_s2["S"], "o"), "hitOut")):
		var _t134 = J.gp(J.gp(_s2["S"], "o"), "hitOut")
		var _t135 = {"x": J.add(J.gp(J.gp(_s2["S"], "a"), "x"), J.mul(J.gp(_s2["S"], "fw"), J.gp(v_Tp_23, 0.0))), "y": J.add(J.gp(J.gp(_s2["S"], "a"), "y"), J.gp(v_Tp_23, 1.0))}
		J.sp(_t134, "p", _t135)
	J.mc(_s2["ctx"], "restore", [])

func _f8(this_, a: Array, env):
	var v_t_121 = null; var v_dx_122 = null; var v_dy_123 = null; var v_kC_124 = null; var v_kL_125 = null; var v_kO_126 = null; var v_lean_127 = null; var v_hr_128 = null; var v_hs_129 = null; var v_chomp_130 = null; var v_shakeA_131 = null; var v_bp_132 = null; var v_bm_133 = null; var v_pv_134 = null; var v_hm_135 = null; var v_c_136 = null; var v_p_137 = null
	v_t_121 = J.arg(a, 0)
	v_dx_122 = J.arg(a, 1)
	v_dy_123 = J.arg(a, 2)
	var _t138 = env["seg"]
	v_kC_124 = J.mc(env["E"], "o", [J.cl(_t138, null, [v_t_121, 0.0, 0.15])])
	var _t139 = env["seg"]
	v_kL_125 = J.mc(env["E"], "i", [J.cl(_t139, null, [v_t_121, 0.15, J.gp(env["K"], "TC")])])
	var _t140 = env["seg"]
	v_kO_126 = J.mc(env["E"], "io", [J.cl(_t140, null, [v_t_121, 0.4, 0.59])])
	v_lean_127 = J.mul((-14.0), v_kC_124)
	v_hr_128 = J.mul((-38.0), v_kC_124)
	v_hs_129 = 1.0
	var _t141 = env["lerp"]
	var _t142 = J.cl(_t141, null, [v_lean_127, 16.0, v_kL_125])
	v_lean_127 = _t142
	var _t143 = env["lerp"]
	var _t144 = J.cl(_t143, null, [v_hr_128, 14.0, v_kL_125])
	v_hr_128 = _t144
	v_chomp_130 = 0.0
	for _t145 in J.iter(env["CH"]):
		v_c_136 = _t145
		v_p_137 = J.div(J.sub(v_t_121, v_c_136), 0.045)
		var _t146 = J.cmp(v_p_137, 0.0, ">=")
		if (J.cmp(v_p_137, 1.0, "<") if _t146 else _t146):
			var _t147 = J.max_([v_chomp_130, sin(J.num(J.mul(v_p_137, PI)))])
			v_chomp_130 = _t147
	var _t148 = J.cmp(v_t_121, J.gp(env["K"], "TC"), ">")
	var _t151 = null
	if (J.cmp(v_t_121, 0.4, "<") if _t148 else _t148):
		var _t150 = (sin(J.num((J.sub(v_t_121, J.gp(env["K"], "TC")) * 95.0))) * 7.0)
		var _t149 = env["seg"]
		_t151 = (_t150 * J.sub(1.0, J.cl(_t149, null, [v_t_121, 0.36, 0.4])))
	else:
		_t151 = 0.0
	v_shakeA_131 = _t151
	var _t152 = J.add(v_hr_128, J.add(J.mul(v_chomp_130, 12.0), v_shakeA_131))
	v_hr_128 = _t152
	var _t153 = (1.0 - J.mul(0.09, v_chomp_130))
	v_hs_129 = _t153
	var _t154 = J.mul(v_lean_127, J.sub(1.0, v_kO_126))
	v_lean_127 = _t154
	var _t155 = J.mul(v_hr_128, J.sub(1.0, v_kO_126))
	v_hr_128 = _t155
	v_bp_132 = J.mc(env["K"], "ip", [env["S"], 0.5, 0.85])
	var _t156 = J.construct(env["M"], [])
	var _t157 = J.mc(_t156, "t", [v_dx_122, J.sub(v_dy_123, J.gp(env["S"], "fl"))])
	var _t158 = J.mc(_t157, "t", [J.gp(v_bp_132, 0.0), J.gp(v_bp_132, 1.0)])
	var _t159 = J.mc(_t158, "r", [J.mul(v_lean_127, env["D"])])
	var _t160 = J.mc(_t159, "t", [(-J.num(J.gp(v_bp_132, 0.0))), (-J.num(J.gp(v_bp_132, 1.0)))])
	var _t161 = J.mc(_t160, "t", [J.gp(v_bp_132, 0.0), J.gp(v_bp_132, 1.0)])
	var _t162 = J.mc(_t161, "s", [((1.0 - J.mul(0.05, v_kC_124)) + (J.mul(0.04, v_kL_125) * J.sub(1.0, v_kO_126))), ((1.0 + J.mul(0.06, v_kC_124)) - (J.mul(0.05, v_kL_125) * J.sub(1.0, v_kO_126)))])
	v_bm_133 = J.mc(_t162, "t", [(-J.num(J.gp(v_bp_132, 0.0))), (-J.num(J.gp(v_bp_132, 1.0)))])
	v_pv_134 = J.mc(env["K"], "ip", [env["S"], J.gp(env["PV"], 0.0), J.gp(env["PV"], 1.0)])
	var _t163 = J.mc(v_bm_133, "clone", [])
	var _t164 = J.mc(_t163, "t", [J.gp(v_pv_134, 0.0), J.add(J.gp(v_pv_134, 1.0), J.mul(J.mul(0.015, env["H"]), v_chomp_130))])
	var _t165 = J.mc(_t164, "r", [J.mul(v_hr_128, env["D"])])
	v_hm_135 = J.mc(_t165, "s", [(1.0 + J.mul(0.05, v_chomp_130)), v_hs_129])
	return {"bm": v_bm_133, "hm": v_hm_135, "chomp": v_chomp_130}

func _f9(this_, a: Array, env):
	var v_c_141 = null; var v_i_142 = null; var v_p_143 = null; var v_close_144 = null; var v_al_145 = null; var v_w_146 = null; var v_gap_147 = null; var v_sg_148 = null; var v_pts_149 = null; var v_j_150 = null
	v_c_141 = J.arg(a, 0)
	v_i_142 = J.arg(a, 1)
	v_p_143 = J.div(J.sub(env["tt"], v_c_141), 0.06)
	var _t205 = J.cmp(v_p_143, 0.0, "<")
	if (_t205 if _t205 else J.cmp(v_p_143, 1.0, ">")):
		return null
	v_close_144 = J.min_([1.0, J.mul(v_p_143, 2.2)])
	v_al_145 = (1.0 - (J.max_([0.0, J.sub(v_p_143, 0.5)]) * 2.0))
	v_w_146 = J.mul(0.2, env["th"])
	v_gap_147 = ((J.mul(0.08, env["th"]) * J.sub(1.0, v_close_144)) + J.mul(0.012, env["th"]))
	for _t206 in J.iter([(-1.0), 1.0]):
		v_sg_148 = _t206
		v_pts_149 = []
		v_j_150 = 0.0
		while true:
			if not J.cmp(v_j_150, 6.0, "<="): break
			J.mc(v_pts_149, "push", [[((J.sub(env["bx"], J.div(v_w_146, 2.0)) + J.div(J.mul(v_j_150, v_w_146), 6.0)) + J.mul(J.mul(v_sg_148, 0.01), env["th"])), J.add(J.add(env["by"], J.mul(v_sg_148, v_gap_147)), J.mul((((-J.num(v_sg_148)) if J.t(J.mod(v_j_150, 2.0)) else 0.0) * 0.035), env["th"]))]])
			v_j_150 = J.num(v_j_150) + 1.0
		J.mc(env["ctx"], "save", [])
		var _t207 = env["ctx"]
		var _t208 = J.mul(J.gp(_t207, "globalAlpha"), v_al_145)
		J.sp(_t207, "globalAlpha", _t208)
		J.mc(env["K"], "crayon", [env["ctx"], v_pts_149, "#fffaf0", J.mul(0.022, env["th"]), J.add((50.0 + J.mul(v_i_142, 9.0)), v_sg_148)])
		J.mc(env["ctx"], "restore", [])
	if J.seq(v_i_142, 0.0):
		J.mc(env["K"], "burst", [env["ctx"], env["bx"], env["by"], J.mul(0.2, env["th"]), J.sub(1.0, v_p_143), "#ffe9c8", 61.0, 9.0])
	else:
		J.mc(env["K"], "burst", [env["ctx"], env["bx"], env["by"], J.mul(0.13, env["th"]), (J.sub(1.0, v_p_143) * 0.8), "#ffd6c8", J.add(61.0, v_i_142), 6.0])

func _f7(this_, a: Array, env):
	var v_a_93 = null; var v_MO_105 = null; var v_back_107 = null; var v_Bp_108 = null; var v_rig_109 = null; var v_m0_110 = null; var v_mo_111 = null; var v_Dx_112 = null; var v_Dy_113 = null; var v_dx_114 = null; var v_dy_115 = null; var v_R_116 = null; var v_k_138 = null; var v_q_139 = null; var v_q_140 = null; var v_k_151 = null; var v_sg_152 = null; var v_j_153 = null; var v_x_154 = null; var v_y_155 = null
	var _s20 = {"__p": env, "ctx": null, "K": null, "S": null, "E": null, "seg": null, "lerp": null, "M": null, "tt": null, "H": null, "th": null, "D": null, "PV": null, "CH": null, "bx": null, "by": null}
	_s20["ctx"] = J.arg(a, 0)
	v_a_93 = J.arg(a, 1)
	v_rig_109 = Callable(self, "_f8").bind(_s20)
	_s20["K"] = J.G.get("MoveKit")
	_s20["S"] = J.mc(_s20["K"], "setup", [v_a_93])
	if (not J.t(_s20["S"])):
		return false
	var _t166 = _s20["K"]
	var _t167 = J.gp(_t166, "E")
	_s20["E"] = _t167
	var _t168 = J.gp(_t166, "seg")
	_s20["seg"] = _t168
	var _t169 = J.gp(_t166, "lerp")
	_s20["lerp"] = _t169
	var _t170 = J.gp(_t166, "M")
	_s20["M"] = _t170
	_s20["tt"] = J.gp(_s20["S"], "tt")
	_s20["H"] = J.gp(_s20["S"], "H")
	_s20["th"] = J.gp(_s20["S"], "th")
	_s20["D"] = J.div(PI, 180.0)
	_s20["PV"] = J.gp(J.gp(_s20["S"], "C"), "pivot")
	v_MO_105 = [0.76, 0.27]
	_s20["CH"] = [J.gp(_s20["K"], "TC"), 0.315, 0.36]
	v_back_107 = J.mc(_s20["K"], "tgtBack", [_s20["tt"], _s20["th"]])
	v_Bp_108 = [J.sub(J.gp(_s20["S"], "tx"), J.mul(0.12, _s20["th"])), J.sub(J.gp(_s20["S"], "ty"), J.mul(0.7, _s20["th"]))]
	v_m0_110 = J.cl(v_rig_109, null, [J.gp(_s20["K"], "TC"), 0.0, 0.0])
	v_mo_111 = J.mc(_s20["K"], "ppt", [_s20["S"], J.gp(v_m0_110, "hm"), J.gp(_s20["PV"], 0.0), J.gp(_s20["PV"], 1.0), J.gp(v_MO_105, 0.0), J.gp(v_MO_105, 1.0)])
	v_Dx_112 = J.max_([0.0, J.sub(J.gp(v_Bp_108, 0.0), J.gp(v_mo_111, 0.0))])
	v_Dy_113 = J.sub(J.gp(v_Bp_108, 1.0), J.gp(v_mo_111, 1.0))
	v_dx_114 = null
	v_dy_115 = null
	if J.cmp(_s20["tt"], 0.15, "<"):
		var _t171 = _s20["seg"]
		v_k_138 = J.mc(_s20["E"], "o", [J.cl(_t171, null, [_s20["tt"], 0.0, 0.15])])
		var _t172 = J.mul(J.mul((-0.07), _s20["H"]), v_k_138)
		v_dx_114 = _t172
		var _t173 = J.mul(J.mul(0.01, _s20["H"]), v_k_138)
		v_dy_115 = _t173
	else:
		if J.cmp(_s20["tt"], J.gp(_s20["K"], "TC"), "<"):
			var _t174 = _s20["seg"]
			v_q_139 = J.mc(_s20["E"], "i", [J.cl(_t174, null, [_s20["tt"], 0.15, J.gp(_s20["K"], "TC")])])
			var _t175 = _s20["lerp"]
			var _t176 = J.cl(_t175, null, [J.mul((-0.07), _s20["H"]), v_Dx_112, v_q_139])
			v_dx_114 = _t176
			var _t177 = _s20["lerp"]
			var _t178 = J.sub(J.cl(_t177, null, [J.mul(0.01, _s20["H"]), v_Dy_113, v_q_139]), (J.mul(0.1, _s20["H"]) * sin(J.num(J.mul(v_q_139, PI)))))
			v_dy_115 = _t178
		else:
			if J.cmp(_s20["tt"], 0.4, "<"):
				var _t179 = J.add(J.add(v_Dx_112, v_back_107), J.mul((sin(J.num(J.mul(_s20["tt"], 120.0))) * 0.006), _s20["H"]))
				v_dx_114 = _t179
				v_dy_115 = v_Dy_113
			else:
				var _t180 = _s20["seg"]
				v_q_140 = J.mc(_s20["E"], "io", [J.cl(_t180, null, [_s20["tt"], 0.4, 0.59])])
				var _t181 = _s20["lerp"]
				var _t182 = J.cl(_t181, null, [J.add(v_Dx_112, v_back_107), 0.0, v_q_140])
				v_dx_114 = _t182
				var _t183 = _s20["lerp"]
				var _t184 = J.sub(J.cl(_t183, null, [v_Dy_113, 0.0, v_q_140]), (J.mul(0.12, _s20["H"]) * sin(J.num(J.mul(v_q_140, PI)))))
				v_dy_115 = _t184
	v_R_116 = J.cl(v_rig_109, null, [_s20["tt"], v_dx_114, v_dy_115])
	J.mc(_s20["ctx"], "save", [])
	J.mc(_s20["K"], "enter", [_s20["ctx"], _s20["S"]])
	J.mc(_s20["K"], "shadow", [_s20["ctx"], _s20["S"], v_dx_114, 0.0, (0.8 - (0.15 * J.min_([1.0, J.div(J.max_([0.0, (-J.num(v_dy_115))]), J.mul(0.15, _s20["H"]))])))])
	var _t185 = J.cmp(_s20["tt"], 0.15, ">")
	if (J.cmp(_s20["tt"], J.gp(_s20["K"], "TC"), "<") if _t185 else _t185):
		var _t187 = _s20["ctx"]
		var _t188 = J.sub(v_dx_114, J.mul(0.15, J.gp(_s20["S"], "W")))
		var _t189 = J.add(J.mul((-0.55), _s20["H"]), v_dy_115)
		var _t190 = J.mul(0.22, _s20["H"])
		var _t191 = J.mul(0.35, _s20["H"])
		var _t186 = _s20["seg"]
		J.mc(_s20["K"], "speed", [_t187, _t188, _t189, 1.0, 0.1, _t190, _t191, J.cl(_t186, null, [_s20["tt"], 0.15, 0.22]), "rgba(235,245,225,.6)", 3.0, 4.0])
	var _t202 = _s20["ctx"]
	var _t203 = _s20["S"]
	var _t204 = J.gp(v_R_116, "bm")
	var _t201 = _s20["S"]
	var _t193 = (-0.25)
	var _t192 = _s20["seg"]
	var _t195 = J.mul(_t193, J.cl(_t192, null, [_s20["tt"], 0.15, 0.27]))
	var _t194 = _s20["seg"]
	var _t200 = (_t195 * J.sub(1.0, J.cl(_t194, null, [_s20["tt"], 0.4, 0.59])))
	var _t197 = (-0.35)
	var _t196 = _s20["seg"]
	var _t199 = J.mul(_t197, J.cl(_t196, null, [_s20["tt"], 0.15, 0.27]))
	var _t198 = _s20["seg"]
	J.mc(_s20["K"], "body", [_t202, _t203, _t204, J.mc(_s20["K"], "pose", [_t201, {"tail1": _t200, "tail2": (_t199 * J.sub(1.0, J.cl(_t198, null, [_s20["tt"], 0.4, 0.59])))}])])
	J.mc(_s20["K"], "piece", [_s20["ctx"], _s20["S"], "egui__arm", J.gp(v_R_116, "hm"), J.gp(_s20["PV"], 0.0), J.gp(_s20["PV"], 1.0)])
	_s20["bx"] = J.add(J.gp(v_Bp_108, 0.0), v_back_107)
	_s20["by"] = J.gp(v_Bp_108, 1.0)
	J.mc(_s20["CH"], "forEach", [Callable(self, "_f9").bind(_s20)])
	var _t209 = J.cmp(_s20["tt"], J.gp(_s20["K"], "TC"), ">")
	if (J.cmp(_s20["tt"], 0.55, "<") if _t209 else _t209):
		var _t210 = _s20["seg"]
		v_k_151 = J.sub(1.0, J.cl(_t210, null, [_s20["tt"], 0.42, 0.55]))
		J.mc(_s20["ctx"], "save", [])
		var _t211 = _s20["ctx"]
		var _t212 = J.mul(J.gp(_t211, "globalAlpha"), J.mul(v_k_151, 0.9))
		J.sp(_t211, "globalAlpha", _t212)
		for _t213 in J.iter([(-1.0), 1.0]):
			v_sg_152 = _t213
			v_j_153 = 0.0
			while true:
				if not J.cmp(v_j_153, 4.0, "<"): break
				v_x_154 = (J.sub(_s20["bx"], J.mul(0.06, _s20["th"])) + J.mul(J.mul(v_j_153, 0.04), _s20["th"]))
				v_y_155 = J.add(_s20["by"], J.mul(J.mul(v_sg_152, 0.03), _s20["th"]))
				J.mc(_s20["K"], "crayon", [_s20["ctx"], [[J.sub(v_x_154, J.mul(0.012, _s20["th"])), v_y_155], [v_x_154, J.add(v_y_155, J.mul(J.mul(v_sg_152, 0.014), _s20["th"]))], [J.add(v_x_154, J.mul(0.012, _s20["th"])), v_y_155]], "#a23a3a", J.mul(0.012, _s20["th"]), J.add(J.add(80.0, v_j_153), v_sg_152)])
				v_j_153 = J.num(v_j_153) + 1.0
		J.mc(_s20["ctx"], "restore", [])
	if J.t(J.gp(J.gp(_s20["S"], "o"), "hitOut")):
		var _t214 = J.gp(J.gp(_s20["S"], "o"), "hitOut")
		var _t215 = {"x": J.add(J.gp(J.gp(_s20["S"], "a"), "x"), J.mul(J.gp(_s20["S"], "fw"), _s20["bx"])), "y": J.add(J.gp(J.gp(_s20["S"], "a"), "y"), _s20["by"])}
		J.sp(_t214, "p", _t215)
	J.mc(_s20["ctx"], "restore", [])

func _f11(this_, a: Array, env):
	var v_t_207 = null; var v_q_208 = null; var v_s_209 = null; var v_k_210 = null; var v_q_211 = null; var v_e_212 = null; var v_ph_213 = null
	v_t_207 = J.arg(a, 0)
	if J.cmp(v_t_207, 0.08, "<"):
		var _t218 = env["seg"]
		v_k_210 = J.mc(env["E"], "o", [J.cl(_t218, null, [v_t_207, 0.0, 0.08])])
		return {"p": [J.sub(J.gp(env["home"], 0.0), J.mul(J.mul(0.06, env["H"]), v_k_210)), J.add(J.gp(env["home"], 1.0), J.mul(J.mul(0.02, env["H"]), v_k_210))], "ph": null}
	if J.cmp(v_t_207, 0.15, "<"):
		var _t219 = env["seg"]
		v_q_211 = J.mc(env["E"], "io", [J.cl(_t219, null, [v_t_207, 0.08, 0.15])])
		v_e_212 = [J.sub(env["cx"], env["Rx"]), env["cy"]]
		var _t220 = env["lerp"]
		var _t222 = J.cl(_t220, null, [J.sub(J.gp(env["home"], 0.0), J.mul(0.06, env["H"])), J.gp(v_e_212, 0.0), v_q_211])
		var _t221 = env["lerp"]
		return {"p": [_t222, J.sub(J.cl(_t221, null, [J.add(J.gp(env["home"], 1.0), J.mul(0.02, env["H"])), J.gp(v_e_212, 1.0), v_q_211]), (J.mul(0.08, env["H"]) * sin(J.num(J.mul(v_q_211, PI)))))], "ph": null}
	if J.cmp(v_t_207, 0.33, "<"):
		var _t233 = null
		if J.cmp(v_t_207, J.gp(env["K"], "TC"), "<"):
			var _t223 = env["lerp"]
			var _t227 = PI
			var _t228 = (2.5 * PI)
			var _t224 = env["seg"]
			var _t226 = J.mul(J.mc(env["E"], "sin", [J.cl(_t224, null, [v_t_207, 0.15, J.gp(env["K"], "TC")])]), 0.15)
			var _t225 = env["seg"]
			_t233 = J.cl(_t223, null, [_t227, _t228, (_t226 + J.mul(J.cl(_t225, null, [v_t_207, 0.15, J.gp(env["K"], "TC")]), 0.85))])
		else:
			var _t229 = env["lerp"]
			var _t231 = (2.5 * PI)
			var _t232 = (3.0 * PI)
			var _t230 = env["seg"]
			_t233 = J.cl(_t229, null, [_t231, _t232, J.mc(env["E"], "o", [J.cl(_t230, null, [v_t_207, J.gp(env["K"], "TC"), 0.33])])])
		v_ph_213 = _t233
		return {"p": [J.add(env["cx"], J.mul(cos(J.num(v_ph_213)), env["Rx"])), J.add(env["cy"], J.mul(sin(J.num(v_ph_213)), env["Ry"]))], "ph": v_ph_213}
	var _t234 = env["seg"]
	v_q_208 = J.mc(env["E"], "io", [J.cl(_t234, null, [v_t_207, 0.33, 0.59])])
	v_s_209 = [J.sub(env["cx"], env["Rx"]), env["cy"]]
	var _t235 = env["lerp"]
	var _t237 = J.cl(_t235, null, [J.gp(v_s_209, 0.0), J.gp(env["home"], 0.0), v_q_208])
	var _t236 = env["lerp"]
	return {"p": [_t237, J.sub(J.cl(_t236, null, [J.gp(v_s_209, 1.0), J.gp(env["home"], 1.0), v_q_208]), (J.mul(0.1, env["H"]) * sin(J.num(J.mul(v_q_208, PI)))))], "ph": null}

func _f10(this_, a: Array, env):
	var v_ctx_158 = null; var v_a_159 = null; var v_S_161 = null; var v_M_165 = null; var v_cl_166 = null; var v_tt_167 = null; var v_th_169 = null; var v_D_170 = null; var v_PV_171 = null; var v_BC_172 = null; var v_bc0_173 = null; var v_back_174 = null; var v_at_180 = null; var v_A_181 = null; var v_A2_182 = null; var v_vx_183 = null; var v_vy_184 = null; var v_ph_185 = null; var v_face_186 = null; var v_depth_187 = null; var v_sc_188 = null; var v_hidden_189 = null; var v_bank_190 = null; var v_kU_191 = null; var v_kS_192 = null; var v_kF_193 = null; var v_kR_194 = null; var v_crot_195 = null; var v_m_196 = null; var v_pv_197 = null; var v_cm_198 = null; var v_vxl_199 = null; var v_tail_200 = null; var v_trav_201 = null; var v_hx_202 = null; var v_hy_203 = null; var v_hk_204 = null; var v_sg_214 = null; var v_w_215 = null; var v_i_216 = null; var v_q0_217 = null; var v_q1_218 = null; var v_o_219 = null; var v_yo_220 = null; var v_p_221 = null; var v_k_222 = null; var v_i_223 = null; var v_o_224 = null; var v_pts_225 = null; var v_j_226 = null; var v_f_227 = null
	var _s36 = {"__p": env, "K": null, "E": null, "seg": null, "lerp": null, "H": null, "cx": null, "cy": null, "Rx": null, "Ry": null, "home": null}
	v_ctx_158 = J.arg(a, 0)
	v_a_159 = J.arg(a, 1)
	v_at_180 = Callable(self, "_f11").bind(_s36)
	_s36["K"] = J.G.get("MoveKit")
	v_S_161 = J.mc(_s36["K"], "setup", [v_a_159])
	if (not J.t(v_S_161)):
		return false
	var _t238 = _s36["K"]
	var _t239 = J.gp(_t238, "E")
	_s36["E"] = _t239
	var _t240 = J.gp(_t238, "seg")
	_s36["seg"] = _t240
	var _t241 = J.gp(_t238, "lerp")
	_s36["lerp"] = _t241
	var _t242 = J.gp(_t238, "M")
	v_M_165 = _t242
	var _t243 = J.gp(_t238, "cl")
	v_cl_166 = _t243
	v_tt_167 = J.gp(v_S_161, "tt")
	_s36["H"] = J.gp(v_S_161, "H")
	v_th_169 = J.gp(v_S_161, "th")
	v_D_170 = J.div(PI, 180.0)
	v_PV_171 = J.gp(J.gp(v_S_161, "C"), "pivot")
	v_BC_172 = [0.45, 0.52]
	v_bc0_173 = J.mc(_s36["K"], "ip", [v_S_161, J.gp(v_BC_172, 0.0), J.gp(v_BC_172, 1.0)])
	v_back_174 = J.mc(_s36["K"], "tgtBack", [v_tt_167, v_th_169])
	_s36["cx"] = J.add(J.gp(v_S_161, "tx"), v_back_174)
	_s36["cy"] = J.sub(J.gp(v_S_161, "ty"), J.mul(0.55, v_th_169))
	_s36["Rx"] = J.mul(0.46, v_th_169)
	_s36["Ry"] = J.mul(0.13, v_th_169)
	_s36["home"] = [J.gp(v_bc0_173, 0.0), J.sub(J.gp(v_bc0_173, 1.0), J.gp(v_S_161, "fl"))]
	v_A_181 = J.cl(v_at_180, null, [v_tt_167])
	v_A2_182 = J.cl(v_at_180, null, [J.max_([0.0, J.sub(v_tt_167, 0.012)])])
	v_vx_183 = J.sub(J.gp(J.gp(v_A_181, "p"), 0.0), J.gp(J.gp(v_A2_182, "p"), 0.0))
	v_vy_184 = J.sub(J.gp(J.gp(v_A_181, "p"), 1.0), J.gp(J.gp(v_A2_182, "p"), 1.0))
	v_ph_185 = J.gp(v_A_181, "ph")
	v_face_186 = 1.0
	if (not J.leq(v_ph_185, null)):
		v_sg_214 = (-sin(J.num(v_ph_185)))
		var _t244 = J.max_([(-1.0), J.min_([1.0, J.mul(v_sg_214, 3.2)])])
		v_face_186 = _t244
		if (absf(J.num(v_face_186)) < 0.15):
			var _t245 = (0.15 * (1.0 if J.cmp(v_sg_214, 0.0, ">=") else (-1.0)))
			v_face_186 = _t245
	v_depth_187 = (sin(J.num(v_ph_185)) if (not J.leq(v_ph_185, null)) else 0.0)
	v_sc_188 = (1.0 + J.mul(0.1, v_depth_187))
	var _t246 = (not J.leq(v_ph_185, null))
	v_hidden_189 = (J.cmp(v_depth_187, (-0.15), "<") if _t246 else _t246)
	v_bank_190 = (J.mul(J.cl(v_cl_166, null, [J.div(v_vx_183, J.mul(0.05, _s36["H"])), (-1.0), 1.0]), 14.0) * signf(J.num((v_face_186 if J.t(v_face_186) else 1.0))))
	var _t247 = _s36["seg"]
	v_kU_191 = J.mc(_s36["E"], "o", [J.cl(_t247, null, [v_tt_167, 0.2, 0.255])])
	var _t248 = _s36["seg"]
	v_kS_192 = J.mc(_s36["E"], "i", [J.cl(_t248, null, [v_tt_167, 0.255, J.gp(_s36["K"], "TC")])])
	var _t249 = _s36["seg"]
	v_kF_193 = J.mc(_s36["E"], "o", [J.cl(_t249, null, [v_tt_167, J.gp(_s36["K"], "TC"), 0.31])])
	var _t250 = _s36["seg"]
	v_kR_194 = J.mc(_s36["E"], "io", [J.cl(_t250, null, [v_tt_167, 0.31, 0.4])])
	var _t251 = _s36["lerp"]
	v_crot_195 = J.cl(_t251, null, [0.0, (-70.0), v_kU_191])
	var _t252 = _s36["lerp"]
	var _t253 = J.cl(_t252, null, [v_crot_195, 35.0, v_kS_192])
	v_crot_195 = _t253
	var _t254 = _s36["lerp"]
	var _t255 = J.cl(_t254, null, [v_crot_195, 75.0, v_kF_193])
	v_crot_195 = _t255
	var _t256 = J.mul(v_crot_195, J.sub(1.0, v_kR_194))
	v_crot_195 = _t256
	if J.cmp(v_tt_167, 0.08, "<"):
		var _t258 = (-20.0)
		var _t257 = _s36["seg"]
		var _t259 = J.mul(_t258, J.mc(_s36["E"], "o", [J.cl(_t257, null, [v_tt_167, 0.0, 0.08])]))
		v_crot_195 = _t259
	else:
		if J.cmp(v_tt_167, 0.2, "<"):
			var _t260 = _s36["lerp"]
			var _t262 = (-20.0)
			var _t261 = _s36["seg"]
			var _t263 = J.cl(_t260, null, [_t262, 0.0, J.cl(_t261, null, [v_tt_167, 0.08, 0.2])])
			v_crot_195 = _t263
	var _t264 = J.construct(v_M_165, [])
	var _t265 = J.mc(_t264, "t", [J.gp(J.gp(v_A_181, "p"), 0.0), J.gp(J.gp(v_A_181, "p"), 1.0)])
	var _t266 = J.mc(_t265, "s", [J.mul(v_face_186, v_sc_188), v_sc_188])
	var _t269 = null
	if J.cmp(v_tt_167, 0.08, "<"):
		var _t268 = (-8.0)
		var _t267 = _s36["seg"]
		_t269 = J.mul(_t268, J.mc(_s36["E"], "o", [J.cl(_t267, null, [v_tt_167, 0.0, 0.08])]))
	else:
		_t269 = 0.0
	var _t270 = J.mc(_t266, "r", [J.mul(J.add(v_bank_190, _t269), v_D_170)])
	v_m_196 = J.mc(_t270, "t", [(-J.num(J.gp(v_bc0_173, 0.0))), (-J.num(J.gp(v_bc0_173, 1.0)))])
	v_pv_197 = J.mc(_s36["K"], "ip", [v_S_161, J.gp(v_PV_171, 0.0), J.gp(v_PV_171, 1.0)])
	var _t271 = J.mc(v_m_196, "clone", [])
	var _t272 = J.mc(_t271, "t", [J.gp(v_pv_197, 0.0), J.gp(v_pv_197, 1.0)])
	v_cm_198 = J.mc(_t272, "r", [J.mul(v_crot_195, v_D_170)])
	v_vxl_199 = J.mul(v_vx_183, signf(J.num((v_face_186 if J.t(v_face_186) else 1.0))))
	v_tail_200 = J.cl(v_cl_166, null, [J.div((-J.num(v_vxl_199)), J.mul(0.04, _s36["H"])), (-1.0), 1.0])
	J.mc(v_ctx_158, "save", [])
	J.mc(_s36["K"], "enter", [v_ctx_158, v_S_161])
	var _t274 = J.sub(J.gp(J.gp(v_A_181, "p"), 0.0), J.gp(_s36["home"], 0.0))
	var _t273 = J.sub(J.sub(_s36["cx"], _s36["Rx"]), J.gp(_s36["home"], 0.0))
	v_trav_201 = J.mc(_s36["K"], "cl", [J.div(_t274, (_t273 if J.t(_t273) else 1.0))])
	J.mc(_s36["K"], "shadow", [v_ctx_158, v_S_161, J.sub(J.gp(J.gp(v_A_181, "p"), 0.0), J.gp(v_bc0_173, 0.0)), (J.mul(J.gp(v_S_161, "ty"), v_trav_201) + (J.mul(sin(J.num(v_ph_185)), _s36["Ry"]) if (not J.leq(v_ph_185, null)) else 0.0)), J.mul(0.8, v_sc_188)])
	J.mc(v_ctx_158, "save", [])
	var _t275 = J.mul(J.gp(v_ctx_158, "globalAlpha"), 0.5)
	J.sp(v_ctx_158, "globalAlpha", _t275)
	if J.t(v_hidden_189):
		J.mc(_s36["K"], "clipOut", [v_ctx_158, J.mc(_s36["K"], "tgtBody", [v_S_161, v_back_174])])
	var _t276 = J.cmp(v_tt_167, 0.08, ">")
	if (J.cmp(v_tt_167, 0.5, "<") if _t276 else _t276):
		v_w_215 = 0.0
		while true:
			if not J.cmp(v_w_215, 3.0, "<"): break
			v_i_216 = 0.0
			while true:
				if not J.cmp(v_i_216, 7.0, "<"): break
				v_q0_217 = J.cl(v_at_180, null, [J.max_([0.0, (J.sub(v_tt_167, 0.01) - J.mul(v_i_216, 0.007))])])
				v_q1_218 = J.cl(v_at_180, null, [J.max_([0.0, (J.sub(v_tt_167, 0.01) - J.mul(J.add(v_i_216, 1.0), 0.007))])])
				v_o_219 = J.mul((J.sub(v_w_215, 1.0) * 0.07), _s36["H"])
				v_yo_220 = J.mul((0.18 + J.mul(0.05, v_w_215)), _s36["H"])
				J.mc(v_ctx_158, "save", [])
				var _t277 = J.mul(J.gp(v_ctx_158, "globalAlpha"), ((1.0 - J.div(v_i_216, 7.0)) * 0.7))
				J.sp(v_ctx_158, "globalAlpha", _t277)
				J.mc(_s36["K"], "crayon", [v_ctx_158, [[J.gp(J.gp(v_q0_217, "p"), 0.0), J.add(J.add(J.gp(J.gp(v_q0_217, "p"), 1.0), v_yo_220), J.mul(v_o_219, 0.3))], [J.gp(J.gp(v_q1_218, "p"), 0.0), J.add(J.add(J.gp(J.gp(v_q1_218, "p"), 1.0), v_yo_220), J.mul(v_o_219, 0.3))]], "#e6f7ee", (J.mul(0.018, _s36["H"]) * (1.0 - J.div(v_i_216, 9.0))), J.add((9.0 + J.mul(v_w_215, 13.0)), v_i_216)])
				J.mc(v_ctx_158, "restore", [])
				v_i_216 = J.num(v_i_216) + 1.0
			v_w_215 = J.num(v_w_215) + 1.0
	J.mc(v_ctx_158, "restore", [])
	J.mc(v_ctx_158, "save", [])
	if J.t(v_hidden_189):
		J.mc(_s36["K"], "clipOut", [v_ctx_158, J.mc(_s36["K"], "tgtBody", [v_S_161, v_back_174])])
	J.mc(_s36["K"], "body", [v_ctx_158, v_S_161, v_m_196, J.mc(_s36["K"], "pose", [v_S_161, {"tail1": J.mul(0.45, v_tail_200), "tail2": J.mul(0.7, v_tail_200), "body": 0.0}])])
	J.mc(_s36["K"], "piece", [v_ctx_158, v_S_161, "xiaogui__arm", v_cm_198, J.gp(v_PV_171, 0.0), J.gp(v_PV_171, 1.0)])
	J.mc(v_ctx_158, "restore", [])
	v_hx_202 = _s36["cx"]
	v_hy_203 = _s36["cy"]
	var _t278 = J.cmp(v_tt_167, 0.255, ">")
	if (J.cmp(v_tt_167, 0.45, "<") if _t278 else _t278):
		var _t279 = _s36["seg"]
		v_p_221 = J.cl(_t279, null, [v_tt_167, 0.255, 0.3])
		var _t280 = _s36["seg"]
		v_k_222 = J.sub(1.0, J.cl(_t280, null, [v_tt_167, 0.34, 0.45]))
		J.mc(v_ctx_158, "save", [])
		var _t281 = J.mul(J.gp(v_ctx_158, "globalAlpha"), v_k_222)
		J.sp(v_ctx_158, "globalAlpha", _t281)
		v_i_223 = 0.0
		while true:
			if not J.cmp(v_i_223, 3.0, "<"): break
			v_o_224 = J.mul((J.sub(v_i_223, 1.0) * 0.07), v_th_169)
			v_pts_225 = []
			v_j_226 = 0.0
			while true:
				if not J.cmp(v_j_226, 6.0, "<="): break
				v_f_227 = J.mul(J.div(v_j_226, 6.0), v_p_221)
				J.mc(v_pts_225, "push", [[(J.sub(J.add(v_hx_202, J.mul(0.16, v_th_169)), J.mul(J.mul(v_f_227, 0.3), v_th_169)) + J.mul(v_o_224, 0.4)), J.add(J.add(J.sub(v_hy_203, J.mul(0.16, v_th_169)), v_o_224), J.mul(J.mul(v_f_227, 0.3), v_th_169))]])
				v_j_226 = J.num(v_j_226) + 1.0
			J.mc(_s36["K"], "crayon", [v_ctx_158, v_pts_225, "#6e1820", (J.mul(0.042, v_th_169) * (1.0 - (0.3 * absf(J.num(J.sub(v_i_223, 1.0)))))), J.add(70.0, v_i_223)])
			J.mc(_s36["K"], "crayon", [v_ctx_158, v_pts_225, ("#fff6ea" if J.seq(v_i_223, 1.0) else "#ffd0c4"), (J.mul(0.022, v_th_169) * (1.0 - (0.3 * absf(J.num(J.sub(v_i_223, 1.0)))))), J.add(90.0, v_i_223)])
			v_i_223 = J.num(v_i_223) + 1.0
		J.mc(v_ctx_158, "restore", [])
	var _t282 = _s36["seg"]
	v_hk_204 = J.sub(1.0, J.cl(_t282, null, [v_tt_167, J.gp(_s36["K"], "TC"), J.add(J.gp(_s36["K"], "TC"), 0.12)]))
	var _t283 = J.cmp(v_tt_167, J.gp(_s36["K"], "TC"), ">=")
	if (J.cmp(v_hk_204, 0.0, ">") if _t283 else _t283):
		J.mc(_s36["K"], "burst", [v_ctx_158, v_hx_202, v_hy_203, J.mul(0.2, v_th_169), v_hk_204, "#f2fff0", 33.0, 9.0])
	var _t284 = J.cmp(v_tt_167, 0.08, ">")
	if (J.cmp(v_tt_167, 0.15, "<") if _t284 else _t284):
		J.mc(_s36["K"], "speed", [v_ctx_158, J.sub(J.gp(J.gp(v_A_181, "p"), 0.0), J.mul(0.1, _s36["H"])), J.gp(J.gp(v_A_181, "p"), 1.0), v_vx_183, v_vy_184, J.mul(0.2, _s36["H"]), J.mul(0.25, _s36["H"]), 0.8, "rgba(225,245,235,.7)", 5.0, 4.0])
	if J.t(J.gp(J.gp(v_S_161, "o"), "hitOut")):
		var _t285 = J.gp(J.gp(v_S_161, "o"), "hitOut")
		var _t286 = {"x": J.add(J.gp(J.gp(v_S_161, "a"), "x"), J.mul(J.gp(v_S_161, "fw"), v_hx_202)), "y": J.add(J.gp(J.gp(v_S_161, "a"), "y"), v_hy_203)}
		J.sp(_t285, "p", _t286)
	J.mc(v_ctx_158, "restore", [])
