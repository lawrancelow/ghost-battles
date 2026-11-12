# 自動轉譯自 puppet.js（tools/jsgd.js）——唔好直接改，改原 JS 再轉
extends RefCounted

func run(env):
	var this_ = null; var a = []
	J.G["PUPPET_ON"] = false
	J.G["Puppet"] = J.cl(Callable(self, "_f1").bind(env), null, [])

func _f3(this_, a: Array, env):
	var v_p_33 = null
	v_p_33 = J.arg(a, 0)
	return [J.sub(env["tw"], J.gp(v_p_33, 0.0)), J.gp(v_p_33, 1.0)]

func _f2(this_, a: Array, env):
	var v_R_30 = null; var v_mx_32 = null; var v_k_34 = null; var v_P_35 = null; var v_T_36 = null
	var _s3 = {"__p": env, "tw": null}
	v_R_30 = J.arg(a, 0)
	if J.t(J.mc(_s3["__p"]["M"], "has", [v_R_30])):
		return null
	J.mc(_s3["__p"]["M"], "add", [v_R_30])
	_s3["tw"] = J.gp(J.gp(v_R_30, "torso"), 1.0)
	v_mx_32 = Callable(self, "_f3").bind(_s3)
	var _t1 = J.cl(v_mx_32, null, [J.gp(v_R_30, "root")])
	J.sp(v_R_30, "root", _t1)
	var _t2 = J.cl(v_mx_32, null, [J.gp(v_R_30, "neck")])
	J.sp(v_R_30, "neck", _t2)
	var _t3 = J.cl(v_mx_32, null, [J.gp(v_R_30, "shF")])
	J.sp(v_R_30, "shF", _t3)
	var _t4 = J.cl(v_mx_32, null, [J.gp(v_R_30, "shB")])
	J.sp(v_R_30, "shB", _t4)
	var _t5 = [J.gp(J.gp(v_R_30, "head"), 0.0), J.gp(J.gp(v_R_30, "head"), 1.0), J.sub(1.0, J.gp(J.gp(v_R_30, "head"), 2.0)), J.gp(J.gp(v_R_30, "head"), 3.0)]
	J.sp(v_R_30, "head", _t5)
	if J.t(J.gp(v_R_30, "hipF")):
		var _t6 = J.cl(v_mx_32, null, [J.gp(v_R_30, "hipF")])
		J.sp(v_R_30, "hipF", _t6)
		var _t7 = J.cl(v_mx_32, null, [J.gp(v_R_30, "hipB")])
		J.sp(v_R_30, "hipB", _t7)
	for _t8 in J.iter(["uF", "fF", "uB", "fB", "lF", "lB"]):
		v_k_34 = _t8
		v_P_35 = J.gp(v_R_30, v_k_34)
		if (not J.t(v_P_35)):
			continue
		var _t9 = [J.sub(J.gp(v_P_35, 1.0), J.gp(J.gp(v_P_35, 3.0), 0.0)), J.gp(J.gp(v_P_35, 3.0), 1.0)]
		J.sp(v_P_35, 3.0, _t9)
		var _t10 = [J.sub(J.gp(v_P_35, 1.0), J.gp(J.gp(v_P_35, 4.0), 0.0)), J.gp(J.gp(v_P_35, 4.0), 1.0)]
		J.sp(v_P_35, 4.0, _t10)
	if J.t(J.gp(v_R_30, "tool")):
		v_T_36 = J.gp(v_R_30, "tool")
		var _t11 = _s3["__p"]["TOOLS"]
		var _t12 = J.add("_", J.gp(v_R_30, "id"))
		var _t13 = [J.gp(v_T_36, 0.0), J.gp(v_T_36, 1.0), J.gp(v_T_36, 2.0), [J.sub(J.gp(v_T_36, 1.0), J.gp(J.gp(v_T_36, 3.0), 0.0)), J.gp(J.gp(v_T_36, 3.0), 1.0)], false]
		J.sp(_t11, _t12, _t13)

func _f4(this_, a: Array, env):
	var v_obj_39 = null; var v_id_40 = null; var v_R_41 = null
	v_obj_39 = J.arg(a, 0)
	for _t14 in J.keys(v_obj_39):
		v_id_40 = _t14
		v_R_41 = J.gp(v_obj_39, v_id_40)
		J.sp(v_R_41, "id", v_id_40)
		var _t15 = env["RIGS"]
		J.sp(_t15, v_id_40, v_R_41)

func _f8(this_, a: Array, env):
	var v_name_53 = null; var v_d_54 = null; var v_im_55 = null; var v_sc_56 = null
	v_name_53 = J.arg(a, 0)
	v_d_54 = J.gp(env["TOOLS"], v_name_53)
	var _t17 = (not J.t(v_d_54))
	if not J.t(_t17):
		var _t16 = env["ok"]
		_t17 = (not J.t(J.cl(_t16, null, [J.gp(v_d_54, 0.0)])))
	if _t17:
		return null
	var _t19 = (not J.t(J.gp(v_d_54, 1.0)))
	if J.t(_t19):
		var _t18 = J.gp(v_d_54, 0.0)
		_t19 = J.mc(_t18, "startsWith", ["tool_s"])
	if J.t(_t19):
		v_im_55 = J.gp(J.G.get("SPR"), J.gp(v_d_54, 0.0))
		v_sc_56 = J.div(1.0, 0.55)
		var _t20 = J.mul(J.gp(v_im_55, "naturalWidth"), v_sc_56)
		J.sp(v_d_54, 1.0, _t20)
		var _t21 = J.mul(J.gp(v_im_55, "naturalHeight"), v_sc_56)
		J.sp(v_d_54, 2.0, _t21)
		var _t22 = [J.sub(J.gp(v_d_54, 1.0), J.mul(J.gp(v_d_54, 1.0), 0.13)), J.mul(J.gp(v_d_54, 2.0), 0.85)]
		J.sp(v_d_54, 3.0, _t22)
	return v_d_54

func _f14(this_, a: Array, env):
	var v_a_65 = null; var v_b_66 = null; var v_k_67 = null; var v_o_68 = null; var v_key_69 = null; var v_va_70 = null; var v_vb_71 = null
	v_a_65 = J.arg(a, 0)
	v_b_66 = J.arg(a, 1)
	v_k_67 = J.arg(a, 2)
	v_o_68 = {}
	for _t23 in J.keys(v_a_65):
		v_key_69 = _t23
		v_va_70 = J.gp(v_a_65, v_key_69)
		v_vb_71 = J.gp(v_b_66, v_key_69)
		var _t24 = J.seq(J.typeof_(v_va_70), "number")
		var _t25 = (J.add(v_va_70, J.mul(J.sub(v_vb_71, v_va_70), v_k_67)) if (J.seq(J.typeof_(v_vb_71), "number") if _t24 else _t24) else (v_va_70 if J.cmp(v_k_67, 0.5, "<") else v_vb_71))
		J.sp(v_o_68, v_key_69, _t25)
	return v_o_68

func _f15(this_, a: Array, env):
	var v_list_74 = null; var v_p_75 = null; var v_i_76 = null; var v_t0_77 = null; var v_a_78 = null; var v_t1_79 = null; var v_b_80 = null; var v_e_81 = null
	v_list_74 = J.arg(a, 0)
	v_p_75 = J.arg(a, 1)
	if J.cmp(v_p_75, J.gp(J.gp(v_list_74, 0.0), 0.0), "<="):
		return J.S_Object_("assign", [{}, env["BASE"], J.gp(J.gp(v_list_74, 0.0), 1.0)])
	v_i_76 = 1.0
	while true:
		if not J.cmp(v_i_76, J.len(v_list_74), "<"): break
		if J.cmp(v_p_75, J.gp(J.gp(v_list_74, v_i_76), 0.0), "<="):
			var _t26 = J.gp(v_list_74, J.sub(v_i_76, 1.0))
			var _t27 = J.gp(_t26, 0.0)
			v_t0_77 = _t27
			var _t28 = J.gp(_t26, 1.0)
			v_a_78 = _t28
			var _t29 = J.gp(v_list_74, v_i_76)
			var _t30 = J.gp(_t29, 0.0)
			v_t1_79 = _t30
			var _t31 = J.gp(_t29, 1.0)
			v_b_80 = _t31
			var _t32 = J.gp(_t29, 2.0)
			v_e_81 = _t32
			var _t33 = env["mix"]
			var _t36 = J.S_Object_("assign", [{}, env["BASE"], v_a_78])
			var _t37 = J.S_Object_("assign", [{}, env["BASE"], v_b_80])
			var _t34 = env["ease"]
			var _t35 = (v_e_81 if J.t(v_e_81) else "io")
			return J.cl(_t33, null, [_t36, _t37, J.mc(_t34, _t35, [J.div(J.sub(v_p_75, v_t0_77), J.sub(v_t1_79, v_t0_77))])])
		v_i_76 = J.num(v_i_76) + 1.0
	return J.S_Object_("assign", [{}, env["BASE"], J.gp(J.gp(v_list_74, (J.len(v_list_74) - 1.0)), 1.0)])

