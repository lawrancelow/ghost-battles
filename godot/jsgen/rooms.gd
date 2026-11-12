# 自動轉譯自 rooms.js（tools/jsgd.js）——唔好直接改，改原 JS 再轉
extends RefCounted

func run(env):
	var this_ = null; var a = []
	J.G["OFFMAP"] = J.cl(Callable(self, "_f1").bind(env), null, [])

func _f16(this_, a: Array, env):
	var v_im_76 = null; var v_c_77 = null; var v_x_78 = null; var v_k_79 = null; var v_g_80 = null; var v_w_81 = null
	if J.t(env["PANO"]):
		return env["PANO"]
	var _t1 = env["ok"]
	if (not J.t(J.cl(_t1, null, ["bg_office_pano"]))):
		return null
	v_im_76 = J.gp(J.G.get("SPR"), "bg_office_pano")
	v_c_77 = J.S_document_("createElement", ["canvas"])
	var _t2 = J.gp(v_im_76, "naturalWidth")
	J.sp(v_c_77, "width", _t2)
	var _t3 = J.gp(v_im_76, "naturalHeight")
	J.sp(v_c_77, "height", _t3)
	v_x_78 = J.mc(v_c_77, "getContext", ["2d"])
	v_k_79 = J.div(J.gp(v_c_77, "height"), env["SH"])
	J.mc(v_x_78, "drawImage", [v_im_76, 0.0, 0.0])
	J.sp(v_x_78, "globalCompositeOperation", "multiply")
	J.sp(v_x_78, "fillStyle", "rgb(118,110,170)")
	v_g_80 = J.mc(v_x_78, "createLinearGradient", [0.0, J.mul(J.gp(v_c_77, "height"), 0.62), 0.0, J.gp(v_c_77, "height")])
	J.mc(v_g_80, "addColorStop", [0.0, "rgb(255,255,255)"])
	J.mc(v_g_80, "addColorStop", [1.0, "rgb(160,152,186)"])
	J.sp(v_x_78, "fillStyle", v_g_80)
	J.mc(v_x_78, "fillRect", [0.0, J.mul(J.gp(v_c_77, "height"), 0.62), J.gp(v_c_77, "width"), J.mul(J.gp(v_c_77, "height"), 0.38)])
	J.sp(v_x_78, "globalCompositeOperation", "screen")
	J.sp(v_x_78, "globalAlpha", 0.45)
	for _t4 in J.iter(env["WIN"]):
		v_w_81 = _t4
		J.mc(v_x_78, "drawImage", [v_im_76, J.mul(J.gp(v_w_81, 0.0), v_k_79), J.mul(J.gp(v_w_81, 1.0), v_k_79), J.mul(J.gp(v_w_81, 2.0), v_k_79), J.mul(J.gp(v_w_81, 3.0), v_k_79), J.mul(J.gp(v_w_81, 0.0), v_k_79), J.mul(J.gp(v_w_81, 1.0), v_k_79), J.mul(J.gp(v_w_81, 2.0), v_k_79), J.mul(J.gp(v_w_81, 3.0), v_k_79)])
	env["PANO"] = v_c_77
	return env["PANO"]

func _f17(this_, a: Array, env):
	var v_id_84 = null; var v_a_85 = null; var v_fill_86 = null; var v_src_87 = null; var v_k_88 = null; var v_c_89 = null; var v_f_90 = null; var v_fx_91 = null; var v_L_92 = null; var v_Rr_93 = null; var v_y_94 = null; var v_g_95 = null
	v_id_84 = J.arg(a, 0)
	v_a_85 = J.arg(a, 1)
	v_fill_86 = J.arg(a, 2)
	if J.t(J.gp(env["CROP"], v_id_84)):
		return J.gp(env["CROP"], v_id_84)
	v_src_87 = J.cl(env["pano"], null, [])
	if (not J.t(v_src_87)):
		return null
	v_k_88 = J.div(J.gp(v_src_87, "height"), env["SH"])
	v_c_89 = J.S_document_("createElement", ["canvas"])
	var _t5 = J.round(J.num(J.mul(J.gp(v_a_85, 2.0), v_k_88)))
	J.sp(v_c_89, "width", _t5)
	var _t6 = J.round(J.num(J.mul(J.gp(v_a_85, 3.0), v_k_88)))
	J.sp(v_c_89, "height", _t6)
	var _t7 = J.mc(v_c_89, "getContext", ["2d"])
	var _t8 = env["Rp"]
	J.mc(_t7, "drawImage", [v_src_87, J.mul(J.cl(_t8, null, [J.gp(v_a_85, 0.0)]), v_k_88), J.mul(J.gp(v_a_85, 1.0), v_k_88), J.mul(J.gp(v_a_85, 2.0), v_k_88), J.mul(J.gp(v_a_85, 3.0), v_k_88), 0.0, 0.0, J.gp(v_c_89, "width"), J.gp(v_c_89, "height")])
	v_f_90 = null
	if J.t(v_fill_86):
		var _t9 = J.S_document_("createElement", ["canvas"])
		v_f_90 = _t9
		var _t10 = J.gp(v_c_89, "width")
		J.sp(v_f_90, "width", _t10)
		var _t11 = J.gp(v_c_89, "height")
		J.sp(v_f_90, "height", _t11)
		v_fx_91 = J.mc(v_f_90, "getContext", ["2d"])
		var _t12 = J.mc(v_src_87, "getContext", ["2d"])
		var _t13 = env["Rp"]
		var _t14 = env["Rp"]
		v_L_92 = J.gp(J.mc(_t12, "getImageData", [J.max_([0.0, (J.mul(J.cl(_t14, null, [J.gp(v_a_85, 0.0)]), v_k_88) - 2.0)]), J.mul(J.gp(v_a_85, 1.0), v_k_88), 1.0, J.gp(v_c_89, "height")]), "data")
		var _t15 = J.mc(v_src_87, "getContext", ["2d"])
		var _t17 = J.sub(J.gp(v_src_87, "width"), 1.0)
		var _t16 = env["Rp"]
		var _t19 = J.sub(J.gp(v_src_87, "width"), 1.0)
		var _t18 = env["Rp"]
		v_Rr_93 = J.gp(J.mc(_t15, "getImageData", [J.min_([_t19, (J.mul(J.add(J.cl(_t18, null, [J.gp(v_a_85, 0.0)]), J.gp(v_a_85, 2.0)), v_k_88) + 2.0)]), J.mul(J.gp(v_a_85, 1.0), v_k_88), 1.0, J.gp(v_c_89, "height")]), "data")
		v_y_94 = 0.0
		while true:
			if not J.cmp(v_y_94, J.gp(v_c_89, "height"), "<"): break
			v_g_95 = J.mc(v_fx_91, "createLinearGradient", [0.0, 0.0, J.gp(v_c_89, "width"), 0.0])
			J.mc(v_g_95, "addColorStop", [0.0, ("rgb(" + J.str(J.gp(v_L_92, J.mul(v_y_94, 4.0))) + "," + J.str(J.gp(v_L_92, (J.mul(v_y_94, 4.0) + 1.0))) + "," + J.str(J.gp(v_L_92, (J.mul(v_y_94, 4.0) + 2.0))) + ")")])
			J.mc(v_g_95, "addColorStop", [1.0, ("rgb(" + J.str(J.gp(v_Rr_93, J.mul(v_y_94, 4.0))) + "," + J.str(J.gp(v_Rr_93, (J.mul(v_y_94, 4.0) + 1.0))) + "," + J.str(J.gp(v_Rr_93, (J.mul(v_y_94, 4.0) + 2.0))) + ")")])
			J.sp(v_fx_91, "fillStyle", v_g_95)
			J.mc(v_fx_91, "fillRect", [0.0, v_y_94, J.gp(v_c_89, "width"), 1.0])
			v_y_94 = J.num(v_y_94) + 1.0
	var _t20 = env["CROP"]
	var _t21 = {"c": v_c_89, "f": v_f_90}
	J.sp(_t20, v_id_84, _t21)
	return _t21

func _f18(this_, a: Array, env):
	var v_k_98 = null; var v_im_99 = null; var v_c_100 = null; var v_x_101 = null
	v_k_98 = J.arg(a, 0)
	if J.t(J.gp(env["TC"], v_k_98)):
		return J.gp(env["TC"], v_k_98)
	var _t22 = env["ok"]
	if (not J.t(J.cl(_t22, null, [v_k_98]))):
		return null
	v_im_99 = J.gp(J.G.get("SPR"), v_k_98)
	v_c_100 = J.S_document_("createElement", ["canvas"])
	var _t23 = J.gp(v_im_99, "naturalWidth")
	J.sp(v_c_100, "width", _t23)
	var _t24 = J.gp(v_im_99, "naturalHeight")
	J.sp(v_c_100, "height", _t24)
	v_x_101 = J.mc(v_c_100, "getContext", ["2d"])
	J.mc(v_x_101, "drawImage", [v_im_99, 0.0, 0.0])
	J.sp(v_x_101, "globalCompositeOperation", "source-atop")
	J.sp(v_x_101, "fillStyle", "rgba(26,18,58,.30)")
	J.mc(v_x_101, "fillRect", [0.0, 0.0, J.gp(v_c_100, "width"), J.gp(v_c_100, "height")])
	var _t25 = env["TC"]
	J.sp(_t25, v_k_98, v_c_100)
	return v_c_100

func _f19(this_, a: Array, env):
	var v_ctx_104 = null; var v_x_105 = null; var v_y_106 = null; var v_s_107 = null; var v_sz_108 = null; var v_a_109 = null
	v_ctx_104 = J.arg(a, 0)
	v_x_105 = J.arg(a, 1)
	v_y_106 = J.arg(a, 2)
	v_s_107 = J.arg(a, 3)
	v_sz_108 = J.arg(a, 4)
	v_a_109 = J.arg(a, 5)
	if J.cmp(v_a_109, 0.01, "<="):
		return null
	J.mc(v_ctx_104, "save", [])
	var _t26 = J.mul(J.gp(v_ctx_104, "globalAlpha"), J.min_([1.0, v_a_109]))
	J.sp(v_ctx_104, "globalAlpha", _t26)
	var _t27 = ("900 " + J.str(J.round(J.num(v_sz_108))) + "px sans-serif")
	J.sp(v_ctx_104, "font", _t27)
	J.sp(v_ctx_104, "textAlign", "center")
	J.sp(v_ctx_104, "lineWidth", 3.0)
	J.sp(v_ctx_104, "strokeStyle", "#1a1020")
	J.mc(v_ctx_104, "strokeText", [v_s_107, v_x_105, v_y_106])
	J.sp(v_ctx_104, "fillStyle", "#fff3d0")
	J.mc(v_ctx_104, "fillText", [v_s_107, v_x_105, v_y_106])
	J.mc(v_ctx_104, "restore", [])

func _f22(this_, a: Array, env):
	var v_x_118 = null; var v_y_119 = null; var v_i_120 = null
	var _t29 = J.gp(J.arg(a, 0), 0.0)
	v_x_118 = _t29
	var _t30 = J.gp(J.arg(a, 0), 1.0)
	v_y_119 = _t30
	v_i_120 = J.arg(a, 1)
	return {"x": v_x_118, "y": v_y_119, "ox": 0.0, "oz": 0.0, "vx": 0.0, "vz": 0.0, "sw": (0.4 if J.t(v_i_120) else (-0.3)), "vs": 0.0}

func _f21(this_, a: Array, env):
	var v_S_117 = null
	v_S_117 = J.arg(a, 0)
	env["SC"] = v_S_117
	var _t28 = J.gp(env["A"], "spare")
	var _t31 = {"t": 0.0, "micro": 0.0, "fridge": 0.0, "vend": 0.0, "can": null, "kettle": 0.0, "tv": 0.0, "speaker": 0.0, "chairs": 0.0, "golf": null, "bchair": 0.0, "trophy": null, "lights": null, "ac": null, "spare": J.mc(_t28, "map", [Callable(self, "_f22").bind(env)])}
	env["st"] = _t31

