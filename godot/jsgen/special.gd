# 自動轉譯自 special.js（tools/jsgd.js）——唔好直接改，改原 JS 再轉
extends RefCounted

func run(env):
	var this_ = null; var a = []
	J.G["SPECIAL"] = J.cl(Callable(self, "_f1").bind(env), null, [])

func _f4(this_, a: Array, env):
	var v_type_44 = null; var v_x_45 = null; var v_o_46 = null; var v_now_47 = null; var v_st_48 = null; var v_dt_49 = null; var v_dx_50 = null; var v_best_51 = null; var v_s_52 = null; var v_d_53 = null; var v_i_54 = null; var v_h_55 = null; var v_a_56 = null; var v_k_57 = null; var v_s_58 = null
	v_type_44 = J.arg(a, 0)
	v_x_45 = J.arg(a, 1)
	v_o_46 = J.arg(a, 2)
	v_now_47 = J.S_performance_("now", [])
	if (J.sub(v_now_47, env["lastCall"]) > 6.0):
		env["epoch"] = J.num(env["epoch"]) + 1.0
	env["lastCall"] = v_now_47
	v_st_48 = null
	if (not J.leq(J.gp(v_o_46, "key"), null)):
		var _t1 = J.mc(env["states"], "get", [J.add(J.add(v_type_44, "#"), J.gp(v_o_46, "key"))])
		v_st_48 = _t1
	else:
		v_best_51 = 1000000000.0
		for _t2 in J.iter(J.mc(env["states"], "values", [])):
			v_s_52 = _t2
			var _t3 = (not J.seq(J.gp(v_s_52, "type"), v_type_44))
			var _t4 = (_t3 if _t3 else J.gp(v_s_52, "keyed"))
			var _t5 = (_t4 if J.t(_t4) else (J.sub(v_now_47, J.gp(v_s_52, "seen")) > 400.0))
			if J.t((_t5 if J.t(_t5) else J.seq(J.gp(v_s_52, "ep"), env["epoch"]))):
				continue
			v_d_53 = absf(J.num(J.sub(J.gp(v_s_52, "x"), v_x_45)))
			var _t6 = J.cmp(v_d_53, 30.0, "<")
			if (J.cmp(v_d_53, v_best_51, "<") if _t6 else _t6):
				v_best_51 = v_d_53
				v_st_48 = v_s_52
	if (not J.t(v_st_48)):
		var _t7 = {"type": v_type_44, "keyed": (not J.leq(J.gp(v_o_46, "key"), null)), "x": v_x_45, "seen": J.sub(v_now_47, 16.0), "ep": (-1.0), "L": 0.0, "V": 0.0, "aclk": (-1.0), "atkOn": false, "hclk": (-1.0), "hurtOn": false}
		v_st_48 = _t7
		var _t10 = null
		if (not J.leq(J.gp(v_o_46, "key"), null)):
			_t10 = J.add(J.add(v_type_44, "#"), J.gp(v_o_46, "key"))
		else:
			var _t9 = J.add(v_type_44, "@")
			var _t8 = J.num(env["uid"])
			env["uid"] = _t8 + 1.0
			_t10 = J.add(_t9, _t8)
		J.mc(env["states"], "set", [_t10, v_st_48])
	v_dt_49 = J.div(J.sub(v_now_47, J.gp(v_st_48, "seen")), 1000.0)
	var _t11 = (0.0 if J.cmp(v_dt_49, 0.0, "<") else (0.05 if J.cmp(v_dt_49, 0.05, ">") else v_dt_49))
	v_dt_49 = _t11
	v_dx_50 = J.sub(v_x_45, J.gp(v_st_48, "x"))
	if (absf(J.num(v_dx_50)) > 40.0):
		v_dx_50 = 0.0
	var _t12 = J.sub(J.gp(v_st_48, "L"), ((-J.num(v_dx_50)) if J.t(J.gp(v_o_46, "flip")) else v_dx_50))
	J.sp(v_st_48, "L", _t12)
	v_i_54 = 0.0
	while true:
		if not J.cmp(v_i_54, 2.0, "<"): break
		v_h_55 = J.div(v_dt_49, 2.0)
		v_a_56 = (J.mul((-170.0), J.gp(v_st_48, "L")) - J.mul(9.0, J.gp(v_st_48, "V")))
		var _t13 = J.add(J.gp(v_st_48, "V"), J.mul(v_a_56, v_h_55))
		J.sp(v_st_48, "V", _t13)
		var _t14 = J.add(J.gp(v_st_48, "L"), J.mul(J.gp(v_st_48, "V"), v_h_55))
		J.sp(v_st_48, "L", _t14)
		v_i_54 = J.num(v_i_54) + 1.0
	if J.cmp(J.gp(v_st_48, "L"), 9.0, ">"):
		J.sp(v_st_48, "L", 9.0)
	else:
		if J.cmp(J.gp(v_st_48, "L"), (-9.0), "<"):
			var _t15 = (-9.0)
			J.sp(v_st_48, "L", _t15)
	J.sp(v_st_48, "x", v_x_45)
	J.sp(v_st_48, "seen", v_now_47)
	J.sp(v_st_48, "dt", v_dt_49)
	var _t16 = env["epoch"]
	J.sp(v_st_48, "ep", _t16)
	if (J.sub(v_now_47, env["lastClean"]) > 2000.0):
		env["lastClean"] = v_now_47
		for _t17 in J.iter(env["states"]):
			var _t18 = J.gp(_t17, 0.0)
			v_k_57 = _t18
			var _t19 = J.gp(_t17, 1.0)
			v_s_58 = _t19
			if (J.sub(v_now_47, J.gp(v_s_58, "seen")) > 2000.0):
				J.mc(env["states"], "delete", [v_k_57])
	return v_st_48

func _f10(this_, a: Array, env):
	var v_st_66 = null; var v_o_67 = null; var v_pa_68 = null; var v_ph_69 = null
	v_st_66 = J.arg(a, 0)
	v_o_67 = J.arg(a, 1)
	v_pa_68 = (-1.0)
	v_ph_69 = (-1.0)
	var _t20 = J.gp(v_o_67, "pose")
	var _t21 = (J.gp(env["ATKPOSE"], J.gp(v_o_67, "pose")) if J.t(_t20) else _t20)
	if J.t(((not J.leq(J.gp(v_o_67, "pt"), null)) if J.t(_t21) else _t21)):
		var _t22 = env["ATKPOSE"]
		var _t23 = J.gp(v_o_67, "pose")
		var _t24 = J.mc(_t22, _t23, [J.gp(v_o_67, "pt")])
		v_pa_68 = _t24
	else:
		var _t25 = J.gp(v_o_67, "atk")
		if J.t(((not J.t(J.gp(v_st_66, "atkOn"))) if J.t(_t25) else _t25)):
			J.sp(v_st_66, "aclk", 0.0)
		var _t26 = (not (not J.t(J.gp(v_o_67, "atk"))))
		J.sp(v_st_66, "atkOn", _t26)
		if J.cmp(J.gp(v_st_66, "aclk"), 0.0, ">="):
			var _t27 = J.div(J.gp(v_st_66, "aclk"), env["ADUR"])
			v_pa_68 = _t27
			var _t28 = J.add(J.gp(v_st_66, "aclk"), J.gp(v_st_66, "dt"))
			J.sp(v_st_66, "aclk", _t28)
			if J.cmp(v_pa_68, 1.6, ">"):
				var _t29 = (-1.0)
				J.sp(v_st_66, "aclk", _t29)
	var _t30 = J.seq(J.gp(v_o_67, "pose"), "hurt")
	var _t31 = (_t30 if _t30 else J.seq(J.gp(v_o_67, "pose"), "die"))
	if ((not J.leq(J.gp(v_o_67, "pt"), null)) if _t31 else _t31):
		var _t32 = J.min_([1.0, J.gp(v_o_67, "pt")])
		v_ph_69 = _t32
	else:
		var _t33 = J.gp(v_o_67, "hurt")
		if J.t(((not J.t(J.gp(v_st_66, "hurtOn"))) if J.t(_t33) else _t33)):
			J.sp(v_st_66, "hclk", 0.0)
		var _t34 = (not (not J.t(J.gp(v_o_67, "hurt"))))
		J.sp(v_st_66, "hurtOn", _t34)
		if J.cmp(J.gp(v_st_66, "hclk"), 0.0, ">="):
			var _t35 = J.div(J.gp(v_st_66, "hclk"), env["HDUR"])
			v_ph_69 = _t35
			var _t36 = J.add(J.gp(v_st_66, "hclk"), J.gp(v_st_66, "dt"))
			J.sp(v_st_66, "hclk", _t36)
			if J.cmp(v_ph_69, 1.6, ">"):
				var _t37 = (-1.0)
				J.sp(v_st_66, "hclk", _t37)
	return [v_pa_68, v_ph_69]

func _f28(this_, a: Array, env):
	var v_type_232 = null; var v_img_233 = null; var v_cols_234 = null; var v_rows_235 = null; var v_m_236 = null; var v_cw_237 = null; var v_ch_238 = null; var v_c_239 = null; var v_g_240 = null; var v_d_241 = null; var v_j_242 = null; var v_i_243 = null; var v_any_244 = null; var v_yy_245 = null; var v_xx_246 = null; var v_e_247 = null
	v_type_232 = J.arg(a, 0)
	v_img_233 = J.arg(a, 1)
	v_cols_234 = J.arg(a, 2)
	v_rows_235 = J.arg(a, 3)
	if J.t(J.gp(env["masks"], v_type_232)):
		return J.gp(env["masks"], v_type_232)
	var _t38 = J.new_("Uint8Array", [J.mul(v_cols_234, v_rows_235)])
	v_m_236 = J.mc(_t38, "fill", [1.0])
	v_cw_237 = J.mul(v_cols_234, 6.0)
	v_ch_238 = J.mul(v_rows_235, 6.0)
	v_c_239 = J.S_document_("createElement", ["canvas"])
	J.sp(v_c_239, "width", v_cw_237)
	J.sp(v_c_239, "height", v_ch_238)
	v_g_240 = J.mc(v_c_239, "getContext", ["2d"])
	J.mc(v_g_240, "drawImage", [v_img_233, 0.0, 0.0, v_cw_237, v_ch_238])
	v_d_241 = J.gp(J.mc(v_g_240, "getImageData", [0.0, 0.0, v_cw_237, v_ch_238]), "data")
	v_j_242 = 0.0
	while true:
		if not J.cmp(v_j_242, v_rows_235, "<"): break
		v_i_243 = 0.0
		while true:
			if not J.cmp(v_i_243, v_cols_234, "<"): break
			v_any_244 = 0.0
			v_yy_245 = J.mul(v_j_242, 6.0)
			while true:
				var _t39 = J.cmp(v_yy_245, (J.mul(v_j_242, 6.0) + 6.0), "<")
				if not ((not J.t(v_any_244)) if _t39 else _t39): break
				v_xx_246 = J.mul(v_i_243, 6.0)
				while true:
					if not J.cmp(v_xx_246, (J.mul(v_i_243, 6.0) + 6.0), "<"): break
					if J.cmp(J.gp(v_d_241, (J.mul(J.add(J.mul(v_yy_245, v_cw_237), v_xx_246), 4.0) + 3.0)), 4.0, ">"):
						v_any_244 = 1.0
						break
					v_xx_246 = J.num(v_xx_246) + 1.0
				v_yy_245 = J.num(v_yy_245) + 1.0
			var _t40 = J.add(J.mul(v_j_242, v_cols_234), v_i_243)
			J.sp(v_m_236, _t40, v_any_244)
			v_i_243 = J.num(v_i_243) + 1.0
		v_j_242 = J.num(v_j_242) + 1.0
	var _t41 = env["masks"]
	J.sp(_t41, v_type_232, v_m_236)
	return v_m_236