func _f46(this_, a: Array, env):
	var v_sx_216 = null; var v_sy_217 = null; var v_tx_218 = null; var v_ty_219 = null; var v_L1_220 = null; var v_L2_221 = null; var v_dx_222 = null; var v_dy_223 = null; var v_d_224 = null; var v_base_225 = null; var v_c_226 = null; var v_a1_227 = null; var v_c2_228 = null
	v_sx_216 = J.arg(a, 0)
	v_sy_217 = J.arg(a, 1)
	v_tx_218 = J.arg(a, 2)
	v_ty_219 = J.arg(a, 3)
	v_L1_220 = J.arg(a, 4)
	v_L2_221 = J.arg(a, 5)
	v_dx_222 = J.sub(v_tx_218, v_sx_216)
	v_dy_223 = J.sub(v_ty_219, v_sy_217)
	v_d_224 = J.hypot_([v_dx_222, v_dy_223])
	var _t38 = J.min_([v_d_224, J.sub(J.add(v_L1_220, v_L2_221), 1.0)])
	v_d_224 = _t38
	v_base_225 = atan2(J.num((-J.num(v_dx_222))), J.num(v_dy_223))
	v_c_226 = J.max_([(-1.0), J.min_([1.0, J.div(((J.mul(v_L1_220, v_L1_220) + J.mul(v_d_224, v_d_224)) - J.mul(v_L2_221, v_L2_221)), J.mul(J.mul(2.0, v_L1_220), v_d_224))])])
	v_a1_227 = J.sub(v_base_225, acos(J.num(v_c_226)))
	v_c2_228 = J.max_([(-1.0), J.min_([1.0, J.div(((J.mul(v_L1_220, v_L1_220) + J.mul(v_L2_221, v_L2_221)) - J.mul(v_d_224, v_d_224)), J.mul(J.mul(2.0, v_L1_220), v_L2_221))])])
	return [v_a1_227, (PI - acos(J.num(v_c2_228)))]

func _f48(this_, a: Array, env):
	var v_ctx_234 = null; var v_R_235 = null; var v_pz_236 = null; var v_k_237 = null; var v_w_238 = null; var v_h_239 = null; var v_im_240 = null; var v_rx_241 = null; var v_ry_242 = null; var v_cut_243 = null; var v_pw_244 = null; var v_u0_245 = null; var v_step_246 = null; var v_y_247 = null; var v_f_248 = null; var v_off_249 = null; var v_hh_250 = null
	v_ctx_234 = J.arg(a, 0)
	v_R_235 = J.arg(a, 1)
	v_pz_236 = J.arg(a, 2)
	var _t39 = J.gp(v_R_235, "torso")
	var _t40 = J.gp(_t39, 0.0)
	v_k_237 = _t40
	var _t41 = J.gp(_t39, 1.0)
	v_w_238 = _t41
	var _t42 = J.gp(_t39, 2.0)
	v_h_239 = _t42
	v_im_240 = J.gp(J.G.get("SPR"), v_k_237)
	var _t43 = J.gp(v_R_235, "root")
	var _t44 = J.gp(_t43, 0.0)
	v_rx_241 = _t44
	var _t45 = J.gp(_t43, 1.0)
	v_ry_242 = _t45
	v_cut_243 = (v_h_239 if J.t(J.gp(v_R_235, "lF")) else J.sub(v_ry_242, 20.0))
	v_pw_244 = J.div(J.gp(v_im_240, "naturalWidth"), v_w_238)
	J.mc(v_ctx_234, "save", [])
	J.mc(v_ctx_234, "scale", [(-1.0), 1.0])
	v_u0_245 = J.sub(v_rx_241, v_w_238)
	J.mc(v_ctx_234, "drawImage", [v_im_240, 0.0, 0.0, J.gp(v_im_240, "naturalWidth"), J.mul(v_cut_243, v_pw_244), v_u0_245, (-J.num(v_ry_242)), v_w_238, v_cut_243])
	v_step_246 = 8.0
	v_y_247 = v_cut_243
	while true:
		if not J.cmp(v_y_247, J.sub(v_h_239, 0.5), "<"): break
		v_f_248 = J.div(J.sub(v_y_247, v_cut_243), J.sub(v_h_239, v_cut_243))
		var _t47 = J.mul(J.mul((sin(J.num((J.mul(J.gp(v_pz_236, "tail"), 3.2) - J.mul(v_f_248, 3.0)))) * 16.0), v_f_248), v_f_248)
		var _t46 = J.gp(v_pz_236, "lean")
		v_off_249 = (_t47 + J.mul(J.mul(J.mul((_t46 if J.t(_t46) else 0.0), (-40.0)), v_f_248), v_f_248))
		v_hh_250 = J.min_([v_step_246, J.sub(v_h_239, v_y_247)])
		J.mc(v_ctx_234, "drawImage", [v_im_240, 0.0, J.mul(v_y_247, v_pw_244), J.gp(v_im_240, "naturalWidth"), J.mul(v_hh_250, v_pw_244), J.sub(v_u0_245, v_off_249), J.sub(v_y_247, v_ry_242), v_w_238, J.add(v_hh_250, 0.8)])
		var _t48 = J.add(v_y_247, v_step_246)
		v_y_247 = _t48
	J.mc(v_ctx_234, "restore", [])

func _f50(this_, a: Array, env):
	var v_hp_293 = null; var v_a_294 = null; var v_L_295 = null
	v_hp_293 = J.arg(a, 0)
	v_a_294 = J.arg(a, 1)
	v_L_295 = J.arg(a, 2)
	J.mc(env["__p"]["ctx"], "save", [])
	J.mc(env["__p"]["ctx"], "translate", [J.sub(J.gp(v_hp_293, 0.0), env["rx0"]), J.sub(J.gp(v_hp_293, 1.0), env["ry0"])])
	J.mc(env["__p"]["ctx"], "rotate", [v_a_294])
	J.mc(env["__p"]["ctx"], "scale", [env["LS"], env["LS"]])
	var _t55 = env["__p"]["__p"]["img"]
	J.cl(_t55, null, [J.gp(v_L_295, 0.0), (-J.num(J.gp(J.gp(v_L_295, 3.0), 0.0))), (-J.num(J.gp(J.gp(v_L_295, 3.0), 1.0))), J.gp(v_L_295, 1.0), J.gp(v_L_295, 2.0), env["__p"]["ctx"]])
	J.mc(env["__p"]["ctx"], "restore", [])

func _f51(this_, a: Array, env):
	var v_sh_300 = null; var v_a_301 = null; var v_e_302 = null; var v_U_303 = null; var v_Fm_304 = null; var v_isFront_305 = null
	v_sh_300 = J.arg(a, 0)
	v_a_301 = J.arg(a, 1)
	v_e_302 = J.arg(a, 2)
	v_U_303 = J.arg(a, 3)
	v_Fm_304 = J.arg(a, 4)
	v_isFront_305 = J.arg(a, 5)
	J.mc(env["ctx"], "save", [])
	J.mc(env["ctx"], "translate", [J.gp(v_sh_300, 0.0), J.gp(v_sh_300, 1.0)])
	J.mc(env["ctx"], "rotate", [v_a_301])
	J.mc(env["ctx"], "scale", [env["AS"], env["AS"]])
	var _t76 = env["__p"]["img"]
	J.cl(_t76, null, [J.gp(v_U_303, 0.0), (-J.num(J.gp(J.gp(v_U_303, 3.0), 0.0))), (-J.num(J.gp(J.gp(v_U_303, 3.0), 1.0))), J.gp(v_U_303, 1.0), J.gp(v_U_303, 2.0), env["ctx"]])
	J.mc(env["ctx"], "translate", [J.sub(J.gp(J.gp(v_U_303, 4.0), 0.0), J.gp(J.gp(v_U_303, 3.0), 0.0)), J.sub(J.gp(J.gp(v_U_303, 4.0), 1.0), J.gp(J.gp(v_U_303, 3.0), 1.0))])
	J.mc(env["ctx"], "rotate", [v_e_302])
	if J.t((env["T"] if J.t(v_isFront_305) else v_isFront_305)):
		J.mc(env["ctx"], "save", [])
		J.mc(env["ctx"], "translate", [J.sub(J.gp(J.gp(v_Fm_304, 4.0), 0.0), J.gp(J.gp(v_Fm_304, 3.0), 0.0)), J.sub(J.gp(J.gp(v_Fm_304, 4.0), 1.0), J.gp(J.gp(v_Fm_304, 3.0), 1.0))])
		J.mc(env["ctx"], "rotate", [J.gp(env["pz"], "tr")])
		if J.t(J.gp(env["T"], 4.0)):
			J.mc(env["ctx"], "scale", [(-1.0), 1.0])
		if J.t(J.gp(env["R"], "toolS")):
			J.mc(env["ctx"], "scale", [J.gp(env["R"], "toolS"), J.gp(env["R"], "toolS")])
		var _t77 = env["__p"]["img"]
		J.cl(_t77, null, [J.gp(env["T"], 0.0), (-J.num(J.gp(J.gp(env["T"], 3.0), 0.0))), (-J.num(J.gp(J.gp(env["T"], 3.0), 1.0))), J.gp(env["T"], 1.0), J.gp(env["T"], 2.0), env["ctx"]])
		J.mc(env["ctx"], "restore", [])
	var _t78 = env["__p"]["img"]
	J.cl(_t78, null, [J.gp(v_Fm_304, 0.0), (-J.num(J.gp(J.gp(v_Fm_304, 3.0), 0.0))), (-J.num(J.gp(J.gp(v_Fm_304, 3.0), 1.0))), J.gp(v_Fm_304, 1.0), J.gp(v_Fm_304, 2.0), env["ctx"]])
	J.mc(env["ctx"], "restore", [])