func _f23(this_, a: Array, env):
	var v_dt_123 = null; var v_k_124 = null; var v_c_125 = null; var v_g_126 = null; var v_k_127 = null; var v_e_128 = null; var v_T_129 = null; var v_c_130 = null; var v_dx_131 = null; var v_dz_132 = null; var v_d_133 = null
	v_dt_123 = J.arg(a, 0)
	if (not J.t(env["st"])):
		return null
	var _t32 = env["st"]
	var _t33 = J.add(J.gp(_t32, "t"), v_dt_123)
	J.sp(_t32, "t", _t33)
	for _t34 in J.iter(["micro", "fridge", "vend", "kettle", "tv", "speaker", "chairs", "bchair"]):
		v_k_124 = _t34
		var _t35 = env["st"]
		var _t36 = J.max_([0.0, J.sub(J.gp(env["st"], v_k_124), v_dt_123)])
		J.sp(_t35, v_k_124, _t36)
	if J.t(J.gp(env["st"], "lights")):
		var _t37 = J.gp(env["st"], "lights")
		var _t38 = J.add(J.gp(_t37, "t"), v_dt_123)
		J.sp(_t37, "t", _t38)
		if J.cmp(J.gp(J.gp(env["st"], "lights"), "t"), 3.6, ">"):
			var _t39 = env["st"]
			J.sp(_t39, "lights", null)
	if J.t(J.gp(env["st"], "ac")):
		var _t40 = J.gp(env["st"], "ac")
		var _t41 = J.add(J.gp(_t40, "t"), v_dt_123)
		J.sp(_t40, "t", _t41)
		if J.cmp(J.gp(J.gp(env["st"], "ac"), "t"), 2.6, ">"):
			var _t42 = env["st"]
			J.sp(_t42, "ac", null)
	if J.t(J.gp(env["st"], "can")):
		v_c_125 = J.gp(env["st"], "can")
		var _t43 = J.add(J.gp(v_c_125, "t"), v_dt_123)
		J.sp(v_c_125, "t", _t43)
		if J.cmp(J.gp(v_c_125, "t"), 0.35, ">"):
			var _t44 = J.add(J.gp(v_c_125, "x"), J.mul(J.gp(v_c_125, "vx"), v_dt_123))
			J.sp(v_c_125, "x", _t44)
			var _t45 = J.mul(J.gp(v_c_125, "vx"), exp(J.num(((-J.num(v_dt_123)) * 0.9))))
			J.sp(v_c_125, "vx", _t45)
			var _t46 = J.add(J.gp(v_c_125, "rot"), (J.mul(J.gp(v_c_125, "vx"), v_dt_123) * 60.0))
			J.sp(v_c_125, "rot", _t46)
		if J.cmp(J.gp(v_c_125, "t"), 9.0, ">"):
			var _t47 = env["st"]
			J.sp(_t47, "can", null)
	if J.t(J.gp(env["st"], "golf")):
		v_g_126 = J.gp(env["st"], "golf")
		var _t48 = J.add(J.gp(v_g_126, "t"), v_dt_123)
		J.sp(v_g_126, "t", _t48)
		v_k_127 = J.min_([1.0, J.div(J.gp(v_g_126, "t"), 2.4)])
		v_e_128 = (1.0 - pow(J.num(J.sub(1.0, v_k_127)), J.num(2.2)))
		var _t49 = J.add(J.gp(v_g_126, "x0"), J.mul(J.sub(J.gp(v_g_126, "x1"), J.gp(v_g_126, "x0")), v_e_128))
		J.sp(v_g_126, "x", _t49)
		var _t50 = J.add(J.gp(v_g_126, "y0"), J.mul(J.sub(J.gp(v_g_126, "y1"), J.gp(v_g_126, "y0")), v_e_128))
		J.sp(v_g_126, "y", _t50)
		var _t51 = J.add(J.gp(v_g_126, "rot"), (J.mul(v_dt_123, 18.0) * J.sub(1.0, v_k_127)))
		J.sp(v_g_126, "rot", _t51)
		if J.cmp(J.gp(v_g_126, "t"), 9.0, ">"):
			var _t52 = env["st"]
			J.sp(_t52, "golf", null)
	if J.t(J.gp(env["st"], "trophy")):
		v_T_129 = J.gp(env["st"], "trophy")
		var _t53 = J.add(J.gp(v_T_129, "t"), v_dt_123)
		J.sp(v_T_129, "t", _t53)
		if J.cmp(J.gp(v_T_129, "t"), 0.35, ">"):
			var _t54 = J.add(J.gp(v_T_129, "vy"), J.mul(2.4, v_dt_123))
			J.sp(v_T_129, "vy", _t54)
			var _t55 = J.add(J.gp(v_T_129, "y"), J.mul(J.gp(v_T_129, "vy"), v_dt_123))
			J.sp(v_T_129, "y", _t55)
			var _t56 = J.add(J.gp(v_T_129, "rot"), J.mul(J.gp(v_T_129, "vr"), v_dt_123))
			J.sp(v_T_129, "rot", _t56)
			if J.cmp(J.gp(v_T_129, "y"), J.gp(v_T_129, "floor"), ">="):
				var _t57 = J.gp(v_T_129, "floor")
				J.sp(v_T_129, "y", _t57)
				var _t58 = J.cmp(J.gp(v_T_129, "b"), 1.0, "<")
				if (J.cmp(J.gp(v_T_129, "vy"), 0.3, ">") if _t58 else _t58):
					var _t59 = ((-J.num(J.gp(v_T_129, "vy"))) * 0.25)
					J.sp(v_T_129, "vy", _t59)
					J.sp(v_T_129, "b", J.num(J.gp(v_T_129, "b")) + 1.0)
					var _t60 = J.gp(v_T_129, "t")
					J.sp(v_T_129, "land", _t60)
				else:
					J.sp(v_T_129, "vy", 0.0)
					J.sp(v_T_129, "vr", 0.0)
					var _t61 = J.add(J.gp(v_T_129, "rest"), v_dt_123)
					J.sp(v_T_129, "rest", _t61)
					var _t62 = J.add(J.gp(v_T_129, "rot"), (J.sub(J.div(PI, 2.0), J.gp(v_T_129, "rot")) * J.min_([1.0, J.mul(v_dt_123, 8.0)])))
					J.sp(v_T_129, "rot", _t62)
		if J.cmp(J.gp(v_T_129, "rest"), 10.0, ">"):
			var _t63 = env["st"]
			J.sp(_t63, "trophy", null)
			var _t64 = env["st"]
			J.sp(_t64, "trophyBack", 0.6)
	var _t65 = env["st"]
	var _t66 = J.gp(env["st"], "trophyBack")
	var _t67 = J.gp(env["st"], "trophyBack")
	var _t68 = J.max_([0.0, J.sub((_t67 if J.t(_t67) else 0.0), v_dt_123)])
	J.sp(_t65, "trophyBack", _t68)
	for _t69 in J.iter(J.gp(env["st"], "spare")):
		v_c_130 = _t69
		var _t70 = J.cmp(J.gp(env["st"], "chairs"), 0.0, ">")
		if J.t((J.gp(v_c_130, "tgt") if _t70 else _t70)):
			v_dx_131 = J.sub(J.gp(J.gp(v_c_130, "tgt"), "x"), J.add(J.gp(v_c_130, "x"), J.gp(v_c_130, "ox")))
			v_dz_132 = J.sub(J.add(J.gp(J.gp(v_c_130, "tgt"), "y"), J.gp(v_c_130, "dy")), J.add(J.gp(v_c_130, "y"), J.gp(v_c_130, "oz")))
			v_d_133 = J.hypot_([v_dx_131, v_dz_132])
			if J.cmp(v_d_133, 0.09, ">"):
				var _t71 = J.add(J.gp(v_c_130, "vx"), J.mul((J.div(v_dx_131, v_d_133) * 0.5), v_dt_123))
				J.sp(v_c_130, "vx", _t71)
				var _t72 = J.add(J.gp(v_c_130, "vz"), J.mul((J.div(v_dz_132, v_d_133) * 0.3), v_dt_123))
				J.sp(v_c_130, "vz", _t72)
			var _t73 = ((1.0 if J.cmp(J.gp(v_c_130, "vs"), 0.0, ">=") else (-1.0)) * J.max_([absf(J.num(J.gp(v_c_130, "vs"))), 5.0]))
			J.sp(v_c_130, "vs", _t73)
		var _t74 = J.add(J.gp(v_c_130, "ox"), J.mul(J.gp(v_c_130, "vx"), v_dt_123))
		J.sp(v_c_130, "ox", _t74)
		var _t75 = J.add(J.gp(v_c_130, "oz"), J.mul(J.gp(v_c_130, "vz"), v_dt_123))
		J.sp(v_c_130, "oz", _t75)
		var _t76 = J.mul(J.gp(v_c_130, "vx"), exp(J.num(((-J.num(v_dt_123)) * 1.6))))
		J.sp(v_c_130, "vx", _t76)
		var _t77 = J.mul(J.gp(v_c_130, "vz"), exp(J.num(((-J.num(v_dt_123)) * 1.6))))
		J.sp(v_c_130, "vz", _t77)
		var _t78 = J.add(J.gp(v_c_130, "sw"), J.mul(J.gp(v_c_130, "vs"), v_dt_123))
		J.sp(v_c_130, "sw", _t78)
		var _t79 = J.mul(J.gp(v_c_130, "vs"), exp(J.num(((-J.num(v_dt_123)) * 1.2))))
		J.sp(v_c_130, "vs", _t79)
		if J.cmp(J.gp(env["st"], "chairs"), 0.0, "<="):
			var _t80 = J.add(J.gp(v_c_130, "ox"), (J.mul((-J.num(J.gp(v_c_130, "ox"))), v_dt_123) * 0.3))
			J.sp(v_c_130, "ox", _t80)
			var _t81 = J.add(J.gp(v_c_130, "oz"), (J.mul((-J.num(J.gp(v_c_130, "oz"))), v_dt_123) * 0.3))
			J.sp(v_c_130, "oz", _t81)
			if (absf(J.num(J.gp(v_c_130, "vs"))) < 0.6):
				var _t82 = J.add(J.gp(v_c_130, "sw"), (J.sub((J.mul((J.round(J.num(J.div(J.gp(v_c_130, "sw"), J.mul(2.0, env["PI"])))) * 2.0), env["PI"]) + ((-0.3) if J.seq(v_c_130, J.gp(J.gp(env["st"], "spare"), 0.0)) else 0.4)), J.gp(v_c_130, "sw")) * J.min_([1.0, J.mul(v_dt_123, 2.0)])))
				J.sp(v_c_130, "sw", _t82)

func _f25(this_, a: Array, env):
	var v_c_140 = null; var v_i_141 = null
	v_c_140 = J.arg(a, 0)
	v_i_141 = J.arg(a, 1)
	var _t95 = env["n"]
	if not J.t(_t95):
		var _t94 = env["__p"]["px"]
		_t95 = {"x": J.cl(_t94, null, [5000.0]), "y": 0.78}
	J.sp(v_c_140, "tgt", _t95)
	var _t96 = (0.05 if J.t(v_i_141) else (-0.03))
	J.sp(v_c_140, "dy", _t96)
	var _t97 = (6.0 if J.t(v_i_141) else (-6.0))
	J.sp(v_c_140, "vs", _t97)

func _f24(this_, a: Array, env):
	var v_k_136 = null; var v_room_138 = null; var v_s_139 = null; var v_x0_142 = null; var v_y0_143 = null; var v_x1_144 = null; var v_y1_145 = null; var v_a_146 = null
	var _s48 = {"__p": env, "n": null}
	v_k_136 = J.arg(a, 0)
	_s48["n"] = J.arg(a, 1)
	v_room_138 = J.arg(a, 2)
	if (not J.t(_s48["__p"]["st"])):
		return null
	if J.seq(v_k_136, "micro"):
		var _t83 = _s48["__p"]["st"]
		J.sp(_t83, "micro", 2.6)
	if J.seq(v_k_136, "fridge"):
		var _t84 = _s48["__p"]["st"]
		J.sp(_t84, "fridge", 3.2)
	if J.seq(v_k_136, "vend"):
		var _t85 = _s48["__p"]["st"]
		J.sp(_t85, "vend", 2.2)
		v_s_139 = J.gp(_s48["__p"]["A"], "vendSlot")
		var _t86 = _s48["__p"]["st"]
		var _t87 = _s48["__p"]["px"]
		var _t88 = {"x": J.cl(_t87, null, [J.add(J.gp(v_s_139, 0.0), J.mul(J.gp(v_s_139, 2.0), 0.4))]), "y": 0.645, "t": 0.0, "vx": (-(0.12 + (randf() * 0.05))), "rot": 0.0}
		J.sp(_t86, "can", _t88)
	if J.seq(v_k_136, "kettle"):
		var _t89 = _s48["__p"]["st"]
		J.sp(_t89, "kettle", 3.0)
	if J.seq(v_k_136, "tv"):
		var _t90 = _s48["__p"]["st"]
		J.sp(_t90, "tv", 2.8)
	if J.seq(v_k_136, "speaker"):
		var _t91 = _s48["__p"]["st"]
		J.sp(_t91, "speaker", 3.0)
	if J.seq(v_k_136, "chairs"):
		var _t92 = _s48["__p"]["st"]
		J.sp(_t92, "chairs", 3.2)
		var _t93 = J.gp(_s48["__p"]["st"], "spare")
		J.mc(_t93, "forEach", [Callable(self, "_f25").bind(_s48)])
	if J.seq(v_k_136, "golf"):
		var _t98 = _s48["__p"]["px"]
		v_x0_142 = J.cl(_t98, null, [120.0])
		v_y0_143 = 0.69
		var _t100 = null
		if J.t(_s48["n"]):
			_t100 = J.add(J.gp(_s48["n"], "x"), ((-0.08) if J.cmp(J.gp(_s48["n"], "x"), v_x0_142, ">") else 0.08))
		else:
			var _t99 = _s48["__p"]["px"]
			_t100 = J.cl(_t99, null, [700.0])
		v_x1_144 = _t100
		v_y1_145 = (J.add(J.gp(_s48["n"], "y"), 0.01) if J.t(_s48["n"]) else 0.75)
		var _t101 = _s48["__p"]["st"]
		var _t102 = {"x0": v_x0_142, "y0": v_y0_143, "x1": v_x1_144, "y1": v_y1_145, "x": v_x0_142, "y": v_y0_143, "t": 0.0, "rot": 0.0}
		J.sp(_t101, "golf", _t102)
	if J.seq(v_k_136, "bchair"):
		var _t103 = _s48["__p"]["st"]
		J.sp(_t103, "bchair", 2.8)
	if J.seq(v_k_136, "trophy"):
		v_a_146 = J.gp(_s48["__p"]["A"], "trophy")
		var _t104 = _s48["__p"]["st"]
		var _t105 = _s48["__p"]["px"]
		var _t107 = J.cl(_t105, null, [J.add(J.gp(v_a_146, 0.0), J.div(J.gp(v_a_146, 2.0), 2.0))])
		var _t106 = _s48["__p"]["py"]
		var _t108 = {"x": _t107, "y": J.cl(_t106, null, [J.add(J.gp(v_a_146, 1.0), J.gp(v_a_146, 3.0))]), "floor": 0.655, "vy": (-0.2), "vr": 3.5, "rot": 0.0, "t": 0.0, "b": 0.0, "rest": 0.0, "land": (-1.0)}
		J.sp(_t104, "trophy", _t108)
	if J.seq(v_k_136, "lights"):
		var _t109 = _s48["__p"]["st"]
		var _t110 = {"t": 0.0, "room": (v_room_138 if J.t(v_room_138) else "main")}
		J.sp(_t109, "lights", _t110)
	if J.seq(v_k_136, "ac"):
		var _t111 = _s48["__p"]["st"]
		var _t112 = {"t": 0.0, "room": (v_room_138 if J.t(v_room_138) else "main")}
		J.sp(_t111, "ac", _t112)