func _f29(this_, a: Array, env):
	var v_def_251 = null; var v_idx_252 = null; var v_t_253 = null; var v_pa_254 = null; var v_ph_255 = null; var v_o_256 = null; var v_G_257 = null; var v_base_258 = null; var v_m_259 = null; var v_lg_260 = null
	v_def_251 = J.arg(a, 0)
	v_idx_252 = J.arg(a, 1)
	v_t_253 = J.arg(a, 2)
	v_pa_254 = J.arg(a, 3)
	v_ph_255 = J.arg(a, 4)
	v_o_256 = J.arg(a, 5)
	v_G_257 = J.gp(env["GC"], v_idx_252)
	if J.seq(J.gp(v_G_257, "ok"), env["frameId"]):
		return v_G_257
	v_base_258 = J.div(v_idx_252, 60.0)
	if J.seq(v_idx_252, 0.0):
		J.mc(v_def_251, "drive", [v_G_257, v_t_253, v_pa_254, v_ph_255, v_o_256, 1.0])
	else:
		J.sp(v_G_257, "sy", 0.0)
		J.sp(v_G_257, "sx", 0.0)
		J.sp(v_G_257, "r", 0.0)
		J.sp(v_G_257, "y", 0.0)
		J.sp(v_G_257, "x", 0.0)
		v_m_259 = 0.0
		while true:
			if not J.cmp(v_m_259, 5.0, "<"): break
			v_lg_260 = J.mul(v_base_258, (0.3 + J.mul(0.35, v_m_259)))
			J.mc(v_def_251, "drive", [env["TMP"], J.sub(v_t_253, v_lg_260), (J.sub(v_pa_254, J.div(v_lg_260, env["ADUR"])) if J.cmp(v_pa_254, 0.0, ">=") else (-1.0)), (J.sub(v_ph_255, J.div(v_lg_260, env["HDUR"])) if J.cmp(v_ph_255, 0.0, ">=") else (-1.0)), v_o_256, exp(J.num(((-J.num(v_lg_260)) * 18.0)))])
			var _t42 = J.add(J.gp(v_G_257, "x"), J.mul(J.gp(env["TMP"], "x"), 0.2))
			J.sp(v_G_257, "x", _t42)
			var _t43 = J.add(J.gp(v_G_257, "y"), J.mul(J.gp(env["TMP"], "y"), 0.2))
			J.sp(v_G_257, "y", _t43)
			var _t44 = J.add(J.gp(v_G_257, "r"), J.mul(J.gp(env["TMP"], "r"), 0.2))
			J.sp(v_G_257, "r", _t44)
			var _t45 = J.add(J.gp(v_G_257, "sx"), J.mul(J.gp(env["TMP"], "sx"), 0.2))
			J.sp(v_G_257, "sx", _t45)
			var _t46 = J.add(J.gp(v_G_257, "sy"), J.mul(J.gp(env["TMP"], "sy"), 0.2))
			J.sp(v_G_257, "sy", _t46)
			v_m_259 = J.num(v_m_259) + 1.0
	var _t47 = cos(J.num(J.gp(v_G_257, "r")))
	J.sp(v_G_257, "c", _t47)
	var _t48 = sin(J.num(J.gp(v_G_257, "r")))
	J.sp(v_G_257, "s", _t48)
	var _t49 = env["frameId"]
	J.sp(v_G_257, "ok", _t49)
	return v_G_257

func _f30(this_, a: Array, env):
	var v_G_263 = null; var v_bx_264 = null; var v_by_265 = null; var v_px_266 = null; var v_py_267 = null; var v_out_268 = null; var v_dx_269 = null; var v_dy_270 = null
	v_G_263 = J.arg(a, 0)
	v_bx_264 = J.arg(a, 1)
	v_by_265 = J.arg(a, 2)
	v_px_266 = J.arg(a, 3)
	v_py_267 = J.arg(a, 4)
	v_out_268 = J.arg(a, 5)
	v_dx_269 = J.mul(J.sub(v_bx_264, v_px_266), J.gp(v_G_263, "sx"))
	v_dy_270 = J.mul(J.sub(v_by_265, v_py_267), J.gp(v_G_263, "sy"))
	var _t50 = J.add(J.sub(J.add(v_px_266, J.mul(v_dx_269, J.gp(v_G_263, "c"))), J.mul(v_dy_270, J.gp(v_G_263, "s"))), J.gp(v_G_263, "x"))
	J.sp(v_out_268, "x", _t50)
	var _t51 = J.add(J.add(J.add(v_py_267, J.mul(v_dx_269, J.gp(v_G_263, "s"))), J.mul(v_dy_270, J.gp(v_G_263, "c"))), J.gp(v_G_263, "y"))
	J.sp(v_out_268, "y", _t51)

func _f31(this_, a: Array, env):
	var v_ctx_273 = null; var v_img_274 = null; var v_M_275 = null; var v_G_276 = null; var v_x0_277 = null; var v_y0_278 = null; var v_s_279 = null; var v_Wd_280 = null; var v_H_281 = null; var v_px_282 = null; var v_py_283 = null; var v_a_284 = null; var v_b_285 = null; var v_c_286 = null; var v_d_287 = null; var v_e_288 = null; var v_f_289 = null; var v_la_290 = null; var v_lb_291 = null; var v_lc_292 = null; var v_ld_293 = null; var v_le_294 = null; var v_lf_295 = null
	v_ctx_273 = J.arg(a, 0)
	v_img_274 = J.arg(a, 1)
	v_M_275 = J.arg(a, 2)
	v_G_276 = J.arg(a, 3)
	v_x0_277 = J.arg(a, 4)
	v_y0_278 = J.arg(a, 5)
	v_s_279 = J.arg(a, 6)
	v_Wd_280 = J.arg(a, 7)
	v_H_281 = J.arg(a, 8)
	v_px_282 = J.arg(a, 9)
	v_py_283 = J.arg(a, 10)
	v_a_284 = J.mul(J.gp(v_G_276, "sx"), J.gp(v_G_276, "c"))
	v_b_285 = J.mul(J.gp(v_G_276, "sx"), J.gp(v_G_276, "s"))
	v_c_286 = J.mul((-J.num(J.gp(v_G_276, "sy"))), J.gp(v_G_276, "s"))
	v_d_287 = J.mul(J.gp(v_G_276, "sy"), J.gp(v_G_276, "c"))
	v_e_288 = J.sub(J.add(v_px_282, J.gp(v_G_276, "x")), (J.mul(v_a_284, v_px_282) + J.mul(v_c_286, v_py_283)))
	v_f_289 = J.sub(J.add(v_py_283, J.gp(v_G_276, "y")), (J.mul(v_b_285, v_px_282) + J.mul(v_d_287, v_py_283)))
	v_la_290 = J.mul(v_a_284, v_s_279)
	v_lb_291 = J.mul(v_b_285, v_s_279)
	v_lc_292 = J.mul(v_c_286, v_s_279)
	v_ld_293 = J.mul(v_d_287, v_s_279)
	v_le_294 = J.add(J.mul(v_e_288, v_s_279), v_x0_277)
	v_lf_295 = J.add(J.mul(v_f_289, v_s_279), v_y0_278)
	J.mc(v_ctx_273, "setTransform", [(J.mul(J.gp(v_M_275, "a"), v_la_290) + J.mul(J.gp(v_M_275, "c"), v_lb_291)), (J.mul(J.gp(v_M_275, "b"), v_la_290) + J.mul(J.gp(v_M_275, "d"), v_lb_291)), (J.mul(J.gp(v_M_275, "a"), v_lc_292) + J.mul(J.gp(v_M_275, "c"), v_ld_293)), (J.mul(J.gp(v_M_275, "b"), v_lc_292) + J.mul(J.gp(v_M_275, "d"), v_ld_293)), J.add((J.mul(J.gp(v_M_275, "a"), v_le_294) + J.mul(J.gp(v_M_275, "c"), v_lf_295)), J.gp(v_M_275, "e")), J.add((J.mul(J.gp(v_M_275, "b"), v_le_294) + J.mul(J.gp(v_M_275, "d"), v_lf_295)), J.gp(v_M_275, "f"))])
	J.mc(v_ctx_273, "drawImage", [v_img_274, J.div((-J.num(v_Wd_280)), 2.0), (-J.num(v_H_281)), v_Wd_280, v_H_281])

func _f32(this_, a: Array, env):
	var v_ctx_298 = null; var v_x0_299 = null; var v_y0_300 = null; var v_s_301 = null; var v_k_302 = null; var v_big_303 = null; var v_n_304 = null; var v_a_305 = null; var v_i_306 = null; var v_sd_307 = null; var v_d_308 = null; var v_rr_309 = null
	v_ctx_298 = J.arg(a, 0)
	v_x0_299 = J.arg(a, 1)
	v_y0_300 = J.arg(a, 2)
	v_s_301 = J.arg(a, 3)
	v_k_302 = J.arg(a, 4)
	v_big_303 = J.arg(a, 5)
	var _t52 = J.cmp(v_k_302, 0.0, "<=")
	if (_t52 if _t52 else J.cmp(v_k_302, 1.0, ">=")):
		return null
	v_n_304 = (5.0 if J.t(v_big_303) else 3.0)
	v_a_305 = (J.sub(1.0, v_k_302) * (0.55 if J.t(v_big_303) else 0.4))
	J.mc(v_ctx_298, "save", [])
	var _t53 = ("rgba(214,204,184," + J.str(J.mc(v_a_305, "toFixed", [3.0])) + ")")
	J.sp(v_ctx_298, "fillStyle", _t53)
	v_i_306 = 0.0
	while true:
		if not J.cmp(v_i_306, v_n_304, "<"): break
		for _t54 in J.iter([(-1.0), 1.0]):
			v_sd_307 = _t54
			v_d_308 = (((10.0 if J.t(v_big_303) else 6.0) + J.mul(v_k_302, (18.0 if J.t(v_big_303) else 10.0))) + J.mul(v_i_306, 3.2))
			v_rr_309 = (((3.4 if J.t(v_big_303) else 2.4) * (0.6 + J.mul(v_k_302, 0.9))) * (1.0 - J.mul(v_i_306, 0.12)))
			J.mc(v_ctx_298, "beginPath", [])
			J.mc(v_ctx_298, "ellipse", [J.add(v_x0_299, J.mul(J.mul(v_sd_307, v_d_308), v_s_301)), J.sub(v_y0_300, J.mul(((1.0 + J.mul(v_i_306, 0.6)) + (J.mul(v_k_302, 2.5) * (1.0 + J.band(v_i_306, 1.0)))), v_s_301)), J.mul(v_rr_309, v_s_301), J.mul(J.mul(v_rr_309, 0.7), v_s_301), 0.0, 0.0, env["TAU"]])
			J.mc(v_ctx_298, "fill", [])
		v_i_306 = J.num(v_i_306) + 1.0
	J.mc(v_ctx_298, "restore", [])