func _f49(this_, a: Array, env):
	var v_id_254 = null; var v_x_255 = null; var v_y_256 = null; var v_worldH_257 = null; var v_flip_259 = null; var v_k_261 = null; var v_rx_263 = null; var v_ry_264 = null; var v_sF_266 = null; var v_uF_267 = null; var v_fF_268 = null; var v_uB_269 = null; var v_fB_270 = null; var v_L1F_271 = null; var v_L2F_272 = null; var v_e1_273 = null; var v_elb_274 = null; var v_e2_275 = null; var v_grip_276 = null; var v_aB_277 = null; var v_eB_278 = null; var v_sB_279 = null; var v_arm_280 = null; var v_hk_281 = null; var v_hi_282 = null; var v_hw0_283 = null; var v_hh0_284 = null; var v_fx_285 = null; var v_fy_286 = null; var v_hw_287 = null; var v_hh_288 = null; var v_leg_292 = null; var v_ta_296 = null; var v_d_297 = null; var v_L1B_298 = null; var v_L2B_299 = null
	var _s63 = {"__p": env, "ctx": null, "pz": null, "R": null, "AS": null, "T": null}
	_s63["ctx"] = J.arg(a, 0)
	v_id_254 = J.arg(a, 1)
	v_x_255 = J.arg(a, 2)
	v_y_256 = J.arg(a, 3)
	v_worldH_257 = J.arg(a, 4)
	_s63["pz"] = J.arg(a, 5)
	v_flip_259 = J.arg(a, 6)
	_s63["R"] = J.gp(_s63["__p"]["RIGS"], v_id_254)
	v_k_261 = J.div(v_worldH_257, J.gp(_s63["R"], "h"))
	J.mc(_s63["ctx"], "save", [])
	var _t49 = J.gp(_s63["pz"], "dy")
	J.mc(_s63["ctx"], "translate", [v_x_255, J.add(v_y_256, J.div(J.mul((_t49 if J.t(_t49) else 0.0), v_worldH_257), 58.0))])
	if J.t(v_flip_259):
		J.mc(_s63["ctx"], "scale", [(-1.0), 1.0])
	J.mc(_s63["ctx"], "scale", [J.mul(v_k_261, J.gp(_s63["pz"], "sx")), J.mul(v_k_261, J.gp(_s63["pz"], "sy"))])
	var _t50 = J.gp(_s63["pz"], "jx")
	J.mc(_s63["ctx"], "translate", [(J.div((_t50 if J.t(_t50) else 0.0), v_k_261) * J.div(v_worldH_257, 58.0)), (-J.sub(J.gp(_s63["R"], "tailY"), J.gp(J.gp(_s63["R"], "root"), 1.0)))])
	if J.t(J.gp(_s63["R"], "lF")):
		var _s64 = {"__p": _s63, "LS": null, "rx0": null, "ry0": null}
		var _t51 = J.gp(_s64["__p"]["R"], "legS")
		_s64["LS"] = (_t51 if J.t(_t51) else 1.0)
		var _t52 = J.gp(_s64["__p"]["R"], "root")
		var _t53 = J.gp(_t52, 0.0)
		_s64["rx0"] = _t53
		var _t54 = J.gp(_t52, 1.0)
		_s64["ry0"] = _t54
		v_leg_292 = Callable(self, "_f50").bind(_s64)
		var _t57 = J.gp(_s64["__p"]["R"], "hipB")
		var _t56 = J.gp(_s64["__p"]["pz"], "lB")
		J.cl(v_leg_292, null, [_t57, (_t56 if J.t(_t56) else 0.0), J.gp(_s64["__p"]["R"], "lB")])
		var _t59 = J.gp(_s64["__p"]["R"], "hipF")
		var _t58 = J.gp(_s64["__p"]["pz"], "lF")
		J.cl(v_leg_292, null, [_t59, (_t58 if J.t(_t58) else 0.0), J.gp(_s64["__p"]["R"], "lF")])
	J.mc(_s63["ctx"], "rotate", [(-J.num(J.gp(_s63["pz"], "lean")))])
	var _t60 = J.gp(_s63["R"], "armS")
	_s63["AS"] = (_t60 if J.t(_t60) else 0.62)
	var _t61 = J.gp(_s63["R"], "root")
	var _t62 = J.gp(_t61, 0.0)
	v_rx_263 = _t62
	var _t63 = J.gp(_t61, 1.0)
	v_ry_264 = _t63
	if J.seq(J.gp(_s63["pz"], "tool"), "_P"):
		var _t64 = J.S_Object_("assign", [{}, _s63["pz"], {"tool": (J.add("_", v_id_254) if J.t(J.gp(_s63["R"], "tool")) else null)}])
		_s63["pz"] = _t64
	var _t66 = J.seq(J.gp(_s63["pz"], "tool"), "_W")
	if not J.t(_t66):
		var _t65 = J.seq(J.gp(_s63["pz"], "tool"), "axe")
		_t66 = ((not J.seq(v_id_254, "afu")) if _t65 else _t65)
	if _t66:
		var _t67 = J.S_Object_("assign", [{}, _s63["pz"], {"tool": (J.add("_", v_id_254) if J.t(J.gp(_s63["R"], "tool")) else ("axe" if J.seq(v_id_254, "afu") else null))}])
		_s63["pz"] = _t67
	var _t68 = _s63["__p"]["toolDef"]
	_s63["T"] = J.cl(_t68, null, [J.gp(_s63["pz"], "tool")])
	v_sF_266 = [J.sub(J.gp(J.gp(_s63["R"], "shF"), 0.0), v_rx_263), J.sub(J.gp(J.gp(_s63["R"], "shF"), 1.0), v_ry_264)]
	v_uF_267 = J.gp(_s63["R"], "uF")
	v_fF_268 = J.gp(_s63["R"], "fF")
	v_uB_269 = J.gp(_s63["R"], "uB")
	v_fB_270 = J.gp(_s63["R"], "fB")
	v_L1F_271 = J.mul(J.sub(J.gp(J.gp(v_uF_267, 4.0), 1.0), J.gp(J.gp(v_uF_267, 3.0), 1.0)), _s63["AS"])
	v_L2F_272 = J.mul(J.sub(J.gp(J.gp(v_fF_268, 4.0), 1.0), J.gp(J.gp(v_fF_268, 3.0), 1.0)), _s63["AS"])
	var _t69 = _s63["__p"]["rot"]
	v_e1_273 = J.cl(_t69, null, [0.0, v_L1F_271, J.gp(_s63["pz"], "aF")])
	v_elb_274 = [J.add(J.gp(v_sF_266, 0.0), J.gp(v_e1_273, 0.0)), J.add(J.gp(v_sF_266, 1.0), J.gp(v_e1_273, 1.0))]
	var _t70 = _s63["__p"]["rot"]
	v_e2_275 = J.cl(_t70, null, [0.0, v_L2F_272, J.add(J.gp(_s63["pz"], "aF"), J.gp(_s63["pz"], "eF"))])
	v_grip_276 = [J.add(J.gp(v_elb_274, 0.0), J.gp(v_e2_275, 0.0)), J.add(J.gp(v_elb_274, 1.0), J.gp(v_e2_275, 1.0))]
	v_aB_277 = J.gp(_s63["pz"], "aB")
	v_eB_278 = J.gp(_s63["pz"], "eB")
	v_sB_279 = [J.sub(J.gp(J.gp(_s63["R"], "shB"), 0.0), v_rx_263), J.sub(J.gp(J.gp(_s63["R"], "shB"), 1.0), v_ry_264)]
	if J.t((J.gp(_s63["pz"], "ik") if J.t(_s63["T"]) else _s63["T"])):
		v_ta_296 = J.add(J.add(J.gp(_s63["pz"], "aF"), J.gp(_s63["pz"], "eF")), J.gp(_s63["pz"], "tr"))
		var _t71 = _s63["__p"]["rot"]
		v_d_297 = J.cl(_t71, null, [0.0, J.mul(70.0, _s63["AS"]), v_ta_296])
		v_L1B_298 = J.mul(J.sub(J.gp(J.gp(v_uB_269, 4.0), 1.0), J.gp(J.gp(v_uB_269, 3.0), 1.0)), _s63["AS"])
		v_L2B_299 = J.mul(J.sub(J.gp(J.gp(v_fB_270, 4.0), 1.0), J.gp(J.gp(v_fB_270, 3.0), 1.0)), _s63["AS"])
		var _t72 = _s63["__p"]["ik2"]
		var _t73 = J.cl(_t72, null, [J.gp(v_sB_279, 0.0), J.gp(v_sB_279, 1.0), J.add(J.gp(v_grip_276, 0.0), J.gp(v_d_297, 0.0)), J.add(J.gp(v_grip_276, 1.0), J.gp(v_d_297, 1.0)), v_L1B_298, v_L2B_299])
		var _t74 = J.gp(_t73, 0.0)
		v_aB_277 = _t74
		var _t75 = J.gp(_t73, 1.0)
		v_eB_278 = _t75
	v_arm_280 = Callable(self, "_f51").bind(_s63)
	J.cl(v_arm_280, null, [v_sB_279, v_aB_277, v_eB_278, v_uB_269, v_fB_270, false])
	var _t79 = _s63["__p"]["drawTorso"]
	J.cl(_t79, null, [_s63["ctx"], _s63["R"], _s63["pz"]])
	var _t81 = J.gp(J.gp(_s63["R"], "heads"), J.gp(_s63["pz"], "hk"))
	if J.t(_t81):
		var _t80 = _s63["__p"]["ok"]
		_t81 = J.cl(_t80, null, [J.gp(J.gp(_s63["R"], "heads"), J.gp(_s63["pz"], "hk"))])
	v_hk_281 = (J.gp(J.gp(_s63["R"], "heads"), J.gp(_s63["pz"], "hk")) if J.t(_t81) else J.gp(J.gp(_s63["R"], "heads"), "n"))
	v_hi_282 = J.gp(J.G.get("SPR"), v_hk_281)
	var _t82 = J.gp(_s63["R"], "head")
	var _t83 = J.gp(_t82, 0.0)
	v_hw0_283 = _t83
	var _t84 = J.gp(_t82, 1.0)
	v_hh0_284 = _t84
	var _t85 = J.gp(_t82, 2.0)
	v_fx_285 = _t85
	var _t86 = J.gp(_t82, 3.0)
	v_fy_286 = _t86
	v_hw_287 = v_hw0_283
	v_hh_288 = J.div(J.mul(v_hw0_283, J.gp(v_hi_282, "naturalHeight")), J.gp(v_hi_282, "naturalWidth"))
	J.mc(_s63["ctx"], "save", [])
	J.mc(_s63["ctx"], "translate", [J.sub(J.gp(J.gp(_s63["R"], "neck"), 0.0), v_rx_263), (J.sub(J.gp(J.gp(_s63["R"], "neck"), 1.0), v_ry_264) + 10.0)])
	J.mc(_s63["ctx"], "rotate", [(-J.num(J.gp(_s63["pz"], "head")))])
	J.mc(_s63["ctx"], "scale", [(-1.0), 1.0])
	J.mc(_s63["ctx"], "drawImage", [v_hi_282, ((-J.num(v_hw_287)) * J.sub(1.0, v_fx_285)), J.mul((-J.num(v_hh_288)), v_fy_286), v_hw_287, v_hh_288])
	J.mc(_s63["ctx"], "restore", [])
	J.cl(v_arm_280, null, [v_sF_266, J.gp(_s63["pz"], "aF"), J.gp(_s63["pz"], "eF"), v_uF_267, v_fF_268, true])
	J.mc(_s63["ctx"], "restore", [])
	return v_grip_276

