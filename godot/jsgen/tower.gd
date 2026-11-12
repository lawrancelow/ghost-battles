# 自動轉譯自 tower.js（tools/jsgd.js）——唔好直接改，改原 JS 再轉
extends RefCounted

func run(env):
	var this_ = null; var a = []
	J.cl(Callable(self, "_f1").bind(env), null, [])
	var _t1007 = J.G.get("window")
	var _t1008 = {"ppr": {"img": "gb_unit_ppr", "W": 1536.0, "H": 1024.0, "crop": [250.0, 830.0], "floor": 752.0, "ceil": 280.0, "ph": 290.0, "door": 62.0, "rooms": [{"k": "living", "n": "客廳", "x0": 20.0, "x1": 524.0}, {"k": "kitchen", "n": "廚房", "x0": 536.0, "x1": 810.0}, {"k": "bed", "n": "睡房", "x0": 824.0, "x1": 1280.0}, {"k": "bath", "n": "廁所", "x0": 1296.0, "x1": 1520.0}], "spots": [{"k": "lamp", "x": 352.0, "y": 400.0}, {"k": "tv", "x": 474.0, "y": 582.0}, {"k": "tap", "x": 668.0, "y": 572.0}, {"k": "fridge", "x": 770.0, "y": 600.0}, {"k": "wardrobe", "x": 1136.0, "y": 560.0}, {"k": "mirror", "x": 1354.0, "y": 478.0}], "acts": {"sofa": {"x": 330.0, "pose": "sit", "look": "tv"}, "tv": {"x": 356.0, "pose": "sit", "look": "tv"}, "table": {"x": 356.0, "seats": [262.0, 318.0, 398.0, 452.0], "pose": "sit"}, "cook": {"x": 604.0, "look": "tap"}, "sink": {"x": 672.0, "look": "tap"}, "fridge": {"x": 744.0, "look": "fridge"}, "desk": {"x": 872.0, "pose": "sit", "look": "wardrobe"}, "pc": {"x": 872.0, "pose": "sit", "look": "wardrobe"}, "radio": {"x": 356.0, "pose": "sit", "look": "tv"}, "bed": {"x": 1030.0, "pose": "lie", "lift": 66.0}, "shower": {"x": 1440.0}, "wash": {"x": 1352.0, "look": "mirror"}}, "search": [{"x": 456.0, "y": 650.0, "n": "電視櫃"}, {"x": 560.0, "y": 620.0, "n": "碗櫃"}, {"x": 1190.0, "y": 690.0, "n": "衣櫃底"}, {"x": 1358.0, "y": 668.0, "n": "膠桶"}], "steal": {"table": {"x": 356.0, "y": 670.0}, "sofa": {"x": 300.0, "y": 640.0}, "door": {"x": 120.0, "y": 700.0}, "cook": {"x": 600.0, "y": 590.0}, "desk": {"x": 872.0, "y": 600.0}}}, "gamer": {"img": "gb_unit_gamer", "W": 1536.0, "H": 1024.0, "crop": [130.0, 880.0], "floor": 820.0, "ceil": 140.0, "ph": 330.0, "door": 52.0, "rooms": [{"k": "living", "n": "客廳", "x0": 30.0, "x1": 524.0}, {"k": "kitchen", "n": "廚房", "x0": 540.0, "x1": 850.0}, {"k": "bed", "n": "睡房", "x0": 870.0, "x1": 1280.0}, {"k": "bath", "n": "浴室", "x0": 1300.0, "x1": 1520.0}], "spots": [{"k": "pc", "x": 212.0, "y": 530.0}, {"k": "fan", "x": 312.0, "y": 232.0}, {"k": "fridge", "x": 792.0, "y": 560.0}, {"k": "lamp", "x": 1098.0, "y": 524.0}, {"k": "wardrobe", "x": 1190.0, "y": 470.0}, {"k": "shower", "x": 1440.0, "y": 372.0}], "acts": {"pc": {"x": 300.0, "pose": "sit", "look": "pc"}, "desk": {"x": 300.0, "pose": "sit", "look": "pc"}, "sofa": {"x": 430.0, "pose": "sit", "look": "pc"}, "tv": {"x": 430.0, "pose": "sit", "look": "pc"}, "radio": {"x": 452.0, "pose": "sit", "look": "pc"}, "table": {"x": 400.0, "seats": [300.0, 360.0, 420.0, 480.0], "pose": "sit"}, "cook": {"x": 690.0, "look": "fridge"}, "sink": {"x": 640.0}, "fridge": {"x": 760.0, "look": "fridge"}, "bed": {"x": 1000.0, "pose": "lie", "lift": 90.0}, "shower": {"x": 1430.0}, "wash": {"x": 1350.0}}, "search": [{"x": 372.0, "y": 790.0, "n": "零食枱"}, {"x": 610.0, "y": 660.0, "n": "廚櫃"}, {"x": 1220.0, "y": 680.0, "n": "衫籃"}, {"x": 1450.0, "y": 740.0, "n": "水桶"}], "steal": {"pc": {"x": 250.0, "y": 620.0}, "desk": {"x": 250.0, "y": 620.0}, "door": {"x": 110.0, "y": 760.0}, "sofa": {"x": 290.0, "y": 770.0}, "cook": {"x": 660.0, "y": 560.0}}}, "shop": {"img": "gb_unit_shop", "W": 1536.0, "H": 1024.0, "crop": [290.0, 830.0], "floor": 772.0, "ceil": 300.0, "ph": 290.0, "door": 44.0, "rooms": [{"k": "living", "n": "廳", "x0": 20.0, "x1": 464.0}, {"k": "kitchen", "n": "廚房", "x0": 480.0, "x1": 796.0}, {"k": "bed", "n": "睡房", "x0": 810.0, "x1": 1290.0}, {"k": "bath", "n": "沖涼房", "x0": 1300.0, "x1": 1510.0}], "spots": [{"k": "lamp", "x": 262.0, "y": 384.0}, {"k": "radio", "x": 238.0, "y": 582.0}, {"k": "fan", "x": 414.0, "y": 548.0}, {"k": "pots", "x": 552.0, "y": 496.0}, {"k": "net", "x": 1140.0, "y": 530.0}, {"k": "jar", "x": 1424.0, "y": 660.0}], "acts": {"sofa": {"x": 340.0, "pose": "sit", "look": "radio"}, "tv": {"x": 340.0, "pose": "sit", "look": "radio"}, "radio": {"x": 300.0, "pose": "sit", "look": "radio"}, "table": {"x": 270.0, "seats": [150.0, 220.0, 320.0, 380.0], "pose": "sit"}, "cook": {"x": 600.0, "look": "pots"}, "sink": {"x": 700.0}, "fridge": {"x": 700.0}, "desk": {"x": 860.0, "pose": "sit"}, "pc": {"x": 860.0, "pose": "sit"}, "bed": {"x": 1120.0, "pose": "lie", "lift": 80.0}, "shower": {"x": 1380.0, "look": "jar"}, "wash": {"x": 1460.0}}, "search": [{"x": 170.0, "y": 640.0, "n": "木櫃"}, {"x": 680.0, "y": 610.0, "n": "碗櫃"}, {"x": 1200.0, "y": 716.0, "n": "樟木槓"}, {"x": 1470.0, "y": 730.0, "n": "水桶"}], "steal": {"table": {"x": 270.0, "y": 680.0}, "sofa": {"x": 150.0, "y": 690.0}, "door": {"x": 90.0, "y": 740.0}, "cook": {"x": 590.0, "y": 640.0}, "desk": {"x": 856.0, "y": 610.0}}}}
	J.sp(_t1007, "UNIT_LAYOUTS", _t1008)
	J.cl(Callable(self, "_f161").bind(env), null, [])
	J.G["Tower"] = J.cl(Callable(self, "_f329").bind(env), null, [])

func _f4(this_, a: Array, env):
	var v___118 = null; var v_i_119 = null
	v___118 = J.arg(a, 0)
	v_i_119 = J.arg(a, 1)
	return v_i_119

func _f3(this_, a: Array, env):
	var v_k_110 = null; var v_p_111 = null; var v_a_112 = null; var v_i_113 = null; var v_j_114 = null; var v_t_115 = null
	v_k_110 = J.arg(a, 0)
	v_p_111 = J.gp(env["LN"], v_k_110)
	var _t2 = (not J.t(J.gp(env["lnUsed"], v_k_110)))
	if (_t2 if _t2 else (not J.t(J.len(J.gp(env["lnUsed"], v_k_110))))):
		v_a_112 = J.mc(v_p_111, "map", [Callable(self, "_f4").bind(env)])
		v_i_113 = (J.len(v_a_112) - 1.0)
		while true:
			if not J.cmp(v_i_113, 0.0, ">"): break
			v_j_114 = floor(J.num(J.mul(randf(), J.add(v_i_113, 1.0))))
			v_t_115 = J.gp(v_a_112, v_i_113)
			var _t3 = J.gp(v_a_112, v_j_114)
			J.sp(v_a_112, v_i_113, _t3)
			J.sp(v_a_112, v_j_114, v_t_115)
			v_i_113 = J.num(v_i_113) + -1.0
		var _t4 = env["lnUsed"]
		J.sp(_t4, v_k_110, v_a_112)
	return J.gp(v_p_111, J.mc(J.gp(env["lnUsed"], v_k_110), "pop", []))

func _f5(this_, a: Array, env):
	var v_e_122 = null; var v_e_123 = null
	if (not J.t(env["AC"])):
		var _t5 = J.gp(J.G.get("window"), "AudioContext")
		var _t6 = J.construct((_t5 if J.t(_t5) else J.gp(J.G.get("window"), "webkitAudioContext")), [])
		env["AC"] = _t6
	if J.t((J.seq(J.gp(env["AC"], "state"), "suspended") if J.t(env["AC"]) else env["AC"])):
		J.mc(env["AC"], "resume", [])
	return env["AC"]

func _f6(this_, a: Array, env):
	var v_c_126 = null; var v_d_127 = null; var v_i_128 = null
	v_c_126 = J.arg(a, 0)
	if (not J.t(env["noiseBuf"])):
		var _t7 = J.mc(v_c_126, "createBuffer", [1.0, J.mul(J.gp(v_c_126, "sampleRate"), 2.0), J.gp(v_c_126, "sampleRate")])
		env["noiseBuf"] = _t7
		v_d_127 = J.mc(env["noiseBuf"], "getChannelData", [0.0])
		v_i_128 = 0.0
		while true:
			if not J.cmp(v_i_128, J.len(v_d_127), "<"): break
			var _t8 = ((randf() * 2.0) - 1.0)
			J.sp(v_d_127, v_i_128, _t8)
			v_i_128 = J.num(v_i_128) + 1.0
	return env["noiseBuf"]

func _f7(this_, a: Array, env):
	var v_f_131 = null; var v_t0_132 = null; var v_dur_133 = null; var v_vol_134 = null; var v_type_135 = null; var v_c_136 = null; var v_o_137 = null; var v_g_138 = null; var v_e_139 = null
	v_f_131 = J.arg(a, 0)
	v_t0_132 = J.arg(a, 1)
	v_dur_133 = J.arg(a, 2)
	v_vol_134 = J.arg(a, 3)
	v_type_135 = J.arg(a, 4)
	v_c_136 = J.cl(env["ac"], null, [])
	if (not J.t(v_c_136)):
		return null
	v_o_137 = J.mc(v_c_136, "createOscillator", [])
	v_g_138 = J.mc(v_c_136, "createGain", [])
	var _t9 = (v_type_135 if J.t(v_type_135) else "sine")
	J.sp(v_o_137, "type", _t9)
	var _t10 = J.gp(v_o_137, "frequency")
	J.sp(_t10, "value", v_f_131)
	var _t11 = J.gp(v_g_138, "gain")
	J.mc(_t11, "setValueAtTime", [0.0001, J.add(J.gp(v_c_136, "currentTime"), v_t0_132)])
	var _t12 = J.gp(v_g_138, "gain")
	J.mc(_t12, "exponentialRampToValueAtTime", [v_vol_134, J.add(J.add(J.gp(v_c_136, "currentTime"), v_t0_132), 0.01)])
	var _t13 = J.gp(v_g_138, "gain")
	J.mc(_t13, "exponentialRampToValueAtTime", [0.0001, J.add(J.add(J.gp(v_c_136, "currentTime"), v_t0_132), v_dur_133)])
	J.mc(v_o_137, "connect", [v_g_138])
	J.mc(v_g_138, "connect", [J.gp(v_c_136, "destination")])
	J.mc(v_o_137, "start", [J.add(J.gp(v_c_136, "currentTime"), v_t0_132)])
	J.mc(v_o_137, "stop", [J.add(J.add(J.add(J.gp(v_c_136, "currentTime"), v_t0_132), v_dur_133), 0.05)])

func _f8(this_, a: Array, env):
	var v_t0_142 = null; var v_dur_143 = null; var v_vol_144 = null; var v_freq_145 = null; var v_q_146 = null; var v_c_147 = null; var v_s_148 = null; var v_bp_149 = null; var v_g_150 = null; var v_T_151 = null; var v_e_152 = null
	v_t0_142 = J.arg(a, 0)
	v_dur_143 = J.arg(a, 1)
	v_vol_144 = J.arg(a, 2)
	v_freq_145 = J.arg(a, 3)
	v_q_146 = J.arg(a, 4)
	v_c_147 = J.cl(env["ac"], null, [])
	if (not J.t(v_c_147)):
		return null
	v_s_148 = J.mc(v_c_147, "createBufferSource", [])
	var _t14 = env["nbuf"]
	var _t15 = J.cl(_t14, null, [v_c_147])
	J.sp(v_s_148, "buffer", _t15)
	J.sp(v_s_148, "loop", true)
	v_bp_149 = J.mc(v_c_147, "createBiquadFilter", [])
	J.sp(v_bp_149, "type", "bandpass")
	var _t16 = J.gp(v_bp_149, "frequency")
	var _t17 = (v_freq_145 if J.t(v_freq_145) else 900.0)
	J.sp(_t16, "value", _t17)
	var _t18 = J.gp(v_bp_149, "Q")
	var _t19 = (v_q_146 if J.t(v_q_146) else 0.8)
	J.sp(_t18, "value", _t19)
	v_g_150 = J.mc(v_c_147, "createGain", [])
	v_T_151 = J.add(J.gp(v_c_147, "currentTime"), v_t0_142)
	var _t20 = J.gp(v_g_150, "gain")
	J.mc(_t20, "setValueAtTime", [0.0001, v_T_151])
	var _t21 = J.gp(v_g_150, "gain")
	J.mc(_t21, "linearRampToValueAtTime", [v_vol_144, J.add(v_T_151, J.mul(v_dur_143, 0.3))])
	var _t22 = J.gp(v_g_150, "gain")
	J.mc(_t22, "linearRampToValueAtTime", [0.0001, J.add(v_T_151, v_dur_143)])
	J.mc(v_s_148, "connect", [v_bp_149])
	J.mc(v_bp_149, "connect", [v_g_150])
	J.mc(v_g_150, "connect", [J.gp(v_c_147, "destination")])
	J.mc(v_s_148, "start", [v_T_151])
	J.mc(v_s_148, "stop", [J.add(J.add(v_T_151, v_dur_143), 0.05)])
	return v_g_150

func _f17(this_, a: Array, env):
	return J.gp(env["A"], "G")

func _f18(this_, a: Array, env):
	return J.gp(env["A"], "FL")

func _f19(this_, a: Array, env):
	return J.sub(J.cl(env["FL"], null, []), 1.0)

func _f20(this_, a: Array, env):
	var v_f_186 = null
	v_f_186 = J.arg(a, 0)
	return ("B" if J.seq(v_f_186, 0.0) else ("G" if J.seq(v_f_186, 1.0) else J.F_String([J.sub(v_f_186, 1.0)])))

func _f21(this_, a: Array, env):
	var v_p_189 = null; var v_a_190 = null; var v_b_191 = null; var v_fr_192 = null
	v_p_189 = J.arg(a, 0)
	v_a_190 = floor(J.num(v_p_189))
	v_b_191 = J.min_([J.cl(env["top"], null, []), J.add(v_a_190, 1.0)])
	v_fr_192 = J.sub(v_p_189, v_a_190)
	return J.add(J.mc(env["A"], "fy", [v_a_190]), J.mul(J.sub(J.mc(env["A"], "fy", [v_b_191]), J.mc(env["A"], "fy", [v_a_190])), v_fr_192))

func _f23(this_, a: Array, env):
	var v_q_198 = null
	v_q_198 = J.arg(a, 0)
	return J.seq(J.gp(v_q_198, 2.0), "lift")

func _f22(this_, a: Array, env):
	var v_c_195 = null
	var _t23 = J.gp(J.gp(env["A"], "LV"), "xs")
	var _t24 = (_t23 if J.t(_t23) else [])
	v_c_195 = J.mc(_t24, "find", [Callable(self, "_f23").bind(env)])
	return ({"x0": J.gp(v_c_195, 0.0), "x1": J.gp(v_c_195, 1.0), "cx": J.div(J.add(J.gp(v_c_195, 0.0), J.gp(v_c_195, 1.0)), 2.0)} if J.t(v_c_195) else {"x0": J.sub(J.gp(J.gp(env["A"], "LV"), "MX"), 42.0), "x1": J.add(J.gp(J.gp(env["A"], "LV"), "MX"), 42.0), "cx": J.gp(J.gp(env["A"], "LV"), "MX")})

func _f24(this_, a: Array, env):
	return absf(J.num(J.sub(J.mc(env["A"], "fy", [0.0]), J.mc(env["A"], "fy", [1.0]))))

func _f25(this_, a: Array, env):
	return (J.mc(env["A"], "rnd", []) if J.t(J.gp(env["A"], "rnd")) else randf())

func _f26(this_, a: Array, env):
	var v_a_205 = null
	v_a_205 = J.arg(a, 0)
	return J.gp(v_a_205, floor(J.num(J.mul(J.cl(env["rnd"], null, []), J.len(v_a_205)))))

func _f27(this_, a: Array, env):
	return J.round(J.num(J.gp(env["S"], "pos")))

func _f28(this_, a: Array, env):
	return (absf(J.num(J.sub(J.gp(env["S"], "pos"), J.round(J.num(J.gp(env["S"], "pos")))))) < 0.002)

func _f29(this_, a: Array, env):
	return (J.gp(J.gp(J.cl(env["G"], null, []), "gh"), J.gp(env["S"], "gi")) if J.t(((not J.leq(J.gp(env["S"], "gi"), null)) if J.t(env["S"]) else env["S"])) else null)

func _f30(this_, a: Array, env):
	var v_e_214 = null
	var _t25 = J.gp(J.G.get("window"), "TW")
	var _t26 = (J.gp(J.G.get("TW"), "gpF") if J.t(_t25) else _t25)
	var _t27 = (env["S"] if J.t(_t26) else _t26)
	var _t29 = null
	if J.t(((not J.leq(J.gp(env["S"], "gi"), null)) if J.t(_t27) else _t27)):
		var _t28 = J.mc(J.G.get("TW"), "gpF", [J.gp(env["S"], "gi")])
		_t29 = (_t28 if J.t(_t28) else 1.0)
	else:
		_t29 = 1.0
	return _t29

func _f31(this_, a: Array, env):
	var v_o_217 = null; var v_t_218 = null
	v_o_217 = J.arg(a, 0)
	v_t_218 = J.arg(a, 1)
	J.sp(v_o_217, "say", v_t_218)
	J.sp(v_o_217, "sayT", 2.8)

func _f32(this_, a: Array, env):
	var v_x_221 = null; var v_y_222 = null; var v_t_223 = null; var v_c_224 = null; var v_e_225 = null
	v_x_221 = J.arg(a, 0)
	v_y_222 = J.arg(a, 1)
	v_t_223 = J.arg(a, 2)
	v_c_224 = J.arg(a, 3)
	J.mc(env["A"], "float", [v_x_221, v_y_222, v_t_223, v_c_224])

func _f33(this_, a: Array, env):
	var v_o_228 = null
	v_o_228 = J.arg(a, 0)
	var _t33 = null
	if J.seq(J.gp(v_o_228, "kind"), "guard"):
		var _t30 = J.gp(env["A"], "HUM")
		var _t31 = (J.gp(J.gp(env["A"], "HUM"), J.gp(J.gp(v_o_228, "ref"), "kind")) if J.t(_t30) else _t30)
		var _t32 = (J.gp(J.gp(J.gp(env["A"], "HUM"), J.gp(J.gp(v_o_228, "ref"), "kind")), "spr") if J.t(_t31) else _t31)
		_t33 = (_t32 if J.t(_t32) else "res_guard")
	else:
		_t33 = J.gp(J.gp(v_o_228, "ref"), "sprite")
	return _t33

func _f34(this_, a: Array, env):
	var v_o_231 = null; var v_k_232 = null; var v_F_233 = null
	v_o_231 = J.arg(a, 0)
	var _t34 = env["riderSpr"]
	v_k_232 = J.cl(_t34, null, [v_o_231])
	v_F_233 = J.gp(J.G.get("window"), "PPLFX")
	var _t36 = null
	if J.t(v_F_233):
		var _t35 = J.seq(J.gp(v_o_231, "mood"), "bolt")
		_t36 = J.mc(v_F_233, "key", [v_k_232, (_t35 if _t35 else J.seq(J.gp(v_o_231, "mood"), "cower"))])
	else:
		_t36 = v_k_232
	return _t36

func _f35(this_, a: Array, env):
	var v_o_236 = null; var v_k_237 = null; var v_h_238 = null; var v_F_239 = null
	v_o_236 = J.arg(a, 0)
	v_k_237 = J.arg(a, 1)
	v_h_238 = J.arg(a, 2)
	v_F_239 = J.gp(J.G.get("window"), "PPLFX")
	var _t38 = null
	if J.t(v_F_239):
		var _t37 = env["riderSpr"]
		_t38 = J.mc(v_F_239, "hgt", [J.cl(_t37, null, [v_o_236]), v_k_237, v_h_238])
	else:
		_t38 = v_h_238
	return _t38

func _f37(this_, a: Array, env):
	var v_o_244 = null
	v_o_244 = J.arg(a, 0)
	return J.seq(J.gp(v_o_244, "ph"), "ride")

func _f36(this_, a: Array, env):
	var _t39 = J.gp(env["S"], "riders")
	return J.mc(_t39, "filter", [Callable(self, "_f37").bind(env)])

func _f39(this_, a: Array, env):
	var v_o_249 = null
	v_o_249 = J.arg(a, 0)
	return J.seq(J.gp(v_o_249, "kind"), "res")

func _f38(this_, a: Array, env):
	var _t40 = J.cl(env["inCab"], null, [])
	return J.mc(_t40, "filter", [Callable(self, "_f39").bind(env)])

func _f41(this_, a: Array, env):
	var v_k_254 = null
	v_k_254 = J.arg(a, 0)
	var _t45 = J.gp(env["S"], "cd")
	J.sp(_t45, v_k_254, 0.0)

func _f40(this_, a: Array, env):
	var _t41 = J.cl(env["G"], null, [])
	env["lastG"] = _t41
	var _t42 = {}
	env["lnUsed"] = _t42
	var _t43 = J.gp(env["A"], "LV")
	var _t44 = {"on": (not (not J.t((J.gp(J.gp(env["A"], "LV"), "lift") if J.t(_t43) else _t43)))), "pos": 1.0, "v": 0.0, "dir": 0.0, "st": "idle", "door": 0.0, "hold": 0.0, "target": null, "stops": {}, "lit": {}, "riders": [], "away": [], "mroom": [], "gi": null, "gCall": null, "dfx": {}, "prevSt": "idle", "cd": {}, "fx": {"dark": 0.0, "mirror": 0.0, "over": 0.0, "flick": 0.0, "btnAll": 0.0}, "stuckT": 0.0, "stuckTo": null, "spawnT": 6.0, "gSpawnT": 14.0, "t": 0.0, "log": [], "shake": 0.0, "ext": null}
	env["S"] = _t44
	J.mc(env["TRK"], "forEach", [Callable(self, "_f41").bind(env)])
	J.cl(env["hideUI"], null, [])

func _f43(this_, a: Array, env):
	var v_o_262 = null
	v_o_262 = J.arg(a, 0)
	if J.seq(J.gp(v_o_262, "ph"), "ride"):
		var _t49 = env["w"]
		var _t50 = J.gp(v_o_262, "dest")
		J.sp(_t49, _t50, 1.0)
	var _t51 = J.seq(J.gp(v_o_262, "ph"), "wait")
	if (J.cmp(env["room"], 0.0, ">") if _t51 else _t51):
		var _t52 = env["w"]
		var _t53 = J.gp(v_o_262, "f")
		J.sp(_t52, _t53, 1.0)

func _f42(this_, a: Array, env):
	var v_k_258 = null
	var _s74 = {"__p": env, "w": null, "room": null}
	_s74["w"] = {}
	for _t46 in J.keys(J.gp(_s74["__p"]["S"], "stops")):
		v_k_258 = _t46
		var _t47 = _s74["w"]
		J.sp(_t47, v_k_258, 1.0)
	_s74["room"] = J.sub(_s74["__p"]["CAP"], J.len(J.cl(_s74["__p"]["inCab"], null, [])))
	var _t48 = J.gp(_s74["__p"]["S"], "riders")
	J.mc(_t48, "forEach", [Callable(self, "_f43").bind(_s74)])
	if (not J.leq(J.gp(_s74["__p"]["S"], "gCall"), null)):
		var _t54 = _s74["w"]
		var _t55 = J.gp(_s74["__p"]["S"], "gCall")
		J.sp(_t54, _t55, 1.0)
	return _s74["w"]

func _f45(this_, a: Array, env):
	var v_f_273 = null
	v_f_273 = J.arg(a, 0)
	var _t58 = J.cmp(v_f_273, 0.0, ">=")
	return (J.cmp(v_f_273, J.cl(env["__p"]["top"], null, []), "<=") if _t58 else _t58)

func _f46(this_, a: Array, env):
	var v_f_276 = null
	v_f_276 = J.arg(a, 0)
	var _t59 = (absf(J.num(J.sub(v_f_276, env["p"]))) > 0.01)
	return (_t59 if _t59 else J.seq(J.gp(env["__p"]["S"], "st"), "idle"))

func _f47(this_, a: Array, env):
	var v_f_279 = null
	v_f_279 = J.arg(a, 0)
	return J.cmp(v_f_279, J.add(env["p"], 0.01), ">")

func _f48(this_, a: Array, env):
	var v_a_282 = null; var v_b_283 = null
	v_a_282 = J.arg(a, 0)
	v_b_283 = J.arg(a, 1)
	return J.sub(v_a_282, v_b_283)

func _f49(this_, a: Array, env):
	var v_f_286 = null
	v_f_286 = J.arg(a, 0)
	return J.cmp(v_f_286, J.sub(env["p"], 0.01), "<")

func _f50(this_, a: Array, env):
	var v_a_289 = null; var v_b_290 = null
	v_a_289 = J.arg(a, 0)
	v_b_290 = J.arg(a, 1)
	return J.sub(v_b_290, v_a_289)

func _f51(this_, a: Array, env):
	var v_f_293 = null
	v_f_293 = J.arg(a, 0)
	return (absf(J.num(J.sub(v_f_293, env["p"]))) <= 0.01)

func _f44(this_, a: Array, env):
	var v_w_265 = null; var v_keys_266 = null; var v_up_268 = null; var v_dn_269 = null; var v_here_270 = null
	var _s77 = {"__p": env, "p": null}
	v_w_265 = J.cl(_s77["__p"]["wanted"], null, [])
	var _t56 = J.S_Object_("keys", [v_w_265])
	var _t57 = J.mc(_t56, "map", [J.G.get("Number")])
	v_keys_266 = J.mc(_t57, "filter", [Callable(self, "_f45").bind(_s77)])
	_s77["p"] = J.gp(_s77["__p"]["S"], "pos")
	var _t60 = J.mc(v_keys_266, "filter", [Callable(self, "_f46").bind(_s77)])
	v_keys_266 = _t60
	if (not J.t(J.len(v_keys_266))):
		return null
	var _t61 = J.mc(v_keys_266, "filter", [Callable(self, "_f47").bind(_s77)])
	v_up_268 = J.mc(_t61, "sort", [Callable(self, "_f48").bind(_s77)])
	var _t62 = J.mc(v_keys_266, "filter", [Callable(self, "_f49").bind(_s77)])
	v_dn_269 = J.mc(_t62, "sort", [Callable(self, "_f50").bind(_s77)])
	v_here_270 = J.mc(v_keys_266, "filter", [Callable(self, "_f51").bind(_s77)])
	var _t63 = J.len(v_here_270)
	if J.t((J.seq(J.gp(_s77["__p"]["S"], "st"), "idle") if J.t(_t63) else _t63)):
		return J.gp(v_here_270, 0.0)
	var _t64 = J.cmp(J.gp(_s77["__p"]["S"], "dir"), 0.0, ">=")
	if J.t((J.len(v_up_268) if _t64 else _t64)):
		return J.gp(v_up_268, 0.0)
	var _t65 = J.cmp(J.gp(_s77["__p"]["S"], "dir"), 0.0, "<=")
	if J.t((J.len(v_dn_269) if _t65 else _t65)):
		return J.gp(v_dn_269, 0.0)
	return (J.gp(v_up_268, 0.0) if J.t(J.len(v_up_268)) else (J.gp(v_dn_269, 0.0) if J.t(J.len(v_dn_269)) else null))

func _f52(this_, a: Array, env):
	var v_t_296 = null
	v_t_296 = J.arg(a, 0)
	var _t66 = env["S"]
	J.sp(_t66, "target", v_t_296)
	var _t67 = env["S"]
	var _t68 = (1.0 if J.cmp(v_t_296, J.gp(env["S"], "pos"), ">") else (-1.0))
	J.sp(_t67, "dir", _t68)
	var _t69 = env["S"]
	J.sp(_t69, "st", "move")
	J.mc(env["SND"], "hum", [true])

func _f54(this_, a: Array, env):
	var v_o_306 = null
	v_o_306 = J.arg(a, 0)
	var _t77 = J.seq(J.gp(v_o_306, "ph"), "wait")
	return (J.seq(J.gp(v_o_306, "f"), env["f"]) if _t77 else _t77)

func _f53(this_, a: Array, env):
	var v_c_300 = null; var v_y_301 = null; var v_g_302 = null; var v_hasPeople_303 = null; var v_e_307 = null
	var _s86 = {"__p": env, "f": null}
	_s86["f"] = J.cl(_s86["__p"]["cabF"], null, [])
	var _t70 = _s86["__p"]["S"]
	var _t71 = _s86["f"]
	J.sp(_t70, "pos", _t71)
	var _t72 = _s86["__p"]["S"]
	J.sp(_t72, "v", 0.0)
	J.del(J.gp(_s86["__p"]["S"], "stops"), _s86["f"])
	J.del(J.gp(_s86["__p"]["S"], "lit"), _s86["f"])
	if J.seq(J.gp(_s86["__p"]["S"], "gCall"), _s86["f"]):
		var _t73 = _s86["__p"]["S"]
		J.sp(_t73, "gCall", null)
	var _t74 = _s86["__p"]["S"]
	J.sp(_t74, "st", "opening")
	J.mc(_s86["__p"]["SND"], "ding", [])
	J.mc(_s86["__p"]["SND"], "door", [])
	var _t75 = _s86["__p"]["S"]
	J.sp(_t75, "target", null)
	v_c_300 = J.cl(_s86["__p"]["col"], null, [])
	v_y_301 = J.mc(_s86["__p"]["A"], "fy", [_s86["f"]])
	v_g_302 = J.cl(_s86["__p"]["ghost"], null, [])
	var _t78 = J.len(J.cl(_s86["__p"]["inCab"], null, []))
	if not J.t(_t78):
		var _t76 = J.gp(_s86["__p"]["S"], "riders")
		_t78 = J.mc(_t76, "some", [Callable(self, "_f54").bind(_s86)])
	v_hasPeople_303 = _t78
	var _t79 = (not J.t(v_g_302))
	if ((not J.t(v_hasPeople_303)) if _t79 else _t79):
		J.mc(_s86["__p"]["A"], "noise", [(J.add("f", _s86["f"]) + "_l"), 2.0])
		var _t80 = _s86["__p"]["fl"]
		var _t82 = J.gp(v_c_300, "cx")
		var _t83 = J.sub(v_y_301, 90.0)
		var _t81 = _s86["__p"]["lab"]
		J.cl(_t80, null, [_t82, _t83, (J.add("叮——（", J.cl(_t81, null, [_s86["f"]])) + " 樓𨋢門自己開咗）"), "#ffd54a"])

func _f56(this_, a: Array, env):
	var v_o_317 = null
	v_o_317 = J.arg(a, 0)
	var _t89 = J.seq(J.gp(v_o_317, "dest"), env["f"])
	var _t90 = (_t89 if _t89 else J.seq(J.gp(v_o_317, "mood"), "bolt"))
	return (_t90 if _t90 else J.seq(J.gp(v_o_317, "mood"), "mroom"))

func _f57(this_, a: Array, env):
	var v_o_320 = null
	v_o_320 = J.arg(a, 0)
	var _t96 = J.seq(J.gp(v_o_320, "ph"), "wait")
	return (J.seq(J.gp(v_o_320, "f"), env["f"]) if _t96 else _t96)

func _f55(this_, a: Array, env):
	var v_dt_310 = null; var v_c_312 = null; var v_out_313 = null; var v_w_314 = null
	var _s92 = {"__p": env, "f": null}
	v_dt_310 = J.arg(a, 0)
	_s92["f"] = J.cl(_s92["__p"]["cabF"], null, [])
	v_c_312 = J.cl(_s92["__p"]["col"], null, [])
	var _t84 = _s92["__p"]["S"]
	var _t85 = J.gp(_s92["__p"]["S"], "xT")
	var _t86 = J.sub((_t85 if J.t(_t85) else 0.0), v_dt_310)
	J.sp(_t84, "xT", _t86)
	if J.cmp(J.gp(_s92["__p"]["S"], "xT"), 0.0, ">"):
		return null
	var _t87 = _s92["__p"]["S"]
	J.sp(_t87, "xT", 0.35)
	var _t88 = J.cl(_s92["__p"]["inCab"], null, [])
	v_out_313 = J.mc(_t88, "find", [Callable(self, "_f56").bind(_s92)])
	if J.t(v_out_313):
		var _t91 = _s92["__p"]["exitRider"]
		J.cl(_t91, null, [v_out_313, _s92["f"]])
		var _t92 = _s92["__p"]["dingFx"]
		J.cl(_t92, null, [_s92["f"], true])
		var _t93 = _s92["__p"]["S"]
		var _t94 = J.max_([J.gp(_s92["__p"]["S"], "hold"), 1.0])
		J.sp(_t93, "hold", _t94)
		return null
	var _t95 = J.gp(_s92["__p"]["S"], "riders")
	v_w_314 = J.mc(_t95, "find", [Callable(self, "_f57").bind(_s92)])
	if J.t(v_w_314):
		if J.cmp(J.len(J.cl(_s92["__p"]["inCab"], null, [])), _s92["__p"]["CAP"], ">="):
			if (not J.t(J.gp(v_w_314, "fullSaid"))):
				J.sp(v_w_314, "fullSaid", 1.0)
				var _t97 = _s92["__p"]["sayR"]
				var _t98 = _s92["__p"]["line"]
				J.cl(_t97, null, [v_w_314, J.cl(_t98, null, ["full"])])
			return null
		J.sp(v_w_314, "ph", "ride")
		var _t99 = _s92["__p"]["dingFx"]
		J.cl(_t99, null, [_s92["f"], true])
		var _t100 = J.add(J.gp(v_c_312, "cx"), ((J.len(J.cl(_s92["__p"]["inCab"], null, [])) - 1.5) * 10.0))
		J.sp(v_w_314, "x", _t100)
		var _t101 = _s92["__p"]["sayR"]
		var _t104 = null
		if J.cmp(J.cl(_s92["__p"]["rnd"], null, []), 0.5, "<"):
			var _t102 = _s92["__p"]["line"]
			_t104 = J.cl(_t102, null, ["board"])
		else:
			var _t103 = _s92["__p"]["lab"]
			_t104 = J.add(J.cl(_t103, null, [J.gp(v_w_314, "dest")]), "樓，唔該")
		J.cl(_t101, null, [v_w_314, _t104])
		var _t105 = _s92["__p"]["S"]
		var _t106 = J.max_([J.gp(_s92["__p"]["S"], "hold"), 1.2])
		J.sp(_t105, "hold", _t106)

func _f58(this_, a: Array, env):
	var v_o_323 = null; var v_f_324 = null; var v_c_325 = null; var v_y_326 = null; var v_g0_327 = null; var v_h_328 = null; var v_r_329 = null
	v_o_323 = J.arg(a, 0)
	v_f_324 = J.arg(a, 1)
	v_c_325 = J.cl(env["col"], null, [])
	v_y_326 = J.mc(env["A"], "fy", [v_f_324])
	v_g0_327 = J.cl(env["G"], null, [])
	var _t107 = J.gp(env["S"], "riders")
	var _t108 = J.gp(env["S"], "riders")
	J.mc(_t107, "splice", [J.mc(_t108, "indexOf", [v_o_323]), 1.0])
	if J.seq(J.gp(v_o_323, "kind"), "guard"):
		v_h_328 = J.gp(v_o_323, "ref")
		J.sp(v_h_328, "to", null)
		J.sp(v_h_328, "path", null)
		J.sp(v_h_328, "p", 0.0)
		var _t109 = (J.add("f", v_f_324) + "_l")
		J.sp(v_h_328, "node", _t109)
		var _t110 = J.gp(v_c_325, "cx")
		J.sp(v_h_328, "x", _t110)
		J.sp(v_h_328, "y", v_y_326)
		J.sp(v_h_328, "wait", 0.8)
		if J.seq(J.gp(v_o_323, "mood"), "mroom"):
			var _t111 = J.gp(env["S"], "mroom")
			J.mc(_t111, "push", [{"h": v_h_328, "t": 22.0}])
			var _t112 = env["fl"]
			J.cl(_t112, null, [J.gp(v_c_325, "cx"), J.sub(v_y_326, 110.0), "保安去咗機房（離開巡邏 22 秒）", "#9fd6bf"])
			var _t113 = env["log"]
			J.cl(_t113, null, ["mroom"])
			return null
		J.sp(v_h_328, "state", "patrol")
		var _t114 = J.gp(v_g0_327, "guards")
		J.mc(_t114, "push", [v_h_328])
		return null
	v_r_329 = J.gp(v_o_323, "ref")
	var _t115 = J.sub(v_y_326, 16.0)
	J.sp(v_r_329, "y", _t115)
	if J.seq(J.gp(v_o_323, "mood"), "bolt"):
		J.sp(v_r_329, "state", "flee")
		var _t116 = (((-1.0) if J.cmp(J.cl(env["rnd"], null, []), 0.5, "<") else 1.0) * 150.0)
		J.sp(v_r_329, "vx", _t116)
		var _t117 = J.gp(v_c_325, "cx")
		J.sp(v_r_329, "x", _t117)
		var _t118 = J.gp(v_g0_327, "res")
		J.mc(_t118, "push", [v_r_329])
		if J.t(J.gp(J.G.get("window"), "PPLFX")):
			J.mc(J.G.get("PPLFX"), "screamOn", [v_r_329])
		else:
			var _t119 = env["sayR"]
			var _t120 = env["line"]
			J.cl(_t119, null, [v_r_329, J.cl(_t120, null, ["bolt"])])
		J.sp(v_r_329, "sayT", 2.4)
		var _t121 = env["log"]
		J.cl(_t121, null, ["bolt"])
		return null
	if J.seq(J.gp(v_o_323, "trip"), "back"):
		J.sp(v_o_323, "ph", "walkHome")
		J.sp(v_o_323, "f", v_f_324)
		var _t122 = J.gp(v_c_325, "cx")
		J.sp(v_o_323, "x", _t122)
		var _t123 = J.gp(env["S"], "riders")
		J.mc(_t123, "push", [v_o_323])
		return null
	if J.seq(J.gp(v_o_323, "trip"), "snack"):
		var _t124 = J.gp(env["S"], "away")
		J.mc(_t124, "push", [{"o": v_o_323, "t": (16.0 + J.mul(J.cl(env["rnd"], null, []), 12.0))}])

func _f60(this_, a: Array, env):
	var v_r_338 = null
	v_r_338 = J.arg(a, 0)
	var _t128 = J.seq(J.gp(v_r_338, "state"), "home")
	var _t129 = ((not J.seq(J.gp(v_r_338, "awake"), false)) if _t128 else _t128)
	var _t130 = ((not J.cmp(J.gp(v_r_338, "fear"), 40.0, ">")) if _t129 else _t129)
	var _t131 = (J.gp(v_r_338, "unit") if _t130 else _t130)
	var _t132 = (J.cmp(J.gp(J.gp(v_r_338, "unit"), "f"), 2.0, ">=") if J.t(_t131) else _t131)
	var _t133 = (J.cmp(J.gp(J.gp(v_r_338, "unit"), "f"), J.cl(env["top"], null, []), "<=") if J.t(_t132) else _t132)
	var _t134 = ((not J.t(J.gp(v_r_338, "liftUsed"))) if J.t(_t133) else _t133)
	return ((not J.seq(J.gp(J.gp(v_r_338, "unit"), "ot"), "deity")) if J.t(_t134) else _t134)

func _f59(this_, a: Array, env):
	var v_g0_332 = null; var v_ph_333 = null; var v_cand_334 = null; var v_r_335 = null
	v_g0_332 = J.cl(env["G"], null, [])
	var _t125 = J.gp(v_g0_332, "phase")
	var _t126 = J.gp(v_g0_332, "phase")
	v_ph_333 = J.min_([2.0, (_t126 if J.t(_t126) else 0.0)])
	var _t127 = J.gp(v_g0_332, "res")
	v_cand_334 = J.mc(_t127, "filter", [Callable(self, "_f60").bind(env)])
	if (not J.t(J.len(v_cand_334))):
		return null
	var _t135 = env["pick"]
	v_r_335 = J.cl(_t135, null, [v_cand_334])
	var _t136 = env["addResRider"]
	return J.cl(_t136, null, [v_r_335, "snack"])

func _f61(this_, a: Array, env):
	var v_r_341 = null; var v_trip_342 = null; var v_dest_343 = null; var v_g0_344 = null; var v_i_345 = null; var v_o_346 = null
	v_r_341 = J.arg(a, 0)
	v_trip_342 = J.arg(a, 1)
	v_dest_343 = J.arg(a, 2)
	v_g0_344 = J.cl(env["G"], null, [])
	var _t137 = J.gp(v_g0_344, "res")
	v_i_345 = J.mc(_t137, "indexOf", [v_r_341])
	if J.cmp(v_i_345, 0.0, ">="):
		var _t138 = J.gp(v_g0_344, "res")
		J.mc(_t138, "splice", [v_i_345, 1.0])
	J.sp(v_r_341, "state", "lift")
	J.sp(v_r_341, "liftUsed", 1.0)
	v_o_346 = {"kind": "res", "ref": v_r_341, "f": J.gp(J.gp(v_r_341, "unit"), "f"), "dest": (v_dest_343 if (not J.leq(v_dest_343, null)) else 1.0), "ph": "walk", "x": J.gp(v_r_341, "x"), "trip": (v_trip_342 if J.t(v_trip_342) else "snack"), "fear": 0.0, "mood": "ok", "say": null, "sayT": 0.0}
	var _t139 = env["sayR"]
	var _t140 = env["line"]
	J.cl(_t139, null, [v_o_346, J.cl(_t140, null, [("work" if J.seq(J.gp(v_o_346, "trip"), "work") else "snack")])])
	var _t141 = J.gp(env["S"], "riders")
	J.mc(_t141, "push", [v_o_346])
	return v_o_346

func _f63(this_, a: Array, env):
	var v_h_355 = null; var v_n_356 = null
	v_h_355 = J.arg(a, 0)
	v_n_356 = J.gp(J.gp(env["g0"], "nodes"), J.gp(v_h_355, "node"))
	var _t143 = J.seq(J.gp(v_h_355, "kind"), "guard")
	var _t144 = (J.seq(J.gp(v_h_355, "state"), "patrol") if _t143 else _t143)
	var _t145 = (v_n_356 if _t144 else _t144)
	var _t146 = (J.cmp(J.gp(v_n_356, "f"), J.cl(env["__p"]["top"], null, []), "<=") if J.t(_t145) else _t145)
	var _t147 = ((absf(J.num(J.sub(J.gp(v_h_355, "x"), J.gp(env["c"], "cx")))) < 240.0) if J.t(_t146) else _t146)
	return ((not J.t(J.gp(v_h_355, "liftCd"))) if J.t(_t147) else _t147)

func _f62(this_, a: Array, env):
	var v_cand_351 = null; var v_h_352 = null
	var _s107 = {"__p": env, "g0": null, "c": null}
	_s107["g0"] = J.cl(_s107["__p"]["G"], null, [])
	_s107["c"] = J.cl(_s107["__p"]["col"], null, [])
	var _t142 = J.gp(_s107["g0"], "guards")
	v_cand_351 = J.mc(_t142, "filter", [Callable(self, "_f63").bind(_s107)])
	if (not J.t(J.len(v_cand_351))):
		return null
	var _t148 = _s107["__p"]["pick"]
	v_h_352 = J.cl(_t148, null, [v_cand_351])
	var _t149 = _s107["__p"]["addGuardRider"]
	return J.cl(_t149, null, [v_h_352])

func _f64(this_, a: Array, env):
	var v_h_359 = null; var v_dest_360 = null; var v_g0_361 = null; var v_n_362 = null; var v_i_363 = null; var v_f_364 = null; var v_d_365 = null; var v_o_366 = null
	v_h_359 = J.arg(a, 0)
	v_dest_360 = J.arg(a, 1)
	v_g0_361 = J.cl(env["G"], null, [])
	v_n_362 = J.gp(J.gp(v_g0_361, "nodes"), J.gp(v_h_359, "node"))
	var _t150 = J.gp(v_g0_361, "guards")
	v_i_363 = J.mc(_t150, "indexOf", [v_h_359])
	if J.cmp(v_i_363, 0.0, ">="):
		var _t151 = J.gp(v_g0_361, "guards")
		J.mc(_t151, "splice", [v_i_363, 1.0])
	v_f_364 = (J.gp(v_n_362, "f") if J.t(v_n_362) else 1.0)
	v_d_365 = v_dest_360
	if J.leq(v_d_365, null):
		var _t152 = true
		while true:
			if not _t152:
				var _t153 = J.seq(v_d_365, v_f_364)
				if not (J.cmp(J.cl(env["top"], null, []), 0.0, ">") if _t153 else _t153): break
			_t152 = false
			var _t154 = floor(J.num(J.mul(J.cl(env["rnd"], null, []), J.add(J.cl(env["top"], null, []), 1.0))))
			v_d_365 = _t154
	v_o_366 = {"kind": "guard", "ref": v_h_359, "f": v_f_364, "dest": v_d_365, "ph": "walk", "x": J.gp(v_h_359, "x"), "trip": "patrol", "mood": "ok", "say": null, "sayT": 0.0}
	var _t155 = env["sayR"]
	var _t156 = env["line"]
	J.cl(_t155, null, [v_o_366, J.cl(_t156, null, ["gRide"])])
	var _t157 = J.gp(env["S"], "riders")
	J.mc(_t157, "push", [v_o_366])
	return v_o_366

func _f67(this_, a: Array, env):
	var v_g_378 = null; var v_f_379 = null
	v_g_378 = J.arg(a, 0)
	v_f_379 = J.arg(a, 1)
	var _t158 = env["S"]
	var _t159 = J.gp(v_g_378, "i")
	J.sp(_t158, "gi", _t159)
	var _t160 = env["S"]
	J.sp(_t160, "gCall", null)
	var _t161 = env["S"]
	J.sp(_t161, "gWait", null)
	J.sp(v_g_378, "to", null)
	J.sp(v_g_378, "auto", null)
	J.sp(v_g_378, "autoS", null)
	if J.seq(J.gp(env["S"], "st"), "idle"):
		var _t162 = env["S"]
		J.sp(_t162, "st", "opening")
		J.mc(env["SND"], "ding", [])
		J.mc(env["SND"], "door", [])
	var _t163 = env["S"]
	var _t164 = J.max_([J.gp(env["S"], "hold"), 3.5])
	J.sp(_t163, "hold", _t164)
	var _t165 = env["dingFx"]
	J.cl(_t165, null, [v_f_379])
	var _t166 = env["log"]
	J.cl(_t166, null, ["enter"])
	J.cl(env["showUI"], null, [])
	if J.t(J.gp(env["A"], "toast")):
		J.mc(env["A"], "toast", ["入咗𨋢：揀樓層、撳開關門。有人一齊搭嘅時候，上面會出「𨋢內嚇人」。"])

func _f77(this_, a: Array, env):
	var v_o_423 = null
	v_o_423 = J.arg(a, 0)
	var _t168 = J.seq(J.gp(v_o_423, "ph"), "wait")
	return (J.seq(J.gp(v_o_423, "f"), env["f"]) if _t168 else _t168)

func _f78(this_, a: Array, env):
	var v_o_426 = null; var v_h_427 = null; var v_r_428 = null; var v_e_429 = null
	v_o_426 = J.arg(a, 0)
	var _t170 = J.gp(env["__p"]["S"], "riders")
	var _t171 = J.gp(env["__p"]["S"], "riders")
	J.mc(_t170, "splice", [J.mc(_t171, "indexOf", [v_o_426]), 1.0])
	if J.seq(J.gp(v_o_426, "kind"), "guard"):
		v_h_427 = J.gp(v_o_426, "ref")
		var _t172 = (J.add("f", env["f"]) + "_l")
		J.sp(v_h_427, "node", _t172)
		J.sp(v_h_427, "to", null)
		J.sp(v_h_427, "p", 0.0)
		var _t173 = J.sub(J.gp(env["c"], "cx"), 30.0)
		J.sp(v_h_427, "x", _t173)
		var _t174 = env["y"]
		J.sp(v_h_427, "y", _t174)
		J.sp(v_h_427, "state", "patrol")
		var _t175 = J.gp(env["g0"], "guards")
		J.mc(_t175, "push", [v_h_427])
		var _t176 = env["__p"]["line"]
		J.mc(env["__p"]["A"], "spook", [v_h_427, J.cl(_t176, null, ["gLand"])])
		return null
	v_r_428 = J.gp(v_o_426, "ref")
	J.sp(v_r_428, "state", "flee")
	var _t177 = (((-1.0) if J.cmp(J.gp(v_o_426, "x"), J.gp(env["c"], "cx"), "<") else 1.0) * 160.0)
	J.sp(v_r_428, "vx", _t177)
	var _t178 = J.gp(v_o_426, "x")
	J.sp(v_r_428, "x", _t178)
	var _t179 = J.sub(env["y"], 16.0)
	J.sp(v_r_428, "y", _t179)
	var _t180 = J.gp(env["g0"], "res")
	J.mc(_t180, "push", [v_r_428])
	var _t181 = env["__p"]["sayR"]
	var _t182 = env["__p"]["line"]
	J.cl(_t181, null, [v_r_428, J.cl(_t182, null, ["land"])])
	J.sp(v_r_428, "sayT", 2.4)

func _f76(this_, a: Array, env):
	var _s149 = {"__p": env, "f": null, "c": null, "y": null, "g0": null}
	_s149["f"] = J.cl(_s149["__p"]["cabF"], null, [])
	_s149["c"] = J.cl(_s149["__p"]["col"], null, [])
	_s149["y"] = J.mc(_s149["__p"]["A"], "fy", [_s149["f"]])
	_s149["g0"] = J.cl(_s149["__p"]["G"], null, [])
	var _t167 = J.gp(_s149["__p"]["S"], "riders")
	var _t169 = J.mc(_t167, "filter", [Callable(self, "_f77").bind(_s149)])
	J.mc(_t169, "forEach", [Callable(self, "_f78").bind(_s149)])

func _f79(this_, a: Array, env):
	var v_f_432 = null; var v_quiet_433 = null; var v_d_434 = null; var v_e_435 = null
	v_f_432 = J.arg(a, 0)
	v_quiet_433 = J.arg(a, 1)
	if (not J.t(env["S"])):
		return null
	v_d_434 = J.gp(J.gp(env["S"], "dfx"), v_f_432)
	if J.t((J.cmp(J.gp(v_d_434, "t"), 0.8, "<") if J.t(v_d_434) else v_d_434)):
		return null
	var _t183 = J.gp(env["S"], "dfx")
	var _t184 = {"t": 0.0}
	J.sp(_t183, v_f_432, _t184)
	if (not J.t(v_quiet_433)):
		J.mc(env["SND"], "ding", [])

func _f83(this_, a: Array, env):
	var v_m_457 = null; var v_g_458 = null
	v_m_457 = J.arg(a, 0)
	var _t185 = env["S"]
	J.sp(_t185, "msg", v_m_457)
	var _t186 = env["S"]
	J.sp(_t186, "msgT", 1.6)
	v_g_458 = J.cl(env["ghost"], null, [])
	if J.t(v_g_458):
		var _t187 = env["fl"]
		J.cl(_t187, null, [J.gp(v_g_458, "x"), J.sub(J.gp(v_g_458, "y"), 120.0), v_m_457, "#ffd54a"])

func _f84(this_, a: Array, env):
	var v_e_461 = null
	v_e_461 = J.arg(a, 0)
	var _t188 = J.gp(env["S"], "log")
	J.mc(_t188, "push", [v_e_461])
	if (J.len(J.gp(env["S"], "log")) > 80.0):
		J.mc(J.gp(env["S"], "log"), "shift", [])

func _f92(this_, a: Array, env):
	var v_k_516 = null; var v_im_517 = null
	v_k_516 = J.arg(a, 0)
	var _t189 = J.gp(env["A"], "IMG")
	v_im_517 = (J.gp(J.gp(env["A"], "IMG"), v_k_516) if J.t(_t189) else _t189)
	return (v_im_517 if J.t((J.gp(v_im_517, "width") if J.t(v_im_517) else v_im_517)) else null)

func _f93(this_, a: Array, env):
	var v_c2_520 = null; var v_k_521 = null; var v_x_522 = null; var v_y_523 = null; var v_h_524 = null; var v_alpha_525 = null; var v_flip_526 = null; var v_sy_527 = null; var v_im_528 = null; var v_w_529 = null
	v_c2_520 = J.arg(a, 0)
	v_k_521 = J.arg(a, 1)
	v_x_522 = J.arg(a, 2)
	v_y_523 = J.arg(a, 3)
	v_h_524 = J.arg(a, 4)
	v_alpha_525 = J.arg(a, 5)
	v_flip_526 = J.arg(a, 6)
	v_sy_527 = J.arg(a, 7)
	var _t190 = env["img"]
	v_im_528 = J.cl(_t190, null, [v_k_521])
	if (not J.t(v_im_528)):
		var _t191 = (J.add("rgba(30,30,36,", (1.0 if J.leq(v_alpha_525, null) else v_alpha_525)) + ")")
		J.sp(v_c2_520, "fillStyle", _t191)
		J.mc(v_c2_520, "fillRect", [J.sub(v_x_522, J.mul(v_h_524, 0.18)), J.sub(v_y_523, v_h_524), J.mul(v_h_524, 0.36), v_h_524])
		return null
	v_w_529 = J.div(J.mul(v_h_524, J.gp(v_im_528, "width")), J.gp(v_im_528, "height"))
	J.mc(v_c2_520, "save", [])
	var _t192 = (1.0 if J.leq(v_alpha_525, null) else v_alpha_525)
	J.sp(v_c2_520, "globalAlpha", _t192)
	J.mc(v_c2_520, "translate", [v_x_522, v_y_523])
	if J.t(v_flip_526):
		J.mc(v_c2_520, "scale", [(-1.0), 1.0])
	if J.t(v_sy_527):
		J.mc(v_c2_520, "scale", [1.0, v_sy_527])
	J.mc(v_c2_520, "drawImage", [v_im_528, J.div((-J.num(v_w_529)), 2.0), (-J.num(v_h_524)), v_w_529, v_h_524])
	J.mc(v_c2_520, "restore", [])

func _f94(this_, a: Array, env):
	var v_c2_532 = null; var v_x_533 = null; var v_y_534 = null; var v_t_535 = null; var v_sc_536 = null; var v_w_537 = null; var v_h_538 = null
	v_c2_532 = J.arg(a, 0)
	v_x_533 = J.arg(a, 1)
	v_y_534 = J.arg(a, 2)
	v_t_535 = J.arg(a, 3)
	v_sc_536 = J.arg(a, 4)
	J.mc(v_c2_532, "save", [])
	var _t193 = J.add((J.add("bold ", J.round(J.num(J.div(12.0, v_sc_536)))) + "px "), J.gp(env["A"], "FONT"))
	J.sp(v_c2_532, "font", _t193)
	v_w_537 = J.min_([J.div(220.0, v_sc_536), J.add(J.gp(J.mc(v_c2_532, "measureText", [v_t_535]), "width"), J.div(14.0, v_sc_536))])
	v_h_538 = J.div(22.0, v_sc_536)
	J.sp(v_c2_532, "fillStyle", "rgba(255,250,240,0.95)")
	J.sp(v_c2_532, "strokeStyle", "#1a1a1e")
	var _t194 = J.div(1.5, v_sc_536)
	J.sp(v_c2_532, "lineWidth", _t194)
	J.mc(v_c2_532, "beginPath", [])
	J.mc(v_c2_532, "rect", [J.sub(v_x_533, J.div(v_w_537, 2.0)), J.sub(v_y_534, v_h_538), v_w_537, v_h_538])
	J.mc(v_c2_532, "fill", [])
	J.mc(v_c2_532, "stroke", [])
	J.sp(v_c2_532, "fillStyle", "#1a1a1e")
	J.sp(v_c2_532, "textAlign", "center")
	J.mc(v_c2_532, "fillText", [v_t_535, v_x_533, J.sub(v_y_534, J.mul(v_h_538, 0.3)), J.sub(v_w_537, J.div(6.0, v_sc_536))])
	J.mc(v_c2_532, "restore", [])

func _f96(this_, a: Array, env):
	var v_b_577 = null
	v_b_577 = J.arg(a, 0)
	var _t219 = J.cmp(J.gp(v_b_577, "y"), J.sub(J.gp(env["__p"]["A"], "VH"), J.gp(env["__p"]["A"], "BOT")), "<")
	if (J.cmp(J.add(J.gp(v_b_577, "y"), J.gp(v_b_577, "h")), J.gp(env["__p"]["A"], "TOP"), ">") if _t219 else _t219):
		J.mc(env["__p"]["wx"], "rect", [J.add(J.add(J.gp(v_b_577, "x"), J.gp(v_b_577, "w")), 2.0), J.sub(J.gp(v_b_577, "y"), 2.0), (-J.num(J.add(J.gp(v_b_577, "w"), 4.0))), J.add(J.gp(v_b_577, "h"), 4.0)])

func _f97(this_, a: Array, env):
	var v_o_581 = null; var v_px_582 = null
	v_o_581 = J.arg(a, 0)
	v_px_582 = (J.sub(J.gp(env["c"], "cx"), J.div(env["cw"], 2.0)) + J.mul(env["cw"], (0.5 if J.seq(env["n"], 1.0) else (0.18 + J.div(J.mul(0.64, env["k"]), J.max_([1.0, J.sub(env["n"], 1.0)]))))))
	env["k"] = J.num(env["k"]) + 1.0
	var _t226 = env["__p"]["sprAt"]
	var _t228 = env["__p"]["wx"]
	var _t227 = env["__p"]["riderSpr"]
	J.cl(_t226, null, [_t228, J.cl(_t227, null, [v_o_581]), v_px_582, J.sub(env["cy"], 1.0), (J.mul(env["ch"], 0.82) * (0.7 if J.seq(J.gp(v_o_581, "mood"), "cower") else 1.0)), 1.0, J.seq(J.mod(env["k"], 2.0), 0.0), null])

func _f98(this_, a: Array, env):
	var v_o_585 = null
	v_o_585 = J.arg(a, 0)
	var _t256 = J.seq(J.gp(v_o_585, "ph"), "wait")
	return (J.seq(J.gp(v_o_585, "f"), env["f"]) if _t256 else _t256)

func _f99(this_, a: Array, env):
	var v_q_588 = null; var v_qi_589 = null; var v_nq_590 = null; var v_al_591 = null
	v_q_588 = J.arg(a, 0)
	v_qi_589 = J.arg(a, 1)
	var _t269 = J.gp(v_q_588, "home")
	var _t270 = (_t269 if J.t(_t269) else J.gp(v_q_588, "out"))
	if J.t((_t270 if J.t(_t270) else J.seq(v_qi_589, J.gp(env["__p"]["S"], "gi")))):
		return null
	v_nq_590 = J.gp(J.gp(J.cl(env["__p"]["G"], null, []), "nodes"), J.gp(v_q_588, "node"))
	var _t271 = (not J.t(v_nq_590))
	var _t272 = (_t271 if _t271 else (not J.seq(J.gp(v_nq_590, "kind"), "lift")))
	if (_t272 if _t272 else (absf(J.num(J.sub(J.gp(v_q_588, "x"), J.gp(env["c"], "cx")))) > J.mul(env["cw"], 0.7))):
		return null
	v_al_591 = (0.35 if J.cmp(J.gp(v_q_588, "inv"), 0.0, ">") else 0.92)
	var _t273 = J.seq(J.gp(J.gp(v_q_588, "d"), "key"), "tianhua")
	var _t274 = ((not J.t(J.gp(v_q_588, "to"))) if _t273 else _t273)
	if ((not J.cmp(J.gp(v_q_588, "dropT"), 0.0, ">")) if _t274 else _t274):
		var _t275 = env["__p"]["sprAt"]
		J.cl(_t275, null, [env["__p"]["wx"], J.gp(J.gp(v_q_588, "d"), "sprite"), J.gp(v_q_588, "x"), J.add(J.mc(env["__p"]["A"], "fy", [J.min_([J.cl(env["__p"]["FL"], null, []), J.add(J.gp(v_nq_590, "f"), 1.0)])]), 14.0), J.gp(J.gp(v_q_588, "d"), "h"), v_al_591, J.cmp(J.gp(v_q_588, "dir"), 0.0, "<"), (-1.0)])
	else:
		var _t276 = env["__p"]["sprAt"]
		J.cl(_t276, null, [env["__p"]["wx"], J.gp(J.gp(v_q_588, "d"), "sprite"), J.gp(v_q_588, "x"), J.gp(v_q_588, "y"), J.gp(J.gp(v_q_588, "d"), "h"), v_al_591, J.cmp(J.gp(v_q_588, "dir"), 0.0, "<")])
	if J.seq(v_qi_589, J.gp(J.cl(env["__p"]["G"], null, []), "active")):
		var _t277 = env["__p"]["wx"]
		J.sp(_t277, "strokeStyle", "rgba(138,255,200,0.55)")
		J.mc(env["__p"]["wx"], "setLineDash", [[4.0, 4.0]])
		var _t278 = env["__p"]["wx"]
		J.sp(_t278, "lineWidth", 1.5)
		J.mc(env["__p"]["wx"], "beginPath", [])
		J.mc(env["__p"]["wx"], "ellipse", [J.gp(v_q_588, "x"), J.sub(J.gp(v_q_588, "y"), 2.0), 30.0, 8.0, 0.0, 0.0, 7.0])
		J.mc(env["__p"]["wx"], "stroke", [])
		J.mc(env["__p"]["wx"], "setLineDash", [[]])

func _f100(this_, a: Array, env):
	var v_o_594 = null; var v_y_595 = null; var v_rk_596 = null
	v_o_594 = J.arg(a, 0)
	if J.seq(J.gp(v_o_594, "ph"), "ride"):
		return null
	v_y_595 = J.mc(env["__p"]["A"], "fy", [J.gp(v_o_594, "f")])
	var _t280 = env["__p"]["rKey"]
	v_rk_596 = J.cl(_t280, null, [v_o_594])
	var _t281 = env["__p"]["sprAt"]
	var _t285 = env["__p"]["wx"]
	var _t286 = J.gp(v_o_594, "x")
	var _t287 = J.sub(v_y_595, 2.0)
	var _t282 = env["__p"]["rH"]
	var _t284 = null
	if J.seq(J.gp(v_o_594, "kind"), "guard"):
		_t284 = 64.0
	else:
		var _t283 = J.gp(J.gp(v_o_594, "ref"), "h")
		_t284 = (_t283 if J.t(_t283) else 66.0)
	var _t292 = J.cl(_t282, null, [v_o_594, v_rk_596, J.mul(_t284, 0.9)])
	var _t291 = null
	if J.seq(J.gp(v_o_594, "ph"), "walkHome"):
		var _t290 = J.gp(v_o_594, "x")
		var _t288 = J.gp(J.gp(v_o_594, "ref"), "unit")
		var _t289 = (J.gp(J.gp(J.gp(J.gp(v_o_594, "ref"), "unit"), "rx"), 0.0) if J.t(_t288) else _t288)
		_t291 = J.cmp(_t290, (_t289 if J.t(_t289) else 0.0), ">")
	else:
		_t291 = J.cmp(J.gp(v_o_594, "x"), J.gp(env["c"], "cx"), ">")
	J.cl(_t281, null, [_t285, v_rk_596, _t286, _t287, _t292, 1.0, _t291])

func _f101(this_, a: Array, env):
	var v_o_599 = null
	v_o_599 = J.arg(a, 0)
	if (not J.t(J.gp(v_o_599, "say"))):
		return null
	if J.seq(J.gp(v_o_599, "ph"), "ride"):
		var _t294 = env["__p"]["bub"]
		J.cl(_t294, null, [env["__p"]["wx"], J.gp(env["c"], "cx"), (J.sub(env["cy"], env["ch"]) - 8.0), J.gp(v_o_599, "say"), 1.0])
	else:
		var _t295 = env["__p"]["bub"]
		J.cl(_t295, null, [env["__p"]["wx"], J.gp(v_o_599, "x"), J.sub(J.mc(env["__p"]["A"], "fy", [J.gp(v_o_599, "f")]), 80.0), J.gp(v_o_599, "say"), 1.0])

func _f95(this_, a: Array, env):
	var v_cv_541 = null; var v_r_542 = null; var v_D_543 = null; var v_p0_544 = null; var v_p1_545 = null; var v_sc_546 = null; var v_cb_547 = null; var v_fh_549 = null; var v_t_552 = null; var v_sh_554 = null; var v_lit_555 = null; var v_ig_556 = null; var v_inn_557 = null; var v_g_558 = null; var v_px2_561 = null; var v_pw2_562 = null; var v_y_564 = null; var v_here_565 = null; var v_op_566 = null; var v_dfx_567 = null; var v_pw_568 = null; var v_fl2_569 = null; var v_lampOn_570 = null; var v_hg_571 = null; var v_wn_572 = null; var v_u_573 = null; var v_pop_574 = null; var v_e_578 = null
	var _s228 = {"__p": env, "c": null, "cw": null, "ch": null, "cy": null, "n": null, "k": null, "f": null}
	v_cv_541 = J.gp(_s228["__p"]["A"], "cv")
	v_r_542 = J.mc(v_cv_541, "getBoundingClientRect", [])
	var _t195 = J.gp(J.G.get("window"), "devicePixelRatio")
	var _t196 = J.gp(J.G.get("window"), "devicePixelRatio")
	v_D_543 = J.min_([2.0, (_t196 if J.t(_t196) else 1.0)])
	var _t197 = (not J.seq(J.gp(_s228["__p"]["wc"], "width"), J.round(J.num(J.mul(J.gp(v_r_542, "width"), v_D_543)))))
	if (_t197 if _t197 else (not J.seq(J.gp(_s228["__p"]["wc"], "height"), J.round(J.num(J.mul(J.gp(v_r_542, "height"), v_D_543)))))):
		var _t198 = _s228["__p"]["wc"]
		var _t199 = J.round(J.num(J.mul(J.gp(v_r_542, "width"), v_D_543)))
		J.sp(_t198, "width", _t199)
		var _t200 = _s228["__p"]["wc"]
		var _t201 = J.round(J.num(J.mul(J.gp(v_r_542, "height"), v_D_543)))
		J.sp(_t200, "height", _t201)
	var _t202 = J.gp(_s228["__p"]["wc"], "style")
	var _t203 = J.add(J.gp(v_r_542, "left"), "px")
	J.sp(_t202, "left", _t203)
	var _t204 = J.gp(_s228["__p"]["wc"], "style")
	var _t205 = J.add(J.gp(v_r_542, "top"), "px")
	J.sp(_t204, "top", _t205)
	var _t206 = J.gp(_s228["__p"]["wc"], "style")
	var _t207 = J.add(J.gp(v_r_542, "width"), "px")
	J.sp(_t206, "width", _t207)
	var _t208 = J.gp(_s228["__p"]["wc"], "style")
	var _t209 = J.add(J.gp(v_r_542, "height"), "px")
	J.sp(_t208, "height", _t209)
	J.mc(_s228["__p"]["wx"], "setTransform", [1.0, 0.0, 0.0, 1.0, 0.0, 0.0])
	J.mc(_s228["__p"]["wx"], "clearRect", [0.0, 0.0, J.gp(_s228["__p"]["wc"], "width"), J.gp(_s228["__p"]["wc"], "height")])
	var _t210 = (not J.t(_s228["__p"]["S"]))
	var _t211 = (_t210 if _t210 else (not J.t(J.gp(_s228["__p"]["S"], "on"))))
	var _t212 = (_t211 if _t211 else (not J.seq(J.gp(_s228["__p"]["A"], "scene"), "play")))
	var _t213 = (_t212 if _t212 else (not J.t(J.cl(_s228["__p"]["G"], null, []))))
	var _t214 = (_t213 if _t213 else J.gp(J.cl(_s228["__p"]["G"], null, []), "choice"))
	var _t215 = (_t214 if J.t(_t214) else J.gp(J.cl(_s228["__p"]["G"], null, []), "over"))
	if J.t((_t215 if J.t(_t215) else J.gp(J.cl(_s228["__p"]["G"], null, []), "showStory"))):
		return null
	v_p0_544 = J.mc(_s228["__p"]["A"], "W2S", [0.0, 0.0])
	v_p1_545 = J.mc(_s228["__p"]["A"], "W2S", [100.0, 0.0])
	v_sc_546 = J.div(J.sub(J.gp(v_p1_545, "x"), J.gp(v_p0_544, "x")), 100.0)
	if (not J.cmp(v_sc_546, 0.0, ">")):
		return null
	J.mc(_s228["__p"]["wx"], "setTransform", [v_D_543, 0.0, 0.0, v_D_543, 0.0, 0.0])
	J.mc(_s228["__p"]["wx"], "save", [])
	J.mc(_s228["__p"]["wx"], "beginPath", [])
	var _t216 = J.cmp(J.gp(J.cl(_s228["__p"]["G"], null, []), "toastT"), 0.0, ">")
	v_cb_547 = (62.0 if J.t((J.gp(J.cl(_s228["__p"]["G"], null, []), "toast") if _t216 else _t216)) else 0.0)
	J.mc(_s228["__p"]["wx"], "rect", [0.0, J.gp(_s228["__p"]["A"], "TOP"), J.gp(_s228["__p"]["A"], "VW"), J.sub(J.sub(J.sub(J.gp(_s228["__p"]["A"], "VH"), J.gp(_s228["__p"]["A"], "TOP")), J.gp(_s228["__p"]["A"], "BOT")), v_cb_547)])
	var _t217 = J.gp(_s228["__p"]["A"], "BTNS")
	var _t218 = (_t217 if J.t(_t217) else [])
	J.mc(_t218, "forEach", [Callable(self, "_f96").bind(_s228)])
	J.mc(_s228["__p"]["wx"], "clip", ["evenodd"])
	J.mc(_s228["__p"]["wx"], "setTransform", [J.mul(v_D_543, v_sc_546), 0.0, 0.0, J.mul(v_D_543, v_sc_546), J.mul(v_D_543, J.gp(v_p0_544, "x")), J.mul(v_D_543, J.gp(v_p0_544, "y"))])
	_s228["c"] = J.cl(_s228["__p"]["col"], null, [])
	v_fh_549 = J.cl(_s228["__p"]["FH"], null, [])
	_s228["cw"] = (J.sub(J.gp(_s228["c"], "x1"), J.gp(_s228["c"], "x0")) * 0.66)
	_s228["ch"] = J.mul(v_fh_549, 0.6)
	v_t_552 = J.gp(_s228["__p"]["S"], "t")
	var _t220 = _s228["__p"]["fyf"]
	_s228["cy"] = J.cl(_t220, null, [J.gp(_s228["__p"]["S"], "pos")])
	v_sh_554 = (((sin(J.num(J.mul(v_t_552, 41.0))) * 0.8) if J.seq(J.gp(_s228["__p"]["S"], "st"), "move") else 0.0) + (((randf() - 0.5) * 4.0) if J.cmp(J.gp(_s228["__p"]["S"], "shake"), 0.0, ">") else 0.0))
	var _t221 = _s228["__p"]["wx"]
	J.sp(_t221, "strokeStyle", "rgba(180,180,170,0.7)")
	var _t222 = _s228["__p"]["wx"]
	J.sp(_t222, "lineWidth", 1.2)
	J.mc(_s228["__p"]["wx"], "beginPath", [])
	J.mc(_s228["__p"]["wx"], "moveTo", [J.sub(J.gp(_s228["c"], "cx"), 6.0), J.sub(J.mc(_s228["__p"]["A"], "fy", [J.cl(_s228["__p"]["FL"], null, [])]), 40.0)])
	J.mc(_s228["__p"]["wx"], "lineTo", [J.sub(J.gp(_s228["c"], "cx"), 6.0), (J.sub(_s228["cy"], _s228["ch"]) - 2.0)])
	J.mc(_s228["__p"]["wx"], "moveTo", [J.add(J.gp(_s228["c"], "cx"), 6.0), J.sub(J.mc(_s228["__p"]["A"], "fy", [J.cl(_s228["__p"]["FL"], null, [])]), 40.0)])
	J.mc(_s228["__p"]["wx"], "lineTo", [J.add(J.gp(_s228["c"], "cx"), 6.0), (J.sub(_s228["cy"], _s228["ch"]) - 2.0)])
	J.mc(_s228["__p"]["wx"], "stroke", [])
	J.mc(_s228["__p"]["wx"], "save", [])
	J.mc(_s228["__p"]["wx"], "translate", [v_sh_554, 0.0])
	v_lit_555 = J.cl(_s228["__p"]["lightLevel"], null, [])
	var _t223 = _s228["__p"]["wx"]
	J.sp(_t223, "fillStyle", "#3a3a36")
	J.mc(_s228["__p"]["wx"], "fillRect", [(J.sub(J.gp(_s228["c"], "cx"), J.div(_s228["cw"], 2.0)) - 3.0), (J.sub(_s228["cy"], _s228["ch"]) - 3.0), J.add(_s228["cw"], 6.0), J.add(_s228["ch"], 3.0)])
	v_ig_556 = J.mc(_s228["__p"]["wx"], "createLinearGradient", [0.0, J.sub(_s228["cy"], _s228["ch"]), 0.0, _s228["cy"]])
	J.mc(v_ig_556, "addColorStop", [0.0, (J.add("rgba(255,228,150,", J.mul(0.95, v_lit_555)) + ")")])
	J.mc(v_ig_556, "addColorStop", [1.0, (J.add("rgba(150,120,70,", J.mul(0.9, v_lit_555)) + ")")])
	var _t224 = _s228["__p"]["wx"]
	J.sp(_t224, "fillStyle", "#0a0a0a")
	J.mc(_s228["__p"]["wx"], "fillRect", [J.sub(J.gp(_s228["c"], "cx"), J.div(_s228["cw"], 2.0)), J.sub(_s228["cy"], _s228["ch"]), _s228["cw"], _s228["ch"]])
	var _t225 = _s228["__p"]["wx"]
	J.sp(_t225, "fillStyle", v_ig_556)
	J.mc(_s228["__p"]["wx"], "fillRect", [J.sub(J.gp(_s228["c"], "cx"), J.div(_s228["cw"], 2.0)), J.sub(_s228["cy"], _s228["ch"]), _s228["cw"], _s228["ch"]])
	v_inn_557 = J.cl(_s228["__p"]["inCab"], null, [])
	v_g_558 = J.cl(_s228["__p"]["ghost"], null, [])
	_s228["n"] = (J.len(v_inn_557) + (1.0 if J.t(v_g_558) else 0.0))
	_s228["k"] = 0.0
	J.mc(v_inn_557, "forEach", [Callable(self, "_f97").bind(_s228)])
	if J.t(v_g_558):
		v_px2_561 = (J.sub(J.gp(_s228["c"], "cx"), J.div(_s228["cw"], 2.0)) + J.mul(_s228["cw"], (0.5 if J.seq(_s228["n"], 1.0) else (0.18 + J.div(J.mul(0.64, _s228["k"]), J.max_([1.0, J.sub(_s228["n"], 1.0)]))))))
		var _t229 = _s228["__p"]["sprAt"]
		J.cl(_t229, null, [_s228["__p"]["wx"], J.gp(J.gp(v_g_558, "d"), "sprite"), v_px2_561, (J.sub(_s228["cy"], 2.0) + (sin(J.num(J.mul(v_t_552, 3.0))) * 1.5)), J.mul(_s228["ch"], 0.82), 0.75, false])
	if J.cmp(v_lit_555, 0.3, "<"):
		var _t230 = _s228["__p"]["wx"]
		J.sp(_t230, "fillStyle", "rgba(0,0,0,0.75)")
		J.mc(_s228["__p"]["wx"], "fillRect", [J.sub(J.gp(_s228["c"], "cx"), J.div(_s228["cw"], 2.0)), J.sub(_s228["cy"], _s228["ch"]), _s228["cw"], _s228["ch"]])
	if (not J.t(J.cl(_s228["__p"]["atFloor"], null, []))):
		v_pw2_562 = (J.div(_s228["cw"], 2.0) * J.sub(1.0, J.gp(_s228["__p"]["S"], "door")))
		if J.cmp(v_pw2_562, 0.5, ">"):
			var _t231 = _s228["__p"]["steel"]
			J.cl(_t231, null, [J.sub(J.gp(_s228["c"], "cx"), J.div(_s228["cw"], 2.0)), J.sub(_s228["cy"], _s228["ch"]), v_pw2_562, _s228["ch"], 1.0])
			var _t232 = _s228["__p"]["steel"]
			J.cl(_t232, null, [J.sub(J.add(J.gp(_s228["c"], "cx"), J.div(_s228["cw"], 2.0)), v_pw2_562), J.sub(_s228["cy"], _s228["ch"]), v_pw2_562, _s228["ch"], (-1.0)])
		if J.cmp(J.gp(_s228["__p"]["S"], "door"), 0.02, ">"):
			var _t233 = _s228["__p"]["gapLight"]
			J.cl(_t233, null, [J.gp(_s228["c"], "cx"), _s228["cy"], J.div(J.mul(_s228["cw"], J.gp(_s228["__p"]["S"], "door")), 2.0), _s228["ch"], J.min_([1.0, J.mul(J.gp(_s228["__p"]["S"], "door"), 3.0)])])
	var _t234 = J.cmp(J.gp(J.gp(_s228["__p"]["S"], "fx"), "over"), 0.0, ">")
	if J.t((J.mod(floor(J.num(J.mul(v_t_552, 6.0))), 2.0) if _t234 else _t234)):
		var _t235 = _s228["__p"]["wx"]
		J.sp(_t235, "fillStyle", "rgba(255,40,30,0.35)")
		J.mc(_s228["__p"]["wx"], "fillRect", [J.sub(J.gp(_s228["c"], "cx"), J.div(_s228["cw"], 2.0)), J.sub(_s228["cy"], _s228["ch"]), _s228["cw"], _s228["ch"]])
	J.mc(_s228["__p"]["wx"], "restore", [])
	_s228["f"] = 0.0
	while true:
		if not J.cmp(_s228["f"], J.cl(_s228["__p"]["top"], null, []), "<="): break
		v_y_564 = J.mc(_s228["__p"]["A"], "fy", [_s228["f"]])
		var _t236 = J.cl(_s228["__p"]["atFloor"], null, [])
		v_here_565 = (J.seq(J.cl(_s228["__p"]["cabF"], null, []), _s228["f"]) if J.t(_t236) else _t236)
		var _t238 = null
		if J.t(v_here_565):
			var _t237 = _s228["__p"]["ease"]
			_t238 = J.cl(_t237, null, [J.gp(_s228["__p"]["S"], "door")])
		else:
			_t238 = 0.0
		v_op_566 = _t238
		v_dfx_567 = J.gp(J.gp(_s228["__p"]["S"], "dfx"), _s228["f"])
		var _t239 = _s228["__p"]["wx"]
		J.sp(_t239, "fillStyle", "#2a2b2e")
		J.mc(_s228["__p"]["wx"], "fillRect", [(J.sub(J.gp(_s228["c"], "cx"), J.div(_s228["cw"], 2.0)) - 5.0), (J.sub(v_y_564, _s228["ch"]) - 5.0), J.add(_s228["cw"], 10.0), 5.0])
		J.mc(_s228["__p"]["wx"], "fillRect", [(J.sub(J.gp(_s228["c"], "cx"), J.div(_s228["cw"], 2.0)) - 5.0), J.sub(v_y_564, _s228["ch"]), 5.0, _s228["ch"]])
		J.mc(_s228["__p"]["wx"], "fillRect", [J.add(J.gp(_s228["c"], "cx"), J.div(_s228["cw"], 2.0)), J.sub(v_y_564, _s228["ch"]), 5.0, _s228["ch"]])
		var _t240 = _s228["__p"]["wx"]
		J.sp(_t240, "fillStyle", "#4a4c50")
		J.mc(_s228["__p"]["wx"], "fillRect", [(J.sub(J.gp(_s228["c"], "cx"), J.div(_s228["cw"], 2.0)) - 5.0), (J.sub(v_y_564, _s228["ch"]) - 5.0), J.add(_s228["cw"], 10.0), 2.0])
		if (not J.t(v_here_565)):
			var _t241 = _s228["__p"]["wx"]
			J.sp(_t241, "fillStyle", "#121214")
			J.mc(_s228["__p"]["wx"], "fillRect", [J.sub(J.gp(_s228["c"], "cx"), J.div(_s228["cw"], 2.0)), J.sub(v_y_564, _s228["ch"]), _s228["cw"], _s228["ch"]])
		v_pw_568 = (J.div(_s228["cw"], 2.0) * J.sub(1.0, v_op_566))
		if J.cmp(v_pw_568, 0.5, ">"):
			var _t242 = _s228["__p"]["steel"]
			J.cl(_t242, null, [J.sub(J.gp(_s228["c"], "cx"), J.div(_s228["cw"], 2.0)), J.sub(v_y_564, _s228["ch"]), v_pw_568, _s228["ch"], 1.0])
			var _t243 = _s228["__p"]["steel"]
			J.cl(_t243, null, [J.sub(J.add(J.gp(_s228["c"], "cx"), J.div(_s228["cw"], 2.0)), v_pw_568), J.sub(v_y_564, _s228["ch"]), v_pw_568, _s228["ch"], (-1.0)])
		if J.t((J.cmp(J.gp(_s228["__p"]["S"], "door"), 0.001, ">") if J.t(v_here_565) else v_here_565)):
			var _t244 = _s228["__p"]["gapLight"]
			J.cl(_t244, null, [J.gp(_s228["c"], "cx"), v_y_564, J.div(J.mul(_s228["cw"], v_op_566), 2.0), _s228["ch"], (1.0 if J.cmp(J.gp(_s228["__p"]["S"], "door"), 1.0, "<") else 0.55)])
		var _t245 = (J.cmp(J.gp(v_dfx_567, "t"), 1.2, "<") if J.t(v_dfx_567) else v_dfx_567)
		v_fl2_569 = (J.seq(J.mod(floor(J.num(J.div(J.gp(v_dfx_567, "t"), 0.15))), 2.0), 0.0) if J.t(_t245) else _t245)
		v_lampOn_570 = (absf(J.num(J.sub(J.gp(_s228["__p"]["S"], "pos"), _s228["f"]))) < 0.5)
		if J.t(v_fl2_569):
			v_hg_571 = J.mc(_s228["__p"]["wx"], "createRadialGradient", [J.gp(_s228["c"], "cx"), (J.sub(v_y_564, _s228["ch"]) - 12.0), 2.0, J.gp(_s228["c"], "cx"), (J.sub(v_y_564, _s228["ch"]) - 12.0), 26.0])
			J.mc(v_hg_571, "addColorStop", [0.0, "rgba(255,214,120,0.85)"])
			J.mc(v_hg_571, "addColorStop", [1.0, "rgba(255,214,120,0)"])
			var _t246 = _s228["__p"]["wx"]
			J.sp(_t246, "fillStyle", v_hg_571)
			J.mc(_s228["__p"]["wx"], "fillRect", [J.sub(J.gp(_s228["c"], "cx"), 28.0), (J.sub(v_y_564, _s228["ch"]) - 40.0), 56.0, 56.0])
		var _t247 = _s228["__p"]["wx"]
		J.sp(_t247, "fillStyle", "#000")
		J.mc(_s228["__p"]["wx"], "fillRect", [J.sub(J.gp(_s228["c"], "cx"), 14.0), (J.sub(v_y_564, _s228["ch"]) - 19.0), 28.0, 13.0])
		var _t248 = _s228["__p"]["wx"]
		var _t249 = ("#fff3c0" if J.t(v_fl2_569) else ("#ffb347" if J.t(v_lampOn_570) else "#7a4a20"))
		J.sp(_t248, "fillStyle", _t249)
		var _t250 = _s228["__p"]["wx"]
		var _t251 = J.add("bold 10px ", J.gp(_s228["__p"]["A"], "FONT"))
		J.sp(_t250, "font", _t251)
		var _t252 = _s228["__p"]["wx"]
		J.sp(_t252, "textAlign", "center")
		var _t254 = (("▲" if J.cmp(J.gp(_s228["__p"]["S"], "dir"), 0.0, ">") else "▼") if J.seq(J.gp(_s228["__p"]["S"], "st"), "move") else "")
		var _t253 = _s228["__p"]["lab"]
		J.mc(_s228["__p"]["wx"], "fillText", [J.add(_t254, J.cl(_t253, null, [J.cl(_s228["__p"]["cabF"], null, [])])), J.gp(_s228["c"], "cx"), (J.sub(v_y_564, _s228["ch"]) - 9.0)])
		var _t255 = J.gp(_s228["__p"]["S"], "riders")
		var _t257 = J.mc(_t255, "some", [Callable(self, "_f98").bind(_s228)])
		v_wn_572 = (_t257 if J.t(_t257) else J.seq(J.gp(_s228["__p"]["S"], "gCall"), _s228["f"]))
		var _t258 = _s228["__p"]["wx"]
		var _t259 = ("#ffd54a" if J.t((v_wn_572 if J.t(v_wn_572) else v_fl2_569)) else "#444")
		J.sp(_t258, "fillStyle", _t259)
		J.mc(_s228["__p"]["wx"], "beginPath", [])
		J.mc(_s228["__p"]["wx"], "arc", [J.add(J.add(J.gp(_s228["c"], "cx"), J.div(_s228["cw"], 2.0)), 9.0), J.sub(v_y_564, J.mul(_s228["ch"], 0.5)), 3.2, 0.0, 7.0])
		J.mc(_s228["__p"]["wx"], "fill", [])
		if J.t((J.cmp(J.gp(v_dfx_567, "t"), 1.4, "<") if J.t(v_dfx_567) else v_dfx_567)):
			v_u_573 = J.div(J.gp(v_dfx_567, "t"), 1.4)
			v_pop_574 = (1.0 + (0.5 * J.max_([0.0, (1.0 - J.div(J.gp(v_dfx_567, "t"), 0.18))])))
			J.mc(_s228["__p"]["wx"], "save", [])
			var _t260 = _s228["__p"]["wx"]
			var _t261 = J.min_([1.0, (J.sub(1.0, v_u_573) * 1.6)])
			J.sp(_t260, "globalAlpha", _t261)
			J.mc(_s228["__p"]["wx"], "translate", [J.add(J.add(J.gp(_s228["c"], "cx"), J.div(_s228["cw"], 2.0)), 16.0), ((J.sub(v_y_564, _s228["ch"]) - 14.0) - J.mul(v_u_573, 34.0))])
			J.mc(_s228["__p"]["wx"], "scale", [v_pop_574, v_pop_574])
			var _t262 = _s228["__p"]["wx"]
			var _t263 = J.add("bold 20px ", J.gp(_s228["__p"]["A"], "FONT"))
			J.sp(_t262, "font", _t263)
			var _t264 = _s228["__p"]["wx"]
			J.sp(_t264, "lineWidth", 4.0)
			var _t265 = _s228["__p"]["wx"]
			J.sp(_t265, "strokeStyle", "#1a1205")
			J.mc(_s228["__p"]["wx"], "strokeText", ["叮", 0.0, 0.0])
			var _t266 = _s228["__p"]["wx"]
			J.sp(_t266, "fillStyle", "#ffd54a")
			J.mc(_s228["__p"]["wx"], "fillText", ["叮", 0.0, 0.0])
			J.mc(_s228["__p"]["wx"], "restore", [])
		_s228["f"] = J.num(_s228["f"]) + 1.0
	var _t267 = J.gp(J.cl(_s228["__p"]["G"], null, []), "gh")
	var _t268 = (_t267 if J.t(_t267) else [])
	J.mc(_t268, "forEach", [Callable(self, "_f99").bind(_s228)])
	var _t279 = J.gp(_s228["__p"]["S"], "riders")
	J.mc(_t279, "forEach", [Callable(self, "_f100").bind(_s228)])
	var _t293 = J.gp(_s228["__p"]["S"], "riders")
	J.mc(_t293, "forEach", [Callable(self, "_f101").bind(_s228)])
	J.mc(_s228["__p"]["wx"], "restore", [])

func _f102(this_, a: Array, env):
	var v_x_602 = null
	v_x_602 = J.arg(a, 0)
	return (J.mul(J.mul(2.0, v_x_602), v_x_602) if J.cmp(v_x_602, 0.5, "<") else (1.0 - J.div(pow(J.num((J.mul((-2.0), v_x_602) + 2.0)), J.num(2.0)), 2.0)))

func _f103(this_, a: Array, env):
	var v_x_605 = null; var v_y_606 = null; var v_w_607 = null; var v_h_608 = null; var v_side_609 = null; var v_gr_610 = null; var v_i_611 = null; var v_ex_612 = null
	v_x_605 = J.arg(a, 0)
	v_y_606 = J.arg(a, 1)
	v_w_607 = J.arg(a, 2)
	v_h_608 = J.arg(a, 3)
	v_side_609 = J.arg(a, 4)
	v_gr_610 = J.mc(env["wx"], "createLinearGradient", [v_x_605, 0.0, J.add(v_x_605, v_w_607), 0.0])
	J.mc(v_gr_610, "addColorStop", [0.0, "#7f8387"])
	J.mc(v_gr_610, "addColorStop", [0.45, "#c9ccd0"])
	J.mc(v_gr_610, "addColorStop", [1.0, "#8a8e92"])
	var _t296 = env["wx"]
	J.sp(_t296, "fillStyle", v_gr_610)
	J.mc(env["wx"], "fillRect", [v_x_605, v_y_606, v_w_607, v_h_608])
	var _t297 = env["wx"]
	J.sp(_t297, "fillStyle", "rgba(255,255,255,0.10)")
	v_i_611 = 1.0
	while true:
		if not J.cmp(v_i_611, 4.0, "<"): break
		J.mc(env["wx"], "fillRect", [v_x_605, J.add(v_y_606, J.div(J.mul(v_h_608, v_i_611), 4.0)), v_w_607, 0.8])
		v_i_611 = J.num(v_i_611) + 1.0
	v_ex_612 = (J.sub(J.add(v_x_605, v_w_607), 1.6) if J.cmp(v_side_609, 0.0, ">") else v_x_605)
	var _t298 = env["wx"]
	J.sp(_t298, "fillStyle", "#4a4d52")
	J.mc(env["wx"], "fillRect", [v_ex_612, v_y_606, 1.6, v_h_608])
	if J.cmp(v_w_607, 6.0, ">"):
		var _t299 = env["wx"]
		J.sp(_t299, "fillStyle", "rgba(40,42,46,0.7)")
		J.mc(env["wx"], "fillRect", [(J.sub(J.add(v_x_605, v_w_607), 5.0) if J.cmp(v_side_609, 0.0, ">") else J.add(v_x_605, 3.4)), J.add(v_y_606, J.mul(v_h_608, 0.42)), 1.6, J.mul(v_h_608, 0.16)])

func _f105(this_, a: Array, env):
	var v_sd_624 = null; var v_ex_625 = null; var v_gr_626 = null
	v_sd_624 = J.arg(a, 0)
	v_ex_625 = J.add(env["cx"], J.mul(v_sd_624, env["half"]))
	v_gr_626 = J.mc(env["__p"]["wx"], "createLinearGradient", [v_ex_625, 0.0, J.add(v_ex_625, J.mul(v_sd_624, 9.0)), 0.0])
	J.mc(v_gr_626, "addColorStop", [0.0, (J.add("rgba(255,236,170,", J.mul(0.75, env["a"])) + ")")])
	J.mc(v_gr_626, "addColorStop", [1.0, "rgba(255,236,170,0)"])
	var _t302 = env["__p"]["wx"]
	J.sp(_t302, "fillStyle", v_gr_626)
	J.mc(env["__p"]["wx"], "fillRect", [J.min_([v_ex_625, J.add(v_ex_625, J.mul(v_sd_624, 9.0))]), J.sub(env["y"], env["ch"]), 9.0, env["ch"]])

func _f104(this_, a: Array, env):
	var v_gs_620 = null; var v_w_621 = null
	var _s256 = {"__p": env, "cx": null, "y": null, "half": null, "ch": null, "a": null}
	_s256["cx"] = J.arg(a, 0)
	_s256["y"] = J.arg(a, 1)
	_s256["half"] = J.arg(a, 2)
	_s256["ch"] = J.arg(a, 3)
	_s256["a"] = J.arg(a, 4)
	J.mc(_s256["__p"]["wx"], "save", [])
	if J.cmp(_s256["half"], 4.0, "<"):
		v_gs_620 = J.mc(_s256["__p"]["wx"], "createLinearGradient", [J.sub(_s256["cx"], 10.0), 0.0, J.add(_s256["cx"], 10.0), 0.0])
		J.mc(v_gs_620, "addColorStop", [0.0, "rgba(255,226,150,0)"])
		J.mc(v_gs_620, "addColorStop", [0.5, (J.add("rgba(255,244,200,", J.mul(0.95, _s256["a"])) + ")")])
		J.mc(v_gs_620, "addColorStop", [1.0, "rgba(255,226,150,0)"])
		var _t300 = _s256["__p"]["wx"]
		J.sp(_t300, "fillStyle", v_gs_620)
		J.mc(_s256["__p"]["wx"], "fillRect", [J.sub(_s256["cx"], 10.0), J.sub(_s256["y"], _s256["ch"]), 20.0, _s256["ch"]])
	else:
		var _t301 = [(-1.0), 1.0]
		J.mc(_t301, "forEach", [Callable(self, "_f105").bind(_s256)])
	v_w_621 = J.max_([3.0, J.mul(_s256["half"], 2.0)])
	var _t303 = _s256["__p"]["wx"]
	var _t304 = (J.add("rgba(255,220,140,", J.mul(0.3, _s256["a"])) + ")")
	J.sp(_t303, "fillStyle", _t304)
	J.mc(_s256["__p"]["wx"], "beginPath", [])
	J.mc(_s256["__p"]["wx"], "moveTo", [J.sub(_s256["cx"], J.div(v_w_621, 2.0)), _s256["y"]])
	J.mc(_s256["__p"]["wx"], "lineTo", [J.add(_s256["cx"], J.div(v_w_621, 2.0)), _s256["y"]])
	J.mc(_s256["__p"]["wx"], "lineTo", [J.add(J.add(_s256["cx"], J.div(v_w_621, 2.0)), 26.0), J.add(_s256["y"], 9.0)])
	J.mc(_s256["__p"]["wx"], "lineTo", [(J.sub(_s256["cx"], J.div(v_w_621, 2.0)) - 26.0), J.add(_s256["y"], 9.0)])
	J.mc(_s256["__p"]["wx"], "closePath", [])
	J.mc(_s256["__p"]["wx"], "fill", [])
	J.mc(_s256["__p"]["wx"], "restore", [])

func _f106(this_, a: Array, env):
	var v_d_629 = null; var v_e_630 = null
	v_d_629 = J.gp(J.gp(env["S"], "fx"), "dark")
	if J.cmp(v_d_629, 0.0, ">"):
		v_e_630 = J.sub(4.2, v_d_629)
		if J.cmp(v_e_630, 0.7, "<"):
			return (0.15 if J.t(J.mod(floor(J.num(J.div(v_e_630, 0.175))), 2.0)) else 1.0)
		return 0.04
	if J.cmp(J.gp(J.gp(env["S"], "fx"), "flick"), 0.0, ">"):
		return 0.55
	if J.seq(J.gp(env["S"], "st"), "stuck"):
		return (0.6 + (0.3 * absf(J.num(sin(J.num(J.mul(J.gp(env["S"], "t"), 9.0)))))))
	return 1.0

func _f108(this_, a: Array, env):
	var _t305 = J.mod(J.mul(env["s"], 16807.0), 2147483647.0)
	env["s"] = _t305
	return J.div(env["s"], 2147483647.0)

func _f110(this_, a: Array, env):
	var v_e_653 = null; var v_i_654 = null; var v_t_655 = null
	v_e_653 = J.arg(a, 0)
	v_i_654 = 0.0
	while true:
		if not J.cmp(v_i_654, 4.0, "<"): break
		v_t_655 = J.div(v_i_654, 4.0)
		J.mc(env["P"], "push", [[J.add(J.add(J.gp(v_e_653, 0.0), J.mul(J.sub(J.gp(v_e_653, 2.0), J.gp(v_e_653, 0.0)), v_t_655)), J.mul(J.sub(J.cl(env["__p"]["r"], null, []), 0.5), env["j"])), J.add(J.add(J.gp(v_e_653, 1.0), J.mul(J.sub(J.gp(v_e_653, 3.0), J.gp(v_e_653, 1.0)), v_t_655)), J.mul(J.sub(J.cl(env["__p"]["r"], null, []), 0.5), env["j"]))]])
		v_i_654 = J.num(v_i_654) + 1.0

func _f111(this_, a: Array, env):
	var v_p_658 = null
	v_p_658 = J.arg(a, 0)
	J.mc(env["__p"]["x"], "lineTo", [J.gp(v_p_658, 0.0), J.gp(v_p_658, 1.0)])

func _f109(this_, a: Array, env):
	var _s264 = {"__p": env, "j": null, "P": null}
	_s264["j"] = J.arg(a, 0)
	_s264["P"] = []
	var _t306 = [[4.0, 4.0, J.sub(_s264["__p"]["N"], 4.0), 4.0], [J.sub(_s264["__p"]["N"], 4.0), 4.0, J.sub(_s264["__p"]["N"], 4.0), J.sub(_s264["__p"]["N"], 4.0)], [J.sub(_s264["__p"]["N"], 4.0), J.sub(_s264["__p"]["N"], 4.0), 4.0, J.sub(_s264["__p"]["N"], 4.0)], [4.0, J.sub(_s264["__p"]["N"], 4.0), 4.0, 4.0]]
	J.mc(_t306, "forEach", [Callable(self, "_f110").bind(_s264)])
	J.mc(_s264["__p"]["x"], "beginPath", [])
	J.mc(_s264["__p"]["x"], "moveTo", [J.gp(J.gp(_s264["P"], 0.0), 0.0), J.gp(J.gp(_s264["P"], 0.0), 1.0)])
	J.mc(_s264["P"], "forEach", [Callable(self, "_f111").bind(_s264)])
	J.mc(_s264["__p"]["x"], "closePath", [])

func _f107(this_, a: Array, env):
	var v_tone_633 = null; var v_press_634 = null; var v_T_635 = null; var v_c_637 = null; var v_k_640 = null; var v_q_641 = null; var v_p_642 = null; var v_path_644 = null
	var _s262 = {"__p": env, "N": null, "x": null, "s": null, "r": null}
	v_tone_633 = J.arg(a, 0)
	v_press_634 = J.arg(a, 1)
	_s262["r"] = Callable(self, "_f108").bind(_s262)
	v_path_644 = Callable(self, "_f109").bind(_s262)
	v_T_635 = J.gp(_s262["__p"]["CRT"], v_tone_633)
	_s262["N"] = 64.0
	v_c_637 = J.S_document_("createElement", ["canvas"])
	var _t307 = J.mul(_s262["N"], 2.0)
	J.sp(v_c_637, "height", _t307)
	J.sp(v_c_637, "width", _t307)
	_s262["x"] = J.mc(v_c_637, "getContext", ["2d"])
	J.mc(_s262["x"], "scale", [2.0, 2.0])
	_s262["s"] = (((7.0 + J.mul(J.mc(v_tone_633, "charCodeAt", [0.0]), 131.0)) + (J.len(v_tone_633) * 977.0)) + (31.0 if J.t(v_press_634) else 0.0))
	J.cl(v_path_644, null, [1.4])
	var _t308 = _s262["x"]
	var _t309 = J.gp(v_T_635, 0.0)
	J.sp(_t308, "fillStyle", _t309)
	J.mc(_s262["x"], "fill", [])
	J.mc(_s262["x"], "save", [])
	J.mc(_s262["x"], "clip", [])
	var _t310 = _s262["x"]
	var _t311 = J.gp(v_T_635, 1.0)
	J.sp(_t310, "strokeStyle", _t311)
	var _t312 = _s262["x"]
	J.sp(_t312, "lineCap", "round")
	v_k_640 = (-J.num(_s262["N"]))
	while true:
		if not J.cmp(v_k_640, J.mul(_s262["N"], 2.0), "<"): break
		var _t313 = _s262["x"]
		var _t314 = (0.3 + J.mul(J.cl(_s262["r"], null, []), 0.3))
		J.sp(_t313, "globalAlpha", _t314)
		var _t315 = _s262["x"]
		var _t316 = (0.8 + J.mul(J.cl(_s262["r"], null, []), 1.3))
		J.sp(_t315, "lineWidth", _t316)
		J.mc(_s262["x"], "beginPath", [])
		J.mc(_s262["x"], "moveTo", [v_k_640, _s262["N"]])
		J.mc(_s262["x"], "lineTo", [J.add(v_k_640, J.mul(_s262["N"], 0.9)), 0.0])
		J.mc(_s262["x"], "stroke", [])
		var _t317 = J.add(v_k_640, (4.0 + J.mul(J.cl(_s262["r"], null, []), 2.0)))
		v_k_640 = _t317
	var _t318 = _s262["x"]
	J.sp(_t318, "globalAlpha", 1.0)
	v_q_641 = 0.0
	while true:
		if not J.cmp(v_q_641, 500.0, "<"): break
		var _t319 = _s262["x"]
		var _t320 = ((J.add("rgba(0,0,0,", (0.1 + J.mul(J.cl(_s262["r"], null, []), 0.25))) + ")") if J.cmp(J.cl(_s262["r"], null, []), 0.6, "<") else (J.add("rgba(255,240,220,", (0.04 + J.mul(J.cl(_s262["r"], null, []), 0.06))) + ")"))
		J.sp(_t319, "fillStyle", _t320)
		J.mc(_s262["x"], "fillRect", [J.mul(J.cl(_s262["r"], null, []), _s262["N"]), J.mul(J.cl(_s262["r"], null, []), _s262["N"]), J.add(1.0, J.cl(_s262["r"], null, [])), J.add(1.0, J.cl(_s262["r"], null, []))])
		v_q_641 = J.num(v_q_641) + 1.0
	J.mc(_s262["x"], "restore", [])
	v_p_642 = 0.0
	while true:
		if not J.cmp(v_p_642, (4.0 if J.t(v_press_634) else 3.0), "<"): break
		var _t321 = _s262["x"]
		var _t322 = (0.5 if J.t(v_p_642) else 0.95)
		J.sp(_t321, "globalAlpha", _t322)
		var _t323 = _s262["x"]
		var _t324 = J.seq(v_p_642, 2.0)
		var _t325 = ("rgba(0,0,0,0.6)" if ((not J.t(v_press_634)) if _t324 else _t324) else J.gp(v_T_635, 2.0))
		J.sp(_t323, "strokeStyle", _t325)
		var _t326 = _s262["x"]
		var _t327 = ((3.4 if J.t(v_press_634) else 2.2) - J.mul(v_p_642, 0.35))
		J.sp(_t326, "lineWidth", _t327)
		var _t328 = _s262["x"]
		J.sp(_t328, "lineJoin", "round")
		J.cl(v_path_644, null, [2.2])
		J.mc(_s262["x"], "stroke", [])
		v_p_642 = J.num(v_p_642) + 1.0
	return (J.add("url(", J.mc(v_c_637, "toDataURL", [])) + ")")

func _f113(this_, a: Array, env):
	var _t329 = J.mod(J.mul(env["s"], 16807.0), 2147483647.0)
	env["s"] = _t329
	return J.div(env["s"], 2147483647.0)

func _f112(this_, a: Array, env):
	var v_c_661 = null; var v_x_662 = null; var v_k_664 = null; var v_q_665 = null; var v_r_666 = null
	var _s275 = {"__p": env, "s": null}
	v_r_666 = Callable(self, "_f113").bind(_s275)
	v_c_661 = J.S_document_("createElement", ["canvas"])
	J.sp(v_c_661, "height", 160.0)
	J.sp(v_c_661, "width", 160.0)
	v_x_662 = J.mc(v_c_661, "getContext", ["2d"])
	_s275["s"] = 11.0
	J.sp(v_x_662, "fillStyle", "#141016")
	J.mc(v_x_662, "fillRect", [0.0, 0.0, 160.0, 160.0])
	J.sp(v_x_662, "strokeStyle", "#2e2430")
	J.sp(v_x_662, "lineCap", "round")
	v_k_664 = (-160.0)
	while true:
		if not J.cmp(v_k_664, 320.0, "<"): break
		var _t330 = (0.25 + J.mul(J.cl(v_r_666, null, []), 0.25))
		J.sp(v_x_662, "globalAlpha", _t330)
		var _t331 = (0.8 + J.mul(J.cl(v_r_666, null, []), 1.4))
		J.sp(v_x_662, "lineWidth", _t331)
		J.mc(v_x_662, "beginPath", [])
		J.mc(v_x_662, "moveTo", [v_k_664, 160.0])
		J.mc(v_x_662, "lineTo", [J.add(v_k_664, 144.0), 0.0])
		J.mc(v_x_662, "stroke", [])
		var _t332 = J.add(v_k_664, (6.0 + J.mul(J.cl(v_r_666, null, []), 2.0)))
		v_k_664 = _t332
	J.sp(v_x_662, "globalAlpha", 1.0)
	v_q_665 = 0.0
	while true:
		if not J.cmp(v_q_665, 1400.0, "<"): break
		var _t333 = ((J.add("rgba(0,0,0,", (0.1 + J.mul(J.cl(v_r_666, null, []), 0.25))) + ")") if J.cmp(J.cl(v_r_666, null, []), 0.6, "<") else (J.add("rgba(255,240,220,", (0.03 + J.mul(J.cl(v_r_666, null, []), 0.06))) + ")"))
		J.sp(v_x_662, "fillStyle", _t333)
		J.mc(v_x_662, "fillRect", [J.mul(J.cl(v_r_666, null, []), 160.0), J.mul(J.cl(v_r_666, null, []), 160.0), (1.0 + J.mul(J.cl(v_r_666, null, []), 1.5)), J.add(1.0, J.cl(v_r_666, null, []))])
		v_q_665 = J.num(v_q_665) + 1.0
	return (J.add("url(", J.mc(v_c_661, "toDataURL", [])) + ")")

func _f115(this_, a: Array, env):
	var _t334 = J.mod(J.mul(env["s"], 16807.0), 2147483647.0)
	env["s"] = _t334
	return J.div(env["s"], 2147483647.0)

func _f114(this_, a: Array, env):
	var v_c_671 = null; var v_x_672 = null; var v_p_674 = null; var v_i_675 = null; var v_r_676 = null
	var _s281 = {"__p": env, "s": null}
	v_r_676 = Callable(self, "_f115").bind(_s281)
	v_c_671 = J.S_document_("createElement", ["canvas"])
	J.sp(v_c_671, "width", 256.0)
	J.sp(v_c_671, "height", 12.0)
	v_x_672 = J.mc(v_c_671, "getContext", ["2d"])
	_s281["s"] = 23.0
	J.sp(v_x_672, "lineCap", "round")
	v_p_674 = 0.0
	while true:
		if not J.cmp(v_p_674, 3.0, "<"): break
		var _t335 = ("rgba(0,0,0,0.6)" if J.seq(v_p_674, 2.0) else "#d8ccb0")
		J.sp(v_x_672, "strokeStyle", _t335)
		var _t336 = (0.5 if J.t(v_p_674) else 0.9)
		J.sp(v_x_672, "globalAlpha", _t336)
		var _t337 = (2.4 - J.mul(v_p_674, 0.5))
		J.sp(v_x_672, "lineWidth", _t337)
		J.mc(v_x_672, "beginPath", [])
		J.mc(v_x_672, "moveTo", [0.0, (4.0 + J.mul(v_p_674, 1.5))])
		v_i_675 = 1.0
		while true:
			if not J.cmp(v_i_675, 16.0, "<="): break
			J.mc(v_x_672, "lineTo", [J.mul(v_i_675, 16.0), ((4.0 + J.mul(v_p_674, 1.5)) + (J.sub(J.cl(v_r_676, null, []), 0.5) * 2.4))])
			v_i_675 = J.num(v_i_675) + 1.0
		J.mc(v_x_672, "stroke", [])
		v_p_674 = J.num(v_p_674) + 1.0
	return (J.add("url(", J.mc(v_c_671, "toDataURL", [])) + ")")

func _f117(this_, a: Array, env):
	var v_t_684 = null
	v_t_684 = J.arg(a, 0)
	return (J.add("border:11px solid transparent;border-image:", J.gp(env["CRF"], v_t_684)) + " 22 fill stretch;background:none;border-radius:0;")

func _f121(this_, a: Array, env):
	var _t339 = J.gp(env["el"], "classList")
	J.mc(_t339, "remove", ["press"])

func _f120(this_, a: Array, env):
	var v_e_696 = null
	var _s290 = {"__p": env, "el": null}
	_s290["el"] = J.arg(a, 0)
	var _t338 = J.gp(_s290["el"], "classList")
	J.mc(_t338, "add", ["press"])
	J.F_setTimeout([Callable(self, "_f121").bind(_s290), 160.0])
	if J.t(J.gp(J.G.get("navigator"), "vibrate")):
		J.S_navigator_("vibrate", [10.0])

func _f123(this_, a: Array, env):
	var v_e_705 = null
	v_e_705 = J.arg(a, 0)
	J.mc(v_e_705, "preventDefault", [])
	var _t342 = env["__p"]["tapFx"]
	J.cl(_t342, null, [env["b"]])
	J.cl(env["__p"]["ac"], null, [])
	J.cl(env["fn"], null, [])
	J.cl(env["__p"]["refresh"], null, [])

func _f122(this_, a: Array, env):
	var v_cls_699 = null; var v_html_700 = null
	var _s295 = {"__p": env, "fn": null, "b": null}
	v_cls_699 = J.arg(a, 0)
	v_html_700 = J.arg(a, 1)
	_s295["fn"] = J.arg(a, 2)
	_s295["b"] = J.S_document_("createElement", ["div"])
	var _t340 = _s295["b"]
	J.sp(_t340, "className", v_cls_699)
	var _t341 = _s295["b"]
	J.sp(_t341, "innerHTML", v_html_700)
	J.mc(_s295["b"], "addEventListener", ["pointerdown", Callable(self, "_f123").bind(_s295)])
	return _s295["b"]

func _f126(this_, a: Array, env):
	J.mc(env["__p"]["L"], "press", [env["f"]])

func _f125(this_, a: Array, env):
	var v_b_716 = null
	var _s299 = {"__p": env, "f": null}
	_s299["f"] = J.arg(a, 0)
	var _t351 = _s299["__p"]["mkBtn"]
	var _t352 = _s299["__p"]["lab"]
	v_b_716 = J.cl(_t351, null, ["lb", J.cl(_t352, null, [_s299["f"]]), Callable(self, "_f126").bind(_s299)])
	var _t353 = J.gp(v_b_716, "dataset")
	var _t354 = _s299["f"]
	J.sp(_t353, "f", _t354)
	J.mc(_s299["__p"]["floorsEl"], "appendChild", [v_b_716])
	var _t355 = _s299["__p"]["fBtns"]
	var _t356 = _s299["f"]
	J.sp(_t355, _t356, v_b_716)

func _f127(this_, a: Array, env):
	J.mc(env["L"], "open", [])

func _f128(this_, a: Array, env):
	J.mc(env["L"], "close", [])

func _f129(this_, a: Array, env):
	J.mc(env["L"], "exit", [])

func _f131(this_, a: Array, env):
	J.mc(env["__p"]["L"], "trick", [env["k"]])

func _f130(this_, a: Array, env):
	var v_b_728 = null
	var _s304 = {"__p": env, "k": null}
	_s304["k"] = J.arg(a, 0)
	var _t360 = _s304["__p"]["mkBtn"]
	v_b_728 = J.cl(_t360, null, ["lt", (J.add("<span>", J.gp(J.gp(_s304["__p"]["TR"], _s304["k"]), "n")) + "</span><small></small>"), Callable(self, "_f131").bind(_s304)])
	var _t361 = J.gp(v_b_728, "dataset")
	var _t362 = _s304["k"]
	J.sp(_t361, "k", _t362)
	J.mc(_s304["__p"]["trickBox"], "appendChild", [v_b_728])
	var _t363 = _s304["__p"]["tBtns"]
	var _t364 = _s304["k"]
	J.sp(_t363, _t364, v_b_728)

func _f124(this_, a: Array, env):
	var v_n_708 = null; var v_cols_709 = null; var v_order_710 = null; var v_f_711 = null; var v_ex_712 = null
	var _t343 = env["floorsEl"]
	J.sp(_t343, "innerHTML", "")
	var _t344 = env["doorsEl"]
	J.sp(_t344, "innerHTML", "")
	var _t345 = env["trickBox"]
	J.sp(_t345, "innerHTML", "")
	var _t346 = {}
	env["fBtns"] = _t346
	var _t347 = {}
	env["tBtns"] = _t347
	v_n_708 = J.add(J.cl(env["top"], null, []), 1.0)
	v_cols_709 = (v_n_708 if J.cmp(v_n_708, 7.0, "<=") else J.min_([7.0, ceil(J.num(J.div(v_n_708, 2.0)))]))
	if J.cmp(v_n_708, 14.0, ">"):
		var _t348 = ceil(J.num(J.div(v_n_708, 3.0)))
		v_cols_709 = _t348
	var _t349 = J.gp(env["floorsEl"], "style")
	var _t350 = (J.add("repeat(", v_cols_709) + ",minmax(48px,56px))")
	J.sp(_t349, "gridTemplateColumns", _t350)
	v_order_710 = []
	v_f_711 = J.cl(env["top"], null, [])
	while true:
		if not J.cmp(v_f_711, 0.0, ">="): break
		J.mc(v_order_710, "push", [v_f_711])
		v_f_711 = J.num(v_f_711) + -1.0
	J.mc(v_order_710, "forEach", [Callable(self, "_f125").bind(env)])
	var _t357 = env["mkBtn"]
	J.mc(env["doorsEl"], "appendChild", [J.cl(_t357, null, ["ld", "◀▶ 開門", Callable(self, "_f127").bind(env)])])
	var _t358 = env["mkBtn"]
	J.mc(env["doorsEl"], "appendChild", [J.cl(_t358, null, ["ld", "▶◀ 關門", Callable(self, "_f128").bind(env)])])
	var _t359 = env["mkBtn"]
	v_ex_712 = J.cl(_t359, null, ["ld exit", "出𨋢", Callable(self, "_f129").bind(env)])
	J.sp(v_ex_712, "id", "lift-exit")
	J.mc(env["doorsEl"], "appendChild", [v_ex_712])
	J.mc(env["TRK"], "forEach", [Callable(self, "_f130").bind(env)])
	env["built"] = v_n_708

func _f132(this_, a: Array, env):
	var v_r_733 = null; var v_W_734 = null; var v_H_735 = null; var v_D_736 = null; var v_bot_737 = null; var v_cabH_738 = null
	v_r_733 = J.mc(J.gp(env["A"], "cv"), "getBoundingClientRect", [])
	v_W_734 = J.gp(v_r_733, "width")
	v_H_735 = J.gp(v_r_733, "height")
	var _t365 = J.gp(J.G.get("window"), "devicePixelRatio")
	var _t366 = J.gp(J.G.get("window"), "devicePixelRatio")
	v_D_736 = J.min_([2.0, (_t366 if J.t(_t366) else 1.0)])
	var _t367 = J.gp(env["ui"], "style")
	var _t368 = J.add(J.gp(v_r_733, "left"), "px")
	J.sp(_t367, "left", _t368)
	var _t369 = J.gp(env["ui"], "style")
	var _t370 = J.add(J.gp(v_r_733, "top"), "px")
	J.sp(_t369, "top", _t370)
	var _t371 = J.gp(env["ui"], "style")
	var _t372 = J.add(v_W_734, "px")
	J.sp(_t371, "width", _t372)
	var _t373 = J.gp(env["ui"], "style")
	var _t374 = J.add(v_H_735, "px")
	J.sp(_t373, "height", _t374)
	v_bot_737 = J.max_([J.gp(env["A"], "BOT"), 200.0])
	v_cabH_738 = J.round(J.num(J.min_([330.0, J.max_([200.0, (J.sub(J.sub(v_H_735, J.gp(env["A"], "TOP")), v_bot_737) * 0.62)])])))
	var _t375 = J.gp(env["cabCv"], "style")
	var _t376 = J.add(J.gp(env["A"], "TOP"), "px")
	J.sp(_t375, "top", _t376)
	var _t377 = J.gp(env["cabCv"], "style")
	var _t378 = J.add(v_cabH_738, "px")
	J.sp(_t377, "height", _t378)
	var _t379 = (not J.seq(J.gp(env["cabCv"], "width"), J.round(J.num(J.mul(v_W_734, v_D_736)))))
	if (_t379 if _t379 else (not J.seq(J.gp(env["cabCv"], "height"), J.round(J.num(J.mul(v_cabH_738, v_D_736)))))):
		var _t380 = env["cabCv"]
		var _t381 = J.round(J.num(J.mul(v_W_734, v_D_736)))
		J.sp(_t380, "width", _t381)
		var _t382 = env["cabCv"]
		var _t383 = J.round(J.num(J.mul(v_cabH_738, v_D_736)))
		J.sp(_t382, "height", _t383)
	var _t384 = J.gp(env["trickBox"], "style")
	var _t385 = J.add(J.sub(J.add(J.gp(env["A"], "TOP"), v_cabH_738), 58.0), "px")
	J.sp(_t384, "top", _t385)
	var _t386 = J.gp(env["block"], "style")
	var _t387 = J.add(J.add(J.gp(env["A"], "TOP"), v_cabH_738), "px")
	J.sp(_t386, "top", _t387)
	var _t388 = J.gp(env["block"], "style")
	var _t389 = J.add(J.max_([0.0, J.sub(J.sub(J.sub(v_H_735, v_bot_737), J.gp(env["A"], "TOP")), v_cabH_738)]), "px")
	J.sp(_t388, "height", _t389)
	var _t390 = J.gp(env["panel"], "style")
	var _t391 = J.add(J.sub(v_H_735, v_bot_737), "px")
	J.sp(_t390, "top", _t391)
	var _t392 = J.gp(env["panel"], "style")
	var _t393 = J.add(v_bot_737, "px")
	J.sp(_t392, "height", _t393)
	var _t394 = env["L"]
	var _t395 = {"y0": J.add(J.gp(env["A"], "TOP"), v_cabH_738), "y1": J.sub(v_H_735, v_bot_737)}
	J.sp(_t394, "_band", _t395)
	return {"W": v_W_734, "H": v_cabH_738, "D": v_D_736}

func _f134(this_, a: Array, env):
	var v_a_750 = null; var v_b_751 = null
	v_a_750 = J.arg(a, 0)
	v_b_751 = J.arg(a, 1)
	return J.sub(v_a_750, v_b_751)

func _f136(this_, a: Array, env):
	var v_o_760 = null
	v_o_760 = J.arg(a, 0)
	var _t405 = J.seq(J.gp(v_o_760, "ph"), "wait")
	return (J.seq(J.gp(v_o_760, "f"), env["f"]) if _t405 else _t405)

func _f135(this_, a: Array, env):
	var v_k_754 = null; var v_ok_755 = null; var v_b_756 = null; var v_show_757 = null
	v_k_754 = J.arg(a, 0)
	v_ok_755 = J.mc(env["__p"]["L"], "canTrick", [v_k_754])
	v_b_756 = J.gp(env["__p"]["tBtns"], v_k_754)
	var _t408 = J.seq(v_ok_755, true)
	if not J.t(_t408):
		var _t407 = J.seq(v_ok_755, "cd")
		if J.t(_t407):
			var _t406 = null
			if J.seq(v_k_754, "door"):
				var _t404 = J.gp(env["__p"]["S"], "riders")
				_t406 = J.mc(_t404, "some", [Callable(self, "_f136").bind(env)])
			else:
				_t406 = (J.len(env["inn"]) > 0.0)
			_t407 = _t406
		_t408 = _t407
	v_show_757 = (_t408 if J.t(_t408) else J.seq(v_ok_755, "busy"))
	var _t409 = J.gp(v_b_756, "style")
	var _t410 = ("flex" if J.t(v_show_757) else "none")
	J.sp(_t409, "display", _t410)
	if J.t(v_show_757):
		env["any"] = true
	var _t411 = J.gp(v_b_756, "classList")
	J.mc(_t411, "toggle", ["cd", (not J.seq(v_ok_755, true))])
	var _t412 = J.mc(v_b_756, "querySelector", ["small"])
	var _t413 = (J.add(ceil(J.num(J.gp(J.gp(env["__p"]["S"], "cd"), v_k_754))), "s") if J.seq(v_ok_755, "cd") else ("進行中" if J.seq(v_ok_755, "busy") else J.add("怕意+", J.gp(J.gp(env["__p"]["TR"], v_k_754), "f"))))
	J.sp(_t412, "textContent", _t413)

func _f133(this_, a: Array, env):
	var v_dest_743 = null; var v_k_744 = null; var v_ex_746 = null; var v_stTxt_747 = null
	var _s308 = {"__p": env, "f": null, "inn": null, "any": null}
	var _t396 = (not J.t(_s308["__p"]["S"]))
	if (_t396 if _t396 else J.leq(J.gp(_s308["__p"]["S"], "gi"), null)):
		return null
	if (not J.seq(_s308["__p"]["built"], J.add(J.cl(_s308["__p"]["top"], null, []), 1.0))):
		J.cl(_s308["__p"]["build"], null, [])
	_s308["f"] = J.cl(_s308["__p"]["cabF"], null, [])
	_s308["inn"] = J.cl(_s308["__p"]["inCab"], null, [])
	var _t397 = J.S_Object_("keys", [J.gp(_s308["__p"]["S"], "stops")])
	var _t398 = J.mc(_t397, "map", [J.G.get("Number")])
	v_dest_743 = J.mc(_t398, "sort", [Callable(self, "_f134").bind(_s308)])
	for _t399 in J.keys(_s308["__p"]["fBtns"]):
		v_k_744 = _t399
		var _t400 = J.gp(J.gp(_s308["__p"]["fBtns"], v_k_744), "classList")
		var _t401 = (not (not J.t(J.gp(J.gp(_s308["__p"]["S"], "lit"), v_k_744))))
		J.mc(_t400, "toggle", ["lit", (_t401 if _t401 else J.cmp(J.gp(J.gp(_s308["__p"]["S"], "fx"), "btnAll"), 0.0, ">"))])
		var _t402 = J.gp(J.gp(_s308["__p"]["fBtns"], v_k_744), "classList")
		var _t403 = J.seq(J.num(v_k_744), _s308["f"])
		J.mc(_t402, "toggle", ["cur", (J.cl(_s308["__p"]["atFloor"], null, []) if _t403 else _t403)])
	_s308["any"] = false
	J.mc(_s308["__p"]["TRK"], "forEach", [Callable(self, "_f135").bind(_s308)])
	var _t414 = J.gp(_s308["__p"]["trickBox"], "style")
	var _t415 = ("flex" if J.t(_s308["any"]) else "none")
	J.sp(_t414, "display", _t415)
	v_ex_746 = J.mc(_s308["__p"]["doorsEl"], "querySelector", ["#lift-exit"])
	if J.t(v_ex_746):
		var _t416 = J.gp(v_ex_746, "classList")
		var _t417 = J.seq(J.gp(_s308["__p"]["S"], "st"), "open")
		var _t418 = (J.cmp(J.gp(_s308["__p"]["S"], "door"), 0.8, ">") if _t417 else _t417)
		J.mc(_t416, "toggle", ["off", (not J.t((J.cl(_s308["__p"]["atFloor"], null, []) if _t418 else _t418)))])
	var _t419 = J.gp({"idle": "停定", "closed": "停定", "move": ("▲ 上緊" if J.cmp(J.gp(_s308["__p"]["S"], "dir"), 0.0, ">") else "▼ 落緊"), "opening": "開門中", "open": "門開咗", "closing": "閂門中", "stuckMove": "⚠ 卡住", "stuck": "⚠ 卡咗喺兩層中間", "unstick": "⚠ 重新起動"}, J.gp(_s308["__p"]["S"], "st"))
	v_stTxt_747 = (_t419 if J.t(_t419) else "")
	var _t420 = _s308["__p"]["stEl"]
	var _t425 = null
	if J.cmp(J.gp(_s308["__p"]["S"], "msgT"), 0.0, ">"):
		_t425 = J.gp(_s308["__p"]["S"], "msg")
	else:
		var _t421 = _s308["__p"]["lab"]
		var _t424 = J.add(J.add(J.cl(_t421, null, [_s308["f"]]), " 樓｜"), v_stTxt_747)
		var _t423 = null
		if J.t(J.len(v_dest_743)):
			var _t422 = J.mc(v_dest_743, "map", [_s308["__p"]["lab"]])
			_t423 = J.add("｜去 ", J.mc(_t422, "join", ["、"]))
		else:
			_t423 = ""
		_t425 = ((J.add(((_t424 + _t423) + "｜𨋢內 "), J.len(_s308["inn"])) + " 人") + ("" if J.t(_s308["any"]) else "（冇人一齊搭）"))
	J.sp(_t420, "textContent", _t425)

func _f138(this_, a: Array, env):
	var _t427 = J.gp(env["ui"], "classList")
	J.mc(_t427, "add", ["show"])

func _f137(this_, a: Array, env):
	if (not J.seq(env["built"], J.add(J.cl(env["top"], null, []), 1.0))):
		J.cl(env["build"], null, [])
	var _t426 = J.gp(env["ui"], "classList")
	J.mc(_t426, "add", ["on"])
	J.cl(env["layout"], null, [])
	J.F_requestAnimationFrame([Callable(self, "_f138").bind(env)])
	J.cl(env["refresh"], null, [])

func _f139(this_, a: Array, env):
	var _t428 = J.gp(env["ui"], "classList")
	J.mc(_t428, "remove", ["show"])
	var _t429 = J.gp(env["ui"], "classList")
	J.mc(_t429, "remove", ["on"])

func _f142(this_, a: Array, env):
	var _t430 = J.mod(J.mul(env["s"], 16807.0), 2147483647.0)
	env["s"] = _t430
	return J.div(env["s"], 2147483647.0)

func _f141(this_, a: Array, env):
	var v_c_771 = null; var v_i_773 = null; var v_x_774 = null; var v_y_775 = null; var v_l_776 = null; var v_j_777 = null; var v_x2_778 = null; var v_y2_779 = null; var v_r_780 = null
	var _s318 = {"__p": env, "s": null}
	v_r_780 = Callable(self, "_f142").bind(_s318)
	if J.t(_s318["__p"]["tex"]):
		return _s318["__p"]["tex"]
	var _t431 = J.S_document_("createElement", ["canvas"])
	_s318["__p"]["tex"] = _t431
	var _t432 = _s318["__p"]["tex"]
	J.sp(_t432, "width", 256.0)
	var _t433 = _s318["__p"]["tex"]
	J.sp(_t433, "height", 256.0)
	v_c_771 = J.mc(_s318["__p"]["tex"], "getContext", ["2d"])
	_s318["s"] = 7.0
	J.sp(v_c_771, "strokeStyle", "rgba(0,0,0,0.5)")
	J.sp(v_c_771, "lineWidth", 1.0)
	v_i_773 = 0.0
	while true:
		if not J.cmp(v_i_773, 900.0, "<"): break
		v_x_774 = J.mul(J.cl(v_r_780, null, []), 256.0)
		v_y_775 = J.mul(J.cl(v_r_780, null, []), 256.0)
		v_l_776 = (3.0 + J.mul(J.cl(v_r_780, null, []), 9.0))
		var _t434 = (0.25 + J.mul(J.cl(v_r_780, null, []), 0.4))
		J.sp(v_c_771, "globalAlpha", _t434)
		J.mc(v_c_771, "beginPath", [])
		J.mc(v_c_771, "moveTo", [v_x_774, v_y_775])
		J.mc(v_c_771, "lineTo", [J.add(v_x_774, v_l_776), J.sub(v_y_775, J.mul(v_l_776, 0.35))])
		J.mc(v_c_771, "stroke", [])
		v_i_773 = J.num(v_i_773) + 1.0
	J.sp(v_c_771, "strokeStyle", "rgba(255,255,255,0.6)")
	v_j_777 = 0.0
	while true:
		if not J.cmp(v_j_777, 300.0, "<"): break
		v_x2_778 = J.mul(J.cl(v_r_780, null, []), 256.0)
		v_y2_779 = J.mul(J.cl(v_r_780, null, []), 256.0)
		var _t435 = (0.15 + J.mul(J.cl(v_r_780, null, []), 0.3))
		J.sp(v_c_771, "globalAlpha", _t435)
		J.mc(v_c_771, "beginPath", [])
		J.mc(v_c_771, "moveTo", [v_x2_778, v_y2_779])
		J.mc(v_c_771, "lineTo", [J.add(J.add(v_x2_778, 4.0), J.mul(J.cl(v_r_780, null, []), 6.0)), J.add(v_y2_779, J.mul(J.cl(v_r_780, null, []), 2.0))])
		J.mc(v_c_771, "stroke", [])
		v_j_777 = J.num(v_j_777) + 1.0
	return _s318["__p"]["tex"]

func _f143(this_, a: Array, env):
	var v_c_785 = null; var v_pts_786 = null; var v_fill_787 = null; var v_i_788 = null
	v_c_785 = J.arg(a, 0)
	v_pts_786 = J.arg(a, 1)
	v_fill_787 = J.arg(a, 2)
	J.mc(v_c_785, "beginPath", [])
	J.mc(v_c_785, "moveTo", [J.gp(v_pts_786, 0.0), J.gp(v_pts_786, 1.0)])
	v_i_788 = 2.0
	while true:
		if not J.cmp(v_i_788, J.len(v_pts_786), "<"): break
		J.mc(v_c_785, "lineTo", [J.gp(v_pts_786, v_i_788), J.gp(v_pts_786, J.add(v_i_788, 1.0))])
		var _t436 = J.add(v_i_788, 2.0)
		v_i_788 = _t436
	J.mc(v_c_785, "closePath", [])
	J.sp(v_c_785, "fillStyle", v_fill_787)
	J.mc(v_c_785, "fill", [])

func _f144(this_, a: Array, env):
	var v_c_791 = null; var v_pts_792 = null; var v_a_793 = null; var v_i_794 = null
	v_c_791 = J.arg(a, 0)
	v_pts_792 = J.arg(a, 1)
	v_a_793 = J.arg(a, 2)
	J.mc(v_c_791, "save", [])
	J.mc(v_c_791, "beginPath", [])
	J.mc(v_c_791, "moveTo", [J.gp(v_pts_792, 0.0), J.gp(v_pts_792, 1.0)])
	v_i_794 = 2.0
	while true:
		if not J.cmp(v_i_794, J.len(v_pts_792), "<"): break
		J.mc(v_c_791, "lineTo", [J.gp(v_pts_792, v_i_794), J.gp(v_pts_792, J.add(v_i_794, 1.0))])
		var _t437 = J.add(v_i_794, 2.0)
		v_i_794 = _t437
	J.mc(v_c_791, "closePath", [])
	J.mc(v_c_791, "clip", [])
	var _t438 = (v_a_793 if J.t(v_a_793) else 0.18)
	J.sp(v_c_791, "globalAlpha", _t438)
	var _t439 = J.mc(v_c_791, "createPattern", [J.cl(env["crayonTex"], null, []), "repeat"])
	J.sp(v_c_791, "fillStyle", _t439)
	J.mc(v_c_791, "fillRect", [0.0, 0.0, 4000.0, 4000.0])
	J.mc(v_c_791, "restore", [])

func _f146(this_, a: Array, env):
	var v_o_850 = null; var v_i_851 = null
	v_o_850 = J.arg(a, 0)
	v_i_851 = J.arg(a, 1)
	var _t463 = env["__p"]["sprAt"]
	var _t465 = env["c"]
	var _t464 = env["__p"]["riderSpr"]
	J.cl(_t463, null, [_t465, J.cl(_t464, null, [v_o_850]), (J.sub(env["W"], 40.0) - J.mul(v_i_851, 18.0)), J.mul(env["H"], 0.6), J.mul(env["H"], 0.4), 0.35, true])

func _f147(this_, a: Array, env):
	var v_o_854 = null
	v_o_854 = J.arg(a, 0)
	var _t487 = J.seq(J.gp(v_o_854, "ph"), "wait")
	return (J.seq(J.gp(v_o_854, "f"), env["f"]) if _t487 else _t487)

func _f148(this_, a: Array, env):
	var v_o_857 = null; var v_i_858 = null
	v_o_857 = J.arg(a, 0)
	v_i_858 = J.arg(a, 1)
	var _t489 = env["__p"]["sprAt"]
	var _t491 = env["c"]
	var _t490 = env["__p"]["riderSpr"]
	J.cl(_t489, null, [_t491, J.cl(_t490, null, [v_o_857]), J.add(env["dx0"], J.mul(env["dw"], (0.78 if J.t(J.mod(v_i_858, 2.0)) else 0.22))), J.add(env["dy0"], env["dh"]), J.mul(env["dh"], 0.85), 1.0, J.seq(J.mod(v_i_858, 2.0), 0.0)])

func _f149(this_, a: Array, env):
	var v_s_861 = null; var v_x_862 = null; var v_dg_863 = null
	v_s_861 = J.arg(a, 0)
	v_x_862 = (J.sub(J.add(env["dx0"], env["dw"]), env["pw"]) if J.t(v_s_861) else env["dx0"])
	v_dg_863 = J.mc(env["c"], "createLinearGradient", [v_x_862, 0.0, J.add(v_x_862, env["pw"]), 0.0])
	J.mc(v_dg_863, "addColorStop", [0.0, "#9da1a5"])
	J.mc(v_dg_863, "addColorStop", [0.5, "#cfd2d5"])
	J.mc(v_dg_863, "addColorStop", [1.0, "#8a8e92"])
	var _t497 = env["c"]
	J.sp(_t497, "fillStyle", v_dg_863)
	J.mc(env["c"], "fillRect", [v_x_862, env["dy0"], env["pw"], env["dh"]])
	var _t498 = env["__p"]["texFill"]
	J.cl(_t498, null, [env["c"], [v_x_862, env["dy0"], J.add(v_x_862, env["pw"]), env["dy0"], J.add(v_x_862, env["pw"]), J.add(env["dy0"], env["dh"]), v_x_862, J.add(env["dy0"], env["dh"])], 0.12])

func _f150(this_, a: Array, env):
	var v_o_866 = null; var v_i_867 = null; var v_x_868 = null; var v_cower_869 = null; var v_hh_870 = null; var v_shk_871 = null; var v_rk_872 = null; var v_tw_873 = null; var v_bx_874 = null; var v_byy_875 = null
	v_o_866 = J.arg(a, 0)
	v_i_867 = J.arg(a, 1)
	v_x_868 = J.gp(env["slots"], J.mod(v_i_867, 4.0))
	v_cower_869 = J.seq(J.gp(v_o_866, "mood"), "cower")
	v_hh_870 = J.mul(env["H"], (0.5 if J.t(v_cower_869) else 0.78))
	v_shk_871 = ((sin(J.num(J.add(J.mul(env["t"], 40.0), v_i_867))) * 1.8) if J.t((v_cower_869 if J.t(v_cower_869) else J.seq(J.gp(v_o_866, "mood"), "bolt"))) else 0.0)
	var _t523 = env["__p"]["rKey"]
	v_rk_872 = J.cl(_t523, null, [v_o_866])
	var _t524 = env["__p"]["sprAt"]
	var _t529 = env["c"]
	var _t530 = J.add(v_x_868, v_shk_871)
	var _t531 = J.add(env["H"], 4.0)
	var _t526 = J.mul(env["H"], 0.9)
	var _t525 = env["__p"]["rH"]
	var _t528 = J.mul(env["H"], 0.9)
	var _t527 = env["__p"]["rH"]
	J.cl(_t524, null, [_t529, v_rk_872, _t530, _t531, J.min_([_t528, J.cl(_t527, null, [v_o_866, v_rk_872, v_hh_870])]), 1.0, J.cmp(v_x_868, J.div(env["W"], 2.0), ">")])
	if J.t(J.gp(v_o_866, "say")):
		var _t532 = env["c"]
		var _t533 = J.add("bold 13px ", J.gp(env["__p"]["A"], "FONT"))
		J.sp(_t532, "font", _t533)
		v_tw_873 = J.min_([J.mul(env["W"], 0.46), J.add(J.gp(J.mc(env["c"], "measureText", [J.gp(v_o_866, "say")]), "width"), 14.0)])
		v_bx_874 = J.max_([4.0, J.min_([(J.sub(env["W"], v_tw_873) - 4.0), J.sub(v_x_868, J.div(v_tw_873, 2.0))])])
		v_byy_875 = (J.mul(env["H"], 0.2) + J.mul(v_i_867, 28.0))
		var _t534 = env["c"]
		J.sp(_t534, "fillStyle", "rgba(255,250,240,0.96)")
		J.mc(env["c"], "fillRect", [v_bx_874, v_byy_875, v_tw_873, 24.0])
		var _t535 = env["c"]
		J.sp(_t535, "strokeStyle", "#1a1a1e")
		var _t536 = env["c"]
		J.sp(_t536, "lineWidth", 1.5)
		J.mc(env["c"], "strokeRect", [v_bx_874, v_byy_875, v_tw_873, 24.0])
		var _t537 = env["c"]
		J.sp(_t537, "fillStyle", "#1a1a1e")
		var _t538 = env["c"]
		J.sp(_t538, "textAlign", "center")
		J.mc(env["c"], "fillText", [J.gp(v_o_866, "say"), J.add(v_bx_874, J.div(v_tw_873, 2.0)), J.add(v_byy_875, 17.0), J.sub(v_tw_873, 6.0)])

func _f145(this_, a: Array, env):
	var v_Lo_797 = null; var v_mv_802 = null; var v_sx_803 = null; var v_sy_804 = null; var v_bx0_805 = null; var v_bx1_806 = null; var v_by0_807 = null; var v_by1_808 = null; var v_lit_809 = null; var v_lg_810 = null; var v_i_811 = null; var v_q_812 = null; var v_lw_813 = null; var v_rw_814 = null; var v_gl_815 = null; var v_gr_816 = null; var v_j_817 = null; var v_xx_818 = null; var v_mr_819 = null; var v_mg_820 = null; var v_m_821 = null; var v_inn_822 = null; var v_a_823 = null; var v_hx_824 = null; var v_hy_825 = null; var v_m2_826 = null; var v_b_827 = null; var v_onB_828 = null; var v_op_833 = null; var v_sl_835 = null; var v_k_837 = null; var v_yy_838 = null; var v_ix_839 = null; var v_iy_840 = null; var v_stuck_841 = null; var v_ovr_842 = null; var v_g_843 = null; var v_dk_845 = null; var v_ey_846 = null; var v_vg_847 = null
	var _s328 = {"__p": env, "W": null, "H": null, "c": null, "t": null, "dw": null, "dx0": null, "dy0": null, "dh": null, "f": null, "pw": null, "slots": null}
	var _t440 = (not J.t(_s328["__p"]["S"]))
	if (_t440 if _t440 else J.leq(J.gp(_s328["__p"]["S"], "gi"), null)):
		return null
	v_Lo_797 = J.cl(_s328["__p"]["layout"], null, [])
	_s328["W"] = J.gp(v_Lo_797, "W")
	_s328["H"] = J.gp(v_Lo_797, "H")
	_s328["c"] = _s328["__p"]["cx2"]
	_s328["t"] = J.gp(_s328["__p"]["S"], "t")
	J.mc(_s328["c"], "setTransform", [J.gp(v_Lo_797, "D"), 0.0, 0.0, J.gp(v_Lo_797, "D"), 0.0, 0.0])
	J.mc(_s328["c"], "clearRect", [0.0, 0.0, _s328["W"], _s328["H"]])
	var _t441 = J.seq(J.gp(_s328["__p"]["S"], "st"), "move")
	v_mv_802 = (_t441 if _t441 else J.seq(J.gp(_s328["__p"]["S"], "st"), "stuckMove"))
	v_sx_803 = ((((sin(J.num(J.mul(_s328["t"], 37.0))) * 1.1) + (sin(J.num(J.mul(_s328["t"], 53.0))) * 0.6)) if J.t(v_mv_802) else 0.0) + (J.mul(((randf() - 0.5) * 8.0), J.gp(_s328["__p"]["S"], "shake")) if J.cmp(J.gp(_s328["__p"]["S"], "shake"), 0.0, ">") else 0.0))
	v_sy_804 = ((sin(J.num(J.mul(_s328["t"], 29.0))) * 0.9) if J.t(v_mv_802) else 0.0)
	J.mc(_s328["c"], "save", [])
	J.mc(_s328["c"], "translate", [v_sx_803, v_sy_804])
	v_bx0_805 = J.mul(_s328["W"], 0.25)
	v_bx1_806 = J.mul(_s328["W"], 0.75)
	v_by0_807 = J.mul(_s328["H"], 0.2)
	v_by1_808 = J.mul(_s328["H"], 0.84)
	var _t442 = _s328["__p"]["poly"]
	J.cl(_t442, null, [_s328["c"], [(-10.0), (-10.0), J.add(_s328["W"], 10.0), (-10.0), v_bx1_806, v_by0_807, v_bx0_805, v_by0_807], "#5d5847"])
	var _t443 = _s328["__p"]["texFill"]
	J.cl(_t443, null, [_s328["c"], [(-10.0), (-10.0), J.add(_s328["W"], 10.0), (-10.0), v_bx1_806, v_by0_807, v_bx0_805, v_by0_807], 0.2])
	v_lit_809 = J.cl(_s328["__p"]["lightLevel"], null, [])
	v_lg_810 = J.mc(_s328["c"], "createRadialGradient", [J.div(_s328["W"], 2.0), J.mul(_s328["H"], 0.06), 4.0, J.div(_s328["W"], 2.0), J.mul(_s328["H"], 0.06), J.mul(_s328["W"], 0.55)])
	J.mc(v_lg_810, "addColorStop", [0.0, (J.add("rgba(255,232,160,", J.mul(0.95, v_lit_809)) + ")")])
	J.mc(v_lg_810, "addColorStop", [1.0, "rgba(255,232,160,0)"])
	var _t444 = _s328["c"]
	J.sp(_t444, "fillStyle", v_lg_810)
	J.mc(_s328["c"], "fillRect", [0.0, 0.0, _s328["W"], J.mul(_s328["H"], 0.5)])
	var _t445 = _s328["c"]
	var _t446 = (J.add("rgba(255,240,190,", J.mul(0.9, v_lit_809)) + ")")
	J.sp(_t445, "fillStyle", _t446)
	J.mc(_s328["c"], "fillRect", [J.mul(_s328["W"], 0.36), J.mul(_s328["H"], 0.05), J.mul(_s328["W"], 0.28), J.mul(_s328["H"], 0.05)])
	var _t447 = _s328["__p"]["poly"]
	J.cl(_t447, null, [_s328["c"], [(-10.0), J.add(_s328["H"], 10.0), J.add(_s328["W"], 10.0), J.add(_s328["H"], 10.0), v_bx1_806, v_by1_808, v_bx0_805, v_by1_808], "#4b4034"])
	var _t448 = _s328["__p"]["texFill"]
	J.cl(_t448, null, [_s328["c"], [(-10.0), J.add(_s328["H"], 10.0), J.add(_s328["W"], 10.0), J.add(_s328["H"], 10.0), v_bx1_806, v_by1_808, v_bx0_805, v_by1_808], 0.25])
	var _t449 = _s328["c"]
	J.sp(_t449, "strokeStyle", "rgba(0,0,0,0.25)")
	var _t450 = _s328["c"]
	J.sp(_t450, "lineWidth", 1.0)
	v_i_811 = 1.0
	while true:
		if not J.cmp(v_i_811, 6.0, "<"): break
		v_q_812 = J.div(v_i_811, 6.0)
		J.mc(_s328["c"], "beginPath", [])
		J.mc(_s328["c"], "moveTo", [J.add(v_bx0_805, J.mul(J.sub(v_bx1_806, v_bx0_805), v_q_812)), v_by1_808])
		J.mc(_s328["c"], "lineTo", [((-10.0) + J.mul(J.add(_s328["W"], 20.0), v_q_812)), J.add(_s328["H"], 10.0)])
		J.mc(_s328["c"], "stroke", [])
		v_i_811 = J.num(v_i_811) + 1.0
	v_lw_813 = [(-10.0), (-10.0), v_bx0_805, v_by0_807, v_bx0_805, v_by1_808, (-10.0), J.add(_s328["H"], 10.0)]
	v_rw_814 = [J.add(_s328["W"], 10.0), (-10.0), v_bx1_806, v_by0_807, v_bx1_806, v_by1_808, J.add(_s328["W"], 10.0), J.add(_s328["H"], 10.0)]
	v_gl_815 = J.mc(_s328["c"], "createLinearGradient", [0.0, 0.0, v_bx0_805, 0.0])
	J.mc(v_gl_815, "addColorStop", [0.0, "#7c8084"])
	J.mc(v_gl_815, "addColorStop", [1.0, "#a9adb1"])
	var _t451 = _s328["__p"]["poly"]
	J.cl(_t451, null, [_s328["c"], v_lw_813, v_gl_815])
	var _t452 = _s328["__p"]["texFill"]
	J.cl(_t452, null, [_s328["c"], v_lw_813, 0.22])
	v_gr_816 = J.mc(_s328["c"], "createLinearGradient", [_s328["W"], 0.0, v_bx1_806, 0.0])
	J.mc(v_gr_816, "addColorStop", [0.0, "#74787c"])
	J.mc(v_gr_816, "addColorStop", [1.0, "#a3a7ab"])
	var _t453 = _s328["__p"]["poly"]
	J.cl(_t453, null, [_s328["c"], v_rw_814, v_gr_816])
	var _t454 = _s328["__p"]["texFill"]
	J.cl(_t454, null, [_s328["c"], v_rw_814, 0.22])
	var _t455 = _s328["c"]
	J.sp(_t455, "strokeStyle", "rgba(255,255,255,0.12)")
	v_j_817 = 0.0
	while true:
		if not J.cmp(v_j_817, 9.0, "<"): break
		v_xx_818 = J.div(J.mul(v_bx0_805, v_j_817), 9.0)
		J.mc(_s328["c"], "beginPath", [])
		J.mc(_s328["c"], "moveTo", [v_xx_818, ((-10.0) + J.div(J.mul(J.add(v_by0_807, 10.0), v_j_817), 9.0))])
		J.mc(_s328["c"], "lineTo", [v_xx_818, J.sub(J.add(_s328["H"], 10.0), J.div(J.mul(J.sub(J.add(_s328["H"], 10.0), v_by1_808), v_j_817), 9.0))])
		J.mc(_s328["c"], "stroke", [])
		v_j_817 = J.num(v_j_817) + 1.0
	var _t456 = _s328["c"]
	J.sp(_t456, "strokeStyle", "#d8c690")
	var _t457 = _s328["c"]
	J.sp(_t457, "lineWidth", 6.0)
	var _t458 = _s328["c"]
	J.sp(_t458, "lineCap", "round")
	J.mc(_s328["c"], "beginPath", [])
	J.mc(_s328["c"], "moveTo", [6.0, J.mul(_s328["H"], 0.66)])
	J.mc(_s328["c"], "lineTo", [J.sub(v_bx0_805, 4.0), J.add(v_by0_807, (J.sub(v_by1_808, v_by0_807) * 0.62))])
	J.mc(_s328["c"], "stroke", [])
	J.mc(_s328["c"], "beginPath", [])
	J.mc(_s328["c"], "moveTo", [J.sub(_s328["W"], 6.0), J.mul(_s328["H"], 0.66)])
	J.mc(_s328["c"], "lineTo", [J.add(v_bx1_806, 4.0), J.add(v_by0_807, (J.sub(v_by1_808, v_by0_807) * 0.62))])
	J.mc(_s328["c"], "stroke", [])
	var _t459 = _s328["c"]
	J.sp(_t459, "strokeStyle", "#6a5a30")
	var _t460 = _s328["c"]
	J.sp(_t460, "lineWidth", 2.0)
	J.mc(_s328["c"], "beginPath", [])
	J.mc(_s328["c"], "moveTo", [6.0, (J.mul(_s328["H"], 0.66) + 3.0)])
	J.mc(_s328["c"], "lineTo", [J.sub(v_bx0_805, 4.0), J.add(J.add(v_by0_807, (J.sub(v_by1_808, v_by0_807) * 0.62)), 2.0)])
	J.mc(_s328["c"], "stroke", [])
	v_mr_819 = [J.sub(_s328["W"], 16.0), J.mul(_s328["H"], 0.12), J.add(v_bx1_806, 8.0), J.add(v_by0_807, 10.0), J.add(v_bx1_806, 8.0), J.add(v_by0_807, (J.sub(v_by1_808, v_by0_807) * 0.56)), J.sub(_s328["W"], 16.0), J.mul(_s328["H"], 0.6)]
	v_mg_820 = J.mc(_s328["c"], "createLinearGradient", [_s328["W"], 0.0, v_bx1_806, _s328["H"]])
	J.mc(v_mg_820, "addColorStop", [0.0, "#6f8894"])
	J.mc(v_mg_820, "addColorStop", [0.5, "#a8c0c8"])
	J.mc(v_mg_820, "addColorStop", [1.0, "#56707c"])
	var _t461 = _s328["__p"]["poly"]
	J.cl(_t461, null, [_s328["c"], v_mr_819, v_mg_820])
	J.mc(_s328["c"], "save", [])
	J.mc(_s328["c"], "beginPath", [])
	J.mc(_s328["c"], "moveTo", [J.gp(v_mr_819, 0.0), J.gp(v_mr_819, 1.0)])
	v_m_821 = 2.0
	while true:
		if not J.cmp(v_m_821, 8.0, "<"): break
		J.mc(_s328["c"], "lineTo", [J.gp(v_mr_819, v_m_821), J.gp(v_mr_819, J.add(v_m_821, 1.0))])
		var _t462 = J.add(v_m_821, 2.0)
		v_m_821 = _t462
	J.mc(_s328["c"], "closePath", [])
	J.mc(_s328["c"], "clip", [])
	v_inn_822 = J.cl(_s328["__p"]["inCab"], null, [])
	J.mc(v_inn_822, "forEach", [Callable(self, "_f146").bind(_s328)])
	if J.cmp(J.gp(J.gp(_s328["__p"]["S"], "fx"), "mirror"), 0.0, ">"):
		v_a_823 = J.min_([1.0, J.div(J.gp(J.gp(_s328["__p"]["S"], "fx"), "mirror"), 0.6), J.div(J.sub(3.6, J.gp(J.gp(_s328["__p"]["S"], "fx"), "mirror")), 0.4)])
		var _t466 = _s328["c"]
		var _t467 = J.mul(0.85, v_a_823)
		J.sp(_t466, "globalAlpha", _t467)
		var _t468 = _s328["c"]
		J.sp(_t468, "fillStyle", "#0c0f12")
		v_hx_824 = J.sub(_s328["W"], 58.0)
		v_hy_825 = J.mul(_s328["H"], 0.26)
		J.mc(_s328["c"], "beginPath", [])
		J.mc(_s328["c"], "ellipse", [v_hx_824, v_hy_825, 11.0, 14.0, 0.0, 0.0, 7.0])
		J.mc(_s328["c"], "fill", [])
		J.mc(_s328["c"], "beginPath", [])
		J.mc(_s328["c"], "moveTo", [J.sub(v_hx_824, 14.0), J.add(v_hy_825, 4.0)])
		J.mc(_s328["c"], "quadraticCurveTo", [J.sub(v_hx_824, 20.0), J.add(v_hy_825, 60.0), J.sub(v_hx_824, 16.0), J.mul(_s328["H"], 0.6)])
		J.mc(_s328["c"], "lineTo", [J.add(v_hx_824, 16.0), J.mul(_s328["H"], 0.6)])
		J.mc(_s328["c"], "quadraticCurveTo", [J.add(v_hx_824, 20.0), J.add(v_hy_825, 60.0), J.add(v_hx_824, 14.0), J.add(v_hy_825, 4.0)])
		J.mc(_s328["c"], "closePath", [])
		J.mc(_s328["c"], "fill", [])
		var _t469 = _s328["c"]
		var _t470 = (J.add("rgba(255,255,255,", J.mul(0.7, v_a_823)) + ")")
		J.sp(_t469, "fillStyle", _t470)
		J.mc(_s328["c"], "fillRect", [J.sub(v_hx_824, 5.0), J.sub(v_hy_825, 2.0), 2.0, 2.0])
		J.mc(_s328["c"], "fillRect", [J.add(v_hx_824, 3.0), J.sub(v_hy_825, 2.0), 2.0, 2.0])
		var _t471 = _s328["c"]
		J.sp(_t471, "globalAlpha", 1.0)
	var _t472 = _s328["c"]
	J.sp(_t472, "fillStyle", "rgba(255,255,255,0.25)")
	J.mc(_s328["c"], "beginPath", [])
	J.mc(_s328["c"], "moveTo", [J.sub(_s328["W"], 30.0), J.mul(_s328["H"], 0.15)])
	J.mc(_s328["c"], "lineTo", [J.sub(_s328["W"], 24.0), J.mul(_s328["H"], 0.15)])
	J.mc(_s328["c"], "lineTo", [J.add(v_bx1_806, 30.0), J.add(v_by0_807, 60.0)])
	J.mc(_s328["c"], "lineTo", [J.add(v_bx1_806, 24.0), J.add(v_by0_807, 60.0)])
	J.mc(_s328["c"], "fill", [])
	J.mc(_s328["c"], "restore", [])
	var _t473 = _s328["c"]
	J.sp(_t473, "strokeStyle", "#c8b878")
	var _t474 = _s328["c"]
	J.sp(_t474, "lineWidth", 3.0)
	J.mc(_s328["c"], "beginPath", [])
	J.mc(_s328["c"], "moveTo", [J.gp(v_mr_819, 0.0), J.gp(v_mr_819, 1.0)])
	v_m2_826 = 2.0
	while true:
		if not J.cmp(v_m2_826, 8.0, "<"): break
		J.mc(_s328["c"], "lineTo", [J.gp(v_mr_819, v_m2_826), J.gp(v_mr_819, J.add(v_m2_826, 1.0))])
		var _t475 = J.add(v_m2_826, 2.0)
		v_m2_826 = _t475
	J.mc(_s328["c"], "closePath", [])
	J.mc(_s328["c"], "stroke", [])
	var _t476 = _s328["c"]
	J.sp(_t476, "fillStyle", "#3a3c40")
	J.mc(_s328["c"], "fillRect", [J.sub(v_bx0_805, 38.0), J.add(v_by0_807, 28.0), 22.0, 58.0])
	v_b_827 = 0.0
	while true:
		if not J.cmp(v_b_827, 6.0, "<"): break
		v_onB_828 = (J.seq(J.mod(floor(J.num(J.add(J.mul(_s328["t"], 10.0), v_b_827))), 2.0), 0.0) if J.cmp(J.gp(J.gp(_s328["__p"]["S"], "fx"), "btnAll"), 0.0, ">") else (not (not J.t(J.gp(J.gp(_s328["__p"]["S"], "lit"), J.sub(J.cl(_s328["__p"]["top"], null, []), v_b_827))))))
		var _t477 = _s328["c"]
		var _t478 = ("#ffb347" if J.t(v_onB_828) else "#8a8d90")
		J.sp(_t477, "fillStyle", _t478)
		J.mc(_s328["c"], "beginPath", [])
		J.mc(_s328["c"], "arc", [J.sub(v_bx0_805, 27.0), J.add(J.add(v_by0_807, 36.0), J.mul(v_b_827, 9.0)), 3.0, 0.0, 7.0])
		J.mc(_s328["c"], "fill", [])
		v_b_827 = J.num(v_b_827) + 1.0
	_s328["dw"] = (J.sub(v_bx1_806, v_bx0_805) * 0.8)
	_s328["dx0"] = (J.div(_s328["W"], 2.0) - J.div(_s328["dw"], 2.0))
	_s328["dy0"] = J.add(v_by0_807, (J.sub(v_by1_808, v_by0_807) * 0.14))
	_s328["dh"] = J.sub(v_by1_808, _s328["dy0"])
	var _t479 = _s328["c"]
	J.sp(_t479, "fillStyle", "#8e9296")
	J.mc(_s328["c"], "fillRect", [v_bx0_805, v_by0_807, J.sub(v_bx1_806, v_bx0_805), J.sub(v_by1_808, v_by0_807)])
	var _t480 = _s328["__p"]["texFill"]
	J.cl(_t480, null, [_s328["c"], [v_bx0_805, v_by0_807, v_bx1_806, v_by0_807, v_bx1_806, v_by1_808, v_bx0_805, v_by1_808], 0.15])
	v_op_833 = J.gp(_s328["__p"]["S"], "door")
	J.mc(_s328["c"], "save", [])
	J.mc(_s328["c"], "beginPath", [])
	J.mc(_s328["c"], "rect", [_s328["dx0"], _s328["dy0"], _s328["dw"], _s328["dh"]])
	J.mc(_s328["c"], "clip", [])
	var _t482 = J.cl(_s328["__p"]["atFloor"], null, [])
	if not J.t(_t482):
		var _t481 = (not J.seq(J.gp(_s328["__p"]["S"], "st"), "stuck"))
		_t482 = ((not J.seq(J.gp(_s328["__p"]["S"], "st"), "unstick")) if _t481 else _t481)
	if J.t(_t482):
		var _t483 = _s328["c"]
		J.sp(_t483, "fillStyle", "#2c2b24")
		J.mc(_s328["c"], "fillRect", [_s328["dx0"], _s328["dy0"], _s328["dw"], _s328["dh"]])
		var _t484 = _s328["c"]
		J.sp(_t484, "fillStyle", "#4a4535")
		J.mc(_s328["c"], "fillRect", [_s328["dx0"], J.add(_s328["dy0"], J.mul(_s328["dh"], 0.82)), _s328["dw"], J.mul(_s328["dh"], 0.18)])
		var _t485 = _s328["c"]
		J.sp(_t485, "fillStyle", "rgba(255,214,140,0.25)")
		J.mc(_s328["c"], "beginPath", [])
		J.mc(_s328["c"], "arc", [J.div(_s328["W"], 2.0), J.add(_s328["dy0"], 10.0), 40.0, 0.0, 7.0])
		J.mc(_s328["c"], "fill", [])
		_s328["f"] = J.cl(_s328["__p"]["cabF"], null, [])
		var _t486 = J.gp(_s328["__p"]["S"], "riders")
		var _t488 = J.mc(_t486, "filter", [Callable(self, "_f147").bind(_s328)])
		J.mc(_t488, "forEach", [Callable(self, "_f148").bind(_s328)])
	else:
		var _t492 = _s328["c"]
		J.sp(_t492, "fillStyle", "#5e594d")
		J.mc(_s328["c"], "fillRect", [_s328["dx0"], _s328["dy0"], _s328["dw"], _s328["dh"]])
		var _t493 = _s328["__p"]["texFill"]
		J.cl(_t493, null, [_s328["c"], [_s328["dx0"], _s328["dy0"], J.add(_s328["dx0"], _s328["dw"]), _s328["dy0"], J.add(_s328["dx0"], _s328["dw"]), J.add(_s328["dy0"], _s328["dh"]), _s328["dx0"], J.add(_s328["dy0"], _s328["dh"])], 0.35])
		var _t494 = _s328["c"]
		J.sp(_t494, "fillStyle", "#3a362e")
		v_sl_835 = J.add(_s328["dy0"], J.mul(_s328["dh"], (0.35 + (0.1 * sin(J.num(1.0))))))
		J.mc(_s328["c"], "fillRect", [_s328["dx0"], v_sl_835, _s328["dw"], J.mul(_s328["dh"], 0.16)])
		var _t495 = _s328["c"]
		J.sp(_t495, "fillStyle", "rgba(0,0,0,0.5)")
		J.mc(_s328["c"], "fillRect", [_s328["dx0"], J.add(v_sl_835, J.mul(_s328["dh"], 0.16)), _s328["dw"], 4.0])
	J.mc(_s328["c"], "restore", [])
	_s328["pw"] = (J.div(_s328["dw"], 2.0) * J.sub(1.0, v_op_833))
	var _t496 = [0.0, 1.0]
	J.mc(_t496, "forEach", [Callable(self, "_f149").bind(_s328)])
	var _t499 = _s328["c"]
	J.sp(_t499, "fillStyle", "#1d1e20")
	J.mc(_s328["c"], "fillRect", [(J.div(_s328["W"], 2.0) - 1.0), _s328["dy0"], 2.0, J.mul(_s328["dh"], (1.0 if J.cmp(v_op_833, 0.02, "<") else 0.0))])
	if J.t((J.cmp(v_op_833, 0.02, "<") if J.t(v_mv_802) else v_mv_802)):
		v_k_837 = 0.0
		while true:
			if not J.cmp(v_k_837, 4.0, "<"): break
			v_yy_838 = J.add(_s328["dy0"], J.mod(J.add(J.mod((J.mul(_s328["t"], (260.0 if J.cmp(J.gp(_s328["__p"]["S"], "dir"), 0.0, ">") else (-260.0))) + J.div(J.mul(v_k_837, _s328["dh"]), 4.0)), _s328["dh"]), _s328["dh"]), _s328["dh"]))
			var _t500 = _s328["c"]
			J.sp(_t500, "fillStyle", "rgba(255,240,200,0.55)")
			J.mc(_s328["c"], "fillRect", [(J.div(_s328["W"], 2.0) - 1.5), v_yy_838, 3.0, 10.0])
			v_k_837 = J.num(v_k_837) + 1.0
	var _t501 = _s328["c"]
	J.sp(_t501, "strokeStyle", "#5c5f63")
	var _t502 = _s328["c"]
	J.sp(_t502, "lineWidth", 4.0)
	J.mc(_s328["c"], "strokeRect", [J.sub(_s328["dx0"], 2.0), J.sub(_s328["dy0"], 2.0), J.add(_s328["dw"], 4.0), J.add(_s328["dh"], 4.0)])
	v_ix_839 = (J.div(_s328["W"], 2.0) - 38.0)
	v_iy_840 = J.sub(v_by0_807, 2.0)
	var _t503 = _s328["c"]
	J.sp(_t503, "fillStyle", "#111")
	J.mc(_s328["c"], "fillRect", [v_ix_839, v_iy_840, 76.0, ((J.sub(_s328["dy0"], v_iy_840) - 6.0) if ((J.sub(_s328["dy0"], v_iy_840) - 6.0) > 18.0) else 22.0)])
	var _t504 = _s328["c"]
	J.sp(_t504, "strokeStyle", "#777")
	var _t505 = _s328["c"]
	J.sp(_t505, "lineWidth", 1.5)
	J.mc(_s328["c"], "strokeRect", [v_ix_839, v_iy_840, 76.0, ((J.sub(_s328["dy0"], v_iy_840) - 6.0) if ((J.sub(_s328["dy0"], v_iy_840) - 6.0) > 18.0) else 22.0)])
	var _t506 = J.seq(J.gp(_s328["__p"]["S"], "st"), "stuck")
	var _t507 = (_t506 if _t506 else J.seq(J.gp(_s328["__p"]["S"], "st"), "stuckMove"))
	v_stuck_841 = (_t507 if _t507 else J.seq(J.gp(_s328["__p"]["S"], "st"), "unstick"))
	v_ovr_842 = J.cmp(J.gp(J.gp(_s328["__p"]["S"], "fx"), "over"), 0.0, ">")
	var _t508 = _s328["c"]
	var _t509 = "bold 20px \"Courier New\",monospace"
	J.sp(_t508, "font", _t509)
	var _t510 = _s328["c"]
	J.sp(_t510, "textAlign", "center")
	var _t511 = _s328["c"]
	var _t512 = (("#ff3b2f" if J.t(J.mod(floor(J.num(J.mul(_s328["t"], 6.0))), 2.0)) else "#5a1410") if J.t(v_ovr_842) else "#ffa030")
	J.sp(_t511, "fillStyle", _t512)
	var _t513 = _s328["c"]
	var _t514 = J.gp(_s328["c"], "fillStyle")
	J.sp(_t513, "shadowColor", _t514)
	var _t515 = _s328["c"]
	J.sp(_t515, "shadowBlur", 8.0)
	var _t521 = null
	if J.t(v_ovr_842):
		_t521 = "OVER"
	else:
		var _t520 = null
		if J.t(v_stuck_841):
			_t520 = "- -"
		else:
			var _t516 = J.cmp(J.gp(_s328["__p"]["S"], "dir"), 0.0, ">")
			var _t518 = null
			if J.t((v_mv_802 if _t516 else _t516)):
				_t518 = "▲"
			else:
				var _t517 = J.cmp(J.gp(_s328["__p"]["S"], "dir"), 0.0, "<")
				_t518 = ("▼" if J.t((v_mv_802 if _t517 else _t517)) else " ")
			var _t519 = _s328["__p"]["lab"]
			_t520 = J.add(_t518, J.cl(_t519, null, [J.cl(_s328["__p"]["cabF"], null, [])]))
		_t521 = _t520
	J.mc(_s328["c"], "fillText", [_t521, J.div(_s328["W"], 2.0), J.add(v_iy_840, 19.0)])
	var _t522 = _s328["c"]
	J.sp(_t522, "shadowBlur", 0.0)
	v_g_843 = J.cl(_s328["__p"]["ghost"], null, [])
	_s328["slots"] = [J.mul(_s328["W"], 0.13), J.mul(_s328["W"], 0.87), J.mul(_s328["W"], 0.3), J.mul(_s328["W"], 0.7)]
	J.mc(v_inn_822, "forEach", [Callable(self, "_f150").bind(_s328)])
	if J.t(v_g_843):
		var _t539 = _s328["__p"]["sprAt"]
		J.cl(_t539, null, [_s328["c"], J.gp(J.gp(v_g_843, "d"), "sprite"), J.mul(_s328["W"], 0.5), (J.mul(_s328["H"], 1.04) + (sin(J.num(J.mul(_s328["t"], 2.6))) * 3.0)), J.mul(_s328["H"], 0.5), 0.5, false])
	v_dk_845 = J.sub(1.0, v_lit_809)
	if J.cmp(v_dk_845, 0.0, ">"):
		var _t540 = _s328["c"]
		var _t541 = (J.add("rgba(0,0,0,", J.mul(0.92, v_dk_845)) + ")")
		J.sp(_t540, "fillStyle", _t541)
		J.mc(_s328["c"], "fillRect", [(-20.0), (-20.0), J.add(_s328["W"], 40.0), J.add(_s328["H"], 40.0)])
		var _t542 = J.cmp(J.gp(J.gp(_s328["__p"]["S"], "fx"), "dark"), 0.0, ">")
		if (J.cmp(v_lit_809, 0.1, "<") if _t542 else _t542):
			var _t543 = _s328["c"]
			J.sp(_t543, "fillStyle", "rgba(220,235,255,0.5)")
			v_ey_846 = (J.mul(_s328["H"], 0.45) + (sin(J.num(J.mul(_s328["t"], 1.3))) * 4.0))
			J.mc(_s328["c"], "fillRect", [J.mul(_s328["W"], 0.62), v_ey_846, 4.0, 2.0])
			J.mc(_s328["c"], "fillRect", [(J.mul(_s328["W"], 0.62) + 12.0), v_ey_846, 4.0, 2.0])
			var _t544 = _s328["c"]
			var _t545 = J.add("14px ", J.gp(_s328["__p"]["A"], "FONT"))
			J.sp(_t544, "font", _t545)
			var _t546 = _s328["c"]
			J.sp(_t546, "fillStyle", "rgba(200,210,220,0.55)")
			var _t547 = _s328["c"]
			J.sp(_t547, "textAlign", "center")
			J.mc(_s328["c"], "fillText", ["……呼……呼……", J.div(_s328["W"], 2.0), J.mul(_s328["H"], 0.35)])
	if J.t(v_ovr_842):
		var _t548 = _s328["c"]
		var _t549 = (J.add("rgba(255,30,20,", (0.18 if J.t(J.mod(floor(J.num(J.mul(_s328["t"], 6.0))), 2.0)) else 0.05)) + ")")
		J.sp(_t548, "fillStyle", _t549)
		J.mc(_s328["c"], "fillRect", [(-20.0), (-20.0), J.add(_s328["W"], 40.0), J.add(_s328["H"], 40.0)])
	v_vg_847 = J.mc(_s328["c"], "createRadialGradient", [J.div(_s328["W"], 2.0), J.div(_s328["H"], 2.0), J.mul(_s328["H"], 0.3), J.div(_s328["W"], 2.0), J.div(_s328["H"], 2.0), J.mul(_s328["W"], 0.75)])
	J.mc(v_vg_847, "addColorStop", [0.0, "rgba(0,0,0,0)"])
	J.mc(v_vg_847, "addColorStop", [1.0, "rgba(20,14,0,0.55)"])
	var _t550 = _s328["c"]
	J.sp(_t550, "fillStyle", v_vg_847)
	J.mc(_s328["c"], "fillRect", [(-20.0), (-20.0), J.add(_s328["W"], 40.0), J.add(_s328["H"], 40.0)])
	J.mc(_s328["c"], "restore", [])

func _f151(this_, a: Array, env):
	var v_g0_878 = null
	v_g0_878 = J.cl(env["G"], null, [])
	var _t551 = J.seq(J.gp(env["A"], "scene"), "play")
	var _t552 = (v_g0_878 if _t551 else _t551)
	var _t553 = ((not J.t(J.gp(v_g0_878, "over"))) if J.t(_t552) else _t552)
	var _t554 = ((not J.t(J.gp(v_g0_878, "choice"))) if J.t(_t553) else _t553)
	var _t555 = ((not J.t(J.gp(v_g0_878, "showStory"))) if J.t(_t554) else _t554)
	var _t556 = ((not J.t(J.gp(v_g0_878, "ult"))) if J.t(_t555) else _t555)
	return ((not J.t(J.gp(env["A"], "paused"))) if J.t(_t556) else _t556)

func _f152(this_, a: Array, env):
	var v_ts_881 = null; var v_dt_882 = null; var v_vis_883 = null; var v_e_884 = null
	v_ts_881 = J.arg(a, 0)
	J.F_requestAnimationFrame([env["loop"]])
	v_dt_882 = (J.min_([0.1, J.div(J.sub(v_ts_881, env["last"]), 1000.0)]) if J.t(env["last"]) else 0.0)
	env["last"] = v_ts_881
	if (not J.seq(J.cl(env["G"], null, []), env["lastG"])):
		J.cl(env["reset"], null, [])
	var _t557 = (J.cl(env["running"], null, []) if J.t(env["S"]) else env["S"])
	if J.t(((not J.t(J.gp(env["L"], "manual"))) if J.t(_t557) else _t557)):
		J.mc(env["L"], "step", [v_dt_882])
	var _t558 = ((not J.leq(J.gp(env["S"], "gi"), null)) if J.t(env["S"]) else env["S"])
	var _t559 = (J.seq(J.gp(env["A"], "scene"), "play") if J.t(_t558) else _t558)
	var _t560 = (J.cl(env["G"], null, []) if J.t(_t559) else _t559)
	var _t561 = ((not J.t(J.gp(J.cl(env["G"], null, []), "over"))) if J.t(_t560) else _t560)
	var _t562 = ((not J.t(J.gp(J.cl(env["G"], null, []), "choice"))) if J.t(_t561) else _t561)
	v_vis_883 = ((not J.t(J.gp(J.cl(env["G"], null, []), "showStory"))) if J.t(_t562) else _t562)
	if J.t(v_vis_883):
		var _t563 = J.gp(env["ui"], "classList")
		if (not J.t(J.mc(_t563, "contains", ["on"]))):
			J.cl(env["showUI"], null, [])
		J.cl(env["refresh"], null, [])
		J.cl(env["drawCab"], null, [])
	else:
		var _t564 = J.gp(env["ui"], "classList")
		if J.t(J.mc(_t564, "contains", ["on"])):
			var _t565 = J.gp(env["ui"], "classList")
			J.mc(_t565, "remove", ["on"])
	J.cl(env["drawWorld"], null, [])

func _f9(this_, a: Array, env):
	var _t566 = env["tone"]
	J.cl(_t566, null, [1318.0, 0.0, 1.1, 0.18])
	var _t567 = env["tone"]
	J.cl(_t567, null, [2636.0, 0.0, 0.5, 0.04])
	var _t568 = env["tone"]
	J.cl(_t568, null, [1046.0, 0.28, 1.3, 0.15])

func _f10(this_, a: Array, env):
	var _t569 = env["noiseBurst"]
	J.cl(_t569, null, [0.0, 0.6, 0.06, 700.0, 0.7])
	var _t570 = env["tone"]
	J.cl(_t570, null, [140.0, 0.0, 0.5, 0.03, "triangle"])

func _f11(this_, a: Array, env):
	var v_i_159 = null
	v_i_159 = 0.0
	while true:
		if not J.cmp(v_i_159, 7.0, "<"): break
		var _t571 = env["tone"]
		J.cl(_t571, null, [520.0, J.mul(v_i_159, 0.32), 0.2, 0.07, "square"])
		v_i_159 = J.num(v_i_159) + 1.0

func _f12(this_, a: Array, env):
	var _t572 = env["noiseBurst"]
	J.cl(_t572, null, [0.2, 1.3, 0.07, 420.0, 0.6])
	var _t573 = env["noiseBurst"]
	J.cl(_t573, null, [1.8, 1.6, 0.06, 360.0, 0.6])

func _f13(this_, a: Array, env):
	var _t574 = env["tone"]
	J.cl(_t574, null, [58.0, 0.0, 0.6, 0.25, "sine"])
	var _t575 = env["noiseBurst"]
	J.cl(_t575, null, [0.0, 0.25, 0.12, 220.0, 0.5])

func _f14(this_, a: Array, env):
	var _t576 = env["tone"]
	J.cl(_t576, null, [1900.0, 0.0, 0.05, 0.05, "square"])

func _f15(this_, a: Array, env):
	var v_on_168 = null; var v_c_169 = null; var v_o_170 = null; var v_o2_171 = null; var v_lp_172 = null; var v_g_173 = null; var v_h_174 = null; var v_e_175 = null
	v_on_168 = J.arg(a, 0)
	v_c_169 = J.cl(env["ac"], null, [])
	if (not J.t(v_c_169)):
		return null
	if J.t(((not J.t(env["hum"])) if J.t(v_on_168) else v_on_168)):
		v_o_170 = J.mc(v_c_169, "createOscillator", [])
		v_o2_171 = J.mc(v_c_169, "createOscillator", [])
		v_lp_172 = J.mc(v_c_169, "createBiquadFilter", [])
		v_g_173 = J.mc(v_c_169, "createGain", [])
		J.sp(v_o_170, "type", "sawtooth")
		var _t577 = J.gp(v_o_170, "frequency")
		J.sp(_t577, "value", 55.0)
		J.sp(v_o2_171, "type", "sine")
		var _t578 = J.gp(v_o2_171, "frequency")
		J.sp(_t578, "value", 110.5)
		J.sp(v_lp_172, "type", "lowpass")
		var _t579 = J.gp(v_lp_172, "frequency")
		J.sp(_t579, "value", 220.0)
		var _t580 = J.gp(v_g_173, "gain")
		J.sp(_t580, "value", 0.0001)
		J.mc(v_o_170, "connect", [v_lp_172])
		J.mc(v_o2_171, "connect", [v_lp_172])
		J.mc(v_lp_172, "connect", [v_g_173])
		J.mc(v_g_173, "connect", [J.gp(v_c_169, "destination")])
		J.mc(v_o_170, "start", [])
		J.mc(v_o2_171, "start", [])
		var _t581 = J.gp(v_g_173, "gain")
		J.mc(_t581, "exponentialRampToValueAtTime", [0.05, J.add(J.gp(v_c_169, "currentTime"), 0.4)])
		var _t582 = {"o": v_o_170, "o2": v_o2_171, "g": v_g_173}
		env["hum"] = _t582
	var _t583 = (not J.t(v_on_168))
	if J.t((env["hum"] if _t583 else _t583)):
		v_h_174 = env["hum"]
		env["hum"] = null
		var _t584 = J.gp(J.gp(v_h_174, "g"), "gain")
		J.mc(_t584, "exponentialRampToValueAtTime", [0.0001, J.add(J.gp(v_c_169, "currentTime"), 0.4)])
		var _t585 = J.gp(v_h_174, "o")
		J.mc(_t585, "stop", [J.add(J.gp(v_c_169, "currentTime"), 0.5)])
		var _t586 = J.gp(v_h_174, "o2")
		J.mc(_t586, "stop", [J.add(J.gp(v_c_169, "currentTime"), 0.5)])

func _f16(this_, a: Array, env):
	J.cl(env["ac"], null, [])

func _f65(this_, a: Array, env):
	var v_g_369 = null; var v_n_370 = null
	v_g_369 = J.arg(a, 0)
	v_n_370 = J.arg(a, 1)
	var _t588 = (not J.t(env["S"]))
	var _t589 = (_t588 if _t588 else (not J.t(J.gp(env["S"], "on"))))
	var _t590 = (_t589 if _t589 else (not J.t(v_g_369)))
	var _t591 = (_t590 if _t590 else J.gp(v_g_369, "home"))
	if J.t((_t591 if J.t(_t591) else J.gp(v_g_369, "out"))):
		return null
	var _t592 = (v_n_370 if J.t(v_n_370) else J.gp(J.gp(J.cl(env["G"], null, []), "nodes"), J.gp(v_g_369, "node")))
	v_n_370 = _t592
	var _t593 = (not J.t(v_n_370))
	var _t594 = (_t593 if _t593 else (not J.seq(J.gp(v_n_370, "kind"), "lift")))
	if (_t594 if _t594 else J.cmp(J.gp(v_n_370, "f"), J.cl(env["top"], null, []), ">")):
		return null
	if (not J.leq(J.gp(env["S"], "gi"), null)):
		return null
	return {"k": "liftIn", "t": ("等緊𨋢……（再撳取消）" if J.seq(J.gp(env["S"], "gCall"), J.gp(v_n_370, "f")) else "入𨋢（撳掣叫𨋢）")}

func _f66(this_, a: Array, env):
	var v_g_373 = null; var v_n_374 = null; var v_f_375 = null
	v_g_373 = J.arg(a, 0)
	var _t597 = (not J.t(env["S"]))
	if (_t597 if _t597 else (not J.t(J.gp(env["S"], "on")))):
		return false
	v_n_374 = J.gp(J.gp(J.cl(env["G"], null, []), "nodes"), J.gp(v_g_373, "node"))
	var _t598 = (not J.t(v_n_374))
	if (_t598 if _t598 else (not J.seq(J.gp(v_n_374, "kind"), "lift"))):
		return false
	v_f_375 = J.gp(v_n_374, "f")
	if J.seq(J.gp(env["S"], "gCall"), v_f_375):
		var _t599 = env["S"]
		J.sp(_t599, "gCall", null)
		var _t600 = env["S"]
		J.sp(_t600, "gWait", null)
		var _t601 = env["fl"]
		J.cl(_t601, null, [J.gp(v_g_373, "x"), J.sub(J.gp(v_g_373, "y"), 80.0), "唔等喇", "#ffd54a"])
		return false
	var _t602 = J.cl(env["atFloor"], null, [])
	var _t605 = (J.seq(J.cl(env["cabF"], null, []), v_f_375) if J.t(_t602) else _t602)
	if J.t(_t605):
		var _t603 = J.seq(J.gp(env["S"], "st"), "open")
		var _t604 = (_t603 if _t603 else J.seq(J.gp(env["S"], "st"), "opening"))
		_t605 = (_t604 if _t604 else J.seq(J.gp(env["S"], "st"), "idle"))
	if J.t(_t605):
		var _t606 = env["doEnter"]
		J.cl(_t606, null, [v_g_373, v_f_375])
		return true
	var _t607 = env["S"]
	J.sp(_t607, "gCall", v_f_375)
	var _t608 = env["S"]
	var _t609 = J.gp(v_g_373, "i")
	J.sp(_t608, "gWait", _t609)
	J.mc(env["SND"], "click", [])
	var _t610 = env["fl"]
	J.cl(_t610, null, [J.gp(v_g_373, "x"), J.sub(J.gp(v_g_373, "y"), 80.0), "撳咗𨋢掣，等緊𨋢……", "#ffd54a"])
	return "called"

func _f68(this_, a: Array, env):
	var v_g_382 = null; var v_f_383 = null; var v_c_384 = null
	v_g_382 = J.cl(env["ghost"], null, [])
	if (not J.t(v_g_382)):
		return false
	var _t613 = J.seq(J.gp(env["S"], "st"), "open")
	var _t614 = (J.cmp(J.gp(env["S"], "door"), 0.8, ">") if _t613 else _t613)
	if (not J.t((J.cl(env["atFloor"], null, []) if _t614 else _t614))):
		var _t615 = env["flash"]
		J.cl(_t615, null, ["門未開，出唔到"])
		return false
	v_f_383 = J.cl(env["cabF"], null, [])
	v_c_384 = J.cl(env["col"], null, [])
	var _t616 = env["S"]
	J.sp(_t616, "gi", null)
	var _t617 = (J.add("f", v_f_383) + "_l")
	J.sp(v_g_382, "node", _t617)
	J.sp(v_g_382, "to", null)
	var _t618 = J.gp(v_c_384, "cx")
	J.sp(v_g_382, "x", _t618)
	var _t619 = J.mc(env["A"], "fy", [v_f_383])
	J.sp(v_g_382, "y", _t619)
	J.sp(v_g_382, "inv", 0.0)
	J.sp(v_g_382, "still", 1.0)
	var _t620 = env["dingFx"]
	J.cl(_t620, null, [v_f_383])
	if J.seq(J.gp(env["S"], "st"), "open"):
		var _t621 = env["S"]
		var _t622 = J.max_([J.gp(env["S"], "hold"), 0.8])
		J.sp(_t621, "hold", _t622)
	J.cl(env["hideUI"], null, [])
	var _t623 = env["log"]
	J.cl(_t623, null, ["exit"])
	return true

func _f69(this_, a: Array, env):
	var v_f_387 = null
	v_f_387 = J.arg(a, 0)
	var _t626 = (not J.t(env["S"]))
	if (_t626 if _t626 else J.leq(J.gp(env["S"], "gi"), null)):
		return null
	J.mc(env["SND"], "click", [])
	v_f_387 = J.num(v_f_387)
	var _t627 = J.cl(env["atFloor"], null, [])
	var _t628 = (J.seq(J.cl(env["cabF"], null, []), v_f_387) if J.t(_t627) else _t627)
	if J.t(((not J.seq(J.gp(env["S"], "st"), "move")) if J.t(_t628) else _t628)):
		J.mc(env["L"], "open", [])
		return null
	var _t629 = J.seq(J.gp(env["S"], "st"), "stuck")
	if (_t629 if _t629 else J.seq(J.gp(env["S"], "st"), "stuckMove")):
		var _t630 = env["flash"]
		J.cl(_t630, null, ["卡住咗，掣冇反應"])
		return null
	var _t631 = J.gp(env["S"], "stops")
	J.sp(_t631, v_f_387, 1.0)
	var _t632 = J.gp(env["S"], "lit")
	J.sp(_t632, v_f_387, 1.0)
	if J.seq(J.gp(env["S"], "st"), "open"):
		var _t633 = env["S"]
		var _t634 = J.min_([J.gp(env["S"], "hold"), 0.9])
		J.sp(_t633, "hold", _t634)
	var _t635 = env["log"]
	J.cl(_t635, null, [J.add("press", v_f_387)])

func _f70(this_, a: Array, env):
	var _t638 = (not J.t(env["S"]))
	if (_t638 if _t638 else J.leq(J.gp(env["S"], "gi"), null)):
		return null
	J.mc(env["SND"], "click", [])
	var _t639 = J.seq(J.gp(env["S"], "st"), "move")
	var _t640 = (_t639 if _t639 else J.seq(J.gp(env["S"], "st"), "stuckMove"))
	if (_t640 if _t640 else J.seq(J.gp(env["S"], "st"), "stuck")):
		var _t641 = env["flash"]
		J.cl(_t641, null, [("行緊，開唔到門" if J.seq(J.gp(env["S"], "st"), "move") else "卡住咗，門開唔到")])
		return null
	var _t642 = J.seq(J.gp(env["S"], "st"), "closing")
	if (_t642 if _t642 else J.seq(J.gp(env["S"], "st"), "idle")):
		var _t643 = env["S"]
		J.sp(_t643, "st", "opening")
		J.mc(env["SND"], "door", [])
	var _t644 = env["S"]
	var _t645 = J.max_([J.gp(env["S"], "hold"), 3.0])
	J.sp(_t644, "hold", _t645)

func _f71(this_, a: Array, env):
	var _t648 = (not J.t(env["S"]))
	if (_t648 if _t648 else J.leq(J.gp(env["S"], "gi"), null)):
		return null
	J.mc(env["SND"], "click", [])
	if J.cmp(J.gp(J.gp(env["S"], "fx"), "over"), 0.0, ">"):
		var _t649 = env["flash"]
		J.cl(_t649, null, ["超重！門閂唔到"])
		return null
	var _t650 = J.seq(J.gp(env["S"], "st"), "open")
	if (_t650 if _t650 else J.seq(J.gp(env["S"], "st"), "opening")):
		var _t651 = env["S"]
		J.sp(_t651, "st", "closing")
		var _t652 = env["S"]
		J.sp(_t652, "hold", 0.0)
		J.mc(env["SND"], "door", [])

func _f73(this_, a: Array, env):
	var v_o_398 = null
	v_o_398 = J.arg(a, 0)
	var _t660 = J.seq(J.gp(v_o_398, "ph"), "wait")
	return (J.seq(J.gp(v_o_398, "f"), env["f"]) if _t660 else _t660)

func _f72(this_, a: Array, env):
	var v_k_394 = null
	var _s129 = {"__p": env, "f": null}
	v_k_394 = J.arg(a, 0)
	var _t655 = (not J.t(_s129["__p"]["S"]))
	if (_t655 if _t655 else J.leq(J.gp(_s129["__p"]["S"], "gi"), null)):
		return "out"
	if J.cmp(J.gp(J.gp(_s129["__p"]["S"], "cd"), v_k_394), 0.0, ">"):
		return "cd"
	if J.seq(v_k_394, "door"):
		_s129["f"] = J.cl(_s129["__p"]["cabF"], null, [])
		var _t656 = (not J.t(J.cl(_s129["__p"]["atFloor"], null, [])))
		var _t658 = (_t656 if _t656 else J.seq(J.gp(_s129["__p"]["S"], "st"), "move"))
		if not J.t(_t658):
			var _t657 = J.F_String([J.gp(_s129["__p"]["S"], "st")])
			_t658 = J.seq(J.mc(_t657, "indexOf", ["stuck"]), 0.0)
		if _t658:
			return "nolanding"
		var _t659 = J.gp(_s129["__p"]["S"], "riders")
		return (true if J.t(J.mc(_t659, "some", [Callable(self, "_f73").bind(_s129)])) else "nolanding")
	if (not J.t(J.len(J.cl(_s129["__p"]["inCab"], null, [])))):
		return "empty"
	var _t662 = J.seq(v_k_394, "stuck")
	if J.t(_t662):
		var _t661 = J.seq(J.gp(_s129["__p"]["S"], "st"), "stuck")
		_t662 = (_t661 if _t661 else J.seq(J.gp(_s129["__p"]["S"], "st"), "stuckMove"))
	if _t662:
		return "busy"
	return true

func _f75(this_, a: Array, env):
	var v_o_412 = null; var v_r_413 = null; var v_amt_414 = null
	v_o_412 = J.arg(a, 0)
	if J.seq(J.gp(v_o_412, "kind"), "guard"):
		var _t700 = env["__p"]["sayR"]
		var _t701 = env["__p"]["line"]
		J.cl(_t700, null, [v_o_412, J.cl(_t701, null, ["gReport"])])
		J.sp(v_o_412, "mood", "mroom")
		var _t702 = J.add(env["tot"], 8.0)
		env["tot"] = _t702
		var _t703 = env["__p"]["fl"]
		var _t705 = J.gp(env["c"], "cx")
		var _t704 = env["__p"]["fyf"]
		J.cl(_t703, null, [_t705, J.sub(J.cl(_t704, null, [J.gp(env["__p"]["S"], "pos")]), 130.0), "保安用對講機報𨋢故障", "#ffb0b0"])
		return null
	v_r_413 = J.gp(v_o_412, "ref")
	var _t707 = J.gp(env["T"], "f")
	var _t706 = J.gp(v_r_413, "brave")
	v_amt_414 = J.mul(J.mul(_t707, J.sub(1.0, (_t706 if J.t(_t706) else 0.0))), J.cl(env["__p"]["gpm"], null, []))
	var _t708 = J.add(J.gp(v_o_412, "fear"), v_amt_414)
	J.sp(v_o_412, "fear", _t708)
	var _t709 = J.gp(v_r_413, "fear")
	var _t710 = J.add((_t709 if J.t(_t709) else 0.0), J.mul(v_amt_414, 0.3))
	J.sp(v_r_413, "fear", _t710)
	var _t711 = J.add(env["tot"], v_amt_414)
	env["tot"] = _t711
	var _t713 = J.cmp(J.gp(v_o_412, "fear"), 60.0, ">=")
	if not J.t(_t713):
		var _t712 = J.seq(env["k"], "stuck")
		_t713 = (J.cmp(J.gp(v_o_412, "fear"), 45.0, ">=") if _t712 else _t712)
	if _t713:
		J.sp(v_o_412, "mood", "bolt")
		var _t714 = env["__p"]["sayR"]
		var _t715 = env["__p"]["line"]
		J.cl(_t714, null, [v_o_412, J.cl(_t715, null, [env["k"]])])
	else:
		J.sp(v_o_412, "mood", "cower")
		var _t716 = env["__p"]["sayR"]
		var _t717 = env["__p"]["line"]
		J.cl(_t716, null, [v_o_412, J.cl(_t717, null, [env["k"]])])

func _f74(this_, a: Array, env):
	var v_ok_402 = null; var v_g_404 = null; var v_f_406 = null; var v_mid_407 = null; var v_add_409 = null
	var _s132 = {"__p": env, "k": null, "T": null, "c": null, "tot": null}
	_s132["k"] = J.arg(a, 0)
	v_ok_402 = J.mc(_s132["__p"]["L"], "canTrick", [_s132["k"]])
	if (not J.seq(v_ok_402, true)):
		if J.seq(v_ok_402, "cd"):
			var _t665 = _s132["__p"]["flash"]
			J.cl(_t665, null, [J.add(J.gp(J.gp(_s132["__p"]["TR"], _s132["k"]), "n"), "冷卻中")])
		else:
			if J.seq(v_ok_402, "empty"):
				var _t666 = _s132["__p"]["flash"]
				J.cl(_t666, null, ["𨋢入面冇人"])
			else:
				if J.seq(v_ok_402, "nolanding"):
					var _t667 = _s132["__p"]["flash"]
					J.cl(_t667, null, ["門口冇人等𨋢"])
		return false
	_s132["T"] = J.gp(_s132["__p"]["TR"], _s132["k"])
	v_g_404 = J.cl(_s132["__p"]["ghost"], null, [])
	_s132["c"] = J.cl(_s132["__p"]["col"], null, [])
	var _t668 = J.gp(_s132["__p"]["S"], "cd")
	var _t669 = _s132["k"]
	var _t670 = J.gp(_s132["T"], "cd")
	J.sp(_t668, _t669, _t670)
	var _t671 = _s132["__p"]["log"]
	J.cl(_t671, null, [J.add("trick:", _s132["k"])])
	if J.seq(_s132["k"], "dark"):
		var _t672 = J.gp(_s132["__p"]["S"], "fx")
		J.sp(_t672, "dark", 4.2)
		J.mc(_s132["__p"]["SND"], "breath", [])
	if J.seq(_s132["k"], "btns"):
		var _t673 = _s132["__p"]["S"]
		var _t674 = J.gp(_s132["__p"]["S"], "btnsSet")
		var _t675 = (_t674 if J.t(_t674) else {})
		J.sp(_t673, "btnsSet", _t675)
		v_f_406 = 0.0
		while true:
			if not J.cmp(v_f_406, J.cl(_s132["__p"]["top"], null, []), "<="): break
			var _t676 = (not J.seq(v_f_406, J.cl(_s132["__p"]["cabF"], null, [])))
			var _t677 = (_t676 if _t676 else (not J.t(J.cl(_s132["__p"]["atFloor"], null, []))))
			if ((not J.t(J.gp(J.gp(_s132["__p"]["S"], "stops"), v_f_406))) if _t677 else _t677):
				var _t678 = J.gp(_s132["__p"]["S"], "stops")
				J.sp(_t678, v_f_406, 1.0)
				var _t679 = J.gp(_s132["__p"]["S"], "lit")
				J.sp(_t679, v_f_406, 1.0)
				var _t680 = J.gp(_s132["__p"]["S"], "btnsSet")
				J.sp(_t680, v_f_406, 1.0)
			v_f_406 = J.num(v_f_406) + 1.0
		var _t681 = _s132["__p"]["S"]
		var _t682 = J.add(J.gp(_s132["__p"]["S"], "t"), 30.0)
		J.sp(_t681, "btnsUntil", _t682)
		var _t683 = J.gp(_s132["__p"]["S"], "fx")
		J.sp(_t683, "btnAll", 3.0)
		J.mc(_s132["__p"]["SND"], "click", [])
	if J.seq(_s132["k"], "mirror"):
		var _t684 = J.gp(_s132["__p"]["S"], "fx")
		J.sp(_t684, "mirror", 3.6)
		var _t685 = _s132["__p"]["tone"]
		J.cl(_t685, null, [196.0, 0.0, 1.6, 0.05, "triangle"])
	if J.seq(_s132["k"], "over"):
		var _t686 = J.gp(_s132["__p"]["S"], "fx")
		J.sp(_t686, "over", 3.6)
		J.mc(_s132["__p"]["SND"], "buzz", [])
		if J.seq(J.gp(_s132["__p"]["S"], "st"), "closing"):
			var _t687 = _s132["__p"]["S"]
			J.sp(_t687, "st", "opening")
	if J.seq(_s132["k"], "stuck"):
		v_mid_407 = J.min_([J.sub(J.cl(_s132["__p"]["top"], null, []), 0.5), J.max_([0.5, (floor(J.num(J.gp(_s132["__p"]["S"], "pos"))) + 0.5)])])
		var _t688 = J.cmp(J.gp(_s132["__p"]["S"], "dir"), 0.0, "<")
		if ((not J.t(J.cl(_s132["__p"]["atFloor"], null, []))) if _t688 else _t688):
			var _t689 = J.max_([0.5, (ceil(J.num(J.gp(_s132["__p"]["S"], "pos"))) - 0.5)])
			v_mid_407 = _t689
		var _t690 = _s132["__p"]["S"]
		J.sp(_t690, "stuckTo", v_mid_407)
		var _t691 = _s132["__p"]["S"]
		J.sp(_t691, "st", "stuckMove")
		var _t692 = _s132["__p"]["S"]
		J.sp(_t692, "stuckT", 5.5)
		J.mc(_s132["__p"]["SND"], "hum", [true])
		if J.cmp(J.gp(_s132["__p"]["S"], "door"), 0.0, ">"):
			var _t693 = _s132["__p"]["S"]
			J.sp(_t693, "door", 0.0)
			J.mc(_s132["__p"]["SND"], "door", [])
	if J.seq(_s132["k"], "door"):
		var _t694 = J.gp(_s132["__p"]["S"], "fx")
		var _t695 = J.max_([J.gp(J.gp(_s132["__p"]["S"], "fx"), "dark"), 2.2])
		J.sp(_t694, "dark", _t695)
		J.cl(_s132["__p"]["scareLanding"], null, [])
		if J.t(J.gp(_s132["__p"]["A"], "addFear")):
			var _t697 = J.round(J.num(J.mul(J.mul(J.gp(_s132["T"], "f"), 0.4), J.cl(_s132["__p"]["gpm"], null, []))))
			var _t698 = J.gp(_s132["c"], "cx")
			var _t696 = _s132["__p"]["fyf"]
			J.mc(_s132["__p"]["A"], "addFear", [_t697, _t698, J.sub(J.cl(_t696, null, [J.gp(_s132["__p"]["S"], "pos")]), 120.0)])
		return true
	_s132["tot"] = 0.0
	var _t699 = J.cl(_s132["__p"]["inCab"], null, [])
	J.mc(_t699, "forEach", [Callable(self, "_f75").bind(_s132)])
	v_add_409 = J.max_([4.0, J.round(J.num(J.mul(_s132["tot"], 0.35)))])
	if J.t(J.gp(_s132["__p"]["A"], "addFear")):
		var _t719 = J.gp(_s132["c"], "cx")
		var _t718 = _s132["__p"]["fyf"]
		J.mc(_s132["__p"]["A"], "addFear", [v_add_409, _t719, J.sub(J.cl(_t718, null, [J.gp(_s132["__p"]["S"], "pos")]), 110.0)])
	if J.t(v_g_404):
		var _t720 = J.gp(v_g_404, "energy")
		var _t721 = J.gp(v_g_404, "energy")
		var _t722 = J.min_([100.0, J.add((_t721 if J.t(_t721) else 0.0), 6.0)])
		J.sp(v_g_404, "energy", _t722)
	var _t723 = _s132["__p"]["S"]
	J.sp(_t723, "shake", 0.35)
	return true

func _f81(this_, a: Array, env):
	var v_o_447 = null
	v_o_447 = J.arg(a, 0)
	var _t729 = J.seq(J.gp(v_o_447, "ph"), "wait")
	var _t730 = (_t729 if _t729 else J.seq(J.gp(v_o_447, "ph"), "walk"))
	var _t731 = (_t730 if _t730 else J.seq(J.gp(v_o_447, "ph"), "walkHome"))
	var _t732 = (J.seq(J.gp(v_o_447, "f"), env["f"]) if _t731 else _t731)
	return ((absf(J.num(J.sub(J.gp(v_o_447, "x"), J.gp(env["g"], "x")))) < 150.0) if _t732 else _t732)

func _f82(this_, a: Array, env):
	var v_o_450 = null; var v_h_451 = null; var v_r_452 = null; var v_e_453 = null
	v_o_450 = J.arg(a, 0)
	var _t734 = J.gp(env["__p"]["S"], "riders")
	var _t735 = J.gp(env["__p"]["S"], "riders")
	J.mc(_t734, "splice", [J.mc(_t735, "indexOf", [v_o_450]), 1.0])
	env["got"] = J.num(env["got"]) + 1.0
	if J.seq(J.gp(v_o_450, "kind"), "guard"):
		v_h_451 = J.gp(v_o_450, "ref")
		var _t736 = (J.add("f", env["f"]) + "_l")
		J.sp(v_h_451, "node", _t736)
		J.sp(v_h_451, "to", null)
		J.sp(v_h_451, "p", 0.0)
		var _t737 = J.gp(v_o_450, "x")
		J.sp(v_h_451, "x", _t737)
		var _t738 = env["y"]
		J.sp(v_h_451, "y", _t738)
		J.sp(v_h_451, "state", "patrol")
		var _t739 = J.gp(env["g0"], "guards")
		J.mc(_t739, "push", [v_h_451])
		var _t740 = env["__p"]["line"]
		J.mc(env["__p"]["A"], "spook", [v_h_451, J.cl(_t740, null, ["gLand"])])
		return null
	v_r_452 = J.gp(v_o_450, "ref")
	J.sp(v_r_452, "state", "flee")
	var _t741 = (((-1.0) if J.cmp(J.gp(v_o_450, "x"), J.gp(env["g"], "x"), "<") else 1.0) * 160.0)
	J.sp(v_r_452, "vx", _t741)
	var _t742 = J.gp(v_o_450, "x")
	J.sp(v_r_452, "x", _t742)
	var _t743 = J.sub(env["y"], 16.0)
	J.sp(v_r_452, "y", _t743)
	var _t744 = J.gp(env["g0"], "res")
	J.mc(_t744, "push", [v_r_452])
	if J.t(J.gp(J.G.get("window"), "PPLFX")):
		J.mc(J.G.get("PPLFX"), "screamOn", [v_r_452])
	else:
		var _t745 = env["__p"]["sayR"]
		var _t746 = env["__p"]["line"]
		J.cl(_t745, null, [v_r_452, J.cl(_t746, null, ["bolt"])])
	J.sp(v_r_452, "sayT", 2.4)

func _f80(this_, a: Array, env):
	var v_n_439 = null; var v_c_443 = null; var v_e_454 = null
	var _s160 = {"__p": env, "g": null, "f": null, "y": null, "g0": null, "got": null}
	_s160["g"] = J.arg(a, 0)
	var _t726 = (not J.t(_s160["__p"]["S"]))
	var _t727 = (_t726 if _t726 else (not J.t(J.gp(_s160["__p"]["S"], "on"))))
	if (_t727 if _t727 else (not J.t(_s160["g"]))):
		return 0.0
	v_n_439 = J.gp(J.gp(J.cl(_s160["__p"]["G"], null, []), "nodes"), J.gp(_s160["g"], "node"))
	if (not J.t(v_n_439)):
		return 0.0
	_s160["f"] = J.gp(v_n_439, "f")
	_s160["y"] = J.mc(_s160["__p"]["A"], "fy", [_s160["f"]])
	_s160["g0"] = J.cl(_s160["__p"]["G"], null, [])
	v_c_443 = J.cl(_s160["__p"]["col"], null, [])
	_s160["got"] = 0.0
	var _t728 = J.gp(_s160["__p"]["S"], "riders")
	var _t733 = J.mc(_t728, "filter", [Callable(self, "_f81").bind(_s160)])
	J.mc(_t733, "forEach", [Callable(self, "_f82").bind(_s160)])
	if J.t(_s160["got"]):
		if J.t(J.gp(_s160["__p"]["A"], "addFear")):
			J.mc(_s160["__p"]["A"], "addFear", [J.mul(10.0, _s160["got"]), J.gp(_s160["g"], "x"), J.sub(_s160["y"], 110.0)])
		var _t747 = _s160["g"]
		J.sp(_t747, "dir", 1.0)
		var _t748 = _s160["__p"]["log"]
		J.cl(_t748, null, ["scareWait"])
	return _s160["got"]

func _f86(this_, a: Array, env):
	var v_o_490 = null
	v_o_490 = J.arg(a, 0)
	return J.seq(J.gp(v_o_490, "kind"), "res")

func _f87(this_, a: Array, env):
	var v_a_493 = null; var v_o_494 = null
	v_a_493 = J.arg(a, 0)
	var _t785 = J.sub(J.gp(v_a_493, "t"), env["dt"])
	J.sp(v_a_493, "t", _t785)
	if J.cmp(J.gp(v_a_493, "t"), 0.0, ">"):
		return true
	v_o_494 = J.gp(v_a_493, "o")
	J.sp(v_o_494, "ph", "wait")
	J.sp(v_o_494, "f", 1.0)
	var _t786 = J.gp(J.gp(J.gp(v_o_494, "ref"), "unit"), "f")
	J.sp(v_o_494, "dest", _t786)
	J.sp(v_o_494, "trip", "back")
	var _t787 = J.sub(J.gp(J.cl(env["__p"]["col"], null, []), "cx"), 46.0)
	J.sp(v_o_494, "x", _t787)
	J.sp(v_o_494, "mood", "ok")
	J.sp(v_o_494, "fear", 0.0)
	var _t788 = env["__p"]["sayR"]
	var _t789 = env["__p"]["line"]
	J.cl(_t788, null, [v_o_494, J.cl(_t789, null, ["back"])])
	var _t790 = J.gp(env["__p"]["S"], "riders")
	J.mc(_t790, "push", [v_o_494])
	return false

func _f88(this_, a: Array, env):
	var v_m_497 = null; var v_h_498 = null; var v_nid_499 = null; var v_n_500 = null
	v_m_497 = J.arg(a, 0)
	var _t794 = J.sub(J.gp(v_m_497, "t"), env["dt"])
	J.sp(v_m_497, "t", _t794)
	if J.cmp(J.gp(v_m_497, "t"), 0.0, ">"):
		return true
	v_h_498 = J.gp(v_m_497, "h")
	v_nid_499 = ("f1_s" if J.t(J.gp(J.gp(env["g0"], "nodes"), "f1_s")) else "f0_s")
	v_n_500 = J.gp(J.gp(env["g0"], "nodes"), v_nid_499)
	J.sp(v_h_498, "node", v_nid_499)
	J.sp(v_h_498, "to", null)
	J.sp(v_h_498, "p", 0.0)
	var _t795 = J.gp(v_n_500, "x")
	J.sp(v_h_498, "x", _t795)
	var _t796 = J.gp(v_n_500, "y")
	J.sp(v_h_498, "y", _t796)
	J.sp(v_h_498, "state", "patrol")
	J.sp(v_h_498, "wait", 1.0)
	var _t797 = env["__p"]["line"]
	var _t798 = J.cl(_t797, null, ["gBack"])
	J.sp(v_h_498, "say", _t798)
	J.sp(v_h_498, "sayT", 2.6)
	J.sp(v_h_498, "liftCd", 1.0)
	var _t799 = J.gp(env["g0"], "guards")
	J.mc(_t799, "push", [v_h_498])
	return false

func _f90(this_, a: Array, env):
	var v_p_510 = null
	v_p_510 = J.arg(a, 0)
	var _t808 = J.seq(J.gp(v_p_510, "ph"), "wait")
	return (J.seq(J.gp(v_p_510, "f"), J.gp(env["o"], "f")) if _t808 else _t808)

func _f89(this_, a: Array, env):
	var v_slot_504 = null; var v_tx_505 = null; var v_r_506 = null; var v_hx_507 = null
	var _s184 = {"__p": env, "o": null}
	_s184["o"] = J.arg(a, 0)
	var _t802 = _s184["o"]
	var _t803 = J.gp(_s184["o"], "sayT")
	var _t804 = J.gp(_s184["o"], "sayT")
	var _t805 = J.max_([0.0, J.sub((_t804 if J.t(_t804) else 0.0), _s184["__p"]["dt"])])
	J.sp(_t802, "sayT", _t805)
	if J.cmp(J.gp(_s184["o"], "sayT"), 0.0, "<="):
		var _t806 = _s184["o"]
		J.sp(_t806, "say", null)
	if J.seq(J.gp(_s184["o"], "ph"), "walk"):
		var _t807 = J.gp(_s184["__p"]["__p"]["S"], "riders")
		v_slot_504 = J.len(J.mc(_t807, "filter", [Callable(self, "_f90").bind(_s184)]))
		v_tx_505 = (J.sub(J.gp(_s184["__p"]["c"], "cx"), 44.0) - J.mul(v_slot_504, 16.0))
		var _t809 = _s184["o"]
		var _t810 = J.add(J.gp(_t809, "x"), (signf(J.num(J.sub(v_tx_505, J.gp(_s184["o"], "x")))) * J.min_([absf(J.num(J.sub(v_tx_505, J.gp(_s184["o"], "x")))), J.mul((36.0 if J.seq(J.gp(_s184["o"], "kind"), "guard") else 62.0), _s184["__p"]["dt"])])))
		J.sp(_t809, "x", _t810)
		if (absf(J.num(J.sub(v_tx_505, J.gp(_s184["o"], "x")))) < 1.0):
			var _t811 = _s184["o"]
			J.sp(_t811, "ph", "wait")
			var _t812 = _s184["o"]
			J.sp(_t812, "waitT", 0.0)
	else:
		if J.seq(J.gp(_s184["o"], "ph"), "wait"):
			var _t813 = _s184["o"]
			var _t814 = J.gp(_s184["o"], "waitT")
			var _t815 = J.add((_t814 if J.t(_t814) else 0.0), _s184["__p"]["dt"])
			J.sp(_t813, "waitT", _t815)
			var _t816 = J.cmp(J.gp(_s184["o"], "waitT"), 7.0, ">")
			if ((not J.t(J.gp(_s184["o"], "said"))) if _t816 else _t816):
				var _t817 = _s184["o"]
				J.sp(_t817, "said", 1.0)
				var _t818 = _s184["__p"]["__p"]["sayR"]
				var _t820 = _s184["o"]
				var _t819 = _s184["__p"]["__p"]["line"]
				J.cl(_t818, null, [_t820, J.cl(_t819, null, ["wait"])])
		else:
			if J.seq(J.gp(_s184["o"], "ph"), "walkHome"):
				v_r_506 = J.gp(_s184["o"], "ref")
				v_hx_507 = J.add(J.gp(J.gp(J.gp(v_r_506, "unit"), "rx"), 0.0), (J.sub(J.gp(J.gp(J.gp(v_r_506, "unit"), "rx"), 1.0), J.gp(J.gp(J.gp(v_r_506, "unit"), "rx"), 0.0)) * 0.42))
				var _t821 = _s184["o"]
				var _t822 = J.add(J.gp(_t821, "x"), (signf(J.num(J.sub(v_hx_507, J.gp(_s184["o"], "x")))) * J.min_([absf(J.num(J.sub(v_hx_507, J.gp(_s184["o"], "x")))), J.mul(62.0, _s184["__p"]["dt"])])))
				J.sp(_t821, "x", _t822)
				if (absf(J.num(J.sub(v_hx_507, J.gp(_s184["o"], "x")))) < 1.0):
					var _t823 = J.gp(_s184["__p"]["__p"]["S"], "riders")
					var _t824 = J.gp(_s184["__p"]["__p"]["S"], "riders")
					J.mc(_t823, "splice", [J.mc(_t824, "indexOf", [_s184["o"]]), 1.0])
					J.sp(v_r_506, "x", v_hx_507)
					var _t825 = J.sub(J.mc(_s184["__p"]["__p"]["A"], "fy", [J.gp(J.gp(v_r_506, "unit"), "f")]), 16.0)
					J.sp(v_r_506, "y", _t825)
					J.sp(v_r_506, "state", "home")
					var _t826 = J.gp(v_r_506, "fear")
					var _t827 = J.gp(v_r_506, "fear")
					var _t828 = J.max_([0.0, (_t827 if J.t(_t827) else 0.0)])
					J.sp(v_r_506, "fear", _t828)
					var _t829 = J.gp(_s184["__p"]["g0"], "res")
					J.mc(_t829, "push", [v_r_506])
					if J.t(J.gp(v_r_506, "unit")):
						var _t830 = J.gp(v_r_506, "unit")
						J.sp(_t830, "doorOpen", 2.0)

func _f91(this_, a: Array, env):
	var v_o_513 = null
	v_o_513 = J.arg(a, 0)
	var _t922 = J.seq(J.gp(v_o_513, "ph"), "ride")
	var _t923 = (J.seq(J.gp(v_o_513, "mood"), "bolt") if _t922 else _t922)
	if ((not J.t(J.gp(v_o_513, "boltSaid"))) if _t923 else _t923):
		J.sp(v_o_513, "boltSaid", 1.0)

func _f85(this_, a: Array, env):
	var v_k_466 = null; var v_bf_467 = null; var v_q_468 = null; var v_g_470 = null; var v_gw_471 = null; var v_nw_472 = null; var v_t_473 = null; var v_w_474 = null; var v_t2_475 = null; var v_d_476 = null; var v_ad_477 = null; var v_vm_478 = null; var v_mv_479 = null; var v_t3_480 = null; var v_dd_481 = null; var v_st_482 = null; var v_nf_483 = null; var v_gw2_484 = null; var v_gw3_485 = null; var v_fN_486 = null; var v_df_487 = null
	var _s173 = {"__p": env, "dt": null, "g0": null, "c": null}
	_s173["dt"] = J.arg(a, 0)
	if (not J.seq(J.cl(_s173["__p"]["G"], null, []), _s173["__p"]["lastG"])):
		J.cl(_s173["__p"]["reset"], null, [])
	var _t751 = (not J.t(_s173["__p"]["S"]))
	var _t752 = (_t751 if _t751 else (not J.t(J.gp(_s173["__p"]["S"], "on"))))
	if (_t752 if _t752 else (not J.t(J.cl(_s173["__p"]["G"], null, [])))):
		return null
	_s173["g0"] = J.cl(_s173["__p"]["G"], null, [])
	var _t753 = _s173["__p"]["S"]
	var _t754 = J.add(J.gp(_t753, "t"), _s173["dt"])
	J.sp(_t753, "t", _t754)
	for _t755 in J.keys(J.gp(_s173["__p"]["S"], "cd")):
		v_k_466 = _t755
		var _t756 = J.gp(_s173["__p"]["S"], "cd")
		var _t757 = J.max_([0.0, J.sub(J.gp(J.gp(_s173["__p"]["S"], "cd"), v_k_466), _s173["dt"])])
		J.sp(_t756, v_k_466, _t757)
	var _t758 = J.gp(_s173["__p"]["S"], "btnsUntil")
	if J.t((J.cmp(J.gp(_s173["__p"]["S"], "t"), J.gp(_s173["__p"]["S"], "btnsUntil"), ">=") if J.t(_t758) else _t758)):
		var _t759 = _s173["__p"]["S"]
		J.sp(_t759, "btnsUntil", 0.0)
		var _t761 = J.gp(_s173["__p"]["S"], "btnsSet")
		for _t760 in J.keys((_t761 if J.t(_t761) else {})):
			v_bf_467 = _t760
			J.del(J.gp(_s173["__p"]["S"], "stops"), v_bf_467)
			J.del(J.gp(_s173["__p"]["S"], "lit"), v_bf_467)
		var _t762 = _s173["__p"]["S"]
		var _t763 = {}
		J.sp(_t762, "btnsSet", _t763)
		var _t764 = _s173["__p"]["log"]
		J.cl(_t764, null, ["btnsReset"])
	for _t765 in J.keys(J.gp(_s173["__p"]["S"], "fx")):
		v_q_468 = _t765
		var _t766 = J.gp(_s173["__p"]["S"], "fx")
		var _t767 = J.max_([0.0, J.sub(J.gp(J.gp(_s173["__p"]["S"], "fx"), v_q_468), _s173["dt"])])
		J.sp(_t766, v_q_468, _t767)
	var _t768 = _s173["__p"]["S"]
	var _t769 = J.max_([0.0, J.sub(J.gp(_s173["__p"]["S"], "shake"), _s173["dt"])])
	J.sp(_t768, "shake", _t769)
	var _t770 = _s173["__p"]["S"]
	var _t771 = J.gp(_s173["__p"]["S"], "msgT")
	var _t772 = J.gp(_s173["__p"]["S"], "msgT")
	var _t773 = J.max_([0.0, J.sub((_t772 if J.t(_t772) else 0.0), _s173["dt"])])
	J.sp(_t770, "msgT", _t773)
	var _t774 = _s173["__p"]["S"]
	var _t775 = J.sub(J.gp(_t774, "spawnT"), _s173["dt"])
	J.sp(_t774, "spawnT", _t775)
	if J.cmp(J.gp(_s173["__p"]["S"], "spawnT"), 0.0, "<="):
		var _t776 = _s173["__p"]["S"]
		var _t777 = (11.0 + J.mul(J.cl(_s173["__p"]["rnd"], null, []), 9.0))
		J.sp(_t776, "spawnT", _t777)
		var _t778 = J.gp(_s173["__p"]["S"], "riders")
		if (J.len(J.mc(_t778, "filter", [Callable(self, "_f86").bind(_s173)])) < 5.0):
			J.cl(_s173["__p"]["spawnResident"], null, [])
	var _t779 = _s173["__p"]["S"]
	var _t780 = J.sub(J.gp(_t779, "gSpawnT"), _s173["dt"])
	J.sp(_t779, "gSpawnT", _t780)
	if J.cmp(J.gp(_s173["__p"]["S"], "gSpawnT"), 0.0, "<="):
		var _t781 = _s173["__p"]["S"]
		var _t782 = (18.0 + J.mul(J.cl(_s173["__p"]["rnd"], null, []), 10.0))
		J.sp(_t781, "gSpawnT", _t782)
		J.cl(_s173["__p"]["spawnGuard"], null, [])
	var _t783 = _s173["__p"]["S"]
	var _t784 = J.gp(_s173["__p"]["S"], "away")
	var _t791 = J.mc(_t784, "filter", [Callable(self, "_f87").bind(_s173)])
	J.sp(_t783, "away", _t791)
	var _t792 = _s173["__p"]["S"]
	var _t793 = J.gp(_s173["__p"]["S"], "mroom")
	var _t800 = J.mc(_t793, "filter", [Callable(self, "_f88").bind(_s173)])
	J.sp(_t792, "mroom", _t800)
	_s173["c"] = J.cl(_s173["__p"]["col"], null, [])
	var _t801 = J.gp(_s173["__p"]["S"], "riders")
	J.mc(_t801, "forEach", [Callable(self, "_f89").bind(_s173)])
	v_g_470 = J.cl(_s173["__p"]["ghost"], null, [])
	var _t832 = v_g_470
	if J.t(_t832):
		var _t831 = J.gp(v_g_470, "out")
		_t832 = (_t831 if J.t(_t831) else J.gp(v_g_470, "home"))
	if J.t(_t832):
		var _t833 = _s173["__p"]["S"]
		J.sp(_t833, "gi", null)
		v_g_470 = null
		J.cl(_s173["__p"]["hideUI"], null, [])
	if (not J.leq(J.gp(_s173["__p"]["S"], "gWait"), null)):
		v_gw_471 = J.gp(J.gp(_s173["g0"], "gh"), J.gp(_s173["__p"]["S"], "gWait"))
		v_nw_472 = (J.gp(J.gp(_s173["g0"], "nodes"), J.gp(v_gw_471, "node")) if J.t(v_gw_471) else v_gw_471)
		var _t834 = (not J.t(v_gw_471))
		var _t835 = (_t834 if _t834 else J.gp(v_gw_471, "to"))
		var _t836 = (_t835 if J.t(_t835) else (not J.t(v_nw_472)))
		var _t837 = (_t836 if J.t(_t836) else (not J.seq(J.gp(v_nw_472, "kind"), "lift")))
		if J.t((_t837 if J.t(_t837) else (not J.seq(J.gp(v_nw_472, "f"), J.gp(_s173["__p"]["S"], "gCall"))))):
			var _t838 = _s173["__p"]["S"]
			J.sp(_t838, "gCall", null)
			var _t839 = _s173["__p"]["S"]
			J.sp(_t839, "gWait", null)
	var _t840 = J.gp(_s173["__p"]["S"], "st")
	var _t841 = -1
	var _t842 = false
	if _t841 == -1 and J.seq(_t840, "idle"): _t841 = 0
	if _t841 == -1 and J.seq(_t840, "move"): _t841 = 1
	if _t841 == -1 and J.seq(_t840, "opening"): _t841 = 2
	if _t841 == -1 and J.seq(_t840, "open"): _t841 = 3
	if _t841 == -1 and J.seq(_t840, "closing"): _t841 = 4
	if _t841 == -1 and J.seq(_t840, "closed"): _t841 = 5
	if _t841 == -1 and J.seq(_t840, "stuckMove"): _t841 = 6
	if _t841 == -1 and J.seq(_t840, "stuck"): _t841 = 7
	if _t841 == -1 and J.seq(_t840, "unstick"): _t841 = 8
	while true:
		if _t841 <= 0 and _t841 >= 0:
			v_t_473 = J.cl(_s173["__p"]["chooseTarget"], null, [])
			if (not J.leq(v_t_473, null)):
				if (absf(J.num(J.sub(v_t_473, J.gp(_s173["__p"]["S"], "pos")))) < 0.01):
					J.cl(_s173["__p"]["arrive"], null, [])
				else:
					var _t843 = _s173["__p"]["startMove"]
					J.cl(_t843, null, [v_t_473])
			break
		if _t841 <= 1 and _t841 >= 0:
			v_w_474 = J.cl(_s173["__p"]["wanted"], null, [])
			v_t2_475 = J.cl(_s173["__p"]["chooseTarget"], null, [])
			var _t844 = (not J.leq(v_t2_475, null))
			var _t845 = (J.cmp(J.gp(_s173["__p"]["S"], "dir"), 0.0, ">") if _t844 else _t844)
			var _t846 = (J.cmp(v_t2_475, J.gp(_s173["__p"]["S"], "pos"), ">") if _t845 else _t845)
			if (J.cmp(v_t2_475, J.gp(_s173["__p"]["S"], "target"), "<") if _t846 else _t846):
				var _t847 = _s173["__p"]["S"]
				J.sp(_t847, "target", v_t2_475)
			var _t848 = (not J.leq(v_t2_475, null))
			var _t849 = (J.cmp(J.gp(_s173["__p"]["S"], "dir"), 0.0, "<") if _t848 else _t848)
			var _t850 = (J.cmp(v_t2_475, J.gp(_s173["__p"]["S"], "pos"), "<") if _t849 else _t849)
			if (J.cmp(v_t2_475, J.gp(_s173["__p"]["S"], "target"), ">") if _t850 else _t850):
				var _t851 = _s173["__p"]["S"]
				J.sp(_t851, "target", v_t2_475)
			v_d_476 = J.sub(J.gp(_s173["__p"]["S"], "target"), J.gp(_s173["__p"]["S"], "pos"))
			v_ad_477 = absf(J.num(v_d_476))
			v_vm_478 = J.min_([_s173["__p"]["VMAX"], (sqrt(J.num(J.mul(J.mul(2.0, _s173["__p"]["ACC"]), v_ad_477))) + 0.05)])
			var _t852 = _s173["__p"]["S"]
			var _t853 = J.min_([v_vm_478, J.add(J.gp(_s173["__p"]["S"], "v"), J.mul(_s173["__p"]["ACC"], _s173["dt"]))])
			J.sp(_t852, "v", _t853)
			v_mv_479 = J.min_([v_ad_477, J.mul(J.gp(_s173["__p"]["S"], "v"), _s173["dt"])])
			var _t854 = _s173["__p"]["S"]
			var _t855 = J.add(J.gp(_t854, "pos"), J.mul(signf(J.num(v_d_476)), v_mv_479))
			J.sp(_t854, "pos", _t855)
			if J.cmp(J.cl(_s173["__p"]["rnd"], null, []), J.mul(_s173["dt"], 0.5), "<"):
				var _t856 = J.gp(_s173["__p"]["S"], "fx")
				J.sp(_t856, "flick", 0.18)
			if (J.sub(v_ad_477, v_mv_479) <= 0.002):
				var _t857 = _s173["__p"]["S"]
				var _t858 = J.gp(_s173["__p"]["S"], "target")
				J.sp(_t857, "pos", _t858)
				J.mc(_s173["__p"]["SND"], "hum", [false])
				J.cl(_s173["__p"]["arrive"], null, [])
			break
		if _t841 <= 2 and _t841 >= 0:
			var _t859 = _s173["__p"]["S"]
			var _t860 = J.min_([1.0, J.add(J.gp(_s173["__p"]["S"], "door"), J.div(_s173["dt"], _s173["__p"]["DOOR_T"]))])
			J.sp(_t859, "door", _t860)
			if J.cmp(J.gp(_s173["__p"]["S"], "door"), 1.0, ">="):
				var _t861 = _s173["__p"]["S"]
				J.sp(_t861, "st", "open")
				var _t862 = _s173["__p"]["S"]
				var _t863 = J.max_([J.gp(_s173["__p"]["S"], "hold"), _s173["__p"]["HOLD"]])
				J.sp(_t862, "hold", _t863)
			break
		if _t841 <= 3 and _t841 >= 0:
			var _t864 = _s173["__p"]["boardAndExit"]
			J.cl(_t864, null, [_s173["dt"]])
			var _t865 = _s173["__p"]["S"]
			var _t866 = J.sub(J.gp(_t865, "hold"), _s173["dt"])
			J.sp(_t865, "hold", _t866)
			if J.cmp(J.gp(J.gp(_s173["__p"]["S"], "fx"), "over"), 0.0, ">"):
				var _t867 = _s173["__p"]["S"]
				var _t868 = J.max_([J.gp(_s173["__p"]["S"], "hold"), 0.3])
				J.sp(_t867, "hold", _t868)
			if J.cmp(J.gp(_s173["__p"]["S"], "hold"), 0.0, "<="):
				var _t869 = _s173["__p"]["S"]
				J.sp(_t869, "st", "closing")
				J.mc(_s173["__p"]["SND"], "door", [])
			break
		if _t841 <= 4 and _t841 >= 0:
			var _t870 = _s173["__p"]["S"]
			var _t871 = J.max_([0.0, J.sub(J.gp(_s173["__p"]["S"], "door"), J.div(_s173["dt"], _s173["__p"]["DOOR_T"]))])
			J.sp(_t870, "door", _t871)
			if J.cmp(J.gp(_s173["__p"]["S"], "door"), 0.0, "<="):
				var _t872 = _s173["__p"]["S"]
				J.sp(_t872, "st", "closed")
			break
		if _t841 <= 5 and _t841 >= 0:
			v_t3_480 = J.cl(_s173["__p"]["chooseTarget"], null, [])
			var _t873 = (not J.leq(v_t3_480, null))
			if ((absf(J.num(J.sub(v_t3_480, J.gp(_s173["__p"]["S"], "pos")))) > 0.01) if _t873 else _t873):
				var _t874 = _s173["__p"]["startMove"]
				J.cl(_t874, null, [v_t3_480])
			else:
				if (not J.leq(v_t3_480, null)):
					var _t875 = _s173["__p"]["S"]
					J.sp(_t875, "st", "opening")
					J.mc(_s173["__p"]["SND"], "door", [])
				else:
					var _t876 = _s173["__p"]["S"]
					J.sp(_t876, "st", "idle")
			break
		if _t841 <= 6 and _t841 >= 0:
			v_dd_481 = J.sub(J.gp(_s173["__p"]["S"], "stuckTo"), J.gp(_s173["__p"]["S"], "pos"))
			v_st_482 = J.min_([absf(J.num(v_dd_481)), J.mul(1.3, _s173["dt"])])
			var _t877 = _s173["__p"]["S"]
			var _t878 = J.add(J.gp(_t877, "pos"), J.mul(signf(J.num(v_dd_481)), v_st_482))
			J.sp(_t877, "pos", _t878)
			if (absf(J.num(v_dd_481)) <= 0.003):
				var _t879 = _s173["__p"]["S"]
				var _t880 = J.gp(_s173["__p"]["S"], "stuckTo")
				J.sp(_t879, "pos", _t880)
				var _t881 = _s173["__p"]["S"]
				J.sp(_t881, "st", "stuck")
				J.mc(_s173["__p"]["SND"], "hum", [false])
				J.mc(_s173["__p"]["SND"], "clunk", [])
				var _t882 = _s173["__p"]["S"]
				J.sp(_t882, "shake", 0.6)
			break
		if _t841 <= 7 and _t841 >= 0:
			var _t883 = _s173["__p"]["S"]
			var _t884 = J.min_([0.45, J.add(J.gp(_s173["__p"]["S"], "door"), J.div(_s173["dt"], _s173["__p"]["DOOR_T"]))])
			J.sp(_t883, "door", _t884)
			var _t885 = _s173["__p"]["S"]
			var _t886 = J.sub(J.gp(_t885, "stuckT"), _s173["dt"])
			J.sp(_t885, "stuckT", _t886)
			if J.cmp(J.gp(_s173["__p"]["S"], "stuckT"), 0.0, "<="):
				var _t887 = _s173["__p"]["S"]
				J.sp(_t887, "st", "unstick")
				J.mc(_s173["__p"]["SND"], "door", [])
			break
		if _t841 <= 8 and _t841 >= 0:
			var _t888 = _s173["__p"]["S"]
			var _t889 = J.max_([0.0, J.sub(J.gp(_s173["__p"]["S"], "door"), J.div(_s173["dt"], _s173["__p"]["DOOR_T"]))])
			J.sp(_t888, "door", _t889)
			if J.cmp(J.gp(_s173["__p"]["S"], "door"), 0.0, "<="):
				v_nf_483 = (ceil(J.num(J.gp(_s173["__p"]["S"], "pos"))) if J.cmp(J.gp(_s173["__p"]["S"], "dir"), 0.0, ">=") else floor(J.num(J.gp(_s173["__p"]["S"], "pos"))))
				var _t890 = J.max_([0.0, J.min_([J.cl(_s173["__p"]["top"], null, []), v_nf_483])])
				v_nf_483 = _t890
				var _t891 = J.gp(_s173["__p"]["S"], "stops")
				J.sp(_t891, v_nf_483, 1.0)
				var _t892 = _s173["__p"]["startMove"]
				J.cl(_t892, null, [v_nf_483])
				var _t893 = _s173["__p"]["S"]
				J.sp(_t893, "target", v_nf_483)
			break
		break
	var _t894 = (not J.leq(J.gp(_s173["__p"]["S"], "gWait"), null))
	if (J.leq(J.gp(_s173["__p"]["S"], "gCall"), null) if _t894 else _t894):
		v_gw2_484 = J.gp(J.gp(_s173["g0"], "gh"), J.gp(_s173["__p"]["S"], "gWait"))
		var _t896 = (J.cl(_s173["__p"]["atFloor"], null, []) if J.t(v_gw2_484) else v_gw2_484)
		if J.t(_t896):
			var _t895 = J.seq(J.gp(_s173["__p"]["S"], "st"), "opening")
			_t896 = (_t895 if _t895 else J.seq(J.gp(_s173["__p"]["S"], "st"), "open"))
		if J.t((J.seq(J.gp(J.gp(J.gp(_s173["g0"], "nodes"), J.gp(v_gw2_484, "node")), "f"), J.cl(_s173["__p"]["cabF"], null, [])) if J.t(_t896) else _t896)):
			var _t897 = _s173["__p"]["doEnter"]
			J.cl(_t897, null, [v_gw2_484, J.cl(_s173["__p"]["cabF"], null, [])])
	var _t898 = (not J.leq(J.gp(_s173["__p"]["S"], "gWait"), null))
	var _t899 = ((not J.leq(J.gp(_s173["__p"]["S"], "gCall"), null)) if _t898 else _t898)
	var _t900 = (J.cl(_s173["__p"]["atFloor"], null, []) if _t899 else _t899)
	var _t902 = (J.seq(J.cl(_s173["__p"]["cabF"], null, []), J.gp(_s173["__p"]["S"], "gCall")) if J.t(_t900) else _t900)
	if J.t(_t902):
		var _t901 = J.seq(J.gp(_s173["__p"]["S"], "st"), "opening")
		_t902 = (_t901 if _t901 else J.seq(J.gp(_s173["__p"]["S"], "st"), "open"))
	if J.t(_t902):
		v_gw3_485 = J.gp(J.gp(_s173["g0"], "gh"), J.gp(_s173["__p"]["S"], "gWait"))
		var _t903 = _s173["__p"]["doEnter"]
		J.cl(_t903, null, [v_gw3_485, J.cl(_s173["__p"]["cabF"], null, [])])
	var _t904 = J.cl(_s173["__p"]["ghost"], null, [])
	v_g_470 = _t904
	if J.t(v_g_470):
		J.sp(v_g_470, "to", null)
		J.sp(v_g_470, "auto", null)
		J.sp(v_g_470, "autoS", null)
		v_fN_486 = J.max_([0.0, J.min_([J.cl(_s173["__p"]["top"], null, []), J.round(J.num(J.gp(_s173["__p"]["S"], "pos")))])])
		var _t905 = (J.add("f", v_fN_486) + "_l")
		J.sp(v_g_470, "node", _t905)
		var _t906 = J.gp(_s173["c"], "cx")
		J.sp(v_g_470, "x", _t906)
		var _t907 = _s173["__p"]["fyf"]
		var _t908 = J.cl(_t907, null, [J.gp(_s173["__p"]["S"], "pos")])
		J.sp(v_g_470, "y", _t908)
		var _t909 = J.cmp(J.gp(_s173["__p"]["S"], "door"), 0.5, "<")
		if (_t909 if _t909 else (not J.t(J.cl(_s173["__p"]["atFloor"], null, [])))):
			var _t910 = J.gp(v_g_470, "inv")
			var _t911 = J.gp(v_g_470, "inv")
			var _t912 = J.max_([(_t911 if J.t(_t911) else 0.0), 0.15])
			J.sp(v_g_470, "inv", _t912)
		J.sp(v_g_470, "taskP", 0.0)
	for _t913 in J.keys(J.gp(_s173["__p"]["S"], "dfx")):
		v_df_487 = _t913
		var _t914 = J.gp(J.gp(_s173["__p"]["S"], "dfx"), v_df_487)
		var _t915 = J.add(J.gp(_t914, "t"), _s173["dt"])
		J.sp(_t914, "t", _t915)
		if J.cmp(J.gp(J.gp(J.gp(_s173["__p"]["S"], "dfx"), v_df_487), "t"), 1.6, ">"):
			J.del(J.gp(_s173["__p"]["S"], "dfx"), v_df_487)
	if (not J.seq(J.gp(_s173["__p"]["S"], "st"), J.gp(_s173["__p"]["S"], "prevSt"))):
		var _t916 = J.seq(J.gp(_s173["__p"]["S"], "st"), "opening")
		if J.t((J.cl(_s173["__p"]["atFloor"], null, []) if _t916 else _t916)):
			var _t917 = _s173["__p"]["dingFx"]
			J.cl(_t917, null, [J.cl(_s173["__p"]["cabF"], null, []), true])
		var _t918 = _s173["__p"]["S"]
		var _t919 = J.gp(_s173["__p"]["S"], "st")
		J.sp(_t918, "prevSt", _t919)
	var _t920 = J.seq(J.gp(_s173["__p"]["S"], "st"), "stuck")
	if (_t920 if _t920 else J.seq(J.gp(_s173["__p"]["S"], "st"), "stuckMove")):
		var _t921 = J.gp(_s173["__p"]["S"], "riders")
		J.mc(_t921, "forEach", [Callable(self, "_f91").bind(_s173)])

func _f116(this_, a: Array, env):
	var v_t_681 = null
	v_t_681 = J.arg(a, 0)
	var _t929 = env["CRF"]
	var _t930 = env["crFrame"]
	var _t931 = J.cl(_t930, null, [v_t_681, false])
	J.sp(_t929, v_t_681, _t931)
	var _t932 = env["CRF"]
	var _t933 = J.add(v_t_681, "P")
	var _t934 = env["crFrame"]
	var _t935 = J.cl(_t934, null, [v_t_681, true])
	J.sp(_t932, _t933, _t935)

func _f119(this_, a: Array, env):
	var v_e_690 = null
	v_e_690 = J.arg(a, 0)
	J.mc(v_e_690, "stopPropagation", [])

func _f118(this_, a: Array, env):
	var v_ev_687 = null
	v_ev_687 = J.arg(a, 0)
	J.mc(env["ui"], "addEventListener", [v_ev_687, Callable(self, "_f119").bind(env), {"passive": true}])

func _f140(this_, a: Array, env):
	var _t947 = ((not J.leq(J.gp(env["S"], "gi"), null)) if J.t(env["S"]) else env["S"])
	if J.t(_t947):
		var _t946 = J.gp(env["ui"], "classList")
		_t947 = J.mc(_t946, "contains", ["on"])
	return (J.gp(env["L"], "_band") if J.t((J.gp(env["L"], "_band") if J.t(_t947) else _t947)) else null)

func _f154(this_, a: Array, env):
	var v_o_889 = null
	v_o_889 = J.arg(a, 0)
	var _t960 = J.gp(v_o_889, "kind")
	var _t961 = J.gp(v_o_889, "ph")
	var _t962 = J.gp(v_o_889, "f")
	var _t963 = J.gp(v_o_889, "dest")
	var _t964 = J.gp(v_o_889, "mood")
	var _t959 = J.gp(v_o_889, "fear")
	return {"kind": _t960, "ph": _t961, "f": _t962, "dest": _t963, "mood": _t964, "fear": J.round(J.num((_t959 if J.t(_t959) else 0.0))), "say": J.gp(v_o_889, "say")}

func _f153(this_, a: Array, env):
	if (not J.t(env["S"])):
		return null
	var _t950 = J.S_Object_("keys", [J.gp(env["S"], "dfx")])
	var _t952 = J.mc(_t950, "map", [J.G.get("Number")])
	var _t953 = J.gp(env["S"], "on")
	var _t954 = J.gp(env["S"], "pos")
	var _t955 = J.gp(env["S"], "st")
	var _t956 = J.gp(env["S"], "door")
	var _t957 = J.gp(env["S"], "dir")
	var _t951 = J.S_Object_("keys", [J.gp(env["S"], "stops")])
	var _t965 = J.mc(_t951, "map", [J.G.get("Number")])
	var _t966 = J.gp(env["S"], "gi")
	var _t967 = J.gp(env["S"], "gCall")
	var _t968 = J.S_JSON_("parse", [J.S_JSON_("stringify", [J.gp(env["S"], "cd")])])
	var _t969 = J.S_JSON_("parse", [J.S_JSON_("stringify", [J.gp(env["S"], "fx")])])
	var _t958 = J.gp(env["S"], "riders")
	var _t971 = J.mc(_t958, "map", [Callable(self, "_f154").bind(env)])
	var _t972 = J.len(J.gp(env["S"], "mroom"))
	var _t973 = J.len(J.gp(env["S"], "away"))
	var _t970 = J.gp(env["S"], "log")
	var _t975 = J.mc(_t970, "slice", [(-30.0)])
	var _t974 = J.gp(env["L"], "_err")
	return {"dfx": _t952, "on": _t953, "pos": _t954, "st": _t955, "door": _t956, "dir": _t957, "stops": _t965, "gi": _t966, "gCall": _t967, "cd": _t968, "fx": _t969, "riders": _t971, "mroom": _t972, "away": _t973, "log": _t975, "err": (_t974 if J.t(_t974) else null), "top": J.cl(env["top"], null, [])}

func _f156(this_, a: Array, env):
	var v_h_901 = null
	v_h_901 = J.arg(a, 0)
	var _t979 = J.seq(J.gp(v_h_901, "kind"), "guard")
	return ((not J.seq(J.gp(v_h_901, "state"), "gone")) if _t979 else _t979)

func _f157(this_, a: Array, env):
	var v_r_904 = null
	v_r_904 = J.arg(a, 0)
	var _t983 = J.seq(J.gp(v_r_904, "state"), "home")
	var _t984 = (J.gp(v_r_904, "unit") if _t983 else _t983)
	return (J.seq(J.gp(J.gp(v_r_904, "unit"), "f"), env["f"]) if J.t(_t984) else _t984)

func _f158(this_, a: Array, env):
	var v_r_907 = null
	v_r_907 = J.arg(a, 0)
	var _t986 = J.seq(J.gp(v_r_907, "state"), "home")
	var _t987 = (J.gp(v_r_907, "unit") if _t986 else _t986)
	return (J.cmp(J.gp(J.gp(v_r_907, "unit"), "f"), 2.0, ">=") if J.t(_t987) else _t987)

func _f155(this_, a: Array, env):
	var v_kind_892 = null; var v_dest_894 = null; var v_g0_895 = null; var v_o_896 = null; var v_h_897 = null; var v_r_898 = null
	var _s363 = {"__p": env, "f": null}
	v_kind_892 = J.arg(a, 0)
	_s363["f"] = J.arg(a, 1)
	v_dest_894 = J.arg(a, 2)
	if (not J.seq(J.cl(_s363["__p"]["G"], null, []), _s363["__p"]["lastG"])):
		J.cl(_s363["__p"]["reset"], null, [])
	v_g0_895 = J.cl(_s363["__p"]["G"], null, [])
	if J.seq(v_kind_892, "guard"):
		var _t978 = J.gp(v_g0_895, "guards")
		v_h_897 = J.mc(_t978, "find", [Callable(self, "_f156").bind(_s363)])
		if (not J.t(v_h_897)):
			return null
		var _t980 = _s363["__p"]["addGuardRider"]
		var _t981 = J.cl(_t980, null, [v_h_897, v_dest_894])
		v_o_896 = _t981
	else:
		var _t982 = J.gp(v_g0_895, "res")
		var _t988 = J.mc(_t982, "find", [Callable(self, "_f157").bind(_s363)])
		if not J.t(_t988):
			var _t985 = J.gp(v_g0_895, "res")
			_t988 = J.mc(_t985, "find", [Callable(self, "_f158").bind(_s363)])
		v_r_898 = _t988
		if (not J.t(v_r_898)):
			return null
		var _t989 = _s363["__p"]["addResRider"]
		var _t990 = J.cl(_t989, null, [v_r_898, "snack", v_dest_894])
		v_o_896 = _t990
		J.sp(v_r_898, "brave", 0.0)
	var _t991 = _s363["f"]
	J.sp(v_o_896, "f", _t991)
	J.sp(v_o_896, "ph", "wait")
	var _t992 = J.sub(J.gp(J.cl(_s363["__p"]["col"], null, []), "cx"), 44.0)
	J.sp(v_o_896, "x", _t992)
	return true

func _f159(this_, a: Array, env):
	var v_f_910 = null
	v_f_910 = J.arg(a, 0)
	if (not J.seq(J.cl(env["G"], null, []), env["lastG"])):
		J.cl(env["reset"], null, [])
	var _t995 = env["S"]
	J.sp(_t995, "pos", v_f_910)
	var _t996 = env["S"]
	J.sp(_t996, "st", "idle")
	var _t997 = env["S"]
	J.sp(_t997, "door", 0.0)
	var _t998 = env["S"]
	J.sp(_t998, "v", 0.0)

func _f160(this_, a: Array, env):
	if (not J.seq(J.cl(env["G"], null, []), env["lastG"])):
		J.cl(env["reset"], null, [])
	var _t1001 = env["S"]
	J.sp(_t1001, "spawnT", 1000000000.0)
	var _t1002 = env["S"]
	J.sp(_t1002, "gSpawnT", 1000000000.0)

func _f2(this_, a: Array, env):
	var v_css_28 = null; var v_resIn_66 = null; var v_crPaperURL_92 = null; var v_crEdgeURL_93 = null; var v_bi_94 = null
	var _s3 = {"__p": env, "A": null, "L": null, "S": null, "lastG": null, "CAP": null, "VMAX": null, "ACC": null, "DOOR_T": null, "HOLD": null, "TR": null, "TRK": null, "LN": null, "lnUsed": null, "AC": null, "hum": null, "noiseBuf": null, "SND": null, "wc": null, "wx": null, "CRT": null, "CRF": null, "ui": null, "cabCv": null, "cx2": null, "trickBox": null, "block": null, "panel": null, "stEl": null, "floorsEl": null, "doorsEl": null, "built": null, "fBtns": null, "tBtns": null, "tex": null, "last": null, "line": null, "ac": null, "nbuf": null, "tone": null, "noiseBurst": null, "G": null, "FL": null, "top": null, "lab": null, "fyf": null, "col": null, "FH": null, "rnd": null, "pick": null, "cabF": null, "atFloor": null, "ghost": null, "gpm": null, "sayR": null, "fl": null, "riderSpr": null, "rKey": null, "rH": null, "inCab": null, "reset": null, "wanted": null, "chooseTarget": null, "startMove": null, "arrive": null, "boardAndExit": null, "exitRider": null, "spawnResident": null, "addResRider": null, "spawnGuard": null, "addGuardRider": null, "doEnter": null, "scareLanding": null, "dingFx": null, "flash": null, "log": null, "img": null, "sprAt": null, "bub": null, "drawWorld": null, "ease": null, "steel": null, "gapLight": null, "lightLevel": null, "crFrame": null, "tapFx": null, "mkBtn": null, "build": null, "layout": null, "refresh": null, "showUI": null, "hideUI": null, "crayonTex": null, "poly": null, "texFill": null, "drawCab": null, "running": null, "loop": null}
	_s3["A"] = J.arg(a, 0)
	_s3["line"] = Callable(self, "_f3").bind(_s3)
	_s3["ac"] = Callable(self, "_f5").bind(_s3)
	_s3["nbuf"] = Callable(self, "_f6").bind(_s3)
	_s3["tone"] = Callable(self, "_f7").bind(_s3)
	_s3["noiseBurst"] = Callable(self, "_f8").bind(_s3)
	_s3["G"] = Callable(self, "_f17").bind(_s3)
	_s3["FL"] = Callable(self, "_f18").bind(_s3)
	_s3["top"] = Callable(self, "_f19").bind(_s3)
	_s3["lab"] = Callable(self, "_f20").bind(_s3)
	_s3["fyf"] = Callable(self, "_f21").bind(_s3)
	_s3["col"] = Callable(self, "_f22").bind(_s3)
	_s3["FH"] = Callable(self, "_f24").bind(_s3)
	_s3["rnd"] = Callable(self, "_f25").bind(_s3)
	_s3["pick"] = Callable(self, "_f26").bind(_s3)
	_s3["cabF"] = Callable(self, "_f27").bind(_s3)
	_s3["atFloor"] = Callable(self, "_f28").bind(_s3)
	_s3["ghost"] = Callable(self, "_f29").bind(_s3)
	_s3["gpm"] = Callable(self, "_f30").bind(_s3)
	_s3["sayR"] = Callable(self, "_f31").bind(_s3)
	_s3["fl"] = Callable(self, "_f32").bind(_s3)
	_s3["riderSpr"] = Callable(self, "_f33").bind(_s3)
	_s3["rKey"] = Callable(self, "_f34").bind(_s3)
	_s3["rH"] = Callable(self, "_f35").bind(_s3)
	_s3["inCab"] = Callable(self, "_f36").bind(_s3)
	v_resIn_66 = Callable(self, "_f38").bind(_s3)
	_s3["reset"] = Callable(self, "_f40").bind(_s3)
	_s3["wanted"] = Callable(self, "_f42").bind(_s3)
	_s3["chooseTarget"] = Callable(self, "_f44").bind(_s3)
	_s3["startMove"] = Callable(self, "_f52").bind(_s3)
	_s3["arrive"] = Callable(self, "_f53").bind(_s3)
	_s3["boardAndExit"] = Callable(self, "_f55").bind(_s3)
	_s3["exitRider"] = Callable(self, "_f58").bind(_s3)
	_s3["spawnResident"] = Callable(self, "_f59").bind(_s3)
	_s3["addResRider"] = Callable(self, "_f61").bind(_s3)
	_s3["spawnGuard"] = Callable(self, "_f62").bind(_s3)
	_s3["addGuardRider"] = Callable(self, "_f64").bind(_s3)
	_s3["doEnter"] = Callable(self, "_f67").bind(_s3)
	_s3["scareLanding"] = Callable(self, "_f76").bind(_s3)
	_s3["dingFx"] = Callable(self, "_f79").bind(_s3)
	_s3["flash"] = Callable(self, "_f83").bind(_s3)
	_s3["log"] = Callable(self, "_f84").bind(_s3)
	_s3["img"] = Callable(self, "_f92").bind(_s3)
	_s3["sprAt"] = Callable(self, "_f93").bind(_s3)
	_s3["bub"] = Callable(self, "_f94").bind(_s3)
	_s3["drawWorld"] = Callable(self, "_f95").bind(_s3)
	_s3["ease"] = Callable(self, "_f102").bind(_s3)
	_s3["steel"] = Callable(self, "_f103").bind(_s3)
	_s3["gapLight"] = Callable(self, "_f104").bind(_s3)
	_s3["lightLevel"] = Callable(self, "_f106").bind(_s3)
	_s3["crFrame"] = Callable(self, "_f107").bind(_s3)
	v_crPaperURL_92 = Callable(self, "_f112").bind(_s3)
	v_crEdgeURL_93 = Callable(self, "_f114").bind(_s3)
	v_bi_94 = Callable(self, "_f117").bind(_s3)
	_s3["tapFx"] = Callable(self, "_f120").bind(_s3)
	_s3["mkBtn"] = Callable(self, "_f122").bind(_s3)
	_s3["build"] = Callable(self, "_f124").bind(_s3)
	_s3["layout"] = Callable(self, "_f132").bind(_s3)
	_s3["refresh"] = Callable(self, "_f133").bind(_s3)
	_s3["showUI"] = Callable(self, "_f137").bind(_s3)
	_s3["hideUI"] = Callable(self, "_f139").bind(_s3)
	_s3["crayonTex"] = Callable(self, "_f141").bind(_s3)
	_s3["poly"] = Callable(self, "_f143").bind(_s3)
	_s3["texFill"] = Callable(self, "_f144").bind(_s3)
	_s3["drawCab"] = Callable(self, "_f145").bind(_s3)
	_s3["running"] = Callable(self, "_f151").bind(_s3)
	_s3["loop"] = Callable(self, "_f152").bind(_s3)
	_s3["L"] = {}
	_s3["S"] = null
	_s3["lastG"] = null
	_s3["CAP"] = 4.0
	_s3["VMAX"] = 0.75
	_s3["ACC"] = 1.4
	_s3["DOOR_T"] = 0.5
	_s3["HOLD"] = 2.6
	_s3["TR"] = {"dark": {"n": "熄燈", "cd": 14.0, "f": 34.0, "d": "閃兩下熄晒，黑暗中有人唞氣"}, "btns": {"n": "亂按", "cd": 18.0, "f": 22.0, "d": "全部樓層掣自己亮，層層都停"}, "mirror": {"n": "鏡中影", "cd": 16.0, "f": 38.0, "d": "𨋢鏡多咗個人影"}, "over": {"n": "超重", "cd": 20.0, "f": 26.0, "d": "超重警報響，但得佢一個"}, "stuck": {"n": "卡𨋢", "cd": 26.0, "f": 45.0, "d": "停喺兩層中間，門開一半見到牆"}, "door": {"n": "嚇門口", "cd": 10.0, "f": 40.0, "d": "開門嚇喺門口等𨋢嘅人"}}
	_s3["TRK"] = ["dark", "btns", "mirror", "over", "stuck", "door"]
	_s3["LN"] = {"wait": ["部𨋢又停咗喺頂樓……", "撳咗好耐都未嚟", "快啲啦，好肚餓", "呢部𨋢慢到死", "等𨋢等到頸都長", "係咪又有人㩒住度門？"], "board": ["唔該等等！", "唔該借借", "唔該撳埋我嗰層", "入面仲有位嘛？", "唔該，等埋我"], "full": ["滿咗？等下一轉啦", "咁多人，我等陣先"], "snack": ["落樓下打包碗雲吞麵先", "去士多買支維他奶", "茶餐廳仲開，去買個菠蘿油", "肚餓，落去買宵夜"], "back": ["買到宵夜喇，返上去食", "好彩仲有得買", "返屋企食住睇劇先"], "work": ["返通宵更喇，遲到就死", "的士要交更，走先"], "dark": ["嘩！做咩黑晒呀？！", "邊個喺度唞氣……？", "唔好玩啦，開返盞燈啦！", "我好似聽到有人喺我耳邊抖氣……"], "btns": ["邊個撳晒啲掣呀？！", "我冇撳過㗎……", "層層停，停到幾時呀？", "啲掣自己亮㗎？！"], "mirror": ["面鏡……我後面多咗個人……", "頭先係咪有人企喺我後面？", "我唔敢再望面鏡喇", "鏡入面嗰個唔係我……"], "over": ["超重？得我一個人咋喎！", "響乜嘢呀，我好重咩……", "咪嚇我啦，入面冇其他人㗎", "超重……咁即係仲有邊個喺度？"], "stuck": ["卡住咗？！開門呀！", "得半度門，出面係牆呀！", "救命呀，有冇人聽到呀？", "唔好喺度停呀，求下你郁啦"], "bolt": ["我行樓梯好過！", "唔搭喇唔搭喇！", "走呀——！", "俾我出去！"], "cower": ["我唔郁……我乜都冇見到……", "快啲到啦，快啲到啦……", "唔關我事，唔好搵我……"], "land": ["嘩！部𨋢入面黑麻麻冇人㗎……", "做咩自己開門嘅？！", "入面……入面有嘢呀！", "我唔搭喇，行樓梯！"], "gReport": ["管理處，管理處，部𨋢有啲古怪，我落機房睇睇。", "Over，𨋢又壞，我去機房check吓。", "對講機：𨋢有問題，我而家去機房。"], "gLand": ["咦？部𨋢自己開門？", "冇人㗎喎……奇怪", "邊個喺度玩部𨋢？"], "gBack": ["機房搞掂，冇事喎……奇怪。", "電掣冇跳過，鬼知咩事。", "檢查完，部𨋢冇壞……"], "gRide": ["搭𨋢巡上去睇睇", "行樓梯行到腳軟，搭𨋢啦", "上去巡下先"]}
	_s3["lnUsed"] = {}
	_s3["AC"] = null
	_s3["hum"] = null
	_s3["noiseBuf"] = null
	_s3["SND"] = {"ding": Callable(self, "_f9").bind(_s3), "door": Callable(self, "_f10").bind(_s3), "buzz": Callable(self, "_f11").bind(_s3), "breath": Callable(self, "_f12").bind(_s3), "clunk": Callable(self, "_f13").bind(_s3), "click": Callable(self, "_f14").bind(_s3), "hum": Callable(self, "_f15").bind(_s3)}
	J.S_document_("addEventListener", ["pointerdown", Callable(self, "_f16").bind(_s3), {"passive": true}])
	var _t587 = _s3["L"]
	var _t595 = Callable(self, "_f65").bind(_s3)
	J.sp(_t587, "action", _t595)
	var _t596 = _s3["L"]
	var _t611 = Callable(self, "_f66").bind(_s3)
	J.sp(_t596, "enter", _t611)
	var _t612 = _s3["L"]
	var _t624 = Callable(self, "_f68").bind(_s3)
	J.sp(_t612, "exit", _t624)
	var _t625 = _s3["L"]
	var _t636 = Callable(self, "_f69").bind(_s3)
	J.sp(_t625, "press", _t636)
	var _t637 = _s3["L"]
	var _t646 = Callable(self, "_f70").bind(_s3)
	J.sp(_t637, "open", _t646)
	var _t647 = _s3["L"]
	var _t653 = Callable(self, "_f71").bind(_s3)
	J.sp(_t647, "close", _t653)
	var _t654 = _s3["L"]
	var _t663 = Callable(self, "_f72").bind(_s3)
	J.sp(_t654, "canTrick", _t663)
	var _t664 = _s3["L"]
	var _t724 = Callable(self, "_f74").bind(_s3)
	J.sp(_t664, "trick", _t724)
	var _t725 = _s3["L"]
	var _t749 = Callable(self, "_f80").bind(_s3)
	J.sp(_t725, "scareWaiting", _t749)
	var _t750 = _s3["L"]
	var _t924 = Callable(self, "_f85").bind(_s3)
	J.sp(_t750, "step", _t924)
	_s3["wc"] = J.S_document_("createElement", ["canvas"])
	var _t925 = _s3["wc"]
	J.sp(_t925, "id", "lift-world")
	var _t926 = J.gp(_s3["wc"], "style")
	J.sp(_t926, "cssText", "position:fixed;pointer-events:none;z-index:61;left:0;top:0")
	var _t927 = J.gp(J.G.get("document"), "body")
	J.mc(_t927, "appendChild", [_s3["wc"]])
	_s3["wx"] = J.mc(_s3["wc"], "getContext", ["2d"])
	_s3["CRT"] = {"bone": ["#1e1a16", "#5c5246", "#d8ccb0"], "rust": ["#2a190d", "#8c4b1d", "#e08840"], "moss": ["#121a11", "#3b5431", "#8aac6c"], "red": ["#2b1012", "#7a2522", "#c4493c"], "ink": ["#18141b", "#3c3544", "#958a9c"], "violet": ["#19132a", "#4b3b6e", "#9c88cc"]}
	_s3["CRF"] = {}
	var _t928 = ["bone", "rust", "moss", "red", "ink", "violet"]
	J.mc(_t928, "forEach", [Callable(self, "_f116").bind(_s3)])
	_s3["ui"] = J.S_document_("createElement", ["div"])
	var _t936 = _s3["ui"]
	J.sp(_t936, "id", "lift-ui")
	var _t937 = _s3["ui"]
	J.sp(_t937, "className", "tw-lift")
	var _t938 = _s3["ui"]
	var _t939 = "<canvas id=\"lift-cab\"></canvas><div id=\"lift-tricks\"></div><div id=\"lift-block\"></div><div id=\"lift-panel\"><div id=\"lift-st\"></div><div id=\"lift-floors\"></div><div id=\"lift-doors\"></div></div>"
	J.sp(_t938, "innerHTML", _t939)
	v_css_28 = J.S_document_("createElement", ["style"])
	var _t940 = J.gp(_s3["A"], "FONT")
	var _t941 = (J.add(((J.add(((J.add((J.add((J.add(((J.add(((J.add((J.add(((J.add((J.add(((J.add(((((J.add((J.add(((((((J.add("#lift-ui{position:fixed;display:none;z-index:62;pointer-events:none;font-family:", J.mc(_t940, "replace", [J.re("\"", "g"), "'"])) + "}") + "#lift-ui.on{display:block}#lift-ui>*{position:absolute;left:0;right:0;pointer-events:auto}") + "#lift-cab{width:100%;display:block;transform:translateY(-12px);opacity:0;transition:transform .28s,opacity .28s;border-bottom:3px solid #3a2e2a;box-shadow:0 6px 18px rgba(0,0,0,.6)}#lift-ui.show #lift-cab{transform:none;opacity:1}") + "#lift-block{background:transparent;touch-action:none}") + "#lift-tricks{display:flex;gap:5px;padding:0 6px;justify-content:center;touch-action:manipulation}") + ".tw-lift #lift-panel{background:"), J.cl(v_crEdgeURL_93, null, [])) + " repeat-x top left/256px 12px,"), J.cl(v_crPaperURL_92, null, [])) + " repeat 0 0/160px 160px,#141016;padding:12px 8px 10px;box-sizing:border-box;touch-action:manipulation;transform:translateY(20px);opacity:0;transition:transform .28s,opacity .28s;box-shadow:0 -6px 14px rgba(0,0,0,.6)}.tw-lift.show #lift-panel{transform:none;opacity:1}") + ".tw-lift #lift-st{color:#e6a85a;font-size:15px;font-weight:bold;height:20px;line-height:20px;text-align:center;text-shadow:1px 2px 0 rgba(6,3,8,.9),0 0 3px #000;white-space:nowrap;overflow:hidden}") + ".tw-lift #lift-floors{display:grid;gap:6px;margin:6px 0;justify-content:center}.tw-lift #lift-doors{display:flex;gap:6px}") + ".tw-lift .lb{min-width:48px;min-height:48px;"), J.cl(v_bi_94, null, ["bone"])) + "color:#efe5cf;font-weight:bold;font-size:18px;display:flex;align-items:center;justify-content:center;user-select:none;-webkit-user-select:none;transition:transform .06s;box-sizing:border-box;text-shadow:1px 2px 0 rgba(6,3,8,.9),0 0 2px #000}") + ".tw-lift .lb.lit{border-image-source:"), J.gp(_s3["CRF"], "rust")) + ";color:#f6dcb6}.tw-lift .lb.cur{border-image-source:"), J.gp(_s3["CRF"], "moss")) + ";color:#e4ecd2}") + ".tw-lift .lb.press,.tw-lift .lb:active{transform:translateY(2px);border-image-source:"), J.gp(_s3["CRF"], "boneP")) + "}.tw-lift .lb.lit.press,.tw-lift .lb.lit:active{border-image-source:"), J.gp(_s3["CRF"], "rustP")) + "}") + ".tw-lift .ld{flex:1;min-height:52px;"), J.cl(v_bi_94, null, ["ink"])) + "color:#ebe3d6;font-weight:bold;font-size:16px;display:flex;align-items:center;justify-content:center;user-select:none;-webkit-user-select:none;transition:transform .06s;box-sizing:border-box;text-shadow:1px 2px 0 rgba(6,3,8,.9),0 0 2px #000}") + ".tw-lift .ld.exit{border-image-source:"), J.gp(_s3["CRF"], "moss")) + ";color:#e4ecd2}.tw-lift .ld.off{opacity:.45;filter:saturate(.5)}.tw-lift .ld.press,.tw-lift .ld:active{transform:translateY(2px);border-image-source:"), J.gp(_s3["CRF"], "inkP")) + "}.tw-lift .ld.exit.press,.tw-lift .ld.exit:active{border-image-source:"), J.gp(_s3["CRF"], "mossP")) + "}") + ".tw-lift .lt{flex:1;min-height:52px;max-width:76px;"), J.cl(v_bi_94, null, ["red"])) + "color:#f2e3cc;font-size:14px;font-weight:bold;display:flex;flex-direction:column;align-items:center;justify-content:center;line-height:1.15;user-select:none;-webkit-user-select:none;transition:transform .06s;box-sizing:border-box;text-shadow:1px 2px 0 rgba(6,3,8,.9),0 0 2px #000}") + ".tw-lift .lt small{font-size:11px;font-weight:bold;color:#e8c4b0}.tw-lift .lt.cd{opacity:.5;filter:saturate(.4)}.tw-lift .lt.press,.tw-lift .lt:active{transform:translateY(2px);border-image-source:"), J.gp(_s3["CRF"], "redP")) + "}")
	J.sp(v_css_28, "textContent", _t941)
	var _t942 = J.gp(J.G.get("document"), "head")
	J.mc(_t942, "appendChild", [v_css_28])
	var _t943 = J.gp(J.G.get("document"), "body")
	J.mc(_t943, "appendChild", [_s3["ui"]])
	_s3["cabCv"] = J.mc(_s3["ui"], "querySelector", ["#lift-cab"])
	_s3["cx2"] = J.mc(_s3["cabCv"], "getContext", ["2d"])
	_s3["trickBox"] = J.mc(_s3["ui"], "querySelector", ["#lift-tricks"])
	_s3["block"] = J.mc(_s3["ui"], "querySelector", ["#lift-block"])
	_s3["panel"] = J.mc(_s3["ui"], "querySelector", ["#lift-panel"])
	_s3["stEl"] = J.mc(_s3["ui"], "querySelector", ["#lift-st"])
	_s3["floorsEl"] = J.mc(_s3["ui"], "querySelector", ["#lift-floors"])
	_s3["doorsEl"] = J.mc(_s3["ui"], "querySelector", ["#lift-doors"])
	var _t944 = ["pointerdown", "pointermove", "pointerup", "touchstart", "touchmove"]
	J.mc(_t944, "forEach", [Callable(self, "_f118").bind(_s3)])
	_s3["built"] = (-1.0)
	_s3["fBtns"] = {}
	_s3["tBtns"] = {}
	var _t945 = _s3["L"]
	var _t948 = Callable(self, "_f140").bind(_s3)
	J.sp(_t945, "band", _t948)
	_s3["tex"] = null
	_s3["last"] = 0.0
	J.F_requestAnimationFrame([_s3["loop"]])
	var _t949 = _s3["L"]
	var _t976 = Callable(self, "_f153").bind(_s3)
	J.sp(_t949, "state", _t976)
	var _t977 = _s3["L"]
	var _t993 = Callable(self, "_f155").bind(_s3)
	J.sp(_t977, "debugRider", _t993)
	var _t994 = _s3["L"]
	var _t999 = Callable(self, "_f159").bind(_s3)
	J.sp(_t994, "setPos", _t999)
	var _t1000 = _s3["L"]
	var _t1003 = Callable(self, "_f160").bind(_s3)
	J.sp(_t1000, "noSpawn", _t1003)
	var _t1004 = _s3["L"]
	var _t1005 = _s3["lab"]
	J.sp(_t1004, "lab", _t1005)
	return _s3["L"]

func _f1(this_, a: Array, env):
	var _t1 = J.G.get("window")
	var _t1006 = Callable(self, "_f2").bind(env)
	J.sp(_t1, "LiftSys", _t1006)

func _f164(this_, a: Array, env):
	var v___1022 = null; var v_i_1023 = null
	v___1022 = J.arg(a, 0)
	v_i_1023 = J.arg(a, 1)
	return v_i_1023

func _f163(this_, a: Array, env):
	var v_k_1014 = null; var v_p_1015 = null; var v_a_1016 = null; var v_i_1017 = null; var v_j_1018 = null; var v_t_1019 = null
	v_k_1014 = J.arg(a, 0)
	v_p_1015 = J.gp(env["LN"], v_k_1014)
	var _t1010 = (not J.t(J.gp(env["lnUsed"], v_k_1014)))
	if (_t1010 if _t1010 else (not J.t(J.len(J.gp(env["lnUsed"], v_k_1014))))):
		v_a_1016 = J.mc(v_p_1015, "map", [Callable(self, "_f164").bind(env)])
		v_i_1017 = (J.len(v_a_1016) - 1.0)
		while true:
			if not J.cmp(v_i_1017, 0.0, ">"): break
			v_j_1018 = floor(J.num(J.mul(randf(), J.add(v_i_1017, 1.0))))
			v_t_1019 = J.gp(v_a_1016, v_i_1017)
			var _t1011 = J.gp(v_a_1016, v_j_1018)
			J.sp(v_a_1016, v_i_1017, _t1011)
			J.sp(v_a_1016, v_j_1018, v_t_1019)
			v_i_1017 = J.num(v_i_1017) + -1.0
		var _t1012 = env["lnUsed"]
		J.sp(_t1012, v_k_1014, v_a_1016)
	return J.gp(v_p_1015, J.mc(J.gp(env["lnUsed"], v_k_1014), "pop", []))

func _f165(this_, a: Array, env):
	var _t1013 = J.gp(J.G.get("window"), "UNIT_LAYOUTS")
	return (_t1013 if J.t(_t1013) else {})

func _f166(this_, a: Array, env):
	var v_un_1028 = null; var v_L_1029 = null; var v_k_1030 = null; var v_l_1031 = null
	v_un_1028 = J.arg(a, 0)
	v_L_1029 = J.cl(env["LAYS"], null, [])
	var _t1014 = J.gp(env["A"], "LV")
	var _t1016 = null
	if J.t((J.seq(J.gp(J.gp(env["A"], "LV"), "key"), "shop") if J.t(_t1014) else _t1014)):
		_t1016 = "shop"
	else:
		var _t1015 = ["gamer", "ot", "gym"]
		_t1016 = ("gamer" if J.cmp(J.mc(_t1015, "indexOf", [J.gp(v_un_1028, "hh")]), 0.0, ">=") else "ppr")
	v_k_1030 = _t1016
	var _t1017 = J.gp(v_L_1029, v_k_1030)
	v_l_1031 = (_t1017 if J.t(_t1017) else J.gp(v_L_1029, "ppr"))
	var _t1019 = v_l_1031
	if J.t(_t1019):
		var _t1018 = env["img"]
		_t1019 = J.cl(_t1018, null, [J.gp(v_l_1031, "img")])
	if J.t(_t1019):
		J.sp(v_l_1031, "key", v_k_1030)
		return v_l_1031
	var _t1020 = env["FB"]
	J.sp(_t1020, "key", "fb")
	return env["FB"]

func _f167(this_, a: Array, env):
	return J.gp(env["A"], "G")

func _f168(this_, a: Array, env):
	return (J.mc(env["A"], "rnd", []) if J.t(J.gp(env["A"], "rnd")) else randf())

func _f169(this_, a: Array, env):
	var v_a_1038 = null
	v_a_1038 = J.arg(a, 0)
	return J.gp(v_a_1038, floor(J.num(J.mul(J.cl(env["rnd"], null, []), J.len(v_a_1038)))))

func _f170(this_, a: Array, env):
	var v_k_1041 = null; var v_im_1042 = null
	v_k_1041 = J.arg(a, 0)
	var _t1021 = (J.gp(env["A"], "IMG") if J.t(v_k_1041) else v_k_1041)
	v_im_1042 = (J.gp(J.gp(env["A"], "IMG"), v_k_1041) if J.t(_t1021) else _t1021)
	return (v_im_1042 if J.t((J.gp(v_im_1042, "width") if J.t(v_im_1042) else v_im_1042)) else null)

func _f171(this_, a: Array, env):
	var v_v_1045 = null; var v_a_1046 = null; var v_b_1047 = null
	v_v_1045 = J.arg(a, 0)
	v_a_1046 = J.arg(a, 1)
	v_b_1047 = J.arg(a, 2)
	return (v_a_1046 if J.cmp(v_v_1045, v_a_1046, "<") else (v_b_1047 if J.cmp(v_v_1045, v_b_1047, ">") else v_v_1045))

func _f173(this_, a: Array, env):
	var v_p_1056 = null
	v_p_1056 = J.arg(a, 0)
	var _t1022 = J.add(env["t"], J.gp(v_p_1056, 1.0))
	env["t"] = _t1022

func _f172(this_, a: Array, env):
	var v_a_1050 = null; var v_r_1052 = null; var v_i_1053 = null
	var _s386 = {"__p": env, "t": null}
	v_a_1050 = J.arg(a, 0)
	_s386["t"] = 0.0
	J.mc(v_a_1050, "forEach", [Callable(self, "_f173").bind(_s386)])
	v_r_1052 = J.mul(J.cl(_s386["__p"]["rnd"], null, []), _s386["t"])
	v_i_1053 = 0.0
	while true:
		if not J.cmp(v_i_1053, J.len(v_a_1050), "<"): break
		var _t1023 = J.sub(v_r_1052, J.gp(J.gp(v_a_1050, v_i_1053), 1.0))
		v_r_1052 = _t1023
		if J.cmp(v_r_1052, 0.0, "<="):
			return J.gp(J.gp(v_a_1050, v_i_1053), 0.0)
		v_i_1053 = J.num(v_i_1053) + 1.0
	return J.gp(J.gp(v_a_1050, 0.0), 0.0)

func _f174(this_, a: Array, env):
	var v_un_1059 = null
	v_un_1059 = J.arg(a, 0)
	var _t1024 = (J.gp(v_un_1059, "hh") if J.t(v_un_1059) else v_un_1059)
	var _t1025 = ((not J.seq(J.gp(v_un_1059, "ot"), "deity")) if J.t(_t1024) else _t1024)
	return (not (not J.t((J.gp(v_un_1059, "rs") if J.t(_t1025) else _t1025))))

func _f175(this_, a: Array, env):
	var v_un_1062 = null; var v_T_1063 = null
	v_un_1062 = J.arg(a, 0)
	if (not J.t(J.gp(v_un_1062, "iu"))):
		var _t1026 = J.gp(env["TASK"], J.gp(v_un_1062, "hh"))
		v_T_1063 = (_t1026 if J.t(_t1026) else {"k": "allout"})
		var _t1027 = {"alert": 0.0, "leftT": 0.0, "ban": 0.0, "cd": 0.0, "task": J.S_JSON_("parse", [J.S_JSON_("stringify", [v_T_1063])]), "done": false, "fled": 0.0, "visits": 0.0, "phoned": false}
		J.sp(v_un_1062, "iu", _t1027)
	return J.gp(v_un_1062, "iu")

func _f176(this_, a: Array, env):
	var v_x_1066 = null; var v_R_1067 = null; var v_i_1068 = null
	v_x_1066 = J.arg(a, 0)
	v_R_1067 = J.gp(J.gp(env["S"], "lay"), "rooms")
	v_i_1068 = 0.0
	while true:
		if not J.cmp(v_i_1068, J.len(v_R_1067), "<"): break
		var _t1028 = J.cmp(v_x_1066, J.sub(J.gp(J.gp(v_R_1067, v_i_1068), "x0"), 8.0), ">=")
		if (J.cmp(v_x_1066, J.add(J.gp(J.gp(v_R_1067, v_i_1068), "x1"), 8.0), "<=") if _t1028 else _t1028):
			return v_i_1068
		v_i_1068 = J.num(v_i_1068) + 1.0
	return (0.0 if J.cmp(v_x_1066, J.gp(J.gp(v_R_1067, 0.0), "x0"), "<") else (J.len(v_R_1067) - 1.0))

func _f177(this_, a: Array, env):
	var v_r_1071 = null; var v_t_1072 = null
	v_r_1071 = J.arg(a, 0)
	v_t_1072 = J.arg(a, 1)
	if (not J.t(v_r_1071)):
		return null
	J.sp(v_r_1071, "say", v_t_1072)
	J.sp(v_r_1071, "sayT", 2.6)

func _f178(this_, a: Array, env):
	var v_t_1075 = null; var v_c_1076 = null
	v_t_1075 = J.arg(a, 0)
	v_c_1076 = J.arg(a, 1)
	if J.t(env["S"]):
		var _t1029 = env["S"]
		J.sp(_t1029, "msg", v_t_1075)
		var _t1030 = env["S"]
		J.sp(_t1030, "msgT", 3.2)
		var _t1031 = env["S"]
		var _t1032 = (v_c_1076 if J.t(v_c_1076) else "#efdcb4")
		J.sp(_t1031, "msgC", _t1032)

func _f180(this_, a: Array, env):
	var v_f_1087 = null
	v_f_1087 = J.arg(a, 0)
	var _t1034 = (absf(J.num(J.sub(J.gp(v_f_1087, "x"), env["x"]))) < 140.0)
	return ((absf(J.num(J.sub(J.gp(v_f_1087, "y"), env["yy"]))) < 30.0) if _t1034 else _t1034)

func _f179(this_, a: Array, env):
	var v_y_1080 = null; var v_t_1081 = null; var v_c_1082 = null; var v_k_1084 = null
	var _s398 = {"__p": env, "x": null, "yy": null}
	_s398["x"] = J.arg(a, 0)
	v_y_1080 = J.arg(a, 1)
	v_t_1081 = J.arg(a, 2)
	v_c_1082 = J.arg(a, 3)
	if (not J.t(_s398["__p"]["S"])):
		return null
	_s398["yy"] = v_y_1080
	v_k_1084 = 0.0
	while true:
		var _t1035 = J.cmp(v_k_1084, 4.0, "<")
		if J.t(_t1035):
			var _t1033 = J.gp(_s398["__p"]["S"], "floats")
			_t1035 = J.mc(_t1033, "some", [Callable(self, "_f180").bind(_s398)])
		if not J.t(_t1035): break
		var _t1036 = J.sub(_s398["yy"], 32.0)
		_s398["yy"] = _t1036
		v_k_1084 = J.num(v_k_1084) + 1.0
	var _t1037 = J.gp(_s398["__p"]["S"], "floats")
	J.mc(_t1037, "push", [{"x": _s398["x"], "y": _s398["yy"], "t": v_t_1081, "c": (v_c_1082 if J.t(v_c_1082) else "#efe5cf"), "life": 1.8}])
	if (J.len(J.gp(_s398["__p"]["S"], "floats")) > 8.0):
		J.mc(J.gp(_s398["__p"]["S"], "floats"), "shift", [])

func _f181(this_, a: Array, env):
	var v_x_1090 = null; var v_y_1091 = null; var v_vx_1092 = null; var v_vy_1093 = null; var v_life_1094 = null; var v_type_1095 = null
	v_x_1090 = J.arg(a, 0)
	v_y_1091 = J.arg(a, 1)
	v_vx_1092 = J.arg(a, 2)
	v_vy_1093 = J.arg(a, 3)
	v_life_1094 = J.arg(a, 4)
	v_type_1095 = J.arg(a, 5)
	if J.t(((J.len(J.gp(env["S"], "parts")) < 220.0) if J.t(env["S"]) else env["S"])):
		var _t1038 = J.gp(env["S"], "parts")
		J.mc(_t1038, "push", [{"x": v_x_1090, "y": v_y_1091, "vx": v_vx_1092, "vy": v_vy_1093, "life": v_life_1094, "max": v_life_1094, "type": v_type_1095}])

func _f182(this_, a: Array, env):
	var v_g0_1098 = null
	v_g0_1098 = J.cl(env["G"], null, [])
	var _t1039 = J.seq(J.gp(env["A"], "scene"), "play")
	var _t1040 = (v_g0_1098 if _t1039 else _t1039)
	var _t1041 = ((not J.t(J.gp(v_g0_1098, "over"))) if J.t(_t1040) else _t1040)
	var _t1042 = ((not J.t(J.gp(v_g0_1098, "choice"))) if J.t(_t1041) else _t1041)
	var _t1043 = ((not J.t(J.gp(v_g0_1098, "showStory"))) if J.t(_t1042) else _t1042)
	var _t1044 = ((not J.t(J.gp(v_g0_1098, "ult"))) if J.t(_t1043) else _t1043)
	return ((not J.t(J.gp(env["A"], "paused"))) if J.t(_t1044) else _t1044)

func _f183(this_, a: Array, env):
	var v_g0_1101 = null
	v_g0_1101 = J.cl(env["G"], null, [])
	var _t1045 = (J.seq(J.gp(env["A"], "scene"), "play") if J.t(env["S"]) else env["S"])
	var _t1046 = (v_g0_1101 if J.t(_t1045) else _t1045)
	var _t1047 = ((not J.t(J.gp(v_g0_1101, "over"))) if J.t(_t1046) else _t1046)
	var _t1048 = ((not J.t(J.gp(v_g0_1101, "choice"))) if J.t(_t1047) else _t1047)
	return (not (not J.t(((not J.t(J.gp(v_g0_1101, "showStory"))) if J.t(_t1048) else _t1048))))

func _f184(this_, a: Array, env):
	var v_e_1104 = null; var v_e_1105 = null
	if (not J.t(env["AC"])):
		var _t1049 = J.gp(J.G.get("window"), "AudioContext")
		var _t1050 = J.construct((_t1049 if J.t(_t1049) else J.gp(J.G.get("window"), "webkitAudioContext")), [])
		env["AC"] = _t1050
	if J.t((J.seq(J.gp(env["AC"], "state"), "suspended") if J.t(env["AC"]) else env["AC"])):
		J.mc(env["AC"], "resume", [])
	return env["AC"]

func _f185(this_, a: Array, env):
	var v_f_1108 = null; var v_t0_1109 = null; var v_dur_1110 = null; var v_vol_1111 = null; var v_type_1112 = null; var v_c_1113 = null; var v_o_1114 = null; var v_g_1115 = null; var v_e_1116 = null
	v_f_1108 = J.arg(a, 0)
	v_t0_1109 = J.arg(a, 1)
	v_dur_1110 = J.arg(a, 2)
	v_vol_1111 = J.arg(a, 3)
	v_type_1112 = J.arg(a, 4)
	v_c_1113 = J.cl(env["ac"], null, [])
	if (not J.t(v_c_1113)):
		return null
	v_o_1114 = J.mc(v_c_1113, "createOscillator", [])
	v_g_1115 = J.mc(v_c_1113, "createGain", [])
	var _t1051 = (v_type_1112 if J.t(v_type_1112) else "sine")
	J.sp(v_o_1114, "type", _t1051)
	var _t1052 = J.gp(v_o_1114, "frequency")
	J.sp(_t1052, "value", v_f_1108)
	var _t1053 = J.gp(v_g_1115, "gain")
	J.mc(_t1053, "setValueAtTime", [0.0001, J.add(J.gp(v_c_1113, "currentTime"), v_t0_1109)])
	var _t1054 = J.gp(v_g_1115, "gain")
	J.mc(_t1054, "exponentialRampToValueAtTime", [v_vol_1111, J.add(J.add(J.gp(v_c_1113, "currentTime"), v_t0_1109), 0.01)])
	var _t1055 = J.gp(v_g_1115, "gain")
	J.mc(_t1055, "exponentialRampToValueAtTime", [0.0001, J.add(J.add(J.gp(v_c_1113, "currentTime"), v_t0_1109), v_dur_1110)])
	J.mc(v_o_1114, "connect", [v_g_1115])
	J.mc(v_g_1115, "connect", [J.gp(v_c_1113, "destination")])
	J.mc(v_o_1114, "start", [J.add(J.gp(v_c_1113, "currentTime"), v_t0_1109)])
	J.mc(v_o_1114, "stop", [J.add(J.add(J.add(J.gp(v_c_1113, "currentTime"), v_t0_1109), v_dur_1110), 0.05)])

func _f186(this_, a: Array, env):
	var v_t0_1119 = null; var v_dur_1120 = null; var v_vol_1121 = null; var v_freq_1122 = null; var v_c_1123 = null; var v_d_1124 = null; var v_i_1125 = null; var v_s_1126 = null; var v_bp_1127 = null; var v_g_1128 = null; var v_T_1129 = null; var v_e_1130 = null
	v_t0_1119 = J.arg(a, 0)
	v_dur_1120 = J.arg(a, 1)
	v_vol_1121 = J.arg(a, 2)
	v_freq_1122 = J.arg(a, 3)
	v_c_1123 = J.cl(env["ac"], null, [])
	if (not J.t(v_c_1123)):
		return null
	if (not J.t(env["NB"])):
		var _t1056 = J.mc(v_c_1123, "createBuffer", [1.0, J.gp(v_c_1123, "sampleRate"), J.gp(v_c_1123, "sampleRate")])
		env["NB"] = _t1056
		v_d_1124 = J.mc(env["NB"], "getChannelData", [0.0])
		v_i_1125 = 0.0
		while true:
			if not J.cmp(v_i_1125, J.len(v_d_1124), "<"): break
			var _t1057 = ((randf() * 2.0) - 1.0)
			J.sp(v_d_1124, v_i_1125, _t1057)
			v_i_1125 = J.num(v_i_1125) + 1.0
	v_s_1126 = J.mc(v_c_1123, "createBufferSource", [])
	var _t1058 = env["NB"]
	J.sp(v_s_1126, "buffer", _t1058)
	J.sp(v_s_1126, "loop", true)
	v_bp_1127 = J.mc(v_c_1123, "createBiquadFilter", [])
	J.sp(v_bp_1127, "type", "bandpass")
	var _t1059 = J.gp(v_bp_1127, "frequency")
	var _t1060 = (v_freq_1122 if J.t(v_freq_1122) else 900.0)
	J.sp(_t1059, "value", _t1060)
	v_g_1128 = J.mc(v_c_1123, "createGain", [])
	v_T_1129 = J.add(J.gp(v_c_1123, "currentTime"), v_t0_1119)
	var _t1061 = J.gp(v_g_1128, "gain")
	J.mc(_t1061, "setValueAtTime", [0.0001, v_T_1129])
	var _t1062 = J.gp(v_g_1128, "gain")
	J.mc(_t1062, "linearRampToValueAtTime", [v_vol_1121, J.add(v_T_1129, J.mul(v_dur_1120, 0.3))])
	var _t1063 = J.gp(v_g_1128, "gain")
	J.mc(_t1063, "linearRampToValueAtTime", [0.0001, J.add(v_T_1129, v_dur_1120)])
	J.mc(v_s_1126, "connect", [v_bp_1127])
	J.mc(v_bp_1127, "connect", [v_g_1128])
	J.mc(v_g_1128, "connect", [J.gp(v_c_1123, "destination")])
	J.mc(v_s_1126, "start", [v_T_1129])
	J.mc(v_s_1126, "stop", [J.add(J.add(v_T_1129, v_dur_1120), 0.05)])

func _f193(this_, a: Array, env):
	var v_g_1147 = null; var v_un_1148 = null; var v_b_1149 = null; var v_I_1150 = null
	v_g_1147 = J.arg(a, 0)
	v_un_1148 = J.arg(a, 1)
	var _t1064 = env["isHH"]
	if (not J.t(J.cl(_t1064, null, [v_un_1148]))):
		return "no"
	v_b_1149 = J.mc(env["A"], "doorBlock", [v_g_1147, v_un_1148])
	if J.t(v_b_1149):
		return v_b_1149
	var _t1065 = env["iu"]
	v_I_1150 = J.cl(_t1065, null, [v_un_1148])
	if J.cmp(J.gp(v_I_1150, "ban"), 0.0, ">"):
		return "ban"
	if J.cmp(J.gp(v_I_1150, "cd"), 0.0, ">"):
		return "cd"
	return true

func _f196(this_, a: Array, env):
	var v_g_1163 = null; var v_un_1164 = null; var v_why_1165 = null; var v_I_1166 = null; var v_t_1167 = null
	v_g_1163 = J.arg(a, 0)
	v_un_1164 = J.arg(a, 1)
	v_why_1165 = J.arg(a, 2)
	v_I_1166 = J.gp(v_un_1164, "iu")
	var _t1069 = null
	if J.seq(v_why_1165, "deity"):
		_t1069 = "呢度有神明鎮宅，要尊重，我哋唔入"
	else:
		var _t1068 = null
		if J.seq(v_why_1165, "ban"):
			_t1068 = (J.add("呢戶啱啱被趕出嚟，佢哋開晒燈，", ceil(J.num(J.gp(v_I_1166, "ban")))) + " 秒後先好再入")
		else:
			var _t1067 = null
			if J.seq(v_why_1165, "cd"):
				_t1067 = (J.add("陰氣未回，", ceil(J.num(J.gp(v_I_1166, "cd")))) + " 秒後先入得")
			else:
				var _t1066 = J.gp(J.gp(env["A"], "BLOCKMSG"), v_why_1165)
				_t1067 = (_t1066 if J.t(_t1066) else "呢戶未入得")
			_t1068 = _t1067
		_t1069 = _t1068
	v_t_1167 = _t1069
	J.mc(env["A"], "float", [J.gp(v_un_1164, "x"), J.sub(J.gp(v_un_1164, "y"), 96.0), v_t_1167, "#ffd54a"])
	var _t1070 = J.seq(v_why_1165, "deity")
	if J.t((J.gp(J.cl(env["G"], null, []), "wardFx") if _t1070 else _t1070)):
		var _t1071 = J.gp(J.cl(env["G"], null, []), "wardFx")
		J.mc(_t1071, "push", [{"x": J.gp(v_un_1164, "x"), "y": J.gp(v_un_1164, "y"), "t": 0.9}])

func _f199(this_, a: Array, env):
	var v_R_1190 = null; var v_i_1191 = null
	v_R_1190 = J.arg(a, 0)
	v_i_1191 = J.arg(a, 1)
	var _t1076 = J.gp(env["S"], "light")
	J.mc(_t1076, "push", [false])
	var _t1077 = J.gp(env["S"], "dark")
	J.mc(_t1077, "push", [0.0])

func _f200(this_, a: Array, env):
	var v_p_1194 = null
	v_p_1194 = J.arg(a, 0)
	if J.t(J.gp(env["HOT"], J.gp(v_p_1194, "k"))):
		var _t1079 = J.gp(env["S"], "spots")
		J.mc(_t1079, "push", [{"k": J.gp(v_p_1194, "k"), "x": J.gp(v_p_1194, "x"), "y": J.gp(v_p_1194, "y"), "room": 0.0, "cd": 0.0, "t": 0.0}])

func _f201(this_, a: Array, env):
	var v_p_1197 = null
	v_p_1197 = J.arg(a, 0)
	var _t1081 = env["roomAt"]
	var _t1082 = J.cl(_t1081, null, [J.gp(v_p_1197, "x")])
	J.sp(v_p_1197, "room", _t1082)

func _f202(this_, a: Array, env):
	var v_p_1200 = null
	v_p_1200 = J.arg(a, 0)
	var _t1084 = J.gp(env["S"], "search")
	var _t1086 = J.gp(v_p_1200, "x")
	var _t1087 = J.gp(v_p_1200, "y")
	var _t1088 = J.gp(v_p_1200, "n")
	var _t1085 = env["roomAt"]
	J.mc(_t1084, "push", [{"x": _t1086, "y": _t1087, "n": _t1088, "room": J.cl(_t1085, null, [J.gp(v_p_1200, "x")])}])

func _f204(this_, a: Array, env):
	var v_p_1206 = null
	v_p_1206 = J.arg(a, 0)
	return J.seq(J.gp(v_p_1206, "k"), env["k"])

func _f203(this_, a: Array, env):
	var _s448 = {"__p": env, "k": null}
	_s448["k"] = J.arg(a, 0)
	var _t1090 = J.gp(_s448["__p"]["S"], "spots")
	return J.mc(_t1090, "some", [Callable(self, "_f204").bind(_s448)])

func _f205(this_, a: Array, env):
	var v_r_1209 = null; var v_i_1210 = null
	v_r_1209 = J.arg(a, 0)
	v_i_1210 = J.arg(a, 1)
	if J.seq(J.gp(v_r_1209, "state"), "home"):
		var _t1097 = J.gp(env["S"], "actors")
		var _t1098 = env["mkActor"]
		J.mc(_t1097, "push", [J.cl(_t1098, null, [v_r_1209, v_i_1210, true])])

func _f206(this_, a: Array, env):
	var v_a_1213 = null
	v_a_1213 = J.arg(a, 0)
	if J.t(J.gp(J.gp(v_a_1213, "r"), "awake")):
		var _t1101 = J.gp(env["S"], "light")
		var _t1100 = env["roomAt"]
		var _t1102 = J.cl(_t1100, null, [J.gp(v_a_1213, "x")])
		J.sp(_t1101, _t1102, true)

func _f207(this_, a: Array, env):
	return true

func _f198(this_, a: Array, env):
	var v_g_1178 = null; var v_un_1179 = null; var v_g0_1180 = null; var v_lay_1181 = null; var v_I_1182 = null; var v_T_1183 = null; var v_mk_1184 = null; var v_sp_1185 = null; var v_ac0_1186 = null; var v_hh_1187 = null
	v_g_1178 = J.arg(a, 0)
	v_un_1179 = J.arg(a, 1)
	v_g0_1180 = J.cl(env["G"], null, [])
	var _t1072 = env["layFor"]
	v_lay_1181 = J.cl(_t1072, null, [v_un_1179])
	var _t1073 = env["iu"]
	v_I_1182 = J.cl(_t1073, null, [v_un_1179])
	J.sp(v_I_1182, "visits", J.num(J.gp(v_I_1182, "visits")) + 1.0)
	var _t1074 = {"un": v_un_1179, "g": v_g_1178, "lay": v_lay_1181, "t": 0.0, "limit": env["LIMIT"], "gx": J.add(J.gp(v_lay_1181, "door"), 50.0), "gdir": 1.0, "gmv": 0.0, "still": 1.0, "goX": null, "pend": null, "joy": null, "sc": null, "scCd": 0.0, "invT": 0.0, "stun": 0.0, "alert": J.max_([0.0, J.sub(J.gp(v_I_1182, "alert"), (J.sub(J.gp(v_g0_1180, "t"), J.gp(v_I_1182, "leftT")) * 1.0))]), "calmT": 0.0, "flags": {}, "actors": [], "spots": [], "search": [], "floats": [], "parts": [], "fx": [], "light": [], "dark": [], "cam": {"x": 0.0, "free": null}, "msg": null, "msgT": 0.0, "task": J.gp(v_I_1182, "task"), "searchP": 0.0, "searchI": (-1.0), "stealP": 0.0, "lastSeen": 0.0, "kickT": 0.0, "flash": 0.0}
	env["S"] = _t1074
	var _t1075 = J.gp(v_lay_1181, "rooms")
	J.mc(_t1075, "forEach", [Callable(self, "_f199").bind(env)])
	var _t1078 = J.gp(v_lay_1181, "spots")
	J.mc(_t1078, "forEach", [Callable(self, "_f200").bind(env)])
	var _t1080 = J.gp(env["S"], "spots")
	J.mc(_t1080, "forEach", [Callable(self, "_f201").bind(env)])
	var _t1083 = J.gp(v_lay_1181, "search")
	J.mc(_t1083, "forEach", [Callable(self, "_f202").bind(env)])
	v_T_1183 = J.gp(env["S"], "task")
	if J.seq(J.gp(v_T_1183, "k"), "media"):
		var _t1089 = ["tv", "pc", "radio"]
		v_mk_1184 = J.mc(_t1089, "find", [Callable(self, "_f203").bind(env)])
		if (not J.t(v_mk_1184)):
			J.sp(v_T_1183, "k", "allout")
		else:
			J.sp(v_T_1183, "spot", v_mk_1184)
	if J.seq(J.gp(v_T_1183, "k"), "steal"):
		var _t1091 = J.gp(v_lay_1181, "steal")
		var _t1092 = (J.gp(J.gp(v_lay_1181, "steal"), J.gp(v_T_1183, "at")) if J.t(_t1091) else _t1091)
		v_sp_1185 = (_t1092 if J.t(_t1092) else null)
		v_ac0_1186 = J.gp(J.gp(v_lay_1181, "acts"), J.gp(v_T_1183, "at"))
		var _t1093 = (J.gp(v_sp_1185, "x") if J.t(v_sp_1185) else (J.gp(v_ac0_1186, "x") if J.t(v_ac0_1186) else J.add(J.gp(v_lay_1181, "door"), 120.0)))
		J.sp(v_T_1183, "x", _t1093)
		var _t1094 = (J.gp(v_sp_1185, "y") if J.t(v_sp_1185) else J.sub(J.gp(v_lay_1181, "floor"), 60.0))
		J.sp(v_T_1183, "y", _t1094)
	var _t1095 = (J.add("偷走", J.gp(v_T_1183, "o")) if J.seq(J.gp(v_T_1183, "k"), "steal") else ("令全屋人走晒（嚇到佢哋奔出屋）" if J.seq(J.gp(v_T_1183, "k"), "allout") else (((J.add("趁住客沖緊涼，喺", J.gp(J.gp(J.gp(v_lay_1181, "rooms"), 3.0), "n")) + "嚇親佢") if J.seq(J.gp(v_T_1183, "room"), "bath") else "趁住客煮緊嘢食，喺廚房嚇親佢") if J.seq(J.gp(v_T_1183, "k"), "room") else ("趁住客睇緊電視，搞部電視" if J.seq(J.gp(v_T_1183, "spot"), "tv") else ("趁住客打緊機，搞部電腦" if J.seq(J.gp(v_T_1183, "spot"), "pc") else "趁住客聽緊收音機，搞部收音機")))))
	J.sp(v_T_1183, "t", _t1095)
	var _t1096 = J.gp(v_un_1179, "rs")
	J.mc(_t1096, "forEach", [Callable(self, "_f205").bind(env)])
	var _t1099 = J.gp(env["S"], "actors")
	J.mc(_t1099, "forEach", [Callable(self, "_f206").bind(env)])
	if J.t(J.gp(v_I_1182, "lights")):
		var _t1103 = env["S"]
		var _t1104 = J.gp(env["S"], "light")
		var _t1105 = J.mc(_t1104, "map", [Callable(self, "_f207").bind(env)])
		J.sp(_t1103, "light", _t1105)
	J.sp(v_g_1178, "inUnit", v_un_1179)
	J.sp(v_g_1178, "to", null)
	J.sp(v_g_1178, "auto", null)
	J.sp(v_g_1178, "autoS", null)
	J.sp(v_g_1178, "taskP", 0.0)
	J.sp(v_g_1178, "sc", null)
	J.sp(v_g_1178, "still", 1.0)
	var _t1106 = J.gp(env["S"], "cam")
	var _t1107 = env["clamp"]
	var _t1108 = J.cl(_t1107, null, [J.sub(J.gp(env["S"], "gx"), 180.0), 0.0, J.gp(v_lay_1181, "W")])
	J.sp(_t1106, "x", _t1108)
	var _t1109 = env["S"]
	J.sp(_t1109, "invT", 2.0)
	J.mc(env["SND"], "door", [])
	var _t1110 = env["hideNative"]
	J.cl(_t1110, null, [true])
	v_hh_1187 = J.gp(J.gp(env["A"], "HH"), J.gp(v_un_1179, "hh"))
	var _t1111 = env["msg"]
	J.cl(_t1111, null, [J.add((J.add(J.add("入咗", J.gp(J.gp(env["A"], "FLN"), J.gp(v_un_1179, "f"))), (J.gp(v_hh_1187, "n") if J.t(v_hh_1187) else "住戶")) + "：熄咗燈嘅房先好郁手；撳作怪點、撳住客嚇人。屋內任務："), J.gp(v_T_1183, "t")), "#efdcb4"])
	var _t1112 = env["S"]
	J.sp(_t1112, "msgT", 5.5)
	var _t1113 = J.seq(J.gp(J.gp(v_g_1178, "d"), "key"), "toyol")
	var _t1114 = (J.gp(v_un_1179, "beans") if _t1113 else _t1113)
	if J.t(((not J.t(J.gp(v_un_1179, "beansDone"))) if J.t(_t1114) else _t1114)):
		J.sp(v_un_1179, "beansDone", true)
		var _t1115 = env["S"]
		J.sp(_t1115, "stun", 2.6)
		var _t1116 = env["wfl"]
		J.cl(_t1116, null, [J.gp(env["S"], "gx"), (J.sub(J.gp(v_lay_1181, "floor"), J.gp(v_lay_1181, "ph")) - 30.0), "地下有綠豆！忍唔住坐低數……", "#b8f0a0"])
	if J.t(J.gp(v_I_1182, "done")):
		var _t1117 = J.gp(env["S"], "task")
		J.sp(_t1117, "done", true)

func _f208(this_, a: Array, env):
	var v_r_1218 = null; var v_i_1219 = null; var v_place_1220 = null; var v_a_1221 = null
	v_r_1218 = J.arg(a, 0)
	v_i_1219 = J.arg(a, 1)
	v_place_1220 = J.arg(a, 2)
	v_a_1221 = {"r": v_r_1218, "i": v_i_1219, "x": J.add(J.gp(J.gp(env["S"], "lay"), "door"), 60.0), "dir": 1.0, "act": null, "actT": 0.0, "st": "walk", "tx": null, "pose": "stand", "seeT": 0.0, "hitT": (-9.0), "goT": 0.0, "lightT": 0.0, "ex": false}
	if J.t(v_place_1220):
		var _t1118 = env["pickAct"]
		J.cl(_t1118, null, [v_a_1221, true])
		var _t1119 = J.gp(v_a_1221, "tx")
		J.sp(v_a_1221, "x", _t1119)
		J.sp(v_a_1221, "st", "act")
		var _t1120 = env["actPose"]
		var _t1121 = J.cl(_t1120, null, [v_a_1221])
		J.sp(v_a_1221, "pose", _t1121)
	return v_a_1221

func _f209(this_, a: Array, env):
	var v_a_1224 = null; var v_d_1225 = null
	v_a_1224 = J.arg(a, 0)
	var _t1122 = J.gp(J.gp(J.gp(env["S"], "lay"), "acts"), J.gp(v_a_1224, "act"))
	v_d_1225 = (_t1122 if J.t(_t1122) else {})
	var _t1123 = J.gp(v_d_1225, "pose")
	return (_t1123 if J.t(_t1123) else "stand")

func _f211(this_, a: Array, env):
	var v_o_1238 = null
	v_o_1238 = J.arg(a, 0)
	var _t1135 = (not J.seq(v_o_1238, env["a"]))
	return (J.seq(J.gp(v_o_1238, "act"), env["k"]) if _t1135 else _t1135)

func _f210(this_, a: Array, env):
	var v_first_1229 = null; var v_r_1230 = null; var v_lay_1231 = null; var v_d_1233 = null; var v_x_1234 = null; var v_same_1235 = null
	var _s459 = {"__p": env, "a": null, "k": null}
	_s459["a"] = J.arg(a, 0)
	v_first_1229 = J.arg(a, 1)
	v_r_1230 = J.gp(_s459["a"], "r")
	v_lay_1231 = J.gp(_s459["__p"]["S"], "lay")
	if (not J.t(J.gp(v_r_1230, "awake"))):
		_s459["k"] = "bed"
	else:
		var _t1124 = _s459["__p"]["wpick"]
		var _t1125 = J.gp(_s459["__p"]["WANT"], J.gp(v_r_1230, "hh"))
		var _t1126 = J.cl(_t1124, null, [(_t1125 if J.t(_t1125) else [["sofa", 1.0]])])
		_s459["k"] = _t1126
		if (not J.t(J.gp(J.gp(v_lay_1231, "acts"), _s459["k"]))):
			_s459["k"] = "sofa"
		var _t1127 = J.seq(J.gp(_s459["a"], "act"), _s459["k"])
		var _t1128 = ((not J.t(v_first_1229)) if _t1127 else _t1127)
		if ((not J.seq(_s459["k"], "table")) if _t1128 else _t1128):
			var _t1129 = _s459["__p"]["wpick"]
			var _t1130 = J.gp(_s459["__p"]["WANT"], J.gp(v_r_1230, "hh"))
			var _t1131 = J.cl(_t1129, null, [(_t1130 if J.t(_t1130) else [["sofa", 1.0]])])
			_s459["k"] = _t1131
	var _t1132 = J.gp(J.gp(v_lay_1231, "acts"), _s459["k"])
	var _t1133 = (_t1132 if J.t(_t1132) else J.gp(J.gp(v_lay_1231, "acts"), "sofa"))
	v_d_1233 = (_t1133 if J.t(_t1133) else {"x": J.add(J.gp(v_lay_1231, "door"), 150.0)})
	v_x_1234 = J.gp(v_d_1233, "x")
	var _t1134 = J.gp(_s459["__p"]["S"], "actors")
	v_same_1235 = J.len(J.mc(_t1134, "filter", [Callable(self, "_f211").bind(_s459)]))
	var _t1136 = J.seq(_s459["k"], "table")
	if J.t((J.gp(v_d_1233, "seats") if _t1136 else _t1136)):
		var _t1137 = J.gp(J.gp(v_d_1233, "seats"), J.mod(J.gp(_s459["a"], "i"), J.len(J.gp(v_d_1233, "seats"))))
		v_x_1234 = _t1137
	else:
		if J.t(v_same_1235):
			var _t1138 = J.add(v_x_1234, ((((-1.0) if J.t(J.mod(v_same_1235, 2.0)) else 1.0) * ceil(J.num(J.div(v_same_1235, 2.0)))) * (110.0 if J.seq(_s459["k"], "bed") else 70.0)))
			v_x_1234 = _t1138
	var _t1139 = _s459["a"]
	var _t1140 = _s459["k"]
	J.sp(_t1139, "act", _t1140)
	var _t1141 = _s459["a"]
	var _t1142 = _s459["__p"]["clamp"]
	var _t1143 = J.cl(_t1142, null, [v_x_1234, J.add(J.gp(J.gp(J.gp(v_lay_1231, "rooms"), 0.0), "x0"), 30.0), J.sub(J.gp(J.gp(J.gp(v_lay_1231, "rooms"), (J.len(J.gp(v_lay_1231, "rooms")) - 1.0)), "x1"), 30.0)])
	J.sp(_t1141, "tx", _t1143)
	var _t1144 = _s459["a"]
	var _t1145 = (1000000000.0 if J.seq(_s459["k"], "bed") else ((40.0 + J.mul(J.cl(_s459["__p"]["rnd"], null, []), 20.0)) if J.seq(_s459["k"], "table") else (9.0 + J.mul(J.cl(_s459["__p"]["rnd"], null, []), 9.0))))
	J.sp(_t1144, "actT", _t1145)
	var _t1146 = _s459["a"]
	J.sp(_t1146, "st", "walk")
	var _t1147 = _s459["a"]
	J.sp(_t1147, "pose", "stand")

func _f224(this_, a: Array, env):
	var v_p_1307 = null; var v_i_1308 = null
	v_p_1307 = J.arg(a, 0)
	v_i_1308 = J.arg(a, 1)
	var _t1152 = J.cmp(absf(J.num(J.sub(J.gp(v_p_1307, "x"), J.gp(env["__p"]["S"], "gx")))), env["bd"], "<")
	if J.t(_t1152):
		var _t1151 = env["__p"]["itemsAt"]
		_t1152 = J.len(J.cl(_t1151, null, [v_i_1308]))
	if J.t(_t1152):
		var _t1153 = absf(J.num(J.sub(J.gp(v_p_1307, "x"), J.gp(env["__p"]["S"], "gx"))))
		env["bd"] = _t1153
		env["near"] = v_i_1308

func _f225(this_, a: Array, env):
	var v_k_1311 = null; var v_I_1312 = null
	v_k_1311 = J.arg(a, 0)
	v_I_1312 = J.gp(J.gp(env["__p"]["A"], "ITEM"), v_k_1311)
	var _t1173 = (not J.t(J.gp(v_I_1312, "who")))
	return (_t1173 if _t1173 else J.seq(J.gp(v_I_1312, "who"), J.gp(J.gp(env["g"], "d"), "key")))

func _f223(this_, a: Array, env):
	var v_dt_1293 = null; var v_g0_1295 = null; var v_lay_1296 = null; var v_un_1297 = null; var v_st_1300 = null; var v_it_1301 = null; var v_k0_1302 = null; var v_w_1303 = null; var v_ix_1304 = null
	var _s497 = {"__p": env, "g": null, "near": null, "bd": null}
	v_dt_1293 = J.arg(a, 0)
	_s497["g"] = J.gp(_s497["__p"]["S"], "g")
	v_g0_1295 = J.cl(_s497["__p"]["G"], null, [])
	v_lay_1296 = J.gp(_s497["__p"]["S"], "lay")
	v_un_1297 = J.gp(_s497["__p"]["S"], "un")
	_s497["near"] = (-1.0)
	_s497["bd"] = 70.0
	var _t1148 = J.seq(J.gp(J.gp(_s497["__p"]["S"], "task"), "k"), "steal")
	var _t1149 = ((not J.t(J.gp(J.gp(_s497["__p"]["S"], "task"), "done"))) if _t1148 else _t1148)
	if (J.cmp(absf(J.num(J.sub(J.gp(_s497["__p"]["S"], "gx"), J.gp(J.gp(_s497["__p"]["S"], "task"), "x")))), _s497["bd"], "<") if _t1149 else _t1149):
		_s497["near"] = 99.0
	else:
		var _t1150 = J.gp(_s497["__p"]["S"], "search")
		J.mc(_t1150, "forEach", [Callable(self, "_f224").bind(_s497)])
	var _t1154 = J.cmp(J.gp(_s497["__p"]["S"], "still"), 0.12, ">=")
	var _t1155 = (J.cmp(J.gp(_s497["__p"]["S"], "stun"), 0.0, "<=") if _t1154 else _t1154)
	var _t1156 = ((not J.t(J.gp(_s497["__p"]["S"], "sc"))) if _t1155 else _t1155)
	v_st_1300 = (J.cmp(J.gp(_s497["__p"]["S"], "t"), 0.8, ">") if _t1156 else _t1156)
	var _t1157 = J.cmp(_s497["near"], 0.0, "<")
	if (_t1157 if _t1157 else (not J.t(v_st_1300))):
		if (not J.seq(J.gp(_s497["__p"]["S"], "searchI"), _s497["near"])):
			var _t1158 = _s497["__p"]["S"]
			J.sp(_t1158, "searchP", 0.0)
		var _t1159 = _s497["__p"]["S"]
		var _t1160 = _s497["near"]
		J.sp(_t1159, "searchI", _t1160)
		return null
	if (not J.seq(J.gp(_s497["__p"]["S"], "searchI"), _s497["near"])):
		var _t1161 = _s497["__p"]["S"]
		var _t1162 = _s497["near"]
		J.sp(_t1161, "searchI", _t1162)
		var _t1163 = _s497["__p"]["S"]
		J.sp(_t1163, "searchP", 0.0)
	if J.seq(_s497["near"], 99.0):
		var _t1164 = _s497["__p"]["S"]
		var _t1166 = J.mul(v_dt_1293, J.gp(J.gp(v_g0_1295, "mods"), "task"))
		var _t1165 = J.gp(_s497["g"], "tm")
		var _t1167 = J.add(J.gp(_t1164, "searchP"), J.div(J.mul(_t1166, (_t1165 if J.t(_t1165) else 1.0)), 2.4))
		J.sp(_t1164, "searchP", _t1167)
		if J.cmp(J.cl(_s497["__p"]["rnd"], null, []), J.mul(v_dt_1293, 8.0), "<"):
			var _t1168 = _s497["__p"]["part"]
			J.cl(_t1168, null, [J.add(J.gp(J.gp(_s497["__p"]["S"], "task"), "x"), (J.sub(J.cl(_s497["__p"]["rnd"], null, []), 0.5) * 30.0)), J.gp(J.gp(_s497["__p"]["S"], "task"), "y"), (J.sub(J.cl(_s497["__p"]["rnd"], null, []), 0.5) * 60.0), (-80.0), 0.6, "dust"])
		if J.cmp(J.gp(_s497["__p"]["S"], "searchP"), 1.0, ">="):
			var _t1169 = _s497["__p"]["S"]
			J.sp(_t1169, "searchP", 0.0)
			var _t1170 = J.gp(_s497["__p"]["S"], "task")
			J.sp(_t1170, "done", true)
			J.cl(_s497["__p"]["taskDone"], null, [])
		return null
	var _t1171 = _s497["__p"]["itemsAt"]
	var _t1172 = J.cl(_t1171, null, [_s497["near"]])
	v_it_1301 = J.mc(_t1172, "find", [Callable(self, "_f225").bind(_s497)])
	if (not J.t(v_it_1301)):
		if (not J.t(J.gp(J.gp(_s497["__p"]["S"], "flags"), J.add("who", _s497["near"])))):
			var _t1174 = J.gp(_s497["__p"]["S"], "flags")
			var _t1175 = J.add("who", _s497["near"])
			J.sp(_t1174, _t1175, 1.0)
			var _t1176 = _s497["__p"]["itemsAt"]
			v_k0_1302 = J.gp(J.cl(_t1176, null, [_s497["near"]]), 0.0)
			v_w_1303 = J.gp(J.gp(J.gp(_s497["__p"]["A"], "ITEM"), v_k0_1302), "who")
			var _t1177 = _s497["__p"]["wfl"]
			var _t1180 = J.gp(J.gp(J.gp(_s497["__p"]["S"], "search"), _s497["near"]), "x")
			var _t1181 = J.sub(J.gp(J.gp(J.gp(_s497["__p"]["S"], "search"), _s497["near"]), "y"), 50.0)
			var _t1179 = J.add(J.gp(J.gp(J.gp(_s497["__p"]["A"], "ITEM"), v_k0_1302), "n"), "要")
			var _t1178 = J.gp({"eking": "餓鬼", "toyol": "Toyol", "tianhua": "天花姐"}, v_w_1303)
			J.cl(_t1177, null, [_t1180, _t1181, (J.add(_t1179, (_t1178 if J.t(_t1178) else "其他鬼")) + "先拎得"), "#e6a85a"])
		return null
	var _t1182 = (not J.seq(v_it_1301, "doll"))
	var _t1183 = ((not J.seq(v_it_1301, "key")) if _t1182 else _t1182)
	var _t1184 = ((not J.seq(v_it_1301, "key2")) if _t1183 else _t1183)
	var _t1185 = ((not J.seq(v_it_1301, "lost")) if _t1184 else _t1184)
	if (J.cmp(J.len(J.gp(v_g0_1295, "bag")), J.gp(_s497["__p"]["A"], "BAGMAX"), ">=") if _t1185 else _t1185):
		if (not J.t(J.gp(J.gp(_s497["__p"]["S"], "flags"), "full"))):
			var _t1186 = J.gp(_s497["__p"]["S"], "flags")
			J.sp(_t1186, "full", 1.0)
			var _t1187 = _s497["__p"]["wfl"]
			J.cl(_t1187, null, [J.gp(_s497["__p"]["S"], "gx"), (J.sub(J.gp(v_lay_1296, "floor"), J.gp(v_lay_1296, "ph")) - 20.0), "收穫格滿咗！", "#e48a78"])
		return null
	var _t1188 = _s497["__p"]["S"]
	var _t1190 = J.mul(v_dt_1293, J.gp(J.gp(v_g0_1295, "mods"), "task"))
	var _t1189 = J.gp(_s497["g"], "tm")
	var _t1191 = J.add(J.gp(_t1188, "searchP"), J.div(J.mul(_t1190, (_t1189 if J.t(_t1189) else 1.0)), J.gp(J.gp(J.gp(_s497["__p"]["A"], "ITEM"), v_it_1301), "t")))
	J.sp(_t1188, "searchP", _t1191)
	if J.cmp(J.gp(_s497["__p"]["S"], "searchP"), 1.0, ">="):
		var _t1192 = _s497["__p"]["S"]
		J.sp(_t1192, "searchP", 0.0)
		var _t1193 = J.gp(v_un_1297, "items")
		v_ix_1304 = J.mc(_t1193, "indexOf", [v_it_1301])
		if J.cmp(v_ix_1304, 0.0, ">="):
			var _t1194 = J.gp(v_un_1297, "items")
			J.mc(_t1194, "splice", [v_ix_1304, 1.0])
			J.mc(_s497["__p"]["A"], "takeItem", [_s497["g"], v_it_1301, v_un_1297])
			var _t1195 = _s497["__p"]["wfl"]
			J.cl(_t1195, null, [J.gp(J.gp(J.gp(_s497["__p"]["S"], "search"), _s497["near"]), "x"), J.sub(J.gp(J.gp(J.gp(_s497["__p"]["S"], "search"), _s497["near"]), "y"), 60.0), (J.add("搜到", J.gp(J.gp(J.gp(_s497["__p"]["A"], "ITEM"), v_it_1301), "n")) + "！"), "#e6a85a"])

func _f227(this_, a: Array, env):
	var v_k_1320 = null; var v_j_1321 = null
	v_k_1320 = J.arg(a, 0)
	v_j_1321 = J.arg(a, 1)
	if J.seq(J.mod(v_j_1321, env["n"]), env["i"]):
		J.mc(env["out"], "push", [v_k_1320])

func _f226(this_, a: Array, env):
	var _s512 = {"__p": env, "i": null, "n": null, "out": null}
	_s512["i"] = J.arg(a, 0)
	_s512["n"] = J.len(J.gp(_s512["__p"]["S"], "search"))
	_s512["out"] = []
	var _t1196 = J.gp(J.gp(_s512["__p"]["S"], "un"), "items")
	J.mc(_t1196, "forEach", [Callable(self, "_f227").bind(_s512)])
	return _s512["out"]

func _f230(this_, a: Array, env):
	var v_a_1336 = null
	v_a_1336 = J.arg(a, 0)
	return J.seq(J.gp(v_a_1336, "r"), env["r"])

func _f229(this_, a: Array, env):
	var v_i_1332 = null; var v_a_1333 = null
	var _s515 = {"__p": env, "r": null}
	_s515["r"] = J.arg(a, 0)
	v_i_1332 = J.arg(a, 1)
	var _t1198 = J.seq(J.gp(_s515["r"], "state"), "home")
	var _t1200 = ((not J.cmp(J.gp(_s515["r"], "fleeAfter"), 0.0, ">")) if _t1198 else _t1198)
	if J.t(_t1200):
		var _t1199 = J.gp(_s515["__p"]["__p"]["S"], "actors")
		_t1200 = (not J.t(J.mc(_t1199, "some", [Callable(self, "_f230").bind(_s515)])))
	if _t1200:
		var _t1201 = _s515["__p"]["__p"]["mkActor"]
		v_a_1333 = J.cl(_t1201, null, [_s515["r"], v_i_1332, false])
		var _t1202 = J.add(_s515["__p"]["door"], 20.0)
		J.sp(v_a_1333, "x", _t1202)
		var _t1203 = _s515["__p"]["__p"]["pickAct"]
		J.cl(_t1203, null, [v_a_1333])
		var _t1204 = J.gp(_s515["__p"]["__p"]["S"], "actors")
		J.mc(_t1204, "push", [v_a_1333])
		var _t1205 = _s515["__p"]["__p"]["sayR"]
		J.cl(_t1205, null, [_s515["r"], "返到屋企喇……"])

func _f232(this_, a: Array, env):
	var v_p_1351 = null
	v_p_1351 = J.arg(a, 0)
	return J.seq(J.gp(v_p_1351, "k"), J.gp(env["d0"], "look"))

func _f233(this_, a: Array, env):
	var v_o_1354 = null
	v_o_1354 = J.arg(a, 0)
	var _t1276 = (not J.seq(v_o_1354, env["a"]))
	var _t1278 = ((not J.t(J.gp(J.gp(v_o_1354, "r"), "awake"))) if _t1276 else _t1276)
	if J.t(_t1278):
		var _t1277 = env["__p"]["__p"]["roomAt"]
		_t1278 = J.seq(J.cl(_t1277, null, [J.gp(v_o_1354, "x")]), env["ri"])
	return _t1278

func _f231(this_, a: Array, env):
	var v_r_1340 = null; var v_run_1341 = null; var v_spd_1342 = null; var v_d_1343 = null; var v_w_1344 = null; var v_sp_1346 = null; var v_sleepers_1348 = null
	var _s518 = {"__p": env, "a": null, "d0": null, "ri": null}
	_s518["a"] = J.arg(a, 0)
	v_r_1340 = J.gp(_s518["a"], "r")
	var _t1207 = _s518["a"]
	var _t1208 = J.max_([0.0, J.sub(J.gp(_s518["a"], "seeT"), J.mul(_s518["__p"]["dt"], 0.5))])
	J.sp(_t1207, "seeT", _t1208)
	var _t1209 = _s518["a"]
	var _t1210 = J.max_([0.0, J.sub(J.gp(_s518["a"], "lightT"), _s518["__p"]["dt"])])
	J.sp(_t1209, "lightT", _t1210)
	var _t1211 = (not J.seq(J.gp(v_r_1340, "state"), "home"))
	if (_t1211 if _t1211 else J.cmp(J.gp(v_r_1340, "fleeAfter"), 0.0, ">")):
		var _t1212 = J.seq(J.gp(v_r_1340, "state"), "flee")
		var _t1213 = (_t1212 if _t1212 else J.seq(J.gp(v_r_1340, "state"), "gone"))
		v_run_1341 = (_t1213 if _t1213 else J.cmp(J.gp(v_r_1340, "fleeAfter"), 0.0, ">"))
		var _t1214 = _s518["a"]
		J.sp(_t1214, "pose", "stand")
		var _t1215 = _s518["a"]
		var _t1216 = ("run" if J.t(v_run_1341) else "leave")
		J.sp(_t1215, "st", _t1216)
		v_spd_1342 = (360.0 if J.t(v_run_1341) else 110.0)
		var _t1217 = _s518["a"]
		var _t1218 = (-1.0)
		J.sp(_t1217, "dir", _t1218)
		if J.cmp(J.gp(_s518["a"], "x"), J.sub(_s518["__p"]["door"], 30.0), ">"):
			var _t1219 = _s518["a"]
			var _t1220 = J.max_([J.sub(_s518["__p"]["door"], 30.0), J.sub(J.gp(_s518["a"], "x"), J.mul(v_spd_1342, _s518["__p"]["dt"]))])
			J.sp(_t1219, "x", _t1220)
			if J.t((J.cmp(J.cl(_s518["__p"]["__p"]["rnd"], null, []), J.mul(_s518["__p"]["dt"], 10.0), "<") if J.t(v_run_1341) else v_run_1341)):
				var _t1221 = _s518["__p"]["__p"]["part"]
				J.cl(_t1221, null, [J.add(J.gp(_s518["a"], "x"), 20.0), J.sub(J.gp(_s518["__p"]["lay"], "floor"), 6.0), 40.0, (-20.0), 0.5, "dust"])
		else:
			var _t1222 = _s518["a"]
			J.sp(_t1222, "hid", true)
		var _t1225 = (not J.seq(J.gp(v_r_1340, "state"), "home"))
		if J.t(_t1225):
			var _t1224 = J.gp(_s518["a"], "hid")
			if not J.t(_t1224):
				var _t1223 = (not J.seq(J.gp(v_r_1340, "state"), "flee"))
				_t1224 = ((not J.seq(J.gp(v_r_1340, "state"), "leave")) if _t1223 else _t1223)
			_t1225 = _t1224
		if J.t(_t1225):
			var _t1226 = _s518["a"]
			J.sp(_t1226, "gone", true)
			var _t1227 = J.seq(J.gp(v_r_1340, "state"), "flee")
			if (_t1227 if _t1227 else J.seq(J.gp(v_r_1340, "state"), "gone")):
				var _t1228 = _s518["__p"]["__p"]["iu"]
				var _t1229 = J.cl(_t1228, null, [_s518["__p"]["un"]])
				J.sp(_t1229, "fled", J.num(J.gp(_t1229, "fled")) + 1.0)
				var _t1230 = _s518["__p"]["__p"]["wfl"]
				J.cl(_t1230, null, [J.add(_s518["__p"]["door"], 60.0), (J.sub(J.gp(_s518["__p"]["lay"], "floor"), J.gp(_s518["__p"]["lay"], "ph")) - 40.0), "奔咗出屋！", "#b2d394"])
		return null
	var _t1231 = J.gp(v_r_1340, "react")
	if J.t(((not J.seq(J.gp(_s518["a"], "st"), "cower")) if J.t(_t1231) else _t1231)):
		var _t1232 = _s518["a"]
		J.sp(_t1232, "st", "cower")
		var _t1233 = _s518["a"]
		J.sp(_t1233, "cowT", 1.4)
	if J.seq(J.gp(_s518["a"], "st"), "cower"):
		var _t1234 = _s518["a"]
		var _t1235 = J.sub(J.gp(_t1234, "cowT"), _s518["__p"]["dt"])
		J.sp(_t1234, "cowT", _t1235)
		if J.cmp(J.gp(_s518["a"], "cowT"), 0.0, "<="):
			var _t1236 = _s518["a"]
			J.sp(_t1236, "st", "walk")
			if J.leq(J.gp(_s518["a"], "tx"), null):
				var _t1237 = _s518["__p"]["__p"]["pickAct"]
				J.cl(_t1237, null, [_s518["a"]])
		return null
	var _t1238 = (not J.t(J.gp(v_r_1340, "awake")))
	if ((not J.seq(J.gp(_s518["a"], "act"), "bed")) if _t1238 else _t1238):
		var _t1239 = _s518["__p"]["__p"]["pickAct"]
		J.cl(_t1239, null, [_s518["a"]])
	var _t1240 = J.gp(v_r_1340, "awake")
	if J.t((J.seq(J.gp(_s518["a"], "act"), "bed") if J.t(_t1240) else _t1240)):
		var _t1241 = _s518["__p"]["__p"]["pickAct"]
		J.cl(_t1241, null, [_s518["a"]])
		var _t1242 = _s518["a"]
		J.sp(_t1242, "pose", "stand")
	var _t1243 = J.seq(J.gp(_s518["a"], "st"), "walk")
	if (_t1243 if _t1243 else J.seq(J.gp(_s518["a"], "st"), "go")):
		v_d_1343 = J.sub(J.gp(_s518["a"], "tx"), J.gp(_s518["a"], "x"))
		v_w_1344 = ((150.0 if J.seq(J.gp(_s518["a"], "st"), "go") else 95.0) if J.t(J.gp(v_r_1340, "awake")) else 95.0)
		if (absf(J.num(v_d_1343)) < 3.0):
			var _t1244 = _s518["a"]
			var _t1245 = J.gp(_s518["a"], "tx")
			J.sp(_t1244, "x", _t1245)
			if J.seq(J.gp(_s518["a"], "st"), "go"):
				var _t1246 = _s518["a"]
				J.sp(_t1246, "st", "look")
				var _t1247 = _s518["a"]
				J.sp(_t1247, "lookT", 2.6)
				var _t1248 = _s518["a"]
				J.sp(_t1248, "pose", "stand")
			else:
				var _t1249 = _s518["a"]
				J.sp(_t1249, "st", "act")
				var _t1250 = _s518["a"]
				var _t1251 = _s518["__p"]["__p"]["actPose"]
				var _t1252 = J.cl(_t1251, null, [_s518["a"]])
				J.sp(_t1250, "pose", _t1252)
		else:
			var _t1253 = _s518["a"]
			var _t1254 = (1.0 if J.cmp(v_d_1343, 0.0, ">") else (-1.0))
			J.sp(_t1253, "dir", _t1254)
			var _t1255 = _s518["a"]
			var _t1256 = J.add(J.gp(_t1255, "x"), (signf(J.num(v_d_1343)) * J.min_([absf(J.num(v_d_1343)), J.mul(v_w_1344, _s518["__p"]["dt"])])))
			J.sp(_t1255, "x", _t1256)
			var _t1257 = _s518["a"]
			J.sp(_t1257, "pose", "stand")
	else:
		if J.seq(J.gp(_s518["a"], "st"), "look"):
			var _t1258 = _s518["a"]
			var _t1259 = J.sub(J.gp(_t1258, "lookT"), _s518["__p"]["dt"])
			J.sp(_t1258, "lookT", _t1259)
			var _t1260 = _s518["a"]
			var _t1261 = (1.0 if J.t(J.mod(floor(J.num(J.mul(J.gp(_s518["a"], "lookT"), 1.3))), 2.0)) else (-1.0))
			J.sp(_t1260, "dir", _t1261)
			if J.cmp(J.gp(_s518["a"], "lookT"), 0.0, "<="):
				var _t1262 = _s518["__p"]["__p"]["sayR"]
				var _t1263 = _s518["__p"]["__p"]["line"]
				J.cl(_t1262, null, [v_r_1340, J.cl(_t1263, null, ["look"])])
				var _t1264 = _s518["__p"]["__p"]["pickAct"]
				J.cl(_t1264, null, [_s518["a"]])
		else:
			if J.seq(J.gp(_s518["a"], "st"), "act"):
				var _t1265 = _s518["a"]
				var _t1266 = J.sub(J.gp(_t1265, "actT"), _s518["__p"]["dt"])
				J.sp(_t1265, "actT", _t1266)
				_s518["d0"] = J.gp(J.gp(_s518["__p"]["lay"], "acts"), J.gp(_s518["a"], "act"))
				if J.t((J.gp(_s518["d0"], "look") if J.t(_s518["d0"]) else _s518["d0"])):
					var _t1267 = J.gp(_s518["__p"]["__p"]["S"], "spots")
					v_sp_1346 = J.mc(_t1267, "find", [Callable(self, "_f232").bind(_s518)])
					if J.t(v_sp_1346):
						var _t1268 = _s518["a"]
						var _t1269 = (1.0 if J.cmp(J.gp(v_sp_1346, "x"), J.gp(_s518["a"], "x"), ">") else (-1.0))
						J.sp(_t1268, "dir", _t1269)
				if J.cmp(J.gp(_s518["a"], "actT"), 0.0, "<="):
					var _t1270 = _s518["__p"]["__p"]["pickAct"]
					J.cl(_t1270, null, [_s518["a"]])
	var _t1271 = _s518["__p"]["__p"]["roomAt"]
	_s518["ri"] = J.cl(_t1271, null, [J.gp(_s518["a"], "x")])
	var _t1272 = J.gp(v_r_1340, "awake")
	var _t1273 = ((not J.seq(J.gp(_s518["a"], "st"), "run")) if J.t(_t1272) else _t1272)
	var _t1274 = ((not J.t(J.gp(J.gp(_s518["__p"]["__p"]["S"], "light"), _s518["ri"]))) if J.t(_t1273) else _t1273)
	if J.t((J.cmp(J.gp(J.gp(_s518["__p"]["__p"]["S"], "dark"), _s518["ri"]), 0.0, "<=") if J.t(_t1274) else _t1274)):
		var _t1275 = J.gp(_s518["__p"]["__p"]["S"], "actors")
		v_sleepers_1348 = J.mc(_t1275, "some", [Callable(self, "_f233").bind(_s518)])
		var _t1279 = (not J.t(v_sleepers_1348))
		if (_t1279 if _t1279 else J.cmp(J.gp(_s518["__p"]["__p"]["S"], "alert"), 35.0, ">=")):
			if (not J.t(J.gp(_s518["a"], "lightT"))):
				var _t1280 = _s518["a"]
				J.sp(_t1280, "lightT", 1.4)
			else:
				if J.cmp(J.gp(_s518["a"], "lightT"), 0.05, "<="):
					var _t1281 = J.gp(_s518["__p"]["__p"]["S"], "light")
					var _t1282 = _s518["ri"]
					J.sp(_t1281, _t1282, true)
					var _t1283 = _s518["a"]
					J.sp(_t1283, "lightT", 0.0)
					var _t1284 = _s518["__p"]["__p"]["sayR"]
					var _t1285 = _s518["__p"]["__p"]["line"]
					J.cl(_t1284, null, [v_r_1340, J.cl(_t1285, null, ["lightOn"])])
					var _t1286 = _s518["__p"]["__p"]["tone"]
					J.cl(_t1286, null, [1200.0, 0.0, 0.05, 0.05, "square"])

func _f234(this_, a: Array, env):
	var v_a_1357 = null
	v_a_1357 = J.arg(a, 0)
	return (not J.t(J.gp(v_a_1357, "gone")))

func _f228(this_, a: Array, env):
	var v_g0_1328 = null
	var _s514 = {"__p": env, "dt": null, "lay": null, "un": null, "door": null}
	_s514["dt"] = J.arg(a, 0)
	_s514["lay"] = J.gp(_s514["__p"]["S"], "lay")
	_s514["un"] = J.gp(_s514["__p"]["S"], "un")
	_s514["door"] = J.gp(_s514["lay"], "door")
	v_g0_1328 = J.cl(_s514["__p"]["G"], null, [])
	var _t1197 = J.gp(_s514["un"], "rs")
	J.mc(_t1197, "forEach", [Callable(self, "_f229").bind(_s514)])
	var _t1206 = J.gp(_s514["__p"]["S"], "actors")
	J.mc(_t1206, "forEach", [Callable(self, "_f231").bind(_s514)])
	var _t1287 = _s514["__p"]["S"]
	var _t1288 = J.gp(_s514["__p"]["S"], "actors")
	var _t1289 = J.mc(_t1288, "filter", [Callable(self, "_f234").bind(_s514)])
	J.sp(_t1287, "actors", _t1289)

func _f237(this_, a: Array, env):
	var v_a_1369 = null
	v_a_1369 = J.arg(a, 0)
	var _t1295 = J.gp(J.gp(v_a_1369, "r"), "awake")
	var _t1297 = ((not J.seq(J.gp(v_a_1369, "st"), "run")) if J.t(_t1295) else _t1295)
	if J.t(_t1297):
		var _t1296 = env["__p"]["__p"]["roomAt"]
		_t1297 = J.seq(J.cl(_t1296, null, [J.gp(v_a_1369, "x")]), env["i"])
	return _t1297

func _f236(this_, a: Array, env):
	var v_on_1364 = null; var v_awake_1366 = null
	var _s545 = {"__p": env, "i": null}
	v_on_1364 = J.arg(a, 0)
	_s545["i"] = J.arg(a, 1)
	if J.cmp(J.gp(J.gp(_s545["__p"]["__p"]["S"], "dark"), _s545["i"]), 0.0, ">"):
		return false
	if J.t(_s545["__p"]["all"]):
		return true
	var _t1294 = J.gp(_s545["__p"]["__p"]["S"], "actors")
	v_awake_1366 = J.mc(_t1294, "some", [Callable(self, "_f237").bind(_s545)])
	var _t1298 = ((not J.t(v_awake_1366)) if J.t(v_on_1364) else v_on_1364)
	if J.t((J.cmp(J.gp(_s545["__p"]["__p"]["S"], "alert"), 35.0, "<") if J.t(_t1298) else _t1298)):
		var _t1299 = _s545["__p"]["__p"]["S"]
		var _t1300 = J.gp(_s545["__p"]["__p"]["S"], "offT")
		var _t1301 = (_t1300 if J.t(_t1300) else [])
		J.sp(_t1299, "offT", _t1301)
		var _t1302 = J.gp(_s545["__p"]["__p"]["S"], "offT")
		var _t1303 = _s545["i"]
		var _t1304 = J.gp(J.gp(_s545["__p"]["__p"]["S"], "offT"), _s545["i"])
		var _t1305 = J.add((_t1304 if J.t(_t1304) else 0.0), _s545["__p"]["dt"])
		J.sp(_t1302, _t1303, _t1305)
		if J.cmp(J.gp(J.gp(_s545["__p"]["__p"]["S"], "offT"), _s545["i"]), 8.0, ">"):
			var _t1306 = J.gp(_s545["__p"]["__p"]["S"], "offT")
			var _t1307 = _s545["i"]
			J.sp(_t1306, _t1307, 0.0)
			return false
	else:
		if J.t(J.gp(_s545["__p"]["__p"]["S"], "offT")):
			var _t1308 = J.gp(_s545["__p"]["__p"]["S"], "offT")
			var _t1309 = _s545["i"]
			J.sp(_t1308, _t1309, 0.0)
	return v_on_1364

func _f235(this_, a: Array, env):
	var _s544 = {"__p": env, "dt": null, "all": null}
	_s544["dt"] = J.arg(a, 0)
	var _t1291 = J.cmp(J.gp(_s544["__p"]["S"], "alert"), 85.0, ">=")
	if not J.t(_t1291):
		var _t1290 = _s544["__p"]["iu"]
		_t1291 = J.gp(J.cl(_t1290, null, [J.gp(_s544["__p"]["S"], "un")]), "lights")
	_s544["all"] = _t1291
	var _t1292 = _s544["__p"]["S"]
	var _t1293 = J.gp(_s544["__p"]["S"], "light")
	var _t1310 = J.mc(_t1293, "map", [Callable(self, "_f236").bind(_s544)])
	J.sp(_t1292, "light", _t1310)

func _f238(this_, a: Array, env):
	var v_a_1372 = null; var v_x_1373 = null
	v_a_1372 = J.arg(a, 0)
	v_x_1373 = J.arg(a, 1)
	var _t1311 = J.seq(signf(J.num(J.sub(v_x_1373, J.gp(v_a_1372, "x")))), J.gp(v_a_1372, "dir"))
	return (_t1311 if _t1311 else (absf(J.num(J.sub(v_x_1373, J.gp(v_a_1372, "x")))) < 70.0))

func _f240(this_, a: Array, env):
	var v_a_1385 = null; var v_r_1386 = null; var v_dx_1387 = null; var v_f_1388 = null; var v_rate_1389 = null
	v_a_1385 = J.arg(a, 0)
	v_r_1386 = J.gp(v_a_1385, "r")
	var _t1314 = (not J.t(J.gp(v_r_1386, "awake")))
	var _t1315 = (_t1314 if _t1314 else J.seq(J.gp(v_a_1385, "st"), "run"))
	var _t1317 = (_t1315 if _t1315 else J.seq(J.gp(v_a_1385, "st"), "cower"))
	if not J.t(_t1317):
		var _t1316 = J.seq(J.gp(v_a_1385, "act"), "shower")
		_t1317 = (J.seq(J.gp(v_a_1385, "st"), "act") if _t1316 else _t1316)
	if (_t1317 if _t1317 else J.seq(J.gp(v_a_1385, "act"), "bed")):
		return null
	var _t1318 = env["__p"]["roomAt"]
	if (not J.seq(J.cl(_t1318, null, [J.gp(v_a_1385, "x")]), env["gr"])):
		return null
	v_dx_1387 = absf(J.num(J.sub(J.gp(env["__p"]["S"], "gx"), J.gp(v_a_1385, "x"))))
	var _t1319 = env["__p"]["facing"]
	v_f_1388 = J.cl(_t1319, null, [v_a_1385, J.gp(env["__p"]["S"], "gx")])
	var _t1322 = J.seq(J.gp(v_a_1385, "st"), "act")
	if J.t(_t1322):
		var _t1320 = J.seq(J.gp(v_a_1385, "act"), "tv")
		var _t1321 = (_t1320 if _t1320 else J.seq(J.gp(v_a_1385, "act"), "pc"))
		_t1322 = (_t1321 if _t1321 else J.seq(J.gp(v_a_1385, "act"), "radio"))
	if (J.cmp(v_dx_1387, 70.0, ">=") if _t1322 else _t1322):
		v_f_1388 = false
	v_rate_1389 = 0.0
	if J.t((v_f_1388 if J.t(env["lit"]) else env["lit"])):
		v_rate_1389 = env["__p"]["SEE_LIT"]
	else:
		var _t1323 = (not J.t(env["lit"]))
		var _t1324 = (v_f_1388 if _t1323 else _t1323)
		if J.t((J.cmp(v_dx_1387, 110.0, "<") if J.t(_t1324) else _t1324)):
			v_rate_1389 = env["__p"]["SEE_DARK"]
	if (not J.t(v_rate_1389)):
		return null
	var _t1326 = (1.0 + (0.15 * J.min_([3.0, J.gp(env["g0"], "phase")])))
	var _t1325 = J.gp(v_r_1386, "brave")
	var _t1327 = J.mul(v_rate_1389, J.mul(_t1326, J.add(1.0, (_t1325 if J.t(_t1325) else 0.0))))
	v_rate_1389 = _t1327
	env["any"] = true
	var _t1328 = J.min_([3.0, J.add(J.gp(v_a_1385, "seeT"), J.mul(env["dt"], 1.5))])
	J.sp(v_a_1385, "seeT", _t1328)
	var _t1329 = J.cmp(J.gp(v_a_1385, "seeT"), 0.8, ">")
	if ((not J.t(J.gp(v_a_1385, "saw"))) if _t1329 else _t1329):
		J.sp(v_a_1385, "saw", true)
		var _t1330 = env["__p"]["sayR"]
		var _t1331 = env["__p"]["line"]
		J.cl(_t1330, null, [v_r_1386, J.cl(_t1331, null, ["see"])])
		J.mc(env["__p"]["SND"], "see", [])
		var _t1332 = env["__p"]["wfl"]
		J.cl(_t1332, null, [J.gp(v_a_1385, "x"), J.sub(J.gp(J.gp(env["__p"]["S"], "lay"), "floor"), J.mul(J.gp(J.gp(env["__p"]["S"], "lay"), "ph"), 1.15)), "！被睇到", "#e48a78"])
	if J.cmp(J.gp(v_a_1385, "seeT"), 0.8, ">"):
		J.mc(env["rates"], "push", [v_rate_1389])

func _f241(this_, a: Array, env):
	var v_a_1392 = null; var v_b_1393 = null
	v_a_1392 = J.arg(a, 0)
	v_b_1393 = J.arg(a, 1)
	return J.sub(v_b_1393, v_a_1392)

func _f242(this_, a: Array, env):
	var v_v_1396 = null; var v_i_1397 = null
	v_v_1396 = J.arg(a, 0)
	v_i_1397 = J.arg(a, 1)
	var _t1333 = env["__p"]["S"]
	var _t1334 = J.add(J.gp(_t1333, "alert"), J.mul((J.mul(v_v_1396, 0.25) if J.t(v_i_1397) else v_v_1396), env["dt"]))
	J.sp(_t1333, "alert", _t1334)

func _f243(this_, a: Array, env):
	var v_a_1400 = null
	v_a_1400 = J.arg(a, 0)
	if J.cmp(J.gp(v_a_1400, "seeT"), 0.1, "<"):
		J.sp(v_a_1400, "saw", false)

func _f239(this_, a: Array, env):
	var v_I_1382 = null
	var _s550 = {"__p": env, "dt": null, "g0": null, "gr": null, "lit": null, "any": null, "rates": null}
	_s550["dt"] = J.arg(a, 0)
	_s550["g0"] = J.cl(_s550["__p"]["G"], null, [])
	var _t1312 = _s550["__p"]["roomAt"]
	_s550["gr"] = J.cl(_t1312, null, [J.gp(_s550["__p"]["S"], "gx")])
	_s550["lit"] = J.gp(J.gp(_s550["__p"]["S"], "light"), _s550["gr"])
	_s550["any"] = false
	_s550["rates"] = []
	if J.cmp(J.gp(_s550["__p"]["S"], "invT"), 0.0, "<="):
		var _t1313 = J.gp(_s550["__p"]["S"], "actors")
		J.mc(_t1313, "forEach", [Callable(self, "_f240").bind(_s550)])
	J.mc(_s550["rates"], "sort", [Callable(self, "_f241").bind(_s550)])
	J.mc(_s550["rates"], "forEach", [Callable(self, "_f242").bind(_s550)])
	var _t1335 = _s550["__p"]["S"]
	var _t1336 = _s550["any"]
	J.sp(_t1335, "seenNow", _t1336)
	if J.t(_s550["any"]):
		var _t1337 = _s550["__p"]["S"]
		J.sp(_t1337, "calmT", 0.0)
	else:
		var _t1338 = _s550["__p"]["S"]
		var _t1339 = J.add(J.gp(_t1338, "calmT"), _s550["dt"])
		J.sp(_t1338, "calmT", _t1339)
		var _t1340 = J.gp(_s550["__p"]["S"], "actors")
		J.mc(_t1340, "forEach", [Callable(self, "_f243").bind(_s550)])
	var _t1341 = J.cmp(J.gp(_s550["__p"]["S"], "calmT"), 5.0, ">")
	if (J.cmp(J.gp(_s550["__p"]["S"], "alert"), 0.0, ">") if _t1341 else _t1341):
		var _t1342 = _s550["__p"]["iu"]
		v_I_1382 = J.cl(_t1342, null, [J.gp(_s550["__p"]["S"], "un")])
		var _t1343 = _s550["__p"]["S"]
		var _t1344 = J.max_([(30.0 if J.t(J.gp(v_I_1382, "lights")) else 0.0), J.sub(J.gp(_s550["__p"]["S"], "alert"), J.mul(2.5, _s550["dt"]))])
		J.sp(_t1343, "alert", _t1344)

func _f245(this_, a: Array, env):
	var v_a_1410 = null
	v_a_1410 = J.arg(a, 0)
	var _t1347 = J.gp(J.gp(v_a_1410, "r"), "awake")
	return ((not J.seq(J.gp(v_a_1410, "st"), "run")) if J.t(_t1347) else _t1347)

func _f246(this_, a: Array, env):
	var v_a_1413 = null
	v_a_1413 = J.arg(a, 0)
	return (not J.t(J.gp(J.gp(v_a_1413, "r"), "awake")))

func _f247(this_, a: Array, env):
	var v_a_1416 = null
	v_a_1416 = J.arg(a, 0)
	var _t1362 = J.gp(v_a_1416, "r")
	J.sp(_t1362, "awake", true)
	var _t1363 = J.gp(v_a_1416, "r")
	J.sp(_t1363, "woke", true)
	var _t1364 = J.gp(v_a_1416, "r")
	var _t1365 = J.gp(J.gp(v_a_1416, "r"), "fear")
	var _t1366 = J.gp(J.gp(v_a_1416, "r"), "fear")
	var _t1367 = J.min_([95.0, J.add((_t1366 if J.t(_t1366) else 0.0), 8.0)])
	J.sp(_t1364, "fear", _t1367)

func _f244(this_, a: Array, env):
	var v_dt_1403 = null; var v_I_1404 = null; var v_g0_1405 = null; var v_aw_1406 = null; var v_sl_1407 = null; var v_e_1417 = null
	v_dt_1403 = J.arg(a, 0)
	var _t1345 = env["iu"]
	v_I_1404 = J.cl(_t1345, null, [J.gp(env["S"], "un")])
	v_g0_1405 = J.cl(env["G"], null, [])
	var _t1346 = J.gp(env["S"], "actors")
	v_aw_1406 = J.mc(_t1346, "filter", [Callable(self, "_f245").bind(env)])
	var _t1348 = J.cmp(J.gp(env["S"], "alert"), 35.0, ">=")
	var _t1349 = ((not J.t(J.gp(J.gp(env["S"], "flags"), "t35"))) if _t1348 else _t1348)
	if J.t((J.len(v_aw_1406) if _t1349 else _t1349)):
		var _t1350 = J.gp(env["S"], "flags")
		J.sp(_t1350, "t35", 1.0)
		var _t1351 = env["sayR"]
		J.cl(_t1351, null, [J.gp(J.gp(v_aw_1406, 0.0), "r"), "開燈！全部開燈先！"])
		var _t1353 = J.gp(env["S"], "light")
		var _t1352 = env["roomAt"]
		var _t1354 = J.cl(_t1352, null, [J.gp(J.gp(v_aw_1406, 0.0), "x")])
		J.sp(_t1353, _t1354, true)
	var _t1355 = J.cmp(J.gp(env["S"], "alert"), 55.0, ">=")
	var _t1356 = ((not J.t(J.gp(J.gp(env["S"], "flags"), "t55"))) if _t1355 else _t1355)
	if J.t((J.len(v_aw_1406) if _t1356 else _t1356)):
		var _t1357 = J.gp(env["S"], "flags")
		J.sp(_t1357, "t55", 1.0)
		var _t1358 = J.gp(env["S"], "actors")
		v_sl_1407 = J.mc(_t1358, "filter", [Callable(self, "_f246").bind(env)])
		if J.t(J.len(v_sl_1407)):
			var _t1359 = env["sayR"]
			var _t1361 = J.gp(J.gp(v_aw_1406, 0.0), "r")
			var _t1360 = env["line"]
			J.cl(_t1359, null, [_t1361, J.cl(_t1360, null, ["wake"])])
			J.mc(v_sl_1407, "forEach", [Callable(self, "_f247").bind(env)])
			var _t1368 = env["msg"]
			J.cl(_t1368, null, ["有人叫醒晒全屋人！", "#e48a78"])
	var _t1369 = J.cmp(J.gp(env["S"], "alert"), 70.0, ">=")
	var _t1370 = ((not J.t(J.gp(v_I_1404, "phoned"))) if _t1369 else _t1369)
	if J.t((J.len(v_aw_1406) if _t1370 else _t1370)):
		J.sp(v_I_1404, "phoned", true)
		var _t1371 = env["sayR"]
		var _t1373 = J.gp(J.gp(v_aw_1406, 0.0), "r")
		var _t1372 = env["line"]
		J.cl(_t1371, null, [_t1373, J.cl(_t1372, null, ["phone"])])
		var _t1374 = J.add(J.gp(v_g0_1405, "alert"), 1.0)
		J.sp(v_g0_1405, "alert", _t1374)
		J.mc(env["A"], "checkAlert", [])
		J.mc(env["A"], "noise", [J.gp(J.gp(env["S"], "un"), "did"), 2.0])
		var _t1375 = env["msg"]
		J.cl(_t1375, null, ["住客打電話去管理處！全樓警覺 +1，保安會去門口睇", "#e48a78"])
	var _t1376 = J.cmp(J.gp(env["S"], "alert"), 85.0, ">=")
	if ((not J.t(J.gp(J.gp(env["S"], "flags"), "t85"))) if _t1376 else _t1376):
		var _t1377 = J.gp(env["S"], "flags")
		J.sp(_t1377, "t85", 1.0)
		J.sp(v_I_1404, "lights", true)
		if J.t(J.len(v_aw_1406)):
			var _t1378 = env["sayR"]
			var _t1380 = J.gp(J.gp(v_aw_1406, 0.0), "r")
			var _t1379 = env["line"]
			J.cl(_t1378, null, [_t1380, J.cl(_t1379, null, ["lights"])])
		var _t1381 = env["msg"]
		J.cl(_t1381, null, ["佢哋開晒全屋燈！行邊度都會現形", "#e48a78"])

func _f249(this_, a: Array, env):
	var v_a_1431 = null; var v_r_1432 = null; var v_ar_1433 = null; var v_same_1434 = null; var v_adj_1435 = null; var v_amt_1436 = null
	v_a_1431 = J.arg(a, 0)
	v_r_1432 = J.gp(v_a_1431, "r")
	var _t1406 = (not J.seq(J.gp(v_r_1432, "state"), "home"))
	if (_t1406 if _t1406 else J.seq(J.gp(v_a_1431, "st"), "run")):
		return null
	var _t1407 = env["__p"]["roomAt"]
	v_ar_1433 = J.cl(_t1407, null, [J.gp(v_a_1431, "x")])
	v_same_1434 = J.seq(v_ar_1433, env["rm"])
	v_adj_1435 = J.seq(absf(J.num(J.sub(v_ar_1433, env["rm"]))), 1.0)
	var _t1409 = (not J.t(v_same_1434))
	if J.t(_t1409):
		var _t1408 = J.gp(env["H"], "loud")
		_t1409 = (not J.t((v_adj_1435 if J.t(_t1408) else _t1408)))
	if _t1409:
		return null
	v_amt_1436 = J.mul(J.gp(env["H"], "f"), (1.0 if J.t(v_same_1434) else 0.35))
	var _t1410 = (v_same_1434 if J.t(env["media"]) else env["media"])
	var _t1412 = (J.seq(J.gp(v_a_1431, "st"), "act") if J.t(_t1410) else _t1410)
	if J.t(_t1412):
		var _t1411 = J.gp(J.gp(J.gp(env["__p"]["S"], "lay"), "acts"), J.gp(v_a_1431, "act"))
		_t1412 = J.seq(J.gp((_t1411 if J.t(_t1411) else {}), "look"), J.gp(env["p"], "k"))
	if J.t(_t1412):
		var _t1413 = J.gp(env["__p"]["S"], "task")
		J.sp(_t1413, "done", true)
		J.cl(env["__p"]["taskDone"], null, [])
	if (not J.t(J.gp(v_r_1432, "awake"))):
		var _t1414 = (not J.t(J.gp(env["H"], "loud")))
		if ((not J.t(v_same_1434)) if _t1414 else _t1414):
			return null
		J.sp(v_r_1432, "awake", true)
		J.sp(v_r_1432, "woke", true)
		var _t1415 = J.mul(v_amt_1436, 0.6)
		v_amt_1436 = _t1415
		var _t1416 = env["__p"]["sayR"]
		var _t1417 = env["__p"]["pick"]
		J.cl(_t1416, null, [v_r_1432, J.cl(_t1417, null, [["咩聲呀……邊個？", "發開夢？"]])])
	else:
		var _t1418 = env["__p"]["sayR"]
		var _t1419 = env["__p"]["pick"]
		J.cl(_t1418, null, [v_r_1432, J.cl(_t1419, null, [J.gp(env["H"], "ln")])])
	var _t1420 = env["__p"]["addRFear"]
	J.cl(_t1420, null, [v_a_1431, v_amt_1436])
	env["hit"] = J.num(env["hit"]) + 1.0
	var _t1421 = (not J.t(v_same_1434))
	var _t1422 = ((not J.seq(J.gp(v_a_1431, "st"), "go")) if _t1421 else _t1421)
	if (J.cmp(J.cl(env["__p"]["rnd"], null, []), 0.6, "<") if _t1422 else _t1422):
		J.sp(v_a_1431, "st", "go")
		var _t1423 = env["__p"]["clamp"]
		var _t1424 = J.cl(_t1423, null, [J.add(J.gp(env["p"], "x"), (J.sub(J.cl(env["__p"]["rnd"], null, []), 0.5) * 60.0)), J.add(J.gp(J.gp(J.gp(J.gp(env["__p"]["S"], "lay"), "rooms"), env["rm"]), "x0"), 30.0), J.sub(J.gp(J.gp(J.gp(J.gp(env["__p"]["S"], "lay"), "rooms"), env["rm"]), "x1"), 30.0)])
		J.sp(v_a_1431, "tx", _t1424)
		var _t1425 = env["__p"]["sayR"]
		var _t1426 = env["__p"]["line"]
		J.cl(_t1425, null, [v_r_1432, J.cl(_t1426, null, ["go"])])
	var _t1427 = env["__p"]["roomTask"]
	J.cl(_t1427, null, [v_a_1431])

func _f248(this_, a: Array, env):
	var v_auto_1421 = null; var v_g0_1422 = null; var v_g_1423 = null; var v_i_1428 = null
	var _s570 = {"__p": env, "p": null, "H": null, "hit": null, "rm": null, "media": null}
	_s570["p"] = J.arg(a, 0)
	v_auto_1421 = J.arg(a, 1)
	v_g0_1422 = J.cl(_s570["__p"]["G"], null, [])
	v_g_1423 = J.gp(_s570["__p"]["S"], "g")
	_s570["H"] = J.gp(_s570["__p"]["HOT"], J.gp(_s570["p"], "k"))
	if J.cmp(J.gp(_s570["p"], "cd"), 0.0, ">"):
		if (not J.t(v_auto_1421)):
			var _t1382 = _s570["__p"]["wfl"]
			J.cl(_t1382, null, [J.gp(_s570["p"], "x"), J.sub(J.gp(_s570["p"], "y"), 40.0), (J.add(J.add(J.gp(_s570["H"], "v"), "冷卻緊 "), ceil(J.num(J.gp(_s570["p"], "cd")))) + " 秒"), "#ddd2bd"])
		return false
	var _t1383 = _s570["__p"]["roomAt"]
	var _t1384 = (not J.seq(J.cl(_t1383, null, [J.gp(_s570["__p"]["S"], "gx")]), J.gp(_s570["p"], "room")))
	if (_t1384 if _t1384 else J.cmp(absf(J.num(J.sub(J.gp(_s570["__p"]["S"], "gx"), J.gp(_s570["p"], "x")))), _s570["__p"]["RANGE_HOT"], ">")):
		var _t1385 = _s570["__p"]["S"]
		var _t1386 = _s570["__p"]["clamp"]
		var _t1387 = J.cl(_t1386, null, [J.gp(_s570["p"], "x"), J.add(J.gp(J.gp(J.gp(J.gp(_s570["__p"]["S"], "lay"), "rooms"), J.gp(_s570["p"], "room")), "x0"), 20.0), J.sub(J.gp(J.gp(J.gp(J.gp(_s570["__p"]["S"], "lay"), "rooms"), J.gp(_s570["p"], "room")), "x1"), 20.0)])
		J.sp(_t1385, "goX", _t1387)
		var _t1388 = _s570["__p"]["S"]
		var _t1389 = {"k": "hot", "p": _s570["p"]}
		J.sp(_t1388, "pend", _t1389)
		return false
	if J.cmp(J.gp(_s570["__p"]["S"], "stun"), 0.0, ">"):
		return false
	var _t1390 = _s570["p"]
	J.sp(_t1390, "cd", 14.0)
	var _t1391 = _s570["p"]
	J.sp(_t1391, "t", 2.6)
	var _t1392 = _s570["__p"]["S"]
	var _t1393 = (1.0 if J.cmp(J.gp(_s570["p"], "x"), J.gp(_s570["__p"]["S"], "gx"), ">") else (-1.0))
	J.sp(_t1392, "gdir", _t1393)
	var _t1394 = _s570["__p"]["S"]
	var _t1395 = J.add(J.gp(_t1394, "alert"), 4.0)
	J.sp(_t1394, "alert", _t1395)
	var _t1396 = _s570["__p"]["S"]
	J.sp(_t1396, "calmT", 0.0)
	J.mc(_s570["__p"]["SND"], "hot", [J.gp(_s570["p"], "k")])
	var _t1397 = _s570["__p"]["wfl"]
	J.cl(_t1397, null, [J.gp(_s570["p"], "x"), J.sub(J.gp(_s570["p"], "y"), 50.0), J.add(J.gp(_s570["H"], "v"), "！"), "#e8a088"])
	if J.seq(J.gp(_s570["p"], "k"), "lamp"):
		var _t1398 = J.gp(_s570["__p"]["S"], "dark")
		var _t1399 = J.gp(_s570["p"], "room")
		J.sp(_t1398, _t1399, 15.0)
		var _t1400 = J.gp(_s570["__p"]["S"], "light")
		var _t1401 = J.gp(_s570["p"], "room")
		J.sp(_t1400, _t1401, false)
		var _t1402 = _s570["__p"]["S"]
		J.sp(_t1402, "flash", 0.4)
	_s570["hit"] = 0.0
	_s570["rm"] = J.gp(_s570["p"], "room")
	var _t1403 = J.seq(J.gp(J.gp(_s570["__p"]["S"], "task"), "k"), "media")
	var _t1404 = (J.seq(J.gp(_s570["p"], "k"), J.gp(J.gp(_s570["__p"]["S"], "task"), "spot")) if _t1403 else _t1403)
	_s570["media"] = ((not J.t(J.gp(J.gp(_s570["__p"]["S"], "task"), "done"))) if _t1404 else _t1404)
	var _t1405 = J.gp(_s570["__p"]["S"], "actors")
	J.mc(_t1405, "forEach", [Callable(self, "_f249").bind(_s570)])
	if J.t(_s570["hit"]):
		J.mc(_s570["__p"]["A"], "addFear", [2.0, J.gp(J.gp(_s570["__p"]["S"], "un"), "x"), J.sub(J.gp(J.gp(_s570["__p"]["S"], "un"), "y"), 100.0)])
		var _t1428 = J.gp(v_g_1423, "energy")
		var _t1429 = J.gp(v_g_1423, "energy")
		var _t1430 = J.min_([100.0, J.add((_t1429 if J.t(_t1429) else 0.0), 6.0)])
		J.sp(v_g_1423, "energy", _t1430)
	v_i_1428 = 0.0
	while true:
		if not J.cmp(v_i_1428, 8.0, "<"): break
		var _t1431 = _s570["__p"]["part"]
		var _t1434 = J.add(J.gp(_s570["p"], "x"), (J.sub(J.cl(_s570["__p"]["rnd"], null, []), 0.5) * 40.0))
		var _t1435 = J.add(J.gp(_s570["p"], "y"), (J.sub(J.cl(_s570["__p"]["rnd"], null, []), 0.5) * 30.0))
		var _t1436 = (J.sub(J.cl(_s570["__p"]["rnd"], null, []), 0.5) * 120.0)
		var _t1437 = ((-60.0) - J.mul(J.cl(_s570["__p"]["rnd"], null, []), 60.0))
		var _t1432 = J.seq(J.gp(_s570["p"], "k"), "tap")
		var _t1433 = (_t1432 if _t1432 else J.seq(J.gp(_s570["p"], "k"), "shower"))
		J.cl(_t1431, null, [_t1434, _t1435, _t1436, _t1437, 0.8, ("drop" if (_t1433 if _t1433 else J.seq(J.gp(_s570["p"], "k"), "jar")) else "spark")])
		v_i_1428 = J.num(v_i_1428) + 1.0
	return true

func _f250(this_, a: Array, env):
	var v_a_1439 = null; var v_amt_1440 = null; var v_r_1441 = null; var v_g0_1442 = null
	v_a_1439 = J.arg(a, 0)
	v_amt_1440 = J.arg(a, 1)
	v_r_1441 = J.gp(v_a_1439, "r")
	v_g0_1442 = J.cl(env["G"], null, [])
	var _t1438 = J.gp(v_r_1441, "fear")
	var _t1441 = (_t1438 if J.t(_t1438) else 0.0)
	var _t1440 = J.mul(J.mul(v_amt_1440, J.gp(J.gp(v_g0_1442, "mods"), "pow")), (J.mc(env["A"], "gpF", [J.gp(env["S"], "g")]) if J.t(J.gp(env["A"], "gpF")) else 1.0))
	var _t1439 = J.gp(v_r_1441, "brave")
	var _t1442 = J.add(_t1441, (_t1440 * J.sub(1.0, (_t1439 if J.t(_t1439) else 0.0))))
	J.sp(v_r_1441, "fear", _t1442)
	var _t1443 = J.cmp(J.gp(v_r_1441, "fear"), 100.0, ">=")
	var _t1444 = ((not J.cmp(J.gp(v_r_1441, "fleeAfter"), 0.0, ">")) if _t1443 else _t1443)
	if (J.seq(J.gp(v_r_1441, "state"), "home") if _t1444 else _t1444):
		J.sp(v_r_1441, "fleeAfter", 0.9)
		var _t1445 = J.gp(env["S"], "g")
		J.sp(v_r_1441, "fleeG", _t1445)

func _f251(this_, a: Array, env):
	var v_a_1445 = null; var v_T_1446 = null; var v_R_1447 = null
	v_a_1445 = J.arg(a, 0)
	v_T_1446 = J.gp(env["S"], "task")
	var _t1446 = (not J.seq(J.gp(v_T_1446, "k"), "room"))
	if J.t((_t1446 if _t1446 else J.gp(v_T_1446, "done"))):
		return null
	var _t1448 = J.gp(J.gp(env["S"], "lay"), "rooms")
	var _t1447 = env["roomAt"]
	v_R_1447 = J.gp(_t1448, J.cl(_t1447, null, [J.gp(v_a_1445, "x")]))
	var _t1450 = J.seq(J.gp(v_R_1447, "k"), J.gp(v_T_1446, "room"))
	if J.t(_t1450):
		var _t1449 = J.seq(J.gp(v_a_1445, "act"), J.gp(v_T_1446, "act"))
		_t1450 = (_t1449 if _t1449 else J.seq(J.gp(v_a_1445, "prevAct"), J.gp(v_T_1446, "act")))
	var _t1452 = _t1450
	if J.t(_t1452):
		var _t1451 = J.seq(J.gp(v_a_1445, "st"), "act")
		_t1452 = (_t1451 if _t1451 else J.seq(J.gp(v_a_1445, "st"), "cower"))
	if _t1452:
		J.sp(v_T_1446, "done", true)
		J.cl(env["taskDone"], null, [])

func _f252(this_, a: Array, env):
	var v_g_1450 = null; var v_g0_1451 = null; var v_I_1452 = null
	v_g_1450 = J.gp(env["S"], "g")
	v_g0_1451 = J.cl(env["G"], null, [])
	var _t1453 = env["iu"]
	v_I_1452 = J.cl(_t1453, null, [J.gp(env["S"], "un")])
	if J.t(J.gp(v_I_1452, "done")):
		return null
	J.sp(v_I_1452, "done", true)
	var _t1454 = J.gp(env["S"], "task")
	J.sp(_t1454, "done", true)
	J.mc(env["A"], "addFear", [J.round(J.num(J.mul(20.0, J.gp(J.gp(v_g0_1451, "mods"), "fear")))), J.gp(J.gp(env["S"], "un"), "x"), J.sub(J.gp(J.gp(env["S"], "un"), "y"), 110.0)])
	var _t1455 = J.gp(v_g_1450, "energy")
	var _t1456 = J.gp(v_g_1450, "energy")
	var _t1457 = J.min_([100.0, J.add((_t1456 if J.t(_t1456) else 0.0), 30.0)])
	J.sp(v_g_1450, "energy", _t1457)
	var _t1458 = J.gp(v_g0_1451, "unitCoins")
	var _t1459 = J.add((_t1458 if J.t(_t1458) else 0.0), 15.0)
	J.sp(v_g0_1451, "unitCoins", _t1459)
	var _t1460 = J.gp(v_g0_1451, "unitTasks")
	var _t1461 = J.add((_t1460 if J.t(_t1460) else 0.0), 1.0)
	J.sp(v_g0_1451, "unitTasks", _t1461)
	J.mc(env["A"], "takeItem", [v_g_1450, "doll", J.gp(env["S"], "un")])
	var _t1462 = env["msg"]
	J.cl(_t1462, null, [(J.add("屋內任務完成：", J.gp(J.gp(env["S"], "task"), "t")) + "——怕意 +20、能量 +30、替身紙人 +1、冥幣 +15"), "#b2d394"])
	var _t1463 = env["S"]
	J.sp(_t1463, "msgT", 4.5)
	var _t1464 = env["wfl"]
	J.cl(_t1464, null, [J.gp(env["S"], "gx"), (J.sub(J.gp(J.gp(env["S"], "lay"), "floor"), J.gp(J.gp(env["S"], "lay"), "ph")) - 60.0), "任務完成！", "#b2d394"])
	var _t1465 = env["tone"]
	J.cl(_t1465, null, [523.0, 0.0, 0.3, 0.08])
	var _t1466 = env["tone"]
	J.cl(_t1466, null, [784.0, 0.15, 0.5, 0.08])

func _f254(this_, a: Array, env):
	var v_r_1459 = null
	v_r_1459 = J.arg(a, 0)
	var _t1467 = J.seq(J.gp(v_r_1459, "state"), "flee")
	return (_t1467 if _t1467 else J.seq(J.gp(v_r_1459, "state"), "gone"))

func _f253(this_, a: Array, env):
	var v_T_1455 = null; var v_rs_1456 = null
	v_T_1455 = J.gp(env["S"], "task")
	if J.t(J.gp(v_T_1455, "done")):
		return null
	if J.seq(J.gp(v_T_1455, "k"), "allout"):
		v_rs_1456 = J.gp(J.gp(env["S"], "un"), "rs")
		var _t1468 = J.len(v_rs_1456)
		var _t1470 = (J.mc(v_rs_1456, "every", [Callable(self, "_f254").bind(env)]) if J.t(_t1468) else _t1468)
		if J.t(_t1470):
			var _t1469 = env["iu"]
			_t1470 = J.cmp(J.gp(J.cl(_t1469, null, [J.gp(env["S"], "un")]), "fled"), 0.0, ">")
		if J.t(_t1470):
			J.sp(v_T_1455, "done", true)
			J.cl(env["taskDone"], null, [])

func _f256(this_, a: Array, env):
	var v_a_1468 = null; var v_d_1469 = null
	v_a_1468 = J.arg(a, 0)
	var _t1473 = (not J.seq(J.gp(J.gp(v_a_1468, "r"), "state"), "home"))
	var _t1474 = (_t1473 if _t1473 else J.seq(J.gp(v_a_1468, "st"), "run"))
	if (_t1474 if _t1474 else J.cmp(J.gp(J.gp(v_a_1468, "r"), "fleeAfter"), 0.0, ">")):
		return null
	v_d_1469 = absf(J.num(J.sub(J.gp(v_a_1468, "x"), J.gp(env["__p"]["S"], "gx"))))
	var _t1475 = env["__p"]["roomAt"]
	var _t1476 = (not J.seq(J.cl(_t1475, null, [J.gp(v_a_1468, "x")]), env["gr"]))
	if (J.cmp(v_d_1469, 90.0, ">") if _t1476 else _t1476):
		return null
	if J.cmp(v_d_1469, env["bd"], "<"):
		env["bd"] = v_d_1469
		env["best"] = v_a_1468

func _f255(this_, a: Array, env):
	var v_range_1462 = null
	var _s589 = {"__p": env, "gr": null, "best": null, "bd": null}
	v_range_1462 = J.arg(a, 0)
	var _t1471 = _s589["__p"]["roomAt"]
	_s589["gr"] = J.cl(_t1471, null, [J.gp(_s589["__p"]["S"], "gx")])
	_s589["best"] = null
	_s589["bd"] = v_range_1462
	var _t1472 = J.gp(_s589["__p"]["S"], "actors")
	J.mc(_t1472, "forEach", [Callable(self, "_f256").bind(_s589)])
	return _s589["best"]

func _f257(this_, a: Array, env):
	var v_a_1472 = null
	v_a_1472 = J.arg(a, 0)
	var _t1477 = (not J.t(v_a_1472))
	if (_t1477 if _t1477 else (not J.seq(J.gp(J.gp(v_a_1472, "r"), "state"), "home"))):
		return null
	var _t1482 = J.cmp(absf(J.num(J.sub(J.gp(v_a_1472, "x"), J.gp(env["S"], "gx")))), env["RANGE_SCARE"], ">")
	if not J.t(_t1482):
		var _t1478 = env["roomAt"]
		var _t1480 = J.cl(_t1478, null, [J.gp(v_a_1472, "x")])
		var _t1479 = env["roomAt"]
		var _t1481 = (not J.seq(_t1480, J.cl(_t1479, null, [J.gp(env["S"], "gx")])))
		_t1482 = ((absf(J.num(J.sub(J.gp(v_a_1472, "x"), J.gp(env["S"], "gx")))) > 90.0) if _t1481 else _t1481)
	if _t1482:
		var _t1483 = env["S"]
		var _t1484 = J.add(J.gp(v_a_1472, "x"), ((-80.0) if J.cmp(J.gp(v_a_1472, "x"), J.gp(env["S"], "gx"), ">") else 80.0))
		J.sp(_t1483, "goX", _t1484)
		var _t1485 = env["S"]
		var _t1486 = {"k": "scare", "a": v_a_1472}
		J.sp(_t1485, "pend", _t1486)
		return null
	J.mc(env["U"], "scare", [v_a_1472])

func _f259(this_, a: Array, env):
	var v_sc_1481 = null; var v_a_1482 = null; var v_r_1483 = null; var v_g_1484 = null; var v_gr_1485 = null; var v_lit_1486 = null; var v_amt_1487 = null; var v_tag_1488 = null; var v_i_1489 = null
	v_sc_1481 = J.arg(a, 0)
	v_a_1482 = J.gp(v_sc_1481, "a")
	v_r_1483 = J.gp(v_a_1482, "r")
	v_g_1484 = J.gp(env["S"], "g")
	var _t1487 = env["roomAt"]
	v_gr_1485 = J.cl(_t1487, null, [J.gp(v_a_1482, "x")])
	v_lit_1486 = J.gp(J.gp(env["S"], "light"), v_gr_1485)
	if (not J.seq(J.gp(v_r_1483, "state"), "home")):
		return null
	v_amt_1487 = 38.0
	v_tag_1488 = ""
	if (not J.t(v_lit_1486)):
		var _t1488 = J.mul(v_amt_1487, 1.5)
		v_amt_1487 = _t1488
		v_tag_1488 = "黑暗中嚇加倍！"
	if (J.sub(J.gp(env["S"], "t"), J.gp(v_a_1482, "hitT")) < 5.0):
		var _t1489 = J.mul(v_amt_1487, 1.3)
		v_amt_1487 = _t1489
		var _t1490 = ((J.add(v_tag_1488, " ") if J.t(v_tag_1488) else "") + "連環嚇！")
		v_tag_1488 = _t1490
	var _t1491 = J.gp(v_a_1482, "act")
	J.sp(v_a_1482, "prevAct", _t1491)
	J.mc(env["A"], "scareRes", [v_r_1483, v_amt_1487, v_g_1484])
	var _t1492 = J.gp(env["S"], "t")
	J.sp(v_a_1482, "hitT", _t1492)
	J.sp(v_a_1482, "st", "cower")
	J.sp(v_a_1482, "cowT", 1.6)
	var _t1493 = env["S"]
	var _t1494 = J.add(J.gp(_t1493, "alert"), (12.0 if J.t(v_lit_1486) else 5.0))
	J.sp(_t1493, "alert", _t1494)
	var _t1495 = env["S"]
	J.sp(_t1495, "calmT", 0.0)
	J.mc(env["SND"], "scare", [])
	var _t1496 = env["S"]
	J.sp(_t1496, "flash", 0.25)
	if J.t(v_tag_1488):
		var _t1497 = env["wfl"]
		J.cl(_t1497, null, [J.gp(v_a_1482, "x"), J.sub(J.gp(J.gp(env["S"], "lay"), "floor"), J.mul(J.gp(J.gp(env["S"], "lay"), "ph"), 1.2)), v_tag_1488, "#e6a85a"])
	v_i_1489 = 0.0
	while true:
		if not J.cmp(v_i_1489, 10.0, "<"): break
		var _t1498 = env["part"]
		J.cl(_t1498, null, [J.gp(v_a_1482, "x"), J.sub(J.gp(J.gp(env["S"], "lay"), "floor"), J.mul(J.gp(J.gp(env["S"], "lay"), "ph"), 0.7)), (J.sub(J.cl(env["rnd"], null, []), 0.5) * 200.0), ((-100.0) - J.mul(J.cl(env["rnd"], null, []), 80.0)), 0.7, ("coin" if J.seq(J.gp(v_sc_1481, "k"), "toyol") else ("drop" if J.seq(J.gp(v_sc_1481, "k"), "tianhua") else "crumb"))])
		v_i_1489 = J.num(v_i_1489) + 1.0
	var _t1499 = env["roomTask"]
	J.cl(_t1499, null, [v_a_1482])

func _f260(this_, a: Array, env):
	var v_on_1492 = null
	v_on_1492 = J.arg(a, 0)
	var _t1500 = J.gp(env["cv"], "style")
	var _t1501 = ("block" if J.t(v_on_1492) else "none")
	J.sp(_t1500, "display", _t1501)
	if (not J.t(v_on_1492)):
		env["ptr"] = null
		if J.t(env["S"]):
			var _t1502 = env["S"]
			J.sp(_t1502, "joy", null)

func _f261(this_, a: Array, env):
	var v_r_1495 = null; var v_cw_1496 = null; var v_ch_1497 = null
	v_r_1495 = J.mc(J.gp(env["A"], "cv"), "getBoundingClientRect", [])
	var _t1503 = J.gp(J.G.get("window"), "devicePixelRatio")
	var _t1504 = J.gp(J.G.get("window"), "devicePixelRatio")
	var _t1505 = J.min_([2.0, (_t1504 if J.t(_t1504) else 1.0)])
	env["DPR"] = _t1505
	var _t1506 = J.gp(v_r_1495, "width")
	var _t1507 = (_t1506 if J.t(_t1506) else J.gp(env["A"], "VW"))
	env["W"] = _t1507
	var _t1508 = J.gp(v_r_1495, "height")
	var _t1509 = (_t1508 if J.t(_t1508) else J.gp(env["A"], "VH"))
	env["H"] = _t1509
	var _t1510 = J.gp(env["cv"], "style")
	var _t1511 = J.add(J.gp(v_r_1495, "left"), "px")
	J.sp(_t1510, "left", _t1511)
	var _t1512 = J.gp(env["cv"], "style")
	var _t1513 = J.add(J.gp(v_r_1495, "top"), "px")
	J.sp(_t1512, "top", _t1513)
	var _t1514 = J.gp(env["cv"], "style")
	var _t1515 = J.add(env["W"], "px")
	J.sp(_t1514, "width", _t1515)
	var _t1516 = J.gp(env["cv"], "style")
	var _t1517 = J.add(env["H"], "px")
	J.sp(_t1516, "height", _t1517)
	v_cw_1496 = J.round(J.num(J.mul(env["W"], env["DPR"])))
	v_ch_1497 = J.round(J.num(J.mul(env["H"], env["DPR"])))
	var _t1518 = (not J.seq(J.gp(env["cv"], "width"), v_cw_1496))
	if (_t1518 if _t1518 else (not J.seq(J.gp(env["cv"], "height"), v_ch_1497))):
		var _t1519 = env["cv"]
		J.sp(_t1519, "width", v_cw_1496)
		var _t1520 = env["cv"]
		J.sp(_t1520, "height", v_ch_1497)

func _f262(this_, a: Array, env):
	var v_lay_1500 = null; var v_top_1501 = null; var v_ph_1502 = null; var v_s_1503 = null
	v_lay_1500 = J.gp(env["S"], "lay")
	v_top_1501 = J.gp(env["A"], "TOP")
	v_ph_1502 = J.sub(J.sub(env["H"], J.gp(env["A"], "TOP")), J.gp(env["A"], "BOT"))
	v_s_1503 = J.div(v_ph_1502, J.sub(J.gp(J.gp(v_lay_1500, "crop"), 1.0), J.gp(J.gp(v_lay_1500, "crop"), 0.0)))
	return {"top": v_top_1501, "ph": v_ph_1502, "s": v_s_1503, "vw": J.div(env["W"], v_s_1503)}

func _f263(this_, a: Array, env):
	var v_x_1506 = null; var v_y_1507 = null; var v_V_1508 = null
	v_x_1506 = J.arg(a, 0)
	v_y_1507 = J.arg(a, 1)
	v_V_1508 = J.arg(a, 2)
	return {"x": J.mul(J.sub(v_x_1506, J.gp(J.gp(env["S"], "cam"), "x")), J.gp(v_V_1508, "s")), "y": J.add(J.gp(v_V_1508, "top"), J.mul(J.sub(v_y_1507, J.gp(J.gp(J.gp(env["S"], "lay"), "crop"), 0.0)), J.gp(v_V_1508, "s")))}

func _f264(this_, a: Array, env):
	var v_k_1511 = null; var v_x_1512 = null; var v_y_1513 = null; var v_h_1514 = null; var v_o_1515 = null; var v_im_1516 = null; var v_w_1517 = null
	v_k_1511 = J.arg(a, 0)
	v_x_1512 = J.arg(a, 1)
	v_y_1513 = J.arg(a, 2)
	v_h_1514 = J.arg(a, 3)
	v_o_1515 = J.arg(a, 4)
	var _t1521 = env["img"]
	v_im_1516 = J.cl(_t1521, null, [v_k_1511])
	if (not J.t(v_im_1516)):
		var _t1522 = env["c"]
		var _t1523 = (J.gp(v_o_1515, "alpha") if J.t(v_o_1515) else v_o_1515)
		var _t1524 = (J.add("rgba(30,30,36,", (_t1523 if J.t(_t1523) else 1.0)) + ")")
		J.sp(_t1522, "fillStyle", _t1524)
		J.mc(env["c"], "fillRect", [J.sub(v_x_1512, J.mul(v_h_1514, 0.18)), J.sub(v_y_1513, v_h_1514), J.mul(v_h_1514, 0.36), v_h_1514])
		return null
	v_w_1517 = J.div(J.mul(v_h_1514, J.gp(v_im_1516, "width")), J.gp(v_im_1516, "height"))
	var _t1525 = (v_o_1515 if J.t(v_o_1515) else {})
	v_o_1515 = _t1525
	J.mc(env["c"], "save", [])
	var _t1526 = env["c"]
	var _t1527 = (1.0 if J.leq(J.gp(v_o_1515, "alpha"), null) else J.gp(v_o_1515, "alpha"))
	J.sp(_t1526, "globalAlpha", _t1527)
	J.mc(env["c"], "translate", [v_x_1512, v_y_1513])
	if J.t(J.gp(v_o_1515, "rot")):
		J.mc(env["c"], "rotate", [J.gp(v_o_1515, "rot")])
	var _t1529 = ((-1.0) if J.t(J.gp(v_o_1515, "flip")) else 1.0)
	var _t1528 = J.gp(v_o_1515, "sx")
	var _t1531 = J.mul(_t1529, (_t1528 if J.t(_t1528) else 1.0))
	var _t1530 = J.gp(v_o_1515, "sy")
	J.mc(env["c"], "scale", [_t1531, (_t1530 if J.t(_t1530) else 1.0)])
	J.mc(env["c"], "drawImage", [v_im_1516, J.div((-J.num(v_w_1517)), 2.0), (-J.num(v_h_1514)), v_w_1517, v_h_1514])
	J.mc(env["c"], "restore", [])

func _f265(this_, a: Array, env):
	var v_x_1520 = null; var v_y_1521 = null; var v_t_1522 = null; var v_w_1523 = null
	v_x_1520 = J.arg(a, 0)
	v_y_1521 = J.arg(a, 1)
	v_t_1522 = J.arg(a, 2)
	var _t1532 = env["c"]
	var _t1533 = J.add("bold 13px ", J.gp(env["A"], "FONT"))
	J.sp(_t1532, "font", _t1533)
	v_w_1523 = J.min_([J.sub(env["W"], 20.0), J.add(J.gp(J.mc(env["c"], "measureText", [v_t_1522]), "width"), 18.0)])
	var _t1534 = env["clamp"]
	var _t1535 = J.cl(_t1534, null, [v_x_1520, (J.div(v_w_1523, 2.0) + 6.0), (J.sub(env["W"], J.div(v_w_1523, 2.0)) - 6.0)])
	v_x_1520 = _t1535
	J.mc(env["A"], "crBlit", [env["c"], J.mc(env["A"], "crGet", [v_w_1523, 24.0, "note", "bar"]), J.sub(v_x_1520, J.div(v_w_1523, 2.0)), J.sub(v_y_1521, 26.0)])
	J.mc(env["c"], "save", [])
	var _t1536 = env["c"]
	J.sp(_t1536, "fillStyle", "#2a1e1c")
	var _t1537 = env["c"]
	J.sp(_t1537, "textAlign", "center")
	J.mc(env["c"], "fillText", [v_t_1522, v_x_1520, J.sub(v_y_1521, 9.0), J.sub(v_w_1523, 8.0)])
	J.mc(env["c"], "restore", [])

func _f266(this_, a: Array, env):
	var v_id_1526 = null; var v_x_1527 = null; var v_y_1528 = null; var v_w_1529 = null; var v_h_1530 = null; var v_label_1531 = null; var v_tone_1532 = null; var v_on_1533 = null; var v_pz_1534 = null
	v_id_1526 = J.arg(a, 0)
	v_x_1527 = J.arg(a, 1)
	v_y_1528 = J.arg(a, 2)
	v_w_1529 = J.arg(a, 3)
	v_h_1530 = J.arg(a, 4)
	v_label_1531 = J.arg(a, 5)
	v_tone_1532 = J.arg(a, 6)
	v_on_1533 = J.arg(a, 7)
	J.mc(env["BTN"], "push", [{"id": v_id_1526, "x": v_x_1527, "y": v_y_1528, "w": v_w_1529, "h": v_h_1530}])
	var _t1539 = (J.seq(J.gp(env["ptr"], "btn"), v_id_1526) if J.t(env["ptr"]) else env["ptr"])
	if not J.t(_t1539):
		var _t1538 = (J.seq(J.gp(env["PRESS"], "id"), v_id_1526) if J.t(env["PRESS"]) else env["PRESS"])
		_t1539 = ((J.sub(J.S_performance_("now", []), J.gp(env["PRESS"], "t")) < 220.0) if J.t(_t1538) else _t1538)
	v_pz_1534 = _t1539
	J.mc(env["A"], "crBtn", [env["c"], v_x_1527, v_y_1528, v_w_1529, v_h_1530, v_label_1531, v_tone_1532, v_pz_1534, J.seq(v_on_1533, false)])

func _f267(this_, a: Array, env):
	var v_s_1537 = null; var v_x_1538 = null; var v_y_1539 = null; var v_sz_1540 = null; var v_col_1541 = null; var v_al_1542 = null; var v_mw_1543 = null
	v_s_1537 = J.arg(a, 0)
	v_x_1538 = J.arg(a, 1)
	v_y_1539 = J.arg(a, 2)
	v_sz_1540 = J.arg(a, 3)
	v_col_1541 = J.arg(a, 4)
	v_al_1542 = J.arg(a, 5)
	v_mw_1543 = J.arg(a, 6)
	J.mc(env["A"], "crText", [env["c"], v_s_1537, v_x_1538, v_y_1539, v_sz_1540, v_col_1541, (v_al_1542 if J.t(v_al_1542) else "center"), v_mw_1543])

func _f270(this_, a: Array, env):
	var v_k_1564 = null
	v_k_1564 = J.arg(a, 0)
	var _t1546 = env["__p"]["img"]
	return J.cl(_t1546, null, [v_k_1564])

func _f269(this_, a: Array, env):
	var v_R_1554 = null; var v_i_1555 = null; var v_a_1556 = null; var v_b_1557 = null; var v_RK_1558 = null; var v_key_1559 = null; var v_gd_1560 = null; var v_tx_1561 = null
	v_R_1554 = J.arg(a, 0)
	v_i_1555 = J.arg(a, 1)
	var _t1542 = env["__p"]["P"]
	v_a_1556 = J.cl(_t1542, null, [J.gp(v_R_1554, "x0"), J.gp(J.gp(env["lay"], "crop"), 0.0), env["V"]])
	var _t1543 = env["__p"]["P"]
	v_b_1557 = J.cl(_t1543, null, [J.gp(v_R_1554, "x1"), J.gp(J.gp(env["lay"], "crop"), 1.0), env["V"]])
	var _t1544 = J.cmp(J.gp(v_b_1557, "x"), 0.0, "<")
	if (_t1544 if _t1544 else J.cmp(J.gp(v_a_1556, "x"), env["__p"]["W"], ">")):
		return null
	var _t1545 = J.gp({"living": ["room_mahjong", "room_shopper"], "kitchen": ["room_helper"], "bed": ["room_nurse", "room_gamer"], "bath": []}, J.gp(v_R_1554, "k"))
	v_RK_1558 = (_t1545 if J.t(_t1545) else [])
	v_key_1559 = J.mc(v_RK_1558, "find", [Callable(self, "_f270").bind(env)])
	if J.t(v_key_1559):
		var _t1547 = env["__p"]["img"]
		J.mc(env["__p"]["c"], "drawImage", [J.cl(_t1547, null, [v_key_1559]), J.gp(v_a_1556, "x"), J.gp(v_a_1556, "y"), J.sub(J.gp(v_b_1557, "x"), J.gp(v_a_1556, "x")), J.sub(J.gp(v_b_1557, "y"), J.gp(v_a_1556, "y"))])
	else:
		v_gd_1560 = J.mc(env["__p"]["c"], "createLinearGradient", [0.0, J.gp(v_a_1556, "y"), 0.0, J.gp(v_b_1557, "y")])
		J.mc(v_gd_1560, "addColorStop", [0.0, "#2a3134"])
		J.mc(v_gd_1560, "addColorStop", [1.0, "#151a1c"])
		var _t1548 = env["__p"]["c"]
		J.sp(_t1548, "fillStyle", v_gd_1560)
		J.mc(env["__p"]["c"], "fillRect", [J.gp(v_a_1556, "x"), J.gp(v_a_1556, "y"), J.sub(J.gp(v_b_1557, "x"), J.gp(v_a_1556, "x")), J.sub(J.gp(v_b_1557, "y"), J.gp(v_a_1556, "y"))])
		var _t1549 = env["__p"]["c"]
		J.sp(_t1549, "strokeStyle", "rgba(180,200,200,0.12)")
		v_tx_1561 = J.gp(v_a_1556, "x")
		while true:
			if not J.cmp(v_tx_1561, J.gp(v_b_1557, "x"), "<"): break
			J.mc(env["__p"]["c"], "beginPath", [])
			J.mc(env["__p"]["c"], "moveTo", [v_tx_1561, J.gp(v_a_1556, "y")])
			J.mc(env["__p"]["c"], "lineTo", [v_tx_1561, J.gp(v_b_1557, "y")])
			J.mc(env["__p"]["c"], "stroke", [])
			var _t1550 = J.add(v_tx_1561, J.mul(22.0, J.gp(env["V"], "s")))
			v_tx_1561 = _t1550
	var _t1551 = env["__p"]["c"]
	J.sp(_t1551, "fillStyle", "#0d0b0e")
	J.mc(env["__p"]["c"], "fillRect", [J.sub(J.gp(v_b_1557, "x"), J.mul(6.0, J.gp(env["V"], "s"))), J.gp(v_a_1556, "y"), J.mul(12.0, J.gp(env["V"], "s")), (J.sub(J.gp(v_b_1557, "y"), J.gp(v_a_1556, "y")) * 0.35)])

func _f268(this_, a: Array, env):
	var v_im_1548 = null; var v_k_1549 = null; var v_ch_1550 = null; var v_srcY_1551 = null
	var _s615 = {"__p": env, "V": null, "lay": null}
	_s615["V"] = J.arg(a, 0)
	_s615["lay"] = J.gp(_s615["__p"]["S"], "lay")
	var _t1540 = _s615["__p"]["img"]
	v_im_1548 = J.cl(_t1540, null, [J.gp(_s615["lay"], "img")])
	if J.t(v_im_1548):
		v_k_1549 = J.div(J.gp(v_im_1548, "width"), J.gp(_s615["lay"], "W"))
		v_ch_1550 = J.sub(J.gp(J.gp(_s615["lay"], "crop"), 1.0), J.gp(J.gp(_s615["lay"], "crop"), 0.0))
		v_srcY_1551 = J.mul((J.gp(J.gp(_s615["lay"], "crop"), 0.0) if (J.div(J.gp(v_im_1548, "height"), v_k_1549) >= J.sub(J.gp(_s615["lay"], "H"), 4.0)) else 0.0), v_k_1549)
		J.mc(_s615["__p"]["c"], "drawImage", [v_im_1548, J.mul(J.gp(J.gp(_s615["__p"]["S"], "cam"), "x"), v_k_1549), v_srcY_1551, J.mul(J.gp(_s615["V"], "vw"), v_k_1549), J.mul(v_ch_1550, v_k_1549), 0.0, J.gp(_s615["V"], "top"), _s615["__p"]["W"], J.gp(_s615["V"], "ph")])
	else:
		var _t1541 = J.gp(_s615["lay"], "rooms")
		J.mc(_t1541, "forEach", [Callable(self, "_f269").bind(_s615)])

func _f271(this_, a: Array, env):
	var v_p_1567 = null; var v_V_1568 = null; var v_q_1569 = null; var v_a_1570 = null; var v_T_1571 = null; var v_s_1572 = null; var v_k_1573 = null; var v_r_1574 = null; var v_i_1575 = null; var v_on_1576 = null; var v_gr_1577 = null; var v_j_1578 = null; var v_xx_1579 = null; var v_o_1580 = null; var v_j2_1581 = null; var v_dy_1582 = null; var v_j3_1583 = null; var v_bx_1584 = null; var v_j4_1585 = null; var v_ready_1586 = null; var v_inR_1587 = null
	v_p_1567 = J.arg(a, 0)
	v_V_1568 = J.arg(a, 1)
	var _t1552 = env["P"]
	v_q_1569 = J.cl(_t1552, null, [J.gp(v_p_1567, "x"), J.gp(v_p_1567, "y"), v_V_1568])
	v_a_1570 = J.cmp(J.gp(v_p_1567, "t"), 0.0, ">")
	v_T_1571 = J.gp(env["S"], "t")
	v_s_1572 = J.gp(v_V_1568, "s")
	v_k_1573 = J.gp(v_p_1567, "k")
	v_r_1574 = (J.mul(34.0, v_s_1572) + 10.0)
	J.mc(env["c"], "save", [])
	if J.t(v_a_1570):
		var _t1553 = env["c"]
		var _t1554 = J.min_([1.0, J.gp(v_p_1567, "t")])
		J.sp(_t1553, "globalAlpha", _t1554)
		var _t1555 = J.seq(v_k_1573, "tv")
		if (_t1555 if _t1555 else J.seq(v_k_1573, "pc")):
			v_i_1575 = 0.0
			while true:
				if not J.cmp(v_i_1575, 60.0, "<"): break
				var _t1556 = env["c"]
				var _t1557 = (J.add("rgba(230,235,240,", (randf() * 0.8)) + ")")
				J.sp(_t1556, "fillStyle", _t1557)
				J.mc(env["c"], "fillRect", [(J.sub(J.gp(v_q_1569, "x"), J.mul(40.0, v_s_1572)) + J.mul((randf() * 80.0), v_s_1572)), (J.sub(J.gp(v_q_1569, "y"), J.mul(28.0, v_s_1572)) + J.mul((randf() * 50.0), v_s_1572)), 3.0, 2.0])
				v_i_1575 = J.num(v_i_1575) + 1.0
			var _t1558 = env["c"]
			J.sp(_t1558, "fillStyle", "rgba(10,10,10,0.6)")
			J.mc(env["c"], "beginPath", [])
			J.mc(env["c"], "ellipse", [J.gp(v_q_1569, "x"), J.gp(v_q_1569, "y"), J.mul(10.0, v_s_1572), J.mul(14.0, v_s_1572), 0.0, 0.0, 7.0])
			J.mc(env["c"], "fill", [])
			if J.seq(v_k_1573, "pc"):
				var _t1559 = env["c"]
				J.sp(_t1559, "fillStyle", "#c0302a")
				J.mc(env["c"], "fillRect", [J.sub(J.gp(v_q_1569, "x"), J.mul(6.0, v_s_1572)), J.sub(J.gp(v_q_1569, "y"), J.mul(4.0, v_s_1572)), J.mul(4.0, v_s_1572), J.mul(4.0, v_s_1572)])
				J.mc(env["c"], "fillRect", [J.add(J.gp(v_q_1569, "x"), J.mul(3.0, v_s_1572)), J.sub(J.gp(v_q_1569, "y"), J.mul(4.0, v_s_1572)), J.mul(4.0, v_s_1572), J.mul(4.0, v_s_1572)])
		else:
			if J.seq(v_k_1573, "lamp"):
				v_on_1576 = J.seq(J.mod(floor(J.num(J.mul(v_T_1571, 14.0))), 3.0), 0.0)
				if J.t(v_on_1576):
					v_gr_1577 = J.mc(env["c"], "createRadialGradient", [J.gp(v_q_1569, "x"), J.gp(v_q_1569, "y"), 2.0, J.gp(v_q_1569, "x"), J.gp(v_q_1569, "y"), J.mul(120.0, v_s_1572)])
					J.mc(v_gr_1577, "addColorStop", [0.0, "rgba(255,240,190,0.55)"])
					J.mc(v_gr_1577, "addColorStop", [1.0, "rgba(255,240,190,0)"])
					var _t1560 = env["c"]
					J.sp(_t1560, "fillStyle", v_gr_1577)
					J.mc(env["c"], "fillRect", [J.sub(J.gp(v_q_1569, "x"), J.mul(120.0, v_s_1572)), J.sub(J.gp(v_q_1569, "y"), J.mul(120.0, v_s_1572)), J.mul(240.0, v_s_1572), J.mul(240.0, v_s_1572)])
			else:
				var _t1561 = J.seq(v_k_1573, "tap")
				if (_t1561 if _t1561 else J.seq(v_k_1573, "shower")):
					var _t1562 = env["c"]
					J.sp(_t1562, "strokeStyle", "rgba(170,215,240,0.85)")
					var _t1563 = env["c"]
					J.sp(_t1563, "lineWidth", 3.0)
					v_j_1578 = 0.0
					while true:
						if not J.cmp(v_j_1578, 4.0, "<"): break
						J.mc(env["c"], "beginPath", [])
						v_xx_1579 = J.add(J.gp(v_q_1569, "x"), J.mul((J.sub(v_j_1578, 1.5) * 4.0), v_s_1572))
						J.mc(env["c"], "moveTo", [v_xx_1579, J.gp(v_q_1569, "y")])
						J.mc(env["c"], "lineTo", [J.add(v_xx_1579, (sin(J.num(J.add(J.mul(v_T_1571, 20.0), v_j_1578))) * 2.0)), J.add(J.gp(v_q_1569, "y"), J.mul((200.0 if J.seq(v_k_1573, "shower") else 60.0), v_s_1572))])
						J.mc(env["c"], "stroke", [])
						v_j_1578 = J.num(v_j_1578) + 1.0
				else:
					var _t1564 = J.seq(v_k_1573, "wardrobe")
					if (_t1564 if _t1564 else J.seq(v_k_1573, "fridge")):
						v_o_1580 = J.mul((absf(J.num(sin(J.num((J.sub(2.6, J.gp(v_p_1567, "t")) * 1.5))))) * 44.0), v_s_1572)
						var _t1565 = env["c"]
						var _t1566 = ("rgba(200,240,255,0.35)" if J.seq(v_k_1573, "fridge") else "rgba(10,6,8,0.85)")
						J.sp(_t1565, "fillStyle", _t1566)
						J.mc(env["c"], "beginPath", [])
						J.mc(env["c"], "moveTo", [J.add(J.gp(v_q_1569, "x"), J.mul(20.0, v_s_1572)), J.sub(J.gp(v_q_1569, "y"), J.mul(70.0, v_s_1572))])
						J.mc(env["c"], "lineTo", [J.add(J.add(J.gp(v_q_1569, "x"), J.mul(20.0, v_s_1572)), v_o_1580), J.sub(J.gp(v_q_1569, "y"), J.mul(80.0, v_s_1572))])
						J.mc(env["c"], "lineTo", [J.add(J.add(J.gp(v_q_1569, "x"), J.mul(20.0, v_s_1572)), v_o_1580), J.add(J.gp(v_q_1569, "y"), J.mul(90.0, v_s_1572))])
						J.mc(env["c"], "lineTo", [J.add(J.gp(v_q_1569, "x"), J.mul(20.0, v_s_1572)), J.add(J.gp(v_q_1569, "y"), J.mul(80.0, v_s_1572))])
						J.mc(env["c"], "closePath", [])
						J.mc(env["c"], "fill", [])
						if J.seq(v_k_1573, "wardrobe"):
							var _t1567 = env["c"]
							J.sp(_t1567, "fillStyle", "rgba(220,40,40,0.8)")
							J.mc(env["c"], "beginPath", [])
							J.mc(env["c"], "arc", [J.add(J.gp(v_q_1569, "x"), J.mul(6.0, v_s_1572)), J.sub(J.gp(v_q_1569, "y"), J.mul(20.0, v_s_1572)), 2.5, 0.0, 7.0])
							J.mc(env["c"], "arc", [J.add(J.gp(v_q_1569, "x"), J.mul(14.0, v_s_1572)), J.sub(J.gp(v_q_1569, "y"), J.mul(20.0, v_s_1572)), 2.5, 0.0, 7.0])
							J.mc(env["c"], "fill", [])
					else:
						if J.seq(v_k_1573, "mirror"):
							var _t1568 = env["c"]
							var _t1569 = J.mul(J.gp(_t1568, "globalAlpha"), (0.5 + (0.3 * sin(J.num(J.mul(v_T_1571, 8.0))))))
							J.sp(_t1568, "globalAlpha", _t1569)
							var _t1570 = env["sprite"]
							J.cl(_t1570, null, [J.gp(J.gp(J.gp(env["S"], "g"), "d"), "sprite"), J.gp(v_q_1569, "x"), J.add(J.gp(v_q_1569, "y"), J.mul(40.0, v_s_1572)), J.mul(90.0, v_s_1572), {"alpha": 0.55}])
						else:
							if J.seq(v_k_1573, "fan"):
								var _t1571 = env["c"]
								J.sp(_t1571, "strokeStyle", "rgba(220,230,235,0.5)")
								var _t1572 = env["c"]
								J.sp(_t1572, "lineWidth", 2.0)
								v_j2_1581 = 0.0
								while true:
									if not J.cmp(v_j2_1581, 3.0, "<"): break
									J.mc(env["c"], "beginPath", [])
									J.mc(env["c"], "ellipse", [J.gp(v_q_1569, "x"), J.gp(v_q_1569, "y"), J.mul((50.0 + J.mul(v_j2_1581, 14.0)), v_s_1572), J.mul(10.0, v_s_1572), 0.0, J.add(J.mul(v_T_1571, 30.0), v_j2_1581), J.add(J.add(J.mul(v_T_1571, 30.0), v_j2_1581), 2.0)])
									J.mc(env["c"], "stroke", [])
									v_j2_1581 = J.num(v_j2_1581) + 1.0
							else:
								if J.seq(v_k_1573, "radio"):
									var _t1573 = env["c"]
									J.sp(_t1573, "fillStyle", "#e8d2a0")
									var _t1574 = env["c"]
									var _t1575 = J.add((J.add("bold ", J.round(J.num((J.mul(22.0, v_s_1572) + 8.0)))) + "px "), J.gp(env["A"], "FONT"))
									J.sp(_t1574, "font", _t1575)
									var _t1576 = env["c"]
									J.sp(_t1576, "textAlign", "center")
									J.mc(env["c"], "fillText", ["♪", (J.sub(J.gp(v_q_1569, "x"), J.mul(20.0, v_s_1572)) + (sin(J.num(J.mul(v_T_1571, 5.0))) * 8.0)), (J.sub(J.gp(v_q_1569, "y"), J.mul(40.0, v_s_1572)) - J.mod(J.mul(v_T_1571, 60.0), 30.0))])
									J.mc(env["c"], "fillText", ["♫", J.add(J.gp(v_q_1569, "x"), J.mul(20.0, v_s_1572)), (J.sub(J.gp(v_q_1569, "y"), J.mul(30.0, v_s_1572)) - J.mod((J.mul(v_T_1571, 60.0) + 15.0), 30.0))])
								else:
									if J.seq(v_k_1573, "pots"):
										v_dy_1582 = J.mul((J.min_([1.0, (J.sub(2.6, J.gp(v_p_1567, "t")) * 2.0)]) * 160.0), v_s_1572)
										var _t1577 = env["c"]
										J.sp(_t1577, "fillStyle", "#3a3a3e")
										J.mc(env["c"], "beginPath", [])
										J.mc(env["c"], "ellipse", [J.add(J.gp(v_q_1569, "x"), J.mul(10.0, v_s_1572)), J.add(J.gp(v_q_1569, "y"), v_dy_1582), J.mul(18.0, v_s_1572), J.mul(8.0, v_s_1572), (J.sub(2.6, J.gp(v_p_1567, "t")) * 6.0), 0.0, 7.0])
										J.mc(env["c"], "fill", [])
									else:
										if J.seq(v_k_1573, "net"):
											var _t1578 = env["c"]
											J.sp(_t1578, "strokeStyle", "rgba(235,235,230,0.55)")
											var _t1579 = env["c"]
											J.sp(_t1579, "lineWidth", 2.0)
											v_j3_1583 = 0.0
											while true:
												if not J.cmp(v_j3_1583, 6.0, "<"): break
												J.mc(env["c"], "beginPath", [])
												v_bx_1584 = (J.sub(J.gp(v_q_1569, "x"), J.mul(90.0, v_s_1572)) + J.mul(J.mul(v_j3_1583, 36.0), v_s_1572))
												J.mc(env["c"], "moveTo", [v_bx_1584, J.sub(J.gp(v_q_1569, "y"), J.mul(110.0, v_s_1572))])
												J.mc(env["c"], "quadraticCurveTo", [J.add(v_bx_1584, J.mul((sin(J.num(J.add(J.mul(v_T_1571, 6.0), v_j3_1583))) * 24.0), v_s_1572)), J.gp(v_q_1569, "y"), J.add(v_bx_1584, J.mul((sin(J.num(J.add(J.mul(v_T_1571, 4.0), v_j3_1583))) * 14.0), v_s_1572)), J.add(J.gp(v_q_1569, "y"), J.mul(110.0, v_s_1572))])
												J.mc(env["c"], "stroke", [])
												v_j3_1583 = J.num(v_j3_1583) + 1.0
										else:
											if J.seq(v_k_1573, "jar"):
												v_j4_1585 = 0.0
												while true:
													if not J.cmp(v_j4_1585, 5.0, "<"): break
													var _t1580 = env["c"]
													J.sp(_t1580, "strokeStyle", "rgba(180,220,230,0.7)")
													J.mc(env["c"], "beginPath", [])
													J.mc(env["c"], "arc", [J.add(J.gp(v_q_1569, "x"), J.mul((J.sub(v_j4_1585, 2.0) * 10.0), v_s_1572)), (J.sub(J.gp(v_q_1569, "y"), J.mul(50.0, v_s_1572)) - J.mul(J.mod((J.mul(v_T_1571, 80.0) + J.mul(v_j4_1585, 13.0)), 40.0), v_s_1572)), (J.mul(4.0, v_s_1572) + 2.0), 0.0, 7.0])
													J.mc(env["c"], "stroke", [])
													v_j4_1585 = J.num(v_j4_1585) + 1.0
		var _t1581 = env["c"]
		J.sp(_t1581, "globalAlpha", 1.0)
	v_ready_1586 = J.cmp(J.gp(v_p_1567, "cd"), 0.0, "<=")
	var _t1582 = env["roomAt"]
	var _t1583 = J.seq(J.cl(_t1582, null, [J.gp(env["S"], "gx")]), J.gp(v_p_1567, "room"))
	v_inR_1587 = (J.cmp(absf(J.num(J.sub(J.gp(env["S"], "gx"), J.gp(v_p_1567, "x")))), env["RANGE_HOT"], "<=") if _t1583 else _t1583)
	var _t1584 = env["c"]
	var _t1585 = (((0.85 + (0.15 * sin(J.num(J.mul(v_T_1571, 6.0))))) if J.t(v_inR_1587) else (0.45 + (0.2 * sin(J.num(J.mul(v_T_1571, 3.0)))))) if J.t(v_ready_1586) else 0.35)
	J.sp(_t1584, "globalAlpha", _t1585)
	var _t1586 = env["c"]
	var _t1587 = (("#e6a85a" if J.t(v_inR_1587) else "#b2d394") if J.t(v_ready_1586) else "#7a6e74")
	J.sp(_t1586, "strokeStyle", _t1587)
	var _t1588 = env["c"]
	var _t1589 = (3.0 if J.t((v_ready_1586 if J.t(v_inR_1587) else v_inR_1587)) else 2.0)
	J.sp(_t1588, "lineWidth", _t1589)
	J.mc(env["c"], "setLineDash", [([] if J.t(v_ready_1586) else [4.0, 4.0])])
	J.mc(env["c"], "beginPath", [])
	J.mc(env["c"], "arc", [J.gp(v_q_1569, "x"), J.gp(v_q_1569, "y"), J.mul(v_r_1574, 0.62), 0.0, 7.0])
	J.mc(env["c"], "stroke", [])
	J.mc(env["c"], "setLineDash", [[]])
	if (not J.t(v_ready_1586)):
		var _t1590 = env["c"]
		J.sp(_t1590, "strokeStyle", "#e8d2a0")
		var _t1591 = env["c"]
		J.sp(_t1591, "lineWidth", 3.0)
		J.mc(env["c"], "beginPath", [])
		J.mc(env["c"], "arc", [J.gp(v_q_1569, "x"), J.gp(v_q_1569, "y"), J.mul(v_r_1574, 0.62), J.div((-PI), 2.0), (J.div((-PI), 2.0) + ((PI * 2.0) * (1.0 - J.div(J.gp(v_p_1567, "cd"), 14.0))))])
		J.mc(env["c"], "stroke", [])
	var _t1592 = env["c"]
	J.sp(_t1592, "globalAlpha", 1.0)
	J.mc(env["c"], "restore", [])
	if J.t((v_inR_1587 if J.t(v_ready_1586) else v_ready_1586)):
		var _t1593 = env["txt"]
		J.cl(_t1593, null, [J.gp(J.gp(env["HOT"], v_k_1573), "v"), J.gp(v_q_1569, "x"), (J.sub(J.gp(v_q_1569, "y"), J.mul(v_r_1574, 0.62)) - 6.0), 12.0, "#e6a85a"])

func _f272(this_, a: Array, env):
	var v_a_1590 = null; var v_V_1591 = null; var v_r_1592 = null; var v_lay_1593 = null; var v_FX_1594 = null; var v_run_1595 = null; var v_scared_1596 = null; var v_h0_1597 = null; var v_k2_1598 = null; var v_h_1599 = null; var v_art_1600 = null; var v_q_1601 = null; var v_rot_1602 = null; var v_sy_1603 = null; var v_sx_1604 = null; var v_oy_1605 = null; var v_al_1606 = null; var v_sxs_1607 = null; var v_tint_1608 = null; var v_flip_1609 = null; var v_bed_1610 = null; var v_lit_1611 = null; var v_S0_1612 = null; var v_T0_1613 = null; var v_j_1614 = null; var v_i_1615 = null; var v_top_1616 = null
	v_a_1590 = J.arg(a, 0)
	v_V_1591 = J.arg(a, 1)
	v_r_1592 = J.gp(v_a_1590, "r")
	v_lay_1593 = J.gp(env["S"], "lay")
	v_FX_1594 = J.gp(J.G.get("window"), "PPLFX")
	v_run_1595 = J.seq(J.gp(v_a_1590, "st"), "run")
	var _t1595 = (not (not J.t(v_FX_1594)))
	if J.t(_t1595):
		var _t1594 = J.cmp(J.gp(v_r_1592, "shockT"), 0.0, ">")
		_t1595 = (_t1594 if _t1594 else v_run_1595)
	v_scared_1596 = _t1595
	var _t1597 = J.gp(v_lay_1593, "ph")
	var _t1596 = J.gp(v_r_1592, "h")
	v_h0_1597 = J.mul(J.div(J.mul(_t1597, (_t1596 if J.t(_t1596) else 74.0)), 74.0), J.gp(v_V_1591, "s"))
	v_k2_1598 = (J.mc(v_FX_1594, "key", [J.gp(v_r_1592, "sprite"), v_scared_1596]) if J.t(v_FX_1594) else J.gp(v_r_1592, "sprite"))
	v_h_1599 = (J.mc(v_FX_1594, "hgt", [J.gp(v_r_1592, "sprite"), v_k2_1598, v_h0_1597]) if J.t(v_FX_1594) else v_h0_1597)
	v_art_1600 = (not J.seq(v_k2_1598, J.gp(v_r_1592, "sprite")))
	var _t1598 = env["P"]
	v_q_1601 = J.cl(_t1598, null, [J.gp(v_a_1590, "x"), J.gp(v_lay_1593, "floor"), v_V_1591])
	v_rot_1602 = 0.0
	v_sy_1603 = 1.0
	v_sx_1604 = 0.0
	v_oy_1605 = 0.0
	v_al_1606 = 1.0
	v_sxs_1607 = 1.0
	v_tint_1608 = 0.0
	v_flip_1609 = J.cmp(J.gp(v_a_1590, "dir"), 0.0, "<")
	var _t1599 = J.seq(J.gp(v_a_1590, "act"), "bed")
	v_bed_1610 = (J.seq(J.gp(v_a_1590, "st"), "act") if _t1599 else _t1599)
	var _t1600 = J.cmp(J.gp(v_q_1601, "x"), (-80.0), "<")
	var _t1601 = (_t1600 if _t1600 else J.cmp(J.gp(v_q_1601, "x"), J.add(env["W"], 80.0), ">"))
	if J.t((_t1601 if _t1601 else J.gp(v_a_1590, "hid"))):
		return null
	var _t1603 = J.gp(env["S"], "light")
	var _t1602 = env["roomAt"]
	v_lit_1611 = J.gp(_t1603, J.cl(_t1602, null, [J.gp(v_a_1590, "x")]))
	var _t1604 = J.seq(J.gp(v_a_1590, "pose"), "sit")
	if (J.seq(J.gp(v_a_1590, "st"), "act") if _t1604 else _t1604):
		v_sy_1603 = 0.86
	if J.t(v_bed_1610):
		v_rot_1602 = (-1.45)
		var _t1605 = J.gp(J.gp(J.gp(v_lay_1593, "acts"), "bed"), "lift")
		var _t1606 = J.mul((-J.num((_t1605 if J.t(_t1605) else 60.0))), J.gp(v_V_1591, "s"))
		v_oy_1605 = _t1606
		var _t1607 = J.mul(v_h_1599, 0.45)
		v_sx_1604 = _t1607
	var _t1608 = J.seq(J.gp(v_a_1590, "act"), "shower")
	if (J.seq(J.gp(v_a_1590, "st"), "act") if _t1608 else _t1608):
		v_al_1606 = 0.85
	var _t1609 = J.seq(J.gp(v_a_1590, "st"), "cower")
	if J.t((_t1609 if _t1609 else J.gp(v_r_1592, "react"))):
		var _t1610 = J.add(v_sx_1604, (sin(J.num(J.mul(J.gp(env["S"], "t"), 40.0))) * 2.0))
		v_sx_1604 = _t1610
		var _t1611 = J.mul(v_sy_1603, 0.94)
		v_sy_1603 = _t1611
	if J.t(v_run_1595):
		var _t1612 = J.sub(v_oy_1605, (absf(J.num(sin(J.num(J.mul(J.gp(v_a_1590, "x"), 0.045))))) * 10.0))
		v_oy_1605 = _t1612
		var _t1613 = ((-J.num(J.gp(v_a_1590, "dir"))) * 0.18)
		v_rot_1602 = _t1613
		var _t1614 = (0.12 if J.t(v_art_1600) else 0.3)
		v_tint_1608 = _t1614
	var _t1615 = (J.cmp(J.gp(v_r_1592, "shockT"), 0.0, ">") if J.t(v_FX_1594) else v_FX_1594)
	var _t1616 = ((not J.t(v_run_1595)) if J.t(_t1615) else _t1615)
	if J.t(((not J.t(v_bed_1610)) if J.t(_t1616) else _t1616)):
		var _t1618 = J.gp(v_r_1592, "shockT")
		var _t1617 = J.gp(v_r_1592, "shockA")
		v_S0_1612 = J.mc(v_FX_1594, "shock", [_t1618, (_t1617 if J.t(_t1617) else 1.0)])
		var _t1619 = J.mul(v_sy_1603, J.gp(v_S0_1612, "sy"))
		v_sy_1603 = _t1619
		v_sxs_1607 = J.gp(v_S0_1612, "sx")
		var _t1620 = J.add(v_oy_1605, J.mul(J.gp(v_S0_1612, "jy"), v_h_1599))
		v_oy_1605 = _t1620
		var _t1621 = J.add(v_sx_1604, J.mul(J.gp(v_S0_1612, "sh"), v_h_1599))
		v_sx_1604 = _t1621
		var _t1622 = J.mul(J.gp(v_S0_1612, "tint"), (0.55 if J.t(v_art_1600) else 1.0))
		v_tint_1608 = _t1622
	else:
		var _t1624 = (J.gp(v_r_1592, "awake") if J.t(v_FX_1594) else v_FX_1594)
		if J.t(_t1624):
			var _t1623 = J.gp(v_r_1592, "fear")
			_t1624 = J.cmp((_t1623 if J.t(_t1623) else 0.0), 55.0, ">=")
		var _t1625 = ((not J.t(v_run_1595)) if J.t(_t1624) else _t1624)
		if J.t(((not J.t(v_bed_1610)) if J.t(_t1625) else _t1625)):
			v_T0_1613 = J.mc(v_FX_1594, "tremble", [v_r_1592, J.gp(env["S"], "t")])
			var _t1626 = J.add(v_sx_1604, J.mul(J.gp(v_T0_1613, "sh"), v_h_1599))
			v_sx_1604 = _t1626
			var _t1627 = J.mul(v_sy_1603, J.gp(v_T0_1613, "sy"))
			v_sy_1603 = _t1627
			var _t1628 = (not J.seq(J.gp(v_a_1590, "st"), "walk"))
			var _t1629 = ((not J.seq(J.gp(v_a_1590, "st"), "go")) if _t1628 else _t1628)
			if ((not J.leq(J.gp(v_T0_1613, "flip"), null)) if _t1629 else _t1629):
				v_flip_1609 = J.gp(v_T0_1613, "flip")
			v_tint_1608 = J.gp(v_T0_1613, "tint")
		else:
			var _t1630 = (not J.t(v_FX_1594))
			if (J.cmp(J.gp(v_r_1592, "jumpT"), 0.0, ">") if _t1630 else _t1630):
				var _t1631 = J.sub(v_oy_1605, (sin(J.num((J.div(J.sub(0.5, J.gp(v_r_1592, "jumpT")), 0.5) * PI))) * 16.0))
				v_oy_1605 = _t1631
	var _t1632 = (J.gp(v_r_1592, "shockN") if J.t(v_FX_1594) else v_FX_1594)
	if J.t(((not J.seq(J.gp(v_a_1590, "shkN"), J.gp(v_r_1592, "shockN"))) if J.t(_t1632) else _t1632)):
		var _t1633 = J.gp(v_r_1592, "shockN")
		J.sp(v_a_1590, "shkN", _t1633)
		v_j_1614 = 0.0
		while true:
			if not J.cmp(v_j_1614, 5.0, "<"): break
			var _t1634 = env["part"]
			J.cl(_t1634, null, [J.add(J.gp(v_a_1590, "x"), ((randf() - 0.5) * 30.0)), J.sub(J.gp(v_lay_1593, "floor"), J.mul(J.gp(v_lay_1593, "ph"), 0.85)), ((randf() - 0.5) * 220.0), ((-120.0) - (randf() * 90.0)), 0.8, "drop"])
			v_j_1614 = J.num(v_j_1614) + 1.0
	var _t1635 = env["c"]
	J.sp(_t1635, "fillStyle", "rgba(0,0,0,0.45)")
	J.mc(env["c"], "beginPath", [])
	J.mc(env["c"], "ellipse", [J.gp(v_q_1601, "x"), J.gp(v_q_1601, "y"), (J.mul(26.0, J.gp(v_V_1591, "s")) + 6.0), 6.0, 0.0, 0.0, 7.0])
	J.mc(env["c"], "fill", [])
	var _t1636 = (v_run_1595 if J.t(v_FX_1594) else v_FX_1594)
	if J.t(((not J.t(v_art_1600)) if J.t(_t1636) else _t1636)):
		J.mc(v_FX_1594, "arms", [env["c"], J.add(J.gp(v_q_1601, "x"), v_sx_1604), J.add(J.gp(v_q_1601, "y"), v_oy_1605), v_h_1599, J.gp(v_a_1590, "dir"), J.gp(env["S"], "t")])
	if J.t(v_FX_1594):
		J.mc(v_FX_1594, "draw", [env["c"], J.gp(v_r_1592, "sprite"), v_k2_1598, J.add(J.gp(v_q_1601, "x"), v_sx_1604), J.add(J.gp(v_q_1601, "y"), v_oy_1605), v_h_1599, {"flip": v_flip_1609, "rot": v_rot_1602, "sy": v_sy_1603, "sx": v_sxs_1607, "alpha": v_al_1606, "tint": v_tint_1608}])
	else:
		var _t1637 = env["sprite"]
		J.cl(_t1637, null, [J.gp(v_r_1592, "sprite"), J.add(J.gp(v_q_1601, "x"), v_sx_1604), J.add(J.gp(v_q_1601, "y"), v_oy_1605), v_h_1599, {"flip": v_flip_1609, "rot": v_rot_1602, "sy": v_sy_1603, "alpha": v_al_1606}])
	var _t1638 = J.seq(J.gp(v_a_1590, "act"), "shower")
	if (J.seq(J.gp(v_a_1590, "st"), "act") if _t1638 else _t1638):
		v_i_1615 = 0.0
		while true:
			if not J.cmp(v_i_1615, 3.0, "<"): break
			var _t1639 = env["c"]
			J.sp(_t1639, "fillStyle", "rgba(220,230,235,0.18)")
			J.mc(env["c"], "beginPath", [])
			J.mc(env["c"], "arc", [J.add(J.gp(v_q_1601, "x"), J.mul((J.sub(v_i_1615, 1.0) * 30.0), J.gp(v_V_1591, "s"))), (J.sub(J.gp(v_q_1601, "y"), J.mul(v_h_1599, (0.4 + J.mul(0.2, v_i_1615)))) - J.mod((J.mul(J.gp(env["S"], "t"), 20.0) + J.mul(v_i_1615, 10.0)), 20.0)), (J.mul(24.0, J.gp(v_V_1591, "s")) + 8.0), 0.0, 7.0])
			J.mc(env["c"], "fill", [])
			v_i_1615 = J.num(v_i_1615) + 1.0
	if J.t(((not J.t(J.gp(v_r_1592, "awake"))) if J.t(v_bed_1610) else v_bed_1610)):
		var _t1640 = env["txt"]
		J.cl(_t1640, null, ["Z", J.add(J.gp(v_q_1601, "x"), J.mul(v_h_1599, 0.5)), (J.sub(J.add(J.gp(v_q_1601, "y"), v_oy_1605), J.mul(v_h_1599, 0.25)) - J.mod(J.mul(J.gp(env["S"], "t"), 14.0), 14.0)), 15.0, "#c8d8ff"])
		var _t1641 = env["txt"]
		J.cl(_t1641, null, ["z", J.add(J.gp(v_q_1601, "x"), J.mul(v_h_1599, 0.6)), (J.sub(J.add(J.gp(v_q_1601, "y"), v_oy_1605), J.mul(v_h_1599, 0.35)) - J.mod((J.mul(J.gp(env["S"], "t"), 14.0) + 7.0), 14.0)), 11.0, "#c8d8ff"])
	v_top_1616 = J.sub(J.add(J.gp(v_q_1601, "y"), v_oy_1605), (J.mul(v_h_1599, 0.35) if J.t(v_bed_1610) else J.mul(v_h_1599, J.min_([1.0, v_sy_1603]))))
	if J.t((J.cmp(J.gp(v_r_1592, "shockT"), 0.0, ">") if J.t(v_FX_1594) else v_FX_1594)):
		J.mc(v_FX_1594, "bang", [env["c"], J.add(J.gp(v_q_1601, "x"), v_sx_1604), J.sub(v_top_1616, 10.0), (1.0 - J.div(J.gp(v_r_1592, "shockT"), 0.9)), 1.1])
	else:
		if J.t((v_run_1595 if J.t(v_FX_1594) else v_FX_1594)):
			J.mc(v_FX_1594, "bang", [env["c"], J.gp(v_q_1601, "x"), J.sub(v_top_1616, 8.0), 0.5, 0.9])
	var _t1642 = J.cmp(J.gp(v_r_1592, "fear"), 0.0, ">")
	if ((not J.t(v_run_1595)) if _t1642 else _t1642):
		J.mc(env["A"], "crBar", [env["c"], J.sub(J.gp(v_q_1601, "x"), 24.0), J.sub(v_top_1616, 12.0), 48.0, 8.0, J.div(J.gp(v_r_1592, "fear"), 100.0), "red"])
	var _t1643 = J.gp(v_a_1590, "saw")
	var _t1644 = (J.cmp(J.gp(v_a_1590, "seeT"), 0.2, ">") if J.t(_t1643) else _t1643)
	if J.t(((not J.cmp(J.gp(v_r_1592, "shockT"), 0.0, ">")) if J.t(_t1644) else _t1644)):
		var _t1645 = env["txt"]
		J.cl(_t1645, null, ["！", J.gp(v_q_1601, "x"), J.sub(v_top_1616, 18.0), 26.0, "#ffe25a"])
	if J.t((J.gp(v_r_1592, "scream") if J.t(v_FX_1594) else v_FX_1594)):
		var _t1647 = env["c"]
		var _t1646 = env["clamp"]
		J.mc(v_FX_1594, "scream", [_t1647, J.cl(_t1646, null, [J.gp(v_q_1601, "x"), 90.0, J.sub(env["W"], 90.0)]), J.sub(v_top_1616, 24.0), J.gp(v_r_1592, "scream"), 1.15])
	if J.t(J.gp(v_r_1592, "say")):
		var _t1648 = env["bubble"]
		J.cl(_t1648, null, [J.gp(v_q_1601, "x"), J.sub(v_top_1616, (18.0 if J.cmp(J.gp(v_r_1592, "fear"), 0.0, ">") else 6.0)), J.gp(v_r_1592, "say")])

func _f273(this_, a: Array, env):
	var v_V_1619 = null; var v_g_1620 = null; var v_lay_1621 = null; var v_gr_1622 = null; var v_lit_1623 = null; var v_h_1624 = null; var v_q_1625 = null; var v_key_1626 = null; var v_by_1627 = null; var v_sy_1628 = null; var v_rot_1629 = null; var v_ox_1630 = null; var v_oy_1631 = null; var v_al_1632 = null; var v_t_1633 = null; var v_k_1634 = null; var v_sq_1635 = null; var v_a_1636 = null; var v_aq_1637 = null; var v_u_1638 = null; var v_k2_1639 = null; var v_ah_1640 = null; var v_i_1641 = null; var v_tx_1642 = null; var v_cy_1643 = null; var v_hx_1644 = null; var v_j_1645 = null
	v_V_1619 = J.arg(a, 0)
	v_g_1620 = J.gp(env["S"], "g")
	v_lay_1621 = J.gp(env["S"], "lay")
	var _t1649 = env["roomAt"]
	v_gr_1622 = J.cl(_t1649, null, [J.gp(env["S"], "gx")])
	var _t1650 = J.gp(J.gp(env["S"], "light"), v_gr_1622)
	v_lit_1623 = (J.cmp(J.gp(env["S"], "invT"), 0.0, "<=") if J.t(_t1650) else _t1650)
	v_h_1624 = J.mul((J.mul(J.gp(v_lay_1621, "ph"), 0.74) * J.div(J.gp(J.gp(v_g_1620, "d"), "h"), 76.0)), J.gp(v_V_1619, "s"))
	var _t1651 = env["P"]
	v_q_1625 = J.cl(_t1651, null, [J.gp(env["S"], "gx"), J.gp(v_lay_1621, "floor"), v_V_1619])
	v_key_1626 = J.gp(J.gp(v_g_1620, "d"), "sprite")
	v_by_1627 = J.gp(v_q_1625, "y")
	v_sy_1628 = 1.0
	v_rot_1629 = 0.0
	v_ox_1630 = 0.0
	v_oy_1631 = 0.0
	v_al_1632 = (0.25 if J.cmp(J.gp(env["S"], "invT"), 0.0, ">") else (0.92 if J.t(v_lit_1623) else 0.5))
	var _t1652 = J.seq(J.gp(J.gp(v_g_1620, "d"), "key"), "tianhua")
	var _t1654 = (J.cmp(J.gp(env["S"], "gmv"), 0.0, "<=") if _t1652 else _t1652)
	if J.t(_t1654):
		var _t1653 = env["img"]
		_t1654 = J.cl(_t1653, null, ["tianhua_hang"])
	if J.t(_t1654):
		v_key_1626 = "tianhua_hang"
		var _t1655 = env["P"]
		var _t1656 = J.add(J.gp(J.cl(_t1655, null, [0.0, J.add(J.gp(v_lay_1621, "ceil"), 20.0), v_V_1619]), "y"), J.mul(v_h_1624, 1.05))
		v_by_1627 = _t1656
	else:
		if J.cmp(J.gp(env["S"], "gmv"), 0.0, ">"):
			var _t1657 = ((-absf(J.num(sin(J.num(J.mul(J.gp(env["S"], "t"), 12.0)))))) * 6.0)
			v_oy_1631 = _t1657
			var _t1658 = J.mul(J.gp(env["S"], "gdir"), 0.08)
			v_rot_1629 = _t1658
		else:
			var _t1659 = ((sin(J.num(J.mul(J.gp(env["S"], "t"), 2.5))) * 4.0) - 4.0)
			v_oy_1631 = _t1659
	if J.t(J.gp(env["S"], "sc")):
		v_t_1633 = J.gp(J.gp(env["S"], "sc"), "t")
		if J.cmp(v_t_1633, env["OMEN"], "<"):
			v_k_1634 = J.div(v_t_1633, env["OMEN"])
			var _t1660 = env["c"]
			var _t1661 = J.add(J.add(J.gp({"eking": "rgba(210,90,40,", "toyol": "rgba(120,220,140,", "tianhua": "rgba(110,190,255,"}, J.gp(J.gp(v_g_1620, "d"), "key")), J.mul(0.3, v_k_1634)), ")")
			J.sp(_t1660, "fillStyle", _t1661)
			J.mc(env["c"], "beginPath", [])
			J.mc(env["c"], "arc", [J.gp(v_q_1625, "x"), J.sub(v_by_1627, J.mul(v_h_1624, 0.5)), (J.mul(v_h_1624, 0.6) * (0.6 + J.mul(0.4, v_k_1634))), 0.0, 7.0])
			J.mc(env["c"], "fill", [])
			var _t1662 = (1.0 - J.mul(0.08, v_k_1634))
			v_sy_1628 = _t1662
		else:
			var _t1663 = (J.mul(J.mul(J.gp(env["S"], "gdir"), 30.0), J.gp(v_V_1619, "s")) * sin(J.num((J.min_([1.0, J.div(J.sub(v_t_1633, env["OMEN"]), 0.3)]) * PI))))
			v_ox_1630 = _t1663
	if J.cmp(J.gp(env["S"], "stun"), 0.0, ">"):
		var _t1664 = env["txt"]
		J.cl(_t1664, null, ["一、二、三……", J.gp(v_q_1625, "x"), (J.sub(v_by_1627, v_h_1624) - 10.0), 14.0, "#b8f0a0"])
	J.mc(env["c"], "save", [])
	var _t1665 = env["c"]
	J.sp(_t1665, "shadowColor", "rgba(140,255,200,0.85)")
	var _t1666 = env["c"]
	var _t1667 = (4.0 if J.t(v_lit_1623) else 14.0)
	J.sp(_t1666, "shadowBlur", _t1667)
	var _t1668 = env["sprite"]
	J.cl(_t1668, null, [v_key_1626, J.add(J.gp(v_q_1625, "x"), v_ox_1630), J.add(v_by_1627, v_oy_1631), v_h_1624, {"flip": J.cmp(J.gp(env["S"], "gdir"), 0.0, "<"), "alpha": v_al_1632, "rot": v_rot_1629, "sy": v_sy_1628}])
	J.mc(env["c"], "restore", [])
	var _t1669 = env["c"]
	J.sp(_t1669, "fillStyle", "rgba(110,255,190,0.35)")
	J.mc(env["c"], "beginPath", [])
	J.mc(env["c"], "ellipse", [J.gp(v_q_1625, "x"), J.gp(v_q_1625, "y"), (J.mul(30.0, J.gp(v_V_1619, "s")) + 8.0), 7.0, 0.0, 0.0, 7.0])
	J.mc(env["c"], "fill", [])
	var _t1670 = (not J.t(v_lit_1623))
	if (J.cmp(J.gp(env["S"], "invT"), 0.0, "<=") if _t1670 else _t1670):
		var _t1671 = env["txt"]
		J.cl(_t1671, null, ["黑暗中", J.gp(v_q_1625, "x"), J.add(J.gp(v_q_1625, "y"), 16.0), 11.0, "#a9c79a"])
	else:
		if J.t((J.cmp(J.gp(env["S"], "invT"), 0.0, "<=") if J.t(v_lit_1623) else v_lit_1623)):
			var _t1672 = env["txt"]
			J.cl(_t1672, null, ["現形！燈著咗", J.gp(v_q_1625, "x"), J.add(J.gp(v_q_1625, "y"), 16.0), 12.0, "#e48a78"])
	if J.cmp(J.gp(env["S"], "searchP"), 0.0, ">"):
		var _t1676 = null
		if J.seq(J.gp(env["S"], "searchI"), 99.0):
			var _t1673 = env["P"]
			_t1676 = J.cl(_t1673, null, [J.gp(J.gp(env["S"], "task"), "x"), J.gp(J.gp(env["S"], "task"), "y"), v_V_1619])
		else:
			var _t1675 = null
			if J.t(J.gp(J.gp(env["S"], "search"), J.gp(env["S"], "searchI"))):
				var _t1674 = env["P"]
				_t1675 = J.cl(_t1674, null, [J.gp(J.gp(J.gp(env["S"], "search"), J.gp(env["S"], "searchI")), "x"), J.gp(J.gp(J.gp(env["S"], "search"), J.gp(env["S"], "searchI")), "y"), v_V_1619])
			else:
				_t1675 = v_q_1625
			_t1676 = _t1675
		v_sq_1635 = _t1676
		var _t1677 = env["c"]
		J.sp(_t1677, "strokeStyle", "#b2d394")
		var _t1678 = env["c"]
		J.sp(_t1678, "lineWidth", 5.0)
		J.mc(env["c"], "beginPath", [])
		J.mc(env["c"], "arc", [J.gp(v_sq_1635, "x"), J.sub(J.gp(v_sq_1635, "y"), 30.0), 16.0, J.div((-PI), 2.0), (J.div((-PI), 2.0) + J.mul((PI * 2.0), J.gp(env["S"], "searchP")))])
		J.mc(env["c"], "stroke", [])
	var _t1679 = J.gp(env["S"], "sc")
	if J.t((J.cmp(J.gp(J.gp(env["S"], "sc"), "t"), env["OMEN"], ">=") if J.t(_t1679) else _t1679)):
		v_a_1636 = J.gp(J.gp(env["S"], "sc"), "a")
		var _t1680 = env["P"]
		v_aq_1637 = J.cl(_t1680, null, [J.gp(v_a_1636, "x"), J.gp(v_lay_1621, "floor"), v_V_1619])
		v_u_1638 = J.min_([1.0, J.div(J.sub(J.gp(J.gp(env["S"], "sc"), "t"), env["OMEN"]), 0.4)])
		v_k2_1639 = J.gp(J.gp(v_g_1620, "d"), "key")
		v_ah_1640 = J.mul(J.gp(v_lay_1621, "ph"), J.gp(v_V_1619, "s"))
		if J.seq(v_k2_1639, "eking"):
			J.mc(env["c"], "save", [])
			var _t1681 = env["c"]
			var _t1682 = (1.0 - J.max_([0.0, J.div((J.sub(J.gp(J.gp(env["S"], "sc"), "t"), env["OMEN"]) - 0.5), 0.4)]))
			J.sp(_t1681, "globalAlpha", _t1682)
			var _t1683 = env["c"]
			J.sp(_t1683, "fillStyle", "#120808")
			J.mc(env["c"], "beginPath", [])
			J.mc(env["c"], "ellipse", [J.gp(v_aq_1637, "x"), J.sub(J.gp(v_aq_1637, "y"), J.mul(v_ah_1640, 0.55)), J.mul(J.mul(v_ah_1640, 0.5), v_u_1638), J.mul(J.mul(v_ah_1640, 0.38), v_u_1638), 0.0, 0.0, 7.0])
			J.mc(env["c"], "fill", [])
			var _t1684 = env["c"]
			J.sp(_t1684, "fillStyle", "#7a0e0e")
			J.mc(env["c"], "beginPath", [])
			J.mc(env["c"], "ellipse", [J.gp(v_aq_1637, "x"), J.sub(J.gp(v_aq_1637, "y"), J.mul(v_ah_1640, 0.55)), J.mul(J.mul(v_ah_1640, 0.4), v_u_1638), (J.mul(J.mul(v_ah_1640, 0.24), v_u_1638) * absf(J.num(sin(J.num(J.mul(J.gp(env["S"], "t"), 12.0)))))), 0.0, 0.0, 7.0])
			J.mc(env["c"], "fill", [])
			var _t1685 = env["c"]
			J.sp(_t1685, "fillStyle", "#e8e0cc")
			v_i_1641 = 0.0
			while true:
				if not J.cmp(v_i_1641, 7.0, "<"): break
				v_tx_1642 = (J.sub(J.gp(v_aq_1637, "x"), J.mul(J.mul(v_ah_1640, 0.32), v_u_1638)) + J.mul((J.mul(v_i_1641, v_ah_1640) * 0.1), v_u_1638))
				J.mc(env["c"], "beginPath", [])
				J.mc(env["c"], "moveTo", [v_tx_1642, (J.sub(J.gp(v_aq_1637, "y"), J.mul(v_ah_1640, 0.55)) - J.mul(J.mul(v_ah_1640, 0.2), v_u_1638))])
				J.mc(env["c"], "lineTo", [J.add(v_tx_1642, J.mul(J.mul(v_ah_1640, 0.05), v_u_1638)), (J.sub(J.gp(v_aq_1637, "y"), J.mul(v_ah_1640, 0.55)) - J.mul(J.mul(v_ah_1640, 0.08), v_u_1638))])
				J.mc(env["c"], "lineTo", [J.add(v_tx_1642, J.mul(J.mul(v_ah_1640, 0.1), v_u_1638)), (J.sub(J.gp(v_aq_1637, "y"), J.mul(v_ah_1640, 0.55)) - J.mul(J.mul(v_ah_1640, 0.2), v_u_1638))])
				J.mc(env["c"], "fill", [])
				v_i_1641 = J.num(v_i_1641) + 1.0
			J.mc(env["c"], "restore", [])
		if J.seq(v_k2_1639, "tianhua"):
			var _t1686 = env["c"]
			J.sp(_t1686, "strokeStyle", "rgba(12,12,14,0.9)")
			var _t1687 = env["c"]
			J.sp(_t1687, "lineWidth", 2.4)
			var _t1688 = env["P"]
			v_cy_1643 = J.gp(J.cl(_t1688, null, [0.0, J.add(J.gp(v_lay_1621, "ceil"), 10.0), v_V_1619]), "y")
			v_hx_1644 = (-60.0)
			while true:
				if not J.cmp(v_hx_1644, 60.0, "<="): break
				J.mc(env["c"], "beginPath", [])
				J.mc(env["c"], "moveTo", [J.add(J.gp(v_aq_1637, "x"), J.mul(v_hx_1644, J.gp(v_V_1619, "s"))), v_cy_1643])
				J.mc(env["c"], "quadraticCurveTo", [J.add(J.add(J.gp(v_aq_1637, "x"), J.mul(v_hx_1644, J.gp(v_V_1619, "s"))), (sin(J.num(J.add(J.mul(J.gp(env["S"], "t"), 6.0), v_hx_1644))) * 10.0)), J.add(v_cy_1643, J.mul((J.sub(J.gp(v_aq_1637, "y"), v_cy_1643) * 0.5), v_u_1638)), J.add(J.gp(v_aq_1637, "x"), J.mul(v_hx_1644, J.gp(v_V_1619, "s"))), J.add(v_cy_1643, J.mul((J.sub(J.gp(v_aq_1637, "y"), v_cy_1643) * 0.85), v_u_1638))])
				J.mc(env["c"], "stroke", [])
				var _t1689 = J.add(v_hx_1644, 7.0)
				v_hx_1644 = _t1689
		if J.seq(v_k2_1639, "toyol"):
			v_j_1645 = 0.0
			while true:
				if not J.cmp(v_j_1645, 6.0, "<"): break
				var _t1690 = env["c"]
				J.sp(_t1690, "fillStyle", "rgba(40,30,20,0.8)")
				J.mc(env["c"], "beginPath", [])
				J.mc(env["c"], "ellipse", [(J.sub(J.gp(v_aq_1637, "x"), J.mul(80.0, J.gp(v_V_1619, "s"))) + J.mul(J.mul(v_j_1645, 28.0), J.gp(v_V_1619, "s"))), J.sub(J.gp(v_aq_1637, "y"), 4.0), 6.0, 3.0, 0.0, 0.0, 7.0])
				J.mc(env["c"], "fill", [])
				v_j_1645 = J.num(v_j_1645) + 1.0
			var _t1691 = env["sprite"]
			J.cl(_t1691, null, ["toyol", J.add(J.gp(v_aq_1637, "x"), (sin(J.num(J.mul(J.gp(env["S"], "t"), 20.0))) * 20.0)), J.sub(J.gp(v_aq_1637, "y"), J.mul(v_ah_1640, 0.6)), J.mul(v_ah_1640, 0.45), {"alpha": 0.8}])

func _f275(this_, a: Array, env):
	var v_R_1657 = null; var v_i_1658 = null; var v_a_1659 = null; var v_b_1660 = null; var v_gr_1661 = null
	v_R_1657 = J.arg(a, 0)
	v_i_1658 = J.arg(a, 1)
	var _t1703 = env["__p"]["P"]
	v_a_1659 = J.cl(_t1703, null, [J.gp(v_R_1657, "x0"), J.gp(J.gp(env["lay"], "crop"), 0.0), env["V"]])
	var _t1704 = env["__p"]["P"]
	v_b_1660 = J.cl(_t1704, null, [J.gp(v_R_1657, "x1"), J.gp(J.gp(env["lay"], "crop"), 1.0), env["V"]])
	var _t1705 = J.cmp(J.gp(v_b_1660, "x"), 0.0, "<")
	if (_t1705 if _t1705 else J.cmp(J.gp(v_a_1659, "x"), env["__p"]["W"], ">")):
		return null
	if (not J.t(J.gp(J.gp(env["__p"]["S"], "light"), v_i_1658))):
		var _t1706 = env["__p"]["c"]
		var _t1707 = (J.add("rgba(4,4,14,", (0.74 if J.cmp(J.gp(J.gp(env["__p"]["S"], "dark"), v_i_1658), 0.0, ">") else 0.6)) + ")")
		J.sp(_t1706, "fillStyle", _t1707)
		J.mc(env["__p"]["c"], "fillRect", [J.gp(v_a_1659, "x"), J.gp(v_a_1659, "y"), J.sub(J.gp(v_b_1660, "x"), J.gp(v_a_1659, "x")), J.sub(J.gp(v_b_1660, "y"), J.gp(v_a_1659, "y"))])
	else:
		v_gr_1661 = J.mc(env["__p"]["c"], "createRadialGradient", [J.div(J.add(J.gp(v_a_1659, "x"), J.gp(v_b_1660, "x")), 2.0), J.add(J.gp(v_a_1659, "y"), 30.0), 10.0, J.div(J.add(J.gp(v_a_1659, "x"), J.gp(v_b_1660, "x")), 2.0), J.add(J.gp(v_a_1659, "y"), 30.0), (J.sub(J.gp(v_b_1660, "x"), J.gp(v_a_1659, "x")) * 0.8)])
		J.mc(v_gr_1661, "addColorStop", [0.0, "rgba(255,226,160,0.12)"])
		J.mc(v_gr_1661, "addColorStop", [1.0, "rgba(255,226,160,0)"])
		var _t1708 = env["__p"]["c"]
		J.sp(_t1708, "fillStyle", v_gr_1661)
		J.mc(env["__p"]["c"], "fillRect", [J.gp(v_a_1659, "x"), J.gp(v_a_1659, "y"), J.sub(J.gp(v_b_1660, "x"), J.gp(v_a_1659, "x")), J.sub(J.gp(v_b_1660, "y"), J.gp(v_a_1659, "y"))])
	var _t1709 = env["__p"]["txt"]
	J.cl(_t1709, null, [J.add(J.gp(v_R_1657, "n"), ("・燈著" if J.t(J.gp(J.gp(env["__p"]["S"], "light"), v_i_1658)) else "・黑")), J.div(J.add(J.gp(v_a_1659, "x"), J.gp(v_b_1660, "x")), 2.0), J.add(J.gp(v_a_1659, "y"), 20.0), 12.0, ("#e8d2a0" if J.t(J.gp(J.gp(env["__p"]["S"], "light"), v_i_1658)) else "#8a7e84")])

func _f276(this_, a: Array, env):
	var v_p_1664 = null
	v_p_1664 = J.arg(a, 0)
	var _t1715 = env["__p"]["drawSpot"]
	J.cl(_t1715, null, [v_p_1664, env["V"]])

func _f278(this_, a: Array, env):
	var v_k_1675 = null
	v_k_1675 = J.arg(a, 0)
	if (not J.t(J.gp(env["cnt"], v_k_1675))):
		var _t1721 = env["cnt"]
		J.sp(_t1721, v_k_1675, 0.0)
		J.mc(env["ord"], "push", [v_k_1675])
	var _t1722 = env["cnt"]
	J.sp(_t1722, v_k_1675, J.num(J.gp(_t1722, v_k_1675)) + 1.0)

func _f279(this_, a: Array, env):
	var v_k_1678 = null
	v_k_1678 = J.arg(a, 0)
	return J.add(J.gp(J.gp(J.gp(env["__p"]["__p"]["A"], "ITEM"), v_k_1678), "n"), (J.add("×", J.gp(env["cnt"], v_k_1678)) if J.cmp(J.gp(env["cnt"], v_k_1678), 1.0, ">") else ""))

func _f277(this_, a: Array, env):
	var v_p_1667 = null; var v_i_1668 = null; var v_its_1669 = null; var v_q_1670 = null
	var _s692 = {"__p": env, "cnt": null, "ord": null}
	v_p_1667 = J.arg(a, 0)
	v_i_1668 = J.arg(a, 1)
	var _t1717 = _s692["__p"]["__p"]["itemsAt"]
	v_its_1669 = J.cl(_t1717, null, [v_i_1668])
	if (not J.t(J.len(v_its_1669))):
		return null
	var _t1718 = _s692["__p"]["__p"]["P"]
	v_q_1670 = J.cl(_t1718, null, [J.gp(v_p_1667, "x"), J.gp(v_p_1667, "y"), _s692["__p"]["V"]])
	var _t1719 = _s692["__p"]["__p"]["c"]
	var _t1720 = (J.add("rgba(230,168,90,", (0.5 + (0.3 * sin(J.num(J.add(J.mul(J.gp(_s692["__p"]["__p"]["S"], "t"), 3.0), v_i_1668)))))) + ")")
	J.sp(_t1719, "fillStyle", _t1720)
	J.mc(_s692["__p"]["__p"]["c"], "beginPath", [])
	J.mc(_s692["__p"]["__p"]["c"], "arc", [J.gp(v_q_1670, "x"), J.gp(v_q_1670, "y"), 6.0, 0.0, 7.0])
	J.mc(_s692["__p"]["__p"]["c"], "fill", [])
	_s692["cnt"] = {}
	_s692["ord"] = []
	J.mc(v_its_1669, "forEach", [Callable(self, "_f278").bind(_s692)])
	var _t1723 = _s692["__p"]["__p"]["txt"]
	var _t1724 = J.mc(_s692["ord"], "map", [Callable(self, "_f279").bind(_s692)])
	J.cl(_t1723, null, [J.add("✦", J.mc(_t1724, "join", [" "])), J.gp(v_q_1670, "x"), J.sub(J.gp(v_q_1670, "y"), 12.0), 11.0, "#e6dcc6"])

func _f280(this_, a: Array, env):
	var v_a_1681 = null; var v_b_1682 = null
	v_a_1681 = J.arg(a, 0)
	v_b_1682 = J.arg(a, 1)
	return ((-1.0) if J.seq(J.gp(v_a_1681, "act"), "bed") else 0.0)

func _f281(this_, a: Array, env):
	var v_a_1685 = null
	v_a_1685 = J.arg(a, 0)
	var _t1733 = env["__p"]["drawActor"]
	J.cl(_t1733, null, [v_a_1685, env["V"]])

func _f282(this_, a: Array, env):
	var v_p_1688 = null; var v_q_1689 = null; var v_a_1690 = null
	v_p_1688 = J.arg(a, 0)
	var _t1736 = env["__p"]["P"]
	v_q_1689 = J.cl(_t1736, null, [J.gp(v_p_1688, "x"), J.gp(v_p_1688, "y"), env["V"]])
	v_a_1690 = J.div(J.gp(v_p_1688, "life"), J.gp(v_p_1688, "max"))
	var _t1737 = env["__p"]["c"]
	var _t1738 = J.min_([1.0, J.mul(v_a_1690, 1.4)])
	J.sp(_t1737, "globalAlpha", _t1738)
	var _t1739 = env["__p"]["c"]
	var _t1740 = ("#9fd0f0" if J.seq(J.gp(v_p_1688, "type"), "drop") else ("#e6c25a" if J.seq(J.gp(v_p_1688, "type"), "coin") else ("rgba(180,170,150,0.6)" if J.seq(J.gp(v_p_1688, "type"), "dust") else ("#e8c07a" if J.seq(J.gp(v_p_1688, "type"), "crumb") else "#f0e0b0"))))
	J.sp(_t1739, "fillStyle", _t1740)
	J.mc(env["__p"]["c"], "beginPath", [])
	J.mc(env["__p"]["c"], "arc", [J.gp(v_q_1689, "x"), J.gp(v_q_1689, "y"), (((6.0 * J.sub(1.0, v_a_1690)) + 2.0) if J.seq(J.gp(v_p_1688, "type"), "dust") else 3.0), 0.0, 7.0])
	J.mc(env["__p"]["c"], "fill", [])
	var _t1741 = env["__p"]["c"]
	J.sp(_t1741, "globalAlpha", 1.0)

func _f283(this_, a: Array, env):
	var v_f_1693 = null; var v_q_1694 = null
	v_f_1693 = J.arg(a, 0)
	var _t1743 = env["__p"]["P"]
	v_q_1694 = J.cl(_t1743, null, [J.gp(v_f_1693, "x"), J.gp(v_f_1693, "y"), env["V"]])
	var _t1744 = env["__p"]["c"]
	var _t1745 = J.min_([1.0, J.gp(v_f_1693, "life")])
	J.sp(_t1744, "globalAlpha", _t1745)
	var _t1746 = env["__p"]["txt"]
	var _t1748 = J.gp(v_f_1693, "t")
	var _t1747 = env["__p"]["clamp"]
	J.cl(_t1746, null, [_t1748, J.cl(_t1747, null, [J.gp(v_q_1694, "x"), 80.0, J.sub(env["__p"]["W"], 80.0)]), J.gp(v_q_1694, "y"), 15.0, J.gp(v_f_1693, "c")])
	var _t1749 = env["__p"]["c"]
	J.sp(_t1749, "globalAlpha", 1.0)

func _f274(this_, a: Array, env):
	var v_g0_1650 = null; var v_fx_1651 = null; var v_tgt_1652 = null; var v_dq_1653 = null; var v_tq_1654 = null
	var _s686 = {"__p": env, "V": null, "lay": null}
	J.cl(_s686["__p"]["layout"], null, [])
	J.mc(_s686["__p"]["c"], "setTransform", [_s686["__p"]["DPR"], 0.0, 0.0, _s686["__p"]["DPR"], 0.0, 0.0])
	var _t1692 = _s686["__p"]["c"]
	J.sp(_t1692, "fillStyle", "#0b0b0d")
	J.mc(_s686["__p"]["c"], "fillRect", [0.0, 0.0, _s686["__p"]["W"], _s686["__p"]["H"]])
	var _t1693 = []
	_s686["__p"]["BTN"] = _t1693
	_s686["V"] = J.cl(_s686["__p"]["view"], null, [])
	_s686["lay"] = J.gp(_s686["__p"]["S"], "lay")
	v_g0_1650 = J.cl(_s686["__p"]["G"], null, [])
	v_fx_1651 = J.gp(_s686["__p"]["S"], "gx")
	var _t1694 = J.gp(_s686["__p"]["S"], "sc")
	if J.t((J.gp(J.gp(_s686["__p"]["S"], "sc"), "a") if J.t(_t1694) else _t1694)):
		var _t1695 = J.div(J.add(J.gp(_s686["__p"]["S"], "gx"), J.gp(J.gp(J.gp(_s686["__p"]["S"], "sc"), "a"), "x")), 2.0)
		v_fx_1651 = _t1695
	v_tgt_1652 = (J.gp(J.gp(_s686["__p"]["S"], "cam"), "free") if (not J.leq(J.gp(J.gp(_s686["__p"]["S"], "cam"), "free"), null)) else J.sub(v_fx_1651, J.div(J.gp(_s686["V"], "vw"), 2.0)))
	var _t1696 = _s686["__p"]["clamp"]
	var _t1697 = J.cl(_t1696, null, [v_tgt_1652, 0.0, J.max_([0.0, J.sub(J.gp(_s686["lay"], "W"), J.gp(_s686["V"], "vw"))])])
	v_tgt_1652 = _t1697
	var _t1698 = J.gp(_s686["__p"]["S"], "cam")
	var _t1699 = J.add(J.gp(_t1698, "x"), (J.sub(v_tgt_1652, J.gp(J.gp(_s686["__p"]["S"], "cam"), "x")) * 0.18))
	J.sp(_t1698, "x", _t1699)
	if (absf(J.num(J.sub(v_tgt_1652, J.gp(J.gp(_s686["__p"]["S"], "cam"), "x")))) < 0.5):
		var _t1700 = J.gp(_s686["__p"]["S"], "cam")
		J.sp(_t1700, "x", v_tgt_1652)
	J.mc(_s686["__p"]["c"], "save", [])
	J.mc(_s686["__p"]["c"], "beginPath", [])
	J.mc(_s686["__p"]["c"], "rect", [0.0, J.gp(_s686["V"], "top"), _s686["__p"]["W"], J.gp(_s686["V"], "ph")])
	J.mc(_s686["__p"]["c"], "clip", [])
	if J.cmp(J.gp(_s686["__p"]["S"], "flash"), 0.0, ">"):
		J.mc(_s686["__p"]["c"], "translate", [J.mul(((randf() - 0.5) * 8.0), J.gp(_s686["__p"]["S"], "flash")), 0.0])
	var _t1701 = _s686["__p"]["drawBG"]
	J.cl(_t1701, null, [_s686["V"]])
	var _t1702 = J.gp(_s686["lay"], "rooms")
	J.mc(_t1702, "forEach", [Callable(self, "_f275").bind(_s686)])
	var _t1710 = _s686["__p"]["P"]
	v_dq_1653 = J.cl(_t1710, null, [J.gp(_s686["lay"], "door"), J.gp(_s686["lay"], "floor"), _s686["V"]])
	var _t1711 = _s686["__p"]["c"]
	var _t1712 = (J.add("rgba(120,255,190,", (0.2 + (0.15 * sin(J.num(J.mul(J.gp(_s686["__p"]["S"], "t"), 4.0)))))) + ")")
	J.sp(_t1711, "fillStyle", _t1712)
	J.mc(_s686["__p"]["c"], "fillRect", [J.sub(J.gp(v_dq_1653, "x"), 16.0), J.sub(J.gp(v_dq_1653, "y"), (J.mul(J.gp(_s686["lay"], "ph"), J.gp(_s686["V"], "s")) * 1.05)), 32.0, (J.mul(J.gp(_s686["lay"], "ph"), J.gp(_s686["V"], "s")) * 1.05)])
	var _t1713 = _s686["__p"]["txt"]
	J.cl(_t1713, null, ["門口", J.gp(v_dq_1653, "x"), (J.sub(J.gp(v_dq_1653, "y"), (J.mul(J.gp(_s686["lay"], "ph"), J.gp(_s686["V"], "s")) * 1.05)) - 6.0), 12.0, "#a9c79a"])
	var _t1714 = J.gp(_s686["__p"]["S"], "spots")
	J.mc(_t1714, "forEach", [Callable(self, "_f276").bind(_s686)])
	var _t1716 = J.gp(_s686["__p"]["S"], "search")
	J.mc(_t1716, "forEach", [Callable(self, "_f277").bind(_s686)])
	var _t1725 = J.seq(J.gp(J.gp(_s686["__p"]["S"], "task"), "k"), "steal")
	if ((not J.t(J.gp(J.gp(_s686["__p"]["S"], "task"), "done"))) if _t1725 else _t1725):
		var _t1726 = _s686["__p"]["P"]
		v_tq_1654 = J.cl(_t1726, null, [J.gp(J.gp(_s686["__p"]["S"], "task"), "x"), J.gp(J.gp(_s686["__p"]["S"], "task"), "y"), _s686["V"]])
		var _t1727 = _s686["__p"]["c"]
		var _t1728 = (J.add("rgba(178,211,148,", (0.6 + (0.3 * sin(J.num(J.mul(J.gp(_s686["__p"]["S"], "t"), 5.0)))))) + ")")
		J.sp(_t1727, "strokeStyle", _t1728)
		var _t1729 = _s686["__p"]["c"]
		J.sp(_t1729, "lineWidth", 3.0)
		J.mc(_s686["__p"]["c"], "beginPath", [])
		J.mc(_s686["__p"]["c"], "arc", [J.gp(v_tq_1654, "x"), J.gp(v_tq_1654, "y"), 14.0, 0.0, 7.0])
		J.mc(_s686["__p"]["c"], "stroke", [])
		var _t1730 = _s686["__p"]["txt"]
		J.cl(_t1730, null, [J.add("任務：", J.gp(J.gp(_s686["__p"]["S"], "task"), "o")), J.gp(v_tq_1654, "x"), J.sub(J.gp(v_tq_1654, "y"), 20.0), 12.0, "#b2d394"])
	var _t1731 = J.mc(J.gp(_s686["__p"]["S"], "actors"), "slice", [])
	var _t1732 = J.mc(_t1731, "sort", [Callable(self, "_f280").bind(_s686)])
	J.mc(_t1732, "forEach", [Callable(self, "_f281").bind(_s686)])
	var _t1734 = _s686["__p"]["drawGhost"]
	J.cl(_t1734, null, [_s686["V"]])
	var _t1735 = J.gp(_s686["__p"]["S"], "parts")
	J.mc(_t1735, "forEach", [Callable(self, "_f282").bind(_s686)])
	var _t1742 = J.gp(_s686["__p"]["S"], "floats")
	J.mc(_t1742, "forEach", [Callable(self, "_f283").bind(_s686)])
	if J.cmp(J.gp(_s686["__p"]["S"], "flash"), 0.0, ">"):
		var _t1750 = _s686["__p"]["c"]
		var _t1751 = (J.add("rgba(255,250,230,", J.mul(J.gp(_s686["__p"]["S"], "flash"), 0.5)) + ")")
		J.sp(_t1750, "fillStyle", _t1751)
		J.mc(_s686["__p"]["c"], "fillRect", [0.0, J.gp(_s686["V"], "top"), _s686["__p"]["W"], J.gp(_s686["V"], "ph")])
	J.mc(_s686["__p"]["c"], "restore", [])
	if (not J.leq(J.gp(J.gp(_s686["__p"]["S"], "cam"), "free"), null)):
		var _t1752 = _s686["__p"]["btn"]
		J.cl(_t1752, null, ["follow", (J.div(_s686["__p"]["W"], 2.0) - 66.0), J.add(J.gp(_s686["V"], "top"), 8.0), 132.0, 46.0, "◎ 跟返隻鬼", "moss"])
	var _t1753 = _s686["__p"]["drawHUD"]
	J.cl(_t1753, null, [_s686["V"], v_g0_1650])
	J.cl(_s686["__p"]["drawJoy"], null, [])

func _f286(this_, a: Array, env):
	var v_a_1722 = null
	v_a_1722 = J.arg(a, 0)
	var _t1765 = env["__p"]["__p"]["roomAt"]
	var _t1766 = J.seq(J.cl(_t1765, null, [J.gp(v_a_1722, "x")]), env["i"])
	return ((not J.seq(J.gp(v_a_1722, "st"), "run")) if _t1766 else _t1766)

func _f285(this_, a: Array, env):
	var v_R_1716 = null; var v_x_1718 = null; var v_ppl_1719 = null
	var _s704 = {"__p": env, "i": null}
	v_R_1716 = J.arg(a, 0)
	_s704["i"] = J.arg(a, 1)
	v_x_1718 = (10.0 + J.mul(_s704["i"], J.add(_s704["__p"]["tw"], 6.0)))
	var _t1764 = J.gp(_s704["__p"]["__p"]["S"], "actors")
	v_ppl_1719 = J.len(J.mc(_t1764, "filter", [Callable(self, "_f286").bind(_s704)]))
	var _t1767 = _s704["__p"]["__p"]["btn"]
	J.cl(_t1767, null, [J.add("room", _s704["i"]), v_x_1718, J.add(_s704["__p"]["y0"], 8.0), _s704["__p"]["tw"], 36.0, "", ("moss" if J.seq(_s704["i"], _s704["__p"]["gr"]) else ("rust" if J.t(J.gp(J.gp(_s704["__p"]["__p"]["S"], "light"), _s704["i"])) else "ink"))])
	var _t1768 = _s704["__p"]["__p"]["txt"]
	J.cl(_t1768, null, [J.add(J.gp(v_R_1716, "n"), ((J.add(" ", v_ppl_1719) + "人") if J.t(v_ppl_1719) else "")), J.add(v_x_1718, J.div(_s704["__p"]["tw"], 2.0)), J.add(_s704["__p"]["y0"], 24.0), 12.0, "#efe5cf", "center", J.sub(_s704["__p"]["tw"], 6.0)])
	var _t1769 = _s704["__p"]["__p"]["txt"]
	J.cl(_t1769, null, [("燈著" if J.t(J.gp(J.gp(_s704["__p"]["__p"]["S"], "light"), _s704["i"])) else "黑"), J.add(v_x_1718, J.div(_s704["__p"]["tw"], 2.0)), J.add(_s704["__p"]["y0"], 39.0), 10.0, ("#efdcb4" if J.t(J.gp(J.gp(_s704["__p"]["__p"]["S"], "light"), _s704["i"])) else "#9a8e92"), "center"])

func _f284(this_, a: Array, env):
	var v_V_1697 = null; var v_g0_1698 = null; var v_lay_1699 = null; var v_un_1700 = null; var v_T_1701 = null; var v_hh_1702 = null; var v_fr_1703 = null; var v_mh_1705 = null; var v_n_1706 = null; var v_T2_1709 = null; var v_g_1710 = null; var v_bx_1711 = null; var v_by_1712 = null; var v_C_1713 = null
	var _s702 = {"__p": env, "y0": null, "tw": null, "gr": null}
	v_V_1697 = J.arg(a, 0)
	v_g0_1698 = J.arg(a, 1)
	v_lay_1699 = J.gp(_s702["__p"]["S"], "lay")
	v_un_1700 = J.gp(_s702["__p"]["S"], "un")
	v_T_1701 = J.gp(_s702["__p"]["A"], "TOP")
	v_hh_1702 = J.gp(J.gp(_s702["__p"]["A"], "HH"), J.gp(v_un_1700, "hh"))
	J.mc(_s702["__p"]["A"], "crPanel", [_s702["__p"]["c"], (-8.0), (-8.0), J.add(_s702["__p"]["W"], 16.0), J.add(v_T_1701, 8.0), "paper"])
	v_fr_1703 = J.min_([1.0, J.div(J.gp(v_g0_1698, "t"), J.mul(J.gp(_s702["__p"]["A"], "PHT"), 3.0))])
	J.mc(_s702["__p"]["A"], "crBar", [_s702["__p"]["c"], 12.0, 8.0, J.sub(_s702["__p"]["W"], 24.0), 13.0, v_fr_1703, "dawn"])
	var _t1754 = _s702["__p"]["txt"]
	J.cl(_t1754, null, [(J.add((J.add((J.add(J.add(J.gp(J.gp(_s702["__p"]["A"], "FLN"), J.gp(v_un_1700, "f")), "・"), (J.gp(v_hh_1702, "n") if J.t(v_hh_1702) else "住戶")) + "　"), (J.gp(J.gp(_s702["__p"]["A"], "PH"), J.gp(v_g0_1698, "phase")) if J.cmp(J.gp(v_g0_1698, "phase"), 3.0, "<") else "天光")) + "　屋內剩 "), J.max_([0.0, ceil(J.num(J.gp(_s702["__p"]["S"], "limit")))])) + " 秒"), 12.0, 40.0, 14.0, ("#e48a78" if J.cmp(J.gp(_s702["__p"]["S"], "limit"), 15.0, "<") else "#efe5cf"), "left", J.sub(_s702["__p"]["W"], 120.0)])
	var _t1755 = _s702["__p"]["txt"]
	J.cl(_t1755, null, ["屋企人警覺", 12.0, 70.0, 13.0, ("#e48a78" if J.cmp(J.gp(_s702["__p"]["S"], "alert"), 70.0, ">=") else "#cfc4b0"), "left"])
	J.mc(_s702["__p"]["A"], "crBar", [_s702["__p"]["c"], 98.0, 58.0, J.sub(_s702["__p"]["W"], 216.0), 15.0, J.div(J.gp(_s702["__p"]["S"], "alert"), 100.0), "red"])
	var _t1756 = _s702["__p"]["txt"]
	J.cl(_t1756, null, [J.add(J.round(J.num(J.gp(_s702["__p"]["S"], "alert"))), ""), (98.0 + J.div(J.sub(_s702["__p"]["W"], 216.0), 2.0)), 71.0, 11.0, "#efe5cf"])
	var _t1757 = _s702["__p"]["btn"]
	J.cl(_t1757, null, ["out", J.sub(_s702["__p"]["W"], 108.0), 32.0, 98.0, 52.0, "出屋", "moss"])
	_s702["y0"] = J.sub(_s702["__p"]["H"], J.gp(_s702["__p"]["A"], "BOT"))
	J.mc(_s702["__p"]["A"], "crPanel", [_s702["__p"]["c"], (-8.0), _s702["y0"], J.add(_s702["__p"]["W"], 16.0), J.add(J.gp(_s702["__p"]["A"], "BOT"), 8.0), "paper"])
	var _t1758 = J.cmp(J.gp(_s702["__p"]["S"], "msgT"), 0.0, ">")
	if J.t((J.gp(_s702["__p"]["S"], "msg") if _t1758 else _t1758)):
		v_mh_1705 = 56.0
		J.mc(_s702["__p"]["A"], "crPanel", [_s702["__p"]["c"], 10.0, (J.sub(_s702["y0"], v_mh_1705) - 6.0), J.sub(_s702["__p"]["W"], 20.0), v_mh_1705, "sheet"])
		var _t1759 = _s702["__p"]["c"]
		var _t1760 = J.add("bold 13px ", J.gp(_s702["__p"]["A"], "FONT"))
		J.sp(_t1759, "font", _t1760)
		var _t1761 = _s702["__p"]["wrapT"]
		J.cl(_t1761, null, [J.gp(_s702["__p"]["S"], "msg"), 20.0, (J.sub(_s702["y0"], v_mh_1705) + 14.0), J.sub(_s702["__p"]["W"], 40.0), 17.0, J.gp(_s702["__p"]["S"], "msgC")])
	v_n_1706 = J.len(J.gp(v_lay_1699, "rooms"))
	_s702["tw"] = J.div((J.sub(_s702["__p"]["W"], 20.0) - (J.sub(v_n_1706, 1.0) * 6.0)), v_n_1706)
	var _t1762 = _s702["__p"]["roomAt"]
	_s702["gr"] = J.cl(_t1762, null, [J.gp(_s702["__p"]["S"], "gx")])
	var _t1763 = J.gp(v_lay_1699, "rooms")
	J.mc(_t1763, "forEach", [Callable(self, "_f285").bind(_s702)])
	v_T2_1709 = J.gp(_s702["__p"]["S"], "task")
	var _t1770 = _s702["__p"]["txt"]
	J.cl(_t1770, null, [J.add(("✓ 任務完成：" if J.t(J.gp(v_T2_1709, "done")) else "任務："), J.gp(v_T2_1709, "t")), 12.0, J.add(_s702["y0"], 64.0), 13.0, ("#b2d394" if J.t(J.gp(v_T2_1709, "done")) else "#e8d2a0"), "left", J.sub(_s702["__p"]["W"], 24.0)])
	v_g_1710 = J.gp(_s702["__p"]["S"], "g")
	v_bx_1711 = 10.0
	v_by_1712 = J.add(_s702["y0"], 76.0)
	var _t1771 = _s702["__p"]["btn"]
	var _t1772 = J.cmp(J.gp(_s702["__p"]["S"], "scCd"), 0.0, ">")
	J.cl(_t1771, null, ["scare", v_bx_1711, v_by_1712, 104.0, 58.0, (J.add("嚇！", ceil(J.num(J.gp(_s702["__p"]["S"], "scCd")))) if ((not J.t(J.gp(_s702["__p"]["S"], "sc"))) if _t1772 else _t1772) else "嚇！"), "red"])
	var _t1773 = _s702["__p"]["btn"]
	J.cl(_t1773, null, ["inv", J.add(v_bx_1711, 112.0), v_by_1712, 84.0, 58.0, (J.add("隱身 ", ceil(J.num(J.gp(v_g_1710, "invCd")))) if J.cmp(J.gp(v_g_1710, "invCd"), 0.0, ">") else "隱身"), "violet", J.cmp(J.gp(v_g_1710, "invCd"), 0.0, "<=")])
	v_C_1713 = J.cl(_s702["__p"]["ctxBtn"], null, [])
	if J.t(v_C_1713):
		var _t1774 = _s702["__p"]["btn"]
		J.cl(_t1774, null, ["ctx", J.add(v_bx_1711, 204.0), v_by_1712, (J.sub(_s702["__p"]["W"], v_bx_1711) - 214.0), 58.0, J.gp(v_C_1713, "t"), J.gp(v_C_1713, "tone"), (not J.seq(J.gp(v_C_1713, "on"), false))])
	else:
		var _t1775 = _s702["__p"]["txt"]
		J.cl(_t1775, null, ["行近發光圈＝作怪點", J.add(J.add(v_bx_1711, 204.0), J.div((J.sub(_s702["__p"]["W"], v_bx_1711) - 214.0), 2.0)), J.add(v_by_1712, 34.0), 12.0, "#9a8e92", "center", (J.sub(_s702["__p"]["W"], v_bx_1711) - 220.0)])
	var _t1776 = _s702["__p"]["txt"]
	var _t1778 = (J.add((J.add((J.add((J.add("怕意 ", J.gp(v_g0_1698, "fear")) + "　收穫 "), J.len(J.gp(v_g0_1698, "bag"))) + "/"), J.gp(_s702["__p"]["A"], "BAGMAX")) + "　紙人 "), J.gp(v_g0_1698, "dolls")) + "/6　匙 紅")
	var _t1777 = J.gp(J.gp(v_g0_1698, "keys"), "key")
	var _t1780 = (J.add(_t1778, (_t1777 if J.t(_t1777) else 0.0)) + " 黃")
	var _t1779 = J.gp(J.gp(v_g0_1698, "keys"), "key2")
	J.cl(_t1776, null, [J.add(_t1780, (_t1779 if J.t(_t1779) else 0.0)), 12.0, J.add(_s702["y0"], 156.0), 12.0, "#cfc4b0", "left", J.sub(_s702["__p"]["W"], 24.0)])
	var _t1781 = _s702["__p"]["txt"]
	J.cl(_t1781, null, ["拖動＝移動；撳作怪點／住客＝飄過去做；企定喺✦先搜得嘢", J.div(_s702["__p"]["W"], 2.0), J.sub(_s702["__p"]["H"], 14.0), 12.0, "#9a8e92", "center", J.sub(_s702["__p"]["W"], 16.0)])

func _f288(this_, a: Array, env):
	var v_p_1733 = null; var v_d_1734 = null
	v_p_1733 = J.arg(a, 0)
	if (not J.seq(J.gp(v_p_1733, "room"), env["gr"])):
		return null
	v_d_1734 = absf(J.num(J.sub(J.gp(v_p_1733, "x"), J.gp(env["__p"]["S"], "gx"))))
	if J.cmp(v_d_1734, env["bd"], "<"):
		env["bd"] = v_d_1734
		env["best"] = v_p_1733

func _f287(this_, a: Array, env):
	var v_g_1725 = null; var v_a_1726 = null; var v_e_1730 = null
	var _s706 = {"__p": env, "gr": null, "best": null, "bd": null}
	v_g_1725 = J.gp(_s706["__p"]["S"], "g")
	v_a_1726 = null
	var _t1782 = J.mc(_s706["__p"]["A"], "ctxAction", [v_g_1725])
	v_a_1726 = _t1782
	if J.t((J.seq(J.gp(v_a_1726, "k"), "deliver") if J.t(v_a_1726) else v_a_1726)):
		return {"k": "deliver", "t": J.gp(v_a_1726, "t"), "tone": "moss"}
	var _t1783 = _s706["__p"]["roomAt"]
	_s706["gr"] = J.cl(_t1783, null, [J.gp(_s706["__p"]["S"], "gx")])
	_s706["best"] = null
	_s706["bd"] = J.add(_s706["__p"]["RANGE_HOT"], 1.0)
	var _t1784 = J.gp(_s706["__p"]["S"], "spots")
	J.mc(_t1784, "forEach", [Callable(self, "_f288").bind(_s706)])
	if J.t(_s706["best"]):
		return ({"k": "hot", "p": _s706["best"], "t": (J.add(J.add(J.gp(J.gp(_s706["__p"]["HOT"], J.gp(_s706["best"], "k")), "v"), " "), ceil(J.num(J.gp(_s706["best"], "cd")))) + "s"), "tone": "ink", "on": false} if J.cmp(J.gp(_s706["best"], "cd"), 0.0, ">") else {"k": "hot", "p": _s706["best"], "t": J.add("作怪：", J.gp(J.gp(_s706["__p"]["HOT"], J.gp(_s706["best"], "k")), "v")), "tone": "rust"})
	if J.cmp(J.gp(_s706["__p"]["S"], "searchI"), 0.0, ">="):
		return {"k": "search", "t": "搜緊……企定", "tone": "ink", "on": false}
	return null

func _f289(this_, a: Array, env):
	var v_t_1737 = null; var v_x_1738 = null; var v_y_1739 = null; var v_w_1740 = null; var v_lh_1741 = null; var v_col_1742 = null; var v_ln_1743 = null; var v_yy_1744 = null; var v_i_1745 = null; var v_tt_1746 = null
	v_t_1737 = J.arg(a, 0)
	v_x_1738 = J.arg(a, 1)
	v_y_1739 = J.arg(a, 2)
	v_w_1740 = J.arg(a, 3)
	v_lh_1741 = J.arg(a, 4)
	v_col_1742 = J.arg(a, 5)
	v_ln_1743 = ""
	v_yy_1744 = v_y_1739
	v_i_1745 = 0.0
	while true:
		if not J.cmp(v_i_1745, J.len(v_t_1737), "<"): break
		v_tt_1746 = J.add(v_ln_1743, J.gp(v_t_1737, v_i_1745))
		if J.cmp(J.gp(J.mc(env["c"], "measureText", [v_tt_1746]), "width"), v_w_1740, ">"):
			var _t1785 = env["txt"]
			J.cl(_t1785, null, [v_ln_1743, v_x_1738, v_yy_1744, 13.0, v_col_1742, "left"])
			v_ln_1743 = J.gp(v_t_1737, v_i_1745)
			var _t1786 = J.add(v_yy_1744, v_lh_1741)
			v_yy_1744 = _t1786
			if J.cmp(v_yy_1744, J.add(v_y_1739, J.mul(v_lh_1741, 1.5)), ">"):
				v_ln_1743 = ""
				break
		else:
			v_ln_1743 = v_tt_1746
		v_i_1745 = J.num(v_i_1745) + 1.0
	if J.t(v_ln_1743):
		var _t1787 = env["txt"]
		J.cl(_t1787, null, [v_ln_1743, v_x_1738, v_yy_1744, 13.0, v_col_1742, "left"])

func _f290(this_, a: Array, env):
	var v_j_1749 = null; var v_dx_1750 = null
	var _t1788 = (not J.t(env["S"]))
	var _t1789 = (_t1788 if _t1788 else (not J.t(J.gp(env["S"], "joy"))))
	if (_t1789 if _t1789 else (not J.t(J.gp(J.gp(env["S"], "joy"), "on")))):
		return null
	v_j_1749 = J.gp(env["S"], "joy")
	var _t1790 = env["clamp"]
	v_dx_1750 = J.cl(_t1790, null, [J.sub(J.gp(v_j_1749, "x"), J.gp(v_j_1749, "ox")), (-58.0), 58.0])
	J.mc(env["c"], "save", [])
	var _t1791 = env["c"]
	J.sp(_t1791, "globalAlpha", 0.7)
	J.mc(env["A"], "crBlit", [env["c"], J.mc(env["A"], "crGet", [116.0, 116.0, "paper", "ring"]), J.sub(J.gp(v_j_1749, "ox"), 58.0), J.sub(J.gp(v_j_1749, "oy"), 58.0)])
	var _t1792 = env["c"]
	J.sp(_t1792, "globalAlpha", 0.92)
	J.mc(env["A"], "crBlit", [env["c"], J.mc(env["A"], "crGet", [48.0, 48.0, "bone", "ring2"]), J.sub(J.add(J.gp(v_j_1749, "ox"), v_dx_1750), 24.0), J.sub(J.gp(v_j_1749, "oy"), 24.0)])
	J.mc(env["c"], "restore", [])

func _f291(this_, a: Array, env):
	var v_e_1753 = null; var v_r_1754 = null
	v_e_1753 = J.arg(a, 0)
	v_r_1754 = J.mc(env["cv"], "getBoundingClientRect", [])
	return {"x": J.sub(J.gp(v_e_1753, "clientX"), J.gp(v_r_1754, "left")), "y": J.sub(J.gp(v_e_1753, "clientY"), J.gp(v_r_1754, "top"))}

func _f292(this_, a: Array, env):
	var v_x_1757 = null; var v_y_1758 = null; var v_best_1759 = null; var v_bd_1760 = null; var v_PAD_1761 = null; var v_i_1762 = null; var v_b_1763 = null; var v_d_1764 = null
	v_x_1757 = J.arg(a, 0)
	v_y_1758 = J.arg(a, 1)
	v_best_1759 = null
	v_bd_1760 = 1000000000.0
	v_PAD_1761 = 10.0
	v_i_1762 = (J.len(env["BTN"]) - 1.0)
	while true:
		if not J.cmp(v_i_1762, 0.0, ">="): break
		v_b_1763 = J.gp(env["BTN"], v_i_1762)
		var _t1793 = J.cmp(v_x_1757, J.sub(J.gp(v_b_1763, "x"), v_PAD_1761), ">=")
		var _t1794 = (J.cmp(v_x_1757, J.add(J.add(J.gp(v_b_1763, "x"), J.gp(v_b_1763, "w")), v_PAD_1761), "<=") if _t1793 else _t1793)
		var _t1795 = (J.cmp(v_y_1758, J.sub(J.gp(v_b_1763, "y"), v_PAD_1761), ">=") if _t1794 else _t1794)
		if (J.cmp(v_y_1758, J.add(J.add(J.gp(v_b_1763, "y"), J.gp(v_b_1763, "h")), v_PAD_1761), "<=") if _t1795 else _t1795):
			var _t1796 = J.cmp(v_x_1757, J.gp(v_b_1763, "x"), ">=")
			var _t1797 = (J.cmp(v_x_1757, J.add(J.gp(v_b_1763, "x"), J.gp(v_b_1763, "w")), "<=") if _t1796 else _t1796)
			var _t1798 = (J.cmp(v_y_1758, J.gp(v_b_1763, "y"), ">=") if _t1797 else _t1797)
			v_d_1764 = ((-1.0) if (J.cmp(v_y_1758, J.add(J.gp(v_b_1763, "y"), J.gp(v_b_1763, "h")), "<=") if _t1798 else _t1798) else J.hypot_([J.sub(v_x_1757, J.add(J.gp(v_b_1763, "x"), J.div(J.gp(v_b_1763, "w"), 2.0))), J.sub(v_y_1758, J.add(J.gp(v_b_1763, "y"), J.div(J.gp(v_b_1763, "h"), 2.0)))]))
			if J.cmp(v_d_1764, v_bd_1760, "<"):
				v_bd_1760 = v_d_1764
				v_best_1759 = v_b_1763
		v_i_1762 = J.num(v_i_1762) + -1.0
	return v_best_1759

func _f299(this_, a: Array, env):
	var v_id_1796 = null; var v_g0_1797 = null; var v_g_1798 = null; var v_R_1799 = null; var v_V_1800 = null; var v_C_1801 = null
	v_id_1796 = J.arg(a, 0)
	if (not J.t(env["S"])):
		return null
	v_g0_1797 = J.cl(env["G"], null, [])
	v_g_1798 = J.gp(env["S"], "g")
	if J.seq(v_id_1796, "out"):
		J.mc(env["U"], "exit", ["door"])
		return null
	if J.seq(v_id_1796, "follow"):
		var _t1799 = J.gp(env["S"], "cam")
		J.sp(_t1799, "free", null)
		return null
	if J.seq(J.mc(v_id_1796, "indexOf", ["room"]), 0.0):
		v_R_1799 = J.gp(J.gp(J.gp(env["S"], "lay"), "rooms"), J.num(J.mc(v_id_1796, "slice", [4.0])))
		v_V_1800 = J.cl(env["view"], null, [])
		var _t1800 = J.gp(env["S"], "cam")
		var _t1801 = env["clamp"]
		var _t1802 = J.cl(_t1801, null, [(J.div(J.add(J.gp(v_R_1799, "x0"), J.gp(v_R_1799, "x1")), 2.0) - J.div(J.gp(v_V_1800, "vw"), 2.0)), 0.0, J.max_([0.0, J.sub(J.gp(J.gp(env["S"], "lay"), "W"), J.gp(v_V_1800, "vw"))])])
		J.sp(_t1800, "free", _t1802)
		return null
	if J.seq(v_id_1796, "scare"):
		var _t1803 = J.gp(env["S"], "cam")
		J.sp(_t1803, "free", null)
		J.mc(env["U"], "scare", [])
		return null
	if J.seq(v_id_1796, "inv"):
		if J.cmp(J.gp(v_g_1798, "invCd"), 0.0, ">"):
			return null
		var _t1804 = env["S"]
		var _t1806 = J.gp(J.gp(v_g0_1797, "mods"), "inv")
		var _t1805 = J.gp(v_g_1798, "im")
		var _t1807 = J.mul(_t1806, (_t1805 if J.t(_t1805) else 1.0))
		J.sp(_t1804, "invT", _t1807)
		var _t1809 = J.gp(env["S"], "invT")
		var _t1808 = J.gp(v_g_1798, "icd")
		var _t1810 = J.add(_t1809, J.mul(9.0, (_t1808 if J.t(_t1808) else 1.0)))
		J.sp(v_g_1798, "invCd", _t1810)
		var _t1811 = env["wfl"]
		J.cl(_t1811, null, [J.gp(env["S"], "gx"), (J.sub(J.gp(J.gp(env["S"], "lay"), "floor"), J.gp(J.gp(env["S"], "lay"), "ph")) - 20.0), "隱身", "#a9a0d8"])
		return null
	if J.seq(v_id_1796, "ctx"):
		v_C_1801 = J.cl(env["ctxBtn"], null, [])
		if (not J.t(v_C_1801)):
			return null
		if J.seq(J.gp(v_C_1801, "k"), "deliver"):
			J.mc(env["A"], "actPress", [])
			var _t1812 = env["msg"]
			J.cl(_t1812, null, ["交還咗失物，佢哋好似冇咁驚喇", "#b2d394"])
			return null
		if J.seq(J.gp(v_C_1801, "k"), "hot"):
			var _t1813 = env["trigger"]
			J.cl(_t1813, null, [J.gp(v_C_1801, "p"), false])
		return null

func _f301(this_, a: Array, env):
	var v_p_1816 = null; var v_d_1817 = null
	v_p_1816 = J.arg(a, 0)
	v_d_1817 = J.hypot_([J.sub(J.gp(v_p_1816, "x"), env["wx"]), J.sub(J.gp(v_p_1816, "y"), env["wy"])])
	if J.cmp(v_d_1817, env["hd"], "<"):
		env["hd"] = v_d_1817
		env["hs"] = v_p_1816

func _f302(this_, a: Array, env):
	var v_a_1820 = null; var v_h_1821 = null; var v_d_1822 = null
	v_a_1820 = J.arg(a, 0)
	if J.seq(J.gp(v_a_1820, "st"), "run"):
		return null
	var _t1819 = J.gp(env["lay"], "ph")
	var _t1818 = J.seq(J.gp(v_a_1820, "act"), "bed")
	v_h_1821 = J.mul(_t1819, (0.5 if (J.seq(J.gp(v_a_1820, "st"), "act") if _t1818 else _t1818) else 1.0))
	var _t1820 = (absf(J.num(J.sub(env["wx"], J.gp(v_a_1820, "x")))) < 70.0)
	var _t1821 = (J.cmp(env["wy"], J.add(J.gp(env["lay"], "floor"), 20.0), "<") if _t1820 else _t1820)
	if (J.cmp(env["wy"], (J.sub(J.gp(env["lay"], "floor"), v_h_1821) - 30.0), ">") if _t1821 else _t1821):
		v_d_1822 = absf(J.num(J.sub(env["wx"], J.gp(v_a_1820, "x"))))
		if J.cmp(v_d_1822, env["td"], "<"):
			env["td"] = v_d_1822
			env["ta"] = v_a_1820

func _f300(this_, a: Array, env):
	var v_x_1804 = null; var v_y_1805 = null; var v_V_1806 = null
	var _s751 = {"__p": env, "wx": null, "wy": null, "lay": null, "hs": null, "hd": null, "ta": null, "td": null}
	v_x_1804 = J.arg(a, 0)
	v_y_1805 = J.arg(a, 1)
	v_V_1806 = J.cl(_s751["__p"]["view"], null, [])
	_s751["wx"] = J.add(J.div(v_x_1804, J.gp(v_V_1806, "s")), J.gp(J.gp(_s751["__p"]["S"], "cam"), "x"))
	_s751["wy"] = J.add(J.div(J.sub(v_y_1805, J.gp(v_V_1806, "top")), J.gp(v_V_1806, "s")), J.gp(J.gp(J.gp(_s751["__p"]["S"], "lay"), "crop"), 0.0))
	_s751["lay"] = J.gp(_s751["__p"]["S"], "lay")
	var _t1814 = J.gp(_s751["__p"]["S"], "cam")
	J.sp(_t1814, "free", null)
	_s751["hs"] = null
	_s751["hd"] = J.div(60.0, J.gp(v_V_1806, "s"))
	var _t1815 = J.gp(_s751["__p"]["S"], "spots")
	J.mc(_t1815, "forEach", [Callable(self, "_f301").bind(_s751)])
	if J.t(_s751["hs"]):
		var _t1816 = _s751["__p"]["trigger"]
		J.cl(_t1816, null, [_s751["hs"], false])
		return null
	_s751["ta"] = null
	_s751["td"] = 1000000000.0
	var _t1817 = J.gp(_s751["__p"]["S"], "actors")
	J.mc(_t1817, "forEach", [Callable(self, "_f302").bind(_s751)])
	if J.t(_s751["ta"]):
		var _t1822 = _s751["__p"]["scareAt"]
		J.cl(_t1822, null, [_s751["ta"]])
		return null
	if (absf(J.num(J.sub(_s751["wx"], J.gp(_s751["lay"], "door")))) < 50.0):
		var _t1823 = _s751["__p"]["S"]
		var _t1824 = J.add(J.gp(_s751["lay"], "door"), 4.0)
		J.sp(_t1823, "goX", _t1824)
		var _t1825 = _s751["__p"]["S"]
		J.sp(_t1825, "pend", null)
		var _t1826 = _s751["__p"]["wfl"]
		J.cl(_t1826, null, [J.gp(_s751["lay"], "door"), (J.sub(J.gp(_s751["lay"], "floor"), J.gp(_s751["lay"], "ph")) - 10.0), "行去門口（撳「出屋」就走得）", "#a9c79a"])
		return null
	var _t1827 = _s751["__p"]["S"]
	var _t1828 = _s751["__p"]["clamp"]
	var _t1829 = J.cl(_t1828, null, [_s751["wx"], J.add(J.gp(J.gp(J.gp(_s751["lay"], "rooms"), 0.0), "x0"), 14.0), J.sub(J.gp(J.gp(J.gp(_s751["lay"], "rooms"), (J.len(J.gp(_s751["lay"], "rooms")) - 1.0)), "x1"), 20.0)])
	J.sp(_t1827, "goX", _t1829)
	var _t1830 = _s751["__p"]["S"]
	J.sp(_t1830, "pend", null)

func _f316(this_, a: Array, env):
	var v_ts_1896 = null; var v_dt_1897 = null; var v_vis_1898 = null; var v_e_1899 = null
	v_ts_1896 = J.arg(a, 0)
	J.F_requestAnimationFrame([env["loop"]])
	v_dt_1897 = (J.min_([0.1, J.div(J.sub(v_ts_1896, env["last"]), 1000.0)]) if J.t(env["last"]) else 0.0)
	env["last"] = v_ts_1896
	if (not J.seq(J.cl(env["G"], null, []), env["lastG"])):
		var _t1831 = J.cl(env["G"], null, [])
		env["lastG"] = _t1831
		env["S"] = null
		var _t1832 = env["hideNative"]
		J.cl(_t1832, null, [false])
	var _t1833 = J.cl(env["running"], null, [])
	if J.t(((not J.t(J.gp(env["U"], "manual"))) if J.t(_t1833) else _t1833)):
		J.mc(env["U"], "step", [v_dt_1897])
	v_vis_1898 = J.cl(env["visible"], null, [])
	if J.t(v_vis_1898):
		if J.seq(J.gp(J.gp(env["cv"], "style"), "display"), "none"):
			var _t1834 = J.gp(env["cv"], "style")
			J.sp(_t1834, "display", "block")
		J.cl(env["draw"], null, [])
	else:
		if (not J.seq(J.gp(J.gp(env["cv"], "style"), "display"), "none")):
			var _t1835 = J.gp(env["cv"], "style")
			J.sp(_t1835, "display", "none")
			env["ptr"] = null
			if J.t(env["S"]):
				var _t1836 = env["S"]
				J.sp(_t1836, "joy", null)

func _f187(this_, a: Array, env):
	var _t1837 = env["hiss"]
	J.cl(_t1837, null, [0.0, 0.5, 0.06, 500.0])
	var _t1838 = env["tone"]
	J.cl(_t1838, null, [110.0, 0.0, 0.4, 0.05, "triangle"])

func _f188(this_, a: Array, env):
	var v_k_1135 = null
	v_k_1135 = J.arg(a, 0)
	if J.seq(v_k_1135, "lamp"):
		var _t1839 = env["tone"]
		J.cl(_t1839, null, [60.0, 0.0, 0.3, 0.12, "square"])
	else:
		var _t1840 = J.seq(v_k_1135, "tv")
		if (_t1840 if _t1840 else J.seq(v_k_1135, "pc")):
			var _t1841 = env["hiss"]
			J.cl(_t1841, null, [0.0, 1.2, 0.07, 2400.0])
		else:
			var _t1842 = J.seq(v_k_1135, "tap")
			var _t1843 = (_t1842 if _t1842 else J.seq(v_k_1135, "shower"))
			if (_t1843 if _t1843 else J.seq(v_k_1135, "jar")):
				var _t1844 = env["hiss"]
				J.cl(_t1844, null, [0.0, 1.4, 0.06, 700.0])
			else:
				if J.seq(v_k_1135, "pots"):
					var _t1845 = env["tone"]
					J.cl(_t1845, null, [880.0, 0.0, 0.3, 0.1, "triangle"])
					var _t1846 = env["tone"]
					J.cl(_t1846, null, [660.0, 0.15, 0.4, 0.08, "triangle"])
				else:
					var _t1847 = env["tone"]
					J.cl(_t1847, null, [196.0, 0.0, 1.1, 0.06, "triangle"])
					var _t1848 = env["tone"]
					J.cl(_t1848, null, [185.0, 0.1, 1.1, 0.05, "sine"])

func _f189(this_, a: Array, env):
	var _t1849 = env["tone"]
	J.cl(_t1849, null, [70.0, 0.0, 0.7, 0.2, "sawtooth"])
	var _t1850 = env["hiss"]
	J.cl(_t1850, null, [0.0, 0.6, 0.1, 300.0])

func _f190(this_, a: Array, env):
	var _t1851 = env["tone"]
	J.cl(_t1851, null, [740.0, 0.0, 0.12, 0.06, "square"])
	var _t1852 = env["tone"]
	J.cl(_t1852, null, [740.0, 0.16, 0.12, 0.06, "square"])

func _f191(this_, a: Array, env):
	var v_i_1142 = null
	v_i_1142 = 0.0
	while true:
		if not J.cmp(v_i_1142, 4.0, "<"): break
		var _t1853 = env["tone"]
		J.cl(_t1853, null, [(400.0 - J.mul(v_i_1142, 60.0)), J.mul(v_i_1142, 0.12), 0.18, 0.08, "square"])
		v_i_1142 = J.num(v_i_1142) + 1.0

func _f192(this_, a: Array, env):
	J.cl(env["ac"], null, [])

func _f194(this_, a: Array, env):
	var v_g_1153 = null; var v_un_1154 = null
	v_g_1153 = J.arg(a, 0)
	v_un_1154 = J.arg(a, 1)
	var _t1855 = env["enterable"]
	return J.seq(J.cl(_t1855, null, [v_g_1153, v_un_1154]), true)

func _f195(this_, a: Array, env):
	var v_g_1157 = null; var v_un_1158 = null; var v_ok_1159 = null; var v_n_1160 = null
	v_g_1157 = J.arg(a, 0)
	v_un_1158 = J.arg(a, 1)
	var _t1858 = env["enterable"]
	v_ok_1159 = J.cl(_t1858, null, [v_g_1157, v_un_1158])
	if (not J.seq(v_ok_1159, true)):
		var _t1859 = env["blockedMsg"]
		J.cl(_t1859, null, [v_g_1157, v_un_1158, v_ok_1159])
		return false
	J.sp(v_g_1157, "to", null)
	J.sp(v_g_1157, "auto", null)
	J.sp(v_g_1157, "autoS", null)
	J.sp(v_g_1157, "p", 0.0)
	var _t1860 = J.gp(v_un_1158, "id")
	J.sp(v_g_1157, "node", _t1860)
	v_n_1160 = J.gp(J.gp(J.cl(env["G"], null, []), "nodes"), J.gp(v_un_1158, "id"))
	var _t1861 = J.gp(v_n_1160, "x")
	J.sp(v_g_1157, "x", _t1861)
	var _t1862 = J.gp(v_n_1160, "y")
	J.sp(v_g_1157, "y", _t1862)
	J.mc(env["A"], "onArrive", [v_g_1157])
	return (not (not J.t(env["S"])))

func _f197(this_, a: Array, env):
	var v_g_1170 = null; var v_n_1171 = null; var v_g0_1172 = null; var v_un_1173 = null; var v_I_1174 = null; var v_d_1175 = null
	v_g_1170 = J.arg(a, 0)
	v_n_1171 = J.arg(a, 1)
	v_g0_1172 = J.cl(env["G"], null, [])
	var _t1865 = (not J.t(v_g0_1172))
	var _t1866 = (_t1865 if _t1865 else env["S"])
	if J.t((_t1866 if J.t(_t1866) else (not J.seq(J.gp(v_g_1170, "i"), J.gp(v_g0_1172, "active"))))):
		return false
	v_un_1173 = J.mc(env["A"], "unitOf", [J.gp(v_n_1171, "id")])
	var _t1867 = env["isHH"]
	if (not J.t(J.cl(_t1867, null, [v_un_1173]))):
		return false
	var _t1868 = env["iu"]
	v_I_1174 = J.cl(_t1868, null, [v_un_1173])
	var _t1869 = J.cmp(J.gp(v_I_1174, "ban"), 0.0, ">")
	if (_t1869 if _t1869 else J.cmp(J.gp(v_I_1174, "cd"), 0.0, ">")):
		var _t1870 = J.gp(v_un_1173, "did")
		J.sp(v_g_1170, "node", _t1870)
		v_d_1175 = J.gp(J.gp(v_g0_1172, "nodes"), J.gp(v_un_1173, "did"))
		var _t1871 = J.gp(v_d_1175, "x")
		J.sp(v_g_1170, "x", _t1871)
		var _t1872 = J.gp(v_d_1175, "y")
		J.sp(v_g_1170, "y", _t1872)
		J.sp(v_g_1170, "to", null)
		J.sp(v_g_1170, "auto", null)
		var _t1873 = env["blockedMsg"]
		J.cl(_t1873, null, [v_g_1170, v_un_1173, ("ban" if J.cmp(J.gp(v_I_1174, "ban"), 0.0, ">") else "cd")])
		return true
	var _t1874 = env["open"]
	J.cl(_t1874, null, [v_g_1170, v_un_1173])
	return true

func _f212(this_, a: Array, env):
	var v_why_1241 = null; var v_un_1242 = null; var v_g_1243 = null; var v_g0_1244 = null; var v_I_1245 = null; var v_d_1246 = null; var v_t_1247 = null; var v_e_1248 = null
	v_why_1241 = J.arg(a, 0)
	if (not J.t(env["S"])):
		return false
	v_un_1242 = J.gp(env["S"], "un")
	v_g_1243 = J.gp(env["S"], "g")
	v_g0_1244 = J.cl(env["G"], null, [])
	var _t1877 = env["iu"]
	v_I_1245 = J.cl(_t1877, null, [v_un_1242])
	var _t1878 = J.gp(env["S"], "alert")
	J.sp(v_I_1245, "alert", _t1878)
	var _t1879 = J.gp(v_g0_1244, "t")
	J.sp(v_I_1245, "leftT", _t1879)
	if J.seq(v_why_1241, "kick"):
		var _t1880 = env["BAN"]
		J.sp(v_I_1245, "ban", _t1880)
		J.sp(v_I_1245, "alert", 55.0)
	else:
		if J.seq(v_why_1241, "time"):
			var _t1881 = env["REIN"]
			J.sp(v_I_1245, "cd", _t1881)
		else:
			J.sp(v_I_1245, "cd", 1.5)
	J.sp(v_g_1243, "inUnit", null)
	var _t1882 = J.gp(v_un_1242, "did")
	J.sp(v_g_1243, "node", _t1882)
	v_d_1246 = J.gp(J.gp(v_g0_1244, "nodes"), J.gp(v_un_1242, "did"))
	var _t1883 = J.gp(v_d_1246, "x")
	J.sp(v_g_1243, "x", _t1883)
	var _t1884 = J.gp(v_d_1246, "y")
	J.sp(v_g_1243, "y", _t1884)
	J.sp(v_g_1243, "to", null)
	J.sp(v_g_1243, "auto", null)
	J.sp(v_g_1243, "autoS", null)
	J.sp(v_g_1243, "p", 0.0)
	J.sp(v_g_1243, "still", 1.0)
	J.sp(v_g_1243, "taskP", 0.0)
	J.sp(v_g_1243, "mv", 0.0)
	var _t1885 = J.gp(v_g_1243, "inv")
	var _t1886 = J.gp(v_g_1243, "inv")
	var _t1887 = J.max_([(_t1886 if J.t(_t1886) else 0.0), (0.8 if J.seq(v_why_1241, "kick") else 1.4)])
	J.sp(v_g_1243, "inv", _t1887)
	v_t_1247 = ((J.add("被趕出屋！", env["BAN"]) + " 秒內呢戶入唔到") if J.seq(v_why_1241, "kick") else ("陰氣唔夠，返出走廊透下" if J.seq(v_why_1241, "time") else "出咗屋"))
	J.mc(env["A"], "float", [J.gp(v_un_1242, "x"), J.sub(J.gp(v_un_1242, "y"), 90.0), v_t_1247, ("#ffb0b0" if J.seq(v_why_1241, "kick") else "#9fd6bf")])
	if J.seq(v_why_1241, "kick"):
		var _t1888 = J.add(J.gp(v_g0_1244, "alert"), 1.0)
		J.sp(v_g0_1244, "alert", _t1888)
		J.mc(env["A"], "checkAlert", [])
		J.mc(env["A"], "noise", [J.gp(v_un_1242, "did"), 2.0])
		J.mc(env["A"], "toast", [J.add(J.gp(J.gp(env["A"], "FLN"), J.gp(v_un_1242, "f")), "嗰戶開晒燈大嗌，鬼被趕返出走廊——全樓警覺 +1，保安聽到聲過嚟睇。")])
	env["S"] = null
	J.mc(env["SND"], "door", [])
	var _t1889 = env["hideNative"]
	J.cl(_t1889, null, [false])
	return true

func _f214(this_, a: Array, env):
	var v_u_1266 = null
	v_u_1266 = J.arg(a, 0)
	if J.t(J.gp(v_u_1266, "iu")):
		var _t1894 = J.gp(v_u_1266, "iu")
		var _t1895 = J.max_([0.0, J.sub(J.gp(J.gp(v_u_1266, "iu"), "ban"), env["dt"])])
		J.sp(_t1894, "ban", _t1895)
		var _t1896 = J.gp(v_u_1266, "iu")
		var _t1897 = J.max_([0.0, J.sub(J.gp(J.gp(v_u_1266, "iu"), "cd"), env["dt"])])
		J.sp(_t1896, "cd", _t1897)

func _f215(this_, a: Array, env):
	var v_p_1269 = null
	v_p_1269 = J.arg(a, 0)
	var _t1965 = J.max_([0.0, J.sub(J.gp(v_p_1269, "cd"), env["dt"])])
	J.sp(v_p_1269, "cd", _t1965)
	var _t1966 = J.max_([0.0, J.sub(J.gp(v_p_1269, "t"), env["dt"])])
	J.sp(v_p_1269, "t", _t1966)

func _f216(this_, a: Array, env):
	var v_v_1272 = null
	v_v_1272 = J.arg(a, 0)
	return J.max_([0.0, J.sub(v_v_1272, env["dt"])])

func _f217(this_, a: Array, env):
	var v_f_1275 = null
	v_f_1275 = J.arg(a, 0)
	var _t1971 = J.sub(J.gp(v_f_1275, "life"), env["dt"])
	J.sp(v_f_1275, "life", _t1971)
	var _t1972 = J.sub(J.gp(v_f_1275, "y"), J.mul(env["dt"], 30.0))
	J.sp(v_f_1275, "y", _t1972)

func _f218(this_, a: Array, env):
	var v_f_1278 = null
	v_f_1278 = J.arg(a, 0)
	return J.cmp(J.gp(v_f_1278, "life"), 0.0, ">")

func _f219(this_, a: Array, env):
	var v_p_1281 = null
	v_p_1281 = J.arg(a, 0)
	var _t1977 = J.sub(J.gp(v_p_1281, "life"), env["dt"])
	J.sp(v_p_1281, "life", _t1977)
	var _t1978 = J.add(J.gp(v_p_1281, "x"), J.mul(J.gp(v_p_1281, "vx"), env["dt"]))
	J.sp(v_p_1281, "x", _t1978)
	var _t1979 = J.add(J.gp(v_p_1281, "y"), J.mul(J.gp(v_p_1281, "vy"), env["dt"]))
	J.sp(v_p_1281, "y", _t1979)
	var _t1980 = J.seq(J.gp(v_p_1281, "type"), "drop")
	var _t1981 = (_t1980 if _t1980 else J.seq(J.gp(v_p_1281, "type"), "coin"))
	if (_t1981 if _t1981 else J.seq(J.gp(v_p_1281, "type"), "sweat")):
		var _t1982 = J.add(J.gp(v_p_1281, "vy"), J.mul(500.0, env["dt"]))
		J.sp(v_p_1281, "vy", _t1982)

func _f220(this_, a: Array, env):
	var v_p_1284 = null
	v_p_1284 = J.arg(a, 0)
	return J.cmp(J.gp(v_p_1284, "life"), 0.0, ">")

func _f221(this_, a: Array, env):
	var v_a_1287 = null
	v_a_1287 = J.arg(a, 0)
	var _t1990 = J.gp(v_a_1287, "r")
	J.sp(_t1990, "awake", true)
	var _t1991 = J.gp(v_a_1287, "r")
	J.sp(_t1991, "woke", true)

func _f222(this_, a: Array, env):
	var v_a_1290 = null
	v_a_1290 = J.arg(a, 0)
	return J.seq(J.gp(J.gp(v_a_1290, "r"), "state"), "home")

func _f213(this_, a: Array, env):
	var v_g0_1252 = null; var v_g_1253 = null; var v_lay_1254 = null; var v_un_1255 = null; var v_sp_1256 = null; var v_mv_1257 = null; var v_jx_1258 = null; var v_d_1259 = null; var v_nx_1260 = null; var v_P_1261 = null; var v_sc_1262 = null; var v_w_1263 = null
	var _s468 = {"__p": env, "dt": null}
	_s468["dt"] = J.arg(a, 0)
	v_g0_1252 = J.cl(_s468["__p"]["G"], null, [])
	if (not J.seq(v_g0_1252, _s468["__p"]["lastG"])):
		_s468["__p"]["lastG"] = v_g0_1252
		_s468["__p"]["S"] = null
		var _t1892 = _s468["__p"]["hideNative"]
		J.cl(_t1892, null, [false])
	if J.t(v_g0_1252):
		var _t1893 = J.gp(v_g0_1252, "units")
		J.mc(_t1893, "forEach", [Callable(self, "_f214").bind(_s468)])
	if (not J.t(_s468["__p"]["S"])):
		return null
	v_g_1253 = J.gp(_s468["__p"]["S"], "g")
	v_lay_1254 = J.gp(_s468["__p"]["S"], "lay")
	v_un_1255 = J.gp(_s468["__p"]["S"], "un")
	var _t1898 = J.gp(v_g_1253, "out")
	var _t1900 = (_t1898 if J.t(_t1898) else J.gp(v_g_1253, "home"))
	if not J.t(_t1900):
		var _t1899 = J.gp(v_g0_1252, "gh")
		_t1900 = J.cmp(J.mc(_t1899, "indexOf", [v_g_1253]), 0.0, "<")
	if J.t(_t1900):
		_s468["__p"]["S"] = null
		J.sp(v_g_1253, "inUnit", null)
		var _t1901 = _s468["__p"]["hideNative"]
		J.cl(_t1901, null, [false])
		return null
	var _t1902 = _s468["__p"]["S"]
	var _t1903 = J.add(J.gp(_t1902, "t"), _s468["dt"])
	J.sp(_t1902, "t", _t1903)
	var _t1904 = _s468["__p"]["S"]
	var _t1905 = J.sub(J.gp(_t1904, "limit"), _s468["dt"])
	J.sp(_t1904, "limit", _t1905)
	var _t1906 = _s468["__p"]["S"]
	var _t1907 = J.max_([0.0, J.sub(J.gp(_s468["__p"]["S"], "msgT"), _s468["dt"])])
	J.sp(_t1906, "msgT", _t1907)
	var _t1908 = _s468["__p"]["S"]
	var _t1909 = J.max_([0.0, J.sub(J.gp(_s468["__p"]["S"], "scCd"), _s468["dt"])])
	J.sp(_t1908, "scCd", _t1909)
	var _t1910 = _s468["__p"]["S"]
	var _t1911 = J.max_([0.0, J.sub(J.gp(_s468["__p"]["S"], "invT"), _s468["dt"])])
	J.sp(_t1910, "invT", _t1911)
	var _t1912 = _s468["__p"]["S"]
	var _t1913 = J.max_([0.0, J.sub(J.gp(_s468["__p"]["S"], "stun"), _s468["dt"])])
	J.sp(_t1912, "stun", _t1913)
	var _t1914 = _s468["__p"]["S"]
	var _t1915 = J.max_([0.0, J.sub(J.gp(_s468["__p"]["S"], "flash"), _s468["dt"])])
	J.sp(_t1914, "flash", _t1915)
	var _t1916 = J.gp(v_g_1253, "inv")
	var _t1917 = J.gp(v_g_1253, "inv")
	var _t1918 = J.max_([(_t1917 if J.t(_t1917) else 0.0), 0.25])
	J.sp(v_g_1253, "inv", _t1918)
	var _t1919 = J.gp(v_un_1255, "id")
	J.sp(v_g_1253, "node", _t1919)
	J.sp(v_g_1253, "to", null)
	J.sp(v_g_1253, "auto", null)
	J.sp(v_g_1253, "autoS", null)
	if (not J.seq(J.gp(v_g0_1252, "active"), J.gp(v_g_1253, "i"))):
		var _t1920 = J.gp(v_g_1253, "i")
		J.sp(v_g0_1252, "active", _t1920)
	var _t1922 = J.mul(J.gp(J.gp(v_g_1253, "d"), "sp"), J.gp(J.gp(v_g0_1252, "mods"), "spd"))
	var _t1921 = J.gp(v_g_1253, "spm")
	v_sp_1256 = (J.mul(_t1922, (_t1921 if J.t(_t1921) else 1.0)) * 2.1)
	v_mv_1257 = 0.0
	var _t1923 = J.gp(_s468["__p"]["S"], "joy")
	v_jx_1258 = (J.div(J.sub(J.gp(J.gp(_s468["__p"]["S"], "joy"), "x"), J.gp(J.gp(_s468["__p"]["S"], "joy"), "ox")), 58.0) if J.t((J.gp(J.gp(_s468["__p"]["S"], "joy"), "on") if J.t(_t1923) else _t1923)) else 0.0)
	var _t1925 = J.cmp(J.gp(_s468["__p"]["S"], "stun"), 0.0, ">")
	if not J.t(_t1925):
		var _t1924 = J.gp(_s468["__p"]["S"], "sc")
		_t1925 = (J.cmp(J.gp(J.gp(_s468["__p"]["S"], "sc"), "t"), J.add(_s468["__p"]["OMEN"], 0.5), "<") if J.t(_t1924) else _t1924)
	if J.t(_t1925):
		v_jx_1258 = 0.0
	if (absf(J.num(v_jx_1258)) > 0.2):
		var _t1926 = _s468["__p"]["S"]
		J.sp(_t1926, "goX", null)
		var _t1927 = _s468["__p"]["S"]
		J.sp(_t1927, "pend", null)
		var _t1928 = _s468["__p"]["clamp"]
		var _t1929 = J.mul(J.mul(J.cl(_t1928, null, [v_jx_1258, (-1.0), 1.0]), v_sp_1256), _s468["dt"])
		v_mv_1257 = _t1929
		if J.t(J.gp(J.gp(_s468["__p"]["S"], "cam"), "free")):
			var _t1930 = J.gp(_s468["__p"]["S"], "cam")
			J.sp(_t1930, "free", null)
	else:
		var _t1931 = (not J.leq(J.gp(_s468["__p"]["S"], "goX"), null))
		if (J.cmp(J.gp(_s468["__p"]["S"], "stun"), 0.0, "<=") if _t1931 else _t1931):
			v_d_1259 = J.sub(J.gp(_s468["__p"]["S"], "goX"), J.gp(_s468["__p"]["S"], "gx"))
			if (absf(J.num(v_d_1259)) < 4.0):
				var _t1932 = _s468["__p"]["S"]
				J.sp(_t1932, "goX", null)
			else:
				var _t1933 = (signf(J.num(v_d_1259)) * J.min_([absf(J.num(v_d_1259)), J.mul(v_sp_1256, _s468["dt"])]))
				v_mv_1257 = _t1933
	if J.t(v_mv_1257):
		var _t1934 = _s468["__p"]["clamp"]
		v_nx_1260 = J.cl(_t1934, null, [J.add(J.gp(_s468["__p"]["S"], "gx"), v_mv_1257), J.add(J.gp(J.gp(J.gp(v_lay_1254, "rooms"), 0.0), "x0"), 10.0), J.sub(J.gp(J.gp(J.gp(v_lay_1254, "rooms"), (J.len(J.gp(v_lay_1254, "rooms")) - 1.0)), "x1"), 20.0)])
		var _t1935 = _s468["__p"]["S"]
		var _t1936 = (1.0 if J.cmp(v_mv_1257, 0.0, ">") else (-1.0))
		J.sp(_t1935, "gdir", _t1936)
		if (absf(J.num(J.sub(v_nx_1260, J.gp(_s468["__p"]["S"], "gx")))) > 0.1):
			var _t1937 = _s468["__p"]["S"]
			J.sp(_t1937, "gmv", 0.15)
			var _t1938 = _s468["__p"]["S"]
			J.sp(_t1938, "still", 0.0)
		var _t1939 = _s468["__p"]["S"]
		J.sp(_t1939, "gx", v_nx_1260)
		var _t1940 = J.cmp(J.gp(_s468["__p"]["S"], "gx"), J.add(J.gp(J.gp(J.gp(v_lay_1254, "rooms"), 0.0), "x0"), 12.0), "<=")
		if (J.cmp(v_jx_1258, (-0.5), "<") if _t1940 else _t1940):
			J.mc(_s468["__p"]["U"], "exit", ["door"])
			return null
	else:
		var _t1941 = _s468["__p"]["S"]
		var _t1942 = J.max_([0.0, J.sub(J.gp(_s468["__p"]["S"], "gmv"), _s468["dt"])])
		J.sp(_t1941, "gmv", _t1942)
		var _t1943 = _s468["__p"]["S"]
		var _t1944 = J.add(J.gp(_t1943, "still"), _s468["dt"])
		J.sp(_t1943, "still", _t1944)
	var _t1945 = J.gp(_s468["__p"]["S"], "sc")
	var _t1946 = (J.cmp(J.gp(J.gp(_s468["__p"]["S"], "sc"), "t"), _s468["__p"]["OMEN"], "<") if J.t(_t1945) else _t1945)
	if J.t((J.cmp(J.gp(_s468["__p"]["S"], "gmv"), 0.0, ">") if J.t(_t1946) else _t1946)):
		var _t1947 = _s468["__p"]["wfl"]
		J.cl(_t1947, null, [J.gp(_s468["__p"]["S"], "gx"), (J.sub(J.gp(v_lay_1254, "floor"), J.gp(v_lay_1254, "ph")) - 20.0), "一郁就破功", "#e6a85a"])
		var _t1948 = _s468["__p"]["S"]
		J.sp(_t1948, "sc", null)
		var _t1949 = _s468["__p"]["S"]
		J.sp(_t1949, "scCd", 0.4)
	var _t1950 = J.gp(_s468["__p"]["S"], "pend")
	var _t1951 = (J.leq(J.gp(_s468["__p"]["S"], "goX"), null) if J.t(_t1950) else _t1950)
	if J.t((J.cmp(J.gp(_s468["__p"]["S"], "stun"), 0.0, "<=") if J.t(_t1951) else _t1951)):
		v_P_1261 = J.gp(_s468["__p"]["S"], "pend")
		var _t1952 = _s468["__p"]["S"]
		J.sp(_t1952, "pend", null)
		if J.seq(J.gp(v_P_1261, "k"), "hot"):
			var _t1953 = _s468["__p"]["trigger"]
			J.cl(_t1953, null, [J.gp(v_P_1261, "p"), true])
		else:
			if J.seq(J.gp(v_P_1261, "k"), "scare"):
				var _t1954 = _s468["__p"]["scareAt"]
				J.cl(_t1954, null, [J.gp(v_P_1261, "a")])
	if J.t(J.gp(_s468["__p"]["S"], "sc")):
		v_sc_1262 = J.gp(_s468["__p"]["S"], "sc")
		var _t1955 = J.add(J.gp(v_sc_1262, "t"), _s468["dt"])
		J.sp(v_sc_1262, "t", _t1955)
		var _t1956 = (not J.t(J.gp(v_sc_1262, "hit")))
		if (J.cmp(J.gp(v_sc_1262, "t"), _s468["__p"]["OMEN"], ">=") if _t1956 else _t1956):
			J.sp(v_sc_1262, "hit", true)
			var _t1957 = _s468["__p"]["strike"]
			J.cl(_t1957, null, [v_sc_1262])
		if J.cmp(J.gp(v_sc_1262, "t"), J.add(_s468["__p"]["OMEN"], 0.9), ">="):
			var _t1958 = _s468["__p"]["S"]
			J.sp(_t1958, "sc", null)
	var _t1959 = _s468["__p"]["searchUpdate"]
	J.cl(_t1959, null, [_s468["dt"]])
	var _t1960 = _s468["__p"]["actorsUpdate"]
	J.cl(_t1960, null, [_s468["dt"]])
	var _t1961 = _s468["__p"]["lightsUpdate"]
	J.cl(_t1961, null, [_s468["dt"]])
	var _t1962 = _s468["__p"]["detect"]
	J.cl(_t1962, null, [_s468["dt"]])
	var _t1963 = _s468["__p"]["thresholds"]
	J.cl(_t1963, null, [_s468["dt"]])
	J.cl(_s468["__p"]["taskCheck"], null, [])
	var _t1964 = J.gp(_s468["__p"]["S"], "spots")
	J.mc(_t1964, "forEach", [Callable(self, "_f215").bind(_s468)])
	var _t1967 = _s468["__p"]["S"]
	var _t1968 = J.gp(_s468["__p"]["S"], "dark")
	var _t1969 = J.mc(_t1968, "map", [Callable(self, "_f216").bind(_s468)])
	J.sp(_t1967, "dark", _t1969)
	var _t1970 = J.gp(_s468["__p"]["S"], "floats")
	J.mc(_t1970, "forEach", [Callable(self, "_f217").bind(_s468)])
	var _t1973 = _s468["__p"]["S"]
	var _t1974 = J.gp(_s468["__p"]["S"], "floats")
	var _t1975 = J.mc(_t1974, "filter", [Callable(self, "_f218").bind(_s468)])
	J.sp(_t1973, "floats", _t1975)
	var _t1976 = J.gp(_s468["__p"]["S"], "parts")
	J.mc(_t1976, "forEach", [Callable(self, "_f219").bind(_s468)])
	var _t1983 = _s468["__p"]["S"]
	var _t1984 = J.gp(_s468["__p"]["S"], "parts")
	var _t1985 = J.mc(_t1984, "filter", [Callable(self, "_f220").bind(_s468)])
	J.sp(_t1983, "parts", _t1985)
	var _t1986 = J.cmp(J.gp(v_g0_1252, "phase"), 3.0, ">=")
	if ((not J.t(J.gp(J.gp(_s468["__p"]["S"], "flags"), "dawn"))) if _t1986 else _t1986):
		var _t1987 = J.gp(_s468["__p"]["S"], "flags")
		J.sp(_t1987, "dawn", 1.0)
		var _t1988 = _s468["__p"]["msg"]
		J.cl(_t1988, null, ["天光喇！住客陸續起身，開晒燈——快啲做完出屋！", "#e48a78"])
		var _t1989 = J.gp(_s468["__p"]["S"], "actors")
		J.mc(_t1989, "forEach", [Callable(self, "_f221").bind(_s468)])
	if J.cmp(J.gp(v_g0_1252, "phase"), 3.0, ">="):
		var _t1992 = _s468["__p"]["S"]
		var _t1993 = J.add(J.gp(_t1992, "alert"), J.mul(3.0, _s468["dt"]))
		J.sp(_t1992, "alert", _t1993)
	if J.cmp(J.gp(_s468["__p"]["S"], "alert"), 100.0, ">="):
		var _t1994 = _s468["__p"]["S"]
		J.sp(_t1994, "alert", 100.0)
		var _t1995 = _s468["__p"]["S"]
		var _t1996 = J.add(J.gp(_t1995, "kickT"), _s468["dt"])
		J.sp(_t1995, "kickT", _t1996)
		var _t1997 = J.cmp(J.gp(_s468["__p"]["S"], "kickT"), 0.01, ">")
		if ((not J.t(J.gp(J.gp(_s468["__p"]["S"], "flags"), "kickSaid"))) if _t1997 else _t1997):
			var _t1998 = J.gp(_s468["__p"]["S"], "flags")
			J.sp(_t1998, "kickSaid", 1.0)
			var _t1999 = J.gp(_s468["__p"]["S"], "actors")
			v_w_1263 = J.mc(_t1999, "find", [Callable(self, "_f222").bind(_s468)])
			if J.t(v_w_1263):
				var _t2000 = _s468["__p"]["sayR"]
				var _t2002 = J.gp(v_w_1263, "r")
				var _t2001 = _s468["__p"]["line"]
				J.cl(_t2000, null, [_t2002, J.cl(_t2001, null, ["kick"])])
			J.mc(_s468["__p"]["SND"], "kick", [])
		if J.cmp(J.gp(_s468["__p"]["S"], "kickT"), 1.0, ">="):
			J.mc(_s468["__p"]["U"], "exit", ["kick"])
			return null
	if J.cmp(J.gp(_s468["__p"]["S"], "limit"), 0.0, "<="):
		J.mc(_s468["__p"]["U"], "exit", ["time"])
		return null

func _f258(this_, a: Array, env):
	var v_target_1475 = null; var v_g_1476 = null; var v_a_1477 = null; var v_far_1478 = null
	v_target_1475 = J.arg(a, 0)
	if (not J.t(env["S"])):
		return false
	v_g_1476 = J.gp(env["S"], "g")
	if J.t(J.gp(env["S"], "sc")):
		return false
	if J.cmp(J.gp(env["S"], "scCd"), 0.0, ">"):
		var _t2005 = env["wfl"]
		J.cl(_t2005, null, [J.gp(env["S"], "gx"), (J.sub(J.gp(J.gp(env["S"], "lay"), "floor"), J.gp(J.gp(env["S"], "lay"), "ph")) - 20.0), "啱啱嚇完，等陣先", "#ddd2bd"])
		return false
	if J.cmp(J.gp(env["S"], "stun"), 0.0, ">"):
		var _t2006 = env["wfl"]
		J.cl(_t2006, null, [J.gp(env["S"], "gx"), (J.sub(J.gp(J.gp(env["S"], "lay"), "floor"), J.gp(J.gp(env["S"], "lay"), "ph")) - 20.0), "數緊綠豆，數完先嚇得", "#b8f0a0"])
		return false
	var _t2008 = v_target_1475
	if not J.t(_t2008):
		var _t2007 = env["nearestActor"]
		_t2008 = J.cl(_t2007, null, [env["RANGE_SCARE"]])
	v_a_1477 = _t2008
	if (not J.t(v_a_1477)):
		var _t2009 = env["nearestActor"]
		v_far_1478 = J.cl(_t2009, null, [2000.0])
		if J.t(v_far_1478):
			var _t2010 = env["scareAt"]
			J.cl(_t2010, null, [v_far_1478])
			var _t2011 = env["wfl"]
			J.cl(_t2011, null, [J.gp(env["S"], "gx"), (J.sub(J.gp(J.gp(env["S"], "lay"), "floor"), J.gp(J.gp(env["S"], "lay"), "ph")) - 20.0), J.add("飄過去嚇", (J.gp(J.gp(J.gp(env["A"], "HH"), J.gp(J.gp(v_far_1478, "r"), "hh")), "n") if J.t(J.gp(J.gp(env["A"], "HH"), J.gp(J.gp(v_far_1478, "r"), "hh"))) else "住客")), "#e8a088"])
			return false
		var _t2012 = env["wfl"]
		J.cl(_t2012, null, [J.gp(env["S"], "gx"), (J.sub(J.gp(J.gp(env["S"], "lay"), "floor"), J.gp(J.gp(env["S"], "lay"), "ph")) - 20.0), "屋入面冇人喇", "#ddd2bd"])
		return false
	var _t2013 = env["S"]
	J.sp(_t2013, "goX", null)
	var _t2014 = env["S"]
	J.sp(_t2014, "pend", null)
	var _t2015 = env["S"]
	var _t2016 = (1.0 if J.cmp(J.gp(v_a_1477, "x"), J.gp(env["S"], "gx"), ">") else (-1.0))
	J.sp(_t2015, "gdir", _t2016)
	var _t2017 = env["S"]
	var _t2018 = J.max_([J.gp(env["S"], "still"), 0.12])
	J.sp(_t2017, "still", _t2018)
	var _t2019 = env["S"]
	J.sp(_t2019, "gmv", 0.0)
	var _t2020 = env["S"]
	var _t2021 = {"t": 0.0, "a": v_a_1477, "k": J.gp(J.gp(v_g_1476, "d"), "key"), "hit": false}
	J.sp(_t2020, "sc", _t2021)
	var _t2022 = env["S"]
	var _t2023 = J.add(env["OMEN"], 1.4)
	J.sp(_t2022, "scCd", _t2023)
	var _t2024 = env["wfl"]
	var _t2026 = J.gp(env["S"], "gx")
	var _t2027 = (J.sub(J.gp(J.gp(env["S"], "lay"), "floor"), J.gp(J.gp(env["S"], "lay"), "ph")) - 30.0)
	var _t2025 = J.gp(J.gp(env["A"], "MV"), J.gp(J.gp(v_g_1476, "d"), "key"))
	J.cl(_t2024, null, [_t2026, _t2027, J.gp((_t2025 if J.t(_t2025) else {"n": "嚇！"}), "n"), "#e8a088"])
	return true

func _f293(this_, a: Array, env):
	var v_e_1767 = null; var v_p_1768 = null; var v_b_1769 = null; var v_inPlay_1770 = null; var v___1771 = null; var v___1772 = null; var v___1773 = null
	v_e_1767 = J.arg(a, 0)
	J.mc(v_e_1767, "stopPropagation", [])
	J.mc(v_e_1767, "preventDefault", [])
	J.cl(env["ac"], null, [])
	if (not J.t(env["S"])):
		return null
	var _t2032 = env["pt"]
	v_p_1768 = J.cl(_t2032, null, [v_e_1767])
	var _t2033 = env["hit"]
	v_b_1769 = J.cl(_t2033, null, [J.gp(v_p_1768, "x"), J.gp(v_p_1768, "y")])
	if J.t(v_b_1769):
		var _t2034 = {"id": J.gp(v_b_1769, "id"), "t": J.S_performance_("now", [])}
		env["PRESS"] = _t2034
		if J.t(J.gp(J.G.get("navigator"), "vibrate")):
			J.S_navigator_("vibrate", [10.0])
		var _t2035 = {"id": J.gp(v_e_1767, "pointerId"), "btn": J.gp(v_b_1769, "id"), "sx": J.gp(v_p_1768, "x"), "sy": J.gp(v_p_1768, "y")}
		env["ptr"] = _t2035
		var _t2036 = env["S"]
		J.sp(_t2036, "joy", null)
		J.mc(env["cv"], "setPointerCapture", [J.gp(v_e_1767, "pointerId")])
		return null
	var _t2037 = J.cmp(J.gp(v_p_1768, "y"), J.gp(env["A"], "TOP"), ">")
	v_inPlay_1770 = (J.cmp(J.gp(v_p_1768, "y"), J.sub(env["H"], J.gp(env["A"], "BOT")), "<") if _t2037 else _t2037)
	var _t2038 = {"id": J.gp(v_e_1767, "pointerId"), "sx": J.gp(v_p_1768, "x"), "sy": J.gp(v_p_1768, "y"), "drag": false, "hud": (not J.t(v_inPlay_1770))}
	env["ptr"] = _t2038
	if J.t(v_inPlay_1770):
		var _t2039 = env["S"]
		var _t2040 = {"ox": J.gp(v_p_1768, "x"), "oy": J.gp(v_p_1768, "y"), "x": J.gp(v_p_1768, "x"), "y": J.gp(v_p_1768, "y"), "on": false}
		J.sp(_t2039, "joy", _t2040)
	J.mc(env["cv"], "setPointerCapture", [J.gp(v_e_1767, "pointerId")])

func _f294(this_, a: Array, env):
	var v_e_1776 = null; var v_p_1777 = null
	v_e_1776 = J.arg(a, 0)
	J.mc(v_e_1776, "stopPropagation", [])
	var _t2041 = (not J.t(env["S"]))
	var _t2042 = (_t2041 if _t2041 else (not J.t(env["ptr"])))
	if (_t2042 if _t2042 else (not J.seq(J.gp(env["ptr"], "id"), J.gp(v_e_1776, "pointerId")))):
		return null
	var _t2043 = env["pt"]
	v_p_1777 = J.cl(_t2043, null, [v_e_1776])
	var _t2044 = (not J.t(J.gp(env["ptr"], "btn")))
	if ((J.hypot_([J.sub(J.gp(v_p_1777, "x"), J.gp(env["ptr"], "sx")), J.sub(J.gp(v_p_1777, "y"), J.gp(env["ptr"], "sy"))]) > 12.0) if _t2044 else _t2044):
		var _t2045 = env["ptr"]
		J.sp(_t2045, "drag", true)
	if J.t(J.gp(env["S"], "joy")):
		var _t2046 = J.gp(env["S"], "joy")
		var _t2047 = J.gp(v_p_1777, "x")
		J.sp(_t2046, "x", _t2047)
		var _t2048 = J.gp(env["S"], "joy")
		var _t2049 = J.gp(v_p_1777, "y")
		J.sp(_t2048, "y", _t2049)
		if J.t(J.gp(env["ptr"], "drag")):
			var _t2050 = J.gp(env["S"], "joy")
			J.sp(_t2050, "on", true)

func _f295(this_, a: Array, env):
	var v_e_1780 = null; var v_p_1781 = null; var v_was_1782 = null; var v_j_1783 = null; var v_b_1784 = null
	v_e_1780 = J.arg(a, 0)
	J.mc(v_e_1780, "stopPropagation", [])
	if (not J.t(env["S"])):
		env["ptr"] = null
		return null
	if J.t(((not J.seq(J.gp(env["ptr"], "id"), J.gp(v_e_1780, "pointerId"))) if J.t(env["ptr"]) else env["ptr"])):
		return null
	var _t2051 = env["pt"]
	v_p_1781 = J.cl(_t2051, null, [v_e_1780])
	v_was_1782 = env["ptr"]
	env["ptr"] = null
	var _t2052 = J.gp(env["S"], "joy")
	v_j_1783 = (J.gp(J.gp(env["S"], "joy"), "on") if J.t(_t2052) else _t2052)
	var _t2053 = env["S"]
	J.sp(_t2053, "joy", null)
	if (not J.t(v_was_1782)):
		return null
	if J.t(J.gp(v_was_1782, "btn")):
		var _t2054 = env["hit"]
		v_b_1784 = J.cl(_t2054, null, [J.gp(v_p_1781, "x"), J.gp(v_p_1781, "y")])
		var _t2055 = (J.seq(J.gp(v_b_1784, "id"), J.gp(v_was_1782, "btn")) if J.t(v_b_1784) else v_b_1784)
		if J.t((_t2055 if J.t(_t2055) else (J.hypot_([J.sub(J.gp(v_p_1781, "x"), J.gp(v_was_1782, "sx")), J.sub(J.gp(v_p_1781, "y"), J.gp(v_was_1782, "sy"))]) < 24.0))):
			var _t2056 = env["press"]
			J.cl(_t2056, null, [J.gp(v_was_1782, "btn")])
		return null
	var _t2057 = (not J.t(J.gp(v_was_1782, "drag")))
	var _t2058 = ((not J.t(v_j_1783)) if _t2057 else _t2057)
	if ((not J.t(J.gp(v_was_1782, "hud"))) if _t2058 else _t2058):
		var _t2059 = env["worldTap"]
		J.cl(_t2059, null, [J.gp(v_p_1781, "x"), J.gp(v_p_1781, "y")])

func _f296(this_, a: Array, env):
	var v_e_1787 = null
	v_e_1787 = J.arg(a, 0)
	env["ptr"] = null
	if J.t(env["S"]):
		var _t2060 = env["S"]
		J.sp(_t2060, "joy", null)

func _f298(this_, a: Array, env):
	var v_e_1793 = null
	v_e_1793 = J.arg(a, 0)
	J.mc(v_e_1793, "stopPropagation", [])
	if (not J.seq(env["ev"], "touchstart")):
		J.mc(v_e_1793, "preventDefault", [])

func _f297(this_, a: Array, env):
	var _s741 = {"__p": env, "ev": null}
	_s741["ev"] = J.arg(a, 0)
	J.mc(_s741["__p"]["cv"], "addEventListener", [_s741["ev"], Callable(self, "_f298").bind(_s741), {"passive": false}])

func _f304(this_, a: Array, env):
	var v_un_1834 = null; var v_d_1835 = null
	v_un_1834 = J.arg(a, 0)
	var _t2065 = (not J.seq(J.gp(v_un_1834, "f"), J.gp(env["gn"], "f")))
	if not J.t(_t2065):
		var _t2064 = env["__p"]["isHH"]
		_t2065 = (not J.t(J.cl(_t2064, null, [v_un_1834])))
	if _t2065:
		return null
	v_d_1835 = absf(J.num(J.sub(J.gp(v_un_1834, "x"), J.gp(env["g"], "x"))))
	var _t2067 = J.cmp(v_d_1835, env["nd"], "<")
	if J.t(_t2067):
		var _t2066 = env["__p"]["enterable"]
		_t2067 = J.seq(J.cl(_t2066, null, [env["g"], v_un_1834]), true)
	if _t2067:
		env["nd"] = v_d_1835
		env["nearU"] = v_un_1834

func _f306(this_, a: Array, env):
	var v_r_1852 = null
	v_r_1852 = J.arg(a, 0)
	var _t2073 = J.seq(J.gp(v_r_1852, "state"), "flee")
	return (_t2073 if _t2073 else J.seq(J.gp(v_r_1852, "state"), "gone"))

func _f305(this_, a: Array, env):
	var v_un_1838 = null; var v_x_1839 = null; var v_y_1840 = null; var v_gr_1841 = null; var v_I_1842 = null; var v_tags_1843 = null; var v_tt_1844 = null; var v_ok_1845 = null; var v_bw_1846 = null; var v_bh_1847 = null; var v_bxw_1848 = null; var v_byw_1849 = null
	v_un_1838 = J.arg(a, 0)
	v_x_1839 = J.gp(v_un_1838, "x")
	v_y_1840 = J.gp(v_un_1838, "y")
	J.sp(v_un_1838, "_ib", null)
	if J.seq(J.gp(v_un_1838, "ot"), "deity"):
		v_gr_1841 = J.mc(env["ctx"], "createRadialGradient", [v_x_1839, J.sub(v_y_1840, 60.0), 2.0, v_x_1839, J.sub(v_y_1840, 60.0), 46.0])
		J.mc(v_gr_1841, "addColorStop", [0.0, (J.add("rgba(220,60,40,", (0.32 + (0.08 * sin(J.num(J.mul(env["T"], 2.0)))))) + ")")])
		J.mc(v_gr_1841, "addColorStop", [1.0, "rgba(220,60,40,0)"])
		var _t2069 = env["ctx"]
		J.sp(_t2069, "fillStyle", v_gr_1841)
		J.mc(env["ctx"], "fillRect", [J.sub(v_x_1839, 46.0), J.sub(v_y_1840, 106.0), 92.0, 92.0])
		var _t2070 = env["ctx"]
		J.sp(_t2070, "fillStyle", "rgba(200,40,30,0.85)")
		J.mc(env["ctx"], "fillRect", [J.sub(v_x_1839, 4.0), J.sub(v_y_1840, 104.0), 8.0, 4.0])
		return null
	var _t2071 = env["__p"]["isHH"]
	if (not J.t(J.cl(_t2071, null, [v_un_1838]))):
		return null
	v_I_1842 = J.gp(v_un_1838, "iu")
	v_tags_1843 = []
	if J.t((J.gp(v_I_1842, "done") if J.t(v_I_1842) else v_I_1842)):
		J.mc(v_tags_1843, "push", ["✓任務"])
	var _t2074 = J.len(J.gp(v_un_1838, "rs"))
	if J.t(_t2074):
		var _t2072 = J.gp(v_un_1838, "rs")
		_t2074 = J.mc(_t2072, "every", [Callable(self, "_f306").bind(env)])
	if J.t(_t2074):
		J.mc(v_tags_1843, "push", ["走晒"])
	if J.t((J.cmp(J.gp(v_I_1842, "ban"), 0.0, ">") if J.t(v_I_1842) else v_I_1842)):
		J.mc(v_tags_1843, "push", [(J.add("封 ", ceil(J.num(J.gp(v_I_1842, "ban")))) + "s")])
	if J.t(J.len(v_tags_1843)):
		var _t2075 = env["ctx"]
		var _t2076 = J.add("bold 11px ", J.gp(env["__p"]["A"], "FONT"))
		J.sp(_t2075, "font", _t2076)
		var _t2077 = env["ctx"]
		J.sp(_t2077, "textAlign", "center")
		var _t2078 = env["ctx"]
		J.sp(_t2078, "lineWidth", 3.0)
		var _t2079 = env["ctx"]
		J.sp(_t2079, "strokeStyle", "#000")
		v_tt_1844 = J.mc(v_tags_1843, "join", [" "])
		J.mc(env["ctx"], "strokeText", [v_tt_1844, v_x_1839, J.sub(v_y_1840, 72.0)])
		var _t2080 = env["ctx"]
		var _t2081 = ("#e48a78" if J.t((J.cmp(J.gp(v_I_1842, "ban"), 0.0, ">") if J.t(v_I_1842) else v_I_1842)) else "#b2d394")
		J.sp(_t2080, "fillStyle", _t2081)
		J.mc(env["ctx"], "fillText", [v_tt_1844, v_x_1839, J.sub(v_y_1840, 72.0)])
	var _t2082 = (not J.t(env["g"]))
	var _t2083 = (_t2082 if _t2082 else J.gp(env["g"], "home"))
	var _t2084 = (_t2083 if J.t(_t2083) else J.gp(env["g"], "out"))
	var _t2085 = (_t2084 if J.t(_t2084) else J.gp(env["g"], "inUnit"))
	if J.t((_t2085 if J.t(_t2085) else (not J.seq(v_un_1838, env["nearU"])))):
		return null
	var _t2086 = env["__p"]["enterable"]
	v_ok_1845 = J.seq(J.cl(_t2086, null, [env["g"], v_un_1838]), true)
	if (not J.t(v_ok_1845)):
		return null
	J.mc(env["ctx"], "save", [])
	var _t2087 = env["ctx"]
	var _t2088 = (0.35 + (0.25 * sin(J.num(J.mul(env["T"], 5.0)))))
	J.sp(_t2087, "globalAlpha", _t2088)
	var _t2089 = env["ctx"]
	J.sp(_t2089, "fillStyle", "#78ffbe")
	J.mc(env["ctx"], "fillRect", [J.sub(v_x_1839, 13.0), J.sub(v_y_1840, 62.0), 26.0, 58.0])
	J.mc(env["ctx"], "restore", [])
	v_bw_1846 = 70.0
	v_bh_1847 = 34.0
	v_bxw_1848 = J.sub(v_x_1839, J.div(v_bw_1846, 2.0))
	v_byw_1849 = J.sub(v_y_1840, 112.0)
	J.mc(env["__p"]["A"], "crBlit", [env["ctx"], J.mc(env["__p"]["A"], "crGet", [v_bw_1846, v_bh_1847, "moss", "n"]), v_bxw_1848, v_byw_1849])
	J.mc(env["__p"]["A"], "crText", [env["ctx"], "入屋", v_x_1839, J.add(J.add(v_byw_1849, J.div(v_bh_1847, 2.0)), 1.0), 16.0, "#e4ecd2", "center", J.sub(v_bw_1846, 8.0), true])
	var _t2090 = {"x": v_bxw_1848, "y": v_byw_1849, "w": v_bw_1846, "h": v_bh_1847}
	J.sp(v_un_1838, "_ib", _t2090)

func _f303(this_, a: Array, env):
	var v_g0_1826 = null
	var _s760 = {"__p": env, "ctx": null, "g": null, "T": null, "nearU": null, "nd": null, "gn": null}
	_s760["ctx"] = J.arg(a, 0)
	v_g0_1826 = J.cl(_s760["__p"]["G"], null, [])
	if (not J.t(v_g0_1826)):
		return null
	_s760["g"] = J.gp(J.gp(v_g0_1826, "gh"), J.gp(v_g0_1826, "active"))
	_s760["T"] = J.gp(v_g0_1826, "t")
	_s760["nearU"] = null
	_s760["nd"] = 150.0
	_s760["gn"] = (J.gp(J.gp(v_g0_1826, "nodes"), J.gp(_s760["g"], "node")) if J.t(_s760["g"]) else _s760["g"])
	if J.t(((not J.t(J.gp(_s760["g"], "inUnit"))) if J.t(_s760["gn"]) else _s760["gn"])):
		var _t2063 = J.gp(v_g0_1826, "units")
		J.mc(_t2063, "forEach", [Callable(self, "_f304").bind(_s760)])
	var _t2068 = J.gp(v_g0_1826, "units")
	J.mc(_t2068, "forEach", [Callable(self, "_f305").bind(_s760)])

func _f308(this_, a: Array, env):
	var v_un_1864 = null; var v_b_1865 = null; var v_onBtn_1866 = null; var v_onDoor_1867 = null
	v_un_1864 = J.arg(a, 0)
	if J.t(env["hitU"]):
		return null
	v_b_1865 = J.gp(v_un_1864, "_ib")
	var _t2096 = (J.cmp(env["wx"], J.sub(J.gp(v_b_1865, "x"), 8.0), ">=") if J.t(v_b_1865) else v_b_1865)
	var _t2097 = (J.cmp(env["wx"], J.add(J.add(J.gp(v_b_1865, "x"), J.gp(v_b_1865, "w")), 8.0), "<=") if J.t(_t2096) else _t2096)
	var _t2098 = (J.cmp(env["wy"], J.sub(J.gp(v_b_1865, "y"), 8.0), ">=") if J.t(_t2097) else _t2097)
	v_onBtn_1866 = (J.cmp(env["wy"], J.add(J.add(J.gp(v_b_1865, "y"), J.gp(v_b_1865, "h")), 8.0), "<=") if J.t(_t2098) else _t2098)
	var _t2099 = (absf(J.num(J.sub(env["wx"], J.gp(v_un_1864, "x")))) < 24.0)
	var _t2100 = (J.cmp(env["wy"], J.sub(J.gp(v_un_1864, "y"), 70.0), ">") if _t2099 else _t2099)
	v_onDoor_1867 = (J.cmp(env["wy"], J.add(J.gp(v_un_1864, "y"), 6.0), "<") if _t2100 else _t2100)
	if J.t((v_onBtn_1866 if J.t(v_onBtn_1866) else v_onDoor_1867)):
		env["hitU"] = v_un_1864

func _f307(this_, a: Array, env):
	var v_g0_1857 = null; var v_g_1858 = null; var v_un_1860 = null; var v_ok_1861 = null
	var _s767 = {"__p": env, "wx": null, "wy": null, "hitU": null}
	_s767["wx"] = J.arg(a, 0)
	_s767["wy"] = J.arg(a, 1)
	v_g0_1857 = J.cl(_s767["__p"]["G"], null, [])
	if (not J.t(v_g0_1857)):
		return false
	v_g_1858 = J.gp(J.gp(v_g0_1857, "gh"), J.gp(v_g0_1857, "active"))
	var _t2093 = (not J.t(v_g_1858))
	var _t2094 = (_t2093 if _t2093 else J.gp(v_g_1858, "home"))
	if J.t((_t2094 if J.t(_t2094) else J.gp(v_g_1858, "out"))):
		return false
	_s767["hitU"] = null
	var _t2095 = J.gp(v_g0_1857, "units")
	J.mc(_t2095, "forEach", [Callable(self, "_f308").bind(_s767)])
	v_un_1860 = _s767["hitU"]
	if (not J.t(v_un_1860)):
		return false
	if J.seq(J.gp(v_un_1860, "ot"), "deity"):
		var _t2101 = _s767["__p"]["blockedMsg"]
		J.cl(_t2101, null, [v_g_1858, v_un_1860, "deity"])
		return true
	var _t2102 = _s767["__p"]["isHH"]
	if (not J.t(J.cl(_t2102, null, [v_un_1860]))):
		return false
	var _t2103 = _s767["__p"]["enterable"]
	v_ok_1861 = J.cl(_t2103, null, [v_g_1858, v_un_1860])
	if (not J.seq(v_ok_1861, true)):
		var _t2104 = _s767["__p"]["blockedMsg"]
		J.cl(_t2104, null, [v_g_1858, v_un_1860, v_ok_1861])
		return true
	var _t2105 = J.seq(J.gp(v_g_1858, "node"), J.gp(v_un_1860, "did"))
	if ((not J.t(J.gp(v_g_1858, "to"))) if _t2105 else _t2105):
		J.mc(_s767["__p"]["U"], "enterFromDoor", [v_g_1858, v_un_1860])
		return true
	if J.t(J.mc(_s767["__p"]["A"], "gotoNode", [v_g_1858, J.gp(v_un_1860, "id")])):
		J.sp(v_g_1858, "autoS", null)
		J.mc(_s767["__p"]["A"], "float", [J.gp(v_un_1860, "x"), J.sub(J.gp(v_un_1860, "y"), 96.0), "行去入屋", "#9fd6bf"])
		return true
	J.mc(_s767["__p"]["A"], "float", [J.gp(v_un_1860, "x"), J.sub(J.gp(v_un_1860, "y"), 96.0), "去唔到", "#ffb0b0"])
	return true

func _f310(this_, a: Array, env):
	var v_u_1877 = null
	v_u_1877 = J.arg(a, 0)
	if J.seq(J.gp(v_u_1877, "did"), J.gp(env["n"], "id")):
		env["un"] = v_u_1877

func _f309(this_, a: Array, env):
	var v_g_1870 = null; var v_g0_1873 = null; var v_ok_1874 = null
	var _s773 = {"__p": env, "n": null, "un": null}
	v_g_1870 = J.arg(a, 0)
	_s773["n"] = J.arg(a, 1)
	if (not J.seq(J.gp(_s773["n"], "kind"), "door")):
		return null
	_s773["un"] = null
	v_g0_1873 = J.cl(_s773["__p"]["G"], null, [])
	var _t2108 = J.gp(v_g0_1873, "units")
	J.mc(_t2108, "forEach", [Callable(self, "_f310").bind(_s773)])
	if (not J.t(_s773["un"])):
		return null
	if J.seq(J.gp(_s773["un"], "ot"), "deity"):
		return {"k": "unitRespect", "t": "（神明鎮宅：要尊重，唔入）"}
	var _t2109 = _s773["__p"]["isHH"]
	if (not J.t(J.cl(_t2109, null, [_s773["un"]]))):
		return null
	var _t2110 = _s773["__p"]["enterable"]
	v_ok_1874 = J.cl(_t2110, null, [v_g_1870, _s773["un"]])
	if J.seq(v_ok_1874, true):
		return {"k": "unitIn", "t": J.add("入屋：", (J.gp(J.gp(J.gp(_s773["__p"]["A"], "HH"), J.gp(_s773["un"], "hh")), "n") if J.t(J.gp(J.gp(_s773["__p"]["A"], "HH"), J.gp(_s773["un"], "hh"))) else "住戶")), "un": _s773["un"]}
	var _t2111 = J.seq(v_ok_1874, "ban")
	if (_t2111 if _t2111 else J.seq(v_ok_1874, "cd")):
		return {"k": "unitBan", "t": (J.add((("（" + ("佢哋開晒燈守住" if J.seq(v_ok_1874, "ban") else "陰氣未回")) + "："), ceil(J.num((J.gp(J.gp(_s773["un"], "iu"), "ban") if J.seq(v_ok_1874, "ban") else J.gp(J.gp(_s773["un"], "iu"), "cd"))))) + " 秒）"), "un": _s773["un"]}
	return null

func _f312(this_, a: Array, env):
	var v_u_1886 = null
	v_u_1886 = J.arg(a, 0)
	return J.seq(J.gp(v_u_1886, "did"), J.gp(env["g"], "node"))

func _f311(this_, a: Array, env):
	var v_a_1881 = null; var v_g0_1882 = null; var v_un_1883 = null
	var _s775 = {"__p": env, "g": null}
	_s775["g"] = J.arg(a, 0)
	v_a_1881 = J.arg(a, 1)
	if J.seq(J.gp(v_a_1881, "k"), "unitIn"):
		J.mc(_s775["__p"]["U"], "enterFromDoor", [_s775["g"], J.gp(v_a_1881, "un")])
		return true
	if J.seq(J.gp(v_a_1881, "k"), "unitRespect"):
		v_g0_1882 = J.cl(_s775["__p"]["G"], null, [])
		var _t2114 = J.gp(v_g0_1882, "units")
		v_un_1883 = J.mc(_t2114, "find", [Callable(self, "_f312").bind(_s775)])
		if J.t(v_un_1883):
			var _t2115 = _s775["__p"]["blockedMsg"]
			J.cl(_t2115, null, [_s775["g"], v_un_1883, "deity"])
		return true
	if J.seq(J.gp(v_a_1881, "k"), "unitBan"):
		var _t2116 = _s775["__p"]["blockedMsg"]
		J.cl(_t2116, null, [_s775["g"], J.gp(v_a_1881, "un"), ("ban" if J.cmp(J.gp(J.gp(J.gp(v_a_1881, "un"), "iu"), "ban"), 0.0, ">") else "cd")])
		return true
	return false

func _f313(this_, a: Array, env):
	var v_g_1889 = null
	v_g_1889 = J.arg(a, 0)
	return (not (not J.t((J.seq(J.gp(env["S"], "g"), v_g_1889) if J.t(env["S"]) else env["S"]))))

func _f314(this_, a: Array, env):
	return J.cl(env["visible"], null, [])

func _f315(this_, a: Array, env):
	return (not (not J.t(env["S"])))

func _f318(this_, a: Array, env):
	var v_a_1904 = null
	v_a_1904 = J.arg(a, 0)
	var _t2137 = J.gp(J.gp(v_a_1904, "r"), "hh")
	var _t2138 = J.round(J.num(J.gp(v_a_1904, "x")))
	var _t2136 = env["roomAt"]
	var _t2140 = J.cl(_t2136, null, [J.gp(v_a_1904, "x")])
	var _t2141 = J.gp(v_a_1904, "act")
	var _t2142 = J.gp(v_a_1904, "st")
	var _t2143 = (not (not J.t(J.gp(J.gp(v_a_1904, "r"), "awake"))))
	var _t2139 = J.gp(J.gp(v_a_1904, "r"), "fear")
	return {"hh": _t2137, "x": _t2138, "room": _t2140, "act": _t2141, "st": _t2142, "awake": _t2143, "fear": J.round(J.num((_t2139 if J.t(_t2139) else 0.0))), "rstate": J.gp(J.gp(v_a_1904, "r"), "state")}

func _f319(this_, a: Array, env):
	var v_p_1907 = null
	v_p_1907 = J.arg(a, 0)
	return {"k": J.gp(v_p_1907, "k"), "x": J.gp(v_p_1907, "x"), "y": J.gp(v_p_1907, "y"), "room": J.gp(v_p_1907, "room"), "cd": J.round(J.num(J.gp(v_p_1907, "cd")))}

func _f320(this_, a: Array, env):
	var v_p_1910 = null; var v_i_1911 = null
	v_p_1910 = J.arg(a, 0)
	v_i_1911 = J.arg(a, 1)
	var _t2150 = J.gp(v_p_1910, "x")
	var _t2151 = J.gp(v_p_1910, "y")
	var _t2149 = env["itemsAt"]
	return {"x": _t2150, "y": _t2151, "items": J.cl(_t2149, null, [v_i_1911])}

func _f317(this_, a: Array, env):
	if (not J.t(env["S"])):
		return null
	var _t2126 = J.gp(J.gp(env["S"], "un"), "id")
	var _t2127 = J.gp(J.gp(env["S"], "un"), "hh")
	var _t2128 = J.gp(J.gp(env["S"], "lay"), "key")
	var _t2129 = J.round(J.num(J.gp(env["S"], "gx")))
	var _t2125 = env["roomAt"]
	var _t2131 = J.cl(_t2125, null, [J.gp(env["S"], "gx")])
	var _t2132 = J.div(J.round(J.num(J.mul(J.gp(env["S"], "alert"), 10.0))), 10.0)
	var _t2133 = J.round(J.num(J.gp(env["S"], "limit")))
	var _t2134 = J.mc(J.gp(env["S"], "light"), "slice", [])
	var _t2130 = J.gp(env["S"], "dark")
	var _t2144 = J.mc(_t2130, "map", [J.gp(J.G.get("Math"), "round")])
	var _t2145 = {"k": J.gp(J.gp(env["S"], "task"), "k"), "t": J.gp(J.gp(env["S"], "task"), "t"), "done": (not (not J.t(J.gp(J.gp(env["S"], "task"), "done")))), "spot": J.gp(J.gp(env["S"], "task"), "spot"), "x": J.gp(J.gp(env["S"], "task"), "x")}
	var _t2135 = J.gp(env["S"], "actors")
	var _t2147 = J.mc(_t2135, "map", [Callable(self, "_f318").bind(env)])
	var _t2146 = J.gp(env["S"], "spots")
	var _t2152 = J.mc(_t2146, "map", [Callable(self, "_f319").bind(env)])
	var _t2148 = J.gp(env["S"], "search")
	var _t2154 = J.mc(_t2148, "map", [Callable(self, "_f320").bind(env)])
	var _t2153 = J.gp(env["U"], "_err")
	return {"un": _t2126, "hh": _t2127, "lay": _t2128, "gx": _t2129, "room": _t2131, "alert": _t2132, "limit": _t2133, "light": _t2134, "dark": _t2144, "task": _t2145, "actors": _t2147, "spots": _t2152, "search": _t2154, "err": (_t2153 if J.t(_t2153) else null), "sc": (not (not J.t(J.gp(env["S"], "sc")))), "scCd": J.gp(env["S"], "scCd"), "invT": J.gp(env["S"], "invT"), "stun": J.gp(env["S"], "stun")}

func _f321(this_, a: Array, env):
	var v_x_1914 = null; var v_y_1915 = null; var v_V_1916 = null; var v_q_1917 = null; var v_r_1918 = null
	v_x_1914 = J.arg(a, 0)
	v_y_1915 = J.arg(a, 1)
	if (not J.t(env["S"])):
		return null
	v_V_1916 = J.cl(env["view"], null, [])
	var _t2157 = env["P"]
	v_q_1917 = J.cl(_t2157, null, [v_x_1914, v_y_1915, v_V_1916])
	v_r_1918 = J.mc(env["cv"], "getBoundingClientRect", [])
	return {"x": J.add(J.gp(v_q_1917, "x"), J.gp(v_r_1918, "left")), "y": J.add(J.gp(v_q_1917, "y"), J.gp(v_r_1918, "top"))}

func _f322(this_, a: Array, env):
	var v_V_1921 = null
	if (not J.t(env["S"])):
		return null
	v_V_1921 = J.cl(env["view"], null, [])
	var _t2160 = J.gp(env["S"], "cam")
	var _t2161 = env["clamp"]
	var _t2162 = J.cl(_t2161, null, [(J.gp(J.gp(env["S"], "cam"), "free") if (not J.leq(J.gp(J.gp(env["S"], "cam"), "free"), null)) else J.sub(J.gp(env["S"], "gx"), J.div(J.gp(v_V_1921, "vw"), 2.0))), 0.0, J.max_([0.0, J.sub(J.gp(J.gp(env["S"], "lay"), "W"), J.gp(v_V_1921, "vw"))])])
	J.sp(_t2160, "x", _t2162)

func _f324(this_, a: Array, env):
	var v_b_1927 = null
	v_b_1927 = J.arg(a, 0)
	return {"id": J.gp(v_b_1927, "id"), "x": J.add(J.gp(v_b_1927, "x"), J.gp(env["r"], "left")), "y": J.add(J.gp(v_b_1927, "y"), J.gp(env["r"], "top")), "w": J.gp(v_b_1927, "w"), "h": J.gp(v_b_1927, "h")}

func _f323(this_, a: Array, env):
	var _s797 = {"__p": env, "r": null}
	_s797["r"] = J.mc(_s797["__p"]["cv"], "getBoundingClientRect", [])
	return J.mc(_s797["__p"]["BTN"], "map", [Callable(self, "_f324").bind(_s797)])

func _f325(this_, a: Array, env):
	var v_v_1930 = null
	v_v_1930 = J.arg(a, 0)
	if J.t(env["S"]):
		var _t2167 = env["S"]
		J.sp(_t2167, "alert", v_v_1930)

func _f326(this_, a: Array, env):
	var v_x_1933 = null
	v_x_1933 = J.arg(a, 0)
	if J.t(env["S"]):
		var _t2170 = env["S"]
		J.sp(_t2170, "gx", v_x_1933)
		var _t2171 = env["S"]
		J.sp(_t2171, "goX", null)

func _f327(this_, a: Array, env):
	var v_i_1936 = null
	v_i_1936 = J.arg(a, 0)
	var _t2175 = null
	if J.t(env["S"]):
		var _t2174 = env["trigger"]
		_t2175 = J.cl(_t2174, null, [J.gp(J.gp(env["S"], "spots"), v_i_1936), false])
	else:
		_t2175 = false
	return _t2175

func _f328(this_, a: Array, env):
	return env["S"]

func _f162(this_, a: Array, env):
	var v_ACTN_933 = null
	var _s372 = {"__p": env, "A": null, "U": null, "S": null, "lastG": null, "LIMIT": null, "BAN": null, "REIN": null, "SEE_LIT": null, "SEE_DARK": null, "RANGE_HOT": null, "RANGE_SCARE": null, "OMEN": null, "HOT": null, "LN": null, "lnUsed": null, "WANT": null, "TASK": null, "FB": null, "AC": null, "NB": null, "SND": null, "cv": null, "c": null, "W": null, "H": null, "DPR": null, "BTN": null, "PRESS": null, "ptr": null, "last": null, "line": null, "LAYS": null, "layFor": null, "G": null, "rnd": null, "pick": null, "img": null, "clamp": null, "wpick": null, "isHH": null, "iu": null, "roomAt": null, "sayR": null, "msg": null, "wfl": null, "part": null, "running": null, "visible": null, "ac": null, "tone": null, "hiss": null, "enterable": null, "blockedMsg": null, "open": null, "mkActor": null, "actPose": null, "pickAct": null, "searchUpdate": null, "itemsAt": null, "actorsUpdate": null, "lightsUpdate": null, "facing": null, "detect": null, "thresholds": null, "trigger": null, "addRFear": null, "roomTask": null, "taskDone": null, "taskCheck": null, "nearestActor": null, "scareAt": null, "strike": null, "hideNative": null, "layout": null, "view": null, "P": null, "sprite": null, "bubble": null, "btn": null, "txt": null, "drawBG": null, "drawSpot": null, "drawActor": null, "drawGhost": null, "draw": null, "drawHUD": null, "ctxBtn": null, "wrapT": null, "drawJoy": null, "pt": null, "hit": null, "press": null, "worldTap": null, "loop": null}
	_s372["A"] = J.arg(a, 0)
	_s372["line"] = Callable(self, "_f163").bind(_s372)
	_s372["LAYS"] = Callable(self, "_f165").bind(_s372)
	_s372["layFor"] = Callable(self, "_f166").bind(_s372)
	_s372["G"] = Callable(self, "_f167").bind(_s372)
	_s372["rnd"] = Callable(self, "_f168").bind(_s372)
	_s372["pick"] = Callable(self, "_f169").bind(_s372)
	_s372["img"] = Callable(self, "_f170").bind(_s372)
	_s372["clamp"] = Callable(self, "_f171").bind(_s372)
	_s372["wpick"] = Callable(self, "_f172").bind(_s372)
	_s372["isHH"] = Callable(self, "_f174").bind(_s372)
	_s372["iu"] = Callable(self, "_f175").bind(_s372)
	_s372["roomAt"] = Callable(self, "_f176").bind(_s372)
	_s372["sayR"] = Callable(self, "_f177").bind(_s372)
	_s372["msg"] = Callable(self, "_f178").bind(_s372)
	_s372["wfl"] = Callable(self, "_f179").bind(_s372)
	_s372["part"] = Callable(self, "_f181").bind(_s372)
	_s372["running"] = Callable(self, "_f182").bind(_s372)
	_s372["visible"] = Callable(self, "_f183").bind(_s372)
	_s372["ac"] = Callable(self, "_f184").bind(_s372)
	_s372["tone"] = Callable(self, "_f185").bind(_s372)
	_s372["hiss"] = Callable(self, "_f186").bind(_s372)
	_s372["enterable"] = Callable(self, "_f193").bind(_s372)
	_s372["blockedMsg"] = Callable(self, "_f196").bind(_s372)
	_s372["open"] = Callable(self, "_f198").bind(_s372)
	_s372["mkActor"] = Callable(self, "_f208").bind(_s372)
	_s372["actPose"] = Callable(self, "_f209").bind(_s372)
	_s372["pickAct"] = Callable(self, "_f210").bind(_s372)
	_s372["searchUpdate"] = Callable(self, "_f223").bind(_s372)
	_s372["itemsAt"] = Callable(self, "_f226").bind(_s372)
	_s372["actorsUpdate"] = Callable(self, "_f228").bind(_s372)
	_s372["lightsUpdate"] = Callable(self, "_f235").bind(_s372)
	_s372["facing"] = Callable(self, "_f238").bind(_s372)
	_s372["detect"] = Callable(self, "_f239").bind(_s372)
	_s372["thresholds"] = Callable(self, "_f244").bind(_s372)
	_s372["trigger"] = Callable(self, "_f248").bind(_s372)
	_s372["addRFear"] = Callable(self, "_f250").bind(_s372)
	_s372["roomTask"] = Callable(self, "_f251").bind(_s372)
	_s372["taskDone"] = Callable(self, "_f252").bind(_s372)
	_s372["taskCheck"] = Callable(self, "_f253").bind(_s372)
	_s372["nearestActor"] = Callable(self, "_f255").bind(_s372)
	_s372["scareAt"] = Callable(self, "_f257").bind(_s372)
	_s372["strike"] = Callable(self, "_f259").bind(_s372)
	_s372["hideNative"] = Callable(self, "_f260").bind(_s372)
	_s372["layout"] = Callable(self, "_f261").bind(_s372)
	_s372["view"] = Callable(self, "_f262").bind(_s372)
	_s372["P"] = Callable(self, "_f263").bind(_s372)
	_s372["sprite"] = Callable(self, "_f264").bind(_s372)
	_s372["bubble"] = Callable(self, "_f265").bind(_s372)
	_s372["btn"] = Callable(self, "_f266").bind(_s372)
	_s372["txt"] = Callable(self, "_f267").bind(_s372)
	_s372["drawBG"] = Callable(self, "_f268").bind(_s372)
	_s372["drawSpot"] = Callable(self, "_f271").bind(_s372)
	_s372["drawActor"] = Callable(self, "_f272").bind(_s372)
	_s372["drawGhost"] = Callable(self, "_f273").bind(_s372)
	_s372["draw"] = Callable(self, "_f274").bind(_s372)
	_s372["drawHUD"] = Callable(self, "_f284").bind(_s372)
	_s372["ctxBtn"] = Callable(self, "_f287").bind(_s372)
	_s372["wrapT"] = Callable(self, "_f289").bind(_s372)
	_s372["drawJoy"] = Callable(self, "_f290").bind(_s372)
	_s372["pt"] = Callable(self, "_f291").bind(_s372)
	_s372["hit"] = Callable(self, "_f292").bind(_s372)
	_s372["press"] = Callable(self, "_f299").bind(_s372)
	_s372["worldTap"] = Callable(self, "_f300").bind(_s372)
	_s372["loop"] = Callable(self, "_f316").bind(_s372)
	_s372["U"] = {}
	_s372["S"] = null
	_s372["lastG"] = null
	_s372["LIMIT"] = 80.0
	_s372["BAN"] = 25.0
	_s372["REIN"] = 6.0
	_s372["SEE_LIT"] = 26.0
	_s372["SEE_DARK"] = 7.0
	_s372["RANGE_HOT"] = 130.0
	_s372["RANGE_SCARE"] = 150.0
	_s372["OMEN"] = 0.6
	_s372["HOT"] = {"lamp": {"v": "閃燈熄燈", "f": 14.0, "loud": 0.0, "ln": ["盞燈做咩閃吓閃吓……", "跳掣？黑麻麻咁……", "又停電？"]}, "tv": {"v": "電視雪花", "f": 24.0, "loud": 1.0, "ln": ["部電視自己轉台？！", "雪花入面……好似有個人影", "我冇撳過遙控㗎！"]}, "tap": {"v": "水喉自己開", "f": 20.0, "loud": 1.0, "ln": ["邊個開咗水喉？", "水喉自己嘩啦嘩啦咁流……"]}, "fridge": {"v": "雪櫃門自己開", "f": 20.0, "loud": 0.0, "ln": ["雪櫃門自己彈開咗！", "點解成間屋咁凍……"]}, "wardrobe": {"v": "衣櫃門自己開", "f": 24.0, "loud": 1.0, "ln": ["衣櫃門……自己慢慢打開……", "入面係咪有人匿埋？"]}, "mirror": {"v": "鏡入面多個影", "f": 28.0, "loud": 0.0, "ln": ["面鏡……我後面有人？", "頭先鏡入面嗰個唔係我……"]}, "pc": {"v": "電腦彈鬼臉", "f": 26.0, "loud": 1.0, "ln": ["個 mon 彈咗張臉出嚟！", "我隻角色自己行開咗？！"]}, "fan": {"v": "風扇狂轉", "f": 18.0, "loud": 0.0, "ln": ["把風扇自己轉到咁大力？！", "啲窗簾吹到飛晒起……"]}, "shower": {"v": "花灑自己開", "f": 22.0, "loud": 1.0, "ln": ["花灑自己開咗……", "冇人喺度，點解有水聲？"]}, "radio": {"v": "收音機自己播", "f": 20.0, "loud": 1.0, "ln": ["收音機自己播粵曲……", "邊個開咗收音機？"]}, "pots": {"v": "鑊鏟自己跌", "f": 22.0, "loud": 1.0, "ln": ["乒乓聲！鑊鏟自己跌落地！", "廚房咩聲呀？！"]}, "net": {"v": "蚊帳自己郁", "f": 22.0, "loud": 0.0, "ln": ["蚊帳自己郁緊……", "冇風㗎喎，點解蚊帳會郁？"]}, "jar": {"v": "水缸冒泡", "f": 20.0, "loud": 0.0, "ln": ["水缸咕嚕咕嚕咁冒泡……", "水缸入面……有嘢？"]}}
	_s372["LN"] = {"see": ["嗰度……有嘢！", "頭先係咪有個影？", "邊個喺度？！", "我見到喇！唔好走！", "你……你係邊個？"], "lightOn": ["開燈先……", "咁黑，開咗盞燈先", "點解會跳掣嘅？開返先"], "go": ["咩聲嚟㗎？去睇睇", "我過去睇下……", "邊度傳嚟嘅聲？"], "look": ["冇嘢喎……", "係咪我聽錯？", "奇怪……明明有聲"], "wake": ["醒醒呀！屋企有嘢呀！", "起身呀，有怪聲呀！"], "phone": ["喂？管理處呀？我屋企有古怪，快啲上嚟！", "喂？保安呀？我哋呢層有嘢呀！"], "lights": ["開晒啲燈！開晒佢！", "全部燈開晒，睇佢仲點匿！"], "kick": ["出去呀！唔好再嚟！", "開晒燈大嗌：「唔該你出去！」"], "leave": ["返工喇，出門口先", "出去行下先"]}
	_s372["lnUsed"] = {}
	_s372["WANT"] = {"gamer": [["pc", 6.0], ["fridge", 1.5], ["sofa", 1.5], ["wash", 1.0]], "ot": [["desk", 4.0], ["tv", 3.0], ["cook", 2.0], ["shower", 1.0]], "gym": [["sofa", 2.0], ["shower", 3.0], ["cook", 3.0], ["tv", 2.0]], "nurse": [["cook", 3.0], ["tv", 3.0], ["shower", 3.0], ["desk", 1.0]], "elder": [["radio", 5.0], ["cook", 2.0], ["wash", 1.0], ["desk", 2.0]], "insomnia": [["radio", 5.0], ["cook", 2.0], ["desk", 3.0]], "granny": [["tv", 6.0], ["cook", 3.0], ["wash", 1.0]], "couple": [["tv", 5.0], ["cook", 2.5], ["shower", 2.5]], "mahjong": [["table", 1.0]], "shopper": [["sofa", 5.0], ["desk", 2.0], ["cook", 3.0]], "taxi": [["tv", 6.0], ["cook", 2.0], ["shower", 2.0]], "cook": [["cook", 7.0], ["tv", 3.0]], "helper": [["cook", 4.0], ["sink", 3.0], ["shower", 1.0], ["wash", 2.0]], "debt": [["sofa", 6.0], ["desk", 4.0]]}
	v_ACTN_933 = {"pc": "打機", "desk": "坐喺枱前", "sofa": "坐梳化", "tv": "睇電視", "radio": "聽收音機", "table": "打麻雀", "cook": "煮嘢食", "sink": "洗碗", "fridge": "搵嘢食", "shower": "沖涼", "wash": "洗面", "bed": "瞓覺"}
	_s372["TASK"] = {"gamer": {"k": "media"}, "ot": {"k": "steal", "o": "公司門卡", "at": "desk"}, "gym": {"k": "room", "room": "bath", "act": "shower"}, "nurse": {"k": "room", "room": "bath", "act": "shower"}, "elder": {"k": "media"}, "insomnia": {"k": "media"}, "granny": {"k": "steal", "o": "葵扇", "at": "sofa"}, "couple": {"k": "allout"}, "mahjong": {"k": "steal", "o": "一隻麻雀牌", "at": "table"}, "shopper": {"k": "steal", "o": "速遞包裹", "at": "door"}, "taxi": {"k": "media"}, "cook": {"k": "room", "room": "kitchen", "act": "cook"}, "helper": {"k": "steal", "o": "熨斗", "at": "cook"}, "debt": {"k": "steal", "o": "門口嗰封追數信", "at": "door"}}
	_s372["FB"] = {"img": null, "W": 1440.0, "H": 420.0, "crop": [20.0, 420.0], "floor": 396.0, "ceil": 40.0, "ph": 230.0, "door": 40.0, "fb": true, "rooms": [{"k": "living", "n": "客廳", "x0": 0.0, "x1": 360.0}, {"k": "kitchen", "n": "廚房", "x0": 360.0, "x1": 720.0}, {"k": "bed", "n": "睡房", "x0": 720.0, "x1": 1080.0}, {"k": "bath", "n": "廁所", "x0": 1080.0, "x1": 1440.0}], "spots": [{"k": "lamp", "x": 180.0, "y": 70.0}, {"k": "tv", "x": 300.0, "y": 270.0}, {"k": "fridge", "x": 640.0, "y": 270.0}, {"k": "tap", "x": 500.0, "y": 280.0}, {"k": "wardrobe", "x": 1000.0, "y": 260.0}, {"k": "mirror", "x": 1200.0, "y": 220.0}], "acts": {"sofa": {"x": 150.0, "pose": "sit", "look": "tv"}, "tv": {"x": 200.0, "pose": "sit", "look": "tv"}, "radio": {"x": 200.0, "pose": "sit", "look": "tv"}, "table": {"x": 180.0, "seats": [100.0, 150.0, 210.0, 260.0], "pose": "sit"}, "cook": {"x": 450.0, "look": "tap"}, "sink": {"x": 520.0, "look": "tap"}, "fridge": {"x": 610.0, "look": "fridge"}, "desk": {"x": 800.0, "pose": "sit", "look": "wardrobe"}, "pc": {"x": 800.0, "pose": "sit", "look": "wardrobe"}, "bed": {"x": 900.0, "pose": "lie", "lift": 60.0}, "shower": {"x": 1300.0}, "wash": {"x": 1200.0, "look": "mirror"}}, "search": [{"x": 90.0, "y": 360.0, "n": "櫃桶"}, {"x": 560.0, "y": 340.0, "n": "碗櫃"}, {"x": 1040.0, "y": 360.0, "n": "衣櫃底"}, {"x": 1380.0, "y": 370.0, "n": "膠桶"}], "steal": {}}
	_s372["AC"] = null
	_s372["NB"] = null
	_s372["SND"] = {"door": Callable(self, "_f187").bind(_s372), "hot": Callable(self, "_f188").bind(_s372), "scare": Callable(self, "_f189").bind(_s372), "see": Callable(self, "_f190").bind(_s372), "kick": Callable(self, "_f191").bind(_s372)}
	J.S_document_("addEventListener", ["pointerdown", Callable(self, "_f192").bind(_s372), {"passive": true}])
	var _t1854 = _s372["U"]
	var _t1856 = Callable(self, "_f194").bind(_s372)
	J.sp(_t1854, "canEnter", _t1856)
	var _t1857 = _s372["U"]
	var _t1863 = Callable(self, "_f195").bind(_s372)
	J.sp(_t1857, "enterFromDoor", _t1863)
	var _t1864 = _s372["U"]
	var _t1875 = Callable(self, "_f197").bind(_s372)
	J.sp(_t1864, "arrive", _t1875)
	var _t1876 = _s372["U"]
	var _t1890 = Callable(self, "_f212").bind(_s372)
	J.sp(_t1876, "exit", _t1890)
	var _t1891 = _s372["U"]
	var _t2003 = Callable(self, "_f213").bind(_s372)
	J.sp(_t1891, "step", _t2003)
	var _t2004 = _s372["U"]
	var _t2028 = Callable(self, "_f258").bind(_s372)
	J.sp(_t2004, "scare", _t2028)
	_s372["cv"] = J.S_document_("createElement", ["canvas"])
	var _t2029 = _s372["cv"]
	J.sp(_t2029, "id", "unit-cv")
	var _t2030 = J.gp(_s372["cv"], "style")
	J.sp(_t2030, "cssText", "position:fixed;z-index:63;left:0;top:0;display:none;touch-action:none")
	var _t2031 = J.gp(J.G.get("document"), "body")
	J.mc(_t2031, "appendChild", [_s372["cv"]])
	_s372["c"] = J.mc(_s372["cv"], "getContext", ["2d"])
	_s372["W"] = 390.0
	_s372["H"] = 844.0
	_s372["DPR"] = 1.0
	_s372["BTN"] = []
	_s372["PRESS"] = null
	_s372["ptr"] = null
	J.mc(_s372["cv"], "addEventListener", ["pointerdown", Callable(self, "_f293").bind(_s372)])
	J.mc(_s372["cv"], "addEventListener", ["pointermove", Callable(self, "_f294").bind(_s372)])
	J.mc(_s372["cv"], "addEventListener", ["pointerup", Callable(self, "_f295").bind(_s372)])
	J.mc(_s372["cv"], "addEventListener", ["pointercancel", Callable(self, "_f296").bind(_s372)])
	var _t2061 = ["touchstart", "touchmove", "touchend", "click", "contextmenu"]
	J.mc(_t2061, "forEach", [Callable(self, "_f297").bind(_s372)])
	var _t2062 = _s372["U"]
	var _t2091 = Callable(self, "_f303").bind(_s372)
	J.sp(_t2062, "drawWorld", _t2091)
	var _t2092 = _s372["U"]
	var _t2106 = Callable(self, "_f307").bind(_s372)
	J.sp(_t2092, "worldTap", _t2106)
	var _t2107 = _s372["U"]
	var _t2112 = Callable(self, "_f309").bind(_s372)
	J.sp(_t2107, "action", _t2112)
	var _t2113 = _s372["U"]
	var _t2117 = Callable(self, "_f311").bind(_s372)
	J.sp(_t2113, "act", _t2117)
	var _t2118 = _s372["U"]
	var _t2119 = Callable(self, "_f313").bind(_s372)
	J.sp(_t2118, "holds", _t2119)
	var _t2120 = _s372["U"]
	var _t2121 = Callable(self, "_f314").bind(_s372)
	J.sp(_t2120, "covering", _t2121)
	var _t2122 = _s372["U"]
	var _t2123 = Callable(self, "_f315").bind(_s372)
	J.sp(_t2122, "on", _t2123)
	_s372["last"] = 0.0
	J.F_requestAnimationFrame([_s372["loop"]])
	var _t2124 = _s372["U"]
	var _t2155 = Callable(self, "_f317").bind(_s372)
	J.sp(_t2124, "state", _t2155)
	var _t2156 = _s372["U"]
	var _t2158 = Callable(self, "_f321").bind(_s372)
	J.sp(_t2156, "toScreen", _t2158)
	var _t2159 = _s372["U"]
	var _t2163 = Callable(self, "_f322").bind(_s372)
	J.sp(_t2159, "camSnap", _t2163)
	var _t2164 = _s372["U"]
	var _t2165 = Callable(self, "_f323").bind(_s372)
	J.sp(_t2164, "btns", _t2165)
	var _t2166 = _s372["U"]
	var _t2168 = Callable(self, "_f325").bind(_s372)
	J.sp(_t2166, "setAlert", _t2168)
	var _t2169 = _s372["U"]
	var _t2172 = Callable(self, "_f326").bind(_s372)
	J.sp(_t2169, "setGX", _t2172)
	var _t2173 = _s372["U"]
	var _t2176 = Callable(self, "_f327").bind(_s372)
	J.sp(_t2173, "trig", _t2176)
	var _t2177 = _s372["U"]
	var _t2178 = _s372["press"]
	J.sp(_t2177, "press", _t2178)
	var _t2179 = _s372["U"]
	var _t2180 = _s372["layFor"]
	J.sp(_t2179, "layFor", _t2180)
	var _t2181 = _s372["U"]
	var _t2182 = _s372["HOT"]
	J.sp(_t2181, "HOT", _t2182)
	var _t2183 = _s372["U"]
	var _t2184 = Callable(self, "_f328").bind(_s372)
	J.sp(_t2183, "_S", _t2184)
	return _s372["U"]

func _f161(this_, a: Array, env):
	var _t1009 = J.G.get("window")
	var _t2185 = Callable(self, "_f162").bind(env)
	J.sp(_t1009, "UnitSys", _t2185)

func _f330(this_, a: Array, env):
	if (not J.t(J.gp(J.G.get("S"), "tower"))):
		var _t2186 = J.G.get("S")
		var _t2187 = {"unlocked": true, "cleared": {}, "best": 0.0, "nights": 0.0}
		J.sp(_t2186, "tower", _t2187)
	var _t2188 = J.gp(J.G.get("S"), "tower")
	var _t2189 = J.gp(J.gp(J.G.get("S"), "tower"), "cleared")
	var _t2190 = (_t2189 if J.t(_t2189) else {})
	J.sp(_t2188, "cleared", _t2190)
	return J.gp(J.G.get("S"), "tower")

func _f332(this_, a: Array, env):
	var v___2220 = null; var v_i_2221 = null
	v___2220 = J.arg(a, 0)
	v_i_2221 = J.arg(a, 1)
	return (J.add("第 ", J.add(v_i_2221, 1.0)) + " 段")

func _f331(this_, a: Array, env):
	var v_k_2216 = null; var v_T_2217 = null
	v_k_2216 = J.arg(a, 0)
	v_T_2217 = J.gp(env["LEVELS"], v_k_2216)
	var _t2191 = env["genLevel"]
	var _t2192 = J.cl(_t2191, null, [v_k_2216])
	env["LV"] = _t2192
	var _t2193 = env["LV"]
	var _t2194 = J.gp(v_T_2217, "story")
	J.sp(_t2193, "story", _t2194)
	var _t2195 = env["LV"]
	var _t2196 = J.gp(v_T_2217, "truth")
	J.sp(_t2195, "truth", _t2196)
	var _t2197 = env["LV"]
	var _t2198 = J.gp(v_T_2217, "story")
	var _t2199 = J.mc(_t2198, "map", [Callable(self, "_f332").bind(env)])
	J.sp(_t2197, "hint", _t2199)
	env["FL"] = J.gp(env["LV"], "FL")
	env["FYS"] = J.gp(env["LV"], "FYS")
	env["SX"] = J.gp(env["LV"], "SX")
	env["LX"] = J.gp(env["LV"], "LX")
	env["GLX"] = J.gp(env["LV"], "GLX")
	env["PX0"] = J.gp(env["LV"], "PX0")
	env["STORY"] = J.gp(env["LV"], "story")
	env["TRUTH"] = J.gp(env["LV"], "truth")
	env["FLN"] = J.gp(env["LV"], "fln")
	env["WW"] = J.gp(env["LV"], "WW")
	env["WH"] = J.gp(env["LV"], "WH")

func _f333(this_, a: Array, env):
	var v_f_2224 = null
	v_f_2224 = J.arg(a, 0)
	return J.gp(env["FYS"], v_f_2224)

func _f334(this_, a: Array, env):
	var _t2200 = J.mod(J.mul(env["seed"], 16807.0), 2147483647.0)
	env["seed"] = _t2200
	return J.div(J.sub(env["seed"], 1.0), 2147483646.0)

func _f335(this_, a: Array, env):
	var v_a_2229 = null
	v_a_2229 = J.arg(a, 0)
	return J.gp(v_a_2229, floor(J.num(J.mul(J.cl(env["rnd"], null, []), J.len(v_a_2229)))))

func _f336(this_, a: Array, env):
	var v_a_2232 = null; var v_i_2233 = null; var v_j_2234 = null; var v_t_2235 = null
	v_a_2232 = J.arg(a, 0)
	var _t2201 = J.mc(v_a_2232, "slice", [])
	v_a_2232 = _t2201
	v_i_2233 = (J.len(v_a_2232) - 1.0)
	while true:
		if not J.cmp(v_i_2233, 0.0, ">"): break
		v_j_2234 = floor(J.num(J.mul(J.cl(env["rnd"], null, []), J.add(v_i_2233, 1.0))))
		v_t_2235 = J.gp(v_a_2232, v_i_2233)
		var _t2202 = J.gp(v_a_2232, v_j_2234)
		J.sp(v_a_2232, v_i_2233, _t2202)
		J.sp(v_a_2232, v_j_2234, v_t_2235)
		v_i_2233 = J.num(v_i_2233) + -1.0
	return v_a_2232

func _f337(this_, a: Array, env):
	var v_v_2238 = null; var v_a_2239 = null; var v_b_2240 = null
	v_v_2238 = J.arg(a, 0)
	v_a_2239 = J.arg(a, 1)
	v_b_2240 = J.arg(a, 2)
	return (v_a_2239 if J.cmp(v_v_2238, v_a_2239, "<") else (v_b_2240 if J.cmp(v_v_2238, v_b_2240, ">") else v_v_2238))

func _f339(this_, a: Array, env):
	var v___2247 = null; var v_i_2248 = null
	v___2247 = J.arg(a, 0)
	v_i_2248 = J.arg(a, 1)
	return v_i_2248

func _f340(this_, a: Array, env):
	var v___2251 = null; var v_i_2252 = null
	v___2251 = J.arg(a, 0)
	v_i_2252 = J.arg(a, 1)
	return v_i_2252

func _f338(this_, a: Array, env):
	var v_k_2243 = null; var v_p_2244 = null
	v_k_2243 = J.arg(a, 0)
	v_p_2244 = J.gp(env["LINES"], v_k_2243)
	var _t2203 = env["used"]
	var _t2205 = J.gp(env["used"], v_k_2243)
	if not J.t(_t2205):
		var _t2204 = env["shuffle"]
		_t2205 = J.cl(_t2204, null, [J.mc(v_p_2244, "map", [Callable(self, "_f339").bind(env)])])
	J.sp(_t2203, v_k_2243, _t2205)
	if (not J.t(J.len(J.gp(env["used"], v_k_2243)))):
		var _t2206 = env["used"]
		var _t2207 = env["shuffle"]
		var _t2208 = J.cl(_t2207, null, [J.mc(v_p_2244, "map", [Callable(self, "_f340").bind(env)])])
		J.sp(_t2206, v_k_2243, _t2208)
	return J.gp(v_p_2244, J.mc(J.gp(env["used"], v_k_2243), "pop", []))

func _f341(this_, a: Array, env):
	var v_d_2255 = null; var v_P_2256 = null; var v_pw_2257 = null; var v_m_2258 = null; var v_e_2259 = null
	v_d_2255 = J.arg(a, 0)
	v_P_2256 = J.gp(J.G.get("window"), "GP")
	var _t2209 = (not J.t(v_P_2256))
	if (_t2209 if _t2209 else (not J.t(J.gp(v_d_2255, "gpk")))):
		return {"mul": 1.0, "pow": 0.0, "tr": false, "na": true}
	var _t2210 = J.mc(v_P_2256, "kindPow", [J.gp(v_d_2255, "gpk")])
	v_pw_2257 = (_t2210 if J.t(_t2210) else 0.0)
	v_m_2258 = J.mc(v_P_2256, "kindMul", [J.gp(v_d_2255, "gpk")])
	var _t2211 = (not J.t(J.F_isFinite([v_m_2258])))
	if (_t2211 if _t2211 else J.cmp(v_m_2258, 0.0, "<=")):
		v_m_2258 = 1.0
	return {"mul": v_m_2258, "pow": v_pw_2257, "tr": J.cmp(v_pw_2257, 0.0, "<="), "na": false}

func _f342(this_, a: Array, env):
	var v_g_2262 = null; var v_r_2263 = null; var v_m_2264 = null
	v_g_2262 = J.arg(a, 0)
	var _t2212 = env["gpRead"]
	v_r_2263 = J.cl(_t2212, null, [J.gp(v_g_2262, "d")])
	v_m_2264 = J.gp(v_r_2263, "mul")
	J.sp(v_g_2262, "mul", v_m_2264)
	var _t2213 = J.gp(v_r_2263, "pow")
	J.sp(v_g_2262, "pow", _t2213)
	var _t2214 = J.gp(v_r_2263, "tr")
	J.sp(v_g_2262, "trainee", _t2214)
	var _t2215 = J.gp(v_r_2263, "na")
	J.sp(v_g_2262, "gpNA", _t2215)
	var _t2216 = J.min_([1.12, (1.0 + (0.08 * J.sub(v_m_2264, 1.0)))])
	J.sp(v_g_2262, "spm", _t2216)
	var _t2217 = (1.0 + (0.2 * J.sub(v_m_2264, 1.0)))
	J.sp(v_g_2262, "em", _t2217)
	var _t2218 = J.min_([1.3, (1.0 + (0.1 * J.sub(v_m_2264, 1.0)))])
	J.sp(v_g_2262, "tm", _t2218)
	var _t2219 = J.max_([0.85, J.min_([1.35, (1.0 + (0.15 * J.sub(v_m_2264, 1.0)))])])
	J.sp(v_g_2262, "im", _t2219)
	var _t2220 = J.max_([0.7, J.min_([1.1, (1.0 - (0.15 * J.sub(v_m_2264, 1.0)))])])
	J.sp(v_g_2262, "icd", _t2220)
	var _t2221 = J.max_([0.9, J.min_([1.3, (1.0 + (0.15 * J.sub(v_m_2264, 1.0)))])])
	J.sp(v_g_2262, "um", _t2221)
	var _t2222 = J.gp(v_g_2262, "energy")
	var _t2223 = (_t2222 if J.t(_t2222) else 0.0)
	J.sp(v_g_2262, "_eL", _t2223)

func _f343(this_, a: Array, env):
	return J.cl(env["TS"], null, [])

func _f344(this_, a: Array, env):
	var v_sv_2269 = null
	v_sv_2269 = J.arg(a, 0)

func _f345(this_, a: Array, env):
	var v_lv_2272 = null; var v_sv_2273 = null
	v_lv_2272 = J.arg(a, 0)
	if (not J.t(J.gp(J.G.get("window"), "GP"))):
		return 0.0
	var _t2224 = J.cl(env["gpSv"], null, [])
	v_sv_2273 = (_t2224 if J.t(_t2224) else {})
	var _t2226 = env["GP_TIER_MAX"]
	var _t2225 = J.gp(v_sv_2273, J.add("win_", v_lv_2272))
	var _t2228 = env["GP_TIER_MAX"]
	var _t2227 = J.gp(v_sv_2273, J.add("win_", v_lv_2272))
	return J.min_([_t2228, J.num((_t2227 if J.t(_t2227) else 0.0))])

func _f346(this_, a: Array, env):
	var v_lv_2276 = null
	v_lv_2276 = J.arg(a, 0)
	var _t2229 = J.gp(env["GP_BASE"], v_lv_2276)
	var _t2231 = (_t2229 if J.t(_t2229) else 1100.0)
	var _t2230 = env["gpTier"]
	return (J.round(J.num(J.div(J.mul(_t2231, (1.0 + J.mul(0.18, J.cl(_t2230, null, [v_lv_2276])))), 10.0))) * 10.0)

func _f347(this_, a: Array, env):
	var v_lv_2279 = null
	v_lv_2279 = J.arg(a, 0)
	var _t2232 = env["gpTier"]
	return pow(J.num((1.0 + J.mul(0.18, J.cl(_t2232, null, [v_lv_2279])))), J.num(0.6))

func _f348(this_, a: Array, env):
	var v_d_2282 = null; var v_r_2283 = null
	v_d_2282 = J.arg(a, 0)
	var _t2233 = env["gpRead"]
	v_r_2283 = J.cl(_t2233, null, [v_d_2282])
	return (0.0 if J.t(J.gp(v_r_2283, "na")) else (env["GP_TRAINEE_POW"] if J.t(J.gp(v_r_2283, "tr")) else J.gp(v_r_2283, "pow")))

func _f350(this_, a: Array, env):
	var v_s_2288 = null; var v_d_2289 = null
	v_s_2288 = J.arg(a, 0)
	v_d_2289 = J.arg(a, 1)
	var _t2234 = env["gpPowOf"]
	return J.add(v_s_2288, J.cl(_t2234, null, [v_d_2289]))

func _f349(this_, a: Array, env):
	return J.mc(env["GH"], "reduce", [Callable(self, "_f350").bind(env), 0.0])

func _f351(this_, a: Array, env):
	var v_g_2292 = null
	v_g_2292 = J.arg(a, 0)
	var _t2235 = (J.gp(v_g_2292, "mul") if J.t(v_g_2292) else v_g_2292)
	var _t2237 = (_t2235 if J.t(_t2235) else 1.0)
	var _t2236 = (J.gp(env["G"], "gpD") if J.t(env["G"]) else env["G"])
	return J.div(_t2237, (_t2236 if J.t(_t2236) else 1.0))

func _f352(this_, a: Array, env):
	var v_g_2295 = null; var v_e_2296 = null; var v_L_2297 = null
	v_g_2295 = J.arg(a, 0)
	var _t2238 = J.gp(v_g_2295, "energy")
	v_e_2296 = (_t2238 if J.t(_t2238) else 0.0)
	v_L_2297 = J.gp(v_g_2295, "_eL")
	var _t2239 = (not J.leq(v_L_2297, null))
	var _t2240 = (J.cmp(v_e_2296, v_L_2297, ">") if _t2239 else _t2239)
	var _t2241 = (J.gp(v_g_2295, "em") if _t2240 else _t2240)
	if J.t(((not J.seq(J.gp(v_g_2295, "em"), 1.0)) if J.t(_t2241) else _t2241)):
		var _t2242 = J.min_([100.0, J.add(v_L_2297, J.mul(J.sub(v_e_2296, v_L_2297), J.gp(v_g_2295, "em")))])
		J.sp(v_g_2295, "energy", _t2242)
	var _t2243 = J.gp(v_g_2295, "energy")
	J.sp(v_g_2295, "_eL", _t2243)

func _f354(this_, a: Array, env):
	var v_g_2302 = null
	v_g_2302 = J.arg(a, 0)
	return J.gp(v_g_2302, "trainee")

func _f353(this_, a: Array, env):
	var _t2244 = J.gp(env["G"], "gh")
	J.mc(_t2244, "forEach", [env["gpApply"]])
	var _t2245 = env["G"]
	var _t2246 = (not (not J.t(J.gp(J.G.get("window"), "GP"))))
	J.sp(_t2245, "gpHas", _t2246)
	var _t2247 = env["G"]
	var _t2248 = env["gpTier"]
	var _t2249 = J.cl(_t2248, null, [env["curLv"]])
	J.sp(_t2247, "gpTier", _t2249)
	var _t2250 = env["G"]
	var _t2251 = env["gpDiff"]
	var _t2252 = J.cl(_t2251, null, [env["curLv"]])
	J.sp(_t2250, "gpD", _t2252)
	var _t2253 = env["G"]
	var _t2254 = env["gpNeed"]
	var _t2255 = J.cl(_t2254, null, [env["curLv"]])
	J.sp(_t2253, "gpNeed", _t2255)
	var _t2256 = env["G"]
	var _t2257 = J.cl(env["gpTeam"], null, [])
	J.sp(_t2256, "gpTeam", _t2257)
	var _t2258 = env["G"]
	var _t2261 = null
	if J.t(J.gp(env["G"], "gpHas")):
		var _t2260 = (J.add((J.add((J.add((J.add("今晚", J.gp(env["LV"], "name")) + "第 "), J.add(J.gp(env["G"], "gpTier"), 1.0)) + " 級：建議鬼力 "), J.gp(env["G"], "gpNeed")) + "，我哋三隻合共 "), J.gp(env["G"], "gpTeam")) + ("——唔夠喎，小心啲！打唔過就返村升級。" if J.cmp(J.gp(env["G"], "gpTeam"), J.gp(env["G"], "gpNeed"), "<") else "，夠晒膽！"))
		var _t2259 = J.gp(env["G"], "gh")
		_t2261 = (_t2260 + ("（有見習鬼）" if J.t(J.mc(_t2259, "some", [Callable(self, "_f354").bind(env)])) else ""))
	else:
		_t2261 = null
	J.sp(_t2258, "gpMsg", _t2261)

func _f355(this_, a: Array, env):
	var _t2262 = J.gp(env["G"], "gpMsg")
	if J.t((J.cmp(J.gp(env["G"], "t"), 5.6, ">=") if J.t(_t2262) else _t2262)):
		var _t2263 = env["toast"]
		J.cl(_t2263, null, [J.gp(env["G"], "gpMsg")])
		var _t2264 = env["G"]
		J.sp(_t2264, "gpMsg", null)

func _f356(this_, a: Array, env):
	var v_why_2307 = null; var v_o_2308 = null; var v_sv_2309 = null
	v_why_2307 = J.arg(a, 0)
	v_o_2308 = J.gp(env["G"], "over")
	var _t2265 = (not (not J.t(J.gp(env["G"], "gpHas"))))
	J.sp(v_o_2308, "gpHas", _t2265)
	var _t2266 = J.gp(env["G"], "gpNeed")
	J.sp(v_o_2308, "gpNeed", _t2266)
	var _t2267 = J.gp(env["G"], "gpTeam")
	J.sp(v_o_2308, "gpTeam", _t2267)
	var _t2268 = J.gp(env["G"], "gpTier")
	J.sp(v_o_2308, "gpTier", _t2268)
	var _t2269 = (not J.seq(v_why_2307, "fail"))
	if J.t((J.gp(env["G"], "gpHas") if _t2269 else _t2269)):
		var _t2270 = J.cl(env["gpSv"], null, [])
		v_sv_2309 = (_t2270 if J.t(_t2270) else {})
		var _t2271 = J.add("win_", env["curLv"])
		var _t2272 = J.gp(v_sv_2309, J.add("win_", env["curLv"]))
		var _t2273 = (J.num((_t2272 if J.t(_t2272) else 0.0)) + 1.0)
		J.sp(v_sv_2309, _t2271, _t2273)
		var _t2274 = env["gpSvPut"]
		J.cl(_t2274, null, [v_sv_2309])
		var _t2275 = env["gpTier"]
		var _t2276 = J.cmp(J.cl(_t2275, null, [env["curLv"]]), J.gp(env["G"], "gpTier"), ">")
		J.sp(v_o_2308, "gpUp", _t2276)

func _f357(this_, a: Array, env):
	var v_o_2312 = null; var v_need_2313 = null; var v_ok_2314 = null; var v_e_2315 = null; var v_e_2316 = null; var v_e_2317 = null
	v_o_2312 = (J.gp(env["G"], "over") if J.t(env["G"]) else env["G"])
	v_need_2313 = (J.gp(v_o_2312, "gpNeed") if J.t((J.cmp(J.gp(v_o_2312, "gpTeam"), J.gp(v_o_2312, "gpNeed"), "<") if J.t(v_o_2312) else v_o_2312)) else 0.0)
	J.cl(env["close"], null, [])
	if (not J.seq(J.typeof_(J.G.get("World")), "undefined")):
		J.mc(J.G.get("World"), "close", [])
	v_ok_2314 = false
	var _t2277 = (not J.seq(J.typeof_(J.G.get("UI")), "undefined"))
	if J.t((J.gp(J.G.get("UI"), "openRoster") if _t2277 else _t2277)):
		J.mc(J.G.get("UI"), "openRoster", [])
		v_ok_2314 = true
	J.mc(J.G.get("Fx"), "toast", [J.add(("" if J.t(v_ok_2314) else "返到村喇！"), (J.mc(J.G.get("GP"), "hint", [v_need_2313]) if J.t(J.gp(J.G.get("window"), "GP")) else "返村幫隻鬼升級再嚟過！"))])

func _f358(this_, a: Array, env):
	var v_x_2320 = null; var v_y_2321 = null; var v_w_2322 = null; var v_t_2323 = null; var v_bg_2324 = null; var v_fg_2325 = null
	v_x_2320 = J.arg(a, 0)
	v_y_2321 = J.arg(a, 1)
	v_w_2322 = J.arg(a, 2)
	v_t_2323 = J.arg(a, 3)
	v_bg_2324 = J.arg(a, 4)
	v_fg_2325 = J.arg(a, 5)
	J.mc(env["ctx"], "save", [])
	var _t2278 = env["ctx"]
	J.sp(_t2278, "fillStyle", v_bg_2324)
	var _t2279 = env["ctx"]
	J.sp(_t2279, "strokeStyle", "rgba(0,0,0,0.55)")
	var _t2280 = env["ctx"]
	J.sp(_t2280, "lineWidth", 1.5)
	J.mc(env["ctx"], "beginPath", [])
	if J.t(J.gp(env["ctx"], "roundRect")):
		J.mc(env["ctx"], "roundRect", [v_x_2320, v_y_2321, v_w_2322, 16.0, 8.0])
	else:
		J.mc(env["ctx"], "rect", [v_x_2320, v_y_2321, v_w_2322, 16.0])
	J.mc(env["ctx"], "fill", [])
	J.mc(env["ctx"], "stroke", [])
	J.mc(env["ctx"], "restore", [])
	var _t2281 = env["crText"]
	J.cl(_t2281, null, [env["ctx"], v_t_2323, J.add(v_x_2320, J.div(v_w_2322, 2.0)), J.add(v_y_2321, 12.5), 11.0, v_fg_2325, "center", J.sub(v_w_2322, 4.0)])

func _f359(this_, a: Array, env):
	var v_o_2328 = null; var v_x_2329 = null; var v_y_2330 = null
	v_o_2328 = J.arg(a, 0)
	v_x_2329 = J.arg(a, 1)
	v_y_2330 = J.arg(a, 2)
	if (not J.t(J.gp(env["G"], "gpHas"))):
		return null
	if J.t(J.gp(v_o_2328, "trainee")):
		var _t2282 = env["gpPill"]
		J.cl(_t2282, null, [J.add(v_x_2329, 8.0), J.sub(v_y_2330, 12.0), 48.0, "見習", "#7a2522", "#ffd9c8"])
	else:
		var _t2283 = env["gpPill"]
		J.cl(_t2283, null, [J.add(v_x_2329, 2.0), J.sub(v_y_2330, 12.0), 60.0, J.add("鬼力 ", J.gp(v_o_2328, "pow")), "#26331f", "#d8f0b8"])

func _f361(this_, a: Array, env):
	var v_d_2336 = null; var v_i_2337 = null; var v_r_2338 = null; var v_cx_2339 = null
	v_d_2336 = J.arg(a, 0)
	v_i_2337 = J.arg(a, 1)
	var _t2284 = env["__p"]["gpRead"]
	v_r_2338 = J.cl(_t2284, null, [v_d_2336])
	v_cx_2339 = (J.div(env["__p"]["VW"], 2.0) + (J.sub(v_i_2337, 1.0) * 100.0))
	var _t2285 = env["__p"]["crText"]
	J.cl(_t2285, null, [env["__p"]["ctx"], ("見習（未招募）" if J.t(J.gp(v_r_2338, "tr")) else J.add("鬼力 ", J.gp(v_r_2338, "pow"))), v_cx_2339, (J.mul(env["__p"]["VH"], 0.52) + 18.0), 13.0, ("#ff8a72" if J.t(J.gp(v_r_2338, "tr")) else "#c8e6a8"), "center", 96.0])

func _f362(this_, a: Array, env):
	var v_lv_2342 = null; var v_i_2343 = null; var v_need_2344 = null; var v_cx_2345 = null; var v_ok_2346 = null
	v_lv_2342 = J.arg(a, 0)
	v_i_2343 = J.arg(a, 1)
	var _t2288 = env["__p"]["gpNeed"]
	v_need_2344 = J.cl(_t2288, null, [v_lv_2342])
	v_cx_2345 = (((34.0 + J.div(J.sub(env["__p"]["VW"], 56.0), 2.0)) + J.div(J.sub(env["__p"]["VW"], 56.0), 4.0)) if J.t(v_i_2343) else (22.0 + J.div(J.sub(env["__p"]["VW"], 56.0), 4.0)))
	v_ok_2346 = J.cmp(env["team"], v_need_2344, ">=")
	var _t2289 = env["__p"]["crText"]
	J.cl(_t2289, null, [env["__p"]["ctx"], (J.add("建議鬼力 ", v_need_2344) + ("" if J.t(v_ok_2346) else "（唔夠）")), v_cx_2345, (J.mul(env["__p"]["VH"], 0.8) + 76.0), 13.0, ("#b2d394" if J.t(v_ok_2346) else "#ff6a5a"), "center", J.div(J.sub(env["__p"]["VW"], 56.0), 2.0)])

func _f360(this_, a: Array, env):
	var _s852 = {"__p": env, "team": null}
	if (not J.t(J.gp(J.G.get("window"), "GP"))):
		return null
	_s852["team"] = J.cl(_s852["__p"]["gpTeam"], null, [])
	J.mc(_s852["__p"]["GH"], "forEach", [Callable(self, "_f361").bind(_s852)])
	var _t2286 = _s852["__p"]["crText"]
	J.cl(_t2286, null, [_s852["__p"]["ctx"], J.add("三隻合共鬼力 ", _s852["team"]), J.div(_s852["__p"]["VW"], 2.0), (J.mul(_s852["__p"]["VH"], 0.52) + 40.0), 15.0, "#efe5cf", "center", J.sub(_s852["__p"]["VW"], 30.0)])
	var _t2287 = ["flat", "shop"]
	J.mc(_t2287, "forEach", [Callable(self, "_f362").bind(_s852)])

func _f363(this_, a: Array, env):
	var v_o_2349 = null; var v_y_2350 = null; var v_ok_2351 = null; var v_tx_2352 = null
	v_o_2349 = J.arg(a, 0)
	v_y_2350 = J.arg(a, 1)
	if (not J.t(J.gp(v_o_2349, "gpHas"))):
		return null
	v_ok_2351 = J.cmp(J.gp(v_o_2349, "gpTeam"), J.gp(v_o_2349, "gpNeed"), ">=")
	var _t2290 = env["ctx"]
	J.sp(_t2290, "textAlign", "center")
	var _t2291 = env["ctx"]
	var _t2292 = ("#d8f0b8" if J.t(v_ok_2351) else "#ff7a64")
	J.sp(_t2291, "fillStyle", _t2292)
	var _t2293 = env["ctx"]
	var _t2294 = J.add("bold 16px ", env["FONT"])
	J.sp(_t2293, "font", _t2294)
	var _t2295 = env["crFill"]
	J.cl(_t2295, null, [J.add((J.add("你嘅鬼力 ", J.gp(v_o_2349, "gpTeam")) + "／建議 "), J.gp(v_o_2349, "gpNeed")), J.div(env["VW"], 2.0), J.add(v_y_2350, 204.0), J.sub(env["VW"], 50.0)])
	var _t2296 = env["ctx"]
	J.sp(_t2296, "fillStyle", "#efdcb4")
	var _t2297 = env["ctx"]
	var _t2298 = J.add("bold 13px ", env["FONT"])
	J.sp(_t2297, "font", _t2298)
	var _t2299 = env["ctx"]
	J.sp(_t2299, "textAlign", "left")
	var _t2300 = J.gp(J.G.get("window"), "GP")
	v_tx_2352 = (J.mc(J.G.get("GP"), "hint", [(0.0 if J.t(v_ok_2351) else J.gp(v_o_2349, "gpNeed"))]) if J.t((J.gp(J.G.get("GP"), "hint") if J.t(_t2300) else _t2300)) else "")
	var _t2301 = env["wrap"]
	J.cl(_t2301, null, [v_tx_2352, 36.0, J.add(v_y_2350, 230.0), J.sub(env["VW"], 72.0), 18.0])
	var _t2302 = env["ctx"]
	J.sp(_t2302, "textAlign", "center")
	var _t2303 = env["btn"]
	J.cl(_t2303, null, ["toVillage", (J.div(env["VW"], 2.0) - 125.0), J.add(v_y_2350, 268.0), 250.0, 44.0, "返村升級", "#8a5a14"])

func _f365(this_, a: Array, env):
	var v_d_2359 = null; var v_i_2360 = null
	v_d_2359 = J.arg(a, 0)
	v_i_2360 = J.arg(a, 1)
	return {"d": v_d_2359, "i": v_i_2360, "node": "f0_e", "to": null, "p": 0.0, "x": 0.0, "y": 0.0, "dir": 1.0, "loot": 0.0, "taskP": 0.0, "inv": 0.0, "invCd": 0.0, "stun": 0.0, "scareCd": 0.0, "home": false, "energy": 0.0, "actT": 0.0, "hitT": 0.0, "bounceT": 0.0, "mv": 0.0, "ph": (randf() * 6.0), "still": 1.0, "caught": 0.0, "out": false, "mirrored": 0.0}

func _f366(this_, a: Array, env):
	var v_g_2363 = null; var v_n_2364 = null
	v_g_2363 = J.arg(a, 0)
	v_n_2364 = J.gp(J.gp(env["G"], "nodes"), J.gp(v_g_2363, "node"))
	var _t2311 = J.gp(v_n_2364, "x")
	J.sp(v_g_2363, "x", _t2311)
	var _t2312 = J.gp(v_n_2364, "y")
	J.sp(v_g_2363, "y", _t2312)

func _f364(this_, a: Array, env):
	var v_s_2355 = null; var v_lv_2356 = null
	v_s_2355 = J.arg(a, 0)
	v_lv_2356 = J.arg(a, 1)
	if J.t(v_lv_2356):
		env["curLv"] = v_lv_2356
	var _t2304 = (v_s_2355 if J.t(v_s_2355) else (J.mod(J.S_Date_("now", []), 100000.0) + 7.0))
	env["seed"] = _t2304
	var _t2305 = {}
	env["used"] = _t2305
	var _t2306 = env["useLevel"]
	J.cl(_t2306, null, [env["curLv"]])
	var _t2307 = {"t": 0.0, "phase": 0.0, "nodes": {}, "edges": [], "units": [], "res": [], "guards": [], "floats": [], "fear": 0.0, "fearNext": 30.0, "fearTotal": 0.0, "mods": {"spd": 1.0, "pow": 1.0, "inv": 3.0, "task": 1.0, "arm": 1.0, "fear": 1.0}, "story": [], "active": 0.0, "over": null, "choice": null, "toast": null, "toastT": 0.0, "alarm": [], "alert": 0.0, "alertLv": 0.0, "bag": [], "dolls": 0.0, "keys": {}, "wave": 0.0, "waveT": 20.0, "gate": null, "gateCharge": 0.0, "captured": 0.0}
	env["G"] = _t2307
	J.cl(env["buildMap2"], null, [])
	J.cl(env["placeUnits2"], null, [])
	var _t2308 = env["G"]
	var _t2309 = J.mc(env["GH"], "map", [Callable(self, "_f365").bind(env)])
	J.sp(_t2308, "gh", _t2309)
	var _t2310 = J.gp(env["G"], "gh")
	J.mc(_t2310, "forEach", [Callable(self, "_f366").bind(env)])
	J.cl(env["gpStart"], null, [])
	var _t2313 = env["cam"]
	J.sp(_t2313, "z", 1.0)
	var _t2314 = env["cam"]
	J.sp(_t2314, "free", null)
	var _t2315 = env["cam"]
	var _t2317 = env["VW"]
	var _t2316 = (J.gp(env["LV"], "camW") if J.t(env["LV"]) else env["LV"])
	var _t2318 = J.div(_t2317, (_t2316 if J.t(_t2316) else 600.0))
	J.sp(_t2315, "s", _t2318)
	var _t2319 = env["G"]
	var _t2320 = []
	J.sp(_t2319, "parts", _t2320)
	var _t2321 = env["G"]
	J.sp(_t2321, "ult", null)
	var _t2322 = env["G"]
	var _t2323 = []
	J.sp(_t2322, "wardFx", _t2323)
	var _t2324 = env["G"]
	var _t2325 = {}
	J.sp(_t2324, "dark", _t2325)
	J.cl(env["spawnZoneGuards"], null, [])
	J.cl(env["initSafe"], null, [])
	var _t2326 = env["G"]
	var _t2327 = []
	J.sp(_t2326, "pdrops", _t2327)
	env["scene"] = "play"
	env["paused"] = false
	var _t2328 = env["toast"]
	J.cl(_t2328, null, [(J.add(J.add(J.gp(env["LV"], "name"), "（"), J.sub(env["FL"], 1.0)) + " 層＋地庫＋天台）：鬆手企定先嚇得人、搜得嘢。保安唔係捉鬼師傅——附身電器、敲水管、叫𨋢可以引開佢哋。左上細地圖撳一下睇全棟。")])

func _f367(this_, a: Array, env):
	var v_id_2367 = null; var v_x_2368 = null; var v_y_2369 = null; var v_f_2370 = null; var v_kind_2371 = null
	v_id_2367 = J.arg(a, 0)
	v_x_2368 = J.arg(a, 1)
	v_y_2369 = J.arg(a, 2)
	v_f_2370 = J.arg(a, 3)
	v_kind_2371 = J.arg(a, 4)
	var _t2329 = J.gp(env["G"], "nodes")
	var _t2330 = {"id": v_id_2367, "x": v_x_2368, "y": v_y_2369, "f": v_f_2370, "kind": v_kind_2371, "links": []}
	J.sp(_t2329, v_id_2367, _t2330)

func _f368(this_, a: Array, env):
	var v_a_2374 = null; var v_b_2375 = null; var v_ward_2376 = null; var v_e_2377 = null
	v_a_2374 = J.arg(a, 0)
	v_b_2375 = J.arg(a, 1)
	v_ward_2376 = J.arg(a, 2)
	v_e_2377 = {"a": v_a_2374, "b": v_b_2375, "ward": (v_ward_2376 if J.t(v_ward_2376) else null)}
	var _t2331 = J.gp(env["G"], "edges")
	J.mc(_t2331, "push", [v_e_2377])
	var _t2332 = J.gp(J.gp(J.gp(env["G"], "nodes"), v_a_2374), "links")
	J.mc(_t2332, "push", [{"to": v_b_2375, "e": v_e_2377}])
	var _t2333 = J.gp(J.gp(J.gp(env["G"], "nodes"), v_b_2375), "links")
	J.mc(_t2333, "push", [{"to": v_a_2374, "e": v_e_2377}])
	return v_e_2377

func _f370(this_, a: Array, env):
	var v_L_2386 = null
	v_L_2386 = J.arg(a, 0)
	return J.seq(J.gp(v_L_2386, 0.0), env["f"])

func _f371(this_, a: Array, env):
	var v_L_2389 = null
	v_L_2389 = J.arg(a, 0)
	return {"x": J.gp(v_L_2389, 7.0), "u": J.gp(v_L_2389, 1.0)}

func _f372(this_, a: Array, env):
	var v_a_2392 = null; var v_b_2393 = null
	v_a_2392 = J.arg(a, 0)
	v_b_2393 = J.arg(a, 1)
	return J.sub(J.gp(v_a_2392, "x"), J.gp(v_b_2393, "x"))

func _f373(this_, a: Array, env):
	var v_st_2396 = null; var v_id_2397 = null; var v_e_2398 = null
	v_st_2396 = J.arg(a, 0)
	if J.t(J.gp(v_st_2396, "p")):
		v_id_2397 = "f0_e"
		var _t2339 = env["__p"]["node"]
		J.cl(_t2339, null, [v_id_2397, J.gp(v_st_2396, "x"), env["y"], 0.0, "portal"])
	else:
		var _t2340 = J.add((J.add("f", env["f"]) + "_d"), J.gp(v_st_2396, "u"))
		v_id_2397 = _t2340
		var _t2341 = env["__p"]["node"]
		J.cl(_t2341, null, [v_id_2397, J.gp(v_st_2396, "x"), env["y"], env["f"], "door"])
		var _t2342 = env["__p"]["node"]
		J.cl(_t2342, null, [J.add((J.add("f", env["f"]) + "_i"), J.gp(v_st_2396, "u")), J.sub(J.gp(v_st_2396, "x"), 14.0), J.sub(env["y"], 34.0), env["f"], "in"])
		var _t2343 = env["__p"]["link"]
		v_e_2398 = J.cl(_t2343, null, [v_id_2397, J.add((J.add("f", env["f"]) + "_i"), J.gp(v_st_2396, "u"))])
		J.sp(v_e_2398, "door", true)
	var _t2344 = env["__p"]["link"]
	J.cl(_t2344, null, [env["prev"], v_id_2397])
	env["prev"] = v_id_2397

func _f369(this_, a: Array, env):
	var v_stops_2382 = null
	var _s861 = {"__p": env, "f": null, "y": null, "prev": null}
	_s861["f"] = 0.0
	while true:
		if not J.cmp(_s861["f"], _s861["__p"]["FL"], "<="): break
		var _t2334 = _s861["__p"]["fy"]
		_s861["y"] = J.cl(_t2334, null, [_s861["f"]])
		var _t2335 = _s861["__p"]["node"]
		J.cl(_t2335, null, [(J.add("f", _s861["f"]) + "_s"), _s861["__p"]["SX"], _s861["y"], _s861["f"], "stair"])
		var _t2336 = _s861["__p"]["node"]
		J.cl(_t2336, null, [(J.add("f", _s861["f"]) + "_l"), (_s861["__p"]["GLX"] if J.seq(_s861["f"], 0.0) else _s861["__p"]["LX"]), _s861["y"], _s861["f"], "lift"])
		if J.cmp(_s861["f"], _s861["__p"]["FL"], "<"):
			var _t2337 = J.gp(_s861["__p"]["LV"], "units")
			var _t2338 = J.mc(_t2337, "filter", [Callable(self, "_f370").bind(_s861)])
			v_stops_2382 = J.mc(_t2338, "map", [Callable(self, "_f371").bind(_s861)])
			if J.seq(_s861["f"], 0.0):
				J.mc(v_stops_2382, "push", [{"x": _s861["__p"]["PX0"], "p": 1.0}])
			J.mc(v_stops_2382, "sort", [Callable(self, "_f372").bind(_s861)])
			_s861["prev"] = (J.add("f", _s861["f"]) + "_s")
			J.mc(v_stops_2382, "forEach", [Callable(self, "_f373").bind(_s861)])
			var _t2345 = _s861["__p"]["link"]
			J.cl(_t2345, null, [_s861["prev"], (J.add("f", _s861["f"]) + "_l")])
		else:
			var _t2346 = _s861["__p"]["node"]
			J.cl(_t2346, null, [(J.add("f", _s861["__p"]["FL"]) + "_p"), 300.0, _s861["y"], _s861["f"], "portal"])
			var _t2347 = _s861["__p"]["link"]
			J.cl(_t2347, null, [(J.add("f", _s861["__p"]["FL"]) + "_s"), (J.add("f", _s861["__p"]["FL"]) + "_p")])
			var _t2348 = _s861["__p"]["link"]
			J.cl(_t2348, null, [(J.add("f", _s861["__p"]["FL"]) + "_p"), (J.add("f", _s861["__p"]["FL"]) + "_l")])
		if J.cmp(_s861["f"], 0.0, ">"):
			var _t2349 = _s861["__p"]["link"]
			var _t2350 = J.cl(_t2349, null, [(J.add("f", J.sub(_s861["f"], 1.0)) + "_s"), (J.add("f", _s861["f"]) + "_s")])
			J.sp(_t2350, "vert", true)
			var _t2351 = _s861["__p"]["link"]
			var _t2352 = J.cl(_t2351, null, [(J.add("f", J.sub(_s861["f"], 1.0)) + "_l"), (J.add("f", _s861["f"]) + "_l")])
			J.sp(_t2352, "vert", true)
		_s861["f"] = J.num(_s861["f"]) + 1.0

func _f376(this_, a: Array, env):
	var v_l_2422 = null
	v_l_2422 = J.arg(a, 0)
	return J.seq(J.gp(v_l_2422, "to"), env["id"])

func _f375(this_, a: Array, env):
	var v_L_2409 = null; var v_f_2410 = null; var v_u_2411 = null; var v_w_2412 = null; var v_did_2414 = null; var v_e_2415 = null; var v_un_2416 = null; var v_cx_2417 = null; var v_rxp_2418 = null; var v_r_2419 = null
	var _s874 = {"__p": env, "id": null}
	v_L_2409 = J.arg(a, 0)
	v_f_2410 = J.gp(v_L_2409, 0.0)
	v_u_2411 = J.gp(v_L_2409, 1.0)
	v_w_2412 = J.gp(v_L_2409, 2.0)
	_s874["id"] = J.add((J.add("f", v_f_2410) + "_i"), v_u_2411)
	v_did_2414 = J.add((J.add("f", v_f_2410) + "_d"), v_u_2411)
	var _t2354 = J.gp(J.gp(J.gp(_s874["__p"]["__p"]["G"], "nodes"), v_did_2414), "links")
	v_e_2415 = J.gp(J.mc(_t2354, "find", [Callable(self, "_f376").bind(_s874)]), "e")
	J.sp(v_e_2415, "ward", v_w_2412)
	var _t2356 = _s874["id"]
	var _t2357 = J.gp(v_L_2409, 3.0)
	var _t2358 = J.cmp(J.gp(v_L_2409, 5.0), 0.0, ">=")
	var _t2359 = J.gp(v_L_2409, 5.0)
	var _t2360 = J.gp(v_L_2409, 6.0)
	var _t2361 = J.gp(J.gp(J.gp(_s874["__p"]["__p"]["G"], "nodes"), v_did_2414), "x")
	var _t2355 = _s874["__p"]["__p"]["fy"]
	v_un_2416 = {"f": v_f_2410, "u": v_u_2411, "id": _t2356, "did": v_did_2414, "ward": v_w_2412, "task": _t2357, "story": _t2358, "si": _t2359, "name": _t2360, "x": _t2361, "y": J.cl(_t2355, null, [v_f_2410]), "rx": J.gp(v_L_2409, 8.0), "lit": false, "litT": 0.0, "open": true, "ot": 0.0, "cost": 0.0, "paid": 0.0, "seen": false, "entered": false, "plus": (2.0 if J.cmp(J.gp(v_L_2409, 5.0), 0.0, ">=") else 1.0), "items": [], "door": false, "doorOpen": 0.0, "ambush": null, "dep": null, "keyNeed": null}
	var _t2362 = J.seq(v_w_2412, "fu")
	var _t2363 = (_t2362 if _t2362 else J.seq(v_w_2412, "menshen"))
	if (_t2363 if _t2363 else J.seq(v_w_2412, "datuk")):
		J.sp(v_un_2416, "open", false)
		J.sp(v_un_2416, "ot", "deity")
	else:
		if J.seq(v_w_2412, "zha"):
			J.sp(v_un_2416, "open", false)
			J.sp(v_un_2416, "ot", 2.0)
			var _t2364 = (8.0 if J.cmp(v_f_2410, 1.0, "<=") else 12.0)
			J.sp(v_un_2416, "cost", _t2364)
		else:
			if J.seq(v_w_2412, "nuomi"):
				J.sp(v_un_2416, "open", false)
				J.sp(v_un_2416, "ot", 2.0)
				var _t2365 = (6.0 if J.cmp(v_f_2410, 1.0, "<=") else 9.0)
				J.sp(v_un_2416, "cost", _t2365)
	if J.t(J.gp(v_L_2409, 3.0)):
		var _t2366 = J.gp(v_un_2416, "items")
		J.mc(_t2366, "push", [J.gp(v_L_2409, 3.0)])
	var _t2367 = J.seq(J.gp(v_L_2409, 3.0), "food")
	if (_t2367 if _t2367 else J.seq(J.gp(v_L_2409, 3.0), "money")):
		var _t2368 = J.gp(v_un_2416, "items")
		J.mc(_t2368, "push", [J.gp(v_L_2409, 3.0)])
	var _t2369 = J.gp(_s874["__p"]["__p"]["G"], "units")
	J.mc(_t2369, "push", [v_un_2416])
	J.sp(v_e_2415, "unit", v_un_2416)
	if J.t(J.gp(v_L_2409, 4.0)):
		v_cx_2417 = J.div(J.add(J.gp(J.gp(v_un_2416, "rx"), 0.0), J.gp(J.gp(v_un_2416, "rx"), 1.0)), 2.0)
		v_rxp_2418 = (J.sub(v_cx_2417, 34.0) if (absf(J.num(J.sub(v_cx_2417, J.gp(v_un_2416, "x")))) < 30.0) else v_cx_2417)
		var _t2371 = J.gp(v_L_2409, 4.0)
		var _t2370 = _s874["__p"]["__p"]["fy"]
		v_r_2419 = {"unit": v_un_2416, "sprite": _t2371, "x": v_rxp_2418, "y": J.sub(J.cl(_t2370, null, [v_f_2410]), 16.0), "fear": 0.0, "brave": 0.0, "state": "home", "vx": 0.0, "doorT": (8.0 + J.mul(J.cl(_s874["__p"]["__p"]["rnd"], null, []), 10.0))}
		var _t2372 = J.gp(_s874["__p"]["__p"]["G"], "res")
		J.mc(_t2372, "push", [v_r_2419])
		J.sp(v_un_2416, "res", v_r_2419)

func _f377(this_, a: Array, env):
	var v_u_2425 = null
	v_u_2425 = J.arg(a, 0)
	var _t2374 = J.gp(v_u_2425, "story")
	return (J.seq(J.gp(v_u_2425, "ot"), 0.0) if J.t(_t2374) else _t2374)

func _f378(this_, a: Array, env):
	var v_a_2428 = null; var v_b_2429 = null
	v_a_2428 = J.arg(a, 0)
	v_b_2429 = J.arg(a, 1)
	return J.sub(J.gp(v_b_2429, "f"), J.gp(v_a_2428, "f"))

func _f380(this_, a: Array, env):
	var v_v_2436 = null
	v_v_2436 = J.arg(a, 0)
	var _t2383 = J.seq(J.gp(v_v_2436, "f"), J.gp(env["u"], "f"))
	var _t2384 = ((not J.seq(v_v_2436, env["u"])) if _t2383 else _t2383)
	var _t2385 = (J.gp(v_v_2436, "res") if _t2384 else _t2384)
	return ((not J.seq(J.gp(v_v_2436, "ot"), "deity")) if J.t(_t2385) else _t2385)

func _f379(this_, a: Array, env):
	var v_nb_2433 = null
	var _s883 = {"__p": env, "u": null}
	_s883["u"] = J.arg(a, 0)
	var _t2380 = (not J.seq(J.gp(_s883["u"], "ot"), 0.0))
	var _t2381 = (_t2380 if _t2380 else J.seq(J.gp(_s883["u"], "f"), 0.0))
	if (_t2381 if _t2381 else J.seq(_s883["u"], _s883["__p"]["top"])):
		return null
	var _t2382 = J.gp(_s883["__p"]["__p"]["G"], "units")
	v_nb_2433 = J.gp(J.mc(_t2382, "filter", [Callable(self, "_f380").bind(_s883)]), 0.0)
	if J.t((J.gp(_s883["u"], "story") if J.t(v_nb_2433) else v_nb_2433)):
		var _t2386 = _s883["u"]
		J.sp(_t2386, "open", false)
		var _t2387 = _s883["u"]
		J.sp(_t2387, "ot", 1.0)
		var _t2388 = _s883["u"]
		J.sp(_t2388, "dep", v_nb_2433)

func _f381(this_, a: Array, env):
	var v_u_2439 = null
	v_u_2439 = J.arg(a, 0)
	var _t2390 = (not J.seq(J.gp(v_u_2439, "ot"), "deity"))
	return ((not J.seq(v_u_2439, env["keyUnit"])) if _t2390 else _t2390)

func _f382(this_, a: Array, env):
	var v_u_2442 = null
	v_u_2442 = J.arg(a, 0)
	var _t2394 = J.gp(v_u_2442, "items")
	J.mc(_t2394, "push", ["key"])

func _f383(this_, a: Array, env):
	var v_u_2445 = null
	v_u_2445 = J.arg(a, 0)
	if J.cmp(env["dolls"], 7.0, "<"):
		var _t2397 = J.gp(v_u_2445, "items")
		J.mc(_t2397, "push", ["doll"])
		env["dolls"] = J.num(env["dolls"]) + 1.0

func _f384(this_, a: Array, env):
	var v_u_2448 = null
	v_u_2448 = J.arg(a, 0)
	var _t2399 = J.gp(v_u_2448, "res")
	var _t2400 = (J.seq(J.gp(v_u_2448, "ot"), 0.0) if J.t(_t2399) else _t2399)
	return (J.cmp(J.gp(v_u_2448, "f"), 0.0, ">") if J.t(_t2400) else _t2400)

func _f385(this_, a: Array, env):
	var v_u_2451 = null
	v_u_2451 = J.arg(a, 0)
	var _t2403 = (not J.t(J.gp(v_u_2451, "res")))
	return ((not J.seq(J.gp(v_u_2451, "ot"), "deity")) if _t2403 else _t2403)

func _f386(this_, a: Array, env):
	var v_u_2454 = null
	v_u_2454 = J.arg(a, 0)
	return J.seq(J.gp(v_u_2454, "ot"), 2.0)

func _f387(this_, a: Array, env):
	var v_u_2457 = null
	v_u_2457 = J.arg(a, 0)
	var _t2407 = J.seq(J.gp(v_u_2457, "ot"), 0.0)
	var _t2408 = (_t2407 if _t2407 else J.seq(J.gp(v_u_2457, "ot"), "deity"))
	var _t2409 = ((not J.t(J.gp(v_u_2457, "ambush"))) if _t2408 else _t2408)
	J.sp(v_u_2457, "seen", _t2409)

func _f374(this_, a: Array, env):
	var v_cand_2403 = null; var v_dc_2405 = null; var v_amb_2406 = null
	var _s873 = {"__p": env, "keyUnit": null, "top": null, "dolls": null}
	_s873["keyUnit"] = null
	var _t2353 = J.gp(_s873["__p"]["LV"], "units")
	J.mc(_t2353, "forEach", [Callable(self, "_f375").bind(_s873)])
	var _t2373 = J.gp(_s873["__p"]["G"], "units")
	var _t2375 = J.mc(_t2373, "filter", [Callable(self, "_f377").bind(_s873)])
	_s873["top"] = J.gp(J.mc(_t2375, "sort", [Callable(self, "_f378").bind(_s873)]), 0.0)
	if J.t(_s873["top"]):
		var _t2376 = _s873["top"]
		J.sp(_t2376, "open", false)
		var _t2377 = _s873["top"]
		J.sp(_t2377, "ot", 11.0)
		var _t2378 = _s873["top"]
		J.sp(_t2378, "keyNeed", "key")
		_s873["keyUnit"] = _s873["top"]
	var _t2379 = J.gp(_s873["__p"]["G"], "units")
	J.mc(_t2379, "forEach", [Callable(self, "_f379").bind(_s873)])
	var _t2389 = J.gp(_s873["__p"]["G"], "units")
	v_cand_2403 = J.mc(_t2389, "filter", [Callable(self, "_f381").bind(_s873)])
	var _t2391 = _s873["__p"]["shuffle"]
	var _t2392 = J.cl(_t2391, null, [v_cand_2403])
	var _t2393 = J.mc(_t2392, "slice", [0.0, 1.0])
	J.mc(_t2393, "forEach", [Callable(self, "_f382").bind(_s873)])
	_s873["dolls"] = 0.0
	var _t2395 = _s873["__p"]["shuffle"]
	var _t2396 = J.cl(_t2395, null, [v_cand_2403])
	J.mc(_t2396, "forEach", [Callable(self, "_f383").bind(_s873)])
	var _t2398 = J.gp(_s873["__p"]["G"], "units")
	v_dc_2405 = J.mc(_t2398, "filter", [Callable(self, "_f384").bind(_s873)])
	if (J.len(v_dc_2405) >= 2.0):
		var _t2401 = J.gp(v_dc_2405, (J.len(v_dc_2405) - 1.0))
		J.sp(_t2401, "door", true)
	var _t2402 = J.gp(_s873["__p"]["G"], "units")
	var _t2405 = J.gp(J.mc(_t2402, "filter", [Callable(self, "_f385").bind(_s873)]), 0.0)
	if not J.t(_t2405):
		var _t2404 = J.gp(_s873["__p"]["G"], "units")
		_t2405 = J.gp(J.mc(_t2404, "filter", [Callable(self, "_f386").bind(_s873)]), 0.0)
	v_amb_2406 = _t2405
	if J.t(v_amb_2406):
		J.sp(v_amb_2406, "ambush", "dog")
	var _t2406 = J.gp(_s873["__p"]["G"], "units")
	J.mc(_t2406, "forEach", [Callable(self, "_f387").bind(_s873)])

func _f388(this_, a: Array, env):
	var v_did_2460 = null; var v_i_2461 = null
	v_did_2460 = J.arg(a, 0)
	v_i_2461 = 0.0
	while true:
		if not J.cmp(v_i_2461, J.len(J.gp(env["G"], "units")), "<"): break
		if J.seq(J.gp(J.gp(J.gp(env["G"], "units"), v_i_2461), "did"), v_did_2460):
			return J.gp(J.gp(env["G"], "units"), v_i_2461)
		v_i_2461 = J.num(v_i_2461) + 1.0
	return null

func _f389(this_, a: Array, env):
	var v_id_2464 = null; var v_i_2465 = null
	v_id_2464 = J.arg(a, 0)
	v_i_2465 = 0.0
	while true:
		if not J.cmp(v_i_2465, J.len(J.gp(env["G"], "units")), "<"): break
		if J.seq(J.gp(J.gp(J.gp(env["G"], "units"), v_i_2465), "id"), v_id_2464):
			return J.gp(J.gp(env["G"], "units"), v_i_2465)
		v_i_2465 = J.num(v_i_2465) + 1.0
	return null

func _f390(this_, a: Array, env):
	var v_kind_2468 = null; var v_nodeId_2469 = null; var v_extra_2470 = null; var v_n_2471 = null; var v_h_2472 = null; var v_k_2473 = null
	v_kind_2468 = J.arg(a, 0)
	v_nodeId_2469 = J.arg(a, 1)
	v_extra_2470 = J.arg(a, 2)
	v_n_2471 = J.gp(J.gp(env["G"], "nodes"), v_nodeId_2469)
	v_h_2472 = {"kind": v_kind_2468, "node": v_nodeId_2469, "to": null, "p": 0.0, "x": J.gp(v_n_2471, "x"), "y": J.gp(v_n_2471, "y"), "dir": 1.0, "wait": 1.0, "talkT": (3.0 + J.mul(J.cl(env["rnd"], null, []), 5.0)), "courage": (5.0 if J.seq(v_kind_2468, "compass") else (2.0 if J.seq(v_kind_2468, "decoy") else 1.0)), "path": null, "repath": 0.0, "chase": null, "alertT": 0.0, "state": "patrol"}
	for _t2410 in J.keys((v_extra_2470 if J.t(v_extra_2470) else {})):
		v_k_2473 = _t2410
		var _t2411 = J.gp(v_extra_2470, v_k_2473)
		J.sp(v_h_2472, v_k_2473, _t2411)
	return v_h_2472

func _f391(this_, a: Array, env):
	var v_nz_2476 = null; var v_span_2477 = null; var v_i_2478 = null; var v_a_2479 = null; var v_b_2480 = null; var v_h_2481 = null
	v_nz_2476 = J.max_([2.0, J.round(J.num(J.div(J.sub(env["FL"], 1.0), 3.0)))])
	v_span_2477 = J.div(J.sub(env["FL"], 1.0), v_nz_2476)
	v_i_2478 = 0.0
	while true:
		if not J.cmp(v_i_2478, v_nz_2476, "<"): break
		v_a_2479 = (1.0 + J.round(J.num(J.mul(v_i_2478, v_span_2477))))
		v_b_2480 = J.min_([J.sub(env["FL"], 1.0), J.round(J.num(J.mul(J.add(v_i_2478, 1.0), v_span_2477)))])
		var _t2412 = env["mkHuman"]
		v_h_2481 = J.cl(_t2412, null, ["guard", ((J.add("f", v_a_2479) + "_") + ("b" if J.t(J.mod(v_i_2478, 2.0)) else "s"))])
		var _t2413 = [v_a_2479, v_b_2480]
		J.sp(v_h_2481, "zone", _t2413)
		var _t2414 = J.gp(env["G"], "guards")
		J.mc(_t2414, "push", [v_h_2481])
		v_i_2478 = J.num(v_i_2478) + 1.0

func _f392(this_, a: Array, env):
	var v_h_2484 = null; var v_f_2485 = null; var v_pad_2486 = null
	v_h_2484 = J.arg(a, 0)
	v_f_2485 = J.arg(a, 1)
	v_pad_2486 = J.arg(a, 2)
	var _t2416 = (not J.t(J.gp(v_h_2484, "zone")))
	if not J.t(_t2416):
		var _t2415 = J.cmp(v_f_2485, J.sub(J.gp(J.gp(v_h_2484, "zone"), 0.0), (v_pad_2486 if J.t(v_pad_2486) else 0.0)), ">=")
		_t2416 = (J.cmp(v_f_2485, J.add(J.gp(J.gp(v_h_2484, "zone"), 1.0), (v_pad_2486 if J.t(v_pad_2486) else 0.0)), "<=") if _t2415 else _t2415)
	return _t2416

func _f393(this_, a: Array, env):
	var v_m_2489 = null
	v_m_2489 = J.arg(a, 0)
	var _t2417 = env["G"]
	J.sp(_t2417, "toast", v_m_2489)
	var _t2418 = env["G"]
	J.sp(_t2418, "toastT", 5.5)

func _f395(this_, a: Array, env):
	var v_f_2503 = null
	v_f_2503 = J.arg(a, 0)
	var _t2425 = J.seq(J.gp(v_f_2503, "t"), env["t"])
	var _t2426 = ((absf(J.num(J.sub(J.gp(v_f_2503, "x"), env["x"]))) < 260.0) if _t2425 else _t2425)
	return ((absf(J.num(J.sub(J.gp(v_f_2503, "y0"), env["y"]))) < 200.0) if _t2426 else _t2426)

func _f396(this_, a: Array, env):
	var v_f_2506 = null
	v_f_2506 = J.arg(a, 0)
	var _t2430 = (absf(J.num(J.sub(J.gp(v_f_2506, "x"), env["x"]))) < 120.0)
	return ((absf(J.num(J.sub(J.gp(v_f_2506, "y"), env["yy"]))) < 17.0) if _t2430 else _t2430)

func _f394(this_, a: Array, env):
	var v_c_2495 = null; var v_now_2496 = null; var v_fc_2497 = null; var v_L0_2498 = null; var v_k_2500 = null
	var _s905 = {"__p": env, "x": null, "y": null, "t": null, "yy": null}
	_s905["x"] = J.arg(a, 0)
	_s905["y"] = J.arg(a, 1)
	_s905["t"] = J.arg(a, 2)
	v_c_2495 = J.arg(a, 3)
	if (not J.t(_s905["__p"]["G"])):
		return null
	v_now_2496 = J.S_performance_("now", [])
	var _t2421 = J.gp(_s905["__p"]["G"], "fcd")
	if not J.t(_t2421):
		var _t2419 = _s905["__p"]["G"]
		var _t2420 = {}
		J.sp(_t2419, "fcd", _t2420)
		_t2421 = _t2420
	v_fc_2497 = _t2421
	v_L0_2498 = J.gp(v_fc_2497, _s905["t"])
	var _t2422 = ((J.sub(v_now_2496, J.gp(v_L0_2498, "t")) < 1500.0) if J.t(v_L0_2498) else v_L0_2498)
	var _t2423 = ((absf(J.num(J.sub(J.gp(v_L0_2498, "x"), _s905["x"]))) < 260.0) if J.t(_t2422) else _t2422)
	if J.t(((absf(J.num(J.sub(J.gp(v_L0_2498, "y"), _s905["y"]))) < 200.0) if J.t(_t2423) else _t2423)):
		return null
	var _t2424 = J.gp(_s905["__p"]["G"], "floats")
	if J.t(J.mc(_t2424, "some", [Callable(self, "_f395").bind(_s905)])):
		return null
	var _t2427 = _s905["t"]
	var _t2428 = {"t": v_now_2496, "x": _s905["x"], "y": _s905["y"]}
	J.sp(v_fc_2497, _t2427, _t2428)
	_s905["yy"] = _s905["y"]
	v_k_2500 = 0.0
	while true:
		var _t2431 = J.cmp(v_k_2500, 4.0, "<")
		if J.t(_t2431):
			var _t2429 = J.gp(_s905["__p"]["G"], "floats")
			_t2431 = J.mc(_t2429, "some", [Callable(self, "_f396").bind(_s905)])
		if not J.t(_t2431): break
		var _t2432 = J.sub(_s905["yy"], 18.0)
		_s905["yy"] = _t2432
		v_k_2500 = J.num(v_k_2500) + 1.0
	var _t2433 = J.gp(_s905["__p"]["G"], "floats")
	J.mc(_t2433, "push", [{"x": _s905["x"], "y": _s905["yy"], "y0": _s905["y"], "t": _s905["t"], "c": (v_c_2495 if J.t(v_c_2495) else "#fff"), "life": 1.6}])
	if (J.len(J.gp(_s905["__p"]["G"], "floats")) > 10.0):
		J.mc(J.gp(_s905["__p"]["G"], "floats"), "shift", [])

func _f397(this_, a: Array, env):
	var v_g_2509 = null; var v_e_2510 = null
	v_g_2509 = J.arg(a, 0)
	v_e_2510 = J.arg(a, 1)
	var _t2434 = J.gp(v_e_2510, "ward")
	return (J.gp(J.gp(J.gp(v_g_2509, "d"), "cross"), J.gp(v_e_2510, "ward")) if J.t(_t2434) else _t2434)

func _f398(this_, a: Array, env):
	var v_g_2513 = null; var v_e_2514 = null; var v_un_2515 = null
	v_g_2513 = J.arg(a, 0)
	v_e_2514 = J.arg(a, 1)
	var _t2435 = J.gp(env["G"], "gate")
	var _t2437 = (J.gp(v_e_2514, "vert") if J.t(_t2435) else _t2435)
	if J.t(_t2437):
		var _t2436 = J.seq(J.gp(J.gp(J.gp(env["G"], "nodes"), J.gp(v_e_2514, "a")), "f"), J.gp(J.gp(env["G"], "gate"), "f"))
		_t2437 = (_t2436 if _t2436 else J.seq(J.gp(J.gp(J.gp(env["G"], "nodes"), J.gp(v_e_2514, "b")), "f"), J.gp(J.gp(env["G"], "gate"), "f")))
	if J.t(_t2437):
		return "stairSeal"
	if (not J.t(J.gp(v_e_2514, "door"))):
		return true
	v_un_2515 = J.gp(v_e_2514, "unit")
	if J.seq(J.gp(v_un_2515, "ot"), "deity"):
		return "deity"
	var _t2439 = (not J.t(J.gp(v_un_2515, "open")))
	if J.t(_t2439):
		var _t2438 = env["shortcut"]
		_t2439 = (not J.t(J.cl(_t2438, null, [v_g_2513, v_e_2514])))
	if _t2439:
		return ("breach" if J.seq(J.gp(v_un_2515, "ot"), 2.0) else ("key" if J.seq(J.gp(v_un_2515, "ot"), 11.0) else "chain"))
	var _t2440 = J.gp(v_un_2515, "door")
	var _t2442 = (J.cmp(J.gp(v_un_2515, "doorOpen"), 0.0, "<=") if J.t(_t2440) else _t2440)
	if J.t(_t2442):
		var _t2441 = env["shortcut"]
		_t2442 = (not J.t(J.cl(_t2441, null, [v_g_2513, v_e_2514])))
	if J.t(_t2442):
		return "door"
	return true

func _f399(this_, a: Array, env):
	var v_h_2518 = null; var v_e_2519 = null
	v_h_2518 = J.arg(a, 0)
	v_e_2519 = J.arg(a, 1)
	if J.t(J.gp(v_e_2519, "pipe")):
		return false
	var _t2443 = J.gp(v_e_2519, "fire")
	if J.t((J.cmp(J.gp(J.gp(v_e_2519, "fire"), "shut"), 0.0, ">") if J.t(_t2443) else _t2443)):
		return false
	var _t2444 = J.seq(J.gp(v_h_2518, "kind"), "dog")
	var _t2445 = (J.gp(v_e_2519, "door") if _t2444 else _t2444)
	var _t2446 = (J.gp(J.gp(v_e_2519, "unit"), "door") if J.t(_t2445) else _t2445)
	if J.t((J.cmp(J.gp(J.gp(v_e_2519, "unit"), "doorOpen"), 0.0, "<=") if J.t(_t2446) else _t2446)):
		return false
	var _t2447 = J.gp(v_e_2519, "door")
	if J.t((J.seq(J.gp(J.gp(v_e_2519, "unit"), "ot"), "deity") if J.t(_t2447) else _t2447)):
		return false
	return true

func _f401(this_, a: Array, env):
	var v_l_2542 = null; var v_m_2543 = null; var v_dx_2544 = null; var v_dy_2545 = null; var v_D_2546 = null; var v_dot_2547 = null
	v_l_2542 = J.arg(a, 0)
	v_m_2543 = J.gp(J.gp(env["__p"]["G"], "nodes"), J.gp(v_l_2542, "to"))
	v_dx_2544 = J.sub(J.gp(v_m_2543, "x"), J.gp(env["n"], "x"))
	v_dy_2545 = J.sub(J.gp(v_m_2543, "y"), J.gp(env["n"], "y"))
	v_D_2546 = J.hypot_([v_dx_2544, v_dy_2545])
	v_dot_2547 = J.div((J.mul(v_dx_2544, env["jx"]) + J.mul(v_dy_2545, env["jy"])), v_D_2546)
	if (absf(J.num(v_dy_2545)) > absf(J.num(v_dx_2544))):
		var _t2459 = J.add(v_dot_2547, 0.12)
		v_dot_2547 = _t2459
	if J.cmp(v_dot_2547, env["bd"], ">"):
		env["bd"] = v_dot_2547
		env["best"] = v_l_2542

func _f400(this_, a: Array, env):
	var v_g_2522 = null; var v_dt_2525 = null; var v_L_2526 = null; var v_mt_2527 = null; var v_sp_2528 = null; var v_ok_2532 = null; var v_a_2533 = null; var v_b_2534 = null; var v_dx_2535 = null; var v_dy_2536 = null; var v_D_2537 = null; var v_dot_2538 = null; var v_t_2539 = null
	var _s912 = {"__p": env, "jx": null, "jy": null, "n": null, "best": null, "bd": null}
	v_g_2522 = J.arg(a, 0)
	_s912["jx"] = J.arg(a, 1)
	_s912["jy"] = J.arg(a, 2)
	v_dt_2525 = J.arg(a, 3)
	var _t2448 = J.cmp(J.gp(v_g_2522, "stun"), 0.0, ">")
	var _t2449 = (_t2448 if _t2448 else J.gp(v_g_2522, "home"))
	if J.t((_t2449 if J.t(_t2449) else J.gp(v_g_2522, "out"))):
		return null
	v_L_2526 = J.hypot_([_s912["jx"], _s912["jy"]])
	if J.cmp(v_L_2526, 0.25, "<"):
		return null
	var _t2450 = J.div(_s912["jx"], v_L_2526)
	_s912["jx"] = _t2450
	var _t2451 = J.div(_s912["jy"], v_L_2526)
	_s912["jy"] = _t2451
	var _t2452 = _s912["__p"]["mirrorOn"]
	v_mt_2527 = J.cl(_t2452, null, [v_g_2522])
	var _t2453 = (J.seq(signf(J.num(J.sub(J.gp(v_mt_2527, "x"), J.gp(v_g_2522, "x")))), signf(J.num(_s912["jx"]))) if J.t(v_mt_2527) else v_mt_2527)
	if J.t(((absf(J.num(_s912["jx"])) > 0.3) if J.t(_t2453) else _t2453)):
		var _t2454 = (not J.t(J.gp(v_g_2522, "blockT")))
		if (_t2454 if _t2454 else J.cmp(J.gp(v_g_2522, "blockT"), 0.0, "<=")):
			var _t2455 = _s912["__p"]["float"]
			J.cl(_t2455, null, [J.gp(v_g_2522, "x"), J.sub(J.gp(v_g_2522, "y"), 80.0), "被鏡照住！轉身先走得", "#ffe9a0"])
			J.sp(v_g_2522, "blockT", 1.0)
		return null
	var _t2457 = J.mul(J.gp(J.gp(v_g_2522, "d"), "sp"), J.gp(J.gp(_s912["__p"]["G"], "mods"), "spd"))
	var _t2456 = J.gp(v_g_2522, "spm")
	v_sp_2528 = J.mul(_t2457, (_t2456 if J.t(_t2456) else 1.0))
	if (not J.t(J.gp(v_g_2522, "to"))):
		_s912["n"] = J.gp(J.gp(_s912["__p"]["G"], "nodes"), J.gp(v_g_2522, "node"))
		_s912["best"] = null
		_s912["bd"] = 0.55
		var _t2458 = J.gp(_s912["n"], "links")
		J.mc(_t2458, "forEach", [Callable(self, "_f401").bind(_s912)])
		if (not J.t(_s912["best"])):
			return null
		var _t2460 = _s912["__p"]["canPass"]
		v_ok_2532 = J.cl(_t2460, null, [v_g_2522, J.gp(_s912["best"], "e")])
		if (not J.seq(v_ok_2532, true)):
			var _t2461 = (not J.t(J.gp(v_g_2522, "blockT")))
			if (_t2461 if _t2461 else J.cmp(J.gp(v_g_2522, "blockT"), 0.0, "<=")):
				var _t2462 = _s912["__p"]["float"]
				J.cl(_t2462, null, [J.gp(_s912["n"], "x"), J.sub(J.gp(_s912["n"], "y"), 80.0), J.gp(_s912["__p"]["BLOCKMSG"], v_ok_2532), "#ffd54a"])
				J.sp(v_g_2522, "blockT", 1.4)
				J.sp(v_g_2522, "bounceT", 0.45)
				if J.seq(v_ok_2532, "deity"):
					var _t2463 = J.gp(_s912["__p"]["G"], "wardFx")
					J.mc(_t2463, "push", [{"x": J.gp(_s912["n"], "x"), "y": J.gp(_s912["n"], "y"), "t": 0.9}])
			return null
		var _t2464 = J.gp(_s912["best"], "to")
		J.sp(v_g_2522, "to", _t2464)
		J.sp(v_g_2522, "p", 0.0)
	v_a_2533 = J.gp(J.gp(_s912["__p"]["G"], "nodes"), J.gp(v_g_2522, "node"))
	v_b_2534 = J.gp(J.gp(_s912["__p"]["G"], "nodes"), J.gp(v_g_2522, "to"))
	v_dx_2535 = J.sub(J.gp(v_b_2534, "x"), J.gp(v_a_2533, "x"))
	v_dy_2536 = J.sub(J.gp(v_b_2534, "y"), J.gp(v_a_2533, "y"))
	v_D_2537 = J.hypot_([v_dx_2535, v_dy_2536])
	v_dot_2538 = J.div((J.mul(v_dx_2535, _s912["jx"]) + J.mul(v_dy_2536, _s912["jy"])), v_D_2537)
	if J.cmp(v_dot_2538, (-0.3), "<"):
		v_t_2539 = J.gp(v_g_2522, "node")
		var _t2465 = J.gp(v_g_2522, "to")
		J.sp(v_g_2522, "node", _t2465)
		J.sp(v_g_2522, "to", v_t_2539)
		var _t2466 = J.sub(1.0, J.gp(v_g_2522, "p"))
		J.sp(v_g_2522, "p", _t2466)
		return null
	var _t2467 = J.add(J.gp(v_g_2522, "p"), J.div(J.mul(v_sp_2528, v_dt_2525), v_D_2537))
	J.sp(v_g_2522, "p", _t2467)
	if J.t(v_dx_2535):
		var _t2468 = (1.0 if J.cmp(v_dx_2535, 0.0, ">") else (-1.0))
		J.sp(v_g_2522, "dir", _t2468)
	J.sp(v_g_2522, "still", 0.0)
	J.sp(v_g_2522, "taskP", 0.0)
	if J.cmp(J.gp(v_g_2522, "p"), 1.0, ">="):
		var _t2469 = J.gp(v_g_2522, "to")
		J.sp(v_g_2522, "node", _t2469)
		J.sp(v_g_2522, "to", null)
		J.sp(v_g_2522, "p", 0.0)
		var _t2470 = _s912["__p"]["onArrive"]
		J.cl(_t2470, null, [v_g_2522])

func _f402(this_, a: Array, env):
	var v_o_2550 = null; var v_a_2551 = null; var v_b_2552 = null
	v_o_2550 = J.arg(a, 0)
	v_a_2551 = J.gp(J.gp(env["G"], "nodes"), J.gp(v_o_2550, "node"))
	if (not J.t(J.gp(v_o_2550, "to"))):
		return {"x": J.gp(v_a_2551, "x"), "y": J.gp(v_a_2551, "y")}
	v_b_2552 = J.gp(J.gp(env["G"], "nodes"), J.gp(v_o_2550, "to"))
	return {"x": J.add(J.gp(v_a_2551, "x"), J.mul(J.sub(J.gp(v_b_2552, "x"), J.gp(v_a_2551, "x")), J.gp(v_o_2550, "p"))), "y": J.add(J.gp(v_a_2551, "y"), J.mul(J.sub(J.gp(v_b_2552, "y"), J.gp(v_a_2551, "y")), J.gp(v_o_2550, "p")))}

func _f403(this_, a: Array, env):
	var v_g_2555 = null; var v_n_2556 = null; var v_un_2557 = null; var v_d_2558 = null
	v_g_2555 = J.arg(a, 0)
	v_n_2556 = J.gp(J.gp(env["G"], "nodes"), J.gp(v_g_2555, "node"))
	if J.seq(J.gp(v_n_2556, "kind"), "in"):
		var _t2471 = env["unitOf"]
		v_un_2557 = J.cl(_t2471, null, [J.gp(v_n_2556, "id")])
		if (not J.t(J.gp(v_un_2557, "entered"))):
			J.sp(v_un_2557, "entered", true)
			J.sp(v_un_2557, "seen", true)
			var _t2472 = env["G"]
			var _t2473 = J.add(J.gp(_t2472, "alert"), J.gp(v_un_2557, "plus"))
			J.sp(_t2472, "alert", _t2473)
			var _t2474 = env["float"]
			J.cl(_t2474, null, [J.gp(v_n_2556, "x"), J.sub(J.gp(v_n_2556, "y"), 90.0), J.add("全樓警覺 +", J.gp(v_un_2557, "plus")), "#ff9a9a"])
			J.cl(env["checkAlert"], null, [])
			if J.seq(J.gp(v_un_2557, "ambush"), "dog"):
				J.sp(v_un_2557, "ambush", null)
				var _t2475 = env["mkHuman"]
				v_d_2558 = J.cl(_t2475, null, ["dog", J.gp(v_un_2557, "did"), {"state": "chase"}])
				J.sp(v_d_2558, "alertT", 1.4)
				var _t2476 = J.gp(env["G"], "guards")
				J.mc(_t2476, "push", [v_d_2558])
				var _t2477 = env["G"]
				J.sp(_t2477, "shake", 0.4)
				var _t2478 = env["float"]
				J.cl(_t2478, null, [J.gp(v_n_2556, "x"), J.sub(J.gp(v_n_2556, "y"), 110.0), "黑屋有隻狗醒咗！", "#ffb0b0"])
				var _t2479 = env["G"]
				var _t2480 = J.add(J.gp(_t2479, "alert"), 1.0)
				J.sp(_t2479, "alert", _t2480)
	var _t2481 = J.seq(J.gp(v_n_2556, "kind"), "portal")
	if (J.seq(J.gp(v_g_2555, "i"), J.gp(env["G"], "active")) if _t2481 else _t2481):
		var _t2482 = env["float"]
		J.cl(_t2482, null, [J.gp(v_n_2556, "x"), J.sub(J.gp(v_n_2556, "y"), 70.0), "陰門：企定按「開陰門」", "#9fd6bf"])
	if J.t((J.seq(J.gp(v_n_2556, "kind"), "in") if J.t(env["UNIT"]) else env["UNIT"])):
		J.mc(env["UNIT"], "arrive", [v_g_2555, v_n_2556])

func _f405(this_, a: Array, env):
	var v_l_2570 = null
	v_l_2570 = J.arg(a, 0)
	var _t2487 = (not J.t(J.gp(env["seen"], J.gp(v_l_2570, "to"))))
	if J.t(_t2487):
		var _t2486 = env["__p"]["canPass"]
		_t2487 = J.seq(J.cl(_t2486, null, [env["g"], J.gp(v_l_2570, "e")]), true)
	if _t2487:
		var _t2488 = env["seen"]
		var _t2489 = J.gp(v_l_2570, "to")
		J.sp(_t2488, _t2489, 1.0)
		var _t2490 = env["prev"]
		var _t2491 = J.gp(v_l_2570, "to")
		var _t2492 = env["c"]
		J.sp(_t2490, _t2491, _t2492)
		J.mc(env["q"], "push", [J.gp(v_l_2570, "to")])

func _f404(this_, a: Array, env):
	var v_target_2562 = null; var v_path_2567 = null
	var _s927 = {"__p": env, "g": null, "prev": null, "q": null, "seen": null, "c": null}
	_s927["g"] = J.arg(a, 0)
	v_target_2562 = J.arg(a, 1)
	_s927["prev"] = {}
	_s927["q"] = [J.gp(_s927["g"], "node")]
	_s927["seen"] = {}
	var _t2483 = _s927["seen"]
	var _t2484 = J.gp(_s927["g"], "node")
	J.sp(_t2483, _t2484, 1.0)
	while true:
		if not J.t(J.len(_s927["q"])): break
		_s927["c"] = J.mc(_s927["q"], "shift", [])
		if J.seq(_s927["c"], v_target_2562):
			break
		var _t2485 = J.gp(J.gp(J.gp(_s927["__p"]["G"], "nodes"), _s927["c"]), "links")
		J.mc(_t2485, "forEach", [Callable(self, "_f405").bind(_s927)])
	if (not J.t(J.gp(_s927["seen"], v_target_2562))):
		return false
	v_path_2567 = [v_target_2562]
	while true:
		if not (not J.seq(J.gp(v_path_2567, 0.0), J.gp(_s927["g"], "node"))): break
		J.mc(v_path_2567, "unshift", [J.gp(_s927["prev"], J.gp(v_path_2567, 0.0))])
	var _t2493 = _s927["g"]
	var _t2494 = J.mc(v_path_2567, "slice", [1.0])
	J.sp(_t2493, "auto", _t2494)
	return true

func _f407(this_, a: Array, env):
	var v_k_2585 = null
	v_k_2585 = J.arg(a, 0)
	var _t2495 = env["dist"]
	J.sp(_t2495, v_k_2585, 1000000000.0)

func _f408(this_, a: Array, env):
	var v_l_2588 = null; var v_a_2589 = null; var v_b_2590 = null; var v_w_2591 = null
	v_l_2588 = J.arg(a, 0)
	var _t2500 = env["__p"]["humanPass"]
	if (not J.t(J.cl(_t2500, null, [env["h"], J.gp(v_l_2588, "e")]))):
		return null
	var _t2501 = env["__p"]["safeNode"]
	var _t2503 = J.cl(_t2501, null, [J.gp(v_l_2588, "to")])
	if J.t(_t2503):
		var _t2502 = env["__p"]["safeNode"]
		_t2503 = (not J.t(J.cl(_t2502, null, [env["src"]])))
	if J.t(_t2503):
		return null
	v_a_2589 = J.gp(J.gp(env["__p"]["G"], "nodes"), env["u"])
	v_b_2590 = J.gp(J.gp(env["__p"]["G"], "nodes"), J.gp(v_l_2588, "to"))
	v_w_2591 = J.hypot_([J.sub(J.gp(v_a_2589, "x"), J.gp(v_b_2590, "x")), J.sub(J.gp(v_a_2589, "y"), J.gp(v_b_2590, "y"))])
	if J.cmp(J.add(J.gp(env["dist"], env["u"]), v_w_2591), J.gp(env["dist"], J.gp(v_l_2588, "to")), "<"):
		var _t2504 = env["dist"]
		var _t2505 = J.gp(v_l_2588, "to")
		var _t2506 = J.add(J.gp(env["dist"], env["u"]), v_w_2591)
		J.sp(_t2504, _t2505, _t2506)
		var _t2507 = env["prev"]
		var _t2508 = J.gp(v_l_2588, "to")
		var _t2509 = env["u"]
		J.sp(_t2507, _t2508, _t2509)

func _f406(this_, a: Array, env):
	var v_dst_2575 = null; var v_Q_2578 = null; var v_bi_2579 = null; var v_i_2580 = null; var v_p_2582 = null
	var _s931 = {"__p": env, "h": null, "src": null, "dist": null, "prev": null, "u": null}
	_s931["h"] = J.arg(a, 0)
	_s931["src"] = J.arg(a, 1)
	v_dst_2575 = J.arg(a, 2)
	_s931["dist"] = {}
	_s931["prev"] = {}
	v_Q_2578 = J.S_Object_("keys", [J.gp(_s931["__p"]["G"], "nodes")])
	J.mc(v_Q_2578, "forEach", [Callable(self, "_f407").bind(_s931)])
	var _t2496 = _s931["dist"]
	var _t2497 = _s931["src"]
	J.sp(_t2496, _t2497, 0.0)
	while true:
		if not J.t(J.len(v_Q_2578)): break
		v_bi_2579 = 0.0
		v_i_2580 = 1.0
		while true:
			if not J.cmp(v_i_2580, J.len(v_Q_2578), "<"): break
			if J.cmp(J.gp(_s931["dist"], J.gp(v_Q_2578, v_i_2580)), J.gp(_s931["dist"], J.gp(v_Q_2578, v_bi_2579)), "<"):
				v_bi_2579 = v_i_2580
			v_i_2580 = J.num(v_i_2580) + 1.0
		_s931["u"] = J.gp(J.mc(v_Q_2578, "splice", [v_bi_2579, 1.0]), 0.0)
		var _t2498 = J.seq(_s931["u"], v_dst_2575)
		if (_t2498 if _t2498 else J.cmp(J.gp(_s931["dist"], _s931["u"]), 1000000000.0, ">=")):
			break
		var _t2499 = J.gp(J.gp(J.gp(_s931["__p"]["G"], "nodes"), _s931["u"]), "links")
		J.mc(_t2499, "forEach", [Callable(self, "_f408").bind(_s931)])
	if J.cmp(J.gp(_s931["dist"], v_dst_2575), 1000000000.0, ">="):
		return null
	v_p_2582 = [v_dst_2575]
	while true:
		if not (not J.seq(J.gp(v_p_2582, 0.0), _s931["src"])): break
		J.mc(v_p_2582, "unshift", [J.gp(_s931["prev"], J.gp(v_p_2582, 0.0))])
	return J.mc(v_p_2582, "slice", [1.0])

func _f410(this_, a: Array, env):
	var v_l_2600 = null
	v_l_2600 = J.arg(a, 0)
	return J.seq(J.gp(v_l_2600, "to"), J.gp(env["b"], "id"))

func _f409(this_, a: Array, env):
	var v_h_2594 = null; var v_a_2595 = null; var v_l_2597 = null
	var _s937 = {"__p": env, "b": null}
	v_h_2594 = J.arg(a, 0)
	v_a_2595 = J.arg(a, 1)
	_s937["b"] = J.arg(a, 2)
	var _t2510 = J.gp(v_a_2595, "links")
	v_l_2597 = J.mc(_t2510, "find", [Callable(self, "_f410").bind(_s937)])
	var _t2512 = (not J.t(v_l_2597))
	if not J.t(_t2512):
		var _t2511 = _s937["__p"]["humanPass"]
		_t2512 = J.cl(_t2511, null, [v_h_2594, J.gp(v_l_2597, "e")])
	return _t2512

func _f411(this_, a: Array, env):
	var v_o_2603 = null; var v_best_2604 = null; var v_bd_2605 = null; var v_k_2606 = null; var v_n_2607 = null; var v_d_2608 = null
	v_o_2603 = J.arg(a, 0)
	v_best_2604 = null
	v_bd_2605 = 1000000000.0
	for _t2513 in J.keys(J.gp(env["G"], "nodes")):
		v_k_2606 = _t2513
		v_n_2607 = J.gp(J.gp(env["G"], "nodes"), v_k_2606)
		if J.seq(J.gp(v_n_2607, "kind"), "in"):
			continue
		v_d_2608 = (absf(J.num(J.sub(J.gp(v_n_2607, "x"), J.gp(v_o_2603, "x")))) + (absf(J.num(J.sub(J.gp(v_n_2607, "y"), J.gp(v_o_2603, "y")))) * 3.0))
		if J.cmp(v_d_2608, v_bd_2605, "<"):
			v_bd_2605 = v_d_2608
			v_best_2604 = v_k_2606
	return v_best_2604

func _f413(this_, a: Array, env):
	var v_h_2615 = null; var v_dx_2616 = null
	v_h_2615 = J.arg(a, 0)
	var _t2516 = (not J.seq(J.gp(v_h_2615, "kind"), "mirror"))
	if (_t2516 if _t2516 else J.seq(J.gp(v_h_2615, "state"), "gone")):
		return null
	if (absf(J.num(J.sub(J.gp(v_h_2615, "y"), J.gp(env["g"], "y")))) > 40.0):
		return null
	v_dx_2616 = J.sub(J.gp(env["g"], "x"), J.gp(v_h_2615, "x"))
	if (absf(J.num(v_dx_2616)) > 220.0):
		return null
	var _t2517 = J.seq(signf(J.num(v_dx_2616)), J.gp(v_h_2615, "dir"))
	if (J.seq(J.gp(env["g"], "dir"), (-J.num(J.gp(v_h_2615, "dir")))) if _t2517 else _t2517):
		env["m"] = v_h_2615

func _f412(this_, a: Array, env):
	var _s943 = {"__p": env, "g": null, "m": null}
	_s943["g"] = J.arg(a, 0)
	var _t2514 = _s943["__p"]["inSafe"]
	if J.t(J.cl(_t2514, null, [_s943["g"]])):
		return null
	_s943["m"] = null
	var _t2515 = J.gp(_s943["__p"]["G"], "guards")
	J.mc(_t2515, "forEach", [Callable(self, "_f413").bind(_s943)])
	return _s943["m"]

func _f416(this_, a: Array, env):
	var v_l_2640 = null
	v_l_2640 = J.arg(a, 0)
	return J.seq(J.gp(v_l_2640, "to"), env["nx"])

func _f417(this_, a: Array, env):
	var v_k_2643 = null; var v_I_2644 = null
	v_k_2643 = J.arg(a, 0)
	v_I_2644 = J.gp(env["__p"]["__p"]["ITEM"], v_k_2643)
	var _t2638 = (not J.t(J.gp(v_I_2644, "who")))
	return (_t2638 if _t2638 else J.seq(J.gp(v_I_2644, "who"), J.gp(J.gp(env["g"], "d"), "key")))

func _f415(this_, a: Array, env):
	var v_ln_2627 = null; var v_a_2628 = null; var v_b_2629 = null; var v_D_2630 = null; var v_p_2631 = null; var v_n_2632 = null; var v_st_2633 = null; var v_un_2634 = null; var v_it_2635 = null; var v_pn_2636 = null; var v_du_2637 = null
	var _s952 = {"__p": env, "g": null, "nx": null}
	_s952["g"] = J.arg(a, 0)
	var _t2549 = _s952["__p"]["__p"]["gpE"]
	J.cl(_t2549, null, [_s952["g"]])
	var _t2550 = J.gp(_s952["g"], "home")
	if J.t((_t2550 if J.t(_t2550) else J.gp(_s952["g"], "out"))):
		return null
	var _t2551 = _s952["g"]
	var _t2552 = J.gp(_s952["g"], "blockT")
	var _t2553 = J.sub((_t2552 if J.t(_t2552) else 0.0), _s952["__p"]["dt"])
	J.sp(_t2551, "blockT", _t2553)
	var _t2554 = _s952["g"]
	var _t2555 = J.max_([0.0, J.sub(J.gp(_s952["g"], "inv"), _s952["__p"]["dt"])])
	J.sp(_t2554, "inv", _t2555)
	var _t2556 = _s952["g"]
	var _t2557 = J.max_([0.0, J.sub(J.gp(_s952["g"], "invCd"), _s952["__p"]["dt"])])
	J.sp(_t2556, "invCd", _t2557)
	var _t2558 = _s952["g"]
	var _t2559 = J.max_([0.0, J.sub(J.gp(_s952["g"], "stun"), _s952["__p"]["dt"])])
	J.sp(_t2558, "stun", _t2559)
	var _t2560 = _s952["g"]
	var _t2561 = J.max_([0.0, J.sub(J.gp(_s952["g"], "scareCd"), _s952["__p"]["dt"])])
	J.sp(_t2560, "scareCd", _t2561)
	var _t2562 = _s952["g"]
	var _t2563 = J.max_([0.0, J.sub(J.gp(_s952["g"], "actT"), _s952["__p"]["dt"])])
	J.sp(_t2562, "actT", _t2563)
	var _t2564 = _s952["g"]
	var _t2565 = J.max_([0.0, J.sub(J.gp(_s952["g"], "hitT"), _s952["__p"]["dt"])])
	J.sp(_t2564, "hitT", _t2565)
	var _t2566 = _s952["g"]
	var _t2567 = J.max_([0.0, J.sub(J.gp(_s952["g"], "bounceT"), _s952["__p"]["dt"])])
	J.sp(_t2566, "bounceT", _t2567)
	var _t2568 = _s952["g"]
	var _t2569 = J.gp(_s952["g"], "sealT")
	var _t2570 = J.gp(_s952["g"], "sealT")
	var _t2571 = J.max_([0.0, J.sub((_t2570 if J.t(_t2570) else 0.0), _s952["__p"]["dt"])])
	J.sp(_t2568, "sealT", _t2571)
	var _t2572 = _s952["g"]
	var _t2573 = J.gp(_s952["g"], "dropT")
	var _t2574 = J.gp(_s952["g"], "dropT")
	var _t2575 = J.max_([0.0, J.sub((_t2574 if J.t(_t2574) else 0.0), _s952["__p"]["dt"])])
	J.sp(_t2572, "dropT", _t2575)
	if J.t(J.gp(_s952["g"], "inUnit")):
		return null
	var _t2576 = _s952["__p"]["__p"]["moveUpdate"]
	J.cl(_t2576, null, [_s952["g"], _s952["__p"]["dt"]])
	var _t2577 = _s952["__p"]["__p"]["beansCheck"]
	J.cl(_t2577, null, [_s952["g"], _s952["__p"]["dt"]])
	if J.seq(J.gp(J.gp(_s952["g"], "d"), "key"), "toyol"):
		var _t2578 = _s952["g"]
		var _t2579 = J.gp(_s952["g"], "flipT")
		var _t2580 = J.gp(_s952["g"], "flipT")
		var _t2581 = J.max_([0.0, J.sub((_t2580 if J.t(_t2580) else 0.0), _s952["__p"]["dt"])])
		J.sp(_t2578, "flipT", _t2581)
		if J.cmp(J.gp(_s952["g"], "mv"), 0.0, ">"):
			var _t2582 = _s952["g"]
			var _t2583 = J.sub((1.2 if J.leq(J.gp(_s952["g"], "flipCd"), null) else J.gp(_s952["g"], "flipCd")), _s952["__p"]["dt"])
			J.sp(_t2582, "flipCd", _t2583)
			if J.cmp(J.gp(_s952["g"], "flipCd"), 0.0, "<="):
				var _t2584 = _s952["g"]
				J.sp(_t2584, "flipT", 0.55)
				var _t2585 = _s952["g"]
				var _t2586 = (2.2 + J.mul(J.cl(_s952["__p"]["__p"]["rnd"], null, []), 1.5))
				J.sp(_t2585, "flipCd", _t2586)
	var _t2587 = J.gp(_s952["g"], "auto")
	if J.t((J.len(J.gp(_s952["g"], "auto")) if J.t(_t2587) else _t2587)):
		_s952["nx"] = J.gp(J.gp(_s952["g"], "auto"), 0.0)
		if (not J.t(J.gp(_s952["g"], "to"))):
			if J.seq(J.gp(_s952["g"], "node"), _s952["nx"]):
				J.mc(J.gp(_s952["g"], "auto"), "shift", [])
			else:
				var _t2588 = J.gp(J.gp(J.gp(_s952["__p"]["__p"]["G"], "nodes"), J.gp(_s952["g"], "node")), "links")
				v_ln_2627 = J.mc(_t2588, "find", [Callable(self, "_f416").bind(_s952)])
				var _t2590 = v_ln_2627
				if J.t(_t2590):
					var _t2589 = _s952["__p"]["__p"]["canPass"]
					_t2590 = J.seq(J.cl(_t2589, null, [_s952["g"], J.gp(v_ln_2627, "e")]), true)
				if J.t(_t2590):
					var _t2591 = _s952["g"]
					var _t2592 = _s952["nx"]
					J.sp(_t2591, "to", _t2592)
					var _t2593 = _s952["g"]
					J.sp(_t2593, "p", 0.0)
				else:
					var _t2594 = _s952["g"]
					J.sp(_t2594, "auto", null)
		if J.t(J.gp(_s952["g"], "to")):
			v_a_2628 = J.gp(J.gp(_s952["__p"]["__p"]["G"], "nodes"), J.gp(_s952["g"], "node"))
			v_b_2629 = J.gp(J.gp(_s952["__p"]["__p"]["G"], "nodes"), J.gp(_s952["g"], "to"))
			v_D_2630 = J.hypot_([J.sub(J.gp(v_b_2629, "x"), J.gp(v_a_2628, "x")), J.sub(J.gp(v_b_2629, "y"), J.gp(v_a_2628, "y"))])
			var _t2595 = _s952["g"]
			var _t2597 = J.mul(J.gp(J.gp(_s952["g"], "d"), "sp"), J.gp(J.gp(_s952["__p"]["__p"]["G"], "mods"), "spd"))
			var _t2596 = J.gp(_s952["g"], "spm")
			var _t2598 = J.add(J.gp(_t2595, "p"), J.div(J.mul(J.mul(_t2597, (_t2596 if J.t(_t2596) else 1.0)), _s952["__p"]["dt"]), v_D_2630))
			J.sp(_t2595, "p", _t2598)
			var _t2599 = _s952["g"]
			J.sp(_t2599, "still", 0.0)
			var _t2600 = _s952["g"]
			J.sp(_t2600, "taskP", 0.0)
			if (not J.seq(J.gp(v_b_2629, "x"), J.gp(v_a_2628, "x"))):
				var _t2601 = _s952["g"]
				var _t2602 = (1.0 if J.cmp(J.gp(v_b_2629, "x"), J.gp(v_a_2628, "x"), ">") else (-1.0))
				J.sp(_t2601, "dir", _t2602)
			if J.cmp(J.gp(_s952["g"], "p"), 1.0, ">="):
				var _t2603 = _s952["g"]
				var _t2604 = J.gp(_s952["g"], "to")
				J.sp(_t2603, "node", _t2604)
				var _t2605 = _s952["g"]
				J.sp(_t2605, "to", null)
				var _t2606 = _s952["g"]
				J.sp(_t2606, "p", 0.0)
				var _t2607 = J.gp(_s952["g"], "auto")
				if J.t((J.seq(J.gp(J.gp(_s952["g"], "auto"), 0.0), J.gp(_s952["g"], "node")) if J.t(_t2607) else _t2607)):
					J.mc(J.gp(_s952["g"], "auto"), "shift", [])
				var _t2608 = _s952["__p"]["__p"]["onArrive"]
				J.cl(_t2608, null, [_s952["g"]])
	var _t2609 = _s952["__p"]["__p"]["posOf"]
	v_p_2631 = J.cl(_t2609, null, [_s952["g"]])
	var _t2610 = _s952["g"]
	var _t2611 = J.max_([0.0, J.sub(J.gp(_s952["g"], "mv"), _s952["__p"]["dt"])])
	J.sp(_t2610, "mv", _t2611)
	if ((absf(J.num(J.sub(J.gp(v_p_2631, "x"), J.gp(_s952["g"], "x")))) + absf(J.num(J.sub(J.gp(v_p_2631, "y"), J.gp(_s952["g"], "y"))))) > 0.2):
		var _t2612 = _s952["g"]
		J.sp(_t2612, "mv", 0.18)
		var _t2613 = _s952["g"]
		J.sp(_t2613, "still", 0.0)
	else:
		var _t2614 = _s952["g"]
		var _t2615 = J.add(J.gp(_t2614, "still"), _s952["__p"]["dt"])
		J.sp(_t2614, "still", _t2615)
	var _t2616 = _s952["g"]
	var _t2617 = J.gp(v_p_2631, "x")
	J.sp(_t2616, "x", _t2617)
	var _t2618 = _s952["g"]
	var _t2619 = J.gp(v_p_2631, "y")
	J.sp(_t2618, "y", _t2619)
	var _t2620 = J.gp(_s952["g"], "autoS")
	var _t2622 = ((not J.t(J.gp(_s952["g"], "to"))) if J.t(_t2620) else _t2620)
	if J.t(_t2622):
		var _t2621 = J.gp(_s952["g"], "auto")
		_t2622 = (not J.t((J.len(J.gp(_s952["g"], "auto")) if J.t(_t2621) else _t2621)))
	var _t2623 = (J.cmp(J.gp(_s952["g"], "still"), 0.12, ">=") if J.t(_t2622) else _t2622)
	var _t2624 = (J.cmp(J.gp(_s952["g"], "stun"), 0.0, "<=") if J.t(_t2623) else _t2623)
	if J.t((J.cmp(J.gp(_s952["g"], "scareCd"), 0.0, "<=") if J.t(_t2624) else _t2624)):
		var _t2625 = _s952["g"]
		J.sp(_t2625, "autoS", null)
		var _t2626 = J.seq(J.gp(_s952["__p"]["__p"]["G"], "active"), J.gp(_s952["g"], "i"))
		if (J.cmp(J.gp(_s952["g"], "scareCd"), 0.0, "<=") if _t2626 else _t2626):
			J.cl(_s952["__p"]["__p"]["scarePress"], null, [])
	v_n_2632 = J.gp(J.gp(_s952["__p"]["__p"]["G"], "nodes"), J.gp(_s952["g"], "node"))
	var _t2627 = (not J.t(J.gp(_s952["g"], "to")))
	var _t2628 = (J.cmp(J.gp(_s952["g"], "still"), 0.1, ">=") if _t2627 else _t2627)
	var _t2630 = (J.cmp(J.gp(_s952["g"], "stun"), 0.0, "<=") if _t2628 else _t2628)
	if J.t(_t2630):
		var _t2629 = _s952["__p"]["__p"]["mirrorOn"]
		_t2630 = (not J.t(J.cl(_t2629, null, [_s952["g"]])))
	v_st_2633 = _t2630
	if J.t((J.seq(J.gp(v_n_2632, "kind"), "in") if J.t(v_st_2633) else v_st_2633)):
		var _t2631 = _s952["__p"]["__p"]["unitOf"]
		v_un_2634 = J.cl(_t2631, null, [J.gp(v_n_2632, "id")])
		if J.t(J.gp(v_un_2634, "lit")):
			var _t2632 = _s952["__p"]["__p"]["float"]
			J.cl(_t2632, null, [J.gp(_s952["g"], "x"), J.sub(J.gp(_s952["g"], "y"), 70.0), "開咗燈！被逼返出去", "#ffb0b0"])
			var _t2633 = _s952["g"]
			var _t2634 = J.gp(v_un_2634, "did")
			J.sp(_t2633, "node", _t2634)
			var _t2635 = _s952["g"]
			J.sp(_t2635, "stun", 0.6)
			var _t2636 = _s952["__p"]["__p"]["loseLoot"]
			J.cl(_t2636, null, [_s952["g"], 0.3])
		else:
			var _t2637 = J.gp(v_un_2634, "items")
			v_it_2635 = J.mc(_t2637, "find", [Callable(self, "_f417").bind(_s952)])
			if J.t(v_it_2635):
				var _t2639 = (not J.seq(v_it_2635, "doll"))
				var _t2640 = ((not J.seq(v_it_2635, "key")) if _t2639 else _t2639)
				var _t2641 = ((not J.seq(v_it_2635, "key2")) if _t2640 else _t2640)
				var _t2642 = ((not J.seq(v_it_2635, "lost")) if _t2641 else _t2641)
				if (J.cmp(J.len(J.gp(_s952["__p"]["__p"]["G"], "bag")), _s952["__p"]["__p"]["BAGMAX"], ">=") if _t2642 else _t2642):
					var _t2643 = (not J.t(J.gp(_s952["g"], "fullT")))
					if (_t2643 if _t2643 else J.cmp(J.gp(_s952["g"], "fullT"), 0.0, "<=")):
						var _t2644 = _s952["__p"]["__p"]["float"]
						J.cl(_t2644, null, [J.gp(_s952["g"], "x"), J.sub(J.gp(_s952["g"], "y"), 80.0), "收穫格滿咗！", "#ffb0b0"])
						var _t2645 = _s952["g"]
						J.sp(_t2645, "fullT", 2.0)
					var _t2646 = _s952["g"]
					var _t2647 = J.sub(J.gp(_t2646, "fullT"), _s952["__p"]["dt"])
					J.sp(_t2646, "fullT", _t2647)
				else:
					var _t2648 = _s952["g"]
					var _t2650 = J.mul(_s952["__p"]["dt"], J.gp(J.gp(_s952["__p"]["__p"]["G"], "mods"), "task"))
					var _t2649 = J.gp(_s952["g"], "tm")
					var _t2651 = J.add(J.gp(_t2648, "taskP"), J.div(J.mul(_t2650, (_t2649 if J.t(_t2649) else 1.0)), J.gp(J.gp(_s952["__p"]["__p"]["ITEM"], v_it_2635), "t")))
					J.sp(_t2648, "taskP", _t2651)
					if J.cmp(J.cl(_s952["__p"]["__p"]["rnd"], null, []), J.mul(_s952["__p"]["dt"], 14.0), "<"):
						if J.seq(J.gp(J.gp(_s952["g"], "d"), "key"), "toyol"):
							v_pn_2636 = {"x": J.add(J.gp(_s952["g"], "x"), J.mul(J.gp(_s952["g"], "dir"), 30.0)), "y": J.sub(J.gp(_s952["g"], "y"), 36.0), "vx": J.cl(_s952["__p"]["__p"]["rnd"], null, []), "vy": 0.0, "life": 0.7, "max": 0.7, "type": "note"}
							var _t2652 = J.gp(_s952["g"], "x")
							J.sp(v_pn_2636, "tx", _t2652)
							var _t2653 = J.sub(J.gp(_s952["g"], "y"), J.mul(J.gp(J.gp(_s952["g"], "d"), "h"), 0.45))
							J.sp(v_pn_2636, "ty", _t2653)
							var _t2654 = J.gp(_s952["__p"]["__p"]["G"], "parts")
							J.mc(_t2654, "push", [v_pn_2636])
						else:
							if J.seq(J.gp(J.gp(_s952["g"], "d"), "key"), "tianhua"):
								var _t2655 = _s952["__p"]["__p"]["part"]
								J.cl(_t2655, null, [J.add(J.gp(_s952["g"], "x"), (J.sub(J.cl(_s952["__p"]["__p"]["rnd"], null, []), 0.5) * 20.0)), J.sub(J.gp(_s952["g"], "y"), J.mul(J.gp(J.gp(_s952["g"], "d"), "h"), 0.5)), (J.sub(J.cl(_s952["__p"]["__p"]["rnd"], null, []), 0.5) * 60.0), ((-40.0) - J.mul(J.cl(_s952["__p"]["__p"]["rnd"], null, []), 40.0)), 0.7, "hair"])
					if J.cmp(J.gp(_s952["g"], "taskP"), 1.0, ">="):
						var _t2656 = _s952["g"]
						J.sp(_t2656, "taskP", 0.0)
						var _t2657 = J.gp(v_un_2634, "items")
						var _t2658 = J.gp(v_un_2634, "items")
						J.mc(_t2657, "splice", [J.mc(_t2658, "indexOf", [v_it_2635]), 1.0])
						var _t2659 = _s952["__p"]["__p"]["takeItem"]
						J.cl(_t2659, null, [_s952["g"], v_it_2635, v_un_2634])
			var _t2660 = J.gp(v_un_2634, "res")
			if J.t((J.seq(J.gp(J.gp(v_un_2634, "res"), "state"), "home") if J.t(_t2660) else _t2660)):
				var _t2661 = J.gp(v_un_2634, "res")
				var _t2663 = J.mul(J.mul(_s952["__p"]["dt"], 3.0), J.gp(J.gp(_s952["__p"]["__p"]["G"], "mods"), "pow"))
				var _t2662 = _s952["__p"]["__p"]["gpF"]
				var _t2664 = J.add(J.gp(_t2661, "fear"), J.mul(_t2663, J.cl(_t2662, null, [_s952["g"]])))
				J.sp(_t2661, "fear", _t2664)
				if J.cmp(J.gp(J.gp(v_un_2634, "res"), "fear"), 100.0, ">="):
					var _t2665 = _s952["__p"]["__p"]["flee"]
					J.cl(_t2665, null, [J.gp(v_un_2634, "res"), _s952["g"]])
	else:
		if (not J.t(v_st_2633)):
			var _t2666 = _s952["g"]
			J.sp(_t2666, "taskP", 0.0)
	var _t2667 = (not J.t(J.gp(_s952["g"], "to")))
	if (J.seq(J.gp(v_n_2632, "kind"), "door") if _t2667 else _t2667):
		var _t2668 = _s952["__p"]["__p"]["unitByDoor"]
		v_du_2637 = J.cl(_t2668, null, [J.gp(v_n_2632, "id")])
		var _t2669 = _s952["g"]
		var _t2671 = null
		if J.t(v_st_2633):
			var _t2670 = J.gp(_s952["g"], "injT")
			_t2671 = J.add((_t2670 if J.t(_t2670) else 0.0), _s952["__p"]["dt"])
		else:
			_t2671 = 0.0
		J.sp(_t2669, "injT", _t2671)
		var _t2672 = ((not J.t(J.gp(v_du_2637, "open"))) if J.t(v_du_2637) else v_du_2637)
		var _t2673 = (J.seq(J.gp(v_du_2637, "ot"), 2.0) if J.t(_t2672) else _t2672)
		if J.t((J.cmp(J.gp(_s952["g"], "injT"), 0.5, ">=") if J.t(_t2673) else _t2673)):
			var _t2674 = _s952["g"]
			var _t2675 = J.gp(_s952["g"], "injAcc")
			var _t2676 = J.add((_t2675 if J.t(_t2675) else 0.0), _s952["__p"]["dt"])
			J.sp(_t2674, "injAcc", _t2676)
			while true:
				var _t2677 = J.cmp(J.gp(_s952["g"], "injAcc"), 0.1, ">=")
				var _t2678 = (J.cmp(J.gp(_s952["__p"]["__p"]["G"], "fear"), 0.0, ">") if _t2677 else _t2677)
				if not (J.cmp(J.gp(v_du_2637, "paid"), J.gp(v_du_2637, "cost"), "<") if _t2678 else _t2678): break
				var _t2679 = _s952["g"]
				var _t2680 = J.sub(J.gp(_t2679, "injAcc"), 0.1)
				J.sp(_t2679, "injAcc", _t2680)
				var _t2681 = _s952["__p"]["__p"]["G"]
				J.sp(_t2681, "fear", J.num(J.gp(_t2681, "fear")) + -1.0)
				J.sp(v_du_2637, "paid", J.num(J.gp(v_du_2637, "paid")) + 1.0)
				if J.cmp(J.cl(_s952["__p"]["__p"]["rnd"], null, []), 0.6, "<"):
					var _t2682 = _s952["__p"]["__p"]["part"]
					J.cl(_t2682, null, [J.gp(_s952["g"], "x"), J.sub(J.gp(_s952["g"], "y"), 40.0), (J.sub(J.gp(v_du_2637, "x"), J.gp(_s952["g"], "x")) * 2.0), (-20.0), 0.5, "suck"])
			if J.cmp(J.gp(v_du_2637, "paid"), J.gp(v_du_2637, "cost"), ">="):
				var _t2683 = _s952["__p"]["__p"]["unlockUnit"]
				J.cl(_t2683, null, [v_du_2637, "鎮宅破咗！"])
			else:
				var _t2685 = J.cmp(J.gp(_s952["__p"]["__p"]["G"], "fear"), 0.0, "<=")
				if J.t(_t2685):
					var _t2684 = (not J.t(J.gp(_s952["g"], "blockT")))
					_t2685 = (_t2684 if _t2684 else J.cmp(J.gp(_s952["g"], "blockT"), 0.0, "<="))
				if _t2685:
					var _t2686 = _s952["__p"]["__p"]["float"]
					J.cl(_t2686, null, [J.gp(_s952["g"], "x"), J.sub(J.gp(_s952["g"], "y"), 80.0), "怕意唔夠，去嚇多啲人", "#ffd54a"])
					var _t2687 = _s952["g"]
					J.sp(_t2687, "blockT", 6.0)
		var _t2688 = ((not J.t(J.gp(v_du_2637, "open"))) if J.t(v_du_2637) else v_du_2637)
		var _t2689 = (J.seq(J.gp(v_du_2637, "ot"), 11.0) if J.t(_t2688) else _t2688)
		var _t2690 = (v_st_2633 if J.t(_t2689) else _t2689)
		if J.t((J.gp(J.gp(_s952["__p"]["__p"]["G"], "keys"), J.gp(v_du_2637, "keyNeed")) if J.t(_t2690) else _t2690)):
			var _t2691 = J.gp(_s952["__p"]["__p"]["G"], "keys")
			var _t2692 = J.gp(v_du_2637, "keyNeed")
			J.sp(_t2691, _t2692, J.num(J.gp(_t2691, _t2692)) + -1.0)
			var _t2693 = _s952["__p"]["__p"]["unlockUnit"]
			J.cl(_t2693, null, [v_du_2637, (J.add("用", J.gp(J.gp(_s952["__p"]["__p"]["ITEM"], J.gp(v_du_2637, "keyNeed")), "n")) + "開咗門")])
	else:
		var _t2694 = _s952["g"]
		J.sp(_t2694, "injT", 0.0)

func _f418(this_, a: Array, env):
	var v_r_2647 = null
	v_r_2647 = J.arg(a, 0)
	var _t2696 = env["__p"]["pplResTick"]
	J.cl(_t2696, null, [v_r_2647, env["dt"]])
	var _t2697 = J.gp(v_r_2647, "jumpT")
	var _t2698 = J.gp(v_r_2647, "jumpT")
	var _t2699 = J.max_([0.0, J.sub((_t2698 if J.t(_t2698) else 0.0), env["dt"])])
	J.sp(v_r_2647, "jumpT", _t2699)
	var _t2700 = J.gp(v_r_2647, "jumpT")
	J.sp(v_r_2647, "_pj", _t2700)
	var _t2701 = J.gp(v_r_2647, "tangle")
	var _t2702 = J.gp(v_r_2647, "tangle")
	var _t2703 = J.max_([0.0, J.sub((_t2702 if J.t(_t2702) else 0.0), env["dt"])])
	J.sp(v_r_2647, "tangle", _t2703)
	if J.seq(J.gp(v_r_2647, "state"), "flee"):
		if J.cmp(J.gp(v_r_2647, "tripT"), 0.0, ">"):
			var _t2704 = J.sub(J.gp(v_r_2647, "tripT"), env["dt"])
			J.sp(v_r_2647, "tripT", _t2704)
			var _t2705 = J.add(J.gp(v_r_2647, "x"), J.mul(J.mul(J.gp(v_r_2647, "vx"), 0.18), env["dt"]))
			J.sp(v_r_2647, "x", _t2705)
		else:
			var _t2706 = J.add(J.gp(v_r_2647, "x"), J.mul(J.gp(v_r_2647, "vx"), env["dt"]))
			J.sp(v_r_2647, "x", _t2706)
		var _t2707 = J.cmp(J.gp(v_r_2647, "x"), env["__p"]["SX"], "<")
		if (_t2707 if _t2707 else J.cmp(J.gp(v_r_2647, "x"), env["__p"]["LX"], ">")):
			J.sp(v_r_2647, "state", "gone")
		if J.cmp(J.cl(env["__p"]["rnd"], null, []), J.mul(env["dt"], 8.0), "<"):
			var _t2708 = env["__p"]["part"]
			J.cl(_t2708, null, [J.sub(J.gp(v_r_2647, "x"), (signf(J.num(J.gp(v_r_2647, "vx"))) * 10.0)), J.sub(J.gp(v_r_2647, "y"), 4.0), ((-J.num(J.gp(v_r_2647, "vx"))) * 0.1), (-10.0), 0.5, "dust"])
	var _t2709 = J.seq(J.gp(v_r_2647, "state"), "home")
	if J.t((J.gp(J.gp(v_r_2647, "unit"), "door") if _t2709 else _t2709)):
		var _t2710 = J.sub(J.gp(v_r_2647, "doorT"), env["dt"])
		J.sp(v_r_2647, "doorT", _t2710)
		if J.cmp(J.gp(v_r_2647, "doorT"), 0.0, "<="):
			var _t2711 = J.gp(v_r_2647, "unit")
			J.sp(_t2711, "doorOpen", 2.6)
			var _t2712 = (12.0 + J.mul(J.cl(env["__p"]["rnd"], null, []), 8.0))
			J.sp(v_r_2647, "doorT", _t2712)
			var _t2713 = env["__p"]["say"]
			var _t2714 = env["__p"]["pick"]
			J.cl(_t2713, null, [v_r_2647, J.cl(_t2714, null, [["出去倒杯水先", "邊個喺門口？", "開門透下氣"]])])
	if J.cmp(J.gp(J.gp(v_r_2647, "unit"), "doorOpen"), 0.0, ">"):
		var _t2715 = J.gp(v_r_2647, "unit")
		var _t2716 = J.sub(J.gp(_t2715, "doorOpen"), env["dt"])
		J.sp(_t2715, "doorOpen", _t2716)

func _f419(this_, a: Array, env):
	var v_un_2650 = null
	v_un_2650 = J.arg(a, 0)
	var _t2718 = J.sub(J.gp(v_un_2650, "litT"), env["dt"])
	J.sp(v_un_2650, "litT", _t2718)
	var _t2719 = J.gp(v_un_2650, "res")
	var _t2720 = (J.seq(J.gp(J.gp(v_un_2650, "res"), "state"), "home") if J.t(_t2719) else _t2719)
	var _t2721 = ((not J.t(J.gp(v_un_2650, "lit"))) if J.t(_t2720) else _t2720)
	if J.t((J.cmp(J.cl(env["__p"]["rnd"], null, []), J.mul(env["dt"], 0.04), "<") if J.t(_t2721) else _t2721)):
		J.sp(v_un_2650, "lit", true)
		J.sp(v_un_2650, "litT", 7.0)
		var _t2722 = env["__p"]["say"]
		var _t2724 = J.gp(v_un_2650, "res")
		var _t2723 = env["__p"]["line"]
		J.cl(_t2722, null, [_t2724, J.cl(_t2723, null, ["wake"])])
	var _t2725 = J.gp(v_un_2650, "lit")
	if J.t((J.cmp(J.gp(v_un_2650, "litT"), 0.0, "<=") if J.t(_t2725) else _t2725)):
		J.sp(v_un_2650, "lit", false)

func _f420(this_, a: Array, env):
	var v_h_2653 = null
	v_h_2653 = J.arg(a, 0)
	var _t2734 = env["__p"]["humanUpdate"]
	J.cl(_t2734, null, [v_h_2653, env["dt"]])

func _f421(this_, a: Array, env):
	var v_h_2656 = null
	v_h_2656 = J.arg(a, 0)
	return (not J.seq(J.gp(v_h_2656, "state"), "gone"))

func _f422(this_, a: Array, env):
	var v_f_2659 = null
	v_f_2659 = J.arg(a, 0)
	var _t2753 = J.sub(J.gp(v_f_2659, "life"), env["dt"])
	J.sp(v_f_2659, "life", _t2753)
	var _t2754 = J.sub(J.gp(v_f_2659, "y"), J.mul(env["dt"], 22.0))
	J.sp(v_f_2659, "y", _t2754)

func _f423(this_, a: Array, env):
	var v_f_2662 = null
	v_f_2662 = J.arg(a, 0)
	return J.cmp(J.gp(v_f_2662, "life"), 0.0, ">")

func _f424(this_, a: Array, env):
	var v_r_2665 = null
	v_r_2665 = J.arg(a, 0)
	if J.t(J.gp(v_r_2665, "say")):
		var _t2759 = J.sub(J.gp(v_r_2665, "sayT"), env["dt"])
		J.sp(v_r_2665, "sayT", _t2759)
		if J.cmp(J.gp(v_r_2665, "sayT"), 0.0, "<="):
			J.sp(v_r_2665, "say", null)

func _f425(this_, a: Array, env):
	var v_g_2668 = null
	v_g_2668 = J.arg(a, 0)
	return J.gp(v_g_2668, "out")

func _f414(this_, a: Array, env):
	var v_np_2620 = null; var v_f_2621 = null; var v_h_2622 = null
	var _s945 = {"__p": env, "dt": null}
	_s945["dt"] = J.arg(a, 0)
	var _t2518 = J.gp(_s945["__p"]["G"], "over")
	var _t2519 = (_t2518 if J.t(_t2518) else J.gp(_s945["__p"]["G"], "choice"))
	if J.t((_t2519 if J.t(_t2519) else _s945["__p"]["paused"])):
		return null
	if J.t(J.gp(_s945["__p"]["G"], "ult")):
		var _t2520 = J.gp(_s945["__p"]["G"], "ult")
		var _t2521 = J.add(J.gp(_t2520, "t"), _s945["dt"])
		J.sp(_t2520, "t", _t2521)
		if J.cmp(J.gp(J.gp(_s945["__p"]["G"], "ult"), "t"), 1.3, "<"):
			var _t2522 = _s945["__p"]["stepFx"]
			J.cl(_t2522, null, [_s945["dt"]])
			return null
		if (not J.t(J.gp(J.gp(_s945["__p"]["G"], "ult"), "done"))):
			var _t2523 = J.gp(_s945["__p"]["G"], "ult")
			J.sp(_t2523, "done", true)
			var _t2524 = _s945["__p"]["applyUlt"]
			J.cl(_t2524, null, [J.gp(_s945["__p"]["G"], "ult")])
		if J.cmp(J.gp(J.gp(_s945["__p"]["G"], "ult"), "t"), 4.0, ">"):
			var _t2525 = _s945["__p"]["G"]
			J.sp(_t2525, "ult", null)
			var _t2526 = _s945["__p"]["G"]
			J.sp(_t2526, "ultCool", 1.5)
	var _t2527 = _s945["__p"]["G"]
	var _t2528 = J.add(J.gp(_t2527, "t"), _s945["dt"])
	J.sp(_t2527, "t", _t2528)
	v_np_2620 = J.min_([3.0, floor(J.num(J.div(J.gp(_s945["__p"]["G"], "t"), _s945["__p"]["PHT"])))])
	if (not J.seq(v_np_2620, J.gp(_s945["__p"]["G"], "phase"))):
		var _t2529 = _s945["__p"]["G"]
		J.sp(_t2529, "phase", v_np_2620)
		var _t2530 = _s945["__p"]["toast"]
		J.cl(_t2530, null, [(J.add(J.gp(_s945["__p"]["PH"], v_np_2620), "到喇——巡邏加派，越近天光人越精。") if J.cmp(v_np_2620, 3.0, "<") else "天光喇！樓下開始有人起身，追兵越嚟越快，快啲走！")])
	var _t2531 = _s945["__p"]["G"]
	var _t2532 = J.sub(J.gp(_t2531, "toastT"), _s945["dt"])
	J.sp(_t2531, "toastT", _t2532)
	J.cl(_s945["__p"]["gpTick"], null, [])
	if (not J.t(J.gp(_s945["__p"]["G"], "traces"))):
		var _t2533 = _s945["__p"]["G"]
		var _t2534 = []
		J.sp(_t2533, "traces", _t2534)
	J.cl(_s945["__p"]["setupBeans"], null, [])
	var _t2535 = _s945["__p"]["G"]
	var _t2536 = J.sub(J.gp(_t2535, "waveT"), _s945["dt"])
	J.sp(_t2535, "waveT", _t2536)
	var _t2537 = J.cmp(J.gp(_s945["__p"]["G"], "waveT"), 0.0, "<=")
	if ((not J.t(J.gp(_s945["__p"]["G"], "gate"))) if _t2537 else _t2537):
		var _t2538 = _s945["__p"]["G"]
		J.sp(_t2538, "wave", J.num(J.gp(_t2538, "wave")) + 1.0)
		var _t2539 = _s945["__p"]["G"]
		var _t2541 = (18.0 if J.cmp(J.gp(_s945["__p"]["G"], "phase"), 3.0, ">=") else 30.0)
		var _t2540 = J.gp(_s945["__p"]["G"], "gpTier")
		var _t2542 = J.div(_t2541, (1.0 + J.mul(0.06, (_t2540 if J.t(_t2540) else 0.0))))
		J.sp(_t2539, "waveT", _t2542)
		v_f_2621 = (1.0 + floor(J.num(J.mul(J.cl(_s945["__p"]["rnd"], null, []), J.sub(_s945["__p"]["FL"], 1.0)))))
		var _t2543 = _s945["__p"]["mkHuman"]
		v_h_2622 = J.cl(_t2543, null, ["guard", ((J.add("f", v_f_2621) + "_") + ("s" if J.cmp(J.cl(_s945["__p"]["rnd"], null, []), 0.5, "<") else "l"))])
		var _t2544 = [J.max_([1.0, J.sub(v_f_2621, 1.0)]), J.min_([J.sub(_s945["__p"]["FL"], 1.0), J.add(v_f_2621, 1.0)])]
		J.sp(v_h_2622, "zone", _t2544)
		var _t2545 = (pow(J.num(1.15), J.num(J.gp(_s945["__p"]["G"], "wave"))) if J.cmp(J.gp(_s945["__p"]["G"], "phase"), 3.0, ">=") else 1.0)
		J.sp(v_h_2622, "boost", _t2545)
		var _t2546 = J.gp(_s945["__p"]["G"], "guards")
		J.mc(_t2546, "push", [v_h_2622])
		var _t2547 = _s945["__p"]["float"]
		J.cl(_t2547, null, [J.gp(v_h_2622, "x"), J.sub(J.gp(v_h_2622, "y"), 80.0), "加派保安", "#ffb0b0"])
	var _t2548 = J.gp(_s945["__p"]["G"], "gh")
	J.mc(_t2548, "forEach", [Callable(self, "_f415").bind(_s945)])
	var _t2695 = J.gp(_s945["__p"]["G"], "res")
	J.mc(_t2695, "forEach", [Callable(self, "_f418").bind(_s945)])
	if J.cmp(J.gp(_s945["__p"]["G"], "phase"), 2.0, ">="):
		var _t2717 = J.gp(_s945["__p"]["G"], "units")
		J.mc(_t2717, "forEach", [Callable(self, "_f419").bind(_s945)])
	var _t2726 = _s945["__p"]["traceUpdate"]
	J.cl(_t2726, null, [_s945["dt"]])
	var _t2727 = _s945["__p"]["G"]
	var _t2728 = J.gp(_s945["__p"]["G"], "phoneCd")
	var _t2729 = J.gp(_s945["__p"]["G"], "phoneCd")
	var _t2730 = J.max_([0.0, J.sub((_t2729 if J.t(_t2729) else 0.0), _s945["dt"])])
	J.sp(_t2727, "phoneCd", _t2730)
	var _t2731 = _s945["__p"]["resUpdate2"]
	J.cl(_t2731, null, [_s945["dt"]])
	var _t2732 = _s945["__p"]["pplTick"]
	J.cl(_t2732, null, [_s945["dt"]])
	var _t2733 = J.gp(_s945["__p"]["G"], "guards")
	J.mc(_t2733, "forEach", [Callable(self, "_f420").bind(_s945)])
	var _t2735 = _s945["__p"]["G"]
	var _t2736 = J.gp(_s945["__p"]["G"], "guards")
	var _t2737 = J.mc(_t2736, "filter", [Callable(self, "_f421").bind(_s945)])
	J.sp(_t2735, "guards", _t2737)
	var _t2738 = _s945["__p"]["G"]
	var _t2739 = J.gp(_s945["__p"]["G"], "ultCool")
	var _t2740 = J.gp(_s945["__p"]["G"], "ultCool")
	var _t2741 = J.max_([0.0, J.sub((_t2740 if J.t(_t2740) else 0.0), _s945["dt"])])
	J.sp(_t2738, "ultCool", _t2741)
	var _t2742 = J.cmp(J.gp(_s945["__p"]["G"], "choiceQ"), 0.0, ">")
	var _t2743 = ((not J.t(J.gp(_s945["__p"]["G"], "ult"))) if _t2742 else _t2742)
	if (J.cmp(J.gp(_s945["__p"]["G"], "ultCool"), 0.0, "<=") if _t2743 else _t2743):
		var _t2744 = _s945["__p"]["G"]
		J.sp(_t2744, "choiceQ", J.num(J.gp(_t2744, "choiceQ")) + -1.0)
		var _t2745 = _s945["__p"]["G"]
		var _t2746 = _s945["__p"]["shuffle"]
		var _t2747 = J.cl(_t2746, null, [_s945["__p"]["CARDS"]])
		var _t2748 = J.mc(_t2747, "slice", [0.0, 3.0])
		J.sp(_t2745, "choice", _t2748)
	J.cl(_s945["__p"]["checkAlert"], null, [])
	var _t2749 = _s945["__p"]["taoUpdate"]
	J.cl(_t2749, null, [_s945["dt"]])
	var _t2750 = _s945["__p"]["gateUpdate"]
	J.cl(_t2750, null, [_s945["dt"]])
	var _t2751 = _s945["__p"]["stepFx"]
	J.cl(_t2751, null, [_s945["dt"]])
	var _t2752 = J.gp(_s945["__p"]["G"], "floats")
	J.mc(_t2752, "forEach", [Callable(self, "_f422").bind(_s945)])
	var _t2755 = _s945["__p"]["G"]
	var _t2756 = J.gp(_s945["__p"]["G"], "floats")
	var _t2757 = J.mc(_t2756, "filter", [Callable(self, "_f423").bind(_s945)])
	J.sp(_t2755, "floats", _t2757)
	var _t2758 = J.gp(_s945["__p"]["G"], "res")
	J.mc(_t2758, "forEach", [Callable(self, "_f424").bind(_s945)])
	var _t2760 = J.gp(_s945["__p"]["G"], "gh")
	if J.t(J.mc(_t2760, "every", [Callable(self, "_f425").bind(_s945)])):
		var _t2761 = _s945["__p"]["endNight"]
		J.cl(_t2761, null, ["fail"])

func _f427(this_, a: Array, env):
	var v_q_2677 = null
	v_q_2677 = J.arg(a, 0)
	return J.seq(J.gp(v_q_2677, "id"), "lost")

func _f426(this_, a: Array, env):
	var v_g_2671 = null; var v_it_2672 = null; var v_un_2673 = null; var v_q_2674 = null
	v_g_2671 = J.arg(a, 0)
	v_it_2672 = J.arg(a, 1)
	v_un_2673 = J.arg(a, 2)
	if J.seq(v_it_2672, "doll"):
		var _t2762 = env["G"]
		J.sp(_t2762, "dolls", J.num(J.gp(_t2762, "dolls")) + 1.0)
		var _t2763 = env["float"]
		J.cl(_t2763, null, [J.gp(v_g_2671, "x"), J.sub(J.gp(v_g_2671, "y"), 90.0), (J.add("替身紙人 ", J.gp(env["G"], "dolls")) + "/6"), "#e8d8b0"])
		if J.seq(J.gp(env["G"], "dolls"), 6.0):
			var _t2764 = env["toast"]
			J.cl(_t2764, null, ["替身紙人夠 6 個！隨時可以按「替身遁走」，但係故事碎片同部分收穫會留低。"])
		return null
	var _t2765 = J.seq(v_it_2672, "key")
	if (_t2765 if _t2765 else J.seq(v_it_2672, "key2")):
		var _t2766 = J.gp(env["G"], "keys")
		var _t2767 = J.gp(J.gp(env["G"], "keys"), v_it_2672)
		var _t2768 = J.add((_t2767 if J.t(_t2767) else 0.0), 1.0)
		J.sp(_t2766, v_it_2672, _t2768)
		var _t2769 = env["float"]
		J.cl(_t2769, null, [J.gp(v_g_2671, "x"), J.sub(J.gp(v_g_2671, "y"), 90.0), (J.add("偷到", J.gp(J.gp(env["ITEM"], v_it_2672), "n")) + "！"), "#ffd54a"])
		return null
	if J.seq(v_it_2672, "lost"):
		var _t2770 = env["G"]
		J.sp(_t2770, "carry", "lost")
		var _t2771 = J.gp(env["G"], "quests")
		var _t2772 = (_t2771 if J.t(_t2771) else [])
		v_q_2674 = J.mc(_t2772, "find", [Callable(self, "_f427").bind(env)])
		var _t2773 = env["float"]
		J.cl(_t2773, null, [J.gp(v_g_2671, "x"), J.sub(J.gp(v_g_2671, "y"), 90.0), (J.add((J.add("搵到", (J.gp(v_q_2674, "thing") if J.t(v_q_2674) else "失物")) + "！帶返去俾"), (J.gp(env["FLN"], J.gp(J.gp(v_q_2674, "owner"), "f")) if J.t(v_q_2674) else "")) + "嘅主人"), "#8affc8"])
		return null
	var _t2774 = J.seq(v_it_2672, "food")
	if (J.seq(J.gp(J.gp(v_g_2671, "d"), "key"), "eking") if _t2774 else _t2774):
		var _t2775 = J.gp(v_g_2671, "fat")
		var _t2776 = J.gp(v_g_2671, "fat")
		var _t2777 = J.min_([0.3, J.add((_t2776 if J.t(_t2776) else 0.0), 0.06)])
		J.sp(v_g_2671, "fat", _t2777)
		var _t2778 = env["float"]
		J.cl(_t2778, null, [J.gp(v_g_2671, "x"), (J.sub(J.gp(v_g_2671, "y"), J.gp(J.gp(v_g_2671, "d"), "h")) - 30.0), "越食越餓……", "#ffb7a0"])
	var _t2779 = J.gp(env["G"], "bag")
	J.mc(_t2779, "push", [{"t": v_it_2672, "o": J.gp(v_g_2671, "i")}])
	J.sp(v_g_2671, "loot", J.num(J.gp(v_g_2671, "loot")) + 1.0)
	var _t2780 = J.min_([100.0, J.add(J.gp(v_g_2671, "energy"), 12.0)])
	J.sp(v_g_2671, "energy", _t2780)
	var _t2781 = env["float"]
	J.cl(_t2781, null, [J.gp(v_g_2671, "x"), J.sub(J.gp(v_g_2671, "y"), 90.0), (J.add((J.add((J.add("收到", J.gp(J.gp(env["ITEM"], v_it_2672), "n")) + "（"), J.len(J.gp(env["G"], "bag"))) + "/"), env["BAGMAX"]) + "）"), "#ffd54a"])

func _f428(this_, a: Array, env):
	var v_u_2680 = null; var v_msg_2681 = null
	v_u_2680 = J.arg(a, 0)
	v_msg_2681 = J.arg(a, 1)
	if J.t(J.gp(v_u_2680, "open")):
		return null
	J.sp(v_u_2680, "open", true)
	var _t2782 = env["float"]
	J.cl(_t2782, null, [J.gp(v_u_2680, "x"), J.sub(J.gp(v_u_2680, "y"), 90.0), v_msg_2681, "#9fd6bf"])
	var _t2783 = J.gp(env["G"], "wardFx")
	J.mc(_t2783, "push", [{"x": J.gp(v_u_2680, "x"), "y": J.gp(v_u_2680, "y"), "t": 0.9}])
	J.sp(v_u_2680, "unlockFx", 1.2)

func _f429(this_, a: Array, env):
	var v_lv_2684 = null; var v_fr_2685 = null; var v_m_2686 = null; var v_real_2687 = null; var v_k_2688 = null; var v_d_2689 = null
	v_lv_2684 = (3.0 if J.cmp(J.gp(env["G"], "alert"), 10.0, ">=") else (2.0 if J.cmp(J.gp(env["G"], "alert"), 6.0, ">=") else (1.0 if J.cmp(J.gp(env["G"], "alert"), 3.0, ">=") else 0.0)))
	while true:
		if not J.cmp(J.gp(env["G"], "alertLv"), v_lv_2684, "<"): break
		var _t2784 = env["G"]
		J.sp(_t2784, "alertLv", J.num(J.gp(_t2784, "alertLv")) + 1.0)
		v_fr_2685 = (1.0 + floor(J.num(J.mul(J.cl(env["rnd"], null, []), J.sub(env["FL"], 1.0)))))
		if J.seq(J.gp(env["G"], "alertLv"), 1.0):
			var _t2785 = J.gp(env["G"], "guards")
			var _t2786 = env["mkHuman"]
			J.mc(_t2785, "push", [J.cl(_t2786, null, ["compass", (J.add("f", v_fr_2685) + "_s")])])
			var _t2787 = env["toast"]
			J.cl(_t2787, null, ["全樓警覺 3：管理處加派「羅盤保安」——每次只嚇得走佢一點膽，靠閂門同繞路避開佢。"])
		if J.seq(J.gp(env["G"], "alertLv"), 2.0):
			var _t2788 = env["mkHuman"]
			v_m_2686 = J.cl(_t2788, null, ["mirror", (J.add("f", v_fr_2685) + "_l")])
			var _t2789 = (-1.0)
			J.sp(v_m_2686, "dir", _t2789)
			var _t2790 = J.gp(env["G"], "guards")
			J.mc(_t2790, "push", [v_m_2686])
			var _t2791 = env["toast"]
			J.cl(_t2791, null, ["全樓警覺 6：「鏡子道士」到——唔好正面對住佢面鏡，要兜去佢背後先嚇得到。"])
		if J.seq(J.gp(env["G"], "alertLv"), 3.0):
			var _t2792 = env["G"]
			J.sp(_t2792, "taoWant", true)
			v_real_2687 = floor(J.num(J.mul(J.cl(env["rnd"], null, []), 3.0)))
			v_k_2688 = 0.0
			while true:
				if not J.cmp(v_k_2688, 3.0, "<"): break
				var _t2793 = env["mkHuman"]
				v_d_2689 = J.cl(_t2793, null, ["decoy", (J.add((J.add("f", v_fr_2685) + "_d"), v_k_2688) if J.has(J.gp(env["G"], "nodes"), J.add((J.add("f", v_fr_2685) + "_d"), v_k_2688)) else (J.add("f", v_fr_2685) + "_s")), {"real": J.seq(v_k_2688, v_real_2687)}])
				var _t2794 = J.gp(env["G"], "guards")
				J.mc(_t2794, "push", [v_d_2689])
				v_k_2688 = J.num(v_k_2688) + 1.0
			var _t2795 = env["toast"]
			J.cl(_t2795, null, ["全樓警覺 10：天師同「紙人替身陣」上樓——三個道士得一個係真身，試下嚇邊個。"])
		var _t2796 = env["G"]
		J.sp(_t2796, "shake", 0.4)

func _f430(this_, a: Array, env):
	var v_n_2692 = null; var v_k_2693 = null; var v_m_2694 = null
	v_n_2692 = J.gp(J.gp(env["G"], "nodes"), "f0_e")
	env["SAFE"] = null
	if (not J.t(v_n_2692)):
		return null
	var _t2797 = {"node": "f0_e", "x": J.gp(v_n_2692, "x"), "y": J.gp(v_n_2692, "y"), "f": J.gp(v_n_2692, "f"), "r": env["SAFE_R"], "nodes": {}, "a": 1.0, "was": true}
	env["SAFE"] = _t2797
	for _t2798 in J.keys(J.gp(env["G"], "nodes")):
		v_k_2693 = _t2798
		v_m_2694 = J.gp(J.gp(env["G"], "nodes"), v_k_2693)
		var _t2799 = J.seq(J.gp(v_m_2694, "f"), J.gp(v_n_2692, "f"))
		if (J.cmp(absf(J.num(J.sub(J.gp(v_m_2694, "x"), J.gp(v_n_2692, "x")))), env["SAFE_R"], "<=") if _t2799 else _t2799):
			var _t2800 = J.gp(env["SAFE"], "nodes")
			J.sp(_t2800, v_k_2693, 1.0)

func _f431(this_, a: Array, env):
	var _t2802 = (env["SAFE"] if J.t(env["G"]) else env["G"])
	if J.t(_t2802):
		var _t2801 = J.gp(env["G"], "gate")
		_t2802 = (not J.t((J.seq(J.gp(J.gp(env["G"], "gate"), "node"), J.gp(env["SAFE"], "node")) if J.t(_t2801) else _t2801)))
	return (not (not J.t(_t2802)))

func _f432(this_, a: Array, env):
	var v_x_2699 = null; var v_y_2700 = null
	v_x_2699 = J.arg(a, 0)
	v_y_2700 = J.arg(a, 1)
	var _t2803 = J.cl(env["safeOn"], null, [])
	var _t2804 = ((absf(J.num(J.sub(v_y_2700, J.gp(env["SAFE"], "y")))) < 30.0) if J.t(_t2803) else _t2803)
	return (J.cmp(absf(J.num(J.sub(v_x_2699, J.gp(env["SAFE"], "x")))), J.gp(env["SAFE"], "r"), "<=") if J.t(_t2804) else _t2804)

func _f433(this_, a: Array, env):
	var v_g_2703 = null
	v_g_2703 = J.arg(a, 0)
	var _t2805 = (not J.t(v_g_2703))
	var _t2806 = (_t2805 if _t2805 else J.gp(v_g_2703, "home"))
	if J.t((_t2806 if J.t(_t2806) else J.gp(v_g_2703, "out"))):
		return false
	var _t2807 = env["inSafeXY"]
	if J.t(J.cl(_t2807, null, [J.gp(v_g_2703, "x"), J.gp(v_g_2703, "y")])):
		var _t2808 = J.gp(env["G"], "t")
		J.sp(v_g_2703, "_sgT", _t2808)
		return true
	var _t2809 = J.cl(env["safeOn"], null, [])
	var _t2810 = ((not J.leq(J.gp(v_g_2703, "_sgT"), null)) if J.t(_t2809) else _t2809)
	var _t2811 = ((J.sub(J.gp(env["G"], "t"), J.gp(v_g_2703, "_sgT")) < 2.0) if J.t(_t2810) else _t2810)
	var _t2812 = ((absf(J.num(J.sub(J.gp(v_g_2703, "y"), J.gp(env["SAFE"], "y")))) < 30.0) if J.t(_t2811) else _t2811)
	return (J.cmp(absf(J.num(J.sub(J.gp(v_g_2703, "x"), J.gp(env["SAFE"], "x")))), J.add(J.gp(env["SAFE"], "r"), 110.0), "<=") if J.t(_t2812) else _t2812)

func _f434(this_, a: Array, env):
	var v_id_2706 = null
	v_id_2706 = J.arg(a, 0)
	var _t2813 = J.cl(env["safeOn"], null, [])
	return ((not (not J.t(J.gp(J.gp(env["SAFE"], "nodes"), v_id_2706)))) if J.t(_t2813) else _t2813)

func _f435(this_, a: Array, env):
	var v_h_2709 = null
	v_h_2709 = J.arg(a, 0)
	var _t2814 = (not (not J.t(env["SAFE"])))
	var _t2815 = ((absf(J.num(J.sub(J.gp(v_h_2709, "y"), J.gp(env["SAFE"], "y")))) < 200.0) if _t2814 else _t2814)
	return (J.cmp(absf(J.num(J.sub(J.gp(v_h_2709, "x"), J.gp(env["SAFE"], "x")))), J.add(J.gp(env["SAFE"], "r"), 340.0), "<") if _t2815 else _t2815)

func _f437(this_, a: Array, env):
	var v_g_2717 = null; var v_d_2718 = null
	v_g_2717 = J.arg(a, 0)
	var _t2817 = J.gp(v_g_2717, "home")
	var _t2818 = (_t2817 if J.t(_t2817) else J.gp(v_g_2717, "out"))
	if J.t((_t2818 if J.t(_t2818) else J.cmp(J.gp(v_g_2717, "inv"), 0.0, ">"))):
		return null
	v_d_2718 = (absf(J.num(J.sub(J.gp(v_g_2717, "x"), J.gp(env["h"], "x")))) + (absf(J.num(J.sub(J.gp(v_g_2717, "y"), J.gp(env["h"], "y")))) * 1.5))
	if J.cmp(v_d_2718, env["bd"], "<"):
		env["bd"] = v_d_2718
		env["best"] = v_g_2717

func _f436(this_, a: Array, env):
	var _s1021 = {"__p": env, "h": null, "best": null, "bd": null}
	_s1021["h"] = J.arg(a, 0)
	_s1021["best"] = null
	_s1021["bd"] = 1000000000.0
	var _t2816 = J.gp(_s1021["__p"]["G"], "gh")
	J.mc(_t2816, "forEach", [Callable(self, "_f437").bind(_s1021)])
	return _s1021["best"]

func _f438(this_, a: Array, env):
	var v_h_2721 = null; var v_best_2722 = null; var v_bd_2723 = null; var v_k_2724 = null; var v_n_2725 = null; var v_d_2726 = null
	v_h_2721 = J.arg(a, 0)
	v_best_2722 = null
	v_bd_2723 = 1000000000.0
	for _t2819 in J.keys(J.gp(env["G"], "nodes")):
		v_k_2724 = _t2819
		v_n_2725 = J.gp(J.gp(env["G"], "nodes"), v_k_2724)
		var _t2821 = J.seq(J.gp(v_n_2725, "kind"), "in")
		if not J.t(_t2821):
			var _t2820 = env["safeNode"]
			_t2821 = J.cl(_t2820, null, [v_k_2724])
		if J.t(_t2821):
			continue
		v_d_2726 = (absf(J.num(J.sub(J.gp(v_n_2725, "x"), J.gp(v_h_2721, "x")))) + (absf(J.num(J.sub(J.gp(v_n_2725, "y"), J.gp(v_h_2721, "y")))) * 3.0))
		if J.cmp(v_d_2726, v_bd_2723, "<"):
			v_bd_2723 = v_d_2726
			v_best_2722 = v_k_2724
	return v_best_2722

func _f440(this_, a: Array, env):
	var v_t_2735 = null
	v_t_2735 = J.arg(a, 0)
	return ((not J.t(J.gp(env["U"], v_t_2735))) if J.t(v_t_2735) else v_t_2735)

func _f439(this_, a: Array, env):
	var v_pool_2729 = null; var v_free_2731 = null; var v_t_2732 = null
	var _s1028 = {"__p": env, "U": null}
	v_pool_2729 = J.arg(a, 0)
	var _t2824 = J.gp(_s1028["__p"]["G"], "_uq")
	if not J.t(_t2824):
		var _t2822 = _s1028["__p"]["G"]
		var _t2823 = {}
		J.sp(_t2822, "_uq", _t2823)
		_t2824 = _t2823
	_s1028["U"] = _t2824
	v_free_2731 = J.mc(v_pool_2729, "filter", [Callable(self, "_f440").bind(_s1028)])
	if (not J.t(J.len(v_free_2731))):
		return null
	v_t_2732 = J.gp(v_free_2731, floor(J.num((randf() * J.len(v_free_2731)))))
	var _t2825 = _s1028["U"]
	J.sp(_t2825, v_t_2732, 1.0)
	return v_t_2732

func _f441(this_, a: Array, env):
	var v_o_2738 = null; var v_t_2739 = null
	v_o_2738 = J.arg(a, 0)
	var _t2826 = env["uniq"]
	v_t_2739 = J.cl(_t2826, null, [env["SCREAM"]])
	var _t2827 = ({"t": v_t_2739, "T": 1.9} if J.t(v_t_2739) else null)
	J.sp(v_o_2738, "scream", _t2827)
	if J.t(v_t_2739):
		J.sp(v_o_2738, "say", null)
		J.sp(v_o_2738, "sayT", 0.0)

func _f442(this_, a: Array, env):
	var v_h_2742 = null; var v_talk_2743 = null; var v_t_2744 = null
	v_h_2742 = J.arg(a, 0)
	v_talk_2743 = J.arg(a, 1)
	J.sp(v_h_2742, "state", "balk")
	J.sp(v_h_2742, "balkT", 2.6)
	J.sp(v_h_2742, "balkTurn", 0.0)
	J.sp(v_h_2742, "path", null)
	J.sp(v_h_2742, "lostT", 0.0)
	J.sp(v_h_2742, "alertT", 0.0)
	var _t2828 = (1.0 if J.t((J.cmp(J.gp(env["SAFE"], "x"), J.gp(v_h_2742, "x"), ">") if J.t(env["SAFE"]) else env["SAFE"])) else (-1.0))
	J.sp(v_h_2742, "dir", _t2828)
	if J.t(v_talk_2743):
		var _t2829 = env["uniq"]
		v_t_2744 = J.cl(_t2829, null, [env["BALKL"]])
		if J.t(v_t_2744):
			J.sp(v_h_2742, "say", v_t_2744)
			J.sp(v_h_2742, "sayT", 2.6)

func _f443(this_, a: Array, env):
	var v_r_2747 = null; var v_amp_2748 = null; var v_H_2749 = null; var v_k_2750 = null
	v_r_2747 = J.arg(a, 0)
	v_amp_2748 = J.arg(a, 1)
	J.sp(v_r_2747, "shockT", 0.9)
	J.sp(v_r_2747, "shockA", v_amp_2748)
	var _t2830 = J.gp(v_r_2747, "shockN")
	var _t2831 = J.add((_t2830 if J.t(_t2830) else 0.0), 1.0)
	J.sp(v_r_2747, "shockN", _t2831)
	var _t2832 = J.gp(v_r_2747, "h")
	v_H_2749 = J.mul((_t2832 if J.t(_t2832) else 66.0), 1.12)
	v_k_2750 = 0.0
	while true:
		if not J.cmp(v_k_2750, (5.0 if J.cmp(v_amp_2748, 1.0, ">=") else 3.0), "<"): break
		var _t2833 = env["part"]
		J.cl(_t2833, null, [J.add(J.gp(v_r_2747, "x"), ((randf() - 0.5) * 24.0)), J.sub(J.gp(v_r_2747, "y"), J.mul(v_H_2749, 0.82)), ((randf() - 0.5) * 150.0), ((-90.0) - (randf() * 70.0)), 0.75, ("tear" if J.t(J.mod(v_k_2750, 2.0)) else "sweat")])
		v_k_2750 = J.num(v_k_2750) + 1.0
	var _t2834 = J.cmp(v_amp_2748, 1.0, ">=")
	var _t2835 = ((not J.t(J.gp(v_r_2747, "dropped"))) if _t2834 else _t2834)
	var _t2836 = (J.seq(J.gp(v_r_2747, "state"), "home") if _t2835 else _t2835)
	var _t2837 = ((not J.t(J.mc(env["PPLFX"], "hasScared", [J.gp(v_r_2747, "sprite")]))) if _t2836 else _t2836)
	if J.t((J.gp(env["DROPK"], J.gp(v_r_2747, "hh")) if _t2837 else _t2837)):
		J.sp(v_r_2747, "dropped", 1.0)
		var _t2840 = J.gp(env["G"], "pdrops")
		if not J.t(_t2840):
			var _t2838 = env["G"]
			var _t2839 = []
			J.sp(_t2838, "pdrops", _t2839)
			_t2840 = _t2839
		J.mc(_t2840, "push", [{"k": J.gp(env["DROPK"], J.gp(v_r_2747, "hh")), "x": J.add(J.gp(v_r_2747, "x"), ((-10.0) if J.cmp(J.gp(v_r_2747, "vx"), 0.0, "<") else 10.0)), "y": J.sub(J.gp(v_r_2747, "y"), J.mul(v_H_2749, 0.5)), "fy": J.gp(v_r_2747, "y"), "vx": (((-1.0) if (randf() < 0.5) else 1.0) * (40.0 + (randf() * 50.0))), "vy": (-140.0), "rot": 0.0, "vr": ((randf() - 0.5) * 14.0), "life": 3.2}])

func _f444(this_, a: Array, env):
	var v_r_2753 = null; var v_dt_2754 = null
	v_r_2753 = J.arg(a, 0)
	v_dt_2754 = J.arg(a, 1)
	var _t2841 = J.gp(v_r_2753, "jumpT")
	var _t2843 = (_t2841 if J.t(_t2841) else 0.0)
	var _t2842 = J.gp(v_r_2753, "_pj")
	if J.cmp(_t2843, J.add((_t2842 if J.t(_t2842) else 0.0), 0.001), ">"):
		var _t2844 = env["startShock"]
		J.cl(_t2844, null, [v_r_2753, (1.0 if J.cmp(J.gp(v_r_2753, "jumpT"), 0.5, ">=") else 0.65)])
	var _t2845 = J.gp(v_r_2753, "shockT")
	var _t2846 = J.gp(v_r_2753, "shockT")
	var _t2847 = J.max_([0.0, J.sub((_t2846 if J.t(_t2846) else 0.0), v_dt_2754)])
	J.sp(v_r_2753, "shockT", _t2847)
	if J.t(J.gp(v_r_2753, "scream")):
		var _t2848 = J.gp(v_r_2753, "scream")
		var _t2849 = J.sub(J.gp(_t2848, "T"), v_dt_2754)
		J.sp(_t2848, "T", _t2849)
		if J.cmp(J.gp(J.gp(v_r_2753, "scream"), "T"), 0.0, "<="):
			J.sp(v_r_2753, "scream", null)
	var _t2850 = J.seq(J.gp(v_r_2753, "state"), "home")
	var _t2852 = (J.gp(v_r_2753, "awake") if _t2850 else _t2850)
	if J.t(_t2852):
		var _t2851 = J.gp(v_r_2753, "fear")
		_t2852 = J.cmp((_t2851 if J.t(_t2851) else 0.0), 55.0, ">=")
	if J.t(((randf() < J.mul(v_dt_2754, 1.1)) if J.t(_t2852) else _t2852)):
		var _t2853 = env["part"]
		var _t2856 = J.add(J.gp(v_r_2753, "x"), ((-12.0) if (randf() < 0.5) else 12.0))
		var _t2855 = J.gp(v_r_2753, "y")
		var _t2854 = J.gp(v_r_2753, "h")
		J.cl(_t2853, null, [_t2856, J.sub(_t2855, J.mul((_t2854 if J.t(_t2854) else 66.0), 0.95)), ((randf() - 0.5) * 30.0), (-20.0), 0.6, "sweat"])

func _f446(this_, a: Array, env):
	var v_d_2761 = null
	v_d_2761 = J.arg(a, 0)
	var _t2859 = J.sub(J.gp(v_d_2761, "life"), env["dt"])
	J.sp(v_d_2761, "life", _t2859)
	var _t2860 = J.add(J.gp(v_d_2761, "vy"), J.mul(520.0, env["dt"]))
	J.sp(v_d_2761, "vy", _t2860)
	var _t2861 = J.add(J.gp(v_d_2761, "x"), J.mul(J.gp(v_d_2761, "vx"), env["dt"]))
	J.sp(v_d_2761, "x", _t2861)
	var _t2862 = J.add(J.gp(v_d_2761, "y"), J.mul(J.gp(v_d_2761, "vy"), env["dt"]))
	J.sp(v_d_2761, "y", _t2862)
	var _t2863 = J.add(J.gp(v_d_2761, "rot"), J.mul(J.gp(v_d_2761, "vr"), env["dt"]))
	J.sp(v_d_2761, "rot", _t2863)
	if J.cmp(J.gp(v_d_2761, "y"), J.sub(J.gp(v_d_2761, "fy"), 3.0), ">="):
		var _t2864 = J.sub(J.gp(v_d_2761, "fy"), 3.0)
		J.sp(v_d_2761, "y", _t2864)
		var _t2865 = ((-absf(J.num(J.gp(v_d_2761, "vy")))) * 0.28)
		J.sp(v_d_2761, "vy", _t2865)
		var _t2866 = J.mul(J.gp(v_d_2761, "vx"), 0.55)
		J.sp(v_d_2761, "vx", _t2866)
		var _t2867 = J.mul(J.gp(v_d_2761, "vr"), 0.4)
		J.sp(v_d_2761, "vr", _t2867)
		if (absf(J.num(J.gp(v_d_2761, "vy"))) < 20.0):
			J.sp(v_d_2761, "vy", 0.0)

func _f447(this_, a: Array, env):
	var v_d_2764 = null
	v_d_2764 = J.arg(a, 0)
	return J.cmp(J.gp(v_d_2764, "life"), 0.0, ">")

func _f445(this_, a: Array, env):
	var v_on_2758 = null
	var _s1040 = {"__p": env, "dt": null}
	_s1040["dt"] = J.arg(a, 0)
	var _t2857 = J.gp(_s1040["__p"]["G"], "pdrops")
	var _t2858 = (_t2857 if J.t(_t2857) else [])
	J.mc(_t2858, "forEach", [Callable(self, "_f446").bind(_s1040)])
	if J.t(J.gp(_s1040["__p"]["G"], "pdrops")):
		var _t2868 = _s1040["__p"]["G"]
		var _t2869 = J.gp(_s1040["__p"]["G"], "pdrops")
		var _t2870 = J.mc(_t2869, "filter", [Callable(self, "_f447").bind(_s1040)])
		J.sp(_t2868, "pdrops", _t2870)
	if J.t(_s1040["__p"]["SAFE"]):
		v_on_2758 = J.cl(_s1040["__p"]["safeOn"], null, [])
		var _t2871 = J.gp(_s1040["__p"]["SAFE"], "was")
		if J.t(((not J.t(v_on_2758)) if J.t(_t2871) else _t2871)):
			var _t2872 = _s1040["__p"]["float"]
			J.cl(_t2872, null, [J.gp(_s1040["__p"]["SAFE"], "x"), J.sub(J.gp(_s1040["__p"]["SAFE"], "y"), 110.0), "陰門一開，陰氣散晒——保安殺到！", "#d8b8ff"])
		var _t2873 = _s1040["__p"]["SAFE"]
		J.sp(_t2873, "was", v_on_2758)

func _f449(this_, a: Array, env):
	var v_d_2769 = null
	v_d_2769 = J.arg(a, 0)
	J.mc(env["ctx"], "save", [])
	var _t2876 = env["ctx"]
	var _t2877 = J.min_([1.0, J.div(J.gp(v_d_2769, "life"), 0.6)])
	J.sp(_t2876, "globalAlpha", _t2877)
	J.mc(env["ctx"], "translate", [J.gp(v_d_2769, "x"), J.gp(v_d_2769, "y")])
	J.mc(env["ctx"], "rotate", [J.gp(v_d_2769, "rot")])
	var _t2878 = env["ctx"]
	J.sp(_t2878, "lineWidth", 1.5)
	var _t2879 = env["ctx"]
	J.sp(_t2879, "strokeStyle", "#1a1418")
	if J.seq(J.gp(v_d_2769, "k"), "cup"):
		var _t2880 = env["ctx"]
		J.sp(_t2880, "fillStyle", "#e8e2d4")
		J.mc(env["ctx"], "fillRect", [(-4.0), (-5.0), 8.0, 9.0])
		J.mc(env["ctx"], "strokeRect", [(-4.0), (-5.0), 8.0, 9.0])
		J.mc(env["ctx"], "beginPath", [])
		J.mc(env["ctx"], "arc", [5.0, (-1.0), 3.0, (-1.4), 1.4])
		J.mc(env["ctx"], "stroke", [])
	else:
		if J.seq(J.gp(v_d_2769, "k"), "tile"):
			var _t2881 = env["ctx"]
			J.sp(_t2881, "fillStyle", "#f2efe2")
			J.mc(env["ctx"], "fillRect", [(-4.0), (-6.0), 8.0, 11.0])
			J.mc(env["ctx"], "strokeRect", [(-4.0), (-6.0), 8.0, 11.0])
			var _t2882 = env["ctx"]
			J.sp(_t2882, "fillStyle", "#3a8a5a")
			J.mc(env["ctx"], "fillRect", [(-2.0), (-3.0), 4.0, 4.0])
		else:
			if J.seq(J.gp(v_d_2769, "k"), "bowl"):
				var _t2883 = env["ctx"]
				J.sp(_t2883, "fillStyle", "#f0e8d8")
				J.mc(env["ctx"], "beginPath", [])
				J.mc(env["ctx"], "arc", [0.0, (-2.0), 6.0, 0.0, PI])
				J.mc(env["ctx"], "closePath", [])
				J.mc(env["ctx"], "fill", [])
				J.mc(env["ctx"], "stroke", [])
			else:
				if J.seq(J.gp(v_d_2769, "k"), "pad"):
					var _t2884 = env["ctx"]
					J.sp(_t2884, "fillStyle", "#2a2a34")
					J.mc(env["ctx"], "fillRect", [(-7.0), (-3.0), 14.0, 7.0])
					J.mc(env["ctx"], "strokeRect", [(-7.0), (-3.0), 14.0, 7.0])
				else:
					if J.seq(J.gp(v_d_2769, "k"), "fan"):
						var _t2885 = env["ctx"]
						J.sp(_t2885, "fillStyle", "#d8c08a")
						J.mc(env["ctx"], "beginPath", [])
						J.mc(env["ctx"], "moveTo", [0.0, 4.0])
						J.mc(env["ctx"], "arc", [0.0, 4.0, 10.0, (-2.6), (-0.5)])
						J.mc(env["ctx"], "closePath", [])
						J.mc(env["ctx"], "fill", [])
						J.mc(env["ctx"], "stroke", [])
					else:
						var _t2886 = env["ctx"]
						J.sp(_t2886, "fillStyle", "#c89a5a")
						J.mc(env["ctx"], "fillRect", [(-6.0), (-5.0), 12.0, 10.0])
						J.mc(env["ctx"], "strokeRect", [(-6.0), (-5.0), 12.0, 10.0])
	J.mc(env["ctx"], "restore", [])

func _f448(this_, a: Array, env):
	var _t2874 = J.gp(env["G"], "pdrops")
	var _t2875 = (_t2874 if J.t(_t2874) else [])
	J.mc(_t2875, "forEach", [Callable(self, "_f449").bind(env)])

func _f450(this_, a: Array, env):
	var v_on_2772 = null; var v_A0_2773 = null; var v_x_2774 = null; var v_y_2775 = null; var v_R_2776 = null; var v_gr_2777 = null; var v_k_2778 = null; var v_u_2779 = null; var v_px_2780 = null; var v_py_2781 = null
	if (not J.t(env["SAFE"])):
		return null
	v_on_2772 = J.cl(env["safeOn"], null, [])
	var _t2887 = env["SAFE"]
	var _t2888 = J.add(J.gp(_t2887, "a"), (J.sub((1.0 if J.t(v_on_2772) else 0.0), J.gp(env["SAFE"], "a")) * 0.06))
	J.sp(_t2887, "a", _t2888)
	v_A0_2773 = J.gp(env["SAFE"], "a")
	if J.cmp(v_A0_2773, 0.02, "<"):
		return null
	v_x_2774 = J.gp(env["SAFE"], "x")
	v_y_2775 = J.gp(env["SAFE"], "y")
	v_R_2776 = J.gp(env["SAFE"], "r")
	J.mc(env["ctx"], "save", [])
	v_gr_2777 = J.mc(env["ctx"], "createRadialGradient", [v_x_2774, J.sub(v_y_2775, 6.0), 6.0, v_x_2774, J.sub(v_y_2775, 6.0), v_R_2776])
	J.mc(v_gr_2777, "addColorStop", [0.0, (J.add("rgba(150,95,205,", J.mul(0.24, v_A0_2773)) + ")")])
	J.mc(v_gr_2777, "addColorStop", [0.65, (J.add("rgba(125,75,185,", J.mul(0.11, v_A0_2773)) + ")")])
	J.mc(v_gr_2777, "addColorStop", [1.0, "rgba(110,60,170,0)"])
	var _t2889 = env["ctx"]
	J.sp(_t2889, "fillStyle", v_gr_2777)
	J.mc(env["ctx"], "beginPath", [])
	J.mc(env["ctx"], "ellipse", [v_x_2774, J.sub(v_y_2775, 5.0), v_R_2776, 20.0, 0.0, 0.0, 7.0])
	J.mc(env["ctx"], "fill", [])
	v_k_2778 = 0.0
	while true:
		if not J.cmp(v_k_2778, 7.0, "<"): break
		v_u_2779 = J.div(J.mod((J.mul(J.gp(env["G"], "t"), 8.0) + J.mul(v_k_2778, 13.0)), 46.0), 46.0)
		v_px_2780 = J.add(v_x_2774, (J.mul(sin(J.num((J.mul(J.gp(env["G"], "t"), 0.45) + J.mul(v_k_2778, 2.1)))), v_R_2776) * 0.78))
		v_py_2781 = (J.sub(v_y_2775, 8.0) - J.mul(v_u_2779, 46.0))
		var _t2890 = env["ctx"]
		var _t2891 = (J.add("rgba(190,150,235,", J.mul((J.sub(1.0, v_u_2779) * 0.15), v_A0_2773)) + ")")
		J.sp(_t2890, "fillStyle", _t2891)
		J.mc(env["ctx"], "beginPath", [])
		J.mc(env["ctx"], "ellipse", [v_px_2780, v_py_2781, (18.0 + (J.mod(v_k_2778, 3.0) * 7.0)), 4.5, 0.0, 0.0, 7.0])
		J.mc(env["ctx"], "fill", [])
		v_k_2778 = J.num(v_k_2778) + 1.0
	var _t2892 = env["ctx"]
	var _t2893 = (J.add("rgba(195,160,240,", J.mul(0.2, v_A0_2773)) + ")")
	J.sp(_t2892, "strokeStyle", _t2893)
	J.mc(env["ctx"], "setLineDash", [[5.0, 7.0]])
	var _t2894 = env["ctx"]
	J.sp(_t2894, "lineWidth", 1.5)
	J.mc(env["ctx"], "beginPath", [])
	J.mc(env["ctx"], "ellipse", [v_x_2774, J.sub(v_y_2775, 5.0), v_R_2776, 13.0, 0.0, 0.08, (PI - 0.08)])
	J.mc(env["ctx"], "stroke", [])
	J.mc(env["ctx"], "setLineDash", [[]])
	var _t2895 = env["ctx"]
	var _t2896 = J.mul(0.5, v_A0_2773)
	J.sp(_t2895, "globalAlpha", _t2896)
	var _t2897 = env["ctx"]
	var _t2898 = J.add("bold 10px ", env["FONT"])
	J.sp(_t2897, "font", _t2898)
	var _t2899 = env["ctx"]
	J.sp(_t2899, "textAlign", "center")
	var _t2900 = env["ctx"]
	J.sp(_t2900, "lineWidth", 3.0)
	var _t2901 = env["ctx"]
	J.sp(_t2901, "strokeStyle", "#120c16")
	J.mc(env["ctx"], "strokeText", ["陰氣地・保安止步", v_x_2774, J.add(v_y_2775, 14.0)])
	var _t2902 = env["ctx"]
	J.sp(_t2902, "fillStyle", "#d6c0f2")
	J.mc(env["ctx"], "fillText", ["陰氣地・保安止步", v_x_2774, J.add(v_y_2775, 14.0)])
	J.mc(env["ctx"], "restore", [])

func _f468(this_, a: Array, env):
	var v_r_2913 = null; var v_viewW_2914 = null; var v_viewH_2915 = null; var v_home_2916 = null; var v_F_2917 = null; var v_flee_2918 = null; var v_scared_2919 = null; var v_k2_2920 = null; var v_H_2921 = null; var v_art_2922 = null; var v_jy_2923 = null; var v_sh_2924 = null; var v_ro_2925 = null; var v_sy_2926 = null; var v_sx_2927 = null; var v_flip_2928 = null; var v_tint_2929 = null; var v_arms_2930 = null; var v_S0_2931 = null; var v_T0_2932 = null; var v_P_2933 = null; var v_by_2934 = null; var v_top_2935 = null
	v_r_2913 = J.arg(a, 0)
	v_viewW_2914 = J.arg(a, 1)
	v_viewH_2915 = J.arg(a, 2)
	var _t2903 = J.seq(J.gp(v_r_2913, "state"), "gone")
	if (_t2903 if _t2903 else J.seq(J.gp(v_r_2913, "state"), "away")):
		return null
	var _t2904 = J.cmp(J.gp(v_r_2913, "x"), J.sub(J.gp(env["cam"], "x"), 60.0), "<")
	var _t2905 = (_t2904 if _t2904 else J.cmp(J.gp(v_r_2913, "x"), J.add(J.add(J.gp(env["cam"], "x"), v_viewW_2914), 60.0), ">"))
	var _t2906 = (_t2905 if _t2905 else J.cmp(J.gp(v_r_2913, "y"), J.sub(J.gp(env["cam"], "y"), 20.0), "<"))
	if (_t2906 if _t2906 else J.cmp(J.gp(v_r_2913, "y"), J.add(J.add(J.gp(env["cam"], "y"), v_viewH_2915), 120.0), ">")):
		return null
	var _t2907 = J.seq(J.gp(v_r_2913, "state"), "leave")
	if (_t2907 if _t2907 else J.seq(J.gp(v_r_2913, "state"), "back")):
		var _t2908 = J.gp(v_r_2913, "vx")
		var _t2909 = (_t2908 if J.t(_t2908) else 1.0)
		J.sp(v_r_2913, "vx", _t2909)
	v_home_2916 = J.seq(J.gp(v_r_2913, "state"), "home")
	var _t2910 = J.gp(v_r_2913, "fear")
	v_F_2917 = (_t2910 if J.t(_t2910) else 0.0)
	v_flee_2918 = J.seq(J.gp(v_r_2913, "state"), "flee")
	var _t2911 = J.cmp(J.gp(v_r_2913, "shockT"), 0.0, ">")
	v_scared_2919 = (_t2911 if _t2911 else v_flee_2918)
	v_k2_2920 = J.mc(env["PPLFX"], "key", [J.gp(v_r_2913, "sprite"), v_scared_2919])
	var _t2913 = J.gp(v_r_2913, "sprite")
	var _t2912 = J.gp(v_r_2913, "h")
	v_H_2921 = J.mc(env["PPLFX"], "hgt", [_t2913, v_k2_2920, (_t2912 if J.t(_t2912) else 58.0)])
	v_art_2922 = (not J.seq(v_k2_2920, J.gp(v_r_2913, "sprite")))
	var _t2914 = env["ctx"]
	J.sp(_t2914, "fillStyle", "rgba(0,0,0,0.45)")
	J.mc(env["ctx"], "beginPath", [])
	J.mc(env["ctx"], "ellipse", [J.gp(v_r_2913, "x"), J.sub(J.gp(v_r_2913, "y"), 1.0), (20.0 if J.t(J.mc(env["PPLFX"], "chibi", [J.gp(v_r_2913, "sprite")])) else 16.0), 4.0, 0.0, 0.0, 7.0])
	J.mc(env["ctx"], "fill", [])
	v_jy_2923 = 0.0
	v_sh_2924 = 0.0
	v_ro_2925 = 0.0
	v_sy_2926 = 1.0
	v_sx_2927 = 1.0
	v_flip_2928 = J.cmp(J.gp(v_r_2913, "vx"), 0.0, "<")
	v_tint_2929 = 0.0
	v_arms_2930 = false
	if J.cmp(J.gp(v_r_2913, "shockT"), 0.0, ">"):
		var _t2916 = J.gp(v_r_2913, "shockT")
		var _t2915 = J.gp(v_r_2913, "shockA")
		v_S0_2931 = J.mc(env["PPLFX"], "shock", [_t2916, (_t2915 if J.t(_t2915) else 1.0)])
		v_sx_2927 = J.gp(v_S0_2931, "sx")
		v_sy_2926 = J.gp(v_S0_2931, "sy")
		var _t2917 = J.mul(J.gp(v_S0_2931, "jy"), v_H_2921)
		v_jy_2923 = _t2917
		var _t2918 = J.mul(J.gp(v_S0_2931, "sh"), v_H_2921)
		v_sh_2924 = _t2918
		var _t2919 = J.mul(J.gp(v_S0_2931, "tint"), (0.18 if J.t(v_art_2922) else 0.7))
		v_tint_2929 = _t2919
	else:
		var _t2920 = (J.gp(v_r_2913, "awake") if J.t(v_home_2916) else v_home_2916)
		if J.t((J.cmp(v_F_2917, 55.0, ">=") if J.t(_t2920) else _t2920)):
			v_T0_2932 = J.mc(env["PPLFX"], "tremble", [v_r_2913, J.gp(env["G"], "t")])
			var _t2921 = J.mul(J.gp(v_T0_2932, "sh"), v_H_2921)
			v_sh_2924 = _t2921
			v_sy_2926 = J.gp(v_T0_2932, "sy")
			if (not J.leq(J.gp(v_T0_2932, "flip"), null)):
				v_flip_2928 = J.gp(v_T0_2932, "flip")
			v_tint_2929 = J.gp(v_T0_2932, "tint")
		else:
			if J.t((J.cmp(v_F_2917, 60.0, ">") if J.t(v_home_2916) else v_home_2916)):
				var _t2922 = (sin(J.num(J.mul(J.gp(env["G"], "t"), 40.0))) * 1.6)
				v_sh_2924 = _t2922
	if J.t(v_flee_2918):
		if J.cmp(J.gp(v_r_2913, "tripT"), 0.0, ">"):
			var _t2923 = ((1.0 if J.cmp(J.gp(v_r_2913, "vx"), 0.0, ">") else (-1.0)) * 1.25)
			v_ro_2925 = _t2923
			v_jy_2923 = (-6.0)
		else:
			var _t2924 = ((-absf(J.num(sin(J.num(J.mul(J.gp(v_r_2913, "x"), 0.12)))))) * 7.0)
			v_jy_2923 = _t2924
			var _t2925 = ((1.0 if J.cmp(J.gp(v_r_2913, "vx"), 0.0, ">") else (-1.0)) * 0.18)
			v_ro_2925 = _t2925
			v_arms_2930 = (not J.t(v_art_2922))
		var _t2926 = J.max_([v_tint_2929, (0.0 if J.t(v_art_2922) else 0.15)])
		v_tint_2929 = _t2926
	if J.cmp(J.gp(v_r_2913, "tangle"), 0.0, ">"):
		var _t2927 = J.add(v_sh_2924, (sin(J.num(J.mul(J.gp(env["G"], "t"), 30.0))) * 2.0))
		v_sh_2924 = _t2927
		var _t2928 = J.mul(v_sy_2926, 0.96)
		v_sy_2926 = _t2928
	var _t2929 = J.seq(J.gp(v_r_2913, "state"), "leave")
	if (_t2929 if _t2929 else J.seq(J.gp(v_r_2913, "state"), "back")):
		var _t2930 = ((-absf(J.num(sin(J.num(J.mul(J.gp(v_r_2913, "x"), 0.2)))))) * 3.0)
		v_jy_2923 = _t2930
	var _t2931 = ((not J.t(J.gp(v_r_2913, "awake"))) if J.t(v_home_2916) else v_home_2916)
	if J.t(((not J.t(J.gp(v_r_2913, "react"))) if J.t(_t2931) else _t2931)):
		v_ro_2925 = (-1.45)
		v_jy_2923 = (-8.0)
		var _t2932 = env["ctx"]
		J.sp(_t2932, "fillStyle", "rgba(200,220,255,0.8)")
		var _t2933 = env["ctx"]
		var _t2934 = J.add("bold 12px ", env["FONT"])
		J.sp(_t2933, "font", _t2934)
		var _t2935 = env["ctx"]
		J.sp(_t2935, "textAlign", "center")
		J.mc(env["ctx"], "fillText", ["Z", J.add(J.gp(v_r_2913, "x"), 18.0), (J.sub(J.gp(v_r_2913, "y"), 30.0) - J.mod(J.mul(J.gp(env["G"], "t"), 12.0), 10.0))])
		var _t2936 = env["ctx"]
		var _t2937 = J.add("bold 9px ", env["FONT"])
		J.sp(_t2936, "font", _t2937)
		J.mc(env["ctx"], "fillText", ["z", J.add(J.gp(v_r_2913, "x"), 26.0), (J.sub(J.gp(v_r_2913, "y"), 40.0) - J.mod((J.mul(J.gp(env["G"], "t"), 12.0) + 5.0), 10.0))])
	v_P_2933 = {"sh": 0.0, "jy": 0.0, "ro": 0.0, "sy": 1.0}
	var _t2938 = env["reactPose"]
	J.cl(_t2938, null, [v_r_2913, v_P_2933])
	var _t2939 = J.add(v_sh_2924, J.gp(v_P_2933, "sh"))
	v_sh_2924 = _t2939
	var _t2940 = J.add(v_jy_2923, J.gp(v_P_2933, "jy"))
	v_jy_2923 = _t2940
	var _t2941 = J.add(v_ro_2925, J.gp(v_P_2933, "ro"))
	v_ro_2925 = _t2941
	var _t2942 = J.mul(v_sy_2926, J.gp(v_P_2933, "sy"))
	v_sy_2926 = _t2942
	var _t2944 = J.add(J.gp(v_r_2913, "y"), v_jy_2923)
	var _t2943 = J.gp(v_r_2913, "dy")
	v_by_2934 = J.add(_t2944, (_t2943 if J.t(_t2943) else 0.0))
	if J.t(v_arms_2930):
		J.mc(env["PPLFX"], "arms", [env["ctx"], J.add(J.gp(v_r_2913, "x"), v_sh_2924), v_by_2934, v_H_2921, (1.0 if J.cmp(J.gp(v_r_2913, "vx"), 0.0, ">") else (-1.0)), J.gp(env["G"], "t")])
	var _t2945 = env["ctx"]
	J.sp(_t2945, "shadowColor", "rgba(255,236,200,0.75)")
	var _t2946 = env["ctx"]
	J.sp(_t2946, "shadowBlur", 5.0)
	J.mc(env["PPLFX"], "draw", [env["ctx"], J.gp(v_r_2913, "sprite"), v_k2_2920, J.add(J.gp(v_r_2913, "x"), v_sh_2924), v_by_2934, v_H_2921, {"flip": v_flip_2928, "rot": v_ro_2925, "sx": v_sx_2927, "sy": v_sy_2926, "tint": v_tint_2929}])
	var _t2947 = env["ctx"]
	J.sp(_t2947, "shadowBlur", 0.0)
	var _t2948 = env["reactProps"]
	J.cl(_t2948, null, [v_r_2913, v_P_2933])
	v_top_2935 = J.sub(v_by_2934, J.mul(v_H_2921, J.min_([1.0, v_sy_2926])))
	if J.cmp(J.gp(v_r_2913, "shockT"), 0.0, ">"):
		J.mc(env["PPLFX"], "bang", [env["ctx"], J.add(J.add(J.gp(v_r_2913, "x"), v_sh_2924), (0.0 if J.t(v_art_2922) else 4.0)), J.sub(v_top_2935, 8.0), (1.0 - J.div(J.gp(v_r_2913, "shockT"), 0.9)), 0.9])
	else:
		if J.t(((not J.t(J.gp(v_r_2913, "tripT"))) if J.t(v_flee_2918) else v_flee_2918)):
			J.mc(env["PPLFX"], "bang", [env["ctx"], J.gp(v_r_2913, "x"), J.sub(v_top_2935, 6.0), 0.5, 0.7])
	if J.t((J.cmp(v_F_2917, 0.0, ">") if J.t(v_home_2916) else v_home_2916)):
		var _t2949 = env["crBar"]
		J.cl(_t2949, null, [env["ctx"], J.sub(J.gp(v_r_2913, "x"), 20.0), J.sub(v_top_2935, 10.0), 40.0, 7.0, J.div(v_F_2917, 100.0), "red"])
	if J.t(J.gp(v_r_2913, "scream")):
		J.mc(env["PPLFX"], "scream", [env["ctx"], J.gp(v_r_2913, "x"), J.sub(v_top_2935, 16.0), J.gp(v_r_2913, "scream"), 1.0])
	if J.t(J.gp(v_r_2913, "say")):
		var _t2950 = env["bubble"]
		J.cl(_t2950, null, [J.gp(v_r_2913, "x"), (J.sub(v_top_2935, 12.0) - (6.0 if J.t((J.cmp(v_F_2917, 0.0, ">") if J.t(v_home_2916) else v_home_2916)) else 0.0)), J.gp(v_r_2913, "say")])

func _f469(this_, a: Array, env):
	var v_s_2938 = null; var v_d_2939 = null; var v_run_2940 = null
	v_s_2938 = J.arg(a, 0)
	v_d_2939 = (0.0 if J.leq(J.gp(v_s_2938, "_lx"), null) else J.hypot_([J.sub(J.gp(v_s_2938, "x"), J.gp(v_s_2938, "_lx")), J.sub(J.gp(v_s_2938, "y"), J.gp(v_s_2938, "_ly"))]))
	var _t2951 = J.gp(v_s_2938, "x")
	J.sp(v_s_2938, "_lx", _t2951)
	var _t2952 = J.gp(v_s_2938, "y")
	J.sp(v_s_2938, "_ly", _t2952)
	if J.cmp(v_d_2939, 40.0, ">"):
		v_d_2939 = 0.0
	var _t2955 = J.seq(J.gp(v_s_2938, "state"), "flee")
	if not J.t(_t2955):
		var _t2954 = J.seq(J.gp(v_s_2938, "state"), "scared")
		if J.t(_t2954):
			var _t2953 = J.gp(v_s_2938, "scT")
			_t2954 = J.cmp((_t2953 if J.t(_t2953) else 0.0), 1.7, "<")
		_t2955 = _t2954
	v_run_2940 = _t2955
	var _t2956 = J.gp(v_s_2938, "stepPh")
	var _t2957 = J.add((_t2956 if J.t(_t2956) else 0.0), J.div(J.mul(v_d_2939, PI), (26.0 if J.t(v_run_2940) else 17.0)))
	J.sp(v_s_2938, "stepPh", _t2957)
	if J.cmp(v_d_2939, 0.05, ">"):
		J.sp(v_s_2938, "mvT", 0.15)
	else:
		var _t2958 = J.gp(v_s_2938, "mvT")
		var _t2959 = J.gp(v_s_2938, "mvT")
		var _t2960 = J.max_([0.0, J.sub((_t2959 if J.t(_t2959) else 0.0), J.div(1.0, 60.0))])
		J.sp(v_s_2938, "mvT", _t2960)
	if J.cmp(J.gp(v_s_2938, "mvT"), 0.0, ">"):
		var _t2961 = (sin(J.num(J.gp(v_s_2938, "stepPh"))) * 0.035)
		J.sp(v_s_2938, "_sway", _t2961)
		return ((-absf(J.num(sin(J.num(J.gp(v_s_2938, "stepPh")))))) * (4.0 if J.t(v_run_2940) else 2.4))
	J.sp(v_s_2938, "_sway", 0.0)
	return ((sin(J.num(J.add(J.mul(J.gp(env["G"], "t"), 1.8), J.gp(v_s_2938, "x")))) * 0.6) - 0.6)

func _f470(this_, a: Array, env):
	var v_s_2943 = null; var v_H_2944 = null; var v_bob_2945 = null; var v_fl_2946 = null; var v_scared_2947 = null; var v_k2_2948 = null; var v_HH_2949 = null; var v_art_2950 = null; var v_sx_2951 = null; var v_sy_2952 = null; var v_jy_2953 = null; var v_sh_2954 = null; var v_ro_2955 = null; var v_tint_2956 = null; var v_S0_2957 = null; var v_top_2958 = null
	v_s_2943 = J.arg(a, 0)
	v_H_2944 = J.arg(a, 1)
	v_bob_2945 = J.arg(a, 2)
	v_fl_2946 = J.arg(a, 3)
	var _t2962 = J.cmp(J.gp(v_s_2943, "shockT"), 0.0, ">")
	var _t2963 = (_t2962 if _t2962 else J.seq(J.gp(v_s_2943, "state"), "scared"))
	v_scared_2947 = (_t2963 if _t2963 else J.seq(J.gp(v_s_2943, "state"), "flee"))
	v_k2_2948 = J.mc(env["PPLFX"], "key", [J.gp(v_H_2944, "spr"), v_scared_2947])
	v_HH_2949 = J.mc(env["PPLFX"], "hgt", [J.gp(v_H_2944, "spr"), v_k2_2948, J.gp(v_H_2944, "h")])
	v_art_2950 = (not J.seq(v_k2_2948, J.gp(v_H_2944, "spr")))
	v_sx_2951 = 1.0
	v_sy_2952 = 1.0
	v_jy_2953 = 0.0
	v_sh_2954 = 0.0
	var _t2964 = J.gp(v_s_2943, "_sway")
	v_ro_2955 = (_t2964 if J.t(_t2964) else 0.0)
	v_tint_2956 = 0.0
	if J.cmp(J.gp(v_s_2943, "shockT"), 0.0, ">"):
		v_S0_2957 = J.mc(env["PPLFX"], "shock", [J.gp(v_s_2943, "shockT"), 1.0])
		v_sx_2951 = J.gp(v_S0_2957, "sx")
		v_sy_2952 = J.gp(v_S0_2957, "sy")
		var _t2965 = J.mul(J.gp(v_S0_2957, "jy"), v_HH_2949)
		v_jy_2953 = _t2965
		var _t2966 = J.mul(J.gp(v_S0_2957, "sh"), v_HH_2949)
		v_sh_2954 = _t2966
		var _t2967 = J.mul(J.gp(v_S0_2957, "tint"), (0.18 if J.t(v_art_2950) else 0.7))
		v_tint_2956 = _t2967
	else:
		if J.seq(J.gp(v_s_2943, "state"), "scared"):
			var _t2968 = (sin(J.num(J.add(J.mul(J.gp(env["G"], "t"), 45.0), J.gp(v_s_2943, "x")))) * 1.3)
			v_sh_2954 = _t2968
			v_sy_2952 = 0.95
			v_tint_2956 = 0.22
	if J.seq(J.gp(v_s_2943, "state"), "flee"):
		var _t2969 = (0.2 if J.cmp(J.gp(v_s_2943, "vx"), 0.0, ">") else (-0.2))
		v_ro_2955 = _t2969
		var _t2970 = J.max_([v_tint_2956, (0.0 if J.t(v_art_2950) else 0.15)])
		v_tint_2956 = _t2970
		if (not J.t(v_art_2950)):
			J.mc(env["PPLFX"], "arms", [env["ctx"], J.gp(v_s_2943, "x"), J.add(J.add(J.gp(v_s_2943, "y"), v_bob_2945), v_jy_2953), v_HH_2949, (1.0 if J.cmp(J.gp(v_s_2943, "vx"), 0.0, ">") else (-1.0)), J.gp(env["G"], "t")])
	J.mc(env["PPLFX"], "draw", [env["ctx"], J.gp(v_H_2944, "spr"), v_k2_2948, J.add(J.gp(v_s_2943, "x"), v_sh_2954), J.add(J.add(J.gp(v_s_2943, "y"), v_bob_2945), v_jy_2953), v_HH_2949, {"flip": v_fl_2946, "alpha": (0.88 if J.seq(J.gp(v_s_2943, "kind"), "decoy") else 1.0), "rot": v_ro_2955, "sx": v_sx_2951, "sy": v_sy_2952, "tint": v_tint_2956}])
	v_top_2958 = J.sub(J.add(J.add(J.gp(v_s_2943, "y"), v_bob_2945), v_jy_2953), J.mul(v_HH_2949, J.min_([1.0, v_sy_2952])))
	if J.cmp(J.gp(v_s_2943, "shockT"), 0.0, ">"):
		J.mc(env["PPLFX"], "bang", [env["ctx"], J.add(J.gp(v_s_2943, "x"), v_sh_2954), J.sub(v_top_2958, 8.0), (1.0 - J.div(J.gp(v_s_2943, "shockT"), 0.9)), 0.9])
	if J.t(J.gp(v_s_2943, "scream")):
		J.mc(env["PPLFX"], "scream", [env["ctx"], J.gp(v_s_2943, "x"), J.sub(v_top_2958, 34.0), J.gp(v_s_2943, "scream"), 1.0])

func _f472(this_, a: Array, env):
	var v_g_2966 = null; var v_d_2967 = null
	v_g_2966 = J.arg(a, 0)
	var _t2972 = J.gp(v_g_2966, "home")
	var _t2973 = (_t2972 if J.t(_t2972) else J.gp(v_g_2966, "out"))
	var _t2975 = (_t2973 if J.t(_t2973) else J.cmp(J.gp(v_g_2966, "inv"), 0.0, ">"))
	if not J.t(_t2975):
		var _t2974 = env["__p"]["inSafe"]
		_t2975 = J.cl(_t2974, null, [v_g_2966])
	if J.t(_t2975):
		return null
	v_d_2967 = (absf(J.num(J.sub(J.gp(v_g_2966, "x"), J.gp(env["h"], "x")))) + (absf(J.num(J.sub(J.gp(v_g_2966, "y"), J.gp(env["h"], "y")))) * 1.5))
	if J.cmp(v_d_2967, env["bd"], "<"):
		env["bd"] = v_d_2967
		env["best"] = v_g_2966

func _f471(this_, a: Array, env):
	var _s1097 = {"__p": env, "h": null, "best": null, "bd": null}
	_s1097["h"] = J.arg(a, 0)
	_s1097["best"] = null
	_s1097["bd"] = 1000000000.0
	var _t2971 = J.gp(_s1097["__p"]["G"], "gh")
	J.mc(_t2971, "forEach", [Callable(self, "_f472").bind(_s1097)])
	return _s1097["best"]

func _f474(this_, a: Array, env):
	var v_l_2999 = null; var v_m_3000 = null
	v_l_2999 = J.arg(a, 0)
	v_m_3000 = J.gp(J.gp(env["__p"]["G"], "nodes"), J.gp(v_l_2999, "to"))
	var _t3167 = (not J.seq(J.gp(v_m_3000, "kind"), "in"))
	var _t3169 = ((not J.seq(J.gp(v_m_3000, "kind"), "portal")) if _t3167 else _t3167)
	if J.t(_t3169):
		var _t3168 = env["__p"]["safeNode"]
		_t3169 = (not J.t(J.cl(_t3168, null, [J.gp(v_l_2999, "to")])))
	var _t3171 = _t3169
	if J.t(_t3171):
		var _t3170 = env["__p"]["humanPass"]
		_t3171 = J.cl(_t3170, null, [env["h"], J.gp(v_l_2999, "e")])
	var _t3176 = _t3171
	if J.t(_t3176):
		var _t3172 = env["__p"]["inZone"]
		var _t3175 = J.cl(_t3172, null, [env["h"], J.gp(v_m_3000, "f")])
		if not J.t(_t3175):
			var _t3173 = env["__p"]["inZone"]
			var _t3174 = (not J.t(J.cl(_t3173, null, [env["h"], J.gp(env["n"], "f")])))
			_t3175 = ((absf(J.num(J.sub(J.gp(v_m_3000, "f"), env["zm"]))) < absf(J.num(J.sub(J.gp(env["n"], "f"), env["zm"])))) if _t3174 else _t3174)
		_t3176 = _t3175
	return _t3176

func _f475(this_, a: Array, env):
	var v_g_3003 = null
	v_g_3003 = J.arg(a, 0)
	var _t3204 = J.gp(v_g_3003, "home")
	var _t3205 = (_t3204 if J.t(_t3204) else J.gp(v_g_3003, "out"))
	var _t3206 = (_t3205 if J.t(_t3205) else J.cmp(J.gp(v_g_3003, "inv"), 0.0, ">"))
	var _t3208 = (_t3206 if J.t(_t3206) else J.cmp(J.gp(v_g_3003, "stun"), 0.0, ">"))
	if not J.t(_t3208):
		var _t3207 = J.gp(env["h"], "catchCd")
		_t3208 = J.cmp((_t3207 if J.t(_t3207) else 0.0), 0.0, ">")
	var _t3210 = _t3208
	if not J.t(_t3210):
		var _t3209 = env["__p"]["inSafe"]
		_t3210 = J.cl(_t3209, null, [v_g_3003])
	if J.t(_t3210):
		return null
	var _t3211 = (absf(J.num(J.sub(J.gp(v_g_3003, "y"), J.gp(env["h"], "y")))) > 30.0)
	if (_t3211 if _t3211 else (absf(J.num(J.sub(J.gp(v_g_3003, "x"), J.gp(env["h"], "x")))) > 18.0)):
		return null
	if J.seq(J.gp(env["h"], "kind"), "dog"):
		J.sp(v_g_3003, "stun", 1.0)
		var _t3212 = env["__p"]["G"]
		var _t3213 = J.add(J.gp(_t3212, "alert"), 1.0)
		J.sp(_t3212, "alert", _t3213)
		J.cl(env["__p"]["checkAlert"], null, [])
		var _t3214 = env["__p"]["float"]
		J.cl(_t3214, null, [J.gp(v_g_3003, "x"), J.sub(J.gp(v_g_3003, "y"), 80.0), "狗吠到成棟樓醒晒！", "#ffb0b0"])
		var _t3215 = env["h"]
		J.sp(_t3215, "catchCd", 2.0)
		return null
	var _t3216 = J.seq(J.gp(env["h"], "kind"), "decoy")
	if ((not J.t(J.gp(env["h"], "real"))) if _t3216 else _t3216):
		return null
	var _t3217 = J.seq(J.gp(env["h"], "kind"), "guard")
	if ((not J.seq(J.gp(env["h"], "state"), "chase")) if _t3217 else _t3217):
		return null
	var _t3218 = env["__p"]["catchGhost"]
	J.cl(_t3218, null, [v_g_3003, env["h"]])
	var _t3219 = env["h"]
	J.sp(_t3219, "catchCd", 2.2)

func _f473(this_, a: Array, env):
	var v_dt_2971 = null; var v_H_2972 = null; var v_bk_2973 = null; var v_nx_2974 = null; var v_nn_2975 = null; var v_q0_2976 = null; var v_a0_2977 = null; var v_b0_2978 = null; var v_D0_2979 = null; var v_p0_2980 = null; var v_tg0_2981 = null; var v_tg1_2982 = null; var v_tgS_2983 = null; var v_tg2_2984 = null; var v_far_2985 = null; var v_tg_2986 = null; var v_chaser_2987 = null; var v_tn_2988 = null; var v_opts_2991 = null; var v_a_2992 = null; var v_b_2993 = null; var v_D_2994 = null; var v_sp_2995 = null; var v_p_2996 = null
	var _s1100 = {"__p": env, "h": null, "n": null, "zm": null}
	_s1100["h"] = J.arg(a, 0)
	v_dt_2971 = J.arg(a, 1)
	v_H_2972 = J.gp(_s1100["__p"]["HUM"], J.gp(_s1100["h"], "kind"))
	var _t2976 = _s1100["h"]
	var _t2977 = J.max_([0.0, J.sub(J.gp(_s1100["h"], "alertT"), v_dt_2971)])
	J.sp(_t2976, "alertT", _t2977)
	var _t2978 = _s1100["h"]
	var _t2979 = J.gp(_s1100["h"], "shockT")
	var _t2980 = J.gp(_s1100["h"], "shockT")
	var _t2981 = J.max_([0.0, J.sub((_t2980 if J.t(_t2980) else 0.0), v_dt_2971)])
	J.sp(_t2978, "shockT", _t2981)
	if J.t(J.gp(_s1100["h"], "scream")):
		var _t2982 = J.gp(_s1100["h"], "scream")
		var _t2983 = J.sub(J.gp(_t2982, "T"), v_dt_2971)
		J.sp(_t2982, "T", _t2983)
		if J.cmp(J.gp(J.gp(_s1100["h"], "scream"), "T"), 0.0, "<="):
			var _t2984 = _s1100["h"]
			J.sp(_t2984, "scream", null)
	var _t2985 = _s1100["h"]
	var _t2986 = J.sub(J.gp(_t2985, "talkT"), v_dt_2971)
	J.sp(_t2985, "talkT", _t2986)
	if J.cmp(J.gp(_s1100["h"], "sayT"), 0.0, ">"):
		var _t2987 = _s1100["h"]
		var _t2988 = J.sub(J.gp(_t2987, "sayT"), v_dt_2971)
		J.sp(_t2987, "sayT", _t2988)
	else:
		var _t2989 = _s1100["h"]
		J.sp(_t2989, "say", null)
	if J.seq(J.gp(_s1100["h"], "state"), "flee"):
		var _t2990 = _s1100["__p"]["inSafeXY"]
		if J.t(J.cl(_t2990, null, [J.add(J.gp(_s1100["h"], "x"), J.mul(J.gp(_s1100["h"], "vx"), v_dt_2971)), J.gp(_s1100["h"], "y")])):
			var _t2991 = _s1100["h"]
			var _t2992 = J.mul(J.gp(_t2991, "vx"), (-1.0))
			J.sp(_t2991, "vx", _t2992)
		if (randf() < J.mul(v_dt_2971, 8.0)):
			var _t2993 = _s1100["__p"]["part"]
			J.cl(_t2993, null, [J.sub(J.gp(_s1100["h"], "x"), (signf(J.num(J.gp(_s1100["h"], "vx"))) * 10.0)), J.sub(J.gp(_s1100["h"], "y"), 4.0), ((-J.num(J.gp(_s1100["h"], "vx"))) * 0.1), (-10.0), 0.5, "dust"])
		var _t2994 = _s1100["h"]
		var _t2995 = J.add(J.gp(_t2994, "x"), J.mul(J.gp(_s1100["h"], "vx"), v_dt_2971))
		J.sp(_t2994, "x", _t2995)
		var _t2996 = J.cmp(J.gp(_s1100["h"], "x"), J.sub(_s1100["__p"]["SX"], 20.0), "<")
		if (_t2996 if _t2996 else J.cmp(J.gp(_s1100["h"], "x"), J.add(_s1100["__p"]["LX"], 20.0), ">")):
			var _t2997 = _s1100["h"]
			J.sp(_t2997, "state", "gone")
		return null
	if J.seq(J.gp(_s1100["h"], "state"), "scared"):
		var _t2998 = _s1100["h"]
		var _t2999 = J.sub(J.gp(_t2998, "scT"), v_dt_2971)
		J.sp(_t2998, "scT", _t2999)
		v_bk_2973 = J.cmp(J.gp(_s1100["h"], "scT"), 1.7, ">")
		if J.t(J.gp(_s1100["h"], "scAway")):
			var _t3000 = _s1100["h"]
			var _t3001 = J.mul(J.gp(_s1100["h"], "scAway"), (55.0 if J.t(v_bk_2973) else 95.0))
			J.sp(_t3000, "vx", _t3001)
			var _t3002 = _s1100["h"]
			var _t3003 = ((-J.num(J.gp(_s1100["h"], "scAway"))) if J.t(v_bk_2973) else J.gp(_s1100["h"], "scAway"))
			J.sp(_t3002, "dir", _t3003)
		v_nx_2974 = J.add(J.gp(_s1100["h"], "x"), J.mul(J.gp(_s1100["h"], "vx"), v_dt_2971))
		var _t3004 = J.cmp(v_nx_2974, _s1100["__p"]["SX"], "<")
		var _t3006 = (_t3004 if _t3004 else J.cmp(v_nx_2974, _s1100["__p"]["LX"], ">"))
		if not J.t(_t3006):
			var _t3005 = _s1100["__p"]["inSafeXY"]
			_t3006 = J.cl(_t3005, null, [v_nx_2974, J.gp(_s1100["h"], "y")])
		if J.t(_t3006):
			var _t3007 = _s1100["h"]
			var _t3008 = J.mul(J.gp(_t3007, "vx"), (-1.0))
			J.sp(_t3007, "vx", _t3008)
			if J.t(J.gp(_s1100["h"], "scAway")):
				var _t3009 = _s1100["h"]
				var _t3010 = J.mul(J.gp(_t3009, "scAway"), (-1.0))
				J.sp(_t3009, "scAway", _t3010)
		else:
			var _t3011 = _s1100["h"]
			J.sp(_t3011, "x", v_nx_2974)
		if J.cmp(J.gp(_s1100["h"], "scT"), 0.0, "<="):
			var _t3012 = _s1100["h"]
			J.sp(_t3012, "state", "patrol")
			var _t3013 = _s1100["__p"]["nearNodeH"]
			v_nn_2975 = J.cl(_t3013, null, [_s1100["h"]])
			var _t3014 = _s1100["h"]
			J.sp(_t3014, "node", v_nn_2975)
			var _t3015 = _s1100["h"]
			J.sp(_t3015, "to", null)
			var _t3016 = _s1100["h"]
			J.sp(_t3016, "p", 0.0)
			v_q0_2976 = J.gp(J.gp(_s1100["__p"]["G"], "nodes"), v_nn_2975)
			var _t3017 = _s1100["h"]
			var _t3018 = J.gp(v_q0_2976, "x")
			J.sp(_t3017, "x", _t3018)
			var _t3019 = _s1100["h"]
			var _t3020 = J.gp(v_q0_2976, "y")
			J.sp(_t3019, "y", _t3020)
		return null
	var _t3021 = J.seq(J.gp(_s1100["h"], "state"), "shift")
	if (_t3021 if _t3021 else J.seq(J.gp(_s1100["h"], "state"), "inv")):
		if (not J.t(J.gp(_s1100["h"], "to"))):
			var _t3022 = (not J.t(J.gp(_s1100["h"], "path")))
			if (_t3022 if _t3022 else (not J.t(J.len(J.gp(_s1100["h"], "path"))))):
				if J.seq(J.gp(_s1100["h"], "state"), "shift"):
					var _t3023 = _s1100["h"]
					J.sp(_t3023, "state", "gone")
					return null
				var _t3024 = _s1100["h"]
				J.sp(_t3024, "state", "puzzle")
				var _t3025 = _s1100["h"]
				J.sp(_t3025, "puzzleT", 3.5)
				var _t3026 = _s1100["h"]
				var _t3027 = _s1100["__p"]["pick"]
				var _t3028 = J.cl(_t3027, null, [["咩都冇喎……", "係咪我聽錯？", "奇怪……啱啱明明有聲"]])
				J.sp(_t3026, "say", _t3028)
				var _t3029 = _s1100["h"]
				J.sp(_t3029, "sayT", 2.4)
				return null
			var _t3030 = _s1100["h"]
			var _t3031 = J.mc(J.gp(_s1100["h"], "path"), "shift", [])
			J.sp(_t3030, "to", _t3031)
			var _t3032 = _s1100["h"]
			J.sp(_t3032, "p", 0.0)
		v_a0_2977 = J.gp(J.gp(_s1100["__p"]["G"], "nodes"), J.gp(_s1100["h"], "node"))
		v_b0_2978 = J.gp(J.gp(_s1100["__p"]["G"], "nodes"), J.gp(_s1100["h"], "to"))
		var _t3033 = _s1100["__p"]["humanPassTo"]
		if (not J.t(J.cl(_t3033, null, [_s1100["h"], v_a0_2977, v_b0_2978]))):
			var _t3034 = _s1100["h"]
			J.sp(_t3034, "to", null)
			var _t3035 = _s1100["h"]
			var _t3036 = _s1100["__p"]["dijkstra"]
			var _t3037 = J.cl(_t3036, null, [_s1100["h"], J.gp(_s1100["h"], "node"), ("f1_s" if J.seq(J.gp(_s1100["h"], "state"), "shift") else J.gp(_s1100["h"], "invNode"))])
			J.sp(_t3035, "path", _t3037)
			if (not J.t(J.gp(_s1100["h"], "path"))):
				var _t3038 = _s1100["h"]
				J.sp(_t3038, "state", "patrol")
			return null
		v_D0_2979 = J.max_([1.0, J.hypot_([J.sub(J.gp(v_b0_2978, "x"), J.gp(v_a0_2977, "x")), J.sub(J.gp(v_b0_2978, "y"), J.gp(v_a0_2977, "y"))])])
		var _t3039 = _s1100["h"]
		var _t3040 = J.add(J.gp(_t3039, "p"), J.div(J.mul(J.mul(J.gp(v_H_2972, "sp"), 0.7), v_dt_2971), v_D0_2979))
		J.sp(_t3039, "p", _t3040)
		if (not J.seq(J.gp(v_b0_2978, "x"), J.gp(v_a0_2977, "x"))):
			var _t3041 = _s1100["h"]
			var _t3042 = (1.0 if J.cmp(J.gp(v_b0_2978, "x"), J.gp(v_a0_2977, "x"), ">") else (-1.0))
			J.sp(_t3041, "dir", _t3042)
		if J.cmp(J.gp(_s1100["h"], "p"), 1.0, ">="):
			var _t3043 = _s1100["h"]
			var _t3044 = J.gp(_s1100["h"], "to")
			J.sp(_t3043, "node", _t3044)
			var _t3045 = _s1100["h"]
			J.sp(_t3045, "to", null)
			var _t3046 = _s1100["h"]
			J.sp(_t3046, "p", 0.0)
		var _t3047 = _s1100["__p"]["posOf"]
		v_p0_2980 = J.cl(_t3047, null, [_s1100["h"]])
		var _t3048 = _s1100["h"]
		var _t3049 = J.gp(v_p0_2980, "x")
		J.sp(_t3048, "x", _t3049)
		var _t3050 = _s1100["h"]
		var _t3051 = J.gp(v_p0_2980, "y")
		J.sp(_t3050, "y", _t3051)
		if J.seq(J.gp(_s1100["h"], "state"), "inv"):
			var _t3052 = _s1100["__p"]["nearestGhost"]
			v_tg0_2981 = J.cl(_t3052, null, [_s1100["h"]])
			var _t3053 = ((absf(J.num(J.sub(J.gp(v_tg0_2981, "y"), J.gp(_s1100["h"], "y")))) < 40.0) if J.t(v_tg0_2981) else v_tg0_2981)
			var _t3054 = ((J.mul(J.sub(J.gp(v_tg0_2981, "x"), J.gp(_s1100["h"], "x")), J.gp(_s1100["h"], "dir")) > 0.0) if J.t(_t3053) else _t3053)
			if J.t(((absf(J.num(J.sub(J.gp(v_tg0_2981, "x"), J.gp(_s1100["h"], "x")))) < 150.0) if J.t(_t3054) else _t3054)):
				var _t3055 = _s1100["h"]
				J.sp(_t3055, "state", "chase")
				var _t3056 = _s1100["h"]
				J.sp(_t3056, "alertT", 1.2)
				var _t3057 = _s1100["h"]
				var _t3058 = _s1100["__p"]["line"]
				var _t3059 = J.cl(_t3058, null, ["guardHit"])
				J.sp(_t3057, "say", _t3059)
				var _t3060 = _s1100["h"]
				J.sp(_t3060, "sayT", 2.0)
		return null
	if J.seq(J.gp(_s1100["h"], "state"), "balk"):
		var _t3061 = _s1100["h"]
		var _t3062 = J.sub(J.gp(_t3061, "balkT"), v_dt_2971)
		J.sp(_t3061, "balkT", _t3062)
		var _t3063 = J.cmp(J.gp(_s1100["h"], "balkT"), 1.3, "<")
		if ((not J.t(J.gp(_s1100["h"], "balkTurn"))) if _t3063 else _t3063):
			var _t3064 = _s1100["h"]
			J.sp(_t3064, "balkTurn", 1.0)
			var _t3065 = _s1100["h"]
			var _t3066 = (-J.num(J.gp(_s1100["h"], "dir")))
			J.sp(_t3065, "dir", _t3066)
		if J.cmp(J.gp(_s1100["h"], "balkT"), 0.0, "<="):
			var _t3067 = _s1100["h"]
			J.sp(_t3067, "state", "patrol")
			var _t3068 = _s1100["h"]
			J.sp(_t3068, "wait", 0.2)
			var _t3069 = _s1100["h"]
			J.sp(_t3069, "repath", 0.0)
			var _t3070 = _s1100["h"]
			J.sp(_t3070, "path", null)
			var _t3071 = _s1100["h"]
			J.sp(_t3071, "balkCd", 6.0)
		return null
	if J.seq(J.gp(_s1100["h"], "state"), "puzzle"):
		var _t3072 = _s1100["h"]
		var _t3073 = J.sub(J.gp(_t3072, "puzzleT"), v_dt_2971)
		J.sp(_t3072, "puzzleT", _t3073)
		var _t3074 = _s1100["h"]
		var _t3075 = (1.0 if J.t(J.mod(floor(J.num(J.mul(J.gp(_s1100["h"], "puzzleT"), 1.2))), 2.0)) else (-1.0))
		J.sp(_t3074, "dir", _t3075)
		var _t3076 = _s1100["__p"]["nearestGhost"]
		v_tg1_2982 = J.cl(_t3076, null, [_s1100["h"]])
		var _t3077 = ((absf(J.num(J.sub(J.gp(v_tg1_2982, "y"), J.gp(_s1100["h"], "y")))) < 40.0) if J.t(v_tg1_2982) else v_tg1_2982)
		var _t3078 = ((J.mul(J.sub(J.gp(v_tg1_2982, "x"), J.gp(_s1100["h"], "x")), J.gp(_s1100["h"], "dir")) > 0.0) if J.t(_t3077) else _t3077)
		if J.t(((absf(J.num(J.sub(J.gp(v_tg1_2982, "x"), J.gp(_s1100["h"], "x")))) < 130.0) if J.t(_t3078) else _t3078)):
			var _t3079 = _s1100["h"]
			J.sp(_t3079, "state", "chase")
			var _t3080 = _s1100["h"]
			J.sp(_t3080, "alertT", 1.2)
			var _t3081 = _s1100["h"]
			var _t3082 = _s1100["__p"]["line"]
			var _t3083 = J.cl(_t3082, null, ["guardHit"])
			J.sp(_t3081, "say", _t3083)
			var _t3084 = _s1100["h"]
			J.sp(_t3084, "sayT", 2.0)
		else:
			if J.cmp(J.gp(_s1100["h"], "puzzleT"), 0.0, "<="):
				var _t3085 = _s1100["h"]
				J.sp(_t3085, "state", "patrol")
				var _t3086 = _s1100["h"]
				J.sp(_t3086, "wait", 0.5)
		return null
	if J.seq(J.gp(_s1100["h"], "kind"), "collector"):
		return null
	var _t3087 = _s1100["__p"]["nearestAny"]
	v_tgS_2983 = J.cl(_t3087, null, [_s1100["h"]])
	var _t3088 = _s1100["h"]
	var _t3089 = J.gp(_s1100["h"], "balkCd")
	var _t3090 = J.gp(_s1100["h"], "balkCd")
	var _t3091 = J.max_([0.0, J.sub((_t3090 if J.t(_t3090) else 0.0), v_dt_2971)])
	J.sp(_t3088, "balkCd", _t3091)
	var _t3093 = v_tgS_2983
	if J.t(_t3093):
		var _t3092 = _s1100["__p"]["inSafe"]
		_t3093 = J.cl(_t3092, null, [v_tgS_2983])
	var _t3095 = ((not J.cmp(J.gp(_s1100["h"], "balkCd"), 0.0, ">")) if J.t(_t3093) else _t3093)
	if J.t(_t3095):
		var _t3094 = _s1100["__p"]["nearSafe"]
		_t3095 = J.cl(_t3094, null, [_s1100["h"]])
	var _t3100 = _t3095
	if J.t(_t3100):
		var _t3099 = J.seq(J.gp(_s1100["h"], "state"), "chase")
		if not J.t(_t3099):
			var _t3096 = (not J.seq(J.gp(_s1100["h"], "kind"), "guard"))
			var _t3098 = ((not J.seq(J.gp(_s1100["h"], "kind"), "collector")) if _t3096 else _t3096)
			if J.t(_t3098):
				var _t3097 = J.seq(J.gp(_s1100["h"], "kind"), "decoy")
				_t3098 = (not ((not J.t(J.gp(_s1100["h"], "real"))) if _t3097 else _t3097))
			_t3099 = _t3098
		_t3100 = _t3099
	if J.t(_t3100):
		var _t3101 = _s1100["__p"]["balk"]
		J.cl(_t3101, null, [_s1100["h"], (not J.seq(J.gp(_s1100["h"], "kind"), "dog"))])
		return null
	var _t3102 = J.seq(J.gp(_s1100["h"], "state"), "chase")
	var _t3104 = (v_tgS_2983 if _t3102 else _t3102)
	if J.t(_t3104):
		var _t3103 = _s1100["__p"]["inSafe"]
		_t3104 = J.cl(_t3103, null, [v_tgS_2983])
	if J.t(_t3104):
		var _t3105 = _s1100["__p"]["balk"]
		J.cl(_t3105, null, [_s1100["h"], false])
		return null
	if J.seq(J.gp(_s1100["h"], "state"), "chase"):
		var _t3106 = _s1100["__p"]["nearestGhost"]
		v_tg2_2984 = J.cl(_t3106, null, [_s1100["h"]])
		var _t3107 = (not J.t(v_tg2_2984))
		var _t3108 = (_t3107 if _t3107 else (absf(J.num(J.sub(J.gp(J.gp(J.gp(_s1100["__p"]["G"], "nodes"), J.gp(v_tg2_2984, "node")), "f"), J.gp(J.gp(J.gp(_s1100["__p"]["G"], "nodes"), J.gp(_s1100["h"], "node")), "f")))) >= 2.0))
		v_far_2985 = (_t3108 if _t3108 else (absf(J.num(J.sub(J.gp(v_tg2_2984, "x"), J.gp(_s1100["h"], "x")))) > 460.0))
		var _t3110 = v_tg2_2984
		if J.t(_t3110):
			var _t3109 = _s1100["__p"]["inZone"]
			_t3110 = (not J.t(J.cl(_t3109, null, [_s1100["h"], J.gp(J.gp(J.gp(_s1100["__p"]["G"], "nodes"), J.gp(v_tg2_2984, "node")), "f"), 1.0])))
		if J.t(_t3110):
			var _t3111 = _s1100["h"]
			var _t3112 = J.gp(_s1100["h"], "lostT")
			var _t3113 = J.add((_t3112 if J.t(_t3112) else 0.0), J.mul(v_dt_2971, 3.0))
			J.sp(_t3111, "lostT", _t3113)
		var _t3114 = _s1100["h"]
		var _t3116 = null
		if J.t(v_far_2985):
			var _t3115 = J.gp(_s1100["h"], "lostT")
			_t3116 = J.add((_t3115 if J.t(_t3115) else 0.0), v_dt_2971)
		else:
			_t3116 = 0.0
		J.sp(_t3114, "lostT", _t3116)
		if J.cmp(J.gp(_s1100["h"], "lostT"), 8.0, ">"):
			var _t3117 = _s1100["h"]
			J.sp(_t3117, "state", "patrol")
			var _t3118 = _s1100["h"]
			J.sp(_t3118, "lostT", 0.0)
			var _t3119 = _s1100["h"]
			J.sp(_t3119, "path", null)
			var _t3120 = _s1100["h"]
			var _t3121 = _s1100["__p"]["pick"]
			var _t3122 = J.cl(_t3121, null, [["走甩咗……", "跑得咁快？算數", "嗰樣嘢去咗邊？"]])
			J.sp(_t3120, "say", _t3122)
			var _t3123 = _s1100["h"]
			J.sp(_t3123, "sayT", 2.2)
	var _t3124 = J.cmp(J.gp(_s1100["h"], "talkT"), 0.0, "<=")
	if ((not J.seq(J.gp(_s1100["h"], "kind"), "dog")) if _t3124 else _t3124):
		var _t3125 = _s1100["h"]
		var _t3130 = null
		if J.seq(J.gp(_s1100["h"], "kind"), "guard"):
			var _t3126 = _s1100["__p"]["line"]
			_t3130 = J.cl(_t3126, null, ["guard"])
		else:
			var _t3129 = null
			if J.seq(J.gp(_s1100["h"], "kind"), "compass"):
				var _t3127 = _s1100["__p"]["pick"]
				_t3129 = J.cl(_t3127, null, [["羅盤指住呢邊……", "針震緊，有嘢喺附近"]])
			else:
				var _t3128 = _s1100["__p"]["pick"]
				_t3129 = J.cl(_t3128, null, [["照妖鏡在此，莫要亂來", "鏡光到處，邪靈退後"]])
			_t3130 = _t3129
		J.sp(_t3125, "say", _t3130)
		var _t3131 = _s1100["h"]
		J.sp(_t3131, "sayT", 2.4)
		var _t3132 = _s1100["h"]
		var _t3133 = (8.0 + J.mul(J.cl(_s1100["__p"]["rnd"], null, []), 8.0))
		J.sp(_t3132, "talkT", _t3133)
	var _t3134 = _s1100["__p"]["nearestGhost"]
	v_tg_2986 = J.cl(_t3134, null, [_s1100["h"]])
	var _t3135 = (not J.seq(J.gp(_s1100["h"], "kind"), "guard"))
	v_chaser_2987 = (_t3135 if _t3135 else J.seq(J.gp(_s1100["h"], "state"), "chase"))
	var _t3136 = J.seq(J.gp(_s1100["h"], "kind"), "guard")
	var _t3137 = (v_tg_2986 if _t3136 else _t3136)
	var _t3138 = ((absf(J.num(J.sub(J.gp(v_tg_2986, "y"), J.gp(_s1100["h"], "y")))) < 40.0) if J.t(_t3137) else _t3137)
	var _t3139 = ((J.mul(J.sub(J.gp(v_tg_2986, "x"), J.gp(_s1100["h"], "x")), J.gp(_s1100["h"], "dir")) > 0.0) if J.t(_t3138) else _t3138)
	var _t3140 = ((absf(J.num(J.sub(J.gp(v_tg_2986, "x"), J.gp(_s1100["h"], "x")))) < 150.0) if J.t(_t3139) else _t3139)
	if J.t(((not J.seq(J.gp(_s1100["h"], "state"), "chase")) if J.t(_t3140) else _t3140)):
		var _t3141 = _s1100["h"]
		J.sp(_t3141, "state", "chase")
		var _t3142 = _s1100["h"]
		J.sp(_t3142, "alertT", 1.2)
		var _t3143 = _s1100["h"]
		var _t3144 = _s1100["__p"]["line"]
		var _t3145 = J.cl(_t3144, null, ["guardHit"])
		J.sp(_t3143, "say", _t3145)
		var _t3146 = _s1100["h"]
		J.sp(_t3146, "sayT", 2.0)
	var _t3147 = J.seq(J.gp(_s1100["h"], "kind"), "decoy")
	if ((not J.t(J.gp(_s1100["h"], "real"))) if _t3147 else _t3147):
		v_chaser_2987 = false
	if (not J.t(J.gp(_s1100["h"], "to"))):
		var _t3148 = _s1100["h"]
		var _t3149 = J.sub(J.gp(_t3148, "wait"), v_dt_2971)
		J.sp(_t3148, "wait", _t3149)
		if J.cmp(J.gp(_s1100["h"], "wait"), 0.0, ">"):
			return null
		var _t3150 = _s1100["h"]
		var _t3151 = J.sub(J.gp(_t3150, "repath"), v_dt_2971)
		J.sp(_t3150, "repath", _t3151)
		if J.t((v_tg_2986 if J.t(v_chaser_2987) else v_chaser_2987)):
			v_tn_2988 = ((J.gp(v_tg_2986, "node") if (absf(J.num(J.sub(J.gp(J.gp(J.gp(_s1100["__p"]["G"], "nodes"), J.gp(v_tg_2986, "node")), "x"), J.gp(v_tg_2986, "x")))) < absf(J.num(J.sub(J.gp(J.gp(J.gp(_s1100["__p"]["G"], "nodes"), J.gp(v_tg_2986, "to")), "x"), J.gp(v_tg_2986, "x"))))) else J.gp(v_tg_2986, "to")) if J.t(J.gp(v_tg_2986, "to")) else J.gp(v_tg_2986, "node"))
			var _t3152 = _s1100["__p"]["safeNode"]
			if J.t(J.cl(_t3152, null, [v_tn_2988])):
				var _t3153 = _s1100["__p"]["balk"]
				var _t3156 = _s1100["h"]
				var _t3155 = (not J.seq(J.gp(_s1100["h"], "kind"), "dog"))
				if J.t(_t3155):
					var _t3154 = _s1100["__p"]["nearSafe"]
					_t3155 = J.cl(_t3154, null, [_s1100["h"]])
				J.cl(_t3153, null, [_t3156, ((not J.cmp(J.gp(_s1100["h"], "balkCd"), 0.0, ">")) if J.t(_t3155) else _t3155)])
				return null
			var _t3157 = J.cmp(J.gp(_s1100["h"], "repath"), 0.0, "<=")
			if (_t3157 if _t3157 else (not J.t(J.gp(_s1100["h"], "path")))):
				var _t3158 = _s1100["h"]
				var _t3159 = _s1100["__p"]["dijkstra"]
				var _t3160 = J.cl(_t3159, null, [_s1100["h"], J.gp(_s1100["h"], "node"), v_tn_2988])
				J.sp(_t3158, "path", _t3160)
				var _t3161 = _s1100["h"]
				J.sp(_t3161, "repath", 0.5)
			var _t3162 = J.gp(_s1100["h"], "path")
			if J.t((J.len(J.gp(_s1100["h"], "path")) if J.t(_t3162) else _t3162)):
				var _t3163 = _s1100["h"]
				var _t3164 = J.mc(J.gp(_s1100["h"], "path"), "shift", [])
				J.sp(_t3163, "to", _t3164)
				var _t3165 = _s1100["h"]
				J.sp(_t3165, "p", 0.0)
		if (not J.t(J.gp(_s1100["h"], "to"))):
			_s1100["n"] = J.gp(J.gp(_s1100["__p"]["G"], "nodes"), J.gp(_s1100["h"], "node"))
			_s1100["zm"] = (J.div(J.add(J.gp(J.gp(_s1100["h"], "zone"), 0.0), J.gp(J.gp(_s1100["h"], "zone"), 1.0)), 2.0) if J.t(J.gp(_s1100["h"], "zone")) else 0.0)
			var _t3166 = J.gp(_s1100["n"], "links")
			v_opts_2991 = J.mc(_t3166, "filter", [Callable(self, "_f474").bind(_s1100)])
			if J.t(J.len(v_opts_2991)):
				var _t3177 = _s1100["h"]
				var _t3178 = _s1100["__p"]["pick"]
				var _t3179 = J.gp(J.cl(_t3178, null, [v_opts_2991]), "to")
				J.sp(_t3177, "to", _t3179)
				var _t3180 = _s1100["h"]
				J.sp(_t3180, "p", 0.0)
	v_a_2992 = J.gp(J.gp(_s1100["__p"]["G"], "nodes"), J.gp(_s1100["h"], "node"))
	v_b_2993 = J.gp(J.gp(_s1100["__p"]["G"], "nodes"), J.gp(_s1100["h"], "to"))
	if (not J.t(v_b_2993)):
		var _t3181 = _s1100["h"]
		J.sp(_t3181, "to", null)
		return null
	v_D_2994 = J.max_([1.0, J.hypot_([J.sub(J.gp(v_b_2993, "x"), J.gp(v_a_2992, "x")), J.sub(J.gp(v_b_2993, "y"), J.gp(v_a_2992, "y"))])])
	var _t3183 = J.gp(v_H_2972, "sp")
	var _t3182 = J.gp(_s1100["h"], "boost")
	v_sp_2995 = ((J.mul(_t3183, (_t3182 if J.t(_t3182) else 1.0)) * ((1.4 if J.cmp(J.gp(J.gp(_s1100["__p"]["G"], "gate"), "t"), 20.0, ">") else 1.2) if J.t(J.gp(_s1100["__p"]["G"], "gate")) else 1.0)) * (1.0 + J.mul(0.08, J.gp(_s1100["__p"]["G"], "phase"))))
	if J.t((v_chaser_2987 if J.t(v_tg_2986) else v_tg_2986)):
		var _t3184 = J.mul(v_sp_2995, (1.05 * pow(J.num(1.15), J.num(absf(J.num(J.sub(J.gp(J.gp(J.gp(_s1100["__p"]["G"], "nodes"), J.gp(v_tg_2986, "node")), "f"), J.gp(v_a_2992, "f"))))))))
		v_sp_2995 = _t3184
		var _t3185 = J.min_([v_sp_2995, (J.mul(J.gp(J.gp(v_tg_2986, "d"), "sp"), J.gp(J.gp(_s1100["__p"]["G"], "mods"), "spd")) * 0.85)])
		v_sp_2995 = _t3185
	else:
		var _t3186 = J.mul(v_sp_2995, 0.45)
		v_sp_2995 = _t3186
	var _t3187 = _s1100["h"]
	J.sp(_t3187, "walkSp", v_sp_2995)
	var _t3188 = _s1100["h"]
	var _t3189 = J.add(J.gp(_t3188, "p"), J.div(J.mul(v_sp_2995, v_dt_2971), v_D_2994))
	J.sp(_t3188, "p", _t3189)
	if (not J.seq(J.gp(v_b_2993, "x"), J.gp(v_a_2992, "x"))):
		var _t3190 = _s1100["h"]
		var _t3191 = (1.0 if J.cmp(J.gp(v_b_2993, "x"), J.gp(v_a_2992, "x"), ">") else (-1.0))
		J.sp(_t3190, "dir", _t3191)
	if J.cmp(J.gp(_s1100["h"], "p"), 1.0, ">="):
		var _t3192 = _s1100["h"]
		var _t3193 = J.gp(_s1100["h"], "to")
		J.sp(_t3192, "node", _t3193)
		var _t3194 = _s1100["h"]
		J.sp(_t3194, "to", null)
		var _t3195 = _s1100["h"]
		J.sp(_t3195, "p", 0.0)
		var _t3196 = _s1100["h"]
		var _t3197 = (0.0 if J.t(v_chaser_2987) else (0.3 + J.mul(J.cl(_s1100["__p"]["rnd"], null, []), 0.8)))
		J.sp(_t3196, "wait", _t3197)
	var _t3198 = _s1100["__p"]["posOf"]
	v_p_2996 = J.cl(_t3198, null, [_s1100["h"]])
	var _t3199 = _s1100["h"]
	var _t3200 = J.gp(v_p_2996, "x")
	J.sp(_t3199, "x", _t3200)
	var _t3201 = _s1100["h"]
	var _t3202 = J.gp(v_p_2996, "y")
	J.sp(_t3201, "y", _t3202)
	var _t3203 = J.gp(_s1100["__p"]["G"], "gh")
	J.mc(_t3203, "forEach", [Callable(self, "_f475").bind(_s1100)])
	var _t3220 = _s1100["h"]
	var _t3221 = J.gp(_s1100["h"], "catchCd")
	var _t3222 = J.gp(_s1100["h"], "catchCd")
	var _t3223 = J.max_([0.0, J.sub((_t3222 if J.t(_t3222) else 0.0), v_dt_2971)])
	J.sp(_t3220, "catchCd", _t3223)

func _f477(this_, a: Array, env):
	var v_o_3015 = null
	v_o_3015 = J.arg(a, 0)
	var _t3226 = (not J.seq(J.gp(v_o_3015, "state"), "flee"))
	var _t3228 = ((not J.seq(J.gp(v_o_3015, "kind"), "dog")) if _t3226 else _t3226)
	if J.t(_t3228):
		var _t3227 = J.seq(J.gp(v_o_3015, "kind"), "decoy")
		_t3228 = (not ((not J.t(J.gp(v_o_3015, "real"))) if _t3227 else _t3227))
	var _t3229 = ((absf(J.num(J.sub(J.gp(v_o_3015, "y"), J.gp(env["g"], "y")))) < 30.0) if _t3228 else _t3228)
	return ((absf(J.num(J.sub(J.gp(v_o_3015, "x"), J.gp(env["g"], "x")))) < 90.0) if _t3229 else _t3229)

func _f478(this_, a: Array, env):
	var v_b_3018 = null
	v_b_3018 = J.arg(a, 0)
	return J.seq(J.gp(v_b_3018, "o"), J.gp(env["g"], "i"))

func _f479(this_, a: Array, env):
	var v_b_3021 = null
	v_b_3021 = J.arg(a, 0)
	return (not J.seq(J.gp(v_b_3021, "o"), J.gp(env["g"], "i")))

func _f480(this_, a: Array, env):
	var v_o_3024 = null
	v_o_3024 = J.arg(a, 0)
	return (not J.t(J.gp(v_o_3024, "out")))

func _f481(this_, a: Array, env):
	var v_o_3027 = null
	v_o_3027 = J.arg(a, 0)
	var _t3257 = (not J.t(J.gp(v_o_3027, "out")))
	return ((not J.t(J.gp(v_o_3027, "home"))) if _t3257 else _t3257)

func _f482(this_, a: Array, env):
	var v_l_3030 = null
	v_l_3030 = J.arg(a, 0)
	return J.gp(J.gp(env["__p"]["G"], "nodes"), J.gp(v_l_3030, "to"))

func _f483(this_, a: Array, env):
	var v_m_3033 = null
	v_m_3033 = J.arg(a, 0)
	var _t3264 = (not J.seq(J.gp(v_m_3033, "kind"), "in"))
	return ((J.mul(J.sub(J.gp(v_m_3033, "x"), J.gp(env["h"], "x")), J.gp(env["h"], "dir")) > 0.0) if _t3264 else _t3264)

func _f476(this_, a: Array, env):
	var v_near_3008 = null; var v_k_3009 = null; var v_lost_3010 = null; var v_nx_3011 = null; var v_back_3012 = null
	var _s1142 = {"__p": env, "g": null, "h": null}
	_s1142["g"] = J.arg(a, 0)
	_s1142["h"] = J.arg(a, 1)
	var _t3224 = _s1142["__p"]["inSafe"]
	if J.t(J.cl(_t3224, null, [_s1142["g"]])):
		return null
	var _t3225 = J.gp(_s1142["__p"]["G"], "guards")
	v_near_3008 = J.len(J.mc(_t3225, "filter", [Callable(self, "_f477").bind(_s1142)]))
	var _t3230 = _s1142["g"]
	var _t3231 = J.add(J.gp(_t3230, "caught"), (3.0 if J.cmp(v_near_3008, 2.0, ">=") else 1.0))
	J.sp(_t3230, "caught", _t3231)
	if J.cmp(v_near_3008, 2.0, ">="):
		var _t3232 = _s1142["__p"]["float"]
		J.cl(_t3232, null, [J.gp(_s1142["g"], "x"), J.sub(J.gp(_s1142["g"], "y"), 110.0), "被圍！", "#ff5a4a"])
	var _t3233 = _s1142["g"]
	J.sp(_t3233, "hitT", 0.8)
	var _t3234 = _s1142["g"]
	var _t3235 = J.gp(_s1142["h"], "dir")
	J.sp(_t3234, "hitDir", _t3235)
	var _t3236 = _s1142["g"]
	J.sp(_t3236, "stun", 1.5)
	var _t3237 = _s1142["g"]
	J.sp(_t3237, "to", null)
	var _t3238 = _s1142["g"]
	J.sp(_t3238, "auto", null)
	var _t3239 = _s1142["h"]
	J.sp(_t3239, "alertT", 1.3)
	var _t3240 = _s1142["h"]
	var _t3241 = _s1142["__p"]["line"]
	var _t3242 = J.cl(_t3241, null, ["guardHit"])
	J.sp(_t3240, "say", _t3242)
	var _t3243 = _s1142["h"]
	J.sp(_t3243, "sayT", 2.0)
	var _t3244 = _s1142["__p"]["G"]
	J.sp(_t3244, "shake", 0.35)
	v_k_3009 = 0.0
	while true:
		if not J.cmp(v_k_3009, 10.0, "<"): break
		var _t3245 = _s1142["__p"]["part"]
		J.cl(_t3245, null, [J.gp(_s1142["g"], "x"), J.sub(J.gp(_s1142["g"], "y"), J.mul(J.gp(J.gp(_s1142["g"], "d"), "h"), 0.5)), ((J.sub(J.cl(_s1142["__p"]["rnd"], null, []), 0.5) * 50.0) + J.mul(J.gp(_s1142["h"], "dir"), 40.0)), ((-30.0) - J.mul(J.cl(_s1142["__p"]["rnd"], null, []), 40.0)), 0.9, "smoke"])
		v_k_3009 = J.num(v_k_3009) + 1.0
	if J.cmp(J.gp(_s1142["g"], "caught"), 3.0, ">="):
		var _t3246 = _s1142["g"]
		J.sp(_t3246, "out", true)
		var _t3247 = J.gp(_s1142["__p"]["G"], "bag")
		v_lost_3010 = J.len(J.mc(_t3247, "filter", [Callable(self, "_f478").bind(_s1142)]))
		var _t3248 = _s1142["__p"]["G"]
		var _t3249 = J.gp(_s1142["__p"]["G"], "bag")
		var _t3250 = J.mc(_t3249, "filter", [Callable(self, "_f479").bind(_s1142)])
		J.sp(_t3248, "bag", _t3250)
		var _t3251 = _s1142["g"]
		J.sp(_t3251, "loot", 0.0)
		var _t3252 = _s1142["__p"]["float"]
		J.cl(_t3252, null, [J.gp(_s1142["g"], "x"), J.sub(J.gp(_s1142["g"], "y"), 100.0), J.add(J.gp(J.gp(_s1142["g"], "d"), "name"), "被收服！"), "#ff7a5a"])
		var _t3253 = _s1142["__p"]["toast"]
		var _t3255 = (J.add(J.add(J.gp(J.gp(_s1142["g"], "d"), "name"), "畀人收服咗，佢身上 "), v_lost_3010) + " 件收穫冇埋。")
		var _t3254 = J.gp(_s1142["__p"]["G"], "gh")
		J.cl(_t3253, null, [(_t3255 + ("快啲切去其他鬼！" if J.t(J.mc(_t3254, "some", [Callable(self, "_f480").bind(_s1142)])) else ""))])
		if J.seq(J.gp(_s1142["__p"]["G"], "active"), J.gp(_s1142["g"], "i")):
			var _t3256 = J.gp(_s1142["__p"]["G"], "gh")
			v_nx_3011 = J.mc(_t3256, "find", [Callable(self, "_f481").bind(_s1142)])
			if J.t(v_nx_3011):
				var _t3258 = _s1142["__p"]["G"]
				var _t3259 = J.gp(v_nx_3011, "i")
				J.sp(_t3258, "active", _t3259)
	else:
		var _t3260 = _s1142["__p"]["loseLoot"]
		J.cl(_t3260, null, [_s1142["g"], 0.34])
		var _t3261 = _s1142["__p"]["float"]
		J.cl(_t3261, null, [J.gp(_s1142["g"], "x"), J.sub(J.gp(_s1142["g"], "y"), 80.0), (J.add("被捉住！（", J.gp(_s1142["g"], "caught")) + "/3）"), "#ffb0b0"])
		var _t3262 = J.gp(J.gp(J.gp(_s1142["__p"]["G"], "nodes"), J.gp(_s1142["g"], "node")), "links")
		var _t3263 = J.mc(_t3262, "map", [Callable(self, "_f482").bind(_s1142)])
		v_back_3012 = J.gp(J.mc(_t3263, "filter", [Callable(self, "_f483").bind(_s1142)]), 0.0)
		if J.t(v_back_3012):
			var _t3265 = _s1142["g"]
			var _t3266 = J.gp(v_back_3012, "id")
			J.sp(_t3265, "node", _t3266)

func _f485(this_, a: Array, env):
	var v_b_3044 = null
	v_b_3044 = J.arg(a, 0)
	return J.seq(J.gp(v_b_3044, "o"), J.gp(env["g"], "i"))

func _f484(this_, a: Array, env):
	var v_frac_3037 = null; var v_mine_3038 = null; var v_l_3039 = null; var v_k_3040 = null; var v_i_3041 = null
	var _s1154 = {"__p": env, "g": null}
	_s1154["g"] = J.arg(a, 0)
	v_frac_3037 = J.arg(a, 1)
	var _t3267 = J.gp(_s1154["__p"]["G"], "bag")
	v_mine_3038 = J.mc(_t3267, "filter", [Callable(self, "_f485").bind(_s1154)])
	v_l_3039 = ceil(J.num((J.mul(J.len(v_mine_3038), v_frac_3037) * (0.5 if J.cmp(J.gp(J.gp(_s1154["__p"]["G"], "mods"), "arm"), 1.0, "<") else 1.0))))
	v_k_3040 = 0.0
	while true:
		if not J.cmp(v_k_3040, v_l_3039, "<"): break
		var _t3268 = J.gp(_s1154["__p"]["G"], "bag")
		v_i_3041 = J.mc(_t3268, "indexOf", [J.gp(v_mine_3038, v_k_3040)])
		var _t3269 = J.gp(_s1154["__p"]["G"], "bag")
		J.mc(_t3269, "splice", [v_i_3041, 1.0])
		v_k_3040 = J.num(v_k_3040) + 1.0
	var _t3270 = _s1154["g"]
	var _t3271 = J.max_([0.0, J.sub(J.gp(_s1154["g"], "loot"), v_l_3039)])
	J.sp(_t3270, "loot", _t3271)
	if J.cmp(v_l_3039, 0.0, ">"):
		var _t3272 = _s1154["__p"]["float"]
		J.cl(_t3272, null, [J.gp(_s1154["g"], "x"), J.sub(J.gp(_s1154["g"], "y"), 95.0), J.add("跌咗收穫 -", v_l_3039), "#ff9a9a"])

func _f486(this_, a: Array, env):
	var v_f_3047 = null; var v_x_3048 = null
	v_f_3047 = J.arg(a, 0)
	v_x_3048 = J.arg(a, 1)
	var _t3273 = env["G"]
	var _t3275 = (1.0 if J.cmp(v_x_3048, J.div(env["WW"], 2.0), "<") else (-1.0))
	var _t3276 = []
	var _t3274 = env["pick"]
	var _t3277 = {"x": v_x_3048, "f": v_f_3047, "dir": _t3275, "ringT": 2.2, "life": 26.0, "waves": _t3276, "say": J.cl(_t3274, null, [env["TAOL"]]), "sayT": 2.6}
	J.sp(_t3273, "tao", _t3277)
	var _t3278 = env["float"]
	var _t3279 = env["fy"]
	J.cl(_t3278, null, [v_x_3048, J.sub(J.cl(_t3279, null, [v_f_3047]), 90.0), "天師嚟咗！", "#ffd54a"])

func _f489(this_, a: Array, env):
	var v_l_3062 = null
	v_l_3062 = J.arg(a, 0)
	return J.gp(J.gp(env["__p"]["__p"]["G"], "nodes"), J.gp(v_l_3062, "to"))

func _f490(this_, a: Array, env):
	var v_m_3065 = null
	v_m_3065 = J.arg(a, 0)
	var _t3314 = (not J.seq(J.gp(v_m_3065, "kind"), "in"))
	var _t3315 = (((J.sub(J.gp(v_m_3065, "x"), J.gp(env["__p"]["T"], "x")) * J.sub(J.gp(env["g"], "x"), J.gp(env["__p"]["T"], "x"))) >= 0.0) if _t3314 else _t3314)
	return ((absf(J.num(J.sub(J.gp(v_m_3065, "x"), J.gp(env["__p"]["T"], "x")))) > absf(J.num(J.sub(J.gp(env["n"], "x"), J.gp(env["__p"]["T"], "x"))))) if _t3315 else _t3315)

func _f488(this_, a: Array, env):
	var v_away_3058 = null; var v_k_3059 = null
	var _s1163 = {"__p": env, "g": null, "n": null}
	_s1163["g"] = J.arg(a, 0)
	var _t3303 = J.gp(_s1163["g"], "home")
	if J.t((_t3303 if J.t(_t3303) else J.gp(_s1163["g"], "out"))):
		return null
	if J.t(J.gp(_s1163["g"], "inUnit")):
		return null
	var _t3304 = _s1163["__p"]["__p"]["inSafe"]
	if J.t(J.cl(_t3304, null, [_s1163["g"]])):
		return null
	if (not J.seq(J.gp(J.gp(J.gp(_s1163["__p"]["__p"]["G"], "nodes"), J.gp(_s1163["g"], "node")), "f"), J.gp(_s1163["__p"]["T"], "f"))):
		return null
	if (absf(J.num(J.sub(J.gp(_s1163["g"], "x"), J.gp(_s1163["__p"]["T"], "x")))) > 140.0):
		return null
	var _t3305 = _s1163["g"]
	J.sp(_t3305, "sealT", 3.0)
	var _t3306 = _s1163["g"]
	J.sp(_t3306, "hitT", 0.8)
	var _t3307 = _s1163["g"]
	var _t3308 = (1.0 if J.cmp(J.gp(_s1163["g"], "x"), J.gp(_s1163["__p"]["T"], "x"), ">") else (-1.0))
	J.sp(_t3307, "hitDir", _t3308)
	var _t3309 = _s1163["g"]
	J.sp(_t3309, "to", null)
	var _t3310 = _s1163["g"]
	J.sp(_t3310, "auto", null)
	var _t3311 = _s1163["g"]
	J.sp(_t3311, "taskP", 0.0)
	_s1163["n"] = J.gp(J.gp(_s1163["__p"]["__p"]["G"], "nodes"), J.gp(_s1163["g"], "node"))
	var _t3312 = J.gp(_s1163["n"], "links")
	var _t3313 = J.mc(_t3312, "map", [Callable(self, "_f489").bind(_s1163)])
	v_away_3058 = J.gp(J.mc(_t3313, "filter", [Callable(self, "_f490").bind(_s1163)]), 0.0)
	if J.seq(J.gp(_s1163["n"], "kind"), "in"):
		var _t3316 = _s1163["g"]
		var _t3317 = J.gp(_s1163["n"], "id")
		var _t3318 = J.mc(_t3317, "replace", ["_i", "_d"])
		J.sp(_t3316, "node", _t3318)
	else:
		if J.t(v_away_3058):
			var _t3319 = _s1163["g"]
			var _t3320 = J.gp(v_away_3058, "id")
			J.sp(_t3319, "node", _t3320)
	var _t3321 = _s1163["__p"]["__p"]["float"]
	J.cl(_t3321, null, [J.gp(_s1163["g"], "x"), J.sub(J.gp(_s1163["g"], "y"), 90.0), "鈴聲逼退，暫時嚇唔到人", "#ffe9a0"])
	v_k_3059 = 0.0
	while true:
		if not J.cmp(v_k_3059, 8.0, "<"): break
		var _t3322 = _s1163["__p"]["__p"]["part"]
		J.cl(_t3322, null, [J.gp(_s1163["g"], "x"), J.sub(J.gp(_s1163["g"], "y"), 30.0), (J.sub(J.cl(_s1163["__p"]["__p"]["rnd"], null, []), 0.5) * 60.0), ((-30.0) - J.mul(J.cl(_s1163["__p"]["__p"]["rnd"], null, []), 40.0)), 0.9, "smoke"])
		v_k_3059 = J.num(v_k_3059) + 1.0

func _f491(this_, a: Array, env):
	var v_w_3068 = null
	v_w_3068 = J.arg(a, 0)
	var _t3324 = J.sub(J.gp(v_w_3068, "t"), env["dt"])
	J.sp(v_w_3068, "t", _t3324)
	var _t3325 = J.add(J.gp(v_w_3068, "r"), J.mul(180.0, env["dt"]))
	J.sp(v_w_3068, "r", _t3325)

func _f492(this_, a: Array, env):
	var v_w_3071 = null
	v_w_3071 = J.arg(a, 0)
	return J.cmp(J.gp(v_w_3071, "t"), 0.0, ">")

func _f487(this_, a: Array, env):
	var v_f_3052 = null
	var _s1159 = {"__p": env, "dt": null, "T": null}
	_s1159["dt"] = J.arg(a, 0)
	var _t3280 = J.gp(_s1159["__p"]["G"], "taoWant")
	var _t3281 = ((not J.t(J.gp(_s1159["__p"]["G"], "tao"))) if J.t(_t3280) else _t3280)
	if J.t(((not J.t(J.gp(_s1159["__p"]["G"], "gate"))) if J.t(_t3281) else _t3281)):
		var _t3282 = _s1159["__p"]["G"]
		var _t3283 = J.sub((2.0 if J.leq(J.gp(_s1159["__p"]["G"], "taoCd"), null) else J.gp(_s1159["__p"]["G"], "taoCd")), _s1159["dt"])
		J.sp(_t3282, "taoCd", _t3283)
		if J.cmp(J.gp(_s1159["__p"]["G"], "taoCd"), 0.0, "<="):
			v_f_3052 = (1.0 + floor(J.num(J.mul(J.cl(_s1159["__p"]["rnd"], null, []), J.sub(_s1159["__p"]["FL"], 1.0)))))
			var _t3284 = _s1159["__p"]["spawnTao"]
			J.cl(_t3284, null, [v_f_3052, (_s1159["__p"]["SX"] if J.cmp(J.cl(_s1159["__p"]["rnd"], null, []), 0.5, "<") else _s1159["__p"]["LX"])])
	_s1159["T"] = J.gp(_s1159["__p"]["G"], "tao")
	if (not J.t(_s1159["T"])):
		return null
	var _t3285 = _s1159["T"]
	var _t3286 = J.sub(J.gp(_t3285, "life"), _s1159["dt"])
	J.sp(_t3285, "life", _t3286)
	var _t3287 = _s1159["T"]
	var _t3288 = J.add(J.gp(_t3287, "x"), J.mul(J.mul(J.gp(_s1159["T"], "dir"), 36.0), _s1159["dt"]))
	J.sp(_t3287, "x", _t3288)
	var _t3289 = J.cmp(J.gp(_s1159["T"], "x"), J.sub(_s1159["__p"]["LX"], 10.0), ">")
	if (_t3289 if _t3289 else J.cmp(J.gp(_s1159["T"], "x"), J.add(_s1159["__p"]["SX"], 10.0), "<")):
		var _t3290 = _s1159["T"]
		var _t3291 = J.mul(J.gp(_t3290, "dir"), (-1.0))
		J.sp(_t3290, "dir", _t3291)
	var _t3292 = _s1159["T"]
	var _t3293 = J.sub(J.gp(_t3292, "sayT"), _s1159["dt"])
	J.sp(_t3292, "sayT", _t3293)
	var _t3294 = _s1159["T"]
	var _t3295 = J.sub(J.gp(_t3294, "ringT"), _s1159["dt"])
	J.sp(_t3294, "ringT", _t3295)
	if J.cmp(J.gp(_s1159["T"], "ringT"), 0.0, "<="):
		var _t3296 = _s1159["T"]
		J.sp(_t3296, "ringT", 4.0)
		var _t3297 = J.gp(_s1159["T"], "waves")
		J.mc(_t3297, "push", [{"r": 10.0, "t": 1.0}])
		var _t3298 = _s1159["T"]
		var _t3299 = _s1159["__p"]["pick"]
		var _t3300 = J.cl(_t3299, null, [_s1159["__p"]["TAOL"]])
		J.sp(_t3298, "say", _t3300)
		var _t3301 = _s1159["T"]
		J.sp(_t3301, "sayT", 2.4)
		var _t3302 = J.gp(_s1159["__p"]["G"], "gh")
		J.mc(_t3302, "forEach", [Callable(self, "_f488").bind(_s1159)])
	var _t3323 = J.gp(_s1159["T"], "waves")
	J.mc(_t3323, "forEach", [Callable(self, "_f491").bind(_s1159)])
	var _t3326 = _s1159["T"]
	var _t3327 = J.gp(_s1159["T"], "waves")
	var _t3328 = J.mc(_t3327, "filter", [Callable(self, "_f492").bind(_s1159)])
	J.sp(_t3326, "waves", _t3328)
	if J.cmp(J.gp(_s1159["T"], "life"), 0.0, "<="):
		var _t3329 = _s1159["__p"]["G"]
		J.sp(_t3329, "tao", null)
		var _t3330 = _s1159["__p"]["G"]
		var _t3331 = (16.0 + J.mul(J.cl(_s1159["__p"]["rnd"], null, []), 10.0))
		J.sp(_t3330, "taoCd", _t3331)

func _f493(this_, a: Array, env):
	var v_g_3074 = null; var v_n_3075 = null
	v_g_3074 = J.gp(J.gp(env["G"], "gh"), J.gp(env["G"], "active"))
	v_n_3075 = J.gp(J.gp(env["G"], "nodes"), J.gp(v_g_3074, "node"))
	var _t3332 = J.gp(env["G"], "gate")
	var _t3333 = (_t3332 if J.t(_t3332) else J.gp(v_g_3074, "to"))
	if J.t((_t3333 if J.t(_t3333) else (not J.seq(J.gp(v_n_3075, "kind"), "portal")))):
		return null
	var _t3334 = env["standStill"]
	J.cl(_t3334, null, [v_g_3074])
	var _t3335 = env["calm"]
	J.cl(_t3335, null, [v_g_3074])
	var _t3336 = env["G"]
	J.sp(_t3336, "gateCharge", 0.001)
	var _t3337 = env["G"]
	var _t3338 = J.gp(v_g_3074, "i")
	J.sp(_t3337, "gateG", _t3338)

func _f495(this_, a: Array, env):
	var v_g_3087 = null
	v_g_3087 = J.arg(a, 0)
	return (not J.t(J.gp(v_g_3087, "out")))

func _f496(this_, a: Array, env):
	var v_g_3090 = null
	v_g_3090 = J.arg(a, 0)
	J.sp(v_g_3090, "home", true)

func _f494(this_, a: Array, env):
	var v_dt_3078 = null; var v_g_3079 = null; var v_Gt_3080 = null; var v_side_3081 = null; var v_h_3082 = null; var v_d_3083 = null; var v_alive_3084 = null
	v_dt_3078 = J.arg(a, 0)
	var _t3339 = J.cmp(J.gp(env["G"], "gateCharge"), 0.0, ">")
	if ((not J.t(J.gp(env["G"], "gate"))) if _t3339 else _t3339):
		v_g_3079 = J.gp(J.gp(env["G"], "gh"), J.gp(env["G"], "gateG"))
		var _t3340 = J.gp(v_g_3079, "to")
		var _t3341 = (_t3340 if J.t(_t3340) else J.cmp(J.gp(v_g_3079, "still"), 0.1, "<"))
		if J.t((_t3341 if J.t(_t3341) else (not J.seq(J.gp(J.gp(J.gp(env["G"], "nodes"), J.gp(v_g_3079, "node")), "kind"), "portal")))):
			var _t3342 = env["G"]
			J.sp(_t3342, "gateCharge", 0.0)
			var _t3343 = env["float"]
			J.cl(_t3343, null, [J.gp(v_g_3079, "x"), J.sub(J.gp(v_g_3079, "y"), 80.0), "郁咗，陰門開唔到", "#ffb0b0"])
		else:
			var _t3344 = env["G"]
			var _t3345 = J.add(J.gp(_t3344, "gateCharge"), v_dt_3078)
			J.sp(_t3344, "gateCharge", _t3345)
			if J.cmp(J.gp(env["G"], "gateCharge"), 1.0, ">="):
				var _t3346 = env["G"]
				J.sp(_t3346, "gateCharge", 0.0)
				var _t3347 = env["G"]
				var _t3348 = {"t": 0.0, "f": J.gp(J.gp(J.gp(env["G"], "nodes"), J.gp(v_g_3079, "node")), "f"), "node": J.gp(v_g_3079, "node"), "sp": 1.2, "fin": false}
				J.sp(_t3347, "gate", _t3348)
				var _t3349 = env["G"]
				J.sp(_t3349, "tao", null)
				var _t3350 = env["toast"]
				J.cl(_t3350, null, ["陰門開咗！企穩 30 秒——樓梯封住，追兵會越嚟越快，最後 8 秒天師會喺你兩邊出現。"])
				var _t3351 = env["G"]
				J.sp(_t3351, "shake", 0.5)
	v_Gt_3080 = J.gp(env["G"], "gate")
	if (not J.t(v_Gt_3080)):
		return null
	var _t3352 = J.add(J.gp(v_Gt_3080, "t"), v_dt_3078)
	J.sp(v_Gt_3080, "t", _t3352)
	var _t3353 = J.sub(J.gp(v_Gt_3080, "sp"), v_dt_3078)
	J.sp(v_Gt_3080, "sp", _t3353)
	if J.cmp(J.gp(v_Gt_3080, "sp"), 0.0, "<="):
		var _t3354 = (2.6 if J.cmp(J.gp(v_Gt_3080, "t"), 20.0, "<") else 1.4)
		J.sp(v_Gt_3080, "sp", _t3354)
		v_side_3081 = J.cmp(J.cl(env["rnd"], null, []), 0.5, "<")
		var _t3355 = env["mkHuman"]
		v_h_3082 = J.cl(_t3355, null, ["guard", ((J.add("f", J.gp(v_Gt_3080, "f")) + "_") + ("s" if J.t(v_side_3081) else "l")), {"state": "chase"}])
		var _t3356 = J.gp(env["G"], "guards")
		J.mc(_t3356, "push", [v_h_3082])
	var _t3357 = J.cmp(J.gp(v_Gt_3080, "t"), 22.0, ">=")
	if ((not J.t(J.gp(v_Gt_3080, "fin"))) if _t3357 else _t3357):
		J.sp(v_Gt_3080, "fin", true)
		v_g_3079 = J.gp(J.gp(env["G"], "gh"), J.gp(env["G"], "active"))
		var _t3358 = env["spawnTao"]
		J.cl(_t3358, null, [J.gp(v_Gt_3080, "f"), J.max_([J.add(env["SX"], 10.0), J.sub(J.gp(v_g_3079, "x"), 120.0)])])
		var _t3359 = J.gp(env["G"], "tao")
		J.sp(_t3359, "ringT", 1.5)
		var _t3360 = env["mkHuman"]
		v_d_3083 = J.cl(_t3360, null, ["mirror", (J.add("f", J.gp(v_Gt_3080, "f")) + "_l")])
		var _t3361 = (-1.0)
		J.sp(v_d_3083, "dir", _t3361)
		var _t3362 = J.gp(env["G"], "guards")
		J.mc(_t3362, "push", [v_d_3083])
		var _t3363 = env["toast"]
		J.cl(_t3363, null, ["最後 8 秒！天師同道士喺兩邊殺到，頂住！"])
	if J.cmp(J.gp(v_Gt_3080, "t"), 30.0, ">="):
		var _t3364 = J.gp(env["G"], "gh")
		v_alive_3084 = J.mc(_t3364, "filter", [Callable(self, "_f495").bind(env)])
		J.mc(v_alive_3084, "forEach", [Callable(self, "_f496").bind(env)])
		var _t3365 = env["endNight"]
		J.cl(_t3365, null, ["gate"])

func _f498(this_, a: Array, env):
	var v_g_3095 = null
	v_g_3095 = J.arg(a, 0)
	if (not J.t(J.gp(v_g_3095, "out"))):
		J.sp(v_g_3095, "home", true)

func _f497(this_, a: Array, env):
	var _t3366 = J.cmp(J.gp(env["G"], "dolls"), 6.0, "<")
	if J.t((_t3366 if _t3366 else J.gp(env["G"], "gate"))):
		return null
	var _t3367 = J.gp(env["G"], "gh")
	J.mc(_t3367, "forEach", [Callable(self, "_f498").bind(env)])
	var _t3368 = env["endNight"]
	J.cl(_t3368, null, ["doll"])

func _f500(this_, a: Array, env):
	var v_g_3106 = null
	v_g_3106 = J.arg(a, 0)
	return (not J.t(J.gp(v_g_3106, "out")))

func _f499(this_, a: Array, env):
	var v_why_3098 = null; var v_kept_3099 = null; var v_story_3100 = null; var v_sv_3101 = null; var v_first_3102 = null; var v_rw_3103 = null; var v_e_3107 = null
	v_why_3098 = J.arg(a, 0)
	if J.t(J.gp(env["G"], "over")):
		return null
	v_kept_3099 = (J.len(J.gp(env["G"], "bag")) if J.seq(v_why_3098, "gate") else (floor(J.num(J.div(J.len(J.gp(env["G"], "bag")), 2.0))) if J.seq(v_why_3098, "doll") else 0.0))
	v_story_3100 = (J.len(J.gp(env["G"], "story")) if J.seq(v_why_3098, "gate") else 0.0)
	var _t3369 = env["G"]
	var _t3371 = (not J.seq(v_why_3098, "fail"))
	var _t3372 = J.sub(J.len(J.gp(env["G"], "bag")), v_kept_3099)
	var _t3370 = J.gp(env["G"], "gh")
	var _t3373 = {"ok": _t3371, "why": v_why_3098, "kept": v_kept_3099, "lost": _t3372, "home": J.len(J.mc(_t3370, "filter", [Callable(self, "_f500").bind(env)])), "fear": J.gp(env["G"], "fearTotal"), "story": v_story_3100, "storyLost": (J.len(J.gp(env["G"], "story")) if J.seq(v_why_3098, "doll") else 0.0), "alert": J.gp(env["G"], "alert")}
	J.sp(_t3369, "over", _t3373)
	var _t3374 = env["gpOnEnd"]
	J.cl(_t3374, null, [v_why_3098])
	v_sv_3101 = J.cl(env["TS"], null, [])
	var _t3375 = J.seq(v_why_3098, "gate")
	v_first_3102 = ((not J.t(J.gp(v_sv_3101, J.add("gate_", env["curLv"])))) if _t3375 else _t3375)
	if J.t(v_first_3102):
		var _t3376 = J.add("gate_", env["curLv"])
		J.sp(v_sv_3101, _t3376, 1.0)
	var _t3377 = J.gp(v_sv_3101, "nights")
	var _t3378 = J.add((_t3377 if J.t(_t3377) else 0.0), 1.0)
	J.sp(v_sv_3101, "nights", _t3378)
	var _t3381 = (((40.0 + J.mul(15.0, v_kept_3099)) + J.mul(25.0, v_story_3100)) if J.seq(v_why_3098, "gate") else ((20.0 + J.mul(8.0, v_kept_3099)) if J.seq(v_why_3098, "doll") else 0.0))
	var _t3380 = null
	if (not J.seq(v_why_3098, "fail")):
		var _t3379 = J.gp(env["G"], "unitCoins")
		_t3380 = (_t3379 if J.t(_t3379) else 0.0)
	else:
		_t3380 = 0.0
	v_rw_3103 = J.add(_t3381, _t3380)
	if J.t(v_first_3102):
		var _t3382 = J.add(v_rw_3103, 100.0)
		v_rw_3103 = _t3382
	if (not J.seq(v_why_3098, "fail")):
		var _t3383 = J.gp(v_sv_3101, "best")
		var _t3384 = J.gp(v_sv_3101, "best")
		var _t3385 = J.max_([(_t3384 if J.t(_t3384) else 0.0), v_kept_3099])
		J.sp(v_sv_3101, "best", _t3385)
		var _t3386 = J.gp(v_sv_3101, "cleared")
		var _t3387 = env["curLv"]
		J.sp(_t3386, _t3387, 1.0)
	var _t3388 = J.gp(env["G"], "over")
	J.sp(_t3388, "reward", v_rw_3103)
	var _t3389 = J.gp(J.G.get("S"), "res")
	var _t3390 = J.add(J.gp(_t3389, "coins"), v_rw_3103)
	J.sp(_t3389, "coins", _t3390)
	J.cl(J.G.get("save"), null, [])

func _f501(this_, a: Array, env):
	var v_r_3110 = null; var v_t_3111 = null
	v_r_3110 = J.arg(a, 0)
	v_t_3111 = J.arg(a, 1)
	J.sp(v_r_3110, "say", v_t_3111)
	J.sp(v_r_3110, "sayT", 2.6)

func _f503(this_, a: Array, env):
	var v_o_3120 = null
	v_o_3120 = J.arg(a, 0)
	var _t3400 = (not J.seq(v_o_3120, env["r"]))
	if (J.seq(J.gp(v_o_3120, "state"), "home") if _t3400 else _t3400):
		J.sp(v_o_3120, "awake", true)
		J.sp(v_o_3120, "woke", true)
		var _t3402 = J.mul(env["amt"], 0.35)
		var _t3401 = env["__p"]["gpF"]
		var _t3403 = J.add(J.gp(v_o_3120, "fear"), (J.mul(_t3402, J.cl(_t3401, null, [env["g"]])) * J.sub(1.0, J.gp(v_o_3120, "brave"))))
		J.sp(v_o_3120, "fear", _t3403)
		J.sp(v_o_3120, "jumpT", 0.4)
		var _t3404 = J.cmp(J.gp(v_o_3120, "fear"), 100.0, ">=")
		if ((not J.cmp(J.gp(v_o_3120, "fleeAfter"), 0.0, ">")) if _t3404 else _t3404):
			J.sp(v_o_3120, "fleeAfter", 1.0)
			var _t3405 = env["g"]
			J.sp(v_o_3120, "fleeG", _t3405)

func _f502(this_, a: Array, env):
	var v_k_3117 = null
	var _s1190 = {"__p": env, "r": null, "amt": null, "g": null}
	_s1190["r"] = J.arg(a, 0)
	_s1190["amt"] = J.arg(a, 1)
	_s1190["g"] = J.arg(a, 2)
	if (not J.seq(J.gp(_s1190["r"], "state"), "home")):
		return null
	if (not J.t(J.gp(_s1190["r"], "awake"))):
		var _t3391 = _s1190["r"]
		J.sp(_t3391, "awake", true)
		var _t3392 = _s1190["r"]
		J.sp(_t3392, "woke", true)
		var _t3393 = J.mul(_s1190["amt"], 0.6)
		_s1190["amt"] = _t3393
	var _t3394 = _s1190["r"]
	var _t3396 = J.mul(_s1190["amt"], J.gp(J.gp(_s1190["__p"]["G"], "mods"), "pow"))
	var _t3395 = _s1190["__p"]["gpF"]
	var _t3397 = J.add(J.gp(_t3394, "fear"), (J.mul(_t3396, J.cl(_t3395, null, [_s1190["g"]])) * J.sub(1.0, J.gp(_s1190["r"], "brave"))))
	J.sp(_t3394, "fear", _t3397)
	var _t3398 = J.gp(_s1190["r"], "unit")
	if J.t((J.gp(J.gp(_s1190["r"], "unit"), "rs") if J.t(_t3398) else _t3398)):
		var _t3399 = J.gp(J.gp(_s1190["r"], "unit"), "rs")
		J.mc(_t3399, "forEach", [Callable(self, "_f503").bind(_s1190)])
	var _t3406 = _s1190["r"]
	J.sp(_t3406, "jumpT", 0.5)
	if J.t(_s1190["g"]):
		var _t3407 = _s1190["g"]
		var _t3408 = J.min_([100.0, J.add(J.gp(_s1190["g"], "energy"), (8.0 if J.t(J.gp(_s1190["r"], "brave")) else 18.0))])
		J.sp(_t3407, "energy", _t3408)
	v_k_3117 = 0.0
	while true:
		if not J.cmp(v_k_3117, 5.0, "<"): break
		var _t3409 = _s1190["__p"]["part"]
		J.cl(_t3409, null, [J.gp(_s1190["r"], "x"), J.sub(J.gp(_s1190["r"], "y"), 48.0), (J.sub(J.cl(_s1190["__p"]["rnd"], null, []), 0.5) * 90.0), ((-60.0) - J.mul(J.cl(_s1190["__p"]["rnd"], null, []), 40.0)), 0.6, "sweat"])
		v_k_3117 = J.num(v_k_3117) + 1.0
	var _t3410 = _s1190["__p"]["doReact"]
	J.cl(_t3410, null, [_s1190["r"], _s1190["g"]])
	var _t3411 = J.cmp(J.gp(_s1190["r"], "fear"), 100.0, ">=")
	if ((not J.cmp(J.gp(_s1190["r"], "fleeAfter"), 0.0, ">")) if _t3411 else _t3411):
		var _t3412 = _s1190["r"]
		J.sp(_t3412, "fleeAfter", 0.9)
		var _t3413 = _s1190["r"]
		var _t3414 = _s1190["g"]
		J.sp(_t3413, "fleeG", _t3414)

func _f505(this_, a: Array, env):
	var v_u_3127 = null
	v_u_3127 = J.arg(a, 0)
	var _t3430 = J.seq(J.gp(v_u_3127, "ot"), 1.0)
	var _t3431 = (J.seq(J.gp(v_u_3127, "dep"), J.gp(env["r"], "unit")) if _t3430 else _t3430)
	if ((not J.t(J.gp(v_u_3127, "open"))) if _t3431 else _t3431):
		var _t3432 = env["__p"]["unlockUnit"]
		J.cl(_t3432, null, [v_u_3127, "隔籬人心惶惶，入得喇（黑屋）"])

func _f504(this_, a: Array, env):
	var v_g_3124 = null
	var _s1197 = {"__p": env, "r": null}
	_s1197["r"] = J.arg(a, 0)
	v_g_3124 = J.arg(a, 1)
	var _t3415 = _s1197["r"]
	J.sp(_t3415, "state", "flee")
	var _t3416 = _s1197["r"]
	var _t3417 = _s1197["__p"]["fy"]
	var _t3418 = J.cl(_t3417, null, [J.gp(J.gp(_s1197["r"], "unit"), "f")])
	J.sp(_t3416, "y", _t3418)
	var _t3419 = _s1197["r"]
	var _t3420 = (((-1.0) if J.cmp(J.gp(_s1197["r"], "x"), J.div(_s1197["__p"]["WW"], 2.0), "<") else 1.0) * 150.0)
	J.sp(_t3419, "vx", _t3420)
	var _t3421 = _s1197["__p"]["chain"]
	var _t3423 = J.gp(_s1197["r"], "unit")
	var _t3422 = J.gp(_s1197["r"], "chainD")
	J.cl(_t3421, null, [_t3423, 16.0, (_t3422 if J.t(_t3422) else 0.0)])
	var _t3424 = _s1197["r"]
	var _t3425 = (0.9 if J.cmp(J.cl(_s1197["__p"]["rnd"], null, []), 0.35, "<") else 0.0)
	J.sp(_t3424, "tripT", _t3425)
	var _t3426 = _s1197["__p"]["pplScream"]
	J.cl(_t3426, null, [_s1197["r"]])
	if J.t(v_g_3124):
		var _t3427 = J.min_([100.0, J.add(J.gp(v_g_3124, "energy"), 20.0)])
		J.sp(v_g_3124, "energy", _t3427)
	var _t3428 = _s1197["__p"]["addFear"]
	J.cl(_t3428, null, [J.round(J.num(J.mul(15.0, J.gp(J.gp(_s1197["__p"]["G"], "mods"), "fear")))), J.gp(_s1197["r"], "x"), J.sub(J.gp(_s1197["r"], "y"), 80.0)])
	var _t3429 = J.gp(_s1197["__p"]["G"], "units")
	J.mc(_t3429, "forEach", [Callable(self, "_f505").bind(_s1197)])
	var _t3434 = J.gp(J.gp(_s1197["r"], "unit"), "story")
	if J.t(_t3434):
		var _t3433 = J.gp(_s1197["__p"]["G"], "story")
		_t3434 = J.cmp(J.mc(_t3433, "indexOf", [J.gp(J.gp(_s1197["r"], "unit"), "si")]), 0.0, "<")
	if J.t(_t3434):
		var _t3435 = J.gp(_s1197["__p"]["G"], "story")
		J.mc(_t3435, "push", [J.gp(J.gp(_s1197["r"], "unit"), "si")])
		J.mc(J.gp(_s1197["__p"]["G"], "story"), "sort", [])
		var _t3436 = _s1197["__p"]["toast"]
		J.cl(_t3436, null, [(J.add("收集到故事碎片——", J.gp(_s1197["__p"]["STORY"], J.gp(J.gp(_s1197["r"], "unit"), "si"))) + "（要正規經陰門返去先帶得走）")])

func _f506(this_, a: Array, env):
	var v_a_3130 = null; var v_x_3131 = null; var v_y_3132 = null
	v_a_3130 = J.arg(a, 0)
	v_x_3131 = J.arg(a, 1)
	v_y_3132 = J.arg(a, 2)
	var _t3437 = env["G"]
	var _t3438 = J.add(J.gp(_t3437, "fear"), v_a_3130)
	J.sp(_t3437, "fear", _t3438)
	var _t3439 = env["G"]
	var _t3440 = J.add(J.gp(_t3439, "fearTotal"), v_a_3130)
	J.sp(_t3439, "fearTotal", _t3440)
	var _t3441 = env["float"]
	J.cl(_t3441, null, [v_x_3131, v_y_3132, J.add("怕意 +", v_a_3130), "#9fd6bf"])
	if J.cmp(J.gp(env["G"], "fearTotal"), J.gp(env["G"], "fearNext"), ">="):
		var _t3442 = env["G"]
		var _t3443 = J.add(J.gp(_t3442, "fearNext"), 30.0)
		J.sp(_t3442, "fearNext", _t3443)
		var _t3444 = env["G"]
		var _t3445 = J.gp(env["G"], "choiceQ")
		var _t3446 = J.add((_t3445 if J.t(_t3445) else 0.0), 1.0)
		J.sp(_t3444, "choiceQ", _t3446)

func _f507(this_, a: Array, env):
	var v_g_3135 = null
	v_g_3135 = J.arg(a, 0)
	J.sp(v_g_3135, "auto", null)
	J.sp(v_g_3135, "autoS", null)
	if J.t(env["joy"]):
		env["joy"] = null

func _f508(this_, a: Array, env):
	var v_g_3138 = null
	v_g_3138 = J.arg(a, 0)
	var _t3447 = J.gp(v_g_3138, "still")
	var _t3448 = J.gp(v_g_3138, "still")
	var _t3449 = J.max_([(_t3448 if J.t(_t3448) else 0.0), 0.12])
	J.sp(v_g_3138, "still", _t3449)
	J.sp(v_g_3138, "mv", 0.0)

func _f511(this_, a: Array, env):
	var v_k_3165 = null; var v_m_3166 = null
	v_k_3165 = J.arg(a, 0)
	v_m_3166 = J.gp(J.gp(env["__p"]["G"], "nodes"), v_k_3165)
	var _t3451 = J.add(env["L"], J.hypot_([J.sub(J.gp(v_m_3166, "x"), J.gp(env["c"], "x")), J.sub(J.gp(v_m_3166, "y"), J.gp(env["c"], "y"))]))
	env["L"] = _t3451
	env["c"] = v_m_3166

func _f510(this_, a: Array, env):
	var v_st_3159 = null; var v_arr_3160 = null
	var _s1207 = {"__p": env, "L": null, "c": null}
	v_st_3159 = J.arg(a, 0)
	v_arr_3160 = J.arg(a, 1)
	_s1207["L"] = 0.0
	_s1207["c"] = J.gp(J.gp(_s1207["__p"]["G"], "nodes"), v_st_3159)
	var _t3450 = (v_arr_3160 if J.t(v_arr_3160) else [])
	J.mc(_t3450, "forEach", [Callable(self, "_f511").bind(_s1207)])
	return _s1207["L"]

func _f509(this_, a: Array, env):
	var v_g_3141 = null; var v_target_3142 = null; var v_ok_3143 = null; var v_a_3144 = null; var v_b_3145 = null; var v_p_3146 = null; var v_na_3147 = null; var v_nb_3148 = null; var v_E_3149 = null; var v_okB_3150 = null; var v_pB_3151 = null; var v_okA_3152 = null; var v_pA_3153 = null; var v_cB_3154 = null; var v_cA_3155 = null; var v_plen_3156 = null
	v_g_3141 = J.arg(a, 0)
	v_target_3142 = J.arg(a, 1)
	v_plen_3156 = Callable(self, "_f510").bind(env)
	if (not J.t(J.gp(v_g_3141, "to"))):
		if J.seq(J.gp(v_g_3141, "node"), v_target_3142):
			return true
		var _t3452 = env["gotoNode"]
		v_ok_3143 = J.cl(_t3452, null, [v_g_3141, v_target_3142])
		return v_ok_3143
	v_a_3144 = J.gp(v_g_3141, "node")
	v_b_3145 = J.gp(v_g_3141, "to")
	v_p_3146 = J.gp(v_g_3141, "p")
	v_na_3147 = J.gp(J.gp(env["G"], "nodes"), v_a_3144)
	v_nb_3148 = J.gp(J.gp(env["G"], "nodes"), v_b_3145)
	v_E_3149 = J.hypot_([J.sub(J.gp(v_nb_3148, "x"), J.gp(v_na_3147, "x")), J.sub(J.gp(v_nb_3148, "y"), J.gp(v_na_3147, "y"))])
	J.sp(v_g_3141, "to", null)
	J.sp(v_g_3141, "node", v_b_3145)
	var _t3453 = env["gotoNode"]
	v_okB_3150 = J.cl(_t3453, null, [v_g_3141, v_target_3142])
	v_pB_3151 = J.gp(v_g_3141, "auto")
	J.sp(v_g_3141, "node", v_a_3144)
	var _t3454 = env["gotoNode"]
	v_okA_3152 = J.cl(_t3454, null, [v_g_3141, v_target_3142])
	v_pA_3153 = J.gp(v_g_3141, "auto")
	J.sp(v_g_3141, "auto", null)
	J.sp(v_g_3141, "node", v_a_3144)
	J.sp(v_g_3141, "to", v_b_3145)
	J.sp(v_g_3141, "p", v_p_3146)
	v_cB_3154 = (J.add(J.mul(v_E_3149, J.sub(1.0, v_p_3146)), J.cl(v_plen_3156, null, [v_b_3145, v_pB_3151])) if J.t(v_okB_3150) else 1000000000.0)
	v_cA_3155 = (J.add(J.mul(v_E_3149, v_p_3146), J.cl(v_plen_3156, null, [v_a_3144, v_pA_3153])) if J.t(v_okA_3152) else 1000000000.0)
	var _t3455 = (not J.t(v_okA_3152))
	if ((not J.t(v_okB_3150)) if _t3455 else _t3455):
		return false
	if J.cmp(v_cA_3155, v_cB_3154, "<"):
		J.sp(v_g_3141, "node", v_b_3145)
		J.sp(v_g_3141, "to", v_a_3144)
		var _t3456 = J.sub(1.0, v_p_3146)
		J.sp(v_g_3141, "p", _t3456)
		var _t3457 = [v_a_3144]
		var _t3458 = J.mc(_t3457, "concat", [(v_pA_3153 if J.t(v_pA_3153) else [])])
		J.sp(v_g_3141, "auto", _t3458)
	else:
		var _t3459 = [v_b_3145]
		var _t3460 = J.mc(_t3459, "concat", [(v_pB_3151 if J.t(v_pB_3151) else [])])
		J.sp(v_g_3141, "auto", _t3460)
	return true

func _f513(this_, a: Array, env):
	var v_r_3176 = null; var v_d_3177 = null
	v_r_3176 = J.arg(a, 0)
	var _t3462 = (not J.seq(J.gp(v_r_3176, "state"), "home"))
	var _t3463 = (_t3462 if _t3462 else (not J.t(J.gp(v_r_3176, "unit"))))
	if (_t3463 if _t3463 else (not J.seq(J.gp(J.gp(v_r_3176, "unit"), "f"), env["f"]))):
		return null
	v_d_3177 = absf(J.num(J.sub(J.gp(v_r_3176, "x"), J.gp(env["g"], "x"))))
	if J.cmp(v_d_3177, env["bd"], "<"):
		env["bd"] = v_d_3177
		env["best"] = v_r_3176

func _f512(this_, a: Array, env):
	var v_R_3170 = null
	var _s1210 = {"__p": env, "g": null, "f": null, "best": null, "bd": null}
	_s1210["g"] = J.arg(a, 0)
	v_R_3170 = J.arg(a, 1)
	_s1210["f"] = J.gp(J.gp(J.gp(_s1210["__p"]["G"], "nodes"), J.gp(_s1210["g"], "node")), "f")
	_s1210["best"] = null
	_s1210["bd"] = v_R_3170
	var _t3461 = J.gp(_s1210["__p"]["G"], "res")
	J.mc(_t3461, "forEach", [Callable(self, "_f513").bind(_s1210)])
	return _s1210["best"]

func _f515(this_, a: Array, env):
	var v_l_3187 = null
	v_l_3187 = J.arg(a, 0)
	return J.seq(J.gp(v_l_3187, "to"), J.gp(env["un"], "id"))

func _f514(this_, a: Array, env):
	var v_g_3180 = null; var v_dn_3182 = null; var v_l_3183 = null; var v_ok_3184 = null
	var _s1213 = {"__p": env, "un": null}
	v_g_3180 = J.arg(a, 0)
	_s1213["un"] = J.arg(a, 1)
	v_dn_3182 = J.gp(J.gp(_s1213["__p"]["G"], "nodes"), J.gp(_s1213["un"], "did"))
	var _t3465 = v_dn_3182
	if J.t(_t3465):
		var _t3464 = J.gp(v_dn_3182, "links")
		_t3465 = J.mc(_t3464, "find", [Callable(self, "_f515").bind(_s1213)])
	v_l_3183 = _t3465
	if (not J.t(v_l_3183)):
		return "door"
	var _t3466 = _s1213["__p"]["canPass"]
	v_ok_3184 = J.cl(_t3466, null, [v_g_3180, J.gp(v_l_3183, "e")])
	return (null if J.seq(v_ok_3184, true) else v_ok_3184)

func _f517(this_, a: Array, env):
	var v_o_3210 = null; var v_d_3211 = null
	v_o_3210 = J.arg(a, 0)
	var _t3483 = J.seq(J.gp(v_o_3210, "state"), "flee")
	if (_t3483 if _t3483 else J.seq(J.gp(v_o_3210, "state"), "gone")):
		return null
	if (absf(J.num(J.sub(J.gp(v_o_3210, "y"), J.gp(env["g"], "y")))) > 30.0):
		return null
	v_d_3211 = absf(J.num(J.sub(J.gp(v_o_3210, "x"), J.gp(env["g"], "x"))))
	if J.cmp(v_d_3211, env["bd"], "<"):
		env["bd"] = v_d_3211
		env["h"] = v_o_3210

func _f518(this_, a: Array, env):
	var v_q_3214 = null
	v_q_3214 = J.arg(a, 0)
	var _t3485 = J.seq(J.gp(v_q_3214, "state"), "home")
	var _t3486 = (J.gp(v_q_3214, "unit") if _t3485 else _t3485)
	var _t3487 = (J.seq(J.gp(J.gp(v_q_3214, "unit"), "f"), env["f0"]) if J.t(_t3486) else _t3486)
	return ((absf(J.num(J.sub(J.gp(v_q_3214, "x"), J.gp(env["g"], "x")))) < 260.0) if J.t(_t3487) else _t3487)

func _f519(this_, a: Array, env):
	var v_a_3217 = null; var v_b_3218 = null
	v_a_3217 = J.arg(a, 0)
	v_b_3218 = J.arg(a, 1)
	return (absf(J.num(J.sub(J.gp(v_a_3217, "x"), J.gp(env["g"], "x")))) - absf(J.num(J.sub(J.gp(v_b_3218, "x"), J.gp(env["g"], "x")))))

func _f520(this_, a: Array, env):
	var v_q_3221 = null
	v_q_3221 = J.arg(a, 0)
	var _t3516 = J.seq(J.gp(v_q_3221, "state"), "home")
	var _t3517 = (J.gp(v_q_3221, "unit") if _t3516 else _t3516)
	return (J.seq(J.gp(J.gp(v_q_3221, "unit"), "f"), env["f"]) if J.t(_t3517) else _t3517)

func _f521(this_, a: Array, env):
	var v_q_3224 = null
	v_q_3224 = J.arg(a, 0)
	var _t3519 = J.gp(v_q_3224, "unit")
	var _t3520 = (J.seq(J.gp(J.gp(v_q_3224, "unit"), "f"), env["f"]) if J.t(_t3519) else _t3519)
	var _t3523 = ((absf(J.num(J.sub(J.gp(v_q_3224, "x"), J.gp(env["g"], "x")))) < 190.0) if J.t(_t3520) else _t3520)
	if J.t(_t3523):
		var _t3521 = J.seq(J.gp(v_q_3224, "state"), "away")
		var _t3522 = (_t3521 if _t3521 else J.seq(J.gp(v_q_3224, "state"), "leave"))
		_t3523 = (_t3522 if _t3522 else J.seq(J.gp(v_q_3224, "state"), "back"))
	return _t3523

func _f516(this_, a: Array, env):
	var v_n_3191 = null; var v_un0_3192 = null; var v_cands_3196 = null; var v_r_3197 = null; var v_blocked_3198 = null; var v_ci_3199 = null; var v_cq_3200 = null; var v_wq_3201 = null; var v_lw_3202 = null; var v_un_3203 = null; var v_tr_3204 = null; var v_some_3206 = null; var v_out_3207 = null
	var _s1215 = {"__p": env, "g": null, "h": null, "bd": null, "f0": null, "f": null}
	_s1215["g"] = J.gp(J.gp(_s1215["__p"]["G"], "gh"), J.gp(_s1215["__p"]["G"], "active"))
	var _t3467 = (not J.t(_s1215["g"]))
	var _t3468 = (_t3467 if _t3467 else J.gp(_s1215["g"], "home"))
	if J.t((_t3468 if J.t(_t3468) else J.gp(_s1215["g"], "out"))):
		return null
	var _t3470 = (J.gp(_s1215["__p"]["LIFT"], "state") if J.t(_s1215["__p"]["LIFT"]) else _s1215["__p"]["LIFT"])
	if J.t(_t3470):
		var _t3469 = J.mc(_s1215["__p"]["LIFT"], "state", [])
		_t3470 = J.seq(J.gp((_t3469 if J.t(_t3469) else {}), "gi"), J.gp(_s1215["g"], "i"))
	if J.t(_t3470):
		return null
	if J.t(J.gp(_s1215["g"], "sc")):
		return null
	if J.cmp(J.gp(_s1215["g"], "scareCd"), 0.0, ">"):
		var _t3471 = _s1215["__p"]["float"]
		J.cl(_t3471, null, [J.gp(_s1215["g"], "x"), J.sub(J.gp(_s1215["g"], "y"), 80.0), "啱啱嚇完，等陣先", "#dddddd"])
		return null
	if J.cmp(J.gp(_s1215["g"], "stun"), 0.0, ">"):
		var _t3472 = _s1215["__p"]["float"]
		J.cl(_t3472, null, [J.gp(_s1215["g"], "x"), J.sub(J.gp(_s1215["g"], "y"), 80.0), ("跌咗落嚟，等陣先嚇得" if J.cmp(J.gp(_s1215["g"], "dropT"), 0.0, ">") else ("數緊綠豆，數完先嚇得" if J.cmp(J.gp(_s1215["g"], "countT"), 0.0, ">") else "暈緊，等陣先嚇得")), "#ffd54a"])
		return null
	var _t3473 = _s1215["__p"]["standStill"]
	J.cl(_t3473, null, [_s1215["g"]])
	if J.cmp(J.gp(_s1215["g"], "sealT"), 0.0, ">"):
		var _t3474 = _s1215["__p"]["float"]
		J.cl(_t3474, null, [J.gp(_s1215["g"], "x"), J.sub(J.gp(_s1215["g"], "y"), 80.0), "鈴聲未散，暫時嚇唔到人", "#ffe9a0"])
		return null
	var _t3475 = _s1215["__p"]["mirrorOn"]
	if J.t(J.cl(_t3475, null, [_s1215["g"]])):
		var _t3476 = _s1215["__p"]["float"]
		J.cl(_t3476, null, [J.gp(_s1215["g"], "x"), J.sub(J.gp(_s1215["g"], "y"), 80.0), "被鏡照住，嚇唔出", "#ffe9a0"])
		return null
	v_n_3191 = J.gp(J.gp(_s1215["__p"]["G"], "nodes"), J.gp(_s1215["g"], "node"))
	var _t3477 = (not J.t(J.gp(_s1215["g"], "to")))
	if (J.seq(J.gp(v_n_3191, "kind"), "in") if _t3477 else _t3477):
		var _t3478 = _s1215["__p"]["unitOf"]
		v_un0_3192 = J.cl(_t3478, null, [J.gp(v_n_3191, "id")])
		var _t3479 = J.gp(v_un0_3192, "res")
		if J.t((J.seq(J.gp(J.gp(v_un0_3192, "res"), "state"), "home") if J.t(_t3479) else _t3479)):
			var _t3480 = _s1215["__p"]["calm"]
			J.cl(_t3480, null, [_s1215["g"]])
			var _t3481 = _s1215["__p"]["startMove"]
			J.cl(_t3481, null, [_s1215["g"], J.gp(v_un0_3192, "res"), v_un0_3192])
			return null
	_s1215["h"] = null
	_s1215["bd"] = 90.0
	var _t3482 = J.gp(_s1215["__p"]["G"], "guards")
	J.mc(_t3482, "forEach", [Callable(self, "_f517").bind(_s1215)])
	_s1215["f0"] = J.gp(v_n_3191, "f")
	var _t3484 = J.gp(_s1215["__p"]["G"], "res")
	var _t3488 = J.mc(_t3484, "filter", [Callable(self, "_f518").bind(_s1215)])
	v_cands_3196 = J.mc(_t3488, "sort", [Callable(self, "_f519").bind(_s1215)])
	v_r_3197 = null
	v_blocked_3198 = null
	v_ci_3199 = 0.0
	while true:
		if not J.cmp(v_ci_3199, J.len(v_cands_3196), "<"): break
		v_cq_3200 = J.gp(v_cands_3196, v_ci_3199)
		var _t3489 = _s1215["__p"]["doorBlock"]
		v_wq_3201 = J.cl(_t3489, null, [_s1215["g"], J.gp(v_cq_3200, "unit")])
		if (not J.t(v_wq_3201)):
			v_r_3197 = v_cq_3200
			break
		var _t3490 = (not J.t(v_blocked_3198))
		if ((absf(J.num(J.sub(J.gp(v_cq_3200, "x"), J.gp(_s1215["g"], "x")))) < 190.0) if _t3490 else _t3490):
			var _t3491 = {"r": v_cq_3200, "why": v_wq_3201}
			v_blocked_3198 = _t3491
		v_ci_3199 = J.num(v_ci_3199) + 1.0
	var _t3493 = _s1215["h"]
	if J.t(_t3493):
		var _t3492 = (not J.t(v_r_3197))
		_t3493 = (_t3492 if _t3492 else (absf(J.num(J.sub(J.gp(_s1215["h"], "x"), J.gp(_s1215["g"], "x")))) <= (absf(J.num(J.sub(J.gp(v_r_3197, "x"), J.gp(_s1215["g"], "x")))) + 20.0)))
	if J.t(_t3493):
		var _t3494 = _s1215["__p"]["calm"]
		J.cl(_t3494, null, [_s1215["g"]])
		var _t3495 = _s1215["__p"]["scareGuard"]
		J.cl(_t3495, null, [_s1215["g"], _s1215["h"]])
		return null
	if J.t((J.gp(_s1215["__p"]["LIFT"], "scareWaiting") if J.t(_s1215["__p"]["LIFT"]) else _s1215["__p"]["LIFT"])):
		v_lw_3202 = J.mc(_s1215["__p"]["LIFT"], "scareWaiting", [_s1215["g"]])
		if J.t(v_lw_3202):
			var _t3496 = _s1215["__p"]["calm"]
			J.cl(_t3496, null, [_s1215["g"]])
			var _t3497 = _s1215["g"]
			J.sp(_t3497, "scareCd", 1.2)
			var _t3498 = _s1215["g"]
			J.sp(_t3498, "actT", 0.9)
			var _t3499 = _s1215["__p"]["G"]
			J.sp(_t3499, "shake", 0.25)
			return null
	if J.t(v_r_3197):
		v_un_3203 = J.gp(v_r_3197, "unit")
		var _t3500 = J.gp(v_un_3203, "res")
		v_tr_3204 = (J.gp(v_un_3203, "res") if J.t((J.seq(J.gp(J.gp(v_un_3203, "res"), "state"), "home") if J.t(_t3500) else _t3500)) else v_r_3197)
		var _t3501 = _s1215["__p"]["approach"]
		if J.t(J.cl(_t3501, null, [_s1215["g"], J.gp(v_un_3203, "id")])):
			var _t3502 = _s1215["g"]
			var _t3503 = {"r": v_tr_3204}
			J.sp(_t3502, "autoS", _t3503)
			var _t3505 = (not J.t(J.gp(_s1215["g"], "to")))
			if J.t(_t3505):
				var _t3504 = J.gp(_s1215["g"], "auto")
				_t3505 = (not J.t((J.len(J.gp(_s1215["g"], "auto")) if J.t(_t3504) else _t3504)))
			if _t3505:
				var _t3506 = _s1215["__p"]["calm"]
				J.cl(_t3506, null, [_s1215["g"]])
				var _t3507 = _s1215["g"]
				J.sp(_t3507, "autoS", null)
				var _t3508 = _s1215["__p"]["startMove"]
				J.cl(_t3508, null, [_s1215["g"], v_tr_3204, v_un_3203])
				return null
			var _t3509 = _s1215["__p"]["float"]
			J.cl(_t3509, null, [J.gp(v_tr_3204, "x"), J.sub(J.gp(v_tr_3204, "y"), 86.0), J.add("飄埋去嚇", (J.gp(J.gp(_s1215["__p"]["HH"], J.gp(v_tr_3204, "hh")), "n") if J.t(J.gp(_s1215["__p"]["HH"], J.gp(v_tr_3204, "hh"))) else "住戶")), "#ffb7a0"])
			return null
		var _t3510 = _s1215["__p"]["float"]
		J.cl(_t3510, null, [J.gp(v_r_3197, "x"), J.sub(J.gp(v_r_3197, "y"), 80.0), "嚇唔到：行唔到入呢戶", "#ffb0b0"])
		return null
	if J.t(v_blocked_3198):
		var _t3511 = _s1215["__p"]["float"]
		var _t3513 = J.gp(_s1215["g"], "x")
		var _t3514 = J.sub(J.gp(_s1215["g"], "y"), 80.0)
		var _t3512 = J.gp(_s1215["__p"]["BLOCKMSG"], J.gp(v_blocked_3198, "why"))
		J.cl(_t3511, null, [_t3513, _t3514, J.add("嚇唔到——", (_t3512 if J.t(_t3512) else "呢戶未入得")), "#ffb0b0"])
		return null
	_s1215["f"] = J.gp(v_n_3191, "f")
	var _t3515 = J.gp(_s1215["__p"]["G"], "res")
	v_some_3206 = J.mc(_t3515, "some", [Callable(self, "_f520").bind(_s1215)])
	var _t3518 = J.gp(_s1215["__p"]["G"], "res")
	v_out_3207 = J.mc(_t3518, "some", [Callable(self, "_f521").bind(_s1215)])
	var _t3524 = _s1215["__p"]["float"]
	J.cl(_t3524, null, [J.gp(_s1215["g"], "x"), J.sub(J.gp(_s1215["g"], "y"), 80.0), ("佢出咗門，唔喺屋企" if J.t(v_out_3207) else ("附近冇人：行近住戶（或者撳住戶）先嚇" if J.t(v_some_3206) else "呢層冇人喺屋企")), "#dddddd"])

func _f522(this_, a: Array, env):
	var v_g_3227 = null; var v_h_3228 = null; var v_k_3229 = null
	v_g_3227 = J.arg(a, 0)
	v_h_3228 = J.arg(a, 1)
	J.sp(v_g_3227, "scareCd", 1.2)
	J.sp(v_g_3227, "actT", 0.9)
	var _t3525 = (1.0 if J.cmp(J.gp(v_h_3228, "x"), J.gp(v_g_3227, "x"), ">") else (-1.0))
	J.sp(v_g_3227, "dir", _t3525)
	var _t3526 = env["G"]
	J.sp(_t3526, "shake", 0.25)
	var _t3527 = J.seq(J.gp(v_h_3228, "kind"), "mirror")
	if (J.seq(signf(J.num(J.sub(J.gp(v_g_3227, "x"), J.gp(v_h_3228, "x")))), J.gp(v_h_3228, "dir")) if _t3527 else _t3527):
		var _t3528 = env["float"]
		J.cl(_t3528, null, [J.gp(v_h_3228, "x"), J.sub(J.gp(v_h_3228, "y"), 90.0), "正面對住面鏡，嚇唔到！兜去背後", "#ffe9a0"])
		return null
	var _t3529 = J.seq(J.gp(v_h_3228, "kind"), "decoy")
	if ((not J.t(J.gp(v_h_3228, "real"))) if _t3529 else _t3529):
		J.sp(v_h_3228, "state", "gone")
		v_k_3229 = 0.0
		while true:
			if not J.cmp(v_k_3229, 12.0, "<"): break
			var _t3530 = env["part"]
			J.cl(_t3530, null, [J.gp(v_h_3228, "x"), J.sub(J.gp(v_h_3228, "y"), 30.0), (J.sub(J.cl(env["rnd"], null, []), 0.5) * 120.0), ((-60.0) - J.mul(J.cl(env["rnd"], null, []), 60.0)), 0.9, "paper"])
			v_k_3229 = J.num(v_k_3229) + 1.0
		var _t3531 = env["float"]
		J.cl(_t3531, null, [J.gp(v_h_3228, "x"), J.sub(J.gp(v_h_3228, "y"), 80.0), "紙人替身！", "#e8d8b0"])
		return null
	if J.seq(J.gp(v_h_3228, "kind"), "guard"):
		var _t3532 = env["spook"]
		var _t3533 = env["pick"]
		J.cl(_t3532, null, [v_h_3228, J.cl(_t3533, null, [["嘩！有嘢喺我後面！", "乜……乜嘢嚟㗎？！"]])])
		var _t3534 = J.min_([100.0, J.add(J.gp(v_g_3227, "energy"), 15.0)])
		J.sp(v_g_3227, "energy", _t3534)
		return null
	J.sp(v_h_3228, "courage", J.num(J.gp(v_h_3228, "courage")) + -1.0)
	J.sp(v_h_3228, "alertT", 0.8)
	J.sp(v_h_3228, "shockT", 0.9)
	var _t3535 = env["float"]
	J.cl(_t3535, null, [J.gp(v_h_3228, "x"), J.sub(J.gp(v_h_3228, "y"), 90.0), ((J.add("羅盤保安膽量 -1（剩 ", J.max_([0.0, J.gp(v_h_3228, "courage")])) + "）") if J.seq(J.gp(v_h_3228, "kind"), "compass") else "嚇！"), "#ff7a5a"])
	if J.cmp(J.gp(v_h_3228, "courage"), 0.0, "<="):
		J.sp(v_h_3228, "state", "flee")
		var _t3536 = (((-1.0) if J.cmp(J.gp(v_h_3228, "x"), J.div(env["WW"], 2.0), "<") else 1.0) * 170.0)
		J.sp(v_h_3228, "vx", _t3536)
		var _t3537 = env["pplScream"]
		J.cl(_t3537, null, [v_h_3228])
		var _t3538 = env["addFear"]
		J.cl(_t3538, null, [(6.0 if J.seq(J.gp(v_h_3228, "kind"), "dog") else 12.0), J.gp(v_h_3228, "x"), J.sub(J.gp(v_h_3228, "y"), 80.0)])
		var _t3539 = J.min_([100.0, J.add(J.gp(v_g_3227, "energy"), 20.0)])
		J.sp(v_g_3227, "energy", _t3539)

func _f523(this_, a: Array, env):
	var v_x_3232 = null; var v_y_3233 = null; var v_vx_3234 = null; var v_vy_3235 = null; var v_life_3236 = null; var v_type_3237 = null
	v_x_3232 = J.arg(a, 0)
	v_y_3233 = J.arg(a, 1)
	v_vx_3234 = J.arg(a, 2)
	v_vy_3235 = J.arg(a, 3)
	v_life_3236 = J.arg(a, 4)
	v_type_3237 = J.arg(a, 5)
	if (J.len(J.gp(env["G"], "parts")) < 260.0):
		var _t3540 = J.gp(env["G"], "parts")
		J.mc(_t3540, "push", [{"x": v_x_3232, "y": v_y_3233, "vx": v_vx_3234, "vy": v_vy_3235, "life": v_life_3236, "max": v_life_3236, "type": v_type_3237}])

func _f525(this_, a: Array, env):
	var v_p_3244 = null
	v_p_3244 = J.arg(a, 0)
	var _t3542 = J.sub(J.gp(v_p_3244, "life"), env["dt"])
	J.sp(v_p_3244, "life", _t3542)
	var _t3543 = J.add(J.gp(v_p_3244, "x"), J.mul(J.gp(v_p_3244, "vx"), env["dt"]))
	J.sp(v_p_3244, "x", _t3543)
	var _t3544 = J.add(J.gp(v_p_3244, "y"), J.mul(J.gp(v_p_3244, "vy"), env["dt"]))
	J.sp(v_p_3244, "y", _t3544)
	var _t3545 = J.seq(J.gp(v_p_3244, "type"), "coin")
	var _t3546 = (_t3545 if _t3545 else J.seq(J.gp(v_p_3244, "type"), "crumb"))
	var _t3547 = (_t3546 if _t3546 else J.seq(J.gp(v_p_3244, "type"), "sweat"))
	var _t3548 = (_t3547 if _t3547 else J.seq(J.gp(v_p_3244, "type"), "tear"))
	var _t3549 = (_t3548 if _t3548 else J.seq(J.gp(v_p_3244, "type"), "paper"))
	if (_t3549 if _t3549 else J.seq(J.gp(v_p_3244, "type"), "drip")):
		var _t3550 = J.add(J.gp(v_p_3244, "vy"), J.mul(220.0, env["dt"]))
		J.sp(v_p_3244, "vy", _t3550)
	if J.seq(J.gp(v_p_3244, "type"), "smoke"):
		var _t3551 = J.mul(J.gp(v_p_3244, "vx"), 0.96)
		J.sp(v_p_3244, "vx", _t3551)
		var _t3552 = J.mul(J.gp(v_p_3244, "vy"), 0.96)
		J.sp(v_p_3244, "vy", _t3552)
	if (not J.leq(J.gp(v_p_3244, "tx"), null)):
		var _t3553 = J.add(J.gp(v_p_3244, "x"), (J.mul(J.sub(J.gp(v_p_3244, "tx"), J.gp(v_p_3244, "x")), env["dt"]) * 3.0))
		J.sp(v_p_3244, "x", _t3553)
		var _t3554 = J.add(J.gp(v_p_3244, "y"), (J.mul(J.sub(J.gp(v_p_3244, "ty"), J.gp(v_p_3244, "y")), env["dt"]) * 3.0))
		J.sp(v_p_3244, "y", _t3554)

func _f526(this_, a: Array, env):
	var v_p_3247 = null
	v_p_3247 = J.arg(a, 0)
	return J.cmp(J.gp(v_p_3247, "life"), 0.0, ">")

func _f527(this_, a: Array, env):
	var v_w_3250 = null
	v_w_3250 = J.arg(a, 0)
	var _t3559 = J.sub(J.gp(v_w_3250, "t"), env["dt"])
	J.sp(v_w_3250, "t", _t3559)

func _f528(this_, a: Array, env):
	var v_w_3253 = null
	v_w_3253 = J.arg(a, 0)
	return J.cmp(J.gp(v_w_3253, "t"), 0.0, ">")

func _f529(this_, a: Array, env):
	var v_u_3256 = null
	v_u_3256 = J.arg(a, 0)
	if J.cmp(J.gp(v_u_3256, "unlockFx"), 0.0, ">"):
		var _t3568 = J.sub(J.gp(v_u_3256, "unlockFx"), env["dt"])
		J.sp(v_u_3256, "unlockFx", _t3568)

func _f524(this_, a: Array, env):
	var v_k_3241 = null
	var _s1245 = {"__p": env, "dt": null}
	_s1245["dt"] = J.arg(a, 0)
	var _t3541 = J.gp(_s1245["__p"]["G"], "parts")
	J.mc(_t3541, "forEach", [Callable(self, "_f525").bind(_s1245)])
	var _t3555 = _s1245["__p"]["G"]
	var _t3556 = J.gp(_s1245["__p"]["G"], "parts")
	var _t3557 = J.mc(_t3556, "filter", [Callable(self, "_f526").bind(_s1245)])
	J.sp(_t3555, "parts", _t3557)
	var _t3558 = J.gp(_s1245["__p"]["G"], "wardFx")
	J.mc(_t3558, "forEach", [Callable(self, "_f527").bind(_s1245)])
	var _t3560 = _s1245["__p"]["G"]
	var _t3561 = J.gp(_s1245["__p"]["G"], "wardFx")
	var _t3562 = J.mc(_t3561, "filter", [Callable(self, "_f528").bind(_s1245)])
	J.sp(_t3560, "wardFx", _t3562)
	var _t3563 = _s1245["__p"]["G"]
	var _t3564 = J.gp(_s1245["__p"]["G"], "shake")
	var _t3565 = J.gp(_s1245["__p"]["G"], "shake")
	var _t3566 = J.max_([0.0, J.sub((_t3565 if J.t(_t3565) else 0.0), _s1245["dt"])])
	J.sp(_t3563, "shake", _t3566)
	var _t3567 = J.gp(_s1245["__p"]["G"], "units")
	J.mc(_t3567, "forEach", [Callable(self, "_f529").bind(_s1245)])
	for _t3569 in J.keys(J.gp(_s1245["__p"]["G"], "dark")):
		v_k_3241 = _t3569
		var _t3570 = J.gp(_s1245["__p"]["G"], "dark")
		var _t3571 = J.sub(J.gp(_t3570, v_k_3241), _s1245["dt"])
		J.sp(_t3570, v_k_3241, _t3571)
		if J.cmp(J.gp(J.gp(_s1245["__p"]["G"], "dark"), v_k_3241), 0.0, "<="):
			J.del(J.gp(_s1245["__p"]["G"], "dark"), v_k_3241)

func _f530(this_, a: Array, env):
	var v_i_3259 = null; var v_g_3260 = null
	v_i_3259 = J.arg(a, 0)
	v_g_3260 = J.gp(J.gp(env["G"], "gh"), v_i_3259)
	var _t3572 = J.cmp(J.gp(v_g_3260, "energy"), 100.0, "<")
	var _t3573 = (_t3572 if _t3572 else J.gp(v_g_3260, "home"))
	var _t3574 = (_t3573 if J.t(_t3573) else J.gp(v_g_3260, "out"))
	if J.t((_t3574 if J.t(_t3574) else J.gp(env["G"], "ult"))):
		return false
	J.sp(v_g_3260, "energy", 0.0)
	var _t3575 = env["G"]
	var _t3576 = {"g": v_g_3260, "t": 0.0, "f": J.gp(J.gp(J.gp(env["G"], "nodes"), J.gp(v_g_3260, "node")), "f"), "done": false}
	J.sp(_t3575, "ult", _t3576)
	return true

func _f532(this_, a: Array, env):
	var v_r_3272 = null
	v_r_3272 = J.arg(a, 0)
	var _t3578 = J.seq(J.gp(J.gp(v_r_3272, "unit"), "f"), env["f"])
	return (J.seq(J.gp(v_r_3272, "state"), "home") if _t3578 else _t3578)

func _f533(this_, a: Array, env):
	var v_h_3275 = null
	v_h_3275 = J.arg(a, 0)
	var _t3580 = J.seq(J.gp(J.gp(J.gp(env["__p"]["G"], "nodes"), J.gp(v_h_3275, "node")), "f"), env["f"])
	return ((not J.seq(J.gp(v_h_3275, "state"), "flee")) if _t3580 else _t3580)

func _f534(this_, a: Array, env):
	var v_r_3278 = null; var v_q_3279 = null; var v_p_3280 = null
	v_r_3278 = J.arg(a, 0)
	var _t3585 = env["__p"]["scareRes"]
	J.cl(_t3585, null, [v_r_3278, 130.0, env["g"]])
	v_q_3279 = 0.0
	while true:
		if not J.cmp(v_q_3279, 6.0, "<"): break
		v_p_3280 = {"x": J.gp(v_r_3278, "x"), "y": J.sub(J.gp(v_r_3278, "y"), 30.0), "vx": 0.0, "vy": 0.0, "life": 1.4, "max": 1.4, "type": "suck"}
		var _t3586 = J.gp(env["g"], "x")
		J.sp(v_p_3280, "tx", _t3586)
		var _t3587 = J.sub(J.gp(env["g"], "y"), 30.0)
		J.sp(v_p_3280, "ty", _t3587)
		var _t3588 = J.gp(env["__p"]["G"], "parts")
		J.mc(_t3588, "push", [v_p_3280])
		v_q_3279 = J.num(v_q_3279) + 1.0

func _f535(this_, a: Array, env):
	var v_h_3283 = null
	v_h_3283 = J.arg(a, 0)
	var _t3589 = J.gp(env["g"], "um")
	var _t3590 = J.mul(3.0, (_t3589 if J.t(_t3589) else 1.0))
	J.sp(v_h_3283, "wait", _t3590)

func _f536(this_, a: Array, env):
	var v_j_3286 = null
	v_j_3286 = J.arg(a, 0)
	return {"x": (J.max_([60.0, J.sub(J.gp(J.gp(J.gp(env["__p"]["G"], "gh"), 0.0), "x"), 260.0)]) + J.mul(v_j_3286, 110.0)), "v": ((1.0 if J.t(J.mod(v_j_3286, 2.0)) else (-1.0)) * (220.0 + J.mul(v_j_3286, 30.0)))}

func _f537(this_, a: Array, env):
	var v_u_3289 = null; var v_q_3290 = null; var v_it_3291 = null
	v_u_3289 = J.arg(a, 0)
	var _t3594 = J.seq(J.gp(v_u_3289, "f"), env["f"])
	if J.t((J.gp(v_u_3289, "open") if _t3594 else _t3594)):
		v_q_3290 = (J.len(J.gp(v_u_3289, "items")) - 1.0)
		while true:
			if not J.cmp(v_q_3290, 0.0, ">="): break
			v_it_3291 = J.gp(J.gp(v_u_3289, "items"), v_q_3290)
			var _t3595 = J.seq(v_it_3291, "money")
			var _t3596 = (_t3595 if _t3595 else J.seq(v_it_3291, "key"))
			var _t3598 = (_t3596 if _t3596 else J.seq(v_it_3291, "doll"))
			if J.t(_t3598):
				var _t3597 = (not J.seq(v_it_3291, "money"))
				_t3598 = (_t3597 if _t3597 else J.cmp(J.len(J.gp(env["__p"]["G"], "bag")), env["__p"]["BAGMAX"], "<"))
			if _t3598:
				var _t3599 = J.gp(v_u_3289, "items")
				J.mc(_t3599, "splice", [v_q_3290, 1.0])
				var _t3600 = env["__p"]["takeItem"]
				J.cl(_t3600, null, [env["g"], v_it_3291, v_u_3289])
				env["got"] = J.num(env["got"]) + 1.0
			v_q_3290 = J.num(v_q_3290) + -1.0

func _f538(this_, a: Array, env):
	var v_r_3294 = null
	v_r_3294 = J.arg(a, 0)
	var _t3602 = env["__p"]["scareRes"]
	J.cl(_t3602, null, [v_r_3294, 85.0, env["g"]])

func _f539(this_, a: Array, env):
	var v_r_3297 = null
	v_r_3297 = J.arg(a, 0)
	var _t3603 = J.gp(env["g"], "um")
	var _t3604 = J.mul(3.2, (_t3603 if J.t(_t3603) else 1.0))
	J.sp(v_r_3297, "tangle", _t3604)
	var _t3605 = env["__p"]["scareRes"]
	J.cl(_t3605, null, [v_r_3297, 105.0, env["g"]])

func _f540(this_, a: Array, env):
	var v_h_3300 = null
	v_h_3300 = J.arg(a, 0)
	var _t3606 = J.gp(env["g"], "um")
	var _t3607 = J.mul(3.2, (_t3606 if J.t(_t3606) else 1.0))
	J.sp(v_h_3300, "wait", _t3607)
	J.sp(v_h_3300, "to", null)

func _f531(this_, a: Array, env):
	var v_U_3263 = null; var v_k_3266 = null; var v_rs_3267 = null; var v_hs_3268 = null
	var _s1256 = {"__p": env, "g": null, "f": null, "got": null}
	v_U_3263 = J.arg(a, 0)
	_s1256["g"] = J.gp(v_U_3263, "g")
	_s1256["f"] = J.gp(v_U_3263, "f")
	v_k_3266 = J.gp(J.gp(_s1256["g"], "d"), "key")
	var _t3577 = J.gp(_s1256["__p"]["G"], "res")
	v_rs_3267 = J.mc(_t3577, "filter", [Callable(self, "_f532").bind(_s1256)])
	var _t3579 = J.gp(_s1256["__p"]["G"], "guards")
	v_hs_3268 = J.mc(_t3579, "filter", [Callable(self, "_f533").bind(_s1256)])
	if J.seq(v_k_3266, "eking"):
		var _t3581 = J.gp(_s1256["__p"]["G"], "dark")
		var _t3582 = _s1256["f"]
		var _t3583 = J.gp(_s1256["g"], "um")
		var _t3584 = J.mul(3.2, (_t3583 if J.t(_t3583) else 1.0))
		J.sp(_t3581, _t3582, _t3584)
		J.mc(v_rs_3267, "forEach", [Callable(self, "_f534").bind(_s1256)])
		J.mc(v_hs_3268, "forEach", [Callable(self, "_f535").bind(_s1256)])
	if J.seq(v_k_3266, "toyol"):
		var _t3591 = [0.0, 1.0, 2.0, 3.0, 4.0]
		var _t3592 = J.mc(_t3591, "map", [Callable(self, "_f536").bind(_s1256)])
		J.sp(v_U_3263, "clones", _t3592)
		_s1256["got"] = 0.0
		var _t3593 = J.gp(_s1256["__p"]["G"], "units")
		J.mc(_t3593, "forEach", [Callable(self, "_f537").bind(_s1256)])
		var _t3601 = _s1256["__p"]["float"]
		J.cl(_t3601, null, [J.gp(_s1256["g"], "x"), J.sub(J.gp(_s1256["g"], "y"), 100.0), (J.add("一掃光！攞到 ", _s1256["got"]) + " 件"), "#ffd54a"])
		J.mc(v_rs_3267, "forEach", [Callable(self, "_f538").bind(_s1256)])
	if J.seq(v_k_3266, "tianhua"):
		J.mc(v_rs_3267, "forEach", [Callable(self, "_f539").bind(_s1256)])
		J.mc(v_hs_3268, "forEach", [Callable(self, "_f540").bind(_s1256)])
	var _t3608 = _s1256["__p"]["G"]
	J.sp(_t3608, "shake", 0.5)

func _f541(this_, a: Array, env):
	var v_g_3303 = null
	v_g_3303 = J.gp(J.gp(env["G"], "gh"), J.gp(env["G"], "active"))
	var _t3609 = J.cmp(J.gp(v_g_3303, "invCd"), 0.0, ">")
	if J.t((_t3609 if _t3609 else J.gp(v_g_3303, "out"))):
		return null
	var _t3611 = J.gp(J.gp(env["G"], "mods"), "inv")
	var _t3610 = J.gp(v_g_3303, "im")
	var _t3612 = J.mul(_t3611, (_t3610 if J.t(_t3610) else 1.0))
	J.sp(v_g_3303, "inv", _t3612)
	var _t3614 = J.gp(v_g_3303, "inv")
	var _t3613 = J.gp(v_g_3303, "icd")
	var _t3615 = J.add(_t3614, J.mul(9.0, (_t3613 if J.t(_t3613) else 1.0)))
	J.sp(v_g_3303, "invCd", _t3615)
	var _t3616 = env["float"]
	J.cl(_t3616, null, [J.gp(v_g_3303, "x"), J.sub(J.gp(v_g_3303, "y"), 90.0), "隱身", "#9fe0ff"])

func _f542(this_, a: Array, env):
	var v_i_3306 = null; var v_c_3307 = null; var v_m_3308 = null
	v_i_3306 = J.arg(a, 0)
	v_c_3307 = J.gp(J.gp(env["G"], "choice"), v_i_3306)
	if (not J.t(v_c_3307)):
		return null
	v_m_3308 = J.gp(env["G"], "mods")
	if J.seq(J.gp(v_c_3307, "id"), "spd"):
		var _t3617 = J.mul(J.gp(v_m_3308, "spd"), 1.2)
		J.sp(v_m_3308, "spd", _t3617)
	if J.seq(J.gp(v_c_3307, "id"), "pow"):
		var _t3618 = J.mul(J.gp(v_m_3308, "pow"), 1.4)
		J.sp(v_m_3308, "pow", _t3618)
	if J.seq(J.gp(v_c_3307, "id"), "inv"):
		var _t3619 = J.add(J.gp(v_m_3308, "inv"), 2.0)
		J.sp(v_m_3308, "inv", _t3619)
	if J.seq(J.gp(v_c_3307, "id"), "task"):
		var _t3620 = J.mul(J.gp(v_m_3308, "task"), 1.35)
		J.sp(v_m_3308, "task", _t3620)
	if J.seq(J.gp(v_c_3307, "id"), "arm"):
		J.sp(v_m_3308, "arm", 0.5)
	if J.seq(J.gp(v_c_3307, "id"), "fear"):
		var _t3621 = J.mul(J.gp(v_m_3308, "fear"), 1.3)
		J.sp(v_m_3308, "fear", _t3621)
	var _t3622 = env["G"]
	J.sp(_t3622, "choice", null)
	var _t3623 = env["toast"]
	J.cl(_t3623, null, [J.add((J.add("揀咗「", J.gp(v_c_3307, "t")) + "」："), J.gp(v_c_3307, "d"))])

func _f543(this_, a: Array, env):
	var v_g_3311 = null; var v_r_3312 = null; var v_un_3313 = null; var v_ceil_3314 = null; var v_side_3315 = null
	v_g_3311 = J.arg(a, 0)
	v_r_3312 = J.arg(a, 1)
	v_un_3313 = J.arg(a, 2)
	var _t3624 = J.add(J.add(J.add(env["OMEN"], env["STRIKE"]), env["AFTER"]), 0.3)
	J.sp(v_g_3311, "scareCd", _t3624)
	var _t3625 = (1.0 if J.cmp(J.gp(v_r_3312, "x"), J.gp(v_g_3311, "x"), ">") else (-1.0))
	J.sp(v_g_3311, "dir", _t3625)
	var _t3626 = env["fy"]
	v_ceil_3314 = J.add(J.cl(_t3626, null, [J.add(J.gp(v_un_3313, "f"), 1.0)]), 16.0)
	v_side_3315 = (1.0 if (J.sub(J.gp(v_r_3312, "x"), J.gp(J.gp(v_un_3313, "rx"), 0.0)) < J.div(J.sub(J.gp(J.gp(v_un_3313, "rx"), 1.0), J.gp(J.gp(v_un_3313, "rx"), 0.0)), 2.0)) else (-1.0))
	var _t3627 = {"t": 0.0, "r": v_r_3312, "un": v_un_3313, "k": J.gp(J.gp(v_g_3311, "d"), "key"), "hit": false, "tr": false, "ceil": v_ceil_3314, "side": v_side_3315, "sx": J.add(J.gp(v_r_3312, "x"), J.mul(v_side_3315, 42.0))}
	J.sp(v_g_3311, "sc", _t3627)
	var _t3628 = env["float"]
	J.cl(_t3628, null, [J.gp(v_g_3311, "x"), (J.sub(J.gp(v_g_3311, "y"), J.gp(J.gp(v_g_3311, "d"), "h")) - 18.0), J.gp(J.gp(env["MV"], J.gp(J.gp(v_g_3311, "d"), "key")), "n"), "#ffb7a0"])

func _f544(this_, a: Array, env):
	var v_g_3318 = null; var v_dt_3319 = null; var v_S_3320 = null; var v_t0_3321 = null; var v_r_3322 = null; var v_k_3323 = null; var v_q_3324 = null; var v_p_3325 = null
	v_g_3318 = J.arg(a, 0)
	v_dt_3319 = J.arg(a, 1)
	v_S_3320 = J.gp(v_g_3318, "sc")
	if (not J.t(v_S_3320)):
		return null
	var _t3630 = J.cmp(J.gp(v_S_3320, "t"), env["OMEN"], "<")
	if J.t(_t3630):
		var _t3629 = J.gp(v_g_3318, "to")
		_t3630 = (_t3629 if J.t(_t3629) else J.cmp(J.gp(v_g_3318, "mv"), 0.05, ">"))
	if J.t(_t3630):
		var _t3631 = env["float"]
		J.cl(_t3631, null, [J.gp(v_g_3318, "x"), J.sub(J.gp(v_g_3318, "y"), 80.0), "一郁就破功", "#ffd54a"])
		J.sp(v_g_3318, "sc", null)
		J.sp(v_g_3318, "scareCd", 0.4)
		return null
	v_t0_3321 = J.gp(v_S_3320, "t")
	var _t3632 = J.add(J.gp(v_S_3320, "t"), v_dt_3319)
	J.sp(v_S_3320, "t", _t3632)
	v_r_3322 = J.gp(v_S_3320, "r")
	v_k_3323 = J.gp(v_S_3320, "k")
	if J.cmp(J.gp(v_S_3320, "t"), env["OMEN"], "<"):
		var _t3633 = J.seq(v_k_3323, "tianhua")
		if (J.cmp(J.cl(env["rnd"], null, []), J.mul(v_dt_3319, 9.0), "<") if _t3633 else _t3633):
			var _t3634 = env["part"]
			J.cl(_t3634, null, [J.add(J.gp(v_r_3322, "x"), (J.sub(J.cl(env["rnd"], null, []), 0.5) * 30.0)), J.add(J.gp(v_S_3320, "ceil"), 4.0), 0.0, 30.0, 0.8, "drip"])
		var _t3635 = J.seq(v_k_3323, "toyol")
		if ((not J.seq(floor(J.num(J.mul(J.gp(v_S_3320, "t"), 8.0))), floor(J.num(J.mul(v_t0_3321, 8.0))))) if _t3635 else _t3635):
			v_q_3324 = floor(J.num(J.mul(J.gp(v_S_3320, "t"), 8.0)))
			var _t3636 = J.gp(v_S_3320, "prints")
			var _t3637 = (_t3636 if J.t(_t3636) else [])
			J.sp(v_S_3320, "prints", _t3637)
			J.mc(_t3637, "push", [{"x": J.add(J.add(J.gp(v_S_3320, "sx"), J.div(J.mul(J.sub(J.gp(v_r_3322, "x"), J.gp(v_S_3320, "sx")), v_q_3324), 6.0)), (4.0 if J.t(J.mod(v_q_3324, 2.0)) else (-4.0))), "y": J.sub(J.gp(v_r_3322, "y"), 2.0)}])
	var _t3638 = (not J.t(J.gp(v_S_3320, "hit")))
	if (J.cmp(J.gp(v_S_3320, "t"), env["OMEN"], ">=") if _t3638 else _t3638):
		J.sp(v_S_3320, "hit", true)
		var _t3639 = env["G"]
		J.sp(_t3639, "shake", 0.35)
		J.sp(v_g_3318, "actT", 0.0)
		if J.seq(v_k_3323, "toyol"):
			v_q_3324 = 0.0
			while true:
				if not J.cmp(v_q_3324, 6.0, "<"): break
				v_p_3325 = {"x": J.gp(v_r_3322, "x"), "y": J.sub(J.gp(v_r_3322, "y"), 34.0), "vx": 0.0, "vy": 0.0, "life": 0.9, "max": 0.9, "type": "note"}
				var _t3640 = J.gp(v_S_3320, "sx")
				J.sp(v_p_3325, "tx", _t3640)
				var _t3641 = J.sub(J.gp(v_r_3322, "y"), 14.0)
				J.sp(v_p_3325, "ty", _t3641)
				var _t3642 = J.gp(env["G"], "parts")
				J.mc(_t3642, "push", [v_p_3325])
				v_q_3324 = J.num(v_q_3324) + 1.0
		if J.seq(v_k_3323, "eking"):
			v_q_3324 = 0.0
			while true:
				if not J.cmp(v_q_3324, 8.0, "<"): break
				var _t3643 = env["part"]
				J.cl(_t3643, null, [J.gp(v_S_3320, "sx"), J.sub(J.gp(v_r_3322, "y"), 30.0), (J.sub(J.cl(env["rnd"], null, []), 0.5) * 160.0), ((-80.0) - J.mul(J.cl(env["rnd"], null, []), 60.0)), 0.8, "crumb"])
				v_q_3324 = J.num(v_q_3324) + 1.0
		if J.seq(v_k_3323, "tianhua"):
			v_q_3324 = 0.0
			while true:
				if not J.cmp(v_q_3324, 10.0, "<"): break
				var _t3644 = env["part"]
				J.cl(_t3644, null, [J.gp(v_r_3322, "x"), J.sub(J.gp(v_r_3322, "y"), 50.0), (J.sub(J.cl(env["rnd"], null, []), 0.5) * 80.0), (-20.0), 0.7, "drip"])
				v_q_3324 = J.num(v_q_3324) + 1.0
		var _t3645 = env["scareRes"]
		J.cl(_t3645, null, [v_r_3322, 38.0, v_g_3318])
	var _t3646 = (not J.t(J.gp(v_S_3320, "tr")))
	if (J.cmp(J.gp(v_S_3320, "t"), J.add(env["OMEN"], env["STRIKE"]), ">=") if _t3646 else _t3646):
		J.sp(v_S_3320, "tr", true)
		var _t3647 = env["addTrace"]
		J.cl(_t3647, null, [J.gp(J.gp(env["MV"], v_k_3323), "tr"), v_S_3320, v_g_3318])
		if J.seq(v_k_3323, "tianhua"):
			J.sp(v_g_3318, "dropT", 2.3)
			var _t3648 = J.max_([J.gp(v_g_3318, "stun"), 2.3])
			J.sp(v_g_3318, "stun", _t3648)
			J.sp(v_g_3318, "to", null)
			J.sp(v_g_3318, "auto", null)
			var _t3649 = env["float"]
			J.cl(_t3649, null, [J.gp(v_g_3318, "x"), J.sub(J.gp(v_g_3318, "y"), 70.0), "哎吔……腰骨痛", "#e8d8b0"])
	if J.cmp(J.gp(v_S_3320, "t"), J.add(J.add(env["OMEN"], env["STRIKE"]), env["AFTER"]), ">="):
		J.sp(v_g_3318, "sc", null)

func _f546(this_, a: Array, env):
	var v_h_3337 = null; var v_hf_3338 = null; var v_d_3339 = null
	v_h_3337 = J.arg(a, 0)
	var _t3659 = (not J.seq(J.gp(v_h_3337, "kind"), "guard"))
	if (_t3659 if _t3659 else J.seq(J.gp(v_h_3337, "state"), "flee")):
		return null
	v_hf_3338 = J.gp(J.gp(J.gp(env["__p"]["G"], "nodes"), J.gp(v_h_3337, "node")), "f")
	v_d_3339 = ((absf(J.num(J.sub(v_hf_3338, J.gp(env["un"], "f")))) * 400.0) + absf(J.num(J.sub(J.gp(v_h_3337, "x"), J.gp(env["un"], "x")))))
	if J.cmp(v_d_3339, env["bd"], "<"):
		env["bd"] = v_d_3339
		env["best"] = v_h_3337

func _f545(this_, a: Array, env):
	var v_kind_3328 = null; var v_S_3329 = null; var v_g_3330 = null; var v_T_3332 = null
	var _s1292 = {"__p": env, "un": null, "best": null, "bd": null}
	v_kind_3328 = J.arg(a, 0)
	v_S_3329 = J.arg(a, 1)
	v_g_3330 = J.arg(a, 2)
	_s1292["un"] = J.gp(v_S_3329, "un")
	var _t3651 = J.gp(_s1292["un"], "f")
	var _t3652 = _s1292["un"]
	var _t3653 = (J.gp(_s1292["un"], "x") if J.seq(v_kind_3328, "hair") else J.gp(J.gp(v_S_3329, "r"), "x"))
	var _t3650 = _s1292["__p"]["fy"]
	v_T_3332 = {"k": v_kind_3328, "f": _t3651, "un": _t3652, "x": _t3653, "y": J.cl(_t3650, null, [J.gp(_s1292["un"], "f")]), "life": (40.0 if J.seq(v_kind_3328, "hair") else 22.0), "used": false, "t": 0.0}
	var _t3654 = J.gp(_s1292["__p"]["G"], "traces")
	J.mc(_t3654, "push", [v_T_3332])
	if J.seq(v_kind_3328, "mess"):
		var _t3655 = _s1292["__p"]["G"]
		var _t3656 = J.add(J.gp(_t3655, "alert"), 1.0)
		J.sp(_t3655, "alert", _t3656)
		var _t3657 = _s1292["__p"]["float"]
		J.cl(_t3657, null, [J.gp(_s1292["un"], "x"), J.sub(J.gp(_s1292["un"], "y"), 96.0), "翻箱倒櫃好嘈！全樓警覺 +1", "#ffb0b0"])
		J.cl(_s1292["__p"]["checkAlert"], null, [])
		_s1292["best"] = null
		_s1292["bd"] = 1000000000.0
		var _t3658 = J.gp(_s1292["__p"]["G"], "guards")
		J.mc(_t3658, "forEach", [Callable(self, "_f546").bind(_s1292)])
		if J.t(_s1292["best"]):
			var _t3660 = _s1292["best"]
			J.sp(_t3660, "state", "chase")
			var _t3661 = _s1292["best"]
			J.sp(_t3661, "alertT", 1.2)
			var _t3662 = _s1292["best"]
			J.sp(_t3662, "say", "邊度咁嘈？上去睇睇！")
			var _t3663 = _s1292["best"]
			J.sp(_t3663, "sayT", 2.4)
		if J.seq(J.gp(J.gp(v_S_3329, "r"), "state"), "home"):
			var _t3664 = J.gp(v_S_3329, "r")
			J.sp(_t3664, "hunt", 4.0)
			var _t3665 = _s1292["__p"]["say"]
			var _t3667 = J.gp(v_S_3329, "r")
			var _t3666 = _s1292["__p"]["pick"]
			J.cl(_t3665, null, [_t3667, J.cl(_t3666, null, [["我啲錢呢？！", "銀包去咗邊呀？！", "邊個翻亂晒啲嘢？"]])])
	if J.seq(v_kind_3328, "food"):
		J.sp(v_T_3332, "wait", 3.2)
	if J.seq(v_kind_3328, "hair"):
		var _t3668 = _s1292["__p"]["float"]
		J.cl(_t3668, null, [J.gp(_s1292["un"], "x"), J.sub(J.gp(_s1292["un"], "y"), 96.0), "門框留低濕頭髮……", "#9fe0ff"])

func _f549(this_, a: Array, env):
	var _t3681 = env["r"]
	J.sp(_t3681, "jumpT", 0.5)
	var _t3682 = env["__p"]["__p"]["say"]
	J.cl(_t3682, null, [env["r"], "嘩！碗入面有隻眼！"])
	var _t3683 = env["__p"]["__p"]["scareRes"]
	J.cl(_t3683, null, [env["r"], 30.0, null])
	var _t3684 = env["__p"]["__p"]["addFear"]
	J.cl(_t3684, null, [6.0, J.gp(env["r"], "x"), J.sub(J.gp(env["r"], "y"), 90.0)])
	var _t3685 = env["__p"]["__p"]["float"]
	J.cl(_t3685, null, [J.gp(env["r"], "x"), J.sub(J.gp(env["r"], "y"), 110.0), "二次嚇！", "#ff7a5a"])

func _f550(this_, a: Array, env):
	var v_h_3352 = null
	v_h_3352 = J.arg(a, 0)
	var _t3688 = J.gp(env["T"], "used")
	var _t3689 = (_t3688 if J.t(_t3688) else J.seq(J.gp(v_h_3352, "state"), "flee"))
	if J.t((_t3689 if J.t(_t3689) else J.seq(J.gp(v_h_3352, "kind"), "dog"))):
		return null
	var _t3690 = (not J.seq(J.gp(J.gp(J.gp(env["__p"]["__p"]["G"], "nodes"), J.gp(v_h_3352, "node")), "f"), J.gp(env["T"], "f")))
	if (_t3690 if _t3690 else (absf(J.num(J.sub(J.gp(v_h_3352, "x"), J.gp(env["T"], "x")))) > 26.0)):
		return null
	var _t3691 = env["T"]
	J.sp(_t3691, "used", true)
	J.sp(v_h_3352, "wait", 1.6)
	J.sp(v_h_3352, "to", null)
	J.sp(v_h_3352, "say", "成地都係飯……咦？碗郁咗！")
	J.sp(v_h_3352, "sayT", 2.2)
	J.sp(v_h_3352, "alertT", 1.0)
	var _t3692 = env["__p"]["__p"]["addFear"]
	J.cl(_t3692, null, [6.0, J.gp(v_h_3352, "x"), J.sub(J.gp(v_h_3352, "y"), 90.0)])
	var _t3693 = env["__p"]["__p"]["float"]
	J.cl(_t3693, null, [J.gp(v_h_3352, "x"), J.sub(J.gp(v_h_3352, "y"), 110.0), "二次嚇！", "#ff7a5a"])

func _f551(this_, a: Array, env):
	var v_h_3355 = null
	v_h_3355 = J.arg(a, 0)
	var _t3696 = (not J.t(env["vic"]))
	var _t3697 = ((not J.seq(J.gp(v_h_3355, "state"), "flee")) if _t3696 else _t3696)
	var _t3698 = ((not J.seq(J.gp(v_h_3355, "kind"), "dog")) if _t3697 else _t3697)
	var _t3699 = ((absf(J.num(J.sub(J.gp(v_h_3355, "y"), J.gp(env["T"], "y")))) < 30.0) if _t3698 else _t3698)
	if ((absf(J.num(J.sub(J.gp(v_h_3355, "x"), J.gp(env["T"], "x")))) < 18.0) if _t3699 else _t3699):
		env["vic"] = v_h_3355

func _f552(this_, a: Array, env):
	var v_r_3358 = null
	v_r_3358 = J.arg(a, 0)
	var _t3701 = (not J.t(env["vic"]))
	var _t3702 = (J.seq(J.gp(v_r_3358, "state"), "flee") if _t3701 else _t3701)
	var _t3703 = ((absf(J.num(J.sub(J.gp(v_r_3358, "y"), J.gp(env["T"], "y")))) < 30.0) if _t3702 else _t3702)
	if ((absf(J.num(J.sub(J.gp(v_r_3358, "x"), J.gp(env["T"], "x")))) < 18.0) if _t3703 else _t3703):
		env["vic"] = v_r_3358

func _f548(this_, a: Array, env):
	var _s1299 = {"__p": env, "T": null, "r": null, "vic": null}
	_s1299["T"] = J.arg(a, 0)
	var _t3670 = _s1299["T"]
	var _t3671 = J.sub(J.gp(_t3670, "life"), _s1299["__p"]["dt"])
	J.sp(_t3670, "life", _t3671)
	var _t3672 = _s1299["T"]
	var _t3673 = J.add(J.gp(_t3672, "t"), _s1299["__p"]["dt"])
	J.sp(_t3672, "t", _t3673)
	var _t3674 = J.seq(J.gp(_s1299["T"], "k"), "food")
	if ((not J.t(J.gp(_s1299["T"], "used"))) if _t3674 else _t3674):
		_s1299["r"] = J.gp(J.gp(_s1299["T"], "un"), "res")
		if J.t((J.seq(J.gp(_s1299["r"], "state"), "home") if J.t(_s1299["r"]) else _s1299["r"])):
			var _t3675 = _s1299["T"]
			var _t3676 = J.sub(J.gp(_t3675, "wait"), _s1299["__p"]["dt"])
			J.sp(_t3675, "wait", _t3676)
			if J.cmp(J.gp(_s1299["T"], "wait"), 0.0, "<="):
				var _t3677 = _s1299["T"]
				J.sp(_t3677, "used", true)
				var _t3678 = _s1299["__p"]["__p"]["say"]
				J.cl(_t3678, null, [_s1299["r"], "邊個搞到成地都係飯……"])
				var _t3679 = _s1299["r"]
				J.sp(_t3679, "tidy", 1.2)
				var _t3680 = _s1299["r"]
				var _t3686 = Callable(self, "_f549").bind(_s1299)
				J.sp(_t3680, "tidyCb", _t3686)
		else:
			var _t3687 = J.gp(_s1299["__p"]["__p"]["G"], "guards")
			J.mc(_t3687, "forEach", [Callable(self, "_f550").bind(_s1299)])
	var _t3694 = J.seq(J.gp(_s1299["T"], "k"), "hair")
	if ((not J.t(J.gp(_s1299["T"], "used"))) if _t3694 else _t3694):
		_s1299["vic"] = null
		var _t3695 = J.gp(_s1299["__p"]["__p"]["G"], "guards")
		J.mc(_t3695, "forEach", [Callable(self, "_f551").bind(_s1299)])
		var _t3700 = J.gp(_s1299["__p"]["__p"]["G"], "res")
		J.mc(_t3700, "forEach", [Callable(self, "_f552").bind(_s1299)])
		if J.t(_s1299["vic"]):
			var _t3704 = _s1299["T"]
			J.sp(_t3704, "used", true)
			var _t3705 = _s1299["T"]
			var _t3706 = J.min_([J.gp(_s1299["T"], "life"), 2.5])
			J.sp(_t3705, "life", _t3706)
			var _t3707 = _s1299["vic"]
			J.sp(_t3707, "tangle", 2.2)
			if J.seq(J.gp(_s1299["vic"], "state"), "flee"):
				var _t3708 = _s1299["vic"]
				J.sp(_t3708, "tripT", 1.2)
			else:
				var _t3709 = _s1299["vic"]
				J.sp(_t3709, "wait", 2.2)
				var _t3710 = _s1299["vic"]
				J.sp(_t3710, "to", null)
				var _t3711 = _s1299["vic"]
				J.sp(_t3711, "path", null)
			var _t3712 = _s1299["vic"]
			J.sp(_t3712, "say", "咩嘢纏住我隻腳呀？！濕㗎！")
			var _t3713 = _s1299["vic"]
			J.sp(_t3713, "sayT", 2.2)
			var _t3714 = _s1299["__p"]["__p"]["addFear"]
			J.cl(_t3714, null, [6.0, J.gp(_s1299["vic"], "x"), J.sub(J.gp(_s1299["vic"], "y"), 90.0)])
			var _t3715 = _s1299["__p"]["__p"]["float"]
			J.cl(_t3715, null, [J.gp(_s1299["vic"], "x"), J.sub(J.gp(_s1299["vic"], "y"), 112.0), "濕髮纏腳！", "#9fe0ff"])

func _f553(this_, a: Array, env):
	var v_T_3361 = null
	v_T_3361 = J.arg(a, 0)
	return J.cmp(J.gp(v_T_3361, "life"), 0.0, ">")

func _f554(this_, a: Array, env):
	var v_r_3364 = null; var v_cb_3365 = null
	v_r_3364 = J.arg(a, 0)
	if J.cmp(J.gp(v_r_3364, "hunt"), 0.0, ">"):
		var _t3720 = J.sub(J.gp(v_r_3364, "hunt"), env["dt"])
		J.sp(v_r_3364, "hunt", _t3720)
		if J.seq(J.gp(v_r_3364, "state"), "home"):
			var _t3721 = J.add(J.gp(v_r_3364, "fear"), J.mul(env["dt"], 5.0))
			J.sp(v_r_3364, "fear", _t3721)
			if J.cmp(J.gp(v_r_3364, "fear"), 100.0, ">="):
				var _t3722 = env["__p"]["flee"]
				J.cl(_t3722, null, [v_r_3364, null])
	if J.cmp(J.gp(v_r_3364, "tidy"), 0.0, ">"):
		var _t3723 = J.sub(J.gp(v_r_3364, "tidy"), env["dt"])
		J.sp(v_r_3364, "tidy", _t3723)
		var _t3724 = J.cmp(J.gp(v_r_3364, "tidy"), 0.0, "<=")
		if J.t((J.gp(v_r_3364, "tidyCb") if _t3724 else _t3724)):
			v_cb_3365 = J.gp(v_r_3364, "tidyCb")
			J.sp(v_r_3364, "tidyCb", null)
			J.cl(v_cb_3365, null, [])
	if J.t(J.gp(v_r_3364, "react")):
		var _t3725 = J.gp(v_r_3364, "react")
		var _t3726 = J.sub(J.gp(_t3725, "t"), env["dt"])
		J.sp(_t3725, "t", _t3726)
		if J.cmp(J.gp(J.gp(v_r_3364, "react"), "t"), 0.0, "<="):
			J.sp(v_r_3364, "react", null)
	if J.cmp(J.gp(v_r_3364, "fleeAfter"), 0.0, ">"):
		var _t3727 = J.sub(J.gp(v_r_3364, "fleeAfter"), env["dt"])
		J.sp(v_r_3364, "fleeAfter", _t3727)
		var _t3728 = J.cmp(J.gp(v_r_3364, "fleeAfter"), 0.0, "<=")
		if (J.seq(J.gp(v_r_3364, "state"), "home") if _t3728 else _t3728):
			J.sp(v_r_3364, "fleeAfter", 0.0)
			var _t3729 = env["__p"]["flee"]
			J.cl(_t3729, null, [v_r_3364, J.gp(v_r_3364, "fleeG")])

func _f555(this_, a: Array, env):
	var v_h_3368 = null
	v_h_3368 = J.arg(a, 0)
	if J.cmp(J.gp(v_h_3368, "tangle"), 0.0, ">"):
		var _t3731 = J.sub(J.gp(v_h_3368, "tangle"), env["dt"])
		J.sp(v_h_3368, "tangle", _t3731)

func _f547(this_, a: Array, env):
	var _s1298 = {"__p": env, "dt": null}
	_s1298["dt"] = J.arg(a, 0)
	var _t3669 = J.gp(_s1298["__p"]["G"], "traces")
	J.mc(_t3669, "forEach", [Callable(self, "_f548").bind(_s1298)])
	var _t3716 = _s1298["__p"]["G"]
	var _t3717 = J.gp(_s1298["__p"]["G"], "traces")
	var _t3718 = J.mc(_t3717, "filter", [Callable(self, "_f553").bind(_s1298)])
	J.sp(_t3716, "traces", _t3718)
	var _t3719 = J.gp(_s1298["__p"]["G"], "res")
	J.mc(_t3719, "forEach", [Callable(self, "_f554").bind(_s1298)])
	var _t3730 = J.gp(_s1298["__p"]["G"], "guards")
	J.mc(_t3730, "forEach", [Callable(self, "_f555").bind(_s1298)])

func _f557(this_, a: Array, env):
	var v_o_3378 = null
	v_o_3378 = J.arg(a, 0)
	var _t3734 = (not J.seq(v_o_3378, env["r"]))
	var _t3735 = ((not J.seq(J.gp(v_o_3378, "state"), "flee")) if _t3734 else _t3734)
	var _t3736 = ((not J.seq(J.gp(v_o_3378, "state"), "gone")) if _t3735 else _t3735)
	var _t3737 = ((absf(J.num(J.sub(J.gp(v_o_3378, "y"), J.gp(env["r"], "y")))) < 30.0) if _t3736 else _t3736)
	return ((absf(J.num(J.sub(J.gp(v_o_3378, "x"), J.gp(env["r"], "x")))) < 130.0) if _t3737 else _t3737)

func _f556(this_, a: Array, env):
	var v_g_3372 = null; var v_opts_3373 = null; var v_near_3374 = null; var v_k_3375 = null
	var _s1321 = {"__p": env, "r": null}
	_s1321["r"] = J.arg(a, 0)
	v_g_3372 = J.arg(a, 1)
	if J.t(J.gp(_s1321["r"], "brave")):
		return "slipper"
	v_opts_3373 = ["scream", "kneel", "cover", "fall", "phone"]
	var _t3732 = J.gp(_s1321["__p"]["G"], "guards")
	var _t3733 = J.mc(_t3732, "concat", [J.gp(_s1321["__p"]["G"], "res")])
	v_near_3374 = J.mc(_t3733, "some", [Callable(self, "_f557").bind(_s1321)])
	if J.t(v_near_3374):
		J.mc(v_opts_3373, "push", ["push", "push"])
	var _t3738 = _s1321["__p"]["pick"]
	v_k_3375 = J.cl(_t3738, null, [v_opts_3373])
	if J.seq(v_k_3375, J.gp(_s1321["r"], "lastReact")):
		var _t3739 = _s1321["__p"]["pick"]
		var _t3740 = J.cl(_t3739, null, [v_opts_3373])
		v_k_3375 = _t3740
	var _t3741 = _s1321["r"]
	J.sp(_t3741, "lastReact", v_k_3375)
	return v_k_3375

func _f559(this_, a: Array, env):
	var v_q_3388 = null
	v_q_3388 = J.arg(a, 0)
	var _t3761 = (not J.t(env["o"]))
	var _t3762 = ((not J.seq(v_q_3388, env["r"])) if _t3761 else _t3761)
	var _t3763 = ((not J.seq(J.gp(v_q_3388, "state"), "flee")) if _t3762 else _t3762)
	var _t3764 = ((not J.seq(J.gp(v_q_3388, "state"), "gone")) if _t3763 else _t3763)
	var _t3765 = ((absf(J.num(J.sub(J.gp(v_q_3388, "y"), J.gp(env["r"], "y")))) < 30.0) if _t3764 else _t3764)
	if ((absf(J.num(J.sub(J.gp(v_q_3388, "x"), J.gp(env["r"], "x")))) < 130.0) if _t3765 else _t3765):
		env["o"] = v_q_3388

func _f558(this_, a: Array, env):
	var v_g_3382 = null; var v_k_3383 = null; var v_ok_3384 = null
	var _s1323 = {"__p": env, "r": null, "o": null}
	_s1323["r"] = J.arg(a, 0)
	v_g_3382 = J.arg(a, 1)
	var _t3742 = _s1323["__p"]["pickReact"]
	v_k_3383 = J.cl(_t3742, null, [_s1323["r"], v_g_3382])
	var _t3743 = _s1323["r"]
	var _t3744 = {"k": v_k_3383, "t": 1.7}
	J.sp(_t3743, "react", _t3744)
	var _t3745 = _s1323["__p"]["say"]
	var _t3747 = _s1323["r"]
	var _t3746 = _s1323["__p"]["pick"]
	J.cl(_t3745, null, [_t3747, J.cl(_t3746, null, [J.gp(_s1323["__p"]["REACT"], v_k_3383)])])
	if J.seq(v_k_3383, "phone"):
		var _t3748 = J.gp(_s1323["__p"]["G"], "phoneCd")
		var _t3750 = J.cmp((_t3748 if J.t(_t3748) else 0.0), 0.0, "<=")
		if J.t(_t3750):
			var _t3749 = J.gp(_s1323["__p"]["G"], "ult")
			_t3750 = (not J.t((J.gp(J.gp(_s1323["__p"]["G"], "ult"), "phoned") if J.t(_t3749) else _t3749)))
		v_ok_3384 = _t3750
		if J.t(v_ok_3384):
			var _t3751 = _s1323["__p"]["G"]
			var _t3752 = J.add(J.gp(_t3751, "alert"), 1.0)
			J.sp(_t3751, "alert", _t3752)
			var _t3753 = _s1323["__p"]["G"]
			J.sp(_t3753, "phoneCd", 8.0)
			if J.t(J.gp(_s1323["__p"]["G"], "ult")):
				var _t3754 = J.gp(_s1323["__p"]["G"], "ult")
				J.sp(_t3754, "phoned", true)
			var _t3755 = _s1323["__p"]["float"]
			J.cl(_t3755, null, [J.gp(_s1323["r"], "x"), J.sub(J.gp(_s1323["r"], "y"), 100.0), "打電話求救！警覺 +1", "#ffb0b0"])
		else:
			var _t3756 = _s1323["__p"]["float"]
			J.cl(_t3756, null, [J.gp(_s1323["r"], "x"), J.sub(J.gp(_s1323["r"], "y"), 100.0), "電話打唔通……", "#e8d8b0"])
	var _t3757 = J.seq(v_k_3383, "slipper")
	if J.t((v_g_3382 if _t3757 else _t3757)):
		J.sp(v_g_3382, "bounceT", 0.45)
		var _t3758 = _s1323["__p"]["float"]
		J.cl(_t3758, null, [J.gp(v_g_3382, "x"), (J.sub(J.gp(v_g_3382, "y"), J.gp(J.gp(v_g_3382, "d"), "h")) - 6.0), "拖鞋打空氣", "#e8d8b0"])
	if J.seq(v_k_3383, "push"):
		_s1323["o"] = null
		var _t3759 = J.gp(_s1323["__p"]["G"], "guards")
		var _t3760 = J.mc(_t3759, "concat", [J.gp(_s1323["__p"]["G"], "res")])
		J.mc(_t3760, "forEach", [Callable(self, "_f559").bind(_s1323)])
		if J.t(_s1323["o"]):
			var _t3766 = _s1323["r"]
			var _t3767 = (1.0 if J.cmp(J.gp(_s1323["o"], "x"), J.gp(_s1323["r"], "x"), ">") else (-1.0))
			J.sp(_t3766, "pushTo", _t3767)
			var _t3768 = _s1323["o"]
			J.sp(_t3768, "jumpT", 0.5)
			if J.t(J.gp(_s1323["o"], "unit")):
				var _t3769 = _s1323["o"]
				var _t3770 = J.add(J.gp(_t3769, "fear"), 10.0)
				J.sp(_t3769, "fear", _t3770)
			else:
				var _t3771 = _s1323["o"]
				var _t3772 = J.gp(_s1323["o"], "wait")
				var _t3773 = J.gp(_s1323["o"], "wait")
				var _t3774 = J.max_([(_t3773 if J.t(_t3773) else 0.0), 0.9])
				J.sp(_t3771, "wait", _t3774)

func _f561(this_, a: Array, env):
	var v_u_3395 = null
	v_u_3395 = J.arg(a, 0)
	var _t3777 = J.cmp(env["c"], 2.0, "<")
	var _t3778 = (J.gp(v_u_3395, "res") if _t3777 else _t3777)
	var _t3779 = ((not J.seq(J.gp(v_u_3395, "ot"), "deity")) if J.t(_t3778) else _t3778)
	var _t3780 = (J.cmp(J.gp(v_u_3395, "f"), 0.0, ">") if J.t(_t3779) else _t3779)
	if J.t((J.seq(J.mod(J.add(J.gp(v_u_3395, "f"), J.gp(v_u_3395, "u")), 2.0), 1.0) if J.t(_t3780) else _t3780)):
		J.sp(v_u_3395, "beans", true)
		env["c"] = J.num(env["c"]) + 1.0

func _f562(this_, a: Array, env):
	var v_u_3398 = null
	v_u_3398 = J.arg(a, 0)
	var _t3782 = J.gp(v_u_3398, "res")
	return ((not J.seq(J.gp(v_u_3398, "ot"), "deity")) if J.t(_t3782) else _t3782)

func _f560(this_, a: Array, env):
	var v_u_3392 = null
	var _s1332 = {"__p": env, "c": null}
	if J.t(J.gp(_s1332["__p"]["G"], "beansInit")):
		return null
	var _t3775 = _s1332["__p"]["G"]
	J.sp(_t3775, "beansInit", true)
	_s1332["c"] = 0.0
	var _t3776 = J.gp(_s1332["__p"]["G"], "units")
	J.mc(_t3776, "forEach", [Callable(self, "_f561").bind(_s1332)])
	if (not J.t(_s1332["c"])):
		var _t3781 = J.gp(_s1332["__p"]["G"], "units")
		v_u_3392 = J.mc(_t3781, "find", [Callable(self, "_f562").bind(_s1332)])
		if J.t(v_u_3392):
			J.sp(v_u_3392, "beans", true)

func _f563(this_, a: Array, env):
	var v_g_3401 = null; var v_dt_3402 = null; var v_n_3403 = null; var v_un_3404 = null
	v_g_3401 = J.arg(a, 0)
	v_dt_3402 = J.arg(a, 1)
	if (not J.seq(J.gp(J.gp(v_g_3401, "d"), "key"), "toyol")):
		return null
	v_n_3403 = J.gp(J.gp(env["G"], "nodes"), J.gp(v_g_3401, "node"))
	if J.cmp(J.gp(v_g_3401, "countT"), 0.0, ">"):
		var _t3783 = J.sub(J.gp(v_g_3401, "countT"), v_dt_3402)
		J.sp(v_g_3401, "countT", _t3783)
		var _t3784 = J.gp(v_g_3401, "cntAcc")
		var _t3785 = J.add((_t3784 if J.t(_t3784) else 0.0), v_dt_3402)
		J.sp(v_g_3401, "cntAcc", _t3785)
		if J.cmp(J.gp(v_g_3401, "cntAcc"), 0.32, ">"):
			J.sp(v_g_3401, "cntAcc", 0.0)
			var _t3786 = J.gp(v_g_3401, "cntN")
			var _t3787 = J.add((_t3786 if J.t(_t3786) else 0.0), 1.0)
			J.sp(v_g_3401, "cntN", _t3787)
		return null
	var _t3788 = J.seq(J.gp(v_n_3403, "kind"), "in")
	if ((not J.t(J.gp(v_g_3401, "to"))) if _t3788 else _t3788):
		var _t3789 = env["unitOf"]
		v_un_3404 = J.cl(_t3789, null, [J.gp(v_n_3403, "id")])
		var _t3790 = J.gp(v_un_3404, "beans")
		if J.t(((not J.t(J.gp(v_un_3404, "beansDone"))) if J.t(_t3790) else _t3790)):
			J.sp(v_un_3404, "beansDone", true)
			J.sp(v_g_3401, "countT", 2.6)
			J.sp(v_g_3401, "stun", 2.6)
			J.sp(v_g_3401, "cntN", 0.0)
			J.sp(v_g_3401, "taskP", 0.0)
			J.sp(v_g_3401, "sc", null)
			var _t3791 = env["float"]
			J.cl(_t3791, null, [J.gp(v_g_3401, "x"), (J.sub(J.gp(v_g_3401, "y"), J.gp(J.gp(v_g_3401, "d"), "h")) - 20.0), "地下有綠豆！忍唔住坐低數……", "#b8f0a0"])

func _f564(this_, a: Array, env):
	var v_x_3407 = null; var v_y_3408 = null; var v_fill_3409 = null
	v_x_3407 = J.arg(a, 0)
	v_y_3408 = J.arg(a, 1)
	v_fill_3409 = J.arg(a, 2)
	var _t3792 = env["ctx"]
	J.sp(_t3792, "fillStyle", "#d8d0c0")
	J.mc(env["ctx"], "beginPath", [])
	J.mc(env["ctx"], "moveTo", [J.sub(v_x_3407, 9.0), J.sub(v_y_3408, 6.0)])
	J.mc(env["ctx"], "quadraticCurveTo", [v_x_3407, J.add(v_y_3408, 5.0), J.add(v_x_3407, 9.0), J.sub(v_y_3408, 6.0)])
	J.mc(env["ctx"], "closePath", [])
	J.mc(env["ctx"], "fill", [])
	var _t3793 = env["ctx"]
	J.sp(_t3793, "strokeStyle", "#6a4a2a")
	var _t3794 = env["ctx"]
	J.sp(_t3794, "lineWidth", 1.0)
	J.mc(env["ctx"], "stroke", [])
	if J.cmp(v_fill_3409, 0.0, ">"):
		var _t3795 = env["ctx"]
		J.sp(_t3795, "fillStyle", "#f0e6c8")
		J.mc(env["ctx"], "beginPath", [])
		J.mc(env["ctx"], "ellipse", [v_x_3407, J.sub(v_y_3408, 6.0), J.mul(8.0, v_fill_3409), 2.6, 0.0, 0.0, 7.0])
		J.mc(env["ctx"], "fill", [])

func _f565(this_, a: Array, env):
	var v_x_3412 = null; var v_y_3413 = null; var v_R_3414 = null; var v_open_3415 = null; var v_dir_3416 = null; var v_n_3417 = null; var v_i_3418 = null; var v_tx_3419 = null
	v_x_3412 = J.arg(a, 0)
	v_y_3413 = J.arg(a, 1)
	v_R_3414 = J.arg(a, 2)
	v_open_3415 = J.arg(a, 3)
	v_dir_3416 = J.arg(a, 4)
	J.mc(env["ctx"], "save", [])
	J.mc(env["ctx"], "translate", [v_x_3412, v_y_3413])
	J.mc(env["ctx"], "scale", [v_dir_3416, 1.0])
	var _t3796 = env["ctx"]
	J.sp(_t3796, "fillStyle", "#120808")
	J.mc(env["ctx"], "beginPath", [])
	J.mc(env["ctx"], "ellipse", [0.0, 0.0, J.mul(v_R_3414, 1.1), J.mul(v_R_3414, 0.85), 0.0, 0.0, 7.0])
	J.mc(env["ctx"], "fill", [])
	var _t3797 = env["ctx"]
	J.sp(_t3797, "fillStyle", "#7a0e0e")
	J.mc(env["ctx"], "beginPath", [])
	J.mc(env["ctx"], "ellipse", [J.mul(v_R_3414, 0.15), 0.0, J.mul(v_R_3414, 0.85), (J.mul(J.mul(v_R_3414, 0.62), v_open_3415) + 2.0), 0.0, 0.0, 7.0])
	J.mc(env["ctx"], "fill", [])
	var _t3798 = env["ctx"]
	J.sp(_t3798, "fillStyle", "#e8e0cc")
	v_n_3417 = 7.0
	v_i_3418 = 0.0
	while true:
		if not J.cmp(v_i_3418, v_n_3417, "<"): break
		v_tx_3419 = (((-J.num(v_R_3414)) * 0.65) + J.div((J.mul(v_i_3418, v_R_3414) * 1.6), v_n_3417))
		J.mc(env["ctx"], "beginPath", [])
		J.mc(env["ctx"], "moveTo", [v_tx_3419, J.mul(((-J.num(v_R_3414)) * 0.62), v_open_3415)])
		J.mc(env["ctx"], "lineTo", [J.add(v_tx_3419, J.mul(v_R_3414, 0.11)), (J.mul(((-J.num(v_R_3414)) * 0.62), v_open_3415) + J.mul(v_R_3414, 0.28))])
		J.mc(env["ctx"], "lineTo", [J.add(v_tx_3419, J.mul(v_R_3414, 0.22)), J.mul(((-J.num(v_R_3414)) * 0.62), v_open_3415)])
		J.mc(env["ctx"], "fill", [])
		J.mc(env["ctx"], "beginPath", [])
		J.mc(env["ctx"], "moveTo", [v_tx_3419, J.mul(J.mul(v_R_3414, 0.62), v_open_3415)])
		J.mc(env["ctx"], "lineTo", [J.add(v_tx_3419, J.mul(v_R_3414, 0.11)), (J.mul(J.mul(v_R_3414, 0.62), v_open_3415) - J.mul(v_R_3414, 0.26))])
		J.mc(env["ctx"], "lineTo", [J.add(v_tx_3419, J.mul(v_R_3414, 0.22)), J.mul(J.mul(v_R_3414, 0.62), v_open_3415)])
		J.mc(env["ctx"], "fill", [])
		v_i_3418 = J.num(v_i_3418) + 1.0
	var _t3799 = env["ctx"]
	J.sp(_t3799, "fillStyle", "#d0c060")
	J.mc(env["ctx"], "beginPath", [])
	J.mc(env["ctx"], "arc", [((-J.num(v_R_3414)) * 0.55), ((-J.num(v_R_3414)) * 0.9), J.mul(v_R_3414, 0.12), 0.0, 7.0])
	J.mc(env["ctx"], "arc", [J.mul(v_R_3414, 0.35), ((-J.num(v_R_3414)) * 0.95), J.mul(v_R_3414, 0.12), 0.0, 7.0])
	J.mc(env["ctx"], "fill", [])
	J.mc(env["ctx"], "restore", [])

func _f566(this_, a: Array, env):
	var v_s_3422 = null; var v_x_3423 = null; var v_y_3424 = null; var v_c_3425 = null; var v_sz_3426 = null
	v_s_3422 = J.arg(a, 0)
	v_x_3423 = J.arg(a, 1)
	v_y_3424 = J.arg(a, 2)
	v_c_3425 = J.arg(a, 3)
	v_sz_3426 = J.arg(a, 4)
	var _t3800 = env["crText"]
	J.cl(_t3800, null, [env["ctx"], v_s_3422, v_x_3423, v_y_3424, (v_sz_3426 if J.t(v_sz_3426) else 12.0), v_c_3425, "center"])

func _f569(this_, a: Array, env):
	var v_p_3450 = null; var v_i_3451 = null
	v_p_3450 = J.arg(a, 0)
	v_i_3451 = J.arg(a, 1)
	var _t3812 = env["ctx"]
	var _t3813 = (J.add("rgba(120,200,150,", 0.55) + ")")
	J.sp(_t3812, "fillStyle", _t3813)
	J.mc(env["ctx"], "beginPath", [])
	J.mc(env["ctx"], "ellipse", [J.gp(v_p_3450, "x"), J.gp(v_p_3450, "y"), 2.6, 1.5, 0.0, 0.0, 7.0])
	J.mc(env["ctx"], "fill", [])
	J.mc(env["ctx"], "beginPath", [])
	J.mc(env["ctx"], "ellipse", [J.add(J.gp(v_p_3450, "x"), 3.0), J.sub(J.gp(v_p_3450, "y"), 3.0), 1.0, 1.0, 0.0, 0.0, 7.0])
	J.mc(env["ctx"], "fill", [])

func _f568(this_, a: Array, env):
	var v_g_3431 = null; var v_S_3432 = null; var v_r_3433 = null; var v_un_3434 = null; var v_top_3435 = null; var v_flo_3436 = null; var v_k_3437 = null; var v_t_3438 = null; var v_o_3439 = null; var v_i_3440 = null; var v_bx_3441 = null; var v_by_3442 = null; var v_s_3443 = null; var v_e_3444 = null; var v_yb_3445 = null; var v_hx_3446 = null; var v_a_3447 = null
	v_g_3431 = J.arg(a, 0)
	v_S_3432 = J.gp(v_g_3431, "sc")
	var _t3802 = (not J.t(v_S_3432))
	var _t3803 = (_t3802 if _t3802 else J.gp(v_g_3431, "home"))
	if J.t((_t3803 if J.t(_t3803) else J.gp(v_g_3431, "out"))):
		return null
	v_r_3433 = J.gp(v_S_3432, "r")
	v_un_3434 = J.gp(v_S_3432, "un")
	var _t3804 = env["fy"]
	v_top_3435 = J.add(J.cl(_t3804, null, [J.add(J.gp(v_un_3434, "f"), 1.0)]), 10.0)
	var _t3805 = env["fy"]
	v_flo_3436 = J.cl(_t3805, null, [J.gp(v_un_3434, "f")])
	v_k_3437 = J.gp(v_S_3432, "k")
	v_t_3438 = J.gp(v_S_3432, "t")
	J.mc(env["ctx"], "save", [])
	J.mc(env["ctx"], "beginPath", [])
	J.mc(env["ctx"], "rect", [J.sub(J.gp(J.gp(v_un_3434, "rx"), 0.0), 40.0), v_top_3435, (J.sub(J.gp(J.gp(v_un_3434, "rx"), 1.0), J.gp(J.gp(v_un_3434, "rx"), 0.0)) + 80.0), (J.sub(v_flo_3436, v_top_3435) + 2.0)])
	J.mc(env["ctx"], "clip", [])
	if J.cmp(v_t_3438, env["OMEN"], "<"):
		v_o_3439 = J.div(v_t_3438, env["OMEN"])
		if J.seq(v_k_3437, "eking"):
			v_i_3440 = 0.0
			while true:
				if not J.cmp(v_i_3440, 3.0, "<"): break
				v_bx_3441 = J.sub(J.gp(v_r_3433, "x"), J.mul(J.gp(v_S_3432, "side"), (14.0 + J.mul(v_i_3440, 14.0))))
				v_by_3442 = (J.sub(J.gp(v_r_3433, "y"), 22.0) - J.mul((absf(J.num(sin(J.num((J.mul(J.gp(env["G"], "t"), 18.0) + J.mul(v_i_3440, 2.0)))))) * 7.0), v_o_3439))
				J.mc(env["ctx"], "save", [])
				J.mc(env["ctx"], "translate", [v_bx_3441, v_by_3442])
				J.mc(env["ctx"], "rotate", [J.mul((sin(J.num(J.add(J.mul(J.gp(env["G"], "t"), 22.0), v_i_3440))) * 0.35), v_o_3439)])
				var _t3806 = env["drawBowl"]
				J.cl(_t3806, null, [0.0, 0.0, 1.0])
				J.mc(env["ctx"], "restore", [])
				var _t3807 = env["ctx"]
				J.sp(_t3807, "strokeStyle", "#c8a050")
				var _t3808 = env["ctx"]
				J.sp(_t3808, "lineWidth", 1.5)
				J.mc(env["ctx"], "beginPath", [])
				J.mc(env["ctx"], "moveTo", [J.add(v_bx_3441, 6.0), (J.sub(v_by_3442, 8.0) - (sin(J.num(J.add(J.mul(J.gp(env["G"], "t"), 30.0), v_i_3440))) * 4.0))])
				J.mc(env["ctx"], "lineTo", [J.add(v_bx_3441, 14.0), J.sub(v_by_3442, 18.0)])
				J.mc(env["ctx"], "stroke", [])
				v_i_3440 = J.num(v_i_3440) + 1.0
			var _t3809 = env["txt"]
			J.cl(_t3809, null, [J.gp(J.gp(env["MV"], "eking"), "omen"), J.sub(J.gp(v_r_3433, "x"), J.mul(J.gp(v_S_3432, "side"), 28.0)), (J.sub(J.gp(v_r_3433, "y"), 72.0) - J.mul(v_o_3439, 6.0)), "#ffe9a0", 11.0])
		if J.seq(v_k_3437, "toyol"):
			var _t3810 = J.gp(v_S_3432, "prints")
			var _t3811 = (_t3810 if J.t(_t3810) else [])
			J.mc(_t3811, "forEach", [Callable(self, "_f569").bind(env)])
			var _t3814 = env["ctx"]
			J.sp(_t3814, "fillStyle", "#3a2a1e")
			J.mc(env["ctx"], "fillRect", [J.sub(J.gp(v_S_3432, "sx"), 26.0), J.sub(v_flo_3436, 18.0), 52.0, 10.0])
			var _t3815 = env["ctx"]
			J.sp(_t3815, "fillStyle", "#7a6a5a")
			J.mc(env["ctx"], "fillRect", [J.sub(J.gp(v_S_3432, "sx"), 28.0), J.sub(v_flo_3436, 24.0), 56.0, 7.0])
			var _t3816 = env["txt"]
			J.cl(_t3816, null, [J.gp(J.gp(env["MV"], "toyol"), "omen"), J.gp(v_S_3432, "sx"), (J.sub(v_flo_3436, 36.0) - (sin(J.num(J.mul(J.gp(env["G"], "t"), 9.0))) * 3.0)), "#b8f0a0", 11.0])
		if J.seq(v_k_3437, "tianhua"):
			var _t3817 = env["ctx"]
			var _t3818 = (J.add("rgba(60,90,110,", J.mul(0.55, v_o_3439)) + ")")
			J.sp(_t3817, "fillStyle", _t3818)
			J.mc(env["ctx"], "beginPath", [])
			J.mc(env["ctx"], "ellipse", [J.gp(v_r_3433, "x"), J.add(J.gp(v_S_3432, "ceil"), 2.0), (10.0 + J.mul(v_o_3439, 26.0)), (4.0 + J.mul(v_o_3439, 4.0)), 0.0, 0.0, 7.0])
			J.mc(env["ctx"], "fill", [])
			var _t3819 = env["txt"]
			J.cl(_t3819, null, [J.gp(J.gp(env["MV"], "tianhua"), "omen"), J.add(J.gp(v_r_3433, "x"), 22.0), J.add(J.gp(v_S_3432, "ceil"), 22.0), "#9fe0ff", 11.0])
	else:
		if J.cmp(v_t_3438, J.add(env["OMEN"], env["STRIKE"]), "<"):
			v_s_3443 = J.div(J.sub(v_t_3438, env["OMEN"]), env["STRIKE"])
			v_e_3444 = (J.div(v_s_3443, 0.35) if J.cmp(v_s_3443, 0.35, "<") else 1.0)
			if J.seq(v_k_3437, "eking"):
				var _t3820 = env["ctx"]
				J.sp(_t3820, "fillStyle", "#2a2e32")
				J.mc(env["ctx"], "fillRect", [J.sub(J.gp(v_S_3432, "sx"), 15.0), J.sub(v_flo_3436, 60.0), 30.0, 58.0])
				var _t3821 = env["ctx"]
				J.sp(_t3821, "strokeStyle", "#8a9aa0")
				var _t3822 = env["ctx"]
				J.sp(_t3822, "lineWidth", 1.5)
				J.mc(env["ctx"], "strokeRect", [J.sub(J.gp(v_S_3432, "sx"), 15.0), J.sub(v_flo_3436, 60.0), 30.0, 58.0])
				J.mc(env["ctx"], "beginPath", [])
				J.mc(env["ctx"], "moveTo", [J.sub(J.gp(v_S_3432, "sx"), 15.0), J.sub(v_flo_3436, 38.0)])
				J.mc(env["ctx"], "lineTo", [J.add(J.gp(v_S_3432, "sx"), 15.0), J.sub(v_flo_3436, 38.0)])
				J.mc(env["ctx"], "stroke", [])
				var _t3823 = env["ctx"]
				var _t3824 = (J.add("rgba(255,240,200,", J.mul(0.5, v_e_3444)) + ")")
				J.sp(_t3823, "fillStyle", _t3824)
				J.mc(env["ctx"], "fillRect", [J.sub(J.gp(v_S_3432, "sx"), 15.0), J.sub(v_flo_3436, 60.0), 4.0, 58.0])
				var _t3825 = env["drawMouth"]
				J.cl(_t3825, null, [J.add(J.gp(v_S_3432, "sx"), J.mul((J.sub(J.gp(v_r_3433, "x"), J.gp(v_S_3432, "sx")) * 0.45), v_e_3444)), J.sub(v_flo_3436, 40.0), (10.0 + J.mul(28.0, v_e_3444)), (0.35 + (0.65 * absf(J.num(sin(J.num((J.mul(v_s_3443, PI) * 3.0))))))), (1.0 if J.cmp(J.gp(v_r_3433, "x"), J.gp(v_S_3432, "sx"), ">") else (-1.0))])
			if J.seq(v_k_3437, "toyol"):
				var _t3826 = env["ctx"]
				J.sp(_t3826, "fillStyle", "#3a2a1e")
				J.mc(env["ctx"], "fillRect", [J.sub(J.gp(v_S_3432, "sx"), 26.0), J.sub(v_flo_3436, 18.0), 52.0, 10.0])
				var _t3827 = env["spr"]
				J.cl(_t3827, null, ["toyol", J.add(J.gp(v_S_3432, "sx"), J.mul((J.sub(J.gp(v_r_3433, "x"), J.gp(v_S_3432, "sx")) * 0.4), v_e_3444)), (J.sub(v_flo_3436, 6.0) + (18.0 * J.sub(1.0, v_e_3444))), 40.0, {"flip": J.cmp(J.gp(v_r_3433, "x"), J.gp(v_S_3432, "sx"), "<"), "rot": (((1.0 if J.cmp(J.gp(v_r_3433, "x"), J.gp(v_S_3432, "sx"), ">") else (-1.0)) * 0.3) * J.sub(1.0, v_e_3444))}])
				var _t3828 = env["ctx"]
				J.sp(_t3828, "fillStyle", "#7a6a5a")
				J.mc(env["ctx"], "fillRect", [J.sub(J.gp(v_S_3432, "sx"), 28.0), J.sub(v_flo_3436, 24.0), 56.0, 7.0])
				if J.cmp(v_s_3443, 0.3, ">"):
					var _t3829 = env["txt"]
					J.cl(_t3829, null, ["搶咗！", J.gp(v_S_3432, "sx"), J.sub(v_flo_3436, 62.0), "#ffd54a", 13.0])
			if J.seq(v_k_3437, "tianhua"):
				v_yb_3445 = J.add(J.add(J.gp(v_S_3432, "ceil"), 8.0), J.mul((J.sub(J.sub(J.gp(v_r_3433, "y"), 30.0), J.gp(v_S_3432, "ceil")) - 8.0), v_e_3444))
				v_hx_3446 = J.add(J.gp(v_r_3433, "x"), ((-14.0) if J.cmp(J.gp(v_r_3433, "x"), J.gp(v_g_3431, "x"), ">") else 14.0))
				var _t3830 = env["ctx"]
				J.sp(_t3830, "strokeStyle", "rgba(14,14,18,0.9)")
				var _t3831 = env["ctx"]
				J.sp(_t3831, "lineWidth", 1.6)
				v_i_3440 = 0.0
				while true:
					if not J.cmp(v_i_3440, 10.0, "<"): break
					J.mc(env["ctx"], "beginPath", [])
					J.mc(env["ctx"], "moveTo", [(J.sub(v_hx_3446, 12.0) + J.mul(v_i_3440, 2.6)), J.gp(v_S_3432, "ceil")])
					J.mc(env["ctx"], "quadraticCurveTo", [((J.sub(v_hx_3446, 12.0) + J.mul(v_i_3440, 2.6)) + (sin(J.num(J.add(J.mul(J.gp(env["G"], "t"), 6.0), v_i_3440))) * 3.0)), J.div(J.add(J.gp(v_S_3432, "ceil"), v_yb_3445), 2.0), (J.sub(v_hx_3446, 14.0) + J.mul(v_i_3440, 3.0)), J.sub(v_yb_3445, 20.0)])
					J.mc(env["ctx"], "stroke", [])
					v_i_3440 = J.num(v_i_3440) + 1.0
				var _t3832 = env["spr"]
				J.cl(_t3832, null, ["tianhua_hang", v_hx_3446, v_yb_3445, 74.0, {"flip": J.cmp(J.gp(v_r_3433, "x"), J.gp(v_g_3431, "x"), "<"), "rot": (sin(J.num(J.mul(J.gp(env["G"], "t"), 4.0))) * 0.05)}])
				v_i_3440 = 0.0
				while true:
					if not J.cmp(v_i_3440, 3.0, "<"): break
					var _t3833 = env["ctx"]
					J.sp(_t3833, "fillStyle", "#9fe0ff")
					J.mc(env["ctx"], "beginPath", [])
					J.mc(env["ctx"], "arc", [(J.sub(v_hx_3446, 8.0) + J.mul(v_i_3440, 8.0)), J.add(J.add(v_yb_3445, 4.0), J.mod((J.mul(J.gp(env["G"], "t"), 60.0) + J.mul(v_i_3440, 9.0)), 22.0)), 1.8, 0.0, 7.0])
					J.mc(env["ctx"], "fill", [])
					v_i_3440 = J.num(v_i_3440) + 1.0
		else:
			v_a_3447 = (1.0 - J.div(J.sub(J.sub(v_t_3438, env["OMEN"]), env["STRIKE"]), env["AFTER"]))
			if J.seq(v_k_3437, "eking"):
				var _t3834 = env["ctx"]
				J.sp(_t3834, "globalAlpha", v_a_3447)
				var _t3835 = env["ctx"]
				J.sp(_t3835, "fillStyle", "#2a2e32")
				J.mc(env["ctx"], "fillRect", [J.sub(J.gp(v_S_3432, "sx"), 15.0), J.sub(v_flo_3436, 60.0), 30.0, 58.0])
				var _t3836 = env["ctx"]
				J.sp(_t3836, "globalAlpha", 1.0)
			if J.seq(v_k_3437, "toyol"):
				var _t3837 = env["ctx"]
				J.sp(_t3837, "globalAlpha", v_a_3447)
				var _t3838 = env["ctx"]
				J.sp(_t3838, "fillStyle", "#3a2a1e")
				J.mc(env["ctx"], "fillRect", [J.sub(J.gp(v_S_3432, "sx"), 26.0), J.sub(v_flo_3436, 18.0), 52.0, 10.0])
				var _t3839 = env["ctx"]
				J.sp(_t3839, "globalAlpha", 1.0)
	J.mc(env["ctx"], "restore", [])

func _f567(this_, a: Array, env):
	var _t3801 = J.gp(env["G"], "gh")
	J.mc(_t3801, "forEach", [Callable(self, "_f568").bind(env)])

func _f571(this_, a: Array, env):
	var v_T_3456 = null; var v_a_3457 = null; var v_i_3458 = null; var v_px_3459 = null; var v_py_3460 = null; var v_r_3461 = null; var v_top_3462 = null; var v_hx_3463 = null
	v_T_3456 = J.arg(a, 0)
	v_a_3457 = J.min_([1.0, J.div(J.gp(v_T_3456, "life"), 2.0)])
	var _t3841 = env["ctx"]
	J.sp(_t3841, "globalAlpha", v_a_3457)
	if J.seq(J.gp(v_T_3456, "k"), "food"):
		v_i_3458 = 0.0
		while true:
			if not J.cmp(v_i_3458, 9.0, "<"): break
			v_px_3459 = (J.sub(J.gp(v_T_3456, "x"), 26.0) + J.mod(J.mul(v_i_3458, 37.0), 52.0))
			v_py_3460 = (J.sub(J.gp(v_T_3456, "y"), 3.0) - J.mod(v_i_3458, 3.0))
			var _t3842 = env["ctx"]
			var _t3843 = ("#e8d8a0" if J.t(J.mod(v_i_3458, 3.0)) else "#c8784a")
			J.sp(_t3842, "fillStyle", _t3843)
			J.mc(env["ctx"], "beginPath", [])
			J.mc(env["ctx"], "ellipse", [v_px_3459, v_py_3460, (3.0 + (J.mod(v_i_3458, 2.0) * 2.0)), 1.6, 0.0, 0.0, 7.0])
			J.mc(env["ctx"], "fill", [])
			v_i_3458 = J.num(v_i_3458) + 1.0
		J.mc(env["ctx"], "save", [])
		J.mc(env["ctx"], "translate", [J.add(J.gp(v_T_3456, "x"), 10.0), J.sub(J.gp(v_T_3456, "y"), 6.0)])
		J.mc(env["ctx"], "rotate", [1.3])
		var _t3844 = env["drawBowl"]
		J.cl(_t3844, null, [0.0, 0.0, 0.0])
		J.mc(env["ctx"], "restore", [])
		J.mc(env["ctx"], "save", [])
		J.mc(env["ctx"], "translate", [J.sub(J.gp(v_T_3456, "x"), 18.0), J.sub(J.gp(v_T_3456, "y"), 5.0)])
		J.mc(env["ctx"], "rotate", [(-2.2)])
		var _t3845 = env["drawBowl"]
		J.cl(_t3845, null, [0.0, 0.0, 0.0])
		J.mc(env["ctx"], "restore", [])
		var _t3846 = env["ctx"]
		J.sp(_t3846, "strokeStyle", "#c8a050")
		var _t3847 = env["ctx"]
		J.sp(_t3847, "lineWidth", 1.4)
		J.mc(env["ctx"], "beginPath", [])
		J.mc(env["ctx"], "moveTo", [J.sub(J.gp(v_T_3456, "x"), 4.0), J.sub(J.gp(v_T_3456, "y"), 2.0)])
		J.mc(env["ctx"], "lineTo", [J.add(J.gp(v_T_3456, "x"), 14.0), J.sub(J.gp(v_T_3456, "y"), 5.0)])
		J.mc(env["ctx"], "moveTo", [J.sub(J.gp(v_T_3456, "x"), 2.0), J.sub(J.gp(v_T_3456, "y"), 1.0)])
		J.mc(env["ctx"], "lineTo", [J.add(J.gp(v_T_3456, "x"), 12.0), J.add(J.gp(v_T_3456, "y"), 1.0)])
		J.mc(env["ctx"], "stroke", [])
		v_r_3461 = J.gp(J.gp(v_T_3456, "un"), "res")
		if J.t((J.cmp(J.gp(v_r_3461, "tidy"), 0.0, ">") if J.t(v_r_3461) else v_r_3461)):
			var _t3848 = env["txt"]
			J.cl(_t3848, null, ["執緊……", J.gp(v_r_3461, "x"), J.sub(J.gp(v_r_3461, "y"), 80.0), "#e8d8b0", 11.0])
	if J.seq(J.gp(v_T_3456, "k"), "mess"):
		v_i_3458 = 0.0
		while true:
			if not J.cmp(v_i_3458, 10.0, "<"): break
			v_px_3459 = (J.sub(J.gp(v_T_3456, "x"), 34.0) + J.mod(J.mul(v_i_3458, 29.0), 68.0))
			v_py_3460 = (J.sub(J.gp(v_T_3456, "y"), 3.0) - (J.mod(v_i_3458, 2.0) * 2.0))
			J.mc(env["ctx"], "save", [])
			J.mc(env["ctx"], "translate", [v_px_3459, v_py_3460])
			J.mc(env["ctx"], "rotate", [J.mul(v_i_3458, 0.7)])
			var _t3849 = env["ctx"]
			var _t3850 = ("#e8e2d0" if J.t(J.mod(v_i_3458, 2.0)) else "#9cc89c")
			J.sp(_t3849, "fillStyle", _t3850)
			J.mc(env["ctx"], "fillRect", [(-4.0), (-2.5), 8.0, 5.0])
			J.mc(env["ctx"], "restore", [])
			v_i_3458 = J.num(v_i_3458) + 1.0
		var _t3851 = env["ctx"]
		J.sp(_t3851, "fillStyle", "#4a3424")
		J.mc(env["ctx"], "save", [])
		J.mc(env["ctx"], "translate", [J.add(J.gp(v_T_3456, "x"), 24.0), J.sub(J.gp(v_T_3456, "y"), 8.0)])
		J.mc(env["ctx"], "rotate", [0.5])
		J.mc(env["ctx"], "fillRect", [(-10.0), (-5.0), 20.0, 10.0])
		J.mc(env["ctx"], "restore", [])
		if J.cmp(J.gp(v_T_3456, "t"), 4.0, "<"):
			var _t3852 = env["txt"]
			J.cl(_t3852, null, ["乒乒乓乓", J.gp(v_T_3456, "x"), (J.sub(J.gp(v_T_3456, "y"), 84.0) - (sin(J.num(J.mul(J.gp(env["G"], "t"), 14.0))) * 2.0)), "#ffb0b0", 11.0])
	if J.seq(J.gp(v_T_3456, "k"), "hair"):
		var _t3853 = env["fy"]
		v_top_3462 = J.add(J.cl(_t3853, null, [J.add(J.gp(v_T_3456, "f"), 1.0)]), 16.0)
		var _t3854 = env["ctx"]
		var _t3855 = ("rgba(30,30,36,0.5)" if J.t(J.gp(v_T_3456, "used")) else "rgba(20,22,28,0.92)")
		J.sp(_t3854, "strokeStyle", _t3855)
		var _t3856 = env["ctx"]
		J.sp(_t3856, "lineWidth", 1.4)
		v_i_3458 = 0.0
		while true:
			if not J.cmp(v_i_3458, 8.0, "<"): break
			v_hx_3463 = ((J.sub(J.gp(v_T_3456, "x"), 14.0) + J.mul(v_i_3458, 1.6)) + (24.0 if J.cmp(v_i_3458, 3.0, ">") else 0.0))
			J.mc(env["ctx"], "beginPath", [])
			J.mc(env["ctx"], "moveTo", [v_hx_3463, J.add(v_top_3462, 4.0)])
			J.mc(env["ctx"], "quadraticCurveTo", [J.add(v_hx_3463, (sin(J.num(J.add(J.mul(J.gp(env["G"], "t"), 2.0), v_i_3458))) * 4.0)), J.add(v_top_3462, 30.0), J.add(v_hx_3463, (sin(J.num(J.add(J.mul(J.gp(env["G"], "t"), 1.5), v_i_3458))) * 3.0)), J.add(J.add(v_top_3462, 44.0), (J.mod(v_i_3458, 3.0) * 8.0))])
			J.mc(env["ctx"], "stroke", [])
			v_i_3458 = J.num(v_i_3458) + 1.0
		if (not J.t(J.gp(v_T_3456, "used"))):
			var _t3857 = env["ctx"]
			J.sp(_t3857, "fillStyle", "rgba(159,224,255,0.7)")
			J.mc(env["ctx"], "beginPath", [])
			J.mc(env["ctx"], "arc", [J.sub(J.gp(v_T_3456, "x"), 10.0), J.add(J.add(v_top_3462, 50.0), J.mod(J.mul(J.gp(env["G"], "t"), 40.0), 24.0)), 1.6, 0.0, 7.0])
			J.mc(env["ctx"], "fill", [])
	var _t3858 = env["ctx"]
	J.sp(_t3858, "globalAlpha", 1.0)

func _f572(this_, a: Array, env):
	var v_u_3466 = null; var v_cx_3467 = null; var v_y_3468 = null; var v_i_3469 = null
	v_u_3466 = J.arg(a, 0)
	var _t3860 = (not J.t(J.gp(v_u_3466, "beans")))
	if (_t3860 if _t3860 else (not J.t(J.gp(v_u_3466, "open")))):
		return null
	v_cx_3467 = (J.div(J.add(J.gp(J.gp(v_u_3466, "rx"), 0.0), J.gp(J.gp(v_u_3466, "rx"), 1.0)), 2.0) + 18.0)
	v_y_3468 = J.sub(J.gp(v_u_3466, "y"), 3.0)
	v_i_3469 = 0.0
	while true:
		if not J.cmp(v_i_3469, 16.0, "<"): break
		var _t3861 = env["ctx"]
		var _t3862 = ("#5a7a3a" if J.t(J.gp(v_u_3466, "beansDone")) else "#7ac04a")
		J.sp(_t3861, "fillStyle", _t3862)
		J.mc(env["ctx"], "beginPath", [])
		J.mc(env["ctx"], "arc", [(J.sub(v_cx_3467, 16.0) + J.mod(J.mul(v_i_3469, 13.0), 32.0)), J.sub(v_y_3468, (J.mod(v_i_3469, 3.0) * 1.4)), 1.7, 0.0, 7.0])
		J.mc(env["ctx"], "fill", [])
		v_i_3469 = J.num(v_i_3469) + 1.0
	var _t3863 = env["ctx"]
	J.sp(_t3863, "fillStyle", "#d24a3a")
	J.mc(env["ctx"], "beginPath", [])
	J.mc(env["ctx"], "arc", [J.add(v_cx_3467, 20.0), J.sub(v_y_3468, 4.0), 4.0, 0.0, 7.0])
	J.mc(env["ctx"], "fill", [])
	var _t3864 = env["ctx"]
	J.sp(_t3864, "fillStyle", "#ffd54a")
	J.mc(env["ctx"], "fillRect", [J.add(v_cx_3467, 24.0), J.sub(v_y_3468, 8.0), 6.0, 6.0])
	if J.t(J.gp(v_u_3466, "seen")):
		var _t3865 = env["txt"]
		J.cl(_t3865, null, [("綠豆（數過）" if J.t(J.gp(v_u_3466, "beansDone")) else "綠豆・玩具"), v_cx_3467, J.sub(v_y_3468, 14.0), "#b8f0a0", 10.0])

func _f570(this_, a: Array, env):
	var _t3840 = J.gp(env["G"], "traces")
	J.mc(_t3840, "forEach", [Callable(self, "_f571").bind(env)])
	var _t3859 = J.gp(env["G"], "units")
	J.mc(_t3859, "forEach", [Callable(self, "_f572").bind(env)])

func _f573(this_, a: Array, env):
	var v_r_3472 = null; var v_P_3473 = null; var v_R_3474 = null; var v_q_3475 = null
	v_r_3472 = J.arg(a, 0)
	v_P_3473 = J.arg(a, 1)
	v_R_3474 = J.gp(v_r_3472, "react")
	var _t3866 = (not J.t(v_R_3474))
	if (_t3866 if _t3866 else (not J.seq(J.gp(v_r_3472, "state"), "home"))):
		return null
	v_q_3475 = (1.0 - J.div(J.gp(v_R_3474, "t"), 1.7))
	if J.seq(J.gp(v_R_3474, "k"), "scream"):
		var _t3867 = (sin(J.num(J.mul(J.gp(env["G"], "t"), 50.0))) * 2.4)
		J.sp(v_P_3473, "sh", _t3867)
		var _t3868 = ((-absf(J.num(sin(J.num((J.mul(v_q_3475, PI) * 2.0)))))) * 8.0)
		J.sp(v_P_3473, "jy", _t3868)
	if J.seq(J.gp(v_R_3474, "k"), "kneel"):
		J.sp(v_P_3473, "sy", 0.66)
		J.sp(v_P_3473, "jy", 2.0)
		var _t3869 = (sin(J.num(J.mul(J.gp(env["G"], "t"), 6.0))) * 0.05)
		J.sp(v_P_3473, "ro", _t3869)
	if J.seq(J.gp(v_R_3474, "k"), "cover"):
		J.sp(v_P_3473, "sy", 0.86)
		var _t3870 = (sin(J.num(J.mul(J.gp(env["G"], "t"), 30.0))) * 1.4)
		J.sp(v_P_3473, "sh", _t3870)
		J.sp(v_P_3473, "hands", true)
	if J.seq(J.gp(v_R_3474, "k"), "fall"):
		var _t3871 = (((-1.0) if J.cmp(J.gp(v_r_3472, "x"), J.div(env["WW"], 2.0), "<") else 1.0) * J.min_([1.35, J.mul(v_q_3475, 5.0)]))
		J.sp(v_P_3473, "ro", _t3871)
		var _t3872 = (J.min_([1.0, J.mul(v_q_3475, 5.0)]) * 10.0)
		J.sp(v_P_3473, "jy", _t3872)
	if J.seq(J.gp(v_R_3474, "k"), "phone"):
		J.sp(v_P_3473, "phone", true)
		var _t3873 = (sin(J.num(J.mul(J.gp(env["G"], "t"), 20.0))) * 1.0)
		J.sp(v_P_3473, "sh", _t3873)
	if J.seq(J.gp(v_R_3474, "k"), "slipper"):
		J.sp(v_P_3473, "slip", true)
		var _t3874 = (sin(J.num(J.mul(J.gp(env["G"], "t"), 16.0))) * 0.12)
		J.sp(v_P_3473, "ro", _t3874)
	if J.seq(J.gp(v_R_3474, "k"), "push"):
		var _t3875 = J.gp(v_r_3472, "pushTo")
		var _t3876 = (J.mul((_t3875 if J.t(_t3875) else 1.0), 0.3) * absf(J.num(sin(J.num(J.mul(J.gp(env["G"], "t"), 10.0))))))
		J.sp(v_P_3473, "ro", _t3876)
		var _t3877 = J.gp(v_r_3472, "pushTo")
		var _t3878 = (J.mul((_t3877 if J.t(_t3877) else 1.0), absf(J.num(sin(J.num(J.mul(J.gp(env["G"], "t"), 10.0)))))) * 8.0)
		J.sp(v_P_3473, "sh", _t3878)
	if J.cmp(J.gp(v_r_3472, "tidy"), 0.0, ">"):
		J.sp(v_P_3473, "sy", 0.78)
		J.sp(v_P_3473, "ro", 0.25)

func _f574(this_, a: Array, env):
	var v_r_3478 = null; var v_P_3479 = null; var v_R_3480 = null; var v_i_3481 = null; var v_a_3482 = null; var v_an_3483 = null; var v_an2_3484 = null
	v_r_3478 = J.arg(a, 0)
	v_P_3479 = J.arg(a, 1)
	v_R_3480 = J.gp(v_r_3478, "react")
	var _t3879 = (not J.t(v_R_3480))
	if (_t3879 if _t3879 else (not J.seq(J.gp(v_r_3478, "state"), "home"))):
		return null
	if J.t(J.gp(v_P_3479, "hands")):
		var _t3880 = env["ctx"]
		J.sp(_t3880, "fillStyle", "#e8c0a0")
		J.mc(env["ctx"], "beginPath", [])
		J.mc(env["ctx"], "arc", [J.sub(J.gp(v_r_3478, "x"), 8.0), J.sub(J.gp(v_r_3478, "y"), 46.0), 5.0, 0.0, 7.0])
		J.mc(env["ctx"], "arc", [J.add(J.gp(v_r_3478, "x"), 8.0), J.sub(J.gp(v_r_3478, "y"), 46.0), 5.0, 0.0, 7.0])
		J.mc(env["ctx"], "fill", [])
	if J.t(J.gp(v_P_3479, "phone")):
		var _t3881 = env["ctx"]
		J.sp(_t3881, "fillStyle", "#202428")
		J.mc(env["ctx"], "fillRect", [J.add(J.gp(v_r_3478, "x"), 9.0), J.sub(J.gp(v_r_3478, "y"), 50.0), 6.0, 11.0])
		var _t3882 = env["ctx"]
		J.sp(_t3882, "fillStyle", "#9fe0ff")
		J.mc(env["ctx"], "fillRect", [J.add(J.gp(v_r_3478, "x"), 10.0), J.sub(J.gp(v_r_3478, "y"), 49.0), 4.0, 7.0])
		v_i_3481 = 0.0
		while true:
			if not J.cmp(v_i_3481, 2.0, "<"): break
			var _t3883 = env["ctx"]
			var _t3884 = (J.add("rgba(159,224,255,", (0.8 - J.mul(v_i_3481, 0.3))) + ")")
			J.sp(_t3883, "strokeStyle", _t3884)
			var _t3885 = env["ctx"]
			J.sp(_t3885, "lineWidth", 1.5)
			J.mc(env["ctx"], "beginPath", [])
			J.mc(env["ctx"], "arc", [J.add(J.gp(v_r_3478, "x"), 12.0), J.sub(J.gp(v_r_3478, "y"), 45.0), ((9.0 + J.mul(v_i_3481, 6.0)) + J.mod(J.mul(J.gp(env["G"], "t"), 20.0), 5.0)), (-0.8), 0.8])
			J.mc(env["ctx"], "stroke", [])
			v_i_3481 = J.num(v_i_3481) + 1.0
	if J.t(J.gp(v_P_3479, "slip")):
		v_a_3482 = (sin(J.num(J.mul(J.gp(env["G"], "t"), 16.0))) * 1.2)
		J.mc(env["ctx"], "save", [])
		J.mc(env["ctx"], "translate", [J.gp(v_r_3478, "x"), J.sub(J.gp(v_r_3478, "y"), 42.0)])
		J.mc(env["ctx"], "rotate", [v_a_3482])
		var _t3886 = env["ctx"]
		J.sp(_t3886, "fillStyle", "#3a6ad0")
		J.mc(env["ctx"], "fillRect", [14.0, (-4.0), 16.0, 7.0])
		J.mc(env["ctx"], "restore", [])
		var _t3887 = env["ctx"]
		J.sp(_t3887, "strokeStyle", "rgba(255,255,255,0.5)")
		var _t3888 = env["ctx"]
		J.sp(_t3888, "lineWidth", 2.0)
		J.mc(env["ctx"], "beginPath", [])
		J.mc(env["ctx"], "arc", [J.gp(v_r_3478, "x"), J.sub(J.gp(v_r_3478, "y"), 42.0), 26.0, (-1.2), 1.2])
		J.mc(env["ctx"], "stroke", [])
	if J.seq(J.gp(v_R_3480, "k"), "scream"):
		var _t3889 = env["ctx"]
		J.sp(_t3889, "strokeStyle", "rgba(255,255,255,0.75)")
		var _t3890 = env["ctx"]
		J.sp(_t3890, "lineWidth", 2.0)
		v_i_3481 = 0.0
		while true:
			if not J.cmp(v_i_3481, 3.0, "<"): break
			v_an_3483 = ((-2.2) + J.mul(v_i_3481, 0.6))
			J.mc(env["ctx"], "beginPath", [])
			J.mc(env["ctx"], "moveTo", [J.add(J.gp(v_r_3478, "x"), (cos(J.num(v_an_3483)) * 24.0)), (J.sub(J.gp(v_r_3478, "y"), 46.0) + (sin(J.num(v_an_3483)) * 24.0))])
			J.mc(env["ctx"], "lineTo", [J.add(J.gp(v_r_3478, "x"), (cos(J.num(v_an_3483)) * 34.0)), (J.sub(J.gp(v_r_3478, "y"), 46.0) + (sin(J.num(v_an_3483)) * 34.0))])
			J.mc(env["ctx"], "stroke", [])
			v_an2_3484 = ((-0.95) + J.mul(v_i_3481, 0.6))
			J.mc(env["ctx"], "beginPath", [])
			J.mc(env["ctx"], "moveTo", [J.add(J.gp(v_r_3478, "x"), (cos(J.num(v_an2_3484)) * 24.0)), (J.sub(J.gp(v_r_3478, "y"), 46.0) + (sin(J.num(v_an2_3484)) * 24.0))])
			J.mc(env["ctx"], "lineTo", [J.add(J.gp(v_r_3478, "x"), (cos(J.num(v_an2_3484)) * 34.0)), (J.sub(J.gp(v_r_3478, "y"), 46.0) + (sin(J.num(v_an2_3484)) * 34.0))])
			J.mc(env["ctx"], "stroke", [])
			v_i_3481 = J.num(v_i_3481) + 1.0

func _f575(this_, a: Array, env):
	var v_o_3487 = null; var v_by_3488 = null; var v_n_3489 = null; var v_k_3490 = null; var v_d_3491 = null; var v_p_3492 = null; var v_bx_3493 = null; var v_byy_3494 = null; var v_mx_3495 = null; var v_my_3496 = null; var v_q_3497 = null; var v_qx_3498 = null; var v_qy_3499 = null; var v_dx_3500 = null; var v_dy_3501 = null; var v_out_3502 = null; var v_cy_3503 = null
	v_o_3487 = J.arg(a, 0)
	v_by_3488 = J.arg(a, 1)
	if (not J.cmp(J.gp(v_o_3487, "taskP"), 0.0, ">")):
		return null
	v_n_3489 = J.gp(J.gp(env["G"], "nodes"), J.gp(v_o_3487, "node"))
	if (not J.seq(J.gp(v_n_3489, "kind"), "in")):
		return null
	v_k_3490 = J.gp(J.gp(v_o_3487, "d"), "key")
	v_d_3491 = J.gp(v_o_3487, "dir")
	v_p_3492 = J.gp(v_o_3487, "taskP")
	if J.seq(v_k_3490, "eking"):
		v_bx_3493 = J.add(J.gp(v_o_3487, "x"), J.mul(v_d_3491, 36.0))
		v_byy_3494 = J.sub(J.gp(v_o_3487, "y"), 14.0)
		var _t3891 = env["drawBowl"]
		J.cl(_t3891, null, [v_bx_3493, v_byy_3494, J.sub(1.0, v_p_3492)])
		v_mx_3495 = J.add(J.gp(v_o_3487, "x"), J.mul(v_d_3491, 6.0))
		v_my_3496 = J.sub(v_by_3488, J.mul(J.gp(J.gp(v_o_3487, "d"), "h"), 0.6))
		var _t3892 = env["ctx"]
		J.sp(_t3892, "strokeStyle", "#5a3a2c")
		var _t3893 = env["ctx"]
		J.sp(_t3893, "lineWidth", 3.2)
		J.mc(env["ctx"], "beginPath", [])
		J.mc(env["ctx"], "moveTo", [v_mx_3495, v_my_3496])
		J.mc(env["ctx"], "quadraticCurveTo", [J.add(J.gp(v_o_3487, "x"), J.mul(v_d_3491, 30.0)), (J.sub(v_my_3496, 16.0) + (sin(J.num(J.mul(J.gp(env["G"], "t"), 6.0))) * 3.0)), v_bx_3493, J.sub(v_byy_3494, 6.0)])
		J.mc(env["ctx"], "stroke", [])
		var _t3894 = env["ctx"]
		J.sp(_t3894, "strokeStyle", "#8a5a44")
		var _t3895 = env["ctx"]
		J.sp(_t3895, "lineWidth", 1.4)
		J.mc(env["ctx"], "stroke", [])
		v_q_3497 = J.mod(J.mul(J.gp(env["G"], "t"), 2.2), 1.0)
		v_qx_3498 = J.add(v_bx_3493, J.mul(J.sub(v_mx_3495, v_bx_3493), v_q_3497))
		v_qy_3499 = ((J.sub(v_byy_3494, 6.0) + J.mul((J.sub(v_my_3496, v_byy_3494) + 6.0), v_q_3497)) - (sin(J.num(J.mul(v_q_3497, PI))) * 14.0))
		var _t3896 = env["ctx"]
		J.sp(_t3896, "fillStyle", "#f0e6c8")
		J.mc(env["ctx"], "beginPath", [])
		J.mc(env["ctx"], "arc", [v_qx_3498, v_qy_3499, 3.2, 0.0, 7.0])
		J.mc(env["ctx"], "fill", [])
	if J.seq(v_k_3490, "toyol"):
		v_dx_3500 = J.add(J.gp(v_o_3487, "x"), J.mul(v_d_3491, 30.0))
		v_dy_3501 = J.sub(J.gp(v_o_3487, "y"), 34.0)
		v_out_3502 = (6.0 + (absf(J.num(sin(J.num(J.mul(J.gp(env["G"], "t"), 7.0))))) * 8.0))
		var _t3897 = env["ctx"]
		J.sp(_t3897, "fillStyle", "#4a3424")
		J.mc(env["ctx"], "fillRect", [J.sub(v_dx_3500, 16.0), J.sub(v_dy_3501, 10.0), 32.0, 26.0])
		var _t3898 = env["ctx"]
		J.sp(_t3898, "fillStyle", "#6a4a30")
		J.mc(env["ctx"], "fillRect", [(J.sub(v_dx_3500, 14.0) + J.mul(v_d_3491, v_out_3502)), J.sub(v_dy_3501, 6.0), 28.0, 10.0])
		var _t3899 = env["ctx"]
		J.sp(_t3899, "fillStyle", "#c8a050")
		J.mc(env["ctx"], "fillRect", [(J.sub(v_dx_3500, 2.0) + J.mul(v_d_3491, v_out_3502)), J.sub(v_dy_3501, 2.0), 4.0, 2.0])
	if J.seq(v_k_3490, "tianhua"):
		v_mx_3495 = J.add(J.gp(v_o_3487, "x"), J.mul(v_d_3491, 34.0))
		v_my_3496 = J.sub(J.gp(v_o_3487, "y"), 62.0)
		var _t3900 = env["ctx"]
		J.sp(_t3900, "fillStyle", "#c8a050")
		J.mc(env["ctx"], "fillRect", [J.sub(v_mx_3495, 13.0), J.sub(v_my_3496, 20.0), 26.0, 40.0])
		var _t3901 = env["ctx"]
		J.sp(_t3901, "fillStyle", "#1a2a30")
		J.mc(env["ctx"], "fillRect", [J.sub(v_mx_3495, 10.0), J.sub(v_my_3496, 17.0), 20.0, 34.0])
		J.mc(env["ctx"], "save", [])
		J.mc(env["ctx"], "beginPath", [])
		J.mc(env["ctx"], "rect", [J.sub(v_mx_3495, 10.0), J.sub(v_my_3496, 17.0), 20.0, 34.0])
		J.mc(env["ctx"], "clip", [])
		var _t3902 = env["spr"]
		J.cl(_t3902, null, ["tianhua", v_mx_3495, J.add(v_my_3496, 20.0), 40.0, {"flip": J.cmp(v_d_3491, 0.0, ">"), "alpha": J.min_([0.9, J.mul(v_p_3492, 2.6)])}])
		J.mc(env["ctx"], "restore", [])
		var _t3903 = env["ctx"]
		J.sp(_t3903, "fillStyle", "rgba(220,245,255,0.25)")
		J.mc(env["ctx"], "fillRect", [J.sub(v_mx_3495, 10.0), J.sub(v_my_3496, 17.0), 5.0, 34.0])
		v_cy_3503 = (J.sub(v_by_3488, J.mul(J.gp(J.gp(v_o_3487, "d"), "h"), 0.8)) + J.mod(J.mul(J.gp(env["G"], "t"), 40.0), J.mul(J.gp(J.gp(v_o_3487, "d"), "h"), 0.5)))
		var _t3904 = env["ctx"]
		J.sp(_t3904, "fillStyle", "#d8b878")
		J.mc(env["ctx"], "fillRect", [(J.sub(J.gp(v_o_3487, "x"), J.mul(v_d_3491, 10.0)) - 5.0), v_cy_3503, 10.0, 3.0])

func _f577(this_, a: Array, env):
	var v_c_3533 = null
	v_c_3533 = J.arg(a, 0)
	var _t3906 = J.add(env["W"], J.gp(v_c_3533, 1.0))
	env["W"] = _t3906

func _f578(this_, a: Array, env):
	var v_c_3536 = null
	v_c_3536 = J.arg(a, 0)
	J.mc(env["xs"], "push", [[env["x"], J.add(env["x"], J.gp(v_c_3536, 1.0)), J.gp(v_c_3536, 0.0)]])
	var _t3908 = J.add(env["x"], J.gp(v_c_3536, 1.0))
	env["x"] = _t3908

func _f580(this_, a: Array, env):
	var v_q_3543 = null
	v_q_3543 = J.arg(a, 0)
	return J.seq(J.gp(v_q_3543, 2.0), env["kind"])

func _f579(this_, a: Array, env):
	var v_c_3540 = null
	var _s1410 = {"__p": env, "kind": null}
	_s1410["kind"] = J.arg(a, 0)
	v_c_3540 = J.mc(_s1410["__p"]["xs"], "find", [Callable(self, "_f580").bind(_s1410)])
	return (J.div(J.add(J.gp(v_c_3540, 0.0), J.gp(v_c_3540, 1.0)), 2.0) if J.t(v_c_3540) else null)

func _f581(this_, a: Array, env):
	var v_q_3546 = null
	v_q_3546 = J.arg(a, 0)
	return J.seq(J.gp(v_q_3546, 2.0), "u")

func _f582(this_, a: Array, env):
	var v___3549 = null; var v_i_3550 = null
	v___3549 = J.arg(a, 0)
	v_i_3550 = J.arg(a, 1)
	return v_i_3550

func _f583(this_, a: Array, env):
	var v_c_3553 = null; var v_u_3554 = null; var v_w_3555 = null; var v_deity_3556 = null; var v_nm_3557 = null; var v_hh_3558 = null; var v_task_3559 = null; var v_doorX_3560 = null
	v_c_3553 = J.arg(a, 0)
	v_u_3554 = J.arg(a, 1)
	var _t3928 = J.gp(env["wardsF"], v_u_3554)
	v_w_3555 = (_t3928 if J.t(_t3928) else null)
	var _t3929 = J.seq(v_w_3555, "fu")
	var _t3930 = (_t3929 if _t3929 else J.seq(v_w_3555, "menshen"))
	v_deity_3556 = (_t3930 if _t3930 else J.seq(v_w_3555, "datuk"))
	v_hh_3558 = null
	v_task_3559 = null
	if J.seq(env["f"], 0.0):
		var _t3931 = J.gp(J.gp(env["B"], "base"), J.mod(v_u_3554, J.len(J.gp(env["B"], "base"))))
		v_nm_3557 = _t3931
		v_hh_3558 = null
	else:
		if J.seq(env["f"], 1.0):
			var _t3932 = J.gp(J.gp(env["B"], "ground"), J.mod(v_u_3554, J.len(J.gp(env["B"], "ground"))))
			v_nm_3557 = _t3932
			var _t3933 = J.seq(v_u_3554, 0.0)
			var _t3936 = null
			if J.t((_t3933 if _t3933 else v_deity_3556)):
				_t3936 = null
			else:
				var _t3935 = null
				if J.cmp(J.cl(env["R"], null, []), 0.5, "<"):
					var _t3934 = env["__p"]["pick"]
					_t3935 = J.cl(_t3934, null, [["insomnia", "cook", "gamer"]])
				else:
					_t3935 = null
				_t3936 = _t3935
			v_hh_3558 = _t3936
		else:
			var _t3939 = null
			if J.t(v_deity_3556):
				_t3939 = null
			else:
				var _t3938 = null
				if J.cmp(J.cl(env["R"], null, []), 0.96, "<"):
					var _t3937 = env["__p"]["wpick"]
					_t3938 = J.cl(_t3937, null, [env["__p"]["HHW"]])
				else:
					_t3938 = null
				_t3939 = _t3938
			v_hh_3558 = _t3939
			var _t3940 = (J.gp(J.gp(env["__p"]["HH"], v_hh_3558), "n") if J.t(v_hh_3558) else "空置單位")
			v_nm_3557 = _t3940
	v_doorX_3560 = J.round(J.num(J.add(J.gp(v_c_3553, 0.0), (J.sub(J.gp(v_c_3553, 1.0), J.gp(v_c_3553, 0.0)) * (0.24 if J.t(J.mod(v_u_3554, 2.0)) else 0.78)))))
	var _t3941 = J.gp(env["LVg"], "units")
	J.mc(_t3941, "push", [[env["f"], v_u_3554, v_w_3555, null, v_hh_3558, (-1.0), v_nm_3557, v_doorX_3560, [J.gp(v_c_3553, 0.0), J.gp(v_c_3553, 1.0)]]])

func _f584(this_, a: Array, env):
	var v_L_3563 = null
	v_L_3563 = J.arg(a, 0)
	var _t3943 = J.gp(v_L_3563, 4.0)
	var _t3944 = (J.cmp(J.gp(v_L_3563, 0.0), 3.0, ">=") if J.t(_t3943) else _t3943)
	return ((not J.t(J.gp(v_L_3563, 2.0))) if J.t(_t3944) else _t3944)

func _f585(this_, a: Array, env):
	var v_L_3566 = null
	v_L_3566 = J.arg(a, 0)
	var _t3950 = J.seq(J.gp(v_L_3566, 0.0), env["f"])
	var _t3951 = (J.gp(v_L_3566, 4.0) if _t3950 else _t3950)
	return ((not J.t(J.gp(v_L_3566, 2.0))) if J.t(_t3951) else _t3951)

func _f586(this_, a: Array, env):
	var v_L_3569 = null
	v_L_3569 = J.arg(a, 0)
	var _t3955 = J.gp(v_L_3569, 4.0)
	var _t3956 = (J.cmp(J.gp(v_L_3569, 5.0), 0.0, "<") if J.t(_t3955) else _t3955)
	return ((not J.t(J.gp(v_L_3569, 2.0))) if J.t(_t3956) else _t3956)

func _f576(this_, a: Array, env):
	var v_k_3506 = null; var v_NL_3509 = null; var v_FLn_3510 = null; var v_FH_3511 = null; var v_H_3513 = null; var v_ys_3514 = null; var v_colX_3518 = null; var v_ucols_3519 = null; var v_storyF_3521 = null; var v_si_3522 = null; var v_nU_3524 = null; var v_idx_3525 = null; var v_cands_3526 = null; var v_d_3527 = null; var v_STN_3528 = null; var v_c_3529 = null; var v_c2_3530 = null
	var _s1406 = {"__p": env, "B": null, "R": null, "W": null, "f": null, "xs": null, "x": null, "LVg": null, "wardsF": null}
	v_k_3506 = J.arg(a, 0)
	_s1406["B"] = J.gp(_s1406["__p"]["BLD"], v_k_3506)
	_s1406["R"] = _s1406["__p"]["rnd"]
	v_NL_3509 = J.len(J.gp(_s1406["B"], "levels"))
	v_FLn_3510 = J.sub(v_NL_3509, 1.0)
	v_FH_3511 = J.gp(_s1406["B"], "FH")
	_s1406["W"] = 0.0
	var _t3905 = J.gp(_s1406["B"], "cols")
	J.mc(_t3905, "forEach", [Callable(self, "_f577").bind(_s1406)])
	v_H_3513 = J.add(J.add((30.0 + J.mul(v_FLn_3510, v_FH_3511)), J.gp(_s1406["B"], "ROOF")), 40.0)
	v_ys_3514 = []
	_s1406["f"] = 0.0
	while true:
		if not J.cmp(_s1406["f"], v_FLn_3510, "<="): break
		J.mc(v_ys_3514, "push", [(J.sub(v_H_3513, 30.0) - J.mul(_s1406["f"], v_FH_3511))])
		_s1406["f"] = J.num(_s1406["f"]) + 1.0
	_s1406["xs"] = []
	_s1406["x"] = 0.0
	var _t3907 = J.gp(_s1406["B"], "cols")
	J.mc(_t3907, "forEach", [Callable(self, "_f578").bind(_s1406)])
	v_colX_3518 = Callable(self, "_f579").bind(_s1406)
	v_ucols_3519 = J.mc(_s1406["xs"], "filter", [Callable(self, "_f581").bind(_s1406)])
	_s1406["LVg"] = {"camW": J.gp(_s1406["B"], "camW"), "name": J.gp(_s1406["B"], "name"), "key": v_k_3506, "bg": null, "B": _s1406["B"], "FL": v_FLn_3510, "FYS": v_ys_3514, "WW": _s1406["W"], "WH": v_H_3513, "SX": J.cl(v_colX_3518, null, ["stair"]), "LX": J.cl(v_colX_3518, null, ["back"]), "GLX": J.cl(v_colX_3518, null, ["lift"]), "MX": J.cl(v_colX_3518, null, ["lift"]), "PX0": J.add(J.gp(J.gp(v_ucols_3519, 0.0), 0.0), 30.0), "fln": J.gp(_s1406["B"], "levels"), "xs": _s1406["xs"], "ucols": v_ucols_3519, "units": [], "pipes": J.gp(_s1406["B"], "pipes"), "lift": J.gp(_s1406["B"], "lift")}
	v_storyF_3521 = []
	v_si_3522 = 0.0
	_s1406["f"] = 0.0
	while true:
		if not J.cmp(_s1406["f"], v_FLn_3510, "<"): break
		_s1406["wardsF"] = {}
		v_nU_3524 = J.len(v_ucols_3519)
		if J.cmp(_s1406["f"], 2.0, ">="):
			var _t3909 = _s1406["__p"]["shuffle"]
			v_idx_3525 = J.cl(_t3909, null, [J.mc(v_ucols_3519, "map", [Callable(self, "_f582").bind(_s1406)])])
			var _t3910 = _s1406["wardsF"]
			var _t3911 = J.gp(v_idx_3525, 0.0)
			var _t3912 = _s1406["__p"]["pick"]
			var _t3913 = J.cl(_t3912, null, [["fu", "menshen", "datuk"]])
			J.sp(_t3910, _t3911, _t3913)
			var _t3914 = _s1406["wardsF"]
			var _t3915 = J.gp(v_idx_3525, 1.0)
			J.sp(_t3914, _t3915, "zha")
			var _t3916 = _s1406["wardsF"]
			var _t3917 = J.gp(v_idx_3525, 2.0)
			J.sp(_t3916, _t3917, "nuomi")
			if J.seq(J.mod(_s1406["f"], 2.0), 0.0):
				var _t3918 = _s1406["wardsF"]
				var _t3919 = J.gp(v_idx_3525, 3.0)
				var _t3920 = _s1406["__p"]["pick"]
				var _t3921 = J.cl(_t3920, null, [["zha", "nuomi"]])
				J.sp(_t3918, _t3919, _t3921)
			var _t3922 = J.cmp(v_nU_3524, 8.0, ">=")
			if (J.seq(J.mod(_s1406["f"], 3.0), 1.0) if _t3922 else _t3922):
				var _t3923 = _s1406["wardsF"]
				var _t3924 = J.gp(v_idx_3525, 4.0)
				J.sp(_t3923, _t3924, "zha")
		if J.seq(_s1406["f"], 1.0):
			var _t3925 = _s1406["wardsF"]
			J.sp(_t3925, 2.0, "datuk")
			var _t3926 = _s1406["wardsF"]
			J.sp(_t3926, 5.0, "zha")
		if J.seq(_s1406["f"], 0.0):
			var _t3927 = _s1406["wardsF"]
			J.sp(_t3927, 1.0, "zha")
		J.mc(v_ucols_3519, "forEach", [Callable(self, "_f583").bind(_s1406)])
		_s1406["f"] = J.num(_s1406["f"]) + 1.0
	var _t3942 = J.gp(_s1406["LVg"], "units")
	v_cands_3526 = J.mc(_t3942, "filter", [Callable(self, "_f584").bind(_s1406)])
	if J.t(J.len(v_cands_3526)):
		var _t3945 = _s1406["__p"]["pick"]
		v_d_3527 = J.cl(_t3945, null, [v_cands_3526])
		J.sp(v_d_3527, 4.0, "debt")
		var _t3946 = J.gp(J.gp(_s1406["__p"]["HH"], "debt"), "n")
		J.sp(v_d_3527, 6.0, _t3946)
	v_STN_3528 = J.len(J.gp(J.gp(_s1406["__p"]["LV0"], v_k_3506), "story"))
	_s1406["f"] = 1.0
	while true:
		var _t3947 = J.cmp(_s1406["f"], v_FLn_3510, "<")
		if not (J.cmp(v_si_3522, v_STN_3528, "<") if _t3947 else _t3947): break
		var _t3948 = _s1406["__p"]["shuffle"]
		var _t3949 = J.gp(_s1406["LVg"], "units")
		v_c_3529 = J.gp(J.cl(_t3948, null, [J.mc(_t3949, "filter", [Callable(self, "_f585").bind(_s1406)])]), 0.0)
		if J.t(v_c_3529):
			var _t3952 = J.num(v_si_3522)
			v_si_3522 = _t3952 + 1.0
			J.sp(v_c_3529, 5.0, _t3952)
		_s1406["f"] = J.num(_s1406["f"]) + 1.0
	while true:
		if not J.cmp(v_si_3522, v_STN_3528, "<"): break
		var _t3953 = _s1406["__p"]["shuffle"]
		var _t3954 = J.gp(_s1406["LVg"], "units")
		v_c2_3530 = J.gp(J.cl(_t3953, null, [J.mc(_t3954, "filter", [Callable(self, "_f586").bind(_s1406)])]), 0.0)
		if (not J.t(v_c2_3530)):
			break
		var _t3957 = J.num(v_si_3522)
		v_si_3522 = _t3957 + 1.0
		J.sp(v_c2_3530, 5.0, _t3957)
	return _s1406["LVg"]

func _f588(this_, a: Array, env):
	var v_p_3578 = null
	v_p_3578 = J.arg(a, 0)
	var _t3958 = J.add(env["t"], J.gp(v_p_3578, 1.0))
	env["t"] = _t3958

func _f587(this_, a: Array, env):
	var v_a_3572 = null; var v_r_3574 = null; var v_i_3575 = null
	var _s1431 = {"__p": env, "t": null}
	v_a_3572 = J.arg(a, 0)
	_s1431["t"] = 0.0
	J.mc(v_a_3572, "forEach", [Callable(self, "_f588").bind(_s1431)])
	v_r_3574 = J.mul(J.cl(_s1431["__p"]["rnd"], null, []), _s1431["t"])
	v_i_3575 = 0.0
	while true:
		if not J.cmp(v_i_3575, J.len(v_a_3572), "<"): break
		var _t3959 = J.sub(v_r_3574, J.gp(J.gp(v_a_3572, v_i_3575), 1.0))
		v_r_3574 = _t3959
		if J.cmp(v_r_3574, 0.0, "<="):
			return J.gp(J.gp(v_a_3572, v_i_3575), 0.0)
		v_i_3575 = J.num(v_i_3575) + 1.0
	return J.gp(J.gp(v_a_3572, 0.0), 0.0)

func _f590(this_, a: Array, env):
	var v_L_3591 = null
	v_L_3591 = J.arg(a, 0)
	return J.seq(J.gp(v_L_3591, 0.0), env["f"])

func _f591(this_, a: Array, env):
	var v_L_3594 = null
	v_L_3594 = J.arg(a, 0)
	J.mc(env["stops"], "push", [{"x": J.gp(v_L_3594, 7.0), "u": J.gp(v_L_3594, 1.0)}])

func _f592(this_, a: Array, env):
	var v_P_3597 = null; var v_i_3598 = null; var v_c_3599 = null
	v_P_3597 = J.arg(a, 0)
	v_i_3598 = J.arg(a, 1)
	var _t3968 = J.seq(J.gp(v_P_3597, 0.0), env["f"])
	if (_t3968 if _t3968 else J.seq(J.gp(v_P_3597, 1.0), env["f"])):
		v_c_3599 = J.gp(J.gp(env["__p"]["LV"], "ucols"), J.gp(v_P_3597, 2.0))
		J.mc(env["stops"], "push", [{"x": J.sub(J.gp(v_c_3599, 1.0), 6.0), "pipe": v_i_3598}])

func _f593(this_, a: Array, env):
	var v_P_3602 = null; var v_i_3603 = null; var v_c_3604 = null
	v_P_3602 = J.arg(a, 0)
	v_i_3603 = J.arg(a, 1)
	if J.seq(J.gp(v_P_3602, 1.0), env["f"]):
		v_c_3604 = J.gp(J.gp(env["__p"]["LV"], "ucols"), J.gp(v_P_3602, 2.0))
		J.mc(env["stops"], "push", [{"x": J.sub(J.gp(v_c_3604, 1.0), 6.0), "pipe": v_i_3603}])

func _f594(this_, a: Array, env):
	var v_a_3607 = null; var v_b_3608 = null
	v_a_3607 = J.arg(a, 0)
	v_b_3608 = J.arg(a, 1)
	return J.sub(J.gp(v_a_3607, "x"), J.gp(v_b_3608, "x"))

func _f595(this_, a: Array, env):
	var v_st_3611 = null; var v_id_3612 = null; var v_e_3613 = null; var v_le_3614 = null
	v_st_3611 = J.arg(a, 0)
	if J.seq(J.gp(v_st_3611, "p"), 1.0):
		v_id_3612 = "f0_e"
		var _t3970 = env["__p"]["node"]
		J.cl(_t3970, null, [v_id_3612, J.gp(v_st_3611, "x"), env["y"], 0.0, "portal"])
	else:
		if J.seq(J.gp(v_st_3611, "p"), 2.0):
			var _t3971 = (J.add("f", env["__p"]["FL"]) + "_p")
			v_id_3612 = _t3971
			var _t3972 = env["__p"]["node"]
			J.cl(_t3972, null, [v_id_3612, J.gp(v_st_3611, "x"), env["y"], env["f"], "portal"])
		else:
			if J.t(J.gp(v_st_3611, "lift")):
				var _t3973 = (J.add("f", env["f"]) + "_l")
				v_id_3612 = _t3973
			else:
				if J.t(J.gp(v_st_3611, "back")):
					var _t3974 = (J.add("f", env["f"]) + "_b")
					v_id_3612 = _t3974
				else:
					if (not J.leq(J.gp(v_st_3611, "pipe"), null)):
						var _t3975 = J.add((J.add("f", env["f"]) + "_q"), J.gp(v_st_3611, "pipe"))
						v_id_3612 = _t3975
						var _t3976 = env["__p"]["node"]
						J.cl(_t3976, null, [v_id_3612, J.gp(v_st_3611, "x"), env["y"], env["f"], "pipe"])
					else:
						var _t3977 = J.add((J.add("f", env["f"]) + "_d"), J.gp(v_st_3611, "u"))
						v_id_3612 = _t3977
						var _t3978 = env["__p"]["node"]
						J.cl(_t3978, null, [v_id_3612, J.gp(v_st_3611, "x"), env["y"], env["f"], "door"])
						var _t3979 = env["__p"]["node"]
						J.cl(_t3979, null, [J.add((J.add("f", env["f"]) + "_i"), J.gp(v_st_3611, "u")), J.sub(J.gp(v_st_3611, "x"), 14.0), J.sub(env["y"], 34.0), env["f"], "in"])
						var _t3980 = env["__p"]["link"]
						v_e_3613 = J.cl(_t3980, null, [v_id_3612, J.add((J.add("f", env["f"]) + "_i"), J.gp(v_st_3611, "u"))])
						J.sp(v_e_3613, "door", true)
	var _t3981 = env["__p"]["link"]
	v_le_3614 = J.cl(_t3981, null, [env["prev"], v_id_3612])
	if J.t(env["first"]):
		var _t3982 = {"shut": 0.0, "cd": 0.0, "x": J.div(J.add(J.gp(J.gp(J.gp(env["__p"]["G"], "nodes"), env["prev"]), "x"), J.gp(J.gp(J.gp(env["__p"]["G"], "nodes"), v_id_3612), "x")), 2.0), "f": env["f"]}
		J.sp(v_le_3614, "fire", _t3982)
		env["first"] = false
	env["prev"] = v_id_3612

func _f596(this_, a: Array, env):
	var v_P_3617 = null; var v_i_3618 = null; var v_e_3619 = null
	v_P_3617 = J.arg(a, 0)
	v_i_3618 = J.arg(a, 1)
	var _t3991 = env["__p"]["link"]
	v_e_3619 = J.cl(_t3991, null, [J.add((J.add("f", J.gp(v_P_3617, 0.0)) + "_q"), v_i_3618), J.add((J.add("f", J.gp(v_P_3617, 1.0)) + "_q"), v_i_3618)])
	J.sp(v_e_3619, "vert", true)
	J.sp(v_e_3619, "pipe", true)

func _f589(this_, a: Array, env):
	var v_B_3581 = null; var v_lastE_3587 = null; var v_le2_3588 = null
	var _s1435 = {"__p": env, "f": null, "y": null, "stops": null, "prev": null, "first": null}
	v_B_3581 = J.gp(_s1435["__p"]["LV"], "B")
	_s1435["f"] = 0.0
	while true:
		if not J.cmp(_s1435["f"], _s1435["__p"]["FL"], "<="): break
		var _t3960 = _s1435["__p"]["fy"]
		_s1435["y"] = J.cl(_t3960, null, [_s1435["f"]])
		_s1435["stops"] = []
		var _t3961 = _s1435["__p"]["node"]
		J.cl(_t3961, null, [(J.add("f", _s1435["f"]) + "_s"), _s1435["__p"]["SX"], _s1435["y"], _s1435["f"], "stair"])
		var _t3962 = J.cmp(_s1435["f"], 1.0, ">=")
		if (_t3962 if _t3962 else (not J.t(J.gp(v_B_3581, "lift")))):
			var _t3963 = _s1435["__p"]["node"]
			J.cl(_t3963, null, [(J.add("f", _s1435["f"]) + "_b"), _s1435["__p"]["LX"], _s1435["y"], _s1435["f"], "stair"])
		var _t3964 = _s1435["__p"]["node"]
		J.cl(_t3964, null, [(J.add("f", _s1435["f"]) + "_l"), J.gp(_s1435["__p"]["LV"], "MX"), _s1435["y"], _s1435["f"], ("lift" if J.t(J.gp(v_B_3581, "lift")) else "stair")])
		if J.cmp(_s1435["f"], _s1435["__p"]["FL"], "<"):
			var _t3965 = J.gp(_s1435["__p"]["LV"], "units")
			var _t3966 = J.mc(_t3965, "filter", [Callable(self, "_f590").bind(_s1435)])
			J.mc(_t3966, "forEach", [Callable(self, "_f591").bind(_s1435)])
			if J.seq(_s1435["f"], 0.0):
				J.mc(_s1435["stops"], "push", [{"x": J.gp(_s1435["__p"]["LV"], "PX0"), "p": 1.0}])
			var _t3967 = J.gp(_s1435["__p"]["LV"], "pipes")
			J.mc(_t3967, "forEach", [Callable(self, "_f592").bind(_s1435)])
		else:
			J.mc(_s1435["stops"], "push", [{"x": (J.round(J.num(J.mul(_s1435["__p"]["WW"], 0.5))) + 40.0), "p": 2.0}])
			var _t3969 = J.gp(_s1435["__p"]["LV"], "pipes")
			J.mc(_t3969, "forEach", [Callable(self, "_f593").bind(_s1435)])
		J.mc(_s1435["stops"], "push", [{"x": J.gp(_s1435["__p"]["LV"], "MX"), "lift": 1.0}])
		if J.t(J.gp(J.gp(_s1435["__p"]["G"], "nodes"), (J.add("f", _s1435["f"]) + "_b"))):
			J.mc(_s1435["stops"], "push", [{"x": _s1435["__p"]["LX"], "back": 1.0}])
		J.mc(_s1435["stops"], "sort", [Callable(self, "_f594").bind(_s1435)])
		_s1435["prev"] = (J.add("f", _s1435["f"]) + "_s")
		_s1435["first"] = true
		J.mc(_s1435["stops"], "forEach", [Callable(self, "_f595").bind(_s1435)])
		if J.seq(_s1435["prev"], (J.add("f", _s1435["f"]) + "_b")):
			v_lastE_3587 = J.gp(J.gp(J.gp(J.gp(J.gp(_s1435["__p"]["G"], "nodes"), _s1435["prev"]), "links"), (J.len(J.gp(J.gp(J.gp(_s1435["__p"]["G"], "nodes"), _s1435["prev"]), "links")) - 1.0)), "e")
			var _t3983 = {"shut": 0.0, "cd": 0.0, "x": J.div(J.add(J.gp(J.gp(J.gp(_s1435["__p"]["G"], "nodes"), J.gp(v_lastE_3587, "a")), "x"), J.gp(J.gp(J.gp(_s1435["__p"]["G"], "nodes"), J.gp(v_lastE_3587, "b")), "x")), 2.0), "f": _s1435["f"]}
			J.sp(v_lastE_3587, "fire", _t3983)
		if J.cmp(_s1435["f"], 0.0, ">"):
			var _t3984 = _s1435["__p"]["link"]
			var _t3985 = J.cl(_t3984, null, [(J.add("f", J.sub(_s1435["f"], 1.0)) + "_s"), (J.add("f", _s1435["f"]) + "_s")])
			J.sp(_t3985, "vert", true)
			var _t3986 = _s1435["__p"]["link"]
			v_le2_3588 = J.cl(_t3986, null, [(J.add("f", J.sub(_s1435["f"], 1.0)) + "_l"), (J.add("f", _s1435["f"]) + "_l")])
			J.sp(v_le2_3588, "vert", true)
			if J.t(J.gp(v_B_3581, "lift")):
				J.sp(v_le2_3588, "lift", true)
			var _t3987 = J.gp(J.gp(_s1435["__p"]["G"], "nodes"), (J.add("f", J.sub(_s1435["f"], 1.0)) + "_b"))
			if J.t((J.gp(J.gp(_s1435["__p"]["G"], "nodes"), (J.add("f", _s1435["f"]) + "_b")) if J.t(_t3987) else _t3987)):
				var _t3988 = _s1435["__p"]["link"]
				var _t3989 = J.cl(_t3988, null, [(J.add("f", J.sub(_s1435["f"], 1.0)) + "_b"), (J.add("f", _s1435["f"]) + "_b")])
				J.sp(_t3989, "vert", true)
		_s1435["f"] = J.num(_s1435["f"]) + 1.0
	var _t3990 = J.gp(_s1435["__p"]["LV"], "pipes")
	J.mc(_t3990, "forEach", [Callable(self, "_f596").bind(_s1435)])

func _f599(this_, a: Array, env):
	var v_l_3650 = null
	v_l_3650 = J.arg(a, 0)
	return J.seq(J.gp(v_l_3650, "to"), env["id"])

func _f600(this_, a: Array, env):
	var v_it_3653 = null
	v_it_3653 = J.arg(a, 0)
	var _t4016 = J.gp(env["un"], "items")
	J.mc(_t4016, "push", [v_it_3653])

func _f601(this_, a: Array, env):
	var v_sp_3656 = null; var v_i_3657 = null; var v_hw0_3658 = null; var v_px_3659 = null; var v_r_3660 = null
	v_sp_3656 = J.arg(a, 0)
	v_i_3657 = J.arg(a, 1)
	v_hw0_3658 = ((((60.0 if J.t(J.mod(v_i_3657, 2.0)) else 66.0) if J.cmp(env["n"], 3.0, ">=") else 74.0) * 0.47) + 4.0)
	v_px_3659 = J.add(J.gp(J.gp(env["un"], "rx"), 0.0), J.mul(env["w0"], (0.42 if J.seq(env["n"], 1.0) else ((0.18 + J.div(J.mul(0.64, v_i_3657), J.sub(env["n"], 1.0))) if J.cmp(env["n"], 3.0, ">=") else (0.28 + J.div(J.mul(0.44, v_i_3657), J.sub(env["n"], 1.0)))))))
	var _t4021 = J.cmp(env["n"], 3.0, "<")
	if ((absf(J.num(J.sub(v_px_3659, J.gp(env["un"], "x")))) < 22.0) if _t4021 else _t4021):
		var _t4022 = J.add(v_px_3659, ((-24.0) if J.cmp(v_px_3659, J.gp(env["un"], "x"), "<") else 24.0))
		v_px_3659 = _t4022
	var _t4023 = J.max_([J.add(J.gp(J.gp(env["un"], "rx"), 0.0), v_hw0_3658), J.min_([J.sub(J.gp(J.gp(env["un"], "rx"), 1.0), v_hw0_3658), v_px_3659])])
	v_px_3659 = _t4023
	var _t4025 = ((60.0 if J.t(J.mod(v_i_3657, 2.0)) else 66.0) if J.cmp(env["n"], 3.0, ">=") else 74.0)
	var _t4024 = J.cmp(env["n"], 3.0, ">=")
	var _t4027 = ((-8.0) if J.t((J.mod(v_i_3657, 2.0) if _t4024 else _t4024)) else 0.0)
	var _t4028 = env["un"]
	var _t4026 = env["__p"]["__p"]["fy"]
	var _t4030 = J.sub(J.cl(_t4026, null, [env["f"]]), 16.0)
	var _t4029 = J.gp(env["hh"], "brave")
	v_r_3660 = {"h": _t4025, "dy": _t4027, "unit": _t4028, "sprite": v_sp_3656, "x": v_px_3659, "y": _t4030, "fear": 0.0, "brave": (_t4029 if J.t(_t4029) else 0.0), "state": "home", "vx": 0.0, "doorT": (8.0 + J.mul(J.cl(env["__p"]["__p"]["rnd"], null, []), 10.0)), "hh": J.gp(env["L"], 4.0), "awake": J.seq(J.gp(J.gp(env["hh"], "awake"), 0.0), 1.0), "idleT": (4.0 + J.mul(J.cl(env["__p"]["__p"]["rnd"], null, []), 10.0))}
	if J.t(J.gp(env["hh"], "away")):
		J.sp(v_r_3660, "state", "away")
	var _t4031 = J.gp(env["__p"]["__p"]["G"], "res")
	J.mc(_t4031, "push", [v_r_3660])
	var _t4032 = J.gp(env["un"], "rs")
	J.mc(_t4032, "push", [v_r_3660])

func _f602(this_, a: Array, env):
	var v_p_3663 = null; var v_i_3664 = null
	v_p_3663 = J.arg(a, 0)
	v_i_3664 = J.arg(a, 1)
	var _t4036 = J.gp(env["un"], "props")
	J.mc(_t4036, "push", [{"k": v_p_3663, "x": J.add(J.add(J.gp(J.gp(env["un"], "rx"), 0.0), J.mul(env["w0"], (0.3 + J.mul(0.4, v_i_3664)))), (8.0 if J.t(v_i_3664) else (-8.0))), "t": 0.0, "cd": 0.0}])

func _f598(this_, a: Array, env):
	var v_u_3639 = null; var v_w_3640 = null; var v_did_3643 = null; var v_e_3644 = null
	var _s1459 = {"__p": env, "L": null, "f": null, "hh": null, "id": null, "un": null, "n": null, "w0": null}
	_s1459["L"] = J.arg(a, 0)
	_s1459["f"] = J.gp(_s1459["L"], 0.0)
	v_u_3639 = J.gp(_s1459["L"], 1.0)
	v_w_3640 = J.gp(_s1459["L"], 2.0)
	_s1459["hh"] = (J.gp(_s1459["__p"]["__p"]["HH"], J.gp(_s1459["L"], 4.0)) if J.t(J.gp(_s1459["L"], 4.0)) else null)
	_s1459["id"] = J.add((J.add("f", _s1459["f"]) + "_i"), v_u_3639)
	v_did_3643 = J.add((J.add("f", _s1459["f"]) + "_d"), v_u_3639)
	var _t3995 = J.gp(J.gp(J.gp(_s1459["__p"]["__p"]["G"], "nodes"), v_did_3643), "links")
	v_e_3644 = J.gp(J.mc(_t3995, "find", [Callable(self, "_f599").bind(_s1459)]), "e")
	J.sp(v_e_3644, "ward", v_w_3640)
	var _t3997 = _s1459["f"]
	var _t3998 = _s1459["id"]
	var _t3999 = J.cmp(J.gp(_s1459["L"], 5.0), 0.0, ">=")
	var _t4000 = J.gp(_s1459["L"], 5.0)
	var _t4001 = J.gp(_s1459["L"], 6.0)
	var _t4002 = J.gp(J.gp(J.gp(_s1459["__p"]["__p"]["G"], "nodes"), v_did_3643), "x")
	var _t3996 = _s1459["__p"]["__p"]["fy"]
	_s1459["un"] = {"f": _t3997, "u": v_u_3639, "id": _t3998, "did": v_did_3643, "ward": v_w_3640, "task": null, "story": _t3999, "si": _t4000, "name": _t4001, "x": _t4002, "y": J.cl(_t3996, null, [_s1459["f"]]), "rx": J.gp(_s1459["L"], 8.0), "lit": false, "litT": 0.0, "hh": J.gp(_s1459["L"], 4.0), "open": true, "ot": 0.0, "cost": 0.0, "paid": 0.0, "seen": false, "entered": false, "plus": (2.0 if J.cmp(J.gp(_s1459["L"], 5.0), 0.0, ">=") else 1.0), "items": [], "door": false, "doorOpen": 0.0, "ambush": null, "dep": null, "keyNeed": null, "rs": [], "props": []}
	var _t4003 = J.seq(v_w_3640, "fu")
	var _t4004 = (_t4003 if _t4003 else J.seq(v_w_3640, "menshen"))
	if (_t4004 if _t4004 else J.seq(v_w_3640, "datuk")):
		var _t4005 = _s1459["un"]
		J.sp(_t4005, "open", false)
		var _t4006 = _s1459["un"]
		J.sp(_t4006, "ot", "deity")
	else:
		if J.seq(v_w_3640, "zha"):
			var _t4007 = _s1459["un"]
			J.sp(_t4007, "open", false)
			var _t4008 = _s1459["un"]
			J.sp(_t4008, "ot", 2.0)
			var _t4009 = _s1459["un"]
			var _t4010 = J.add(4.0, _s1459["f"])
			J.sp(_t4009, "cost", _t4010)
		else:
			if J.seq(v_w_3640, "nuomi"):
				var _t4011 = _s1459["un"]
				J.sp(_t4011, "open", false)
				var _t4012 = _s1459["un"]
				J.sp(_t4012, "ot", 2.0)
				var _t4013 = _s1459["un"]
				var _t4014 = J.add(3.0, _s1459["f"])
				J.sp(_t4013, "cost", _t4014)
	if J.t(_s1459["hh"]):
		var _t4015 = J.gp(_s1459["hh"], "items")
		J.mc(_t4015, "forEach", [Callable(self, "_f600").bind(_s1459)])
	else:
		var _t4017 = J.seq(_s1459["f"], 1.0)
		if ((not J.seq(J.gp(_s1459["un"], "ot"), "deity")) if _t4017 else _t4017):
			var _t4018 = J.gp(_s1459["un"], "items")
			var _t4019 = _s1459["__p"]["__p"]["pick"]
			J.mc(_t4018, "push", [J.cl(_t4019, null, [["food", "money", "comb"]])])
	if J.t(((not J.seq(J.gp(_s1459["un"], "ot"), "deity")) if J.t(_s1459["hh"]) else _s1459["hh"])):
		_s1459["n"] = J.len(J.gp(_s1459["hh"], "sp"))
		_s1459["w0"] = J.sub(J.gp(J.gp(_s1459["un"], "rx"), 1.0), J.gp(J.gp(_s1459["un"], "rx"), 0.0))
		var _t4020 = J.gp(_s1459["hh"], "sp")
		J.mc(_t4020, "forEach", [Callable(self, "_f601").bind(_s1459)])
		var _t4033 = _s1459["un"]
		var _t4034 = J.gp(J.gp(_s1459["un"], "rs"), 0.0)
		J.sp(_t4033, "res", _t4034)
		var _t4035 = J.gp(_s1459["hh"], "props")
		J.mc(_t4035, "forEach", [Callable(self, "_f602").bind(_s1459)])
	var _t4037 = J.gp(_s1459["__p"]["__p"]["G"], "units")
	J.mc(_t4037, "push", [_s1459["un"]])
	var _t4038 = _s1459["un"]
	J.sp(v_e_3644, "unit", _t4038)

func _f604(this_, a: Array, env):
	var v_v_3671 = null
	v_v_3671 = J.arg(a, 0)
	var _t4042 = J.seq(J.gp(v_v_3671, "f"), J.gp(env["u"], "f"))
	var _t4043 = ((not J.seq(v_v_3671, env["u"])) if _t4042 else _t4042)
	var _t4044 = (J.len(J.gp(v_v_3671, "rs")) if _t4043 else _t4043)
	var _t4045 = ((not J.seq(J.gp(v_v_3671, "ot"), "deity")) if J.t(_t4044) else _t4044)
	return (J.seq(absf(J.num(J.sub(J.gp(v_v_3671, "u"), J.gp(env["u"], "u")))), 1.0) if J.t(_t4045) else _t4045)

func _f603(this_, a: Array, env):
	var v_nb_3668 = null
	var _s1469 = {"__p": env, "u": null}
	_s1469["u"] = J.arg(a, 0)
	var _t4040 = (not J.seq(J.gp(_s1469["u"], "ot"), 0.0))
	if (_t4040 if _t4040 else J.cmp(J.gp(_s1469["u"], "f"), 2.0, "<")):
		return null
	var _t4041 = J.gp(_s1469["__p"]["__p"]["G"], "units")
	v_nb_3668 = J.gp(J.mc(_t4041, "filter", [Callable(self, "_f604").bind(_s1469)]), 0.0)
	var _t4047 = v_nb_3668
	if J.t(_t4047):
		var _t4046 = J.gp(_s1469["u"], "story")
		_t4047 = (_t4046 if J.t(_t4046) else J.cmp(J.cl(_s1469["__p"]["__p"]["rnd"], null, []), 0.22, "<"))
	if J.t(_t4047):
		var _t4048 = _s1469["u"]
		J.sp(_t4048, "open", false)
		var _t4049 = _s1469["u"]
		J.sp(_t4049, "ot", 1.0)
		var _t4050 = _s1469["u"]
		J.sp(_t4050, "dep", v_nb_3668)

func _f605(this_, a: Array, env):
	var v_u_3674 = null
	v_u_3674 = J.arg(a, 0)
	var _t4052 = J.seq(J.gp(v_u_3674, "ot"), 0.0)
	var _t4053 = (J.cmp(J.gp(v_u_3674, "f"), J.sub(env["__p"]["FL"], 3.0), ">=") if _t4052 else _t4052)
	return (J.len(J.gp(v_u_3674, "rs")) if _t4053 else _t4053)

func _f606(this_, a: Array, env):
	var v_a_3677 = null; var v_b_3678 = null
	v_a_3677 = J.arg(a, 0)
	v_b_3678 = J.arg(a, 1)
	return J.sub(J.gp(v_b_3678, "f"), J.gp(v_a_3677, "f"))

func _f607(this_, a: Array, env):
	var v_kn_3681 = null; var v_i_3682 = null; var v_t_3683 = null
	v_kn_3681 = J.arg(a, 0)
	v_i_3682 = J.arg(a, 1)
	v_t_3683 = J.gp(env["tops"], J.mul(v_i_3682, 2.0))
	if J.t(v_t_3683):
		J.sp(v_t_3683, "open", false)
		J.sp(v_t_3683, "ot", 11.0)
		J.sp(v_t_3683, "keyNeed", v_kn_3681)
		J.mc(env["keyUnits"], "push", [v_t_3683])

func _f608(this_, a: Array, env):
	var v_u_3686 = null
	v_u_3686 = J.arg(a, 0)
	var _t4056 = (not J.seq(J.gp(v_u_3686, "ot"), "deity"))
	return (J.cmp(J.mc(env["keyUnits"], "indexOf", [v_u_3686]), 0.0, "<") if _t4056 else _t4056)

func _f610(this_, a: Array, env):
	var v_u_3694 = null
	v_u_3694 = J.arg(a, 0)
	return J.cmp(J.gp(v_u_3694, "f"), J.sub(J.gp(J.gp(env["__p"]["keyUnits"], env["i"]), "f"), 1.0), "<")

func _f609(this_, a: Array, env):
	var v_kn_3689 = null; var v_c_3691 = null
	var _s1477 = {"__p": env, "i": null}
	v_kn_3689 = J.arg(a, 0)
	_s1477["i"] = J.arg(a, 1)
	if (not J.t(J.gp(_s1477["__p"]["keyUnits"], _s1477["i"]))):
		return null
	var _t4057 = _s1477["__p"]["__p"]["shuffle"]
	v_c_3691 = J.gp(J.cl(_t4057, null, [J.mc(_s1477["__p"]["cand"], "filter", [Callable(self, "_f610").bind(_s1477)])]), 0.0)
	if J.t(v_c_3691):
		var _t4058 = J.gp(v_c_3691, "items")
		J.mc(_t4058, "push", [v_kn_3689])

func _f611(this_, a: Array, env):
	var v_u_3697 = null
	v_u_3697 = J.arg(a, 0)
	if J.cmp(env["dolls"], 12.0, "<"):
		var _t4061 = J.gp(v_u_3697, "items")
		J.mc(_t4061, "push", ["doll"])
		env["dolls"] = J.num(env["dolls"]) + 1.0

func _f612(this_, a: Array, env):
	var v_u_3700 = null
	v_u_3700 = J.arg(a, 0)
	var _t4064 = J.len(J.gp(v_u_3700, "rs"))
	var _t4065 = (J.seq(J.gp(v_u_3700, "ot"), 0.0) if J.t(_t4064) else _t4064)
	return (J.cmp(J.gp(v_u_3700, "f"), 2.0, ">=") if J.t(_t4065) else _t4065)

func _f613(this_, a: Array, env):
	var v_u_3703 = null
	v_u_3703 = J.arg(a, 0)
	J.sp(v_u_3703, "door", true)

func _f614(this_, a: Array, env):
	var v_u_3706 = null
	v_u_3706 = J.arg(a, 0)
	var _t4070 = (not J.t(J.len(J.gp(v_u_3706, "rs"))))
	var _t4071 = ((not J.seq(J.gp(v_u_3706, "ot"), "deity")) if _t4070 else _t4070)
	return (J.cmp(J.gp(v_u_3706, "f"), 1.0, ">=") if _t4071 else _t4071)

func _f615(this_, a: Array, env):
	var v_u_3709 = null
	v_u_3709 = J.arg(a, 0)
	J.sp(v_u_3709, "ambush", "dog")

func _f616(this_, a: Array, env):
	var v_u_3712 = null
	v_u_3712 = J.arg(a, 0)
	var _t4075 = J.seq(J.gp(v_u_3712, "ot"), 0.0)
	var _t4076 = (_t4075 if _t4075 else J.seq(J.gp(v_u_3712, "ot"), "deity"))
	var _t4077 = ((not J.t(J.gp(v_u_3712, "ambush"))) if _t4076 else _t4076)
	var _t4078 = (J.cmp(J.gp(v_u_3712, "f"), 1.0, "<=") if _t4077 else _t4077)
	J.sp(v_u_3712, "seen", _t4078)
	var _t4079 = J.seq(J.gp(v_u_3712, "ot"), 0.0)
	var _t4080 = ((not J.t(J.gp(v_u_3712, "ambush"))) if _t4079 else _t4079)
	var _t4081 = (J.cmp(J.gp(v_u_3712, "f"), 1.0, ">") if _t4080 else _t4080)
	if (J.cmp(J.cl(env["__p"]["rnd"], null, []), 0.5, "<") if _t4081 else _t4081):
		J.sp(v_u_3712, "seen", true)

func _f617(this_, a: Array, env):
	var v_u_3715 = null
	v_u_3715 = J.arg(a, 0)
	return J.seq(J.gp(v_u_3715, "f"), env["f"])

func _f618(this_, a: Array, env):
	var v_u_3718 = null
	v_u_3718 = J.arg(a, 0)
	var _t4091 = J.seq(J.gp(v_u_3718, "hh"), "elder")
	var _t4092 = (_t4091 if _t4091 else J.seq(J.gp(v_u_3718, "hh"), "granny"))
	var _t4093 = (J.cmp(J.gp(v_u_3718, "f"), 2.0, ">=") if _t4092 else _t4092)
	return (J.gp(v_u_3718, "open") if _t4093 else _t4093)

func _f619(this_, a: Array, env):
	var v_u_3721 = null
	v_u_3721 = J.arg(a, 0)
	var _t4095 = J.seq(J.gp(v_u_3721, "hh"), "elder")
	return (_t4095 if _t4095 else J.seq(J.gp(v_u_3721, "hh"), "granny"))

func _f620(this_, a: Array, env):
	var v_u_3724 = null
	v_u_3724 = J.arg(a, 0)
	var _t4100 = (not J.seq(v_u_3724, env["ow"]))
	return ((absf(J.num(J.sub(J.gp(v_u_3724, "f"), J.gp(env["ow"], "f")))) >= 2.0) if _t4100 else _t4100)

func _f621(this_, a: Array, env):
	var v_u_3727 = null
	v_u_3727 = J.arg(a, 0)
	return J.seq(J.gp(v_u_3727, "hh"), "debt")

func _f622(this_, a: Array, env):
	var v_u_3730 = null
	v_u_3730 = J.arg(a, 0)
	return J.seq(J.gp(v_u_3730, "hh"), "mahjong")

func _f597(this_, a: Array, env):
	var v_keyNames_3622 = null; var v_ds_3628 = null; var v_olds_3629 = null; var v_thing_3631 = null; var v_hid_3632 = null; var v_dbt_3633 = null; var v_mj_3634 = null
	var _s1458 = {"__p": env, "tops": null, "keyUnits": null, "cand": null, "dolls": null, "f": null, "ow": null}
	var _t3992 = _s1458["__p"]["G"]
	var _t3993 = []
	J.sp(_t3992, "traces", _t3993)
	var _t3994 = J.gp(_s1458["__p"]["LV"], "units")
	J.mc(_t3994, "forEach", [Callable(self, "_f598").bind(_s1458)])
	var _t4039 = J.gp(_s1458["__p"]["G"], "units")
	J.mc(_t4039, "forEach", [Callable(self, "_f603").bind(_s1458)])
	v_keyNames_3622 = ["key", "key2"]
	var _t4051 = J.gp(_s1458["__p"]["G"], "units")
	var _t4054 = J.mc(_t4051, "filter", [Callable(self, "_f605").bind(_s1458)])
	_s1458["tops"] = J.mc(_t4054, "sort", [Callable(self, "_f606").bind(_s1458)])
	_s1458["keyUnits"] = []
	J.mc(v_keyNames_3622, "forEach", [Callable(self, "_f607").bind(_s1458)])
	var _t4055 = J.gp(_s1458["__p"]["G"], "units")
	_s1458["cand"] = J.mc(_t4055, "filter", [Callable(self, "_f608").bind(_s1458)])
	J.mc(v_keyNames_3622, "forEach", [Callable(self, "_f609").bind(_s1458)])
	_s1458["dolls"] = 0.0
	var _t4059 = _s1458["__p"]["shuffle"]
	var _t4060 = J.cl(_t4059, null, [_s1458["cand"]])
	J.mc(_t4060, "forEach", [Callable(self, "_f611").bind(_s1458)])
	var _t4062 = _s1458["__p"]["shuffle"]
	var _t4063 = J.gp(_s1458["__p"]["G"], "units")
	var _t4066 = J.cl(_t4062, null, [J.mc(_t4063, "filter", [Callable(self, "_f612").bind(_s1458)])])
	var _t4067 = J.mc(_t4066, "slice", [0.0, 6.0])
	J.mc(_t4067, "forEach", [Callable(self, "_f613").bind(_s1458)])
	var _t4068 = _s1458["__p"]["shuffle"]
	var _t4069 = J.gp(_s1458["__p"]["G"], "units")
	var _t4072 = J.cl(_t4068, null, [J.mc(_t4069, "filter", [Callable(self, "_f614").bind(_s1458)])])
	var _t4073 = J.mc(_t4072, "slice", [0.0, 3.0])
	J.mc(_t4073, "forEach", [Callable(self, "_f615").bind(_s1458)])
	var _t4074 = J.gp(_s1458["__p"]["G"], "units")
	J.mc(_t4074, "forEach", [Callable(self, "_f616").bind(_s1458)])
	var _t4082 = _s1458["__p"]["G"]
	var _t4083 = []
	J.sp(_t4082, "cprops", _t4083)
	_s1458["f"] = 1.0
	while true:
		if not J.cmp(_s1458["f"], _s1458["__p"]["FL"], "<"): break
		var _t4084 = _s1458["__p"]["shuffle"]
		var _t4085 = J.gp(_s1458["__p"]["G"], "units")
		v_ds_3628 = J.cl(_t4084, null, [J.mc(_t4085, "filter", [Callable(self, "_f617").bind(_s1458)])])
		if J.t(J.gp(v_ds_3628, 0.0)):
			var _t4086 = J.gp(_s1458["__p"]["G"], "cprops")
			J.mc(_t4086, "push", [{"k": "pipeK", "node": J.gp(J.gp(v_ds_3628, 0.0), "did"), "f": _s1458["f"], "t": 0.0, "cd": 0.0}])
		if J.t(J.gp(v_ds_3628, 1.0)):
			var _t4087 = J.gp(_s1458["__p"]["G"], "cprops")
			J.mc(_t4087, "push", [{"k": "light", "node": J.gp(J.gp(v_ds_3628, 1.0), "did"), "f": _s1458["f"], "t": 0.0, "cd": 0.0}])
		_s1458["f"] = J.num(_s1458["f"]) + 1.0
	var _t4088 = _s1458["__p"]["G"]
	var _t4089 = []
	J.sp(_t4088, "quests", _t4089)
	var _t4090 = J.gp(_s1458["__p"]["G"], "units")
	v_olds_3629 = J.mc(_t4090, "filter", [Callable(self, "_f618").bind(_s1458)])
	if (not J.t(J.len(v_olds_3629))):
		var _t4094 = J.gp(_s1458["__p"]["G"], "units")
		var _t4096 = J.mc(_t4094, "filter", [Callable(self, "_f619").bind(_s1458)])
		v_olds_3629 = _t4096
	if J.t(J.len(v_olds_3629)):
		var _t4097 = _s1458["__p"]["pick"]
		_s1458["ow"] = J.cl(_t4097, null, [v_olds_3629])
		var _t4098 = _s1458["__p"]["pick"]
		v_thing_3631 = J.cl(_t4098, null, [["老花鏡", "假牙", "結婚戒指", "錢罌"]])
		var _t4099 = _s1458["__p"]["shuffle"]
		v_hid_3632 = J.gp(J.cl(_t4099, null, [J.mc(_s1458["cand"], "filter", [Callable(self, "_f620").bind(_s1458)])]), 0.0)
		if J.t(v_hid_3632):
			var _t4101 = J.gp(v_hid_3632, "items")
			J.mc(_t4101, "unshift", ["lost"])
			var _t4102 = J.gp(_s1458["__p"]["G"], "quests")
			J.mc(_t4102, "push", [{"id": "lost", "t": J.add((J.add(J.add("搵返", J.gp(_s1458["__p"]["FLN"], J.gp(_s1458["ow"], "f"))), J.mc(_s1458["__p"]["LV0K"], "who", [_s1458["ow"]])) + "嘅"), v_thing_3631), "thing": v_thing_3631, "owner": _s1458["ow"], "hid": v_hid_3632, "state": 0.0}])
			var _t4103 = _s1458["ow"]
			J.sp(_t4103, "questMark", 1.0)
	var _t4104 = J.gp(_s1458["__p"]["G"], "units")
	v_dbt_3633 = J.mc(_t4104, "find", [Callable(self, "_f621").bind(_s1458)])
	if J.t(v_dbt_3633):
		var _t4105 = J.gp(_s1458["__p"]["G"], "quests")
		J.mc(_t4105, "push", [{"id": "debt", "t": (J.add("嚇走", J.gp(_s1458["__p"]["FLN"], J.gp(v_dbt_3633, "f"))) + "拍門嘅收數佬"), "unit": v_dbt_3633, "state": 0.0, "at": (30.0 + J.mul(J.cl(_s1458["__p"]["rnd"], null, []), 25.0))}])
	var _t4106 = J.gp(_s1458["__p"]["G"], "units")
	v_mj_3634 = J.mc(_t4106, "find", [Callable(self, "_f622").bind(_s1458)])
	if J.t(v_mj_3634):
		var _t4107 = J.gp(_s1458["__p"]["G"], "quests")
		J.mc(_t4107, "push", [{"id": "mj", "t": (J.add("散咗", J.gp(_s1458["__p"]["FLN"], J.gp(v_mj_3634, "f"))) + "嘅麻雀局（四個都嚇走）"), "unit": v_mj_3634, "state": 0.0}])
	var _t4108 = _s1458["__p"]["G"]
	var _t4109 = []
	J.sp(_t4108, "relief", _t4109)
	var _t4110 = _s1458["__p"]["G"]
	J.sp(_t4110, "alertAcc", 0.0)

func _f625(this_, a: Array, env):
	var v_r_3759 = null; var v_dx_3760 = null; var v_dy_3761 = null; var v_dw_3762 = null; var v_dh_3763 = null; var v_flip_3764 = null; var v_dark_3765 = null
	v_r_3759 = J.arg(a, 0)
	v_dx_3760 = J.arg(a, 1)
	v_dy_3761 = J.arg(a, 2)
	v_dw_3762 = J.arg(a, 3)
	v_dh_3763 = J.arg(a, 4)
	v_flip_3764 = J.arg(a, 5)
	v_dark_3765 = J.arg(a, 6)
	var _t4111 = (not J.t(env["img"]))
	if (_t4111 if _t4111 else (not J.t(J.gp(env["img"], "width")))):
		var _t4112 = env["c"]
		J.sp(_t4112, "fillStyle", "#222")
		J.mc(env["c"], "fillRect", [v_dx_3760, v_dy_3761, v_dw_3762, v_dh_3763])
		return null
	J.mc(env["c"], "save", [])
	if J.t((v_flip_3764 if J.t(v_flip_3764) else J.gp(v_r_3759, 4.0))):
		J.mc(env["c"], "translate", [J.add(v_dx_3760, v_dw_3762), v_dy_3761])
		J.mc(env["c"], "scale", [(-1.0), 1.0])
		v_dx_3760 = 0.0
		v_dy_3761 = 0.0
	J.mc(env["c"], "drawImage", [env["img"], J.mul(J.gp(v_r_3759, 0.0), env["k"]), J.mul(J.gp(v_r_3759, 2.0), env["k"]), J.mul(J.sub(J.gp(v_r_3759, 1.0), J.gp(v_r_3759, 0.0)), env["k"]), J.mul(J.sub(J.gp(v_r_3759, 3.0), J.gp(v_r_3759, 2.0)), env["k"]), v_dx_3760, v_dy_3761, v_dw_3762, v_dh_3763])
	J.mc(env["c"], "restore", [])
	if J.t(v_dark_3765):
		var _t4113 = env["c"]
		J.sp(_t4113, "fillStyle", v_dark_3765)
		J.mc(env["c"], "fillRect", [(v_dx_3760 if J.t((v_flip_3764 if J.t(v_flip_3764) else J.gp(v_r_3759, 4.0))) else v_dx_3760), v_dy_3761, v_dw_3762, v_dh_3763])

func _f627(this_, a: Array, env):
	var v_k_3807 = null; var v_im_3808 = null
	v_k_3807 = J.arg(a, 0)
	var _t4114 = J.gp(env["__p"]["__p"]["IMG"], J.add("twt_", v_k_3807))
	v_im_3808 = (_t4114 if J.t(_t4114) else (J.gp(J.G.get("SPR"), J.add("twt_", v_k_3807)) if (not J.seq(J.typeof_(J.G.get("SPR")), "undefined")) else null))
	var _t4116 = v_im_3808
	if J.t(_t4116):
		var _t4115 = J.gp(v_im_3808, "naturalWidth")
		_t4116 = (_t4115 if J.t(_t4115) else J.gp(v_im_3808, "width"))
	return (v_im_3808 if J.t(_t4116) else null)

func _f629(this_, a: Array, env):
	var v_a_3814 = null; var v_b_3815 = null; var v_d_3816 = null; var v_h_3817 = null
	v_a_3814 = J.arg(a, 0)
	v_b_3815 = J.arg(a, 1)
	v_d_3816 = J.arg(a, 2)
	v_h_3817 = J.bxor(J.bxor(J.math("imul", [J.add(v_a_3814, 1.0), 73856093.0]), J.math("imul", [J.add(v_b_3815, 7.0), 19349663.0])), J.math("imul", [J.add(v_d_3816, 3.0), 83492791.0]))
	var _t4117 = J.math("imul", [J.bxor(v_h_3817, J.ushr(v_h_3817, 13.0)), 1274126177.0])
	v_h_3817 = _t4117
	return J.ushr(J.bxor(v_h_3817, J.ushr(v_h_3817, 16.0)), 0.0)

func _f630(this_, a: Array, env):
	var v_k_3820 = null; var v_sx0_3821 = null; var v_sx1_3822 = null; var v_sy0_3823 = null; var v_x0_3824 = null; var v_w_3825 = null; var v_top_3826 = null; var v_floor_3827 = null; var v_flip_3828 = null; var v_tint_3829 = null; var v_im_3830 = null; var v_q_3831 = null; var v_s_3832 = null; var v_h_3833 = null
	v_k_3820 = J.arg(a, 0)
	v_sx0_3821 = J.arg(a, 1)
	v_sx1_3822 = J.arg(a, 2)
	v_sy0_3823 = J.arg(a, 3)
	v_x0_3824 = J.arg(a, 4)
	v_w_3825 = J.arg(a, 5)
	v_top_3826 = J.arg(a, 6)
	v_floor_3827 = J.arg(a, 7)
	v_flip_3828 = J.arg(a, 8)
	v_tint_3829 = J.arg(a, 9)
	v_im_3830 = J.gp(env["T"], v_k_3820)
	var _t4118 = J.gp(v_im_3830, "naturalWidth")
	v_q_3831 = J.div((_t4118 if J.t(_t4118) else J.gp(v_im_3830, "width")), env["N"])
	v_s_3832 = J.div(J.sub(v_floor_3827, v_top_3826), J.sub(J.gp(env["FLY"], v_k_3820), v_sy0_3823))
	v_h_3833 = J.mul(J.sub(env["N"], v_sy0_3823), v_s_3832)
	J.mc(env["__p"]["c"], "save", [])
	if J.t(v_flip_3828):
		J.mc(env["__p"]["c"], "translate", [J.add(v_x0_3824, v_w_3825), 0.0])
		J.mc(env["__p"]["c"], "scale", [(-1.0), 1.0])
		J.mc(env["__p"]["c"], "drawImage", [v_im_3830, J.mul(v_sx0_3821, v_q_3831), J.mul(v_sy0_3823, v_q_3831), J.mul(J.sub(v_sx1_3822, v_sx0_3821), v_q_3831), J.mul(J.sub(env["N"], v_sy0_3823), v_q_3831), 0.0, v_top_3826, v_w_3825, v_h_3833])
	else:
		J.mc(env["__p"]["c"], "drawImage", [v_im_3830, J.mul(v_sx0_3821, v_q_3831), J.mul(v_sy0_3823, v_q_3831), J.mul(J.sub(v_sx1_3822, v_sx0_3821), v_q_3831), J.mul(J.sub(env["N"], v_sy0_3823), v_q_3831), v_x0_3824, v_top_3826, v_w_3825, v_h_3833])
	J.mc(env["__p"]["c"], "restore", [])
	if J.t(v_tint_3829):
		var _t4119 = env["__p"]["c"]
		J.sp(_t4119, "fillStyle", v_tint_3829)
		J.mc(env["__p"]["c"], "fillRect", [v_x0_3824, v_top_3826, v_w_3825, v_h_3833])

func _f628(this_, a: Array, env):
	var v_k_3811 = null
	v_k_3811 = J.arg(a, 0)
	var _t4121 = env["T"]
	var _t4122 = env["TI"]
	var _t4123 = J.cl(_t4122, null, [v_k_3811])
	J.sp(_t4121, v_k_3811, _t4123)
	if (not J.t(J.gp(env["T"], v_k_3811))):
		env["ok"] = false

func _f632(this_, a: Array, env):
	var v_q_3856 = null
	v_q_3856 = J.arg(a, 0)
	var _t4139 = J.seq(J.gp(v_q_3856, "f"), env["__p"]["f"])
	return (J.seq(J.gp(J.gp(v_q_3856, "rx"), 0.0), env["x0"]) if _t4139 else _t4139)

func _f631(this_, a: Array, env):
	var v_col_3836 = null; var v_ci_3837 = null; var v_w_3839 = null; var v_kd_3840 = null; var v_h0_3841 = null; var v_tn_3842 = null; var v_up_3843 = null; var v_un_3844 = null; var v_deity_3845 = null; var v_rk_3846 = null; var v_ri_3847 = null; var v_r_3848 = null; var v_two_3849 = null; var v_dx_3850 = null; var v_p_3851 = null; var v_px_3852 = null; var v_py_3853 = null
	var _s1513 = {"__p": env, "x0": null}
	v_col_3836 = J.arg(a, 0)
	v_ci_3837 = J.arg(a, 1)
	_s1513["x0"] = J.gp(v_col_3836, 0.0)
	v_w_3839 = J.sub(J.gp(v_col_3836, 1.0), J.gp(v_col_3836, 0.0))
	v_kd_3840 = J.gp(v_col_3836, 2.0)
	var _t4128 = _s1513["__p"]["hs"]
	v_h0_3841 = J.cl(_t4128, null, [_s1513["__p"]["KK"], _s1513["__p"]["f"], v_ci_3837])
	v_tn_3842 = (_s1513["__p"]["BT"] if J.seq(_s1513["__p"]["f"], 0.0) else null)
	var _t4129 = J.seq(v_kd_3840, "stair")
	var _t4131 = (_t4129 if _t4129 else J.seq(v_kd_3840, "back"))
	if not J.t(_t4131):
		var _t4130 = J.seq(v_kd_3840, "lift")
		_t4131 = ((not J.t(J.gp(_s1513["__p"]["__p"]["__p"]["LV"], "lift"))) if _t4130 else _t4130)
	if _t4131:
		var _t4132 = J.seq(v_kd_3840, "back")
		var _t4133 = (J.seq(_s1513["__p"]["f"], 0.0) if _t4132 else _t4132)
		if ((not J.t(J.gp(J.gp(_s1513["__p"]["__p"]["__p"]["G"], "nodes"), "f0_b"))) if _t4133 else _t4133):
			var _t4134 = _s1513["__p"]["tile"]
			J.cl(_t4134, null, ["carpark", 296.0, _s1513["__p"]["N"], 0.0, _s1513["x0"], v_w_3839, _s1513["__p"]["top"], _s1513["__p"]["floor"], false, "rgba(10,20,40,0.16)"])
			return null
		v_up_3843 = ("R" if J.seq(v_kd_3840, "stair") else ("L" if J.seq(v_kd_3840, "back") else ("L" if J.t(J.mod(_s1513["__p"]["f"], 2.0)) else "R")))
		if J.seq(v_up_3843, "R"):
			var _t4135 = _s1513["__p"]["tile"]
			J.cl(_t4135, null, ["stairR", 62.0, _s1513["__p"]["N"], 0.0, _s1513["x0"], v_w_3839, _s1513["__p"]["top"], _s1513["__p"]["floor"], false, v_tn_3842])
		else:
			var _t4136 = _s1513["__p"]["tile"]
			J.cl(_t4136, null, ["stairL", 0.0, 354.0, 0.0, _s1513["x0"], v_w_3839, _s1513["__p"]["top"], _s1513["__p"]["floor"], false, v_tn_3842])
		return null
	if J.seq(v_kd_3840, "lift"):
		var _t4137 = _s1513["__p"]["tile"]
		J.cl(_t4137, null, ["lift", 58.0, 360.0, (0.0 if J.seq(_s1513["__p"]["f"], J.sub(_s1513["__p"]["__p"]["__p"]["FL"], 1.0)) else 46.0), _s1513["x0"], v_w_3839, _s1513["__p"]["top"], _s1513["__p"]["floor"], false, v_tn_3842])
		return null
	var _t4138 = J.gp(_s1513["__p"]["__p"]["__p"]["G"], "units")
	v_un_3844 = J.mc(_t4138, "find", [Callable(self, "_f632").bind(_s1513)])
	v_deity_3845 = (J.seq(J.gp(v_un_3844, "ot"), "deity") if J.t(v_un_3844) else v_un_3844)
	var _t4140 = ((not J.t(v_deity_3845)) if J.t(v_un_3844) else v_un_3844)
	v_rk_3846 = (J.gp(_s1513["__p"]["RM"], J.gp(v_un_3844, "hh")) if J.t((J.cmp(_s1513["__p"]["f"], 1.0, ">=") if J.t(_t4140) else _t4140)) else null)
	v_ri_3847 = (J.gp(_s1513["__p"]["__p"]["__p"]["IMG"], v_rk_3846) if J.t(v_rk_3846) else v_rk_3846)
	if J.seq(_s1513["__p"]["f"], 0.0):
		var _t4141 = _s1513["__p"]["tile"]
		J.cl(_t4141, null, ["carpark", 0.0, _s1513["__p"]["N"], 0.0, _s1513["x0"], v_w_3839, _s1513["__p"]["top"], _s1513["__p"]["floor"], J.band(J.ushr(v_h0_3841, 5.0), 1.0), "rgba(10,20,40,0.16)"])
		_s1513["__p"]["c2prev"] = false
		return null
	if J.t((J.gp(v_ri_3847, "width") if J.t(v_ri_3847) else v_ri_3847)):
		J.mc(_s1513["__p"]["__p"]["c"], "save", [])
		if J.seq(J.mod(J.add(v_ci_3837, _s1513["__p"]["f"]), 2.0), 1.0):
			J.mc(_s1513["__p"]["__p"]["c"], "translate", [J.add(_s1513["x0"], v_w_3839), _s1513["__p"]["top"]])
			J.mc(_s1513["__p"]["__p"]["c"], "scale", [(-1.0), 1.0])
			J.mc(_s1513["__p"]["__p"]["c"], "drawImage", [v_ri_3847, 0.0, 0.0, v_w_3839, _s1513["__p"]["hgt"]])
		else:
			J.mc(_s1513["__p"]["__p"]["c"], "drawImage", [v_ri_3847, _s1513["x0"], _s1513["__p"]["top"], v_w_3839, _s1513["__p"]["hgt"]])
		J.mc(_s1513["__p"]["__p"]["c"], "restore", [])
		var _t4142 = _s1513["__p"]["__p"]["c"]
		J.sp(_t4142, "strokeStyle", "rgba(0,0,0,0.6)")
		var _t4143 = _s1513["__p"]["__p"]["c"]
		J.sp(_t4143, "lineWidth", 3.0)
		J.mc(_s1513["__p"]["__p"]["c"], "strokeRect", [J.add(_s1513["x0"], 1.0), J.add(_s1513["__p"]["top"], 1.0), J.sub(v_w_3839, 2.0), J.sub(_s1513["__p"]["hgt"], 2.0)])
		_s1513["__p"]["c2prev"] = false
		return null
	if J.t(_s1513["__p"]["SHOP"]):
		var _t4147 = null
		if J.t(v_deity_3845):
			_t4147 = J.gp(J.gp(J.gp(_s1513["__p"]["__p"]["B"], "src"), "deity"), 0.0)
		else:
			var _t4146 = null
			if J.seq(_s1513["__p"]["f"], 1.0):
				_t4146 = J.gp(_s1513["__p"]["gPool"], J.mod(J.add(v_ci_3837, _s1513["__p"]["f"]), J.len(_s1513["__p"]["gPool"])))
			else:
				var _t4145 = _s1513["__p"]["resPool"]
				var _t4144 = J.num(_s1513["__p"]["ui"])
				_s1513["__p"]["ui"] = _t4144 + 1.0
				_t4146 = J.gp(_t4145, J.mod(J.add((_t4144 * 5.0), _s1513["__p"]["f"]), J.len(_s1513["__p"]["resPool"])))
			_t4147 = _t4146
		v_r_3848 = _t4147
		var _t4148 = _s1513["__p"]["__p"]["put"]
		J.cl(_t4148, null, [v_r_3848, _s1513["x0"], _s1513["__p"]["top"], v_w_3839, _s1513["__p"]["hgt"], J.seq(J.mod(J.add(v_ci_3837, _s1513["__p"]["f"]), 2.0), 1.0), null])
		return null
	if J.seq(_s1513["__p"]["f"], 1.0):
		var _t4149 = _s1513["__p"]["tile"]
		J.cl(_t4149, null, ["lobby", 0.0, _s1513["__p"]["N"], 0.0, _s1513["x0"], v_w_3839, _s1513["__p"]["top"], _s1513["__p"]["floor"], J.seq(J.mod(v_ci_3837, 2.0), 1.0), null])
		return null
	var _t4150 = (not J.t(v_deity_3845))
	var _t4151 = ((not J.t(_s1513["__p"]["c2prev"])) if _t4150 else _t4150)
	v_two_3849 = ((J.mod(v_h0_3841, 100.0) < 40.0) if _t4151 else _t4151)
	_s1513["__p"]["c2prev"] = v_two_3849
	if J.t(v_two_3849):
		var _t4152 = _s1513["__p"]["tile"]
		J.cl(_t4152, null, ["corr2", 0.0, _s1513["__p"]["N"], 0.0, _s1513["x0"], v_w_3839, _s1513["__p"]["top"], _s1513["__p"]["floor"], J.band(J.ushr(v_h0_3841, 7.0), 1.0), null])
	else:
		var _t4153 = _s1513["__p"]["tile"]
		J.cl(_t4153, null, ["corr1", 0.0, _s1513["__p"]["N"], 0.0, _s1513["x0"], v_w_3839, _s1513["__p"]["top"], _s1513["__p"]["floor"], (J.seq(J.mod(J.gp(v_un_3844, "u"), 2.0), 0.0) if J.t(v_un_3844) else J.band(J.ushr(v_h0_3841, 7.0), 1.0)), null])
		if J.t(v_deity_3845):
			var _t4154 = _s1513["__p"]["__p"]["c"]
			J.sp(_t4154, "fillStyle", "rgba(110,8,8,0.20)")
			J.mc(_s1513["__p"]["__p"]["c"], "fillRect", [_s1513["x0"], _s1513["__p"]["top"], v_w_3839, J.sub(_s1513["__p"]["floor"], _s1513["__p"]["top"])])
			v_dx_3850 = J.gp(v_un_3844, "x")
			v_p_3851 = 0.0
			while true:
				if not J.cmp(v_p_3851, 7.0, "<"): break
				v_px_3852 = (J.sub(v_dx_3850, 15.0) + (J.band(J.ushr(v_h0_3841, J.mul(v_p_3851, 3.0)), 7.0) * 4.3))
				var _t4155 = _s1513["__p"]["__p"]["__p"]["fy"]
				v_py_3853 = ((J.sub(J.cl(_t4155, null, [_s1513["__p"]["f"]]), 92.0) + (J.band(J.ushr(v_h0_3841, (J.mul(v_p_3851, 2.0) + 5.0)), 7.0) * 9.0)) + J.mul(v_p_3851, 3.0))
				J.mc(_s1513["__p"]["__p"]["c"], "save", [])
				J.mc(_s1513["__p"]["__p"]["c"], "translate", [v_px_3852, v_py_3853])
				J.mc(_s1513["__p"]["__p"]["c"], "rotate", [((J.band(J.ushr(v_h0_3841, J.add(v_p_3851, 9.0)), 7.0) - 3.5) * 0.05)])
				var _t4156 = _s1513["__p"]["__p"]["c"]
				var _t4157 = ("#9e1e1a" if J.t(J.mod(v_p_3851, 3.0)) else "#c0281f")
				J.sp(_t4156, "fillStyle", _t4157)
				J.mc(_s1513["__p"]["__p"]["c"], "fillRect", [(-4.5), (-10.0), 9.0, 20.0])
				var _t4158 = _s1513["__p"]["__p"]["c"]
				J.sp(_t4158, "fillStyle", "rgba(30,0,0,0.35)")
				J.mc(_s1513["__p"]["__p"]["c"], "fillRect", [2.5, (-10.0), 2.0, 20.0])
				var _t4159 = _s1513["__p"]["__p"]["c"]
				J.sp(_t4159, "fillStyle", "rgba(240,200,90,0.6)")
				J.mc(_s1513["__p"]["__p"]["c"], "fillRect", [(-2.0), (-6.0), 4.0, 1.4])
				J.mc(_s1513["__p"]["__p"]["c"], "fillRect", [(-2.0), (-1.0), 4.0, 1.4])
				J.mc(_s1513["__p"]["__p"]["c"], "fillRect", [(-2.0), 4.0, 4.0, 1.4])
				J.mc(_s1513["__p"]["__p"]["c"], "restore", [])
				v_p_3851 = J.num(v_p_3851) + 1.0

func _f633(this_, a: Array, env):
	var v_col_3859 = null; var v_ci_3860 = null; var v_xb_3861 = null; var v_g_3862 = null
	v_col_3859 = J.arg(a, 0)
	v_ci_3860 = J.arg(a, 1)
	if (not J.t(v_ci_3860)):
		return null
	v_xb_3861 = J.gp(v_col_3859, 0.0)
	v_g_3862 = J.mc(env["__p"]["c"], "createLinearGradient", [J.sub(v_xb_3861, 8.0), 0.0, J.add(v_xb_3861, 8.0), 0.0])
	J.mc(v_g_3862, "addColorStop", [0.0, "rgba(0,0,0,0)"])
	J.mc(v_g_3862, "addColorStop", [0.5, "rgba(0,0,0,0.58)"])
	J.mc(v_g_3862, "addColorStop", [1.0, "rgba(0,0,0,0)"])
	var _t4171 = env["__p"]["c"]
	J.sp(_t4171, "fillStyle", v_g_3862)
	J.mc(env["__p"]["c"], "fillRect", [J.sub(v_xb_3861, 8.0), env["top"], 16.0, J.sub(env["floor"], env["top"])])

func _f634(this_, a: Array, env):
	var v_e_3865 = null; var v_g_3866 = null
	v_e_3865 = J.arg(a, 0)
	v_g_3866 = J.mc(env["__p"]["c"], "createLinearGradient", [J.gp(v_e_3865, 0.0), 0.0, J.add(J.gp(v_e_3865, 0.0), J.mul(J.gp(v_e_3865, 1.0), 28.0)), 0.0])
	J.mc(v_g_3866, "addColorStop", [0.0, "rgba(0,0,0,0.55)"])
	J.mc(v_g_3866, "addColorStop", [1.0, "rgba(0,0,0,0)"])
	var _t4175 = env["__p"]["c"]
	J.sp(_t4175, "fillStyle", v_g_3866)
	J.mc(env["__p"]["c"], "fillRect", [(0.0 if J.cmp(J.gp(v_e_3865, 1.0), 0.0, ">") else J.sub(env["__p"]["__p"]["WW"], 28.0)), 0.0, 28.0, env["__p"]["__p"]["WH"]])

func _f626(this_, a: Array, env):
	var v_bot_3782 = null; var v_rs_3785 = null; var v_rh_3786 = null; var v_rtop_3787 = null; var v_x_3788 = null; var v_i_3789 = null; var v_F_3790 = null; var v_im_3791 = null; var v_q_3792 = null; var v_A_3793 = null; var v_sx1_3794 = null; var v_w_3795 = null; var v_flip_3796 = null; var v_oc_3797 = null; var v_ox_3798 = null; var v_gr_3799 = null; var v_yb_3800 = null; var v_g_3801 = null
	var _s1504 = {"__p": env, "T": null, "ok": null, "N": null, "FLY": null, "KK": null, "SHOP": null, "BT": null, "RM": null, "resPool": null, "gPool": null, "ui": null, "f": null, "top": null, "floor": null, "hgt": null, "c2prev": null, "TI": null, "hs": null, "tile": null}
	_s1504["TI"] = Callable(self, "_f627").bind(_s1504)
	_s1504["hs"] = Callable(self, "_f629").bind(_s1504)
	_s1504["tile"] = Callable(self, "_f630").bind(_s1504)
	_s1504["T"] = {}
	_s1504["ok"] = true
	var _t4120 = ["corr1", "corr2", "stairR", "stairL", "lift", "roof", "lobby", "carpark"]
	J.mc(_t4120, "forEach", [Callable(self, "_f628").bind(_s1504)])
	if (not J.t(_s1504["ok"])):
		return false
	_s1504["N"] = 416.0
	_s1504["FLY"] = {"corr1": 400.0, "corr2": 400.0, "stairR": 398.0, "stairL": 398.0, "lift": 403.0, "roof": 402.0, "lobby": 405.0, "carpark": 405.0}
	_s1504["KK"] = (2.0 if J.seq(J.gp(_s1504["__p"]["__p"]["LV"], "key"), "shop") else 1.0)
	_s1504["SHOP"] = J.seq(J.gp(_s1504["__p"]["__p"]["LV"], "key"), "shop")
	_s1504["BT"] = "rgba(10,20,40,0.34)"
	_s1504["RM"] = {"mahjong": "room_mahjong", "gamer": "room_gamer", "nurse": "room_nurse", "helper": "room_helper", "gym": "room_gym", "shopper": "room_shopper"}
	_s1504["resPool"] = J.gp(J.gp(_s1504["__p"]["B"], "src"), "res")
	_s1504["gPool"] = J.gp(J.gp(_s1504["__p"]["B"], "src"), "ground")
	_s1504["ui"] = 0.0
	_s1504["f"] = 0.0
	while true:
		if not J.cmp(_s1504["f"], _s1504["__p"]["__p"]["FL"], "<"): break
		var _t4124 = _s1504["__p"]["__p"]["fy"]
		_s1504["top"] = J.cl(_t4124, null, [J.add(_s1504["f"], 1.0)])
		var _t4125 = _s1504["__p"]["__p"]["fy"]
		_s1504["floor"] = J.add(J.cl(_t4125, null, [_s1504["f"]]), 3.0)
		var _t4126 = _s1504["__p"]["__p"]["fy"]
		v_bot_3782 = J.add(J.cl(_t4126, null, [_s1504["f"]]), 12.0)
		_s1504["hgt"] = J.sub(v_bot_3782, _s1504["top"])
		_s1504["c2prev"] = false
		var _t4127 = J.gp(_s1504["__p"]["__p"]["LV"], "xs")
		J.mc(_t4127, "forEach", [Callable(self, "_f631").bind(_s1504)])
		_s1504["f"] = J.num(_s1504["f"]) + 1.0
	var _t4160 = _s1504["__p"]["__p"]["fy"]
	v_rs_3785 = J.div(J.add(J.add(J.cl(_t4160, null, [_s1504["__p"]["__p"]["FL"]]), 3.0), 8.0), J.gp(_s1504["FLY"], "roof"))
	v_rh_3786 = J.mul(_s1504["N"], v_rs_3785)
	var _t4161 = _s1504["__p"]["__p"]["fy"]
	v_rtop_3787 = J.sub(J.add(J.cl(_t4161, null, [_s1504["__p"]["__p"]["FL"]]), 3.0), J.mul(J.gp(_s1504["FLY"], "roof"), v_rs_3785))
	v_x_3788 = 0.0
	v_i_3789 = 0.0
	v_F_3790 = 30.0
	v_im_3791 = J.gp(_s1504["T"], "roof")
	var _t4162 = J.gp(v_im_3791, "naturalWidth")
	v_q_3792 = J.div((_t4162 if J.t(_t4162) else J.gp(v_im_3791, "width")), _s1504["N"])
	while true:
		if not J.cmp(v_x_3788, _s1504["__p"]["__p"]["WW"], "<"): break
		v_A_3793 = J.seq(J.mod(v_i_3789, 2.0), 1.0)
		v_sx1_3794 = (196.0 if J.t(v_A_3793) else _s1504["N"])
		v_w_3795 = J.mul(v_sx1_3794, v_rs_3785)
		var _t4164 = null
		if J.t(v_A_3793):
			var _t4163 = _s1504["hs"]
			_t4164 = J.band(J.ushr(J.cl(_t4163, null, [_s1504["KK"], 99.0, v_i_3789]), 3.0), 1.0)
		else:
			_t4164 = J.seq(J.mod(J.shr(v_i_3789, 1.0), 2.0), 1.0)
		v_flip_3796 = _t4164
		v_oc_3797 = J.S_document_("createElement", ["canvas"])
		var _t4165 = J.max_([1.0, ceil(J.num(J.mul(v_w_3795, _s1504["__p"]["SC"])))])
		J.sp(v_oc_3797, "width", _t4165)
		var _t4166 = J.max_([1.0, ceil(J.num(J.mul(v_rh_3786, _s1504["__p"]["SC"])))])
		J.sp(v_oc_3797, "height", _t4166)
		v_ox_3798 = J.mc(v_oc_3797, "getContext", ["2d"])
		if J.t(v_flip_3796):
			J.mc(v_ox_3798, "translate", [J.gp(v_oc_3797, "width"), 0.0])
			J.mc(v_ox_3798, "scale", [(-1.0), 1.0])
		J.mc(v_ox_3798, "drawImage", [v_im_3791, 0.0, 0.0, J.mul(v_sx1_3794, v_q_3792), J.mul(_s1504["N"], v_q_3792), 0.0, 0.0, J.gp(v_oc_3797, "width"), J.gp(v_oc_3797, "height")])
		J.mc(v_ox_3798, "setTransform", [1.0, 0.0, 0.0, 1.0, 0.0, 0.0])
		if J.cmp(v_i_3789, 0.0, ">"):
			J.sp(v_ox_3798, "globalCompositeOperation", "destination-in")
			v_gr_3799 = J.mc(v_ox_3798, "createLinearGradient", [0.0, 0.0, J.mul(v_F_3790, _s1504["__p"]["SC"]), 0.0])
			J.mc(v_gr_3799, "addColorStop", [0.0, "rgba(0,0,0,0)"])
			J.mc(v_gr_3799, "addColorStop", [1.0, "rgba(0,0,0,1)"])
			J.sp(v_ox_3798, "fillStyle", v_gr_3799)
			J.mc(v_ox_3798, "fillRect", [0.0, 0.0, J.gp(v_oc_3797, "width"), J.gp(v_oc_3797, "height")])
		J.mc(_s1504["__p"]["c"], "drawImage", [v_oc_3797, v_x_3788, v_rtop_3787, v_w_3795, v_rh_3786])
		var _t4167 = J.add(v_x_3788, J.sub(v_w_3795, v_F_3790))
		v_x_3788 = _t4167
		v_i_3789 = J.num(v_i_3789) + 1.0
	_s1504["f"] = 0.0
	while true:
		if not J.cmp(_s1504["f"], _s1504["__p"]["__p"]["FL"], "<"): break
		var _t4168 = _s1504["__p"]["__p"]["fy"]
		_s1504["top"] = J.cl(_t4168, null, [J.add(_s1504["f"], 1.0)])
		var _t4169 = _s1504["__p"]["__p"]["fy"]
		_s1504["floor"] = J.add(J.cl(_t4169, null, [_s1504["f"]]), 10.0)
		var _t4170 = J.gp(_s1504["__p"]["__p"]["LV"], "xs")
		J.mc(_t4170, "forEach", [Callable(self, "_f633").bind(_s1504)])
		_s1504["f"] = J.num(_s1504["f"]) + 1.0
	_s1504["f"] = 0.0
	while true:
		if not J.cmp(_s1504["f"], _s1504["__p"]["__p"]["FL"], "<="): break
		var _t4172 = _s1504["__p"]["__p"]["fy"]
		v_yb_3800 = J.add(J.cl(_t4172, null, [_s1504["f"]]), 3.0)
		v_g_3801 = J.mc(_s1504["__p"]["c"], "createLinearGradient", [0.0, v_yb_3800, 0.0, J.add(v_yb_3800, 26.0)])
		J.mc(v_g_3801, "addColorStop", [0.0, "rgba(0,0,0,0)"])
		J.mc(v_g_3801, "addColorStop", [0.28, "rgba(0,0,0,0.5)"])
		J.mc(v_g_3801, "addColorStop", [1.0, "rgba(0,0,0,0)"])
		if J.cmp(_s1504["f"], 0.0, ">"):
			var _t4173 = _s1504["__p"]["c"]
			J.sp(_t4173, "fillStyle", v_g_3801)
			J.mc(_s1504["__p"]["c"], "fillRect", [0.0, v_yb_3800, _s1504["__p"]["__p"]["WW"], 26.0])
		_s1504["f"] = J.num(_s1504["f"]) + 1.0
	var _t4174 = [[0.0, 1.0], [_s1504["__p"]["__p"]["WW"], (-1.0)]]
	J.mc(_t4174, "forEach", [Callable(self, "_f634").bind(_s1504)])
	return true

func _f635(this_, a: Array, env):
	return (J.mc(env["__p"]["staticCv"], "toDataURL", ["image/png"]) if J.t(env["__p"]["staticCv"]) else null)

func _f636(this_, a: Array, env):
	var v_x_3871 = null; var v_y_3872 = null
	v_x_3871 = J.arg(a, 0)
	v_y_3872 = J.arg(a, 1)
	var _t4189 = env["__p"]["cam"]
	var _t4190 = (null if J.leq(v_x_3871, null) else {"x": v_x_3871, "y": v_y_3872})
	J.sp(_t4189, "free", _t4190)

func _f638(this_, a: Array, env):
	var v_q_3886 = null
	v_q_3886 = J.arg(a, 0)
	var _t4204 = J.seq(J.gp(v_q_3886, "f"), env["__p"]["f"])
	return (J.seq(J.gp(J.gp(v_q_3886, "rx"), 0.0), env["x0"]) if _t4204 else _t4204)

func _f637(this_, a: Array, env):
	var v_col_3875 = null; var v_ci_3876 = null; var v_w_3878 = null; var v_un_3879 = null; var v_r_3880 = null; var v_RM_3881 = null; var v_rk_3882 = null; var v_ri_3883 = null
	var _s1542 = {"__p": env, "x0": null}
	v_col_3875 = J.arg(a, 0)
	v_ci_3876 = J.arg(a, 1)
	_s1542["x0"] = J.gp(v_col_3875, 0.0)
	v_w_3878 = J.sub(J.gp(v_col_3875, 1.0), J.gp(v_col_3875, 0.0))
	if J.seq(J.gp(v_col_3875, 2.0), "stair"):
		var _t4195 = _s1542["__p"]["put"]
		J.cl(_t4195, null, [(J.gp(J.gp(_s1542["__p"]["B"], "src"), "gstair") if J.cmp(_s1542["__p"]["f"], 1.0, "<=") else J.gp(J.gp(_s1542["__p"]["B"], "src"), "stair")), _s1542["x0"], _s1542["__p"]["top"], v_w_3878, _s1542["__p"]["hgt"], false, _s1542["__p"]["dark"]])
	else:
		if J.seq(J.gp(v_col_3875, 2.0), "lift"):
			var _t4196 = _s1542["__p"]["put"]
			J.cl(_t4196, null, [(J.gp(J.gp(_s1542["__p"]["B"], "src"), "glift") if J.cmp(_s1542["__p"]["f"], 1.0, "<=") else J.gp(J.gp(_s1542["__p"]["B"], "src"), "lift")), _s1542["x0"], _s1542["__p"]["top"], v_w_3878, _s1542["__p"]["hgt"], false, _s1542["__p"]["dark"]])
		else:
			if J.seq(J.gp(v_col_3875, 2.0), "back"):
				var _t4197 = _s1542["__p"]["put"]
				var _t4199 = J.gp(J.gp(_s1542["__p"]["B"], "src"), "back")
				var _t4200 = _s1542["x0"]
				var _t4201 = _s1542["__p"]["top"]
				var _t4202 = _s1542["__p"]["hgt"]
				var _t4198 = (not J.t(J.gp(J.gp(J.gp(_s1542["__p"]["B"], "src"), "back"), 4.0)))
				J.cl(_t4197, null, [_t4199, _t4200, _t4201, v_w_3878, _t4202, (J.seq(J.gp(_s1542["__p"]["__p"]["LV"], "key"), "flat") if _t4198 else _t4198), _s1542["__p"]["dark"]])
			else:
				var _t4203 = J.gp(_s1542["__p"]["__p"]["G"], "units")
				v_un_3879 = J.mc(_t4203, "find", [Callable(self, "_f638").bind(_s1542)])
				v_RM_3881 = {"mahjong": "room_mahjong", "gamer": "room_gamer", "nurse": "room_nurse", "helper": "room_helper", "gym": "room_gym", "shopper": "room_shopper"}
				var _t4207 = null
				if J.t(((not J.seq(J.gp(v_un_3879, "ot"), "deity")) if J.t(v_un_3879) else v_un_3879)):
					var _t4206 = null
					if J.seq(_s1542["__p"]["f"], 0.0):
						_t4206 = "room_carpark"
					else:
						var _t4205 = J.seq(_s1542["__p"]["f"], 1.0)
						_t4206 = ("room_lobby" if (J.seq(J.gp(v_un_3879, "u"), 0.0) if _t4205 else _t4205) else J.gp(v_RM_3881, J.gp(v_un_3879, "hh")))
					_t4207 = _t4206
				else:
					_t4207 = null
				v_rk_3882 = _t4207
				v_ri_3883 = (J.gp(_s1542["__p"]["__p"]["IMG"], v_rk_3882) if J.t(v_rk_3882) else v_rk_3882)
				if J.t((J.gp(v_ri_3883, "width") if J.t(v_ri_3883) else v_ri_3883)):
					J.mc(_s1542["__p"]["c"], "save", [])
					if J.seq(J.mod(J.add(v_ci_3876, _s1542["__p"]["f"]), 2.0), 1.0):
						J.mc(_s1542["__p"]["c"], "translate", [J.add(_s1542["x0"], v_w_3878), _s1542["__p"]["top"]])
						J.mc(_s1542["__p"]["c"], "scale", [(-1.0), 1.0])
						J.mc(_s1542["__p"]["c"], "drawImage", [v_ri_3883, 0.0, 0.0, v_w_3878, _s1542["__p"]["hgt"]])
					else:
						J.mc(_s1542["__p"]["c"], "drawImage", [v_ri_3883, _s1542["x0"], _s1542["__p"]["top"], v_w_3878, _s1542["__p"]["hgt"]])
					J.mc(_s1542["__p"]["c"], "restore", [])
					if J.t(_s1542["__p"]["dark"]):
						var _t4208 = _s1542["__p"]["c"]
						J.sp(_t4208, "fillStyle", "rgba(10,20,40,0.25)")
						J.mc(_s1542["__p"]["c"], "fillRect", [_s1542["x0"], _s1542["__p"]["top"], v_w_3878, _s1542["__p"]["hgt"]])
					var _t4209 = _s1542["__p"]["c"]
					J.sp(_t4209, "strokeStyle", "rgba(0,0,0,0.6)")
					var _t4210 = _s1542["__p"]["c"]
					J.sp(_t4210, "lineWidth", 3.0)
					J.mc(_s1542["__p"]["c"], "strokeRect", [J.add(_s1542["x0"], 1.0), J.add(_s1542["__p"]["top"], 1.0), J.sub(v_w_3878, 2.0), J.sub(_s1542["__p"]["hgt"], 2.0)])
				else:
					if J.t((J.seq(J.gp(v_un_3879, "ot"), "deity") if J.t(v_un_3879) else v_un_3879)):
						v_r_3880 = J.gp(J.gp(J.gp(_s1542["__p"]["B"], "src"), "deity"), 0.0)
					else:
						if J.cmp(_s1542["__p"]["f"], 1.0, "<="):
							var _t4211 = J.gp(_s1542["__p"]["gPool"], J.mod(J.add(v_ci_3876, _s1542["__p"]["f"]), J.len(_s1542["__p"]["gPool"])))
							v_r_3880 = _t4211
						else:
							var _t4213 = _s1542["__p"]["resPool"]
							var _t4212 = J.num(_s1542["__p"]["ui"])
							_s1542["__p"]["ui"] = _t4212 + 1.0
							var _t4214 = J.gp(_t4213, J.mod(J.add((_t4212 * 5.0), _s1542["__p"]["f"]), J.len(_s1542["__p"]["resPool"])))
							v_r_3880 = _t4214
					var _t4215 = _s1542["__p"]["put"]
					J.cl(_t4215, null, [v_r_3880, _s1542["x0"], _s1542["__p"]["top"], v_w_3878, _s1542["__p"]["hgt"], J.seq(J.mod(J.add(v_ci_3876, _s1542["__p"]["f"]), 2.0), 1.0), _s1542["__p"]["dark"]])

func _f639(this_, a: Array, env):
	var v_P_3889 = null; var v_px_3890 = null; var v_y_3891 = null
	v_P_3889 = J.arg(a, 0)
	v_px_3890 = J.sub(J.gp(J.gp(J.gp(env["__p"]["LV"], "ucols"), J.gp(v_P_3889, 2.0)), 1.0), 6.0)
	var _t4229 = env["c"]
	J.sp(_t4229, "strokeStyle", "#5a6a68")
	var _t4230 = env["c"]
	J.sp(_t4230, "lineWidth", 5.0)
	J.mc(env["c"], "beginPath", [])
	var _t4231 = env["__p"]["fy"]
	J.mc(env["c"], "moveTo", [v_px_3890, J.sub(J.cl(_t4231, null, [J.gp(v_P_3889, 1.0)]), 110.0)])
	var _t4232 = env["__p"]["fy"]
	J.mc(env["c"], "lineTo", [v_px_3890, J.cl(_t4232, null, [J.gp(v_P_3889, 0.0)])])
	J.mc(env["c"], "stroke", [])
	var _t4233 = env["c"]
	J.sp(_t4233, "strokeStyle", "#8a9a96")
	var _t4234 = env["c"]
	J.sp(_t4234, "lineWidth", 1.5)
	J.mc(env["c"], "stroke", [])
	var _t4235 = env["__p"]["fy"]
	v_y_3891 = J.sub(J.cl(_t4235, null, [J.gp(v_P_3889, 1.0)]), 100.0)
	while true:
		var _t4236 = env["__p"]["fy"]
		if not J.cmp(v_y_3891, J.cl(_t4236, null, [J.gp(v_P_3889, 0.0)]), "<"): break
		var _t4237 = env["c"]
		J.sp(_t4237, "fillStyle", "#3a4442")
		J.mc(env["c"], "fillRect", [J.sub(v_px_3890, 5.0), v_y_3891, 10.0, 4.0])
		var _t4238 = J.add(v_y_3891, 40.0)
		v_y_3891 = _t4238

func _f624(this_, a: Array, env):
	var v_sky_3741 = null; var v_i_3742 = null; var v_bot_3748 = null; var v_rt_3751 = null; var v_rh_3752 = null; var v_rw_3753 = null; var v_x_3754 = null; var v_bakeTiles_3756 = null
	var _s1497 = {"__p": env, "SC": null, "B": null, "c": null, "img": null, "k": null, "resPool": null, "gPool": null, "ui": null, "f": null, "top": null, "hgt": null, "dark": null, "put": null}
	_s1497["put"] = Callable(self, "_f625").bind(_s1497)
	v_bakeTiles_3756 = Callable(self, "_f626").bind(_s1497)
	_s1497["SC"] = J.min_([1.4, sqrt(J.num(J.div(6500000.0, J.mul(_s1497["__p"]["WW"], _s1497["__p"]["WH"]))))])
	_s1497["B"] = J.gp(_s1497["__p"]["LV"], "B")
	var _t4176 = J.S_document_("createElement", ["canvas"])
	_s1497["__p"]["staticCv"] = _t4176
	var _t4177 = _s1497["__p"]["staticCv"]
	var _t4178 = J.round(J.num(J.mul(_s1497["__p"]["WW"], _s1497["SC"])))
	J.sp(_t4177, "width", _t4178)
	var _t4179 = _s1497["__p"]["staticCv"]
	var _t4180 = J.round(J.num(J.mul(_s1497["__p"]["WH"], _s1497["SC"])))
	J.sp(_t4179, "height", _t4180)
	_s1497["c"] = J.mc(_s1497["__p"]["staticCv"], "getContext", ["2d"])
	J.mc(_s1497["c"], "scale", [_s1497["SC"], _s1497["SC"]])
	_s1497["img"] = J.gp(_s1497["__p"]["IMG"], J.gp(_s1497["B"], "skin"))
	_s1497["k"] = (J.div(J.gp(_s1497["img"], "width"), 600.0) if J.t((J.gp(_s1497["img"], "width") if J.t(_s1497["img"]) else _s1497["img"])) else 1.0)
	v_sky_3741 = J.mc(_s1497["c"], "createLinearGradient", [0.0, 0.0, 0.0, _s1497["__p"]["WH"]])
	J.mc(v_sky_3741, "addColorStop", [0.0, "#0b0d16"])
	J.mc(v_sky_3741, "addColorStop", [0.5, "#141622"])
	J.mc(v_sky_3741, "addColorStop", [1.0, "#0c0c10"])
	var _t4181 = _s1497["c"]
	J.sp(_t4181, "fillStyle", v_sky_3741)
	J.mc(_s1497["c"], "fillRect", [0.0, 0.0, _s1497["__p"]["WW"], _s1497["__p"]["WH"]])
	v_i_3742 = 0.0
	while true:
		if not J.cmp(v_i_3742, 60.0, "<"): break
		var _t4182 = _s1497["c"]
		var _t4183 = (J.add("rgba(230,230,255,", (0.2 + J.div(J.mod(J.mul(v_i_3742, 37.0), 10.0), 20.0))) + ")")
		J.sp(_t4182, "fillStyle", _t4183)
		var _t4187 = J.mod(J.mul(v_i_3742, 197.0), _s1497["__p"]["WW"])
		var _t4186 = J.mul(v_i_3742, 61.0)
		var _t4184 = _s1497["__p"]["fy"]
		var _t4185 = _s1497["__p"]["fy"]
		J.mc(_s1497["c"], "fillRect", [_t4187, J.mod(_t4186, J.max_([40.0, J.sub(J.cl(_t4185, null, [_s1497["__p"]["FL"]]), 60.0)])), 1.5, 1.5])
		v_i_3742 = J.num(v_i_3742) + 1.0
	var _t4188 = J.G.get("window")
	var _t4191 = {"bakeURL": Callable(self, "_f635").bind(_s1497), "camTo": Callable(self, "_f636").bind(_s1497)}
	J.sp(_t4188, "TW8", _t4191)
	if (not J.t(J.cl(v_bakeTiles_3756, null, []))):
		_s1497["resPool"] = J.gp(J.gp(_s1497["B"], "src"), "res")
		_s1497["gPool"] = J.gp(J.gp(_s1497["B"], "src"), "ground")
		_s1497["ui"] = 0.0
		_s1497["f"] = 0.0
		while true:
			if not J.cmp(_s1497["f"], _s1497["__p"]["FL"], "<"): break
			var _t4192 = _s1497["__p"]["fy"]
			_s1497["top"] = J.cl(_t4192, null, [J.add(_s1497["f"], 1.0)])
			var _t4193 = _s1497["__p"]["fy"]
			v_bot_3748 = J.add(J.cl(_t4193, null, [_s1497["f"]]), 12.0)
			_s1497["hgt"] = J.sub(v_bot_3748, _s1497["top"])
			_s1497["dark"] = ("rgba(10,20,40,0.45)" if J.seq(_s1497["f"], 0.0) else null)
			var _t4194 = J.gp(_s1497["__p"]["LV"], "xs")
			J.mc(_t4194, "forEach", [Callable(self, "_f637").bind(_s1497)])
			var _t4216 = _s1497["c"]
			J.sp(_t4216, "fillStyle", "rgba(0,0,0,0.55)")
			J.mc(_s1497["c"], "fillRect", [0.0, J.sub(v_bot_3748, 4.0), _s1497["__p"]["WW"], 6.0])
			_s1497["f"] = J.num(_s1497["f"]) + 1.0
		v_rt_3751 = J.gp(J.gp(_s1497["B"], "src"), "roof")
		v_rh_3752 = J.sub(J.gp(v_rt_3751, 3.0), J.gp(v_rt_3751, 2.0))
		v_rw_3753 = J.sub(J.gp(v_rt_3751, 1.0), J.gp(v_rt_3751, 0.0))
		v_x_3754 = 0.0
		while true:
			if not J.cmp(v_x_3754, _s1497["__p"]["WW"], "<"): break
			var _t4217 = _s1497["put"]
			var _t4218 = _s1497["__p"]["fy"]
			J.cl(_t4217, null, [v_rt_3751, v_x_3754, J.sub(J.cl(_t4218, null, [_s1497["__p"]["FL"]]), v_rh_3752), v_rw_3753, J.add(v_rh_3752, 8.0), J.seq(J.mod(J.div(v_x_3754, v_rw_3753), 2.0), 1.0)])
			var _t4219 = J.add(v_x_3754, v_rw_3753)
			v_x_3754 = _t4219
		var _t4220 = _s1497["c"]
		J.sp(_t4220, "strokeStyle", "rgba(120,140,150,0.5)")
		var _t4221 = _s1497["c"]
		J.sp(_t4221, "lineWidth", 4.0)
		J.mc(_s1497["c"], "beginPath", [])
		var _t4222 = _s1497["__p"]["fy"]
		J.mc(_s1497["c"], "moveTo", [0.0, J.add(J.cl(_t4222, null, [1.0]), 30.0)])
		var _t4224 = _s1497["__p"]["WW"]
		var _t4223 = _s1497["__p"]["fy"]
		J.mc(_s1497["c"], "lineTo", [_t4224, J.add(J.cl(_t4223, null, [1.0]), 30.0)])
		J.mc(_s1497["c"], "stroke", [])
		var _t4225 = _s1497["c"]
		J.sp(_t4225, "fillStyle", "rgba(220,220,160,0.25)")
		v_x_3754 = 120.0
		while true:
			if not J.cmp(v_x_3754, J.sub(_s1497["__p"]["WW"], 100.0), "<"): break
			var _t4226 = _s1497["__p"]["fy"]
			J.mc(_s1497["c"], "fillRect", [v_x_3754, J.sub(J.cl(_t4226, null, [0.0]), 4.0), 60.0, 3.0])
			var _t4227 = J.add(v_x_3754, 110.0)
			v_x_3754 = _t4227
	var _t4228 = J.gp(_s1497["__p"]["LV"], "pipes")
	J.mc(_t4228, "forEach", [Callable(self, "_f639").bind(_s1497)])
	var _t4239 = _s1497["c"]
	var _t4240 = J.add("bold 13px ", _s1497["__p"]["FONT"])
	J.sp(_t4239, "font", _t4240)
	var _t4241 = _s1497["c"]
	J.sp(_t4241, "textAlign", "left")
	_s1497["f"] = 0.0
	while true:
		if not J.cmp(_s1497["f"], _s1497["__p"]["FL"], "<="): break
		var _t4242 = _s1497["c"]
		J.sp(_t4242, "lineWidth", 3.0)
		var _t4243 = _s1497["c"]
		J.sp(_t4243, "strokeStyle", "#000")
		var _t4245 = J.gp(_s1497["__p"]["FLN"], _s1497["f"])
		var _t4244 = _s1497["__p"]["fy"]
		J.mc(_s1497["c"], "strokeText", [_t4245, 6.0, ((J.sub(J.cl(_t4244, null, [_s1497["f"]]), J.gp(J.gp(_s1497["__p"]["LV"], "B"), "FH")) + 44.0) + (60.0 if J.seq(_s1497["f"], _s1497["__p"]["FL"]) else 0.0))])
		var _t4246 = _s1497["c"]
		J.sp(_t4246, "fillStyle", "#e8d8b0")
		var _t4248 = J.gp(_s1497["__p"]["FLN"], _s1497["f"])
		var _t4247 = _s1497["__p"]["fy"]
		J.mc(_s1497["c"], "fillText", [_t4248, 6.0, ((J.sub(J.cl(_t4247, null, [_s1497["f"]]), J.gp(J.gp(_s1497["__p"]["LV"], "B"), "FH")) + 44.0) + (60.0 if J.seq(_s1497["f"], _s1497["__p"]["FL"]) else 0.0))])
		_s1497["f"] = J.num(_s1497["f"]) + 1.0

func _f641(this_, a: Array, env):
	var v_r_3899 = null; var v_hh_3900 = null; var v_want_3901 = null; var v_tx_3902 = null
	v_r_3899 = J.arg(a, 0)
	v_hh_3900 = J.gp(env["__p"]["HH"], J.gp(v_r_3899, "hh"))
	if (not J.t(v_hh_3900)):
		return null
	if J.seq(J.gp(v_r_3899, "state"), "home"):
		v_want_3901 = J.seq(J.gp(J.gp(v_hh_3900, "awake"), env["ph"]), 1.0)
		if J.t(((not J.t(J.gp(v_r_3899, "awake"))) if J.t(v_want_3901) else v_want_3901)):
			J.sp(v_r_3899, "awake", true)
			var _t4250 = env["__p"]["say"]
			var _t4251 = env["__p"]["pick"]
			J.cl(_t4250, null, [v_r_3899, J.cl(_t4251, null, [["又醒咗……", "咩鐘數呀而家？"]])])
		var _t4252 = (not J.t(v_want_3901))
		var _t4253 = (J.gp(v_r_3899, "awake") if _t4252 else _t4252)
		var _t4254 = ((not J.t(J.gp(v_r_3899, "woke"))) if J.t(_t4253) else _t4253)
		var _t4255 = (J.cmp(J.gp(v_r_3899, "fear"), 20.0, "<") if J.t(_t4254) else _t4254)
		if J.t((J.cmp(J.cl(env["__p"]["rnd"], null, []), J.mul(env["dt"], 0.05), "<") if J.t(_t4255) else _t4255)):
			J.sp(v_r_3899, "awake", false)
		var _t4256 = J.sub(J.gp(v_r_3899, "idleT"), env["dt"])
		J.sp(v_r_3899, "idleT", _t4256)
		if J.cmp(J.gp(v_r_3899, "idleT"), 0.0, "<="):
			var _t4257 = (10.0 + J.mul(J.cl(env["__p"]["rnd"], null, []), 14.0))
			J.sp(v_r_3899, "idleT", _t4257)
			var _t4258 = J.gp(v_r_3899, "awake")
			if J.t(((not J.t(J.gp(v_r_3899, "say"))) if J.t(_t4258) else _t4258)):
				var _t4259 = env["__p"]["say"]
				var _t4260 = env["__p"]["pick"]
				J.cl(_t4259, null, [v_r_3899, J.cl(_t4260, null, [J.gp(v_hh_3900, "idle")])])
		var _t4261 = J.gp(v_hh_3900, "leave")
		var _t4262 = ((not J.t(J.gp(v_r_3899, "left"))) if J.t(_t4261) else _t4261)
		if J.t((J.cmp(env["tt"], J.gp(v_hh_3900, "leave"), ">=") if J.t(_t4262) else _t4262)):
			J.sp(v_r_3899, "left", true)
			J.sp(v_r_3899, "state", "leave")
			J.sp(v_r_3899, "awake", true)
			var _t4263 = env["__p"]["say"]
			J.cl(_t4263, null, [v_r_3899, ("返工喇，出門口先" if J.seq(J.gp(v_r_3899, "hh"), "nurse") else "去晨運先")])
			var _t4264 = J.gp(v_r_3899, "unit")
			J.sp(_t4264, "doorOpen", 4.0)
			var _t4265 = (-70.0)
			J.sp(v_r_3899, "vx", _t4265)
	var _t4266 = J.seq(J.gp(v_r_3899, "state"), "away")
	var _t4267 = (J.gp(v_hh_3900, "away") if _t4266 else _t4266)
	if J.t((J.cmp(env["tt"], J.gp(v_hh_3900, "away"), ">=") if J.t(_t4267) else _t4267)):
		J.sp(v_r_3899, "state", "back")
		var _t4268 = env["__p"]["SX"]
		J.sp(v_r_3899, "x", _t4268)
		var _t4269 = env["__p"]["fy"]
		var _t4270 = J.sub(J.cl(_t4269, null, [J.gp(J.gp(v_r_3899, "unit"), "f")]), 16.0)
		J.sp(v_r_3899, "y", _t4270)
		J.sp(v_r_3899, "vx", 70.0)
		J.sp(v_r_3899, "awake", true)
		var _t4271 = env["__p"]["say"]
		J.cl(_t4271, null, [v_r_3899, "收工返屋企喇……"])
	if J.seq(J.gp(v_r_3899, "state"), "leave"):
		var _t4272 = J.add(J.gp(v_r_3899, "x"), J.mul(J.gp(v_r_3899, "vx"), env["dt"]))
		J.sp(v_r_3899, "x", _t4272)
		if J.cmp(J.gp(v_r_3899, "x"), env["__p"]["SX"], "<="):
			J.sp(v_r_3899, "state", "gone")
	if J.seq(J.gp(v_r_3899, "state"), "back"):
		v_tx_3902 = J.add(J.gp(J.gp(J.gp(v_r_3899, "unit"), "rx"), 0.0), 30.0)
		var _t4273 = J.add(J.gp(v_r_3899, "x"), J.mul((signf(J.num(J.sub(v_tx_3902, J.gp(v_r_3899, "x")))) * 70.0), env["dt"]))
		J.sp(v_r_3899, "x", _t4273)
		if (absf(J.num(J.sub(v_tx_3902, J.gp(v_r_3899, "x")))) < 4.0):
			J.sp(v_r_3899, "state", "home")
			var _t4274 = J.gp(v_r_3899, "unit")
			J.sp(_t4274, "doorOpen", 3.0)

func _f643(this_, a: Array, env):
	var v_r_3908 = null
	v_r_3908 = J.arg(a, 0)
	return J.seq(J.gp(v_r_3908, "state"), "home")

func _f644(this_, a: Array, env):
	var v_p_3911 = null
	v_p_3911 = J.arg(a, 0)
	var _t4281 = J.max_([0.0, J.sub(J.gp(v_p_3911, "t"), env["dt"])])
	J.sp(v_p_3911, "t", _t4281)
	var _t4282 = J.max_([0.0, J.sub(J.gp(v_p_3911, "cd"), env["dt"])])
	J.sp(v_p_3911, "cd", _t4282)

func _f642(this_, a: Array, env):
	var v_u_3905 = null
	v_u_3905 = J.arg(a, 0)
	if (not J.t(J.gp(v_u_3905, "rs"))):
		return null
	var _t4276 = J.gp(v_u_3905, "rs")
	var _t4277 = J.mc(_t4276, "find", [Callable(self, "_f643").bind(env)])
	var _t4278 = (_t4277 if J.t(_t4277) else J.gp(J.gp(v_u_3905, "rs"), 0.0))
	var _t4279 = (_t4278 if J.t(_t4278) else null)
	J.sp(v_u_3905, "res", _t4279)
	var _t4280 = J.gp(v_u_3905, "props")
	J.mc(_t4280, "forEach", [Callable(self, "_f644").bind(env)])

func _f645(this_, a: Array, env):
	var v_p_3914 = null
	v_p_3914 = J.arg(a, 0)
	var _t4285 = J.max_([0.0, J.sub(J.gp(v_p_3914, "t"), env["dt"])])
	J.sp(v_p_3914, "t", _t4285)
	var _t4286 = J.max_([0.0, J.sub(J.gp(v_p_3914, "cd"), env["dt"])])
	J.sp(v_p_3914, "cd", _t4286)

func _f646(this_, a: Array, env):
	var v_e_3917 = null
	v_e_3917 = J.arg(a, 0)
	if J.t(J.gp(v_e_3917, "fire")):
		var _t4288 = J.gp(v_e_3917, "fire")
		var _t4289 = J.max_([0.0, J.sub(J.gp(J.gp(v_e_3917, "fire"), "shut"), env["dt"])])
		J.sp(_t4288, "shut", _t4289)
		var _t4290 = J.gp(v_e_3917, "fire")
		var _t4291 = J.max_([0.0, J.sub(J.gp(J.gp(v_e_3917, "fire"), "cd"), env["dt"])])
		J.sp(_t4290, "cd", _t4291)

func _f640(this_, a: Array, env):
	var _s1557 = {"__p": env, "dt": null, "ph": null, "tt": null}
	_s1557["dt"] = J.arg(a, 0)
	_s1557["ph"] = J.min_([2.0, J.gp(_s1557["__p"]["G"], "phase")])
	_s1557["tt"] = J.div(J.gp(_s1557["__p"]["G"], "t"), _s1557["__p"]["PHT"])
	var _t4249 = J.gp(_s1557["__p"]["G"], "res")
	J.mc(_t4249, "forEach", [Callable(self, "_f641").bind(_s1557)])
	var _t4275 = J.gp(_s1557["__p"]["G"], "units")
	J.mc(_t4275, "forEach", [Callable(self, "_f642").bind(_s1557)])
	var _t4283 = J.gp(_s1557["__p"]["G"], "cprops")
	var _t4284 = (_t4283 if J.t(_t4283) else [])
	J.mc(_t4284, "forEach", [Callable(self, "_f645").bind(_s1557)])
	var _t4287 = J.gp(_s1557["__p"]["G"], "edges")
	J.mc(_t4287, "forEach", [Callable(self, "_f646").bind(_s1557)])
	var _t4292 = _s1557["__p"]["G"]
	var _t4293 = J.gp(_s1557["__p"]["G"], "lureCd")
	var _t4294 = J.gp(_s1557["__p"]["G"], "lureCd")
	var _t4295 = J.max_([0.0, J.sub((_t4294 if J.t(_t4294) else 0.0), _s1557["dt"])])
	J.sp(_t4292, "lureCd", _t4295)
	var _t4296 = _s1557["__p"]["questUpdate"]
	J.cl(_t4296, null, [_s1557["dt"]])
	var _t4297 = _s1557["__p"]["reliefUpdate"]
	J.cl(_t4297, null, [_s1557["dt"]])

func _f649(this_, a: Array, env):
	var v_r_3930 = null
	v_r_3930 = J.arg(a, 0)
	if (not J.seq(J.gp(v_r_3930, "state"), "home")):
		return null
	J.sp(v_r_3930, "awake", true)
	J.sp(v_r_3930, "woke", true)
	var _t4306 = J.add(J.gp(v_r_3930, "fear"), env["amt"])
	J.sp(v_r_3930, "fear", _t4306)
	J.sp(v_r_3930, "jumpT", 0.4)
	env["hit"] = J.num(env["hit"]) + 1.0
	if J.cmp(J.cl(env["__p"]["rnd"], null, []), 0.5, "<"):
		var _t4307 = env["__p"]["say"]
		var _t4308 = env["__p"]["pick"]
		J.cl(_t4307, null, [v_r_3930, J.cl(_t4308, null, [["隔籬做咩嗌成咁？", "樓上咩聲呀？！", "咩事咩事？！"]])])
	var _t4309 = J.cmp(J.gp(v_r_3930, "fear"), 100.0, ">=")
	if ((not J.cmp(J.gp(v_r_3930, "fleeAfter"), 0.0, ">")) if _t4309 else _t4309):
		J.sp(v_r_3930, "fleeAfter", 1.2)
		var _t4310 = J.add((env["depth"] if J.t(env["depth"]) else 0.0), 1.0)
		J.sp(v_r_3930, "chainD", _t4310)

func _f648(this_, a: Array, env):
	var v_v_3926 = null; var v_adj_3927 = null
	v_v_3926 = J.arg(a, 0)
	var _t4299 = J.seq(v_v_3926, env["un"])
	var _t4300 = (_t4299 if _t4299 else (not J.t(J.len(J.gp(v_v_3926, "rs")))))
	if (_t4300 if _t4300 else J.seq(J.gp(v_v_3926, "ot"), "deity")):
		return null
	var _t4301 = J.seq(J.gp(v_v_3926, "f"), J.gp(env["un"], "f"))
	var _t4304 = (J.seq(absf(J.num(J.sub(J.gp(v_v_3926, "u"), J.gp(env["un"], "u")))), 1.0) if _t4301 else _t4301)
	if not J.t(_t4304):
		var _t4302 = J.seq(absf(J.num(J.sub(J.gp(v_v_3926, "f"), J.gp(env["un"], "f")))), 1.0)
		var _t4303 = (J.cmp(J.gp(J.gp(v_v_3926, "rx"), 0.0), J.gp(J.gp(env["un"], "rx"), 1.0), "<") if _t4302 else _t4302)
		_t4304 = (J.cmp(J.gp(J.gp(v_v_3926, "rx"), 1.0), J.gp(J.gp(env["un"], "rx"), 0.0), ">") if _t4303 else _t4303)
	v_adj_3927 = _t4304
	if (not J.t(v_adj_3927)):
		return null
	var _t4305 = J.gp(v_v_3926, "rs")
	J.mc(_t4305, "forEach", [Callable(self, "_f649").bind(env)])

func _f647(this_, a: Array, env):
	var _s1575 = {"__p": env, "un": null, "amt": null, "depth": null, "hit": null}
	_s1575["un"] = J.arg(a, 0)
	_s1575["amt"] = J.arg(a, 1)
	_s1575["depth"] = J.arg(a, 2)
	if J.cmp((_s1575["depth"] if J.t(_s1575["depth"]) else 0.0), 1.0, ">"):
		return null
	_s1575["hit"] = 0.0
	var _t4298 = J.gp(_s1575["__p"]["G"], "units")
	J.mc(_t4298, "forEach", [Callable(self, "_f648").bind(_s1575)])
	if J.t(_s1575["hit"]):
		var _t4311 = _s1575["__p"]["float"]
		J.cl(_t4311, null, [J.gp(_s1575["un"], "x"), J.sub(J.gp(_s1575["un"], "y"), 120.0), (J.add("連鎖！隔籬 ", _s1575["hit"]) + " 個醒晒"), "#ffb7a0"])
		var _t4312 = _s1575["__p"]["addFear"]
		J.cl(_t4312, null, [J.min_([12.0, J.mul(_s1575["hit"], 2.0)]), J.gp(_s1575["un"], "x"), J.sub(J.gp(_s1575["un"], "y"), 140.0)])

func _f652(this_, a: Array, env):
	var v_id_3945 = null; var v_b_3946 = null
	v_id_3945 = J.arg(a, 0)
	v_b_3946 = J.gp(J.gp(env["__p"]["__p"]["G"], "nodes"), v_id_3945)
	var _t4324 = J.add(env["d"], (absf(J.num(J.sub(J.gp(env["a"], "x"), J.gp(v_b_3946, "x")))) + absf(J.num(J.sub(J.gp(env["a"], "y"), J.gp(v_b_3946, "y"))))))
	env["d"] = _t4324
	env["a"] = v_b_3946

func _f651(this_, a: Array, env):
	var v_h_3939 = null; var v_p_3940 = null
	var _s1581 = {"__p": env, "d": null, "a": null}
	v_h_3939 = J.arg(a, 0)
	var _t4318 = (not J.seq(J.gp(v_h_3939, "kind"), "guard"))
	var _t4319 = (_t4318 if _t4318 else J.seq(J.gp(v_h_3939, "state"), "chase"))
	var _t4320 = (_t4319 if _t4319 else J.seq(J.gp(v_h_3939, "state"), "scared"))
	var _t4321 = (_t4320 if _t4320 else J.seq(J.gp(v_h_3939, "state"), "shift"))
	var _t4322 = (_t4321 if _t4321 else J.seq(J.gp(v_h_3939, "state"), "flee"))
	if (_t4322 if _t4322 else J.seq(J.gp(v_h_3939, "state"), "gone")):
		return null
	var _t4323 = _s1581["__p"]["__p"]["dijkstra"]
	v_p_3940 = J.cl(_t4323, null, [v_h_3939, J.gp(v_h_3939, "node"), _s1581["__p"]["nodeId"]])
	if (not J.t(v_p_3940)):
		return null
	_s1581["d"] = 0.0
	_s1581["a"] = J.gp(J.gp(_s1581["__p"]["__p"]["G"], "nodes"), J.gp(v_h_3939, "node"))
	J.mc(v_p_3940, "forEach", [Callable(self, "_f652").bind(_s1581)])
	var _t4326 = J.cmp(_s1581["d"], J.mul(700.0, _s1581["__p"]["lvl"]), ">")
	if not J.t(_t4326):
		var _t4325 = _s1581["__p"]["__p"]["inZone"]
		_t4326 = (not J.t(J.cl(_t4325, null, [v_h_3939, J.gp(_s1581["__p"]["n"], "f"), 1.0])))
	if _t4326:
		return null
	var _t4327 = J.seq(J.gp(v_h_3939, "state"), "puzzle")
	if (J.seq(J.gp(v_h_3939, "invNode"), _s1581["__p"]["nodeId"]) if _t4327 else _t4327):
		var _t4328 = _s1581["__p"]["__p"]["spook"]
		J.cl(_t4328, null, [v_h_3939, "同一個位又有怪聲！"])
		return null
	J.sp(v_h_3939, "state", "inv")
	var _t4329 = _s1581["__p"]["nodeId"]
	J.sp(v_h_3939, "invNode", _t4329)
	J.sp(v_h_3939, "path", v_p_3940)
	J.sp(v_h_3939, "to", null)
	J.sp(v_h_3939, "wait", 0.0)
	J.sp(v_h_3939, "alertT", 0.8)
	var _t4330 = _s1581["__p"]["__p"]["pick"]
	var _t4331 = J.cl(_t4330, null, [["咩聲嚟㗎？過去睇睇", "邊度傳嚟嘅？", (J.add("又係", J.gp(_s1581["__p"]["__p"]["FLN"], J.gp(_s1581["__p"]["n"], "f"))) + "？")]])
	J.sp(v_h_3939, "say", _t4331)
	J.sp(v_h_3939, "sayT", 2.2)

func _f650(this_, a: Array, env):
	var v_why_3935 = null
	var _s1580 = {"__p": env, "nodeId": null, "lvl": null, "n": null}
	_s1580["nodeId"] = J.arg(a, 0)
	_s1580["lvl"] = J.arg(a, 1)
	v_why_3935 = J.arg(a, 2)
	_s1580["n"] = J.gp(J.gp(_s1580["__p"]["G"], "nodes"), _s1580["nodeId"])
	if (not J.t(_s1580["n"])):
		return null
	var _t4313 = _s1580["__p"]["G"]
	var _t4314 = J.gp(_s1580["__p"]["G"], "noiseFx")
	var _t4315 = (_t4314 if J.t(_t4314) else [])
	J.sp(_t4313, "noiseFx", _t4315)
	var _t4316 = J.gp(_s1580["__p"]["G"], "noiseFx")
	J.mc(_t4316, "push", [{"x": J.gp(_s1580["n"], "x"), "y": J.sub(J.gp(_s1580["n"], "y"), 40.0), "t": 1.2, "lvl": _s1580["lvl"]}])
	var _t4317 = J.gp(_s1580["__p"]["G"], "guards")
	J.mc(_t4317, "forEach", [Callable(self, "_f651").bind(_s1580)])

func _f654(this_, a: Array, env):
	var v_g_3955 = null; var v_d_3956 = null
	v_g_3955 = J.arg(a, 0)
	var _t4340 = J.gp(v_g_3955, "home")
	if J.t((_t4340 if J.t(_t4340) else J.gp(v_g_3955, "out"))):
		return null
	v_d_3956 = (absf(J.num(J.sub(J.gp(v_g_3955, "x"), J.gp(env["h"], "x")))) + (absf(J.num(J.sub(J.gp(v_g_3955, "y"), J.gp(env["h"], "y")))) * 3.0))
	if J.cmp(v_d_3956, env["dS"], "<"):
		env["dS"] = v_d_3956
		env["gS"] = v_g_3955

func _f653(this_, a: Array, env):
	var v_txt0_3950 = null
	var _s1584 = {"__p": env, "h": null, "gS": null, "dS": null}
	_s1584["h"] = J.arg(a, 0)
	v_txt0_3950 = J.arg(a, 1)
	var _t4332 = J.seq(J.gp(_s1584["h"], "state"), "shift")
	if (_t4332 if _t4332 else J.seq(J.gp(_s1584["h"], "state"), "gone")):
		return null
	var _t4333 = _s1584["h"]
	var _t4334 = J.sub((3.0 if J.leq(J.gp(_s1584["h"], "nerve"), null) else J.gp(_s1584["h"], "nerve")), 1.0)
	J.sp(_t4333, "nerve", _t4334)
	var _t4335 = _s1584["h"]
	J.sp(_t4335, "state", "scared")
	var _t4336 = _s1584["h"]
	J.sp(_t4336, "scT", 2.6)
	var _t4337 = _s1584["h"]
	J.sp(_t4337, "to", null)
	var _t4338 = _s1584["h"]
	J.sp(_t4338, "path", null)
	_s1584["gS"] = null
	_s1584["dS"] = 1000000000.0
	var _t4339 = J.gp(_s1584["__p"]["G"], "gh")
	J.mc(_t4339, "forEach", [Callable(self, "_f654").bind(_s1584)])
	var _t4341 = _s1584["h"]
	var _t4342 = ((1.0 if J.cmp(J.gp(_s1584["h"], "x"), J.gp(_s1584["gS"], "x"), ">=") else (-1.0)) if J.t((J.cmp(_s1584["dS"], 400.0, "<") if J.t(_s1584["gS"]) else _s1584["gS"])) else ((-1.0) if J.cmp(J.cl(_s1584["__p"]["rnd"], null, []), 0.5, "<") else 1.0))
	J.sp(_t4341, "scAway", _t4342)
	var _t4343 = _s1584["h"]
	var _t4344 = J.mul(J.gp(_s1584["h"], "scAway"), 55.0)
	J.sp(_t4343, "vx", _t4344)
	var _t4345 = _s1584["h"]
	var _t4346 = (-J.num(J.gp(_s1584["h"], "scAway")))
	J.sp(_t4345, "dir", _t4346)
	var _t4347 = _s1584["h"]
	J.sp(_t4347, "shockT", 0.9)
	var _t4348 = _s1584["h"]
	var _t4349 = _s1584["__p"]["uniq"]
	var _t4351 = J.cl(_t4349, null, [[v_txt0_3950]])
	if not J.t(_t4351):
		var _t4350 = _s1584["__p"]["uniq"]
		_t4351 = J.cl(_t4350, null, [_s1584["__p"]["SPOOKL"]])
	J.sp(_t4348, "say", _t4351)
	var _t4352 = _s1584["h"]
	J.sp(_t4352, "sayT", 2.0)
	var _t4353 = _s1584["h"]
	J.sp(_t4353, "alertT", 0.6)
	var _t4354 = _s1584["__p"]["addFear"]
	J.cl(_t4354, null, [6.0, J.gp(_s1584["h"], "x"), J.sub(J.gp(_s1584["h"], "y"), 90.0)])
	var _t4355 = _s1584["__p"]["float"]
	J.cl(_t4355, null, [J.gp(_s1584["h"], "x"), J.sub(J.gp(_s1584["h"], "y"), 110.0), "保安嚇親！", "#ffd54a"])
	if J.cmp(J.cl(_s1584["__p"]["rnd"], null, []), 0.3, "<"):
		var _t4356 = _s1584["__p"]["G"]
		var _t4357 = J.add(J.gp(_t4356, "alert"), 1.0)
		J.sp(_t4356, "alert", _t4357)
		J.cl(_s1584["__p"]["checkAlert"], null, [])
		var _t4358 = _s1584["__p"]["float"]
		J.cl(_t4358, null, [J.gp(_s1584["h"], "x"), J.sub(J.gp(_s1584["h"], "y"), 130.0), (J.add("對講機：「管理處！", J.gp(_s1584["__p"]["FLN"], J.gp(J.gp(J.gp(_s1584["__p"]["G"], "nodes"), J.gp(_s1584["h"], "node")), "f"))) + "有怪事！」警覺 +1"), "#ffb0b0"])
	if J.cmp(J.gp(_s1584["h"], "nerve"), 0.0, "<="):
		var _t4359 = _s1584["h"]
		J.sp(_t4359, "state", "shift")
		var _t4360 = _s1584["h"]
		J.sp(_t4360, "say", "唔做喇！交更！")
		var _t4361 = _s1584["h"]
		J.sp(_t4361, "sayT", 2.5)
		var _t4362 = _s1584["__p"]["float"]
		J.cl(_t4362, null, [J.gp(_s1584["h"], "x"), J.sub(J.gp(_s1584["h"], "y"), 130.0), "保安頂唔順，落樓交更", "#9fd6bf"])
		var _t4363 = J.gp(_s1584["__p"]["G"], "relief")
		J.mc(_t4363, "push", [{"t": 26.0, "zone": J.gp(_s1584["h"], "zone")}])
		var _t4364 = _s1584["h"]
		var _t4365 = _s1584["__p"]["dijkstra"]
		var _t4366 = J.cl(_t4365, null, [_s1584["h"], J.gp(_s1584["h"], "node"), "f1_s"])
		J.sp(_t4364, "path", _t4366)

func _f656(this_, a: Array, env):
	var v_r_3962 = null; var v_zn_3963 = null; var v_h_3964 = null
	v_r_3962 = J.arg(a, 0)
	var _t4369 = J.sub(J.gp(v_r_3962, "t"), env["dt"])
	J.sp(v_r_3962, "t", _t4369)
	var _t4370 = J.cmp(J.gp(v_r_3962, "t"), 0.0, "<=")
	if ((not J.t(J.gp(v_r_3962, "done"))) if _t4370 else _t4370):
		J.sp(v_r_3962, "done", true)
		var _t4371 = J.gp(v_r_3962, "zone")
		v_zn_3963 = (_t4371 if J.t(_t4371) else [1.0, 3.0])
		var _t4372 = env["__p"]["mkHuman"]
		v_h_3964 = J.cl(_t4372, null, ["guard", (J.add("f", J.gp(v_zn_3963, 0.0)) + "_s")])
		J.sp(v_h_3964, "zone", v_zn_3963)
		J.sp(v_h_3964, "nerve", 3.0)
		var _t4373 = J.gp(env["__p"]["G"], "guards")
		J.mc(_t4373, "push", [v_h_3964])
		var _t4374 = env["__p"]["float"]
		J.cl(_t4374, null, [J.gp(v_h_3964, "x"), J.sub(J.gp(v_h_3964, "y"), 80.0), "新一更保安上班", "#ffb0b0"])

func _f657(this_, a: Array, env):
	var v_r_3967 = null
	v_r_3967 = J.arg(a, 0)
	return (not J.t(J.gp(v_r_3967, "done")))

func _f655(this_, a: Array, env):
	var _s1589 = {"__p": env, "dt": null}
	_s1589["dt"] = J.arg(a, 0)
	var _t4367 = J.gp(_s1589["__p"]["G"], "relief")
	var _t4368 = (_t4367 if J.t(_t4367) else [])
	J.mc(_t4368, "forEach", [Callable(self, "_f656").bind(_s1589)])
	var _t4375 = _s1589["__p"]["G"]
	var _t4376 = J.gp(_s1589["__p"]["G"], "relief")
	var _t4377 = (_t4376 if J.t(_t4376) else [])
	var _t4378 = J.mc(_t4377, "filter", [Callable(self, "_f657").bind(_s1589)])
	J.sp(_t4375, "relief", _t4378)

func _f658(this_, a: Array, env):
	var _t4379 = env["G"]
	var _t4380 = J.gp(env["G"], "alertAcc")
	var _t4381 = J.add((_t4380 if J.t(_t4380) else 0.0), 0.34)
	J.sp(_t4379, "alertAcc", _t4381)
	if J.cmp(J.gp(env["G"], "alertAcc"), 1.0, ">="):
		var _t4382 = env["G"]
		var _t4383 = J.sub(J.gp(_t4382, "alertAcc"), 1.0)
		J.sp(_t4382, "alertAcc", _t4383)
		var _t4384 = env["G"]
		var _t4385 = J.add(J.gp(_t4384, "alert"), 1.0)
		J.sp(_t4384, "alert", _t4385)
		J.cl(env["checkAlert"], null, [])

func _f660(this_, a: Array, env):
	var v_q_3984 = null
	v_q_3984 = J.arg(a, 0)
	var _t4392 = J.seq(J.gp(v_q_3984, "id"), "lost")
	var _t4393 = (J.seq(J.gp(v_q_3984, "state"), 1.0) if _t4392 else _t4392)
	return (J.seq(J.gp(v_q_3984, "owner"), env["un"]) if _t4393 else _t4393)

func _f661(this_, a: Array, env):
	var v_p_3987 = null
	v_p_3987 = J.arg(a, 0)
	var _t4395 = J.gp(J.gp(env["__p"]["PROP"], J.gp(v_p_3987, "k")), "v")
	return (J.cmp(J.gp(v_p_3987, "cd"), 0.0, "<=") if J.t(_t4395) else _t4395)

func _f662(this_, a: Array, env):
	var v_p_3990 = null
	v_p_3990 = J.arg(a, 0)
	return J.seq(J.gp(v_p_3990, "k"), "ancestor")

func _f663(this_, a: Array, env):
	var v_p_3993 = null
	v_p_3993 = J.arg(a, 0)
	var _t4399 = J.seq(J.gp(v_p_3993, "node"), J.gp(env["n"], "id"))
	return (J.cmp(J.gp(v_p_3993, "cd"), 0.0, "<=") if _t4399 else _t4399)

func _f664(this_, a: Array, env):
	var v_l_3996 = null
	v_l_3996 = J.arg(a, 0)
	return J.gp(v_l_3996, "e")

func _f665(this_, a: Array, env):
	var v_e_3999 = null
	v_e_3999 = J.arg(a, 0)
	return J.gp(v_e_3999, "fire")

func _f659(this_, a: Array, env):
	var v_g_3972 = null; var v_q_3975 = null; var v_p_3976 = null; var v_anc_3977 = null; var v_cp_3978 = null; var v_ua_3979 = null; var v_la_3980 = null; var v_fe_3981 = null
	var _s1595 = {"__p": env, "n": null, "un": null}
	v_g_3972 = J.arg(a, 0)
	var _t4386 = (not J.t(v_g_3972))
	var _t4387 = (_t4386 if _t4386 else J.gp(v_g_3972, "to"))
	var _t4388 = (_t4387 if J.t(_t4387) else J.gp(v_g_3972, "home"))
	if J.t((_t4388 if J.t(_t4388) else J.gp(v_g_3972, "out"))):
		return null
	_s1595["n"] = J.gp(J.gp(_s1595["__p"]["G"], "nodes"), J.gp(v_g_3972, "node"))
	if J.seq(J.gp(_s1595["n"], "kind"), "in"):
		var _t4389 = _s1595["__p"]["unitOf"]
		_s1595["un"] = J.cl(_t4389, null, [J.gp(_s1595["n"], "id")])
		var _t4390 = J.gp(_s1595["__p"]["G"], "quests")
		var _t4391 = (_t4390 if J.t(_t4390) else [])
		v_q_3975 = J.mc(_t4391, "find", [Callable(self, "_f660").bind(_s1595)])
		if J.t(v_q_3975):
			return {"k": "deliver", "t": J.add("交還", J.gp(v_q_3975, "thing")), "q": v_q_3975}
		var _t4394 = J.gp(_s1595["un"], "props")
		v_p_3976 = J.mc(_t4394, "find", [Callable(self, "_f661").bind(_s1595)])
		if J.t(v_p_3976):
			return {"k": "prop", "t": J.gp(J.gp(_s1595["__p"]["PROP"], J.gp(v_p_3976, "k")), "v"), "p": v_p_3976, "un": _s1595["un"]}
		var _t4396 = J.gp(_s1595["un"], "props")
		v_anc_3977 = J.mc(_t4396, "find", [Callable(self, "_f662").bind(_s1595)])
		if J.t(v_anc_3977):
			return {"k": "respect", "t": "（祖先牌位：唔好郁）"}
		return null
	var _t4397 = J.gp(_s1595["__p"]["G"], "cprops")
	var _t4398 = (_t4397 if J.t(_t4397) else [])
	v_cp_3978 = J.mc(_t4398, "find", [Callable(self, "_f663").bind(_s1595)])
	if J.t(v_cp_3978):
		return {"k": "cprop", "t": ("敲水管" if J.seq(J.gp(v_cp_3978, "k"), "pipeK") else "整閃走廊燈"), "p": v_cp_3978}
	if J.t(_s1595["__p"]["UNIT"]):
		v_ua_3979 = J.mc(_s1595["__p"]["UNIT"], "action", [v_g_3972, _s1595["n"]])
		if J.t(v_ua_3979):
			return v_ua_3979
	if J.t(_s1595["__p"]["LIFT"]):
		v_la_3980 = J.mc(_s1595["__p"]["LIFT"], "action", [v_g_3972, _s1595["n"]])
		if J.t(v_la_3980):
			return v_la_3980
	var _t4400 = J.seq(J.gp(_s1595["n"], "kind"), "lift")
	var _t4402 = (J.gp(_s1595["__p"]["LV"], "lift") if _t4400 else _t4400)
	if J.t(_t4402):
		var _t4401 = J.gp(_s1595["__p"]["G"], "liftCd")
		_t4402 = J.cmp((_t4401 if J.t(_t4401) else 0.0), 0.0, "<=")
	if J.t(_t4402):
		return {"k": "lift", "t": "叫𨋢自己上落"}
	if J.seq(J.gp(_s1595["n"], "kind"), "pipe"):
		return {"k": "pipeN", "t": "敲雨水喉（另一層都聽到）"}
	var _t4403 = J.gp(_s1595["n"], "id")
	var _t4405 = J.seq(J.mc(_t4403, "slice", [(-2.0)]), "_s")
	if not J.t(_t4405):
		var _t4404 = J.gp(_s1595["n"], "id")
		_t4405 = J.seq(J.mc(_t4404, "slice", [(-2.0)]), "_b")
	if _t4405:
		var _t4406 = J.gp(_s1595["n"], "links")
		var _t4407 = J.mc(_t4406, "map", [Callable(self, "_f664").bind(_s1595)])
		v_fe_3981 = J.mc(_t4407, "find", [Callable(self, "_f665").bind(_s1595)])
		var _t4408 = (J.cmp(J.gp(J.gp(v_fe_3981, "fire"), "cd"), 0.0, "<=") if J.t(v_fe_3981) else v_fe_3981)
		if J.t((J.cmp(J.gp(J.gp(v_fe_3981, "fire"), "shut"), 0.0, "<=") if J.t(_t4408) else _t4408)):
			return {"k": "fire", "t": "閂防煙門（保安要兜路）", "e": v_fe_3981}
	return null

func _f667(this_, a: Array, env):
	var v_x_4021 = null
	v_x_4021 = J.arg(a, 0)
	var _t4418 = J.min_([100.0, J.add(J.gp(v_x_4021, "energy"), 30.0)])
	J.sp(v_x_4021, "energy", _t4418)

func _f668(this_, a: Array, env):
	var v_r_4024 = null
	v_r_4024 = J.arg(a, 0)
	if (not J.seq(J.gp(v_r_4024, "state"), "home")):
		return null
	if (not J.t(J.gp(v_r_4024, "awake"))):
		J.sp(v_r_4024, "awake", true)
		J.sp(v_r_4024, "woke", true)
		var _t4429 = J.mul(J.mul(J.gp(env["P"], "f"), 0.6), J.gp(J.gp(env["__p"]["G"], "mods"), "pow"))
		var _t4428 = env["__p"]["gpF"]
		var _t4430 = J.add(J.gp(v_r_4024, "fear"), (J.mul(_t4429, J.cl(_t4428, null, [env["g"]])) * J.sub(1.0, J.gp(v_r_4024, "brave"))))
		J.sp(v_r_4024, "fear", _t4430)
		J.sp(v_r_4024, "jumpT", 0.5)
		var _t4431 = env["__p"]["say"]
		var _t4432 = env["__p"]["pick"]
		J.cl(_t4431, null, [v_r_4024, J.cl(_t4432, null, [["咩聲呀……邊個？", "發開夢？"]])])
	else:
		var _t4433 = env["__p"]["scareRes"]
		J.cl(_t4433, null, [v_r_4024, J.gp(env["P"], "f"), env["g"]])
		if J.cmp(J.cl(env["__p"]["rnd"], null, []), 0.6, "<"):
			var _t4434 = env["__p"]["say"]
			var _t4435 = env["__p"]["pick"]
			J.cl(_t4434, null, [v_r_4024, J.cl(_t4435, null, [J.gp(env["__p"]["PROPLINE"], J.gp(env["p"], "k"))])])

func _f669(this_, a: Array, env):
	var v_h_4027 = null
	v_h_4027 = J.arg(a, 0)
	var _t4445 = J.seq(J.gp(v_h_4027, "kind"), "guard")
	var _t4446 = (J.seq(J.gp(J.gp(J.gp(env["__p"]["G"], "nodes"), J.gp(v_h_4027, "node")), "f"), J.gp(env["nn"], "f")) if _t4445 else _t4445)
	var _t4447 = ((absf(J.num(J.sub(J.gp(v_h_4027, "x"), J.gp(env["nn"], "x")))) < 260.0) if _t4446 else _t4446)
	if ((not J.seq(J.gp(v_h_4027, "state"), "chase")) if _t4447 else _t4447):
		var _t4448 = env["__p"]["spook"]
		J.cl(_t4448, null, [v_h_4027, "盞燈……盞燈做咩閃成咁？！"])

func _f670(this_, a: Array, env):
	var v_l_4030 = null
	v_l_4030 = J.arg(a, 0)
	return J.gp(v_l_4030, "e")

func _f671(this_, a: Array, env):
	var v_e_4033 = null
	v_e_4033 = J.arg(a, 0)
	return J.gp(v_e_4033, "pipe")

func _f672(this_, a: Array, env):
	var v_h_4036 = null
	v_h_4036 = J.arg(a, 0)
	J.sp(v_h_4036, "path", null)
	J.sp(v_h_4036, "repath", 0.0)

func _f666(this_, a: Array, env):
	var v_a_4003 = null; var v_q_4004 = null; var v_ow_4005 = null; var v_un_4007 = null; var v_q2_4009 = null; var v_cp_4010 = null; var v_fs_4012 = null; var v_f_4013 = null; var v_tf_4014 = null; var v_ln_4015 = null; var v_e_4016 = null; var v_other_4017 = null; var v_fe_4018 = null
	var _s1606 = {"__p": env, "g": null, "p": null, "P": null, "nn": null}
	_s1606["g"] = J.gp(J.gp(_s1606["__p"]["G"], "gh"), J.gp(_s1606["__p"]["G"], "active"))
	var _t4409 = _s1606["__p"]["ctxAction"]
	v_a_4003 = J.cl(_t4409, null, [_s1606["g"]])
	if (not J.t(v_a_4003)):
		return null
	var _t4410 = _s1606["__p"]["standStill"]
	J.cl(_t4410, null, [_s1606["g"]])
	if J.t(J.gp(_s1606["g"], "to")):
		var _t4411 = _s1606["__p"]["float"]
		J.cl(_t4411, null, [J.gp(_s1606["g"], "x"), J.sub(J.gp(_s1606["g"], "y"), 80.0), "行到位先做得", "#ffd54a"])
		return null
	var _t4412 = _s1606["__p"]["calm"]
	J.cl(_t4412, null, [_s1606["g"]])
	if J.seq(J.gp(v_a_4003, "k"), "liftIn"):
		J.mc(_s1606["__p"]["LIFT"], "enter", [_s1606["g"]])
		return null
	if J.t((J.mc(_s1606["__p"]["UNIT"], "act", [_s1606["g"], v_a_4003]) if J.t(_s1606["__p"]["UNIT"]) else _s1606["__p"]["UNIT"])):
		return null
	if J.seq(J.gp(v_a_4003, "k"), "respect"):
		var _t4413 = _s1606["__p"]["float"]
		J.cl(_t4413, null, [J.gp(_s1606["g"], "x"), J.sub(J.gp(_s1606["g"], "y"), 90.0), "祖先牌位要尊重，我哋唔郁", "#e8d8b0"])
		return null
	if J.seq(J.gp(v_a_4003, "k"), "deliver"):
		v_q_4004 = J.gp(v_a_4003, "q")
		J.sp(v_q_4004, "state", 2.0)
		var _t4414 = _s1606["__p"]["G"]
		J.sp(_t4414, "carry", null)
		v_ow_4005 = J.gp(J.gp(v_q_4004, "owner"), "res")
		if J.t(v_ow_4005):
			var _t4415 = _s1606["__p"]["say"]
			J.cl(_t4415, null, [v_ow_4005, (J.add("咦？我副", J.gp(v_q_4004, "thing")) + "點解會喺張枱度嘅？多謝晒……")])
			J.sp(v_ow_4005, "fear", 0.0)
		var _t4416 = _s1606["__p"]["addFear"]
		J.cl(_t4416, null, [25.0, J.gp(_s1606["g"], "x"), J.sub(J.gp(_s1606["g"], "y"), 90.0)])
		var _t4417 = J.gp(_s1606["__p"]["G"], "gh")
		J.mc(_t4417, "forEach", [Callable(self, "_f667").bind(_s1606)])
		var _t4419 = _s1606["__p"]["float"]
		J.cl(_t4419, null, [J.gp(_s1606["g"], "x"), J.sub(J.gp(_s1606["g"], "y"), 120.0), J.add("支線完成：", J.gp(v_q_4004, "t")), "#8affc8"])
		J.cl(_s1606["__p"]["giveStory"], null, [])
		var _t4420 = _s1606["__p"]["toast"]
		J.cl(_t4420, null, [(J.add("支線完成！", J.gp(v_q_4004, "t")) + "——怕意 +25、三隻鬼能量 +30。")])
		return null
	if J.seq(J.gp(v_a_4003, "k"), "prop"):
		_s1606["p"] = J.gp(v_a_4003, "p")
		v_un_4007 = J.gp(v_a_4003, "un")
		_s1606["P"] = J.gp(_s1606["__p"]["PROP"], J.gp(_s1606["p"], "k"))
		if J.cmp(J.gp(_s1606["__p"]["G"], "lureCd"), 0.0, ">"):
			return null
		var _t4421 = _s1606["p"]
		J.sp(_t4421, "t", 3.0)
		var _t4422 = _s1606["p"]
		J.sp(_t4422, "cd", 18.0)
		var _t4423 = _s1606["__p"]["G"]
		J.sp(_t4423, "lureCd", 1.5)
		var _t4424 = _s1606["g"]
		J.sp(_t4424, "actT", 0.9)
		var _t4425 = _s1606["g"]
		var _t4426 = (1.0 if J.cmp(J.gp(_s1606["p"], "x"), J.gp(_s1606["g"], "x"), ">") else (-1.0))
		J.sp(_t4425, "dir", _t4426)
		var _t4427 = J.gp(v_un_4007, "rs")
		J.mc(_t4427, "forEach", [Callable(self, "_f668").bind(_s1606)])
		if J.seq(J.gp(_s1606["p"], "k"), "mahjong"):
			v_q2_4009 = 0.0
			while true:
				if not J.cmp(v_q2_4009, 10.0, "<"): break
				var _t4436 = _s1606["__p"]["part"]
				J.cl(_t4436, null, [J.gp(_s1606["p"], "x"), J.sub(J.gp(v_un_4007, "y"), 40.0), (J.sub(J.cl(_s1606["__p"]["rnd"], null, []), 0.5) * 90.0), ((-60.0) - J.mul(J.cl(_s1606["__p"]["rnd"], null, []), 40.0)), 0.8, "paper"])
				v_q2_4009 = J.num(v_q2_4009) + 1.0
		var _t4437 = _s1606["__p"]["float"]
		J.cl(_t4437, null, [J.gp(_s1606["p"], "x"), J.sub(J.gp(v_un_4007, "y"), 96.0), J.add(J.gp(_s1606["P"], "v"), "！"), "#ffb7a0"])
		var _t4438 = _s1606["__p"]["noise"]
		J.cl(_t4438, null, [J.gp(v_un_4007, "did"), J.gp(_s1606["P"], "lv"), J.gp(_s1606["P"], "n")])
		J.cl(_s1606["__p"]["lureCost"], null, [])
		var _t4439 = _s1606["g"]
		var _t4440 = J.min_([100.0, J.add(J.gp(_s1606["g"], "energy"), 8.0)])
		J.sp(_t4439, "energy", _t4440)
		return null
	if J.seq(J.gp(v_a_4003, "k"), "cprop"):
		v_cp_4010 = J.gp(v_a_4003, "p")
		J.sp(v_cp_4010, "t", 3.0)
		J.sp(v_cp_4010, "cd", 20.0)
		J.cl(_s1606["__p"]["lureCost"], null, [])
		_s1606["nn"] = J.gp(J.gp(_s1606["__p"]["G"], "nodes"), J.gp(v_cp_4010, "node"))
		if J.seq(J.gp(v_cp_4010, "k"), "pipeK"):
			var _t4441 = _s1606["__p"]["float"]
			J.cl(_t4441, null, [J.gp(_s1606["nn"], "x"), J.sub(J.gp(_s1606["nn"], "y"), 90.0), "噹！噹！噹！", "#ffd54a"])
			var _t4442 = _s1606["__p"]["noise"]
			J.cl(_t4442, null, [J.gp(v_cp_4010, "node"), 2.0])
		else:
			var _t4443 = _s1606["__p"]["float"]
			J.cl(_t4443, null, [J.gp(_s1606["nn"], "x"), J.sub(J.gp(_s1606["nn"], "y"), 90.0), "走廊燈閃閃吓……", "#ffd54a"])
			var _t4444 = J.gp(_s1606["__p"]["G"], "guards")
			J.mc(_t4444, "forEach", [Callable(self, "_f669").bind(_s1606)])
			var _t4449 = _s1606["__p"]["noise"]
			J.cl(_t4449, null, [J.gp(v_cp_4010, "node"), 1.0])
		return null
	if J.seq(J.gp(v_a_4003, "k"), "lift"):
		var _t4450 = _s1606["__p"]["G"]
		J.sp(_t4450, "liftCd", 16.0)
		J.cl(_s1606["__p"]["lureCost"], null, [])
		v_fs_4012 = []
		v_f_4013 = 0.0
		while true:
			if not J.cmp(v_f_4013, _s1606["__p"]["FL"], "<"): break
			if (absf(J.num(J.sub(v_f_4013, J.gp(J.gp(J.gp(_s1606["__p"]["G"], "nodes"), J.gp(_s1606["g"], "node")), "f")))) >= 2.0):
				J.mc(v_fs_4012, "push", [v_f_4013])
			v_f_4013 = J.num(v_f_4013) + 1.0
		var _t4451 = _s1606["__p"]["pick"]
		v_tf_4014 = J.cl(_t4451, null, [(v_fs_4012 if J.t(J.len(v_fs_4012)) else [0.0])])
		v_ln_4015 = (J.add("f", v_tf_4014) + "_l")
		var _t4452 = _s1606["__p"]["G"]
		var _t4453 = {"f": v_tf_4014, "t": 2.5}
		J.sp(_t4452, "liftFx", _t4453)
		var _t4454 = _s1606["__p"]["float"]
		J.cl(_t4454, null, [J.gp(_s1606["g"], "x"), J.sub(J.gp(_s1606["g"], "y"), 90.0), (J.add("部𨋢自己落咗去", J.gp(_s1606["__p"]["FLN"], v_tf_4014)) + "……"), "#ffd54a"])
		var _t4455 = _s1606["__p"]["noise"]
		J.cl(_t4455, null, [v_ln_4015, 3.0])
		return null
	if J.seq(J.gp(v_a_4003, "k"), "pipeN"):
		if J.cmp(J.gp(_s1606["__p"]["G"], "lureCd"), 0.0, ">"):
			return null
		var _t4456 = _s1606["__p"]["G"]
		J.sp(_t4456, "lureCd", 6.0)
		J.cl(_s1606["__p"]["lureCost"], null, [])
		var _t4457 = J.gp(J.gp(J.gp(_s1606["__p"]["G"], "nodes"), J.gp(_s1606["g"], "node")), "links")
		var _t4458 = J.mc(_t4457, "map", [Callable(self, "_f670").bind(_s1606)])
		v_e_4016 = J.mc(_t4458, "find", [Callable(self, "_f671").bind(_s1606)])
		v_other_4017 = (J.gp(v_e_4016, "b") if J.seq(J.gp(v_e_4016, "a"), J.gp(_s1606["g"], "node")) else J.gp(v_e_4016, "a"))
		var _t4459 = _s1606["__p"]["float"]
		J.cl(_t4459, null, [J.gp(_s1606["g"], "x"), J.sub(J.gp(_s1606["g"], "y"), 90.0), (J.add("噹……（", J.gp(_s1606["__p"]["FLN"], J.gp(J.gp(J.gp(_s1606["__p"]["G"], "nodes"), v_other_4017), "f"))) + "都聽到）"), "#ffd54a"])
		var _t4460 = _s1606["__p"]["noise"]
		J.cl(_t4460, null, [v_other_4017, 2.0])
		return null
	if J.seq(J.gp(v_a_4003, "k"), "fire"):
		v_fe_4018 = J.gp(v_a_4003, "e")
		var _t4461 = J.gp(v_fe_4018, "fire")
		J.sp(_t4461, "shut", 14.0)
		var _t4462 = J.gp(v_fe_4018, "fire")
		J.sp(_t4462, "cd", 26.0)
		var _t4463 = _s1606["__p"]["float"]
		J.cl(_t4463, null, [J.gp(_s1606["g"], "x"), J.sub(J.gp(_s1606["g"], "y"), 90.0), "防煙門閂咗！保安要兜路", "#9fd6bf"])
		var _t4464 = J.gp(_s1606["__p"]["G"], "guards")
		J.mc(_t4464, "forEach", [Callable(self, "_f672").bind(_s1606)])
		return null

func _f673(this_, a: Array, env):
	var v_i_4039 = null
	v_i_4039 = 0.0
	while true:
		if not J.cmp(v_i_4039, J.len(env["STORY"]), "<"): break
		var _t4465 = J.gp(env["G"], "story")
		if J.cmp(J.mc(_t4465, "indexOf", [v_i_4039]), 0.0, "<"):
			var _t4466 = J.gp(env["G"], "story")
			J.mc(_t4466, "push", [v_i_4039])
			J.mc(J.gp(env["G"], "story"), "sort", [])
			var _t4467 = env["toast"]
			J.cl(_t4467, null, [J.add("收集到故事碎片——", J.gp(env["STORY"], v_i_4039))])
			return null
		v_i_4039 = J.num(v_i_4039) + 1.0

func _f676(this_, a: Array, env):
	var v_r_4049 = null
	v_r_4049 = J.arg(a, 0)
	if J.seq(J.gp(v_r_4049, "state"), "home"):
		var _t4482 = J.min_([90.0, J.add(J.gp(v_r_4049, "fear"), 4.0)])
		J.sp(v_r_4049, "fear", _t4482)

func _f677(this_, a: Array, env):
	var v_r_4052 = null
	v_r_4052 = J.arg(a, 0)
	if J.seq(J.gp(v_r_4052, "state"), "home"):
		J.sp(v_r_4052, "fear", 0.0)
		var _t4486 = env["__p"]["say"]
		J.cl(_t4486, null, [v_r_4052, "佢……佢走咗？好似有人幫緊我哋……"])

func _f678(this_, a: Array, env):
	var v_r_4055 = null
	v_r_4055 = J.arg(a, 0)
	return (not J.seq(J.gp(v_r_4055, "state"), "home"))

func _f675(this_, a: Array, env):
	var v_q_4045 = null; var v_h_4046 = null
	v_q_4045 = J.arg(a, 0)
	if J.seq(J.gp(v_q_4045, "id"), "debt"):
		var _t4470 = J.seq(J.gp(v_q_4045, "state"), 0.0)
		if (J.cmp(J.gp(env["__p"]["G"], "t"), J.gp(v_q_4045, "at"), ">=") if _t4470 else _t4470):
			J.sp(v_q_4045, "state", 1.0)
			var _t4471 = env["__p"]["mkHuman"]
			v_h_4046 = J.cl(_t4471, null, ["collector", J.gp(J.gp(v_q_4045, "unit"), "did"), {"courage": 3.0, "real": true}])
			J.sp(v_h_4046, "wait", 1000000000.0)
			var _t4472 = J.gp(env["__p"]["G"], "guards")
			J.mc(_t4472, "push", [v_h_4046])
			J.sp(v_q_4045, "h", v_h_4046)
			var _t4473 = env["__p"]["toast"]
			J.cl(_t4473, null, [J.add(J.gp(env["__p"]["FLN"], J.gp(J.gp(v_q_4045, "unit"), "f")), "有個收數佬拍門大嗌，屋企人嚇到唔敢出聲……嚇走佢！")])
		if J.seq(J.gp(v_q_4045, "state"), 1.0):
			v_h_4046 = J.gp(v_q_4045, "h")
			var _t4474 = J.gp(v_h_4046, "bangT")
			var _t4475 = J.sub((_t4474 if J.t(_t4474) else 0.0), env["dt"])
			J.sp(v_h_4046, "bangT", _t4475)
			var _t4476 = J.cmp(J.gp(v_h_4046, "bangT"), 0.0, "<=")
			if ((not J.seq(J.gp(v_h_4046, "state"), "flee")) if _t4476 else _t4476):
				J.sp(v_h_4046, "bangT", 3.2)
				var _t4477 = env["__p"]["pick"]
				var _t4478 = J.cl(_t4477, null, [["開門呀！還錢呀！", "我知你喺入面！", "唔還錢就淋紅油！"]])
				J.sp(v_h_4046, "say", _t4478)
				J.sp(v_h_4046, "sayT", 2.4)
				var _t4479 = env["__p"]["G"]
				var _t4480 = J.max_([J.gp(env["__p"]["G"], "shake"), 0.12])
				J.sp(_t4479, "shake", _t4480)
				var _t4481 = J.gp(J.gp(v_q_4045, "unit"), "rs")
				J.mc(_t4481, "forEach", [Callable(self, "_f676").bind(env)])
			var _t4483 = J.seq(J.gp(v_h_4046, "state"), "flee")
			if (_t4483 if _t4483 else J.seq(J.gp(v_h_4046, "state"), "gone")):
				J.sp(v_q_4045, "state", 2.0)
				var _t4484 = J.gp(J.gp(v_q_4045, "unit"), "items")
				J.mc(_t4484, "push", ["money", "money"])
				var _t4485 = J.gp(J.gp(v_q_4045, "unit"), "rs")
				J.mc(_t4485, "forEach", [Callable(self, "_f677").bind(env)])
				var _t4487 = env["__p"]["addFear"]
				J.cl(_t4487, null, [30.0, J.gp(J.gp(v_q_4045, "unit"), "x"), J.sub(J.gp(J.gp(v_q_4045, "unit"), "y"), 100.0)])
				var _t4488 = env["__p"]["float"]
				J.cl(_t4488, null, [J.gp(J.gp(v_q_4045, "unit"), "x"), J.sub(J.gp(J.gp(v_q_4045, "unit"), "y"), 130.0), J.add("支線完成：", J.gp(v_q_4045, "t")), "#8affc8"])
				J.cl(env["__p"]["giveStory"], null, [])
				var _t4489 = env["__p"]["toast"]
				J.cl(_t4489, null, ["收數佬嚇到碌落樓梯！佢跌低咗個銀包喺門口。"])
	var _t4490 = J.seq(J.gp(v_q_4045, "id"), "mj")
	var _t4492 = (J.seq(J.gp(v_q_4045, "state"), 0.0) if _t4490 else _t4490)
	if J.t(_t4492):
		var _t4491 = J.gp(J.gp(v_q_4045, "unit"), "rs")
		_t4492 = J.mc(_t4491, "every", [Callable(self, "_f678").bind(env)])
	if J.t(_t4492):
		J.sp(v_q_4045, "state", 2.0)
		var _t4493 = env["__p"]["addFear"]
		J.cl(_t4493, null, [20.0, J.gp(J.gp(v_q_4045, "unit"), "x"), J.sub(J.gp(J.gp(v_q_4045, "unit"), "y"), 100.0)])
		var _t4494 = J.gp(J.gp(v_q_4045, "unit"), "items")
		J.mc(_t4494, "push", ["money"])
		var _t4495 = env["__p"]["float"]
		J.cl(_t4495, null, [J.gp(J.gp(v_q_4045, "unit"), "x"), J.sub(J.gp(J.gp(v_q_4045, "unit"), "y"), 130.0), J.add("支線完成：", J.gp(v_q_4045, "t")), "#8affc8"])
		J.cl(env["__p"]["giveStory"], null, [])
	var _t4496 = J.seq(J.gp(v_q_4045, "id"), "lost")
	var _t4497 = (J.seq(J.gp(v_q_4045, "state"), 0.0) if _t4496 else _t4496)
	if (J.seq(J.gp(env["__p"]["G"], "carry"), "lost") if _t4497 else _t4497):
		J.sp(v_q_4045, "state", 1.0)

func _f674(this_, a: Array, env):
	var _s1633 = {"__p": env, "dt": null}
	_s1633["dt"] = J.arg(a, 0)
	var _t4468 = J.gp(_s1633["__p"]["G"], "quests")
	var _t4469 = (_t4468 if J.t(_t4468) else [])
	J.mc(_t4469, "forEach", [Callable(self, "_f675").bind(_s1633)])

func _f681(this_, a: Array, env):
	var v_p_4064 = null; var v_x_4065 = null; var v_y_4066 = null; var v_a_4067 = null; var v_T_4068 = null; var v_i_4069 = null; var v_o_4070 = null
	v_p_4064 = J.arg(a, 0)
	v_x_4065 = J.gp(v_p_4064, "x")
	v_y_4066 = J.sub(J.gp(env["u"], "y"), 4.0)
	v_a_4067 = J.cmp(J.gp(v_p_4064, "t"), 0.0, ">")
	v_T_4068 = J.gp(env["__p"]["G"], "t")
	if J.seq(J.gp(v_p_4064, "k"), "tv"):
		var _t4501 = env["__p"]["ctx"]
		J.sp(_t4501, "fillStyle", "#1a1a1e")
		J.mc(env["__p"]["ctx"], "fillRect", [J.sub(v_x_4065, 14.0), J.sub(v_y_4066, 40.0), 28.0, 20.0])
		var _t4502 = env["__p"]["ctx"]
		var _t4503 = ((J.add("rgba(220,230,240,", (0.5 + (0.5 * randf()))) + ")") if J.t(v_a_4067) else "#2a3440")
		J.sp(_t4502, "fillStyle", _t4503)
		J.mc(env["__p"]["ctx"], "fillRect", [J.sub(v_x_4065, 12.0), J.sub(v_y_4066, 38.0), 24.0, 16.0])
		if J.t(v_a_4067):
			var _t4504 = env["__p"]["ctx"]
			J.sp(_t4504, "fillStyle", "rgba(20,20,20,0.7)")
			J.mc(env["__p"]["ctx"], "beginPath", [])
			J.mc(env["__p"]["ctx"], "arc", [v_x_4065, J.sub(v_y_4066, 30.0), 5.0, 0.0, 7.0])
			J.mc(env["__p"]["ctx"], "fill", [])
		var _t4505 = env["__p"]["ctx"]
		J.sp(_t4505, "fillStyle", "#4a3424")
		J.mc(env["__p"]["ctx"], "fillRect", [J.sub(v_x_4065, 10.0), J.sub(v_y_4066, 20.0), 20.0, 16.0])
	else:
		if J.seq(J.gp(v_p_4064, "k"), "fan"):
			var _t4506 = env["__p"]["ctx"]
			J.sp(_t4506, "strokeStyle", "#bbb")
			var _t4507 = env["__p"]["ctx"]
			J.sp(_t4507, "lineWidth", 2.0)
			J.mc(env["__p"]["ctx"], "beginPath", [])
			J.mc(env["__p"]["ctx"], "moveTo", [v_x_4065, v_y_4066])
			J.mc(env["__p"]["ctx"], "lineTo", [v_x_4065, J.sub(v_y_4066, 30.0)])
			J.mc(env["__p"]["ctx"], "stroke", [])
			J.mc(env["__p"]["ctx"], "save", [])
			J.mc(env["__p"]["ctx"], "translate", [v_x_4065, J.sub(v_y_4066, 34.0)])
			J.mc(env["__p"]["ctx"], "rotate", [J.mul(v_T_4068, (40.0 if J.t(v_a_4067) else 6.0))])
			v_i_4069 = 0.0
			while true:
				if not J.cmp(v_i_4069, 3.0, "<"): break
				J.mc(env["__p"]["ctx"], "rotate", [2.094])
				var _t4508 = env["__p"]["ctx"]
				J.sp(_t4508, "fillStyle", "rgba(200,210,220,0.8)")
				J.mc(env["__p"]["ctx"], "fillRect", [0.0, (-2.0), 9.0, 4.0])
				v_i_4069 = J.num(v_i_4069) + 1.0
			J.mc(env["__p"]["ctx"], "restore", [])
			var _t4509 = env["__p"]["ctx"]
			J.sp(_t4509, "strokeStyle", "#888")
			J.mc(env["__p"]["ctx"], "beginPath", [])
			J.mc(env["__p"]["ctx"], "arc", [v_x_4065, J.sub(v_y_4066, 34.0), 10.0, 0.0, 7.0])
			J.mc(env["__p"]["ctx"], "stroke", [])
		else:
			if J.seq(J.gp(v_p_4064, "k"), "fridge"):
				var _t4510 = env["__p"]["ctx"]
				J.sp(_t4510, "fillStyle", "#7d8786")
				J.mc(env["__p"]["ctx"], "fillRect", [J.sub(v_x_4065, 9.0), J.sub(v_y_4066, 40.0), 18.0, 38.0])
				var _t4511 = env["__p"]["ctx"]
				J.sp(_t4511, "fillStyle", "rgba(255,255,255,0.12)")
				J.mc(env["__p"]["ctx"], "fillRect", [J.sub(v_x_4065, 9.0), J.sub(v_y_4066, 40.0), 5.0, 38.0])
				var _t4512 = env["__p"]["ctx"]
				J.sp(_t4512, "strokeStyle", "#2a2e2e")
				var _t4513 = env["__p"]["ctx"]
				J.sp(_t4513, "lineWidth", 1.5)
				J.mc(env["__p"]["ctx"], "strokeRect", [J.sub(v_x_4065, 9.0), J.sub(v_y_4066, 40.0), 18.0, 38.0])
				J.mc(env["__p"]["ctx"], "beginPath", [])
				J.mc(env["__p"]["ctx"], "moveTo", [J.sub(v_x_4065, 9.0), J.sub(v_y_4066, 26.0)])
				J.mc(env["__p"]["ctx"], "lineTo", [J.add(v_x_4065, 9.0), J.sub(v_y_4066, 26.0)])
				J.mc(env["__p"]["ctx"], "stroke", [])
				var _t4514 = env["__p"]["ctx"]
				J.sp(_t4514, "fillStyle", "#c8c8c0")
				J.mc(env["__p"]["ctx"], "fillRect", [J.add(v_x_4065, 5.0), J.sub(v_y_4066, 36.0), 2.0, 7.0])
				if J.t(v_a_4067):
					v_o_4070 = (absf(J.num(sin(J.num(J.mul(v_T_4068, 9.0))))) * 16.0)
					var _t4515 = env["__p"]["ctx"]
					J.sp(_t4515, "fillStyle", "#b8c0c0")
					J.mc(env["__p"]["ctx"], "fillRect", [J.add(v_x_4065, 10.0), J.sub(v_y_4066, 46.0), v_o_4070, 30.0])
					var _t4516 = env["__p"]["ctx"]
					J.sp(_t4516, "fillStyle", "rgba(200,240,255,0.5)")
					J.mc(env["__p"]["ctx"], "fillRect", [J.sub(v_x_4065, 8.0), J.sub(v_y_4066, 44.0), 16.0, 26.0])
			else:
				if J.seq(J.gp(v_p_4064, "k"), "pc"):
					var _t4517 = env["__p"]["ctx"]
					J.sp(_t4517, "fillStyle", "#202428")
					J.mc(env["__p"]["ctx"], "fillRect", [J.sub(v_x_4065, 13.0), J.sub(v_y_4066, 38.0), 26.0, 18.0])
					var _t4518 = env["__p"]["ctx"]
					var _t4519 = (("#e8e8e8" if J.t(J.mod(floor(J.num(J.mul(v_T_4068, 8.0))), 2.0)) else "#d02020") if J.t(v_a_4067) else "#3a6ad0")
					J.sp(_t4518, "fillStyle", _t4519)
					J.mc(env["__p"]["ctx"], "fillRect", [J.sub(v_x_4065, 11.0), J.sub(v_y_4066, 36.0), 22.0, 14.0])
					if J.t(v_a_4067):
						var _t4520 = env["__p"]["ctx"]
						J.sp(_t4520, "fillStyle", "#000")
						J.mc(env["__p"]["ctx"], "fillRect", [J.sub(v_x_4065, 5.0), J.sub(v_y_4066, 32.0), 3.0, 3.0])
						J.mc(env["__p"]["ctx"], "fillRect", [J.add(v_x_4065, 2.0), J.sub(v_y_4066, 32.0), 3.0, 3.0])
						J.mc(env["__p"]["ctx"], "fillRect", [J.sub(v_x_4065, 4.0), J.sub(v_y_4066, 26.0), 8.0, 2.0])
					var _t4521 = env["__p"]["ctx"]
					J.sp(_t4521, "fillStyle", "#4a3424")
					J.mc(env["__p"]["ctx"], "fillRect", [J.sub(v_x_4065, 16.0), J.sub(v_y_4066, 20.0), 32.0, 4.0])
				else:
					if J.seq(J.gp(v_p_4064, "k"), "radio"):
						var _t4522 = env["__p"]["ctx"]
						J.sp(_t4522, "fillStyle", "#8a5a3a")
						J.mc(env["__p"]["ctx"], "fillRect", [J.sub(v_x_4065, 10.0), J.sub(v_y_4066, 26.0), 20.0, 12.0])
						var _t4523 = env["__p"]["ctx"]
						J.sp(_t4523, "fillStyle", "#ffd54a")
						J.mc(env["__p"]["ctx"], "fillRect", [J.add(v_x_4065, 3.0), J.sub(v_y_4066, 23.0), 4.0, 4.0])
						if J.t(v_a_4067):
							var _t4524 = env["__p"]["ctx"]
							J.sp(_t4524, "fillStyle", "#ffe9a0")
							var _t4525 = env["__p"]["ctx"]
							var _t4526 = J.add("bold 12px ", env["__p"]["FONT"])
							J.sp(_t4525, "font", _t4526)
							var _t4527 = env["__p"]["ctx"]
							J.sp(_t4527, "textAlign", "center")
							J.mc(env["__p"]["ctx"], "fillText", ["♪", (J.sub(v_x_4065, 8.0) + (sin(J.num(J.mul(v_T_4068, 5.0))) * 6.0)), (J.sub(v_y_4066, 34.0) - J.mod(J.mul(v_T_4068, 30.0), 14.0))])
							J.mc(env["__p"]["ctx"], "fillText", ["♫", J.add(v_x_4065, 8.0), (J.sub(v_y_4066, 30.0) - J.mod((J.mul(v_T_4068, 30.0) + 7.0), 14.0))])
					else:
						if J.seq(J.gp(v_p_4064, "k"), "phone"):
							var _t4528 = env["__p"]["ctx"]
							J.sp(_t4528, "fillStyle", "#202428")
							J.mc(env["__p"]["ctx"], "fillRect", [J.sub(v_x_4065, 4.0), J.sub(v_y_4066, 22.0), 8.0, 12.0])
							if J.t(v_a_4067):
								var _t4529 = env["__p"]["ctx"]
								J.sp(_t4529, "strokeStyle", "rgba(159,224,255,0.8)")
								var _t4530 = env["__p"]["ctx"]
								J.sp(_t4530, "lineWidth", 1.5)
								v_i_4069 = 0.0
								while true:
									if not J.cmp(v_i_4069, 2.0, "<"): break
									J.mc(env["__p"]["ctx"], "beginPath", [])
									J.mc(env["__p"]["ctx"], "arc", [v_x_4065, J.sub(v_y_4066, 16.0), ((7.0 + J.mul(v_i_4069, 5.0)) + J.mod(J.mul(v_T_4068, 20.0), 5.0)), (-0.8), 0.8])
									J.mc(env["__p"]["ctx"], "stroke", [])
									v_i_4069 = J.num(v_i_4069) + 1.0
						else:
							if J.seq(J.gp(v_p_4064, "k"), "mahjong"):
								var _t4531 = env["__p"]["ctx"]
								J.sp(_t4531, "fillStyle", "#2a6a3a")
								J.mc(env["__p"]["ctx"], "fillRect", [J.sub(v_x_4065, 22.0), J.sub(v_y_4066, 24.0), 44.0, 6.0])
								var _t4532 = env["__p"]["ctx"]
								J.sp(_t4532, "fillStyle", "#4a3424")
								J.mc(env["__p"]["ctx"], "fillRect", [J.sub(v_x_4065, 20.0), J.sub(v_y_4066, 18.0), 4.0, 14.0])
								J.mc(env["__p"]["ctx"], "fillRect", [J.add(v_x_4065, 16.0), J.sub(v_y_4066, 18.0), 4.0, 14.0])
								v_i_4069 = 0.0
								while true:
									if not J.cmp(v_i_4069, 8.0, "<"): break
									var _t4533 = env["__p"]["ctx"]
									J.sp(_t4533, "fillStyle", "#f0ead8")
									J.mc(env["__p"]["ctx"], "fillRect", [(J.sub(v_x_4065, 18.0) + J.mul(v_i_4069, 4.6)), (J.sub(v_y_4066, 28.0) - ((absf(J.num(sin(J.num(J.add(J.mul(v_T_4068, 14.0), v_i_4069))))) * 6.0) if J.t(v_a_4067) else 0.0)), 3.6, 4.0])
									v_i_4069 = J.num(v_i_4069) + 1.0
							else:
								if J.seq(J.gp(v_p_4064, "k"), "doorbell"):
									var _t4534 = env["__p"]["ctx"]
									J.sp(_t4534, "fillStyle", "#c8a050")
									J.mc(env["__p"]["ctx"], "beginPath", [])
									J.mc(env["__p"]["ctx"], "arc", [J.add(J.gp(env["u"], "x"), 16.0), J.sub(v_y_4066, 52.0), 3.0, 0.0, 7.0])
									J.mc(env["__p"]["ctx"], "fill", [])
									var _t4535 = env["__p"]["ctx"]
									J.sp(_t4535, "fillStyle", "#a07040")
									v_i_4069 = 0.0
									while true:
										if not J.cmp(v_i_4069, 3.0, "<"): break
										J.mc(env["__p"]["ctx"], "fillRect", [(J.sub(v_x_4065, 14.0) + J.mul(v_i_4069, 9.0)), (J.sub(v_y_4066, 10.0) - (J.mod(v_i_4069, 2.0) * 8.0)), 10.0, 8.0])
										v_i_4069 = J.num(v_i_4069) + 1.0
									if J.t(v_a_4067):
										var _t4536 = env["__p"]["ctx"]
										J.sp(_t4536, "fillStyle", "#ffd54a")
										var _t4537 = env["__p"]["ctx"]
										var _t4538 = J.add("bold 11px ", env["__p"]["FONT"])
										J.sp(_t4537, "font", _t4538)
										var _t4539 = env["__p"]["ctx"]
										J.sp(_t4539, "textAlign", "center")
										J.mc(env["__p"]["ctx"], "fillText", ["叮噹", J.add(J.gp(env["u"], "x"), 16.0), J.sub(v_y_4066, 60.0)])
								else:
									if J.seq(J.gp(v_p_4064, "k"), "washer"):
										var _t4540 = env["__p"]["ctx"]
										J.sp(_t4540, "fillStyle", "#e8e8e2")
										J.mc(env["__p"]["ctx"], "fillRect", [J.sub(v_x_4065, 12.0), J.sub(v_y_4066, 30.0), 24.0, 28.0])
										var _t4541 = env["__p"]["ctx"]
										J.sp(_t4541, "strokeStyle", "#777")
										var _t4542 = env["__p"]["ctx"]
										J.sp(_t4542, "lineWidth", 1.0)
										J.mc(env["__p"]["ctx"], "strokeRect", [J.sub(v_x_4065, 12.0), J.sub(v_y_4066, 30.0), 24.0, 28.0])
										J.mc(env["__p"]["ctx"], "save", [])
										J.mc(env["__p"]["ctx"], "translate", [v_x_4065, J.sub(v_y_4066, 15.0)])
										J.mc(env["__p"]["ctx"], "rotate", [(J.mul(v_T_4068, 20.0) if J.t(v_a_4067) else 0.0)])
										var _t4543 = env["__p"]["ctx"]
										J.sp(_t4543, "fillStyle", "#6a8aa8")
										J.mc(env["__p"]["ctx"], "beginPath", [])
										J.mc(env["__p"]["ctx"], "arc", [0.0, 0.0, 8.0, 0.0, 7.0])
										J.mc(env["__p"]["ctx"], "fill", [])
										var _t4544 = env["__p"]["ctx"]
										J.sp(_t4544, "fillStyle", "#e8e2d0")
										J.mc(env["__p"]["ctx"], "fillRect", [(-2.0), (-7.0), 4.0, 6.0])
										J.mc(env["__p"]["ctx"], "restore", [])
									else:
										var _t4545 = J.seq(J.gp(v_p_4064, "k"), "kettle")
										if (_t4545 if _t4545 else J.seq(J.gp(v_p_4064, "k"), "rice")):
											var _t4546 = env["__p"]["ctx"]
											var _t4547 = ("#b8bcc0" if J.seq(J.gp(v_p_4064, "k"), "kettle") else "#e8e2d0")
											J.sp(_t4546, "fillStyle", _t4547)
											J.mc(env["__p"]["ctx"], "beginPath", [])
											J.mc(env["__p"]["ctx"], "ellipse", [v_x_4065, J.sub(v_y_4066, 26.0), 8.0, 7.0, 0.0, 0.0, 7.0])
											J.mc(env["__p"]["ctx"], "fill", [])
											if J.t(v_a_4067):
												v_i_4069 = 0.0
												while true:
													if not J.cmp(v_i_4069, 2.0, "<"): break
													var _t4548 = env["__p"]["ctx"]
													J.sp(_t4548, "fillStyle", "rgba(230,230,230,0.5)")
													J.mc(env["__p"]["ctx"], "beginPath", [])
													J.mc(env["__p"]["ctx"], "arc", [J.add(v_x_4065, (6.0 if J.t(v_i_4069) else (-2.0))), (J.sub(v_y_4066, 36.0) - J.mod((J.mul(v_T_4068, 30.0) + J.mul(v_i_4069, 8.0)), 16.0)), 3.0, 0.0, 7.0])
													J.mc(env["__p"]["ctx"], "fill", [])
													v_i_4069 = J.num(v_i_4069) + 1.0
										else:
											if J.seq(J.gp(v_p_4064, "k"), "ancestor"):
												var _t4549 = env["__p"]["ctx"]
												J.sp(_t4549, "fillStyle", "#6a1a16")
												J.mc(env["__p"]["ctx"], "fillRect", [J.sub(v_x_4065, 9.0), J.sub(v_y_4066, 56.0), 18.0, 22.0])
												var _t4550 = env["__p"]["ctx"]
												J.sp(_t4550, "fillStyle", "#ffd54a")
												J.mc(env["__p"]["ctx"], "fillRect", [J.sub(v_x_4065, 6.0), J.sub(v_y_4066, 53.0), 12.0, 3.0])
												var _t4551 = env["__p"]["ctx"]
												var _t4552 = (0.35 + (0.15 * sin(J.num(J.mul(v_T_4068, 3.0)))))
												J.sp(_t4551, "globalAlpha", _t4552)
												var _t4553 = env["__p"]["ctx"]
												J.sp(_t4553, "fillStyle", "#ff8a5a")
												J.mc(env["__p"]["ctx"], "beginPath", [])
												J.mc(env["__p"]["ctx"], "arc", [v_x_4065, J.sub(v_y_4066, 30.0), 4.0, 0.0, 7.0])
												J.mc(env["__p"]["ctx"], "fill", [])
												var _t4554 = env["__p"]["ctx"]
												J.sp(_t4554, "globalAlpha", 1.0)
	if J.t(((not J.seq(J.gp(v_p_4064, "k"), "ancestor")) if J.t(v_a_4067) else v_a_4067)):
		var _t4555 = env["__p"]["ctx"]
		var _t4556 = (J.add("rgba(138,255,200,", J.div(J.mul(0.4, J.gp(v_p_4064, "t")), 3.0)) + ")")
		J.sp(_t4555, "strokeStyle", _t4556)
		var _t4557 = env["__p"]["ctx"]
		J.sp(_t4557, "lineWidth", 2.0)
		J.mc(env["__p"]["ctx"], "beginPath", [])
		J.mc(env["__p"]["ctx"], "arc", [v_x_4065, J.sub(v_y_4066, 28.0), (22.0 + (J.sub(3.0, J.gp(v_p_4064, "t")) * 10.0)), 0.0, 7.0])
		J.mc(env["__p"]["ctx"], "stroke", [])

func _f680(this_, a: Array, env):
	var _s1647 = {"__p": env, "u": null}
	_s1647["u"] = J.arg(a, 0)
	var _t4499 = (not J.t(J.gp(_s1647["u"], "seen")))
	if ((not J.t(J.gp(_s1647["u"], "entered"))) if _t4499 else _t4499):
		return null
	var _t4500 = J.gp(_s1647["u"], "props")
	J.mc(_t4500, "forEach", [Callable(self, "_f681").bind(_s1647)])

func _f682(this_, a: Array, env):
	var v_p_4073 = null; var v_n_4074 = null; var v_x_4075 = null; var v_y_4076 = null; var v_i_4077 = null; var v_on_4078 = null; var v_gr_4079 = null
	v_p_4073 = J.arg(a, 0)
	v_n_4074 = J.gp(J.gp(env["G"], "nodes"), J.gp(v_p_4073, "node"))
	v_x_4075 = J.add(J.gp(v_n_4074, "x"), 22.0)
	v_y_4076 = J.gp(v_n_4074, "y")
	if J.seq(J.gp(v_p_4073, "k"), "pipeK"):
		var _t4560 = env["ctx"]
		J.sp(_t4560, "strokeStyle", "#7a8a86")
		var _t4561 = env["ctx"]
		J.sp(_t4561, "lineWidth", 3.0)
		J.mc(env["ctx"], "beginPath", [])
		J.mc(env["ctx"], "moveTo", [v_x_4075, J.sub(v_y_4076, 110.0)])
		J.mc(env["ctx"], "lineTo", [v_x_4075, J.sub(v_y_4076, 6.0)])
		J.mc(env["ctx"], "stroke", [])
		if J.cmp(J.gp(v_p_4073, "t"), 0.0, ">"):
			var _t4562 = env["ctx"]
			var _t4563 = (J.add("rgba(255,213,74,", J.div(J.gp(v_p_4073, "t"), 3.0)) + ")")
			J.sp(_t4562, "strokeStyle", _t4563)
			v_i_4077 = 0.0
			while true:
				if not J.cmp(v_i_4077, 3.0, "<"): break
				J.mc(env["ctx"], "beginPath", [])
				J.mc(env["ctx"], "arc", [v_x_4075, J.sub(v_y_4076, 60.0), ((8.0 + J.mul(v_i_4077, 7.0)) + (J.sub(3.0, J.gp(v_p_4073, "t")) * 6.0)), 0.0, 7.0])
				J.mc(env["ctx"], "stroke", [])
				v_i_4077 = J.num(v_i_4077) + 1.0
	else:
		v_on_4078 = (J.mod(floor(J.num(J.mul(J.gp(env["G"], "t"), 12.0))), 2.0) if J.cmp(J.gp(v_p_4073, "t"), 0.0, ">") else 1.0)
		var _t4564 = env["ctx"]
		var _t4565 = ("rgba(255,240,180,0.9)" if J.t(v_on_4078) else "#333")
		J.sp(_t4564, "fillStyle", _t4565)
		J.mc(env["ctx"], "fillRect", [J.sub(J.gp(v_n_4074, "x"), 10.0), J.sub(v_y_4076, 118.0), 20.0, 4.0])
		if J.t(v_on_4078):
			v_gr_4079 = J.mc(env["ctx"], "createRadialGradient", [J.gp(v_n_4074, "x"), J.sub(v_y_4076, 114.0), 2.0, J.gp(v_n_4074, "x"), J.sub(v_y_4076, 114.0), 40.0])
			J.mc(v_gr_4079, "addColorStop", [0.0, "rgba(255,240,180,0.25)"])
			J.mc(v_gr_4079, "addColorStop", [1.0, "rgba(255,240,180,0)"])
			var _t4566 = env["ctx"]
			J.sp(_t4566, "fillStyle", v_gr_4079)
			J.mc(env["ctx"], "fillRect", [J.sub(J.gp(v_n_4074, "x"), 40.0), J.sub(v_y_4076, 150.0), 80.0, 80.0])

func _f683(this_, a: Array, env):
	var v_e_4082 = null; var v_x_4083 = null; var v_y_4084 = null
	v_e_4082 = J.arg(a, 0)
	if (not J.t(J.gp(v_e_4082, "fire"))):
		return null
	v_x_4083 = J.gp(J.gp(v_e_4082, "fire"), "x")
	var _t4568 = env["fy"]
	v_y_4084 = J.cl(_t4568, null, [J.gp(J.gp(v_e_4082, "fire"), "f")])
	if J.cmp(J.gp(J.gp(v_e_4082, "fire"), "shut"), 0.0, ">"):
		var _t4569 = env["ctx"]
		J.sp(_t4569, "fillStyle", "#6a1e1a")
		J.mc(env["ctx"], "fillRect", [J.sub(v_x_4083, 6.0), J.sub(v_y_4084, 70.0), 12.0, 66.0])
		var _t4570 = env["ctx"]
		J.sp(_t4570, "strokeStyle", "#ffd54a")
		var _t4571 = env["ctx"]
		J.sp(_t4571, "lineWidth", 1.5)
		J.mc(env["ctx"], "strokeRect", [J.sub(v_x_4083, 6.0), J.sub(v_y_4084, 70.0), 12.0, 66.0])
		var _t4572 = env["ctx"]
		J.sp(_t4572, "fillStyle", "#e8e2d0")
		var _t4573 = env["ctx"]
		var _t4574 = J.add("9px ", env["FONT"])
		J.sp(_t4573, "font", _t4574)
		var _t4575 = env["ctx"]
		J.sp(_t4575, "textAlign", "center")
		J.mc(env["ctx"], "fillText", [ceil(J.num(J.gp(J.gp(v_e_4082, "fire"), "shut"))), v_x_4083, J.sub(v_y_4084, 74.0)])
	else:
		var _t4576 = env["ctx"]
		J.sp(_t4576, "strokeStyle", "rgba(160,60,50,0.5)")
		var _t4577 = env["ctx"]
		J.sp(_t4577, "lineWidth", 1.0)
		J.mc(env["ctx"], "strokeRect", [J.sub(v_x_4083, 6.0), J.sub(v_y_4084, 70.0), 12.0, 66.0])

func _f684(this_, a: Array, env):
	var v_z_4087 = null; var v_i_4088 = null
	v_z_4087 = J.arg(a, 0)
	var _t4589 = J.sub(J.gp(v_z_4087, "t"), 0.033)
	J.sp(v_z_4087, "t", _t4589)
	var _t4590 = env["ctx"]
	var _t4591 = (J.add("rgba(255,213,74,", J.max_([0.0, J.gp(v_z_4087, "t")])) + ")")
	J.sp(_t4590, "strokeStyle", _t4591)
	var _t4592 = env["ctx"]
	J.sp(_t4592, "lineWidth", 2.0)
	v_i_4088 = 0.0
	while true:
		if not J.cmp(v_i_4088, J.gp(v_z_4087, "lvl"), "<"): break
		J.mc(env["ctx"], "beginPath", [])
		J.mc(env["ctx"], "arc", [J.gp(v_z_4087, "x"), J.gp(v_z_4087, "y"), ((J.sub(1.2, J.gp(v_z_4087, "t")) * 90.0) + J.mul(v_i_4088, 16.0)), 0.0, 7.0])
		J.mc(env["ctx"], "stroke", [])
		v_i_4088 = J.num(v_i_4088) + 1.0

func _f685(this_, a: Array, env):
	var v_z_4091 = null
	v_z_4091 = J.arg(a, 0)
	return J.cmp(J.gp(v_z_4091, "t"), 0.0, ">")

func _f686(this_, a: Array, env):
	var v_q_4094 = null; var v_u_4095 = null
	v_q_4094 = J.arg(a, 0)
	var _t4599 = J.seq(J.gp(v_q_4094, "id"), "lost")
	if (J.cmp(J.gp(v_q_4094, "state"), 2.0, "<") if _t4599 else _t4599):
		v_u_4095 = J.gp(v_q_4094, "owner")
		var _t4600 = J.gp(v_u_4095, "seen")
		if J.t((_t4600 if J.t(_t4600) else J.gp(v_u_4095, "entered"))):
			var _t4601 = env["txt"]
			J.cl(_t4601, null, [(J.add("交還", J.gp(v_q_4094, "thing")) if J.seq(J.gp(v_q_4094, "state"), 1.0) else "？"), J.div(J.add(J.gp(J.gp(v_u_4095, "rx"), 0.0), J.gp(J.gp(v_u_4095, "rx"), 1.0)), 2.0), J.sub(J.gp(v_u_4095, "y"), 112.0), "#8affc8", 13.0])
		var _t4603 = J.seq(J.gp(v_q_4094, "state"), 0.0)
		if J.t(_t4603):
			var _t4602 = J.gp(J.gp(v_q_4094, "hid"), "seen")
			_t4603 = (_t4602 if J.t(_t4602) else J.gp(J.gp(v_q_4094, "hid"), "entered"))
		if J.t(_t4603):
			var _t4604 = env["txt"]
			J.cl(_t4604, null, [J.add("✦", J.gp(v_q_4094, "thing")), J.div(J.add(J.gp(J.gp(J.gp(v_q_4094, "hid"), "rx"), 0.0), J.gp(J.gp(J.gp(v_q_4094, "hid"), "rx"), 1.0)), 2.0), J.sub(J.gp(J.gp(v_q_4094, "hid"), "y"), 100.0), "#8affc8", 11.0])

func _f679(this_, a: Array, env):
	var v_ln_4058 = null
	var _t4498 = J.gp(env["G"], "units")
	J.mc(_t4498, "forEach", [Callable(self, "_f680").bind(env)])
	var _t4558 = J.gp(env["G"], "cprops")
	var _t4559 = (_t4558 if J.t(_t4558) else [])
	J.mc(_t4559, "forEach", [Callable(self, "_f682").bind(env)])
	var _t4567 = J.gp(env["G"], "edges")
	J.mc(_t4567, "forEach", [Callable(self, "_f683").bind(env)])
	var _t4578 = J.gp(env["G"], "liftFx")
	if J.t((J.cmp(J.gp(J.gp(env["G"], "liftFx"), "t"), 0.0, ">") if J.t(_t4578) else _t4578)):
		v_ln_4058 = J.gp(J.gp(env["G"], "nodes"), (J.add("f", J.gp(J.gp(env["G"], "liftFx"), "f")) + "_l"))
		var _t4579 = J.gp(env["G"], "liftFx")
		var _t4580 = J.sub(J.gp(_t4579, "t"), 0.033)
		J.sp(_t4579, "t", _t4580)
		var _t4581 = env["ctx"]
		var _t4582 = (J.add("rgba(255,230,140,", (0.5 + (0.4 * sin(J.num(J.mul(J.gp(env["G"], "t"), 20.0)))))) + ")")
		J.sp(_t4581, "fillStyle", _t4582)
		J.mc(env["ctx"], "fillRect", [J.sub(J.gp(v_ln_4058, "x"), 14.0), J.sub(J.gp(v_ln_4058, "y"), 80.0), 28.0, 74.0])
		var _t4583 = env["ctx"]
		J.sp(_t4583, "fillStyle", "#000")
		var _t4584 = env["ctx"]
		var _t4585 = J.add("bold 14px ", env["FONT"])
		J.sp(_t4584, "font", _t4585)
		var _t4586 = env["ctx"]
		J.sp(_t4586, "textAlign", "center")
		J.mc(env["ctx"], "fillText", ["叮！", J.gp(v_ln_4058, "x"), J.sub(J.gp(v_ln_4058, "y"), 86.0)])
	var _t4587 = J.gp(env["G"], "noiseFx")
	var _t4588 = (_t4587 if J.t(_t4587) else [])
	J.mc(_t4588, "forEach", [Callable(self, "_f684").bind(env)])
	var _t4593 = env["G"]
	var _t4594 = J.gp(env["G"], "noiseFx")
	var _t4595 = (_t4594 if J.t(_t4594) else [])
	var _t4596 = J.mc(_t4595, "filter", [Callable(self, "_f685").bind(env)])
	J.sp(_t4593, "noiseFx", _t4596)
	var _t4597 = J.gp(env["G"], "quests")
	var _t4598 = (_t4597 if J.t(_t4597) else [])
	J.mc(_t4598, "forEach", [Callable(self, "_f686").bind(env)])

func _f688(this_, a: Array, env):
	var v_q_4103 = null
	v_q_4103 = J.arg(a, 0)
	return J.seq(J.gp(v_q_4103, "id"), "mini")

func _f687(this_, a: Array, env):
	var v_b_4098 = null; var v_wx_4099 = null; var v_wy_4100 = null
	v_b_4098 = J.mc(env["buttons"], "find", [Callable(self, "_f688").bind(env)])
	var _t4605 = (not J.t(v_b_4098))
	if (_t4605 if _t4605 else (not J.t(env["LASTP"]))):
		return null
	v_wx_4099 = J.mul(J.div(J.sub(J.gp(env["LASTP"], "x"), J.gp(v_b_4098, "x")), J.gp(v_b_4098, "w")), env["WW"])
	v_wy_4100 = J.mul(J.div(J.sub(J.gp(env["LASTP"], "y"), J.gp(v_b_4098, "y")), J.gp(v_b_4098, "h")), env["WH"])
	var _t4606 = env["cam"]
	var _t4607 = env["clamp"]
	var _t4609 = J.cl(_t4607, null, [v_wx_4099, 0.0, env["WW"]])
	var _t4608 = env["clamp"]
	var _t4610 = {"x": _t4609, "y": J.cl(_t4608, null, [v_wy_4100, 0.0, env["WH"]])}
	J.sp(_t4606, "free", _t4610)

func _f690(this_, a: Array, env):
	var v_u_4115 = null; var v_top_4116 = null
	v_u_4115 = J.arg(a, 0)
	var _t4613 = env["__p"]["fy"]
	v_top_4116 = J.add(J.cl(_t4613, null, [J.add(J.gp(v_u_4115, "f"), 1.0)]), 16.0)
	var _t4614 = env["__p"]["ctx"]
	var _t4617 = null
	if J.seq(J.gp(v_u_4115, "ot"), "deity"):
		_t4617 = "#5a2420"
	else:
		var _t4616 = null
		if (not J.t(J.gp(v_u_4115, "open"))):
			_t4616 = "#2a2430"
		else:
			var _t4615 = J.gp(v_u_4115, "seen")
			_t4616 = ("#3a4632" if J.t((_t4615 if J.t(_t4615) else J.gp(v_u_4115, "entered"))) else "#1c1820")
		_t4617 = _t4616
	J.sp(_t4614, "fillStyle", _t4617)
	J.mc(env["__p"]["ctx"], "fillRect", [J.add(J.add(env["mx"], J.mul(J.gp(J.gp(v_u_4115, "rx"), 0.0), env["sx"])), 0.5), J.add(env["my"], J.mul(v_top_4116, env["sy"])), (J.mul(J.sub(J.gp(J.gp(v_u_4115, "rx"), 1.0), J.gp(J.gp(v_u_4115, "rx"), 0.0)), env["sx"]) - 1.0), J.mul(J.sub(J.gp(v_u_4115, "y"), v_top_4116), env["sy"])])

func _f691(this_, a: Array, env):
	var v_id_4119 = null; var v_n_4120 = null
	v_id_4119 = J.arg(a, 0)
	v_n_4120 = J.gp(J.gp(env["__p"]["G"], "nodes"), v_id_4119)
	J.mc(env["__p"]["ctx"], "fillRect", [J.sub(J.add(env["mx"], J.mul(J.gp(v_n_4120, "x"), env["sx"])), 2.0), J.sub(J.add(env["my"], J.mul(J.gp(v_n_4120, "y"), env["sy"])), 3.0), 4.0, 3.0])

func _f692(this_, a: Array, env):
	var v_h_4123 = null
	v_h_4123 = J.arg(a, 0)
	if J.seq(J.gp(v_h_4123, "state"), "gone"):
		return null
	var _t4621 = env["__p"]["ctx"]
	var _t4622 = ("#d87e3c" if J.seq(J.gp(v_h_4123, "kind"), "collector") else ("#e0483a" if J.seq(J.gp(v_h_4123, "state"), "chase") else "#b8786a"))
	J.sp(_t4621, "fillStyle", _t4622)
	J.mc(env["__p"]["ctx"], "fillRect", [J.sub(J.add(env["mx"], J.mul(J.gp(v_h_4123, "x"), env["sx"])), 1.5), J.sub(J.add(env["my"], J.mul(J.gp(v_h_4123, "y"), env["sy"])), 3.0), 3.0, 3.0])

func _f693(this_, a: Array, env):
	var v_g_4126 = null; var v_i_4127 = null
	v_g_4126 = J.arg(a, 0)
	v_i_4127 = J.arg(a, 1)
	var _t4624 = J.gp(v_g_4126, "home")
	if J.t((_t4624 if J.t(_t4624) else J.gp(v_g_4126, "out"))):
		return null
	var _t4625 = env["__p"]["ctx"]
	var _t4626 = ("#efe5cf" if J.seq(v_i_4127, J.gp(env["__p"]["G"], "active")) else "#9c88cc")
	J.sp(_t4625, "fillStyle", _t4626)
	J.mc(env["__p"]["ctx"], "beginPath", [])
	J.mc(env["__p"]["ctx"], "arc", [J.add(env["mx"], J.mul(J.gp(v_g_4126, "x"), env["sx"])), J.sub(J.add(env["my"], J.mul(J.gp(v_g_4126, "y"), env["sy"])), 2.0), (3.0 if J.seq(v_i_4127, J.gp(env["__p"]["G"], "active")) else 2.0), 0.0, 7.0])
	J.mc(env["__p"]["ctx"], "fill", [])

func _f689(this_, a: Array, env):
	var v_mw_4106 = null; var v_mh_4107 = null; var v_S_4112 = null
	var _s1697 = {"__p": env, "mx": null, "my": null, "sx": null, "sy": null}
	v_mw_4106 = 74.0
	v_mh_4107 = J.min_([110.0, J.round(J.num(J.div(J.mul(74.0, _s1697["__p"]["WH"]), _s1697["__p"]["WW"])))])
	_s1697["mx"] = 10.0
	_s1697["my"] = J.add(_s1697["__p"]["TOP"], 60.0)
	_s1697["sx"] = J.div(v_mw_4106, _s1697["__p"]["WW"])
	_s1697["sy"] = J.div(v_mh_4107, _s1697["__p"]["WH"])
	J.mc(_s1697["__p"]["buttons"], "push", [{"id": "mini", "x": _s1697["mx"], "y": _s1697["my"], "w": v_mw_4106, "h": v_mh_4107}])
	var _t4611 = _s1697["__p"]["crPanel"]
	J.cl(_t4611, null, [_s1697["__p"]["ctx"], J.sub(_s1697["mx"], 5.0), J.sub(_s1697["my"], 5.0), J.add(v_mw_4106, 10.0), J.add(v_mh_4107, 10.0), "ink"])
	var _t4612 = J.gp(_s1697["__p"]["G"], "units")
	J.mc(_t4612, "forEach", [Callable(self, "_f690").bind(_s1697)])
	var _t4618 = _s1697["__p"]["ctx"]
	J.sp(_t4618, "fillStyle", "#8aac6c")
	var _t4619 = ["f0_e", (J.add("f", _s1697["__p"]["FL"]) + "_p")]
	J.mc(_t4619, "forEach", [Callable(self, "_f691").bind(_s1697)])
	var _t4620 = J.gp(_s1697["__p"]["G"], "guards")
	J.mc(_t4620, "forEach", [Callable(self, "_f692").bind(_s1697)])
	var _t4623 = J.gp(_s1697["__p"]["G"], "gh")
	J.mc(_t4623, "forEach", [Callable(self, "_f693").bind(_s1697)])
	v_S_4112 = J.mul(J.gp(_s1697["__p"]["cam"], "s"), J.gp(_s1697["__p"]["cam"], "z"))
	var _t4627 = _s1697["__p"]["ctx"]
	J.sp(_t4627, "strokeStyle", "rgba(216,204,176,0.6)")
	var _t4628 = _s1697["__p"]["ctx"]
	J.sp(_t4628, "lineWidth", 1.2)
	J.mc(_s1697["__p"]["ctx"], "strokeRect", [J.add(_s1697["mx"], J.mul(J.gp(_s1697["__p"]["cam"], "x"), _s1697["sx"])), J.add(_s1697["my"], J.mul(J.gp(_s1697["__p"]["cam"], "y"), _s1697["sy"])), J.mul(J.div(_s1697["__p"]["VW"], v_S_4112), _s1697["sx"]), J.mul(J.div(J.sub(J.sub(_s1697["__p"]["VH"], _s1697["__p"]["TOP"]), _s1697["__p"]["BOT"]), v_S_4112), _s1697["sy"])])

func _f694(this_, a: Array, env):
	var _t4629 = J.min_([J.gp(J.G.get("window"), "innerWidth"), 520.0])
	env["VW"] = _t4629
	env["VH"] = J.gp(J.G.get("window"), "innerHeight")
	var _t4630 = J.gp(env["cv"], "style")
	var _t4631 = J.add(env["VW"], "px")
	J.sp(_t4630, "width", _t4631)
	var _t4632 = J.gp(env["cv"], "style")
	var _t4633 = J.add(env["VH"], "px")
	J.sp(_t4632, "height", _t4633)
	var _t4634 = env["cv"]
	var _t4635 = J.round(J.num(J.mul(env["VW"], env["DPR"])))
	J.sp(_t4634, "width", _t4635)
	var _t4636 = env["cv"]
	var _t4637 = J.round(J.num(J.mul(env["VH"], env["DPR"])))
	J.sp(_t4636, "height", _t4637)
	var _t4638 = env["cam"]
	var _t4640 = env["VW"]
	var _t4639 = (J.gp(env["LV"], "camW") if J.t(env["LV"]) else env["LV"])
	var _t4641 = J.div(_t4640, (_t4639 if J.t(_t4639) else 600.0))
	J.sp(_t4638, "s", _t4641)
	var _t4642 = J.div(env["VW"], env["WW"])
	env["BOTX"] = _t4642

func _f695(this_, a: Array, env):
	var v_c2_4132 = null; var v_x_4133 = null; var v_y_4134 = null; var v_w_4135 = null; var v_h_4136 = null; var v_col_4137 = null; var v_dens_4138 = null; var v_n_4139 = null; var v_i_4140 = null; var v_px_4141 = null; var v_py_4142 = null; var v_L_4143 = null
	v_c2_4132 = J.arg(a, 0)
	v_x_4133 = J.arg(a, 1)
	v_y_4134 = J.arg(a, 2)
	v_w_4135 = J.arg(a, 3)
	v_h_4136 = J.arg(a, 4)
	v_col_4137 = J.arg(a, 5)
	v_dens_4138 = J.arg(a, 6)
	J.sp(v_c2_4132, "fillStyle", v_col_4137)
	J.mc(v_c2_4132, "fillRect", [v_x_4133, v_y_4134, v_w_4135, v_h_4136])
	J.mc(v_c2_4132, "save", [])
	J.mc(v_c2_4132, "beginPath", [])
	J.mc(v_c2_4132, "rect", [v_x_4133, v_y_4134, v_w_4135, v_h_4136])
	J.mc(v_c2_4132, "clip", [])
	J.sp(v_c2_4132, "globalAlpha", 0.16)
	J.sp(v_c2_4132, "strokeStyle", "#000")
	J.sp(v_c2_4132, "lineWidth", 1.0)
	v_n_4139 = floor(J.num(J.div(J.mul(v_w_4135, v_h_4136), (v_dens_4138 if J.t(v_dens_4138) else 140.0))))
	v_i_4140 = 0.0
	while true:
		if not J.cmp(v_i_4140, v_n_4139, "<"): break
		v_px_4141 = J.add(v_x_4133, J.mul(randf(), v_w_4135))
		v_py_4142 = J.add(v_y_4134, J.mul(randf(), v_h_4136))
		v_L_4143 = (4.0 + (randf() * 9.0))
		J.mc(v_c2_4132, "beginPath", [])
		J.mc(v_c2_4132, "moveTo", [v_px_4141, v_py_4142])
		J.mc(v_c2_4132, "lineTo", [J.add(v_px_4141, v_L_4143), J.sub(v_py_4142, J.mul(v_L_4143, 0.35))])
		J.mc(v_c2_4132, "stroke", [])
		v_i_4140 = J.num(v_i_4140) + 1.0
	J.sp(v_c2_4132, "globalAlpha", 0.1)
	J.sp(v_c2_4132, "strokeStyle", "#fff")
	v_i_4140 = 0.0
	while true:
		if not J.cmp(v_i_4140, J.div(v_n_4139, 2.0), "<"): break
		v_px_4141 = J.add(v_x_4133, J.mul(randf(), v_w_4135))
		v_py_4142 = J.add(v_y_4134, J.mul(randf(), v_h_4136))
		J.mc(v_c2_4132, "beginPath", [])
		J.mc(v_c2_4132, "moveTo", [v_px_4141, v_py_4142])
		J.mc(v_c2_4132, "lineTo", [J.add(v_px_4141, 5.0), J.sub(v_py_4142, 2.0)])
		J.mc(v_c2_4132, "stroke", [])
		v_i_4140 = J.num(v_i_4140) + 1.0
	J.mc(v_c2_4132, "restore", [])

func _f696(this_, a: Array, env):
	var v_c_4146 = null; var v_bgi_4147 = null
	if J.t(J.gp(env["LV"], "B")):
		J.cl(env["bake2"], null, [])
		return null
	var _t4643 = J.S_document_("createElement", ["canvas"])
	env["staticCv"] = _t4643
	var _t4644 = env["staticCv"]
	var _t4645 = J.mul(env["WW"], 2.0)
	J.sp(_t4644, "width", _t4645)
	var _t4646 = env["staticCv"]
	var _t4647 = J.mul(env["WH"], 2.0)
	J.sp(_t4646, "height", _t4647)
	v_c_4146 = J.mc(env["staticCv"], "getContext", ["2d"])
	v_bgi_4147 = J.gp(env["IMG"], J.gp(env["LV"], "bg"))
	if J.t((J.gp(v_bgi_4147, "width") if J.t(v_bgi_4147) else v_bgi_4147)):
		J.mc(v_c_4146, "drawImage", [v_bgi_4147, 0.0, 0.0, J.mul(env["WW"], 2.0), J.mul(env["WH"], 2.0)])
	else:
		J.sp(v_c_4146, "fillStyle", "#1a1a1e")
		J.mc(v_c_4146, "fillRect", [0.0, 0.0, J.mul(env["WW"], 2.0), J.mul(env["WH"], 2.0)])

func _f697(this_, a: Array, env):
	var v_x_4150 = null; var v_y_4151 = null; var v_S_4152 = null
	v_x_4150 = J.arg(a, 0)
	v_y_4151 = J.arg(a, 1)
	v_S_4152 = J.mul(J.gp(env["cam"], "s"), J.gp(env["cam"], "z"))
	return {"x": J.mul(J.sub(v_x_4150, J.gp(env["cam"], "x")), v_S_4152), "y": J.add(J.mul(J.sub(v_y_4151, J.gp(env["cam"], "y")), v_S_4152), env["TOP"])}

func _f698(this_, a: Array, env):
	var v_k_4155 = null; var v_x_4156 = null; var v_y_4157 = null; var v_h_4158 = null; var v_o_4159 = null; var v_im_4160 = null; var v_w_4161 = null
	v_k_4155 = J.arg(a, 0)
	v_x_4156 = J.arg(a, 1)
	v_y_4157 = J.arg(a, 2)
	v_h_4158 = J.arg(a, 3)
	v_o_4159 = J.arg(a, 4)
	v_im_4160 = J.gp(env["IMG"], v_k_4155)
	var _t4648 = (not J.t(v_im_4160))
	if (_t4648 if _t4648 else (not J.t(J.gp(v_im_4160, "width")))):
		return null
	v_w_4161 = J.div(J.mul(v_h_4158, J.gp(v_im_4160, "width")), J.gp(v_im_4160, "height"))
	var _t4649 = (v_o_4159 if J.t(v_o_4159) else {})
	v_o_4159 = _t4649
	J.mc(env["ctx"], "save", [])
	var _t4650 = env["ctx"]
	var _t4651 = (1.0 if J.leq(J.gp(v_o_4159, "alpha"), null) else J.gp(v_o_4159, "alpha"))
	J.sp(_t4650, "globalAlpha", _t4651)
	var _t4652 = J.gp(v_o_4159, "ox")
	var _t4654 = J.add(v_x_4156, (_t4652 if J.t(_t4652) else 0.0))
	var _t4653 = J.gp(v_o_4159, "oy")
	J.mc(env["ctx"], "translate", [_t4654, J.add(v_y_4157, (_t4653 if J.t(_t4653) else 0.0))])
	if J.t(J.gp(v_o_4159, "rot")):
		J.mc(env["ctx"], "rotate", [J.gp(v_o_4159, "rot")])
	var _t4656 = ((-1.0) if J.t(J.gp(v_o_4159, "flip")) else 1.0)
	var _t4655 = J.gp(v_o_4159, "sx")
	var _t4658 = J.mul(_t4656, (_t4655 if J.t(_t4655) else 1.0))
	var _t4657 = J.gp(v_o_4159, "sy")
	J.mc(env["ctx"], "scale", [_t4658, (_t4657 if J.t(_t4657) else 1.0)])
	J.mc(env["ctx"], "drawImage", [v_im_4160, J.div((-J.num(v_w_4161)), 2.0), (-J.num(v_h_4158)), v_w_4161, v_h_4158])
	J.mc(env["ctx"], "restore", [])

func _f699(this_, a: Array, env):
	var v_k_4164 = null; var v_x_4165 = null; var v_y_4166 = null; var v_h_4167 = null; var v_flip_4168 = null; var v_alpha_4169 = null; var v_im_4170 = null; var v_w_4171 = null
	v_k_4164 = J.arg(a, 0)
	v_x_4165 = J.arg(a, 1)
	v_y_4166 = J.arg(a, 2)
	v_h_4167 = J.arg(a, 3)
	v_flip_4168 = J.arg(a, 4)
	v_alpha_4169 = J.arg(a, 5)
	v_im_4170 = J.gp(env["IMG"], v_k_4164)
	var _t4659 = (not J.t(v_im_4170))
	if (_t4659 if _t4659 else (not J.t(J.gp(v_im_4170, "width")))):
		return null
	v_w_4171 = J.div(J.mul(v_h_4167, J.gp(v_im_4170, "width")), J.gp(v_im_4170, "height"))
	var _t4660 = env["ctx"]
	var _t4661 = (1.0 if J.leq(v_alpha_4169, null) else v_alpha_4169)
	J.sp(_t4660, "globalAlpha", _t4661)
	if J.t(v_flip_4168):
		J.mc(env["ctx"], "save", [])
		J.mc(env["ctx"], "translate", [v_x_4165, 0.0])
		J.mc(env["ctx"], "scale", [(-1.0), 1.0])
		J.mc(env["ctx"], "drawImage", [v_im_4170, J.div((-J.num(v_w_4171)), 2.0), J.sub(v_y_4166, v_h_4167), v_w_4171, v_h_4167])
		J.mc(env["ctx"], "restore", [])
	else:
		J.mc(env["ctx"], "drawImage", [v_im_4170, J.sub(v_x_4165, J.div(v_w_4171, 2.0)), J.sub(v_y_4166, v_h_4167), v_w_4171, v_h_4167])
	var _t4662 = env["ctx"]
	J.sp(_t4662, "globalAlpha", 1.0)

func _f700(this_, a: Array, env):
	var v_e_4174 = null; var v_n_4175 = null; var v_x_4176 = null; var v_y_4177 = null; var v_w_4178 = null; var v_k_4179 = null
	v_e_4174 = J.arg(a, 0)
	v_n_4175 = (J.gp(J.gp(env["G"], "nodes"), J.gp(v_e_4174, "a")) if J.seq(J.gp(J.gp(J.gp(env["G"], "nodes"), J.gp(v_e_4174, "a")), "kind"), "door") else J.gp(J.gp(env["G"], "nodes"), J.gp(v_e_4174, "b")))
	v_x_4176 = J.gp(v_n_4175, "x")
	v_y_4177 = J.gp(v_n_4175, "y")
	v_w_4178 = J.gp(v_e_4174, "ward")
	if (not J.t(v_w_4178)):
		return null
	if J.seq(v_w_4178, "fu"):
		var _t4663 = env["ctx"]
		J.sp(_t4663, "fillStyle", "#d42a2a")
		J.mc(env["ctx"], "fillRect", [J.sub(v_x_4176, 6.0), J.sub(v_y_4177, 92.0), 12.0, 16.0])
		var _t4664 = env["ctx"]
		J.sp(_t4664, "strokeStyle", "#ffd54a")
		var _t4665 = env["ctx"]
		J.sp(_t4665, "lineWidth", 1.5)
		J.mc(env["ctx"], "strokeRect", [J.sub(v_x_4176, 6.0), J.sub(v_y_4177, 92.0), 12.0, 16.0])
	if J.seq(v_w_4178, "menshen"):
		var _t4666 = env["ctx"]
		J.sp(_t4666, "fillStyle", "#b7302a")
		J.mc(env["ctx"], "fillRect", [J.sub(v_x_4176, 14.0), J.sub(v_y_4177, 70.0), 13.0, 46.0])
		J.mc(env["ctx"], "fillRect", [J.add(v_x_4176, 1.0), J.sub(v_y_4177, 70.0), 13.0, 46.0])
		var _t4667 = env["ctx"]
		J.sp(_t4667, "strokeStyle", "#ffd54a")
		var _t4668 = env["ctx"]
		J.sp(_t4668, "lineWidth", 2.0)
		J.mc(env["ctx"], "strokeRect", [J.sub(v_x_4176, 14.0), J.sub(v_y_4177, 70.0), 13.0, 46.0])
		J.mc(env["ctx"], "strokeRect", [J.add(v_x_4176, 1.0), J.sub(v_y_4177, 70.0), 13.0, 46.0])
		var _t4669 = env["ctx"]
		J.sp(_t4669, "fillStyle", "#ffd54a")
		J.mc(env["ctx"], "beginPath", [])
		J.mc(env["ctx"], "arc", [J.sub(v_x_4176, 7.5), J.sub(v_y_4177, 56.0), 4.0, 0.0, 7.0])
		J.mc(env["ctx"], "arc", [J.add(v_x_4176, 7.5), J.sub(v_y_4177, 56.0), 4.0, 0.0, 7.0])
		J.mc(env["ctx"], "fill", [])
	if J.seq(v_w_4178, "zha"):
		var _t4670 = env["ctx"]
		J.sp(_t4670, "fillStyle", "#c8ccd8")
		J.mc(env["ctx"], "fillRect", [J.add(v_x_4176, 8.0), J.sub(v_y_4177, 44.0), 8.0, 6.0])
		var _t4671 = env["ctx"]
		J.sp(_t4671, "strokeStyle", "#2a2030")
		var _t4672 = env["ctx"]
		J.sp(_t4672, "lineWidth", 1.0)
		J.mc(env["ctx"], "strokeRect", [J.add(v_x_4176, 8.0), J.sub(v_y_4177, 44.0), 8.0, 6.0])
		J.mc(env["ctx"], "beginPath", [])
		J.mc(env["ctx"], "arc", [J.add(v_x_4176, 12.0), J.sub(v_y_4177, 46.0), 3.0, PI, 0.0])
		J.mc(env["ctx"], "stroke", [])
	if J.seq(v_w_4178, "nuomi"):
		var _t4673 = env["ctx"]
		J.sp(_t4673, "fillStyle", "#fffbe8")
		v_k_4179 = 0.0
		while true:
			if not J.cmp(v_k_4179, 20.0, "<"): break
			J.mc(env["ctx"], "fillRect", [(J.sub(v_x_4176, 24.0) + J.mul(v_k_4179, 2.5)), (J.sub(v_y_4177, 6.0) + (J.mod(v_k_4179, 3.0) * 1.5)), 2.0, 2.0])
			v_k_4179 = J.num(v_k_4179) + 1.0
	if J.seq(v_w_4178, "datuk"):
		var _t4674 = env["ctx"]
		var _t4675 = (0.3 + (0.15 * sin(J.num(J.mul(J.gp(env["G"], "t"), 3.0)))))
		J.sp(_t4674, "globalAlpha", _t4675)
		var _t4676 = env["ctx"]
		J.sp(_t4676, "fillStyle", "#ffcc66")
		J.mc(env["ctx"], "beginPath", [])
		J.mc(env["ctx"], "arc", [J.add(v_x_4176, 22.0), J.sub(v_y_4177, 14.0), 14.0, 0.0, 7.0])
		J.mc(env["ctx"], "fill", [])
		var _t4677 = env["ctx"]
		J.sp(_t4677, "globalAlpha", 1.0)
		var _t4678 = env["ctx"]
		J.sp(_t4678, "fillStyle", "#c4202a")
		J.mc(env["ctx"], "fillRect", [J.add(v_x_4176, 13.0), J.sub(v_y_4177, 24.0), 18.0, 20.0])
		var _t4679 = env["ctx"]
		J.sp(_t4679, "strokeStyle", "#ffd54a")
		var _t4680 = env["ctx"]
		J.sp(_t4680, "lineWidth", 1.5)
		J.mc(env["ctx"], "strokeRect", [J.add(v_x_4176, 13.0), J.sub(v_y_4177, 24.0), 18.0, 20.0])
		var _t4681 = env["ctx"]
		J.sp(_t4681, "fillStyle", "#ffd54a")
		J.mc(env["ctx"], "fillRect", [J.add(v_x_4176, 16.0), J.sub(v_y_4177, 20.0), 12.0, 3.0])

func _f701(this_, a: Array, env):
	var v_x_4182 = null; var v_y_4183 = null; var v_t_4184 = null; var v_col_4185 = null
	v_x_4182 = J.arg(a, 0)
	v_y_4183 = J.arg(a, 1)
	v_t_4184 = J.arg(a, 2)
	v_col_4185 = J.arg(a, 3)
	var _t4682 = env["crBubble"]
	J.cl(_t4682, null, [v_x_4182, v_y_4183, v_t_4184, v_col_4185])

func _f702(this_, a: Array, env):
	var v_x_4188 = null; var v_y_4189 = null; var v_w_4190 = null; var v_h_4191 = null; var v_r_4192 = null
	v_x_4188 = J.arg(a, 0)
	v_y_4189 = J.arg(a, 1)
	v_w_4190 = J.arg(a, 2)
	v_h_4191 = J.arg(a, 3)
	v_r_4192 = J.arg(a, 4)
	J.mc(env["ctx"], "beginPath", [])
	J.mc(env["ctx"], "moveTo", [J.add(v_x_4188, v_r_4192), v_y_4189])
	J.mc(env["ctx"], "arcTo", [J.add(v_x_4188, v_w_4190), v_y_4189, J.add(v_x_4188, v_w_4190), J.add(v_y_4189, v_h_4191), v_r_4192])
	J.mc(env["ctx"], "arcTo", [J.add(v_x_4188, v_w_4190), J.add(v_y_4189, v_h_4191), v_x_4188, J.add(v_y_4189, v_h_4191), v_r_4192])
	J.mc(env["ctx"], "arcTo", [v_x_4188, J.add(v_y_4189, v_h_4191), v_x_4188, v_y_4189, v_r_4192])
	J.mc(env["ctx"], "arcTo", [v_x_4188, v_y_4189, J.add(v_x_4188, v_w_4190), v_y_4189, v_r_4192])
	J.mc(env["ctx"], "closePath", [])

func _f703(this_, a: Array, env):
	var v_c_4195 = null; var v_k_4196 = null
	v_c_4195 = J.arg(a, 0)
	if (not J.seq(J.typeof_(v_c_4195), "string")):
		return v_c_4195
	v_k_4196 = J.mc(v_c_4195, "toLowerCase", [])
	if J.seq(v_k_4196, "#fff"):
		v_k_4196 = "#ffffff"
	var _t4683 = J.gp(env["CRC"], v_k_4196)
	return (_t4683 if J.t(_t4683) else v_c_4195)

func _f705(this_, a: Array, env):
	var _t4684 = J.mod(J.mul(env["s"], 16807.0), 2147483647.0)
	env["s"] = _t4684
	return J.div(J.sub(env["s"], 1.0), 2147483646.0)

func _f704(this_, a: Array, env):
	var v_seed_4199 = null
	var _s1726 = {"__p": env, "s": null}
	v_seed_4199 = J.arg(a, 0)
	_s1726["s"] = (J.mod(v_seed_4199, 2147483646.0) + 1.0)
	return Callable(self, "_f705").bind(_s1726)

func _f706(this_, a: Array, env):
	var v_str_4205 = null; var v_h_4206 = null; var v_i_4207 = null
	v_str_4205 = J.arg(a, 0)
	v_h_4206 = 2166136261.0
	v_i_4207 = 0.0
	while true:
		if not J.cmp(v_i_4207, J.len(v_str_4205), "<"): break
		var _t4685 = J.bxor(v_h_4206, J.mc(v_str_4205, "charCodeAt", [v_i_4207]))
		v_h_4206 = _t4685
		var _t4686 = J.math("imul", [v_h_4206, 16777619.0])
		v_h_4206 = _t4686
		v_i_4207 = J.num(v_i_4207) + 1.0
	return (J.mod(J.ushr(v_h_4206, 0.0), 2147483646.0) + 1.0)

func _f707(this_, a: Array, env):
	var v_c_4210 = null; var v_x_4211 = null; var v_r_4212 = null; var v_i_4213 = null; var v_v_4214 = null; var v_j_4215 = null; var v_px_4216 = null; var v_py_4217 = null
	if J.t(J.gp(env["CR"], "grain")):
		return J.gp(env["CR"], "grain")
	v_c_4210 = J.S_document_("createElement", ["canvas"])
	J.sp(v_c_4210, "height", 128.0)
	J.sp(v_c_4210, "width", 128.0)
	v_x_4211 = J.mc(v_c_4210, "getContext", ["2d"])
	var _t4687 = env["crRnd"]
	v_r_4212 = J.cl(_t4687, null, [99.0])
	v_i_4213 = 0.0
	while true:
		if not J.cmp(v_i_4213, 2600.0, "<"): break
		v_v_4214 = J.cl(v_r_4212, null, [])
		var _t4688 = ((J.add("rgba(0,0,0,", (0.1 + J.mul(J.cl(v_r_4212, null, []), 0.25))) + ")") if J.cmp(v_v_4214, 0.55, "<") else (J.add("rgba(255,240,220,", (0.03 + J.mul(J.cl(v_r_4212, null, []), 0.07))) + ")"))
		J.sp(v_x_4211, "fillStyle", _t4688)
		J.mc(v_x_4211, "fillRect", [J.mul(J.cl(v_r_4212, null, []), 128.0), J.mul(J.cl(v_r_4212, null, []), 128.0), (1.0 + J.mul(J.cl(v_r_4212, null, []), 1.6)), (1.0 + J.mul(J.cl(v_r_4212, null, []), 1.2))])
		v_i_4213 = J.num(v_i_4213) + 1.0
	J.sp(v_x_4211, "strokeStyle", "rgba(0,0,0,0.2)")
	J.sp(v_x_4211, "lineWidth", 0.7)
	v_j_4215 = 0.0
	while true:
		if not J.cmp(v_j_4215, 70.0, "<"): break
		v_px_4216 = J.mul(J.cl(v_r_4212, null, []), 128.0)
		v_py_4217 = J.mul(J.cl(v_r_4212, null, []), 128.0)
		J.mc(v_x_4211, "beginPath", [])
		J.mc(v_x_4211, "moveTo", [v_px_4216, v_py_4217])
		J.mc(v_x_4211, "lineTo", [J.add(J.add(v_px_4216, 4.0), J.mul(J.cl(v_r_4212, null, []), 10.0)), J.add(v_py_4217, (J.sub(J.cl(v_r_4212, null, []), 0.5) * 3.0))])
		J.mc(v_x_4211, "stroke", [])
		v_j_4215 = J.num(v_j_4215) + 1.0
	var _t4689 = env["CR"]
	J.sp(_t4689, "grain", v_c_4210)
	return v_c_4210

func _f709(this_, a: Array, env):
	var v_x0_4233 = null; var v_y0_4234 = null; var v_x1_4235 = null; var v_y1_4236 = null; var v_L_4237 = null; var v_n_4238 = null; var v_i_4239 = null; var v_t_4240 = null
	v_x0_4233 = J.arg(a, 0)
	v_y0_4234 = J.arg(a, 1)
	v_x1_4235 = J.arg(a, 2)
	v_y1_4236 = J.arg(a, 3)
	v_L_4237 = J.hypot_([J.sub(v_x1_4235, v_x0_4233), J.sub(v_y1_4236, v_y0_4234)])
	v_n_4238 = J.max_([2.0, J.round(J.num(J.div(v_L_4237, 16.0)))])
	v_i_4239 = 0.0
	while true:
		if not J.cmp(v_i_4239, v_n_4238, "<"): break
		v_t_4240 = J.div(v_i_4239, v_n_4238)
		J.mc(env["P"], "push", [[J.add(J.add(v_x0_4233, J.mul(J.sub(v_x1_4235, v_x0_4233), v_t_4240)), J.mul(J.sub(J.cl(env["r"], null, []), 0.5), env["j"])), J.add(J.add(v_y0_4234, J.mul(J.sub(v_y1_4236, v_y0_4234), v_t_4240)), J.mul(J.sub(J.cl(env["r"], null, []), 0.5), env["j"]))]])
		v_i_4239 = J.num(v_i_4239) + 1.0

func _f708(this_, a: Array, env):
	var v_w_4221 = null; var v_h_4222 = null; var v_ring_4224 = null; var v_R_4226 = null; var v_n_4227 = null; var v_i_4228 = null; var v_a_4229 = null; var v_seg_4230 = null
	var _s1736 = {"__p": env, "r": null, "j": null, "P": null}
	_s1736["r"] = J.arg(a, 0)
	v_w_4221 = J.arg(a, 1)
	v_h_4222 = J.arg(a, 2)
	_s1736["j"] = J.arg(a, 3)
	v_ring_4224 = J.arg(a, 4)
	v_seg_4230 = Callable(self, "_f709").bind(_s1736)
	_s1736["P"] = []
	if J.t(v_ring_4224):
		v_R_4226 = J.div(v_w_4221, 2.0)
		v_n_4227 = J.max_([18.0, J.round(J.num(J.mul(v_R_4226, 0.6)))])
		v_i_4228 = 0.0
		while true:
			if not J.cmp(v_i_4228, v_n_4227, "<"): break
			v_a_4229 = ((J.div(v_i_4228, v_n_4227) * PI) * 2.0)
			J.mc(_s1736["P"], "push", [[J.add(v_R_4226, J.mul(cos(J.num(v_a_4229)), J.add(v_R_4226, J.mul(J.sub(J.cl(_s1736["r"], null, []), 0.5), _s1736["j"])))), J.add(v_R_4226, J.mul(sin(J.num(v_a_4229)), J.add(v_R_4226, J.mul(J.sub(J.cl(_s1736["r"], null, []), 0.5), _s1736["j"]))))]])
			v_i_4228 = J.num(v_i_4228) + 1.0
		return _s1736["P"]
	J.cl(v_seg_4230, null, [0.0, 0.0, v_w_4221, 0.0])
	J.cl(v_seg_4230, null, [v_w_4221, 0.0, v_w_4221, v_h_4222])
	J.cl(v_seg_4230, null, [v_w_4221, v_h_4222, 0.0, v_h_4222])
	J.cl(v_seg_4230, null, [0.0, v_h_4222, 0.0, 0.0])
	return _s1736["P"]

func _f710(this_, a: Array, env):
	var v_c_4243 = null; var v_P_4244 = null; var v_i_4245 = null
	v_c_4243 = J.arg(a, 0)
	v_P_4244 = J.arg(a, 1)
	J.mc(v_c_4243, "beginPath", [])
	J.mc(v_c_4243, "moveTo", [J.gp(J.gp(v_P_4244, 0.0), 0.0), J.gp(J.gp(v_P_4244, 0.0), 1.0)])
	v_i_4245 = 1.0
	while true:
		if not J.cmp(v_i_4245, J.len(v_P_4244), "<"): break
		J.mc(v_c_4243, "lineTo", [J.gp(J.gp(v_P_4244, v_i_4245), 0.0), J.gp(J.gp(v_P_4244, v_i_4245), 1.0)])
		v_i_4245 = J.num(v_i_4245) + 1.0
	J.mc(v_c_4243, "closePath", [])

func _f712(this_, a: Array, env):
	var v_v_4282 = null
	v_v_4282 = J.arg(a, 0)
	return [J.add(J.gp(v_v_4282, 0.0), J.mul(J.sub(J.cl(env["r"], null, []), 0.5), env["jj"])), J.add(J.gp(v_v_4282, 1.0), J.mul(J.sub(J.cl(env["r"], null, []), 0.5), env["jj"]))]

func _f713(this_, a: Array, env):
	var v_o2_4285 = null
	v_o2_4285 = J.arg(a, 0)
	var _t4746 = env["c"]
	J.sp(_t4746, "globalAlpha", 0.6)
	J.mc(env["c"], "beginPath", [])
	J.mc(env["c"], "arc", [J.add(J.gp(v_o2_4285, 0.0), (J.sub(J.cl(env["r"], null, []), 0.5) * 2.0)), J.add(J.gp(v_o2_4285, 1.0), (J.sub(J.cl(env["r"], null, []), 0.5) * 2.0)), (1.3 + J.mul(J.cl(env["r"], null, []), 1.2)), 0.0, 7.0])
	J.mc(env["c"], "fill", [])

func _f711(this_, a: Array, env):
	var v_w_4248 = null; var v_h_4249 = null; var v_tone_4250 = null; var v_mode_4251 = null; var v_T_4252 = null; var v_M_4253 = null; var v_D_4254 = null; var v_o_4255 = null; var v_pr_4258 = null; var v_off_4259 = null; var v_pan_4260 = null; var v_bar_4261 = null; var v_ring_4262 = null; var v_J_4263 = null; var v_P_4264 = null; var v_gd_4265 = null; var v_g_4266 = null; var v_step_4267 = null; var v_k_4268 = null; var v_a0_4269 = null; var v_nq_4270 = null; var v_q_4271 = null; var v_qx_4272 = null; var v_qy_4273 = null; var v_s2_4274 = null; var v_yy_4275 = null; var v_passes_4276 = null; var v_p_4278 = null; var v_Q_4279 = null
	var _s1745 = {"__p": env, "c": null, "r": null, "jj": null}
	v_w_4248 = J.arg(a, 0)
	v_h_4249 = J.arg(a, 1)
	v_tone_4250 = J.arg(a, 2)
	v_mode_4251 = J.arg(a, 3)
	var _t4690 = J.gp(J.gp(_s1745["__p"]["CR"], "tones"), v_tone_4250)
	v_T_4252 = (_t4690 if J.t(_t4690) else J.gp(J.gp(_s1745["__p"]["CR"], "tones"), "ink"))
	v_M_4253 = J.gp(_s1745["__p"]["CR"], "M")
	v_D_4254 = _s1745["__p"]["DPR"]
	v_o_4255 = J.S_document_("createElement", ["canvas"])
	var _t4691 = ceil(J.num(J.mul(J.add(v_w_4248, J.mul(v_M_4253, 2.0)), v_D_4254)))
	J.sp(v_o_4255, "width", _t4691)
	var _t4692 = ceil(J.num(J.mul(J.add(v_h_4249, J.mul(v_M_4253, 2.0)), v_D_4254)))
	J.sp(v_o_4255, "height", _t4692)
	_s1745["c"] = J.mc(v_o_4255, "getContext", ["2d"])
	J.mc(_s1745["c"], "scale", [v_D_4254, v_D_4254])
	J.mc(_s1745["c"], "translate", [v_M_4253, v_M_4253])
	var _t4693 = _s1745["__p"]["crRnd"]
	var _t4694 = _s1745["__p"]["crHash"]
	_s1745["r"] = J.cl(_t4693, null, [J.cl(_t4694, null, [J.add(J.add(J.add(J.add(v_w_4248, "x"), v_h_4249), v_tone_4250), v_mode_4251)])])
	v_pr_4258 = J.seq(v_mode_4251, "p")
	v_off_4259 = J.seq(v_mode_4251, "off")
	v_pan_4260 = J.seq(v_mode_4251, "panel")
	var _t4695 = J.seq(v_mode_4251, "bar")
	v_bar_4261 = (_t4695 if _t4695 else J.seq(v_mode_4251, "fill"))
	v_ring_4262 = J.seq(J.mc(v_mode_4251, "indexOf", ["ring"]), 0.0)
	v_J_4263 = (2.4 if J.t(v_pan_4260) else (1.0 if J.t(v_bar_4261) else 1.7))
	var _t4696 = _s1745["__p"]["crShape"]
	v_P_4264 = J.cl(_t4696, null, [_s1745["r"], v_w_4248, v_h_4249, v_J_4263, v_ring_4262])
	var _t4697 = (not J.t(v_pr_4258))
	var _t4698 = ((not J.t(v_pan_4260)) if _t4697 else _t4697)
	if ((not J.t(v_bar_4261)) if _t4698 else _t4698):
		J.mc(_s1745["c"], "save", [])
		J.mc(_s1745["c"], "translate", [2.0, 3.0])
		var _t4699 = _s1745["__p"]["crTrace"]
		J.cl(_t4699, null, [_s1745["c"], v_P_4264])
		var _t4700 = _s1745["c"]
		J.sp(_t4700, "fillStyle", "rgba(0,0,0,0.55)")
		J.mc(_s1745["c"], "fill", [])
		J.mc(_s1745["c"], "restore", [])
	var _t4701 = _s1745["__p"]["crTrace"]
	J.cl(_t4701, null, [_s1745["c"], v_P_4264])
	var _t4702 = J.seq(v_mode_4251, "fill")
	if (J.seq(v_tone_4250, "dawn") if _t4702 else _t4702):
		v_gd_4265 = J.mc(_s1745["c"], "createLinearGradient", [0.0, 0.0, v_w_4248, 0.0])
		J.mc(v_gd_4265, "addColorStop", [0.0, "#24361f"])
		J.mc(v_gd_4265, "addColorStop", [0.62, "#6a2220"])
		J.mc(v_gd_4265, "addColorStop", [1.0, "#b8642c"])
		var _t4703 = _s1745["c"]
		J.sp(_t4703, "fillStyle", v_gd_4265)
	else:
		var _t4704 = _s1745["c"]
		var _t4705 = (J.gp(v_T_4252, "m") if J.seq(v_mode_4251, "fill") else J.gp(v_T_4252, "b"))
		J.sp(_t4704, "fillStyle", _t4705)
	J.mc(_s1745["c"], "fill", [])
	J.mc(_s1745["c"], "save", [])
	var _t4706 = _s1745["__p"]["crTrace"]
	J.cl(_t4706, null, [_s1745["c"], v_P_4264])
	J.mc(_s1745["c"], "clip", [])
	v_g_4266 = J.mc(_s1745["c"], "createLinearGradient", [0.0, 0.0, 0.0, v_h_4249])
	J.mc(v_g_4266, "addColorStop", [0.0, "rgba(255,240,220,0.06)"])
	J.mc(v_g_4266, "addColorStop", [1.0, "rgba(0,0,0,0.34)"])
	var _t4707 = _s1745["c"]
	J.sp(_t4707, "fillStyle", v_g_4266)
	J.mc(_s1745["c"], "fillRect", [0.0, 0.0, v_w_4248, v_h_4249])
	var _t4708 = _s1745["c"]
	var _t4709 = (J.gp(v_T_4252, "h") if J.seq(v_mode_4251, "fill") else J.gp(v_T_4252, "m"))
	J.sp(_t4708, "strokeStyle", _t4709)
	var _t4710 = _s1745["c"]
	J.sp(_t4710, "lineCap", "round")
	v_step_4267 = (7.0 if J.t(v_pan_4260) else (3.5 if J.t(v_bar_4261) else 5.0))
	v_k_4268 = ((-J.num(v_h_4249)) - 4.0)
	while true:
		if not J.cmp(v_k_4268, J.add(v_w_4248, v_h_4249), "<"): break
		var _t4711 = _s1745["c"]
		var _t4712 = ((0.22 if J.t(v_pan_4260) else (0.28 if J.seq(v_mode_4251, "fill") else 0.36)) + J.mul(J.cl(_s1745["r"], null, []), 0.25))
		J.sp(_t4711, "globalAlpha", _t4712)
		var _t4713 = _s1745["c"]
		var _t4714 = (0.8 + J.mul(J.cl(_s1745["r"], null, []), 1.4))
		J.sp(_t4713, "lineWidth", _t4714)
		J.mc(_s1745["c"], "beginPath", [])
		v_a0_4269 = J.add(v_k_4268, (J.sub(J.cl(_s1745["r"], null, []), 0.5) * 3.0))
		J.mc(_s1745["c"], "moveTo", [v_a0_4269, J.add(v_h_4249, 2.0)])
		J.mc(_s1745["c"], "lineTo", [J.add(J.add(v_a0_4269, J.mul(v_h_4249, 0.9)), (J.sub(J.cl(_s1745["r"], null, []), 0.5) * 4.0)), (-2.0)])
		J.mc(_s1745["c"], "stroke", [])
		var _t4715 = J.add(v_k_4268, J.add(v_step_4267, J.mul(J.cl(_s1745["r"], null, []), 2.0)))
		v_k_4268 = _t4715
	var _t4716 = _s1745["c"]
	var _t4717 = J.gp(v_T_4252, "e")
	J.sp(_t4716, "strokeStyle", _t4717)
	v_nq_4270 = (J.min_([260.0, J.div(J.mul(v_w_4248, v_h_4249), 900.0)]) if J.t(v_pan_4260) else J.div(v_w_4248, 6.0))
	v_q_4271 = 0.0
	while true:
		if not J.cmp(v_q_4271, v_nq_4270, "<"): break
		var _t4718 = _s1745["c"]
		var _t4719 = (0.05 + J.mul(J.cl(_s1745["r"], null, []), 0.08))
		J.sp(_t4718, "globalAlpha", _t4719)
		var _t4720 = _s1745["c"]
		var _t4721 = J.add(0.6, J.cl(_s1745["r"], null, []))
		J.sp(_t4720, "lineWidth", _t4721)
		v_qx_4272 = J.mul(J.cl(_s1745["r"], null, []), v_w_4248)
		v_qy_4273 = J.mul(J.cl(_s1745["r"], null, []), v_h_4249)
		J.mc(_s1745["c"], "beginPath", [])
		J.mc(_s1745["c"], "moveTo", [v_qx_4272, v_qy_4273])
		J.mc(_s1745["c"], "lineTo", [J.add(J.add(v_qx_4272, 6.0), J.mul(J.cl(_s1745["r"], null, []), 14.0)), (J.sub(v_qy_4273, 3.0) - J.mul(J.cl(_s1745["r"], null, []), 5.0))])
		J.mc(_s1745["c"], "stroke", [])
		v_q_4271 = J.num(v_q_4271) + 1.0
	var _t4722 = _s1745["c"]
	J.sp(_t4722, "globalAlpha", 1.0)
	var _t4723 = _s1745["c"]
	var _t4724 = J.mc(_s1745["c"], "createPattern", [J.cl(_s1745["__p"]["crGrain"], null, []), "repeat"])
	J.sp(_t4723, "fillStyle", _t4724)
	J.mc(_s1745["c"], "fillRect", [(-2.0), (-2.0), J.add(v_w_4248, 4.0), J.add(v_h_4249, 4.0)])
	var _t4725 = (not J.t(v_pan_4260))
	var _t4726 = ((not J.t(v_bar_4261)) if _t4725 else _t4725)
	if ((not J.t(v_ring_4262)) if _t4726 else _t4726):
		var _t4727 = _s1745["c"]
		var _t4728 = J.gp(v_T_4252, "h")
		J.sp(_t4727, "strokeStyle", _t4728)
		v_s2_4274 = 0.0
		while true:
			if not J.cmp(v_s2_4274, 3.0, "<"): break
			var _t4729 = _s1745["c"]
			var _t4730 = (0.08 + J.mul(J.cl(_s1745["r"], null, []), 0.12))
			J.sp(_t4729, "globalAlpha", _t4730)
			var _t4731 = _s1745["c"]
			var _t4732 = (2.0 + J.mul(J.cl(_s1745["r"], null, []), 2.0))
			J.sp(_t4731, "lineWidth", _t4732)
			J.mc(_s1745["c"], "beginPath", [])
			v_yy_4275 = J.add((3.0 + J.mul(v_s2_4274, 2.2)), J.cl(_s1745["r"], null, []))
			J.mc(_s1745["c"], "moveTo", [(6.0 + J.mul(J.cl(_s1745["r"], null, []), 6.0)), v_yy_4275])
			J.mc(_s1745["c"], "lineTo", [(J.sub(v_w_4248, 6.0) - J.mul(J.cl(_s1745["r"], null, []), 10.0)), J.add(v_yy_4275, (J.sub(J.cl(_s1745["r"], null, []), 0.5) * 2.0))])
			J.mc(_s1745["c"], "stroke", [])
			v_s2_4274 = J.num(v_s2_4274) + 1.0
	J.mc(_s1745["c"], "restore", [])
	v_passes_4276 = (4.0 if J.t(v_pr_4258) else (2.0 if J.t(v_bar_4261) else 3.0))
	_s1745["jj"] = (2.6 if J.t(v_pan_4260) else (1.0 if J.t(v_bar_4261) else 2.0))
	if (not J.seq(v_mode_4251, "fill")):
		v_p_4278 = 0.0
		while true:
			if not J.cmp(v_p_4278, v_passes_4276, "<"): break
			v_Q_4279 = J.mc(v_P_4264, "map", [Callable(self, "_f712").bind(_s1745)])
			var _t4733 = _s1745["c"]
			var _t4734 = (0.95 if J.seq(v_p_4278, 0.0) else (0.42 + J.mul(J.cl(_s1745["r"], null, []), 0.3)))
			J.sp(_t4733, "globalAlpha", _t4734)
			var _t4735 = _s1745["c"]
			var _t4736 = J.seq(v_p_4278, J.sub(v_passes_4276, 1.0))
			var _t4737 = ("rgba(0,0,0,0.55)" if ((not J.t(v_bar_4261)) if _t4736 else _t4736) else J.gp(v_T_4252, "e"))
			J.sp(_t4735, "strokeStyle", _t4737)
			var _t4738 = _s1745["c"]
			var _t4739 = (((3.4 if J.t(v_pr_4258) else (2.1 if J.t(v_pan_4260) else (1.3 if J.t(v_bar_4261) else 2.2))) - J.mul(v_p_4278, 0.35)) + J.mul(J.cl(_s1745["r"], null, []), 0.5))
			J.sp(_t4738, "lineWidth", _t4739)
			var _t4740 = _s1745["c"]
			J.sp(_t4740, "lineJoin", "round")
			var _t4741 = _s1745["__p"]["crTrace"]
			J.cl(_t4741, null, [_s1745["c"], v_Q_4279])
			J.mc(_s1745["c"], "stroke", [])
			v_p_4278 = J.num(v_p_4278) + 1.0
	var _t4742 = (not J.t(v_bar_4261))
	if ((not J.t(v_ring_4262)) if _t4742 else _t4742):
		var _t4743 = _s1745["c"]
		var _t4744 = J.gp(v_T_4252, "e")
		J.sp(_t4743, "fillStyle", _t4744)
		var _t4745 = [[0.0, 0.0], [v_w_4248, 0.0], [v_w_4248, v_h_4249], [0.0, v_h_4249]]
		J.mc(_t4745, "forEach", [Callable(self, "_f713").bind(_s1745)])
	var _t4747 = _s1745["c"]
	J.sp(_t4747, "globalAlpha", 1.0)
	if J.t(v_off_4259):
		var _t4748 = _s1745["c"]
		J.sp(_t4748, "globalCompositeOperation", "source-atop")
		var _t4749 = _s1745["c"]
		J.sp(_t4749, "fillStyle", "rgba(16,13,18,0.58)")
		J.mc(_s1745["c"], "fillRect", [(-J.num(v_M_4253)), (-J.num(v_M_4253)), J.add(v_w_4248, J.mul(2.0, v_M_4253)), J.add(v_h_4249, J.mul(2.0, v_M_4253))])
		var _t4750 = _s1745["c"]
		J.sp(_t4750, "globalCompositeOperation", "source-over")
	return v_o_4255

func _f714(this_, a: Array, env):
	var v_w_4288 = null; var v_h_4289 = null; var v_tone_4290 = null; var v_mode_4291 = null; var v_k_4292 = null; var v_v_4293 = null
	v_w_4288 = J.arg(a, 0)
	v_h_4289 = J.arg(a, 1)
	v_tone_4290 = J.arg(a, 2)
	v_mode_4291 = J.arg(a, 3)
	var _t4751 = J.max_([4.0, J.round(J.num(v_w_4288))])
	v_w_4288 = _t4751
	var _t4752 = J.max_([4.0, J.round(J.num(v_h_4289))])
	v_h_4289 = _t4752
	v_k_4292 = J.add((J.add((J.add((J.add(J.add(v_w_4288, "|"), v_h_4289) + "|"), v_tone_4290) + "|"), v_mode_4291) + "|"), env["DPR"])
	v_v_4293 = J.gp(J.gp(env["CR"], "cache"), v_k_4292)
	if (not J.t(v_v_4293)):
		if J.cmp(J.gp(env["CR"], "n"), 220.0, ">"):
			var _t4753 = env["CR"]
			var _t4754 = {}
			J.sp(_t4753, "cache", _t4754)
			var _t4755 = env["CR"]
			J.sp(_t4755, "n", 0.0)
		var _t4756 = J.gp(env["CR"], "cache")
		var _t4757 = env["crBuild"]
		var _t4758 = J.cl(_t4757, null, [v_w_4288, v_h_4289, v_tone_4290, v_mode_4291])
		J.sp(_t4756, v_k_4292, _t4758)
		v_v_4293 = _t4758
		var _t4759 = env["CR"]
		J.sp(_t4759, "n", J.num(J.gp(_t4759, "n")) + 1.0)
	return v_v_4293

func _f715(this_, a: Array, env):
	var v_c_4296 = null; var v_im_4297 = null; var v_x_4298 = null; var v_y_4299 = null; var v_M_4300 = null
	v_c_4296 = J.arg(a, 0)
	v_im_4297 = J.arg(a, 1)
	v_x_4298 = J.arg(a, 2)
	v_y_4299 = J.arg(a, 3)
	v_M_4300 = J.gp(env["CR"], "M")
	J.mc(v_c_4296, "drawImage", [v_im_4297, J.sub(v_x_4298, v_M_4300), J.sub(v_y_4299, v_M_4300), J.div(J.gp(v_im_4297, "width"), env["DPR"]), J.div(J.gp(v_im_4297, "height"), env["DPR"])])

func _f716(this_, a: Array, env):
	var v_c_4303 = null; var v_x_4304 = null; var v_y_4305 = null; var v_w_4306 = null; var v_h_4307 = null; var v_tone_4308 = null
	v_c_4303 = J.arg(a, 0)
	v_x_4304 = J.arg(a, 1)
	v_y_4305 = J.arg(a, 2)
	v_w_4306 = J.arg(a, 3)
	v_h_4307 = J.arg(a, 4)
	v_tone_4308 = J.arg(a, 5)
	var _t4760 = env["crBlit"]
	var _t4761 = env["crGet"]
	J.cl(_t4760, null, [v_c_4303, J.cl(_t4761, null, [v_w_4306, v_h_4307, (v_tone_4308 if J.t(v_tone_4308) else "paper"), "panel"]), v_x_4304, v_y_4305])

func _f718(this_, a: Array, env):
	var v_dx_4324 = null; var v_dy_4325 = null
	v_dx_4324 = J.arg(a, 0)
	v_dy_4325 = J.arg(a, 1)
	if J.t(env["mw"]):
		J.mc(env["c"], "fillText", [env["s"], J.add(env["x"], v_dx_4324), J.add(env["y"], v_dy_4325), env["mw"]])
	else:
		J.mc(env["c"], "fillText", [env["s"], J.add(env["x"], v_dx_4324), J.add(env["y"], v_dy_4325)])

func _f717(this_, a: Array, env):
	var v_sz_4315 = null; var v_col_4316 = null; var v_al_4317 = null; var v_mid_4319 = null; var v_wt_4320 = null; var v_F_4321 = null
	var _s1766 = {"__p": env, "c": null, "s": null, "x": null, "y": null, "mw": null}
	_s1766["c"] = J.arg(a, 0)
	_s1766["s"] = J.arg(a, 1)
	_s1766["x"] = J.arg(a, 2)
	_s1766["y"] = J.arg(a, 3)
	v_sz_4315 = J.arg(a, 4)
	v_col_4316 = J.arg(a, 5)
	v_al_4317 = J.arg(a, 6)
	_s1766["mw"] = J.arg(a, 7)
	v_mid_4319 = J.arg(a, 8)
	v_wt_4320 = J.arg(a, 9)
	var _t4762 = J.F_String([_s1766["s"]])
	_s1766["s"] = _t4762
	J.mc(_s1766["c"], "save", [])
	var _t4763 = _s1766["c"]
	var _t4764 = J.add((J.add(J.add((v_wt_4320 if J.t(v_wt_4320) else "bold"), " "), v_sz_4315) + "px "), _s1766["__p"]["FONT"])
	J.sp(_t4763, "font", _t4764)
	var _t4765 = _s1766["c"]
	var _t4766 = (v_al_4317 if J.t(v_al_4317) else "left")
	J.sp(_t4765, "textAlign", _t4766)
	var _t4767 = _s1766["c"]
	var _t4768 = ("middle" if J.t(v_mid_4319) else "alphabetic")
	J.sp(_t4767, "textBaseline", _t4768)
	var _t4769 = _s1766["c"]
	J.sp(_t4769, "lineJoin", "round")
	v_F_4321 = Callable(self, "_f718").bind(_s1766)
	var _t4770 = _s1766["c"]
	J.sp(_t4770, "fillStyle", "rgba(6,3,8,0.88)")
	J.cl(v_F_4321, null, [1.4, 2.0])
	var _t4771 = _s1766["c"]
	var _t4772 = J.max_([2.4, J.mul(v_sz_4315, 0.2)])
	J.sp(_t4771, "lineWidth", _t4772)
	var _t4773 = _s1766["c"]
	J.sp(_t4773, "strokeStyle", "rgba(8,5,10,0.82)")
	if J.t(_s1766["mw"]):
		J.mc(_s1766["c"], "strokeText", [_s1766["s"], _s1766["x"], _s1766["y"], _s1766["mw"]])
	else:
		J.mc(_s1766["c"], "strokeText", [_s1766["s"], _s1766["x"], _s1766["y"]])
	var _t4774 = _s1766["c"]
	var _t4775 = _s1766["__p"]["crCol"]
	var _t4776 = J.cl(_t4775, null, [(v_col_4316 if J.t(v_col_4316) else "#efe5cf")])
	J.sp(_t4774, "fillStyle", _t4776)
	J.cl(v_F_4321, null, [0.0, 0.0])
	var _t4777 = _s1766["c"]
	var _t4778 = J.mul(J.gp(_t4777, "globalAlpha"), 0.35)
	J.sp(_t4777, "globalAlpha", _t4778)
	J.cl(v_F_4321, null, [0.6, (-0.4)])
	J.mc(_s1766["c"], "restore", [])

func _f719(this_, a: Array, env):
	var v_s_4328 = null; var v_x_4329 = null; var v_y_4330 = null; var v_mw_4331 = null; var v_m_4332 = null; var v_sz_4333 = null; var v_bold_4334 = null
	v_s_4328 = J.arg(a, 0)
	v_x_4329 = J.arg(a, 1)
	v_y_4330 = J.arg(a, 2)
	v_mw_4331 = J.arg(a, 3)
	v_m_4332 = J.mc(J.re("(\\d+(?:\\.\\d+)?)px", ""), "exec", [J.gp(env["ctx"], "font")])
	v_sz_4333 = (J.num(J.gp(v_m_4332, 1.0)) if J.t(v_m_4332) else 13.0)
	v_bold_4334 = J.mc(J.re("bold", ""), "test", [J.gp(env["ctx"], "font")])
	var _t4779 = env["crText"]
	J.cl(_t4779, null, [env["ctx"], v_s_4328, v_x_4329, v_y_4330, v_sz_4333, J.gp(env["ctx"], "fillStyle"), J.gp(env["ctx"], "textAlign"), v_mw_4331, false, ("bold" if J.t(v_bold_4334) else "normal")])

func _f720(this_, a: Array, env):
	var v_c_4337 = null; var v_x_4338 = null; var v_y_4339 = null; var v_w_4340 = null; var v_h_4341 = null; var v_f_4342 = null; var v_tone_4343 = null
	v_c_4337 = J.arg(a, 0)
	v_x_4338 = J.arg(a, 1)
	v_y_4339 = J.arg(a, 2)
	v_w_4340 = J.arg(a, 3)
	v_h_4341 = J.arg(a, 4)
	v_f_4342 = J.arg(a, 5)
	v_tone_4343 = J.arg(a, 6)
	var _t4780 = env["crBlit"]
	var _t4781 = env["crGet"]
	J.cl(_t4780, null, [v_c_4337, J.cl(_t4781, null, [v_w_4340, v_h_4341, "ink", "bar"]), v_x_4338, v_y_4339])
	var _t4782 = J.max_([0.0, J.min_([1.0, (v_f_4342 if J.t(v_f_4342) else 0.0)])])
	v_f_4342 = _t4782
	if J.cmp(v_f_4342, 0.0, "<="):
		return null
	J.mc(v_c_4337, "save", [])
	J.mc(v_c_4337, "beginPath", [])
	J.mc(v_c_4337, "rect", [J.sub(v_x_4338, 2.0), J.sub(v_y_4339, 3.0), (J.mul(v_w_4340, v_f_4342) + 2.0), J.add(v_h_4341, 6.0)])
	J.mc(v_c_4337, "clip", [])
	var _t4783 = env["crBlit"]
	var _t4784 = env["crGet"]
	J.cl(_t4783, null, [v_c_4337, J.cl(_t4784, null, [v_w_4340, v_h_4341, (v_tone_4343 if J.t(v_tone_4343) else "red"), "fill"]), v_x_4338, v_y_4339])
	J.mc(v_c_4337, "restore", [])
	if J.cmp(v_f_4342, 1.0, "<"):
		var _t4785 = J.gp(J.gp(env["CR"], "tones"), v_tone_4343)
		var _t4786 = J.gp((_t4785 if J.t(_t4785) else J.gp(J.gp(env["CR"], "tones"), "red")), "e")
		J.sp(v_c_4337, "strokeStyle", _t4786)
		J.sp(v_c_4337, "globalAlpha", 0.8)
		J.sp(v_c_4337, "lineWidth", 2.0)
		J.mc(v_c_4337, "beginPath", [])
		J.mc(v_c_4337, "moveTo", [J.add(v_x_4338, J.mul(v_w_4340, v_f_4342)), J.sub(v_y_4339, 1.0)])
		J.mc(v_c_4337, "lineTo", [J.add(J.add(v_x_4338, J.mul(v_w_4340, v_f_4342)), 1.0), J.add(J.add(v_y_4339, v_h_4341), 1.0)])
		J.mc(v_c_4337, "stroke", [])
		J.sp(v_c_4337, "globalAlpha", 1.0)

func _f721(this_, a: Array, env):
	var v_col_4346 = null; var v_k_4347 = null
	v_col_4346 = J.arg(a, 0)
	v_k_4347 = J.mc(J.F_String([(v_col_4346 if J.t(v_col_4346) else "")]), "toLowerCase", [])
	var _t4787 = J.gp({"#6e1c1c": "red", "#5a1c1c": "red", "#2a4a7a": "violet", "#2f5a4a": "moss", "#3a5a2a": "moss", "#2e3a34": "moss", "#8a5a14": "rust", "#3a3a40": "ink", "#2c2c33": "ink", "#24242a": "ink", "#26262c": "ink"}, v_k_4347)
	return (_t4787 if J.t(_t4787) else "ink")

func _f722(this_, a: Array, env):
	var v_c_4350 = null; var v_x_4351 = null; var v_y_4352 = null; var v_w_4353 = null; var v_h_4354 = null; var v_label_4355 = null; var v_tone_4356 = null; var v_pressed_4357 = null; var v_off_4358 = null; var v_dy_4359 = null
	v_c_4350 = J.arg(a, 0)
	v_x_4351 = J.arg(a, 1)
	v_y_4352 = J.arg(a, 2)
	v_w_4353 = J.arg(a, 3)
	v_h_4354 = J.arg(a, 4)
	v_label_4355 = J.arg(a, 5)
	v_tone_4356 = J.arg(a, 6)
	v_pressed_4357 = J.arg(a, 7)
	v_off_4358 = J.arg(a, 8)
	v_dy_4359 = (2.0 if J.t(v_pressed_4357) else 0.0)
	var _t4788 = env["crBlit"]
	var _t4789 = env["crGet"]
	J.cl(_t4788, null, [v_c_4350, J.cl(_t4789, null, [v_w_4353, v_h_4354, v_tone_4356, ("p" if J.t(v_pressed_4357) else ("off" if J.t(v_off_4358) else "n"))]), v_x_4351, J.add(v_y_4352, v_dy_4359)])
	if J.t(v_label_4355):
		var _t4790 = env["crText"]
		var _t4793 = J.add(v_x_4351, J.div(v_w_4353, 2.0))
		var _t4794 = J.add(J.add(J.add(v_y_4352, J.div(v_h_4354, 2.0)), v_dy_4359), 1.0)
		var _t4795 = (17.0 if J.cmp(v_h_4354, 50.0, ">=") else 16.0)
		var _t4792 = null
		if J.t(v_off_4358):
			_t4792 = "#8a7e84"
		else:
			var _t4791 = J.gp(J.gp(env["CR"], "tones"), v_tone_4356)
			_t4792 = J.gp((_t4791 if J.t(_t4791) else J.gp(J.gp(env["CR"], "tones"), "ink")), "t")
		J.cl(_t4790, null, [v_c_4350, v_label_4355, _t4793, _t4794, _t4795, _t4792, "center", J.sub(v_w_4353, 10.0), true])

func _f723(this_, a: Array, env):
	var v_x_4362 = null; var v_y_4363 = null; var v_t_4364 = null; var v_col_4365 = null; var v_w_4366 = null
	v_x_4362 = J.arg(a, 0)
	v_y_4363 = J.arg(a, 1)
	v_t_4364 = J.arg(a, 2)
	v_col_4365 = J.arg(a, 3)
	var _t4796 = env["ctx"]
	var _t4797 = J.add("bold 12px ", env["FONT"])
	J.sp(_t4796, "font", _t4797)
	v_w_4366 = (ceil(J.num(J.div(J.min_([190.0, J.add(J.gp(J.mc(env["ctx"], "measureText", [v_t_4364]), "width"), 16.0)]), 8.0))) * 8.0)
	var _t4798 = env["crBlit"]
	var _t4800 = env["ctx"]
	var _t4799 = env["crGet"]
	J.cl(_t4798, null, [_t4800, J.cl(_t4799, null, [v_w_4366, 22.0, "note", "bar"]), J.sub(v_x_4362, J.div(v_w_4366, 2.0)), J.sub(v_y_4363, 24.0)])
	J.mc(env["ctx"], "save", [])
	var _t4801 = env["ctx"]
	var _t4802 = (v_col_4365 if J.t(v_col_4365) else "#2a1e1c")
	J.sp(_t4801, "fillStyle", _t4802)
	var _t4803 = env["ctx"]
	J.sp(_t4803, "textAlign", "center")
	J.mc(env["ctx"], "fillText", [v_t_4364, v_x_4362, J.sub(v_y_4363, 9.0), J.sub(v_w_4366, 8.0)])
	J.mc(env["ctx"], "restore", [])

func _f724(this_, a: Array, env):
	var _t4804 = env["crPanel"]
	J.cl(_t4804, null, [env["ctx"], (-8.0), (-8.0), J.add(env["VW"], 16.0), J.add(env["VH"], 16.0), "paper"])

func _f725(this_, a: Array, env):
	var v_id_4371 = null
	v_id_4371 = J.arg(a, 0)
	var _t4806 = (J.seq(J.gp(env["ptr"], "btn"), v_id_4371) if J.t(env["ptr"]) else env["ptr"])
	if not J.t(_t4806):
		var _t4805 = (J.seq(J.gp(env["PRESS"], "id"), v_id_4371) if J.t(env["PRESS"]) else env["PRESS"])
		_t4806 = ((J.sub(J.S_performance_("now", []), J.gp(env["PRESS"], "t")) < 200.0) if J.t(_t4805) else _t4805)
	return _t4806

func _f726(this_, a: Array, env):
	var v_id_4374 = null; var v_x_4375 = null; var v_y_4376 = null; var v_w_4377 = null; var v_h_4378 = null; var v_label_4379 = null; var v_col_4380 = null; var v_on_4381 = null
	v_id_4374 = J.arg(a, 0)
	v_x_4375 = J.arg(a, 1)
	v_y_4376 = J.arg(a, 2)
	v_w_4377 = J.arg(a, 3)
	v_h_4378 = J.arg(a, 4)
	v_label_4379 = J.arg(a, 5)
	v_col_4380 = J.arg(a, 6)
	v_on_4381 = J.arg(a, 7)
	J.mc(env["buttons"], "push", [{"id": v_id_4374, "x": v_x_4375, "y": v_y_4376, "w": v_w_4377, "h": v_h_4378}])
	var _t4807 = env["crBtn"]
	var _t4809 = env["ctx"]
	var _t4808 = env["crTone"]
	var _t4811 = J.cl(_t4808, null, [v_col_4380])
	var _t4810 = env["crPressed"]
	J.cl(_t4807, null, [_t4809, v_x_4375, v_y_4376, v_w_4377, v_h_4378, v_label_4379, _t4811, J.cl(_t4810, null, [v_id_4374]), J.seq(v_on_4381, false)])

func _f728(this_, a: Array, env):
	var v_un_4423 = null; var v_top_4424 = null; var v_col_4425 = null; var v_lb_4426 = null; var v_tx_4427 = null; var v_tt_4428 = null
	v_un_4423 = J.arg(a, 0)
	var _t4824 = env["__p"]["fy"]
	v_top_4424 = J.add(J.cl(_t4824, null, [J.add(J.gp(v_un_4423, "f"), 1.0)]), 16.0)
	if J.t(J.gp(v_un_4423, "lit")):
		var _t4825 = env["__p"]["ctx"]
		J.sp(_t4825, "fillStyle", "rgba(255,230,140,0.38)")
		J.mc(env["__p"]["ctx"], "fillRect", [J.gp(J.gp(v_un_4423, "rx"), 0.0), v_top_4424, J.sub(J.gp(J.gp(v_un_4423, "rx"), 1.0), J.gp(J.gp(v_un_4423, "rx"), 0.0)), (J.sub(J.gp(v_un_4423, "y"), v_top_4424) - 4.0)])
	var _t4826 = J.gp(v_un_4423, "task")
	if J.t(((not J.t(J.gp(v_un_4423, "taskDone"))) if J.t(_t4826) else _t4826)):
		v_col_4425 = J.gp({"food": "#ffd54a", "money": "#ffe27a", "comb": "#e8b0a0"}, J.gp(v_un_4423, "task"))
		var _t4827 = env["__p"]["ctx"]
		J.sp(_t4827, "strokeStyle", v_col_4425)
		var _t4828 = env["__p"]["ctx"]
		J.sp(_t4828, "lineWidth", 3.0)
		var _t4829 = env["__p"]["ctx"]
		var _t4830 = (0.6 + (0.3 * sin(J.num(J.mul(J.gp(env["__p"]["G"], "t"), 4.0)))))
		J.sp(_t4829, "globalAlpha", _t4830)
		J.mc(env["__p"]["ctx"], "beginPath", [])
		J.mc(env["__p"]["ctx"], "ellipse", [J.gp(v_un_4423, "x"), J.sub(J.gp(v_un_4423, "y"), 34.0), 16.0, 5.0, 0.0, 0.0, 7.0])
		J.mc(env["__p"]["ctx"], "stroke", [])
		var _t4831 = env["__p"]["ctx"]
		J.sp(_t4831, "globalAlpha", 1.0)
		var _t4832 = env["__p"]["ctx"]
		var _t4833 = J.add("bold 11px ", env["__p"]["FONT"])
		J.sp(_t4832, "font", _t4833)
		var _t4834 = env["__p"]["ctx"]
		J.sp(_t4834, "lineWidth", 3.0)
		var _t4835 = env["__p"]["ctx"]
		J.sp(_t4835, "strokeStyle", "#0c0c0e")
		var _t4836 = env["__p"]["ctx"]
		J.sp(_t4836, "textAlign", "center")
		v_lb_4426 = J.gp({"food": "宵夜", "money": "銀包", "comb": "梳頭"}, J.gp(v_un_4423, "task"))
		J.mc(env["__p"]["ctx"], "strokeText", [v_lb_4426, J.gp(v_un_4423, "x"), J.sub(J.gp(v_un_4423, "y"), 44.0)])
		var _t4837 = env["__p"]["ctx"]
		J.sp(_t4837, "fillStyle", v_col_4425)
		J.mc(env["__p"]["ctx"], "fillText", [v_lb_4426, J.gp(v_un_4423, "x"), J.sub(J.gp(v_un_4423, "y"), 44.0)])
	if J.t(J.gp(v_un_4423, "story")):
		v_tx_4427 = J.div(J.add(J.gp(J.gp(v_un_4423, "rx"), 0.0), J.gp(J.gp(v_un_4423, "rx"), 1.0)), 2.0)
		var _t4838 = J.gp(env["__p"]["G"], "story")
		v_tt_4428 = ("✦已收集" if J.cmp(J.mc(_t4838, "indexOf", [J.gp(v_un_4423, "si")]), 0.0, ">=") else "✦故事")
		var _t4839 = env["__p"]["ctx"]
		var _t4840 = J.add("bold 11px ", env["__p"]["FONT"])
		J.sp(_t4839, "font", _t4840)
		var _t4841 = env["__p"]["ctx"]
		J.sp(_t4841, "textAlign", "center")
		var _t4842 = env["__p"]["ctx"]
		J.sp(_t4842, "lineWidth", 3.0)
		var _t4843 = env["__p"]["ctx"]
		J.sp(_t4843, "strokeStyle", "#0c0c0e")
		J.mc(env["__p"]["ctx"], "strokeText", [v_tt_4428, v_tx_4427, J.add(v_top_4424, 14.0)])
		var _t4844 = env["__p"]["ctx"]
		J.sp(_t4844, "fillStyle", "#cfe8dc")
		J.mc(env["__p"]["ctx"], "fillText", [v_tt_4428, v_tx_4427, J.add(v_top_4424, 14.0)])

func _f729(this_, a: Array, env):
	var v_id_4431 = null; var v_n_4432 = null
	v_id_4431 = J.arg(a, 0)
	var _t4847 = J.gp(env["__p"]["G"], "gate")
	if J.t(((not J.seq(J.gp(J.gp(env["__p"]["G"], "gate"), "node"), v_id_4431)) if J.t(_t4847) else _t4847)):
		return null
	v_n_4432 = J.gp(J.gp(env["__p"]["G"], "nodes"), v_id_4431)
	var _t4848 = env["__p"]["ctx"]
	var _t4849 = (0.5 + (0.3 * sin(J.num(J.mul(J.gp(env["__p"]["G"], "t"), 2.5)))))
	J.sp(_t4848, "globalAlpha", _t4849)
	var _t4850 = env["__p"]["ctx"]
	J.sp(_t4850, "fillStyle", "#3fbf8f")
	J.mc(env["__p"]["ctx"], "beginPath", [])
	J.mc(env["__p"]["ctx"], "ellipse", [J.gp(v_n_4432, "x"), J.sub(J.gp(v_n_4432, "y"), 4.0), 26.0, 9.0, 0.0, 0.0, 7.0])
	J.mc(env["__p"]["ctx"], "fill", [])
	var _t4851 = env["__p"]["ctx"]
	J.sp(_t4851, "globalAlpha", 1.0)
	var _t4852 = env["__p"]["ctx"]
	J.sp(_t4852, "fillStyle", "#e2e6e0")
	var _t4853 = env["__p"]["ctx"]
	var _t4854 = J.add("bold 12px ", env["__p"]["FONT"])
	J.sp(_t4853, "font", _t4854)
	var _t4855 = env["__p"]["ctx"]
	J.sp(_t4855, "textAlign", "center")
	var _t4856 = env["__p"]["ctx"]
	J.sp(_t4856, "lineWidth", 3.0)
	var _t4857 = env["__p"]["ctx"]
	J.sp(_t4857, "strokeStyle", "#0c0c0e")
	J.mc(env["__p"]["ctx"], "strokeText", ["回陰間", J.gp(v_n_4432, "x"), J.sub(J.gp(v_n_4432, "y"), 14.0)])
	J.mc(env["__p"]["ctx"], "fillText", ["回陰間", J.gp(v_n_4432, "x"), J.sub(J.gp(v_n_4432, "y"), 14.0)])

func _f730(this_, a: Array, env):
	var v_u_4435 = null
	v_u_4435 = J.arg(a, 0)
	return J.seq(J.gp(v_u_4435, "f"), env["f"])

func _f731(this_, a: Array, env):
	var v_u_4438 = null
	v_u_4438 = J.arg(a, 0)
	return J.div(J.add(J.gp(J.gp(v_u_4438, "rx"), 0.0), J.gp(J.gp(v_u_4438, "rx"), 1.0)), 2.0)

func _f732(this_, a: Array, env):
	var v_lx_4441 = null; var v_gr_4442 = null
	v_lx_4441 = J.arg(a, 0)
	v_gr_4442 = J.mc(env["__p"]["ctx"], "createRadialGradient", [v_lx_4441, env["ly"], 2.0, v_lx_4441, env["ly"], 46.0])
	J.mc(v_gr_4442, "addColorStop", [0.0, (J.add("rgba(255,214,140,", J.mul(0.32, env["fl"])) + ")")])
	J.mc(v_gr_4442, "addColorStop", [1.0, "rgba(255,214,140,0)"])
	var _t4865 = env["__p"]["ctx"]
	J.sp(_t4865, "fillStyle", v_gr_4442)
	J.mc(env["__p"]["ctx"], "fillRect", [J.sub(v_lx_4441, 46.0), J.sub(env["ly"], 46.0), 92.0, 92.0])

func _f733(this_, a: Array, env):
	var v_w_4445 = null; var v_a_4446 = null; var v_gr_4447 = null
	v_w_4445 = J.arg(a, 0)
	v_a_4446 = J.div(J.gp(v_w_4445, "t"), 0.9)
	v_gr_4447 = J.mc(env["__p"]["ctx"], "createRadialGradient", [J.gp(v_w_4445, "x"), J.sub(J.gp(v_w_4445, "y"), 30.0), 4.0, J.gp(v_w_4445, "x"), J.sub(J.gp(v_w_4445, "y"), 30.0), 60.0])
	J.mc(v_gr_4447, "addColorStop", [0.0, (J.add("rgba(255,220,140,", J.mul(0.7, v_a_4446)) + ")")])
	J.mc(v_gr_4447, "addColorStop", [1.0, "rgba(255,220,140,0)"])
	var _t4877 = env["__p"]["ctx"]
	J.sp(_t4877, "fillStyle", v_gr_4447)
	J.mc(env["__p"]["ctx"], "fillRect", [J.sub(J.gp(v_w_4445, "x"), 60.0), J.sub(J.gp(v_w_4445, "y"), 90.0), 120.0, 120.0])
	var _t4878 = env["__p"]["ctx"]
	var _t4879 = (J.add("rgba(255,230,160,", v_a_4446) + ")")
	J.sp(_t4878, "strokeStyle", _t4879)
	var _t4880 = env["__p"]["ctx"]
	J.sp(_t4880, "lineWidth", 2.0)
	J.mc(env["__p"]["ctx"], "beginPath", [])
	J.mc(env["__p"]["ctx"], "arc", [J.gp(v_w_4445, "x"), J.sub(J.gp(v_w_4445, "y"), 30.0), (30.0 + (J.sub(1.0, v_a_4446) * 30.0)), 0.0, 7.0])
	J.mc(env["__p"]["ctx"], "stroke", [])

func _f734(this_, a: Array, env):
	var v_r_4450 = null
	v_r_4450 = J.arg(a, 0)
	var _t4882 = env["__p"]["pplDrawRes"]
	J.cl(_t4882, null, [v_r_4450, env["viewW"], env["viewH"]])

func _f735(this_, a: Array, env):
	var v_w_4453 = null
	v_w_4453 = J.arg(a, 0)
	var _t4885 = env["__p"]["ctx"]
	var _t4886 = (J.add("rgba(255,215,90,", J.mul(J.gp(v_w_4453, "t"), 0.85)) + ")")
	J.sp(_t4885, "strokeStyle", _t4886)
	var _t4887 = env["__p"]["ctx"]
	J.sp(_t4887, "lineWidth", 4.0)
	J.mc(env["__p"]["ctx"], "beginPath", [])
	J.mc(env["__p"]["ctx"], "ellipse", [J.gp(env["T"], "x"), J.sub(env["ty"], 30.0), J.gp(v_w_4453, "r"), J.mul(J.gp(v_w_4453, "r"), 0.45), 0.0, 0.0, 7.0])
	J.mc(env["__p"]["ctx"], "stroke", [])

func _f736(this_, a: Array, env):
	var v_o_4456 = null
	v_o_4456 = J.arg(a, 0)
	var _t4904 = J.cmp(J.gp(v_o_4456, "sealT"), 0.0, ">")
	if ((not J.t(J.gp(v_o_4456, "home"))) if _t4904 else _t4904):
		var _t4905 = env["__p"]["ctx"]
		J.sp(_t4905, "strokeStyle", "rgba(255,215,90,0.7)")
		var _t4906 = env["__p"]["ctx"]
		J.sp(_t4906, "lineWidth", 2.0)
		J.mc(env["__p"]["ctx"], "beginPath", [])
		J.mc(env["__p"]["ctx"], "arc", [J.gp(v_o_4456, "x"), J.sub(J.gp(v_o_4456, "y"), J.mul(J.gp(J.gp(v_o_4456, "d"), "h"), 0.5)), J.mul(J.gp(J.gp(v_o_4456, "d"), "h"), 0.55), 0.0, 7.0])
		J.mc(env["__p"]["ctx"], "stroke", [])

func _f738(this_, a: Array, env):
	var v_lx_4475 = null; var v_k_4476 = null
	v_lx_4475 = J.arg(a, 0)
	v_k_4476 = J.arg(a, 1)
	J.mc(env["__p"]["ctx"], "beginPath", [])
	J.mc(env["__p"]["ctx"], "moveTo", [v_lx_4475, (-8.0)])
	J.mc(env["__p"]["ctx"], "lineTo", [J.add(v_lx_4475, (sin(J.num(J.add(J.mul(J.gp(env["__p"]["G"], "t"), 20.0), v_k_4476))) * 4.0)), 0.0])
	J.mc(env["__p"]["ctx"], "stroke", [])

func _f737(this_, a: Array, env):
	var v_s_4459 = null; var v_H_4460 = null; var v_HHt_4461 = null; var v_sw_4462 = null; var v_bg_4463 = null; var v_bob_4464 = null; var v_fl_4465 = null; var v_mx_4466 = null; var v_my_4467 = null; var v_mg_4468 = null; var v_na_4469 = null; var v_q_4470 = null; var v_lab_4471 = null; var v_bb_4472 = null
	v_s_4459 = J.arg(a, 0)
	v_H_4460 = J.gp(env["__p"]["HUM"], J.gp(v_s_4459, "kind"))
	v_HHt_4461 = (J.mc(env["__p"]["PPLFX"], "hgt", [J.gp(v_H_4460, "spr"), J.gp(v_H_4460, "spr"), J.gp(v_H_4460, "h")]) if J.t(J.gp(v_H_4460, "spr")) else J.gp(v_H_4460, "h"))
	var _t4908 = J.gp(v_s_4459, "alertT")
	var _t4909 = J.gp(v_s_4459, "alertT")
	var _t4910 = J.max_([0.0, J.sub((_t4909 if J.t(_t4909) else 0.0), 0.0)])
	J.sp(v_s_4459, "alertT", _t4910)
	var _t4911 = J.seq(J.gp(v_s_4459, "kind"), "guard")
	if (_t4911 if _t4911 else J.seq(J.gp(v_s_4459, "kind"), "compass")):
		v_sw_4462 = (((sin(J.num(J.add(J.mul(J.gp(env["__p"]["G"], "t"), 23.0), J.gp(v_s_4459, "x")))) * 46.0) + (sin(J.num(J.mul(J.gp(env["__p"]["G"], "t"), 37.0))) * 18.0)) if J.seq(J.gp(v_s_4459, "state"), "scared") else (sin(J.num((J.mul(J.gp(env["__p"]["G"], "t"), 2.4) + J.mul(J.gp(v_s_4459, "x"), 0.01)))) * 14.0))
		v_bg_4463 = J.mc(env["__p"]["ctx"], "createLinearGradient", [J.gp(v_s_4459, "x"), 0.0, J.add(J.gp(v_s_4459, "x"), J.mul(J.gp(v_s_4459, "dir"), 150.0)), 0.0])
		var _t4912 = J.seq(J.gp(v_s_4459, "state"), "chase")
		J.mc(v_bg_4463, "addColorStop", [0.0, (J.add("rgba(255,245,180,", ((0.45 if (_t4912 if _t4912 else J.seq(J.gp(v_s_4459, "kind"), "compass")) else 0.3) * ((0.4 + (0.6 * absf(J.num(sin(J.num(J.mul(J.gp(env["__p"]["G"], "t"), 29.0))))))) if J.seq(J.gp(v_s_4459, "state"), "scared") else 1.0))) + ")")])
		J.mc(v_bg_4463, "addColorStop", [1.0, "rgba(255,245,180,0)"])
		var _t4913 = env["__p"]["ctx"]
		J.sp(_t4913, "fillStyle", v_bg_4463)
		J.mc(env["__p"]["ctx"], "beginPath", [])
		J.mc(env["__p"]["ctx"], "moveTo", [J.add(J.gp(v_s_4459, "x"), J.mul(J.gp(v_s_4459, "dir"), 8.0)), J.sub(J.gp(v_s_4459, "y"), 30.0)])
		J.mc(env["__p"]["ctx"], "lineTo", [J.add(J.gp(v_s_4459, "x"), J.mul(J.gp(v_s_4459, "dir"), 150.0)), J.add(J.sub(J.gp(v_s_4459, "y"), 56.0), v_sw_4462)])
		J.mc(env["__p"]["ctx"], "lineTo", [J.add(J.gp(v_s_4459, "x"), J.mul(J.gp(v_s_4459, "dir"), 150.0)), (J.sub(J.gp(v_s_4459, "y"), 4.0) + J.mul(v_sw_4462, 0.4))])
		J.mc(env["__p"]["ctx"], "closePath", [])
		J.mc(env["__p"]["ctx"], "fill", [])
	var _t4914 = env["__p"]["ctx"]
	J.sp(_t4914, "fillStyle", "rgba(0,0,0,0.45)")
	J.mc(env["__p"]["ctx"], "beginPath", [])
	J.mc(env["__p"]["ctx"], "ellipse", [J.gp(v_s_4459, "x"), J.sub(J.gp(v_s_4459, "y"), 1.0), 16.0, 4.0, 0.0, 0.0, 7.0])
	J.mc(env["__p"]["ctx"], "fill", [])
	var _t4916 = null
	if J.seq(J.gp(v_s_4459, "kind"), "dog"):
		_t4916 = ((-absf(J.num(sin(J.num(J.add(J.mul(J.gp(env["__p"]["G"], "t"), 18.0), J.gp(v_s_4459, "x"))))))) * 5.0)
	else:
		var _t4915 = env["__p"]["pplStep"]
		_t4916 = J.cl(_t4915, null, [v_s_4459])
	v_bob_4464 = _t4916
	v_fl_4465 = (J.cmp(J.gp(v_s_4459, "vx"), 0.0, "<") if J.seq(J.gp(v_s_4459, "state"), "flee") else J.cmp(J.gp(v_s_4459, "dir"), 0.0, "<"))
	if J.seq(J.gp(v_s_4459, "kind"), "dog"):
		J.mc(env["__p"]["ctx"], "save", [])
		J.mc(env["__p"]["ctx"], "translate", [J.gp(v_s_4459, "x"), J.add(J.gp(v_s_4459, "y"), v_bob_4464)])
		J.mc(env["__p"]["ctx"], "scale", [((-1.0) if J.t(v_fl_4465) else 1.0), 1.0])
		var _t4917 = env["__p"]["ctx"]
		J.sp(_t4917, "fillStyle", "#3a2e24")
		var _t4918 = env["__p"]["ctx"]
		J.sp(_t4918, "strokeStyle", "#e8d8b0")
		var _t4919 = env["__p"]["ctx"]
		J.sp(_t4919, "lineWidth", 1.5)
		J.mc(env["__p"]["ctx"], "beginPath", [])
		J.mc(env["__p"]["ctx"], "ellipse", [0.0, (-14.0), 20.0, 9.0, 0.0, 0.0, 7.0])
		J.mc(env["__p"]["ctx"], "fill", [])
		J.mc(env["__p"]["ctx"], "stroke", [])
		J.mc(env["__p"]["ctx"], "beginPath", [])
		J.mc(env["__p"]["ctx"], "ellipse", [18.0, (-22.0), 9.0, 7.0, 0.0, 0.0, 7.0])
		J.mc(env["__p"]["ctx"], "fill", [])
		J.mc(env["__p"]["ctx"], "stroke", [])
		var _t4920 = env["__p"]["ctx"]
		J.sp(_t4920, "fillStyle", "#ff4a3a")
		J.mc(env["__p"]["ctx"], "fillRect", [21.0, (-25.0), 3.0, 3.0])
		var _t4921 = env["__p"]["ctx"]
		J.sp(_t4921, "strokeStyle", "#3a2e24")
		var _t4922 = env["__p"]["ctx"]
		J.sp(_t4922, "lineWidth", 3.0)
		var _t4923 = [(-12.0), (-4.0), 6.0, 12.0]
		J.mc(_t4923, "forEach", [Callable(self, "_f738").bind(env)])
		J.mc(env["__p"]["ctx"], "beginPath", [])
		J.mc(env["__p"]["ctx"], "moveTo", [(-19.0), (-16.0)])
		J.mc(env["__p"]["ctx"], "lineTo", [(-28.0), ((-24.0) + (sin(J.num(J.mul(J.gp(env["__p"]["G"], "t"), 25.0))) * 3.0))])
		J.mc(env["__p"]["ctx"], "stroke", [])
		J.mc(env["__p"]["ctx"], "restore", [])
	else:
		var _t4924 = env["__p"]["ctx"]
		var _t4925 = J.seq(J.gp(v_s_4459, "kind"), "mirror")
		var _t4926 = ("rgba(255,215,90,0.8)" if (_t4925 if _t4925 else J.seq(J.gp(v_s_4459, "kind"), "decoy")) else "rgba(255,236,200,0.75)")
		J.sp(_t4924, "shadowColor", _t4926)
		var _t4927 = env["__p"]["ctx"]
		J.sp(_t4927, "shadowBlur", 6.0)
		var _t4928 = env["__p"]["pplGuard"]
		J.cl(_t4928, null, [v_s_4459, v_H_4460, v_bob_4464, v_fl_4465])
		var _t4929 = env["__p"]["ctx"]
		J.sp(_t4929, "shadowBlur", 0.0)
	if J.seq(J.gp(v_s_4459, "kind"), "mirror"):
		v_mx_4466 = J.add(J.gp(v_s_4459, "x"), J.mul(J.gp(v_s_4459, "dir"), 14.0))
		v_my_4467 = J.sub(J.gp(v_s_4459, "y"), 40.0)
		var _t4930 = env["__p"]["ctx"]
		J.sp(_t4930, "fillStyle", "#d8c070")
		J.mc(env["__p"]["ctx"], "beginPath", [])
		J.mc(env["__p"]["ctx"], "arc", [v_mx_4466, v_my_4467, 8.0, 0.0, 7.0])
		J.mc(env["__p"]["ctx"], "fill", [])
		var _t4931 = env["__p"]["ctx"]
		var _t4932 = (J.add("rgba(220,245,255,", (0.6 + (0.3 * sin(J.num(J.mul(J.gp(env["__p"]["G"], "t"), 6.0)))))) + ")")
		J.sp(_t4931, "fillStyle", _t4932)
		J.mc(env["__p"]["ctx"], "beginPath", [])
		J.mc(env["__p"]["ctx"], "arc", [v_mx_4466, v_my_4467, 5.5, 0.0, 7.0])
		J.mc(env["__p"]["ctx"], "fill", [])
		v_mg_4468 = J.mc(env["__p"]["ctx"], "createLinearGradient", [v_mx_4466, 0.0, J.add(v_mx_4466, J.mul(J.gp(v_s_4459, "dir"), 220.0)), 0.0])
		J.mc(v_mg_4468, "addColorStop", [0.0, "rgba(220,245,255,0.25)"])
		J.mc(v_mg_4468, "addColorStop", [1.0, "rgba(220,245,255,0)"])
		var _t4933 = env["__p"]["ctx"]
		J.sp(_t4933, "fillStyle", v_mg_4468)
		J.mc(env["__p"]["ctx"], "beginPath", [])
		J.mc(env["__p"]["ctx"], "moveTo", [v_mx_4466, v_my_4467])
		J.mc(env["__p"]["ctx"], "lineTo", [J.add(v_mx_4466, J.mul(J.gp(v_s_4459, "dir"), 220.0)), J.sub(v_my_4467, 26.0)])
		J.mc(env["__p"]["ctx"], "lineTo", [J.add(v_mx_4466, J.mul(J.gp(v_s_4459, "dir"), 220.0)), J.add(v_my_4467, 26.0)])
		J.mc(env["__p"]["ctx"], "closePath", [])
		J.mc(env["__p"]["ctx"], "fill", [])
	if J.seq(J.gp(v_s_4459, "kind"), "compass"):
		var _t4934 = env["__p"]["ctx"]
		J.sp(_t4934, "fillStyle", "#c8a050")
		J.mc(env["__p"]["ctx"], "beginPath", [])
		J.mc(env["__p"]["ctx"], "arc", [J.add(J.gp(v_s_4459, "x"), J.mul(J.gp(v_s_4459, "dir"), 12.0)), J.sub(J.gp(v_s_4459, "y"), 30.0), 6.0, 0.0, 7.0])
		J.mc(env["__p"]["ctx"], "fill", [])
		var _t4935 = env["__p"]["ctx"]
		J.sp(_t4935, "strokeStyle", "#600")
		var _t4936 = env["__p"]["ctx"]
		J.sp(_t4936, "lineWidth", 1.5)
		v_na_4469 = J.mul(J.gp(env["__p"]["G"], "t"), 7.0)
		J.mc(env["__p"]["ctx"], "beginPath", [])
		J.mc(env["__p"]["ctx"], "moveTo", [J.add(J.gp(v_s_4459, "x"), J.mul(J.gp(v_s_4459, "dir"), 12.0)), J.sub(J.gp(v_s_4459, "y"), 30.0)])
		J.mc(env["__p"]["ctx"], "lineTo", [J.add(J.add(J.gp(v_s_4459, "x"), J.mul(J.gp(v_s_4459, "dir"), 12.0)), (cos(J.num(v_na_4469)) * 5.0)), (J.sub(J.gp(v_s_4459, "y"), 30.0) + (sin(J.num(v_na_4469)) * 5.0))])
		J.mc(env["__p"]["ctx"], "stroke", [])
		v_q_4470 = 0.0
		while true:
			if not J.cmp(v_q_4470, J.gp(v_s_4459, "courage"), "<"): break
			var _t4937 = env["__p"]["ctx"]
			J.sp(_t4937, "fillStyle", "#ffd54a")
			J.mc(env["__p"]["ctx"], "fillRect", [(J.sub(J.gp(v_s_4459, "x"), 12.0) + J.mul(v_q_4470, 5.0)), (J.sub(J.gp(v_s_4459, "y"), v_HHt_4461) - 10.0), 4.0, 4.0])
			v_q_4470 = J.num(v_q_4470) + 1.0
	v_lab_4471 = J.gp(v_H_4460, "n")
	var _t4938 = env["__p"]["ctx"]
	var _t4939 = J.add("bold 11px ", env["__p"]["FONT"])
	J.sp(_t4938, "font", _t4939)
	var _t4940 = env["__p"]["ctx"]
	J.sp(_t4940, "textAlign", "center")
	var _t4941 = env["__p"]["ctx"]
	J.sp(_t4941, "lineWidth", 3.0)
	var _t4942 = env["__p"]["ctx"]
	J.sp(_t4942, "strokeStyle", "#000")
	J.mc(env["__p"]["ctx"], "strokeText", [v_lab_4471, J.gp(v_s_4459, "x"), (J.sub(J.gp(v_s_4459, "y"), v_HHt_4461) - 14.0)])
	var _t4943 = env["__p"]["ctx"]
	var _t4944 = ("#e8e4dc" if J.seq(J.gp(v_s_4459, "kind"), "guard") else "#ffe9a0")
	J.sp(_t4943, "fillStyle", _t4944)
	J.mc(env["__p"]["ctx"], "fillText", [v_lab_4471, J.gp(v_s_4459, "x"), (J.sub(J.gp(v_s_4459, "y"), v_HHt_4461) - 14.0)])
	if J.cmp(J.gp(v_s_4459, "alertT"), 0.0, ">"):
		var _t4945 = env["__p"]["ctx"]
		J.sp(_t4945, "fillStyle", "#ffe25a")
		var _t4946 = env["__p"]["ctx"]
		J.sp(_t4946, "strokeStyle", "#000")
		var _t4947 = env["__p"]["ctx"]
		J.sp(_t4947, "lineWidth", 3.0)
		var _t4948 = env["__p"]["ctx"]
		var _t4949 = J.add("bold 26px ", env["__p"]["FONT"])
		J.sp(_t4948, "font", _t4949)
		var _t4950 = env["__p"]["ctx"]
		J.sp(_t4950, "textAlign", "center")
		v_bb_4472 = (sin(J.num(J.mul(J.gp(env["__p"]["G"], "t"), 20.0))) * 2.0)
		J.mc(env["__p"]["ctx"], "strokeText", ["！", J.gp(v_s_4459, "x"), J.add((J.sub(J.gp(v_s_4459, "y"), v_HHt_4461) - 24.0), v_bb_4472)])
		J.mc(env["__p"]["ctx"], "fillText", ["！", J.gp(v_s_4459, "x"), J.add((J.sub(J.gp(v_s_4459, "y"), v_HHt_4461) - 24.0), v_bb_4472)])
	if J.t(J.gp(v_s_4459, "say")):
		var _t4951 = env["__p"]["bubble"]
		J.cl(_t4951, null, [J.gp(v_s_4459, "x"), (J.sub(J.gp(v_s_4459, "y"), v_HHt_4461) - 30.0), J.gp(v_s_4459, "say")])

func _f740(this_, a: Array, env):
	var v_k_4494 = null
	v_k_4494 = J.arg(a, 0)
	if (not J.t(J.gp(env["cnt"], v_k_4494))):
		var _t4991 = env["cnt"]
		J.sp(_t4991, v_k_4494, 0.0)
		J.mc(env["ord"], "push", [v_k_4494])
	var _t4992 = env["cnt"]
	J.sp(_t4992, v_k_4494, J.num(J.gp(_t4992, v_k_4494)) + 1.0)

func _f741(this_, a: Array, env):
	var v_k_4497 = null
	v_k_4497 = J.arg(a, 0)
	return J.add(J.gp(J.gp(env["__p"]["__p"]["ITEM"], v_k_4497), "n"), (J.add("×", J.gp(env["cnt"], v_k_4497)) if J.cmp(J.gp(env["cnt"], v_k_4497), 1.0, ">") else ""))

func _f739(this_, a: Array, env):
	var v_u_4479 = null; var v_top_4480 = null; var v_w_4481 = null; var v_hgt_4482 = null; var v_cx_4483 = null; var v_cy_4484 = null; var v_tx_4485 = null; var v_dx_4486 = null; var v_a_4487 = null; var v_ix_4488 = null; var v_tt_4491 = null
	var _s1808 = {"__p": env, "cnt": null, "ord": null}
	v_u_4479 = J.arg(a, 0)
	var _t4953 = _s1808["__p"]["__p"]["fy"]
	v_top_4480 = J.add(J.cl(_t4953, null, [J.add(J.gp(v_u_4479, "f"), 1.0)]), 16.0)
	v_w_4481 = J.sub(J.gp(J.gp(v_u_4479, "rx"), 1.0), J.gp(J.gp(v_u_4479, "rx"), 0.0))
	v_hgt_4482 = (J.sub(J.gp(v_u_4479, "y"), v_top_4480) - 4.0)
	if (not J.t(J.gp(v_u_4479, "seen"))):
		var _t4954 = _s1808["__p"]["__p"]["ctx"]
		var _t4955 = (J.add("rgba(2,2,4,", (0.82 if J.t(J.gp(v_u_4479, "open")) else 0.9)) + ")")
		J.sp(_t4954, "fillStyle", _t4955)
		J.mc(_s1808["__p"]["__p"]["ctx"], "fillRect", [J.gp(J.gp(v_u_4479, "rx"), 0.0), v_top_4480, v_w_4481, v_hgt_4482])
		if J.cmp(J.gp(v_u_4479, "unlockFx"), 0.0, ">"):
			var _t4956 = _s1808["__p"]["__p"]["ctx"]
			var _t4957 = (J.add("rgba(159,214,191,", J.gp(v_u_4479, "unlockFx")) + ")")
			J.sp(_t4956, "strokeStyle", _t4957)
			var _t4958 = _s1808["__p"]["__p"]["ctx"]
			J.sp(_t4958, "lineWidth", 3.0)
			J.mc(_s1808["__p"]["__p"]["ctx"], "strokeRect", [J.add(J.gp(J.gp(v_u_4479, "rx"), 0.0), 2.0), J.add(v_top_4480, 2.0), J.sub(v_w_4481, 4.0), J.sub(v_hgt_4482, 4.0)])
	var _t4959 = (not J.t(J.gp(v_u_4479, "open")))
	if ((not J.seq(J.gp(v_u_4479, "ot"), "deity")) if _t4959 else _t4959):
		v_cx_4483 = J.div(J.add(J.gp(J.gp(v_u_4479, "rx"), 0.0), J.gp(J.gp(v_u_4479, "rx"), 1.0)), 2.0)
		v_cy_4484 = J.add(v_top_4480, J.mul(v_hgt_4482, 0.5))
		var _t4960 = _s1808["__p"]["__p"]["ctx"]
		J.sp(_t4960, "fillStyle", "rgba(0,0,0,0.6)")
		J.mc(_s1808["__p"]["__p"]["ctx"], "beginPath", [])
		J.mc(_s1808["__p"]["__p"]["ctx"], "arc", [v_cx_4483, v_cy_4484, 20.0, 0.0, 7.0])
		J.mc(_s1808["__p"]["__p"]["ctx"], "fill", [])
		var _t4961 = _s1808["__p"]["__p"]["ctx"]
		J.sp(_t4961, "strokeStyle", "#c8a050")
		var _t4962 = _s1808["__p"]["__p"]["ctx"]
		J.sp(_t4962, "lineWidth", 2.5)
		J.mc(_s1808["__p"]["__p"]["ctx"], "beginPath", [])
		J.mc(_s1808["__p"]["__p"]["ctx"], "arc", [v_cx_4483, J.sub(v_cy_4484, 5.0), 6.0, PI, 0.0])
		J.mc(_s1808["__p"]["__p"]["ctx"], "stroke", [])
		var _t4963 = _s1808["__p"]["__p"]["ctx"]
		J.sp(_t4963, "fillStyle", "#c8a050")
		J.mc(_s1808["__p"]["__p"]["ctx"], "fillRect", [J.sub(v_cx_4483, 8.0), J.sub(v_cy_4484, 4.0), 16.0, 12.0])
		v_tx_4485 = (J.add((J.add("破鎮宅 ", J.gp(v_u_4479, "paid")) + "/"), J.gp(v_u_4479, "cost")) if J.seq(J.gp(v_u_4479, "ot"), 2.0) else ("要鎖匙" if J.seq(J.gp(v_u_4479, "ot"), 11.0) else "隔籬未亂"))
		var _t4964 = _s1808["__p"]["__p"]["ctx"]
		var _t4965 = J.add("bold 11px ", _s1808["__p"]["__p"]["FONT"])
		J.sp(_t4964, "font", _t4965)
		var _t4966 = _s1808["__p"]["__p"]["ctx"]
		J.sp(_t4966, "textAlign", "center")
		var _t4967 = _s1808["__p"]["__p"]["ctx"]
		J.sp(_t4967, "lineWidth", 3.0)
		var _t4968 = _s1808["__p"]["__p"]["ctx"]
		J.sp(_t4968, "strokeStyle", "#000")
		J.mc(_s1808["__p"]["__p"]["ctx"], "strokeText", [v_tx_4485, v_cx_4483, J.add(v_cy_4484, 30.0)])
		var _t4969 = _s1808["__p"]["__p"]["ctx"]
		J.sp(_t4969, "fillStyle", "#ffe9a0")
		J.mc(_s1808["__p"]["__p"]["ctx"], "fillText", [v_tx_4485, v_cx_4483, J.add(v_cy_4484, 30.0)])
		var _t4970 = J.seq(J.gp(v_u_4479, "ot"), 2.0)
		if (J.cmp(J.gp(v_u_4479, "paid"), 0.0, ">") if _t4970 else _t4970):
			var _t4971 = _s1808["__p"]["__p"]["ctx"]
			J.sp(_t4971, "strokeStyle", "#9fd6bf")
			var _t4972 = _s1808["__p"]["__p"]["ctx"]
			J.sp(_t4972, "lineWidth", 4.0)
			J.mc(_s1808["__p"]["__p"]["ctx"], "beginPath", [])
			J.mc(_s1808["__p"]["__p"]["ctx"], "arc", [v_cx_4483, v_cy_4484, 24.0, J.div((-PI), 2.0), (J.div((-PI), 2.0) + J.div(J.mul((PI * 2.0), J.gp(v_u_4479, "paid")), J.gp(v_u_4479, "cost")))])
			J.mc(_s1808["__p"]["__p"]["ctx"], "stroke", [])
	if J.t(J.gp(v_u_4479, "door")):
		v_dx_4486 = J.gp(v_u_4479, "x")
		v_a_4487 = (0.25 if J.cmp(J.gp(v_u_4479, "doorOpen"), 0.0, ">") else 1.0)
		var _t4973 = _s1808["__p"]["__p"]["ctx"]
		J.sp(_t4973, "globalAlpha", v_a_4487)
		var _t4974 = _s1808["__p"]["__p"]["ctx"]
		J.sp(_t4974, "fillStyle", "#4a3020")
		J.mc(_s1808["__p"]["__p"]["ctx"], "fillRect", [J.sub(v_dx_4486, 12.0), J.sub(J.gp(v_u_4479, "y"), 62.0), 24.0, 58.0])
		var _t4975 = _s1808["__p"]["__p"]["ctx"]
		J.sp(_t4975, "strokeStyle", "#c8a050")
		var _t4976 = _s1808["__p"]["__p"]["ctx"]
		J.sp(_t4976, "lineWidth", 2.0)
		J.mc(_s1808["__p"]["__p"]["ctx"], "strokeRect", [J.sub(v_dx_4486, 12.0), J.sub(J.gp(v_u_4479, "y"), 62.0), 24.0, 58.0])
		var _t4977 = _s1808["__p"]["__p"]["ctx"]
		J.sp(_t4977, "fillStyle", "#c8a050")
		J.mc(_s1808["__p"]["__p"]["ctx"], "fillRect", [J.add(v_dx_4486, 6.0), J.sub(J.gp(v_u_4479, "y"), 34.0), 3.0, 3.0])
		var _t4978 = _s1808["__p"]["__p"]["ctx"]
		J.sp(_t4978, "globalAlpha", 1.0)
		if J.cmp(J.gp(v_u_4479, "doorOpen"), 0.0, ">"):
			var _t4979 = _s1808["__p"]["__p"]["ctx"]
			J.sp(_t4979, "fillStyle", "#9fd6bf")
			var _t4980 = _s1808["__p"]["__p"]["ctx"]
			var _t4981 = J.add("bold 11px ", _s1808["__p"]["__p"]["FONT"])
			J.sp(_t4980, "font", _t4981)
			var _t4982 = _s1808["__p"]["__p"]["ctx"]
			J.sp(_t4982, "textAlign", "center")
			J.mc(_s1808["__p"]["__p"]["ctx"], "fillText", ["門開咗！", v_dx_4486, J.sub(J.gp(v_u_4479, "y"), 68.0)])
	var _t4983 = J.gp(v_u_4479, "seen")
	var _t4984 = (J.len(J.gp(v_u_4479, "items")) if J.t(_t4983) else _t4983)
	if J.t((J.gp(v_u_4479, "open") if J.t(_t4984) else _t4984)):
		v_ix_4488 = J.div(J.add(J.gp(J.gp(v_u_4479, "rx"), 0.0), J.gp(J.gp(v_u_4479, "rx"), 1.0)), 2.0)
		var _t4985 = _s1808["__p"]["__p"]["ctx"]
		var _t4986 = J.add("10px ", _s1808["__p"]["__p"]["FONT"])
		J.sp(_t4985, "font", _t4986)
		var _t4987 = _s1808["__p"]["__p"]["ctx"]
		J.sp(_t4987, "textAlign", "center")
		var _t4988 = _s1808["__p"]["__p"]["ctx"]
		J.sp(_t4988, "lineWidth", 3.0)
		var _t4989 = _s1808["__p"]["__p"]["ctx"]
		J.sp(_t4989, "strokeStyle", "#000")
		_s1808["cnt"] = {}
		_s1808["ord"] = []
		var _t4990 = J.gp(v_u_4479, "items")
		J.mc(_t4990, "forEach", [Callable(self, "_f740").bind(_s1808)])
		var _t4993 = J.mc(_s1808["ord"], "map", [Callable(self, "_f741").bind(_s1808)])
		v_tt_4491 = J.mc(_t4993, "join", [" "])
		J.mc(_s1808["__p"]["__p"]["ctx"], "strokeText", [v_tt_4491, v_ix_4488, J.add(v_top_4480, 28.0)])
		var _t4994 = _s1808["__p"]["__p"]["ctx"]
		J.sp(_t4994, "fillStyle", "#e8d8b0")
		J.mc(_s1808["__p"]["__p"]["ctx"], "fillText", [v_tt_4491, v_ix_4488, J.add(v_top_4480, 28.0)])

func _f742(this_, a: Array, env):
	var v_o_4500 = null; var v_i_4501 = null; var v_n_4502 = null; var v_inside_4503 = null; var v_hang_4504 = null; var v_a_4505 = null; var v_T_4506 = null; var v_k_4507 = null; var v_ox_4508 = null; var v_oy_4509 = null; var v_ro_4510 = null; var v_sx_4511 = null; var v_sy_4512 = null; var v_key_4513 = null; var v_by_4514 = null; var v_st_4515 = null; var v_c_4516 = null; var v_h_4517 = null; var v_q_4518 = null; var v_hs_4519 = null; var v_hx_4520 = null; var v_bp_4521 = null; var v_fq_4522 = null; var v_na_4523 = null; var v_nb_4524 = null; var v_na2_4525 = null; var v_nb2_4526 = null; var v_ceil2_4527 = null; var v_flo2_4528 = null; var v_dq_4529 = null; var v_u2_4530 = null; var v_u3_4531 = null; var v_w2_4532 = null; var v_down_4533 = null; var v_cy0_4534 = null; var v_fa_4535 = null
	v_o_4500 = J.arg(a, 0)
	v_i_4501 = J.arg(a, 1)
	var _t5000 = J.gp(v_o_4500, "home")
	if J.t((_t5000 if J.t(_t5000) else J.gp(v_o_4500, "out"))):
		return null
	v_n_4502 = J.gp(J.gp(env["__p"]["G"], "nodes"), J.gp(v_o_4500, "node"))
	var _t5001 = J.seq(J.gp(v_n_4502, "kind"), "in")
	v_inside_4503 = ((not J.t(J.gp(v_o_4500, "to"))) if _t5001 else _t5001)
	var _t5002 = J.seq(J.gp(J.gp(v_o_4500, "d"), "key"), "tianhua")
	v_hang_4504 = (v_inside_4503 if _t5002 else _t5002)
	v_a_4505 = (0.35 if J.cmp(J.gp(v_o_4500, "inv"), 0.0, ">") else (1.0 if J.seq(v_i_4501, J.gp(env["__p"]["G"], "active")) else 0.75))
	var _t5003 = J.cmp(J.gp(v_o_4500, "stun"), 0.0, ">")
	var _t5004 = ((not J.cmp(J.gp(v_o_4500, "countT"), 0.0, ">")) if _t5003 else _t5003)
	if ((not J.cmp(J.gp(v_o_4500, "dropT"), 0.0, ">")) if _t5004 else _t5004):
		var _t5005 = J.mul(v_a_4505, (0.6 + (0.4 * sin(J.num(J.mul(J.gp(env["__p"]["G"], "t"), 30.0))))))
		v_a_4505 = _t5005
	if J.seq(v_i_4501, J.gp(env["__p"]["G"], "active")):
		var _t5006 = env["__p"]["ctx"]
		J.sp(_t5006, "fillStyle", "rgba(110,255,190,0.40)")
		J.mc(env["__p"]["ctx"], "beginPath", [])
		J.mc(env["__p"]["ctx"], "ellipse", [J.gp(v_o_4500, "x"), J.sub(J.gp(v_o_4500, "y"), 2.0), 24.0, 6.0, 0.0, 0.0, 7.0])
		J.mc(env["__p"]["ctx"], "fill", [])
	v_T_4506 = J.add(J.gp(env["__p"]["G"], "t"), J.gp(v_o_4500, "ph"))
	v_k_4507 = J.gp(J.gp(v_o_4500, "d"), "key")
	v_ox_4508 = 0.0
	v_oy_4509 = 0.0
	v_ro_4510 = 0.0
	v_sx_4511 = 1.0
	v_sy_4512 = 1.0
	v_key_4513 = ("tianhua_hang" if J.t(v_hang_4504) else J.gp(J.gp(v_o_4500, "d"), "sprite"))
	v_by_4514 = (J.sub(J.gp(v_o_4500, "y"), 50.0) if J.t(v_hang_4504) else J.gp(v_o_4500, "y"))
	if J.cmp(J.gp(v_o_4500, "countT"), 0.0, ">"):
		v_sy_4512 = 0.8
		v_oy_4509 = 3.0
		var _t5007 = (sin(J.num(J.mul(J.gp(env["__p"]["G"], "t"), 9.0))) * 0.1)
		v_ro_4510 = _t5007
	else:
		if J.t(J.gp(v_o_4500, "sc")):
			v_st_4515 = J.gp(J.gp(v_o_4500, "sc"), "t")
			if J.cmp(v_st_4515, env["__p"]["OMEN"], "<"):
				v_c_4516 = J.div(v_st_4515, env["__p"]["OMEN"])
				var _t5008 = ((1.0 - J.mul(0.08, v_c_4516)) + (0.03 * sin(J.num(J.mul(J.gp(env["__p"]["G"], "t"), 20.0)))))
				v_sy_4512 = _t5008
				v_sx_4511 = v_sy_4512
				var _t5009 = env["__p"]["ctx"]
				var _t5010 = J.add(J.add(J.gp({"eking": "rgba(210,90,40,", "toyol": "rgba(120,220,140,", "tianhua": "rgba(110,190,255,"}, v_k_4507), J.mul(0.25, v_c_4516)), ")")
				J.sp(_t5009, "fillStyle", _t5010)
				J.mc(env["__p"]["ctx"], "beginPath", [])
				J.mc(env["__p"]["ctx"], "arc", [J.gp(v_o_4500, "x"), J.sub(v_by_4514, J.mul(J.gp(J.gp(v_o_4500, "d"), "h"), 0.5)), (J.mul(J.gp(J.gp(v_o_4500, "d"), "h"), 0.6) * (0.6 + J.mul(0.4, v_c_4516))), 0.0, 7.0])
				J.mc(env["__p"]["ctx"], "fill", [])
			else:
				if J.cmp(v_st_4515, J.add(env["__p"]["OMEN"], env["__p"]["STRIKE"]), "<"):
					if J.seq(v_k_4507, "eking"):
						var _t5011 = (1.18 + (0.06 * sin(J.num(J.mul(J.gp(env["__p"]["G"], "t"), 30.0)))))
						v_sx_4511 = _t5011
						v_sy_4512 = 0.92
						var _t5012 = J.mul(J.gp(v_o_4500, "dir"), 0.1)
						v_ro_4510 = _t5012
					else:
						var _t5013 = J.mul(v_a_4505, 0.25)
						v_a_4505 = _t5013
				else:
					var _t5014 = J.mul(v_a_4505, (1.0 if J.seq(v_k_4507, "eking") else J.min_([1.0, (0.25 + J.div(J.sub(J.sub(v_st_4515, env["__p"]["OMEN"]), env["__p"]["STRIKE"]), env["__p"]["AFTER"]))])))
					v_a_4505 = _t5014
		else:
			if J.cmp(J.gp(v_o_4500, "hitT"), 0.0, ">"):
				v_h_4517 = J.div(J.gp(v_o_4500, "hitT"), 0.8)
				var _t5015 = J.gp(v_o_4500, "hitDir")
				var _t5017 = (((-J.num((_t5015 if J.t(_t5015) else 1.0))) * J.sub(1.0, v_h_4517)) * 0.0)
				var _t5016 = J.gp(v_o_4500, "hitDir")
				var _t5018 = (_t5017 + (J.mul((_t5016 if J.t(_t5016) else 1.0), v_h_4517) * 14.0))
				v_ox_4508 = _t5018
				var _t5019 = J.gp(v_o_4500, "hitDir")
				var _t5020 = J.mul(J.mul((_t5019 if J.t(_t5019) else 1.0), 0.25), v_h_4517)
				v_ro_4510 = _t5020
				var _t5021 = J.mul(v_a_4505, (0.5 + (0.5 * absf(J.num(sin(J.num(J.mul(J.gp(env["__p"]["G"], "t"), 35.0))))))))
				v_a_4505 = _t5021
			else:
				if J.cmp(J.gp(v_o_4500, "actT"), 0.0, ">"):
					v_q_4518 = (1.0 - J.div(J.gp(v_o_4500, "actT"), 0.9))
					if J.cmp(v_q_4518, 0.3, "<"):
						v_c_4516 = J.div(v_q_4518, 0.3)
						var _t5022 = (1.0 - J.mul(0.12, v_c_4516))
						v_sy_4512 = _t5022
						v_sx_4511 = v_sy_4512
						var _t5023 = J.mul(2.0, v_c_4516)
						v_oy_4509 = _t5023
						var _t5024 = J.mul(((-J.num(J.gp(v_o_4500, "dir"))) * 0.12), v_c_4516)
						v_ro_4510 = _t5024
						var _t5025 = env["__p"]["ctx"]
						var _t5026 = (J.add("rgba(200,30,30,", J.mul(0.35, v_c_4516)) + ")")
						J.sp(_t5025, "fillStyle", _t5026)
						J.mc(env["__p"]["ctx"], "beginPath", [])
						J.mc(env["__p"]["ctx"], "arc", [J.gp(v_o_4500, "x"), J.sub(v_by_4514, J.mul(J.gp(J.gp(v_o_4500, "d"), "h"), 0.5)), J.mul(J.gp(J.gp(v_o_4500, "d"), "h"), 0.7), 0.0, 7.0])
						J.mc(env["__p"]["ctx"], "fill", [])
					else:
						if J.cmp(v_q_4518, 0.6, "<"):
							v_c_4516 = J.div(J.sub(v_q_4518, 0.3), 0.3)
							var _t5027 = (0.88 + J.mul(0.55, v_c_4516))
							v_sy_4512 = _t5027
							v_sx_4511 = v_sy_4512
							var _t5028 = J.mul(J.mul(J.gp(v_o_4500, "dir"), 26.0), v_c_4516)
							v_ox_4508 = _t5028
							var _t5029 = J.mul(J.mul(J.gp(v_o_4500, "dir"), 0.15), v_c_4516)
							v_ro_4510 = _t5029
							if J.seq(v_k_4507, "tianhua"):
								var _t5030 = J.mul((-6.0), v_c_4516)
								v_oy_4509 = _t5030
						else:
							v_c_4516 = J.div(J.sub(v_q_4518, 0.6), 0.4)
							var _t5031 = (1.43 - J.mul(0.43, v_c_4516))
							v_sy_4512 = _t5031
							v_sx_4511 = v_sy_4512
							var _t5032 = (J.mul(J.gp(v_o_4500, "dir"), 26.0) * J.sub(1.0, v_c_4516))
							v_ox_4508 = _t5032
					var _t5033 = J.cmp(v_q_4518, 0.3, ">")
					var _t5034 = (J.cmp(v_q_4518, 0.75, "<") if _t5033 else _t5033)
					if (J.seq(v_k_4507, "tianhua") if _t5034 else _t5034):
						var _t5035 = env["__p"]["ctx"]
						J.sp(_t5035, "strokeStyle", "rgba(20,20,24,0.85)")
						var _t5036 = env["__p"]["ctx"]
						J.sp(_t5036, "lineWidth", 2.0)
						v_hs_4519 = 0.0
						while true:
							if not J.cmp(v_hs_4519, 9.0, "<"): break
							v_hx_4520 = J.add(J.gp(v_o_4500, "x"), J.mul(J.gp(v_o_4500, "dir"), (10.0 + J.mul(v_hs_4519, 5.0))))
							J.mc(env["__p"]["ctx"], "beginPath", [])
							J.mc(env["__p"]["ctx"], "moveTo", [v_hx_4520, J.sub(v_by_4514, J.gp(J.gp(v_o_4500, "d"), "h"))])
							J.mc(env["__p"]["ctx"], "quadraticCurveTo", [J.add(v_hx_4520, (sin(J.num(J.add(J.mul(J.gp(env["__p"]["G"], "t"), 9.0), v_hs_4519))) * 6.0)), J.sub(v_by_4514, J.mul(J.gp(J.gp(v_o_4500, "d"), "h"), 0.4)), J.add(v_hx_4520, (sin(J.num(J.add(J.mul(J.gp(env["__p"]["G"], "t"), 7.0), v_hs_4519))) * 4.0)), J.add(v_by_4514, 4.0)])
							J.mc(env["__p"]["ctx"], "stroke", [])
							v_hs_4519 = J.num(v_hs_4519) + 1.0
				else:
					if J.cmp(J.gp(v_o_4500, "taskP"), 0.0, ">"):
						if J.seq(v_k_4507, "eking"):
							var _t5037 = (1.0 + (0.09 * sin(J.num(J.mul(J.gp(env["__p"]["G"], "t"), 18.0)))))
							v_sy_4512 = _t5037
							var _t5038 = (1.0 - (0.05 * sin(J.num(J.mul(J.gp(env["__p"]["G"], "t"), 18.0)))))
							v_sx_4511 = _t5038
						else:
							if J.seq(v_k_4507, "toyol"):
								var _t5039 = (sin(J.num(J.mul(J.gp(env["__p"]["G"], "t"), 20.0))) * 0.14)
								v_ro_4510 = _t5039
								var _t5040 = ((-absf(J.num(sin(J.num(J.mul(J.gp(env["__p"]["G"], "t"), 10.0)))))) * 3.0)
								v_oy_4509 = _t5040
							else:
								var _t5041 = (sin(J.num(J.mul(J.gp(env["__p"]["G"], "t"), 5.0))) * 0.08)
								v_ro_4510 = _t5041
						if J.seq(v_k_4507, "tianhua"):
							var _t5042 = env["__p"]["ctx"]
							J.sp(_t5042, "strokeStyle", "rgba(30,30,34,0.8)")
							var _t5043 = env["__p"]["ctx"]
							J.sp(_t5043, "lineWidth", 1.5)
							v_hs_4519 = 0.0
							while true:
								if not J.cmp(v_hs_4519, 6.0, "<"): break
								v_hx_4520 = (J.sub(J.gp(v_o_4500, "x"), 8.0) + J.mul(v_hs_4519, 3.0))
								J.mc(env["__p"]["ctx"], "beginPath", [])
								J.mc(env["__p"]["ctx"], "moveTo", [v_hx_4520, J.sub(v_by_4514, J.mul(J.gp(J.gp(v_o_4500, "d"), "h"), 0.2))])
								J.mc(env["__p"]["ctx"], "lineTo", [J.add(v_hx_4520, (sin(J.num(J.add(J.mul(J.gp(env["__p"]["G"], "t"), 4.0), v_hs_4519))) * 3.0)), J.add(J.add(v_by_4514, 16.0), (J.mod(v_hs_4519, 2.0) * 6.0))])
								J.mc(env["__p"]["ctx"], "stroke", [])
								v_hs_4519 = J.num(v_hs_4519) + 1.0
					else:
						if J.cmp(J.gp(v_o_4500, "mv"), 0.0, ">"):
							if J.seq(v_k_4507, "eking"):
								var _t5044 = (sin(J.num(J.mul(v_T_4506, 8.0))) * 0.08)
								v_ro_4510 = _t5044
								var _t5045 = ((-absf(J.num(sin(J.num(J.mul(v_T_4506, 8.0)))))) * 2.0)
								v_oy_4509 = _t5045
								v_bp_4521 = sin(J.num(J.mul(v_T_4506, 9.0)))
								var _t5046 = (1.0 + J.mul(0.08, v_bp_4521))
								v_sx_4511 = _t5046
								var _t5047 = (1.0 - J.mul(0.035, v_bp_4521))
								v_sy_4512 = _t5047
							else:
								if J.seq(v_k_4507, "toyol"):
									var _t5048 = ((-absf(J.num(sin(J.num(J.mul(v_T_4506, 15.0)))))) * 7.0)
									v_oy_4509 = _t5048
									var _t5049 = (sin(J.num(J.mul(v_T_4506, 15.0))) * 0.13)
									v_ro_4510 = _t5049
									if J.cmp(J.gp(v_o_4500, "flipT"), 0.0, ">"):
										v_fq_4522 = (1.0 - J.div(J.gp(v_o_4500, "flipT"), 0.55))
										var _t5050 = J.mul((J.mul(J.gp(v_o_4500, "dir"), PI) * 2.0), v_fq_4522)
										v_ro_4510 = _t5050
										var _t5051 = (((-sin(J.num(J.mul(v_fq_4522, PI)))) * 22.0) - (J.mul(J.gp(J.gp(v_o_4500, "d"), "h"), 0.3) * sin(J.num(J.mul(v_fq_4522, PI)))))
										v_oy_4509 = _t5051
								else:
									v_na_4523 = J.gp(J.gp(env["__p"]["G"], "nodes"), J.gp(v_o_4500, "node"))
									v_nb_4524 = (J.gp(J.gp(env["__p"]["G"], "nodes"), J.gp(v_o_4500, "to")) if J.t(J.gp(v_o_4500, "to")) else v_na_4523)
									var _t5052 = J.seq(J.gp(v_na_4523, "f"), J.gp(v_nb_4524, "f"))
									var _t5053 = ((not J.seq(J.gp(v_na_4523, "kind"), "in")) if _t5052 else _t5052)
									if ((not J.seq(J.gp(v_nb_4524, "kind"), "in")) if _t5053 else _t5053):
										var _t5054 = env["__p"]["fy"]
										var _t5055 = J.add(J.cl(_t5054, null, [J.add(J.gp(v_na_4523, "f"), 1.0)]), 14.0)
										v_by_4514 = _t5055
										v_sy_4512 = (-1.0)
										var _t5056 = (sin(J.num(J.mul(v_T_4506, 10.0))) * 0.06)
										v_ro_4510 = _t5056
										var _t5057 = (sin(J.num(J.mul(v_T_4506, 10.0))) * 2.0)
										v_ox_4508 = _t5057
									else:
										var _t5058 = J.mul(J.gp(v_o_4500, "dir"), 0.12)
										v_ro_4510 = _t5058
										var _t5059 = ((-4.0) + (sin(J.num(J.mul(v_T_4506, 6.0))) * 3.0))
										v_oy_4509 = _t5059
						else:
							var _t5060 = ((sin(J.num(J.mul(v_T_4506, 2.5))) * 3.0) - (0.0 if J.seq(v_k_4507, "eking") else 3.0))
							v_oy_4509 = _t5060
							var _t5061 = (1.0 + (0.025 * sin(J.num(J.mul(v_T_4506, 2.5)))))
							v_sy_4512 = _t5061
	if J.cmp(J.gp(v_o_4500, "bounceT"), 0.0, ">"):
		var _t5062 = J.add(v_ox_4508, (((-J.num(J.gp(v_o_4500, "dir"))) * sin(J.num((J.div(J.gp(v_o_4500, "bounceT"), 0.45) * PI)))) * 12.0))
		v_ox_4508 = _t5062
	if J.seq(v_k_4507, "tianhua"):
		v_na2_4525 = J.gp(J.gp(env["__p"]["G"], "nodes"), J.gp(v_o_4500, "node"))
		v_nb2_4526 = (J.gp(J.gp(env["__p"]["G"], "nodes"), J.gp(v_o_4500, "to")) if J.t(J.gp(v_o_4500, "to")) else v_na2_4525)
		var _t5063 = env["__p"]["fy"]
		v_ceil2_4527 = J.add(J.cl(_t5063, null, [J.min_([env["__p"]["FL"], J.add(J.gp(v_na2_4525, "f"), 1.0)])]), 14.0)
		v_flo2_4528 = J.gp(v_o_4500, "y")
		if J.cmp(J.gp(v_o_4500, "dropT"), 0.0, ">"):
			v_key_4513 = J.gp(J.gp(v_o_4500, "d"), "sprite")
			v_dq_4529 = J.gp(v_o_4500, "dropT")
			if J.cmp(v_dq_4529, 2.05, ">"):
				v_u2_4530 = J.div(J.sub(2.3, v_dq_4529), 0.25)
				var _t5064 = J.add(v_ceil2_4527, J.mul(J.sub(v_flo2_4528, v_ceil2_4527), v_u2_4530))
				v_by_4514 = _t5064
				v_sy_4512 = 1.0
				v_sx_4511 = 1.0
				var _t5065 = (PI * J.sub(1.0, v_u2_4530))
				v_ro_4510 = _t5065
				v_oy_4509 = 0.0
				v_ox_4508 = 0.0
			else:
				if J.cmp(v_dq_4529, 0.5, "<"):
					v_u3_4531 = (1.0 - J.div(v_dq_4529, 0.5))
					var _t5066 = J.sub(v_flo2_4528, J.mul(J.sub(v_flo2_4528, v_ceil2_4527), v_u3_4531))
					v_by_4514 = _t5066
					v_sy_4512 = 1.0
					v_sx_4511 = 1.0
					v_ro_4510 = 0.0
					var _t5067 = (sin(J.num(J.mul(J.gp(env["__p"]["G"], "t"), 30.0))) * 1.5)
					v_ox_4508 = _t5067
				else:
					v_by_4514 = v_flo2_4528
					v_sy_4512 = 1.0
					v_sx_4511 = 1.0
					var _t5068 = (J.mul(J.gp(v_o_4500, "dir"), 0.24) + (sin(J.num(J.mul(J.gp(env["__p"]["G"], "t"), 3.0))) * 0.03))
					v_ro_4510 = _t5068
					v_ox_4508 = 0.0
					v_oy_4509 = 0.0
					if J.cmp(v_dq_4529, 0.8, ">"):
						var _t5069 = env["__p"]["ctx"]
						J.sp(_t5069, "strokeStyle", "rgba(255,230,160,0.8)")
						var _t5070 = env["__p"]["ctx"]
						J.sp(_t5070, "lineWidth", 2.0)
						v_w2_4532 = 0.0
						while true:
							if not J.cmp(v_w2_4532, 3.0, "<"): break
							J.mc(env["__p"]["ctx"], "beginPath", [])
							J.mc(env["__p"]["ctx"], "arc", [J.sub(J.gp(v_o_4500, "x"), J.mul(J.gp(v_o_4500, "dir"), 10.0)), J.sub(v_flo2_4528, J.mul(J.gp(J.gp(v_o_4500, "d"), "h"), 0.42)), ((6.0 + J.mul(v_w2_4532, 5.0)) + J.mod(J.mul(J.gp(env["__p"]["G"], "t"), 16.0), 5.0)), (PI * 0.6), (PI * 1.4)])
							J.mc(env["__p"]["ctx"], "stroke", [])
							v_w2_4532 = J.num(v_w2_4532) + 1.0
		else:
			if (not J.t(v_hang_4504)):
				if (not J.seq(J.gp(v_na2_4525, "f"), J.gp(v_nb2_4526, "f"))):
					v_down_4533 = J.cmp(J.gp(v_nb2_4526, "f"), J.gp(v_na2_4525, "f"), "<")
					var _t5071 = J.sub(J.gp(v_o_4500, "y"), (0.0 if J.t(v_down_4533) else 6.0))
					v_by_4514 = _t5071
					var _t5072 = (PI if J.t(v_down_4533) else 0.0)
					v_ro_4510 = _t5072
					var _t5073 = (J.mul(J.gp(v_o_4500, "dir"), 14.0) + (sin(J.num(J.mul(J.gp(env["__p"]["G"], "t"), 14.0))) * 2.0))
					v_ox_4508 = _t5073
					if J.t(v_down_4533):
						var _t5074 = J.sub(J.gp(v_o_4500, "y"), J.mul(J.gp(J.gp(v_o_4500, "d"), "h"), 0.9))
						v_by_4514 = _t5074
					var _t5075 = J.mul(v_sx_4511, 0.95)
					v_sx_4511 = _t5075
					var _t5076 = absf(J.num(v_sy_4512))
					v_sy_4512 = _t5076
				else:
					v_by_4514 = v_ceil2_4527
					var _t5077 = (-absf(J.num((v_sy_4512 if J.t(v_sy_4512) else 1.0))))
					v_sy_4512 = _t5077
					var _t5078 = J.mul((v_oy_4509 if J.t(v_oy_4509) else 0.0), 0.4)
					v_oy_4509 = _t5078
	if J.seq(v_k_4507, "eking"):
		var _t5079 = J.gp(v_o_4500, "fat")
		var _t5080 = J.mul(v_sx_4511, J.add(1.0, (_t5079 if J.t(_t5079) else 0.0)))
		v_sx_4511 = _t5080
	var _t5081 = env["__p"]["drawTaskProps"]
	J.cl(_t5081, null, [v_o_4500, v_by_4514])
	if J.cmp(J.gp(v_o_4500, "countT"), 0.0, ">"):
		v_cy0_4534 = (J.sub(J.gp(v_o_4500, "y"), J.gp(J.gp(v_o_4500, "d"), "h")) - 8.0)
		var _t5082 = J.gp(v_o_4500, "cntAcc")
		var _t5083 = J.gp(v_o_4500, "cntAcc")
		v_fa_4535 = J.min_([1.0, J.div((_t5083 if J.t(_t5083) else 0.0), 0.32)])
		if J.cmp(J.gp(v_o_4500, "cntN"), 0.0, ">"):
			var _t5084 = env["__p"]["ctx"]
			var _t5085 = J.sub(1.0, v_fa_4535)
			J.sp(_t5084, "globalAlpha", _t5085)
			var _t5086 = env["__p"]["txt"]
			J.cl(_t5086, null, [J.gp(env["__p"]["COUNT"], J.mod(J.sub(J.gp(v_o_4500, "cntN"), 1.0), 10.0)), J.add(J.gp(v_o_4500, "x"), 10.0), J.sub(v_cy0_4534, J.mul(v_fa_4535, 14.0)), "#b8f0a0", 13.0])
			var _t5087 = env["__p"]["ctx"]
			J.sp(_t5087, "globalAlpha", 1.0)
		var _t5088 = env["__p"]["ctx"]
		J.sp(_t5088, "globalAlpha", v_fa_4535)
		var _t5089 = env["__p"]["txt"]
		var _t5091 = env["__p"]["COUNT"]
		var _t5090 = J.gp(v_o_4500, "cntN")
		J.cl(_t5089, null, [J.add(J.gp(_t5091, J.mod((_t5090 if J.t(_t5090) else 0.0), 10.0)), "……"), J.add(J.gp(v_o_4500, "x"), 10.0), J.sub(J.add(v_cy0_4534, 6.0), J.mul(v_fa_4535, 6.0)), "#d8ffc0", 16.0])
		var _t5092 = env["__p"]["ctx"]
		J.sp(_t5092, "globalAlpha", 1.0)
	var _t5093 = env["__p"]["ctx"]
	J.sp(_t5093, "shadowColor", "rgba(140,255,200,0.85)")
	var _t5094 = env["__p"]["ctx"]
	J.sp(_t5094, "shadowBlur", 7.0)
	var _t5095 = env["__p"]["spr"]
	J.cl(_t5095, null, [v_key_4513, J.gp(v_o_4500, "x"), v_by_4514, J.gp(J.gp(v_o_4500, "d"), "h"), {"flip": J.cmp(J.gp(v_o_4500, "dir"), 0.0, "<"), "alpha": v_a_4505, "ox": v_ox_4508, "oy": v_oy_4509, "rot": v_ro_4510, "sx": v_sx_4511, "sy": v_sy_4512}])
	var _t5096 = env["__p"]["ctx"]
	J.sp(_t5096, "shadowBlur", 0.0)
	var _t5097 = J.seq(v_i_4501, J.gp(env["__p"]["G"], "active"))
	var _t5098 = ((not J.t(J.gp(v_o_4500, "to"))) if _t5097 else _t5097)
	var _t5099 = (J.cmp(J.gp(v_o_4500, "still"), 0.1, ">=") if _t5098 else _t5098)
	if (J.cmp(J.gp(v_o_4500, "mv"), 0.0, "<=") if _t5099 else _t5099):
		var _t5100 = env["__p"]["ctx"]
		J.sp(_t5100, "strokeStyle", "rgba(138,255,200,0.55)")
		J.mc(env["__p"]["ctx"], "setLineDash", [[4.0, 4.0]])
		J.mc(env["__p"]["ctx"], "beginPath", [])
		J.mc(env["__p"]["ctx"], "ellipse", [J.gp(v_o_4500, "x"), J.sub(J.gp(v_o_4500, "y"), 2.0), 30.0, 8.0, 0.0, 0.0, 7.0])
		J.mc(env["__p"]["ctx"], "stroke", [])
		J.mc(env["__p"]["ctx"], "setLineDash", [[]])
	if J.cmp(J.gp(v_o_4500, "taskP"), 0.0, ">"):
		var _t5101 = env["__p"]["ctx"]
		J.sp(_t5101, "strokeStyle", "#8affc8")
		var _t5102 = env["__p"]["ctx"]
		J.sp(_t5102, "lineWidth", 4.0)
		J.mc(env["__p"]["ctx"], "beginPath", [])
		J.mc(env["__p"]["ctx"], "arc", [J.gp(v_o_4500, "x"), (J.sub(J.gp(v_o_4500, "y"), J.gp(J.gp(v_o_4500, "d"), "h")) - 14.0), 10.0, J.div((-PI), 2.0), (J.div((-PI), 2.0) + J.mul((PI * 2.0), J.gp(v_o_4500, "taskP")))])
		J.mc(env["__p"]["ctx"], "stroke", [])

func _f743(this_, a: Array, env):
	var v_p_4538 = null; var v_a_4539 = null
	v_p_4538 = J.arg(a, 0)
	v_a_4539 = J.div(J.gp(v_p_4538, "life"), J.gp(v_p_4538, "max"))
	var _t5104 = env["__p"]["ctx"]
	var _t5105 = J.min_([1.0, J.mul(v_a_4539, 1.4)])
	J.sp(_t5104, "globalAlpha", _t5105)
	if J.seq(J.gp(v_p_4538, "type"), "coin"):
		var _t5106 = env["__p"]["ctx"]
		J.sp(_t5106, "fillStyle", "#ffd54a")
		J.mc(env["__p"]["ctx"], "beginPath", [])
		J.mc(env["__p"]["ctx"], "ellipse", [J.gp(v_p_4538, "x"), J.gp(v_p_4538, "y"), 4.0, (4.0 * absf(J.num(sin(J.num(J.add(J.mul(J.gp(env["__p"]["G"], "t"), 12.0), J.gp(v_p_4538, "x"))))))), 0.0, 0.0, 7.0])
		J.mc(env["__p"]["ctx"], "fill", [])
	else:
		if J.seq(J.gp(v_p_4538, "type"), "crumb"):
			var _t5107 = env["__p"]["ctx"]
			J.sp(_t5107, "fillStyle", "#e8c07a")
			J.mc(env["__p"]["ctx"], "fillRect", [J.gp(v_p_4538, "x"), J.gp(v_p_4538, "y"), 3.0, 3.0])
		else:
			if J.seq(J.gp(v_p_4538, "type"), "sweat"):
				var _t5108 = env["__p"]["ctx"]
				J.sp(_t5108, "fillStyle", "#9fe0ff")
				J.mc(env["__p"]["ctx"], "beginPath", [])
				J.mc(env["__p"]["ctx"], "arc", [J.gp(v_p_4538, "x"), J.gp(v_p_4538, "y"), 2.5, 0.0, 7.0])
				J.mc(env["__p"]["ctx"], "fill", [])
			else:
				if J.seq(J.gp(v_p_4538, "type"), "tear"):
					var _t5109 = env["__p"]["ctx"]
					J.sp(_t5109, "fillStyle", "#bfeaff")
					var _t5110 = env["__p"]["ctx"]
					J.sp(_t5110, "strokeStyle", "#2a4a5a")
					var _t5111 = env["__p"]["ctx"]
					J.sp(_t5111, "lineWidth", 0.8)
					J.mc(env["__p"]["ctx"], "beginPath", [])
					J.mc(env["__p"]["ctx"], "moveTo", [J.gp(v_p_4538, "x"), J.sub(J.gp(v_p_4538, "y"), 4.5)])
					J.mc(env["__p"]["ctx"], "quadraticCurveTo", [J.add(J.gp(v_p_4538, "x"), 3.2), J.gp(v_p_4538, "y"), J.gp(v_p_4538, "x"), J.add(J.gp(v_p_4538, "y"), 2.6)])
					J.mc(env["__p"]["ctx"], "quadraticCurveTo", [J.sub(J.gp(v_p_4538, "x"), 3.2), J.gp(v_p_4538, "y"), J.gp(v_p_4538, "x"), J.sub(J.gp(v_p_4538, "y"), 4.5)])
					J.mc(env["__p"]["ctx"], "fill", [])
					J.mc(env["__p"]["ctx"], "stroke", [])
				else:
					if J.seq(J.gp(v_p_4538, "type"), "hair"):
						var _t5112 = env["__p"]["ctx"]
						J.sp(_t5112, "strokeStyle", "#222")
						var _t5113 = env["__p"]["ctx"]
						J.sp(_t5113, "lineWidth", 1.0)
						J.mc(env["__p"]["ctx"], "beginPath", [])
						J.mc(env["__p"]["ctx"], "moveTo", [J.gp(v_p_4538, "x"), J.gp(v_p_4538, "y")])
						J.mc(env["__p"]["ctx"], "lineTo", [J.add(J.gp(v_p_4538, "x"), 3.0), J.add(J.gp(v_p_4538, "y"), 9.0)])
						J.mc(env["__p"]["ctx"], "stroke", [])
					else:
						if J.seq(J.gp(v_p_4538, "type"), "smoke"):
							var _t5114 = env["__p"]["ctx"]
							J.sp(_t5114, "fillStyle", "rgba(200,210,205,0.5)")
							J.mc(env["__p"]["ctx"], "beginPath", [])
							J.mc(env["__p"]["ctx"], "arc", [J.gp(v_p_4538, "x"), J.gp(v_p_4538, "y"), (4.0 + (J.sub(1.0, v_a_4539) * 10.0)), 0.0, 7.0])
							J.mc(env["__p"]["ctx"], "fill", [])
						else:
							if J.seq(J.gp(v_p_4538, "type"), "dust"):
								var _t5115 = env["__p"]["ctx"]
								J.sp(_t5115, "fillStyle", "rgba(180,170,150,0.5)")
								J.mc(env["__p"]["ctx"], "beginPath", [])
								J.mc(env["__p"]["ctx"], "arc", [J.gp(v_p_4538, "x"), J.gp(v_p_4538, "y"), (3.0 + (J.sub(1.0, v_a_4539) * 5.0)), 0.0, 7.0])
								J.mc(env["__p"]["ctx"], "fill", [])
							else:
								if J.seq(J.gp(v_p_4538, "type"), "drip"):
									var _t5116 = env["__p"]["ctx"]
									J.sp(_t5116, "fillStyle", "#9fe0ff")
									J.mc(env["__p"]["ctx"], "beginPath", [])
									J.mc(env["__p"]["ctx"], "ellipse", [J.gp(v_p_4538, "x"), J.gp(v_p_4538, "y"), 1.6, 3.0, 0.0, 0.0, 7.0])
									J.mc(env["__p"]["ctx"], "fill", [])
								else:
									if J.seq(J.gp(v_p_4538, "type"), "note"):
										var _t5117 = env["__p"]["ctx"]
										J.sp(_t5117, "fillStyle", "#9cc89c")
										J.mc(env["__p"]["ctx"], "save", [])
										J.mc(env["__p"]["ctx"], "translate", [J.gp(v_p_4538, "x"), J.gp(v_p_4538, "y")])
										J.mc(env["__p"]["ctx"], "rotate", [J.add(J.mul(J.gp(env["__p"]["G"], "t"), 8.0), J.gp(v_p_4538, "vx"))])
										J.mc(env["__p"]["ctx"], "fillRect", [(-5.0), (-3.0), 10.0, 6.0])
										J.mc(env["__p"]["ctx"], "restore", [])
									else:
										if J.seq(J.gp(v_p_4538, "type"), "suck"):
											var _t5118 = env["__p"]["ctx"]
											J.sp(_t5118, "fillStyle", "#d24a3a")
											J.mc(env["__p"]["ctx"], "beginPath", [])
											J.mc(env["__p"]["ctx"], "arc", [J.gp(v_p_4538, "x"), J.gp(v_p_4538, "y"), 3.0, 0.0, 7.0])
											J.mc(env["__p"]["ctx"], "fill", [])
	var _t5119 = env["__p"]["ctx"]
	J.sp(_t5119, "globalAlpha", 1.0)

func _f744(this_, a: Array, env):
	var v_c_4542 = null; var v_j_4543 = null
	v_c_4542 = J.arg(a, 0)
	v_j_4543 = J.arg(a, 1)
	var _t5125 = J.add(J.gp(v_c_4542, "x"), J.mul(J.gp(v_c_4542, "v"), 0.033))
	J.sp(v_c_4542, "x", _t5125)
	var _t5126 = J.cmp(J.gp(v_c_4542, "x"), 60.0, "<")
	if (_t5126 if _t5126 else J.cmp(J.gp(v_c_4542, "x"), J.sub(env["__p"]["WW"], 60.0), ">")):
		var _t5127 = J.mul(J.gp(v_c_4542, "v"), (-1.0))
		J.sp(v_c_4542, "v", _t5127)
	var _t5128 = env["__p"]["spr"]
	J.cl(_t5128, null, ["toyol", J.gp(v_c_4542, "x"), env["bot"], 40.0, {"flip": J.cmp(J.gp(v_c_4542, "v"), 0.0, "<"), "alpha": 0.75, "oy": ((-absf(J.num(sin(J.num(J.add(J.mul(J.gp(env["__p"]["G"], "t"), 14.0), v_j_4543)))))) * 8.0)}])
	if (randf() < 0.3):
		var _t5129 = env["__p"]["part"]
		J.cl(_t5129, null, [J.gp(v_c_4542, "x"), J.sub(env["bot"], 20.0), ((randf() - 0.5) * 60.0), (-80.0), 0.6, "coin"])

func _f745(this_, a: Array, env):
	var v_f_4546 = null
	v_f_4546 = J.arg(a, 0)
	var _t5138 = env["__p"]["ctx"]
	var _t5139 = J.min_([1.0, J.gp(v_f_4546, "life")])
	J.sp(_t5138, "globalAlpha", _t5139)
	var _t5140 = env["__p"]["crText"]
	J.cl(_t5140, null, [env["__p"]["ctx"], J.gp(v_f_4546, "t"), J.gp(v_f_4546, "x"), J.gp(v_f_4546, "y"), 14.0, J.gp(v_f_4546, "c"), "center"])
	var _t5141 = env["__p"]["ctx"]
	J.sp(_t5141, "globalAlpha", 1.0)

func _f727(this_, a: Array, env):
	var v_g_4384 = null; var v_S_4385 = null; var v_fxc_4388 = null; var v_fyc_4389 = null; var v_LB_4390 = null; var v_tx_4392 = null; var v_shk_4393 = null; var v_k_4397 = null; var v_fx_4398 = null; var v_bx_4400 = null; var v_byy_4401 = null; var v_gn_4402 = null; var v_rr2_4403 = null; var v_gg_4404 = null; var v_q_4405 = null; var v_U_4406 = null; var v_uf_4407 = null; var v_ut_4408 = null; var v_top_4409 = null; var v_len_4411 = null; var v_spread_4412 = null; var v_hx_4413 = null; var v_R0_4414 = null; var v_cy_4415 = null; var v_t_4416 = null; var v_gk_4417 = null; var v_ea_4418 = null; var v_by_4419 = null; var v_yy_4420 = null
	var _s1777 = {"__p": env, "viewH": null, "viewW": null, "ty": null, "f": null, "ly": null, "fl": null, "T": null, "bot": null}
	J.mc(_s1777["__p"]["ctx"], "setTransform", [_s1777["__p"]["DPR"], 0.0, 0.0, _s1777["__p"]["DPR"], 0.0, 0.0])
	var _t4812 = _s1777["__p"]["ctx"]
	J.sp(_t4812, "fillStyle", "#0b0b0d")
	J.mc(_s1777["__p"]["ctx"], "fillRect", [0.0, 0.0, _s1777["__p"]["VW"], _s1777["__p"]["VH"]])
	var _t4813 = []
	_s1777["__p"]["buttons"] = _t4813
	if J.seq(_s1777["__p"]["scene"], "title"):
		J.cl(_s1777["__p"]["drawTitle"], null, [])
		return null
	v_g_4384 = J.gp(J.gp(_s1777["__p"]["G"], "gh"), J.gp(_s1777["__p"]["G"], "active"))
	v_S_4385 = J.mul(J.gp(_s1777["__p"]["cam"], "s"), J.gp(_s1777["__p"]["cam"], "z"))
	_s1777["viewH"] = J.div(J.sub(J.sub(_s1777["__p"]["VH"], _s1777["__p"]["TOP"]), _s1777["__p"]["BOT"]), v_S_4385)
	_s1777["viewW"] = J.div(_s1777["__p"]["VW"], v_S_4385)
	v_fxc_4388 = (J.gp(J.gp(_s1777["__p"]["cam"], "free"), "x") if J.t(J.gp(_s1777["__p"]["cam"], "free")) else J.gp(v_g_4384, "x"))
	v_fyc_4389 = (J.gp(J.gp(_s1777["__p"]["cam"], "free"), "y") if J.t(J.gp(_s1777["__p"]["cam"], "free")) else J.gp(v_g_4384, "y"))
	var _t4814 = (not J.t(J.gp(_s1777["__p"]["cam"], "free")))
	var _t4815 = (_s1777["__p"]["LIFT"] if _t4814 else _t4814)
	v_LB_4390 = (J.mc(_s1777["__p"]["LIFT"], "band", []) if J.t((J.gp(_s1777["__p"]["LIFT"], "band") if J.t(_t4815) else _t4815)) else null)
	var _t4817 = null
	if J.t(v_LB_4390):
		_t4817 = J.sub(v_fyc_4389, J.div(J.sub(J.sub(J.gp(v_LB_4390, "y1"), 14.0), _s1777["__p"]["TOP"]), v_S_4385))
	else:
		var _t4816 = _s1777["__p"]["clamp"]
		_t4817 = J.cl(_t4816, null, [J.sub(v_fyc_4389, J.mul(_s1777["viewH"], 0.55)), 0.0, J.max_([0.0, (J.sub(_s1777["__p"]["WH"], _s1777["viewH"]) + 70.0)])])
	_s1777["ty"] = _t4817
	var _t4818 = _s1777["__p"]["clamp"]
	v_tx_4392 = J.cl(_t4818, null, [J.sub(v_fxc_4388, J.div(_s1777["viewW"], 2.0)), 0.0, J.max_([0.0, J.sub(_s1777["__p"]["WW"], _s1777["viewW"])])])
	var _t4819 = _s1777["__p"]["cam"]
	var _t4820 = J.add(J.gp(_t4819, "y"), (J.sub(_s1777["ty"], J.gp(_s1777["__p"]["cam"], "y")) * 0.15))
	J.sp(_t4819, "y", _t4820)
	var _t4821 = _s1777["__p"]["cam"]
	var _t4822 = J.add(J.gp(_t4821, "x"), (J.sub(v_tx_4392, J.gp(_s1777["__p"]["cam"], "x")) * 0.15))
	J.sp(_t4821, "x", _t4822)
	v_shk_4393 = ((J.mul((randf() - 0.5), J.gp(_s1777["__p"]["G"], "shake")) * 16.0) if J.cmp(J.gp(_s1777["__p"]["G"], "shake"), 0.0, ">") else 0.0)
	J.mc(_s1777["__p"]["ctx"], "save", [])
	J.mc(_s1777["__p"]["ctx"], "translate", [v_shk_4393, _s1777["__p"]["TOP"]])
	J.mc(_s1777["__p"]["ctx"], "beginPath", [])
	J.mc(_s1777["__p"]["ctx"], "rect", [0.0, 0.0, _s1777["__p"]["VW"], J.sub(J.sub(_s1777["__p"]["VH"], _s1777["__p"]["TOP"]), _s1777["__p"]["BOT"])])
	J.mc(_s1777["__p"]["ctx"], "clip", [])
	J.mc(_s1777["__p"]["ctx"], "scale", [v_S_4385, v_S_4385])
	J.mc(_s1777["__p"]["ctx"], "translate", [(-J.num(J.gp(_s1777["__p"]["cam"], "x"))), (-J.num(J.gp(_s1777["__p"]["cam"], "y")))])
	J.mc(_s1777["__p"]["ctx"], "drawImage", [_s1777["__p"]["staticCv"], 0.0, 0.0, _s1777["__p"]["WW"], _s1777["__p"]["WH"]])
	var _t4823 = J.gp(_s1777["__p"]["G"], "units")
	J.mc(_t4823, "forEach", [Callable(self, "_f728").bind(_s1777)])
	var _t4845 = J.gp(_s1777["__p"]["G"], "edges")
	J.mc(_t4845, "forEach", [_s1777["__p"]["drawWard"]])
	J.cl(_s1777["__p"]["drawProps2"], null, [])
	var _t4846 = ["f0_e", (J.add("f", _s1777["__p"]["FL"]) + "_p")]
	J.mc(_t4846, "forEach", [Callable(self, "_f729").bind(_s1777)])
	_s1777["f"] = 0.0
	while true:
		if not J.cmp(_s1777["f"], _s1777["__p"]["FL"], "<"): break
		var _t4858 = _s1777["__p"]["fy"]
		var _t4860 = J.cmp(J.cl(_t4858, null, [_s1777["f"]]), J.sub(J.gp(_s1777["__p"]["cam"], "y"), 20.0), "<")
		if not J.t(_t4860):
			var _t4859 = _s1777["__p"]["fy"]
			_t4860 = J.cmp(J.cl(_t4859, null, [J.add(_s1777["f"], 1.0)]), J.add(J.add(J.gp(_s1777["__p"]["cam"], "y"), _s1777["viewH"]), 40.0), ">")
		if _t4860:
			_s1777["f"] = J.num(_s1777["f"]) + 1.0
			continue
		var _t4861 = _s1777["__p"]["fy"]
		_s1777["ly"] = J.add(J.cl(_t4861, null, [J.add(_s1777["f"], 1.0)]), 18.0)
		_s1777["fl"] = (0.55 + ((0.45 * sin(J.num((J.mul(J.gp(_s1777["__p"]["G"], "t"), 13.0) + J.mul(_s1777["f"], 2.1))))) * sin(J.num(J.add(J.mul(J.gp(_s1777["__p"]["G"], "t"), 3.7), _s1777["f"])))))
		if J.seq(J.mod(floor(J.num((J.mul(J.gp(_s1777["__p"]["G"], "t"), 7.0) + J.mul(_s1777["f"], 5.0)))), 23.0), 0.0):
			_s1777["fl"] = 0.1
		if J.t(J.gp(J.gp(_s1777["__p"]["G"], "dark"), _s1777["f"])):
			_s1777["fl"] = 0.0
		var _t4862 = J.gp(_s1777["__p"]["G"], "units")
		var _t4863 = J.mc(_t4862, "filter", [Callable(self, "_f730").bind(_s1777)])
		var _t4864 = J.mc(_t4863, "map", [Callable(self, "_f731").bind(_s1777)])
		J.mc(_t4864, "forEach", [Callable(self, "_f732").bind(_s1777)])
		v_k_4397 = 0.0
		while true:
			if not J.cmp(v_k_4397, 3.0, "<"): break
			v_fx_4398 = (J.mod(((J.mul(J.gp(_s1777["__p"]["G"], "t"), (10.0 + J.mul(v_k_4397, 4.0))) + J.mul(v_k_4397, 200.0)) + J.mul(_s1777["f"], 90.0)), J.add(_s1777["__p"]["WW"], 100.0)) - 50.0)
			var _t4866 = _s1777["__p"]["ctx"]
			J.sp(_t4866, "fillStyle", "rgba(180,220,210,0.07)")
			J.mc(_s1777["__p"]["ctx"], "beginPath", [])
			var _t4867 = _s1777["__p"]["fy"]
			J.mc(_s1777["__p"]["ctx"], "ellipse", [v_fx_4398, J.sub(J.cl(_t4867, null, [_s1777["f"]]), 6.0), 70.0, 9.0, 0.0, 0.0, 7.0])
			J.mc(_s1777["__p"]["ctx"], "fill", [])
			v_k_4397 = J.num(v_k_4397) + 1.0
		if J.t(J.gp(J.gp(_s1777["__p"]["G"], "dark"), _s1777["f"])):
			var _t4868 = _s1777["__p"]["ctx"]
			var _t4869 = (J.add("rgba(0,0,0,", J.min_([0.78, J.mul(J.gp(J.gp(_s1777["__p"]["G"], "dark"), _s1777["f"]), 0.6)])) + ")")
			J.sp(_t4868, "fillStyle", _t4869)
			var _t4870 = _s1777["__p"]["fy"]
			var _t4874 = J.add(J.cl(_t4870, null, [J.add(_s1777["f"], 1.0)]), 8.0)
			var _t4875 = _s1777["__p"]["WW"]
			var _t4871 = _s1777["__p"]["fy"]
			var _t4873 = J.cl(_t4871, null, [_s1777["f"]])
			var _t4872 = _s1777["__p"]["fy"]
			J.mc(_s1777["__p"]["ctx"], "fillRect", [0.0, _t4874, _t4875, (J.sub(_t4873, J.cl(_t4872, null, [J.add(_s1777["f"], 1.0)])) - 6.0)])
		_s1777["f"] = J.num(_s1777["f"]) + 1.0
	var _t4876 = J.gp(_s1777["__p"]["G"], "wardFx")
	J.mc(_t4876, "forEach", [Callable(self, "_f733").bind(_s1777)])
	J.cl(_s1777["__p"]["drawTraces"], null, [])
	J.cl(_s1777["__p"]["drawSafe"], null, [])
	J.cl(_s1777["__p"]["drawDrops"], null, [])
	var _t4881 = J.gp(_s1777["__p"]["G"], "res")
	J.mc(_t4881, "forEach", [Callable(self, "_f734").bind(_s1777)])
	if J.t(J.gp(_s1777["__p"]["G"], "tao")):
		_s1777["T"] = J.gp(_s1777["__p"]["G"], "tao")
		var _t4883 = _s1777["__p"]["fy"]
		_s1777["ty"] = J.cl(_t4883, null, [J.gp(_s1777["T"], "f")])
		var _t4884 = J.gp(_s1777["T"], "waves")
		J.mc(_t4884, "forEach", [Callable(self, "_f735").bind(_s1777)])
		var _t4888 = _s1777["__p"]["ctx"]
		J.sp(_t4888, "fillStyle", "rgba(0,0,0,0.45)")
		J.mc(_s1777["__p"]["ctx"], "beginPath", [])
		J.mc(_s1777["__p"]["ctx"], "ellipse", [J.gp(_s1777["T"], "x"), J.sub(_s1777["ty"], 1.0), 16.0, 4.0, 0.0, 0.0, 7.0])
		J.mc(_s1777["__p"]["ctx"], "fill", [])
		var _t4889 = _s1777["__p"]["ctx"]
		J.sp(_t4889, "shadowColor", "rgba(255,215,90,0.9)")
		var _t4890 = _s1777["__p"]["ctx"]
		J.sp(_t4890, "shadowBlur", 9.0)
		var _t4891 = _s1777["__p"]["spr"]
		J.cl(_t4891, null, ["npc_boss", J.gp(_s1777["T"], "x"), _s1777["ty"], 62.0, {"flip": J.cmp(J.gp(_s1777["T"], "dir"), 0.0, "<"), "oy": ((-absf(J.num(sin(J.num(J.mul(J.gp(_s1777["__p"]["G"], "t"), 6.0)))))) * 2.0)}])
		var _t4892 = _s1777["__p"]["ctx"]
		J.sp(_t4892, "shadowBlur", 0.0)
		v_bx_4400 = J.add(J.gp(_s1777["T"], "x"), J.mul(J.gp(_s1777["T"], "dir"), 16.0))
		v_byy_4401 = (J.sub(_s1777["ty"], 40.0) + (sin(J.num(J.mul(J.gp(_s1777["__p"]["G"], "t"), 14.0))) * 2.0))
		var _t4893 = _s1777["__p"]["ctx"]
		J.sp(_t4893, "fillStyle", "#e8b830")
		J.mc(_s1777["__p"]["ctx"], "beginPath", [])
		J.mc(_s1777["__p"]["ctx"], "moveTo", [J.sub(v_bx_4400, 6.0), J.add(v_byy_4401, 8.0)])
		J.mc(_s1777["__p"]["ctx"], "quadraticCurveTo", [v_bx_4400, J.sub(v_byy_4401, 10.0), J.add(v_bx_4400, 6.0), J.add(v_byy_4401, 8.0)])
		J.mc(_s1777["__p"]["ctx"], "closePath", [])
		J.mc(_s1777["__p"]["ctx"], "fill", [])
		var _t4894 = _s1777["__p"]["ctx"]
		J.sp(_t4894, "strokeStyle", "#5a3a10")
		var _t4895 = _s1777["__p"]["ctx"]
		J.sp(_t4895, "lineWidth", 1.0)
		J.mc(_s1777["__p"]["ctx"], "stroke", [])
		var _t4896 = _s1777["__p"]["ctx"]
		J.sp(_t4896, "fillStyle", "#ffe9a0")
		var _t4897 = _s1777["__p"]["ctx"]
		var _t4898 = J.add("bold 12px ", _s1777["__p"]["FONT"])
		J.sp(_t4897, "font", _t4898)
		var _t4899 = _s1777["__p"]["ctx"]
		J.sp(_t4899, "textAlign", "center")
		var _t4900 = _s1777["__p"]["ctx"]
		J.sp(_t4900, "lineWidth", 3.0)
		var _t4901 = _s1777["__p"]["ctx"]
		J.sp(_t4901, "strokeStyle", "#000")
		J.mc(_s1777["__p"]["ctx"], "strokeText", ["天師", J.gp(_s1777["T"], "x"), J.sub(_s1777["ty"], 70.0)])
		J.mc(_s1777["__p"]["ctx"], "fillText", ["天師", J.gp(_s1777["T"], "x"), J.sub(_s1777["ty"], 70.0)])
		if J.cmp(J.gp(_s1777["T"], "sayT"), 0.0, ">"):
			var _t4902 = _s1777["__p"]["bubble"]
			J.cl(_t4902, null, [J.gp(_s1777["T"], "x"), J.sub(_s1777["ty"], 78.0), J.gp(_s1777["T"], "say")])
	var _t4903 = J.gp(_s1777["__p"]["G"], "gh")
	J.mc(_t4903, "forEach", [Callable(self, "_f736").bind(_s1777)])
	var _t4907 = J.gp(_s1777["__p"]["G"], "guards")
	J.mc(_t4907, "forEach", [Callable(self, "_f737").bind(_s1777)])
	var _t4952 = J.gp(_s1777["__p"]["G"], "units")
	J.mc(_t4952, "forEach", [Callable(self, "_f739").bind(_s1777)])
	var _t4995 = J.gp(_s1777["__p"]["G"], "gate")
	if J.t((_t4995 if J.t(_t4995) else J.cmp(J.gp(_s1777["__p"]["G"], "gateCharge"), 0.0, ">"))):
		v_gn_4402 = J.gp(J.gp(_s1777["__p"]["G"], "nodes"), (J.gp(J.gp(_s1777["__p"]["G"], "gate"), "node") if J.t(J.gp(_s1777["__p"]["G"], "gate")) else J.gp(J.gp(J.gp(_s1777["__p"]["G"], "gh"), J.gp(_s1777["__p"]["G"], "gateG")), "node")))
		v_rr2_4403 = ((40.0 + (sin(J.num(J.mul(J.gp(_s1777["__p"]["G"], "t"), 4.0))) * 6.0)) if J.t(J.gp(_s1777["__p"]["G"], "gate")) else J.mul(20.0, J.gp(_s1777["__p"]["G"], "gateCharge")))
		v_gg_4404 = J.mc(_s1777["__p"]["ctx"], "createRadialGradient", [J.gp(v_gn_4402, "x"), J.sub(J.gp(v_gn_4402, "y"), 40.0), 4.0, J.gp(v_gn_4402, "x"), J.sub(J.gp(v_gn_4402, "y"), 40.0), J.mul(v_rr2_4403, 1.8)])
		J.mc(v_gg_4404, "addColorStop", [0.0, "rgba(120,255,200,0.75)"])
		J.mc(v_gg_4404, "addColorStop", [1.0, "rgba(40,120,90,0)"])
		var _t4996 = _s1777["__p"]["ctx"]
		J.sp(_t4996, "fillStyle", v_gg_4404)
		J.mc(_s1777["__p"]["ctx"], "beginPath", [])
		J.mc(_s1777["__p"]["ctx"], "arc", [J.gp(v_gn_4402, "x"), J.sub(J.gp(v_gn_4402, "y"), 40.0), J.mul(v_rr2_4403, 1.8), 0.0, 7.0])
		J.mc(_s1777["__p"]["ctx"], "fill", [])
		var _t4997 = _s1777["__p"]["ctx"]
		J.sp(_t4997, "strokeStyle", "rgba(160,255,210,0.8)")
		var _t4998 = _s1777["__p"]["ctx"]
		J.sp(_t4998, "lineWidth", 3.0)
		v_q_4405 = 0.0
		while true:
			if not J.cmp(v_q_4405, 3.0, "<"): break
			J.mc(_s1777["__p"]["ctx"], "beginPath", [])
			J.mc(_s1777["__p"]["ctx"], "arc", [J.gp(v_gn_4402, "x"), J.sub(J.gp(v_gn_4402, "y"), 40.0), J.mul(v_rr2_4403, (0.5 + J.mul(v_q_4405, 0.3))), J.mul(J.gp(_s1777["__p"]["G"], "t"), J.add(2.0, v_q_4405)), (J.mul(J.gp(_s1777["__p"]["G"], "t"), J.add(2.0, v_q_4405)) + 4.0)])
			J.mc(_s1777["__p"]["ctx"], "stroke", [])
			v_q_4405 = J.num(v_q_4405) + 1.0
	J.cl(_s1777["__p"]["drawMoves"], null, [])
	if J.t(_s1777["__p"]["UNIT"]):
		J.mc(_s1777["__p"]["UNIT"], "drawWorld", [_s1777["__p"]["ctx"]])
	var _t4999 = J.gp(_s1777["__p"]["G"], "gh")
	J.mc(_t4999, "forEach", [Callable(self, "_f742").bind(_s1777)])
	var _t5103 = J.gp(_s1777["__p"]["G"], "parts")
	J.mc(_t5103, "forEach", [Callable(self, "_f743").bind(_s1777)])
	var _t5120 = J.gp(_s1777["__p"]["G"], "ult")
	if J.t((J.cmp(J.gp(J.gp(_s1777["__p"]["G"], "ult"), "t"), 1.3, ">=") if J.t(_t5120) else _t5120)):
		v_U_4406 = J.gp(_s1777["__p"]["G"], "ult")
		v_uf_4407 = J.gp(v_U_4406, "f")
		v_ut_4408 = J.sub(J.gp(v_U_4406, "t"), 1.3)
		var _t5121 = _s1777["__p"]["fy"]
		v_top_4409 = J.add(J.cl(_t5121, null, [J.min_([_s1777["__p"]["FL"], J.add(v_uf_4407, 1.0)])]), 8.0)
		var _t5122 = _s1777["__p"]["fy"]
		_s1777["bot"] = J.cl(_t5122, null, [v_uf_4407])
		var _t5123 = J.seq(J.gp(J.gp(J.gp(v_U_4406, "g"), "d"), "key"), "toyol")
		if J.t((J.gp(v_U_4406, "clones") if _t5123 else _t5123)):
			var _t5124 = J.gp(v_U_4406, "clones")
			J.mc(_t5124, "forEach", [Callable(self, "_f744").bind(_s1777)])
		if J.seq(J.gp(J.gp(J.gp(v_U_4406, "g"), "d"), "key"), "tianhua"):
			var _t5130 = _s1777["__p"]["ctx"]
			J.sp(_t5130, "strokeStyle", "rgba(12,12,14,0.9)")
			var _t5131 = _s1777["__p"]["ctx"]
			J.sp(_t5131, "lineWidth", 2.2)
			v_len_4411 = (J.min_([1.0, J.mul(v_ut_4408, 1.6)]) * J.sub(_s1777["bot"], v_top_4409))
			v_spread_4412 = J.min_([300.0, J.mul(v_ut_4408, 190.0)])
			if J.cmp(v_spread_4412, 300.0, "<"):
				var _t5132 = _s1777["__p"]["txt"]
				J.cl(_t5132, null, ["頭髮沿走廊爬去隔籬屋……", J.gp(J.gp(v_U_4406, "g"), "x"), J.add(v_top_4409, 18.0), "#9fe0ff", 13.0])
			v_hx_4413 = J.max_([60.0, J.sub(J.gp(J.gp(v_U_4406, "g"), "x"), v_spread_4412)])
			while true:
				if not J.cmp(v_hx_4413, J.min_([J.sub(_s1777["__p"]["WW"], 55.0), J.add(J.gp(J.gp(v_U_4406, "g"), "x"), v_spread_4412)]), "<"): break
				J.mc(_s1777["__p"]["ctx"], "beginPath", [])
				J.mc(_s1777["__p"]["ctx"], "moveTo", [v_hx_4413, v_top_4409])
				J.mc(_s1777["__p"]["ctx"], "quadraticCurveTo", [J.add(v_hx_4413, (sin(J.num(J.add(J.mul(J.gp(_s1777["__p"]["G"], "t"), 3.0), v_hx_4413))) * 10.0)), J.add(v_top_4409, J.mul(v_len_4411, 0.5)), J.add(v_hx_4413, (sin(J.num((J.mul(J.gp(_s1777["__p"]["G"], "t"), 2.0) + J.mul(v_hx_4413, 0.3)))) * 8.0)), J.add(v_top_4409, v_len_4411)])
				J.mc(_s1777["__p"]["ctx"], "stroke", [])
				var _t5133 = J.add(v_hx_4413, 7.0)
				v_hx_4413 = _t5133
		if J.seq(J.gp(J.gp(J.gp(v_U_4406, "g"), "d"), "key"), "eking"):
			v_R0_4414 = (J.min_([1.0, J.mul(v_ut_4408, 1.5)]) * (J.sub(_s1777["bot"], v_top_4409) * 0.46))
			v_cy_4415 = (J.div(J.add(v_top_4409, _s1777["bot"]), 2.0) + 6.0)
			J.mc(_s1777["__p"]["ctx"], "save", [])
			J.mc(_s1777["__p"]["ctx"], "beginPath", [])
			J.mc(_s1777["__p"]["ctx"], "rect", [0.0, v_top_4409, _s1777["__p"]["WW"], J.sub(_s1777["bot"], v_top_4409)])
			J.mc(_s1777["__p"]["ctx"], "clip", [])
			var _t5134 = _s1777["__p"]["ctx"]
			J.sp(_t5134, "fillStyle", "rgba(0,0,0,0.55)")
			J.mc(_s1777["__p"]["ctx"], "fillRect", [0.0, v_top_4409, _s1777["__p"]["WW"], J.sub(_s1777["bot"], v_top_4409)])
			var _t5135 = _s1777["__p"]["drawMouth"]
			J.cl(_t5135, null, [J.gp(J.gp(v_U_4406, "g"), "x"), v_cy_4415, v_R0_4414, (0.3 + (0.7 * absf(J.num(sin(J.num(J.mul(v_ut_4408, 5.0))))))), 1.0])
			J.mc(_s1777["__p"]["ctx"], "restore", [])
			if J.cmp(v_ut_4408, 1.6, "<"):
				var _t5136 = _s1777["__p"]["txt"]
				J.cl(_t5136, null, ["開飯喇……", J.gp(J.gp(v_U_4406, "g"), "x"), J.add(v_top_4409, 16.0), "#ffb7a0", 13.0])
	var _t5137 = J.gp(_s1777["__p"]["G"], "floats")
	J.mc(_t5137, "forEach", [Callable(self, "_f745").bind(_s1777)])
	J.mc(_s1777["__p"]["ctx"], "restore", [])
	var _t5142 = J.gp(_s1777["__p"]["G"], "ult")
	if J.t((J.cmp(J.gp(J.gp(_s1777["__p"]["G"], "ult"), "t"), 1.3, "<") if J.t(_t5142) else _t5142)):
		v_t_4416 = J.gp(J.gp(_s1777["__p"]["G"], "ult"), "t")
		v_gk_4417 = J.gp(J.gp(J.gp(_s1777["__p"]["G"], "ult"), "g"), "d")
		v_ea_4418 = (J.min_([1.0, J.mul(v_t_4416, 4.0)]) * (J.div(J.sub(1.3, v_t_4416), 0.2) if J.cmp(v_t_4416, 1.1, ">") else 1.0))
		var _t5143 = _s1777["__p"]["ctx"]
		var _t5144 = (J.add("rgba(0,0,0,", J.mul(0.7, v_ea_4418)) + ")")
		J.sp(_t5143, "fillStyle", _t5144)
		J.mc(_s1777["__p"]["ctx"], "fillRect", [0.0, 0.0, _s1777["__p"]["VW"], _s1777["__p"]["VH"]])
		v_bx_4400 = (J.mul(_s1777["__p"]["VW"], (1.0 - J.div(v_t_4416, 0.25))) if J.cmp(v_t_4416, 0.25, "<") else 0.0)
		v_by_4419 = J.mul(_s1777["__p"]["VH"], 0.36)
		J.mc(_s1777["__p"]["ctx"], "save", [])
		J.mc(_s1777["__p"]["ctx"], "translate", [v_bx_4400, 0.0])
		var _t5145 = _s1777["__p"]["ctx"]
		J.sp(_t5145, "fillStyle", "rgba(110,20,20,0.92)")
		J.mc(_s1777["__p"]["ctx"], "beginPath", [])
		J.mc(_s1777["__p"]["ctx"], "moveTo", [0.0, v_by_4419])
		J.mc(_s1777["__p"]["ctx"], "lineTo", [_s1777["__p"]["VW"], J.sub(v_by_4419, 30.0)])
		J.mc(_s1777["__p"]["ctx"], "lineTo", [_s1777["__p"]["VW"], J.add(v_by_4419, 120.0)])
		J.mc(_s1777["__p"]["ctx"], "lineTo", [0.0, J.add(v_by_4419, 150.0)])
		J.mc(_s1777["__p"]["ctx"], "closePath", [])
		J.mc(_s1777["__p"]["ctx"], "fill", [])
		var _t5146 = _s1777["__p"]["ctx"]
		J.sp(_t5146, "strokeStyle", "#e8d0a0")
		var _t5147 = _s1777["__p"]["ctx"]
		J.sp(_t5147, "lineWidth", 3.0)
		J.mc(_s1777["__p"]["ctx"], "stroke", [])
		v_q_4405 = 0.0
		while true:
			if not J.cmp(v_q_4405, 14.0, "<"): break
			var _t5148 = _s1777["__p"]["ctx"]
			J.sp(_t5148, "strokeStyle", "rgba(255,220,180,0.25)")
			J.mc(_s1777["__p"]["ctx"], "beginPath", [])
			v_yy_4420 = J.add(v_by_4419, J.mod((J.mul(v_q_4405, 37.0) + J.mul(v_t_4416, 900.0)), 150.0))
			J.mc(_s1777["__p"]["ctx"], "moveTo", [0.0, v_yy_4420])
			J.mc(_s1777["__p"]["ctx"], "lineTo", [_s1777["__p"]["VW"], J.sub(v_yy_4420, 30.0)])
			J.mc(_s1777["__p"]["ctx"], "stroke", [])
			v_q_4405 = J.num(v_q_4405) + 1.0
		var _t5149 = _s1777["__p"]["spr"]
		J.cl(_t5149, null, [J.gp(v_gk_4417, "sprite"), (J.mul(_s1777["__p"]["VW"], 0.27) + (sin(J.num(J.mul(v_t_4416, 20.0))) * 2.0)), J.add(v_by_4419, 148.0), 190.0, {"sx": (1.0 + (0.04 * sin(J.num(J.mul(v_t_4416, 12.0)))))}])
		var _t5150 = _s1777["__p"]["ctx"]
		J.sp(_t5150, "fillStyle", "#ffe9c0")
		var _t5151 = _s1777["__p"]["ctx"]
		J.sp(_t5151, "strokeStyle", "#000")
		var _t5152 = _s1777["__p"]["ctx"]
		J.sp(_t5152, "lineWidth", 5.0)
		var _t5153 = _s1777["__p"]["ctx"]
		var _t5154 = J.add("bold 40px ", _s1777["__p"]["FONT"])
		J.sp(_t5153, "font", _t5154)
		var _t5155 = _s1777["__p"]["ctx"]
		J.sp(_t5155, "textAlign", "left")
		J.mc(_s1777["__p"]["ctx"], "strokeText", [J.gp(J.gp(_s1777["__p"]["ULT"], J.gp(v_gk_4417, "key")), "n"), J.mul(_s1777["__p"]["VW"], 0.5), J.add(v_by_4419, 58.0)])
		J.mc(_s1777["__p"]["ctx"], "fillText", [J.gp(J.gp(_s1777["__p"]["ULT"], J.gp(v_gk_4417, "key")), "n"), J.mul(_s1777["__p"]["VW"], 0.5), J.add(v_by_4419, 58.0)])
		var _t5156 = _s1777["__p"]["ctx"]
		var _t5157 = J.add("bold 14px ", _s1777["__p"]["FONT"])
		J.sp(_t5156, "font", _t5157)
		var _t5158 = _s1777["__p"]["ctx"]
		J.sp(_t5158, "lineWidth", 3.0)
		J.mc(_s1777["__p"]["ctx"], "strokeText", [J.gp(J.gp(_s1777["__p"]["ULT"], J.gp(v_gk_4417, "key")), "d"), (J.mul(_s1777["__p"]["VW"], 0.5) - 20.0), J.add(v_by_4419, 92.0), J.mul(_s1777["__p"]["VW"], 0.52)])
		J.mc(_s1777["__p"]["ctx"], "fillText", [J.gp(J.gp(_s1777["__p"]["ULT"], J.gp(v_gk_4417, "key")), "d"), (J.mul(_s1777["__p"]["VW"], 0.5) - 20.0), J.add(v_by_4419, 92.0), J.mul(_s1777["__p"]["VW"], 0.52)])
		J.mc(_s1777["__p"]["ctx"], "restore", [])
	J.cl(_s1777["__p"]["drawHUD"], null, [])

func _f747(this_, a: Array, env):
	var v_o_4560 = null; var v_i_4561 = null; var v_x_4562 = null; var v_y_4563 = null; var v_full_4564 = null; var v_act_4565 = null; var v_pz_4566 = null; var v_dy_4567 = null
	v_o_4560 = J.arg(a, 0)
	v_i_4561 = J.arg(a, 1)
	v_x_4562 = (10.0 + J.mul(v_i_4561, 72.0))
	v_y_4563 = J.add(env["y0"], 12.0)
	var _t5183 = J.cmp(J.gp(v_o_4560, "energy"), 100.0, ">=")
	v_full_4564 = ((not J.t(J.gp(v_o_4560, "home"))) if _t5183 else _t5183)
	v_act_4565 = J.seq(v_i_4561, J.gp(env["__p"]["G"], "active"))
	J.mc(env["__p"]["buttons"], "push", [{"id": J.add("gh", v_i_4561), "x": v_x_4562, "y": v_y_4563, "w": 64.0, "h": 74.0}])
	var _t5184 = env["__p"]["crPressed"]
	v_pz_4566 = J.cl(_t5184, null, [J.add("gh", v_i_4561)])
	v_dy_4567 = (2.0 if J.t(v_pz_4566) else 0.0)
	if J.t(v_full_4564):
		J.mc(env["__p"]["ctx"], "save", [])
		var _t5185 = env["__p"]["ctx"]
		var _t5186 = (0.45 + (0.35 * sin(J.num(J.mul(J.gp(env["__p"]["G"], "t"), 8.0)))))
		J.sp(_t5185, "globalAlpha", _t5186)
		var _t5187 = env["__p"]["crBlit"]
		var _t5189 = env["__p"]["ctx"]
		var _t5188 = env["__p"]["crGet"]
		J.cl(_t5187, null, [_t5189, J.cl(_t5188, null, [72.0, 82.0, "rust", "panel"]), J.sub(v_x_4562, 4.0), J.add(J.sub(v_y_4563, 4.0), v_dy_4567)])
		J.mc(env["__p"]["ctx"], "restore", [])
	var _t5190 = env["__p"]["crBlit"]
	var _t5192 = env["__p"]["ctx"]
	var _t5191 = env["__p"]["crGet"]
	J.cl(_t5190, null, [_t5192, J.cl(_t5191, null, [64.0, 74.0, ("rust" if J.t(v_full_4564) else ("moss" if J.t(v_act_4565) else "ink")), ("p" if J.t(v_pz_4566) else "n")]), v_x_4562, J.add(v_y_4563, v_dy_4567)])
	var _t5193 = env["__p"]["sprite"]
	var _t5195 = J.gp(J.gp(v_o_4560, "d"), "sprite")
	var _t5196 = J.add(v_x_4562, 32.0)
	var _t5197 = J.add(J.add(v_y_4563, 58.0), v_dy_4567)
	var _t5194 = J.gp(v_o_4560, "home")
	J.cl(_t5193, null, [_t5195, _t5196, _t5197, 46.0, false, (0.3 if J.t((_t5194 if J.t(_t5194) else J.gp(v_o_4560, "out"))) else 1.0)])
	var _t5198 = env["__p"]["crBar"]
	J.cl(_t5198, null, [env["__p"]["ctx"], J.add(v_x_4562, 6.0), J.add(J.add(v_y_4563, 5.0), v_dy_4567), 52.0, 6.0, J.div(J.gp(v_o_4560, "energy"), 100.0), ("rust" if J.t(v_full_4564) else "red")])
	if J.t(v_full_4564):
		var _t5199 = env["__p"]["crText"]
		J.cl(_t5199, null, [env["__p"]["ctx"], "點我放大招", J.add(v_x_4562, 32.0), J.add(J.add(v_y_4563, 24.0), v_dy_4567), 11.0, "#f6dcb6", "center", 60.0])
	var _t5200 = env["__p"]["crText"]
	J.cl(_t5200, null, [env["__p"]["ctx"], ("被收服" if J.t(J.gp(v_o_4560, "out")) else ("已返" if J.t(J.gp(v_o_4560, "home")) else J.add(J.gp(J.gp(v_o_4560, "d"), "name"), ((J.add(" ", J.gp(v_o_4560, "caught")) + "/3") if J.t(J.gp(v_o_4560, "caught")) else "")))), J.add(v_x_4562, 32.0), J.add(J.add(v_y_4563, 69.0), v_dy_4567), 12.0, ("#e4ecd2" if J.t(v_act_4565) else "#ebe3d6"), "center", 60.0])
	var _t5201 = env["__p"]["gpBadge"]
	J.cl(_t5201, null, [v_o_4560, v_x_4562, J.add(v_y_4563, v_dy_4567)])

func _f746(this_, a: Array, env):
	var v_fr_4549 = null; var v_g_4551 = null; var v_n_4552 = null; var v_atP_4553 = null; var v_A_4554 = null; var v_U_4555 = null; var v_aw_4556 = null; var v_hw_4557 = null
	var _s1892 = {"__p": env, "y0": null}
	var _t5159 = _s1892["__p"]["crPanel"]
	J.cl(_t5159, null, [_s1892["__p"]["ctx"], (-8.0), (-8.0), J.add(_s1892["__p"]["VW"], 16.0), J.add(_s1892["__p"]["TOP"], 8.0), "paper"])
	v_fr_4549 = J.min_([1.0, J.div(J.gp(_s1892["__p"]["G"], "t"), J.mul(_s1892["__p"]["PHT"], 3.0))])
	var _t5160 = _s1892["__p"]["crBar"]
	J.cl(_t5160, null, [_s1892["__p"]["ctx"], 12.0, 8.0, J.sub(_s1892["__p"]["VW"], 24.0), 15.0, v_fr_4549, "dawn"])
	var _t5161 = _s1892["__p"]["crText"]
	J.cl(_t5161, null, [_s1892["__p"]["ctx"], J.add(((((J.add("陰門死守 ", ceil(J.num(J.sub(30.0, J.gp(J.gp(_s1892["__p"]["G"], "gate"), "t"))))) + " 秒　") if J.t(J.gp(_s1892["__p"]["G"], "gate")) else "") + ((J.add(J.add(J.gp(_s1892["__p"]["PH"], J.gp(_s1892["__p"]["G"], "phase")), "　天光 "), floor(J.num(J.mul(v_fr_4549, 100.0)))) + "%") if J.cmp(J.gp(_s1892["__p"]["G"], "phase"), 3.0, "<") else (J.add("天光後・追兵第 ", J.gp(_s1892["__p"]["G"], "wave")) + " 輪"))) + "　警覺 "), J.gp(_s1892["__p"]["G"], "alert")), 14.0, 44.0, 15.0, ("#e8b4a0" if J.cmp(J.gp(_s1892["__p"]["G"], "alert"), 3.0, ">=") else "#efe5cf"), "left", J.sub(_s1892["__p"]["VW"], 110.0)])
	var _t5162 = _s1892["__p"]["crText"]
	J.cl(_t5162, null, [_s1892["__p"]["ctx"], J.add("怕意 ", J.gp(_s1892["__p"]["G"], "fear")), J.sub(_s1892["__p"]["VW"], 14.0), 44.0, 15.0, "#b2d394", "right"])
	var _t5163 = _s1892["__p"]["crText"]
	var _t5168 = _s1892["__p"]["ctx"]
	var _t5165 = (J.add((J.add((J.add("收穫 ", J.len(J.gp(_s1892["__p"]["G"], "bag"))) + "/"), _s1892["__p"]["BAGMAX"]) + "　紙人 "), J.gp(_s1892["__p"]["G"], "dolls")) + "/6　匙 紅")
	var _t5164 = J.gp(J.gp(_s1892["__p"]["G"], "keys"), "key")
	var _t5167 = (J.add(_t5165, (_t5164 if J.t(_t5164) else 0.0)) + " 黃")
	var _t5166 = J.gp(J.gp(_s1892["__p"]["G"], "keys"), "key2")
	J.cl(_t5163, null, [_t5168, (J.add(_t5167, (_t5166 if J.t(_t5166) else 0.0)) + ("　帶住失物" if J.t(J.gp(_s1892["__p"]["G"], "carry")) else "")), 14.0, 68.0, 13.0, "#cfc4b0", "left", J.sub(_s1892["__p"]["VW"], 118.0)])
	var _t5169 = _s1892["__p"]["btn"]
	J.cl(_t5169, null, ["story", J.sub(_s1892["__p"]["VW"], 100.0), 48.0, 90.0, 44.0, J.add((J.add("故事 ", J.len(J.gp(_s1892["__p"]["G"], "story"))) + "/"), J.len(_s1892["__p"]["STORY"])), "#2e3a34"])
	J.cl(_s1892["__p"]["drawMini"], null, [])
	if J.t(J.gp(_s1892["__p"]["cam"], "free")):
		var _t5170 = _s1892["__p"]["btn"]
		J.cl(_t5170, null, ["follow", (J.div(_s1892["__p"]["VW"], 2.0) - 66.0), J.add(_s1892["__p"]["TOP"], 8.0), 132.0, 46.0, "◎ 跟返隻鬼", "#2f5a4a"])
	var _t5171 = _s1892["__p"]["btn"]
	J.cl(_t5171, null, ["quit", 10.0, J.add(_s1892["__p"]["TOP"], 8.0), 62.0, 46.0, "離開", "#2c2c33"])
	var _t5172 = _s1892["__p"]["btn"]
	J.cl(_t5172, null, ["zin", J.sub(_s1892["__p"]["VW"], 56.0), J.add(_s1892["__p"]["TOP"], 8.0), 46.0, 46.0, "＋", "#24242a"])
	var _t5173 = _s1892["__p"]["btn"]
	J.cl(_t5173, null, ["zout", J.sub(_s1892["__p"]["VW"], 56.0), J.add(_s1892["__p"]["TOP"], 60.0), 46.0, 46.0, "－", "#24242a"])
	_s1892["y0"] = J.sub(_s1892["__p"]["VH"], _s1892["__p"]["BOT"])
	var _t5174 = _s1892["__p"]["crPanel"]
	J.cl(_t5174, null, [_s1892["__p"]["ctx"], (-8.0), _s1892["y0"], J.add(_s1892["__p"]["VW"], 16.0), J.add(_s1892["__p"]["BOT"], 8.0), "paper"])
	var _t5175 = J.cmp(J.gp(_s1892["__p"]["G"], "toastT"), 0.0, ">")
	if J.t((J.gp(_s1892["__p"]["G"], "toast") if _t5175 else _t5175)):
		var _t5176 = _s1892["__p"]["crPanel"]
		J.cl(_t5176, null, [_s1892["__p"]["ctx"], 10.0, J.sub(_s1892["y0"], 58.0), J.sub(_s1892["__p"]["VW"], 20.0), 52.0, "sheet"])
		var _t5177 = _s1892["__p"]["ctx"]
		J.sp(_t5177, "fillStyle", "#efdcb4")
		var _t5178 = _s1892["__p"]["ctx"]
		var _t5179 = J.add("bold 13px ", _s1892["__p"]["FONT"])
		J.sp(_t5178, "font", _t5179)
		var _t5180 = _s1892["__p"]["ctx"]
		J.sp(_t5180, "textAlign", "left")
		var _t5181 = _s1892["__p"]["wrap"]
		J.cl(_t5181, null, [J.gp(_s1892["__p"]["G"], "toast"), 20.0, J.sub(_s1892["y0"], 37.0), J.sub(_s1892["__p"]["VW"], 40.0), 17.0])
	var _t5182 = J.gp(_s1892["__p"]["G"], "gh")
	J.mc(_t5182, "forEach", [Callable(self, "_f747").bind(_s1892)])
	v_g_4551 = J.gp(J.gp(_s1892["__p"]["G"], "gh"), J.gp(_s1892["__p"]["G"], "active"))
	v_n_4552 = J.gp(J.gp(_s1892["__p"]["G"], "nodes"), J.gp(v_g_4551, "node"))
	var _t5202 = (not J.t(J.gp(v_g_4551, "to")))
	var _t5203 = (J.seq(J.gp(v_n_4552, "kind"), "portal") if _t5202 else _t5202)
	v_atP_4553 = ((not J.t(J.gp(v_g_4551, "home"))) if _t5203 else _t5203)
	var _t5204 = _s1892["__p"]["btn"]
	J.cl(_t5204, null, ["scare", J.sub(_s1892["__p"]["VW"], 170.0), J.add(_s1892["y0"], 12.0), 74.0, 52.0, "嚇！", "#6e1c1c"])
	var _t5205 = _s1892["__p"]["btn"]
	J.cl(_t5205, null, ["inv", J.sub(_s1892["__p"]["VW"], 88.0), J.add(_s1892["y0"], 12.0), 76.0, 52.0, (J.add("隱身 ", ceil(J.num(J.gp(v_g_4551, "invCd")))) if J.cmp(J.gp(v_g_4551, "invCd"), 0.0, ">") else "隱身"), "#2a4a7a", J.cmp(J.gp(v_g_4551, "invCd"), 0.0, "<=")])
	var _t5206 = _s1892["__p"]["ctxAction"]
	v_A_4554 = J.cl(_t5206, null, [v_g_4551])
	var _t5207 = J.cmp(J.gp(v_g_4551, "energy"), 100.0, ">=")
	var _t5208 = ((not J.t(J.gp(v_g_4551, "home"))) if _t5207 else _t5207)
	var _t5209 = ((not J.t(J.gp(v_g_4551, "out"))) if _t5208 else _t5208)
	v_U_4555 = ((not J.t(J.gp(_s1892["__p"]["G"], "ult"))) if _t5209 else _t5209)
	v_aw_4556 = (J.div(J.sub(_s1892["__p"]["VW"], 30.0), 2.0) if J.t(v_U_4555) else J.sub(_s1892["__p"]["VW"], 20.0))
	if J.t(v_A_4554):
		var _t5210 = _s1892["__p"]["btn"]
		J.cl(_t5210, null, ["act", 10.0, J.add(_s1892["y0"], 92.0), v_aw_4556, 46.0, J.gp(v_A_4554, "t"), ("#3a3a40" if J.seq(J.gp(v_A_4554, "k"), "respect") else "#3a5a2a"), (not J.seq(J.gp(v_A_4554, "k"), "respect"))])
	else:
		if (not J.t(v_U_4555)):
			var _t5211 = _s1892["__p"]["crText"]
			J.cl(_t5211, null, [_s1892["__p"]["ctx"], "撳住戶＝行過去嚇；企喺電器、水管、𨋢口、樓梯口出「互動」", J.div(_s1892["__p"]["VW"], 2.0), J.add(_s1892["y0"], 120.0), 12.0, "#9a8e92", "center", J.sub(_s1892["__p"]["VW"], 20.0), false, "normal"])
	if J.t(v_U_4555):
		var _t5212 = _s1892["__p"]["btn"]
		J.cl(_t5212, null, ["ult", (J.add(20.0, v_aw_4556) if J.t(v_A_4554) else 10.0), J.add(_s1892["y0"], 92.0), (v_aw_4556 if J.t(v_A_4554) else J.sub(_s1892["__p"]["VW"], 20.0)), 46.0, J.add("放大招：", J.gp(J.gp(_s1892["__p"]["ULT"], J.gp(J.gp(v_g_4551, "d"), "key")), "n")), "#8a5a14"])
	v_hw_4557 = J.div(J.sub(_s1892["__p"]["VW"], 30.0), 2.0)
	var _t5213 = _s1892["__p"]["btn"]
	J.cl(_t5213, null, ["gate", 10.0, J.add(_s1892["y0"], 146.0), v_hw_4557, 44.0, ((J.add("陰門 ", ceil(J.num(J.sub(30.0, J.gp(J.gp(_s1892["__p"]["G"], "gate"), "t"))))) + "s") if J.t(J.gp(_s1892["__p"]["G"], "gate")) else ("開陰門（企定）" if J.t(v_atP_4553) else "陰門：天台/地庫")), "#2f5a4a", ((not J.t(J.gp(_s1892["__p"]["G"], "gate"))) if J.t(v_atP_4553) else v_atP_4553)])
	var _t5214 = _s1892["__p"]["btn"]
	var _t5216 = J.add(20.0, v_hw_4557)
	var _t5217 = J.add(_s1892["y0"], 146.0)
	var _t5218 = (J.add("替身遁走 ", J.gp(_s1892["__p"]["G"], "dolls")) + "/6")
	var _t5215 = J.cmp(J.gp(_s1892["__p"]["G"], "dolls"), 6.0, ">=")
	J.cl(_t5214, null, ["doll", _t5216, _t5217, v_hw_4557, 44.0, _t5218, "#5a1c1c", ((not J.t(J.gp(_s1892["__p"]["G"], "gate"))) if _t5215 else _t5215)])
	var _t5219 = _s1892["__p"]["crText"]
	J.cl(_t5219, null, [_s1892["__p"]["ctx"], "拖動＝移動；鬆手企定先嚇人、搜嘢、附身、破鎮宅", J.div(_s1892["__p"]["VW"], 2.0), J.sub(_s1892["__p"]["VH"], 12.0), 12.0, "#9a8e92", "center", J.sub(_s1892["__p"]["VW"], 16.0), false, "normal"])
	if J.t(J.gp(_s1892["__p"]["G"], "choice")):
		J.cl(_s1892["__p"]["drawChoice"], null, [])
	if J.t(J.gp(_s1892["__p"]["G"], "showStory")):
		J.cl(_s1892["__p"]["drawStory"], null, [])
	if J.t(J.gp(_s1892["__p"]["G"], "over")):
		J.cl(_s1892["__p"]["drawOver"], null, [])

func _f748(this_, a: Array, env):
	var v_t_4570 = null; var v_x_4571 = null; var v_y_4572 = null; var v_w_4573 = null; var v_lh_4574 = null; var v_line_4575 = null; var v_yy_4576 = null; var v_i_4577 = null; var v_tt_4578 = null
	v_t_4570 = J.arg(a, 0)
	v_x_4571 = J.arg(a, 1)
	v_y_4572 = J.arg(a, 2)
	v_w_4573 = J.arg(a, 3)
	v_lh_4574 = J.arg(a, 4)
	v_line_4575 = ""
	v_yy_4576 = v_y_4572
	v_i_4577 = 0.0
	while true:
		if not J.cmp(v_i_4577, J.len(v_t_4570), "<"): break
		v_tt_4578 = J.add(v_line_4575, J.gp(v_t_4570, v_i_4577))
		if J.cmp(J.gp(J.mc(env["ctx"], "measureText", [v_tt_4578]), "width"), v_w_4573, ">"):
			var _t5220 = env["crFill"]
			J.cl(_t5220, null, [v_line_4575, v_x_4571, v_yy_4576])
			v_line_4575 = J.gp(v_t_4570, v_i_4577)
			var _t5221 = J.add(v_yy_4576, v_lh_4574)
			v_yy_4576 = _t5221
		else:
			v_line_4575 = v_tt_4578
		v_i_4577 = J.num(v_i_4577) + 1.0
	var _t5222 = env["crFill"]
	J.cl(_t5222, null, [v_line_4575, v_x_4571, v_yy_4576])
	return v_yy_4576

func _f749(this_, a: Array, env):
	var v_h_4581 = null; var v_y_4582 = null
	v_h_4581 = J.arg(a, 0)
	var _t5223 = env["ctx"]
	J.sp(_t5223, "fillStyle", "rgba(6,3,8,0.78)")
	J.mc(env["ctx"], "fillRect", [0.0, 0.0, env["VW"], env["VH"]])
	v_y_4582 = J.div(J.sub(env["VH"], v_h_4581), 2.0)
	var _t5224 = env["crPanel"]
	J.cl(_t5224, null, [env["ctx"], 16.0, v_y_4582, J.sub(env["VW"], 32.0), v_h_4581, "sheet"])
	var _t5225 = []
	env["buttons"] = _t5225
	return v_y_4582

func _f751(this_, a: Array, env):
	var v_c_4589 = null; var v_i_4590 = null; var v_by_4591 = null
	v_c_4589 = J.arg(a, 0)
	v_i_4590 = J.arg(a, 1)
	v_by_4591 = J.add(J.add(env["y"], 52.0), J.mul(v_i_4590, 88.0))
	var _t5235 = env["__p"]["btn"]
	J.cl(_t5235, null, [J.add("card", v_i_4590), 26.0, v_by_4591, J.sub(env["__p"]["VW"], 52.0), 78.0, "", "#26262c"])
	var _t5236 = env["__p"]["ctx"]
	J.sp(_t5236, "fillStyle", "#ffd54a")
	var _t5237 = env["__p"]["ctx"]
	var _t5238 = J.add("bold 18px ", env["__p"]["FONT"])
	J.sp(_t5237, "font", _t5238)
	var _t5239 = env["__p"]["crFill"]
	J.cl(_t5239, null, [J.gp(v_c_4589, "t"), J.div(env["__p"]["VW"], 2.0), J.add(v_by_4591, 32.0), J.sub(env["__p"]["VW"], 70.0)])
	var _t5240 = env["__p"]["ctx"]
	J.sp(_t5240, "fillStyle", "#d6dad2")
	var _t5241 = env["__p"]["ctx"]
	var _t5242 = J.add("bold 14px ", env["__p"]["FONT"])
	J.sp(_t5241, "font", _t5242)
	var _t5243 = env["__p"]["crFill"]
	J.cl(_t5243, null, [J.gp(v_c_4589, "d"), J.div(env["__p"]["VW"], 2.0), J.add(v_by_4591, 58.0), J.sub(env["__p"]["VW"], 70.0)])

func _f750(this_, a: Array, env):
	var v_h_4585 = null
	var _s1902 = {"__p": env, "y": null}
	v_h_4585 = 330.0
	_s1902["y"] = (J.sub(_s1902["__p"]["VH"], v_h_4585) - 8.0)
	var _t5226 = _s1902["__p"]["ctx"]
	J.sp(_t5226, "fillStyle", "rgba(6,3,8,0.45)")
	J.mc(_s1902["__p"]["ctx"], "fillRect", [0.0, 0.0, _s1902["__p"]["VW"], _s1902["__p"]["VH"]])
	var _t5227 = _s1902["__p"]["crPanel"]
	J.cl(_t5227, null, [_s1902["__p"]["ctx"], 10.0, _s1902["y"], J.sub(_s1902["__p"]["VW"], 20.0), v_h_4585, "sheet"])
	var _t5228 = []
	_s1902["__p"]["buttons"] = _t5228
	var _t5229 = _s1902["__p"]["ctx"]
	J.sp(_t5229, "fillStyle", "#fff")
	var _t5230 = _s1902["__p"]["ctx"]
	var _t5231 = J.add("bold 19px ", _s1902["__p"]["FONT"])
	J.sp(_t5230, "font", _t5231)
	var _t5232 = _s1902["__p"]["ctx"]
	J.sp(_t5232, "textAlign", "center")
	var _t5233 = _s1902["__p"]["crFill"]
	J.cl(_t5233, null, ["怕意滿咗！揀一樣強化", J.div(_s1902["__p"]["VW"], 2.0), J.add(_s1902["y"], 36.0)])
	var _t5234 = J.gp(_s1902["__p"]["G"], "choice")
	J.mc(_t5234, "forEach", [Callable(self, "_f751").bind(_s1902)])

func _f753(this_, a: Array, env):
	var v_q_4600 = null
	v_q_4600 = J.arg(a, 0)
	var _t5271 = env["__p"]["ctx"]
	var _t5272 = ("#8affc8" if J.seq(J.gp(v_q_4600, "state"), 2.0) else "#d8d8d0")
	J.sp(_t5271, "fillStyle", _t5272)
	var _t5273 = env["__p"]["wrap"]
	var _t5275 = J.add(("✓ " if J.seq(J.gp(v_q_4600, "state"), 2.0) else "・"), J.gp(v_q_4600, "t"))
	var _t5274 = J.seq(J.gp(v_q_4600, "id"), "debt")
	var _t5276 = J.add(J.cl(_t5273, null, [(_t5275 + ("（遲啲先出現）" if (J.seq(J.gp(v_q_4600, "state"), 0.0) if _t5274 else _t5274) else "")), 28.0, env["yy"], J.sub(env["__p"]["VW"], 56.0), 16.0]), 20.0)
	env["yy"] = _t5276

func _f752(this_, a: Array, env):
	var v_H0_4594 = null; var v_y_4595 = null; var v_f_4597 = null
	var _s1904 = {"__p": env, "yy": null}
	v_H0_4594 = J.min_([J.sub(_s1904["__p"]["VH"], 40.0), 620.0])
	var _t5244 = _s1904["__p"]["panel"]
	v_y_4595 = J.cl(_t5244, null, [v_H0_4594])
	var _t5245 = _s1904["__p"]["ctx"]
	J.sp(_t5245, "fillStyle", "#fff")
	var _t5246 = _s1904["__p"]["ctx"]
	var _t5247 = J.add("bold 18px ", _s1904["__p"]["FONT"])
	J.sp(_t5246, "font", _t5247)
	var _t5248 = _s1904["__p"]["ctx"]
	J.sp(_t5248, "textAlign", "center")
	var _t5249 = _s1904["__p"]["crFill"]
	J.cl(_t5249, null, [(J.add((J.add(J.add(J.gp(_s1904["__p"]["LV"], "name"), "嘅故事（"), J.len(J.gp(_s1904["__p"]["G"], "story"))) + "/"), J.len(_s1904["__p"]["STORY"])) + "）"), J.div(_s1904["__p"]["VW"], 2.0), J.add(v_y_4595, 34.0)])
	var _t5250 = _s1904["__p"]["ctx"]
	J.sp(_t5250, "textAlign", "left")
	var _t5251 = _s1904["__p"]["ctx"]
	var _t5252 = J.add("13px ", _s1904["__p"]["FONT"])
	J.sp(_t5251, "font", _t5252)
	_s1904["yy"] = J.add(v_y_4595, 60.0)
	v_f_4597 = 0.0
	while true:
		if not J.cmp(v_f_4597, J.len(_s1904["__p"]["STORY"]), "<"): break
		var _t5253 = _s1904["__p"]["ctx"]
		var _t5254 = J.gp(_s1904["__p"]["G"], "story")
		var _t5255 = ("#ecece6" if J.cmp(J.mc(_t5254, "indexOf", [v_f_4597]), 0.0, ">=") else "#5a5e58")
		J.sp(_t5253, "fillStyle", _t5255)
		var _t5256 = _s1904["__p"]["wrap"]
		var _t5257 = J.gp(_s1904["__p"]["G"], "story")
		var _t5258 = J.add(J.cl(_t5256, null, [(J.gp(_s1904["__p"]["STORY"], v_f_4597) if J.cmp(J.mc(_t5257, "indexOf", [v_f_4597]), 0.0, ">=") else J.add(J.gp(J.gp(_s1904["__p"]["LV"], "hint"), v_f_4597), "：？？？（嚇走「✦故事」戶或者完成支線）")), 28.0, _s1904["yy"], J.sub(_s1904["__p"]["VW"], 56.0), 16.0]), 22.0)
		_s1904["yy"] = _t5258
		v_f_4597 = J.num(v_f_4597) + 1.0
	if J.seq(J.len(J.gp(_s1904["__p"]["G"], "story")), J.len(_s1904["__p"]["STORY"])):
		var _t5259 = _s1904["__p"]["ctx"]
		J.sp(_t5259, "fillStyle", "#ffd54a")
		var _t5260 = _s1904["__p"]["wrap"]
		var _t5261 = J.add(J.cl(_t5260, null, [_s1904["__p"]["TRUTH"], 28.0, _s1904["yy"], J.sub(_s1904["__p"]["VW"], 56.0), 16.0]), 24.0)
		_s1904["yy"] = _t5261
	var _t5262 = _s1904["__p"]["ctx"]
	J.sp(_t5262, "fillStyle", "#9fd6bf")
	var _t5263 = _s1904["__p"]["ctx"]
	var _t5264 = J.add("bold 13px ", _s1904["__p"]["FONT"])
	J.sp(_t5263, "font", _t5264)
	var _t5265 = _s1904["__p"]["crFill"]
	J.cl(_t5265, null, ["支線", 28.0, _s1904["yy"]])
	var _t5266 = J.add(_s1904["yy"], 20.0)
	_s1904["yy"] = _t5266
	var _t5267 = _s1904["__p"]["ctx"]
	var _t5268 = J.add("12px ", _s1904["__p"]["FONT"])
	J.sp(_t5267, "font", _t5268)
	var _t5269 = J.gp(_s1904["__p"]["G"], "quests")
	var _t5270 = (_t5269 if J.t(_t5269) else [])
	J.mc(_t5270, "forEach", [Callable(self, "_f753").bind(_s1904)])
	var _t5277 = _s1904["__p"]["btn"]
	J.cl(_t5277, null, ["closeStory", (J.div(_s1904["__p"]["VW"], 2.0) - 60.0), J.sub(J.add(v_y_4595, v_H0_4594), 56.0), 120.0, 46.0, "返去", "#5a1c1c"])

func _f755(this_, a: Array, env):
	var v_m_4608 = null; var v_i_4609 = null
	v_m_4608 = J.arg(a, 0)
	v_i_4609 = J.arg(a, 1)
	var _t5288 = env["__p"]["crFill"]
	J.cl(_t5288, null, [v_m_4608, J.div(env["__p"]["VW"], 2.0), J.add(J.add(env["y"], 90.0), J.mul(v_i_4609, 30.0)), J.sub(env["__p"]["VW"], 50.0)])

func _f754(this_, a: Array, env):
	var v_o_4603 = null; var v_msg_4605 = null
	var _s1909 = {"__p": env, "y": null}
	v_o_4603 = J.gp(_s1909["__p"]["G"], "over")
	var _t5278 = _s1909["__p"]["panel"]
	_s1909["y"] = J.cl(_t5278, null, [420.0])
	var _t5279 = _s1909["__p"]["ctx"]
	J.sp(_t5279, "textAlign", "center")
	var _t5280 = _s1909["__p"]["ctx"]
	var _t5281 = ("#8affc8" if J.t(J.gp(v_o_4603, "ok")) else "#ff9a9a")
	J.sp(_t5280, "fillStyle", _t5281)
	var _t5282 = _s1909["__p"]["ctx"]
	var _t5283 = J.add("bold 26px ", _s1909["__p"]["FONT"])
	J.sp(_t5282, "font", _t5283)
	var _t5284 = _s1909["__p"]["crFill"]
	J.cl(_t5284, null, [("陰門撤離成功！" if J.seq(J.gp(v_o_4603, "why"), "gate") else ("替身遁走！" if J.seq(J.gp(v_o_4603, "why"), "doll") else "被圍收服……")), J.div(_s1909["__p"]["VW"], 2.0), J.add(_s1909["y"], 44.0)])
	var _t5285 = _s1909["__p"]["ctx"]
	J.sp(_t5285, "fillStyle", "#fff")
	var _t5286 = _s1909["__p"]["ctx"]
	var _t5287 = J.add("bold 15px ", _s1909["__p"]["FONT"])
	J.sp(_t5286, "font", _t5287)
	v_msg_4605 = ([(J.add("返到陰間嘅鬼：", J.gp(v_o_4603, "home")) + " 隻"), (J.add("帶走全部收穫：", J.gp(v_o_4603, "kept")) + " 件"), J.add((J.add("收服故事碎片：", J.gp(v_o_4603, "story")) + "/"), J.len(_s1909["__p"]["STORY"])), J.add("今晚怕意總共：", J.gp(v_o_4603, "fear")), J.add("全樓警覺：", J.gp(v_o_4603, "alert"))] if J.seq(J.gp(v_o_4603, "why"), "gate") else ([(J.add("用替身紙人遁走：", J.gp(v_o_4603, "home")) + " 隻鬼"), (J.add((J.add("帶走一半收穫：", J.gp(v_o_4603, "kept")) + " 件（留低 "), J.gp(v_o_4603, "lost")) + " 件）"), (J.add("故事碎片冇得帶走（", J.gp(v_o_4603, "storyLost")) + " 塊留咗喺樓入面）"), J.add("今晚怕意總共：", J.gp(v_o_4603, "fear"))] if J.seq(J.gp(v_o_4603, "why"), "doll") else ["三隻鬼全部畀人收服", (J.add("收穫全部冇晒：", J.gp(v_o_4603, "lost")) + " 件"), J.add("今晚怕意總共：", J.gp(v_o_4603, "fear")), J.add("全樓警覺：", J.gp(v_o_4603, "alert"))]))
	J.mc(v_msg_4605, "forEach", [Callable(self, "_f755").bind(_s1909)])
	if J.seq(J.gp(v_o_4603, "story"), J.len(_s1909["__p"]["STORY"])):
		var _t5289 = _s1909["__p"]["ctx"]
		J.sp(_t5289, "fillStyle", "#ffd54a")
		var _t5290 = _s1909["__p"]["ctx"]
		var _t5291 = J.add("bold 13px ", _s1909["__p"]["FONT"])
		J.sp(_t5290, "font", _t5291)
		var _t5292 = _s1909["__p"]["ctx"]
		J.sp(_t5292, "textAlign", "left")
		var _t5293 = _s1909["__p"]["wrap"]
		J.cl(_t5293, null, [_s1909["__p"]["TRUTH"], 36.0, J.add(_s1909["y"], 250.0), J.sub(_s1909["__p"]["VW"], 72.0), 18.0])
	if (not J.t(J.gp(v_o_4603, "ok"))):
		var _t5294 = _s1909["__p"]["gpOver"]
		J.cl(_t5294, null, [v_o_4603, _s1909["y"]])
	var _t5295 = _s1909["__p"]["btn"]
	J.cl(_t5295, null, ["again", (J.div(_s1909["__p"]["VW"], 2.0) - 130.0), J.sub(J.add(_s1909["y"], 420.0), 60.0), 120.0, 44.0, "再嚟一晚", "#5a1c1c"])
	var _t5296 = _s1909["__p"]["btn"]
	J.cl(_t5296, null, ["toMap", (J.div(_s1909["__p"]["VW"], 2.0) + 10.0), J.sub(J.add(_s1909["y"], 420.0), 60.0), 120.0, 44.0, "返地圖", "#2c2c33"])
	if (not J.leq(J.gp(v_o_4603, "reward"), null)):
		var _t5297 = _s1909["__p"]["crText"]
		J.cl(_t5297, null, [_s1909["__p"]["ctx"], J.add("收到冥幣 +", J.gp(v_o_4603, "reward")), J.div(_s1909["__p"]["VW"], 2.0), J.sub(J.add(_s1909["y"], 420.0), 76.0), 17.0, "#e6a85a", "center"])

func _f756(this_, a: Array, env):
	var v_r_4612 = null; var v_y_4613 = null; var v_p_4614 = null; var v_k_4615 = null
	var _t5298 = env["crRnd"]
	v_r_4612 = J.cl(_t5298, null, [5.0])
	v_y_4613 = (J.mul(env["VH"], 0.24) + 52.0)
	J.mc(env["ctx"], "save", [])
	var _t5299 = env["ctx"]
	J.sp(_t5299, "strokeStyle", "#7a2522")
	var _t5300 = env["ctx"]
	J.sp(_t5300, "lineCap", "round")
	v_p_4614 = 0.0
	while true:
		if not J.cmp(v_p_4614, 3.0, "<"): break
		var _t5301 = env["ctx"]
		var _t5302 = (0.5 + J.mul(J.cl(v_r_4612, null, []), 0.4))
		J.sp(_t5301, "globalAlpha", _t5302)
		var _t5303 = env["ctx"]
		var _t5304 = (2.4 - J.mul(v_p_4614, 0.5))
		J.sp(_t5303, "lineWidth", _t5304)
		J.mc(env["ctx"], "beginPath", [])
		J.mc(env["ctx"], "moveTo", [(J.mul(env["VW"], 0.2) + J.mul(J.cl(v_r_4612, null, []), 6.0)), J.add(v_y_4613, J.mul(J.cl(v_r_4612, null, []), 3.0))])
		v_k_4615 = 1.0
		while true:
			if not J.cmp(v_k_4615, 8.0, "<="): break
			J.mc(env["ctx"], "lineTo", [(J.mul(env["VW"], 0.2) + J.div(J.mul(J.mul(env["VW"], 0.6), v_k_4615), 8.0)), J.add(v_y_4613, (J.sub(J.cl(v_r_4612, null, []), 0.5) * 4.0))])
			v_k_4615 = J.num(v_k_4615) + 1.0
		J.mc(env["ctx"], "stroke", [])
		v_p_4614 = J.num(v_p_4614) + 1.0
	J.mc(env["ctx"], "restore", [])
	var _t5305 = env["crPanel"]
	J.cl(_t5305, null, [env["ctx"], 14.0, (J.mul(env["VH"], 0.62) - 24.0), J.sub(env["VW"], 28.0), ((5.0 * 24.0) + 14.0), "ink"])

func _f758(this_, a: Array, env):
	var v_d_4622 = null; var v_i_4623 = null
	v_d_4622 = J.arg(a, 0)
	v_i_4623 = J.arg(a, 1)
	var _t5316 = env["sprite"]
	J.cl(_t5316, null, [J.gp(v_d_4622, "sprite"), (J.div(env["VW"], 2.0) + (J.sub(v_i_4623, 1.0) * 100.0)), J.mul(env["VH"], 0.52), J.mul(J.gp(v_d_4622, "h"), 1.5)])

func _f759(this_, a: Array, env):
	var v_t_4626 = null; var v_i_4627 = null
	v_t_4626 = J.arg(a, 0)
	v_i_4627 = J.arg(a, 1)
	var _t5321 = env["crFill"]
	J.cl(_t5321, null, [v_t_4626, J.div(env["VW"], 2.0), (J.mul(env["VH"], 0.62) + J.mul(v_i_4627, 24.0)), J.sub(env["VW"], 30.0)])

func _f757(this_, a: Array, env):
	var v_sv_4618 = null; var v_shopOpen_4619 = null
	J.cl(env["crBg"], null, [])
	J.cl(env["crTitleDeco"], null, [])
	var _t5306 = env["btn"]
	J.cl(_t5306, null, ["exit", 12.0, 14.0, 104.0, 46.0, "◀ 返地圖", "#2c2c33"])
	var _t5307 = env["ctx"]
	J.sp(_t5307, "textAlign", "center")
	var _t5308 = env["ctx"]
	J.sp(_t5308, "fillStyle", "#c4493c")
	var _t5309 = env["ctx"]
	var _t5310 = J.add("bold 40px ", env["FONT"])
	J.sp(_t5309, "font", _t5310)
	var _t5311 = env["crFill"]
	J.cl(_t5311, null, ["樓裡有鬼", J.div(env["VW"], 2.0), J.mul(env["VH"], 0.24)])
	var _t5312 = env["ctx"]
	var _t5313 = J.add("bold 16px ", env["FONT"])
	J.sp(_t5312, "font", _t5313)
	var _t5314 = env["ctx"]
	J.sp(_t5314, "fillStyle", "#d8ccb0")
	var _t5315 = env["crFill"]
	J.cl(_t5315, null, ["揀一棟樓・天光前返陰間", J.div(env["VW"], 2.0), (J.mul(env["VH"], 0.24) + 36.0)])
	J.mc(env["GH"], "forEach", [Callable(self, "_f758").bind(env)])
	var _t5317 = env["ctx"]
	J.sp(_t5317, "fillStyle", "#c8ccc4")
	var _t5318 = env["ctx"]
	var _t5319 = J.add("bold 14px ", env["FONT"])
	J.sp(_t5318, "font", _t5319)
	var _t5320 = ["三隻鬼一齊出動：餓鬼搵宵夜、Toyol 偷錢、天花姐梳頭。", "成棟樓幾十戶人：打機、返夜更、打麻雀、網購……", "保安唔係捉鬼師傅：附身電器、敲水管、叫𨋢引開佢。", "有紅紙符、門神、拿督公、祖先牌位要尊重，繞路行。", "子時→丑時→寅時，天光前由地庫或天台陰門返陰間。"]
	J.mc(_t5320, "forEach", [Callable(self, "_f759").bind(env)])
	v_sv_4618 = J.cl(env["TS"], null, [])
	var _t5322 = (not (not J.t(J.gp(J.gp(v_sv_4618, "cleared"), "flat"))))
	var _t5323 = (_t5322 if _t5322 else J.mc(env["Q"], "has", ["unlock"]))
	v_shopOpen_4619 = (_t5323 if J.t(_t5323) else (not (not J.t(J.gp(J.G.get("window"), "STN_TEST")))))
	var _t5324 = env["btn"]
	J.cl(_t5324, null, ["lv_flat", 22.0, J.mul(env["VH"], 0.8), J.div(J.sub(env["VW"], 56.0), 2.0), 58.0, ("組屋" + (" ✓" if J.t(J.gp(J.gp(v_sv_4618, "cleared"), "flat")) else "")), "#5a1c1c"])
	var _t5325 = env["btn"]
	J.cl(_t5325, null, ["lv_shop", (34.0 + J.div(J.sub(env["VW"], 56.0), 2.0)), J.mul(env["VH"], 0.8), J.div(J.sub(env["VW"], 56.0), 2.0), 58.0, (("老店屋" + (" ✓" if J.t(J.gp(J.gp(v_sv_4618, "cleared"), "shop")) else "")) if J.t(v_shopOpen_4619) else "老店屋（未解鎖）"), "#2f5a4a", v_shopOpen_4619])
	var _t5326 = env["ctx"]
	J.sp(_t5326, "fillStyle", "#7a7f78")
	var _t5327 = env["ctx"]
	var _t5328 = J.add("bold 13px ", env["FONT"])
	J.sp(_t5327, "font", _t5328)
	var _t5329 = env["ctx"]
	J.sp(_t5329, "textAlign", "center")
	var _t5330 = env["crFill"]
	J.cl(_t5330, null, [("揀一棟樓開始今晚" if J.t(v_shopOpen_4619) else "組屋過關（安全返陰間）就解鎖老店屋"), J.div(env["VW"], 2.0), (J.mul(env["VH"], 0.8) + (100.0 if J.t(J.gp(J.G.get("window"), "GP")) else 78.0))])
	J.cl(env["gpTitle"], null, [])

func _f764(this_, a: Array, env):
	var v_g_4662 = null; var v_R0_4663 = null; var v_a_4664 = null; var v_b_4665 = null; var v_E_4666 = null; var v_t_4667 = null
	v_g_4662 = J.arg(a, 0)
	v_R0_4663 = J.arg(a, 1)
	var _t5331 = (not J.t(v_g_4662))
	var _t5332 = (_t5331 if _t5331 else (not J.t(J.gp(v_g_4662, "to"))))
	var _t5333 = (_t5332 if _t5332 else J.gp(v_g_4662, "home"))
	if J.t((_t5333 if J.t(_t5333) else J.gp(v_g_4662, "out"))):
		return null
	v_a_4664 = J.gp(J.gp(env["G"], "nodes"), J.gp(v_g_4662, "node"))
	v_b_4665 = J.gp(J.gp(env["G"], "nodes"), J.gp(v_g_4662, "to"))
	v_E_4666 = J.hypot_([J.sub(J.gp(v_b_4665, "x"), J.gp(v_a_4664, "x")), J.sub(J.gp(v_b_4665, "y"), J.gp(v_a_4664, "y"))])
	if J.cmp(J.mul(v_E_4666, J.sub(1.0, J.gp(v_g_4662, "p"))), v_R0_4663, "<="):
		var _t5334 = [J.gp(v_g_4662, "to")]
		J.sp(v_g_4662, "auto", _t5334)
	else:
		if J.cmp(J.mul(v_E_4666, J.gp(v_g_4662, "p")), v_R0_4663, "<="):
			v_t_4667 = J.gp(v_g_4662, "node")
			var _t5335 = J.gp(v_g_4662, "to")
			J.sp(v_g_4662, "node", _t5335)
			J.sp(v_g_4662, "to", v_t_4667)
			var _t5336 = J.sub(1.0, J.gp(v_g_4662, "p"))
			J.sp(v_g_4662, "p", _t5336)
			var _t5337 = [v_t_4667]
			J.sp(v_g_4662, "auto", _t5337)

func _f765(this_, a: Array, env):
	var v_e_4670 = null; var v_r_4671 = null
	v_e_4670 = J.arg(a, 0)
	v_r_4671 = J.mc(env["cv"], "getBoundingClientRect", [])
	return {"x": J.sub(J.gp(v_e_4670, "clientX"), J.gp(v_r_4671, "left")), "y": J.sub(J.gp(v_e_4670, "clientY"), J.gp(v_r_4671, "top"))}

func _f766(this_, a: Array, env):
	var v_dx_4674 = null; var v_dy_4675 = null; var v_L_4676 = null
	var _t5338 = (not J.t(env["joy"]))
	if (_t5338 if _t5338 else (not J.t(J.gp(env["joy"], "on")))):
		return null
	v_dx_4674 = J.sub(J.gp(env["joy"], "x"), J.gp(env["joy"], "ox"))
	v_dy_4675 = J.sub(J.gp(env["joy"], "y"), J.gp(env["joy"], "oy"))
	v_L_4676 = J.hypot_([v_dx_4674, v_dy_4675])
	if J.cmp(v_L_4676, env["JR"], ">"):
		var _t5339 = J.mul(v_dx_4674, J.div(env["JR"], v_L_4676))
		v_dx_4674 = _t5339
		var _t5340 = J.mul(v_dy_4675, J.div(env["JR"], v_L_4676))
		v_dy_4675 = _t5340
	return {"x": J.div(v_dx_4674, env["JR"]), "y": J.div(v_dy_4675, env["JR"])}

func _f767(this_, a: Array, env):
	var v_v_4679 = null
	var _t5341 = (not J.t(env["joy"]))
	if (_t5341 if _t5341 else (not J.t(J.gp(env["joy"], "on")))):
		return null
	v_v_4679 = J.cl(env["joyVec"], null, [])
	J.mc(env["ctx"], "setTransform", [env["DPR"], 0.0, 0.0, env["DPR"], 0.0, 0.0])
	J.mc(env["ctx"], "save", [])
	var _t5342 = env["ctx"]
	J.sp(_t5342, "globalAlpha", 0.7)
	var _t5343 = env["crBlit"]
	var _t5345 = env["ctx"]
	var _t5344 = env["crGet"]
	J.cl(_t5343, null, [_t5345, J.cl(_t5344, null, [J.mul(env["JR"], 2.0), J.mul(env["JR"], 2.0), "paper", "ring"]), J.sub(J.gp(env["joy"], "ox"), env["JR"]), J.sub(J.gp(env["joy"], "oy"), env["JR"])])
	var _t5346 = env["ctx"]
	J.sp(_t5346, "globalAlpha", 0.92)
	var _t5347 = env["crBlit"]
	var _t5349 = env["ctx"]
	var _t5348 = env["crGet"]
	J.cl(_t5347, null, [_t5349, J.cl(_t5348, null, [48.0, 48.0, "bone", "ring2"]), J.sub(J.add(J.gp(env["joy"], "ox"), J.mul(J.gp(v_v_4679, "x"), env["JR"])), 24.0), J.sub(J.add(J.gp(env["joy"], "oy"), J.mul(J.gp(v_v_4679, "y"), env["JR"])), 24.0)])
	J.mc(env["ctx"], "restore", [])

func _f768(this_, a: Array, env):
	var v_x_4682 = null; var v_y_4683 = null; var v_best_4684 = null; var v_bd_4685 = null; var v_i_4686 = null; var v_b_4687 = null; var v_d_4688 = null
	v_x_4682 = J.arg(a, 0)
	v_y_4683 = J.arg(a, 1)
	v_best_4684 = null
	v_bd_4685 = 1000000000.0
	v_i_4686 = (J.len(env["buttons"]) - 1.0)
	while true:
		if not J.cmp(v_i_4686, 0.0, ">="): break
		v_b_4687 = J.gp(env["buttons"], v_i_4686)
		var _t5350 = J.cmp(v_x_4682, J.sub(J.gp(v_b_4687, "x"), env["PAD"]), ">=")
		var _t5351 = (J.cmp(v_x_4682, J.add(J.add(J.gp(v_b_4687, "x"), J.gp(v_b_4687, "w")), env["PAD"]), "<=") if _t5350 else _t5350)
		var _t5352 = (J.cmp(v_y_4683, J.sub(J.gp(v_b_4687, "y"), env["PAD"]), ">=") if _t5351 else _t5351)
		if (J.cmp(v_y_4683, J.add(J.add(J.gp(v_b_4687, "y"), J.gp(v_b_4687, "h")), env["PAD"]), "<=") if _t5352 else _t5352):
			var _t5353 = J.cmp(v_x_4682, J.gp(v_b_4687, "x"), ">=")
			var _t5354 = (J.cmp(v_x_4682, J.add(J.gp(v_b_4687, "x"), J.gp(v_b_4687, "w")), "<=") if _t5353 else _t5353)
			var _t5355 = (J.cmp(v_y_4683, J.gp(v_b_4687, "y"), ">=") if _t5354 else _t5354)
			v_d_4688 = ((-1.0) if (J.cmp(v_y_4683, J.add(J.gp(v_b_4687, "y"), J.gp(v_b_4687, "h")), "<=") if _t5355 else _t5355) else J.hypot_([J.sub(v_x_4682, J.add(J.gp(v_b_4687, "x"), J.div(J.gp(v_b_4687, "w"), 2.0))), J.sub(v_y_4683, J.add(J.gp(v_b_4687, "y"), J.div(J.gp(v_b_4687, "h"), 2.0)))]))
			if J.cmp(v_d_4688, v_bd_4685, "<"):
				v_bd_4685 = v_d_4688
				v_best_4684 = v_b_4687
		v_i_4686 = J.num(v_i_4686) + -1.0
	return v_best_4684

func _f769(this_, a: Array, env):
	var v_x_4691 = null; var v_y_4692 = null; var v_b_4693 = null
	v_x_4691 = J.arg(a, 0)
	v_y_4692 = J.arg(a, 1)
	var _t5356 = {"x": v_x_4691, "y": v_y_4692}
	env["LASTP"] = _t5356
	var _t5357 = env["hitBtn"]
	v_b_4693 = J.cl(_t5357, null, [v_x_4691, v_y_4692])
	if J.t(v_b_4693):
		var _t5358 = env["press"]
		J.cl(_t5358, null, [J.gp(v_b_4693, "id")])
		return null
	var _t5359 = J.seq(env["scene"], "play")
	var _t5360 = (env["G"] if _t5359 else _t5359)
	var _t5361 = ((not J.t(J.gp(env["G"], "over"))) if J.t(_t5360) else _t5360)
	var _t5362 = ((not J.t(J.gp(env["G"], "choice"))) if J.t(_t5361) else _t5361)
	var _t5363 = ((not J.t(J.gp(env["G"], "showStory"))) if J.t(_t5362) else _t5362)
	var _t5364 = (J.cmp(v_y_4692, env["TOP"], ">") if J.t(_t5363) else _t5363)
	if J.t((J.cmp(v_y_4692, J.sub(env["VH"], env["BOT"]), "<") if J.t(_t5364) else _t5364)):
		var _t5365 = env["worldTap"]
		J.cl(_t5365, null, [v_x_4691, v_y_4692])

func _f771(this_, a: Array, env):
	var v_g_4715 = null; var v_i_4716 = null; var v_d_4717 = null
	v_g_4715 = J.arg(a, 0)
	v_i_4716 = J.arg(a, 1)
	var _t5367 = J.gp(v_g_4715, "home")
	var _t5368 = (_t5367 if J.t(_t5367) else J.gp(v_g_4715, "out"))
	if J.t((_t5368 if J.t(_t5368) else J.seq(v_i_4716, J.gp(env["__p"]["G"], "active")))):
		return null
	v_d_4717 = J.hypot_([J.sub(J.gp(v_g_4715, "x"), env["wx"]), J.sub(J.sub(J.gp(v_g_4715, "y"), J.mul(J.gp(J.gp(v_g_4715, "d"), "h"), 0.5)), env["wy"])])
	if J.cmp(v_d_4717, env["gbd"], "<"):
		env["gbd"] = v_d_4717
		var _t5369 = {"g": v_i_4716}
		env["gb"] = _t5369

func _f772(this_, a: Array, env):
	var v_r_4720 = null; var v_d_4721 = null
	v_r_4720 = J.arg(a, 0)
	if (not J.seq(J.gp(v_r_4720, "state"), "home")):
		return null
	v_d_4721 = J.hypot_([J.sub(J.gp(v_r_4720, "x"), env["wx"]), J.sub(J.sub(J.gp(v_r_4720, "y"), 26.0), env["wy"])])
	if J.cmp(v_d_4721, env["bd"], "<"):
		env["bd"] = v_d_4721
		var _t5371 = {"r": v_r_4720}
		env["best"] = _t5371

func _f773(this_, a: Array, env):
	var v_h_4724 = null; var v_d_4725 = null
	v_h_4724 = J.arg(a, 0)
	var _t5373 = J.seq(J.gp(v_h_4724, "state"), "gone")
	if (_t5373 if _t5373 else J.seq(J.gp(v_h_4724, "state"), "flee")):
		return null
	v_d_4725 = J.hypot_([J.sub(J.gp(v_h_4724, "x"), env["wx"]), J.sub(J.sub(J.gp(v_h_4724, "y"), 30.0), env["wy"])])
	if J.cmp(v_d_4725, env["bd"], "<"):
		env["bd"] = v_d_4725
		var _t5374 = {"h": v_h_4724}
		env["best"] = _t5374

func _f770(this_, a: Array, env):
	var v_x_4696 = null; var v_y_4697 = null; var v_S_4698 = null; var v_g_4705 = null; var v_nn_4706 = null; var v_nd_4707 = null; var v_k_4708 = null; var v_n_4709 = null; var v_d_4710 = null; var v_un_4711 = null; var v_hn_4712 = null
	var _s1954 = {"__p": env, "wx": null, "wy": null, "best": null, "bd": null, "gb": null, "gbd": null}
	v_x_4696 = J.arg(a, 0)
	v_y_4697 = J.arg(a, 1)
	v_S_4698 = J.mul(J.gp(_s1954["__p"]["cam"], "s"), J.gp(_s1954["__p"]["cam"], "z"))
	_s1954["wx"] = J.add(J.div(v_x_4696, v_S_4698), J.gp(_s1954["__p"]["cam"], "x"))
	_s1954["wy"] = J.add(J.div(J.sub(v_y_4697, _s1954["__p"]["TOP"]), v_S_4698), J.gp(_s1954["__p"]["cam"], "y"))
	_s1954["best"] = null
	_s1954["bd"] = 40.0
	if J.t((J.mc(_s1954["__p"]["UNIT"], "worldTap", [_s1954["wx"], _s1954["wy"]]) if J.t(_s1954["__p"]["UNIT"]) else _s1954["__p"]["UNIT"])):
		return null
	_s1954["gb"] = null
	_s1954["gbd"] = 26.0
	var _t5366 = J.gp(_s1954["__p"]["G"], "gh")
	J.mc(_t5366, "forEach", [Callable(self, "_f771").bind(_s1954)])
	var _t5370 = J.gp(_s1954["__p"]["G"], "res")
	J.mc(_t5370, "forEach", [Callable(self, "_f772").bind(_s1954)])
	var _t5372 = J.gp(_s1954["__p"]["G"], "guards")
	J.mc(_t5372, "forEach", [Callable(self, "_f773").bind(_s1954)])
	var _t5375 = (not J.t(_s1954["best"]))
	if J.t((_s1954["gb"] if _t5375 else _t5375)):
		_s1954["best"] = _s1954["gb"]
	v_g_4705 = J.gp(J.gp(_s1954["__p"]["G"], "gh"), J.gp(_s1954["__p"]["G"], "active"))
	if (not J.t(_s1954["best"])):
		v_nn_4706 = null
		v_nd_4707 = 1000000000.0
		for _t5376 in J.keys(J.gp(_s1954["__p"]["G"], "nodes")):
			v_k_4708 = _t5376
			v_n_4709 = J.gp(J.gp(_s1954["__p"]["G"], "nodes"), v_k_4708)
			v_d_4710 = (absf(J.num(J.sub(J.gp(v_n_4709, "x"), _s1954["wx"]))) + (absf(J.num(J.sub(J.sub(J.gp(v_n_4709, "y"), 30.0), _s1954["wy"]))) * 1.6))
			if J.cmp(v_d_4710, v_nd_4707, "<"):
				v_nd_4707 = v_d_4710
				v_nn_4706 = v_k_4708
		if J.t((J.cmp(v_nd_4707, 120.0, "<") if J.t(v_nn_4706) else v_nn_4706)):
			var _t5377 = _s1954["__p"]["gotoNode"]
			if J.t(J.cl(_t5377, null, [v_g_4705, v_nn_4706])):
				J.sp(v_g_4705, "autoS", null)
				var _t5378 = _s1954["__p"]["float"]
				J.cl(_t5378, null, [J.gp(J.gp(J.gp(_s1954["__p"]["G"], "nodes"), v_nn_4706), "x"), J.sub(J.gp(J.gp(J.gp(_s1954["__p"]["G"], "nodes"), v_nn_4706), "y"), 70.0), "去呢度", "#9fd6bf"])
			else:
				var _t5379 = _s1954["__p"]["float"]
				J.cl(_t5379, null, [_s1954["wx"], _s1954["wy"], "去唔到", "#ffb0b0"])
		return null
	if (not J.leq(J.gp(_s1954["best"], "g"), null)):
		var _t5380 = _s1954["__p"]["G"]
		var _t5381 = J.gp(_s1954["best"], "g")
		J.sp(_t5380, "active", _t5381)
		var _t5382 = _s1954["__p"]["cam"]
		J.sp(_t5382, "free", null)
		return null
	if J.t(J.gp(_s1954["best"], "r")):
		v_un_4711 = J.gp(J.gp(_s1954["best"], "r"), "unit")
		var _t5383 = (not J.t(J.gp(v_un_4711, "open")))
		if ((not J.seq(J.gp(v_un_4711, "ot"), 1.0)) if _t5383 else _t5383):
			var _t5384 = _s1954["__p"]["float"]
			J.cl(_t5384, null, [J.gp(J.gp(_s1954["best"], "r"), "x"), J.sub(J.gp(J.gp(_s1954["best"], "r"), "y"), 80.0), "呢戶未入得", "#ffd54a"])
			return null
		var _t5385 = J.seq(J.gp(v_g_4705, "node"), J.gp(v_un_4711, "id"))
		if ((not J.t(J.gp(v_g_4705, "to"))) if _t5385 else _t5385):
			var _t5386 = J.max_([J.gp(v_g_4705, "still"), 0.11])
			J.sp(v_g_4705, "still", _t5386)
			J.cl(_s1954["__p"]["scarePress"], null, [])
			return null
		var _t5387 = _s1954["__p"]["gotoNode"]
		if J.t(J.cl(_t5387, null, [v_g_4705, J.gp(v_un_4711, "id")])):
			var _t5388 = {"r": J.gp(_s1954["best"], "r")}
			J.sp(v_g_4705, "autoS", _t5388)
			var _t5389 = _s1954["__p"]["float"]
			J.cl(_t5389, null, [J.gp(J.gp(_s1954["best"], "r"), "x"), J.sub(J.gp(J.gp(_s1954["best"], "r"), "y"), 86.0), J.add("目標：", (J.gp(J.gp(_s1954["__p"]["HH"], J.gp(J.gp(_s1954["best"], "r"), "hh")), "n") if J.t(J.gp(_s1954["__p"]["HH"], J.gp(J.gp(_s1954["best"], "r"), "hh"))) else "住戶")), "#ffb7a0"])
		else:
			var _t5390 = _s1954["__p"]["float"]
			J.cl(_t5390, null, [J.gp(J.gp(_s1954["best"], "r"), "x"), J.sub(J.gp(J.gp(_s1954["best"], "r"), "y"), 80.0), "去唔到（要先開門／破鎮宅）", "#ffb0b0"])
		return null
	if J.t(J.gp(_s1954["best"], "h")):
		var _t5391 = J.gp(J.gp(_s1954["best"], "h"), "to")
		v_hn_4712 = (J.gp(J.gp(_s1954["best"], "h"), "to") if J.t(((absf(J.num(J.sub(J.gp(J.gp(J.gp(_s1954["__p"]["G"], "nodes"), J.gp(J.gp(_s1954["best"], "h"), "to")), "x"), J.gp(J.gp(_s1954["best"], "h"), "x")))) < absf(J.num(J.sub(J.gp(J.gp(J.gp(_s1954["__p"]["G"], "nodes"), J.gp(J.gp(_s1954["best"], "h"), "node")), "x"), J.gp(J.gp(_s1954["best"], "h"), "x"))))) if J.t(_t5391) else _t5391)) else J.gp(J.gp(_s1954["best"], "h"), "node"))
		var _t5392 = _s1954["__p"]["gotoNode"]
		if J.t(J.cl(_t5392, null, [v_g_4705, v_hn_4712])):
			var _t5393 = {"h": J.gp(_s1954["best"], "h")}
			J.sp(v_g_4705, "autoS", _t5393)
			var _t5394 = _s1954["__p"]["float"]
			J.cl(_t5394, null, [J.gp(J.gp(_s1954["best"], "h"), "x"), J.sub(J.gp(J.gp(_s1954["best"], "h"), "y"), 90.0), J.add("目標：", J.gp(J.gp(_s1954["__p"]["HUM"], J.gp(J.gp(_s1954["best"], "h"), "kind")), "n")), "#ffb7a0"])
		return null

func _f774(this_, a: Array, env):
	var v_id_4728 = null; var v_sv_4729 = null; var v_i_4730 = null
	v_id_4728 = J.arg(a, 0)
	var _t5395 = J.seq(v_id_4728, "lv_flat")
	if (_t5395 if _t5395 else J.seq(v_id_4728, "start")):
		var _t5396 = env["newGame"]
		J.cl(_t5396, null, [null, "flat"])
		J.cl(env["bake"], null, [])
		return null
	if J.seq(v_id_4728, "exit"):
		J.cl(env["close"], null, [])
		return null
	if J.seq(v_id_4728, "quit"):
		env["scene"] = "title"
		return null
	if J.seq(v_id_4728, "lv_shop"):
		v_sv_4729 = J.cl(env["TS"], null, [])
		var _t5397 = J.gp(J.gp(v_sv_4729, "cleared"), "flat")
		var _t5398 = (_t5397 if J.t(_t5397) else J.mc(env["Q"], "has", ["unlock"]))
		if J.t((_t5398 if J.t(_t5398) else J.gp(J.G.get("window"), "STN_TEST"))):
			var _t5399 = env["newGame"]
			J.cl(_t5399, null, [null, "shop"])
			J.cl(env["bake"], null, [])
		return null
	if J.seq(v_id_4728, "again"):
		J.cl(env["newGame"], null, [])
		J.cl(env["bake"], null, [])
		return null
	if J.seq(v_id_4728, "toVillage"):
		J.cl(env["gpGoVillage"], null, [])
		return null
	if J.seq(v_id_4728, "title"):
		env["scene"] = "title"
		return null
	if J.seq(v_id_4728, "toMap"):
		J.cl(env["close"], null, [])
		return null
	if (not J.seq(env["scene"], "play")):
		return null
	if J.seq(J.mc(v_id_4728, "indexOf", ["card"]), 0.0):
		var _t5400 = env["chooseCard"]
		J.cl(_t5400, null, [J.num(J.mc(v_id_4728, "slice", [4.0]))])
		return null
	if J.seq(v_id_4728, "zin"):
		var _t5401 = env["cam"]
		var _t5402 = J.min_([1.5, J.mul(J.gp(env["cam"], "z"), 1.25)])
		J.sp(_t5401, "z", _t5402)
		return null
	if J.seq(v_id_4728, "zout"):
		var _t5403 = env["cam"]
		var _t5404 = J.max_([0.5, J.div(J.gp(env["cam"], "z"), 1.25)])
		J.sp(_t5403, "z", _t5404)
		return null
	if J.seq(v_id_4728, "mini"):
		J.cl(env["miniJump"], null, [])
		return null
	if J.seq(v_id_4728, "follow"):
		var _t5405 = env["cam"]
		J.sp(_t5405, "free", null)
		return null
	if J.seq(v_id_4728, "act"):
		J.cl(env["actPress"], null, [])
		return null
	if J.seq(v_id_4728, "ult"):
		var _t5406 = env["ultPress"]
		J.cl(_t5406, null, [J.gp(env["G"], "active")])
		return null
	if J.seq(v_id_4728, "story"):
		var _t5407 = env["G"]
		J.sp(_t5407, "showStory", true)
		return null
	if J.seq(v_id_4728, "closeStory"):
		var _t5408 = env["G"]
		J.sp(_t5408, "showStory", false)
		return null
	var _t5409 = J.gp(env["G"], "over")
	var _t5410 = (_t5409 if J.t(_t5409) else J.gp(env["G"], "choice"))
	if J.t((_t5410 if J.t(_t5410) else J.gp(env["G"], "showStory"))):
		return null
	if J.seq(J.mc(v_id_4728, "indexOf", ["gh"]), 0.0):
		var _t5411 = env["cam"]
		J.sp(_t5411, "free", null)
		v_i_4730 = J.num(J.mc(v_id_4728, "slice", [2.0]))
		if J.t(J.gp(J.gp(J.gp(env["G"], "gh"), v_i_4730), "home")):
			return null
		var _t5412 = J.seq(v_i_4730, J.gp(env["G"], "active"))
		if (J.cmp(J.gp(J.gp(J.gp(env["G"], "gh"), v_i_4730), "energy"), 100.0, ">=") if _t5412 else _t5412):
			var _t5413 = env["ultPress"]
			J.cl(_t5413, null, [v_i_4730])
			return null
		var _t5414 = env["G"]
		J.sp(_t5414, "active", v_i_4730)
		var _t5415 = env["toast"]
		J.cl(_t5415, null, [(env["GP_TRAINEE_MSG"] if J.t(J.gp(J.gp(J.gp(env["G"], "gh"), v_i_4730), "trainee")) else J.add(J.gp(J.gp(env["GH"], v_i_4730), "tip"), ("（能量滿！再點頭像放大招）" if J.cmp(J.gp(J.gp(J.gp(env["G"], "gh"), v_i_4730), "energy"), 100.0, ">=") else "")))])
		return null
	if J.seq(v_id_4728, "scare"):
		J.cl(env["scarePress"], null, [])
	if J.seq(v_id_4728, "inv"):
		J.cl(env["invPress"], null, [])
	if J.seq(v_id_4728, "gate"):
		J.cl(env["gatePress"], null, [])
	if J.seq(v_id_4728, "doll"):
		J.cl(env["dollEscape"], null, [])

func _f775(this_, a: Array, env):
	var v_ts_4733 = null; var v_dt_4734 = null; var v_v_4735 = null
	v_ts_4733 = J.arg(a, 0)
	if (not J.t(env["OPEN"])):
		env["RAF"] = 0.0
		return null
	var _t5416 = J.F_requestAnimationFrame([env["frame"]])
	env["RAF"] = _t5416
	if (not J.t(env["last"])):
		env["last"] = v_ts_4733
	v_dt_4734 = J.div(J.sub(v_ts_4733, env["last"]), 1000.0)
	if J.cmp(v_dt_4734, J.div(1.0, 31.0), "<"):
		return null
	env["last"] = v_ts_4733
	var _t5417 = J.min_([v_dt_4734, 0.1])
	v_dt_4734 = _t5417
	var _t5418 = J.seq(env["scene"], "play")
	if ((not J.t(J.gp(env["G"], "showStory"))) if _t5418 else _t5418):
		v_v_4735 = J.cl(env["joyVec"], null, [])
		var _t5419 = ((not J.t(J.gp(env["G"], "choice"))) if J.t(v_v_4735) else v_v_4735)
		if J.t(((not J.t(J.gp(env["G"], "over"))) if J.t(_t5419) else _t5419)):
			var _t5420 = J.gp(J.gp(env["G"], "gh"), J.gp(env["G"], "active"))
			J.sp(_t5420, "auto", null)
			var _t5421 = J.gp(J.gp(env["G"], "gh"), J.gp(env["G"], "active"))
			J.sp(_t5421, "autoS", null)
			var _t5422 = env["cam"]
			J.sp(_t5422, "free", null)
			var _t5423 = env["joyMove"]
			J.cl(_t5423, null, [J.gp(J.gp(env["G"], "gh"), J.gp(env["G"], "active")), J.gp(v_v_4735, "x"), J.gp(v_v_4735, "y"), v_dt_4734])
		var _t5424 = env["update"]
		J.cl(_t5424, null, [v_dt_4734])
	if (not J.t((J.mc(env["UNIT"], "covering", []) if J.t(env["UNIT"]) else env["UNIT"]))):
		J.cl(env["draw"], null, [])
		J.cl(env["drawJoy"], null, [])

func _f827(this_, a: Array, env):
	var v_k_4868 = null
	v_k_4868 = J.arg(a, 0)
	var _t5426 = env["__p"]["IMG"]
	var _t5428 = J.G.get("SPR")
	var _t5427 = J.gp(env["M"], v_k_4868)
	var _t5429 = J.gp(_t5428, (_t5427 if J.t(_t5427) else v_k_4868))
	J.sp(_t5426, v_k_4868, _t5429)

func _f826(this_, a: Array, env):
	var _s2051 = {"__p": env, "M": null}
	_s2051["M"] = {"flatbg": "bg_tw_flat", "shopbg": "bg_tw_shop"}
	var _t5425 = ["res_gamer_scared", "res_uncle_scared", "res_granny_scared", "res_helper_scared", "res_mjaunty_scared", "res_shopper_scared", "res_collector_scared", "res_guard_scared", "res_ot_scared", "res_gym_scared", "eguiking", "toyol", "tianhua", "tianhua_hang", "npc_ken", "npc_auntie", "npc_guard", "npc_it", "npc_mis", "npc_boss", "npc_it_sit", "npc_ken_sit", "res_gamer", "res_uncle", "res_granny", "res_helper", "res_mjaunty", "res_shopper", "res_collector", "res_guard", "res_ot", "res_gym", "room_mahjong", "room_gamer", "room_nurse", "room_helper", "room_gym", "room_shopper", "room_carpark", "room_lobby", "flatbg", "shopbg", "gb_unit_ppr", "gb_unit_gamer", "gb_unit_shop"]
	J.mc(_t5425, "forEach", [Callable(self, "_f827").bind(_s2051)])

func _f828(this_, a: Array, env):
	var v_e_4871 = null; var v_e_4872 = null
	J.cl(env["loadImgs"], null, [])
	J.cl(env["TS"], null, [])
	var _t5430 = J.gp(env["ROOT"], "classList")
	J.mc(_t5430, "add", ["on"])
	env["OPEN"] = true
	env["scene"] = "title"
	J.cl(env["resize"], null, [])
	env["last"] = 0.0
	if (not J.t(env["RAF"])):
		var _t5431 = J.F_requestAnimationFrame([env["frame"]])
		env["RAF"] = _t5431
	if J.t(J.gp(J.G.get("Sound"), "setMode")):
		J.mc(J.G.get("Sound"), "setMode", ["story"])
	var _t5432 = J.gp(J.G.get("window"), "Policy")
	if J.t((J.gp(J.G.get("Policy"), "firstEnter") if J.t(_t5432) else _t5432)):
		J.mc(J.G.get("Policy"), "firstEnter", ["tower"])

func _f829(this_, a: Array, env):
	var v_e_4875 = null
	env["OPEN"] = false
	var _t5433 = J.gp(env["ROOT"], "classList")
	J.mc(_t5433, "remove", ["on"])
	env["joy"] = null
	env["ptr"] = null
	J.cl(J.G.get("save"), null, [])
	if J.t(J.gp(J.G.get("Sound"), "setMode")):
		J.mc(J.G.get("Sound"), "setMode", ["village"])
	if (not J.seq(J.typeof_(J.G.get("World")), "undefined")):
		J.mc(J.G.get("World"), "open", [])

func _f452(this_, a: Array, env):
	var v_k_2803 = null; var v_i_2804 = null
	v_k_2803 = J.arg(a, 0)
	v_i_2804 = (J.gp(env["__p"]["IMG"], v_k_2803) if J.t(v_k_2803) else v_k_2803)
	return (v_i_2804 if J.t((J.gp(v_i_2804, "width") if J.t(v_i_2804) else v_i_2804)) else null)

func _f453(this_, a: Array, env):
	var v_k_2807 = null
	v_k_2807 = J.arg(a, 0)
	var _t5442 = (not (not J.t(v_k_2807)))
	var _t5444 = (J.seq(J.mc(v_k_2807, "indexOf", ["res_"]), 0.0) if _t5442 else _t5442)
	if J.t(_t5444):
		var _t5443 = env["im"]
		_t5444 = (not (not J.t(J.cl(_t5443, null, [J.add(v_k_2807, "_scared")]))))
	return _t5444

func _f454(this_, a: Array, env):
	var v_k_2810 = null; var v_scared_2811 = null
	v_k_2810 = J.arg(a, 0)
	v_scared_2811 = J.arg(a, 1)
	var _t5446 = v_scared_2811
	if J.t(_t5446):
		var _t5445 = env["hasScared"]
		_t5446 = J.cl(_t5445, null, [v_k_2810])
	return (J.add(v_k_2810, "_scared") if J.t(_t5446) else v_k_2810)

func _f455(this_, a: Array, env):
	var v_k_2814 = null; var v_i_2815 = null
	v_k_2814 = J.arg(a, 0)
	var _t5447 = env["im"]
	v_i_2815 = J.cl(_t5447, null, [v_k_2814])
	var _t5448 = (not (not J.t(v_i_2815)))
	return ((J.div(J.gp(v_i_2815, "width"), J.gp(v_i_2815, "height")) >= 0.42) if _t5448 else _t5448)

func _f456(this_, a: Array, env):
	var v_base_2818 = null; var v_k2_2819 = null; var v_h_2820 = null; var v_m_2821 = null
	v_base_2818 = J.arg(a, 0)
	v_k2_2819 = J.arg(a, 1)
	v_h_2820 = J.arg(a, 2)
	v_m_2821 = J.gp(env["__p"]["PPL_META"], v_base_2818)
	var _t5449 = env["chibi"]
	var _t5452 = J.mul(v_h_2820, (env["CHIBI_K"] if J.t(J.cl(_t5449, null, [v_base_2818])) else 1.0))
	var _t5450 = (not J.seq(v_k2_2819, v_base_2818))
	var _t5451 = (v_m_2821 if _t5450 else _t5450)
	return J.mul(_t5452, (J.gp(J.gp(v_m_2821, "s"), "k") if J.t((J.gp(v_m_2821, "s") if J.t(_t5451) else _t5451)) else 1.0))

func _f457(this_, a: Array, env):
	var v_base_2824 = null; var v_k2_2825 = null; var v_m_2826 = null
	v_base_2824 = J.arg(a, 0)
	v_k2_2825 = J.arg(a, 1)
	v_m_2826 = J.gp(env["__p"]["PPL_META"], v_base_2824)
	if (not J.t(v_m_2826)):
		return 0.0
	var _t5457 = null
	if (not J.seq(v_k2_2825, v_base_2824)):
		var _t5453 = J.gp(v_m_2826, "s")
		var _t5454 = (J.gp(J.gp(v_m_2826, "s"), "foot") if J.t(_t5453) else _t5453)
		_t5457 = (_t5454 if J.t(_t5454) else 0.0)
	else:
		var _t5455 = J.gp(v_m_2826, "n")
		var _t5456 = (J.gp(J.gp(v_m_2826, "n"), "foot") if J.t(_t5455) else _t5455)
		_t5457 = (_t5456 if J.t(_t5456) else 0.0)
	return _t5457

func _f458(this_, a: Array, env):
	var v_k_2829 = null; var v_i_2830 = null; var v_c_2831 = null; var v_s_2832 = null; var v_x_2833 = null
	v_k_2829 = J.arg(a, 0)
	var _t5458 = env["im"]
	v_i_2830 = J.cl(_t5458, null, [v_k_2829])
	if (not J.t(v_i_2830)):
		return null
	v_c_2831 = J.gp(env["TC"], v_k_2829)
	if J.t((J.seq(J.gp(v_c_2831, "_src"), v_i_2830) if J.t(v_c_2831) else v_c_2831)):
		return v_c_2831
	var _t5459 = J.S_document_("createElement", ["canvas"])
	v_c_2831 = _t5459
	v_s_2832 = J.min_([1.0, J.div(220.0, J.gp(v_i_2830, "height"))])
	var _t5460 = J.max_([1.0, J.round(J.num(J.mul(J.gp(v_i_2830, "width"), v_s_2832)))])
	J.sp(v_c_2831, "width", _t5460)
	var _t5461 = J.max_([1.0, J.round(J.num(J.mul(J.gp(v_i_2830, "height"), v_s_2832)))])
	J.sp(v_c_2831, "height", _t5461)
	v_x_2833 = J.mc(v_c_2831, "getContext", ["2d"])
	J.mc(v_x_2833, "drawImage", [v_i_2830, 0.0, 0.0, J.gp(v_c_2831, "width"), J.gp(v_c_2831, "height")])
	J.sp(v_x_2833, "globalCompositeOperation", "source-atop")
	J.sp(v_x_2833, "fillStyle", "rgb(178,222,236)")
	J.mc(v_x_2833, "fillRect", [0.0, 0.0, J.gp(v_c_2831, "width"), J.gp(v_c_2831, "height")])
	J.sp(v_c_2831, "_src", v_i_2830)
	var _t5462 = env["TC"]
	J.sp(_t5462, v_k_2829, v_c_2831)
	return v_c_2831

func _f459(this_, a: Array, env):
	var v_c2_2836 = null; var v_i_2837 = null; var v_x_2838 = null; var v_y_2839 = null; var v_h_2840 = null; var v_o_2841 = null; var v_w_2842 = null
	v_c2_2836 = J.arg(a, 0)
	v_i_2837 = J.arg(a, 1)
	v_x_2838 = J.arg(a, 2)
	v_y_2839 = J.arg(a, 3)
	v_h_2840 = J.arg(a, 4)
	v_o_2841 = J.arg(a, 5)
	v_w_2842 = J.div(J.mul(v_h_2840, J.gp(v_i_2837, "width")), J.gp(v_i_2837, "height"))
	J.mc(v_c2_2836, "save", [])
	var _t5463 = (1.0 if J.leq(J.gp(v_o_2841, "alpha"), null) else J.gp(v_o_2841, "alpha"))
	J.sp(v_c2_2836, "globalAlpha", _t5463)
	J.mc(v_c2_2836, "translate", [v_x_2838, v_y_2839])
	if J.t(J.gp(v_o_2841, "rot")):
		J.mc(v_c2_2836, "rotate", [J.gp(v_o_2841, "rot")])
	var _t5465 = ((-1.0) if J.t(J.gp(v_o_2841, "flip")) else 1.0)
	var _t5464 = J.gp(v_o_2841, "sx")
	var _t5467 = J.mul(_t5465, (_t5464 if J.t(_t5464) else 1.0))
	var _t5466 = J.gp(v_o_2841, "sy")
	J.mc(v_c2_2836, "scale", [_t5467, (_t5466 if J.t(_t5466) else 1.0)])
	J.mc(v_c2_2836, "drawImage", [v_i_2837, J.div((-J.num(v_w_2842)), 2.0), (-J.num(v_h_2840)), v_w_2842, v_h_2840])
	J.mc(v_c2_2836, "restore", [])

func _f460(this_, a: Array, env):
	var v_c2_2845 = null; var v_base_2846 = null; var v_k2_2847 = null; var v_x_2848 = null; var v_y_2849 = null; var v_h_2850 = null; var v_o_2851 = null; var v_i_2852 = null; var v_fy0_2853 = null; var v_t_2854 = null; var v_sb_2855 = null
	v_c2_2845 = J.arg(a, 0)
	v_base_2846 = J.arg(a, 1)
	v_k2_2847 = J.arg(a, 2)
	v_x_2848 = J.arg(a, 3)
	v_y_2849 = J.arg(a, 4)
	v_h_2850 = J.arg(a, 5)
	v_o_2851 = J.arg(a, 6)
	var _t5468 = (v_o_2851 if J.t(v_o_2851) else {})
	v_o_2851 = _t5468
	var _t5469 = env["im"]
	v_i_2852 = J.cl(_t5469, null, [v_k2_2847])
	if (not J.t(v_i_2852)):
		return null
	var _t5470 = env["foot"]
	v_fy0_2853 = J.add(v_y_2849, J.mul(J.cl(_t5470, null, [v_base_2846, v_k2_2847]), v_h_2850))
	var _t5471 = env["blit"]
	J.cl(_t5471, null, [v_c2_2845, v_i_2852, v_x_2848, v_fy0_2853, v_h_2850, v_o_2851])
	if J.cmp(J.gp(v_o_2851, "tint"), 0.02, ">"):
		var _t5472 = env["tintCv"]
		v_t_2854 = J.cl(_t5472, null, [v_k2_2847])
		if J.t(v_t_2854):
			v_sb_2855 = J.gp(v_c2_2845, "shadowBlur")
			J.sp(v_c2_2845, "shadowBlur", 0.0)
			var _t5473 = env["blit"]
			J.cl(_t5473, null, [v_c2_2845, v_t_2854, v_x_2848, v_fy0_2853, v_h_2850, {"flip": J.gp(v_o_2851, "flip"), "rot": J.gp(v_o_2851, "rot"), "sx": J.gp(v_o_2851, "sx"), "sy": J.gp(v_o_2851, "sy"), "alpha": J.mul((1.0 if J.leq(J.gp(v_o_2851, "alpha"), null) else J.gp(v_o_2851, "alpha")), J.min_([0.4, J.mul(J.gp(v_o_2851, "tint"), 0.45)]))}])
			J.sp(v_c2_2845, "shadowBlur", v_sb_2855)

func _f461(this_, a: Array, env):
	var v_t_2858 = null; var v_amp_2859 = null; var v_q_2860 = null; var v_a_2861 = null; var v_o_2862 = null; var v_c_2863 = null; var v_c2_2864 = null; var v_c3_2865 = null
	v_t_2858 = J.arg(a, 0)
	v_amp_2859 = J.arg(a, 1)
	v_q_2860 = (1.0 - J.div(v_t_2858, 0.9))
	v_a_2861 = (v_amp_2859 if J.t(v_amp_2859) else 1.0)
	v_o_2862 = {"sx": 1.0, "sy": 1.0, "jy": 0.0, "sh": 0.0, "tint": (0.95 * (1.0 - J.mul(v_q_2860, 0.55)))}
	if J.cmp(v_q_2860, 0.12, "<"):
		v_c_2863 = J.div(v_q_2860, 0.12)
		var _t5474 = (1.0 - J.mul(J.mul(0.22, v_c_2863), v_a_2861))
		J.sp(v_o_2862, "sy", _t5474)
		var _t5475 = (1.0 + J.mul(J.mul(0.16, v_c_2863), v_a_2861))
		J.sp(v_o_2862, "sx", _t5475)
	else:
		if J.cmp(v_q_2860, 0.5, "<"):
			v_c2_2864 = J.div(J.sub(v_q_2860, 0.12), 0.38)
			var _t5476 = J.mul(((-sin(J.num(J.mul(v_c2_2864, PI)))) * 0.3), v_a_2861)
			J.sp(v_o_2862, "jy", _t5476)
			var _t5477 = (1.0 + J.mul((0.17 * J.sub(1.0, v_c2_2864)), v_a_2861))
			J.sp(v_o_2862, "sy", _t5477)
			var _t5478 = (1.0 - J.mul((0.11 * J.sub(1.0, v_c2_2864)), v_a_2861))
			J.sp(v_o_2862, "sx", _t5478)
		else:
			v_c3_2865 = J.div(J.sub(v_q_2860, 0.5), 0.5)
			var _t5479 = (1.0 - J.mul(((0.07 * sin(J.num(J.mul(v_c3_2865, PI)))) * J.sub(1.0, v_c3_2865)), v_a_2861))
			J.sp(v_o_2862, "sy", _t5479)
			var _t5480 = (1.0 + J.mul(((0.05 * sin(J.num(J.mul(v_c3_2865, PI)))) * J.sub(1.0, v_c3_2865)), v_a_2861))
			J.sp(v_o_2862, "sx", _t5480)
			var _t5481 = ((sin(J.num((J.div(J.S_performance_("now", []), 1000.0) * 62.0))) * 0.032) * J.sub(1.0, v_c3_2865))
			J.sp(v_o_2862, "sh", _t5481)
	return v_o_2862

func _f462(this_, a: Array, env):
	var v_r_2868 = null; var v_t_2869 = null; var v_ph_2870 = null
	v_r_2868 = J.arg(a, 0)
	v_t_2869 = J.arg(a, 1)
	var _t5482 = J.gp(v_r_2868, "x")
	v_ph_2870 = floor(J.num(J.mul(J.add(v_t_2869, J.mod((_t5482 if J.t(_t5482) else 0.0), 5.0)), 1.15)))
	var _t5484 = J.mul(v_t_2869, 47.0)
	var _t5483 = J.gp(v_r_2868, "x")
	return {"sh": (sin(J.num(J.add(_t5484, (_t5483 if J.t(_t5483) else 0.0)))) * 0.018), "sy": 0.93, "flip": (null if J.seq(J.mod(v_ph_2870, 3.0), 2.0) else J.seq(J.mod(v_ph_2870, 3.0), 1.0)), "tint": 0.16}

func _f463(this_, a: Array, env):
	var v_c2_2873 = null; var v_x_2874 = null; var v_y_2875 = null; var v_q_2876 = null; var v_s_2877 = null; var v_pop_2878 = null; var v_al_2879 = null; var v_i_2880 = null; var v_an_2881 = null; var v_an2_2882 = null
	v_c2_2873 = J.arg(a, 0)
	v_x_2874 = J.arg(a, 1)
	v_y_2875 = J.arg(a, 2)
	v_q_2876 = J.arg(a, 3)
	v_s_2877 = J.arg(a, 4)
	var _t5485 = (v_s_2877 if J.t(v_s_2877) else 1.0)
	v_s_2877 = _t5485
	v_pop_2878 = (1.0 + (0.7 * J.max_([0.0, (1.0 - J.div(v_q_2876, 0.16))])))
	v_al_2879 = (J.max_([0.0, J.div(J.sub(1.0, v_q_2876), 0.2)]) if J.cmp(v_q_2876, 0.8, ">") else 1.0)
	J.mc(v_c2_2873, "save", [])
	J.sp(v_c2_2873, "globalAlpha", v_al_2879)
	J.mc(v_c2_2873, "translate", [v_x_2874, v_y_2875])
	J.mc(v_c2_2873, "rotate", [(-0.12)])
	J.mc(v_c2_2873, "scale", [J.mul(v_pop_2878, v_s_2877), J.mul(v_pop_2878, v_s_2877)])
	var _t5486 = J.add("900 22px ", env["__p"]["FONT"])
	J.sp(v_c2_2873, "font", _t5486)
	J.sp(v_c2_2873, "textAlign", "center")
	J.sp(v_c2_2873, "lineJoin", "round")
	J.sp(v_c2_2873, "lineWidth", 5.0)
	J.sp(v_c2_2873, "strokeStyle", "#160c10")
	J.mc(v_c2_2873, "strokeText", ["!!", 0.0, 0.0])
	J.sp(v_c2_2873, "fillStyle", "#ffe25a")
	J.mc(v_c2_2873, "fillText", ["!!", 0.0, 0.0])
	J.sp(v_c2_2873, "strokeStyle", "#ffe25a")
	J.sp(v_c2_2873, "lineWidth", 2.0)
	v_i_2880 = 0.0
	while true:
		if not J.cmp(v_i_2880, 3.0, "<"): break
		v_an_2881 = ((-2.5) + J.mul(v_i_2880, 0.5))
		J.mc(v_c2_2873, "beginPath", [])
		J.mc(v_c2_2873, "moveTo", [((cos(J.num(v_an_2881)) * 15.0) - 2.0), ((sin(J.num(v_an_2881)) * 15.0) - 8.0)])
		J.mc(v_c2_2873, "lineTo", [((cos(J.num(v_an_2881)) * 22.0) - 2.0), ((sin(J.num(v_an_2881)) * 22.0) - 8.0)])
		J.mc(v_c2_2873, "stroke", [])
		v_an2_2882 = ((-0.65) - J.mul(v_i_2880, 0.5))
		J.mc(v_c2_2873, "beginPath", [])
		J.mc(v_c2_2873, "moveTo", [((cos(J.num(v_an2_2882)) * 15.0) + 2.0), ((sin(J.num(v_an2_2882)) * 15.0) - 8.0)])
		J.mc(v_c2_2873, "lineTo", [((cos(J.num(v_an2_2882)) * 22.0) + 2.0), ((sin(J.num(v_an2_2882)) * 22.0) - 8.0)])
		J.mc(v_c2_2873, "stroke", [])
		v_i_2880 = J.num(v_i_2880) + 1.0
	J.mc(v_c2_2873, "restore", [])

func _f464(this_, a: Array, env):
	var v_c2_2885 = null; var v_x_2886 = null; var v_y_2887 = null; var v_h_2888 = null; var v_dir_2889 = null; var v_t_2890 = null; var v_sh_2891 = null; var v_s_2892 = null; var v_w_2893 = null; var v_hx_2894 = null; var v_hy_2895 = null; var v_sx0_2896 = null
	v_c2_2885 = J.arg(a, 0)
	v_x_2886 = J.arg(a, 1)
	v_y_2887 = J.arg(a, 2)
	v_h_2888 = J.arg(a, 3)
	v_dir_2889 = J.arg(a, 4)
	v_t_2890 = J.arg(a, 5)
	v_sh_2891 = J.sub(v_y_2887, J.mul(v_h_2888, 0.5))
	J.mc(v_c2_2885, "save", [])
	J.sp(v_c2_2885, "lineCap", "round")
	v_s_2892 = (-1.0)
	while true:
		if not J.cmp(v_s_2892, 1.0, "<="): break
		v_w_2893 = (J.mul(sin(J.num(J.add(J.mul(v_t_2890, 19.0), v_s_2892))), v_h_2888) * 0.035)
		v_hx_2894 = J.add(J.add(v_x_2886, (J.mul(v_s_2892, v_h_2888) * 0.3)), v_w_2893)
		v_hy_2895 = (J.sub(v_y_2887, J.mul(v_h_2888, 0.97)) + (J.mul(cos(J.num(J.add(J.mul(v_t_2890, 19.0), v_s_2892))), v_h_2888) * 0.02))
		v_sx0_2896 = J.add(v_x_2886, (J.mul(v_s_2892, v_h_2888) * 0.12))
		J.sp(v_c2_2885, "strokeStyle", "#1a1214")
		var _t5487 = J.max_([3.0, J.mul(v_h_2888, 0.075)])
		J.sp(v_c2_2885, "lineWidth", _t5487)
		J.mc(v_c2_2885, "beginPath", [])
		J.mc(v_c2_2885, "moveTo", [v_sx0_2896, v_sh_2891])
		J.mc(v_c2_2885, "lineTo", [v_hx_2894, v_hy_2895])
		J.mc(v_c2_2885, "stroke", [])
		J.sp(v_c2_2885, "strokeStyle", "#f0c8a4")
		var _t5488 = J.max_([1.6, J.mul(v_h_2888, 0.045)])
		J.sp(v_c2_2885, "lineWidth", _t5488)
		J.mc(v_c2_2885, "beginPath", [])
		J.mc(v_c2_2885, "moveTo", [v_sx0_2896, v_sh_2891])
		J.mc(v_c2_2885, "lineTo", [v_hx_2894, v_hy_2895])
		J.mc(v_c2_2885, "stroke", [])
		J.sp(v_c2_2885, "fillStyle", "#f0c8a4")
		J.sp(v_c2_2885, "strokeStyle", "#1a1214")
		J.sp(v_c2_2885, "lineWidth", 1.5)
		J.mc(v_c2_2885, "beginPath", [])
		J.mc(v_c2_2885, "arc", [v_hx_2894, v_hy_2895, J.max_([2.5, J.mul(v_h_2888, 0.05)]), 0.0, 7.0])
		J.mc(v_c2_2885, "fill", [])
		J.mc(v_c2_2885, "stroke", [])
		var _t5489 = J.add(v_s_2892, 2.0)
		v_s_2892 = _t5489
	J.mc(v_c2_2885, "restore", [])

func _f465(this_, a: Array, env):
	var v_c2_2899 = null; var v_x_2900 = null; var v_y_2901 = null; var v_sc_2902 = null; var v_s_2903 = null; var v_u_2904 = null; var v_yy_2905 = null
	v_c2_2899 = J.arg(a, 0)
	v_x_2900 = J.arg(a, 1)
	v_y_2901 = J.arg(a, 2)
	v_sc_2902 = J.arg(a, 3)
	v_s_2903 = J.arg(a, 4)
	if (not J.t(v_sc_2902)):
		return null
	var _t5490 = (v_s_2903 if J.t(v_s_2903) else 1.0)
	v_s_2903 = _t5490
	v_u_2904 = (1.0 - J.div(J.gp(v_sc_2902, "T"), 1.9))
	J.mc(v_c2_2899, "save", [])
	var _t5491 = J.min_([1.0, J.div(J.gp(v_sc_2902, "T"), 0.45)])
	J.sp(v_c2_2899, "globalAlpha", _t5491)
	var _t5492 = J.add((J.add("900 ", J.round(J.num(J.mul(14.0, v_s_2903)))) + "px "), env["__p"]["FONT"])
	J.sp(v_c2_2899, "font", _t5492)
	J.sp(v_c2_2899, "textAlign", "center")
	J.sp(v_c2_2899, "lineJoin", "round")
	J.sp(v_c2_2899, "lineWidth", 4.0)
	J.sp(v_c2_2899, "strokeStyle", "#14080a")
	v_yy_2905 = J.sub(v_y_2901, J.mul(J.mul(v_u_2904, 22.0), v_s_2903))
	J.mc(v_c2_2899, "strokeText", [J.gp(v_sc_2902, "t"), v_x_2900, v_yy_2905])
	J.sp(v_c2_2899, "fillStyle", "#ff9a86")
	J.mc(v_c2_2899, "fillText", [J.gp(v_sc_2902, "t"), v_x_2900, v_yy_2905])
	J.mc(v_c2_2899, "restore", [])

func _f466(this_, a: Array, env):
	var _t5493 = env["__p"]["uniq"]
	return J.cl(_t5493, null, [env["__p"]["SCREAM"]])

func _f467(this_, a: Array, env):
	var v_o_2910 = null
	v_o_2910 = J.arg(a, 0)
	var _t5494 = env["__p"]["pplScream"]
	J.cl(_t5494, null, [v_o_2910])

func _f451(this_, a: Array, env):
	var v_key_2788 = null; var v_hgt_2790 = null; var v_draw_2794 = null; var v_shock_2795 = null; var v_tremble_2796 = null; var v_bang_2797 = null; var v_arms_2798 = null; var v_scream_2799 = null; var v_uq_2800 = null
	var _s1056 = {"__p": env, "CHIBI_K": null, "TC": null, "im": null, "hasScared": null, "chibi": null, "foot": null, "tintCv": null, "blit": null}
	_s1056["im"] = Callable(self, "_f452").bind(_s1056)
	_s1056["hasScared"] = Callable(self, "_f453").bind(_s1056)
	v_key_2788 = Callable(self, "_f454").bind(_s1056)
	_s1056["chibi"] = Callable(self, "_f455").bind(_s1056)
	v_hgt_2790 = Callable(self, "_f456").bind(_s1056)
	_s1056["foot"] = Callable(self, "_f457").bind(_s1056)
	_s1056["tintCv"] = Callable(self, "_f458").bind(_s1056)
	_s1056["blit"] = Callable(self, "_f459").bind(_s1056)
	v_draw_2794 = Callable(self, "_f460").bind(_s1056)
	v_shock_2795 = Callable(self, "_f461").bind(_s1056)
	v_tremble_2796 = Callable(self, "_f462").bind(_s1056)
	v_bang_2797 = Callable(self, "_f463").bind(_s1056)
	v_arms_2798 = Callable(self, "_f464").bind(_s1056)
	v_scream_2799 = Callable(self, "_f465").bind(_s1056)
	v_uq_2800 = Callable(self, "_f466").bind(_s1056)
	_s1056["CHIBI_K"] = 1.12
	_s1056["TC"] = {}
	return {"key": v_key_2788, "hasScared": _s1056["hasScared"], "chibi": _s1056["chibi"], "hgt": v_hgt_2790, "foot": _s1056["foot"], "draw": v_draw_2794, "shock": v_shock_2795, "tremble": v_tremble_2796, "bang": v_bang_2797, "arms": v_arms_2798, "scream": v_scream_2799, "screamOn": Callable(self, "_f467").bind(_s1056), "tint": _s1056["tintCv"], "CHIBI_K": _s1056["CHIBI_K"], "uniqScream": v_uq_2800}

func _f623(this_, a: Array, env):
	var v_u_3733 = null
	v_u_3733 = J.arg(a, 0)
	return ("伯伯" if J.seq(J.gp(v_u_3733, "hh"), "elder") else "婆婆")

func _f760(this_, a: Array, env):
	var v_e_4630 = null; var v_p_4631 = null; var v_hb_4632 = null; var v_ids_4633 = null; var v_a_4634 = null; var v_b_4635 = null; var v___4636 = null; var v___4637 = null; var v___4638 = null
	v_e_4630 = J.arg(a, 0)
	if J.t(J.gp(v_e_4630, "isPrimary")):
		var _t5496 = {}
		env["pts"] = _t5496
	var _t5497 = env["pt"]
	v_p_4631 = J.cl(_t5497, null, [v_e_4630])
	var _t5498 = env["pts"]
	var _t5499 = J.gp(v_e_4630, "pointerId")
	J.sp(_t5498, _t5499, v_p_4631)
	var _t5500 = env["hitBtn"]
	v_hb_4632 = J.cl(_t5500, null, [J.gp(v_p_4631, "x"), J.gp(v_p_4631, "y")])
	if J.t(v_hb_4632):
		var _t5501 = {"id": J.gp(v_hb_4632, "id"), "t": J.S_performance_("now", [])}
		env["PRESS"] = _t5501
		if J.t(J.gp(J.G.get("navigator"), "vibrate")):
			J.S_navigator_("vibrate", [12.0])
		var _t5502 = {"sx": J.gp(v_p_4631, "x"), "sy": J.gp(v_p_4631, "y"), "drag": false, "btn": J.gp(v_hb_4632, "id"), "id": J.gp(v_e_4630, "pointerId")}
		env["ptr"] = _t5502
		env["joy"] = null
		J.mc(env["cv"], "setPointerCapture", [J.gp(v_e_4630, "pointerId")])
		return null
	v_ids_4633 = J.S_Object_("keys", [env["pts"]])
	if J.seq(J.len(v_ids_4633), 2.0):
		v_a_4634 = J.gp(env["pts"], J.gp(v_ids_4633, 0.0))
		v_b_4635 = J.gp(env["pts"], J.gp(v_ids_4633, 1.0))
		var _t5503 = {"d": J.hypot_([J.sub(J.gp(v_a_4634, "x"), J.gp(v_b_4635, "x")), J.sub(J.gp(v_a_4634, "y"), J.gp(v_b_4635, "y"))]), "z": J.gp(env["cam"], "z")}
		env["pinch"] = _t5503
		env["joy"] = null
		env["ptr"] = null
		return null
	var _t5505 = J.gp(v_p_4631, "x")
	var _t5506 = J.gp(v_p_4631, "y")
	var _t5507 = J.gp(v_e_4630, "pointerId")
	var _t5504 = J.cmp(J.gp(v_p_4631, "y"), J.sub(env["VH"], env["BOT"]), ">=")
	var _t5508 = {"sx": _t5505, "sy": _t5506, "drag": false, "id": _t5507, "hud": (_t5504 if _t5504 else J.cmp(J.gp(v_p_4631, "y"), env["TOP"], "<="))}
	env["ptr"] = _t5508
	var _t5509 = J.seq(env["scene"], "play")
	var _t5510 = ((not J.t(J.gp(env["G"], "over"))) if _t5509 else _t5509)
	var _t5511 = ((not J.t(J.gp(env["G"], "choice"))) if _t5510 else _t5510)
	var _t5512 = ((not J.t(J.gp(env["G"], "showStory"))) if _t5511 else _t5511)
	var _t5513 = (J.cmp(J.gp(v_p_4631, "y"), env["TOP"], ">") if _t5512 else _t5512)
	if (J.cmp(J.gp(v_p_4631, "y"), J.sub(env["VH"], env["BOT"]), "<") if _t5513 else _t5513):
		var _t5514 = {"ox": J.gp(v_p_4631, "x"), "oy": J.gp(v_p_4631, "y"), "x": J.gp(v_p_4631, "x"), "y": J.gp(v_p_4631, "y"), "on": false}
		env["joy"] = _t5514
	J.mc(env["cv"], "setPointerCapture", [J.gp(v_e_4630, "pointerId")])

func _f761(this_, a: Array, env):
	var v_e_4641 = null; var v_p_4642 = null; var v_ids_4643 = null; var v_a_4644 = null; var v_b_4645 = null; var v_S9_4646 = null; var v_mxp_4647 = null; var v_myp_4648 = null; var v_c0_4649 = null
	v_e_4641 = J.arg(a, 0)
	var _t5515 = env["pt"]
	v_p_4642 = J.cl(_t5515, null, [v_e_4641])
	if J.t(J.gp(env["pts"], J.gp(v_e_4641, "pointerId"))):
		var _t5516 = env["pts"]
		var _t5517 = J.gp(v_e_4641, "pointerId")
		J.sp(_t5516, _t5517, v_p_4642)
	if J.t(env["pinch"]):
		v_ids_4643 = J.S_Object_("keys", [env["pts"]])
		if J.seq(J.len(v_ids_4643), 2.0):
			v_a_4644 = J.gp(env["pts"], J.gp(v_ids_4643, 0.0))
			v_b_4645 = J.gp(env["pts"], J.gp(v_ids_4643, 1.0))
			var _t5518 = env["cam"]
			var _t5519 = env["clamp"]
			var _t5520 = J.cl(_t5519, null, [J.div(J.mul(J.gp(env["pinch"], "z"), J.hypot_([J.sub(J.gp(v_a_4644, "x"), J.gp(v_b_4645, "x")), J.sub(J.gp(v_a_4644, "y"), J.gp(v_b_4645, "y"))])), J.gp(env["pinch"], "d")), 0.5, 1.5])
			J.sp(_t5518, "z", _t5520)
			v_S9_4646 = J.mul(J.gp(env["cam"], "s"), J.gp(env["cam"], "z"))
			v_mxp_4647 = J.div(J.add(J.gp(v_a_4644, "x"), J.gp(v_b_4645, "x")), 2.0)
			v_myp_4648 = J.div(J.add(J.gp(v_a_4644, "y"), J.gp(v_b_4645, "y")), 2.0)
			if (not J.leq(J.gp(env["pinch"], "mx"), null)):
				var _t5521 = J.gp(env["cam"], "free")
				v_c0_4649 = (_t5521 if J.t(_t5521) else {"x": J.add(J.gp(env["cam"], "x"), J.div(J.div(env["VW"], v_S9_4646), 2.0)), "y": J.add(J.gp(env["cam"], "y"), (J.div(J.sub(J.sub(env["VH"], env["TOP"]), env["BOT"]), v_S9_4646) * 0.55))})
				var _t5522 = env["cam"]
				var _t5523 = {"x": J.sub(J.gp(v_c0_4649, "x"), J.div(J.sub(v_mxp_4647, J.gp(env["pinch"], "mx")), v_S9_4646)), "y": J.sub(J.gp(v_c0_4649, "y"), J.div(J.sub(v_myp_4648, J.gp(env["pinch"], "my")), v_S9_4646))}
				J.sp(_t5522, "free", _t5523)
			var _t5524 = env["pinch"]
			J.sp(_t5524, "mx", v_mxp_4647)
			var _t5525 = env["pinch"]
			J.sp(_t5525, "my", v_myp_4648)
		return null
	var _t5526 = (not J.t(env["ptr"]))
	if (_t5526 if _t5526 else (not J.seq(J.gp(env["ptr"], "id"), J.gp(v_e_4641, "pointerId")))):
		return null
	var _t5527 = (not J.t(J.gp(env["ptr"], "btn")))
	if ((J.hypot_([J.sub(J.gp(v_p_4642, "x"), J.gp(env["ptr"], "sx")), J.sub(J.gp(v_p_4642, "y"), J.gp(env["ptr"], "sy"))]) > 12.0) if _t5527 else _t5527):
		var _t5528 = env["ptr"]
		J.sp(_t5528, "drag", true)
	if J.t(env["joy"]):
		var _t5529 = env["joy"]
		var _t5530 = J.gp(v_p_4642, "x")
		J.sp(_t5529, "x", _t5530)
		var _t5531 = env["joy"]
		var _t5532 = J.gp(v_p_4642, "y")
		J.sp(_t5531, "y", _t5532)
		if J.t(J.gp(env["ptr"], "drag")):
			var _t5533 = env["joy"]
			J.sp(_t5533, "on", true)

func _f762(this_, a: Array, env):
	var v_e_4652 = null; var v_p_4653 = null; var v_was_4654 = null; var v_j_4655 = null; var v_hb_4656 = null
	v_e_4652 = J.arg(a, 0)
	J.del(env["pts"], J.gp(v_e_4652, "pointerId"))
	if J.t(env["pinch"]):
		if (not J.t(J.len(J.S_Object_("keys", [env["pts"]])))):
			env["pinch"] = null
		return null
	var _t5534 = ((not J.leq(J.gp(env["ptr"], "id"), null)) if J.t(env["ptr"]) else env["ptr"])
	if J.t(((not J.seq(J.gp(env["ptr"], "id"), J.gp(v_e_4652, "pointerId"))) if J.t(_t5534) else _t5534)):
		return null
	var _t5535 = env["pt"]
	v_p_4653 = J.cl(_t5535, null, [v_e_4652])
	v_was_4654 = env["ptr"]
	env["ptr"] = null
	v_j_4655 = (J.gp(env["joy"], "on") if J.t(env["joy"]) else env["joy"])
	env["joy"] = null
	var _t5536 = (J.seq(env["scene"], "play") if J.t(v_j_4655) else v_j_4655)
	var _t5537 = (env["G"] if J.t(_t5536) else _t5536)
	if J.t(((not J.t(J.gp(env["G"], "over"))) if J.t(_t5537) else _t5537)):
		var _t5538 = env["settleNear"]
		J.cl(_t5538, null, [J.gp(J.gp(env["G"], "gh"), J.gp(env["G"], "active")), 44.0])
	if J.t((J.gp(v_was_4654, "btn") if J.t(v_was_4654) else v_was_4654)):
		env["LASTP"] = v_p_4653
		var _t5539 = env["hitBtn"]
		v_hb_4656 = J.cl(_t5539, null, [J.gp(v_p_4653, "x"), J.gp(v_p_4653, "y")])
		if J.t((J.seq(J.gp(v_hb_4656, "id"), J.gp(v_was_4654, "btn")) if J.t(v_hb_4656) else v_hb_4656)):
			var _t5540 = env["press"]
			J.cl(_t5540, null, [J.gp(v_hb_4656, "id")])
		else:
			if (J.hypot_([J.sub(J.gp(v_p_4653, "x"), J.gp(v_was_4654, "sx")), J.sub(J.gp(v_p_4653, "y"), J.gp(v_was_4654, "sy"))]) < 24.0):
				var _t5541 = env["press"]
				J.cl(_t5541, null, [J.gp(v_was_4654, "btn")])
		return null
	var _t5542 = ((not J.t(J.gp(v_was_4654, "drag"))) if J.t(v_was_4654) else v_was_4654)
	if J.t(((not J.t(v_j_4655)) if J.t(_t5542) else _t5542)):
		var _t5543 = env["tap"]
		J.cl(_t5543, null, [J.gp(v_p_4653, "x"), J.gp(v_p_4653, "y")])

func _f763(this_, a: Array, env):
	var v_e_4659 = null
	v_e_4659 = J.arg(a, 0)
	J.del(env["pts"], J.gp(v_e_4659, "pointerId"))
	env["pinch"] = null
	env["ptr"] = null
	env["joy"] = null

func _f776(this_, a: Array, env):
	return env["G"]

func _f777(this_, a: Array, env):
	return env["LV"]

func _f778(this_, a: Array, env):
	return env["FL"]

func _f779(this_, a: Array, env):
	return env["FLN"]

func _f780(this_, a: Array, env):
	return env["IMG"]

func _f781(this_, a: Array, env):
	return (env["scene"] if J.t(env["OPEN"]) else "closed")

func _f782(this_, a: Array, env):
	return env["paused"]

func _f783(this_, a: Array, env):
	return env["VW"]

func _f784(this_, a: Array, env):
	return env["VH"]

func _f785(this_, a: Array, env):
	return env["TOP"]

func _f786(this_, a: Array, env):
	return env["BOT"]

func _f787(this_, a: Array, env):
	return env["buttons"]

func _f788(this_, a: Array, env):
	return env["G"]

func _f789(this_, a: Array, env):
	return env["LV"]

func _f790(this_, a: Array, env):
	return env["FL"]

func _f791(this_, a: Array, env):
	return env["FLN"]

func _f792(this_, a: Array, env):
	return env["IMG"]

func _f793(this_, a: Array, env):
	return (env["scene"] if J.t(env["OPEN"]) else "closed")

func _f794(this_, a: Array, env):
	return env["paused"]

func _f795(this_, a: Array, env):
	return env["VW"]

func _f796(this_, a: Array, env):
	return env["VH"]

func _f797(this_, a: Array, env):
	return env["TOP"]

func _f798(this_, a: Array, env):
	return env["BOT"]

func _f800(this_, a: Array, env):
	var v_g_4786 = null
	v_g_4786 = J.arg(a, 0)
	return {"k": J.gp(J.gp(v_g_4786, "d"), "key"), "mul": J.gp(v_g_4786, "mul"), "pow": J.gp(v_g_4786, "pow"), "trainee": J.gp(v_g_4786, "trainee"), "spm": J.gp(v_g_4786, "spm"), "em": J.gp(v_g_4786, "em"), "tm": J.gp(v_g_4786, "tm"), "im": J.gp(v_g_4786, "im"), "icd": J.gp(v_g_4786, "icd"), "um": J.gp(v_g_4786, "um")}

func _f799(this_, a: Array, env):
	var _t5555 = env["G"]
	if J.t(_t5555):
		var _t5550 = J.gp(env["G"], "gpHas")
		var _t5551 = J.gp(env["G"], "gpNeed")
		var _t5552 = J.gp(env["G"], "gpTeam")
		var _t5553 = J.gp(env["G"], "gpD")
		var _t5554 = J.gp(env["G"], "gpTier")
		var _t5549 = J.gp(env["G"], "gh")
		_t5555 = {"has": _t5550, "need": _t5551, "team": _t5552, "D": _t5553, "tier": _t5554, "gh": J.mc(_t5549, "map", [Callable(self, "_f800").bind(env)])}
	return _t5555

func _f801(this_, a: Array, env):
	J.cl(env["gpStart"], null, [])

func _f802(this_, a: Array, env):
	var v_i_4791 = null
	v_i_4791 = J.arg(a, 0)
	var _t5556 = env["gpF"]
	return J.cl(_t5556, null, [J.gp(J.gp(env["G"], "gh"), v_i_4791)])

func _f803(this_, a: Array, env):
	var v_w_4794 = null
	v_w_4794 = J.arg(a, 0)
	var _t5557 = env["endNight"]
	J.cl(_t5557, null, [v_w_4794])

func _f804(this_, a: Array, env):
	var v_r_4797 = null; var v_amt_4798 = null; var v_i_4799 = null
	v_r_4797 = J.arg(a, 0)
	v_amt_4798 = J.arg(a, 1)
	v_i_4799 = J.arg(a, 2)
	var _t5558 = env["scareRes"]
	J.cl(_t5558, null, [v_r_4797, v_amt_4798, (null if J.leq(v_i_4799, null) else J.gp(J.gp(env["G"], "gh"), v_i_4799))])

func _f805(this_, a: Array, env):
	var v_sd_4802 = null; var v_lv_4803 = null
	v_sd_4802 = J.arg(a, 0)
	v_lv_4803 = J.arg(a, 1)
	var _t5559 = env["newGame"]
	J.cl(_t5559, null, [v_sd_4802, v_lv_4803])
	J.cl(env["bake"], null, [])

func _f806(this_, a: Array, env):
	return ({"x": J.gp(env["SAFE"], "x"), "y": J.gp(env["SAFE"], "y"), "r": J.gp(env["SAFE"], "r"), "f": J.gp(env["SAFE"], "f"), "nodes": J.S_Object_("keys", [J.gp(env["SAFE"], "nodes")]), "on": J.cl(env["safeOn"], null, [])} if J.t(env["SAFE"]) else null)

func _f807(this_, a: Array, env):
	var v_i_4808 = null
	v_i_4808 = J.arg(a, 0)
	var _t5560 = env["inSafe"]
	return J.cl(_t5560, null, [J.gp(J.gp(env["G"], "gh"), v_i_4808)])

func _f808(this_, a: Array, env):
	var v_x_4811 = null; var v_y_4812 = null
	v_x_4811 = J.arg(a, 0)
	v_y_4812 = J.arg(a, 1)
	var _t5561 = env["inSafeXY"]
	return J.cl(_t5561, null, [v_x_4811, v_y_4812])

func _f809(this_, a: Array, env):
	var _t5562 = J.gp(env["G"], "_uq")
	return J.S_Object_("keys", [(_t5562 if J.t(_t5562) else {})])

func _f810(this_, a: Array, env):
	return {"z": J.gp(env["cam"], "z"), "free": (not (not J.t(J.gp(env["cam"], "free")))), "x": J.gp(env["cam"], "x"), "y": J.gp(env["cam"], "y")}

func _f812(this_, a: Array, env):
	var v_b_4821 = null
	v_b_4821 = J.arg(a, 0)
	return {"id": J.gp(v_b_4821, "id"), "x": J.gp(v_b_4821, "x"), "y": J.gp(v_b_4821, "y"), "w": J.gp(v_b_4821, "w"), "h": J.gp(v_b_4821, "h")}

func _f811(this_, a: Array, env):
	return J.mc(env["buttons"], "map", [Callable(self, "_f812").bind(env)])

func _f813(this_, a: Array, env):
	J.cl(env["actPress"], null, [])

func _f814(this_, a: Array, env):
	var _t5563 = env["ctxAction"]
	return J.cl(_t5563, null, [J.gp(J.gp(env["G"], "gh"), J.gp(env["G"], "active"))])

func _f815(this_, a: Array, env):
	var v_id_4828 = null; var v_l_4829 = null
	v_id_4828 = J.arg(a, 0)
	v_l_4829 = J.arg(a, 1)
	var _t5564 = env["noise"]
	J.cl(_t5564, null, [v_id_4828, v_l_4829])

func _f816(this_, a: Array, env):
	var v_z_4832 = null
	v_z_4832 = J.arg(a, 0)
	var _t5565 = env["cam"]
	J.sp(_t5565, "z", v_z_4832)

func _f817(this_, a: Array, env):
	var v_v_4835 = null
	v_v_4835 = J.arg(a, 0)
	env["paused"] = v_v_4835

func _f818(this_, a: Array, env):
	var v_dt_4838 = null; var v_n_4839 = null; var v_pp_4840 = null; var v_i_4841 = null
	v_dt_4838 = J.arg(a, 0)
	v_n_4839 = J.arg(a, 1)
	v_pp_4840 = env["paused"]
	env["paused"] = false
	v_i_4841 = 0.0
	while true:
		if not J.cmp(v_i_4841, (v_n_4839 if J.t(v_n_4839) else 1.0), "<"): break
		var _t5566 = env["update"]
		J.cl(_t5566, null, [v_dt_4838])
		v_i_4841 = J.num(v_i_4841) + 1.0
	env["paused"] = v_pp_4840
	J.cl(env["draw"], null, [])

func _f819(this_, a: Array, env):
	var v_i_4844 = null
	v_i_4844 = J.arg(a, 0)
	var _t5567 = env["catchGhost"]
	var _t5569 = J.gp(J.gp(env["G"], "gh"), v_i_4844)
	var _t5568 = J.gp(J.gp(env["G"], "guards"), 0.0)
	J.cl(_t5567, null, [_t5569, (_t5568 if J.t(_t5568) else {"dir": 1.0})])

func _f820(this_, a: Array, env):
	var v_i_4847 = null; var v_id_4848 = null
	v_i_4847 = J.arg(a, 0)
	v_id_4848 = J.arg(a, 1)
	var _t5570 = env["gotoNode"]
	return J.cl(_t5570, null, [J.gp(J.gp(env["G"], "gh"), v_i_4847), v_id_4848])

func _f821(this_, a: Array, env):
	var v_s_4851 = null
	v_s_4851 = J.arg(a, 0)
	var _t5571 = env["G"]
	var _t5572 = J.add(J.gp(_t5571, "t"), v_s_4851)
	J.sp(_t5571, "t", _t5572)

func _f822(this_, a: Array, env):
	return env["G"]

func _f823(this_, a: Array, env):
	var v_v_4856 = null
	v_v_4856 = J.arg(a, 0)

func _f824(this_, a: Array, env):
	var v_x_4859 = null; var v_y_4860 = null
	v_x_4859 = J.arg(a, 0)
	v_y_4860 = J.arg(a, 1)
	var _t5573 = env["W2S"]
	return J.cl(_t5573, null, [v_x_4859, v_y_4860])

func _f825(this_, a: Array, env):
	if J.t(env["OPEN"]):
		J.cl(env["resize"], null, [])

func _f830(this_, a: Array, env):
	return env["OPEN"]

func _f329(this_, a: Array, env):
	var v__cv_1944 = null; var v_NIGHT_1970 = null; var v_WARD_1976 = null; var v_buildMap_2059 = null; var v_placeUnits_2060 = null; var v_nearNode_2077 = null; var v_nearRes_2119 = null; var v_crayon_2164 = null; var v_rr_2171 = null; var v_open_2210 = null
	var _s804 = {"__p": env, "OPEN": null, "RAF": null, "ROOT": null, "FONT": null, "cv": null, "ctx": null, "DPR": null, "VW": null, "VH": null, "TOP": null, "BOT": null, "IMG": null, "Q": null, "WW": null, "WH": null, "BOTX": null, "FL": null, "FYS": null, "SX": null, "LX": null, "GLX": null, "PX0": null, "LV": null, "STORY": null, "TRUTH": null, "FLN": null, "LV0": null, "LEVELS": null, "PH": null, "seed": null, "LINES": null, "used": null, "GH": null, "CARDS": null, "GP_TRAINEE_POW": null, "GP_BASE": null, "GP_TIER_MAX": null, "GP_TRAINEE_MSG": null, "G": null, "scene": null, "paused": null, "PHT": null, "HUM": null, "ITEM": null, "BAGMAX": null, "curLv": null, "BLOCKMSG": null, "PPL_META": null, "SAFE": null, "SAFE_R": null, "SCREAM": null, "SPOOKL": null, "BALKL": null, "DROPK": null, "PPLFX": null, "TAOL": null, "ULT": null, "MV": null, "OMEN": null, "STRIKE": null, "AFTER": null, "REACT": null, "COUNT": null, "BLD": null, "HH": null, "HHW": null, "PROP": null, "PROPLINE": null, "LV0K": null, "cam": null, "staticCv": null, "LASTP": null, "buttons": null, "CR": null, "CRC": null, "joy": null, "ptr": null, "JR": null, "pts": null, "pinch": null, "PRESS": null, "PAD": null, "last": null, "LIFT": null, "UNIT": null, "TS": null, "useLevel": null, "fy": null, "rnd": null, "pick": null, "shuffle": null, "clamp": null, "line": null, "gpRead": null, "gpApply": null, "gpSv": null, "gpSvPut": null, "gpTier": null, "gpNeed": null, "gpDiff": null, "gpPowOf": null, "gpTeam": null, "gpF": null, "gpE": null, "gpStart": null, "gpTick": null, "gpOnEnd": null, "gpGoVillage": null, "gpPill": null, "gpBadge": null, "gpTitle": null, "gpOver": null, "newGame": null, "node": null, "link": null, "unitByDoor": null, "unitOf": null, "mkHuman": null, "spawnZoneGuards": null, "inZone": null, "toast": null, "float": null, "shortcut": null, "canPass": null, "humanPass": null, "joyMove": null, "posOf": null, "onArrive": null, "gotoNode": null, "dijkstra": null, "humanPassTo": null, "mirrorOn": null, "update": null, "takeItem": null, "unlockUnit": null, "checkAlert": null, "initSafe": null, "safeOn": null, "inSafeXY": null, "inSafe": null, "safeNode": null, "nearSafe": null, "nearestAny": null, "nearNodeH": null, "uniq": null, "pplScream": null, "balk": null, "startShock": null, "pplResTick": null, "pplTick": null, "drawDrops": null, "drawSafe": null, "pplDrawRes": null, "pplStep": null, "pplGuard": null, "nearestGhost": null, "humanUpdate": null, "catchGhost": null, "loseLoot": null, "spawnTao": null, "taoUpdate": null, "gatePress": null, "gateUpdate": null, "dollEscape": null, "endNight": null, "say": null, "scareRes": null, "flee": null, "addFear": null, "standStill": null, "calm": null, "approach": null, "doorBlock": null, "scarePress": null, "scareGuard": null, "part": null, "stepFx": null, "ultPress": null, "applyUlt": null, "invPress": null, "chooseCard": null, "startMove": null, "moveUpdate": null, "addTrace": null, "traceUpdate": null, "pickReact": null, "doReact": null, "setupBeans": null, "beansCheck": null, "drawBowl": null, "drawMouth": null, "txt": null, "drawMoves": null, "drawTraces": null, "reactPose": null, "reactProps": null, "drawTaskProps": null, "genLevel": null, "wpick": null, "buildMap2": null, "placeUnits2": null, "bake2": null, "resUpdate2": null, "chain": null, "noise": null, "spook": null, "reliefUpdate": null, "lureCost": null, "ctxAction": null, "actPress": null, "giveStory": null, "questUpdate": null, "drawProps2": null, "miniJump": null, "drawMini": null, "resize": null, "bake": null, "W2S": null, "spr": null, "sprite": null, "drawWard": null, "bubble": null, "crCol": null, "crRnd": null, "crHash": null, "crGrain": null, "crShape": null, "crTrace": null, "crBuild": null, "crGet": null, "crBlit": null, "crPanel": null, "crText": null, "crFill": null, "crBar": null, "crTone": null, "crBtn": null, "crBubble": null, "crBg": null, "crPressed": null, "btn": null, "draw": null, "drawHUD": null, "wrap": null, "panel": null, "drawChoice": null, "drawStory": null, "drawOver": null, "crTitleDeco": null, "drawTitle": null, "settleNear": null, "pt": null, "joyVec": null, "drawJoy": null, "hitBtn": null, "tap": null, "worldTap": null, "press": null, "frame": null, "loadImgs": null, "close": null}
	_s804["TS"] = Callable(self, "_f330").bind(_s804)
	_s804["useLevel"] = Callable(self, "_f331").bind(_s804)
	_s804["fy"] = Callable(self, "_f333").bind(_s804)
	_s804["rnd"] = Callable(self, "_f334").bind(_s804)
	_s804["pick"] = Callable(self, "_f335").bind(_s804)
	_s804["shuffle"] = Callable(self, "_f336").bind(_s804)
	_s804["clamp"] = Callable(self, "_f337").bind(_s804)
	_s804["line"] = Callable(self, "_f338").bind(_s804)
	_s804["gpRead"] = Callable(self, "_f341").bind(_s804)
	_s804["gpApply"] = Callable(self, "_f342").bind(_s804)
	_s804["gpSv"] = Callable(self, "_f343").bind(_s804)
	_s804["gpSvPut"] = Callable(self, "_f344").bind(_s804)
	_s804["gpTier"] = Callable(self, "_f345").bind(_s804)
	_s804["gpNeed"] = Callable(self, "_f346").bind(_s804)
	_s804["gpDiff"] = Callable(self, "_f347").bind(_s804)
	_s804["gpPowOf"] = Callable(self, "_f348").bind(_s804)
	_s804["gpTeam"] = Callable(self, "_f349").bind(_s804)
	_s804["gpF"] = Callable(self, "_f351").bind(_s804)
	_s804["gpE"] = Callable(self, "_f352").bind(_s804)
	_s804["gpStart"] = Callable(self, "_f353").bind(_s804)
	_s804["gpTick"] = Callable(self, "_f355").bind(_s804)
	_s804["gpOnEnd"] = Callable(self, "_f356").bind(_s804)
	_s804["gpGoVillage"] = Callable(self, "_f357").bind(_s804)
	_s804["gpPill"] = Callable(self, "_f358").bind(_s804)
	_s804["gpBadge"] = Callable(self, "_f359").bind(_s804)
	_s804["gpTitle"] = Callable(self, "_f360").bind(_s804)
	_s804["gpOver"] = Callable(self, "_f363").bind(_s804)
	_s804["newGame"] = Callable(self, "_f364").bind(_s804)
	_s804["node"] = Callable(self, "_f367").bind(_s804)
	_s804["link"] = Callable(self, "_f368").bind(_s804)
	v_buildMap_2059 = Callable(self, "_f369").bind(_s804)
	v_placeUnits_2060 = Callable(self, "_f374").bind(_s804)
	_s804["unitByDoor"] = Callable(self, "_f388").bind(_s804)
	_s804["unitOf"] = Callable(self, "_f389").bind(_s804)
	_s804["mkHuman"] = Callable(self, "_f390").bind(_s804)
	_s804["spawnZoneGuards"] = Callable(self, "_f391").bind(_s804)
	_s804["inZone"] = Callable(self, "_f392").bind(_s804)
	_s804["toast"] = Callable(self, "_f393").bind(_s804)
	_s804["float"] = Callable(self, "_f394").bind(_s804)
	_s804["shortcut"] = Callable(self, "_f397").bind(_s804)
	_s804["canPass"] = Callable(self, "_f398").bind(_s804)
	_s804["humanPass"] = Callable(self, "_f399").bind(_s804)
	_s804["joyMove"] = Callable(self, "_f400").bind(_s804)
	_s804["posOf"] = Callable(self, "_f402").bind(_s804)
	_s804["onArrive"] = Callable(self, "_f403").bind(_s804)
	_s804["gotoNode"] = Callable(self, "_f404").bind(_s804)
	_s804["dijkstra"] = Callable(self, "_f406").bind(_s804)
	_s804["humanPassTo"] = Callable(self, "_f409").bind(_s804)
	v_nearNode_2077 = Callable(self, "_f411").bind(_s804)
	_s804["mirrorOn"] = Callable(self, "_f412").bind(_s804)
	_s804["update"] = Callable(self, "_f414").bind(_s804)
	_s804["takeItem"] = Callable(self, "_f426").bind(_s804)
	_s804["unlockUnit"] = Callable(self, "_f428").bind(_s804)
	_s804["checkAlert"] = Callable(self, "_f429").bind(_s804)
	_s804["initSafe"] = Callable(self, "_f430").bind(_s804)
	_s804["safeOn"] = Callable(self, "_f431").bind(_s804)
	_s804["inSafeXY"] = Callable(self, "_f432").bind(_s804)
	_s804["inSafe"] = Callable(self, "_f433").bind(_s804)
	_s804["safeNode"] = Callable(self, "_f434").bind(_s804)
	_s804["nearSafe"] = Callable(self, "_f435").bind(_s804)
	_s804["nearestAny"] = Callable(self, "_f436").bind(_s804)
	_s804["nearNodeH"] = Callable(self, "_f438").bind(_s804)
	_s804["uniq"] = Callable(self, "_f439").bind(_s804)
	_s804["pplScream"] = Callable(self, "_f441").bind(_s804)
	_s804["balk"] = Callable(self, "_f442").bind(_s804)
	_s804["startShock"] = Callable(self, "_f443").bind(_s804)
	_s804["pplResTick"] = Callable(self, "_f444").bind(_s804)
	_s804["pplTick"] = Callable(self, "_f445").bind(_s804)
	_s804["drawDrops"] = Callable(self, "_f448").bind(_s804)
	_s804["drawSafe"] = Callable(self, "_f450").bind(_s804)
	_s804["pplDrawRes"] = Callable(self, "_f468").bind(_s804)
	_s804["pplStep"] = Callable(self, "_f469").bind(_s804)
	_s804["pplGuard"] = Callable(self, "_f470").bind(_s804)
	_s804["nearestGhost"] = Callable(self, "_f471").bind(_s804)
	_s804["humanUpdate"] = Callable(self, "_f473").bind(_s804)
	_s804["catchGhost"] = Callable(self, "_f476").bind(_s804)
	_s804["loseLoot"] = Callable(self, "_f484").bind(_s804)
	_s804["spawnTao"] = Callable(self, "_f486").bind(_s804)
	_s804["taoUpdate"] = Callable(self, "_f487").bind(_s804)
	_s804["gatePress"] = Callable(self, "_f493").bind(_s804)
	_s804["gateUpdate"] = Callable(self, "_f494").bind(_s804)
	_s804["dollEscape"] = Callable(self, "_f497").bind(_s804)
	_s804["endNight"] = Callable(self, "_f499").bind(_s804)
	_s804["say"] = Callable(self, "_f501").bind(_s804)
	_s804["scareRes"] = Callable(self, "_f502").bind(_s804)
	_s804["flee"] = Callable(self, "_f504").bind(_s804)
	_s804["addFear"] = Callable(self, "_f506").bind(_s804)
	_s804["standStill"] = Callable(self, "_f507").bind(_s804)
	_s804["calm"] = Callable(self, "_f508").bind(_s804)
	_s804["approach"] = Callable(self, "_f509").bind(_s804)
	v_nearRes_2119 = Callable(self, "_f512").bind(_s804)
	_s804["doorBlock"] = Callable(self, "_f514").bind(_s804)
	_s804["scarePress"] = Callable(self, "_f516").bind(_s804)
	_s804["scareGuard"] = Callable(self, "_f522").bind(_s804)
	_s804["part"] = Callable(self, "_f523").bind(_s804)
	_s804["stepFx"] = Callable(self, "_f524").bind(_s804)
	_s804["ultPress"] = Callable(self, "_f530").bind(_s804)
	_s804["applyUlt"] = Callable(self, "_f531").bind(_s804)
	_s804["invPress"] = Callable(self, "_f541").bind(_s804)
	_s804["chooseCard"] = Callable(self, "_f542").bind(_s804)
	_s804["startMove"] = Callable(self, "_f543").bind(_s804)
	_s804["moveUpdate"] = Callable(self, "_f544").bind(_s804)
	_s804["addTrace"] = Callable(self, "_f545").bind(_s804)
	_s804["traceUpdate"] = Callable(self, "_f547").bind(_s804)
	_s804["pickReact"] = Callable(self, "_f556").bind(_s804)
	_s804["doReact"] = Callable(self, "_f558").bind(_s804)
	_s804["setupBeans"] = Callable(self, "_f560").bind(_s804)
	_s804["beansCheck"] = Callable(self, "_f563").bind(_s804)
	_s804["drawBowl"] = Callable(self, "_f564").bind(_s804)
	_s804["drawMouth"] = Callable(self, "_f565").bind(_s804)
	_s804["txt"] = Callable(self, "_f566").bind(_s804)
	_s804["drawMoves"] = Callable(self, "_f567").bind(_s804)
	_s804["drawTraces"] = Callable(self, "_f570").bind(_s804)
	_s804["reactPose"] = Callable(self, "_f573").bind(_s804)
	_s804["reactProps"] = Callable(self, "_f574").bind(_s804)
	_s804["drawTaskProps"] = Callable(self, "_f575").bind(_s804)
	_s804["genLevel"] = Callable(self, "_f576").bind(_s804)
	_s804["wpick"] = Callable(self, "_f587").bind(_s804)
	_s804["buildMap2"] = Callable(self, "_f589").bind(_s804)
	_s804["placeUnits2"] = Callable(self, "_f597").bind(_s804)
	_s804["bake2"] = Callable(self, "_f624").bind(_s804)
	_s804["resUpdate2"] = Callable(self, "_f640").bind(_s804)
	_s804["chain"] = Callable(self, "_f647").bind(_s804)
	_s804["noise"] = Callable(self, "_f650").bind(_s804)
	_s804["spook"] = Callable(self, "_f653").bind(_s804)
	_s804["reliefUpdate"] = Callable(self, "_f655").bind(_s804)
	_s804["lureCost"] = Callable(self, "_f658").bind(_s804)
	_s804["ctxAction"] = Callable(self, "_f659").bind(_s804)
	_s804["actPress"] = Callable(self, "_f666").bind(_s804)
	_s804["giveStory"] = Callable(self, "_f673").bind(_s804)
	_s804["questUpdate"] = Callable(self, "_f674").bind(_s804)
	_s804["drawProps2"] = Callable(self, "_f679").bind(_s804)
	_s804["miniJump"] = Callable(self, "_f687").bind(_s804)
	_s804["drawMini"] = Callable(self, "_f689").bind(_s804)
	_s804["resize"] = Callable(self, "_f694").bind(_s804)
	v_crayon_2164 = Callable(self, "_f695").bind(_s804)
	_s804["bake"] = Callable(self, "_f696").bind(_s804)
	_s804["W2S"] = Callable(self, "_f697").bind(_s804)
	_s804["spr"] = Callable(self, "_f698").bind(_s804)
	_s804["sprite"] = Callable(self, "_f699").bind(_s804)
	_s804["drawWard"] = Callable(self, "_f700").bind(_s804)
	_s804["bubble"] = Callable(self, "_f701").bind(_s804)
	v_rr_2171 = Callable(self, "_f702").bind(_s804)
	_s804["crCol"] = Callable(self, "_f703").bind(_s804)
	_s804["crRnd"] = Callable(self, "_f704").bind(_s804)
	_s804["crHash"] = Callable(self, "_f706").bind(_s804)
	_s804["crGrain"] = Callable(self, "_f707").bind(_s804)
	_s804["crShape"] = Callable(self, "_f708").bind(_s804)
	_s804["crTrace"] = Callable(self, "_f710").bind(_s804)
	_s804["crBuild"] = Callable(self, "_f711").bind(_s804)
	_s804["crGet"] = Callable(self, "_f714").bind(_s804)
	_s804["crBlit"] = Callable(self, "_f715").bind(_s804)
	_s804["crPanel"] = Callable(self, "_f716").bind(_s804)
	_s804["crText"] = Callable(self, "_f717").bind(_s804)
	_s804["crFill"] = Callable(self, "_f719").bind(_s804)
	_s804["crBar"] = Callable(self, "_f720").bind(_s804)
	_s804["crTone"] = Callable(self, "_f721").bind(_s804)
	_s804["crBtn"] = Callable(self, "_f722").bind(_s804)
	_s804["crBubble"] = Callable(self, "_f723").bind(_s804)
	_s804["crBg"] = Callable(self, "_f724").bind(_s804)
	_s804["crPressed"] = Callable(self, "_f725").bind(_s804)
	_s804["btn"] = Callable(self, "_f726").bind(_s804)
	_s804["draw"] = Callable(self, "_f727").bind(_s804)
	_s804["drawHUD"] = Callable(self, "_f746").bind(_s804)
	_s804["wrap"] = Callable(self, "_f748").bind(_s804)
	_s804["panel"] = Callable(self, "_f749").bind(_s804)
	_s804["drawChoice"] = Callable(self, "_f750").bind(_s804)
	_s804["drawStory"] = Callable(self, "_f752").bind(_s804)
	_s804["drawOver"] = Callable(self, "_f754").bind(_s804)
	_s804["crTitleDeco"] = Callable(self, "_f756").bind(_s804)
	_s804["drawTitle"] = Callable(self, "_f757").bind(_s804)
	_s804["settleNear"] = Callable(self, "_f764").bind(_s804)
	_s804["pt"] = Callable(self, "_f765").bind(_s804)
	_s804["joyVec"] = Callable(self, "_f766").bind(_s804)
	_s804["drawJoy"] = Callable(self, "_f767").bind(_s804)
	_s804["hitBtn"] = Callable(self, "_f768").bind(_s804)
	_s804["tap"] = Callable(self, "_f769").bind(_s804)
	_s804["worldTap"] = Callable(self, "_f770").bind(_s804)
	_s804["press"] = Callable(self, "_f774").bind(_s804)
	_s804["frame"] = Callable(self, "_f775").bind(_s804)
	_s804["loadImgs"] = Callable(self, "_f826").bind(_s804)
	v_open_2210 = Callable(self, "_f828").bind(_s804)
	_s804["close"] = Callable(self, "_f829").bind(_s804)
	_s804["OPEN"] = false
	_s804["RAF"] = 0.0
	_s804["ROOT"] = J.S_document_("createElement", ["section"])
	var _t5434 = _s804["ROOT"]
	J.sp(_t5434, "id", "tw-root")
	var _t5435 = _s804["ROOT"]
	J.sp(_t5435, "className", "tw-root")
	v__cv_1944 = J.S_document_("createElement", ["canvas"])
	J.sp(v__cv_1944, "className", "tw-cv")
	J.mc(_s804["ROOT"], "appendChild", [v__cv_1944])
	var _t5436 = J.gp(J.G.get("document"), "body")
	J.mc(_t5436, "appendChild", [_s804["ROOT"]])
	if (not J.seq(J.typeof_(J.G.get("World")), "undefined")):
		var _t5437 = J.gp(J.G.get("World"), "ICON")
		J.sp(_t5437, "tower", "樓")
	_s804["FONT"] = "\"PingFang HK\",\"PingFang TC\",\"Noto Sans CJK TC\",\"Noto Sans TC\",\"Microsoft JhengHei\",sans-serif"
	_s804["cv"] = v__cv_1944
	_s804["ctx"] = J.mc(_s804["cv"], "getContext", ["2d"])
	var _t5438 = J.gp(J.G.get("window"), "devicePixelRatio")
	var _t5439 = J.gp(J.G.get("window"), "devicePixelRatio")
	_s804["DPR"] = J.min_([2.0, (_t5439 if J.t(_t5439) else 1.0)])
	_s804["VW"] = 390.0
	_s804["VH"] = 844.0
	_s804["TOP"] = 96.0
	_s804["BOT"] = 240.0
	_s804["IMG"] = {}
	_s804["Q"] = J.construct(J.G.get("URLSearchParams"), [J.gp(J.G.get("location"), "search")])
	_s804["WW"] = 600.0
	_s804["WH"] = 900.0
	_s804["BOTX"] = 0.0
	_s804["FL"] = 5.0
	_s804["LEVELS"] = {"flat": {"name": "組屋", "bg": "flatbg", "FL": 5.0, "FYS": [873.0, 711.0, 549.0, 405.0, 261.0, 117.0], "SX": 45.0, "LX": 555.0, "GLX": 555.0, "PX0": 105.0, "guard0": "f0_d2", "fln": ["地下", "二樓", "三樓", "四樓", "五樓", "天台"], "units": [[0.0, 1.0, "zha", "money", "npc_ken", 0.0, "雜貨舖", 330.0, [255.0, 405.0]], [0.0, 2.0, "datuk", null, null, (-1.0), "保安亭", 470.0, [405.0, 520.0]], [1.0, 0.0, null, "food", "npc_it", (-1.0), "學生房", 226.0, [78.0, 240.0]], [1.0, 1.0, "nuomi", "comb", "npc_auntie", 1.0, "老夫妻", 366.0, [240.0, 378.0]], [1.0, 2.0, null, null, null, (-1.0), "空置單位", 496.0, [378.0, 516.0]], [2.0, 0.0, null, "food", "npc_ken", 2.0, "大家庭", 226.0, [78.0, 240.0]], [2.0, 1.0, "nuomi", "comb", "npc_mis", (-1.0), "家庭理髮", 366.0, [240.0, 378.0]], [2.0, 2.0, "zha", "money", "npc_boss", (-1.0), "麻雀館", 496.0, [378.0, 516.0]], [3.0, 0.0, "menshen", null, null, (-1.0), "夜班護士", 226.0, [78.0, 240.0]], [3.0, 1.0, "zha", "money", "npc_ken", (-1.0), "囤積屋", 366.0, [240.0, 378.0]], [3.0, 2.0, null, "food", "npc_mis", 3.0, "卡拉OK", 496.0, [378.0, 516.0]], [4.0, 0.0, "fu", null, null, (-1.0), "封咗嘅單位", 226.0, [78.0, 240.0]], [4.0, 1.0, null, null, "npc_boss", 4.0, "養雀伯伯", 366.0, [240.0, 378.0]], [4.0, 2.0, "nuomi", "comb", "npc_auntie", (-1.0), "新婚夫婦", 496.0, [378.0, 516.0]]], "story": ["地庫：管理員話，停車場盡頭成日有部單車自己響鈴，佢話係陳伯以前架單車。", "地下：管理處話，頂樓嗰個貼滿紅紙嘅單位封咗好多年，但係夜晚成日有收音機聲。", "二樓：以前陳伯朝朝喺走廊淋花，見到人就問「食咗飯未呀？」", "三樓：有年七月，陳伯敲過我哋門借鹽，我扮唔喺屋企，冇開門……", "四樓：之後成座樓都聞到陣怪味，大家都以為係垃圾槽。", "五樓：陳伯隻雀仔而家我養住，佢一聽到收音機聲就唱歌，好似等緊有人敲門。", "六樓：天台門口有張舊相，係陳伯同成座樓街坊嘅中秋合照，個個都笑到見牙唔見眼。", "天台：陳伯以前晚晚上嚟淋花，佢話「花要有人睇住，人都係」。"], "hint": ["地下", "二樓", "三樓", "四樓", "五樓"], "truth": "呢座樓唔係真係鬧鬼——係有個伯伯等咗好耐，想有人記得佢。今晚之後，總算有人知道陳伯嘅名。"}, "shop": {"name": "老店屋", "bg": "shopbg", "FL": 4.0, "FYS": [812.0, 585.0, 420.0, 262.0, 74.0], "SX": 62.0, "LX": 552.0, "GLX": 520.0, "PX0": 122.0, "guard0": "f0_d1", "fln": ["地下", "二樓", "三樓", "四樓", "天台"], "units": [[0.0, 0.0, null, "food", "npc_ken", 0.0, "茶餐室", 232.0, [100.0, 370.0]], [0.0, 1.0, "datuk", null, null, (-1.0), "後廚", 430.0, [380.0, 560.0]], [1.0, 0.0, "zha", "money", "npc_boss", (-1.0), "中藥舖", 205.0, [100.0, 310.0]], [1.0, 1.0, "nuomi", "comb", "npc_auntie", 1.0, "老租客房", 420.0, [320.0, 530.0]], [2.0, 0.0, null, "food", "npc_it", 2.0, "工人房", 210.0, [100.0, 320.0]], [2.0, 1.0, "zha", "money", "npc_mis", 3.0, "麻雀房", 430.0, [330.0, 530.0]], [3.0, 0.0, null, null, "npc_ken", 4.0, "雜物房", 232.0, [100.0, 370.0]], [3.0, 1.0, "fu", null, null, (-1.0), "封咗嘅房", 445.0, [380.0, 530.0]]], "story": ["地庫：貨倉入面有部舊衣車，車針仲插住半件未補好嘅工衣。", "地下：茶餐室阿叔話，以前四樓住咗個車衫嘅芳姐，成條街啲工人都搵佢補衫。", "二樓：芳姐同我做咗三十年鄰居，佢話呢間屋就係佢一世，點都唔肯搬。", "三樓：收樓嗰年芳姐病咗入院，之後佢間房就封咗，門口貼滿紅紙。", "三樓：之後打麻雀打到三更，成日聽到樓上有車衣車聲，嗒嗒嗒咁響。", "四樓：我執雜物嗰陣搵到佢本記帳簿，最後一頁寫住「仲有十件衫未補完」。", "五樓：涼茶舖老闆娘話，芳姐每年冬至都會煲一大煲湯，逐層逐戶咁送。", "天台：芳姐以前喺天台曬衫，曬好就摺得四四正正，放喺各家門口。"], "hint": ["地下茶餐室", "二樓老租客", "三樓工人房", "三樓麻雀房", "四樓雜物房"], "truth": "芳姐唔係嚟嚇人——佢只係想做完手上最後嗰幾件衫。今晚之後，會有人幫佢將衫交返俾街坊。"}}
	_s804["LV0"] = _s804["LEVELS"]
	var _t5440 = J.mc(_s804["Q"], "get", ["night"])
	v_NIGHT_1970 = J.num((_t5440 if J.t(_t5440) else 150.0))
	_s804["PH"] = ["子時", "丑時", "寅時"]
	_s804["seed"] = 1.0
	_s804["LINES"] = {"afraid": ["咦？頭先咩聲嚟㗎？", "做咩部電視自己閃吓閃吓……", "我成身起晒雞皮，真係", "係咪隔籬屋喺度敲牆呀？", "唔好玩啦，邊個喺度？", "點解間屋凍到咁嘅？", "我好似見到有嘢郁咗一下", "背脊涼颼颼，唔對路", "冇嘢嘅冇嘢嘅，自己嚇自己", "頭先個影係咪你嚟㗎？"], "flee": ["鬼呀——！走先！", "救命呀！屋企有嘢呀！", "唔理啦，我落樓先！", "開門開門！我要出去！", "死啦死啦，真係有鬼！", "拖鞋都唔要啦，走呀！", "保安！保安！快啲上嚟！", "唔好追我呀——！"], "brave": ["嚇邊個呀？我見得多", "又係風啫，瞓覺", "想嚇我？等下世啦", "我後生做過夜更㗎"], "guard": ["巡樓囉，三樓啲燈又壞", "呢座樓夜晚真係陰陰哋", "巡完呢轉我要飲杯咖啡", "又要行樓梯，腳都軟埋"], "guardHit": ["照到喇！邊個喺度？", "手電筒照住你！唔好走！", "嗰度有嘢！我睇到！"], "wake": ["我開燈先，唔該晒", "念番兩句先瞓得著", "開晒啲燈佢就唔敢嚟"]}
	_s804["used"] = {}
	_s804["GH"] = [{"key": "eking", "gpk": "eguiking", "name": "餓鬼", "sprite": "eguiking", "h": 76.0, "sp": 104.0, "task": "food", "cross": {}, "tip": "餓鬼：入屋搵宵夜，站喺金圈讀條。"}, {"key": "toyol", "gpk": "toyol", "name": "Toyol", "sprite": "toyol", "h": 70.0, "sp": 132.0, "task": "money", "cross": {"zha": 1.0}, "tip": "Toyol：細隻，鐵閘罅都鑽得過，專偷銀包。"}, {"key": "tianhua", "gpk": "tianhua", "name": "天花姐", "sprite": "tianhua", "h": 74.0, "sp": 114.0, "task": "comb", "cross": {"nuomi": 1.0}, "tip": "天花姐：喺天花爬，地下撒嘅糯米攔佢唔住。"}]
	v_WARD_1976 = {"fu": {"n": "紅紙符", "m": "門頂貼住紅紙符，入唔到，繞路啦"}, "menshen": {"n": "門神", "m": "門神守住度門，我哋唔好亂嚟，繞路"}, "zha": {"n": "鐵閘", "m": "鐵閘鎖住，得 Toyol 鑽得入"}, "nuomi": {"n": "糯米", "m": "門口撒咗糯米，得天花姐過得去"}, "datuk": {"n": "拿督公神位", "m": "門口供住拿督公，要尊重，唔好入"}}
	_s804["CARDS"] = [{"id": "spd", "t": "鬼步加速", "d": "全部鬼移動快 20%"}, {"id": "pow", "t": "嚇人加倍", "d": "嚇人威力 +40%"}, {"id": "inv", "t": "隱身延長", "d": "隱身時間 +2 秒"}, {"id": "task", "t": "手快腳快", "d": "讀條快 35%"}, {"id": "arm", "t": "陰氣護體", "d": "被手電照到損失減半"}, {"id": "fear", "t": "怕意加成", "d": "嚇走人掉多 30% 怕意"}]
	_s804["GP_TRAINEE_POW"] = 250.0
	_s804["GP_BASE"] = {"flat": 1100.0, "shop": 1500.0}
	_s804["GP_TIER_MAX"] = 8.0
	_s804["GP_TRAINEE_MSG"] = "村入面未有呢隻鬼，只係見習水平。返村招募／升級先會變強！"
	_s804["G"] = null
	_s804["scene"] = "title"
	_s804["paused"] = false
	_s804["PHT"] = 60.0
	_s804["HUM"] = {"collector": {"n": "收數佬", "sp": 0.0, "spr": "res_collector", "h": 76.0}, "guard": {"n": "保安", "sp": 43.0, "spr": "res_guard", "h": 78.0}, "compass": {"n": "羅盤保安", "sp": 45.0, "spr": "npc_guard", "h": 78.0}, "mirror": {"n": "鏡子道士", "sp": 38.0, "spr": "npc_boss", "h": 76.0}, "decoy": {"n": "道士", "sp": 37.0, "spr": "npc_boss", "h": 76.0}, "dog": {"n": "看門狗", "sp": 230.0, "spr": null, "h": 38.0}}
	_s804["ITEM"] = {"food": {"n": "宵夜", "t": 0.8, "who": "eking"}, "money": {"n": "銀包", "t": 1.3, "who": "toyol"}, "comb": {"n": "木梳", "t": 1.6, "who": "tianhua"}, "doll": {"n": "替身紙人", "t": 2.0}, "key": {"n": "紅鎖匙", "t": 2.6}, "key2": {"n": "黃鎖匙", "t": 2.6}, "lost": {"n": "失物", "t": 1.5}}
	_s804["BAGMAX"] = 10.0
	_s804["curLv"] = "flat"
	_s804["BLOCKMSG"] = {"deity": "呢度有神明鎮宅，要尊重，繞路", "breach": "鎮宅未破：企定喺門口注入怕意", "key": "要先喺別戶偷到鎖匙", "chain": "隔籬戶未亂，呢度仲未入得", "door": "度門閂住，等住客開門嗰下先入", "stairSeal": "陰門開咗，樓梯封住"}
	_s804["PPL_META"] = {"res_gamer": {"n": {"foot": 0.0}, "s": {"k": 1.031, "foot": 0.0}}, "res_uncle": {"n": {"foot": 0.0}, "s": {"k": 1.0167, "foot": 0.0}}, "res_granny": {"n": {"foot": 0.0}, "s": {"k": 1.0071, "foot": 0.0}}, "res_helper": {"n": {"foot": 0.0}, "s": {"k": 1.0238, "foot": 0.0}}, "res_mjaunty": {"n": {"foot": 0.0}, "s": {"k": 0.9929, "foot": 0.0}}, "res_shopper": {"n": {"foot": 0.0}, "s": {"k": 0.9548, "foot": 0.0}}, "res_collector": {"n": {"foot": 0.0}, "s": {"k": 0.9167, "foot": 0.0}}, "res_guard": {"n": {"foot": 0.0}, "s": {"k": 0.9429, "foot": 0.0}}, "res_ot": {"n": {"foot": 0.0}, "s": {"k": 0.9262, "foot": 0.0}}, "res_gym": {"n": {"foot": 0.0}, "s": {"k": 0.9429, "foot": 0.0}}}
	_s804["SAFE"] = null
	_s804["SAFE_R"] = 150.0
	_s804["SCREAM"] = ["鬼呀——！走先！", "救命呀！屋企有嘢呀！", "唔理啦，我落樓先！", "開門開門！我要出去！", "死啦死啦，真係有鬼！", "拖鞋都唔要啦，走呀！", "保安！保安！快啲上嚟！", "唔好追我呀——！", "媽呀——！", "嘩——！唔關我事㗎！", "我唔住喇！聽日搬！", "走呀走呀！咪理銀包喇！", "有鬼呀！真係有鬼呀！", "我仲未想死呀——！", "乜嘢嚟㗎嗰樣嘢？！走！", "唔好搵我呀，我好人嚟㗎！", "頂唔順喇，走為上着！", "喂！等埋我呀——！", "我以後唔夜瞓喇！", "唔好過嚟呀——！", "救命呀！有冇人呀？！", "我對腳軟晒……走呀！", "今晚去酒店瞓好過！", "係咪我眼花……唔理喇走！", "嗚哇——！嚇死人咩！", "我發誓以後唔講粗口！", "快啲快啲，落樓梯！", "唔好捉我呀——！", "咩鬼嘢呀！走呀！", "喊都喊唔出呀！", "我要返鄉下！", "頭先嗰個……唔係人嚟！", "電話呢？算啦，走先！", "我心口好翳……走呀！", "冇眼睇喇，閃！", "條頸凍晒，走呀！", "唔玩喇唔玩喇！", "鬼打牆呀——！", "我以後晚晚開晒燈！", "快啲開門呀——！", "嘩呀——！頂唔順！", "救命呀——！鬼呀！", "我唔要命呀……唔係，我要命呀！", "走啦走啦，唔好望！", "阿媽救我呀——！", "嗰度有對眼呀——！", "我條腳唔聽話呀！", "落樓！落樓！快啲！", "冇得傾，我走先！", "唔好掂我呀——！", "咩呀咩呀咩呀——！", "我好驚呀——！", "點解會咁㗎——！", "我錯喇我錯喇！", "唔好嚇我呀大佬！", "走得快好世界！", "我出去搵人幫手先！", "救我呀，邊個都好！", "嘩，佢望住我呀！", "我今晚唔返嚟瞓喇！", "頭皮發晒麻呀！", "我要報警呀——！", "佢喺我後面呀——！", "唔好再跟住我呀！", "我以後唔睇鬼片喇！", "嚇到魂都冇埋！", "係真㗎！係真㗎！", "我唔信邪……但我信喇！", "快走，唔好回頭！", "我把聲都震晒呀！", "佢冇腳㗎——！", "好凍呀！好凍呀！", "開燈呀！開晒啲燈呀！", "唔好笑呀——！", "我唔識你呀——！", "冇得頂！", "我寧願返工都唔留喺度！", "呢間屋有嘢㗎！", "我仲有供樓未還㗎！", "我唔玩捉迷藏呀！", "我隻手凍到冇知覺！", "跑呀，唔好企喺度！", "我眼花，一定係眼花……走！", "邊個喺度笑呀——！", "我隻拖鞋呢？唔要喇！", "我發夢……一定係發夢！", "我收工喇！收工喇！", "鬼呀鬼呀鬼呀——！", "唔好拉我呀——！", "我未食飯㗎，唔好食我！", "嗰把聲喺耳邊呀——！", "啲燈熄晒喇，走呀！", "我唔夠膽再望多一眼！", "我腳都軟埋——走！", "唔關事，真係唔關事！", "我出去瞓街好過！", "隻手！有隻手呀——！", "我啲寒毛企晒起身！", "我同你冇仇㗎——！", "嗚嗚嗚，我要返屋企……", "我錯晒，我以後早啲瞓！", "快啲搵人嚟呀——！", "我把心跳到出嚟！", "嗰陣味好臭呀，走！", "個天花板有嘢呀——！", "我唔做呢份工喇！", "邊度走得最快呀？！", "我出去等天光！", "佢叫咗我個名呀——！", "唔好企喺門口呀，走！"]
	_s804["SPOOKL"] = ["嘩！！", "乜……乜嘢嚟㗎？！", "我唔做喇……", "嘩！有嘢喺我後面！", "咩、咩聲呀？！", "手電筒點解閃㗎？！", "冇嘢嘅冇嘢嘅……", "頭先係咪有嘢掂我？", "我……我去飲杯水先", "邊個喺度？！出嚟！", "唔好玩嘢呀！", "份人工唔包驚㗎！", "對講機！對講機呢？！", "我對腳震緊……", "係風……一定係風……", "老細冇講過有呢樣嘢㗎！", "佢、佢郁咗！", "我要加人工先得！", "嚇到我心都離一離", "背脊涼晒……"]
	_s804["BALKL"] = ["頂……嗰邊陰陰森森，唔過去喇", "嗰度凍到入骨，我唔行埋去", "老細話過嗰邊夜晚唔好去……", "算數，嗰度我唔跟喇", "嗰邊陰風陣陣……返轉頭先", "唔通真係有嘢？我返轉頭好過", "嗰度啲燈成日閃，唔去喇", "我條命緊要過份工", "嗰邊冇人去㗎，我都唔去", "唔該，嗰度我真係唔敢入"]
	_s804["DROPK"] = {"couple": "cup", "mahjong": "tile", "taxi": "cup", "cook": "bowl", "insomnia": "cup", "nurse": "cup", "debt": "cup", "gamer": "pad", "granny": "fan", "elder": "cup", "helper": "cup", "shopper": "box", "ot": "cup", "gym": "cup"}
	var _t5441 = J.G.get("window")
	var _t5495 = J.cl(Callable(self, "_f451").bind(_s804), null, [])
	J.sp(_t5441, "PPLFX", _t5495)
	_s804["PPLFX"] = _t5495
	_s804["TAOL"] = ["鈴……鈴……各位街坊安心瞓", "天師巡樓，邪氣退散", "聽住鈴聲，唔好亂走", "鈴聲到處，夜路平安"]
	_s804["ULT"] = {"eking": {"n": "大胃王", "d": "整層熄燈，黑暗中得返一張巨口！"}, "toyol": {"n": "一掃光", "d": "分身滿層亂竄，偷到一個唔留！"}, "tianhua": {"n": "千絲垂髮", "d": "頭髮沿走廊爬去隔籬屋，纏實成層人！"}}
	_s804["MV"] = {"eking": {"n": "碗筷自己郁・米缸巨口", "omen": "叮叮噹噹……", "tr": "food"}, "toyol": {"n": "細腳印・床底搶嘢", "omen": "嘻嘻……嘻嘻……", "tr": "mess"}, "tianhua": {"n": "天花滲水・倒吊貼面", "omen": "嘀……嘀……", "tr": "hair"}}
	_s804["OMEN"] = 0.75
	_s804["STRIKE"] = 0.65
	_s804["AFTER"] = 0.6
	_s804["REACT"] = {"scream": ["啊——！！", "嘩呀——！！", "救——命——！"], "kneel": ["唔好搵我……我冇做壞事㗎", "放過我啦……", "我同你無仇無怨㗎……"], "cover": ["睇唔到睇唔到睇唔到……", "唔好望唔好望……"], "fall": ["哎呀！", "跌親呀——"], "phone": ["喂？管理處呀！有嘢呀！", "喂喂喂！快啲上嚟！"], "slipper": ["打死你！打死你！", "睇我隻拖鞋！"], "push": ["你行先！", "唔好推我呀！"]}
	_s804["COUNT"] = ["一", "二", "三", "四", "五", "六", "七", "八", "九", "十"]
	_s804["BLD"] = {"flat": {"name": "組屋", "skin": "flatbg", "FH": 184.0, "ROOF": 150.0, "camW": 400.0, "levels": ["地庫", "地下", "一樓", "二樓", "三樓", "四樓", "五樓", "六樓", "七樓", "八樓", "九樓", "十樓", "天台"], "cols": [["stair", 112.0], ["u", 180.0], ["u", 180.0], ["u", 180.0], ["u", 180.0], ["lift", 124.0], ["u", 180.0], ["u", 180.0], ["u", 180.0], ["u", 180.0], ["back", 112.0]], "src": {"stair": [0.0, 78.0, 261.0, 405.0], "lift": [516.0, 600.0, 261.0, 405.0], "back": [0.0, 78.0, 261.0, 405.0, 1.0], "gstair": [0.0, 78.0, 711.0, 873.0], "glift": [520.0, 600.0, 711.0, 873.0], "roof": [0.0, 600.0, 0.0, 117.0], "res": [[78.0, 240.0, 117.0, 261.0], [240.0, 378.0, 117.0, 261.0], [378.0, 516.0, 117.0, 261.0], [78.0, 240.0, 261.0, 405.0], [240.0, 378.0, 261.0, 405.0], [378.0, 516.0, 261.0, 405.0], [78.0, 240.0, 405.0, 549.0], [240.0, 378.0, 405.0, 549.0], [378.0, 516.0, 405.0, 549.0], [78.0, 240.0, 549.0, 711.0], [240.0, 378.0, 549.0, 711.0], [378.0, 516.0, 549.0, 711.0]], "deity": [[78.0, 240.0, 117.0, 261.0]], "ground": [[78.0, 240.0, 711.0, 873.0], [240.0, 405.0, 711.0, 873.0], [405.0, 520.0, 711.0, 873.0]]}, "ground": ["信箱大堂", "士多", "管理處", "茶餐廳", "單車房", "垃圾房", "藥房", "洗衣舖"], "base": ["停車場", "機房", "水錶房", "貨倉", "雜物房", "停車場", "冷氣機房", "電錶房"], "pipes": [[2.0, 4.0, 3.0], [4.0, 7.0, 6.0], [1.0, 3.0, 0.0], [5.0, 7.0, 2.0], [7.0, 10.0, 5.0], [9.0, 12.0, 1.0], [8.0, 11.0, 7.0]], "lift": true}, "shop": {"name": "老店屋", "skin": "shopbg", "FH": 194.0, "ROOF": 140.0, "camW": 500.0, "levels": ["地庫", "地下", "一樓", "二樓", "三樓", "四樓", "五樓", "六樓", "七樓", "八樓", "天台"], "cols": [["stair", 124.0], ["u", 236.0], ["u", 236.0], ["u", 236.0], ["lift", 116.0], ["u", 236.0], ["u", 236.0], ["back", 96.0]], "src": {"stair": [0.0, 100.0, 262.0, 420.0], "lift": [0.0, 100.0, 420.0, 585.0, 1.0], "back": [530.0, 600.0, 262.0, 420.0], "gstair": [0.0, 100.0, 585.0, 812.0], "glift": [0.0, 100.0, 585.0, 812.0, 1.0], "roof": [0.0, 600.0, 0.0, 74.0], "res": [[100.0, 320.0, 262.0, 420.0], [320.0, 530.0, 262.0, 420.0], [100.0, 320.0, 420.0, 585.0], [320.0, 530.0, 420.0, 585.0], [100.0, 320.0, 74.0, 262.0]], "deity": [[320.0, 530.0, 74.0, 262.0]], "ground": [[100.0, 320.0, 585.0, 812.0], [320.0, 530.0, 585.0, 812.0]]}, "ground": ["茶餐室", "中藥舖", "車衣舖", "五金舖", "涼茶舖"], "base": ["貨倉", "雜物房", "米倉", "舊工場", "冷房"], "pipes": [[1.0, 3.0, 2.0], [3.0, 6.0, 4.0], [2.0, 5.0, 0.0], [5.0, 8.0, 1.0], [7.0, 10.0, 3.0]], "lift": false}}
	_s804["HH"] = {"gamer": {"n": "打機青年", "sp": ["res_gamer"], "awake": [1.0, 1.0, 1.0], "brave": 0.25, "props": ["pc", "fridge"], "items": ["food", "food"], "idle": ["再打多鋪先瞓", "隊友又送頭……", "聽日唔使返工，打通宵！"]}, "nurse": {"n": "夜班護士", "sp": ["npc_mis"], "awake": [1.0, 0.0, 0.0], "leave": 0.55, "props": ["phone", "kettle"], "items": ["money", "comb"], "idle": ["今晚又返通宵", "飲杯熱水先出門"]}, "elder": {"n": "獨居伯伯", "sp": ["res_uncle"], "awake": [0.0, 0.0, 1.0], "leave": 2.35, "props": ["radio", "ancestor"], "items": ["comb", "food"], "idle": ["唉，又瞓唔著", "聽朝早啲去飲茶"]}, "granny": {"n": "婆婆", "sp": ["res_granny"], "awake": [0.0, 0.0, 1.0], "props": ["radio", "fan"], "items": ["food", "comb"], "idle": ["個仔又冇打電話嚟……", "風扇開細啲先"]}, "couple": {"n": "新婚夫婦", "sp": ["npc_ken", "npc_mis"], "awake": [1.0, 0.0, 0.0], "props": ["tv", "fridge"], "items": ["food", "comb"], "idle": ["睇埋呢集先瞓", "聽日去邊度食早餐？"]}, "mahjong": {"n": "麻雀腳", "sp": ["res_mjaunty", "npc_boss", "npc_ken", "npc_mis"], "awake": [1.0, 1.0, 1.0], "props": ["mahjong", "fan"], "items": ["money", "money", "food"], "noisy": 1.0, "idle": ["碰！", "食糊！自摸！", "到你出牌喇", "今晚手氣真係差"]}, "shopper": {"n": "網購狂", "sp": ["res_shopper"], "awake": [1.0, 1.0, 0.0], "props": ["doorbell", "tv"], "items": ["money", "comb"], "idle": ["又有速遞到？", "買多件先，平呀嘛"]}, "taxi": {"n": "夜更的士佬", "sp": ["npc_ken"], "awake": [1.0, 1.0, 1.0], "away": 1.35, "props": ["fridge", "tv"], "items": ["food", "money"], "idle": ["收工喇，攰到死", "今晚載咗個好奇怪嘅客……"]}, "cook": {"n": "宵夜佬", "sp": ["npc_ken_sit"], "awake": [1.0, 1.0, 0.0], "props": ["rice", "fridge"], "items": ["food", "food"], "idle": ["煮個公仔麵先", "加隻蛋！"]}, "insomnia": {"n": "失眠阿叔", "sp": ["npc_boss"], "awake": [1.0, 1.0, 1.0], "brave": 0.4, "props": ["radio", "fan"], "items": ["money"], "idle": ["我喺呢度住咗四十年，咩未見過", "收音機陪我瞓"]}, "helper": {"n": "家務姐姐", "sp": ["res_helper"], "awake": [1.0, 1.0, 0.0], "props": ["washer", "fridge"], "items": ["food", "comb"], "idle": ["仲有一籃衫未熨……", "聽朝一早要陪婆婆睇醫生", "洗埋呢籃先瞓"]}, "ot": {"n": "加班族", "sp": ["res_ot"], "awake": [1.0, 1.0, 0.0], "away": 0.75, "props": ["pc", "tv"], "items": ["food", "food"], "idle": ["又OT到咁夜……", "食完個外賣就瞓", "老細仲WhatsApp我？"]}, "gym": {"n": "健身仔", "sp": ["res_gym"], "awake": [1.0, 1.0, 1.0], "brave": 0.5, "props": ["radio", "fan"], "items": ["food"], "idle": ["再做多十下！", "練完先食宵夜", "今晚練胸"]}, "debt": {"n": "欠債人家", "sp": ["npc_ken", "npc_auntie"], "awake": [1.0, 1.0, 0.0], "props": ["phone", "tv"], "items": ["food"], "idle": ["唔好出聲，佢哋又嚟……", "下個月一定還到"]}}
	_s804["HHW"] = [["gamer", 3.0], ["nurse", 2.0], ["elder", 2.0], ["granny", 2.0], ["couple", 3.0], ["mahjong", 1.0], ["shopper", 2.0], ["taxi", 1.0], ["cook", 2.0], ["insomnia", 1.0], ["helper", 1.0], ["ot", 2.0], ["gym", 1.0]]
	_s804["PROP"] = {"tv": {"n": "電視", "v": "附身電視", "lv": 1.0, "f": 24.0}, "fan": {"n": "風扇", "v": "附身風扇", "lv": 1.0, "f": 18.0}, "fridge": {"n": "雪櫃", "v": "附身雪櫃", "lv": 1.0, "f": 22.0}, "pc": {"n": "電腦", "v": "附身電腦", "lv": 1.0, "f": 26.0}, "radio": {"n": "收音機", "v": "開收音機", "lv": 2.0, "f": 20.0}, "phone": {"n": "電話", "v": "整響電話", "lv": 2.0, "f": 22.0}, "mahjong": {"n": "麻雀枱", "v": "自動洗牌", "lv": 2.0, "f": 30.0}, "doorbell": {"n": "門鐘", "v": "撳門鐘", "lv": 2.0, "f": 20.0}, "kettle": {"n": "水煲", "v": "自己煲水", "lv": 1.0, "f": 16.0}, "washer": {"n": "洗衣機", "v": "洗衣機自己轉", "lv": 2.0, "f": 20.0}, "rice": {"n": "電飯煲", "v": "電飯煲跳掣", "lv": 1.0, "f": 16.0}, "ancestor": {"n": "祖先牌位", "v": null}}
	_s804["PROPLINE"] = {"tv": ["部電視做咩自己開咗？！", "雪花……入面好似有個人影"], "fan": ["風扇自己轉到咁大力？！", "窗簾吹到飛晒起……"], "fridge": ["雪櫃門自己開咗！", "點解咁凍……"], "pc": ["電腦彈咗張鬼臉出嚟！", "我隻角色自己行開咗？！"], "radio": ["收音機自己播粵曲……", "邊個開咗收音機？"], "phone": ["三點幾有人打嚟……冇聲嘅", "喂？喂？邊位呀？"], "mahjong": ["啲牌自己洗緊！", "邊個郁咗我啲牌？！"], "doorbell": ["叮噹——門口冇人㗎喎", "又係速遞？咁夜？"], "kettle": ["水煲自己嗚嗚叫……", "我冇煲水㗎喎"], "washer": ["洗衣機自己開咗？！", "入面啲衫……好似有隻手"], "rice": ["電飯煲自己跳掣？", "啲飯冇咗一半！"]}
	_s804["LV0K"] = {"who": Callable(self, "_f623").bind(_s804)}
	_s804["cam"] = {"x": 0.0, "y": 0.0, "s": 1.0, "z": 1.0, "free": null}
	_s804["staticCv"] = null
	_s804["LASTP"] = null
	_s804["buttons"] = []
	_s804["CR"] = {"cache": {}, "n": 0.0, "M": 8.0, "tones": {"red": {"b": "#2b1012", "m": "#7a2522", "e": "#c4493c", "t": "#f2e3cc", "h": "#e07a62"}, "bone": {"b": "#1e1a16", "m": "#5c5246", "e": "#d8ccb0", "t": "#efe5cf", "h": "#f4ead2"}, "rust": {"b": "#2a190d", "m": "#8c4b1d", "e": "#d87e3c", "t": "#f6dcb6", "h": "#eea060"}, "violet": {"b": "#19132a", "m": "#4b3b6e", "e": "#9c88cc", "t": "#e8e0fa", "h": "#bfaee8"}, "moss": {"b": "#121a11", "m": "#3b5431", "e": "#8aac6c", "t": "#e4ecd2", "h": "#b4d090"}, "ink": {"b": "#18141b", "m": "#3c3544", "e": "#958a9c", "t": "#ebe3d6", "h": "#b8aec0"}, "paper": {"b": "#141016", "m": "#2e2430", "e": "#6a5a68", "t": "#e9e1d4", "h": "#8a7a8c"}, "sheet": {"b": "#1a1418", "m": "#3a2a34", "e": "#cdbf9f", "t": "#efe5cf", "h": "#e8dcc0"}, "note": {"b": "#d6c9ab", "m": "#b3a283", "e": "#3a2c28", "t": "#2a1e1c", "h": "#efe4c8"}, "dawn": {"b": "#1a1418", "m": "#3a5230", "e": "#d87e3c", "t": "#efe5cf", "h": "#eea060"}}}
	_s804["CRC"] = {"#ffffff": "#efe5cf", "#fff3c8": "#efdcb4", "#ffd54a": "#e6a85a", "#ffcc55": "#e6a85a", "#ffe9a0": "#e8d2a0", "#ffe9c0": "#efdcb8", "#8affc8": "#b2d394", "#9fd6bf": "#a9c79a", "#9fe0ff": "#a9a0d8", "#ff9a9a": "#e48a78", "#ffb0b0": "#e48a78", "#ffb7a0": "#e8a088", "#ff8a5a": "#e0844a", "#dddddd": "#ddd2bd", "#d8d8d0": "#ddd2bd", "#c8ccc4": "#cfc4b0", "#ecece6": "#efe5cf", "#d6dad2": "#ddd2bd", "#e2e6e0": "#efe5cf", "#7a7f78": "#9a8e92", "#55585a": "#8a7e84", "#5a5e58": "#7a6e74", "#e8e2d0": "#e6dcc6", "#ffd8c8": "#e8c4b0", "#ff3a2a": "#d2463a", "#d24a3a": "#c4493c"}
	_s804["joy"] = null
	_s804["ptr"] = null
	_s804["JR"] = 58.0
	_s804["pts"] = {}
	_s804["pinch"] = null
	J.mc(_s804["cv"], "addEventListener", ["pointerdown", Callable(self, "_f760").bind(_s804)])
	J.mc(_s804["cv"], "addEventListener", ["pointermove", Callable(self, "_f761").bind(_s804)])
	J.mc(_s804["cv"], "addEventListener", ["pointerup", Callable(self, "_f762").bind(_s804)])
	J.mc(_s804["cv"], "addEventListener", ["pointercancel", Callable(self, "_f763").bind(_s804)])
	_s804["PRESS"] = null
	_s804["PAD"] = 10.0
	_s804["last"] = 0.0
	_s804["LIFT"] = (J.S_window_("LiftSys", [{"FONT": _s804["FONT"], "HUM": _s804["HUM"], "HH": _s804["HH"], "cv": _s804["cv"], "fy": _s804["fy"], "rnd": _s804["rnd"], "float": _s804["float"], "toast": _s804["toast"], "say": _s804["say"], "addFear": _s804["addFear"], "noise": _s804["noise"], "spook": _s804["spook"], "W2S": _s804["W2S"], "__getters": {"G": Callable(self, "_f776").bind(_s804), "LV": Callable(self, "_f777").bind(_s804), "FL": Callable(self, "_f778").bind(_s804), "FLN": Callable(self, "_f779").bind(_s804), "IMG": Callable(self, "_f780").bind(_s804), "scene": Callable(self, "_f781").bind(_s804), "paused": Callable(self, "_f782").bind(_s804), "VW": Callable(self, "_f783").bind(_s804), "VH": Callable(self, "_f784").bind(_s804), "TOP": Callable(self, "_f785").bind(_s804), "BOT": Callable(self, "_f786").bind(_s804), "BTNS": Callable(self, "_f787").bind(_s804)}}]) if J.t(J.gp(J.G.get("window"), "LiftSys")) else null)
	var _t5544 = J.G.get("window")
	var _t5545 = _s804["LIFT"]
	J.sp(_t5544, "LIFT", _t5545)
	_s804["UNIT"] = (J.S_window_("UnitSys", [{"FONT": _s804["FONT"], "HH": _s804["HH"], "ITEM": _s804["ITEM"], "BAGMAX": _s804["BAGMAX"], "MV": _s804["MV"], "BLOCKMSG": _s804["BLOCKMSG"], "PH": _s804["PH"], "PHT": _s804["PHT"], "cv": _s804["cv"], "fy": _s804["fy"], "rnd": _s804["rnd"], "float": _s804["float"], "toast": _s804["toast"], "say": _s804["say"], "addFear": _s804["addFear"], "scareRes": _s804["scareRes"], "gpF": _s804["gpF"], "takeItem": _s804["takeItem"], "onArrive": _s804["onArrive"], "unitOf": _s804["unitOf"], "doorBlock": _s804["doorBlock"], "ctxAction": _s804["ctxAction"], "actPress": _s804["actPress"], "gotoNode": _s804["gotoNode"], "noise": _s804["noise"], "checkAlert": _s804["checkAlert"], "crPanel": _s804["crPanel"], "crText": _s804["crText"], "crBtn": _s804["crBtn"], "crBar": _s804["crBar"], "crGet": _s804["crGet"], "crBlit": _s804["crBlit"], "__getters": {"G": Callable(self, "_f788").bind(_s804), "LV": Callable(self, "_f789").bind(_s804), "FL": Callable(self, "_f790").bind(_s804), "FLN": Callable(self, "_f791").bind(_s804), "IMG": Callable(self, "_f792").bind(_s804), "scene": Callable(self, "_f793").bind(_s804), "paused": Callable(self, "_f794").bind(_s804), "VW": Callable(self, "_f795").bind(_s804), "VH": Callable(self, "_f796").bind(_s804), "TOP": Callable(self, "_f797").bind(_s804), "BOT": Callable(self, "_f798").bind(_s804)}}]) if J.t(J.gp(J.G.get("window"), "UnitSys")) else null)
	var _t5546 = J.G.get("window")
	var _t5547 = _s804["UNIT"]
	J.sp(_t5546, "UNIT", _t5547)
	var _t5548 = J.G.get("window")
	var _t5574 = {"gp": Callable(self, "_f799").bind(_s804), "gpRe": Callable(self, "_f801").bind(_s804), "gpF": Callable(self, "_f802").bind(_s804), "end": Callable(self, "_f803").bind(_s804), "sr": Callable(self, "_f804").bind(_s804), "ng": Callable(self, "_f805").bind(_s804), "safe": Callable(self, "_f806").bind(_s804), "inSafe": Callable(self, "_f807").bind(_s804), "inSafeXY": Callable(self, "_f808").bind(_s804), "uq": Callable(self, "_f809").bind(_s804), "cam": Callable(self, "_f810").bind(_s804), "btns": Callable(self, "_f811").bind(_s804), "act": Callable(self, "_f813").bind(_s804), "ctx": Callable(self, "_f814").bind(_s804), "noise": Callable(self, "_f815").bind(_s804), "zoom": Callable(self, "_f816").bind(_s804), "pause": Callable(self, "_f817").bind(_s804), "step": Callable(self, "_f818").bind(_s804), "gate": _s804["gatePress"], "doll": _s804["dollEscape"], "catchG": Callable(self, "_f819").bind(_s804), "ult": _s804["ultPress"], "press": _s804["press"], "tap": _s804["tap"], "goto": Callable(self, "_f820").bind(_s804), "choose": _s804["chooseCard"], "skip": Callable(self, "_f821").bind(_s804), "w2s": Callable(self, "_f824").bind(_s804), "__getters": {"G": Callable(self, "_f822").bind(_s804)}}
	J.sp(_t5548, "TW", _t5574)
	J.S_window_("addEventListener", ["resize", Callable(self, "_f825").bind(_s804)])
	return {"open": v_open_2210, "close": _s804["close"], "__getters": {"on": Callable(self, "_f830").bind(_s804)}}
