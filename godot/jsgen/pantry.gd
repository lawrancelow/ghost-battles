# 自動轉譯自 pantry.js（tools/jsgd.js）——唔好直接改，改原 JS 再轉
extends RefCounted

func run(env):
	var this_ = null; var a = []
	J.G["Pantry"] = J.cl(Callable(self, "_f1").bind(env), null, [])

func _f8(this_, a: Array, env):
	var v_im_76 = null; var v_k_77 = null; var v_X0_78 = null; var v_X1_79 = null; var v_c_80 = null; var v_x_81 = null; var v_g_82 = null
	if J.t(env["NIGHT"]):
		return env["NIGHT"]
	var _t1 = env["ok"]
	if (not J.t(J.cl(_t1, null, ["bg_office_pano"]))):
		return null
	v_im_76 = J.gp(J.G.get("SPR"), "bg_office_pano")
	v_k_77 = J.div(J.gp(v_im_76, "naturalHeight"), env["SH"])
	v_X0_78 = 6480.0
	v_X1_79 = 7620.0
	v_c_80 = J.S_document_("createElement", ["canvas"])
	var _t2 = J.round(J.num(J.mul(J.sub(v_X1_79, v_X0_78), v_k_77)))
	J.sp(v_c_80, "width", _t2)
	var _t3 = J.gp(v_im_76, "naturalHeight")
	J.sp(v_c_80, "height", _t3)
	v_x_81 = J.mc(v_c_80, "getContext", ["2d"])
	J.mc(v_x_81, "drawImage", [v_im_76, J.mul(v_X0_78, v_k_77), 0.0, J.mul(J.sub(v_X1_79, v_X0_78), v_k_77), J.gp(v_c_80, "height"), 0.0, 0.0, J.gp(v_c_80, "width"), J.gp(v_c_80, "height")])
	J.sp(v_x_81, "globalCompositeOperation", "multiply")
	J.sp(v_x_81, "fillStyle", "rgb(150,140,196)")
	J.mc(v_x_81, "fillRect", [0.0, 0.0, J.gp(v_c_80, "width"), J.gp(v_c_80, "height")])
	v_g_82 = J.mc(v_x_81, "createLinearGradient", [0.0, J.mul(J.gp(v_c_80, "height"), 0.62), 0.0, J.gp(v_c_80, "height")])
	J.mc(v_g_82, "addColorStop", [0.0, "rgb(255,255,255)"])
	J.mc(v_g_82, "addColorStop", [1.0, "rgb(160,152,186)"])
	J.sp(v_x_81, "fillStyle", v_g_82)
	J.mc(v_x_81, "fillRect", [0.0, J.mul(J.gp(v_c_80, "height"), 0.62), J.gp(v_c_80, "width"), J.mul(J.gp(v_c_80, "height"), 0.38)])
	var _t4 = {"c": v_c_80, "k": v_k_77, "X0": v_X0_78}
	env["NIGHT"] = _t4
	return env["NIGHT"]

func _f9(this_, a: Array, env):
	var v_id_85 = null; var v_N_86 = null; var v_A_87 = null; var v_bx_88 = null; var v_by_89 = null; var v_bw_90 = null; var v_bh_91 = null; var v_k_92 = null; var v_c_93 = null; var v_x_94 = null; var v_sx_95 = null; var v_sy_96 = null; var v_sw_97 = null; var v_shh_98 = null; var v_r_99 = null
	v_id_85 = J.arg(a, 0)
	if J.t(J.gp(env["CUT"], v_id_85)):
		return J.gp(env["CUT"], v_id_85)
	v_N_86 = J.cl(env["night"], null, [])
	if (not J.t(v_N_86)):
		return null
	v_A_87 = J.gp(env["AP"], v_id_85)
	var _t5 = J.gp(v_A_87, "b")
	var _t6 = J.gp(_t5, 0.0)
	v_bx_88 = _t6
	var _t7 = J.gp(_t5, 1.0)
	v_by_89 = _t7
	var _t8 = J.gp(_t5, 2.0)
	v_bw_90 = _t8
	var _t9 = J.gp(_t5, 3.0)
	v_bh_91 = _t9
	v_k_92 = J.gp(v_N_86, "k")
	v_c_93 = J.S_document_("createElement", ["canvas"])
	var _t10 = ceil(J.num(J.mul(v_bw_90, v_k_92)))
	J.sp(v_c_93, "width", _t10)
	var _t11 = ceil(J.num(J.mul(v_bh_91, v_k_92)))
	J.sp(v_c_93, "height", _t11)
	v_x_94 = J.mc(v_c_93, "getContext", ["2d"])
	J.mc(v_x_94, "drawImage", [J.gp(v_N_86, "c"), J.mul(J.sub(v_bx_88, J.gp(v_N_86, "X0")), v_k_92), J.mul(v_by_89, v_k_92), J.mul(v_bw_90, v_k_92), J.mul(v_bh_91, v_k_92), 0.0, 0.0, J.gp(v_c_93, "width"), J.gp(v_c_93, "height")])
	J.sp(v_x_94, "globalCompositeOperation", "destination-in")
	J.sp(v_x_94, "fillStyle", "#000")
	for _t12 in J.iter(J.gp(v_A_87, "sh")):
		var _t13 = J.gp(_t12, 0.0)
		v_sx_95 = _t13
		var _t14 = J.gp(_t12, 1.0)
		v_sy_96 = _t14
		var _t15 = J.gp(_t12, 2.0)
		v_sw_97 = _t15
		var _t16 = J.gp(_t12, 3.0)
		v_shh_98 = _t16
		var _t17 = J.gp(_t12, 4.0)
		v_r_99 = _t17
		var _t18 = env["rr"]
		J.cl(_t18, null, [v_x_94, J.mul(J.sub(v_sx_95, v_bx_88), v_k_92), J.mul(J.sub(v_sy_96, v_by_89), v_k_92), J.mul(v_sw_97, v_k_92), J.mul(v_shh_98, v_k_92), J.mul(v_r_99, v_k_92)])
		J.mc(v_x_94, "fill", [])
	var _t19 = env["CUT"]
	J.sp(_t19, v_id_85, v_c_93)
	return v_c_93

func _f10(this_, a: Array, env):
	var v_id_102 = null; var v_rx_103 = null; var v_ry_104 = null; var v_rw_105 = null; var v_rh_106 = null; var v_N_107 = null; var v_k_108 = null; var v_c_109 = null; var v_x_110 = null
	v_id_102 = J.arg(a, 0)
	v_rx_103 = J.arg(a, 1)
	v_ry_104 = J.arg(a, 2)
	v_rw_105 = J.arg(a, 3)
	v_rh_106 = J.arg(a, 4)
	if J.t(J.gp(env["CUT"], v_id_102)):
		return J.gp(env["CUT"], v_id_102)
	v_N_107 = J.cl(env["night"], null, [])
	if (not J.t(v_N_107)):
		return null
	v_k_108 = J.gp(v_N_107, "k")
	v_c_109 = J.S_document_("createElement", ["canvas"])
	var _t20 = ceil(J.num(J.mul(v_rw_105, v_k_108)))
	J.sp(v_c_109, "width", _t20)
	var _t21 = ceil(J.num(J.mul(v_rh_106, v_k_108)))
	J.sp(v_c_109, "height", _t21)
	v_x_110 = J.mc(v_c_109, "getContext", ["2d"])
	J.mc(v_x_110, "drawImage", [J.gp(v_N_107, "c"), J.mul(J.sub(v_rx_103, J.gp(v_N_107, "X0")), v_k_108), J.mul(v_ry_104, v_k_108), J.mul(v_rw_105, v_k_108), J.mul(v_rh_106, v_k_108), 0.0, 0.0, J.gp(v_c_109, "width"), J.gp(v_c_109, "height")])
	J.sp(v_x_110, "globalCompositeOperation", "destination-in")
	var _t22 = env["rr"]
	J.cl(_t22, null, [v_x_110, 0.0, 0.0, J.gp(v_c_109, "width"), J.gp(v_c_109, "height"), J.mul(10.0, v_k_108)])
	J.mc(v_x_110, "fill", [])
	var _t23 = env["CUT"]
	J.sp(_t23, v_id_102, v_c_109)
	return v_c_109

func _f12(this_, a: Array, env):
	var _t24 = {"t": 0.0, "micro": null, "coffee": null, "fridge": null, "water": null, "vend": null, "items": [], "puddles": [], "drips": [], "mist": [], "bub": [], "flick": 0.0, "nextFlick": 3.0, "nextBub": 4.0, "use": {}}
	env["st"] = _t24

func _f15(this_, a: Array, env):
	var _t29 = J.gp(J.G.get("Scare"), "active")
	var _t30 = ((not J.t(J.gp(env["n"], "gone"))) if J.t(_t29) else _t29)
	if J.t(((not J.t(J.gp(env["n"], "fleeing"))) if J.t(_t30) else _t30)):
		var _t31 = env["n"]
		J.sp(_t31, "bubT", 0.0)
		var _t36 = env["n"]
		var _t32 = J.G.get("L")
		var _t33 = env["__p"]["pick"]
		var _t35 = env["__p"]["LINES"]
		var _t34 = J.mc(env["k"], "replace", ["loop", ""])
		J.mc(J.G.get("Scare"), "bubble", [_t36, J.cl(_t32, null, [J.cl(_t33, null, [J.gp(_t35, J.mc(_t34, "replace", ["snack", "vend"]))])]), 2.6])

func _f14(this_, a: Array, env):
	var _t25 = (env["n"] if J.t(env["s"]) else env["s"])
	var _t28 = (J.gp(J.G.get("Scare"), "bubble") if J.t(_t25) else _t25)
	if J.t(_t28):
		var _t27 = env["__p"]["LINES"]
		var _t26 = J.mc(env["k"], "replace", ["loop", ""])
		_t28 = J.gp(_t27, J.mc(_t26, "replace", ["snack", "vend"]))
	if J.t(_t28):
		J.F_setTimeout([Callable(self, "_f15").bind(env), 2200.0])

func _f16(this_, a: Array, env):
	var v_x_123 = null; var v_e_124 = null
	v_x_123 = J.arg(a, 0)
	if (not J.t(J.gp(J.G.get("Scare"), "headless"))):
		J.mc(J.G.get("Sound"), "play", [v_x_123])

func _f13(this_, a: Array, env):
	var v_use_119 = null; var v_say_121 = null; var v_snd_122 = null; var v_col_125 = null; var v_row_126 = null
	var _s19 = {"__p": env, "k": null, "n": null, "s": null}
	_s19["k"] = J.arg(a, 0)
	_s19["n"] = J.arg(a, 1)
	v_use_119 = J.arg(a, 2)
	if (not J.t(_s19["__p"]["st"])):
		J.cl(_s19["__p"]["reset"], null, [])
	_s19["s"] = (not J.t(v_use_119))
	v_say_121 = Callable(self, "_f14").bind(_s19)
	v_snd_122 = Callable(self, "_f16").bind(_s19)
	if J.seq(_s19["k"], "micro"):
		var _t37 = _s19["__p"]["st"]
		var _t38 = {"t": 0.0, "dur": (4.5 if J.t(_s19["s"]) else 4.0)}
		J.sp(_t37, "micro", _t38)
		J.cl(v_snd_122, null, ["click"])
	else:
		if J.seq(_s19["k"], "coffee"):
			var _t39 = _s19["__p"]["st"]
			var _t40 = {"t": 0.0, "dur": 5.0}
			J.sp(_t39, "coffee", _t40)
			J.cl(v_snd_122, null, ["click"])
		else:
			var _t41 = J.seq(_s19["k"], "fridge")
			if (_t41 if _t41 else J.seq(_s19["k"], "fridgeloop")):
				var _t42 = _s19["__p"]["st"]
				var _t43 = {"t": 0.0, "dur": (7.2 if J.seq(_s19["k"], "fridgeloop") else (3.4 if J.t(_s19["s"]) else 3.0)), "loop": J.seq(_s19["k"], "fridgeloop"), "bang": 0.0}
				J.sp(_t42, "fridge", _t43)
				J.cl(v_snd_122, null, ["whoosh"])
			else:
				if J.seq(_s19["k"], "water"):
					var _t44 = _s19["__p"]["st"]
					var _t45 = {"t": 0.0, "dur": (7.0 if J.t(_s19["s"]) else 2.6), "leak": _s19["s"]}
					J.sp(_t44, "water", _t45)
					if J.t(_s19["s"]):
						var _t46 = J.gp(_s19["__p"]["st"], "puddles")
						J.mc(_t46, "push", [{"x": 7314.0, "y": 0.655, "r": 0.0, "rmax": (0.07 + (randf() * 0.015)), "t": 0.0, "grow": 7.0, "life": 32.0}])
				else:
					var _t47 = J.seq(_s19["k"], "vend")
					if (_t47 if _t47 else J.seq(_s19["k"], "snack")):
						v_col_125 = floor(J.num((randf() * 4.0)))
						v_row_126 = (0.0 if J.seq(_s19["k"], "snack") else 3.0)
						var _t48 = _s19["__p"]["st"]
						var _t49 = {"t": 0.0, "dur": 2.8, "kind": ("snack" if J.seq(_s19["k"], "snack") else "can"), "col": v_col_125, "row": v_row_126, "hue": J.gp([8.0, 35.0, 95.0, 200.0], v_col_125)}
						J.sp(_t48, "vend", _t49)
						var _t50 = _s19["__p"]["st"]
						J.sp(_t50, "flick", 1.4)
						J.cl(v_snd_122, null, ["paper"])
					else:
						var _t51 = J.seq(_s19["k"], "kettle")
						if (_t51 if _t51 else J.seq(_s19["k"], "lights")):
							J.mc(_s19["__p"]["ORIG"], "onProp", [_s19["k"], _s19["n"], "pantry"])
							return null
	J.cl(v_say_121, null, [])

func _f19(this_, a: Array, env):
	var v_it_140 = null
	v_it_140 = J.arg(a, 0)
	return J.cmp(J.gp(v_it_140, "t"), 14.0, "<")

func _f20(this_, a: Array, env):
	var v_p_143 = null
	v_p_143 = J.arg(a, 0)
	return J.cmp(J.gp(v_p_143, "t"), J.gp(v_p_143, "life"), "<")

func _f21(this_, a: Array, env):
	var v_m_145 = null
	v_m_145 = J.arg(a, 0)
	return J.cmp(J.gp(v_m_145, "t"), J.gp(v_m_145, "life"), "<")

func _f22(this_, a: Array, env):
	var v_d_147 = null
	v_d_147 = J.arg(a, 0)
	return J.cmp(J.gp(v_d_147, "y"), (640.0 if J.t(J.gp(v_d_147, "fl")) else 508.0), "<")

func _f23(this_, a: Array, env):
	var v_b_150 = null
	v_b_150 = J.arg(a, 0)
	return J.cmp(J.gp(v_b_150, "y"), 318.0, ">")