func _f33(this_, a: Array, env):
	var v_ctx_312 = null; var v_type_313 = null; var v_x0_314 = null; var v_y0_315 = null; var v_s_316 = null; var v_o_317 = null; var v_def_318 = null; var v_img_319 = null; var v_iw_320 = null; var v_ih_321 = null; var v_t_322 = null; var v_H_323 = null; var v_Wd_324 = null; var v_cols_325 = null; var v_rows_326 = null; var v_st_327 = null; var v_pa_328 = null; var v_ph_329 = null; var v_px_330 = null; var v_py_331 = null; var v_dustK_332 = null; var v_dustBig_333 = null; var v_nx_334 = null; var v_out_335 = null; var v_mnX_336 = null; var v_mnY_337 = null; var v_M_338 = null; var v_mk_339 = null; var v_cw_340 = null; var v_ch_341 = null; var v_Ms_342 = null; var v_f_343 = null; var v_h_344 = null; var v_j_345 = null; var v_v_346 = null; var v_i_347 = null; var v_u_348 = null; var v_bx_349 = null; var v_by_350 = null; var v_G0_351 = null; var v_X_352 = null; var v_Y_353 = null; var v_lf_354 = null; var v_k_355 = null; var v_g_356 = null; var v_X0_357 = null; var v_Y0_358 = null; var v_li_359 = null; var v_fr_360 = null; var v_ax_361 = null; var v_ay_362 = null; var v_ddx_363 = null; var v_ddy_364 = null; var v_m_365 = null; var v_q_366 = null; var v_j_367 = null; var v_i_368 = null; var v_k_369 = null; var v_i_370 = null; var v_j_371 = null; var v_k_372 = null; var v_G0_373 = null; var v_G2_374 = null; var v_spd_375 = null; var v_base_376 = null; var v_amt_377 = null; var v_i_378 = null; var v_j_379 = null; var v_i_380 = null; var v_k00_381 = null; var v_k10_382 = null; var v_k01_383 = null; var v_k11_384 = null; var v_ex_385 = null; var v_ey_386 = null; var v_fx_387 = null; var v_fy_388 = null; var v_ox_389 = null; var v_oy_390 = null; var v_twS_391 = null; var v_lx_392 = null; var v_ly_393 = null; var v_aL_394 = null; var v_aR_395 = null; var v_aT_396 = null; var v_aB_397 = null; var v_sx0_398 = null; var v_sx1_399 = null; var v_sy0_400 = null; var v_sy1_401 = null
	v_ctx_312 = J.arg(a, 0)
	v_type_313 = J.arg(a, 1)
	v_x0_314 = J.arg(a, 2)
	v_y0_315 = J.arg(a, 3)
	v_s_316 = J.arg(a, 4)
	v_o_317 = J.arg(a, 5)
	v_def_318 = J.gp(env["C"], v_type_313)
	v_img_319 = J.gp(J.G.get("SPR"), v_type_313)
	v_iw_320 = J.gp(v_img_319, "naturalWidth")
	v_ih_321 = J.gp(v_img_319, "naturalHeight")
	var _t55 = J.gp(v_o_317, "t")
	v_t_322 = (_t55 if J.t(_t55) else 0.0)
	v_H_323 = J.gp(env["H0"], v_type_313)
	v_Wd_324 = J.div(J.mul(v_H_323, v_iw_320), v_ih_321)
	v_cols_325 = J.gp(J.gp(v_def_318, "grid"), 0.0)
	v_rows_326 = J.gp(J.gp(v_def_318, "grid"), 1.0)
	var _t56 = env["getState"]
	v_st_327 = J.cl(_t56, null, [v_type_313, v_x0_314, v_o_317])
	var _t57 = env["progress"]
	var _t58 = J.cl(_t57, null, [v_st_327, v_o_317])
	var _t59 = J.gp(_t58, 0.0)
	v_pa_328 = _t59
	var _t60 = J.gp(_t58, 1.0)
	v_ph_329 = _t60
	env["frameId"] = J.num(env["frameId"]) + 1.0
	v_px_330 = J.mul(J.sub(J.gp(v_def_318, "pu"), 0.5), v_Wd_324)
	v_py_331 = J.mul((-J.sub(1.0, J.gp(v_def_318, "pv"))), v_H_323)
	var _t61 = env["P"]
	J.sp(_t61, "t", v_t_322)
	var _t62 = env["P"]
	var _t63 = J.div(J.gp(v_st_327, "L"), J.max_([0.3, v_s_316]))
	J.sp(_t62, "L", _t63)
	var _t64 = env["P"]
	J.sp(_t64, "Wd", v_Wd_324)
	var _t65 = env["P"]
	J.sp(_t65, "H", v_H_323)
	var _t66 = env["P"]
	J.sp(_t66, "flop", 0.0)
	var _t67 = env["P"]
	J.sp(_t67, "jel", 0.0)
	var _t68 = env["P"]
	J.sp(_t68, "hr", 0.0)
	var _t69 = env["P"]
	J.sp(_t69, "sj", 0.0)
	v_dustK_332 = (-1.0)
	v_dustBig_333 = false
	if J.seq(v_type_313, "pocong"):
		var _t70 = J.cmp(v_pa_328, 0.0, ">=")
		if (J.cmp(v_pa_328, 1.0, "<") if _t70 else _t70):
			if J.cmp(v_pa_328, 0.62, ">"):
				var _t71 = J.div(J.sub(v_pa_328, 0.62), 0.38)
				v_dustK_332 = _t71
				v_dustBig_333 = true
				var _t72 = env["P"]
				var _t73 = J.max_([0.0, (1.0 - J.div(J.sub(v_pa_328, 0.62), 0.3))])
				J.sp(_t72, "jel", _t73)
			var _t74 = env["P"]
			var _t75 = (sin(J.num((J.mul(v_pa_328, env["TAU"]) * 1.5))) * J.sub(1.0, v_pa_328))
			J.sp(_t74, "flop", _t75)
		else:
			if J.t(J.mc(v_def_318, "hopping", [v_o_317])):
				var _t76 = J.mc(v_def_318, "hop", [v_t_322, v_o_317])
				var _t77 = J.gp(_t76, 0.0)
				v_f_343 = _t77
				var _t78 = J.gp(_t76, 1.0)
				v_h_344 = _t78
				var _t79 = env["P"]
				var _t80 = (sin(J.num((J.mul(v_f_343, env["TAU"]) - 1.2))) * J.div(v_h_344, 6.0))
				J.sp(_t79, "flop", _t80)
				var _t81 = J.cmp(v_f_343, 0.7, ">")
				if (J.cmp(v_h_344, 3.0, ">") if _t81 else _t81):
					var _t82 = J.div(J.sub(v_f_343, 0.7), 0.3)
					v_dustK_332 = _t82
				if J.cmp(v_f_343, 0.7, ">"):
					var _t83 = env["P"]
					var _t84 = ((1.0 - J.div(J.sub(v_f_343, 0.7), 0.3)) * 0.6)
					J.sp(_t83, "jel", _t84)
		var _t85 = J.cmp(v_ph_329, 0.0, ">=")
		if (J.cmp(v_ph_329, 1.0, "<") if _t85 else _t85):
			var _t86 = env["P"]
			var _t87 = J.max_([J.gp(env["P"], "jel"), J.sub(1.0, v_ph_329)])
			J.sp(_t86, "jel", _t87)
	else:
		if J.seq(v_type_313, "toyol"):
			var _t88 = env["P"]
			var _t89 = ((sin(J.num((J.mul(v_t_322, 1.9) + 0.4))) * 0.07) + (0.05 if J.t(J.gp(v_o_317, "walk")) else 0.0))
			J.sp(_t88, "hr", _t89)
			var _t90 = J.cmp(v_pa_328, 0.0, ">=")
			if (J.cmp(v_pa_328, 1.0, "<") if _t90 else _t90):
				var _t91 = env["P"]
				var _t92 = env["sm"]
				var _t94 = J.cl(_t92, null, [0.36, 0.45, v_pa_328])
				var _t93 = env["sm"]
				var _t95 = J.mul(_t94, J.sub(1.0, J.cl(_t93, null, [0.7, 0.85, v_pa_328])))
				J.sp(_t91, "sj", _t95)
				var _t96 = env["P"]
				var _t98 = (-0.12)
				var _t97 = env["sm"]
				var _t100 = J.mul(_t98, J.cl(_t97, null, [0.22, 0.4, v_pa_328]))
				var _t99 = env["sm"]
				var _t101 = J.add(J.gp(_t96, "hr"), (_t100 * J.sub(1.0, J.cl(_t99, null, [0.4, 0.6, v_pa_328]))))
				J.sp(_t96, "hr", _t101)
			var _t102 = J.cmp(v_ph_329, 0.0, ">=")
			if (J.cmp(v_ph_329, 1.0, "<") if _t102 else _t102):
				var _t103 = env["P"]
				var _t104 = J.max_([J.gp(env["P"], "sj"), (J.sub(1.0, v_ph_329) * 0.8)])
				J.sp(_t103, "sj", _t104)
				var _t105 = env["P"]
				var _t106 = J.sub(J.gp(_t105, "hr"), ((0.2 * J.sub(1.0, v_ph_329)) * J.sub(1.0, v_ph_329)))
				J.sp(_t105, "hr", _t106)
	v_nx_334 = J.add(v_cols_325, 1.0)
	v_out_335 = env["D"]
	v_j_345 = 0.0
	while true:
		if not J.cmp(v_j_345, v_rows_326, "<="): break
		v_v_346 = J.div(v_j_345, v_rows_326)
		v_i_347 = 0.0
		while true:
			if not J.cmp(v_i_347, v_cols_325, "<="): break
			v_u_348 = J.div(v_i_347, v_cols_325)
			J.mc(v_def_318, "weights", [v_u_348, v_v_346, env["W"]])
			J.mc(v_def_318, "local", [v_u_348, v_v_346, env["P"], env["W"], v_out_335])
			v_bx_349 = J.add(J.mul(J.sub(v_u_348, 0.5), v_Wd_324), J.gp(v_out_335, "x"))
			v_by_350 = J.add(J.mul((-J.sub(1.0, v_v_346)), v_H_323), J.gp(v_out_335, "y"))
			var _t107 = env["poseAt"]
			v_G0_351 = J.cl(_t107, null, [v_def_318, 0.0, v_t_322, v_pa_328, v_ph_329, v_o_317])
			var _t108 = env["apply"]
			J.cl(_t108, null, [v_G0_351, v_bx_349, v_by_350, v_px_330, v_py_331, v_out_335])
			v_X_352 = J.gp(v_out_335, "x")
			v_Y_353 = J.gp(v_out_335, "y")
			v_lf_354 = J.min_([38.999, J.mul(J.mc(v_def_318, "lag", [v_u_348, v_v_346, env["W"]]), 60.0)])
			if J.cmp(v_lf_354, 0.001, ">"):
				v_g_356 = J.mc(v_def_318, "gain", [v_u_348, v_v_346, env["W"]])
				v_X0_357 = v_X_352
				v_Y0_358 = v_Y_353
				v_li_359 = floor(J.num(v_lf_354))
				v_fr_360 = J.sub(v_lf_354, v_li_359)
				var _t109 = env["apply"]
				var _t110 = env["poseAt"]
				J.cl(_t109, null, [J.cl(_t110, null, [v_def_318, v_li_359, v_t_322, v_pa_328, v_ph_329, v_o_317]), v_bx_349, v_by_350, v_px_330, v_py_331, v_out_335])
				v_ax_361 = J.gp(v_out_335, "x")
				v_ay_362 = J.gp(v_out_335, "y")
				var _t111 = env["apply"]
				var _t112 = env["poseAt"]
				J.cl(_t111, null, [J.cl(_t112, null, [v_def_318, J.add(v_li_359, 1.0), v_t_322, v_pa_328, v_ph_329, v_o_317]), v_bx_349, v_by_350, v_px_330, v_py_331, v_out_335])
				var _t113 = J.add(v_ax_361, J.mul(J.sub(J.gp(v_out_335, "x"), v_ax_361), v_fr_360))
				J.sp(v_out_335, "x", _t113)
				var _t114 = J.add(v_ay_362, J.mul(J.sub(J.gp(v_out_335, "y"), v_ay_362), v_fr_360))
				J.sp(v_out_335, "y", _t114)
				v_ddx_363 = J.mul(J.sub(J.gp(v_out_335, "x"), v_X0_357), v_g_356)
				v_ddy_364 = J.mul(J.sub(J.gp(v_out_335, "y"), v_Y0_358), v_g_356)
				v_m_365 = J.hypot_([v_ddx_363, v_ddy_364])
				if J.cmp(v_m_365, 0.0001, ">"):
					v_q_366 = J.div(J.mul(J.gp(v_def_318, "cap"), J.math("tanh", [J.div(v_m_365, J.gp(v_def_318, "cap"))])), v_m_365)
					var _t115 = J.mul(v_ddx_363, v_q_366)
					v_ddx_363 = _t115
					var _t116 = J.mul(v_ddy_364, v_q_366)
					v_ddy_364 = _t116
				var _t117 = J.add(v_X0_357, v_ddx_363)
				v_X_352 = _t117
				var _t118 = J.add(v_Y0_358, v_ddy_364)
				v_Y_353 = _t118
			v_k_355 = J.add(J.mul(v_j_345, v_nx_334), v_i_347)
			var _t119 = env["VX"]
			var _t120 = J.add(v_x0_314, J.mul(v_X_352, v_s_316))
			J.sp(_t119, v_k_355, _t120)
			var _t121 = env["VY"]
			var _t122 = J.add(v_y0_315, J.mul(v_Y_353, v_s_316))
			J.sp(_t121, v_k_355, _t122)
			v_i_347 = J.num(v_i_347) + 1.0
		v_j_345 = J.num(v_j_345) + 1.0
	v_mnX_336 = J.mul(J.div(J.mul(0.25, v_Wd_324), v_cols_325), v_s_316)
	v_mnY_337 = J.mul(J.div(J.mul(0.25, v_H_323), v_rows_326), v_s_316)
	v_j_367 = 0.0
	while true:
		if not J.cmp(v_j_367, v_rows_326, "<="): break
		v_i_368 = 1.0
		while true:
			if not J.cmp(v_i_368, v_cols_325, "<="): break
			v_k_369 = J.add(J.mul(v_j_367, v_nx_334), v_i_368)
			if J.cmp(J.gp(env["VX"], v_k_369), J.add(J.gp(env["VX"], J.sub(v_k_369, 1.0)), v_mnX_336), "<"):
				var _t123 = env["VX"]
				var _t124 = J.add(J.gp(env["VX"], J.sub(v_k_369, 1.0)), v_mnX_336)
				J.sp(_t123, v_k_369, _t124)
			v_i_368 = J.num(v_i_368) + 1.0
		v_j_367 = J.num(v_j_367) + 1.0
	v_i_370 = 0.0
	while true:
		if not J.cmp(v_i_370, v_cols_325, "<="): break
		v_j_371 = 1.0
		while true:
			if not J.cmp(v_j_371, v_rows_326, "<="): break
			v_k_372 = J.add(J.mul(v_j_371, v_nx_334), v_i_370)
			if J.cmp(J.gp(env["VY"], v_k_372), J.add(J.gp(env["VY"], J.sub(v_k_372, v_nx_334)), v_mnY_337), "<"):
				var _t125 = env["VY"]
				var _t126 = J.add(J.gp(env["VY"], J.sub(v_k_372, v_nx_334)), v_mnY_337)
				J.sp(_t125, v_k_372, _t126)
			v_j_371 = J.num(v_j_371) + 1.0
		v_i_370 = J.num(v_i_370) + 1.0
	v_M_338 = J.mc(v_ctx_312, "getTransform", [])
	var _t127 = env["mask"]
	v_mk_339 = J.cl(_t127, null, [v_type_313, v_img_319, v_cols_325, v_rows_326])
	v_cw_340 = J.div(v_iw_320, v_cols_325)
	v_ch_341 = J.div(v_ih_321, v_rows_326)
	v_Ms_342 = J.max_([0.2, J.hypot_([J.gp(v_M_338, "a"), J.gp(v_M_338, "b")])])
	J.mc(v_ctx_312, "save", [])
	var _t128 = J.seq(v_type_313, "toyol")
	var _t129 = (J.cmp(v_pa_328, 0.0, ">=") if _t128 else _t128)
	if (J.cmp(v_pa_328, 1.0, "<") if _t129 else _t129):
		var _t130 = env["poseAt"]
		v_G0_373 = J.cl(_t130, null, [v_def_318, 0.0, v_t_322, v_pa_328, v_ph_329, v_o_317])
		var _t131 = env["poseAt"]
		v_G2_374 = J.cl(_t131, null, [v_def_318, 2.0, v_t_322, v_pa_328, v_ph_329, v_o_317])
		v_spd_375 = (absf(J.num(J.sub(J.gp(v_G0_373, "x"), J.gp(v_G2_374, "x")))) * 30.0)
		if J.cmp(v_spd_375, 25.0, ">"):
			v_base_376 = J.gp(v_ctx_312, "globalAlpha")
			v_amt_377 = J.min_([1.0, J.div(J.sub(v_spd_375, 25.0), 120.0)])
			v_i_378 = 4.0
			while true:
				if not J.cmp(v_i_378, 1.0, ">="): break
				var _t132 = ((J.mul(v_base_376, v_amt_377) * 0.22) * (1.0 - J.div(v_i_378, 5.0)))
				J.sp(v_ctx_312, "globalAlpha", _t132)
				var _t133 = env["drawWhole"]
				var _t134 = env["poseAt"]
				J.cl(_t133, null, [v_ctx_312, v_img_319, v_M_338, J.cl(_t134, null, [v_def_318, J.mul(v_i_378, 2.0), v_t_322, v_pa_328, v_ph_329, v_o_317]), v_x0_314, v_y0_315, v_s_316, v_Wd_324, v_H_323, v_px_330, v_py_331])
				v_i_378 = J.num(v_i_378) + -1.0
			J.sp(v_ctx_312, "globalAlpha", v_base_376)
	v_j_379 = 0.0
	while true:
		if not J.cmp(v_j_379, v_rows_326, "<"): break
		v_i_380 = 0.0
		while true:
			if not J.cmp(v_i_380, v_cols_325, "<"): break
			if (not J.t(J.gp(v_mk_339, J.add(J.mul(v_j_379, v_cols_325), v_i_380)))):
				v_i_380 = J.num(v_i_380) + 1.0
				continue
			v_k00_381 = J.add(J.mul(v_j_379, v_nx_334), v_i_380)
			v_k10_382 = J.add(v_k00_381, 1.0)
			v_k01_383 = J.add(v_k00_381, v_nx_334)
			v_k11_384 = J.add(v_k01_383, 1.0)
			v_ex_385 = (J.sub(J.add(J.sub(J.gp(env["VX"], v_k10_382), J.gp(env["VX"], v_k00_381)), J.gp(env["VX"], v_k11_384)), J.gp(env["VX"], v_k01_383)) * 0.5)
			v_ey_386 = (J.sub(J.add(J.sub(J.gp(env["VY"], v_k10_382), J.gp(env["VY"], v_k00_381)), J.gp(env["VY"], v_k11_384)), J.gp(env["VY"], v_k01_383)) * 0.5)
			v_fx_387 = (J.sub(J.add(J.sub(J.gp(env["VX"], v_k01_383), J.gp(env["VX"], v_k00_381)), J.gp(env["VX"], v_k11_384)), J.gp(env["VX"], v_k10_382)) * 0.5)
			v_fy_388 = (J.sub(J.add(J.sub(J.gp(env["VY"], v_k01_383), J.gp(env["VY"], v_k00_381)), J.gp(env["VY"], v_k11_384)), J.gp(env["VY"], v_k10_382)) * 0.5)
			v_ox_389 = (J.mul(J.add(J.add(J.add(J.gp(env["VX"], v_k00_381), J.gp(env["VX"], v_k10_382)), J.gp(env["VX"], v_k01_383)), J.gp(env["VX"], v_k11_384)), 0.25) - J.mul(J.add(v_ex_385, v_fx_387), 0.5))
			v_oy_390 = (J.mul(J.add(J.add(J.add(J.gp(env["VY"], v_k00_381), J.gp(env["VY"], v_k10_382)), J.gp(env["VY"], v_k01_383)), J.gp(env["VY"], v_k11_384)), 0.25) - J.mul(J.add(v_ey_386, v_fy_388), 0.5))
			J.mc(v_ctx_312, "setTransform", [(J.mul(J.gp(v_M_338, "a"), v_ex_385) + J.mul(J.gp(v_M_338, "c"), v_ey_386)), (J.mul(J.gp(v_M_338, "b"), v_ex_385) + J.mul(J.gp(v_M_338, "d"), v_ey_386)), (J.mul(J.gp(v_M_338, "a"), v_fx_387) + J.mul(J.gp(v_M_338, "c"), v_fy_388)), (J.mul(J.gp(v_M_338, "b"), v_fx_387) + J.mul(J.gp(v_M_338, "d"), v_fy_388)), J.add((J.mul(J.gp(v_M_338, "a"), v_ox_389) + J.mul(J.gp(v_M_338, "c"), v_oy_390)), J.gp(v_M_338, "e")), J.add((J.mul(J.gp(v_M_338, "b"), v_ox_389) + J.mul(J.gp(v_M_338, "d"), v_oy_390)), J.gp(v_M_338, "f"))])
			v_twS_391 = J.mul((J.hypot_([J.sub(J.sub(J.add(J.gp(env["VX"], v_k00_381), J.gp(env["VX"], v_k11_384)), J.gp(env["VX"], v_k10_382)), J.gp(env["VX"], v_k01_383)), J.sub(J.sub(J.add(J.gp(env["VY"], v_k00_381), J.gp(env["VY"], v_k11_384)), J.gp(env["VY"], v_k10_382)), J.gp(env["VY"], v_k01_383))]) * 0.25), v_Ms_342)
			v_lx_392 = J.max_([1.0, J.mul(J.hypot_([v_ex_385, v_ey_386]), v_Ms_342)])
			v_ly_393 = J.max_([1.0, J.mul(J.hypot_([v_fx_387, v_fy_388]), v_Ms_342)])
			v_aL_394 = J.min_([0.25, J.div(v_twS_391, v_lx_392)])
			v_aR_395 = J.min_([0.3, J.div(J.add(1.1, v_twS_391), v_lx_392)])
			v_aT_396 = J.min_([0.25, J.div(v_twS_391, v_ly_393)])
			v_aB_397 = J.min_([0.3, J.div(J.add(1.1, v_twS_391), v_ly_393)])
			v_sx0_398 = J.max_([0.0, J.mul(J.sub(v_i_380, v_aL_394), v_cw_340)])
			v_sx1_399 = J.min_([v_iw_320, J.mul(J.add(J.add(v_i_380, 1.0), v_aR_395), v_cw_340)])
			v_sy0_400 = J.max_([0.0, J.mul(J.sub(v_j_379, v_aT_396), v_ch_341)])
			v_sy1_401 = J.min_([v_ih_321, J.mul(J.add(J.add(v_j_379, 1.0), v_aB_397), v_ch_341)])
			J.mc(v_ctx_312, "drawImage", [v_img_319, v_sx0_398, v_sy0_400, J.sub(v_sx1_399, v_sx0_398), J.sub(v_sy1_401, v_sy0_400), J.sub(J.div(v_sx0_398, v_cw_340), v_i_380), J.sub(J.div(v_sy0_400, v_ch_341), v_j_379), J.div(J.sub(v_sx1_399, v_sx0_398), v_cw_340), J.div(J.sub(v_sy1_401, v_sy0_400), v_ch_341)])
			v_i_380 = J.num(v_i_380) + 1.0
		v_j_379 = J.num(v_j_379) + 1.0
	J.mc(v_ctx_312, "setTransform", [v_M_338])
	if J.cmp(v_dustK_332, 0.0, ">"):
		var _t135 = env["dust"]
		J.cl(_t135, null, [v_ctx_312, v_x0_314, v_y0_315, v_s_316, v_dustK_332, v_dustBig_333])
	J.mc(v_ctx_312, "restore", [])

