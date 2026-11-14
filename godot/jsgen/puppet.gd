# 自動轉譯自 puppet.js（tools/jsgd.js）——唔好直接改，改原 JS 再轉
extends RefCounted

func run(env):
	var this_ = null; var a = []
	J.G["PUPPET_ON"] = false
	J.G["Puppet"] = J.cl(Callable(self, "_f1").bind(env), null, [])

func _f3(this_, a: Array, env):
	var v_p_34 = null
	v_p_34 = J.arg(a, 0)
	return [J.sub(env["tw"], J.gp(v_p_34, 0.0)), J.gp(v_p_34, 1.0)]

func _f2(this_, a: Array, env):
	var v_R_31 = null; var v_mx_33 = null; var v_k_35 = null; var v_P_36 = null; var v_T_37 = null
	var _s3 = {"__p": env, "tw": null}
	v_R_31 = J.arg(a, 0)
	if J.t(J.mc(_s3["__p"]["M"], "has", [v_R_31])):
		return null
	J.mc(_s3["__p"]["M"], "add", [v_R_31])
	_s3["tw"] = J.gp(J.gp(v_R_31, "torso"), 1.0)
	v_mx_33 = Callable(self, "_f3").bind(_s3)
	var _t1 = J.cl(v_mx_33, null, [J.gp(v_R_31, "root")])
	J.sp(v_R_31, "root", _t1)
	var _t2 = J.cl(v_mx_33, null, [J.gp(v_R_31, "neck")])
	J.sp(v_R_31, "neck", _t2)
	var _t3 = J.cl(v_mx_33, null, [J.gp(v_R_31, "shF")])
	J.sp(v_R_31, "shF", _t3)
	var _t4 = J.cl(v_mx_33, null, [J.gp(v_R_31, "shB")])
	J.sp(v_R_31, "shB", _t4)
	var _t5 = [J.gp(J.gp(v_R_31, "head"), 0.0), J.gp(J.gp(v_R_31, "head"), 1.0), J.sub(1.0, J.gp(J.gp(v_R_31, "head"), 2.0)), J.gp(J.gp(v_R_31, "head"), 3.0)]
	J.sp(v_R_31, "head", _t5)
	if J.t(J.gp(v_R_31, "hipF")):
		var _t6 = J.cl(v_mx_33, null, [J.gp(v_R_31, "hipF")])
		J.sp(v_R_31, "hipF", _t6)
		var _t7 = J.cl(v_mx_33, null, [J.gp(v_R_31, "hipB")])
		J.sp(v_R_31, "hipB", _t7)
	for _t8 in J.iter(["uF", "fF", "uB", "fB", "lF", "lB"]):
		v_k_35 = _t8
		v_P_36 = J.gp(v_R_31, v_k_35)
		if (not J.t(v_P_36)):
			continue
		var _t9 = [J.sub(J.gp(v_P_36, 1.0), J.gp(J.gp(v_P_36, 3.0), 0.0)), J.gp(J.gp(v_P_36, 3.0), 1.0)]
		J.sp(v_P_36, 3.0, _t9)
		var _t10 = [J.sub(J.gp(v_P_36, 1.0), J.gp(J.gp(v_P_36, 4.0), 0.0)), J.gp(J.gp(v_P_36, 4.0), 1.0)]
		J.sp(v_P_36, 4.0, _t10)
	if J.t(J.gp(v_R_31, "tool")):
		v_T_37 = J.gp(v_R_31, "tool")
		var _t11 = _s3["__p"]["TOOLS"]
		var _t12 = J.add("_", J.gp(v_R_31, "id"))
		var _t13 = [J.gp(v_T_37, 0.0), J.gp(v_T_37, 1.0), J.gp(v_T_37, 2.0), [J.sub(J.gp(v_T_37, 1.0), J.gp(J.gp(v_T_37, 3.0), 0.0)), J.gp(J.gp(v_T_37, 3.0), 1.0)], false]
		J.sp(_t11, _t12, _t13)

func _f4(this_, a: Array, env):
	var v_obj_40 = null; var v_id_41 = null; var v_R_42 = null
	v_obj_40 = J.arg(a, 0)
	for _t14 in J.keys(v_obj_40):
		v_id_41 = _t14
		v_R_42 = J.gp(v_obj_40, v_id_41)
		J.sp(v_R_42, "id", v_id_41)
		var _t15 = env["RIGS"]
		J.sp(_t15, v_id_41, v_R_42)

func _f8(this_, a: Array, env):
	var v_name_54 = null; var v_d_55 = null; var v_im_56 = null; var v_sc_57 = null
	v_name_54 = J.arg(a, 0)
	v_d_55 = J.gp(env["TOOLS"], v_name_54)
	var _t17 = (not J.t(v_d_55))
	if not J.t(_t17):
		var _t16 = env["ok"]
		_t17 = (not J.t(J.cl(_t16, null, [J.gp(v_d_55, 0.0)])))
	if _t17:
		return null
	var _t19 = (not J.t(J.gp(v_d_55, 1.0)))
	if J.t(_t19):
		var _t18 = J.gp(v_d_55, 0.0)
		_t19 = J.mc(_t18, "startsWith", ["tool_s"])
	if J.t(_t19):
		v_im_56 = J.gp(J.G.get("SPR"), J.gp(v_d_55, 0.0))
		v_sc_57 = J.div(1.0, 0.55)
		var _t20 = J.mul(J.gp(v_im_56, "naturalWidth"), v_sc_57)
		J.sp(v_d_55, 1.0, _t20)
		var _t21 = J.mul(J.gp(v_im_56, "naturalHeight"), v_sc_57)
		J.sp(v_d_55, 2.0, _t21)
		var _t22 = [J.sub(J.gp(v_d_55, 1.0), J.mul(J.gp(v_d_55, 1.0), 0.13)), J.mul(J.gp(v_d_55, 2.0), 0.85)]
		J.sp(v_d_55, 3.0, _t22)
	return v_d_55

func _f14(this_, a: Array, env):
	var v_a_66 = null; var v_b_67 = null; var v_k_68 = null; var v_o_69 = null; var v_key_70 = null; var v_va_71 = null; var v_vb_72 = null
	v_a_66 = J.arg(a, 0)
	v_b_67 = J.arg(a, 1)
	v_k_68 = J.arg(a, 2)
	v_o_69 = {}
	for _t23 in J.keys(v_a_66):
		v_key_70 = _t23
		v_va_71 = J.gp(v_a_66, v_key_70)
		v_vb_72 = J.gp(v_b_67, v_key_70)
		var _t24 = J.seq(J.typeof_(v_va_71), "number")
		var _t25 = (J.add(v_va_71, J.mul(J.sub(v_vb_72, v_va_71), v_k_68)) if (J.seq(J.typeof_(v_vb_72), "number") if _t24 else _t24) else (v_va_71 if J.cmp(v_k_68, 0.5, "<") else v_vb_72))
		J.sp(v_o_69, v_key_70, _t25)
	return v_o_69

func _f15(this_, a: Array, env):
	var v_list_75 = null; var v_p_76 = null; var v_i_77 = null; var v_t0_78 = null; var v_a_79 = null; var v_t1_80 = null; var v_b_81 = null; var v_e_82 = null
	v_list_75 = J.arg(a, 0)
	v_p_76 = J.arg(a, 1)
	if J.cmp(v_p_76, J.gp(J.gp(v_list_75, 0.0), 0.0), "<="):
		return J.S_Object_("assign", [{}, env["BASE"], J.gp(J.gp(v_list_75, 0.0), 1.0)])
	v_i_77 = 1.0
	while true:
		if not J.cmp(v_i_77, J.len(v_list_75), "<"): break
		if J.cmp(v_p_76, J.gp(J.gp(v_list_75, v_i_77), 0.0), "<="):
			var _t26 = J.gp(v_list_75, J.sub(v_i_77, 1.0))
			var _t27 = J.gp(_t26, 0.0)
			v_t0_78 = _t27
			var _t28 = J.gp(_t26, 1.0)
			v_a_79 = _t28
			var _t29 = J.gp(v_list_75, v_i_77)
			var _t30 = J.gp(_t29, 0.0)
			v_t1_80 = _t30
			var _t31 = J.gp(_t29, 1.0)
			v_b_81 = _t31
			var _t32 = J.gp(_t29, 2.0)
			v_e_82 = _t32
			var _t33 = env["mix"]
			var _t36 = J.S_Object_("assign", [{}, env["BASE"], v_a_79])
			var _t37 = J.S_Object_("assign", [{}, env["BASE"], v_b_81])
			var _t34 = env["ease"]
			var _t35 = (v_e_82 if J.t(v_e_82) else "io")
			return J.cl(_t33, null, [_t36, _t37, J.mc(_t34, _t35, [J.div(J.sub(v_p_76, v_t0_78), J.sub(v_t1_80, v_t0_78))])])
		v_i_77 = J.num(v_i_77) + 1.0
	return J.S_Object_("assign", [{}, env["BASE"], J.gp(J.gp(v_list_75, (J.len(v_list_75) - 1.0)), 1.0)])