func _f18(this_, a: Array, env):
	var v_dt_130 = null; var v_V_131 = null; var v_F_132 = null; var v_W_133 = null; var v_k_134 = null; var v_e_135 = null; var v_er_136 = null; var v_er_137 = null; var v_it_138 = null; var v_f_139 = null; var v_p_141 = null; var v_g_142 = null; var v_m_144 = null; var v_d_146 = null; var v_i_148 = null; var v_b_149 = null
	v_dt_130 = J.arg(a, 0)
	if (not J.t(env["st"])):
		J.cl(env["reset"], null, [])
	var _t52 = env["st"]
	var _t53 = J.add(J.gp(_t52, "t"), v_dt_130)
	J.sp(_t52, "t", _t53)
	for _t54 in J.iter(["micro", "coffee", "fridge", "water"]):
		v_k_134 = _t54
		v_e_135 = J.gp(env["st"], v_k_134)
		if J.t(v_e_135):
			var _t55 = J.add(J.gp(v_e_135, "t"), v_dt_130)
			J.sp(v_e_135, "t", _t55)
			var _t56 = J.seq(v_k_134, "micro")
			var _t57 = ((not J.t(J.gp(v_e_135, "ding"))) if _t56 else _t56)
			if (J.cmp(J.gp(v_e_135, "t"), J.sub(J.gp(v_e_135, "dur"), 0.8), ">") if _t57 else _t57):
				J.sp(v_e_135, "ding", 1.0)
				if (not J.t(J.gp(J.G.get("Scare"), "headless"))):
					J.mc(J.G.get("Sound"), "play", ["click"])
			if J.cmp(J.gp(v_e_135, "t"), J.gp(v_e_135, "dur"), ">"):
				var _t58 = env["st"]
				J.sp(_t58, v_k_134, null)
	v_V_131 = J.gp(env["st"], "vend")
	if J.t(v_V_131):
		var _t59 = J.add(J.gp(v_V_131, "t"), v_dt_130)
		J.sp(v_V_131, "t", _t59)
		var _t60 = (not J.t(J.gp(v_V_131, "out")))
		if (J.cmp(J.gp(v_V_131, "t"), 1.15, ">") if _t60 else _t60):
			J.sp(v_V_131, "out", 1.0)
			var _t61 = J.gp(env["st"], "items")
			J.mc(_t61, "push", [{"kind": J.gp(v_V_131, "kind"), "hue": J.gp(v_V_131, "hue"), "x": (7450.0 + (randf() * 40.0)), "y": 0.62, "t": 0.0, "vx": ((-(70.0 + (randf() * 30.0))) if J.seq(J.gp(v_V_131, "kind"), "can") else (-(30.0 + (randf() * 15.0)))), "rot": 0.0, "dist": 0.0}])
			if (not J.t(J.gp(J.G.get("Scare"), "headless"))):
				J.mc(J.G.get("Sound"), "play", ["hit"])
		if J.cmp(J.gp(v_V_131, "t"), J.gp(v_V_131, "dur"), ">"):
			var _t62 = env["st"]
			J.sp(_t62, "vend", null)
	for _t63 in J.iter(J.gp(env["st"], "items")):
		v_it_138 = _t63
		var _t64 = J.add(J.gp(v_it_138, "t"), v_dt_130)
		J.sp(v_it_138, "t", _t64)
		if J.cmp(J.gp(v_it_138, "t"), 0.25, ">"):
			v_f_139 = (0.8 if J.seq(J.gp(v_it_138, "kind"), "can") else 2.6)
			var _t65 = J.add(J.gp(v_it_138, "x"), J.mul(J.gp(v_it_138, "vx"), v_dt_130))
			J.sp(v_it_138, "x", _t65)
			var _t66 = J.mul(J.gp(v_it_138, "vx"), exp(J.num(J.mul((-J.num(v_dt_130)), v_f_139))))
			J.sp(v_it_138, "vx", _t66)
			var _t67 = J.min_([0.69, J.add(J.gp(v_it_138, "y"), (J.mul(v_dt_130, 0.06) * exp(J.num((-J.num(J.gp(v_it_138, "t")))))))])
			J.sp(v_it_138, "y", _t67)
			if J.seq(J.gp(v_it_138, "kind"), "can"):
				var _t68 = J.add(J.gp(v_it_138, "rot"), J.div(J.mul(J.gp(v_it_138, "vx"), v_dt_130), 9.0))
				J.sp(v_it_138, "rot", _t68)
	var _t69 = env["st"]
	var _t70 = J.gp(env["st"], "items")
	var _t71 = J.mc(_t70, "filter", [Callable(self, "_f19").bind(env)])
	J.sp(_t69, "items", _t71)
	for _t72 in J.iter(J.gp(env["st"], "puddles")):
		v_p_141 = _t72
		var _t73 = J.add(J.gp(v_p_141, "t"), v_dt_130)
		J.sp(v_p_141, "t", _t73)
		v_g_142 = J.min_([1.0, J.div(J.gp(v_p_141, "t"), J.gp(v_p_141, "grow"))])
		var _t74 = (J.mul(J.gp(v_p_141, "rmax"), (1.0 - pow(J.num(J.sub(1.0, v_g_142)), J.num(2.0)))) * (J.max_([0.35, (1.0 - (J.div(J.sub(J.gp(v_p_141, "t"), J.mul(J.gp(v_p_141, "life"), 0.55)), J.mul(J.gp(v_p_141, "life"), 0.45)) * 0.65))]) if J.cmp(J.gp(v_p_141, "t"), J.mul(J.gp(v_p_141, "life"), 0.55), ">") else 1.0))
		J.sp(v_p_141, "r", _t74)
	var _t75 = env["st"]
	var _t76 = J.gp(env["st"], "puddles")
	var _t77 = J.mc(_t76, "filter", [Callable(self, "_f20").bind(env)])
	J.sp(_t75, "puddles", _t77)
	v_F_132 = J.gp(env["st"], "fridge")
	var _t79 = v_F_132
	if J.t(_t79):
		var _t78 = env["fridgeOpen"]
		_t79 = J.cmp(J.cl(_t78, null, [v_F_132]), 0.4, ">")
	if J.t(_t79):
		if (randf() < J.mul(v_dt_130, 14.0)):
			var _t80 = J.gp(env["st"], "mist")
			J.mc(_t80, "push", [{"x": (7095.0 + (randf() * 140.0)), "y": (330.0 + (randf() * 60.0)), "vx": ((-10.0) + (randf() * 30.0)), "vy": (25.0 + (randf() * 30.0)), "r": (8.0 + (randf() * 8.0)), "t": 0.0, "life": (1.6 + randf())}])
	for _t81 in J.iter(J.gp(env["st"], "mist")):
		v_m_144 = _t81
		var _t82 = J.add(J.gp(v_m_144, "t"), v_dt_130)
		J.sp(v_m_144, "t", _t82)
		var _t83 = J.add(J.gp(v_m_144, "x"), J.mul(J.gp(v_m_144, "vx"), v_dt_130))
		J.sp(v_m_144, "x", _t83)
		var _t84 = J.add(J.gp(v_m_144, "y"), J.mul(J.gp(v_m_144, "vy"), v_dt_130))
		J.sp(v_m_144, "y", _t84)
		if J.cmp(J.gp(v_m_144, "y"), 600.0, ">"):
			J.sp(v_m_144, "y", 600.0)
			J.sp(v_m_144, "vy", 0.0)
			var _t85 = J.add(J.gp(v_m_144, "vx"), J.mul(((1.0 if J.cmp(J.gp(v_m_144, "vx"), 0.0, ">=") else (-1.0)) * 18.0), v_dt_130))
			J.sp(v_m_144, "vx", _t85)
		var _t86 = J.add(J.gp(v_m_144, "r"), J.mul(v_dt_130, 10.0))
		J.sp(v_m_144, "r", _t86)
	var _t87 = env["st"]
	var _t88 = J.gp(env["st"], "mist")
	var _t89 = J.mc(_t88, "filter", [Callable(self, "_f21").bind(env)])
	J.sp(_t87, "mist", _t89)
	v_W_133 = J.gp(env["st"], "water")
	if J.t(((randf() < J.mul(v_dt_130, (6.0 if J.t(J.gp(v_W_133, "leak")) else 9.0))) if J.t(v_W_133) else v_W_133)):
		var _t90 = J.gp(env["st"], "drips")
		var _t92 = (7330.0 if J.t(J.gp(v_W_133, "leak")) else 7329.0)
		var _t91 = J.gp(v_W_133, "leak")
		J.mc(_t90, "push", [{"x": _t92, "y": 487.0, "vy": 0.0, "t": 0.0, "fl": (J.cmp(J.gp(v_W_133, "t"), 1.4, ">") if J.t(_t91) else _t91)}])
	for _t93 in J.iter(J.gp(env["st"], "drips")):
		v_d_146 = _t93
		var _t94 = J.add(J.gp(v_d_146, "t"), v_dt_130)
		J.sp(v_d_146, "t", _t94)
		var _t95 = J.add(J.gp(v_d_146, "vy"), J.mul(900.0, v_dt_130))
		J.sp(v_d_146, "vy", _t95)
		var _t96 = J.add(J.gp(v_d_146, "y"), J.mul(J.gp(v_d_146, "vy"), v_dt_130))
		J.sp(v_d_146, "y", _t96)
	var _t97 = env["st"]
	var _t98 = J.gp(env["st"], "drips")
	var _t99 = J.mc(_t98, "filter", [Callable(self, "_f22").bind(env)])
	J.sp(_t97, "drips", _t99)
	var _t100 = env["st"]
	var _t101 = J.sub(J.gp(_t100, "nextBub"), J.mul(v_dt_130, (6.0 if J.t(v_W_133) else 1.0)))
	J.sp(_t100, "nextBub", _t101)
	if J.cmp(J.gp(env["st"], "nextBub"), 0.0, "<="):
		var _t102 = env["st"]
		var _t103 = (5.0 + (randf() * 7.0))
		J.sp(_t102, "nextBub", _t103)
		v_i_148 = 0.0
		while true:
			if not J.cmp(v_i_148, 4.0, "<"): break
			var _t104 = J.gp(env["st"], "bub")
			J.mc(_t104, "push", [{"x": (7300.0 + (randf() * 28.0)), "y": (404.0 + J.mul(v_i_148, 6.0)), "r": (2.0 + (randf() * 3.5)), "t": ((-J.num(v_i_148)) * 0.15)}])
			v_i_148 = J.num(v_i_148) + 1.0
	for _t105 in J.iter(J.gp(env["st"], "bub")):
		v_b_149 = _t105
		var _t106 = J.add(J.gp(v_b_149, "t"), v_dt_130)
		J.sp(v_b_149, "t", _t106)
		if J.cmp(J.gp(v_b_149, "t"), 0.0, ">"):
			var _t107 = J.sub(J.gp(v_b_149, "y"), J.mul(v_dt_130, (55.0 + J.mul(J.gp(v_b_149, "r"), 6.0))))
			J.sp(v_b_149, "y", _t107)
	var _t108 = env["st"]
	var _t109 = J.gp(env["st"], "bub")
	var _t110 = J.mc(_t109, "filter", [Callable(self, "_f23").bind(env)])
	J.sp(_t108, "bub", _t110)
	var _t111 = env["st"]
	var _t112 = J.max_([0.0, J.sub(J.gp(env["st"], "flick"), v_dt_130)])
	J.sp(_t111, "flick", _t112)
	var _t113 = env["st"]
	var _t114 = J.sub(J.gp(_t113, "nextFlick"), v_dt_130)
	J.sp(_t113, "nextFlick", _t114)
	if J.cmp(J.gp(env["st"], "nextFlick"), 0.0, "<="):
		var _t115 = env["st"]
		var _t116 = (4.0 + (randf() * 8.0))
		J.sp(_t115, "nextFlick", _t116)
		var _t117 = env["st"]
		var _t118 = (0.5 + (randf() * 0.5))
		J.sp(_t117, "flick", _t118)
	var _t119 = env["npcUse"]
	J.cl(_t119, null, [v_dt_130])

func _f24(this_, a: Array, env):
	var v_dt_153 = null; var v_SP_154 = null; var v_n_155 = null; var v_hit_156 = null; var v_k_157 = null; var v_s_158 = null
	v_dt_153 = J.arg(a, 0)
	var _t120 = (not J.t(J.gp(J.G.get("Scare"), "npcs")))
	var _t121 = (_t120 if _t120 else (not J.t(J.gp(J.G.get("Scare"), "site"))))
	if (_t121 if _t121 else (not J.t(J.gp(J.gp(J.G.get("Scare"), "site"), "pano")))):
		return null
	v_SP_154 = J.gp(J.G.get("OFFMAP"), "SPOT")
	for _t122 in J.iter(J.gp(J.G.get("Scare"), "npcs")):
		v_n_155 = _t122
		var _t123 = J.gp(v_n_155, "gone")
		var _t124 = (_t123 if J.t(_t123) else J.gp(v_n_155, "out"))
		var _t125 = (_t124 if J.t(_t124) else J.gp(v_n_155, "fleeing"))
		if J.t((_t125 if J.t(_t125) else J.gp(J.gp(v_n_155, "d"), "guard"))):
			J.sp(v_n_155, "_pu", null)
			continue
		v_hit_156 = null
		for _t126 in J.keys(env["USE"]):
			v_k_157 = _t126
			v_s_158 = J.gp(v_SP_154, v_k_157)
			var _t127 = ((absf(J.num(J.sub(J.gp(v_n_155, "x"), J.gp(v_s_158, 0.0)))) < 0.05) if J.t(v_s_158) else v_s_158)
			if J.t(((absf(J.num(J.sub(J.gp(v_n_155, "y"), J.gp(v_s_158, 1.0)))) < 0.035) if J.t(_t127) else _t127)):
				v_hit_156 = v_k_157
				break
		var _t128 = (not J.t(v_hit_156))
		if (_t128 if _t128 else J.seq(J.gp(v_n_155, "act"), "walk")):
			if (not J.t(v_hit_156)):
				J.sp(v_n_155, "_pu", null)
			continue
		var _t129 = (not J.t(J.gp(v_n_155, "_pu")))
		if (_t129 if _t129 else (not J.seq(J.gp(J.gp(v_n_155, "_pu"), "k"), v_hit_156))):
			var _t130 = {"k": v_hit_156, "t": 0.0, "done": false}
			J.sp(v_n_155, "_pu", _t130)
		var _t131 = J.gp(v_n_155, "_pu")
		var _t132 = J.add(J.gp(_t131, "t"), v_dt_153)
		J.sp(_t131, "t", _t132)
		var _t133 = (not J.t(J.gp(J.gp(v_n_155, "_pu"), "done")))
		var _t134 = (J.cmp(J.gp(J.gp(v_n_155, "_pu"), "t"), 0.8, ">") if _t133 else _t133)
		if ((not J.t((J.gp(env["st"], "vend") if J.seq(v_hit_156, "vend") else J.gp(env["st"], v_hit_156)))) if _t134 else _t134):
			var _t135 = J.gp(v_n_155, "_pu")
			J.sp(_t135, "done", true)
			var _t136 = (not J.seq(v_hit_156, "vend"))
			if (_t136 if _t136 else (randf() < 0.7)):
				var _t137 = env["fx"]
				var _t138 = J.seq(v_hit_156, "vend")
				J.cl(_t137, null, [("snack" if ((randf() < 0.5) if _t138 else _t138) else v_hit_156), v_n_155, true])

func _f26(this_, a: Array, env):
	var v_F_162 = null; var v_t_163 = null; var v_c_164 = null; var v_ph_165 = null; var v_i_166 = null
	v_F_162 = J.arg(a, 0)
	if (not J.t(v_F_162)):
		return 0.0
	v_t_163 = J.gp(v_F_162, "t")
	if J.t(J.gp(v_F_162, "loop")):
		v_c_164 = 1.8
		v_ph_165 = J.mod(v_t_163, v_c_164)
		v_i_166 = floor(J.num(J.div(v_t_163, v_c_164)))
		if J.cmp(v_i_166, 4.0, ">="):
			return 0.0
		var _t142 = null
		if J.cmp(v_ph_165, 0.45, "<"):
			var _t139 = env["ease"]
			_t142 = J.cl(_t139, null, [J.div(v_ph_165, 0.45)])
		else:
			var _t141 = null
			if J.cmp(v_ph_165, 1.1, "<"):
				_t141 = 1.0
			else:
				var _t140 = env["ease"]
				_t141 = J.cl(_t140, null, [(1.0 - J.div(J.sub(v_ph_165, 1.1), 0.3))])
			_t142 = _t141
		return _t142
	var _t143 = env["ease"]
	var _t145 = J.cl(_t143, null, [J.div(v_t_163, 0.6)])
	var _t144 = env["ease"]
	var _t146 = env["ease"]
	var _t148 = J.cl(_t146, null, [J.div(v_t_163, 0.6)])
	var _t147 = env["ease"]
	return J.min_([_t148, J.cl(_t147, null, [J.div(J.sub(J.gp(v_F_162, "dur"), v_t_163), 0.5)])])