func _f2(this_, a: Array, env):
	var v_a_33 = null; var v_b_34 = null; var v_x_35 = null
	v_a_33 = J.arg(a, 0)
	v_b_34 = J.arg(a, 1)
	v_x_35 = J.arg(a, 2)
	var _t136 = J.div(J.sub(v_x_35, v_a_33), J.sub(v_b_34, v_a_33))
	v_x_35 = _t136
	var _t137 = (0.0 if J.cmp(v_x_35, 0.0, "<") else (1.0 if J.cmp(v_x_35, 1.0, ">") else v_x_35))
	v_x_35 = _t137
	return (J.mul(v_x_35, v_x_35) * (3.0 - J.mul(2.0, v_x_35)))

func _f3(this_, a: Array, env):
	var v_K_36 = null; var v_p_37 = null; var v_i_38 = null; var v_a_39 = null; var v_b_40 = null; var v_q_41 = null
	v_K_36 = J.arg(a, 0)
	v_p_37 = J.arg(a, 1)
	v_i_38 = 1.0
	while true:
		if not J.cmp(v_i_38, J.len(v_K_36), "<"): break
		if J.cmp(v_p_37, J.gp(J.gp(v_K_36, v_i_38), 0.0), "<="):
			v_a_39 = J.gp(v_K_36, J.sub(v_i_38, 1.0))
			v_b_40 = J.gp(v_K_36, v_i_38)
			v_q_41 = J.div(J.sub(v_p_37, J.gp(v_a_39, 0.0)), J.sub(J.gp(v_b_40, 0.0), J.gp(v_a_39, 0.0)))
			return J.add(J.gp(v_a_39, 1.0), (J.sub(J.gp(v_b_40, 1.0), J.gp(v_a_39, 1.0)) * (0.5 - (0.5 * cos(J.num(J.mul(PI, v_q_41)))))))
		v_i_38 = J.num(v_i_38) + 1.0
	return J.gp(J.gp(v_K_36, (J.len(v_K_36) - 1.0)), 1.0)