func _f46(this_, a: Array, env):
	var v_sx_217 = null; var v_sy_218 = null; var v_tx_219 = null; var v_ty_220 = null; var v_L1_221 = null; var v_L2_222 = null; var v_dx_223 = null; var v_dy_224 = null; var v_d_225 = null; var v_base_226 = null; var v_c_227 = null; var v_a1_228 = null; var v_c2_229 = null
	v_sx_217 = J.arg(a, 0)
	v_sy_218 = J.arg(a, 1)
	v_tx_219 = J.arg(a, 2)
	v_ty_220 = J.arg(a, 3)
	v_L1_221 = J.arg(a, 4)
	v_L2_222 = J.arg(a, 5)
	v_dx_223 = J.sub(v_tx_219, v_sx_217)
	v_dy_224 = J.sub(v_ty_220, v_sy_218)
	v_d_225 = J.hypot_([v_dx_223, v_dy_224])
	var _t38 = J.min_([v_d_225, J.sub(J.add(v_L1_221, v_L2_222), 1.0)])
	v_d_225 = _t38
	v_base_226 = atan2(J.num((-J.num(v_dx_223))), J.num(v_dy_224))
	v_c_227 = J.max_([(-1.0), J.min_([1.0, J.div(((J.mul(v_L1_221, v_L1_221) + J.mul(v_d_225, v_d_225)) - J.mul(v_L2_222, v_L2_222)), J.mul(J.mul(2.0, v_L1_221), v_d_225))])])
	v_a1_228 = J.sub(v_base_226, acos(J.num(v_c_227)))
	v_c2_229 = J.max_([(-1.0), J.min_([1.0, J.div(((J.mul(v_L1_221, v_L1_221) + J.mul(v_L2_222, v_L2_222)) - J.mul(v_d_225, v_d_225)), J.mul(J.mul(2.0, v_L1_221), v_L2_222))])])
	return [v_a1_228, (PI - acos(J.num(v_c2_229)))]

func _f48(this_, a: Array, env):
	var v_ctx_235 = null; var v_R_236 = null; var v_pz_237 = null; var v_k_238 = null; var v_w_239 = null; var v_h_240 = null; var v_im_241 = null; var v_rx_242 = null; var v_ry_243 = null; var v_cut_244 = null; var v_pw_245 = null; var v_u0_246 = null; var v_step_247 = null; var v_y_248 = null; var v_f_249 = null; var v_off_250 = null; var v_hh_251 = null
	v_ctx_235 = J.arg(a, 0)
	v_R_236 = J.arg(a, 1)
	v_pz_237 = J.arg(a, 2)
	var _t39 = J.gp(v_R_236, "torso")
	var _t40 = J.gp(_t39, 0.0)
	v_k_238 = _t40
	var _t41 = J.gp(_t39, 1.0)
	v_w_239 = _t41
	var _t42 = J.gp(_t39, 2.0)
	v_h_240 = _t42
	v_im_241 = J.gp(J.G.get("SPR"), v_k_238)
	var _t43 = J.gp(v_R_236, "root")
	var _t44 = J.gp(_t43, 0.0)
	v_rx_242 = _t44
	var _t45 = J.gp(_t43, 1.0)
	v_ry_243 = _t45
	v_cut_244 = (v_h_240 if J.t(J.gp(v_R_236, "lF")) else J.sub(v_ry_243, 20.0))
	v_pw_245 = J.div(J.gp(v_im_241, "naturalWidth"), v_w_239)
	J.mc(v_ctx_235, "save", [])
	if J.t(J.gp(v_pz_237, "cloth")):
		var _t46 = J.gp(v_pz_237, "cloth")
		J.sp(v_ctx_235, "filter", _t46)
	J.mc(v_ctx_235, "scale", [(-1.0), 1.0])
	v_u0_246 = J.sub(v_rx_242, v_w_239)
	J.mc(v_ctx_235, "drawImage", [v_im_241, 0.0, 0.0, J.gp(v_im_241, "naturalWidth"), J.mul(v_cut_244, v_pw_245), v_u0_246, (-J.num(v_ry_243)), v_w_239, v_cut_244])
	v_step_247 = 8.0
	v_y_248 = v_cut_244
	while true:
		if not J.cmp(v_y_248, J.sub(v_h_240, 0.5), "<"): break
		v_f_249 = J.div(J.sub(v_y_248, v_cut_244), J.sub(v_h_240, v_cut_244))
		var _t48 = J.mul(J.mul((sin(J.num((J.mul(J.gp(v_pz_237, "tail"), 3.2) - J.mul(v_f_249, 3.0)))) * 16.0), v_f_249), v_f_249)
		var _t47 = J.gp(v_pz_237, "lean")
		v_off_250 = (_t48 + J.mul(J.mul(J.mul((_t47 if J.t(_t47) else 0.0), (-40.0)), v_f_249), v_f_249))
		v_hh_251 = J.min_([v_step_247, J.sub(v_h_240, v_y_248)])
		J.mc(v_ctx_235, "drawImage", [v_im_241, 0.0, J.mul(v_y_248, v_pw_245), J.gp(v_im_241, "naturalWidth"), J.mul(v_hh_251, v_pw_245), J.sub(v_u0_246, v_off_250), J.sub(v_y_248, v_ry_243), v_w_239, J.add(v_hh_251, 0.8)])
		var _t49 = J.add(v_y_248, v_step_247)
		v_y_248 = _t49
	J.mc(v_ctx_235, "restore", [])

func _f50(this_, a: Array, env):
	var v_hp_294 = null; var v_a_295 = null; var v_L_296 = null
	v_hp_294 = J.arg(a, 0)
	v_a_295 = J.arg(a, 1)
	v_L_296 = J.arg(a, 2)
	J.mc(env["__p"]["ctx"], "save", [])
	J.mc(env["__p"]["ctx"], "translate", [J.sub(J.gp(v_hp_294, 0.0), env["rx0"]), J.sub(J.gp(v_hp_294, 1.0), env["ry0"])])
	J.mc(env["__p"]["ctx"], "rotate", [v_a_295])
	J.mc(env["__p"]["ctx"], "scale", [env["LS"], env["LS"]])
	var _t56 = env["__p"]["__p"]["img"]
	J.cl(_t56, null, [J.gp(v_L_296, 0.0), (-J.num(J.gp(J.gp(v_L_296, 3.0), 0.0))), (-J.num(J.gp(J.gp(v_L_296, 3.0), 1.0))), J.gp(v_L_296, 1.0), J.gp(v_L_296, 2.0), env["__p"]["ctx"]])
	J.mc(env["__p"]["ctx"], "restore", [])