func _f26(this_, a: Array, env):
	var v_ctx_149 = null; var v_t_150 = null; var v_c_151 = null; var v_b_152 = null; var v_k_153 = null; var v_sx_154 = null; var v_sw_155 = null; var v_y0_156 = null; var v_slab_157 = null; var v_g_158 = null; var v_px0_159 = null; var v_sg_160 = null; var v_i_161 = null; var v_bx_162 = null; var v_bh_163 = null; var v_bw_164 = null; var v_w_165 = null; var v_x_166 = null; var v_y_167 = null; var v_w_168 = null; var v_h_169 = null; var v_on_170 = null; var v_a_171 = null; var v_g_172 = null; var v_d_173 = null; var v_x_174 = null; var v_y_175 = null; var v_w_176 = null; var v_h_177 = null; var v_o_178 = null; var v_g_179 = null; var v_sw_180 = null; var v_i_181 = null; var v_i_182 = null; var v_q_183 = null; var v_fx_184 = null; var v_fy_185 = null; var v_r_186 = null; var v_gg_187 = null; var v_x_188 = null; var v_y_189 = null; var v_w_190 = null; var v_h_191 = null; var v_on_192 = null; var v_sx_193 = null; var v_sy_194 = null; var v_sw2_195 = null; var v_sh2_196 = null; var v_x_197 = null; var v_y_198 = null; var v_w_199 = null; var v_h_200 = null; var v_e_201 = null; var v_i_202 = null; var v_q_203 = null; var v_sx_204 = null; var v_sy_205 = null; var v_s_206 = null; var v_x0_207 = null; var v_y0_208 = null; var v_w0_209 = null; var v_h0_210 = null; var v_x_211 = null; var v_y_212 = null; var v_w_213 = null; var v_h_214 = null; var v_face_215 = null; var v_g_216 = null; var v_i_217 = null; var v_v_218 = null; var v_i_219 = null; var v_pc_220 = null; var v_sz_221 = null; var v_x_222 = null; var v_y_223 = null; var v_w_224 = null; var v_h_225 = null; var v_e_226 = null; var v_br_227 = null; var v_i_228 = null; var v_q_229 = null; var v_C_230 = null; var v_x_231 = null; var v_y_232 = null; var v_w_233 = null; var v_h_234 = null; var v_e_235 = null; var v_a_236 = null; var v_sc_237 = null; var v_C_238 = null; var v_x_239 = null; var v_y_240 = null; var v_w_241 = null; var v_h_242 = null
	v_ctx_149 = J.arg(a, 0)
	v_t_150 = J.arg(a, 1)
	v_c_151 = J.cl(env["pano"], null, [])
	v_b_152 = J.mc(env["SC"], "bgScale", [])
	if J.t(v_c_151):
		v_k_153 = J.div(J.gp(v_c_151, "height"), env["SH"])
		v_sx_154 = J.mul(J.mul(J.gp(env["SC"], "camX"), env["PXU"]), v_k_153)
		v_sw_155 = J.div(J.mul(J.gp(env["SC"], "W"), v_k_153), J.gp(v_b_152, "s"))
		J.mc(v_ctx_149, "drawImage", [v_c_151, v_sx_154, 0.0, v_sw_155, J.gp(v_c_151, "height"), 0.0, J.gp(v_b_152, "oy"), J.gp(env["SC"], "W"), J.mul(J.gp(v_b_152, "ih"), J.gp(v_b_152, "s"))])
		if J.cmp(J.gp(v_b_152, "oy"), 0.0, ">"):
			v_y0_156 = J.gp(v_b_152, "oy")
			v_slab_157 = J.max_([10.0, J.mul(J.gp(v_b_152, "s"), 34.0)])
			v_g_158 = J.mc(v_ctx_149, "createLinearGradient", [0.0, 0.0, 0.0, J.sub(v_y0_156, v_slab_157)])
			J.mc(v_g_158, "addColorStop", [0.0, "#0b0a1c"])
			J.mc(v_g_158, "addColorStop", [1.0, "#1d1838"])
			J.sp(v_ctx_149, "fillStyle", v_g_158)
			J.mc(v_ctx_149, "fillRect", [0.0, 0.0, J.gp(env["SC"], "W"), (J.sub(v_y0_156, v_slab_157) + 1.0)])
			J.mc(v_ctx_149, "save", [])
			v_px0_159 = J.mul(J.gp(env["SC"], "camX"), 140.0)
			v_i_161 = 0.0
			while true:
				if not J.cmp(v_i_161, 26.0, "<"): break
				v_bx_162 = (J.mod(J.add(J.add(J.mod(J.sub(J.mul(v_i_161, 97.0), v_px0_159), J.add(J.gp(env["SC"], "W"), 120.0)), J.gp(env["SC"], "W")), 120.0), J.add(J.gp(env["SC"], "W"), 120.0)) - 60.0)
				v_bh_163 = ((0.35 + J.div(J.mod(J.mul(v_i_161, 53.0), 10.0), 16.0)) * J.sub(v_y0_156, v_slab_157))
				v_bw_164 = (26.0 + J.mod(J.mul(v_i_161, 31.0), 30.0))
				J.sp(v_ctx_149, "fillStyle", "rgba(30,26,58,.9)")
				J.mc(v_ctx_149, "fillRect", [v_bx_162, J.sub(J.sub(v_y0_156, v_slab_157), v_bh_163), v_bw_164, v_bh_163])
				J.sp(v_ctx_149, "fillStyle", "rgba(255,214,140,.35)")
				v_w_165 = 0.0
				while true:
					if not J.cmp(v_w_165, 6.0, "<"): break
					if J.seq(J.mod((J.mul(v_i_161, 7.0) + J.mul(v_w_165, 3.0)), 5.0), 0.0):
						J.mc(v_ctx_149, "fillRect", [J.add(J.add(v_bx_162, 4.0), (J.mod(v_w_165, 3.0) * 7.0)), ((J.sub(J.sub(v_y0_156, v_slab_157), v_bh_163) + 6.0) + (floor(J.num(J.div(v_w_165, 3.0))) * 10.0)), 3.0, 4.0])
					v_w_165 = J.num(v_w_165) + 1.0
				v_i_161 = J.num(v_i_161) + 1.0
			J.mc(v_ctx_149, "restore", [])
			v_sg_160 = J.mc(v_ctx_149, "createLinearGradient", [0.0, J.sub(v_y0_156, v_slab_157), 0.0, v_y0_156])
			J.mc(v_sg_160, "addColorStop", [0.0, "#5a5068"])
			J.mc(v_sg_160, "addColorStop", [0.25, "#3c3448"])
			J.mc(v_sg_160, "addColorStop", [1.0, "#2a2434"])
			J.sp(v_ctx_149, "fillStyle", v_sg_160)
			J.mc(v_ctx_149, "fillRect", [0.0, J.sub(v_y0_156, v_slab_157), J.gp(env["SC"], "W"), v_slab_157])
			J.sp(v_ctx_149, "fillStyle", "rgba(255,255,255,.12)")
			J.mc(v_ctx_149, "fillRect", [0.0, J.sub(v_y0_156, v_slab_157), J.gp(env["SC"], "W"), 1.5])
			J.sp(v_ctx_149, "fillStyle", "rgba(0,0,0,.45)")
			J.mc(v_ctx_149, "fillRect", [0.0, J.sub(v_y0_156, 2.0), J.gp(env["SC"], "W"), 2.0])
	if (not J.t(env["st"])):
		return null
	if J.cmp(J.gp(env["st"], "micro"), 0.0, ">"):
		var _t113 = env["rect"]
		var _t114 = J.cl(_t113, null, [J.gp(env["A"], "microWin")])
		var _t115 = J.gp(_t114, 0.0)
		v_x_166 = _t115
		var _t116 = J.gp(_t114, 1.0)
		v_y_167 = _t116
		var _t117 = J.gp(_t114, 2.0)
		v_w_168 = _t117
		var _t118 = J.gp(_t114, 3.0)
		v_h_169 = _t118
		v_on_170 = (sin(J.num(J.mul(v_t_150, 40.0))) > (-0.6))
		J.mc(v_ctx_149, "save", [])
		J.sp(v_ctx_149, "globalCompositeOperation", "lighter")
		var _t119 = ("rgba(255,200,110," + J.str((0.75 if J.t(v_on_170) else 0.35)) + ")")
		J.sp(v_ctx_149, "fillStyle", _t119)
		J.mc(v_ctx_149, "fillRect", [v_x_166, v_y_167, v_w_168, v_h_169])
		J.sp(v_ctx_149, "strokeStyle", "rgba(255,240,200,.7)")
		J.sp(v_ctx_149, "lineWidth", 1.5)
		J.mc(v_ctx_149, "beginPath", [])
		J.mc(v_ctx_149, "ellipse", [J.add(v_x_166, J.div(v_w_168, 2.0)), J.add(v_y_167, J.mul(v_h_169, 0.75)), J.mul(v_w_168, 0.3), J.mul(v_h_169, 0.1), 0.0, 0.0, J.mul(env["PI"], 2.0)])
		J.mc(v_ctx_149, "stroke", [])
		v_a_171 = J.mul(v_t_150, 5.0)
		J.mc(v_ctx_149, "beginPath", [])
		J.mc(v_ctx_149, "moveTo", [J.add(v_x_166, J.div(v_w_168, 2.0)), J.add(v_y_167, J.mul(v_h_169, 0.75))])
		J.mc(v_ctx_149, "lineTo", [J.add(J.add(v_x_166, J.div(v_w_168, 2.0)), (J.mul(cos(J.num(v_a_171)), v_w_168) * 0.28)), J.add(J.add(v_y_167, J.mul(v_h_169, 0.75)), (J.mul(sin(J.num(v_a_171)), v_h_169) * 0.09))])
		J.mc(v_ctx_149, "stroke", [])
		v_g_172 = J.mc(v_ctx_149, "createRadialGradient", [J.add(v_x_166, J.div(v_w_168, 2.0)), J.add(v_y_167, J.div(v_h_169, 2.0)), 0.0, J.add(v_x_166, J.div(v_w_168, 2.0)), J.add(v_y_167, J.div(v_h_169, 2.0)), J.mul(v_w_168, 1.3)])
		J.mc(v_g_172, "addColorStop", [0.0, "rgba(255,190,100,.35)"])
		J.mc(v_g_172, "addColorStop", [1.0, "rgba(255,190,100,0)"])
		J.sp(v_ctx_149, "fillStyle", v_g_172)
		J.mc(v_ctx_149, "fillRect", [J.sub(v_x_166, v_w_168), J.sub(v_y_167, v_w_168), J.mul(v_w_168, 3.0), J.add(v_h_169, J.mul(v_w_168, 2.0))])
		J.mc(v_ctx_149, "restore", [])
		if J.cmp(J.gp(env["st"], "micro"), 0.7, "<"):
			var _t120 = env["text"]
			J.cl(_t120, null, [v_ctx_149, J.add(v_x_166, J.div(v_w_168, 2.0)), J.sub(v_y_167, J.mul(v_h_169, 0.3)), "叮！", J.mul(v_h_169, 0.75), J.div(J.gp(env["st"], "micro"), 0.7)])
		else:
			var _t121 = env["text"]
			J.cl(_t121, null, [v_ctx_149, J.add(v_x_166, J.div(v_w_168, 2.0)), J.sub(v_y_167, J.mul(v_h_169, 0.3)), "嗡——", J.mul(v_h_169, 0.5), 0.8])
	var _t122 = env["crop"]
	v_d_173 = J.cl(_t122, null, ["fdoor", J.gp(env["A"], "fridgeDoor")])
	var _t123 = env["rect"]
	var _t124 = J.cl(_t123, null, [J.gp(env["A"], "fridgeDoor")])
	var _t125 = J.gp(_t124, 0.0)
	v_x_174 = _t125
	var _t126 = J.gp(_t124, 1.0)
	v_y_175 = _t126
	var _t127 = J.gp(_t124, 2.0)
	v_w_176 = _t127
	var _t128 = J.gp(_t124, 3.0)
	v_h_177 = _t128
	v_o_178 = (J.min_([1.0, (J.sub(3.2, J.gp(env["st"], "fridge")) * 3.0), J.mul(J.gp(env["st"], "fridge"), 1.5)]) if J.cmp(J.gp(env["st"], "fridge"), 0.0, ">") else 0.0)
	var _t129 = J.cmp(v_o_178, 0.01, ">")
	if J.t((v_d_173 if _t129 else _t129)):
		J.mc(v_ctx_149, "save", [])
		v_g_179 = J.mc(v_ctx_149, "createLinearGradient", [v_x_174, v_y_175, v_x_174, J.add(v_y_175, v_h_177)])
		J.mc(v_g_179, "addColorStop", [0.0, "#eaf4ff"])
		J.mc(v_g_179, "addColorStop", [1.0, "#bcd2e8"])
		J.sp(v_ctx_149, "fillStyle", v_g_179)
		J.mc(v_ctx_149, "fillRect", [v_x_174, v_y_175, v_w_176, v_h_177])
		J.sp(v_ctx_149, "strokeStyle", "rgba(120,140,170,.8)")
		J.sp(v_ctx_149, "lineWidth", 2.0)
		v_i_181 = 1.0
		while true:
			if not J.cmp(v_i_181, 3.0, "<"): break
			J.mc(v_ctx_149, "beginPath", [])
			J.mc(v_ctx_149, "moveTo", [J.add(v_x_174, 4.0), J.add(v_y_175, J.div(J.mul(v_h_177, v_i_181), 3.0))])
			J.mc(v_ctx_149, "lineTo", [J.sub(J.add(v_x_174, v_w_176), 4.0), J.add(v_y_175, J.div(J.mul(v_h_177, v_i_181), 3.0))])
			J.mc(v_ctx_149, "stroke", [])
			v_i_181 = J.num(v_i_181) + 1.0
		J.sp(v_ctx_149, "fillStyle", "#d9c06a")
		J.mc(v_ctx_149, "fillRect", [J.add(v_x_174, J.mul(v_w_176, 0.2)), J.sub(J.add(v_y_175, J.div(v_h_177, 3.0)), J.mul(v_h_177, 0.12)), J.mul(v_w_176, 0.12), J.mul(v_h_177, 0.12)])
		J.sp(v_ctx_149, "fillStyle", "#e88")
		J.mc(v_ctx_149, "fillRect", [J.add(v_x_174, J.mul(v_w_176, 0.55)), J.sub(J.add(v_y_175, J.div(J.mul(v_h_177, 2.0), 3.0)), J.mul(v_h_177, 0.1)), J.mul(v_w_176, 0.2), J.mul(v_h_177, 0.1)])
		v_sw_180 = cos(J.num((J.mul(v_o_178, env["PI"]) * 0.62)))
		J.mc(v_ctx_149, "translate", [J.add(v_x_174, v_w_176), v_y_175])
		J.mc(v_ctx_149, "scale", [(-1.0), 1.0])
		J.mc(v_ctx_149, "drawImage", [J.gp(v_d_173, "c"), 0.0, 0.0, J.mul(v_w_176, J.max_([0.08, v_sw_180])), v_h_177])
		J.mc(v_ctx_149, "restore", [])
		J.mc(v_ctx_149, "save", [])
		var _t130 = J.mul(0.55, v_o_178)
		J.sp(v_ctx_149, "globalAlpha", _t130)
		v_i_182 = 0.0
		while true:
			if not J.cmp(v_i_182, 6.0, "<"): break
			v_q_183 = J.mod((J.mul(v_t_150, 0.5) + J.div(v_i_182, 6.0)), 1.0)
			v_fx_184 = J.add(v_x_174, J.mul(v_w_176, (0.2 + J.mul(0.12, v_i_182))))
			v_fy_185 = J.add(J.add(v_y_175, v_h_177), (J.mul(v_q_183, v_h_177) * 1.4))
			v_r_186 = J.mul(v_w_176, (0.18 + J.mul(v_q_183, 0.35)))
			v_gg_187 = J.mc(v_ctx_149, "createRadialGradient", [v_fx_184, v_fy_185, 0.0, v_fx_184, v_fy_185, v_r_186])
			J.mc(v_gg_187, "addColorStop", [0.0, "rgba(225,240,255,.6)"])
			J.mc(v_gg_187, "addColorStop", [1.0, "rgba(225,240,255,0)"])
			J.sp(v_ctx_149, "fillStyle", v_gg_187)
			J.mc(v_ctx_149, "beginPath", [])
			J.mc(v_ctx_149, "arc", [v_fx_184, v_fy_185, v_r_186, 0.0, J.mul(env["PI"], 2.0)])
			J.mc(v_ctx_149, "fill", [])
			v_i_182 = J.num(v_i_182) + 1.0
		J.mc(v_ctx_149, "restore", [])
	if J.cmp(J.gp(env["st"], "vend"), 0.0, ">"):
		var _t131 = env["rect"]
		var _t132 = J.cl(_t131, null, [J.gp(env["A"], "vendGlass")])
		var _t133 = J.gp(_t132, 0.0)
		v_x_188 = _t133
		var _t134 = J.gp(_t132, 1.0)
		v_y_189 = _t134
		var _t135 = J.gp(_t132, 2.0)
		v_w_190 = _t135
		var _t136 = J.gp(_t132, 3.0)
		v_h_191 = _t136
		v_on_192 = ((sin(J.num(J.mul(v_t_150, 33.0))) + sin(J.num(J.mul(v_t_150, 19.0)))) > 0.2)
		J.mc(v_ctx_149, "save", [])
		var _t137 = ("lighter" if J.t(v_on_192) else "source-over")
		J.sp(v_ctx_149, "globalCompositeOperation", _t137)
		var _t138 = ("rgba(200,240,255,.35)" if J.t(v_on_192) else "rgba(5,4,15,.6)")
		J.sp(v_ctx_149, "fillStyle", _t138)
		J.mc(v_ctx_149, "fillRect", [v_x_188, v_y_189, v_w_190, v_h_191])
		J.mc(v_ctx_149, "restore", [])
		var _t139 = env["rect"]
		var _t140 = J.cl(_t139, null, [J.gp(env["A"], "vendSlot")])
		var _t141 = J.gp(_t140, 0.0)
		v_sx_193 = _t141
		var _t142 = J.gp(_t140, 1.0)
		v_sy_194 = _t142
		var _t143 = J.gp(_t140, 2.0)
		v_sw2_195 = _t143
		var _t144 = J.gp(_t140, 3.0)
		v_sh2_196 = _t144
		if J.cmp(J.gp(env["st"], "vend"), 1.6, ">"):
			var _t145 = env["text"]
			J.cl(_t145, null, [v_ctx_149, J.add(v_sx_193, J.div(v_sw2_195, 2.0)), J.sub(v_sy_194, J.mul(v_sh2_196, 0.4)), "哐咚！", J.mul(v_sh2_196, 1.1), J.div(J.sub(J.gp(env["st"], "vend"), 1.6), 0.6)])
	if J.cmp(J.gp(env["st"], "kettle"), 0.0, ">"):
		var _t146 = env["rect"]
		var _t147 = J.cl(_t146, null, [J.gp(env["A"], "kettle")])
		var _t148 = J.gp(_t147, 0.0)
		v_x_197 = _t148
		var _t149 = J.gp(_t147, 1.0)
		v_y_198 = _t149
		var _t150 = J.gp(_t147, 2.0)
		v_w_199 = _t150
		var _t151 = J.gp(_t147, 3.0)
		v_h_200 = _t151
		v_e_201 = J.min_([1.0, J.gp(env["st"], "kettle"), (J.sub(3.0, J.gp(env["st"], "kettle")) * 2.0)])
		J.mc(v_ctx_149, "save", [])
		J.sp(v_ctx_149, "lineCap", "round")
		v_i_202 = 0.0
		while true:
			if not J.cmp(v_i_202, 5.0, "<"): break
			v_q_203 = J.mod((J.mul(v_t_150, 0.8) + J.div(v_i_202, 5.0)), 1.0)
			v_sx_204 = J.add(J.add(v_x_197, J.mul(v_w_199, 0.78)), (J.mul(sin(J.num(J.add(J.mul(v_t_150, 3.0), v_i_202))), v_w_199) * 0.15))
			v_sy_205 = J.sub(J.add(v_y_198, J.mul(v_h_200, 0.05)), (J.mul(v_q_203, v_h_200) * 2.4))
			var _t152 = ("rgba(245,245,250," + J.str((J.mul(0.6, v_e_201) * J.sub(1.0, v_q_203))) + ")")
			J.sp(v_ctx_149, "strokeStyle", _t152)
			var _t153 = J.mul(J.mul(v_w_199, 0.12), J.add(1.0, v_q_203))
			J.sp(v_ctx_149, "lineWidth", _t153)
			J.mc(v_ctx_149, "beginPath", [])
			J.mc(v_ctx_149, "moveTo", [v_sx_204, J.add(v_sy_205, J.mul(v_h_200, 0.2))])
			J.mc(v_ctx_149, "quadraticCurveTo", [J.add(v_sx_204, (J.mul(v_w_199, 0.3) * sin(J.num(J.add(J.mul(v_t_150, 2.0), v_i_202))))), v_sy_205, v_sx_204, J.sub(v_sy_205, J.mul(v_h_200, 0.2))])
			J.mc(v_ctx_149, "stroke", [])
			v_i_202 = J.num(v_i_202) + 1.0
		var _t154 = ("rgba(255,255,255," + J.str(J.mul(0.5, v_e_201)) + ")")
		J.sp(v_ctx_149, "strokeStyle", _t154)
		J.sp(v_ctx_149, "lineWidth", 1.5)
		for _t155 in J.iter([(-1.0), 1.0]):
			v_s_206 = _t155
			J.mc(v_ctx_149, "beginPath", [])
			J.mc(v_ctx_149, "arc", [J.add(v_x_197, J.div(v_w_199, 2.0)), J.add(v_y_198, J.div(v_h_200, 2.0)), (J.mul(v_w_199, 0.7) + (sin(J.num(J.mul(v_t_150, 30.0))) * 2.0)), ((-0.4) if J.cmp(v_s_206, 0.0, ">") else J.sub(env["PI"], 0.4)), (0.4 if J.cmp(v_s_206, 0.0, ">") else J.add(env["PI"], 0.4))])
			J.mc(v_ctx_149, "stroke", [])
		J.mc(v_ctx_149, "restore", [])
		var _t156 = env["text"]
		J.cl(_t156, null, [v_ctx_149, J.add(J.add(v_x_197, J.div(v_w_199, 2.0)), (sin(J.num(J.mul(v_t_150, 25.0))) * 2.0)), J.sub(v_y_198, J.mul(v_h_200, 1.6)), "嗚——", J.mul(v_h_200, 0.55), v_e_201])
	if J.cmp(J.gp(env["st"], "tv"), 0.0, ">"):
		var _t157 = env["rect"]
		var _t158 = J.cl(_t157, null, [J.gp(env["A"], "tv")])
		var _t159 = J.gp(_t158, 0.0)
		v_x0_207 = _t159
		var _t160 = J.gp(_t158, 1.0)
		v_y0_208 = _t160
		var _t161 = J.gp(_t158, 2.0)
		v_w0_209 = _t161
		var _t162 = J.gp(_t158, 3.0)
		v_h0_210 = _t162
		v_x_211 = J.add(v_x0_207, J.mul(v_w0_209, 0.035))
		v_y_212 = J.add(v_y0_208, J.mul(v_h0_210, 0.06))
		v_w_213 = J.mul(v_w0_209, 0.93)
		v_h_214 = J.mul(v_h0_210, 0.85)
		J.mc(v_ctx_149, "save", [])
		J.mc(v_ctx_149, "beginPath", [])
		J.mc(v_ctx_149, "rect", [v_x_211, v_y_212, v_w_213, v_h_214])
		J.mc(v_ctx_149, "clip", [])
		J.sp(v_ctx_149, "fillStyle", "rgba(70,70,90,.92)")
		J.mc(v_ctx_149, "fillRect", [v_x_211, v_y_212, v_w_213, v_h_214])
		v_i_217 = 0.0
		while true:
			if not J.cmp(v_i_217, 260.0, "<"): break
			v_v_218 = J.bor((randf() * 255.0), 0.0)
			var _t163 = ("rgba(" + J.str(v_v_218) + "," + J.str(v_v_218) + "," + J.str(J.add(v_v_218, 10.0)) + ",.9)")
			J.sp(v_ctx_149, "fillStyle", _t163)
			J.mc(v_ctx_149, "fillRect", [J.add(v_x_211, J.mul(randf(), v_w_213)), J.add(v_y_212, J.mul(randf(), v_h_214)), (2.0 + (randf() * 3.0)), 1.5])
			v_i_217 = J.num(v_i_217) + 1.0
		v_i_219 = 0.0
		while true:
			if not J.cmp(v_i_219, 4.0, "<"): break
			J.sp(v_ctx_149, "fillStyle", "rgba(255,255,255,.25)")
			J.mc(v_ctx_149, "fillRect", [v_x_211, J.add(v_y_212, J.mul(J.mod((J.mul(v_t_150, 0.7) + J.div(v_i_219, 4.0)), 1.0), v_h_214)), v_w_213, 2.0])
			v_i_219 = J.num(v_i_219) + 1.0
		var _t164 = J.cmp(J.gp(env["st"], "tv"), 1.6, "<")
		var _t165 = (J.cmp(J.gp(env["st"], "tv"), 0.6, ">") if _t164 else _t164)
		v_face_215 = ((sin(J.num(J.mul(v_t_150, 17.0))) > (-0.2)) if _t165 else _t165)
		var _t166 = ((not J.seq(J.typeof_(J.G.get("ART")), "undefined")) if J.t(v_face_215) else v_face_215)
		if J.t((J.gp(J.G.get("ART"), "portrait") if J.t(_t166) else _t166)):
			v_pc_220 = J.mc(J.G.get("ART"), "portrait", ["afu", 96.0, {"tamed": true}])
			v_sz_221 = J.mul(v_h_214, 0.9)
			J.sp(v_ctx_149, "globalAlpha", 0.55)
			J.sp(v_ctx_149, "globalCompositeOperation", "luminosity")
			J.mc(v_ctx_149, "drawImage", [v_pc_220, (J.sub(J.add(v_x_211, J.div(v_w_213, 2.0)), J.div(v_sz_221, 2.0)) + ((randf() - 0.5) * 4.0)), J.add(v_y_212, J.mul(v_h_214, 0.05)), v_sz_221, v_sz_221])
		J.mc(v_ctx_149, "restore", [])
		J.mc(v_ctx_149, "save", [])
		J.sp(v_ctx_149, "globalCompositeOperation", "lighter")
		v_g_216 = J.mc(v_ctx_149, "createRadialGradient", [J.add(v_x_211, J.div(v_w_213, 2.0)), J.add(v_y_212, J.div(v_h_214, 2.0)), 0.0, J.add(v_x_211, J.div(v_w_213, 2.0)), J.add(v_y_212, J.div(v_h_214, 2.0)), J.mul(v_w_213, 0.8)])
		J.mc(v_g_216, "addColorStop", [0.0, "rgba(200,210,255,.25)"])
		J.mc(v_g_216, "addColorStop", [1.0, "rgba(200,210,255,0)"])
		J.sp(v_ctx_149, "fillStyle", v_g_216)
		J.mc(v_ctx_149, "fillRect", [J.sub(v_x_211, J.mul(v_w_213, 0.3)), J.sub(v_y_212, J.mul(v_h_214, 0.3)), J.mul(v_w_213, 1.6), J.mul(v_h_214, 1.8)])
		J.mc(v_ctx_149, "restore", [])
		var _t167 = env["text"]
		J.cl(_t167, null, [v_ctx_149, J.add(v_x_211, J.mul(v_w_213, 0.85)), J.sub(v_y_212, J.mul(v_h_214, 0.08)), "沙沙沙", J.mul(v_h_214, 0.14), J.min_([1.0, J.gp(env["st"], "tv")])])
	if J.cmp(J.gp(env["st"], "speaker"), 0.0, ">"):
		var _t168 = env["rect"]
		var _t169 = J.cl(_t168, null, [J.gp(env["A"], "speaker")])
		var _t170 = J.gp(_t169, 0.0)
		v_x_222 = _t170
		var _t171 = J.gp(_t169, 1.0)
		v_y_223 = _t171
		var _t172 = J.gp(_t169, 2.0)
		v_w_224 = _t172
		var _t173 = J.gp(_t169, 3.0)
		v_h_225 = _t173
		v_e_226 = J.min_([1.0, J.gp(env["st"], "speaker"), (J.sub(3.0, J.gp(env["st"], "speaker")) * 3.0)])
		v_br_227 = (0.5 + (0.5 * sin(J.num(J.mul(v_t_150, 2.6)))))
		J.mc(v_ctx_149, "save", [])
		J.sp(v_ctx_149, "globalCompositeOperation", "lighter")
		v_i_228 = 0.0
		while true:
			if not J.cmp(v_i_228, 3.0, "<"): break
			v_q_229 = J.mod((J.mul(v_t_150, 0.6) + J.div(v_i_228, 3.0)), 1.0)
			var _t174 = ("rgba(140,255,170," + J.str((J.mul(0.6, v_e_226) * J.sub(1.0, v_q_229))) + ")")
			J.sp(v_ctx_149, "strokeStyle", _t174)
			J.sp(v_ctx_149, "lineWidth", 2.0)
			J.mc(v_ctx_149, "beginPath", [])
			J.mc(v_ctx_149, "ellipse", [J.add(v_x_222, J.div(v_w_224, 2.0)), J.add(v_y_223, J.mul(v_h_225, 0.4)), J.mul(v_w_224, (0.3 + J.mul(v_q_229, 0.9))), J.mul(v_h_225, (0.3 + J.mul(v_q_229, 0.6))), 0.0, 0.0, J.mul(env["PI"], 2.0)])
			J.mc(v_ctx_149, "stroke", [])
			v_i_228 = J.num(v_i_228) + 1.0
		var _t175 = ("rgba(140,255,170," + J.str(J.mul(0.8, v_e_226)) + ")")
		J.sp(v_ctx_149, "fillStyle", _t175)
		J.mc(v_ctx_149, "beginPath", [])
		J.mc(v_ctx_149, "arc", [J.add(v_x_222, J.div(v_w_224, 2.0)), J.add(v_y_223, J.mul(v_h_225, 0.35)), 3.0, 0.0, J.mul(env["PI"], 2.0)])
		J.mc(v_ctx_149, "fill", [])
		J.mc(v_ctx_149, "restore", [])
		var _t176 = env["text"]
		J.cl(_t176, null, [v_ctx_149, J.add(v_x_222, J.div(v_w_224, 2.0)), J.sub(v_y_223, J.mul(v_h_225, (1.2 + J.mul(v_br_227, 0.4)))), ("呼……" if J.cmp(v_br_227, 0.5, ">") else "……吸"), J.mul(v_h_225, 0.75), J.mul(v_e_226, (0.5 + J.mul(0.5, v_br_227)))])
	if J.cmp(J.gp(env["st"], "bchair"), 0.0, ">"):
		var _t177 = env["crop"]
		v_C_230 = J.cl(_t177, null, ["bchair", J.gp(env["A"], "chair"), true])
		var _t178 = env["rect"]
		var _t179 = J.cl(_t178, null, [J.gp(env["A"], "chair")])
		var _t180 = J.gp(_t179, 0.0)
		v_x_231 = _t180
		var _t181 = J.gp(_t179, 1.0)
		v_y_232 = _t181
		var _t182 = J.gp(_t179, 2.0)
		v_w_233 = _t182
		var _t183 = J.gp(_t179, 3.0)
		v_h_234 = _t183
		if J.t(v_C_230):
			v_e_235 = J.min_([1.0, J.gp(env["st"], "bchair"), (J.sub(2.8, J.gp(env["st"], "bchair")) * 3.0)])
			v_a_236 = J.mul((J.sub(2.8, J.gp(env["st"], "bchair")) * 7.0), v_e_235)
			v_sc_237 = cos(J.num(v_a_236))
			J.mc(v_ctx_149, "drawImage", [J.gp(v_C_230, "f"), v_x_231, v_y_232, v_w_233, v_h_234])
			J.mc(v_ctx_149, "save", [])
			J.mc(v_ctx_149, "translate", [J.add(v_x_231, J.div(v_w_233, 2.0)), J.add(v_y_232, v_h_234)])
			J.mc(v_ctx_149, "scale", [J.max_([0.25, absf(J.num(v_sc_237))]), 1.0])
			if J.cmp(v_sc_237, 0.0, "<"):
				J.sp(v_ctx_149, "filter", "brightness(0.6)")
			J.mc(v_ctx_149, "drawImage", [J.gp(v_C_230, "c"), J.div((-J.num(v_w_233)), 2.0), (-J.num(v_h_234)), v_w_233, v_h_234])
			J.mc(v_ctx_149, "restore", [])
			var _t184 = env["text"]
			J.cl(_t184, null, [v_ctx_149, J.add(v_x_231, J.div(v_w_233, 2.0)), J.sub(v_y_232, J.mul(v_h_234, 0.15)), "吱——", J.mul(v_h_234, 0.32), v_e_235])
	var _t185 = J.gp(env["st"], "trophy")
	if J.t((_t185 if J.t(_t185) else J.cmp(J.gp(env["st"], "trophyBack"), 0.0, ">"))):
		var _t186 = env["crop"]
		v_C_238 = J.cl(_t186, null, ["trophy", J.gp(env["A"], "trophy"), true])
		var _t187 = env["rect"]
		var _t188 = J.cl(_t187, null, [J.gp(env["A"], "trophy")])
		var _t189 = J.gp(_t188, 0.0)
		v_x_239 = _t189
		var _t190 = J.gp(_t188, 1.0)
		v_y_240 = _t190
		var _t191 = J.gp(_t188, 2.0)
		v_w_241 = _t191
		var _t192 = J.gp(_t188, 3.0)
		v_h_242 = _t192
		if J.t(v_C_238):
			J.mc(v_ctx_149, "drawImage", [J.gp(v_C_238, "f"), v_x_239, v_y_240, v_w_241, v_h_242])
			var _t193 = (not J.t(J.gp(env["st"], "trophy")))
			if (J.cmp(J.gp(env["st"], "trophyBack"), 0.0, ">") if _t193 else _t193):
				J.mc(v_ctx_149, "save", [])
				var _t194 = (1.0 - J.div(J.gp(env["st"], "trophyBack"), 0.6))
				J.sp(v_ctx_149, "globalAlpha", _t194)
				J.mc(v_ctx_149, "drawImage", [J.gp(v_C_238, "c"), v_x_239, v_y_240, v_w_241, v_h_242])
				J.mc(v_ctx_149, "restore", [])