func _f27(this_, a: Array, env):
	var v_ctx_169 = null; var v_id_170 = null; var v_t_171 = null; var v_A_172 = null; var v_img_173 = null; var v_s_174 = null; var v_bx_175 = null; var v_by_176 = null; var v_bw_177 = null; var v_bh_178 = null; var v_x_179 = null; var v_y_180 = null; var v_w_181 = null; var v_h_182 = null; var v_f_183 = null; var v_dw_184 = null; var v_dh_185 = null; var v_dx_186 = null; var v_dy_187 = null; var v_g_188 = null; var v_cx_189 = null; var v_cy_190 = null; var v_g_191 = null; var v_M_192 = null; var v_k_193 = null; var v_b_194 = null; var v_ox_195 = null; var v_oy_196 = null; var v_key_197 = null; var v_c_198 = null; var v_u_199 = null; var v_pad_200 = null; var v_g_201 = null; var v_sx_202 = null; var v_sy_203 = null; var v_sw_204 = null; var v_shh_205 = null; var v_r_206 = null; var v_px0_207 = null; var v_py0_208 = null
	v_ctx_169 = J.arg(a, 0)
	v_id_170 = J.arg(a, 1)
	v_t_171 = J.arg(a, 2)
	v_A_172 = J.gp(env["AP"], v_id_170)
	var _t149 = env["cut"]
	v_img_173 = J.cl(_t149, null, [v_id_170])
	if (not J.t(v_img_173)):
		return null
	v_s_174 = J.cl(env["sc"], null, [])
	var _t150 = J.gp(v_A_172, "b")
	var _t151 = J.gp(_t150, 0.0)
	v_bx_175 = _t151
	var _t152 = J.gp(_t150, 1.0)
	v_by_176 = _t152
	var _t153 = J.gp(_t150, 2.0)
	v_bw_177 = _t153
	var _t154 = J.gp(_t150, 3.0)
	v_bh_178 = _t154
	var _t155 = env["Q"]
	var _t156 = J.cl(_t155, null, [v_bx_175, v_by_176])
	var _t157 = J.gp(_t156, 0.0)
	v_x_179 = _t157
	var _t158 = J.gp(_t156, 1.0)
	v_y_180 = _t158
	v_w_181 = J.mul(v_bw_177, v_s_174)
	v_h_182 = J.mul(v_bh_178, v_s_174)
	if J.t(J.gp(v_A_172, "floor")):
		var _t159 = env["Q"]
		var _t160 = J.cl(_t159, null, [J.add(v_bx_175, J.div(v_bw_177, 2.0)), J.sub(J.add(v_by_176, v_bh_178), 2.0)])
		var _t161 = J.gp(_t160, 0.0)
		v_cx_189 = _t161
		var _t162 = J.gp(_t160, 1.0)
		v_cy_190 = _t162
		J.mc(v_ctx_169, "save", [])
		v_g_191 = J.mc(v_ctx_169, "createRadialGradient", [v_cx_189, v_cy_190, 0.0, v_cx_189, v_cy_190, J.mul(v_w_181, 0.62)])
		J.mc(v_g_191, "addColorStop", [0.0, "rgba(8,4,22,.55)"])
		J.mc(v_g_191, "addColorStop", [0.6, "rgba(8,4,22,.25)"])
		J.mc(v_g_191, "addColorStop", [1.0, "rgba(8,4,22,0)"])
		J.sp(v_ctx_169, "fillStyle", v_g_191)
		J.mc(v_ctx_169, "translate", [v_cx_189, v_cy_190])
		J.mc(v_ctx_169, "scale", [1.0, 0.16])
		J.mc(v_ctx_169, "beginPath", [])
		J.mc(v_ctx_169, "arc", [0.0, 0.0, J.mul(v_w_181, 0.62), 0.0, J.mul(env["PI"], 2.0)])
		J.mc(v_ctx_169, "fill", [])
		J.mc(v_ctx_169, "restore", [])
	v_f_183 = (1.018 if J.t(J.gp(v_A_172, "floor")) else 1.012)
	v_dw_184 = J.mul(v_w_181, v_f_183)
	v_dh_185 = J.mul(v_h_182, v_f_183)
	v_dx_186 = J.add(v_x_179, J.div(J.sub(v_w_181, v_dw_184), 2.0))
	v_dy_187 = J.sub(J.add(v_y_180, v_h_182), v_dh_185)
	v_M_192 = J.mc(v_ctx_169, "getTransform", [])
	v_k_193 = J.div(J.mul(J.hypot_([J.gp(v_M_192, "a"), J.gp(v_M_192, "b")]), v_dw_184), J.gp(v_img_173, "width"))
	v_b_194 = J.div(J.mul(27.0, v_s_174), v_k_193)
	v_ox_195 = J.div(J.mul(6.0, v_s_174), v_k_193)
	v_oy_196 = J.div(J.mul(4.0, v_s_174), v_k_193)
	v_key_197 = J.add(J.add(v_id_170, "|"), J.round(J.num(J.mul(v_b_194, 2.0))))
	v_c_198 = J.gp(env["SHC"], v_key_197)
	if (not J.t(v_c_198)):
		v_pad_200 = ceil(J.num((J.mul(v_b_194, 2.0) + J.max_([v_ox_195, v_oy_196]))))
		var _t163 = J.S_document_("createElement", ["canvas"])
		v_c_198 = _t163
		var _t164 = J.add(J.gp(v_img_173, "width"), J.mul(v_pad_200, 2.0))
		J.sp(v_c_198, "width", _t164)
		var _t165 = J.add(J.gp(v_img_173, "height"), J.mul(v_pad_200, 2.0))
		J.sp(v_c_198, "height", _t165)
		v_g_201 = J.mc(v_c_198, "getContext", ["2d"])
		J.sp(v_g_201, "shadowColor", "rgba(6,2,20,.55)")
		J.sp(v_g_201, "shadowBlur", v_b_194)
		J.sp(v_g_201, "shadowOffsetX", v_ox_195)
		J.sp(v_g_201, "shadowOffsetY", v_oy_196)
		J.sp(v_g_201, "imageSmoothingQuality", "high")
		J.mc(v_g_201, "drawImage", [v_img_173, v_pad_200, v_pad_200])
		J.sp(v_c_198, "pad", v_pad_200)
		var _t166 = env["SHC"]
		J.sp(_t166, v_key_197, v_c_198)
	v_u_199 = J.div(v_dw_184, J.gp(v_img_173, "width"))
	J.mc(v_ctx_169, "save", [])
	J.sp(v_ctx_169, "imageSmoothingQuality", "high")
	J.mc(v_ctx_169, "drawImage", [v_c_198, J.sub(v_dx_186, J.mul(J.gp(v_c_198, "pad"), v_u_199)), J.sub(v_dy_187, J.mul(J.gp(v_c_198, "pad"), v_u_199)), J.mul(J.gp(v_c_198, "width"), v_u_199), J.mul(J.gp(v_c_198, "height"), v_u_199)])
	J.mc(v_ctx_169, "restore", [])
	J.mc(v_ctx_169, "save", [])
	J.sp(v_ctx_169, "globalCompositeOperation", "lighter")
	var _t167 = J.max_([1.0, J.mul(2.2, v_s_174)])
	J.sp(v_ctx_169, "lineWidth", _t167)
	v_g_188 = J.mc(v_ctx_169, "createLinearGradient", [v_dx_186, v_dy_187, J.add(v_dx_186, J.mul(v_dw_184, 0.6)), J.add(v_dy_187, J.mul(v_dh_185, 0.6))])
	J.mc(v_g_188, "addColorStop", [0.0, "rgba(170,160,255,.42)"])
	J.mc(v_g_188, "addColorStop", [1.0, "rgba(170,160,255,0)"])
	J.sp(v_ctx_169, "strokeStyle", v_g_188)
	for _t168 in J.iter(J.gp(v_A_172, "sh")):
		var _t169 = J.gp(_t168, 0.0)
		v_sx_202 = _t169
		var _t170 = J.gp(_t168, 1.0)
		v_sy_203 = _t170
		var _t171 = J.gp(_t168, 2.0)
		v_sw_204 = _t171
		var _t172 = J.gp(_t168, 3.0)
		v_shh_205 = _t172
		var _t173 = J.gp(_t168, 4.0)
		v_r_206 = _t173
		var _t174 = env["Q"]
		var _t175 = J.cl(_t174, null, [J.sub(J.add(v_bx_175, J.mul(J.sub(v_sx_202, v_bx_175), v_f_183)), J.div(J.mul(v_bw_177, J.sub(v_f_183, 1.0)), 2.0)), J.sub(J.add(v_by_176, v_bh_178), J.mul(J.sub(J.add(v_by_176, v_bh_178), v_sy_203), v_f_183))])
		var _t176 = J.gp(_t175, 0.0)
		v_px0_207 = _t176
		var _t177 = J.gp(_t175, 1.0)
		v_py0_208 = _t177
		var _t178 = env["rr"]
		J.cl(_t178, null, [v_ctx_169, J.add(v_px0_207, J.mul(1.5, v_s_174)), J.add(v_py0_208, J.mul(1.5, v_s_174)), (J.mul(J.mul(v_sw_204, v_s_174), v_f_183) - J.mul(3.0, v_s_174)), (J.mul(J.mul(v_shh_205, v_s_174), v_f_183) - J.mul(3.0, v_s_174)), J.mul(v_r_206, v_s_174)])
		J.mc(v_ctx_169, "stroke", [])
	J.mc(v_ctx_169, "restore", [])

func _f29(this_, a: Array, env):
	var v_ctx_218 = null; var v_x_219 = null; var v_y_220 = null; var v_r_221 = null; var v_col_222 = null; var v_a_223 = null; var v_X_224 = null; var v_Y_225 = null; var v_s_226 = null; var v_g_227 = null
	v_ctx_218 = J.arg(a, 0)
	v_x_219 = J.arg(a, 1)
	v_y_220 = J.arg(a, 2)
	v_r_221 = J.arg(a, 3)
	v_col_222 = J.arg(a, 4)
	v_a_223 = J.arg(a, 5)
	var _t179 = env["Q"]
	var _t180 = J.cl(_t179, null, [v_x_219, v_y_220])
	var _t181 = J.gp(_t180, 0.0)
	v_X_224 = _t181
	var _t182 = J.gp(_t180, 1.0)
	v_Y_225 = _t182
	v_s_226 = J.cl(env["sc"], null, [])
	v_g_227 = J.mc(v_ctx_218, "createRadialGradient", [v_X_224, v_Y_225, 0.0, v_X_224, v_Y_225, J.mul(v_r_221, v_s_226)])
	J.mc(v_g_227, "addColorStop", [0.0, ("rgba(" + J.str(v_col_222) + "," + J.str(v_a_223) + ")")])
	J.mc(v_g_227, "addColorStop", [1.0, ("rgba(" + J.str(v_col_222) + ",0)")])
	J.mc(v_ctx_218, "save", [])
	J.sp(v_ctx_218, "globalCompositeOperation", "lighter")
	J.sp(v_ctx_218, "fillStyle", v_g_227)
	J.mc(v_ctx_218, "fillRect", [J.sub(v_X_224, J.mul(v_r_221, v_s_226)), J.sub(v_Y_225, J.mul(v_r_221, v_s_226)), (J.mul(v_r_221, v_s_226) * 2.0), (J.mul(v_r_221, v_s_226) * 2.0)])
	J.mc(v_ctx_218, "restore", [])

func _f30(this_, a: Array, env):
	var v_ctx_230 = null; var v_x_231 = null; var v_y_232 = null; var v_col_233 = null; var v_a_234 = null; var v_X_235 = null; var v_Y_236 = null; var v_s_237 = null
	v_ctx_230 = J.arg(a, 0)
	v_x_231 = J.arg(a, 1)
	v_y_232 = J.arg(a, 2)
	v_col_233 = J.arg(a, 3)
	v_a_234 = J.arg(a, 4)
	var _t183 = env["Q"]
	var _t184 = J.cl(_t183, null, [v_x_231, v_y_232])
	var _t185 = J.gp(_t184, 0.0)
	v_X_235 = _t185
	var _t186 = J.gp(_t184, 1.0)
	v_Y_236 = _t186
	v_s_237 = J.cl(env["sc"], null, [])
	J.mc(v_ctx_230, "save", [])
	var _t187 = ("rgba(" + J.str(v_col_233) + "," + J.str(v_a_234) + ")")
	J.sp(v_ctx_230, "fillStyle", _t187)
	J.mc(v_ctx_230, "beginPath", [])
	J.mc(v_ctx_230, "arc", [v_X_235, v_Y_236, J.max_([1.3, J.mul(3.0, v_s_237)]), 0.0, J.mul(env["PI"], 2.0)])
	J.mc(v_ctx_230, "fill", [])
	J.mc(v_ctx_230, "restore", [])
	var _t188 = env["glowAt"]
	J.cl(_t188, null, [v_ctx_230, v_x_231, v_y_232, 14.0, v_col_233, J.mul(v_a_234, 0.5)])

func _f31(this_, a: Array, env):
	var v_ctx_240 = null; var v_x_241 = null; var v_y_242 = null; var v_s0_243 = null; var v_sz_244 = null; var v_a_245 = null; var v_X_246 = null; var v_Y_247 = null; var v_s_248 = null
	v_ctx_240 = J.arg(a, 0)
	v_x_241 = J.arg(a, 1)
	v_y_242 = J.arg(a, 2)
	v_s0_243 = J.arg(a, 3)
	v_sz_244 = J.arg(a, 4)
	v_a_245 = J.arg(a, 5)
	if J.cmp(v_a_245, 0.01, "<="):
		return null
	var _t189 = env["Q"]
	var _t190 = J.cl(_t189, null, [v_x_241, v_y_242])
	var _t191 = J.gp(_t190, 0.0)
	v_X_246 = _t191
	var _t192 = J.gp(_t190, 1.0)
	v_Y_247 = _t192
	v_s_248 = J.cl(env["sc"], null, [])
	J.mc(v_ctx_240, "save", [])
	var _t193 = J.mul(J.gp(v_ctx_240, "globalAlpha"), J.min_([1.0, v_a_245]))
	J.sp(v_ctx_240, "globalAlpha", _t193)
	var _t194 = ("900 " + J.str(J.round(J.num(J.max_([13.0, J.mul(v_sz_244, v_s_248)])))) + "px sans-serif")
	J.sp(v_ctx_240, "font", _t194)
	J.sp(v_ctx_240, "textAlign", "center")
	J.sp(v_ctx_240, "lineWidth", 3.0)
	J.sp(v_ctx_240, "strokeStyle", "#1a1020")
	J.mc(v_ctx_240, "strokeText", [v_s0_243, v_X_246, v_Y_247])
	J.sp(v_ctx_240, "fillStyle", "#fff3d0")
	J.mc(v_ctx_240, "fillText", [v_s0_243, v_X_246, v_Y_247])
	J.mc(v_ctx_240, "restore", [])