func _f51(this_, a: Array, env):
	var v_sh_301 = null; var v_a_302 = null; var v_e_303 = null; var v_U_304 = null; var v_Fm_305 = null; var v_isFront_306 = null
	v_sh_301 = J.arg(a, 0)
	v_a_302 = J.arg(a, 1)
	v_e_303 = J.arg(a, 2)
	v_U_304 = J.arg(a, 3)
	v_Fm_305 = J.arg(a, 4)
	v_isFront_306 = J.arg(a, 5)
	J.mc(env["ctx"], "save", [])
	J.mc(env["ctx"], "translate", [J.gp(v_sh_301, 0.0), J.gp(v_sh_301, 1.0)])
	J.mc(env["ctx"], "rotate", [v_a_302])
	J.mc(env["ctx"], "scale", [env["AS"], env["AS"]])
	var _t82 = env["__p"]["img"]
	J.cl(_t82, null, [J.gp(v_U_304, 0.0), (-J.num(J.gp(J.gp(v_U_304, 3.0), 0.0))), (-J.num(J.gp(J.gp(v_U_304, 3.0), 1.0))), J.gp(v_U_304, 1.0), J.gp(v_U_304, 2.0), env["ctx"]])
	J.mc(env["ctx"], "translate", [J.sub(J.gp(J.gp(v_U_304, 4.0), 0.0), J.gp(J.gp(v_U_304, 3.0), 0.0)), J.sub(J.gp(J.gp(v_U_304, 4.0), 1.0), J.gp(J.gp(v_U_304, 3.0), 1.0))])
	J.mc(env["ctx"], "rotate", [v_e_303])
	if J.t((env["T"] if J.t(v_isFront_306) else v_isFront_306)):
		J.mc(env["ctx"], "save", [])
		J.mc(env["ctx"], "translate", [J.sub(J.gp(J.gp(v_Fm_305, 4.0), 0.0), J.gp(J.gp(v_Fm_305, 3.0), 0.0)), J.sub(J.gp(J.gp(v_Fm_305, 4.0), 1.0), J.gp(J.gp(v_Fm_305, 3.0), 1.0))])
		J.mc(env["ctx"], "rotate", [J.gp(env["pz"], "tr")])
		if J.t(J.gp(env["T"], 4.0)):
			J.mc(env["ctx"], "scale", [(-1.0), 1.0])
		if J.t(J.gp(env["R"], "toolS")):
			J.mc(env["ctx"], "scale", [J.gp(env["R"], "toolS"), J.gp(env["R"], "toolS")])
		var _t83 = env["__p"]["img"]
		J.cl(_t83, null, [J.gp(env["T"], 0.0), (-J.num(J.gp(J.gp(env["T"], 3.0), 0.0))), (-J.num(J.gp(J.gp(env["T"], 3.0), 1.0))), J.gp(env["T"], 1.0), J.gp(env["T"], 2.0), env["ctx"]])
		J.mc(env["ctx"], "restore", [])
	var _t84 = env["__p"]["img"]
	J.cl(_t84, null, [J.gp(v_Fm_305, 0.0), (-J.num(J.gp(J.gp(v_Fm_305, 3.0), 0.0))), (-J.num(J.gp(J.gp(v_Fm_305, 3.0), 1.0))), J.gp(v_Fm_305, 1.0), J.gp(v_Fm_305, 2.0), env["ctx"]])
	J.mc(env["ctx"], "restore", [])