func _f28(this_, a: Array, env):
	var v_ctx_248 = null; var v_c_249 = null; var v_x_250 = null; var v_y_251 = null; var v_u_252 = null; var v_r_253 = null; var v_hgt_254 = null; var v_drop_255 = null
	v_ctx_248 = J.arg(a, 0)
	v_c_249 = J.gp(env["__p"]["st"], "can")
	var _t195 = env["__p"]["P"]
	var _t196 = J.cl(_t195, null, [J.gp(v_c_249, "x"), J.gp(v_c_249, "y")])
	var _t197 = J.gp(_t196, 0.0)
	v_x_250 = _t197
	var _t198 = J.gp(_t196, 1.0)
	v_y_251 = _t198
	var _t199 = env["__p"]["U"]
	v_u_252 = J.cl(_t199, null, [J.gp(v_c_249, "y")])
	v_r_253 = J.mul(v_u_252, 0.035)
	v_hgt_254 = J.mul(v_u_252, 0.075)
	v_drop_255 = ((J.mul((1.0 - J.div(J.gp(v_c_249, "t"), 0.35)), v_u_252) * 0.08) if J.cmp(J.gp(v_c_249, "t"), 0.35, "<") else 0.0)
	J.mc(v_ctx_248, "save", [])
	J.mc(v_ctx_248, "translate", [v_x_250, J.sub(J.sub(v_y_251, v_r_253), v_drop_255)])
	J.mc(v_ctx_248, "rotate", [(J.gp(v_c_249, "rot") if J.cmp(J.gp(v_c_249, "t"), 0.35, ">") else 0.0)])
	J.sp(v_ctx_248, "fillStyle", "#d23a3a")
	J.mc(v_ctx_248, "fillRect", [J.div((-J.num(v_hgt_254)), 2.0), (-J.num(v_r_253)), v_hgt_254, J.mul(v_r_253, 2.0)])
	J.sp(v_ctx_248, "fillStyle", "#eee")
	J.mc(v_ctx_248, "fillRect", [((-J.num(v_hgt_254)) * 0.15), (-J.num(v_r_253)), J.mul(v_hgt_254, 0.3), J.mul(v_r_253, 2.0)])
	J.sp(v_ctx_248, "fillStyle", "#aaa")
	J.mc(v_ctx_248, "fillRect", [(J.div((-J.num(v_hgt_254)), 2.0) - 1.0), (-J.num(v_r_253)), 2.0, J.mul(v_r_253, 2.0)])
	J.mc(v_ctx_248, "fillRect", [(J.div(v_hgt_254, 2.0) - 1.0), (-J.num(v_r_253)), 2.0, J.mul(v_r_253, 2.0)])
	J.mc(v_ctx_248, "restore", [])
	var _t200 = J.cmp(J.gp(v_c_249, "t"), 0.3, ">")
	if (J.cmp(J.gp(v_c_249, "t"), 1.2, "<") if _t200 else _t200):
		var _t201 = env["__p"]["text"]
		J.cl(_t201, null, [v_ctx_248, v_x_250, J.sub(v_y_251, J.mul(v_u_252, 0.18)), "咕碌咕碌", J.mul(v_u_252, 0.08), (1.0 - J.div(J.sub(J.gp(v_c_249, "t"), 0.3), 0.9))])