func _f32(this_, a: Array, env):
	var v_ctx_251 = null; var v_t_252 = null; var v_F_253 = null; var v_o_254 = null; var v_s_255 = null; var v_x_256 = null; var v_y_257 = null; var v_w_258 = null; var v_h_259 = null; var v_g_260 = null; var v_it_261 = null; var v_d_262 = null; var v_fx0_263 = null; var v_fy0_264 = null; var v_fx1_265 = null; var v_lg_266 = null; var v_i_267 = null; var v_ix_268 = null; var v_sh_269 = null; var v_iw_270 = null; var v_ih_271 = null; var v_c_272 = null; var v_cw_273 = null; var v_dw_274 = null; var v_th_275 = null; var v_ph_276 = null
	v_ctx_251 = J.arg(a, 0)
	v_t_252 = J.arg(a, 1)
	v_F_253 = J.gp(env["st"], "fridge")
	var _t195 = env["fridgeOpen"]
	v_o_254 = J.cl(_t195, null, [v_F_253])
	v_s_255 = J.cl(env["sc"], null, [])
	var _t196 = env["led"]
	J.cl(_t196, null, [v_ctx_251, 7238.0, 268.0, "120,255,170", (0.55 + (0.25 * sin(J.num(J.mul(v_t_252, 2.2)))))])
	if J.cmp(v_o_254, 0.005, "<="):
		return null
	var _t197 = env["R"]
	var _t198 = J.cl(_t197, null, [7081.0, 256.0, 170.0, 138.0])
	var _t199 = J.gp(_t198, 0.0)
	v_x_256 = _t199
	var _t200 = J.gp(_t198, 1.0)
	v_y_257 = _t200
	var _t201 = J.gp(_t198, 2.0)
	v_w_258 = _t201
	var _t202 = J.gp(_t198, 3.0)
	v_h_259 = _t202
	J.mc(v_ctx_251, "save", [])
	v_g_260 = J.mc(v_ctx_251, "createLinearGradient", [v_x_256, v_y_257, v_x_256, J.add(v_y_257, v_h_259)])
	J.mc(v_g_260, "addColorStop", [0.0, "#f2f8ff"])
	J.mc(v_g_260, "addColorStop", [1.0, "#b7cbe4"])
	J.sp(v_ctx_251, "fillStyle", v_g_260)
	var _t203 = env["rr"]
	J.cl(_t203, null, [v_ctx_251, v_x_256, v_y_257, v_w_258, v_h_259, J.mul(8.0, v_s_255)])
	J.mc(v_ctx_251, "fill", [])
	J.mc(v_ctx_251, "clip", [])
	J.sp(v_ctx_251, "strokeStyle", "rgba(110,130,165,.8)")
	var _t204 = J.max_([1.0, J.mul(2.0, v_s_255)])
	J.sp(v_ctx_251, "lineWidth", _t204)
	v_i_267 = 1.0
	while true:
		if not J.cmp(v_i_267, 3.0, "<"): break
		J.mc(v_ctx_251, "beginPath", [])
		J.mc(v_ctx_251, "moveTo", [v_x_256, J.add(v_y_257, J.div(J.mul(v_h_259, v_i_267), 3.0))])
		J.mc(v_ctx_251, "lineTo", [J.add(v_x_256, v_w_258), J.add(v_y_257, J.div(J.mul(v_h_259, v_i_267), 3.0))])
		J.mc(v_ctx_251, "stroke", [])
		v_i_267 = J.num(v_i_267) + 1.0
	v_it_261 = [[0.12, 1.0, 0.14, 0.2, "#e3c25a"], [0.32, 1.0, 0.1, 0.24, "#7fc28a"], [0.55, 2.0, 0.24, 0.13, "#e98a8a"], [0.15, 2.0, 0.16, 0.16, "#f4f0e0"], [0.62, 1.0, 0.12, 0.18, "#8aaee8"], [0.4, 3.0, 0.3, 0.12, "#d9a46b"]]
	for _t205 in J.iter(v_it_261):
		var _t206 = J.gp(_t205, 0.0)
		v_ix_268 = _t206
		var _t207 = J.gp(_t205, 1.0)
		v_sh_269 = _t207
		var _t208 = J.gp(_t205, 2.0)
		v_iw_270 = _t208
		var _t209 = J.gp(_t205, 3.0)
		v_ih_271 = _t209
		var _t210 = J.gp(_t205, 4.0)
		v_c_272 = _t210
		J.sp(v_ctx_251, "fillStyle", v_c_272)
		J.sp(v_ctx_251, "strokeStyle", "#3b2c3a")
		var _t211 = J.max_([1.0, J.mul(1.5, v_s_255)])
		J.sp(v_ctx_251, "lineWidth", _t211)
		var _t212 = env["rr"]
		J.cl(_t212, null, [v_ctx_251, J.add(v_x_256, J.mul(v_w_258, v_ix_268)), (J.sub(J.add(v_y_257, J.div(J.mul(v_h_259, v_sh_269), 3.0)), J.mul(v_h_259, v_ih_271)) - J.mul(2.0, v_s_255)), J.mul(v_w_258, v_iw_270), J.mul(v_h_259, v_ih_271), J.mul(3.0, v_s_255)])
		J.mc(v_ctx_251, "fill", [])
		J.mc(v_ctx_251, "stroke", [])
	J.mc(v_ctx_251, "restore", [])
	var _t213 = env["glowAt"]
	J.cl(_t213, null, [v_ctx_251, 7166.0, 330.0, 190.0, "200,230,255", J.mul(0.55, v_o_254)])
	var _t214 = env["cutRect"]
	v_d_262 = J.cl(_t214, null, ["fdoor", 7079.0, 254.0, 174.0, 141.0])
	if J.t(v_d_262):
		v_cw_273 = cos(J.num((J.mul(v_o_254, env["PI"]) * 0.46)))
		v_dw_274 = (J.mul(J.max_([0.06, v_cw_273]), v_w_258) * 1.02)
		J.mc(v_ctx_251, "save", [])
		J.mc(v_ctx_251, "drawImage", [v_d_262, J.sub(J.add(v_x_256, J.mul(v_w_258, 1.01)), v_dw_274), J.sub(v_y_257, J.mul(2.0, v_s_255)), v_dw_274, J.add(v_h_259, J.mul(4.0, v_s_255))])
		var _t215 = ("rgba(20,14,40," + J.str(J.mul(0.35, v_o_254)) + ")")
		J.sp(v_ctx_251, "fillStyle", _t215)
		J.mc(v_ctx_251, "fillRect", [J.sub(J.add(v_x_256, J.mul(v_w_258, 1.01)), v_dw_274), J.sub(v_y_257, J.mul(2.0, v_s_255)), v_dw_274, J.add(v_h_259, J.mul(4.0, v_s_255))])
		J.sp(v_ctx_251, "fillStyle", "#d8d4e8")
		J.sp(v_ctx_251, "strokeStyle", "#2b2033")
		var _t216 = J.max_([1.0, J.mul(1.5, v_s_255)])
		J.sp(v_ctx_251, "lineWidth", _t216)
		v_th_275 = J.mul(J.mul(9.0, v_s_255), v_o_254)
		J.mc(v_ctx_251, "fillRect", [J.sub(J.sub(J.add(v_x_256, J.mul(v_w_258, 1.01)), v_dw_274), v_th_275), J.sub(v_y_257, J.mul(2.0, v_s_255)), v_th_275, J.add(v_h_259, J.mul(4.0, v_s_255))])
		J.mc(v_ctx_251, "strokeRect", [J.sub(J.sub(J.add(v_x_256, J.mul(v_w_258, 1.01)), v_dw_274), v_th_275), J.sub(v_y_257, J.mul(2.0, v_s_255)), v_th_275, J.add(v_h_259, J.mul(4.0, v_s_255))])
		J.mc(v_ctx_251, "restore", [])
	var _t217 = env["Q"]
	var _t218 = J.cl(_t217, null, [7090.0, 612.0])
	var _t219 = J.gp(_t218, 0.0)
	v_fx0_263 = _t219
	var _t220 = J.gp(_t218, 1.0)
	v_fy0_264 = _t220
	var _t221 = env["Q"]
	var _t222 = J.cl(_t221, null, [7250.0, 612.0])
	var _t223 = J.gp(_t222, 0.0)
	v_fx1_265 = _t223
	J.mc(v_ctx_251, "save", [])
	J.sp(v_ctx_251, "globalCompositeOperation", "lighter")
	v_lg_266 = J.mc(v_ctx_251, "createLinearGradient", [0.0, v_fy0_264, 0.0, J.add(v_fy0_264, J.mul(90.0, v_s_255))])
	J.mc(v_lg_266, "addColorStop", [0.0, ("rgba(170,210,255," + J.str(J.mul(0.28, v_o_254)) + ")")])
	J.mc(v_lg_266, "addColorStop", [1.0, "rgba(170,210,255,0)"])
	J.sp(v_ctx_251, "fillStyle", v_lg_266)
	J.mc(v_ctx_251, "beginPath", [])
	J.mc(v_ctx_251, "moveTo", [v_fx0_263, v_fy0_264])
	J.mc(v_ctx_251, "lineTo", [v_fx1_265, v_fy0_264])
	J.mc(v_ctx_251, "lineTo", [J.add(v_fx1_265, J.mul(60.0, v_s_255)), J.add(v_fy0_264, J.mul(90.0, v_s_255))])
	J.mc(v_ctx_251, "lineTo", [J.sub(v_fx0_263, J.mul(60.0, v_s_255)), J.add(v_fy0_264, J.mul(90.0, v_s_255))])
	J.mc(v_ctx_251, "closePath", [])
	J.mc(v_ctx_251, "fill", [])
	J.mc(v_ctx_251, "restore", [])
	if J.t(J.gp(v_F_253, "loop")):
		v_ph_276 = J.mod(J.gp(v_F_253, "t"), 1.8)
		var _t224 = J.cmp(v_ph_276, 1.35, ">")
		var _t225 = (J.cmp(v_ph_276, 1.75, "<") if _t224 else _t224)
		if (J.cmp(J.gp(v_F_253, "t"), 7.2, "<") if _t225 else _t225):
			var _t226 = env["sfx"]
			J.cl(_t226, null, [v_ctx_251, 7166.0, 236.0, "砰！", 34.0, (1.0 - J.div(J.sub(v_ph_276, 1.35), 0.4))])

func _f33(this_, a: Array, env):
	var v_ctx_279 = null; var v_s_280 = null; var v_m_281 = null; var v_X_282 = null; var v_Y_283 = null; var v_a_284 = null; var v_r_285 = null; var v_g_286 = null
	v_ctx_279 = J.arg(a, 0)
	if (not J.t(J.len(J.gp(env["st"], "mist")))):
		return null
	v_s_280 = J.cl(env["sc"], null, [])
	J.mc(v_ctx_279, "save", [])
	for _t227 in J.iter(J.gp(env["st"], "mist")):
		v_m_281 = _t227
		var _t228 = env["Q"]
		var _t229 = J.cl(_t228, null, [J.gp(v_m_281, "x"), J.gp(v_m_281, "y")])
		var _t230 = J.gp(_t229, 0.0)
		v_X_282 = _t230
		var _t231 = J.gp(_t229, 1.0)
		v_Y_283 = _t231
		v_a_284 = (sin(J.num(J.mul(J.min_([1.0, J.div(J.gp(v_m_281, "t"), J.gp(v_m_281, "life"))]), env["PI"]))) * 0.13)
		v_r_285 = J.mul(J.gp(v_m_281, "r"), v_s_280)
		v_g_286 = J.mc(v_ctx_279, "createRadialGradient", [v_X_282, v_Y_283, 0.0, v_X_282, v_Y_283, v_r_285])
		J.mc(v_g_286, "addColorStop", [0.0, ("rgba(225,240,255," + J.str(v_a_284) + ")")])
		J.mc(v_g_286, "addColorStop", [1.0, "rgba(225,240,255,0)"])
		J.sp(v_ctx_279, "fillStyle", v_g_286)
		J.mc(v_ctx_279, "fillRect", [J.sub(v_X_282, v_r_285), J.sub(v_Y_283, v_r_285), J.mul(v_r_285, 2.0), J.mul(v_r_285, 2.0)])
	J.mc(v_ctx_279, "restore", [])

func _f34(this_, a: Array, env):
	var v_ctx_289 = null; var v_t_290 = null; var v_M_291 = null; var v_s_292 = null; var v_x_293 = null; var v_y_294 = null; var v_w_295 = null; var v_h_296 = null; var v_on_297 = null; var v_X_298 = null; var v_Y_299 = null; var v_a_300 = null; var v_bx_301 = null; var v_bz_302 = null
	v_ctx_289 = J.arg(a, 0)
	v_t_290 = J.arg(a, 1)
	v_M_291 = J.gp(env["st"], "micro")
	v_s_292 = J.cl(env["sc"], null, [])
	var _t232 = env["Q"]
	var _t233 = J.cl(_t232, null, [6864.0, 416.0])
	var _t234 = J.gp(_t233, 0.0)
	v_X_298 = _t234
	var _t235 = J.gp(_t233, 1.0)
	v_Y_299 = _t235
	J.mc(v_ctx_289, "save", [])
	var _t236 = ("700 " + J.str(J.max_([6.0, J.round(J.num(J.mul(9.0, v_s_292)))])) + "px monospace")
	J.sp(v_ctx_289, "font", _t236)
	J.sp(v_ctx_289, "textAlign", "center")
	var _t237 = ("rgba(255,190,90,.95)" if J.t(v_M_291) else ("rgba(120,255,170," + J.str((0.9 if (sin(J.num(J.mul(v_t_290, 3.0))) > 0.0) else 0.45)) + ")"))
	J.sp(v_ctx_289, "fillStyle", _t237)
	var _t239 = null
	if J.t(v_M_291):
		var _t238 = J.F_String([J.max_([0.0, ceil(J.num(J.sub(J.gp(v_M_291, "dur"), J.gp(v_M_291, "t"))))])])
		_t239 = J.add("0:", J.mc(_t238, "padStart", [2.0, "0"]))
	else:
		_t239 = "12:00"
	J.mc(v_ctx_289, "fillText", [_t239, J.add(v_X_298, J.mul(5.0, v_s_292)), v_Y_299])
	J.mc(v_ctx_289, "restore", [])
	if (not J.t(v_M_291)):
		return null
	var _t240 = env["R"]
	var _t241 = J.cl(_t240, null, [6770.0, 406.0, 84.0, 52.0])
	var _t242 = J.gp(_t241, 0.0)
	v_x_293 = _t242
	var _t243 = J.gp(_t241, 1.0)
	v_y_294 = _t243
	var _t244 = J.gp(_t241, 2.0)
	v_w_295 = _t244
	var _t245 = J.gp(_t241, 3.0)
	v_h_296 = _t245
	v_on_297 = J.cmp(J.gp(v_M_291, "t"), J.sub(J.gp(v_M_291, "dur"), 0.8), "<")
	J.mc(v_ctx_289, "save", [])
	var _t246 = env["rr"]
	J.cl(_t246, null, [v_ctx_289, v_x_293, v_y_294, v_w_295, v_h_296, J.mul(4.0, v_s_292)])
	J.mc(v_ctx_289, "clip", [])
	if J.t(v_on_297):
		J.sp(v_ctx_289, "fillStyle", "rgba(255,196,110,.85)")
		J.mc(v_ctx_289, "fillRect", [v_x_293, v_y_294, v_w_295, v_h_296])
		v_a_300 = J.mul(J.gp(v_M_291, "t"), 3.2)
		J.sp(v_ctx_289, "strokeStyle", "rgba(120,70,30,.7)")
		var _t247 = J.max_([1.0, J.mul(1.5, v_s_292)])
		J.sp(v_ctx_289, "lineWidth", _t247)
		J.mc(v_ctx_289, "beginPath", [])
		J.mc(v_ctx_289, "ellipse", [J.add(v_x_293, J.div(v_w_295, 2.0)), J.add(v_y_294, J.mul(v_h_296, 0.8)), J.mul(v_w_295, 0.36), J.mul(v_h_296, 0.1), 0.0, 0.0, J.mul(env["PI"], 2.0)])
		J.mc(v_ctx_289, "stroke", [])
		v_bx_301 = J.add(J.add(v_x_293, J.div(v_w_295, 2.0)), (J.mul(cos(J.num(v_a_300)), v_w_295) * 0.16))
		v_bz_302 = sin(J.num(v_a_300))
		var _t248 = ("#9a5a3a" if J.cmp(v_bz_302, 0.0, ">") else "#7d4a32")
		J.sp(v_ctx_289, "fillStyle", _t248)
		J.mc(v_ctx_289, "beginPath", [])
		J.mc(v_ctx_289, "ellipse", [v_bx_301, J.add(v_y_294, J.mul(v_h_296, 0.72)), (J.mul(v_w_295, 0.13) * (0.85 + (0.15 * absf(J.num(cos(J.num(v_a_300))))))), J.mul(v_h_296, 0.13), 0.0, 0.0, J.mul(env["PI"], 2.0)])
		J.mc(v_ctx_289, "fill", [])
		J.sp(v_ctx_289, "fillStyle", "#c87a4a")
		J.mc(v_ctx_289, "fillRect", [J.sub(v_bx_301, J.mul(v_w_295, 0.12)), J.add(v_y_294, J.mul(v_h_296, 0.6)), J.mul(v_w_295, 0.24), J.mul(v_h_296, 0.1)])
	J.mc(v_ctx_289, "restore", [])
	if J.t(v_on_297):
		var _t249 = env["glowAt"]
		J.cl(_t249, null, [v_ctx_289, 6812.0, 432.0, 110.0, "255,180,90", (0.35 + (0.1 * sin(J.num(J.mul(v_t_290, 30.0)))))])
	if J.t(v_on_297):
		var _t250 = env["sfx"]
		J.cl(_t250, null, [v_ctx_289, 6812.0, 386.0, "嗡——", 20.0, 0.75])
	else:
		var _t251 = env["sfx"]
		J.cl(_t251, null, [v_ctx_289, 6812.0, 386.0, "叮！", 34.0, J.div(J.sub(J.gp(v_M_291, "dur"), J.gp(v_M_291, "t")), 0.8)])