func _f49(this_, a: Array, env):
	var v_id_255 = null; var v_x_256 = null; var v_y_257 = null; var v_worldH_258 = null; var v_flip_260 = null; var v_k_262 = null; var v_rx_264 = null; var v_ry_265 = null; var v_sF_267 = null; var v_uF_268 = null; var v_fF_269 = null; var v_uB_270 = null; var v_fB_271 = null; var v_L1F_272 = null; var v_L2F_273 = null; var v_e1_274 = null; var v_elb_275 = null; var v_e2_276 = null; var v_grip_277 = null; var v_aB_278 = null; var v_eB_279 = null; var v_sB_280 = null; var v_arm_281 = null; var v_hk_282 = null; var v_hi_283 = null; var v_hw0_284 = null; var v_hh0_285 = null; var v_fx_286 = null; var v_fy_287 = null; var v_hw_288 = null; var v_hh_289 = null; var v_leg_293 = null; var v_ta_297 = null; var v_d_298 = null; var v_L1B_299 = null; var v_L2B_300 = null
	var _s63 = {"__p": env, "ctx": null, "pz": null, "R": null, "AS": null, "T": null}
	_s63["ctx"] = J.arg(a, 0)
	v_id_255 = J.arg(a, 1)
	v_x_256 = J.arg(a, 2)
	v_y_257 = J.arg(a, 3)
	v_worldH_258 = J.arg(a, 4)
	_s63["pz"] = J.arg(a, 5)
	v_flip_260 = J.arg(a, 6)
	_s63["R"] = J.gp(_s63["__p"]["RIGS"], v_id_255)
	v_k_262 = J.div(v_worldH_258, J.gp(_s63["R"], "h"))
	J.mc(_s63["ctx"], "save", [])
	var _t50 = J.gp(_s63["pz"], "dy")
	J.mc(_s63["ctx"], "translate", [v_x_256, J.add(v_y_257, J.div(J.mul((_t50 if J.t(_t50) else 0.0), v_worldH_258), 58.0))])
	if J.t(v_flip_260):
		J.mc(_s63["ctx"], "scale", [(-1.0), 1.0])
	J.mc(_s63["ctx"], "scale", [J.mul(v_k_262, J.gp(_s63["pz"], "sx")), J.mul(v_k_262, J.gp(_s63["pz"], "sy"))])
	var _t51 = J.gp(_s63["pz"], "jx")
	J.mc(_s63["ctx"], "translate", [(J.div((_t51 if J.t(_t51) else 0.0), v_k_262) * J.div(v_worldH_258, 58.0)), (-J.sub(J.gp(_s63["R"], "tailY"), J.gp(J.gp(_s63["R"], "root"), 1.0)))])
	if J.t(J.gp(_s63["R"], "lF")):
		var _s64 = {"__p": _s63, "LS": null, "rx0": null, "ry0": null}
		var _t52 = J.gp(_s64["__p"]["R"], "legS")
		_s64["LS"] = (_t52 if J.t(_t52) else 1.0)
		var _t53 = J.gp(_s64["__p"]["R"], "root")
		var _t54 = J.gp(_t53, 0.0)
		_s64["rx0"] = _t54
		var _t55 = J.gp(_t53, 1.0)
		_s64["ry0"] = _t55
		v_leg_293 = Callable(self, "_f50").bind(_s64)
		var _t58 = J.gp(_s64["__p"]["R"], "hipB")
		var _t57 = J.gp(_s64["__p"]["pz"], "lB")
		J.cl(v_leg_293, null, [_t58, (_t57 if J.t(_t57) else 0.0), J.gp(_s64["__p"]["R"], "lB")])
		var _t60 = J.gp(_s64["__p"]["R"], "hipF")
		var _t59 = J.gp(_s64["__p"]["pz"], "lF")
		J.cl(v_leg_293, null, [_t60, (_t59 if J.t(_t59) else 0.0), J.gp(_s64["__p"]["R"], "lF")])
	J.mc(_s63["ctx"], "rotate", [(-J.num(J.gp(_s63["pz"], "lean")))])
	var _t61 = J.gp(_s63["R"], "armS")
	_s63["AS"] = (_t61 if J.t(_t61) else 0.62)
	var _t62 = J.gp(_s63["R"], "root")
	var _t63 = J.gp(_t62, 0.0)
	v_rx_264 = _t63
	var _t64 = J.gp(_t62, 1.0)
	v_ry_265 = _t64
	if J.seq(J.gp(_s63["pz"], "tool"), "_P"):
		var _t65 = J.S_Object_("assign", [{}, _s63["pz"], {"tool": (J.add("_", v_id_255) if J.t(J.gp(_s63["R"], "tool")) else null)}])
		_s63["pz"] = _t65
	var _t67 = J.gp(_s63["pz"], "wpn")
	if J.t(_t67):
		var _t66 = J.seq(J.gp(_s63["pz"], "tool"), "_W")
		_t67 = (_t66 if _t66 else J.seq(J.gp(_s63["pz"], "tool"), "axe"))
	var _t69 = _t67
	if J.t(_t69):
		var _t68 = _s63["__p"]["toolDef"]
		_t69 = J.cl(_t68, null, [J.gp(_s63["pz"], "wpn")])
	if J.t(_t69):
		var _t70 = J.S_Object_("assign", [{}, _s63["pz"], {"tool": J.gp(_s63["pz"], "wpn")}])
		_s63["pz"] = _t70
	else:
		var _t72 = J.seq(J.gp(_s63["pz"], "tool"), "_W")
		if not J.t(_t72):
			var _t71 = J.seq(J.gp(_s63["pz"], "tool"), "axe")
			_t72 = ((not J.seq(v_id_255, "afu")) if _t71 else _t71)
		if _t72:
			var _t73 = J.S_Object_("assign", [{}, _s63["pz"], {"tool": (J.add("_", v_id_255) if J.t(J.gp(_s63["R"], "tool")) else ("axe" if J.seq(v_id_255, "afu") else null))}])
			_s63["pz"] = _t73
	var _t74 = _s63["__p"]["toolDef"]
	_s63["T"] = J.cl(_t74, null, [J.gp(_s63["pz"], "tool")])
	v_sF_267 = [J.sub(J.gp(J.gp(_s63["R"], "shF"), 0.0), v_rx_264), J.sub(J.gp(J.gp(_s63["R"], "shF"), 1.0), v_ry_265)]
	v_uF_268 = J.gp(_s63["R"], "uF")
	v_fF_269 = J.gp(_s63["R"], "fF")
	v_uB_270 = J.gp(_s63["R"], "uB")
	v_fB_271 = J.gp(_s63["R"], "fB")
	v_L1F_272 = J.mul(J.sub(J.gp(J.gp(v_uF_268, 4.0), 1.0), J.gp(J.gp(v_uF_268, 3.0), 1.0)), _s63["AS"])
	v_L2F_273 = J.mul(J.sub(J.gp(J.gp(v_fF_269, 4.0), 1.0), J.gp(J.gp(v_fF_269, 3.0), 1.0)), _s63["AS"])
	var _t75 = _s63["__p"]["rot"]
	v_e1_274 = J.cl(_t75, null, [0.0, v_L1F_272, J.gp(_s63["pz"], "aF")])
	v_elb_275 = [J.add(J.gp(v_sF_267, 0.0), J.gp(v_e1_274, 0.0)), J.add(J.gp(v_sF_267, 1.0), J.gp(v_e1_274, 1.0))]
	var _t76 = _s63["__p"]["rot"]
	v_e2_276 = J.cl(_t76, null, [0.0, v_L2F_273, J.add(J.gp(_s63["pz"], "aF"), J.gp(_s63["pz"], "eF"))])
	v_grip_277 = [J.add(J.gp(v_elb_275, 0.0), J.gp(v_e2_276, 0.0)), J.add(J.gp(v_elb_275, 1.0), J.gp(v_e2_276, 1.0))]
	v_aB_278 = J.gp(_s63["pz"], "aB")
	v_eB_279 = J.gp(_s63["pz"], "eB")
	v_sB_280 = [J.sub(J.gp(J.gp(_s63["R"], "shB"), 0.0), v_rx_264), J.sub(J.gp(J.gp(_s63["R"], "shB"), 1.0), v_ry_265)]
	if J.t((J.gp(_s63["pz"], "ik") if J.t(_s63["T"]) else _s63["T"])):
		v_ta_297 = J.add(J.add(J.gp(_s63["pz"], "aF"), J.gp(_s63["pz"], "eF")), J.gp(_s63["pz"], "tr"))
		var _t77 = _s63["__p"]["rot"]
		v_d_298 = J.cl(_t77, null, [0.0, J.mul(70.0, _s63["AS"]), v_ta_297])
		v_L1B_299 = J.mul(J.sub(J.gp(J.gp(v_uB_270, 4.0), 1.0), J.gp(J.gp(v_uB_270, 3.0), 1.0)), _s63["AS"])
		v_L2B_300 = J.mul(J.sub(J.gp(J.gp(v_fB_271, 4.0), 1.0), J.gp(J.gp(v_fB_271, 3.0), 1.0)), _s63["AS"])
		var _t78 = _s63["__p"]["ik2"]
		var _t79 = J.cl(_t78, null, [J.gp(v_sB_280, 0.0), J.gp(v_sB_280, 1.0), J.add(J.gp(v_grip_277, 0.0), J.gp(v_d_298, 0.0)), J.add(J.gp(v_grip_277, 1.0), J.gp(v_d_298, 1.0)), v_L1B_299, v_L2B_300])
		var _t80 = J.gp(_t79, 0.0)
		v_aB_278 = _t80
		var _t81 = J.gp(_t79, 1.0)
		v_eB_279 = _t81
	v_arm_281 = Callable(self, "_f51").bind(_s63)
	J.cl(v_arm_281, null, [v_sB_280, v_aB_278, v_eB_279, v_uB_270, v_fB_271, false])
	var _t85 = _s63["__p"]["drawTorso"]
	J.cl(_t85, null, [_s63["ctx"], _s63["R"], _s63["pz"]])
	var _t87 = J.gp(J.gp(_s63["R"], "heads"), J.gp(_s63["pz"], "hk"))
	if J.t(_t87):
		var _t86 = _s63["__p"]["ok"]
		_t87 = J.cl(_t86, null, [J.gp(J.gp(_s63["R"], "heads"), J.gp(_s63["pz"], "hk"))])
	v_hk_282 = (J.gp(J.gp(_s63["R"], "heads"), J.gp(_s63["pz"], "hk")) if J.t(_t87) else J.gp(J.gp(_s63["R"], "heads"), "n"))
	v_hi_283 = J.gp(J.G.get("SPR"), v_hk_282)
	var _t88 = J.gp(_s63["R"], "head")
	var _t89 = J.gp(_t88, 0.0)
	v_hw0_284 = _t89
	var _t90 = J.gp(_t88, 1.0)
	v_hh0_285 = _t90
	var _t91 = J.gp(_t88, 2.0)
	v_fx_286 = _t91
	var _t92 = J.gp(_t88, 3.0)
	v_fy_287 = _t92
	v_hw_288 = v_hw0_284
	v_hh_289 = J.div(J.mul(v_hw0_284, J.gp(v_hi_283, "naturalHeight")), J.gp(v_hi_283, "naturalWidth"))
	J.mc(_s63["ctx"], "save", [])
	J.mc(_s63["ctx"], "translate", [J.sub(J.gp(J.gp(_s63["R"], "neck"), 0.0), v_rx_264), (J.sub(J.gp(J.gp(_s63["R"], "neck"), 1.0), v_ry_265) + 10.0)])
	J.mc(_s63["ctx"], "rotate", [(-J.num(J.gp(_s63["pz"], "head")))])
	J.mc(_s63["ctx"], "scale", [(-1.0), 1.0])
	J.mc(_s63["ctx"], "drawImage", [v_hi_283, ((-J.num(v_hw_288)) * J.sub(1.0, v_fx_286)), J.mul((-J.num(v_hh_289)), v_fy_287), v_hw_288, v_hh_289])
	J.mc(_s63["ctx"], "restore", [])
	J.cl(v_arm_281, null, [v_sF_267, J.gp(_s63["pz"], "aF"), J.gp(_s63["pz"], "eF"), v_uF_268, v_fF_269, true])
	J.mc(_s63["ctx"], "restore", [])
	return v_grip_277