func _f29(this_, a: Array, env):
	var v_ctx_256 = null; var v_g_257 = null; var v_x_258 = null; var v_y_259 = null; var v_u_260 = null; var v_r_261 = null; var v_i_262 = null
	v_ctx_256 = J.arg(a, 0)
	v_g_257 = J.gp(env["__p"]["st"], "golf")
	var _t202 = env["__p"]["P"]
	var _t203 = J.cl(_t202, null, [J.gp(v_g_257, "x"), J.gp(v_g_257, "y")])
	var _t204 = J.gp(_t203, 0.0)
	v_x_258 = _t204
	var _t205 = J.gp(_t203, 1.0)
	v_y_259 = _t205
	var _t206 = env["__p"]["U"]
	v_u_260 = J.cl(_t206, null, [J.gp(v_g_257, "y")])
	v_r_261 = J.mul(v_u_260, 0.022)
	J.mc(v_ctx_256, "save", [])
	J.sp(v_ctx_256, "fillStyle", "rgba(0,0,0,.3)")
	J.mc(v_ctx_256, "beginPath", [])
	J.mc(v_ctx_256, "ellipse", [v_x_258, v_y_259, J.mul(v_r_261, 1.3), J.mul(v_r_261, 0.4), 0.0, 0.0, J.mul(env["__p"]["PI"], 2.0)])
	J.mc(v_ctx_256, "fill", [])
	J.sp(v_ctx_256, "fillStyle", "#fafafa")
	J.sp(v_ctx_256, "strokeStyle", "#555")
	J.sp(v_ctx_256, "lineWidth", 1.0)
	J.mc(v_ctx_256, "beginPath", [])
	J.mc(v_ctx_256, "arc", [v_x_258, J.sub(v_y_259, v_r_261), v_r_261, 0.0, J.mul(env["__p"]["PI"], 2.0)])
	J.mc(v_ctx_256, "fill", [])
	J.mc(v_ctx_256, "stroke", [])
	J.sp(v_ctx_256, "fillStyle", "#bbb")
	J.mc(v_ctx_256, "beginPath", [])
	J.mc(v_ctx_256, "arc", [J.add(v_x_258, (J.mul(cos(J.num(J.gp(v_g_257, "rot"))), v_r_261) * 0.5)), (J.sub(v_y_259, v_r_261) + (J.mul(sin(J.num(J.gp(v_g_257, "rot"))), v_r_261) * 0.3)), J.mul(v_r_261, 0.18), 0.0, J.mul(env["__p"]["PI"], 2.0)])
	J.mc(v_ctx_256, "fill", [])
	J.mc(v_ctx_256, "restore", [])
	if J.cmp(J.gp(v_g_257, "t"), 2.4, "<"):
		J.mc(v_ctx_256, "save", [])
		J.sp(v_ctx_256, "strokeStyle", "rgba(255,255,255,.35)")
		J.sp(v_ctx_256, "lineWidth", 1.5)
		v_i_262 = 1.0
		while true:
			if not J.cmp(v_i_262, 4.0, "<"): break
			J.mc(v_ctx_256, "beginPath", [])
			J.mc(v_ctx_256, "moveTo", [J.sub(v_x_258, (J.mul(signf(J.num(J.sub(J.gp(v_g_257, "x1"), J.gp(v_g_257, "x0")))), v_u_260) * (0.05 + J.mul(v_i_262, 0.05)))), ((J.sub(v_y_259, v_r_261) - J.mul(v_i_262, 2.0)) + 4.0)])
			J.mc(v_ctx_256, "lineTo", [J.sub(v_x_258, (J.mul(signf(J.num(J.sub(J.gp(v_g_257, "x1"), J.gp(v_g_257, "x0")))), v_u_260) * (0.1 + J.mul(v_i_262, 0.05)))), ((J.sub(v_y_259, v_r_261) - J.mul(v_i_262, 2.0)) + 4.0)])
			J.mc(v_ctx_256, "stroke", [])
			v_i_262 = J.num(v_i_262) + 1.0
		J.mc(v_ctx_256, "restore", [])
		var _t207 = env["__p"]["text"]
		J.cl(_t207, null, [v_ctx_256, v_x_258, J.sub(v_y_259, J.mul(v_u_260, 0.12)), "咕碌——", J.mul(v_u_260, 0.07), (1.0 - J.div(J.gp(v_g_257, "t"), 2.4))])

func _f30(this_, a: Array, env):
	var v_ctx_263 = null; var v_T_264 = null; var v_C_265 = null; var v_x_266 = null; var v_y_267 = null; var v_w_268 = null; var v_h_269 = null
	v_ctx_263 = J.arg(a, 0)
	v_T_264 = J.gp(env["__p"]["st"], "trophy")
	var _t208 = env["__p"]["crop"]
	v_C_265 = J.cl(_t208, null, ["trophy", J.gp(env["__p"]["A"], "trophy"), true])
	if (not J.t(v_C_265)):
		return null
	var _t209 = env["__p"]["P"]
	var _t210 = J.cl(_t209, null, [J.gp(v_T_264, "x"), J.gp(v_T_264, "y")])
	var _t211 = J.gp(_t210, 0.0)
	v_x_266 = _t211
	var _t212 = J.gp(_t210, 1.0)
	v_y_267 = _t212
	var _t213 = env["__p"]["rect"]
	v_w_268 = J.gp(J.cl(_t213, null, [J.gp(env["__p"]["A"], "trophy")]), 2.0)
	var _t214 = env["__p"]["rect"]
	v_h_269 = J.gp(J.cl(_t214, null, [J.gp(env["__p"]["A"], "trophy")]), 3.0)
	J.mc(v_ctx_263, "save", [])
	J.mc(v_ctx_263, "translate", [v_x_266, J.sub(v_y_267, (J.mul(v_w_268, 0.5) if J.cmp(J.gp(v_T_264, "y"), J.gp(v_T_264, "floor"), ">=") else J.mul(v_h_269, 0.5)))])
	J.mc(v_ctx_263, "rotate", [J.gp(v_T_264, "rot")])
	J.mc(v_ctx_263, "drawImage", [J.gp(v_C_265, "c"), J.div((-J.num(v_w_268)), 2.0), J.div((-J.num(v_h_269)), 2.0), v_w_268, v_h_269])
	J.mc(v_ctx_263, "restore", [])
	var _t215 = J.cmp(J.gp(v_T_264, "land"), 0.0, ">=")
	if ((J.sub(J.gp(v_T_264, "t"), J.gp(v_T_264, "land")) < 0.6) if _t215 else _t215):
		var _t216 = env["__p"]["text"]
		J.cl(_t216, null, [v_ctx_263, v_x_266, J.sub(v_y_267, J.mul(v_h_269, 0.9)), "哐啷！", J.mul(v_h_269, 0.35), (1.0 - J.div(J.sub(J.gp(v_T_264, "t"), J.gp(v_T_264, "land")), 0.6))])

func _f31(this_, a: Array, env):
	var v_ctx_272 = null; var v_b_273 = null; var v_k_274 = null; var v_w_275 = null; var v_h_276 = null; var v_x_277 = null; var v_y_278 = null
	v_ctx_272 = J.arg(a, 0)
	v_b_273 = J.mc(env["__p"]["__p"]["SC"], "bgScale", [])
	v_k_274 = J.mul(J.div(J.mul(J.gp(v_b_273, "ih"), J.gp(v_b_273, "s")), env["__p"]["__p"]["SH"]), env["__p"]["__p"]["MT_K"])
	v_w_275 = J.mul(869.0, v_k_274)
	v_h_276 = J.mul(192.0, v_k_274)
	var _t221 = env["__p"]["__p"]["P"]
	var _t222 = J.cl(_t221, null, [env["mx"], env["my"]])
	var _t223 = J.gp(_t222, 0.0)
	v_x_277 = _t223
	var _t224 = J.gp(_t222, 1.0)
	v_y_278 = _t224
	J.mc(v_ctx_272, "save", [])
	J.sp(v_ctx_272, "fillStyle", "rgba(6,4,18,.32)")
	J.mc(v_ctx_272, "beginPath", [])
	J.mc(v_ctx_272, "ellipse", [v_x_277, J.sub(v_y_278, J.mul(v_h_276, 0.03)), J.mul(v_w_275, 0.52), J.mul(v_h_276, 0.14), 0.0, 0.0, J.mul(env["__p"]["__p"]["PI"], 2.0)])
	J.mc(v_ctx_272, "fill", [])
	J.mc(v_ctx_272, "drawImage", [env["__p"]["tb"], J.sub(v_x_277, J.div(v_w_275, 2.0)), J.sub(v_y_278, v_h_276), v_w_275, v_h_276])
	J.mc(v_ctx_272, "restore", [])

func _f32(this_, a: Array, env):
	var v_dy_285 = null; var v_u_286 = null; var v_h_287 = null; var v_w_288 = null; var v_mx_289 = null; var v_y_290 = null; var v_wa_291 = null
	v_dy_285 = J.add(env["ry"], 0.02)
	var _t231 = env["__p"]["__p"]["U"]
	v_u_286 = J.cl(_t231, null, [v_dy_285])
	v_h_287 = J.mul(0.62, v_u_286)
	v_w_288 = J.mul(v_h_287, (J.div(J.gp(env["rc"], "width"), J.gp(env["rc"], "height")) if J.t(env["rc"]) else 2.26))
	var _t232 = env["__p"]["__p"]["P"]
	var _t233 = J.cl(_t232, null, [env["rx"], env["ry"]])
	var _t234 = J.gp(_t233, 0.0)
	v_mx_289 = _t234
	var _t235 = env["__p"]["__p"]["P"]
	var _t236 = J.cl(_t235, null, [env["rx"], v_dy_285])
	var _t237 = J.gp(_t236, 1.0)
	v_y_290 = _t237
	v_wa_291 = J.div(J.mul(v_w_288, 400.0), 578.0)
	return {"dy": v_dy_285, "u": v_u_286, "h": v_h_287, "w": v_w_288, "wa": v_wa_291, "x0": J.sub(v_mx_289, J.mul(v_wa_291, 0.36)), "y": v_y_290}

func _f33(this_, a: Array, env):
	var v_ctx_292 = null; var v_u_293 = null; var v_h_294 = null; var v_w_295 = null; var v_x_296 = null; var v_y_297 = null
	v_ctx_292 = J.arg(a, 0)
	var _t238 = env["__p"]["__p"]["U"]
	v_u_293 = J.cl(_t238, null, [env["ry"]])
	v_h_294 = J.mul(0.6, v_u_293)
	v_w_295 = J.div(J.mul(v_h_294, J.gp(env["ch"], "width")), J.gp(env["ch"], "height"))
	var _t239 = env["__p"]["__p"]["P"]
	var _t240 = J.cl(_t239, null, [env["rx"], J.sub(env["ry"], 0.006)])
	var _t241 = J.gp(_t240, 0.0)
	v_x_296 = _t241
	var _t242 = J.gp(_t240, 1.0)
	v_y_297 = _t242
	J.mc(v_ctx_292, "save", [])
	J.mc(v_ctx_292, "translate", [J.sub(v_x_296, J.mul(v_w_295, 0.18)), v_y_297])
	J.mc(v_ctx_292, "scale", [(-1.0), 1.0])
	J.mc(v_ctx_292, "drawImage", [env["ch"], J.div((-J.num(v_w_295)), 2.0), (-J.num(v_h_294)), v_w_295, v_h_294])
	J.mc(v_ctx_292, "restore", [])

func _f34(this_, a: Array, env):
	var v_ctx_298 = null; var v_g_299 = null; var v_bw_300 = null; var v_bh_301 = null; var v_bx_302 = null; var v_by_303 = null; var v_mh_304 = null; var v_mw_305 = null; var v_top_306 = null
	v_ctx_298 = J.arg(a, 0)
	v_g_299 = J.cl(env["geo"], null, [])
	J.mc(v_ctx_298, "save", [])
	J.sp(v_ctx_298, "fillStyle", "rgba(6,4,18,.38)")
	J.mc(v_ctx_298, "beginPath", [])
	J.mc(v_ctx_298, "ellipse", [J.add(J.gp(v_g_299, "x0"), J.div(J.gp(v_g_299, "w"), 2.0)), J.sub(J.gp(v_g_299, "y"), J.mul(J.gp(v_g_299, "h"), 0.01)), J.mul(J.gp(v_g_299, "w"), 0.54), J.mul(J.gp(v_g_299, "h"), 0.09), 0.0, 0.0, J.mul(env["__p"]["__p"]["PI"], 2.0)])
	J.mc(v_ctx_298, "fill", [])
	if J.t(env["mon"]):
		v_mh_304 = J.mul(J.gp(v_g_299, "h"), 0.62)
		v_mw_305 = J.div(J.mul(v_mh_304, J.gp(env["mon"], "width")), J.gp(env["mon"], "height"))
		v_top_306 = J.sub(J.gp(v_g_299, "y"), J.mul(J.gp(v_g_299, "h"), J.div(170.0, 256.0)))
		J.mc(v_ctx_298, "save", [])
		J.mc(v_ctx_298, "translate", [J.add(J.gp(v_g_299, "x0"), J.mul(J.gp(v_g_299, "wa"), 0.8)), J.add(v_top_306, J.mul(v_mh_304, 0.05))])
		J.mc(v_ctx_298, "scale", [(-1.0), 1.0])
		J.mc(v_ctx_298, "drawImage", [env["mon"], J.div((-J.num(v_mw_305)), 2.0), (-J.num(v_mh_304)), v_mw_305, v_mh_304])
		J.mc(v_ctx_298, "restore", [])
	J.mc(v_ctx_298, "drawImage", [env["rc"], J.gp(v_g_299, "x0"), J.sub(J.gp(v_g_299, "y"), J.gp(v_g_299, "h")), J.gp(v_g_299, "w"), J.gp(v_g_299, "h")])
	v_bw_300 = (J.sub(J.gp(v_g_299, "w"), J.gp(v_g_299, "wa")) * 0.82)
	v_bh_301 = J.mul(J.gp(v_g_299, "h"), 0.11)
	v_bx_302 = J.sub(J.add(J.add(J.gp(v_g_299, "x0"), J.gp(v_g_299, "wa")), J.div(J.sub(J.sub(J.gp(v_g_299, "w"), J.gp(v_g_299, "wa")), v_bw_300), 2.0)), J.mul(J.gp(v_g_299, "w"), 0.005))
	v_by_303 = (J.sub(J.gp(v_g_299, "y"), J.gp(v_g_299, "h")) - J.mul(v_bh_301, 0.92))
	J.sp(v_ctx_298, "fillStyle", "#2a1a14")
	J.mc(v_ctx_298, "fillRect", [J.sub(v_bx_302, 1.5), J.sub(v_by_303, 1.5), J.add(v_bw_300, 3.0), J.add(v_bh_301, 3.0)])
	J.sp(v_ctx_298, "fillStyle", "#d4b062")
	J.mc(v_ctx_298, "fillRect", [v_bx_302, v_by_303, v_bw_300, v_bh_301])
	J.sp(v_ctx_298, "fillStyle", "#2a1a10")
	var _t243 = ("900 " + J.str(J.round(J.num(J.mul(v_bh_301, 0.7)))) + "px \"PingFang TC\",\"Noto Sans TC\",sans-serif")
	J.sp(v_ctx_298, "font", _t243)
	J.sp(v_ctx_298, "textAlign", "center")
	J.sp(v_ctx_298, "textBaseline", "middle")
	J.mc(v_ctx_298, "fillText", ["接待處", J.add(v_bx_302, J.div(v_bw_300, 2.0)), J.add(v_by_303, J.mul(v_bh_301, 0.55))])
	J.mc(v_ctx_298, "restore", [])