func _f5(this_, a: Array, env):
	var v_p_59 = null
	v_p_59 = J.arg(a, 0)
	return (0.3 * J.min_([1.0, v_p_59]))

func _f6(this_, a: Array, env):
	var v_p_60 = null
	v_p_60 = J.arg(a, 0)
	return (0.3 + (0.4 * J.min_([1.0, v_p_60])))

func _f7(this_, a: Array, env):
	var v_p_61 = null
	v_p_61 = J.arg(a, 0)
	return (0.7 + (0.3 * J.min_([1.0, v_p_61])))

func _f8(this_, a: Array, env):
	var v_p_62 = null
	v_p_62 = J.arg(a, 0)
	return J.min_([1.0, v_p_62])

func _f9(this_, a: Array, env):
	var v_p_63 = null
	v_p_63 = J.arg(a, 0)
	return J.min_([1.0, v_p_63])

func _f11(this_, a: Array, env):
	var v_G_72 = null; var v_tt_73 = null; var v_pa_74 = null; var v_ph_75 = null; var v_o_76 = null; var v_hf_77 = null; var v_x_78 = null; var v_y_79 = null; var v_r_80 = null; var v_sx_81 = null; var v_sy_82 = null; var v_p_83 = null; var v_a1_84 = null; var v_l_85 = null; var v_str_86 = null; var v_q_87 = null; var v_c_88 = null; var v_k_89 = null; var v_k2_90 = null; var v_j_91 = null
	v_G_72 = J.arg(a, 0)
	v_tt_73 = J.arg(a, 1)
	v_pa_74 = J.arg(a, 2)
	v_ph_75 = J.arg(a, 3)
	v_o_76 = J.arg(a, 4)
	v_hf_77 = J.arg(a, 5)
	v_x_78 = (sin(J.num(J.mul(v_tt_73, 1.3))) * 1.2)
	v_y_79 = ((-4.0) - (sin(J.num(J.mul(v_tt_73, 2.6))) * 2.2))
	v_r_80 = (sin(J.num((J.mul(v_tt_73, 1.3) + 0.6))) * 0.06)
	v_sx_81 = 1.0
	v_sy_82 = 1.0
	if J.t(J.gp(v_o_76, "walk")):
		var _t139 = J.sub(v_y_79, (sin(J.num(J.mul(v_tt_73, 5.2))) * 1.6))
		v_y_79 = _t139
		var _t140 = J.add(v_r_80, (0.1 + (sin(J.num((J.mul(v_tt_73, 5.2) + 0.8))) * 0.05)))
		v_r_80 = _t140
		var _t141 = J.add(v_x_78, (sin(J.num(J.mul(v_tt_73, 2.6))) * 1.0))
		v_x_78 = _t141
	if J.t(J.gp(v_o_76, "work")):
		var _t142 = J.add(v_r_80, (sin(J.num(J.mul(v_tt_73, 7.0))) * 0.07))
		v_r_80 = _t142
		var _t143 = J.sub(v_y_79, (absf(J.num(sin(J.num(J.mul(v_tt_73, 7.0))))) * 1.5))
		v_y_79 = _t143
	if J.cmp(v_pa_74, 0.0, ">="):
		v_p_83 = J.min_([1.0, J.max_([0.0, v_pa_74])])
		var _t144 = env["sm"]
		var _t146 = J.cl(_t144, null, [0.0, 0.25, v_p_83])
		var _t145 = env["sm"]
		v_a1_84 = J.mul(_t146, J.sub(1.0, J.cl(_t145, null, [0.27, 0.4, v_p_83])))
		var _t147 = J.sub(v_x_78, J.mul(5.0, v_a1_84))
		v_x_78 = _t147
		var _t148 = J.sub(v_r_80, J.mul(0.22, v_a1_84))
		v_r_80 = _t148
		var _t149 = J.mul(v_sy_82, (1.0 + J.mul(0.08, v_a1_84)))
		v_sy_82 = _t149
		var _t150 = J.mul(v_sx_81, (1.0 - J.mul(0.06, v_a1_84)))
		v_sx_81 = _t150
		var _t151 = J.add(v_y_79, J.mul(1.5, v_a1_84))
		v_y_79 = _t151
		var _t152 = env["sm"]
		var _t154 = J.cl(_t152, null, [0.25, 0.47, v_p_83])
		var _t153 = env["sm"]
		v_l_85 = J.mul(_t154, J.sub(1.0, J.cl(_t153, null, [0.62, 1.0, v_p_83])))
		var _t155 = J.add(v_x_78, J.mul(13.0, v_l_85))
		v_x_78 = _t155
		var _t156 = J.add(v_r_80, J.mul(0.08, v_l_85))
		v_r_80 = _t156
		var _t157 = J.add(v_y_79, J.mul(2.0, v_l_85))
		v_y_79 = _t157
		v_str_86 = sin(J.num(J.mul(PI, v_l_85)))
		var _t158 = J.mul(v_sx_81, (1.0 + J.mul(0.22, v_str_86)))
		v_sx_81 = _t158
		var _t159 = J.mul(v_sy_82, (1.0 - J.mul(0.13, v_str_86)))
		v_sy_82 = _t159
		var _t160 = J.cmp(v_p_83, 0.44, ">")
		if (J.cmp(v_p_83, 0.7, "<") if _t160 else _t160):
			v_q_87 = J.div(J.sub(v_p_83, 0.44), 0.26)
			v_c_88 = J.mul((absf(J.num(sin(J.num(J.mul(v_q_87, env["TAU"]))))) * sin(J.num(J.mul(v_q_87, PI)))), v_hf_77)
			var _t161 = J.mul(v_sy_82, (1.0 - J.mul(0.18, v_c_88)))
			v_sy_82 = _t161
			var _t162 = J.mul(v_sx_81, (1.0 + J.mul(0.12, v_c_88)))
			v_sx_81 = _t162
	var _t163 = J.cmp(v_ph_75, 0.0, ">=")
	if (J.cmp(v_ph_75, 1.0, "<") if _t163 else _t163):
		v_k_89 = J.sub(1.0, v_ph_75)
		var _t165 = J.mul(v_k_89, v_k_89)
		var _t164 = env["sm"]
		v_k2_90 = J.mul(_t165, J.cl(_t164, null, [0.0, 0.16, v_ph_75]))
		var _t167 = J.mul(sin(J.num(J.mul(v_ph_75, 22.0))), v_k_89)
		var _t166 = env["sm"]
		v_j_91 = J.mul(J.mul(_t167, J.cl(_t166, null, [0.0, 0.06, v_ph_75])), v_hf_77)
		var _t168 = J.sub(v_x_78, J.mul(7.0, v_k2_90))
		v_x_78 = _t168
		var _t169 = J.sub(v_y_79, J.mul(2.0, v_k2_90))
		v_y_79 = _t169
		var _t170 = J.sub(v_r_80, J.mul(0.3, v_k2_90))
		v_r_80 = _t170
		var _t171 = J.mul(v_sy_82, (1.0 + J.mul(0.1, v_j_91)))
		v_sy_82 = _t171
		var _t172 = J.mul(v_sx_81, (1.0 - J.mul(0.08, v_j_91)))
		v_sx_81 = _t172
	J.sp(v_G_72, "x", v_x_78)
	J.sp(v_G_72, "y", v_y_79)
	J.sp(v_G_72, "r", v_r_80)
	J.sp(v_G_72, "sx", v_sx_81)
	J.sp(v_G_72, "sy", v_sy_82)