func _f52(this_, a: Array, env):
	var v_id_309 = null; var v_x_310 = null; var v_y_311 = null; var v_worldH_312 = null; var v_pz_313 = null; var v_flip_314 = null; var v_along_315 = null; var v_R_316 = null; var v_k_317 = null; var v_rx_318 = null; var v_ry_319 = null; var v_T_320 = null; var v_AS_321 = null; var v_uF_322 = null; var v_fF_323 = null; var v_L1F_324 = null; var v_L2F_325 = null; var v_p_326 = null; var v_r1_327 = null; var v_w_328 = null; var v_d_329 = null
	v_id_309 = J.arg(a, 0)
	v_x_310 = J.arg(a, 1)
	v_y_311 = J.arg(a, 2)
	v_worldH_312 = J.arg(a, 3)
	v_pz_313 = J.arg(a, 4)
	v_flip_314 = J.arg(a, 5)
	v_along_315 = J.arg(a, 6)
	v_R_316 = J.gp(env["RIGS"], v_id_309)
	v_k_317 = J.div(v_worldH_312, J.gp(v_R_316, "h"))
	var _t93 = J.gp(v_R_316, "root")
	var _t94 = J.gp(_t93, 0.0)
	v_rx_318 = _t94
	var _t95 = J.gp(_t93, 1.0)
	v_ry_319 = _t95
	var _t96 = env["toolDef"]
	v_T_320 = J.cl(_t96, null, [J.gp(v_pz_313, "tool")])
	var _t97 = J.gp(v_R_316, "armS")
	v_AS_321 = (_t97 if J.t(_t97) else 0.62)
	v_uF_322 = J.gp(v_R_316, "uF")
	v_fF_323 = J.gp(v_R_316, "fF")
	v_L1F_324 = J.mul(J.sub(J.gp(J.gp(v_uF_322, 4.0), 1.0), J.gp(J.gp(v_uF_322, 3.0), 1.0)), v_AS_321)
	v_L2F_325 = J.mul(J.sub(J.gp(J.gp(v_fF_323, 4.0), 1.0), J.gp(J.gp(v_fF_323, 3.0), 1.0)), v_AS_321)
	v_p_326 = [J.sub(J.gp(J.gp(v_R_316, "shF"), 0.0), v_rx_318), J.sub(J.gp(J.gp(v_R_316, "shF"), 1.0), v_ry_319)]
	var _t98 = env["rot"]
	v_r1_327 = J.cl(_t98, null, [0.0, v_L1F_324, J.gp(v_pz_313, "aF")])
	var _t99 = [J.add(J.gp(v_p_326, 0.0), J.gp(v_r1_327, 0.0)), J.add(J.gp(v_p_326, 1.0), J.gp(v_r1_327, 1.0))]
	v_p_326 = _t99
	var _t100 = env["rot"]
	var _t101 = J.cl(_t100, null, [0.0, v_L2F_325, J.add(J.gp(v_pz_313, "aF"), J.gp(v_pz_313, "eF"))])
	v_r1_327 = _t101
	var _t102 = [J.add(J.gp(v_p_326, 0.0), J.gp(v_r1_327, 0.0)), J.add(J.gp(v_p_326, 1.0), J.gp(v_r1_327, 1.0))]
	v_p_326 = _t102
	if J.t(v_T_320):
		var _t103 = env["rot"]
		v_d_329 = J.cl(_t103, null, [0.0, J.mul((-J.num((v_along_315 if J.t(v_along_315) else J.mul(J.gp(v_T_320, 2.0), 0.7)))), v_AS_321), J.add(J.add(J.gp(v_pz_313, "aF"), J.gp(v_pz_313, "eF")), J.gp(v_pz_313, "tr"))])
		var _t104 = [J.add(J.gp(v_p_326, 0.0), J.gp(v_d_329, 0.0)), J.add(J.gp(v_p_326, 1.0), J.gp(v_d_329, 1.0))]
		v_p_326 = _t104
	var _t105 = env["rot"]
	v_w_328 = J.cl(_t105, null, [J.gp(v_p_326, 0.0), J.gp(v_p_326, 1.0), (-J.num(J.gp(v_pz_313, "lean")))])
	var _t106 = [J.gp(v_w_328, 0.0), J.sub(J.gp(v_w_328, 1.0), J.sub(J.gp(v_R_316, "tailY"), J.gp(J.gp(v_R_316, "root"), 1.0)))]
	v_w_328 = _t106
	var _t107 = [J.mul(J.mul(J.gp(v_w_328, 0.0), v_k_317), J.gp(v_pz_313, "sx")), J.mul(J.mul(J.gp(v_w_328, 1.0), v_k_317), J.gp(v_pz_313, "sy"))]
	v_w_328 = _t107
	var _t109 = J.add(v_x_310, ((-J.num(J.gp(v_w_328, 0.0))) if J.t(v_flip_314) else J.gp(v_w_328, 0.0)))
	var _t108 = J.gp(v_pz_313, "dy")
	return [_t109, J.add(J.add(v_y_311, J.div(J.mul((_t108 if J.t(_t108) else 0.0), v_worldH_312), 58.0)), J.gp(v_w_328, 1.0))]

func _f54(this_, a: Array, env):
	var v_name_333 = null; var v_key_334 = null; var v_w_335 = null; var v_h_336 = null; var v_gy_337 = null
	v_name_333 = J.arg(a, 0)
	v_key_334 = J.arg(a, 1)
	v_w_335 = J.arg(a, 2)
	v_h_336 = J.arg(a, 3)
	v_gy_337 = J.arg(a, 4)
	var _t110 = env["TOOLS"]
	var _t111 = [v_key_334, v_w_335, v_h_336, [J.div(v_w_335, 2.0), J.mul(v_h_336, (v_gy_337 if J.t(v_gy_337) else 0.88))], false]
	J.sp(_t110, v_name_333, _t111)

func _f5(this_, a: Array, env):
	var v_k_43 = null
	v_k_43 = J.arg(a, 0)
	var _t113 = J.seq(J.typeof_(J.G.get("sprOk")), "function")
	if J.t(_t113):
		var _t112 = J.G.get("sprOk")
		_t113 = J.cl(_t112, null, [v_k_43])
	return _t113

func _f6(this_, a: Array, env):
	var v_id_44 = null; var v_r_45 = null
	v_id_44 = J.arg(a, 0)
	if (not J.t(J.G.get("PUPPET_ON"))):
		return false
	v_r_45 = J.gp(env["RIGS"], v_id_44)
	if J.t(v_r_45):
		var _t114 = env["mirror"]
		J.cl(_t114, null, [v_r_45])
	var _t116 = v_r_45
	if J.t(_t116):
		var _t115 = env["ok"]
		_t116 = J.cl(_t115, null, [J.gp(J.gp(v_r_45, "torso"), 0.0)])
	var _t118 = _t116
	if J.t(_t118):
		var _t117 = env["ok"]
		_t118 = J.cl(_t117, null, [J.gp(J.gp(v_r_45, "heads"), "n")])
	var _t120 = _t118
	if J.t(_t120):
		var _t119 = env["ok"]
		_t120 = J.cl(_t119, null, [J.gp(J.gp(v_r_45, "uF"), 0.0)])
	var _t122 = _t120
	if J.t(_t122):
		var _t121 = env["ok"]
		_t122 = J.cl(_t121, null, [J.gp(J.gp(v_r_45, "fF"), 0.0)])
	var _t124 = _t122
	if J.t(_t124):
		var _t123 = env["ok"]
		_t124 = J.cl(_t123, null, [J.gp(J.gp(v_r_45, "uB"), 0.0)])
	var _t126 = _t124
	if J.t(_t126):
		var _t125 = env["ok"]
		_t126 = J.cl(_t125, null, [J.gp(J.gp(v_r_45, "fB"), 0.0)])
	return (not (not J.t(_t126)))

func _f7(this_, a: Array, env):
	var v_k_46 = null; var v_x_47 = null; var v_y_48 = null; var v_w_49 = null; var v_h_50 = null; var v_ctx_51 = null
	v_k_46 = J.arg(a, 0)
	v_x_47 = J.arg(a, 1)
	v_y_48 = J.arg(a, 2)
	v_w_49 = J.arg(a, 3)
	v_h_50 = J.arg(a, 4)
	v_ctx_51 = J.arg(a, 5)
	J.mc(v_ctx_51, "save", [])
	J.mc(v_ctx_51, "scale", [(-1.0), 1.0])
	J.mc(v_ctx_51, "drawImage", [J.gp(J.G.get("SPR"), v_k_46), J.sub((-J.num(v_x_47)), v_w_49), v_y_48, v_w_49, v_h_50])
	J.mc(v_ctx_51, "restore", [])

func _f9(this_, a: Array, env):
	var v_t_58 = null
	v_t_58 = J.arg(a, 0)
	return v_t_58

func _f10(this_, a: Array, env):
	var v_t_59 = null
	v_t_59 = J.arg(a, 0)
	return J.mul(v_t_59, v_t_59)