func _f35(this_, a: Array, env):
	var v_ctx_305 = null; var v_t_306 = null; var v_C_307 = null; var v_s_308 = null; var v_k_309 = null; var v_X0_310 = null; var v_Y0_311 = null; var v_Y1_312 = null; var v_x_313 = null; var v_y_314 = null; var v_w_315 = null; var v_h_316 = null; var v_lv_317 = null; var v_i_318 = null; var v_ph_319 = null; var v_X_320 = null; var v_Y_321 = null
	v_ctx_305 = J.arg(a, 0)
	v_t_306 = J.arg(a, 1)
	v_C_307 = J.gp(env["st"], "coffee")
	v_s_308 = J.cl(env["sc"], null, [])
	var _t252 = env["led"]
	J.cl(_t252, null, [v_ctx_305, 6973.0, 381.0, ("255,90,70" if J.t(v_C_307) else "120,255,170"), (0.9 if J.t(v_C_307) else (0.8 if (sin(J.num(J.mul(v_t_306, 1.6))) > 0.3) else 0.25))])
	if (not J.t(v_C_307)):
		return null
	v_k_309 = J.min_([1.0, J.div(J.gp(v_C_307, "t"), J.sub(J.gp(v_C_307, "dur"), 0.6))])
	if J.cmp(J.gp(v_C_307, "t"), J.sub(J.gp(v_C_307, "dur"), 0.6), "<"):
		var _t253 = env["Q"]
		var _t254 = J.cl(_t253, null, [6940.0, 409.0])
		var _t255 = J.gp(_t254, 0.0)
		v_X0_310 = _t255
		var _t256 = J.gp(_t254, 1.0)
		v_Y0_311 = _t256
		var _t257 = env["Q"]
		var _t258 = J.cl(_t257, null, [6940.0, (452.0 - J.mul(v_k_309, 30.0))])
		var _t259 = J.gp(_t258, 1.0)
		v_Y1_312 = _t259
		J.mc(v_ctx_305, "save", [])
		J.sp(v_ctx_305, "strokeStyle", "rgba(70,35,18,.95)")
		var _t260 = J.max_([1.0, J.mul(2.2, v_s_308)])
		J.sp(v_ctx_305, "lineWidth", _t260)
		J.mc(v_ctx_305, "setLineDash", [[J.mul(4.0, v_s_308), J.mul(3.0, v_s_308)]])
		var _t261 = ((-J.num(v_t_306)) * 60.0)
		J.sp(v_ctx_305, "lineDashOffset", _t261)
		J.mc(v_ctx_305, "beginPath", [])
		J.mc(v_ctx_305, "moveTo", [v_X0_310, v_Y0_311])
		J.mc(v_ctx_305, "lineTo", [v_X0_310, v_Y1_312])
		J.mc(v_ctx_305, "stroke", [])
		J.mc(v_ctx_305, "restore", [])
	var _t262 = env["R"]
	var _t263 = J.cl(_t262, null, [6914.0, 415.0, 52.0, 42.0])
	var _t264 = J.gp(_t263, 0.0)
	v_x_313 = _t264
	var _t265 = J.gp(_t263, 1.0)
	v_y_314 = _t265
	var _t266 = J.gp(_t263, 2.0)
	v_w_315 = _t266
	var _t267 = J.gp(_t263, 3.0)
	v_h_316 = _t267
	J.mc(v_ctx_305, "save", [])
	J.mc(v_ctx_305, "beginPath", [])
	J.mc(v_ctx_305, "ellipse", [J.add(v_x_313, J.div(v_w_315, 2.0)), J.add(v_y_314, J.mul(v_h_316, 0.58)), J.mul(v_w_315, 0.5), J.mul(v_h_316, 0.48), 0.0, 0.0, J.mul(env["PI"], 2.0)])
	J.mc(v_ctx_305, "clip", [])
	J.sp(v_ctx_305, "fillStyle", "rgba(80,40,20,.92)")
	v_lv_317 = J.mul(v_h_316, (0.25 + J.mul(0.7, v_k_309)))
	J.mc(v_ctx_305, "fillRect", [v_x_313, J.sub(J.add(v_y_314, v_h_316), v_lv_317), v_w_315, v_lv_317])
	J.sp(v_ctx_305, "fillStyle", "rgba(255,220,180,.25)")
	J.mc(v_ctx_305, "fillRect", [v_x_313, J.sub(J.add(v_y_314, v_h_316), v_lv_317), v_w_315, J.mul(2.0, v_s_308)])
	J.mc(v_ctx_305, "restore", [])
	J.mc(v_ctx_305, "save", [])
	J.sp(v_ctx_305, "lineCap", "round")
	v_i_318 = 0.0
	while true:
		if not J.cmp(v_i_318, 3.0, "<"): break
		v_ph_319 = J.mod((J.mul(v_t_306, 0.7) + J.div(v_i_318, 3.0)), 1.0)
		var _t268 = env["Q"]
		var _t269 = J.cl(_t268, null, [((6930.0 + J.mul(v_i_318, 10.0)) + (sin(J.num(J.add(J.mul(v_t_306, 2.0), v_i_318))) * 4.0)), (366.0 - J.mul(v_ph_319, 60.0))])
		var _t270 = J.gp(_t269, 0.0)
		v_X_320 = _t270
		var _t271 = J.gp(_t269, 1.0)
		v_Y_321 = _t271
		var _t272 = ("rgba(240,235,255," + J.str((0.45 * J.sub(1.0, v_ph_319))) + ")")
		J.sp(v_ctx_305, "strokeStyle", _t272)
		var _t273 = J.max_([1.0, (J.mul(4.0, v_s_308) * (1.0 - J.mul(v_ph_319, 0.5)))])
		J.sp(v_ctx_305, "lineWidth", _t273)
		J.mc(v_ctx_305, "beginPath", [])
		J.mc(v_ctx_305, "moveTo", [v_X_320, v_Y_321])
		J.mc(v_ctx_305, "quadraticCurveTo", [J.add(v_X_320, J.mul(8.0, v_s_308)), J.sub(v_Y_321, J.mul(10.0, v_s_308)), v_X_320, J.sub(v_Y_321, J.mul(20.0, v_s_308))])
		J.mc(v_ctx_305, "stroke", [])
		v_i_318 = J.num(v_i_318) + 1.0
	J.mc(v_ctx_305, "restore", [])
	if J.cmp(J.gp(v_C_307, "t"), 1.0, "<"):
		var _t274 = env["sfx"]
		J.cl(_t274, null, [v_ctx_305, 6942.0, 350.0, "嘀", 22.0, J.sub(1.0, J.gp(v_C_307, "t"))])
	else:
		if J.cmp(J.gp(v_C_307, "t"), J.sub(J.gp(v_C_307, "dur"), 0.6), "<"):
			var _t275 = env["sfx"]
			J.cl(_t275, null, [v_ctx_305, 6942.0, 350.0, "咕嚕咕嚕", 18.0, 0.7])

func _f36(this_, a: Array, env):
	var v_ctx_324 = null; var v_t_325 = null; var v_W_326 = null; var v_s_327 = null; var v_b_328 = null; var v_X_329 = null; var v_Y_330 = null; var v_d_331 = null; var v_X_332 = null; var v_Y_333 = null; var v_X_334 = null; var v_Y0_335 = null; var v_Y1_336 = null; var v_x_337 = null; var v_y_338 = null; var v_w_339 = null; var v_h_340 = null; var v_lv_341 = null
	v_ctx_324 = J.arg(a, 0)
	v_t_325 = J.arg(a, 1)
	v_W_326 = J.gp(env["st"], "water")
	v_s_327 = J.cl(env["sc"], null, [])
	var _t276 = env["led"]
	J.cl(_t276, null, [v_ctx_324, 7344.0, 462.0, "255,120,90", (0.35 + (0.15 * sin(J.num(J.mul(v_t_325, 1.3)))))])
	J.mc(v_ctx_324, "save", [])
	for _t277 in J.iter(J.gp(env["st"], "bub")):
		v_b_328 = _t277
		if J.cmp(J.gp(v_b_328, "t"), 0.0, "<"):
			continue
		var _t278 = env["Q"]
		var _t279 = J.cl(_t278, null, [J.add(J.gp(v_b_328, "x"), (sin(J.num(J.add(J.mul(J.gp(v_b_328, "t"), 9.0), J.gp(v_b_328, "r")))) * 2.0)), J.gp(v_b_328, "y")])
		var _t280 = J.gp(_t279, 0.0)
		v_X_329 = _t280
		var _t281 = J.gp(_t279, 1.0)
		v_Y_330 = _t281
		J.sp(v_ctx_324, "strokeStyle", "rgba(220,240,255,.75)")
		var _t282 = J.max_([1.0, J.mul(1.3, v_s_327)])
		J.sp(v_ctx_324, "lineWidth", _t282)
		J.mc(v_ctx_324, "beginPath", [])
		J.mc(v_ctx_324, "arc", [v_X_329, v_Y_330, J.mul(J.gp(v_b_328, "r"), v_s_327), 0.0, J.mul(env["PI"], 2.0)])
		J.mc(v_ctx_324, "stroke", [])
	J.mc(v_ctx_324, "restore", [])
	J.mc(v_ctx_324, "save", [])
	J.sp(v_ctx_324, "fillStyle", "rgba(160,210,255,.95)")
	for _t283 in J.iter(J.gp(env["st"], "drips")):
		v_d_331 = _t283
		var _t284 = env["Q"]
		var _t285 = J.cl(_t284, null, [J.gp(v_d_331, "x"), J.gp(v_d_331, "y")])
		var _t286 = J.gp(_t285, 0.0)
		v_X_332 = _t286
		var _t287 = J.gp(_t285, 1.0)
		v_Y_333 = _t287
		J.mc(v_ctx_324, "beginPath", [])
		J.mc(v_ctx_324, "ellipse", [v_X_332, v_Y_333, (J.mul(2.2, v_s_327) + 0.6), (J.mul(3.6, v_s_327) + 0.8), 0.0, 0.0, J.mul(env["PI"], 2.0)])
		J.mc(v_ctx_324, "fill", [])
	J.mc(v_ctx_324, "restore", [])
	var _t288 = (J.gp(v_W_326, "leak") if J.t(v_W_326) else v_W_326)
	if J.t((J.cmp(J.gp(v_W_326, "t"), 1.0, ">") if J.t(_t288) else _t288)):
		var _t289 = env["Q"]
		var _t290 = J.cl(_t289, null, [7300.0, 512.0])
		var _t291 = J.gp(_t290, 0.0)
		v_X_334 = _t291
		var _t292 = J.gp(_t290, 1.0)
		v_Y0_335 = _t292
		var _t293 = env["Q"]
		var _t294 = J.cl(_t293, null, [7300.0, 612.0])
		var _t295 = J.gp(_t294, 1.0)
		v_Y1_336 = _t295
		J.mc(v_ctx_324, "save", [])
		J.sp(v_ctx_324, "strokeStyle", "rgba(150,200,255,.5)")
		var _t296 = J.max_([1.0, J.mul(2.0, v_s_327)])
		J.sp(v_ctx_324, "lineWidth", _t296)
		J.mc(v_ctx_324, "setLineDash", [[J.mul(6.0, v_s_327), J.mul(8.0, v_s_327)]])
		var _t297 = ((-J.num(v_t_325)) * 120.0)
		J.sp(v_ctx_324, "lineDashOffset", _t297)
		J.mc(v_ctx_324, "beginPath", [])
		J.mc(v_ctx_324, "moveTo", [v_X_334, v_Y0_335])
		J.mc(v_ctx_324, "lineTo", [v_X_334, v_Y1_336])
		J.mc(v_ctx_324, "stroke", [])
		J.mc(v_ctx_324, "restore", [])
	if J.t((J.gp(v_W_326, "leak") if J.t(v_W_326) else v_W_326)):
		var _t298 = env["sfx"]
		J.cl(_t298, null, [v_ctx_324, 7314.0, 290.0, "滴…滴…", 18.0, J.min_([1.0, J.gp(v_W_326, "t"), J.sub(J.gp(v_W_326, "dur"), J.gp(v_W_326, "t"))])])
	if J.t(((not J.t(J.gp(v_W_326, "leak"))) if J.t(v_W_326) else v_W_326)):
		var _t299 = env["R"]
		var _t300 = J.cl(_t299, null, [7319.0, 486.0, 22.0, 22.0])
		var _t301 = J.gp(_t300, 0.0)
		v_x_337 = _t301
		var _t302 = J.gp(_t300, 1.0)
		v_y_338 = _t302
		var _t303 = J.gp(_t300, 2.0)
		v_w_339 = _t303
		var _t304 = J.gp(_t300, 3.0)
		v_h_340 = _t304
		J.mc(v_ctx_324, "save", [])
		J.sp(v_ctx_324, "fillStyle", "rgba(240,240,250,.9)")
		J.sp(v_ctx_324, "strokeStyle", "#2b2033")
		var _t305 = J.max_([1.0, J.mul(1.4, v_s_327)])
		J.sp(v_ctx_324, "lineWidth", _t305)
		J.mc(v_ctx_324, "fillRect", [v_x_337, v_y_338, v_w_339, v_h_340])
		J.mc(v_ctx_324, "strokeRect", [v_x_337, v_y_338, v_w_339, v_h_340])
		J.sp(v_ctx_324, "fillStyle", "rgba(150,200,255,.8)")
		v_lv_341 = J.mul(v_h_340, J.min_([0.85, J.div(J.gp(v_W_326, "t"), J.gp(v_W_326, "dur"))]))
		J.mc(v_ctx_324, "fillRect", [J.add(v_x_337, 1.0), J.sub(J.add(v_y_338, v_h_340), v_lv_341), J.sub(v_w_339, 2.0), v_lv_341])
		J.mc(v_ctx_324, "restore", [])