func _f52(this_, a: Array, env):
	var v_id_308 = null; var v_x_309 = null; var v_y_310 = null; var v_worldH_311 = null; var v_pz_312 = null; var v_flip_313 = null; var v_along_314 = null; var v_R_315 = null; var v_k_316 = null; var v_rx_317 = null; var v_ry_318 = null; var v_T_319 = null; var v_AS_320 = null; var v_uF_321 = null; var v_fF_322 = null; var v_L1F_323 = null; var v_L2F_324 = null; var v_p_325 = null; var v_r1_326 = null; var v_w_327 = null; var v_d_328 = null
	v_id_308 = J.arg(a, 0)
	v_x_309 = J.arg(a, 1)
	v_y_310 = J.arg(a, 2)
	v_worldH_311 = J.arg(a, 3)
	v_pz_312 = J.arg(a, 4)
	v_flip_313 = J.arg(a, 5)
	v_along_314 = J.arg(a, 6)
	v_R_315 = J.gp(env["RIGS"], v_id_308)
	v_k_316 = J.div(v_worldH_311, J.gp(v_R_315, "h"))
	var _t87 = J.gp(v_R_315, "root")
	var _t88 = J.gp(_t87, 0.0)
	v_rx_317 = _t88
	var _t89 = J.gp(_t87, 1.0)
	v_ry_318 = _t89
	var _t90 = env["toolDef"]
	v_T_319 = J.cl(_t90, null, [J.gp(v_pz_312, "tool")])
	var _t91 = J.gp(v_R_315, "armS")
	v_AS_320 = (_t91 if J.t(_t91) else 0.62)
	v_uF_321 = J.gp(v_R_315, "uF")
	v_fF_322 = J.gp(v_R_315, "fF")
	v_L1F_323 = J.mul(J.sub(J.gp(J.gp(v_uF_321, 4.0), 1.0), J.gp(J.gp(v_uF_321, 3.0), 1.0)), v_AS_320)
	v_L2F_324 = J.mul(J.sub(J.gp(J.gp(v_fF_322, 4.0), 1.0), J.gp(J.gp(v_fF_322, 3.0), 1.0)), v_AS_320)
	v_p_325 = [J.sub(J.gp(J.gp(v_R_315, "shF"), 0.0), v_rx_317), J.sub(J.gp(J.gp(v_R_315, "shF"), 1.0), v_ry_318)]
	var _t92 = env["rot"]
	v_r1_326 = J.cl(_t92, null, [0.0, v_L1F_323, J.gp(v_pz_312, "aF")])
	var _t93 = [J.add(J.gp(v_p_325, 0.0), J.gp(v_r1_326, 0.0)), J.add(J.gp(v_p_325, 1.0), J.gp(v_r1_326, 1.0))]
	v_p_325 = _t93
	var _t94 = env["rot"]
	var _t95 = J.cl(_t94, null, [0.0, v_L2F_324, J.add(J.gp(v_pz_312, "aF"), J.gp(v_pz_312, "eF"))])
	v_r1_326 = _t95
	var _t96 = [J.add(J.gp(v_p_325, 0.0), J.gp(v_r1_326, 0.0)), J.add(J.gp(v_p_325, 1.0), J.gp(v_r1_326, 1.0))]
	v_p_325 = _t96
	if J.t(v_T_319):
		var _t97 = env["rot"]
		v_d_328 = J.cl(_t97, null, [0.0, J.mul((-J.num((v_along_314 if J.t(v_along_314) else J.mul(J.gp(v_T_319, 2.0), 0.7)))), v_AS_320), J.add(J.add(J.gp(v_pz_312, "aF"), J.gp(v_pz_312, "eF")), J.gp(v_pz_312, "tr"))])
		var _t98 = [J.add(J.gp(v_p_325, 0.0), J.gp(v_d_328, 0.0)), J.add(J.gp(v_p_325, 1.0), J.gp(v_d_328, 1.0))]
		v_p_325 = _t98
	var _t99 = env["rot"]
	v_w_327 = J.cl(_t99, null, [J.gp(v_p_325, 0.0), J.gp(v_p_325, 1.0), (-J.num(J.gp(v_pz_312, "lean")))])
	var _t100 = [J.gp(v_w_327, 0.0), J.sub(J.gp(v_w_327, 1.0), J.sub(J.gp(v_R_315, "tailY"), J.gp(J.gp(v_R_315, "root"), 1.0)))]
	v_w_327 = _t100
	var _t101 = [J.mul(J.mul(J.gp(v_w_327, 0.0), v_k_316), J.gp(v_pz_312, "sx")), J.mul(J.mul(J.gp(v_w_327, 1.0), v_k_316), J.gp(v_pz_312, "sy"))]
	v_w_327 = _t101
	var _t103 = J.add(v_x_309, ((-J.num(J.gp(v_w_327, 0.0))) if J.t(v_flip_313) else J.gp(v_w_327, 0.0)))
	var _t102 = J.gp(v_pz_312, "dy")
	return [_t103, J.add(J.add(v_y_310, J.div(J.mul((_t102 if J.t(_t102) else 0.0), v_worldH_311), 58.0)), J.gp(v_w_327, 1.0))]