func _f11(this_, a: Array, env):
	var v_t_60 = null
	v_t_60 = J.arg(a, 0)
	return (1.0 - (J.sub(1.0, v_t_60) * J.sub(1.0, v_t_60)))

func _f12(this_, a: Array, env):
	var v_t_61 = null
	v_t_61 = J.arg(a, 0)
	return (J.mul(J.mul(2.0, v_t_61), v_t_61) if J.cmp(v_t_61, 0.5, "<") else (1.0 - ((2.0 * J.sub(1.0, v_t_61)) * J.sub(1.0, v_t_61))))

func _f13(this_, a: Array, env):
	var v_t_62 = null; var v_c_63 = null
	v_t_62 = J.arg(a, 0)
	v_c_63 = 1.9
	return ((1.0 + J.mul(J.add(v_c_63, 1.0), pow(J.num(J.sub(v_t_62, 1.0)), J.num(3.0)))) + J.mul(v_c_63, pow(J.num(J.sub(v_t_62, 1.0)), J.num(2.0))))

func _f16(this_, a: Array, env):
	var v_t_85 = null; var v_b_86 = null
	v_t_85 = J.arg(a, 0)
	v_b_86 = sin(J.num(J.mul(v_t_85, 2.2)))
	return J.S_Object_("assign", [{}, env["BASE"], {"dy": J.mul(v_b_86, 2.5), "sy": (1.0 + J.mul(v_b_86, 0.012)), "sx": (1.0 - J.mul(v_b_86, 0.008)), "head": (sin(J.num(J.mul(v_t_85, 1.1))) * 0.05), "aF": (0.35 + (sin(J.num(J.mul(v_t_85, 1.7))) * 0.06)), "eF": (0.55 + (sin(J.num((J.mul(v_t_85, 1.7) + 0.6))) * 0.08)), "aB": ((-0.3) + (sin(J.num((J.mul(v_t_85, 1.7) + 1.0))) * 0.05)), "eB": 0.5, "tail": v_t_85, "tool": null}])

func _f17(this_, a: Array, env):
	var v_t_89 = null; var v_s_90 = null
	v_t_89 = J.arg(a, 0)
	v_s_90 = sin(J.num(J.mul(v_t_89, 7.0)))
	return J.S_Object_("assign", [{}, env["BASE"], {"lean": 0.2, "dy": (absf(J.num(cos(J.num(J.mul(v_t_89, 7.0))))) * (-3.0)), "head": (0.05 + J.mul(v_s_90, 0.04)), "aF": ((-0.35) + J.mul(v_s_90, 0.55)), "eF": 0.35, "aB": (0.25 - J.mul(v_s_90, 0.55)), "eB": 0.35, "tail": J.mul(v_t_89, 2.6)}])

func _f18(this_, a: Array, env):
	var v_p_93 = null; var v_t_94 = null
	v_p_93 = J.arg(a, 0)
	v_t_94 = J.arg(a, 1)
	var _t127 = env["keys"]
	return J.S_Object_("assign", [J.cl(_t127, null, [[[0.0, env["CHOP_STRIKE"]], [0.16, env["CHOP_STRIKE"]], [0.5, J.S_Object_("assign", [{}, env["CHOP_UP"], {"aF": 2.6, "aB": 2.2, "lean": (-0.1), "hk": "n"}]), "io"], [0.8, env["CHOP_UP"], "out"], [1.0, env["CHOP_STRIKE"], "in"]], v_p_93]), {"tail": v_t_94}])

func _f19(this_, a: Array, env):
	var v_p_97 = null; var v_t_98 = null; var v_q_99 = null; var v_up_100 = null; var v_dn_101 = null
	v_p_97 = J.arg(a, 0)
	v_t_98 = J.arg(a, 1)
	v_q_99 = J.mod(J.mul(v_p_97, 2.0), 1.0)
	v_up_100 = {"lean": (-0.02), "dy": (-3.0), "head": (-0.12), "hk": "s", "aF": 2.7, "eF": 0.5, "aB": 0.6, "eB": 0.9, "tool": "mallet", "tr": (-1.7)}
	v_dn_101 = {"lean": 0.25, "dy": 3.0, "sx": 1.03, "sy": 0.96, "head": 0.25, "hk": "s", "aF": 0.75, "eF": 0.35, "aB": 0.7, "eB": 0.9, "tool": "mallet", "tr": (-3.2)}
	var _t128 = env["keys"]
	return J.S_Object_("assign", [J.cl(_t128, null, [[[0.0, v_dn_101], [0.12, v_dn_101], [0.7, v_up_100, "io"], [1.0, v_dn_101, "in"]], v_q_99]), {"tail": v_t_98}])

func _f20(this_, a: Array, env):
	var v_p_104 = null; var v_t_105 = null; var v_a_106 = null; var v_b_107 = null
	v_p_104 = J.arg(a, 0)
	v_t_105 = J.arg(a, 1)
	v_a_106 = sin(J.num((J.mul(v_p_104, PI) * 4.0)))
	v_b_107 = sin(J.num(((J.mul(v_p_104, PI) * 4.0) + PI)))
	return J.S_Object_("assign", [{}, env["BASE"], {"lean": (0.42 + J.mul(v_a_106, 0.04)), "dy": (2.0 + (absf(J.num(v_a_106)) * 2.0)), "head": 0.3, "hk": ("p" if J.cmp(v_p_104, 0.85, ">") else "s"), "aF": (0.9 + J.mul(v_a_106, 0.35)), "eF": (0.5 - J.mul(v_a_106, 0.25)), "aB": (0.95 + J.mul(v_b_107, 0.35)), "eB": (0.45 - J.mul(v_b_107, 0.25)), "tail": v_t_105, "sx": (1.0 + (J.max_([0.0, v_a_106]) * 0.03)), "sy": (1.0 - (J.max_([0.0, v_a_106]) * 0.03))}])

func _f21(this_, a: Array, env):
	var v_p_110 = null; var v_t_111 = null; var v_w_112 = null
	v_p_110 = J.arg(a, 0)
	v_t_111 = J.arg(a, 1)
	v_w_112 = sin(J.num((J.mul(v_p_110, PI) * 6.0)))
	return J.S_Object_("assign", [{}, env["BASE"], {"lean": 0.55, "dy": 4.0, "head": (0.28 + J.mul(v_w_112, 0.05)), "hk": ("p" if J.cmp(v_p_110, 0.85, ">") else "s"), "aF": (0.4 + J.mul(v_w_112, 0.75)), "eF": 0.25, "aB": (0.85 - J.mul(v_w_112, 0.2)), "eB": 0.6, "tool": "sickle", "tr": ((-1.3) - J.mul(v_w_112, 0.25)), "tail": v_t_111}])

func _f22(this_, a: Array, env):
	var v_p_115 = null; var v_t_116 = null; var v_a_117 = null
	v_p_115 = J.arg(a, 0)
	v_t_116 = J.arg(a, 1)
	v_a_117 = J.S_Object_("assign", [{}, env["BASE"], {"tool": "_W", "tr": (-1.4), "ik": 1.0}])
	var _t129 = env["mix"]
	return J.S_Object_("assign", [J.cl(_t129, null, [v_a_117, env["CHOP_UP"], J.mc(env["ease"], "out", [J.min_([1.0, v_p_115])])]), {"tail": v_t_116}])

func _f23(this_, a: Array, env):
	var v_p_120 = null; var v_t_121 = null
	v_p_120 = J.arg(a, 0)
	v_t_121 = J.arg(a, 1)
	var _t130 = env["mix"]
	return J.S_Object_("assign", [J.cl(_t130, null, [env["CHOP_UP"], env["CHOP_STRIKE"], J.mc(env["ease"], "out", [J.min_([1.0, J.mul(v_p_120, 1.6)])])]), {"tail": v_t_121}])

func _f24(this_, a: Array, env):
	var v_p_124 = null; var v_t_125 = null
	v_p_124 = J.arg(a, 0)
	v_t_125 = J.arg(a, 1)
	var _t131 = env["mix"]
	return J.S_Object_("assign", [J.cl(_t131, null, [env["CHOP_STRIKE"], J.S_Object_("assign", [{}, env["BASE"], {"tool": "_W", "tr": (-1.4)}]), J.mc(env["ease"], "io", [J.min_([1.0, v_p_124])])]), {"tail": v_t_125}])