func _f35(this_, a: Array, env):
	var v_ctx_309 = null; var v_x_310 = null; var v_yy_311 = null; var v_u_312 = null; var v_h_313 = null; var v_w_314 = null; var v_s_315 = null
	v_ctx_309 = J.arg(a, 0)
	var _t246 = env["__p"]["__p"]["__p"]["P"]
	var _t247 = J.cl(_t246, null, [J.add(J.gp(env["__p"]["c"], "x"), J.gp(env["__p"]["c"], "ox")), env["y"]])
	var _t248 = J.gp(_t247, 0.0)
	v_x_310 = _t248
	var _t249 = J.gp(_t247, 1.0)
	v_yy_311 = _t249
	var _t250 = env["__p"]["__p"]["__p"]["U"]
	v_u_312 = J.cl(_t250, null, [env["y"]])
	v_h_313 = J.mul(0.62, v_u_312)
	v_w_314 = J.div(J.mul(v_h_313, J.gp(env["__p"]["__p"]["ch"], "width")), J.gp(env["__p"]["__p"]["ch"], "height"))
	v_s_315 = cos(J.num(J.gp(env["__p"]["c"], "sw")))
	J.mc(v_ctx_309, "save", [])
	J.sp(v_ctx_309, "fillStyle", "rgba(6,4,18,.3)")
	J.mc(v_ctx_309, "beginPath", [])
	J.mc(v_ctx_309, "ellipse", [v_x_310, v_yy_311, J.mul(v_w_314, 0.42), J.mul(v_w_314, 0.1), 0.0, 0.0, J.mul(env["__p"]["__p"]["__p"]["PI"], 2.0)])
	J.mc(v_ctx_309, "fill", [])
	J.mc(v_ctx_309, "translate", [v_x_310, v_yy_311])
	J.mc(v_ctx_309, "scale", [(J.max_([0.35, absf(J.num(v_s_315))]) * ((-1.0) if J.cmp(v_s_315, 0.0, "<") else 1.0)), 1.0])
	J.mc(v_ctx_309, "drawImage", [env["__p"]["__p"]["ch"], J.div((-J.num(v_w_314)), 2.0), (-J.num(v_h_313)), v_w_314, v_h_313])
	J.mc(v_ctx_309, "restore", [])
	if J.cmp(J.gp(env["__p"]["__p"]["__p"]["st"], "chairs"), 0.0, ">"):
		var _t251 = env["__p"]["__p"]["__p"]["text"]
		J.cl(_t251, null, [v_ctx_309, v_x_310, J.sub(v_yy_311, J.mul(v_h_313, 1.05)), "吱——", J.mul(v_u_312, 0.1), J.min_([1.0, J.gp(env["__p"]["__p"]["__p"]["st"], "chairs")])])

func _f27(this_, a: Array, env):
	var v_out_245 = null
	var _s87 = {"__p": env, "tb": null, "ch": null}
	v_out_245 = []
	if (not J.t(_s87["__p"]["st"])):
		return v_out_245
	if J.t(J.gp(_s87["__p"]["st"], "can")):
		J.mc(v_out_245, "push", [[0.645, Callable(self, "_f28").bind(_s87)]])
	if J.t(J.gp(_s87["__p"]["st"], "golf")):
		J.mc(v_out_245, "push", [[J.gp(J.gp(_s87["__p"]["st"], "golf"), "y"), Callable(self, "_f29").bind(_s87)]])
	if J.t(J.gp(_s87["__p"]["st"], "trophy")):
		J.mc(v_out_245, "push", [[(0.656 if J.cmp(J.gp(J.gp(_s87["__p"]["st"], "trophy"), "y"), 0.64, ">") else 0.6), Callable(self, "_f30").bind(_s87)]])
	var _t217 = _s87["__p"]["tint"]
	_s87["tb"] = J.cl(_t217, null, ["of_meet_table"])
	if J.t(_s87["tb"]):
		var _s94 = {"__p": _s87, "mx": null, "my": null}
		var _t218 = J.gp(_s94["__p"]["__p"]["SPOT"], "meetTable")
		var _t219 = J.gp(_t218, 0.0)
		_s94["mx"] = _t219
		var _t220 = J.gp(_t218, 1.0)
		_s94["my"] = _t220
		J.mc(v_out_245, "push", [[_s94["my"], Callable(self, "_f31").bind(_s94)]])
	var _s96 = {"__p": _s87, "rc": null, "ch": null, "mon": null, "rx": null, "ry": null, "geo": null}
	var _t225 = _s96["__p"]["__p"]["tint"]
	_s96["rc"] = J.cl(_t225, null, ["of_reception"])
	var _t226 = _s96["__p"]["__p"]["tint"]
	_s96["ch"] = J.cl(_t226, null, ["of_chair_front"])
	var _t227 = _s96["__p"]["__p"]["tint"]
	_s96["mon"] = J.cl(_t227, null, ["op_mon_side_on"])
	var _t228 = J.gp(_s96["__p"]["__p"]["SPOT"], "reception")
	var _t229 = J.gp(_t228, 0.0)
	_s96["rx"] = _t229
	var _t230 = J.gp(_t228, 1.0)
	_s96["ry"] = _t230
	_s96["geo"] = Callable(self, "_f32").bind(_s96)
	if J.t(_s96["ch"]):
		J.mc(v_out_245, "push", [[J.sub(_s96["ry"], 0.006), Callable(self, "_f33").bind(_s96)]])
	if J.t(_s96["rc"]):
		J.mc(v_out_245, "push", [[J.add(_s96["ry"], 0.02), Callable(self, "_f34").bind(_s96)]])
	var _t244 = _s87["__p"]["tint"]
	_s87["ch"] = J.cl(_t244, null, ["of_chair_back"])
	if J.t(_s87["ch"]):
		for _t245 in J.iter(J.gp(_s87["__p"]["st"], "spare")):
			var _s101 = {"__p": _s87, "c": null}
			_s101["c"] = _t245
			var _s102 = {"__p": _s101, "y": null}
			_s102["y"] = J.add(J.gp(_s102["__p"]["c"], "y"), J.gp(_s102["__p"]["c"], "oz"))
			J.mc(v_out_245, "push", [[_s102["y"], Callable(self, "_f35").bind(_s102)]])
	return v_out_245

func _f36(this_, a: Array, env):
	var v_r_318 = null; var v_x1_319 = null; var v_x2_320 = null
	v_r_318 = J.arg(a, 0)
	var _t252 = env["P"]
	var _t253 = J.cl(_t252, null, [J.gp(v_r_318, "x0"), 0.0])
	var _t254 = J.gp(_t253, 0.0)
	v_x1_319 = _t254
	var _t255 = env["P"]
	var _t256 = J.cl(_t255, null, [J.gp(v_r_318, "x1"), 0.0])
	var _t257 = J.gp(_t256, 0.0)
	v_x2_320 = _t257
	return [J.max_([0.0, v_x1_319]), J.min_([J.gp(env["SC"], "W"), v_x2_320])]

func _f37(this_, a: Array, env):
	var v_ctx_323 = null; var v_t_324 = null; var v_H_325 = null; var v_L_326 = null; var v_r_327 = null; var v_a_328 = null; var v_b_329 = null; var v_q_330 = null; var v_fl_331 = null; var v_r0_332 = null; var v_r1_333 = null; var v_bw_334 = null; var v_i_335 = null; var v_t0_336 = null; var v_v_337 = null; var v_i_338 = null; var v_A0_339 = null; var v_r_340 = null; var v_a_341 = null; var v_b_342 = null; var v_e_343 = null; var v_vx_344 = null; var v_vy_345 = null; var v_i_346 = null; var v_q_347 = null; var v_sx_348 = null; var v_ex_349 = null; var v_ey_350 = null
	v_ctx_323 = J.arg(a, 0)
	v_t_324 = J.arg(a, 1)
	if (not J.t(env["st"])):
		return null
	v_H_325 = J.gp(env["SC"], "H")
	if J.t(J.gp(env["st"], "lights")):
		v_L_326 = J.gp(env["st"], "lights")
		v_r_327 = J.gp(env["RM"], J.gp(v_L_326, "room"))
		var _t258 = env["roomScreen"]
		var _t259 = J.cl(_t258, null, [v_r_327])
		var _t260 = J.gp(_t259, 0.0)
		v_a_328 = _t260
		var _t261 = J.gp(_t259, 1.0)
		v_b_329 = _t261
		if J.cmp(v_b_329, v_a_328, ">"):
			v_q_330 = J.gp(v_L_326, "t")
			v_fl_331 = (0.55 if ((sin(J.num(J.mul(v_q_330, 37.0))) + sin(J.num(J.mul(v_q_330, 23.0)))) > 0.6) else 0.08)
			var _t262 = env["P"]
			var _t263 = J.cl(_t262, null, [J.gp(v_r_327, "x0"), 0.0])
			var _t264 = J.gp(_t263, 0.0)
			v_r0_332 = _t264
			var _t265 = env["P"]
			var _t266 = J.cl(_t265, null, [J.gp(v_r_327, "x1"), 0.0])
			var _t267 = J.gp(_t266, 0.0)
			v_r1_333 = _t267
			v_bw_334 = J.div(J.sub(v_r1_333, v_r0_332), 3.0)
			J.mc(v_ctx_323, "save", [])
			J.mc(v_ctx_323, "beginPath", [])
			J.mc(v_ctx_323, "rect", [v_a_328, 0.0, J.sub(v_b_329, v_a_328), v_H_325])
			J.mc(v_ctx_323, "clip", [])
			v_i_335 = 0.0
			while true:
				if not J.cmp(v_i_335, 3.0, "<"): break
				v_t0_336 = (0.9 + J.mul(v_i_335, 0.3))
				v_v_337 = (v_fl_331 if J.cmp(v_q_330, 0.9, "<") else ((v_fl_331 if J.cmp(v_q_330, v_t0_336, "<") else J.min_([0.74, (0.2 + (J.sub(v_q_330, v_t0_336) * 3.0))])) if J.cmp(v_q_330, 2.7, "<") else 0.0))
				if J.cmp(v_v_337, 0.0, ">"):
					var _t268 = ("rgba(4,3,14," + J.str(v_v_337) + ")")
					J.sp(v_ctx_323, "fillStyle", _t268)
					J.mc(v_ctx_323, "fillRect", [J.sub(J.add(v_r0_332, J.mul(v_bw_334, v_i_335)), 1.0), 0.0, J.add(v_bw_334, 2.0), v_H_325])
				v_i_335 = J.num(v_i_335) + 1.0
			var _t269 = J.cmp(v_q_330, 2.7, ">=")
			if (J.cmp(v_q_330, 3.1, "<") if _t269 else _t269):
				var _t270 = ("rgba(255,250,230," + J.str((0.35 * (1.0 - J.div(J.sub(v_q_330, 2.7), 0.4)))) + ")")
				J.sp(v_ctx_323, "fillStyle", _t270)
				J.mc(v_ctx_323, "fillRect", [v_a_328, 0.0, J.sub(v_b_329, v_a_328), v_H_325])
			J.mc(v_ctx_323, "restore", [])
			var _t271 = J.cmp(v_q_330, 0.95, ">")
			if (J.cmp(v_q_330, 2.6, "<") if _t271 else _t271):
				v_i_338 = J.min_([2.0, floor(J.num(J.div(J.sub(v_q_330, 0.9), 0.3)))])
				var _t272 = env["text"]
				J.cl(_t272, null, [v_ctx_323, J.max_([J.add(v_a_328, 20.0), J.min_([J.sub(v_b_329, 20.0), J.add(v_r0_332, J.mul(v_bw_334, J.add(v_i_338, 0.5)))])]), J.mul(v_H_325, 0.16), "啪", J.mul(v_H_325, 0.035), (1.0 - J.div(J.mod(J.sub(v_q_330, 0.9), 0.3), 0.3))])
	if J.t(J.gp(env["st"], "ac")):
		v_A0_339 = J.gp(env["st"], "ac")
		v_r_340 = J.gp(env["RM"], J.gp(v_A0_339, "room"))
		var _t273 = env["roomScreen"]
		var _t274 = J.cl(_t273, null, [v_r_340])
		var _t275 = J.gp(_t274, 0.0)
		v_a_341 = _t275
		var _t276 = J.gp(_t274, 1.0)
		v_b_342 = _t276
		if J.cmp(v_b_342, v_a_341, ">"):
			v_e_343 = J.min_([1.0, J.mul(J.gp(v_A0_339, "t"), 3.0), (J.sub(2.6, J.gp(v_A0_339, "t")) * 3.0)])
			var _t277 = env["P"]
			var _t278 = env["npx"]
			var _t280 = J.cl(_t278, null, [J.gp(J.gp(v_r_340, "vent"), 0.0)])
			var _t279 = env["py"]
			var _t281 = J.cl(_t277, null, [_t280, J.cl(_t279, null, [J.gp(J.gp(v_r_340, "vent"), 1.0)])])
			var _t282 = J.gp(_t281, 0.0)
			v_vx_344 = _t282
			var _t283 = J.gp(_t281, 1.0)
			v_vy_345 = _t283
			J.mc(v_ctx_323, "save", [])
			J.mc(v_ctx_323, "beginPath", [])
			J.mc(v_ctx_323, "rect", [v_a_341, 0.0, J.sub(v_b_342, v_a_341), v_H_325])
			J.mc(v_ctx_323, "clip", [])
			var _t284 = ("rgba(150,200,255," + J.str(J.mul(0.14, v_e_343)) + ")")
			J.sp(v_ctx_323, "fillStyle", _t284)
			J.mc(v_ctx_323, "fillRect", [v_a_341, 0.0, J.sub(v_b_342, v_a_341), v_H_325])
			J.sp(v_ctx_323, "lineCap", "round")
			v_i_346 = 0.0
			while true:
				if not J.cmp(v_i_346, 9.0, "<"): break
				v_q_347 = J.mod((J.mul(v_t_324, 0.9) + J.div(v_i_346, 9.0)), 1.0)
				v_sx_348 = J.add(v_vx_344, (J.sub(v_i_346, 4.0) * 9.0))
				v_ex_349 = J.sub(J.add(v_sx_348, J.mul((J.sub(v_i_346, 4.0) * 14.0), v_q_347)), J.mul(10.0, v_q_347))
				v_ey_350 = J.add(v_vy_345, (J.mul(v_q_347, v_H_325) * 0.5))
				var _t285 = ("rgba(210,235,255," + J.str((J.mul(0.5, v_e_343) * J.sub(1.0, v_q_347))) + ")")
				J.sp(v_ctx_323, "strokeStyle", _t285)
				var _t286 = (2.2 * (1.0 - J.mul(v_q_347, 0.5)))
				J.sp(v_ctx_323, "lineWidth", _t286)
				J.mc(v_ctx_323, "beginPath", [])
				J.mc(v_ctx_323, "moveTo", [v_sx_348, v_vy_345])
				J.mc(v_ctx_323, "quadraticCurveTo", [J.add(v_sx_348, (sin(J.num(J.add(J.mul(v_t_324, 6.0), v_i_346))) * 8.0)), J.div(J.add(v_vy_345, v_ey_350), 2.0), v_ex_349, v_ey_350])
				J.mc(v_ctx_323, "stroke", [])
				v_i_346 = J.num(v_i_346) + 1.0
			J.mc(v_ctx_323, "restore", [])

func _f39(this_, a: Array, env):
	var v_r_353 = null
	v_r_353 = J.arg(a, 0)
	var _t288 = J.gp(v_r_353, "k")
	var _t289 = (J.div(J.gp(v_r_353, "x0"), env["WW"]) * 100.0)
	var _t290 = (J.div(J.sub(J.gp(v_r_353, "x1"), J.gp(v_r_353, "x0")), env["WW"]) * 100.0)
	var _t287 = J.gp(env["SHORT"], J.gp(v_r_353, "k"))
	return ("<div class=\"scm-r\" data-r=\"" + J.str(_t288) + "\" style=\"left:" + J.str(_t289) + "%;width:" + J.str(_t290) + "%\"><span>" + J.str((_t287 if J.t(_t287) else J.gp(v_r_353, "name"))) + "</span></div>")