func _f5(this_, a: Array, env):
	var v_k_42 = null
	v_k_42 = J.arg(a, 0)
	var _t105 = J.seq(J.typeof_(J.G.get("sprOk")), "function")
	if J.t(_t105):
		var _t104 = J.G.get("sprOk")
		_t105 = J.cl(_t104, null, [v_k_42])
	return _t105

func _f6(this_, a: Array, env):
	var v_id_43 = null; var v_r_44 = null
	v_id_43 = J.arg(a, 0)
	if (not J.t(J.G.get("PUPPET_ON"))):
		return false
	v_r_44 = J.gp(env["RIGS"], v_id_43)
	if J.t(v_r_44):
		var _t106 = env["mirror"]
		J.cl(_t106, null, [v_r_44])
	var _t108 = v_r_44
	if J.t(_t108):
		var _t107 = env["ok"]
		_t108 = J.cl(_t107, null, [J.gp(J.gp(v_r_44, "torso"), 0.0)])
	var _t110 = _t108
	if J.t(_t110):
		var _t109 = env["ok"]
		_t110 = J.cl(_t109, null, [J.gp(J.gp(v_r_44, "heads"), "n")])
	var _t112 = _t110
	if J.t(_t112):
		var _t111 = env["ok"]
		_t112 = J.cl(_t111, null, [J.gp(J.gp(v_r_44, "uF"), 0.0)])
	var _t114 = _t112
	if J.t(_t114):
		var _t113 = env["ok"]
		_t114 = J.cl(_t113, null, [J.gp(J.gp(v_r_44, "fF"), 0.0)])
	var _t116 = _t114
	if J.t(_t116):
		var _t115 = env["ok"]
		_t116 = J.cl(_t115, null, [J.gp(J.gp(v_r_44, "uB"), 0.0)])
	var _t118 = _t116
	if J.t(_t118):
		var _t117 = env["ok"]
		_t118 = J.cl(_t117, null, [J.gp(J.gp(v_r_44, "fB"), 0.0)])
	return (not (not J.t(_t118)))

func _f7(this_, a: Array, env):
	var v_k_45 = null; var v_x_46 = null; var v_y_47 = null; var v_w_48 = null; var v_h_49 = null; var v_ctx_50 = null
	v_k_45 = J.arg(a, 0)
	v_x_46 = J.arg(a, 1)
	v_y_47 = J.arg(a, 2)
	v_w_48 = J.arg(a, 3)
	v_h_49 = J.arg(a, 4)
	v_ctx_50 = J.arg(a, 5)
	J.mc(v_ctx_50, "save", [])
	J.mc(v_ctx_50, "scale", [(-1.0), 1.0])
	J.mc(v_ctx_50, "drawImage", [J.gp(J.G.get("SPR"), v_k_45), J.sub((-J.num(v_x_46)), v_w_48), v_y_47, v_w_48, v_h_49])
	J.mc(v_ctx_50, "restore", [])

func _f9(this_, a: Array, env):
	var v_t_57 = null
	v_t_57 = J.arg(a, 0)
	return v_t_57

func _f10(this_, a: Array, env):
	var v_t_58 = null
	v_t_58 = J.arg(a, 0)
	return J.mul(v_t_58, v_t_58)

func _f11(this_, a: Array, env):
	var v_t_59 = null
	v_t_59 = J.arg(a, 0)
	return (1.0 - (J.sub(1.0, v_t_59) * J.sub(1.0, v_t_59)))

func _f12(this_, a: Array, env):
	var v_t_60 = null
	v_t_60 = J.arg(a, 0)
	return (J.mul(J.mul(2.0, v_t_60), v_t_60) if J.cmp(v_t_60, 0.5, "<") else (1.0 - ((2.0 * J.sub(1.0, v_t_60)) * J.sub(1.0, v_t_60))))

func _f13(this_, a: Array, env):
	var v_t_61 = null; var v_c_62 = null
	v_t_61 = J.arg(a, 0)
	v_c_62 = 1.9
	return ((1.0 + J.mul(J.add(v_c_62, 1.0), pow(J.num(J.sub(v_t_61, 1.0)), J.num(3.0)))) + J.mul(v_c_62, pow(J.num(J.sub(v_t_61, 1.0)), J.num(2.0))))

func _f16(this_, a: Array, env):
	var v_t_84 = null; var v_b_85 = null
	v_t_84 = J.arg(a, 0)
	v_b_85 = sin(J.num(J.mul(v_t_84, 2.2)))
	return J.S_Object_("assign", [{}, env["BASE"], {"dy": J.mul(v_b_85, 2.5), "sy": (1.0 + J.mul(v_b_85, 0.012)), "sx": (1.0 - J.mul(v_b_85, 0.008)), "head": (sin(J.num(J.mul(v_t_84, 1.1))) * 0.05), "aF": (0.35 + (sin(J.num(J.mul(v_t_84, 1.7))) * 0.06)), "eF": (0.55 + (sin(J.num((J.mul(v_t_84, 1.7) + 0.6))) * 0.08)), "aB": ((-0.3) + (sin(J.num((J.mul(v_t_84, 1.7) + 1.0))) * 0.05)), "eB": 0.5, "tail": v_t_84, "tool": null}])

func _f17(this_, a: Array, env):
	var v_t_88 = null; var v_s_89 = null
	v_t_88 = J.arg(a, 0)
	v_s_89 = sin(J.num(J.mul(v_t_88, 7.0)))
	return J.S_Object_("assign", [{}, env["BASE"], {"lean": 0.2, "dy": (absf(J.num(cos(J.num(J.mul(v_t_88, 7.0))))) * (-3.0)), "head": (0.05 + J.mul(v_s_89, 0.04)), "aF": ((-0.35) + J.mul(v_s_89, 0.55)), "eF": 0.35, "aB": (0.25 - J.mul(v_s_89, 0.55)), "eB": 0.35, "tail": J.mul(v_t_88, 2.6)}])

func _f18(this_, a: Array, env):
	var v_p_92 = null; var v_t_93 = null
	v_p_92 = J.arg(a, 0)
	v_t_93 = J.arg(a, 1)
	var _t119 = env["keys"]
	return J.S_Object_("assign", [J.cl(_t119, null, [[[0.0, env["CHOP_STRIKE"]], [0.16, env["CHOP_STRIKE"]], [0.5, J.S_Object_("assign", [{}, env["CHOP_UP"], {"aF": 2.6, "aB": 2.2, "lean": (-0.1), "hk": "n"}]), "io"], [0.8, env["CHOP_UP"], "out"], [1.0, env["CHOP_STRIKE"], "in"]], v_p_92]), {"tail": v_t_93}])

func _f19(this_, a: Array, env):
	var v_p_96 = null; var v_t_97 = null; var v_q_98 = null; var v_up_99 = null; var v_dn_100 = null
	v_p_96 = J.arg(a, 0)
	v_t_97 = J.arg(a, 1)
	v_q_98 = J.mod(J.mul(v_p_96, 2.0), 1.0)
	v_up_99 = {"lean": (-0.02), "dy": (-3.0), "head": (-0.12), "hk": "s", "aF": 2.7, "eF": 0.5, "aB": 0.6, "eB": 0.9, "tool": "mallet", "tr": (-1.7)}
	v_dn_100 = {"lean": 0.25, "dy": 3.0, "sx": 1.03, "sy": 0.96, "head": 0.25, "hk": "s", "aF": 0.75, "eF": 0.35, "aB": 0.7, "eB": 0.9, "tool": "mallet", "tr": (-3.2)}
	var _t120 = env["keys"]
	return J.S_Object_("assign", [J.cl(_t120, null, [[[0.0, v_dn_100], [0.12, v_dn_100], [0.7, v_up_99, "io"], [1.0, v_dn_100, "in"]], v_q_98]), {"tail": v_t_97}])