func _f37(this_, a: Array, env):
	var v_ctx_344 = null; var v_t_345 = null; var v_V_346 = null; var v_s_347 = null; var v_fl_348 = null; var v_x_349 = null; var v_y_350 = null; var v_w_351 = null; var v_h_352 = null; var v_cx_353 = null; var v_ry_354 = null; var v_k_355 = null; var v_yy_356 = null; var v_g_357 = null; var v_fx0_358 = null; var v_fy0_359 = null; var v_fx1_360 = null; var v_g_361 = null
	v_ctx_344 = J.arg(a, 0)
	v_t_345 = J.arg(a, 1)
	v_V_346 = J.gp(env["st"], "vend")
	v_s_347 = J.cl(env["sc"], null, [])
	var _t306 = J.cmp(J.gp(env["st"], "flick"), 0.0, ">")
	v_fl_348 = (((sin(J.num(J.mul(v_t_345, 47.0))) + sin(J.num(J.mul(v_t_345, 29.0)))) > 0.3) if _t306 else _t306)
	var _t307 = env["R"]
	var _t308 = J.cl(_t307, null, [7398.0, 289.0, 141.0, 211.0])
	var _t309 = J.gp(_t308, 0.0)
	v_x_349 = _t309
	var _t310 = J.gp(_t308, 1.0)
	v_y_350 = _t310
	var _t311 = J.gp(_t308, 2.0)
	v_w_351 = _t311
	var _t312 = J.gp(_t308, 3.0)
	v_h_352 = _t312
	J.mc(v_ctx_344, "save", [])
	var _t313 = ("source-over" if J.t(v_fl_348) else "lighter")
	J.sp(v_ctx_344, "globalCompositeOperation", _t313)
	var _t314 = ("rgba(6,4,18,.5)" if J.t(v_fl_348) else ("rgba(150,215,255," + J.str((0.16 + (0.03 * sin(J.num(J.mul(v_t_345, 5.0)))))) + ")"))
	J.sp(v_ctx_344, "fillStyle", _t314)
	var _t315 = env["rr"]
	J.cl(_t315, null, [v_ctx_344, v_x_349, v_y_350, v_w_351, v_h_352, J.mul(4.0, v_s_347)])
	J.mc(v_ctx_344, "fill", [])
	if (not J.t(v_fl_348)):
		v_g_357 = J.mc(v_ctx_344, "createLinearGradient", [v_x_349, v_y_350, J.add(v_x_349, v_w_351), J.add(v_y_350, v_h_352)])
		J.mc(v_g_357, "addColorStop", [0.0, "rgba(255,255,255,0)"])
		J.mc(v_g_357, "addColorStop", [0.45, "rgba(255,255,255,.14)"])
		J.mc(v_g_357, "addColorStop", [0.55, "rgba(255,255,255,0)"])
		J.sp(v_ctx_344, "fillStyle", v_g_357)
		J.mc(v_ctx_344, "fillRect", [v_x_349, v_y_350, v_w_351, v_h_352])
	J.mc(v_ctx_344, "restore", [])
	if (not J.t(v_fl_348)):
		var _t316 = env["glowAt"]
		J.cl(_t316, null, [v_ctx_344, 7468.0, 400.0, 200.0, "120,190,255", 0.16])
	var _t317 = env["Q"]
	var _t318 = J.cl(_t317, null, [7380.0, 614.0])
	var _t319 = J.gp(_t318, 0.0)
	v_fx0_358 = _t319
	var _t320 = J.gp(_t318, 1.0)
	v_fy0_359 = _t320
	var _t321 = env["Q"]
	var _t322 = J.cl(_t321, null, [7590.0, 614.0])
	var _t323 = J.gp(_t322, 0.0)
	v_fx1_360 = _t323
	J.mc(v_ctx_344, "save", [])
	J.sp(v_ctx_344, "globalCompositeOperation", "lighter")
	v_g_361 = J.mc(v_ctx_344, "createLinearGradient", [0.0, v_fy0_359, 0.0, J.add(v_fy0_359, J.mul(70.0, v_s_347))])
	J.mc(v_g_361, "addColorStop", [0.0, ("rgba(120,190,255," + J.str((0.03 if J.t(v_fl_348) else 0.16)) + ")")])
	J.mc(v_g_361, "addColorStop", [1.0, "rgba(120,190,255,0)"])
	J.sp(v_ctx_344, "fillStyle", v_g_361)
	J.mc(v_ctx_344, "fillRect", [J.sub(v_fx0_358, J.mul(30.0, v_s_347)), v_fy0_359, (J.sub(v_fx1_360, v_fx0_358) + J.mul(60.0, v_s_347)), J.mul(70.0, v_s_347)])
	J.mc(v_ctx_344, "restore", [])
	if (not J.t(v_V_346)):
		return null
	v_cx_353 = (7420.0 + J.mul(J.gp(v_V_346, "col"), 35.0))
	v_ry_354 = (322.0 + J.mul(J.gp(v_V_346, "row"), 50.0))
	v_k_355 = J.min_([1.0, J.div(J.gp(v_V_346, "t"), 1.1)])
	v_yy_356 = J.add(v_ry_354, J.mul(J.mul(J.sub(505.0, v_ry_354), v_k_355), v_k_355))
	if J.cmp(J.gp(v_V_346, "t"), 1.15, "<"):
		J.mc(v_ctx_344, "save", [])
		J.mc(v_ctx_344, "beginPath", [])
		J.mc(v_ctx_344, "rect", [v_x_349, v_y_350, v_w_351, J.add(v_h_352, J.mul(50.0, v_s_347))])
		J.mc(v_ctx_344, "clip", [])
		var _t324 = env["item"]
		J.cl(_t324, null, [v_ctx_344, J.gp(v_V_346, "kind"), J.gp(v_V_346, "hue"), v_cx_353, v_yy_356, 0.0, J.mul(v_k_355, 2.5)])
		J.mc(v_ctx_344, "restore", [])
	var _t325 = J.cmp(J.gp(v_V_346, "t"), 1.1, ">")
	if (J.cmp(J.gp(v_V_346, "t"), 2.2, "<") if _t325 else _t325):
		var _t326 = env["sfx"]
		J.cl(_t326, null, [v_ctx_344, 7474.0, 515.0, "哐咚！", 30.0, (1.0 - J.div(J.sub(J.gp(v_V_346, "t"), 1.1), 1.1))])

func _f38(this_, a: Array, env):
	var v_ctx_364 = null; var v_kind_365 = null; var v_hue_366 = null; var v_bx_367 = null; var v_by_368 = null; var v_rot_369 = null; var v_spin_370 = null; var v_X_371 = null; var v_Y_372 = null; var v_s_373 = null; var v_cw_374 = null; var v_ch_375 = null; var v_cw_376 = null; var v_ch_377 = null
	v_ctx_364 = J.arg(a, 0)
	v_kind_365 = J.arg(a, 1)
	v_hue_366 = J.arg(a, 2)
	v_bx_367 = J.arg(a, 3)
	v_by_368 = J.arg(a, 4)
	v_rot_369 = J.arg(a, 5)
	v_spin_370 = J.arg(a, 6)
	var _t327 = env["Q"]
	var _t328 = J.cl(_t327, null, [v_bx_367, v_by_368])
	var _t329 = J.gp(_t328, 0.0)
	v_X_371 = _t329
	var _t330 = J.gp(_t328, 1.0)
	v_Y_372 = _t330
	v_s_373 = J.mul(J.cl(env["sc"], null, []), 1.5)
	J.mc(v_ctx_364, "save", [])
	J.mc(v_ctx_364, "translate", [v_X_371, J.sub(v_Y_372, J.mul(12.0, v_s_373))])
	J.mc(v_ctx_364, "rotate", [J.add(v_rot_369, (v_spin_370 if J.t(v_spin_370) else 0.0))])
	J.sp(v_ctx_364, "strokeStyle", "#2b2033")
	var _t331 = J.max_([1.0, J.mul(1.6, v_s_373)])
	J.sp(v_ctx_364, "lineWidth", _t331)
	if J.seq(v_kind_365, "can"):
		v_cw_374 = J.mul(16.0, v_s_373)
		v_ch_375 = J.mul(26.0, v_s_373)
		var _t332 = ("hsl(" + J.str(v_hue_366) + ",62%,48%)")
		J.sp(v_ctx_364, "fillStyle", _t332)
		var _t333 = env["rr"]
		J.cl(_t333, null, [v_ctx_364, J.div((-J.num(v_cw_374)), 2.0), J.div((-J.num(v_ch_375)), 2.0), v_cw_374, v_ch_375, J.mul(3.0, v_s_373)])
		J.mc(v_ctx_364, "fill", [])
		J.mc(v_ctx_364, "stroke", [])
		J.sp(v_ctx_364, "fillStyle", "rgba(255,255,255,.85)")
		J.mc(v_ctx_364, "fillRect", [(J.div((-J.num(v_cw_374)), 2.0) + 1.0), ((-J.num(v_ch_375)) * 0.1), J.sub(v_cw_374, 2.0), J.mul(v_ch_375, 0.2)])
		J.sp(v_ctx_364, "fillStyle", "#cfd2da")
		J.mc(v_ctx_364, "fillRect", [(J.div((-J.num(v_cw_374)), 2.0) + 1.0), (J.div((-J.num(v_ch_375)), 2.0) + 1.0), J.sub(v_cw_374, 2.0), J.mul(3.0, v_s_373)])
	else:
		v_cw_376 = J.mul(24.0, v_s_373)
		v_ch_377 = J.mul(30.0, v_s_373)
		var _t334 = ("hsl(" + J.str(v_hue_366) + ",70%,58%)")
		J.sp(v_ctx_364, "fillStyle", _t334)
		J.mc(v_ctx_364, "beginPath", [])
		J.mc(v_ctx_364, "moveTo", [J.div((-J.num(v_cw_376)), 2.0), J.div((-J.num(v_ch_377)), 2.0)])
		J.mc(v_ctx_364, "lineTo", [J.div(v_cw_376, 2.0), J.div((-J.num(v_ch_377)), 2.0)])
		J.mc(v_ctx_364, "lineTo", [(J.div(v_cw_376, 2.0) - J.mul(2.0, v_s_373)), J.div(v_ch_377, 2.0)])
		J.mc(v_ctx_364, "lineTo", [(J.div((-J.num(v_cw_376)), 2.0) + J.mul(2.0, v_s_373)), J.div(v_ch_377, 2.0)])
		J.mc(v_ctx_364, "closePath", [])
		J.mc(v_ctx_364, "fill", [])
		J.mc(v_ctx_364, "stroke", [])
		J.sp(v_ctx_364, "fillStyle", "rgba(255,255,255,.6)")
		J.mc(v_ctx_364, "fillRect", [(J.div((-J.num(v_cw_376)), 2.0) + J.mul(2.0, v_s_373)), J.div((-J.num(v_ch_377)), 2.0), J.sub(v_cw_376, J.mul(4.0, v_s_373)), J.mul(4.0, v_s_373)])
		J.mc(v_ctx_364, "fillRect", [(J.div((-J.num(v_cw_376)), 2.0) + J.mul(3.0, v_s_373)), (J.div(v_ch_377, 2.0) - J.mul(4.0, v_s_373)), J.sub(v_cw_376, J.mul(6.0, v_s_373)), J.mul(3.0, v_s_373)])
		J.sp(v_ctx_364, "fillStyle", "rgba(255,255,255,.75)")
		J.mc(v_ctx_364, "beginPath", [])
		J.mc(v_ctx_364, "arc", [0.0, 0.0, J.mul(5.0, v_s_373), 0.0, J.mul(env["PI"], 2.0)])
		J.mc(v_ctx_364, "fill", [])
	J.mc(v_ctx_364, "restore", [])

func _f39(this_, a: Array, env):
	var v_ctx_380 = null; var v_t_381 = null; var v_id_382 = null
	v_ctx_380 = J.arg(a, 0)
	v_t_381 = J.arg(a, 1)
	J.mc(env["ORIG"], "drawBack", [v_ctx_380, v_t_381])
	var _t335 = (not J.t(J.gp(J.G.get("Scare"), "site")))
	var _t336 = (_t335 if _t335 else (not J.t(J.gp(J.gp(J.G.get("Scare"), "site"), "pano"))))
	var _t337 = (_t336 if _t336 else (not J.t(env["st"])))
	if (_t337 if _t337 else (not J.t(J.cl(env["visible"], null, [])))):
		return null
	for _t338 in J.iter(env["ORDER"]):
		v_id_382 = _t338
		var _t339 = env["popOut"]
		J.cl(_t339, null, [v_ctx_380, v_id_382, v_t_381])
	var _t340 = env["drawMicro"]
	J.cl(_t340, null, [v_ctx_380, v_t_381])
	var _t341 = env["drawCoffee"]
	J.cl(_t341, null, [v_ctx_380, v_t_381])
	var _t342 = env["drawFridge"]
	J.cl(_t342, null, [v_ctx_380, v_t_381])
	var _t343 = env["drawWater"]
	J.cl(_t343, null, [v_ctx_380, v_t_381])
	var _t344 = env["drawVend"]
	J.cl(_t344, null, [v_ctx_380, v_t_381])
	var _t345 = env["drawMist"]
	J.cl(_t345, null, [v_ctx_380])

func _f41(this_, a: Array, env):
	var v_ctx_387 = null; var v_X_388 = null; var v_Y_389 = null; var v_rx_390 = null; var v_a_391 = null; var v_rp_392 = null
	v_ctx_387 = J.arg(a, 0)
	var _t349 = env["__p"]["Q"]
	var _t350 = J.cl(_t349, null, [J.gp(env["p"], "x"), J.mul(J.gp(env["p"], "y"), env["__p"]["SH"])])
	var _t351 = J.gp(_t350, 0.0)
	v_X_388 = _t351
	var _t352 = J.gp(_t350, 1.0)
	v_Y_389 = _t352
	v_rx_390 = J.mul(J.mul(J.gp(env["p"], "r"), env["__p"]["PXU"]), J.cl(env["__p"]["sc"], null, []))
	v_a_391 = (J.max_([0.0, (1.0 - J.div(J.sub(J.gp(env["p"], "t"), J.mul(J.gp(env["p"], "life"), 0.55)), J.mul(J.gp(env["p"], "life"), 0.45)))]) if J.cmp(J.gp(env["p"], "t"), J.mul(J.gp(env["p"], "life"), 0.55), ">") else 1.0)
	if J.cmp(v_rx_390, 1.0, "<"):
		return null
	J.mc(v_ctx_387, "save", [])
	J.sp(v_ctx_387, "globalAlpha", v_a_391)
	J.sp(v_ctx_387, "fillStyle", "rgba(110,150,220,.32)")
	J.mc(v_ctx_387, "beginPath", [])
	J.mc(v_ctx_387, "ellipse", [v_X_388, v_Y_389, v_rx_390, J.mul(v_rx_390, 0.16), 0.0, 0.0, J.mul(env["__p"]["PI"], 2.0)])
	J.mc(v_ctx_387, "ellipse", [J.sub(v_X_388, J.mul(v_rx_390, 0.35)), J.add(v_Y_389, J.mul(v_rx_390, 0.05)), J.mul(v_rx_390, 0.55), J.mul(v_rx_390, 0.11), 0.0, 0.0, J.mul(env["__p"]["PI"], 2.0)])
	J.mc(v_ctx_387, "fill", [])
	J.sp(v_ctx_387, "globalCompositeOperation", "lighter")
	J.sp(v_ctx_387, "strokeStyle", "rgba(200,225,255,.35)")
	J.sp(v_ctx_387, "lineWidth", 1.5)
	J.mc(v_ctx_387, "beginPath", [])
	J.mc(v_ctx_387, "ellipse", [J.add(v_X_388, J.mul(v_rx_390, 0.15)), J.sub(v_Y_389, J.mul(v_rx_390, 0.03)), J.mul(v_rx_390, 0.5), J.mul(v_rx_390, 0.06), 0.0, J.mul(env["__p"]["PI"], 1.1), J.mul(env["__p"]["PI"], 1.8)])
	J.mc(v_ctx_387, "stroke", [])
	var _t353 = J.gp(J.G.get("Scare"), "t")
	v_rp_392 = J.mod(J.mul((_t353 if J.t(_t353) else 0.0), 0.8), 1.0)
	var _t354 = ("rgba(200,225,255," + J.str((0.3 * J.sub(1.0, v_rp_392))) + ")")
	J.sp(v_ctx_387, "strokeStyle", _t354)
	J.mc(v_ctx_387, "beginPath", [])
	J.mc(v_ctx_387, "ellipse", [J.add(v_X_388, J.mul(v_rx_390, 0.2)), v_Y_389, J.mul(J.mul(v_rx_390, 0.3), v_rp_392), J.mul(J.mul(v_rx_390, 0.05), v_rp_392), 0.0, 0.0, J.mul(env["__p"]["PI"], 2.0)])
	J.mc(v_ctx_387, "stroke", [])
	J.mc(v_ctx_387, "restore", [])