func _f12(this_, a: Array, env):
	var v_u_94 = null; var v_v_95 = null; var v_W_96 = null; var v_rr_97 = null; var v_eu_98 = null
	v_u_94 = J.arg(a, 0)
	v_v_95 = J.arg(a, 1)
	v_W_96 = J.arg(a, 2)
	v_rr_97 = J.hypot_([J.div(J.sub(v_u_94, 0.46), 0.31), J.div(J.sub(v_v_95, 0.37), 0.29)])
	var _t173 = env["sm"]
	var _t174 = J.cl(_t173, null, [0.8, 1.6, v_rr_97])
	J.sp(v_W_96, "hw", _t174)
	var _t176 = J.gp(v_W_96, "hw")
	var _t175 = env["sm"]
	var _t178 = J.gp(v_W_96, "hw")
	var _t177 = env["sm"]
	var _t179 = J.max_([_t178, J.cl(_t177, null, [0.52, 0.95, v_v_95])])
	J.sp(v_W_96, "dw", _t179)
	v_eu_98 = J.div(J.sub(v_u_94, 0.43), 0.17)
	var _t180 = env["sm"]
	var _t181 = J.mul(J.cl(_t180, null, [0.5, 0.9, v_v_95]), exp(J.num(J.mul((-J.num(v_eu_98)), v_eu_98))))
	J.sp(v_W_96, "ew", _t181)

func _f13(this_, a: Array, env):
	var v_u_101 = null; var v_v_102 = null; var v_P_103 = null; var v_W_104 = null; var v_out_105 = null; var v_t_106 = null; var v_dw_107 = null
	v_u_101 = J.arg(a, 0)
	v_v_102 = J.arg(a, 1)
	v_P_103 = J.arg(a, 2)
	v_W_104 = J.arg(a, 3)
	v_out_105 = J.arg(a, 4)
	v_t_106 = J.gp(v_P_103, "t")
	v_dw_107 = J.gp(v_W_104, "dw")
	var _t182 = (((J.mul(v_dw_107, ((sin(J.num(((J.mul(v_t_106, 3.1) - J.mul(v_v_102, 7.0)) + J.mul(v_u_101, 2.0)))) * 1.4) + (sin(J.num(J.add((J.mul(v_t_106, 1.9) - J.mul(v_v_102, 4.3)), v_u_101))) * 0.7))) * (0.35 + J.mul(0.9, v_v_102))) + (((J.mul(J.gp(v_W_104, "ew"), sin(J.num((J.mul(v_t_106, 2.1) - J.mul(v_v_102, 3.2))))) * 2.4) * J.sub(v_v_102, 0.5)) * 2.0)) + (J.mul(J.mul(J.gp(v_P_103, "L"), v_dw_107), v_v_102) * 1.1))
	J.sp(v_out_105, "x", _t182)
	var _t183 = ((J.mul(J.gp(v_W_104, "hw"), sin(J.num((J.mul(v_t_106, 2.4) - J.mul(v_u_101, 6.0))))) * 0.5) + (J.mul(J.gp(v_W_104, "ew"), sin(J.num((J.mul(v_t_106, 4.2) - J.mul(v_v_102, 5.0))))) * 0.4))
	J.sp(v_out_105, "y", _t183)

func _f14(this_, a: Array, env):
	var v_u_110 = null; var v_v_111 = null; var v_W_112 = null
	v_u_110 = J.arg(a, 0)
	v_v_111 = J.arg(a, 1)
	v_W_112 = J.arg(a, 2)
	return (J.mul(J.gp(v_W_112, "dw"), (0.04 + J.mul(0.2, v_v_111))) + J.mul(J.gp(v_W_112, "ew"), 0.06))

func _f15(this_, a: Array, env):
	var v_u_115 = null; var v_v_116 = null; var v_W_117 = null
	v_u_115 = J.arg(a, 0)
	v_v_116 = J.arg(a, 1)
	v_W_117 = J.arg(a, 2)
	return (1.0 + J.mul(0.12, J.gp(v_W_117, "dw")))

func _f16(this_, a: Array, env):
	var v_o_120 = null
	v_o_120 = J.arg(a, 0)
	var _t186 = J.gp(v_o_120, "walk")
	var _t187 = (_t186 if J.t(_t186) else J.gp(v_o_120, "enemy"))
	return (not (not J.t((_t187 if J.t(_t187) else J.gp(v_o_120, "work")))))

func _f17(this_, a: Array, env):
	var v_tt_123 = null; var v_o_124 = null; var v_rate_125 = null; var v_h_126 = null; var v_f_127 = null
	v_tt_123 = J.arg(a, 0)
	v_o_124 = J.arg(a, 1)
	v_rate_125 = (2.2 if J.t(J.gp(v_o_124, "work")) else (1.55 if J.t(J.gp(v_o_124, "walk")) else 1.25))
	v_h_126 = (2.5 if J.t(J.gp(v_o_124, "work")) else (7.0 if J.t(J.gp(v_o_124, "walk")) else 4.5))
	v_f_127 = J.mul(v_tt_123, v_rate_125)
	return [J.sub(v_f_127, floor(J.num(v_f_127))), v_h_126]

func _f18(this_, a: Array, env):
	var v_G_130 = null; var v_tt_131 = null; var v_pa_132 = null; var v_ph_133 = null; var v_o_134 = null; var v_hf_135 = null; var v_x_136 = null; var v_y_137 = null; var v_r_138 = null; var v_sx_139 = null; var v_sy_140 = null; var v_atk_141 = null; var v_p_142 = null; var v_q_143 = null; var v_q_144 = null; var v_q_145 = null; var v_k_146 = null; var v_f_147 = null; var v_h_148 = null; var v_q_149 = null; var v_k_150 = null; var v_k2_151 = null; var v_j_152 = null
	v_G_130 = J.arg(a, 0)
	v_tt_131 = J.arg(a, 1)
	v_pa_132 = J.arg(a, 2)
	v_ph_133 = J.arg(a, 3)
	v_o_134 = J.arg(a, 4)
	v_hf_135 = J.arg(a, 5)
	v_x_136 = 0.0
	v_y_137 = 0.0
	v_r_138 = 0.0
	v_sx_139 = 1.0
	v_sy_140 = 1.0
	var _t188 = J.cmp(v_pa_132, 0.0, ">=")
	v_atk_141 = (J.cmp(v_pa_132, 1.0, "<") if _t188 else _t188)
	if J.t(v_atk_141):
		v_p_142 = J.max_([0.0, v_pa_132])
		if J.cmp(v_p_142, 0.25, "<"):
			var _t189 = env["sm"]
			v_q_143 = J.cl(_t189, null, [0.0, 0.25, v_p_142])
			var _t190 = (1.0 - J.mul(0.28, v_q_143))
			v_sy_140 = _t190
			var _t191 = J.mul((-0.08), v_q_143)
			v_r_138 = _t191
		else:
			if J.cmp(v_p_142, 0.62, "<"):
				v_q_144 = J.div(J.sub(v_p_142, 0.25), 0.37)
				var _t192 = (J.mul(((-22.0) * 4.0), v_q_144) * J.sub(1.0, v_q_144))
				v_y_137 = _t192
				var _t193 = env["sm"]
				var _t194 = J.mul(11.0, J.cl(_t193, null, [0.0, 1.0, v_q_144]))
				v_x_136 = _t194
				var _t195 = env["lerpKeys"]
				var _t196 = J.cl(_t195, null, [[[0.0, 0.72], [0.12, 1.22], [0.5, 1.04], [0.85, 1.12], [1.0, 1.1]], v_q_144])
				v_sy_140 = _t196
				var _t197 = (0.18 * sin(J.num(J.mul(PI, v_q_144))))
				v_r_138 = _t197
			else:
				if J.cmp(v_p_142, 0.72, "<"):
					var _t198 = env["sm"]
					v_q_145 = J.cl(_t198, null, [0.62, 0.72, v_p_142])
					v_x_136 = 11.0
					var _t199 = (1.1 - J.mul(0.42, v_q_145))
					v_sy_140 = _t199
				else:
					v_k_146 = J.div(J.sub(v_p_142, 0.72), 0.28)
					var _t200 = env["sm"]
					var _t201 = (11.0 * J.sub(1.0, J.cl(_t200, null, [0.0, 1.0, v_k_146])))
					v_x_136 = _t201
					var _t202 = (1.0 - (((0.32 * J.sub(1.0, v_k_146)) * J.sub(1.0, v_k_146)) * cos(J.num((J.mul(v_k_146, 3.0) * PI)))))
					v_sy_140 = _t202
		var _t203 = J.div(1.0, pow(J.num(v_sy_140), J.num(0.7)))
		v_sx_139 = _t203
	else:
		if J.t(J.mc(this_, "hopping", [v_o_134])):
			var _t204 = J.mc(this_, "hop", [v_tt_131, v_o_134])
			var _t205 = J.gp(_t204, 0.0)
			v_f_147 = _t205
			var _t206 = J.gp(_t204, 1.0)
			v_h_148 = _t206
			var _t207 = env["lerpKeys"]
			var _t208 = J.cl(_t207, null, [env["HOP_SY"], v_f_147])
			v_sy_140 = _t208
			var _t209 = J.div(1.0, pow(J.num(v_sy_140), J.num(0.6)))
			v_sx_139 = _t209
			var _t210 = J.cmp(v_f_147, 0.2, ">")
			if (J.cmp(v_f_147, 0.7, "<") if _t210 else _t210):
				v_q_149 = J.div(J.sub(v_f_147, 0.2), 0.5)
				var _t211 = (J.mul(((-J.num(v_h_148)) * 4.0), v_q_149) * J.sub(1.0, v_q_149))
				v_y_137 = _t211
				var _t212 = ((0.08 if J.t(J.gp(v_o_134, "walk")) else 0.04) * sin(J.num(J.mul(PI, v_q_149))))
				v_r_138 = _t212
				if J.t(J.gp(v_o_134, "walk")):
					var _t213 = (J.sub(v_q_149, 0.5) * 2.5)
					v_x_136 = _t213
			else:
				if J.t(J.gp(v_o_134, "walk")):
					var _t214 = (1.25 if J.cmp(v_f_147, 0.7, ">") else (-1.25))
					v_x_136 = _t214
		else:
			var _t215 = (sin(J.num(J.mul(v_tt_131, 1.6))) * 0.035)
			v_r_138 = _t215
			var _t216 = (1.0 + (sin(J.num(J.mul(v_tt_131, 2.2))) * 0.015))
			v_sy_140 = _t216
			var _t217 = (1.0 - (sin(J.num(J.mul(v_tt_131, 2.2))) * 0.01))
			v_sx_139 = _t217
	var _t218 = J.cmp(v_ph_133, 0.0, ">=")
	if (J.cmp(v_ph_133, 1.0, "<") if _t218 else _t218):
		v_k_150 = J.sub(1.0, v_ph_133)
		var _t220 = J.mul(v_k_150, v_k_150)
		var _t219 = env["sm"]
		v_k2_151 = J.mul(_t220, J.cl(_t219, null, [0.0, 0.16, v_ph_133]))
		var _t222 = J.mul(sin(J.num(J.mul(v_ph_133, 20.0))), v_k_150)
		var _t221 = env["sm"]
		v_j_152 = J.mul(J.mul(_t222, J.cl(_t221, null, [0.0, 0.06, v_ph_133])), v_hf_135)
		var _t223 = J.sub(v_x_136, J.mul(4.0, v_k2_151))
		v_x_136 = _t223
		var _t224 = J.sub(v_r_138, J.mul(0.22, v_k2_151))
		v_r_138 = _t224
		var _t225 = J.mul(v_sy_140, (1.0 + J.mul(0.1, v_j_152)))
		v_sy_140 = _t225
		var _t226 = J.mul(v_sx_139, (1.0 - J.mul(0.08, v_j_152)))
		v_sx_139 = _t226
	J.sp(v_G_130, "x", v_x_136)
	J.sp(v_G_130, "y", v_y_137)
	J.sp(v_G_130, "r", v_r_138)
	J.sp(v_G_130, "sx", v_sx_139)
	J.sp(v_G_130, "sy", v_sy_140)