func _f20(this_, a: Array, env):
	var v_p_103 = null; var v_t_104 = null; var v_a_105 = null; var v_b_106 = null
	v_p_103 = J.arg(a, 0)
	v_t_104 = J.arg(a, 1)
	v_a_105 = sin(J.num((J.mul(v_p_103, PI) * 4.0)))
	v_b_106 = sin(J.num(((J.mul(v_p_103, PI) * 4.0) + PI)))
	return J.S_Object_("assign", [{}, env["BASE"], {"lean": (0.42 + J.mul(v_a_105, 0.04)), "dy": (2.0 + (absf(J.num(v_a_105)) * 2.0)), "head": 0.3, "hk": ("p" if J.cmp(v_p_103, 0.85, ">") else "s"), "aF": (0.9 + J.mul(v_a_105, 0.35)), "eF": (0.5 - J.mul(v_a_105, 0.25)), "aB": (0.95 + J.mul(v_b_106, 0.35)), "eB": (0.45 - J.mul(v_b_106, 0.25)), "tail": v_t_104, "sx": (1.0 + (J.max_([0.0, v_a_105]) * 0.03)), "sy": (1.0 - (J.max_([0.0, v_a_105]) * 0.03))}])

func _f21(this_, a: Array, env):
	var v_p_109 = null; var v_t_110 = null; var v_w_111 = null
	v_p_109 = J.arg(a, 0)
	v_t_110 = J.arg(a, 1)
	v_w_111 = sin(J.num((J.mul(v_p_109, PI) * 6.0)))
	return J.S_Object_("assign", [{}, env["BASE"], {"lean": 0.55, "dy": 4.0, "head": (0.28 + J.mul(v_w_111, 0.05)), "hk": ("p" if J.cmp(v_p_109, 0.85, ">") else "s"), "aF": (0.4 + J.mul(v_w_111, 0.75)), "eF": 0.25, "aB": (0.85 - J.mul(v_w_111, 0.2)), "eB": 0.6, "tool": "sickle", "tr": ((-1.3) - J.mul(v_w_111, 0.25)), "tail": v_t_110}])

func _f22(this_, a: Array, env):
	var v_p_114 = null; var v_t_115 = null; var v_a_116 = null
	v_p_114 = J.arg(a, 0)
	v_t_115 = J.arg(a, 1)
	v_a_116 = J.S_Object_("assign", [{}, env["BASE"], {"tool": "_W", "tr": (-1.4), "ik": 1.0}])
	var _t121 = env["mix"]
	return J.S_Object_("assign", [J.cl(_t121, null, [v_a_116, env["CHOP_UP"], J.mc(env["ease"], "out", [J.min_([1.0, v_p_114])])]), {"tail": v_t_115}])

func _f23(this_, a: Array, env):
	var v_p_119 = null; var v_t_120 = null
	v_p_119 = J.arg(a, 0)
	v_t_120 = J.arg(a, 1)
	var _t122 = env["mix"]
	return J.S_Object_("assign", [J.cl(_t122, null, [env["CHOP_UP"], env["CHOP_STRIKE"], J.mc(env["ease"], "out", [J.min_([1.0, J.mul(v_p_119, 1.6)])])]), {"tail": v_t_120}])

func _f24(this_, a: Array, env):
	var v_p_123 = null; var v_t_124 = null
	v_p_123 = J.arg(a, 0)
	v_t_124 = J.arg(a, 1)
	var _t123 = env["mix"]
	return J.S_Object_("assign", [J.cl(_t123, null, [env["CHOP_STRIKE"], J.S_Object_("assign", [{}, env["BASE"], {"tool": "_W", "tr": (-1.4)}]), J.mc(env["ease"], "io", [J.min_([1.0, v_p_123])])]), {"tail": v_t_124}])

func _f25(this_, a: Array, env):
	var v_p_127 = null; var v_t_128 = null
	v_p_127 = J.arg(a, 0)
	v_t_128 = J.arg(a, 1)
	var _t124 = env["mix"]
	return J.S_Object_("assign", [J.cl(_t124, null, [env["BASE"], env["CLAW_UP"], J.mc(env["ease"], "out", [J.min_([1.0, v_p_127])])]), {"tail": v_t_128}])

func _f26(this_, a: Array, env):
	var v_p_131 = null; var v_t_132 = null
	v_p_131 = J.arg(a, 0)
	v_t_132 = J.arg(a, 1)
	var _t125 = env["mix"]
	return J.S_Object_("assign", [J.cl(_t125, null, [env["CLAW_UP"], env["CLAW_HIT"], J.mc(env["ease"], "out", [J.min_([1.0, J.mul(v_p_131, 1.6)])])]), {"tail": v_t_132}])

func _f27(this_, a: Array, env):
	var v_p_135 = null; var v_t_136 = null
	v_p_135 = J.arg(a, 0)
	v_t_136 = J.arg(a, 1)
	var _t126 = env["mix"]
	return J.S_Object_("assign", [J.cl(_t126, null, [env["CLAW_HIT"], env["BASE"], J.mc(env["ease"], "io", [J.min_([1.0, v_p_135])])]), {"tail": v_t_136}])

func _f28(this_, a: Array, env):
	var v_p_139 = null; var v_t_140 = null; var v_w_141 = null
	v_p_139 = J.arg(a, 0)
	v_t_140 = J.arg(a, 1)
	v_w_141 = (sin(J.num(J.mul(v_t_140, 18.0))) * 0.06)
	return J.S_Object_("assign", [{}, env["BASE"], {"lean": (-0.12), "dy": ((-4.0) - J.mul(v_p_139, 4.0)), "hk": "a", "head": (-0.2), "aF": J.add(2.0, v_w_141), "eF": (-0.4), "aB": J.sub(1.8, v_w_141), "eB": (-0.3), "tail": v_t_140, "sx": (1.0 + J.mul(v_p_139, 0.04)), "sy": (1.0 + J.mul(v_p_139, 0.04))}])

func _f29(this_, a: Array, env):
	var v_p_144 = null; var v_t_145 = null
	v_p_144 = J.arg(a, 0)
	v_t_145 = J.arg(a, 1)
	return J.S_Object_("assign", [J.mc(env["ANIMS"], "idle", [v_t_145]), {"hk": "p", "head": (-0.15), "aF": (-0.25), "eF": 2.2, "aB": (-0.3), "eB": 2.1}])

func _f30(this_, a: Array, env):
	var v_p_148 = null; var v_t_149 = null
	v_p_148 = J.arg(a, 0)
	v_t_149 = J.arg(a, 1)
	return J.S_Object_("assign", [J.mc(env["ANIMS"], "hurt", [0.0, v_t_149]), {"hk": "h", "lean": J.mul((-0.6), v_p_148), "dy": J.mul((-6.0), v_p_148)}])

func _f31(this_, a: Array, env):
	var v_p_152 = null; var v_t_153 = null; var v_k_154 = null
	v_p_152 = J.arg(a, 0)
	v_t_153 = J.arg(a, 1)
	v_k_154 = J.max_([0.0, J.sub(1.0, v_p_152)])
	return J.S_Object_("assign", [{}, env["BASE"], {"lean": J.mul((-0.35), v_k_154), "dy": J.mul((-4.0), v_k_154), "hk": "h", "head": J.mul((-0.3), v_k_154), "aF": (J.mul(1.2, v_k_154) + 0.1), "eF": J.mul(0.9, v_k_154), "aB": J.mul(1.0, v_k_154), "eB": J.mul(1.1, v_k_154), "tail": v_t_153, "sx": (1.0 - J.mul(0.06, v_k_154)), "sy": (1.0 + J.mul(0.06, v_k_154))}])

func _f32(this_, a: Array, env):
	var v_o_155 = null
	v_o_155 = J.arg(a, 0)
	return J.S_Object_("assign", [{}, env["BASE"], v_o_155])

func _f33(this_, a: Array, env):
	var v_t_158 = null; var v_s_159 = null
	v_t_158 = J.arg(a, 0)
	v_s_159 = sin(J.num(J.mul(v_t_158, 8.0)))
	var _t127 = env["H_"]
	return J.cl(_t127, null, [{"lean": 0.06, "dy": ((-absf(J.num(cos(J.num(J.mul(v_t_158, 8.0)))))) * 1.6), "head": (sin(J.num(J.mul(v_t_158, 8.0))) * 0.03), "aF": ((-J.num(v_s_159)) * 0.45), "eF": 0.25, "aB": J.mul(v_s_159, 0.45), "eB": 0.25, "lF": J.mul(v_s_159, 0.42), "lB": ((-J.num(v_s_159)) * 0.42)}])