func _f42(this_, a: Array, env):
	var v_ctx_395 = null; var v_a_396 = null; var v_inSlot_397 = null; var v_X_398 = null; var v_Y_399 = null; var v_s_400 = null; var v_sx_401 = null; var v_sy_402 = null
	v_ctx_395 = J.arg(a, 0)
	v_a_396 = ((1.0 - J.div(J.sub(J.gp(env["__p"]["it"], "t"), 12.0), 2.0)) if J.cmp(J.gp(env["__p"]["it"], "t"), 12.0, ">") else 1.0)
	v_inSlot_397 = J.cmp(J.gp(env["__p"]["it"], "t"), 0.25, "<")
	var _t356 = env["__p"]["__p"]["Q"]
	var _t357 = J.cl(_t356, null, [J.gp(env["__p"]["it"], "x"), J.mul(env["yy"], env["__p"]["__p"]["SH"])])
	var _t358 = J.gp(_t357, 0.0)
	v_X_398 = _t358
	var _t359 = J.gp(_t357, 1.0)
	v_Y_399 = _t359
	v_s_400 = J.cl(env["__p"]["__p"]["sc"], null, [])
	J.mc(v_ctx_395, "save", [])
	J.sp(v_ctx_395, "globalAlpha", v_a_396)
	if (not J.t(v_inSlot_397)):
		J.sp(v_ctx_395, "fillStyle", "rgba(6,4,18,.35)")
		J.mc(v_ctx_395, "beginPath", [])
		J.mc(v_ctx_395, "ellipse", [v_X_398, v_Y_399, J.mul(14.0, v_s_400), J.mul(3.5, v_s_400), 0.0, 0.0, J.mul(env["__p"]["__p"]["PI"], 2.0)])
		J.mc(v_ctx_395, "fill", [])
	if J.t(v_inSlot_397):
		J.mc(v_ctx_395, "beginPath", [])
		var _t360 = env["__p"]["__p"]["Q"]
		var _t361 = J.cl(_t360, null, [7414.0, 518.0])
		var _t362 = J.gp(_t361, 0.0)
		v_sx_401 = _t362
		var _t363 = J.gp(_t361, 1.0)
		v_sy_402 = _t363
		J.mc(v_ctx_395, "rect", [v_sx_401, v_sy_402, J.mul(120.0, v_s_400), J.mul(36.0, v_s_400)])
		J.mc(v_ctx_395, "clip", [])
		var _t364 = env["__p"]["__p"]["item"]
		J.cl(_t364, null, [v_ctx_395, J.gp(env["__p"]["it"], "kind"), J.gp(env["__p"]["it"], "hue"), J.gp(env["__p"]["it"], "x"), 552.0, 0.0])
	else:
		var _t365 = env["__p"]["__p"]["item"]
		J.cl(_t365, null, [v_ctx_395, J.gp(env["__p"]["it"], "kind"), J.gp(env["__p"]["it"], "hue"), J.gp(env["__p"]["it"], "x"), J.mul(env["yy"], env["__p"]["__p"]["SH"]), (J.gp(env["__p"]["it"], "rot") if J.seq(J.gp(env["__p"]["it"], "kind"), "can") else ((-0.15) + (J.min_([J.gp(env["__p"]["it"], "t"), 1.0]) * (-1.25))))])
	J.mc(v_ctx_395, "restore", [])
	var _t366 = J.cmp(J.gp(env["__p"]["it"], "t"), 0.25, ">")
	if (J.cmp(J.gp(env["__p"]["it"], "t"), 1.3, "<") if _t366 else _t366):
		var _t367 = env["__p"]["__p"]["sfx"]
		J.cl(_t367, null, [v_ctx_395, J.gp(env["__p"]["it"], "x"), (J.mul(env["yy"], env["__p"]["__p"]["SH"]) - 50.0), ("咕碌咕碌" if J.seq(J.gp(env["__p"]["it"], "kind"), "can") else "啪"), 16.0, (1.0 - J.sub(J.gp(env["__p"]["it"], "t"), 0.25))])

func _f43(this_, a: Array, env):
	var v_ctx_405 = null
	v_ctx_405 = J.arg(a, 0)
	var _t371 = env["__p"]["chair"]
	return J.cl(_t371, null, [v_ctx_405, env["sx"], env["sy"]])

func _f44(this_, a: Array, env):
	var v_ctx_406 = null
	v_ctx_406 = J.arg(a, 0)
	var _t372 = env["drawTable"]
	return J.cl(_t372, null, [v_ctx_406, J.cl(env["t0"], null, [])])

func _f40(this_, a: Array, env):
	var v_out_385 = null
	v_out_385 = J.mc(env["ORIG"], "drawables", [])
	var _t346 = (not J.t(env["st"]))
	var _t347 = (_t346 if _t346 else (not J.t(J.gp(J.G.get("Scare"), "site"))))
	if (_t347 if _t347 else (not J.t(J.gp(J.gp(J.G.get("Scare"), "site"), "pano")))):
		return v_out_385
	for _t348 in J.iter(J.gp(env["st"], "puddles")):
		var _s124 = {"__p": env, "p": null}
		_s124["p"] = _t348
		J.mc(v_out_385, "push", [[0.625, Callable(self, "_f41").bind(_s124)]])
	for _t355 in J.iter(J.gp(env["st"], "items")):
		var _s126 = {"__p": env, "it": null}
		_s126["it"] = _t355
		var _s127 = {"__p": _s126, "yy": null}
		_s127["yy"] = J.gp(_s127["__p"]["it"], "y")
		J.mc(v_out_385, "push", [[_s127["yy"], Callable(self, "_f42").bind(_s127)]])
	for _t368 in J.iter(env["seats"]):
		var _s131 = {"__p": env, "sx": null, "sy": null}
		var _t369 = J.gp(_t368, 0.0)
		_s131["sx"] = _t369
		var _t370 = J.gp(_t368, 1.0)
		_s131["sy"] = _t370
		J.mc(v_out_385, "push", [[J.sub(_s131["sy"], 0.004), Callable(self, "_f43").bind(_s131)]])
	J.mc(v_out_385, "push", [[J.gp(env["table"], 1.0), Callable(self, "_f44").bind(env)]])
	return v_out_385

func _f46(this_, a: Array, env):
	var v_ctx_409 = null; var v_x_410 = null; var v_y_411 = null; var v_im_412 = null; var v_X_413 = null; var v_Y_414 = null; var v_H_415 = null; var v_W_416 = null; var v_c_417 = null; var v_g_418 = null
	v_ctx_409 = J.arg(a, 0)
	v_x_410 = J.arg(a, 1)
	v_y_411 = J.arg(a, 2)
	var _t373 = env["ok"]
	if (not J.t(J.cl(_t373, null, ["of_chair_front"]))):
		return null
	v_im_412 = J.gp(J.G.get("SPR"), "of_chair_front")
	var _t374 = J.mc(J.G.get("Scare"), "pt", [v_x_410, v_y_411])
	var _t375 = J.gp(_t374, 0.0)
	v_X_413 = _t375
	var _t376 = J.gp(_t374, 1.0)
	v_Y_414 = _t376
	v_H_415 = J.mul(J.mc(J.G.get("Scare"), "hh", [v_y_411]), 0.6)
	v_W_416 = J.div(J.mul(v_H_415, J.gp(v_im_412, "naturalWidth")), J.gp(v_im_412, "naturalHeight"))
	J.mc(v_ctx_409, "save", [])
	J.sp(v_ctx_409, "fillStyle", "rgba(6,4,18,.3)")
	J.mc(v_ctx_409, "beginPath", [])
	J.mc(v_ctx_409, "ellipse", [v_X_413, v_Y_414, J.mul(v_W_416, 0.42), J.mul(v_W_416, 0.09), 0.0, 0.0, J.mul(env["PI"], 2.0)])
	J.mc(v_ctx_409, "fill", [])
	if (not J.t(J.gp(env["DIMC"], "chair"))):
		v_c_417 = J.S_document_("createElement", ["canvas"])
		var _t377 = J.gp(v_im_412, "naturalWidth")
		J.sp(v_c_417, "width", _t377)
		var _t378 = J.gp(v_im_412, "naturalHeight")
		J.sp(v_c_417, "height", _t378)
		v_g_418 = J.mc(v_c_417, "getContext", ["2d"])
		J.sp(v_g_418, "filter", "brightness(.78) saturate(.9)")
		J.mc(v_g_418, "drawImage", [v_im_412, 0.0, 0.0])
		var _t379 = env["DIMC"]
		J.sp(_t379, "chair", v_c_417)
	J.mc(v_ctx_409, "drawImage", [J.gp(env["DIMC"], "chair"), J.sub(v_X_413, J.div(v_W_416, 2.0)), J.sub(v_Y_414, v_H_415), v_W_416, v_H_415])
	J.mc(v_ctx_409, "restore", [])

func _f47(this_, a: Array, env):
	var v_ctx_421 = null; var v_x_422 = null; var v_y_423 = null; var v_X_424 = null; var v_Y_425 = null; var v_u_426 = null; var v_R0_427 = null; var v_top_428 = null; var v_lw_429 = null; var v_im_430 = null; var v_mh_431 = null; var v_mw_432 = null; var v_im_433 = null; var v_mh_434 = null; var v_mw_435 = null
	v_ctx_421 = J.arg(a, 0)
	var _t380 = env["table"]
	var _t381 = J.gp(_t380, 0.0)
	v_x_422 = _t381
	var _t382 = J.gp(_t380, 1.0)
	v_y_423 = _t382
	var _t383 = J.mc(J.G.get("Scare"), "pt", [v_x_422, v_y_423])
	var _t384 = J.gp(_t383, 0.0)
	v_X_424 = _t384
	var _t385 = J.gp(_t383, 1.0)
	v_Y_425 = _t385
	v_u_426 = J.mc(J.G.get("Scare"), "hh", [v_y_423])
	v_R0_427 = J.mul(v_u_426, 0.36)
	v_top_428 = J.sub(v_Y_425, J.mul(v_u_426, 0.4))
	v_lw_429 = J.max_([1.5, J.mul(v_u_426, 0.012)])
	J.mc(v_ctx_421, "save", [])
	J.sp(v_ctx_421, "lineJoin", "round")
	J.sp(v_ctx_421, "strokeStyle", "#2a1f2e")
	J.sp(v_ctx_421, "lineWidth", v_lw_429)
	J.sp(v_ctx_421, "fillStyle", "rgba(6,4,18,.38)")
	J.mc(v_ctx_421, "beginPath", [])
	J.mc(v_ctx_421, "ellipse", [v_X_424, v_Y_425, J.mul(v_R0_427, 0.75), J.mul(v_R0_427, 0.16), 0.0, 0.0, J.mul(env["PI"], 2.0)])
	J.mc(v_ctx_421, "fill", [])
	J.sp(v_ctx_421, "fillStyle", "#7b6878")
	J.mc(v_ctx_421, "beginPath", [])
	J.mc(v_ctx_421, "ellipse", [v_X_424, J.sub(v_Y_425, J.mul(v_u_426, 0.012)), J.mul(v_R0_427, 0.42), J.mul(v_R0_427, 0.09), 0.0, 0.0, J.mul(env["PI"], 2.0)])
	J.mc(v_ctx_421, "fill", [])
	J.mc(v_ctx_421, "stroke", [])
	J.sp(v_ctx_421, "fillStyle", "#8c7a88")
	J.mc(v_ctx_421, "fillRect", [J.sub(v_X_424, J.mul(v_u_426, 0.022)), v_top_428, J.mul(v_u_426, 0.044), (J.sub(v_Y_425, v_top_428) - J.mul(v_u_426, 0.012))])
	J.mc(v_ctx_421, "strokeRect", [J.sub(v_X_424, J.mul(v_u_426, 0.022)), v_top_428, J.mul(v_u_426, 0.044), (J.sub(v_Y_425, v_top_428) - J.mul(v_u_426, 0.012))])
	J.sp(v_ctx_421, "fillStyle", "#9f8079")
	J.mc(v_ctx_421, "beginPath", [])
	J.mc(v_ctx_421, "ellipse", [v_X_424, J.add(v_top_428, J.mul(v_u_426, 0.03)), v_R0_427, J.mul(v_R0_427, 0.26), 0.0, 0.0, J.mul(env["PI"], 2.0)])
	J.mc(v_ctx_421, "fill", [])
	J.mc(v_ctx_421, "stroke", [])
	J.sp(v_ctx_421, "fillStyle", "#c9a99a")
	J.mc(v_ctx_421, "beginPath", [])
	J.mc(v_ctx_421, "ellipse", [v_X_424, v_top_428, v_R0_427, J.mul(v_R0_427, 0.26), 0.0, 0.0, J.mul(env["PI"], 2.0)])
	J.mc(v_ctx_421, "fill", [])
	J.mc(v_ctx_421, "stroke", [])
	J.sp(v_ctx_421, "strokeStyle", "rgba(255,240,230,.25)")
	var _t386 = J.mul(v_lw_429, 0.8)
	J.sp(v_ctx_421, "lineWidth", _t386)
	J.mc(v_ctx_421, "beginPath", [])
	J.mc(v_ctx_421, "ellipse", [v_X_424, v_top_428, J.mul(v_R0_427, 0.78), J.mul(v_R0_427, 0.18), 0.0, J.mul(env["PI"], 1.1), J.mul(env["PI"], 1.6)])
	J.mc(v_ctx_421, "stroke", [])
	var _t387 = env["ok"]
	if J.t(J.cl(_t387, null, ["op_mug"])):
		v_im_430 = J.gp(J.G.get("SPR"), "op_mug")
		v_mh_431 = J.mul(v_u_426, 0.09)
		v_mw_432 = J.div(J.mul(v_mh_431, J.gp(v_im_430, "naturalWidth")), J.gp(v_im_430, "naturalHeight"))
		J.mc(v_ctx_421, "drawImage", [v_im_430, (J.sub(v_X_424, J.mul(v_R0_427, 0.45)) - J.div(v_mw_432, 2.0)), J.sub(v_top_428, J.mul(v_mh_431, 0.85)), v_mw_432, v_mh_431])
	var _t388 = env["ok"]
	if J.t(J.cl(_t388, null, ["op_phone"])):
		v_im_433 = J.gp(J.G.get("SPR"), "op_phone")
		v_mh_434 = J.mul(v_u_426, 0.05)
		v_mw_435 = J.div(J.mul(v_mh_434, J.gp(v_im_433, "naturalWidth")), J.gp(v_im_433, "naturalHeight"))
		J.mc(v_ctx_421, "drawImage", [v_im_433, J.sub(J.add(v_X_424, J.mul(v_R0_427, 0.3)), J.div(v_mw_435, 2.0)), J.sub(v_top_428, J.mul(v_mh_434, 0.6)), v_mw_435, v_mh_434])
	J.mc(v_ctx_421, "restore", [])

func _f2(this_, a: Array, env):
	var v_yue_53 = null; var v_zh_54 = null
	v_yue_53 = J.arg(a, 0)
	v_zh_54 = J.arg(a, 1)
	if (not J.seq(J.typeof_(J.G.get("LANG")), "undefined")):
		J.mc(J.G.get("LANG"), "add", [{J.key(v_yue_53): v_zh_54}])
	return v_yue_53

func _f3(this_, a: Array, env):
	var v_sh_55 = null; var v_x0_56 = null; var v_y0_57 = null; var v_x1_58 = null; var v_y1_59 = null; var v_x_60 = null; var v_y_61 = null; var v_w_62 = null; var v_h_63 = null
	v_sh_55 = J.arg(a, 0)
	v_x0_56 = 1000000000.0
	v_y0_57 = 1000000000.0
	v_x1_58 = (-1000000000.0)
	v_y1_59 = (-1000000000.0)
	for _t389 in J.iter(v_sh_55):
		var _t390 = J.gp(_t389, 0.0)
		v_x_60 = _t390
		var _t391 = J.gp(_t389, 1.0)
		v_y_61 = _t391
		var _t392 = J.gp(_t389, 2.0)
		v_w_62 = _t392
		var _t393 = J.gp(_t389, 3.0)
		v_h_63 = _t393
		var _t394 = J.min_([v_x0_56, v_x_60])
		v_x0_56 = _t394
		var _t395 = J.min_([v_y0_57, v_y_61])
		v_y0_57 = _t395
		var _t396 = J.max_([v_x1_58, J.add(v_x_60, v_w_62)])
		v_x1_58 = _t396
		var _t397 = J.max_([v_y1_59, J.add(v_y_61, v_h_63)])
		v_y1_59 = _t397
	return [v_x0_56, v_y0_57, J.sub(v_x1_58, v_x0_56), J.sub(v_y1_59, v_y0_57)]