func _f19(this_, a: Array, env):
	var v_u_155 = null; var v_v_156 = null; var v_W_157 = null
	v_u_155 = J.arg(a, 0)
	v_v_156 = J.arg(a, 1)
	v_W_157 = J.arg(a, 2)
	var _t227 = env["sm"]
	var _t228 = J.sub(1.0, J.cl(_t227, null, [0.03, 0.26, v_v_156]))
	J.sp(v_W_157, "kw", _t228)
	var _t229 = sin(J.num((PI * J.min_([1.0, J.max_([0.0, J.div(J.sub(v_v_156, 0.2), 0.75)])]))))
	J.sp(v_W_157, "bw", _t229)

func _f20(this_, a: Array, env):
	var v_u_160 = null; var v_v_161 = null; var v_P_162 = null; var v_W_163 = null; var v_out_164 = null; var v_kw_165 = null; var v_t_166 = null
	v_u_160 = J.arg(a, 0)
	v_v_161 = J.arg(a, 1)
	v_P_162 = J.arg(a, 2)
	v_W_163 = J.arg(a, 3)
	v_out_164 = J.arg(a, 4)
	v_kw_165 = J.gp(v_W_163, "kw")
	v_t_166 = J.gp(v_P_162, "t")
	var _t230 = (((J.mul(v_kw_165, (((sin(J.num(J.mul(v_t_166, 3.3))) * 0.9) + J.mul(J.gp(v_P_162, "flop"), 1.8)) + J.mul(J.gp(v_P_162, "L"), 1.6))) * (1.2 - J.mul(v_v_161, 2.0))) + (J.mul(J.gp(v_W_163, "bw"), J.gp(v_P_162, "L")) * 0.35)) + ((J.mul(J.gp(v_W_163, "bw"), J.gp(v_P_162, "jel")) * sin(J.num((J.mul(v_v_161, 9.0) - J.mul(v_t_166, 20.0))))) * 0.6))
	J.sp(v_out_164, "x", _t230)
	var _t231 = (J.mul(v_kw_165, sin(J.num((J.mul(v_t_166, 2.6) + J.mul(v_u_160, 3.0))))) * 0.3)
	J.sp(v_out_164, "y", _t231)

func _f21(this_, a: Array, env):
	var v_u_169 = null; var v_v_170 = null; var v_W_171 = null
	v_u_169 = J.arg(a, 0)
	v_v_170 = J.arg(a, 1)
	v_W_171 = J.arg(a, 2)
	return (J.mul(J.gp(v_W_171, "kw"), 0.07) + J.mul(J.gp(v_W_171, "bw"), 0.02))

func _f22(this_, a: Array, env):
	var v_u_174 = null; var v_v_175 = null; var v_W_176 = null
	v_u_174 = J.arg(a, 0)
	v_v_175 = J.arg(a, 1)
	v_W_176 = J.arg(a, 2)
	return (1.0 + J.mul(0.4, J.gp(v_W_176, "kw")))

func _f23(this_, a: Array, env):
	var v_G_179 = null; var v_tt_180 = null; var v_pa_181 = null; var v_ph_182 = null; var v_o_183 = null; var v_hf_184 = null; var v_x_185 = null; var v_y_186 = null; var v_r_187 = null; var v_sy_188 = null; var v_sx_189 = null; var v_p_190 = null; var v_a1_191 = null; var v_l_192 = null; var v_str_193 = null; var v_q_194 = null; var v_b_195 = null; var v_k_196 = null; var v_k2_197 = null; var v_j_198 = null
	v_G_179 = J.arg(a, 0)
	v_tt_180 = J.arg(a, 1)
	v_pa_181 = J.arg(a, 2)
	v_ph_182 = J.arg(a, 3)
	v_o_183 = J.arg(a, 4)
	v_hf_184 = J.arg(a, 5)
	v_x_185 = (sin(J.num(J.mul(v_tt_180, 1.4))) * 0.8)
	v_y_186 = ((-sin(J.num(J.mul(v_tt_180, 2.8)))) * 1.0)
	v_r_187 = (sin(J.num(J.mul(v_tt_180, 1.7))) * 0.05)
	v_sy_188 = (1.0 + (sin(J.num(J.mul(v_tt_180, 3.0))) * 0.02))
	v_sx_189 = (1.0 - (sin(J.num(J.mul(v_tt_180, 3.0))) * 0.012))
	if J.t(J.gp(v_o_183, "walk")):
		var _t234 = J.add(v_r_187, (0.15 + (sin(J.num(J.mul(v_tt_180, 6.0))) * 0.03)))
		v_r_187 = _t234
		var _t235 = J.add(v_y_186, (sin(J.num(J.mul(v_tt_180, 6.0))) * 0.9))
		v_y_186 = _t235
	if J.t(J.gp(v_o_183, "work")):
		var _t236 = J.sub(v_y_186, (absf(J.num(sin(J.num(J.mul(v_tt_180, 6.0))))) * 1.8))
		v_y_186 = _t236
		var _t237 = J.add(v_r_187, (sin(J.num(J.mul(v_tt_180, 6.0))) * 0.06))
		v_r_187 = _t237
	if J.cmp(v_pa_181, 0.0, ">="):
		v_p_190 = J.min_([1.0, J.max_([0.0, v_pa_181])])
		var _t238 = env["sm"]
		var _t240 = J.cl(_t238, null, [0.0, 0.22, v_p_190])
		var _t239 = env["sm"]
		v_a1_191 = J.mul(_t240, J.sub(1.0, J.cl(_t239, null, [0.22, 0.32, v_p_190])))
		var _t241 = J.sub(v_x_185, J.mul(4.0, v_a1_191))
		v_x_185 = _t241
		var _t242 = J.sub(v_r_187, J.mul(0.14, v_a1_191))
		v_r_187 = _t242
		var _t243 = J.mul(v_sx_189, (1.0 + J.mul(0.08, v_a1_191)))
		v_sx_189 = _t243
		var _t244 = J.mul(v_sy_188, (1.0 - J.mul(0.1, v_a1_191)))
		v_sy_188 = _t244
		var _t245 = J.add(v_y_186, J.mul(1.0, v_a1_191))
		v_y_186 = _t245
		var _t246 = env["sm"]
		var _t248 = J.cl(_t246, null, [0.22, 0.4, v_p_190])
		var _t247 = env["sm"]
		v_l_192 = J.mul(_t248, J.sub(1.0, J.cl(_t247, null, [0.74, 1.0, v_p_190])))
		var _t249 = J.add(v_x_185, J.mul(15.0, v_l_192))
		v_x_185 = _t249
		var _t251 = PI
		var _t250 = env["sm"]
		var _t252 = J.add(v_r_187, ((0.2 * sin(J.num(J.mul(_t251, J.cl(_t250, null, [0.22, 0.4, v_p_190]))))) + J.mul(0.06, v_l_192)))
		v_r_187 = _t252
		v_str_193 = sin(J.num(J.mul(PI, v_l_192)))
		var _t253 = J.mul(v_sx_189, (1.0 + J.mul(0.26, v_str_193)))
		v_sx_189 = _t253
		var _t254 = J.mul(v_sy_188, (1.0 - J.mul(0.14, v_str_193)))
		v_sy_188 = _t254
		var _t255 = J.cmp(v_p_190, 0.4, ">")
		if (J.cmp(v_p_190, 0.74, "<") if _t255 else _t255):
			v_q_194 = J.div(J.sub(v_p_190, 0.4), 0.34)
			v_b_195 = J.mul((sin(J.num((J.mul(v_q_194, 3.0) * PI))) * J.sub(1.0, v_q_194)), v_hf_184)
			var _t256 = J.mul(v_sy_188, (1.0 - J.mul(0.1, v_b_195)))
			v_sy_188 = _t256
			var _t257 = J.mul(v_sx_189, (1.0 + J.mul(0.07, v_b_195)))
			v_sx_189 = _t257
	var _t258 = J.cmp(v_ph_182, 0.0, ">=")
	if (J.cmp(v_ph_182, 1.0, "<") if _t258 else _t258):
		v_k_196 = J.sub(1.0, v_ph_182)
		var _t260 = J.mul(v_k_196, v_k_196)
		var _t259 = env["sm"]
		v_k2_197 = J.mul(_t260, J.cl(_t259, null, [0.0, 0.16, v_ph_182]))
		var _t262 = J.mul(sin(J.num(J.mul(v_ph_182, 22.0))), v_k_196)
		var _t261 = env["sm"]
		v_j_198 = J.mul(J.mul(_t262, J.cl(_t261, null, [0.0, 0.06, v_ph_182])), v_hf_184)
		var _t263 = J.sub(v_x_185, J.mul(6.0, v_k2_197))
		v_x_185 = _t263
		var _t264 = J.sub(v_r_187, J.mul(0.28, v_k2_197))
		v_r_187 = _t264
		var _t265 = J.mul(v_sy_188, (1.0 + J.mul(0.1, v_j_198)))
		v_sy_188 = _t265
		var _t266 = J.mul(v_sx_189, (1.0 - J.mul(0.08, v_j_198)))
		v_sx_189 = _t266
	J.sp(v_G_179, "x", v_x_185)
	J.sp(v_G_179, "y", v_y_186)
	J.sp(v_G_179, "r", v_r_187)
	J.sp(v_G_179, "sx", v_sx_189)
	J.sp(v_G_179, "sy", v_sy_188)