func _f34(this_, a: Array, env):
	var v_t_162 = null; var v_s_163 = null
	v_t_162 = J.arg(a, 0)
	v_s_163 = sin(J.num(J.mul(v_t_162, 15.0)))
	var _t128 = env["H_"]
	return J.cl(_t128, null, [{"lean": 0.32, "dy": ((-absf(J.num(cos(J.num(J.mul(v_t_162, 15.0)))))) * 4.0), "head": ((-0.15) + J.mul(v_s_163, 0.06)), "hk": "t", "aF": (2.3 + J.mul(v_s_163, 0.7)), "eF": (-0.3), "aB": (2.0 - J.mul(v_s_163, 0.7)), "eB": (-0.2), "lF": J.mul(v_s_163, 0.85), "lB": ((-J.num(v_s_163)) * 0.85), "jx": (sin(J.num(J.mul(v_t_162, 41.0))) * 0.6)}])

func _f35(this_, a: Array, env):
	var v_p_166 = null; var v_t_167 = null; var v_up_168 = null
	v_p_166 = J.arg(a, 0)
	v_t_167 = J.arg(a, 1)
	v_up_168 = (J.mc(env["ease"], "out", [J.div(v_p_166, 0.35)]) if J.cmp(v_p_166, 0.35, "<") else (1.0 - J.mul(J.mc(env["ease"], "in", [J.div(J.sub(v_p_166, 0.35), 0.65)]), 0.75)))
	var _t129 = env["H_"]
	return J.cl(_t129, null, [{"lean": J.mul((-0.32), v_up_168), "dy": (((-9.0) * sin(J.num((J.min_([1.0, J.div(v_p_166, 0.7)]) * PI)))) - ((-3.0) if J.cmp(v_p_166, 0.08, "<") else 0.0)), "sx": (1.0 - J.mul(0.06, v_up_168)), "sy": (1.0 + J.mul(0.08, v_up_168)), "head": J.mul((-0.25), v_up_168), "hk": "s", "aF": (J.mul(2.7, v_up_168) + 0.2), "eF": J.mul((-0.4), v_up_168), "aB": J.mul(2.5, v_up_168), "eB": J.mul((-0.3), v_up_168), "lF": J.mul(0.45, v_up_168), "lB": J.mul((-0.35), v_up_168), "jx": ((sin(J.num(J.mul(v_t_167, 50.0))) * 0.8) * J.sub(1.0, v_p_166))}])

func _f36(this_, a: Array, env):
	var v_p_171 = null; var v_t_172 = null; var v_j_173 = null
	v_p_171 = J.arg(a, 0)
	v_t_172 = J.arg(a, 1)
	v_j_173 = (sin(J.num(J.mul(v_t_172, 45.0))) * 0.04)
	var _t130 = env["H_"]
	return J.cl(_t130, null, [{"lean": 0.35, "dy": 7.0, "sx": 1.04, "sy": 0.9, "head": J.add(0.35, v_j_173), "hk": "t", "aF": J.add(2.5, v_j_173), "eF": 1.7, "aB": J.sub(2.3, v_j_173), "eB": 1.8, "lF": 0.55, "lB": (-0.5), "jx": (sin(J.num(J.mul(v_t_172, 47.0))) * 0.7)}])

func _f37(this_, a: Array, env):
	var v_p_176 = null; var v_t_177 = null; var v_j_178 = null
	v_p_176 = J.arg(a, 0)
	v_t_177 = J.arg(a, 1)
	v_j_178 = sin(J.num(J.mul(v_t_177, 38.0)))
	var _t131 = env["H_"]
	return J.cl(_t131, null, [{"lean": (-0.05), "dy": 1.5, "head": (0.08 + J.mul(v_j_178, 0.03)), "hk": "f", "aF": (0.85 + J.mul(v_j_178, 0.05)), "eF": 1.9, "aB": (0.75 - J.mul(v_j_178, 0.05)), "eB": 2.0, "lF": (0.12 + J.mul(v_j_178, 0.04)), "lB": ((-0.12) - J.mul(v_j_178, 0.04)), "jx": J.mul(v_j_178, 0.9), "sx": 0.98, "sy": 1.0}])

func _f38(this_, a: Array, env):
	var v_p_181 = null; var v_t_182 = null; var v_b_183 = null
	v_p_181 = J.arg(a, 0)
	v_t_182 = J.arg(a, 1)
	v_b_183 = sin(J.num(J.mul(v_t_182, 1.6)))
	var _t132 = env["H_"]
	return J.cl(_t132, null, [{"lean": 0.06, "dy": J.mul(v_b_183, 0.6), "head": (0.28 + J.mul(v_b_183, 0.02)), "hk": "b", "aF": 0.75, "eF": (1.45 + J.mul(v_b_183, 0.03)), "aB": 0.65, "eB": 1.55, "tool": "_P", "tr": (-1.4), "lF": 0.0, "lB": 0.0}])

func _f39(this_, a: Array, env):
	var v_t_186 = null; var v_w_187 = null
	v_t_186 = J.arg(a, 0)
	v_w_187 = sin(J.num(J.mul(v_t_186, 1.3)))
	var _t133 = env["H_"]
	return J.cl(_t133, null, [{"lean": (-0.02), "head": (J.mul(v_w_187, 0.18) - 0.05), "hk": "q", "aF": (1.45 + J.mul(v_w_187, 0.15)), "eF": 0.05, "aB": (-0.15), "eB": 0.4, "tool": "_P", "tr": (-3.0), "dy": (sin(J.num(J.mul(v_t_186, 2.0))) * 0.5)}])

func _f40(this_, a: Array, env):
	var v_t_190 = null; var v_w_191 = null
	v_t_190 = J.arg(a, 0)
	v_w_191 = sin(J.num(J.mul(v_t_190, 4.5)))
	var _t134 = env["H_"]
	return J.cl(_t134, null, [{"lean": 0.18, "dy": 1.0, "head": 0.15, "hk": "b", "aF": (0.55 + J.mul(v_w_191, 0.35)), "eF": 0.35, "aB": (0.8 + J.mul(v_w_191, 0.3)), "eB": 0.5, "tool": "_P", "tr": ((-3.5) + J.mul(v_w_191, 0.15)), "ik": 1.0, "lF": J.mul(v_w_191, 0.08), "lB": ((-J.num(v_w_191)) * 0.08)}])

func _f41(this_, a: Array, env):
	var v_p_194 = null; var v_t_195 = null; var v_k_196 = null
	v_p_194 = J.arg(a, 0)
	v_t_195 = J.arg(a, 1)
	v_k_196 = J.mc(env["ease"], "in", [J.min_([1.0, v_p_194])])
	var _t135 = env["H_"]
	return J.cl(_t135, null, [{"lean": J.mul((-1.35), v_k_196), "dy": J.mul(4.0, v_k_196), "head": J.mul((-0.3), v_k_196), "hk": "x", "aF": J.mul(2.6, v_k_196), "eF": 0.4, "aB": J.mul(2.4, v_k_196), "eB": 0.5, "lF": J.mul(0.6, v_k_196), "lB": J.mul(0.3, v_k_196)}])

func _f42(this_, a: Array, env):
	var v_t_199 = null; var v_w_200 = null
	v_t_199 = J.arg(a, 0)
	v_w_200 = sin(J.num(J.mul(v_t_199, 1.4)))
	var _t136 = env["H_"]
	return J.cl(_t136, null, [{"head": ((-0.08) + J.mul(v_w_200, 0.03)), "hk": "c", "aF": 0.55, "eF": (2.15 + J.mul(v_w_200, 0.05)), "aB": (-0.1), "eB": 0.3, "dy": (sin(J.num(J.mul(v_t_199, 2.0))) * 0.5)}])

func _f43(this_, a: Array, env):
	var v_t_203 = null; var v_b_204 = null
	v_t_203 = J.arg(a, 0)
	v_b_204 = sin(J.num(J.mul(v_t_203, 2.0)))
	var _t137 = env["H_"]
	return J.cl(_t137, null, [{"dy": J.mul(v_b_204, 0.5), "sy": (1.0 + J.mul(v_b_204, 0.006)), "head": (sin(J.num(J.mul(v_t_203, 0.9))) * 0.04), "aF": (0.12 + J.mul(v_b_204, 0.03)), "eF": 0.2, "aB": (-0.1), "eB": 0.2}])

func _f44(this_, a: Array, env):
	var v_t_207 = null; var v_b_208 = null
	v_t_207 = J.arg(a, 0)
	v_b_208 = sin(J.num(J.mul(v_t_207, 2.0)))
	var _t138 = env["H_"]
	return J.cl(_t138, null, [{"dy": J.mul(v_b_208, 0.5), "head": (-0.05), "hk": "q", "aF": 0.55, "eF": 1.25, "aB": 0.45, "eB": 1.35, "tool": "_P", "tr": (-1.57)}])