func _f38(this_, a: Array, env):
	var _t291 = J.mc(env["ROOMS"], "map", [Callable(self, "_f39").bind(env)])
	return ("<div id=\"sc-map\">" + J.str(J.mc(_t291, "join", [""])) + "<i id=\"scm-view\"></i><div id=\"scm-dots\"></div></div><button id=\"sc-follow\" class=\"\" title=\"鏡頭跟住點中嘅人（預設關：唔好自己捲走個畫面）\">跟</button>")

func _f41(this_, a: Array, env):
	var v_e_366 = null
	v_e_366 = J.arg(a, 0)
	var _t299 = J.gp(v_e_366, "classList")
	return J.mc(_t299, "toggle", ["cur", J.seq(J.gp(J.gp(v_e_366, "dataset"), "r"), J.gp(env["cr"], "k"))])

func _f42(this_, a: Array, env):
	var v_n_367 = null
	v_n_367 = J.arg(a, 0)
	var _t301 = (not J.t(J.gp(v_n_367, "gone")))
	return ((not J.t(J.gp(v_n_367, "out"))) if _t301 else _t301)

func _f43(this_, a: Array, env):
	var v_a_379 = null; var v_b_380 = null
	v_a_379 = J.arg(a, 0)
	v_b_380 = J.arg(a, 1)
	return J.sub(J.gp(v_a_379, "x"), J.gp(v_b_380, "x"))

func _f40(this_, a: Array, env):
	var v_S_356 = null; var v_box_357 = null; var v_v_358 = null; var v_sel_359 = null; var v_wit_360 = null; var v_want_362 = null; var v_vis_363 = null; var v_last_364 = null; var v_row_365 = null; var v_n_368 = null; var v_d_369 = null; var v_f_370 = null; var v_col_371 = null; var v_sm_372 = null; var v_lane_373 = null; var v_B_374 = null; var v_on_375 = null; var v_d_376 = null; var v_k_377 = null; var v_d_378 = null; var v_n_381 = null; var v_d_382 = null; var v_p_383 = null
	var _s119 = {"__p": env, "cr": null}
	v_S_356 = J.arg(a, 0)
	v_box_357 = J.S_document_("getElementById", ["scm-dots"])
	if (not J.t(v_box_357)):
		return null
	v_v_358 = J.S_document_("getElementById", ["scm-view"])
	var _t292 = J.gp(v_v_358, "style")
	var _t293 = J.add((J.div(J.gp(v_S_356, "camX"), _s119["__p"]["WW"]) * 100.0), "%")
	J.sp(_t292, "left", _t293)
	var _t294 = J.gp(v_v_358, "style")
	var _t295 = J.add((J.div(J.mc(v_S_356, "viewW", []), _s119["__p"]["WW"]) * 100.0), "%")
	J.sp(_t294, "width", _t295)
	var _t296 = J.gp(v_S_356, "sel")
	var _t297 = ((not J.t(J.gp(J.gp(v_S_356, "sel"), "gone"))) if J.t(_t296) else _t296)
	v_sel_359 = (J.gp(v_S_356, "sel") if J.t(((not J.t(J.gp(J.gp(v_S_356, "sel"), "out"))) if J.t(_t297) else _t297)) else null)
	v_wit_360 = (J.new_("Set", [J.mc(v_S_356, "witnesses", [v_sel_359])]) if J.t(v_sel_359) else J.new_("Set", []))
	_s119["cr"] = J.mc(v_S_356, "camRoom", [])
	var _t298 = J.S_document_("querySelectorAll", ["#sc-map .scm-r"])
	J.mc(_t298, "forEach", [Callable(self, "_f41").bind(_s119)])
	var _t300 = J.gp(v_S_356, "npcs")
	v_want_362 = J.mc(_t300, "filter", [Callable(self, "_f42").bind(_s119)])
	var _t302 = J.gp(v_S_356, "_dots")
	var _t303 = (_t302 if J.t(_t302) else {})
	J.sp(v_S_356, "_dots", _t303)
	for _t304 in J.iter(v_want_362):
		v_n_368 = _t304
		v_d_369 = J.gp(J.gp(v_S_356, "_dots"), J.gp(J.gp(v_n_368, "d"), "k"))
		if (not J.t(v_d_369)):
			var _t305 = J.gp(v_S_356, "_dots")
			var _t306 = J.gp(J.gp(v_n_368, "d"), "k")
			var _t307 = J.S_document_("createElement", ["b"])
			J.sp(_t305, _t306, _t307)
			v_d_369 = _t307
			var _t308 = J.gp(_s119["__p"]["DOTCH"], J.gp(J.gp(v_n_368, "d"), "k"))
			var _t309 = (_t308 if J.t(_t308) else J.gp(J.gp(J.gp(v_n_368, "d"), "name"), 0.0))
			J.sp(v_d_369, "textContent", _t309)
			J.mc(v_box_357, "appendChild", [v_d_369])
		v_f_370 = J.gp(v_n_368, "fear")
		v_col_371 = ("#c070ff" if J.t(J.gp(v_n_368, "fleeing")) else ("#ff5a4a" if J.cmp(v_f_370, 50.0, ">=") else ("#ffb84a" if J.cmp(v_f_370, 25.0, ">=") else ("#8ab0d0" if J.t(J.gp(J.gp(v_n_368, "d"), "guard")) else ("#ffd36a" if J.t(J.gp(J.gp(v_n_368, "d"), "daoshi")) else "#7fd6a0")))))
		v_sm_372 = (J.div(J.max_([0.6, J.min_([J.sub(_s119["__p"]["WW"], 0.06), J.gp(v_n_368, "x")])]), _s119["__p"]["WW"]) * 100.0)
		v_lane_373 = (J.round(J.num((J.div(J.sub(J.gp(v_n_368, "y"), 0.64), 0.34) * 4.0))) * 0.0)
		var _t310 = J.gp(v_d_369, "style")
		var _t311 = J.add(v_sm_372, "%")
		J.sp(_t310, "left", _t311)
		var _t312 = J.gp(v_d_369, "style")
		J.sp(_t312, "background", v_col_371)
		var _t313 = (("sel" if J.seq(v_n_368, v_sel_359) else ("wit" if J.t(J.mc(v_wit_360, "has", [v_n_368])) else "")) + (" walk" if J.seq(J.gp(v_n_368, "act"), "walk") else ""))
		J.sp(v_d_369, "className", _t313)
		var _t314 = J.gp(v_d_369, "style")
		J.sp(_t314, "display", "")
		J.sp(v_d_369, "_seen", true)
	v_B_374 = J.gp(v_S_356, "bryan")
	var _t315 = ((not J.seq(J.gp(v_B_374, "st"), "wait")) if J.t(v_B_374) else v_B_374)
	v_on_375 = ((not J.seq(J.gp(v_B_374, "st"), "gone")) if J.t(_t315) else _t315)
	v_d_376 = J.gp(J.gp(v_S_356, "_dots"), "__bryan")
	if J.t(v_on_375):
		if (not J.t(v_d_376)):
			var _t316 = J.gp(v_S_356, "_dots")
			var _t317 = J.S_document_("createElement", ["b"])
			J.sp(_t316, "__bryan", _t317)
			v_d_376 = _t317
			J.sp(v_d_376, "textContent", "B")
			J.mc(v_box_357, "appendChild", [v_d_376])
		var _t318 = J.gp(v_d_376, "style")
		var _t319 = J.add((J.div(J.max_([0.6, J.min_([J.sub(_s119["__p"]["WW"], 0.06), J.gp(v_B_374, "x")])]), _s119["__p"]["WW"]) * 100.0), "%")
		J.sp(_t318, "left", _t319)
		var _t320 = J.gp(v_d_376, "style")
		J.sp(_t320, "background", "#b07aff")
		var _t321 = J.gp(v_d_376, "style")
		J.sp(_t321, "top", "8px")
		J.sp(v_d_376, "className", "bry")
		J.sp(v_d_376, "_seen", true)
	for _t322 in J.keys(J.gp(v_S_356, "_dots")):
		v_k_377 = _t322
		v_d_378 = J.gp(J.gp(v_S_356, "_dots"), v_k_377)
		if (not J.t(J.gp(v_d_378, "_seen"))):
			var _t323 = J.gp(v_d_378, "style")
			J.sp(_t323, "display", "none")
		else:
			var _t324 = J.gp(v_d_378, "style")
			J.sp(_t324, "display", "")
		J.sp(v_d_378, "_seen", false)
	var _t325 = J.mc(v_want_362, "slice", [])
	v_vis_363 = J.mc(_t325, "sort", [Callable(self, "_f43").bind(_s119)])
	v_last_364 = (-9.0)
	v_row_365 = 0.0
	for _t326 in J.iter(v_vis_363):
		v_n_381 = _t326
		v_d_382 = J.gp(J.gp(v_S_356, "_dots"), J.gp(J.gp(v_n_381, "d"), "k"))
		v_p_383 = (J.div(J.gp(v_n_381, "x"), _s119["__p"]["WW"]) * 100.0)
		var _t327 = (J.mod(J.add(v_row_365, 1.0), 2.0) if (J.sub(v_p_383, v_last_364) < 4.2) else 0.0)
		v_row_365 = _t327
		v_last_364 = v_p_383
		var _t328 = J.gp(v_d_382, "style")
		var _t329 = ("15px" if J.t(v_row_365) else "1px")
		J.sp(_t328, "top", _t329)

func _f2(this_, a: Array, env):
	var v_v_54 = null; var v_a_55 = null; var v_b_56 = null; var v_n_57 = null
	v_v_54 = J.arg(a, 0)
	for _t330 in J.iter(env["REMAP"]):
		var _t331 = J.gp(_t330, 0.0)
		v_a_55 = _t331
		var _t332 = J.gp(_t330, 1.0)
		v_b_56 = _t332
		var _t333 = J.gp(_t330, 2.0)
		v_n_57 = _t333
		var _t334 = J.cmp(v_v_54, v_a_55, ">=")
		if (J.cmp(v_v_54, v_b_56, "<=") if _t334 else _t334):
			return J.sub(J.add(v_n_57, v_v_54), v_a_55)
	return v_v_54

func _f3(this_, a: Array, env):
	var v_u_58 = null
	v_u_58 = J.arg(a, 0)
	var _t335 = env["Rp"]
	return J.div(J.cl(_t335, null, [J.mul(v_u_58, env["PXU"])]), env["PXU"])

func _f4(this_, a: Array, env):
	var v_v_59 = null
	v_v_59 = J.arg(a, 0)
	var _t336 = env["Rp"]
	return J.div(J.cl(_t336, null, [v_v_59]), env["PXU"])

func _f5(this_, a: Array, env):
	var v_v_60 = null
	v_v_60 = J.arg(a, 0)
	return J.div(v_v_60, env["PXU"])

func _f6(this_, a: Array, env):
	var v_v_61 = null
	v_v_61 = J.arg(a, 0)
	return J.div(v_v_61, env["SH"])

func _f7(this_, a: Array, env):
	var v_v_62 = null
	v_v_62 = J.arg(a, 0)
	var _t337 = env["npx"]
	return J.cl(_t337, null, [J.add(v_v_62, J.div(env["WALLW"], 2.0))])

func _f8(this_, a: Array, env):
	var v_r_63 = null; var v_i_64 = null
	v_r_63 = J.arg(a, 0)
	v_i_64 = J.arg(a, 1)
	J.sp(v_r_63, "i", v_i_64)
	var _t338 = J.div(J.add(J.gp(v_r_63, "x0"), J.gp(v_r_63, "x1")), 2.0)
	J.sp(v_r_63, "cx", _t338)
	var _t339 = env["RM"]
	var _t340 = J.gp(v_r_63, "k")
	J.sp(_t339, _t340, v_r_63)

func _f9(this_, a: Array, env):
	var v_x_65 = null
	v_x_65 = J.arg(a, 0)
	var _t341 = env["Ru"]
	return J.cl(_t341, null, [J.add(env["OX"], v_x_65)])

func _f10(this_, a: Array, env):
	var v_y_66 = null
	v_y_66 = J.arg(a, 0)
	return (0.64 + (J.sub(v_y_66, 0.5) * 0.75))

func _f11(this_, a: Array, env):
	var v_x_67 = null; var v_r_68 = null
	v_x_67 = J.arg(a, 0)
	for _t342 in J.iter(env["ROOMS"]):
		v_r_68 = _t342
		if J.cmp(v_x_67, J.gp(v_r_68, "x1"), "<"):
			return v_r_68
	return J.gp(env["ROOMS"], (J.len(env["ROOMS"]) - 1.0))

func _f12(this_, a: Array, env):
	var v_a_69 = null
	v_a_69 = J.arg(a, 0)
	var _t452 = env["px"]
	var _t454 = J.cl(_t452, null, [J.gp(v_a_69, 0.0)])
	var _t453 = env["py"]
	var _t456 = J.cl(_t453, null, [J.gp(v_a_69, 1.0)])
	var _t455 = env["px"]
	var _t458 = J.cl(_t455, null, [J.gp(v_a_69, 2.0)])
	var _t457 = env["py"]
	return [_t454, _t456, _t458, J.cl(_t457, null, [J.gp(v_a_69, 3.0)])]

func _f13(this_, a: Array, env):
	var v_k_70 = null
	v_k_70 = J.arg(a, 0)
	var _t460 = J.seq(J.typeof_(J.G.get("sprOk")), "function")
	if J.t(_t460):
		var _t459 = J.G.get("sprOk")
		_t460 = J.cl(_t459, null, [v_k_70])
	return _t460

func _f14(this_, a: Array, env):
	var v_x_71 = null; var v_y_72 = null
	v_x_71 = J.arg(a, 0)
	v_y_72 = J.arg(a, 1)
	return J.mc(env["SC"], "pt", [v_x_71, v_y_72])

func _f15(this_, a: Array, env):
	var v_y_73 = null
	v_y_73 = J.arg(a, 0)
	return J.mul(J.mc(env["SC"], "hh", [v_y_73]), J.div(64.0, (64.0 * 1.08)))

func _f20(this_, a: Array, env):
	var v_a_110 = null; var v_x1_111 = null; var v_y1_112 = null; var v_x2_113 = null; var v_y2_114 = null
	v_a_110 = J.arg(a, 0)
	var _t461 = env["P"]
	var _t462 = env["px"]
	var _t464 = J.cl(_t462, null, [J.gp(v_a_110, 0.0)])
	var _t463 = env["py"]
	var _t465 = J.cl(_t461, null, [_t464, J.cl(_t463, null, [J.gp(v_a_110, 1.0)])])
	var _t466 = J.gp(_t465, 0.0)
	v_x1_111 = _t466
	var _t467 = J.gp(_t465, 1.0)
	v_y1_112 = _t467
	var _t468 = env["P"]
	var _t469 = env["px"]
	var _t471 = J.cl(_t469, null, [J.add(J.gp(v_a_110, 0.0), J.gp(v_a_110, 2.0))])
	var _t470 = env["py"]
	var _t472 = J.cl(_t468, null, [_t471, J.cl(_t470, null, [J.add(J.gp(v_a_110, 1.0), J.gp(v_a_110, 3.0))])])
	var _t473 = J.gp(_t472, 0.0)
	v_x2_113 = _t473
	var _t474 = J.gp(_t472, 1.0)
	v_y2_114 = _t474
	return [v_x1_111, v_y1_112, J.sub(v_x2_113, v_x1_111), J.sub(v_y2_114, v_y1_112)]