func _f24(this_, a: Array, env):
	var v_u_201 = null; var v_v_202 = null; var v_W_203 = null; var v_su_204 = null; var v_sv_205 = null
	v_u_201 = J.arg(a, 0)
	v_v_202 = J.arg(a, 1)
	v_W_203 = J.arg(a, 2)
	var _t267 = env["sm"]
	var _t268 = J.sub(1.0, J.cl(_t267, null, [0.36, 0.5, v_v_202]))
	J.sp(v_W_203, "hw", _t268)
	var _t269 = env["sm"]
	var _t271 = J.cl(_t269, null, [0.4, 0.48, v_v_202])
	var _t270 = env["sm"]
	var _t272 = J.mul(_t271, J.sub(1.0, J.cl(_t270, null, [0.68, 0.76, v_v_202])))
	J.sp(v_W_203, "bw", _t272)
	v_su_204 = J.div(J.sub(v_u_201, 0.8), 0.17)
	v_sv_205 = J.div(J.sub(v_v_202, 0.55), 0.15)
	var _t273 = exp(J.num((-(J.mul(v_su_204, v_su_204) + J.mul(v_sv_205, v_sv_205)))))
	J.sp(v_W_203, "sw", _t273)
	var _t274 = env["sm"]
	var _t275 = J.cl(_t274, null, [0.68, 1.0, v_v_202])
	J.sp(v_W_203, "tw", _t275)

func _f25(this_, a: Array, env):
	var v_u_208 = null; var v_v_209 = null; var v_P_210 = null; var v_W_211 = null; var v_out_212 = null; var v_t_213 = null; var v_tw_214 = null; var v_a_215 = null; var v_ox_216 = null; var v_oy_217 = null; var v_x_218 = null; var v_y_219 = null
	v_u_208 = J.arg(a, 0)
	v_v_209 = J.arg(a, 1)
	v_P_210 = J.arg(a, 2)
	v_W_211 = J.arg(a, 3)
	v_out_212 = J.arg(a, 4)
	v_t_213 = J.gp(v_P_210, "t")
	v_tw_214 = pow(J.num(J.gp(v_W_211, "tw")), J.num(1.3))
	v_a_215 = J.mul(J.gp(v_W_211, "hw"), J.gp(v_P_210, "hr"))
	v_ox_216 = J.mul(J.sub(v_u_208, 0.5), J.gp(v_P_210, "Wd"))
	v_oy_217 = J.mul(J.sub(v_v_209, 0.45), J.gp(v_P_210, "H"))
	v_x_218 = J.sub((J.mul(v_ox_216, cos(J.num(v_a_215))) - J.mul(v_oy_217, sin(J.num(v_a_215)))), v_ox_216)
	v_y_219 = J.sub((J.mul(v_ox_216, sin(J.num(v_a_215))) + J.mul(v_oy_217, cos(J.num(v_a_215)))), v_oy_217)
	var _t276 = J.add(v_x_218, ((J.mul(J.mul(J.gp(v_W_211, "bw"), J.sub(v_u_208, 0.55)), J.gp(v_P_210, "Wd")) * 0.05) * sin(J.num(J.mul(v_t_213, 3.0)))))
	v_x_218 = _t276
	var _t277 = J.add(v_y_219, (((J.mul(J.mul(J.gp(v_W_211, "bw"), J.sub(0.6, v_v_209)), J.gp(v_P_210, "H")) * 0.03) * sin(J.num(J.mul(v_t_213, 3.0)))) + (J.mul(J.gp(v_W_211, "hw"), sin(J.num((J.mul(v_t_213, 2.8) - 0.6)))) * 0.5)))
	v_y_219 = _t277
	var _t278 = J.add(v_x_218, J.mul(v_tw_214, ((sin(J.num((J.mul(v_t_213, 4.2) - J.mul(v_v_209, 8.0)))) * 2.4) + J.mul(J.gp(v_P_210, "L"), 1.6))))
	v_x_218 = _t278
	var _t279 = J.add(v_y_219, (J.mul(v_tw_214, sin(J.num((J.mul(v_t_213, 3.1) - J.mul(v_v_209, 6.0))))) * 0.4))
	v_y_219 = _t279
	var _t280 = J.add(v_x_218, ((J.mul(J.gp(v_W_211, "sw"), J.gp(v_P_210, "sj")) * sin(J.num(J.mul(v_t_213, 37.0)))) * 1.4))
	v_x_218 = _t280
	var _t281 = J.add(v_y_219, J.mul(J.gp(v_W_211, "sw"), ((sin(J.num((J.mul(v_t_213, 3.0) + 1.0))) * 0.8) + (J.mul(J.gp(v_P_210, "sj"), sin(J.num((J.mul(v_t_213, 29.0) + 1.0)))) * 1.8))))
	v_y_219 = _t281
	J.sp(v_out_212, "x", v_x_218)
	J.sp(v_out_212, "y", v_y_219)

func _f26(this_, a: Array, env):
	var v_u_222 = null; var v_v_223 = null; var v_W_224 = null
	v_u_222 = J.arg(a, 0)
	v_v_223 = J.arg(a, 1)
	v_W_224 = J.arg(a, 2)
	return (J.mul(J.gp(v_W_224, "hw"), 0.06) + J.mul(J.gp(v_W_224, "tw"), 0.16))

func _f27(this_, a: Array, env):
	var v_u_227 = null; var v_v_228 = null; var v_W_229 = null
	v_u_227 = J.arg(a, 0)
	v_v_228 = J.arg(a, 1)
	v_W_229 = J.arg(a, 2)
	return (1.0 + J.mul(0.5, J.gp(v_W_229, "tw")))

func _f34(this_, a: Array, env):
	var v_type_404 = null
	v_type_404 = J.arg(a, 0)
	var _t283 = J.gp(env["C"], v_type_404)
	var _t284 = ((not J.seq(J.typeof_(J.G.get("SPR")), "undefined")) if J.t(_t283) else _t283)
	var _t285 = (J.gp(J.G.get("SPR"), v_type_404) if J.t(_t284) else _t284)
	return (not (not J.t((J.gp(J.gp(J.G.get("SPR"), v_type_404), "naturalWidth") if J.t(_t285) else _t285))))

func _f1(this_, a: Array, env):
	var v_draw_32 = null; var v_i_248 = null
	var _s2 = {"__p": env, "TAU": null, "H0": null, "ADUR": null, "HDUR": null, "sm": null, "lerpKeys": null, "HOP_SY": null, "states": null, "uid": null, "lastClean": null, "epoch": null, "lastCall": null, "getState": null, "ATKPOSE": null, "progress": null, "C": null, "masks": null, "mask": null, "VX": null, "VY": null, "GC": null, "W": null, "D": null, "P": null, "frameId": null, "TMP": null, "poseAt": null, "apply": null, "drawWhole": null, "dust": null}
	_s2["getState"] = Callable(self, "_f4").bind(_s2)
	_s2["progress"] = Callable(self, "_f10").bind(_s2)
	_s2["mask"] = Callable(self, "_f28").bind(_s2)
	_s2["poseAt"] = Callable(self, "_f29").bind(_s2)
	_s2["apply"] = Callable(self, "_f30").bind(_s2)
	_s2["drawWhole"] = Callable(self, "_f31").bind(_s2)
	_s2["dust"] = Callable(self, "_f32").bind(_s2)
	v_draw_32 = Callable(self, "_f33").bind(_s2)
	_s2["TAU"] = (PI * 2.0)
	_s2["H0"] = {"penanggal": 52.0, "pocong": 54.0, "toyol": 46.0}
	_s2["ADUR"] = 0.55
	_s2["HDUR"] = 0.45
	_s2["sm"] = Callable(self, "_f2").bind(_s2)
	_s2["lerpKeys"] = Callable(self, "_f3").bind(_s2)
	_s2["HOP_SY"] = [[0.0, 1.0], [0.15, 0.84], [0.24, 1.14], [0.45, 1.03], [0.62, 1.08], [0.7, 1.1], [0.78, 0.8], [0.89, 1.05], [1.0, 1.0]]
	_s2["states"] = J.new_("Map", [])
	_s2["uid"] = 0.0
	_s2["lastClean"] = 0.0
	_s2["epoch"] = 0.0
	_s2["lastCall"] = 0.0
	_s2["ATKPOSE"] = {"windup": Callable(self, "_f5").bind(_s2), "strike": Callable(self, "_f6").bind(_s2), "recover": Callable(self, "_f7").bind(_s2), "cast": Callable(self, "_f8").bind(_s2), "attack": Callable(self, "_f9").bind(_s2)}
	_s2["C"] = {}
	var _t138 = _s2["C"]
	var _t184 = {"grid": [7.0, 18.0], "pu": 0.46, "pv": 0.37, "cap": 4.5, "drive": Callable(self, "_f11").bind(_s2), "weights": Callable(self, "_f12").bind(_s2), "local": Callable(self, "_f13").bind(_s2), "lag": Callable(self, "_f14").bind(_s2), "gain": Callable(self, "_f15").bind(_s2)}
	J.sp(_t138, "penanggal", _t184)
	var _t185 = _s2["C"]
	var _t232 = {"grid": [3.0, 18.0], "pu": 0.5, "pv": 1.0, "cap": 1.6, "hopping": Callable(self, "_f16").bind(_s2), "hop": Callable(self, "_f17").bind(_s2), "drive": Callable(self, "_f18").bind(_s2), "weights": Callable(self, "_f19").bind(_s2), "local": Callable(self, "_f20").bind(_s2), "lag": Callable(self, "_f21").bind(_s2), "gain": Callable(self, "_f22").bind(_s2)}
	J.sp(_t185, "pocong", _t232)
	var _t233 = _s2["C"]
	var _t282 = {"grid": [5.0, 18.0], "pu": 0.5, "pv": 0.62, "cap": 4.0, "drive": Callable(self, "_f23").bind(_s2), "weights": Callable(self, "_f24").bind(_s2), "local": Callable(self, "_f25").bind(_s2), "lag": Callable(self, "_f26").bind(_s2), "gain": Callable(self, "_f27").bind(_s2)}
	J.sp(_t233, "toyol", _t282)
	_s2["masks"] = {}
	_s2["VX"] = J.new_("Float32Array", [512.0])
	_s2["VY"] = J.new_("Float32Array", [512.0])
	_s2["GC"] = []
	v_i_248 = 0.0
	while true:
		if not J.cmp(v_i_248, 40.0, "<"): break
		J.mc(_s2["GC"], "push", [{"x": 0.0, "y": 0.0, "r": 0.0, "sx": 1.0, "sy": 1.0, "c": 1.0, "s": 0.0, "ok": (-1.0)}])
		v_i_248 = J.num(v_i_248) + 1.0
	_s2["W"] = {}
	_s2["D"] = {"x": 0.0, "y": 0.0}
	_s2["P"] = {"t": 0.0, "L": 0.0, "flop": 0.0, "jel": 0.0, "hr": 0.0, "sj": 0.0, "Wd": 0.0, "H": 0.0}
	_s2["frameId"] = 0.0
	_s2["TMP"] = {"x": 0.0, "y": 0.0, "r": 0.0, "sx": 1.0, "sy": 1.0}
	return {"has": Callable(self, "_f34").bind(_s2), "draw": v_draw_32, "_dbg": {"VX": _s2["VX"], "VY": _s2["VY"], "C": _s2["C"]}}
