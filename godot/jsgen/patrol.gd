# 自動轉譯自 patrol.js（tools/jsgd.js）——唔好直接改，改原 JS 再轉
extends RefCounted

func run(env):
	var this_ = null; var a = []
	J.G["Patrol"] = J.cl(Callable(self, "_f1").bind(env), null, [])
	J.G["Gear"] = J.cl(Callable(self, "_f373").bind(env), null, [])

func _f3(this_, a: Array, env):
	var v_k_201 = null; var v_sk_202 = null
	v_k_201 = J.arg(a, 0)
	if J.t(J.gp(env["FAC_OF"], v_k_201)):
		return J.gp(env["FAC_OF"], v_k_201)
	var _t1 = (not J.seq(J.typeof_(J.G.get("SKILLS")), "undefined"))
	var _t2 = (J.gp(J.G.get("SKILLS"), v_k_201) if _t1 else _t1)
	v_sk_202 = (_t2 if J.t(_t2) else {})
	var _t3 = J.gp(v_sk_202, "drain")
	if J.t((_t3 if J.t(_t3) else J.gp(v_sk_202, "steal"))):
		return "chan"
	var _t4 = J.seq(J.gp(v_sk_202, "kind"), "heal")
	var _t5 = (_t4 if _t4 else J.seq(J.gp(v_sk_202, "apply"), "down"))
	var _t6 = (_t5 if _t5 else J.seq(J.gp(v_sk_202, "apply"), "push"))
	if J.t((_t6 if _t6 else J.gp(v_sk_202, "sap"))):
		return "lan"
	return "yuan"

func _f5(this_, a: Array, env):
	var v_r_206 = null; var v_c_207 = null
	v_r_206 = J.arg(a, 0)
	v_c_207 = J.arg(a, 1)
	return J.gp(J.gp(env["TLAY"], v_r_206), (J.sub(J.sub(env["COLS"], 1.0), v_c_207) if J.t(env["MIR"]) else v_c_207))

func _f6(this_, a: Array, env):
	var v_z_210 = null; var v_r_211 = null; var v_c_212 = null
	v_z_210 = J.arg(a, 0)
	v_r_211 = floor(J.num(J.div(v_z_210, env["COLS"])))
	v_c_212 = J.mod(v_z_210, env["COLS"])
	return {"r": v_r_211, "c": v_c_212, "x": (J.mul(v_c_212, env["CW"]) + J.div(env["CW"], 2.0)), "y": (J.mul(v_r_211, env["CH"]) + J.div(env["CH"], 2.0))}

func _f7(this_, a: Array, env):
	var v_x_215 = null; var v_y_216 = null; var v_r_217 = null; var v_c_218 = null
	v_x_215 = J.arg(a, 0)
	v_y_216 = J.arg(a, 1)
	v_r_217 = J.max_([0.0, J.min_([J.sub(env["ROWS"], 1.0), floor(J.num(J.div(v_y_216, env["CH"])))])])
	v_c_218 = J.max_([0.0, J.min_([J.sub(env["COLS"], 1.0), floor(J.num(J.div(v_x_215, env["CW"])))])])
	return J.add(J.mul(v_r_217, env["COLS"]), v_c_218)

func _f8(this_, a: Array, env):
	var v_z_221 = null; var v_c_222 = null
	v_z_221 = J.arg(a, 0)
	var _t7 = env["zoneCell"]
	v_c_222 = J.cl(_t7, null, [v_z_221])
	var _t8 = env["terAt"]
	return J.cl(_t8, null, [J.gp(v_c_222, "r"), J.gp(v_c_222, "c")])

func _f9(this_, a: Array, env):
	var v_x_225 = null; var v_y_226 = null
	v_x_225 = J.arg(a, 0)
	v_y_226 = J.arg(a, 1)
	var _t9 = env["terOf"]
	var _t10 = env["zoneAt"]
	return J.cl(_t9, null, [J.cl(_t10, null, [v_x_225, v_y_226])])

func _f10(this_, a: Array, env):
	var v_ci_229 = null; var v_t_230 = null; var v_hi_231 = null; var v_lo_232 = null
	v_ci_229 = J.arg(a, 0)
	v_t_230 = J.arg(a, 1)
	v_hi_231 = J.gp(J.gp(J.gp(J.gp(J.G.get("CHAPTERS"), v_ci_229), "stages"), 2.0), "p")
	v_lo_232 = (J.gp(J.gp(J.gp(J.gp(J.G.get("CHAPTERS"), J.sub(v_ci_229, 1.0)), "stages"), 2.0), "p") if J.cmp(v_ci_229, 0.0, ">") else 0.0)
	return (J.gp(J.gp(J.gp(J.gp(J.G.get("CHAPTERS"), v_ci_229), "stages"), J.gp(env["TMAIN"], v_t_230)), "p") if (not J.leq(J.gp(env["TMAIN"], v_t_230), null)) else J.add(v_lo_232, J.mul(J.sub(v_hi_231, v_lo_232), J.gp(env["TTIER"], v_t_230))))

func _f11(this_, a: Array, env):
	var v_ci_235 = null; var v_z_236 = null; var v_t_237 = null; var v_c_238 = null; var v_j_239 = null
	v_ci_235 = J.arg(a, 0)
	v_z_236 = J.arg(a, 1)
	var _t11 = env["terOf"]
	v_t_237 = J.cl(_t11, null, [v_z_236])
	var _t12 = env["zoneCell"]
	v_c_238 = J.cl(_t12, null, [v_z_236])
	v_j_239 = J.div(J.mod((J.mul(J.gp(v_c_238, "r"), 7.0) + J.mul(J.gp(v_c_238, "c"), 3.0)), 5.0), 5.0)
	var _t13 = env["terP"]
	var _t14 = env["terP"]
	return J.max_([0.2, J.mul(J.cl(_t14, null, [v_ci_235, v_t_237]), (0.85 + J.mul(0.15, v_j_239)))])

func _f12(this_, a: Array, env):
	var v_ci_242 = null; var v_z_243 = null
	v_ci_242 = J.arg(a, 0)
	v_z_243 = J.arg(a, 1)
	var _t16 = J.gp(env["TNAME"], v_ci_242)
	var _t15 = env["terOf"]
	return J.gp(_t16, J.cl(_t15, null, [v_z_243]))

func _f13(this_, a: Array, env):
	var v_t_246 = null; var v_r_247 = null; var v_c_248 = null
	v_t_246 = J.arg(a, 0)
	var _t17 = J.gp(env["TLAIR"], v_t_246)
	var _t18 = J.gp(_t17, 0.0)
	v_r_247 = _t18
	var _t19 = J.gp(_t17, 1.0)
	v_c_248 = _t19
	var _t20 = env["mc"]
	return {"x": (J.mul(J.cl(_t20, null, [v_c_248]), env["CW"]) + J.div(env["CW"], 2.0)), "y": (J.mul(v_r_247, env["CH"]) + J.div(env["CH"], 2.0))}

func _f15(this_, a: Array, env):
	var v_k_253 = null
	v_k_253 = J.arg(a, 0)
	return J.seq(J.gp(env["__p"]["TMAIN"], v_k_253), env["si"])

func _f14(this_, a: Array, env):
	var v_t_252 = null
	var _s15 = {"__p": env, "si": null}
	_s15["si"] = J.arg(a, 0)
	var _t21 = J.S_Object_("keys", [_s15["__p"]["TMAIN"]])
	v_t_252 = J.num(J.mc(_t21, "find", [Callable(self, "_f15").bind(_s15)]))
	var _t22 = _s15["__p"]["lairPos"]
	return J.cl(_t22, null, [v_t_252])

func _f17(this_, a: Array, env):
	var v_a_256 = null; var v_b_257 = null; var v_ca_258 = null; var v_cb_259 = null; var v_i_260 = null; var v_ra_261 = null; var v_rb_262 = null; var v_xa_263 = null; var v_xb_264 = null; var v_za_265 = null; var v_zb_266 = null; var v_sec_267 = null
	var _t23 = J.gp(J.arg(a, 0), 0.0)
	v_a_256 = _t23
	var _t24 = J.gp(J.arg(a, 0), 1.0)
	v_b_257 = _t24
	var _t25 = J.gp(J.arg(a, 0), 2.0)
	v_ca_258 = _t25
	var _t26 = J.gp(J.arg(a, 0), 3.0)
	v_cb_259 = _t26
	v_i_260 = J.arg(a, 1)
	v_ra_261 = J.gp(v_ca_258, 0.0)
	v_rb_262 = J.gp(v_cb_259, 0.0)
	var _t27 = env["mc"]
	v_xa_263 = J.cl(_t27, null, [J.gp(v_ca_258, 1.0)])
	var _t28 = env["mc"]
	v_xb_264 = J.cl(_t28, null, [J.gp(v_cb_259, 1.0)])
	v_za_265 = J.add(J.mul(v_ra_261, env["COLS"]), v_xa_263)
	v_zb_266 = J.add(J.mul(v_rb_262, env["COLS"]), v_xb_264)
	v_sec_267 = (not (not J.t(J.gp(J.gp(env["TGATE"], v_i_260), 4.0))))
	if J.seq(v_ra_261, v_rb_262):
		return {"i": v_i_260, "a": v_a_256, "b": v_b_257, "za": v_za_265, "zb": v_zb_266, "sec": v_sec_267, "vert": true, "x": J.mul(J.max_([v_xa_263, v_xb_264]), env["CW"]), "y": (J.mul(v_ra_261, env["CH"]) + J.div(env["CH"], 2.0))}
	return {"i": v_i_260, "a": v_a_256, "b": v_b_257, "za": v_za_265, "zb": v_zb_266, "sec": v_sec_267, "vert": false, "x": (J.mul(v_xa_263, env["CW"]) + J.div(env["CW"], 2.0)), "y": J.mul(J.max_([v_ra_261, v_rb_262]), env["CH"])}

func _f16(this_, a: Array, env):
	return J.mc(env["TGATE"], "map", [Callable(self, "_f17").bind(env)])

func _f18(this_, a: Array, env):
	var v_t_270 = null
	v_t_270 = J.arg(a, 0)
	if (not J.t(env["R"])):
		return false
	if (not J.leq(J.gp(env["TMAIN"], v_t_270), null)):
		var _t30 = J.gp(J.G.get("S"), "cleared")
		var _t29 = env["sidOf"]
		return (not (not J.t(J.gp(_t30, J.cl(_t29, null, [J.gp(env["R"], "ci"), J.gp(env["TMAIN"], v_t_270)])))))
	var _t31 = env["regSt"]
	var _t32 = J.gp(J.cl(_t31, null, [J.gp(env["R"], "ci")]), "kings")
	return (not (not J.t(J.gp((_t32 if J.t(_t32) else {}), v_t_270))))

func _f19(this_, a: Array, env):
	var v_g_273 = null
	v_g_273 = J.arg(a, 0)
	var _t34 = J.gp(v_g_273, "sec")
	if not J.t(_t34):
		var _t33 = env["kingDone"]
		_t34 = J.cl(_t33, null, [J.gp(v_g_273, "a")])
	var _t36 = _t34
	if not J.t(_t36):
		var _t35 = env["kingDone"]
		_t36 = J.cl(_t35, null, [J.gp(v_g_273, "b")])
	return _t36

func _f20(this_, a: Array, env):
	var v_g_276 = null
	v_g_276 = J.arg(a, 0)
	var _t41 = (not J.t(J.gp(v_g_276, "sec")))
	if not J.t(_t41):
		var _t38 = env["R"]
		if J.t(_t38):
			var _t37 = env["regSt"]
			_t38 = J.gp(J.cl(_t37, null, [J.gp(env["R"], "ci")]), "sg")
		var _t40 = _t38
		if J.t(_t40):
			var _t39 = env["regSt"]
			_t40 = J.gp(J.gp(J.cl(_t39, null, [J.gp(env["R"], "ci")]), "sg"), J.gp(v_g_276, "i"))
		_t41 = (not (not J.t(_t40)))
	return _t41

func _f22(this_, a: Array, env):
	var v_t_279 = null; var v_r_280 = null; var v_c_281 = null; var v_ox_282 = null; var v_oy_283 = null
	var _t42 = J.gp(J.arg(a, 0), 0.0)
	v_t_279 = _t42
	var _t43 = J.gp(J.arg(a, 0), 1.0)
	v_r_280 = _t43
	var _t44 = J.gp(J.arg(a, 0), 2.0)
	v_c_281 = _t44
	var _t45 = J.gp(J.arg(a, 0), 3.0)
	v_ox_282 = _t45
	var _t46 = J.gp(J.arg(a, 0), 4.0)
	v_oy_283 = _t46
	var _t48 = J.mul(v_r_280, env["COLS"])
	var _t47 = env["mc"]
	return {"t": v_t_279, "z": J.add(_t48, J.cl(_t47, null, [v_c_281])), "ox": ((-J.num(v_ox_282)) if J.t(env["MIR"]) else v_ox_282), "oy": v_oy_283}

func _f21(this_, a: Array, env):
	var _t49 = J.mc(env["FACI0"], "map", [Callable(self, "_f22").bind(env)])
	env["FACI"] = _t49
	var _t50 = J.cl(env["gateList"], null, [])
	env["GATES"] = _t50

func _f25(this_, a: Array, env):
	var v_p_288 = null
	if (not J.t(J.gp(J.G.get("S"), "pt"))):
		var _t51 = J.G.get("S")
		var _t52 = {}
		J.sp(_t51, "pt", _t52)
	v_p_288 = J.gp(J.G.get("S"), "pt")
	var _t53 = J.gp(v_p_288, "reg")
	var _t54 = (_t53 if J.t(_t53) else {})
	J.sp(v_p_288, "reg", _t54)
	var _t55 = J.gp(v_p_288, "mats")
	var _t56 = (_t55 if J.t(_t55) else {"yuan": 0.0, "chan": 0.0, "lan": 0.0})
	J.sp(v_p_288, "mats", _t56)
	var _t57 = J.gp(v_p_288, "pity")
	var _t58 = (_t57 if J.t(_t57) else {})
	J.sp(v_p_288, "pity", _t58)
	var _t59 = J.gp(v_p_288, "lead")
	var _t60 = (_t59 if J.t(_t59) else null)
	J.sp(v_p_288, "lead", _t60)
	if J.leq(J.gp(v_p_288, "min"), null):
		var _t61 = (18.0 * 60.0)
		J.sp(v_p_288, "min", _t61)
	var _t62 = J.gp(v_p_288, "kills")
	var _t63 = (_t62 if J.t(_t62) else 0.0)
	J.sp(v_p_288, "kills", _t63)
	var _t64 = J.gp(v_p_288, "rec")
	var _t65 = (_t64 if J.t(_t64) else 0.0)
	J.sp(v_p_288, "rec", _t65)
	var _t66 = J.gp(v_p_288, "poach")
	var _t67 = (_t66 if J.t(_t66) else [])
	J.sp(v_p_288, "poach", _t67)
	return v_p_288

func _f26(this_, a: Array, env):
	var v_ci_291 = null; var v_p_292 = null; var v_r_293 = null
	v_ci_291 = J.arg(a, 0)
	v_p_292 = J.cl(env["st"], null, [])
	v_r_293 = J.gp(J.gp(v_p_292, "reg"), v_ci_291)
	var _t69 = (not J.t(v_r_293))
	if not J.t(_t69):
		var _t68 = (not J.seq(J.gp(v_r_293, "v"), 2.0))
		_t69 = ((not J.seq(J.gp(v_r_293, "v"), 3.0)) if _t68 else _t68)
	if _t69:
		var _t70 = J.gp(v_p_292, "reg")
		var _t71 = {"v": 3.0, "fog": "", "sta": {}, "ot": (-1.0), "pr": (-1.0), "kings": {}}
		J.sp(_t70, v_ci_291, _t71)
		v_r_293 = _t71
	if J.seq(J.gp(v_r_293, "v"), 2.0):
		J.sp(v_r_293, "v", 3.0)
		J.sp(v_r_293, "fog", "")
		var _t72 = {}
		J.sp(v_r_293, "sta", _t72)
	var _t73 = J.gp(v_r_293, "sta")
	var _t74 = (_t73 if J.t(_t73) else {})
	J.sp(v_r_293, "sta", _t74)
	var _t75 = J.gp(v_r_293, "kings")
	var _t76 = (_t75 if J.t(_t75) else {})
	J.sp(v_r_293, "kings", _t76)
	var _t77 = J.gp(v_r_293, "lm")
	var _t78 = (_t77 if J.t(_t77) else {})
	J.sp(v_r_293, "lm", _t78)
	var _t79 = J.gp(v_r_293, "ca")
	var _t80 = (_t79 if J.t(_t79) else {})
	J.sp(v_r_293, "ca", _t80)
	var _t81 = J.gp(v_r_293, "pg")
	var _t82 = (_t81 if J.t(_t81) else {})
	J.sp(v_r_293, "pg", _t82)
	var _t83 = J.gp(v_r_293, "sg")
	var _t84 = (_t83 if J.t(_t83) else {})
	J.sp(v_r_293, "sg", _t84)
	return v_r_293

func _f27(this_, a: Array, env):
	var v_ci_296 = null; var v_m_297 = null; var v_z_298 = null
	v_ci_296 = J.arg(a, 0)
	v_m_297 = env["MIR"]
	var _t85 = J.seq(J.mod(v_ci_296, 2.0), 1.0)
	env["MIR"] = _t85
	var _t87 = J.mul(6.0, env["COLS"])
	var _t86 = env["mc"]
	v_z_298 = J.add(_t87, J.cl(_t86, null, [0.0]))
	env["MIR"] = v_m_297
	return v_z_298

func _f28(this_, a: Array, env):
	var v_z_301 = null
	v_z_301 = J.arg(a, 0)
	var _t89 = J.gp(env["TNAME"], (J.gp(env["R"], "ci") if J.t(env["R"]) else 0.0))
	var _t88 = env["terOf"]
	return J.gp(_t89, J.cl(_t88, null, [v_z_301]))

func _f30(this_, a: Array, env):
	var v_ci_306 = null
	v_ci_306 = J.arg(a, 0)
	var _t92 = J.seq(v_ci_306, 0.0)
	if not J.t(_t92):
		var _t91 = J.gp(J.G.get("S"), "cleared")
		var _t90 = env["sidOf"]
		_t92 = (not (not J.t(J.gp(_t91, J.cl(_t90, null, [J.sub(v_ci_306, 1.0), 2.0])))))
	return _t92

func _f31(this_, a: Array, env):
	var v_f_309 = null; var v_c_310 = null
	v_f_309 = J.arg(a, 0)
	var _t93 = env["zoneCell"]
	v_c_310 = J.cl(_t93, null, [J.gp(v_f_309, "z")])
	return {"x": J.add(J.gp(v_c_310, "x"), J.gp(v_f_309, "ox")), "y": J.add(J.gp(v_c_310, "y"), J.gp(v_f_309, "oy"))}

func _f33(this_, a: Array, env):
	var v_k_314 = null
	v_k_314 = J.arg(a, 0)
	return J.seq(J.gp(J.gp(J.G.get("N30_G"), v_k_314), "at"), J.gp(J.gp(env["__p"]["REG"], env["ci"]), "site"))

func _f32(this_, a: Array, env):
	var _s35 = {"__p": env, "ci": null}
	_s35["ci"] = J.arg(a, 0)
	var _t94 = _s35["__p"]["has"]
	var _t96 = null
	if J.t(J.cl(_t94, null, [J.G.get("N30W")])):
		var _t95 = J.mc(J.G.get("N30W"), "ids", [])
		_t96 = J.mc(_t95, "filter", [Callable(self, "_f33").bind(_s35)])
	else:
		_t96 = []
	return _t96

func _f34(this_, a: Array, env):
	var v_ci_317 = null; var v_z_318 = null; var v_l_319 = null; var v_k_320 = null
	v_ci_317 = J.arg(a, 0)
	v_z_318 = J.arg(a, 1)
	var _t97 = env["elitesOf"]
	v_l_319 = J.cl(_t97, null, [v_ci_317])
	if (not J.t(J.len(v_l_319))):
		return null
	v_k_320 = J.gp(v_l_319, J.mod(v_z_318, J.len(v_l_319)))
	var _t98 = J.cmp(v_z_318, J.len(v_l_319), "<")
	var _t99 = (_t98 if _t98 else J.seq(J.mod(v_z_318, 2.0), 0.0))
	return (v_k_320 if J.t((J.mc(J.G.get("N30W"), "open", [v_k_320]) if _t99 else _t99)) else null)

func _f35(this_, a: Array, env):
	var v_ci_323 = null; var v_a_324 = null; var v_i_325 = null
	v_ci_323 = J.arg(a, 0)
	v_a_324 = []
	v_i_325 = 0.0
	while true:
		if not J.cmp(v_i_325, v_ci_323, "<="): break
		var _t100 = J.mc(v_a_324, "concat", [J.gp(env["CH_FOD"], v_i_325)])
		v_a_324 = _t100
		v_i_325 = J.num(v_i_325) + 1.0
	return v_a_324

func _f36(this_, a: Array, env):
	var v_min_328 = null; var v_h_329 = null
	v_min_328 = J.arg(a, 0)
	v_h_329 = floor(J.num(J.div(v_min_328, 60.0)))
	return ("zi" if J.cmp(v_h_329, 4.0, "<") else ("off" if J.cmp(v_h_329, 8.0, "<") else ("work" if J.cmp(v_h_329, 18.0, "<") else "ot")))

func _f40(this_, a: Array, env):
	var v_g_332 = null
	v_g_332 = J.arg(a, 0)
	var _t102 = J.seq(J.gp(v_g_332, "q"), "藍")
	var _t103 = (_t102 if _t102 else J.seq(J.gp(v_g_332, "q"), "紫"))
	var _t104 = ((not J.t(J.gp(v_g_332, "post"))) if _t103 else _t103)
	var _t106 = ((not J.t(J.gp(v_g_332, "poached"))) if _t104 else _t104)
	if J.t(_t106):
		var _t105 = J.gp(v_g_332, "fat")
		_t106 = J.cmp((_t105 if J.t(_t105) else 0.0), 100.0, "<")
	return _t106

func _f41(this_, a: Array, env):
	var v_a_333 = null; var v_b_334 = null
	v_a_333 = J.arg(a, 0)
	v_b_334 = J.arg(a, 1)
	return J.sub(J.mc(J.G.get("F"), "glv", [v_b_334]), J.mc(J.G.get("F"), "glv", [v_a_333]))

func _f39(this_, a: Array, env):
	var _t101 = J.gp(J.G.get("S"), "ghosts")
	var _t107 = J.mc(_t101, "filter", [Callable(self, "_f40").bind(env)])
	var _t108 = J.mc(_t107, "sort", [Callable(self, "_f41").bind(env)])
	return J.mc(_t108, "slice", [0.0, J.cl(env["crewCap"], null, [])])

func _f43(this_, a: Array, env):
	var v_id_339 = null
	v_id_339 = J.arg(a, 0)
	return ((not J.seq(v_id_339, "afu")) if J.t(v_id_339) else v_id_339)

func _f44(this_, a: Array, env):
	var v_g_340 = null
	v_g_340 = J.arg(a, 0)
	return ((not J.seq(J.gp(v_g_340, "k"), "afu")) if J.t(v_g_340) else v_g_340)

func _f42(this_, a: Array, env):
	var v_p_337 = null; var v_ids_338 = null
	v_p_337 = J.cl(env["st"], null, [])
	v_ids_338 = J.gp(v_p_337, "lead")
	if (not J.t(v_ids_338)):
		var _t109 = J.gp(J.G.get("S"), "team")
		var _t110 = J.mc(_t109, "filter", [Callable(self, "_f43").bind(env)])
		v_ids_338 = _t110
	var _t111 = J.mc(v_ids_338, "map", [J.G.get("ghostById")])
	var _t112 = J.mc(_t111, "filter", [Callable(self, "_f44").bind(env)])
	return J.mc(_t112, "slice", [0.0, 3.0])

func _f46(this_, a: Array, env):
	var v_g_346 = null
	v_g_346 = J.arg(a, 0)
	if J.t(J.gp(v_g_346, "fat")):
		var _t114 = J.max_([0.0, J.sub(J.gp(v_g_346, "fat"), J.mul(env["m"], 2.0))])
		J.sp(v_g_346, "fat", _t114)

func _f45(this_, a: Array, env):
	var v_p_343 = null; var v_now_344 = null
	v_p_343 = J.cl(env["st"], null, [])
	v_now_344 = J.S_Date_("now", [])
	if J.t(J.gp(v_p_343, "restAt")):
		var _s50 = {"__p": env, "m": null}
		_s50["m"] = J.div(J.sub(v_now_344, J.gp(v_p_343, "restAt")), 60000.0)
		if J.cmp(_s50["m"], 0.0, ">"):
			var _t113 = J.gp(J.G.get("S"), "ghosts")
			J.mc(_t113, "forEach", [Callable(self, "_f46").bind(_s50)])
	J.sp(v_p_343, "restAt", v_now_344)

func _f47(this_, a: Array, env):
	var v_g_349 = null; var v_role_350 = null; var v_P_351 = null; var v_A_352 = null; var v_dm_353 = null; var v_d_354 = null; var v_gm_355 = null; var v_crew_356 = null; var v_fac_357 = null; var v_cm_358 = null; var v_hp_359 = null; var v_atk_360 = null; var v_rng_361 = null
	v_g_349 = J.arg(a, 0)
	v_role_350 = J.arg(a, 1)
	v_P_351 = J.mc(J.G.get("F"), "stat", [v_g_349, 0.0])
	v_A_352 = J.mc(J.G.get("F"), "stat", [v_g_349, 2.0])
	v_dm_353 = J.mc(J.G.get("GP"), "drillMul", [J.gp(v_g_349, "k")])
	var _t115 = J.G.get("gdef")
	v_d_354 = J.cl(_t115, null, [v_g_349])
	var _t116 = env["has"]
	v_gm_355 = (J.mc(J.G.get("Gear"), "unitMul", [v_g_349]) if J.t(J.cl(_t116, null, [J.G.get("Gear")])) else {"atk": 1.0, "hp": 1.0})
	v_crew_356 = J.seq(v_role_350, "crew")
	var _t117 = env["facOf"]
	v_fac_357 = J.cl(_t117, null, [J.gp(v_g_349, "k")])
	var _t119 = null
	if J.t((env["R"] if J.t(v_crew_356) else v_crew_356)):
		var _t118 = J.gp(J.gp(env["R"], "crewBuff"), v_fac_357)
		_t119 = (_t118 if J.t(_t118) else {"atk": 1.0, "hp": 1.0})
	else:
		_t119 = {"atk": 1.0, "hp": 1.0}
	v_cm_358 = _t119
	v_hp_359 = J.mul(J.mul(J.mul((((220.0 + J.mul(v_P_351, 6.0)) + J.mul(v_A_352, 3.0)) if J.t(v_crew_356) else ((300.0 + J.mul(v_P_351, 8.0)) + J.mul(v_A_352, 4.0))), v_dm_353), J.gp(v_gm_355, "hp")), J.gp(v_cm_358, "hp"))
	v_atk_360 = J.mul(J.mul(J.mul(((15.0 + J.mul(v_A_352, 1.1)) if J.t(v_crew_356) else (20.0 + J.mul(v_A_352, 1.4))), v_dm_353), J.gp(v_gm_355, "atk")), J.gp(v_cm_358, "atk"))
	v_rng_361 = (150.0 if J.seq(J.gp(v_d_354, "range"), "ranged") else 46.0)
	return {"side": 0.0, "role": v_role_350, "g": v_g_349, "gid": J.gp(v_g_349, "id"), "k": J.gp(v_g_349, "k"), "name": J.gp(v_g_349, "name"), "fac": v_fac_357, "hp": v_hp_359, "maxhp": v_hp_359, "atk": v_atk_360, "rng": v_rng_361, "aspd": (1.2 if J.cmp(v_rng_361, 60.0, ">") else 1.0), "spd": (160.0 if J.seq(v_role_350, "lead") else 175.0), "cd": (randf() * 0.6), "energy": (0.0 if J.seq(v_role_350, "crew") else 30.0), "sk": (null if J.seq(v_role_350, "crew") else J.gp(J.G.get("SKILLS"), J.gp(v_g_349, "k"))), "s": (0.6 if J.seq(v_role_350, "afu") else (0.6 if J.seq(v_role_350, "lead") else 0.48)), "x": 0.0, "y": 0.0, "ox": 0.0, "oy": 0.0, "flip": false, "anim": 0.0, "hurt": 0.0}

func _f50(this_, a: Array, env):
	var v_h_368 = null; var v_w_369 = null
	var _t125 = env["im"]
	J.sp(_t125, "_ok", true)
	v_h_368 = 330.0
	v_w_369 = J.div(J.mul(v_h_368, J.gp(env["im"], "naturalWidth")), J.gp(env["im"], "naturalHeight"))
	J.mc(J.G.get("Puppet"), "addTool", [env["n"], env["key"], v_w_369, v_h_368, 0.86])

func _f49(this_, a: Array, env):
	var v_src_365 = null
	var _s54 = {"__p": env, "n": null, "key": null, "im": null}
	_s54["n"] = J.arg(a, 0)
	v_src_365 = J.gp(J.G.get("PT_IMG_SRC"), _s54["n"])
	if (not J.t(v_src_365)):
		return null
	_s54["key"] = J.add("pt_", _s54["n"])
	_s54["im"] = J.new_("Image", [])
	var _t124 = _s54["im"]
	var _t126 = Callable(self, "_f50").bind(_s54)
	J.sp(_t124, "onload", _t126)
	var _t127 = _s54["im"]
	J.sp(_t127, "src", v_src_365)
	var _t128 = J.G.get("SPR")
	var _t129 = _s54["key"]
	var _t130 = _s54["im"]
	J.sp(_t128, _t129, _t130)

func _f48(this_, a: Array, env):
	var _t121 = env["wReg"]
	if not J.t(_t121):
		var _t120 = env["has"]
		_t121 = (not J.t(J.cl(_t120, null, [J.G.get("Gear")])))
	var _t122 = (_t121 if J.t(_t121) else J.seq(J.typeof_(J.G.get("Puppet")), "undefined"))
	if J.t((_t122 if J.t(_t122) else (not J.t(J.gp(J.G.get("Puppet"), "addTool"))))):
		return null
	env["wReg"] = true
	var _t123 = J.mc(J.gp(J.G.get("Gear"), "WIMG"), "flat", [])
	J.mc(_t123, "forEach", [Callable(self, "_f49").bind(env)])

func _f51(this_, a: Array, env):
	var v_u_372 = null; var v_g_373 = null; var v_w_374 = null; var v_ar_375 = null; var v_bd_376 = null
	v_u_372 = J.arg(a, 0)
	v_g_373 = J.arg(a, 1)
	J.cl(env["regWeapons"], null, [])
	var _t131 = env["has"]
	var _t132 = (not J.t(J.cl(_t131, null, [J.G.get("Gear")])))
	if (_t132 if _t132 else (not J.t(v_g_373))):
		return null
	v_w_374 = J.mc(J.G.get("Gear"), "weaponOf", [v_g_373])
	if J.t(v_w_374):
		J.sp(v_u_372, "wpn", v_w_374)
		var _t133 = J.gp(J.gp(v_w_374, "S"), "rng")
		J.sp(v_u_372, "rng", _t133)
		var _t134 = J.gp(J.gp(v_w_374, "S"), "aspd")
		J.sp(v_u_372, "aspd", _t134)
	v_ar_375 = J.mc(J.G.get("Gear"), "armorOf", [v_g_373])
	var _t135 = (J.gp(J.gp(env["CLOTH"], J.gp(v_ar_375, "f")), (1.0 if J.cmp(J.gp(v_ar_375, "c"), 3.0, ">=") else 0.0)) if J.t(v_ar_375) else null)
	J.sp(v_u_372, "cloth", _t135)
	v_bd_376 = J.mc(J.G.get("Gear"), "badgeOf", [v_g_373])
	var _t136 = ({"col": J.gp(J.gp(env["FAC"], J.gp(v_bd_376, "f")), "col"), "c": J.gp(v_bd_376, "c")} if J.t(v_bd_376) else null)
	J.sp(v_u_372, "badge", _t136)

func _f52(this_, a: Array, env):
	var v_i_379 = null; var v_tb_380 = null; var v_hp_381 = null
	v_i_379 = J.arg(a, 0)
	v_tb_380 = (1.0 + (0.08 * J.max_([0.0, J.sub(J.gp(J.gp(J.G.get("S"), "bld"), "home"), 1.0)])))
	v_hp_381 = J.mul((90.0 + J.mul(14.0, J.gp(J.G.get("S"), "lv"))), v_tb_380)
	return {"side": 0.0, "role": "troop", "k": "youhun", "name": "陰兵", "hp": v_hp_381, "maxhp": v_hp_381, "atk": J.mul((9.0 + J.mul(2.2, J.gp(J.G.get("S"), "lv"))), v_tb_380), "rng": 40.0, "aspd": 1.0, "spd": 175.0, "cd": randf(), "energy": 0.0, "s": 0.4, "x": 0.0, "y": 0.0, "ox": 0.0, "oy": 0.0, "ti": v_i_379, "anim": 0.0, "hurt": 0.0}

func _f53(this_, a: Array, env):
	var v_k_384 = null; var v_p_385 = null; var v_mul_386 = null; var v_extra_387 = null; var v_t_388 = null; var v_zi_389 = null; var v_hp_390 = null; var v_atk_391 = null; var v_d_392 = null; var v_rng_393 = null
	v_k_384 = J.arg(a, 0)
	v_p_385 = J.arg(a, 1)
	v_mul_386 = J.arg(a, 2)
	v_extra_387 = J.arg(a, 3)
	var _t137 = J.gp(J.G.get("ENEMY_T"), v_k_384)
	v_t_388 = (_t137 if J.t(_t137) else [1.0, 1.0, v_k_384])
	var _t139 = env["R"]
	if J.t(_t139):
		var _t138 = env["phase"]
		_t139 = J.seq(J.cl(_t138, null, [J.gp(J.cl(env["st"], null, []), "min")]), "zi")
	v_zi_389 = (1.3 if J.t(_t139) else 1.0)
	v_hp_390 = J.mul(J.mul((J.mul((260.0 + J.mul(90.0, v_p_385)), J.gp(v_t_388, 0.0)) * 0.55), (J.gp(v_mul_386, "hp") if J.t(v_mul_386) else 1.0)), v_zi_389)
	v_atk_391 = J.mul(J.mul((J.mul((16.0 + J.mul(7.5, v_p_385)), J.gp(v_t_388, 1.0)) * 0.6), (J.gp(v_mul_386, "atk") if J.t(v_mul_386) else 1.0)), v_zi_389)
	var _t140 = J.gp(J.G.get("GHOSTS"), v_k_384)
	var _t141 = (_t140 if J.t(_t140) else J.gp(J.G.get("FODDER"), v_k_384))
	v_d_392 = (_t141 if J.t(_t141) else {})
	var _t143 = J.seq(J.gp(v_d_392, "range"), "ranged")
	if not J.t(_t143):
		var _t142 = ["zhiren", "penanggal"]
		_t143 = J.mc(_t142, "includes", [v_k_384])
	v_rng_393 = (140.0 if J.t(_t143) else 44.0)
	var _t145 = J.gp(v_t_388, 2.0)
	var _t144 = env["facOf"]
	var _t150 = J.cl(_t144, null, [v_k_384])
	var _t151 = (1.3 if J.cmp(v_rng_393, 60.0, ">") else 1.1)
	var _t152 = (120.0 if J.seq(v_k_384, "xiaogui") else 100.0)
	var _t153 = randf()
	var _t146 = J.gp(J.G.get("SKILLS"), v_k_384)
	var _t149 = (v_extra_387 if J.t(_t146) else _t146)
	if J.t(_t149):
		var _t147 = J.gp(v_extra_387, "elite")
		var _t148 = (_t147 if J.t(_t147) else (not J.leq(J.gp(v_extra_387, "guard"), null)))
		_t149 = (_t148 if J.t(_t148) else J.gp(v_extra_387, "otBoss"))
	return J.S_Object_("assign", [{"side": 1.0, "k": v_k_384, "name": _t145, "fac": _t150, "p": v_p_385, "hp": v_hp_390, "maxhp": v_hp_390, "atk": v_atk_391, "rng": v_rng_393, "aspd": _t151, "spd": _t152, "cd": _t153, "energy": 0.0, "sk": (J.gp(J.G.get("SKILLS"), v_k_384) if J.t(_t149) else null), "s": 0.5, "x": 0.0, "y": 0.0, "ox": 0.0, "oy": 0.0, "anim": 0.0, "hurt": 0.0, "flip": true}, (v_extra_387 if J.t(v_extra_387) else {})])

func _f55(this_, a: Array, env):
	var _t154 = J.mod((J.mul(env["s"], 9301.0) + 49297.0), 233280.0)
	env["s"] = _t154
	return J.div(env["s"], 233280.0)

func _f54(this_, a: Array, env):
	var v_n_396 = null
	var _s60 = {"__p": env, "s": null}
	v_n_396 = J.arg(a, 0)
	_s60["s"] = (J.mul(v_n_396, 9301.0) + 49297.0)
	return Callable(self, "_f55").bind(_s60)

func _f56(this_, a: Array, env):
	var v_ci_400 = null; var v_c_401 = null; var v_x_402 = null; var v_rg_403 = null; var v_rnd_404 = null; var v_i_405 = null; var v_px_406 = null; var v_py_407 = null; var v_l_408 = null; var v_a_409 = null
	v_ci_400 = J.arg(a, 0)
	v_c_401 = J.S_document_("createElement", ["canvas"])
	J.sp(v_c_401, "height", 256.0)
	J.sp(v_c_401, "width", 256.0)
	v_x_402 = J.mc(v_c_401, "getContext", ["2d"])
	v_rg_403 = J.gp(env["REG"], v_ci_400)
	var _t155 = env["seeded"]
	v_rnd_404 = J.cl(_t155, null, [J.add(v_ci_400, 7.0)])
	var _t156 = J.gp(v_rg_403, "g0")
	J.sp(v_x_402, "fillStyle", _t156)
	J.mc(v_x_402, "fillRect", [0.0, 0.0, 256.0, 256.0])
	v_i_405 = 0.0
	while true:
		if not J.cmp(v_i_405, 260.0, "<"): break
		v_px_406 = J.mul(J.cl(v_rnd_404, null, []), 256.0)
		v_py_407 = J.mul(J.cl(v_rnd_404, null, []), 256.0)
		v_l_408 = (4.0 + J.mul(J.cl(v_rnd_404, null, []), 12.0))
		v_a_409 = J.mul(J.cl(v_rnd_404, null, []), PI)
		var _t157 = (J.gp(v_rg_403, "g1") if J.t(J.mod(v_i_405, 3.0)) else "rgba(0,0,0,.35)")
		J.sp(v_x_402, "strokeStyle", _t157)
		var _t158 = (0.25 + J.mul(J.cl(v_rnd_404, null, []), 0.4))
		J.sp(v_x_402, "globalAlpha", _t158)
		var _t159 = (1.0 + J.mul(J.cl(v_rnd_404, null, []), 1.6))
		J.sp(v_x_402, "lineWidth", _t159)
		J.sp(v_x_402, "lineCap", "round")
		J.mc(v_x_402, "beginPath", [])
		J.mc(v_x_402, "moveTo", [v_px_406, v_py_407])
		J.mc(v_x_402, "lineTo", [J.add(v_px_406, J.mul(cos(J.num(v_a_409)), v_l_408)), J.add(v_py_407, J.mul(sin(J.num(v_a_409)), v_l_408))])
		J.mc(v_x_402, "stroke", [])
		v_i_405 = J.num(v_i_405) + 1.0
	J.sp(v_x_402, "globalAlpha", 1.0)
	return v_c_401

func _f58(this_, a: Array, env):
	var v_g_412 = null
	v_g_412 = J.arg(a, 0)
	return ([{"x": J.sub(J.gp(v_g_412, "x"), 60.0), "y": J.gp(v_g_412, "y")}, {"x": J.add(J.gp(v_g_412, "x"), 60.0), "y": J.gp(v_g_412, "y")}] if J.t(J.gp(v_g_412, "vert")) else [{"x": J.gp(v_g_412, "x"), "y": J.sub(J.gp(v_g_412, "y"), 60.0)}, {"x": J.gp(v_g_412, "x"), "y": J.add(J.gp(v_g_412, "y"), 60.0)}])

func _f57(this_, a: Array, env):
	return J.spread([J.SP(J.mc(env["FACI"], "map", [env["faciPos"]])), J.SP(J.mc(env["TALL"], "map", [env["lairPos"]])), J.SP(J.mc(env["GATES"], "flatMap", [Callable(self, "_f58").bind(env)]))])

func _f59(this_, a: Array, env):
	var v_w_415 = null; var v_x_416 = null; var v_y_417 = null; var v_along_418 = null; var v_across_419 = null; var v_t_420 = null
	v_w_415 = J.arg(a, 0)
	v_x_416 = J.arg(a, 1)
	v_y_417 = J.arg(a, 2)
	v_along_418 = (v_x_416 if J.t(J.gp(v_w_415, "h")) else v_y_417)
	v_across_419 = (v_y_417 if J.t(J.gp(v_w_415, "h")) else v_x_416)
	v_t_420 = J.max_([J.gp(v_w_415, "a"), J.min_([J.gp(v_w_415, "b"), v_along_418])])
	return J.hypot_([J.sub(v_along_418, v_t_420), J.sub(v_across_419, J.gp(v_w_415, "p"))])

func _f61(this_, a: Array, env):
	var v_w_426 = null
	v_w_426 = J.arg(a, 0)
	var _t161 = env["__p"]["segD"]
	if J.cmp(J.cl(_t161, null, [v_w_426, env["x"], env["y"]]), env["m"], ">"):
		return false
	var _t162 = J.gp(v_w_426, "gap")
	if J.t(((absf(J.num(J.sub((env["x"] if J.t(J.gp(v_w_426, "h")) else env["y"]), J.gp(J.gp(v_w_426, "gap"), "c")))) < J.div(env["__p"]["GW"], 2.0)) if J.t(_t162) else _t162)):
		return false
	return true

func _f60(this_, a: Array, env):
	var _s68 = {"__p": env, "x": null, "y": null, "m": null}
	_s68["x"] = J.arg(a, 0)
	_s68["y"] = J.arg(a, 1)
	_s68["m"] = J.arg(a, 2)
	var _t160 = (_s68["m"] if J.t(_s68["m"]) else 50.0)
	_s68["m"] = _t160
	return J.mc(_s68["__p"]["WALLS"], "some", [Callable(self, "_f61").bind(_s68)])

func _f64(this_, a: Array, env):
	var v_g_450 = null
	v_g_450 = J.arg(a, 0)
	var _t170 = null
	if J.t(env["h"]):
		var _t164 = (not J.t(J.gp(v_g_450, "vert")))
		var _t165 = (J.seq(J.gp(v_g_450, "y"), env["p"]) if _t164 else _t164)
		var _t166 = (J.cmp(J.gp(v_g_450, "x"), env["a"], ">") if _t165 else _t165)
		_t170 = (J.cmp(J.gp(v_g_450, "x"), env["b"], "<") if _t166 else _t166)
	else:
		var _t167 = J.gp(v_g_450, "vert")
		var _t168 = (J.seq(J.gp(v_g_450, "x"), env["p"]) if J.t(_t167) else _t167)
		var _t169 = (J.cmp(J.gp(v_g_450, "y"), env["a"], ">") if J.t(_t168) else _t168)
		_t170 = (J.cmp(J.gp(v_g_450, "y"), env["b"], "<") if J.t(_t169) else _t169)
	return _t170

func _f63(this_, a: Array, env):
	var _s71 = {"__p": env, "h": null, "p": null, "a": null, "b": null}
	_s71["h"] = J.arg(a, 0)
	_s71["p"] = J.arg(a, 1)
	_s71["a"] = J.arg(a, 2)
	_s71["b"] = J.arg(a, 3)
	return J.mc(_s71["__p"]["__p"]["GATES"], "find", [Callable(self, "_f64").bind(_s71)])

func _f65(this_, a: Array, env):
	var v_q_469 = null
	v_q_469 = J.arg(a, 0)
	var _t182 = env["__p"]["__p"]["segD"]
	return J.cmp(J.cl(_t182, null, [env["w"], J.gp(v_q_469, "x"), J.gp(v_q_469, "y")]), 150.0, "<")

func _f66(this_, a: Array, env):
	var v_o_470 = null
	v_o_470 = J.arg(a, 0)
	var _t183 = J.seq(J.gp(v_o_470, "h"), J.gp(env["w"], "h"))
	var _t184 = ((absf(J.num(J.sub(J.gp(v_o_470, "p"), J.gp(env["w"], "p")))) < 160.0) if _t183 else _t183)
	var _t185 = (J.cmp(J.gp(v_o_470, "a"), J.gp(env["w"], "b"), "<") if _t184 else _t184)
	return (J.cmp(J.gp(env["w"], "a"), J.gp(v_o_470, "b"), "<") if _t185 else _t185)

func _f67(this_, a: Array, env):
	var v_w_471 = null; var v_v_472 = null; var v_x0_473 = null; var v_x1_474 = null; var v_y0_475 = null; var v_y1_476 = null; var v_j_477 = null; var v_i_478 = null; var v_x_479 = null; var v_y_480 = null
	v_w_471 = J.arg(a, 0)
	v_v_472 = J.arg(a, 1)
	v_x0_473 = (J.sub(J.gp(v_w_471, "a"), 20.0) if J.t(J.gp(v_w_471, "h")) else J.sub(J.gp(v_w_471, "p"), 20.0))
	v_x1_474 = (J.add(J.gp(v_w_471, "b"), 20.0) if J.t(J.gp(v_w_471, "h")) else J.add(J.gp(v_w_471, "p"), 20.0))
	v_y0_475 = (J.sub(J.gp(v_w_471, "p"), 20.0) if J.t(J.gp(v_w_471, "h")) else J.sub(J.gp(v_w_471, "a"), 20.0))
	v_y1_476 = (J.add(J.gp(v_w_471, "p"), 20.0) if J.t(J.gp(v_w_471, "h")) else J.add(J.gp(v_w_471, "b"), 20.0))
	v_j_477 = J.max_([0.0, floor(J.num(J.div(v_y0_475, env["G"])))])
	while true:
		if not J.cmp(v_j_477, J.min_([J.sub(env["gh"], 1.0), floor(J.num(J.div(v_y1_476, env["G"])))]), "<="): break
		v_i_478 = J.max_([0.0, floor(J.num(J.div(v_x0_473, env["G"])))])
		while true:
			if not J.cmp(v_i_478, J.min_([J.sub(env["gw"], 1.0), floor(J.num(J.div(v_x1_474, env["G"])))]), "<="): break
			v_x_479 = (J.mul(v_i_478, env["G"]) + J.div(env["G"], 2.0))
			v_y_480 = (J.mul(v_j_477, env["G"]) + J.div(env["G"], 2.0))
			var _t187 = env["__p"]["segD"]
			if J.cmp(J.cl(_t187, null, [v_w_471, v_x_479, v_y_480]), 18.0, ">="):
				v_i_478 = J.num(v_i_478) + 1.0
				continue
			var _t188 = J.gp(v_w_471, "gap")
			if J.t(((absf(J.num(J.sub((v_x_479 if J.t(J.gp(v_w_471, "h")) else v_y_480), J.gp(J.gp(v_w_471, "gap"), "c")))) < (J.div(env["__p"]["GW"], 2.0) - 14.0)) if J.t(_t188) else _t188)):
				v_i_478 = J.num(v_i_478) + 1.0
				continue
			var _t189 = env["blk"]
			var _t190 = J.add(J.mul(v_j_477, env["gw"]), v_i_478)
			var _t191 = J.add(J.gp(_t189, _t190), v_v_472)
			J.sp(_t189, _t190, _t191)
			v_i_478 = J.num(v_i_478) + 1.0
		v_j_477 = J.num(v_j_477) + 1.0

func _f68(this_, a: Array, env):
	var v_p_481 = null
	v_p_481 = J.arg(a, 0)
	return (J.mul(floor(J.num(J.div(J.gp(v_p_481, "y"), env["G"]))), env["gw"]) + floor(J.num(J.div(J.gp(v_p_481, "x"), env["G"]))))

func _f70(this_, a: Array, env):
	var v_k_487 = null
	v_k_487 = J.arg(a, 0)
	return J.gp(env["seen"], v_k_487)

func _f69(this_, a: Array, env):
	var v_h_482 = null; var v_t_483 = null; var v_k_484 = null; var v_i_485 = null; var v_j_486 = null
	J.mc(env["seen"], "fill", [0.0])
	v_h_482 = 0.0
	v_t_483 = 0.0
	var _t194 = env["q"]
	var _t193 = J.num(v_t_483)
	v_t_483 = _t193 + 1.0
	var _t195 = env["start"]
	J.sp(_t194, _t193, _t195)
	var _t196 = env["seen"]
	var _t197 = env["start"]
	J.sp(_t196, _t197, 1.0)
	while true:
		if not J.cmp(v_h_482, v_t_483, "<"): break
		var _t199 = env["q"]
		var _t198 = J.num(v_h_482)
		v_h_482 = _t198 + 1.0
		v_k_484 = J.gp(_t199, _t198)
		v_i_485 = J.mod(v_k_484, env["gw"])
		v_j_486 = J.div(J.sub(v_k_484, v_i_485), env["gw"])
		var _t200 = J.cmp(v_i_485, 0.0, ">")
		var _t201 = ((not J.t(J.gp(env["seen"], J.sub(v_k_484, 1.0)))) if _t200 else _t200)
		if ((not J.t(J.gp(env["blk"], J.sub(v_k_484, 1.0)))) if _t201 else _t201):
			var _t202 = env["seen"]
			var _t203 = J.sub(v_k_484, 1.0)
			J.sp(_t202, _t203, 1.0)
			var _t205 = env["q"]
			var _t204 = J.num(v_t_483)
			v_t_483 = _t204 + 1.0
			var _t206 = J.sub(v_k_484, 1.0)
			J.sp(_t205, _t204, _t206)
		var _t207 = J.cmp(v_i_485, J.sub(env["gw"], 1.0), "<")
		var _t208 = ((not J.t(J.gp(env["seen"], J.add(v_k_484, 1.0)))) if _t207 else _t207)
		if ((not J.t(J.gp(env["blk"], J.add(v_k_484, 1.0)))) if _t208 else _t208):
			var _t209 = env["seen"]
			var _t210 = J.add(v_k_484, 1.0)
			J.sp(_t209, _t210, 1.0)
			var _t212 = env["q"]
			var _t211 = J.num(v_t_483)
			v_t_483 = _t211 + 1.0
			var _t213 = J.add(v_k_484, 1.0)
			J.sp(_t212, _t211, _t213)
		var _t214 = J.cmp(v_j_486, 0.0, ">")
		var _t215 = ((not J.t(J.gp(env["seen"], J.sub(v_k_484, env["gw"])))) if _t214 else _t214)
		if ((not J.t(J.gp(env["blk"], J.sub(v_k_484, env["gw"])))) if _t215 else _t215):
			var _t216 = env["seen"]
			var _t217 = J.sub(v_k_484, env["gw"])
			J.sp(_t216, _t217, 1.0)
			var _t219 = env["q"]
			var _t218 = J.num(v_t_483)
			v_t_483 = _t218 + 1.0
			var _t220 = J.sub(v_k_484, env["gw"])
			J.sp(_t219, _t218, _t220)
		var _t221 = J.cmp(v_j_486, J.sub(env["gh"], 1.0), "<")
		var _t222 = ((not J.t(J.gp(env["seen"], J.add(v_k_484, env["gw"])))) if _t221 else _t221)
		if ((not J.t(J.gp(env["blk"], J.add(v_k_484, env["gw"])))) if _t222 else _t222):
			var _t223 = env["seen"]
			var _t224 = J.add(v_k_484, env["gw"])
			J.sp(_t223, _t224, 1.0)
			var _t226 = env["q"]
			var _t225 = J.num(v_t_483)
			v_t_483 = _t225 + 1.0
			var _t227 = J.add(v_k_484, env["gw"])
			J.sp(_t226, _t225, _t227)
	return J.mc(env["kc"], "every", [Callable(self, "_f70").bind(env)])

func _f71(this_, a: Array, env):
	var v_w_488 = null
	v_w_488 = J.arg(a, 0)
	var _t228 = env["paint"]
	return J.cl(_t228, null, [v_w_488, 1.0])

func _f62(this_, a: Array, env):
	var v_ci_429 = null; var v_gateOn_430 = null; var v_rnd_431 = null; var v_kp_432 = null; var v_inner_433 = null; var v_kind_434 = null; var v_s0_440 = null; var v_ok_445 = null; var v_r_451 = null; var v_c_452 = null; var v_p_453 = null; var v_a_454 = null; var v_b_455 = null; var v_g_456 = null; var v_p_457 = null; var v_a_458 = null; var v_b_459 = null; var v_g_460 = null; var v_n_461 = null; var v_z_462 = null; var v_cell_463 = null; var v_h_464 = null; var v_L_465 = null; var v_off_466 = null; var v_fromLo_467 = null; var v_w_489 = null
	var _s70 = {"__p": env, "G": null, "gw": null, "gh": null, "blk": null, "paint": null, "start": null, "kc": null, "seen": null, "q": null}
	v_ci_429 = J.arg(a, 0)
	var _t163 = []
	_s70["__p"]["WALLS"] = _t163
	v_gateOn_430 = Callable(self, "_f63").bind(_s70)
	v_r_451 = 0.0
	while true:
		if not J.cmp(v_r_451, _s70["__p"]["ROWS"], "<"): break
		v_c_452 = 0.0
		while true:
			if not J.cmp(v_c_452, _s70["__p"]["COLS"], "<"): break
			var _t174 = J.cmp(v_c_452, J.sub(_s70["__p"]["COLS"], 1.0), "<")
			if J.t(_t174):
				var _t171 = _s70["__p"]["terAt"]
				var _t173 = J.cl(_t171, null, [v_r_451, v_c_452])
				var _t172 = _s70["__p"]["terAt"]
				_t174 = (not J.seq(_t173, J.cl(_t172, null, [v_r_451, J.add(v_c_452, 1.0)])))
			if _t174:
				v_p_453 = J.mul(J.add(v_c_452, 1.0), _s70["__p"]["CW"])
				v_a_454 = J.mul(v_r_451, _s70["__p"]["CH"])
				v_b_455 = J.mul(J.add(v_r_451, 1.0), _s70["__p"]["CH"])
				v_g_456 = J.cl(v_gateOn_430, null, [false, v_p_453, v_a_454, v_b_455])
				J.mc(_s70["__p"]["WALLS"], "push", [{"h": false, "p": v_p_453, "a": v_a_454, "b": v_b_455, "kind": "border", "gap": ({"c": J.gp(v_g_456, "y"), "g": v_g_456} if J.t(v_g_456) else null)}])
			var _t178 = J.cmp(v_r_451, J.sub(_s70["__p"]["ROWS"], 1.0), "<")
			if J.t(_t178):
				var _t175 = _s70["__p"]["terAt"]
				var _t177 = J.cl(_t175, null, [v_r_451, v_c_452])
				var _t176 = _s70["__p"]["terAt"]
				_t178 = (not J.seq(_t177, J.cl(_t176, null, [J.add(v_r_451, 1.0), v_c_452])))
			if _t178:
				v_p_457 = J.mul(J.add(v_r_451, 1.0), _s70["__p"]["CH"])
				v_a_458 = J.mul(v_c_452, _s70["__p"]["CW"])
				v_b_459 = J.mul(J.add(v_c_452, 1.0), _s70["__p"]["CW"])
				v_g_460 = J.cl(v_gateOn_430, null, [true, v_p_457, v_a_458, v_b_459])
				J.mc(_s70["__p"]["WALLS"], "push", [{"h": true, "p": v_p_457, "a": v_a_458, "b": v_b_459, "kind": "border", "gap": ({"c": J.gp(v_g_460, "x"), "g": v_g_460} if J.t(v_g_460) else null)}])
			v_c_452 = J.num(v_c_452) + 1.0
		v_r_451 = J.num(v_r_451) + 1.0
	var _t179 = _s70["__p"]["seeded"]
	v_rnd_431 = J.cl(_t179, null, [(J.mul(v_ci_429, 57.0) + 11.0)])
	v_kp_432 = J.cl(_s70["__p"]["keyPts"], null, [])
	v_inner_433 = []
	var _t180 = J.seq(v_ci_429, 3.0)
	v_kind_434 = ("river" if (_t180 if _t180 else J.seq(v_ci_429, 1.0)) else "ravine")
	v_n_461 = 0.0
	while true:
		if not J.cmp(v_n_461, (J.mul(_s70["__p"]["COLS"], _s70["__p"]["ROWS"]) * 2.4), "<"): break
		var _s79 = {"__p": _s70, "w": null}
		v_z_462 = J.mod(v_n_461, J.mul(_s79["__p"]["__p"]["COLS"], _s79["__p"]["__p"]["ROWS"]))
		if J.cmp(J.cl(v_rnd_431, null, []), (0.1 if J.cmp(v_n_461, J.mul(_s79["__p"]["__p"]["COLS"], _s79["__p"]["__p"]["ROWS"]), "<") else 0.45), "<"):
			v_n_461 = J.num(v_n_461) + 1.0
			continue
		var _t181 = _s79["__p"]["__p"]["zoneCell"]
		v_cell_463 = J.cl(_t181, null, [v_z_462])
		v_h_464 = J.cmp(J.cl(v_rnd_431, null, []), 0.5, "<")
		v_L_465 = J.mul((0.42 + J.mul(J.cl(v_rnd_431, null, []), 0.18)), (_s79["__p"]["__p"]["CW"] if J.t(v_h_464) else _s79["__p"]["__p"]["CH"]))
		v_off_466 = (0.3 + J.mul(J.cl(v_rnd_431, null, []), 0.4))
		v_fromLo_467 = J.cmp(J.cl(v_rnd_431, null, []), 0.5, "<")
		_s79["w"] = ({"h": true, "p": (J.mul(J.gp(v_cell_463, "r"), _s79["__p"]["__p"]["CH"]) + J.mul(_s79["__p"]["__p"]["CH"], v_off_466)), "a": (J.mul(J.gp(v_cell_463, "c"), _s79["__p"]["__p"]["CW"]) if J.t(v_fromLo_467) else J.sub(J.mul(J.add(J.gp(v_cell_463, "c"), 1.0), _s79["__p"]["__p"]["CW"]), v_L_465)), "b": (J.add(J.mul(J.gp(v_cell_463, "c"), _s79["__p"]["__p"]["CW"]), v_L_465) if J.t(v_fromLo_467) else J.mul(J.add(J.gp(v_cell_463, "c"), 1.0), _s79["__p"]["__p"]["CW"])), "kind": v_kind_434, "gap": null} if J.t(v_h_464) else {"h": false, "p": (J.mul(J.gp(v_cell_463, "c"), _s79["__p"]["__p"]["CW"]) + J.mul(_s79["__p"]["__p"]["CW"], v_off_466)), "a": (J.mul(J.gp(v_cell_463, "r"), _s79["__p"]["__p"]["CH"]) if J.t(v_fromLo_467) else J.sub(J.mul(J.add(J.gp(v_cell_463, "r"), 1.0), _s79["__p"]["__p"]["CH"]), v_L_465)), "b": (J.add(J.mul(J.gp(v_cell_463, "r"), _s79["__p"]["__p"]["CH"]), v_L_465) if J.t(v_fromLo_467) else J.mul(J.add(J.gp(v_cell_463, "r"), 1.0), _s79["__p"]["__p"]["CH"])), "kind": v_kind_434, "gap": null})
		var _t186 = J.mc(v_kp_432, "some", [Callable(self, "_f65").bind(_s79)])
		if J.t((_t186 if J.t(_t186) else J.mc(v_inner_433, "some", [Callable(self, "_f66").bind(_s79)]))):
			v_n_461 = J.num(v_n_461) + 1.0
			continue
		J.mc(v_inner_433, "push", [_s79["w"]])
		v_n_461 = J.num(v_n_461) + 1.0
	_s70["G"] = 40.0
	_s70["gw"] = ceil(J.num(J.div(_s70["__p"]["WW"], _s70["G"])))
	_s70["gh"] = ceil(J.num(J.div(_s70["__p"]["WH"], _s70["G"])))
	_s70["blk"] = J.new_("Uint8Array", [J.mul(_s70["gw"], _s70["gh"])])
	_s70["paint"] = Callable(self, "_f67").bind(_s70)
	var _t192 = _s70["__p"]["faciPos"]
	v_s0_440 = J.cl(_t192, null, [J.gp(_s70["__p"]["FACI"], 0.0)])
	_s70["start"] = (J.mul(floor(J.num(J.div(J.gp(v_s0_440, "y"), _s70["G"]))), _s70["gw"]) + floor(J.num(J.div(J.gp(v_s0_440, "x"), _s70["G"]))))
	_s70["kc"] = J.mc(v_kp_432, "map", [Callable(self, "_f68").bind(_s70)])
	_s70["seen"] = J.new_("Uint8Array", [J.mul(_s70["gw"], _s70["gh"])])
	_s70["q"] = J.new_("Int32Array", [J.mul(_s70["gw"], _s70["gh"])])
	v_ok_445 = Callable(self, "_f69").bind(_s70)
	J.mc(_s70["__p"]["WALLS"], "forEach", [Callable(self, "_f71").bind(_s70)])
	for _t229 in J.iter(v_inner_433):
		v_w_489 = _t229
		var _t230 = _s70["paint"]
		J.cl(_t230, null, [v_w_489, 1.0])
		if J.t(J.cl(v_ok_445, null, [])):
			J.mc(_s70["__p"]["WALLS"], "push", [v_w_489])
		else:
			var _t231 = _s70["paint"]
			J.cl(_t231, null, [v_w_489, (-1.0)])
	J.cl(v_ok_445, null, [])
	var _t232 = {"G": _s70["G"], "gw": _s70["gw"], "gh": _s70["gh"], "blk": _s70["blk"], "seen": J.mc(_s70["seen"], "slice", [])}
	_s70["__p"]["R0WALK"] = _t232

func _f73(this_, a: Array, env):
	var v_d_497 = null
	v_d_497 = J.arg(a, 0)
	return [J.gp(v_d_497, "big"), J.gp(v_d_497, "small")]

func _f74(this_, a: Array, env):
	var v_k_498 = null
	v_k_498 = J.arg(a, 0)
	var _t237 = (not J.t(J.mc(env["used"], "has", [v_k_498])))
	return (J.gp(J.G.get("GHOSTS"), v_k_498) if _t237 else _t237)

func _f72(this_, a: Array, env):
	var v_t_492 = null; var v_el_494 = null; var v_pool_495 = null; var v_k_496 = null
	var _s97 = {"__p": env, "used": null}
	v_t_492 = J.arg(a, 0)
	if J.t(J.gp(J.gp(_s97["__p"]["TKING"], J.gp(_s97["__p"]["R"], "ci")), v_t_492)):
		return J.gp(J.gp(_s97["__p"]["TKING"], J.gp(_s97["__p"]["R"], "ci")), v_t_492)
	if (not J.t(J.gp(_s97["__p"]["TSECRET"], v_t_492))):
		return null
	var _t234 = null
	if J.t(J.gp(_s97["__p"]["TKING"], J.gp(_s97["__p"]["R"], "ci"))):
		var _t233 = J.S_Object_("values", [J.gp(_s97["__p"]["TKING"], J.gp(_s97["__p"]["R"], "ci"))])
		_t234 = J.mc(_t233, "flatMap", [Callable(self, "_f73").bind(_s97)])
	else:
		_t234 = []
	_s97["used"] = J.new_("Set", [_t234])
	var _t235 = _s97["__p"]["elitesOf"]
	var _t236 = J.cl(_t235, null, [J.gp(_s97["__p"]["R"], "ci")])
	v_el_494 = J.mc(_t236, "filter", [Callable(self, "_f74").bind(_s97)])
	var _t238 = _s97["__p"]["fodOf"]
	v_pool_495 = J.cl(_t238, null, [J.gp(_s97["__p"]["R"], "ci")])
	v_k_496 = (J.gp(v_el_494, J.mod(J.sub(v_t_492, 6.0), J.len(v_el_494))) if J.t(J.len(v_el_494)) else J.gp(v_pool_495, (J.len(v_pool_495) - 1.0)))
	return {"small": v_k_496, "guard": true}

func _f77(this_, a: Array, env):
	var v_k_505 = null
	v_k_505 = J.arg(a, 0)
	var _t242 = (J.gp(J.G.get("GHOSTS"), v_k_505) if J.t(v_k_505) else v_k_505)
	var _t243 = (J.gp(J.gp(J.G.get("GHOSTS"), v_k_505), "lore") if J.t(_t242) else _t242)
	if J.t(((not J.t(J.mc(env["out"], "includes", [v_k_505]))) if J.t(_t243) else _t243)):
		J.mc(env["out"], "push", [v_k_505])

func _f76(this_, a: Array, env):
	var v_v_504 = null
	v_v_504 = J.arg(a, 0)
	var _t241 = [J.gp(v_v_504, "big"), J.gp(v_v_504, "small")]
	return J.mc(_t241, "forEach", [Callable(self, "_f77").bind(env)])

func _f75(this_, a: Array, env):
	var v_ci_501 = null; var v_d_502 = null
	var _s100 = {"__p": env, "out": null}
	v_ci_501 = J.arg(a, 0)
	var _t239 = J.gp(_s100["__p"]["TKING"], v_ci_501)
	v_d_502 = (_t239 if J.t(_t239) else {})
	_s100["out"] = []
	var _t240 = J.S_Object_("values", [v_d_502])
	J.mc(_t240, "forEach", [Callable(self, "_f76").bind(_s100)])
	return J.mc(_s100["out"], "slice", [0.0, 6.0])

func _f80(this_, a: Array, env):
	var v_q_528 = null
	v_q_528 = J.arg(a, 0)
	return (J.hypot_([J.sub(J.gp(v_q_528, "x"), env["x"]), J.sub(J.gp(v_q_528, "y"), env["y"])]) < 230.0)

func _f81(this_, a: Array, env):
	var v_o_529 = null
	v_o_529 = J.arg(a, 0)
	return J.cmp(J.hypot_([J.sub(J.gp(v_o_529, "x"), env["x"]), J.sub(J.gp(v_o_529, "y"), env["y"])]), (env["near"] if J.t(env["near"]) else 420.0), "<")

func _f82(this_, a: Array, env):
	var v_o_530 = null
	v_o_530 = J.arg(a, 0)
	return J.cmp(J.hypot_([J.sub(J.gp(v_o_530, "x"), env["x"]), J.sub(J.gp(v_o_530, "y"), env["y"])]), J.add(J.gp(v_o_530, "r"), 50.0), "<")

func _f79(this_, a: Array, env):
	var v_i_522 = null; var v_j_523 = null; var v_l_524 = null; var v_b_525 = null; var v_a_526 = null; var v_k_527 = null
	var _s104 = {"__p": env, "x": null, "y": null, "near": null}
	_s104["x"] = J.arg(a, 0)
	_s104["y"] = J.arg(a, 1)
	_s104["near"] = J.arg(a, 2)
	v_i_522 = floor(J.num(J.div(_s104["x"], J.gp(_s104["__p"]["W"], "G"))))
	v_j_523 = floor(J.num(J.div(_s104["y"], J.gp(_s104["__p"]["W"], "G"))))
	var _t245 = J.cmp(v_i_522, 1.0, "<")
	var _t246 = (_t245 if _t245 else J.cmp(v_j_523, 1.0, "<"))
	var _t247 = (_t246 if _t246 else J.cmp(v_i_522, J.sub(J.gp(_s104["__p"]["W"], "gw"), 1.0), ">="))
	if (_t247 if _t247 else J.cmp(v_j_523, J.sub(J.gp(_s104["__p"]["W"], "gh"), 1.0), ">=")):
		return false
	v_b_525 = (-2.0)
	while true:
		if not J.cmp(v_b_525, 2.0, "<="): break
		v_a_526 = (-2.0)
		while true:
			if not J.cmp(v_a_526, 2.0, "<="): break
			v_k_527 = J.add(J.add(J.mul(J.add(v_j_523, v_b_525), J.gp(_s104["__p"]["W"], "gw")), v_i_522), v_a_526)
			var _t248 = J.gp(J.gp(_s104["__p"]["W"], "blk"), v_k_527)
			if J.t((_t248 if J.t(_t248) else (not J.t(J.gp(J.gp(_s104["__p"]["W"], "seen"), v_k_527))))):
				return false
			v_a_526 = J.num(v_a_526) + 1.0
		v_b_525 = J.num(v_b_525) + 1.0
	if J.t(J.mc(_s104["__p"]["kp"], "some", [Callable(self, "_f80").bind(_s104)])):
		return false
	if J.t(J.mc(_s104["__p"]["out"], "some", [Callable(self, "_f81").bind(_s104)])):
		return false
	v_l_524 = J.gp(_s104["__p"]["__p"]["PGRID"], J.add(J.add(floor(J.num(J.div(_s104["x"], 200.0))), ","), floor(J.num(J.div(_s104["y"], 200.0)))))
	return (not J.t((J.mc(v_l_524, "some", [Callable(self, "_f82").bind(_s104)]) if J.t(v_l_524) else v_l_524)))

func _f83(this_, a: Array, env):
	var v_t_531 = null; var v_a_532 = null; var v_z_533 = null
	v_t_531 = J.arg(a, 0)
	v_a_532 = []
	v_z_533 = 0.0
	while true:
		if not J.cmp(v_z_533, J.mul(env["__p"]["COLS"], env["__p"]["ROWS"]), "<"): break
		var _t249 = env["__p"]["terOf"]
		if J.seq(J.cl(_t249, null, [v_z_533]), v_t_531):
			var _t250 = env["__p"]["zoneCell"]
			J.mc(v_a_532, "push", [J.cl(_t250, null, [v_z_533])])
		v_z_533 = J.num(v_z_533) + 1.0
	return v_a_532

func _f84(this_, a: Array, env):
	var v_cells_534 = null; var v_near_535 = null; var v_n_536 = null; var v_c_537 = null; var v_x_538 = null; var v_y_539 = null
	v_cells_534 = J.arg(a, 0)
	v_near_535 = J.arg(a, 1)
	v_n_536 = 0.0
	while true:
		if not J.cmp(v_n_536, 120.0, "<"): break
		v_c_537 = J.gp(v_cells_534, floor(J.num(J.mul(J.cl(env["rnd"], null, []), J.len(v_cells_534)))))
		v_x_538 = J.add(J.gp(v_c_537, "x"), (J.sub(J.cl(env["rnd"], null, []), 0.5) * J.sub(env["__p"]["CW"], 120.0)))
		v_y_539 = J.add(J.gp(v_c_537, "y"), (J.sub(J.cl(env["rnd"], null, []), 0.5) * J.sub(env["__p"]["CH"], 120.0)))
		var _t251 = env["okAt"]
		if J.t(J.cl(_t251, null, [v_x_538, v_y_539, v_near_535])):
			return {"x": v_x_538, "y": v_y_539}
		v_n_536 = J.num(v_n_536) + 1.0
	return null

func _f85(this_, a: Array, env):
	var v_c_545 = null
	v_c_545 = J.arg(a, 0)
	return J.S_Object_("assign", [{"t": env["t"]}, v_c_545])

func _f86(this_, a: Array, env):
	var v_c_546 = null
	v_c_546 = J.arg(a, 0)
	return J.gp(env["__p"]["TSECRET"], J.gp(v_c_546, "t"))

func _f87(this_, a: Array, env):
	var v_gk_549 = null; var v_n_550 = null; var v_q_551 = null
	v_gk_549 = J.arg(a, 0)
	v_n_550 = J.arg(a, 1)
	var _t258 = env["pick"]
	v_q_551 = J.cl(_t258, null, [(env["secCells"] if J.t(J.mod(v_n_550, 2.0)) else env["all"]), 360.0])
	if J.t(v_q_551):
		var _t259 = env["__p"]["terAtXY"]
		J.mc(env["out"], "push", [{"k": "pg", "id": v_n_550, "gk": v_gk_549, "t": J.cl(_t259, null, [J.gp(v_q_551, "x"), J.gp(v_q_551, "y")]), "x": J.gp(v_q_551, "x"), "y": J.gp(v_q_551, "y")}])

func _f78(this_, a: Array, env):
	var v_ci_508 = null; var v_cellsOf_514 = null; var v_li_516 = null; var v_t_540 = null; var v_cells_541 = null; var v_n_542 = null; var v_q_543 = null; var v_n_547 = null; var v_q_548 = null
	var _s103 = {"__p": env, "W": null, "rnd": null, "out": null, "kp": null, "okAt": null, "pick": null, "all": null, "secCells": null}
	v_ci_508 = J.arg(a, 0)
	_s103["W"] = _s103["__p"]["R0WALK"]
	var _t244 = _s103["__p"]["seeded"]
	_s103["rnd"] = J.cl(_t244, null, [(J.mul(v_ci_508, 97.0) + 7.0)])
	_s103["out"] = []
	_s103["kp"] = J.cl(_s103["__p"]["keyPts"], null, [])
	_s103["okAt"] = Callable(self, "_f79").bind(_s103)
	v_cellsOf_514 = Callable(self, "_f83").bind(_s103)
	_s103["pick"] = Callable(self, "_f84").bind(_s103)
	v_li_516 = 0.0
	v_t_540 = 0.0
	while true:
		if not J.cmp(v_t_540, 9.0, "<"): break
		v_cells_541 = J.cl(v_cellsOf_514, null, [v_t_540])
		v_n_542 = 0.0
		while true:
			if not J.cmp(v_n_542, J.gp(_s103["__p"]["LM_N"], v_t_540), "<"): break
			var _t252 = _s103["pick"]
			v_q_543 = J.cl(_t252, null, [v_cells_541])
			if J.t(v_q_543):
				J.mc(_s103["out"], "push", [{"k": "lm", "id": v_li_516, "t": v_t_540, "x": J.gp(v_q_543, "x"), "y": J.gp(v_q_543, "y"), "name": J.gp(J.gp(_s103["__p"]["LMNAME"], v_ci_508), v_li_516)}])
			v_n_542 = J.num(v_n_542) + 1.0
			v_li_516 = J.num(v_li_516) + 1.0
		v_t_540 = J.num(v_t_540) + 1.0
	_s103["all"] = []
	var _s120 = {"__p": _s103, "t": null}
	_s120["t"] = 0.0
	while true:
		_s120 = _s120.duplicate()
		if not J.cmp(_s120["t"], 9.0, "<"): break
		var _t253 = J.cl(v_cellsOf_514, null, [_s120["t"]])
		J.mc(_s120["__p"]["all"], "push", J.spread([J.SP(J.mc(_t253, "map", [Callable(self, "_f85").bind(_s120)]))]))
		_s120["t"] = J.num(_s120["t"]) + 1.0
	_s103["secCells"] = J.mc(_s103["all"], "filter", [Callable(self, "_f86").bind(_s103)])
	v_n_547 = 0.0
	while true:
		if not J.cmp(v_n_547, 16.0, "<"): break
		var _t254 = _s103["pick"]
		v_q_548 = J.cl(_t254, null, [(_s103["secCells"] if J.cmp(v_n_547, 6.0, "<") else _s103["all"]), 300.0])
		if J.t(v_q_548):
			var _t255 = _s103["__p"]["terAtXY"]
			J.mc(_s103["out"], "push", [{"k": "ca", "id": v_n_547, "t": J.cl(_t255, null, [J.gp(v_q_548, "x"), J.gp(v_q_548, "y")]), "x": J.gp(v_q_548, "x"), "y": J.gp(v_q_548, "y")}])
		v_n_547 = J.num(v_n_547) + 1.0
	var _t256 = _s103["__p"]["pageGhosts"]
	var _t257 = J.cl(_t256, null, [v_ci_508])
	J.mc(_t257, "forEach", [Callable(self, "_f87").bind(_s103)])
	return _s103["out"]

func _f89(this_, a: Array, env):
	var v_f_556 = null; var v_er_557 = null
	v_f_556 = J.arg(a, 0)
	J.cl(v_f_556, null, [env["d"]])

func _f88(this_, a: Array, env):
	var v_e_554 = null
	var _s126 = {"__p": env, "d": null}
	v_e_554 = J.arg(a, 0)
	_s126["d"] = J.arg(a, 1)
	var _t260 = J.gp(_s126["__p"]["HOOK"], v_e_554)
	var _t261 = (_t260 if J.t(_t260) else [])
	J.mc(_t261, "forEach", [Callable(self, "_f89").bind(_s126)])

func _f90(this_, a: Array, env):
	var v_dt_560 = null; var v_me_561 = null; var v_rs_562 = null; var v_digging_563 = null; var v_g_564 = null; var v_to_565 = null; var v_e_566 = null; var v_sp_567 = null; var v_d_568 = null; var v_rew_569 = null; var v_e_570 = null; var v_G_571 = null; var v_sp_572 = null; var v_f_573 = null; var v_n_574 = null; var v_coins_575 = null; var v_box_576 = null
	v_dt_560 = J.arg(a, 0)
	v_me_561 = J.gp(env["R"], "L")
	var _t262 = env["regSt"]
	v_rs_562 = J.cl(_t262, null, [J.gp(env["R"], "ci")])
	for _t263 in J.iter(env["GATES"]):
		v_g_564 = _t263
		var _t264 = J.gp(v_g_564, "sec")
		var _t265 = ((not J.t(J.gp(J.gp(v_rs_562, "sg"), J.gp(v_g_564, "i")))) if J.t(_t264) else _t264)
		if J.t(((J.hypot_([J.sub(J.gp(v_g_564, "x"), J.gp(v_me_561, "x")), J.sub(J.gp(v_g_564, "y"), J.gp(v_me_561, "y"))]) < 300.0) if J.t(_t265) else _t265)):
			var _t266 = J.gp(v_rs_562, "sg")
			var _t267 = J.gp(v_g_564, "i")
			J.sp(_t266, _t267, 1.0)
			var _t268 = env["terAtXY"]
			v_to_565 = (J.gp(v_g_564, "b") if J.seq(J.cl(_t268, null, [J.gp(v_me_561, "x"), J.gp(v_me_561, "y")]), J.gp(v_g_564, "a")) else J.gp(v_g_564, "a"))
			var _t269 = env["msg"]
			var _t270 = env["T"]
			J.cl(_t269, null, [J.cl(_t270, null, [("發現暗路！通往 <b>" + J.str(J.gp(J.gp(env["TNAME"], J.gp(env["R"], "ci")), v_to_565)) + "</b>"), ("發現暗路！通往 <b>" + J.str(J.gp(J.gp(env["TNAME"], J.gp(env["R"], "ci")), v_to_565)) + "</b>")]), 3.0])
			J.mc(J.G.get("Sound"), "play", ["click"])
			J.cl(env["persist"], null, [])
			var _t271 = env["emit"]
			J.cl(_t271, null, ["secret", {"ci": J.gp(env["R"], "ci"), "gate": J.gp(v_g_564, "i"), "to": v_to_565}])
	v_digging_563 = null
	for _t272 in J.iter(J.gp(env["R"], "spots")):
		v_sp_567 = _t272
		v_d_568 = J.hypot_([J.sub(J.gp(v_sp_567, "x"), J.gp(v_me_561, "x")), (J.sub(J.gp(v_sp_567, "y"), J.gp(v_me_561, "y")) * 1.2)])
		var _t273 = J.seq(J.gp(v_sp_567, "k"), "lm")
		var _t274 = ((not J.t(J.gp(J.gp(v_rs_562, "lm"), J.gp(v_sp_567, "id")))) if _t273 else _t273)
		if (J.cmp(v_d_568, 170.0, "<") if _t274 else _t274):
			var _t275 = J.gp(v_rs_562, "lm")
			var _t276 = J.gp(v_sp_567, "id")
			J.sp(_t275, _t276, 1.0)
			v_rew_569 = {"coins": (8.0 + J.mul(J.gp(env["R"], "ci"), 6.0)), "exp": (6.0 + J.mul(J.gp(env["R"], "ci"), 3.0))}
			var _t277 = env["gain"]
			J.cl(_t277, null, [v_rew_569])
			var _t278 = env["revealAround"]
			J.cl(_t278, null, [J.gp(v_sp_567, "x"), J.gp(v_sp_567, "y"), 7.0])
			var _t279 = env["msg"]
			J.cl(_t279, null, [("<b>發現地標：" + J.str(J.gp(v_sp_567, "name")) + "</b>　冥幣 +" + J.str(J.gp(v_rew_569, "coins")) + "　好評 +" + J.str(J.gp(v_rew_569, "exp")) + "　（地標 " + J.str(J.len(J.S_Object_("keys", [J.gp(v_rs_562, "lm")]))) + "/" + J.str(J.len(J.gp(env["LMNAME"], J.gp(env["R"], "ci")))) + "）"), 3.5])
			var _t280 = env["spr"]
			J.cl(_t280, null, ["fx_ring", J.gp(v_sp_567, "x"), J.gp(v_sp_567, "y"), {"ground": true, "s0": 0.2, "s1": 0.9, "life": 0.7, "hue": J.gp(env["HUE"], "lan")}])
			J.mc(J.G.get("Sound"), "play", ["click"])
			J.cl(env["persist"], null, [])
			var _t281 = env["emit"]
			J.cl(_t281, null, ["discover", {"ci": J.gp(env["R"], "ci"), "id": J.gp(v_sp_567, "id"), "name": J.gp(v_sp_567, "name"), "t": J.gp(v_sp_567, "t")}])
		else:
			var _t282 = J.seq(J.gp(v_sp_567, "k"), "pg")
			var _t283 = ((not J.t(J.gp(J.gp(v_rs_562, "pg"), J.gp(v_sp_567, "id")))) if _t282 else _t282)
			if (J.cmp(v_d_568, 70.0, "<") if _t283 else _t283):
				var _t284 = J.gp(v_rs_562, "pg")
				var _t285 = J.gp(v_sp_567, "id")
				J.sp(_t284, _t285, 1.0)
				v_G_571 = J.gp(J.G.get("GHOSTS"), J.gp(v_sp_567, "gk"))
				var _t286 = env["gain"]
				J.cl(_t286, null, [{"exp": (10.0 + J.mul(J.gp(env["R"], "ci"), 4.0))}])
				J.cl(env["persist"], null, [])
				var _t287 = env["emit"]
				J.cl(_t287, null, ["page", {"ci": J.gp(env["R"], "ci"), "id": J.gp(v_sp_567, "id"), "gk": J.gp(v_sp_567, "gk")}])
				var _t288 = env["T"]
				var _t291 = ["旁白", J.cl(_t288, null, [("拾到典籍殘頁・" + J.str(J.gp(v_G_571, "name"))), ("撿到典籍殘頁・" + J.str(J.gp(v_G_571, "name")))])]
				var _t289 = J.G.get("L")
				var _t290 = J.gp(v_G_571, "lore")
				var _t298 = ["旁白", J.cl(_t289, null, [(_t290 if J.t(_t290) else "")])]
				var _t292 = env["T"]
				var _t294 = J.len(J.S_Object_("keys", [J.gp(v_rs_562, "pg")]))
				var _t293 = env["pageGhosts"]
				var _t297 = ("（殘頁 " + J.str(_t294) + "/" + J.str(J.len(J.cl(_t293, null, [J.gp(env["R"], "ci")]))) + "）")
				var _t296 = J.len(J.S_Object_("keys", [J.gp(v_rs_562, "pg")]))
				var _t295 = env["pageGhosts"]
				J.mc(J.G.get("Story"), "queue", [{"style": "narr", "lines": [_t291, _t298, ["旁白", J.cl(_t292, null, [_t297, ("（殘頁 " + J.str(_t296) + "/" + J.str(J.len(J.cl(_t295, null, [J.gp(env["R"], "ci")]))) + "）")])]]}])
			else:
				var _t299 = J.seq(J.gp(v_sp_567, "k"), "ca")
				var _t300 = ((not J.t(J.gp(J.gp(v_rs_562, "ca"), J.gp(v_sp_567, "id")))) if _t299 else _t299)
				if (J.cmp(v_d_568, 60.0, "<") if _t300 else _t300):
					v_digging_563 = v_sp_567
	var _t307 = v_digging_563
	if J.t(_t307):
		var _t301 = J.gp(v_me_561, "vx")
		var _t303 = (_t301 if J.t(_t301) else 0.0)
		var _t302 = J.gp(v_me_561, "vy")
		var _t304 = J.gp(v_me_561, "vx")
		var _t306 = (_t304 if J.t(_t304) else 0.0)
		var _t305 = J.gp(v_me_561, "vy")
		_t307 = (J.hypot_([_t306, (_t305 if J.t(_t305) else 0.0)]) < 60.0)
	if J.t(_t307):
		var _t308 = env["R"]
		var _t309 = J.gp(env["R"], "dig")
		var _t310 = (J.gp(env["R"], "dig") if J.t((J.seq(J.gp(J.gp(env["R"], "dig"), "sp"), v_digging_563) if J.t(_t309) else _t309)) else {"sp": v_digging_563, "t": 0.0})
		J.sp(_t308, "dig", _t310)
		var _t311 = J.gp(env["R"], "dig")
		var _t312 = J.add(J.gp(_t311, "t"), v_dt_560)
		J.sp(_t311, "t", _t312)
		if J.cmp(J.gp(J.gp(env["R"], "dig"), "t"), 1.3, ">"):
			v_sp_572 = v_digging_563
			var _t313 = J.gp(v_rs_562, "ca")
			var _t314 = J.gp(v_sp_572, "id")
			J.sp(_t313, _t314, 1.0)
			var _t315 = env["R"]
			J.sp(_t315, "dig", null)
			v_f_573 = J.gp(J.S_Object_("keys", [env["FAC"]]), J.mod(J.gp(v_sp_572, "id"), 3.0))
			v_n_574 = ((3.0 + floor(J.num((randf() * 4.0)))) + J.mul(J.gp(env["R"], "ci"), 2.0))
			v_coins_575 = (15.0 + J.mul(J.gp(env["R"], "ci"), 12.0))
			v_box_576 = (randf() < 0.18)
			var _t316 = J.gp(env["R"], "loot")
			var _t317 = J.add(J.gp(_t316, v_f_573), v_n_574)
			J.sp(_t316, v_f_573, _t317)
			var _t318 = J.gp(J.cl(env["st"], null, []), "mats")
			var _t319 = J.add(J.gp(_t318, v_f_573), v_n_574)
			J.sp(_t318, v_f_573, _t319)
			var _t320 = env["gain"]
			J.cl(_t320, null, [{"coins": v_coins_575}])
			if J.t(v_box_576):
				var _t321 = J.gp(J.G.get("S"), "chests")
				J.sp(_t321, "b", J.num(J.gp(_t321, "b")) + 1.0)
			var _t322 = env["msg"]
			J.cl(_t322, null, [("挖到埋咗嘅嘢：" + J.str(J.gp(J.gp(env["FAC"], v_f_573), "mat")) + " +" + J.str(v_n_574) + "　冥幣 +" + J.str(v_coins_575) + ("　<b>藍箱 ×1</b>" if J.t(v_box_576) else "")), 3.0])
			var _t323 = env["dust"]
			J.cl(_t323, null, [J.gp(v_sp_572, "x"), J.gp(v_sp_572, "y"), 1.5])
			var _t324 = env["spr"]
			J.cl(_t324, null, ["fx_gold", J.gp(v_sp_572, "x"), J.sub(J.gp(v_sp_572, "y"), 30.0), {"s0": 0.2, "s1": 0.6, "life": 0.8}])
			J.cl(env["persist"], null, [])
			var _t325 = env["emit"]
			J.cl(_t325, null, ["cache", {"ci": J.gp(env["R"], "ci"), "id": J.gp(v_sp_572, "id")}])
	else:
		if J.t(J.gp(env["R"], "dig")):
			var _t326 = env["R"]
			J.sp(_t326, "dig", null)

func _f91(this_, a: Array, env):
	var v_c_579 = null; var v_cx_580 = null; var v_cy_581 = null; var v_vw_582 = null; var v_vh_583 = null; var v_rs_584 = null; var v_L_585 = null; var v_sp_586 = null; var v_x_587 = null; var v_y_588 = null; var v_found_589 = null; var v_txt_590 = null; var v_tw_591 = null; var v_a_592 = null; var v_g_593 = null; var v_d_594 = null; var v_i_595 = null; var v_ph_596 = null; var v_a_597 = null; var v_px_598 = null; var v_py_599 = null; var v_bob_600 = null; var v_g_601 = null; var v_i_602 = null
	v_c_579 = J.arg(a, 0)
	v_cx_580 = J.arg(a, 1)
	v_cy_581 = J.arg(a, 2)
	v_vw_582 = J.arg(a, 3)
	v_vh_583 = J.arg(a, 4)
	var _t327 = env["regSt"]
	v_rs_584 = J.cl(_t327, null, [J.gp(env["R"], "ci")])
	v_L_585 = J.gp(env["R"], "L")
	for _t328 in J.iter(J.gp(env["R"], "spots")):
		v_sp_586 = _t328
		var _t329 = J.cmp(J.gp(v_sp_586, "x"), J.sub(v_cx_580, 120.0), "<")
		var _t330 = (_t329 if _t329 else J.cmp(J.gp(v_sp_586, "x"), J.add(J.add(v_cx_580, v_vw_582), 120.0), ">"))
		var _t331 = (_t330 if _t330 else J.cmp(J.gp(v_sp_586, "y"), J.sub(v_cy_581, 60.0), "<"))
		if (_t331 if _t331 else J.cmp(J.gp(v_sp_586, "y"), J.add(J.add(v_cy_581, v_vh_583), 160.0), ">")):
			continue
		v_x_587 = J.gp(v_sp_586, "x")
		v_y_588 = J.gp(v_sp_586, "y")
		if J.seq(J.gp(v_sp_586, "k"), "lm"):
			v_found_589 = (not (not J.t(J.gp(J.gp(v_rs_584, "lm"), J.gp(v_sp_586, "id")))))
			J.mc(v_c_579, "save", [])
			if (not J.t(v_found_589)):
				v_a_592 = (0.25 + (0.15 * sin(J.num(J.add(J.mul(J.gp(env["R"], "t"), 2.0), J.gp(v_sp_586, "id"))))))
				J.sp(v_c_579, "globalCompositeOperation", "lighter")
				v_g_593 = J.mc(v_c_579, "createLinearGradient", [v_x_587, J.sub(v_y_588, 140.0), v_x_587, v_y_588])
				J.mc(v_g_593, "addColorStop", [0.0, "rgba(120,200,255,0)"])
				J.mc(v_g_593, "addColorStop", [1.0, ("rgba(120,200,255," + J.str(v_a_592) + ")")])
				J.sp(v_c_579, "fillStyle", v_g_593)
				J.mc(v_c_579, "fillRect", [J.sub(v_x_587, 10.0), J.sub(v_y_588, 140.0), 20.0, 140.0])
				J.sp(v_c_579, "globalCompositeOperation", "source-over")
			J.sp(v_c_579, "fillStyle", "rgba(0,0,0,.35)")
			J.mc(v_c_579, "beginPath", [])
			J.mc(v_c_579, "ellipse", [v_x_587, v_y_588, 20.0, 6.0, 0.0, 0.0, 7.0])
			J.mc(v_c_579, "fill", [])
			J.sp(v_c_579, "fillStyle", "#3a2a1c")
			J.sp(v_c_579, "strokeStyle", "#120a06")
			J.sp(v_c_579, "lineWidth", 2.0)
			J.mc(v_c_579, "fillRect", [J.sub(v_x_587, 3.0), J.sub(v_y_588, 58.0), 6.0, 58.0])
			J.mc(v_c_579, "strokeRect", [J.sub(v_x_587, 3.0), J.sub(v_y_588, 58.0), 6.0, 58.0])
			var _t332 = "900 13px \"PingFang TC\",\"Noto Sans TC\",sans-serif"
			J.sp(v_c_579, "font", _t332)
			v_txt_590 = (J.gp(v_sp_586, "name") if J.t(v_found_589) else "？")
			v_tw_591 = J.max_([34.0, J.add(J.gp(J.mc(v_c_579, "measureText", [v_txt_590]), "width"), 18.0)])
			var _t333 = ("#d9c79c" if J.t(v_found_589) else "#6d6252")
			J.sp(v_c_579, "fillStyle", _t333)
			J.mc(v_c_579, "beginPath", [])
			J.mc(v_c_579, "moveTo", [J.sub(v_x_587, J.div(v_tw_591, 2.0)), J.sub(v_y_588, 66.0)])
			J.mc(v_c_579, "lineTo", [J.sub(J.add(v_x_587, J.div(v_tw_591, 2.0)), 6.0), J.sub(v_y_588, 66.0)])
			J.mc(v_c_579, "lineTo", [J.add(J.add(v_x_587, J.div(v_tw_591, 2.0)), 4.0), J.sub(v_y_588, 56.0)])
			J.mc(v_c_579, "lineTo", [J.sub(J.add(v_x_587, J.div(v_tw_591, 2.0)), 6.0), J.sub(v_y_588, 46.0)])
			J.mc(v_c_579, "lineTo", [J.sub(v_x_587, J.div(v_tw_591, 2.0)), J.sub(v_y_588, 46.0)])
			J.mc(v_c_579, "closePath", [])
			J.mc(v_c_579, "fill", [])
			J.mc(v_c_579, "stroke", [])
			var _t334 = ("#3a1a10" if J.t(v_found_589) else "#e8dcc0")
			J.sp(v_c_579, "fillStyle", _t334)
			J.sp(v_c_579, "textAlign", "center")
			J.mc(v_c_579, "fillText", [v_txt_590, v_x_587, J.sub(v_y_588, 51.0)])
			J.mc(v_c_579, "restore", [])
		else:
			var _t335 = J.seq(J.gp(v_sp_586, "k"), "ca")
			if ((not J.t(J.gp(J.gp(v_rs_584, "ca"), J.gp(v_sp_586, "id")))) if _t335 else _t335):
				v_d_594 = J.hypot_([J.sub(J.gp(v_sp_586, "x"), J.gp(v_L_585, "x")), J.sub(J.gp(v_sp_586, "y"), J.gp(v_L_585, "y"))])
				if J.cmp(v_d_594, 280.0, ">"):
					continue
				J.mc(v_c_579, "save", [])
				J.sp(v_c_579, "fillStyle", "rgba(60,46,36,.85)")
				J.mc(v_c_579, "beginPath", [])
				J.mc(v_c_579, "ellipse", [v_x_587, v_y_588, 22.0, 9.0, 0.0, 0.0, 7.0])
				J.mc(v_c_579, "fill", [])
				J.sp(v_c_579, "strokeStyle", "rgba(20,14,10,.8)")
				J.sp(v_c_579, "lineWidth", 1.5)
				J.mc(v_c_579, "stroke", [])
				J.sp(v_c_579, "globalCompositeOperation", "lighter")
				v_i_595 = 0.0
				while true:
					if not J.cmp(v_i_595, 3.0, "<"): break
					v_ph_596 = J.mod(((J.mul(J.gp(env["R"], "t"), 1.3) + J.mul(v_i_595, 0.33)) + J.mul(J.gp(v_sp_586, "id"), 0.1)), 1.0)
					v_a_597 = sin(J.num(J.mul(v_ph_596, PI)))
					var _t336 = ("rgba(255,236,170," + J.str(J.mul(0.8, v_a_597)) + ")")
					J.sp(v_c_579, "fillStyle", _t336)
					v_px_598 = J.add(v_x_587, (sin(J.num(J.add(J.mul(v_i_595, 2.1), J.gp(v_sp_586, "id")))) * 14.0))
					v_py_599 = (J.sub(v_y_588, 4.0) - J.mul(v_ph_596, 10.0))
					J.mc(v_c_579, "fillRect", [J.sub(v_px_598, 1.0), J.sub(v_py_599, 4.0), 2.0, 8.0])
					J.mc(v_c_579, "fillRect", [J.sub(v_px_598, 4.0), J.sub(v_py_599, 1.0), 8.0, 2.0])
					v_i_595 = J.num(v_i_595) + 1.0
				var _t337 = J.gp(env["R"], "dig")
				if J.t((J.seq(J.gp(J.gp(env["R"], "dig"), "sp"), v_sp_586) if J.t(_t337) else _t337)):
					J.sp(v_c_579, "globalCompositeOperation", "source-over")
					J.sp(v_c_579, "strokeStyle", "#ffe9a0")
					J.sp(v_c_579, "lineWidth", 4.0)
					J.mc(v_c_579, "beginPath", [])
					J.mc(v_c_579, "arc", [v_x_587, J.sub(v_y_588, 40.0), 14.0, J.div((-PI), 2.0), (J.div((-PI), 2.0) + ((PI * 2.0) * J.min_([1.0, J.div(J.gp(J.gp(env["R"], "dig"), "t"), 1.3)])))])
					J.mc(v_c_579, "stroke", [])
				J.mc(v_c_579, "restore", [])
			else:
				var _t338 = J.seq(J.gp(v_sp_586, "k"), "pg")
				if ((not J.t(J.gp(J.gp(v_rs_584, "pg"), J.gp(v_sp_586, "id")))) if _t338 else _t338):
					v_bob_600 = (sin(J.num(J.add(J.mul(J.gp(env["R"], "t"), 2.4), J.gp(v_sp_586, "id")))) * 5.0)
					J.mc(v_c_579, "save", [])
					J.sp(v_c_579, "globalCompositeOperation", "lighter")
					v_g_601 = J.mc(v_c_579, "createRadialGradient", [v_x_587, J.add(J.sub(v_y_588, 30.0), v_bob_600), 0.0, v_x_587, J.add(J.sub(v_y_588, 30.0), v_bob_600), 40.0])
					J.mc(v_g_601, "addColorStop", [0.0, "rgba(200,255,220,.45)"])
					J.mc(v_g_601, "addColorStop", [1.0, "rgba(120,255,180,0)"])
					J.sp(v_c_579, "fillStyle", v_g_601)
					J.mc(v_c_579, "beginPath", [])
					J.mc(v_c_579, "arc", [v_x_587, J.add(J.sub(v_y_588, 30.0), v_bob_600), 40.0, 0.0, 7.0])
					J.mc(v_c_579, "fill", [])
					J.sp(v_c_579, "globalCompositeOperation", "source-over")
					J.mc(v_c_579, "translate", [v_x_587, J.add(J.sub(v_y_588, 30.0), v_bob_600)])
					J.mc(v_c_579, "rotate", [(sin(J.num(J.add(J.mul(J.gp(env["R"], "t"), 1.7), J.gp(v_sp_586, "id")))) * 0.2)])
					J.sp(v_c_579, "fillStyle", "#e9e0c6")
					J.sp(v_c_579, "strokeStyle", "#3a2c1c")
					J.sp(v_c_579, "lineWidth", 1.5)
					J.mc(v_c_579, "fillRect", [(-9.0), (-12.0), 18.0, 24.0])
					J.mc(v_c_579, "strokeRect", [(-9.0), (-12.0), 18.0, 24.0])
					J.sp(v_c_579, "strokeStyle", "rgba(60,40,30,.6)")
					J.sp(v_c_579, "lineWidth", 1.0)
					v_i_602 = 0.0
					while true:
						if not J.cmp(v_i_602, 4.0, "<"): break
						J.mc(v_c_579, "beginPath", [])
						J.mc(v_c_579, "moveTo", [((-5.0) + J.mul(v_i_602, 3.3)), (-8.0)])
						J.mc(v_c_579, "lineTo", [((-5.0) + J.mul(v_i_602, 3.3)), 8.0])
						J.mc(v_c_579, "stroke", [])
						v_i_602 = J.num(v_i_602) + 1.0
					J.mc(v_c_579, "restore", [])

func _f93(this_, a: Array, env):
	var v_f_610 = null
	v_f_610 = J.arg(a, 0)
	return J.seq(J.gp(v_f_610, "t"), "station")

func _f94(this_, a: Array, env):
	var v_f_611 = null; var v_q_612 = null
	v_f_611 = J.arg(a, 0)
	var _t343 = env["faciPos"]
	v_q_612 = J.cl(_t343, null, [v_f_611])
	return {"x": J.add(J.gp(v_q_612, "x"), 60.0), "y": J.add(J.gp(v_q_612, "y"), 60.0)}

func _f95(this_, a: Array, env):
	var v_g_613 = null
	v_g_613 = J.arg(a, 0)
	return {"x": J.gp(v_g_613, "x"), "y": J.gp(v_g_613, "y")}

func _f96(this_, a: Array, env):
	var v_a_620 = null
	v_a_620 = J.arg(a, 0)
	return (J.hypot_([J.sub(J.gp(v_a_620, "x"), env["x"]), J.sub(J.gp(v_a_620, "y"), env["y"])]) < (190.0 if J.t(env["big"]) else 150.0))

func _f97(this_, a: Array, env):
	var v_o_621 = null
	v_o_621 = J.arg(a, 0)
	var _t348 = J.hypot_([J.sub(J.gp(v_o_621, "x"), env["x"]), (J.sub(J.gp(v_o_621, "y"), env["y"]) * 1.4)])
	var _t347 = J.gp(env["__p"]["SOLID"], J.gp(v_o_621, "t"))
	return (_t348 < (120.0 if J.t((_t347 if J.t(_t347) else env["big"])) else 70.0))

func _f98(this_, a: Array, env):
	var v_o_622 = null; var v_k_623 = null
	v_o_622 = J.arg(a, 0)
	if (not J.t(J.gp(v_o_622, "r"))):
		return null
	v_k_623 = J.add(J.add(floor(J.num(J.div(J.gp(v_o_622, "x"), 200.0))), ","), floor(J.num(J.div(J.gp(v_o_622, "y"), 200.0))))
	var _t349 = env["PGRID"]
	var _t350 = J.gp(env["PGRID"], v_k_623)
	var _t351 = (_t350 if J.t(_t350) else [])
	J.sp(_t349, v_k_623, _t351)
	J.mc(_t351, "push", [v_o_622])

func _f92(this_, a: Array, env):
	var v_ci_605 = null; var v_rnd_606 = null; var v_out_607 = null; var v_rg_608 = null; var v_avoid_609 = null; var v_i_614 = null; var v_t_617 = null; var v_sc_618 = null
	v_ci_605 = J.arg(a, 0)
	var _t339 = {}
	env["PGRID"] = _t339
	var _t340 = env["mkWalls"]
	J.cl(_t340, null, [v_ci_605])
	var _t341 = env["seeded"]
	v_rnd_606 = J.cl(_t341, null, [(J.mul(v_ci_605, 31.0) + 3.0)])
	v_out_607 = []
	v_rg_608 = J.gp(env["REG"], v_ci_605)
	var _t344 = J.mc(env["FACI"], "map", [env["faciPos"]])
	var _t342 = J.mc(env["FACI"], "filter", [Callable(self, "_f93").bind(env)])
	v_avoid_609 = J.spread([J.SP(_t344), J.SP(J.mc(_t342, "map", [Callable(self, "_f94").bind(env)])), J.SP(J.mc(env["GATES"], "map", [Callable(self, "_f95").bind(env)])), J.SP(J.mc(env["TALL"], "map", [env["lairPos"]]))])
	v_i_614 = 0.0
	while true:
		var _t345 = J.cmp(v_i_614, 3200.0, "<")
		if not ((J.len(v_out_607) < 1350.0) if _t345 else _t345): break
		var _s163 = {"__p": env, "x": null, "y": null, "big": null}
		_s163["x"] = (40.0 + J.mul(J.cl(v_rnd_606, null, []), J.sub(_s163["__p"]["WW"], 80.0)))
		_s163["y"] = (40.0 + J.mul(J.cl(v_rnd_606, null, []), J.sub(_s163["__p"]["WH"], 80.0)))
		v_t_617 = J.gp(J.gp(v_rg_608, "props"), floor(J.num(J.mul(J.cl(v_rnd_606, null, []), J.len(J.gp(v_rg_608, "props"))))))
		v_sc_618 = (0.75 + J.mul(J.cl(v_rnd_606, null, []), 0.5))
		_s163["big"] = (1.0 if J.t(J.gp(_s163["__p"]["SOLID"], v_t_617)) else 0.0)
		if J.t(J.mc(v_avoid_609, "some", [Callable(self, "_f96").bind(_s163)])):
			v_i_614 = J.num(v_i_614) + 1.0
			continue
		var _t346 = _s163["__p"]["blockedAt"]
		if J.t(J.cl(_t346, null, [_s163["x"], _s163["y"], (80.0 if J.t(_s163["big"]) else 56.0)])):
			v_i_614 = J.num(v_i_614) + 1.0
			continue
		if J.t(J.mc(v_out_607, "some", [Callable(self, "_f97").bind(_s163)])):
			v_i_614 = J.num(v_i_614) + 1.0
			continue
		J.mc(v_out_607, "push", [{"x": _s163["x"], "y": _s163["y"], "t": v_t_617, "s": v_sc_618, "v": J.cl(v_rnd_606, null, []), "r": (J.mul(J.gp(_s163["__p"]["SOLID"], v_t_617), v_sc_618) if J.t(J.gp(_s163["__p"]["SOLID"], v_t_617)) else 0.0)}])
		v_i_614 = J.num(v_i_614) + 1.0
	J.mc(v_out_607, "forEach", [Callable(self, "_f98").bind(env)])
	return v_out_607

func _f100(this_, a: Array, env):
	var v_w_633 = null
	v_w_633 = J.arg(a, 0)
	var _t354 = env["c"]
	J.sp(_t354, "fillStyle", "rgba(0,0,0,.35)")
	J.mc(env["c"], "beginPath", [])
	J.mc(env["c"], "ellipse", [env["x"], J.add(env["y"], 2.0), J.mul(v_w_633, env["s"]), J.mul(J.mul(v_w_633, 0.32), env["s"]), 0.0, 0.0, 7.0])
	J.mc(env["c"], "fill", [])

func _f99(this_, a: Array, env):
	var v_p_627 = null; var v_ink_631 = null; var v_shadow_632 = null; var v_i_634 = null; var v_g_635 = null; var v_i_636 = null; var v_a_637 = null; var v_dx_638 = null; var v_g_639 = null
	var _s167 = {"__p": env, "c": null, "s": null, "x": null, "y": null}
	_s167["c"] = J.arg(a, 0)
	v_p_627 = J.arg(a, 1)
	_s167["s"] = J.gp(v_p_627, "s")
	_s167["x"] = J.gp(v_p_627, "x")
	_s167["y"] = J.gp(v_p_627, "y")
	J.mc(_s167["c"], "save", [])
	var _t352 = _s167["c"]
	J.sp(_t352, "lineCap", "round")
	var _t353 = _s167["c"]
	J.sp(_t353, "lineJoin", "round")
	v_ink_631 = "rgba(10,8,12,.85)"
	v_shadow_632 = Callable(self, "_f100").bind(_s167)
	var _t355 = J.gp(v_p_627, "t")
	var _t356 = -1
	var _t357 = false
	if _t356 == -1 and J.seq(_t355, "tomb"): _t356 = 0
	if _t356 == -1 and J.seq(_t355, "tree"): _t356 = 1
	if _t356 == -1 and J.seq(_t355, "grass"): _t356 = 2
	if _t356 == -1 and J.seq(_t355, "rock"): _t356 = 3
	if _t356 == -1 and J.seq(_t355, "lantern"): _t356 = 4
	if _t356 == -1 and J.seq(_t355, "palm"): _t356 = 5
	if _t356 == -1 and J.seq(_t355, "banana"): _t356 = 6
	if _t356 == -1 and J.seq(_t355, "stilt"): _t356 = 7
	if _t356 == -1 and J.seq(_t355, "lamp"): _t356 = 8
	if _t356 == -1 and J.seq(_t355, "cart"): _t356 = 9
	if _t356 == -1 and J.seq(_t355, "cone"): _t356 = 10
	if _t356 == -1 and J.seq(_t355, "pillar"): _t356 = 11
	if _t356 == -1 and J.seq(_t355, "desk"): _t356 = 13
	if _t356 == -1: _t356 = 12
	while true:
		if _t356 <= 0 and _t356 >= 0:
			J.cl(v_shadow_632, null, [20.0])
			var _t358 = _s167["c"]
			J.sp(_t358, "fillStyle", "#5a5650")
			var _t359 = _s167["c"]
			J.sp(_t359, "strokeStyle", v_ink_631)
			var _t360 = _s167["c"]
			J.sp(_t360, "lineWidth", 2.2)
			J.mc(_s167["c"], "beginPath", [])
			J.mc(_s167["c"], "moveTo", [J.sub(_s167["x"], J.mul(14.0, _s167["s"])), _s167["y"]])
			J.mc(_s167["c"], "lineTo", [J.sub(_s167["x"], J.mul(14.0, _s167["s"])), J.sub(_s167["y"], J.mul(26.0, _s167["s"]))])
			J.mc(_s167["c"], "quadraticCurveTo", [_s167["x"], J.sub(_s167["y"], J.mul(40.0, _s167["s"])), J.add(_s167["x"], J.mul(14.0, _s167["s"])), J.sub(_s167["y"], J.mul(26.0, _s167["s"]))])
			J.mc(_s167["c"], "lineTo", [J.add(_s167["x"], J.mul(14.0, _s167["s"])), _s167["y"]])
			J.mc(_s167["c"], "closePath", [])
			J.mc(_s167["c"], "fill", [])
			J.mc(_s167["c"], "stroke", [])
			var _t361 = _s167["c"]
			J.sp(_t361, "strokeStyle", "rgba(200,190,170,.4)")
			var _t362 = _s167["c"]
			J.sp(_t362, "lineWidth", 1.3)
			J.mc(_s167["c"], "beginPath", [])
			J.mc(_s167["c"], "moveTo", [J.sub(_s167["x"], J.mul(5.0, _s167["s"])), J.sub(_s167["y"], J.mul(24.0, _s167["s"]))])
			J.mc(_s167["c"], "lineTo", [J.add(_s167["x"], J.mul(5.0, _s167["s"])), J.sub(_s167["y"], J.mul(24.0, _s167["s"]))])
			J.mc(_s167["c"], "moveTo", [_s167["x"], J.sub(_s167["y"], J.mul(30.0, _s167["s"]))])
			J.mc(_s167["c"], "lineTo", [_s167["x"], J.sub(_s167["y"], J.mul(10.0, _s167["s"]))])
			J.mc(_s167["c"], "stroke", [])
			break
		if _t356 <= 1 and _t356 >= 0:
			J.cl(v_shadow_632, null, [26.0])
			var _t363 = _s167["c"]
			J.sp(_t363, "strokeStyle", "#2a211b")
			var _t364 = _s167["c"]
			var _t365 = J.mul(5.0, _s167["s"])
			J.sp(_t364, "lineWidth", _t365)
			J.mc(_s167["c"], "beginPath", [])
			J.mc(_s167["c"], "moveTo", [_s167["x"], _s167["y"]])
			J.mc(_s167["c"], "lineTo", [J.add(_s167["x"], J.mul(2.0, _s167["s"])), J.sub(_s167["y"], J.mul(40.0, _s167["s"]))])
			J.mc(_s167["c"], "moveTo", [J.add(_s167["x"], J.mul(1.0, _s167["s"])), J.sub(_s167["y"], J.mul(26.0, _s167["s"]))])
			J.mc(_s167["c"], "lineTo", [J.sub(_s167["x"], J.mul(16.0, _s167["s"])), J.sub(_s167["y"], J.mul(50.0, _s167["s"]))])
			J.mc(_s167["c"], "moveTo", [J.add(_s167["x"], J.mul(2.0, _s167["s"])), J.sub(_s167["y"], J.mul(36.0, _s167["s"]))])
			J.mc(_s167["c"], "lineTo", [J.add(_s167["x"], J.mul(18.0, _s167["s"])), J.sub(_s167["y"], J.mul(56.0, _s167["s"]))])
			J.mc(_s167["c"], "stroke", [])
			var _t366 = _s167["c"]
			var _t367 = J.mul(2.4, _s167["s"])
			J.sp(_t366, "lineWidth", _t367)
			J.mc(_s167["c"], "beginPath", [])
			J.mc(_s167["c"], "moveTo", [J.sub(_s167["x"], J.mul(10.0, _s167["s"])), J.sub(_s167["y"], J.mul(42.0, _s167["s"]))])
			J.mc(_s167["c"], "lineTo", [J.sub(_s167["x"], J.mul(20.0, _s167["s"])), J.sub(_s167["y"], J.mul(44.0, _s167["s"]))])
			J.mc(_s167["c"], "moveTo", [J.add(_s167["x"], J.mul(12.0, _s167["s"])), J.sub(_s167["y"], J.mul(48.0, _s167["s"]))])
			J.mc(_s167["c"], "lineTo", [J.add(_s167["x"], J.mul(24.0, _s167["s"])), J.sub(_s167["y"], J.mul(50.0, _s167["s"]))])
			J.mc(_s167["c"], "stroke", [])
			break
		if _t356 <= 2 and _t356 >= 0:
			var _t368 = _s167["c"]
			var _t369 = ("#3c4a2c" if J.cmp(J.gp(v_p_627, "v"), 0.5, ">") else "#4a4430")
			J.sp(_t368, "strokeStyle", _t369)
			var _t370 = _s167["c"]
			J.sp(_t370, "lineWidth", 1.6)
			J.mc(_s167["c"], "beginPath", [])
			v_i_634 = (-3.0)
			while true:
				if not J.cmp(v_i_634, 3.0, "<="): break
				J.mc(_s167["c"], "moveTo", [J.add(_s167["x"], J.mul(J.mul(v_i_634, 3.0), _s167["s"])), _s167["y"]])
				J.mc(_s167["c"], "lineTo", [J.add(J.add(_s167["x"], J.mul(J.mul(v_i_634, 4.5), _s167["s"])), (J.sub(J.gp(v_p_627, "v"), 0.5) * 6.0)), J.sub(_s167["y"], J.mul(((8.0 + (absf(J.num(v_i_634)) * (-1.0))) + 6.0), _s167["s"]))])
				v_i_634 = J.num(v_i_634) + 1.0
			J.mc(_s167["c"], "stroke", [])
			break
		if _t356 <= 3 and _t356 >= 0:
			J.cl(v_shadow_632, null, [16.0])
			var _t371 = _s167["c"]
			J.sp(_t371, "fillStyle", "#3e3b3a")
			var _t372 = _s167["c"]
			J.sp(_t372, "strokeStyle", v_ink_631)
			var _t373 = _s167["c"]
			J.sp(_t373, "lineWidth", 2.0)
			J.mc(_s167["c"], "beginPath", [])
			J.mc(_s167["c"], "moveTo", [J.sub(_s167["x"], J.mul(15.0, _s167["s"])), _s167["y"]])
			J.mc(_s167["c"], "lineTo", [J.sub(_s167["x"], J.mul(10.0, _s167["s"])), J.sub(_s167["y"], J.mul(12.0, _s167["s"]))])
			J.mc(_s167["c"], "lineTo", [J.add(_s167["x"], J.mul(4.0, _s167["s"])), J.sub(_s167["y"], J.mul(15.0, _s167["s"]))])
			J.mc(_s167["c"], "lineTo", [J.add(_s167["x"], J.mul(15.0, _s167["s"])), J.sub(_s167["y"], J.mul(4.0, _s167["s"]))])
			J.mc(_s167["c"], "lineTo", [J.add(_s167["x"], J.mul(12.0, _s167["s"])), _s167["y"]])
			J.mc(_s167["c"], "closePath", [])
			J.mc(_s167["c"], "fill", [])
			J.mc(_s167["c"], "stroke", [])
			break
		if _t356 <= 4 and _t356 >= 0:
			J.cl(v_shadow_632, null, [8.0])
			var _t374 = _s167["c"]
			J.sp(_t374, "strokeStyle", "#2a211b")
			var _t375 = _s167["c"]
			J.sp(_t375, "lineWidth", 2.5)
			J.mc(_s167["c"], "beginPath", [])
			J.mc(_s167["c"], "moveTo", [_s167["x"], _s167["y"]])
			J.mc(_s167["c"], "lineTo", [_s167["x"], J.sub(_s167["y"], J.mul(40.0, _s167["s"]))])
			J.mc(_s167["c"], "lineTo", [J.add(_s167["x"], J.mul(10.0, _s167["s"])), J.sub(_s167["y"], J.mul(40.0, _s167["s"]))])
			J.mc(_s167["c"], "stroke", [])
			v_g_635 = J.mc(_s167["c"], "createRadialGradient", [J.add(_s167["x"], J.mul(10.0, _s167["s"])), J.sub(_s167["y"], J.mul(32.0, _s167["s"])), 2.0, J.add(_s167["x"], J.mul(10.0, _s167["s"])), J.sub(_s167["y"], J.mul(32.0, _s167["s"])), J.mul(34.0, _s167["s"])])
			J.mc(v_g_635, "addColorStop", [0.0, "rgba(255,90,60,.4)"])
			J.mc(v_g_635, "addColorStop", [1.0, "rgba(255,90,60,0)"])
			var _t376 = _s167["c"]
			J.sp(_t376, "fillStyle", v_g_635)
			J.mc(_s167["c"], "fillRect", [J.sub(_s167["x"], J.mul(30.0, _s167["s"])), J.sub(_s167["y"], J.mul(70.0, _s167["s"])), J.mul(80.0, _s167["s"]), J.mul(76.0, _s167["s"])])
			var _t377 = _s167["c"]
			J.sp(_t377, "fillStyle", "#c8402c")
			J.mc(_s167["c"], "beginPath", [])
			J.mc(_s167["c"], "ellipse", [J.add(_s167["x"], J.mul(10.0, _s167["s"])), J.sub(_s167["y"], J.mul(32.0, _s167["s"])), J.mul(6.0, _s167["s"]), J.mul(8.0, _s167["s"]), 0.0, 0.0, 7.0])
			J.mc(_s167["c"], "fill", [])
			var _t378 = _s167["c"]
			J.sp(_t378, "strokeStyle", v_ink_631)
			var _t379 = _s167["c"]
			J.sp(_t379, "lineWidth", 1.5)
			J.mc(_s167["c"], "stroke", [])
			break
		if _t356 <= 5 and _t356 >= 0:
			pass
		if _t356 <= 6 and _t356 >= 0:
			J.cl(v_shadow_632, null, [24.0])
			var _t380 = _s167["c"]
			J.sp(_t380, "strokeStyle", "#3a2c1c")
			var _t381 = _s167["c"]
			var _t382 = J.mul(4.0, _s167["s"])
			J.sp(_t381, "lineWidth", _t382)
			J.mc(_s167["c"], "beginPath", [])
			J.mc(_s167["c"], "moveTo", [_s167["x"], _s167["y"]])
			J.mc(_s167["c"], "quadraticCurveTo", [J.add(_s167["x"], J.mul(6.0, _s167["s"])), J.sub(_s167["y"], J.mul(30.0, _s167["s"])), J.add(_s167["x"], J.mul(2.0, _s167["s"])), J.sub(_s167["y"], J.mul(52.0, _s167["s"]))])
			J.mc(_s167["c"], "stroke", [])
			var _t383 = _s167["c"]
			var _t384 = ("#2d4a26" if J.seq(J.gp(v_p_627, "t"), "banana") else "#33402a")
			J.sp(_t383, "strokeStyle", _t384)
			var _t385 = _s167["c"]
			var _t386 = J.mul((7.0 if J.seq(J.gp(v_p_627, "t"), "banana") else 3.5), _s167["s"])
			J.sp(_t385, "lineWidth", _t386)
			J.mc(_s167["c"], "beginPath", [])
			v_i_636 = 0.0
			while true:
				if not J.cmp(v_i_636, 5.0, "<"): break
				v_a_637 = (J.div((-PI), 2.0) + (J.sub(v_i_636, 2.0) * 0.7))
				J.mc(_s167["c"], "moveTo", [J.add(_s167["x"], J.mul(2.0, _s167["s"])), J.sub(_s167["y"], J.mul(52.0, _s167["s"]))])
				J.mc(_s167["c"], "quadraticCurveTo", [J.add(J.add(_s167["x"], J.mul(2.0, _s167["s"])), J.mul((cos(J.num(v_a_637)) * 18.0), _s167["s"])), ((J.sub(_s167["y"], J.mul(52.0, _s167["s"])) + J.mul((sin(J.num(v_a_637)) * 18.0), _s167["s"])) - J.mul(6.0, _s167["s"])), J.add(J.add(_s167["x"], J.mul(2.0, _s167["s"])), J.mul((cos(J.num(v_a_637)) * 30.0), _s167["s"])), ((J.sub(_s167["y"], J.mul(50.0, _s167["s"])) + J.mul((sin(J.num(v_a_637)) * 26.0), _s167["s"])) + J.mul(14.0, _s167["s"]))])
				v_i_636 = J.num(v_i_636) + 1.0
			J.mc(_s167["c"], "stroke", [])
			break
		if _t356 <= 7 and _t356 >= 0:
			J.cl(v_shadow_632, null, [34.0])
			var _t387 = _s167["c"]
			J.sp(_t387, "strokeStyle", v_ink_631)
			var _t388 = _s167["c"]
			J.sp(_t388, "lineWidth", 2.2)
			var _t389 = _s167["c"]
			J.sp(_t389, "fillStyle", "#3a2e24")
			J.mc(_s167["c"], "fillRect", [J.sub(_s167["x"], J.mul(26.0, _s167["s"])), J.sub(_s167["y"], J.mul(44.0, _s167["s"])), J.mul(52.0, _s167["s"]), J.mul(22.0, _s167["s"])])
			J.mc(_s167["c"], "strokeRect", [J.sub(_s167["x"], J.mul(26.0, _s167["s"])), J.sub(_s167["y"], J.mul(44.0, _s167["s"])), J.mul(52.0, _s167["s"]), J.mul(22.0, _s167["s"])])
			var _t390 = _s167["c"]
			J.sp(_t390, "fillStyle", "#2a201a")
			J.mc(_s167["c"], "beginPath", [])
			J.mc(_s167["c"], "moveTo", [J.sub(_s167["x"], J.mul(32.0, _s167["s"])), J.sub(_s167["y"], J.mul(44.0, _s167["s"]))])
			J.mc(_s167["c"], "lineTo", [_s167["x"], J.sub(_s167["y"], J.mul(62.0, _s167["s"]))])
			J.mc(_s167["c"], "lineTo", [J.add(_s167["x"], J.mul(32.0, _s167["s"])), J.sub(_s167["y"], J.mul(44.0, _s167["s"]))])
			J.mc(_s167["c"], "closePath", [])
			J.mc(_s167["c"], "fill", [])
			J.mc(_s167["c"], "stroke", [])
			J.mc(_s167["c"], "beginPath", [])
			for _t391 in J.iter([(-22.0), (-8.0), 8.0, 22.0]):
				v_dx_638 = _t391
				J.mc(_s167["c"], "moveTo", [J.add(_s167["x"], J.mul(v_dx_638, _s167["s"])), J.sub(_s167["y"], J.mul(22.0, _s167["s"]))])
				J.mc(_s167["c"], "lineTo", [J.add(_s167["x"], J.mul(v_dx_638, _s167["s"])), _s167["y"]])
			J.mc(_s167["c"], "stroke", [])
			var _t392 = _s167["c"]
			J.sp(_t392, "fillStyle", "rgba(255,200,110,.5)")
			J.mc(_s167["c"], "fillRect", [J.sub(_s167["x"], J.mul(6.0, _s167["s"])), J.sub(_s167["y"], J.mul(40.0, _s167["s"])), J.mul(10.0, _s167["s"]), J.mul(10.0, _s167["s"])])
			break
		if _t356 <= 8 and _t356 >= 0:
			J.cl(v_shadow_632, null, [8.0])
			var _t393 = _s167["c"]
			J.sp(_t393, "strokeStyle", "#1a1818")
			var _t394 = _s167["c"]
			J.sp(_t394, "lineWidth", 3.0)
			J.mc(_s167["c"], "beginPath", [])
			J.mc(_s167["c"], "moveTo", [_s167["x"], _s167["y"]])
			J.mc(_s167["c"], "lineTo", [_s167["x"], J.sub(_s167["y"], J.mul(54.0, _s167["s"]))])
			J.mc(_s167["c"], "quadraticCurveTo", [_s167["x"], J.sub(_s167["y"], J.mul(62.0, _s167["s"])), J.add(_s167["x"], J.mul(12.0, _s167["s"])), J.sub(_s167["y"], J.mul(60.0, _s167["s"]))])
			J.mc(_s167["c"], "stroke", [])
			v_g_639 = J.mc(_s167["c"], "createRadialGradient", [J.add(_s167["x"], J.mul(12.0, _s167["s"])), J.sub(_s167["y"], J.mul(56.0, _s167["s"])), 2.0, J.add(_s167["x"], J.mul(12.0, _s167["s"])), J.sub(_s167["y"], J.mul(40.0, _s167["s"])), J.mul(50.0, _s167["s"])])
			J.mc(v_g_639, "addColorStop", [0.0, ("rgba(200,230,170,.35)" if J.cmp(J.gp(v_p_627, "v"), 0.3, ">") else "rgba(0,0,0,0)")])
			J.mc(v_g_639, "addColorStop", [1.0, "rgba(0,0,0,0)"])
			var _t395 = _s167["c"]
			J.sp(_t395, "fillStyle", v_g_639)
			J.mc(_s167["c"], "fillRect", [J.sub(_s167["x"], J.mul(40.0, _s167["s"])), J.sub(_s167["y"], J.mul(100.0, _s167["s"])), J.mul(104.0, _s167["s"]), J.mul(104.0, _s167["s"])])
			break
		if _t356 <= 9 and _t356 >= 0:
			J.cl(v_shadow_632, null, [22.0])
			var _t396 = _s167["c"]
			J.sp(_t396, "fillStyle", "#3b2f25")
			var _t397 = _s167["c"]
			J.sp(_t397, "strokeStyle", v_ink_631)
			var _t398 = _s167["c"]
			J.sp(_t398, "lineWidth", 2.0)
			J.mc(_s167["c"], "fillRect", [J.sub(_s167["x"], J.mul(18.0, _s167["s"])), J.sub(_s167["y"], J.mul(20.0, _s167["s"])), J.mul(36.0, _s167["s"]), J.mul(12.0, _s167["s"])])
			J.mc(_s167["c"], "strokeRect", [J.sub(_s167["x"], J.mul(18.0, _s167["s"])), J.sub(_s167["y"], J.mul(20.0, _s167["s"])), J.mul(36.0, _s167["s"]), J.mul(12.0, _s167["s"])])
			J.mc(_s167["c"], "beginPath", [])
			J.mc(_s167["c"], "arc", [J.sub(_s167["x"], J.mul(10.0, _s167["s"])), J.sub(_s167["y"], J.mul(5.0, _s167["s"])), J.mul(6.0, _s167["s"]), 0.0, 7.0])
			J.mc(_s167["c"], "arc", [J.add(_s167["x"], J.mul(12.0, _s167["s"])), J.sub(_s167["y"], J.mul(5.0, _s167["s"])), J.mul(6.0, _s167["s"]), 0.0, 7.0])
			J.mc(_s167["c"], "stroke", [])
			break
		if _t356 <= 10 and _t356 >= 0:
			J.cl(v_shadow_632, null, [10.0])
			var _t399 = _s167["c"]
			J.sp(_t399, "fillStyle", "#c4572c")
			var _t400 = _s167["c"]
			J.sp(_t400, "strokeStyle", v_ink_631)
			var _t401 = _s167["c"]
			J.sp(_t401, "lineWidth", 1.8)
			J.mc(_s167["c"], "beginPath", [])
			J.mc(_s167["c"], "moveTo", [J.sub(_s167["x"], J.mul(9.0, _s167["s"])), _s167["y"]])
			J.mc(_s167["c"], "lineTo", [_s167["x"], J.sub(_s167["y"], J.mul(24.0, _s167["s"]))])
			J.mc(_s167["c"], "lineTo", [J.add(_s167["x"], J.mul(9.0, _s167["s"])), _s167["y"]])
			J.mc(_s167["c"], "closePath", [])
			J.mc(_s167["c"], "fill", [])
			J.mc(_s167["c"], "stroke", [])
			var _t402 = _s167["c"]
			J.sp(_t402, "fillStyle", "#ddd")
			J.mc(_s167["c"], "fillRect", [J.sub(_s167["x"], J.mul(5.0, _s167["s"])), J.sub(_s167["y"], J.mul(13.0, _s167["s"])), J.mul(10.0, _s167["s"]), J.mul(3.0, _s167["s"])])
			break
		if _t356 <= 11 and _t356 >= 0:
			J.cl(v_shadow_632, null, [18.0])
			var _t403 = _s167["c"]
			J.sp(_t403, "fillStyle", "#2b2733")
			var _t404 = _s167["c"]
			J.sp(_t404, "strokeStyle", v_ink_631)
			var _t405 = _s167["c"]
			J.sp(_t405, "lineWidth", 2.0)
			J.mc(_s167["c"], "fillRect", [J.sub(_s167["x"], J.mul(12.0, _s167["s"])), J.sub(_s167["y"], J.mul(70.0, _s167["s"])), J.mul(24.0, _s167["s"]), J.mul(70.0, _s167["s"])])
			J.mc(_s167["c"], "strokeRect", [J.sub(_s167["x"], J.mul(12.0, _s167["s"])), J.sub(_s167["y"], J.mul(70.0, _s167["s"])), J.mul(24.0, _s167["s"]), J.mul(70.0, _s167["s"])])
			var _t406 = _s167["c"]
			J.sp(_t406, "strokeStyle", "rgba(160,140,190,.25)")
			J.mc(_s167["c"], "beginPath", [])
			J.mc(_s167["c"], "moveTo", [J.sub(_s167["x"], J.mul(4.0, _s167["s"])), J.sub(_s167["y"], J.mul(66.0, _s167["s"]))])
			J.mc(_s167["c"], "lineTo", [J.sub(_s167["x"], J.mul(4.0, _s167["s"])), J.sub(_s167["y"], J.mul(4.0, _s167["s"]))])
			J.mc(_s167["c"], "stroke", [])
			break
		if _t356 <= 12 and _t356 >= 0:
			if (not J.seq(J.gp(v_p_627, "t"), "desk")):
				J.sp(v_p_627, "t", "rock")
				var _t407 = _s167["__p"]["drawProp"]
				J.cl(_t407, null, [_s167["c"], v_p_627])
				break
		if _t356 <= 13 and _t356 >= 0:
			J.cl(v_shadow_632, null, [24.0])
			var _t408 = _s167["c"]
			J.sp(_t408, "fillStyle", "#3a3136")
			var _t409 = _s167["c"]
			J.sp(_t409, "strokeStyle", v_ink_631)
			var _t410 = _s167["c"]
			J.sp(_t410, "lineWidth", 2.0)
			J.mc(_s167["c"], "fillRect", [J.sub(_s167["x"], J.mul(22.0, _s167["s"])), J.sub(_s167["y"], J.mul(22.0, _s167["s"])), J.mul(44.0, _s167["s"]), J.mul(8.0, _s167["s"])])
			J.mc(_s167["c"], "strokeRect", [J.sub(_s167["x"], J.mul(22.0, _s167["s"])), J.sub(_s167["y"], J.mul(22.0, _s167["s"])), J.mul(44.0, _s167["s"]), J.mul(8.0, _s167["s"])])
			J.mc(_s167["c"], "beginPath", [])
			J.mc(_s167["c"], "moveTo", [J.sub(_s167["x"], J.mul(18.0, _s167["s"])), J.sub(_s167["y"], J.mul(14.0, _s167["s"]))])
			J.mc(_s167["c"], "lineTo", [J.sub(_s167["x"], J.mul(18.0, _s167["s"])), _s167["y"]])
			J.mc(_s167["c"], "moveTo", [J.add(_s167["x"], J.mul(18.0, _s167["s"])), J.sub(_s167["y"], J.mul(14.0, _s167["s"]))])
			J.mc(_s167["c"], "lineTo", [J.add(_s167["x"], J.mul(18.0, _s167["s"])), _s167["y"]])
			J.mc(_s167["c"], "stroke", [])
			var _t411 = _s167["c"]
			J.sp(_t411, "fillStyle", "rgba(140,200,255,.4)")
			J.mc(_s167["c"], "fillRect", [J.sub(_s167["x"], J.mul(8.0, _s167["s"])), J.sub(_s167["y"], J.mul(36.0, _s167["s"])), J.mul(16.0, _s167["s"]), J.mul(12.0, _s167["s"])])
			break
		break
	J.mc(_s167["c"], "restore", [])

func _f101(this_, a: Array, env):
	var v_then_642 = null; var v_p_643 = null
	v_then_642 = J.arg(a, 0)
	v_p_643 = J.cl(env["st"], null, [])
	if J.t(J.gp(v_p_643, "introSeen")):
		if J.t(v_then_642):
			J.cl(v_then_642, null, [])
		return null
	J.sp(v_p_643, "introSeen", 1.0)
	J.cl(J.G.get("save"), null, [])
	var _t412 = env["T"]
	var _t414 = ["龐總", J.cl(_t412, null, ["各位同事，宣佈新政策：「夜班巡陰計劃」。由今晚開始，搶地盤取消，改為巡邏。", "各位同事，宣佈新政策：「夜班巡陰計劃」。從今晚開始，取消搶地盤，改為巡邏。"])]
	var _t413 = env["T"]
	var _t416 = ["龐總", J.cl(_t413, null, ["每個部門帶隊出去，見到遊魂，有兩個處理方法：送去投胎，或者遞合約收編。", "每個部門帶隊出去，見到遊魂，有兩個處理方法：送去投胎，或者遞合約收編。"])]
	var _t415 = env["T"]
	var _t418 = ["冼小姐", J.cl(_t415, null, ["提提大家：收編要有編制，編制睇民宅。合約工資係壽包，自己準備。", "提醒大家：收編要有編制，編制看民宅。合約工資是壽包，自己準備。"])]
	var _t417 = env["T"]
	var _t420 = ["龐總", J.cl(_t417, null, ["仲有，部門唔好做到過勞。過勞咗……都係你哋自己嘅事。", "還有，部門不要做到過勞。過勞了……也是你們自己的事。"])]
	var _t419 = env["T"]
	J.mc(J.G.get("Story"), "queue", [{"style": "narr", "lines": [_t414, _t416, _t418, _t420, ["阿福", J.cl(_t419, null, ["……即係同以前一樣。", "……就是跟以前一樣。"])]]}, v_then_642])

func _f103(this_, a: Array, env):
	return env["FACI"]

func _f104(this_, a: Array, env):
	var v_ci_647 = null
	v_ci_647 = J.arg(a, 0)
	var _t422 = J.seq(J.mod(v_ci_647, 2.0), 1.0)
	env["MIR"] = _t422

func _f105(this_, a: Array, env):
	J.mc(J.G.get("UI"), "sheet", ["夜班巡陰", J.cl(env["prepHTML"], null, [])])
	J.cl(env["bindPrep"], null, [])

func _f102(this_, a: Array, env):
	var v_show_646 = null
	if (not J.seq(J.typeof_(J.G.get("__nat_patrolMenu")), "undefined")):
		var _t421 = J.G.get("Patrol")
		var _t423 = {"st": env["st"], "regSt": env["regSt"], "crewList": env["crewList"], "leads": env["leads"], "crewCap": env["crewCap"], "troopTeams": env["troopTeams"], "regionOpen": env["regionOpen"], "sidOf": env["sidOf"], "startZ": env["startZ"], "mkFaci": env["mkFaci"], "faci": Callable(self, "_f103").bind(env), "TNAME": env["TNAME"], "LMNAME": env["LMNAME"], "terOf": env["terOf"], "restRecover": env["restRecover"], "start": env["start"], "intro": env["intro"], "facOf": env["facOf"], "FAC": env["FAC"], "setMir": Callable(self, "_f104").bind(env)}
		J.sp(_t421, "_menu", _t423)
		var _t424 = J.G.get("__nat_patrolMenu")
		if J.t(J.cl(_t424, null, ["prep"])):
			return null
	J.cl(env["restRecover"], null, [])
	J.mc(J.G.get("UI"), "close", [])
	v_show_646 = Callable(self, "_f105").bind(env)
	if (not J.t(J.gp(J.cl(env["st"], null, []), "introSeen"))):
		var _t425 = env["intro"]
		J.cl(_t425, null, [v_show_646])
	else:
		J.cl(v_show_646, null, [])

func _f107(this_, a: Array, env):
	var v_g_659 = null
	v_g_659 = J.arg(a, 0)
	var _t427 = J.seq(J.gp(v_g_659, "q"), "藍")
	return (_t427 if _t427 else J.seq(J.gp(v_g_659, "q"), "紫"))

func _f108(this_, a: Array, env):
	var v_g_660 = null
	v_g_660 = J.arg(a, 0)
	return J.gp(v_g_660, "post")

func _f109(this_, a: Array, env):
	var v_g_661 = null
	v_g_661 = J.arg(a, 0)
	var _t429 = (not J.t(J.gp(v_g_661, "post")))
	if J.t(_t429):
		var _t428 = J.gp(v_g_661, "fat")
		_t429 = J.cmp((_t428 if J.t(_t428) else 0.0), 100.0, ">=")
	return _t429

func _f110(this_, a: Array, env):
	var v_g_662 = null
	v_g_662 = J.arg(a, 0)
	return J.gp(v_g_662, "poached")

func _f111(this_, a: Array, env):
	var v_f_663 = null
	v_f_663 = J.arg(a, 0)
	var _t433 = J.gp(J.gp(env["__p"]["FAC"], v_f_663), "col")
	var _t434 = J.gp(J.gp(env["__p"]["FAC"], v_f_663), "mat")
	var _t432 = J.G.get("fmt")
	return ("<span style=\"color:" + J.str(_t433) + "\"><b>" + J.str(_t434) + "</b> " + J.str(J.cl(_t432, null, [J.gp(J.gp(env["p"], "mats"), v_f_663)])) + "</span>")

func _f112(this_, a: Array, env):
	var v_i_664 = null; var v_g_665 = null
	v_i_664 = J.arg(a, 0)
	v_g_665 = J.gp(env["ld"], v_i_664)
	return ("<div class=\"pt-ls\" data-ls=\"" + J.str(v_i_664) + "\">" + (("<canvas data-por=\"" + J.str(J.gp(v_g_665, "k")) + "\"></canvas><b>" + J.str(J.gp(v_g_665, "name")) + "</b><small>" + J.str(J.mc(J.G.get("GP"), "T", ["鬼力", "鬼力"])) + " " + J.str(J.mc(J.G.get("GP"), "pow", [v_g_665])) + "</small>") if J.t(v_g_665) else "<span>＋<br>帶隊主管</span>") + "</div>")

func _f113(this_, a: Array, env):
	var v_g_666 = null
	v_g_666 = J.arg(a, 0)
	var _t446 = J.gp(v_g_666, "name")
	var _t447 = J.gp(v_g_666, "k")
	var _t445 = env["__p"]["FAC"]
	var _t444 = env["__p"]["facOf"]
	var _t450 = J.gp(J.gp(_t445, J.cl(_t444, null, [J.gp(v_g_666, "k")])), "col")
	var _t448 = J.gp(v_g_666, "fat")
	var _t449 = J.gp(v_g_666, "fat")
	return ("<span class=\"pt-cm\" title=\"" + J.str(_t446) + "\"><canvas data-por=\"" + J.str(_t447) + "\"></canvas><i style=\"background:" + J.str(_t450) + "\"></i><s style=\"width:" + J.str(J.min_([100.0, (_t449 if J.t(_t449) else 0.0)])) + "%\"></s><em>Lv" + J.str(J.mc(J.G.get("F"), "glv", [v_g_666])) + "</em></span>")

func _f115(this_, a: Array, env):
	var v_s_677 = null; var v_si_678 = null
	v_s_677 = J.arg(a, 0)
	v_si_678 = J.arg(a, 1)
	var _t462 = J.gp(J.G.get("S"), "cleared")
	var _t461 = env["__p"]["__p"]["sidOf"]
	return J.gp(_t462, J.cl(_t461, null, [env["ci"], v_si_678]))

func _f116(this_, a: Array, env):
	var v_f_679 = null
	v_f_679 = J.arg(a, 0)
	var _t466 = J.seq(J.gp(v_f_679, "t"), "station")
	if J.t(_t466):
		var _t465 = J.seq(J.gp(v_f_679, "z"), env["st0"])
		_t466 = (_t465 if _t465 else J.gp(J.gp(env["r"], "sta"), J.gp(v_f_679, "z")))
	return _t466

func _f117(this_, a: Array, env):
	var v_f_680 = null
	v_f_680 = J.arg(a, 0)
	var _t480 = ("gold" if J.t((J.seq(J.gp(v_f_680, "z"), env["st0"]) if J.t(env["cur"]) else env["cur"])) else "")
	var _t481 = env["ci"]
	var _t482 = J.gp(v_f_680, "z")
	var _t479 = null
	if J.seq(J.gp(v_f_680, "z"), env["st0"]):
		_t479 = "出發"
	else:
		var _t478 = J.gp(env["__p"]["__p"]["TNAME"], env["ci"])
		var _t477 = env["__p"]["__p"]["terOf"]
		_t479 = (J.str(J.gp(_t478, J.cl(_t477, null, [J.gp(v_f_680, "z")]))) + "站")
	return ("<button class=\"btn sm " + _t480 + "\" data-go=\"" + J.str(_t481) + "," + J.str(_t482) + "\">" + _t479 + "</button>")

func _f114(this_, a: Array, env):
	var v_ch_667 = null; var v_open_669 = null; var v_n_671 = null; var v_stas_674 = null; var v_kn_675 = null; var v_lmn_676 = null
	var _s194 = {"__p": env, "ci": null, "r": null, "cur": null, "st0": null}
	v_ch_667 = J.arg(a, 0)
	_s194["ci"] = J.arg(a, 1)
	var _t458 = _s194["__p"]["__p"]["regionOpen"]
	v_open_669 = J.cl(_t458, null, [_s194["ci"]])
	var _t459 = _s194["__p"]["__p"]["regSt"]
	_s194["r"] = J.cl(_t459, null, [_s194["ci"]])
	var _t460 = J.gp(v_ch_667, "stages")
	v_n_671 = J.len(J.mc(_t460, "filter", [Callable(self, "_f115").bind(_s194)]))
	_s194["cur"] = (J.cmp(v_n_671, 3.0, "<") if J.t(v_open_669) else v_open_669)
	var _t463 = J.seq(J.mod(_s194["ci"], 2.0), 1.0)
	_s194["__p"]["__p"]["MIR"] = _t463
	J.cl(_s194["__p"]["__p"]["mkFaci"], null, [])
	var _t464 = _s194["__p"]["__p"]["startZ"]
	_s194["st0"] = J.cl(_t464, null, [_s194["ci"]])
	v_stas_674 = J.mc(_s194["__p"]["__p"]["FACI"], "filter", [Callable(self, "_f116").bind(_s194)])
	v_kn_675 = J.add(J.len(J.S_Object_("keys", [J.gp(_s194["r"], "kings")])), v_n_671)
	var _t467 = J.gp(_s194["r"], "lm")
	v_lmn_676 = J.len(J.S_Object_("keys", [(_t467 if J.t(_t467) else {})]))
	var _t473 = ("" if J.t(v_open_669) else "locked")
	var _t474 = ("cur" if J.t(_s194["cur"]) else "")
	var _t475 = J.gp("一二三四五六", _s194["ci"])
	var _t476 = J.gp(v_ch_667, "name")
	var _t472 = null
	if J.t(v_open_669):
		var _t470 = J.len(J.gp(_s194["__p"]["__p"]["LMNAME"], _s194["ci"]))
		var _t471 = J.mc(J.G.get("GP"), "T", ["建議鬼力", "建議鬼力"])
		var _t469 = J.gp(J.gp(v_ch_667, "stages"), J.min_([2.0, v_n_671]))
		var _t468 = _s194["__p"]["__p"]["sidOf"]
		_t472 = ("地頭 " + J.str(v_kn_675) + "/9　地標 " + J.str(v_lmn_676) + "/" + J.str(_t470) + "　主線 " + J.str(v_n_671) + "/3　" + J.str(_t471) + " " + J.str(J.mc(J.G.get("GP"), "stageNeed", [_t469, J.cl(_t468, null, [_s194["ci"], J.min_([2.0, v_n_671])])])) + "　需主公 Lv" + J.str(J.gp(J.gp(J.gp(v_ch_667, "stages"), 0.0), "req")))
	else:
		_t472 = "打完上一區總監才開放"
	var _t484 = null
	if J.t(v_open_669):
		var _t483 = J.mc(v_stas_674, "map", [Callable(self, "_f117").bind(_s194)])
		_t484 = ("<div class=\"pt-go\">" + J.str(J.mc(_t483, "join", [""])) + "</div>")
	else:
		_t484 = "<span class=\"lk\">🔒</span>"
	var _t485 = J.add(_s194["__p"]["h"], ("<div class=\"pt-reg " + _t473 + " " + _t474 + "\"><div><b>第" + J.str(_t475) + "區・" + J.str(_t476) + "</b><small>" + _t472 + "</small></div>" + _t484 + "</div>"))
	_s194["__p"]["h"] = _t485

func _f106(this_, a: Array, env):
	var v_crew_651 = null; var v_all_653 = null; var v_busy_654 = null; var v_tired_655 = null; var v_poached_656 = null; var v_p0_658 = null
	var _s186 = {"__p": env, "p": null, "ld": null, "h": null}
	_s186["p"] = J.cl(_s186["__p"]["st"], null, [])
	v_crew_651 = J.cl(_s186["__p"]["crewList"], null, [])
	_s186["ld"] = J.cl(_s186["__p"]["leads"], null, [])
	var _t426 = J.gp(J.G.get("S"), "ghosts")
	v_all_653 = J.mc(_t426, "filter", [Callable(self, "_f107").bind(_s186)])
	v_busy_654 = J.len(J.mc(v_all_653, "filter", [Callable(self, "_f108").bind(_s186)]))
	v_tired_655 = J.len(J.mc(v_all_653, "filter", [Callable(self, "_f109").bind(_s186)]))
	v_poached_656 = J.len(J.mc(v_all_653, "filter", [Callable(self, "_f110").bind(_s186)]))
	var _t430 = _s186["__p"]["T"]
	_s186["h"] = ("<p class=\"desc\">" + J.str(J.cl(_t430, null, ["帶部門出去巡邏。打倒嘅遊魂：<b>送去投胎</b>（冥幣＋執念）或者<b>遞合約</b>收編（要編制同壽包）。部門主管同區域總監就係主線關卡。", "帶部門出去巡邏。打倒的遊魂：<b>送去投胎</b>（冥幣＋執念）或<b>遞合約</b>收編（要編制和壽包）。部門主管和區域總監就是主線關卡。"])) + "</p>")
	var _t431 = J.S_Object_("keys", [_s186["__p"]["FAC"]])
	var _t435 = J.mc(_t431, "map", [Callable(self, "_f111").bind(_s186)])
	var _t437 = J.mc(_t435, "join", [""])
	var _t436 = J.G.get("fmt")
	var _t438 = J.add(_s186["h"], ("<div class=\"pt-mats\">" + J.str(_t437) + "<span><b>壽包</b> " + J.str(J.cl(_t436, null, [J.gp(J.gp(J.G.get("S"), "res"), "buns")])) + "</span></div>"))
	_s186["h"] = _t438
	var _t439 = J.add(_s186["h"], ("<div class=\"pt-box\"><div class=\"pt-bh\"><b>我的部門</b><button class=\"btn sm\" id=\"pt-gear\">裝備房</button></div>"))
	_s186["h"] = _t439
	var _t440 = [0.0, 1.0, 2.0]
	var _t441 = J.mc(_t440, "map", [Callable(self, "_f112").bind(_s186)])
	var _t442 = J.add(_s186["h"], ("<div class=\"pt-lead\">" + J.str(J.mc(_t441, "join", [""])) + "</div>"))
	_s186["h"] = _t442
	var _t443 = J.add(_s186["h"], ("<p class=\"desc\">組員 <b>" + J.str(J.len(v_crew_651)) + "</b>／編制 " + J.str(J.cl(_s186["__p"]["crewCap"], null, [])) + "（民宅越高級編制越多）　陰兵 " + J.str(J.cl(_s186["__p"]["troopTeams"], null, [])) + " 隊（每 25 個一隊，最多 4 隊）</p>"))
	_s186["h"] = _t443
	var _t451 = J.mc(v_crew_651, "map", [Callable(self, "_f113").bind(_s186)])
	var _t452 = J.mc(_t451, "join", [""])
	var _t453 = J.add(_s186["h"], ("<div class=\"pt-crew\">" + J.str((_t452 if J.t(_t452) else "<small>（村裡沒有閒置的雜鬼。先去招魂台招，或在巡邏中收編。）</small>")) + "</div>"))
	_s186["h"] = _t453
	var _t454 = (v_busy_654 if J.t(v_busy_654) else v_tired_655)
	if J.t((_t454 if J.t(_t454) else v_poached_656)):
		var _t455 = J.add(_s186["h"], ("<p class=\"desc pt-note\">" + ((J.str(v_busy_654) + " 隻派了工，留在村裡做事。") if J.t(v_busy_654) else "") + ((J.str(v_tired_655) + " 隻過勞請病假（在村裡休息會慢慢恢復）。") if J.t(v_tired_655) else "") + (("<b class=\"pt-red\">" + J.str(v_poached_656) + " 隻被 Bryan 挖角</b>：在巡邏中打贏 Bryan 部門就能搶回來。") if J.t(v_poached_656) else "") + "</p>"))
		_s186["h"] = _t455
	var _t456 = J.add(_s186["h"], ("</div>"))
	_s186["h"] = _t456
	v_p0_658 = J.cl(_s186["__p"]["st"], null, [])
	var _t457 = J.add(_s186["h"], ("<div class=\"pt-regs\">"))
	_s186["h"] = _t457
	J.mc(J.G.get("CHAPTERS"), "forEach", [Callable(self, "_f114").bind(_s186)])
	var _t486 = J.gp(J.gp(J.G.get("S"), "seen"), "ch1_end")
	if J.t(((not J.seq(J.typeof_(J.G.get("Sports")), "undefined")) if J.t(_t486) else _t486)):
		var _t487 = J.add(_s186["h"], ("</div><div class=\"sc-entry sp-entry\"><div><b>陰間運動會</b><small>殭屍跳遠、舌頭對脖子拔河、倒掛耐力、河童游泳</small></div><button class=\"btn gold\" id=\"sp-open\">參加</button>"))
		_s186["h"] = _t487
	var _t488 = J.add(_s186["h"], ("</div><label class=\"pt-auto\"><input type=\"checkbox\" id=\"pt-autoc\" " + ("checked" if J.t(J.gp(v_p0_658, "auto")) else "") + "> 自動送去投胎（不用逐隻選；遞合約要手動）</label>"))
	_s186["h"] = _t488
	return _s186["h"]

func _f120(this_, a: Array, env):
	var v_ci_688 = null; var v_z_689 = null
	var _t493 = J.gp(J.gp(env["b"], "dataset"), "go")
	var _t494 = J.mc(_t493, "split", [","])
	var _t495 = J.mc(_t494, "map", [J.G.get("Number")])
	var _t496 = J.gp(_t495, 0.0)
	v_ci_688 = _t496
	var _t497 = J.gp(_t495, 1.0)
	v_z_689 = _t497
	var _t498 = env["__p"]["__p"]["start"]
	J.cl(_t498, null, [v_ci_688, v_z_689])

func _f119(this_, a: Array, env):
	var _s199 = {"__p": env, "b": null}
	_s199["b"] = J.arg(a, 0)
	var _t492 = _s199["b"]
	var _t499 = Callable(self, "_f120").bind(_s199)
	J.sp(_t492, "onclick", _t499)
	return _t499

func _f122(this_, a: Array, env):
	var _t502 = env["__p"]["__p"]["pickLead"]
	return J.cl(_t502, null, [J.num(J.gp(J.gp(env["b"], "dataset"), "ls"))])

func _f121(this_, a: Array, env):
	var _s201 = {"__p": env, "b": null}
	_s201["b"] = J.arg(a, 0)
	var _t501 = _s201["b"]
	var _t503 = Callable(self, "_f122").bind(_s201)
	J.sp(_t501, "onclick", _t503)
	return _t503

func _f124(this_, a: Array, env):
	return J.cl(env["__p"]["openPrep"], null, [])

func _f123(this_, a: Array, env):
	return J.mc(J.G.get("Gear"), "open", [Callable(self, "_f124").bind(env)])

func _f125(this_, a: Array, env):
	J.mc(J.G.get("UI"), "close", [])
	J.mc(J.G.get("Sports"), "open", [])

func _f126(this_, a: Array, env):
	var _t510 = J.cl(env["__p"]["st"], null, [])
	var _t511 = J.gp(env["ac"], "checked")
	J.sp(_t510, "auto", _t511)
	J.cl(J.G.get("save"), null, [])

func _f118(this_, a: Array, env):
	var v_root_683 = null; var v_gb_684 = null; var v_spo_685 = null
	var _s198 = {"__p": env, "ac": null}
	var _t489 = J.G.get("$")
	v_root_683 = J.cl(_t489, null, ["#sheet"])
	var _t490 = J.G.get("paintPortraits")
	J.cl(_t490, null, [v_root_683])
	var _t491 = J.mc(v_root_683, "querySelectorAll", ["[data-go]"])
	J.mc(_t491, "forEach", [Callable(self, "_f119").bind(_s198)])
	var _t500 = J.mc(v_root_683, "querySelectorAll", ["[data-ls]"])
	J.mc(_t500, "forEach", [Callable(self, "_f121").bind(_s198)])
	var _t504 = J.G.get("$")
	v_gb_684 = J.cl(_t504, null, ["#pt-gear"])
	if J.t(v_gb_684):
		var _t505 = Callable(self, "_f123").bind(_s198)
		J.sp(v_gb_684, "onclick", _t505)
	var _t506 = J.G.get("$")
	v_spo_685 = J.cl(_t506, null, ["#sp-open"])
	if J.t(v_spo_685):
		var _t507 = Callable(self, "_f125").bind(_s198)
		J.sp(v_spo_685, "onclick", _t507)
	var _t508 = J.G.get("$")
	_s198["ac"] = J.cl(_t508, null, ["#pt-autoc"])
	if J.t(_s198["ac"]):
		var _t509 = _s198["ac"]
		var _t512 = Callable(self, "_f126").bind(_s198)
		J.sp(_t509, "onchange", _t512)

func _f128(this_, a: Array, env):
	var v_g_699 = null
	v_g_699 = J.arg(a, 0)
	return J.gp(v_g_699, "id")

func _f129(this_, a: Array, env):
	var v_g_700 = null
	v_g_700 = J.arg(a, 0)
	return J.seq(J.gp(v_g_700, "q"), "名")

func _f130(this_, a: Array, env):
	var v_a_701 = null; var v_b_702 = null
	v_a_701 = J.arg(a, 0)
	v_b_702 = J.arg(a, 1)
	return J.sub(J.mc(J.G.get("GP"), "pow", [v_b_702]), J.mc(J.G.get("GP"), "pow", [v_a_701]))

func _f131(this_, a: Array, env):
	return J.cl(env["__p"]["openPrep"], null, [])

func _f133(this_, a: Array, env):
	var v_id_705 = null; var v_arr_706 = null; var v_j_707 = null
	var _t542 = J.gp(J.gp(env["el"], "dataset"), "g")
	v_id_705 = (_t542 if J.t(_t542) else null)
	v_arr_706 = J.mc(env["__p"]["cur"], "slice", [])
	while true:
		if not (J.len(v_arr_706) < 3.0): break
		J.mc(v_arr_706, "push", [null])
	v_j_707 = (J.mc(v_arr_706, "indexOf", [v_id_705]) if J.t(v_id_705) else (-1.0))
	if J.cmp(v_j_707, 0.0, ">="):
		var _t543 = J.gp(v_arr_706, env["__p"]["i"])
		J.sp(v_arr_706, v_j_707, _t543)
	var _t544 = env["__p"]["i"]
	J.sp(v_arr_706, _t544, v_id_705)
	var _t545 = env["__p"]["p"]
	var _t546 = J.mc(v_arr_706, "filter", [J.G.get("Boolean")])
	J.sp(_t545, "lead", _t546)
	J.cl(J.G.get("save"), null, [])
	J.cl(env["__p"]["__p"]["openPrep"], null, [])

func _f132(this_, a: Array, env):
	var _s213 = {"__p": env, "el": null}
	_s213["el"] = J.arg(a, 0)
	var _t541 = _s213["el"]
	var _t547 = Callable(self, "_f133").bind(_s213)
	J.sp(_t541, "onclick", _t547)
	return _t547

func _f127(this_, a: Array, env):
	var v_now_696 = null; var v_list_697 = null; var v_h_698 = null; var v_g_703 = null
	var _s207 = {"__p": env, "i": null, "p": null, "cur": null}
	_s207["i"] = J.arg(a, 0)
	_s207["p"] = J.cl(_s207["__p"]["st"], null, [])
	var _t513 = J.cl(_s207["__p"]["leads"], null, [])
	_s207["cur"] = J.mc(_t513, "map", [Callable(self, "_f128").bind(_s207)])
	v_now_696 = J.gp(_s207["cur"], _s207["i"])
	var _t514 = J.gp(J.G.get("S"), "ghosts")
	var _t515 = J.mc(_t514, "filter", [Callable(self, "_f129").bind(_s207)])
	v_list_697 = J.mc(_t515, "sort", [Callable(self, "_f130").bind(_s207)])
	v_h_698 = ("<p class=\"desc\">選帶隊主管（最多 3 隻）。主管不佔編制，倒下 25 秒後自動歸隊。</p><div class=\"glist\">")
	if J.t(v_now_696):
		var _t516 = J.add(v_h_698, ("<div class=\"gi\" data-g=\"\"><div><b>— 空著 —</b></div></div>"))
		v_h_698 = _t516
	for _t517 in J.iter(v_list_697):
		v_g_703 = _t517
		var _t520 = ("sel" if J.seq(J.gp(v_g_703, "id"), v_now_696) else "")
		var _t521 = J.gp(v_g_703, "id")
		var _t522 = J.gp(v_g_703, "k")
		var _t523 = J.gp(v_g_703, "name")
		var _t524 = ("<i class=\"tag\">帶隊中</i>" if J.t(J.mc(_s207["cur"], "includes", [J.gp(v_g_703, "id")])) else "")
		var _t525 = J.mc(J.G.get("F"), "glv", [v_g_703])
		var _t526 = J.mc(J.G.get("GP"), "T", ["鬼力", "鬼力"])
		var _t527 = J.mc(J.G.get("GP"), "pow", [v_g_703])
		var _t519 = _s207["__p"]["FAC"]
		var _t518 = _s207["__p"]["facOf"]
		var _t530 = J.gp(J.gp(_t519, J.cl(_t518, null, [J.gp(v_g_703, "k")])), "col")
		var _t529 = _s207["__p"]["FAC"]
		var _t528 = _s207["__p"]["facOf"]
		var _t531 = J.add(v_h_698, ("<div class=\"gi " + _t520 + "\" data-g=\"" + J.str(_t521) + "\"><canvas data-por=\"" + J.str(_t522) + "\"></canvas><div><b>" + J.str(_t523) + "</b> " + _t524 + "<small>Lv" + J.str(_t525) + "　<b class=\"gp-pw\">" + J.str(_t526) + " " + J.str(_t527) + "</b>　<span style=\"color:" + J.str(_t530) + "\">" + J.str(J.gp(J.gp(_t529, J.cl(_t528, null, [J.gp(v_g_703, "k")])), "name")) + "</span></small><small class=\"sk\">【" + J.str(J.gp(J.gp(J.G.get("SKILLS"), J.gp(v_g_703, "k")), "name")) + "】" + J.str(J.gp(J.gp(J.G.get("SKILLS"), J.gp(v_g_703, "k")), "desc")) + "</small></div></div>"))
		v_h_698 = _t531
	var _t532 = J.add(v_h_698, ("</div><button class=\"btn wide\" id=\"pkback\">返回</button>"))
	v_h_698 = _t532
	J.mc(J.G.get("UI"), "sheet", ["帶隊主管", v_h_698])
	var _t533 = J.G.get("paintPortraits")
	var _t534 = J.G.get("$")
	J.cl(_t533, null, [J.cl(_t534, null, ["#sheet"])])
	var _t535 = J.G.get("$")
	var _t536 = J.cl(_t535, null, ["#pkback"])
	var _t537 = Callable(self, "_f131").bind(_s207)
	J.sp(_t536, "onclick", _t537)
	var _t538 = J.G.get("$")
	var _t539 = J.cl(_t538, null, ["#sheet"])
	var _t540 = J.mc(_t539, "querySelectorAll", [".gi"])
	J.mc(_t540, "forEach", [Callable(self, "_f132").bind(_s207)])

func _f135(this_, a: Array, env):
	var v_id_715 = null
	v_id_715 = J.arg(a, 0)
	return (not J.t(J.gp(J.gp(J.G.get("S"), "seen"), v_id_715)))

func _f136(this_, a: Array, env):
	var v_id_716 = null
	v_id_716 = J.arg(a, 0)
	if (not J.t(J.gp(J.gp(J.G.get("S"), "seen"), v_id_716))):
		J.mc(J.G.get("Story"), "queue", [v_id_716])

func _f137(this_, a: Array, env):
	var _t550 = env["__p"]["begin"]
	return J.cl(_t550, null, [env["ci"], env["z"]])

func _f134(this_, a: Array, env):
	var v_ch_712 = null; var v_any_713 = null; var v_go_714 = null
	var _s215 = {"__p": env, "ci": null, "z": null}
	_s215["ci"] = J.arg(a, 0)
	_s215["z"] = J.arg(a, 1)
	J.mc(J.G.get("UI"), "close", [])
	J.cl(_s215["__p"]["restRecover"], null, [])
	v_ch_712 = J.gp(J.G.get("CHAPTERS"), _s215["ci"])
	var _t548 = J.gp(v_ch_712, "intro")
	v_any_713 = J.mc(_t548, "some", [Callable(self, "_f135").bind(_s215)])
	var _t549 = J.gp(v_ch_712, "intro")
	J.mc(_t549, "forEach", [Callable(self, "_f136").bind(_s215)])
	v_go_714 = Callable(self, "_f137").bind(_s215)
	if J.t(v_any_713):
		J.mc(J.G.get("Story"), "queue", [{"style": "narr", "lines": [["旁白", ("第" + J.str(J.gp("一二三四五六", _s215["ci"])) + "區・" + J.str(J.gp(v_ch_712, "name")))]]}, v_go_714])
	else:
		J.cl(v_go_714, null, [])

func _f139(this_, a: Array, env):
	var v_f_728 = null
	v_f_728 = J.arg(a, 0)
	var _t578 = J.seq(J.gp(v_f_728, "t"), "station")
	return (J.seq(J.gp(v_f_728, "z"), env["z0"]) if _t578 else _t578)

func _f140(this_, a: Array, env):
	var v_g_729 = null; var v_i_730 = null; var v_u_731 = null
	v_g_729 = J.arg(a, 0)
	v_i_730 = J.arg(a, 1)
	var _t588 = env["__p"]["unitFromGhost"]
	v_u_731 = J.cl(_t588, null, [v_g_729, "lead"])
	J.sp(v_u_731, "slot", v_i_730)
	var _t589 = J.gp(env["__p"]["R"], "units")
	J.mc(_t589, "push", [v_u_731])

func _f141(this_, a: Array, env):
	var v_g_732 = null; var v_i_733 = null; var v_u_734 = null
	v_g_732 = J.arg(a, 0)
	v_i_733 = J.arg(a, 1)
	var _t591 = env["__p"]["unitFromGhost"]
	v_u_734 = J.cl(_t591, null, [v_g_732, "crew"])
	var _t592 = J.add(3.0, v_i_733)
	J.sp(v_u_734, "slot", _t592)
	var _t593 = J.gp(v_g_732, "fat")
	if J.cmp((_t593 if J.t(_t593) else 0.0), 70.0, ">="):
		var _t594 = J.mul(J.gp(v_u_734, "atk"), 0.7)
		J.sp(v_u_734, "atk", _t594)
	var _t595 = J.gp(env["__p"]["R"], "units")
	J.mc(_t595, "push", [v_u_734])

func _f142(this_, a: Array, env):
	var v_u_737 = null; var v_i_738 = null; var v_o_739 = null
	v_u_737 = J.arg(a, 0)
	v_i_738 = J.arg(a, 1)
	if (not J.t(J.gp(v_u_737, "leader"))):
		var _t600 = env["__p"]["formation"]
		var _t601 = J.gp(v_u_737, "slot")
		v_o_739 = J.cl(_t600, null, [(_t601 if J.t(_t601) else v_i_738)])
		var _t602 = J.add(env["lx"], J.gp(v_o_739, "x"))
		J.sp(v_u_737, "x", _t602)
		var _t603 = J.add(env["ly"], J.gp(v_o_739, "y"))
		J.sp(v_u_737, "y", _t603)

func _f143(this_, a: Array, env):
	var v_g_740 = null
	v_g_740 = J.arg(a, 0)
	return J.gp(v_g_740, "poached")

func _f138(this_, a: Array, env):
	var v_ci_719 = null; var v_p_721 = null; var v_rs_722 = null; var v_sp_723 = null; var v_afu_726 = null; var v_L0_727 = null; var v_i_735 = null; var v_u_736 = null; var v_e_741 = null
	var _s219 = {"__p": env, "z0": null, "lx": null, "ly": null}
	v_ci_719 = J.arg(a, 0)
	_s219["z0"] = J.arg(a, 1)
	var _t551 = J.seq(J.mod(v_ci_719, 2.0), 1.0)
	_s219["__p"]["MIR"] = _t551
	J.cl(_s219["__p"]["mkFaci"], null, [])
	v_p_721 = J.cl(_s219["__p"]["st"], null, [])
	var _t552 = _s219["__p"]["regSt"]
	v_rs_722 = J.cl(_t552, null, [v_ci_719])
	var _t554 = []
	var _t555 = []
	var _t556 = []
	var _t557 = []
	var _t558 = []
	var _t559 = {}
	var _t560 = {"x": 0.0, "y": 0.0}
	var _t561 = {}
	var _t562 = {}
	var _t563 = {}
	var _t564 = {}
	var _t565 = {"coins": 0.0, "exp": 0.0, "yuan": 0.0, "chan": 0.0, "lan": 0.0, "rec": 0.0, "kills": 0.0, "buns": 0.0}
	var _t553 = _s219["__p"]["mkProps"]
	var _t569 = J.cl(_t553, null, [v_ci_719])
	var _t570 = {}
	var _t566 = J.gp(v_rs_722, "fog")
	var _t567 = (_t566 if J.t(_t566) else "")
	var _t568 = J.mc(_t567, "padEnd", [(ceil(J.num(J.div(_s219["__p"]["WW"], _s219["__p"]["FOG"]))) * ceil(J.num(J.div(_s219["__p"]["WH"], _s219["__p"]["FOG"])))), "0"])
	var _t572 = J.mc(_t568, "split", [""])
	var _t571 = _s219["__p"]["has"]
	var _t573 = {"ci": v_ci_719, "units": _t554, "foes": _t555, "fx": _t556, "proj": _t557, "downs": _t558, "t": 0.0, "joy": null, "keys": _t559, "cam": _t560, "packs": _t561, "nextSp": _t562, "zoneSeen": _t563, "tea": _t564, "act": null, "loot": _t565, "streak": 0.0, "bryan": null, "bryanDone": false, "ended": false, "gearMsg": "", "pat": null, "props": _t569, "kings": _t570, "fog": _t572, "crewBuff": (J.mc(J.G.get("Gear"), "crewBuff", []) if J.t(J.cl(_t571, null, [J.G.get("Gear")])) else {})}
	_s219["__p"]["R"] = _t573
	var _t575 = J.gp(v_rs_722, "sta")
	var _t574 = _s219["__p"]["startZ"]
	var _t576 = J.cl(_t574, null, [v_ci_719])
	J.sp(_t575, _t576, 1.0)
	var _t577 = _s219["__p"]["faciPos"]
	var _t579 = J.mc(_s219["__p"]["FACI"], "find", [Callable(self, "_f139").bind(_s219)])
	v_sp_723 = J.cl(_t577, null, [(_t579 if J.t(_t579) else J.gp(_s219["__p"]["FACI"], 0.0))])
	_s219["lx"] = J.add(J.gp(v_sp_723, "x"), 60.0)
	_s219["ly"] = J.add(J.gp(v_sp_723, "y"), 60.0)
	var _t580 = J.G.get("ghostById")
	v_afu_726 = J.cl(_t580, null, ["afu"])
	var _t581 = _s219["__p"]["unitFromGhost"]
	v_L0_727 = J.cl(_t581, null, [v_afu_726, "afu"])
	var _t582 = _s219["lx"]
	J.sp(v_L0_727, "x", _t582)
	var _t583 = _s219["ly"]
	J.sp(v_L0_727, "y", _t583)
	J.sp(v_L0_727, "leader", true)
	var _t584 = _s219["__p"]["equip"]
	J.cl(_t584, null, [v_L0_727, v_afu_726])
	var _t585 = J.gp(_s219["__p"]["R"], "units")
	J.mc(_t585, "push", [v_L0_727])
	var _t586 = _s219["__p"]["R"]
	J.sp(_t586, "L", v_L0_727)
	var _t587 = J.cl(_s219["__p"]["leads"], null, [])
	J.mc(_t587, "forEach", [Callable(self, "_f140").bind(_s219)])
	var _t590 = J.cl(_s219["__p"]["crewList"], null, [])
	J.mc(_t590, "forEach", [Callable(self, "_f141").bind(_s219)])
	v_i_735 = 0.0
	while true:
		if not J.cmp(v_i_735, J.cl(_s219["__p"]["troopTeams"], null, []), "<"): break
		var _t596 = _s219["__p"]["troopUnit"]
		v_u_736 = J.cl(_t596, null, [v_i_735])
		var _t597 = J.add(20.0, v_i_735)
		J.sp(v_u_736, "slot", _t597)
		var _t598 = J.gp(_s219["__p"]["R"], "units")
		J.mc(_t598, "push", [v_u_736])
		v_i_735 = J.num(v_i_735) + 1.0
	var _t599 = J.gp(_s219["__p"]["R"], "units")
	J.mc(_t599, "forEach", [Callable(self, "_f142").bind(_s219)])
	var _t604 = J.gp(_s219["__p"]["R"], "cam")
	var _t605 = _s219["lx"]
	J.sp(_t604, "x", _t605)
	var _t606 = J.gp(_s219["__p"]["R"], "cam")
	var _t607 = _s219["ly"]
	J.sp(_t606, "y", _t607)
	var _t608 = _s219["__p"]["R"]
	var _t609 = J.gp(J.G.get("S"), "ghosts")
	var _t610 = J.mc(_t609, "some", [Callable(self, "_f143").bind(_s219)])
	var _t611 = (_t610 if J.t(_t610) else (randf() < 0.4))
	J.sp(_t608, "bryanWant", _t611)
	J.cl(_s219["__p"]["mount"], null, [])
	_s219["__p"]["active"] = true
	if J.t(J.gp(J.G.get("Sound"), "setMode")):
		J.mc(J.G.get("Sound"), "setMode", ["battle"])
	var _t612 = _s219["__p"]["revealAround"]
	J.cl(_t612, null, [_s219["lx"], _s219["ly"]])
	var _t613 = _s219["__p"]["R"]
	var _t614 = _s219["__p"]["mkSpots"]
	var _t615 = J.cl(_t614, null, [v_ci_719])
	J.sp(_t613, "spots", _t615)
	var _t616 = _s219["__p"]["has"]
	if J.t(J.cl(_t616, null, [J.G.get("Guide")])):
		J.mc(J.G.get("Guide"), "visit", ["battle"])

func _f144(this_, a: Array, env):
	var v_i_744 = null; var v_a_745 = null; var v_a_746 = null; var v_j_747 = null; var v_ring_748 = null; var v_n_749 = null; var v_a_750 = null; var v_r_751 = null
	v_i_744 = J.arg(a, 0)
	if J.cmp(v_i_744, 3.0, "<"):
		v_a_746 = ((J.div((-PI), 2.0) + (J.sub(v_i_744, 1.0) * 1.1)) + PI)
		return {"x": (cos(J.num(v_a_746)) * 66.0), "y": ((sin(J.num(v_a_746)) * 40.0) + 8.0)}
	if J.cmp(v_i_744, 20.0, "<"):
		v_j_747 = J.sub(v_i_744, 3.0)
		v_ring_748 = (0.0 if J.cmp(v_j_747, 6.0, "<") else 1.0)
		v_n_749 = (7.0 if J.t(v_ring_748) else 6.0)
		v_a_750 = (((J.div(J.mod(v_j_747, v_n_749), v_n_749) * PI) * 2.0) + J.mul(v_ring_748, 0.4))
		v_r_751 = (150.0 if J.t(v_ring_748) else 108.0)
		return {"x": J.mul(cos(J.num(v_a_750)), v_r_751), "y": ((J.mul(sin(J.num(v_a_750)), v_r_751) * 0.65) + 10.0)}
	v_a_745 = (((J.div(J.sub(v_i_744, 20.0), 4.0) * PI) * 2.0) + 0.8)
	return {"x": (cos(J.num(v_a_745)) * 185.0), "y": ((sin(J.num(v_a_745)) * 118.0) + 10.0)}

func _f146(this_, a: Array, env):
	var v_e_756 = null
	v_e_756 = J.arg(a, 0)
	J.mc(v_e_756, "stopPropagation", [])
	J.mc(v_e_756, "preventDefault", [])
	J.cl(env["openMap"], null, [])

func _f147(this_, a: Array, env):
	var v_e_757 = null
	v_e_757 = J.arg(a, 0)
	if J.t(((not J.t(J.gp(env["R"], "ended"))) if J.t(env["R"]) else env["R"])):
		var _t635 = J.G.get("confirmInline")
		if (not J.t(J.cl(_t635, null, [J.gp(v_e_757, "target"), "確定收工？"]))):
			return null
		var _t636 = env["end"]
		J.cl(_t636, null, [false])

func _f149(this_, a: Array, env):
	var v_e_761 = null
	v_e_761 = J.arg(a, 0)
	J.mc(v_e_761, "stopPropagation", [])
	J.mc(v_e_761, "preventDefault", [])
	J.cl(env["fn"], null, [])

func _f148(this_, a: Array, env):
	var v_id_758 = null; var v_b_760 = null
	var _s239 = {"__p": env, "fn": null}
	v_id_758 = J.arg(a, 0)
	_s239["fn"] = J.arg(a, 1)
	var _t638 = J.G.get("$")
	v_b_760 = J.cl(_t638, null, [v_id_758])
	var _t639 = Callable(self, "_f149").bind(_s239)
	J.sp(v_b_760, "onpointerdown", _t639)

func _f150(this_, a: Array, env):
	var _t640 = J.cl(env["st"], null, [])
	var _t641 = J.seq(J.gp(J.cl(env["st"], null, []), "autoSk"), false)
	J.sp(_t640, "autoSk", _t641)
	J.cl(J.G.get("save"), null, [])
	var _t642 = env["hud"]
	J.cl(_t642, null, [true])

func _f151(this_, a: Array, env):
	var v_u_762 = null
	v_u_762 = J.arg(a, 0)
	return J.seq(J.gp(v_u_762, "role"), "lead")

func _f152(this_, a: Array, env):
	var v_u_763 = null
	v_u_763 = J.arg(a, 0)
	return ("<button class=\"pt-lc\" data-lu=\"" + J.str(J.gp(v_u_763, "gid")) + "\"><canvas data-por=\"" + J.str(J.gp(v_u_763, "k")) + "\"></canvas><i></i></button>")

func _f155(this_, a: Array, env):
	var v_x_767 = null
	v_x_767 = J.arg(a, 0)
	return J.seq(J.gp(v_x_767, "gid"), J.gp(J.gp(env["b"], "dataset"), "lu"))

func _f156(this_, a: Array, env):
	var v_f_769 = null
	v_f_769 = J.arg(a, 0)
	return J.cmp(J.gp(v_f_769, "hp"), 0.0, ">")

func _f154(this_, a: Array, env):
	var v_e_765 = null; var v_u_766 = null; var v_tg_768 = null
	v_e_765 = J.arg(a, 0)
	J.mc(v_e_765, "stopPropagation", [])
	J.mc(v_e_765, "preventDefault", [])
	var _t655 = J.gp(env["__p"]["R"], "units")
	v_u_766 = J.mc(_t655, "find", [Callable(self, "_f155").bind(env)])
	var _t656 = (not J.t(v_u_766))
	if (_t656 if _t656 else J.cmp(J.gp(v_u_766, "hp"), 0.0, "<=")):
		return null
	if J.cmp(J.gp(v_u_766, "energy"), 100.0, ">="):
		J.sp(v_u_766, "wantCast", true)
		var _t657 = env["__p"]["nearest"]
		var _t658 = J.gp(env["__p"]["R"], "foes")
		v_tg_768 = J.cl(_t657, null, [v_u_766, J.mc(_t658, "filter", [Callable(self, "_f156").bind(env)]), 300.0])
		if J.t(((not J.t(J.gp(v_u_766, "act"))) if J.t(v_tg_768) else v_tg_768)):
			var _t659 = env["__p"]["startAttack"]
			J.cl(_t659, null, [v_u_766, v_tg_768, true])
	else:
		J.mc(J.G.get("Fx"), "toast", [(J.str(J.gp(v_u_766, "name")) + "：符未滿")])

func _f153(this_, a: Array, env):
	var _s244 = {"__p": env, "b": null}
	_s244["b"] = J.arg(a, 0)
	var _t654 = _s244["b"]
	var _t660 = Callable(self, "_f154").bind(_s244)
	J.sp(_t654, "onpointerdown", _t660)
	return _t660

func _f157(this_, a: Array, env):
	var v_e_770 = null
	v_e_770 = J.arg(a, 0)
	J.mc(env["cv"], "setPointerCapture", [J.gp(v_e_770, "pointerId")])
	var _t663 = env["R"]
	var _t664 = {"id": J.gp(v_e_770, "pointerId"), "x0": J.gp(v_e_770, "offsetX"), "y0": J.gp(v_e_770, "offsetY"), "x": J.gp(v_e_770, "offsetX"), "y": J.gp(v_e_770, "offsetY")}
	J.sp(_t663, "joy", _t664)

func _f158(this_, a: Array, env):
	var v_e_771 = null
	v_e_771 = J.arg(a, 0)
	var _t667 = (J.gp(env["R"], "joy") if J.t(env["R"]) else env["R"])
	if J.t((J.seq(J.gp(J.gp(env["R"], "joy"), "id"), J.gp(v_e_771, "pointerId")) if J.t(_t667) else _t667)):
		var _t668 = J.gp(env["R"], "joy")
		var _t669 = J.gp(v_e_771, "offsetX")
		J.sp(_t668, "x", _t669)
		var _t670 = J.gp(env["R"], "joy")
		var _t671 = J.gp(v_e_771, "offsetY")
		J.sp(_t670, "y", _t671)

func _f159(this_, a: Array, env):
	var v_e_772 = null
	v_e_772 = J.arg(a, 0)
	var _t673 = (J.gp(env["R"], "joy") if J.t(env["R"]) else env["R"])
	if J.t((J.seq(J.gp(J.gp(env["R"], "joy"), "id"), J.gp(v_e_772, "pointerId")) if J.t(_t673) else _t673)):
		var _t674 = env["R"]
		J.sp(_t674, "joy", null)

func _f160(this_, a: Array, env):
	var v_e_773 = null; var v_k_774 = null
	v_e_773 = J.arg(a, 0)
	if (not J.t(env["R"])):
		return null
	v_k_774 = J.mc(J.gp(v_e_773, "key"), "toLowerCase", [])
	var _t678 = J.gp(env["R"], "keys")
	J.sp(_t678, v_k_774, 1.0)
	var _t679 = J.seq(v_k_774, " ")
	if (_t679 if _t679 else J.seq(v_k_774, "j")):
		J.cl(env["dash"], null, [])
	if J.seq(v_k_774, "k"):
		J.cl(env["pie"], null, [])
	if J.seq(v_k_774, "m"):
		var _t680 = J.G.get("$")
		if J.t(J.cl(_t680, null, ["#pt-map"])):
			var _t681 = J.G.get("$")
			J.mc(J.cl(_t681, null, ["#pt-map"]), "remove", [])
			var _t682 = env["R"]
			J.sp(_t682, "paused", false)
		else:
			J.cl(env["openMap"], null, [])

func _f161(this_, a: Array, env):
	var v_e_775 = null
	v_e_775 = J.arg(a, 0)
	if J.t(env["R"]):
		var _t685 = J.gp(env["R"], "keys")
		var _t686 = J.mc(J.gp(v_e_775, "key"), "toLowerCase", [])
		J.sp(_t685, _t686, 0.0)

func _f145(this_, a: Array, env):
	var v_bar_754 = null; var v_up_755 = null
	var _t617 = J.G.get("$")
	var _t618 = J.cl(_t617, null, ["#patrol"])
	env["el"] = _t618
	if (not J.t(env["el"])):
		var _t619 = J.S_document_("createElement", ["section"])
		env["el"] = _t619
		var _t620 = env["el"]
		J.sp(_t620, "id", "patrol")
		var _t621 = J.gp(J.G.get("document"), "body")
		J.mc(_t621, "appendChild", [env["el"]])
	var _t622 = env["el"]
	var _t623 = ("<canvas id=\"pt-cv\"></canvas>\n      <div id=\"pt-top\"><button id=\"pt-quit\" class=\"btn sm ghost\">收工</button><div class=\"pt-ttl\"><b id=\"pt-reg\"></b><small id=\"pt-zone\"></small></div><div class=\"pt-clk\"><b id=\"pt-clock\"></b><small id=\"pt-ph\"></small></div></div>\n      <div id=\"pt-res\"></div><canvas id=\"pt-mini\" width=\"264\" height=\"180\"></canvas>\n      <div id=\"pt-msg\"></div><div id=\"pt-act\"></div><div id=\"pt-down\"></div>\n      <div id=\"pt-bar\"><div id=\"pt-leads\"></div><button id=\"pt-sk-auto\" class=\"pt-tog\"></button><button id=\"pt-pie\" class=\"pt-rb\"><b>畫大餅</b><i></i></button><button id=\"pt-dash\" class=\"pt-rb big\"><b>衝刺</b><i></i></button></div><div id=\"pt-end\"></div>")
	J.sp(_t622, "innerHTML", _t623)
	var _t624 = J.gp(env["el"], "classList")
	J.mc(_t624, "add", ["on"])
	var _t625 = J.G.get("$")
	var _t626 = J.cl(_t625, null, ["#pt-cv"])
	env["cv"] = _t626
	var _t627 = J.mc(env["cv"], "getContext", ["2d"])
	env["ctx"] = _t627
	var _t628 = J.G.get("$")
	var _t629 = J.cl(_t628, null, ["#pt-mini"])
	env["mini"] = _t629
	var _t630 = env["mini"]
	var _t631 = Callable(self, "_f146").bind(env)
	J.sp(_t630, "onpointerdown", _t631)
	var _t632 = J.G.get("window")
	J.sp(_t632, "onkeydown", null)
	var _t633 = J.G.get("$")
	var _t634 = J.cl(_t633, null, ["#pt-quit"])
	var _t637 = Callable(self, "_f147").bind(env)
	J.sp(_t634, "onclick", _t637)
	J.cl(env["resize"], null, [])
	J.S_window_("addEventListener", ["resize", env["resize"]])
	v_bar_754 = Callable(self, "_f148").bind(env)
	J.cl(v_bar_754, null, ["#pt-dash", env["dash"]])
	J.cl(v_bar_754, null, ["#pt-pie", env["pie"]])
	J.cl(v_bar_754, null, ["#pt-sk-auto", Callable(self, "_f150").bind(env)])
	var _t643 = J.G.get("$")
	var _t644 = J.cl(_t643, null, ["#pt-leads"])
	var _t645 = J.gp(env["R"], "units")
	var _t646 = J.mc(_t645, "filter", [Callable(self, "_f151").bind(env)])
	var _t647 = J.mc(_t646, "map", [Callable(self, "_f152").bind(env)])
	var _t648 = J.mc(_t647, "join", [""])
	J.sp(_t644, "innerHTML", _t648)
	var _t649 = J.G.get("paintPortraits")
	var _t650 = J.G.get("$")
	J.cl(_t649, null, [J.cl(_t650, null, ["#pt-leads"])])
	var _t651 = J.G.get("$")
	var _t652 = J.cl(_t651, null, ["#pt-leads"])
	var _t653 = J.mc(_t652, "querySelectorAll", ["[data-lu]"])
	J.mc(_t653, "forEach", [Callable(self, "_f153").bind(env)])
	var _t661 = J.G.get("window")
	J.sp(_t661, "onkeydown", null)
	var _t662 = env["cv"]
	var _t665 = Callable(self, "_f157").bind(env)
	J.sp(_t662, "onpointerdown", _t665)
	var _t666 = env["cv"]
	var _t672 = Callable(self, "_f158").bind(env)
	J.sp(_t666, "onpointermove", _t672)
	v_up_755 = Callable(self, "_f159").bind(env)
	var _t675 = env["cv"]
	J.sp(_t675, "onpointerup", v_up_755)
	var _t676 = env["cv"]
	J.sp(_t676, "onpointercancel", v_up_755)
	var _t677 = J.G.get("window")
	var _t683 = Callable(self, "_f160").bind(env)
	J.sp(_t677, "onkeydown", _t683)
	var _t684 = J.G.get("window")
	var _t687 = Callable(self, "_f161").bind(env)
	J.sp(_t684, "onkeyup", _t687)
	var _t688 = J.S_performance_("now", [])
	env["last"] = _t688
	J.F_cancelAnimationFrame([env["raf"]])
	var _t689 = J.F_requestAnimationFrame([env["frame"]])
	env["raf"] = _t689

func _f162(this_, a: Array, env):
	var v_r_778 = null; var v_dpr_779 = null
	if (not J.t(env["cv"])):
		return null
	v_r_778 = J.mc(env["cv"], "getBoundingClientRect", [])
	var _t690 = J.gp(J.G.get("window"), "devicePixelRatio")
	var _t691 = J.gp(J.G.get("window"), "devicePixelRatio")
	v_dpr_779 = J.min_([2.0, (_t691 if J.t(_t691) else 1.0)])
	var _t692 = env["cv"]
	var _t693 = J.mul(J.gp(v_r_778, "width"), v_dpr_779)
	J.sp(_t692, "width", _t693)
	var _t694 = env["cv"]
	var _t695 = J.mul(J.gp(v_r_778, "height"), v_dpr_779)
	J.sp(_t694, "height", _t695)
	if J.t(env["R"]):
		var _t696 = env["R"]
		J.sp(_t696, "dpr", v_dpr_779)
		var _t697 = env["R"]
		var _t698 = J.gp(v_r_778, "width")
		J.sp(_t697, "w", _t698)
		var _t699 = env["R"]
		var _t700 = J.gp(v_r_778, "height")
		J.sp(_t699, "h", _t700)
		var _t701 = env["R"]
		var _t702 = J.div(J.gp(v_r_778, "width"), env["VIEW"])
		J.sp(_t701, "sc", _t702)

func _f163(this_, a: Array, env):
	var v_now_782 = null; var v_dt_783 = null
	v_now_782 = J.arg(a, 0)
	if (not J.t(env["active"])):
		return null
	var _t703 = J.F_requestAnimationFrame([env["frame"]])
	env["raf"] = _t703
	if (J.sub(v_now_782, env["last"]) < (J.div(1000.0, 30.0) - 2.0)):
		return null
	v_dt_783 = J.min_([0.08, J.div(J.sub(v_now_782, env["last"]), 1000.0)])
	env["last"] = v_now_782
	if (not J.t(env["R"])):
		return null
	if (not J.t(J.gp(env["R"], "sc"))):
		J.cl(env["resize"], null, [])
	var _t704 = (not J.t(J.gp(env["R"], "ended")))
	var _t705 = ((not J.t(J.mc(J.G.get("Story"), "busy", []))) if _t704 else _t704)
	if ((not J.t(J.gp(env["R"], "paused"))) if _t705 else _t705):
		var _t706 = env["update"]
		J.cl(_t706, null, [v_dt_783])
	J.cl(env["draw"], null, [])
	if (not J.seq(J.bor(J.mul(J.gp(env["R"], "t"), 4.0), 0.0), J.bor(J.gp(env["R"], "hudT"), 0.0))):
		var _t707 = env["R"]
		var _t708 = J.bor(J.mul(J.gp(env["R"], "t"), 4.0), 0.0)
		J.sp(_t707, "hudT", _t708)
		J.cl(env["hud"], null, [])

func _f164(this_, a: Array, env):
	var v_u_786 = null; var v_nx_787 = null; var v_ny_788 = null; var v_gx_789 = null; var v_gy_790 = null; var v_w_791 = null; var v_by_792 = null; var v_cross_793 = null; var v_bx_794 = null; var v_cross_795 = null; var v_i_796 = null; var v_j_797 = null; var v_l_798 = null; var v_o_799 = null; var v_dx_800 = null; var v_dy_801 = null; var v_d_802 = null; var v_k_803 = null
	v_u_786 = J.arg(a, 0)
	v_nx_787 = J.arg(a, 1)
	v_ny_788 = J.arg(a, 2)
	var _t709 = J.max_([20.0, J.min_([J.sub(env["WW"], 20.0), v_nx_787])])
	v_nx_787 = _t709
	var _t710 = J.max_([30.0, J.min_([J.sub(env["WH"], 20.0), v_ny_788])])
	v_ny_788 = _t710
	for _t711 in J.iter(env["WALLS"]):
		v_w_791 = _t711
		if J.t(J.gp(v_w_791, "h")):
			var _t712 = J.cmp(v_nx_787, J.sub(J.gp(v_w_791, "a"), 14.0), "<")
			if (_t712 if _t712 else J.cmp(v_nx_787, J.add(J.gp(v_w_791, "b"), 14.0), ">")):
				continue
			v_by_792 = J.gp(v_w_791, "p")
			var _t713 = (not J.seq(J.cmp(J.gp(v_u_786, "y"), v_by_792, "<"), J.cmp(v_ny_788, v_by_792, "<")))
			v_cross_793 = (_t713 if _t713 else (absf(J.num(J.sub(v_ny_788, v_by_792))) < 14.0))
			if (not J.t(v_cross_793)):
				continue
			var _t714 = J.gp(v_w_791, "gap")
			var _t717 = ((absf(J.num(J.sub(v_nx_787, J.gp(J.gp(v_w_791, "gap"), "c")))) < (J.div(env["GW"], 2.0) - 12.0)) if J.t(_t714) else _t714)
			if J.t(_t717):
				var _t716 = J.seq(J.gp(v_u_786, "side"), 1.0)
				if not J.t(_t716):
					var _t715 = env["gateOpen"]
					_t716 = J.cl(_t715, null, [J.gp(J.gp(v_w_791, "gap"), "g")])
				_t717 = _t716
			if J.t(_t717):
				continue
			var _t718 = (J.min_([v_ny_788, J.sub(v_by_792, 15.0)]) if J.cmp(J.gp(v_u_786, "y"), v_by_792, "<") else J.max_([v_ny_788, J.add(v_by_792, 15.0)]))
			v_ny_788 = _t718
		else:
			var _t719 = J.cmp(v_ny_788, J.sub(J.gp(v_w_791, "a"), 14.0), "<")
			if (_t719 if _t719 else J.cmp(v_ny_788, J.add(J.gp(v_w_791, "b"), 14.0), ">")):
				continue
			v_bx_794 = J.gp(v_w_791, "p")
			var _t720 = (not J.seq(J.cmp(J.gp(v_u_786, "x"), v_bx_794, "<"), J.cmp(v_nx_787, v_bx_794, "<")))
			v_cross_795 = (_t720 if _t720 else (absf(J.num(J.sub(v_nx_787, v_bx_794))) < 14.0))
			if (not J.t(v_cross_795)):
				continue
			var _t721 = J.gp(v_w_791, "gap")
			var _t724 = ((absf(J.num(J.sub(v_ny_788, J.gp(J.gp(v_w_791, "gap"), "c")))) < (J.div(env["GW"], 2.0) - 12.0)) if J.t(_t721) else _t721)
			if J.t(_t724):
				var _t723 = J.seq(J.gp(v_u_786, "side"), 1.0)
				if not J.t(_t723):
					var _t722 = env["gateOpen"]
					_t723 = J.cl(_t722, null, [J.gp(J.gp(v_w_791, "gap"), "g")])
				_t724 = _t723
			if J.t(_t724):
				continue
			var _t725 = (J.min_([v_nx_787, J.sub(v_bx_794, 15.0)]) if J.cmp(J.gp(v_u_786, "x"), v_bx_794, "<") else J.max_([v_nx_787, J.add(v_bx_794, 15.0)]))
			v_nx_787 = _t725
	v_gx_789 = floor(J.num(J.div(v_nx_787, 200.0)))
	v_gy_790 = floor(J.num(J.div(v_ny_788, 200.0)))
	v_i_796 = (-1.0)
	while true:
		if not J.cmp(v_i_796, 1.0, "<="): break
		v_j_797 = (-1.0)
		while true:
			if not J.cmp(v_j_797, 1.0, "<="): break
			v_l_798 = J.gp(env["PGRID"], J.add(J.add(J.add(v_gx_789, v_i_796), ","), J.add(v_gy_790, v_j_797)))
			if (not J.t(v_l_798)):
				v_j_797 = J.num(v_j_797) + 1.0
				continue
			for _t726 in J.iter(v_l_798):
				v_o_799 = _t726
				v_dx_800 = J.sub(v_nx_787, J.gp(v_o_799, "x"))
				v_dy_801 = (J.sub(v_ny_788, J.gp(v_o_799, "y")) * 1.7)
				v_d_802 = J.hypot_([v_dx_800, v_dy_801])
				var _t727 = J.cmp(v_d_802, J.gp(v_o_799, "r"), "<")
				if (J.cmp(v_d_802, 0.01, ">") if _t727 else _t727):
					v_k_803 = J.div(J.gp(v_o_799, "r"), v_d_802)
					var _t728 = J.add(J.gp(v_o_799, "x"), J.mul(v_dx_800, v_k_803))
					v_nx_787 = _t728
					var _t729 = J.add(J.gp(v_o_799, "y"), J.div(J.mul(v_dy_801, v_k_803), 1.7))
					v_ny_788 = _t729
			v_j_797 = J.num(v_j_797) + 1.0
		v_i_796 = J.num(v_i_796) + 1.0
	J.sp(v_u_786, "x", v_nx_787)
	J.sp(v_u_786, "y", v_ny_788)

func _f165(this_, a: Array, env):
	var v_x_806 = null; var v_y_807 = null; var v_rr_808 = null; var v_cw_809 = null; var v_r_810 = null; var v_cx_811 = null; var v_cy_812 = null; var v_j_813 = null; var v_i_814 = null; var v_X_815 = null; var v_Y_816 = null
	v_x_806 = J.arg(a, 0)
	v_y_807 = J.arg(a, 1)
	v_rr_808 = J.arg(a, 2)
	v_cw_809 = ceil(J.num(J.div(env["WW"], env["FOG"])))
	v_r_810 = (v_rr_808 if J.t(v_rr_808) else 3.0)
	v_cx_811 = floor(J.num(J.div(v_x_806, env["FOG"])))
	v_cy_812 = floor(J.num(J.div(v_y_807, env["FOG"])))
	v_j_813 = (-J.num(v_r_810))
	while true:
		if not J.cmp(v_j_813, v_r_810, "<="): break
		v_i_814 = (-J.num(v_r_810))
		while true:
			if not J.cmp(v_i_814, v_r_810, "<="): break
			if ((J.mul(v_i_814, v_i_814) + J.mul(v_j_813, v_j_813)) > (J.mul(v_r_810, v_r_810) + 1.0)):
				v_i_814 = J.num(v_i_814) + 1.0
				continue
			v_X_815 = J.add(v_cx_811, v_i_814)
			v_Y_816 = J.add(v_cy_812, v_j_813)
			var _t730 = J.cmp(v_X_815, 0.0, "<")
			var _t731 = (_t730 if _t730 else J.cmp(v_Y_816, 0.0, "<"))
			var _t732 = (_t731 if _t731 else J.cmp(v_X_815, v_cw_809, ">="))
			if (_t732 if _t732 else J.cmp(J.mul(v_Y_816, env["FOG"]), env["WH"], ">=")):
				v_i_814 = J.num(v_i_814) + 1.0
				continue
			var _t733 = J.gp(env["R"], "fog")
			var _t734 = J.add(J.mul(v_Y_816, v_cw_809), v_X_815)
			J.sp(_t733, _t734, "1")
			v_i_814 = J.num(v_i_814) + 1.0
		v_j_813 = J.num(v_j_813) + 1.0

func _f168(this_, a: Array, env):
	var v_e_836 = null
	v_e_836 = J.arg(a, 0)
	var _t742 = J.cmp(J.gp(v_e_836, "hp"), 0.0, ">")
	return (_t742 if _t742 else J.cmp(J.gp(v_e_836, "down"), 0.0, ">"))

func _f167(this_, a: Array, env):
	var v_pk_835 = null
	v_pk_835 = J.arg(a, 0)
	return J.mc(v_pk_835, "some", [Callable(self, "_f168").bind(env)])

func _f169(this_, a: Array, env):
	var v_f_838 = null; var v_q_839 = null
	v_f_838 = J.arg(a, 0)
	var _t752 = env["__p"]["faciPos"]
	v_q_839 = J.cl(_t752, null, [v_f_838])
	return (J.hypot_([J.sub(J.gp(v_q_839, "x"), env["x"]), J.sub(J.gp(v_q_839, "y"), env["y"])]) < 170.0)

func _f170(this_, a: Array, env):
	var v_t_840 = null; var v_q_841 = null
	v_t_840 = J.arg(a, 0)
	var _t754 = env["__p"]["lairPos"]
	v_q_841 = J.cl(_t754, null, [v_t_840])
	return (J.hypot_([J.sub(J.gp(v_q_841, "x"), env["x"]), J.sub(J.gp(v_q_841, "y"), env["y"])]) < 260.0)

func _f171(this_, a: Array, env):
	var v_s_842 = null; var v_a_843 = null
	v_s_842 = J.arg(a, 0)
	v_a_843 = J.arg(a, 1)
	return J.add(v_s_842, J.len(v_a_843))

func _f173(this_, a: Array, env):
	var v_e_848 = null
	v_e_848 = J.arg(a, 0)
	return J.gp(v_e_848, "elite")

func _f172(this_, a: Array, env):
	var v_a_847 = null
	v_a_847 = J.arg(a, 0)
	return J.mc(v_a_847, "some", [Callable(self, "_f173").bind(env)])

func _f174(this_, a: Array, env):
	var v_e_851 = null
	v_e_851 = J.arg(a, 0)
	var _t783 = J.gp(env["__p"]["R"], "foes")
	return J.mc(_t783, "push", [v_e_851])

func _f166(this_, a: Array, env):
	var v_z_819 = null; var v_ci_820 = null; var v_p_821 = null; var v_pool_822 = null; var v_cell_823 = null; var v_ph_824 = null; var v_want_825 = null; var v_alive_826 = null; var v_ok_829 = null; var v_tz_830 = null; var v_n_831 = null; var v_unlocked_832 = null; var v_pk_833 = null; var v_ek_834 = null; var v_k_837 = null; var v_i_844 = null; var v_k_845 = null; var v_e_846 = null; var v_t_849 = null; var v_e_850 = null
	var _s275 = {"__p": env, "x": null, "y": null}
	v_z_819 = J.arg(a, 0)
	v_ci_820 = J.gp(_s275["__p"]["R"], "ci")
	var _t735 = _s275["__p"]["zoneP"]
	v_p_821 = J.cl(_t735, null, [v_ci_820, v_z_819])
	var _t736 = _s275["__p"]["fodOf"]
	v_pool_822 = J.cl(_t736, null, [v_ci_820])
	var _t737 = _s275["__p"]["zoneCell"]
	v_cell_823 = J.cl(_t737, null, [v_z_819])
	var _t738 = _s275["__p"]["phase"]
	v_ph_824 = J.cl(_t738, null, [J.gp(J.cl(_s275["__p"]["st"], null, []), "min")])
	if (not J.t(J.gp(J.gp(_s275["__p"]["R"], "packs"), v_z_819))):
		var _t739 = J.gp(_s275["__p"]["R"], "packs")
		var _t740 = []
		J.sp(_t739, v_z_819, _t740)
	v_want_825 = (3.0 if J.seq(v_ph_824, "off") else 4.0)
	var _t741 = J.gp(J.gp(_s275["__p"]["R"], "packs"), v_z_819)
	v_alive_826 = J.mc(_t741, "filter", [Callable(self, "_f167").bind(_s275)])
	var _t743 = J.gp(_s275["__p"]["R"], "packs")
	J.sp(_t743, v_z_819, v_alive_826)
	var _t746 = J.cmp(J.len(v_alive_826), v_want_825, ">=")
	if not J.t(_t746):
		var _t745 = J.gp(_s275["__p"]["R"], "t")
		var _t744 = J.gp(J.gp(_s275["__p"]["R"], "nextSp"), v_z_819)
		_t746 = J.cmp(_t745, (_t744 if J.t(_t744) else 0.0), "<")
	if _t746:
		return null
	var _t747 = J.gp(_s275["__p"]["R"], "nextSp")
	var _t748 = J.add(J.gp(_s275["__p"]["R"], "t"), 2.0)
	J.sp(_t747, v_z_819, _t748)
	_s275["x"] = 0.0
	_s275["y"] = 0.0
	v_ok_829 = false
	v_k_837 = 0.0
	while true:
		var _t749 = J.cmp(v_k_837, 12.0, "<")
		if not ((not J.t(v_ok_829)) if _t749 else _t749): break
		var _t750 = J.add(J.gp(v_cell_823, "x"), ((randf() - 0.5) * J.sub(_s275["__p"]["CW"], 160.0)))
		_s275["x"] = _t750
		var _t751 = J.add(J.gp(v_cell_823, "y"), ((randf() - 0.5) * J.sub(_s275["__p"]["CH"], 160.0)))
		_s275["y"] = _t751
		var _t753 = (J.hypot_([J.sub(_s275["x"], J.gp(J.gp(_s275["__p"]["R"], "L"), "x")), J.sub(_s275["y"], J.gp(J.gp(_s275["__p"]["R"], "L"), "y"))]) > 380.0)
		var _t755 = ((not J.t(J.mc(_s275["__p"]["FACI"], "some", [Callable(self, "_f169").bind(_s275)]))) if _t753 else _t753)
		var _t757 = ((not J.t(J.mc(_s275["__p"]["TALL"], "some", [Callable(self, "_f170").bind(_s275)]))) if _t755 else _t755)
		if J.t(_t757):
			var _t756 = _s275["__p"]["blockedAt"]
			_t757 = (not J.t(J.cl(_t756, null, [_s275["x"], _s275["y"]])))
		v_ok_829 = _t757
		v_k_837 = J.num(v_k_837) + 1.0
	if (not J.t(v_ok_829)):
		return null
	var _t758 = _s275["__p"]["terOf"]
	v_tz_830 = J.cl(_t758, null, [v_z_819])
	v_n_831 = (1.0 + floor(J.num((randf() * J.min_([(4.0 if J.seq(v_ci_820, 0.0) else 5.0), J.add(J.add(1.0, v_tz_830), J.min_([v_ci_820, 2.0]))])))))
	var _t760 = J.len(v_pool_822)
	var _t759 = J.mc(_s275["__p"]["CH_FOD"], "slice", [0.0, v_ci_820])
	var _t762 = J.len(v_pool_822)
	var _t761 = J.mc(_s275["__p"]["CH_FOD"], "slice", [0.0, v_ci_820])
	var _t764 = J.len(v_pool_822)
	var _t763 = J.mc(_s275["__p"]["CH_FOD"], "slice", [0.0, v_ci_820])
	var _t766 = J.len(v_pool_822)
	var _t765 = J.mc(_s275["__p"]["CH_FOD"], "slice", [0.0, v_ci_820])
	v_unlocked_832 = J.mc(v_pool_822, "slice", [0.0, J.max_([1.0, J.min_([_t766, J.add(J.add(J.mc(_t765, "reduce", [Callable(self, "_f171").bind(_s275), 0.0]), 1.0), floor(J.num(J.div(v_tz_830, 2.0))))])])])
	v_pk_833 = []
	v_i_844 = 0.0
	while true:
		if not J.cmp(v_i_844, v_n_831, "<"): break
		v_k_845 = J.gp(v_unlocked_832, ((J.len(v_unlocked_832) - 1.0) if (randf() < 0.55) else floor(J.num((randf() * J.len(v_unlocked_832))))))
		var _t767 = _s275["__p"]["foe"]
		v_e_846 = J.cl(_t767, null, [v_k_845, v_p_821])
		var _t768 = J.add(_s275["x"], ((randf() - 0.5) * 70.0))
		J.sp(v_e_846, "x", _t768)
		var _t769 = J.add(_s275["y"], ((randf() - 0.5) * 50.0))
		J.sp(v_e_846, "y", _t769)
		var _t770 = _s275["x"]
		J.sp(v_e_846, "hx", _t770)
		var _t771 = _s275["y"]
		J.sp(v_e_846, "hy", _t771)
		J.sp(v_e_846, "z", v_z_819)
		J.mc(v_pk_833, "push", [v_e_846])
		v_i_844 = J.num(v_i_844) + 1.0
	var _t772 = _s275["__p"]["eliteOfZone"]
	v_ek_834 = J.cl(_t772, null, [v_ci_820, v_z_819])
	var _t775 = ((not J.t(J.mc(v_alive_826, "some", [Callable(self, "_f172").bind(_s275)]))) if J.t(v_ek_834) else v_ek_834)
	if J.t(_t775):
		var _t774 = J.gp(_s275["__p"]["R"], "t")
		var _t773 = J.gp(_s275["__p"]["R"], "eliteT")
		_t775 = J.cmp(_t774, (_t773 if J.t(_t773) else 0.0), ">")
	if J.t(((randf() < (0.6 if J.seq(v_ph_824, "zi") else 0.3)) if J.t(_t775) else _t775)):
		var _t776 = _s275["__p"]["R"]
		var _t777 = J.add(J.gp(_s275["__p"]["R"], "t"), 40.0)
		J.sp(_t776, "eliteT", _t777)
		v_t_849 = J.gp(J.G.get("N30_TIER"), J.gp(J.gp(J.G.get("N30_G"), v_ek_834), "t"))
		var _t778 = _s275["__p"]["foe"]
		v_e_850 = J.cl(_t778, null, [v_ek_834, J.max_([v_p_821, J.gp(v_t_849, "p")]), {"hp": 3.2, "atk": 1.5}, {"elite": true}])
		J.sp(v_e_850, "s", 0.58)
		var _t779 = _s275["x"]
		J.sp(v_e_850, "x", _t779)
		var _t780 = _s275["y"]
		J.sp(v_e_850, "y", _t780)
		var _t781 = _s275["x"]
		J.sp(v_e_850, "hx", _t781)
		var _t782 = _s275["y"]
		J.sp(v_e_850, "hy", _t782)
		J.sp(v_e_850, "z", v_z_819)
		J.mc(v_pk_833, "push", [v_e_850])
	J.mc(v_pk_833, "forEach", [Callable(self, "_f174").bind(_s275)])
	var _t784 = J.gp(J.gp(_s275["__p"]["R"], "packs"), v_z_819)
	J.mc(_t784, "push", [v_pk_833])

func _f176(this_, a: Array, env):
	var v_k_859 = null; var v_i_860 = null; var v_boss_861 = null; var v_e_862 = null; var v_a_863 = null
	v_k_859 = J.arg(a, 0)
	v_i_860 = J.arg(a, 1)
	v_boss_861 = J.seq(v_k_859, J.gp(env["stg"], "boss"))
	var _t793 = env["__p"]["foe"]
	v_e_862 = J.cl(_t793, null, [v_k_859, J.gp(env["stg"], "p"), {"hp": (3.6 if J.t(v_boss_861) else 2.2), "atk": (1.3 if J.t(v_boss_861) else 1.1)}, {"guard": env["si"], "boss": v_boss_861}])
	v_a_863 = (J.sub(v_i_860, J.div((J.len(J.gp(env["stg"], "en")) - 1.0), 2.0)) * 0.9)
	var _t794 = J.add(J.gp(env["gp"], "x"), (sin(J.num(v_a_863)) * 70.0))
	J.sp(v_e_862, "x", _t794)
	var _t795 = (J.sub(J.gp(env["gp"], "y"), (cos(J.num(v_a_863)) * 20.0)) + ((-10.0) if J.t(v_boss_861) else 0.0))
	J.sp(v_e_862, "y", _t795)
	var _t796 = J.gp(v_e_862, "x")
	J.sp(v_e_862, "hx", _t796)
	var _t797 = J.gp(v_e_862, "y")
	J.sp(v_e_862, "hy", _t797)
	var _t798 = (0.78 if J.t(v_boss_861) else 0.55)
	J.sp(v_e_862, "s", _t798)
	var _t799 = J.gp(J.G.get("ENEMY_T"), v_k_859)
	var _t800 = J.gp((_t799 if J.t(_t799) else []), 2.0)
	var _t801 = (_t800 if J.t(_t800) else v_k_859)
	J.sp(v_e_862, "name", _t801)
	J.mc(env["arr"], "push", [v_e_862])
	var _t802 = J.gp(env["__p"]["R"], "foes")
	J.mc(_t802, "push", [v_e_862])

func _f175(this_, a: Array, env):
	var v_sid_855 = null
	var _s289 = {"__p": env, "si": null, "stg": null, "gp": null, "arr": null}
	_s289["si"] = J.arg(a, 0)
	var _t785 = _s289["__p"]["sidOf"]
	v_sid_855 = J.cl(_t785, null, [J.gp(_s289["__p"]["R"], "ci"), _s289["si"]])
	var _t787 = J.gp(J.gp(J.G.get("S"), "cleared"), v_sid_855)
	if not J.t(_t787):
		var _t786 = J.gp(_s289["__p"]["R"], "guards")
		_t787 = (J.gp(J.gp(_s289["__p"]["R"], "guards"), _s289["si"]) if J.t(_t786) else _t786)
	if J.t(_t787):
		return null
	var _t788 = _s289["__p"]["R"]
	var _t789 = J.gp(_s289["__p"]["R"], "guards")
	var _t790 = (_t789 if J.t(_t789) else {})
	J.sp(_t788, "guards", _t790)
	_s289["stg"] = J.gp(J.gp(J.gp(J.G.get("CHAPTERS"), J.gp(_s289["__p"]["R"], "ci")), "stages"), _s289["si"])
	var _t791 = _s289["__p"]["guardPos"]
	_s289["gp"] = J.cl(_t791, null, [_s289["si"]])
	_s289["arr"] = []
	var _t792 = J.gp(_s289["stg"], "en")
	J.mc(_t792, "forEach", [Callable(self, "_f176").bind(_s289)])
	var _t803 = J.gp(_s289["__p"]["R"], "guards")
	var _t804 = _s289["si"]
	var _t805 = _s289["arr"]
	J.sp(_t803, _t804, _t805)

func _f178(this_, a: Array, env):
	var v_k_873 = null; var v_big_874 = null; var v_dx_875 = null; var v_lab_876 = null; var v_e_877 = null
	v_k_873 = J.arg(a, 0)
	v_big_874 = J.arg(a, 1)
	v_dx_875 = J.arg(a, 2)
	v_lab_876 = J.arg(a, 3)
	var _t812 = (not J.t(v_k_873))
	if (_t812 if _t812 else (not J.t(J.gp(J.G.get("ENEMY_T"), v_k_873)))):
		return null
	var _t813 = env["__p"]["foe"]
	v_e_877 = J.cl(_t813, null, [v_k_873, env["p"], ({"hp": 5.5, "atk": 1.6} if J.t(v_big_874) else {"hp": 3.4, "atk": 1.35}), {"king": env["t"], "boss": v_big_874, "elite": false, "kname": v_lab_876}])
	var _t814 = J.gp(J.G.get("SKILLS"), v_k_873)
	var _t815 = (_t814 if J.t(_t814) else null)
	J.sp(v_e_877, "sk", _t815)
	var _t816 = (0.8 if J.t(v_big_874) else 0.66)
	J.sp(v_e_877, "s", _t816)
	var _t817 = J.add(J.gp(env["lp"], "x"), v_dx_875)
	J.sp(v_e_877, "x", _t817)
	var _t818 = J.sub(J.gp(env["lp"], "y"), 10.0)
	J.sp(v_e_877, "y", _t818)
	var _t819 = J.gp(v_e_877, "x")
	J.sp(v_e_877, "hx", _t819)
	var _t820 = J.gp(v_e_877, "y")
	J.sp(v_e_877, "hy", _t820)
	var _t821 = (J.gp(J.gp(J.G.get("GHOSTS"), v_k_873), "name") if J.t(J.gp(J.G.get("GHOSTS"), v_k_873)) else J.gp(v_e_877, "name"))
	J.sp(v_e_877, "name", _t821)
	J.mc(env["arr"], "push", [v_e_877])

func _f179(this_, a: Array, env):
	var v_e_882 = null
	v_e_882 = J.arg(a, 0)
	var _t827 = J.gp(env["__p"]["R"], "foes")
	return J.mc(_t827, "push", [v_e_882])

func _f177(this_, a: Array, env):
	var v_d_867 = null; var v_pool_871 = null; var v_mk_872 = null; var v_i_878 = null; var v_k_879 = null; var v_e_880 = null; var v_a_881 = null
	var _s291 = {"__p": env, "t": null, "lp": null, "p": null, "arr": null}
	_s291["t"] = J.arg(a, 0)
	var _t807 = (not J.leq(J.gp(_s291["__p"]["TMAIN"], _s291["t"]), null))
	if not J.t(_t807):
		var _t806 = _s291["__p"]["kingDone"]
		_t807 = J.cl(_t806, null, [_s291["t"]])
	if J.t((_t807 if J.t(_t807) else J.gp(J.gp(_s291["__p"]["R"], "kings"), _s291["t"]))):
		return null
	var _t808 = _s291["__p"]["kingDef"]
	v_d_867 = J.cl(_t808, null, [_s291["t"]])
	if (not J.t(v_d_867)):
		return null
	var _t809 = _s291["__p"]["lairPos"]
	_s291["lp"] = J.cl(_t809, null, [_s291["t"]])
	var _t810 = _s291["__p"]["terP"]
	_s291["p"] = J.cl(_t810, null, [J.gp(_s291["__p"]["R"], "ci"), _s291["t"]])
	_s291["arr"] = []
	var _t811 = _s291["__p"]["fodOf"]
	v_pool_871 = J.cl(_t811, null, [J.gp(_s291["__p"]["R"], "ci")])
	v_mk_872 = Callable(self, "_f178").bind(_s291)
	J.cl(v_mk_872, null, [J.gp(v_d_867, "big"), true, ((-55.0) if J.t(J.gp(v_d_867, "small")) else 0.0), "大王"])
	J.cl(v_mk_872, null, [J.gp(v_d_867, "small"), (not J.t(J.gp(v_d_867, "big"))), (60.0 if J.t(J.gp(v_d_867, "big")) else 0.0), ("守寶鬼" if J.t(J.gp(v_d_867, "guard")) else ("小王" if J.t(J.gp(v_d_867, "big")) else "地頭王"))])
	v_i_878 = 0.0
	while true:
		if not J.cmp(v_i_878, (2.0 + J.min_([3.0, _s291["t"]])), "<"): break
		v_k_879 = J.gp(v_pool_871, J.mod(J.add(v_i_878, _s291["t"]), J.len(v_pool_871)))
		var _t822 = _s291["__p"]["foe"]
		v_e_880 = J.cl(_t822, null, [v_k_879, _s291["p"], {"hp": 1.4, "atk": 1.1}, {"king": _s291["t"], "minion": true}])
		v_a_881 = ((J.div(v_i_878, (2.0 + J.min_([3.0, _s291["t"]]))) * PI) * 2.0)
		var _t823 = J.add(J.gp(_s291["lp"], "x"), (cos(J.num(v_a_881)) * 110.0))
		J.sp(v_e_880, "x", _t823)
		var _t824 = J.add(J.gp(_s291["lp"], "y"), (sin(J.num(v_a_881)) * 70.0))
		J.sp(v_e_880, "y", _t824)
		var _t825 = J.gp(v_e_880, "x")
		J.sp(v_e_880, "hx", _t825)
		var _t826 = J.gp(v_e_880, "y")
		J.sp(v_e_880, "hy", _t826)
		J.mc(_s291["arr"], "push", [v_e_880])
		v_i_878 = J.num(v_i_878) + 1.0
	J.mc(_s291["arr"], "forEach", [Callable(self, "_f179").bind(_s291)])
	var _t828 = J.gp(_s291["__p"]["R"], "kings")
	var _t829 = _s291["t"]
	var _t830 = _s291["arr"]
	J.sp(_t828, _t829, _t830)

func _f181(this_, a: Array, env):
	var v_f_892 = null; var v_n_893 = null
	v_f_892 = J.arg(a, 0)
	v_n_893 = (6.0 + J.mul(J.gp(env["R"], "ci"), 3.0))
	var _t842 = J.gp(env["R"], "loot")
	var _t843 = J.add(J.gp(_t842, v_f_892), v_n_893)
	J.sp(_t842, v_f_892, _t843)
	var _t844 = J.gp(J.cl(env["st"], null, []), "mats")
	var _t845 = J.add(J.gp(_t844, v_f_892), v_n_893)
	J.sp(_t844, v_f_892, _t845)

func _f183(this_, a: Array, env):
	var v_g_896 = null
	v_g_896 = J.arg(a, 0)
	return J.seq(J.gp(v_g_896, "k"), env["k"])

func _f182(this_, a: Array, env):
	var _s302 = {"__p": env, "k": null}
	_s302["k"] = J.arg(a, 0)
	var _t851 = (J.gp(J.G.get("GHOSTS"), _s302["k"]) if J.t(_s302["k"]) else _s302["k"])
	var _t853 = (J.seq(J.gp(J.gp(J.G.get("GHOSTS"), _s302["k"]), "q"), "名") if J.t(_t851) else _t851)
	if J.t(_t853):
		var _t852 = J.gp(J.G.get("S"), "ghosts")
		_t853 = (not J.t(J.mc(_t852, "some", [Callable(self, "_f183").bind(_s302)])))
	return _t853

func _f185(this_, a: Array, env):
	var _t859 = J.G.get("joinGhost")
	J.cl(_t859, null, [env["k"]])
	J.cl(J.G.get("save"), null, [])

func _f184(this_, a: Array, env):
	var _s304 = {"__p": env, "k": null}
	_s304["k"] = J.arg(a, 0)
	var _t856 = J.gp(J.gp(J.G.get("GHOSTS"), _s304["k"]), "name")
	var _t854 = J.G.get("L")
	var _t855 = J.gp(J.gp(J.G.get("GHOSTS"), _s304["k"]), "say")
	var _t858 = ["旁白", (J.str(_t856) + "：「" + J.str(J.cl(_t854, null, [(_t855 if J.t(_t855) else "")])) + "」")]
	var _t857 = _s304["__p"]["T"]
	return J.mc(J.G.get("Story"), "queue", [{"style": "narr", "lines": [_t858, ["旁白", J.cl(_t857, null, [(J.str(J.gp(J.gp(J.G.get("GHOSTS"), _s304["k"]), "name")) + "輸咗地頭，決定跟你返落魄村。"), (J.str(J.gp(J.gp(J.G.get("GHOSTS"), _s304["k"]), "name")) + "輸了地頭，決定跟你回落魄村。")])]]}, Callable(self, "_f185").bind(_s304)])

func _f180(this_, a: Array, env):
	var v_t_885 = null; var v_rs_886 = null; var v_d_887 = null; var v_first_888 = null; var v_p_889 = null; var v_rew_890 = null; var v_join_891 = null; var v_e_894 = null
	v_t_885 = J.arg(a, 0)
	var _t831 = env["regSt"]
	v_rs_886 = J.cl(_t831, null, [J.gp(env["R"], "ci")])
	var _t832 = env["kingDef"]
	var _t833 = J.cl(_t832, null, [v_t_885])
	v_d_887 = (_t833 if J.t(_t833) else {})
	v_first_888 = (not J.t(J.gp(J.gp(v_rs_886, "kings"), v_t_885)))
	var _t834 = J.gp(v_rs_886, "kings")
	var _t835 = J.S_Date_("now", [])
	J.sp(_t834, v_t_885, _t835)
	var _t836 = env["terP"]
	v_p_889 = J.cl(_t836, null, [J.gp(env["R"], "ci"), v_t_885])
	v_rew_890 = {"coins": J.round(J.num((60.0 + J.mul(45.0, v_p_889)))), "exp": J.round(J.num((25.0 + J.mul(18.0, v_p_889))))}
	var _t837 = env["gain"]
	J.cl(_t837, null, [v_rew_890])
	if J.t(v_first_888):
		var _t839 = J.gp(J.G.get("S"), "chests")
		var _t838 = J.gp(v_d_887, "big")
		var _t840 = ("p" if J.t((_t838 if J.t(_t838) else J.gp(v_d_887, "guard"))) else "b")
		J.sp(_t839, _t840, J.num(J.gp(_t839, _t840)) + 1.0)
		if J.t(J.gp(v_d_887, "guard")):
			var _t841 = J.S_Object_("keys", [env["FAC"]])
			J.mc(_t841, "forEach", [Callable(self, "_f181").bind(env)])
	J.mc(J.G.get("Sound"), "play", ["win"])
	var _t846 = env["spr"]
	J.cl(_t846, null, ["fx_scream", J.gp(J.gp(env["R"], "L"), "x"), J.sub(J.gp(J.gp(env["R"], "L"), "y"), 40.0), {"s0": 0.4, "s1": 2.2, "life": 0.8}])
	var _t847 = env["spr"]
	J.cl(_t847, null, ["fx_gold", J.gp(J.gp(env["R"], "L"), "x"), J.sub(J.gp(J.gp(env["R"], "L"), "y"), 60.0), {"s0": 0.4, "s1": 0.9, "life": 1.0}])
	var _t848 = env["R"]
	J.sp(_t848, "flash", 0.4)
	J.mc(J.G.get("Fx"), "banner", [(("秘境寶物到手：" + J.str(J.gp(J.gp(env["TNAME"], J.gp(env["R"], "ci")), v_t_885)) + "！") if J.t(J.gp(v_d_887, "guard")) else ("拿下地頭：" + J.str(J.gp(J.gp(env["TNAME"], J.gp(env["R"], "ci")), v_t_885)) + "！"))])
	var _t849 = env["emit"]
	J.cl(_t849, null, ["king", {"ci": J.gp(env["R"], "ci"), "t": v_t_885}])
	J.mc(J.G.get("Fx"), "toast", [("地頭王擊破：冥幣 +" + J.str(J.gp(v_rew_890, "coins")) + "，好評 +" + J.str(J.gp(v_rew_890, "exp")) + (("，" + ("紫" if J.t(J.gp(v_d_887, "big")) else "藍") + "箱 ×1") if J.t(v_first_888) else "") + "。相連的閘口開了。")])
	var _t850 = [J.gp(v_d_887, "big"), J.gp(v_d_887, "small")]
	v_join_891 = J.mc(_t850, "filter", [Callable(self, "_f182").bind(env)])
	J.mc(v_join_891, "forEach", [Callable(self, "_f184").bind(env)])
	J.cl(env["persist"], null, [])
	J.cl(J.G.get("save"), null, [])
	J.mc(J.G.get("UI"), "refresh", [])

func _f187(this_, a: Array, env):
	var v_e_911 = null
	v_e_911 = J.arg(a, 0)
	var _t874 = J.gp(env["R"], "foes")
	return J.mc(_t874, "push", [v_e_911])

func _f186(this_, a: Array, env):
	var v_z_900 = null; var v_cell_901 = null; var v_x_902 = null; var v_y_903 = null; var v_p_904 = null; var v_pool_905 = null; var v_arr_906 = null; var v_b_907 = null; var v_i_908 = null; var v_k_909 = null; var v_e_910 = null
	v_z_900 = J.arg(a, 0)
	var _t860 = J.gp(env["R"], "bryan")
	var _t861 = (_t860 if J.t(_t860) else J.gp(env["R"], "bryanDone"))
	var _t863 = (_t861 if J.t(_t861) else (not J.t(J.gp(env["R"], "bryanWant"))))
	if not J.t(_t863):
		var _t862 = env["terOf"]
		_t863 = J.cmp(J.cl(_t862, null, [v_z_900]), 1.0, "<")
	if J.t(_t863):
		return null
	var _t864 = env["zoneCell"]
	v_cell_901 = J.cl(_t864, null, [v_z_900])
	v_x_902 = J.add(J.gp(v_cell_901, "x"), ((randf() - 0.5) * 300.0))
	v_y_903 = J.add(J.gp(v_cell_901, "y"), ((randf() - 0.5) * 240.0))
	if (J.hypot_([J.sub(v_x_902, J.gp(J.gp(env["R"], "L"), "x")), J.sub(v_y_903, J.gp(J.gp(env["R"], "L"), "y"))]) < 420.0):
		return null
	var _t865 = env["zoneP"]
	v_p_904 = J.add(J.cl(_t865, null, [J.gp(env["R"], "ci"), v_z_900]), 0.6)
	var _t866 = env["fodOf"]
	v_pool_905 = J.cl(_t866, null, [J.gp(env["R"], "ci")])
	v_arr_906 = []
	var _t867 = env["foe"]
	v_b_907 = J.cl(_t867, null, ["npc_rival", v_p_904, {"hp": 2.6, "atk": 1.2}, {"bryan": true, "name": "Bryan"}])
	J.sp(v_b_907, "k", "npc_rival")
	J.sp(v_b_907, "name", "Bryan")
	J.sp(v_b_907, "fac", "yuan")
	J.sp(v_b_907, "rng", 44.0)
	J.sp(v_b_907, "s", 0.62)
	J.sp(v_b_907, "x", v_x_902)
	J.sp(v_b_907, "y", v_y_903)
	J.sp(v_b_907, "hx", v_x_902)
	J.sp(v_b_907, "hy", v_y_903)
	J.mc(v_arr_906, "push", [v_b_907])
	v_i_908 = 0.0
	while true:
		if not J.cmp(v_i_908, 4.0, "<"): break
		v_k_909 = J.gp(v_pool_905, floor(J.num((randf() * J.len(v_pool_905)))))
		var _t868 = env["foe"]
		v_e_910 = J.cl(_t868, null, [v_k_909, v_p_904, {"hp": 1.3, "atk": 1.1}, {"bryan": true}])
		var _t869 = J.add("夜冷村", J.gp(v_e_910, "name"))
		J.sp(v_e_910, "name", _t869)
		var _t870 = J.add(v_x_902, (cos(J.num(J.mul(v_i_908, 1.6))) * 60.0))
		J.sp(v_e_910, "x", _t870)
		var _t871 = J.add(v_y_903, (sin(J.num(J.mul(v_i_908, 1.6))) * 40.0))
		J.sp(v_e_910, "y", _t871)
		var _t872 = J.gp(v_e_910, "x")
		J.sp(v_e_910, "hx", _t872)
		var _t873 = J.gp(v_e_910, "y")
		J.sp(v_e_910, "hy", _t873)
		J.mc(v_arr_906, "push", [v_e_910])
		v_i_908 = J.num(v_i_908) + 1.0
	J.mc(v_arr_906, "forEach", [Callable(self, "_f187").bind(env)])
	var _t875 = env["R"]
	J.sp(_t875, "bryan", v_arr_906)
	var _t876 = env["msg"]
	var _t877 = env["T"]
	J.cl(_t876, null, [J.cl(_t877, null, ["Bryan：「哦？阿福部門都有出嚟巡？你啲人睇落好攰喎，不如過嚟我度？」", "Bryan：「哦？阿福部門也出來巡？你的人看起來很累，不如過來我這邊？」"]), 4.0])

func _f188(this_, a: Array, env):
	var v_u_914 = null; var v_dvx_915 = null; var v_dvy_916 = null; var v_dt_917 = null; var v_acc_918 = null; var v_ax_919 = null; var v_ay_920 = null; var v_a_921 = null; var v_m_922 = null
	v_u_914 = J.arg(a, 0)
	v_dvx_915 = J.arg(a, 1)
	v_dvy_916 = J.arg(a, 2)
	v_dt_917 = J.arg(a, 3)
	v_acc_918 = J.arg(a, 4)
	v_ax_919 = J.sub(v_dvx_915, J.gp(v_u_914, "vx"))
	v_ay_920 = J.sub(v_dvy_916, J.gp(v_u_914, "vy"))
	v_a_921 = J.hypot_([v_ax_919, v_ay_920])
	v_m_922 = J.mul((v_acc_918 if J.t(v_acc_918) else env["ACC"]), v_dt_917)
	if J.cmp(v_a_921, v_m_922, ">"):
		var _t878 = J.add(J.gp(v_u_914, "vx"), J.mul(J.div(v_ax_919, v_a_921), v_m_922))
		J.sp(v_u_914, "vx", _t878)
		var _t879 = J.add(J.gp(v_u_914, "vy"), J.mul(J.div(v_ay_920, v_a_921), v_m_922))
		J.sp(v_u_914, "vy", _t879)
	else:
		J.sp(v_u_914, "vx", v_dvx_915)
		J.sp(v_u_914, "vy", v_dvy_916)

func _f189(this_, a: Array, env):
	var v_u_925 = null; var v_tx_926 = null; var v_ty_927 = null; var v_spd_928 = null; var v_dt_929 = null; var v_arrive_930 = null; var v_dx_931 = null; var v_dy_932 = null; var v_d_933 = null; var v_s_934 = null
	v_u_925 = J.arg(a, 0)
	v_tx_926 = J.arg(a, 1)
	v_ty_927 = J.arg(a, 2)
	v_spd_928 = J.arg(a, 3)
	v_dt_929 = J.arg(a, 4)
	v_arrive_930 = J.arg(a, 5)
	v_dx_931 = J.sub(v_tx_926, J.gp(v_u_925, "x"))
	v_dy_932 = J.sub(v_ty_927, J.gp(v_u_925, "y"))
	v_d_933 = J.hypot_([v_dx_931, v_dy_932])
	if J.cmp(v_d_933, 2.0, "<"):
		var _t880 = env["approachV"]
		J.cl(_t880, null, [v_u_925, 0.0, 0.0, v_dt_929])
		return null
	v_s_934 = (J.min_([v_spd_928, J.div(J.mul(v_spd_928, v_d_933), v_arrive_930)]) if J.t(v_arrive_930) else v_spd_928)
	var _t881 = env["approachV"]
	J.cl(_t881, null, [v_u_925, J.mul(J.div(v_dx_931, v_d_933), v_s_934), J.mul(J.div(v_dy_932, v_d_933), v_s_934), v_dt_929])

func _f190(this_, a: Array, env):
	var v_u_937 = null; var v_dt_938 = null; var v_sp_939 = null; var v_nx_940 = null; var v_ny_941 = null; var v_f_942 = null
	v_u_937 = J.arg(a, 0)
	v_dt_938 = J.arg(a, 1)
	v_sp_939 = J.hypot_([J.gp(v_u_937, "vx"), J.gp(v_u_937, "vy")])
	var _t882 = J.cmp(v_sp_939, 16.0, ">")
	J.sp(v_u_937, "moving", _t882)
	var _t883 = (absf(J.num(J.gp(v_u_937, "vx"))) > 14.0)
	if ((not J.t(J.gp(v_u_937, "act"))) if _t883 else _t883):
		var _t884 = J.cmp(J.gp(v_u_937, "vx"), 0.0, "<")
		J.sp(v_u_937, "flip", _t884)
	v_nx_940 = J.add(J.gp(v_u_937, "x"), J.mul(J.gp(v_u_937, "vx"), v_dt_938))
	v_ny_941 = J.add(J.gp(v_u_937, "y"), J.mul(J.gp(v_u_937, "vy"), v_dt_938))
	if J.t(J.gp(v_u_937, "kb")):
		var _t885 = J.add(v_nx_940, J.mul(J.gp(J.gp(v_u_937, "kb"), "x"), v_dt_938))
		v_nx_940 = _t885
		var _t886 = J.add(v_ny_941, J.mul(J.gp(J.gp(v_u_937, "kb"), "y"), v_dt_938))
		v_ny_941 = _t886
		v_f_942 = pow(J.num(0.002), J.num(v_dt_938))
		var _t887 = J.gp(v_u_937, "kb")
		var _t888 = J.mul(J.gp(_t887, "x"), v_f_942)
		J.sp(_t887, "x", _t888)
		var _t889 = J.gp(v_u_937, "kb")
		var _t890 = J.mul(J.gp(_t889, "y"), v_f_942)
		J.sp(_t889, "y", _t890)
		if (J.hypot_([J.gp(J.gp(v_u_937, "kb"), "x"), J.gp(J.gp(v_u_937, "kb"), "y")]) < 6.0):
			J.sp(v_u_937, "kb", null)
	var _t891 = env["moveTo"]
	J.cl(_t891, null, [v_u_937, v_nx_940, v_ny_941])
	var _t894 = J.gp(v_u_937, "moving")
	if J.t(_t894):
		var _t892 = J.gp(v_u_937, "leader")
		var _t893 = (_t892 if J.t(_t892) else J.seq(J.gp(v_u_937, "role"), "lead"))
		_t894 = (_t893 if J.t(_t893) else J.gp(v_u_937, "boss"))
	if J.t(_t894):
		var _t895 = J.gp(v_u_937, "stepT")
		var _t896 = J.add((_t895 if J.t(_t895) else 0.0), J.div(J.mul(v_dt_938, v_sp_939), 55.0))
		J.sp(v_u_937, "stepT", _t896)
		if J.cmp(J.gp(v_u_937, "stepT"), 1.0, ">"):
			J.sp(v_u_937, "stepT", 0.0)
			var _t897 = env["dust"]
			J.cl(_t897, null, [J.add(J.gp(v_u_937, "x"), ((randf() - 0.5) * 8.0)), J.gp(v_u_937, "y"), (0.9 if J.t(J.gp(v_u_937, "boss")) else 0.5)])

func _f191(this_, a: Array, env):
	var v_u_945 = null; var v_L_946 = null; var v_dt_947 = null; var v_rg_948 = null; var v_lv_949 = null; var v_lm_950 = null; var v_tx_951 = null; var v_ty_952 = null; var v_d_953 = null; var v_dl_954 = null; var v_far_955 = null; var v_spd_956 = null; var v_a_957 = null; var v_r_958 = null
	v_u_945 = J.arg(a, 0)
	v_L_946 = J.arg(a, 1)
	v_dt_947 = J.arg(a, 2)
	var _t898 = J.gp(env["RING"], J.gp(v_u_945, "role"))
	v_rg_948 = (_t898 if J.t(_t898) else J.gp(env["RING"], "crew"))
	v_lv_949 = J.hypot_([J.gp(v_L_946, "vx"), J.gp(v_L_946, "vy")])
	v_lm_950 = J.cmp(v_lv_949, 40.0, ">")
	var _t899 = J.gp(v_u_945, "wtT")
	var _t900 = J.sub((_t899 if J.t(_t899) else 0.0), v_dt_947)
	J.sp(v_u_945, "wtT", _t900)
	var _t901 = (not J.t(J.gp(v_u_945, "wt")))
	var _t902 = (_t901 if _t901 else J.cmp(J.gp(v_u_945, "wtT"), 0.0, "<="))
	if J.t((_t902 if _t902 else ((not J.t(J.gp(J.gp(v_u_945, "wt"), "mv"))) if J.t(v_lm_950) else v_lm_950))):
		v_a_957 = ((randf() * PI) * 2.0)
		if J.t(v_lm_950):
			var _t903 = (atan2(J.num((-J.num(J.gp(v_L_946, "vy")))), J.num((-J.num(J.gp(v_L_946, "vx"))))) + ((randf() - 0.5) * 2.6))
			v_a_957 = _t903
		v_r_958 = J.add(J.gp(v_rg_948, 0.0), (randf() * J.sub(J.gp(v_rg_948, 1.0), J.gp(v_rg_948, 0.0))))
		var _t904 = {"x": J.mul(cos(J.num(v_a_957)), v_r_958), "y": (J.mul(sin(J.num(v_a_957)), v_r_958) * 0.6), "mv": v_lm_950}
		J.sp(v_u_945, "wt", _t904)
		var _t905 = ((0.7 + (randf() * 1.1)) if J.t(v_lm_950) else (1.8 + (randf() * 3.8)))
		J.sp(v_u_945, "wtT", _t905)
	v_tx_951 = J.add(J.gp(v_L_946, "x"), J.gp(J.gp(v_u_945, "wt"), "x"))
	v_ty_952 = J.add(J.gp(v_L_946, "y"), J.gp(J.gp(v_u_945, "wt"), "y"))
	v_d_953 = J.hypot_([J.sub(v_tx_951, J.gp(v_u_945, "x")), J.sub(v_ty_952, J.gp(v_u_945, "y"))])
	v_dl_954 = J.hypot_([J.sub(J.gp(v_L_946, "x"), J.gp(v_u_945, "x")), J.sub(J.gp(v_L_946, "y"), J.gp(v_u_945, "y"))])
	if J.cmp(v_dl_954, 900.0, ">"):
		J.sp(v_u_945, "x", v_tx_951)
		J.sp(v_u_945, "y", v_ty_952)
		J.sp(v_u_945, "vy", 0.0)
		J.sp(v_u_945, "vx", 0.0)
		return null
	if J.cmp(v_d_953, 9.0, "<"):
		var _t906 = env["approachV"]
		J.cl(_t906, null, [v_u_945, 0.0, 0.0, v_dt_947])
		var _t907 = (not J.t(v_lm_950))
		if ((randf() < J.mul(v_dt_947, 0.35)) if _t907 else _t907):
			var _t908 = (not J.t(J.gp(v_u_945, "flip")))
			J.sp(v_u_945, "flip", _t908)
		return null
	v_far_955 = J.cmp(v_dl_954, J.add(J.gp(v_rg_948, 1.0), 50.0), ">")
	var _t913 = null
	if J.t(v_far_955):
		_t913 = J.mul(J.gp(v_u_945, "spd"), 1.6)
	else:
		var _t912 = null
		if J.t(v_lm_950):
			_t912 = J.max_([J.mul(J.gp(v_u_945, "spd"), 0.7), J.mul(v_lv_949, 1.08)])
		else:
			var _t911 = J.gp(v_u_945, "spd")
			var _t909 = J.gp(v_u_945, "ti")
			var _t910 = (_t909 if J.t(_t909) else J.gp(v_u_945, "slot"))
			_t912 = J.mul(_t911, (0.35 + J.div((0.25 * J.mod((_t910 if J.t(_t910) else 1.0), 3.0)), 2.0)))
		_t913 = _t912
	v_spd_956 = _t913
	var _t914 = env["steer"]
	J.cl(_t914, null, [v_u_945, v_tx_951, v_ty_952, v_spd_956, v_dt_947, (30.0 if J.t(v_lm_950) else 50.0)])

func _f193(this_, a: Array, env):
	var v_f_977 = null
	v_f_977 = J.arg(a, 0)
	if J.seq(J.gp(v_f_977, "kind"), "num"):
		var _t918 = J.add(J.gp(v_f_977, "t"), J.mul(env["dt"], 0.2))
		J.sp(v_f_977, "t", _t918)

func _f194(this_, a: Array, env):
	var v_k_988 = null
	v_k_988 = J.arg(a, 0)
	return (J.gp(J.gp(J.G.get("GHOSTS"), v_k_988), "name") if J.t(J.gp(J.G.get("GHOSTS"), v_k_988)) else v_k_988)

func _f195(this_, a: Array, env):
	var _t987 = env["__p"]["__p"]["msg"]
	return J.cl(_t987, null, [("新面孔出沒：<b>" + J.str(J.gp(J.gp(J.G.get("GHOSTS"), env["ek"]), "name")) + "</b>（" + J.str(J.gp(J.gp(J.G.get("GHOSTS"), env["ek"]), "title")) + "）"), 3.0])

func _f196(this_, a: Array, env):
	var v_e_997 = null
	v_e_997 = J.arg(a, 0)
	var _t1007 = (not J.leq(J.gp(v_e_997, "guard"), null))
	var _t1008 = (_t1007 if _t1007 else J.gp(v_e_997, "bryan"))
	var _t1009 = (_t1008 if J.t(_t1008) else J.gp(v_e_997, "ot"))
	if J.t((_t1009 if J.t(_t1009) else (not J.leq(J.gp(v_e_997, "king"), null)))):
		return true
	var _t1010 = J.gp(env["__p"]["R"], "near")
	var _t1011 = (_t1010 if J.t(_t1010) else [])
	var _t1012 = (not J.t(J.mc(_t1011, "includes", [J.gp(v_e_997, "z")])))
	if ((J.hypot_([J.sub(J.gp(v_e_997, "x"), J.gp(env["L"], "x")), J.sub(J.gp(v_e_997, "y"), J.gp(env["L"], "y"))]) > 1200.0) if _t1012 else _t1012):
		J.sp(v_e_997, "gone", 1.0)
		return false
	return true

func _f198(this_, a: Array, env):
	var v_e_1000 = null
	v_e_1000 = J.arg(a, 0)
	var _t1017 = (not J.t(J.gp(v_e_1000, "gone")))
	var _t1018 = ((not J.t(J.gp(v_e_1000, "fled"))) if _t1017 else _t1017)
	return ((not J.t(J.gp(v_e_1000, "done"))) if _t1018 else _t1018)

func _f197(this_, a: Array, env):
	var v_pk_999 = null
	v_pk_999 = J.arg(a, 0)
	return J.mc(v_pk_999, "filter", [Callable(self, "_f198").bind(env)])

func _f199(this_, a: Array, env):
	var v_pk_1001 = null
	v_pk_1001 = J.arg(a, 0)
	return J.len(v_pk_1001)

func _f200(this_, a: Array, env):
	var _t1031 = env["__p"]["R"]
	J.sp(_t1031, "beforeQ", 0.0)

func _f201(this_, a: Array, env):
	var v_e_1007 = null
	v_e_1007 = J.arg(a, 0)
	J.sp(v_e_1007, "awake", true)
	return true

func _f202(this_, a: Array, env):
	var v_u_1008 = null
	v_u_1008 = J.arg(a, 0)
	var _t1038 = J.cmp(J.gp(v_u_1008, "hp"), 0.0, ">")
	return ((not J.t(J.gp(v_u_1008, "gone"))) if _t1038 else _t1038)

func _f203(this_, a: Array, env):
	var v_e_1009 = null
	v_e_1009 = J.arg(a, 0)
	var _t1040 = J.cmp(J.gp(v_e_1009, "hp"), 0.0, ">")
	var _t1045 = ((not J.t(J.gp(v_e_1009, "fled"))) if _t1040 else _t1040)
	if J.t(_t1045):
		var _t1041 = (not J.seq(env["ph"], "work"))
		var _t1042 = (_t1041 if _t1041 else J.gp(v_e_1009, "provoked"))
		var _t1043 = (_t1042 if J.t(_t1042) else (not J.leq(J.gp(v_e_1009, "guard"), null)))
		var _t1044 = (_t1043 if J.t(_t1043) else J.gp(v_e_1009, "bryan"))
		_t1045 = (_t1044 if J.t(_t1044) else (J.hypot_([J.sub(J.gp(v_e_1009, "x"), J.gp(env["L"], "x")), J.sub(J.gp(v_e_1009, "y"), J.gp(env["L"], "y"))]) < 110.0))
	return _t1045

func _f204(this_, a: Array, env):
	var v_e_1010 = null
	v_e_1010 = J.arg(a, 0)
	var _t1047 = J.cmp(J.gp(v_e_1010, "hp"), 0.0, ">")
	var _t1048 = ((not J.t(J.gp(v_e_1010, "fled"))) if _t1047 else _t1047)
	var _t1050 = ((not J.cmp(J.gp(v_e_1010, "down"), 0.0, ">")) if _t1048 else _t1048)
	if J.t(_t1050):
		var _t1049 = J.gp(v_e_1010, "provoked")
		_t1050 = (_t1049 if J.t(_t1049) else J.gp(v_e_1010, "awake"))
	return ((J.hypot_([J.sub(J.gp(v_e_1010, "x"), J.gp(env["L"], "x")), J.sub(J.gp(v_e_1010, "y"), J.gp(env["L"], "y"))]) < 420.0) if J.t(_t1050) else _t1050)

func _f205(this_, a: Array, env):
	var v_t_1016 = null
	v_t_1016 = J.arg(a, 0)
	return (J.hypot_([J.div(J.sub(J.gp(env["u"], "x"), J.gp(v_t_1016, "x")), J.gp(v_t_1016, "r")), J.div(J.sub(J.gp(env["u"], "y"), J.gp(v_t_1016, "y")), J.mul(J.gp(v_t_1016, "r"), 0.6))]) < 1.05)

func _f206(this_, a: Array, env):
	var v_t_1034 = null; var v_src_1035 = null; var v_u_1036 = null; var v_e_1037 = null
	v_t_1034 = J.arg(a, 0)
	var _t1182 = J.add(J.gp(v_t_1034, "t"), env["dt"])
	J.sp(v_t_1034, "t", _t1182)
	if J.cmp(J.gp(v_t_1034, "t"), J.gp(v_t_1034, "dur"), "<"):
		return true
	v_src_1035 = J.gp(v_t_1034, "src")
	var _t1183 = J.cmp(J.gp(v_src_1035, "hp"), 0.0, ">")
	if ((not J.cmp(J.gp(v_src_1035, "down"), 0.0, ">")) if _t1183 else _t1183):
		var _t1184 = env["__p"]["R"]
		J.sp(_t1184, "shake", 9.0)
		var _t1185 = env["__p"]["dust"]
		J.cl(_t1185, null, [J.sub(J.gp(v_t_1034, "x"), 20.0), J.gp(v_t_1034, "y"), 1.6])
		var _t1186 = env["__p"]["dust"]
		J.cl(_t1186, null, [J.add(J.gp(v_t_1034, "x"), 20.0), J.gp(v_t_1034, "y"), 1.4])
		var _t1187 = env["__p"]["img"]
		if J.t(J.cl(_t1187, null, ["fx_shock"])):
			var _t1188 = env["__p"]["spr"]
			J.cl(_t1188, null, ["fx_shock", J.gp(v_t_1034, "x"), J.gp(v_t_1034, "y"), {"ground": true, "s0": J.div(J.mul(J.gp(v_t_1034, "r"), 1.4), 256.0), "s1": J.div(J.mul(J.gp(v_t_1034, "r"), 2.3), 256.0), "life": 0.5}])
		else:
			var _t1189 = J.gp(env["__p"]["R"], "fx")
			J.mc(_t1189, "push", [{"kind": "ring", "x": J.gp(v_t_1034, "x"), "y": J.gp(v_t_1034, "y"), "t": 0.0, "life": 0.4, "col": "#ff6a4a", "r": J.gp(v_t_1034, "r")}])
		for _t1190 in J.iter(J.gp(env["__p"]["R"], "units")):
			v_u_1036 = _t1190
			var _t1191 = J.cmp(J.gp(v_u_1036, "hp"), 0.0, ">")
			var _t1192 = ((not J.t(J.gp(v_u_1036, "inv"))) if _t1191 else _t1191)
			if ((J.hypot_([J.div(J.sub(J.gp(v_u_1036, "x"), J.gp(v_t_1034, "x")), J.gp(v_t_1034, "r")), J.div(J.sub(J.gp(v_u_1036, "y"), J.gp(v_t_1034, "y")), J.mul(J.gp(v_t_1034, "r"), 0.6))]) < 1.0) if _t1192 else _t1192):
				var _t1193 = env["__p"]["hit"]
				J.cl(_t1193, null, [v_src_1035, v_u_1036, 2.2, {"kb": 260.0, "from": v_t_1034}])
		J.mc(J.G.get("Sound"), "play", ["skill"])
	return false

func _f207(this_, a: Array, env):
	var v_e_1038 = null
	v_e_1038 = J.arg(a, 0)
	var _t1196 = J.cmp(J.gp(v_e_1038, "hp"), 0.0, ">")
	var _t1197 = ((not J.t(J.gp(v_e_1038, "fled"))) if _t1196 else _t1196)
	return ((not J.cmp(J.gp(v_e_1038, "down"), 0.0, ">")) if _t1197 else _t1197)

func _f208(this_, a: Array, env):
	var v_q_1048 = null; var v_v_1049 = null; var v_ty_1050 = null; var v_dx_1051 = null; var v_dy_1052 = null; var v_d_1053 = null; var v_stp_1054 = null
	v_q_1048 = J.arg(a, 0)
	v_v_1049 = J.gp(v_q_1048, "tg")
	var _t1205 = (not J.t(v_v_1049))
	var _t1206 = (_t1205 if _t1205 else J.cmp(J.gp(v_v_1049, "hp"), 0.0, "<="))
	if (_t1206 if _t1206 else J.cmp(J.gp(v_v_1049, "down"), 0.0, ">")):
		var _t1207 = J.gp(v_q_1048, "dead")
		var _t1208 = J.add((_t1207 if J.t(_t1207) else 0.0), env["dt"])
		J.sp(v_q_1048, "dead", _t1208)
		return J.cmp(J.gp(v_q_1048, "dead"), 0.15, "<")
	v_ty_1050 = J.sub(J.gp(v_v_1049, "y"), (J.mul(34.0, J.gp(v_v_1049, "s")) * 1.65))
	v_dx_1051 = J.sub(J.gp(v_v_1049, "x"), J.gp(v_q_1048, "x"))
	v_dy_1052 = J.sub(v_ty_1050, J.gp(v_q_1048, "y"))
	v_d_1053 = J.hypot_([v_dx_1051, v_dy_1052])
	v_stp_1054 = J.mul(J.gp(v_q_1048, "spd"), env["dt"])
	var _t1209 = J.gp(v_q_1048, "trail")
	J.mc(_t1209, "push", [[J.gp(v_q_1048, "x"), J.gp(v_q_1048, "y")]])
	if (J.len(J.gp(v_q_1048, "trail")) > 7.0):
		J.mc(J.gp(v_q_1048, "trail"), "shift", [])
	if J.cmp(v_d_1053, J.add(v_stp_1054, 6.0), "<="):
		var _t1210 = env["__p"]["hit"]
		var _t1212 = J.gp(v_q_1048, "src")
		var _t1211 = J.gp(v_q_1048, "mult")
		J.cl(_t1210, null, [_t1212, v_v_1049, (_t1211 if J.t(_t1211) else 1.0)])
		var _t1213 = env["__p"]["spr"]
		var _t1218 = J.gp(v_q_1048, "x")
		var _t1219 = J.gp(v_q_1048, "y")
		var _t1217 = J.gp(v_q_1048, "hue")
		var _t1214 = J.gp(v_q_1048, "vy")
		var _t1216 = (_t1214 if J.t(_t1214) else 0.0)
		var _t1215 = J.gp(v_q_1048, "vx")
		J.cl(_t1213, null, ["fx_fire", _t1218, _t1219, {"s0": 0.12, "s1": 0.26, "life": 0.18, "hue": _t1217, "rot": (atan2(J.num(_t1216), J.num((_t1215 if J.t(_t1215) else 1.0))) + PI)}])
		return false
	J.sp(v_q_1048, "vx", v_dx_1051)
	J.sp(v_q_1048, "vy", v_dy_1052)
	var _t1220 = J.add(J.gp(v_q_1048, "x"), J.mul(J.div(v_dx_1051, v_d_1053), v_stp_1054))
	J.sp(v_q_1048, "x", _t1220)
	var _t1221 = J.add(J.gp(v_q_1048, "y"), (J.mul(J.div(v_dy_1052, v_d_1053), v_stp_1054) + (sin(J.num(J.add(J.mul(J.gp(env["__p"]["R"], "t"), 18.0), J.gp(v_q_1048, "ph")))) * 0.8)))
	J.sp(v_q_1048, "y", _t1221)
	return true

func _f209(this_, a: Array, env):
	var v_e_1057 = null
	v_e_1057 = J.arg(a, 0)
	var _t1232 = J.cmp(J.gp(v_e_1057, "hp"), 0.0, "<=")
	return ((not J.cmp(J.gp(v_e_1057, "down"), 0.0, ">")) if _t1232 else _t1232)

func _f210(this_, a: Array, env):
	var v_g_1059 = null
	v_g_1059 = J.arg(a, 0)
	return J.gp(v_g_1059, "poached")

func _f211(this_, a: Array, env):
	var v_g_1060 = null
	v_g_1060 = J.arg(a, 0)
	J.del(v_g_1060, "poached")
	return true

func _f212(this_, a: Array, env):
	var v_g_1061 = null
	v_g_1061 = J.arg(a, 0)
	return J.gp(v_g_1061, "name")

func _f213(this_, a: Array, env):
	var v_g_1062 = null
	v_g_1062 = J.arg(a, 0)
	return J.gp(v_g_1062, "name")

func _f214(this_, a: Array, env):
	var v_e_1063 = null
	v_e_1063 = J.arg(a, 0)
	var _t1247 = J.cmp(J.gp(v_e_1063, "hp"), 0.0, "<=")
	var _t1248 = (_t1247 if _t1247 else J.gp(v_e_1063, "fled"))
	var _t1250 = ((not J.cmp(J.gp(v_e_1063, "down"), 0.0, ">")) if J.t(_t1248) else _t1248)
	if J.t(_t1250):
		var _t1249 = J.gp(v_e_1063, "deadT")
		_t1250 = J.cmp((_t1249 if J.t(_t1249) else 0.0), 1.5, ">")
	return (not J.t(_t1250))

func _f215(this_, a: Array, env):
	var v_e_1064 = null
	v_e_1064 = J.arg(a, 0)
	var _t1253 = J.cmp(J.gp(v_e_1064, "hp"), 0.0, "<=")
	var _t1254 = (_t1253 if _t1253 else J.gp(v_e_1064, "fled"))
	return ((not J.cmp(J.gp(v_e_1064, "down"), 0.0, ">")) if J.t(_t1254) else _t1254)

func _f216(this_, a: Array, env):
	var v_e_1069 = null
	v_e_1069 = J.arg(a, 0)
	J.sp(v_e_1069, "provoked", true)

func _f217(this_, a: Array, env):
	var v_e_1070 = null
	v_e_1070 = J.arg(a, 0)
	var _t1269 = J.cmp(J.gp(v_e_1070, "hp"), 0.0, "<=")
	return ((not J.cmp(J.gp(v_e_1070, "down"), 0.0, ">")) if _t1269 else _t1269)

func _f218(this_, a: Array, env):
	var v_e_1073 = null
	v_e_1073 = J.arg(a, 0)
	return J.cmp(J.gp(v_e_1073, "hp"), 0.0, "<=")

func _f219(this_, a: Array, env):
	var v_f_1074 = null
	v_f_1074 = J.arg(a, 0)
	var _t1278 = J.add(J.gp(v_f_1074, "t"), env["dt"])
	J.sp(v_f_1074, "t", _t1278)
	return J.cmp(J.gp(v_f_1074, "t"), J.gp(v_f_1074, "life"), "<")

func _f220(this_, a: Array, env):
	var v_q_1075 = null; var v_e_1076 = null
	v_q_1075 = J.arg(a, 0)
	var _t1282 = J.sub(J.gp(v_q_1075, "t"), env["dt"])
	J.sp(v_q_1075, "t", _t1282)
	if J.cmp(J.gp(v_q_1075, "t"), 0.0, ">"):
		return true
	J.mc(v_q_1075, "f", [])
	return false

func _f192(this_, a: Array, env):
	var v_p_962 = null; var v_mx_965 = null; var v_my_966 = null; var v_K_967 = null; var v_ml_968 = null; var v_z_969 = null; var v_tNow_970 = null; var v_party_971 = null; var v_foes_972 = null; var v_calm_973 = null; var v_all_974 = null; var v_lx_975 = null; var v_ly_976 = null; var v_u_978 = null; var v_e_979 = null; var v_dx_980 = null; var v_dy_981 = null; var v_d_982 = null; var v_k_983 = null; var v_e_984 = null; var v_spd_985 = null; var v_d_986 = null; var v_kn_987 = null; var v_zz_990 = null; var v_q_991 = null; var v_c_992 = null; var v_t_993 = null; var v_lp_994 = null; var v_si_995 = null; var v_gp_996 = null; var v_zz_998 = null; var v_si_1002 = null; var v_sid_1003 = null; var v_stg_1004 = null; var v_gp_1005 = null; var v_d_1006 = null; var v_u_1011 = null; var v_tg_1013 = null; var v_tele_1014 = null; var v_tg_1015 = null; var v_dx_1017 = null; var v_dy_1018 = null; var v_d_1019 = null; var v_d_1020 = null; var v_want_1021 = null; var v_side_1022 = null; var v_e_1023 = null; var v_passive_1024 = null; var v_tg_1025 = null; var v_home_1026 = null; var v_spd_1027 = null; var v_d_1028 = null; var v_big_1029 = null; var v_dx_1030 = null; var v_dy_1031 = null; var v_dd_1032 = null; var v_c0_1033 = null; var v_i_1039 = null; var v_j_1040 = null; var v_a_1041 = null; var v_b_1042 = null; var v_R0_1043 = null; var v_dx_1044 = null; var v_dy_1045 = null; var v_d_1046 = null; var v_k_1047 = null; var v_b_1055 = null; var v_u_1056 = null; var v_back_1058 = null; var v_t_1065 = null; var v_g_1066 = null; var v_lp_1067 = null; var v_d_1068 = null; var v_si_1071 = null; var v_g_1072 = null
	var _s323 = {"__p": env, "dt": null, "L": null, "ph": null}
	_s323["dt"] = J.arg(a, 0)
	if J.cmp(J.gp(_s323["__p"]["R"], "stop"), 0.0, ">"):
		var _t915 = _s323["__p"]["R"]
		var _t916 = J.sub(J.gp(_t915, "stop"), _s323["dt"])
		J.sp(_t915, "stop", _t916)
		var _t917 = J.gp(_s323["__p"]["R"], "fx")
		J.mc(_t917, "forEach", [Callable(self, "_f193").bind(_s323)])
		return null
	var _t919 = _s323["__p"]["R"]
	var _t920 = J.add(J.gp(_t919, "t"), _s323["dt"])
	J.sp(_t919, "t", _t920)
	v_p_962 = J.cl(_s323["__p"]["st"], null, [])
	_s323["L"] = J.gp(_s323["__p"]["R"], "L")
	for _t921 in J.iter(J.gp(_s323["__p"]["R"], "units")):
		v_u_978 = _t921
		if J.leq(J.gp(v_u_978, "vx"), null):
			J.sp(v_u_978, "vx", 0.0)
			J.sp(v_u_978, "vy", 0.0)
	for _t922 in J.iter(J.gp(_s323["__p"]["R"], "foes")):
		v_e_979 = _t922
		if J.leq(J.gp(v_e_979, "vx"), null):
			J.sp(v_e_979, "vx", 0.0)
			J.sp(v_e_979, "vy", 0.0)
	var _t923 = J.mod(J.add(J.gp(v_p_962, "min"), J.mul(_s323["dt"], 2.0)), 1440.0)
	J.sp(v_p_962, "min", _t923)
	var _t924 = _s323["__p"]["phase"]
	_s323["ph"] = J.cl(_t924, null, [J.gp(v_p_962, "min")])
	var _t925 = _s323["__p"]["R"]
	var _t926 = J.gp(_s323["__p"]["R"], "shake")
	var _t927 = J.gp(_s323["__p"]["R"], "shake")
	var _t928 = J.max_([0.0, J.sub((_t927 if J.t(_t927) else 0.0), J.mul(_s323["dt"], 30.0))])
	J.sp(_t925, "shake", _t928)
	var _t929 = _s323["__p"]["R"]
	var _t930 = J.gp(_s323["__p"]["R"], "flash")
	var _t931 = J.gp(_s323["__p"]["R"], "flash")
	var _t932 = J.max_([0.0, J.sub((_t931 if J.t(_t931) else 0.0), J.mul(_s323["dt"], 3.0))])
	J.sp(_t929, "flash", _t932)
	if J.cmp(J.gp(_s323["__p"]["R"], "buff"), 0.0, ">"):
		var _t933 = _s323["__p"]["R"]
		var _t934 = J.sub(J.gp(_t933, "buff"), _s323["dt"])
		J.sp(_t933, "buff", _t934)
	var _t935 = _s323["__p"]["R"]
	var _t936 = J.gp(_s323["__p"]["R"], "dashCd")
	var _t937 = J.gp(_s323["__p"]["R"], "dashCd")
	var _t938 = J.max_([0.0, J.sub((_t937 if J.t(_t937) else 0.0), _s323["dt"])])
	J.sp(_t935, "dashCd", _t938)
	var _t939 = _s323["__p"]["R"]
	var _t940 = J.gp(_s323["__p"]["R"], "pieCd")
	var _t941 = J.gp(_s323["__p"]["R"], "pieCd")
	var _t942 = J.max_([0.0, J.sub((_t941 if J.t(_t941) else 0.0), _s323["dt"])])
	J.sp(_t939, "pieCd", _t942)
	v_mx_965 = 0.0
	v_my_966 = 0.0
	if J.t(J.gp(_s323["__p"]["R"], "joy")):
		v_dx_980 = J.sub(J.gp(J.gp(_s323["__p"]["R"], "joy"), "x"), J.gp(J.gp(_s323["__p"]["R"], "joy"), "x0"))
		v_dy_981 = J.sub(J.gp(J.gp(_s323["__p"]["R"], "joy"), "y"), J.gp(J.gp(_s323["__p"]["R"], "joy"), "y0"))
		v_d_982 = J.hypot_([v_dx_980, v_dy_981])
		if J.cmp(v_d_982, 6.0, ">"):
			v_k_983 = J.min_([1.0, J.div(J.sub(v_d_982, 6.0), 44.0)])
			var _t943 = J.mul(J.div(v_dx_980, v_d_982), v_k_983)
			v_mx_965 = _t943
			var _t944 = J.mul(J.div(v_dy_981, v_d_982), v_k_983)
			v_my_966 = _t944
	v_K_967 = J.gp(_s323["__p"]["R"], "keys")
	var _t945 = J.gp(v_K_967, "a")
	if J.t((_t945 if J.t(_t945) else J.gp(v_K_967, "arrowleft"))):
		var _t946 = J.sub(v_mx_965, 1.0)
		v_mx_965 = _t946
	var _t947 = J.gp(v_K_967, "d")
	if J.t((_t947 if J.t(_t947) else J.gp(v_K_967, "arrowright"))):
		var _t948 = J.add(v_mx_965, 1.0)
		v_mx_965 = _t948
	var _t949 = J.gp(v_K_967, "w")
	if J.t((_t949 if J.t(_t949) else J.gp(v_K_967, "arrowup"))):
		var _t950 = J.sub(v_my_966, 1.0)
		v_my_966 = _t950
	var _t951 = J.gp(v_K_967, "s")
	if J.t((_t951 if J.t(_t951) else J.gp(v_K_967, "arrowdown"))):
		var _t952 = J.add(v_my_966, 1.0)
		v_my_966 = _t952
	v_ml_968 = J.hypot_([v_mx_965, v_my_966])
	if J.cmp(v_ml_968, 1.0, ">"):
		var _t953 = J.div(v_mx_965, v_ml_968)
		v_mx_965 = _t953
		var _t954 = J.div(v_my_966, v_ml_968)
		v_my_966 = _t954
	if J.cmp(v_ml_968, 0.05, ">"):
		var _t955 = _s323["__p"]["R"]
		var _t956 = {"x": J.div(v_mx_965, J.max_([v_ml_968, 0.01])), "y": J.div(v_my_966, J.max_([v_ml_968, 0.01]))}
		J.sp(_t955, "face", _t956)
	if J.cmp(J.gp(_s323["L"], "hp"), 0.0, ">"):
		if J.cmp(J.gp(_s323["L"], "dash"), 0.0, ">"):
			var _t957 = _s323["L"]
			var _t958 = J.sub(J.gp(_t957, "dash"), _s323["dt"])
			J.sp(_t957, "dash", _t958)
			var _t959 = _s323["L"]
			var _t960 = J.cmp(J.gp(_s323["L"], "dash"), 0.0, ">")
			J.sp(_t959, "inv", _t960)
			if (randf() < 0.7):
				var _t961 = J.gp(_s323["__p"]["R"], "fx")
				J.mc(_t961, "push", [{"kind": "after", "k": J.gp(_s323["L"], "k"), "x": J.gp(_s323["L"], "x"), "y": J.gp(_s323["L"], "y"), "s": J.gp(_s323["L"], "s"), "flip": J.gp(_s323["L"], "flip"), "t": 0.0, "life": 0.28}])
			for _t962 in J.iter(J.gp(_s323["__p"]["R"], "foes")):
				v_e_984 = _t962
				var _t963 = J.cmp(J.gp(v_e_984, "hp"), 0.0, ">")
				var _t964 = ((not J.t(J.gp(v_e_984, "fled"))) if _t963 else _t963)
				var _t966 = ((not J.cmp(J.gp(v_e_984, "down"), 0.0, ">")) if _t964 else _t964)
				if J.t(_t966):
					var _t965 = J.gp(_s323["L"], "dashHit")
					_t966 = (not J.t(J.mc(_t965, "has", [v_e_984])))
				if ((J.hypot_([J.sub(J.gp(v_e_984, "x"), J.gp(_s323["L"], "x")), (J.sub(J.gp(v_e_984, "y"), J.gp(_s323["L"], "y")) * 1.3)]) < 40.0) if _t966 else _t966):
					var _t967 = J.gp(_s323["L"], "dashHit")
					J.mc(_t967, "add", [v_e_984])
					var _t968 = _s323["__p"]["hit"]
					J.cl(_t968, null, [_s323["L"], v_e_984, 0.8, {"kb": 300.0}])
		else:
			v_spd_985 = J.mul(J.gp(_s323["L"], "spd"), (1.12 if J.cmp(J.gp(_s323["__p"]["R"], "buff"), 0.0, ">") else 1.0))
			var _t969 = _s323["__p"]["approachV"]
			J.cl(_t969, null, [_s323["L"], J.mul(v_mx_965, v_spd_985), J.mul(v_my_966, v_spd_985), _s323["dt"], (1800.0 if J.cmp(v_ml_968, 0.05, ">") else 2400.0)])
		var _t970 = _s323["__p"]["integrate"]
		J.cl(_t970, null, [_s323["L"], _s323["dt"]])
	var _t971 = _s323["__p"]["revealAround"]
	J.cl(_t971, null, [J.gp(_s323["L"], "x"), J.gp(_s323["L"], "y")])
	var _t972 = _s323["__p"]["zoneAt"]
	v_z_969 = J.cl(_t972, null, [J.gp(_s323["L"], "x"), J.gp(_s323["L"], "y")])
	var _t973 = _s323["__p"]["terOf"]
	v_tNow_970 = J.cl(_t973, null, [v_z_969])
	if (not J.seq(J.gp(_s323["__p"]["R"], "lastT"), v_tNow_970)):
		var _t974 = _s323["__p"]["R"]
		J.sp(_t974, "lastT", v_tNow_970)
		var _t975 = _s323["__p"]["kingDef"]
		v_d_986 = J.cl(_t975, null, [v_tNow_970])
		var _t980 = null
		if (not J.leq(J.gp(_s323["__p"]["TMAIN"], v_tNow_970), null)):
			_t980 = ("主線・" + J.str(J.gp(J.gp(J.gp(J.gp(J.G.get("CHAPTERS"), J.gp(_s323["__p"]["R"], "ci")), "stages"), J.gp(_s323["__p"]["TMAIN"], v_tNow_970)), "name")))
		else:
			var _t979 = null
			if J.t(v_d_986):
				var _t976 = [J.gp(v_d_986, "big"), J.gp(v_d_986, "small")]
				var _t977 = J.mc(_t976, "filter", [J.G.get("Boolean")])
				var _t978 = J.mc(_t977, "map", [Callable(self, "_f194").bind(_s323)])
				_t979 = J.mc(_t978, "join", ["、"])
			else:
				_t979 = ""
			_t980 = _t979
		v_kn_987 = _t980
		var _t981 = _s323["__p"]["msg"]
		var _t983 = ("秘境" if J.t(J.gp(_s323["__p"]["TSECRET"], v_tNow_970)) else "地頭")
		var _t984 = J.gp(J.gp(_s323["__p"]["TNAME"], J.gp(_s323["__p"]["R"], "ci")), v_tNow_970)
		var _t982 = _s323["__p"]["kingDone"]
		J.cl(_t981, null, [("<b>" + _t983 + "：" + J.str(_t984) + "</b>" + ("　（已拿下）" if J.t(J.cl(_t982, null, [v_tNow_970])) else (("　" + ("" if (not J.leq(J.gp(_s323["__p"]["TMAIN"], v_tNow_970), null)) else ("守寶鬼：" if J.t((J.gp(v_d_986, "guard") if J.t(v_d_986) else v_d_986)) else "地頭王：")) + J.str(v_kn_987)) if J.t(v_kn_987) else ""))), 3.0])
	if (not J.t(J.gp(J.gp(_s323["__p"]["R"], "zoneSeen"), v_z_969))):
		var _s342 = {"__p": _s323, "ek": null}
		var _t985 = J.gp(_s342["__p"]["__p"]["R"], "zoneSeen")
		J.sp(_t985, v_z_969, 1.0)
		var _t986 = _s342["__p"]["__p"]["eliteOfZone"]
		_s342["ek"] = J.cl(_t986, null, [J.gp(_s342["__p"]["__p"]["R"], "ci"), v_z_969])
		if J.t(((not J.t(J.mc(J.G.get("N30W"), "owned", [_s342["ek"]]))) if J.t(_s342["ek"]) else _s342["ek"])):
			J.F_setTimeout([Callable(self, "_f195").bind(_s342), 2500.0])
	var _t989 = J.gp(_s323["__p"]["R"], "near")
	for _t988 in J.iter((_t989 if J.t(_t989) else [])):
		v_zz_990 = _t988
		var _t990 = _s323["__p"]["spawnZone"]
		J.cl(_t990, null, [v_zz_990])
	var _t991 = (not J.t(J.gp(_s323["__p"]["R"], "nearT")))
	if (_t991 if _t991 else J.cmp(J.gp(_s323["__p"]["R"], "t"), J.gp(_s323["__p"]["R"], "nearT"), ">")):
		var _t992 = _s323["__p"]["R"]
		var _t993 = J.add(J.gp(_s323["__p"]["R"], "t"), 0.5)
		J.sp(_t992, "nearT", _t993)
		var _t994 = _s323["__p"]["R"]
		var _t995 = []
		J.sp(_t994, "near", _t995)
		v_q_991 = 0.0
		while true:
			if not J.cmp(v_q_991, J.mul(_s323["__p"]["COLS"], _s323["__p"]["ROWS"]), "<"): break
			var _t996 = _s323["__p"]["zoneCell"]
			v_c_992 = J.cl(_t996, null, [v_q_991])
			var _t997 = (absf(J.num(J.sub(J.gp(v_c_992, "x"), J.gp(_s323["L"], "x")))) < J.mul(_s323["__p"]["CW"], 1.05))
			if ((absf(J.num(J.sub(J.gp(v_c_992, "y"), J.gp(_s323["L"], "y")))) < J.mul(_s323["__p"]["CH"], 1.05)) if _t997 else _t997):
				var _t998 = J.gp(_s323["__p"]["R"], "near")
				J.mc(_t998, "push", [v_q_991])
			v_q_991 = J.num(v_q_991) + 1.0
	v_t_993 = 0.0
	while true:
		if not J.cmp(v_t_993, 9.0, "<"): break
		var _t999 = _s323["__p"]["lairPos"]
		v_lp_994 = J.cl(_t999, null, [v_t_993])
		if (J.hypot_([J.sub(J.gp(v_lp_994, "x"), J.gp(_s323["L"], "x")), J.sub(J.gp(v_lp_994, "y"), J.gp(_s323["L"], "y"))]) < 900.0):
			var _t1000 = _s323["__p"]["spawnKing"]
			J.cl(_t1000, null, [v_t_993])
		v_t_993 = J.num(v_t_993) + 1.0
	var _t1001 = _s323["__p"]["spotTick"]
	J.cl(_t1001, null, [_s323["dt"]])
	v_si_995 = 0.0
	while true:
		if not J.cmp(v_si_995, 3.0, "<"): break
		var _t1002 = _s323["__p"]["guardPos"]
		v_gp_996 = J.cl(_t1002, null, [v_si_995])
		if (J.hypot_([J.sub(J.gp(v_gp_996, "x"), J.gp(_s323["L"], "x")), J.sub(J.gp(v_gp_996, "y"), J.gp(_s323["L"], "y"))]) < 900.0):
			var _t1003 = _s323["__p"]["spawnGuards"]
			J.cl(_t1003, null, [v_si_995])
		v_si_995 = J.num(v_si_995) + 1.0
	var _t1004 = _s323["__p"]["spawnBryan"]
	J.cl(_t1004, null, [v_z_969])
	var _t1005 = _s323["__p"]["R"]
	var _t1006 = J.gp(_s323["__p"]["R"], "foes")
	var _t1013 = J.mc(_t1006, "filter", [Callable(self, "_f196").bind(_s323)])
	J.sp(_t1005, "foes", _t1013)
	for _t1014 in J.keys(J.gp(_s323["__p"]["R"], "packs")):
		v_zz_998 = _t1014
		var _t1015 = J.gp(_s323["__p"]["R"], "packs")
		var _t1016 = J.gp(J.gp(_s323["__p"]["R"], "packs"), v_zz_998)
		var _t1019 = J.mc(_t1016, "map", [Callable(self, "_f197").bind(_s323)])
		var _t1020 = J.mc(_t1019, "filter", [Callable(self, "_f199").bind(_s323)])
		J.sp(_t1015, v_zz_998, _t1020)
	v_si_1002 = 0.0
	while true:
		if not J.cmp(v_si_1002, 3.0, "<"): break
		var _t1021 = _s323["__p"]["sidOf"]
		v_sid_1003 = J.cl(_t1021, null, [J.gp(_s323["__p"]["R"], "ci"), v_si_1002])
		v_stg_1004 = J.gp(J.gp(J.gp(J.G.get("CHAPTERS"), J.gp(_s323["__p"]["R"], "ci")), "stages"), v_si_1002)
		var _t1022 = _s323["__p"]["guardPos"]
		v_gp_1005 = J.cl(_t1022, null, [v_si_1002])
		v_d_1006 = J.hypot_([J.sub(J.gp(v_gp_1005, "x"), J.gp(_s323["L"], "x")), J.sub(J.gp(v_gp_1005, "y"), J.gp(_s323["L"], "y"))])
		var _t1023 = J.gp(J.gp(J.G.get("S"), "cleared"), v_sid_1003)
		if J.t((_t1023 if J.t(_t1023) else J.cmp(v_d_1006, 300.0, ">"))):
			v_si_1002 = J.num(v_si_1002) + 1.0
			continue
		if J.cmp(J.gp(J.G.get("S"), "lv"), J.gp(v_stg_1004, "req"), "<"):
			var _t1024 = (not J.t(J.gp(_s323["__p"]["R"], "reqMsg")))
			if (_t1024 if _t1024 else (J.sub(J.gp(_s323["__p"]["R"], "t"), J.gp(_s323["__p"]["R"], "reqMsg")) > 6.0)):
				var _t1025 = _s323["__p"]["R"]
				var _t1026 = J.gp(_s323["__p"]["R"], "t")
				J.sp(_t1025, "reqMsg", _t1026)
				var _t1027 = _s323["__p"]["msg"]
				J.cl(_t1027, null, [("<b>" + J.str(J.gp(v_stg_1004, "name")) + "</b>：需主公 Lv" + J.str(J.gp(v_stg_1004, "req")) + "（" + J.str(J.mc(J.G.get("GP"), "T", ["建議鬼力", "建議鬼力"])) + " " + J.str(J.mc(J.G.get("GP"), "stageNeed", [v_stg_1004, v_sid_1003])) + "）。先回村升級再來。"), 4.0])
			v_si_1002 = J.num(v_si_1002) + 1.0
			continue
		var _t1028 = J.gp(v_stg_1004, "before")
		var _t1029 = ((not J.t(J.gp(J.gp(J.G.get("S"), "seen"), J.gp(v_stg_1004, "before")))) if J.t(_t1028) else _t1028)
		if J.t(((not J.t(J.gp(_s323["__p"]["R"], "beforeQ"))) if J.t(_t1029) else _t1029)):
			var _t1030 = _s323["__p"]["R"]
			J.sp(_t1030, "beforeQ", 1.0)
			J.mc(J.G.get("Story"), "queue", [J.gp(v_stg_1004, "before"), Callable(self, "_f200").bind(_s323)])
			return null
		var _t1032 = J.gp(_s323["__p"]["R"], "guards")
		var _t1033 = (J.gp(J.gp(_s323["__p"]["R"], "guards"), v_si_1002) if J.t(_t1032) else _t1032)
		if J.t(((not J.t(J.gp(J.gp(J.gp(J.gp(_s323["__p"]["R"], "guards"), v_si_1002), 0.0), "awake"))) if J.t(_t1033) else _t1033)):
			var _t1034 = J.gp(J.gp(_s323["__p"]["R"], "guards"), v_si_1002)
			J.mc(_t1034, "forEach", [Callable(self, "_f201").bind(_s323)])
			var _t1035 = _s323["__p"]["msg"]
			J.cl(_t1035, null, [("<b>" + J.str(J.gp(v_stg_1004, "name")) + "</b>：「" + ("總監親自當值。" if J.seq(v_si_1002, 2.0) else "主管當值，閒人勿進。") + "」"), 2.5])
			var _t1036 = _s323["__p"]["R"]
			J.sp(_t1036, "shake", 6.0)
		v_si_1002 = J.num(v_si_1002) + 1.0
	var _t1037 = J.gp(_s323["__p"]["R"], "units")
	v_party_971 = J.mc(_t1037, "filter", [Callable(self, "_f202").bind(_s323)])
	var _t1039 = J.gp(_s323["__p"]["R"], "foes")
	v_foes_972 = J.mc(_t1039, "filter", [Callable(self, "_f203").bind(_s323)])
	var _t1046 = J.gp(_s323["__p"]["R"], "foes")
	v_calm_973 = (not J.t(J.mc(_t1046, "some", [Callable(self, "_f204").bind(_s323)])))
	if J.t(v_calm_973):
		for _t1051 in J.iter(v_party_971):
			v_u_1011 = _t1051
			var _t1052 = J.min_([J.gp(v_u_1011, "maxhp"), J.add(J.gp(v_u_1011, "hp"), J.mul(J.mul(J.gp(v_u_1011, "maxhp"), 0.03), _s323["dt"]))])
			J.sp(v_u_1011, "hp", _t1052)
	for _t1053 in J.iter(J.gp(_s323["__p"]["R"], "units")):
		var _s370 = {"__p": _s323, "u": null}
		_s370["u"] = _t1053
		var _t1054 = _s370["u"]
		var _t1055 = J.gp(_s370["u"], "flash")
		var _t1056 = J.gp(_s370["u"], "flash")
		var _t1057 = J.max_([0.0, J.sub((_t1056 if J.t(_t1056) else 0.0), J.mul(_s370["__p"]["dt"], 5.0))])
		J.sp(_t1054, "flash", _t1057)
		var _t1058 = _s370["u"]
		var _t1059 = J.gp(_s370["u"], "hurt")
		var _t1060 = J.gp(_s370["u"], "hurt")
		var _t1061 = J.max_([0.0, J.sub((_t1060 if J.t(_t1060) else 0.0), _s370["__p"]["dt"])])
		J.sp(_t1058, "hurt", _t1061)
		if J.cmp(J.gp(_s370["u"], "hp"), 0.0, "<="):
			var _t1062 = _s370["u"]
			var _t1063 = J.gp(_s370["u"], "deadT")
			var _t1064 = J.add((_t1063 if J.t(_t1063) else 0.0), _s370["__p"]["dt"])
			J.sp(_t1062, "deadT", _t1064)
			var _t1065 = J.seq(J.gp(_s370["u"], "role"), "lead")
			if (J.cmp(J.gp(_s370["u"], "deadT"), 25.0, ">") if _t1065 else _t1065):
				var _t1066 = _s370["u"]
				var _t1067 = J.mul(J.gp(_s370["u"], "maxhp"), 0.6)
				J.sp(_t1066, "hp", _t1067)
				var _t1068 = _s370["u"]
				J.sp(_t1068, "deadT", 0.0)
				var _t1069 = _s370["u"]
				var _t1070 = J.gp(_s370["__p"]["L"], "x")
				J.sp(_t1069, "x", _t1070)
				var _t1071 = _s370["u"]
				var _t1072 = J.gp(_s370["__p"]["L"], "y")
				J.sp(_t1071, "y", _t1072)
				var _t1073 = _s370["u"]
				var _t1074 = _s370["u"]
				J.sp(_t1074, "vy", 0.0)
				J.sp(_t1073, "vx", 0.0)
				var _t1075 = _s370["__p"]["__p"]["fxText"]
				J.cl(_t1075, null, [J.gp(_s370["u"], "x"), J.sub(J.gp(_s370["u"], "y"), 50.0), "歸隊！", "#9ff"])
				var _t1076 = _s370["__p"]["__p"]["spr"]
				J.cl(_t1076, null, ["fx_beam", J.gp(_s370["u"], "x"), J.add(J.gp(_s370["u"], "y"), 6.0), {"s0": 0.3, "s1": 0.4, "sx": 0.7, "life": 0.8, "anchor": 0.95}])
				var _t1077 = J.gp(_s370["__p"]["__p"]["R"], "fx")
				J.mc(_t1077, "push", [{"kind": "ring", "x": J.gp(_s370["u"], "x"), "y": J.gp(_s370["u"], "y"), "t": 0.0, "life": 0.5, "col": "#9ff", "r": 60.0}])
			continue
		if J.t(J.gp(_s370["u"], "leader")):
			if J.t(J.gp(_s370["u"], "act")):
				var _t1078 = _s370["__p"]["__p"]["tickAct"]
				J.cl(_t1078, null, [_s370["u"], _s370["__p"]["dt"]])
			else:
				var _t1079 = _s370["u"]
				var _t1080 = J.sub(J.gp(_t1079, "cd"), _s370["__p"]["dt"])
				J.sp(_t1079, "cd", _t1080)
				var _t1081 = _s370["__p"]["__p"]["nearest"]
				v_tg_1015 = J.cl(_t1081, null, [_s370["u"], v_foes_972, J.add(J.gp(_s370["u"], "rng"), 10.0)])
				var _t1082 = (J.cmp(J.gp(_s370["u"], "cd"), 0.0, "<=") if J.t(v_tg_1015) else v_tg_1015)
				if J.t(((not J.cmp(J.gp(_s370["u"], "dash"), 0.0, ">")) if J.t(_t1082) else _t1082)):
					var _t1083 = _s370["__p"]["__p"]["startAttack"]
					J.cl(_t1083, null, [_s370["u"], v_tg_1015])
			continue
		var _t1084 = _s370["u"]
		var _t1085 = J.sub(J.gp(_t1084, "cd"), _s370["__p"]["dt"])
		J.sp(_t1084, "cd", _t1085)
		var _t1086 = J.seq(J.gp(_s370["u"], "role"), "crew")
		if J.t((J.gp(_s370["u"], "inFight") if _t1086 else _t1086)):
			var _t1087 = J.gp(_s370["u"], "g")
			var _t1088 = J.gp(J.gp(_s370["u"], "g"), "fat")
			var _t1089 = J.gp(J.gp(_s370["u"], "g"), "fat")
			var _t1090 = J.min_([100.0, J.add((_t1089 if J.t(_t1089) else 0.0), J.mul(_s370["__p"]["dt"], 0.5))])
			J.sp(_t1087, "fat", _t1090)
			var _t1091 = J.cmp(J.gp(J.gp(_s370["u"], "g"), "fat"), 100.0, ">=")
			if ((not J.t(J.gp(_s370["u"], "sick"))) if _t1091 else _t1091):
				var _t1092 = _s370["u"]
				J.sp(_t1092, "sick", 1.0)
				var _t1093 = _s370["u"]
				J.sp(_t1093, "hp", 0.0)
				var _t1094 = _s370["u"]
				J.sp(_t1094, "deadT", 0.0)
				var _t1095 = _s370["__p"]["__p"]["fxText"]
				J.cl(_t1095, null, [J.gp(_s370["u"], "x"), J.sub(J.gp(_s370["u"], "y"), 40.0), "請病假", "#fca"])
				var _t1096 = _s370["__p"]["__p"]["msg"]
				J.cl(_t1096, null, [(J.str(J.gp(_s370["u"], "name")) + " 過勞，請病假回村。"), 2.5])
				continue
			var _t1097 = J.cmp(J.gp(J.gp(_s370["u"], "g"), "fat"), 70.0, ">=")
			if ((not J.t(J.gp(_s370["u"], "tired"))) if _t1097 else _t1097):
				var _t1098 = _s370["u"]
				J.sp(_t1098, "tired", 1.0)
				var _t1099 = _s370["u"]
				var _t1100 = J.mul(J.gp(_t1099, "atk"), 0.7)
				J.sp(_t1099, "atk", _t1100)
		if J.t(J.gp(_s370["u"], "act")):
			var _t1101 = _s370["__p"]["__p"]["tickAct"]
			J.cl(_t1101, null, [_s370["u"], _s370["__p"]["dt"]])
			var _t1102 = _s370["__p"]["__p"]["approachV"]
			J.cl(_t1102, null, [_s370["u"], 0.0, 0.0, _s370["__p"]["dt"]])
			var _t1103 = _s370["__p"]["__p"]["integrate"]
			J.cl(_t1103, null, [_s370["u"], _s370["__p"]["dt"]])
			continue
		var _t1104 = _s370["__p"]["__p"]["nearest"]
		v_tg_1013 = J.cl(_t1104, null, [_s370["u"], v_foes_972, 240.0])
		var _t1105 = _s370["u"]
		var _t1106 = (not (not J.t(v_tg_1013)))
		var _t1107 = ((J.hypot_([J.sub(J.gp(v_tg_1013, "x"), J.gp(_s370["__p"]["L"], "x")), J.sub(J.gp(v_tg_1013, "y"), J.gp(_s370["__p"]["L"], "y"))]) < 340.0) if _t1106 else _t1106)
		J.sp(_t1105, "inFight", _t1107)
		var _t1109 = J.gp(_s370["__p"]["__p"]["R"], "tele")
		if J.t(_t1109):
			var _t1108 = J.gp(_s370["__p"]["__p"]["R"], "tele")
			_t1109 = J.mc(_t1108, "find", [Callable(self, "_f205").bind(_s370)])
		v_tele_1014 = _t1109
		if J.t(v_tele_1014):
			v_dx_1017 = J.sub(J.gp(_s370["u"], "x"), J.gp(v_tele_1014, "x"))
			v_dy_1018 = J.sub(J.gp(_s370["u"], "y"), J.gp(v_tele_1014, "y"))
			var _t1110 = J.hypot_([v_dx_1017, v_dy_1018])
			v_d_1019 = (_t1110 if J.t(_t1110) else 1.0)
			var _t1111 = _s370["__p"]["__p"]["approachV"]
			J.cl(_t1111, null, [_s370["u"], (J.mul(J.div(v_dx_1017, v_d_1019), J.gp(_s370["u"], "spd")) * 1.3), (J.mul(J.div(v_dy_1018, v_d_1019), J.gp(_s370["u"], "spd")) * 1.3), _s370["__p"]["dt"]])
		else:
			if J.t(J.gp(_s370["u"], "inFight")):
				v_d_1020 = J.hypot_([J.sub(J.gp(v_tg_1013, "x"), J.gp(_s370["u"], "x")), (J.sub(J.gp(v_tg_1013, "y"), J.gp(_s370["u"], "y")) * 1.2)])
				v_want_1021 = J.mul(J.gp(_s370["u"], "rng"), (0.85 if J.cmp(J.gp(_s370["u"], "rng"), 60.0, ">") else 0.8))
				var _t1112 = J.gp(_s370["u"], "sk")
				var _t1114 = (J.cmp(J.gp(_s370["u"], "energy"), 100.0, ">=") if J.t(_t1112) else _t1112)
				if J.t(_t1114):
					var _t1113 = (not J.seq(J.gp(J.cl(_s370["__p"]["__p"]["st"], null, []), "autoSk"), false))
					_t1114 = (_t1113 if _t1113 else J.gp(_s370["u"], "wantCast"))
				if J.t(_t1114):
					var _t1115 = _s370["__p"]["__p"]["startAttack"]
					J.cl(_t1115, null, [_s370["u"], v_tg_1013, true])
					var _t1116 = _s370["u"]
					J.sp(_t1116, "wantCast", false)
				else:
					if J.cmp(v_d_1020, J.gp(_s370["u"], "rng"), ">"):
						var _t1117 = J.gp(_s370["u"], "ti")
						var _t1118 = (_t1117 if J.t(_t1117) else J.gp(_s370["u"], "slot"))
						v_side_1022 = ((1.0 if J.t(J.mod((_t1118 if J.t(_t1118) else 0.0), 2.0)) else (-1.0)) * 18.0)
						var _t1119 = _s370["__p"]["__p"]["steer"]
						J.cl(_t1119, null, [_s370["u"], J.add(J.gp(v_tg_1013, "x"), ((-J.num(v_want_1021)) if J.cmp(J.gp(_s370["u"], "x"), J.gp(v_tg_1013, "x"), "<") else v_want_1021)), J.add(J.gp(v_tg_1013, "y"), v_side_1022), J.gp(_s370["u"], "spd"), _s370["__p"]["dt"], 24.0])
					else:
						var _t1120 = _s370["__p"]["__p"]["approachV"]
						J.cl(_t1120, null, [_s370["u"], 0.0, 0.0, _s370["__p"]["dt"]])
						if J.cmp(J.gp(_s370["u"], "cd"), 0.0, "<="):
							var _t1121 = _s370["__p"]["__p"]["startAttack"]
							J.cl(_t1121, null, [_s370["u"], v_tg_1013])
			else:
				var _t1122 = _s370["__p"]["__p"]["wander"]
				J.cl(_t1122, null, [_s370["u"], _s370["__p"]["L"], _s370["__p"]["dt"]])
		var _t1123 = _s370["__p"]["__p"]["integrate"]
		J.cl(_t1123, null, [_s370["u"], _s370["__p"]["dt"]])
	for _t1124 in J.iter(J.gp(_s323["__p"]["R"], "foes")):
		v_e_1023 = _t1124
		var _t1125 = J.gp(v_e_1023, "flash")
		var _t1126 = J.gp(v_e_1023, "flash")
		var _t1127 = J.max_([0.0, J.sub((_t1126 if J.t(_t1126) else 0.0), J.mul(_s323["dt"], 5.0))])
		J.sp(v_e_1023, "flash", _t1127)
		var _t1128 = J.gp(v_e_1023, "hurt")
		var _t1129 = J.gp(v_e_1023, "hurt")
		var _t1130 = J.max_([0.0, J.sub((_t1129 if J.t(_t1129) else 0.0), _s323["dt"])])
		J.sp(v_e_1023, "hurt", _t1130)
		if J.cmp(J.gp(v_e_1023, "down"), 0.0, ">"):
			var _t1131 = J.sub(J.gp(v_e_1023, "down"), _s323["dt"])
			J.sp(v_e_1023, "down", _t1131)
			var _t1132 = _s323["__p"]["approachV"]
			J.cl(_t1132, null, [v_e_1023, 0.0, 0.0, _s323["dt"]])
			var _t1133 = _s323["__p"]["integrate"]
			J.cl(_t1133, null, [v_e_1023, _s323["dt"]])
			var _t1134 = J.cmp(J.gp(v_e_1023, "down"), 0.0, "<=")
			if ((not J.t(J.gp(v_e_1023, "done"))) if _t1134 else _t1134):
				var _t1135 = _s323["__p"]["resolveDown"]
				J.cl(_t1135, null, [v_e_1023, "soul", true])
			continue
		var _t1136 = J.cmp(J.gp(v_e_1023, "hp"), 0.0, "<=")
		if J.t((_t1136 if _t1136 else J.gp(v_e_1023, "fled"))):
			var _t1137 = J.gp(v_e_1023, "deadT")
			var _t1138 = J.add((_t1137 if J.t(_t1137) else 0.0), _s323["dt"])
			J.sp(v_e_1023, "deadT", _t1138)
			if J.t(J.gp(v_e_1023, "fled")):
				var _t1139 = J.add(J.gp(v_e_1023, "x"), J.mul((((-1.0) if J.t(J.gp(v_e_1023, "flip")) else 1.0) * 160.0), _s323["dt"]))
				J.sp(v_e_1023, "x", _t1139)
				var _t1140 = J.sub(J.gp(v_e_1023, "y"), J.mul(20.0, _s323["dt"]))
				J.sp(v_e_1023, "y", _t1140)
			continue
		var _t1141 = J.sub(J.gp(v_e_1023, "cd"), _s323["dt"])
		J.sp(v_e_1023, "cd", _t1141)
		var _t1142 = J.sub(((3.0 + (randf() * 3.0)) if J.leq(J.gp(v_e_1023, "slamCd"), null) else J.gp(v_e_1023, "slamCd")), _s323["dt"])
		J.sp(v_e_1023, "slamCd", _t1142)
		if J.t(J.gp(v_e_1023, "act")):
			var _t1143 = _s323["__p"]["tickAct"]
			J.cl(_t1143, null, [v_e_1023, _s323["dt"]])
			var _t1144 = _s323["__p"]["approachV"]
			J.cl(_t1144, null, [v_e_1023, 0.0, 0.0, _s323["dt"]])
			var _t1145 = _s323["__p"]["integrate"]
			J.cl(_t1145, null, [v_e_1023, _s323["dt"]])
			continue
		var _t1148 = null
		if (not J.leq(J.gp(v_e_1023, "guard"), null)):
			_t1148 = (not J.t(J.gp(v_e_1023, "awake")))
		else:
			var _t1146 = J.seq(_s323["ph"], "work")
			var _t1147 = ((not J.t(J.gp(v_e_1023, "provoked"))) if _t1146 else _t1146)
			_t1148 = ((not J.t(J.gp(v_e_1023, "bryan"))) if _t1147 else _t1147)
		v_passive_1024 = _t1148
		var _t1150 = null
		if J.t(v_passive_1024):
			_t1150 = null
		else:
			var _t1149 = _s323["__p"]["nearest"]
			_t1150 = J.cl(_t1149, null, [v_e_1023, v_party_971, (280.0 if (not J.leq(J.gp(v_e_1023, "guard"), null)) else (420.0 if J.t(J.gp(v_e_1023, "provoked")) else 190.0))])
		v_tg_1025 = _t1150
		v_home_1026 = J.hypot_([J.sub(J.gp(v_e_1023, "x"), J.gp(v_e_1023, "hx")), J.sub(J.gp(v_e_1023, "y"), J.gp(v_e_1023, "hy"))])
		v_spd_1027 = J.mul(J.gp(v_e_1023, "spd"), (0.7 if J.seq(_s323["ph"], "off") else 1.0))
		if J.t((J.cmp(v_home_1026, (340.0 if (not J.leq(J.gp(v_e_1023, "guard"), null)) else 480.0), "<") if J.t(v_tg_1025) else v_tg_1025)):
			J.sp(v_e_1023, "provoked", true)
			v_d_1028 = J.hypot_([J.sub(J.gp(v_tg_1025, "x"), J.gp(v_e_1023, "x")), (J.sub(J.gp(v_tg_1025, "y"), J.gp(v_e_1023, "y")) * 1.2)])
			var _t1151 = J.gp(v_e_1023, "elite")
			var _t1152 = (_t1151 if J.t(_t1151) else J.gp(v_e_1023, "boss"))
			var _t1154 = (_t1152 if J.t(_t1152) else J.gp(v_e_1023, "otBoss"))
			if not J.t(_t1154):
				var _t1153 = J.gp(v_e_1023, "bryan")
				_t1154 = (J.seq(J.gp(v_e_1023, "k"), "npc_rival") if J.t(_t1153) else _t1153)
			v_big_1029 = _t1154
			var _t1155 = (J.cmp(J.gp(v_e_1023, "slamCd"), 0.0, "<=") if J.t(v_big_1029) else v_big_1029)
			if J.t((J.cmp(v_d_1028, 200.0, "<") if J.t(_t1155) else _t1155)):
				var _t1156 = (5.5 + (randf() * 2.5))
				J.sp(v_e_1023, "slamCd", _t1156)
				var _t1157 = _s323["__p"]["telegraph"]
				J.cl(_t1157, null, [v_e_1023, v_tg_1025])
				continue
			var _t1158 = J.gp(v_e_1023, "sk")
			var _t1159 = (J.cmp(J.gp(v_e_1023, "energy"), 100.0, ">=") if J.t(_t1158) else _t1158)
			if J.t((J.cmp(v_d_1028, 220.0, "<") if J.t(_t1159) else _t1159)):
				var _t1160 = _s323["__p"]["startAttack"]
				J.cl(_t1160, null, [v_e_1023, v_tg_1025, true])
				continue
			var _t1161 = J.cmp(J.gp(v_e_1023, "rng"), 60.0, ">")
			if (J.cmp(v_d_1028, 70.0, "<") if _t1161 else _t1161):
				v_dx_1030 = J.sub(J.gp(v_e_1023, "x"), J.gp(v_tg_1025, "x"))
				v_dy_1031 = J.sub(J.gp(v_e_1023, "y"), J.gp(v_tg_1025, "y"))
				var _t1162 = J.hypot_([v_dx_1030, v_dy_1031])
				v_dd_1032 = (_t1162 if J.t(_t1162) else 1.0)
				var _t1163 = _s323["__p"]["approachV"]
				J.cl(_t1163, null, [v_e_1023, J.mul(J.div(v_dx_1030, v_dd_1032), v_spd_1027), J.mul(J.div(v_dy_1031, v_dd_1032), v_spd_1027), _s323["dt"]])
			else:
				if J.cmp(v_d_1028, J.gp(v_e_1023, "rng"), ">"):
					var _t1164 = _s323["__p"]["steer"]
					var _t1166 = J.add(J.gp(v_tg_1025, "x"), (((-J.num(J.gp(v_e_1023, "rng"))) * 0.8) if J.cmp(J.gp(v_e_1023, "x"), J.gp(v_tg_1025, "x"), "<") else J.mul(J.gp(v_e_1023, "rng"), 0.8)))
					var _t1167 = J.gp(v_tg_1025, "y")
					var _t1165 = J.seq(J.gp(v_e_1023, "k"), "xiaogui")
					J.cl(_t1164, null, [v_e_1023, _t1166, _t1167, J.mul(v_spd_1027, (1.5 if (J.cmp(v_d_1028, 120.0, ">") if _t1165 else _t1165) else 1.0)), _s323["dt"], 20.0])
				else:
					var _t1168 = _s323["__p"]["approachV"]
					J.cl(_t1168, null, [v_e_1023, 0.0, 0.0, _s323["dt"]])
					if J.cmp(J.gp(v_e_1023, "cd"), 0.0, "<="):
						var _t1169 = _s323["__p"]["startAttack"]
						J.cl(_t1169, null, [v_e_1023, v_tg_1025])
		else:
			if J.cmp(v_home_1026, 30.0, ">"):
				var _t1170 = _s323["__p"]["steer"]
				J.cl(_t1170, null, [v_e_1023, J.gp(v_e_1023, "hx"), J.gp(v_e_1023, "hy"), J.mul(v_spd_1027, 0.7), _s323["dt"], 40.0])
				if J.cmp(v_home_1026, 300.0, ">"):
					var _t1171 = J.min_([J.gp(v_e_1023, "maxhp"), J.add(J.gp(v_e_1023, "hp"), (J.mul(J.gp(v_e_1023, "maxhp"), _s323["dt"]) * 0.3))])
					J.sp(v_e_1023, "hp", _t1171)
			else:
				var _t1172 = _s323["__p"]["approachV"]
				J.cl(_t1172, null, [v_e_1023, 0.0, 0.0, _s323["dt"], 600.0])
				var _t1173 = (randf() < J.mul(_s323["dt"], 0.35))
				var _t1174 = ((not J.leq(J.gp(v_e_1023, "z"), null)) if _t1173 else _t1173)
				var _t1175 = (J.leq(J.gp(v_e_1023, "guard"), null) if _t1174 else _t1174)
				if ((not J.t(J.gp(v_e_1023, "ot"))) if _t1175 else _t1175):
					var _t1176 = _s323["__p"]["zoneCell"]
					v_c0_1033 = J.cl(_t1176, null, [J.gp(v_e_1023, "z")])
					var _t1177 = J.max_([(J.sub(J.gp(v_c0_1033, "x"), J.div(_s323["__p"]["CW"], 2.0)) + 70.0), J.min_([J.sub(J.add(J.gp(v_c0_1033, "x"), J.div(_s323["__p"]["CW"], 2.0)), 70.0), J.add(J.gp(v_e_1023, "hx"), ((randf() - 0.5) * 110.0))])])
					J.sp(v_e_1023, "hx", _t1177)
					var _t1178 = J.max_([(J.sub(J.gp(v_c0_1033, "y"), J.div(_s323["__p"]["CH"], 2.0)) + 70.0), J.min_([J.sub(J.add(J.gp(v_c0_1033, "y"), J.div(_s323["__p"]["CH"], 2.0)), 70.0), J.add(J.gp(v_e_1023, "hy"), ((randf() - 0.5) * 80.0))])])
					J.sp(v_e_1023, "hy", _t1178)
		var _t1179 = _s323["__p"]["integrate"]
		J.cl(_t1179, null, [v_e_1023, _s323["dt"]])
	if J.t(J.gp(_s323["__p"]["R"], "tele")):
		var _t1180 = _s323["__p"]["R"]
		var _t1181 = J.gp(_s323["__p"]["R"], "tele")
		var _t1194 = J.mc(_t1181, "filter", [Callable(self, "_f206").bind(_s323)])
		J.sp(_t1180, "tele", _t1194)
	var _t1195 = J.gp(_s323["__p"]["R"], "foes")
	v_all_974 = J.mc(v_party_971, "concat", [J.mc(_t1195, "filter", [Callable(self, "_f207").bind(_s323)])])
	v_i_1039 = 0.0
	while true:
		if not J.cmp(v_i_1039, J.len(v_all_974), "<"): break
		v_j_1040 = J.add(v_i_1039, 1.0)
		while true:
			if not J.cmp(v_j_1040, J.len(v_all_974), "<"): break
			v_a_1041 = J.gp(v_all_974, v_i_1039)
			v_b_1042 = J.gp(v_all_974, v_j_1040)
			v_R0_1043 = J.mul(J.add(J.gp(v_a_1041, "s"), J.gp(v_b_1042, "s")), 30.0)
			v_dx_1044 = J.sub(J.gp(v_b_1042, "x"), J.gp(v_a_1041, "x"))
			v_dy_1045 = (J.sub(J.gp(v_b_1042, "y"), J.gp(v_a_1041, "y")) * 1.5)
			v_d_1046 = J.hypot_([v_dx_1044, v_dy_1045])
			var _t1198 = J.cmp(v_d_1046, 0.1, ">")
			if (J.cmp(v_d_1046, v_R0_1043, "<") if _t1198 else _t1198):
				v_k_1047 = (J.div(J.sub(v_R0_1043, v_d_1046), v_d_1046) * 4.0)
				if (not J.t(J.gp(v_a_1041, "leader"))):
					var _t1199 = J.sub(J.gp(v_a_1041, "vx"), (J.mul(J.mul(v_dx_1044, v_k_1047), _s323["dt"]) * 10.0))
					J.sp(v_a_1041, "vx", _t1199)
					var _t1200 = J.sub(J.gp(v_a_1041, "vy"), (J.mul(J.mul(v_dy_1045, v_k_1047), _s323["dt"]) * 6.0))
					J.sp(v_a_1041, "vy", _t1200)
				if (not J.t(J.gp(v_b_1042, "leader"))):
					var _t1201 = J.add(J.gp(v_b_1042, "vx"), (J.mul(J.mul(v_dx_1044, v_k_1047), _s323["dt"]) * 10.0))
					J.sp(v_b_1042, "vx", _t1201)
					var _t1202 = J.add(J.gp(v_b_1042, "vy"), (J.mul(J.mul(v_dy_1045, v_k_1047), _s323["dt"]) * 6.0))
					J.sp(v_b_1042, "vy", _t1202)
			v_j_1040 = J.num(v_j_1040) + 1.0
		v_i_1039 = J.num(v_i_1039) + 1.0
	var _t1203 = _s323["__p"]["R"]
	var _t1204 = J.gp(_s323["__p"]["R"], "proj")
	var _t1222 = J.mc(_t1204, "filter", [Callable(self, "_f208").bind(_s323)])
	J.sp(_t1203, "proj", _t1222)
	if J.t(J.gp(_s323["__p"]["R"], "bryan")):
		v_b_1055 = J.gp(J.gp(_s323["__p"]["R"], "bryan"), 0.0)
		if J.cmp(J.gp(v_b_1055, "hp"), 0.0, ">"):
			for _t1223 in J.iter(J.gp(_s323["__p"]["R"], "units")):
				v_u_1056 = _t1223
				var _t1224 = J.seq(J.gp(v_u_1056, "role"), "crew")
				var _t1226 = (J.cmp(J.gp(v_u_1056, "hp"), 0.0, ">") if _t1224 else _t1224)
				if J.t(_t1226):
					var _t1225 = J.gp(J.gp(v_u_1056, "g"), "fat")
					_t1226 = J.cmp((_t1225 if J.t(_t1225) else 0.0), 75.0, ">=")
				if ((J.hypot_([J.sub(J.gp(v_u_1056, "x"), J.gp(v_b_1055, "x")), J.sub(J.gp(v_u_1056, "y"), J.gp(v_b_1055, "y"))]) < 220.0) if _t1226 else _t1226):
					var _t1227 = J.gp(v_u_1056, "g")
					J.sp(_t1227, "poached", 1.0)
					J.sp(v_u_1056, "hp", 0.0)
					J.sp(v_u_1056, "deadT", 9.0)
					J.sp(v_u_1056, "gone", 1.0)
					var _t1228 = _s323["__p"]["fxText"]
					J.cl(_t1228, null, [J.gp(v_u_1056, "x"), J.sub(J.gp(v_u_1056, "y"), 40.0), "跳槽！", "#f88"])
					var _t1229 = _s323["__p"]["msg"]
					var _t1230 = _s323["__p"]["T"]
					J.cl(_t1229, null, [J.cl(_t1230, null, [("Bryan：「" + J.str(J.gp(v_u_1056, "name")) + "，嚟我度，我哋冇 KPI 㗎。」" + J.str(J.gp(v_u_1056, "name")) + "跟咗 Bryan 走。"), ("Bryan：「" + J.str(J.gp(v_u_1056, "name")) + "，來我這邊，我們沒有 KPI 的。」" + J.str(J.gp(v_u_1056, "name")) + "跟 Bryan 走了。")]), 4.0])
		var _t1231 = J.gp(_s323["__p"]["R"], "bryan")
		if J.t(J.mc(_t1231, "every", [Callable(self, "_f209").bind(_s323)])):
			var _t1233 = _s323["__p"]["R"]
			J.sp(_t1233, "bryanDone", true)
			var _t1234 = _s323["__p"]["R"]
			J.sp(_t1234, "bryan", null)
			var _t1235 = J.gp(J.G.get("S"), "ghosts")
			v_back_1058 = J.mc(_t1235, "filter", [Callable(self, "_f210").bind(_s323)])
			J.mc(v_back_1058, "forEach", [Callable(self, "_f211").bind(_s323)])
			var _t1236 = _s323["__p"]["msg"]
			var _t1237 = _s323["__p"]["T"]
			var _t1239 = null
			if J.t(J.len(v_back_1058)):
				var _t1238 = J.mc(v_back_1058, "map", [Callable(self, "_f212").bind(_s323)])
				_t1239 = (J.str(J.mc(_t1238, "join", ["、"])) + " 返嚟咗：「其實佢嗰邊都有 KPI……」")
			else:
				_t1239 = "Bryan：「今次唔計，我啱啱熱緊身。」"
			var _t1242 = ("打贏 Bryan 部門！" + _t1239)
			var _t1241 = null
			if J.t(J.len(v_back_1058)):
				var _t1240 = J.mc(v_back_1058, "map", [Callable(self, "_f213").bind(_s323)])
				_t1241 = (J.str(J.mc(_t1240, "join", ["、"])) + " 回來了：「其實他那邊也有 KPI……」")
			else:
				_t1241 = "Bryan：「這次不算，我剛在熱身。」"
			J.cl(_t1236, null, [J.cl(_t1237, null, [_t1242, ("打贏 Bryan 部門！" + _t1241)]), 5.0])
			var _t1243 = _s323["__p"]["gain"]
			var _t1244 = _s323["__p"]["zoneP"]
			J.cl(_t1243, null, [{"coins": J.round(J.num((40.0 + J.mul(30.0, J.cl(_t1244, null, [J.gp(_s323["__p"]["R"], "ci"), v_z_969]))))), "exp": 20.0}])
	var _t1245 = _s323["__p"]["R"]
	var _t1246 = J.gp(_s323["__p"]["R"], "foes")
	var _t1251 = J.mc(_t1246, "filter", [Callable(self, "_f214").bind(_s323)])
	J.sp(_t1245, "foes", _t1251)
	var _t1255 = J.gp(_s323["__p"]["R"], "ot")
	if J.t(_t1255):
		var _t1252 = J.gp(_s323["__p"]["R"], "ot")
		_t1255 = J.mc(_t1252, "every", [Callable(self, "_f215").bind(_s323)])
	if J.t(_t1255):
		var _t1256 = _s323["__p"]["R"]
		J.sp(_t1256, "ot", null)
		var _t1257 = J.gp(J.G.get("S"), "chests")
		J.sp(_t1257, "p", J.num(J.gp(_t1257, "p")) + 1.0)
		var _t1258 = _s323["__p"]["gain"]
		var _t1259 = _s323["__p"]["zoneP"]
		J.cl(_t1258, null, [{"coins": J.round(J.num((80.0 + J.mul(60.0, J.cl(_t1259, null, [J.gp(_s323["__p"]["R"], "ci"), 9.0]))))), "exp": 30.0}])
		J.mc(J.G.get("Fx"), "toast", ["通宵加班房搞定！紫箱 ×1"])
		var _t1260 = _s323["__p"]["msg"]
		var _t1261 = _s323["__p"]["T"]
		J.cl(_t1260, null, [J.cl(_t1261, null, ["加班鬼：「多謝你哋……我終於可以收工。」佢瞓咗。", "加班鬼：「謝謝你們……我終於可以下班了。」他睡著了。"]), 3.0])
	for _t1262 in J.keys(J.gp(_s323["__p"]["R"], "kings")):
		v_t_1065 = _t1262
		v_g_1066 = J.gp(J.gp(_s323["__p"]["R"], "kings"), v_t_1065)
		if (not J.t(v_g_1066)):
			continue
		var _t1263 = _s323["__p"]["lairPos"]
		v_lp_1067 = J.cl(_t1263, null, [J.num(v_t_1065)])
		var _t1264 = (not J.t(J.gp(v_g_1066, "woke")))
		if ((J.hypot_([J.sub(J.gp(v_lp_1067, "x"), J.gp(_s323["L"], "x")), J.sub(J.gp(v_lp_1067, "y"), J.gp(_s323["L"], "y"))]) < 300.0) if _t1264 else _t1264):
			J.sp(v_g_1066, "woke", 1.0)
			J.mc(v_g_1066, "forEach", [Callable(self, "_f216").bind(_s323)])
			var _t1265 = _s323["__p"]["kingDef"]
			v_d_1068 = J.cl(_t1265, null, [v_t_1065])
			var _t1266 = _s323["__p"]["msg"]
			var _t1267 = _s323["__p"]["T"]
			J.cl(_t1266, null, [J.add(J.cl(_t1267, null, [("<b>" + J.str(J.gp(J.gp(_s323["__p"]["TNAME"], J.gp(_s323["__p"]["R"], "ci")), v_t_1065)) + "</b>係我哋嘅地頭！"), ("<b>" + J.str(J.gp(J.gp(_s323["__p"]["TNAME"], J.gp(_s323["__p"]["R"], "ci")), v_t_1065)) + "</b>是我們的地頭！")]), (("（大王：" + J.str((J.gp(J.gp(J.G.get("GHOSTS"), J.gp(v_d_1068, "big")), "name") if J.t(J.gp(J.G.get("GHOSTS"), J.gp(v_d_1068, "big"))) else "")) + "）") if J.t((J.gp(v_d_1068, "big") if J.t(v_d_1068) else v_d_1068)) else "")), 2.5])
			var _t1268 = _s323["__p"]["R"]
			J.sp(_t1268, "shake", 6.0)
		if J.t(J.mc(v_g_1066, "every", [Callable(self, "_f217").bind(_s323)])):
			var _t1270 = J.gp(_s323["__p"]["R"], "kings")
			J.sp(_t1270, v_t_1065, null)
			var _t1271 = _s323["__p"]["kingWin"]
			J.cl(_t1271, null, [J.num(v_t_1065)])
	if J.t(J.gp(_s323["__p"]["R"], "guards")):
		for _t1272 in J.keys(J.gp(_s323["__p"]["R"], "guards")):
			v_si_1071 = _t1272
			v_g_1072 = J.gp(J.gp(_s323["__p"]["R"], "guards"), v_si_1071)
			var _t1273 = (J.len(v_g_1072) if J.t(v_g_1072) else v_g_1072)
			if J.t((J.mc(v_g_1072, "every", [Callable(self, "_f218").bind(_s323)]) if J.t(_t1273) else _t1273)):
				var _t1274 = J.gp(_s323["__p"]["R"], "guards")
				J.sp(_t1274, v_si_1071, null)
				var _t1275 = _s323["__p"]["stageWin"]
				J.cl(_t1275, null, [J.num(v_si_1071)])
	var _t1276 = _s323["__p"]["R"]
	var _t1277 = J.gp(_s323["__p"]["R"], "fx")
	var _t1279 = J.mc(_t1277, "filter", [Callable(self, "_f219").bind(_s323)])
	J.sp(_t1276, "fx", _t1279)
	if J.t(J.gp(_s323["__p"]["R"], "later")):
		var _t1280 = _s323["__p"]["R"]
		var _t1281 = J.gp(_s323["__p"]["R"], "later")
		var _t1283 = J.mc(_t1281, "filter", [Callable(self, "_f220").bind(_s323)])
		J.sp(_t1280, "later", _t1283)
	if J.t(J.gp(_s323["L"], "swing")):
		var _t1284 = J.gp(_s323["L"], "swing")
		var _t1285 = J.add(J.gp(_t1284, "t"), _s323["dt"])
		J.sp(_t1284, "t", _t1285)
		if J.cmp(J.gp(J.gp(_s323["L"], "swing"), "t"), 0.45, ">"):
			var _t1286 = _s323["L"]
			J.sp(_t1286, "swing", null)
	var _t1287 = _s323["__p"]["ambient"]
	J.cl(_t1287, null, [_s323["dt"]])
	var _t1288 = _s323["__p"]["facilities"]
	J.cl(_t1288, null, [_s323["dt"]])
	var _t1290 = J.gp(_s323["L"], "x")
	var _t1289 = J.gp(_s323["L"], "vx")
	v_lx_975 = J.add(_t1290, J.mul((_t1289 if J.t(_t1289) else 0.0), 0.25))
	var _t1292 = J.sub(J.gp(_s323["L"], "y"), 30.0)
	var _t1291 = J.gp(_s323["L"], "vy")
	v_ly_976 = (_t1292 + J.mul((_t1291 if J.t(_t1291) else 0.0), 0.2))
	var _t1293 = J.gp(_s323["__p"]["R"], "cam")
	var _t1294 = J.add(J.gp(_t1293, "x"), (J.sub(v_lx_975, J.gp(J.gp(_s323["__p"]["R"], "cam"), "x")) * J.min_([1.0, J.mul(_s323["dt"], 4.5)])))
	J.sp(_t1293, "x", _t1294)
	var _t1295 = J.gp(_s323["__p"]["R"], "cam")
	var _t1296 = J.add(J.gp(_t1295, "y"), (J.sub(v_ly_976, J.gp(J.gp(_s323["__p"]["R"], "cam"), "y")) * J.min_([1.0, J.mul(_s323["dt"], 4.5)])))
	J.sp(_t1295, "y", _t1296)
	var _t1297 = J.cmp(J.gp(_s323["L"], "hp"), 0.0, "<=")
	if ((not J.t(J.gp(_s323["__p"]["R"], "ended"))) if _t1297 else _t1297):
		var _t1298 = _s323["__p"]["end"]
		J.cl(_t1298, null, [true])
	var _t1300 = J.gp(_s323["__p"]["R"], "t")
	var _t1299 = J.gp(_s323["__p"]["R"], "saveT")
	if (J.sub(_t1300, (_t1299 if J.t(_t1299) else 0.0)) > 10.0):
		var _t1301 = _s323["__p"]["R"]
		var _t1302 = J.gp(_s323["__p"]["R"], "t")
		J.sp(_t1301, "saveT", _t1302)
		J.cl(_s323["__p"]["persist"], null, [])

func _f221(this_, a: Array, env):
	var v_u_1079 = null; var v_list_1080 = null; var v_r_1081 = null; var v_b_1082 = null; var v_bd_1083 = null; var v_v_1084 = null; var v_d_1085 = null
	v_u_1079 = J.arg(a, 0)
	v_list_1080 = J.arg(a, 1)
	v_r_1081 = J.arg(a, 2)
	v_b_1082 = null
	v_bd_1083 = v_r_1081
	for _t1303 in J.iter(v_list_1080):
		v_v_1084 = _t1303
		var _t1304 = J.cmp(J.gp(v_v_1084, "hp"), 0.0, "<=")
		var _t1305 = (_t1304 if _t1304 else J.cmp(J.gp(v_v_1084, "down"), 0.0, ">"))
		var _t1306 = (_t1305 if _t1305 else J.gp(v_v_1084, "fled"))
		var _t1308 = (_t1306 if J.t(_t1306) else J.gp(v_v_1084, "gone"))
		if not J.t(_t1308):
			var _t1307 = (not J.leq(J.gp(v_v_1084, "guard"), null))
			_t1308 = ((not J.t(J.gp(v_v_1084, "awake"))) if _t1307 else _t1307)
		if J.t(_t1308):
			continue
		v_d_1085 = J.hypot_([J.sub(J.gp(v_v_1084, "x"), J.gp(v_u_1079, "x")), (J.sub(J.gp(v_v_1084, "y"), J.gp(v_u_1079, "y")) * 1.2)])
		if J.cmp(v_d_1085, v_bd_1083, "<"):
			v_bd_1083 = v_d_1085
			v_b_1082 = v_v_1084
	return v_b_1082

func _f224(this_, a: Array, env):
	var v_e_1091 = null
	v_e_1091 = J.arg(a, 0)
	J.sp(v_e_1091, "provoked", true)
	return true

func _f223(this_, a: Array, env):
	var v_pk_1090 = null
	v_pk_1090 = J.arg(a, 0)
	if J.t(J.mc(v_pk_1090, "includes", [env["v"]])):
		J.mc(v_pk_1090, "forEach", [Callable(self, "_f224").bind(env)])

func _f222(this_, a: Array, env):
	var v_z_1089 = null
	var _s449 = {"__p": env, "v": null}
	_s449["v"] = J.arg(a, 0)
	var _t1309 = (not J.t(J.gp(_s449["v"], "provoked")))
	if (J.cmp(J.gp(_s449["v"], "hp"), 0.0, ">") if _t1309 else _t1309):
		var _t1310 = J.gp(_s449["__p"]["R"], "fx")
		J.mc(_t1310, "push", [{"kind": "txt", "x": J.gp(_s449["v"], "x"), "y": J.sub(J.gp(_s449["v"], "y"), J.mul(100.0, J.gp(_s449["v"], "s"))), "text": "！", "col": "#ff8a6a", "t": 0.0, "life": 0.7, "big": true}])
	var _t1311 = _s449["v"]
	J.sp(_t1311, "provoked", true)
	v_z_1089 = J.gp(_s449["v"], "z")
	var _t1312 = (not J.leq(v_z_1089, null))
	if J.t((J.gp(J.gp(_s449["__p"]["R"], "packs"), v_z_1089) if _t1312 else _t1312)):
		var _t1313 = J.gp(J.gp(_s449["__p"]["R"], "packs"), v_z_1089)
		J.mc(_t1313, "forEach", [Callable(self, "_f223").bind(_s449)])

func _f225(this_, a: Array, env):
	var v_u_1094 = null; var v_v_1095 = null; var v_cast_1096 = null; var v_e_1097 = null
	v_u_1094 = J.arg(a, 0)
	v_v_1095 = J.arg(a, 1)
	v_cast_1096 = J.arg(a, 2)
	var _t1314 = {"ph": "windup", "t": 0.0, "tg": v_v_1095, "cast": (not (not J.t(v_cast_1096))), "dur": (J.gp(env["ATK"], "cast") if J.t(v_cast_1096) else J.mul(J.gp(env["ATK"], "windup"), (1.6 if J.t(J.gp(v_u_1094, "boss")) else 1.0)))}
	J.sp(v_u_1094, "act", _t1314)
	var _t1315 = J.mul(J.gp(v_u_1094, "aspd"), (0.85 + (randf() * 0.3)))
	J.sp(v_u_1094, "cd", _t1315)
	if (absf(J.num(J.sub(J.gp(v_v_1095, "x"), J.gp(v_u_1094, "x")))) > 2.0):
		var _t1316 = J.cmp(J.gp(v_v_1095, "x"), J.gp(v_u_1094, "x"), "<")
		J.sp(v_u_1094, "flip", _t1316)
	var _t1317 = J.seq(J.gp(v_u_1094, "side"), 0.0)
	if (J.seq(J.gp(v_v_1095, "side"), 1.0) if _t1317 else _t1317):
		var _t1318 = env["provoke"]
		J.cl(_t1318, null, [v_v_1095])
	if J.t(v_cast_1096):
		J.sp(v_u_1094, "energy", 0.0)
		J.mc(J.G.get("Sound"), "play", ["click"])

func _f226(this_, a: Array, env):
	var v_u_1100 = null; var v_dt_1101 = null; var v_a_1102 = null
	v_u_1100 = J.arg(a, 0)
	v_dt_1101 = J.arg(a, 1)
	v_a_1102 = J.gp(v_u_1100, "act")
	var _t1319 = J.add(J.gp(v_a_1102, "t"), v_dt_1101)
	J.sp(v_a_1102, "t", _t1319)
	var _t1320 = J.seq(J.gp(v_a_1102, "ph"), "windup")
	if (J.cmp(J.gp(v_a_1102, "t"), J.gp(v_a_1102, "dur"), ">=") if _t1320 else _t1320):
		J.sp(v_a_1102, "ph", "strike")
		J.sp(v_a_1102, "t", 0.0)
		if J.cmp(J.gp(v_u_1100, "hp"), 0.0, ">"):
			var _t1321 = env["fire"]
			J.cl(_t1321, null, [v_u_1100, v_a_1102])
	else:
		var _t1322 = J.seq(J.gp(v_a_1102, "ph"), "strike")
		if (J.cmp(J.gp(v_a_1102, "t"), J.gp(env["ATK"], "strike"), ">=") if _t1322 else _t1322):
			J.sp(v_a_1102, "ph", "recover")
			J.sp(v_a_1102, "t", 0.0)
		else:
			var _t1323 = J.seq(J.gp(v_a_1102, "ph"), "recover")
			if (J.cmp(J.gp(v_a_1102, "t"), J.gp(env["ATK"], "recover"), ">=") if _t1323 else _t1323):
				J.sp(v_u_1100, "act", null)

func _f227(this_, a: Array, env):
	var v_u_1105 = null
	v_u_1105 = J.arg(a, 0)
	var _t1324 = J.gp({"yuan": "#d6a8ff", "chan": "#ffc27a", "lan": "#9fdcff"}, J.gp(v_u_1105, "fac"))
	return (_t1324 if J.t(_t1324) else "#bff")

func _f228(this_, a: Array, env):
	var v_u_1108 = null; var v_a_1109 = null; var v_v_1110 = null; var v_dir_1111 = null; var v_big_1112 = null
	v_u_1108 = J.arg(a, 0)
	v_a_1109 = J.arg(a, 1)
	if J.t(J.gp(v_a_1109, "cast")):
		var _t1325 = env["skill"]
		J.cl(_t1325, null, [v_u_1108])
		return null
	if J.t(J.gp(v_a_1109, "slam")):
		return null
	v_v_1110 = J.gp(v_a_1109, "tg")
	var _t1326 = (not J.t(v_v_1110))
	var _t1327 = (_t1326 if _t1326 else J.cmp(J.gp(v_v_1110, "hp"), 0.0, "<="))
	if (_t1327 if _t1327 else J.cmp(J.gp(v_v_1110, "down"), 0.0, ">")):
		return null
	var _t1328 = J.gp(v_u_1108, "leader")
	if J.t((J.gp(v_u_1108, "wpn") if J.t(_t1328) else _t1328)):
		var _t1329 = env["wfire"]
		J.cl(_t1329, null, [v_u_1108, v_v_1110])
		return null
	if J.cmp(J.gp(v_u_1108, "rng"), 60.0, ">"):
		var _t1330 = J.gp(env["R"], "proj")
		var _t1333 = J.add(J.gp(v_u_1108, "x"), ((-14.0) if J.t(J.gp(v_u_1108, "flip")) else 14.0))
		var _t1334 = J.sub(J.gp(v_u_1108, "y"), (J.mul(44.0, J.gp(v_u_1108, "s")) * 1.65))
		var _t1332 = null
		if J.t(J.gp(v_u_1108, "side")):
			_t1332 = "#ff9ac0"
		else:
			var _t1331 = env["projCol"]
			_t1332 = J.cl(_t1331, null, [v_u_1108])
		var _t1336 = null
		if J.t(J.gp(v_u_1108, "side")):
			_t1336 = J.gp(env["HUE"], "foe")
		else:
			var _t1335 = J.gp(env["HUE"], J.gp(v_u_1108, "fac"))
			_t1336 = (_t1335 if J.t(_t1335) else 0.0)
		var _t1337 = J.seq(J.gp(v_u_1108, "role"), "lead")
		var _t1338 = (_t1337 if _t1337 else J.gp(v_u_1108, "elite"))
		J.mc(_t1330, "push", [{"x": _t1333, "y": _t1334, "tg": v_v_1110, "src": v_u_1108, "spd": 560.0, "col": _t1332, "hue": _t1336, "big": (1.3 if J.t((_t1338 if J.t(_t1338) else J.gp(v_u_1108, "boss"))) else 1.0), "trail": [], "ph": (randf() * 6.0)}])
		return null
	var _t1339 = signf(J.num(J.sub(J.gp(v_v_1110, "x"), J.gp(v_u_1108, "x"))))
	v_dir_1111 = (_t1339 if J.t(_t1339) else 1.0)
	var _t1340 = J.add(J.gp(v_u_1108, "vx"), J.mul(v_dir_1111, 120.0))
	J.sp(v_u_1108, "vx", _t1340)
	var _t1341 = env["img"]
	if J.t(J.cl(_t1341, null, ["fx_slash"])):
		var _t1344 = null
		if J.t(J.gp(v_u_1108, "boss")):
			_t1344 = 1.5
		else:
			var _t1342 = J.gp(v_u_1108, "leader")
			var _t1343 = (_t1342 if J.t(_t1342) else J.seq(J.gp(v_u_1108, "role"), "lead"))
			_t1344 = (1.15 if J.t((_t1343 if J.t(_t1343) else J.gp(v_u_1108, "elite"))) else (0.6 if J.seq(J.gp(v_u_1108, "role"), "troop") else 0.8))
		v_big_1112 = _t1344
		var _t1345 = env["spr"]
		var _t1353 = J.sub(J.gp(v_v_1110, "x"), J.mul(v_dir_1111, 6.0))
		var _t1354 = J.sub(J.gp(v_v_1110, "y"), (J.mul(34.0, J.gp(v_v_1110, "s")) * 1.65))
		var _t1349 = J.mul(0.16, v_big_1112)
		var _t1350 = J.mul(0.3, v_big_1112)
		var _t1351 = J.cmp(v_dir_1111, 0.0, "<")
		var _t1352 = ((randf() - 0.5) * 0.6)
		var _t1348 = null
		if J.t(J.gp(v_u_1108, "side")):
			_t1348 = (-155.0)
		else:
			var _t1347 = null
			if J.t(J.gp(v_u_1108, "leader")):
				_t1347 = 0.0
			else:
				var _t1346 = J.gp(env["HUE"], J.gp(v_u_1108, "fac"))
				_t1347 = (_t1346 if J.t(_t1346) else 0.0)
			_t1348 = _t1347
		J.cl(_t1345, null, ["fx_slash", _t1353, _t1354, {"s0": _t1349, "s1": _t1350, "life": 0.2, "flip": _t1351, "rot": _t1352, "hue": _t1348}])
	else:
		var _t1355 = J.gp(env["R"], "fx")
		J.mc(_t1355, "push", [{"kind": "slash", "x": J.gp(v_v_1110, "x"), "y": J.sub(J.gp(v_v_1110, "y"), (J.mul(34.0, J.gp(v_v_1110, "s")) * 1.65)), "dir": v_dir_1111, "t": 0.0, "life": 0.2, "r": (22.0 + (14.0 if J.t(J.gp(v_u_1108, "boss")) else (6.0 if J.t(J.gp(v_u_1108, "leader")) else 0.0))), "col": ("#ff9ac0" if J.t(J.gp(v_u_1108, "side")) else ("#ffe9a0" if J.t(J.gp(v_u_1108, "leader")) else "#bff"))}])
	var _t1356 = env["hit"]
	J.cl(_t1356, null, [v_u_1108, v_v_1110, 1.0])

func _f229(this_, a: Array, env):
	var v_t_1115 = null; var v_f_1116 = null
	v_t_1115 = J.arg(a, 0)
	v_f_1116 = J.arg(a, 1)
	var _t1357 = env["R"]
	var _t1358 = J.gp(env["R"], "later")
	var _t1359 = (_t1358 if J.t(_t1358) else [])
	J.sp(_t1357, "later", _t1359)
	J.mc(_t1359, "push", [{"t": v_t_1115, "f": v_f_1116}])

func _f231(this_, a: Array, env):
	var v_e_1122 = null
	v_e_1122 = J.arg(a, 0)
	var _t1361 = J.cmp(J.gp(v_e_1122, "hp"), 0.0, ">")
	var _t1362 = ((not J.cmp(J.gp(v_e_1122, "down"), 0.0, ">")) if _t1361 else _t1361)
	var _t1364 = ((not J.t(J.gp(v_e_1122, "fled"))) if _t1362 else _t1362)
	if J.t(_t1364):
		var _t1363 = (not J.leq(J.gp(v_e_1122, "guard"), null))
		_t1364 = (not ((not J.t(J.gp(v_e_1122, "awake"))) if _t1363 else _t1363))
	return (J.cmp(J.hypot_([J.sub(J.gp(v_e_1122, "x"), env["x"]), (J.sub(J.gp(v_e_1122, "y"), env["y"]) * 1.3)]), env["r"], "<") if _t1364 else _t1364)

func _f230(this_, a: Array, env):
	var _s467 = {"__p": env, "x": null, "y": null, "r": null}
	_s467["x"] = J.arg(a, 0)
	_s467["y"] = J.arg(a, 1)
	_s467["r"] = J.arg(a, 2)
	var _t1360 = J.gp(_s467["__p"]["R"], "foes")
	return J.mc(_t1360, "filter", [Callable(self, "_f231").bind(_s467)])

func _f233(this_, a: Array, env):
	var v_e_1132 = null
	v_e_1132 = J.arg(a, 0)
	return J.sub(J.gp(v_e_1132, "y"), (J.mul(34.0, J.gp(v_e_1132, "s")) * 1.65))

func _f234(this_, a: Array, env):
	var v_e_1134 = null
	if J.cmp(J.gp(env["v"], "hp"), 0.0, "<="):
		return null
	var _t1373 = J.gp(env["__p"]["R"], "proj")
	J.mc(_t1373, "push", [{"x": J.add(J.gp(env["u"], "x"), J.mul(env["dir"], 16.0)), "y": J.sub(J.gp(env["u"], "y"), 50.0), "tg": env["v"], "src": env["u"], "spd": 720.0, "col": "#d6e4ff", "hue": env["hue"], "big": 0.7, "trail": [], "ph": (randf() * 6.0), "mult": J.mul(0.5, env["m"])}])
	J.mc(J.G.get("Sound"), "play", ["click"])

func _f235(this_, a: Array, env):
	var v_e_1137 = null
	v_e_1137 = J.arg(a, 0)
	var _t1379 = env["__p"]["hit"]
	return J.cl(_t1379, null, [env["u"], v_e_1137, J.mul((1.6 if J.seq(J.gp(env["w"], "sty"), "smash") else 1.3), env["m"]), {"kb": 230.0, "from": env["u"]}])

func _f236(this_, a: Array, env):
	var v_e_1139 = null
	v_e_1139 = J.arg(a, 0)
	var _t1392 = env["__p"]["spr"]
	var _t1394 = J.gp(v_e_1139, "x")
	var _t1393 = env["hy"]
	return J.cl(_t1392, null, ["fx_heal", _t1394, J.cl(_t1393, null, [v_e_1139]), {"s0": 0.15, "s1": 0.05, "life": 0.4, "vx": J.sub(J.gp(env["u"], "x"), J.gp(v_e_1139, "x")), "vy": (-J.sub(J.gp(env["u"], "y"), J.gp(v_e_1139, "y"))), "hue": J.gp(env["__p"]["HUE"], "yuan")}])

func _f237(this_, a: Array, env):
	var v_e_1141 = null
	v_e_1141 = J.arg(a, 0)
	var _t1397 = env["__p"]["hit"]
	return J.cl(_t1397, null, [env["u"], v_e_1141, J.mul((0.8 if J.seq(J.gp(env["w"], "sty"), "spin") else 0.72), env["m"]), {"kb": 200.0, "from": env["u"]}])

func _f238(this_, a: Array, env):
	var v_e_1146 = null
	v_e_1146 = J.arg(a, 0)
	var _t1401 = J.cmp(J.gp(v_e_1146, "hp"), 0.0, ">")
	var _t1402 = ((not J.cmp(J.gp(v_e_1146, "down"), 0.0, ">")) if _t1401 else _t1401)
	return ((not J.t(J.gp(v_e_1146, "fled"))) if _t1402 else _t1402)

func _f239(this_, a: Array, env):
	var v_e_1147 = null; var v_px_1148 = null; var v_py_1149 = null; var v_t_1150 = null
	v_e_1147 = J.arg(a, 0)
	v_px_1148 = J.sub(J.gp(v_e_1147, "x"), J.gp(env["__p"]["u"], "x"))
	v_py_1149 = J.sub(J.gp(v_e_1147, "y"), J.gp(env["__p"]["u"], "y"))
	v_t_1150 = (J.mul(v_px_1148, env["ex"]) + J.mul(v_py_1149, env["ey"]))
	var _t1404 = J.cmp(v_t_1150, 0.0, ">")
	var _t1405 = (J.cmp(v_t_1150, env["L"], "<") if _t1404 else _t1404)
	if ((absf(J.num((J.mul(v_px_1148, env["ey"]) - J.mul(v_py_1149, env["ex"])))) < 34.0) if _t1405 else _t1405):
		var _t1406 = env["__p"]["__p"]["hit"]
		J.cl(_t1406, null, [env["__p"]["u"], v_e_1147, J.mul(1.0, env["__p"]["m"]), {"kb": 120.0, "from": env["__p"]["u"]}])

func _f240(this_, a: Array, env):
	if J.cmp(J.gp(env["__p"]["v"], "hp"), 0.0, "<="):
		return null
	var _t1413 = env["__p"]["u"]
	var _t1414 = J.add(J.gp(_t1413, "vx"), J.mul(env["__p"]["dir"], 60.0))
	J.sp(_t1413, "vx", _t1414)
	var _t1415 = env["__p"]["__p"]["hit"]
	J.cl(_t1415, null, [env["__p"]["u"], env["__p"]["v"], J.mul((0.8 if J.seq(env["i"], 2.0) else 0.45), env["__p"]["m"]), {"kb": (260.0 if J.seq(env["i"], 2.0) else 40.0)}])
	var _t1416 = env["__p"]["__p"]["spr"]
	var _t1418 = J.sub(J.gp(env["__p"]["v"], "x"), J.mul(env["__p"]["dir"], 6.0))
	var _t1417 = env["__p"]["hy"]
	J.cl(_t1416, null, ["fx_slash", _t1418, J.add(J.cl(_t1417, null, [env["__p"]["v"]]), (J.sub(env["i"], 1.0) * 8.0)), {"s0": 0.16, "s1": 0.3, "life": 0.16, "flip": (J.cmp(env["__p"]["dir"], 0.0, ">") if J.t(J.mod(env["i"], 2.0)) else J.cmp(env["__p"]["dir"], 0.0, "<")), "rot": (J.sub(env["i"], 1.0) * 0.5), "hue": env["__p"]["hue"]}])

func _f242(this_, a: Array, env):
	var v_e_1154 = null
	v_e_1154 = J.arg(a, 0)
	var _t1423 = env["__p"]["__p"]["hit"]
	J.cl(_t1423, null, [env["__p"]["u"], v_e_1154, J.mul(0.85, env["__p"]["m"]), {"kb": 90.0, "from": {"x": env["tx"], "y": env["ty"]}}])
	var _t1424 = J.add(J.gp(v_e_1154, "cd"), 0.5)
	J.sp(v_e_1154, "cd", _t1424)
	J.sp(v_e_1154, "slow", 1.5)

func _f241(this_, a: Array, env):
	var _t1421 = env["__p"]["__p"]["foesNear"]
	var _t1422 = J.cl(_t1421, null, [env["tx"], env["ty"], 95.0])
	J.mc(_t1422, "forEach", [Callable(self, "_f242").bind(env)])
	var _t1425 = env["__p"]["__p"]["spr"]
	J.cl(_t1425, null, ["fx_smoke", env["tx"], env["ty"], {"ground": true, "s0": 0.3, "s1": 0.75, "life": 0.7, "hue": env["__p"]["hue"]}])
	var _t1426 = env["__p"]["__p"]["fxText"]
	J.cl(_t1426, null, [env["tx"], J.sub(env["ty"], 60.0), "燙！", "#ffc27a"])

func _f243(this_, a: Array, env):
	if J.cmp(J.gp(env["v"], "hp"), 0.0, ">"):
		var _t1432 = env["__p"]["hit"]
		J.cl(_t1432, null, [env["u"], env["v"], J.mul(1.25, env["m"]), {"kb": 200.0}])

func _f244(this_, a: Array, env):
	var v_e_1159 = null
	v_e_1159 = J.arg(a, 0)
	var _t1436 = J.cmp(J.gp(v_e_1159, "hp"), 0.0, ">")
	var _t1437 = ((not J.cmp(J.gp(v_e_1159, "down"), 0.0, ">")) if _t1436 else _t1436)
	return ((not J.t(J.gp(v_e_1159, "fled"))) if _t1437 else _t1437)

func _f245(this_, a: Array, env):
	var v_e_1160 = null; var v_px_1161 = null; var v_py_1162 = null
	v_e_1160 = J.arg(a, 0)
	v_px_1161 = J.sub(J.gp(v_e_1160, "x"), J.gp(env["__p"]["u"], "x"))
	v_py_1162 = J.sub(J.gp(v_e_1160, "y"), J.gp(env["__p"]["u"], "y"))
	return [v_e_1160, (J.mul(v_px_1161, env["ex"]) + J.mul(v_py_1162, env["ey"])), absf(J.num((J.mul(v_px_1161, env["ey"]) - J.mul(v_py_1162, env["ex"]))))]

func _f246(this_, a: Array, env):
	var v_q_1163 = null
	v_q_1163 = J.arg(a, 0)
	var _t1440 = J.cmp(J.gp(v_q_1163, 1.0), 0.0, ">")
	var _t1441 = (J.cmp(J.gp(v_q_1163, 1.0), J.add(J.gp(J.gp(env["__p"]["w"], "S"), "rng"), 30.0), "<") if _t1440 else _t1440)
	return (J.cmp(J.gp(v_q_1163, 2.0), 30.0, "<") if _t1441 else _t1441)

func _f247(this_, a: Array, env):
	var v_a_1164 = null; var v_b_1165 = null
	v_a_1164 = J.arg(a, 0)
	v_b_1165 = J.arg(a, 1)
	return J.sub(J.gp(v_a_1164, 1.0), J.gp(v_b_1165, 1.0))

func _f248(this_, a: Array, env):
	var v_e_1166 = null
	var _t1445 = J.gp(J.arg(a, 0), 0.0)
	v_e_1166 = _t1445
	var _t1446 = env["__p"]["__p"]["hit"]
	return J.cl(_t1446, null, [env["__p"]["u"], v_e_1166, J.mul(0.95, env["__p"]["m"]), {"kb": 150.0, "from": env["__p"]["u"]}])

func _f250(this_, a: Array, env):
	var v_e_1167 = null
	v_e_1167 = J.arg(a, 0)
	var _t1453 = env["__p"]["hit"]
	J.cl(_t1453, null, [env["u"], v_e_1167, J.mul(1.35, env["m"]), {"kb": 120.0, "from": env["v"]}])
	var _t1454 = (not J.t(J.gp(v_e_1167, "boss")))
	if (J.cmp(J.gp(v_e_1167, "hp"), 0.0, ">") if _t1454 else _t1454):
		var _t1455 = J.add(J.gp(v_e_1167, "cd"), 1.0)
		J.sp(v_e_1167, "cd", _t1455)
		var _t1456 = env["__p"]["fxText"]
		J.cl(_t1456, null, [J.gp(v_e_1167, "x"), J.sub(J.gp(v_e_1167, "y"), J.mul(70.0, J.gp(v_e_1167, "s"))), "壓扁", "#ffd0a0"])

func _f249(this_, a: Array, env):
	var v_e_1168 = null
	var _t1451 = env["__p"]["foesNear"]
	var _t1452 = J.cl(_t1451, null, [J.gp(env["v"], "x"), J.gp(env["v"], "y"), 150.0])
	J.mc(_t1452, "forEach", [Callable(self, "_f250").bind(env)])
	var _t1457 = env["__p"]["spr"]
	J.cl(_t1457, null, ["fx_shock", J.gp(env["v"], "x"), J.gp(env["v"], "y"), {"ground": true, "s0": 0.3, "s1": 0.9, "life": 0.45, "hue": env["hue"]}])
	var _t1458 = env["__p"]["dust"]
	J.cl(_t1458, null, [J.sub(J.gp(env["v"], "x"), 30.0), J.gp(env["v"], "y"), 1.6])
	var _t1459 = env["__p"]["dust"]
	J.cl(_t1459, null, [J.add(J.gp(env["v"], "x"), 30.0), J.gp(env["v"], "y"), 1.6])
	var _t1460 = env["__p"]["R"]
	var _t1461 = J.max_([J.gp(env["__p"]["R"], "shake"), 9.0])
	J.sp(_t1460, "shake", _t1461)
	var _t1462 = env["__p"]["R"]
	var _t1463 = J.gp(env["__p"]["R"], "stop")
	var _t1464 = J.gp(env["__p"]["R"], "stop")
	var _t1465 = J.max_([(_t1464 if J.t(_t1464) else 0.0), 0.07])
	J.sp(_t1462, "stop", _t1465)
	J.mc(J.G.get("Sound"), "play", ["skill"])

func _f232(this_, a: Array, env):
	var v_i_1133 = null; var v_r_1135 = null; var v_hs_1136 = null; var v_h_1138 = null; var v_r_1140 = null; var v_ang_1143 = null; var v_d_1155 = null; var v_ang_1156 = null
	var _s469 = {"__p": env, "u": null, "v": null, "w": null, "m": null, "dir": null, "hy": null, "hue": null}
	_s469["u"] = J.arg(a, 0)
	_s469["v"] = J.arg(a, 1)
	_s469["w"] = J.gp(_s469["u"], "wpn")
	_s469["m"] = J.gp(_s469["w"], "lvMul")
	var _t1365 = signf(J.num(J.sub(J.gp(_s469["v"], "x"), J.gp(_s469["u"], "x"))))
	_s469["dir"] = (_t1365 if J.t(_t1365) else 1.0)
	_s469["hy"] = Callable(self, "_f233").bind(_s469)
	var _t1366 = J.gp(_s469["__p"]["HUE"], J.gp(J.gp(_s469["w"], "it"), "f"))
	_s469["hue"] = (_t1366 if J.t(_t1366) else 0.0)
	var _t1367 = _s469["u"]
	var _t1368 = {"sty": J.gp(_s469["w"], "sty"), "t": 0.0}
	J.sp(_t1367, "swing", _t1368)
	var _t1369 = J.gp(_s469["w"], "sty")
	var _t1370 = -1
	var _t1371 = false
	if _t1370 == -1 and J.seq(_t1369, "shoot"): _t1370 = 0
	if _t1370 == -1 and J.seq(_t1369, "smash"): _t1370 = 1
	if _t1370 == -1 and J.seq(_t1369, "drain"): _t1370 = 2
	if _t1370 == -1 and J.seq(_t1369, "spin"): _t1370 = 3
	if _t1370 == -1 and J.seq(_t1369, "flail"): _t1370 = 4
	if _t1370 == -1 and J.seq(_t1369, "beam"): _t1370 = 5
	if _t1370 == -1 and J.seq(_t1369, "combo"): _t1370 = 6
	if _t1370 == -1 and J.seq(_t1369, "splash"): _t1370 = 7
	if _t1370 == -1 and J.seq(_t1369, "pull"): _t1370 = 8
	if _t1370 == -1 and J.seq(_t1369, "poke"): _t1370 = 9
	if _t1370 == -1 and J.seq(_t1369, "slam"): _t1370 = 10
	while true:
		if _t1370 <= 0 and _t1370 >= 0:
			v_i_1133 = 0.0
			while true:
				if not J.cmp(v_i_1133, 3.0, "<"): break
				var _t1372 = _s469["__p"]["later"]
				J.cl(_t1372, null, [J.mul(v_i_1133, 0.09), Callable(self, "_f234").bind(_s469)])
				v_i_1133 = J.num(v_i_1133) + 1.0
			var _t1374 = _s469["u"]
			var _t1375 = J.sub(J.gp(_t1374, "vx"), J.mul(_s469["dir"], 90.0))
			J.sp(_t1374, "vx", _t1375)
			break
		if _t1370 <= 1 and _t1370 >= 0:
			pass
		if _t1370 <= 2 and _t1370 >= 0:
			var _t1376 = _s469["u"]
			var _t1377 = J.add(J.gp(_t1376, "vx"), J.mul(_s469["dir"], 260.0))
			J.sp(_t1376, "vx", _t1377)
			v_r_1135 = (80.0 if J.seq(J.gp(_s469["w"], "sty"), "smash") else 62.0)
			var _t1378 = _s469["__p"]["foesNear"]
			v_hs_1136 = J.cl(_t1378, null, [J.gp(_s469["v"], "x"), J.gp(_s469["v"], "y"), v_r_1135])
			J.mc(v_hs_1136, "forEach", [Callable(self, "_f235").bind(_s469)])
			var _t1380 = _s469["__p"]["spr"]
			J.cl(_t1380, null, ["fx_shock", J.gp(_s469["v"], "x"), J.gp(_s469["v"], "y"), {"ground": true, "s0": 0.2, "s1": 0.55, "life": 0.35, "hue": _s469["hue"]}])
			var _t1381 = _s469["__p"]["dust"]
			J.cl(_t1381, null, [J.gp(_s469["v"], "x"), J.gp(_s469["v"], "y"), 1.2])
			var _t1382 = _s469["__p"]["R"]
			var _t1383 = J.max_([J.gp(_s469["__p"]["R"], "shake"), 6.0])
			J.sp(_t1382, "shake", _t1383)
			var _t1384 = _s469["__p"]["R"]
			var _t1385 = J.gp(_s469["__p"]["R"], "stop")
			var _t1386 = J.gp(_s469["__p"]["R"], "stop")
			var _t1387 = J.max_([(_t1386 if J.t(_t1386) else 0.0), 0.05])
			J.sp(_t1384, "stop", _t1387)
			var _t1388 = J.seq(J.gp(_s469["w"], "sty"), "drain")
			if J.t((J.len(v_hs_1136) if _t1388 else _t1388)):
				v_h_1138 = J.mul((J.mul(J.gp(_s469["u"], "atk"), 0.3) * J.len(v_hs_1136)), _s469["m"])
				var _t1389 = _s469["u"]
				var _t1390 = J.min_([J.gp(_s469["u"], "maxhp"), J.add(J.gp(_s469["u"], "hp"), v_h_1138)])
				J.sp(_t1389, "hp", _t1390)
				var _t1391 = _s469["__p"]["fxText"]
				J.cl(_t1391, null, [J.gp(_s469["u"], "x"), J.sub(J.gp(_s469["u"], "y"), 70.0), J.add("+", J.round(J.num(v_h_1138))), "#8affb0"])
				J.mc(v_hs_1136, "forEach", [Callable(self, "_f236").bind(_s469)])
			break
		if _t1370 <= 3 and _t1370 >= 0:
			pass
		if _t1370 <= 4 and _t1370 >= 0:
			v_r_1140 = (120.0 if J.seq(J.gp(_s469["w"], "sty"), "spin") else 160.0)
			var _t1395 = _s469["__p"]["foesNear"]
			var _t1396 = J.cl(_t1395, null, [J.gp(_s469["u"], "x"), J.gp(_s469["u"], "y"), v_r_1140])
			J.mc(_t1396, "forEach", [Callable(self, "_f237").bind(_s469)])
			var _t1398 = _s469["__p"]["spr"]
			J.cl(_t1398, null, ["fx_wind", J.gp(_s469["u"], "x"), J.gp(_s469["u"], "y"), {"s0": 0.4, "s1": J.div(v_r_1140, 150.0), "life": 0.4, "anchor": 0.85, "hue": _s469["hue"], "spin": 9.0}])
			var _t1399 = J.gp(_s469["__p"]["R"], "fx")
			J.mc(_t1399, "push", [{"kind": "ring", "x": J.gp(_s469["u"], "x"), "y": J.gp(_s469["u"], "y"), "t": 0.0, "life": 0.35, "col": "#bfe0ff", "r": v_r_1140}])
			break
		if _t1370 <= 5 and _t1370 >= 0:
			var _s483 = {"__p": _s469, "L": null, "ex": null, "ey": null}
			_s483["L"] = J.add(J.gp(J.gp(_s483["__p"]["w"], "S"), "rng"), 50.0)
			v_ang_1143 = atan2(J.num(J.sub(J.gp(_s483["__p"]["v"], "y"), J.gp(_s483["__p"]["u"], "y"))), J.num(J.sub(J.gp(_s483["__p"]["v"], "x"), J.gp(_s483["__p"]["u"], "x"))))
			_s483["ex"] = cos(J.num(v_ang_1143))
			_s483["ey"] = sin(J.num(v_ang_1143))
			var _t1400 = J.gp(_s483["__p"]["__p"]["R"], "foes")
			var _t1403 = J.mc(_t1400, "filter", [Callable(self, "_f238").bind(_s483)])
			J.mc(_t1403, "forEach", [Callable(self, "_f239").bind(_s483)])
			var _t1407 = _s483["__p"]["__p"]["spr"]
			J.cl(_t1407, null, ["fx_beam", J.add(J.gp(_s483["__p"]["u"], "x"), J.div(J.mul(_s483["ex"], _s483["L"]), 2.0)), (J.sub(J.gp(_s483["__p"]["u"], "y"), 40.0) + J.div(J.mul(_s483["ey"], _s483["L"]), 2.0)), {"s0": 0.4, "s1": 0.5, "sx": J.div(_s483["L"], 180.0), "life": 0.25, "rot": J.sub(v_ang_1143, J.div(PI, 2.0)), "hue": _s483["__p"]["hue"]}])
			var _t1408 = _s483["__p"]["__p"]["R"]
			var _t1409 = J.gp(_s483["__p"]["__p"]["R"], "flash")
			var _t1410 = J.gp(_s483["__p"]["__p"]["R"], "flash")
			var _t1411 = J.max_([(_t1410 if J.t(_t1410) else 0.0), 0.08])
			J.sp(_t1408, "flash", _t1411)
			break
		if _t1370 <= 6 and _t1370 >= 0:
			var _s486 = {"__p": _s469, "i": null}
			_s486["i"] = 0.0
			while true:
				_s486 = _s486.duplicate()
				if not J.cmp(_s486["i"], 3.0, "<"): break
				var _t1412 = _s486["__p"]["__p"]["later"]
				J.cl(_t1412, null, [J.mul(_s486["i"], 0.12), Callable(self, "_f240").bind(_s486)])
				_s486["i"] = J.num(_s486["i"]) + 1.0
			break
		if _t1370 <= 7 and _t1370 >= 0:
			var _s488 = {"__p": _s469, "tx": null, "ty": null}
			_s488["tx"] = J.gp(_s488["__p"]["v"], "x")
			_s488["ty"] = J.gp(_s488["__p"]["v"], "y")
			var _t1419 = _s488["__p"]["__p"]["spr"]
			J.cl(_t1419, null, ["fx_smoke", J.add(J.gp(_s488["__p"]["u"], "x"), J.mul(_s488["__p"]["dir"], 20.0)), J.sub(J.gp(_s488["__p"]["u"], "y"), 50.0), {"s0": 0.1, "s1": 0.2, "life": 0.3, "vx": J.sub(_s488["tx"], J.gp(_s488["__p"]["u"], "x")), "vy": (-J.sub(_s488["ty"], J.gp(_s488["__p"]["u"], "y"))), "hue": _s488["__p"]["hue"]}])
			var _t1420 = _s488["__p"]["__p"]["later"]
			J.cl(_t1420, null, [0.3, Callable(self, "_f241").bind(_s488)])
			break
		if _t1370 <= 8 and _t1370 >= 0:
			var _t1427 = J.hypot_([J.sub(J.gp(_s469["v"], "x"), J.gp(_s469["u"], "x")), J.sub(J.gp(_s469["v"], "y"), J.gp(_s469["u"], "y"))])
			v_d_1155 = (_t1427 if J.t(_t1427) else 1.0)
			if (not J.t(J.gp(_s469["v"], "boss"))):
				var _t1428 = _s469["v"]
				var _t1429 = {"x": (J.div((-J.sub(J.gp(_s469["v"], "x"), J.gp(_s469["u"], "x"))), v_d_1155) * 520.0), "y": (J.div((-J.sub(J.gp(_s469["v"], "y"), J.gp(_s469["u"], "y"))), v_d_1155) * 300.0)}
				J.sp(_t1428, "kb", _t1429)
			var _t1430 = _s469["__p"]["spr"]
			J.cl(_t1430, null, ["fx_bolt", J.div(J.add(J.gp(_s469["u"], "x"), J.gp(_s469["v"], "x")), 2.0), (J.div(J.add(J.gp(_s469["u"], "y"), J.gp(_s469["v"], "y")), 2.0) - 40.0), {"s0": 0.2, "s1": 0.3, "sx": J.div(v_d_1155, 160.0), "life": 0.2, "rot": atan2(J.num(J.sub(J.gp(_s469["v"], "y"), J.gp(_s469["u"], "y"))), J.num(J.sub(J.gp(_s469["v"], "x"), J.gp(_s469["u"], "x")))), "hue": _s469["hue"]}])
			var _t1431 = _s469["__p"]["later"]
			J.cl(_t1431, null, [0.18, Callable(self, "_f243").bind(_s469)])
			break
		if _t1370 <= 9 and _t1370 >= 0:
			var _s494 = {"__p": _s469, "ex": null, "ey": null}
			v_ang_1156 = atan2(J.num(J.sub(J.gp(_s494["__p"]["v"], "y"), J.gp(_s494["__p"]["u"], "y"))), J.num(J.sub(J.gp(_s494["__p"]["v"], "x"), J.gp(_s494["__p"]["u"], "x"))))
			_s494["ex"] = cos(J.num(v_ang_1156))
			_s494["ey"] = sin(J.num(v_ang_1156))
			var _t1433 = _s494["__p"]["u"]
			var _t1434 = J.add(J.gp(_t1433, "vx"), J.mul(_s494["ex"], 160.0))
			J.sp(_t1433, "vx", _t1434)
			var _t1435 = J.gp(_s494["__p"]["__p"]["R"], "foes")
			var _t1438 = J.mc(_t1435, "filter", [Callable(self, "_f244").bind(_s494)])
			var _t1439 = J.mc(_t1438, "map", [Callable(self, "_f245").bind(_s494)])
			var _t1442 = J.mc(_t1439, "filter", [Callable(self, "_f246").bind(_s494)])
			var _t1443 = J.mc(_t1442, "sort", [Callable(self, "_f247").bind(_s494)])
			var _t1444 = J.mc(_t1443, "slice", [0.0, 2.0])
			J.mc(_t1444, "forEach", [Callable(self, "_f248").bind(_s494)])
			var _t1447 = _s494["__p"]["__p"]["spr"]
			J.cl(_t1447, null, ["fx_dash", J.add(J.gp(_s494["__p"]["u"], "x"), J.mul(_s494["ex"], 60.0)), J.sub(J.gp(_s494["__p"]["u"], "y"), 40.0), {"s0": 0.25, "s1": 0.4, "life": 0.18, "rot": v_ang_1156, "hue": _s494["__p"]["hue"]}])
			break
		if _t1370 <= 10 and _t1370 >= 0:
			var _t1448 = _s469["u"]
			var _t1449 = J.add(J.gp(_t1448, "vx"), J.mul(_s469["dir"], 200.0))
			J.sp(_t1448, "vx", _t1449)
			var _t1450 = _s469["__p"]["later"]
			J.cl(_t1450, null, [0.12, Callable(self, "_f249").bind(_s469)])
			break
		break

func _f251(this_, a: Array, env):
	var v_u_1171 = null; var v_v_1172 = null; var v_mult_1173 = null; var v_o_1174 = null; var v_crit_1175 = null; var v_buff_1176 = null; var v_dmg_1177 = null; var v_sx_1178 = null; var v_sy_1179 = null; var v_dx_1180 = null; var v_dy_1181 = null; var v_dl_1182 = null; var v_kb_1183 = null; var v_hy_1184 = null; var v_e_1185 = null
	v_u_1171 = J.arg(a, 0)
	v_v_1172 = J.arg(a, 1)
	v_mult_1173 = J.arg(a, 2)
	v_o_1174 = J.arg(a, 3)
	var _t1466 = J.cmp(J.gp(v_v_1172, "hp"), 0.0, "<=")
	var _t1467 = (_t1466 if _t1466 else J.cmp(J.gp(v_v_1172, "down"), 0.0, ">"))
	if J.t((_t1467 if _t1467 else J.gp(v_v_1172, "inv"))):
		return null
	var _t1468 = (v_o_1174 if J.t(v_o_1174) else {})
	v_o_1174 = _t1468
	var _t1469 = J.seq(J.gp(v_u_1171, "side"), 0.0)
	v_crit_1175 = ((randf() < (0.16 if J.t(J.gp(v_u_1171, "leader")) else 0.1)) if _t1469 else _t1469)
	var _t1470 = J.seq(J.gp(v_u_1171, "side"), 0.0)
	v_buff_1176 = (1.3 if (J.cmp(J.gp(env["R"], "buff"), 0.0, ">") if _t1470 else _t1470) else 1.0)
	v_dmg_1177 = J.max_([1.0, J.round(J.num(((J.mul(J.mul(J.gp(v_u_1171, "atk"), v_mult_1173), v_buff_1176) * (1.8 if J.t(v_crit_1175) else 1.0)) * (0.9 + (randf() * 0.2)))))])
	var _t1471 = J.sub(J.gp(v_v_1172, "hp"), v_dmg_1177)
	J.sp(v_v_1172, "hp", _t1471)
	J.sp(v_v_1172, "hurt", 0.24)
	J.sp(v_v_1172, "flash", 1.0)
	J.sp(v_v_1172, "lastBy", v_u_1171)
	var _t1472 = J.gp(v_v_1172, "act")
	var _t1473 = (J.seq(J.gp(J.gp(v_v_1172, "act"), "ph"), "windup") if J.t(_t1472) else _t1472)
	var _t1474 = ((not J.t(J.gp(v_v_1172, "boss"))) if J.t(_t1473) else _t1473)
	if J.t(((v_crit_1175 if J.t(v_crit_1175) else J.cmp(v_mult_1173, 1.5, ">")) if J.t(_t1474) else _t1474)):
		J.sp(v_v_1172, "act", null)
	v_sx_1178 = (J.gp(J.gp(v_o_1174, "from"), "x") if J.t(J.gp(v_o_1174, "from")) else J.gp(v_u_1171, "x"))
	v_sy_1179 = (J.gp(J.gp(v_o_1174, "from"), "y") if J.t(J.gp(v_o_1174, "from")) else J.gp(v_u_1171, "y"))
	v_dx_1180 = J.sub(J.gp(v_v_1172, "x"), v_sx_1178)
	v_dy_1181 = J.sub(J.gp(v_v_1172, "y"), v_sy_1179)
	var _t1475 = J.hypot_([v_dx_1180, v_dy_1181])
	v_dl_1182 = (_t1475 if J.t(_t1475) else 1.0)
	var _t1476 = J.gp(v_o_1174, "kb")
	var _t1479 = (_t1476 if J.t(_t1476) else (170.0 if J.t(v_crit_1175) else (150.0 if J.cmp(v_mult_1173, 1.0, ">") else 70.0)))
	var _t1478 = null
	if J.t(J.gp(v_v_1172, "boss")):
		_t1478 = 0.25
	else:
		var _t1477 = J.gp(v_v_1172, "elite")
		_t1478 = (0.5 if J.t((_t1477 if J.t(_t1477) else (not J.leq(J.gp(v_v_1172, "guard"), null)))) else 1.0)
	v_kb_1183 = J.mul(_t1479, _t1478)
	var _t1480 = {"x": J.mul(J.div(v_dx_1180, v_dl_1182), v_kb_1183), "y": (J.mul(J.div(v_dy_1181, v_dl_1182), v_kb_1183) * 0.6)}
	J.sp(v_v_1172, "kb", _t1480)
	if J.t(J.gp(v_u_1171, "sk")):
		var _t1481 = J.gp(v_u_1171, "energy")
		var _t1482 = J.gp(v_u_1171, "energy")
		var _t1483 = J.min_([100.0, J.add((_t1482 if J.t(_t1482) else 0.0), (4.0 if J.cmp(v_mult_1173, 1.0, ">") else 10.0))])
		J.sp(v_u_1171, "energy", _t1483)
	var _t1484 = J.gp(v_v_1172, "sk")
	if J.t((J.seq(J.gp(v_v_1172, "side"), 1.0) if J.t(_t1484) else _t1484)):
		var _t1485 = J.gp(v_v_1172, "energy")
		var _t1486 = J.gp(v_v_1172, "energy")
		var _t1487 = J.min_([100.0, J.add((_t1486 if J.t(_t1486) else 0.0), 6.0)])
		J.sp(v_v_1172, "energy", _t1487)
	var _t1488 = J.gp(v_u_1171, "sk")
	var _t1489 = (J.gp(J.gp(v_u_1171, "sk"), "drain") if J.t(_t1488) else _t1488)
	if J.t((J.cmp(v_mult_1173, 1.0, ">") if J.t(_t1489) else _t1489)):
		var _t1490 = J.min_([J.gp(v_u_1171, "maxhp"), J.add(J.gp(v_u_1171, "hp"), J.mul(v_dmg_1177, J.gp(J.gp(v_u_1171, "sk"), "drain")))])
		J.sp(v_u_1171, "hp", _t1490)
	var _t1491 = J.seq(J.gp(v_u_1171, "fac"), "chan")
	var _t1492 = (J.seq(J.gp(v_u_1171, "side"), 0.0) if _t1491 else _t1491)
	if (J.seq(J.gp(v_u_1171, "role"), "crew") if _t1492 else _t1492):
		var _t1493 = J.min_([J.gp(v_u_1171, "maxhp"), J.add(J.gp(v_u_1171, "hp"), J.mul(v_dmg_1177, 0.08))])
		J.sp(v_u_1171, "hp", _t1493)
	var _t1494 = J.seq(J.gp(v_u_1171, "fac"), "lan")
	var _t1495 = (J.seq(J.gp(v_u_1171, "side"), 0.0) if _t1494 else _t1494)
	if ((randf() < 0.12) if _t1495 else _t1495):
		var _t1496 = J.add(J.gp(v_v_1172, "cd"), 0.6)
		J.sp(v_v_1172, "cd", _t1496)
		var _t1497 = env["fxText"]
		J.cl(_t1497, null, [J.gp(v_v_1172, "x"), J.sub(J.gp(v_v_1172, "y"), J.mul(70.0, J.gp(v_v_1172, "s"))), "卡到陰", "#9fdcff"])
	v_hy_1184 = J.sub(J.gp(v_v_1172, "y"), (J.mul(34.0, J.gp(v_v_1172, "s")) * 1.65))
	var _t1498 = env["spark"]
	J.cl(_t1498, null, [J.sub(J.gp(v_v_1172, "x"), (J.div(v_dx_1180, v_dl_1182) * 6.0)), v_hy_1184, (1.3 if J.t((v_crit_1175 if J.t(v_crit_1175) else J.cmp(v_mult_1173, 1.0, ">"))) else (0.7 if J.seq(J.gp(v_v_1172, "side"), 0.0) else 0.9)), ("#ff9a7a" if J.seq(J.gp(v_v_1172, "side"), 0.0) else ("#ffd84a" if J.t(v_crit_1175) else "#fff4c0"))])
	var _t1499 = (v_crit_1175 if J.t(v_crit_1175) else J.cmp(v_mult_1173, 1.0, ">"))
	var _t1500 = (_t1499 if J.t(_t1499) else J.seq(J.gp(v_v_1172, "side"), 0.0))
	var _t1501 = (_t1500 if J.t(_t1500) else J.gp(v_u_1171, "leader"))
	var _t1502 = (_t1501 if J.t(_t1501) else J.seq(J.gp(v_u_1171, "role"), "lead"))
	var _t1503 = (_t1502 if J.t(_t1502) else J.gp(v_v_1172, "boss"))
	if J.t((_t1503 if J.t(_t1503) else J.gp(v_v_1172, "elite"))):
		var _t1504 = J.gp(env["R"], "fx")
		J.mc(_t1504, "push", [{"kind": "num", "x": J.add(J.gp(v_v_1172, "x"), ((randf() - 0.5) * 14.0)), "y": J.sub(v_hy_1184, J.mul(30.0, J.gp(v_v_1172, "s"))), "vx": (J.div(v_dx_1180, v_dl_1182) * (14.0 + (randf() * 18.0))), "text": ((J.str(v_dmg_1177) + "!") if J.t(v_crit_1175) else J.add("", v_dmg_1177)), "col": ("#ffd84a" if J.t(v_crit_1175) else ("#fff" if J.t(J.gp(v_v_1172, "side")) else "#ff8a8a")), "big": (v_crit_1175 if J.t(v_crit_1175) else J.cmp(v_mult_1173, 1.4, ">")), "t": 0.0, "life": 0.95}])
	if J.t((v_crit_1175 if J.t(v_crit_1175) else J.cmp(v_mult_1173, 1.4, ">"))):
		var _t1505 = env["R"]
		var _t1506 = J.max_([J.gp(env["R"], "shake"), (4.0 if J.t(v_crit_1175) else 6.0)])
		J.sp(_t1505, "shake", _t1506)
		var _t1507 = env["R"]
		var _t1508 = J.gp(env["R"], "stop")
		var _t1509 = J.gp(env["R"], "stop")
		var _t1510 = J.max_([(_t1509 if J.t(_t1509) else 0.0), 0.05])
		J.sp(_t1507, "stop", _t1510)
	var _t1512 = J.S_Date_("now", [])
	var _t1511 = J.gp(env["R"], "sndAt")
	if (J.sub(_t1512, (_t1511 if J.t(_t1511) else 0.0)) > 80.0):
		var _t1513 = env["R"]
		var _t1514 = J.S_Date_("now", [])
		J.sp(_t1513, "sndAt", _t1514)
		J.mc(J.G.get("Sound"), "play", ["hit"])
	if J.cmp(J.gp(v_v_1172, "hp"), 0.0, "<="):
		J.sp(v_v_1172, "hp", 0.0)
		var _t1515 = env["R"]
		var _t1516 = J.max_([J.gp(env["R"], "shake"), (5.0 if J.seq(J.gp(v_v_1172, "side"), 1.0) else 3.0)])
		J.sp(_t1515, "shake", _t1516)
		var _t1517 = env["spark"]
		J.cl(_t1517, null, [J.gp(v_v_1172, "x"), v_hy_1184, 1.6, "#fff"])
		if J.seq(J.gp(v_v_1172, "side"), 1.0):
			var _t1518 = env["R"]
			var _t1519 = J.gp(env["R"], "stop")
			var _t1520 = J.gp(env["R"], "stop")
			var _t1521 = J.max_([(_t1520 if J.t(_t1520) else 0.0), 0.06])
			J.sp(_t1518, "stop", _t1521)
		var _t1522 = env["onDown"]
		J.cl(_t1522, null, [v_v_1172, v_u_1171])

func _f252(this_, a: Array, env):
	var v_e_1188 = null; var v_tg_1189 = null; var v_r_1190 = null
	v_e_1188 = J.arg(a, 0)
	v_tg_1189 = J.arg(a, 1)
	var _t1523 = env["R"]
	var _t1524 = J.gp(env["R"], "tele")
	var _t1525 = (_t1524 if J.t(_t1524) else [])
	J.sp(_t1523, "tele", _t1525)
	v_r_1190 = (120.0 if J.t(J.gp(v_e_1188, "boss")) else 92.0)
	var _t1526 = J.gp(env["R"], "tele")
	J.mc(_t1526, "push", [{"x": J.gp(v_tg_1189, "x"), "y": J.gp(v_tg_1189, "y"), "r": v_r_1190, "t": 0.0, "dur": (1.1 if J.t(J.gp(v_e_1188, "boss")) else 0.9), "src": v_e_1188}])
	var _t1527 = {"ph": "windup", "t": 0.0, "tg": v_tg_1189, "cast": false, "dur": (1.1 if J.t(J.gp(v_e_1188, "boss")) else 0.9), "slam": true}
	J.sp(v_e_1188, "act", _t1527)
	var _t1528 = J.cmp(J.gp(v_tg_1189, "x"), J.gp(v_e_1188, "x"), "<")
	J.sp(v_e_1188, "flip", _t1528)

func _f254(this_, a: Array, env):
	var v_e_1200 = null
	v_e_1200 = J.arg(a, 0)
	var _t1530 = J.cmp(J.gp(v_e_1200, "hp"), 0.0, ">")
	var _t1531 = ((not J.cmp(J.gp(v_e_1200, "down"), 0.0, ">")) if _t1530 else _t1530)
	return ((not J.t(J.gp(v_e_1200, "fled"))) if _t1531 else _t1531)

func _f255(this_, a: Array, env):
	var v_x_1201 = null
	v_x_1201 = J.arg(a, 0)
	var _t1533 = J.cmp(J.gp(v_x_1201, "hp"), 0.0, ">")
	return ((not J.t(J.gp(v_x_1201, "gone"))) if _t1533 else _t1533)

func _f256(this_, a: Array, env):
	var v_v_1202 = null
	v_v_1202 = J.arg(a, 0)
	return (J.hypot_([J.sub(J.gp(v_v_1202, "x"), J.gp(env["u"], "x")), J.sub(J.gp(v_v_1202, "y"), J.gp(env["u"], "y"))]) < 280.0)

func _f257(this_, a: Array, env):
	var v_v_1203 = null; var v_h_1204 = null
	v_v_1203 = J.arg(a, 0)
	v_h_1204 = J.mul(J.gp(v_v_1203, "maxhp"), J.gp(env["sk"], "mult"))
	var _t1535 = J.min_([J.gp(v_v_1203, "maxhp"), J.add(J.gp(v_v_1203, "hp"), v_h_1204)])
	J.sp(v_v_1203, "hp", _t1535)
	var _t1536 = env["__p"]["spr"]
	J.cl(_t1536, null, ["fx_heal", J.gp(v_v_1203, "x"), J.sub(J.gp(v_v_1203, "y"), 30.0), {"s0": 0.15, "s1": 0.35, "life": 0.8, "vy": 30.0, "spin": 1.5}])
	var _t1537 = env["__p"]["fxText"]
	J.cl(_t1537, null, [J.gp(v_v_1203, "x"), J.sub(J.gp(v_v_1203, "y"), 60.0), J.add("+", J.round(J.num(v_h_1204))), "#8affb0"])
	var _t1538 = J.gp(env["__p"]["R"], "fx")
	J.mc(_t1538, "push", [{"kind": "ring", "x": J.gp(v_v_1203, "x"), "y": J.gp(v_v_1203, "y"), "t": 0.0, "life": 0.5, "col": "#8affb0", "r": 40.0}])

func _f258(this_, a: Array, env):
	var v_v_1205 = null
	v_v_1205 = J.arg(a, 0)
	return (J.hypot_([J.sub(J.gp(v_v_1205, "x"), J.gp(env["u"], "x")), (J.sub(J.gp(v_v_1205, "y"), J.gp(env["u"], "y")) * 1.3)]) < 210.0)

func _f259(this_, a: Array, env):
	var v_v_1206 = null
	v_v_1206 = J.arg(a, 0)
	var _t1540 = env["__p"]["hit"]
	return J.cl(_t1540, null, [env["u"], v_v_1206, J.gp(env["sk"], "mult"), {"kb": 240.0}])

func _f253(this_, a: Array, env):
	var v_foes_1195 = null; var v_allies_1196 = null; var v_enemies_1197 = null; var v_mine_1198 = null; var v_col_1199 = null; var v_v_1207 = null; var v_n_1208 = null; var v_i_1209 = null; var v_d_1210 = null; var v_e_1211 = null
	var _s516 = {"__p": env, "u": null, "sk": null}
	_s516["u"] = J.arg(a, 0)
	_s516["sk"] = J.gp(_s516["u"], "sk")
	if (not J.t(_s516["sk"])):
		return null
	var _t1529 = J.gp(_s516["__p"]["R"], "foes")
	v_foes_1195 = J.mc(_t1529, "filter", [Callable(self, "_f254").bind(_s516)])
	var _t1532 = J.gp(_s516["__p"]["R"], "units")
	v_allies_1196 = J.mc(_t1532, "filter", [Callable(self, "_f255").bind(_s516)])
	v_enemies_1197 = (v_foes_1195 if J.seq(J.gp(_s516["u"], "side"), 0.0) else v_allies_1196)
	v_mine_1198 = (v_allies_1196 if J.seq(J.gp(_s516["u"], "side"), 0.0) else v_foes_1195)
	v_col_1199 = ("#ff9ac0" if J.t(J.gp(_s516["u"], "side")) else "#9ff3ff")
	if J.seq(J.gp(_s516["sk"], "kind"), "heal"):
		var _t1534 = J.mc(v_mine_1198, "filter", [Callable(self, "_f256").bind(_s516)])
		J.mc(_t1534, "forEach", [Callable(self, "_f257").bind(_s516)])
	else:
		if J.seq(J.gp(_s516["sk"], "kind"), "aoe"):
			var _t1539 = J.mc(v_enemies_1197, "filter", [Callable(self, "_f258").bind(_s516)])
			J.mc(_t1539, "forEach", [Callable(self, "_f259").bind(_s516)])
			var _t1541 = _s516["__p"]["img"]
			if J.t(J.cl(_t1541, null, ["fx_wind"])):
				var _t1542 = _s516["__p"]["spr"]
				J.cl(_t1542, null, ["fx_wind", J.gp(_s516["u"], "x"), J.gp(_s516["u"], "y"), {"s0": 0.4, "s1": 1.1, "life": 0.6, "anchor": 0.85, "hue": ((-155.0) if J.t(J.gp(_s516["u"], "side")) else 0.0)}])
				var _t1543 = _s516["__p"]["spr"]
				J.cl(_t1543, null, ["fx_scream", J.gp(_s516["u"], "x"), J.sub(J.gp(_s516["u"], "y"), 40.0), {"s0": 0.3, "s1": 1.6, "life": 0.5, "alpha": 0.8, "hue": ((-155.0) if J.t(J.gp(_s516["u"], "side")) else 0.0)}])
				var _t1544 = _s516["__p"]["spr"]
				J.cl(_t1544, null, ["fx_shock", J.gp(_s516["u"], "x"), J.gp(_s516["u"], "y"), {"ground": true, "s0": 0.8, "s1": 1.8, "life": 0.5, "hue": ((-155.0) if J.t(J.gp(_s516["u"], "side")) else 0.0)}])
			else:
				var _t1545 = J.gp(_s516["__p"]["R"], "fx")
				J.mc(_t1545, "push", [{"kind": "ring", "x": J.gp(_s516["u"], "x"), "y": J.gp(_s516["u"], "y"), "t": 0.0, "life": 0.5, "col": v_col_1199, "r": 210.0}])
			var _t1546 = _s516["__p"]["R"]
			J.sp(_t1546, "flash", 0.35)
			var _t1547 = _s516["__p"]["R"]
			J.sp(_t1547, "shake", 8.0)
		else:
			var _t1548 = _s516["__p"]["nearest"]
			v_v_1207 = J.cl(_t1548, null, [_s516["u"], v_enemies_1197, 280.0])
			if J.t(v_v_1207):
				var _t1549 = J.gp(_s516["sk"], "hits")
				v_n_1208 = (_t1549 if J.t(_t1549) else 1.0)
				v_i_1209 = 0.0
				while true:
					if not J.cmp(v_i_1209, v_n_1208, "<"): break
					var _t1550 = _s516["__p"]["hit"]
					J.cl(_t1550, null, [_s516["u"], v_v_1207, J.div(J.gp(_s516["sk"], "mult"), v_n_1208), {"kb": (260.0 if J.seq(v_i_1209, J.sub(v_n_1208, 1.0)) else 60.0)}])
					v_i_1209 = J.num(v_i_1209) + 1.0
				var _t1551 = _s516["__p"]["img"]
				if J.t(J.cl(_t1551, null, ["fx_slash"])):
					var _t1552 = signf(J.num(J.sub(J.gp(v_v_1207, "x"), J.gp(_s516["u"], "x"))))
					v_d_1210 = (_t1552 if J.t(_t1552) else 1.0)
					var _t1553 = _s516["__p"]["spr"]
					var _t1557 = J.gp(v_v_1207, "x")
					var _t1558 = J.sub(J.gp(v_v_1207, "y"), (J.mul(34.0, J.gp(v_v_1207, "s")) * 1.65))
					var _t1556 = J.cmp(v_d_1210, 0.0, "<")
					var _t1555 = null
					if J.t(J.gp(_s516["u"], "side")):
						_t1555 = (-155.0)
					else:
						var _t1554 = J.gp(_s516["__p"]["HUE"], J.gp(_s516["u"], "fac"))
						_t1555 = (_t1554 if J.t(_t1554) else 0.0)
					J.cl(_t1553, null, ["fx_slash", _t1557, _t1558, {"s0": 0.35, "s1": 0.6, "life": 0.3, "flip": _t1556, "hue": _t1555}])
					var _t1559 = _s516["__p"]["spr"]
					J.cl(_t1559, null, ["fx_hit", J.gp(v_v_1207, "x"), J.sub(J.gp(v_v_1207, "y"), (J.mul(34.0, J.gp(v_v_1207, "s")) * 1.65)), {"s0": 0.2, "s1": 0.45, "life": 0.25}])
					var _t1560 = _s516["__p"]["spr"]
					J.cl(_t1560, null, ["fx_bolt", J.gp(v_v_1207, "x"), J.sub(J.gp(v_v_1207, "y"), 50.0), {"s0": 0.25, "s1": 0.4, "life": 0.2}])
				else:
					var _t1561 = J.gp(_s516["__p"]["R"], "fx")
					var _t1563 = J.gp(v_v_1207, "x")
					var _t1564 = J.sub(J.gp(v_v_1207, "y"), (J.mul(34.0, J.gp(v_v_1207, "s")) * 1.65))
					var _t1562 = signf(J.num(J.sub(J.gp(v_v_1207, "x"), J.gp(_s516["u"], "x"))))
					J.mc(_t1561, "push", [{"kind": "slash", "x": _t1563, "y": _t1564, "dir": (_t1562 if J.t(_t1562) else 1.0), "t": 0.0, "life": 0.3, "r": 40.0, "col": v_col_1199}])
				var _t1565 = J.gp(_s516["sk"], "steal")
				if J.t((J.seq(J.gp(_s516["u"], "side"), 0.0) if J.t(_t1565) else _t1565)):
					var _t1566 = _s516["__p"]["gain"]
					J.cl(_t1566, null, [{"coins": J.gp(_s516["sk"], "steal")}])
	var _t1567 = J.gp(_s516["__p"]["R"], "fx")
	J.mc(_t1567, "push", [{"kind": "num", "x": J.gp(_s516["u"], "x"), "y": J.sub(J.gp(_s516["u"], "y"), (J.mul(95.0, J.gp(_s516["u"], "s")) * 1.65)), "text": J.gp(_s516["sk"], "name"), "col": v_col_1199, "skill": true, "t": 0.0, "life": 1.1}])
	J.mc(J.G.get("Sound"), "play", ["skill"])

func _f260(this_, a: Array, env):
	var v_L_1214 = null; var v_f_1215 = null; var v_e_1216 = null
	v_L_1214 = (J.gp(env["R"], "L") if J.t(env["R"]) else env["R"])
	var _t1568 = (not J.t(v_L_1214))
	var _t1569 = (_t1568 if _t1568 else J.cmp(J.gp(v_L_1214, "hp"), 0.0, "<="))
	var _t1570 = (_t1569 if _t1569 else J.cmp(J.gp(env["R"], "dashCd"), 0.0, ">"))
	if J.t((_t1570 if _t1570 else J.gp(env["R"], "ended"))):
		return null
	var _t1571 = J.gp(env["R"], "face")
	v_f_1215 = (_t1571 if J.t(_t1571) else {"x": ((-1.0) if J.t(J.gp(v_L_1214, "flip")) else 1.0), "y": 0.0})
	var _t1572 = J.mul(J.gp(v_f_1215, "x"), 640.0)
	J.sp(v_L_1214, "vx", _t1572)
	var _t1573 = J.mul(J.gp(v_f_1215, "y"), 640.0)
	J.sp(v_L_1214, "vy", _t1573)
	J.sp(v_L_1214, "dash", 0.24)
	var _t1574 = J.new_("Set", [])
	J.sp(v_L_1214, "dashHit", _t1574)
	J.sp(v_L_1214, "act", null)
	var _t1575 = env["R"]
	J.sp(_t1575, "dashCd", 3.5)
	var _t1576 = env["dust"]
	J.cl(_t1576, null, [J.gp(v_L_1214, "x"), J.gp(v_L_1214, "y"), 1.1])
	var _t1577 = env["img"]
	if J.t(J.cl(_t1577, null, ["fx_dash"])):
		var _t1578 = env["spr"]
		J.cl(_t1578, null, ["fx_dash", J.add(J.gp(v_L_1214, "x"), J.mul(J.gp(v_f_1215, "x"), 50.0)), J.sub(J.gp(v_L_1214, "y"), 34.0), {"s0": 0.35, "s1": 0.55, "life": 0.3, "rot": atan2(J.num(J.gp(v_f_1215, "y")), J.num(J.gp(v_f_1215, "x")))}])
	J.mc(J.G.get("Sound"), "play", ["click"])

func _f261(this_, a: Array, env):
	var v_lines_1219 = null; var v_l_1220 = null; var v_u_1221 = null; var v_e_1222 = null
	var _t1579 = (not J.t(env["R"]))
	var _t1580 = (_t1579 if _t1579 else J.cmp(J.gp(env["R"], "pieCd"), 0.0, ">"))
	var _t1581 = (_t1580 if _t1580 else J.gp(env["R"], "ended"))
	if J.t((_t1581 if J.t(_t1581) else J.cmp(J.gp(J.gp(env["R"], "L"), "hp"), 0.0, "<="))):
		return null
	var _t1582 = env["R"]
	J.sp(_t1582, "buff", 8.0)
	var _t1583 = env["R"]
	J.sp(_t1583, "pieCd", 30.0)
	var _t1584 = env["R"]
	J.sp(_t1584, "flash", 0.25)
	for _t1585 in J.iter(J.gp(env["R"], "units")):
		v_u_1221 = _t1585
		if J.cmp(J.gp(v_u_1221, "hp"), 0.0, ">"):
			var _t1586 = env["img"]
			if J.t(J.cl(_t1586, null, ["fx_aura"])):
				var _t1587 = env["spr"]
				J.cl(_t1587, null, ["fx_aura", J.gp(v_u_1221, "x"), J.add(J.gp(v_u_1221, "y"), 4.0), {"s0": 0.15, "s1": 0.3, "life": 0.8, "anchor": 0.95}])
			else:
				var _t1588 = J.gp(env["R"], "fx")
				J.mc(_t1588, "push", [{"kind": "ring", "x": J.gp(v_u_1221, "x"), "y": J.gp(v_u_1221, "y"), "t": 0.0, "life": 0.6, "col": "#ffd84a", "r": 36.0}])
			var _t1589 = J.gp(v_u_1221, "g")
			if J.t((J.seq(J.gp(v_u_1221, "role"), "crew") if J.t(_t1589) else _t1589)):
				var _t1590 = J.gp(v_u_1221, "g")
				var _t1591 = J.gp(J.gp(v_u_1221, "g"), "fat")
				var _t1592 = J.gp(J.gp(v_u_1221, "g"), "fat")
				var _t1593 = J.min_([100.0, J.add((_t1592 if J.t(_t1592) else 0.0), 4.0)])
				J.sp(_t1590, "fat", _t1593)
	var _t1594 = env["T"]
	var _t1596 = ["阿福", J.cl(_t1594, null, ["各位！做完今晚，年尾分紅一定有！（應該）", "各位！做完今晚，年底分紅一定有！（應該）"])]
	var _t1595 = env["T"]
	var _t1598 = ["阿福", J.cl(_t1595, null, ["公司好睇好你哋㗎！（我估）", "公司很看好你們的！（我猜）"])]
	var _t1597 = env["T"]
	v_lines_1219 = [_t1596, _t1598, ["阿福", J.cl(_t1597, null, ["呢個 project 做完，大家升職！（未批）", "這個 project 做完，大家升職！（還沒批）"])]]
	v_l_1220 = J.gp(v_lines_1219, floor(J.num((randf() * J.len(v_lines_1219)))))
	var _t1599 = env["msg"]
	J.cl(_t1599, null, [("<b>" + J.str(J.gp(v_l_1220, 0.0)) + "</b>：" + J.str(J.gp(v_l_1220, 1.0)) + "　全隊攻擊 +30%"), 2.5])
	J.mc(J.G.get("Sound"), "play", ["gong"])

func _f262(this_, a: Array, env):
	var v_x_1225 = null; var v_y_1226 = null; var v_k_1227 = null; var v_col_1228 = null; var v_n_1229 = null; var v_rays_1230 = null; var v_i_1231 = null
	v_x_1225 = J.arg(a, 0)
	v_y_1226 = J.arg(a, 1)
	v_k_1227 = J.arg(a, 2)
	v_col_1228 = J.arg(a, 3)
	var _t1600 = env["img"]
	if J.t(J.cl(_t1600, null, ["fx_hit"])):
		var _t1601 = env["spr"]
		J.cl(_t1601, null, ["fx_hit", v_x_1225, v_y_1226, {"s0": J.mul(0.08, v_k_1227), "s1": J.mul(0.22, v_k_1227), "life": 0.18, "rot": (randf() * 6.28), "hue": ((-155.0) if J.seq(v_col_1228, "#ff9a7a") else 0.0)}])
		var _t1603 = J.cmp(v_k_1227, 1.3, ">=")
		if J.t(_t1603):
			var _t1602 = env["img"]
			_t1603 = J.cl(_t1602, null, ["fx_bolt"])
		if J.t(_t1603):
			var _t1604 = env["spr"]
			J.cl(_t1604, null, ["fx_bolt", v_x_1225, J.sub(v_y_1226, 6.0), {"s0": 0.18, "s1": 0.3, "life": 0.16, "rot": ((randf() - 0.5) * 1.2)}])
		return null
	v_n_1229 = (7.0 + floor(J.num((randf() * 4.0))))
	v_rays_1230 = []
	v_i_1231 = 0.0
	while true:
		if not J.cmp(v_i_1231, v_n_1229, "<"): break
		J.mc(v_rays_1230, "push", [{"a": (((J.div(v_i_1231, v_n_1229) * PI) * 2.0) + ((randf() - 0.5) * 0.5)), "len": J.mul((12.0 + (randf() * 14.0)), v_k_1227), "j": (randf() * 1000.0)}])
		v_i_1231 = J.num(v_i_1231) + 1.0
	var _t1605 = J.gp(env["R"], "fx")
	J.mc(_t1605, "push", [{"kind": "spark", "x": v_x_1225, "y": v_y_1226, "t": 0.0, "life": 0.24, "rays": v_rays_1230, "col": v_col_1228, "k": v_k_1227, "rot": (randf() * PI)}])

func _f263(this_, a: Array, env):
	var v_n_1234 = null; var v_hue_1235 = null; var v_im_1236 = null; var v_k_1237 = null; var v_c_1238 = null; var v_x_1239 = null
	v_n_1234 = J.arg(a, 0)
	v_hue_1235 = J.arg(a, 1)
	var _t1606 = env["img"]
	v_im_1236 = J.cl(_t1606, null, [v_n_1234])
	if (not J.t(v_im_1236)):
		return null
	if (not J.t(v_hue_1235)):
		return v_im_1236
	v_k_1237 = J.add(J.add(v_n_1234, "@"), v_hue_1235)
	if J.t(J.gp(env["TINT"], v_k_1237)):
		return J.gp(env["TINT"], v_k_1237)
	v_c_1238 = J.S_document_("createElement", ["canvas"])
	var _t1607 = J.gp(v_im_1236, "naturalWidth")
	J.sp(v_c_1238, "width", _t1607)
	var _t1608 = J.gp(v_im_1236, "naturalHeight")
	J.sp(v_c_1238, "height", _t1608)
	v_x_1239 = J.mc(v_c_1238, "getContext", ["2d"])
	var _t1609 = ("hue-rotate(" + J.str(v_hue_1235) + "deg) saturate(1.2)")
	J.sp(v_x_1239, "filter", _t1609)
	J.mc(v_x_1239, "drawImage", [v_im_1236, 0.0, 0.0])
	var _t1610 = env["TINT"]
	J.sp(_t1610, v_k_1237, v_c_1238)
	return v_c_1238

func _f264(this_, a: Array, env):
	var v_n_1242 = null; var v_x_1243 = null; var v_y_1244 = null; var v_o_1245 = null
	v_n_1242 = J.arg(a, 0)
	v_x_1243 = J.arg(a, 1)
	v_y_1244 = J.arg(a, 2)
	v_o_1245 = J.arg(a, 3)
	var _t1611 = (v_o_1245 if J.t(v_o_1245) else {})
	v_o_1245 = _t1611
	var _t1612 = J.gp(env["R"], "fx")
	J.mc(_t1612, "push", [J.S_Object_("assign", [{"kind": "spr", "n": v_n_1242, "x": v_x_1243, "y": v_y_1244, "t": 0.0, "life": 0.3, "s0": 0.3, "s1": 0.5, "rot": 0.0, "alpha": 1.0, "add": true, "sx": 1.0, "sy": 1.0, "vy": 0.0, "hue": 0.0}, v_o_1245])])

func _f265(this_, a: Array, env):
	var v_c_1248 = null; var v_f_1249 = null; var v_im_1250 = null; var v_p_1251 = null; var v_e_1252 = null; var v_sc_1253 = null; var v_a_1254 = null; var v_w_1255 = null; var v_h_1256 = null
	v_c_1248 = J.arg(a, 0)
	v_f_1249 = J.arg(a, 1)
	var _t1613 = env["fxImg"]
	v_im_1250 = J.cl(_t1613, null, [J.gp(v_f_1249, "n"), J.gp(v_f_1249, "hue")])
	if (not J.t(v_im_1250)):
		return null
	v_p_1251 = J.div(J.gp(v_f_1249, "t"), J.gp(v_f_1249, "life"))
	v_e_1252 = (1.0 - pow(J.num(J.sub(1.0, v_p_1251)), J.num(2.2)))
	v_sc_1253 = J.add(J.gp(v_f_1249, "s0"), J.mul(J.sub(J.gp(v_f_1249, "s1"), J.gp(v_f_1249, "s0")), v_e_1252))
	var _t1615 = J.gp(v_f_1249, "alpha")
	var _t1614 = J.gp(v_f_1249, "fadeIn")
	v_a_1254 = (J.mul(_t1615, (J.div(v_p_1251, 0.2) if J.t((J.cmp(v_p_1251, 0.2, "<") if J.t(_t1614) else _t1614)) else 1.0)) * (1.0 if J.cmp(v_p_1251, 0.55, "<") else (1.0 - J.div(J.sub(v_p_1251, 0.55), 0.45))))
	var _t1616 = J.gp(v_im_1250, "naturalWidth")
	v_w_1255 = J.mul(J.mul((_t1616 if J.t(_t1616) else J.gp(v_im_1250, "width")), v_sc_1253), J.gp(v_f_1249, "sx"))
	var _t1617 = J.gp(v_im_1250, "naturalHeight")
	v_h_1256 = J.mul(J.mul((_t1617 if J.t(_t1617) else J.gp(v_im_1250, "height")), v_sc_1253), J.gp(v_f_1249, "sy"))
	J.mc(v_c_1248, "save", [])
	var _t1618 = J.max_([0.0, v_a_1254])
	J.sp(v_c_1248, "globalAlpha", _t1618)
	if J.t(J.gp(v_f_1249, "add")):
		J.sp(v_c_1248, "globalCompositeOperation", "lighter")
	var _t1620 = J.gp(v_f_1249, "x")
	var _t1619 = J.gp(v_f_1249, "vx")
	J.mc(v_c_1248, "translate", [J.add(_t1620, J.mul((_t1619 if J.t(_t1619) else 0.0), v_p_1251)), J.sub(J.gp(v_f_1249, "y"), J.mul(J.gp(v_f_1249, "vy"), v_p_1251))])
	var _t1621 = J.gp(v_f_1249, "rot")
	if J.t((_t1621 if J.t(_t1621) else J.gp(v_f_1249, "spin"))):
		var _t1623 = J.gp(v_f_1249, "rot")
		var _t1622 = J.gp(v_f_1249, "spin")
		J.mc(v_c_1248, "rotate", [J.add(_t1623, J.mul((_t1622 if J.t(_t1622) else 0.0), v_p_1251))])
	if J.t(J.gp(v_f_1249, "flip")):
		J.mc(v_c_1248, "scale", [(-1.0), 1.0])
	J.mc(v_c_1248, "drawImage", [v_im_1250, J.div((-J.num(v_w_1255)), 2.0), J.mul((-J.num(v_h_1256)), (J.gp(v_f_1249, "anchor") if (not J.leq(J.gp(v_f_1249, "anchor"), null)) else 0.5)), v_w_1255, v_h_1256])
	J.mc(v_c_1248, "restore", [])

func _f266(this_, a: Array, env):
	var v_x_1259 = null; var v_y_1260 = null; var v_k_1261 = null; var v_puffs_1262 = null; var v_i_1263 = null
	v_x_1259 = J.arg(a, 0)
	v_y_1260 = J.arg(a, 1)
	v_k_1261 = J.arg(a, 2)
	var _t1624 = env["img"]
	if J.t(J.cl(_t1624, null, ["fx_dust"])):
		var _t1625 = env["spr"]
		J.cl(_t1625, null, ["fx_dust", J.add(v_x_1259, ((randf() - 0.5) * 10.0)), v_y_1260, {"add": true, "alpha": 0.45, "s0": J.mul(0.06, v_k_1261), "s1": J.mul(0.16, v_k_1261), "life": 0.5, "vy": 10.0, "anchor": 0.8, "flip": (randf() < 0.5)}])
		return null
	v_puffs_1262 = []
	v_i_1263 = 0.0
	while true:
		if not J.cmp(v_i_1263, 5.0, "<"): break
		J.mc(v_puffs_1262, "push", [{"dx": J.mul(((randf() - 0.5) * 18.0), v_k_1261), "vx": J.mul(((randf() - 0.5) * 60.0), v_k_1261), "r": J.mul((4.0 + (randf() * 4.0)), v_k_1261)}])
		v_i_1263 = J.num(v_i_1263) + 1.0
	var _t1626 = J.gp(env["R"], "fx")
	J.mc(_t1626, "push", [{"kind": "dust", "x": v_x_1259, "y": v_y_1260, "t": 0.0, "life": 0.45, "puffs": v_puffs_1262}])

func _f267(this_, a: Array, env):
	var v_dt_1266 = null; var v_L_1267 = null; var v_w_1268 = null
	v_dt_1266 = J.arg(a, 0)
	var _t1627 = env["R"]
	var _t1628 = J.gp(env["R"], "wisps")
	var _t1629 = (_t1628 if J.t(_t1628) else [])
	J.sp(_t1627, "wisps", _t1629)
	v_L_1267 = J.gp(env["R"], "L")
	while true:
		if not (J.len(J.gp(env["R"], "wisps")) < 26.0): break
		var _t1630 = J.gp(env["R"], "wisps")
		J.mc(_t1630, "push", [{"x": J.add(J.gp(v_L_1267, "x"), ((randf() - 0.5) * 700.0)), "y": J.add(J.gp(v_L_1267, "y"), ((randf() - 0.5) * 1000.0)), "vx": ((randf() - 0.5) * 14.0), "vy": ((-6.0) - (randf() * 12.0)), "ph": (randf() * 6.0), "r": (1.2 + (randf() * 1.8)), "hue": (0.0 if (randf() < 0.7) else 1.0)}])
	for _t1631 in J.iter(J.gp(env["R"], "wisps")):
		v_w_1268 = _t1631
		var _t1632 = J.add(J.gp(v_w_1268, "x"), J.mul(J.add(J.gp(v_w_1268, "vx"), (sin(J.num(J.add(J.gp(env["R"], "t"), J.gp(v_w_1268, "ph")))) * 8.0)), v_dt_1266))
		J.sp(v_w_1268, "x", _t1632)
		var _t1633 = J.add(J.gp(v_w_1268, "y"), J.mul(J.gp(v_w_1268, "vy"), v_dt_1266))
		J.sp(v_w_1268, "y", _t1633)
		var _t1634 = (absf(J.num(J.sub(J.gp(v_w_1268, "x"), J.gp(v_L_1267, "x")))) > 420.0)
		if (_t1634 if _t1634 else (absf(J.num(J.sub(J.gp(v_w_1268, "y"), J.gp(v_L_1267, "y")))) > 620.0)):
			var _t1635 = J.add(J.gp(v_L_1267, "x"), ((randf() - 0.5) * 700.0))
			J.sp(v_w_1268, "x", _t1635)
			var _t1636 = J.add(J.add(J.gp(v_L_1267, "y"), 300.0), (randf() * 300.0))
			J.sp(v_w_1268, "y", _t1636)

func _f268(this_, a: Array, env):
	var v_x_1271 = null; var v_y_1272 = null; var v_text_1273 = null; var v_col_1274 = null; var v_big_1275 = null
	v_x_1271 = J.arg(a, 0)
	v_y_1272 = J.arg(a, 1)
	v_text_1273 = J.arg(a, 2)
	v_col_1274 = J.arg(a, 3)
	v_big_1275 = J.arg(a, 4)
	var _t1637 = J.gp(env["R"], "fx")
	J.mc(_t1637, "push", [{"kind": "num", "x": v_x_1271, "y": v_y_1272, "text": v_text_1273, "col": v_col_1274, "big": v_big_1275, "t": 0.0, "life": 0.95, "vx": ((randf() - 0.5) * 30.0)}])

func _f270(this_, a: Array, env):
	var _t1642 = J.gp(env["m"], "classList")
	return J.mc(_t1642, "remove", ["on"])

func _f269(this_, a: Array, env):
	var v_h_1278 = null; var v_sec_1279 = null
	var _s556 = {"__p": env, "m": null}
	v_h_1278 = J.arg(a, 0)
	v_sec_1279 = J.arg(a, 1)
	var _t1638 = J.G.get("$")
	_s556["m"] = J.cl(_t1638, null, ["#pt-msg"])
	if (not J.t(_s556["m"])):
		return null
	var _t1639 = _s556["m"]
	J.sp(_t1639, "innerHTML", v_h_1278)
	var _t1640 = J.gp(_s556["m"], "classList")
	J.mc(_t1640, "add", ["on"])
	J.F_clearTimeout([J.gp(_s556["__p"]["msg"], "_t")])
	var _t1641 = _s556["__p"]["msg"]
	var _t1643 = J.F_setTimeout([Callable(self, "_f270").bind(_s556), J.mul((v_sec_1279 if J.t(v_sec_1279) else 3.0), 1000.0)])
	J.sp(_t1641, "_t", _t1643)

func _f271(this_, a: Array, env):
	var v_v_1283 = null; var v_by_1284 = null; var v_u_1285 = null
	v_v_1283 = J.arg(a, 0)
	v_by_1284 = J.arg(a, 1)
	if J.seq(J.gp(v_v_1283, "side"), 0.0):
		J.sp(v_v_1283, "deadT", 0.0)
		if J.seq(J.gp(v_v_1283, "role"), "crew"):
			var _t1644 = J.gp(v_v_1283, "g")
			J.sp(_t1644, "fat", 100.0)
			var _t1645 = env["fxText"]
			J.cl(_t1645, null, [J.gp(v_v_1283, "x"), J.sub(J.gp(v_v_1283, "y"), 40.0), "倒下", "#fca"])
		if J.seq(J.gp(v_v_1283, "role"), "troop"):
			var _t1646 = J.gp(J.G.get("S"), "res")
			var _t1647 = J.max_([0.0, J.sub(J.gp(J.gp(J.G.get("S"), "res"), "troops"), 25.0)])
			J.sp(_t1646, "troops", _t1647)
		return null
	var _t1648 = env["R"]
	J.sp(_t1648, "streak", J.num(J.gp(_t1648, "streak")) + 1.0)
	var _t1649 = J.gp(env["R"], "loot")
	J.sp(_t1649, "kills", J.num(J.gp(_t1649, "kills")) + 1.0)
	var _t1650 = J.cl(env["st"], null, [])
	J.sp(_t1650, "kills", J.num(J.gp(_t1650, "kills")) + 1.0)
	for _t1651 in J.iter(J.gp(env["R"], "units")):
		v_u_1285 = _t1651
		var _t1652 = J.seq(J.gp(v_u_1285, "role"), "crew")
		var _t1653 = (J.cmp(J.gp(v_u_1285, "hp"), 0.0, ">") if _t1652 else _t1652)
		if J.t((J.gp(v_u_1285, "inFight") if _t1653 else _t1653)):
			var _t1654 = J.gp(v_u_1285, "g")
			var _t1655 = J.gp(J.gp(v_u_1285, "g"), "fat")
			var _t1656 = J.gp(J.gp(v_u_1285, "g"), "fat")
			var _t1657 = J.min_([100.0, J.add((_t1656 if J.t(_t1656) else 0.0), 1.5)])
			J.sp(_t1654, "fat", _t1657)
	var _t1658 = (not J.leq(J.gp(v_v_1283, "guard"), null))
	var _t1659 = (_t1658 if _t1658 else J.gp(v_v_1283, "bryan"))
	if J.t((_t1659 if J.t(_t1659) else J.gp(v_v_1283, "otBoss"))):
		J.sp(v_v_1283, "deadT", 0.0)
		var _t1660 = env["soulDrop"]
		J.cl(_t1660, null, [v_v_1283, 0.6])
		return null
	var _t1661 = env["DOWN_T"]
	J.sp(v_v_1283, "down", _t1661)
	var _t1662 = env["DOWN_T"]
	J.sp(v_v_1283, "downMax", _t1662)
	var _t1663 = J.gp(env["R"], "downs")
	J.mc(_t1663, "push", [v_v_1283])
	if J.t(J.gp(J.cl(env["st"], null, []), "auto")):
		var _t1664 = env["resolveDown"]
		J.cl(_t1664, null, [v_v_1283, "soul"])
		return null
	J.cl(env["downUI"], null, [])

func _f273(this_, a: Array, env):
	var v_s_1296 = null; var v_si_1297 = null
	v_s_1296 = J.arg(a, 0)
	v_si_1297 = J.arg(a, 1)
	var _t1670 = J.gp(J.G.get("S"), "cleared")
	var _t1669 = env["sidOf"]
	return J.gp(_t1670, J.cl(_t1669, null, [J.gp(env["R"], "ci"), v_si_1297]))

func _f274(this_, a: Array, env):
	var v_t_1301 = null
	v_t_1301 = J.arg(a, 0)
	var _t1674 = J.gp(env["f"], "w")
	return J.mc(_t1674, "includes", [v_t_1301])

func _f272(this_, a: Array, env):
	var v_v_1288 = null; var v_p_1289 = null; var v_ph_1290 = null; var v_isN_1291 = null; var v_ch_1292 = null; var v_regClr_1293 = null; var v_fear_1294 = null; var v_cost_1295 = null; var v_by_1298 = null; var v_ts_1300 = null; var v_e_1302 = null
	v_v_1288 = J.arg(a, 0)
	v_p_1289 = J.cl(env["st"], null, [])
	var _t1665 = env["phase"]
	v_ph_1290 = J.cl(_t1665, null, [J.gp(v_p_1289, "min")])
	v_isN_1291 = (not (not J.t(J.gp(J.G.get("N30_G"), J.gp(v_v_1288, "k")))))
	if J.t((J.mc(J.G.get("N30W"), "owned", [J.gp(v_v_1288, "k")]) if J.t(v_isN_1291) else v_isN_1291)):
		return {"ok": false, "why": "已經收服了"}
	if J.t((J.cmp(J.gp(J.G.get("S"), "lv"), J.gp(J.gp(J.G.get("N30_TIER"), J.gp(J.gp(J.G.get("N30_G"), J.gp(v_v_1288, "k")), "t")), "req"), "<") if J.t(v_isN_1291) else v_isN_1291)):
		return {"ok": false, "why": ("需主公 Lv" + J.str(J.gp(J.gp(J.G.get("N30_TIER"), J.gp(J.gp(J.G.get("N30_G"), J.gp(v_v_1288, "k")), "t")), "req")))}
	var _t1666 = (not J.t(v_isN_1291))
	if ((not J.t(J.gp(J.G.get("FODDER"), J.gp(v_v_1288, "k")))) if _t1666 else _t1666):
		return {"ok": false, "why": "不肯簽"}
	var _t1667 = (not J.t(v_isN_1291))
	if (J.cmp(J.cl(J.G.get("fodderCount"), null, []), J.mc(J.G.get("F"), "rosterCap", []), ">=") if _t1667 else _t1667):
		return {"ok": false, "why": "編制滿了（升級民宅）"}
	v_ch_1292 = (30.0 if J.t(v_isN_1291) else 60.0)
	var _t1668 = J.gp(J.gp(J.G.get("CHAPTERS"), J.gp(env["R"], "ci")), "stages")
	v_regClr_1293 = J.len(J.mc(_t1668, "filter", [Callable(self, "_f273").bind(env)]))
	var _t1671 = J.mul(v_ch_1292, (0.8 + J.div(J.mul(0.4, v_regClr_1293), 3.0)))
	v_ch_1292 = _t1671
	var _t1672 = J.gp(J.gp(v_p_1289, "pity"), J.gp(v_v_1288, "k"))
	var _t1673 = J.add(v_ch_1292, (_t1672 if J.t(_t1672) else 0.0))
	v_ch_1292 = _t1673
	v_fear_1294 = false
	var _s567 = {"__p": env, "f": null}
	v_by_1298 = J.gp(v_v_1288, "lastBy")
	_s567["f"] = J.mc(J.G.get("Rework"), "fearOf", [J.gp(v_v_1288, "k")])
	v_ts_1300 = (J.mc(J.G.get("Rework"), "typesOf", [J.gp(v_by_1298, "k")]) if J.t(v_by_1298) else v_by_1298)
	var _t1675 = (_s567["f"] if J.t(v_ts_1300) else v_ts_1300)
	if J.t((J.mc(v_ts_1300, "some", [Callable(self, "_f274").bind(_s567)]) if J.t(_t1675) else _t1675)):
		var _t1676 = J.add(v_ch_1292, 20.0)
		v_ch_1292 = _t1676
		v_fear_1294 = true
	if J.seq(v_ph_1290, "zi"):
		var _t1677 = J.sub(v_ch_1292, 10.0)
		v_ch_1292 = _t1677
	if J.seq(v_ph_1290, "off"):
		var _t1678 = J.add(v_ch_1292, 10.0)
		v_ch_1292 = _t1678
	var _t1679 = J.max_([5.0, J.min_([95.0, J.round(J.num(v_ch_1292))])])
	v_ch_1292 = _t1679
	v_cost_1295 = J.round(J.num(((30.0 + J.mul(8.0, J.gp(v_v_1288, "p"))) if J.t(v_isN_1291) else (8.0 + J.mul(3.0, J.gp(v_v_1288, "p"))))))
	return {"ok": J.cmp(J.gp(J.gp(J.G.get("S"), "res"), "buns"), v_cost_1295, ">="), "why": ("" if J.cmp(J.gp(J.gp(J.G.get("S"), "res"), "buns"), v_cost_1295, ">=") else "壽包不夠"), "ch": v_ch_1292, "cost": v_cost_1295, "fear": v_fear_1294, "isN": v_isN_1291}

func _f275(this_, a: Array, env):
	var v_v_1305 = null; var v_mul_1306 = null; var v_ph_1307 = null; var v_m_1308 = null; var v_coins_1309 = null; var v_mat_1310 = null; var v_exp_1311 = null; var v_f_1312 = null; var v_g_1313 = null
	v_v_1305 = J.arg(a, 0)
	v_mul_1306 = J.arg(a, 1)
	var _t1680 = env["phase"]
	v_ph_1307 = J.cl(_t1680, null, [J.gp(J.cl(env["st"], null, []), "min")])
	v_m_1308 = ((J.mul((v_mul_1306 if J.t(v_mul_1306) else 1.0), (2.0 if J.seq(v_ph_1307, "zi") else 1.0)) * (1.0 + J.min_([1.0, J.mul(J.gp(env["R"], "streak"), 0.01)]))) * (5.0 if J.t(J.gp(v_v_1305, "elite")) else 1.0))
	v_coins_1309 = J.max_([1.0, J.round(J.num(J.mul((3.0 + J.mul(2.2, J.gp(v_v_1305, "p"))), v_m_1308)))])
	v_mat_1310 = J.max_([1.0, J.round(J.num((J.mul((1.0 + J.div(J.gp(v_v_1305, "p"), 5.0)), v_m_1308) * (0.7 + (randf() * 0.6)))))])
	v_exp_1311 = J.max_([1.0, J.round(J.num(((1.0 + J.mul(J.gp(v_v_1305, "p"), 0.8)) * (4.0 if J.t(J.gp(v_v_1305, "elite")) else 1.0))))])
	v_f_1312 = (J.gp(v_v_1305, "fac") if J.has(env["FAC"], J.gp(v_v_1305, "fac")) else "lan")
	v_g_1313 = {"coins": v_coins_1309, "exp": v_exp_1311}
	J.sp(v_g_1313, v_f_1312, v_mat_1310)
	var _t1681 = env["gain"]
	J.cl(_t1681, null, [v_g_1313])
	var _t1682 = J.gp(v_v_1305, "elite")
	if J.t(((randf() < 0.5) if J.t(_t1682) else _t1682)):
		var _t1683 = J.gp(J.G.get("S"), "chests")
		J.sp(_t1683, "g", J.num(J.gp(_t1683, "g")) + 1.0)
		var _t1684 = env["fxText"]
		J.cl(_t1684, null, [J.gp(v_v_1305, "x"), J.sub(J.gp(v_v_1305, "y"), 90.0), "綠箱 ×1", "#9f9", true])
	var _t1685 = env["fxText"]
	J.cl(_t1685, null, [J.gp(v_v_1305, "x"), J.sub(J.gp(v_v_1305, "y"), 70.0), ("+" + J.str(v_coins_1309) + " 冥幣　+" + J.str(v_mat_1310) + " " + J.str(J.gp(J.gp(env["FAC"], v_f_1312), "mat"))), "#ffe08a"])
	var _t1686 = env["img"]
	if J.t(J.cl(_t1686, null, ["fx_beam"])):
		var _t1687 = env["spr"]
		J.cl(_t1687, null, ["fx_beam", J.gp(v_v_1305, "x"), J.add(J.gp(v_v_1305, "y"), 6.0), {"s0": 0.35, "s1": 0.5, "sx": 0.7, "life": 1.1, "anchor": 0.95, "fadeIn": true}])
		var _t1688 = env["spr"]
		J.cl(_t1688, null, ["fx_gold", J.gp(v_v_1305, "x"), J.sub(J.gp(v_v_1305, "y"), 40.0), {"s0": 0.15, "s1": 0.35, "life": 0.7, "vy": 40.0}])
	else:
		var _t1689 = J.gp(env["R"], "fx")
		J.mc(_t1689, "push", [{"kind": "soul", "x": J.gp(v_v_1305, "x"), "y": J.gp(v_v_1305, "y"), "t": 0.0, "life": 1.3}])

func _f276(this_, a: Array, env):
	var v_g_1316 = null; var v_k_1317 = null
	v_g_1316 = J.arg(a, 0)
	for _t1690 in J.keys(v_g_1316):
		v_k_1317 = _t1690
		if J.seq(v_k_1317, "coins"):
			var _t1691 = J.gp(J.G.get("S"), "res")
			var _t1692 = J.add(J.gp(_t1691, "coins"), J.gp(v_g_1316, "coins"))
			J.sp(_t1691, "coins", _t1692)
			var _t1693 = J.gp(env["R"], "loot")
			var _t1694 = J.add(J.gp(_t1693, "coins"), J.gp(v_g_1316, "coins"))
			J.sp(_t1693, "coins", _t1694)
		else:
			if J.seq(v_k_1317, "exp"):
				var _t1695 = J.G.get("gainExp")
				J.cl(_t1695, null, [J.gp(v_g_1316, "exp")])
				var _t1696 = J.gp(env["R"], "loot")
				var _t1697 = J.add(J.gp(_t1696, "exp"), J.gp(v_g_1316, "exp"))
				J.sp(_t1696, "exp", _t1697)
			else:
				if J.has(env["FAC"], v_k_1317):
					var _t1698 = J.gp(J.cl(env["st"], null, []), "mats")
					var _t1699 = J.add(J.gp(_t1698, v_k_1317), J.gp(v_g_1316, v_k_1317))
					J.sp(_t1698, v_k_1317, _t1699)
					var _t1700 = J.gp(env["R"], "loot")
					var _t1701 = J.add(J.gp(_t1700, v_k_1317), J.gp(v_g_1316, v_k_1317))
					J.sp(_t1700, v_k_1317, _t1701)

func _f278(this_, a: Array, env):
	var v_x_1323 = null
	v_x_1323 = J.arg(a, 0)
	return (not J.seq(v_x_1323, env["v"]))

func _f279(this_, a: Array, env):
	var _t1726 = J.G.get("joinGhost")
	J.cl(_t1726, null, [env["k"]])
	J.cl(env["__p"]["__p"]["persist"], null, [])

func _f277(this_, a: Array, env):
	var v_how_1321 = null; var v_timeout_1322 = null; var v_I_1324 = null; var v_g_1326 = null; var v_e_1327 = null
	var _s581 = {"__p": env, "v": null}
	_s581["v"] = J.arg(a, 0)
	v_how_1321 = J.arg(a, 1)
	v_timeout_1322 = J.arg(a, 2)
	if J.t(J.gp(_s581["v"], "done")):
		return null
	var _t1702 = _s581["v"]
	J.sp(_t1702, "done", true)
	var _t1703 = _s581["v"]
	J.sp(_t1703, "down", 0.0)
	var _t1704 = _s581["v"]
	J.sp(_t1704, "deadT", 0.0)
	var _t1705 = _s581["__p"]["R"]
	var _t1706 = J.gp(_s581["__p"]["R"], "downs")
	var _t1707 = J.mc(_t1706, "filter", [Callable(self, "_f278").bind(_s581)])
	J.sp(_t1705, "downs", _t1707)
	if J.seq(v_how_1321, "soul"):
		var _t1708 = _s581["__p"]["soulDrop"]
		J.cl(_t1708, null, [_s581["v"]])
		var _t1709 = _s581["v"]
		J.sp(_t1709, "soul", 1.0)
	else:
		var _t1710 = _s581["__p"]["signInfo"]
		v_I_1324 = J.cl(_t1710, null, [_s581["v"]])
		if (not J.t(J.gp(v_I_1324, "ok"))):
			var _t1711 = _s581["v"]
			J.sp(_t1711, "done", false)
			var _t1712 = _s581["v"]
			var _t1713 = J.max_([0.5, J.gp(_s581["v"], "down")])
			J.sp(_t1712, "down", _t1713)
			var _t1714 = J.gp(_s581["__p"]["R"], "downs")
			J.mc(_t1714, "push", [_s581["v"]])
			J.mc(J.G.get("Fx"), "toast", [J.gp(v_I_1324, "why")])
			return null
		var _t1715 = J.gp(J.G.get("S"), "res")
		var _t1716 = J.sub(J.gp(_t1715, "buns"), J.gp(v_I_1324, "cost"))
		J.sp(_t1715, "buns", _t1716)
		var _t1717 = J.gp(_s581["__p"]["R"], "loot")
		var _t1718 = J.add(J.gp(_t1717, "buns"), J.gp(v_I_1324, "cost"))
		J.sp(_t1717, "buns", _t1718)
		if J.cmp((randf() * 100.0), J.gp(v_I_1324, "ch"), "<"):
			var _t1719 = J.gp(J.cl(_s581["__p"]["st"], null, []), "pity")
			var _t1720 = J.gp(_s581["v"], "k")
			J.sp(_t1719, _t1720, 0.0)
			var _t1721 = J.gp(_s581["__p"]["R"], "loot")
			J.sp(_t1721, "rec", J.num(J.gp(_t1721, "rec")) + 1.0)
			var _t1722 = J.cl(_s581["__p"]["st"], null, [])
			J.sp(_t1722, "rec", J.num(J.gp(_t1722, "rec")) + 1.0)
			var _t1723 = _s581["v"]
			J.sp(_t1723, "signed", 1.0)
			if J.t(J.gp(v_I_1324, "isN")):
				var _s587 = {"__p": _s581, "k": null}
				_s587["k"] = J.gp(_s587["__p"]["v"], "k")
				var _t1725 = [J.gp(J.gp(J.G.get("GHOSTS"), _s587["k"]), "name"), J.gp(J.gp(J.G.get("GHOSTS"), _s587["k"]), "say")]
				var _t1724 = _s587["__p"]["__p"]["T"]
				J.mc(J.G.get("Story"), "queue", [{"style": "narr", "lines": [_t1725, ["旁白", J.cl(_t1724, null, [(J.str(J.gp(J.gp(J.G.get("GHOSTS"), _s587["k"]), "name")) + "簽咗合約，跟你返落魄村。"), (J.str(J.gp(J.gp(J.G.get("GHOSTS"), _s587["k"]), "name")) + "簽了合約，跟你回落魄村。")])]]}, Callable(self, "_f279").bind(_s587)])
			else:
				var _t1727 = _s581["__p"]["addCrew"]
				v_g_1326 = J.cl(_t1727, null, [J.gp(_s581["v"], "k"), J.gp(_s581["v"], "p"), J.gp(_s581["v"], "elite"), J.gp(_s581["v"], "x"), J.gp(_s581["v"], "y")])
				var _t1728 = _s581["__p"]["msg"]
				J.cl(_t1728, null, [("<b>收編成功！</b>" + J.str(J.gp(v_g_1326, "name")) + "（" + J.str(J.gp(v_g_1326, "q")) + "・Lv" + J.str(J.gp(v_g_1326, "lv")) + "）加入部門。" + ("（對症收編 +20%）" if J.t(J.gp(v_I_1324, "fear")) else "")), 3.0])
			var _t1729 = _s581["__p"]["fxText"]
			J.cl(_t1729, null, [J.gp(_s581["v"], "x"), J.sub(J.gp(_s581["v"], "y"), 80.0), "簽約！", "#9fffb0", true])
			var _t1730 = _s581["__p"]["spr"]
			J.cl(_t1730, null, ["fx_ring", J.gp(_s581["v"], "x"), J.gp(_s581["v"], "y"), {"ground": true, "s0": 0.2, "s1": 0.55, "life": 0.8}])
			var _t1731 = _s581["__p"]["spr"]
			J.cl(_t1731, null, ["fx_gold", J.gp(_s581["v"], "x"), J.sub(J.gp(_s581["v"], "y"), 50.0), {"s0": 0.2, "s1": 0.5, "life": 0.8, "vy": 30.0}])
			J.mc(J.G.get("Sound"), "play", ["gong"])
		else:
			var _t1732 = J.gp(J.cl(_s581["__p"]["st"], null, []), "pity")
			var _t1733 = J.gp(_s581["v"], "k")
			var _t1734 = J.gp(J.gp(J.cl(_s581["__p"]["st"], null, []), "pity"), J.gp(_s581["v"], "k"))
			var _t1735 = J.add((_t1734 if J.t(_t1734) else 0.0), 15.0)
			J.sp(_t1732, _t1733, _t1735)
			var _t1736 = _s581["v"]
			J.sp(_t1736, "fled", 1.0)
			var _t1737 = _s581["__p"]["spr"]
			J.cl(_t1737, null, ["fx_smoke", J.gp(_s581["v"], "x"), J.sub(J.gp(_s581["v"], "y"), 30.0), {"s0": 0.2, "s1": 0.5, "life": 0.7, "add": false, "alpha": 0.9}])
			var _t1738 = _s581["__p"]["fxText"]
			J.cl(_t1738, null, [J.gp(_s581["v"], "x"), J.sub(J.gp(_s581["v"], "y"), 80.0), "跑掉了！", "#fca", true])
			var _t1739 = _s581["__p"]["msg"]
			var _t1740 = _s581["__p"]["T"]
			J.cl(_t1739, null, [J.cl(_t1740, null, [(J.str(J.gp(_s581["v"], "name")) + "睇完合約，走咗。（下次收同種 +15%）"), (J.str(J.gp(_s581["v"], "name")) + "看完合約，跑了。（下次收同種 +15%）")]), 2.5])
	J.cl(_s581["__p"]["downUI"], null, [])
	J.cl(J.G.get("save"), null, [])

func _f281(this_, a: Array, env):
	return J.round(J.num(J.mul((15.0 + (randf() * 32.0)), env["m"])))

func _f282(this_, a: Array, env):
	var v_g_1343 = null
	v_g_1343 = J.arg(a, 0)
	return J.gp(v_g_1343, "name")

func _f283(this_, a: Array, env):
	var v_u_1345 = null
	v_u_1345 = J.arg(a, 0)
	var _t1751 = J.seq(J.gp(v_u_1345, "role"), "crew")
	return ((not J.t(J.gp(v_u_1345, "gone"))) if _t1751 else _t1751)

func _f280(this_, a: Array, env):
	var v_k_1330 = null; var v_p_1331 = null; var v_rare_1332 = null; var v_x_1333 = null; var v_y_1334 = null; var v_lv_1335 = null; var v_purple_1336 = null; var v_s3_1338 = null; var v_used_1339 = null; var v_name_1340 = null; var v_g_1341 = null; var v_nCrew_1342 = null; var v_i_1344 = null; var v_u_1346 = null; var v_e_1347 = null
	var _s594 = {"__p": env, "m": null}
	v_k_1330 = J.arg(a, 0)
	v_p_1331 = J.arg(a, 1)
	v_rare_1332 = J.arg(a, 2)
	v_x_1333 = J.arg(a, 3)
	v_y_1334 = J.arg(a, 4)
	v_lv_1335 = J.max_([1.0, J.min_([J.mc(J.G.get("F"), "ghostCap", []), J.round(J.num((1.0 + J.mul(v_p_1331, 1.6))))])])
	v_purple_1336 = (v_rare_1332 if J.t(v_rare_1332) else (randf() < 0.12))
	_s594["m"] = (1.45 if J.t(v_purple_1336) else 1.0)
	var _t1741 = [0.0, 0.0, 0.0]
	v_s3_1338 = J.mc(_t1741, "map", [Callable(self, "_f281").bind(_s594)])
	var _t1742 = J.gp(J.G.get("S"), "ghosts")
	v_used_1339 = J.new_("Set", [J.mc(_t1742, "map", [Callable(self, "_f282").bind(_s594)])])
	v_name_1340 = J.gp(J.gp(J.G.get("FODDER"), v_k_1330), "name")
	v_i_1344 = 0.0
	while true:
		if not J.cmp(v_i_1344, 40.0, "<"): break
		var _t1743 = J.add(J.add(J.gp(J.gp(J.G.get("FODDER"), v_k_1330), "name"), "・"), J.gp(J.G.get("NICKS"), floor(J.num((randf() * J.len(J.G.get("NICKS")))))))
		v_name_1340 = _t1743
		if (not J.t(J.mc(v_used_1339, "has", [v_name_1340]))):
			break
		v_i_1344 = J.num(v_i_1344) + 1.0
	var _t1744 = J.G.get("S")
	var _t1745 = J.num(J.gp(_t1744, "uid"))
	J.sp(_t1744, "uid", _t1745 + 1.0)
	v_g_1341 = {"id": J.add("g", _t1745), "k": v_k_1330, "name": v_name_1340, "q": ("紫" if J.t(v_purple_1336) else "藍"), "lv": v_lv_1335, "st": v_s3_1338, "post": null, "spent": 0.0, "fat": 0.0}
	var _t1746 = J.gp(J.G.get("S"), "ghosts")
	J.mc(_t1746, "push", [v_g_1341])
	var _t1747 = J.gp(J.G.get("S"), "cnt")
	var _t1748 = J.gp(J.gp(J.G.get("S"), "cnt"), "recruit")
	var _t1749 = J.add((_t1748 if J.t(_t1748) else 0.0), 1.0)
	J.sp(_t1747, "recruit", _t1749)
	var _t1750 = J.gp(_s594["__p"]["R"], "units")
	v_nCrew_1342 = J.len(J.mc(_t1750, "filter", [Callable(self, "_f283").bind(_s594)]))
	if J.cmp(v_nCrew_1342, J.cl(_s594["__p"]["crewCap"], null, []), "<"):
		var _t1752 = _s594["__p"]["unitFromGhost"]
		v_u_1346 = J.cl(_t1752, null, [v_g_1341, "crew"])
		var _t1753 = J.add(3.0, v_nCrew_1342)
		J.sp(v_u_1346, "slot", _t1753)
		J.sp(v_u_1346, "x", v_x_1333)
		J.sp(v_u_1346, "y", v_y_1334)
		var _t1754 = J.gp(_s594["__p"]["R"], "units")
		J.mc(_t1754, "push", [v_u_1346])
	var _t1755 = _s594["__p"]["has"]
	var _t1756 = J.cl(_t1755, null, [J.G.get("Chatter")])
	if J.t((J.gp(J.G.get("Chatter"), "onRecruit") if J.t(_t1756) else _t1756)):
		J.mc(J.G.get("Chatter"), "onRecruit", [v_g_1341])
	return v_g_1341

func _f285(this_, a: Array, env):
	var _t1769 = env["__p"]["resolveDown"]
	return J.cl(_t1769, null, [env["v"], "soul"])

func _f286(this_, a: Array, env):
	var _t1773 = env["__p"]["resolveDown"]
	return J.cl(_t1773, null, [env["v"], "sign"])

func _f284(this_, a: Array, env):
	var v_box_1350 = null; var v_I_1352 = null; var v_f_1353 = null
	var _s604 = {"__p": env, "v": null}
	var _t1757 = J.G.get("$")
	v_box_1350 = J.cl(_t1757, null, ["#pt-down"])
	if (not J.t(v_box_1350)):
		return null
	_s604["v"] = J.gp(J.gp(_s604["__p"]["R"], "downs"), (J.len(J.gp(_s604["__p"]["R"], "downs")) - 1.0))
	if (not J.t(_s604["v"])):
		var _t1758 = J.gp(v_box_1350, "classList")
		J.mc(_t1758, "remove", ["on"])
		J.sp(v_box_1350, "innerHTML", "")
		var _t1759 = _s604["__p"]["R"]
		J.sp(_t1759, "downV", null)
		return null
	if J.seq(J.gp(_s604["__p"]["R"], "downV"), _s604["v"]):
		return null
	var _t1760 = _s604["__p"]["R"]
	var _t1761 = _s604["v"]
	J.sp(_t1760, "downV", _t1761)
	var _t1762 = _s604["__p"]["signInfo"]
	v_I_1352 = J.cl(_t1762, null, [_s604["v"]])
	var _t1763 = J.gp(_s604["__p"]["FAC"], J.gp(_s604["v"], "fac"))
	v_f_1353 = (_t1763 if J.t(_t1763) else J.gp(_s604["__p"]["FAC"], "lan"))
	var _t1764 = ("<div class=\"pd-h\"><canvas data-por=\"" + J.str(J.gp(_s604["v"], "k")) + "\"></canvas><div><b>" + J.str(J.gp(_s604["v"], "name")) + "</b>" + ("<i class=\"pd-el\">釘子戶</i>" if J.t(J.gp(_s604["v"], "elite")) else "") + "<small style=\"color:" + J.str(J.gp(v_f_1353, "col")) + "\">" + J.str(J.gp(v_f_1353, "name")) + "・靈體不穩</small></div><i class=\"pd-t\"><s></s></i></div>\n      <div class=\"pd-b\"><button class=\"btn\" id=\"pd-soul\">送去投胎<small>冥幣＋" + J.str(J.gp(v_f_1353, "mat")) + "</small></button><button class=\"btn gold\" id=\"pd-sign\" " + ("" if J.t(J.gp(v_I_1352, "ok")) else "disabled") + ">遞合約 " + (J.add(J.gp(v_I_1352, "ch"), "%") if (not J.leq(J.gp(v_I_1352, "ch"), null)) else "") + "<small>" + J.str((("壽包 " + J.str(J.gp(v_I_1352, "cost")) + ("・對症" if J.t(J.gp(v_I_1352, "fear")) else "")) if J.t(J.gp(v_I_1352, "ok")) else J.gp(v_I_1352, "why"))) + "</small></button></div>")
	J.sp(v_box_1350, "innerHTML", _t1764)
	var _t1765 = J.gp(v_box_1350, "classList")
	J.mc(_t1765, "add", ["on"])
	var _t1766 = J.G.get("paintPortraits")
	J.cl(_t1766, null, [v_box_1350])
	var _t1767 = J.G.get("$")
	var _t1768 = J.cl(_t1767, null, ["#pd-soul"])
	var _t1770 = Callable(self, "_f285").bind(_s604)
	J.sp(_t1768, "onclick", _t1770)
	var _t1771 = J.G.get("$")
	var _t1772 = J.cl(_t1771, null, ["#pd-sign"])
	var _t1774 = Callable(self, "_f286").bind(_s604)
	J.sp(_t1772, "onclick", _t1774)

func _f287(this_, a: Array, env):
	var v_z_1356 = null; var v_c_1357 = null
	v_z_1356 = J.arg(a, 0)
	v_c_1357 = J.add(J.gp(env["R"], "ci"), 1.0)
	var _t1775 = env["startZ"]
	var _t1777 = null
	if J.seq(v_z_1356, J.cl(_t1775, null, [J.gp(env["R"], "ci")])):
		_t1777 = 0.0
	else:
		var _t1776 = env["terOf"]
		_t1777 = J.round(J.num(((10.0 + J.mul(4.0, J.cl(_t1776, null, [v_z_1356]))) * pow(J.num(v_c_1357), J.num(1.5)))))
	return _t1777

func _f288(this_, a: Array, env):
	var v_m_1360 = null
	v_m_1360 = J.gp(J.cl(env["st"], null, []), "mats")
	return J.add(J.add(J.gp(v_m_1360, "yuan"), J.gp(v_m_1360, "chan")), J.gp(v_m_1360, "lan"))

func _f290(this_, a: Array, env):
	var v_a_1367 = null; var v_b_1368 = null
	v_a_1367 = J.arg(a, 0)
	v_b_1368 = J.arg(a, 1)
	return J.sub(J.gp(env["m"], v_b_1368), J.gp(env["m"], v_a_1367))

func _f289(this_, a: Array, env):
	var v_n_1363 = null; var v_left_1365 = null; var v_k_1366 = null; var v_d_1369 = null
	var _s610 = {"__p": env, "m": null}
	v_n_1363 = J.arg(a, 0)
	_s610["m"] = J.gp(J.cl(_s610["__p"]["st"], null, []), "mats")
	v_left_1365 = v_n_1363
	var _t1779 = J.S_Object_("keys", [_s610["m"]])
	for _t1778 in J.iter(J.mc(_t1779, "sort", [Callable(self, "_f290").bind(_s610)])):
		v_k_1366 = _t1778
		v_d_1369 = J.min_([J.gp(_s610["m"], v_k_1366), v_left_1365])
		var _t1780 = _s610["m"]
		var _t1781 = J.sub(J.gp(_t1780, v_k_1366), v_d_1369)
		J.sp(_t1780, v_k_1366, _t1781)
		var _t1782 = J.sub(v_left_1365, v_d_1369)
		v_left_1365 = _t1782
		if (not J.t(v_left_1365)):
			break

func _f292(this_, a: Array, env):
	var v_f_1385 = null
	v_f_1385 = J.arg(a, 0)
	var _t1791 = J.seq(J.gp(v_f_1385, "t"), "station")
	var _t1792 = ((not J.seq(J.gp(v_f_1385, "z"), J.gp(env["near"], "z"))) if _t1791 else _t1791)
	return (J.gp(J.gp(env["rs"], "sta"), J.gp(v_f_1385, "z")) if _t1792 else _t1792)

func _f293(this_, a: Array, env):
	var v_f_1386 = null
	v_f_1386 = J.arg(a, 0)
	var _t1795 = J.gp(v_f_1386, "z")
	var _t1794 = env["__p"]["staName"]
	return ("<button class=\"btn\" data-tp=\"" + J.str(_t1795) + "\">" + J.str(J.cl(_t1794, null, [J.gp(v_f_1386, "z")])) + "站</button>")

func _f294(this_, a: Array, env):
	var _t1806 = env["__p"]["useFaci"]
	return J.cl(_t1806, null, [env["near"]])

func _f297(this_, a: Array, env):
	var v_f_1390 = null
	v_f_1390 = J.arg(a, 0)
	var _t1811 = J.seq(J.gp(v_f_1390, "t"), "station")
	return (J.seq(J.gp(v_f_1390, "z"), J.num(J.gp(J.gp(env["b"], "dataset"), "tp"))) if _t1811 else _t1811)

func _f296(this_, a: Array, env):
	var v_q_1389 = null
	var _t1810 = env["__p"]["__p"]["faciPos"]
	v_q_1389 = J.cl(_t1810, null, [J.mc(env["__p"]["__p"]["FACI"], "find", [Callable(self, "_f297").bind(env)])])
	var _t1812 = env["__p"]["__p"]["teleport"]
	J.cl(_t1812, null, [J.add(J.gp(v_q_1389, "x"), 60.0), J.add(J.gp(v_q_1389, "y"), 60.0)])

func _f295(this_, a: Array, env):
	var _s628 = {"__p": env, "b": null}
	_s628["b"] = J.arg(a, 0)
	var _t1809 = _s628["b"]
	var _t1813 = Callable(self, "_f296").bind(_s628)
	J.sp(_t1809, "onclick", _t1813)
	return _t1813

func _f291(this_, a: Array, env):
	var v_dt_1372 = null; var v_L_1373 = null; var v_day_1375 = null; var v_box_1377 = null; var v_key_1378 = null; var v_h_1379 = null; var v_go_1380 = null; var v_f_1381 = null; var v_q_1382 = null; var v_c_1383 = null; var v_others_1384 = null; var v_cd_1387 = null
	var _s614 = {"__p": env, "rs": null, "near": null}
	v_dt_1372 = J.arg(a, 0)
	v_L_1373 = J.gp(_s614["__p"]["R"], "L")
	var _t1783 = _s614["__p"]["regSt"]
	_s614["rs"] = J.cl(_t1783, null, [J.gp(_s614["__p"]["R"], "ci")])
	v_day_1375 = floor(J.num(J.div(J.S_Date_("now", []), 86400000.0)))
	_s614["near"] = null
	for _t1784 in J.iter(_s614["__p"]["FACI"]):
		v_f_1381 = _t1784
		var _t1785 = _s614["__p"]["faciPos"]
		v_q_1382 = J.cl(_t1785, null, [v_f_1381])
		if (J.hypot_([J.sub(J.gp(v_q_1382, "x"), J.gp(v_L_1373, "x")), J.sub(J.gp(v_q_1382, "y"), J.gp(v_L_1373, "y"))]) < 90.0):
			_s614["near"] = v_f_1381
			break
	var _t1786 = J.G.get("$")
	v_box_1377 = J.cl(_t1786, null, ["#pt-act"])
	if (not J.t(v_box_1377)):
		return null
	v_key_1378 = (J.add(J.add(J.add(J.add(J.add(J.add(J.gp(_s614["near"], "t"), J.gp(_s614["near"], "z")), ":"), (1.0 if J.t(J.gp(J.gp(_s614["rs"], "sta"), J.gp(_s614["near"], "z"))) else 0.0)), (1.0 if J.cmp(J.gp(J.gp(_s614["__p"]["R"], "tea"), J.gp(_s614["near"], "z")), J.gp(_s614["__p"]["R"], "t"), ">") else 0.0)), J.seq(J.gp(_s614["rs"], "ot"), v_day_1375)), J.seq(J.gp(_s614["rs"], "pr"), v_day_1375)) if J.t(_s614["near"]) else "")
	if J.seq(v_key_1378, J.gp(_s614["__p"]["R"], "actKey")):
		return null
	var _t1787 = _s614["__p"]["R"]
	J.sp(_t1787, "actKey", v_key_1378)
	if (not J.t(_s614["near"])):
		var _t1788 = J.gp(v_box_1377, "classList")
		J.mc(_t1788, "remove", ["on"])
		J.sp(v_box_1377, "innerHTML", "")
		return null
	v_h_1379 = ""
	if J.seq(J.gp(_s614["near"], "t"), "station"):
		if (not J.t(J.gp(J.gp(_s614["rs"], "sta"), J.gp(_s614["near"], "z")))):
			var _t1789 = _s614["__p"]["stationCost"]
			v_c_1383 = J.cl(_t1789, null, [J.gp(_s614["near"], "z")])
			var _t1790 = ("<b>陰間地鐵站（未開通）</b><small>開通後可從準備畫面直接在這裡出發，巡邏中也能互相轉站。</small><button class=\"btn gold\" id=\"pa-go\" " + ("" if J.cmp(J.cl(_s614["__p"]["matTotal"], null, []), v_c_1383, ">=") else "disabled") + ">開通（執念 " + J.str(v_c_1383) + "，任何派系）</button>")
			v_h_1379 = _t1790
		else:
			v_others_1384 = J.mc(_s614["__p"]["FACI"], "filter", [Callable(self, "_f292").bind(_s614)])
			var _t1793 = _s614["__p"]["staName"]
			var _t1797 = J.cl(_t1793, null, [J.gp(_s614["near"], "z")])
			var _t1798 = ("搭到：" if J.t(J.len(v_others_1384)) else "其他站未開通")
			var _t1796 = J.mc(v_others_1384, "map", [Callable(self, "_f293").bind(_s614)])
			var _t1799 = ("<b>陰間地鐵站・" + J.str(_t1797) + "</b><small>" + _t1798 + "</small>" + J.str(J.mc(_t1796, "join", [""])))
			v_h_1379 = _t1799
	else:
		if J.seq(J.gp(_s614["near"], "t"), "tea"):
			var _t1800 = J.gp(J.gp(_s614["__p"]["R"], "tea"), J.gp(_s614["near"], "z"))
			v_cd_1387 = J.sub((_t1800 if J.t(_t1800) else 0.0), J.gp(_s614["__p"]["R"], "t"))
			var _t1801 = ("<b>陰間茶水間</b><small>全部門回血，過勞 -40。</small><button class=\"btn gold\" id=\"pa-go\" " + ("disabled" if J.cmp(v_cd_1387, 0.0, ">") else "") + ">" + (("在沖咖啡（" + J.str(ceil(J.num(v_cd_1387))) + " 秒）") if J.cmp(v_cd_1387, 0.0, ">") else "進去歇一下") + "</button>")
			v_h_1379 = _t1801
		else:
			if J.seq(J.gp(_s614["near"], "t"), "prison"):
				var _t1802 = (("<b>扣押室</b><small>今天已經救過人，明天再來。</small>") if J.seq(J.gp(_s614["rs"], "pr"), v_day_1375) else ("<b>扣押室</b><small>關著一隻欠交報告的實習鬼。救牠出來，牠會自願加入部門（要有編制）。</small><button class=\"btn gold\" id=\"pa-go\" " + ("" if J.cmp(J.cl(J.G.get("fodderCount"), null, []), J.mc(J.G.get("F"), "rosterCap", []), "<") else "disabled") + ">" + ("救人" if J.cmp(J.cl(J.G.get("fodderCount"), null, []), J.mc(J.G.get("F"), "rosterCap", []), "<") else "編制滿了") + "</button>"))
				v_h_1379 = _t1802
			else:
				if J.seq(J.gp(_s614["near"], "t"), "overtime"):
					var _t1803 = (("<b>通宵加班房</b><small>今晚已經加過班，明晚再來。</small>") if J.seq(J.gp(_s614["rs"], "ot"), v_day_1375) else ("<b>通宵加班房</b><small>裡面有隻連加三晚班的鬼（攻擊 ×3、血 ×6），帶著 4 個實習鬼。打贏有大獎（紫箱）。</small><button class=\"btn gold\" id=\"pa-go\">開門</button>"))
					v_h_1379 = _t1803
	J.sp(v_box_1377, "innerHTML", v_h_1379)
	var _t1804 = J.gp(v_box_1377, "classList")
	J.mc(_t1804, "add", ["on"])
	var _t1805 = J.G.get("$")
	v_go_1380 = J.cl(_t1805, null, ["#pa-go"])
	if J.t(v_go_1380):
		var _t1807 = Callable(self, "_f294").bind(_s614)
		J.sp(v_go_1380, "onclick", _t1807)
	var _t1808 = J.mc(v_box_1377, "querySelectorAll", ["[data-tp]"])
	J.mc(_t1808, "forEach", [Callable(self, "_f295").bind(_s614)])

func _f299(this_, a: Array, env):
	var v_u_1395 = null; var v_o_1396 = null
	v_u_1395 = J.arg(a, 0)
	J.sp(v_u_1395, "vy", 0.0)
	J.sp(v_u_1395, "vx", 0.0)
	if (not J.t(J.gp(v_u_1395, "leader"))):
		var _t1819 = env["__p"]["formation"]
		var _t1820 = J.gp(v_u_1395, "slot")
		v_o_1396 = J.cl(_t1819, null, [(_t1820 if J.t(_t1820) else 0.0)])
		var _t1821 = J.add(env["x"], J.gp(v_o_1396, "x"))
		J.sp(v_u_1395, "x", _t1821)
		var _t1822 = J.add(env["y"], J.gp(v_o_1396, "y"))
		J.sp(v_u_1395, "y", _t1822)

func _f298(this_, a: Array, env):
	var _s631 = {"__p": env, "x": null, "y": null}
	_s631["x"] = J.arg(a, 0)
	_s631["y"] = J.arg(a, 1)
	var _t1814 = J.gp(_s631["__p"]["R"], "L")
	var _t1815 = _s631["x"]
	J.sp(_t1814, "x", _t1815)
	var _t1816 = J.gp(_s631["__p"]["R"], "L")
	var _t1817 = _s631["y"]
	J.sp(_t1816, "y", _t1817)
	var _t1818 = J.gp(_s631["__p"]["R"], "units")
	J.mc(_t1818, "forEach", [Callable(self, "_f299").bind(_s631)])
	var _t1823 = J.gp(_s631["__p"]["R"], "cam")
	var _t1824 = _s631["x"]
	J.sp(_t1823, "x", _t1824)
	var _t1825 = J.gp(_s631["__p"]["R"], "cam")
	var _t1826 = _s631["y"]
	J.sp(_t1825, "y", _t1826)
	var _t1827 = _s631["__p"]["R"]
	J.sp(_t1827, "actKey", null)
	var _t1828 = _s631["__p"]["revealAround"]
	J.cl(_t1828, null, [_s631["x"], _s631["y"]])
	var _t1829 = _s631["__p"]["msg"]
	J.cl(_t1829, null, ["到站。", 1.2])

func _f301(this_, a: Array, env):
	var v_u_1404 = null
	v_u_1404 = J.arg(a, 0)
	if J.cmp(J.gp(v_u_1404, "hp"), 0.0, ">"):
		var _t1843 = J.gp(v_u_1404, "maxhp")
		J.sp(v_u_1404, "hp", _t1843)
	var _t1844 = J.gp(v_u_1404, "g")
	if J.t((J.gp(J.gp(v_u_1404, "g"), "fat") if J.t(_t1844) else _t1844)):
		var _t1845 = J.gp(v_u_1404, "g")
		var _t1846 = J.max_([0.0, J.sub(J.gp(J.gp(v_u_1404, "g"), "fat"), 40.0)])
		J.sp(_t1845, "fat", _t1846)
		var _t1847 = J.cmp(J.gp(J.gp(v_u_1404, "g"), "fat"), 70.0, "<")
		if J.t((J.gp(v_u_1404, "tired") if _t1847 else _t1847)):
			J.sp(v_u_1404, "tired", 0.0)
			var _t1848 = J.div(J.gp(v_u_1404, "atk"), 0.7)
			J.sp(v_u_1404, "atk", _t1848)

func _f302(this_, a: Array, env):
	var v_e_1417 = null
	v_e_1417 = J.arg(a, 0)
	var _t1874 = J.gp(env["R"], "foes")
	return J.mc(_t1874, "push", [v_e_1417])

func _f300(this_, a: Array, env):
	var v_f_1399 = null; var v_rs_1400 = null; var v_day_1401 = null; var v_q_1402 = null; var v_c_1403 = null; var v_e_1405 = null; var v_pool_1406 = null; var v_k_1407 = null; var v_g_1408 = null; var v_z_1409 = null; var v_p_1410 = null; var v_pool_1411 = null; var v_arr_1412 = null; var v_bk_1413 = null; var v_b_1414 = null; var v_i_1415 = null; var v_e_1416 = null
	v_f_1399 = J.arg(a, 0)
	var _t1830 = env["regSt"]
	v_rs_1400 = J.cl(_t1830, null, [J.gp(env["R"], "ci")])
	v_day_1401 = floor(J.num(J.div(J.S_Date_("now", []), 86400000.0)))
	var _t1831 = env["faciPos"]
	v_q_1402 = J.cl(_t1831, null, [v_f_1399])
	var _t1832 = env["R"]
	J.sp(_t1832, "actKey", null)
	if J.seq(J.gp(v_f_1399, "t"), "station"):
		var _t1833 = env["stationCost"]
		v_c_1403 = J.cl(_t1833, null, [J.gp(v_f_1399, "z")])
		if J.cmp(J.cl(env["matTotal"], null, []), v_c_1403, "<"):
			return null
		var _t1834 = env["payMat"]
		J.cl(_t1834, null, [v_c_1403])
		var _t1835 = J.gp(v_rs_1400, "sta")
		var _t1836 = J.gp(v_f_1399, "z")
		J.sp(_t1835, _t1836, 1.0)
		var _t1837 = env["msg"]
		var _t1838 = env["staName"]
		J.cl(_t1837, null, [("開通了 " + J.str(J.cl(_t1838, null, [J.gp(v_f_1399, "z")])) + " 地鐵站。"), 2.0])
		J.cl(J.G.get("save"), null, [])
	else:
		if J.seq(J.gp(v_f_1399, "t"), "tea"):
			var _t1839 = J.gp(env["R"], "tea")
			var _t1840 = J.gp(v_f_1399, "z")
			var _t1841 = J.add(J.gp(env["R"], "t"), env["TEA_CD"])
			J.sp(_t1839, _t1840, _t1841)
			var _t1842 = J.gp(env["R"], "units")
			J.mc(_t1842, "forEach", [Callable(self, "_f301").bind(env)])
			var _t1849 = env["msg"]
			var _t1850 = env["T"]
			J.cl(_t1849, null, [J.cl(_t1850, null, ["茶水間：「咖啡機又壞咗。」大家飲住熱水休息咗一陣。全部門回血，過勞 -40。", "茶水間：「咖啡機又壞了。」大家喝熱水休息了一下。全部門回血，過勞 -40。"]), 3.0])
			J.mc(J.G.get("Sound"), "play", ["click"])
		else:
			if J.seq(J.gp(v_f_1399, "t"), "prison"):
				if J.cmp(J.cl(J.G.get("fodderCount"), null, []), J.mc(J.G.get("F"), "rosterCap", []), ">="):
					return null
				J.sp(v_rs_1400, "pr", v_day_1401)
				var _t1851 = env["fodOf"]
				v_pool_1406 = J.cl(_t1851, null, [J.gp(env["R"], "ci")])
				v_k_1407 = J.gp(v_pool_1406, floor(J.num((randf() * J.len(v_pool_1406)))))
				var _t1852 = env["addCrew"]
				var _t1853 = env["zoneP"]
				v_g_1408 = J.cl(_t1852, null, [v_k_1407, J.cl(_t1853, null, [J.gp(env["R"], "ci"), J.gp(v_f_1399, "z")]), false, J.gp(v_q_1402, "x"), J.add(J.gp(v_q_1402, "y"), 30.0)])
				var _t1854 = J.gp(env["R"], "loot")
				J.sp(_t1854, "rec", J.num(J.gp(_t1854, "rec")) + 1.0)
				var _t1855 = env["fxText"]
				J.cl(_t1855, null, [J.gp(v_q_1402, "x"), J.sub(J.gp(v_q_1402, "y"), 60.0), J.add(J.gp(v_g_1408, "name"), " 入部門"), "#9fffb0", true])
				var _t1856 = env["msg"]
				var _t1857 = env["T"]
				J.cl(_t1856, null, [J.cl(_t1857, null, ["實習鬼：「多謝前輩！報告我聽日一定交！」（佢唔會交）", "實習鬼：「謝謝前輩！報告我明天一定交！」（他不會交）"]), 3.0])
			else:
				if J.seq(J.gp(v_f_1399, "t"), "overtime"):
					J.sp(v_rs_1400, "ot", v_day_1401)
					v_z_1409 = J.gp(v_f_1399, "z")
					var _t1858 = env["zoneP"]
					v_p_1410 = J.add(J.cl(_t1858, null, [J.gp(env["R"], "ci"), v_z_1409]), 0.5)
					var _t1859 = env["fodOf"]
					v_pool_1411 = J.cl(_t1859, null, [J.gp(env["R"], "ci")])
					v_arr_1412 = []
					v_bk_1413 = J.gp(v_pool_1411, (J.len(v_pool_1411) - 1.0))
					var _t1860 = env["foe"]
					v_b_1414 = J.cl(_t1860, null, [v_bk_1413, v_p_1410, {"hp": 6.0, "atk": 3.0}, {"ot": true}])
					var _t1861 = J.add("通宵", J.gp(v_b_1414, "name"))
					J.sp(v_b_1414, "name", _t1861)
					J.sp(v_b_1414, "otBoss", true)
					var _t1862 = J.gp(J.G.get("SKILLS"), v_bk_1413)
					var _t1863 = (_t1862 if J.t(_t1862) else null)
					J.sp(v_b_1414, "sk", _t1863)
					J.sp(v_b_1414, "s", 0.75)
					var _t1864 = J.gp(v_q_1402, "x")
					J.sp(v_b_1414, "x", _t1864)
					var _t1865 = J.sub(J.gp(v_q_1402, "y"), 40.0)
					J.sp(v_b_1414, "y", _t1865)
					var _t1866 = J.gp(v_b_1414, "x")
					J.sp(v_b_1414, "hx", _t1866)
					var _t1867 = J.gp(v_b_1414, "y")
					J.sp(v_b_1414, "hy", _t1867)
					J.sp(v_b_1414, "provoked", true)
					J.sp(v_b_1414, "z", v_z_1409)
					J.mc(v_arr_1412, "push", [v_b_1414])
					v_i_1415 = 0.0
					while true:
						if not J.cmp(v_i_1415, 4.0, "<"): break
						var _t1868 = env["foe"]
						v_e_1416 = J.cl(_t1868, null, [J.gp(v_pool_1411, J.mod(v_i_1415, J.len(v_pool_1411))), v_p_1410, {"hp": 1.2, "atk": 1.1}, {"ot": true}])
						var _t1869 = J.add("實習", J.gp(v_e_1416, "name"))
						J.sp(v_e_1416, "name", _t1869)
						var _t1870 = J.add(J.gp(v_q_1402, "x"), (cos(J.num(J.mul(v_i_1415, 1.57))) * 70.0))
						J.sp(v_e_1416, "x", _t1870)
						var _t1871 = (J.sub(J.gp(v_q_1402, "y"), 40.0) + (sin(J.num(J.mul(v_i_1415, 1.57))) * 45.0))
						J.sp(v_e_1416, "y", _t1871)
						var _t1872 = J.gp(v_e_1416, "x")
						J.sp(v_e_1416, "hx", _t1872)
						var _t1873 = J.gp(v_e_1416, "y")
						J.sp(v_e_1416, "hy", _t1873)
						J.sp(v_e_1416, "provoked", true)
						J.sp(v_e_1416, "z", v_z_1409)
						J.mc(v_arr_1412, "push", [v_e_1416])
						v_i_1415 = J.num(v_i_1415) + 1.0
					J.mc(v_arr_1412, "forEach", [Callable(self, "_f302").bind(env)])
					var _t1875 = env["R"]
					J.sp(_t1875, "ot", v_arr_1412)
					var _t1876 = env["msg"]
					var _t1877 = env["T"]
					J.cl(_t1876, null, [J.cl(_t1877, null, ["加班房道門打開：「你哋又係嚟陪我加班？」", "加班房的門打開了：「你們也是來陪我加班的？」"]), 3.0])
	J.cl(env["persist"], null, [])

func _f304(this_, a: Array, env):
	var _t1891 = J.G.get("joinGhost")
	J.cl(_t1891, null, ["baiwu"])
	var _t1892 = J.G.get("joinGhost")
	J.cl(_t1892, null, ["heiwu"])

func _f305(this_, a: Array, env):
	var _t1893 = J.G.get("joinGhost")
	return J.cl(_t1893, null, ["mengpo"])

func _f306(this_, a: Array, env):
	var _t1894 = J.G.get("S")
	J.sp(_t1894, "ended", true)

func _f308(this_, a: Array, env):
	if J.seq(env["i"], 0.0):
		var _t1895 = J.gp(env["__p"]["stg"], "join")
		var _t1896 = (_t1895 if J.t(_t1895) else [])
		J.mc(_t1896, "forEach", [J.G.get("joinGhost")])
	var _t1897 = (not J.seq(J.typeof_(J.G.get("GIFT_REWARD")), "undefined"))
	if J.t((J.gp(J.G.get("GIFT_REWARD"), env["id"]) if _t1897 else _t1897)):
		var _t1898 = J.G.get("give")
		J.mc(J.G.get("Fx"), "toast", [J.add("媽媽燒來的禮物：", J.cl(_t1898, null, [J.gp(J.G.get("GIFT_REWARD"), env["id"])]))])

func _f307(this_, a: Array, env):
	var _s658 = {"__p": env, "id": null, "i": null}
	_s658["id"] = J.arg(a, 0)
	_s658["i"] = J.arg(a, 1)
	return J.mc(J.G.get("Story"), "queue", [_s658["id"], Callable(self, "_f308").bind(_s658)])

func _f303(this_, a: Array, env):
	var v_si_1420 = null; var v_ci_1421 = null; var v_ch_1422 = null; var v_sid_1424 = null; var v_first_1425 = null; var v_rew_1426 = null; var v_txt_1427 = null; var v_e_1428 = null; var v_afters_1429 = null
	var _s648 = {"__p": env, "stg": null}
	v_si_1420 = J.arg(a, 0)
	v_ci_1421 = J.gp(_s648["__p"]["R"], "ci")
	v_ch_1422 = J.gp(J.G.get("CHAPTERS"), v_ci_1421)
	_s648["stg"] = J.gp(J.gp(v_ch_1422, "stages"), v_si_1420)
	var _t1878 = _s648["__p"]["sidOf"]
	v_sid_1424 = J.cl(_t1878, null, [v_ci_1421, v_si_1420])
	v_first_1425 = (not J.t(J.gp(J.gp(J.G.get("S"), "cleared"), v_sid_1424)))
	v_rew_1426 = ({"coins": (J.mul(60.0, J.gp(_s648["stg"], "p")) + 40.0), "exp": (J.mul(30.0, J.gp(_s648["stg"], "p")) + 40.0), "chest": J.gp(["g", "b", "p"], v_si_1420)} if J.t(v_first_1425) else {"coins": J.mul(20.0, J.gp(_s648["stg"], "p")), "exp": J.mul(8.0, J.gp(_s648["stg"], "p"))})
	var _t1879 = J.gp(J.G.get("S"), "cleared")
	J.sp(_t1879, v_sid_1424, true)
	var _t1880 = J.G.get("give")
	v_txt_1427 = J.cl(_t1880, null, [v_rew_1426])
	var _t1881 = J.gp(_s648["__p"]["R"], "loot")
	var _t1882 = J.gp(v_rew_1426, "coins")
	var _t1883 = J.add(J.gp(_t1881, "coins"), (_t1882 if J.t(_t1882) else 0.0))
	J.sp(_t1881, "coins", _t1883)
	var _t1884 = J.gp(_s648["__p"]["R"], "loot")
	var _t1885 = J.gp(v_rew_1426, "exp")
	var _t1886 = J.add(J.gp(_t1884, "exp"), (_t1885 if J.t(_t1885) else 0.0))
	J.sp(_t1884, "exp", _t1886)
	J.mc(J.G.get("Sound"), "play", ["win"])
	var _t1887 = _s648["__p"]["spr"]
	J.cl(_t1887, null, ["fx_scream", J.gp(J.gp(_s648["__p"]["R"], "L"), "x"), J.sub(J.gp(J.gp(_s648["__p"]["R"], "L"), "y"), 40.0), {"s0": 0.4, "s1": 2.2, "life": 0.8}])
	var _t1888 = _s648["__p"]["spr"]
	J.cl(_t1888, null, ["fx_gold", J.gp(J.gp(_s648["__p"]["R"], "L"), "x"), J.sub(J.gp(J.gp(_s648["__p"]["R"], "L"), "y"), 60.0), {"s0": 0.4, "s1": 0.9, "life": 1.0}])
	var _t1889 = _s648["__p"]["R"]
	J.sp(_t1889, "flash", 0.4)
	J.mc(J.G.get("Fx"), "banner", [(("區域總監 " + J.str(J.gp(_s648["stg"], "name")) + " 擊破！") if J.seq(v_si_1420, 2.0) else ("部門主管擊破！" + ("第 4 區閘口開放" if J.seq(v_si_1420, 0.0) else "第 8 區閘口開放")))])
	J.mc(J.G.get("Fx"), "toast", [(J.str(v_sid_1424) + "　" + J.str(J.gp(_s648["stg"], "name")) + "　" + J.str(v_txt_1427))])
	if J.t(v_first_1425):
		var _t1890 = J.gp(_s648["stg"], "after")
		v_afters_1429 = J.mc((_t1890 if J.t(_t1890) else []), "slice", [])
		if J.seq(v_sid_1424, "6-2"):
			J.mc(J.G.get("Story"), "queue", ["ch6_wuchang", Callable(self, "_f304").bind(_s648)])
			J.mc(J.G.get("Story"), "queue", ["ch6_mengpo", Callable(self, "_f305").bind(_s648)])
		else:
			if J.seq(v_sid_1424, "6-3"):
				J.mc(J.G.get("Story"), "queue", ["ch6_end"])
				J.mc(J.G.get("Story"), "queue", ["ch6_reboot", Callable(self, "_f306").bind(_s648)])
				J.mc(J.G.get("Story"), "queue", ["epilogue"])
			else:
				J.mc(v_afters_1429, "forEach", [Callable(self, "_f307").bind(_s648)])
		var _t1899 = J.seq(v_si_1420, 2.0)
		if (J.cmp(v_ci_1421, 5.0, "<") if _t1899 else _t1899):
			J.mc(J.G.get("Story"), "queue", [{"style": "narr", "lines": [["旁白", ("第" + J.str(J.gp("一二三四五六", J.add(v_ci_1421, 1.0))) + "區・" + J.str(J.gp(J.gp(J.G.get("CHAPTERS"), J.add(v_ci_1421, 1.0)), "name")) + " 開放了。收工返村，準備好就可以出發。")]]}])
	J.mc(J.G.get("Quest"), "check", [])
	J.cl(_s648["__p"]["persist"], null, [])
	J.cl(J.G.get("save"), null, [])
	J.mc(J.G.get("UI"), "refresh", [])

func _f309(this_, a: Array, env):
	if (not J.t(env["R"])):
		return null
	var _t1900 = env["regSt"]
	var _t1901 = J.cl(_t1900, null, [J.gp(env["R"], "ci")])
	var _t1902 = J.gp(env["R"], "fog")
	var _t1903 = J.mc(_t1902, "join", [""])
	var _t1904 = J.mc(_t1903, "replace", [J.re("0+$", ""), ""])
	J.sp(_t1901, "fog", _t1904)
	J.cl(J.G.get("save"), null, [])

func _f311(this_, a: Array, env):
	var v_f_1440 = null
	v_f_1440 = J.arg(a, 0)
	return ("<span style=\"color:" + J.str(J.gp(J.gp(env["__p"]["FAC"], v_f_1440), "col")) + "\">" + J.str(J.gp(J.gp(env["__p"]["FAC"], v_f_1440), "mat")) + " +" + J.str(J.gp(env["l"], v_f_1440)) + "</span>")

func _f312(this_, a: Array, env):
	return J.cl(env["__p"]["close"], null, [])

func _f310(this_, a: Array, env):
	var v_died_1436 = null; var v_box_1438 = null; var v_q_1439 = null; var v_e_1441 = null
	var _s661 = {"__p": env, "l": null}
	v_died_1436 = J.arg(a, 0)
	var _t1905 = (not J.t(_s661["__p"]["R"]))
	if J.t((_t1905 if _t1905 else J.gp(_s661["__p"]["R"], "ended"))):
		return null
	var _t1906 = _s661["__p"]["R"]
	J.sp(_t1906, "ended", true)
	J.cl(_s661["__p"]["persist"], null, [])
	var _t1907 = J.cl(_s661["__p"]["st"], null, [])
	var _t1908 = J.S_Date_("now", [])
	J.sp(_t1907, "restAt", _t1908)
	if J.t(v_died_1436):
		var _t1909 = _s661["__p"]["R"]
		J.sp(_t1909, "streak", 0.0)
	_s661["l"] = J.gp(_s661["__p"]["R"], "loot")
	var _t1910 = J.G.get("$")
	v_box_1438 = J.cl(_t1910, null, ["#pt-end"])
	var _t1911 = _s661["__p"]["D"]
	v_q_1439 = J.cl(_t1911, null, [J.gp(_s661["__p"]["MEET"], floor(J.num((randf() * J.len(_s661["__p"]["MEET"])))))])
	var _t1913 = ("阿福倒下了" if J.t(v_died_1436) else "收工")
	var _t1914 = (("<p class=\"quip\">" + J.str(v_q_1439) + "</p>") if J.t(v_died_1436) else "")
	var _t1915 = J.gp(_s661["l"], "kills")
	var _t1916 = J.gp(_s661["l"], "rec")
	var _t1912 = J.G.get("fmt")
	var _t1918 = J.cl(_t1912, null, [J.gp(_s661["l"], "coins")])
	var _t1917 = J.G.get("fmt")
	var _t1921 = J.cl(_t1917, null, [J.gp(_s661["l"], "exp")])
	var _t1919 = J.S_Object_("keys", [_s661["__p"]["FAC"]])
	var _t1920 = J.mc(_t1919, "map", [Callable(self, "_f311").bind(_s661)])
	var _t1922 = ("<div class=\"pe-card\"><h2>" + _t1913 + "</h2>" + _t1914 + "\n      <p>擊倒 " + J.str(_t1915) + "　收編 " + J.str(_t1916) + "</p><p>冥幣 +" + J.str(_t1918) + "　好評 +" + J.str(_t1921) + "</p><p>" + J.str(J.mc(_t1920, "join", ["　"])) + "</p>" + (("<p>合約工資：壽包 -" + J.str(J.gp(_s661["l"], "buns")) + "</p>") if J.t(J.gp(_s661["l"], "buns")) else "") + "\n      <p class=\"desc\">" + ("材料和冥幣全部保留。" if J.t(v_died_1436) else "") + "部門回村休息，過勞會慢慢恢復。</p>\n      <button class=\"btn gold wide\" id=\"pe-ok\">返村</button></div>")
	J.sp(v_box_1438, "innerHTML", _t1922)
	var _t1923 = J.gp(v_box_1438, "classList")
	J.mc(_t1923, "add", ["on"])
	var _t1924 = J.G.get("$")
	var _t1925 = J.cl(_t1924, null, ["#pe-ok"])
	var _t1926 = Callable(self, "_f312").bind(_s661)
	J.sp(_t1925, "onclick", _t1926)
	J.mc(J.G.get("Sound"), "play", [("lose" if J.t(v_died_1436) else "win")])
	J.cl(J.G.get("save"), null, [])

func _f313(this_, a: Array, env):
	var v_e_1444 = null
	env["active"] = false
	J.F_cancelAnimationFrame([env["raf"]])
	J.S_window_("removeEventListener", ["resize", env["resize"]])
	var _t1927 = J.G.get("window")
	J.sp(_t1927, "onkeydown", null)
	var _t1928 = J.G.get("window")
	J.sp(_t1928, "onkeyup", null)
	if J.t(env["el"]):
		var _t1929 = J.gp(env["el"], "classList")
		J.mc(_t1929, "remove", ["on"])
		var _t1930 = env["el"]
		J.sp(_t1930, "innerHTML", "")
	env["R"] = null
	J.mc(J.G.get("Sound"), "setMode", ["village"])
	J.mc(J.G.get("Quest"), "check", [])
	J.cl(J.G.get("save"), null, [])
	J.mc(J.G.get("UI"), "refresh", [])

func _f314(this_, a: Array, env):
	var v_c_1447 = null; var v_im_1448 = null
	v_c_1447 = J.arg(a, 0)
	var _t1931 = env["img"]
	v_im_1448 = J.cl(_t1931, null, [J.add("ground", J.gp(env["R"], "ci"))])
	if J.t(v_im_1448):
		if (not J.t(J.gp(env["PAT"], J.add("g", J.gp(env["R"], "ci"))))):
			var _t1932 = env["PAT"]
			var _t1933 = J.add("g", J.gp(env["R"], "ci"))
			var _t1934 = J.mc(v_c_1447, "createPattern", [v_im_1448, "repeat"])
			J.sp(_t1932, _t1933, _t1934)
		return J.gp(env["PAT"], J.add("g", J.gp(env["R"], "ci")))
	if (not J.t(J.gp(env["PAT"], J.add("p", J.gp(env["R"], "ci"))))):
		var _t1935 = env["PAT"]
		var _t1936 = J.add("p", J.gp(env["R"], "ci"))
		var _t1937 = env["mkPattern"]
		var _t1938 = J.mc(v_c_1447, "createPattern", [J.cl(_t1937, null, [J.gp(env["R"], "ci")]), "repeat"])
		J.sp(_t1935, _t1936, _t1938)
	return J.gp(env["PAT"], J.add("p", J.gp(env["R"], "ci")))

func _f317(this_, a: Array, env):
	var v_G_1470 = null
	v_G_1470 = J.arg(a, 0)
	var _t1955 = (not J.t(J.gp(v_G_1470, "sec")))
	if J.t(_t1955):
		var _t1952 = J.seq(J.gp(v_G_1470, "za"), env["__p"]["z"])
		var _t1954 = (J.seq(J.gp(v_G_1470, "zb"), env["z2"]) if _t1952 else _t1952)
		if not J.t(_t1954):
			var _t1953 = J.seq(J.gp(v_G_1470, "zb"), env["__p"]["z"])
			_t1954 = (J.seq(J.gp(v_G_1470, "za"), env["z2"]) if _t1953 else _t1953)
		_t1955 = _t1954
	return _t1955

func _f316(this_, a: Array, env):
	var v_r_1459 = null; var v_c_1460 = null; var v_out_1461 = null; var v_dr_1462 = null; var v_dc_1463 = null; var v_rr_1464 = null; var v_cc_1465 = null; var v_ta_1467 = null; var v_tb_1468 = null; var v_g_1469 = null
	var _s675 = {"__p": env, "z": null}
	_s675["z"] = J.arg(a, 0)
	var _t1940 = _s675["__p"]["__p"]["zoneCell"]
	var _t1941 = J.cl(_t1940, null, [_s675["z"]])
	var _t1942 = J.gp(_t1941, "r")
	v_r_1459 = _t1942
	var _t1943 = J.gp(_t1941, "c")
	v_c_1460 = _t1943
	v_out_1461 = []
	for _t1944 in J.iter([[0.0, 1.0], [0.0, (-1.0)], [1.0, 0.0], [(-1.0), 0.0]]):
		var _t1945 = J.gp(_t1944, 0.0)
		v_dr_1462 = _t1945
		var _t1946 = J.gp(_t1944, 1.0)
		v_dc_1463 = _t1946
		var _s677 = {"__p": _s675, "z2": null}
		v_rr_1464 = J.add(v_r_1459, v_dr_1462)
		v_cc_1465 = J.add(v_c_1460, v_dc_1463)
		var _t1947 = J.cmp(v_rr_1464, 0.0, "<")
		var _t1948 = (_t1947 if _t1947 else J.cmp(v_cc_1465, 0.0, "<"))
		var _t1949 = (_t1948 if _t1948 else J.cmp(v_rr_1464, _s677["__p"]["__p"]["__p"]["ROWS"], ">="))
		if (_t1949 if _t1949 else J.cmp(v_cc_1465, _s677["__p"]["__p"]["__p"]["COLS"], ">=")):
			continue
		_s677["z2"] = J.add(J.mul(v_rr_1464, _s677["__p"]["__p"]["__p"]["COLS"]), v_cc_1465)
		var _t1950 = _s677["__p"]["__p"]["__p"]["terOf"]
		v_ta_1467 = J.cl(_t1950, null, [_s677["__p"]["z"]])
		var _t1951 = _s677["__p"]["__p"]["__p"]["terOf"]
		v_tb_1468 = J.cl(_t1951, null, [_s677["z2"]])
		if J.seq(v_ta_1467, v_tb_1468):
			J.mc(v_out_1461, "push", [[_s677["z2"], null]])
		else:
			v_g_1469 = J.mc(_s677["__p"]["__p"]["__p"]["GATES"], "find", [Callable(self, "_f317").bind(_s677)])
			if J.t(v_g_1469):
				J.mc(v_out_1461, "push", [[_s677["z2"], v_g_1469]])
	return v_out_1461

func _f318(this_, a: Array, env):
	var v_a_1471 = null; var v_b_1472 = null; var v_prev_1473 = null; var v_q_1474 = null; var v_out_1475 = null; var v_z_1476 = null; var v_z_1477 = null; var v_z2_1478 = null; var v_g_1479 = null
	v_a_1471 = J.arg(a, 0)
	v_b_1472 = J.arg(a, 1)
	v_prev_1473 = {}
	var _t1956 = [(-1.0)]
	J.sp(v_prev_1473, v_a_1471, _t1956)
	v_q_1474 = [v_a_1471]
	while true:
		if not J.t(J.len(v_q_1474)): break
		v_z_1477 = J.mc(v_q_1474, "shift", [])
		if J.seq(v_z_1477, v_b_1472):
			break
		var _t1958 = env["nb"]
		for _t1957 in J.iter(J.cl(_t1958, null, [v_z_1477])):
			var _t1959 = J.gp(_t1957, 0.0)
			v_z2_1478 = _t1959
			var _t1960 = J.gp(_t1957, 1.0)
			v_g_1479 = _t1960
			if (not J.has(v_prev_1473, v_z2_1478)):
				var _t1961 = [v_z_1477, v_g_1479]
				J.sp(v_prev_1473, v_z2_1478, _t1961)
				J.mc(v_q_1474, "push", [v_z2_1478])
	v_out_1475 = []
	v_z_1476 = v_b_1472
	while true:
		var _t1962 = (not J.seq(v_z_1476, v_a_1471))
		if not J.t((J.gp(v_prev_1473, v_z_1476) if _t1962 else _t1962)): break
		J.mc(v_out_1475, "unshift", [[v_z_1476, J.gp(J.gp(v_prev_1473, v_z_1476), 1.0)]])
		v_z_1476 = J.gp(J.gp(v_prev_1473, v_z_1476), 0.0)
	return v_out_1475

func _f315(this_, a: Array, env):
	var v_rnd_1451 = null; var v_N_1452 = null; var v_route_1454 = null; var v_pts_1455 = null; var v_s0_1456 = null; var v_cur_1457 = null; var v_t_1480 = null; var v_lp_1481 = null; var v_zt_1482 = null; var v_z_1483 = null; var v_g_1484 = null; var v_c_1485 = null
	var _s674 = {"__p": env, "nb": null}
	if J.t(J.gp(_s674["__p"]["R"], "path")):
		return J.gp(_s674["__p"]["R"], "path")
	var _t1939 = _s674["__p"]["seeded"]
	v_rnd_1451 = J.cl(_t1939, null, [(J.mul(J.gp(_s674["__p"]["R"], "ci"), 13.0) + 5.0)])
	v_N_1452 = J.mul(_s674["__p"]["COLS"], _s674["__p"]["ROWS"])
	_s674["nb"] = Callable(self, "_f316").bind(_s674)
	v_route_1454 = Callable(self, "_f318").bind(_s674)
	v_pts_1455 = []
	var _t1963 = _s674["__p"]["faciPos"]
	v_s0_1456 = J.cl(_t1963, null, [J.gp(_s674["__p"]["FACI"], 0.0)])
	J.mc(v_pts_1455, "push", [[J.add(J.gp(v_s0_1456, "x"), 60.0), J.sub(J.gp(v_s0_1456, "y"), 40.0)]])
	v_cur_1457 = J.gp(J.gp(_s674["__p"]["FACI"], 0.0), "z")
	for _t1964 in J.iter([0.0, 1.0, 3.0, 4.0, 5.0]):
		v_t_1480 = _t1964
		var _t1965 = _s674["__p"]["lairPos"]
		v_lp_1481 = J.cl(_t1965, null, [v_t_1480])
		var _t1966 = _s674["__p"]["zoneAt"]
		v_zt_1482 = J.cl(_t1966, null, [J.gp(v_lp_1481, "x"), J.gp(v_lp_1481, "y")])
		for _t1967 in J.iter(J.cl(v_route_1454, null, [v_cur_1457, v_zt_1482])):
			var _t1968 = J.gp(_t1967, 0.0)
			v_z_1483 = _t1968
			var _t1969 = J.gp(_t1967, 1.0)
			v_g_1484 = _t1969
			if J.t(v_g_1484):
				J.mc(v_pts_1455, "push", [[J.gp(v_g_1484, "x"), J.gp(v_g_1484, "y")]])
			var _t1970 = _s674["__p"]["zoneCell"]
			v_c_1485 = J.cl(_t1970, null, [v_z_1483])
			if (not J.seq(v_z_1483, v_zt_1482)):
				J.mc(v_pts_1455, "push", [[J.add(J.gp(v_c_1485, "x"), (J.sub(J.cl(v_rnd_1451, null, []), 0.5) * 200.0)), J.add(J.gp(v_c_1485, "y"), (J.sub(J.cl(v_rnd_1451, null, []), 0.5) * 180.0))]])
		J.mc(v_pts_1455, "push", [[J.gp(v_lp_1481, "x"), J.add(J.gp(v_lp_1481, "y"), 120.0)]])
		v_cur_1457 = v_zt_1482
	var _t1971 = _s674["__p"]["R"]
	J.sp(_t1971, "path", v_pts_1455)
	return v_pts_1455

func _f320(this_, a: Array, env):
	var v_i_1491 = null; var v_x0_1492 = null; var v_y0_1493 = null; var v_x1_1494 = null; var v_y1_1495 = null
	J.mc(env["c"], "beginPath", [])
	J.mc(env["c"], "moveTo", [J.gp(J.gp(env["pts"], 0.0), 0.0), J.gp(J.gp(env["pts"], 0.0), 1.0)])
	v_i_1491 = 1.0
	while true:
		if not J.cmp(v_i_1491, J.len(env["pts"]), "<"): break
		var _t1974 = J.gp(env["pts"], J.sub(v_i_1491, 1.0))
		var _t1975 = J.gp(_t1974, 0.0)
		v_x0_1492 = _t1975
		var _t1976 = J.gp(_t1974, 1.0)
		v_y0_1493 = _t1976
		var _t1977 = J.gp(env["pts"], v_i_1491)
		var _t1978 = J.gp(_t1977, 0.0)
		v_x1_1494 = _t1978
		var _t1979 = J.gp(_t1977, 1.0)
		v_y1_1495 = _t1979
		J.mc(env["c"], "quadraticCurveTo", [v_x0_1492, v_y0_1493, J.div(J.add(v_x0_1492, v_x1_1494), 2.0), J.div(J.add(v_y0_1493, v_y1_1495), 2.0)])
		v_i_1491 = J.num(v_i_1491) + 1.0
	J.mc(env["c"], "lineTo", [J.gp(J.gp(env["pts"], (J.len(env["pts"]) - 1.0)), 0.0), J.gp(J.gp(env["pts"], (J.len(env["pts"]) - 1.0)), 1.0)])
	J.mc(env["c"], "stroke", [])

func _f319(this_, a: Array, env):
	var v_line_1490 = null
	var _s689 = {"__p": env, "c": null, "pts": null}
	_s689["c"] = J.arg(a, 0)
	_s689["pts"] = J.cl(_s689["__p"]["pathPts"], null, [])
	J.mc(_s689["c"], "save", [])
	var _t1972 = _s689["c"]
	J.sp(_t1972, "lineCap", "round")
	var _t1973 = _s689["c"]
	J.sp(_t1973, "lineJoin", "round")
	v_line_1490 = Callable(self, "_f320").bind(_s689)
	var _t1980 = _s689["c"]
	J.sp(_t1980, "strokeStyle", "rgba(20,14,10,.28)")
	var _t1981 = _s689["c"]
	J.sp(_t1981, "lineWidth", 120.0)
	J.cl(v_line_1490, null, [])
	var _t1982 = _s689["c"]
	J.sp(_t1982, "strokeStyle", "rgba(120,104,80,.16)")
	var _t1983 = _s689["c"]
	J.sp(_t1983, "lineWidth", 80.0)
	J.cl(v_line_1490, null, [])
	J.mc(_s689["c"], "setLineDash", [[3.0, 14.0]])
	var _t1984 = _s689["c"]
	J.sp(_t1984, "strokeStyle", "rgba(200,180,140,.12)")
	var _t1985 = _s689["c"]
	J.sp(_t1985, "lineWidth", 3.0)
	J.cl(v_line_1490, null, [])
	J.mc(_s689["c"], "setLineDash", [[]])
	J.mc(_s689["c"], "restore", [])

func _f322(this_, a: Array, env):
	var v_a_1517 = null; var v_b_1518 = null; var v_gr_1519 = null; var v_sg_1520 = null; var v_x_1521 = null; var v_X_1522 = null; var v_j_1523 = null; var v_x_1524 = null; var v_ph_1525 = null; var v_x_1526 = null
	v_a_1517 = J.arg(a, 0)
	v_b_1518 = J.arg(a, 1)
	if J.cmp(v_b_1518, v_a_1517, "<="):
		return null
	v_gr_1519 = J.mc(env["c"], "createLinearGradient", [0.0, (-J.num(env["H2"])), 0.0, env["H2"]])
	J.mc(v_gr_1519, "addColorStop", [0.0, "rgba(0,0,0,0)"])
	J.mc(v_gr_1519, "addColorStop", [0.3, ("rgba(6,18,16,.95)" if J.t(env["river"]) else "rgba(4,3,8,.95)")])
	J.mc(v_gr_1519, "addColorStop", [0.7, ("rgba(6,18,16,.95)" if J.t(env["river"]) else "rgba(4,3,8,.95)")])
	J.mc(v_gr_1519, "addColorStop", [1.0, "rgba(0,0,0,0)"])
	var _t1989 = env["c"]
	J.sp(_t1989, "fillStyle", v_gr_1519)
	J.mc(env["c"], "fillRect", [v_a_1517, (-J.num(env["H2"])), J.sub(v_b_1518, v_a_1517), J.mul(env["H2"], 2.0)])
	var _t1990 = env["c"]
	var _t1991 = ("rgba(40,70,60,.8)" if J.t(env["river"]) else "rgba(70,58,50,.75)")
	J.sp(_t1990, "strokeStyle", _t1991)
	var _t1992 = env["c"]
	J.sp(_t1992, "lineWidth", 3.0)
	var _t1993 = env["c"]
	J.sp(_t1993, "lineJoin", "round")
	for _t1994 in J.iter([(-1.0), 1.0]):
		v_sg_1520 = _t1994
		J.mc(env["c"], "beginPath", [])
		v_x_1521 = v_a_1517
		while true:
			if not J.cmp(v_x_1521, v_b_1518, "<="): break
			v_X_1522 = J.add(v_x_1521, J.gp(env["w"], "a"))
			v_j_1523 = ((sin(J.num(J.add(J.mul(v_X_1522, 0.07), v_sg_1520))) * 4.0) + (J.mod(J.mul(v_X_1522, 7919.0), 11.0) * 0.5))
			J.mc(env["c"], "lineTo", [v_x_1521, (J.mul(v_sg_1520, J.mul(env["H2"], 0.36)) + J.mul(v_j_1523, v_sg_1520))])
			var _t1995 = J.add(v_x_1521, 16.0)
			v_x_1521 = _t1995
		J.mc(env["c"], "stroke", [])
	if J.t(env["river"]):
		J.mc(env["c"], "save", [])
		var _t1996 = env["c"]
		J.sp(_t1996, "globalCompositeOperation", "lighter")
		v_x_1524 = J.sub(v_a_1517, J.mod(v_a_1517, 60.0))
		while true:
			if not J.cmp(v_x_1524, v_b_1518, "<"): break
			v_ph_1525 = J.mod((J.mul(J.gp(env["__p"]["R"], "t"), 0.6) + J.mul(v_x_1524, 0.013)), 1.0)
			var _t1997 = env["c"]
			var _t1998 = ("rgba(90,255,170," + J.str((0.1 * sin(J.num(J.mul(v_ph_1525, PI))))) + ")")
			J.sp(_t1997, "fillStyle", _t1998)
			J.mc(env["c"], "beginPath", [])
			J.mc(env["c"], "ellipse", [J.add(v_x_1524, J.mul(v_ph_1525, 40.0)), (sin(J.num(v_x_1524)) * 6.0), 18.0, 3.0, 0.0, 0.0, 7.0])
			J.mc(env["c"], "fill", [])
			var _t1999 = J.add(v_x_1524, 60.0)
			v_x_1524 = _t1999
		J.mc(env["c"], "restore", [])
	else:
		var _t2000 = env["c"]
		J.sp(_t2000, "fillStyle", "rgba(120,140,170,.05)")
		v_x_1526 = J.sub(v_a_1517, J.mod(v_a_1517, 90.0))
		while true:
			if not J.cmp(v_x_1526, v_b_1518, "<"): break
			J.mc(env["c"], "beginPath", [])
			J.mc(env["c"], "ellipse", [J.add(v_x_1526, (sin(J.num(J.add(J.mul(J.gp(env["__p"]["R"], "t"), 0.4), v_x_1526))) * 20.0)), 0.0, 70.0, 12.0, 0.0, 0.0, 7.0])
			J.mc(env["c"], "fill", [])
			var _t2001 = J.add(v_x_1526, 90.0)
			v_x_1526 = _t2001

func _f321(this_, a: Array, env):
	var v_cx_1500 = null; var v_cy_1501 = null; var v_vw_1502 = null; var v_vh_1503 = null; var v_len_1504 = null; var v_x0w_1506 = null; var v_x1w_1507 = null; var v_y0w_1508 = null; var v_y1w_1509 = null; var v_cap_1511 = null; var v_band_1512 = null; var v_g_1513 = null; var v_gc_1514 = null; var v_sec_1515 = null; var v_found_1516 = null; var v_gr_1527 = null; var v_i_1528 = null; var v_x_1529 = null; var v_h_1530 = null; var v_e_1531 = null; var v_yy_1532 = null; var v_i_1533 = null; var v_x_1534 = null; var v_i_1535 = null; var v_i_1536 = null; var v_yy_1537 = null; var v_gx_1538 = null; var v_gy_1539 = null; var v_main_1540 = null
	var _s693 = {"__p": env, "c": null, "w": null, "H2": null, "river": null}
	_s693["c"] = J.arg(a, 0)
	_s693["w"] = J.arg(a, 1)
	v_cx_1500 = J.arg(a, 2)
	v_cy_1501 = J.arg(a, 3)
	v_vw_1502 = J.arg(a, 4)
	v_vh_1503 = J.arg(a, 5)
	v_len_1504 = J.sub(J.gp(_s693["w"], "b"), J.gp(_s693["w"], "a"))
	_s693["H2"] = (46.0 if J.seq(J.gp(_s693["w"], "kind"), "border") else 34.0)
	v_x0w_1506 = (J.gp(_s693["w"], "a") if J.t(J.gp(_s693["w"], "h")) else J.sub(J.gp(_s693["w"], "p"), _s693["H2"]))
	v_x1w_1507 = (J.gp(_s693["w"], "b") if J.t(J.gp(_s693["w"], "h")) else J.add(J.gp(_s693["w"], "p"), _s693["H2"]))
	v_y0w_1508 = (J.sub(J.gp(_s693["w"], "p"), _s693["H2"]) if J.t(J.gp(_s693["w"], "h")) else J.gp(_s693["w"], "a"))
	v_y1w_1509 = (J.add(J.gp(_s693["w"], "p"), _s693["H2"]) if J.t(J.gp(_s693["w"], "h")) else J.gp(_s693["w"], "b"))
	var _t1986 = J.cmp(v_x1w_1507, J.sub(v_cx_1500, 60.0), "<")
	var _t1987 = (_t1986 if _t1986 else J.cmp(v_x0w_1506, J.add(J.add(v_cx_1500, v_vw_1502), 60.0), ">"))
	var _t1988 = (_t1987 if _t1987 else J.cmp(v_y1w_1509, J.sub(v_cy_1501, 60.0), "<"))
	if (_t1988 if _t1988 else J.cmp(v_y0w_1508, J.add(J.add(v_cy_1501, v_vh_1503), 100.0), ">")):
		return null
	J.mc(_s693["c"], "save", [])
	if J.t(J.gp(_s693["w"], "h")):
		J.mc(_s693["c"], "translate", [J.gp(_s693["w"], "a"), J.gp(_s693["w"], "p")])
	else:
		J.mc(_s693["c"], "translate", [J.gp(_s693["w"], "p"), J.gp(_s693["w"], "a")])
		J.mc(_s693["c"], "rotate", [J.div(PI, 2.0)])
	_s693["river"] = J.seq(J.gp(_s693["w"], "kind"), "river")
	v_cap_1511 = (not J.seq(J.gp(_s693["w"], "kind"), "border"))
	v_band_1512 = Callable(self, "_f322").bind(_s693)
	v_g_1513 = J.gp(_s693["w"], "gap")
	v_gc_1514 = (J.sub(J.gp(v_g_1513, "c"), J.gp(_s693["w"], "a")) if J.t(v_g_1513) else (-1000000000.0))
	v_sec_1515 = (J.gp(J.gp(v_g_1513, "g"), "sec") if J.t(v_g_1513) else v_g_1513)
	var _t2003 = v_sec_1515
	if J.t(_t2003):
		var _t2002 = _s693["__p"]["secFound"]
		_t2003 = J.cl(_t2002, null, [J.gp(v_g_1513, "g")])
	v_found_1516 = _t2003
	if J.t(v_g_1513):
		J.cl(v_band_1512, null, [0.0, J.sub(v_gc_1514, J.div(_s693["__p"]["GW"], 2.0))])
		J.cl(v_band_1512, null, [J.add(v_gc_1514, J.div(_s693["__p"]["GW"], 2.0)), v_len_1504])
	else:
		J.cl(v_band_1512, null, [0.0, v_len_1504])
	if J.t(((not J.t(v_found_1516)) if J.t(v_sec_1515) else v_sec_1515)):
		v_gr_1527 = J.mc(_s693["c"], "createLinearGradient", [0.0, (-J.num(_s693["H2"])), 0.0, _s693["H2"]])
		J.mc(v_gr_1527, "addColorStop", [0.0, "rgba(0,0,0,0)"])
		J.mc(v_gr_1527, "addColorStop", [0.3, "rgba(10,12,8,.82)"])
		J.mc(v_gr_1527, "addColorStop", [0.7, "rgba(10,12,8,.82)"])
		J.mc(v_gr_1527, "addColorStop", [1.0, "rgba(0,0,0,0)"])
		var _t2004 = _s693["c"]
		J.sp(_t2004, "fillStyle", v_gr_1527)
		J.mc(_s693["c"], "fillRect", [J.sub(v_gc_1514, J.div(_s693["__p"]["GW"], 2.0)), (-J.num(_s693["H2"])), _s693["__p"]["GW"], J.mul(_s693["H2"], 2.0)])
		var _t2005 = _s693["c"]
		J.sp(_t2005, "strokeStyle", "rgba(60,80,40,.7)")
		var _t2006 = _s693["c"]
		J.sp(_t2006, "lineWidth", 2.0)
		J.mc(_s693["c"], "beginPath", [])
		v_i_1528 = 0.0
		while true:
			if not J.cmp(v_i_1528, 16.0, "<"): break
			v_x_1529 = ((J.sub(v_gc_1514, J.div(_s693["__p"]["GW"], 2.0)) + 8.0) + J.div(J.mul(v_i_1528, J.sub(_s693["__p"]["GW"], 16.0)), 15.0))
			v_h_1530 = (10.0 + J.mod(J.mul(v_i_1528, 37.0), 9.0))
			J.mc(_s693["c"], "moveTo", [v_x_1529, J.mul(_s693["H2"], 0.3)])
			J.mc(_s693["c"], "lineTo", [J.add(v_x_1529, (sin(J.num(J.add(J.mul(J.gp(_s693["__p"]["R"], "t"), 1.5), v_i_1528))) * 3.0)), J.sub(J.mul(_s693["H2"], 0.3), v_h_1530)])
			v_i_1528 = J.num(v_i_1528) + 1.0
		J.mc(_s693["c"], "stroke", [])
	if J.t(v_cap_1511):
		var _t2007 = _s693["c"]
		var _t2008 = ("rgba(6,18,16,.9)" if J.t(_s693["river"]) else "rgba(4,3,8,.9)")
		J.sp(_t2007, "fillStyle", _t2008)
		for _t2009 in J.iter([0.0, v_len_1504]):
			v_e_1531 = _t2009
			J.mc(_s693["c"], "beginPath", [])
			J.mc(_s693["c"], "ellipse", [v_e_1531, 0.0, J.mul(_s693["H2"], 0.6), J.mul(_s693["H2"], 0.5), 0.0, 0.0, 7.0])
			J.mc(_s693["c"], "fill", [])
	if J.t(((not J.t(v_sec_1515)) if J.t(v_g_1513) else v_g_1513)):
		var _t2010 = _s693["c"]
		J.sp(_t2010, "fillStyle", "#3a2c20")
		var _t2011 = _s693["c"]
		J.sp(_t2011, "strokeStyle", "#120c08")
		var _t2012 = _s693["c"]
		J.sp(_t2012, "lineWidth", 2.0)
		v_yy_1532 = ((-J.num(_s693["H2"])) + 4.0)
		while true:
			if not J.cmp(v_yy_1532, J.sub(_s693["H2"], 4.0), "<"): break
			J.mc(_s693["c"], "fillRect", [(J.sub(v_gc_1514, J.div(_s693["__p"]["GW"], 2.0)) + 22.0), v_yy_1532, J.sub(_s693["__p"]["GW"], 44.0), 9.0])
			J.mc(_s693["c"], "strokeRect", [(J.sub(v_gc_1514, J.div(_s693["__p"]["GW"], 2.0)) + 22.0), v_yy_1532, J.sub(_s693["__p"]["GW"], 44.0), 9.0])
			var _t2013 = J.add(v_yy_1532, 12.0)
			v_yy_1532 = _t2013
		var _t2014 = _s693["c"]
		J.sp(_t2014, "strokeStyle", "#2a1c12")
		var _t2015 = _s693["c"]
		J.sp(_t2015, "lineWidth", 4.0)
		J.mc(_s693["c"], "beginPath", [])
		J.mc(_s693["c"], "moveTo", [(J.sub(v_gc_1514, J.div(_s693["__p"]["GW"], 2.0)) + 18.0), (-J.num(_s693["H2"]))])
		J.mc(_s693["c"], "lineTo", [(J.sub(v_gc_1514, J.div(_s693["__p"]["GW"], 2.0)) + 18.0), _s693["H2"]])
		J.mc(_s693["c"], "moveTo", [J.sub(J.add(v_gc_1514, J.div(_s693["__p"]["GW"], 2.0)), 18.0), (-J.num(_s693["H2"]))])
		J.mc(_s693["c"], "lineTo", [J.sub(J.add(v_gc_1514, J.div(_s693["__p"]["GW"], 2.0)), 18.0), _s693["H2"]])
		J.mc(_s693["c"], "stroke", [])
		var _t2016 = _s693["__p"]["gateOpen"]
		if (not J.t(J.cl(_t2016, null, [J.gp(v_g_1513, "g")]))):
			v_i_1533 = 0.0
			while true:
				if not J.cmp(v_i_1533, 5.0, "<"): break
				v_x_1534 = ((J.sub(v_gc_1514, J.div(_s693["__p"]["GW"], 2.0)) + 30.0) + J.div(J.mul(v_i_1533, J.sub(_s693["__p"]["GW"], 60.0)), 4.0))
				var _t2017 = _s693["c"]
				J.sp(_t2017, "fillStyle", "#1a1414")
				J.mc(_s693["c"], "fillRect", [J.sub(v_x_1534, 3.0), (-26.0), 6.0, 32.0])
				v_i_1533 = J.num(v_i_1533) + 1.0
			var _t2018 = _s693["c"]
			J.sp(_t2018, "fillStyle", "#7a1420")
			J.mc(_s693["c"], "fillRect", [(J.sub(v_gc_1514, J.div(_s693["__p"]["GW"], 2.0)) + 24.0), (-22.0), J.sub(_s693["__p"]["GW"], 48.0), 10.0])
			var _t2019 = _s693["c"]
			J.sp(_t2019, "fillStyle", "#222")
			v_i_1535 = 0.0
			while true:
				if not J.cmp(v_i_1535, 7.0, "<"): break
				J.mc(_s693["c"], "fillRect", [((J.sub(v_gc_1514, J.div(_s693["__p"]["GW"], 2.0)) + 32.0) + J.mul(v_i_1535, 24.0)), (-22.0), 11.0, 10.0])
				v_i_1535 = J.num(v_i_1535) + 1.0
	if J.t(v_found_1516):
		var _t2020 = _s693["c"]
		J.sp(_t2020, "fillStyle", "#4a4238")
		var _t2021 = _s693["c"]
		J.sp(_t2021, "strokeStyle", "#151210")
		var _t2022 = _s693["c"]
		J.sp(_t2022, "lineWidth", 1.5)
		v_i_1536 = 0.0
		while true:
			if not J.cmp(v_i_1536, 5.0, "<"): break
			v_yy_1537 = (((-J.num(_s693["H2"])) + 8.0) + J.div(J.mul(v_i_1536, (J.mul(_s693["H2"], 2.0) - 16.0)), 4.0))
			J.mc(_s693["c"], "beginPath", [])
			J.mc(_s693["c"], "ellipse", [J.add(v_gc_1514, (sin(J.num(J.mul(v_i_1536, 2.3))) * 12.0)), v_yy_1537, 16.0, 7.0, 0.0, 0.0, 7.0])
			J.mc(_s693["c"], "fill", [])
			J.mc(_s693["c"], "stroke", [])
			v_i_1536 = J.num(v_i_1536) + 1.0
	J.mc(_s693["c"], "restore", [])
	var _t2024 = v_g_1513
	if J.t(_t2024):
		var _t2023 = _s693["__p"]["gateOpen"]
		_t2024 = (not J.t(J.cl(_t2023, null, [J.gp(v_g_1513, "g")])))
	if J.t(_t2024):
		v_gx_1538 = J.gp(J.gp(v_g_1513, "g"), "x")
		v_gy_1539 = J.sub(J.gp(J.gp(v_g_1513, "g"), "y"), (30.0 if J.t(J.gp(J.gp(v_g_1513, "g"), "vert")) else 50.0))
		var _t2025 = (not J.leq(J.gp(_s693["__p"]["TMAIN"], J.gp(J.gp(v_g_1513, "g"), "a")), null))
		v_main_1540 = (_t2025 if _t2025 else (not J.leq(J.gp(_s693["__p"]["TMAIN"], J.gp(J.gp(v_g_1513, "g"), "b")), null)))
		J.mc(_s693["c"], "save", [])
		var _t2026 = _s693["c"]
		J.sp(_t2026, "fillStyle", "#e8dcc0")
		J.mc(_s693["c"], "fillRect", [J.sub(v_gx_1538, 50.0), J.sub(v_gy_1539, 26.0), 100.0, 22.0])
		var _t2027 = _s693["c"]
		J.sp(_t2027, "strokeStyle", "#2a1a10")
		var _t2028 = _s693["c"]
		J.sp(_t2028, "lineWidth", 2.0)
		J.mc(_s693["c"], "strokeRect", [J.sub(v_gx_1538, 50.0), J.sub(v_gy_1539, 26.0), 100.0, 22.0])
		var _t2029 = _s693["c"]
		J.sp(_t2029, "fillStyle", "#7a1a10")
		var _t2030 = _s693["c"]
		var _t2031 = "900 13px \"PingFang TC\",\"Noto Sans TC\",sans-serif"
		J.sp(_t2030, "font", _t2031)
		var _t2032 = _s693["c"]
		J.sp(_t2032, "textAlign", "center")
		J.mc(_s693["c"], "fillText", [("主管當值" if J.t(v_main_1540) else "地頭封路"), v_gx_1538, J.sub(v_gy_1539, 10.0)])
		J.mc(_s693["c"], "restore", [])

func _f323(this_, a: Array, env):
	var v_c_1543 = null; var v_t_1544 = null; var v_lp_1545 = null; var v_done_1546 = null; var v_r_1547 = null; var v_g_1548 = null; var v_i_1549 = null; var v_a_1550 = null; var v_x_1551 = null; var v_y_1552 = null; var v_f_1553 = null; var v_gg_1554 = null
	v_c_1543 = J.arg(a, 0)
	v_t_1544 = J.arg(a, 1)
	var _t2033 = env["lairPos"]
	v_lp_1545 = J.cl(_t2033, null, [v_t_1544])
	var _t2034 = env["kingDone"]
	v_done_1546 = J.cl(_t2034, null, [v_t_1544])
	v_r_1547 = 150.0
	J.mc(v_c_1543, "save", [])
	v_g_1548 = J.mc(v_c_1543, "createRadialGradient", [J.gp(v_lp_1545, "x"), J.gp(v_lp_1545, "y"), 20.0, J.gp(v_lp_1545, "x"), J.gp(v_lp_1545, "y"), v_r_1547])
	J.mc(v_g_1548, "addColorStop", [0.0, ("rgba(30,40,40,.15)" if J.t(v_done_1546) else "rgba(40,0,10,.35)")])
	J.mc(v_g_1548, "addColorStop", [1.0, "rgba(0,0,0,0)"])
	J.sp(v_c_1543, "fillStyle", v_g_1548)
	J.mc(v_c_1543, "beginPath", [])
	J.mc(v_c_1543, "ellipse", [J.gp(v_lp_1545, "x"), J.gp(v_lp_1545, "y"), v_r_1547, J.mul(v_r_1547, 0.62), 0.0, 0.0, 7.0])
	J.mc(v_c_1543, "fill", [])
	var _t2035 = ("rgba(120,140,140,.25)" if J.t(v_done_1546) else "rgba(150,30,40,.45)")
	J.sp(v_c_1543, "strokeStyle", _t2035)
	J.sp(v_c_1543, "lineWidth", 3.0)
	J.mc(v_c_1543, "setLineDash", [[14.0, 10.0]])
	J.mc(v_c_1543, "beginPath", [])
	J.mc(v_c_1543, "ellipse", [J.gp(v_lp_1545, "x"), J.gp(v_lp_1545, "y"), J.mul(v_r_1547, 0.9), J.mul(v_r_1547, 0.56), 0.0, 0.0, 7.0])
	J.mc(v_c_1543, "stroke", [])
	J.mc(v_c_1543, "setLineDash", [[]])
	v_i_1549 = 0.0
	while true:
		if not J.cmp(v_i_1549, 6.0, "<"): break
		v_a_1550 = (((J.div(v_i_1549, 6.0) * PI) * 2.0) + 0.3)
		v_x_1551 = J.add(J.gp(v_lp_1545, "x"), (J.mul(cos(J.num(v_a_1550)), v_r_1547) * 0.9))
		v_y_1552 = J.add(J.gp(v_lp_1545, "y"), (J.mul(sin(J.num(v_a_1550)), v_r_1547) * 0.56))
		J.sp(v_c_1543, "fillStyle", "#1a1612")
		J.mc(v_c_1543, "fillRect", [J.sub(v_x_1551, 3.0), J.sub(v_y_1552, 26.0), 6.0, 26.0])
		if (not J.t(v_done_1546)):
			J.mc(v_c_1543, "save", [])
			J.sp(v_c_1543, "globalCompositeOperation", "lighter")
			v_f_1553 = (0.7 + (0.3 * sin(J.num((J.mul(J.gp(env["R"], "t"), 7.0) + J.mul(v_i_1549, 1.7))))))
			v_gg_1554 = J.mc(v_c_1543, "createRadialGradient", [v_x_1551, J.sub(v_y_1552, 32.0), 0.0, v_x_1551, J.sub(v_y_1552, 32.0), J.mul(16.0, v_f_1553)])
			J.mc(v_gg_1554, "addColorStop", [0.0, "rgba(160,255,190,.9)"])
			J.mc(v_gg_1554, "addColorStop", [1.0, "rgba(40,200,120,0)"])
			J.sp(v_c_1543, "fillStyle", v_gg_1554)
			J.mc(v_c_1543, "beginPath", [])
			J.mc(v_c_1543, "arc", [v_x_1551, J.sub(v_y_1552, 32.0), J.mul(16.0, v_f_1553), 0.0, 7.0])
			J.mc(v_c_1543, "fill", [])
			J.mc(v_c_1543, "restore", [])
		v_i_1549 = J.num(v_i_1549) + 1.0
	J.mc(v_c_1543, "restore", [])

func _f324(this_, a: Array, env):
	var v_c_1557 = null; var v_p_1558 = null; var v_d_1559 = null; var v_im_1560 = null; var v_h_1561 = null; var v_w_1562 = null
	v_c_1557 = J.arg(a, 0)
	v_p_1558 = J.arg(a, 1)
	v_d_1559 = J.gp(env["PROP"], J.gp(v_p_1558, "t"))
	var _t2037 = v_d_1559
	if J.t(_t2037):
		var _t2036 = env["img"]
		_t2037 = J.cl(_t2036, null, [J.gp(v_d_1559, "img")])
	v_im_1560 = _t2037
	if (not J.t(v_im_1560)):
		var _t2038 = env["drawProp"]
		J.cl(_t2038, null, [v_c_1557, v_p_1558])
		return null
	v_h_1561 = J.mul(J.gp(v_d_1559, "h"), J.gp(v_p_1558, "s"))
	v_w_1562 = J.div(J.mul(v_h_1561, J.gp(v_im_1560, "naturalWidth")), J.gp(v_im_1560, "naturalHeight"))
	J.mc(v_c_1557, "save", [])
	J.sp(v_c_1557, "fillStyle", "rgba(0,0,0,.32)")
	J.mc(v_c_1557, "beginPath", [])
	J.mc(v_c_1557, "ellipse", [J.gp(v_p_1558, "x"), J.add(J.gp(v_p_1558, "y"), 2.0), J.mul(v_w_1562, 0.38), J.mul(v_w_1562, 0.11), 0.0, 0.0, 7.0])
	J.mc(v_c_1557, "fill", [])
	if J.cmp(J.gp(v_p_1558, "v"), 0.5, ">"):
		J.mc(v_c_1557, "translate", [J.gp(v_p_1558, "x"), 0.0])
		J.mc(v_c_1557, "scale", [(-1.0), 1.0])
		J.mc(v_c_1557, "translate", [(-J.num(J.gp(v_p_1558, "x"))), 0.0])
	J.mc(v_c_1557, "drawImage", [v_im_1560, J.sub(J.gp(v_p_1558, "x"), J.div(v_w_1562, 2.0)), (J.sub(J.gp(v_p_1558, "y"), v_h_1561) + 6.0), v_w_1562, v_h_1561])
	J.mc(v_c_1557, "restore", [])

func _f326(this_, a: Array, env):
	var _t2073 = env["__p"]["__p"]["drawPropImg"]
	return J.cl(_t2073, null, [env["__p"]["c"], env["p"]])

func _f327(this_, a: Array, env):
	var _t2079 = env["__p"]["__p"]["__p"]["drawFaci"]
	return J.cl(_t2079, null, [env["__p"]["__p"]["c"], env["__p"]["f"], env["q"]])

func _f328(this_, a: Array, env):
	var _t2087 = env["__p"]["__p"]["drawUnit"]
	return J.cl(_t2087, null, [env["__p"]["c"], env["u"]])

func _f329(this_, a: Array, env):
	var _t2099 = env["__p"]["__p"]["drawUnit"]
	return J.cl(_t2099, null, [env["__p"]["c"], env["e"]])

func _f330(this_, a: Array, env):
	var v_e_1607 = null
	J.mc(env["__p"]["c"], "save", [])
	var _t2101 = env["__p"]["c"]
	var _t2102 = (0.35 * (1.0 - J.div(J.gp(env["f"], "t"), J.gp(env["f"], "life"))))
	J.sp(_t2101, "globalAlpha", _t2102)
	var _t2103 = env["__p"]["c"]
	J.sp(_t2103, "globalCompositeOperation", "lighter")
	J.mc(J.G.get("ART"), "drawChar", [env["__p"]["c"], J.gp(env["f"], "k"), J.gp(env["f"], "x"), J.gp(env["f"], "y"), J.mul(J.gp(env["f"], "s"), 1.65), {"flip": J.gp(env["f"], "flip"), "shadow": false, "tamed": true, "untied": true, "pose": "move", "walk": true, "t": J.gp(env["__p"]["__p"]["R"], "t")}])
	J.mc(env["__p"]["c"], "restore", [])

func _f331(this_, a: Array, env):
	var v_a_1608 = null; var v_b_1609 = null
	v_a_1608 = J.arg(a, 0)
	v_b_1609 = J.arg(a, 1)
	return J.sub(J.gp(v_a_1608, "y"), J.gp(v_b_1609, "y"))

func _f332(this_, a: Array, env):
	var v_i_1610 = null
	v_i_1610 = J.arg(a, 0)
	return J.mc(v_i_1610, "f", [])

func _f333(this_, a: Array, env):
	var v_x_1623 = null; var v_y_1624 = null
	v_x_1623 = J.arg(a, 0)
	v_y_1624 = J.arg(a, 1)
	return [J.mul(J.add(J.sub(v_x_1623, env["cx"]), env["shx"]), env["k"]), J.mul(J.add(J.sub(v_y_1624, env["cy"]), env["shy"]), env["k"])]

func _f334(this_, a: Array, env):
	var v_x_1625 = null; var v_y_1626 = null; var v_r_1627 = null; var v_a_1628 = null; var v_sx0_1629 = null; var v_sy0_1630 = null; var v_sx_1631 = null; var v_sy_1632 = null; var v_rr_1633 = null; var v_g_1634 = null
	v_x_1625 = J.arg(a, 0)
	v_y_1626 = J.arg(a, 1)
	v_r_1627 = J.arg(a, 2)
	v_a_1628 = J.arg(a, 3)
	var _t2137 = env["S2"]
	var _t2138 = J.cl(_t2137, null, [v_x_1625, v_y_1626])
	var _t2139 = J.gp(_t2138, 0.0)
	v_sx0_1629 = _t2139
	var _t2140 = J.gp(_t2138, 1.0)
	v_sy0_1630 = _t2140
	v_sx_1631 = J.div(v_sx0_1629, env["LQ"])
	v_sy_1632 = J.div(v_sy0_1630, env["LQ"])
	v_rr_1633 = J.div(J.mul(v_r_1627, env["k"]), env["LQ"])
	v_g_1634 = J.mc(env["l"], "createRadialGradient", [v_sx_1631, v_sy_1632, 0.0, v_sx_1631, v_sy_1632, v_rr_1633])
	J.mc(v_g_1634, "addColorStop", [0.0, ("rgba(0,0,0," + J.str(v_a_1628) + ")")])
	J.mc(v_g_1634, "addColorStop", [1.0, "rgba(0,0,0,0)"])
	var _t2141 = env["l"]
	J.sp(_t2141, "fillStyle", v_g_1634)
	J.mc(env["l"], "fillRect", [J.sub(v_sx_1631, v_rr_1633), J.sub(v_sy_1632, v_rr_1633), J.mul(v_rr_1633, 2.0), J.mul(v_rr_1633, 2.0)])

func _f325(this_, a: Array, env):
	var v_vw_1567 = null; var v_vh_1568 = null; var v_sh_1571 = null; var v_gx0_1574 = null; var v_gy0_1575 = null; var v_gx1_1576 = null; var v_gy1_1577 = null; var v_L_1578 = null; var v_items_1579 = null; var v_lights_1580 = null; var v_ph_1583 = null; var v_hole_1585 = null; var v_t_1586 = null; var v_lp_1587 = null; var v_f_1588 = null; var v_t_1589 = null; var v_p_1590 = null; var v_wi_1591 = null; var v_pul_1592 = null; var v_W_1593 = null; var v_H_1594 = null; var v_W2_1595 = null; var v_H2_1596 = null; var v_f_1597 = null; var v_d_1599 = null; var v_t_1602 = null; var v_lp_1603 = null; var v_w_1611 = null; var v_q_1612 = null; var v_f_1613 = null; var v_p_1614 = null; var v_p_1615 = null; var v_y_1616 = null; var v_g_1617 = null; var v_f_1618 = null; var v_i_1619 = null; var v_fx_1620 = null; var v_fy_1621 = null; var v_g_1622 = null; var v_q_1635 = null; var v_q_1636 = null; var v_sx_1637 = null; var v_sy_1638 = null; var v_rr_1639 = null; var v_g_1640 = null; var v_w_1641 = null; var v_sx_1642 = null; var v_sy_1643 = null; var v_a_1644 = null; var v_rr_1645 = null; var v_g_1646 = null; var v_col_1647 = null; var v_d_1648 = null; var v_dx_1649 = null; var v_dy_1650 = null; var v_dl_1651 = null; var v_m_1652 = null
	var _s731 = {"__p": env, "c": null, "k": null, "cx": null, "cy": null, "shx": null, "shy": null, "LQ": null, "l": null, "S2": null}
	_s731["c"] = _s731["__p"]["ctx"]
	_s731["k"] = J.mul(J.gp(_s731["__p"]["R"], "sc"), J.gp(_s731["__p"]["R"], "dpr"))
	v_vw_1567 = _s731["__p"]["VIEW"]
	v_vh_1568 = J.div(J.gp(_s731["__p"]["R"], "h"), J.gp(_s731["__p"]["R"], "sc"))
	_s731["cx"] = J.max_([0.0, J.min_([J.sub(_s731["__p"]["WW"], v_vw_1567), J.sub(J.gp(J.gp(_s731["__p"]["R"], "cam"), "x"), J.div(v_vw_1567, 2.0))])])
	_s731["cy"] = (J.div(J.sub(_s731["__p"]["WH"], v_vh_1568), 2.0) if J.cmp(v_vh_1568, _s731["__p"]["WH"], ">=") else J.max_([(-60.0), J.min_([(J.sub(_s731["__p"]["WH"], v_vh_1568) + 40.0), J.sub(J.gp(J.gp(_s731["__p"]["R"], "cam"), "y"), J.div(v_vh_1568, 2.0))])]))
	var _t2039 = J.gp(_s731["__p"]["R"], "shake")
	v_sh_1571 = (_t2039 if J.t(_t2039) else 0.0)
	_s731["shx"] = (J.mul((randf() - 0.5), v_sh_1571) if J.t(v_sh_1571) else 0.0)
	_s731["shy"] = ((J.mul((randf() - 0.5), v_sh_1571) * 0.7) if J.t(v_sh_1571) else 0.0)
	J.mc(_s731["c"], "setTransform", [1.0, 0.0, 0.0, 1.0, 0.0, 0.0])
	var _t2040 = _s731["c"]
	J.sp(_t2040, "fillStyle", "#060508")
	J.mc(_s731["c"], "fillRect", [0.0, 0.0, J.gp(_s731["__p"]["cv"], "width"), J.gp(_s731["__p"]["cv"], "height")])
	J.mc(_s731["c"], "setTransform", [_s731["k"], 0.0, 0.0, _s731["k"], J.mul(J.add((-J.num(_s731["cx"])), _s731["shx"]), _s731["k"]), J.mul(J.add((-J.num(_s731["cy"])), _s731["shy"]), _s731["k"])])
	v_gx0_1574 = J.max_([0.0, _s731["cx"]])
	v_gy0_1575 = J.max_([0.0, _s731["cy"]])
	v_gx1_1576 = J.min_([_s731["__p"]["WW"], J.add(_s731["cx"], v_vw_1567)])
	v_gy1_1577 = J.min_([_s731["__p"]["WH"], J.add(_s731["cy"], v_vh_1568)])
	var _t2041 = _s731["c"]
	var _t2042 = _s731["__p"]["groundPat"]
	var _t2043 = J.cl(_t2042, null, [_s731["c"]])
	J.sp(_t2041, "fillStyle", _t2043)
	J.mc(_s731["c"], "fillRect", [v_gx0_1574, v_gy0_1575, J.sub(v_gx1_1576, v_gx0_1574), J.sub(v_gy1_1577, v_gy0_1575)])
	var _t2044 = _s731["__p"]["drawPath"]
	J.cl(_t2044, null, [_s731["c"]])
	v_t_1586 = 0.0
	while true:
		if not J.cmp(v_t_1586, 9.0, "<"): break
		var _t2045 = _s731["__p"]["lairPos"]
		v_lp_1587 = J.cl(_t2045, null, [v_t_1586])
		var _t2046 = J.cmp(absf(J.num(J.sub(J.gp(v_lp_1587, "x"), J.add(_s731["cx"], J.div(v_vw_1567, 2.0))))), v_vw_1567, "<")
		if (J.cmp(absf(J.num(J.sub(J.gp(v_lp_1587, "y"), J.add(_s731["cy"], J.div(v_vh_1568, 2.0))))), v_vh_1568, "<") if _t2046 else _t2046):
			var _t2047 = _s731["__p"]["drawLair"]
			J.cl(_t2047, null, [_s731["c"], v_t_1586])
		v_t_1586 = J.num(v_t_1586) + 1.0
	var _t2048 = _s731["__p"]["drawSpots"]
	J.cl(_t2048, null, [_s731["c"], _s731["cx"], _s731["cy"], v_vw_1567, v_vh_1568])
	for _t2049 in J.iter(J.gp(_s731["__p"]["R"], "fx")):
		v_f_1588 = _t2049
		var _t2050 = J.seq(J.gp(v_f_1588, "kind"), "spr")
		if J.t((J.gp(v_f_1588, "ground") if _t2050 else _t2050)):
			var _t2051 = _s731["__p"]["drawSpr"]
			J.cl(_t2051, null, [_s731["c"], v_f_1588])
	if J.t(J.gp(_s731["__p"]["R"], "tele")):
		for _t2052 in J.iter(J.gp(_s731["__p"]["R"], "tele")):
			v_t_1589 = _t2052
			v_p_1590 = J.div(J.gp(v_t_1589, "t"), J.gp(v_t_1589, "dur"))
			var _t2053 = _s731["__p"]["fxImg"]
			v_wi_1591 = J.cl(_t2053, null, ["fx_warn"])
			if J.t(v_wi_1591):
				J.mc(_s731["c"], "save", [])
				v_pul_1592 = (0.7 + (0.25 * sin(J.num(J.mul(J.gp(_s731["__p"]["R"], "t"), 18.0)))))
				var _t2054 = _s731["c"]
				J.sp(_t2054, "globalAlpha", v_pul_1592)
				v_W_1593 = J.mul(J.gp(v_t_1589, "r"), 2.2)
				v_H_1594 = J.div(J.mul(v_W_1593, J.gp(v_wi_1591, "naturalHeight")), J.gp(v_wi_1591, "naturalWidth"))
				J.mc(_s731["c"], "drawImage", [v_wi_1591, J.sub(J.gp(v_t_1589, "x"), J.div(v_W_1593, 2.0)), J.sub(J.gp(v_t_1589, "y"), J.div(v_H_1594, 2.0)), v_W_1593, v_H_1594])
				var _t2055 = _s731["c"]
				var _t2056 = (0.5 + J.mul(0.4, v_p_1590))
				J.sp(_t2055, "globalAlpha", _t2056)
				v_W2_1595 = J.mul(v_W_1593, v_p_1590)
				v_H2_1596 = J.mul(v_H_1594, v_p_1590)
				J.mc(_s731["c"], "drawImage", [v_wi_1591, J.sub(J.gp(v_t_1589, "x"), J.div(v_W2_1595, 2.0)), J.sub(J.gp(v_t_1589, "y"), J.div(v_H2_1596, 2.0)), v_W2_1595, v_H2_1596])
				J.mc(_s731["c"], "restore", [])
				continue
			J.mc(_s731["c"], "save", [])
			var _t2057 = _s731["c"]
			var _t2058 = (0.35 + (0.25 * sin(J.num(J.mul(J.gp(_s731["__p"]["R"], "t"), 20.0)))))
			J.sp(_t2057, "globalAlpha", _t2058)
			var _t2059 = _s731["c"]
			J.sp(_t2059, "fillStyle", "rgba(200,30,20,.35)")
			var _t2060 = _s731["c"]
			J.sp(_t2060, "strokeStyle", "#ff5a3a")
			var _t2061 = _s731["c"]
			J.sp(_t2061, "lineWidth", 3.0)
			J.mc(_s731["c"], "beginPath", [])
			J.mc(_s731["c"], "ellipse", [J.gp(v_t_1589, "x"), J.gp(v_t_1589, "y"), J.gp(v_t_1589, "r"), J.mul(J.gp(v_t_1589, "r"), 0.6), 0.0, 0.0, 7.0])
			J.mc(_s731["c"], "fill", [])
			J.mc(_s731["c"], "stroke", [])
			var _t2062 = _s731["c"]
			J.sp(_t2062, "globalAlpha", 0.6)
			var _t2063 = _s731["c"]
			J.sp(_t2063, "fillStyle", "rgba(255,90,60,.5)")
			J.mc(_s731["c"], "beginPath", [])
			J.mc(_s731["c"], "ellipse", [J.gp(v_t_1589, "x"), J.gp(v_t_1589, "y"), J.mul(J.gp(v_t_1589, "r"), v_p_1590), J.mul(J.mul(J.gp(v_t_1589, "r"), 0.6), v_p_1590), 0.0, 0.0, 7.0])
			J.mc(_s731["c"], "fill", [])
			J.mc(_s731["c"], "restore", [])
	v_L_1578 = J.gp(_s731["__p"]["R"], "L")
	J.mc(_s731["c"], "save", [])
	var _t2064 = _s731["c"]
	J.sp(_t2064, "strokeStyle", "rgba(255,220,120,.55)")
	var _t2065 = _s731["c"]
	J.sp(_t2065, "lineWidth", 2.0)
	J.mc(_s731["c"], "setLineDash", [[6.0, 5.0]])
	var _t2066 = _s731["c"]
	var _t2067 = ((-J.num(J.gp(_s731["__p"]["R"], "t"))) * 20.0)
	J.sp(_t2066, "lineDashOffset", _t2067)
	J.mc(_s731["c"], "beginPath", [])
	J.mc(_s731["c"], "ellipse", [J.gp(v_L_1578, "x"), J.add(J.gp(v_L_1578, "y"), 2.0), 26.0, 9.0, 0.0, 0.0, 7.0])
	J.mc(_s731["c"], "stroke", [])
	J.mc(_s731["c"], "restore", [])
	for _t2068 in J.iter(J.gp(_s731["__p"]["R"], "fx")):
		v_f_1597 = _t2068
		if J.seq(J.gp(v_f_1597, "kind"), "dust"):
			J.mc(J.G.get("Battle"), "drawDust", [_s731["c"], v_f_1597])
	v_items_1579 = []
	v_lights_1580 = []
	for _t2069 in J.iter(J.gp(_s731["__p"]["R"], "props")):
		var _s739 = {"__p": _s731, "p": null}
		_s739["p"] = _t2069
		var _t2070 = J.cmp(J.gp(_s739["p"], "x"), J.sub(_s739["__p"]["cx"], 90.0), ">")
		var _t2071 = (J.cmp(J.gp(_s739["p"], "x"), J.add(J.add(_s739["__p"]["cx"], v_vw_1567), 90.0), "<") if _t2070 else _t2070)
		var _t2072 = (J.cmp(J.gp(_s739["p"], "y"), J.sub(_s739["__p"]["cy"], 20.0), ">") if _t2071 else _t2071)
		if (J.cmp(J.gp(_s739["p"], "y"), J.add(J.add(_s739["__p"]["cy"], v_vh_1568), 160.0), "<") if _t2072 else _t2072):
			J.mc(v_items_1579, "push", [{"y": J.gp(_s739["p"], "y"), "f": Callable(self, "_f326").bind(_s739)}])
			v_d_1599 = J.gp(_s739["__p"]["__p"]["PROP"], J.gp(_s739["p"], "t"))
			if J.t((J.gp(v_d_1599, "light") if J.t(v_d_1599) else v_d_1599)):
				J.mc(v_lights_1580, "push", [{"x": J.gp(_s739["p"], "x"), "y": J.sub(J.gp(_s739["p"], "y"), (J.mul(J.gp(v_d_1599, "h"), J.gp(_s739["p"], "s")) * 0.6)), "r": 150.0, "col": J.gp(v_d_1599, "light")}])
	for _t2074 in J.iter(_s731["__p"]["FACI"]):
		var _s742 = {"__p": _s731, "f": null}
		_s742["f"] = _t2074
		var _s743 = {"__p": _s742, "q": null}
		var _t2075 = _s743["__p"]["__p"]["__p"]["faciPos"]
		_s743["q"] = J.cl(_t2075, null, [_s743["__p"]["f"]])
		var _t2076 = J.cmp(J.gp(_s743["q"], "x"), J.sub(_s743["__p"]["__p"]["cx"], 140.0), ">")
		var _t2077 = (J.cmp(J.gp(_s743["q"], "x"), J.add(J.add(_s743["__p"]["__p"]["cx"], v_vw_1567), 140.0), "<") if _t2076 else _t2076)
		var _t2078 = (J.cmp(J.gp(_s743["q"], "y"), J.sub(_s743["__p"]["__p"]["cy"], 60.0), ">") if _t2077 else _t2077)
		if (J.cmp(J.gp(_s743["q"], "y"), J.add(J.add(_s743["__p"]["__p"]["cy"], v_vh_1568), 160.0), "<") if _t2078 else _t2078):
			J.mc(v_items_1579, "push", [{"y": J.gp(_s743["q"], "y"), "f": Callable(self, "_f327").bind(_s743)}])
			J.mc(v_lights_1580, "push", [{"x": J.gp(_s743["q"], "x"), "y": J.sub(J.gp(_s743["q"], "y"), 40.0), "r": 170.0, "col": ("120,255,160" if J.seq(J.gp(_s743["__p"]["f"], "t"), "station") else ("255,200,120" if J.seq(J.gp(_s743["__p"]["f"], "t"), "tea") else ("140,200,255" if J.seq(J.gp(_s743["__p"]["f"], "t"), "overtime") else null)))}])
	v_t_1602 = 0.0
	while true:
		if not J.cmp(v_t_1602, 9.0, "<"): break
		var _t2080 = _s731["__p"]["kingDone"]
		if (not J.t(J.cl(_t2080, null, [v_t_1602]))):
			var _t2081 = _s731["__p"]["lairPos"]
			v_lp_1603 = J.cl(_t2081, null, [v_t_1602])
			J.mc(v_lights_1580, "push", [{"x": J.gp(v_lp_1603, "x"), "y": J.gp(v_lp_1603, "y"), "r": 200.0, "col": "90,255,160"}])
		v_t_1602 = J.num(v_t_1602) + 1.0
	for _t2082 in J.iter(J.gp(_s731["__p"]["R"], "units")):
		var _s748 = {"__p": _s731, "u": null}
		_s748["u"] = _t2082
		var _t2084 = J.cmp(J.gp(_s748["u"], "hp"), 0.0, ">")
		if not J.t(_t2084):
			var _t2083 = J.gp(_s748["u"], "deadT")
			_t2084 = J.cmp((_t2083 if J.t(_t2083) else 0.0), 0.8, "<")
		var _t2086 = ((not J.t(J.gp(_s748["u"], "gone"))) if _t2084 else _t2084)
		if J.t(_t2086):
			var _t2085 = _s748["__p"]["__p"]["vis"]
			_t2086 = J.cl(_t2085, null, [_s748["u"], _s748["__p"]["cx"], _s748["__p"]["cy"], v_vw_1567, v_vh_1568])
		if J.t(_t2086):
			J.mc(v_items_1579, "push", [{"y": J.gp(_s748["u"], "y"), "f": Callable(self, "_f328").bind(_s748)}])
			var _t2088 = J.cmp(J.gp(_s748["u"], "hp"), 0.0, ">")
			if ((not J.t(J.gp(_s748["u"], "leader"))) if _t2088 else _t2088):
				J.mc(v_lights_1580, "push", [{"x": J.gp(_s748["u"], "x"), "y": J.sub(J.gp(_s748["u"], "y"), 30.0), "r": 60.0}])
	for _t2089 in J.iter(J.gp(_s731["__p"]["R"], "foes")):
		var _s751 = {"__p": _s731, "e": null}
		_s751["e"] = _t2089
		var _t2090 = J.cmp(J.gp(_s751["e"], "hp"), 0.0, ">")
		var _t2091 = ((not J.t(J.gp(_s751["e"], "fled"))) if _t2090 else _t2090)
		var _t2093 = (_t2091 if _t2091 else J.cmp(J.gp(_s751["e"], "down"), 0.0, ">"))
		if not J.t(_t2093):
			var _t2092 = J.gp(_s751["e"], "deadT")
			_t2093 = J.cmp((_t2092 if J.t(_t2092) else 0.0), 0.8, "<")
		var _t2096 = _t2093
		if not J.t(_t2096):
			var _t2095 = J.gp(_s751["e"], "fled")
			if J.t(_t2095):
				var _t2094 = J.gp(_s751["e"], "deadT")
				_t2095 = J.cmp((_t2094 if J.t(_t2094) else 0.0), 1.2, "<")
			_t2096 = _t2095
		var _t2098 = _t2096
		if J.t(_t2098):
			var _t2097 = _s751["__p"]["__p"]["vis"]
			_t2098 = J.cl(_t2097, null, [_s751["e"], _s751["__p"]["cx"], _s751["__p"]["cy"], v_vw_1567, v_vh_1568])
		if J.t(_t2098):
			J.mc(v_items_1579, "push", [{"y": J.gp(_s751["e"], "y"), "f": Callable(self, "_f329").bind(_s751)}])
	for _t2100 in J.iter(J.gp(_s731["__p"]["R"], "fx")):
		var _s753 = {"__p": _s731, "f": null}
		_s753["f"] = _t2100
		if J.seq(J.gp(_s753["f"], "kind"), "after"):
			J.mc(v_items_1579, "push", [{"y": J.sub(J.gp(_s753["f"], "y"), 0.1), "f": Callable(self, "_f330").bind(_s753)}])
	var _t2104 = J.mc(v_items_1579, "sort", [Callable(self, "_f331").bind(_s731)])
	J.mc(_t2104, "forEach", [Callable(self, "_f332").bind(_s731)])
	for _t2105 in J.iter(_s731["__p"]["WALLS"]):
		v_w_1611 = _t2105
		var _t2106 = _s731["__p"]["drawWall"]
		J.cl(_t2106, null, [_s731["c"], v_w_1611, _s731["cx"], _s731["cy"], v_vw_1567, v_vh_1568])
	for _t2107 in J.iter(J.gp(_s731["__p"]["R"], "proj")):
		v_q_1612 = _t2107
		var _t2108 = _s731["__p"]["drawProj"]
		J.cl(_t2108, null, [_s731["c"], v_q_1612])
		J.mc(v_lights_1580, "push", [{"x": J.gp(v_q_1612, "x"), "y": J.gp(v_q_1612, "y"), "r": 50.0}])
	for _t2109 in J.iter(J.gp(_s731["__p"]["R"], "fx")):
		v_f_1613 = _t2109
		if J.seq(J.gp(v_f_1613, "kind"), "spr"):
			if (not J.t(J.gp(v_f_1613, "ground"))):
				var _t2110 = _s731["__p"]["drawSpr"]
				J.cl(_t2110, null, [_s731["c"], v_f_1613])
				var _t2111 = J.gp(v_f_1613, "add")
				if J.t((J.cmp(J.gp(v_f_1613, "t"), J.mul(J.gp(v_f_1613, "life"), 0.5), "<") if J.t(_t2111) else _t2111)):
					J.mc(v_lights_1580, "push", [{"x": J.gp(v_f_1613, "x"), "y": J.gp(v_f_1613, "y"), "r": 60.0}])
		else:
			if J.seq(J.gp(v_f_1613, "kind"), "spark"):
				J.mc(J.G.get("Battle"), "drawSpark", [_s731["c"], v_f_1613])
			else:
				if J.seq(J.gp(v_f_1613, "kind"), "slash"):
					J.mc(J.G.get("Battle"), "drawSlash", [_s731["c"], v_f_1613])
				else:
					if J.seq(J.gp(v_f_1613, "kind"), "ring"):
						v_p_1614 = J.div(J.gp(v_f_1613, "t"), J.gp(v_f_1613, "life"))
						J.mc(_s731["c"], "save", [])
						var _t2112 = _s731["c"]
						var _t2113 = J.gp(v_f_1613, "col")
						J.sp(_t2112, "strokeStyle", _t2113)
						var _t2114 = _s731["c"]
						var _t2115 = J.sub(1.0, v_p_1614)
						J.sp(_t2114, "globalAlpha", _t2115)
						var _t2116 = _s731["c"]
						var _t2117 = ((4.0 * J.sub(1.0, v_p_1614)) + 1.0)
						J.sp(_t2116, "lineWidth", _t2117)
						J.mc(_s731["c"], "beginPath", [])
						J.mc(_s731["c"], "ellipse", [J.gp(v_f_1613, "x"), J.gp(v_f_1613, "y"), J.mul(J.gp(v_f_1613, "r"), (0.3 + J.mul(0.7, v_p_1614))), (J.mul(J.gp(v_f_1613, "r"), 0.6) * (0.3 + J.mul(0.7, v_p_1614))), 0.0, 0.0, 7.0])
						J.mc(_s731["c"], "stroke", [])
						J.mc(_s731["c"], "restore", [])
						J.mc(v_lights_1580, "push", [{"x": J.gp(v_f_1613, "x"), "y": J.gp(v_f_1613, "y"), "r": J.mul(J.gp(v_f_1613, "r"), 0.8)}])
					else:
						if J.seq(J.gp(v_f_1613, "kind"), "soul"):
							v_p_1615 = J.div(J.gp(v_f_1613, "t"), J.gp(v_f_1613, "life"))
							J.mc(_s731["c"], "save", [])
							var _t2118 = _s731["c"]
							J.sp(_t2118, "globalCompositeOperation", "lighter")
							v_y_1616 = (J.sub(J.gp(v_f_1613, "y"), 40.0) - J.mul(v_p_1615, 90.0))
							v_g_1617 = J.mc(_s731["c"], "createRadialGradient", [J.gp(v_f_1613, "x"), v_y_1616, 0.0, J.gp(v_f_1613, "x"), v_y_1616, 16.0])
							J.mc(v_g_1617, "addColorStop", [0.0, ("rgba(220,240,255," + J.str((0.9 * J.sub(1.0, v_p_1615))) + ")")])
							J.mc(v_g_1617, "addColorStop", [1.0, "rgba(120,180,255,0)"])
							var _t2119 = _s731["c"]
							J.sp(_t2119, "fillStyle", v_g_1617)
							J.mc(_s731["c"], "beginPath", [])
							J.mc(_s731["c"], "arc", [J.gp(v_f_1613, "x"), v_y_1616, 16.0, 0.0, 7.0])
							J.mc(_s731["c"], "fill", [])
							var _t2120 = _s731["c"]
							var _t2121 = ("rgba(160,200,255," + J.str((0.18 * J.sub(1.0, v_p_1615))) + ")")
							J.sp(_t2120, "fillStyle", _t2121)
							J.mc(_s731["c"], "fillRect", [J.sub(J.gp(v_f_1613, "x"), 7.0), J.sub(J.gp(v_f_1613, "y"), 160.0), 14.0, 160.0])
							J.mc(_s731["c"], "restore", [])
							J.mc(v_lights_1580, "push", [{"x": J.gp(v_f_1613, "x"), "y": v_y_1616, "r": 70.0}])
	for _t2122 in J.iter(J.gp(_s731["__p"]["R"], "fx")):
		v_f_1618 = _t2122
		var _t2123 = J.seq(J.gp(v_f_1618, "kind"), "num")
		if (_t2123 if _t2123 else J.seq(J.gp(v_f_1618, "kind"), "txt")):
			J.mc(J.G.get("Battle"), "drawText", [_s731["c"], v_f_1618])
	J.mc(_s731["c"], "save", [])
	v_i_1619 = 0.0
	while true:
		if not J.cmp(v_i_1619, 3.0, "<"): break
		v_fx_1620 = J.sub(J.add(_s731["cx"], J.mod((J.mul(v_i_1619, 173.0) + J.mul(J.gp(_s731["__p"]["R"], "t"), (8.0 + J.mul(v_i_1619, 2.0)))), J.add(v_vw_1567, 400.0))), 200.0)
		v_fy_1621 = J.add(J.add(_s731["cy"], J.mul(v_vh_1568, (0.15 + J.mul(v_i_1619, 0.15)))), (sin(J.num(J.add(J.mul(J.gp(_s731["__p"]["R"], "t"), 0.3), v_i_1619))) * 30.0))
		v_g_1622 = J.mc(_s731["c"], "createRadialGradient", [v_fx_1620, v_fy_1621, 0.0, v_fx_1620, v_fy_1621, 220.0])
		J.mc(v_g_1622, "addColorStop", [0.0, "rgba(150,160,190,.07)"])
		J.mc(v_g_1622, "addColorStop", [1.0, "rgba(150,160,190,0)"])
		var _t2124 = _s731["c"]
		J.sp(_t2124, "fillStyle", v_g_1622)
		J.mc(_s731["c"], "fillRect", [J.sub(v_fx_1620, 220.0), J.sub(v_fy_1621, 220.0), 440.0, 440.0])
		v_i_1619 = J.num(v_i_1619) + 1.0
	J.mc(_s731["c"], "restore", [])
	J.mc(_s731["c"], "setTransform", [1.0, 0.0, 0.0, 1.0, 0.0, 0.0])
	_s731["LQ"] = 4.0
	var _t2125 = (not J.t(_s731["__p"]["LC"]))
	var _t2126 = (_t2125 if _t2125 else (not J.seq(J.gp(_s731["__p"]["LC"], "width"), ceil(J.num(J.div(J.gp(_s731["__p"]["cv"], "width"), _s731["LQ"]))))))
	if (_t2126 if _t2126 else (not J.seq(J.gp(_s731["__p"]["LC"], "height"), ceil(J.num(J.div(J.gp(_s731["__p"]["cv"], "height"), _s731["LQ"])))))):
		var _t2127 = J.S_document_("createElement", ["canvas"])
		_s731["__p"]["LC"] = _t2127
		var _t2128 = _s731["__p"]["LC"]
		var _t2129 = ceil(J.num(J.div(J.gp(_s731["__p"]["cv"], "width"), _s731["LQ"])))
		J.sp(_t2128, "width", _t2129)
		var _t2130 = _s731["__p"]["LC"]
		var _t2131 = ceil(J.num(J.div(J.gp(_s731["__p"]["cv"], "height"), _s731["LQ"])))
		J.sp(_t2130, "height", _t2131)
	_s731["l"] = J.mc(_s731["__p"]["LC"], "getContext", ["2d"])
	var _t2132 = _s731["__p"]["phase"]
	v_ph_1583 = J.cl(_t2132, null, [J.gp(J.cl(_s731["__p"]["st"], null, []), "min")])
	var _t2133 = _s731["l"]
	J.sp(_t2133, "globalCompositeOperation", "source-over")
	J.mc(_s731["l"], "clearRect", [0.0, 0.0, J.gp(_s731["__p"]["LC"], "width"), J.gp(_s731["__p"]["LC"], "height")])
	var _t2134 = _s731["l"]
	var _t2135 = ("rgba(22,0,10,.8)" if J.seq(v_ph_1583, "zi") else ("rgba(8,12,24,.5)" if J.seq(v_ph_1583, "work") else ("rgba(10,10,26,.62)" if J.seq(v_ph_1583, "off") else "rgba(4,4,14,.7)")))
	J.sp(_t2134, "fillStyle", _t2135)
	J.mc(_s731["l"], "fillRect", [0.0, 0.0, J.gp(_s731["__p"]["LC"], "width"), J.gp(_s731["__p"]["LC"], "height")])
	var _t2136 = _s731["l"]
	J.sp(_t2136, "globalCompositeOperation", "destination-out")
	_s731["S2"] = Callable(self, "_f333").bind(_s731)
	v_hole_1585 = Callable(self, "_f334").bind(_s731)
	J.cl(v_hole_1585, null, [J.gp(v_L_1578, "x"), J.sub(J.gp(v_L_1578, "y"), 30.0), 330.0, 1.0])
	for _t2142 in J.iter(v_lights_1580):
		v_q_1635 = _t2142
		var _t2143 = J.cmp(J.gp(v_q_1635, "x"), J.sub(_s731["cx"], 200.0), ">")
		var _t2144 = (J.cmp(J.gp(v_q_1635, "x"), J.add(J.add(_s731["cx"], v_vw_1567), 200.0), "<") if _t2143 else _t2143)
		var _t2145 = (J.cmp(J.gp(v_q_1635, "y"), J.sub(_s731["cy"], 200.0), ">") if _t2144 else _t2144)
		if (J.cmp(J.gp(v_q_1635, "y"), J.add(J.add(_s731["cy"], v_vh_1568), 200.0), "<") if _t2145 else _t2145):
			J.cl(v_hole_1585, null, [J.gp(v_q_1635, "x"), J.gp(v_q_1635, "y"), J.gp(v_q_1635, "r"), 0.85])
	var _t2146 = _s731["c"]
	J.sp(_t2146, "imageSmoothingEnabled", true)
	J.mc(_s731["c"], "drawImage", [_s731["__p"]["LC"], 0.0, 0.0, J.gp(_s731["__p"]["cv"], "width"), J.gp(_s731["__p"]["cv"], "height")])
	J.mc(_s731["c"], "save", [])
	var _t2147 = _s731["c"]
	J.sp(_t2147, "globalCompositeOperation", "lighter")
	for _t2148 in J.iter(v_lights_1580):
		v_q_1636 = _t2148
		if J.t(J.gp(v_q_1636, "col")):
			var _t2149 = _s731["S2"]
			var _t2150 = J.cl(_t2149, null, [J.gp(v_q_1636, "x"), J.gp(v_q_1636, "y")])
			var _t2151 = J.gp(_t2150, 0.0)
			v_sx_1637 = _t2151
			var _t2152 = J.gp(_t2150, 1.0)
			v_sy_1638 = _t2152
			v_rr_1639 = J.mul(J.mul(J.gp(v_q_1636, "r"), 0.7), _s731["k"])
			v_g_1640 = J.mc(_s731["c"], "createRadialGradient", [v_sx_1637, v_sy_1638, 0.0, v_sx_1637, v_sy_1638, v_rr_1639])
			J.mc(v_g_1640, "addColorStop", [0.0, ("rgba(" + J.str(J.gp(v_q_1636, "col")) + ",.22)")])
			J.mc(v_g_1640, "addColorStop", [1.0, ("rgba(" + J.str(J.gp(v_q_1636, "col")) + ",0)")])
			var _t2153 = _s731["c"]
			J.sp(_t2153, "fillStyle", v_g_1640)
			J.mc(_s731["c"], "fillRect", [J.sub(v_sx_1637, v_rr_1639), J.sub(v_sy_1638, v_rr_1639), J.mul(v_rr_1639, 2.0), J.mul(v_rr_1639, 2.0)])
	var _t2155 = J.gp(_s731["__p"]["R"], "wisps")
	for _t2154 in J.iter((_t2155 if J.t(_t2155) else [])):
		v_w_1641 = _t2154
		var _t2156 = _s731["S2"]
		var _t2157 = J.cl(_t2156, null, [J.gp(v_w_1641, "x"), J.gp(v_w_1641, "y")])
		var _t2158 = J.gp(_t2157, 0.0)
		v_sx_1642 = _t2158
		var _t2159 = J.gp(_t2157, 1.0)
		v_sy_1643 = _t2159
		v_a_1644 = (0.45 + (0.4 * sin(J.num(J.add(J.mul(J.gp(_s731["__p"]["R"], "t"), 3.0), J.gp(v_w_1641, "ph"))))))
		v_rr_1645 = J.mul(J.mul(J.gp(v_w_1641, "r"), 3.0), _s731["k"])
		v_g_1646 = J.mc(_s731["c"], "createRadialGradient", [v_sx_1642, v_sy_1643, 0.0, v_sx_1642, v_sy_1643, v_rr_1645])
		v_col_1647 = ("255,180,120" if J.t(J.gp(v_w_1641, "hue")) else "150,255,190")
		J.mc(v_g_1646, "addColorStop", [0.0, ("rgba(" + J.str(v_col_1647) + "," + J.str(v_a_1644) + ")")])
		J.mc(v_g_1646, "addColorStop", [1.0, ("rgba(" + J.str(v_col_1647) + ",0)")])
		var _t2160 = _s731["c"]
		J.sp(_t2160, "fillStyle", v_g_1646)
		J.mc(_s731["c"], "fillRect", [J.sub(v_sx_1642, v_rr_1645), J.sub(v_sy_1643, v_rr_1645), J.mul(v_rr_1645, 2.0), J.mul(v_rr_1645, 2.0)])
	J.mc(_s731["c"], "restore", [])
	if J.cmp(J.gp(_s731["__p"]["R"], "buff"), 0.0, ">"):
		J.mc(_s731["c"], "save", [])
		var _t2161 = _s731["c"]
		var _t2162 = (0.08 + (0.04 * sin(J.num(J.mul(J.gp(_s731["__p"]["R"], "t"), 6.0)))))
		J.sp(_t2161, "globalAlpha", _t2162)
		var _t2163 = _s731["c"]
		J.sp(_t2163, "fillStyle", "#ffcf5a")
		J.mc(_s731["c"], "fillRect", [0.0, 0.0, J.gp(_s731["__p"]["cv"], "width"), J.gp(_s731["__p"]["cv"], "height")])
		J.mc(_s731["c"], "restore", [])
	if J.cmp(J.gp(_s731["__p"]["R"], "flash"), 0.0, ">"):
		var _t2164 = _s731["c"]
		var _t2165 = ("rgba(255,255,255," + J.str(J.mul(J.gp(_s731["__p"]["R"], "flash"), 0.5)) + ")")
		J.sp(_t2164, "fillStyle", _t2165)
		J.mc(_s731["c"], "fillRect", [0.0, 0.0, J.gp(_s731["__p"]["cv"], "width"), J.gp(_s731["__p"]["cv"], "height")])
	if J.t(J.gp(_s731["__p"]["R"], "joy")):
		v_d_1648 = J.gp(_s731["__p"]["R"], "dpr")
		var _t2166 = _s731["c"]
		J.sp(_t2166, "strokeStyle", "rgba(255,255,255,.35)")
		var _t2167 = _s731["c"]
		var _t2168 = J.mul(2.0, v_d_1648)
		J.sp(_t2167, "lineWidth", _t2168)
		J.mc(_s731["c"], "beginPath", [])
		J.mc(_s731["c"], "arc", [J.mul(J.gp(J.gp(_s731["__p"]["R"], "joy"), "x0"), v_d_1648), J.mul(J.gp(J.gp(_s731["__p"]["R"], "joy"), "y0"), v_d_1648), J.mul(46.0, v_d_1648), 0.0, 7.0])
		J.mc(_s731["c"], "stroke", [])
		v_dx_1649 = J.sub(J.gp(J.gp(_s731["__p"]["R"], "joy"), "x"), J.gp(J.gp(_s731["__p"]["R"], "joy"), "x0"))
		v_dy_1650 = J.sub(J.gp(J.gp(_s731["__p"]["R"], "joy"), "y"), J.gp(J.gp(_s731["__p"]["R"], "joy"), "y0"))
		v_dl_1651 = J.hypot_([v_dx_1649, v_dy_1650])
		v_m_1652 = J.div(J.min_([46.0, v_dl_1651]), (v_dl_1651 if J.t(v_dl_1651) else 1.0))
		var _t2169 = _s731["c"]
		J.sp(_t2169, "fillStyle", "rgba(255,255,255,.35)")
		J.mc(_s731["c"], "beginPath", [])
		J.mc(_s731["c"], "arc", [J.mul(J.add(J.gp(J.gp(_s731["__p"]["R"], "joy"), "x0"), J.mul(v_dx_1649, v_m_1652)), v_d_1648), J.mul(J.add(J.gp(J.gp(_s731["__p"]["R"], "joy"), "y0"), J.mul(v_dy_1650, v_m_1652)), v_d_1648), J.mul(20.0, v_d_1648), 0.0, 7.0])
		J.mc(_s731["c"], "fill", [])
	J.cl(_s731["__p"]["drawMini"], null, [])

func _f335(this_, a: Array, env):
	var v_c_1655 = null; var v_p_1656 = null; var v_fi_1657 = null; var v_g_1658 = null; var v_v_1659 = null; var v_ang_1660 = null; var v_W_1661 = null; var v_H_1662 = null; var v_i_1663 = null; var v_x0_1664 = null; var v_y0_1665 = null; var v_x1_1666 = null; var v_y1_1667 = null; var v_f_1668 = null
	v_c_1655 = J.arg(a, 0)
	v_p_1656 = J.arg(a, 1)
	var _t2170 = env["fxImg"]
	v_fi_1657 = J.cl(_t2170, null, ["fx_fire", J.gp(v_p_1656, "hue")])
	if J.t(v_fi_1657):
		v_v_1659 = J.gp(v_p_1656, "tg")
		var _t2171 = J.gp(v_p_1656, "vy")
		var _t2173 = (_t2171 if J.t(_t2171) else 0.0)
		var _t2172 = J.gp(v_p_1656, "vx")
		v_ang_1660 = atan2(J.num(_t2173), J.num((_t2172 if J.t(_t2172) else 1.0)))
		var _t2174 = J.gp(v_p_1656, "big")
		v_W_1661 = J.mul(46.0, (_t2174 if J.t(_t2174) else 1.0))
		var _t2175 = J.gp(v_fi_1657, "naturalHeight")
		var _t2177 = J.mul(v_W_1661, (_t2175 if J.t(_t2175) else J.gp(v_fi_1657, "height")))
		var _t2176 = J.gp(v_fi_1657, "naturalWidth")
		v_H_1662 = J.div(_t2177, (_t2176 if J.t(_t2176) else J.gp(v_fi_1657, "width")))
		J.mc(v_c_1655, "save", [])
		J.sp(v_c_1655, "globalCompositeOperation", "lighter")
		J.mc(v_c_1655, "translate", [J.gp(v_p_1656, "x"), J.gp(v_p_1656, "y")])
		J.mc(v_c_1655, "rotate", [v_ang_1660])
		J.mc(v_c_1655, "drawImage", [v_fi_1657, ((-J.num(v_W_1661)) * 0.8), J.div((-J.num(v_H_1662)), 2.0), v_W_1661, v_H_1662])
		J.mc(v_c_1655, "restore", [])
		return null
	J.mc(v_c_1655, "save", [])
	J.sp(v_c_1655, "lineCap", "round")
	v_i_1663 = 1.0
	while true:
		if not J.cmp(v_i_1663, J.len(J.gp(v_p_1656, "trail")), "<"): break
		var _t2178 = J.gp(J.gp(v_p_1656, "trail"), J.sub(v_i_1663, 1.0))
		var _t2179 = J.gp(_t2178, 0.0)
		v_x0_1664 = _t2179
		var _t2180 = J.gp(_t2178, 1.0)
		v_y0_1665 = _t2180
		var _t2181 = J.gp(J.gp(v_p_1656, "trail"), v_i_1663)
		var _t2182 = J.gp(_t2181, 0.0)
		v_x1_1666 = _t2182
		var _t2183 = J.gp(_t2181, 1.0)
		v_y1_1667 = _t2183
		v_f_1668 = J.div(v_i_1663, J.len(J.gp(v_p_1656, "trail")))
		var _t2184 = J.mul(v_f_1668, 0.7)
		J.sp(v_c_1655, "globalAlpha", _t2184)
		var _t2185 = J.gp(v_p_1656, "col")
		J.sp(v_c_1655, "strokeStyle", _t2185)
		var _t2186 = (1.0 + J.mul(v_f_1668, 5.0))
		J.sp(v_c_1655, "lineWidth", _t2186)
		J.mc(v_c_1655, "beginPath", [])
		J.mc(v_c_1655, "moveTo", [v_x0_1664, v_y0_1665])
		J.mc(v_c_1655, "lineTo", [v_x1_1666, v_y1_1667])
		J.mc(v_c_1655, "stroke", [])
		v_i_1663 = J.num(v_i_1663) + 1.0
	J.sp(v_c_1655, "globalAlpha", 1.0)
	J.sp(v_c_1655, "globalCompositeOperation", "lighter")
	v_g_1658 = J.mc(v_c_1655, "createRadialGradient", [J.gp(v_p_1656, "x"), J.gp(v_p_1656, "y"), 0.0, J.gp(v_p_1656, "x"), J.gp(v_p_1656, "y"), 11.0])
	J.mc(v_g_1658, "addColorStop", [0.0, "#fff"])
	J.mc(v_g_1658, "addColorStop", [0.35, J.gp(v_p_1656, "col")])
	J.mc(v_g_1658, "addColorStop", [1.0, "rgba(0,0,0,0)"])
	J.sp(v_c_1655, "fillStyle", v_g_1658)
	J.mc(v_c_1655, "beginPath", [])
	J.mc(v_c_1655, "arc", [J.gp(v_p_1656, "x"), J.gp(v_p_1656, "y"), 11.0, 0.0, 7.0])
	J.mc(v_c_1655, "fill", [])
	J.mc(v_c_1655, "restore", [])

func _f336(this_, a: Array, env):
	var v_u_1671 = null; var v_cx_1672 = null; var v_cy_1673 = null; var v_vw_1674 = null; var v_vh_1675 = null
	v_u_1671 = J.arg(a, 0)
	v_cx_1672 = J.arg(a, 1)
	v_cy_1673 = J.arg(a, 2)
	v_vw_1674 = J.arg(a, 3)
	v_vh_1675 = J.arg(a, 4)
	var _t2187 = J.cmp(J.gp(v_u_1671, "x"), J.sub(v_cx_1672, 80.0), ">")
	var _t2188 = (J.cmp(J.gp(v_u_1671, "x"), J.add(J.add(v_cx_1672, v_vw_1674), 80.0), "<") if _t2187 else _t2187)
	var _t2189 = (J.cmp(J.gp(v_u_1671, "y"), J.sub(v_cy_1673, 20.0), ">") if _t2188 else _t2188)
	return (J.cmp(J.gp(v_u_1671, "y"), J.add(J.add(v_cy_1673, v_vh_1675), 140.0), "<") if _t2189 else _t2189)

func _f337(this_, a: Array, env):
	var v_n_1678 = null
	v_n_1678 = J.arg(a, 0)
	var _t2190 = J.seq(J.typeof_(J.G.get("PT_IMG_SRC")), "undefined")
	if (_t2190 if _t2190 else (not J.t(J.gp(J.G.get("PT_IMG_SRC"), v_n_1678)))):
		return null
	if (not J.t(J.gp(env["IMG"], v_n_1678))):
		var _t2191 = env["IMG"]
		var _t2192 = J.new_("Image", [])
		J.sp(_t2191, v_n_1678, _t2192)
		var _t2193 = J.gp(env["IMG"], v_n_1678)
		var _t2194 = J.gp(J.G.get("PT_IMG_SRC"), v_n_1678)
		J.sp(_t2193, "src", _t2194)
	var _t2195 = J.gp(J.gp(env["IMG"], v_n_1678), "complete")
	return (J.gp(env["IMG"], v_n_1678) if J.t((J.gp(J.gp(env["IMG"], v_n_1678), "naturalWidth") if J.t(_t2195) else _t2195)) else null)

func _f339(this_, a: Array, env):
	var v_t_1689 = null; var v_col_1690 = null
	v_t_1689 = J.arg(a, 0)
	v_col_1690 = J.arg(a, 1)
	var _t2200 = env["c"]
	J.sp(_t2200, "lineWidth", 3.0)
	var _t2201 = env["c"]
	J.sp(_t2201, "strokeStyle", "rgba(0,0,0,.8)")
	J.mc(env["c"], "strokeText", [v_t_1689, env["x"], J.add(env["y"], 18.0)])
	var _t2202 = env["c"]
	J.sp(_t2202, "fillStyle", v_col_1690)
	J.mc(env["c"], "fillText", [v_t_1689, env["x"], J.add(env["y"], 18.0)])

func _f338(this_, a: Array, env):
	var v_f_1682 = null; var v_q_1683 = null; var v_rs_1686 = null; var v_label_1687 = null; var v_im_1688 = null; var v_w_1691 = null; var v_h_1692 = null; var v_off_1693 = null; var v_L_1694 = null; var v_on_1695 = null; var v_cd_1696 = null; var v_i_1697 = null
	var _s790 = {"__p": env, "c": null, "x": null, "y": null}
	_s790["c"] = J.arg(a, 0)
	v_f_1682 = J.arg(a, 1)
	v_q_1683 = J.arg(a, 2)
	_s790["x"] = J.gp(v_q_1683, "x")
	_s790["y"] = J.gp(v_q_1683, "y")
	var _t2196 = _s790["__p"]["regSt"]
	v_rs_1686 = J.cl(_t2196, null, [J.gp(_s790["__p"]["R"], "ci")])
	J.mc(_s790["c"], "save", [])
	var _t2197 = _s790["c"]
	J.sp(_t2197, "textAlign", "center")
	var _t2198 = _s790["c"]
	var _t2199 = "900 12px \"PingFang TC\",\"Noto Sans TC\",sans-serif"
	J.sp(_t2198, "font", _t2199)
	v_label_1687 = Callable(self, "_f339").bind(_s790)
	var _t2203 = _s790["c"]
	J.sp(_t2203, "fillStyle", "rgba(0,0,0,.4)")
	J.mc(_s790["c"], "beginPath", [])
	J.mc(_s790["c"], "ellipse", [_s790["x"], J.add(_s790["y"], 2.0), 52.0, 14.0, 0.0, 0.0, 7.0])
	J.mc(_s790["c"], "fill", [])
	var _t2204 = _s790["__p"]["img"]
	v_im_1688 = J.cl(_t2204, null, [J.gp(v_f_1682, "t")])
	if J.t(v_im_1688):
		v_w_1691 = 118.0
		v_h_1692 = J.div(J.mul(v_w_1691, J.gp(v_im_1688, "naturalHeight")), J.gp(v_im_1688, "naturalWidth"))
		var _t2205 = J.seq(J.gp(v_f_1682, "t"), "station")
		var _t2208 = ((not J.t(J.gp(J.gp(v_rs_1686, "sta"), J.gp(v_f_1682, "z")))) if _t2205 else _t2205)
		if not J.t(_t2208):
			var _t2207 = J.seq(J.gp(v_f_1682, "t"), "tea")
			if J.t(_t2207):
				var _t2206 = J.gp(J.gp(_s790["__p"]["R"], "tea"), J.gp(v_f_1682, "z"))
				_t2207 = J.cmp((_t2206 if J.t(_t2206) else 0.0), J.gp(_s790["__p"]["R"], "t"), ">")
			_t2208 = _t2207
		v_off_1693 = _t2208
		if J.t(v_off_1693):
			var _t2209 = _s790["c"]
			J.sp(_t2209, "filter", "grayscale(.85) brightness(.6)")
		J.mc(_s790["c"], "drawImage", [v_im_1688, J.sub(_s790["x"], J.div(v_w_1691, 2.0)), (J.sub(_s790["y"], v_h_1692) + 8.0), v_w_1691, v_h_1692])
		var _t2210 = _s790["c"]
		J.sp(_t2210, "filter", "none")
		var _t2212 = null
		if J.t(J.gp(J.gp(v_rs_1686, "sta"), J.gp(v_f_1682, "z"))):
			var _t2211 = _s790["__p"]["staName"]
			_t2212 = ("地鐵站・" + J.str(J.cl(_t2211, null, [J.gp(v_f_1682, "z")])))
		else:
			_t2212 = "地鐵站（未開通）"
		v_L_1694 = J.gp({"station": [_t2212, ("#9fe0b8" if J.t(J.gp(J.gp(v_rs_1686, "sta"), J.gp(v_f_1682, "z"))) else "#aaa")], "tea": ["茶水間", "#ffd69a"], "prison": ["扣押室", "#d8c8c8"], "overtime": ["通宵加班房", "#bcd8ff"]}, J.gp(v_f_1682, "t"))
		J.cl(v_label_1687, null, [J.gp(v_L_1694, 0.0), J.gp(v_L_1694, 1.0)])
		J.mc(_s790["c"], "restore", [])
		return null
	if J.seq(J.gp(v_f_1682, "t"), "station"):
		v_on_1695 = J.gp(J.gp(v_rs_1686, "sta"), J.gp(v_f_1682, "z"))
		var _t2213 = _s790["c"]
		J.sp(_t2213, "fillStyle", "#1c1a22")
		var _t2214 = _s790["c"]
		J.sp(_t2214, "strokeStyle", "#0a090c")
		var _t2215 = _s790["c"]
		J.sp(_t2215, "lineWidth", 2.0)
		J.mc(_s790["c"], "fillRect", [J.sub(_s790["x"], 32.0), J.sub(_s790["y"], 30.0), 64.0, 30.0])
		J.mc(_s790["c"], "strokeRect", [J.sub(_s790["x"], 32.0), J.sub(_s790["y"], 30.0), 64.0, 30.0])
		var _t2216 = _s790["c"]
		J.sp(_t2216, "fillStyle", "#0a090c")
		J.mc(_s790["c"], "fillRect", [J.sub(_s790["x"], 18.0), J.sub(_s790["y"], 22.0), 36.0, 22.0])
		var _t2217 = _s790["c"]
		J.sp(_t2217, "strokeStyle", "#3a3440")
		J.mc(_s790["c"], "beginPath", [])
		J.mc(_s790["c"], "moveTo", [J.sub(_s790["x"], 22.0), J.sub(_s790["y"], 30.0)])
		J.mc(_s790["c"], "lineTo", [J.sub(_s790["x"], 22.0), J.sub(_s790["y"], 62.0)])
		J.mc(_s790["c"], "stroke", [])
		var _t2218 = _s790["c"]
		var _t2219 = ("#3fa36a" if J.t(v_on_1695) else "#555")
		J.sp(_t2218, "fillStyle", _t2219)
		J.mc(_s790["c"], "beginPath", [])
		J.mc(_s790["c"], "arc", [J.sub(_s790["x"], 22.0), J.sub(_s790["y"], 70.0), 12.0, 0.0, 7.0])
		J.mc(_s790["c"], "fill", [])
		var _t2220 = _s790["c"]
		J.sp(_t2220, "fillStyle", "#fff")
		var _t2221 = _s790["c"]
		J.sp(_t2221, "font", "900 13px sans-serif")
		J.mc(_s790["c"], "fillText", ["陰", J.sub(_s790["x"], 22.0), J.sub(_s790["y"], 65.0)])
		var _t2223 = null
		if J.t(v_on_1695):
			var _t2222 = _s790["__p"]["staName"]
			_t2223 = ("地鐵站・" + J.str(J.cl(_t2222, null, [J.gp(v_f_1682, "z")])))
		else:
			_t2223 = "地鐵站（未開通）"
		J.cl(v_label_1687, null, [_t2223, ("#9fe0b8" if J.t(v_on_1695) else "#aaa")])
	else:
		if J.seq(J.gp(v_f_1682, "t"), "tea"):
			var _t2224 = J.gp(J.gp(_s790["__p"]["R"], "tea"), J.gp(v_f_1682, "z"))
			v_cd_1696 = J.cmp((_t2224 if J.t(_t2224) else 0.0), J.gp(_s790["__p"]["R"], "t"), ">")
			var _t2225 = _s790["c"]
			J.sp(_t2225, "fillStyle", "#3a2e26")
			var _t2226 = _s790["c"]
			J.sp(_t2226, "strokeStyle", "#0d0a08")
			var _t2227 = _s790["c"]
			J.sp(_t2227, "lineWidth", 2.0)
			J.mc(_s790["c"], "fillRect", [J.sub(_s790["x"], 30.0), J.sub(_s790["y"], 34.0), 60.0, 34.0])
			J.mc(_s790["c"], "strokeRect", [J.sub(_s790["x"], 30.0), J.sub(_s790["y"], 34.0), 60.0, 34.0])
			var _t2228 = _s790["c"]
			J.sp(_t2228, "fillStyle", "#2a201a")
			J.mc(_s790["c"], "beginPath", [])
			J.mc(_s790["c"], "moveTo", [J.sub(_s790["x"], 36.0), J.sub(_s790["y"], 34.0)])
			J.mc(_s790["c"], "lineTo", [_s790["x"], J.sub(_s790["y"], 52.0)])
			J.mc(_s790["c"], "lineTo", [J.add(_s790["x"], 36.0), J.sub(_s790["y"], 34.0)])
			J.mc(_s790["c"], "closePath", [])
			J.mc(_s790["c"], "fill", [])
			J.mc(_s790["c"], "stroke", [])
			var _t2229 = _s790["c"]
			var _t2230 = ("rgba(120,120,120,.5)" if J.t(v_cd_1696) else "rgba(255,214,140,.75)")
			J.sp(_t2229, "fillStyle", _t2230)
			J.mc(_s790["c"], "fillRect", [J.sub(_s790["x"], 10.0), J.sub(_s790["y"], 26.0), 20.0, 14.0])
			if (not J.t(v_cd_1696)):
				var _t2231 = _s790["c"]
				J.sp(_t2231, "strokeStyle", "rgba(255,255,255,.4)")
				J.mc(_s790["c"], "beginPath", [])
				J.mc(_s790["c"], "moveTo", [J.sub(_s790["x"], 4.0), J.sub(_s790["y"], 56.0)])
				J.mc(_s790["c"], "quadraticCurveTo", [J.add(_s790["x"], 4.0), J.sub(_s790["y"], 64.0), J.sub(_s790["x"], 2.0), J.sub(_s790["y"], 72.0)])
				J.mc(_s790["c"], "stroke", [])
			J.cl(v_label_1687, null, ["茶水間", "#ffd69a"])
		else:
			if J.seq(J.gp(v_f_1682, "t"), "prison"):
				var _t2232 = _s790["c"]
				J.sp(_t2232, "strokeStyle", "#6a6460")
				var _t2233 = _s790["c"]
				J.sp(_t2233, "lineWidth", 3.0)
				J.mc(_s790["c"], "strokeRect", [J.sub(_s790["x"], 26.0), J.sub(_s790["y"], 44.0), 52.0, 44.0])
				v_i_1697 = (-2.0)
				while true:
					if not J.cmp(v_i_1697, 2.0, "<="): break
					J.mc(_s790["c"], "beginPath", [])
					J.mc(_s790["c"], "moveTo", [J.add(_s790["x"], J.mul(v_i_1697, 10.0)), J.sub(_s790["y"], 44.0)])
					J.mc(_s790["c"], "lineTo", [J.add(_s790["x"], J.mul(v_i_1697, 10.0)), _s790["y"]])
					J.mc(_s790["c"], "stroke", [])
					v_i_1697 = J.num(v_i_1697) + 1.0
				J.cl(v_label_1687, null, ["扣押室", "#d8c8c8"])
			else:
				if J.seq(J.gp(v_f_1682, "t"), "overtime"):
					var _t2234 = _s790["c"]
					J.sp(_t2234, "fillStyle", "#26222e")
					var _t2235 = _s790["c"]
					J.sp(_t2235, "strokeStyle", "#0a090c")
					var _t2236 = _s790["c"]
					J.sp(_t2236, "lineWidth", 2.0)
					J.mc(_s790["c"], "fillRect", [J.sub(_s790["x"], 34.0), J.sub(_s790["y"], 46.0), 68.0, 46.0])
					J.mc(_s790["c"], "strokeRect", [J.sub(_s790["x"], 34.0), J.sub(_s790["y"], 46.0), 68.0, 46.0])
					var _t2237 = _s790["c"]
					J.sp(_t2237, "fillStyle", "rgba(160,220,255,.55)")
					J.mc(_s790["c"], "fillRect", [J.sub(_s790["x"], 26.0), J.sub(_s790["y"], 38.0), 22.0, 14.0])
					J.mc(_s790["c"], "fillRect", [J.add(_s790["x"], 4.0), J.sub(_s790["y"], 38.0), 22.0, 14.0])
					var _t2238 = _s790["c"]
					J.sp(_t2238, "fillStyle", "#e8dcc0")
					J.mc(_s790["c"], "beginPath", [])
					J.mc(_s790["c"], "arc", [_s790["x"], J.sub(_s790["y"], 58.0), 9.0, 0.0, 7.0])
					J.mc(_s790["c"], "fill", [])
					var _t2239 = _s790["c"]
					J.sp(_t2239, "strokeStyle", "#222")
					J.mc(_s790["c"], "beginPath", [])
					J.mc(_s790["c"], "moveTo", [_s790["x"], J.sub(_s790["y"], 58.0)])
					J.mc(_s790["c"], "lineTo", [_s790["x"], J.sub(_s790["y"], 64.0)])
					J.mc(_s790["c"], "moveTo", [_s790["x"], J.sub(_s790["y"], 58.0)])
					J.mc(_s790["c"], "lineTo", [J.add(_s790["x"], 5.0), J.sub(_s790["y"], 58.0)])
					J.mc(_s790["c"], "stroke", [])
					J.cl(v_label_1687, null, ["通宵加班房", "#bcd8ff"])
	J.mc(_s790["c"], "restore", [])

func _f341(this_, a: Array, env):
	var v_q_1718 = null
	v_q_1718 = J.arg(a, 0)
	return (1.0 - pow(J.num((1.0 - J.min_([1.0, J.max_([0.0, v_q_1718])]))), J.num(3.0)))

func _f340(this_, a: Array, env):
	var v_c_1700 = null; var v_u_1701 = null; var v_dying_1702 = null; var v_p_1703 = null; var v_eo_1704 = null; var v_pose_1705 = null; var v_pt_1706 = null; var v_ox_1707 = null; var v_oy_1708 = null; var v_rot_1709 = null; var v_a_1710 = null; var v_tg_1711 = null; var v_s_1712 = null; var v_o_1713 = null; var v_x_1714 = null; var v_y_1715 = null; var v_top_1716 = null; var v_named_1717 = null; var v_dir_1719 = null; var v_melee_1720 = null; var v_Lg_1721 = null; var v_tt_1722 = null; var v_ai_1723 = null; var v_W_1724 = null; var v_H_1725 = null; var v_ri_1726 = null; var v_pp_1727 = null; var v_W_1728 = null; var v_H_1729 = null; var v_e_1730 = null; var v_bw_1731 = null; var v_t_1732 = null; var v_col_1733 = null; var v_req_1734 = null
	v_c_1700 = J.arg(a, 0)
	v_u_1701 = J.arg(a, 1)
	var _t2240 = J.cmp(J.gp(v_u_1701, "hp"), 0.0, "<=")
	var _t2241 = (_t2240 if _t2240 else J.gp(v_u_1701, "fled"))
	v_dying_1702 = ((not J.cmp(J.gp(v_u_1701, "down"), 0.0, ">")) if J.t(_t2241) else _t2241)
	var _t2244 = null
	if J.t(v_dying_1702):
		var _t2242 = J.gp(v_u_1701, "deadT")
		var _t2243 = J.gp(v_u_1701, "deadT")
		_t2244 = J.min_([1.0, J.div((_t2243 if J.t(_t2243) else 0.0), (1.2 if J.t(J.gp(v_u_1701, "fled")) else 0.8))])
	else:
		_t2244 = 0.0
	v_p_1703 = _t2244
	v_eo_1704 = Callable(self, "_f341").bind(env)
	v_pose_1705 = "idle"
	v_pt_1706 = 0.0
	v_ox_1707 = 0.0
	v_oy_1708 = 0.0
	v_rot_1709 = 0.0
	v_a_1710 = J.gp(v_u_1701, "act")
	v_tg_1711 = (J.gp(v_a_1710, "tg") if J.t(v_a_1710) else v_a_1710)
	if J.cmp(J.gp(v_u_1701, "down"), 0.0, ">"):
		v_pose_1705 = "down"
		v_pt_1706 = 1.0
	else:
		if J.t(((not J.t(J.gp(v_u_1701, "fled"))) if J.t(v_dying_1702) else v_dying_1702)):
			v_pose_1705 = "die"
			v_pt_1706 = v_p_1703
		else:
			if J.t(v_a_1710):
				var _t2246 = null
				if J.t(v_tg_1711):
					var _t2245 = signf(J.num(J.sub(J.gp(v_tg_1711, "x"), J.gp(v_u_1701, "x"))))
					_t2246 = (_t2245 if J.t(_t2245) else 1.0)
				else:
					_t2246 = ((-1.0) if J.t(J.gp(v_u_1701, "flip")) else 1.0)
				v_dir_1719 = _t2246
				v_melee_1720 = J.cmp(J.gp(v_u_1701, "rng"), 60.0, "<")
				v_Lg_1721 = (J.mul((16.0 if J.t(J.gp(v_u_1701, "boss")) else 12.0), J.gp(v_u_1701, "s")) * 1.65)
				var _t2247 = J.gp(v_a_1710, "cast")
				if J.t((_t2247 if J.t(_t2247) else J.gp(v_a_1710, "slam"))):
					v_pose_1705 = "windup"
					var _t2248 = J.min_([1.0, J.div(J.gp(v_a_1710, "t"), J.gp(v_a_1710, "dur"))])
					v_pt_1706 = _t2248
					if (not J.seq(J.gp(v_a_1710, "ph"), "windup")):
						v_pose_1705 = "strike"
						v_pt_1706 = 1.0
				else:
					if J.seq(J.gp(v_a_1710, "ph"), "windup"):
						v_pose_1705 = "windup"
						var _t2249 = J.div(J.gp(v_a_1710, "t"), J.gp(v_a_1710, "dur"))
						v_pt_1706 = _t2249
						var _t2250 = J.mul(((-J.num(v_dir_1719)) * 3.0), J.cl(v_eo_1704, null, [v_pt_1706]))
						v_ox_1707 = _t2250
					else:
						if J.seq(J.gp(v_a_1710, "ph"), "strike"):
							v_pose_1705 = "strike"
							var _t2251 = J.div(J.gp(v_a_1710, "t"), J.gp(env["ATK"], "strike"))
							v_pt_1706 = _t2251
							var _t2252 = (J.mul(J.mul(v_dir_1719, v_Lg_1721), J.cl(v_eo_1704, null, [J.mul(v_pt_1706, 2.0)])) if J.t(v_melee_1720) else ((-J.num(v_dir_1719)) * 4.0))
							v_ox_1707 = _t2252
						else:
							v_pose_1705 = "recover"
							var _t2253 = J.div(J.gp(v_a_1710, "t"), J.gp(env["ATK"], "recover"))
							v_pt_1706 = _t2253
							var _t2254 = ((J.mul(v_dir_1719, v_Lg_1721) * J.sub(1.0, J.cl(v_eo_1704, null, [v_pt_1706]))) if J.t(v_melee_1720) else (((-J.num(v_dir_1719)) * 4.0) * J.sub(1.0, v_pt_1706)))
							v_ox_1707 = _t2254
			else:
				if J.cmp(J.gp(v_u_1701, "hurt"), 0.0, ">"):
					v_pose_1705 = "hurt"
					var _t2255 = (1.0 - J.div(J.gp(v_u_1701, "hurt"), 0.24))
					v_pt_1706 = _t2255
				else:
					if J.t(J.gp(v_u_1701, "moving")):
						v_pose_1705 = "move"
	var _t2256 = J.seq(v_pose_1705, "idle")
	if ((not J.t(v_dying_1702)) if _t2256 else _t2256):
		v_tt_1722 = J.add(J.gp(env["R"], "t"), J.mul(J.gp(v_u_1701, "x"), 0.013))
		var _t2257 = ((-absf(J.num(sin(J.num(J.mul(v_tt_1722, 3.2)))))) * 1.6)
		v_oy_1708 = _t2257
	if J.cmp(J.gp(v_u_1701, "dash"), 0.0, ">"):
		var _t2258 = (0.18 if J.t(J.gp(v_u_1701, "flip")) else (-0.18))
		v_rot_1709 = _t2258
	var _t2260 = J.gp(v_u_1701, "swing")
	if J.t(_t2260):
		var _t2259 = J.seq(J.gp(J.gp(v_u_1701, "swing"), "sty"), "spin")
		_t2260 = (_t2259 if _t2259 else J.seq(J.gp(J.gp(v_u_1701, "swing"), "sty"), "flail"))
	if J.t((J.cmp(J.gp(J.gp(v_u_1701, "swing"), "t"), 0.32, "<") if J.t(_t2260) else _t2260)):
		var _t2261 = ((J.div(J.mul(((-1.0) if J.t(J.gp(v_u_1701, "flip")) else 1.0), J.gp(J.gp(v_u_1701, "swing"), "t")), 0.32) * PI) * 2.0)
		v_rot_1709 = _t2261
		v_pose_1705 = "strike"
		v_pt_1706 = 1.0
	v_s_1712 = J.mul(J.gp(v_u_1701, "s"), 1.65)
	v_o_1713 = {"t": J.add(J.gp(env["R"], "t"), J.mod(J.gp(v_u_1701, "x"), 7.0)), "walk": J.seq(v_pose_1705, "move"), "pose": v_pose_1705, "pt": v_pt_1706, "flip": (not (not J.t(J.gp(v_u_1701, "flip")))), "enemy": J.seq(J.gp(v_u_1701, "side"), 1.0), "tamed": J.seq(J.gp(v_u_1701, "side"), 0.0), "untied": J.seq(J.gp(v_u_1701, "side"), 0.0), "rot": v_rot_1709, "tdx": (J.sub(J.gp(v_tg_1711, "x"), J.gp(v_u_1701, "x")) if J.t(v_tg_1711) else ((-40.0) if J.t(J.gp(v_u_1701, "flip")) else 40.0)), "tdy": (J.sub(J.gp(v_tg_1711, "y"), J.gp(v_u_1701, "y")) if J.t(v_tg_1711) else 0.0), "alpha": (J.max_([0.0, (0.6 - J.mul(v_p_1703, 0.6))]) if J.t(J.gp(v_u_1701, "fled")) else (J.sub(1.0, v_p_1703) if J.t(v_dying_1702) else ((0.55 + (0.3 * sin(J.num(J.mul(J.gp(env["R"], "t"), 12.0))))) if J.cmp(J.gp(v_u_1701, "down"), 0.0, ">") else 1.0)))}
	if J.t(J.gp(v_u_1701, "wpn")):
		var _t2262 = J.gp(J.gp(v_u_1701, "wpn"), "img")
		J.sp(v_o_1713, "weapon", _t2262)
	if J.t(J.gp(v_u_1701, "cloth")):
		var _t2263 = J.gp(v_u_1701, "cloth")
		J.sp(v_o_1713, "cloth", _t2263)
	v_x_1714 = J.add(J.gp(v_u_1701, "x"), v_ox_1707)
	v_y_1715 = J.add(J.gp(v_u_1701, "y"), v_oy_1708)
	var _t2264 = J.seq(J.gp(v_u_1701, "side"), 0.0)
	var _t2265 = (J.cmp(J.gp(env["R"], "buff"), 0.0, ">") if _t2264 else _t2264)
	var _t2266 = (J.cmp(J.gp(v_u_1701, "hp"), 0.0, ">") if _t2265 else _t2265)
	if ((not J.t(v_dying_1702)) if _t2266 else _t2266):
		var _t2267 = env["fxImg"]
		v_ai_1723 = J.cl(_t2267, null, ["fx_aura"])
		if J.t(v_ai_1723):
			J.mc(v_c_1700, "save", [])
			J.sp(v_c_1700, "globalCompositeOperation", "lighter")
			var _t2268 = (0.35 + (0.15 * sin(J.num(J.add(J.mul(J.gp(env["R"], "t"), 8.0), J.gp(v_u_1701, "x"))))))
			J.sp(v_c_1700, "globalAlpha", _t2268)
			v_W_1724 = J.mul(70.0, v_s_1712)
			v_H_1725 = J.div(J.mul(v_W_1724, J.gp(v_ai_1723, "naturalHeight")), J.gp(v_ai_1723, "naturalWidth"))
			J.mc(v_c_1700, "drawImage", [v_ai_1723, J.sub(J.gp(v_u_1701, "x"), J.div(v_W_1724, 2.0)), J.sub(J.gp(v_u_1701, "y"), J.mul(v_H_1725, 0.92)), v_W_1724, v_H_1725])
			J.mc(v_c_1700, "restore", [])
	var _t2270 = v_a_1710
	if J.t(_t2270):
		var _t2269 = J.gp(v_a_1710, "cast")
		_t2270 = (_t2269 if J.t(_t2269) else J.gp(v_a_1710, "slam"))
	if J.t((J.seq(J.gp(v_a_1710, "ph"), "windup") if J.t(_t2270) else _t2270)):
		var _t2271 = env["fxImg"]
		v_ri_1726 = J.cl(_t2271, null, ["fx_ring", (150.0 if J.t(J.gp(v_u_1701, "side")) else 0.0)])
		if J.t(v_ri_1726):
			v_pp_1727 = J.min_([1.0, J.div(J.gp(v_a_1710, "t"), J.gp(v_a_1710, "dur"))])
			J.mc(v_c_1700, "save", [])
			J.sp(v_c_1700, "globalCompositeOperation", "lighter")
			var _t2272 = (0.5 + J.mul(v_pp_1727, 0.5))
			J.sp(v_c_1700, "globalAlpha", _t2272)
			v_W_1728 = (J.mul((120.0 - J.mul(50.0, v_pp_1727)), v_s_1712) * (1.4 if J.t(J.gp(v_u_1701, "boss")) else 1.0))
			v_H_1729 = J.div(J.mul(v_W_1728, J.gp(v_ri_1726, "naturalHeight")), J.gp(v_ri_1726, "naturalWidth"))
			J.mc(v_c_1700, "drawImage", [v_ri_1726, J.sub(J.gp(v_u_1701, "x"), J.div(v_W_1728, 2.0)), J.sub(J.gp(v_u_1701, "y"), J.div(v_H_1729, 2.0)), v_W_1728, v_H_1729])
			J.mc(v_c_1700, "restore", [])
		else:
			var _t2273 = J.gp(J.G.get("Battle"), "drawCharge")
			J.mc(_t2273, "call", [{"t": J.gp(env["R"], "t")}, v_c_1700, v_x_1714, J.sub(v_y_1715, J.mul(28.0, v_s_1712)), v_s_1712, J.div(J.gp(v_a_1710, "t"), J.gp(v_a_1710, "dur")), ("#ff9ac0" if J.t(J.gp(v_u_1701, "side")) else "#9ff3ff"), false])
	J.mc(J.G.get("ART"), "drawChar", [v_c_1700, J.gp(v_u_1701, "k"), v_x_1714, v_y_1715, v_s_1712, v_o_1713])
	var _t2274 = J.gp(v_u_1701, "cloth")
	var _t2275 = ((not J.seq(v_pose_1705, "down")) if J.t(_t2274) else _t2274)
	if J.t(((not J.t(v_dying_1702)) if J.t(_t2275) else _t2275)):
		var _t2276 = env["drawCloth"]
		J.cl(_t2276, null, [v_c_1700, v_u_1701, v_x_1714, v_y_1715, v_s_1712, v_o_1713])
	var _t2277 = J.gp(v_u_1701, "badge")
	var _t2278 = ((not J.t(v_rot_1709)) if J.t(_t2277) else _t2277)
	var _t2279 = ((not J.seq(v_pose_1705, "down")) if J.t(_t2278) else _t2278)
	if J.t(((not J.t(v_dying_1702)) if J.t(_t2279) else _t2279)):
		var _t2280 = env["drawBadge"]
		J.cl(_t2280, null, [v_c_1700, v_u_1701, v_x_1714, v_y_1715, v_s_1712])
	var _t2281 = J.gp(v_u_1701, "wpn")
	var _t2282 = ((not J.seq(v_pose_1705, "down")) if J.t(_t2281) else _t2281)
	if J.t(((not J.t(v_dying_1702)) if J.t(_t2282) else _t2282)):
		var _t2283 = env["drawWeapon"]
		J.cl(_t2283, null, [v_c_1700, v_u_1701, v_x_1714, v_y_1715, v_s_1712, v_pose_1705, v_pt_1706, v_rot_1709])
	if J.cmp(J.gp(v_u_1701, "flash"), 0.0, ">"):
		J.mc(v_c_1700, "save", [])
		J.sp(v_c_1700, "globalCompositeOperation", "lighter")
		J.mc(J.G.get("ART"), "drawChar", [v_c_1700, J.gp(v_u_1701, "k"), v_x_1714, v_y_1715, v_s_1712, J.S_Object_("assign", [{}, v_o_1713, {"alpha": (J.mul(J.gp(v_o_1713, "alpha"), J.gp(v_u_1701, "flash")) * 0.8), "shadow": false}])])
		J.mc(v_c_1700, "restore", [])
	var _t2285 = v_a_1710
	if J.t(_t2285):
		var _t2284 = J.gp(v_a_1710, "cast")
		_t2285 = (_t2284 if J.t(_t2284) else J.gp(v_a_1710, "slam"))
	var _t2287 = (J.seq(J.gp(v_a_1710, "ph"), "windup") if J.t(_t2285) else _t2285)
	if J.t(_t2287):
		var _t2286 = env["fxImg"]
		_t2287 = (not J.t(J.cl(_t2286, null, ["fx_ring"])))
	if J.t(_t2287):
		var _t2288 = J.gp(J.G.get("Battle"), "drawCharge")
		J.mc(_t2288, "call", [{"t": J.gp(env["R"], "t")}, v_c_1700, v_x_1714, J.sub(v_y_1715, J.mul(28.0, v_s_1712)), v_s_1712, J.div(J.gp(v_a_1710, "t"), J.gp(v_a_1710, "dur")), ("#ff9ac0" if J.t(J.gp(v_u_1701, "side")) else "#9ff3ff"), true])
	if J.t(v_dying_1702):
		return null
	v_top_1716 = (J.sub(J.gp(v_u_1701, "y"), J.mul((70.0 if J.t(J.gp(v_u_1701, "leader")) else (88.0 if J.t(J.gp(v_u_1701, "boss")) else 78.0)), v_s_1712)) - 2.0)
	if J.cmp(J.gp(v_u_1701, "down"), 0.0, ">"):
		J.mc(v_c_1700, "save", [])
		J.sp(v_c_1700, "strokeStyle", "#ffd84a")
		J.sp(v_c_1700, "lineWidth", 3.0)
		J.mc(v_c_1700, "beginPath", [])
		J.mc(v_c_1700, "arc", [J.gp(v_u_1701, "x"), J.sub(v_top_1716, 6.0), 11.0, J.div((-PI), 2.0), (J.div((-PI), 2.0) + ((PI * 2.0) * J.div(J.gp(v_u_1701, "down"), J.gp(v_u_1701, "downMax"))))])
		J.mc(v_c_1700, "stroke", [])
		J.sp(v_c_1700, "fillStyle", "#ffd84a")
		J.sp(v_c_1700, "font", "900 12px sans-serif")
		J.sp(v_c_1700, "textAlign", "center")
		J.mc(v_c_1700, "fillText", ["?", J.gp(v_u_1701, "x"), J.sub(v_top_1716, 2.0)])
		J.mc(v_c_1700, "restore", [])
		return null
	var _t2289 = J.gp(v_u_1701, "boss")
	var _t2290 = (_t2289 if J.t(_t2289) else J.gp(v_u_1701, "elite"))
	var _t2292 = (_t2290 if J.t(_t2290) else (not J.leq(J.gp(v_u_1701, "guard"), null)))
	if not J.t(_t2292):
		var _t2291 = J.gp(v_u_1701, "bryan")
		_t2292 = (J.seq(J.gp(v_u_1701, "k"), "npc_rival") if J.t(_t2291) else _t2291)
	v_named_1717 = (_t2292 if J.t(_t2292) else J.gp(v_u_1701, "otBoss"))
	var _t2293 = J.cmp(J.gp(v_u_1701, "hp"), J.gp(v_u_1701, "maxhp"), "<")
	var _t2294 = (_t2293 if _t2293 else v_named_1717)
	if J.t((_t2294 if J.t(_t2294) else J.gp(v_u_1701, "leader"))):
		v_bw_1731 = (62.0 if J.t(J.gp(v_u_1701, "boss")) else (46.0 if J.t(v_named_1717) else (40.0 if J.t(J.gp(v_u_1701, "leader")) else (20.0 if J.seq(J.gp(v_u_1701, "role"), "troop") else 28.0))))
		J.sp(v_c_1700, "fillStyle", "rgba(0,0,0,.65)")
		J.mc(v_c_1700, "fillRect", [(J.sub(J.gp(v_u_1701, "x"), J.div(v_bw_1731, 2.0)) - 1.0), J.sub(v_top_1716, 1.0), J.add(v_bw_1731, 2.0), 5.0])
		var _t2295 = ("#e84a5f" if J.t(J.gp(v_u_1701, "side")) else ("#ffd84a" if J.t(J.gp(v_u_1701, "leader")) else "#4ade80"))
		J.sp(v_c_1700, "fillStyle", _t2295)
		J.mc(v_c_1700, "fillRect", [J.sub(J.gp(v_u_1701, "x"), J.div(v_bw_1731, 2.0)), v_top_1716, J.mul(v_bw_1731, J.max_([0.0, J.div(J.gp(v_u_1701, "hp"), J.gp(v_u_1701, "maxhp"))])), 3.0])
		var _t2296 = J.gp(v_u_1701, "sk")
		var _t2297 = (J.seq(J.gp(v_u_1701, "side"), 0.0) if J.t(_t2296) else _t2296)
		if J.t(((not J.t(J.gp(v_u_1701, "leader"))) if J.t(_t2297) else _t2297)):
			var _t2298 = ("#ffd84a" if J.cmp(J.gp(v_u_1701, "energy"), 100.0, ">=") else "#7dd3fc")
			J.sp(v_c_1700, "fillStyle", _t2298)
			var _t2301 = J.sub(J.gp(v_u_1701, "x"), J.div(v_bw_1731, 2.0))
			var _t2302 = J.add(v_top_1716, 4.0)
			var _t2299 = J.gp(v_u_1701, "energy")
			var _t2300 = J.gp(v_u_1701, "energy")
			J.mc(v_c_1700, "fillRect", [_t2301, _t2302, J.mul(v_bw_1731, J.min_([1.0, J.div((_t2300 if J.t(_t2300) else 0.0), 100.0)])), 2.0])
		var _t2303 = J.seq(J.gp(v_u_1701, "role"), "crew")
		var _t2305 = (J.gp(v_u_1701, "g") if _t2303 else _t2303)
		if J.t(_t2305):
			var _t2304 = J.gp(J.gp(v_u_1701, "g"), "fat")
			_t2305 = J.cmp((_t2304 if J.t(_t2304) else 0.0), 70.0, ">=")
		if J.t(_t2305):
			J.sp(v_c_1700, "fillStyle", "#ff9a5a")
			J.sp(v_c_1700, "font", "800 10px sans-serif")
			J.sp(v_c_1700, "textAlign", "center")
			J.mc(v_c_1700, "fillText", ["累", J.add(J.add(J.gp(v_u_1701, "x"), J.div(v_bw_1731, 2.0)), 6.0), J.add(v_top_1716, 5.0)])
	if J.t((v_named_1717 if J.t(v_named_1717) else J.gp(v_u_1701, "leader"))):
		J.mc(v_c_1700, "save", [])
		var _t2306 = ("900 " + J.str((13.0 if J.t(J.gp(v_u_1701, "boss")) else 11.0)) + "px \"PingFang TC\",\"Noto Sans TC\",sans-serif")
		J.sp(v_c_1700, "font", _t2306)
		J.sp(v_c_1700, "textAlign", "center")
		J.sp(v_c_1700, "lineWidth", 3.0)
		J.sp(v_c_1700, "strokeStyle", "rgba(0,0,0,.85)")
		v_t_1732 = ("阿福" if J.t(J.gp(v_u_1701, "leader")) else ((J.str(J.gp(v_u_1701, "kname")) + "・" + J.str(J.gp(v_u_1701, "name"))) if J.t(J.gp(v_u_1701, "kname")) else (("釘子戶・" + J.str(J.gp(v_u_1701, "name"))) if J.t(J.gp(v_u_1701, "elite")) else J.gp(v_u_1701, "name"))))
		v_col_1733 = ("#ffe9a0" if J.t(J.gp(v_u_1701, "leader")) else ("#ffb0ff" if J.t(J.gp(v_u_1701, "elite")) else ("#ff9a9a" if J.t(J.gp(v_u_1701, "bryan")) else "#ffd0d8")))
		J.mc(v_c_1700, "strokeText", [v_t_1732, J.gp(v_u_1701, "x"), J.sub(v_top_1716, 5.0)])
		J.sp(v_c_1700, "fillStyle", v_col_1733)
		J.mc(v_c_1700, "fillText", [v_t_1732, J.gp(v_u_1701, "x"), J.sub(v_top_1716, 5.0)])
		var _t2307 = (not J.leq(J.gp(v_u_1701, "guard"), null))
		var _t2308 = ((not J.t(J.gp(v_u_1701, "awake"))) if _t2307 else _t2307)
		if J.t((J.gp(v_u_1701, "boss") if _t2308 else _t2308)):
			v_req_1734 = J.gp(J.gp(J.gp(J.gp(J.G.get("CHAPTERS"), J.gp(env["R"], "ci")), "stages"), J.gp(v_u_1701, "guard")), "req")
			if J.cmp(J.gp(J.G.get("S"), "lv"), v_req_1734, "<"):
				J.sp(v_c_1700, "fillStyle", "#ff8a8a")
				J.mc(v_c_1700, "strokeText", [("需主公 Lv" + J.str(v_req_1734)), J.gp(v_u_1701, "x"), J.sub(v_top_1716, 19.0)])
				J.mc(v_c_1700, "fillText", [("需主公 Lv" + J.str(v_req_1734)), J.gp(v_u_1701, "x"), J.sub(v_top_1716, 19.0)])
		J.mc(v_c_1700, "restore", [])
	var _t2310 = J.seq(J.gp(v_u_1701, "side"), 1.0)
	if J.t(_t2310):
		var _t2309 = env["phase"]
		_t2310 = J.seq(J.cl(_t2309, null, [J.gp(J.cl(env["st"], null, []), "min")]), "work")
	var _t2311 = ((not J.t(J.gp(v_u_1701, "provoked"))) if _t2310 else _t2310)
	var _t2312 = (J.leq(J.gp(v_u_1701, "guard"), null) if _t2311 else _t2311)
	if ((not J.t(J.gp(v_u_1701, "bryan"))) if _t2312 else _t2312):
		J.mc(v_c_1700, "save", [])
		J.sp(v_c_1700, "font", "800 10px sans-serif")
		J.sp(v_c_1700, "fillStyle", "rgba(200,220,255,.75)")
		J.sp(v_c_1700, "textAlign", "center")
		J.mc(v_c_1700, "fillText", ["摸魚中 z", J.gp(v_u_1701, "x"), J.sub(v_top_1716, 5.0)])
		J.mc(v_c_1700, "restore", [])

func _f342(this_, a: Array, env):
	var v_c_1737 = null; var v_u_1738 = null; var v_x_1739 = null; var v_y_1740 = null; var v_s_1741 = null; var v_o_1742 = null; var v_H_1743 = null
	v_c_1737 = J.arg(a, 0)
	v_u_1738 = J.arg(a, 1)
	v_x_1739 = J.arg(a, 2)
	v_y_1740 = J.arg(a, 3)
	v_s_1741 = J.arg(a, 4)
	v_o_1742 = J.arg(a, 5)
	v_H_1743 = J.mul(58.0, v_s_1741)
	J.mc(v_c_1737, "save", [])
	J.mc(v_c_1737, "beginPath", [])
	J.mc(v_c_1737, "rect", [J.sub(v_x_1739, v_H_1743), J.sub(v_y_1740, J.mul(v_H_1743, 0.5)), J.mul(v_H_1743, 2.0), J.mul(v_H_1743, 0.62)])
	J.mc(v_c_1737, "clip", [])
	var _t2313 = J.gp(v_u_1738, "cloth")
	J.sp(v_c_1737, "filter", _t2313)
	J.sp(v_c_1737, "globalAlpha", 0.72)
	J.mc(J.G.get("ART"), "drawChar", [v_c_1737, J.gp(v_u_1738, "k"), v_x_1739, v_y_1740, v_s_1741, J.S_Object_("assign", [{}, v_o_1742, {"shadow": false}])])
	J.mc(v_c_1737, "restore", [])

func _f344(this_, a: Array, env):
	var v_q_1765 = null
	v_q_1765 = J.arg(a, 0)
	return (1.0 - pow(J.num((1.0 - J.min_([1.0, J.max_([0.0, v_q_1765])]))), J.num(3.0)))

func _f343(this_, a: Array, env):
	var v_c_1746 = null; var v_u_1747 = null; var v_x_1748 = null; var v_y_1749 = null; var v_s_1750 = null; var v_pose_1751 = null; var v_pt_1752 = null; var v_rot_1753 = null; var v_im_1754 = null; var v_H_1755 = null; var v_fd_1756 = null; var v_sty_1757 = null; var v_far_1758 = null; var v_eo_1759 = null; var v_a_1760 = null; var v_hx_1761 = null; var v_hy_1762 = null; var v_h_1763 = null; var v_w_1764 = null
	v_c_1746 = J.arg(a, 0)
	v_u_1747 = J.arg(a, 1)
	v_x_1748 = J.arg(a, 2)
	v_y_1749 = J.arg(a, 3)
	v_s_1750 = J.arg(a, 4)
	v_pose_1751 = J.arg(a, 5)
	v_pt_1752 = J.arg(a, 6)
	v_rot_1753 = J.arg(a, 7)
	var _t2314 = env["img"]
	v_im_1754 = J.cl(_t2314, null, [J.gp(J.gp(v_u_1747, "wpn"), "img")])
	if (not J.t(v_im_1754)):
		return null
	v_H_1755 = J.mul(58.0, v_s_1750)
	v_fd_1756 = ((-1.0) if J.t(J.gp(v_u_1747, "flip")) else 1.0)
	v_sty_1757 = J.gp(J.gp(v_u_1747, "wpn"), "sty")
	var _t2315 = ["shoot", "beam", "poke", "pull", "splash"]
	v_far_1758 = J.mc(_t2315, "includes", [v_sty_1757])
	v_eo_1759 = Callable(self, "_f344").bind(env)
	v_a_1760 = (0.45 + (sin(J.num((J.mul(J.gp(env["R"], "t"), 3.0) + J.mul(v_x_1748, 0.01)))) * 0.05))
	if J.seq(v_pose_1751, "move"):
		var _t2316 = (0.6 + (sin(J.num(J.mul(J.gp(env["R"], "t"), 9.0))) * 0.12))
		v_a_1760 = _t2316
	else:
		if J.seq(v_pose_1751, "windup"):
			var _t2317 = ((0.45 + J.mul(0.9, v_pt_1752)) if J.t(v_far_1758) else (0.45 - J.mul(1.7, J.cl(v_eo_1759, null, [v_pt_1752]))))
			v_a_1760 = _t2317
		else:
			if J.seq(v_pose_1751, "strike"):
				var _t2318 = (1.5 if J.t(v_far_1758) else ((-1.25) + J.mul(3.0, J.cl(v_eo_1759, null, [v_pt_1752]))))
				v_a_1760 = _t2318
			else:
				if J.seq(v_pose_1751, "recover"):
					var _t2319 = ((1.5 - J.mul(1.05, v_pt_1752)) if J.t(v_far_1758) else (1.75 - J.mul(1.3, v_pt_1752)))
					v_a_1760 = _t2319
	v_hx_1761 = J.add(v_x_1748, (J.mul(v_fd_1756, v_H_1755) * 0.2))
	v_hy_1762 = J.sub(v_y_1749, J.mul(v_H_1755, 0.4))
	var _t2321 = J.mul(v_H_1755, 0.74)
	var _t2320 = J.seq(v_sty_1757, "slam")
	v_h_1763 = (_t2321 * (1.15 if (_t2320 if _t2320 else J.seq(v_sty_1757, "flail")) else 1.0))
	v_w_1764 = J.div(J.mul(v_h_1763, J.gp(v_im_1754, "naturalWidth")), J.gp(v_im_1754, "naturalHeight"))
	J.mc(v_c_1746, "save", [])
	if J.t(v_rot_1753):
		J.mc(v_c_1746, "translate", [v_x_1748, J.sub(v_y_1749, J.mul(15.0, v_s_1750))])
		J.mc(v_c_1746, "rotate", [v_rot_1753])
		J.mc(v_c_1746, "translate", [(-J.num(v_x_1748)), (-J.sub(v_y_1749, J.mul(15.0, v_s_1750)))])
	J.mc(v_c_1746, "translate", [v_hx_1761, v_hy_1762])
	J.mc(v_c_1746, "scale", [v_fd_1756, 1.0])
	J.mc(v_c_1746, "rotate", [v_a_1760])
	J.mc(v_c_1746, "drawImage", [v_im_1754, J.div((-J.num(v_w_1764)), 2.0), ((-J.num(v_h_1763)) * 0.86), v_w_1764, v_h_1763])
	var _t2322 = J.gp(v_u_1747, "swing")
	var _t2323 = (J.cmp(J.gp(J.gp(v_u_1747, "swing"), "t"), 0.12, "<") if J.t(_t2322) else _t2322)
	if J.t(((not J.t(v_far_1758)) if J.t(_t2323) else _t2323)):
		J.sp(v_c_1746, "globalCompositeOperation", "lighter")
		var _t2324 = (0.5 * (1.0 - J.div(J.gp(J.gp(v_u_1747, "swing"), "t"), 0.12)))
		J.sp(v_c_1746, "globalAlpha", _t2324)
		J.mc(v_c_1746, "drawImage", [v_im_1754, J.div((-J.num(v_w_1764)), 2.0), ((-J.num(v_h_1763)) * 0.86), v_w_1764, v_h_1763])
	J.mc(v_c_1746, "restore", [])

func _f345(this_, a: Array, env):
	var v_c_1768 = null; var v_u_1769 = null; var v_x_1770 = null; var v_y_1771 = null; var v_s_1772 = null; var v_H_1773 = null; var v_fx_1774 = null; var v_nx_1775 = null; var v_ny_1776 = null; var v_bx_1777 = null; var v_by_1778 = null
	v_c_1768 = J.arg(a, 0)
	v_u_1769 = J.arg(a, 1)
	v_x_1770 = J.arg(a, 2)
	v_y_1771 = J.arg(a, 3)
	v_s_1772 = J.arg(a, 4)
	v_H_1773 = J.mul(58.0, v_s_1772)
	v_fx_1774 = ((-1.0) if J.t(J.gp(v_u_1769, "flip")) else 1.0)
	v_nx_1775 = J.add(v_x_1770, (J.mul(v_fx_1774, v_H_1773) * 0.02))
	v_ny_1776 = J.sub(v_y_1771, J.mul(v_H_1773, 0.74))
	v_bx_1777 = J.add(J.add(v_x_1770, (J.mul(v_fx_1774, v_H_1773) * 0.03)), (sin(J.num(J.add(J.mul(J.gp(env["R"], "t"), 3.0), v_x_1770))) * 0.8))
	v_by_1778 = J.sub(v_y_1771, J.mul(v_H_1773, 0.5))
	J.mc(v_c_1768, "save", [])
	var _t2325 = J.gp(J.gp(v_u_1769, "badge"), "col")
	J.sp(v_c_1768, "strokeStyle", _t2325)
	var _t2326 = J.mul(1.4, v_s_1772)
	J.sp(v_c_1768, "lineWidth", _t2326)
	J.mc(v_c_1768, "beginPath", [])
	J.mc(v_c_1768, "moveTo", [J.sub(v_nx_1775, J.mul(5.0, v_s_1772)), v_ny_1776])
	J.mc(v_c_1768, "lineTo", [v_bx_1777, J.sub(v_by_1778, J.mul(3.0, v_s_1772))])
	J.mc(v_c_1768, "lineTo", [J.add(v_nx_1775, J.mul(5.0, v_s_1772)), v_ny_1776])
	J.mc(v_c_1768, "stroke", [])
	J.sp(v_c_1768, "fillStyle", "#f4efe2")
	J.sp(v_c_1768, "strokeStyle", "#2a2018")
	var _t2327 = J.mul(1.0, v_s_1772)
	J.sp(v_c_1768, "lineWidth", _t2327)
	J.mc(v_c_1768, "fillRect", [J.sub(v_bx_1777, J.mul(3.5, v_s_1772)), J.sub(v_by_1778, J.mul(3.0, v_s_1772)), J.mul(7.0, v_s_1772), J.mul(9.0, v_s_1772)])
	J.mc(v_c_1768, "strokeRect", [J.sub(v_bx_1777, J.mul(3.5, v_s_1772)), J.sub(v_by_1778, J.mul(3.0, v_s_1772)), J.mul(7.0, v_s_1772), J.mul(9.0, v_s_1772)])
	var _t2328 = J.gp(J.gp(v_u_1769, "badge"), "col")
	J.sp(v_c_1768, "fillStyle", _t2328)
	J.mc(v_c_1768, "fillRect", [J.sub(v_bx_1777, J.mul(3.5, v_s_1772)), J.sub(v_by_1778, J.mul(3.0, v_s_1772)), J.mul(7.0, v_s_1772), J.mul(2.4, v_s_1772)])
	if J.cmp(J.gp(J.gp(v_u_1769, "badge"), "c"), 3.0, ">="):
		J.sp(v_c_1768, "fillStyle", "#ffd84a")
		J.mc(v_c_1768, "fillRect", [J.sub(v_bx_1777, J.mul(1.5, v_s_1772)), J.add(v_by_1778, J.mul(2.5, v_s_1772)), J.mul(3.0, v_s_1772), J.mul(2.5, v_s_1772)])
	J.mc(v_c_1768, "restore", [])

func _f347(this_, a: Array, env):
	var v_a_1802 = null; var v_b_1803 = null
	v_a_1802 = J.arg(a, 0)
	v_b_1803 = J.arg(a, 1)
	if J.cmp(v_b_1803, v_a_1802, "<="):
		return null
	if J.t(J.gp(env["__p"]["w"], "h")):
		J.mc(env["__p"]["__p"]["m"], "fillRect", [J.mul(v_a_1802, env["__p"]["__p"]["k"]), (J.mul(J.gp(env["__p"]["w"], "p"), env["__p"]["__p"]["k"]) - J.div(env["th"], 2.0)), J.mul(J.sub(v_b_1803, v_a_1802), env["__p"]["__p"]["k"]), env["th"]])
	else:
		J.mc(env["__p"]["__p"]["m"], "fillRect", [(J.mul(J.gp(env["__p"]["w"], "p"), env["__p"]["__p"]["k"]) - J.div(env["th"], 2.0)), J.mul(v_a_1802, env["__p"]["__p"]["k"]), env["th"], J.mul(J.sub(v_b_1803, v_a_1802), env["__p"]["__p"]["k"])])

func _f346(this_, a: Array, env):
	var v_W_1782 = null; var v_H_1783 = null; var v_ox_1784 = null; var v_oy_1785 = null; var v_big_1787 = null; var v_rs_1788 = null; var v_cw_1789 = null; var v_x0_1790 = null; var v_x1_1791 = null; var v_y0_1792 = null; var v_y1_1793 = null; var v_sz_1794 = null; var v_j_1795 = null; var v_i_1796 = null; var v_z_1797 = null; var v_cl_1798 = null; var v_seg_1801 = null; var v_t3_1804 = null; var v_f_1805 = null; var v_q_1806 = null; var v_sp_1807 = null; var v_t_1808 = null; var v_q_1809 = null; var v_main_1810 = null; var v_kd_1811 = null; var v_bigK_1812 = null; var v_b_1813 = null; var v_t_1814 = null; var v_sx_1815 = null; var v_sy_1816 = null; var v_n_1817 = null; var v_seen_1818 = null; var v_nm_1819 = null; var v_z_1820 = null; var v_c2_1821 = null; var v_sp_1822 = null
	var _s836 = {"__p": env, "m": null, "k": null}
	_s836["m"] = J.arg(a, 0)
	v_W_1782 = J.arg(a, 1)
	v_H_1783 = J.arg(a, 2)
	v_ox_1784 = J.arg(a, 3)
	v_oy_1785 = J.arg(a, 4)
	_s836["k"] = J.arg(a, 5)
	v_big_1787 = J.arg(a, 6)
	J.mc(_s836["m"], "clearRect", [0.0, 0.0, v_W_1782, v_H_1783])
	var _t2329 = _s836["m"]
	J.sp(_t2329, "fillStyle", "rgba(8,6,12,.92)")
	J.mc(_s836["m"], "fillRect", [0.0, 0.0, v_W_1782, v_H_1783])
	J.mc(_s836["m"], "save", [])
	J.mc(_s836["m"], "translate", [J.mul((-J.num(v_ox_1784)), _s836["k"]), J.mul((-J.num(v_oy_1785)), _s836["k"])])
	var _t2330 = _s836["__p"]["regSt"]
	v_rs_1788 = J.cl(_t2330, null, [J.gp(_s836["__p"]["R"], "ci")])
	v_cw_1789 = ceil(J.num(J.div(_s836["__p"]["WW"], _s836["__p"]["FOG"])))
	v_x0_1790 = J.max_([0.0, floor(J.num(J.div(v_ox_1784, _s836["__p"]["FOG"])))])
	v_x1_1791 = J.min_([v_cw_1789, ceil(J.num(J.div(J.add(v_ox_1784, J.div(v_W_1782, _s836["k"])), _s836["__p"]["FOG"])))])
	v_y0_1792 = J.max_([0.0, floor(J.num(J.div(v_oy_1785, _s836["__p"]["FOG"])))])
	v_y1_1793 = ceil(J.num(J.div(J.add(v_oy_1785, J.div(v_H_1783, _s836["k"])), _s836["__p"]["FOG"])))
	var _t2331 = _s836["m"]
	J.sp(_t2331, "fillStyle", "rgba(120,110,140,.45)")
	v_j_1795 = v_y0_1792
	while true:
		if not J.cmp(v_j_1795, v_y1_1793, "<"): break
		v_i_1796 = v_x0_1790
		while true:
			if not J.cmp(v_i_1796, v_x1_1791, "<"): break
			if J.seq(J.gp(J.gp(_s836["__p"]["R"], "fog"), J.add(J.mul(v_j_1795, v_cw_1789), v_i_1796)), "1"):
				J.mc(_s836["m"], "fillRect", [J.mul(J.mul(v_i_1796, _s836["__p"]["FOG"]), _s836["k"]), J.mul(J.mul(v_j_1795, _s836["__p"]["FOG"]), _s836["k"]), (J.mul(_s836["__p"]["FOG"], _s836["k"]) + 0.6), (J.mul(_s836["__p"]["FOG"], _s836["k"]) + 0.6)])
			v_i_1796 = J.num(v_i_1796) + 1.0
		v_j_1795 = J.num(v_j_1795) + 1.0
	v_z_1797 = 0.0
	while true:
		if not J.cmp(v_z_1797, J.mul(_s836["__p"]["COLS"], _s836["__p"]["ROWS"]), "<"): break
		var _t2332 = _s836["__p"]["zoneCell"]
		v_cl_1798 = J.cl(_t2332, null, [v_z_1797])
		var _t2333 = _s836["m"]
		var _t2335 = _s836["__p"]["TC"]
		var _t2334 = _s836["__p"]["terOf"]
		var _t2336 = J.gp(_t2335, J.cl(_t2334, null, [v_z_1797]))
		J.sp(_t2333, "fillStyle", _t2336)
		J.mc(_s836["m"], "fillRect", [J.mul(J.mul(J.gp(v_cl_1798, "c"), _s836["__p"]["CW"]), _s836["k"]), J.mul(J.mul(J.gp(v_cl_1798, "r"), _s836["__p"]["CH"]), _s836["k"]), (J.mul(_s836["__p"]["CW"], _s836["k"]) + 0.5), (J.mul(_s836["__p"]["CH"], _s836["k"]) + 0.5)])
		v_z_1797 = J.num(v_z_1797) + 1.0
	for _t2337 in J.iter(_s836["__p"]["WALLS"]):
		var _s841 = {"__p": _s836, "w": null}
		_s841["w"] = _t2337
		var _s842 = {"__p": _s841, "th": null}
		_s842["th"] = ((2.0 if J.seq(J.gp(_s842["__p"]["w"], "kind"), "border") else 1.3) * (1.6 if J.t(v_big_1787) else 1.0))
		var _t2338 = _s842["__p"]["__p"]["m"]
		var _t2339 = ("#0e2a24" if J.seq(J.gp(_s842["__p"]["w"], "kind"), "river") else "#000")
		J.sp(_t2338, "fillStyle", _t2339)
		v_seg_1801 = Callable(self, "_f347").bind(_s842)
		var _t2340 = J.gp(_s842["__p"]["w"], "gap")
		var _t2342 = (J.gp(J.gp(J.gp(_s842["__p"]["w"], "gap"), "g"), "sec") if J.t(_t2340) else _t2340)
		if J.t(_t2342):
			var _t2341 = _s842["__p"]["__p"]["__p"]["secFound"]
			_t2342 = (not J.t(J.cl(_t2341, null, [J.gp(J.gp(_s842["__p"]["w"], "gap"), "g")])))
		if J.t(_t2342):
			J.cl(v_seg_1801, null, [J.gp(_s842["__p"]["w"], "a"), J.gp(_s842["__p"]["w"], "b")])
			continue
		if J.t(J.gp(_s842["__p"]["w"], "gap")):
			J.cl(v_seg_1801, null, [J.gp(_s842["__p"]["w"], "a"), J.sub(J.gp(J.gp(_s842["__p"]["w"], "gap"), "c"), J.div(_s842["__p"]["__p"]["__p"]["GW"], 2.0))])
			J.cl(v_seg_1801, null, [J.add(J.gp(J.gp(_s842["__p"]["w"], "gap"), "c"), J.div(_s842["__p"]["__p"]["__p"]["GW"], 2.0)), J.gp(_s842["__p"]["w"], "b")])
			if J.t(J.gp(J.gp(J.gp(_s842["__p"]["w"], "gap"), "g"), "sec")):
				var _t2343 = _s842["__p"]["__p"]["m"]
				J.sp(_t2343, "fillStyle", "#7dffc0")
				J.mc(_s842["__p"]["__p"]["m"], "beginPath", [])
				J.mc(_s842["__p"]["__p"]["m"], "arc", [J.mul(J.gp(J.gp(J.gp(_s842["__p"]["w"], "gap"), "g"), "x"), _s842["__p"]["__p"]["k"]), J.mul(J.gp(J.gp(J.gp(_s842["__p"]["w"], "gap"), "g"), "y"), _s842["__p"]["__p"]["k"]), (4.0 if J.t(v_big_1787) else 2.0), 0.0, 7.0])
				J.mc(_s842["__p"]["__p"]["m"], "fill", [])
			else:
				var _t2344 = _s842["__p"]["__p"]["__p"]["gateOpen"]
				if (not J.t(J.cl(_t2344, null, [J.gp(J.gp(_s842["__p"]["w"], "gap"), "g")]))):
					var _t2345 = _s842["__p"]["__p"]["m"]
					J.sp(_t2345, "fillStyle", "#e84a5f")
					v_t3_1804 = (4.0 if J.t(v_big_1787) else 3.0)
					if J.t(J.gp(_s842["__p"]["w"], "h")):
						J.mc(_s842["__p"]["__p"]["m"], "fillRect", [J.mul(J.sub(J.gp(J.gp(_s842["__p"]["w"], "gap"), "c"), J.div(_s842["__p"]["__p"]["__p"]["GW"], 2.0)), _s842["__p"]["__p"]["k"]), (J.mul(J.gp(_s842["__p"]["w"], "p"), _s842["__p"]["__p"]["k"]) - J.div(v_t3_1804, 2.0)), J.mul(_s842["__p"]["__p"]["__p"]["GW"], _s842["__p"]["__p"]["k"]), v_t3_1804])
					else:
						J.mc(_s842["__p"]["__p"]["m"], "fillRect", [(J.mul(J.gp(_s842["__p"]["w"], "p"), _s842["__p"]["__p"]["k"]) - J.div(v_t3_1804, 2.0)), J.mul(J.sub(J.gp(J.gp(_s842["__p"]["w"], "gap"), "c"), J.div(_s842["__p"]["__p"]["__p"]["GW"], 2.0)), _s842["__p"]["__p"]["k"]), v_t3_1804, J.mul(_s842["__p"]["__p"]["__p"]["GW"], _s842["__p"]["__p"]["k"])])
		else:
			J.cl(v_seg_1801, null, [J.gp(_s842["__p"]["w"], "a"), J.gp(_s842["__p"]["w"], "b")])
	v_sz_1794 = (2.0 if J.t(v_big_1787) else 1.0)
	for _t2346 in J.iter(_s836["__p"]["FACI"]):
		v_f_1805 = _t2346
		var _t2347 = _s836["__p"]["faciPos"]
		v_q_1806 = J.cl(_t2347, null, [v_f_1805])
		var _t2348 = _s836["m"]
		var _t2349 = (("#3fa36a" if J.t(J.gp(J.gp(v_rs_1788, "sta"), J.gp(v_f_1805, "z"))) else "#666") if J.seq(J.gp(v_f_1805, "t"), "station") else ("#ffd69a" if J.seq(J.gp(v_f_1805, "t"), "tea") else ("#d8c8c8" if J.seq(J.gp(v_f_1805, "t"), "prison") else "#9cc8ff")))
		J.sp(_t2348, "fillStyle", _t2349)
		J.mc(_s836["m"], "fillRect", [(J.mul(J.gp(v_q_1806, "x"), _s836["k"]) - J.mul(2.0, v_sz_1794)), (J.mul(J.gp(v_q_1806, "y"), _s836["k"]) - J.mul(2.0, v_sz_1794)), J.mul(4.0, v_sz_1794), J.mul(4.0, v_sz_1794)])
	var _t2351 = J.gp(_s836["__p"]["R"], "spots")
	for _t2350 in J.iter((_t2351 if J.t(_t2351) else [])):
		v_sp_1807 = _t2350
		var _t2352 = J.seq(J.gp(v_sp_1807, "k"), "lm")
		if J.t((J.gp(J.gp(v_rs_1788, "lm"), J.gp(v_sp_1807, "id")) if _t2352 else _t2352)):
			var _t2353 = _s836["m"]
			J.sp(_t2353, "fillStyle", "#e8d29a")
			J.mc(_s836["m"], "save", [])
			J.mc(_s836["m"], "translate", [J.mul(J.gp(v_sp_1807, "x"), _s836["k"]), J.mul(J.gp(v_sp_1807, "y"), _s836["k"])])
			J.mc(_s836["m"], "rotate", [J.div(PI, 4.0)])
			J.mc(_s836["m"], "fillRect", [J.mul((-2.0), v_sz_1794), J.mul((-2.0), v_sz_1794), J.mul(4.0, v_sz_1794), J.mul(4.0, v_sz_1794)])
			J.mc(_s836["m"], "restore", [])
	v_t_1808 = 0.0
	while true:
		if not J.cmp(v_t_1808, 9.0, "<"): break
		var _t2354 = _s836["__p"]["kingDone"]
		if (not J.t(J.cl(_t2354, null, [v_t_1808]))):
			var _t2355 = _s836["__p"]["lairPos"]
			v_q_1809 = J.cl(_t2355, null, [v_t_1808])
			v_main_1810 = (not J.leq(J.gp(_s836["__p"]["TMAIN"], v_t_1808), null))
			var _t2356 = _s836["__p"]["kingDef"]
			var _t2357 = J.cl(_t2356, null, [v_t_1808])
			v_kd_1811 = (_t2357 if J.t(_t2357) else {})
			v_bigK_1812 = (J.seq(J.gp(_s836["__p"]["TMAIN"], v_t_1808), 2.0) if J.t(v_main_1810) else (not (not J.t(J.gp(v_kd_1811, "big")))))
			var _t2359 = J.gp(_s836["__p"]["TSECRET"], v_t_1808)
			if J.t(_t2359):
				var _t2358 = J.gp(J.gp(_s836["__p"]["R"], "fog"), (J.mul(floor(J.num(J.div(J.gp(v_q_1809, "y"), _s836["__p"]["FOG"]))), v_cw_1789) + floor(J.num(J.div(J.gp(v_q_1809, "x"), _s836["__p"]["FOG"])))))
				_t2359 = (not J.t(J.mc(_t2358, "includes", ["1"])))
			if J.t(_t2359):
				v_t_1808 = J.num(v_t_1808) + 1.0
				continue
			var _t2360 = _s836["m"]
			var _t2361 = ("#ff4a6a" if J.t(v_main_1810) else ("#7dffc0" if J.t(J.gp(v_kd_1811, "guard")) else "#c77dff"))
			J.sp(_t2360, "fillStyle", _t2361)
			J.mc(_s836["m"], "beginPath", [])
			J.mc(_s836["m"], "arc", [J.mul(J.gp(v_q_1809, "x"), _s836["k"]), J.mul(J.gp(v_q_1809, "y"), _s836["k"]), J.mul((3.5 if J.t(v_bigK_1812) else 2.6), v_sz_1794), 0.0, 7.0])
			J.mc(_s836["m"], "fill", [])
		v_t_1808 = J.num(v_t_1808) + 1.0
	if J.t(J.gp(_s836["__p"]["R"], "bryan")):
		v_b_1813 = J.gp(J.gp(_s836["__p"]["R"], "bryan"), 0.0)
		var _t2362 = _s836["m"]
		J.sp(_t2362, "fillStyle", "#ff6a6a")
		J.mc(_s836["m"], "fillRect", [(J.mul(J.gp(v_b_1813, "x"), _s836["k"]) - J.mul(1.5, v_sz_1794)), (J.mul(J.gp(v_b_1813, "y"), _s836["k"]) - J.mul(1.5, v_sz_1794)), J.mul(3.0, v_sz_1794), J.mul(3.0, v_sz_1794)])
	if J.t(v_big_1787):
		var _t2363 = _s836["m"]
		J.sp(_t2363, "textAlign", "center")
		var _t2364 = _s836["m"]
		var _t2365 = "900 13px \"PingFang TC\",\"Noto Sans TC\",sans-serif"
		J.sp(_t2364, "font", _t2365)
		v_t_1814 = 0.0
		while true:
			if not J.cmp(v_t_1814, 9.0, "<"): break
			v_sx_1815 = 0.0
			v_sy_1816 = 0.0
			v_n_1817 = 0.0
			v_seen_1818 = false
			v_z_1820 = 0.0
			while true:
				if not J.cmp(v_z_1820, J.mul(_s836["__p"]["COLS"], _s836["__p"]["ROWS"]), "<"): break
				var _t2366 = _s836["__p"]["terOf"]
				if J.seq(J.cl(_t2366, null, [v_z_1820]), v_t_1814):
					var _t2367 = _s836["__p"]["zoneCell"]
					v_c2_1821 = J.cl(_t2367, null, [v_z_1820])
					var _t2368 = J.add(v_sx_1815, J.gp(v_c2_1821, "x"))
					v_sx_1815 = _t2368
					var _t2369 = J.add(v_sy_1816, J.gp(v_c2_1821, "y"))
					v_sy_1816 = _t2369
					v_n_1817 = J.num(v_n_1817) + 1.0
					if J.seq(J.gp(J.gp(_s836["__p"]["R"], "fog"), (J.mul(floor(J.num(J.div(J.gp(v_c2_1821, "y"), _s836["__p"]["FOG"]))), v_cw_1789) + floor(J.num(J.div(J.gp(v_c2_1821, "x"), _s836["__p"]["FOG"]))))), "1"):
						v_seen_1818 = true
				v_z_1820 = J.num(v_z_1820) + 1.0
			var _t2370 = J.gp(_s836["__p"]["TSECRET"], v_t_1814)
			if J.t(((not J.t(v_seen_1818)) if J.t(_t2370) else _t2370)):
				v_t_1814 = J.num(v_t_1814) + 1.0
				continue
			var _t2371 = _s836["m"]
			var _t2372 = _s836["__p"]["kingDone"]
			var _t2373 = ("rgba(200,220,200,.75)" if J.t(J.cl(_t2372, null, [v_t_1814])) else "rgba(255,240,210,.92)")
			J.sp(_t2371, "fillStyle", _t2373)
			var _t2374 = _s836["m"]
			J.sp(_t2374, "strokeStyle", "rgba(0,0,0,.8)")
			var _t2375 = _s836["m"]
			J.sp(_t2375, "lineWidth", 3.0)
			v_nm_1819 = (J.gp(J.gp(_s836["__p"]["TNAME"], J.gp(_s836["__p"]["R"], "ci")), v_t_1814) if J.t(v_seen_1818) else "？？？")
			J.mc(_s836["m"], "strokeText", [v_nm_1819, J.mul(J.div(v_sx_1815, v_n_1817), _s836["k"]), (J.mul(J.div(v_sy_1816, v_n_1817), _s836["k"]) - 14.0)])
			J.mc(_s836["m"], "fillText", [v_nm_1819, J.mul(J.div(v_sx_1815, v_n_1817), _s836["k"]), (J.mul(J.div(v_sy_1816, v_n_1817), _s836["k"]) - 14.0)])
			v_t_1814 = J.num(v_t_1814) + 1.0
		var _t2376 = _s836["m"]
		var _t2377 = "700 10px \"PingFang TC\",\"Noto Sans TC\",sans-serif"
		J.sp(_t2376, "font", _t2377)
		var _t2379 = J.gp(_s836["__p"]["R"], "spots")
		for _t2378 in J.iter((_t2379 if J.t(_t2379) else [])):
			v_sp_1822 = _t2378
			var _t2380 = J.seq(J.gp(v_sp_1822, "k"), "lm")
			if J.t((J.gp(J.gp(v_rs_1788, "lm"), J.gp(v_sp_1822, "id")) if _t2380 else _t2380)):
				var _t2381 = _s836["m"]
				J.sp(_t2381, "fillStyle", "#e8d29a")
				var _t2382 = _s836["m"]
				J.sp(_t2382, "strokeStyle", "rgba(0,0,0,.8)")
				var _t2383 = _s836["m"]
				J.sp(_t2383, "lineWidth", 2.5)
				J.mc(_s836["m"], "strokeText", [J.gp(v_sp_1822, "name"), J.mul(J.gp(v_sp_1822, "x"), _s836["k"]), (J.mul(J.gp(v_sp_1822, "y"), _s836["k"]) + 13.0)])
				J.mc(_s836["m"], "fillText", [J.gp(v_sp_1822, "name"), J.mul(J.gp(v_sp_1822, "x"), _s836["k"]), (J.mul(J.gp(v_sp_1822, "y"), _s836["k"]) + 13.0)])
	var _t2384 = _s836["m"]
	J.sp(_t2384, "fillStyle", "#ffe9a0")
	J.mc(_s836["m"], "beginPath", [])
	J.mc(_s836["m"], "arc", [J.mul(J.gp(J.gp(_s836["__p"]["R"], "L"), "x"), _s836["k"]), J.mul(J.gp(J.gp(_s836["__p"]["R"], "L"), "y"), _s836["k"]), (5.0 if J.t(v_big_1787) else 3.0), 0.0, 7.0])
	J.mc(_s836["m"], "fill", [])
	var _t2385 = _s836["m"]
	J.sp(_t2385, "strokeStyle", "#000")
	var _t2386 = _s836["m"]
	J.sp(_t2386, "lineWidth", 1.5)
	J.mc(_s836["m"], "stroke", [])
	J.mc(_s836["m"], "restore", [])

func _f348(this_, a: Array, env):
	var v_m_1825 = null; var v_W_1826 = null; var v_H_1827 = null; var v_VWm_1828 = null; var v_k_1829 = null; var v_VHm_1830 = null; var v_ox_1831 = null; var v_oy_1832 = null
	if (not J.t(env["mini"])):
		return null
	v_m_1825 = J.mc(env["mini"], "getContext", ["2d"])
	v_W_1826 = J.gp(env["mini"], "width")
	v_H_1827 = J.gp(env["mini"], "height")
	v_VWm_1828 = 2600.0
	v_k_1829 = J.div(v_W_1826, v_VWm_1828)
	v_VHm_1830 = J.div(v_H_1827, v_k_1829)
	v_ox_1831 = J.max_([0.0, J.min_([J.sub(env["WW"], v_VWm_1828), J.sub(J.gp(J.gp(env["R"], "L"), "x"), J.div(v_VWm_1828, 2.0))])])
	v_oy_1832 = J.max_([0.0, J.min_([J.sub(env["WH"], v_VHm_1830), J.sub(J.gp(J.gp(env["R"], "L"), "y"), J.div(v_VHm_1830, 2.0))])])
	var _t2387 = env["drawMap"]
	J.cl(_t2387, null, [v_m_1825, v_W_1826, v_H_1827, v_ox_1831, v_oy_1832, v_k_1829, false])

func _f350(this_, a: Array, env):
	J.mc(env["d"], "remove", [])
	if J.t(env["__p"]["R"]):
		var _t2405 = env["__p"]["R"]
		J.sp(_t2405, "paused", false)

func _f349(this_, a: Array, env):
	var v_cvm_1836 = null; var v_wrap_1837 = null; var v_box_1838 = null; var v_k0_1839 = null; var v_dpr_1840 = null; var v_CWm_1841 = null; var v_CHm_1842 = null; var v_m_1843 = null; var v_close_1844 = null
	var _s863 = {"__p": env, "d": null}
	var _t2389 = (not J.t(_s863["__p"]["R"]))
	if not J.t(_t2389):
		var _t2388 = J.G.get("$")
		_t2389 = J.cl(_t2388, null, ["#pt-map"])
	if J.t(_t2389):
		return null
	_s863["d"] = J.S_document_("createElement", ["div"])
	var _t2390 = _s863["d"]
	J.sp(_t2390, "id", "pt-map")
	var _t2391 = _s863["d"]
	var _t2392 = ("<div class=\"pm-h\"><b>第" + J.str(J.gp("一二三四五六", J.gp(_s863["__p"]["R"], "ci"))) + "區・" + J.str(J.gp(J.gp(J.G.get("CHAPTERS"), J.gp(_s863["__p"]["R"], "ci")), "name")) + "</b><small>" + J.str(J.cl(_s863["__p"]["mapStat"], null, [])) + "</small><button class=\"btn sm\" id=\"pm-x\">返回</button></div><canvas></canvas><div class=\"pm-k\"><i style=\"background:#ff4a6a\"></i>主線　<i style=\"background:#c77dff\"></i>地頭王　<i style=\"background:#7dffc0\"></i>秘境／暗路　<i style=\"background:#e8d29a\"></i>地標　<i style=\"background:#3fa36a\"></i>地鐵站　<i style=\"background:#ffd69a\"></i>茶水間</div>")
	J.sp(_t2391, "innerHTML", _t2392)
	J.mc(_s863["__p"]["el"], "appendChild", [_s863["d"]])
	var _t2393 = _s863["__p"]["R"]
	J.sp(_t2393, "paused", true)
	v_cvm_1836 = J.mc(_s863["d"], "querySelector", ["canvas"])
	v_wrap_1837 = J.S_document_("createElement", ["div"])
	J.sp(v_wrap_1837, "className", "pm-w")
	J.mc(v_cvm_1836, "replaceWith", [v_wrap_1837])
	J.mc(v_wrap_1837, "appendChild", [v_cvm_1836])
	v_box_1838 = J.mc(v_wrap_1837, "getBoundingClientRect", [])
	v_k0_1839 = J.max_([J.div(J.gp(v_box_1838, "height"), _s863["__p"]["WH"]), J.div(J.gp(v_box_1838, "width"), _s863["__p"]["WW"])])
	var _t2394 = J.gp(J.G.get("window"), "devicePixelRatio")
	var _t2395 = J.gp(J.G.get("window"), "devicePixelRatio")
	v_dpr_1840 = J.min_([2.0, (_t2395 if J.t(_t2395) else 1.0)])
	v_CWm_1841 = J.mul(_s863["__p"]["WW"], v_k0_1839)
	v_CHm_1842 = J.mul(_s863["__p"]["WH"], v_k0_1839)
	var _t2396 = J.gp(v_cvm_1836, "style")
	var _t2397 = J.add(v_CWm_1841, "px")
	J.sp(_t2396, "width", _t2397)
	var _t2398 = J.gp(v_cvm_1836, "style")
	var _t2399 = J.add(v_CHm_1842, "px")
	J.sp(_t2398, "height", _t2399)
	var _t2400 = J.mul(v_CWm_1841, v_dpr_1840)
	J.sp(v_cvm_1836, "width", _t2400)
	var _t2401 = J.mul(v_CHm_1842, v_dpr_1840)
	J.sp(v_cvm_1836, "height", _t2401)
	v_m_1843 = J.mc(v_cvm_1836, "getContext", ["2d"])
	J.mc(v_m_1843, "scale", [v_dpr_1840, v_dpr_1840])
	var _t2402 = _s863["__p"]["drawMap"]
	J.cl(_t2402, null, [v_m_1843, v_CWm_1841, v_CHm_1842, 0.0, 0.0, v_k0_1839, true])
	var _t2403 = (J.mul(J.gp(J.gp(_s863["__p"]["R"], "L"), "x"), v_k0_1839) - J.div(J.gp(v_box_1838, "width"), 2.0))
	J.sp(v_wrap_1837, "scrollLeft", _t2403)
	var _t2404 = (J.mul(J.gp(J.gp(_s863["__p"]["R"], "L"), "y"), v_k0_1839) - J.div(J.gp(v_box_1838, "height"), 2.0))
	J.sp(v_wrap_1837, "scrollTop", _t2404)
	v_close_1844 = Callable(self, "_f350").bind(_s863)
	var _t2406 = J.mc(_s863["d"], "querySelector", ["#pm-x"])
	J.sp(_t2406, "onclick", v_close_1844)

func _f351(this_, a: Array, env):
	var v_rs_1847 = null; var v_kn_1848 = null
	var _t2407 = env["regSt"]
	v_rs_1847 = J.cl(_t2407, null, [J.gp(env["R"], "ci")])
	v_kn_1848 = J.len(J.mc(env["TALL"], "filter", [env["kingDone"]]))
	var _t2409 = J.len(J.S_Object_("keys", [J.gp(v_rs_1847, "lm")]))
	var _t2410 = J.len(J.gp(env["LMNAME"], J.gp(env["R"], "ci")))
	var _t2411 = J.len(J.S_Object_("keys", [J.gp(v_rs_1847, "pg")]))
	var _t2408 = env["pageGhosts"]
	return ("地頭 " + J.str(v_kn_1848) + "/9　地標 " + J.str(_t2409) + "/" + J.str(_t2410) + "　殘頁 " + J.str(_t2411) + "/" + J.str(J.len(J.cl(_t2408, null, [J.gp(env["R"], "ci")]))) + "　寶藏 " + J.str(J.len(J.S_Object_("keys", [J.gp(v_rs_1847, "ca")]))) + "/16　暗路 " + J.str(J.len(J.S_Object_("keys", [J.gp(v_rs_1847, "sg")]))) + "/5")

func _f353(this_, a: Array, env):
	var v_u_1865 = null
	v_u_1865 = J.arg(a, 0)
	var _t2433 = J.seq(J.gp(v_u_1865, "role"), "crew")
	return (J.cmp(J.gp(v_u_1865, "hp"), 0.0, ">") if _t2433 else _t2433)

func _f354(this_, a: Array, env):
	var v_u_1866 = null
	v_u_1866 = J.arg(a, 0)
	return J.seq(J.gp(v_u_1866, "role"), "crew")

func _f355(this_, a: Array, env):
	var v_f_1867 = null
	v_f_1867 = J.arg(a, 0)
	var _t2440 = J.gp(J.gp(env["__p"]["FAC"], v_f_1867), "col")
	var _t2441 = J.gp(J.gp(env["__p"]["FAC"], v_f_1867), "mat")
	var _t2439 = J.G.get("fmt")
	return ("<span style=\"color:" + J.str(_t2440) + "\">" + J.str(_t2441) + " " + J.str(J.cl(_t2439, null, [J.gp(J.gp(env["p"], "mats"), v_f_1867)])) + "</span>")

func _f356(this_, a: Array, env):
	var v_id_1870 = null; var v_cd_1871 = null; var v_max_1872 = null; var v_b_1873 = null
	v_id_1870 = J.arg(a, 0)
	v_cd_1871 = J.arg(a, 1)
	v_max_1872 = J.arg(a, 2)
	var _t2451 = J.G.get("$")
	v_b_1873 = J.cl(_t2451, null, [v_id_1870])
	if (not J.t(v_b_1873)):
		return null
	var _t2452 = J.gp(v_b_1873, "classList")
	J.mc(_t2452, "toggle", ["cd", J.cmp(v_cd_1871, 0.0, ">")])
	var _t2453 = J.gp(J.mc(v_b_1873, "querySelector", ["i"]), "style")
	var _t2454 = J.add(((J.div(v_cd_1871, v_max_1872) * 100.0) if J.cmp(v_cd_1871, 0.0, ">") else 0.0), "%")
	J.sp(_t2453, "height", _t2454)

func _f358(this_, a: Array, env):
	var v_x_1876 = null
	v_x_1876 = J.arg(a, 0)
	return J.seq(J.gp(v_x_1876, "gid"), J.gp(J.gp(env["b"], "dataset"), "lu"))

func _f357(this_, a: Array, env):
	var v_u_1875 = null
	var _s872 = {"__p": env, "b": null}
	_s872["b"] = J.arg(a, 0)
	var _t2460 = J.gp(_s872["__p"]["__p"]["R"], "units")
	v_u_1875 = J.mc(_t2460, "find", [Callable(self, "_f358").bind(_s872)])
	if (not J.t(v_u_1875)):
		return null
	var _t2461 = J.gp(_s872["b"], "classList")
	J.mc(_t2461, "toggle", ["dead", J.cmp(J.gp(v_u_1875, "hp"), 0.0, "<=")])
	var _t2462 = J.gp(_s872["b"], "classList")
	var _t2463 = J.cmp(J.gp(v_u_1875, "hp"), 0.0, ">")
	J.mc(_t2462, "toggle", ["ready", (J.cmp(J.gp(v_u_1875, "energy"), 100.0, ">=") if _t2463 else _t2463)])
	var _t2464 = J.gp(J.mc(_s872["b"], "querySelector", ["i"]), "style")
	var _t2467 = null
	if J.cmp(J.gp(v_u_1875, "hp"), 0.0, ">"):
		var _t2465 = J.gp(v_u_1875, "energy")
		var _t2466 = J.gp(v_u_1875, "energy")
		_t2467 = J.min_([100.0, (_t2466 if J.t(_t2466) else 0.0)])
	else:
		_t2467 = 0.0
	var _t2468 = J.add(_t2467, "%")
	J.sp(_t2464, "height", _t2468)

func _f352(this_, a: Array, env):
	var v_z_1852 = null; var v_ph_1853 = null; var v_hh_1854 = null; var v_mm_1855 = null; var v_a_1856 = null; var v_b_1857 = null; var v_c_1858 = null; var v_d_1859 = null; var v_r_1860 = null; var v_crew_1861 = null; var v_crewAll_1862 = null; var v_cdv_1863 = null; var v_ab_1864 = null; var v_v_1868 = null; var v_s_1869 = null
	var _s866 = {"__p": env, "p": null}
	if (not J.t(_s866["__p"]["R"])):
		return null
	_s866["p"] = J.cl(_s866["__p"]["st"], null, [])
	var _t2412 = _s866["__p"]["zoneAt"]
	v_z_1852 = J.cl(_t2412, null, [J.gp(J.gp(_s866["__p"]["R"], "L"), "x"), J.gp(J.gp(_s866["__p"]["R"], "L"), "y")])
	var _t2414 = _s866["__p"]["PH"]
	var _t2413 = _s866["__p"]["phase"]
	v_ph_1853 = J.gp(_t2414, J.cl(_t2413, null, [J.gp(_s866["p"], "min")]))
	v_hh_1854 = floor(J.num(J.div(J.gp(_s866["p"], "min"), 60.0)))
	v_mm_1855 = floor(J.num(J.mod(J.gp(_s866["p"], "min"), 60.0)))
	var _t2415 = J.G.get("$")
	v_a_1856 = J.cl(_t2415, null, ["#pt-reg"])
	var _t2416 = J.G.get("$")
	v_b_1857 = J.cl(_t2416, null, ["#pt-zone"])
	var _t2417 = J.G.get("$")
	v_c_1858 = J.cl(_t2417, null, ["#pt-clock"])
	var _t2418 = J.G.get("$")
	v_d_1859 = J.cl(_t2418, null, ["#pt-ph"])
	var _t2419 = J.G.get("$")
	v_r_1860 = J.cl(_t2419, null, ["#pt-res"])
	if (not J.t(v_a_1856)):
		return null
	var _t2420 = ("第" + J.str(J.gp("一二三四五六", J.gp(_s866["__p"]["R"], "ci"))) + "區・" + J.str(J.gp(J.gp(J.G.get("CHAPTERS"), J.gp(_s866["__p"]["R"], "ci")), "name")))
	J.sp(v_a_1856, "textContent", _t2420)
	var _t2421 = _s866["__p"]["zoneName"]
	var _t2424 = J.cl(_t2421, null, [J.gp(_s866["__p"]["R"], "ci"), v_z_1852])
	var _t2422 = _s866["__p"]["kingDone"]
	var _t2423 = _s866["__p"]["terOf"]
	var _t2425 = ("地頭・" + J.str(_t2424) + ("（已拿下）" if J.t(J.cl(_t2422, null, [J.cl(_t2423, null, [v_z_1852])])) else ""))
	J.sp(v_b_1857, "textContent", _t2425)
	var _t2426 = J.F_String([v_hh_1854])
	var _t2428 = J.mc(_t2426, "padStart", [2.0, "0"])
	var _t2427 = J.F_String([v_mm_1855])
	var _t2429 = (J.str(_t2428) + ":" + J.str(J.mc(_t2427, "padStart", [2.0, "0"])))
	J.sp(v_c_1858, "textContent", _t2429)
	var _t2430 = J.gp(v_ph_1853, "n")
	J.sp(v_d_1859, "textContent", _t2430)
	var _t2431 = J.gp(v_ph_1853, "d")
	J.sp(v_d_1859, "title", _t2431)
	var _t2432 = J.gp(_s866["__p"]["R"], "units")
	v_crew_1861 = J.len(J.mc(_t2432, "filter", [Callable(self, "_f353").bind(_s866)]))
	var _t2434 = J.gp(_s866["__p"]["R"], "units")
	v_crewAll_1862 = J.len(J.mc(_t2434, "filter", [Callable(self, "_f354").bind(_s866)]))
	var _t2435 = J.G.get("fmt")
	var _t2437 = J.cl(_t2435, null, [J.gp(J.gp(J.G.get("S"), "res"), "coins")])
	var _t2436 = J.G.get("fmt")
	var _t2443 = J.cl(_t2436, null, [J.gp(J.gp(J.G.get("S"), "res"), "buns")])
	var _t2438 = J.S_Object_("keys", [_s866["__p"]["FAC"]])
	var _t2442 = J.mc(_t2438, "map", [Callable(self, "_f355").bind(_s866)])
	var _t2446 = J.mc(_t2442, "join", [""])
	var _t2445 = null
	if J.cmp(J.gp(_s866["__p"]["R"], "streak"), 4.0, ">"):
		var _t2444 = (1.0 + J.min_([1.0, J.mul(J.gp(_s866["__p"]["R"], "streak"), 0.01)]))
		_t2445 = ("<span class=\"pt-str\">連巡 ×" + J.str(J.mc(_t2444, "toFixed", [2.0])) + "</span>")
	else:
		_t2445 = ""
	var _t2447 = ("<span>冥幣 " + J.str(_t2437) + "</span><span>壽包 " + J.str(_t2443) + "</span>" + J.str(_t2446) + "<span>部門 " + J.str(v_crew_1861) + "/" + J.str(v_crewAll_1862) + "</span>" + _t2445)
	J.sp(v_r_1860, "innerHTML", _t2447)
	if J.t(J.len(J.gp(_s866["__p"]["R"], "downs"))):
		v_v_1868 = J.gp(J.gp(_s866["__p"]["R"], "downs"), (J.len(J.gp(_s866["__p"]["R"], "downs")) - 1.0))
		var _t2448 = J.G.get("$")
		v_s_1869 = J.cl(_t2448, null, ["#pt-down .pd-t s"])
		if J.t(v_s_1869):
			var _t2449 = J.gp(v_s_1869, "style")
			var _t2450 = J.add(J.max_([0.0, (J.div(J.gp(v_v_1868, "down"), J.gp(v_v_1868, "downMax")) * 100.0)]), "%")
			J.sp(_t2449, "width", _t2450)
	v_cdv_1863 = Callable(self, "_f356").bind(_s866)
	var _t2455 = J.gp(_s866["__p"]["R"], "dashCd")
	J.cl(v_cdv_1863, null, ["#pt-dash", (_t2455 if J.t(_t2455) else 0.0), 3.5])
	var _t2456 = J.gp(_s866["__p"]["R"], "pieCd")
	J.cl(v_cdv_1863, null, ["#pt-pie", (_t2456 if J.t(_t2456) else 0.0), 30.0])
	var _t2457 = J.G.get("$")
	v_ab_1864 = J.cl(_t2457, null, ["#pt-sk-auto"])
	if J.t(v_ab_1864):
		var _t2458 = ("技能：手動" if J.seq(J.gp(J.cl(_s866["__p"]["st"], null, []), "autoSk"), false) else "技能：自動")
		J.sp(v_ab_1864, "textContent", _t2458)
	var _t2459 = J.S_document_("querySelectorAll", ["#pt-leads [data-lu]"])
	J.mc(_t2459, "forEach", [Callable(self, "_f357").bind(_s866)])

func _f2(this_, a: Array, env):
	var v_yue_197 = null; var v_zh_198 = null
	v_yue_197 = J.arg(a, 0)
	v_zh_198 = J.arg(a, 1)
	return (J.mc(J.G.get("GP"), "T", [v_yue_197, v_zh_198]) if (not J.seq(J.typeof_(J.G.get("GP")), "undefined")) else v_zh_198)

func _f4(this_, a: Array, env):
	var v_c_203 = null
	v_c_203 = J.arg(a, 0)
	return (J.sub(J.sub(env["COLS"], 1.0), v_c_203) if J.t(env["MIR"]) else v_c_203)

func _f23(this_, a: Array, env):
	var v_a_284 = null
	v_a_284 = J.arg(a, 0)
	var _t2469 = env["T"]
	return J.cl(_t2469, null, [J.gp(v_a_284, 0.0), J.gp(v_a_284, 1.0)])

func _f24(this_, a: Array, env):
	var v_x_285 = null
	v_x_285 = J.arg(a, 0)
	return (not J.seq(J.typeof_(v_x_285), "undefined"))

func _f29(this_, a: Array, env):
	var v_ci_302 = null; var v_si_303 = null
	v_ci_302 = J.arg(a, 0)
	v_si_303 = J.arg(a, 1)
	return (J.str(J.add(v_ci_302, 1.0)) + "-" + J.str(J.add(v_si_303, 1.0)))

func _f37(this_, a: Array, env):
	var _t2470 = J.gp(J.gp(J.G.get("S"), "bld"), "home")
	var _t2471 = J.gp(J.gp(J.G.get("S"), "bld"), "home")
	return J.min_([12.0, J.add(3.0, (_t2471 if J.t(_t2471) else 0.0))])

func _f38(this_, a: Array, env):
	var _t2472 = J.gp(J.gp(J.G.get("S"), "res"), "troops")
	var _t2473 = J.gp(J.gp(J.G.get("S"), "res"), "troops")
	return J.min_([4.0, floor(J.num(J.div((_t2473 if J.t(_t2473) else 0.0), 25.0)))])

func _f359(this_, a: Array, env):
	return env["active"]

func _f360(this_, a: Array, env):
	return env["R"]

func _f361(this_, a: Array, env):
	return (J.gp(env["R"], "spots") if J.t(env["R"]) else [])

func _f363(this_, a: Array, env):
	var v_name_1880 = null; var v_id_1881 = null
	v_name_1880 = J.arg(a, 0)
	v_id_1881 = J.arg(a, 1)
	var _t2475 = env["__p"]["regSt"]
	return {"id": v_id_1881, "name": v_name_1880, "found": (not (not J.t(J.gp(J.gp(J.cl(_t2475, null, [env["ci"]]), "lm"), v_id_1881))))}

func _f362(this_, a: Array, env):
	var _s877 = {"__p": env, "ci": null}
	_s877["ci"] = J.arg(a, 0)
	var _t2474 = J.gp(_s877["__p"]["LMNAME"], _s877["ci"])
	return J.mc(_t2474, "map", [Callable(self, "_f363").bind(_s877)])

func _f364(this_, a: Array, env):
	var v_e_1882 = null; var v_f_1883 = null
	v_e_1882 = J.arg(a, 0)
	v_f_1883 = J.arg(a, 1)
	var _t2476 = env["HOOK"]
	var _t2477 = J.gp(env["HOOK"], v_e_1882)
	var _t2478 = (_t2477 if J.t(_t2477) else [])
	J.sp(_t2476, v_e_1882, _t2478)
	J.mc(_t2478, "push", [v_f_1883])

func _f366(this_, a: Array, env):
	var v_g_1884 = null
	v_g_1884 = J.arg(a, 0)
	var _t2480 = J.gp(v_g_1884, "x")
	var _t2481 = J.gp(v_g_1884, "y")
	var _t2482 = J.gp(v_g_1884, "vert")
	var _t2479 = env["gateOpen"]
	return {"x": _t2480, "y": _t2481, "vert": _t2482, "open": J.cl(_t2479, null, [v_g_1884])}

func _f367(this_, a: Array, env):
	var v_t_1885 = null
	v_t_1885 = J.arg(a, 0)
	var _t2483 = env["lairPos"]
	var _t2485 = J.cl(_t2483, null, [v_t_1885])
	var _t2484 = env["kingDone"]
	var _t2486 = {}
	J.assign(_t2486, [_t2485])
	_t2486["done"] = J.cl(_t2484, null, [v_t_1885])
	return _t2486

func _f368(this_, a: Array, env):
	var v_f_1886 = null
	v_f_1886 = J.arg(a, 0)
	var _t2488 = J.gp(v_f_1886, "t")
	var _t2487 = env["faciPos"]
	var _t2489 = {}
	_t2489["t"] = _t2488
	J.assign(_t2489, [J.cl(_t2487, null, [v_f_1886])])
	return _t2489

func _f370(this_, a: Array, env):
	var v_v_1889 = null; var v_c_1890 = null
	v_v_1889 = J.arg(a, 0)
	v_c_1890 = J.arg(a, 1)
	var _t2490 = env["__p"]["terAt"]
	return J.cl(_t2490, null, [env["ri"], v_c_1890])

func _f369(this_, a: Array, env):
	var v_r_1887 = null
	var _s884 = {"__p": env, "ri": null}
	v_r_1887 = J.arg(a, 0)
	_s884["ri"] = J.arg(a, 1)
	return J.mc(v_r_1887, "map", [Callable(self, "_f370").bind(_s884)])

func _f371(this_, a: Array, env):
	var v_p_1891 = null
	v_p_1891 = J.arg(a, 0)
	return J.gp(v_p_1891, "r")

func _f372(this_, a: Array, env):
	var v_p_1892 = null
	v_p_1892 = J.arg(a, 0)
	return [J.bor(J.gp(v_p_1892, "x"), 0.0), J.bor(J.gp(v_p_1892, "y"), 0.0), J.bor(J.gp(v_p_1892, "r"), 0.0)]

func _f365(this_, a: Array, env):
	var _t2493 = env["WALLS"]
	var _t2494 = J.mc(env["GATES"], "map", [Callable(self, "_f366").bind(env)])
	var _t2495 = J.mc(env["TALL"], "map", [Callable(self, "_f367").bind(env)])
	var _t2496 = J.mc(env["FACI"], "map", [Callable(self, "_f368").bind(env)])
	var _t2497 = J.mc(env["TLAY"], "map", [Callable(self, "_f369").bind(env)])
	var _t2491 = J.gp(env["R"], "props")
	var _t2492 = J.mc(_t2491, "filter", [Callable(self, "_f371").bind(env)])
	return {"walls": _t2493, "gates": _t2494, "lairs": _t2495, "faci": _t2496, "ter": _t2497, "props": J.mc(_t2492, "map", [Callable(self, "_f372").bind(env)]), "path": J.gp(env["R"], "path"), "spots": J.gp(env["R"], "spots"), "W": env["WW"], "H": env["WH"], "CW": env["CW"], "CH": env["CH"]}

func _f1(this_, a: Array, env):
	var _s2 = {"__p": env, "T": null, "CW": null, "CH": null, "COLS": null, "ROWS": null, "WW": null, "WH": null, "VIEW": null, "FOG": null, "FAC": null, "FAC_OF": null, "facOf": null, "REG": null, "CH_FOD": null, "TLAY": null, "TGATE": null, "TLAIR": null, "TMAIN": null, "TSECRET": null, "TALL": null, "TNAME": null, "LM_N": null, "LMNAME": null, "TKING": null, "TTIER": null, "MIR": null, "mc": null, "terAt": null, "zoneCell": null, "zoneAt": null, "terOf": null, "terAtXY": null, "terP": null, "zoneP": null, "zoneName": null, "lairPos": null, "guardPos": null, "gateList": null, "GATES": null, "GW": null, "kingDone": null, "gateOpen": null, "secFound": null, "FACI0": null, "FACI": null, "mkFaci": null, "TEA_CD": null, "DOWN_T": null, "MEET": null, "D": null, "has": null, "st": null, "regSt": null, "startZ": null, "staName": null, "sidOf": null, "regionOpen": null, "faciPos": null, "elitesOf": null, "eliteOfZone": null, "fodOf": null, "phase": null, "PH": null, "crewCap": null, "troopTeams": null, "crewList": null, "leads": null, "restRecover": null, "R": null, "unitFromGhost": null, "CLOTH": null, "wReg": null, "regWeapons": null, "equip": null, "troopUnit": null, "foe": null, "seeded": null, "mkPattern": null, "SOLID": null, "PGRID": null, "WALLS": null, "keyPts": null, "segD": null, "blockedAt": null, "mkWalls": null, "R0WALK": null, "kingDef": null, "pageGhosts": null, "mkSpots": null, "HOOK": null, "emit": null, "spotTick": null, "drawSpots": null, "mkProps": null, "drawProp": null, "intro": null, "openPrep": null, "prepHTML": null, "bindPrep": null, "pickLead": null, "start": null, "begin": null, "formation": null, "active": null, "el": null, "cv": null, "ctx": null, "mini": null, "raf": null, "last": null, "mount": null, "resize": null, "frame": null, "moveTo": null, "revealAround": null, "spawnZone": null, "spawnGuards": null, "spawnKing": null, "kingWin": null, "spawnBryan": null, "ACC": null, "RING": null, "ATK": null, "approachV": null, "steer": null, "integrate": null, "wander": null, "update": null, "nearest": null, "provoke": null, "startAttack": null, "tickAct": null, "projCol": null, "fire": null, "later": null, "foesNear": null, "wfire": null, "hit": null, "telegraph": null, "skill": null, "dash": null, "pie": null, "spark": null, "TINT": null, "fxImg": null, "spr": null, "drawSpr": null, "HUE": null, "dust": null, "ambient": null, "fxText": null, "msg": null, "onDown": null, "signInfo": null, "soulDrop": null, "gain": null, "resolveDown": null, "addCrew": null, "downUI": null, "stationCost": null, "matTotal": null, "payMat": null, "facilities": null, "teleport": null, "useFaci": null, "stageWin": null, "persist": null, "end": null, "close": null, "PROP": null, "PAT": null, "groundPat": null, "pathPts": null, "drawPath": null, "drawWall": null, "drawLair": null, "drawPropImg": null, "LC": null, "draw": null, "drawProj": null, "vis": null, "IMG": null, "img": null, "drawFaci": null, "drawUnit": null, "drawCloth": null, "drawWeapon": null, "drawBadge": null, "TC": null, "drawMap": null, "drawMini": null, "openMap": null, "mapStat": null, "hud": null}
	_s2["facOf"] = Callable(self, "_f3").bind(_s2)
	_s2["terAt"] = Callable(self, "_f5").bind(_s2)
	_s2["zoneCell"] = Callable(self, "_f6").bind(_s2)
	_s2["zoneAt"] = Callable(self, "_f7").bind(_s2)
	_s2["terOf"] = Callable(self, "_f8").bind(_s2)
	_s2["terAtXY"] = Callable(self, "_f9").bind(_s2)
	_s2["terP"] = Callable(self, "_f10").bind(_s2)
	_s2["zoneP"] = Callable(self, "_f11").bind(_s2)
	_s2["zoneName"] = Callable(self, "_f12").bind(_s2)
	_s2["lairPos"] = Callable(self, "_f13").bind(_s2)
	_s2["guardPos"] = Callable(self, "_f14").bind(_s2)
	_s2["gateList"] = Callable(self, "_f16").bind(_s2)
	_s2["kingDone"] = Callable(self, "_f18").bind(_s2)
	_s2["gateOpen"] = Callable(self, "_f19").bind(_s2)
	_s2["secFound"] = Callable(self, "_f20").bind(_s2)
	_s2["mkFaci"] = Callable(self, "_f21").bind(_s2)
	_s2["st"] = Callable(self, "_f25").bind(_s2)
	_s2["regSt"] = Callable(self, "_f26").bind(_s2)
	_s2["startZ"] = Callable(self, "_f27").bind(_s2)
	_s2["staName"] = Callable(self, "_f28").bind(_s2)
	_s2["regionOpen"] = Callable(self, "_f30").bind(_s2)
	_s2["faciPos"] = Callable(self, "_f31").bind(_s2)
	_s2["elitesOf"] = Callable(self, "_f32").bind(_s2)
	_s2["eliteOfZone"] = Callable(self, "_f34").bind(_s2)
	_s2["fodOf"] = Callable(self, "_f35").bind(_s2)
	_s2["phase"] = Callable(self, "_f36").bind(_s2)
	_s2["crewList"] = Callable(self, "_f39").bind(_s2)
	_s2["leads"] = Callable(self, "_f42").bind(_s2)
	_s2["restRecover"] = Callable(self, "_f45").bind(_s2)
	_s2["unitFromGhost"] = Callable(self, "_f47").bind(_s2)
	_s2["regWeapons"] = Callable(self, "_f48").bind(_s2)
	_s2["equip"] = Callable(self, "_f51").bind(_s2)
	_s2["troopUnit"] = Callable(self, "_f52").bind(_s2)
	_s2["foe"] = Callable(self, "_f53").bind(_s2)
	_s2["seeded"] = Callable(self, "_f54").bind(_s2)
	_s2["mkPattern"] = Callable(self, "_f56").bind(_s2)
	_s2["keyPts"] = Callable(self, "_f57").bind(_s2)
	_s2["segD"] = Callable(self, "_f59").bind(_s2)
	_s2["blockedAt"] = Callable(self, "_f60").bind(_s2)
	_s2["mkWalls"] = Callable(self, "_f62").bind(_s2)
	_s2["kingDef"] = Callable(self, "_f72").bind(_s2)
	_s2["pageGhosts"] = Callable(self, "_f75").bind(_s2)
	_s2["mkSpots"] = Callable(self, "_f78").bind(_s2)
	_s2["emit"] = Callable(self, "_f88").bind(_s2)
	_s2["spotTick"] = Callable(self, "_f90").bind(_s2)
	_s2["drawSpots"] = Callable(self, "_f91").bind(_s2)
	_s2["mkProps"] = Callable(self, "_f92").bind(_s2)
	_s2["drawProp"] = Callable(self, "_f99").bind(_s2)
	_s2["intro"] = Callable(self, "_f101").bind(_s2)
	_s2["openPrep"] = Callable(self, "_f102").bind(_s2)
	_s2["prepHTML"] = Callable(self, "_f106").bind(_s2)
	_s2["bindPrep"] = Callable(self, "_f118").bind(_s2)
	_s2["pickLead"] = Callable(self, "_f127").bind(_s2)
	_s2["start"] = Callable(self, "_f134").bind(_s2)
	_s2["begin"] = Callable(self, "_f138").bind(_s2)
	_s2["formation"] = Callable(self, "_f144").bind(_s2)
	_s2["mount"] = Callable(self, "_f145").bind(_s2)
	_s2["resize"] = Callable(self, "_f162").bind(_s2)
	_s2["frame"] = Callable(self, "_f163").bind(_s2)
	_s2["moveTo"] = Callable(self, "_f164").bind(_s2)
	_s2["revealAround"] = Callable(self, "_f165").bind(_s2)
	_s2["spawnZone"] = Callable(self, "_f166").bind(_s2)
	_s2["spawnGuards"] = Callable(self, "_f175").bind(_s2)
	_s2["spawnKing"] = Callable(self, "_f177").bind(_s2)
	_s2["kingWin"] = Callable(self, "_f180").bind(_s2)
	_s2["spawnBryan"] = Callable(self, "_f186").bind(_s2)
	_s2["approachV"] = Callable(self, "_f188").bind(_s2)
	_s2["steer"] = Callable(self, "_f189").bind(_s2)
	_s2["integrate"] = Callable(self, "_f190").bind(_s2)
	_s2["wander"] = Callable(self, "_f191").bind(_s2)
	_s2["update"] = Callable(self, "_f192").bind(_s2)
	_s2["nearest"] = Callable(self, "_f221").bind(_s2)
	_s2["provoke"] = Callable(self, "_f222").bind(_s2)
	_s2["startAttack"] = Callable(self, "_f225").bind(_s2)
	_s2["tickAct"] = Callable(self, "_f226").bind(_s2)
	_s2["projCol"] = Callable(self, "_f227").bind(_s2)
	_s2["fire"] = Callable(self, "_f228").bind(_s2)
	_s2["later"] = Callable(self, "_f229").bind(_s2)
	_s2["foesNear"] = Callable(self, "_f230").bind(_s2)
	_s2["wfire"] = Callable(self, "_f232").bind(_s2)
	_s2["hit"] = Callable(self, "_f251").bind(_s2)
	_s2["telegraph"] = Callable(self, "_f252").bind(_s2)
	_s2["skill"] = Callable(self, "_f253").bind(_s2)
	_s2["dash"] = Callable(self, "_f260").bind(_s2)
	_s2["pie"] = Callable(self, "_f261").bind(_s2)
	_s2["spark"] = Callable(self, "_f262").bind(_s2)
	_s2["fxImg"] = Callable(self, "_f263").bind(_s2)
	_s2["spr"] = Callable(self, "_f264").bind(_s2)
	_s2["drawSpr"] = Callable(self, "_f265").bind(_s2)
	_s2["dust"] = Callable(self, "_f266").bind(_s2)
	_s2["ambient"] = Callable(self, "_f267").bind(_s2)
	_s2["fxText"] = Callable(self, "_f268").bind(_s2)
	_s2["msg"] = Callable(self, "_f269").bind(_s2)
	_s2["onDown"] = Callable(self, "_f271").bind(_s2)
	_s2["signInfo"] = Callable(self, "_f272").bind(_s2)
	_s2["soulDrop"] = Callable(self, "_f275").bind(_s2)
	_s2["gain"] = Callable(self, "_f276").bind(_s2)
	_s2["resolveDown"] = Callable(self, "_f277").bind(_s2)
	_s2["addCrew"] = Callable(self, "_f280").bind(_s2)
	_s2["downUI"] = Callable(self, "_f284").bind(_s2)
	_s2["stationCost"] = Callable(self, "_f287").bind(_s2)
	_s2["matTotal"] = Callable(self, "_f288").bind(_s2)
	_s2["payMat"] = Callable(self, "_f289").bind(_s2)
	_s2["facilities"] = Callable(self, "_f291").bind(_s2)
	_s2["teleport"] = Callable(self, "_f298").bind(_s2)
	_s2["useFaci"] = Callable(self, "_f300").bind(_s2)
	_s2["stageWin"] = Callable(self, "_f303").bind(_s2)
	_s2["persist"] = Callable(self, "_f309").bind(_s2)
	_s2["end"] = Callable(self, "_f310").bind(_s2)
	_s2["close"] = Callable(self, "_f313").bind(_s2)
	_s2["groundPat"] = Callable(self, "_f314").bind(_s2)
	_s2["pathPts"] = Callable(self, "_f315").bind(_s2)
	_s2["drawPath"] = Callable(self, "_f319").bind(_s2)
	_s2["drawWall"] = Callable(self, "_f321").bind(_s2)
	_s2["drawLair"] = Callable(self, "_f323").bind(_s2)
	_s2["drawPropImg"] = Callable(self, "_f324").bind(_s2)
	_s2["draw"] = Callable(self, "_f325").bind(_s2)
	_s2["drawProj"] = Callable(self, "_f335").bind(_s2)
	_s2["vis"] = Callable(self, "_f336").bind(_s2)
	_s2["img"] = Callable(self, "_f337").bind(_s2)
	_s2["drawFaci"] = Callable(self, "_f338").bind(_s2)
	_s2["drawUnit"] = Callable(self, "_f340").bind(_s2)
	_s2["drawCloth"] = Callable(self, "_f342").bind(_s2)
	_s2["drawWeapon"] = Callable(self, "_f343").bind(_s2)
	_s2["drawBadge"] = Callable(self, "_f345").bind(_s2)
	_s2["drawMap"] = Callable(self, "_f346").bind(_s2)
	_s2["drawMini"] = Callable(self, "_f348").bind(_s2)
	_s2["openMap"] = Callable(self, "_f349").bind(_s2)
	_s2["mapStat"] = Callable(self, "_f351").bind(_s2)
	_s2["hud"] = Callable(self, "_f352").bind(_s2)
	_s2["T"] = Callable(self, "_f2").bind(_s2)
	_s2["CW"] = 800.0
	_s2["CH"] = 700.0
	_s2["COLS"] = 9.0
	_s2["ROWS"] = 7.0
	_s2["WW"] = J.mul(_s2["CW"], _s2["COLS"])
	_s2["WH"] = J.mul(_s2["CH"], _s2["ROWS"])
	_s2["VIEW"] = 400.0
	_s2["FOG"] = 100.0
	_s2["FAC"] = {"yuan": {"name": "怨靈系", "mat": "怨念", "col": "#c890ff", "d": "高輸出、脆"}, "chan": {"name": "餓鬼系", "mat": "饞念", "col": "#ffb85a", "d": "吸血、越打越勇"}, "lan": {"name": "躺平系", "mat": "懶念", "col": "#8fd0ff", "d": "肉厚、拖慢敵人"}}
	_s2["FAC_OF"] = {"youhun": "lan", "zhiren": "yuan", "egui": "chan", "xiaogui": "yuan", "zombie": "lan", "shuigui": "yuan", "niutou": "lan", "mamian": "chan", "eguiking": "chan", "toyol": "chan", "laojiang": "lan", "pontianak": "yuan", "pocong": "lan", "penanggal": "yuan", "baiwu": "yuan", "heiwu": "lan", "huang": "chan", "xiaozhi": "yuan", "mengpo": "chan", "tianhua": "yuan", "afu": "lan"}
	_s2["REG"] = [{"site": "field", "g0": "#1e2219", "g1": "#2b3021", "props": ["tomb", "tomb", "tree", "lantern", "rock", "grass", "grass"]}, {"site": "kampung", "g0": "#1c2318", "g1": "#28331f", "props": ["stilt", "palm", "palm", "well", "bush", "bush2", "grass"]}, {"site": "road", "g0": "#231f1b", "g1": "#312a22", "props": ["lamp", "cart", "stone", "rock2", "tomb", "grass", "tree"]}, {"site": "banana", "g0": "#18241c", "g1": "#223325", "props": ["banana", "banana", "pond", "hut", "fern", "grass", "lantern"]}, {"site": "death", "g0": "#211b1e", "g1": "#2e2328", "props": ["slamp", "cone", "bus", "scooter", "rock", "grass"]}, {"site": "night", "g0": "#1b1a24", "g1": "#262433", "props": ["pillar", "cabinet", "plant", "cooler", "pillar", "grass"]}]
	_s2["CH_FOD"] = [["youhun", "egui"], ["xiaogui"], ["zombie"], ["shuigui"], ["zhiren"], ["niutou", "mamian"]]
	_s2["TLAY"] = [[6.0, 6.0, 3.0, 3.0, 3.0, 4.0, 4.0, 5.0, 5.0], [6.0, 6.0, 3.0, 3.0, 4.0, 4.0, 4.0, 5.0, 5.0], [7.0, 3.0, 3.0, 3.0, 4.0, 4.0, 8.0, 5.0, 5.0], [7.0, 7.0, 1.0, 1.0, 1.0, 8.0, 8.0, 8.0, 5.0], [0.0, 7.0, 1.0, 1.0, 1.0, 2.0, 8.0, 2.0, 2.0], [0.0, 0.0, 1.0, 1.0, 2.0, 2.0, 2.0, 2.0, 2.0], [0.0, 0.0, 0.0, 1.0, 1.0, 2.0, 2.0, 2.0, 2.0]]
	_s2["TGATE"] = [[0.0, 1.0, [5.0, 1.0], [5.0, 2.0]], [1.0, 2.0, [6.0, 4.0], [6.0, 5.0]], [1.0, 3.0, [3.0, 2.0], [2.0, 2.0]], [3.0, 4.0, [1.0, 3.0], [1.0, 4.0]], [2.0, 5.0, [4.0, 8.0], [3.0, 8.0]], [4.0, 5.0, [1.0, 6.0], [1.0, 7.0]], [0.0, 7.0, [4.0, 0.0], [3.0, 0.0], 1.0], [7.0, 1.0, [4.0, 1.0], [4.0, 2.0], 1.0], [3.0, 6.0, [1.0, 2.0], [1.0, 1.0], 1.0], [2.0, 8.0, [4.0, 7.0], [3.0, 7.0], 1.0], [8.0, 4.0, [2.0, 6.0], [2.0, 5.0], 1.0]]
	_s2["TLAIR"] = [[4.0, 0.0], [4.0, 3.0], [5.0, 7.0], [0.0, 3.0], [0.0, 6.0], [0.0, 8.0], [0.0, 0.0], [3.0, 0.0], [3.0, 6.0]]
	_s2["TMAIN"] = {"1": 0.0, "3": 1.0, "5": 2.0}
	_s2["TSECRET"] = {"6": 1.0, "7": 1.0, "8": 1.0}
	_s2["TALL"] = [0.0, 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0]
	_s2["TNAME"] = [["村口槐樹頭", "槐林邊", "老磚窰", "包子鋪後巷", "亂葬崗北", "餓鬼王大宅", "枯井底", "廢蒸籠倉", "無主孤墳"], ["甘榜入口", "甘榜小路", "椰林深處", "高腳屋下", "舊膠園", "Toyol 老窩", "老榴槤園", "水稻田邊", "紅毛丹果園"], ["古道驛站", "南下的屍隊", "斷橋渡口", "跳過國境線", "荒廢客棧", "老殭棺材鋪", "義莊後院", "霧谷", "採藥人山洞"], ["河口", "河邊", "紅樹林", "香蕉園", "舊水閘", "Pontianak 香蕉樹", "漁村廢屋", "鱷魚灘", "舊碼頭"], ["巴士站", "村口的白布", "十字路口", "舊組屋", "高架橋底", "Penanggal 屋頂", "廢停車場", "夜市後巷", "舊戲院"], ["集團停車場", "集團大門", "檔案室", "黑白無常值班室", "董事會走廊", "頂樓・黃總", "員工天台", "地庫機房", "員工休息室"]]
	_s2["LM_N"] = [2.0, 3.0, 4.0, 3.0, 2.0, 2.0, 1.0, 1.0, 2.0]
	_s2["LMNAME"] = [["斷頭石磨", "歪脖子槐樹", "吊燈籠小徑", "掉牙石獅", "半塌牛棚", "熄火窰口", "燒焦磚堆", "窰工宿舍", "煙囪殘骸", "隔夜包子籠", "後巷垃圾站", "掛滿收據嘅晾衫架", "無字碑林", "狗吠坡", "大宅後廚", "空米缸房", "井底舊水桶", "疊到天花嘅蒸籠", "倒地紙紮屋", "長草土堆"], ["生鏽腳車棚", "村口雜貨店", "晾紗籠竹竿", "斷咗嘅木橋", "雞寮", "倒椰樹", "椰殼山", "舊抽水機", "樹頂樹屋", "屋底鞦韆", "舊米缸", "屋底舊沙發", "割膠刀架", "一排膠汁杯", "玩具山", "偷返嚟嘅錢罌", "榴槤殼山", "稻草人", "果園工寮", "倒瀉嘅果籃"], ["驛站馬槽", "驛站告示板", "一排腳印", "掉低嘅草鞋", "竹竿擔架", "斷橋橋墩", "擺渡竹筏", "渡口茶寮", "纜繩樁", "界碑", "生鏽邊境閘", "換錢攤", "客棧馬房", "二樓爛窗", "棺材山", "鋸木枱", "停棺長廊", "霧中石凳", "洞口草藥架", "熄咗嘅火堆"], ["河口漁排", "翻轉小艇", "洗衫石", "河邊高腳亭", "釣魚凳", "紅樹根迷宮", "螢火蟲灣", "泥灘蟹洞", "擱淺木船", "香蕉寮", "斬開嘅蕉樹", "蕉葉堆", "生鏽閘門", "水位尺", "最大嗰棵蕉樹", "樹下紅鞋", "吊網屋", "鱷魚曬太陽石", "斷咗嘅碼頭", "貨箱山"], ["冇巴士嘅站牌", "爛候車椅", "掛住白布嘅籬笆", "晾衫場", "跳住走嘅腳印", "壞咗嘅紅綠燈", "路口宵夜檔", "倒地路牌", "斑馬線", "停咗嘅升降機", "走廊鞋架", "天台水缸", "橋底塗鴉牆", "紙皮屋", "屋頂天線", "晾腸架", "冇車嘅車位", "收咗檔嘅推車", "售票窗", "爛海報牆"], ["總裁專用車位", "收費閘", "打卡機", "保安亭", "旋轉門", "碎紙機牆", "檔案山", "影印機房", "遺失物箱", "交更白板", "值班床", "茶包山", "歷任董事油畫", "KPI 大螢幕", "黃總辦公枱", "落地玻璃窗", "煙頭花盆", "嗡嗡響嘅伺服器", "睡袋堆", "冇咗插頭嘅咖啡機"]]
	_s2["TKING"] = [{"0": {"small": "n30_qionggui"}, "2": {"big": "n30_taozhai", "small": "n30_guhangui"}, "4": {"big": "pg_tuimo", "small": "n30_dugui"}}, {"0": {"small": "n30_pelesit"}, "2": {"big": "n30_hanturaya", "small": "n30_polong"}, "4": {"big": "n30_hantugalah", "small": "n30_jenglot"}}, {"0": {"small": "n30_wutou"}, "2": {"big": "n30_shanxiao", "small": "n30_changgui"}, "4": {"big": "pg_songding", "small": "n30_baigujing"}}, {"0": {"small": "n30_phiam"}, "2": {"big": "n30_maenak", "small": "n30_churel"}, "4": {"big": "pg_ex", "small": "n30_tikbalang"}}, {"0": {"small": "n30_zipai"}, "2": {"big": "pg_landlady", "small": "n30_zhongshu"}, "4": {"big": "n30_chehuo", "small": "n30_daji"}}, {"0": {"small": "n30_kasaobake"}, "2": {"big": "pg_ji", "small": "n30_nopperabo"}, "4": {"big": "n30_hannya", "small": "n30_rokurokubi"}}]
	_s2["TTIER"] = [0.15, 0.3, 0.45, 0.6, 0.75, 1.0, 0.85, 0.4, 0.7]
	_s2["MIR"] = false
	_s2["mc"] = Callable(self, "_f4").bind(_s2)
	_s2["GATES"] = []
	_s2["GW"] = 220.0
	_s2["FACI0"] = [["station", 6.0, 0.0, (-170.0), 120.0], ["tea", 5.0, 1.0, 150.0, 100.0], ["station", 4.0, 4.0, (-120.0), 150.0], ["tea", 6.0, 3.0, 0.0, (-150.0)], ["station", 5.0, 6.0, 120.0, (-140.0)], ["tea", 6.0, 7.0, (-150.0), 120.0], ["prison", 5.0, 5.0, 0.0, 150.0], ["tea", 3.0, 4.0, 150.0, (-120.0)], ["station", 2.0, 3.0, 150.0, 150.0], ["tea", 2.0, 2.0, (-150.0), (-120.0)], ["station", 1.0, 5.0, (-150.0), 120.0], ["overtime", 0.0, 5.0, 0.0, 160.0], ["tea", 0.0, 4.0, 150.0, 140.0], ["station", 2.0, 8.0, (-150.0), 150.0], ["tea", 1.0, 8.0, 140.0, (-150.0)], ["tea", 4.0, 8.0, (-140.0), 150.0]]
	_s2["FACI"] = []
	J.cl(_s2["mkFaci"], null, [])
	_s2["TEA_CD"] = 60.0
	_s2["DOWN_T"] = 4.5
	_s2["MEET"] = [["龐總：「阿福，臨時開會。你部門今晚嘅表現，我哋逐張 slide 傾。」", "龐總：「阿福，臨時開會。你部門今晚的表現，我們一張張投影片來談。」"], ["龐總：「倒低唔緊要，最緊要寫低原因，聽朝交檢討報告。」", "龐總：「倒下不要緊，最要緊是寫下原因，明早交檢討報告。」"], ["龐總：「我唔係話你唔努力，我係話你努力得唔夠有效率。」", "龐總：「我不是說你不努力，我是說你努力得不夠有效率。」"], ["龐總：「你知唔知你倒低嗰陣，Bryan 喺度打緊卡？」", "龐總：「你知不知道你倒下的時候，Bryan 在打卡？」"], ["龐總：「下次記得，倒低之前先 cc 埋我。」", "龐總：「下次記得，倒下之前先 cc 我。」"], ["龐總：「部門唔係你一個人嘅，係公司嘅。返去休息，聽日再嚟。」", "龐總：「部門不是你一個人的，是公司的。回去休息，明天再來。」"], ["龐總：「呢個會好短，十五分鐘。」（開咗兩個鐘）", "龐總：「這個會很短，十五分鐘。」（開了兩小時）"], ["龐總：「你今晚收咗幾多隻？唔緊要，數字唔會呃人，我會。」", "龐總：「你今晚收了幾隻？沒關係，數字不會騙人，我會。」"], ["冼小姐：「阿福，你嘅病假紙要喺陰司系統度補返，唔該。」", "冼小姐：「阿福，你的病假單要在陰司系統裡補上，謝謝。」"], ["龐總：「我哋係一個大家庭。家庭成員倒低咗，就要扣錢。」", "龐總：「我們是一個大家庭。家庭成員倒下了，就要扣錢。」"], ["龐總：「我欣賞你嘅衝勁。下次衝之前，先睇下地圖。」", "龐總：「我欣賞你的衝勁。下次衝之前，先看一下地圖。」"], ["龐總：「阿福，你嘅 KPI 好似你嘅心跳，平咗。」", "龐總：「阿福，你的 KPI 跟你的心跳一樣，平了。」"], ["冼小姐：「依公司規定，巡邏倒低唔計工傷，計自願加班。」", "冼小姐：「依公司規定，巡邏倒下不算工傷，算自願加班。」"], ["龐總：「你唔使驚，我唔會炒你。死咗嘅人炒唔到。」", "龐總：「你不用怕，我不會開除你。死了的人開除不了。」"], ["龐總：「我年輕嗰陣巡夜，一個人打一條街。」（佢冇巡過）", "龐總：「我年輕的時候巡夜，一個人打一條街。」（他沒巡過）"], ["龐總：「失敗係成功之母。你個媽燒咗咁多嘢落嚟，你都要爭啖氣。」", "龐總：「失敗是成功之母。你媽燒了那麼多東西下來，你也要爭口氣。」"], ["龐總：「下次帶多啲人。唔夠人？自己諗辦法，呢個叫 ownership。」", "龐總：「下次帶多點人。人不夠？自己想辦法，這叫 ownership。」"], ["冼小姐：「部門士氣調查：你個部門 0 分。唔係，係負分。」", "冼小姐：「部門士氣調查：你的部門 0 分。不對，是負分。」"], ["龐總：「今晚當交學費。學費邊個俾？你。」", "龐總：「今晚就當交學費。學費誰付？你。」"], ["龐總：「散會。阿福留低，我哋私下再傾下你嘅前途。」", "龐總：「散會。阿福留下，我們私下再談談你的前途。」"]]
	_s2["D"] = Callable(self, "_f23").bind(_s2)
	_s2["has"] = Callable(self, "_f24").bind(_s2)
	_s2["sidOf"] = Callable(self, "_f29").bind(_s2)
	_s2["PH"] = {"zi": {"n": "子時", "d": "凶鬼出沒・掉落×2・收編 -10%"}, "off": {"n": "收工", "d": "遊魂變少變慢・收編 +10%"}, "work": {"n": "上班時間", "d": "遊魂在摸魚，不惹牠就不動"}, "ot": {"n": "加班時間", "d": "遊魂正常巡邏"}}
	_s2["crewCap"] = Callable(self, "_f37").bind(_s2)
	_s2["troopTeams"] = Callable(self, "_f38").bind(_s2)
	_s2["R"] = null
	_s2["CLOTH"] = {"yuan": ["sepia(.45) hue-rotate(215deg) saturate(1.5)", "sepia(.6) hue-rotate(225deg) saturate(2.2) brightness(.9)"], "chan": ["sepia(.55) hue-rotate(-25deg) saturate(1.6)", "sepia(.7) hue-rotate(-30deg) saturate(2.4) brightness(.92)"], "lan": ["sepia(.45) hue-rotate(160deg) saturate(1.5)", "sepia(.6) hue-rotate(170deg) saturate(2.2) brightness(.9)"]}
	_s2["wReg"] = false
	_s2["SOLID"] = {"tomb": 20.0, "tree": 18.0, "stilt": 46.0, "palm": 12.0, "well": 28.0, "lamp": 8.0, "cart": 30.0, "stone": 20.0, "rock2": 30.0, "banana": 14.0, "pond": 44.0, "hut": 42.0, "slamp": 8.0, "bus": 46.0, "scooter": 26.0, "pillar": 22.0, "cabinet": 22.0, "cooler": 16.0, "rock": 24.0}
	_s2["PGRID"] = {}
	_s2["WALLS"] = []
	_s2["R0WALK"] = null
	_s2["HOOK"] = {}
	_s2["active"] = false
	_s2["el"] = null
	_s2["cv"] = null
	_s2["ctx"] = null
	_s2["mini"] = null
	_s2["raf"] = 0.0
	_s2["last"] = 0.0
	_s2["ACC"] = 1500.0
	_s2["RING"] = {"lead": [55.0, 130.0], "crew": [80.0, 185.0], "troop": [100.0, 215.0]}
	_s2["ATK"] = {"windup": 0.15, "strike": 0.1, "recover": 0.22, "cast": 0.45}
	_s2["TINT"] = {}
	_s2["HUE"] = {"yuan": 110.0, "chan": (-150.0), "lan": 35.0, "foe": (-155.0), "gold": 0.0}
	_s2["PROP"] = {"tomb": {"img": "pr_tomb", "h": 62.0}, "tree": {"img": "pr_deadtree", "h": 120.0}, "lantern": {"img": "pr_lantern", "h": 92.0, "light": "255,120,70"}, "rock": {"img": "pr_rocks", "h": 44.0}, "stilt": {"img": "pr_stilt", "h": 120.0, "light": "255,190,110"}, "palm": {"img": "pr_palm", "h": 140.0}, "well": {"img": "pr_well", "h": 62.0}, "bush": {"img": "pr_bush", "h": 56.0}, "bush2": {"img": "pr_bush2", "h": 54.0}, "lamp": {"img": "pr_lamp", "h": 110.0, "light": "200,230,170"}, "cart": {"img": "pr_cart", "h": 56.0}, "stone": {"img": "pr_milestone", "h": 58.0}, "rock2": {"img": "pr_rocks2", "h": 48.0}, "banana": {"img": "pr_banana", "h": 120.0}, "pond": {"img": "pr_pond", "h": 46.0}, "hut": {"img": "pr_hut", "h": 96.0, "light": "255,190,110"}, "fern": {"img": "pr_fern", "h": 44.0}, "slamp": {"img": "pr_slamp", "h": 120.0, "light": "255,214,140"}, "cone": {"img": "pr_barrier", "h": 46.0}, "bus": {"img": "pr_busstop", "h": 92.0}, "scooter": {"img": "pr_scooter", "h": 52.0}, "pillar": {"img": "pr_pillar", "h": 108.0}, "cabinet": {"img": "pr_cabinet", "h": 68.0}, "plant": {"img": "pr_plant", "h": 66.0}, "cooler": {"img": "pr_cooler", "h": 72.0, "light": "140,200,255"}}
	_s2["PAT"] = {}
	_s2["LC"] = null
	_s2["IMG"] = {}
	_s2["TC"] = ["rgba(120,200,140,.12)", "rgba(220,180,90,.12)", "rgba(140,160,240,.12)", "rgba(220,120,200,.12)", "rgba(110,210,230,.12)", "rgba(240,90,90,.14)", "rgba(90,255,190,.10)", "rgba(90,255,190,.10)", "rgba(90,255,190,.10)"]
	return {"open": _s2["openPrep"], "openPrep": _s2["openPrep"], "close": _s2["close"], "FAC": _s2["FAC"], "facOf": _s2["facOf"], "st": _s2["st"], "regionOpen": _s2["regionOpen"], "_R": Callable(self, "_f360").bind(_s2), "_end": _s2["end"], "_gain": _s2["gain"], "spots": Callable(self, "_f361").bind(_s2), "landmarks": Callable(self, "_f362").bind(_s2), "on": Callable(self, "_f364").bind(_s2), "openMap": _s2["openMap"], "_test": {"foe": _s2["foe"], "onDown": _s2["onDown"], "resolveDown": _s2["resolveDown"], "signInfo": _s2["signInfo"], "fxImg": _s2["fxImg"], "img": _s2["img"], "telegraph": _s2["telegraph"], "map": Callable(self, "_f365").bind(_s2), "kingWin": _s2["kingWin"], "spawnKing": _s2["spawnKing"]}, "__getters": {"active": Callable(self, "_f359").bind(_s2)}}

func _f375(this_, a: Array, env):
	var v_x_1926 = null
	v_x_1926 = J.arg(a, 0)
	return J.seq(J.gp(v_x_1926, "slot"), "wea")

func _f374(this_, a: Array, env):
	var v_g_1923 = null; var v_it_1924 = null; var v_i_1925 = null
	v_g_1923 = J.arg(a, 0)
	var _t2498 = env["held"]
	var _t2499 = J.cl(_t2498, null, [v_g_1923])
	v_it_1924 = J.mc(_t2499, "find", [Callable(self, "_f375").bind(env)])
	if (not J.t(v_it_1924)):
		return null
	v_i_1925 = J.mc(env["FK"], "indexOf", [J.gp(v_it_1924, "f")])
	return {"it": v_it_1924, "img": J.gp(J.gp(env["WIMG"], J.gp(v_it_1924, "c")), v_i_1925), "sty": J.gp(J.gp(env["WSTY"], J.gp(v_it_1924, "c")), v_i_1925), "S": J.gp(env["STY"], J.gp(J.gp(env["WSTY"], J.gp(v_it_1924, "c")), v_i_1925)), "lvMul": (1.0 + (0.04 * J.sub(J.gp(v_it_1924, "lv"), 1.0)))}

func _f377(this_, a: Array, env):
	var v_x_1930 = null
	v_x_1930 = J.arg(a, 0)
	return J.seq(J.gp(v_x_1930, "slot"), "arm")

func _f376(this_, a: Array, env):
	var v_g_1929 = null
	v_g_1929 = J.arg(a, 0)
	var _t2500 = env["held"]
	var _t2501 = J.cl(_t2500, null, [v_g_1929])
	var _t2502 = J.mc(_t2501, "find", [Callable(self, "_f377").bind(env)])
	return (_t2502 if J.t(_t2502) else null)

func _f379(this_, a: Array, env):
	var v_x_1934 = null
	v_x_1934 = J.arg(a, 0)
	return J.seq(J.gp(v_x_1934, "slot"), "acc")

func _f378(this_, a: Array, env):
	var v_g_1933 = null
	v_g_1933 = J.arg(a, 0)
	var _t2503 = env["held"]
	var _t2504 = J.cl(_t2503, null, [v_g_1933])
	var _t2505 = J.mc(_t2504, "find", [Callable(self, "_f379").bind(env)])
	return (_t2505 if J.t(_t2505) else null)

func _f380(this_, a: Array, env):
	if (not J.t(J.gp(J.G.get("S"), "gear"))):
		var _t2506 = J.G.get("S")
		var _t2507 = {"items": [], "uid": 1.0}
		J.sp(_t2506, "gear", _t2507)
	return J.gp(J.G.get("S"), "gear")

func _f381(this_, a: Array, env):
	var v_it_1939 = null; var v_l_1940 = null
	v_it_1939 = J.arg(a, 0)
	v_l_1940 = J.gp(J.gp(env["NAMES"], J.gp(v_it_1939, "slot")), J.gp(v_it_1939, "c"))
	return ((J.str(J.gp(v_l_1940, 0.0)) + "・" + J.str(J.gp(J.gp(J.gp(J.G.get("Patrol"), "FAC"), J.gp(v_it_1939, "f")), "name"))) if J.seq(J.gp(v_it_1939, "slot"), "acc") else J.gp(v_l_1940, J.mc(env["FK"], "indexOf", [J.gp(v_it_1939, "f")])))

func _f382(this_, a: Array, env):
	var v_it_1943 = null
	v_it_1943 = J.arg(a, 0)
	return J.round(J.num(((5.0 + J.mul(5.0, J.gp(v_it_1943, "c"))) * (1.0 + (0.15 * J.sub(J.gp(v_it_1943, "lv"), 1.0))))))

func _f383(this_, a: Array, env):
	var v_c_1946 = null; var v_f_1947 = null; var v_k_1948 = null; var v_r_1949 = null
	v_c_1946 = J.arg(a, 0)
	v_f_1947 = J.arg(a, 1)
	v_k_1948 = J.add(v_c_1946, 1.0)
	v_r_1949 = {"coins": J.round(J.num((150.0 * pow(J.num(v_k_1948), J.num(1.7))))), "planks": J.round(J.num((40.0 * pow(J.num(v_k_1948), J.num(1.5)))))}
	return {"r": v_r_1949, "mat": {J.key(v_f_1947): J.round(J.num((12.0 * pow(J.num(v_k_1948), J.num(1.4)))))}}

func _f384(this_, a: Array, env):
	var v_it_1952 = null; var v_k_1953 = null
	v_it_1952 = J.arg(a, 0)
	v_k_1953 = J.add(J.gp(v_it_1952, "c"), 1.0)
	return {"r": {"coins": J.round(J.num(J.mul(J.mul(60.0, v_k_1953), J.gp(v_it_1952, "lv")))), "planks": J.round(J.num(J.mul(J.mul(10.0, v_k_1953), J.gp(v_it_1952, "lv"))))}, "mat": {J.key(J.gp(v_it_1952, "f")): J.round(J.num(J.mul(J.mul(4.0, v_k_1953), J.gp(v_it_1952, "lv"))))}}

func _f386(this_, a: Array, env):
	var v_f_1958 = null
	v_f_1958 = J.arg(a, 0)
	return J.cmp(J.gp(env["m"], v_f_1958), J.gp(J.gp(env["c"], "mat"), v_f_1958), ">=")

func _f385(this_, a: Array, env):
	var _s900 = {"__p": env, "c": null, "m": null}
	_s900["c"] = J.arg(a, 0)
	_s900["m"] = J.gp(J.mc(J.G.get("Patrol"), "st", []), "mats")
	var _t2508 = J.G.get("canPay")
	var _t2510 = J.cl(_t2508, null, [J.gp(_s900["c"], "r")])
	if J.t(_t2510):
		var _t2509 = J.S_Object_("keys", [J.gp(_s900["c"], "mat")])
		_t2510 = J.mc(_t2509, "every", [Callable(self, "_f386").bind(_s900)])
	return _t2510

func _f387(this_, a: Array, env):
	var v_c_1961 = null; var v_m_1962 = null; var v_f_1963 = null
	v_c_1961 = J.arg(a, 0)
	var _t2511 = J.G.get("pay")
	J.cl(_t2511, null, [J.gp(v_c_1961, "r")])
	v_m_1962 = J.gp(J.mc(J.G.get("Patrol"), "st", []), "mats")
	for _t2512 in J.keys(J.gp(v_c_1961, "mat")):
		v_f_1963 = _t2512
		var _t2513 = J.sub(J.gp(v_m_1962, v_f_1963), J.gp(J.gp(v_c_1961, "mat"), v_f_1963))
		J.sp(v_m_1962, v_f_1963, _t2513)

func _f389(this_, a: Array, env):
	var v_f_1968 = null
	v_f_1968 = J.arg(a, 0)
	return ("<span class=\"" + ("" if J.cmp(J.gp(env["m"], v_f_1968), J.gp(J.gp(env["c"], "mat"), v_f_1968), ">=") else "lack") + "\">" + J.str(J.gp(J.gp(J.gp(J.G.get("Patrol"), "FAC"), v_f_1968), "mat")) + " " + J.str(J.gp(J.gp(env["c"], "mat"), v_f_1968)) + "</span>")

func _f388(this_, a: Array, env):
	var _s904 = {"__p": env, "c": null, "m": null}
	_s904["c"] = J.arg(a, 0)
	_s904["m"] = J.gp(J.mc(J.G.get("Patrol"), "st", []), "mats")
	var _t2514 = J.G.get("costText")
	var _t2517 = J.add(J.cl(_t2514, null, [J.gp(_s904["c"], "r")]), "　")
	var _t2515 = J.S_Object_("keys", [J.gp(_s904["c"], "mat")])
	var _t2516 = J.mc(_t2515, "map", [Callable(self, "_f389").bind(_s904)])
	return J.add(_t2517, J.mc(_t2516, "join", [""]))

func _f391(this_, a: Array, env):
	var v_it_1972 = null
	v_it_1972 = J.arg(a, 0)
	return J.seq(J.gp(v_it_1972, "who"), J.gp(env["g"], "id"))

func _f390(this_, a: Array, env):
	var _s906 = {"__p": env, "g": null}
	_s906["g"] = J.arg(a, 0)
	var _t2519 = null
	if J.t(_s906["g"]):
		var _t2518 = J.gp(J.cl(_s906["__p"]["st"], null, []), "items")
		_t2519 = J.mc(_t2518, "filter", [Callable(self, "_f391").bind(_s906)])
	else:
		_t2519 = []
	return _t2519

func _f392(this_, a: Array, env):
	var v_g_1975 = null; var v_atk_1976 = null; var v_hp_1977 = null; var v_it_1978 = null; var v_p_1979 = null
	v_g_1975 = J.arg(a, 0)
	v_atk_1976 = 1.0
	v_hp_1977 = 1.0
	var _t2521 = env["held"]
	for _t2520 in J.iter(J.cl(_t2521, null, [v_g_1975])):
		v_it_1978 = _t2520
		var _t2522 = env["pct"]
		v_p_1979 = J.div(J.cl(_t2522, null, [v_it_1978]), 100.0)
		if J.seq(J.gp(v_it_1978, "slot"), "wea"):
			var _t2523 = J.add(v_atk_1976, v_p_1979)
			v_atk_1976 = _t2523
		else:
			if J.seq(J.gp(v_it_1978, "slot"), "arm"):
				var _t2524 = J.add(v_hp_1977, J.mul(v_p_1979, 1.2))
				v_hp_1977 = _t2524
			else:
				var _t2525 = J.add(v_atk_1976, J.mul(v_p_1979, 0.3))
				v_atk_1976 = _t2525
	return {"atk": v_atk_1976, "hp": v_hp_1977}

func _f393(this_, a: Array, env):
	var v_g_1982 = null; var v_m_1983 = null
	v_g_1982 = J.arg(a, 0)
	var _t2526 = env["unitMul"]
	v_m_1983 = J.cl(_t2526, null, [v_g_1982])
	return (1.0 + J.div((J.sub(J.gp(v_m_1983, "atk"), 1.0) + J.sub(J.gp(v_m_1983, "hp"), 1.0)), 2.0))

func _f394(this_, a: Array, env):
	var v_out_1986 = null; var v_ids_1987 = null; var v_it_1988 = null; var v_p_1989 = null
	v_out_1986 = {"yuan": {"atk": 1.0, "hp": 1.0}, "chan": {"atk": 1.0, "hp": 1.0}, "lan": {"atk": 1.0, "hp": 1.0}}
	var _t2527 = ["afu"]
	var _t2528 = J.gp(J.G.get("S"), "pt")
	var _t2530 = (J.gp(J.gp(J.G.get("S"), "pt"), "lead") if J.t(_t2528) else _t2528)
	if not J.t(_t2530):
		var _t2529 = J.gp(J.G.get("S"), "team")
		_t2530 = J.mc(_t2529, "filter", [J.G.get("Boolean")])
	v_ids_1987 = J.mc(_t2527, "concat", [_t2530])
	for _t2531 in J.iter(J.gp(J.cl(env["st"], null, []), "items")):
		v_it_1988 = _t2531
		if J.t(J.mc(v_ids_1987, "includes", [J.gp(v_it_1988, "who")])):
			var _t2532 = env["pct"]
			v_p_1989 = J.div(J.cl(_t2532, null, [v_it_1988]), 100.0)
			if J.seq(J.gp(v_it_1988, "slot"), "acc"):
				var _t2533 = J.gp(v_out_1986, J.gp(v_it_1988, "f"))
				var _t2534 = J.add(J.gp(_t2533, "atk"), J.mul(v_p_1989, 0.6))
				J.sp(_t2533, "atk", _t2534)
			if J.seq(J.gp(v_it_1988, "slot"), "arm"):
				var _t2535 = J.gp(v_out_1986, J.gp(v_it_1988, "f"))
				var _t2536 = J.add(J.gp(_t2535, "hp"), J.mul(v_p_1989, 0.5))
				J.sp(_t2535, "hp", _t2536)
	return v_out_1986

func _f395(this_, a: Array, env):
	var v_it_1992 = null; var v_p_1993 = null; var v_f_1994 = null
	v_it_1992 = J.arg(a, 0)
	var _t2537 = env["pct"]
	v_p_1993 = J.cl(_t2537, null, [v_it_1992])
	v_f_1994 = J.gp(J.gp(J.gp(J.G.get("Patrol"), "FAC"), J.gp(v_it_1992, "f")), "name")
	return (("攻擊 +" + J.str(v_p_1993) + "%・" + J.str(J.gp(J.gp(env["STY"], J.gp(J.gp(env["WSTY"], J.gp(v_it_1992, "c")), J.mc(env["FK"], "indexOf", [J.gp(v_it_1992, "f")]))), "n")) + "：" + J.str(J.gp(J.gp(env["STY"], J.gp(J.gp(env["WSTY"], J.gp(v_it_1992, "c")), J.mc(env["FK"], "indexOf", [J.gp(v_it_1992, "f")]))), "d"))) if J.seq(J.gp(v_it_1992, "slot"), "wea") else (("血 +" + J.str(J.round(J.num(J.mul(v_p_1993, 1.2)))) + "%・" + J.str(v_f_1994) + "組員血 +" + J.str(J.round(J.num(J.mul(v_p_1993, 0.5)))) + "%") if J.seq(J.gp(v_it_1992, "slot"), "arm") else (J.str(v_f_1994) + "組員攻擊 +" + J.str(J.round(J.num(J.mul(v_p_1993, 0.6)))) + "%・自己攻擊 +" + J.str(J.round(J.num(J.mul(v_p_1993, 0.3)))) + "%")))

func _f396(this_, a: Array, env):
	var v_it_1997 = null; var v_src_1998 = null
	v_it_1997 = J.arg(a, 0)
	if (not J.seq(J.gp(v_it_1997, "slot"), "wea")):
		return ""
	var _t2538 = (not J.seq(J.typeof_(J.G.get("PT_IMG_SRC")), "undefined"))
	v_src_1998 = (J.gp(J.G.get("PT_IMG_SRC"), J.gp(J.gp(env["WIMG"], J.gp(v_it_1997, "c")), J.mc(env["FK"], "indexOf", [J.gp(v_it_1997, "f")]))) if _t2538 else _t2538)
	return (("<img class=\"gr-ic\" src=\"" + J.str(v_src_1998) + "\" alt=\"\">") if J.t(v_src_1998) else "")

func _f397(this_, a: Array, env):
	var v_b_2001 = null
	v_b_2001 = J.arg(a, 0)
	if (not J.seq(J.typeof_(J.G.get("__nat_patrolMenu")), "undefined")):
		var _t2539 = J.G.get("Gear")
		var _t2540 = {"st": env["st"], "nameOf": env["nameOf"], "effText": env["effText"], "craftCost": env["craftCost"], "upCost": env["upCost"], "canPayAll": env["canPayAll"], "payAll": env["payAll"], "held": env["held"], "FK": env["FK"], "WIMG": env["WIMG"], "SLOTS": env["SLOTS"]}
		J.sp(_t2539, "_menu", _t2540)
		var _t2541 = J.G.get("__nat_patrolMenu")
		if J.t(J.cl(_t2541, null, ["gear", v_b_2001])):
			return null
	if J.t(v_b_2001):
		env["back"] = v_b_2001
	J.cl(env["render"], null, [])

func _f399(this_, a: Array, env):
	var v_g_2010 = null
	v_g_2010 = J.arg(a, 0)
	var _t2543 = J.seq(J.gp(v_g_2010, "q"), "名")
	return (_t2543 if _t2543 else J.seq(J.gp(v_g_2010, "q"), "主"))

func _f400(this_, a: Array, env):
	var v_f_2011 = null
	v_f_2011 = J.arg(a, 0)
	var _t2546 = J.gp(J.gp(J.gp(J.G.get("Patrol"), "FAC"), v_f_2011), "col")
	var _t2547 = J.gp(J.gp(J.gp(J.G.get("Patrol"), "FAC"), v_f_2011), "mat")
	var _t2545 = J.G.get("fmt")
	return ("<span style=\"color:" + J.str(_t2546) + "\"><b>" + J.str(_t2547) + "</b> " + J.str(J.cl(_t2545, null, [J.gp(env["m"], v_f_2011)])) + "</span>")

func _f401(this_, a: Array, env):
	var v_k_2012 = null
	v_k_2012 = J.arg(a, 0)
	return ("<button class=\"btn sm " + ("gold" if J.seq(env["__p"]["tab"], v_k_2012) else "") + "\" data-tab=\"" + J.str(v_k_2012) + "\">" + J.str(J.gp(env["__p"]["SLOTS"], v_k_2012)) + "</button>")

func _f402(this_, a: Array, env):
	var v_it_2013 = null
	v_it_2013 = J.arg(a, 0)
	return J.seq(J.gp(v_it_2013, "slot"), env["__p"]["tab"])

func _f403(this_, a: Array, env):
	var v_g_2017 = null
	v_g_2017 = J.arg(a, 0)
	return ("<option value=\"" + J.str(J.gp(v_g_2017, "id")) + "\" " + ("selected" if J.seq(J.gp(v_g_2017, "id"), J.gp(env["it"], "who")) else "") + ">" + J.str(J.gp(v_g_2017, "name")) + "</option>")

func _f405(this_, a: Array, env):
	var v_f_2021 = null; var v_it_2022 = null; var v_cc_2023 = null
	v_f_2021 = J.arg(a, 0)
	var _t2582 = J.seq(env["__p"]["__p"]["tab"], "acc")
	if (false if _t2582 else _t2582):
		return null
	v_it_2022 = {"slot": env["__p"]["__p"]["tab"], "c": env["c"], "f": v_f_2021, "lv": 1.0}
	var _t2583 = env["__p"]["__p"]["craftCost"]
	v_cc_2023 = J.cl(_t2583, null, [env["c"], v_f_2021])
	var _t2585 = ("" if J.t(env["open"]) else "dis")
	var _t2584 = env["__p"]["__p"]["icon"]
	var _t2587 = J.cl(_t2584, null, [v_it_2022])
	var _t2588 = J.gp(J.gp(J.gp(J.G.get("Patrol"), "FAC"), v_f_2021), "col")
	var _t2586 = env["__p"]["__p"]["nameOf"]
	var _t2590 = J.cl(_t2586, null, [v_it_2022])
	var _t2591 = J.gp("一二三四五六", env["c"])
	var _t2589 = env["__p"]["__p"]["effText"]
	var _t2597 = J.cl(_t2589, null, [v_it_2022])
	var _t2596 = null
	if J.t(env["open"]):
		var _t2593 = env["c"]
		var _t2592 = env["__p"]["__p"]["canPayAll"]
		var _t2595 = ("" if J.t(J.cl(_t2592, null, [v_cc_2023])) else "disabled")
		var _t2594 = env["__p"]["__p"]["costHTML"]
		_t2596 = ("<button class=\"btn sm\" data-mk=\"" + J.str(_t2593) + "," + J.str(v_f_2021) + "\" " + _t2595 + ">打造<small>" + J.str(J.cl(_t2594, null, [v_cc_2023])) + "</small></button>")
	else:
		_t2596 = "<small>巡到這區才解鎖</small>"
	var _t2598 = J.add(env["__p"]["h"], ("<div class=\"gr-it " + _t2585 + "\"><div class=\"gr-n\">" + J.str(_t2587) + "<b style=\"color:" + J.str(_t2588) + "\">" + J.str(_t2590) + "</b> <i>第" + J.str(_t2591) + "區</i><small>" + J.str(_t2597) + "</small></div><div class=\"gr-b\">" + _t2596 + "</div></div>"))
	env["__p"]["h"] = _t2598

func _f404(this_, a: Array, env):
	var v_ch_2018 = null
	var _s927 = {"__p": env, "c": null, "open": null}
	v_ch_2018 = J.arg(a, 0)
	_s927["c"] = J.arg(a, 1)
	_s927["open"] = J.mc(J.G.get("Patrol"), "regionOpen", [_s927["c"]])
	J.mc(_s927["__p"]["__p"]["FK"], "forEach", [Callable(self, "_f405").bind(_s927)])

func _f407(this_, a: Array, env):
	env["__p"]["__p"]["tab"] = J.gp(J.gp(env["b"], "dataset"), "tab")
	var _t2603 = env["__p"]["__p"]["keep"]
	J.cl(_t2603, null, [env["__p"]["__p"]["render"]])

func _f406(this_, a: Array, env):
	var _s929 = {"__p": env, "b": null}
	_s929["b"] = J.arg(a, 0)
	var _t2602 = _s929["b"]
	var _t2604 = Callable(self, "_f407").bind(_s929)
	J.sp(_t2602, "onclick", _t2604)
	return _t2604

func _f409(this_, a: Array, env):
	var v_c_2026 = null; var v_f_2027 = null; var v_cc_2028 = null; var v_it_2029 = null; var v_e_2030 = null
	var _t2607 = J.gp(J.gp(env["b"], "dataset"), "mk")
	var _t2608 = J.mc(_t2607, "split", [","])
	var _t2609 = J.gp(_t2608, 0.0)
	v_c_2026 = _t2609
	var _t2610 = J.gp(_t2608, 1.0)
	v_f_2027 = _t2610
	var _t2611 = env["__p"]["__p"]["craftCost"]
	v_cc_2028 = J.cl(_t2611, null, [J.num(v_c_2026), v_f_2027])
	var _t2612 = env["__p"]["__p"]["canPayAll"]
	if (not J.t(J.cl(_t2612, null, [v_cc_2028]))):
		return null
	var _t2613 = env["__p"]["__p"]["payAll"]
	J.cl(_t2613, null, [v_cc_2028])
	var _t2614 = env["__p"]["s"]
	var _t2615 = J.num(J.gp(_t2614, "uid"))
	J.sp(_t2614, "uid", _t2615 + 1.0)
	v_it_2029 = {"id": J.add("e", _t2615), "slot": env["__p"]["__p"]["tab"], "c": J.num(v_c_2026), "f": v_f_2027, "lv": 1.0, "who": null}
	var _t2616 = J.gp(env["__p"]["s"], "items")
	J.mc(_t2616, "push", [v_it_2029])
	var _t2617 = env["__p"]["__p"]["nameOf"]
	J.mc(J.G.get("Fx"), "toast", [("打造了 <b>" + J.str(J.cl(_t2617, null, [v_it_2029])) + "</b>")])
	J.mc(J.G.get("Sound"), "play", ["gong"])
	J.cl(J.G.get("save"), null, [])
	var _t2618 = env["__p"]["__p"]["keep"]
	J.cl(_t2618, null, [env["__p"]["__p"]["render"]])

func _f408(this_, a: Array, env):
	var _s931 = {"__p": env, "b": null}
	_s931["b"] = J.arg(a, 0)
	var _t2606 = _s931["b"]
	var _t2619 = Callable(self, "_f409").bind(_s931)
	J.sp(_t2606, "onclick", _t2619)
	return _t2619

func _f412(this_, a: Array, env):
	var v_x_2034 = null
	v_x_2034 = J.arg(a, 0)
	return J.seq(J.gp(v_x_2034, "id"), J.gp(J.gp(env["b"], "dataset"), "up"))

func _f411(this_, a: Array, env):
	var v_it_2032 = null; var v_uc_2033 = null
	var _t2622 = J.gp(env["__p"]["s"], "items")
	v_it_2032 = J.mc(_t2622, "find", [Callable(self, "_f412").bind(env)])
	var _t2623 = env["__p"]["__p"]["upCost"]
	v_uc_2033 = J.cl(_t2623, null, [v_it_2032])
	var _t2624 = env["__p"]["__p"]["canPayAll"]
	var _t2625 = (not J.t(J.cl(_t2624, null, [v_uc_2033])))
	if (_t2625 if _t2625 else J.cmp(J.gp(v_it_2032, "lv"), 10.0, ">=")):
		return null
	var _t2626 = env["__p"]["__p"]["payAll"]
	J.cl(_t2626, null, [v_uc_2033])
	J.sp(v_it_2032, "lv", J.num(J.gp(v_it_2032, "lv")) + 1.0)
	var _t2627 = env["__p"]["__p"]["nameOf"]
	J.mc(J.G.get("Fx"), "toast", [(J.str(J.cl(_t2627, null, [v_it_2032])) + " 升到 Lv" + J.str(J.gp(v_it_2032, "lv")))])
	J.cl(J.G.get("save"), null, [])
	var _t2628 = env["__p"]["__p"]["keep"]
	J.cl(_t2628, null, [env["__p"]["__p"]["render"]])

func _f410(this_, a: Array, env):
	var _s936 = {"__p": env, "b": null}
	_s936["b"] = J.arg(a, 0)
	var _t2621 = _s936["b"]
	var _t2629 = Callable(self, "_f411").bind(_s936)
	J.sp(_t2621, "onclick", _t2629)
	return _t2629

func _f415(this_, a: Array, env):
	var v_x_2038 = null
	v_x_2038 = J.arg(a, 0)
	return J.seq(J.gp(v_x_2038, "id"), J.gp(J.gp(env["__p"]["sel"], "dataset"), "who"))

func _f416(this_, a: Array, env):
	var v_x_2039 = null
	v_x_2039 = J.arg(a, 0)
	var _t2635 = (not J.seq(v_x_2039, env["it"]))
	var _t2636 = (J.seq(J.gp(v_x_2039, "who"), env["id"]) if _t2635 else _t2635)
	if (J.seq(J.gp(v_x_2039, "slot"), J.gp(env["it"], "slot")) if _t2636 else _t2636):
		J.sp(v_x_2039, "who", null)

func _f414(this_, a: Array, env):
	var _s940 = {"__p": env, "it": null, "id": null}
	var _t2632 = J.gp(_s940["__p"]["__p"]["s"], "items")
	_s940["it"] = J.mc(_t2632, "find", [Callable(self, "_f415").bind(_s940)])
	var _t2633 = J.gp(_s940["__p"]["sel"], "value")
	_s940["id"] = (_t2633 if J.t(_t2633) else null)
	if J.t(_s940["id"]):
		var _t2634 = J.gp(_s940["__p"]["__p"]["s"], "items")
		J.mc(_t2634, "forEach", [Callable(self, "_f416").bind(_s940)])
	var _t2637 = _s940["it"]
	var _t2638 = _s940["id"]
	J.sp(_t2637, "who", _t2638)
	J.cl(J.G.get("save"), null, [])
	var _t2639 = _s940["__p"]["__p"]["__p"]["keep"]
	J.cl(_t2639, null, [_s940["__p"]["__p"]["__p"]["render"]])

func _f413(this_, a: Array, env):
	var _s939 = {"__p": env, "sel": null}
	_s939["sel"] = J.arg(a, 0)
	var _t2631 = _s939["sel"]
	var _t2640 = Callable(self, "_f414").bind(_s939)
	J.sp(_t2631, "onchange", _t2640)
	return _t2640

func _f417(this_, a: Array, env):
	return (J.cl(env["__p"]["back"], null, []) if J.t(env["__p"]["back"]) else J.mc(J.G.get("UI"), "close", []))

func _f398(this_, a: Array, env):
	var v_who_2006 = null; var v_mine_2008 = null; var v_root_2009 = null; var v_w_2015 = null; var v_uc_2016 = null
	var _s919 = {"__p": env, "s": null, "m": null, "h": null}
	_s919["s"] = J.cl(_s919["__p"]["st"], null, [])
	_s919["m"] = J.gp(J.mc(J.G.get("Patrol"), "st", []), "mats")
	var _t2542 = J.gp(J.G.get("S"), "ghosts")
	v_who_2006 = J.mc(_t2542, "filter", [Callable(self, "_f399").bind(_s919)])
	_s919["h"] = ("<p class=\"desc\">用冥幣、棺材板和執念打造。武器、衣服、掛繩都可以隨時換給別的角色戴。加成會帶到所有玩法（鬼力）。</p>")
	var _t2544 = J.S_Object_("keys", [J.gp(J.G.get("Patrol"), "FAC")])
	var _t2548 = J.mc(_t2544, "map", [Callable(self, "_f400").bind(_s919)])
	var _t2550 = J.mc(_t2548, "join", [""])
	var _t2549 = J.G.get("fmt")
	var _t2552 = J.cl(_t2549, null, [J.gp(J.gp(J.G.get("S"), "res"), "planks")])
	var _t2551 = J.G.get("fmt")
	var _t2553 = J.add(_s919["h"], ("<div class=\"pt-mats\">" + J.str(_t2550) + "<span><b>棺材板</b> " + J.str(_t2552) + "</span><span><b>冥幣</b> " + J.str(J.cl(_t2551, null, [J.gp(J.gp(J.G.get("S"), "res"), "coins")])) + "</span></div>"))
	_s919["h"] = _t2553
	var _t2554 = J.S_Object_("keys", [_s919["__p"]["SLOTS"]])
	var _t2555 = J.mc(_t2554, "map", [Callable(self, "_f401").bind(_s919)])
	var _t2556 = J.add(_s919["h"], ("<div class=\"gr-tabs\">" + J.str(J.mc(_t2555, "join", [""])) + "</div>"))
	_s919["h"] = _t2556
	var _t2557 = J.gp(_s919["s"], "items")
	v_mine_2008 = J.mc(_t2557, "filter", [Callable(self, "_f402").bind(_s919)])
	var _t2558 = J.add(_s919["h"], ("<div class=\"ch-h\">我的" + J.str(J.gp(_s919["__p"]["SLOTS"], _s919["__p"]["tab"])) + "（" + J.str(J.len(v_mine_2008)) + "）</div><div class=\"gr-list\">"))
	_s919["h"] = _t2558
	for _t2559 in J.iter(v_mine_2008):
		var _s924 = {"__p": _s919, "it": null}
		_s924["it"] = _t2559
		var _t2560 = J.G.get("ghostById")
		v_w_2015 = J.cl(_t2560, null, [J.gp(_s924["it"], "who")])
		var _t2561 = _s924["__p"]["__p"]["upCost"]
		v_uc_2016 = J.cl(_t2561, null, [_s924["it"]])
		var _t2562 = _s924["__p"]["__p"]["icon"]
		var _t2564 = J.cl(_t2562, null, [_s924["it"]])
		var _t2565 = J.gp(J.gp(J.gp(J.G.get("Patrol"), "FAC"), J.gp(_s924["it"], "f")), "col")
		var _t2563 = _s924["__p"]["__p"]["nameOf"]
		var _t2567 = J.cl(_t2563, null, [_s924["it"]])
		var _t2568 = J.gp(_s924["it"], "lv")
		var _t2566 = _s924["__p"]["__p"]["effText"]
		var _t2570 = J.cl(_t2566, null, [_s924["it"]])
		var _t2571 = (("佩戴：" + J.str(J.gp(v_w_2015, "name"))) if J.t(v_w_2015) else "未戴")
		var _t2572 = J.gp(_s924["it"], "id")
		var _t2569 = J.mc(v_who_2006, "map", [Callable(self, "_f403").bind(_s924)])
		var _t2578 = J.mc(_t2569, "join", [""])
		var _t2577 = null
		if J.cmp(J.gp(_s924["it"], "lv"), 10.0, "<"):
			var _t2574 = J.gp(_s924["it"], "id")
			var _t2573 = _s924["__p"]["__p"]["canPayAll"]
			var _t2576 = ("" if J.t(J.cl(_t2573, null, [v_uc_2016])) else "disabled")
			var _t2575 = _s924["__p"]["__p"]["costHTML"]
			_t2577 = ("<button class=\"btn sm gold\" data-up=\"" + J.str(_t2574) + "\" " + _t2576 + ">升級<small>" + J.str(J.cl(_t2575, null, [v_uc_2016])) + "</small></button>")
		else:
			_t2577 = "<small>滿級</small>"
		var _t2579 = J.add(_s924["__p"]["h"], ("<div class=\"gr-it\"><div class=\"gr-n\">" + J.str(_t2564) + "<b style=\"color:" + J.str(_t2565) + "\">" + J.str(_t2567) + "</b> <i>Lv" + J.str(_t2568) + "</i><small>" + J.str(_t2570) + "</small><small>" + _t2571 + "</small></div>\n        <div class=\"gr-b\"><select data-who=\"" + J.str(_t2572) + "\"><option value=\"\">— 不戴 —</option>" + J.str(_t2578) + "</select>\n        " + _t2577 + "</div></div>"))
		_s924["__p"]["h"] = _t2579
	if (not J.t(J.len(v_mine_2008))):
		var _t2580 = J.add(_s919["h"], ("<p class=\"desc\">還沒有。在下面打造。</p>"))
		_s919["h"] = _t2580
	var _t2581 = J.add(_s919["h"], ("</div><div class=\"ch-h\">打造</div><div class=\"gr-list\">"))
	_s919["h"] = _t2581
	J.mc(J.G.get("CHAPTERS"), "forEach", [Callable(self, "_f404").bind(_s919)])
	var _t2599 = J.add(_s919["h"], ("</div><button class=\"btn wide\" id=\"gr-back\">返回</button>"))
	_s919["h"] = _t2599
	J.mc(J.G.get("UI"), "sheet", ["裝備房", _s919["h"]])
	var _t2600 = J.G.get("$")
	v_root_2009 = J.cl(_t2600, null, ["#sheet"])
	var _t2601 = J.mc(v_root_2009, "querySelectorAll", ["[data-tab]"])
	J.mc(_t2601, "forEach", [Callable(self, "_f406").bind(_s919)])
	var _t2605 = J.mc(v_root_2009, "querySelectorAll", ["[data-mk]"])
	J.mc(_t2605, "forEach", [Callable(self, "_f408").bind(_s919)])
	var _t2620 = J.mc(v_root_2009, "querySelectorAll", ["[data-up]"])
	J.mc(_t2620, "forEach", [Callable(self, "_f410").bind(_s919)])
	var _t2630 = J.mc(v_root_2009, "querySelectorAll", ["[data-who]"])
	J.mc(_t2630, "forEach", [Callable(self, "_f413").bind(_s919)])
	var _t2641 = J.G.get("$")
	var _t2642 = J.cl(_t2641, null, ["#gr-back"])
	var _t2643 = Callable(self, "_f417").bind(_s919)
	J.sp(_t2642, "onclick", _t2643)

func _f418(this_, a: Array, env):
	var v_f_2042 = null; var v_b_2043 = null; var v_sc_2044 = null; var v_b2_2045 = null
	v_f_2042 = J.arg(a, 0)
	var _t2644 = J.G.get("$")
	v_b_2043 = J.cl(_t2644, null, ["#sheet .sh-body"])
	v_sc_2044 = (J.gp(v_b_2043, "scrollTop") if J.t(v_b_2043) else 0.0)
	J.cl(v_f_2042, null, [])
	var _t2645 = J.G.get("$")
	v_b2_2045 = J.cl(_t2645, null, ["#sheet .sh-body"])
	if J.t(v_b2_2045):
		J.sp(v_b2_2045, "scrollTop", v_sc_2044)

func _f373(this_, a: Array, env):
	var v_weaponOf_1899 = null; var v_armorOf_1900 = null; var v_badgeOf_1901 = null; var v_gpMul_1912 = null; var v_crewBuff_1913 = null; var v_open_1918 = null
	var _s888 = {"__p": env, "SLOTS": null, "NAMES": null, "FK": null, "WIMG": null, "WSTY": null, "STY": null, "st": null, "nameOf": null, "pct": null, "craftCost": null, "upCost": null, "canPayAll": null, "payAll": null, "costHTML": null, "held": null, "unitMul": null, "effText": null, "icon": null, "back": null, "tab": null, "render": null, "keep": null}
	v_weaponOf_1899 = Callable(self, "_f374").bind(_s888)
	v_armorOf_1900 = Callable(self, "_f376").bind(_s888)
	v_badgeOf_1901 = Callable(self, "_f378").bind(_s888)
	_s888["st"] = Callable(self, "_f380").bind(_s888)
	_s888["nameOf"] = Callable(self, "_f381").bind(_s888)
	_s888["pct"] = Callable(self, "_f382").bind(_s888)
	_s888["craftCost"] = Callable(self, "_f383").bind(_s888)
	_s888["upCost"] = Callable(self, "_f384").bind(_s888)
	_s888["canPayAll"] = Callable(self, "_f385").bind(_s888)
	_s888["payAll"] = Callable(self, "_f387").bind(_s888)
	_s888["costHTML"] = Callable(self, "_f388").bind(_s888)
	_s888["held"] = Callable(self, "_f390").bind(_s888)
	_s888["unitMul"] = Callable(self, "_f392").bind(_s888)
	v_gpMul_1912 = Callable(self, "_f393").bind(_s888)
	v_crewBuff_1913 = Callable(self, "_f394").bind(_s888)
	_s888["effText"] = Callable(self, "_f395").bind(_s888)
	_s888["icon"] = Callable(self, "_f396").bind(_s888)
	v_open_1918 = Callable(self, "_f397").bind(_s888)
	_s888["render"] = Callable(self, "_f398").bind(_s888)
	_s888["keep"] = Callable(self, "_f418").bind(_s888)
	_s888["SLOTS"] = {"wea": "武器", "arm": "衣服", "acc": "掛繩"}
	_s888["NAMES"] = {"wea": [["尖嘴釘書機", "三層鐵飯盒", "午睡抱枕"], ["雷射筆", "外賣保溫袋", "人體工學辦公椅"], ["機械鍵盤", "保溫咖啡壺", "熱水袋"], ["碎紙機", "自助餐夾", "按摩槌"], ["投影遙控器", "火鍋長筷", "U 型頸枕"], ["總裁鋼筆", "金飯碗", "躺平床墊"]], "arm": [["舊恤衫", "油漬圍裙", "珊瑚絨睡衣"], ["保安制服", "外賣制服", "酒店浴袍"], ["二手西裝", "廚師服", "毛毯斗篷"], ["即棄雨衣", "大胃王戰衣", "懶人睡袋"], ["公司風褸", "食評家背心", "連身睡衣"], ["總監西裝", "星級廚袍", "五星浴袍"]], "acc": [["實習生證"], ["正式員工證"], ["組長證"], ["主任證"], ["經理證"], ["總監證"]]}
	_s888["FK"] = ["yuan", "chan", "lan"]
	_s888["WIMG"] = [["w_stapler", "w_tiffin", "w_pillow"], ["w_laser", "w_bag", "w_chair"], ["w_keyboard", "w_coffee", "w_bottle"], ["w_shredder", "w_tongs", "w_hammer"], ["w_remote", "w_chopsticks", "w_neck"], ["w_pen", "w_goldbowl", "w_mattress"]]
	_s888["WSTY"] = [["shoot", "smash", "spin"], ["beam", "drain", "spin"], ["combo", "splash", "flail"], ["combo", "pull", "smash"], ["beam", "poke", "spin"], ["poke", "smash", "slam"]]
	_s888["STY"] = {"shoot": {"rng": 180.0, "aspd": 0.6, "n": "連射", "d": "遠距離連發三粒釘，射完退半步。"}, "smash": {"rng": 62.0, "aspd": 1.25, "n": "重砸", "d": "衝前一下砸落地，震開身邊一圈。"}, "spin": {"rng": 72.0, "aspd": 1.05, "n": "迴旋", "d": "原地轉一圈，掃中身邊所有敵人。"}, "beam": {"rng": 230.0, "aspd": 1.0, "n": "光束", "d": "一條直線射穿，線上全部中。"}, "drain": {"rng": 62.0, "aspd": 1.15, "n": "吸魂砸", "d": "砸中會吸返血。"}, "combo": {"rng": 56.0, "aspd": 0.75, "n": "三連", "d": "快手連打三下，最後一下打飛。"}, "splash": {"rng": 160.0, "aspd": 1.15, "n": "潑", "d": "拋過去潑一地，範圍傷害兼減慢。"}, "flail": {"rng": 95.0, "aspd": 1.0, "n": "流星錘", "d": "甩住大圈轉，範圍最大。"}, "pull": {"rng": 150.0, "aspd": 1.0, "n": "夾過嚟", "d": "遠處夾住敵人拉到面前再打。"}, "poke": {"rng": 115.0, "aspd": 0.7, "n": "長刺", "d": "一路刺過去，穿兩隻。"}, "slam": {"rng": 80.0, "aspd": 1.5, "n": "壓扁", "d": "成張床墊壓落去，大範圍，壓暈。"}}
	_s888["back"] = null
	_s888["tab"] = "wea"
	return {"open": v_open_1918, "unitMul": _s888["unitMul"], "gpMul": v_gpMul_1912, "crewBuff": v_crewBuff_1913, "held": _s888["held"], "nameOf": _s888["nameOf"], "pct": _s888["pct"], "SLOTS": _s888["SLOTS"], "weaponOf": v_weaponOf_1899, "armorOf": v_armorOf_1900, "badgeOf": v_badgeOf_1901, "STY": _s888["STY"], "WIMG": _s888["WIMG"]}