func _f25(this_, a: Array, env):
	var v_p_128 = null; var v_t_129 = null
	v_p_128 = J.arg(a, 0)
	v_t_129 = J.arg(a, 1)
	var _t132 = env["mix"]
	return J.S_Object_("assign", [J.cl(_t132, null, [env["BASE"], env["CLAW_UP"], J.mc(env["ease"], "out", [J.min_([1.0, v_p_128])])]), {"tail": v_t_129}])

func _f26(this_, a: Array, env):
	var v_p_132 = null; var v_t_133 = null
	v_p_132 = J.arg(a, 0)
	v_t_133 = J.arg(a, 1)
	var _t133 = env["mix"]
	return J.S_Object_("assign", [J.cl(_t133, null, [env["CLAW_UP"], env["CLAW_HIT"], J.mc(env["ease"], "out", [J.min_([1.0, J.mul(v_p_132, 1.6)])])]), {"tail": v_t_133}])

func _f27(this_, a: Array, env):
	var v_p_136 = null; var v_t_137 = null
	v_p_136 = J.arg(a, 0)
	v_t_137 = J.arg(a, 1)
	var _t134 = env["mix"]
	return J.S_Object_("assign", [J.cl(_t134, null, [env["CLAW_HIT"], env["BASE"], J.mc(env["ease"], "io", [J.min_([1.0, v_p_136])])]), {"tail": v_t_137}])

func _f28(this_, a: Array, env):
	var v_p_140 = null; var v_t_141 = null; var v_w_142 = null
	v_p_140 = J.arg(a, 0)
	v_t_141 = J.arg(a, 1)
	v_w_142 = (sin(J.num(J.mul(v_t_141, 18.0))) * 0.06)
	return J.S_Object_("assign", [{}, env["BASE"], {"lean": (-0.12), "dy": ((-4.0) - J.mul(v_p_140, 4.0)), "hk": "a", "head": (-0.2), "aF": J.add(2.0, v_w_142), "eF": (-0.4), "aB": J.sub(1.8, v_w_142), "eB": (-0.3), "tail": v_t_141, "sx": (1.0 + J.mul(v_p_140, 0.04)), "sy": (1.0 + J.mul(v_p_140, 0.04))}])

func _f29(this_, a: Array, env):
	var v_p_145 = null; var v_t_146 = null
	v_p_145 = J.arg(a, 0)
	v_t_146 = J.arg(a, 1)
	return J.S_Object_("assign", [J.mc(env["ANIMS"], "idle", [v_t_146]), {"hk": "p", "head": (-0.15), "aF": (-0.25), "eF": 2.2, "aB": (-0.3), "eB": 2.1}])

func _f30(this_, a: Array, env):
	var v_p_149 = null; var v_t_150 = null
	v_p_149 = J.arg(a, 0)
	v_t_150 = J.arg(a, 1)
	return J.S_Object_("assign", [J.mc(env["ANIMS"], "hurt", [0.0, v_t_150]), {"hk": "h", "lean": J.mul((-0.6), v_p_149), "dy": J.mul((-6.0), v_p_149)}])

func _f31(this_, a: Array, env):
	var v_p_153 = null; var v_t_154 = null; var v_k_155 = null
	v_p_153 = J.arg(a, 0)
	v_t_154 = J.arg(a, 1)
	v_k_155 = J.max_([0.0, J.sub(1.0, v_p_153)])
	return J.S_Object_("assign", [{}, env["BASE"], {"lean": J.mul((-0.35), v_k_155), "dy": J.mul((-4.0), v_k_155), "hk": "h", "head": J.mul((-0.3), v_k_155), "aF": (J.mul(1.2, v_k_155) + 0.1), "eF": J.mul(0.9, v_k_155), "aB": J.mul(1.0, v_k_155), "eB": J.mul(1.1, v_k_155), "tail": v_t_154, "sx": (1.0 - J.mul(0.06, v_k_155)), "sy": (1.0 + J.mul(0.06, v_k_155))}])

func _f32(this_, a: Array, env):
	var v_o_156 = null
	v_o_156 = J.arg(a, 0)
	return J.S_Object_("assign", [{}, env["BASE"], v_o_156])

func _f33(this_, a: Array, env):
	var v_t_159 = null; var v_s_160 = null
	v_t_159 = J.arg(a, 0)
	v_s_160 = sin(J.num(J.mul(v_t_159, 8.0)))
	var _t135 = env["H_"]
	return J.cl(_t135, null, [{"lean": 0.06, "dy": ((-absf(J.num(cos(J.num(J.mul(v_t_159, 8.0)))))) * 1.6), "head": (sin(J.num(J.mul(v_t_159, 8.0))) * 0.03), "aF": ((-J.num(v_s_160)) * 0.45), "eF": 0.25, "aB": J.mul(v_s_160, 0.45), "eB": 0.25, "lF": J.mul(v_s_160, 0.42), "lB": ((-J.num(v_s_160)) * 0.42)}])

func _f34(this_, a: Array, env):
	var v_t_163 = null; var v_s_164 = null
	v_t_163 = J.arg(a, 0)
	v_s_164 = sin(J.num(J.mul(v_t_163, 15.0)))
	var _t136 = env["H_"]
	return J.cl(_t136, null, [{"lean": 0.32, "dy": ((-absf(J.num(cos(J.num(J.mul(v_t_163, 15.0)))))) * 4.0), "head": ((-0.15) + J.mul(v_s_164, 0.06)), "hk": "t", "aF": (2.3 + J.mul(v_s_164, 0.7)), "eF": (-0.3), "aB": (2.0 - J.mul(v_s_164, 0.7)), "eB": (-0.2), "lF": J.mul(v_s_164, 0.85), "lB": ((-J.num(v_s_164)) * 0.85), "jx": (sin(J.num(J.mul(v_t_163, 41.0))) * 0.6)}])

func _f35(this_, a: Array, env):
	var v_p_167 = null; var v_t_168 = null; var v_up_169 = null
	v_p_167 = J.arg(a, 0)
	v_t_168 = J.arg(a, 1)
	v_up_169 = (J.mc(env["ease"], "out", [J.div(v_p_167, 0.35)]) if J.cmp(v_p_167, 0.35, "<") else (1.0 - J.mul(J.mc(env["ease"], "in", [J.div(J.sub(v_p_167, 0.35), 0.65)]), 0.75)))
	var _t137 = env["H_"]
	return J.cl(_t137, null, [{"lean": J.mul((-0.32), v_up_169), "dy": (((-9.0) * sin(J.num((J.min_([1.0, J.div(v_p_167, 0.7)]) * PI)))) - ((-3.0) if J.cmp(v_p_167, 0.08, "<") else 0.0)), "sx": (1.0 - J.mul(0.06, v_up_169)), "sy": (1.0 + J.mul(0.08, v_up_169)), "head": J.mul((-0.25), v_up_169), "hk": "s", "aF": (J.mul(2.7, v_up_169) + 0.2), "eF": J.mul((-0.4), v_up_169), "aB": J.mul(2.5, v_up_169), "eB": J.mul((-0.3), v_up_169), "lF": J.mul(0.45, v_up_169), "lB": J.mul((-0.35), v_up_169), "jx": ((sin(J.num(J.mul(v_t_168, 50.0))) * 0.8) * J.sub(1.0, v_p_167))}])

func _f36(this_, a: Array, env):
	var v_p_172 = null; var v_t_173 = null; var v_j_174 = null
	v_p_172 = J.arg(a, 0)
	v_t_173 = J.arg(a, 1)
	v_j_174 = (sin(J.num(J.mul(v_t_173, 45.0))) * 0.04)
	var _t138 = env["H_"]
	return J.cl(_t138, null, [{"lean": 0.35, "dy": 7.0, "sx": 1.04, "sy": 0.9, "head": J.add(0.35, v_j_174), "hk": "t", "aF": J.add(2.5, v_j_174), "eF": 1.7, "aB": J.sub(2.3, v_j_174), "eB": 1.8, "lF": 0.55, "lB": (-0.5), "jx": (sin(J.num(J.mul(v_t_173, 47.0))) * 0.7)}])