func _f45(this_, a: Array, env):
	var v_p_211 = null; var v_t_212 = null; var v_k_213 = null
	v_p_211 = J.arg(a, 0)
	v_t_212 = J.arg(a, 1)
	v_k_213 = sin(J.num((J.min_([1.0, v_p_211]) * PI)))
	var _t139 = env["H_"]
	return J.cl(_t139, null, [{"head": J.mul((-0.15), v_k_213), "hk": "q", "aF": J.mul(0.6, v_k_213), "eF": J.mul((-1.2), v_k_213), "aB": J.mul(0.5, v_k_213), "eB": J.mul((-1.1), v_k_213), "dy": J.mul((-1.5), v_k_213)}])

func _f47(this_, a: Array, env):
	var v_x_229 = null; var v_y_230 = null; var v_a_231 = null
	v_x_229 = J.arg(a, 0)
	v_y_230 = J.arg(a, 1)
	v_a_231 = J.arg(a, 2)
	return [(J.mul(v_x_229, cos(J.num(v_a_231))) - J.mul(v_y_230, sin(J.num(v_a_231)))), (J.mul(v_x_229, sin(J.num(v_a_231))) + J.mul(v_y_230, cos(J.num(v_a_231))))]

func _f53(this_, a: Array, env):
	var v_id_329 = null
	v_id_329 = J.arg(a, 0)
	var _t141 = J.seq(v_id_329, "afu")
	if not J.t(_t141):
		var _t140 = J.gp(env["RIGS"], v_id_329)
		_t141 = (not (not J.t((J.gp(J.gp(env["RIGS"], v_id_329), "tool") if J.t(_t140) else _t140))))
	return _t141

func _f1(this_, a: Array, env):
	var v_addRigs_7 = null; var v_has_9 = null; var v_draw_25 = null; var v_tipWorld_26 = null; var v_armed_27 = null
	var _s2 = {"__p": env, "RIGS": null, "TOOLS": null, "M": null, "mirror": null, "ok": null, "img": null, "toolDef": null, "BASE": null, "ease": null, "mix": null, "keys": null, "CHOP_STRIKE": null, "CHOP_UP": null, "CLAW_UP": null, "CLAW_HIT": null, "ANIMS": null, "H_": null, "ik2": null, "rot": null, "drawTorso": null}
	_s2["mirror"] = Callable(self, "_f2").bind(_s2)
	v_addRigs_7 = Callable(self, "_f4").bind(_s2)
	_s2["toolDef"] = Callable(self, "_f8").bind(_s2)
	_s2["mix"] = Callable(self, "_f14").bind(_s2)
	_s2["keys"] = Callable(self, "_f15").bind(_s2)
	_s2["ik2"] = Callable(self, "_f46").bind(_s2)
	_s2["drawTorso"] = Callable(self, "_f48").bind(_s2)
	v_draw_25 = Callable(self, "_f49").bind(_s2)
	v_tipWorld_26 = Callable(self, "_f52").bind(_s2)
	_s2["RIGS"] = {"afu": {"h": 600.0, "root": [120.0, 240.0], "tailY": 380.0, "torso": ["rg_afu_torso", 261.0, 384.0], "heads": {"n": "rg_afu_head", "s": "rg_afu_head_s", "h": "rg_afu_head_h", "p": "rg_afu_head_p"}, "head": [440.0, 362.0, 0.512, 0.925], "neck": [135.0, 28.0], "shF": [212.0, 78.0], "shB": [45.0, 78.0], "uF": ["rg_afu_uarmF", 155.0, 291.0, [95.0, 34.0], [88.0, 262.0]], "fF": ["rg_afu_farmF", 138.0, 287.0, [62.0, 30.0], [62.0, 222.0]], "uB": ["rg_afu_uarmB", 166.0, 292.0, [58.0, 34.0], [85.0, 262.0]], "fB": ["rg_afu_farmB", 144.0, 328.0, [66.0, 32.0], [56.0, 292.0]]}}
	_s2["TOOLS"] = {"axe": ["tool_axe", 205.0, 374.0, [(205.0 - 42.0), 300.0], false], "mallet": ["tool_mallet", 241.0, 371.0, [(241.0 - 85.0), 300.0], false], "sickle": ["tool_sickle", 0.0, 0.0, [0.0, 0.0], false]}
	_s2["M"] = J.new_("Set", [])
	_s2["ok"] = Callable(self, "_f5").bind(_s2)
	v_has_9 = Callable(self, "_f6").bind(_s2)
	_s2["img"] = Callable(self, "_f7").bind(_s2)
	_s2["BASE"] = {"lean": 0.0, "dy": 0.0, "sx": 1.0, "sy": 1.0, "head": 0.0, "hk": "n", "aF": 0.15, "eF": 0.1, "aB": (-0.12), "eB": 0.15, "tool": null, "tr": (-1.57), "ik": 0.0, "tail": 0.0, "lF": 0.0, "lB": 0.0, "jx": 0.0}
	_s2["ease"] = {"lin": Callable(self, "_f9").bind(_s2), "in": Callable(self, "_f10").bind(_s2), "out": Callable(self, "_f11").bind(_s2), "io": Callable(self, "_f12").bind(_s2), "back": Callable(self, "_f13").bind(_s2)}
	_s2["CHOP_STRIKE"] = {"lean": 0.22, "dy": 3.0, "sx": 1.04, "sy": 0.95, "head": 0.18, "hk": "s", "aF": 1.0, "eF": (-0.1), "aB": 0.55, "eB": 0.5, "tool": "axe", "tr": (-3.0), "ik": 1.0}
	_s2["CHOP_UP"] = {"lean": (-0.16), "dy": (-5.0), "sx": 0.96, "sy": 1.05, "head": (-0.2), "hk": "s", "aF": 3.35, "eF": 0.35, "aB": 2.6, "eB": 0.4, "tool": "axe", "tr": (-1.5), "ik": 1.0}
	_s2["CLAW_UP"] = {"lean": (-0.18), "dy": (-3.0), "sx": 0.96, "sy": 1.04, "head": (-0.15), "hk": "a", "aF": (-1.1), "eF": (-0.9), "aB": (-0.7), "eB": (-0.5)}
	_s2["CLAW_HIT"] = {"lean": 0.3, "dy": 2.0, "sx": 1.05, "sy": 0.96, "head": 0.12, "hk": "a", "aF": 1.65, "eF": (-0.15), "aB": 1.2, "eB": 0.1}
	_s2["ANIMS"] = {"idle": Callable(self, "_f16").bind(_s2), "move": Callable(self, "_f17").bind(_s2), "chop": Callable(self, "_f18").bind(_s2), "hammer": Callable(self, "_f19").bind(_s2), "knead": Callable(self, "_f20").bind(_s2), "reap": Callable(self, "_f21").bind(_s2), "windup": Callable(self, "_f22").bind(_s2), "strike": Callable(self, "_f23").bind(_s2), "recover": Callable(self, "_f24").bind(_s2), "windupC": Callable(self, "_f25").bind(_s2), "strikeC": Callable(self, "_f26").bind(_s2), "recoverC": Callable(self, "_f27").bind(_s2), "cast": Callable(self, "_f28").bind(_s2), "proud": Callable(self, "_f29").bind(_s2), "die": Callable(self, "_f30").bind(_s2), "hurt": Callable(self, "_f31").bind(_s2)}
	_s2["H_"] = Callable(self, "_f32").bind(_s2)
	J.S_Object_("assign", [_s2["ANIMS"], {"walk": Callable(self, "_f33").bind(_s2), "run": Callable(self, "_f34").bind(_s2), "startle": Callable(self, "_f35").bind(_s2), "cower": Callable(self, "_f36").bind(_s2), "tremble": Callable(self, "_f37").bind(_s2), "phone": Callable(self, "_f38").bind(_s2), "look": Callable(self, "_f39").bind(_s2), "mop": Callable(self, "_f40").bind(_s2), "faint": Callable(self, "_f41").bind(_s2), "sip": Callable(self, "_f42").bind(_s2), "stand": Callable(self, "_f43").bind(_s2), "hold": Callable(self, "_f44").bind(_s2), "shrug": Callable(self, "_f45").bind(_s2)}])
	_s2["rot"] = Callable(self, "_f47").bind(_s2)
	v_armed_27 = Callable(self, "_f53").bind(_s2)
	return {"armed": v_armed_27, "has": v_has_9, "draw": v_draw_25, "ANIMS": _s2["ANIMS"], "tipWorld": v_tipWorld_26, "RIGS": _s2["RIGS"], "addRigs": v_addRigs_7}