func _f4(this_, a: Array, env):
	var v_k_65 = null
	v_k_65 = J.arg(a, 0)
	var _t402 = J.seq(J.typeof_(J.G.get("sprOk")), "function")
	if J.t(_t402):
		var _t401 = J.G.get("sprOk")
		_t402 = J.cl(_t401, null, [v_k_65])
	return _t402

func _f5(this_, a: Array, env):
	return J.gp(J.mc(J.G.get("Scare"), "bgScale", []), "s")

func _f6(this_, a: Array, env):
	var v_x_66 = null; var v_y_67 = null
	v_x_66 = J.arg(a, 0)
	v_y_67 = J.arg(a, 1)
	return J.mc(J.G.get("Scare"), "pt", [J.div(v_x_66, env["PXU"]), J.div(v_y_67, env["SH"])])

func _f7(this_, a: Array, env):
	var v_c_68 = null; var v_x_69 = null; var v_y_70 = null; var v_w_71 = null; var v_h_72 = null; var v_r_73 = null
	v_c_68 = J.arg(a, 0)
	v_x_69 = J.arg(a, 1)
	v_y_70 = J.arg(a, 2)
	v_w_71 = J.arg(a, 3)
	v_h_72 = J.arg(a, 4)
	v_r_73 = J.arg(a, 5)
	J.mc(v_c_68, "beginPath", [])
	J.mc(v_c_68, "moveTo", [J.add(v_x_69, v_r_73), v_y_70])
	J.mc(v_c_68, "arcTo", [J.add(v_x_69, v_w_71), v_y_70, J.add(v_x_69, v_w_71), J.add(v_y_70, v_h_72), v_r_73])
	J.mc(v_c_68, "arcTo", [J.add(v_x_69, v_w_71), J.add(v_y_70, v_h_72), v_x_69, J.add(v_y_70, v_h_72), v_r_73])
	J.mc(v_c_68, "arcTo", [v_x_69, J.add(v_y_70, v_h_72), v_x_69, v_y_70, v_r_73])
	J.mc(v_c_68, "arcTo", [v_x_69, v_y_70, J.add(v_x_69, v_w_71), v_y_70, v_r_73])
	J.mc(v_c_68, "closePath", [])

func _f11(this_, a: Array, env):
	var v_a_111 = null; var v_b_112 = null
	var _t403 = env["Q"]
	var _t404 = J.cl(_t403, null, [6480.0, 0.0])
	var _t405 = J.gp(_t404, 0.0)
	v_a_111 = _t405
	var _t406 = env["Q"]
	var _t407 = J.cl(_t406, null, [7640.0, 0.0])
	var _t408 = J.gp(_t407, 0.0)
	v_b_112 = _t408
	var _t410 = J.cmp(v_b_112, (-40.0), ">")
	if J.t(_t410):
		var _t409 = J.gp(J.G.get("Scare"), "W")
		_t410 = J.cmp(v_a_111, J.add((_t409 if J.t(_t409) else 390.0), 40.0), "<")
	return _t410

func _f17(this_, a: Array, env):
	var v_a_127 = null
	v_a_127 = J.arg(a, 0)
	return J.gp(v_a_127, floor(J.num((randf() * J.len(v_a_127)))))

func _f25(this_, a: Array, env):
	var v_x_159 = null
	v_x_159 = J.arg(a, 0)
	return (0.0 if J.cmp(v_x_159, 0.0, "<") else (1.0 if J.cmp(v_x_159, 1.0, ">") else (J.mul(v_x_159, v_x_159) * (3.0 - J.mul(2.0, v_x_159)))))

func _f28(this_, a: Array, env):
	var v_x_209 = null; var v_y_210 = null; var v_w_211 = null; var v_h_212 = null; var v_a_213 = null; var v_b_214 = null; var v_s_215 = null
	v_x_209 = J.arg(a, 0)
	v_y_210 = J.arg(a, 1)
	v_w_211 = J.arg(a, 2)
	v_h_212 = J.arg(a, 3)
	var _t411 = env["Q"]
	var _t412 = J.cl(_t411, null, [v_x_209, v_y_210])
	var _t413 = J.gp(_t412, 0.0)
	v_a_213 = _t413
	var _t414 = J.gp(_t412, 1.0)
	v_b_214 = _t414
	v_s_215 = J.cl(env["sc"], null, [])
	return [v_a_213, v_b_214, J.mul(v_w_211, v_s_215), J.mul(v_h_212, v_s_215)]

func _f45(this_, a: Array, env):
	var _t415 = J.gp(J.G.get("Scare"), "t")
	return (_t415 if J.t(_t415) else 0.0)

func _f48(this_, a: Array, env):
	var v_S_438 = null
	v_S_438 = J.arg(a, 0)
	J.cl(env["reset"], null, [])
	var _t417 = J.gp(env["ORIG"], "init")
	return J.mc(_t417, "apply", [this_, a])

func _f49(this_, a: Array, env):
	var v_dt_441 = null; var v_r_442 = null; var v_e_443 = null
	v_dt_441 = J.arg(a, 0)
	var _t420 = J.gp(env["ORIG"], "tick")
	v_r_442 = J.mc(_t420, "apply", [this_, a])
	var _t421 = env["tick"]
	J.cl(_t421, null, [v_dt_441])
	return v_r_442

func _f50(this_, a: Array, env):
	var v_ctx_446 = null; var v_t_447 = null
	v_ctx_446 = J.arg(a, 0)
	v_t_447 = J.arg(a, 1)
	var _t424 = env["drawBack"]
	J.cl(_t424, null, [v_ctx_446, v_t_447])

func _f51(this_, a: Array, env):
	return J.cl(env["drawables"], null, [])

func _f52(this_, a: Array, env):
	var v_k_452 = null; var v_n_453 = null; var v_room_454 = null; var v_m_455 = null
	v_k_452 = J.arg(a, 0)
	v_n_453 = J.arg(a, 1)
	v_room_454 = J.arg(a, 2)
	v_m_455 = J.gp({"micro": "micro", "fridge": "fridge", "vend": "vend", "water": "water", "coffee": "coffee"}, v_k_452)
	if J.t(v_m_455):
		var _t429 = env["fx"]
		return J.cl(_t429, null, [v_m_455, v_n_453, false])
	var _t430 = J.gp(env["ORIG"], "onProp")
	return J.mc(_t430, "apply", [this_, a])

func _f53(this_, a: Array, env):
	var v_k_456 = null; var v_n_457 = null
	v_k_456 = J.arg(a, 0)
	v_n_457 = J.arg(a, 1)
	var _t432 = env["fx"]
	return J.cl(_t432, null, [v_k_456, v_n_457, false])

func _f54(this_, a: Array, env):
	var v_k_458 = null; var v_n_459 = null
	v_k_458 = J.arg(a, 0)
	v_n_459 = J.arg(a, 1)
	var _t433 = env["fx"]
	return J.cl(_t433, null, [v_k_458, v_n_459, true])

func _f55(this_, a: Array, env):
	return ({"micro": (not (not J.t(J.gp(env["st"], "micro")))), "coffee": (not (not J.t(J.gp(env["st"], "coffee")))), "fridge": (not (not J.t(J.gp(env["st"], "fridge")))), "water": (not (not J.t(J.gp(env["st"], "water")))), "vend": (not (not J.t(J.gp(env["st"], "vend")))), "items": J.len(J.gp(env["st"], "items")), "puddles": J.len(J.gp(env["st"], "puddles"))} if J.t(env["st"]) else env["st"])

func _f1(this_, a: Array, env):
	var v_D_5 = null; var v_box_9 = null; var v_last_15 = null; var v_EV_27 = null; var v_k_64 = null
	var _s2 = {"__p": env, "PXU": null, "SH": null, "PI": null, "LINES": null, "AP": null, "ORDER": null, "table": null, "seats": null, "NIGHT": null, "CUT": null, "st": null, "ok": null, "sc": null, "Q": null, "rr": null, "night": null, "SHC": null, "DIMC": null, "cut": null, "cutRect": null, "visible": null, "reset": null, "fx": null, "pick": null, "tick": null, "USE": null, "npcUse": null, "ease": null, "fridgeOpen": null, "popOut": null, "R": null, "glowAt": null, "led": null, "sfx": null, "drawFridge": null, "drawMist": null, "drawMicro": null, "drawCoffee": null, "drawWater": null, "drawVend": null, "item": null, "drawBack": null, "drawables": null, "t0": null, "chair": null, "drawTable": null, "ORIG": null}
	_s2["night"] = Callable(self, "_f8").bind(_s2)
	_s2["cut"] = Callable(self, "_f9").bind(_s2)
	_s2["cutRect"] = Callable(self, "_f10").bind(_s2)
	_s2["reset"] = Callable(self, "_f12").bind(_s2)
	_s2["fx"] = Callable(self, "_f13").bind(_s2)
	_s2["tick"] = Callable(self, "_f18").bind(_s2)
	_s2["npcUse"] = Callable(self, "_f24").bind(_s2)
	_s2["fridgeOpen"] = Callable(self, "_f26").bind(_s2)
	_s2["popOut"] = Callable(self, "_f27").bind(_s2)
	_s2["glowAt"] = Callable(self, "_f29").bind(_s2)
	_s2["led"] = Callable(self, "_f30").bind(_s2)
	_s2["sfx"] = Callable(self, "_f31").bind(_s2)
	_s2["drawFridge"] = Callable(self, "_f32").bind(_s2)
	_s2["drawMist"] = Callable(self, "_f33").bind(_s2)
	_s2["drawMicro"] = Callable(self, "_f34").bind(_s2)
	_s2["drawCoffee"] = Callable(self, "_f35").bind(_s2)
	_s2["drawWater"] = Callable(self, "_f36").bind(_s2)
	_s2["drawVend"] = Callable(self, "_f37").bind(_s2)
	_s2["item"] = Callable(self, "_f38").bind(_s2)
	_s2["drawBack"] = Callable(self, "_f39").bind(_s2)
	_s2["drawables"] = Callable(self, "_f40").bind(_s2)
	_s2["chair"] = Callable(self, "_f46").bind(_s2)
	_s2["drawTable"] = Callable(self, "_f47").bind(_s2)
	_s2["PXU"] = 1165.0
	_s2["SH"] = 1024.0
	_s2["PI"] = PI
	v_D_5 = Callable(self, "_f2").bind(_s2)
	_s2["LINES"] = {"fridge": [J.cl(v_D_5, null, ["雪櫃門……自己開咗？", "冰箱門……自己開了？"]), J.cl(v_D_5, null, ["喂，邊個開咗雪櫃唔閂啊？", "喂，誰打開冰箱沒關啊？"])], "vend": [J.cl(v_D_5, null, ["我都未入錢……點解會跌嘢出嚟？", "我都還沒投錢……怎麼會掉東西出來？"])], "water": [J.cl(v_D_5, null, ["水機漏水呀？成地都係……", "飲水機漏水啊？滿地都是……"])], "coffee": [J.cl(v_D_5, null, ["咖啡機自己沖咖啡？我冇撳掣喎……", "咖啡機自己沖咖啡？我沒按按鈕啊……"])], "micro": [J.cl(v_D_5, null, ["入面冇嘢……佢叮乜嘢啊？", "裡面沒東西……它在叮什麼啊？"])]}
	_s2["AP"] = {"cab": {"sh": [[6514.0, 206.0, 552.0, 132.0, 6.0]], "floor": false}, "micro": {"sh": [[6757.0, 392.0, 132.0, 79.0, 9.0]], "floor": false}, "coffee": {"sh": [[6899.0, 365.0, 88.0, 106.0, 9.0]], "floor": false}, "fridge": {"sh": [[7073.0, 249.0, 186.0, 366.0, 13.0]], "floor": true}, "water": {"sh": [[7268.0, 300.0, 92.0, 116.0, 16.0], [7263.0, 405.0, 102.0, 210.0, 10.0]], "floor": true}, "vend": {"sh": [[7371.0, 262.0, 227.0, 353.0, 9.0]], "floor": true}}
	_s2["ORDER"] = ["cab", "micro", "coffee", "fridge", "water", "vend"]
	v_box_9 = Callable(self, "_f3").bind(_s2)
	for _t398 in J.keys(_s2["AP"]):
		v_k_64 = _t398
		var _t399 = J.gp(_s2["AP"], v_k_64)
		var _t400 = J.cl(v_box_9, null, [J.gp(J.gp(_s2["AP"], v_k_64), "sh")])
		J.sp(_t399, "b", _t400)
	_s2["table"] = J.gp(J.gp(J.G.get("OFFMAP"), "SPOT"), "restTable")
	_s2["seats"] = J.gp(J.gp(J.G.get("OFFMAP"), "SPOT"), "restSeats")
	_s2["NIGHT"] = null
	_s2["CUT"] = {}
	_s2["st"] = null
	v_last_15 = null
	_s2["ok"] = Callable(self, "_f4").bind(_s2)
	_s2["sc"] = Callable(self, "_f5").bind(_s2)
	_s2["Q"] = Callable(self, "_f6").bind(_s2)
	_s2["rr"] = Callable(self, "_f7").bind(_s2)
	_s2["SHC"] = {}
	_s2["DIMC"] = {}
	_s2["visible"] = Callable(self, "_f11").bind(_s2)
	v_EV_27 = {"micro": {"use": 4.0, "scare": 4.5}, "coffee": {"use": 5.0, "scare": 5.0}, "fridge": {"use": 3.0, "scare": 3.4}, "water": {"use": 2.6, "scare": 7.0}}
	_s2["pick"] = Callable(self, "_f17").bind(_s2)
	_s2["USE"] = {"micro": "micro", "coffee": "coffee", "water": "water", "fridge": "fridge", "vend": "vend"}
	_s2["ease"] = Callable(self, "_f25").bind(_s2)
	_s2["R"] = Callable(self, "_f28").bind(_s2)
	_s2["t0"] = Callable(self, "_f45").bind(_s2)
	_s2["ORIG"] = {"drawBack": J.gp(J.G.get("OFFMAP"), "drawBack"), "drawables": J.gp(J.G.get("OFFMAP"), "drawables"), "tick": J.gp(J.G.get("OFFMAP"), "tick"), "onProp": J.gp(J.G.get("OFFMAP"), "onProp"), "init": J.gp(J.G.get("OFFMAP"), "init")}
	var _t416 = J.G.get("OFFMAP")
	var _t418 = Callable(self, "_f48").bind(_s2)
	J.sp(_t416, "init", _t418)
	var _t419 = J.G.get("OFFMAP")
	var _t422 = Callable(self, "_f49").bind(_s2)
	J.sp(_t419, "tick", _t422)
	var _t423 = J.G.get("OFFMAP")
	var _t425 = Callable(self, "_f50").bind(_s2)
	J.sp(_t423, "drawBack", _t425)
	var _t426 = J.G.get("OFFMAP")
	var _t427 = Callable(self, "_f51").bind(_s2)
	J.sp(_t426, "drawables", _t427)
	var _t428 = J.G.get("OFFMAP")
	var _t431 = Callable(self, "_f52").bind(_s2)
	J.sp(_t428, "onProp", _t431)
	return {"table": _s2["table"], "seats": _s2["seats"], "fx": Callable(self, "_f53").bind(_s2), "use": Callable(self, "_f54").bind(_s2), "state": Callable(self, "_f55").bind(_s2), "AP": _s2["AP"]}