func _f37(this_, a: Array, env):
	var v_p_177 = null; var v_t_178 = null; var v_j_179 = null
	v_p_177 = J.arg(a, 0)
	v_t_178 = J.arg(a, 1)
	v_j_179 = sin(J.num(J.mul(v_t_178, 38.0)))
	var _t139 = env["H_"]
	return J.cl(_t139, null, [{"lean": (-0.05), "dy": 1.5, "head": (0.08 + J.mul(v_j_179, 0.03)), "hk": "f", "aF": (0.85 + J.mul(v_j_179, 0.05)), "eF": 1.9, "aB": (0.75 - J.mul(v_j_179, 0.05)), "eB": 2.0, "lF": (0.12 + J.mul(v_j_179, 0.04)), "lB": ((-0.12) - J.mul(v_j_179, 0.04)), "jx": J.mul(v_j_179, 0.9), "sx": 0.98, "sy": 1.0}])

func _f38(this_, a: Array, env):
	var v_p_182 = null; var v_t_183 = null; var v_b_184 = null
	v_p_182 = J.arg(a, 0)
	v_t_183 = J.arg(a, 1)
	v_b_184 = sin(J.num(J.mul(v_t_183, 1.6)))
	var _t140 = env["H_"]
	return J.cl(_t140, null, [{"lean": 0.06, "dy": J.mul(v_b_184, 0.6), "head": (0.28 + J.mul(v_b_184, 0.02)), "hk": "b", "aF": 0.75, "eF": (1.45 + J.mul(v_b_184, 0.03)), "aB": 0.65, "eB": 1.55, "tool": "_P", "tr": (-1.4), "lF": 0.0, "lB": 0.0}])

func _f39(this_, a: Array, env):
	var v_t_187 = null; var v_w_188 = null
	v_t_187 = J.arg(a, 0)
	v_w_188 = sin(J.num(J.mul(v_t_187, 1.3)))
	var _t141 = env["H_"]
	return J.cl(_t141, null, [{"lean": (-0.02), "head": (J.mul(v_w_188, 0.18) - 0.05), "hk": "q", "aF": (1.45 + J.mul(v_w_188, 0.15)), "eF": 0.05, "aB": (-0.15), "eB": 0.4, "tool": "_P", "tr": (-3.0), "dy": (sin(J.num(J.mul(v_t_187, 2.0))) * 0.5)}])

func _f40(this_, a: Array, env):
	var v_t_191 = null; var v_w_192 = null
	v_t_191 = J.arg(a, 0)
	v_w_192 = sin(J.num(J.mul(v_t_191, 4.5)))
	var _t142 = env["H_"]
	return J.cl(_t142, null, [{"lean": 0.18, "dy": 1.0, "head": 0.15, "hk": "b", "aF": (0.55 + J.mul(v_w_192, 0.35)), "eF": 0.35, "aB": (0.8 + J.mul(v_w_192, 0.3)), "eB": 0.5, "tool": "_P", "tr": ((-3.5) + J.mul(v_w_192, 0.15)), "ik": 1.0, "lF": J.mul(v_w_192, 0.08), "lB": ((-J.num(v_w_192)) * 0.08)}])

func _f41(this_, a: Array, env):
	var v_p_195 = null; var v_t_196 = null; var v_k_197 = null
	v_p_195 = J.arg(a, 0)
	v_t_196 = J.arg(a, 1)
	v_k_197 = J.mc(env["ease"], "in", [J.min_([1.0, v_p_195])])
	var _t143 = env["H_"]
	return J.cl(_t143, null, [{"lean": J.mul((-1.35), v_k_197), "dy": J.mul(4.0, v_k_197), "head": J.mul((-0.3), v_k_197), "hk": "x", "aF": J.mul(2.6, v_k_197), "eF": 0.4, "aB": J.mul(2.4, v_k_197), "eB": 0.5, "lF": J.mul(0.6, v_k_197), "lB": J.mul(0.3, v_k_197)}])

func _f42(this_, a: Array, env):
	var v_t_200 = null; var v_w_201 = null
	v_t_200 = J.arg(a, 0)
	v_w_201 = sin(J.num(J.mul(v_t_200, 1.4)))
	var _t144 = env["H_"]
	return J.cl(_t144, null, [{"head": ((-0.08) + J.mul(v_w_201, 0.03)), "hk": "c", "aF": 0.55, "eF": (2.15 + J.mul(v_w_201, 0.05)), "aB": (-0.1), "eB": 0.3, "dy": (sin(J.num(J.mul(v_t_200, 2.0))) * 0.5)}])

func _f43(this_, a: Array, env):
	var v_t_204 = null; var v_b_205 = null
	v_t_204 = J.arg(a, 0)
	v_b_205 = sin(J.num(J.mul(v_t_204, 2.0)))
	var _t145 = env["H_"]
	return J.cl(_t145, null, [{"dy": J.mul(v_b_205, 0.5), "sy": (1.0 + J.mul(v_b_205, 0.006)), "head": (sin(J.num(J.mul(v_t_204, 0.9))) * 0.04), "aF": (0.12 + J.mul(v_b_205, 0.03)), "eF": 0.2, "aB": (-0.1), "eB": 0.2}])

func _f44(this_, a: Array, env):
	var v_t_208 = null; var v_b_209 = null
	v_t_208 = J.arg(a, 0)
	v_b_209 = sin(J.num(J.mul(v_t_208, 2.0)))
	var _t146 = env["H_"]
	return J.cl(_t146, null, [{"dy": J.mul(v_b_209, 0.5), "head": (-0.05), "hk": "q", "aF": 0.55, "eF": 1.25, "aB": 0.45, "eB": 1.35, "tool": "_P", "tr": (-1.57)}])

func _f45(this_, a: Array, env):
	var v_p_212 = null; var v_t_213 = null; var v_k_214 = null
	v_p_212 = J.arg(a, 0)
	v_t_213 = J.arg(a, 1)
	v_k_214 = sin(J.num((J.min_([1.0, v_p_212]) * PI)))
	var _t147 = env["H_"]
	return J.cl(_t147, null, [{"head": J.mul((-0.15), v_k_214), "hk": "q", "aF": J.mul(0.6, v_k_214), "eF": J.mul((-1.2), v_k_214), "aB": J.mul(0.5, v_k_214), "eB": J.mul((-1.1), v_k_214), "dy": J.mul((-1.5), v_k_214)}])

func _f47(this_, a: Array, env):
	var v_x_230 = null; var v_y_231 = null; var v_a_232 = null
	v_x_230 = J.arg(a, 0)
	v_y_231 = J.arg(a, 1)
	v_a_232 = J.arg(a, 2)
	return [(J.mul(v_x_230, cos(J.num(v_a_232))) - J.mul(v_y_231, sin(J.num(v_a_232)))), (J.mul(v_x_230, sin(J.num(v_a_232))) + J.mul(v_y_231, cos(J.num(v_a_232))))]

func _f53(this_, a: Array, env):
	var v_id_330 = null
	v_id_330 = J.arg(a, 0)
	var _t149 = J.seq(v_id_330, "afu")
	if not J.t(_t149):
		var _t148 = J.gp(env["RIGS"], v_id_330)
		_t149 = (not (not J.t((J.gp(J.gp(env["RIGS"], v_id_330), "tool") if J.t(_t148) else _t148))))
	return _t149

func _f1(this_, a: Array, env):
	var v_addRigs_7 = null; var v_has_9 = null; var v_draw_25 = null; var v_tipWorld_26 = null; var v_armed_27 = null; var v_addTool_28 = null
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
	v_addTool_28 = Callable(self, "_f54").bind(_s2)
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
	return {"addTool": v_addTool_28, "TOOLS": _s2["TOOLS"], "armed": v_armed_27, "has": v_has_9, "draw": v_draw_25, "ANIMS": _s2["ANIMS"], "tipWorld": v_tipWorld_26, "RIGS": _s2["RIGS"], "addRigs": v_addRigs_7}