func _f1(this_, a: Array, env):
	var v_SW_2 = null; var v_WALLS_14 = null; var v_SEAM_16 = null; var v_PILLAR_17 = null; var v_M_21 = null; var v_MY_22 = null; var v_roomAt_23 = null; var v_LANE_25 = null; var v_PATROL_26 = null; var v_R_28 = null; var v_init_43 = null; var v_tick_44 = null; var v_onProp_45 = null; var v_drawBack_46 = null; var v_drawables_47 = null; var v_drawOver_49 = null; var v_mapHTML_50 = null; var v_mapTick_53 = null
	var _s2 = {"__p": env, "SH": null, "PXU": null, "REMAP": null, "Rp": null, "Ru": null, "px": null, "npx": null, "py": null, "PI": null, "WW": null, "MT_K": null, "WALLW": null, "ROOMS": null, "RM": null, "OX": null, "SPOT": null, "A": null, "WIN": null, "SC": null, "st": null, "PANO": null, "CROP": null, "TC": null, "ok": null, "P": null, "U": null, "pano": null, "crop": null, "tint": null, "text": null, "rect": null, "roomScreen": null, "SHORT": null, "DOTCH": null}
	_s2["pano"] = Callable(self, "_f16").bind(_s2)
	_s2["crop"] = Callable(self, "_f17").bind(_s2)
	_s2["tint"] = Callable(self, "_f18").bind(_s2)
	_s2["text"] = Callable(self, "_f19").bind(_s2)
	v_init_43 = Callable(self, "_f21").bind(_s2)
	v_tick_44 = Callable(self, "_f23").bind(_s2)
	v_onProp_45 = Callable(self, "_f24").bind(_s2)
	v_drawBack_46 = Callable(self, "_f26").bind(_s2)
	v_drawables_47 = Callable(self, "_f27").bind(_s2)
	_s2["roomScreen"] = Callable(self, "_f36").bind(_s2)
	v_drawOver_49 = Callable(self, "_f37").bind(_s2)
	v_mapHTML_50 = Callable(self, "_f38").bind(_s2)
	v_mapTick_53 = Callable(self, "_f40").bind(_s2)
	v_SW_2 = 12168.0
	_s2["SH"] = 1024.0
	_s2["PXU"] = 1165.0
	_s2["REMAP"] = [[0.0, 1506.0, 0.0], [4458.0, 5964.0, 1616.0], [2560.0, 2982.0, 3472.0], [1506.0, 2560.0, 4242.0], [2982.0, 4458.0, 6152.0]]
	_s2["Rp"] = Callable(self, "_f2").bind(_s2)
	_s2["Ru"] = Callable(self, "_f3").bind(_s2)
	_s2["px"] = Callable(self, "_f4").bind(_s2)
	_s2["npx"] = Callable(self, "_f5").bind(_s2)
	_s2["py"] = Callable(self, "_f6").bind(_s2)
	_s2["PI"] = PI
	_s2["WW"] = J.div(v_SW_2, _s2["PXU"])
	_s2["MT_K"] = 1.17
	v_WALLS_14 = [1506.0, 3122.0, 4132.0, 6042.0, 7628.0, 8438.0, 9948.0, 11258.0]
	_s2["WALLW"] = 110.0
	v_SEAM_16 = J.mc(v_WALLS_14, "map", [Callable(self, "_f7").bind(_s2)])
	v_PILLAR_17 = J.div(_s2["WALLW"], _s2["PXU"])
	_s2["ROOMS"] = [{"k": "boss", "name": "陳總房", "x0": 0.0, "x1": J.gp(v_SEAM_16, 0.0), "vent": [600.0, 70.0]}, {"k": "meeting", "name": "會議室", "x0": J.gp(v_SEAM_16, 0.0), "x1": J.gp(v_SEAM_16, 1.0), "vent": [2590.0, 66.0]}, {"k": "lobby", "name": "電梯大堂", "x0": J.gp(v_SEAM_16, 1.0), "x1": J.gp(v_SEAM_16, 2.0), "vent": [3700.0, 70.0]}, {"k": "main", "name": "工程師區", "x0": J.gp(v_SEAM_16, 2.0), "x1": J.gp(v_SEAM_16, 3.0), "vent": [5210.0, 70.0]}, {"k": "pantry", "name": "茶水間", "x0": J.gp(v_SEAM_16, 3.0), "x1": J.gp(v_SEAM_16, 4.0), "vent": [6896.0, 120.0]}, {"k": "wc", "name": "洗手間", "x0": J.gp(v_SEAM_16, 4.0), "x1": J.gp(v_SEAM_16, 5.0), "vent": [8090.0, 70.0]}, {"k": "qa", "name": "設計測試區", "x0": J.gp(v_SEAM_16, 5.0), "x1": J.gp(v_SEAM_16, 6.0), "vent": [9250.0, 70.0]}, {"k": "server", "name": "伺服器房", "x0": J.gp(v_SEAM_16, 6.0), "x1": J.gp(v_SEAM_16, 7.0), "vent": [10660.0, 70.0]}, {"k": "rest", "name": "休息室", "x0": J.gp(v_SEAM_16, 7.0), "x1": _s2["WW"], "vent": [11760.0, 70.0]}]
	_s2["RM"] = {}
	J.mc(_s2["ROOMS"], "forEach", [Callable(self, "_f8").bind(_s2)])
	_s2["OX"] = 1.37
	v_M_21 = Callable(self, "_f9").bind(_s2)
	v_MY_22 = Callable(self, "_f10").bind(_s2)
	v_roomAt_23 = Callable(self, "_f11").bind(_s2)
	var _t343 = _s2["px"]
	var _t345 = [J.cl(_t343, null, [1010.0]), 0.668]
	var _t344 = _s2["px"]
	var _t347 = [J.cl(_t344, null, [720.0]), 0.73]
	var _t346 = _s2["px"]
	var _t349 = [J.cl(_t346, null, [300.0]), 0.8]
	var _t348 = _s2["px"]
	var _t351 = [J.cl(_t348, null, [860.0]), 0.72]
	var _t350 = _s2["px"]
	var _t353 = [J.cl(_t350, null, [4060.0]), 0.68]
	var _t352 = _s2["px"]
	var _t355 = [J.cl(_t352, null, [3770.0]), 0.675]
	var _t354 = _s2["px"]
	var _t357 = [J.cl(_t354, null, [3650.0]), 0.68]
	var _t356 = _s2["px"]
	var _t359 = [J.cl(_t356, null, [4300.0]), 0.7]
	var _t358 = _s2["px"]
	var _t361 = [J.cl(_t358, null, [3990.0]), 0.69]
	var _t360 = _s2["px"]
	var _t363 = [J.cl(_t360, null, [3860.0]), 0.672]
	var _t362 = _s2["px"]
	var _t365 = [J.cl(_t362, null, [3470.0]), 0.672]
	var _t364 = _s2["npx"]
	var _t367 = [J.cl(_t364, null, [2905.0]), 0.8]
	var _t366 = _s2["npx"]
	var _t369 = [J.cl(_t366, null, [2264.0]), 0.72]
	var _t368 = _s2["npx"]
	var _t371 = [J.cl(_t368, null, [2477.0]), 0.72]
	var _t370 = _s2["npx"]
	var _t373 = [J.cl(_t370, null, [2034.0]), 0.72]
	var _t372 = _s2["px"]
	var _t375 = [J.cl(_t372, null, [2762.0]), 0.655]
	var _t374 = _s2["npx"]
	var _t381 = [J.cl(_t374, null, [6890.0]), 0.86]
	var _t376 = _s2["npx"]
	var _t378 = [J.cl(_t376, null, [6720.0]), 0.8]
	var _t377 = _s2["npx"]
	var _t380 = [J.cl(_t377, null, [6890.0]), 0.8]
	var _t379 = _s2["npx"]
	var _t383 = [_t378, _t380, [J.cl(_t379, null, [7060.0]), 0.8]]
	var _t382 = _s2["npx"]
	var _t385 = [J.cl(_t382, null, [3330.0]), 0.8]
	var _t384 = _s2["npx"]
	var _t387 = [J.cl(_t384, null, [6300.0]), 0.7]
	var _t386 = _s2["npx"]
	var _t389 = [J.cl(_t386, null, [7868.0]), 0.7]
	var _t388 = _s2["npx"]
	var _t391 = [J.cl(_t388, null, [8108.0]), 0.7]
	var _t390 = _s2["npx"]
	var _t393 = [J.cl(_t390, null, [2370.0]), 0.82]
	var _t392 = _s2["npx"]
	var _t399 = [J.cl(_t392, null, [10660.0]), 0.78]
	var _t394 = _s2["npx"]
	var _t396 = J.cl(_t394, null, [8800.0])
	var _t395 = _s2["npx"]
	var _t398 = J.cl(_t395, null, [9150.0])
	var _t397 = _s2["npx"]
	var _t401 = [_t396, _t398, J.cl(_t397, null, [9500.0])]
	var _t400 = _s2["npx"]
	_s2["SPOT"] = {"bossDesk": _t345, "bossFront": _t347, "golf": _t349, "bossVisit": _t351, "water": _t353, "coffee": _t355, "micro": _t357, "vend": _t359, "fridge": _t361, "kettle": _t363, "sink": _t365, "board": _t367, "seat1": _t369, "seat2": _t371, "seat3": _t373, "elev": _t375, "restTable": _t381, "restSeats": _t383, "reception": _t385, "copier": _t387, "wcM": _t389, "wcF": _t391, "meetTable": _t393, "server": _t399, "qaDesks": _t401, "sofa": [J.cl(_t400, null, [11850.0]), 0.7]}
	var _t402 = _s2["Ru"]
	var _t404 = [J.cl(_t402, null, [1.8]), 0.93]
	var _t403 = _s2["Ru"]
	var _t406 = [J.cl(_t403, null, [2.24]), 0.91]
	var _t405 = _s2["px"]
	var _t408 = [J.cl(_t405, null, [3320.0]), 0.93]
	var _t407 = _s2["px"]
	var _t410 = [J.cl(_t407, null, [3960.0]), 0.92]
	var _t409 = _s2["npx"]
	var _t412 = [J.cl(_t409, null, [7900.0]), 0.88]
	var _t411 = _s2["npx"]
	var _t414 = [J.cl(_t411, null, [9300.0]), 0.9]
	var _t413 = _s2["npx"]
	var _t416 = [J.cl(_t413, null, [10700.0]), 0.88]
	var _t415 = _s2["npx"]
	var _t418 = [J.cl(_t415, null, [11500.0]), 0.9]
	var _t417 = _s2["npx"]
	var _t420 = [J.cl(_t417, null, [9600.0]), 0.84]
	var _t419 = _s2["px"]
	var _t422 = [J.cl(_t419, null, [3620.0]), 0.95]
	var _t421 = _s2["npx"]
	var _t424 = [J.cl(_t421, null, [3700.0]), 0.92]
	var _t423 = _s2["npx"]
	v_LANE_25 = [_t404, _t406, _t408, _t410, _t412, _t414, _t416, _t418, _t420, _t422, _t424, [J.cl(_t423, null, [2600.0]), 0.93]]
	var _t425 = _s2["px"]
	var _t427 = [J.cl(_t425, null, [780.0]), 0.8]
	var _t426 = _s2["npx"]
	var _t429 = [J.cl(_t426, null, [2750.0]), 0.88]
	var _t430 = [J.cl(v_M_21, null, [0.14]), J.cl(v_MY_22, null, [0.71])]
	var _t428 = _s2["npx"]
	var _t432 = [J.cl(_t428, null, [6500.0]), 0.9]
	var _t431 = _s2["npx"]
	var _t434 = [J.cl(_t431, null, [8000.0]), 0.84]
	var _t433 = _s2["npx"]
	var _t436 = [J.cl(_t433, null, [9300.0]), 0.86]
	var _t435 = _s2["npx"]
	var _t438 = [J.cl(_t435, null, [10600.0]), 0.84]
	var _t437 = _s2["npx"]
	v_PATROL_26 = [_t427, _t429, _t430, _t432, _t434, _t436, _t438, [J.cl(_t437, null, [11600.0]), 0.84]]
	var _t442 = [3594.0, 392.0, 120.0, 72.0]
	var _t443 = [3606.0, 402.0, 78.0, 52.0]
	var _t444 = [3906.0, 256.0, 176.0, 350.0]
	var _t445 = [3910.0, 260.0, 168.0, 148.0]
	var _t446 = [4202.0, 264.0, 224.0, 344.0]
	var _t447 = [4232.0, 288.0, 160.0, 186.0]
	var _t448 = [4236.0, 512.0, 124.0, 38.0]
	var _t449 = [3818.0, 392.0, 72.0, 72.0]
	var _t450 = [4728.0, 195.0, 391.0, 219.0]
	var _t451 = [5143.0, 450.0, 94.0, 36.0]
	var _t439 = _s2["npx"]
	var _t441 = [J.cl(_t439, null, [1780.0]), 0.8]
	var _t440 = _s2["npx"]
	_s2["A"] = {"micro": _t442, "microWin": _t443, "fridge": _t444, "fridgeDoor": _t445, "vend": _t446, "vendGlass": _t447, "vendSlot": _t448, "kettle": _t449, "tv": _t450, "speaker": _t451, "spare": [_t441, [J.cl(_t440, null, [2960.0]), 0.9]], "golfBag": [0.0, 328.0, 112.0, 264.0], "chair": [680.0, 362.0, 178.0, 120.0], "trophy": [262.0, 204.0, 46.0, 96.0]}
	v_R_28 = Callable(self, "_f12").bind(_s2)
	_s2["WIN"] = [[368.0, 240.0, 792.0, 240.0], [4311.0, 200.0, 995.0, 216.0], [5296.0, 200.0, 746.0, 216.0], [6196.0, 208.0, 296.0, 280.0], [8617.0, 200.0, 985.0, 216.0]]
	_s2["SC"] = null
	_s2["st"] = null
	_s2["PANO"] = null
	_s2["CROP"] = {}
	_s2["TC"] = {}
	_s2["ok"] = Callable(self, "_f13").bind(_s2)
	_s2["P"] = Callable(self, "_f14").bind(_s2)
	_s2["U"] = Callable(self, "_f15").bind(_s2)
	_s2["rect"] = Callable(self, "_f20").bind(_s2)
	_s2["SHORT"] = {"boss": "陳總", "meeting": "會議", "lobby": "大堂", "main": "工程", "pantry": "茶水", "wc": "洗手", "qa": "設計", "server": "機房", "rest": "休息"}
	_s2["DOTCH"] = {"ken": "K", "it": "晴", "mis": "美", "boss": "陳", "auntie": "娣", "guard": "伯", "daoshi": "道", "kol": "網"}
	var _t482 = _s2["pano"]
	var _t483 = _s2["PXU"]
	var _t484 = _s2["WW"]
	var _t485 = _s2["SH"]
	var _t486 = _s2["WALLW"]
	var _t487 = _s2["ROOMS"]
	var _t488 = _s2["RM"]
	var _t489 = _s2["OX"]
	var _t490 = _s2["px"]
	var _t491 = _s2["npx"]
	var _t492 = _s2["py"]
	var _t493 = _s2["Rp"]
	var _t494 = _s2["Ru"]
	var _t495 = _s2["SPOT"]
	var _t496 = _s2["A"]
	var _t475 = _s2["px"]
	var _t477 = J.cl(_t475, null, [1575.0])
	var _t476 = _s2["py"]
	var _t479 = J.cl(_t476, null, [200.0])
	var _t478 = _s2["px"]
	var _t481 = J.cl(_t478, null, [995.0])
	var _t480 = _s2["py"]
	var _t510 = [_t477, _t479, _t481, J.cl(_t480, null, [216.0])]
	var _t497 = _s2["px"]
	var _t499 = J.cl(_t497, null, [2652.0])
	var _t498 = _s2["px"]
	var _t501 = J.cl(_t498, null, [2872.0])
	var _t500 = _s2["px"]
	var _t503 = J.cl(_t500, null, [2762.0])
	var _t502 = _s2["py"]
	var _t505 = J.cl(_t502, null, [248.0])
	var _t504 = _s2["py"]
	var _t509 = J.cl(_t504, null, [570.0])
	var _t506 = _s2["px"]
	var _t508 = J.cl(_t506, null, [2910.0])
	var _t507 = _s2["py"]
	return {"pano": _t482, "PXU": _t483, "WW": _t484, "SW": v_SW_2, "SH": _t485, "SEAM": v_SEAM_16, "WALLS": v_WALLS_14, "WALLW": _t486, "PILLAR": v_PILLAR_17, "ROOMS": _t487, "RM": _t488, "OX": _t489, "M": v_M_21, "MY": v_MY_22, "px": _t490, "npx": _t491, "py": _t492, "Rp": _t493, "Ru": _t494, "roomAt": v_roomAt_23, "SPOT": _t495, "LANE": v_LANE_25, "PATROL": v_PATROL_26, "A": _t496, "R": v_R_28, "init": v_init_43, "tick": v_tick_44, "onProp": v_onProp_45, "drawBack": v_drawBack_46, "drawables": v_drawables_47, "drawOver": v_drawOver_49, "mapHTML": v_mapHTML_50, "mapTick": v_mapTick_53, "WINMAIN": _t510, "ELEV": {"x0": _t499, "x1": _t501, "seam": _t503, "top": _t505, "bot": _t509, "btn": [_t508, J.cl(_t507, null, [380.0])]}}
