# 自動轉譯自 tower.js（tools/jsgd.js）——唔好直接改，改原 JS 再轉
extends RefCounted

func run(env):
	var this_ = null; var a = []
	J.cl(Callable(self, "_f1").bind(env), null, [])
	var _t1044 = J.G.get("window")
	var _t1045 = {"ppr": {"img": "gb_unit_ppr", "W": 1536.0, "H": 1024.0, "crop": [250.0, 830.0], "floor": 752.0, "ceil": 280.0, "ph": 290.0, "door": 62.0, "rooms": [{"k": "living", "n": "客廳", "x0": 20.0, "x1": 524.0}, {"k": "kitchen", "n": "廚房", "x0": 536.0, "x1": 810.0}, {"k": "bed", "n": "睡房", "x0": 824.0, "x1": 1280.0}, {"k": "bath", "n": "廁所", "x0": 1296.0, "x1": 1520.0}], "spots": [{"k": "lamp", "x": 352.0, "y": 400.0}, {"k": "tv", "x": 474.0, "y": 582.0}, {"k": "tap", "x": 668.0, "y": 572.0}, {"k": "fridge", "x": 770.0, "y": 600.0}, {"k": "wardrobe", "x": 1136.0, "y": 560.0}, {"k": "mirror", "x": 1354.0, "y": 478.0}], "acts": {"sofa": {"x": 330.0, "pose": "sit", "look": "tv"}, "tv": {"x": 356.0, "pose": "sit", "look": "tv"}, "table": {"x": 356.0, "seats": [262.0, 318.0, 398.0, 452.0], "pose": "sit"}, "cook": {"x": 604.0, "look": "tap"}, "sink": {"x": 672.0, "look": "tap"}, "fridge": {"x": 744.0, "look": "fridge"}, "desk": {"x": 872.0, "pose": "sit", "look": "wardrobe"}, "pc": {"x": 872.0, "pose": "sit", "look": "wardrobe"}, "radio": {"x": 356.0, "pose": "sit", "look": "tv"}, "bed": {"x": 1030.0, "pose": "lie", "lift": 66.0}, "shower": {"x": 1440.0}, "wash": {"x": 1352.0, "look": "mirror"}}, "search": [{"x": 456.0, "y": 650.0, "n": "電視櫃"}, {"x": 560.0, "y": 620.0, "n": "碗櫃"}, {"x": 1190.0, "y": 690.0, "n": "衣櫃底"}, {"x": 1358.0, "y": 668.0, "n": "膠桶"}], "steal": {"table": {"x": 356.0, "y": 670.0}, "sofa": {"x": 300.0, "y": 640.0}, "door": {"x": 120.0, "y": 700.0}, "cook": {"x": 600.0, "y": 590.0}, "desk": {"x": 872.0, "y": 600.0}}}, "gamer": {"img": "gb_unit_gamer", "W": 1536.0, "H": 1024.0, "crop": [130.0, 880.0], "floor": 820.0, "ceil": 140.0, "ph": 330.0, "door": 52.0, "rooms": [{"k": "living", "n": "客廳", "x0": 30.0, "x1": 524.0}, {"k": "kitchen", "n": "廚房", "x0": 540.0, "x1": 850.0}, {"k": "bed", "n": "睡房", "x0": 870.0, "x1": 1280.0}, {"k": "bath", "n": "浴室", "x0": 1300.0, "x1": 1520.0}], "spots": [{"k": "pc", "x": 212.0, "y": 530.0}, {"k": "fan", "x": 312.0, "y": 232.0}, {"k": "fridge", "x": 792.0, "y": 560.0}, {"k": "lamp", "x": 1098.0, "y": 524.0}, {"k": "wardrobe", "x": 1190.0, "y": 470.0}, {"k": "shower", "x": 1440.0, "y": 372.0}], "acts": {"pc": {"x": 300.0, "pose": "sit", "look": "pc"}, "desk": {"x": 300.0, "pose": "sit", "look": "pc"}, "sofa": {"x": 430.0, "pose": "sit", "look": "pc"}, "tv": {"x": 430.0, "pose": "sit", "look": "pc"}, "radio": {"x": 452.0, "pose": "sit", "look": "pc"}, "table": {"x": 400.0, "seats": [300.0, 360.0, 420.0, 480.0], "pose": "sit"}, "cook": {"x": 690.0, "look": "fridge"}, "sink": {"x": 640.0}, "fridge": {"x": 760.0, "look": "fridge"}, "bed": {"x": 1000.0, "pose": "lie", "lift": 90.0}, "shower": {"x": 1430.0}, "wash": {"x": 1350.0}}, "search": [{"x": 372.0, "y": 790.0, "n": "零食枱"}, {"x": 610.0, "y": 660.0, "n": "廚櫃"}, {"x": 1220.0, "y": 680.0, "n": "衫籃"}, {"x": 1450.0, "y": 740.0, "n": "水桶"}], "steal": {"pc": {"x": 250.0, "y": 620.0}, "desk": {"x": 250.0, "y": 620.0}, "door": {"x": 110.0, "y": 760.0}, "sofa": {"x": 290.0, "y": 770.0}, "cook": {"x": 660.0, "y": 560.0}}}, "shop": {"img": "gb_unit_shop", "W": 1536.0, "H": 1024.0, "crop": [290.0, 830.0], "floor": 772.0, "ceil": 300.0, "ph": 290.0, "door": 44.0, "rooms": [{"k": "living", "n": "廳", "x0": 20.0, "x1": 464.0}, {"k": "kitchen", "n": "廚房", "x0": 480.0, "x1": 796.0}, {"k": "bed", "n": "睡房", "x0": 810.0, "x1": 1290.0}, {"k": "bath", "n": "沖涼房", "x0": 1300.0, "x1": 1510.0}], "spots": [{"k": "lamp", "x": 262.0, "y": 384.0}, {"k": "radio", "x": 238.0, "y": 582.0}, {"k": "fan", "x": 414.0, "y": 548.0}, {"k": "pots", "x": 552.0, "y": 496.0}, {"k": "net", "x": 1140.0, "y": 530.0}, {"k": "jar", "x": 1424.0, "y": 660.0}], "acts": {"sofa": {"x": 340.0, "pose": "sit", "look": "radio"}, "tv": {"x": 340.0, "pose": "sit", "look": "radio"}, "radio": {"x": 300.0, "pose": "sit", "look": "radio"}, "table": {"x": 270.0, "seats": [150.0, 220.0, 320.0, 380.0], "pose": "sit"}, "cook": {"x": 600.0, "look": "pots"}, "sink": {"x": 700.0}, "fridge": {"x": 700.0}, "desk": {"x": 860.0, "pose": "sit"}, "pc": {"x": 860.0, "pose": "sit"}, "bed": {"x": 1120.0, "pose": "lie", "lift": 80.0}, "shower": {"x": 1380.0, "look": "jar"}, "wash": {"x": 1460.0}}, "search": [{"x": 170.0, "y": 640.0, "n": "木櫃"}, {"x": 680.0, "y": 610.0, "n": "碗櫃"}, {"x": 1200.0, "y": 716.0, "n": "樟木槓"}, {"x": 1470.0, "y": 730.0, "n": "水桶"}], "steal": {"table": {"x": 270.0, "y": 680.0}, "sofa": {"x": 150.0, "y": 690.0}, "door": {"x": 90.0, "y": 740.0}, "cook": {"x": 590.0, "y": 640.0}, "desk": {"x": 856.0, "y": 610.0}}}}
	J.sp(_t1044, "UNIT_LAYOUTS", _t1045)
	J.cl(Callable(self, "_f167").bind(env), null, [])
	J.G["Tower"] = J.cl(Callable(self, "_f336").bind(env), null, [])

func _f4(this_, a: Array, env):
	var v___119 = null; var v_i_120 = null
	v___119 = J.arg(a, 0)
	v_i_120 = J.arg(a, 1)
	return v_i_120

func _f3(this_, a: Array, env):
	var v_k_111 = null; var v_p_112 = null; var v_a_113 = null; var v_i_114 = null; var v_j_115 = null; var v_t_116 = null
	v_k_111 = J.arg(a, 0)
	v_p_112 = J.gp(env["LN"], v_k_111)
	var _t2 = (not J.t(J.gp(env["lnUsed"], v_k_111)))
	if (_t2 if _t2 else (not J.t(J.len(J.gp(env["lnUsed"], v_k_111))))):
		v_a_113 = J.mc(v_p_112, "map", [Callable(self, "_f4").bind(env)])
		v_i_114 = (J.len(v_a_113) - 1.0)
		while true:
			if not J.cmp(v_i_114, 0.0, ">"): break
			v_j_115 = floor(J.num(J.mul(randf(), J.add(v_i_114, 1.0))))
			v_t_116 = J.gp(v_a_113, v_i_114)
			var _t3 = J.gp(v_a_113, v_j_115)
			J.sp(v_a_113, v_i_114, _t3)
			J.sp(v_a_113, v_j_115, v_t_116)
			v_i_114 = J.num(v_i_114) + -1.0
		var _t4 = env["lnUsed"]
		J.sp(_t4, v_k_111, v_a_113)
	return J.gp(v_p_112, J.mc(J.gp(env["lnUsed"], v_k_111), "pop", []))

func _f5(this_, a: Array, env):
	var v_e_123 = null; var v_e_124 = null
	if (not J.t(env["AC"])):
		var _t5 = J.gp(J.G.get("window"), "AudioContext")
		var _t6 = J.construct((_t5 if J.t(_t5) else J.gp(J.G.get("window"), "webkitAudioContext")), [])
		env["AC"] = _t6
	if J.t((J.seq(J.gp(env["AC"], "state"), "suspended") if J.t(env["AC"]) else env["AC"])):
		J.mc(env["AC"], "resume", [])
	return env["AC"]

func _f6(this_, a: Array, env):
	var v_c_127 = null; var v_d_128 = null; var v_i_129 = null
	v_c_127 = J.arg(a, 0)
	if (not J.t(env["noiseBuf"])):
		var _t7 = J.mc(v_c_127, "createBuffer", [1.0, J.mul(J.gp(v_c_127, "sampleRate"), 2.0), J.gp(v_c_127, "sampleRate")])
		env["noiseBuf"] = _t7
		v_d_128 = J.mc(env["noiseBuf"], "getChannelData", [0.0])
		v_i_129 = 0.0
		while true:
			if not J.cmp(v_i_129, J.len(v_d_128), "<"): break
			var _t8 = ((randf() * 2.0) - 1.0)
			J.sp(v_d_128, v_i_129, _t8)
			v_i_129 = J.num(v_i_129) + 1.0
	return env["noiseBuf"]

func _f7(this_, a: Array, env):
	var v_f_132 = null; var v_t0_133 = null; var v_dur_134 = null; var v_vol_135 = null; var v_type_136 = null; var v_c_137 = null; var v_o_138 = null; var v_g_139 = null; var v_e_140 = null
	v_f_132 = J.arg(a, 0)
	v_t0_133 = J.arg(a, 1)
	v_dur_134 = J.arg(a, 2)
	v_vol_135 = J.arg(a, 3)
	v_type_136 = J.arg(a, 4)
	v_c_137 = J.cl(env["ac"], null, [])
	if (not J.t(v_c_137)):
		return null
	v_o_138 = J.mc(v_c_137, "createOscillator", [])
	v_g_139 = J.mc(v_c_137, "createGain", [])
	var _t9 = (v_type_136 if J.t(v_type_136) else "sine")
	J.sp(v_o_138, "type", _t9)
	var _t10 = J.gp(v_o_138, "frequency")
	J.sp(_t10, "value", v_f_132)
	var _t11 = J.gp(v_g_139, "gain")
	J.mc(_t11, "setValueAtTime", [0.0001, J.add(J.gp(v_c_137, "currentTime"), v_t0_133)])
	var _t12 = J.gp(v_g_139, "gain")
	J.mc(_t12, "exponentialRampToValueAtTime", [v_vol_135, J.add(J.add(J.gp(v_c_137, "currentTime"), v_t0_133), 0.01)])
	var _t13 = J.gp(v_g_139, "gain")
	J.mc(_t13, "exponentialRampToValueAtTime", [0.0001, J.add(J.add(J.gp(v_c_137, "currentTime"), v_t0_133), v_dur_134)])
	J.mc(v_o_138, "connect", [v_g_139])
	J.mc(v_g_139, "connect", [J.gp(v_c_137, "destination")])
	J.mc(v_o_138, "start", [J.add(J.gp(v_c_137, "currentTime"), v_t0_133)])
	J.mc(v_o_138, "stop", [J.add(J.add(J.add(J.gp(v_c_137, "currentTime"), v_t0_133), v_dur_134), 0.05)])

func _f8(this_, a: Array, env):
	var v_t0_143 = null; var v_dur_144 = null; var v_vol_145 = null; var v_freq_146 = null; var v_q_147 = null; var v_c_148 = null; var v_s_149 = null; var v_bp_150 = null; var v_g_151 = null; var v_T_152 = null; var v_e_153 = null
	v_t0_143 = J.arg(a, 0)
	v_dur_144 = J.arg(a, 1)
	v_vol_145 = J.arg(a, 2)
	v_freq_146 = J.arg(a, 3)
	v_q_147 = J.arg(a, 4)
	v_c_148 = J.cl(env["ac"], null, [])
	if (not J.t(v_c_148)):
		return null
	v_s_149 = J.mc(v_c_148, "createBufferSource", [])
	var _t14 = env["nbuf"]
	var _t15 = J.cl(_t14, null, [v_c_148])
	J.sp(v_s_149, "buffer", _t15)
	J.sp(v_s_149, "loop", true)
	v_bp_150 = J.mc(v_c_148, "createBiquadFilter", [])
	J.sp(v_bp_150, "type", "bandpass")
	var _t16 = J.gp(v_bp_150, "frequency")
	var _t17 = (v_freq_146 if J.t(v_freq_146) else 900.0)
	J.sp(_t16, "value", _t17)
	var _t18 = J.gp(v_bp_150, "Q")
	var _t19 = (v_q_147 if J.t(v_q_147) else 0.8)
	J.sp(_t18, "value", _t19)
	v_g_151 = J.mc(v_c_148, "createGain", [])
	v_T_152 = J.add(J.gp(v_c_148, "currentTime"), v_t0_143)
	var _t20 = J.gp(v_g_151, "gain")
	J.mc(_t20, "setValueAtTime", [0.0001, v_T_152])
	var _t21 = J.gp(v_g_151, "gain")
	J.mc(_t21, "linearRampToValueAtTime", [v_vol_145, J.add(v_T_152, J.mul(v_dur_144, 0.3))])
	var _t22 = J.gp(v_g_151, "gain")
	J.mc(_t22, "linearRampToValueAtTime", [0.0001, J.add(v_T_152, v_dur_144)])
	J.mc(v_s_149, "connect", [v_bp_150])
	J.mc(v_bp_150, "connect", [v_g_151])
	J.mc(v_g_151, "connect", [J.gp(v_c_148, "destination")])
	J.mc(v_s_149, "start", [v_T_152])
	J.mc(v_s_149, "stop", [J.add(J.add(v_T_152, v_dur_144), 0.05)])
	return v_g_151

func _f17(this_, a: Array, env):
	return J.gp(env["A"], "G")

func _f18(this_, a: Array, env):
	return J.gp(env["A"], "FL")

func _f19(this_, a: Array, env):
	return J.sub(J.cl(env["FL"], null, []), 1.0)

func _f20(this_, a: Array, env):
	var v_f_187 = null
	v_f_187 = J.arg(a, 0)
	return ("B" if J.seq(v_f_187, 0.0) else ("G" if J.seq(v_f_187, 1.0) else J.F_String([J.sub(v_f_187, 1.0)])))

func _f21(this_, a: Array, env):
	var v_p_190 = null; var v_a_191 = null; var v_b_192 = null; var v_fr_193 = null
	v_p_190 = J.arg(a, 0)
	v_a_191 = floor(J.num(v_p_190))
	v_b_192 = J.min_([J.cl(env["top"], null, []), J.add(v_a_191, 1.0)])
	v_fr_193 = J.sub(v_p_190, v_a_191)
	return J.add(J.mc(env["A"], "fy", [v_a_191]), J.mul(J.sub(J.mc(env["A"], "fy", [v_b_192]), J.mc(env["A"], "fy", [v_a_191])), v_fr_193))

func _f23(this_, a: Array, env):
	var v_q_199 = null
	v_q_199 = J.arg(a, 0)
	return J.seq(J.gp(v_q_199, 2.0), "lift")

func _f22(this_, a: Array, env):
	var v_c_196 = null
	var _t23 = J.gp(J.gp(env["A"], "LV"), "xs")
	var _t24 = (_t23 if J.t(_t23) else [])
	v_c_196 = J.mc(_t24, "find", [Callable(self, "_f23").bind(env)])
	return ({"x0": J.gp(v_c_196, 0.0), "x1": J.gp(v_c_196, 1.0), "cx": J.div(J.add(J.gp(v_c_196, 0.0), J.gp(v_c_196, 1.0)), 2.0)} if J.t(v_c_196) else {"x0": J.sub(J.gp(J.gp(env["A"], "LV"), "MX"), 42.0), "x1": J.add(J.gp(J.gp(env["A"], "LV"), "MX"), 42.0), "cx": J.gp(J.gp(env["A"], "LV"), "MX")})

func _f24(this_, a: Array, env):
	return absf(J.num(J.sub(J.mc(env["A"], "fy", [0.0]), J.mc(env["A"], "fy", [1.0]))))

func _f25(this_, a: Array, env):
	return (J.mc(env["A"], "rnd", []) if J.t(J.gp(env["A"], "rnd")) else randf())

func _f26(this_, a: Array, env):
	var v_a_206 = null
	v_a_206 = J.arg(a, 0)
	return J.gp(v_a_206, floor(J.num(J.mul(J.cl(env["rnd"], null, []), J.len(v_a_206)))))

func _f27(this_, a: Array, env):
	return J.round(J.num(J.gp(env["S"], "pos")))

func _f28(this_, a: Array, env):
	return (absf(J.num(J.sub(J.gp(env["S"], "pos"), J.round(J.num(J.gp(env["S"], "pos")))))) < 0.002)

func _f29(this_, a: Array, env):
	return (J.gp(J.gp(J.cl(env["G"], null, []), "gh"), J.gp(env["S"], "gi")) if J.t(((not J.leq(J.gp(env["S"], "gi"), null)) if J.t(env["S"]) else env["S"])) else null)

func _f30(this_, a: Array, env):
	var v_e_215 = null
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
	var v_o_218 = null; var v_t_219 = null
	v_o_218 = J.arg(a, 0)
	v_t_219 = J.arg(a, 1)
	J.sp(v_o_218, "say", v_t_219)
	J.sp(v_o_218, "sayT", 2.8)

func _f32(this_, a: Array, env):
	var v_x_222 = null; var v_y_223 = null; var v_t_224 = null; var v_c_225 = null; var v_e_226 = null
	v_x_222 = J.arg(a, 0)
	v_y_223 = J.arg(a, 1)
	v_t_224 = J.arg(a, 2)
	v_c_225 = J.arg(a, 3)
	J.mc(env["A"], "float", [v_x_222, v_y_223, v_t_224, v_c_225])

func _f33(this_, a: Array, env):
	var v_o_229 = null
	v_o_229 = J.arg(a, 0)
	var _t33 = null
	if J.seq(J.gp(v_o_229, "kind"), "guard"):
		var _t30 = J.gp(env["A"], "HUM")
		var _t31 = (J.gp(J.gp(env["A"], "HUM"), J.gp(J.gp(v_o_229, "ref"), "kind")) if J.t(_t30) else _t30)
		var _t32 = (J.gp(J.gp(J.gp(env["A"], "HUM"), J.gp(J.gp(v_o_229, "ref"), "kind")), "spr") if J.t(_t31) else _t31)
		_t33 = (_t32 if J.t(_t32) else "res_guard")
	else:
		_t33 = J.gp(J.gp(v_o_229, "ref"), "sprite")
	return _t33

func _f34(this_, a: Array, env):
	var v_o_232 = null; var v_k_233 = null; var v_F_234 = null
	v_o_232 = J.arg(a, 0)
	var _t34 = env["riderSpr"]
	v_k_233 = J.cl(_t34, null, [v_o_232])
	v_F_234 = J.gp(J.G.get("window"), "PPLFX")
	var _t36 = null
	if J.t(v_F_234):
		var _t35 = J.seq(J.gp(v_o_232, "mood"), "bolt")
		_t36 = J.mc(v_F_234, "key", [v_k_233, (_t35 if _t35 else J.seq(J.gp(v_o_232, "mood"), "cower"))])
	else:
		_t36 = v_k_233
	return _t36

func _f35(this_, a: Array, env):
	var v_o_237 = null; var v_k_238 = null; var v_h_239 = null; var v_F_240 = null
	v_o_237 = J.arg(a, 0)
	v_k_238 = J.arg(a, 1)
	v_h_239 = J.arg(a, 2)
	v_F_240 = J.gp(J.G.get("window"), "PPLFX")
	var _t38 = null
	if J.t(v_F_240):
		var _t37 = env["riderSpr"]
		_t38 = J.mc(v_F_240, "hgt", [J.cl(_t37, null, [v_o_237]), v_k_238, v_h_239])
	else:
		_t38 = v_h_239
	return _t38

func _f37(this_, a: Array, env):
	var v_o_245 = null
	v_o_245 = J.arg(a, 0)
	return J.seq(J.gp(v_o_245, "ph"), "ride")

func _f36(this_, a: Array, env):
	var _t39 = J.gp(env["S"], "riders")
	return J.mc(_t39, "filter", [Callable(self, "_f37").bind(env)])

func _f39(this_, a: Array, env):
	var v_o_250 = null
	v_o_250 = J.arg(a, 0)
	return J.seq(J.gp(v_o_250, "kind"), "res")

func _f38(this_, a: Array, env):
	var _t40 = J.cl(env["inCab"], null, [])
	return J.mc(_t40, "filter", [Callable(self, "_f39").bind(env)])

func _f41(this_, a: Array, env):
	var v_k_255 = null
	v_k_255 = J.arg(a, 0)
	var _t45 = J.gp(env["S"], "cd")
	J.sp(_t45, v_k_255, 0.0)

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
	var v_o_263 = null
	v_o_263 = J.arg(a, 0)
	if J.seq(J.gp(v_o_263, "ph"), "ride"):
		var _t49 = env["w"]
		var _t50 = J.gp(v_o_263, "dest")
		J.sp(_t49, _t50, 1.0)
	var _t51 = J.seq(J.gp(v_o_263, "ph"), "wait")
	if (J.cmp(env["room"], 0.0, ">") if _t51 else _t51):
		var _t52 = env["w"]
		var _t53 = J.gp(v_o_263, "f")
		J.sp(_t52, _t53, 1.0)

func _f42(this_, a: Array, env):
	var v_k_259 = null
	var _s74 = {"__p": env, "w": null, "room": null}
	_s74["w"] = {}
	for _t46 in J.keys(J.gp(_s74["__p"]["S"], "stops")):
		v_k_259 = _t46
		var _t47 = _s74["w"]
		J.sp(_t47, v_k_259, 1.0)
	_s74["room"] = J.sub(_s74["__p"]["CAP"], J.len(J.cl(_s74["__p"]["inCab"], null, [])))
	var _t48 = J.gp(_s74["__p"]["S"], "riders")
	J.mc(_t48, "forEach", [Callable(self, "_f43").bind(_s74)])
	if (not J.leq(J.gp(_s74["__p"]["S"], "gCall"), null)):
		var _t54 = _s74["w"]
		var _t55 = J.gp(_s74["__p"]["S"], "gCall")
		J.sp(_t54, _t55, 1.0)
	return _s74["w"]

func _f45(this_, a: Array, env):
	var v_f_274 = null
	v_f_274 = J.arg(a, 0)
	var _t58 = J.cmp(v_f_274, 0.0, ">=")
	return (J.cmp(v_f_274, J.cl(env["__p"]["top"], null, []), "<=") if _t58 else _t58)

func _f46(this_, a: Array, env):
	var v_f_277 = null
	v_f_277 = J.arg(a, 0)
	var _t59 = (absf(J.num(J.sub(v_f_277, env["p"]))) > 0.01)
	return (_t59 if _t59 else J.seq(J.gp(env["__p"]["S"], "st"), "idle"))

func _f47(this_, a: Array, env):
	var v_f_280 = null
	v_f_280 = J.arg(a, 0)
	return J.cmp(v_f_280, J.add(env["p"], 0.01), ">")

func _f48(this_, a: Array, env):
	var v_a_283 = null; var v_b_284 = null
	v_a_283 = J.arg(a, 0)
	v_b_284 = J.arg(a, 1)
	return J.sub(v_a_283, v_b_284)

func _f49(this_, a: Array, env):
	var v_f_287 = null
	v_f_287 = J.arg(a, 0)
	return J.cmp(v_f_287, J.sub(env["p"], 0.01), "<")

func _f50(this_, a: Array, env):
	var v_a_290 = null; var v_b_291 = null
	v_a_290 = J.arg(a, 0)
	v_b_291 = J.arg(a, 1)
	return J.sub(v_b_291, v_a_290)

func _f51(this_, a: Array, env):
	var v_f_294 = null
	v_f_294 = J.arg(a, 0)
	return (absf(J.num(J.sub(v_f_294, env["p"]))) <= 0.01)

func _f44(this_, a: Array, env):
	var v_w_266 = null; var v_keys_267 = null; var v_up_269 = null; var v_dn_270 = null; var v_here_271 = null
	var _s77 = {"__p": env, "p": null}
	v_w_266 = J.cl(_s77["__p"]["wanted"], null, [])
	var _t56 = J.S_Object_("keys", [v_w_266])
	var _t57 = J.mc(_t56, "map", [J.G.get("Number")])
	v_keys_267 = J.mc(_t57, "filter", [Callable(self, "_f45").bind(_s77)])
	_s77["p"] = J.gp(_s77["__p"]["S"], "pos")
	var _t60 = J.mc(v_keys_267, "filter", [Callable(self, "_f46").bind(_s77)])
	v_keys_267 = _t60
	if (not J.t(J.len(v_keys_267))):
		return null
	var _t61 = J.mc(v_keys_267, "filter", [Callable(self, "_f47").bind(_s77)])
	v_up_269 = J.mc(_t61, "sort", [Callable(self, "_f48").bind(_s77)])
	var _t62 = J.mc(v_keys_267, "filter", [Callable(self, "_f49").bind(_s77)])
	v_dn_270 = J.mc(_t62, "sort", [Callable(self, "_f50").bind(_s77)])
	v_here_271 = J.mc(v_keys_267, "filter", [Callable(self, "_f51").bind(_s77)])
	var _t63 = J.len(v_here_271)
	if J.t((J.seq(J.gp(_s77["__p"]["S"], "st"), "idle") if J.t(_t63) else _t63)):
		return J.gp(v_here_271, 0.0)
	var _t64 = J.cmp(J.gp(_s77["__p"]["S"], "dir"), 0.0, ">=")
	if J.t((J.len(v_up_269) if _t64 else _t64)):
		return J.gp(v_up_269, 0.0)
	var _t65 = J.cmp(J.gp(_s77["__p"]["S"], "dir"), 0.0, "<=")
	if J.t((J.len(v_dn_270) if _t65 else _t65)):
		return J.gp(v_dn_270, 0.0)
	return (J.gp(v_up_269, 0.0) if J.t(J.len(v_up_269)) else (J.gp(v_dn_270, 0.0) if J.t(J.len(v_dn_270)) else null))

func _f52(this_, a: Array, env):
	var v_t_297 = null
	v_t_297 = J.arg(a, 0)
	var _t66 = env["S"]
	J.sp(_t66, "target", v_t_297)
	var _t67 = env["S"]
	var _t68 = (1.0 if J.cmp(v_t_297, J.gp(env["S"], "pos"), ">") else (-1.0))
	J.sp(_t67, "dir", _t68)
	var _t69 = env["S"]
	J.sp(_t69, "st", "move")
	J.mc(env["SND"], "hum", [true])

func _f54(this_, a: Array, env):
	var v_o_307 = null
	v_o_307 = J.arg(a, 0)
	var _t77 = J.seq(J.gp(v_o_307, "ph"), "wait")
	return (J.seq(J.gp(v_o_307, "f"), env["f"]) if _t77 else _t77)

func _f53(this_, a: Array, env):
	var v_c_301 = null; var v_y_302 = null; var v_g_303 = null; var v_hasPeople_304 = null; var v_e_308 = null
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
	v_c_301 = J.cl(_s86["__p"]["col"], null, [])
	v_y_302 = J.mc(_s86["__p"]["A"], "fy", [_s86["f"]])
	v_g_303 = J.cl(_s86["__p"]["ghost"], null, [])
	var _t78 = J.len(J.cl(_s86["__p"]["inCab"], null, []))
	if not J.t(_t78):
		var _t76 = J.gp(_s86["__p"]["S"], "riders")
		_t78 = J.mc(_t76, "some", [Callable(self, "_f54").bind(_s86)])
	v_hasPeople_304 = _t78
	var _t79 = (not J.t(v_g_303))
	if ((not J.t(v_hasPeople_304)) if _t79 else _t79):
		J.mc(_s86["__p"]["A"], "noise", [(J.add("f", _s86["f"]) + "_l"), 2.0])
		var _t80 = _s86["__p"]["fl"]
		var _t82 = J.gp(v_c_301, "cx")
		var _t83 = J.sub(v_y_302, 90.0)
		var _t81 = _s86["__p"]["lab"]
		J.cl(_t80, null, [_t82, _t83, (J.add("叮——（", J.cl(_t81, null, [_s86["f"]])) + " 樓𨋢門自己開咗）"), "#ffd54a"])

func _f56(this_, a: Array, env):
	var v_o_318 = null
	v_o_318 = J.arg(a, 0)
	var _t89 = J.seq(J.gp(v_o_318, "dest"), env["f"])
	var _t90 = (_t89 if _t89 else J.seq(J.gp(v_o_318, "mood"), "bolt"))
	return (_t90 if _t90 else J.seq(J.gp(v_o_318, "mood"), "mroom"))

func _f57(this_, a: Array, env):
	var v_o_321 = null
	v_o_321 = J.arg(a, 0)
	var _t96 = J.seq(J.gp(v_o_321, "ph"), "wait")
	return (J.seq(J.gp(v_o_321, "f"), env["f"]) if _t96 else _t96)

func _f55(this_, a: Array, env):
	var v_dt_311 = null; var v_c_313 = null; var v_out_314 = null; var v_w_315 = null
	var _s92 = {"__p": env, "f": null}
	v_dt_311 = J.arg(a, 0)
	_s92["f"] = J.cl(_s92["__p"]["cabF"], null, [])
	v_c_313 = J.cl(_s92["__p"]["col"], null, [])
	var _t84 = _s92["__p"]["S"]
	var _t85 = J.gp(_s92["__p"]["S"], "xT")
	var _t86 = J.sub((_t85 if J.t(_t85) else 0.0), v_dt_311)
	J.sp(_t84, "xT", _t86)
	if J.cmp(J.gp(_s92["__p"]["S"], "xT"), 0.0, ">"):
		return null
	var _t87 = _s92["__p"]["S"]
	J.sp(_t87, "xT", 0.35)
	var _t88 = J.cl(_s92["__p"]["inCab"], null, [])
	v_out_314 = J.mc(_t88, "find", [Callable(self, "_f56").bind(_s92)])
	if J.t(v_out_314):
		var _t91 = _s92["__p"]["exitRider"]
		J.cl(_t91, null, [v_out_314, _s92["f"]])
		var _t92 = _s92["__p"]["dingFx"]
		J.cl(_t92, null, [_s92["f"], true])
		var _t93 = _s92["__p"]["S"]
		var _t94 = J.max_([J.gp(_s92["__p"]["S"], "hold"), 1.0])
		J.sp(_t93, "hold", _t94)
		return null
	var _t95 = J.gp(_s92["__p"]["S"], "riders")
	v_w_315 = J.mc(_t95, "find", [Callable(self, "_f57").bind(_s92)])
	if J.t(v_w_315):
		if J.cmp(J.len(J.cl(_s92["__p"]["inCab"], null, [])), _s92["__p"]["CAP"], ">="):
			if (not J.t(J.gp(v_w_315, "fullSaid"))):
				J.sp(v_w_315, "fullSaid", 1.0)
				var _t97 = _s92["__p"]["sayR"]
				var _t98 = _s92["__p"]["line"]
				J.cl(_t97, null, [v_w_315, J.cl(_t98, null, ["full"])])
			return null
		J.sp(v_w_315, "ph", "ride")
		var _t99 = _s92["__p"]["dingFx"]
		J.cl(_t99, null, [_s92["f"], true])
		var _t100 = J.add(J.gp(v_c_313, "cx"), ((J.len(J.cl(_s92["__p"]["inCab"], null, [])) - 1.5) * 10.0))
		J.sp(v_w_315, "x", _t100)
		var _t101 = _s92["__p"]["sayR"]
		var _t104 = null
		if J.cmp(J.cl(_s92["__p"]["rnd"], null, []), 0.5, "<"):
			var _t102 = _s92["__p"]["line"]
			_t104 = J.cl(_t102, null, ["board"])
		else:
			var _t103 = _s92["__p"]["lab"]
			_t104 = J.add(J.cl(_t103, null, [J.gp(v_w_315, "dest")]), "樓，唔該")
		J.cl(_t101, null, [v_w_315, _t104])
		var _t105 = _s92["__p"]["S"]
		var _t106 = J.max_([J.gp(_s92["__p"]["S"], "hold"), 1.2])
		J.sp(_t105, "hold", _t106)

func _f58(this_, a: Array, env):
	var v_o_324 = null; var v_f_325 = null; var v_c_326 = null; var v_y_327 = null; var v_g0_328 = null; var v_h_329 = null; var v_r_330 = null
	v_o_324 = J.arg(a, 0)
	v_f_325 = J.arg(a, 1)
	v_c_326 = J.cl(env["col"], null, [])
	v_y_327 = J.mc(env["A"], "fy", [v_f_325])
	v_g0_328 = J.cl(env["G"], null, [])
	var _t107 = J.gp(env["S"], "riders")
	var _t108 = J.gp(env["S"], "riders")
	J.mc(_t107, "splice", [J.mc(_t108, "indexOf", [v_o_324]), 1.0])
	if J.seq(J.gp(v_o_324, "kind"), "guard"):
		v_h_329 = J.gp(v_o_324, "ref")
		J.sp(v_h_329, "to", null)
		J.sp(v_h_329, "path", null)
		J.sp(v_h_329, "p", 0.0)
		var _t109 = (J.add("f", v_f_325) + "_l")
		J.sp(v_h_329, "node", _t109)
		var _t110 = J.gp(v_c_326, "cx")
		J.sp(v_h_329, "x", _t110)
		J.sp(v_h_329, "y", v_y_327)
		J.sp(v_h_329, "wait", 0.8)
		if J.seq(J.gp(v_o_324, "mood"), "mroom"):
			var _t111 = J.gp(env["S"], "mroom")
			J.mc(_t111, "push", [{"h": v_h_329, "t": 22.0}])
			var _t112 = env["fl"]
			J.cl(_t112, null, [J.gp(v_c_326, "cx"), J.sub(v_y_327, 110.0), "保安去咗機房（離開巡邏 22 秒）", "#9fd6bf"])
			var _t113 = env["log"]
			J.cl(_t113, null, ["mroom"])
			return null
		J.sp(v_h_329, "state", "patrol")
		var _t114 = J.gp(v_g0_328, "guards")
		J.mc(_t114, "push", [v_h_329])
		return null
	v_r_330 = J.gp(v_o_324, "ref")
	var _t115 = J.sub(v_y_327, 16.0)
	J.sp(v_r_330, "y", _t115)
	if J.seq(J.gp(v_o_324, "mood"), "bolt"):
		J.sp(v_r_330, "state", "flee")
		var _t116 = (((-1.0) if J.cmp(J.cl(env["rnd"], null, []), 0.5, "<") else 1.0) * 150.0)
		J.sp(v_r_330, "vx", _t116)
		var _t117 = J.gp(v_c_326, "cx")
		J.sp(v_r_330, "x", _t117)
		var _t118 = J.gp(v_g0_328, "res")
		J.mc(_t118, "push", [v_r_330])
		if J.t(J.gp(J.G.get("window"), "PPLFX")):
			J.mc(J.G.get("PPLFX"), "screamOn", [v_r_330])
		else:
			var _t119 = env["sayR"]
			var _t120 = env["line"]
			J.cl(_t119, null, [v_r_330, J.cl(_t120, null, ["bolt"])])
		J.sp(v_r_330, "sayT", 2.4)
		var _t121 = env["log"]
		J.cl(_t121, null, ["bolt"])
		return null
	if J.seq(J.gp(v_o_324, "trip"), "back"):
		J.sp(v_o_324, "ph", "walkHome")
		J.sp(v_o_324, "f", v_f_325)
		var _t122 = J.gp(v_c_326, "cx")
		J.sp(v_o_324, "x", _t122)
		var _t123 = J.gp(env["S"], "riders")
		J.mc(_t123, "push", [v_o_324])
		return null
	if J.seq(J.gp(v_o_324, "trip"), "snack"):
		var _t124 = J.gp(env["S"], "away")
		J.mc(_t124, "push", [{"o": v_o_324, "t": (16.0 + J.mul(J.cl(env["rnd"], null, []), 12.0))}])

func _f60(this_, a: Array, env):
	var v_r_339 = null
	v_r_339 = J.arg(a, 0)
	var _t128 = J.seq(J.gp(v_r_339, "state"), "home")
	var _t129 = ((not J.seq(J.gp(v_r_339, "awake"), false)) if _t128 else _t128)
	var _t130 = ((not J.cmp(J.gp(v_r_339, "fear"), 40.0, ">")) if _t129 else _t129)
	var _t131 = (J.gp(v_r_339, "unit") if _t130 else _t130)
	var _t132 = (J.cmp(J.gp(J.gp(v_r_339, "unit"), "f"), 2.0, ">=") if J.t(_t131) else _t131)
	var _t133 = (J.cmp(J.gp(J.gp(v_r_339, "unit"), "f"), J.cl(env["top"], null, []), "<=") if J.t(_t132) else _t132)
	var _t134 = ((not J.t(J.gp(v_r_339, "liftUsed"))) if J.t(_t133) else _t133)
	return ((not J.seq(J.gp(J.gp(v_r_339, "unit"), "ot"), "deity")) if J.t(_t134) else _t134)

func _f59(this_, a: Array, env):
	var v_g0_333 = null; var v_ph_334 = null; var v_cand_335 = null; var v_r_336 = null
	v_g0_333 = J.cl(env["G"], null, [])
	var _t125 = J.gp(v_g0_333, "phase")
	var _t126 = J.gp(v_g0_333, "phase")
	v_ph_334 = J.min_([2.0, (_t126 if J.t(_t126) else 0.0)])
	var _t127 = J.gp(v_g0_333, "res")
	v_cand_335 = J.mc(_t127, "filter", [Callable(self, "_f60").bind(env)])
	if (not J.t(J.len(v_cand_335))):
		return null
	var _t135 = env["pick"]
	v_r_336 = J.cl(_t135, null, [v_cand_335])
	var _t136 = env["addResRider"]
	return J.cl(_t136, null, [v_r_336, "snack"])

func _f61(this_, a: Array, env):
	var v_r_342 = null; var v_trip_343 = null; var v_dest_344 = null; var v_g0_345 = null; var v_i_346 = null; var v_o_347 = null
	v_r_342 = J.arg(a, 0)
	v_trip_343 = J.arg(a, 1)
	v_dest_344 = J.arg(a, 2)
	v_g0_345 = J.cl(env["G"], null, [])
	var _t137 = J.gp(v_g0_345, "res")
	v_i_346 = J.mc(_t137, "indexOf", [v_r_342])
	if J.cmp(v_i_346, 0.0, ">="):
		var _t138 = J.gp(v_g0_345, "res")
		J.mc(_t138, "splice", [v_i_346, 1.0])
	J.sp(v_r_342, "state", "lift")
	J.sp(v_r_342, "liftUsed", 1.0)
	v_o_347 = {"kind": "res", "ref": v_r_342, "f": J.gp(J.gp(v_r_342, "unit"), "f"), "dest": (v_dest_344 if (not J.leq(v_dest_344, null)) else 1.0), "ph": "walk", "x": J.gp(v_r_342, "x"), "trip": (v_trip_343 if J.t(v_trip_343) else "snack"), "fear": 0.0, "mood": "ok", "say": null, "sayT": 0.0}
	var _t139 = env["sayR"]
	var _t140 = env["line"]
	J.cl(_t139, null, [v_o_347, J.cl(_t140, null, [("work" if J.seq(J.gp(v_o_347, "trip"), "work") else "snack")])])
	var _t141 = J.gp(env["S"], "riders")
	J.mc(_t141, "push", [v_o_347])
	return v_o_347

func _f63(this_, a: Array, env):
	var v_h_356 = null; var v_n_357 = null
	v_h_356 = J.arg(a, 0)
	v_n_357 = J.gp(J.gp(env["g0"], "nodes"), J.gp(v_h_356, "node"))
	var _t143 = J.seq(J.gp(v_h_356, "kind"), "guard")
	var _t144 = (J.seq(J.gp(v_h_356, "state"), "patrol") if _t143 else _t143)
	var _t145 = (v_n_357 if _t144 else _t144)
	var _t146 = (J.cmp(J.gp(v_n_357, "f"), J.cl(env["__p"]["top"], null, []), "<=") if J.t(_t145) else _t145)
	var _t147 = ((absf(J.num(J.sub(J.gp(v_h_356, "x"), J.gp(env["c"], "cx")))) < 240.0) if J.t(_t146) else _t146)
	return ((not J.t(J.gp(v_h_356, "liftCd"))) if J.t(_t147) else _t147)

func _f62(this_, a: Array, env):
	var v_cand_352 = null; var v_h_353 = null
	var _s107 = {"__p": env, "g0": null, "c": null}
	_s107["g0"] = J.cl(_s107["__p"]["G"], null, [])
	_s107["c"] = J.cl(_s107["__p"]["col"], null, [])
	var _t142 = J.gp(_s107["g0"], "guards")
	v_cand_352 = J.mc(_t142, "filter", [Callable(self, "_f63").bind(_s107)])
	if (not J.t(J.len(v_cand_352))):
		return null
	var _t148 = _s107["__p"]["pick"]
	v_h_353 = J.cl(_t148, null, [v_cand_352])
	var _t149 = _s107["__p"]["addGuardRider"]
	return J.cl(_t149, null, [v_h_353])

func _f64(this_, a: Array, env):
	var v_h_360 = null; var v_dest_361 = null; var v_g0_362 = null; var v_n_363 = null; var v_i_364 = null; var v_f_365 = null; var v_d_366 = null; var v_o_367 = null
	v_h_360 = J.arg(a, 0)
	v_dest_361 = J.arg(a, 1)
	v_g0_362 = J.cl(env["G"], null, [])
	v_n_363 = J.gp(J.gp(v_g0_362, "nodes"), J.gp(v_h_360, "node"))
	var _t150 = J.gp(v_g0_362, "guards")
	v_i_364 = J.mc(_t150, "indexOf", [v_h_360])
	if J.cmp(v_i_364, 0.0, ">="):
		var _t151 = J.gp(v_g0_362, "guards")
		J.mc(_t151, "splice", [v_i_364, 1.0])
	v_f_365 = (J.gp(v_n_363, "f") if J.t(v_n_363) else 1.0)
	v_d_366 = v_dest_361
	if J.leq(v_d_366, null):
		var _t152 = true
		while true:
			if not _t152:
				var _t153 = J.seq(v_d_366, v_f_365)
				if not (J.cmp(J.cl(env["top"], null, []), 0.0, ">") if _t153 else _t153): break
			_t152 = false
			var _t154 = floor(J.num(J.mul(J.cl(env["rnd"], null, []), J.add(J.cl(env["top"], null, []), 1.0))))
			v_d_366 = _t154
	v_o_367 = {"kind": "guard", "ref": v_h_360, "f": v_f_365, "dest": v_d_366, "ph": "walk", "x": J.gp(v_h_360, "x"), "trip": "patrol", "mood": "ok", "say": null, "sayT": 0.0}
	var _t155 = env["sayR"]
	var _t156 = env["line"]
	J.cl(_t155, null, [v_o_367, J.cl(_t156, null, ["gRide"])])
	var _t157 = J.gp(env["S"], "riders")
	J.mc(_t157, "push", [v_o_367])
	return v_o_367

func _f67(this_, a: Array, env):
	var v_g_379 = null; var v_f_380 = null
	v_g_379 = J.arg(a, 0)
	v_f_380 = J.arg(a, 1)
	var _t158 = env["S"]
	var _t159 = J.gp(v_g_379, "i")
	J.sp(_t158, "gi", _t159)
	var _t160 = env["S"]
	J.sp(_t160, "gCall", null)
	var _t161 = env["S"]
	J.sp(_t161, "gWait", null)
	J.sp(v_g_379, "to", null)
	J.sp(v_g_379, "auto", null)
	J.sp(v_g_379, "autoS", null)
	if J.seq(J.gp(env["S"], "st"), "idle"):
		var _t162 = env["S"]
		J.sp(_t162, "st", "opening")
		J.mc(env["SND"], "ding", [])
		J.mc(env["SND"], "door", [])
	var _t163 = env["S"]
	var _t164 = J.max_([J.gp(env["S"], "hold"), 3.5])
	J.sp(_t163, "hold", _t164)
	var _t165 = env["dingFx"]
	J.cl(_t165, null, [v_f_380])
	var _t166 = env["log"]
	J.cl(_t166, null, ["enter"])
	J.cl(env["showUI"], null, [])
	if J.t(J.gp(env["A"], "toast")):
		J.mc(env["A"], "toast", ["入咗𨋢：揀樓層、撳開關門。有人一齊搭嘅時候，上面會出「𨋢內嚇人」。"])

func _f77(this_, a: Array, env):
	var v_o_424 = null
	v_o_424 = J.arg(a, 0)
	var _t168 = J.seq(J.gp(v_o_424, "ph"), "wait")
	return (J.seq(J.gp(v_o_424, "f"), env["f"]) if _t168 else _t168)

func _f78(this_, a: Array, env):
	var v_o_427 = null; var v_h_428 = null; var v_r_429 = null; var v_e_430 = null
	v_o_427 = J.arg(a, 0)
	var _t170 = J.gp(env["__p"]["S"], "riders")
	var _t171 = J.gp(env["__p"]["S"], "riders")
	J.mc(_t170, "splice", [J.mc(_t171, "indexOf", [v_o_427]), 1.0])
	if J.seq(J.gp(v_o_427, "kind"), "guard"):
		v_h_428 = J.gp(v_o_427, "ref")
		var _t172 = (J.add("f", env["f"]) + "_l")
		J.sp(v_h_428, "node", _t172)
		J.sp(v_h_428, "to", null)
		J.sp(v_h_428, "p", 0.0)
		var _t173 = J.sub(J.gp(env["c"], "cx"), 30.0)
		J.sp(v_h_428, "x", _t173)
		var _t174 = env["y"]
		J.sp(v_h_428, "y", _t174)
		J.sp(v_h_428, "state", "patrol")
		var _t175 = J.gp(env["g0"], "guards")
		J.mc(_t175, "push", [v_h_428])
		var _t176 = env["__p"]["line"]
		J.mc(env["__p"]["A"], "spook", [v_h_428, J.cl(_t176, null, ["gLand"])])
		return null
	v_r_429 = J.gp(v_o_427, "ref")
	J.sp(v_r_429, "state", "flee")
	var _t177 = (((-1.0) if J.cmp(J.gp(v_o_427, "x"), J.gp(env["c"], "cx"), "<") else 1.0) * 160.0)
	J.sp(v_r_429, "vx", _t177)
	var _t178 = J.gp(v_o_427, "x")
	J.sp(v_r_429, "x", _t178)
	var _t179 = J.sub(env["y"], 16.0)
	J.sp(v_r_429, "y", _t179)
	var _t180 = J.gp(env["g0"], "res")
	J.mc(_t180, "push", [v_r_429])
	var _t181 = env["__p"]["sayR"]
	var _t182 = env["__p"]["line"]
	J.cl(_t181, null, [v_r_429, J.cl(_t182, null, ["land"])])
	J.sp(v_r_429, "sayT", 2.4)

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
	var v_f_433 = null; var v_quiet_434 = null; var v_d_435 = null; var v_e_436 = null
	v_f_433 = J.arg(a, 0)
	v_quiet_434 = J.arg(a, 1)
	if (not J.t(env["S"])):
		return null
	v_d_435 = J.gp(J.gp(env["S"], "dfx"), v_f_433)
	if J.t((J.cmp(J.gp(v_d_435, "t"), 0.8, "<") if J.t(v_d_435) else v_d_435)):
		return null
	var _t183 = J.gp(env["S"], "dfx")
	var _t184 = {"t": 0.0}
	J.sp(_t183, v_f_433, _t184)
	if (not J.t(v_quiet_434)):
		J.mc(env["SND"], "ding", [])

func _f83(this_, a: Array, env):
	var v_m_458 = null; var v_g_459 = null
	v_m_458 = J.arg(a, 0)
	var _t185 = env["S"]
	J.sp(_t185, "msg", v_m_458)
	var _t186 = env["S"]
	J.sp(_t186, "msgT", 1.6)
	v_g_459 = J.cl(env["ghost"], null, [])
	if J.t(v_g_459):
		var _t187 = env["fl"]
		J.cl(_t187, null, [J.gp(v_g_459, "x"), J.sub(J.gp(v_g_459, "y"), 120.0), v_m_458, "#ffd54a"])

func _f84(this_, a: Array, env):
	var v_e_462 = null
	v_e_462 = J.arg(a, 0)
	var _t188 = J.gp(env["S"], "log")
	J.mc(_t188, "push", [v_e_462])
	if (J.len(J.gp(env["S"], "log")) > 80.0):
		J.mc(J.gp(env["S"], "log"), "shift", [])

func _f92(this_, a: Array, env):
	var v_k_517 = null; var v_im_518 = null
	v_k_517 = J.arg(a, 0)
	var _t189 = J.gp(env["A"], "IMG")
	v_im_518 = (J.gp(J.gp(env["A"], "IMG"), v_k_517) if J.t(_t189) else _t189)
	return (v_im_518 if J.t((J.gp(v_im_518, "width") if J.t(v_im_518) else v_im_518)) else null)

func _f93(this_, a: Array, env):
	var v_c2_521 = null; var v_k_522 = null; var v_x_523 = null; var v_y_524 = null; var v_h_525 = null; var v_alpha_526 = null; var v_flip_527 = null; var v_sy_528 = null; var v_im_529 = null; var v_w_530 = null
	v_c2_521 = J.arg(a, 0)
	v_k_522 = J.arg(a, 1)
	v_x_523 = J.arg(a, 2)
	v_y_524 = J.arg(a, 3)
	v_h_525 = J.arg(a, 4)
	v_alpha_526 = J.arg(a, 5)
	v_flip_527 = J.arg(a, 6)
	v_sy_528 = J.arg(a, 7)
	var _t190 = env["img"]
	v_im_529 = J.cl(_t190, null, [v_k_522])
	if (not J.t(v_im_529)):
		var _t191 = (J.add("rgba(30,30,36,", (1.0 if J.leq(v_alpha_526, null) else v_alpha_526)) + ")")
		J.sp(v_c2_521, "fillStyle", _t191)
		J.mc(v_c2_521, "fillRect", [J.sub(v_x_523, J.mul(v_h_525, 0.18)), J.sub(v_y_524, v_h_525), J.mul(v_h_525, 0.36), v_h_525])
		return null
	v_w_530 = J.div(J.mul(v_h_525, J.gp(v_im_529, "width")), J.gp(v_im_529, "height"))
	J.mc(v_c2_521, "save", [])
	var _t192 = (1.0 if J.leq(v_alpha_526, null) else v_alpha_526)
	J.sp(v_c2_521, "globalAlpha", _t192)
	J.mc(v_c2_521, "translate", [v_x_523, v_y_524])
	if J.t(v_flip_527):
		J.mc(v_c2_521, "scale", [(-1.0), 1.0])
	if J.t(v_sy_528):
		J.mc(v_c2_521, "scale", [1.0, v_sy_528])
	J.mc(v_c2_521, "drawImage", [v_im_529, J.div((-J.num(v_w_530)), 2.0), (-J.num(v_h_525)), v_w_530, v_h_525])
	J.mc(v_c2_521, "restore", [])

func _f94(this_, a: Array, env):
	var v_c2_533 = null; var v_x_534 = null; var v_y_535 = null; var v_t_536 = null; var v_sc_537 = null; var v_w_538 = null; var v_h_539 = null
	v_c2_533 = J.arg(a, 0)
	v_x_534 = J.arg(a, 1)
	v_y_535 = J.arg(a, 2)
	v_t_536 = J.arg(a, 3)
	v_sc_537 = J.arg(a, 4)
	J.mc(v_c2_533, "save", [])
	var _t193 = J.add((J.add("bold ", J.round(J.num(J.div(12.0, v_sc_537)))) + "px "), J.gp(env["A"], "FONT"))
	J.sp(v_c2_533, "font", _t193)
	v_w_538 = J.min_([J.div(220.0, v_sc_537), J.add(J.gp(J.mc(v_c2_533, "measureText", [v_t_536]), "width"), J.div(14.0, v_sc_537))])
	v_h_539 = J.div(22.0, v_sc_537)
	J.sp(v_c2_533, "fillStyle", "rgba(255,250,240,0.95)")
	J.sp(v_c2_533, "strokeStyle", "#1a1a1e")
	var _t194 = J.div(1.5, v_sc_537)
	J.sp(v_c2_533, "lineWidth", _t194)
	J.mc(v_c2_533, "beginPath", [])
	J.mc(v_c2_533, "rect", [J.sub(v_x_534, J.div(v_w_538, 2.0)), J.sub(v_y_535, v_h_539), v_w_538, v_h_539])
	J.mc(v_c2_533, "fill", [])
	J.mc(v_c2_533, "stroke", [])
	J.sp(v_c2_533, "fillStyle", "#1a1a1e")
	J.sp(v_c2_533, "textAlign", "center")
	J.mc(v_c2_533, "fillText", [v_t_536, v_x_534, J.sub(v_y_535, J.mul(v_h_539, 0.3)), J.sub(v_w_538, J.div(6.0, v_sc_537))])
	J.mc(v_c2_533, "restore", [])

func _f96(this_, a: Array, env):
	var v_b_580 = null
	v_b_580 = J.arg(a, 0)
	var _t221 = J.cmp(J.gp(v_b_580, "y"), J.sub(J.gp(env["__p"]["A"], "VH"), J.gp(env["__p"]["A"], "BOT")), "<")
	if (J.cmp(J.add(J.gp(v_b_580, "y"), J.gp(v_b_580, "h")), J.gp(env["__p"]["A"], "TOP"), ">") if _t221 else _t221):
		J.mc(env["__p"]["wx"], "rect", [J.add(J.add(J.gp(v_b_580, "x"), J.gp(v_b_580, "w")), 2.0), J.sub(J.gp(v_b_580, "y"), 2.0), (-J.num(J.add(J.gp(v_b_580, "w"), 4.0))), J.add(J.gp(v_b_580, "h"), 4.0)])

func _f97(this_, a: Array, env):
	var v_o_584 = null; var v_px_585 = null
	v_o_584 = J.arg(a, 0)
	v_px_585 = (J.sub(J.gp(env["c"], "cx"), J.div(env["cw"], 2.0)) + J.mul(env["cw"], (0.5 if J.seq(env["n"], 1.0) else (0.18 + J.div(J.mul(0.64, env["k"]), J.max_([1.0, J.sub(env["n"], 1.0)]))))))
	env["k"] = J.num(env["k"]) + 1.0
	var _t228 = env["__p"]["sprAt"]
	var _t230 = env["__p"]["wx"]
	var _t229 = env["__p"]["riderSpr"]
	J.cl(_t228, null, [_t230, J.cl(_t229, null, [v_o_584]), v_px_585, J.sub(env["cy"], 1.0), (J.mul(env["ch"], 0.82) * (0.7 if J.seq(J.gp(v_o_584, "mood"), "cower") else 1.0)), 1.0, J.seq(J.mod(env["k"], 2.0), 0.0), null])

func _f98(this_, a: Array, env):
	var v_o_588 = null
	v_o_588 = J.arg(a, 0)
	var _t260 = J.seq(J.gp(v_o_588, "ph"), "wait")
	return (J.seq(J.gp(v_o_588, "f"), env["f"]) if _t260 else _t260)

func _f99(this_, a: Array, env):
	var v_q_591 = null; var v_qi_592 = null; var v_nq_593 = null; var v_al_594 = null
	v_q_591 = J.arg(a, 0)
	v_qi_592 = J.arg(a, 1)
	var _t273 = J.gp(v_q_591, "home")
	var _t274 = (_t273 if J.t(_t273) else J.gp(v_q_591, "out"))
	if J.t((_t274 if J.t(_t274) else J.seq(v_qi_592, J.gp(env["__p"]["S"], "gi")))):
		return null
	v_nq_593 = J.gp(J.gp(J.cl(env["__p"]["G"], null, []), "nodes"), J.gp(v_q_591, "node"))
	var _t275 = (not J.t(v_nq_593))
	var _t276 = (_t275 if _t275 else (not J.seq(J.gp(v_nq_593, "kind"), "lift")))
	if (_t276 if _t276 else (absf(J.num(J.sub(J.gp(v_q_591, "x"), J.gp(env["c"], "cx")))) > J.mul(env["cw"], 0.7))):
		return null
	v_al_594 = (0.35 if J.cmp(J.gp(v_q_591, "inv"), 0.0, ">") else 0.92)
	var _t277 = J.seq(J.gp(J.gp(v_q_591, "d"), "key"), "tianhua")
	var _t278 = ((not J.t(J.gp(v_q_591, "to"))) if _t277 else _t277)
	if ((not J.cmp(J.gp(v_q_591, "dropT"), 0.0, ">")) if _t278 else _t278):
		var _t279 = env["__p"]["sprAt"]
		J.cl(_t279, null, [env["__p"]["wx"], J.gp(J.gp(v_q_591, "d"), "sprite"), J.gp(v_q_591, "x"), J.add(J.mc(env["__p"]["A"], "fy", [J.min_([J.cl(env["__p"]["FL"], null, []), J.add(J.gp(v_nq_593, "f"), 1.0)])]), 14.0), J.gp(J.gp(v_q_591, "d"), "h"), v_al_594, J.cmp(J.gp(v_q_591, "dir"), 0.0, "<"), (-1.0)])
	else:
		var _t280 = env["__p"]["sprAt"]
		J.cl(_t280, null, [env["__p"]["wx"], J.gp(J.gp(v_q_591, "d"), "sprite"), J.gp(v_q_591, "x"), J.gp(v_q_591, "y"), J.gp(J.gp(v_q_591, "d"), "h"), v_al_594, J.cmp(J.gp(v_q_591, "dir"), 0.0, "<")])
	if J.seq(v_qi_592, J.gp(J.cl(env["__p"]["G"], null, []), "active")):
		var _t281 = env["__p"]["wx"]
		J.sp(_t281, "strokeStyle", "rgba(138,255,200,0.55)")
		J.mc(env["__p"]["wx"], "setLineDash", [[4.0, 4.0]])
		var _t282 = env["__p"]["wx"]
		J.sp(_t282, "lineWidth", 1.5)
		J.mc(env["__p"]["wx"], "beginPath", [])
		J.mc(env["__p"]["wx"], "ellipse", [J.gp(v_q_591, "x"), J.sub(J.gp(v_q_591, "y"), 2.0), 30.0, 8.0, 0.0, 0.0, 7.0])
		J.mc(env["__p"]["wx"], "stroke", [])
		J.mc(env["__p"]["wx"], "setLineDash", [[]])

func _f100(this_, a: Array, env):
	var v_o_597 = null; var v_y_598 = null; var v_rk_599 = null
	v_o_597 = J.arg(a, 0)
	if J.seq(J.gp(v_o_597, "ph"), "ride"):
		return null
	v_y_598 = J.mc(env["__p"]["A"], "fy", [J.gp(v_o_597, "f")])
	var _t284 = env["__p"]["rKey"]
	v_rk_599 = J.cl(_t284, null, [v_o_597])
	var _t285 = env["__p"]["sprAt"]
	var _t289 = env["__p"]["wx"]
	var _t290 = J.gp(v_o_597, "x")
	var _t291 = J.sub(v_y_598, 2.0)
	var _t286 = env["__p"]["rH"]
	var _t288 = null
	if J.seq(J.gp(v_o_597, "kind"), "guard"):
		_t288 = 64.0
	else:
		var _t287 = J.gp(J.gp(v_o_597, "ref"), "h")
		_t288 = (_t287 if J.t(_t287) else 66.0)
	var _t296 = J.cl(_t286, null, [v_o_597, v_rk_599, J.mul(_t288, 0.9)])
	var _t295 = null
	if J.seq(J.gp(v_o_597, "ph"), "walkHome"):
		var _t294 = J.gp(v_o_597, "x")
		var _t292 = J.gp(J.gp(v_o_597, "ref"), "unit")
		var _t293 = (J.gp(J.gp(J.gp(J.gp(v_o_597, "ref"), "unit"), "rx"), 0.0) if J.t(_t292) else _t292)
		_t295 = J.cmp(_t294, (_t293 if J.t(_t293) else 0.0), ">")
	else:
		_t295 = J.cmp(J.gp(v_o_597, "x"), J.gp(env["c"], "cx"), ">")
	J.cl(_t285, null, [_t289, v_rk_599, _t290, _t291, _t296, 1.0, _t295])

func _f101(this_, a: Array, env):
	var v_o_602 = null
	v_o_602 = J.arg(a, 0)
	if (not J.t(J.gp(v_o_602, "say"))):
		return null
	if J.seq(J.gp(v_o_602, "ph"), "ride"):
		var _t298 = env["__p"]["bub"]
		J.cl(_t298, null, [env["__p"]["wx"], J.gp(env["c"], "cx"), (J.sub(env["cy"], env["ch"]) - 8.0), J.gp(v_o_602, "say"), 1.0])
	else:
		var _t299 = env["__p"]["bub"]
		J.cl(_t299, null, [env["__p"]["wx"], J.gp(v_o_602, "x"), J.sub(J.mc(env["__p"]["A"], "fy", [J.gp(v_o_602, "f")]), 80.0), J.gp(v_o_602, "say"), 1.0])

func _f95(this_, a: Array, env):
	var v_NT_542 = null; var v_cv_543 = null; var v_r_544 = null; var v_D_545 = null; var v_p0_546 = null; var v_p1_547 = null; var v_sc_548 = null; var v_cb_549 = null; var v_fh_551 = null; var v_t_554 = null; var v_sh_556 = null; var v_lit_557 = null; var v_ig_558 = null; var v_inn_559 = null; var v_g_560 = null; var v_px2_563 = null; var v_pw2_564 = null; var v_CLW_565 = null; var v_y_567 = null; var v_here_568 = null; var v_op_569 = null; var v_dfx_570 = null; var v_pw_571 = null; var v_fl2_572 = null; var v_lampOn_573 = null; var v_hg_574 = null; var v_wn_575 = null; var v_u_576 = null; var v_pop_577 = null; var v_e_581 = null
	var _s228 = {"__p": env, "c": null, "cw": null, "ch": null, "cy": null, "n": null, "k": null, "f": null}
	v_NT_542 = J.gp(J.G.get("window"), "__twNat")
	if J.t(((not J.t(J.gp(v_NT_542, "ctx"))) if J.t(v_NT_542) else v_NT_542)):
		return null
	var _t195 = (J.gp(v_NT_542, "ctx") if J.t(v_NT_542) else _s228["__p"]["wx0"])
	_s228["__p"]["wx"] = _t195
	v_cv_543 = J.gp(_s228["__p"]["A"], "cv")
	v_r_544 = ({"left": 0.0, "top": 0.0, "width": J.gp(_s228["__p"]["A"], "VW"), "height": J.gp(_s228["__p"]["A"], "VH")} if J.t(v_NT_542) else J.mc(v_cv_543, "getBoundingClientRect", []))
	var _t198 = null
	if J.t(v_NT_542):
		_t198 = J.gp(v_NT_542, "s")
	else:
		var _t196 = J.gp(J.G.get("window"), "devicePixelRatio")
		var _t197 = J.gp(J.G.get("window"), "devicePixelRatio")
		_t198 = J.min_([2.0, (_t197 if J.t(_t197) else 1.0)])
	v_D_545 = _t198
	var _t199 = (not J.seq(J.gp(_s228["__p"]["wc"], "width"), J.round(J.num(J.mul(J.gp(v_r_544, "width"), v_D_545)))))
	if (_t199 if _t199 else (not J.seq(J.gp(_s228["__p"]["wc"], "height"), J.round(J.num(J.mul(J.gp(v_r_544, "height"), v_D_545)))))):
		var _t200 = _s228["__p"]["wc"]
		var _t201 = J.round(J.num(J.mul(J.gp(v_r_544, "width"), v_D_545)))
		J.sp(_t200, "width", _t201)
		var _t202 = _s228["__p"]["wc"]
		var _t203 = J.round(J.num(J.mul(J.gp(v_r_544, "height"), v_D_545)))
		J.sp(_t202, "height", _t203)
	var _t204 = J.gp(_s228["__p"]["wc"], "style")
	var _t205 = J.add(J.gp(v_r_544, "left"), "px")
	J.sp(_t204, "left", _t205)
	var _t206 = J.gp(_s228["__p"]["wc"], "style")
	var _t207 = J.add(J.gp(v_r_544, "top"), "px")
	J.sp(_t206, "top", _t207)
	var _t208 = J.gp(_s228["__p"]["wc"], "style")
	var _t209 = J.add(J.gp(v_r_544, "width"), "px")
	J.sp(_t208, "width", _t209)
	var _t210 = J.gp(_s228["__p"]["wc"], "style")
	var _t211 = J.add(J.gp(v_r_544, "height"), "px")
	J.sp(_t210, "height", _t211)
	if (not J.t(v_NT_542)):
		J.mc(_s228["__p"]["wx"], "setTransform", [1.0, 0.0, 0.0, 1.0, 0.0, 0.0])
		J.mc(_s228["__p"]["wx"], "clearRect", [0.0, 0.0, J.gp(_s228["__p"]["wc"], "width"), J.gp(_s228["__p"]["wc"], "height")])
	var _t212 = (not J.t(_s228["__p"]["S"]))
	var _t213 = (_t212 if _t212 else (not J.t(J.gp(_s228["__p"]["S"], "on"))))
	var _t214 = (_t213 if _t213 else (not J.seq(J.gp(_s228["__p"]["A"], "scene"), "play")))
	var _t215 = (_t214 if _t214 else (not J.t(J.cl(_s228["__p"]["G"], null, []))))
	var _t216 = (_t215 if _t215 else J.gp(J.cl(_s228["__p"]["G"], null, []), "choice"))
	var _t217 = (_t216 if J.t(_t216) else J.gp(J.cl(_s228["__p"]["G"], null, []), "over"))
	if J.t((_t217 if J.t(_t217) else J.gp(J.cl(_s228["__p"]["G"], null, []), "showStory"))):
		return null
	v_p0_546 = J.mc(_s228["__p"]["A"], "W2S", [0.0, 0.0])
	v_p1_547 = J.mc(_s228["__p"]["A"], "W2S", [100.0, 0.0])
	v_sc_548 = J.div(J.sub(J.gp(v_p1_547, "x"), J.gp(v_p0_546, "x")), 100.0)
	if (not J.cmp(v_sc_548, 0.0, ">")):
		return null
	J.mc(_s228["__p"]["wx"], "setTransform", [v_D_545, 0.0, 0.0, v_D_545, 0.0, 0.0])
	J.mc(_s228["__p"]["wx"], "save", [])
	J.mc(_s228["__p"]["wx"], "beginPath", [])
	var _t218 = J.cmp(J.gp(J.cl(_s228["__p"]["G"], null, []), "toastT"), 0.0, ">")
	v_cb_549 = (62.0 if J.t((J.gp(J.cl(_s228["__p"]["G"], null, []), "toast") if _t218 else _t218)) else 0.0)
	J.mc(_s228["__p"]["wx"], "rect", [0.0, J.gp(_s228["__p"]["A"], "TOP"), J.gp(_s228["__p"]["A"], "VW"), J.sub(J.sub(J.sub(J.gp(_s228["__p"]["A"], "VH"), J.gp(_s228["__p"]["A"], "TOP")), J.gp(_s228["__p"]["A"], "BOT")), v_cb_549)])
	var _t219 = J.gp(_s228["__p"]["A"], "BTNS")
	var _t220 = (_t219 if J.t(_t219) else [])
	J.mc(_t220, "forEach", [Callable(self, "_f96").bind(_s228)])
	J.mc(_s228["__p"]["wx"], "clip", ["evenodd"])
	J.mc(_s228["__p"]["wx"], "setTransform", [J.mul(v_D_545, v_sc_548), 0.0, 0.0, J.mul(v_D_545, v_sc_548), J.mul(v_D_545, J.gp(v_p0_546, "x")), J.mul(v_D_545, J.gp(v_p0_546, "y"))])
	_s228["c"] = J.cl(_s228["__p"]["col"], null, [])
	v_fh_551 = J.cl(_s228["__p"]["FH"], null, [])
	_s228["cw"] = (J.sub(J.gp(_s228["c"], "x1"), J.gp(_s228["c"], "x0")) * 0.66)
	_s228["ch"] = J.mul(v_fh_551, 0.6)
	v_t_554 = J.gp(_s228["__p"]["S"], "t")
	var _t222 = _s228["__p"]["fyf"]
	_s228["cy"] = J.cl(_t222, null, [J.gp(_s228["__p"]["S"], "pos")])
	v_sh_556 = (((sin(J.num(J.mul(v_t_554, 41.0))) * 0.8) if J.seq(J.gp(_s228["__p"]["S"], "st"), "move") else 0.0) + (((randf() - 0.5) * 4.0) if J.cmp(J.gp(_s228["__p"]["S"], "shake"), 0.0, ">") else 0.0))
	var _t223 = _s228["__p"]["wx"]
	J.sp(_t223, "strokeStyle", "rgba(180,180,170,0.7)")
	var _t224 = _s228["__p"]["wx"]
	J.sp(_t224, "lineWidth", 1.2)
	J.mc(_s228["__p"]["wx"], "beginPath", [])
	J.mc(_s228["__p"]["wx"], "moveTo", [J.sub(J.gp(_s228["c"], "cx"), 6.0), J.sub(J.mc(_s228["__p"]["A"], "fy", [J.cl(_s228["__p"]["FL"], null, [])]), 40.0)])
	J.mc(_s228["__p"]["wx"], "lineTo", [J.sub(J.gp(_s228["c"], "cx"), 6.0), (J.sub(_s228["cy"], _s228["ch"]) - 2.0)])
	J.mc(_s228["__p"]["wx"], "moveTo", [J.add(J.gp(_s228["c"], "cx"), 6.0), J.sub(J.mc(_s228["__p"]["A"], "fy", [J.cl(_s228["__p"]["FL"], null, [])]), 40.0)])
	J.mc(_s228["__p"]["wx"], "lineTo", [J.add(J.gp(_s228["c"], "cx"), 6.0), (J.sub(_s228["cy"], _s228["ch"]) - 2.0)])
	J.mc(_s228["__p"]["wx"], "stroke", [])
	J.mc(_s228["__p"]["wx"], "save", [])
	J.mc(_s228["__p"]["wx"], "translate", [v_sh_556, 0.0])
	v_lit_557 = J.cl(_s228["__p"]["lightLevel"], null, [])
	var _t225 = _s228["__p"]["wx"]
	J.sp(_t225, "fillStyle", "#3a3a36")
	J.mc(_s228["__p"]["wx"], "fillRect", [(J.sub(J.gp(_s228["c"], "cx"), J.div(_s228["cw"], 2.0)) - 3.0), (J.sub(_s228["cy"], _s228["ch"]) - 3.0), J.add(_s228["cw"], 6.0), J.add(_s228["ch"], 3.0)])
	v_ig_558 = J.mc(_s228["__p"]["wx"], "createLinearGradient", [0.0, J.sub(_s228["cy"], _s228["ch"]), 0.0, _s228["cy"]])
	J.mc(v_ig_558, "addColorStop", [0.0, (J.add("rgba(255,228,150,", J.mul(0.95, v_lit_557)) + ")")])
	J.mc(v_ig_558, "addColorStop", [1.0, (J.add("rgba(150,120,70,", J.mul(0.9, v_lit_557)) + ")")])
	var _t226 = _s228["__p"]["wx"]
	J.sp(_t226, "fillStyle", "#0a0a0a")
	J.mc(_s228["__p"]["wx"], "fillRect", [J.sub(J.gp(_s228["c"], "cx"), J.div(_s228["cw"], 2.0)), J.sub(_s228["cy"], _s228["ch"]), _s228["cw"], _s228["ch"]])
	var _t227 = _s228["__p"]["wx"]
	J.sp(_t227, "fillStyle", v_ig_558)
	J.mc(_s228["__p"]["wx"], "fillRect", [J.sub(J.gp(_s228["c"], "cx"), J.div(_s228["cw"], 2.0)), J.sub(_s228["cy"], _s228["ch"]), _s228["cw"], _s228["ch"]])
	v_inn_559 = J.cl(_s228["__p"]["inCab"], null, [])
	v_g_560 = J.cl(_s228["__p"]["ghost"], null, [])
	_s228["n"] = (J.len(v_inn_559) + (1.0 if J.t(v_g_560) else 0.0))
	_s228["k"] = 0.0
	J.mc(v_inn_559, "forEach", [Callable(self, "_f97").bind(_s228)])
	if J.t(v_g_560):
		v_px2_563 = (J.sub(J.gp(_s228["c"], "cx"), J.div(_s228["cw"], 2.0)) + J.mul(_s228["cw"], (0.5 if J.seq(_s228["n"], 1.0) else (0.18 + J.div(J.mul(0.64, _s228["k"]), J.max_([1.0, J.sub(_s228["n"], 1.0)]))))))
		var _t231 = _s228["__p"]["sprAt"]
		J.cl(_t231, null, [_s228["__p"]["wx"], J.gp(J.gp(v_g_560, "d"), "sprite"), v_px2_563, (J.sub(_s228["cy"], 2.0) + (sin(J.num(J.mul(v_t_554, 3.0))) * 1.5)), J.mul(_s228["ch"], 0.82), 0.75, false])
	if J.cmp(v_lit_557, 0.3, "<"):
		var _t232 = _s228["__p"]["wx"]
		J.sp(_t232, "fillStyle", "rgba(0,0,0,0.75)")
		J.mc(_s228["__p"]["wx"], "fillRect", [J.sub(J.gp(_s228["c"], "cx"), J.div(_s228["cw"], 2.0)), J.sub(_s228["cy"], _s228["ch"]), _s228["cw"], _s228["ch"]])
	if (not J.t(J.cl(_s228["__p"]["atFloor"], null, []))):
		v_pw2_564 = (J.div(_s228["cw"], 2.0) * J.sub(1.0, J.gp(_s228["__p"]["S"], "door")))
		if J.cmp(v_pw2_564, 0.5, ">"):
			var _t233 = _s228["__p"]["steel"]
			J.cl(_t233, null, [J.sub(J.gp(_s228["c"], "cx"), J.div(_s228["cw"], 2.0)), J.sub(_s228["cy"], _s228["ch"]), v_pw2_564, _s228["ch"], 1.0])
			var _t234 = _s228["__p"]["steel"]
			J.cl(_t234, null, [J.sub(J.add(J.gp(_s228["c"], "cx"), J.div(_s228["cw"], 2.0)), v_pw2_564), J.sub(_s228["cy"], _s228["ch"]), v_pw2_564, _s228["ch"], (-1.0)])
		if J.cmp(J.gp(_s228["__p"]["S"], "door"), 0.02, ">"):
			var _t235 = _s228["__p"]["gapLight"]
			J.cl(_t235, null, [J.gp(_s228["c"], "cx"), _s228["cy"], J.div(J.mul(_s228["cw"], J.gp(_s228["__p"]["S"], "door")), 2.0), _s228["ch"], J.min_([1.0, J.mul(J.gp(_s228["__p"]["S"], "door"), 3.0)])])
	var _t236 = J.cmp(J.gp(J.gp(_s228["__p"]["S"], "fx"), "over"), 0.0, ">")
	if J.t((J.mod(floor(J.num(J.mul(v_t_554, 6.0))), 2.0) if _t236 else _t236)):
		var _t237 = _s228["__p"]["wx"]
		J.sp(_t237, "fillStyle", "rgba(255,40,30,0.35)")
		J.mc(_s228["__p"]["wx"], "fillRect", [J.sub(J.gp(_s228["c"], "cx"), J.div(_s228["cw"], 2.0)), J.sub(_s228["cy"], _s228["ch"]), _s228["cw"], _s228["ch"]])
	J.mc(_s228["__p"]["wx"], "restore", [])
	v_CLW_565 = J.gp(J.G.get("window"), "__twCull")
	_s228["f"] = 0.0
	while true:
		if not J.cmp(_s228["f"], J.cl(_s228["__p"]["top"], null, []), "<="): break
		v_y_567 = J.mc(_s228["__p"]["A"], "fy", [_s228["f"]])
		var _t239 = v_CLW_565
		if J.t(_t239):
			var _t238 = J.cmp(v_y_567, J.gp(v_CLW_565, "y0"), "<")
			_t239 = (_t238 if _t238 else J.cmp((J.sub(v_y_567, _s228["ch"]) - 60.0), J.gp(v_CLW_565, "y1"), ">"))
		if J.t(_t239):
			_s228["f"] = J.num(_s228["f"]) + 1.0
			continue
		var _t240 = J.cl(_s228["__p"]["atFloor"], null, [])
		v_here_568 = (J.seq(J.cl(_s228["__p"]["cabF"], null, []), _s228["f"]) if J.t(_t240) else _t240)
		var _t242 = null
		if J.t(v_here_568):
			var _t241 = _s228["__p"]["ease"]
			_t242 = J.cl(_t241, null, [J.gp(_s228["__p"]["S"], "door")])
		else:
			_t242 = 0.0
		v_op_569 = _t242
		v_dfx_570 = J.gp(J.gp(_s228["__p"]["S"], "dfx"), _s228["f"])
		var _t243 = _s228["__p"]["wx"]
		J.sp(_t243, "fillStyle", "#2a2b2e")
		J.mc(_s228["__p"]["wx"], "fillRect", [(J.sub(J.gp(_s228["c"], "cx"), J.div(_s228["cw"], 2.0)) - 5.0), (J.sub(v_y_567, _s228["ch"]) - 5.0), J.add(_s228["cw"], 10.0), 5.0])
		J.mc(_s228["__p"]["wx"], "fillRect", [(J.sub(J.gp(_s228["c"], "cx"), J.div(_s228["cw"], 2.0)) - 5.0), J.sub(v_y_567, _s228["ch"]), 5.0, _s228["ch"]])
		J.mc(_s228["__p"]["wx"], "fillRect", [J.add(J.gp(_s228["c"], "cx"), J.div(_s228["cw"], 2.0)), J.sub(v_y_567, _s228["ch"]), 5.0, _s228["ch"]])
		var _t244 = _s228["__p"]["wx"]
		J.sp(_t244, "fillStyle", "#4a4c50")
		J.mc(_s228["__p"]["wx"], "fillRect", [(J.sub(J.gp(_s228["c"], "cx"), J.div(_s228["cw"], 2.0)) - 5.0), (J.sub(v_y_567, _s228["ch"]) - 5.0), J.add(_s228["cw"], 10.0), 2.0])
		if (not J.t(v_here_568)):
			var _t245 = _s228["__p"]["wx"]
			J.sp(_t245, "fillStyle", "#121214")
			J.mc(_s228["__p"]["wx"], "fillRect", [J.sub(J.gp(_s228["c"], "cx"), J.div(_s228["cw"], 2.0)), J.sub(v_y_567, _s228["ch"]), _s228["cw"], _s228["ch"]])
		v_pw_571 = (J.div(_s228["cw"], 2.0) * J.sub(1.0, v_op_569))
		if J.cmp(v_pw_571, 0.5, ">"):
			var _t246 = _s228["__p"]["steel"]
			J.cl(_t246, null, [J.sub(J.gp(_s228["c"], "cx"), J.div(_s228["cw"], 2.0)), J.sub(v_y_567, _s228["ch"]), v_pw_571, _s228["ch"], 1.0])
			var _t247 = _s228["__p"]["steel"]
			J.cl(_t247, null, [J.sub(J.add(J.gp(_s228["c"], "cx"), J.div(_s228["cw"], 2.0)), v_pw_571), J.sub(v_y_567, _s228["ch"]), v_pw_571, _s228["ch"], (-1.0)])
		if J.t((J.cmp(J.gp(_s228["__p"]["S"], "door"), 0.001, ">") if J.t(v_here_568) else v_here_568)):
			var _t248 = _s228["__p"]["gapLight"]
			J.cl(_t248, null, [J.gp(_s228["c"], "cx"), v_y_567, J.div(J.mul(_s228["cw"], v_op_569), 2.0), _s228["ch"], (1.0 if J.cmp(J.gp(_s228["__p"]["S"], "door"), 1.0, "<") else 0.55)])
		var _t249 = (J.cmp(J.gp(v_dfx_570, "t"), 1.2, "<") if J.t(v_dfx_570) else v_dfx_570)
		v_fl2_572 = (J.seq(J.mod(floor(J.num(J.div(J.gp(v_dfx_570, "t"), 0.15))), 2.0), 0.0) if J.t(_t249) else _t249)
		v_lampOn_573 = (absf(J.num(J.sub(J.gp(_s228["__p"]["S"], "pos"), _s228["f"]))) < 0.5)
		if J.t(v_fl2_572):
			v_hg_574 = J.mc(_s228["__p"]["wx"], "createRadialGradient", [J.gp(_s228["c"], "cx"), (J.sub(v_y_567, _s228["ch"]) - 12.0), 2.0, J.gp(_s228["c"], "cx"), (J.sub(v_y_567, _s228["ch"]) - 12.0), 26.0])
			J.mc(v_hg_574, "addColorStop", [0.0, "rgba(255,214,120,0.85)"])
			J.mc(v_hg_574, "addColorStop", [1.0, "rgba(255,214,120,0)"])
			var _t250 = _s228["__p"]["wx"]
			J.sp(_t250, "fillStyle", v_hg_574)
			J.mc(_s228["__p"]["wx"], "fillRect", [J.sub(J.gp(_s228["c"], "cx"), 28.0), (J.sub(v_y_567, _s228["ch"]) - 40.0), 56.0, 56.0])
		var _t251 = _s228["__p"]["wx"]
		J.sp(_t251, "fillStyle", "#000")
		J.mc(_s228["__p"]["wx"], "fillRect", [J.sub(J.gp(_s228["c"], "cx"), 14.0), (J.sub(v_y_567, _s228["ch"]) - 19.0), 28.0, 13.0])
		var _t252 = _s228["__p"]["wx"]
		var _t253 = ("#fff3c0" if J.t(v_fl2_572) else ("#ffb347" if J.t(v_lampOn_573) else "#7a4a20"))
		J.sp(_t252, "fillStyle", _t253)
		var _t254 = _s228["__p"]["wx"]
		var _t255 = J.add("bold 10px ", J.gp(_s228["__p"]["A"], "FONT"))
		J.sp(_t254, "font", _t255)
		var _t256 = _s228["__p"]["wx"]
		J.sp(_t256, "textAlign", "center")
		var _t258 = (("▲" if J.cmp(J.gp(_s228["__p"]["S"], "dir"), 0.0, ">") else "▼") if J.seq(J.gp(_s228["__p"]["S"], "st"), "move") else "")
		var _t257 = _s228["__p"]["lab"]
		J.mc(_s228["__p"]["wx"], "fillText", [J.add(_t258, J.cl(_t257, null, [J.cl(_s228["__p"]["cabF"], null, [])])), J.gp(_s228["c"], "cx"), (J.sub(v_y_567, _s228["ch"]) - 9.0)])
		var _t259 = J.gp(_s228["__p"]["S"], "riders")
		var _t261 = J.mc(_t259, "some", [Callable(self, "_f98").bind(_s228)])
		v_wn_575 = (_t261 if J.t(_t261) else J.seq(J.gp(_s228["__p"]["S"], "gCall"), _s228["f"]))
		var _t262 = _s228["__p"]["wx"]
		var _t263 = ("#ffd54a" if J.t((v_wn_575 if J.t(v_wn_575) else v_fl2_572)) else "#444")
		J.sp(_t262, "fillStyle", _t263)
		J.mc(_s228["__p"]["wx"], "beginPath", [])
		J.mc(_s228["__p"]["wx"], "arc", [J.add(J.add(J.gp(_s228["c"], "cx"), J.div(_s228["cw"], 2.0)), 9.0), J.sub(v_y_567, J.mul(_s228["ch"], 0.5)), 3.2, 0.0, 7.0])
		J.mc(_s228["__p"]["wx"], "fill", [])
		if J.t((J.cmp(J.gp(v_dfx_570, "t"), 1.4, "<") if J.t(v_dfx_570) else v_dfx_570)):
			v_u_576 = J.div(J.gp(v_dfx_570, "t"), 1.4)
			v_pop_577 = (1.0 + (0.5 * J.max_([0.0, (1.0 - J.div(J.gp(v_dfx_570, "t"), 0.18))])))
			J.mc(_s228["__p"]["wx"], "save", [])
			var _t264 = _s228["__p"]["wx"]
			var _t265 = J.min_([1.0, (J.sub(1.0, v_u_576) * 1.6)])
			J.sp(_t264, "globalAlpha", _t265)
			J.mc(_s228["__p"]["wx"], "translate", [J.add(J.add(J.gp(_s228["c"], "cx"), J.div(_s228["cw"], 2.0)), 16.0), ((J.sub(v_y_567, _s228["ch"]) - 14.0) - J.mul(v_u_576, 34.0))])
			J.mc(_s228["__p"]["wx"], "scale", [v_pop_577, v_pop_577])
			var _t266 = _s228["__p"]["wx"]
			var _t267 = J.add("bold 20px ", J.gp(_s228["__p"]["A"], "FONT"))
			J.sp(_t266, "font", _t267)
			var _t268 = _s228["__p"]["wx"]
			J.sp(_t268, "lineWidth", 4.0)
			var _t269 = _s228["__p"]["wx"]
			J.sp(_t269, "strokeStyle", "#1a1205")
			J.mc(_s228["__p"]["wx"], "strokeText", ["叮", 0.0, 0.0])
			var _t270 = _s228["__p"]["wx"]
			J.sp(_t270, "fillStyle", "#ffd54a")
			J.mc(_s228["__p"]["wx"], "fillText", ["叮", 0.0, 0.0])
			J.mc(_s228["__p"]["wx"], "restore", [])
		_s228["f"] = J.num(_s228["f"]) + 1.0
	var _t271 = J.gp(J.cl(_s228["__p"]["G"], null, []), "gh")
	var _t272 = (_t271 if J.t(_t271) else [])
	J.mc(_t272, "forEach", [Callable(self, "_f99").bind(_s228)])
	var _t283 = J.gp(_s228["__p"]["S"], "riders")
	J.mc(_t283, "forEach", [Callable(self, "_f100").bind(_s228)])
	var _t297 = J.gp(_s228["__p"]["S"], "riders")
	J.mc(_t297, "forEach", [Callable(self, "_f101").bind(_s228)])
	J.mc(_s228["__p"]["wx"], "restore", [])

func _f102(this_, a: Array, env):
	var v_x_605 = null
	v_x_605 = J.arg(a, 0)
	return (J.mul(J.mul(2.0, v_x_605), v_x_605) if J.cmp(v_x_605, 0.5, "<") else (1.0 - J.div(pow(J.num((J.mul((-2.0), v_x_605) + 2.0)), J.num(2.0)), 2.0)))

func _f103(this_, a: Array, env):
	var v_x_608 = null; var v_y_609 = null; var v_w_610 = null; var v_h_611 = null; var v_side_612 = null; var v_gr_613 = null; var v_i_614 = null; var v_ex_615 = null
	v_x_608 = J.arg(a, 0)
	v_y_609 = J.arg(a, 1)
	v_w_610 = J.arg(a, 2)
	v_h_611 = J.arg(a, 3)
	v_side_612 = J.arg(a, 4)
	v_gr_613 = J.mc(env["wx"], "createLinearGradient", [v_x_608, 0.0, J.add(v_x_608, v_w_610), 0.0])
	J.mc(v_gr_613, "addColorStop", [0.0, "#7f8387"])
	J.mc(v_gr_613, "addColorStop", [0.45, "#c9ccd0"])
	J.mc(v_gr_613, "addColorStop", [1.0, "#8a8e92"])
	var _t300 = env["wx"]
	J.sp(_t300, "fillStyle", v_gr_613)
	J.mc(env["wx"], "fillRect", [v_x_608, v_y_609, v_w_610, v_h_611])
	var _t301 = env["wx"]
	J.sp(_t301, "fillStyle", "rgba(255,255,255,0.10)")
	v_i_614 = 1.0
	while true:
		if not J.cmp(v_i_614, 4.0, "<"): break
		J.mc(env["wx"], "fillRect", [v_x_608, J.add(v_y_609, J.div(J.mul(v_h_611, v_i_614), 4.0)), v_w_610, 0.8])
		v_i_614 = J.num(v_i_614) + 1.0
	v_ex_615 = (J.sub(J.add(v_x_608, v_w_610), 1.6) if J.cmp(v_side_612, 0.0, ">") else v_x_608)
	var _t302 = env["wx"]
	J.sp(_t302, "fillStyle", "#4a4d52")
	J.mc(env["wx"], "fillRect", [v_ex_615, v_y_609, 1.6, v_h_611])
	if J.cmp(v_w_610, 6.0, ">"):
		var _t303 = env["wx"]
		J.sp(_t303, "fillStyle", "rgba(40,42,46,0.7)")
		J.mc(env["wx"], "fillRect", [(J.sub(J.add(v_x_608, v_w_610), 5.0) if J.cmp(v_side_612, 0.0, ">") else J.add(v_x_608, 3.4)), J.add(v_y_609, J.mul(v_h_611, 0.42)), 1.6, J.mul(v_h_611, 0.16)])

func _f105(this_, a: Array, env):
	var v_sd_627 = null; var v_ex_628 = null; var v_gr_629 = null
	v_sd_627 = J.arg(a, 0)
	v_ex_628 = J.add(env["cx"], J.mul(v_sd_627, env["half"]))
	v_gr_629 = J.mc(env["__p"]["wx"], "createLinearGradient", [v_ex_628, 0.0, J.add(v_ex_628, J.mul(v_sd_627, 9.0)), 0.0])
	J.mc(v_gr_629, "addColorStop", [0.0, (J.add("rgba(255,236,170,", J.mul(0.75, env["a"])) + ")")])
	J.mc(v_gr_629, "addColorStop", [1.0, "rgba(255,236,170,0)"])
	var _t306 = env["__p"]["wx"]
	J.sp(_t306, "fillStyle", v_gr_629)
	J.mc(env["__p"]["wx"], "fillRect", [J.min_([v_ex_628, J.add(v_ex_628, J.mul(v_sd_627, 9.0))]), J.sub(env["y"], env["ch"]), 9.0, env["ch"]])

func _f104(this_, a: Array, env):
	var v_gs_623 = null; var v_w_624 = null
	var _s257 = {"__p": env, "cx": null, "y": null, "half": null, "ch": null, "a": null}
	_s257["cx"] = J.arg(a, 0)
	_s257["y"] = J.arg(a, 1)
	_s257["half"] = J.arg(a, 2)
	_s257["ch"] = J.arg(a, 3)
	_s257["a"] = J.arg(a, 4)
	J.mc(_s257["__p"]["wx"], "save", [])
	if J.cmp(_s257["half"], 4.0, "<"):
		v_gs_623 = J.mc(_s257["__p"]["wx"], "createLinearGradient", [J.sub(_s257["cx"], 10.0), 0.0, J.add(_s257["cx"], 10.0), 0.0])
		J.mc(v_gs_623, "addColorStop", [0.0, "rgba(255,226,150,0)"])
		J.mc(v_gs_623, "addColorStop", [0.5, (J.add("rgba(255,244,200,", J.mul(0.95, _s257["a"])) + ")")])
		J.mc(v_gs_623, "addColorStop", [1.0, "rgba(255,226,150,0)"])
		var _t304 = _s257["__p"]["wx"]
		J.sp(_t304, "fillStyle", v_gs_623)
		J.mc(_s257["__p"]["wx"], "fillRect", [J.sub(_s257["cx"], 10.0), J.sub(_s257["y"], _s257["ch"]), 20.0, _s257["ch"]])
	else:
		var _t305 = [(-1.0), 1.0]
		J.mc(_t305, "forEach", [Callable(self, "_f105").bind(_s257)])
	v_w_624 = J.max_([3.0, J.mul(_s257["half"], 2.0)])
	var _t307 = _s257["__p"]["wx"]
	var _t308 = (J.add("rgba(255,220,140,", J.mul(0.3, _s257["a"])) + ")")
	J.sp(_t307, "fillStyle", _t308)
	J.mc(_s257["__p"]["wx"], "beginPath", [])
	J.mc(_s257["__p"]["wx"], "moveTo", [J.sub(_s257["cx"], J.div(v_w_624, 2.0)), _s257["y"]])
	J.mc(_s257["__p"]["wx"], "lineTo", [J.add(_s257["cx"], J.div(v_w_624, 2.0)), _s257["y"]])
	J.mc(_s257["__p"]["wx"], "lineTo", [J.add(J.add(_s257["cx"], J.div(v_w_624, 2.0)), 26.0), J.add(_s257["y"], 9.0)])
	J.mc(_s257["__p"]["wx"], "lineTo", [(J.sub(_s257["cx"], J.div(v_w_624, 2.0)) - 26.0), J.add(_s257["y"], 9.0)])
	J.mc(_s257["__p"]["wx"], "closePath", [])
	J.mc(_s257["__p"]["wx"], "fill", [])
	J.mc(_s257["__p"]["wx"], "restore", [])

func _f106(this_, a: Array, env):
	var v_d_632 = null; var v_e_633 = null
	v_d_632 = J.gp(J.gp(env["S"], "fx"), "dark")
	if J.cmp(v_d_632, 0.0, ">"):
		v_e_633 = J.sub(4.2, v_d_632)
		if J.cmp(v_e_633, 0.7, "<"):
			return (0.15 if J.t(J.mod(floor(J.num(J.div(v_e_633, 0.175))), 2.0)) else 1.0)
		return 0.04
	if J.cmp(J.gp(J.gp(env["S"], "fx"), "flick"), 0.0, ">"):
		return 0.55
	if J.seq(J.gp(env["S"], "st"), "stuck"):
		return (0.6 + (0.3 * absf(J.num(sin(J.num(J.mul(J.gp(env["S"], "t"), 9.0)))))))
	return 1.0

func _f108(this_, a: Array, env):
	var _t309 = J.mod(J.mul(env["s"], 16807.0), 2147483647.0)
	env["s"] = _t309
	return J.div(env["s"], 2147483647.0)

func _f110(this_, a: Array, env):
	var v_e_656 = null; var v_i_657 = null; var v_t_658 = null
	v_e_656 = J.arg(a, 0)
	v_i_657 = 0.0
	while true:
		if not J.cmp(v_i_657, 4.0, "<"): break
		v_t_658 = J.div(v_i_657, 4.0)
		J.mc(env["P"], "push", [[J.add(J.add(J.gp(v_e_656, 0.0), J.mul(J.sub(J.gp(v_e_656, 2.0), J.gp(v_e_656, 0.0)), v_t_658)), J.mul(J.sub(J.cl(env["__p"]["r"], null, []), 0.5), env["j"])), J.add(J.add(J.gp(v_e_656, 1.0), J.mul(J.sub(J.gp(v_e_656, 3.0), J.gp(v_e_656, 1.0)), v_t_658)), J.mul(J.sub(J.cl(env["__p"]["r"], null, []), 0.5), env["j"]))]])
		v_i_657 = J.num(v_i_657) + 1.0

func _f111(this_, a: Array, env):
	var v_p_661 = null
	v_p_661 = J.arg(a, 0)
	J.mc(env["__p"]["x"], "lineTo", [J.gp(v_p_661, 0.0), J.gp(v_p_661, 1.0)])

func _f109(this_, a: Array, env):
	var _s265 = {"__p": env, "j": null, "P": null}
	_s265["j"] = J.arg(a, 0)
	_s265["P"] = []
	var _t310 = [[4.0, 4.0, J.sub(_s265["__p"]["N"], 4.0), 4.0], [J.sub(_s265["__p"]["N"], 4.0), 4.0, J.sub(_s265["__p"]["N"], 4.0), J.sub(_s265["__p"]["N"], 4.0)], [J.sub(_s265["__p"]["N"], 4.0), J.sub(_s265["__p"]["N"], 4.0), 4.0, J.sub(_s265["__p"]["N"], 4.0)], [4.0, J.sub(_s265["__p"]["N"], 4.0), 4.0, 4.0]]
	J.mc(_t310, "forEach", [Callable(self, "_f110").bind(_s265)])
	J.mc(_s265["__p"]["x"], "beginPath", [])
	J.mc(_s265["__p"]["x"], "moveTo", [J.gp(J.gp(_s265["P"], 0.0), 0.0), J.gp(J.gp(_s265["P"], 0.0), 1.0)])
	J.mc(_s265["P"], "forEach", [Callable(self, "_f111").bind(_s265)])
	J.mc(_s265["__p"]["x"], "closePath", [])

func _f107(this_, a: Array, env):
	var v_tone_636 = null; var v_press_637 = null; var v_T_638 = null; var v_c_640 = null; var v_k_643 = null; var v_q_644 = null; var v_p_645 = null; var v_path_647 = null
	var _s263 = {"__p": env, "N": null, "x": null, "s": null, "r": null}
	v_tone_636 = J.arg(a, 0)
	v_press_637 = J.arg(a, 1)
	_s263["r"] = Callable(self, "_f108").bind(_s263)
	v_path_647 = Callable(self, "_f109").bind(_s263)
	v_T_638 = J.gp(_s263["__p"]["CRT"], v_tone_636)
	_s263["N"] = 64.0
	v_c_640 = J.S_document_("createElement", ["canvas"])
	var _t311 = J.mul(_s263["N"], 2.0)
	J.sp(v_c_640, "height", _t311)
	J.sp(v_c_640, "width", _t311)
	_s263["x"] = J.mc(v_c_640, "getContext", ["2d"])
	J.mc(_s263["x"], "scale", [2.0, 2.0])
	_s263["s"] = (((7.0 + J.mul(J.mc(v_tone_636, "charCodeAt", [0.0]), 131.0)) + (J.len(v_tone_636) * 977.0)) + (31.0 if J.t(v_press_637) else 0.0))
	J.cl(v_path_647, null, [1.4])
	var _t312 = _s263["x"]
	var _t313 = J.gp(v_T_638, 0.0)
	J.sp(_t312, "fillStyle", _t313)
	J.mc(_s263["x"], "fill", [])
	J.mc(_s263["x"], "save", [])
	J.mc(_s263["x"], "clip", [])
	var _t314 = _s263["x"]
	var _t315 = J.gp(v_T_638, 1.0)
	J.sp(_t314, "strokeStyle", _t315)
	var _t316 = _s263["x"]
	J.sp(_t316, "lineCap", "round")
	v_k_643 = (-J.num(_s263["N"]))
	while true:
		if not J.cmp(v_k_643, J.mul(_s263["N"], 2.0), "<"): break
		var _t317 = _s263["x"]
		var _t318 = (0.3 + J.mul(J.cl(_s263["r"], null, []), 0.3))
		J.sp(_t317, "globalAlpha", _t318)
		var _t319 = _s263["x"]
		var _t320 = (0.8 + J.mul(J.cl(_s263["r"], null, []), 1.3))
		J.sp(_t319, "lineWidth", _t320)
		J.mc(_s263["x"], "beginPath", [])
		J.mc(_s263["x"], "moveTo", [v_k_643, _s263["N"]])
		J.mc(_s263["x"], "lineTo", [J.add(v_k_643, J.mul(_s263["N"], 0.9)), 0.0])
		J.mc(_s263["x"], "stroke", [])
		var _t321 = J.add(v_k_643, (4.0 + J.mul(J.cl(_s263["r"], null, []), 2.0)))
		v_k_643 = _t321
	var _t322 = _s263["x"]
	J.sp(_t322, "globalAlpha", 1.0)
	v_q_644 = 0.0
	while true:
		if not J.cmp(v_q_644, 500.0, "<"): break
		var _t323 = _s263["x"]
		var _t324 = ((J.add("rgba(0,0,0,", (0.1 + J.mul(J.cl(_s263["r"], null, []), 0.25))) + ")") if J.cmp(J.cl(_s263["r"], null, []), 0.6, "<") else (J.add("rgba(255,240,220,", (0.04 + J.mul(J.cl(_s263["r"], null, []), 0.06))) + ")"))
		J.sp(_t323, "fillStyle", _t324)
		J.mc(_s263["x"], "fillRect", [J.mul(J.cl(_s263["r"], null, []), _s263["N"]), J.mul(J.cl(_s263["r"], null, []), _s263["N"]), J.add(1.0, J.cl(_s263["r"], null, [])), J.add(1.0, J.cl(_s263["r"], null, []))])
		v_q_644 = J.num(v_q_644) + 1.0
	J.mc(_s263["x"], "restore", [])
	v_p_645 = 0.0
	while true:
		if not J.cmp(v_p_645, (4.0 if J.t(v_press_637) else 3.0), "<"): break
		var _t325 = _s263["x"]
		var _t326 = (0.5 if J.t(v_p_645) else 0.95)
		J.sp(_t325, "globalAlpha", _t326)
		var _t327 = _s263["x"]
		var _t328 = J.seq(v_p_645, 2.0)
		var _t329 = ("rgba(0,0,0,0.6)" if ((not J.t(v_press_637)) if _t328 else _t328) else J.gp(v_T_638, 2.0))
		J.sp(_t327, "strokeStyle", _t329)
		var _t330 = _s263["x"]
		var _t331 = ((3.4 if J.t(v_press_637) else 2.2) - J.mul(v_p_645, 0.35))
		J.sp(_t330, "lineWidth", _t331)
		var _t332 = _s263["x"]
		J.sp(_t332, "lineJoin", "round")
		J.cl(v_path_647, null, [2.2])
		J.mc(_s263["x"], "stroke", [])
		v_p_645 = J.num(v_p_645) + 1.0
	return (J.add("url(", J.mc(v_c_640, "toDataURL", [])) + ")")

func _f113(this_, a: Array, env):
	var _t333 = J.mod(J.mul(env["s"], 16807.0), 2147483647.0)
	env["s"] = _t333
	return J.div(env["s"], 2147483647.0)

func _f112(this_, a: Array, env):
	var v_c_664 = null; var v_x_665 = null; var v_k_667 = null; var v_q_668 = null; var v_r_669 = null
	var _s276 = {"__p": env, "s": null}
	v_r_669 = Callable(self, "_f113").bind(_s276)
	v_c_664 = J.S_document_("createElement", ["canvas"])
	J.sp(v_c_664, "height", 160.0)
	J.sp(v_c_664, "width", 160.0)
	v_x_665 = J.mc(v_c_664, "getContext", ["2d"])
	_s276["s"] = 11.0
	J.sp(v_x_665, "fillStyle", "#141016")
	J.mc(v_x_665, "fillRect", [0.0, 0.0, 160.0, 160.0])
	J.sp(v_x_665, "strokeStyle", "#2e2430")
	J.sp(v_x_665, "lineCap", "round")
	v_k_667 = (-160.0)
	while true:
		if not J.cmp(v_k_667, 320.0, "<"): break
		var _t334 = (0.25 + J.mul(J.cl(v_r_669, null, []), 0.25))
		J.sp(v_x_665, "globalAlpha", _t334)
		var _t335 = (0.8 + J.mul(J.cl(v_r_669, null, []), 1.4))
		J.sp(v_x_665, "lineWidth", _t335)
		J.mc(v_x_665, "beginPath", [])
		J.mc(v_x_665, "moveTo", [v_k_667, 160.0])
		J.mc(v_x_665, "lineTo", [J.add(v_k_667, 144.0), 0.0])
		J.mc(v_x_665, "stroke", [])
		var _t336 = J.add(v_k_667, (6.0 + J.mul(J.cl(v_r_669, null, []), 2.0)))
		v_k_667 = _t336
	J.sp(v_x_665, "globalAlpha", 1.0)
	v_q_668 = 0.0
	while true:
		if not J.cmp(v_q_668, 1400.0, "<"): break
		var _t337 = ((J.add("rgba(0,0,0,", (0.1 + J.mul(J.cl(v_r_669, null, []), 0.25))) + ")") if J.cmp(J.cl(v_r_669, null, []), 0.6, "<") else (J.add("rgba(255,240,220,", (0.03 + J.mul(J.cl(v_r_669, null, []), 0.06))) + ")"))
		J.sp(v_x_665, "fillStyle", _t337)
		J.mc(v_x_665, "fillRect", [J.mul(J.cl(v_r_669, null, []), 160.0), J.mul(J.cl(v_r_669, null, []), 160.0), (1.0 + J.mul(J.cl(v_r_669, null, []), 1.5)), J.add(1.0, J.cl(v_r_669, null, []))])
		v_q_668 = J.num(v_q_668) + 1.0
	return (J.add("url(", J.mc(v_c_664, "toDataURL", [])) + ")")

func _f115(this_, a: Array, env):
	var _t338 = J.mod(J.mul(env["s"], 16807.0), 2147483647.0)
	env["s"] = _t338
	return J.div(env["s"], 2147483647.0)

func _f114(this_, a: Array, env):
	var v_c_674 = null; var v_x_675 = null; var v_p_677 = null; var v_i_678 = null; var v_r_679 = null
	var _s282 = {"__p": env, "s": null}
	v_r_679 = Callable(self, "_f115").bind(_s282)
	v_c_674 = J.S_document_("createElement", ["canvas"])
	J.sp(v_c_674, "width", 256.0)
	J.sp(v_c_674, "height", 12.0)
	v_x_675 = J.mc(v_c_674, "getContext", ["2d"])
	_s282["s"] = 23.0
	J.sp(v_x_675, "lineCap", "round")
	v_p_677 = 0.0
	while true:
		if not J.cmp(v_p_677, 3.0, "<"): break
		var _t339 = ("rgba(0,0,0,0.6)" if J.seq(v_p_677, 2.0) else "#d8ccb0")
		J.sp(v_x_675, "strokeStyle", _t339)
		var _t340 = (0.5 if J.t(v_p_677) else 0.9)
		J.sp(v_x_675, "globalAlpha", _t340)
		var _t341 = (2.4 - J.mul(v_p_677, 0.5))
		J.sp(v_x_675, "lineWidth", _t341)
		J.mc(v_x_675, "beginPath", [])
		J.mc(v_x_675, "moveTo", [0.0, (4.0 + J.mul(v_p_677, 1.5))])
		v_i_678 = 1.0
		while true:
			if not J.cmp(v_i_678, 16.0, "<="): break
			J.mc(v_x_675, "lineTo", [J.mul(v_i_678, 16.0), ((4.0 + J.mul(v_p_677, 1.5)) + (J.sub(J.cl(v_r_679, null, []), 0.5) * 2.4))])
			v_i_678 = J.num(v_i_678) + 1.0
		J.mc(v_x_675, "stroke", [])
		v_p_677 = J.num(v_p_677) + 1.0
	return (J.add("url(", J.mc(v_c_674, "toDataURL", [])) + ")")

func _f117(this_, a: Array, env):
	var v_t_687 = null
	v_t_687 = J.arg(a, 0)
	return (J.add("border:11px solid transparent;border-image:", J.gp(env["CRF"], v_t_687)) + " 22 fill stretch;background:none;border-radius:0;")

func _f121(this_, a: Array, env):
	var _t343 = J.gp(env["el"], "classList")
	J.mc(_t343, "remove", ["press"])

func _f120(this_, a: Array, env):
	var v_e_699 = null
	var _s291 = {"__p": env, "el": null}
	_s291["el"] = J.arg(a, 0)
	var _t342 = J.gp(_s291["el"], "classList")
	J.mc(_t342, "add", ["press"])
	J.F_setTimeout([Callable(self, "_f121").bind(_s291), 160.0])
	if J.t(J.gp(J.G.get("navigator"), "vibrate")):
		J.S_navigator_("vibrate", [10.0])

func _f123(this_, a: Array, env):
	var v_e_708 = null
	v_e_708 = J.arg(a, 0)
	J.mc(v_e_708, "preventDefault", [])
	var _t346 = env["__p"]["tapFx"]
	J.cl(_t346, null, [env["b"]])
	J.cl(env["__p"]["ac"], null, [])
	J.cl(env["fn"], null, [])
	J.cl(env["__p"]["refresh"], null, [])

func _f122(this_, a: Array, env):
	var v_cls_702 = null; var v_html_703 = null
	var _s296 = {"__p": env, "fn": null, "b": null}
	v_cls_702 = J.arg(a, 0)
	v_html_703 = J.arg(a, 1)
	_s296["fn"] = J.arg(a, 2)
	_s296["b"] = J.S_document_("createElement", ["div"])
	var _t344 = _s296["b"]
	J.sp(_t344, "className", v_cls_702)
	var _t345 = _s296["b"]
	J.sp(_t345, "innerHTML", v_html_703)
	J.mc(_s296["b"], "addEventListener", ["pointerdown", Callable(self, "_f123").bind(_s296)])
	return _s296["b"]

func _f126(this_, a: Array, env):
	J.mc(env["__p"]["L"], "press", [env["f"]])

func _f125(this_, a: Array, env):
	var v_b_719 = null
	var _s300 = {"__p": env, "f": null}
	_s300["f"] = J.arg(a, 0)
	var _t355 = _s300["__p"]["mkBtn"]
	var _t356 = _s300["__p"]["lab"]
	v_b_719 = J.cl(_t355, null, ["lb", J.cl(_t356, null, [_s300["f"]]), Callable(self, "_f126").bind(_s300)])
	var _t357 = J.gp(v_b_719, "dataset")
	var _t358 = _s300["f"]
	J.sp(_t357, "f", _t358)
	J.mc(_s300["__p"]["floorsEl"], "appendChild", [v_b_719])
	var _t359 = _s300["__p"]["fBtns"]
	var _t360 = _s300["f"]
	J.sp(_t359, _t360, v_b_719)

func _f127(this_, a: Array, env):
	J.mc(env["L"], "open", [])

func _f128(this_, a: Array, env):
	J.mc(env["L"], "close", [])

func _f129(this_, a: Array, env):
	J.mc(env["L"], "exit", [])

func _f131(this_, a: Array, env):
	J.mc(env["__p"]["L"], "trick", [env["k"]])

func _f130(this_, a: Array, env):
	var v_b_731 = null
	var _s305 = {"__p": env, "k": null}
	_s305["k"] = J.arg(a, 0)
	var _t364 = _s305["__p"]["mkBtn"]
	v_b_731 = J.cl(_t364, null, ["lt", (J.add("<span>", J.gp(J.gp(_s305["__p"]["TR"], _s305["k"]), "n")) + "</span><small></small>"), Callable(self, "_f131").bind(_s305)])
	var _t365 = J.gp(v_b_731, "dataset")
	var _t366 = _s305["k"]
	J.sp(_t365, "k", _t366)
	J.mc(_s305["__p"]["trickBox"], "appendChild", [v_b_731])
	var _t367 = _s305["__p"]["tBtns"]
	var _t368 = _s305["k"]
	J.sp(_t367, _t368, v_b_731)

func _f124(this_, a: Array, env):
	var v_n_711 = null; var v_cols_712 = null; var v_order_713 = null; var v_f_714 = null; var v_ex_715 = null
	var _t347 = env["floorsEl"]
	J.sp(_t347, "innerHTML", "")
	var _t348 = env["doorsEl"]
	J.sp(_t348, "innerHTML", "")
	var _t349 = env["trickBox"]
	J.sp(_t349, "innerHTML", "")
	var _t350 = {}
	env["fBtns"] = _t350
	var _t351 = {}
	env["tBtns"] = _t351
	v_n_711 = J.add(J.cl(env["top"], null, []), 1.0)
	v_cols_712 = (v_n_711 if J.cmp(v_n_711, 7.0, "<=") else J.min_([7.0, ceil(J.num(J.div(v_n_711, 2.0)))]))
	if J.cmp(v_n_711, 14.0, ">"):
		var _t352 = ceil(J.num(J.div(v_n_711, 3.0)))
		v_cols_712 = _t352
	var _t353 = J.gp(env["floorsEl"], "style")
	var _t354 = (J.add("repeat(", v_cols_712) + ",minmax(48px,56px))")
	J.sp(_t353, "gridTemplateColumns", _t354)
	v_order_713 = []
	v_f_714 = J.cl(env["top"], null, [])
	while true:
		if not J.cmp(v_f_714, 0.0, ">="): break
		J.mc(v_order_713, "push", [v_f_714])
		v_f_714 = J.num(v_f_714) + -1.0
	J.mc(v_order_713, "forEach", [Callable(self, "_f125").bind(env)])
	var _t361 = env["mkBtn"]
	J.mc(env["doorsEl"], "appendChild", [J.cl(_t361, null, ["ld", "◀▶ 開門", Callable(self, "_f127").bind(env)])])
	var _t362 = env["mkBtn"]
	J.mc(env["doorsEl"], "appendChild", [J.cl(_t362, null, ["ld", "▶◀ 關門", Callable(self, "_f128").bind(env)])])
	var _t363 = env["mkBtn"]
	v_ex_715 = J.cl(_t363, null, ["ld exit", "出𨋢", Callable(self, "_f129").bind(env)])
	J.sp(v_ex_715, "id", "lift-exit")
	J.mc(env["doorsEl"], "appendChild", [v_ex_715])
	J.mc(env["TRK"], "forEach", [Callable(self, "_f130").bind(env)])
	env["built"] = v_n_711

func _f132(this_, a: Array, env):
	var v_NT_736 = null; var v_r_737 = null; var v_W_738 = null; var v_H_739 = null; var v_D_740 = null; var v_bot_741 = null; var v_cabH_742 = null
	v_NT_736 = J.gp(J.G.get("window"), "__twNat")
	v_r_737 = ({"left": 0.0, "top": 0.0, "width": J.gp(env["A"], "VW"), "height": J.gp(env["A"], "VH")} if J.t(v_NT_736) else J.mc(J.gp(env["A"], "cv"), "getBoundingClientRect", []))
	v_W_738 = J.gp(v_r_737, "width")
	v_H_739 = J.gp(v_r_737, "height")
	var _t371 = null
	if J.t(v_NT_736):
		_t371 = J.gp(v_NT_736, "s")
	else:
		var _t369 = J.gp(J.G.get("window"), "devicePixelRatio")
		var _t370 = J.gp(J.G.get("window"), "devicePixelRatio")
		_t371 = J.min_([2.0, (_t370 if J.t(_t370) else 1.0)])
	v_D_740 = _t371
	var _t372 = J.gp(env["ui"], "style")
	var _t373 = J.add(J.gp(v_r_737, "left"), "px")
	J.sp(_t372, "left", _t373)
	var _t374 = J.gp(env["ui"], "style")
	var _t375 = J.add(J.gp(v_r_737, "top"), "px")
	J.sp(_t374, "top", _t375)
	var _t376 = J.gp(env["ui"], "style")
	var _t377 = J.add(v_W_738, "px")
	J.sp(_t376, "width", _t377)
	var _t378 = J.gp(env["ui"], "style")
	var _t379 = J.add(v_H_739, "px")
	J.sp(_t378, "height", _t379)
	v_bot_741 = J.max_([J.gp(env["A"], "BOT"), 200.0])
	v_cabH_742 = J.round(J.num(J.min_([330.0, J.max_([200.0, (J.sub(J.sub(v_H_739, J.gp(env["A"], "TOP")), v_bot_741) * 0.62)])])))
	var _t380 = J.gp(env["cabCv"], "style")
	var _t381 = J.add(J.gp(env["A"], "TOP"), "px")
	J.sp(_t380, "top", _t381)
	var _t382 = J.gp(env["cabCv"], "style")
	var _t383 = J.add(v_cabH_742, "px")
	J.sp(_t382, "height", _t383)
	var _t384 = (not J.seq(J.gp(env["cabCv"], "width"), J.round(J.num(J.mul(v_W_738, v_D_740)))))
	if (_t384 if _t384 else (not J.seq(J.gp(env["cabCv"], "height"), J.round(J.num(J.mul(v_cabH_742, v_D_740)))))):
		var _t385 = env["cabCv"]
		var _t386 = J.round(J.num(J.mul(v_W_738, v_D_740)))
		J.sp(_t385, "width", _t386)
		var _t387 = env["cabCv"]
		var _t388 = J.round(J.num(J.mul(v_cabH_742, v_D_740)))
		J.sp(_t387, "height", _t388)
	var _t389 = J.gp(env["trickBox"], "style")
	var _t390 = J.add(J.sub(J.add(J.gp(env["A"], "TOP"), v_cabH_742), 58.0), "px")
	J.sp(_t389, "top", _t390)
	var _t391 = J.gp(env["block"], "style")
	var _t392 = J.add(J.add(J.gp(env["A"], "TOP"), v_cabH_742), "px")
	J.sp(_t391, "top", _t392)
	var _t393 = J.gp(env["block"], "style")
	var _t394 = J.add(J.max_([0.0, J.sub(J.sub(J.sub(v_H_739, v_bot_741), J.gp(env["A"], "TOP")), v_cabH_742)]), "px")
	J.sp(_t393, "height", _t394)
	var _t395 = J.gp(env["panel"], "style")
	var _t396 = J.add(J.sub(v_H_739, v_bot_741), "px")
	J.sp(_t395, "top", _t396)
	var _t397 = J.gp(env["panel"], "style")
	var _t398 = J.add(v_bot_741, "px")
	J.sp(_t397, "height", _t398)
	var _t399 = env["L"]
	var _t400 = {"y0": J.add(J.gp(env["A"], "TOP"), v_cabH_742), "y1": J.sub(v_H_739, v_bot_741)}
	J.sp(_t399, "_band", _t400)
	return {"W": v_W_738, "H": v_cabH_742, "D": v_D_740}

func _f134(this_, a: Array, env):
	var v_a_754 = null; var v_b_755 = null
	v_a_754 = J.arg(a, 0)
	v_b_755 = J.arg(a, 1)
	return J.sub(v_a_754, v_b_755)

func _f136(this_, a: Array, env):
	var v_o_764 = null
	v_o_764 = J.arg(a, 0)
	var _t410 = J.seq(J.gp(v_o_764, "ph"), "wait")
	return (J.seq(J.gp(v_o_764, "f"), env["f"]) if _t410 else _t410)

func _f135(this_, a: Array, env):
	var v_k_758 = null; var v_ok_759 = null; var v_b_760 = null; var v_show_761 = null
	v_k_758 = J.arg(a, 0)
	v_ok_759 = J.mc(env["__p"]["L"], "canTrick", [v_k_758])
	v_b_760 = J.gp(env["__p"]["tBtns"], v_k_758)
	var _t413 = J.seq(v_ok_759, true)
	if not J.t(_t413):
		var _t412 = J.seq(v_ok_759, "cd")
		if J.t(_t412):
			var _t411 = null
			if J.seq(v_k_758, "door"):
				var _t409 = J.gp(env["__p"]["S"], "riders")
				_t411 = J.mc(_t409, "some", [Callable(self, "_f136").bind(env)])
			else:
				_t411 = (J.len(env["inn"]) > 0.0)
			_t412 = _t411
		_t413 = _t412
	v_show_761 = (_t413 if J.t(_t413) else J.seq(v_ok_759, "busy"))
	var _t414 = J.gp(v_b_760, "style")
	var _t415 = ("flex" if J.t(v_show_761) else "none")
	J.sp(_t414, "display", _t415)
	if J.t(v_show_761):
		env["any"] = true
	var _t416 = J.gp(v_b_760, "classList")
	J.mc(_t416, "toggle", ["cd", (not J.seq(v_ok_759, true))])
	var _t417 = J.mc(v_b_760, "querySelector", ["small"])
	var _t418 = (J.add(ceil(J.num(J.gp(J.gp(env["__p"]["S"], "cd"), v_k_758))), "s") if J.seq(v_ok_759, "cd") else ("進行中" if J.seq(v_ok_759, "busy") else J.add("怕意+", J.gp(J.gp(env["__p"]["TR"], v_k_758), "f"))))
	J.sp(_t417, "textContent", _t418)

func _f133(this_, a: Array, env):
	var v_dest_747 = null; var v_k_748 = null; var v_ex_750 = null; var v_stTxt_751 = null
	var _s309 = {"__p": env, "f": null, "inn": null, "any": null}
	var _t401 = (not J.t(_s309["__p"]["S"]))
	if (_t401 if _t401 else J.leq(J.gp(_s309["__p"]["S"], "gi"), null)):
		return null
	if (not J.seq(_s309["__p"]["built"], J.add(J.cl(_s309["__p"]["top"], null, []), 1.0))):
		J.cl(_s309["__p"]["build"], null, [])
	_s309["f"] = J.cl(_s309["__p"]["cabF"], null, [])
	_s309["inn"] = J.cl(_s309["__p"]["inCab"], null, [])
	var _t402 = J.S_Object_("keys", [J.gp(_s309["__p"]["S"], "stops")])
	var _t403 = J.mc(_t402, "map", [J.G.get("Number")])
	v_dest_747 = J.mc(_t403, "sort", [Callable(self, "_f134").bind(_s309)])
	for _t404 in J.keys(_s309["__p"]["fBtns"]):
		v_k_748 = _t404
		var _t405 = J.gp(J.gp(_s309["__p"]["fBtns"], v_k_748), "classList")
		var _t406 = (not (not J.t(J.gp(J.gp(_s309["__p"]["S"], "lit"), v_k_748))))
		J.mc(_t405, "toggle", ["lit", (_t406 if _t406 else J.cmp(J.gp(J.gp(_s309["__p"]["S"], "fx"), "btnAll"), 0.0, ">"))])
		var _t407 = J.gp(J.gp(_s309["__p"]["fBtns"], v_k_748), "classList")
		var _t408 = J.seq(J.num(v_k_748), _s309["f"])
		J.mc(_t407, "toggle", ["cur", (J.cl(_s309["__p"]["atFloor"], null, []) if _t408 else _t408)])
	_s309["any"] = false
	J.mc(_s309["__p"]["TRK"], "forEach", [Callable(self, "_f135").bind(_s309)])
	var _t419 = J.gp(_s309["__p"]["trickBox"], "style")
	var _t420 = ("flex" if J.t(_s309["any"]) else "none")
	J.sp(_t419, "display", _t420)
	v_ex_750 = J.mc(_s309["__p"]["doorsEl"], "querySelector", ["#lift-exit"])
	if J.t(v_ex_750):
		var _t421 = J.gp(v_ex_750, "classList")
		var _t422 = J.seq(J.gp(_s309["__p"]["S"], "st"), "open")
		var _t423 = (J.cmp(J.gp(_s309["__p"]["S"], "door"), 0.8, ">") if _t422 else _t422)
		J.mc(_t421, "toggle", ["off", (not J.t((J.cl(_s309["__p"]["atFloor"], null, []) if _t423 else _t423)))])
	var _t424 = J.gp({"idle": "停定", "closed": "停定", "move": ("▲ 上緊" if J.cmp(J.gp(_s309["__p"]["S"], "dir"), 0.0, ">") else "▼ 落緊"), "opening": "開門中", "open": "門開咗", "closing": "閂門中", "stuckMove": "⚠ 卡住", "stuck": "⚠ 卡咗喺兩層中間", "unstick": "⚠ 重新起動"}, J.gp(_s309["__p"]["S"], "st"))
	v_stTxt_751 = (_t424 if J.t(_t424) else "")
	var _t425 = _s309["__p"]["stEl"]
	var _t430 = null
	if J.cmp(J.gp(_s309["__p"]["S"], "msgT"), 0.0, ">"):
		_t430 = J.gp(_s309["__p"]["S"], "msg")
	else:
		var _t426 = _s309["__p"]["lab"]
		var _t429 = J.add(J.add(J.cl(_t426, null, [_s309["f"]]), " 樓｜"), v_stTxt_751)
		var _t428 = null
		if J.t(J.len(v_dest_747)):
			var _t427 = J.mc(v_dest_747, "map", [_s309["__p"]["lab"]])
			_t428 = J.add("｜去 ", J.mc(_t427, "join", ["、"]))
		else:
			_t428 = ""
		_t430 = ((J.add(((_t429 + _t428) + "｜𨋢內 "), J.len(_s309["inn"])) + " 人") + ("" if J.t(_s309["any"]) else "（冇人一齊搭）"))
	J.sp(_t425, "textContent", _t430)

func _f138(this_, a: Array, env):
	var _t432 = J.gp(env["ui"], "classList")
	J.mc(_t432, "add", ["show"])

func _f137(this_, a: Array, env):
	if (not J.seq(env["built"], J.add(J.cl(env["top"], null, []), 1.0))):
		J.cl(env["build"], null, [])
	var _t431 = J.gp(env["ui"], "classList")
	J.mc(_t431, "add", ["on"])
	J.cl(env["layout"], null, [])
	J.F_requestAnimationFrame([Callable(self, "_f138").bind(env)])
	J.cl(env["refresh"], null, [])

func _f139(this_, a: Array, env):
	var _t433 = J.gp(env["ui"], "classList")
	J.mc(_t433, "remove", ["show"])
	var _t434 = J.gp(env["ui"], "classList")
	J.mc(_t434, "remove", ["on"])

func _f142(this_, a: Array, env):
	var _t435 = J.mod(J.mul(env["s"], 16807.0), 2147483647.0)
	env["s"] = _t435
	return J.div(env["s"], 2147483647.0)

func _f141(this_, a: Array, env):
	var v_c_775 = null; var v_i_777 = null; var v_x_778 = null; var v_y_779 = null; var v_l_780 = null; var v_j_781 = null; var v_x2_782 = null; var v_y2_783 = null; var v_r_784 = null
	var _s319 = {"__p": env, "s": null}
	v_r_784 = Callable(self, "_f142").bind(_s319)
	if J.t(_s319["__p"]["tex"]):
		return _s319["__p"]["tex"]
	var _t436 = J.S_document_("createElement", ["canvas"])
	_s319["__p"]["tex"] = _t436
	var _t437 = _s319["__p"]["tex"]
	J.sp(_t437, "width", 256.0)
	var _t438 = _s319["__p"]["tex"]
	J.sp(_t438, "height", 256.0)
	v_c_775 = J.mc(_s319["__p"]["tex"], "getContext", ["2d"])
	_s319["s"] = 7.0
	J.sp(v_c_775, "strokeStyle", "rgba(0,0,0,0.5)")
	J.sp(v_c_775, "lineWidth", 1.0)
	v_i_777 = 0.0
	while true:
		if not J.cmp(v_i_777, 900.0, "<"): break
		v_x_778 = J.mul(J.cl(v_r_784, null, []), 256.0)
		v_y_779 = J.mul(J.cl(v_r_784, null, []), 256.0)
		v_l_780 = (3.0 + J.mul(J.cl(v_r_784, null, []), 9.0))
		var _t439 = (0.25 + J.mul(J.cl(v_r_784, null, []), 0.4))
		J.sp(v_c_775, "globalAlpha", _t439)
		J.mc(v_c_775, "beginPath", [])
		J.mc(v_c_775, "moveTo", [v_x_778, v_y_779])
		J.mc(v_c_775, "lineTo", [J.add(v_x_778, v_l_780), J.sub(v_y_779, J.mul(v_l_780, 0.35))])
		J.mc(v_c_775, "stroke", [])
		v_i_777 = J.num(v_i_777) + 1.0
	J.sp(v_c_775, "strokeStyle", "rgba(255,255,255,0.6)")
	v_j_781 = 0.0
	while true:
		if not J.cmp(v_j_781, 300.0, "<"): break
		v_x2_782 = J.mul(J.cl(v_r_784, null, []), 256.0)
		v_y2_783 = J.mul(J.cl(v_r_784, null, []), 256.0)
		var _t440 = (0.15 + J.mul(J.cl(v_r_784, null, []), 0.3))
		J.sp(v_c_775, "globalAlpha", _t440)
		J.mc(v_c_775, "beginPath", [])
		J.mc(v_c_775, "moveTo", [v_x2_782, v_y2_783])
		J.mc(v_c_775, "lineTo", [J.add(J.add(v_x2_782, 4.0), J.mul(J.cl(v_r_784, null, []), 6.0)), J.add(v_y2_783, J.mul(J.cl(v_r_784, null, []), 2.0))])
		J.mc(v_c_775, "stroke", [])
		v_j_781 = J.num(v_j_781) + 1.0
	return _s319["__p"]["tex"]

func _f143(this_, a: Array, env):
	var v_c_789 = null; var v_pts_790 = null; var v_fill_791 = null; var v_i_792 = null
	v_c_789 = J.arg(a, 0)
	v_pts_790 = J.arg(a, 1)
	v_fill_791 = J.arg(a, 2)
	J.mc(v_c_789, "beginPath", [])
	J.mc(v_c_789, "moveTo", [J.gp(v_pts_790, 0.0), J.gp(v_pts_790, 1.0)])
	v_i_792 = 2.0
	while true:
		if not J.cmp(v_i_792, J.len(v_pts_790), "<"): break
		J.mc(v_c_789, "lineTo", [J.gp(v_pts_790, v_i_792), J.gp(v_pts_790, J.add(v_i_792, 1.0))])
		var _t441 = J.add(v_i_792, 2.0)
		v_i_792 = _t441
	J.mc(v_c_789, "closePath", [])
	J.sp(v_c_789, "fillStyle", v_fill_791)
	J.mc(v_c_789, "fill", [])

func _f144(this_, a: Array, env):
	var v_c_795 = null; var v_pts_796 = null; var v_a_797 = null; var v_i_798 = null
	v_c_795 = J.arg(a, 0)
	v_pts_796 = J.arg(a, 1)
	v_a_797 = J.arg(a, 2)
	J.mc(v_c_795, "save", [])
	J.mc(v_c_795, "beginPath", [])
	J.mc(v_c_795, "moveTo", [J.gp(v_pts_796, 0.0), J.gp(v_pts_796, 1.0)])
	v_i_798 = 2.0
	while true:
		if not J.cmp(v_i_798, J.len(v_pts_796), "<"): break
		J.mc(v_c_795, "lineTo", [J.gp(v_pts_796, v_i_798), J.gp(v_pts_796, J.add(v_i_798, 1.0))])
		var _t442 = J.add(v_i_798, 2.0)
		v_i_798 = _t442
	J.mc(v_c_795, "closePath", [])
	J.mc(v_c_795, "clip", [])
	var _t443 = (v_a_797 if J.t(v_a_797) else 0.18)
	J.sp(v_c_795, "globalAlpha", _t443)
	var _t444 = J.mc(v_c_795, "createPattern", [J.cl(env["crayonTex"], null, []), "repeat"])
	J.sp(v_c_795, "fillStyle", _t444)
	J.mc(v_c_795, "fillRect", [0.0, 0.0, 4000.0, 4000.0])
	J.mc(v_c_795, "restore", [])

func _f146(this_, a: Array, env):
	var v_o_855 = null; var v_i_856 = null
	v_o_855 = J.arg(a, 0)
	v_i_856 = J.arg(a, 1)
	var _t468 = env["__p"]["sprAt"]
	var _t470 = env["c"]
	var _t469 = env["__p"]["riderSpr"]
	J.cl(_t468, null, [_t470, J.cl(_t469, null, [v_o_855]), (J.sub(env["W"], 40.0) - J.mul(v_i_856, 18.0)), J.mul(env["H"], 0.6), J.mul(env["H"], 0.4), 0.35, true])

func _f147(this_, a: Array, env):
	var v_o_859 = null
	v_o_859 = J.arg(a, 0)
	var _t492 = J.seq(J.gp(v_o_859, "ph"), "wait")
	return (J.seq(J.gp(v_o_859, "f"), env["f"]) if _t492 else _t492)

func _f148(this_, a: Array, env):
	var v_o_862 = null; var v_i_863 = null
	v_o_862 = J.arg(a, 0)
	v_i_863 = J.arg(a, 1)
	var _t494 = env["__p"]["sprAt"]
	var _t496 = env["c"]
	var _t495 = env["__p"]["riderSpr"]
	J.cl(_t494, null, [_t496, J.cl(_t495, null, [v_o_862]), J.add(env["dx0"], J.mul(env["dw"], (0.78 if J.t(J.mod(v_i_863, 2.0)) else 0.22))), J.add(env["dy0"], env["dh"]), J.mul(env["dh"], 0.85), 1.0, J.seq(J.mod(v_i_863, 2.0), 0.0)])

func _f149(this_, a: Array, env):
	var v_s_866 = null; var v_x_867 = null; var v_dg_868 = null
	v_s_866 = J.arg(a, 0)
	v_x_867 = (J.sub(J.add(env["dx0"], env["dw"]), env["pw"]) if J.t(v_s_866) else env["dx0"])
	v_dg_868 = J.mc(env["c"], "createLinearGradient", [v_x_867, 0.0, J.add(v_x_867, env["pw"]), 0.0])
	J.mc(v_dg_868, "addColorStop", [0.0, "#9da1a5"])
	J.mc(v_dg_868, "addColorStop", [0.5, "#cfd2d5"])
	J.mc(v_dg_868, "addColorStop", [1.0, "#8a8e92"])
	var _t502 = env["c"]
	J.sp(_t502, "fillStyle", v_dg_868)
	J.mc(env["c"], "fillRect", [v_x_867, env["dy0"], env["pw"], env["dh"]])
	var _t503 = env["__p"]["texFill"]
	J.cl(_t503, null, [env["c"], [v_x_867, env["dy0"], J.add(v_x_867, env["pw"]), env["dy0"], J.add(v_x_867, env["pw"]), J.add(env["dy0"], env["dh"]), v_x_867, J.add(env["dy0"], env["dh"])], 0.12])

func _f150(this_, a: Array, env):
	var v_o_871 = null; var v_i_872 = null; var v_x_873 = null; var v_cower_874 = null; var v_hh_875 = null; var v_shk_876 = null; var v_rk_877 = null; var v_tw_878 = null; var v_bx_879 = null; var v_byy_880 = null
	v_o_871 = J.arg(a, 0)
	v_i_872 = J.arg(a, 1)
	v_x_873 = J.gp(env["slots"], J.mod(v_i_872, 4.0))
	v_cower_874 = J.seq(J.gp(v_o_871, "mood"), "cower")
	v_hh_875 = J.mul(env["H"], (0.5 if J.t(v_cower_874) else 0.78))
	v_shk_876 = ((sin(J.num(J.add(J.mul(env["t"], 40.0), v_i_872))) * 1.8) if J.t((v_cower_874 if J.t(v_cower_874) else J.seq(J.gp(v_o_871, "mood"), "bolt"))) else 0.0)
	var _t528 = env["__p"]["rKey"]
	v_rk_877 = J.cl(_t528, null, [v_o_871])
	var _t529 = env["__p"]["sprAt"]
	var _t534 = env["c"]
	var _t535 = J.add(v_x_873, v_shk_876)
	var _t536 = J.add(env["H"], 4.0)
	var _t531 = J.mul(env["H"], 0.9)
	var _t530 = env["__p"]["rH"]
	var _t533 = J.mul(env["H"], 0.9)
	var _t532 = env["__p"]["rH"]
	J.cl(_t529, null, [_t534, v_rk_877, _t535, _t536, J.min_([_t533, J.cl(_t532, null, [v_o_871, v_rk_877, v_hh_875])]), 1.0, J.cmp(v_x_873, J.div(env["W"], 2.0), ">")])
	if J.t(J.gp(v_o_871, "say")):
		var _t537 = env["c"]
		var _t538 = J.add("bold 13px ", J.gp(env["__p"]["A"], "FONT"))
		J.sp(_t537, "font", _t538)
		v_tw_878 = J.min_([J.mul(env["W"], 0.46), J.add(J.gp(J.mc(env["c"], "measureText", [J.gp(v_o_871, "say")]), "width"), 14.0)])
		v_bx_879 = J.max_([4.0, J.min_([(J.sub(env["W"], v_tw_878) - 4.0), J.sub(v_x_873, J.div(v_tw_878, 2.0))])])
		v_byy_880 = (J.mul(env["H"], 0.2) + J.mul(v_i_872, 28.0))
		var _t539 = env["c"]
		J.sp(_t539, "fillStyle", "rgba(255,250,240,0.96)")
		J.mc(env["c"], "fillRect", [v_bx_879, v_byy_880, v_tw_878, 24.0])
		var _t540 = env["c"]
		J.sp(_t540, "strokeStyle", "#1a1a1e")
		var _t541 = env["c"]
		J.sp(_t541, "lineWidth", 1.5)
		J.mc(env["c"], "strokeRect", [v_bx_879, v_byy_880, v_tw_878, 24.0])
		var _t542 = env["c"]
		J.sp(_t542, "fillStyle", "#1a1a1e")
		var _t543 = env["c"]
		J.sp(_t543, "textAlign", "center")
		J.mc(env["c"], "fillText", [J.gp(v_o_871, "say"), J.add(v_bx_879, J.div(v_tw_878, 2.0)), J.add(v_byy_880, 17.0), J.sub(v_tw_878, 6.0)])

func _f145(this_, a: Array, env):
	var v_NT_801 = null; var v_Lo_802 = null; var v_mv_807 = null; var v_sx_808 = null; var v_sy_809 = null; var v_bx0_810 = null; var v_bx1_811 = null; var v_by0_812 = null; var v_by1_813 = null; var v_lit_814 = null; var v_lg_815 = null; var v_i_816 = null; var v_q_817 = null; var v_lw_818 = null; var v_rw_819 = null; var v_gl_820 = null; var v_gr_821 = null; var v_j_822 = null; var v_xx_823 = null; var v_mr_824 = null; var v_mg_825 = null; var v_m_826 = null; var v_inn_827 = null; var v_a_828 = null; var v_hx_829 = null; var v_hy_830 = null; var v_m2_831 = null; var v_b_832 = null; var v_onB_833 = null; var v_op_838 = null; var v_sl_840 = null; var v_k_842 = null; var v_yy_843 = null; var v_ix_844 = null; var v_iy_845 = null; var v_stuck_846 = null; var v_ovr_847 = null; var v_g_848 = null; var v_dk_850 = null; var v_ey_851 = null; var v_vg_852 = null
	var _s329 = {"__p": env, "W": null, "H": null, "c": null, "t": null, "dw": null, "dx0": null, "dy0": null, "dh": null, "f": null, "pw": null, "slots": null}
	var _t445 = (not J.t(_s329["__p"]["S"]))
	if (_t445 if _t445 else J.leq(J.gp(_s329["__p"]["S"], "gi"), null)):
		return null
	v_NT_801 = J.gp(J.G.get("window"), "__twNat")
	v_Lo_802 = J.cl(_s329["__p"]["layout"], null, [])
	_s329["W"] = J.gp(v_Lo_802, "W")
	_s329["H"] = J.gp(v_Lo_802, "H")
	_s329["c"] = (J.gp(v_NT_801, "cab") if J.t((J.gp(v_NT_801, "cab") if J.t(v_NT_801) else v_NT_801)) else _s329["__p"]["cx2"])
	_s329["t"] = J.gp(_s329["__p"]["S"], "t")
	J.mc(_s329["c"], "setTransform", [J.gp(v_Lo_802, "D"), 0.0, 0.0, J.gp(v_Lo_802, "D"), 0.0, 0.0])
	if (not J.t((J.gp(v_NT_801, "cab") if J.t(v_NT_801) else v_NT_801))):
		J.mc(_s329["c"], "clearRect", [0.0, 0.0, _s329["W"], _s329["H"]])
	var _t446 = J.seq(J.gp(_s329["__p"]["S"], "st"), "move")
	v_mv_807 = (_t446 if _t446 else J.seq(J.gp(_s329["__p"]["S"], "st"), "stuckMove"))
	v_sx_808 = ((((sin(J.num(J.mul(_s329["t"], 37.0))) * 1.1) + (sin(J.num(J.mul(_s329["t"], 53.0))) * 0.6)) if J.t(v_mv_807) else 0.0) + (J.mul(((randf() - 0.5) * 8.0), J.gp(_s329["__p"]["S"], "shake")) if J.cmp(J.gp(_s329["__p"]["S"], "shake"), 0.0, ">") else 0.0))
	v_sy_809 = ((sin(J.num(J.mul(_s329["t"], 29.0))) * 0.9) if J.t(v_mv_807) else 0.0)
	J.mc(_s329["c"], "save", [])
	J.mc(_s329["c"], "translate", [v_sx_808, v_sy_809])
	v_bx0_810 = J.mul(_s329["W"], 0.25)
	v_bx1_811 = J.mul(_s329["W"], 0.75)
	v_by0_812 = J.mul(_s329["H"], 0.2)
	v_by1_813 = J.mul(_s329["H"], 0.84)
	var _t447 = _s329["__p"]["poly"]
	J.cl(_t447, null, [_s329["c"], [(-10.0), (-10.0), J.add(_s329["W"], 10.0), (-10.0), v_bx1_811, v_by0_812, v_bx0_810, v_by0_812], "#5d5847"])
	var _t448 = _s329["__p"]["texFill"]
	J.cl(_t448, null, [_s329["c"], [(-10.0), (-10.0), J.add(_s329["W"], 10.0), (-10.0), v_bx1_811, v_by0_812, v_bx0_810, v_by0_812], 0.2])
	v_lit_814 = J.cl(_s329["__p"]["lightLevel"], null, [])
	v_lg_815 = J.mc(_s329["c"], "createRadialGradient", [J.div(_s329["W"], 2.0), J.mul(_s329["H"], 0.06), 4.0, J.div(_s329["W"], 2.0), J.mul(_s329["H"], 0.06), J.mul(_s329["W"], 0.55)])
	J.mc(v_lg_815, "addColorStop", [0.0, (J.add("rgba(255,232,160,", J.mul(0.95, v_lit_814)) + ")")])
	J.mc(v_lg_815, "addColorStop", [1.0, "rgba(255,232,160,0)"])
	var _t449 = _s329["c"]
	J.sp(_t449, "fillStyle", v_lg_815)
	J.mc(_s329["c"], "fillRect", [0.0, 0.0, _s329["W"], J.mul(_s329["H"], 0.5)])
	var _t450 = _s329["c"]
	var _t451 = (J.add("rgba(255,240,190,", J.mul(0.9, v_lit_814)) + ")")
	J.sp(_t450, "fillStyle", _t451)
	J.mc(_s329["c"], "fillRect", [J.mul(_s329["W"], 0.36), J.mul(_s329["H"], 0.05), J.mul(_s329["W"], 0.28), J.mul(_s329["H"], 0.05)])
	var _t452 = _s329["__p"]["poly"]
	J.cl(_t452, null, [_s329["c"], [(-10.0), J.add(_s329["H"], 10.0), J.add(_s329["W"], 10.0), J.add(_s329["H"], 10.0), v_bx1_811, v_by1_813, v_bx0_810, v_by1_813], "#4b4034"])
	var _t453 = _s329["__p"]["texFill"]
	J.cl(_t453, null, [_s329["c"], [(-10.0), J.add(_s329["H"], 10.0), J.add(_s329["W"], 10.0), J.add(_s329["H"], 10.0), v_bx1_811, v_by1_813, v_bx0_810, v_by1_813], 0.25])
	var _t454 = _s329["c"]
	J.sp(_t454, "strokeStyle", "rgba(0,0,0,0.25)")
	var _t455 = _s329["c"]
	J.sp(_t455, "lineWidth", 1.0)
	v_i_816 = 1.0
	while true:
		if not J.cmp(v_i_816, 6.0, "<"): break
		v_q_817 = J.div(v_i_816, 6.0)
		J.mc(_s329["c"], "beginPath", [])
		J.mc(_s329["c"], "moveTo", [J.add(v_bx0_810, J.mul(J.sub(v_bx1_811, v_bx0_810), v_q_817)), v_by1_813])
		J.mc(_s329["c"], "lineTo", [((-10.0) + J.mul(J.add(_s329["W"], 20.0), v_q_817)), J.add(_s329["H"], 10.0)])
		J.mc(_s329["c"], "stroke", [])
		v_i_816 = J.num(v_i_816) + 1.0
	v_lw_818 = [(-10.0), (-10.0), v_bx0_810, v_by0_812, v_bx0_810, v_by1_813, (-10.0), J.add(_s329["H"], 10.0)]
	v_rw_819 = [J.add(_s329["W"], 10.0), (-10.0), v_bx1_811, v_by0_812, v_bx1_811, v_by1_813, J.add(_s329["W"], 10.0), J.add(_s329["H"], 10.0)]
	v_gl_820 = J.mc(_s329["c"], "createLinearGradient", [0.0, 0.0, v_bx0_810, 0.0])
	J.mc(v_gl_820, "addColorStop", [0.0, "#7c8084"])
	J.mc(v_gl_820, "addColorStop", [1.0, "#a9adb1"])
	var _t456 = _s329["__p"]["poly"]
	J.cl(_t456, null, [_s329["c"], v_lw_818, v_gl_820])
	var _t457 = _s329["__p"]["texFill"]
	J.cl(_t457, null, [_s329["c"], v_lw_818, 0.22])
	v_gr_821 = J.mc(_s329["c"], "createLinearGradient", [_s329["W"], 0.0, v_bx1_811, 0.0])
	J.mc(v_gr_821, "addColorStop", [0.0, "#74787c"])
	J.mc(v_gr_821, "addColorStop", [1.0, "#a3a7ab"])
	var _t458 = _s329["__p"]["poly"]
	J.cl(_t458, null, [_s329["c"], v_rw_819, v_gr_821])
	var _t459 = _s329["__p"]["texFill"]
	J.cl(_t459, null, [_s329["c"], v_rw_819, 0.22])
	var _t460 = _s329["c"]
	J.sp(_t460, "strokeStyle", "rgba(255,255,255,0.12)")
	v_j_822 = 0.0
	while true:
		if not J.cmp(v_j_822, 9.0, "<"): break
		v_xx_823 = J.div(J.mul(v_bx0_810, v_j_822), 9.0)
		J.mc(_s329["c"], "beginPath", [])
		J.mc(_s329["c"], "moveTo", [v_xx_823, ((-10.0) + J.div(J.mul(J.add(v_by0_812, 10.0), v_j_822), 9.0))])
		J.mc(_s329["c"], "lineTo", [v_xx_823, J.sub(J.add(_s329["H"], 10.0), J.div(J.mul(J.sub(J.add(_s329["H"], 10.0), v_by1_813), v_j_822), 9.0))])
		J.mc(_s329["c"], "stroke", [])
		v_j_822 = J.num(v_j_822) + 1.0
	var _t461 = _s329["c"]
	J.sp(_t461, "strokeStyle", "#d8c690")
	var _t462 = _s329["c"]
	J.sp(_t462, "lineWidth", 6.0)
	var _t463 = _s329["c"]
	J.sp(_t463, "lineCap", "round")
	J.mc(_s329["c"], "beginPath", [])
	J.mc(_s329["c"], "moveTo", [6.0, J.mul(_s329["H"], 0.66)])
	J.mc(_s329["c"], "lineTo", [J.sub(v_bx0_810, 4.0), J.add(v_by0_812, (J.sub(v_by1_813, v_by0_812) * 0.62))])
	J.mc(_s329["c"], "stroke", [])
	J.mc(_s329["c"], "beginPath", [])
	J.mc(_s329["c"], "moveTo", [J.sub(_s329["W"], 6.0), J.mul(_s329["H"], 0.66)])
	J.mc(_s329["c"], "lineTo", [J.add(v_bx1_811, 4.0), J.add(v_by0_812, (J.sub(v_by1_813, v_by0_812) * 0.62))])
	J.mc(_s329["c"], "stroke", [])
	var _t464 = _s329["c"]
	J.sp(_t464, "strokeStyle", "#6a5a30")
	var _t465 = _s329["c"]
	J.sp(_t465, "lineWidth", 2.0)
	J.mc(_s329["c"], "beginPath", [])
	J.mc(_s329["c"], "moveTo", [6.0, (J.mul(_s329["H"], 0.66) + 3.0)])
	J.mc(_s329["c"], "lineTo", [J.sub(v_bx0_810, 4.0), J.add(J.add(v_by0_812, (J.sub(v_by1_813, v_by0_812) * 0.62)), 2.0)])
	J.mc(_s329["c"], "stroke", [])
	v_mr_824 = [J.sub(_s329["W"], 16.0), J.mul(_s329["H"], 0.12), J.add(v_bx1_811, 8.0), J.add(v_by0_812, 10.0), J.add(v_bx1_811, 8.0), J.add(v_by0_812, (J.sub(v_by1_813, v_by0_812) * 0.56)), J.sub(_s329["W"], 16.0), J.mul(_s329["H"], 0.6)]
	v_mg_825 = J.mc(_s329["c"], "createLinearGradient", [_s329["W"], 0.0, v_bx1_811, _s329["H"]])
	J.mc(v_mg_825, "addColorStop", [0.0, "#6f8894"])
	J.mc(v_mg_825, "addColorStop", [0.5, "#a8c0c8"])
	J.mc(v_mg_825, "addColorStop", [1.0, "#56707c"])
	var _t466 = _s329["__p"]["poly"]
	J.cl(_t466, null, [_s329["c"], v_mr_824, v_mg_825])
	J.mc(_s329["c"], "save", [])
	J.mc(_s329["c"], "beginPath", [])
	J.mc(_s329["c"], "moveTo", [J.gp(v_mr_824, 0.0), J.gp(v_mr_824, 1.0)])
	v_m_826 = 2.0
	while true:
		if not J.cmp(v_m_826, 8.0, "<"): break
		J.mc(_s329["c"], "lineTo", [J.gp(v_mr_824, v_m_826), J.gp(v_mr_824, J.add(v_m_826, 1.0))])
		var _t467 = J.add(v_m_826, 2.0)
		v_m_826 = _t467
	J.mc(_s329["c"], "closePath", [])
	J.mc(_s329["c"], "clip", [])
	v_inn_827 = J.cl(_s329["__p"]["inCab"], null, [])
	J.mc(v_inn_827, "forEach", [Callable(self, "_f146").bind(_s329)])
	if J.cmp(J.gp(J.gp(_s329["__p"]["S"], "fx"), "mirror"), 0.0, ">"):
		v_a_828 = J.min_([1.0, J.div(J.gp(J.gp(_s329["__p"]["S"], "fx"), "mirror"), 0.6), J.div(J.sub(3.6, J.gp(J.gp(_s329["__p"]["S"], "fx"), "mirror")), 0.4)])
		var _t471 = _s329["c"]
		var _t472 = J.mul(0.85, v_a_828)
		J.sp(_t471, "globalAlpha", _t472)
		var _t473 = _s329["c"]
		J.sp(_t473, "fillStyle", "#0c0f12")
		v_hx_829 = J.sub(_s329["W"], 58.0)
		v_hy_830 = J.mul(_s329["H"], 0.26)
		J.mc(_s329["c"], "beginPath", [])
		J.mc(_s329["c"], "ellipse", [v_hx_829, v_hy_830, 11.0, 14.0, 0.0, 0.0, 7.0])
		J.mc(_s329["c"], "fill", [])
		J.mc(_s329["c"], "beginPath", [])
		J.mc(_s329["c"], "moveTo", [J.sub(v_hx_829, 14.0), J.add(v_hy_830, 4.0)])
		J.mc(_s329["c"], "quadraticCurveTo", [J.sub(v_hx_829, 20.0), J.add(v_hy_830, 60.0), J.sub(v_hx_829, 16.0), J.mul(_s329["H"], 0.6)])
		J.mc(_s329["c"], "lineTo", [J.add(v_hx_829, 16.0), J.mul(_s329["H"], 0.6)])
		J.mc(_s329["c"], "quadraticCurveTo", [J.add(v_hx_829, 20.0), J.add(v_hy_830, 60.0), J.add(v_hx_829, 14.0), J.add(v_hy_830, 4.0)])
		J.mc(_s329["c"], "closePath", [])
		J.mc(_s329["c"], "fill", [])
		var _t474 = _s329["c"]
		var _t475 = (J.add("rgba(255,255,255,", J.mul(0.7, v_a_828)) + ")")
		J.sp(_t474, "fillStyle", _t475)
		J.mc(_s329["c"], "fillRect", [J.sub(v_hx_829, 5.0), J.sub(v_hy_830, 2.0), 2.0, 2.0])
		J.mc(_s329["c"], "fillRect", [J.add(v_hx_829, 3.0), J.sub(v_hy_830, 2.0), 2.0, 2.0])
		var _t476 = _s329["c"]
		J.sp(_t476, "globalAlpha", 1.0)
	var _t477 = _s329["c"]
	J.sp(_t477, "fillStyle", "rgba(255,255,255,0.25)")
	J.mc(_s329["c"], "beginPath", [])
	J.mc(_s329["c"], "moveTo", [J.sub(_s329["W"], 30.0), J.mul(_s329["H"], 0.15)])
	J.mc(_s329["c"], "lineTo", [J.sub(_s329["W"], 24.0), J.mul(_s329["H"], 0.15)])
	J.mc(_s329["c"], "lineTo", [J.add(v_bx1_811, 30.0), J.add(v_by0_812, 60.0)])
	J.mc(_s329["c"], "lineTo", [J.add(v_bx1_811, 24.0), J.add(v_by0_812, 60.0)])
	J.mc(_s329["c"], "fill", [])
	J.mc(_s329["c"], "restore", [])
	var _t478 = _s329["c"]
	J.sp(_t478, "strokeStyle", "#c8b878")
	var _t479 = _s329["c"]
	J.sp(_t479, "lineWidth", 3.0)
	J.mc(_s329["c"], "beginPath", [])
	J.mc(_s329["c"], "moveTo", [J.gp(v_mr_824, 0.0), J.gp(v_mr_824, 1.0)])
	v_m2_831 = 2.0
	while true:
		if not J.cmp(v_m2_831, 8.0, "<"): break
		J.mc(_s329["c"], "lineTo", [J.gp(v_mr_824, v_m2_831), J.gp(v_mr_824, J.add(v_m2_831, 1.0))])
		var _t480 = J.add(v_m2_831, 2.0)
		v_m2_831 = _t480
	J.mc(_s329["c"], "closePath", [])
	J.mc(_s329["c"], "stroke", [])
	var _t481 = _s329["c"]
	J.sp(_t481, "fillStyle", "#3a3c40")
	J.mc(_s329["c"], "fillRect", [J.sub(v_bx0_810, 38.0), J.add(v_by0_812, 28.0), 22.0, 58.0])
	v_b_832 = 0.0
	while true:
		if not J.cmp(v_b_832, 6.0, "<"): break
		v_onB_833 = (J.seq(J.mod(floor(J.num(J.add(J.mul(_s329["t"], 10.0), v_b_832))), 2.0), 0.0) if J.cmp(J.gp(J.gp(_s329["__p"]["S"], "fx"), "btnAll"), 0.0, ">") else (not (not J.t(J.gp(J.gp(_s329["__p"]["S"], "lit"), J.sub(J.cl(_s329["__p"]["top"], null, []), v_b_832))))))
		var _t482 = _s329["c"]
		var _t483 = ("#ffb347" if J.t(v_onB_833) else "#8a8d90")
		J.sp(_t482, "fillStyle", _t483)
		J.mc(_s329["c"], "beginPath", [])
		J.mc(_s329["c"], "arc", [J.sub(v_bx0_810, 27.0), J.add(J.add(v_by0_812, 36.0), J.mul(v_b_832, 9.0)), 3.0, 0.0, 7.0])
		J.mc(_s329["c"], "fill", [])
		v_b_832 = J.num(v_b_832) + 1.0
	_s329["dw"] = (J.sub(v_bx1_811, v_bx0_810) * 0.8)
	_s329["dx0"] = (J.div(_s329["W"], 2.0) - J.div(_s329["dw"], 2.0))
	_s329["dy0"] = J.add(v_by0_812, (J.sub(v_by1_813, v_by0_812) * 0.14))
	_s329["dh"] = J.sub(v_by1_813, _s329["dy0"])
	var _t484 = _s329["c"]
	J.sp(_t484, "fillStyle", "#8e9296")
	J.mc(_s329["c"], "fillRect", [v_bx0_810, v_by0_812, J.sub(v_bx1_811, v_bx0_810), J.sub(v_by1_813, v_by0_812)])
	var _t485 = _s329["__p"]["texFill"]
	J.cl(_t485, null, [_s329["c"], [v_bx0_810, v_by0_812, v_bx1_811, v_by0_812, v_bx1_811, v_by1_813, v_bx0_810, v_by1_813], 0.15])
	v_op_838 = J.gp(_s329["__p"]["S"], "door")
	J.mc(_s329["c"], "save", [])
	J.mc(_s329["c"], "beginPath", [])
	J.mc(_s329["c"], "rect", [_s329["dx0"], _s329["dy0"], _s329["dw"], _s329["dh"]])
	J.mc(_s329["c"], "clip", [])
	var _t487 = J.cl(_s329["__p"]["atFloor"], null, [])
	if not J.t(_t487):
		var _t486 = (not J.seq(J.gp(_s329["__p"]["S"], "st"), "stuck"))
		_t487 = ((not J.seq(J.gp(_s329["__p"]["S"], "st"), "unstick")) if _t486 else _t486)
	if J.t(_t487):
		var _t488 = _s329["c"]
		J.sp(_t488, "fillStyle", "#2c2b24")
		J.mc(_s329["c"], "fillRect", [_s329["dx0"], _s329["dy0"], _s329["dw"], _s329["dh"]])
		var _t489 = _s329["c"]
		J.sp(_t489, "fillStyle", "#4a4535")
		J.mc(_s329["c"], "fillRect", [_s329["dx0"], J.add(_s329["dy0"], J.mul(_s329["dh"], 0.82)), _s329["dw"], J.mul(_s329["dh"], 0.18)])
		var _t490 = _s329["c"]
		J.sp(_t490, "fillStyle", "rgba(255,214,140,0.25)")
		J.mc(_s329["c"], "beginPath", [])
		J.mc(_s329["c"], "arc", [J.div(_s329["W"], 2.0), J.add(_s329["dy0"], 10.0), 40.0, 0.0, 7.0])
		J.mc(_s329["c"], "fill", [])
		_s329["f"] = J.cl(_s329["__p"]["cabF"], null, [])
		var _t491 = J.gp(_s329["__p"]["S"], "riders")
		var _t493 = J.mc(_t491, "filter", [Callable(self, "_f147").bind(_s329)])
		J.mc(_t493, "forEach", [Callable(self, "_f148").bind(_s329)])
	else:
		var _t497 = _s329["c"]
		J.sp(_t497, "fillStyle", "#5e594d")
		J.mc(_s329["c"], "fillRect", [_s329["dx0"], _s329["dy0"], _s329["dw"], _s329["dh"]])
		var _t498 = _s329["__p"]["texFill"]
		J.cl(_t498, null, [_s329["c"], [_s329["dx0"], _s329["dy0"], J.add(_s329["dx0"], _s329["dw"]), _s329["dy0"], J.add(_s329["dx0"], _s329["dw"]), J.add(_s329["dy0"], _s329["dh"]), _s329["dx0"], J.add(_s329["dy0"], _s329["dh"])], 0.35])
		var _t499 = _s329["c"]
		J.sp(_t499, "fillStyle", "#3a362e")
		v_sl_840 = J.add(_s329["dy0"], J.mul(_s329["dh"], (0.35 + (0.1 * sin(J.num(1.0))))))
		J.mc(_s329["c"], "fillRect", [_s329["dx0"], v_sl_840, _s329["dw"], J.mul(_s329["dh"], 0.16)])
		var _t500 = _s329["c"]
		J.sp(_t500, "fillStyle", "rgba(0,0,0,0.5)")
		J.mc(_s329["c"], "fillRect", [_s329["dx0"], J.add(v_sl_840, J.mul(_s329["dh"], 0.16)), _s329["dw"], 4.0])
	J.mc(_s329["c"], "restore", [])
	_s329["pw"] = (J.div(_s329["dw"], 2.0) * J.sub(1.0, v_op_838))
	var _t501 = [0.0, 1.0]
	J.mc(_t501, "forEach", [Callable(self, "_f149").bind(_s329)])
	var _t504 = _s329["c"]
	J.sp(_t504, "fillStyle", "#1d1e20")
	J.mc(_s329["c"], "fillRect", [(J.div(_s329["W"], 2.0) - 1.0), _s329["dy0"], 2.0, J.mul(_s329["dh"], (1.0 if J.cmp(v_op_838, 0.02, "<") else 0.0))])
	if J.t((J.cmp(v_op_838, 0.02, "<") if J.t(v_mv_807) else v_mv_807)):
		v_k_842 = 0.0
		while true:
			if not J.cmp(v_k_842, 4.0, "<"): break
			v_yy_843 = J.add(_s329["dy0"], J.mod(J.add(J.mod((J.mul(_s329["t"], (260.0 if J.cmp(J.gp(_s329["__p"]["S"], "dir"), 0.0, ">") else (-260.0))) + J.div(J.mul(v_k_842, _s329["dh"]), 4.0)), _s329["dh"]), _s329["dh"]), _s329["dh"]))
			var _t505 = _s329["c"]
			J.sp(_t505, "fillStyle", "rgba(255,240,200,0.55)")
			J.mc(_s329["c"], "fillRect", [(J.div(_s329["W"], 2.0) - 1.5), v_yy_843, 3.0, 10.0])
			v_k_842 = J.num(v_k_842) + 1.0
	var _t506 = _s329["c"]
	J.sp(_t506, "strokeStyle", "#5c5f63")
	var _t507 = _s329["c"]
	J.sp(_t507, "lineWidth", 4.0)
	J.mc(_s329["c"], "strokeRect", [J.sub(_s329["dx0"], 2.0), J.sub(_s329["dy0"], 2.0), J.add(_s329["dw"], 4.0), J.add(_s329["dh"], 4.0)])
	v_ix_844 = (J.div(_s329["W"], 2.0) - 38.0)
	v_iy_845 = J.sub(v_by0_812, 2.0)
	var _t508 = _s329["c"]
	J.sp(_t508, "fillStyle", "#111")
	J.mc(_s329["c"], "fillRect", [v_ix_844, v_iy_845, 76.0, ((J.sub(_s329["dy0"], v_iy_845) - 6.0) if ((J.sub(_s329["dy0"], v_iy_845) - 6.0) > 18.0) else 22.0)])
	var _t509 = _s329["c"]
	J.sp(_t509, "strokeStyle", "#777")
	var _t510 = _s329["c"]
	J.sp(_t510, "lineWidth", 1.5)
	J.mc(_s329["c"], "strokeRect", [v_ix_844, v_iy_845, 76.0, ((J.sub(_s329["dy0"], v_iy_845) - 6.0) if ((J.sub(_s329["dy0"], v_iy_845) - 6.0) > 18.0) else 22.0)])
	var _t511 = J.seq(J.gp(_s329["__p"]["S"], "st"), "stuck")
	var _t512 = (_t511 if _t511 else J.seq(J.gp(_s329["__p"]["S"], "st"), "stuckMove"))
	v_stuck_846 = (_t512 if _t512 else J.seq(J.gp(_s329["__p"]["S"], "st"), "unstick"))
	v_ovr_847 = J.cmp(J.gp(J.gp(_s329["__p"]["S"], "fx"), "over"), 0.0, ">")
	var _t513 = _s329["c"]
	var _t514 = "bold 20px \"Courier New\",monospace"
	J.sp(_t513, "font", _t514)
	var _t515 = _s329["c"]
	J.sp(_t515, "textAlign", "center")
	var _t516 = _s329["c"]
	var _t517 = (("#ff3b2f" if J.t(J.mod(floor(J.num(J.mul(_s329["t"], 6.0))), 2.0)) else "#5a1410") if J.t(v_ovr_847) else "#ffa030")
	J.sp(_t516, "fillStyle", _t517)
	var _t518 = _s329["c"]
	var _t519 = J.gp(_s329["c"], "fillStyle")
	J.sp(_t518, "shadowColor", _t519)
	var _t520 = _s329["c"]
	J.sp(_t520, "shadowBlur", 8.0)
	var _t526 = null
	if J.t(v_ovr_847):
		_t526 = "OVER"
	else:
		var _t525 = null
		if J.t(v_stuck_846):
			_t525 = "- -"
		else:
			var _t521 = J.cmp(J.gp(_s329["__p"]["S"], "dir"), 0.0, ">")
			var _t523 = null
			if J.t((v_mv_807 if _t521 else _t521)):
				_t523 = "▲"
			else:
				var _t522 = J.cmp(J.gp(_s329["__p"]["S"], "dir"), 0.0, "<")
				_t523 = ("▼" if J.t((v_mv_807 if _t522 else _t522)) else " ")
			var _t524 = _s329["__p"]["lab"]
			_t525 = J.add(_t523, J.cl(_t524, null, [J.cl(_s329["__p"]["cabF"], null, [])]))
		_t526 = _t525
	J.mc(_s329["c"], "fillText", [_t526, J.div(_s329["W"], 2.0), J.add(v_iy_845, 19.0)])
	var _t527 = _s329["c"]
	J.sp(_t527, "shadowBlur", 0.0)
	v_g_848 = J.cl(_s329["__p"]["ghost"], null, [])
	_s329["slots"] = [J.mul(_s329["W"], 0.13), J.mul(_s329["W"], 0.87), J.mul(_s329["W"], 0.3), J.mul(_s329["W"], 0.7)]
	J.mc(v_inn_827, "forEach", [Callable(self, "_f150").bind(_s329)])
	if J.t(v_g_848):
		var _t544 = _s329["__p"]["sprAt"]
		J.cl(_t544, null, [_s329["c"], J.gp(J.gp(v_g_848, "d"), "sprite"), J.mul(_s329["W"], 0.5), (J.mul(_s329["H"], 1.04) + (sin(J.num(J.mul(_s329["t"], 2.6))) * 3.0)), J.mul(_s329["H"], 0.5), 0.5, false])
	v_dk_850 = J.sub(1.0, v_lit_814)
	if J.cmp(v_dk_850, 0.0, ">"):
		var _t545 = _s329["c"]
		var _t546 = (J.add("rgba(0,0,0,", J.mul(0.92, v_dk_850)) + ")")
		J.sp(_t545, "fillStyle", _t546)
		J.mc(_s329["c"], "fillRect", [(-20.0), (-20.0), J.add(_s329["W"], 40.0), J.add(_s329["H"], 40.0)])
		var _t547 = J.cmp(J.gp(J.gp(_s329["__p"]["S"], "fx"), "dark"), 0.0, ">")
		if (J.cmp(v_lit_814, 0.1, "<") if _t547 else _t547):
			var _t548 = _s329["c"]
			J.sp(_t548, "fillStyle", "rgba(220,235,255,0.5)")
			v_ey_851 = (J.mul(_s329["H"], 0.45) + (sin(J.num(J.mul(_s329["t"], 1.3))) * 4.0))
			J.mc(_s329["c"], "fillRect", [J.mul(_s329["W"], 0.62), v_ey_851, 4.0, 2.0])
			J.mc(_s329["c"], "fillRect", [(J.mul(_s329["W"], 0.62) + 12.0), v_ey_851, 4.0, 2.0])
			var _t549 = _s329["c"]
			var _t550 = J.add("14px ", J.gp(_s329["__p"]["A"], "FONT"))
			J.sp(_t549, "font", _t550)
			var _t551 = _s329["c"]
			J.sp(_t551, "fillStyle", "rgba(200,210,220,0.55)")
			var _t552 = _s329["c"]
			J.sp(_t552, "textAlign", "center")
			J.mc(_s329["c"], "fillText", ["……呼……呼……", J.div(_s329["W"], 2.0), J.mul(_s329["H"], 0.35)])
	if J.t(v_ovr_847):
		var _t553 = _s329["c"]
		var _t554 = (J.add("rgba(255,30,20,", (0.18 if J.t(J.mod(floor(J.num(J.mul(_s329["t"], 6.0))), 2.0)) else 0.05)) + ")")
		J.sp(_t553, "fillStyle", _t554)
		J.mc(_s329["c"], "fillRect", [(-20.0), (-20.0), J.add(_s329["W"], 40.0), J.add(_s329["H"], 40.0)])
	v_vg_852 = J.mc(_s329["c"], "createRadialGradient", [J.div(_s329["W"], 2.0), J.div(_s329["H"], 2.0), J.mul(_s329["H"], 0.3), J.div(_s329["W"], 2.0), J.div(_s329["H"], 2.0), J.mul(_s329["W"], 0.75)])
	J.mc(v_vg_852, "addColorStop", [0.0, "rgba(0,0,0,0)"])
	J.mc(v_vg_852, "addColorStop", [1.0, "rgba(20,14,0,0.55)"])
	var _t555 = _s329["c"]
	J.sp(_t555, "fillStyle", v_vg_852)
	J.mc(_s329["c"], "fillRect", [(-20.0), (-20.0), J.add(_s329["W"], 40.0), J.add(_s329["H"], 40.0)])
	J.mc(_s329["c"], "restore", [])

func _f151(this_, a: Array, env):
	var v_g0_883 = null
	v_g0_883 = J.cl(env["G"], null, [])
	var _t556 = J.seq(J.gp(env["A"], "scene"), "play")
	var _t557 = (v_g0_883 if _t556 else _t556)
	var _t558 = ((not J.t(J.gp(v_g0_883, "over"))) if J.t(_t557) else _t557)
	var _t559 = ((not J.t(J.gp(v_g0_883, "choice"))) if J.t(_t558) else _t558)
	var _t560 = ((not J.t(J.gp(v_g0_883, "showStory"))) if J.t(_t559) else _t559)
	var _t561 = ((not J.t(J.gp(v_g0_883, "ult"))) if J.t(_t560) else _t560)
	return ((not J.t(J.gp(env["A"], "paused"))) if J.t(_t561) else _t561)

func _f152(this_, a: Array, env):
	var v_ts_886 = null; var v_dt_887 = null; var v_vis_888 = null; var v_e_889 = null
	v_ts_886 = J.arg(a, 0)
	J.F_requestAnimationFrame([env["loop"]])
	v_dt_887 = (J.min_([0.1, J.div(J.sub(v_ts_886, env["last"]), 1000.0)]) if J.t(env["last"]) else 0.0)
	env["last"] = v_ts_886
	if (not J.seq(J.cl(env["G"], null, []), env["lastG"])):
		J.cl(env["reset"], null, [])
	var _t562 = (J.cl(env["running"], null, []) if J.t(env["S"]) else env["S"])
	if J.t(((not J.t(J.gp(env["L"], "manual"))) if J.t(_t562) else _t562)):
		J.mc(env["L"], "step", [v_dt_887])
	var _t563 = ((not J.leq(J.gp(env["S"], "gi"), null)) if J.t(env["S"]) else env["S"])
	var _t564 = (J.seq(J.gp(env["A"], "scene"), "play") if J.t(_t563) else _t563)
	var _t565 = (J.cl(env["G"], null, []) if J.t(_t564) else _t564)
	var _t566 = ((not J.t(J.gp(J.cl(env["G"], null, []), "over"))) if J.t(_t565) else _t565)
	var _t567 = ((not J.t(J.gp(J.cl(env["G"], null, []), "choice"))) if J.t(_t566) else _t566)
	v_vis_888 = ((not J.t(J.gp(J.cl(env["G"], null, []), "showStory"))) if J.t(_t567) else _t567)
	if J.t(v_vis_888):
		var _t568 = J.gp(env["ui"], "classList")
		if (not J.t(J.mc(_t568, "contains", ["on"]))):
			J.cl(env["showUI"], null, [])
		if (not J.t(J.gp(J.G.get("window"), "__twNat"))):
			J.cl(env["refresh"], null, [])
			J.cl(env["drawCab"], null, [])
	else:
		var _t569 = J.gp(env["ui"], "classList")
		if J.t(J.mc(_t569, "contains", ["on"])):
			var _t570 = J.gp(env["ui"], "classList")
			J.mc(_t570, "remove", ["on"])
	if (not J.t(J.gp(J.G.get("window"), "__twNat"))):
		J.cl(env["drawWorld"], null, [])

func _f9(this_, a: Array, env):
	var _t571 = env["tone"]
	J.cl(_t571, null, [1318.0, 0.0, 1.1, 0.18])
	var _t572 = env["tone"]
	J.cl(_t572, null, [2636.0, 0.0, 0.5, 0.04])
	var _t573 = env["tone"]
	J.cl(_t573, null, [1046.0, 0.28, 1.3, 0.15])

func _f10(this_, a: Array, env):
	var _t574 = env["noiseBurst"]
	J.cl(_t574, null, [0.0, 0.6, 0.06, 700.0, 0.7])
	var _t575 = env["tone"]
	J.cl(_t575, null, [140.0, 0.0, 0.5, 0.03, "triangle"])

func _f11(this_, a: Array, env):
	var v_i_160 = null
	v_i_160 = 0.0
	while true:
		if not J.cmp(v_i_160, 7.0, "<"): break
		var _t576 = env["tone"]
		J.cl(_t576, null, [520.0, J.mul(v_i_160, 0.32), 0.2, 0.07, "square"])
		v_i_160 = J.num(v_i_160) + 1.0

func _f12(this_, a: Array, env):
	var _t577 = env["noiseBurst"]
	J.cl(_t577, null, [0.2, 1.3, 0.07, 420.0, 0.6])
	var _t578 = env["noiseBurst"]
	J.cl(_t578, null, [1.8, 1.6, 0.06, 360.0, 0.6])

func _f13(this_, a: Array, env):
	var _t579 = env["tone"]
	J.cl(_t579, null, [58.0, 0.0, 0.6, 0.25, "sine"])
	var _t580 = env["noiseBurst"]
	J.cl(_t580, null, [0.0, 0.25, 0.12, 220.0, 0.5])

func _f14(this_, a: Array, env):
	var _t581 = env["tone"]
	J.cl(_t581, null, [1900.0, 0.0, 0.05, 0.05, "square"])

func _f15(this_, a: Array, env):
	var v_on_169 = null; var v_c_170 = null; var v_o_171 = null; var v_o2_172 = null; var v_lp_173 = null; var v_g_174 = null; var v_h_175 = null; var v_e_176 = null
	v_on_169 = J.arg(a, 0)
	v_c_170 = J.cl(env["ac"], null, [])
	if (not J.t(v_c_170)):
		return null
	if J.t(((not J.t(env["hum"])) if J.t(v_on_169) else v_on_169)):
		v_o_171 = J.mc(v_c_170, "createOscillator", [])
		v_o2_172 = J.mc(v_c_170, "createOscillator", [])
		v_lp_173 = J.mc(v_c_170, "createBiquadFilter", [])
		v_g_174 = J.mc(v_c_170, "createGain", [])
		J.sp(v_o_171, "type", "sawtooth")
		var _t582 = J.gp(v_o_171, "frequency")
		J.sp(_t582, "value", 55.0)
		J.sp(v_o2_172, "type", "sine")
		var _t583 = J.gp(v_o2_172, "frequency")
		J.sp(_t583, "value", 110.5)
		J.sp(v_lp_173, "type", "lowpass")
		var _t584 = J.gp(v_lp_173, "frequency")
		J.sp(_t584, "value", 220.0)
		var _t585 = J.gp(v_g_174, "gain")
		J.sp(_t585, "value", 0.0001)
		J.mc(v_o_171, "connect", [v_lp_173])
		J.mc(v_o2_172, "connect", [v_lp_173])
		J.mc(v_lp_173, "connect", [v_g_174])
		J.mc(v_g_174, "connect", [J.gp(v_c_170, "destination")])
		J.mc(v_o_171, "start", [])
		J.mc(v_o2_172, "start", [])
		var _t586 = J.gp(v_g_174, "gain")
		J.mc(_t586, "exponentialRampToValueAtTime", [0.05, J.add(J.gp(v_c_170, "currentTime"), 0.4)])
		var _t587 = {"o": v_o_171, "o2": v_o2_172, "g": v_g_174}
		env["hum"] = _t587
	var _t588 = (not J.t(v_on_169))
	if J.t((env["hum"] if _t588 else _t588)):
		v_h_175 = env["hum"]
		env["hum"] = null
		var _t589 = J.gp(J.gp(v_h_175, "g"), "gain")
		J.mc(_t589, "exponentialRampToValueAtTime", [0.0001, J.add(J.gp(v_c_170, "currentTime"), 0.4)])
		var _t590 = J.gp(v_h_175, "o")
		J.mc(_t590, "stop", [J.add(J.gp(v_c_170, "currentTime"), 0.5)])
		var _t591 = J.gp(v_h_175, "o2")
		J.mc(_t591, "stop", [J.add(J.gp(v_c_170, "currentTime"), 0.5)])

func _f16(this_, a: Array, env):
	J.cl(env["ac"], null, [])

func _f65(this_, a: Array, env):
	var v_g_370 = null; var v_n_371 = null
	v_g_370 = J.arg(a, 0)
	v_n_371 = J.arg(a, 1)
	var _t593 = (not J.t(env["S"]))
	var _t594 = (_t593 if _t593 else (not J.t(J.gp(env["S"], "on"))))
	var _t595 = (_t594 if _t594 else (not J.t(v_g_370)))
	var _t596 = (_t595 if _t595 else J.gp(v_g_370, "home"))
	if J.t((_t596 if J.t(_t596) else J.gp(v_g_370, "out"))):
		return null
	var _t597 = (v_n_371 if J.t(v_n_371) else J.gp(J.gp(J.cl(env["G"], null, []), "nodes"), J.gp(v_g_370, "node")))
	v_n_371 = _t597
	var _t598 = (not J.t(v_n_371))
	var _t599 = (_t598 if _t598 else (not J.seq(J.gp(v_n_371, "kind"), "lift")))
	if (_t599 if _t599 else J.cmp(J.gp(v_n_371, "f"), J.cl(env["top"], null, []), ">")):
		return null
	if (not J.leq(J.gp(env["S"], "gi"), null)):
		return null
	return {"k": "liftIn", "t": ("等緊𨋢……（再撳取消）" if J.seq(J.gp(env["S"], "gCall"), J.gp(v_n_371, "f")) else "入𨋢（撳掣叫𨋢）")}

func _f66(this_, a: Array, env):
	var v_g_374 = null; var v_n_375 = null; var v_f_376 = null
	v_g_374 = J.arg(a, 0)
	var _t602 = (not J.t(env["S"]))
	if (_t602 if _t602 else (not J.t(J.gp(env["S"], "on")))):
		return false
	v_n_375 = J.gp(J.gp(J.cl(env["G"], null, []), "nodes"), J.gp(v_g_374, "node"))
	var _t603 = (not J.t(v_n_375))
	if (_t603 if _t603 else (not J.seq(J.gp(v_n_375, "kind"), "lift"))):
		return false
	v_f_376 = J.gp(v_n_375, "f")
	if J.seq(J.gp(env["S"], "gCall"), v_f_376):
		var _t604 = env["S"]
		J.sp(_t604, "gCall", null)
		var _t605 = env["S"]
		J.sp(_t605, "gWait", null)
		var _t606 = env["fl"]
		J.cl(_t606, null, [J.gp(v_g_374, "x"), J.sub(J.gp(v_g_374, "y"), 80.0), "唔等喇", "#ffd54a"])
		return false
	var _t607 = J.cl(env["atFloor"], null, [])
	var _t610 = (J.seq(J.cl(env["cabF"], null, []), v_f_376) if J.t(_t607) else _t607)
	if J.t(_t610):
		var _t608 = J.seq(J.gp(env["S"], "st"), "open")
		var _t609 = (_t608 if _t608 else J.seq(J.gp(env["S"], "st"), "opening"))
		_t610 = (_t609 if _t609 else J.seq(J.gp(env["S"], "st"), "idle"))
	if J.t(_t610):
		var _t611 = env["doEnter"]
		J.cl(_t611, null, [v_g_374, v_f_376])
		return true
	var _t612 = env["S"]
	J.sp(_t612, "gCall", v_f_376)
	var _t613 = env["S"]
	var _t614 = J.gp(v_g_374, "i")
	J.sp(_t613, "gWait", _t614)
	J.mc(env["SND"], "click", [])
	var _t615 = env["fl"]
	J.cl(_t615, null, [J.gp(v_g_374, "x"), J.sub(J.gp(v_g_374, "y"), 80.0), "撳咗𨋢掣，等緊𨋢……", "#ffd54a"])
	return "called"

func _f68(this_, a: Array, env):
	var v_g_383 = null; var v_f_384 = null; var v_c_385 = null
	v_g_383 = J.cl(env["ghost"], null, [])
	if (not J.t(v_g_383)):
		return false
	var _t618 = J.seq(J.gp(env["S"], "st"), "open")
	var _t619 = (J.cmp(J.gp(env["S"], "door"), 0.8, ">") if _t618 else _t618)
	if (not J.t((J.cl(env["atFloor"], null, []) if _t619 else _t619))):
		var _t620 = env["flash"]
		J.cl(_t620, null, ["門未開，出唔到"])
		return false
	v_f_384 = J.cl(env["cabF"], null, [])
	v_c_385 = J.cl(env["col"], null, [])
	var _t621 = env["S"]
	J.sp(_t621, "gi", null)
	var _t622 = (J.add("f", v_f_384) + "_l")
	J.sp(v_g_383, "node", _t622)
	J.sp(v_g_383, "to", null)
	var _t623 = J.gp(v_c_385, "cx")
	J.sp(v_g_383, "x", _t623)
	var _t624 = J.mc(env["A"], "fy", [v_f_384])
	J.sp(v_g_383, "y", _t624)
	J.sp(v_g_383, "inv", 0.0)
	J.sp(v_g_383, "still", 1.0)
	var _t625 = env["dingFx"]
	J.cl(_t625, null, [v_f_384])
	if J.seq(J.gp(env["S"], "st"), "open"):
		var _t626 = env["S"]
		var _t627 = J.max_([J.gp(env["S"], "hold"), 0.8])
		J.sp(_t626, "hold", _t627)
	J.cl(env["hideUI"], null, [])
	var _t628 = env["log"]
	J.cl(_t628, null, ["exit"])
	return true

func _f69(this_, a: Array, env):
	var v_f_388 = null
	v_f_388 = J.arg(a, 0)
	var _t631 = (not J.t(env["S"]))
	if (_t631 if _t631 else J.leq(J.gp(env["S"], "gi"), null)):
		return null
	J.mc(env["SND"], "click", [])
	v_f_388 = J.num(v_f_388)
	var _t632 = J.cl(env["atFloor"], null, [])
	var _t633 = (J.seq(J.cl(env["cabF"], null, []), v_f_388) if J.t(_t632) else _t632)
	if J.t(((not J.seq(J.gp(env["S"], "st"), "move")) if J.t(_t633) else _t633)):
		J.mc(env["L"], "open", [])
		return null
	var _t634 = J.seq(J.gp(env["S"], "st"), "stuck")
	if (_t634 if _t634 else J.seq(J.gp(env["S"], "st"), "stuckMove")):
		var _t635 = env["flash"]
		J.cl(_t635, null, ["卡住咗，掣冇反應"])
		return null
	var _t636 = J.gp(env["S"], "stops")
	J.sp(_t636, v_f_388, 1.0)
	var _t637 = J.gp(env["S"], "lit")
	J.sp(_t637, v_f_388, 1.0)
	if J.seq(J.gp(env["S"], "st"), "open"):
		var _t638 = env["S"]
		var _t639 = J.min_([J.gp(env["S"], "hold"), 0.9])
		J.sp(_t638, "hold", _t639)
	var _t640 = env["log"]
	J.cl(_t640, null, [J.add("press", v_f_388)])

func _f70(this_, a: Array, env):
	var _t643 = (not J.t(env["S"]))
	if (_t643 if _t643 else J.leq(J.gp(env["S"], "gi"), null)):
		return null
	J.mc(env["SND"], "click", [])
	var _t644 = J.seq(J.gp(env["S"], "st"), "move")
	var _t645 = (_t644 if _t644 else J.seq(J.gp(env["S"], "st"), "stuckMove"))
	if (_t645 if _t645 else J.seq(J.gp(env["S"], "st"), "stuck")):
		var _t646 = env["flash"]
		J.cl(_t646, null, [("行緊，開唔到門" if J.seq(J.gp(env["S"], "st"), "move") else "卡住咗，門開唔到")])
		return null
	var _t647 = J.seq(J.gp(env["S"], "st"), "closing")
	if (_t647 if _t647 else J.seq(J.gp(env["S"], "st"), "idle")):
		var _t648 = env["S"]
		J.sp(_t648, "st", "opening")
		J.mc(env["SND"], "door", [])
	var _t649 = env["S"]
	var _t650 = J.max_([J.gp(env["S"], "hold"), 3.0])
	J.sp(_t649, "hold", _t650)

func _f71(this_, a: Array, env):
	var _t653 = (not J.t(env["S"]))
	if (_t653 if _t653 else J.leq(J.gp(env["S"], "gi"), null)):
		return null
	J.mc(env["SND"], "click", [])
	if J.cmp(J.gp(J.gp(env["S"], "fx"), "over"), 0.0, ">"):
		var _t654 = env["flash"]
		J.cl(_t654, null, ["超重！門閂唔到"])
		return null
	var _t655 = J.seq(J.gp(env["S"], "st"), "open")
	if (_t655 if _t655 else J.seq(J.gp(env["S"], "st"), "opening")):
		var _t656 = env["S"]
		J.sp(_t656, "st", "closing")
		var _t657 = env["S"]
		J.sp(_t657, "hold", 0.0)
		J.mc(env["SND"], "door", [])

func _f73(this_, a: Array, env):
	var v_o_399 = null
	v_o_399 = J.arg(a, 0)
	var _t665 = J.seq(J.gp(v_o_399, "ph"), "wait")
	return (J.seq(J.gp(v_o_399, "f"), env["f"]) if _t665 else _t665)

func _f72(this_, a: Array, env):
	var v_k_395 = null
	var _s129 = {"__p": env, "f": null}
	v_k_395 = J.arg(a, 0)
	var _t660 = (not J.t(_s129["__p"]["S"]))
	if (_t660 if _t660 else J.leq(J.gp(_s129["__p"]["S"], "gi"), null)):
		return "out"
	if J.cmp(J.gp(J.gp(_s129["__p"]["S"], "cd"), v_k_395), 0.0, ">"):
		return "cd"
	if J.seq(v_k_395, "door"):
		_s129["f"] = J.cl(_s129["__p"]["cabF"], null, [])
		var _t661 = (not J.t(J.cl(_s129["__p"]["atFloor"], null, [])))
		var _t663 = (_t661 if _t661 else J.seq(J.gp(_s129["__p"]["S"], "st"), "move"))
		if not J.t(_t663):
			var _t662 = J.F_String([J.gp(_s129["__p"]["S"], "st")])
			_t663 = J.seq(J.mc(_t662, "indexOf", ["stuck"]), 0.0)
		if _t663:
			return "nolanding"
		var _t664 = J.gp(_s129["__p"]["S"], "riders")
		return (true if J.t(J.mc(_t664, "some", [Callable(self, "_f73").bind(_s129)])) else "nolanding")
	if (not J.t(J.len(J.cl(_s129["__p"]["inCab"], null, [])))):
		return "empty"
	var _t667 = J.seq(v_k_395, "stuck")
	if J.t(_t667):
		var _t666 = J.seq(J.gp(_s129["__p"]["S"], "st"), "stuck")
		_t667 = (_t666 if _t666 else J.seq(J.gp(_s129["__p"]["S"], "st"), "stuckMove"))
	if _t667:
		return "busy"
	return true

func _f75(this_, a: Array, env):
	var v_o_413 = null; var v_r_414 = null; var v_amt_415 = null
	v_o_413 = J.arg(a, 0)
	if J.seq(J.gp(v_o_413, "kind"), "guard"):
		var _t705 = env["__p"]["sayR"]
		var _t706 = env["__p"]["line"]
		J.cl(_t705, null, [v_o_413, J.cl(_t706, null, ["gReport"])])
		J.sp(v_o_413, "mood", "mroom")
		var _t707 = J.add(env["tot"], 8.0)
		env["tot"] = _t707
		var _t708 = env["__p"]["fl"]
		var _t710 = J.gp(env["c"], "cx")
		var _t709 = env["__p"]["fyf"]
		J.cl(_t708, null, [_t710, J.sub(J.cl(_t709, null, [J.gp(env["__p"]["S"], "pos")]), 130.0), "保安用對講機報𨋢故障", "#ffb0b0"])
		return null
	v_r_414 = J.gp(v_o_413, "ref")
	var _t712 = J.gp(env["T"], "f")
	var _t711 = J.gp(v_r_414, "brave")
	v_amt_415 = J.mul(J.mul(_t712, J.sub(1.0, (_t711 if J.t(_t711) else 0.0))), J.cl(env["__p"]["gpm"], null, []))
	var _t713 = J.add(J.gp(v_o_413, "fear"), v_amt_415)
	J.sp(v_o_413, "fear", _t713)
	var _t714 = J.gp(v_r_414, "fear")
	var _t715 = J.add((_t714 if J.t(_t714) else 0.0), J.mul(v_amt_415, 0.3))
	J.sp(v_r_414, "fear", _t715)
	var _t716 = J.add(env["tot"], v_amt_415)
	env["tot"] = _t716
	var _t718 = J.cmp(J.gp(v_o_413, "fear"), 60.0, ">=")
	if not J.t(_t718):
		var _t717 = J.seq(env["k"], "stuck")
		_t718 = (J.cmp(J.gp(v_o_413, "fear"), 45.0, ">=") if _t717 else _t717)
	if _t718:
		J.sp(v_o_413, "mood", "bolt")
		var _t719 = env["__p"]["sayR"]
		var _t720 = env["__p"]["line"]
		J.cl(_t719, null, [v_o_413, J.cl(_t720, null, [env["k"]])])
	else:
		J.sp(v_o_413, "mood", "cower")
		var _t721 = env["__p"]["sayR"]
		var _t722 = env["__p"]["line"]
		J.cl(_t721, null, [v_o_413, J.cl(_t722, null, [env["k"]])])

func _f74(this_, a: Array, env):
	var v_ok_403 = null; var v_g_405 = null; var v_f_407 = null; var v_mid_408 = null; var v_add_410 = null
	var _s132 = {"__p": env, "k": null, "T": null, "c": null, "tot": null}
	_s132["k"] = J.arg(a, 0)
	v_ok_403 = J.mc(_s132["__p"]["L"], "canTrick", [_s132["k"]])
	if (not J.seq(v_ok_403, true)):
		if J.seq(v_ok_403, "cd"):
			var _t670 = _s132["__p"]["flash"]
			J.cl(_t670, null, [J.add(J.gp(J.gp(_s132["__p"]["TR"], _s132["k"]), "n"), "冷卻中")])
		else:
			if J.seq(v_ok_403, "empty"):
				var _t671 = _s132["__p"]["flash"]
				J.cl(_t671, null, ["𨋢入面冇人"])
			else:
				if J.seq(v_ok_403, "nolanding"):
					var _t672 = _s132["__p"]["flash"]
					J.cl(_t672, null, ["門口冇人等𨋢"])
		return false
	_s132["T"] = J.gp(_s132["__p"]["TR"], _s132["k"])
	v_g_405 = J.cl(_s132["__p"]["ghost"], null, [])
	_s132["c"] = J.cl(_s132["__p"]["col"], null, [])
	var _t673 = J.gp(_s132["__p"]["S"], "cd")
	var _t674 = _s132["k"]
	var _t675 = J.gp(_s132["T"], "cd")
	J.sp(_t673, _t674, _t675)
	var _t676 = _s132["__p"]["log"]
	J.cl(_t676, null, [J.add("trick:", _s132["k"])])
	if J.seq(_s132["k"], "dark"):
		var _t677 = J.gp(_s132["__p"]["S"], "fx")
		J.sp(_t677, "dark", 4.2)
		J.mc(_s132["__p"]["SND"], "breath", [])
	if J.seq(_s132["k"], "btns"):
		var _t678 = _s132["__p"]["S"]
		var _t679 = J.gp(_s132["__p"]["S"], "btnsSet")
		var _t680 = (_t679 if J.t(_t679) else {})
		J.sp(_t678, "btnsSet", _t680)
		v_f_407 = 0.0
		while true:
			if not J.cmp(v_f_407, J.cl(_s132["__p"]["top"], null, []), "<="): break
			var _t681 = (not J.seq(v_f_407, J.cl(_s132["__p"]["cabF"], null, [])))
			var _t682 = (_t681 if _t681 else (not J.t(J.cl(_s132["__p"]["atFloor"], null, []))))
			if ((not J.t(J.gp(J.gp(_s132["__p"]["S"], "stops"), v_f_407))) if _t682 else _t682):
				var _t683 = J.gp(_s132["__p"]["S"], "stops")
				J.sp(_t683, v_f_407, 1.0)
				var _t684 = J.gp(_s132["__p"]["S"], "lit")
				J.sp(_t684, v_f_407, 1.0)
				var _t685 = J.gp(_s132["__p"]["S"], "btnsSet")
				J.sp(_t685, v_f_407, 1.0)
			v_f_407 = J.num(v_f_407) + 1.0
		var _t686 = _s132["__p"]["S"]
		var _t687 = J.add(J.gp(_s132["__p"]["S"], "t"), 30.0)
		J.sp(_t686, "btnsUntil", _t687)
		var _t688 = J.gp(_s132["__p"]["S"], "fx")
		J.sp(_t688, "btnAll", 3.0)
		J.mc(_s132["__p"]["SND"], "click", [])
	if J.seq(_s132["k"], "mirror"):
		var _t689 = J.gp(_s132["__p"]["S"], "fx")
		J.sp(_t689, "mirror", 3.6)
		var _t690 = _s132["__p"]["tone"]
		J.cl(_t690, null, [196.0, 0.0, 1.6, 0.05, "triangle"])
	if J.seq(_s132["k"], "over"):
		var _t691 = J.gp(_s132["__p"]["S"], "fx")
		J.sp(_t691, "over", 3.6)
		J.mc(_s132["__p"]["SND"], "buzz", [])
		if J.seq(J.gp(_s132["__p"]["S"], "st"), "closing"):
			var _t692 = _s132["__p"]["S"]
			J.sp(_t692, "st", "opening")
	if J.seq(_s132["k"], "stuck"):
		v_mid_408 = J.min_([J.sub(J.cl(_s132["__p"]["top"], null, []), 0.5), J.max_([0.5, (floor(J.num(J.gp(_s132["__p"]["S"], "pos"))) + 0.5)])])
		var _t693 = J.cmp(J.gp(_s132["__p"]["S"], "dir"), 0.0, "<")
		if ((not J.t(J.cl(_s132["__p"]["atFloor"], null, []))) if _t693 else _t693):
			var _t694 = J.max_([0.5, (ceil(J.num(J.gp(_s132["__p"]["S"], "pos"))) - 0.5)])
			v_mid_408 = _t694
		var _t695 = _s132["__p"]["S"]
		J.sp(_t695, "stuckTo", v_mid_408)
		var _t696 = _s132["__p"]["S"]
		J.sp(_t696, "st", "stuckMove")
		var _t697 = _s132["__p"]["S"]
		J.sp(_t697, "stuckT", 5.5)
		J.mc(_s132["__p"]["SND"], "hum", [true])
		if J.cmp(J.gp(_s132["__p"]["S"], "door"), 0.0, ">"):
			var _t698 = _s132["__p"]["S"]
			J.sp(_t698, "door", 0.0)
			J.mc(_s132["__p"]["SND"], "door", [])
	if J.seq(_s132["k"], "door"):
		var _t699 = J.gp(_s132["__p"]["S"], "fx")
		var _t700 = J.max_([J.gp(J.gp(_s132["__p"]["S"], "fx"), "dark"), 2.2])
		J.sp(_t699, "dark", _t700)
		J.cl(_s132["__p"]["scareLanding"], null, [])
		if J.t(J.gp(_s132["__p"]["A"], "addFear")):
			var _t702 = J.round(J.num(J.mul(J.mul(J.gp(_s132["T"], "f"), 0.4), J.cl(_s132["__p"]["gpm"], null, []))))
			var _t703 = J.gp(_s132["c"], "cx")
			var _t701 = _s132["__p"]["fyf"]
			J.mc(_s132["__p"]["A"], "addFear", [_t702, _t703, J.sub(J.cl(_t701, null, [J.gp(_s132["__p"]["S"], "pos")]), 120.0)])
		return true
	_s132["tot"] = 0.0
	var _t704 = J.cl(_s132["__p"]["inCab"], null, [])
	J.mc(_t704, "forEach", [Callable(self, "_f75").bind(_s132)])
	v_add_410 = J.max_([4.0, J.round(J.num(J.mul(_s132["tot"], 0.35)))])
	if J.t(J.gp(_s132["__p"]["A"], "addFear")):
		var _t724 = J.gp(_s132["c"], "cx")
		var _t723 = _s132["__p"]["fyf"]
		J.mc(_s132["__p"]["A"], "addFear", [v_add_410, _t724, J.sub(J.cl(_t723, null, [J.gp(_s132["__p"]["S"], "pos")]), 110.0)])
	if J.t(v_g_405):
		var _t725 = J.gp(v_g_405, "energy")
		var _t726 = J.gp(v_g_405, "energy")
		var _t727 = J.min_([100.0, J.add((_t726 if J.t(_t726) else 0.0), 6.0)])
		J.sp(v_g_405, "energy", _t727)
	var _t728 = _s132["__p"]["S"]
	J.sp(_t728, "shake", 0.35)
	return true

func _f81(this_, a: Array, env):
	var v_o_448 = null
	v_o_448 = J.arg(a, 0)
	var _t734 = J.seq(J.gp(v_o_448, "ph"), "wait")
	var _t735 = (_t734 if _t734 else J.seq(J.gp(v_o_448, "ph"), "walk"))
	var _t736 = (_t735 if _t735 else J.seq(J.gp(v_o_448, "ph"), "walkHome"))
	var _t737 = (J.seq(J.gp(v_o_448, "f"), env["f"]) if _t736 else _t736)
	return ((absf(J.num(J.sub(J.gp(v_o_448, "x"), J.gp(env["g"], "x")))) < 150.0) if _t737 else _t737)

func _f82(this_, a: Array, env):
	var v_o_451 = null; var v_h_452 = null; var v_r_453 = null; var v_e_454 = null
	v_o_451 = J.arg(a, 0)
	var _t739 = J.gp(env["__p"]["S"], "riders")
	var _t740 = J.gp(env["__p"]["S"], "riders")
	J.mc(_t739, "splice", [J.mc(_t740, "indexOf", [v_o_451]), 1.0])
	env["got"] = J.num(env["got"]) + 1.0
	if J.seq(J.gp(v_o_451, "kind"), "guard"):
		v_h_452 = J.gp(v_o_451, "ref")
		var _t741 = (J.add("f", env["f"]) + "_l")
		J.sp(v_h_452, "node", _t741)
		J.sp(v_h_452, "to", null)
		J.sp(v_h_452, "p", 0.0)
		var _t742 = J.gp(v_o_451, "x")
		J.sp(v_h_452, "x", _t742)
		var _t743 = env["y"]
		J.sp(v_h_452, "y", _t743)
		J.sp(v_h_452, "state", "patrol")
		var _t744 = J.gp(env["g0"], "guards")
		J.mc(_t744, "push", [v_h_452])
		var _t745 = env["__p"]["line"]
		J.mc(env["__p"]["A"], "spook", [v_h_452, J.cl(_t745, null, ["gLand"])])
		return null
	v_r_453 = J.gp(v_o_451, "ref")
	J.sp(v_r_453, "state", "flee")
	var _t746 = (((-1.0) if J.cmp(J.gp(v_o_451, "x"), J.gp(env["g"], "x"), "<") else 1.0) * 160.0)
	J.sp(v_r_453, "vx", _t746)
	var _t747 = J.gp(v_o_451, "x")
	J.sp(v_r_453, "x", _t747)
	var _t748 = J.sub(env["y"], 16.0)
	J.sp(v_r_453, "y", _t748)
	var _t749 = J.gp(env["g0"], "res")
	J.mc(_t749, "push", [v_r_453])
	if J.t(J.gp(J.G.get("window"), "PPLFX")):
		J.mc(J.G.get("PPLFX"), "screamOn", [v_r_453])
	else:
		var _t750 = env["__p"]["sayR"]
		var _t751 = env["__p"]["line"]
		J.cl(_t750, null, [v_r_453, J.cl(_t751, null, ["bolt"])])
	J.sp(v_r_453, "sayT", 2.4)

func _f80(this_, a: Array, env):
	var v_n_440 = null; var v_c_444 = null; var v_e_455 = null
	var _s160 = {"__p": env, "g": null, "f": null, "y": null, "g0": null, "got": null}
	_s160["g"] = J.arg(a, 0)
	var _t731 = (not J.t(_s160["__p"]["S"]))
	var _t732 = (_t731 if _t731 else (not J.t(J.gp(_s160["__p"]["S"], "on"))))
	if (_t732 if _t732 else (not J.t(_s160["g"]))):
		return 0.0
	v_n_440 = J.gp(J.gp(J.cl(_s160["__p"]["G"], null, []), "nodes"), J.gp(_s160["g"], "node"))
	if (not J.t(v_n_440)):
		return 0.0
	_s160["f"] = J.gp(v_n_440, "f")
	_s160["y"] = J.mc(_s160["__p"]["A"], "fy", [_s160["f"]])
	_s160["g0"] = J.cl(_s160["__p"]["G"], null, [])
	v_c_444 = J.cl(_s160["__p"]["col"], null, [])
	_s160["got"] = 0.0
	var _t733 = J.gp(_s160["__p"]["S"], "riders")
	var _t738 = J.mc(_t733, "filter", [Callable(self, "_f81").bind(_s160)])
	J.mc(_t738, "forEach", [Callable(self, "_f82").bind(_s160)])
	if J.t(_s160["got"]):
		if J.t(J.gp(_s160["__p"]["A"], "addFear")):
			J.mc(_s160["__p"]["A"], "addFear", [J.mul(10.0, _s160["got"]), J.gp(_s160["g"], "x"), J.sub(_s160["y"], 110.0)])
		var _t752 = _s160["g"]
		J.sp(_t752, "dir", 1.0)
		var _t753 = _s160["__p"]["log"]
		J.cl(_t753, null, ["scareWait"])
	return _s160["got"]

func _f86(this_, a: Array, env):
	var v_o_491 = null
	v_o_491 = J.arg(a, 0)
	return J.seq(J.gp(v_o_491, "kind"), "res")

func _f87(this_, a: Array, env):
	var v_a_494 = null; var v_o_495 = null
	v_a_494 = J.arg(a, 0)
	var _t790 = J.sub(J.gp(v_a_494, "t"), env["dt"])
	J.sp(v_a_494, "t", _t790)
	if J.cmp(J.gp(v_a_494, "t"), 0.0, ">"):
		return true
	v_o_495 = J.gp(v_a_494, "o")
	J.sp(v_o_495, "ph", "wait")
	J.sp(v_o_495, "f", 1.0)
	var _t791 = J.gp(J.gp(J.gp(v_o_495, "ref"), "unit"), "f")
	J.sp(v_o_495, "dest", _t791)
	J.sp(v_o_495, "trip", "back")
	var _t792 = J.sub(J.gp(J.cl(env["__p"]["col"], null, []), "cx"), 46.0)
	J.sp(v_o_495, "x", _t792)
	J.sp(v_o_495, "mood", "ok")
	J.sp(v_o_495, "fear", 0.0)
	var _t793 = env["__p"]["sayR"]
	var _t794 = env["__p"]["line"]
	J.cl(_t793, null, [v_o_495, J.cl(_t794, null, ["back"])])
	var _t795 = J.gp(env["__p"]["S"], "riders")
	J.mc(_t795, "push", [v_o_495])
	return false

func _f88(this_, a: Array, env):
	var v_m_498 = null; var v_h_499 = null; var v_nid_500 = null; var v_n_501 = null
	v_m_498 = J.arg(a, 0)
	var _t799 = J.sub(J.gp(v_m_498, "t"), env["dt"])
	J.sp(v_m_498, "t", _t799)
	if J.cmp(J.gp(v_m_498, "t"), 0.0, ">"):
		return true
	v_h_499 = J.gp(v_m_498, "h")
	v_nid_500 = ("f1_s" if J.t(J.gp(J.gp(env["g0"], "nodes"), "f1_s")) else "f0_s")
	v_n_501 = J.gp(J.gp(env["g0"], "nodes"), v_nid_500)
	J.sp(v_h_499, "node", v_nid_500)
	J.sp(v_h_499, "to", null)
	J.sp(v_h_499, "p", 0.0)
	var _t800 = J.gp(v_n_501, "x")
	J.sp(v_h_499, "x", _t800)
	var _t801 = J.gp(v_n_501, "y")
	J.sp(v_h_499, "y", _t801)
	J.sp(v_h_499, "state", "patrol")
	J.sp(v_h_499, "wait", 1.0)
	var _t802 = env["__p"]["line"]
	var _t803 = J.cl(_t802, null, ["gBack"])
	J.sp(v_h_499, "say", _t803)
	J.sp(v_h_499, "sayT", 2.6)
	J.sp(v_h_499, "liftCd", 1.0)
	var _t804 = J.gp(env["g0"], "guards")
	J.mc(_t804, "push", [v_h_499])
	return false

func _f90(this_, a: Array, env):
	var v_p_511 = null
	v_p_511 = J.arg(a, 0)
	var _t813 = J.seq(J.gp(v_p_511, "ph"), "wait")
	return (J.seq(J.gp(v_p_511, "f"), J.gp(env["o"], "f")) if _t813 else _t813)

func _f89(this_, a: Array, env):
	var v_slot_505 = null; var v_tx_506 = null; var v_r_507 = null; var v_hx_508 = null
	var _s184 = {"__p": env, "o": null}
	_s184["o"] = J.arg(a, 0)
	var _t807 = _s184["o"]
	var _t808 = J.gp(_s184["o"], "sayT")
	var _t809 = J.gp(_s184["o"], "sayT")
	var _t810 = J.max_([0.0, J.sub((_t809 if J.t(_t809) else 0.0), _s184["__p"]["dt"])])
	J.sp(_t807, "sayT", _t810)
	if J.cmp(J.gp(_s184["o"], "sayT"), 0.0, "<="):
		var _t811 = _s184["o"]
		J.sp(_t811, "say", null)
	if J.seq(J.gp(_s184["o"], "ph"), "walk"):
		var _t812 = J.gp(_s184["__p"]["__p"]["S"], "riders")
		v_slot_505 = J.len(J.mc(_t812, "filter", [Callable(self, "_f90").bind(_s184)]))
		v_tx_506 = (J.sub(J.gp(_s184["__p"]["c"], "cx"), 44.0) - J.mul(v_slot_505, 16.0))
		var _t814 = _s184["o"]
		var _t815 = J.add(J.gp(_t814, "x"), (signf(J.num(J.sub(v_tx_506, J.gp(_s184["o"], "x")))) * J.min_([absf(J.num(J.sub(v_tx_506, J.gp(_s184["o"], "x")))), J.mul((36.0 if J.seq(J.gp(_s184["o"], "kind"), "guard") else 62.0), _s184["__p"]["dt"])])))
		J.sp(_t814, "x", _t815)
		if (absf(J.num(J.sub(v_tx_506, J.gp(_s184["o"], "x")))) < 1.0):
			var _t816 = _s184["o"]
			J.sp(_t816, "ph", "wait")
			var _t817 = _s184["o"]
			J.sp(_t817, "waitT", 0.0)
	else:
		if J.seq(J.gp(_s184["o"], "ph"), "wait"):
			var _t818 = _s184["o"]
			var _t819 = J.gp(_s184["o"], "waitT")
			var _t820 = J.add((_t819 if J.t(_t819) else 0.0), _s184["__p"]["dt"])
			J.sp(_t818, "waitT", _t820)
			var _t821 = J.cmp(J.gp(_s184["o"], "waitT"), 7.0, ">")
			if ((not J.t(J.gp(_s184["o"], "said"))) if _t821 else _t821):
				var _t822 = _s184["o"]
				J.sp(_t822, "said", 1.0)
				var _t823 = _s184["__p"]["__p"]["sayR"]
				var _t825 = _s184["o"]
				var _t824 = _s184["__p"]["__p"]["line"]
				J.cl(_t823, null, [_t825, J.cl(_t824, null, ["wait"])])
		else:
			if J.seq(J.gp(_s184["o"], "ph"), "walkHome"):
				v_r_507 = J.gp(_s184["o"], "ref")
				v_hx_508 = J.add(J.gp(J.gp(J.gp(v_r_507, "unit"), "rx"), 0.0), (J.sub(J.gp(J.gp(J.gp(v_r_507, "unit"), "rx"), 1.0), J.gp(J.gp(J.gp(v_r_507, "unit"), "rx"), 0.0)) * 0.42))
				var _t826 = _s184["o"]
				var _t827 = J.add(J.gp(_t826, "x"), (signf(J.num(J.sub(v_hx_508, J.gp(_s184["o"], "x")))) * J.min_([absf(J.num(J.sub(v_hx_508, J.gp(_s184["o"], "x")))), J.mul(62.0, _s184["__p"]["dt"])])))
				J.sp(_t826, "x", _t827)
				if (absf(J.num(J.sub(v_hx_508, J.gp(_s184["o"], "x")))) < 1.0):
					var _t828 = J.gp(_s184["__p"]["__p"]["S"], "riders")
					var _t829 = J.gp(_s184["__p"]["__p"]["S"], "riders")
					J.mc(_t828, "splice", [J.mc(_t829, "indexOf", [_s184["o"]]), 1.0])
					J.sp(v_r_507, "x", v_hx_508)
					var _t830 = J.sub(J.mc(_s184["__p"]["__p"]["A"], "fy", [J.gp(J.gp(v_r_507, "unit"), "f")]), 16.0)
					J.sp(v_r_507, "y", _t830)
					J.sp(v_r_507, "state", "home")
					var _t831 = J.gp(v_r_507, "fear")
					var _t832 = J.gp(v_r_507, "fear")
					var _t833 = J.max_([0.0, (_t832 if J.t(_t832) else 0.0)])
					J.sp(v_r_507, "fear", _t833)
					var _t834 = J.gp(_s184["__p"]["g0"], "res")
					J.mc(_t834, "push", [v_r_507])
					if J.t(J.gp(v_r_507, "unit")):
						var _t835 = J.gp(v_r_507, "unit")
						J.sp(_t835, "doorOpen", 2.0)

func _f91(this_, a: Array, env):
	var v_o_514 = null
	v_o_514 = J.arg(a, 0)
	var _t927 = J.seq(J.gp(v_o_514, "ph"), "ride")
	var _t928 = (J.seq(J.gp(v_o_514, "mood"), "bolt") if _t927 else _t927)
	if ((not J.t(J.gp(v_o_514, "boltSaid"))) if _t928 else _t928):
		J.sp(v_o_514, "boltSaid", 1.0)

func _f85(this_, a: Array, env):
	var v_k_467 = null; var v_bf_468 = null; var v_q_469 = null; var v_g_471 = null; var v_gw_472 = null; var v_nw_473 = null; var v_t_474 = null; var v_w_475 = null; var v_t2_476 = null; var v_d_477 = null; var v_ad_478 = null; var v_vm_479 = null; var v_mv_480 = null; var v_t3_481 = null; var v_dd_482 = null; var v_st_483 = null; var v_nf_484 = null; var v_gw2_485 = null; var v_gw3_486 = null; var v_fN_487 = null; var v_df_488 = null
	var _s173 = {"__p": env, "dt": null, "g0": null, "c": null}
	_s173["dt"] = J.arg(a, 0)
	if (not J.seq(J.cl(_s173["__p"]["G"], null, []), _s173["__p"]["lastG"])):
		J.cl(_s173["__p"]["reset"], null, [])
	var _t756 = (not J.t(_s173["__p"]["S"]))
	var _t757 = (_t756 if _t756 else (not J.t(J.gp(_s173["__p"]["S"], "on"))))
	if (_t757 if _t757 else (not J.t(J.cl(_s173["__p"]["G"], null, [])))):
		return null
	_s173["g0"] = J.cl(_s173["__p"]["G"], null, [])
	var _t758 = _s173["__p"]["S"]
	var _t759 = J.add(J.gp(_t758, "t"), _s173["dt"])
	J.sp(_t758, "t", _t759)
	for _t760 in J.keys(J.gp(_s173["__p"]["S"], "cd")):
		v_k_467 = _t760
		var _t761 = J.gp(_s173["__p"]["S"], "cd")
		var _t762 = J.max_([0.0, J.sub(J.gp(J.gp(_s173["__p"]["S"], "cd"), v_k_467), _s173["dt"])])
		J.sp(_t761, v_k_467, _t762)
	var _t763 = J.gp(_s173["__p"]["S"], "btnsUntil")
	if J.t((J.cmp(J.gp(_s173["__p"]["S"], "t"), J.gp(_s173["__p"]["S"], "btnsUntil"), ">=") if J.t(_t763) else _t763)):
		var _t764 = _s173["__p"]["S"]
		J.sp(_t764, "btnsUntil", 0.0)
		var _t766 = J.gp(_s173["__p"]["S"], "btnsSet")
		for _t765 in J.keys((_t766 if J.t(_t766) else {})):
			v_bf_468 = _t765
			J.del(J.gp(_s173["__p"]["S"], "stops"), v_bf_468)
			J.del(J.gp(_s173["__p"]["S"], "lit"), v_bf_468)
		var _t767 = _s173["__p"]["S"]
		var _t768 = {}
		J.sp(_t767, "btnsSet", _t768)
		var _t769 = _s173["__p"]["log"]
		J.cl(_t769, null, ["btnsReset"])
	for _t770 in J.keys(J.gp(_s173["__p"]["S"], "fx")):
		v_q_469 = _t770
		var _t771 = J.gp(_s173["__p"]["S"], "fx")
		var _t772 = J.max_([0.0, J.sub(J.gp(J.gp(_s173["__p"]["S"], "fx"), v_q_469), _s173["dt"])])
		J.sp(_t771, v_q_469, _t772)
	var _t773 = _s173["__p"]["S"]
	var _t774 = J.max_([0.0, J.sub(J.gp(_s173["__p"]["S"], "shake"), _s173["dt"])])
	J.sp(_t773, "shake", _t774)
	var _t775 = _s173["__p"]["S"]
	var _t776 = J.gp(_s173["__p"]["S"], "msgT")
	var _t777 = J.gp(_s173["__p"]["S"], "msgT")
	var _t778 = J.max_([0.0, J.sub((_t777 if J.t(_t777) else 0.0), _s173["dt"])])
	J.sp(_t775, "msgT", _t778)
	var _t779 = _s173["__p"]["S"]
	var _t780 = J.sub(J.gp(_t779, "spawnT"), _s173["dt"])
	J.sp(_t779, "spawnT", _t780)
	if J.cmp(J.gp(_s173["__p"]["S"], "spawnT"), 0.0, "<="):
		var _t781 = _s173["__p"]["S"]
		var _t782 = (11.0 + J.mul(J.cl(_s173["__p"]["rnd"], null, []), 9.0))
		J.sp(_t781, "spawnT", _t782)
		var _t783 = J.gp(_s173["__p"]["S"], "riders")
		if (J.len(J.mc(_t783, "filter", [Callable(self, "_f86").bind(_s173)])) < 5.0):
			J.cl(_s173["__p"]["spawnResident"], null, [])
	var _t784 = _s173["__p"]["S"]
	var _t785 = J.sub(J.gp(_t784, "gSpawnT"), _s173["dt"])
	J.sp(_t784, "gSpawnT", _t785)
	if J.cmp(J.gp(_s173["__p"]["S"], "gSpawnT"), 0.0, "<="):
		var _t786 = _s173["__p"]["S"]
		var _t787 = (18.0 + J.mul(J.cl(_s173["__p"]["rnd"], null, []), 10.0))
		J.sp(_t786, "gSpawnT", _t787)
		J.cl(_s173["__p"]["spawnGuard"], null, [])
	var _t788 = _s173["__p"]["S"]
	var _t789 = J.gp(_s173["__p"]["S"], "away")
	var _t796 = J.mc(_t789, "filter", [Callable(self, "_f87").bind(_s173)])
	J.sp(_t788, "away", _t796)
	var _t797 = _s173["__p"]["S"]
	var _t798 = J.gp(_s173["__p"]["S"], "mroom")
	var _t805 = J.mc(_t798, "filter", [Callable(self, "_f88").bind(_s173)])
	J.sp(_t797, "mroom", _t805)
	_s173["c"] = J.cl(_s173["__p"]["col"], null, [])
	var _t806 = J.gp(_s173["__p"]["S"], "riders")
	J.mc(_t806, "forEach", [Callable(self, "_f89").bind(_s173)])
	v_g_471 = J.cl(_s173["__p"]["ghost"], null, [])
	var _t837 = v_g_471
	if J.t(_t837):
		var _t836 = J.gp(v_g_471, "out")
		_t837 = (_t836 if J.t(_t836) else J.gp(v_g_471, "home"))
	if J.t(_t837):
		var _t838 = _s173["__p"]["S"]
		J.sp(_t838, "gi", null)
		v_g_471 = null
		J.cl(_s173["__p"]["hideUI"], null, [])
	if (not J.leq(J.gp(_s173["__p"]["S"], "gWait"), null)):
		v_gw_472 = J.gp(J.gp(_s173["g0"], "gh"), J.gp(_s173["__p"]["S"], "gWait"))
		v_nw_473 = (J.gp(J.gp(_s173["g0"], "nodes"), J.gp(v_gw_472, "node")) if J.t(v_gw_472) else v_gw_472)
		var _t839 = (not J.t(v_gw_472))
		var _t840 = (_t839 if _t839 else J.gp(v_gw_472, "to"))
		var _t841 = (_t840 if J.t(_t840) else (not J.t(v_nw_473)))
		var _t842 = (_t841 if J.t(_t841) else (not J.seq(J.gp(v_nw_473, "kind"), "lift")))
		if J.t((_t842 if J.t(_t842) else (not J.seq(J.gp(v_nw_473, "f"), J.gp(_s173["__p"]["S"], "gCall"))))):
			var _t843 = _s173["__p"]["S"]
			J.sp(_t843, "gCall", null)
			var _t844 = _s173["__p"]["S"]
			J.sp(_t844, "gWait", null)
	var _t845 = J.gp(_s173["__p"]["S"], "st")
	var _t846 = -1
	var _t847 = false
	if _t846 == -1 and J.seq(_t845, "idle"): _t846 = 0
	if _t846 == -1 and J.seq(_t845, "move"): _t846 = 1
	if _t846 == -1 and J.seq(_t845, "opening"): _t846 = 2
	if _t846 == -1 and J.seq(_t845, "open"): _t846 = 3
	if _t846 == -1 and J.seq(_t845, "closing"): _t846 = 4
	if _t846 == -1 and J.seq(_t845, "closed"): _t846 = 5
	if _t846 == -1 and J.seq(_t845, "stuckMove"): _t846 = 6
	if _t846 == -1 and J.seq(_t845, "stuck"): _t846 = 7
	if _t846 == -1 and J.seq(_t845, "unstick"): _t846 = 8
	while true:
		if _t846 <= 0 and _t846 >= 0:
			v_t_474 = J.cl(_s173["__p"]["chooseTarget"], null, [])
			if (not J.leq(v_t_474, null)):
				if (absf(J.num(J.sub(v_t_474, J.gp(_s173["__p"]["S"], "pos")))) < 0.01):
					J.cl(_s173["__p"]["arrive"], null, [])
				else:
					var _t848 = _s173["__p"]["startMove"]
					J.cl(_t848, null, [v_t_474])
			break
		if _t846 <= 1 and _t846 >= 0:
			v_w_475 = J.cl(_s173["__p"]["wanted"], null, [])
			v_t2_476 = J.cl(_s173["__p"]["chooseTarget"], null, [])
			var _t849 = (not J.leq(v_t2_476, null))
			var _t850 = (J.cmp(J.gp(_s173["__p"]["S"], "dir"), 0.0, ">") if _t849 else _t849)
			var _t851 = (J.cmp(v_t2_476, J.gp(_s173["__p"]["S"], "pos"), ">") if _t850 else _t850)
			if (J.cmp(v_t2_476, J.gp(_s173["__p"]["S"], "target"), "<") if _t851 else _t851):
				var _t852 = _s173["__p"]["S"]
				J.sp(_t852, "target", v_t2_476)
			var _t853 = (not J.leq(v_t2_476, null))
			var _t854 = (J.cmp(J.gp(_s173["__p"]["S"], "dir"), 0.0, "<") if _t853 else _t853)
			var _t855 = (J.cmp(v_t2_476, J.gp(_s173["__p"]["S"], "pos"), "<") if _t854 else _t854)
			if (J.cmp(v_t2_476, J.gp(_s173["__p"]["S"], "target"), ">") if _t855 else _t855):
				var _t856 = _s173["__p"]["S"]
				J.sp(_t856, "target", v_t2_476)
			v_d_477 = J.sub(J.gp(_s173["__p"]["S"], "target"), J.gp(_s173["__p"]["S"], "pos"))
			v_ad_478 = absf(J.num(v_d_477))
			v_vm_479 = J.min_([_s173["__p"]["VMAX"], (sqrt(J.num(J.mul(J.mul(2.0, _s173["__p"]["ACC"]), v_ad_478))) + 0.05)])
			var _t857 = _s173["__p"]["S"]
			var _t858 = J.min_([v_vm_479, J.add(J.gp(_s173["__p"]["S"], "v"), J.mul(_s173["__p"]["ACC"], _s173["dt"]))])
			J.sp(_t857, "v", _t858)
			v_mv_480 = J.min_([v_ad_478, J.mul(J.gp(_s173["__p"]["S"], "v"), _s173["dt"])])
			var _t859 = _s173["__p"]["S"]
			var _t860 = J.add(J.gp(_t859, "pos"), J.mul(signf(J.num(v_d_477)), v_mv_480))
			J.sp(_t859, "pos", _t860)
			if J.cmp(J.cl(_s173["__p"]["rnd"], null, []), J.mul(_s173["dt"], 0.5), "<"):
				var _t861 = J.gp(_s173["__p"]["S"], "fx")
				J.sp(_t861, "flick", 0.18)
			if (J.sub(v_ad_478, v_mv_480) <= 0.002):
				var _t862 = _s173["__p"]["S"]
				var _t863 = J.gp(_s173["__p"]["S"], "target")
				J.sp(_t862, "pos", _t863)
				J.mc(_s173["__p"]["SND"], "hum", [false])
				J.cl(_s173["__p"]["arrive"], null, [])
			break
		if _t846 <= 2 and _t846 >= 0:
			var _t864 = _s173["__p"]["S"]
			var _t865 = J.min_([1.0, J.add(J.gp(_s173["__p"]["S"], "door"), J.div(_s173["dt"], _s173["__p"]["DOOR_T"]))])
			J.sp(_t864, "door", _t865)
			if J.cmp(J.gp(_s173["__p"]["S"], "door"), 1.0, ">="):
				var _t866 = _s173["__p"]["S"]
				J.sp(_t866, "st", "open")
				var _t867 = _s173["__p"]["S"]
				var _t868 = J.max_([J.gp(_s173["__p"]["S"], "hold"), _s173["__p"]["HOLD"]])
				J.sp(_t867, "hold", _t868)
			break
		if _t846 <= 3 and _t846 >= 0:
			var _t869 = _s173["__p"]["boardAndExit"]
			J.cl(_t869, null, [_s173["dt"]])
			var _t870 = _s173["__p"]["S"]
			var _t871 = J.sub(J.gp(_t870, "hold"), _s173["dt"])
			J.sp(_t870, "hold", _t871)
			if J.cmp(J.gp(J.gp(_s173["__p"]["S"], "fx"), "over"), 0.0, ">"):
				var _t872 = _s173["__p"]["S"]
				var _t873 = J.max_([J.gp(_s173["__p"]["S"], "hold"), 0.3])
				J.sp(_t872, "hold", _t873)
			if J.cmp(J.gp(_s173["__p"]["S"], "hold"), 0.0, "<="):
				var _t874 = _s173["__p"]["S"]
				J.sp(_t874, "st", "closing")
				J.mc(_s173["__p"]["SND"], "door", [])
			break
		if _t846 <= 4 and _t846 >= 0:
			var _t875 = _s173["__p"]["S"]
			var _t876 = J.max_([0.0, J.sub(J.gp(_s173["__p"]["S"], "door"), J.div(_s173["dt"], _s173["__p"]["DOOR_T"]))])
			J.sp(_t875, "door", _t876)
			if J.cmp(J.gp(_s173["__p"]["S"], "door"), 0.0, "<="):
				var _t877 = _s173["__p"]["S"]
				J.sp(_t877, "st", "closed")
			break
		if _t846 <= 5 and _t846 >= 0:
			v_t3_481 = J.cl(_s173["__p"]["chooseTarget"], null, [])
			var _t878 = (not J.leq(v_t3_481, null))
			if ((absf(J.num(J.sub(v_t3_481, J.gp(_s173["__p"]["S"], "pos")))) > 0.01) if _t878 else _t878):
				var _t879 = _s173["__p"]["startMove"]
				J.cl(_t879, null, [v_t3_481])
			else:
				if (not J.leq(v_t3_481, null)):
					var _t880 = _s173["__p"]["S"]
					J.sp(_t880, "st", "opening")
					J.mc(_s173["__p"]["SND"], "door", [])
				else:
					var _t881 = _s173["__p"]["S"]
					J.sp(_t881, "st", "idle")
			break
		if _t846 <= 6 and _t846 >= 0:
			v_dd_482 = J.sub(J.gp(_s173["__p"]["S"], "stuckTo"), J.gp(_s173["__p"]["S"], "pos"))
			v_st_483 = J.min_([absf(J.num(v_dd_482)), J.mul(1.3, _s173["dt"])])
			var _t882 = _s173["__p"]["S"]
			var _t883 = J.add(J.gp(_t882, "pos"), J.mul(signf(J.num(v_dd_482)), v_st_483))
			J.sp(_t882, "pos", _t883)
			if (absf(J.num(v_dd_482)) <= 0.003):
				var _t884 = _s173["__p"]["S"]
				var _t885 = J.gp(_s173["__p"]["S"], "stuckTo")
				J.sp(_t884, "pos", _t885)
				var _t886 = _s173["__p"]["S"]
				J.sp(_t886, "st", "stuck")
				J.mc(_s173["__p"]["SND"], "hum", [false])
				J.mc(_s173["__p"]["SND"], "clunk", [])
				var _t887 = _s173["__p"]["S"]
				J.sp(_t887, "shake", 0.6)
			break
		if _t846 <= 7 and _t846 >= 0:
			var _t888 = _s173["__p"]["S"]
			var _t889 = J.min_([0.45, J.add(J.gp(_s173["__p"]["S"], "door"), J.div(_s173["dt"], _s173["__p"]["DOOR_T"]))])
			J.sp(_t888, "door", _t889)
			var _t890 = _s173["__p"]["S"]
			var _t891 = J.sub(J.gp(_t890, "stuckT"), _s173["dt"])
			J.sp(_t890, "stuckT", _t891)
			if J.cmp(J.gp(_s173["__p"]["S"], "stuckT"), 0.0, "<="):
				var _t892 = _s173["__p"]["S"]
				J.sp(_t892, "st", "unstick")
				J.mc(_s173["__p"]["SND"], "door", [])
			break
		if _t846 <= 8 and _t846 >= 0:
			var _t893 = _s173["__p"]["S"]
			var _t894 = J.max_([0.0, J.sub(J.gp(_s173["__p"]["S"], "door"), J.div(_s173["dt"], _s173["__p"]["DOOR_T"]))])
			J.sp(_t893, "door", _t894)
			if J.cmp(J.gp(_s173["__p"]["S"], "door"), 0.0, "<="):
				v_nf_484 = (ceil(J.num(J.gp(_s173["__p"]["S"], "pos"))) if J.cmp(J.gp(_s173["__p"]["S"], "dir"), 0.0, ">=") else floor(J.num(J.gp(_s173["__p"]["S"], "pos"))))
				var _t895 = J.max_([0.0, J.min_([J.cl(_s173["__p"]["top"], null, []), v_nf_484])])
				v_nf_484 = _t895
				var _t896 = J.gp(_s173["__p"]["S"], "stops")
				J.sp(_t896, v_nf_484, 1.0)
				var _t897 = _s173["__p"]["startMove"]
				J.cl(_t897, null, [v_nf_484])
				var _t898 = _s173["__p"]["S"]
				J.sp(_t898, "target", v_nf_484)
			break
		break
	var _t899 = (not J.leq(J.gp(_s173["__p"]["S"], "gWait"), null))
	if (J.leq(J.gp(_s173["__p"]["S"], "gCall"), null) if _t899 else _t899):
		v_gw2_485 = J.gp(J.gp(_s173["g0"], "gh"), J.gp(_s173["__p"]["S"], "gWait"))
		var _t901 = (J.cl(_s173["__p"]["atFloor"], null, []) if J.t(v_gw2_485) else v_gw2_485)
		if J.t(_t901):
			var _t900 = J.seq(J.gp(_s173["__p"]["S"], "st"), "opening")
			_t901 = (_t900 if _t900 else J.seq(J.gp(_s173["__p"]["S"], "st"), "open"))
		if J.t((J.seq(J.gp(J.gp(J.gp(_s173["g0"], "nodes"), J.gp(v_gw2_485, "node")), "f"), J.cl(_s173["__p"]["cabF"], null, [])) if J.t(_t901) else _t901)):
			var _t902 = _s173["__p"]["doEnter"]
			J.cl(_t902, null, [v_gw2_485, J.cl(_s173["__p"]["cabF"], null, [])])
	var _t903 = (not J.leq(J.gp(_s173["__p"]["S"], "gWait"), null))
	var _t904 = ((not J.leq(J.gp(_s173["__p"]["S"], "gCall"), null)) if _t903 else _t903)
	var _t905 = (J.cl(_s173["__p"]["atFloor"], null, []) if _t904 else _t904)
	var _t907 = (J.seq(J.cl(_s173["__p"]["cabF"], null, []), J.gp(_s173["__p"]["S"], "gCall")) if J.t(_t905) else _t905)
	if J.t(_t907):
		var _t906 = J.seq(J.gp(_s173["__p"]["S"], "st"), "opening")
		_t907 = (_t906 if _t906 else J.seq(J.gp(_s173["__p"]["S"], "st"), "open"))
	if J.t(_t907):
		v_gw3_486 = J.gp(J.gp(_s173["g0"], "gh"), J.gp(_s173["__p"]["S"], "gWait"))
		var _t908 = _s173["__p"]["doEnter"]
		J.cl(_t908, null, [v_gw3_486, J.cl(_s173["__p"]["cabF"], null, [])])
	var _t909 = J.cl(_s173["__p"]["ghost"], null, [])
	v_g_471 = _t909
	if J.t(v_g_471):
		J.sp(v_g_471, "to", null)
		J.sp(v_g_471, "auto", null)
		J.sp(v_g_471, "autoS", null)
		v_fN_487 = J.max_([0.0, J.min_([J.cl(_s173["__p"]["top"], null, []), J.round(J.num(J.gp(_s173["__p"]["S"], "pos")))])])
		var _t910 = (J.add("f", v_fN_487) + "_l")
		J.sp(v_g_471, "node", _t910)
		var _t911 = J.gp(_s173["c"], "cx")
		J.sp(v_g_471, "x", _t911)
		var _t912 = _s173["__p"]["fyf"]
		var _t913 = J.cl(_t912, null, [J.gp(_s173["__p"]["S"], "pos")])
		J.sp(v_g_471, "y", _t913)
		var _t914 = J.cmp(J.gp(_s173["__p"]["S"], "door"), 0.5, "<")
		if (_t914 if _t914 else (not J.t(J.cl(_s173["__p"]["atFloor"], null, [])))):
			var _t915 = J.gp(v_g_471, "inv")
			var _t916 = J.gp(v_g_471, "inv")
			var _t917 = J.max_([(_t916 if J.t(_t916) else 0.0), 0.15])
			J.sp(v_g_471, "inv", _t917)
		J.sp(v_g_471, "taskP", 0.0)
	for _t918 in J.keys(J.gp(_s173["__p"]["S"], "dfx")):
		v_df_488 = _t918
		var _t919 = J.gp(J.gp(_s173["__p"]["S"], "dfx"), v_df_488)
		var _t920 = J.add(J.gp(_t919, "t"), _s173["dt"])
		J.sp(_t919, "t", _t920)
		if J.cmp(J.gp(J.gp(J.gp(_s173["__p"]["S"], "dfx"), v_df_488), "t"), 1.6, ">"):
			J.del(J.gp(_s173["__p"]["S"], "dfx"), v_df_488)
	if (not J.seq(J.gp(_s173["__p"]["S"], "st"), J.gp(_s173["__p"]["S"], "prevSt"))):
		var _t921 = J.seq(J.gp(_s173["__p"]["S"], "st"), "opening")
		if J.t((J.cl(_s173["__p"]["atFloor"], null, []) if _t921 else _t921)):
			var _t922 = _s173["__p"]["dingFx"]
			J.cl(_t922, null, [J.cl(_s173["__p"]["cabF"], null, []), true])
		var _t923 = _s173["__p"]["S"]
		var _t924 = J.gp(_s173["__p"]["S"], "st")
		J.sp(_t923, "prevSt", _t924)
	var _t925 = J.seq(J.gp(_s173["__p"]["S"], "st"), "stuck")
	if (_t925 if _t925 else J.seq(J.gp(_s173["__p"]["S"], "st"), "stuckMove")):
		var _t926 = J.gp(_s173["__p"]["S"], "riders")
		J.mc(_t926, "forEach", [Callable(self, "_f91").bind(_s173)])

func _f116(this_, a: Array, env):
	var v_t_684 = null
	v_t_684 = J.arg(a, 0)
	var _t934 = env["CRF"]
	var _t935 = env["crFrame"]
	var _t936 = J.cl(_t935, null, [v_t_684, false])
	J.sp(_t934, v_t_684, _t936)
	var _t937 = env["CRF"]
	var _t938 = J.add(v_t_684, "P")
	var _t939 = env["crFrame"]
	var _t940 = J.cl(_t939, null, [v_t_684, true])
	J.sp(_t937, _t938, _t940)

func _f119(this_, a: Array, env):
	var v_e_693 = null
	v_e_693 = J.arg(a, 0)
	J.mc(v_e_693, "stopPropagation", [])

func _f118(this_, a: Array, env):
	var v_ev_690 = null
	v_ev_690 = J.arg(a, 0)
	J.mc(env["ui"], "addEventListener", [v_ev_690, Callable(self, "_f119").bind(env), {"passive": true}])

func _f140(this_, a: Array, env):
	var _t952 = ((not J.leq(J.gp(env["S"], "gi"), null)) if J.t(env["S"]) else env["S"])
	if J.t(_t952):
		var _t951 = J.gp(env["ui"], "classList")
		_t952 = J.mc(_t951, "contains", ["on"])
	return (J.gp(env["L"], "_band") if J.t((J.gp(env["L"], "_band") if J.t(_t952) else _t952)) else null)

func _f153(this_, a: Array, env):
	J.cl(env["drawWorld"], null, [])

func _f154(this_, a: Array, env):
	J.cl(env["drawCab"], null, [])

func _f155(this_, a: Array, env):
	return J.cl(env["layout"], null, [])

func _f157(this_, a: Array, env):
	var v_a_904 = null; var v_b_905 = null
	v_a_904 = J.arg(a, 0)
	v_b_905 = J.arg(a, 1)
	return J.sub(v_a_904, v_b_905)

func _f158(this_, a: Array, env):
	var v_o_908 = null
	v_o_908 = J.arg(a, 0)
	var _t982 = J.seq(J.gp(v_o_908, "ph"), "wait")
	return (J.seq(J.gp(v_o_908, "f"), env["f"]) if _t982 else _t982)

func _f156(this_, a: Array, env):
	var v_inn_899 = null; var v_lit_900 = null; var v_k_901 = null
	var _s366 = {"__p": env, "f": null}
	var _t967 = (not J.t(_s366["__p"]["S"]))
	var _t969 = (_t967 if _t967 else J.leq(J.gp(_s366["__p"]["S"], "gi"), null))
	if not J.t(_t969):
		var _t968 = J.gp(_s366["__p"]["ui"], "classList")
		_t969 = (not J.t(J.mc(_t968, "contains", ["on"])))
	if _t969:
		return null
	_s366["f"] = J.cl(_s366["__p"]["cabF"], null, [])
	v_inn_899 = J.cl(_s366["__p"]["inCab"], null, [])
	v_lit_900 = []
	for _t970 in J.keys(J.gp(_s366["__p"]["S"], "lit")):
		v_k_901 = _t970
		if J.t(J.gp(J.gp(_s366["__p"]["S"], "lit"), v_k_901)):
			J.mc(v_lit_900, "push", [J.num(v_k_901)])
	var _t973 = J.cl(_s366["__p"]["top"], null, [])
	var _t974 = _s366["f"]
	var _t975 = J.cl(_s366["__p"]["atFloor"], null, [])
	var _t976 = J.cmp(J.gp(J.gp(_s366["__p"]["S"], "fx"), "btnAll"), 0.0, ">")
	var _t977 = J.gp(_s366["__p"]["S"], "st")
	var _t978 = J.gp(_s366["__p"]["S"], "door")
	var _t979 = J.gp(_s366["__p"]["S"], "dir")
	var _t980 = (J.gp(_s366["__p"]["S"], "msg") if J.cmp(J.gp(_s366["__p"]["S"], "msgT"), 0.0, ">") else "")
	var _t971 = J.S_Object_("keys", [J.gp(_s366["__p"]["S"], "stops")])
	var _t972 = J.mc(_t971, "map", [J.G.get("Number")])
	var _t983 = J.mc(_t972, "sort", [Callable(self, "_f157").bind(_s366)])
	var _t984 = J.len(v_inn_899)
	var _t981 = J.gp(_s366["__p"]["S"], "riders")
	return {"top": _t973, "f": _t974, "at": _t975, "lit": v_lit_900, "all": _t976, "st": _t977, "door": _t978, "dir": _t979, "msg": _t980, "stops": _t983, "inn": _t984, "waitHere": J.mc(_t981, "some", [Callable(self, "_f158").bind(_s366)]), "cd": J.gp(_s366["__p"]["S"], "cd")}

func _f160(this_, a: Array, env):
	var v_o_913 = null
	v_o_913 = J.arg(a, 0)
	var _t997 = J.gp(v_o_913, "kind")
	var _t998 = J.gp(v_o_913, "ph")
	var _t999 = J.gp(v_o_913, "f")
	var _t1000 = J.gp(v_o_913, "dest")
	var _t1001 = J.gp(v_o_913, "mood")
	var _t996 = J.gp(v_o_913, "fear")
	return {"kind": _t997, "ph": _t998, "f": _t999, "dest": _t1000, "mood": _t1001, "fear": J.round(J.num((_t996 if J.t(_t996) else 0.0))), "say": J.gp(v_o_913, "say")}

func _f159(this_, a: Array, env):
	if (not J.t(env["S"])):
		return null
	var _t987 = J.S_Object_("keys", [J.gp(env["S"], "dfx")])
	var _t989 = J.mc(_t987, "map", [J.G.get("Number")])
	var _t990 = J.gp(env["S"], "on")
	var _t991 = J.gp(env["S"], "pos")
	var _t992 = J.gp(env["S"], "st")
	var _t993 = J.gp(env["S"], "door")
	var _t994 = J.gp(env["S"], "dir")
	var _t988 = J.S_Object_("keys", [J.gp(env["S"], "stops")])
	var _t1002 = J.mc(_t988, "map", [J.G.get("Number")])
	var _t1003 = J.gp(env["S"], "gi")
	var _t1004 = J.gp(env["S"], "gCall")
	var _t1005 = J.S_JSON_("parse", [J.S_JSON_("stringify", [J.gp(env["S"], "cd")])])
	var _t1006 = J.S_JSON_("parse", [J.S_JSON_("stringify", [J.gp(env["S"], "fx")])])
	var _t995 = J.gp(env["S"], "riders")
	var _t1008 = J.mc(_t995, "map", [Callable(self, "_f160").bind(env)])
	var _t1009 = J.len(J.gp(env["S"], "mroom"))
	var _t1010 = J.len(J.gp(env["S"], "away"))
	var _t1007 = J.gp(env["S"], "log")
	var _t1012 = J.mc(_t1007, "slice", [(-30.0)])
	var _t1011 = J.gp(env["L"], "_err")
	return {"dfx": _t989, "on": _t990, "pos": _t991, "st": _t992, "door": _t993, "dir": _t994, "stops": _t1002, "gi": _t1003, "gCall": _t1004, "cd": _t1005, "fx": _t1006, "riders": _t1008, "mroom": _t1009, "away": _t1010, "log": _t1012, "err": (_t1011 if J.t(_t1011) else null), "top": J.cl(env["top"], null, [])}

func _f162(this_, a: Array, env):
	var v_h_925 = null
	v_h_925 = J.arg(a, 0)
	var _t1016 = J.seq(J.gp(v_h_925, "kind"), "guard")
	return ((not J.seq(J.gp(v_h_925, "state"), "gone")) if _t1016 else _t1016)

func _f163(this_, a: Array, env):
	var v_r_928 = null
	v_r_928 = J.arg(a, 0)
	var _t1020 = J.seq(J.gp(v_r_928, "state"), "home")
	var _t1021 = (J.gp(v_r_928, "unit") if _t1020 else _t1020)
	return (J.seq(J.gp(J.gp(v_r_928, "unit"), "f"), env["f"]) if J.t(_t1021) else _t1021)

func _f164(this_, a: Array, env):
	var v_r_931 = null
	v_r_931 = J.arg(a, 0)
	var _t1023 = J.seq(J.gp(v_r_931, "state"), "home")
	var _t1024 = (J.gp(v_r_931, "unit") if _t1023 else _t1023)
	return (J.cmp(J.gp(J.gp(v_r_931, "unit"), "f"), 2.0, ">=") if J.t(_t1024) else _t1024)

func _f161(this_, a: Array, env):
	var v_kind_916 = null; var v_dest_918 = null; var v_g0_919 = null; var v_o_920 = null; var v_h_921 = null; var v_r_922 = null
	var _s372 = {"__p": env, "f": null}
	v_kind_916 = J.arg(a, 0)
	_s372["f"] = J.arg(a, 1)
	v_dest_918 = J.arg(a, 2)
	if (not J.seq(J.cl(_s372["__p"]["G"], null, []), _s372["__p"]["lastG"])):
		J.cl(_s372["__p"]["reset"], null, [])
	v_g0_919 = J.cl(_s372["__p"]["G"], null, [])
	if J.seq(v_kind_916, "guard"):
		var _t1015 = J.gp(v_g0_919, "guards")
		v_h_921 = J.mc(_t1015, "find", [Callable(self, "_f162").bind(_s372)])
		if (not J.t(v_h_921)):
			return null
		var _t1017 = _s372["__p"]["addGuardRider"]
		var _t1018 = J.cl(_t1017, null, [v_h_921, v_dest_918])
		v_o_920 = _t1018
	else:
		var _t1019 = J.gp(v_g0_919, "res")
		var _t1025 = J.mc(_t1019, "find", [Callable(self, "_f163").bind(_s372)])
		if not J.t(_t1025):
			var _t1022 = J.gp(v_g0_919, "res")
			_t1025 = J.mc(_t1022, "find", [Callable(self, "_f164").bind(_s372)])
		v_r_922 = _t1025
		if (not J.t(v_r_922)):
			return null
		var _t1026 = _s372["__p"]["addResRider"]
		var _t1027 = J.cl(_t1026, null, [v_r_922, "snack", v_dest_918])
		v_o_920 = _t1027
		J.sp(v_r_922, "brave", 0.0)
	var _t1028 = _s372["f"]
	J.sp(v_o_920, "f", _t1028)
	J.sp(v_o_920, "ph", "wait")
	var _t1029 = J.sub(J.gp(J.cl(_s372["__p"]["col"], null, []), "cx"), 44.0)
	J.sp(v_o_920, "x", _t1029)
	return true

func _f165(this_, a: Array, env):
	var v_f_934 = null
	v_f_934 = J.arg(a, 0)
	if (not J.seq(J.cl(env["G"], null, []), env["lastG"])):
		J.cl(env["reset"], null, [])
	var _t1032 = env["S"]
	J.sp(_t1032, "pos", v_f_934)
	var _t1033 = env["S"]
	J.sp(_t1033, "st", "idle")
	var _t1034 = env["S"]
	J.sp(_t1034, "door", 0.0)
	var _t1035 = env["S"]
	J.sp(_t1035, "v", 0.0)

func _f166(this_, a: Array, env):
	if (not J.seq(J.cl(env["G"], null, []), env["lastG"])):
		J.cl(env["reset"], null, [])
	var _t1038 = env["S"]
	J.sp(_t1038, "spawnT", 1000000000.0)
	var _t1039 = env["S"]
	J.sp(_t1039, "gSpawnT", 1000000000.0)

func _f2(this_, a: Array, env):
	var v_css_29 = null; var v_resIn_67 = null; var v_crPaperURL_93 = null; var v_crEdgeURL_94 = null; var v_bi_95 = null
	var _s3 = {"__p": env, "A": null, "L": null, "S": null, "lastG": null, "CAP": null, "VMAX": null, "ACC": null, "DOOR_T": null, "HOLD": null, "TR": null, "TRK": null, "LN": null, "lnUsed": null, "AC": null, "hum": null, "noiseBuf": null, "SND": null, "wc": null, "wx0": null, "wx": null, "CRT": null, "CRF": null, "ui": null, "cabCv": null, "cx2": null, "trickBox": null, "block": null, "panel": null, "stEl": null, "floorsEl": null, "doorsEl": null, "built": null, "fBtns": null, "tBtns": null, "tex": null, "last": null, "line": null, "ac": null, "nbuf": null, "tone": null, "noiseBurst": null, "G": null, "FL": null, "top": null, "lab": null, "fyf": null, "col": null, "FH": null, "rnd": null, "pick": null, "cabF": null, "atFloor": null, "ghost": null, "gpm": null, "sayR": null, "fl": null, "riderSpr": null, "rKey": null, "rH": null, "inCab": null, "reset": null, "wanted": null, "chooseTarget": null, "startMove": null, "arrive": null, "boardAndExit": null, "exitRider": null, "spawnResident": null, "addResRider": null, "spawnGuard": null, "addGuardRider": null, "doEnter": null, "scareLanding": null, "dingFx": null, "flash": null, "log": null, "img": null, "sprAt": null, "bub": null, "drawWorld": null, "ease": null, "steel": null, "gapLight": null, "lightLevel": null, "crFrame": null, "tapFx": null, "mkBtn": null, "build": null, "layout": null, "refresh": null, "showUI": null, "hideUI": null, "crayonTex": null, "poly": null, "texFill": null, "drawCab": null, "running": null, "loop": null}
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
	v_resIn_67 = Callable(self, "_f38").bind(_s3)
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
	v_crPaperURL_93 = Callable(self, "_f112").bind(_s3)
	v_crEdgeURL_94 = Callable(self, "_f114").bind(_s3)
	v_bi_95 = Callable(self, "_f117").bind(_s3)
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
	var _t592 = _s3["L"]
	var _t600 = Callable(self, "_f65").bind(_s3)
	J.sp(_t592, "action", _t600)
	var _t601 = _s3["L"]
	var _t616 = Callable(self, "_f66").bind(_s3)
	J.sp(_t601, "enter", _t616)
	var _t617 = _s3["L"]
	var _t629 = Callable(self, "_f68").bind(_s3)
	J.sp(_t617, "exit", _t629)
	var _t630 = _s3["L"]
	var _t641 = Callable(self, "_f69").bind(_s3)
	J.sp(_t630, "press", _t641)
	var _t642 = _s3["L"]
	var _t651 = Callable(self, "_f70").bind(_s3)
	J.sp(_t642, "open", _t651)
	var _t652 = _s3["L"]
	var _t658 = Callable(self, "_f71").bind(_s3)
	J.sp(_t652, "close", _t658)
	var _t659 = _s3["L"]
	var _t668 = Callable(self, "_f72").bind(_s3)
	J.sp(_t659, "canTrick", _t668)
	var _t669 = _s3["L"]
	var _t729 = Callable(self, "_f74").bind(_s3)
	J.sp(_t669, "trick", _t729)
	var _t730 = _s3["L"]
	var _t754 = Callable(self, "_f80").bind(_s3)
	J.sp(_t730, "scareWaiting", _t754)
	var _t755 = _s3["L"]
	var _t929 = Callable(self, "_f85").bind(_s3)
	J.sp(_t755, "step", _t929)
	_s3["wc"] = J.S_document_("createElement", ["canvas"])
	var _t930 = _s3["wc"]
	J.sp(_t930, "id", "lift-world")
	var _t931 = J.gp(_s3["wc"], "style")
	J.sp(_t931, "cssText", "position:fixed;pointer-events:none;z-index:61;left:0;top:0")
	var _t932 = J.gp(J.G.get("document"), "body")
	J.mc(_t932, "appendChild", [_s3["wc"]])
	_s3["wx0"] = J.mc(_s3["wc"], "getContext", ["2d"])
	_s3["wx"] = _s3["wx0"]
	_s3["CRT"] = {"bone": ["#1e1a16", "#5c5246", "#d8ccb0"], "rust": ["#2a190d", "#8c4b1d", "#e08840"], "moss": ["#121a11", "#3b5431", "#8aac6c"], "red": ["#2b1012", "#7a2522", "#c4493c"], "ink": ["#18141b", "#3c3544", "#958a9c"], "violet": ["#19132a", "#4b3b6e", "#9c88cc"]}
	_s3["CRF"] = {}
	var _t933 = ["bone", "rust", "moss", "red", "ink", "violet"]
	J.mc(_t933, "forEach", [Callable(self, "_f116").bind(_s3)])
	_s3["ui"] = J.S_document_("createElement", ["div"])
	var _t941 = _s3["ui"]
	J.sp(_t941, "id", "lift-ui")
	var _t942 = _s3["ui"]
	J.sp(_t942, "className", "tw-lift")
	var _t943 = _s3["ui"]
	var _t944 = "<canvas id=\"lift-cab\"></canvas><div id=\"lift-tricks\"></div><div id=\"lift-block\"></div><div id=\"lift-panel\"><div id=\"lift-st\"></div><div id=\"lift-floors\"></div><div id=\"lift-doors\"></div></div>"
	J.sp(_t943, "innerHTML", _t944)
	v_css_29 = J.S_document_("createElement", ["style"])
	var _t945 = J.gp(_s3["A"], "FONT")
	var _t946 = (J.add(((J.add(((J.add((J.add((J.add(((J.add(((J.add((J.add(((J.add((J.add(((J.add(((((J.add((J.add(((((((J.add("#lift-ui{position:fixed;display:none;z-index:62;pointer-events:none;font-family:", J.mc(_t945, "replace", [J.re("\"", "g"), "'"])) + "}") + "#lift-ui.on{display:block}#lift-ui>*{position:absolute;left:0;right:0;pointer-events:auto}") + "#lift-cab{width:100%;display:block;transform:translateY(-12px);opacity:0;transition:transform .28s,opacity .28s;border-bottom:3px solid #3a2e2a;box-shadow:0 6px 18px rgba(0,0,0,.6)}#lift-ui.show #lift-cab{transform:none;opacity:1}") + "#lift-block{background:transparent;touch-action:none}") + "#lift-tricks{display:flex;gap:5px;padding:0 6px;justify-content:center;touch-action:manipulation}") + ".tw-lift #lift-panel{background:"), J.cl(v_crEdgeURL_94, null, [])) + " repeat-x top left/256px 12px,"), J.cl(v_crPaperURL_93, null, [])) + " repeat 0 0/160px 160px,#141016;padding:12px 8px 10px;box-sizing:border-box;touch-action:manipulation;transform:translateY(20px);opacity:0;transition:transform .28s,opacity .28s;box-shadow:0 -6px 14px rgba(0,0,0,.6)}.tw-lift.show #lift-panel{transform:none;opacity:1}") + ".tw-lift #lift-st{color:#e6a85a;font-size:15px;font-weight:bold;height:20px;line-height:20px;text-align:center;text-shadow:1px 2px 0 rgba(6,3,8,.9),0 0 3px #000;white-space:nowrap;overflow:hidden}") + ".tw-lift #lift-floors{display:grid;gap:6px;margin:6px 0;justify-content:center}.tw-lift #lift-doors{display:flex;gap:6px}") + ".tw-lift .lb{min-width:48px;min-height:48px;"), J.cl(v_bi_95, null, ["bone"])) + "color:#efe5cf;font-weight:bold;font-size:18px;display:flex;align-items:center;justify-content:center;user-select:none;-webkit-user-select:none;transition:transform .06s;box-sizing:border-box;text-shadow:1px 2px 0 rgba(6,3,8,.9),0 0 2px #000}") + ".tw-lift .lb.lit{border-image-source:"), J.gp(_s3["CRF"], "rust")) + ";color:#f6dcb6}.tw-lift .lb.cur{border-image-source:"), J.gp(_s3["CRF"], "moss")) + ";color:#e4ecd2}") + ".tw-lift .lb.press,.tw-lift .lb:active{transform:translateY(2px);border-image-source:"), J.gp(_s3["CRF"], "boneP")) + "}.tw-lift .lb.lit.press,.tw-lift .lb.lit:active{border-image-source:"), J.gp(_s3["CRF"], "rustP")) + "}") + ".tw-lift .ld{flex:1;min-height:52px;"), J.cl(v_bi_95, null, ["ink"])) + "color:#ebe3d6;font-weight:bold;font-size:16px;display:flex;align-items:center;justify-content:center;user-select:none;-webkit-user-select:none;transition:transform .06s;box-sizing:border-box;text-shadow:1px 2px 0 rgba(6,3,8,.9),0 0 2px #000}") + ".tw-lift .ld.exit{border-image-source:"), J.gp(_s3["CRF"], "moss")) + ";color:#e4ecd2}.tw-lift .ld.off{opacity:.45;filter:saturate(.5)}.tw-lift .ld.press,.tw-lift .ld:active{transform:translateY(2px);border-image-source:"), J.gp(_s3["CRF"], "inkP")) + "}.tw-lift .ld.exit.press,.tw-lift .ld.exit:active{border-image-source:"), J.gp(_s3["CRF"], "mossP")) + "}") + ".tw-lift .lt{flex:1;min-height:52px;max-width:76px;"), J.cl(v_bi_95, null, ["red"])) + "color:#f2e3cc;font-size:14px;font-weight:bold;display:flex;flex-direction:column;align-items:center;justify-content:center;line-height:1.15;user-select:none;-webkit-user-select:none;transition:transform .06s;box-sizing:border-box;text-shadow:1px 2px 0 rgba(6,3,8,.9),0 0 2px #000}") + ".tw-lift .lt small{font-size:11px;font-weight:bold;color:#e8c4b0}.tw-lift .lt.cd{opacity:.5;filter:saturate(.4)}.tw-lift .lt.press,.tw-lift .lt:active{transform:translateY(2px);border-image-source:"), J.gp(_s3["CRF"], "redP")) + "}")
	J.sp(v_css_29, "textContent", _t946)
	var _t947 = J.gp(J.G.get("document"), "head")
	J.mc(_t947, "appendChild", [v_css_29])
	var _t948 = J.gp(J.G.get("document"), "body")
	J.mc(_t948, "appendChild", [_s3["ui"]])
	_s3["cabCv"] = J.mc(_s3["ui"], "querySelector", ["#lift-cab"])
	_s3["cx2"] = J.mc(_s3["cabCv"], "getContext", ["2d"])
	_s3["trickBox"] = J.mc(_s3["ui"], "querySelector", ["#lift-tricks"])
	_s3["block"] = J.mc(_s3["ui"], "querySelector", ["#lift-block"])
	_s3["panel"] = J.mc(_s3["ui"], "querySelector", ["#lift-panel"])
	_s3["stEl"] = J.mc(_s3["ui"], "querySelector", ["#lift-st"])
	_s3["floorsEl"] = J.mc(_s3["ui"], "querySelector", ["#lift-floors"])
	_s3["doorsEl"] = J.mc(_s3["ui"], "querySelector", ["#lift-doors"])
	var _t949 = ["pointerdown", "pointermove", "pointerup", "touchstart", "touchmove"]
	J.mc(_t949, "forEach", [Callable(self, "_f118").bind(_s3)])
	_s3["built"] = (-1.0)
	_s3["fBtns"] = {}
	_s3["tBtns"] = {}
	var _t950 = _s3["L"]
	var _t953 = Callable(self, "_f140").bind(_s3)
	J.sp(_t950, "band", _t953)
	_s3["tex"] = null
	_s3["last"] = 0.0
	J.F_requestAnimationFrame([_s3["loop"]])
	var _t954 = _s3["L"]
	var _t955 = Callable(self, "_f153").bind(_s3)
	J.sp(_t954, "drawW", _t955)
	var _t956 = _s3["L"]
	var _t957 = Callable(self, "_f154").bind(_s3)
	J.sp(_t956, "drawCabN", _t957)
	var _t958 = _s3["L"]
	var _t959 = Callable(self, "_f155").bind(_s3)
	J.sp(_t958, "layoutN", _t959)
	var _t960 = _s3["L"]
	var _t961 = _s3["lab"]
	J.sp(_t960, "lab", _t961)
	var _t962 = _s3["L"]
	var _t963 = _s3["TR"]
	J.sp(_t962, "TR", _t963)
	var _t964 = _s3["L"]
	var _t965 = _s3["TRK"]
	J.sp(_t964, "TRK", _t965)
	var _t966 = _s3["L"]
	var _t985 = Callable(self, "_f156").bind(_s3)
	J.sp(_t966, "ui", _t985)
	var _t986 = _s3["L"]
	var _t1013 = Callable(self, "_f159").bind(_s3)
	J.sp(_t986, "state", _t1013)
	var _t1014 = _s3["L"]
	var _t1030 = Callable(self, "_f161").bind(_s3)
	J.sp(_t1014, "debugRider", _t1030)
	var _t1031 = _s3["L"]
	var _t1036 = Callable(self, "_f165").bind(_s3)
	J.sp(_t1031, "setPos", _t1036)
	var _t1037 = _s3["L"]
	var _t1040 = Callable(self, "_f166").bind(_s3)
	J.sp(_t1037, "noSpawn", _t1040)
	var _t1041 = _s3["L"]
	var _t1042 = _s3["lab"]
	J.sp(_t1041, "lab", _t1042)
	return _s3["L"]

func _f1(this_, a: Array, env):
	var _t1 = J.G.get("window")
	var _t1043 = Callable(self, "_f2").bind(env)
	J.sp(_t1, "LiftSys", _t1043)

func _f170(this_, a: Array, env):
	var v___1047 = null; var v_i_1048 = null
	v___1047 = J.arg(a, 0)
	v_i_1048 = J.arg(a, 1)
	return v_i_1048

func _f169(this_, a: Array, env):
	var v_k_1039 = null; var v_p_1040 = null; var v_a_1041 = null; var v_i_1042 = null; var v_j_1043 = null; var v_t_1044 = null
	v_k_1039 = J.arg(a, 0)
	v_p_1040 = J.gp(env["LN"], v_k_1039)
	var _t1047 = (not J.t(J.gp(env["lnUsed"], v_k_1039)))
	if (_t1047 if _t1047 else (not J.t(J.len(J.gp(env["lnUsed"], v_k_1039))))):
		v_a_1041 = J.mc(v_p_1040, "map", [Callable(self, "_f170").bind(env)])
		v_i_1042 = (J.len(v_a_1041) - 1.0)
		while true:
			if not J.cmp(v_i_1042, 0.0, ">"): break
			v_j_1043 = floor(J.num(J.mul(randf(), J.add(v_i_1042, 1.0))))
			v_t_1044 = J.gp(v_a_1041, v_i_1042)
			var _t1048 = J.gp(v_a_1041, v_j_1043)
			J.sp(v_a_1041, v_i_1042, _t1048)
			J.sp(v_a_1041, v_j_1043, v_t_1044)
			v_i_1042 = J.num(v_i_1042) + -1.0
		var _t1049 = env["lnUsed"]
		J.sp(_t1049, v_k_1039, v_a_1041)
	return J.gp(v_p_1040, J.mc(J.gp(env["lnUsed"], v_k_1039), "pop", []))

func _f171(this_, a: Array, env):
	var _t1050 = J.gp(J.G.get("window"), "UNIT_LAYOUTS")
	return (_t1050 if J.t(_t1050) else {})

func _f172(this_, a: Array, env):
	var v_un_1053 = null; var v_L_1054 = null; var v_k_1055 = null; var v_l_1056 = null
	v_un_1053 = J.arg(a, 0)
	v_L_1054 = J.cl(env["LAYS"], null, [])
	var _t1051 = J.gp(env["A"], "LV")
	var _t1053 = null
	if J.t((J.seq(J.gp(J.gp(env["A"], "LV"), "key"), "shop") if J.t(_t1051) else _t1051)):
		_t1053 = "shop"
	else:
		var _t1052 = ["gamer", "ot", "gym"]
		_t1053 = ("gamer" if J.cmp(J.mc(_t1052, "indexOf", [J.gp(v_un_1053, "hh")]), 0.0, ">=") else "ppr")
	v_k_1055 = _t1053
	var _t1054 = J.gp(v_L_1054, v_k_1055)
	v_l_1056 = (_t1054 if J.t(_t1054) else J.gp(v_L_1054, "ppr"))
	var _t1056 = v_l_1056
	if J.t(_t1056):
		var _t1055 = env["img"]
		_t1056 = J.cl(_t1055, null, [J.gp(v_l_1056, "img")])
	if J.t(_t1056):
		J.sp(v_l_1056, "key", v_k_1055)
		return v_l_1056
	var _t1057 = env["FB"]
	J.sp(_t1057, "key", "fb")
	return env["FB"]

func _f173(this_, a: Array, env):
	return J.gp(env["A"], "G")

func _f174(this_, a: Array, env):
	return (J.mc(env["A"], "rnd", []) if J.t(J.gp(env["A"], "rnd")) else randf())

func _f175(this_, a: Array, env):
	var v_a_1063 = null
	v_a_1063 = J.arg(a, 0)
	return J.gp(v_a_1063, floor(J.num(J.mul(J.cl(env["rnd"], null, []), J.len(v_a_1063)))))

func _f176(this_, a: Array, env):
	var v_k_1066 = null; var v_im_1067 = null
	v_k_1066 = J.arg(a, 0)
	var _t1058 = (J.gp(env["A"], "IMG") if J.t(v_k_1066) else v_k_1066)
	v_im_1067 = (J.gp(J.gp(env["A"], "IMG"), v_k_1066) if J.t(_t1058) else _t1058)
	return (v_im_1067 if J.t((J.gp(v_im_1067, "width") if J.t(v_im_1067) else v_im_1067)) else null)

func _f177(this_, a: Array, env):
	var v_v_1070 = null; var v_a_1071 = null; var v_b_1072 = null
	v_v_1070 = J.arg(a, 0)
	v_a_1071 = J.arg(a, 1)
	v_b_1072 = J.arg(a, 2)
	return (v_a_1071 if J.cmp(v_v_1070, v_a_1071, "<") else (v_b_1072 if J.cmp(v_v_1070, v_b_1072, ">") else v_v_1070))

func _f179(this_, a: Array, env):
	var v_p_1081 = null
	v_p_1081 = J.arg(a, 0)
	var _t1059 = J.add(env["t"], J.gp(v_p_1081, 1.0))
	env["t"] = _t1059

func _f178(this_, a: Array, env):
	var v_a_1075 = null; var v_r_1077 = null; var v_i_1078 = null
	var _s395 = {"__p": env, "t": null}
	v_a_1075 = J.arg(a, 0)
	_s395["t"] = 0.0
	J.mc(v_a_1075, "forEach", [Callable(self, "_f179").bind(_s395)])
	v_r_1077 = J.mul(J.cl(_s395["__p"]["rnd"], null, []), _s395["t"])
	v_i_1078 = 0.0
	while true:
		if not J.cmp(v_i_1078, J.len(v_a_1075), "<"): break
		var _t1060 = J.sub(v_r_1077, J.gp(J.gp(v_a_1075, v_i_1078), 1.0))
		v_r_1077 = _t1060
		if J.cmp(v_r_1077, 0.0, "<="):
			return J.gp(J.gp(v_a_1075, v_i_1078), 0.0)
		v_i_1078 = J.num(v_i_1078) + 1.0
	return J.gp(J.gp(v_a_1075, 0.0), 0.0)

func _f180(this_, a: Array, env):
	var v_un_1084 = null
	v_un_1084 = J.arg(a, 0)
	var _t1061 = (J.gp(v_un_1084, "hh") if J.t(v_un_1084) else v_un_1084)
	var _t1062 = ((not J.seq(J.gp(v_un_1084, "ot"), "deity")) if J.t(_t1061) else _t1061)
	return (not (not J.t((J.gp(v_un_1084, "rs") if J.t(_t1062) else _t1062))))

func _f181(this_, a: Array, env):
	var v_un_1087 = null; var v_T_1088 = null
	v_un_1087 = J.arg(a, 0)
	if (not J.t(J.gp(v_un_1087, "iu"))):
		var _t1063 = J.gp(env["TASK"], J.gp(v_un_1087, "hh"))
		v_T_1088 = (_t1063 if J.t(_t1063) else {"k": "allout"})
		var _t1064 = {"alert": 0.0, "leftT": 0.0, "ban": 0.0, "cd": 0.0, "task": J.S_JSON_("parse", [J.S_JSON_("stringify", [v_T_1088])]), "done": false, "fled": 0.0, "visits": 0.0, "phoned": false}
		J.sp(v_un_1087, "iu", _t1064)
	return J.gp(v_un_1087, "iu")

func _f182(this_, a: Array, env):
	var v_x_1091 = null; var v_R_1092 = null; var v_i_1093 = null
	v_x_1091 = J.arg(a, 0)
	v_R_1092 = J.gp(J.gp(env["S"], "lay"), "rooms")
	v_i_1093 = 0.0
	while true:
		if not J.cmp(v_i_1093, J.len(v_R_1092), "<"): break
		var _t1065 = J.cmp(v_x_1091, J.sub(J.gp(J.gp(v_R_1092, v_i_1093), "x0"), 8.0), ">=")
		if (J.cmp(v_x_1091, J.add(J.gp(J.gp(v_R_1092, v_i_1093), "x1"), 8.0), "<=") if _t1065 else _t1065):
			return v_i_1093
		v_i_1093 = J.num(v_i_1093) + 1.0
	return (0.0 if J.cmp(v_x_1091, J.gp(J.gp(v_R_1092, 0.0), "x0"), "<") else (J.len(v_R_1092) - 1.0))

func _f183(this_, a: Array, env):
	var v_r_1096 = null; var v_t_1097 = null
	v_r_1096 = J.arg(a, 0)
	v_t_1097 = J.arg(a, 1)
	if (not J.t(v_r_1096)):
		return null
	J.sp(v_r_1096, "say", v_t_1097)
	J.sp(v_r_1096, "sayT", 2.6)

func _f184(this_, a: Array, env):
	var v_t_1100 = null; var v_c_1101 = null
	v_t_1100 = J.arg(a, 0)
	v_c_1101 = J.arg(a, 1)
	if J.t(env["S"]):
		var _t1066 = env["S"]
		J.sp(_t1066, "msg", v_t_1100)
		var _t1067 = env["S"]
		J.sp(_t1067, "msgT", 3.2)
		var _t1068 = env["S"]
		var _t1069 = (v_c_1101 if J.t(v_c_1101) else "#efdcb4")
		J.sp(_t1068, "msgC", _t1069)

func _f186(this_, a: Array, env):
	var v_f_1112 = null
	v_f_1112 = J.arg(a, 0)
	var _t1071 = (absf(J.num(J.sub(J.gp(v_f_1112, "x"), env["x"]))) < 140.0)
	return ((absf(J.num(J.sub(J.gp(v_f_1112, "y"), env["yy"]))) < 30.0) if _t1071 else _t1071)

func _f185(this_, a: Array, env):
	var v_y_1105 = null; var v_t_1106 = null; var v_c_1107 = null; var v_k_1109 = null
	var _s407 = {"__p": env, "x": null, "yy": null}
	_s407["x"] = J.arg(a, 0)
	v_y_1105 = J.arg(a, 1)
	v_t_1106 = J.arg(a, 2)
	v_c_1107 = J.arg(a, 3)
	if (not J.t(_s407["__p"]["S"])):
		return null
	_s407["yy"] = v_y_1105
	v_k_1109 = 0.0
	while true:
		var _t1072 = J.cmp(v_k_1109, 4.0, "<")
		if J.t(_t1072):
			var _t1070 = J.gp(_s407["__p"]["S"], "floats")
			_t1072 = J.mc(_t1070, "some", [Callable(self, "_f186").bind(_s407)])
		if not J.t(_t1072): break
		var _t1073 = J.sub(_s407["yy"], 32.0)
		_s407["yy"] = _t1073
		v_k_1109 = J.num(v_k_1109) + 1.0
	var _t1074 = J.gp(_s407["__p"]["S"], "floats")
	J.mc(_t1074, "push", [{"x": _s407["x"], "y": _s407["yy"], "t": v_t_1106, "c": (v_c_1107 if J.t(v_c_1107) else "#efe5cf"), "life": 1.8}])
	if (J.len(J.gp(_s407["__p"]["S"], "floats")) > 8.0):
		J.mc(J.gp(_s407["__p"]["S"], "floats"), "shift", [])

func _f187(this_, a: Array, env):
	var v_x_1115 = null; var v_y_1116 = null; var v_vx_1117 = null; var v_vy_1118 = null; var v_life_1119 = null; var v_type_1120 = null
	v_x_1115 = J.arg(a, 0)
	v_y_1116 = J.arg(a, 1)
	v_vx_1117 = J.arg(a, 2)
	v_vy_1118 = J.arg(a, 3)
	v_life_1119 = J.arg(a, 4)
	v_type_1120 = J.arg(a, 5)
	if J.t(((J.len(J.gp(env["S"], "parts")) < 220.0) if J.t(env["S"]) else env["S"])):
		var _t1075 = J.gp(env["S"], "parts")
		J.mc(_t1075, "push", [{"x": v_x_1115, "y": v_y_1116, "vx": v_vx_1117, "vy": v_vy_1118, "life": v_life_1119, "max": v_life_1119, "type": v_type_1120}])

func _f188(this_, a: Array, env):
	var v_g0_1123 = null
	v_g0_1123 = J.cl(env["G"], null, [])
	var _t1076 = J.seq(J.gp(env["A"], "scene"), "play")
	var _t1077 = (v_g0_1123 if _t1076 else _t1076)
	var _t1078 = ((not J.t(J.gp(v_g0_1123, "over"))) if J.t(_t1077) else _t1077)
	var _t1079 = ((not J.t(J.gp(v_g0_1123, "choice"))) if J.t(_t1078) else _t1078)
	var _t1080 = ((not J.t(J.gp(v_g0_1123, "showStory"))) if J.t(_t1079) else _t1079)
	var _t1081 = ((not J.t(J.gp(v_g0_1123, "ult"))) if J.t(_t1080) else _t1080)
	return ((not J.t(J.gp(env["A"], "paused"))) if J.t(_t1081) else _t1081)

func _f189(this_, a: Array, env):
	var v_g0_1126 = null
	v_g0_1126 = J.cl(env["G"], null, [])
	var _t1082 = (J.seq(J.gp(env["A"], "scene"), "play") if J.t(env["S"]) else env["S"])
	var _t1083 = (v_g0_1126 if J.t(_t1082) else _t1082)
	var _t1084 = ((not J.t(J.gp(v_g0_1126, "over"))) if J.t(_t1083) else _t1083)
	var _t1085 = ((not J.t(J.gp(v_g0_1126, "choice"))) if J.t(_t1084) else _t1084)
	return (not (not J.t(((not J.t(J.gp(v_g0_1126, "showStory"))) if J.t(_t1085) else _t1085))))

func _f190(this_, a: Array, env):
	var v_e_1129 = null; var v_e_1130 = null
	if (not J.t(env["AC"])):
		var _t1086 = J.gp(J.G.get("window"), "AudioContext")
		var _t1087 = J.construct((_t1086 if J.t(_t1086) else J.gp(J.G.get("window"), "webkitAudioContext")), [])
		env["AC"] = _t1087
	if J.t((J.seq(J.gp(env["AC"], "state"), "suspended") if J.t(env["AC"]) else env["AC"])):
		J.mc(env["AC"], "resume", [])
	return env["AC"]

func _f191(this_, a: Array, env):
	var v_f_1133 = null; var v_t0_1134 = null; var v_dur_1135 = null; var v_vol_1136 = null; var v_type_1137 = null; var v_c_1138 = null; var v_o_1139 = null; var v_g_1140 = null; var v_e_1141 = null
	v_f_1133 = J.arg(a, 0)
	v_t0_1134 = J.arg(a, 1)
	v_dur_1135 = J.arg(a, 2)
	v_vol_1136 = J.arg(a, 3)
	v_type_1137 = J.arg(a, 4)
	v_c_1138 = J.cl(env["ac"], null, [])
	if (not J.t(v_c_1138)):
		return null
	v_o_1139 = J.mc(v_c_1138, "createOscillator", [])
	v_g_1140 = J.mc(v_c_1138, "createGain", [])
	var _t1088 = (v_type_1137 if J.t(v_type_1137) else "sine")
	J.sp(v_o_1139, "type", _t1088)
	var _t1089 = J.gp(v_o_1139, "frequency")
	J.sp(_t1089, "value", v_f_1133)
	var _t1090 = J.gp(v_g_1140, "gain")
	J.mc(_t1090, "setValueAtTime", [0.0001, J.add(J.gp(v_c_1138, "currentTime"), v_t0_1134)])
	var _t1091 = J.gp(v_g_1140, "gain")
	J.mc(_t1091, "exponentialRampToValueAtTime", [v_vol_1136, J.add(J.add(J.gp(v_c_1138, "currentTime"), v_t0_1134), 0.01)])
	var _t1092 = J.gp(v_g_1140, "gain")
	J.mc(_t1092, "exponentialRampToValueAtTime", [0.0001, J.add(J.add(J.gp(v_c_1138, "currentTime"), v_t0_1134), v_dur_1135)])
	J.mc(v_o_1139, "connect", [v_g_1140])
	J.mc(v_g_1140, "connect", [J.gp(v_c_1138, "destination")])
	J.mc(v_o_1139, "start", [J.add(J.gp(v_c_1138, "currentTime"), v_t0_1134)])
	J.mc(v_o_1139, "stop", [J.add(J.add(J.add(J.gp(v_c_1138, "currentTime"), v_t0_1134), v_dur_1135), 0.05)])

func _f192(this_, a: Array, env):
	var v_t0_1144 = null; var v_dur_1145 = null; var v_vol_1146 = null; var v_freq_1147 = null; var v_c_1148 = null; var v_d_1149 = null; var v_i_1150 = null; var v_s_1151 = null; var v_bp_1152 = null; var v_g_1153 = null; var v_T_1154 = null; var v_e_1155 = null
	v_t0_1144 = J.arg(a, 0)
	v_dur_1145 = J.arg(a, 1)
	v_vol_1146 = J.arg(a, 2)
	v_freq_1147 = J.arg(a, 3)
	v_c_1148 = J.cl(env["ac"], null, [])
	if (not J.t(v_c_1148)):
		return null
	if (not J.t(env["NB"])):
		var _t1093 = J.mc(v_c_1148, "createBuffer", [1.0, J.gp(v_c_1148, "sampleRate"), J.gp(v_c_1148, "sampleRate")])
		env["NB"] = _t1093
		v_d_1149 = J.mc(env["NB"], "getChannelData", [0.0])
		v_i_1150 = 0.0
		while true:
			if not J.cmp(v_i_1150, J.len(v_d_1149), "<"): break
			var _t1094 = ((randf() * 2.0) - 1.0)
			J.sp(v_d_1149, v_i_1150, _t1094)
			v_i_1150 = J.num(v_i_1150) + 1.0
	v_s_1151 = J.mc(v_c_1148, "createBufferSource", [])
	var _t1095 = env["NB"]
	J.sp(v_s_1151, "buffer", _t1095)
	J.sp(v_s_1151, "loop", true)
	v_bp_1152 = J.mc(v_c_1148, "createBiquadFilter", [])
	J.sp(v_bp_1152, "type", "bandpass")
	var _t1096 = J.gp(v_bp_1152, "frequency")
	var _t1097 = (v_freq_1147 if J.t(v_freq_1147) else 900.0)
	J.sp(_t1096, "value", _t1097)
	v_g_1153 = J.mc(v_c_1148, "createGain", [])
	v_T_1154 = J.add(J.gp(v_c_1148, "currentTime"), v_t0_1144)
	var _t1098 = J.gp(v_g_1153, "gain")
	J.mc(_t1098, "setValueAtTime", [0.0001, v_T_1154])
	var _t1099 = J.gp(v_g_1153, "gain")
	J.mc(_t1099, "linearRampToValueAtTime", [v_vol_1146, J.add(v_T_1154, J.mul(v_dur_1145, 0.3))])
	var _t1100 = J.gp(v_g_1153, "gain")
	J.mc(_t1100, "linearRampToValueAtTime", [0.0001, J.add(v_T_1154, v_dur_1145)])
	J.mc(v_s_1151, "connect", [v_bp_1152])
	J.mc(v_bp_1152, "connect", [v_g_1153])
	J.mc(v_g_1153, "connect", [J.gp(v_c_1148, "destination")])
	J.mc(v_s_1151, "start", [v_T_1154])
	J.mc(v_s_1151, "stop", [J.add(J.add(v_T_1154, v_dur_1145), 0.05)])

func _f199(this_, a: Array, env):
	var v_g_1172 = null; var v_un_1173 = null; var v_b_1174 = null; var v_I_1175 = null
	v_g_1172 = J.arg(a, 0)
	v_un_1173 = J.arg(a, 1)
	var _t1101 = env["isHH"]
	if (not J.t(J.cl(_t1101, null, [v_un_1173]))):
		return "no"
	v_b_1174 = J.mc(env["A"], "doorBlock", [v_g_1172, v_un_1173])
	if J.t(v_b_1174):
		return v_b_1174
	var _t1102 = env["iu"]
	v_I_1175 = J.cl(_t1102, null, [v_un_1173])
	if J.cmp(J.gp(v_I_1175, "ban"), 0.0, ">"):
		return "ban"
	if J.cmp(J.gp(v_I_1175, "cd"), 0.0, ">"):
		return "cd"
	return true

func _f202(this_, a: Array, env):
	var v_g_1188 = null; var v_un_1189 = null; var v_why_1190 = null; var v_I_1191 = null; var v_t_1192 = null
	v_g_1188 = J.arg(a, 0)
	v_un_1189 = J.arg(a, 1)
	v_why_1190 = J.arg(a, 2)
	v_I_1191 = J.gp(v_un_1189, "iu")
	var _t1106 = null
	if J.seq(v_why_1190, "deity"):
		_t1106 = "呢度有神明鎮宅，要尊重，我哋唔入"
	else:
		var _t1105 = null
		if J.seq(v_why_1190, "ban"):
			_t1105 = (J.add("呢戶啱啱被趕出嚟，佢哋開晒燈，", ceil(J.num(J.gp(v_I_1191, "ban")))) + " 秒後先好再入")
		else:
			var _t1104 = null
			if J.seq(v_why_1190, "cd"):
				_t1104 = (J.add("陰氣未回，", ceil(J.num(J.gp(v_I_1191, "cd")))) + " 秒後先入得")
			else:
				var _t1103 = J.gp(J.gp(env["A"], "BLOCKMSG"), v_why_1190)
				_t1104 = (_t1103 if J.t(_t1103) else "呢戶未入得")
			_t1105 = _t1104
		_t1106 = _t1105
	v_t_1192 = _t1106
	J.mc(env["A"], "float", [J.gp(v_un_1189, "x"), J.sub(J.gp(v_un_1189, "y"), 96.0), v_t_1192, "#ffd54a"])
	var _t1107 = J.seq(v_why_1190, "deity")
	if J.t((J.gp(J.cl(env["G"], null, []), "wardFx") if _t1107 else _t1107)):
		var _t1108 = J.gp(J.cl(env["G"], null, []), "wardFx")
		J.mc(_t1108, "push", [{"x": J.gp(v_un_1189, "x"), "y": J.gp(v_un_1189, "y"), "t": 0.9}])

func _f205(this_, a: Array, env):
	var v_R_1215 = null; var v_i_1216 = null
	v_R_1215 = J.arg(a, 0)
	v_i_1216 = J.arg(a, 1)
	var _t1113 = J.gp(env["S"], "light")
	J.mc(_t1113, "push", [false])
	var _t1114 = J.gp(env["S"], "dark")
	J.mc(_t1114, "push", [0.0])

func _f206(this_, a: Array, env):
	var v_p_1219 = null
	v_p_1219 = J.arg(a, 0)
	if J.t(J.gp(env["HOT"], J.gp(v_p_1219, "k"))):
		var _t1116 = J.gp(env["S"], "spots")
		J.mc(_t1116, "push", [{"k": J.gp(v_p_1219, "k"), "x": J.gp(v_p_1219, "x"), "y": J.gp(v_p_1219, "y"), "room": 0.0, "cd": 0.0, "t": 0.0}])

func _f207(this_, a: Array, env):
	var v_p_1222 = null
	v_p_1222 = J.arg(a, 0)
	var _t1118 = env["roomAt"]
	var _t1119 = J.cl(_t1118, null, [J.gp(v_p_1222, "x")])
	J.sp(v_p_1222, "room", _t1119)

func _f208(this_, a: Array, env):
	var v_p_1225 = null
	v_p_1225 = J.arg(a, 0)
	var _t1121 = J.gp(env["S"], "search")
	var _t1123 = J.gp(v_p_1225, "x")
	var _t1124 = J.gp(v_p_1225, "y")
	var _t1125 = J.gp(v_p_1225, "n")
	var _t1122 = env["roomAt"]
	J.mc(_t1121, "push", [{"x": _t1123, "y": _t1124, "n": _t1125, "room": J.cl(_t1122, null, [J.gp(v_p_1225, "x")])}])

func _f210(this_, a: Array, env):
	var v_p_1231 = null
	v_p_1231 = J.arg(a, 0)
	return J.seq(J.gp(v_p_1231, "k"), env["k"])

func _f209(this_, a: Array, env):
	var _s457 = {"__p": env, "k": null}
	_s457["k"] = J.arg(a, 0)
	var _t1127 = J.gp(_s457["__p"]["S"], "spots")
	return J.mc(_t1127, "some", [Callable(self, "_f210").bind(_s457)])

func _f211(this_, a: Array, env):
	var v_r_1234 = null; var v_i_1235 = null
	v_r_1234 = J.arg(a, 0)
	v_i_1235 = J.arg(a, 1)
	if J.seq(J.gp(v_r_1234, "state"), "home"):
		var _t1134 = J.gp(env["S"], "actors")
		var _t1135 = env["mkActor"]
		J.mc(_t1134, "push", [J.cl(_t1135, null, [v_r_1234, v_i_1235, true])])

func _f212(this_, a: Array, env):
	var v_a_1238 = null
	v_a_1238 = J.arg(a, 0)
	if J.t(J.gp(J.gp(v_a_1238, "r"), "awake")):
		var _t1138 = J.gp(env["S"], "light")
		var _t1137 = env["roomAt"]
		var _t1139 = J.cl(_t1137, null, [J.gp(v_a_1238, "x")])
		J.sp(_t1138, _t1139, true)

func _f213(this_, a: Array, env):
	return true

func _f204(this_, a: Array, env):
	var v_g_1203 = null; var v_un_1204 = null; var v_g0_1205 = null; var v_lay_1206 = null; var v_I_1207 = null; var v_T_1208 = null; var v_mk_1209 = null; var v_sp_1210 = null; var v_ac0_1211 = null; var v_hh_1212 = null
	v_g_1203 = J.arg(a, 0)
	v_un_1204 = J.arg(a, 1)
	v_g0_1205 = J.cl(env["G"], null, [])
	var _t1109 = env["layFor"]
	v_lay_1206 = J.cl(_t1109, null, [v_un_1204])
	var _t1110 = env["iu"]
	v_I_1207 = J.cl(_t1110, null, [v_un_1204])
	J.sp(v_I_1207, "visits", J.num(J.gp(v_I_1207, "visits")) + 1.0)
	var _t1111 = {"un": v_un_1204, "g": v_g_1203, "lay": v_lay_1206, "t": 0.0, "limit": env["LIMIT"], "gx": J.add(J.gp(v_lay_1206, "door"), 50.0), "gdir": 1.0, "gmv": 0.0, "still": 1.0, "goX": null, "pend": null, "joy": null, "sc": null, "scCd": 0.0, "invT": 0.0, "stun": 0.0, "alert": J.max_([0.0, J.sub(J.gp(v_I_1207, "alert"), (J.sub(J.gp(v_g0_1205, "t"), J.gp(v_I_1207, "leftT")) * 1.0))]), "calmT": 0.0, "flags": {}, "actors": [], "spots": [], "search": [], "floats": [], "parts": [], "fx": [], "light": [], "dark": [], "cam": {"x": 0.0, "free": null}, "msg": null, "msgT": 0.0, "task": J.gp(v_I_1207, "task"), "searchP": 0.0, "searchI": (-1.0), "stealP": 0.0, "lastSeen": 0.0, "kickT": 0.0, "flash": 0.0}
	env["S"] = _t1111
	var _t1112 = J.gp(v_lay_1206, "rooms")
	J.mc(_t1112, "forEach", [Callable(self, "_f205").bind(env)])
	var _t1115 = J.gp(v_lay_1206, "spots")
	J.mc(_t1115, "forEach", [Callable(self, "_f206").bind(env)])
	var _t1117 = J.gp(env["S"], "spots")
	J.mc(_t1117, "forEach", [Callable(self, "_f207").bind(env)])
	var _t1120 = J.gp(v_lay_1206, "search")
	J.mc(_t1120, "forEach", [Callable(self, "_f208").bind(env)])
	v_T_1208 = J.gp(env["S"], "task")
	if J.seq(J.gp(v_T_1208, "k"), "media"):
		var _t1126 = ["tv", "pc", "radio"]
		v_mk_1209 = J.mc(_t1126, "find", [Callable(self, "_f209").bind(env)])
		if (not J.t(v_mk_1209)):
			J.sp(v_T_1208, "k", "allout")
		else:
			J.sp(v_T_1208, "spot", v_mk_1209)
	if J.seq(J.gp(v_T_1208, "k"), "steal"):
		var _t1128 = J.gp(v_lay_1206, "steal")
		var _t1129 = (J.gp(J.gp(v_lay_1206, "steal"), J.gp(v_T_1208, "at")) if J.t(_t1128) else _t1128)
		v_sp_1210 = (_t1129 if J.t(_t1129) else null)
		v_ac0_1211 = J.gp(J.gp(v_lay_1206, "acts"), J.gp(v_T_1208, "at"))
		var _t1130 = (J.gp(v_sp_1210, "x") if J.t(v_sp_1210) else (J.gp(v_ac0_1211, "x") if J.t(v_ac0_1211) else J.add(J.gp(v_lay_1206, "door"), 120.0)))
		J.sp(v_T_1208, "x", _t1130)
		var _t1131 = (J.gp(v_sp_1210, "y") if J.t(v_sp_1210) else J.sub(J.gp(v_lay_1206, "floor"), 60.0))
		J.sp(v_T_1208, "y", _t1131)
	var _t1132 = (J.add("偷走", J.gp(v_T_1208, "o")) if J.seq(J.gp(v_T_1208, "k"), "steal") else ("令全屋人走晒（嚇到佢哋奔出屋）" if J.seq(J.gp(v_T_1208, "k"), "allout") else (((J.add("趁住客沖緊涼，喺", J.gp(J.gp(J.gp(v_lay_1206, "rooms"), 3.0), "n")) + "嚇親佢") if J.seq(J.gp(v_T_1208, "room"), "bath") else "趁住客煮緊嘢食，喺廚房嚇親佢") if J.seq(J.gp(v_T_1208, "k"), "room") else ("趁住客睇緊電視，搞部電視" if J.seq(J.gp(v_T_1208, "spot"), "tv") else ("趁住客打緊機，搞部電腦" if J.seq(J.gp(v_T_1208, "spot"), "pc") else "趁住客聽緊收音機，搞部收音機")))))
	J.sp(v_T_1208, "t", _t1132)
	var _t1133 = J.gp(v_un_1204, "rs")
	J.mc(_t1133, "forEach", [Callable(self, "_f211").bind(env)])
	var _t1136 = J.gp(env["S"], "actors")
	J.mc(_t1136, "forEach", [Callable(self, "_f212").bind(env)])
	if J.t(J.gp(v_I_1207, "lights")):
		var _t1140 = env["S"]
		var _t1141 = J.gp(env["S"], "light")
		var _t1142 = J.mc(_t1141, "map", [Callable(self, "_f213").bind(env)])
		J.sp(_t1140, "light", _t1142)
	J.sp(v_g_1203, "inUnit", v_un_1204)
	J.sp(v_g_1203, "to", null)
	J.sp(v_g_1203, "auto", null)
	J.sp(v_g_1203, "autoS", null)
	J.sp(v_g_1203, "taskP", 0.0)
	J.sp(v_g_1203, "sc", null)
	J.sp(v_g_1203, "still", 1.0)
	var _t1143 = J.gp(env["S"], "cam")
	var _t1144 = env["clamp"]
	var _t1145 = J.cl(_t1144, null, [J.sub(J.gp(env["S"], "gx"), 180.0), 0.0, J.gp(v_lay_1206, "W")])
	J.sp(_t1143, "x", _t1145)
	var _t1146 = env["S"]
	J.sp(_t1146, "invT", 2.0)
	J.mc(env["SND"], "door", [])
	var _t1147 = env["hideNative"]
	J.cl(_t1147, null, [true])
	v_hh_1212 = J.gp(J.gp(env["A"], "HH"), J.gp(v_un_1204, "hh"))
	var _t1148 = env["msg"]
	J.cl(_t1148, null, [J.add((J.add(J.add("入咗", J.gp(J.gp(env["A"], "FLN"), J.gp(v_un_1204, "f"))), (J.gp(v_hh_1212, "n") if J.t(v_hh_1212) else "住戶")) + "：熄咗燈嘅房先好郁手；撳作怪點、撳住客嚇人。屋內任務："), J.gp(v_T_1208, "t")), "#efdcb4"])
	var _t1149 = env["S"]
	J.sp(_t1149, "msgT", 5.5)
	var _t1150 = J.seq(J.gp(J.gp(v_g_1203, "d"), "key"), "toyol")
	var _t1151 = (J.gp(v_un_1204, "beans") if _t1150 else _t1150)
	if J.t(((not J.t(J.gp(v_un_1204, "beansDone"))) if J.t(_t1151) else _t1151)):
		J.sp(v_un_1204, "beansDone", true)
		var _t1152 = env["S"]
		J.sp(_t1152, "stun", 2.6)
		var _t1153 = env["wfl"]
		J.cl(_t1153, null, [J.gp(env["S"], "gx"), (J.sub(J.gp(v_lay_1206, "floor"), J.gp(v_lay_1206, "ph")) - 30.0), "地下有綠豆！忍唔住坐低數……", "#b8f0a0"])
	if J.t(J.gp(v_I_1207, "done")):
		var _t1154 = J.gp(env["S"], "task")
		J.sp(_t1154, "done", true)

func _f214(this_, a: Array, env):
	var v_r_1243 = null; var v_i_1244 = null; var v_place_1245 = null; var v_a_1246 = null
	v_r_1243 = J.arg(a, 0)
	v_i_1244 = J.arg(a, 1)
	v_place_1245 = J.arg(a, 2)
	v_a_1246 = {"r": v_r_1243, "i": v_i_1244, "x": J.add(J.gp(J.gp(env["S"], "lay"), "door"), 60.0), "dir": 1.0, "act": null, "actT": 0.0, "st": "walk", "tx": null, "pose": "stand", "seeT": 0.0, "hitT": (-9.0), "goT": 0.0, "lightT": 0.0, "ex": false}
	if J.t(v_place_1245):
		var _t1155 = env["pickAct"]
		J.cl(_t1155, null, [v_a_1246, true])
		var _t1156 = J.gp(v_a_1246, "tx")
		J.sp(v_a_1246, "x", _t1156)
		J.sp(v_a_1246, "st", "act")
		var _t1157 = env["actPose"]
		var _t1158 = J.cl(_t1157, null, [v_a_1246])
		J.sp(v_a_1246, "pose", _t1158)
	return v_a_1246

func _f215(this_, a: Array, env):
	var v_a_1249 = null; var v_d_1250 = null
	v_a_1249 = J.arg(a, 0)
	var _t1159 = J.gp(J.gp(J.gp(env["S"], "lay"), "acts"), J.gp(v_a_1249, "act"))
	v_d_1250 = (_t1159 if J.t(_t1159) else {})
	var _t1160 = J.gp(v_d_1250, "pose")
	return (_t1160 if J.t(_t1160) else "stand")

func _f217(this_, a: Array, env):
	var v_o_1263 = null
	v_o_1263 = J.arg(a, 0)
	var _t1172 = (not J.seq(v_o_1263, env["a"]))
	return (J.seq(J.gp(v_o_1263, "act"), env["k"]) if _t1172 else _t1172)

func _f216(this_, a: Array, env):
	var v_first_1254 = null; var v_r_1255 = null; var v_lay_1256 = null; var v_d_1258 = null; var v_x_1259 = null; var v_same_1260 = null
	var _s468 = {"__p": env, "a": null, "k": null}
	_s468["a"] = J.arg(a, 0)
	v_first_1254 = J.arg(a, 1)
	v_r_1255 = J.gp(_s468["a"], "r")
	v_lay_1256 = J.gp(_s468["__p"]["S"], "lay")
	if (not J.t(J.gp(v_r_1255, "awake"))):
		_s468["k"] = "bed"
	else:
		var _t1161 = _s468["__p"]["wpick"]
		var _t1162 = J.gp(_s468["__p"]["WANT"], J.gp(v_r_1255, "hh"))
		var _t1163 = J.cl(_t1161, null, [(_t1162 if J.t(_t1162) else [["sofa", 1.0]])])
		_s468["k"] = _t1163
		if (not J.t(J.gp(J.gp(v_lay_1256, "acts"), _s468["k"]))):
			_s468["k"] = "sofa"
		var _t1164 = J.seq(J.gp(_s468["a"], "act"), _s468["k"])
		var _t1165 = ((not J.t(v_first_1254)) if _t1164 else _t1164)
		if ((not J.seq(_s468["k"], "table")) if _t1165 else _t1165):
			var _t1166 = _s468["__p"]["wpick"]
			var _t1167 = J.gp(_s468["__p"]["WANT"], J.gp(v_r_1255, "hh"))
			var _t1168 = J.cl(_t1166, null, [(_t1167 if J.t(_t1167) else [["sofa", 1.0]])])
			_s468["k"] = _t1168
	var _t1169 = J.gp(J.gp(v_lay_1256, "acts"), _s468["k"])
	var _t1170 = (_t1169 if J.t(_t1169) else J.gp(J.gp(v_lay_1256, "acts"), "sofa"))
	v_d_1258 = (_t1170 if J.t(_t1170) else {"x": J.add(J.gp(v_lay_1256, "door"), 150.0)})
	v_x_1259 = J.gp(v_d_1258, "x")
	var _t1171 = J.gp(_s468["__p"]["S"], "actors")
	v_same_1260 = J.len(J.mc(_t1171, "filter", [Callable(self, "_f217").bind(_s468)]))
	var _t1173 = J.seq(_s468["k"], "table")
	if J.t((J.gp(v_d_1258, "seats") if _t1173 else _t1173)):
		var _t1174 = J.gp(J.gp(v_d_1258, "seats"), J.mod(J.gp(_s468["a"], "i"), J.len(J.gp(v_d_1258, "seats"))))
		v_x_1259 = _t1174
	else:
		if J.t(v_same_1260):
			var _t1175 = J.add(v_x_1259, ((((-1.0) if J.t(J.mod(v_same_1260, 2.0)) else 1.0) * ceil(J.num(J.div(v_same_1260, 2.0)))) * (110.0 if J.seq(_s468["k"], "bed") else 70.0)))
			v_x_1259 = _t1175
	var _t1176 = _s468["a"]
	var _t1177 = _s468["k"]
	J.sp(_t1176, "act", _t1177)
	var _t1178 = _s468["a"]
	var _t1179 = _s468["__p"]["clamp"]
	var _t1180 = J.cl(_t1179, null, [v_x_1259, J.add(J.gp(J.gp(J.gp(v_lay_1256, "rooms"), 0.0), "x0"), 30.0), J.sub(J.gp(J.gp(J.gp(v_lay_1256, "rooms"), (J.len(J.gp(v_lay_1256, "rooms")) - 1.0)), "x1"), 30.0)])
	J.sp(_t1178, "tx", _t1180)
	var _t1181 = _s468["a"]
	var _t1182 = (1000000000.0 if J.seq(_s468["k"], "bed") else ((40.0 + J.mul(J.cl(_s468["__p"]["rnd"], null, []), 20.0)) if J.seq(_s468["k"], "table") else (9.0 + J.mul(J.cl(_s468["__p"]["rnd"], null, []), 9.0))))
	J.sp(_t1181, "actT", _t1182)
	var _t1183 = _s468["a"]
	J.sp(_t1183, "st", "walk")
	var _t1184 = _s468["a"]
	J.sp(_t1184, "pose", "stand")

func _f230(this_, a: Array, env):
	var v_p_1332 = null; var v_i_1333 = null
	v_p_1332 = J.arg(a, 0)
	v_i_1333 = J.arg(a, 1)
	var _t1189 = J.cmp(absf(J.num(J.sub(J.gp(v_p_1332, "x"), J.gp(env["__p"]["S"], "gx")))), env["bd"], "<")
	if J.t(_t1189):
		var _t1188 = env["__p"]["itemsAt"]
		_t1189 = J.len(J.cl(_t1188, null, [v_i_1333]))
	if J.t(_t1189):
		var _t1190 = absf(J.num(J.sub(J.gp(v_p_1332, "x"), J.gp(env["__p"]["S"], "gx"))))
		env["bd"] = _t1190
		env["near"] = v_i_1333

func _f231(this_, a: Array, env):
	var v_k_1336 = null; var v_I_1337 = null
	v_k_1336 = J.arg(a, 0)
	v_I_1337 = J.gp(J.gp(env["__p"]["A"], "ITEM"), v_k_1336)
	var _t1210 = (not J.t(J.gp(v_I_1337, "who")))
	return (_t1210 if _t1210 else J.seq(J.gp(v_I_1337, "who"), J.gp(J.gp(env["g"], "d"), "key")))

func _f229(this_, a: Array, env):
	var v_dt_1318 = null; var v_g0_1320 = null; var v_lay_1321 = null; var v_un_1322 = null; var v_st_1325 = null; var v_it_1326 = null; var v_k0_1327 = null; var v_w_1328 = null; var v_ix_1329 = null
	var _s506 = {"__p": env, "g": null, "near": null, "bd": null}
	v_dt_1318 = J.arg(a, 0)
	_s506["g"] = J.gp(_s506["__p"]["S"], "g")
	v_g0_1320 = J.cl(_s506["__p"]["G"], null, [])
	v_lay_1321 = J.gp(_s506["__p"]["S"], "lay")
	v_un_1322 = J.gp(_s506["__p"]["S"], "un")
	_s506["near"] = (-1.0)
	_s506["bd"] = 70.0
	var _t1185 = J.seq(J.gp(J.gp(_s506["__p"]["S"], "task"), "k"), "steal")
	var _t1186 = ((not J.t(J.gp(J.gp(_s506["__p"]["S"], "task"), "done"))) if _t1185 else _t1185)
	if (J.cmp(absf(J.num(J.sub(J.gp(_s506["__p"]["S"], "gx"), J.gp(J.gp(_s506["__p"]["S"], "task"), "x")))), _s506["bd"], "<") if _t1186 else _t1186):
		_s506["near"] = 99.0
	else:
		var _t1187 = J.gp(_s506["__p"]["S"], "search")
		J.mc(_t1187, "forEach", [Callable(self, "_f230").bind(_s506)])
	var _t1191 = J.cmp(J.gp(_s506["__p"]["S"], "still"), 0.12, ">=")
	var _t1192 = (J.cmp(J.gp(_s506["__p"]["S"], "stun"), 0.0, "<=") if _t1191 else _t1191)
	var _t1193 = ((not J.t(J.gp(_s506["__p"]["S"], "sc"))) if _t1192 else _t1192)
	v_st_1325 = (J.cmp(J.gp(_s506["__p"]["S"], "t"), 0.8, ">") if _t1193 else _t1193)
	var _t1194 = J.cmp(_s506["near"], 0.0, "<")
	if (_t1194 if _t1194 else (not J.t(v_st_1325))):
		if (not J.seq(J.gp(_s506["__p"]["S"], "searchI"), _s506["near"])):
			var _t1195 = _s506["__p"]["S"]
			J.sp(_t1195, "searchP", 0.0)
		var _t1196 = _s506["__p"]["S"]
		var _t1197 = _s506["near"]
		J.sp(_t1196, "searchI", _t1197)
		return null
	if (not J.seq(J.gp(_s506["__p"]["S"], "searchI"), _s506["near"])):
		var _t1198 = _s506["__p"]["S"]
		var _t1199 = _s506["near"]
		J.sp(_t1198, "searchI", _t1199)
		var _t1200 = _s506["__p"]["S"]
		J.sp(_t1200, "searchP", 0.0)
	if J.seq(_s506["near"], 99.0):
		var _t1201 = _s506["__p"]["S"]
		var _t1203 = J.mul(v_dt_1318, J.gp(J.gp(v_g0_1320, "mods"), "task"))
		var _t1202 = J.gp(_s506["g"], "tm")
		var _t1204 = J.add(J.gp(_t1201, "searchP"), J.div(J.mul(_t1203, (_t1202 if J.t(_t1202) else 1.0)), 2.4))
		J.sp(_t1201, "searchP", _t1204)
		if J.cmp(J.cl(_s506["__p"]["rnd"], null, []), J.mul(v_dt_1318, 8.0), "<"):
			var _t1205 = _s506["__p"]["part"]
			J.cl(_t1205, null, [J.add(J.gp(J.gp(_s506["__p"]["S"], "task"), "x"), (J.sub(J.cl(_s506["__p"]["rnd"], null, []), 0.5) * 30.0)), J.gp(J.gp(_s506["__p"]["S"], "task"), "y"), (J.sub(J.cl(_s506["__p"]["rnd"], null, []), 0.5) * 60.0), (-80.0), 0.6, "dust"])
		if J.cmp(J.gp(_s506["__p"]["S"], "searchP"), 1.0, ">="):
			var _t1206 = _s506["__p"]["S"]
			J.sp(_t1206, "searchP", 0.0)
			var _t1207 = J.gp(_s506["__p"]["S"], "task")
			J.sp(_t1207, "done", true)
			J.cl(_s506["__p"]["taskDone"], null, [])
		return null
	var _t1208 = _s506["__p"]["itemsAt"]
	var _t1209 = J.cl(_t1208, null, [_s506["near"]])
	v_it_1326 = J.mc(_t1209, "find", [Callable(self, "_f231").bind(_s506)])
	if (not J.t(v_it_1326)):
		if (not J.t(J.gp(J.gp(_s506["__p"]["S"], "flags"), J.add("who", _s506["near"])))):
			var _t1211 = J.gp(_s506["__p"]["S"], "flags")
			var _t1212 = J.add("who", _s506["near"])
			J.sp(_t1211, _t1212, 1.0)
			var _t1213 = _s506["__p"]["itemsAt"]
			v_k0_1327 = J.gp(J.cl(_t1213, null, [_s506["near"]]), 0.0)
			v_w_1328 = J.gp(J.gp(J.gp(_s506["__p"]["A"], "ITEM"), v_k0_1327), "who")
			var _t1214 = _s506["__p"]["wfl"]
			var _t1217 = J.gp(J.gp(J.gp(_s506["__p"]["S"], "search"), _s506["near"]), "x")
			var _t1218 = J.sub(J.gp(J.gp(J.gp(_s506["__p"]["S"], "search"), _s506["near"]), "y"), 50.0)
			var _t1216 = J.add(J.gp(J.gp(J.gp(_s506["__p"]["A"], "ITEM"), v_k0_1327), "n"), "要")
			var _t1215 = J.gp({"eking": "餓鬼", "toyol": "Toyol", "tianhua": "天花姐"}, v_w_1328)
			J.cl(_t1214, null, [_t1217, _t1218, (J.add(_t1216, (_t1215 if J.t(_t1215) else "其他鬼")) + "先拎得"), "#e6a85a"])
		return null
	var _t1219 = (not J.seq(v_it_1326, "doll"))
	var _t1220 = ((not J.seq(v_it_1326, "key")) if _t1219 else _t1219)
	var _t1221 = ((not J.seq(v_it_1326, "key2")) if _t1220 else _t1220)
	var _t1222 = ((not J.seq(v_it_1326, "lost")) if _t1221 else _t1221)
	if (J.cmp(J.len(J.gp(v_g0_1320, "bag")), J.gp(_s506["__p"]["A"], "BAGMAX"), ">=") if _t1222 else _t1222):
		if (not J.t(J.gp(J.gp(_s506["__p"]["S"], "flags"), "full"))):
			var _t1223 = J.gp(_s506["__p"]["S"], "flags")
			J.sp(_t1223, "full", 1.0)
			var _t1224 = _s506["__p"]["wfl"]
			J.cl(_t1224, null, [J.gp(_s506["__p"]["S"], "gx"), (J.sub(J.gp(v_lay_1321, "floor"), J.gp(v_lay_1321, "ph")) - 20.0), "收穫格滿咗！", "#e48a78"])
		return null
	var _t1225 = _s506["__p"]["S"]
	var _t1227 = J.mul(v_dt_1318, J.gp(J.gp(v_g0_1320, "mods"), "task"))
	var _t1226 = J.gp(_s506["g"], "tm")
	var _t1228 = J.add(J.gp(_t1225, "searchP"), J.div(J.mul(_t1227, (_t1226 if J.t(_t1226) else 1.0)), J.gp(J.gp(J.gp(_s506["__p"]["A"], "ITEM"), v_it_1326), "t")))
	J.sp(_t1225, "searchP", _t1228)
	if J.cmp(J.gp(_s506["__p"]["S"], "searchP"), 1.0, ">="):
		var _t1229 = _s506["__p"]["S"]
		J.sp(_t1229, "searchP", 0.0)
		var _t1230 = J.gp(v_un_1322, "items")
		v_ix_1329 = J.mc(_t1230, "indexOf", [v_it_1326])
		if J.cmp(v_ix_1329, 0.0, ">="):
			var _t1231 = J.gp(v_un_1322, "items")
			J.mc(_t1231, "splice", [v_ix_1329, 1.0])
			J.mc(_s506["__p"]["A"], "takeItem", [_s506["g"], v_it_1326, v_un_1322])
			var _t1232 = _s506["__p"]["wfl"]
			J.cl(_t1232, null, [J.gp(J.gp(J.gp(_s506["__p"]["S"], "search"), _s506["near"]), "x"), J.sub(J.gp(J.gp(J.gp(_s506["__p"]["S"], "search"), _s506["near"]), "y"), 60.0), (J.add("搜到", J.gp(J.gp(J.gp(_s506["__p"]["A"], "ITEM"), v_it_1326), "n")) + "！"), "#e6a85a"])

func _f233(this_, a: Array, env):
	var v_k_1345 = null; var v_j_1346 = null
	v_k_1345 = J.arg(a, 0)
	v_j_1346 = J.arg(a, 1)
	if J.seq(J.mod(v_j_1346, env["n"]), env["i"]):
		J.mc(env["out"], "push", [v_k_1345])

func _f232(this_, a: Array, env):
	var _s521 = {"__p": env, "i": null, "n": null, "out": null}
	_s521["i"] = J.arg(a, 0)
	_s521["n"] = J.len(J.gp(_s521["__p"]["S"], "search"))
	_s521["out"] = []
	var _t1233 = J.gp(J.gp(_s521["__p"]["S"], "un"), "items")
	J.mc(_t1233, "forEach", [Callable(self, "_f233").bind(_s521)])
	return _s521["out"]

func _f236(this_, a: Array, env):
	var v_a_1361 = null
	v_a_1361 = J.arg(a, 0)
	return J.seq(J.gp(v_a_1361, "r"), env["r"])

func _f235(this_, a: Array, env):
	var v_i_1357 = null; var v_a_1358 = null
	var _s524 = {"__p": env, "r": null}
	_s524["r"] = J.arg(a, 0)
	v_i_1357 = J.arg(a, 1)
	var _t1235 = J.seq(J.gp(_s524["r"], "state"), "home")
	var _t1237 = ((not J.cmp(J.gp(_s524["r"], "fleeAfter"), 0.0, ">")) if _t1235 else _t1235)
	if J.t(_t1237):
		var _t1236 = J.gp(_s524["__p"]["__p"]["S"], "actors")
		_t1237 = (not J.t(J.mc(_t1236, "some", [Callable(self, "_f236").bind(_s524)])))
	if _t1237:
		var _t1238 = _s524["__p"]["__p"]["mkActor"]
		v_a_1358 = J.cl(_t1238, null, [_s524["r"], v_i_1357, false])
		var _t1239 = J.add(_s524["__p"]["door"], 20.0)
		J.sp(v_a_1358, "x", _t1239)
		var _t1240 = _s524["__p"]["__p"]["pickAct"]
		J.cl(_t1240, null, [v_a_1358])
		var _t1241 = J.gp(_s524["__p"]["__p"]["S"], "actors")
		J.mc(_t1241, "push", [v_a_1358])
		var _t1242 = _s524["__p"]["__p"]["sayR"]
		J.cl(_t1242, null, [_s524["r"], "返到屋企喇……"])

func _f238(this_, a: Array, env):
	var v_p_1376 = null
	v_p_1376 = J.arg(a, 0)
	return J.seq(J.gp(v_p_1376, "k"), J.gp(env["d0"], "look"))

func _f239(this_, a: Array, env):
	var v_o_1379 = null
	v_o_1379 = J.arg(a, 0)
	var _t1313 = (not J.seq(v_o_1379, env["a"]))
	var _t1315 = ((not J.t(J.gp(J.gp(v_o_1379, "r"), "awake"))) if _t1313 else _t1313)
	if J.t(_t1315):
		var _t1314 = env["__p"]["__p"]["roomAt"]
		_t1315 = J.seq(J.cl(_t1314, null, [J.gp(v_o_1379, "x")]), env["ri"])
	return _t1315

func _f237(this_, a: Array, env):
	var v_r_1365 = null; var v_run_1366 = null; var v_spd_1367 = null; var v_d_1368 = null; var v_w_1369 = null; var v_sp_1371 = null; var v_sleepers_1373 = null
	var _s527 = {"__p": env, "a": null, "d0": null, "ri": null}
	_s527["a"] = J.arg(a, 0)
	v_r_1365 = J.gp(_s527["a"], "r")
	var _t1244 = _s527["a"]
	var _t1245 = J.max_([0.0, J.sub(J.gp(_s527["a"], "seeT"), J.mul(_s527["__p"]["dt"], 0.5))])
	J.sp(_t1244, "seeT", _t1245)
	var _t1246 = _s527["a"]
	var _t1247 = J.max_([0.0, J.sub(J.gp(_s527["a"], "lightT"), _s527["__p"]["dt"])])
	J.sp(_t1246, "lightT", _t1247)
	var _t1248 = (not J.seq(J.gp(v_r_1365, "state"), "home"))
	if (_t1248 if _t1248 else J.cmp(J.gp(v_r_1365, "fleeAfter"), 0.0, ">")):
		var _t1249 = J.seq(J.gp(v_r_1365, "state"), "flee")
		var _t1250 = (_t1249 if _t1249 else J.seq(J.gp(v_r_1365, "state"), "gone"))
		v_run_1366 = (_t1250 if _t1250 else J.cmp(J.gp(v_r_1365, "fleeAfter"), 0.0, ">"))
		var _t1251 = _s527["a"]
		J.sp(_t1251, "pose", "stand")
		var _t1252 = _s527["a"]
		var _t1253 = ("run" if J.t(v_run_1366) else "leave")
		J.sp(_t1252, "st", _t1253)
		v_spd_1367 = (360.0 if J.t(v_run_1366) else 110.0)
		var _t1254 = _s527["a"]
		var _t1255 = (-1.0)
		J.sp(_t1254, "dir", _t1255)
		if J.cmp(J.gp(_s527["a"], "x"), J.sub(_s527["__p"]["door"], 30.0), ">"):
			var _t1256 = _s527["a"]
			var _t1257 = J.max_([J.sub(_s527["__p"]["door"], 30.0), J.sub(J.gp(_s527["a"], "x"), J.mul(v_spd_1367, _s527["__p"]["dt"]))])
			J.sp(_t1256, "x", _t1257)
			if J.t((J.cmp(J.cl(_s527["__p"]["__p"]["rnd"], null, []), J.mul(_s527["__p"]["dt"], 10.0), "<") if J.t(v_run_1366) else v_run_1366)):
				var _t1258 = _s527["__p"]["__p"]["part"]
				J.cl(_t1258, null, [J.add(J.gp(_s527["a"], "x"), 20.0), J.sub(J.gp(_s527["__p"]["lay"], "floor"), 6.0), 40.0, (-20.0), 0.5, "dust"])
		else:
			var _t1259 = _s527["a"]
			J.sp(_t1259, "hid", true)
		var _t1262 = (not J.seq(J.gp(v_r_1365, "state"), "home"))
		if J.t(_t1262):
			var _t1261 = J.gp(_s527["a"], "hid")
			if not J.t(_t1261):
				var _t1260 = (not J.seq(J.gp(v_r_1365, "state"), "flee"))
				_t1261 = ((not J.seq(J.gp(v_r_1365, "state"), "leave")) if _t1260 else _t1260)
			_t1262 = _t1261
		if J.t(_t1262):
			var _t1263 = _s527["a"]
			J.sp(_t1263, "gone", true)
			var _t1264 = J.seq(J.gp(v_r_1365, "state"), "flee")
			if (_t1264 if _t1264 else J.seq(J.gp(v_r_1365, "state"), "gone")):
				var _t1265 = _s527["__p"]["__p"]["iu"]
				var _t1266 = J.cl(_t1265, null, [_s527["__p"]["un"]])
				J.sp(_t1266, "fled", J.num(J.gp(_t1266, "fled")) + 1.0)
				var _t1267 = _s527["__p"]["__p"]["wfl"]
				J.cl(_t1267, null, [J.add(_s527["__p"]["door"], 60.0), (J.sub(J.gp(_s527["__p"]["lay"], "floor"), J.gp(_s527["__p"]["lay"], "ph")) - 40.0), "奔咗出屋！", "#b2d394"])
		return null
	var _t1268 = J.gp(v_r_1365, "react")
	if J.t(((not J.seq(J.gp(_s527["a"], "st"), "cower")) if J.t(_t1268) else _t1268)):
		var _t1269 = _s527["a"]
		J.sp(_t1269, "st", "cower")
		var _t1270 = _s527["a"]
		J.sp(_t1270, "cowT", 1.4)
	if J.seq(J.gp(_s527["a"], "st"), "cower"):
		var _t1271 = _s527["a"]
		var _t1272 = J.sub(J.gp(_t1271, "cowT"), _s527["__p"]["dt"])
		J.sp(_t1271, "cowT", _t1272)
		if J.cmp(J.gp(_s527["a"], "cowT"), 0.0, "<="):
			var _t1273 = _s527["a"]
			J.sp(_t1273, "st", "walk")
			if J.leq(J.gp(_s527["a"], "tx"), null):
				var _t1274 = _s527["__p"]["__p"]["pickAct"]
				J.cl(_t1274, null, [_s527["a"]])
		return null
	var _t1275 = (not J.t(J.gp(v_r_1365, "awake")))
	if ((not J.seq(J.gp(_s527["a"], "act"), "bed")) if _t1275 else _t1275):
		var _t1276 = _s527["__p"]["__p"]["pickAct"]
		J.cl(_t1276, null, [_s527["a"]])
	var _t1277 = J.gp(v_r_1365, "awake")
	if J.t((J.seq(J.gp(_s527["a"], "act"), "bed") if J.t(_t1277) else _t1277)):
		var _t1278 = _s527["__p"]["__p"]["pickAct"]
		J.cl(_t1278, null, [_s527["a"]])
		var _t1279 = _s527["a"]
		J.sp(_t1279, "pose", "stand")
	var _t1280 = J.seq(J.gp(_s527["a"], "st"), "walk")
	if (_t1280 if _t1280 else J.seq(J.gp(_s527["a"], "st"), "go")):
		v_d_1368 = J.sub(J.gp(_s527["a"], "tx"), J.gp(_s527["a"], "x"))
		v_w_1369 = ((150.0 if J.seq(J.gp(_s527["a"], "st"), "go") else 95.0) if J.t(J.gp(v_r_1365, "awake")) else 95.0)
		if (absf(J.num(v_d_1368)) < 3.0):
			var _t1281 = _s527["a"]
			var _t1282 = J.gp(_s527["a"], "tx")
			J.sp(_t1281, "x", _t1282)
			if J.seq(J.gp(_s527["a"], "st"), "go"):
				var _t1283 = _s527["a"]
				J.sp(_t1283, "st", "look")
				var _t1284 = _s527["a"]
				J.sp(_t1284, "lookT", 2.6)
				var _t1285 = _s527["a"]
				J.sp(_t1285, "pose", "stand")
			else:
				var _t1286 = _s527["a"]
				J.sp(_t1286, "st", "act")
				var _t1287 = _s527["a"]
				var _t1288 = _s527["__p"]["__p"]["actPose"]
				var _t1289 = J.cl(_t1288, null, [_s527["a"]])
				J.sp(_t1287, "pose", _t1289)
		else:
			var _t1290 = _s527["a"]
			var _t1291 = (1.0 if J.cmp(v_d_1368, 0.0, ">") else (-1.0))
			J.sp(_t1290, "dir", _t1291)
			var _t1292 = _s527["a"]
			var _t1293 = J.add(J.gp(_t1292, "x"), (signf(J.num(v_d_1368)) * J.min_([absf(J.num(v_d_1368)), J.mul(v_w_1369, _s527["__p"]["dt"])])))
			J.sp(_t1292, "x", _t1293)
			var _t1294 = _s527["a"]
			J.sp(_t1294, "pose", "stand")
	else:
		if J.seq(J.gp(_s527["a"], "st"), "look"):
			var _t1295 = _s527["a"]
			var _t1296 = J.sub(J.gp(_t1295, "lookT"), _s527["__p"]["dt"])
			J.sp(_t1295, "lookT", _t1296)
			var _t1297 = _s527["a"]
			var _t1298 = (1.0 if J.t(J.mod(floor(J.num(J.mul(J.gp(_s527["a"], "lookT"), 1.3))), 2.0)) else (-1.0))
			J.sp(_t1297, "dir", _t1298)
			if J.cmp(J.gp(_s527["a"], "lookT"), 0.0, "<="):
				var _t1299 = _s527["__p"]["__p"]["sayR"]
				var _t1300 = _s527["__p"]["__p"]["line"]
				J.cl(_t1299, null, [v_r_1365, J.cl(_t1300, null, ["look"])])
				var _t1301 = _s527["__p"]["__p"]["pickAct"]
				J.cl(_t1301, null, [_s527["a"]])
		else:
			if J.seq(J.gp(_s527["a"], "st"), "act"):
				var _t1302 = _s527["a"]
				var _t1303 = J.sub(J.gp(_t1302, "actT"), _s527["__p"]["dt"])
				J.sp(_t1302, "actT", _t1303)
				_s527["d0"] = J.gp(J.gp(_s527["__p"]["lay"], "acts"), J.gp(_s527["a"], "act"))
				if J.t((J.gp(_s527["d0"], "look") if J.t(_s527["d0"]) else _s527["d0"])):
					var _t1304 = J.gp(_s527["__p"]["__p"]["S"], "spots")
					v_sp_1371 = J.mc(_t1304, "find", [Callable(self, "_f238").bind(_s527)])
					if J.t(v_sp_1371):
						var _t1305 = _s527["a"]
						var _t1306 = (1.0 if J.cmp(J.gp(v_sp_1371, "x"), J.gp(_s527["a"], "x"), ">") else (-1.0))
						J.sp(_t1305, "dir", _t1306)
				if J.cmp(J.gp(_s527["a"], "actT"), 0.0, "<="):
					var _t1307 = _s527["__p"]["__p"]["pickAct"]
					J.cl(_t1307, null, [_s527["a"]])
	var _t1308 = _s527["__p"]["__p"]["roomAt"]
	_s527["ri"] = J.cl(_t1308, null, [J.gp(_s527["a"], "x")])
	var _t1309 = J.gp(v_r_1365, "awake")
	var _t1310 = ((not J.seq(J.gp(_s527["a"], "st"), "run")) if J.t(_t1309) else _t1309)
	var _t1311 = ((not J.t(J.gp(J.gp(_s527["__p"]["__p"]["S"], "light"), _s527["ri"]))) if J.t(_t1310) else _t1310)
	if J.t((J.cmp(J.gp(J.gp(_s527["__p"]["__p"]["S"], "dark"), _s527["ri"]), 0.0, "<=") if J.t(_t1311) else _t1311)):
		var _t1312 = J.gp(_s527["__p"]["__p"]["S"], "actors")
		v_sleepers_1373 = J.mc(_t1312, "some", [Callable(self, "_f239").bind(_s527)])
		var _t1316 = (not J.t(v_sleepers_1373))
		if (_t1316 if _t1316 else J.cmp(J.gp(_s527["__p"]["__p"]["S"], "alert"), 35.0, ">=")):
			if (not J.t(J.gp(_s527["a"], "lightT"))):
				var _t1317 = _s527["a"]
				J.sp(_t1317, "lightT", 1.4)
			else:
				if J.cmp(J.gp(_s527["a"], "lightT"), 0.05, "<="):
					var _t1318 = J.gp(_s527["__p"]["__p"]["S"], "light")
					var _t1319 = _s527["ri"]
					J.sp(_t1318, _t1319, true)
					var _t1320 = _s527["a"]
					J.sp(_t1320, "lightT", 0.0)
					var _t1321 = _s527["__p"]["__p"]["sayR"]
					var _t1322 = _s527["__p"]["__p"]["line"]
					J.cl(_t1321, null, [v_r_1365, J.cl(_t1322, null, ["lightOn"])])
					var _t1323 = _s527["__p"]["__p"]["tone"]
					J.cl(_t1323, null, [1200.0, 0.0, 0.05, 0.05, "square"])

func _f240(this_, a: Array, env):
	var v_a_1382 = null
	v_a_1382 = J.arg(a, 0)
	return (not J.t(J.gp(v_a_1382, "gone")))

func _f234(this_, a: Array, env):
	var v_g0_1353 = null
	var _s523 = {"__p": env, "dt": null, "lay": null, "un": null, "door": null}
	_s523["dt"] = J.arg(a, 0)
	_s523["lay"] = J.gp(_s523["__p"]["S"], "lay")
	_s523["un"] = J.gp(_s523["__p"]["S"], "un")
	_s523["door"] = J.gp(_s523["lay"], "door")
	v_g0_1353 = J.cl(_s523["__p"]["G"], null, [])
	var _t1234 = J.gp(_s523["un"], "rs")
	J.mc(_t1234, "forEach", [Callable(self, "_f235").bind(_s523)])
	var _t1243 = J.gp(_s523["__p"]["S"], "actors")
	J.mc(_t1243, "forEach", [Callable(self, "_f237").bind(_s523)])
	var _t1324 = _s523["__p"]["S"]
	var _t1325 = J.gp(_s523["__p"]["S"], "actors")
	var _t1326 = J.mc(_t1325, "filter", [Callable(self, "_f240").bind(_s523)])
	J.sp(_t1324, "actors", _t1326)

func _f243(this_, a: Array, env):
	var v_a_1394 = null
	v_a_1394 = J.arg(a, 0)
	var _t1332 = J.gp(J.gp(v_a_1394, "r"), "awake")
	var _t1334 = ((not J.seq(J.gp(v_a_1394, "st"), "run")) if J.t(_t1332) else _t1332)
	if J.t(_t1334):
		var _t1333 = env["__p"]["__p"]["roomAt"]
		_t1334 = J.seq(J.cl(_t1333, null, [J.gp(v_a_1394, "x")]), env["i"])
	return _t1334

func _f242(this_, a: Array, env):
	var v_on_1389 = null; var v_awake_1391 = null
	var _s554 = {"__p": env, "i": null}
	v_on_1389 = J.arg(a, 0)
	_s554["i"] = J.arg(a, 1)
	if J.cmp(J.gp(J.gp(_s554["__p"]["__p"]["S"], "dark"), _s554["i"]), 0.0, ">"):
		return false
	if J.t(_s554["__p"]["all"]):
		return true
	var _t1331 = J.gp(_s554["__p"]["__p"]["S"], "actors")
	v_awake_1391 = J.mc(_t1331, "some", [Callable(self, "_f243").bind(_s554)])
	var _t1335 = ((not J.t(v_awake_1391)) if J.t(v_on_1389) else v_on_1389)
	if J.t((J.cmp(J.gp(_s554["__p"]["__p"]["S"], "alert"), 35.0, "<") if J.t(_t1335) else _t1335)):
		var _t1336 = _s554["__p"]["__p"]["S"]
		var _t1337 = J.gp(_s554["__p"]["__p"]["S"], "offT")
		var _t1338 = (_t1337 if J.t(_t1337) else [])
		J.sp(_t1336, "offT", _t1338)
		var _t1339 = J.gp(_s554["__p"]["__p"]["S"], "offT")
		var _t1340 = _s554["i"]
		var _t1341 = J.gp(J.gp(_s554["__p"]["__p"]["S"], "offT"), _s554["i"])
		var _t1342 = J.add((_t1341 if J.t(_t1341) else 0.0), _s554["__p"]["dt"])
		J.sp(_t1339, _t1340, _t1342)
		if J.cmp(J.gp(J.gp(_s554["__p"]["__p"]["S"], "offT"), _s554["i"]), 8.0, ">"):
			var _t1343 = J.gp(_s554["__p"]["__p"]["S"], "offT")
			var _t1344 = _s554["i"]
			J.sp(_t1343, _t1344, 0.0)
			return false
	else:
		if J.t(J.gp(_s554["__p"]["__p"]["S"], "offT")):
			var _t1345 = J.gp(_s554["__p"]["__p"]["S"], "offT")
			var _t1346 = _s554["i"]
			J.sp(_t1345, _t1346, 0.0)
	return v_on_1389

func _f241(this_, a: Array, env):
	var _s553 = {"__p": env, "dt": null, "all": null}
	_s553["dt"] = J.arg(a, 0)
	var _t1328 = J.cmp(J.gp(_s553["__p"]["S"], "alert"), 85.0, ">=")
	if not J.t(_t1328):
		var _t1327 = _s553["__p"]["iu"]
		_t1328 = J.gp(J.cl(_t1327, null, [J.gp(_s553["__p"]["S"], "un")]), "lights")
	_s553["all"] = _t1328
	var _t1329 = _s553["__p"]["S"]
	var _t1330 = J.gp(_s553["__p"]["S"], "light")
	var _t1347 = J.mc(_t1330, "map", [Callable(self, "_f242").bind(_s553)])
	J.sp(_t1329, "light", _t1347)

func _f244(this_, a: Array, env):
	var v_a_1397 = null; var v_x_1398 = null
	v_a_1397 = J.arg(a, 0)
	v_x_1398 = J.arg(a, 1)
	var _t1348 = J.seq(signf(J.num(J.sub(v_x_1398, J.gp(v_a_1397, "x")))), J.gp(v_a_1397, "dir"))
	return (_t1348 if _t1348 else (absf(J.num(J.sub(v_x_1398, J.gp(v_a_1397, "x")))) < 70.0))

func _f246(this_, a: Array, env):
	var v_a_1410 = null; var v_r_1411 = null; var v_dx_1412 = null; var v_f_1413 = null; var v_rate_1414 = null
	v_a_1410 = J.arg(a, 0)
	v_r_1411 = J.gp(v_a_1410, "r")
	var _t1351 = (not J.t(J.gp(v_r_1411, "awake")))
	var _t1352 = (_t1351 if _t1351 else J.seq(J.gp(v_a_1410, "st"), "run"))
	var _t1354 = (_t1352 if _t1352 else J.seq(J.gp(v_a_1410, "st"), "cower"))
	if not J.t(_t1354):
		var _t1353 = J.seq(J.gp(v_a_1410, "act"), "shower")
		_t1354 = (J.seq(J.gp(v_a_1410, "st"), "act") if _t1353 else _t1353)
	if (_t1354 if _t1354 else J.seq(J.gp(v_a_1410, "act"), "bed")):
		return null
	var _t1355 = env["__p"]["roomAt"]
	if (not J.seq(J.cl(_t1355, null, [J.gp(v_a_1410, "x")]), env["gr"])):
		return null
	v_dx_1412 = absf(J.num(J.sub(J.gp(env["__p"]["S"], "gx"), J.gp(v_a_1410, "x"))))
	var _t1356 = env["__p"]["facing"]
	v_f_1413 = J.cl(_t1356, null, [v_a_1410, J.gp(env["__p"]["S"], "gx")])
	var _t1359 = J.seq(J.gp(v_a_1410, "st"), "act")
	if J.t(_t1359):
		var _t1357 = J.seq(J.gp(v_a_1410, "act"), "tv")
		var _t1358 = (_t1357 if _t1357 else J.seq(J.gp(v_a_1410, "act"), "pc"))
		_t1359 = (_t1358 if _t1358 else J.seq(J.gp(v_a_1410, "act"), "radio"))
	if (J.cmp(v_dx_1412, 70.0, ">=") if _t1359 else _t1359):
		v_f_1413 = false
	v_rate_1414 = 0.0
	if J.t((v_f_1413 if J.t(env["lit"]) else env["lit"])):
		v_rate_1414 = env["__p"]["SEE_LIT"]
	else:
		var _t1360 = (not J.t(env["lit"]))
		var _t1361 = (v_f_1413 if _t1360 else _t1360)
		if J.t((J.cmp(v_dx_1412, 110.0, "<") if J.t(_t1361) else _t1361)):
			v_rate_1414 = env["__p"]["SEE_DARK"]
	if (not J.t(v_rate_1414)):
		return null
	var _t1363 = (1.0 + (0.15 * J.min_([3.0, J.gp(env["g0"], "phase")])))
	var _t1362 = J.gp(v_r_1411, "brave")
	var _t1364 = J.mul(v_rate_1414, J.mul(_t1363, J.add(1.0, (_t1362 if J.t(_t1362) else 0.0))))
	v_rate_1414 = _t1364
	env["any"] = true
	var _t1365 = J.min_([3.0, J.add(J.gp(v_a_1410, "seeT"), J.mul(env["dt"], 1.5))])
	J.sp(v_a_1410, "seeT", _t1365)
	var _t1366 = J.cmp(J.gp(v_a_1410, "seeT"), 0.8, ">")
	if ((not J.t(J.gp(v_a_1410, "saw"))) if _t1366 else _t1366):
		J.sp(v_a_1410, "saw", true)
		var _t1367 = env["__p"]["sayR"]
		var _t1368 = env["__p"]["line"]
		J.cl(_t1367, null, [v_r_1411, J.cl(_t1368, null, ["see"])])
		J.mc(env["__p"]["SND"], "see", [])
		var _t1369 = env["__p"]["wfl"]
		J.cl(_t1369, null, [J.gp(v_a_1410, "x"), J.sub(J.gp(J.gp(env["__p"]["S"], "lay"), "floor"), J.mul(J.gp(J.gp(env["__p"]["S"], "lay"), "ph"), 1.15)), "！被睇到", "#e48a78"])
	if J.cmp(J.gp(v_a_1410, "seeT"), 0.8, ">"):
		J.mc(env["rates"], "push", [v_rate_1414])

func _f247(this_, a: Array, env):
	var v_a_1417 = null; var v_b_1418 = null
	v_a_1417 = J.arg(a, 0)
	v_b_1418 = J.arg(a, 1)
	return J.sub(v_b_1418, v_a_1417)

func _f248(this_, a: Array, env):
	var v_v_1421 = null; var v_i_1422 = null
	v_v_1421 = J.arg(a, 0)
	v_i_1422 = J.arg(a, 1)
	var _t1370 = env["__p"]["S"]
	var _t1371 = J.add(J.gp(_t1370, "alert"), J.mul((J.mul(v_v_1421, 0.25) if J.t(v_i_1422) else v_v_1421), env["dt"]))
	J.sp(_t1370, "alert", _t1371)

func _f249(this_, a: Array, env):
	var v_a_1425 = null
	v_a_1425 = J.arg(a, 0)
	if J.cmp(J.gp(v_a_1425, "seeT"), 0.1, "<"):
		J.sp(v_a_1425, "saw", false)

func _f245(this_, a: Array, env):
	var v_I_1407 = null
	var _s559 = {"__p": env, "dt": null, "g0": null, "gr": null, "lit": null, "any": null, "rates": null}
	_s559["dt"] = J.arg(a, 0)
	_s559["g0"] = J.cl(_s559["__p"]["G"], null, [])
	var _t1349 = _s559["__p"]["roomAt"]
	_s559["gr"] = J.cl(_t1349, null, [J.gp(_s559["__p"]["S"], "gx")])
	_s559["lit"] = J.gp(J.gp(_s559["__p"]["S"], "light"), _s559["gr"])
	_s559["any"] = false
	_s559["rates"] = []
	if J.cmp(J.gp(_s559["__p"]["S"], "invT"), 0.0, "<="):
		var _t1350 = J.gp(_s559["__p"]["S"], "actors")
		J.mc(_t1350, "forEach", [Callable(self, "_f246").bind(_s559)])
	J.mc(_s559["rates"], "sort", [Callable(self, "_f247").bind(_s559)])
	J.mc(_s559["rates"], "forEach", [Callable(self, "_f248").bind(_s559)])
	var _t1372 = _s559["__p"]["S"]
	var _t1373 = _s559["any"]
	J.sp(_t1372, "seenNow", _t1373)
	if J.t(_s559["any"]):
		var _t1374 = _s559["__p"]["S"]
		J.sp(_t1374, "calmT", 0.0)
	else:
		var _t1375 = _s559["__p"]["S"]
		var _t1376 = J.add(J.gp(_t1375, "calmT"), _s559["dt"])
		J.sp(_t1375, "calmT", _t1376)
		var _t1377 = J.gp(_s559["__p"]["S"], "actors")
		J.mc(_t1377, "forEach", [Callable(self, "_f249").bind(_s559)])
	var _t1378 = J.cmp(J.gp(_s559["__p"]["S"], "calmT"), 5.0, ">")
	if (J.cmp(J.gp(_s559["__p"]["S"], "alert"), 0.0, ">") if _t1378 else _t1378):
		var _t1379 = _s559["__p"]["iu"]
		v_I_1407 = J.cl(_t1379, null, [J.gp(_s559["__p"]["S"], "un")])
		var _t1380 = _s559["__p"]["S"]
		var _t1381 = J.max_([(30.0 if J.t(J.gp(v_I_1407, "lights")) else 0.0), J.sub(J.gp(_s559["__p"]["S"], "alert"), J.mul(2.5, _s559["dt"]))])
		J.sp(_t1380, "alert", _t1381)

func _f251(this_, a: Array, env):
	var v_a_1435 = null
	v_a_1435 = J.arg(a, 0)
	var _t1384 = J.gp(J.gp(v_a_1435, "r"), "awake")
	return ((not J.seq(J.gp(v_a_1435, "st"), "run")) if J.t(_t1384) else _t1384)

func _f252(this_, a: Array, env):
	var v_a_1438 = null
	v_a_1438 = J.arg(a, 0)
	return (not J.t(J.gp(J.gp(v_a_1438, "r"), "awake")))

func _f253(this_, a: Array, env):
	var v_a_1441 = null
	v_a_1441 = J.arg(a, 0)
	var _t1399 = J.gp(v_a_1441, "r")
	J.sp(_t1399, "awake", true)
	var _t1400 = J.gp(v_a_1441, "r")
	J.sp(_t1400, "woke", true)
	var _t1401 = J.gp(v_a_1441, "r")
	var _t1402 = J.gp(J.gp(v_a_1441, "r"), "fear")
	var _t1403 = J.gp(J.gp(v_a_1441, "r"), "fear")
	var _t1404 = J.min_([95.0, J.add((_t1403 if J.t(_t1403) else 0.0), 8.0)])
	J.sp(_t1401, "fear", _t1404)

func _f250(this_, a: Array, env):
	var v_dt_1428 = null; var v_I_1429 = null; var v_g0_1430 = null; var v_aw_1431 = null; var v_sl_1432 = null; var v_e_1442 = null
	v_dt_1428 = J.arg(a, 0)
	var _t1382 = env["iu"]
	v_I_1429 = J.cl(_t1382, null, [J.gp(env["S"], "un")])
	v_g0_1430 = J.cl(env["G"], null, [])
	var _t1383 = J.gp(env["S"], "actors")
	v_aw_1431 = J.mc(_t1383, "filter", [Callable(self, "_f251").bind(env)])
	var _t1385 = J.cmp(J.gp(env["S"], "alert"), 35.0, ">=")
	var _t1386 = ((not J.t(J.gp(J.gp(env["S"], "flags"), "t35"))) if _t1385 else _t1385)
	if J.t((J.len(v_aw_1431) if _t1386 else _t1386)):
		var _t1387 = J.gp(env["S"], "flags")
		J.sp(_t1387, "t35", 1.0)
		var _t1388 = env["sayR"]
		J.cl(_t1388, null, [J.gp(J.gp(v_aw_1431, 0.0), "r"), "開燈！全部開燈先！"])
		var _t1390 = J.gp(env["S"], "light")
		var _t1389 = env["roomAt"]
		var _t1391 = J.cl(_t1389, null, [J.gp(J.gp(v_aw_1431, 0.0), "x")])
		J.sp(_t1390, _t1391, true)
	var _t1392 = J.cmp(J.gp(env["S"], "alert"), 55.0, ">=")
	var _t1393 = ((not J.t(J.gp(J.gp(env["S"], "flags"), "t55"))) if _t1392 else _t1392)
	if J.t((J.len(v_aw_1431) if _t1393 else _t1393)):
		var _t1394 = J.gp(env["S"], "flags")
		J.sp(_t1394, "t55", 1.0)
		var _t1395 = J.gp(env["S"], "actors")
		v_sl_1432 = J.mc(_t1395, "filter", [Callable(self, "_f252").bind(env)])
		if J.t(J.len(v_sl_1432)):
			var _t1396 = env["sayR"]
			var _t1398 = J.gp(J.gp(v_aw_1431, 0.0), "r")
			var _t1397 = env["line"]
			J.cl(_t1396, null, [_t1398, J.cl(_t1397, null, ["wake"])])
			J.mc(v_sl_1432, "forEach", [Callable(self, "_f253").bind(env)])
			var _t1405 = env["msg"]
			J.cl(_t1405, null, ["有人叫醒晒全屋人！", "#e48a78"])
	var _t1406 = J.cmp(J.gp(env["S"], "alert"), 70.0, ">=")
	var _t1407 = ((not J.t(J.gp(v_I_1429, "phoned"))) if _t1406 else _t1406)
	if J.t((J.len(v_aw_1431) if _t1407 else _t1407)):
		J.sp(v_I_1429, "phoned", true)
		var _t1408 = env["sayR"]
		var _t1410 = J.gp(J.gp(v_aw_1431, 0.0), "r")
		var _t1409 = env["line"]
		J.cl(_t1408, null, [_t1410, J.cl(_t1409, null, ["phone"])])
		var _t1411 = J.add(J.gp(v_g0_1430, "alert"), 1.0)
		J.sp(v_g0_1430, "alert", _t1411)
		J.mc(env["A"], "checkAlert", [])
		J.mc(env["A"], "noise", [J.gp(J.gp(env["S"], "un"), "did"), 2.0])
		var _t1412 = env["msg"]
		J.cl(_t1412, null, ["住客打電話去管理處！全樓警覺 +1，保安會去門口睇", "#e48a78"])
	var _t1413 = J.cmp(J.gp(env["S"], "alert"), 85.0, ">=")
	if ((not J.t(J.gp(J.gp(env["S"], "flags"), "t85"))) if _t1413 else _t1413):
		var _t1414 = J.gp(env["S"], "flags")
		J.sp(_t1414, "t85", 1.0)
		J.sp(v_I_1429, "lights", true)
		if J.t(J.len(v_aw_1431)):
			var _t1415 = env["sayR"]
			var _t1417 = J.gp(J.gp(v_aw_1431, 0.0), "r")
			var _t1416 = env["line"]
			J.cl(_t1415, null, [_t1417, J.cl(_t1416, null, ["lights"])])
		var _t1418 = env["msg"]
		J.cl(_t1418, null, ["佢哋開晒全屋燈！行邊度都會現形", "#e48a78"])

func _f255(this_, a: Array, env):
	var v_a_1456 = null; var v_r_1457 = null; var v_ar_1458 = null; var v_same_1459 = null; var v_adj_1460 = null; var v_amt_1461 = null
	v_a_1456 = J.arg(a, 0)
	v_r_1457 = J.gp(v_a_1456, "r")
	var _t1443 = (not J.seq(J.gp(v_r_1457, "state"), "home"))
	if (_t1443 if _t1443 else J.seq(J.gp(v_a_1456, "st"), "run")):
		return null
	var _t1444 = env["__p"]["roomAt"]
	v_ar_1458 = J.cl(_t1444, null, [J.gp(v_a_1456, "x")])
	v_same_1459 = J.seq(v_ar_1458, env["rm"])
	v_adj_1460 = J.seq(absf(J.num(J.sub(v_ar_1458, env["rm"]))), 1.0)
	var _t1446 = (not J.t(v_same_1459))
	if J.t(_t1446):
		var _t1445 = J.gp(env["H"], "loud")
		_t1446 = (not J.t((v_adj_1460 if J.t(_t1445) else _t1445)))
	if _t1446:
		return null
	v_amt_1461 = J.mul(J.gp(env["H"], "f"), (1.0 if J.t(v_same_1459) else 0.35))
	var _t1447 = (v_same_1459 if J.t(env["media"]) else env["media"])
	var _t1449 = (J.seq(J.gp(v_a_1456, "st"), "act") if J.t(_t1447) else _t1447)
	if J.t(_t1449):
		var _t1448 = J.gp(J.gp(J.gp(env["__p"]["S"], "lay"), "acts"), J.gp(v_a_1456, "act"))
		_t1449 = J.seq(J.gp((_t1448 if J.t(_t1448) else {}), "look"), J.gp(env["p"], "k"))
	if J.t(_t1449):
		var _t1450 = J.gp(env["__p"]["S"], "task")
		J.sp(_t1450, "done", true)
		J.cl(env["__p"]["taskDone"], null, [])
	if (not J.t(J.gp(v_r_1457, "awake"))):
		var _t1451 = (not J.t(J.gp(env["H"], "loud")))
		if ((not J.t(v_same_1459)) if _t1451 else _t1451):
			return null
		J.sp(v_r_1457, "awake", true)
		J.sp(v_r_1457, "woke", true)
		var _t1452 = J.mul(v_amt_1461, 0.6)
		v_amt_1461 = _t1452
		var _t1453 = env["__p"]["sayR"]
		var _t1454 = env["__p"]["pick"]
		J.cl(_t1453, null, [v_r_1457, J.cl(_t1454, null, [["咩聲呀……邊個？", "發開夢？"]])])
	else:
		var _t1455 = env["__p"]["sayR"]
		var _t1456 = env["__p"]["pick"]
		J.cl(_t1455, null, [v_r_1457, J.cl(_t1456, null, [J.gp(env["H"], "ln")])])
	var _t1457 = env["__p"]["addRFear"]
	J.cl(_t1457, null, [v_a_1456, v_amt_1461])
	env["hit"] = J.num(env["hit"]) + 1.0
	var _t1458 = (not J.t(v_same_1459))
	var _t1459 = ((not J.seq(J.gp(v_a_1456, "st"), "go")) if _t1458 else _t1458)
	if (J.cmp(J.cl(env["__p"]["rnd"], null, []), 0.6, "<") if _t1459 else _t1459):
		J.sp(v_a_1456, "st", "go")
		var _t1460 = env["__p"]["clamp"]
		var _t1461 = J.cl(_t1460, null, [J.add(J.gp(env["p"], "x"), (J.sub(J.cl(env["__p"]["rnd"], null, []), 0.5) * 60.0)), J.add(J.gp(J.gp(J.gp(J.gp(env["__p"]["S"], "lay"), "rooms"), env["rm"]), "x0"), 30.0), J.sub(J.gp(J.gp(J.gp(J.gp(env["__p"]["S"], "lay"), "rooms"), env["rm"]), "x1"), 30.0)])
		J.sp(v_a_1456, "tx", _t1461)
		var _t1462 = env["__p"]["sayR"]
		var _t1463 = env["__p"]["line"]
		J.cl(_t1462, null, [v_r_1457, J.cl(_t1463, null, ["go"])])
	var _t1464 = env["__p"]["roomTask"]
	J.cl(_t1464, null, [v_a_1456])

func _f254(this_, a: Array, env):
	var v_auto_1446 = null; var v_g0_1447 = null; var v_g_1448 = null; var v_i_1453 = null
	var _s579 = {"__p": env, "p": null, "H": null, "hit": null, "rm": null, "media": null}
	_s579["p"] = J.arg(a, 0)
	v_auto_1446 = J.arg(a, 1)
	v_g0_1447 = J.cl(_s579["__p"]["G"], null, [])
	v_g_1448 = J.gp(_s579["__p"]["S"], "g")
	_s579["H"] = J.gp(_s579["__p"]["HOT"], J.gp(_s579["p"], "k"))
	if J.cmp(J.gp(_s579["p"], "cd"), 0.0, ">"):
		if (not J.t(v_auto_1446)):
			var _t1419 = _s579["__p"]["wfl"]
			J.cl(_t1419, null, [J.gp(_s579["p"], "x"), J.sub(J.gp(_s579["p"], "y"), 40.0), (J.add(J.add(J.gp(_s579["H"], "v"), "冷卻緊 "), ceil(J.num(J.gp(_s579["p"], "cd")))) + " 秒"), "#ddd2bd"])
		return false
	var _t1420 = _s579["__p"]["roomAt"]
	var _t1421 = (not J.seq(J.cl(_t1420, null, [J.gp(_s579["__p"]["S"], "gx")]), J.gp(_s579["p"], "room")))
	if (_t1421 if _t1421 else J.cmp(absf(J.num(J.sub(J.gp(_s579["__p"]["S"], "gx"), J.gp(_s579["p"], "x")))), _s579["__p"]["RANGE_HOT"], ">")):
		var _t1422 = _s579["__p"]["S"]
		var _t1423 = _s579["__p"]["clamp"]
		var _t1424 = J.cl(_t1423, null, [J.gp(_s579["p"], "x"), J.add(J.gp(J.gp(J.gp(J.gp(_s579["__p"]["S"], "lay"), "rooms"), J.gp(_s579["p"], "room")), "x0"), 20.0), J.sub(J.gp(J.gp(J.gp(J.gp(_s579["__p"]["S"], "lay"), "rooms"), J.gp(_s579["p"], "room")), "x1"), 20.0)])
		J.sp(_t1422, "goX", _t1424)
		var _t1425 = _s579["__p"]["S"]
		var _t1426 = {"k": "hot", "p": _s579["p"]}
		J.sp(_t1425, "pend", _t1426)
		return false
	if J.cmp(J.gp(_s579["__p"]["S"], "stun"), 0.0, ">"):
		return false
	var _t1427 = _s579["p"]
	J.sp(_t1427, "cd", 14.0)
	var _t1428 = _s579["p"]
	J.sp(_t1428, "t", 2.6)
	var _t1429 = _s579["__p"]["S"]
	var _t1430 = (1.0 if J.cmp(J.gp(_s579["p"], "x"), J.gp(_s579["__p"]["S"], "gx"), ">") else (-1.0))
	J.sp(_t1429, "gdir", _t1430)
	var _t1431 = _s579["__p"]["S"]
	var _t1432 = J.add(J.gp(_t1431, "alert"), 4.0)
	J.sp(_t1431, "alert", _t1432)
	var _t1433 = _s579["__p"]["S"]
	J.sp(_t1433, "calmT", 0.0)
	J.mc(_s579["__p"]["SND"], "hot", [J.gp(_s579["p"], "k")])
	var _t1434 = _s579["__p"]["wfl"]
	J.cl(_t1434, null, [J.gp(_s579["p"], "x"), J.sub(J.gp(_s579["p"], "y"), 50.0), J.add(J.gp(_s579["H"], "v"), "！"), "#e8a088"])
	if J.seq(J.gp(_s579["p"], "k"), "lamp"):
		var _t1435 = J.gp(_s579["__p"]["S"], "dark")
		var _t1436 = J.gp(_s579["p"], "room")
		J.sp(_t1435, _t1436, 15.0)
		var _t1437 = J.gp(_s579["__p"]["S"], "light")
		var _t1438 = J.gp(_s579["p"], "room")
		J.sp(_t1437, _t1438, false)
		var _t1439 = _s579["__p"]["S"]
		J.sp(_t1439, "flash", 0.4)
	_s579["hit"] = 0.0
	_s579["rm"] = J.gp(_s579["p"], "room")
	var _t1440 = J.seq(J.gp(J.gp(_s579["__p"]["S"], "task"), "k"), "media")
	var _t1441 = (J.seq(J.gp(_s579["p"], "k"), J.gp(J.gp(_s579["__p"]["S"], "task"), "spot")) if _t1440 else _t1440)
	_s579["media"] = ((not J.t(J.gp(J.gp(_s579["__p"]["S"], "task"), "done"))) if _t1441 else _t1441)
	var _t1442 = J.gp(_s579["__p"]["S"], "actors")
	J.mc(_t1442, "forEach", [Callable(self, "_f255").bind(_s579)])
	if J.t(_s579["hit"]):
		J.mc(_s579["__p"]["A"], "addFear", [2.0, J.gp(J.gp(_s579["__p"]["S"], "un"), "x"), J.sub(J.gp(J.gp(_s579["__p"]["S"], "un"), "y"), 100.0)])
		var _t1465 = J.gp(v_g_1448, "energy")
		var _t1466 = J.gp(v_g_1448, "energy")
		var _t1467 = J.min_([100.0, J.add((_t1466 if J.t(_t1466) else 0.0), 6.0)])
		J.sp(v_g_1448, "energy", _t1467)
	v_i_1453 = 0.0
	while true:
		if not J.cmp(v_i_1453, 8.0, "<"): break
		var _t1468 = _s579["__p"]["part"]
		var _t1471 = J.add(J.gp(_s579["p"], "x"), (J.sub(J.cl(_s579["__p"]["rnd"], null, []), 0.5) * 40.0))
		var _t1472 = J.add(J.gp(_s579["p"], "y"), (J.sub(J.cl(_s579["__p"]["rnd"], null, []), 0.5) * 30.0))
		var _t1473 = (J.sub(J.cl(_s579["__p"]["rnd"], null, []), 0.5) * 120.0)
		var _t1474 = ((-60.0) - J.mul(J.cl(_s579["__p"]["rnd"], null, []), 60.0))
		var _t1469 = J.seq(J.gp(_s579["p"], "k"), "tap")
		var _t1470 = (_t1469 if _t1469 else J.seq(J.gp(_s579["p"], "k"), "shower"))
		J.cl(_t1468, null, [_t1471, _t1472, _t1473, _t1474, 0.8, ("drop" if (_t1470 if _t1470 else J.seq(J.gp(_s579["p"], "k"), "jar")) else "spark")])
		v_i_1453 = J.num(v_i_1453) + 1.0
	return true

func _f256(this_, a: Array, env):
	var v_a_1464 = null; var v_amt_1465 = null; var v_r_1466 = null; var v_g0_1467 = null
	v_a_1464 = J.arg(a, 0)
	v_amt_1465 = J.arg(a, 1)
	v_r_1466 = J.gp(v_a_1464, "r")
	v_g0_1467 = J.cl(env["G"], null, [])
	var _t1475 = J.gp(v_r_1466, "fear")
	var _t1478 = (_t1475 if J.t(_t1475) else 0.0)
	var _t1477 = J.mul(J.mul(v_amt_1465, J.gp(J.gp(v_g0_1467, "mods"), "pow")), (J.mc(env["A"], "gpF", [J.gp(env["S"], "g")]) if J.t(J.gp(env["A"], "gpF")) else 1.0))
	var _t1476 = J.gp(v_r_1466, "brave")
	var _t1479 = J.add(_t1478, (_t1477 * J.sub(1.0, (_t1476 if J.t(_t1476) else 0.0))))
	J.sp(v_r_1466, "fear", _t1479)
	var _t1480 = J.cmp(J.gp(v_r_1466, "fear"), 100.0, ">=")
	var _t1481 = ((not J.cmp(J.gp(v_r_1466, "fleeAfter"), 0.0, ">")) if _t1480 else _t1480)
	if (J.seq(J.gp(v_r_1466, "state"), "home") if _t1481 else _t1481):
		J.sp(v_r_1466, "fleeAfter", 0.9)
		var _t1482 = J.gp(env["S"], "g")
		J.sp(v_r_1466, "fleeG", _t1482)

func _f257(this_, a: Array, env):
	var v_a_1470 = null; var v_T_1471 = null; var v_R_1472 = null
	v_a_1470 = J.arg(a, 0)
	v_T_1471 = J.gp(env["S"], "task")
	var _t1483 = (not J.seq(J.gp(v_T_1471, "k"), "room"))
	if J.t((_t1483 if _t1483 else J.gp(v_T_1471, "done"))):
		return null
	var _t1485 = J.gp(J.gp(env["S"], "lay"), "rooms")
	var _t1484 = env["roomAt"]
	v_R_1472 = J.gp(_t1485, J.cl(_t1484, null, [J.gp(v_a_1470, "x")]))
	var _t1487 = J.seq(J.gp(v_R_1472, "k"), J.gp(v_T_1471, "room"))
	if J.t(_t1487):
		var _t1486 = J.seq(J.gp(v_a_1470, "act"), J.gp(v_T_1471, "act"))
		_t1487 = (_t1486 if _t1486 else J.seq(J.gp(v_a_1470, "prevAct"), J.gp(v_T_1471, "act")))
	var _t1489 = _t1487
	if J.t(_t1489):
		var _t1488 = J.seq(J.gp(v_a_1470, "st"), "act")
		_t1489 = (_t1488 if _t1488 else J.seq(J.gp(v_a_1470, "st"), "cower"))
	if _t1489:
		J.sp(v_T_1471, "done", true)
		J.cl(env["taskDone"], null, [])

func _f258(this_, a: Array, env):
	var v_g_1475 = null; var v_g0_1476 = null; var v_I_1477 = null
	v_g_1475 = J.gp(env["S"], "g")
	v_g0_1476 = J.cl(env["G"], null, [])
	var _t1490 = env["iu"]
	v_I_1477 = J.cl(_t1490, null, [J.gp(env["S"], "un")])
	if J.t(J.gp(v_I_1477, "done")):
		return null
	J.sp(v_I_1477, "done", true)
	var _t1491 = J.gp(env["S"], "task")
	J.sp(_t1491, "done", true)
	J.mc(env["A"], "addFear", [J.round(J.num(J.mul(20.0, J.gp(J.gp(v_g0_1476, "mods"), "fear")))), J.gp(J.gp(env["S"], "un"), "x"), J.sub(J.gp(J.gp(env["S"], "un"), "y"), 110.0)])
	var _t1492 = J.gp(v_g_1475, "energy")
	var _t1493 = J.gp(v_g_1475, "energy")
	var _t1494 = J.min_([100.0, J.add((_t1493 if J.t(_t1493) else 0.0), 30.0)])
	J.sp(v_g_1475, "energy", _t1494)
	var _t1495 = J.gp(v_g0_1476, "unitCoins")
	var _t1496 = J.add((_t1495 if J.t(_t1495) else 0.0), 15.0)
	J.sp(v_g0_1476, "unitCoins", _t1496)
	var _t1497 = J.gp(v_g0_1476, "unitTasks")
	var _t1498 = J.add((_t1497 if J.t(_t1497) else 0.0), 1.0)
	J.sp(v_g0_1476, "unitTasks", _t1498)
	J.mc(env["A"], "takeItem", [v_g_1475, "doll", J.gp(env["S"], "un")])
	var _t1499 = env["msg"]
	J.cl(_t1499, null, [(J.add("屋內任務完成：", J.gp(J.gp(env["S"], "task"), "t")) + "——怕意 +20、能量 +30、替身紙人 +1、冥幣 +15"), "#b2d394"])
	var _t1500 = env["S"]
	J.sp(_t1500, "msgT", 4.5)
	var _t1501 = env["wfl"]
	J.cl(_t1501, null, [J.gp(env["S"], "gx"), (J.sub(J.gp(J.gp(env["S"], "lay"), "floor"), J.gp(J.gp(env["S"], "lay"), "ph")) - 60.0), "任務完成！", "#b2d394"])
	var _t1502 = env["tone"]
	J.cl(_t1502, null, [523.0, 0.0, 0.3, 0.08])
	var _t1503 = env["tone"]
	J.cl(_t1503, null, [784.0, 0.15, 0.5, 0.08])

func _f260(this_, a: Array, env):
	var v_r_1484 = null
	v_r_1484 = J.arg(a, 0)
	var _t1504 = J.seq(J.gp(v_r_1484, "state"), "flee")
	return (_t1504 if _t1504 else J.seq(J.gp(v_r_1484, "state"), "gone"))

func _f259(this_, a: Array, env):
	var v_T_1480 = null; var v_rs_1481 = null
	v_T_1480 = J.gp(env["S"], "task")
	if J.t(J.gp(v_T_1480, "done")):
		return null
	if J.seq(J.gp(v_T_1480, "k"), "allout"):
		v_rs_1481 = J.gp(J.gp(env["S"], "un"), "rs")
		var _t1505 = J.len(v_rs_1481)
		var _t1507 = (J.mc(v_rs_1481, "every", [Callable(self, "_f260").bind(env)]) if J.t(_t1505) else _t1505)
		if J.t(_t1507):
			var _t1506 = env["iu"]
			_t1507 = J.cmp(J.gp(J.cl(_t1506, null, [J.gp(env["S"], "un")]), "fled"), 0.0, ">")
		if J.t(_t1507):
			J.sp(v_T_1480, "done", true)
			J.cl(env["taskDone"], null, [])

func _f262(this_, a: Array, env):
	var v_a_1493 = null; var v_d_1494 = null
	v_a_1493 = J.arg(a, 0)
	var _t1510 = (not J.seq(J.gp(J.gp(v_a_1493, "r"), "state"), "home"))
	var _t1511 = (_t1510 if _t1510 else J.seq(J.gp(v_a_1493, "st"), "run"))
	if (_t1511 if _t1511 else J.cmp(J.gp(J.gp(v_a_1493, "r"), "fleeAfter"), 0.0, ">")):
		return null
	v_d_1494 = absf(J.num(J.sub(J.gp(v_a_1493, "x"), J.gp(env["__p"]["S"], "gx"))))
	var _t1512 = env["__p"]["roomAt"]
	var _t1513 = (not J.seq(J.cl(_t1512, null, [J.gp(v_a_1493, "x")]), env["gr"]))
	if (J.cmp(v_d_1494, 90.0, ">") if _t1513 else _t1513):
		return null
	if J.cmp(v_d_1494, env["bd"], "<"):
		env["bd"] = v_d_1494
		env["best"] = v_a_1493

func _f261(this_, a: Array, env):
	var v_range_1487 = null
	var _s598 = {"__p": env, "gr": null, "best": null, "bd": null}
	v_range_1487 = J.arg(a, 0)
	var _t1508 = _s598["__p"]["roomAt"]
	_s598["gr"] = J.cl(_t1508, null, [J.gp(_s598["__p"]["S"], "gx")])
	_s598["best"] = null
	_s598["bd"] = v_range_1487
	var _t1509 = J.gp(_s598["__p"]["S"], "actors")
	J.mc(_t1509, "forEach", [Callable(self, "_f262").bind(_s598)])
	return _s598["best"]

func _f263(this_, a: Array, env):
	var v_a_1497 = null
	v_a_1497 = J.arg(a, 0)
	var _t1514 = (not J.t(v_a_1497))
	if (_t1514 if _t1514 else (not J.seq(J.gp(J.gp(v_a_1497, "r"), "state"), "home"))):
		return null
	var _t1519 = J.cmp(absf(J.num(J.sub(J.gp(v_a_1497, "x"), J.gp(env["S"], "gx")))), env["RANGE_SCARE"], ">")
	if not J.t(_t1519):
		var _t1515 = env["roomAt"]
		var _t1517 = J.cl(_t1515, null, [J.gp(v_a_1497, "x")])
		var _t1516 = env["roomAt"]
		var _t1518 = (not J.seq(_t1517, J.cl(_t1516, null, [J.gp(env["S"], "gx")])))
		_t1519 = ((absf(J.num(J.sub(J.gp(v_a_1497, "x"), J.gp(env["S"], "gx")))) > 90.0) if _t1518 else _t1518)
	if _t1519:
		var _t1520 = env["S"]
		var _t1521 = J.add(J.gp(v_a_1497, "x"), ((-80.0) if J.cmp(J.gp(v_a_1497, "x"), J.gp(env["S"], "gx"), ">") else 80.0))
		J.sp(_t1520, "goX", _t1521)
		var _t1522 = env["S"]
		var _t1523 = {"k": "scare", "a": v_a_1497}
		J.sp(_t1522, "pend", _t1523)
		return null
	J.mc(env["U"], "scare", [v_a_1497])

func _f265(this_, a: Array, env):
	var v_sc_1506 = null; var v_a_1507 = null; var v_r_1508 = null; var v_g_1509 = null; var v_gr_1510 = null; var v_lit_1511 = null; var v_amt_1512 = null; var v_tag_1513 = null; var v_i_1514 = null
	v_sc_1506 = J.arg(a, 0)
	v_a_1507 = J.gp(v_sc_1506, "a")
	v_r_1508 = J.gp(v_a_1507, "r")
	v_g_1509 = J.gp(env["S"], "g")
	var _t1524 = env["roomAt"]
	v_gr_1510 = J.cl(_t1524, null, [J.gp(v_a_1507, "x")])
	v_lit_1511 = J.gp(J.gp(env["S"], "light"), v_gr_1510)
	if (not J.seq(J.gp(v_r_1508, "state"), "home")):
		return null
	v_amt_1512 = 38.0
	v_tag_1513 = ""
	if (not J.t(v_lit_1511)):
		var _t1525 = J.mul(v_amt_1512, 1.5)
		v_amt_1512 = _t1525
		v_tag_1513 = "黑暗中嚇加倍！"
	if (J.sub(J.gp(env["S"], "t"), J.gp(v_a_1507, "hitT")) < 5.0):
		var _t1526 = J.mul(v_amt_1512, 1.3)
		v_amt_1512 = _t1526
		var _t1527 = ((J.add(v_tag_1513, " ") if J.t(v_tag_1513) else "") + "連環嚇！")
		v_tag_1513 = _t1527
	var _t1528 = J.gp(v_a_1507, "act")
	J.sp(v_a_1507, "prevAct", _t1528)
	J.mc(env["A"], "scareRes", [v_r_1508, v_amt_1512, v_g_1509])
	var _t1529 = J.gp(env["S"], "t")
	J.sp(v_a_1507, "hitT", _t1529)
	J.sp(v_a_1507, "st", "cower")
	J.sp(v_a_1507, "cowT", 1.6)
	var _t1530 = env["S"]
	var _t1531 = J.add(J.gp(_t1530, "alert"), (12.0 if J.t(v_lit_1511) else 5.0))
	J.sp(_t1530, "alert", _t1531)
	var _t1532 = env["S"]
	J.sp(_t1532, "calmT", 0.0)
	J.mc(env["SND"], "scare", [])
	var _t1533 = env["S"]
	J.sp(_t1533, "flash", 0.25)
	if J.t(v_tag_1513):
		var _t1534 = env["wfl"]
		J.cl(_t1534, null, [J.gp(v_a_1507, "x"), J.sub(J.gp(J.gp(env["S"], "lay"), "floor"), J.mul(J.gp(J.gp(env["S"], "lay"), "ph"), 1.2)), v_tag_1513, "#e6a85a"])
	v_i_1514 = 0.0
	while true:
		if not J.cmp(v_i_1514, 10.0, "<"): break
		var _t1535 = env["part"]
		J.cl(_t1535, null, [J.gp(v_a_1507, "x"), J.sub(J.gp(J.gp(env["S"], "lay"), "floor"), J.mul(J.gp(J.gp(env["S"], "lay"), "ph"), 0.7)), (J.sub(J.cl(env["rnd"], null, []), 0.5) * 200.0), ((-100.0) - J.mul(J.cl(env["rnd"], null, []), 80.0)), 0.7, ("coin" if J.seq(J.gp(v_sc_1506, "k"), "toyol") else ("drop" if J.seq(J.gp(v_sc_1506, "k"), "tianhua") else "crumb"))])
		v_i_1514 = J.num(v_i_1514) + 1.0
	var _t1536 = env["roomTask"]
	J.cl(_t1536, null, [v_a_1507])

func _f266(this_, a: Array, env):
	var v_on_1517 = null
	v_on_1517 = J.arg(a, 0)
	var _t1537 = J.gp(env["cv"], "style")
	var _t1538 = ("block" if J.t(v_on_1517) else "none")
	J.sp(_t1537, "display", _t1538)
	if (not J.t(v_on_1517)):
		env["ptr"] = null
		if J.t(env["S"]):
			var _t1539 = env["S"]
			J.sp(_t1539, "joy", null)

func _f267(this_, a: Array, env):
	var v_NT_1520 = null; var v_r_1521 = null; var v_cw_1522 = null; var v_ch_1523 = null
	v_NT_1520 = J.gp(J.G.get("window"), "__twNat")
	v_r_1521 = ({"left": 0.0, "top": 0.0, "width": J.gp(env["A"], "VW"), "height": J.gp(env["A"], "VH")} if J.t(v_NT_1520) else J.mc(J.gp(env["A"], "cv"), "getBoundingClientRect", []))
	var _t1542 = null
	if J.t(v_NT_1520):
		_t1542 = J.gp(v_NT_1520, "s")
	else:
		var _t1540 = J.gp(J.G.get("window"), "devicePixelRatio")
		var _t1541 = J.gp(J.G.get("window"), "devicePixelRatio")
		_t1542 = J.min_([2.0, (_t1541 if J.t(_t1541) else 1.0)])
	env["DPR"] = _t1542
	var _t1543 = J.gp(v_r_1521, "width")
	var _t1544 = (_t1543 if J.t(_t1543) else J.gp(env["A"], "VW"))
	env["W"] = _t1544
	var _t1545 = J.gp(v_r_1521, "height")
	var _t1546 = (_t1545 if J.t(_t1545) else J.gp(env["A"], "VH"))
	env["H"] = _t1546
	var _t1547 = J.gp(env["cv"], "style")
	var _t1548 = J.add(J.gp(v_r_1521, "left"), "px")
	J.sp(_t1547, "left", _t1548)
	var _t1549 = J.gp(env["cv"], "style")
	var _t1550 = J.add(J.gp(v_r_1521, "top"), "px")
	J.sp(_t1549, "top", _t1550)
	var _t1551 = J.gp(env["cv"], "style")
	var _t1552 = J.add(env["W"], "px")
	J.sp(_t1551, "width", _t1552)
	var _t1553 = J.gp(env["cv"], "style")
	var _t1554 = J.add(env["H"], "px")
	J.sp(_t1553, "height", _t1554)
	v_cw_1522 = J.round(J.num(J.mul(env["W"], env["DPR"])))
	v_ch_1523 = J.round(J.num(J.mul(env["H"], env["DPR"])))
	var _t1555 = (not J.seq(J.gp(env["cv"], "width"), v_cw_1522))
	if (_t1555 if _t1555 else (not J.seq(J.gp(env["cv"], "height"), v_ch_1523))):
		var _t1556 = env["cv"]
		J.sp(_t1556, "width", v_cw_1522)
		var _t1557 = env["cv"]
		J.sp(_t1557, "height", v_ch_1523)

func _f268(this_, a: Array, env):
	var v_lay_1526 = null; var v_top_1527 = null; var v_ph_1528 = null; var v_s_1529 = null
	v_lay_1526 = J.gp(env["S"], "lay")
	v_top_1527 = J.gp(env["A"], "TOP")
	v_ph_1528 = J.sub(J.sub(env["H"], J.gp(env["A"], "TOP")), J.gp(env["A"], "BOT"))
	v_s_1529 = J.div(v_ph_1528, J.sub(J.gp(J.gp(v_lay_1526, "crop"), 1.0), J.gp(J.gp(v_lay_1526, "crop"), 0.0)))
	return {"top": v_top_1527, "ph": v_ph_1528, "s": v_s_1529, "vw": J.div(env["W"], v_s_1529)}

func _f269(this_, a: Array, env):
	var v_x_1532 = null; var v_y_1533 = null; var v_V_1534 = null
	v_x_1532 = J.arg(a, 0)
	v_y_1533 = J.arg(a, 1)
	v_V_1534 = J.arg(a, 2)
	return {"x": J.mul(J.sub(v_x_1532, J.gp(J.gp(env["S"], "cam"), "x")), J.gp(v_V_1534, "s")), "y": J.add(J.gp(v_V_1534, "top"), J.mul(J.sub(v_y_1533, J.gp(J.gp(J.gp(env["S"], "lay"), "crop"), 0.0)), J.gp(v_V_1534, "s")))}

func _f270(this_, a: Array, env):
	var v_k_1537 = null; var v_x_1538 = null; var v_y_1539 = null; var v_h_1540 = null; var v_o_1541 = null; var v_im_1542 = null; var v_w_1543 = null
	v_k_1537 = J.arg(a, 0)
	v_x_1538 = J.arg(a, 1)
	v_y_1539 = J.arg(a, 2)
	v_h_1540 = J.arg(a, 3)
	v_o_1541 = J.arg(a, 4)
	var _t1558 = env["img"]
	v_im_1542 = J.cl(_t1558, null, [v_k_1537])
	if (not J.t(v_im_1542)):
		var _t1559 = env["c"]
		var _t1560 = (J.gp(v_o_1541, "alpha") if J.t(v_o_1541) else v_o_1541)
		var _t1561 = (J.add("rgba(30,30,36,", (_t1560 if J.t(_t1560) else 1.0)) + ")")
		J.sp(_t1559, "fillStyle", _t1561)
		J.mc(env["c"], "fillRect", [J.sub(v_x_1538, J.mul(v_h_1540, 0.18)), J.sub(v_y_1539, v_h_1540), J.mul(v_h_1540, 0.36), v_h_1540])
		return null
	v_w_1543 = J.div(J.mul(v_h_1540, J.gp(v_im_1542, "width")), J.gp(v_im_1542, "height"))
	var _t1562 = (v_o_1541 if J.t(v_o_1541) else {})
	v_o_1541 = _t1562
	J.mc(env["c"], "save", [])
	var _t1563 = env["c"]
	var _t1564 = (1.0 if J.leq(J.gp(v_o_1541, "alpha"), null) else J.gp(v_o_1541, "alpha"))
	J.sp(_t1563, "globalAlpha", _t1564)
	J.mc(env["c"], "translate", [v_x_1538, v_y_1539])
	if J.t(J.gp(v_o_1541, "rot")):
		J.mc(env["c"], "rotate", [J.gp(v_o_1541, "rot")])
	var _t1566 = ((-1.0) if J.t(J.gp(v_o_1541, "flip")) else 1.0)
	var _t1565 = J.gp(v_o_1541, "sx")
	var _t1568 = J.mul(_t1566, (_t1565 if J.t(_t1565) else 1.0))
	var _t1567 = J.gp(v_o_1541, "sy")
	J.mc(env["c"], "scale", [_t1568, (_t1567 if J.t(_t1567) else 1.0)])
	J.mc(env["c"], "drawImage", [v_im_1542, J.div((-J.num(v_w_1543)), 2.0), (-J.num(v_h_1540)), v_w_1543, v_h_1540])
	J.mc(env["c"], "restore", [])

func _f271(this_, a: Array, env):
	var v_x_1546 = null; var v_y_1547 = null; var v_t_1548 = null; var v_w_1549 = null
	v_x_1546 = J.arg(a, 0)
	v_y_1547 = J.arg(a, 1)
	v_t_1548 = J.arg(a, 2)
	var _t1569 = env["c"]
	var _t1570 = J.add("bold 13px ", J.gp(env["A"], "FONT"))
	J.sp(_t1569, "font", _t1570)
	v_w_1549 = J.min_([J.sub(env["W"], 20.0), J.add(J.gp(J.mc(env["c"], "measureText", [v_t_1548]), "width"), 18.0)])
	var _t1571 = env["clamp"]
	var _t1572 = J.cl(_t1571, null, [v_x_1546, (J.div(v_w_1549, 2.0) + 6.0), (J.sub(env["W"], J.div(v_w_1549, 2.0)) - 6.0)])
	v_x_1546 = _t1572
	J.mc(env["A"], "crBlit", [env["c"], J.mc(env["A"], "crGet", [v_w_1549, 24.0, "note", "bar"]), J.sub(v_x_1546, J.div(v_w_1549, 2.0)), J.sub(v_y_1547, 26.0)])
	J.mc(env["c"], "save", [])
	var _t1573 = env["c"]
	J.sp(_t1573, "fillStyle", "#2a1e1c")
	var _t1574 = env["c"]
	J.sp(_t1574, "textAlign", "center")
	J.mc(env["c"], "fillText", [v_t_1548, v_x_1546, J.sub(v_y_1547, 9.0), J.sub(v_w_1549, 8.0)])
	J.mc(env["c"], "restore", [])

func _f272(this_, a: Array, env):
	var v_id_1552 = null; var v_x_1553 = null; var v_y_1554 = null; var v_w_1555 = null; var v_h_1556 = null; var v_label_1557 = null; var v_tone_1558 = null; var v_on_1559 = null; var v_pz_1560 = null
	v_id_1552 = J.arg(a, 0)
	v_x_1553 = J.arg(a, 1)
	v_y_1554 = J.arg(a, 2)
	v_w_1555 = J.arg(a, 3)
	v_h_1556 = J.arg(a, 4)
	v_label_1557 = J.arg(a, 5)
	v_tone_1558 = J.arg(a, 6)
	v_on_1559 = J.arg(a, 7)
	J.mc(env["BTN"], "push", [{"id": v_id_1552, "x": v_x_1553, "y": v_y_1554, "w": v_w_1555, "h": v_h_1556}])
	var _t1576 = (J.seq(J.gp(env["ptr"], "btn"), v_id_1552) if J.t(env["ptr"]) else env["ptr"])
	if not J.t(_t1576):
		var _t1575 = (J.seq(J.gp(env["PRESS"], "id"), v_id_1552) if J.t(env["PRESS"]) else env["PRESS"])
		_t1576 = ((J.sub(J.S_performance_("now", []), J.gp(env["PRESS"], "t")) < 220.0) if J.t(_t1575) else _t1575)
	v_pz_1560 = _t1576
	J.mc(env["A"], "crBtn", [env["c"], v_x_1553, v_y_1554, v_w_1555, v_h_1556, v_label_1557, v_tone_1558, v_pz_1560, J.seq(v_on_1559, false)])

func _f273(this_, a: Array, env):
	var v_s_1563 = null; var v_x_1564 = null; var v_y_1565 = null; var v_sz_1566 = null; var v_col_1567 = null; var v_al_1568 = null; var v_mw_1569 = null
	v_s_1563 = J.arg(a, 0)
	v_x_1564 = J.arg(a, 1)
	v_y_1565 = J.arg(a, 2)
	v_sz_1566 = J.arg(a, 3)
	v_col_1567 = J.arg(a, 4)
	v_al_1568 = J.arg(a, 5)
	v_mw_1569 = J.arg(a, 6)
	J.mc(env["A"], "crText", [env["c"], v_s_1563, v_x_1564, v_y_1565, v_sz_1566, v_col_1567, (v_al_1568 if J.t(v_al_1568) else "center"), v_mw_1569])

func _f276(this_, a: Array, env):
	var v_k_1590 = null
	v_k_1590 = J.arg(a, 0)
	var _t1583 = env["__p"]["img"]
	return J.cl(_t1583, null, [v_k_1590])

func _f275(this_, a: Array, env):
	var v_R_1580 = null; var v_i_1581 = null; var v_a_1582 = null; var v_b_1583 = null; var v_RK_1584 = null; var v_key_1585 = null; var v_gd_1586 = null; var v_tx_1587 = null
	v_R_1580 = J.arg(a, 0)
	v_i_1581 = J.arg(a, 1)
	var _t1579 = env["__p"]["P"]
	v_a_1582 = J.cl(_t1579, null, [J.gp(v_R_1580, "x0"), J.gp(J.gp(env["lay"], "crop"), 0.0), env["V"]])
	var _t1580 = env["__p"]["P"]
	v_b_1583 = J.cl(_t1580, null, [J.gp(v_R_1580, "x1"), J.gp(J.gp(env["lay"], "crop"), 1.0), env["V"]])
	var _t1581 = J.cmp(J.gp(v_b_1583, "x"), 0.0, "<")
	if (_t1581 if _t1581 else J.cmp(J.gp(v_a_1582, "x"), env["__p"]["W"], ">")):
		return null
	var _t1582 = J.gp({"living": ["room_mahjong", "room_shopper"], "kitchen": ["room_helper"], "bed": ["room_nurse", "room_gamer"], "bath": []}, J.gp(v_R_1580, "k"))
	v_RK_1584 = (_t1582 if J.t(_t1582) else [])
	v_key_1585 = J.mc(v_RK_1584, "find", [Callable(self, "_f276").bind(env)])
	if J.t(v_key_1585):
		var _t1584 = env["__p"]["img"]
		J.mc(env["__p"]["c"], "drawImage", [J.cl(_t1584, null, [v_key_1585]), J.gp(v_a_1582, "x"), J.gp(v_a_1582, "y"), J.sub(J.gp(v_b_1583, "x"), J.gp(v_a_1582, "x")), J.sub(J.gp(v_b_1583, "y"), J.gp(v_a_1582, "y"))])
	else:
		v_gd_1586 = J.mc(env["__p"]["c"], "createLinearGradient", [0.0, J.gp(v_a_1582, "y"), 0.0, J.gp(v_b_1583, "y")])
		J.mc(v_gd_1586, "addColorStop", [0.0, "#2a3134"])
		J.mc(v_gd_1586, "addColorStop", [1.0, "#151a1c"])
		var _t1585 = env["__p"]["c"]
		J.sp(_t1585, "fillStyle", v_gd_1586)
		J.mc(env["__p"]["c"], "fillRect", [J.gp(v_a_1582, "x"), J.gp(v_a_1582, "y"), J.sub(J.gp(v_b_1583, "x"), J.gp(v_a_1582, "x")), J.sub(J.gp(v_b_1583, "y"), J.gp(v_a_1582, "y"))])
		var _t1586 = env["__p"]["c"]
		J.sp(_t1586, "strokeStyle", "rgba(180,200,200,0.12)")
		v_tx_1587 = J.gp(v_a_1582, "x")
		while true:
			if not J.cmp(v_tx_1587, J.gp(v_b_1583, "x"), "<"): break
			J.mc(env["__p"]["c"], "beginPath", [])
			J.mc(env["__p"]["c"], "moveTo", [v_tx_1587, J.gp(v_a_1582, "y")])
			J.mc(env["__p"]["c"], "lineTo", [v_tx_1587, J.gp(v_b_1583, "y")])
			J.mc(env["__p"]["c"], "stroke", [])
			var _t1587 = J.add(v_tx_1587, J.mul(22.0, J.gp(env["V"], "s")))
			v_tx_1587 = _t1587
	var _t1588 = env["__p"]["c"]
	J.sp(_t1588, "fillStyle", "#0d0b0e")
	J.mc(env["__p"]["c"], "fillRect", [J.sub(J.gp(v_b_1583, "x"), J.mul(6.0, J.gp(env["V"], "s"))), J.gp(v_a_1582, "y"), J.mul(12.0, J.gp(env["V"], "s")), (J.sub(J.gp(v_b_1583, "y"), J.gp(v_a_1582, "y")) * 0.35)])

func _f274(this_, a: Array, env):
	var v_im_1574 = null; var v_k_1575 = null; var v_ch_1576 = null; var v_srcY_1577 = null
	var _s624 = {"__p": env, "V": null, "lay": null}
	_s624["V"] = J.arg(a, 0)
	_s624["lay"] = J.gp(_s624["__p"]["S"], "lay")
	var _t1577 = _s624["__p"]["img"]
	v_im_1574 = J.cl(_t1577, null, [J.gp(_s624["lay"], "img")])
	if J.t(v_im_1574):
		v_k_1575 = J.div(J.gp(v_im_1574, "width"), J.gp(_s624["lay"], "W"))
		v_ch_1576 = J.sub(J.gp(J.gp(_s624["lay"], "crop"), 1.0), J.gp(J.gp(_s624["lay"], "crop"), 0.0))
		v_srcY_1577 = J.mul((J.gp(J.gp(_s624["lay"], "crop"), 0.0) if (J.div(J.gp(v_im_1574, "height"), v_k_1575) >= J.sub(J.gp(_s624["lay"], "H"), 4.0)) else 0.0), v_k_1575)
		J.mc(_s624["__p"]["c"], "drawImage", [v_im_1574, J.mul(J.gp(J.gp(_s624["__p"]["S"], "cam"), "x"), v_k_1575), v_srcY_1577, J.mul(J.gp(_s624["V"], "vw"), v_k_1575), J.mul(v_ch_1576, v_k_1575), 0.0, J.gp(_s624["V"], "top"), _s624["__p"]["W"], J.gp(_s624["V"], "ph")])
	else:
		var _t1578 = J.gp(_s624["lay"], "rooms")
		J.mc(_t1578, "forEach", [Callable(self, "_f275").bind(_s624)])

func _f277(this_, a: Array, env):
	var v_p_1593 = null; var v_V_1594 = null; var v_q_1595 = null; var v_a_1596 = null; var v_T_1597 = null; var v_s_1598 = null; var v_k_1599 = null; var v_r_1600 = null; var v_i_1601 = null; var v_on_1602 = null; var v_gr_1603 = null; var v_j_1604 = null; var v_xx_1605 = null; var v_o_1606 = null; var v_j2_1607 = null; var v_dy_1608 = null; var v_j3_1609 = null; var v_bx_1610 = null; var v_j4_1611 = null; var v_ready_1612 = null; var v_inR_1613 = null
	v_p_1593 = J.arg(a, 0)
	v_V_1594 = J.arg(a, 1)
	var _t1589 = env["P"]
	v_q_1595 = J.cl(_t1589, null, [J.gp(v_p_1593, "x"), J.gp(v_p_1593, "y"), v_V_1594])
	v_a_1596 = J.cmp(J.gp(v_p_1593, "t"), 0.0, ">")
	v_T_1597 = J.gp(env["S"], "t")
	v_s_1598 = J.gp(v_V_1594, "s")
	v_k_1599 = J.gp(v_p_1593, "k")
	v_r_1600 = (J.mul(34.0, v_s_1598) + 10.0)
	J.mc(env["c"], "save", [])
	if J.t(v_a_1596):
		var _t1590 = env["c"]
		var _t1591 = J.min_([1.0, J.gp(v_p_1593, "t")])
		J.sp(_t1590, "globalAlpha", _t1591)
		var _t1592 = J.seq(v_k_1599, "tv")
		if (_t1592 if _t1592 else J.seq(v_k_1599, "pc")):
			v_i_1601 = 0.0
			while true:
				if not J.cmp(v_i_1601, 60.0, "<"): break
				var _t1593 = env["c"]
				var _t1594 = (J.add("rgba(230,235,240,", (randf() * 0.8)) + ")")
				J.sp(_t1593, "fillStyle", _t1594)
				J.mc(env["c"], "fillRect", [(J.sub(J.gp(v_q_1595, "x"), J.mul(40.0, v_s_1598)) + J.mul((randf() * 80.0), v_s_1598)), (J.sub(J.gp(v_q_1595, "y"), J.mul(28.0, v_s_1598)) + J.mul((randf() * 50.0), v_s_1598)), 3.0, 2.0])
				v_i_1601 = J.num(v_i_1601) + 1.0
			var _t1595 = env["c"]
			J.sp(_t1595, "fillStyle", "rgba(10,10,10,0.6)")
			J.mc(env["c"], "beginPath", [])
			J.mc(env["c"], "ellipse", [J.gp(v_q_1595, "x"), J.gp(v_q_1595, "y"), J.mul(10.0, v_s_1598), J.mul(14.0, v_s_1598), 0.0, 0.0, 7.0])
			J.mc(env["c"], "fill", [])
			if J.seq(v_k_1599, "pc"):
				var _t1596 = env["c"]
				J.sp(_t1596, "fillStyle", "#c0302a")
				J.mc(env["c"], "fillRect", [J.sub(J.gp(v_q_1595, "x"), J.mul(6.0, v_s_1598)), J.sub(J.gp(v_q_1595, "y"), J.mul(4.0, v_s_1598)), J.mul(4.0, v_s_1598), J.mul(4.0, v_s_1598)])
				J.mc(env["c"], "fillRect", [J.add(J.gp(v_q_1595, "x"), J.mul(3.0, v_s_1598)), J.sub(J.gp(v_q_1595, "y"), J.mul(4.0, v_s_1598)), J.mul(4.0, v_s_1598), J.mul(4.0, v_s_1598)])
		else:
			if J.seq(v_k_1599, "lamp"):
				v_on_1602 = J.seq(J.mod(floor(J.num(J.mul(v_T_1597, 14.0))), 3.0), 0.0)
				if J.t(v_on_1602):
					v_gr_1603 = J.mc(env["c"], "createRadialGradient", [J.gp(v_q_1595, "x"), J.gp(v_q_1595, "y"), 2.0, J.gp(v_q_1595, "x"), J.gp(v_q_1595, "y"), J.mul(120.0, v_s_1598)])
					J.mc(v_gr_1603, "addColorStop", [0.0, "rgba(255,240,190,0.55)"])
					J.mc(v_gr_1603, "addColorStop", [1.0, "rgba(255,240,190,0)"])
					var _t1597 = env["c"]
					J.sp(_t1597, "fillStyle", v_gr_1603)
					J.mc(env["c"], "fillRect", [J.sub(J.gp(v_q_1595, "x"), J.mul(120.0, v_s_1598)), J.sub(J.gp(v_q_1595, "y"), J.mul(120.0, v_s_1598)), J.mul(240.0, v_s_1598), J.mul(240.0, v_s_1598)])
			else:
				var _t1598 = J.seq(v_k_1599, "tap")
				if (_t1598 if _t1598 else J.seq(v_k_1599, "shower")):
					var _t1599 = env["c"]
					J.sp(_t1599, "strokeStyle", "rgba(170,215,240,0.85)")
					var _t1600 = env["c"]
					J.sp(_t1600, "lineWidth", 3.0)
					v_j_1604 = 0.0
					while true:
						if not J.cmp(v_j_1604, 4.0, "<"): break
						J.mc(env["c"], "beginPath", [])
						v_xx_1605 = J.add(J.gp(v_q_1595, "x"), J.mul((J.sub(v_j_1604, 1.5) * 4.0), v_s_1598))
						J.mc(env["c"], "moveTo", [v_xx_1605, J.gp(v_q_1595, "y")])
						J.mc(env["c"], "lineTo", [J.add(v_xx_1605, (sin(J.num(J.add(J.mul(v_T_1597, 20.0), v_j_1604))) * 2.0)), J.add(J.gp(v_q_1595, "y"), J.mul((200.0 if J.seq(v_k_1599, "shower") else 60.0), v_s_1598))])
						J.mc(env["c"], "stroke", [])
						v_j_1604 = J.num(v_j_1604) + 1.0
				else:
					var _t1601 = J.seq(v_k_1599, "wardrobe")
					if (_t1601 if _t1601 else J.seq(v_k_1599, "fridge")):
						v_o_1606 = J.mul((absf(J.num(sin(J.num((J.sub(2.6, J.gp(v_p_1593, "t")) * 1.5))))) * 44.0), v_s_1598)
						var _t1602 = env["c"]
						var _t1603 = ("rgba(200,240,255,0.35)" if J.seq(v_k_1599, "fridge") else "rgba(10,6,8,0.85)")
						J.sp(_t1602, "fillStyle", _t1603)
						J.mc(env["c"], "beginPath", [])
						J.mc(env["c"], "moveTo", [J.add(J.gp(v_q_1595, "x"), J.mul(20.0, v_s_1598)), J.sub(J.gp(v_q_1595, "y"), J.mul(70.0, v_s_1598))])
						J.mc(env["c"], "lineTo", [J.add(J.add(J.gp(v_q_1595, "x"), J.mul(20.0, v_s_1598)), v_o_1606), J.sub(J.gp(v_q_1595, "y"), J.mul(80.0, v_s_1598))])
						J.mc(env["c"], "lineTo", [J.add(J.add(J.gp(v_q_1595, "x"), J.mul(20.0, v_s_1598)), v_o_1606), J.add(J.gp(v_q_1595, "y"), J.mul(90.0, v_s_1598))])
						J.mc(env["c"], "lineTo", [J.add(J.gp(v_q_1595, "x"), J.mul(20.0, v_s_1598)), J.add(J.gp(v_q_1595, "y"), J.mul(80.0, v_s_1598))])
						J.mc(env["c"], "closePath", [])
						J.mc(env["c"], "fill", [])
						if J.seq(v_k_1599, "wardrobe"):
							var _t1604 = env["c"]
							J.sp(_t1604, "fillStyle", "rgba(220,40,40,0.8)")
							J.mc(env["c"], "beginPath", [])
							J.mc(env["c"], "arc", [J.add(J.gp(v_q_1595, "x"), J.mul(6.0, v_s_1598)), J.sub(J.gp(v_q_1595, "y"), J.mul(20.0, v_s_1598)), 2.5, 0.0, 7.0])
							J.mc(env["c"], "arc", [J.add(J.gp(v_q_1595, "x"), J.mul(14.0, v_s_1598)), J.sub(J.gp(v_q_1595, "y"), J.mul(20.0, v_s_1598)), 2.5, 0.0, 7.0])
							J.mc(env["c"], "fill", [])
					else:
						if J.seq(v_k_1599, "mirror"):
							var _t1605 = env["c"]
							var _t1606 = J.mul(J.gp(_t1605, "globalAlpha"), (0.5 + (0.3 * sin(J.num(J.mul(v_T_1597, 8.0))))))
							J.sp(_t1605, "globalAlpha", _t1606)
							var _t1607 = env["sprite"]
							J.cl(_t1607, null, [J.gp(J.gp(J.gp(env["S"], "g"), "d"), "sprite"), J.gp(v_q_1595, "x"), J.add(J.gp(v_q_1595, "y"), J.mul(40.0, v_s_1598)), J.mul(90.0, v_s_1598), {"alpha": 0.55}])
						else:
							if J.seq(v_k_1599, "fan"):
								var _t1608 = env["c"]
								J.sp(_t1608, "strokeStyle", "rgba(220,230,235,0.5)")
								var _t1609 = env["c"]
								J.sp(_t1609, "lineWidth", 2.0)
								v_j2_1607 = 0.0
								while true:
									if not J.cmp(v_j2_1607, 3.0, "<"): break
									J.mc(env["c"], "beginPath", [])
									J.mc(env["c"], "ellipse", [J.gp(v_q_1595, "x"), J.gp(v_q_1595, "y"), J.mul((50.0 + J.mul(v_j2_1607, 14.0)), v_s_1598), J.mul(10.0, v_s_1598), 0.0, J.add(J.mul(v_T_1597, 30.0), v_j2_1607), J.add(J.add(J.mul(v_T_1597, 30.0), v_j2_1607), 2.0)])
									J.mc(env["c"], "stroke", [])
									v_j2_1607 = J.num(v_j2_1607) + 1.0
							else:
								if J.seq(v_k_1599, "radio"):
									var _t1610 = env["c"]
									J.sp(_t1610, "fillStyle", "#e8d2a0")
									var _t1611 = env["c"]
									var _t1612 = J.add((J.add("bold ", J.round(J.num((J.mul(22.0, v_s_1598) + 8.0)))) + "px "), J.gp(env["A"], "FONT"))
									J.sp(_t1611, "font", _t1612)
									var _t1613 = env["c"]
									J.sp(_t1613, "textAlign", "center")
									J.mc(env["c"], "fillText", ["♪", (J.sub(J.gp(v_q_1595, "x"), J.mul(20.0, v_s_1598)) + (sin(J.num(J.mul(v_T_1597, 5.0))) * 8.0)), (J.sub(J.gp(v_q_1595, "y"), J.mul(40.0, v_s_1598)) - J.mod(J.mul(v_T_1597, 60.0), 30.0))])
									J.mc(env["c"], "fillText", ["♫", J.add(J.gp(v_q_1595, "x"), J.mul(20.0, v_s_1598)), (J.sub(J.gp(v_q_1595, "y"), J.mul(30.0, v_s_1598)) - J.mod((J.mul(v_T_1597, 60.0) + 15.0), 30.0))])
								else:
									if J.seq(v_k_1599, "pots"):
										v_dy_1608 = J.mul((J.min_([1.0, (J.sub(2.6, J.gp(v_p_1593, "t")) * 2.0)]) * 160.0), v_s_1598)
										var _t1614 = env["c"]
										J.sp(_t1614, "fillStyle", "#3a3a3e")
										J.mc(env["c"], "beginPath", [])
										J.mc(env["c"], "ellipse", [J.add(J.gp(v_q_1595, "x"), J.mul(10.0, v_s_1598)), J.add(J.gp(v_q_1595, "y"), v_dy_1608), J.mul(18.0, v_s_1598), J.mul(8.0, v_s_1598), (J.sub(2.6, J.gp(v_p_1593, "t")) * 6.0), 0.0, 7.0])
										J.mc(env["c"], "fill", [])
									else:
										if J.seq(v_k_1599, "net"):
											var _t1615 = env["c"]
											J.sp(_t1615, "strokeStyle", "rgba(235,235,230,0.55)")
											var _t1616 = env["c"]
											J.sp(_t1616, "lineWidth", 2.0)
											v_j3_1609 = 0.0
											while true:
												if not J.cmp(v_j3_1609, 6.0, "<"): break
												J.mc(env["c"], "beginPath", [])
												v_bx_1610 = (J.sub(J.gp(v_q_1595, "x"), J.mul(90.0, v_s_1598)) + J.mul(J.mul(v_j3_1609, 36.0), v_s_1598))
												J.mc(env["c"], "moveTo", [v_bx_1610, J.sub(J.gp(v_q_1595, "y"), J.mul(110.0, v_s_1598))])
												J.mc(env["c"], "quadraticCurveTo", [J.add(v_bx_1610, J.mul((sin(J.num(J.add(J.mul(v_T_1597, 6.0), v_j3_1609))) * 24.0), v_s_1598)), J.gp(v_q_1595, "y"), J.add(v_bx_1610, J.mul((sin(J.num(J.add(J.mul(v_T_1597, 4.0), v_j3_1609))) * 14.0), v_s_1598)), J.add(J.gp(v_q_1595, "y"), J.mul(110.0, v_s_1598))])
												J.mc(env["c"], "stroke", [])
												v_j3_1609 = J.num(v_j3_1609) + 1.0
										else:
											if J.seq(v_k_1599, "jar"):
												v_j4_1611 = 0.0
												while true:
													if not J.cmp(v_j4_1611, 5.0, "<"): break
													var _t1617 = env["c"]
													J.sp(_t1617, "strokeStyle", "rgba(180,220,230,0.7)")
													J.mc(env["c"], "beginPath", [])
													J.mc(env["c"], "arc", [J.add(J.gp(v_q_1595, "x"), J.mul((J.sub(v_j4_1611, 2.0) * 10.0), v_s_1598)), (J.sub(J.gp(v_q_1595, "y"), J.mul(50.0, v_s_1598)) - J.mul(J.mod((J.mul(v_T_1597, 80.0) + J.mul(v_j4_1611, 13.0)), 40.0), v_s_1598)), (J.mul(4.0, v_s_1598) + 2.0), 0.0, 7.0])
													J.mc(env["c"], "stroke", [])
													v_j4_1611 = J.num(v_j4_1611) + 1.0
		var _t1618 = env["c"]
		J.sp(_t1618, "globalAlpha", 1.0)
	v_ready_1612 = J.cmp(J.gp(v_p_1593, "cd"), 0.0, "<=")
	var _t1619 = env["roomAt"]
	var _t1620 = J.seq(J.cl(_t1619, null, [J.gp(env["S"], "gx")]), J.gp(v_p_1593, "room"))
	v_inR_1613 = (J.cmp(absf(J.num(J.sub(J.gp(env["S"], "gx"), J.gp(v_p_1593, "x")))), env["RANGE_HOT"], "<=") if _t1620 else _t1620)
	var _t1621 = env["c"]
	var _t1622 = (((0.85 + (0.15 * sin(J.num(J.mul(v_T_1597, 6.0))))) if J.t(v_inR_1613) else (0.45 + (0.2 * sin(J.num(J.mul(v_T_1597, 3.0)))))) if J.t(v_ready_1612) else 0.35)
	J.sp(_t1621, "globalAlpha", _t1622)
	var _t1623 = env["c"]
	var _t1624 = (("#e6a85a" if J.t(v_inR_1613) else "#b2d394") if J.t(v_ready_1612) else "#7a6e74")
	J.sp(_t1623, "strokeStyle", _t1624)
	var _t1625 = env["c"]
	var _t1626 = (3.0 if J.t((v_ready_1612 if J.t(v_inR_1613) else v_inR_1613)) else 2.0)
	J.sp(_t1625, "lineWidth", _t1626)
	J.mc(env["c"], "setLineDash", [([] if J.t(v_ready_1612) else [4.0, 4.0])])
	J.mc(env["c"], "beginPath", [])
	J.mc(env["c"], "arc", [J.gp(v_q_1595, "x"), J.gp(v_q_1595, "y"), J.mul(v_r_1600, 0.62), 0.0, 7.0])
	J.mc(env["c"], "stroke", [])
	J.mc(env["c"], "setLineDash", [[]])
	if (not J.t(v_ready_1612)):
		var _t1627 = env["c"]
		J.sp(_t1627, "strokeStyle", "#e8d2a0")
		var _t1628 = env["c"]
		J.sp(_t1628, "lineWidth", 3.0)
		J.mc(env["c"], "beginPath", [])
		J.mc(env["c"], "arc", [J.gp(v_q_1595, "x"), J.gp(v_q_1595, "y"), J.mul(v_r_1600, 0.62), J.div((-PI), 2.0), (J.div((-PI), 2.0) + ((PI * 2.0) * (1.0 - J.div(J.gp(v_p_1593, "cd"), 14.0))))])
		J.mc(env["c"], "stroke", [])
	var _t1629 = env["c"]
	J.sp(_t1629, "globalAlpha", 1.0)
	J.mc(env["c"], "restore", [])
	if J.t((v_inR_1613 if J.t(v_ready_1612) else v_ready_1612)):
		var _t1630 = env["txt"]
		J.cl(_t1630, null, [J.gp(J.gp(env["HOT"], v_k_1599), "v"), J.gp(v_q_1595, "x"), (J.sub(J.gp(v_q_1595, "y"), J.mul(v_r_1600, 0.62)) - 6.0), 12.0, "#e6a85a"])

func _f278(this_, a: Array, env):
	var v_a_1616 = null; var v_V_1617 = null; var v_r_1618 = null; var v_lay_1619 = null; var v_FX_1620 = null; var v_run_1621 = null; var v_scared_1622 = null; var v_h0_1623 = null; var v_k2_1624 = null; var v_h_1625 = null; var v_art_1626 = null; var v_q_1627 = null; var v_rot_1628 = null; var v_sy_1629 = null; var v_sx_1630 = null; var v_oy_1631 = null; var v_al_1632 = null; var v_sxs_1633 = null; var v_tint_1634 = null; var v_flip_1635 = null; var v_bed_1636 = null; var v_lit_1637 = null; var v_S0_1638 = null; var v_T0_1639 = null; var v_j_1640 = null; var v_i_1641 = null; var v_top_1642 = null
	v_a_1616 = J.arg(a, 0)
	v_V_1617 = J.arg(a, 1)
	v_r_1618 = J.gp(v_a_1616, "r")
	v_lay_1619 = J.gp(env["S"], "lay")
	v_FX_1620 = J.gp(J.G.get("window"), "PPLFX")
	v_run_1621 = J.seq(J.gp(v_a_1616, "st"), "run")
	var _t1632 = (not (not J.t(v_FX_1620)))
	if J.t(_t1632):
		var _t1631 = J.cmp(J.gp(v_r_1618, "shockT"), 0.0, ">")
		_t1632 = (_t1631 if _t1631 else v_run_1621)
	v_scared_1622 = _t1632
	var _t1634 = J.gp(v_lay_1619, "ph")
	var _t1633 = J.gp(v_r_1618, "h")
	v_h0_1623 = J.mul(J.div(J.mul(_t1634, (_t1633 if J.t(_t1633) else 74.0)), 74.0), J.gp(v_V_1617, "s"))
	v_k2_1624 = (J.mc(v_FX_1620, "key", [J.gp(v_r_1618, "sprite"), v_scared_1622]) if J.t(v_FX_1620) else J.gp(v_r_1618, "sprite"))
	v_h_1625 = (J.mc(v_FX_1620, "hgt", [J.gp(v_r_1618, "sprite"), v_k2_1624, v_h0_1623]) if J.t(v_FX_1620) else v_h0_1623)
	v_art_1626 = (not J.seq(v_k2_1624, J.gp(v_r_1618, "sprite")))
	var _t1635 = env["P"]
	v_q_1627 = J.cl(_t1635, null, [J.gp(v_a_1616, "x"), J.gp(v_lay_1619, "floor"), v_V_1617])
	v_rot_1628 = 0.0
	v_sy_1629 = 1.0
	v_sx_1630 = 0.0
	v_oy_1631 = 0.0
	v_al_1632 = 1.0
	v_sxs_1633 = 1.0
	v_tint_1634 = 0.0
	v_flip_1635 = J.cmp(J.gp(v_a_1616, "dir"), 0.0, "<")
	var _t1636 = J.seq(J.gp(v_a_1616, "act"), "bed")
	v_bed_1636 = (J.seq(J.gp(v_a_1616, "st"), "act") if _t1636 else _t1636)
	var _t1637 = J.cmp(J.gp(v_q_1627, "x"), (-80.0), "<")
	var _t1638 = (_t1637 if _t1637 else J.cmp(J.gp(v_q_1627, "x"), J.add(env["W"], 80.0), ">"))
	if J.t((_t1638 if _t1638 else J.gp(v_a_1616, "hid"))):
		return null
	var _t1640 = J.gp(env["S"], "light")
	var _t1639 = env["roomAt"]
	v_lit_1637 = J.gp(_t1640, J.cl(_t1639, null, [J.gp(v_a_1616, "x")]))
	var _t1641 = J.seq(J.gp(v_a_1616, "pose"), "sit")
	if (J.seq(J.gp(v_a_1616, "st"), "act") if _t1641 else _t1641):
		v_sy_1629 = 0.86
	if J.t(v_bed_1636):
		v_rot_1628 = (-1.45)
		var _t1642 = J.gp(J.gp(J.gp(v_lay_1619, "acts"), "bed"), "lift")
		var _t1643 = J.mul((-J.num((_t1642 if J.t(_t1642) else 60.0))), J.gp(v_V_1617, "s"))
		v_oy_1631 = _t1643
		var _t1644 = J.mul(v_h_1625, 0.45)
		v_sx_1630 = _t1644
	var _t1645 = J.seq(J.gp(v_a_1616, "act"), "shower")
	if (J.seq(J.gp(v_a_1616, "st"), "act") if _t1645 else _t1645):
		v_al_1632 = 0.85
	var _t1646 = J.seq(J.gp(v_a_1616, "st"), "cower")
	if J.t((_t1646 if _t1646 else J.gp(v_r_1618, "react"))):
		var _t1647 = J.add(v_sx_1630, (sin(J.num(J.mul(J.gp(env["S"], "t"), 40.0))) * 2.0))
		v_sx_1630 = _t1647
		var _t1648 = J.mul(v_sy_1629, 0.94)
		v_sy_1629 = _t1648
	if J.t(v_run_1621):
		var _t1649 = J.sub(v_oy_1631, (absf(J.num(sin(J.num(J.mul(J.gp(v_a_1616, "x"), 0.045))))) * 10.0))
		v_oy_1631 = _t1649
		var _t1650 = ((-J.num(J.gp(v_a_1616, "dir"))) * 0.18)
		v_rot_1628 = _t1650
		var _t1651 = (0.12 if J.t(v_art_1626) else 0.3)
		v_tint_1634 = _t1651
	var _t1652 = (J.cmp(J.gp(v_r_1618, "shockT"), 0.0, ">") if J.t(v_FX_1620) else v_FX_1620)
	var _t1653 = ((not J.t(v_run_1621)) if J.t(_t1652) else _t1652)
	if J.t(((not J.t(v_bed_1636)) if J.t(_t1653) else _t1653)):
		var _t1655 = J.gp(v_r_1618, "shockT")
		var _t1654 = J.gp(v_r_1618, "shockA")
		v_S0_1638 = J.mc(v_FX_1620, "shock", [_t1655, (_t1654 if J.t(_t1654) else 1.0)])
		var _t1656 = J.mul(v_sy_1629, J.gp(v_S0_1638, "sy"))
		v_sy_1629 = _t1656
		v_sxs_1633 = J.gp(v_S0_1638, "sx")
		var _t1657 = J.add(v_oy_1631, J.mul(J.gp(v_S0_1638, "jy"), v_h_1625))
		v_oy_1631 = _t1657
		var _t1658 = J.add(v_sx_1630, J.mul(J.gp(v_S0_1638, "sh"), v_h_1625))
		v_sx_1630 = _t1658
		var _t1659 = J.mul(J.gp(v_S0_1638, "tint"), (0.55 if J.t(v_art_1626) else 1.0))
		v_tint_1634 = _t1659
	else:
		var _t1661 = (J.gp(v_r_1618, "awake") if J.t(v_FX_1620) else v_FX_1620)
		if J.t(_t1661):
			var _t1660 = J.gp(v_r_1618, "fear")
			_t1661 = J.cmp((_t1660 if J.t(_t1660) else 0.0), 55.0, ">=")
		var _t1662 = ((not J.t(v_run_1621)) if J.t(_t1661) else _t1661)
		if J.t(((not J.t(v_bed_1636)) if J.t(_t1662) else _t1662)):
			v_T0_1639 = J.mc(v_FX_1620, "tremble", [v_r_1618, J.gp(env["S"], "t")])
			var _t1663 = J.add(v_sx_1630, J.mul(J.gp(v_T0_1639, "sh"), v_h_1625))
			v_sx_1630 = _t1663
			var _t1664 = J.mul(v_sy_1629, J.gp(v_T0_1639, "sy"))
			v_sy_1629 = _t1664
			var _t1665 = (not J.seq(J.gp(v_a_1616, "st"), "walk"))
			var _t1666 = ((not J.seq(J.gp(v_a_1616, "st"), "go")) if _t1665 else _t1665)
			if ((not J.leq(J.gp(v_T0_1639, "flip"), null)) if _t1666 else _t1666):
				v_flip_1635 = J.gp(v_T0_1639, "flip")
			v_tint_1634 = J.gp(v_T0_1639, "tint")
		else:
			var _t1667 = (not J.t(v_FX_1620))
			if (J.cmp(J.gp(v_r_1618, "jumpT"), 0.0, ">") if _t1667 else _t1667):
				var _t1668 = J.sub(v_oy_1631, (sin(J.num((J.div(J.sub(0.5, J.gp(v_r_1618, "jumpT")), 0.5) * PI))) * 16.0))
				v_oy_1631 = _t1668
	var _t1669 = (J.gp(v_r_1618, "shockN") if J.t(v_FX_1620) else v_FX_1620)
	if J.t(((not J.seq(J.gp(v_a_1616, "shkN"), J.gp(v_r_1618, "shockN"))) if J.t(_t1669) else _t1669)):
		var _t1670 = J.gp(v_r_1618, "shockN")
		J.sp(v_a_1616, "shkN", _t1670)
		v_j_1640 = 0.0
		while true:
			if not J.cmp(v_j_1640, 5.0, "<"): break
			var _t1671 = env["part"]
			J.cl(_t1671, null, [J.add(J.gp(v_a_1616, "x"), ((randf() - 0.5) * 30.0)), J.sub(J.gp(v_lay_1619, "floor"), J.mul(J.gp(v_lay_1619, "ph"), 0.85)), ((randf() - 0.5) * 220.0), ((-120.0) - (randf() * 90.0)), 0.8, "drop"])
			v_j_1640 = J.num(v_j_1640) + 1.0
	var _t1672 = env["c"]
	J.sp(_t1672, "fillStyle", "rgba(0,0,0,0.45)")
	J.mc(env["c"], "beginPath", [])
	J.mc(env["c"], "ellipse", [J.gp(v_q_1627, "x"), J.gp(v_q_1627, "y"), (J.mul(26.0, J.gp(v_V_1617, "s")) + 6.0), 6.0, 0.0, 0.0, 7.0])
	J.mc(env["c"], "fill", [])
	var _t1673 = (v_run_1621 if J.t(v_FX_1620) else v_FX_1620)
	if J.t(((not J.t(v_art_1626)) if J.t(_t1673) else _t1673)):
		J.mc(v_FX_1620, "arms", [env["c"], J.add(J.gp(v_q_1627, "x"), v_sx_1630), J.add(J.gp(v_q_1627, "y"), v_oy_1631), v_h_1625, J.gp(v_a_1616, "dir"), J.gp(env["S"], "t")])
	if J.t(v_FX_1620):
		J.mc(v_FX_1620, "draw", [env["c"], J.gp(v_r_1618, "sprite"), v_k2_1624, J.add(J.gp(v_q_1627, "x"), v_sx_1630), J.add(J.gp(v_q_1627, "y"), v_oy_1631), v_h_1625, {"flip": v_flip_1635, "rot": v_rot_1628, "sy": v_sy_1629, "sx": v_sxs_1633, "alpha": v_al_1632, "tint": v_tint_1634}])
	else:
		var _t1674 = env["sprite"]
		J.cl(_t1674, null, [J.gp(v_r_1618, "sprite"), J.add(J.gp(v_q_1627, "x"), v_sx_1630), J.add(J.gp(v_q_1627, "y"), v_oy_1631), v_h_1625, {"flip": v_flip_1635, "rot": v_rot_1628, "sy": v_sy_1629, "alpha": v_al_1632}])
	var _t1675 = J.seq(J.gp(v_a_1616, "act"), "shower")
	if (J.seq(J.gp(v_a_1616, "st"), "act") if _t1675 else _t1675):
		v_i_1641 = 0.0
		while true:
			if not J.cmp(v_i_1641, 3.0, "<"): break
			var _t1676 = env["c"]
			J.sp(_t1676, "fillStyle", "rgba(220,230,235,0.18)")
			J.mc(env["c"], "beginPath", [])
			J.mc(env["c"], "arc", [J.add(J.gp(v_q_1627, "x"), J.mul((J.sub(v_i_1641, 1.0) * 30.0), J.gp(v_V_1617, "s"))), (J.sub(J.gp(v_q_1627, "y"), J.mul(v_h_1625, (0.4 + J.mul(0.2, v_i_1641)))) - J.mod((J.mul(J.gp(env["S"], "t"), 20.0) + J.mul(v_i_1641, 10.0)), 20.0)), (J.mul(24.0, J.gp(v_V_1617, "s")) + 8.0), 0.0, 7.0])
			J.mc(env["c"], "fill", [])
			v_i_1641 = J.num(v_i_1641) + 1.0
	if J.t(((not J.t(J.gp(v_r_1618, "awake"))) if J.t(v_bed_1636) else v_bed_1636)):
		var _t1677 = env["txt"]
		J.cl(_t1677, null, ["Z", J.add(J.gp(v_q_1627, "x"), J.mul(v_h_1625, 0.5)), (J.sub(J.add(J.gp(v_q_1627, "y"), v_oy_1631), J.mul(v_h_1625, 0.25)) - J.mod(J.mul(J.gp(env["S"], "t"), 14.0), 14.0)), 15.0, "#c8d8ff"])
		var _t1678 = env["txt"]
		J.cl(_t1678, null, ["z", J.add(J.gp(v_q_1627, "x"), J.mul(v_h_1625, 0.6)), (J.sub(J.add(J.gp(v_q_1627, "y"), v_oy_1631), J.mul(v_h_1625, 0.35)) - J.mod((J.mul(J.gp(env["S"], "t"), 14.0) + 7.0), 14.0)), 11.0, "#c8d8ff"])
	v_top_1642 = J.sub(J.add(J.gp(v_q_1627, "y"), v_oy_1631), (J.mul(v_h_1625, 0.35) if J.t(v_bed_1636) else J.mul(v_h_1625, J.min_([1.0, v_sy_1629]))))
	if J.t((J.cmp(J.gp(v_r_1618, "shockT"), 0.0, ">") if J.t(v_FX_1620) else v_FX_1620)):
		J.mc(v_FX_1620, "bang", [env["c"], J.add(J.gp(v_q_1627, "x"), v_sx_1630), J.sub(v_top_1642, 10.0), (1.0 - J.div(J.gp(v_r_1618, "shockT"), 0.9)), 1.1])
	else:
		if J.t((v_run_1621 if J.t(v_FX_1620) else v_FX_1620)):
			J.mc(v_FX_1620, "bang", [env["c"], J.gp(v_q_1627, "x"), J.sub(v_top_1642, 8.0), 0.5, 0.9])
	var _t1679 = J.cmp(J.gp(v_r_1618, "fear"), 0.0, ">")
	if ((not J.t(v_run_1621)) if _t1679 else _t1679):
		J.mc(env["A"], "crBar", [env["c"], J.sub(J.gp(v_q_1627, "x"), 24.0), J.sub(v_top_1642, 12.0), 48.0, 8.0, J.div(J.gp(v_r_1618, "fear"), 100.0), "red"])
	var _t1680 = J.gp(v_a_1616, "saw")
	var _t1681 = (J.cmp(J.gp(v_a_1616, "seeT"), 0.2, ">") if J.t(_t1680) else _t1680)
	if J.t(((not J.cmp(J.gp(v_r_1618, "shockT"), 0.0, ">")) if J.t(_t1681) else _t1681)):
		var _t1682 = env["txt"]
		J.cl(_t1682, null, ["！", J.gp(v_q_1627, "x"), J.sub(v_top_1642, 18.0), 26.0, "#ffe25a"])
	if J.t((J.gp(v_r_1618, "scream") if J.t(v_FX_1620) else v_FX_1620)):
		var _t1684 = env["c"]
		var _t1683 = env["clamp"]
		J.mc(v_FX_1620, "scream", [_t1684, J.cl(_t1683, null, [J.gp(v_q_1627, "x"), 90.0, J.sub(env["W"], 90.0)]), J.sub(v_top_1642, 24.0), J.gp(v_r_1618, "scream"), 1.15])
	if J.t(J.gp(v_r_1618, "say")):
		var _t1685 = env["bubble"]
		J.cl(_t1685, null, [J.gp(v_q_1627, "x"), J.sub(v_top_1642, (18.0 if J.cmp(J.gp(v_r_1618, "fear"), 0.0, ">") else 6.0)), J.gp(v_r_1618, "say")])

func _f279(this_, a: Array, env):
	var v_V_1645 = null; var v_g_1646 = null; var v_lay_1647 = null; var v_gr_1648 = null; var v_lit_1649 = null; var v_h_1650 = null; var v_q_1651 = null; var v_key_1652 = null; var v_by_1653 = null; var v_sy_1654 = null; var v_rot_1655 = null; var v_ox_1656 = null; var v_oy_1657 = null; var v_al_1658 = null; var v_t_1659 = null; var v_k_1660 = null; var v_sq_1661 = null; var v_a_1662 = null; var v_aq_1663 = null; var v_u_1664 = null; var v_k2_1665 = null; var v_ah_1666 = null; var v_i_1667 = null; var v_tx_1668 = null; var v_cy_1669 = null; var v_hx_1670 = null; var v_j_1671 = null
	v_V_1645 = J.arg(a, 0)
	v_g_1646 = J.gp(env["S"], "g")
	v_lay_1647 = J.gp(env["S"], "lay")
	var _t1686 = env["roomAt"]
	v_gr_1648 = J.cl(_t1686, null, [J.gp(env["S"], "gx")])
	var _t1687 = J.gp(J.gp(env["S"], "light"), v_gr_1648)
	v_lit_1649 = (J.cmp(J.gp(env["S"], "invT"), 0.0, "<=") if J.t(_t1687) else _t1687)
	v_h_1650 = J.mul((J.mul(J.gp(v_lay_1647, "ph"), 0.74) * J.div(J.gp(J.gp(v_g_1646, "d"), "h"), 76.0)), J.gp(v_V_1645, "s"))
	var _t1688 = env["P"]
	v_q_1651 = J.cl(_t1688, null, [J.gp(env["S"], "gx"), J.gp(v_lay_1647, "floor"), v_V_1645])
	v_key_1652 = J.gp(J.gp(v_g_1646, "d"), "sprite")
	v_by_1653 = J.gp(v_q_1651, "y")
	v_sy_1654 = 1.0
	v_rot_1655 = 0.0
	v_ox_1656 = 0.0
	v_oy_1657 = 0.0
	v_al_1658 = (0.25 if J.cmp(J.gp(env["S"], "invT"), 0.0, ">") else (0.92 if J.t(v_lit_1649) else 0.5))
	var _t1689 = J.seq(J.gp(J.gp(v_g_1646, "d"), "key"), "tianhua")
	var _t1691 = (J.cmp(J.gp(env["S"], "gmv"), 0.0, "<=") if _t1689 else _t1689)
	if J.t(_t1691):
		var _t1690 = env["img"]
		_t1691 = J.cl(_t1690, null, ["tianhua_hang"])
	if J.t(_t1691):
		v_key_1652 = "tianhua_hang"
		var _t1692 = env["P"]
		var _t1693 = J.add(J.gp(J.cl(_t1692, null, [0.0, J.add(J.gp(v_lay_1647, "ceil"), 20.0), v_V_1645]), "y"), J.mul(v_h_1650, 1.05))
		v_by_1653 = _t1693
	else:
		if J.cmp(J.gp(env["S"], "gmv"), 0.0, ">"):
			var _t1694 = ((-absf(J.num(sin(J.num(J.mul(J.gp(env["S"], "t"), 12.0)))))) * 6.0)
			v_oy_1657 = _t1694
			var _t1695 = J.mul(J.gp(env["S"], "gdir"), 0.08)
			v_rot_1655 = _t1695
		else:
			var _t1696 = ((sin(J.num(J.mul(J.gp(env["S"], "t"), 2.5))) * 4.0) - 4.0)
			v_oy_1657 = _t1696
	if J.t(J.gp(env["S"], "sc")):
		v_t_1659 = J.gp(J.gp(env["S"], "sc"), "t")
		if J.cmp(v_t_1659, env["OMEN"], "<"):
			v_k_1660 = J.div(v_t_1659, env["OMEN"])
			var _t1697 = env["c"]
			var _t1698 = J.add(J.add(J.gp({"eking": "rgba(210,90,40,", "toyol": "rgba(120,220,140,", "tianhua": "rgba(110,190,255,"}, J.gp(J.gp(v_g_1646, "d"), "key")), J.mul(0.3, v_k_1660)), ")")
			J.sp(_t1697, "fillStyle", _t1698)
			J.mc(env["c"], "beginPath", [])
			J.mc(env["c"], "arc", [J.gp(v_q_1651, "x"), J.sub(v_by_1653, J.mul(v_h_1650, 0.5)), (J.mul(v_h_1650, 0.6) * (0.6 + J.mul(0.4, v_k_1660))), 0.0, 7.0])
			J.mc(env["c"], "fill", [])
			var _t1699 = (1.0 - J.mul(0.08, v_k_1660))
			v_sy_1654 = _t1699
		else:
			var _t1700 = (J.mul(J.mul(J.gp(env["S"], "gdir"), 30.0), J.gp(v_V_1645, "s")) * sin(J.num((J.min_([1.0, J.div(J.sub(v_t_1659, env["OMEN"]), 0.3)]) * PI))))
			v_ox_1656 = _t1700
	if J.cmp(J.gp(env["S"], "stun"), 0.0, ">"):
		var _t1701 = env["txt"]
		J.cl(_t1701, null, ["一、二、三……", J.gp(v_q_1651, "x"), (J.sub(v_by_1653, v_h_1650) - 10.0), 14.0, "#b8f0a0"])
	J.mc(env["c"], "save", [])
	var _t1702 = env["c"]
	J.sp(_t1702, "shadowColor", "rgba(140,255,200,0.85)")
	var _t1703 = env["c"]
	var _t1704 = (4.0 if J.t(v_lit_1649) else 14.0)
	J.sp(_t1703, "shadowBlur", _t1704)
	var _t1705 = env["sprite"]
	J.cl(_t1705, null, [v_key_1652, J.add(J.gp(v_q_1651, "x"), v_ox_1656), J.add(v_by_1653, v_oy_1657), v_h_1650, {"flip": J.cmp(J.gp(env["S"], "gdir"), 0.0, "<"), "alpha": v_al_1658, "rot": v_rot_1655, "sy": v_sy_1654}])
	J.mc(env["c"], "restore", [])
	var _t1706 = env["c"]
	J.sp(_t1706, "fillStyle", "rgba(110,255,190,0.35)")
	J.mc(env["c"], "beginPath", [])
	J.mc(env["c"], "ellipse", [J.gp(v_q_1651, "x"), J.gp(v_q_1651, "y"), (J.mul(30.0, J.gp(v_V_1645, "s")) + 8.0), 7.0, 0.0, 0.0, 7.0])
	J.mc(env["c"], "fill", [])
	var _t1707 = (not J.t(v_lit_1649))
	if (J.cmp(J.gp(env["S"], "invT"), 0.0, "<=") if _t1707 else _t1707):
		var _t1708 = env["txt"]
		J.cl(_t1708, null, ["黑暗中", J.gp(v_q_1651, "x"), J.add(J.gp(v_q_1651, "y"), 16.0), 11.0, "#a9c79a"])
	else:
		if J.t((J.cmp(J.gp(env["S"], "invT"), 0.0, "<=") if J.t(v_lit_1649) else v_lit_1649)):
			var _t1709 = env["txt"]
			J.cl(_t1709, null, ["現形！燈著咗", J.gp(v_q_1651, "x"), J.add(J.gp(v_q_1651, "y"), 16.0), 12.0, "#e48a78"])
	if J.cmp(J.gp(env["S"], "searchP"), 0.0, ">"):
		var _t1713 = null
		if J.seq(J.gp(env["S"], "searchI"), 99.0):
			var _t1710 = env["P"]
			_t1713 = J.cl(_t1710, null, [J.gp(J.gp(env["S"], "task"), "x"), J.gp(J.gp(env["S"], "task"), "y"), v_V_1645])
		else:
			var _t1712 = null
			if J.t(J.gp(J.gp(env["S"], "search"), J.gp(env["S"], "searchI"))):
				var _t1711 = env["P"]
				_t1712 = J.cl(_t1711, null, [J.gp(J.gp(J.gp(env["S"], "search"), J.gp(env["S"], "searchI")), "x"), J.gp(J.gp(J.gp(env["S"], "search"), J.gp(env["S"], "searchI")), "y"), v_V_1645])
			else:
				_t1712 = v_q_1651
			_t1713 = _t1712
		v_sq_1661 = _t1713
		var _t1714 = env["c"]
		J.sp(_t1714, "strokeStyle", "#b2d394")
		var _t1715 = env["c"]
		J.sp(_t1715, "lineWidth", 5.0)
		J.mc(env["c"], "beginPath", [])
		J.mc(env["c"], "arc", [J.gp(v_sq_1661, "x"), J.sub(J.gp(v_sq_1661, "y"), 30.0), 16.0, J.div((-PI), 2.0), (J.div((-PI), 2.0) + J.mul((PI * 2.0), J.gp(env["S"], "searchP")))])
		J.mc(env["c"], "stroke", [])
	var _t1716 = J.gp(env["S"], "sc")
	if J.t((J.cmp(J.gp(J.gp(env["S"], "sc"), "t"), env["OMEN"], ">=") if J.t(_t1716) else _t1716)):
		v_a_1662 = J.gp(J.gp(env["S"], "sc"), "a")
		var _t1717 = env["P"]
		v_aq_1663 = J.cl(_t1717, null, [J.gp(v_a_1662, "x"), J.gp(v_lay_1647, "floor"), v_V_1645])
		v_u_1664 = J.min_([1.0, J.div(J.sub(J.gp(J.gp(env["S"], "sc"), "t"), env["OMEN"]), 0.4)])
		v_k2_1665 = J.gp(J.gp(v_g_1646, "d"), "key")
		v_ah_1666 = J.mul(J.gp(v_lay_1647, "ph"), J.gp(v_V_1645, "s"))
		if J.seq(v_k2_1665, "eking"):
			J.mc(env["c"], "save", [])
			var _t1718 = env["c"]
			var _t1719 = (1.0 - J.max_([0.0, J.div((J.sub(J.gp(J.gp(env["S"], "sc"), "t"), env["OMEN"]) - 0.5), 0.4)]))
			J.sp(_t1718, "globalAlpha", _t1719)
			var _t1720 = env["c"]
			J.sp(_t1720, "fillStyle", "#120808")
			J.mc(env["c"], "beginPath", [])
			J.mc(env["c"], "ellipse", [J.gp(v_aq_1663, "x"), J.sub(J.gp(v_aq_1663, "y"), J.mul(v_ah_1666, 0.55)), J.mul(J.mul(v_ah_1666, 0.5), v_u_1664), J.mul(J.mul(v_ah_1666, 0.38), v_u_1664), 0.0, 0.0, 7.0])
			J.mc(env["c"], "fill", [])
			var _t1721 = env["c"]
			J.sp(_t1721, "fillStyle", "#7a0e0e")
			J.mc(env["c"], "beginPath", [])
			J.mc(env["c"], "ellipse", [J.gp(v_aq_1663, "x"), J.sub(J.gp(v_aq_1663, "y"), J.mul(v_ah_1666, 0.55)), J.mul(J.mul(v_ah_1666, 0.4), v_u_1664), (J.mul(J.mul(v_ah_1666, 0.24), v_u_1664) * absf(J.num(sin(J.num(J.mul(J.gp(env["S"], "t"), 12.0)))))), 0.0, 0.0, 7.0])
			J.mc(env["c"], "fill", [])
			var _t1722 = env["c"]
			J.sp(_t1722, "fillStyle", "#e8e0cc")
			v_i_1667 = 0.0
			while true:
				if not J.cmp(v_i_1667, 7.0, "<"): break
				v_tx_1668 = (J.sub(J.gp(v_aq_1663, "x"), J.mul(J.mul(v_ah_1666, 0.32), v_u_1664)) + J.mul((J.mul(v_i_1667, v_ah_1666) * 0.1), v_u_1664))
				J.mc(env["c"], "beginPath", [])
				J.mc(env["c"], "moveTo", [v_tx_1668, (J.sub(J.gp(v_aq_1663, "y"), J.mul(v_ah_1666, 0.55)) - J.mul(J.mul(v_ah_1666, 0.2), v_u_1664))])
				J.mc(env["c"], "lineTo", [J.add(v_tx_1668, J.mul(J.mul(v_ah_1666, 0.05), v_u_1664)), (J.sub(J.gp(v_aq_1663, "y"), J.mul(v_ah_1666, 0.55)) - J.mul(J.mul(v_ah_1666, 0.08), v_u_1664))])
				J.mc(env["c"], "lineTo", [J.add(v_tx_1668, J.mul(J.mul(v_ah_1666, 0.1), v_u_1664)), (J.sub(J.gp(v_aq_1663, "y"), J.mul(v_ah_1666, 0.55)) - J.mul(J.mul(v_ah_1666, 0.2), v_u_1664))])
				J.mc(env["c"], "fill", [])
				v_i_1667 = J.num(v_i_1667) + 1.0
			J.mc(env["c"], "restore", [])
		if J.seq(v_k2_1665, "tianhua"):
			var _t1723 = env["c"]
			J.sp(_t1723, "strokeStyle", "rgba(12,12,14,0.9)")
			var _t1724 = env["c"]
			J.sp(_t1724, "lineWidth", 2.4)
			var _t1725 = env["P"]
			v_cy_1669 = J.gp(J.cl(_t1725, null, [0.0, J.add(J.gp(v_lay_1647, "ceil"), 10.0), v_V_1645]), "y")
			v_hx_1670 = (-60.0)
			while true:
				if not J.cmp(v_hx_1670, 60.0, "<="): break
				J.mc(env["c"], "beginPath", [])
				J.mc(env["c"], "moveTo", [J.add(J.gp(v_aq_1663, "x"), J.mul(v_hx_1670, J.gp(v_V_1645, "s"))), v_cy_1669])
				J.mc(env["c"], "quadraticCurveTo", [J.add(J.add(J.gp(v_aq_1663, "x"), J.mul(v_hx_1670, J.gp(v_V_1645, "s"))), (sin(J.num(J.add(J.mul(J.gp(env["S"], "t"), 6.0), v_hx_1670))) * 10.0)), J.add(v_cy_1669, J.mul((J.sub(J.gp(v_aq_1663, "y"), v_cy_1669) * 0.5), v_u_1664)), J.add(J.gp(v_aq_1663, "x"), J.mul(v_hx_1670, J.gp(v_V_1645, "s"))), J.add(v_cy_1669, J.mul((J.sub(J.gp(v_aq_1663, "y"), v_cy_1669) * 0.85), v_u_1664))])
				J.mc(env["c"], "stroke", [])
				var _t1726 = J.add(v_hx_1670, 7.0)
				v_hx_1670 = _t1726
		if J.seq(v_k2_1665, "toyol"):
			v_j_1671 = 0.0
			while true:
				if not J.cmp(v_j_1671, 6.0, "<"): break
				var _t1727 = env["c"]
				J.sp(_t1727, "fillStyle", "rgba(40,30,20,0.8)")
				J.mc(env["c"], "beginPath", [])
				J.mc(env["c"], "ellipse", [(J.sub(J.gp(v_aq_1663, "x"), J.mul(80.0, J.gp(v_V_1645, "s"))) + J.mul(J.mul(v_j_1671, 28.0), J.gp(v_V_1645, "s"))), J.sub(J.gp(v_aq_1663, "y"), 4.0), 6.0, 3.0, 0.0, 0.0, 7.0])
				J.mc(env["c"], "fill", [])
				v_j_1671 = J.num(v_j_1671) + 1.0
			var _t1728 = env["sprite"]
			J.cl(_t1728, null, ["toyol", J.add(J.gp(v_aq_1663, "x"), (sin(J.num(J.mul(J.gp(env["S"], "t"), 20.0))) * 20.0)), J.sub(J.gp(v_aq_1663, "y"), J.mul(v_ah_1666, 0.6)), J.mul(v_ah_1666, 0.45), {"alpha": 0.8}])

func _f281(this_, a: Array, env):
	var v_R_1683 = null; var v_i_1684 = null; var v_a_1685 = null; var v_b_1686 = null; var v_gr_1687 = null
	v_R_1683 = J.arg(a, 0)
	v_i_1684 = J.arg(a, 1)
	var _t1740 = env["__p"]["P"]
	v_a_1685 = J.cl(_t1740, null, [J.gp(v_R_1683, "x0"), J.gp(J.gp(env["lay"], "crop"), 0.0), env["V"]])
	var _t1741 = env["__p"]["P"]
	v_b_1686 = J.cl(_t1741, null, [J.gp(v_R_1683, "x1"), J.gp(J.gp(env["lay"], "crop"), 1.0), env["V"]])
	var _t1742 = J.cmp(J.gp(v_b_1686, "x"), 0.0, "<")
	if (_t1742 if _t1742 else J.cmp(J.gp(v_a_1685, "x"), env["__p"]["W"], ">")):
		return null
	if (not J.t(J.gp(J.gp(env["__p"]["S"], "light"), v_i_1684))):
		var _t1743 = env["__p"]["c"]
		var _t1744 = (J.add("rgba(4,4,14,", (0.74 if J.cmp(J.gp(J.gp(env["__p"]["S"], "dark"), v_i_1684), 0.0, ">") else 0.6)) + ")")
		J.sp(_t1743, "fillStyle", _t1744)
		J.mc(env["__p"]["c"], "fillRect", [J.gp(v_a_1685, "x"), J.gp(v_a_1685, "y"), J.sub(J.gp(v_b_1686, "x"), J.gp(v_a_1685, "x")), J.sub(J.gp(v_b_1686, "y"), J.gp(v_a_1685, "y"))])
	else:
		v_gr_1687 = J.mc(env["__p"]["c"], "createRadialGradient", [J.div(J.add(J.gp(v_a_1685, "x"), J.gp(v_b_1686, "x")), 2.0), J.add(J.gp(v_a_1685, "y"), 30.0), 10.0, J.div(J.add(J.gp(v_a_1685, "x"), J.gp(v_b_1686, "x")), 2.0), J.add(J.gp(v_a_1685, "y"), 30.0), (J.sub(J.gp(v_b_1686, "x"), J.gp(v_a_1685, "x")) * 0.8)])
		J.mc(v_gr_1687, "addColorStop", [0.0, "rgba(255,226,160,0.12)"])
		J.mc(v_gr_1687, "addColorStop", [1.0, "rgba(255,226,160,0)"])
		var _t1745 = env["__p"]["c"]
		J.sp(_t1745, "fillStyle", v_gr_1687)
		J.mc(env["__p"]["c"], "fillRect", [J.gp(v_a_1685, "x"), J.gp(v_a_1685, "y"), J.sub(J.gp(v_b_1686, "x"), J.gp(v_a_1685, "x")), J.sub(J.gp(v_b_1686, "y"), J.gp(v_a_1685, "y"))])
	var _t1746 = env["__p"]["txt"]
	J.cl(_t1746, null, [J.add(J.gp(v_R_1683, "n"), ("・燈著" if J.t(J.gp(J.gp(env["__p"]["S"], "light"), v_i_1684)) else "・黑")), J.div(J.add(J.gp(v_a_1685, "x"), J.gp(v_b_1686, "x")), 2.0), J.add(J.gp(v_a_1685, "y"), 20.0), 12.0, ("#e8d2a0" if J.t(J.gp(J.gp(env["__p"]["S"], "light"), v_i_1684)) else "#8a7e84")])

func _f282(this_, a: Array, env):
	var v_p_1690 = null
	v_p_1690 = J.arg(a, 0)
	var _t1752 = env["__p"]["drawSpot"]
	J.cl(_t1752, null, [v_p_1690, env["V"]])

func _f284(this_, a: Array, env):
	var v_k_1701 = null
	v_k_1701 = J.arg(a, 0)
	if (not J.t(J.gp(env["cnt"], v_k_1701))):
		var _t1758 = env["cnt"]
		J.sp(_t1758, v_k_1701, 0.0)
		J.mc(env["ord"], "push", [v_k_1701])
	var _t1759 = env["cnt"]
	J.sp(_t1759, v_k_1701, J.num(J.gp(_t1759, v_k_1701)) + 1.0)

func _f285(this_, a: Array, env):
	var v_k_1704 = null
	v_k_1704 = J.arg(a, 0)
	return J.add(J.gp(J.gp(J.gp(env["__p"]["__p"]["A"], "ITEM"), v_k_1704), "n"), (J.add("×", J.gp(env["cnt"], v_k_1704)) if J.cmp(J.gp(env["cnt"], v_k_1704), 1.0, ">") else ""))

func _f283(this_, a: Array, env):
	var v_p_1693 = null; var v_i_1694 = null; var v_its_1695 = null; var v_q_1696 = null
	var _s701 = {"__p": env, "cnt": null, "ord": null}
	v_p_1693 = J.arg(a, 0)
	v_i_1694 = J.arg(a, 1)
	var _t1754 = _s701["__p"]["__p"]["itemsAt"]
	v_its_1695 = J.cl(_t1754, null, [v_i_1694])
	if (not J.t(J.len(v_its_1695))):
		return null
	var _t1755 = _s701["__p"]["__p"]["P"]
	v_q_1696 = J.cl(_t1755, null, [J.gp(v_p_1693, "x"), J.gp(v_p_1693, "y"), _s701["__p"]["V"]])
	var _t1756 = _s701["__p"]["__p"]["c"]
	var _t1757 = (J.add("rgba(230,168,90,", (0.5 + (0.3 * sin(J.num(J.add(J.mul(J.gp(_s701["__p"]["__p"]["S"], "t"), 3.0), v_i_1694)))))) + ")")
	J.sp(_t1756, "fillStyle", _t1757)
	J.mc(_s701["__p"]["__p"]["c"], "beginPath", [])
	J.mc(_s701["__p"]["__p"]["c"], "arc", [J.gp(v_q_1696, "x"), J.gp(v_q_1696, "y"), 6.0, 0.0, 7.0])
	J.mc(_s701["__p"]["__p"]["c"], "fill", [])
	_s701["cnt"] = {}
	_s701["ord"] = []
	J.mc(v_its_1695, "forEach", [Callable(self, "_f284").bind(_s701)])
	var _t1760 = _s701["__p"]["__p"]["txt"]
	var _t1761 = J.mc(_s701["ord"], "map", [Callable(self, "_f285").bind(_s701)])
	J.cl(_t1760, null, [J.add("✦", J.mc(_t1761, "join", [" "])), J.gp(v_q_1696, "x"), J.sub(J.gp(v_q_1696, "y"), 12.0), 11.0, "#e6dcc6"])

func _f286(this_, a: Array, env):
	var v_a_1707 = null; var v_b_1708 = null
	v_a_1707 = J.arg(a, 0)
	v_b_1708 = J.arg(a, 1)
	return ((-1.0) if J.seq(J.gp(v_a_1707, "act"), "bed") else 0.0)

func _f287(this_, a: Array, env):
	var v_a_1711 = null
	v_a_1711 = J.arg(a, 0)
	var _t1770 = env["__p"]["drawActor"]
	J.cl(_t1770, null, [v_a_1711, env["V"]])

func _f288(this_, a: Array, env):
	var v_p_1714 = null; var v_q_1715 = null; var v_a_1716 = null
	v_p_1714 = J.arg(a, 0)
	var _t1773 = env["__p"]["P"]
	v_q_1715 = J.cl(_t1773, null, [J.gp(v_p_1714, "x"), J.gp(v_p_1714, "y"), env["V"]])
	v_a_1716 = J.div(J.gp(v_p_1714, "life"), J.gp(v_p_1714, "max"))
	var _t1774 = env["__p"]["c"]
	var _t1775 = J.min_([1.0, J.mul(v_a_1716, 1.4)])
	J.sp(_t1774, "globalAlpha", _t1775)
	var _t1776 = env["__p"]["c"]
	var _t1777 = ("#9fd0f0" if J.seq(J.gp(v_p_1714, "type"), "drop") else ("#e6c25a" if J.seq(J.gp(v_p_1714, "type"), "coin") else ("rgba(180,170,150,0.6)" if J.seq(J.gp(v_p_1714, "type"), "dust") else ("#e8c07a" if J.seq(J.gp(v_p_1714, "type"), "crumb") else "#f0e0b0"))))
	J.sp(_t1776, "fillStyle", _t1777)
	J.mc(env["__p"]["c"], "beginPath", [])
	J.mc(env["__p"]["c"], "arc", [J.gp(v_q_1715, "x"), J.gp(v_q_1715, "y"), (((6.0 * J.sub(1.0, v_a_1716)) + 2.0) if J.seq(J.gp(v_p_1714, "type"), "dust") else 3.0), 0.0, 7.0])
	J.mc(env["__p"]["c"], "fill", [])
	var _t1778 = env["__p"]["c"]
	J.sp(_t1778, "globalAlpha", 1.0)

func _f289(this_, a: Array, env):
	var v_f_1719 = null; var v_q_1720 = null
	v_f_1719 = J.arg(a, 0)
	var _t1780 = env["__p"]["P"]
	v_q_1720 = J.cl(_t1780, null, [J.gp(v_f_1719, "x"), J.gp(v_f_1719, "y"), env["V"]])
	var _t1781 = env["__p"]["c"]
	var _t1782 = J.min_([1.0, J.gp(v_f_1719, "life")])
	J.sp(_t1781, "globalAlpha", _t1782)
	var _t1783 = env["__p"]["txt"]
	var _t1785 = J.gp(v_f_1719, "t")
	var _t1784 = env["__p"]["clamp"]
	J.cl(_t1783, null, [_t1785, J.cl(_t1784, null, [J.gp(v_q_1720, "x"), 80.0, J.sub(env["__p"]["W"], 80.0)]), J.gp(v_q_1720, "y"), 15.0, J.gp(v_f_1719, "c")])
	var _t1786 = env["__p"]["c"]
	J.sp(_t1786, "globalAlpha", 1.0)

func _f280(this_, a: Array, env):
	var v_g0_1676 = null; var v_fx_1677 = null; var v_tgt_1678 = null; var v_dq_1679 = null; var v_tq_1680 = null
	var _s695 = {"__p": env, "V": null, "lay": null}
	J.cl(_s695["__p"]["layout"], null, [])
	J.mc(_s695["__p"]["c"], "setTransform", [_s695["__p"]["DPR"], 0.0, 0.0, _s695["__p"]["DPR"], 0.0, 0.0])
	var _t1729 = _s695["__p"]["c"]
	J.sp(_t1729, "fillStyle", "#0b0b0d")
	J.mc(_s695["__p"]["c"], "fillRect", [0.0, 0.0, _s695["__p"]["W"], _s695["__p"]["H"]])
	var _t1730 = []
	_s695["__p"]["BTN"] = _t1730
	_s695["V"] = J.cl(_s695["__p"]["view"], null, [])
	_s695["lay"] = J.gp(_s695["__p"]["S"], "lay")
	v_g0_1676 = J.cl(_s695["__p"]["G"], null, [])
	v_fx_1677 = J.gp(_s695["__p"]["S"], "gx")
	var _t1731 = J.gp(_s695["__p"]["S"], "sc")
	if J.t((J.gp(J.gp(_s695["__p"]["S"], "sc"), "a") if J.t(_t1731) else _t1731)):
		var _t1732 = J.div(J.add(J.gp(_s695["__p"]["S"], "gx"), J.gp(J.gp(J.gp(_s695["__p"]["S"], "sc"), "a"), "x")), 2.0)
		v_fx_1677 = _t1732
	v_tgt_1678 = (J.gp(J.gp(_s695["__p"]["S"], "cam"), "free") if (not J.leq(J.gp(J.gp(_s695["__p"]["S"], "cam"), "free"), null)) else J.sub(v_fx_1677, J.div(J.gp(_s695["V"], "vw"), 2.0)))
	var _t1733 = _s695["__p"]["clamp"]
	var _t1734 = J.cl(_t1733, null, [v_tgt_1678, 0.0, J.max_([0.0, J.sub(J.gp(_s695["lay"], "W"), J.gp(_s695["V"], "vw"))])])
	v_tgt_1678 = _t1734
	var _t1735 = J.gp(_s695["__p"]["S"], "cam")
	var _t1736 = J.add(J.gp(_t1735, "x"), (J.sub(v_tgt_1678, J.gp(J.gp(_s695["__p"]["S"], "cam"), "x")) * 0.18))
	J.sp(_t1735, "x", _t1736)
	if (absf(J.num(J.sub(v_tgt_1678, J.gp(J.gp(_s695["__p"]["S"], "cam"), "x")))) < 0.5):
		var _t1737 = J.gp(_s695["__p"]["S"], "cam")
		J.sp(_t1737, "x", v_tgt_1678)
	J.mc(_s695["__p"]["c"], "save", [])
	J.mc(_s695["__p"]["c"], "beginPath", [])
	J.mc(_s695["__p"]["c"], "rect", [0.0, J.gp(_s695["V"], "top"), _s695["__p"]["W"], J.gp(_s695["V"], "ph")])
	J.mc(_s695["__p"]["c"], "clip", [])
	if J.cmp(J.gp(_s695["__p"]["S"], "flash"), 0.0, ">"):
		J.mc(_s695["__p"]["c"], "translate", [J.mul(((randf() - 0.5) * 8.0), J.gp(_s695["__p"]["S"], "flash")), 0.0])
	var _t1738 = _s695["__p"]["drawBG"]
	J.cl(_t1738, null, [_s695["V"]])
	var _t1739 = J.gp(_s695["lay"], "rooms")
	J.mc(_t1739, "forEach", [Callable(self, "_f281").bind(_s695)])
	var _t1747 = _s695["__p"]["P"]
	v_dq_1679 = J.cl(_t1747, null, [J.gp(_s695["lay"], "door"), J.gp(_s695["lay"], "floor"), _s695["V"]])
	var _t1748 = _s695["__p"]["c"]
	var _t1749 = (J.add("rgba(120,255,190,", (0.2 + (0.15 * sin(J.num(J.mul(J.gp(_s695["__p"]["S"], "t"), 4.0)))))) + ")")
	J.sp(_t1748, "fillStyle", _t1749)
	J.mc(_s695["__p"]["c"], "fillRect", [J.sub(J.gp(v_dq_1679, "x"), 16.0), J.sub(J.gp(v_dq_1679, "y"), (J.mul(J.gp(_s695["lay"], "ph"), J.gp(_s695["V"], "s")) * 1.05)), 32.0, (J.mul(J.gp(_s695["lay"], "ph"), J.gp(_s695["V"], "s")) * 1.05)])
	var _t1750 = _s695["__p"]["txt"]
	J.cl(_t1750, null, ["門口", J.gp(v_dq_1679, "x"), (J.sub(J.gp(v_dq_1679, "y"), (J.mul(J.gp(_s695["lay"], "ph"), J.gp(_s695["V"], "s")) * 1.05)) - 6.0), 12.0, "#a9c79a"])
	var _t1751 = J.gp(_s695["__p"]["S"], "spots")
	J.mc(_t1751, "forEach", [Callable(self, "_f282").bind(_s695)])
	var _t1753 = J.gp(_s695["__p"]["S"], "search")
	J.mc(_t1753, "forEach", [Callable(self, "_f283").bind(_s695)])
	var _t1762 = J.seq(J.gp(J.gp(_s695["__p"]["S"], "task"), "k"), "steal")
	if ((not J.t(J.gp(J.gp(_s695["__p"]["S"], "task"), "done"))) if _t1762 else _t1762):
		var _t1763 = _s695["__p"]["P"]
		v_tq_1680 = J.cl(_t1763, null, [J.gp(J.gp(_s695["__p"]["S"], "task"), "x"), J.gp(J.gp(_s695["__p"]["S"], "task"), "y"), _s695["V"]])
		var _t1764 = _s695["__p"]["c"]
		var _t1765 = (J.add("rgba(178,211,148,", (0.6 + (0.3 * sin(J.num(J.mul(J.gp(_s695["__p"]["S"], "t"), 5.0)))))) + ")")
		J.sp(_t1764, "strokeStyle", _t1765)
		var _t1766 = _s695["__p"]["c"]
		J.sp(_t1766, "lineWidth", 3.0)
		J.mc(_s695["__p"]["c"], "beginPath", [])
		J.mc(_s695["__p"]["c"], "arc", [J.gp(v_tq_1680, "x"), J.gp(v_tq_1680, "y"), 14.0, 0.0, 7.0])
		J.mc(_s695["__p"]["c"], "stroke", [])
		var _t1767 = _s695["__p"]["txt"]
		J.cl(_t1767, null, [J.add("任務：", J.gp(J.gp(_s695["__p"]["S"], "task"), "o")), J.gp(v_tq_1680, "x"), J.sub(J.gp(v_tq_1680, "y"), 20.0), 12.0, "#b2d394"])
	var _t1768 = J.mc(J.gp(_s695["__p"]["S"], "actors"), "slice", [])
	var _t1769 = J.mc(_t1768, "sort", [Callable(self, "_f286").bind(_s695)])
	J.mc(_t1769, "forEach", [Callable(self, "_f287").bind(_s695)])
	var _t1771 = _s695["__p"]["drawGhost"]
	J.cl(_t1771, null, [_s695["V"]])
	var _t1772 = J.gp(_s695["__p"]["S"], "parts")
	J.mc(_t1772, "forEach", [Callable(self, "_f288").bind(_s695)])
	var _t1779 = J.gp(_s695["__p"]["S"], "floats")
	J.mc(_t1779, "forEach", [Callable(self, "_f289").bind(_s695)])
	if J.cmp(J.gp(_s695["__p"]["S"], "flash"), 0.0, ">"):
		var _t1787 = _s695["__p"]["c"]
		var _t1788 = (J.add("rgba(255,250,230,", J.mul(J.gp(_s695["__p"]["S"], "flash"), 0.5)) + ")")
		J.sp(_t1787, "fillStyle", _t1788)
		J.mc(_s695["__p"]["c"], "fillRect", [0.0, J.gp(_s695["V"], "top"), _s695["__p"]["W"], J.gp(_s695["V"], "ph")])
	J.mc(_s695["__p"]["c"], "restore", [])
	if (not J.leq(J.gp(J.gp(_s695["__p"]["S"], "cam"), "free"), null)):
		var _t1789 = _s695["__p"]["btn"]
		J.cl(_t1789, null, ["follow", (J.div(_s695["__p"]["W"], 2.0) - 66.0), J.add(J.gp(_s695["V"], "top"), 8.0), 132.0, 46.0, "◎ 跟返隻鬼", "moss"])
	var _t1790 = _s695["__p"]["drawHUD"]
	J.cl(_t1790, null, [_s695["V"], v_g0_1676])
	J.cl(_s695["__p"]["drawJoy"], null, [])

func _f292(this_, a: Array, env):
	var v_a_1748 = null
	v_a_1748 = J.arg(a, 0)
	var _t1802 = env["__p"]["__p"]["roomAt"]
	var _t1803 = J.seq(J.cl(_t1802, null, [J.gp(v_a_1748, "x")]), env["i"])
	return ((not J.seq(J.gp(v_a_1748, "st"), "run")) if _t1803 else _t1803)

func _f291(this_, a: Array, env):
	var v_R_1742 = null; var v_x_1744 = null; var v_ppl_1745 = null
	var _s713 = {"__p": env, "i": null}
	v_R_1742 = J.arg(a, 0)
	_s713["i"] = J.arg(a, 1)
	v_x_1744 = (10.0 + J.mul(_s713["i"], J.add(_s713["__p"]["tw"], 6.0)))
	var _t1801 = J.gp(_s713["__p"]["__p"]["S"], "actors")
	v_ppl_1745 = J.len(J.mc(_t1801, "filter", [Callable(self, "_f292").bind(_s713)]))
	var _t1804 = _s713["__p"]["__p"]["btn"]
	J.cl(_t1804, null, [J.add("room", _s713["i"]), v_x_1744, J.add(_s713["__p"]["y0"], 8.0), _s713["__p"]["tw"], 36.0, "", ("moss" if J.seq(_s713["i"], _s713["__p"]["gr"]) else ("rust" if J.t(J.gp(J.gp(_s713["__p"]["__p"]["S"], "light"), _s713["i"])) else "ink"))])
	var _t1805 = _s713["__p"]["__p"]["txt"]
	J.cl(_t1805, null, [J.add(J.gp(v_R_1742, "n"), ((J.add(" ", v_ppl_1745) + "人") if J.t(v_ppl_1745) else "")), J.add(v_x_1744, J.div(_s713["__p"]["tw"], 2.0)), J.add(_s713["__p"]["y0"], 24.0), 12.0, "#efe5cf", "center", J.sub(_s713["__p"]["tw"], 6.0)])
	var _t1806 = _s713["__p"]["__p"]["txt"]
	J.cl(_t1806, null, [("燈著" if J.t(J.gp(J.gp(_s713["__p"]["__p"]["S"], "light"), _s713["i"])) else "黑"), J.add(v_x_1744, J.div(_s713["__p"]["tw"], 2.0)), J.add(_s713["__p"]["y0"], 39.0), 10.0, ("#efdcb4" if J.t(J.gp(J.gp(_s713["__p"]["__p"]["S"], "light"), _s713["i"])) else "#9a8e92"), "center"])

func _f290(this_, a: Array, env):
	var v_V_1723 = null; var v_g0_1724 = null; var v_lay_1725 = null; var v_un_1726 = null; var v_T_1727 = null; var v_hh_1728 = null; var v_fr_1729 = null; var v_mh_1731 = null; var v_n_1732 = null; var v_T2_1735 = null; var v_g_1736 = null; var v_bx_1737 = null; var v_by_1738 = null; var v_C_1739 = null
	var _s711 = {"__p": env, "y0": null, "tw": null, "gr": null}
	v_V_1723 = J.arg(a, 0)
	v_g0_1724 = J.arg(a, 1)
	v_lay_1725 = J.gp(_s711["__p"]["S"], "lay")
	v_un_1726 = J.gp(_s711["__p"]["S"], "un")
	v_T_1727 = J.gp(_s711["__p"]["A"], "TOP")
	v_hh_1728 = J.gp(J.gp(_s711["__p"]["A"], "HH"), J.gp(v_un_1726, "hh"))
	J.mc(_s711["__p"]["A"], "crPanel", [_s711["__p"]["c"], (-8.0), (-8.0), J.add(_s711["__p"]["W"], 16.0), J.add(v_T_1727, 8.0), "paper"])
	v_fr_1729 = J.min_([1.0, J.div(J.gp(v_g0_1724, "t"), J.mul(J.gp(_s711["__p"]["A"], "PHT"), 3.0))])
	J.mc(_s711["__p"]["A"], "crBar", [_s711["__p"]["c"], 12.0, 8.0, J.sub(_s711["__p"]["W"], 24.0), 13.0, v_fr_1729, "dawn"])
	var _t1791 = _s711["__p"]["txt"]
	J.cl(_t1791, null, [(J.add((J.add((J.add(J.add(J.gp(J.gp(_s711["__p"]["A"], "FLN"), J.gp(v_un_1726, "f")), "・"), (J.gp(v_hh_1728, "n") if J.t(v_hh_1728) else "住戶")) + "　"), (J.gp(J.gp(_s711["__p"]["A"], "PH"), J.gp(v_g0_1724, "phase")) if J.cmp(J.gp(v_g0_1724, "phase"), 3.0, "<") else "天光")) + "　屋內剩 "), J.max_([0.0, ceil(J.num(J.gp(_s711["__p"]["S"], "limit")))])) + " 秒"), 12.0, 40.0, 14.0, ("#e48a78" if J.cmp(J.gp(_s711["__p"]["S"], "limit"), 15.0, "<") else "#efe5cf"), "left", J.sub(_s711["__p"]["W"], 120.0)])
	var _t1792 = _s711["__p"]["txt"]
	J.cl(_t1792, null, ["屋企人警覺", 12.0, 70.0, 13.0, ("#e48a78" if J.cmp(J.gp(_s711["__p"]["S"], "alert"), 70.0, ">=") else "#cfc4b0"), "left"])
	J.mc(_s711["__p"]["A"], "crBar", [_s711["__p"]["c"], 98.0, 58.0, J.sub(_s711["__p"]["W"], 216.0), 15.0, J.div(J.gp(_s711["__p"]["S"], "alert"), 100.0), "red"])
	var _t1793 = _s711["__p"]["txt"]
	J.cl(_t1793, null, [J.add(J.round(J.num(J.gp(_s711["__p"]["S"], "alert"))), ""), (98.0 + J.div(J.sub(_s711["__p"]["W"], 216.0), 2.0)), 71.0, 11.0, "#efe5cf"])
	var _t1794 = _s711["__p"]["btn"]
	J.cl(_t1794, null, ["out", J.sub(_s711["__p"]["W"], 108.0), 32.0, 98.0, 52.0, "出屋", "moss"])
	_s711["y0"] = J.sub(_s711["__p"]["H"], J.gp(_s711["__p"]["A"], "BOT"))
	J.mc(_s711["__p"]["A"], "crPanel", [_s711["__p"]["c"], (-8.0), _s711["y0"], J.add(_s711["__p"]["W"], 16.0), J.add(J.gp(_s711["__p"]["A"], "BOT"), 8.0), "paper"])
	var _t1795 = J.cmp(J.gp(_s711["__p"]["S"], "msgT"), 0.0, ">")
	if J.t((J.gp(_s711["__p"]["S"], "msg") if _t1795 else _t1795)):
		v_mh_1731 = 56.0
		J.mc(_s711["__p"]["A"], "crPanel", [_s711["__p"]["c"], 10.0, (J.sub(_s711["y0"], v_mh_1731) - 6.0), J.sub(_s711["__p"]["W"], 20.0), v_mh_1731, "sheet"])
		var _t1796 = _s711["__p"]["c"]
		var _t1797 = J.add("bold 13px ", J.gp(_s711["__p"]["A"], "FONT"))
		J.sp(_t1796, "font", _t1797)
		var _t1798 = _s711["__p"]["wrapT"]
		J.cl(_t1798, null, [J.gp(_s711["__p"]["S"], "msg"), 20.0, (J.sub(_s711["y0"], v_mh_1731) + 14.0), J.sub(_s711["__p"]["W"], 40.0), 17.0, J.gp(_s711["__p"]["S"], "msgC")])
	v_n_1732 = J.len(J.gp(v_lay_1725, "rooms"))
	_s711["tw"] = J.div((J.sub(_s711["__p"]["W"], 20.0) - (J.sub(v_n_1732, 1.0) * 6.0)), v_n_1732)
	var _t1799 = _s711["__p"]["roomAt"]
	_s711["gr"] = J.cl(_t1799, null, [J.gp(_s711["__p"]["S"], "gx")])
	var _t1800 = J.gp(v_lay_1725, "rooms")
	J.mc(_t1800, "forEach", [Callable(self, "_f291").bind(_s711)])
	v_T2_1735 = J.gp(_s711["__p"]["S"], "task")
	var _t1807 = _s711["__p"]["txt"]
	J.cl(_t1807, null, [J.add(("✓ 任務完成：" if J.t(J.gp(v_T2_1735, "done")) else "任務："), J.gp(v_T2_1735, "t")), 12.0, J.add(_s711["y0"], 64.0), 13.0, ("#b2d394" if J.t(J.gp(v_T2_1735, "done")) else "#e8d2a0"), "left", J.sub(_s711["__p"]["W"], 24.0)])
	v_g_1736 = J.gp(_s711["__p"]["S"], "g")
	v_bx_1737 = 10.0
	v_by_1738 = J.add(_s711["y0"], 76.0)
	var _t1808 = _s711["__p"]["btn"]
	var _t1809 = J.cmp(J.gp(_s711["__p"]["S"], "scCd"), 0.0, ">")
	J.cl(_t1808, null, ["scare", v_bx_1737, v_by_1738, 104.0, 58.0, (J.add("嚇！", ceil(J.num(J.gp(_s711["__p"]["S"], "scCd")))) if ((not J.t(J.gp(_s711["__p"]["S"], "sc"))) if _t1809 else _t1809) else "嚇！"), "red"])
	var _t1810 = _s711["__p"]["btn"]
	J.cl(_t1810, null, ["inv", J.add(v_bx_1737, 112.0), v_by_1738, 84.0, 58.0, (J.add("隱身 ", ceil(J.num(J.gp(v_g_1736, "invCd")))) if J.cmp(J.gp(v_g_1736, "invCd"), 0.0, ">") else "隱身"), "violet", J.cmp(J.gp(v_g_1736, "invCd"), 0.0, "<=")])
	v_C_1739 = J.cl(_s711["__p"]["ctxBtn"], null, [])
	if J.t(v_C_1739):
		var _t1811 = _s711["__p"]["btn"]
		J.cl(_t1811, null, ["ctx", J.add(v_bx_1737, 204.0), v_by_1738, (J.sub(_s711["__p"]["W"], v_bx_1737) - 214.0), 58.0, J.gp(v_C_1739, "t"), J.gp(v_C_1739, "tone"), (not J.seq(J.gp(v_C_1739, "on"), false))])
	else:
		var _t1812 = _s711["__p"]["txt"]
		J.cl(_t1812, null, ["行近發光圈＝作怪點", J.add(J.add(v_bx_1737, 204.0), J.div((J.sub(_s711["__p"]["W"], v_bx_1737) - 214.0), 2.0)), J.add(v_by_1738, 34.0), 12.0, "#9a8e92", "center", (J.sub(_s711["__p"]["W"], v_bx_1737) - 220.0)])
	var _t1813 = _s711["__p"]["txt"]
	var _t1815 = (J.add((J.add((J.add((J.add("怕意 ", J.gp(v_g0_1724, "fear")) + "　收穫 "), J.len(J.gp(v_g0_1724, "bag"))) + "/"), J.gp(_s711["__p"]["A"], "BAGMAX")) + "　紙人 "), J.gp(v_g0_1724, "dolls")) + "/6　匙 紅")
	var _t1814 = J.gp(J.gp(v_g0_1724, "keys"), "key")
	var _t1817 = (J.add(_t1815, (_t1814 if J.t(_t1814) else 0.0)) + " 黃")
	var _t1816 = J.gp(J.gp(v_g0_1724, "keys"), "key2")
	J.cl(_t1813, null, [J.add(_t1817, (_t1816 if J.t(_t1816) else 0.0)), 12.0, J.add(_s711["y0"], 156.0), 12.0, "#cfc4b0", "left", J.sub(_s711["__p"]["W"], 24.0)])
	var _t1818 = _s711["__p"]["txt"]
	J.cl(_t1818, null, ["拖動＝移動；撳作怪點／住客＝飄過去做；企定喺✦先搜得嘢", J.div(_s711["__p"]["W"], 2.0), J.sub(_s711["__p"]["H"], 14.0), 12.0, "#9a8e92", "center", J.sub(_s711["__p"]["W"], 16.0)])

func _f294(this_, a: Array, env):
	var v_p_1759 = null; var v_d_1760 = null
	v_p_1759 = J.arg(a, 0)
	if (not J.seq(J.gp(v_p_1759, "room"), env["gr"])):
		return null
	v_d_1760 = absf(J.num(J.sub(J.gp(v_p_1759, "x"), J.gp(env["__p"]["S"], "gx"))))
	if J.cmp(v_d_1760, env["bd"], "<"):
		env["bd"] = v_d_1760
		env["best"] = v_p_1759

func _f293(this_, a: Array, env):
	var v_g_1751 = null; var v_a_1752 = null; var v_e_1756 = null
	var _s715 = {"__p": env, "gr": null, "best": null, "bd": null}
	v_g_1751 = J.gp(_s715["__p"]["S"], "g")
	v_a_1752 = null
	var _t1819 = J.mc(_s715["__p"]["A"], "ctxAction", [v_g_1751])
	v_a_1752 = _t1819
	if J.t((J.seq(J.gp(v_a_1752, "k"), "deliver") if J.t(v_a_1752) else v_a_1752)):
		return {"k": "deliver", "t": J.gp(v_a_1752, "t"), "tone": "moss"}
	var _t1820 = _s715["__p"]["roomAt"]
	_s715["gr"] = J.cl(_t1820, null, [J.gp(_s715["__p"]["S"], "gx")])
	_s715["best"] = null
	_s715["bd"] = J.add(_s715["__p"]["RANGE_HOT"], 1.0)
	var _t1821 = J.gp(_s715["__p"]["S"], "spots")
	J.mc(_t1821, "forEach", [Callable(self, "_f294").bind(_s715)])
	if J.t(_s715["best"]):
		return ({"k": "hot", "p": _s715["best"], "t": (J.add(J.add(J.gp(J.gp(_s715["__p"]["HOT"], J.gp(_s715["best"], "k")), "v"), " "), ceil(J.num(J.gp(_s715["best"], "cd")))) + "s"), "tone": "ink", "on": false} if J.cmp(J.gp(_s715["best"], "cd"), 0.0, ">") else {"k": "hot", "p": _s715["best"], "t": J.add("作怪：", J.gp(J.gp(_s715["__p"]["HOT"], J.gp(_s715["best"], "k")), "v")), "tone": "rust"})
	if J.cmp(J.gp(_s715["__p"]["S"], "searchI"), 0.0, ">="):
		return {"k": "search", "t": "搜緊……企定", "tone": "ink", "on": false}
	return null

func _f295(this_, a: Array, env):
	var v_t_1763 = null; var v_x_1764 = null; var v_y_1765 = null; var v_w_1766 = null; var v_lh_1767 = null; var v_col_1768 = null; var v_ln_1769 = null; var v_yy_1770 = null; var v_i_1771 = null; var v_tt_1772 = null
	v_t_1763 = J.arg(a, 0)
	v_x_1764 = J.arg(a, 1)
	v_y_1765 = J.arg(a, 2)
	v_w_1766 = J.arg(a, 3)
	v_lh_1767 = J.arg(a, 4)
	v_col_1768 = J.arg(a, 5)
	v_ln_1769 = ""
	v_yy_1770 = v_y_1765
	v_i_1771 = 0.0
	while true:
		if not J.cmp(v_i_1771, J.len(v_t_1763), "<"): break
		v_tt_1772 = J.add(v_ln_1769, J.gp(v_t_1763, v_i_1771))
		if J.cmp(J.gp(J.mc(env["c"], "measureText", [v_tt_1772]), "width"), v_w_1766, ">"):
			var _t1822 = env["txt"]
			J.cl(_t1822, null, [v_ln_1769, v_x_1764, v_yy_1770, 13.0, v_col_1768, "left"])
			v_ln_1769 = J.gp(v_t_1763, v_i_1771)
			var _t1823 = J.add(v_yy_1770, v_lh_1767)
			v_yy_1770 = _t1823
			if J.cmp(v_yy_1770, J.add(v_y_1765, J.mul(v_lh_1767, 1.5)), ">"):
				v_ln_1769 = ""
				break
		else:
			v_ln_1769 = v_tt_1772
		v_i_1771 = J.num(v_i_1771) + 1.0
	if J.t(v_ln_1769):
		var _t1824 = env["txt"]
		J.cl(_t1824, null, [v_ln_1769, v_x_1764, v_yy_1770, 13.0, v_col_1768, "left"])

func _f296(this_, a: Array, env):
	var v_j_1775 = null; var v_dx_1776 = null
	var _t1825 = (not J.t(env["S"]))
	var _t1826 = (_t1825 if _t1825 else (not J.t(J.gp(env["S"], "joy"))))
	if (_t1826 if _t1826 else (not J.t(J.gp(J.gp(env["S"], "joy"), "on")))):
		return null
	v_j_1775 = J.gp(env["S"], "joy")
	var _t1827 = env["clamp"]
	v_dx_1776 = J.cl(_t1827, null, [J.sub(J.gp(v_j_1775, "x"), J.gp(v_j_1775, "ox")), (-58.0), 58.0])
	J.mc(env["c"], "save", [])
	var _t1828 = env["c"]
	J.sp(_t1828, "globalAlpha", 0.7)
	J.mc(env["A"], "crBlit", [env["c"], J.mc(env["A"], "crGet", [116.0, 116.0, "paper", "ring"]), J.sub(J.gp(v_j_1775, "ox"), 58.0), J.sub(J.gp(v_j_1775, "oy"), 58.0)])
	var _t1829 = env["c"]
	J.sp(_t1829, "globalAlpha", 0.92)
	J.mc(env["A"], "crBlit", [env["c"], J.mc(env["A"], "crGet", [48.0, 48.0, "bone", "ring2"]), J.sub(J.add(J.gp(v_j_1775, "ox"), v_dx_1776), 24.0), J.sub(J.gp(v_j_1775, "oy"), 24.0)])
	J.mc(env["c"], "restore", [])

func _f297(this_, a: Array, env):
	var v_e_1779 = null; var v_r_1780 = null
	v_e_1779 = J.arg(a, 0)
	if (not J.leq(J.gp(v_e_1779, "nx"), null)):
		return {"x": J.gp(v_e_1779, "nx"), "y": J.gp(v_e_1779, "ny")}
	v_r_1780 = J.mc(env["cv"], "getBoundingClientRect", [])
	return {"x": J.sub(J.gp(v_e_1779, "clientX"), J.gp(v_r_1780, "left")), "y": J.sub(J.gp(v_e_1779, "clientY"), J.gp(v_r_1780, "top"))}

func _f298(this_, a: Array, env):
	var v_x_1783 = null; var v_y_1784 = null; var v_best_1785 = null; var v_bd_1786 = null; var v_PAD_1787 = null; var v_i_1788 = null; var v_b_1789 = null; var v_d_1790 = null
	v_x_1783 = J.arg(a, 0)
	v_y_1784 = J.arg(a, 1)
	v_best_1785 = null
	v_bd_1786 = 1000000000.0
	v_PAD_1787 = 10.0
	v_i_1788 = (J.len(env["BTN"]) - 1.0)
	while true:
		if not J.cmp(v_i_1788, 0.0, ">="): break
		v_b_1789 = J.gp(env["BTN"], v_i_1788)
		var _t1830 = J.cmp(v_x_1783, J.sub(J.gp(v_b_1789, "x"), v_PAD_1787), ">=")
		var _t1831 = (J.cmp(v_x_1783, J.add(J.add(J.gp(v_b_1789, "x"), J.gp(v_b_1789, "w")), v_PAD_1787), "<=") if _t1830 else _t1830)
		var _t1832 = (J.cmp(v_y_1784, J.sub(J.gp(v_b_1789, "y"), v_PAD_1787), ">=") if _t1831 else _t1831)
		if (J.cmp(v_y_1784, J.add(J.add(J.gp(v_b_1789, "y"), J.gp(v_b_1789, "h")), v_PAD_1787), "<=") if _t1832 else _t1832):
			var _t1833 = J.cmp(v_x_1783, J.gp(v_b_1789, "x"), ">=")
			var _t1834 = (J.cmp(v_x_1783, J.add(J.gp(v_b_1789, "x"), J.gp(v_b_1789, "w")), "<=") if _t1833 else _t1833)
			var _t1835 = (J.cmp(v_y_1784, J.gp(v_b_1789, "y"), ">=") if _t1834 else _t1834)
			v_d_1790 = ((-1.0) if (J.cmp(v_y_1784, J.add(J.gp(v_b_1789, "y"), J.gp(v_b_1789, "h")), "<=") if _t1835 else _t1835) else J.hypot_([J.sub(v_x_1783, J.add(J.gp(v_b_1789, "x"), J.div(J.gp(v_b_1789, "w"), 2.0))), J.sub(v_y_1784, J.add(J.gp(v_b_1789, "y"), J.div(J.gp(v_b_1789, "h"), 2.0)))]))
			if J.cmp(v_d_1790, v_bd_1786, "<"):
				v_bd_1786 = v_d_1790
				v_best_1785 = v_b_1789
		v_i_1788 = J.num(v_i_1788) + -1.0
	return v_best_1785

func _f305(this_, a: Array, env):
	var v_id_1822 = null; var v_g0_1823 = null; var v_g_1824 = null; var v_R_1825 = null; var v_V_1826 = null; var v_C_1827 = null
	v_id_1822 = J.arg(a, 0)
	if (not J.t(env["S"])):
		return null
	v_g0_1823 = J.cl(env["G"], null, [])
	v_g_1824 = J.gp(env["S"], "g")
	if J.seq(v_id_1822, "out"):
		J.mc(env["U"], "exit", ["door"])
		return null
	if J.seq(v_id_1822, "follow"):
		var _t1836 = J.gp(env["S"], "cam")
		J.sp(_t1836, "free", null)
		return null
	if J.seq(J.mc(v_id_1822, "indexOf", ["room"]), 0.0):
		v_R_1825 = J.gp(J.gp(J.gp(env["S"], "lay"), "rooms"), J.num(J.mc(v_id_1822, "slice", [4.0])))
		v_V_1826 = J.cl(env["view"], null, [])
		var _t1837 = J.gp(env["S"], "cam")
		var _t1838 = env["clamp"]
		var _t1839 = J.cl(_t1838, null, [(J.div(J.add(J.gp(v_R_1825, "x0"), J.gp(v_R_1825, "x1")), 2.0) - J.div(J.gp(v_V_1826, "vw"), 2.0)), 0.0, J.max_([0.0, J.sub(J.gp(J.gp(env["S"], "lay"), "W"), J.gp(v_V_1826, "vw"))])])
		J.sp(_t1837, "free", _t1839)
		return null
	if J.seq(v_id_1822, "scare"):
		var _t1840 = J.gp(env["S"], "cam")
		J.sp(_t1840, "free", null)
		J.mc(env["U"], "scare", [])
		return null
	if J.seq(v_id_1822, "inv"):
		if J.cmp(J.gp(v_g_1824, "invCd"), 0.0, ">"):
			return null
		var _t1841 = env["S"]
		var _t1843 = J.gp(J.gp(v_g0_1823, "mods"), "inv")
		var _t1842 = J.gp(v_g_1824, "im")
		var _t1844 = J.mul(_t1843, (_t1842 if J.t(_t1842) else 1.0))
		J.sp(_t1841, "invT", _t1844)
		var _t1846 = J.gp(env["S"], "invT")
		var _t1845 = J.gp(v_g_1824, "icd")
		var _t1847 = J.add(_t1846, J.mul(9.0, (_t1845 if J.t(_t1845) else 1.0)))
		J.sp(v_g_1824, "invCd", _t1847)
		var _t1848 = env["wfl"]
		J.cl(_t1848, null, [J.gp(env["S"], "gx"), (J.sub(J.gp(J.gp(env["S"], "lay"), "floor"), J.gp(J.gp(env["S"], "lay"), "ph")) - 20.0), "隱身", "#a9a0d8"])
		return null
	if J.seq(v_id_1822, "ctx"):
		v_C_1827 = J.cl(env["ctxBtn"], null, [])
		if (not J.t(v_C_1827)):
			return null
		if J.seq(J.gp(v_C_1827, "k"), "deliver"):
			J.mc(env["A"], "actPress", [])
			var _t1849 = env["msg"]
			J.cl(_t1849, null, ["交還咗失物，佢哋好似冇咁驚喇", "#b2d394"])
			return null
		if J.seq(J.gp(v_C_1827, "k"), "hot"):
			var _t1850 = env["trigger"]
			J.cl(_t1850, null, [J.gp(v_C_1827, "p"), false])
		return null

func _f307(this_, a: Array, env):
	var v_p_1842 = null; var v_d_1843 = null
	v_p_1842 = J.arg(a, 0)
	v_d_1843 = J.hypot_([J.sub(J.gp(v_p_1842, "x"), env["wx"]), J.sub(J.gp(v_p_1842, "y"), env["wy"])])
	if J.cmp(v_d_1843, env["hd"], "<"):
		env["hd"] = v_d_1843
		env["hs"] = v_p_1842

func _f308(this_, a: Array, env):
	var v_a_1846 = null; var v_h_1847 = null; var v_d_1848 = null
	v_a_1846 = J.arg(a, 0)
	if J.seq(J.gp(v_a_1846, "st"), "run"):
		return null
	var _t1856 = J.gp(env["lay"], "ph")
	var _t1855 = J.seq(J.gp(v_a_1846, "act"), "bed")
	v_h_1847 = J.mul(_t1856, (0.5 if (J.seq(J.gp(v_a_1846, "st"), "act") if _t1855 else _t1855) else 1.0))
	var _t1857 = (absf(J.num(J.sub(env["wx"], J.gp(v_a_1846, "x")))) < 70.0)
	var _t1858 = (J.cmp(env["wy"], J.add(J.gp(env["lay"], "floor"), 20.0), "<") if _t1857 else _t1857)
	if (J.cmp(env["wy"], (J.sub(J.gp(env["lay"], "floor"), v_h_1847) - 30.0), ">") if _t1858 else _t1858):
		v_d_1848 = absf(J.num(J.sub(env["wx"], J.gp(v_a_1846, "x"))))
		if J.cmp(v_d_1848, env["td"], "<"):
			env["td"] = v_d_1848
			env["ta"] = v_a_1846

func _f306(this_, a: Array, env):
	var v_x_1830 = null; var v_y_1831 = null; var v_V_1832 = null
	var _s760 = {"__p": env, "wx": null, "wy": null, "lay": null, "hs": null, "hd": null, "ta": null, "td": null}
	v_x_1830 = J.arg(a, 0)
	v_y_1831 = J.arg(a, 1)
	v_V_1832 = J.cl(_s760["__p"]["view"], null, [])
	_s760["wx"] = J.add(J.div(v_x_1830, J.gp(v_V_1832, "s")), J.gp(J.gp(_s760["__p"]["S"], "cam"), "x"))
	_s760["wy"] = J.add(J.div(J.sub(v_y_1831, J.gp(v_V_1832, "top")), J.gp(v_V_1832, "s")), J.gp(J.gp(J.gp(_s760["__p"]["S"], "lay"), "crop"), 0.0))
	_s760["lay"] = J.gp(_s760["__p"]["S"], "lay")
	var _t1851 = J.gp(_s760["__p"]["S"], "cam")
	J.sp(_t1851, "free", null)
	_s760["hs"] = null
	_s760["hd"] = J.div(60.0, J.gp(v_V_1832, "s"))
	var _t1852 = J.gp(_s760["__p"]["S"], "spots")
	J.mc(_t1852, "forEach", [Callable(self, "_f307").bind(_s760)])
	if J.t(_s760["hs"]):
		var _t1853 = _s760["__p"]["trigger"]
		J.cl(_t1853, null, [_s760["hs"], false])
		return null
	_s760["ta"] = null
	_s760["td"] = 1000000000.0
	var _t1854 = J.gp(_s760["__p"]["S"], "actors")
	J.mc(_t1854, "forEach", [Callable(self, "_f308").bind(_s760)])
	if J.t(_s760["ta"]):
		var _t1859 = _s760["__p"]["scareAt"]
		J.cl(_t1859, null, [_s760["ta"]])
		return null
	if (absf(J.num(J.sub(_s760["wx"], J.gp(_s760["lay"], "door")))) < 50.0):
		var _t1860 = _s760["__p"]["S"]
		var _t1861 = J.add(J.gp(_s760["lay"], "door"), 4.0)
		J.sp(_t1860, "goX", _t1861)
		var _t1862 = _s760["__p"]["S"]
		J.sp(_t1862, "pend", null)
		var _t1863 = _s760["__p"]["wfl"]
		J.cl(_t1863, null, [J.gp(_s760["lay"], "door"), (J.sub(J.gp(_s760["lay"], "floor"), J.gp(_s760["lay"], "ph")) - 10.0), "行去門口（撳「出屋」就走得）", "#a9c79a"])
		return null
	var _t1864 = _s760["__p"]["S"]
	var _t1865 = _s760["__p"]["clamp"]
	var _t1866 = J.cl(_t1865, null, [_s760["wx"], J.add(J.gp(J.gp(J.gp(_s760["lay"], "rooms"), 0.0), "x0"), 14.0), J.sub(J.gp(J.gp(J.gp(_s760["lay"], "rooms"), (J.len(J.gp(_s760["lay"], "rooms")) - 1.0)), "x1"), 20.0)])
	J.sp(_t1864, "goX", _t1866)
	var _t1867 = _s760["__p"]["S"]
	J.sp(_t1867, "pend", null)

func _f322(this_, a: Array, env):
	var v_ts_1923 = null; var v_dt_1924 = null; var v_vis_1925 = null; var v_e_1926 = null
	v_ts_1923 = J.arg(a, 0)
	J.F_requestAnimationFrame([env["loop"]])
	v_dt_1924 = (J.min_([0.1, J.div(J.sub(v_ts_1923, env["last"]), 1000.0)]) if J.t(env["last"]) else 0.0)
	env["last"] = v_ts_1923
	if (not J.seq(J.cl(env["G"], null, []), env["lastG"])):
		var _t1868 = J.cl(env["G"], null, [])
		env["lastG"] = _t1868
		env["S"] = null
		var _t1869 = env["hideNative"]
		J.cl(_t1869, null, [false])
	var _t1870 = J.cl(env["running"], null, [])
	if J.t(((not J.t(J.gp(env["U"], "manual"))) if J.t(_t1870) else _t1870)):
		J.mc(env["U"], "step", [v_dt_1924])
	v_vis_1925 = J.cl(env["visible"], null, [])
	if J.t(v_vis_1925):
		if J.seq(J.gp(J.gp(env["cv"], "style"), "display"), "none"):
			var _t1871 = J.gp(env["cv"], "style")
			J.sp(_t1871, "display", "block")
		if (not J.t(J.gp(J.G.get("window"), "__twNat"))):
			J.cl(env["draw"], null, [])
	else:
		if (not J.seq(J.gp(J.gp(env["cv"], "style"), "display"), "none")):
			var _t1872 = J.gp(env["cv"], "style")
			J.sp(_t1872, "display", "none")
			env["ptr"] = null
			if J.t(env["S"]):
				var _t1873 = env["S"]
				J.sp(_t1873, "joy", null)

func _f193(this_, a: Array, env):
	var _t1874 = env["hiss"]
	J.cl(_t1874, null, [0.0, 0.5, 0.06, 500.0])
	var _t1875 = env["tone"]
	J.cl(_t1875, null, [110.0, 0.0, 0.4, 0.05, "triangle"])

func _f194(this_, a: Array, env):
	var v_k_1160 = null
	v_k_1160 = J.arg(a, 0)
	if J.seq(v_k_1160, "lamp"):
		var _t1876 = env["tone"]
		J.cl(_t1876, null, [60.0, 0.0, 0.3, 0.12, "square"])
	else:
		var _t1877 = J.seq(v_k_1160, "tv")
		if (_t1877 if _t1877 else J.seq(v_k_1160, "pc")):
			var _t1878 = env["hiss"]
			J.cl(_t1878, null, [0.0, 1.2, 0.07, 2400.0])
		else:
			var _t1879 = J.seq(v_k_1160, "tap")
			var _t1880 = (_t1879 if _t1879 else J.seq(v_k_1160, "shower"))
			if (_t1880 if _t1880 else J.seq(v_k_1160, "jar")):
				var _t1881 = env["hiss"]
				J.cl(_t1881, null, [0.0, 1.4, 0.06, 700.0])
			else:
				if J.seq(v_k_1160, "pots"):
					var _t1882 = env["tone"]
					J.cl(_t1882, null, [880.0, 0.0, 0.3, 0.1, "triangle"])
					var _t1883 = env["tone"]
					J.cl(_t1883, null, [660.0, 0.15, 0.4, 0.08, "triangle"])
				else:
					var _t1884 = env["tone"]
					J.cl(_t1884, null, [196.0, 0.0, 1.1, 0.06, "triangle"])
					var _t1885 = env["tone"]
					J.cl(_t1885, null, [185.0, 0.1, 1.1, 0.05, "sine"])

func _f195(this_, a: Array, env):
	var _t1886 = env["tone"]
	J.cl(_t1886, null, [70.0, 0.0, 0.7, 0.2, "sawtooth"])
	var _t1887 = env["hiss"]
	J.cl(_t1887, null, [0.0, 0.6, 0.1, 300.0])

func _f196(this_, a: Array, env):
	var _t1888 = env["tone"]
	J.cl(_t1888, null, [740.0, 0.0, 0.12, 0.06, "square"])
	var _t1889 = env["tone"]
	J.cl(_t1889, null, [740.0, 0.16, 0.12, 0.06, "square"])

func _f197(this_, a: Array, env):
	var v_i_1167 = null
	v_i_1167 = 0.0
	while true:
		if not J.cmp(v_i_1167, 4.0, "<"): break
		var _t1890 = env["tone"]
		J.cl(_t1890, null, [(400.0 - J.mul(v_i_1167, 60.0)), J.mul(v_i_1167, 0.12), 0.18, 0.08, "square"])
		v_i_1167 = J.num(v_i_1167) + 1.0

func _f198(this_, a: Array, env):
	J.cl(env["ac"], null, [])

func _f200(this_, a: Array, env):
	var v_g_1178 = null; var v_un_1179 = null
	v_g_1178 = J.arg(a, 0)
	v_un_1179 = J.arg(a, 1)
	var _t1892 = env["enterable"]
	return J.seq(J.cl(_t1892, null, [v_g_1178, v_un_1179]), true)

func _f201(this_, a: Array, env):
	var v_g_1182 = null; var v_un_1183 = null; var v_ok_1184 = null; var v_n_1185 = null
	v_g_1182 = J.arg(a, 0)
	v_un_1183 = J.arg(a, 1)
	var _t1895 = env["enterable"]
	v_ok_1184 = J.cl(_t1895, null, [v_g_1182, v_un_1183])
	if (not J.seq(v_ok_1184, true)):
		var _t1896 = env["blockedMsg"]
		J.cl(_t1896, null, [v_g_1182, v_un_1183, v_ok_1184])
		return false
	J.sp(v_g_1182, "to", null)
	J.sp(v_g_1182, "auto", null)
	J.sp(v_g_1182, "autoS", null)
	J.sp(v_g_1182, "p", 0.0)
	var _t1897 = J.gp(v_un_1183, "id")
	J.sp(v_g_1182, "node", _t1897)
	v_n_1185 = J.gp(J.gp(J.cl(env["G"], null, []), "nodes"), J.gp(v_un_1183, "id"))
	var _t1898 = J.gp(v_n_1185, "x")
	J.sp(v_g_1182, "x", _t1898)
	var _t1899 = J.gp(v_n_1185, "y")
	J.sp(v_g_1182, "y", _t1899)
	J.mc(env["A"], "onArrive", [v_g_1182])
	return (not (not J.t(env["S"])))

func _f203(this_, a: Array, env):
	var v_g_1195 = null; var v_n_1196 = null; var v_g0_1197 = null; var v_un_1198 = null; var v_I_1199 = null; var v_d_1200 = null
	v_g_1195 = J.arg(a, 0)
	v_n_1196 = J.arg(a, 1)
	v_g0_1197 = J.cl(env["G"], null, [])
	var _t1902 = (not J.t(v_g0_1197))
	var _t1903 = (_t1902 if _t1902 else env["S"])
	if J.t((_t1903 if J.t(_t1903) else (not J.seq(J.gp(v_g_1195, "i"), J.gp(v_g0_1197, "active"))))):
		return false
	v_un_1198 = J.mc(env["A"], "unitOf", [J.gp(v_n_1196, "id")])
	var _t1904 = env["isHH"]
	if (not J.t(J.cl(_t1904, null, [v_un_1198]))):
		return false
	var _t1905 = env["iu"]
	v_I_1199 = J.cl(_t1905, null, [v_un_1198])
	var _t1906 = J.cmp(J.gp(v_I_1199, "ban"), 0.0, ">")
	if (_t1906 if _t1906 else J.cmp(J.gp(v_I_1199, "cd"), 0.0, ">")):
		var _t1907 = J.gp(v_un_1198, "did")
		J.sp(v_g_1195, "node", _t1907)
		v_d_1200 = J.gp(J.gp(v_g0_1197, "nodes"), J.gp(v_un_1198, "did"))
		var _t1908 = J.gp(v_d_1200, "x")
		J.sp(v_g_1195, "x", _t1908)
		var _t1909 = J.gp(v_d_1200, "y")
		J.sp(v_g_1195, "y", _t1909)
		J.sp(v_g_1195, "to", null)
		J.sp(v_g_1195, "auto", null)
		var _t1910 = env["blockedMsg"]
		J.cl(_t1910, null, [v_g_1195, v_un_1198, ("ban" if J.cmp(J.gp(v_I_1199, "ban"), 0.0, ">") else "cd")])
		return true
	var _t1911 = env["open"]
	J.cl(_t1911, null, [v_g_1195, v_un_1198])
	return true

func _f218(this_, a: Array, env):
	var v_why_1266 = null; var v_un_1267 = null; var v_g_1268 = null; var v_g0_1269 = null; var v_I_1270 = null; var v_d_1271 = null; var v_t_1272 = null; var v_e_1273 = null
	v_why_1266 = J.arg(a, 0)
	if (not J.t(env["S"])):
		return false
	v_un_1267 = J.gp(env["S"], "un")
	v_g_1268 = J.gp(env["S"], "g")
	v_g0_1269 = J.cl(env["G"], null, [])
	var _t1914 = env["iu"]
	v_I_1270 = J.cl(_t1914, null, [v_un_1267])
	var _t1915 = J.gp(env["S"], "alert")
	J.sp(v_I_1270, "alert", _t1915)
	var _t1916 = J.gp(v_g0_1269, "t")
	J.sp(v_I_1270, "leftT", _t1916)
	if J.seq(v_why_1266, "kick"):
		var _t1917 = env["BAN"]
		J.sp(v_I_1270, "ban", _t1917)
		J.sp(v_I_1270, "alert", 55.0)
	else:
		if J.seq(v_why_1266, "time"):
			var _t1918 = env["REIN"]
			J.sp(v_I_1270, "cd", _t1918)
		else:
			J.sp(v_I_1270, "cd", 1.5)
	J.sp(v_g_1268, "inUnit", null)
	var _t1919 = J.gp(v_un_1267, "did")
	J.sp(v_g_1268, "node", _t1919)
	v_d_1271 = J.gp(J.gp(v_g0_1269, "nodes"), J.gp(v_un_1267, "did"))
	var _t1920 = J.gp(v_d_1271, "x")
	J.sp(v_g_1268, "x", _t1920)
	var _t1921 = J.gp(v_d_1271, "y")
	J.sp(v_g_1268, "y", _t1921)
	J.sp(v_g_1268, "to", null)
	J.sp(v_g_1268, "auto", null)
	J.sp(v_g_1268, "autoS", null)
	J.sp(v_g_1268, "p", 0.0)
	J.sp(v_g_1268, "still", 1.0)
	J.sp(v_g_1268, "taskP", 0.0)
	J.sp(v_g_1268, "mv", 0.0)
	var _t1922 = J.gp(v_g_1268, "inv")
	var _t1923 = J.gp(v_g_1268, "inv")
	var _t1924 = J.max_([(_t1923 if J.t(_t1923) else 0.0), (0.8 if J.seq(v_why_1266, "kick") else 1.4)])
	J.sp(v_g_1268, "inv", _t1924)
	v_t_1272 = ((J.add("被趕出屋！", env["BAN"]) + " 秒內呢戶入唔到") if J.seq(v_why_1266, "kick") else ("陰氣唔夠，返出走廊透下" if J.seq(v_why_1266, "time") else "出咗屋"))
	J.mc(env["A"], "float", [J.gp(v_un_1267, "x"), J.sub(J.gp(v_un_1267, "y"), 90.0), v_t_1272, ("#ffb0b0" if J.seq(v_why_1266, "kick") else "#9fd6bf")])
	if J.seq(v_why_1266, "kick"):
		var _t1925 = J.add(J.gp(v_g0_1269, "alert"), 1.0)
		J.sp(v_g0_1269, "alert", _t1925)
		J.mc(env["A"], "checkAlert", [])
		J.mc(env["A"], "noise", [J.gp(v_un_1267, "did"), 2.0])
		J.mc(env["A"], "toast", [J.add(J.gp(J.gp(env["A"], "FLN"), J.gp(v_un_1267, "f")), "嗰戶開晒燈大嗌，鬼被趕返出走廊——全樓警覺 +1，保安聽到聲過嚟睇。")])
	env["S"] = null
	J.mc(env["SND"], "door", [])
	var _t1926 = env["hideNative"]
	J.cl(_t1926, null, [false])
	return true

func _f220(this_, a: Array, env):
	var v_u_1291 = null
	v_u_1291 = J.arg(a, 0)
	if J.t(J.gp(v_u_1291, "iu")):
		var _t1931 = J.gp(v_u_1291, "iu")
		var _t1932 = J.max_([0.0, J.sub(J.gp(J.gp(v_u_1291, "iu"), "ban"), env["dt"])])
		J.sp(_t1931, "ban", _t1932)
		var _t1933 = J.gp(v_u_1291, "iu")
		var _t1934 = J.max_([0.0, J.sub(J.gp(J.gp(v_u_1291, "iu"), "cd"), env["dt"])])
		J.sp(_t1933, "cd", _t1934)

func _f221(this_, a: Array, env):
	var v_p_1294 = null
	v_p_1294 = J.arg(a, 0)
	var _t2002 = J.max_([0.0, J.sub(J.gp(v_p_1294, "cd"), env["dt"])])
	J.sp(v_p_1294, "cd", _t2002)
	var _t2003 = J.max_([0.0, J.sub(J.gp(v_p_1294, "t"), env["dt"])])
	J.sp(v_p_1294, "t", _t2003)

func _f222(this_, a: Array, env):
	var v_v_1297 = null
	v_v_1297 = J.arg(a, 0)
	return J.max_([0.0, J.sub(v_v_1297, env["dt"])])

func _f223(this_, a: Array, env):
	var v_f_1300 = null
	v_f_1300 = J.arg(a, 0)
	var _t2008 = J.sub(J.gp(v_f_1300, "life"), env["dt"])
	J.sp(v_f_1300, "life", _t2008)
	var _t2009 = J.sub(J.gp(v_f_1300, "y"), J.mul(env["dt"], 30.0))
	J.sp(v_f_1300, "y", _t2009)

func _f224(this_, a: Array, env):
	var v_f_1303 = null
	v_f_1303 = J.arg(a, 0)
	return J.cmp(J.gp(v_f_1303, "life"), 0.0, ">")

func _f225(this_, a: Array, env):
	var v_p_1306 = null
	v_p_1306 = J.arg(a, 0)
	var _t2014 = J.sub(J.gp(v_p_1306, "life"), env["dt"])
	J.sp(v_p_1306, "life", _t2014)
	var _t2015 = J.add(J.gp(v_p_1306, "x"), J.mul(J.gp(v_p_1306, "vx"), env["dt"]))
	J.sp(v_p_1306, "x", _t2015)
	var _t2016 = J.add(J.gp(v_p_1306, "y"), J.mul(J.gp(v_p_1306, "vy"), env["dt"]))
	J.sp(v_p_1306, "y", _t2016)
	var _t2017 = J.seq(J.gp(v_p_1306, "type"), "drop")
	var _t2018 = (_t2017 if _t2017 else J.seq(J.gp(v_p_1306, "type"), "coin"))
	if (_t2018 if _t2018 else J.seq(J.gp(v_p_1306, "type"), "sweat")):
		var _t2019 = J.add(J.gp(v_p_1306, "vy"), J.mul(500.0, env["dt"]))
		J.sp(v_p_1306, "vy", _t2019)

func _f226(this_, a: Array, env):
	var v_p_1309 = null
	v_p_1309 = J.arg(a, 0)
	return J.cmp(J.gp(v_p_1309, "life"), 0.0, ">")

func _f227(this_, a: Array, env):
	var v_a_1312 = null
	v_a_1312 = J.arg(a, 0)
	var _t2027 = J.gp(v_a_1312, "r")
	J.sp(_t2027, "awake", true)
	var _t2028 = J.gp(v_a_1312, "r")
	J.sp(_t2028, "woke", true)

func _f228(this_, a: Array, env):
	var v_a_1315 = null
	v_a_1315 = J.arg(a, 0)
	return J.seq(J.gp(J.gp(v_a_1315, "r"), "state"), "home")

func _f219(this_, a: Array, env):
	var v_g0_1277 = null; var v_g_1278 = null; var v_lay_1279 = null; var v_un_1280 = null; var v_sp_1281 = null; var v_mv_1282 = null; var v_jx_1283 = null; var v_d_1284 = null; var v_nx_1285 = null; var v_P_1286 = null; var v_sc_1287 = null; var v_w_1288 = null
	var _s477 = {"__p": env, "dt": null}
	_s477["dt"] = J.arg(a, 0)
	v_g0_1277 = J.cl(_s477["__p"]["G"], null, [])
	if (not J.seq(v_g0_1277, _s477["__p"]["lastG"])):
		_s477["__p"]["lastG"] = v_g0_1277
		_s477["__p"]["S"] = null
		var _t1929 = _s477["__p"]["hideNative"]
		J.cl(_t1929, null, [false])
	if J.t(v_g0_1277):
		var _t1930 = J.gp(v_g0_1277, "units")
		J.mc(_t1930, "forEach", [Callable(self, "_f220").bind(_s477)])
	if (not J.t(_s477["__p"]["S"])):
		return null
	v_g_1278 = J.gp(_s477["__p"]["S"], "g")
	v_lay_1279 = J.gp(_s477["__p"]["S"], "lay")
	v_un_1280 = J.gp(_s477["__p"]["S"], "un")
	var _t1935 = J.gp(v_g_1278, "out")
	var _t1937 = (_t1935 if J.t(_t1935) else J.gp(v_g_1278, "home"))
	if not J.t(_t1937):
		var _t1936 = J.gp(v_g0_1277, "gh")
		_t1937 = J.cmp(J.mc(_t1936, "indexOf", [v_g_1278]), 0.0, "<")
	if J.t(_t1937):
		_s477["__p"]["S"] = null
		J.sp(v_g_1278, "inUnit", null)
		var _t1938 = _s477["__p"]["hideNative"]
		J.cl(_t1938, null, [false])
		return null
	var _t1939 = _s477["__p"]["S"]
	var _t1940 = J.add(J.gp(_t1939, "t"), _s477["dt"])
	J.sp(_t1939, "t", _t1940)
	var _t1941 = _s477["__p"]["S"]
	var _t1942 = J.sub(J.gp(_t1941, "limit"), _s477["dt"])
	J.sp(_t1941, "limit", _t1942)
	var _t1943 = _s477["__p"]["S"]
	var _t1944 = J.max_([0.0, J.sub(J.gp(_s477["__p"]["S"], "msgT"), _s477["dt"])])
	J.sp(_t1943, "msgT", _t1944)
	var _t1945 = _s477["__p"]["S"]
	var _t1946 = J.max_([0.0, J.sub(J.gp(_s477["__p"]["S"], "scCd"), _s477["dt"])])
	J.sp(_t1945, "scCd", _t1946)
	var _t1947 = _s477["__p"]["S"]
	var _t1948 = J.max_([0.0, J.sub(J.gp(_s477["__p"]["S"], "invT"), _s477["dt"])])
	J.sp(_t1947, "invT", _t1948)
	var _t1949 = _s477["__p"]["S"]
	var _t1950 = J.max_([0.0, J.sub(J.gp(_s477["__p"]["S"], "stun"), _s477["dt"])])
	J.sp(_t1949, "stun", _t1950)
	var _t1951 = _s477["__p"]["S"]
	var _t1952 = J.max_([0.0, J.sub(J.gp(_s477["__p"]["S"], "flash"), _s477["dt"])])
	J.sp(_t1951, "flash", _t1952)
	var _t1953 = J.gp(v_g_1278, "inv")
	var _t1954 = J.gp(v_g_1278, "inv")
	var _t1955 = J.max_([(_t1954 if J.t(_t1954) else 0.0), 0.25])
	J.sp(v_g_1278, "inv", _t1955)
	var _t1956 = J.gp(v_un_1280, "id")
	J.sp(v_g_1278, "node", _t1956)
	J.sp(v_g_1278, "to", null)
	J.sp(v_g_1278, "auto", null)
	J.sp(v_g_1278, "autoS", null)
	if (not J.seq(J.gp(v_g0_1277, "active"), J.gp(v_g_1278, "i"))):
		var _t1957 = J.gp(v_g_1278, "i")
		J.sp(v_g0_1277, "active", _t1957)
	var _t1959 = J.mul(J.gp(J.gp(v_g_1278, "d"), "sp"), J.gp(J.gp(v_g0_1277, "mods"), "spd"))
	var _t1958 = J.gp(v_g_1278, "spm")
	v_sp_1281 = (J.mul(_t1959, (_t1958 if J.t(_t1958) else 1.0)) * 2.1)
	v_mv_1282 = 0.0
	var _t1960 = J.gp(_s477["__p"]["S"], "joy")
	v_jx_1283 = (J.div(J.sub(J.gp(J.gp(_s477["__p"]["S"], "joy"), "x"), J.gp(J.gp(_s477["__p"]["S"], "joy"), "ox")), 58.0) if J.t((J.gp(J.gp(_s477["__p"]["S"], "joy"), "on") if J.t(_t1960) else _t1960)) else 0.0)
	var _t1962 = J.cmp(J.gp(_s477["__p"]["S"], "stun"), 0.0, ">")
	if not J.t(_t1962):
		var _t1961 = J.gp(_s477["__p"]["S"], "sc")
		_t1962 = (J.cmp(J.gp(J.gp(_s477["__p"]["S"], "sc"), "t"), J.add(_s477["__p"]["OMEN"], 0.5), "<") if J.t(_t1961) else _t1961)
	if J.t(_t1962):
		v_jx_1283 = 0.0
	if (absf(J.num(v_jx_1283)) > 0.2):
		var _t1963 = _s477["__p"]["S"]
		J.sp(_t1963, "goX", null)
		var _t1964 = _s477["__p"]["S"]
		J.sp(_t1964, "pend", null)
		var _t1965 = _s477["__p"]["clamp"]
		var _t1966 = J.mul(J.mul(J.cl(_t1965, null, [v_jx_1283, (-1.0), 1.0]), v_sp_1281), _s477["dt"])
		v_mv_1282 = _t1966
		if J.t(J.gp(J.gp(_s477["__p"]["S"], "cam"), "free")):
			var _t1967 = J.gp(_s477["__p"]["S"], "cam")
			J.sp(_t1967, "free", null)
	else:
		var _t1968 = (not J.leq(J.gp(_s477["__p"]["S"], "goX"), null))
		if (J.cmp(J.gp(_s477["__p"]["S"], "stun"), 0.0, "<=") if _t1968 else _t1968):
			v_d_1284 = J.sub(J.gp(_s477["__p"]["S"], "goX"), J.gp(_s477["__p"]["S"], "gx"))
			if (absf(J.num(v_d_1284)) < 4.0):
				var _t1969 = _s477["__p"]["S"]
				J.sp(_t1969, "goX", null)
			else:
				var _t1970 = (signf(J.num(v_d_1284)) * J.min_([absf(J.num(v_d_1284)), J.mul(v_sp_1281, _s477["dt"])]))
				v_mv_1282 = _t1970
	if J.t(v_mv_1282):
		var _t1971 = _s477["__p"]["clamp"]
		v_nx_1285 = J.cl(_t1971, null, [J.add(J.gp(_s477["__p"]["S"], "gx"), v_mv_1282), J.add(J.gp(J.gp(J.gp(v_lay_1279, "rooms"), 0.0), "x0"), 10.0), J.sub(J.gp(J.gp(J.gp(v_lay_1279, "rooms"), (J.len(J.gp(v_lay_1279, "rooms")) - 1.0)), "x1"), 20.0)])
		var _t1972 = _s477["__p"]["S"]
		var _t1973 = (1.0 if J.cmp(v_mv_1282, 0.0, ">") else (-1.0))
		J.sp(_t1972, "gdir", _t1973)
		if (absf(J.num(J.sub(v_nx_1285, J.gp(_s477["__p"]["S"], "gx")))) > 0.1):
			var _t1974 = _s477["__p"]["S"]
			J.sp(_t1974, "gmv", 0.15)
			var _t1975 = _s477["__p"]["S"]
			J.sp(_t1975, "still", 0.0)
		var _t1976 = _s477["__p"]["S"]
		J.sp(_t1976, "gx", v_nx_1285)
		var _t1977 = J.cmp(J.gp(_s477["__p"]["S"], "gx"), J.add(J.gp(J.gp(J.gp(v_lay_1279, "rooms"), 0.0), "x0"), 12.0), "<=")
		if (J.cmp(v_jx_1283, (-0.5), "<") if _t1977 else _t1977):
			J.mc(_s477["__p"]["U"], "exit", ["door"])
			return null
	else:
		var _t1978 = _s477["__p"]["S"]
		var _t1979 = J.max_([0.0, J.sub(J.gp(_s477["__p"]["S"], "gmv"), _s477["dt"])])
		J.sp(_t1978, "gmv", _t1979)
		var _t1980 = _s477["__p"]["S"]
		var _t1981 = J.add(J.gp(_t1980, "still"), _s477["dt"])
		J.sp(_t1980, "still", _t1981)
	var _t1982 = J.gp(_s477["__p"]["S"], "sc")
	var _t1983 = (J.cmp(J.gp(J.gp(_s477["__p"]["S"], "sc"), "t"), _s477["__p"]["OMEN"], "<") if J.t(_t1982) else _t1982)
	if J.t((J.cmp(J.gp(_s477["__p"]["S"], "gmv"), 0.0, ">") if J.t(_t1983) else _t1983)):
		var _t1984 = _s477["__p"]["wfl"]
		J.cl(_t1984, null, [J.gp(_s477["__p"]["S"], "gx"), (J.sub(J.gp(v_lay_1279, "floor"), J.gp(v_lay_1279, "ph")) - 20.0), "一郁就破功", "#e6a85a"])
		var _t1985 = _s477["__p"]["S"]
		J.sp(_t1985, "sc", null)
		var _t1986 = _s477["__p"]["S"]
		J.sp(_t1986, "scCd", 0.4)
	var _t1987 = J.gp(_s477["__p"]["S"], "pend")
	var _t1988 = (J.leq(J.gp(_s477["__p"]["S"], "goX"), null) if J.t(_t1987) else _t1987)
	if J.t((J.cmp(J.gp(_s477["__p"]["S"], "stun"), 0.0, "<=") if J.t(_t1988) else _t1988)):
		v_P_1286 = J.gp(_s477["__p"]["S"], "pend")
		var _t1989 = _s477["__p"]["S"]
		J.sp(_t1989, "pend", null)
		if J.seq(J.gp(v_P_1286, "k"), "hot"):
			var _t1990 = _s477["__p"]["trigger"]
			J.cl(_t1990, null, [J.gp(v_P_1286, "p"), true])
		else:
			if J.seq(J.gp(v_P_1286, "k"), "scare"):
				var _t1991 = _s477["__p"]["scareAt"]
				J.cl(_t1991, null, [J.gp(v_P_1286, "a")])
	if J.t(J.gp(_s477["__p"]["S"], "sc")):
		v_sc_1287 = J.gp(_s477["__p"]["S"], "sc")
		var _t1992 = J.add(J.gp(v_sc_1287, "t"), _s477["dt"])
		J.sp(v_sc_1287, "t", _t1992)
		var _t1993 = (not J.t(J.gp(v_sc_1287, "hit")))
		if (J.cmp(J.gp(v_sc_1287, "t"), _s477["__p"]["OMEN"], ">=") if _t1993 else _t1993):
			J.sp(v_sc_1287, "hit", true)
			var _t1994 = _s477["__p"]["strike"]
			J.cl(_t1994, null, [v_sc_1287])
		if J.cmp(J.gp(v_sc_1287, "t"), J.add(_s477["__p"]["OMEN"], 0.9), ">="):
			var _t1995 = _s477["__p"]["S"]
			J.sp(_t1995, "sc", null)
	var _t1996 = _s477["__p"]["searchUpdate"]
	J.cl(_t1996, null, [_s477["dt"]])
	var _t1997 = _s477["__p"]["actorsUpdate"]
	J.cl(_t1997, null, [_s477["dt"]])
	var _t1998 = _s477["__p"]["lightsUpdate"]
	J.cl(_t1998, null, [_s477["dt"]])
	var _t1999 = _s477["__p"]["detect"]
	J.cl(_t1999, null, [_s477["dt"]])
	var _t2000 = _s477["__p"]["thresholds"]
	J.cl(_t2000, null, [_s477["dt"]])
	J.cl(_s477["__p"]["taskCheck"], null, [])
	var _t2001 = J.gp(_s477["__p"]["S"], "spots")
	J.mc(_t2001, "forEach", [Callable(self, "_f221").bind(_s477)])
	var _t2004 = _s477["__p"]["S"]
	var _t2005 = J.gp(_s477["__p"]["S"], "dark")
	var _t2006 = J.mc(_t2005, "map", [Callable(self, "_f222").bind(_s477)])
	J.sp(_t2004, "dark", _t2006)
	var _t2007 = J.gp(_s477["__p"]["S"], "floats")
	J.mc(_t2007, "forEach", [Callable(self, "_f223").bind(_s477)])
	var _t2010 = _s477["__p"]["S"]
	var _t2011 = J.gp(_s477["__p"]["S"], "floats")
	var _t2012 = J.mc(_t2011, "filter", [Callable(self, "_f224").bind(_s477)])
	J.sp(_t2010, "floats", _t2012)
	var _t2013 = J.gp(_s477["__p"]["S"], "parts")
	J.mc(_t2013, "forEach", [Callable(self, "_f225").bind(_s477)])
	var _t2020 = _s477["__p"]["S"]
	var _t2021 = J.gp(_s477["__p"]["S"], "parts")
	var _t2022 = J.mc(_t2021, "filter", [Callable(self, "_f226").bind(_s477)])
	J.sp(_t2020, "parts", _t2022)
	var _t2023 = J.cmp(J.gp(v_g0_1277, "phase"), 3.0, ">=")
	if ((not J.t(J.gp(J.gp(_s477["__p"]["S"], "flags"), "dawn"))) if _t2023 else _t2023):
		var _t2024 = J.gp(_s477["__p"]["S"], "flags")
		J.sp(_t2024, "dawn", 1.0)
		var _t2025 = _s477["__p"]["msg"]
		J.cl(_t2025, null, ["天光喇！住客陸續起身，開晒燈——快啲做完出屋！", "#e48a78"])
		var _t2026 = J.gp(_s477["__p"]["S"], "actors")
		J.mc(_t2026, "forEach", [Callable(self, "_f227").bind(_s477)])
	if J.cmp(J.gp(v_g0_1277, "phase"), 3.0, ">="):
		var _t2029 = _s477["__p"]["S"]
		var _t2030 = J.add(J.gp(_t2029, "alert"), J.mul(3.0, _s477["dt"]))
		J.sp(_t2029, "alert", _t2030)
	if J.cmp(J.gp(_s477["__p"]["S"], "alert"), 100.0, ">="):
		var _t2031 = _s477["__p"]["S"]
		J.sp(_t2031, "alert", 100.0)
		var _t2032 = _s477["__p"]["S"]
		var _t2033 = J.add(J.gp(_t2032, "kickT"), _s477["dt"])
		J.sp(_t2032, "kickT", _t2033)
		var _t2034 = J.cmp(J.gp(_s477["__p"]["S"], "kickT"), 0.01, ">")
		if ((not J.t(J.gp(J.gp(_s477["__p"]["S"], "flags"), "kickSaid"))) if _t2034 else _t2034):
			var _t2035 = J.gp(_s477["__p"]["S"], "flags")
			J.sp(_t2035, "kickSaid", 1.0)
			var _t2036 = J.gp(_s477["__p"]["S"], "actors")
			v_w_1288 = J.mc(_t2036, "find", [Callable(self, "_f228").bind(_s477)])
			if J.t(v_w_1288):
				var _t2037 = _s477["__p"]["sayR"]
				var _t2039 = J.gp(v_w_1288, "r")
				var _t2038 = _s477["__p"]["line"]
				J.cl(_t2037, null, [_t2039, J.cl(_t2038, null, ["kick"])])
			J.mc(_s477["__p"]["SND"], "kick", [])
		if J.cmp(J.gp(_s477["__p"]["S"], "kickT"), 1.0, ">="):
			J.mc(_s477["__p"]["U"], "exit", ["kick"])
			return null
	if J.cmp(J.gp(_s477["__p"]["S"], "limit"), 0.0, "<="):
		J.mc(_s477["__p"]["U"], "exit", ["time"])
		return null

func _f264(this_, a: Array, env):
	var v_target_1500 = null; var v_g_1501 = null; var v_a_1502 = null; var v_far_1503 = null
	v_target_1500 = J.arg(a, 0)
	if (not J.t(env["S"])):
		return false
	v_g_1501 = J.gp(env["S"], "g")
	if J.t(J.gp(env["S"], "sc")):
		return false
	if J.cmp(J.gp(env["S"], "scCd"), 0.0, ">"):
		var _t2042 = env["wfl"]
		J.cl(_t2042, null, [J.gp(env["S"], "gx"), (J.sub(J.gp(J.gp(env["S"], "lay"), "floor"), J.gp(J.gp(env["S"], "lay"), "ph")) - 20.0), "啱啱嚇完，等陣先", "#ddd2bd"])
		return false
	if J.cmp(J.gp(env["S"], "stun"), 0.0, ">"):
		var _t2043 = env["wfl"]
		J.cl(_t2043, null, [J.gp(env["S"], "gx"), (J.sub(J.gp(J.gp(env["S"], "lay"), "floor"), J.gp(J.gp(env["S"], "lay"), "ph")) - 20.0), "數緊綠豆，數完先嚇得", "#b8f0a0"])
		return false
	var _t2045 = v_target_1500
	if not J.t(_t2045):
		var _t2044 = env["nearestActor"]
		_t2045 = J.cl(_t2044, null, [env["RANGE_SCARE"]])
	v_a_1502 = _t2045
	if (not J.t(v_a_1502)):
		var _t2046 = env["nearestActor"]
		v_far_1503 = J.cl(_t2046, null, [2000.0])
		if J.t(v_far_1503):
			var _t2047 = env["scareAt"]
			J.cl(_t2047, null, [v_far_1503])
			var _t2048 = env["wfl"]
			J.cl(_t2048, null, [J.gp(env["S"], "gx"), (J.sub(J.gp(J.gp(env["S"], "lay"), "floor"), J.gp(J.gp(env["S"], "lay"), "ph")) - 20.0), J.add("飄過去嚇", (J.gp(J.gp(J.gp(env["A"], "HH"), J.gp(J.gp(v_far_1503, "r"), "hh")), "n") if J.t(J.gp(J.gp(env["A"], "HH"), J.gp(J.gp(v_far_1503, "r"), "hh"))) else "住客")), "#e8a088"])
			return false
		var _t2049 = env["wfl"]
		J.cl(_t2049, null, [J.gp(env["S"], "gx"), (J.sub(J.gp(J.gp(env["S"], "lay"), "floor"), J.gp(J.gp(env["S"], "lay"), "ph")) - 20.0), "屋入面冇人喇", "#ddd2bd"])
		return false
	var _t2050 = env["S"]
	J.sp(_t2050, "goX", null)
	var _t2051 = env["S"]
	J.sp(_t2051, "pend", null)
	var _t2052 = env["S"]
	var _t2053 = (1.0 if J.cmp(J.gp(v_a_1502, "x"), J.gp(env["S"], "gx"), ">") else (-1.0))
	J.sp(_t2052, "gdir", _t2053)
	var _t2054 = env["S"]
	var _t2055 = J.max_([J.gp(env["S"], "still"), 0.12])
	J.sp(_t2054, "still", _t2055)
	var _t2056 = env["S"]
	J.sp(_t2056, "gmv", 0.0)
	var _t2057 = env["S"]
	var _t2058 = {"t": 0.0, "a": v_a_1502, "k": J.gp(J.gp(v_g_1501, "d"), "key"), "hit": false}
	J.sp(_t2057, "sc", _t2058)
	var _t2059 = env["S"]
	var _t2060 = J.add(env["OMEN"], 1.4)
	J.sp(_t2059, "scCd", _t2060)
	var _t2061 = env["wfl"]
	var _t2063 = J.gp(env["S"], "gx")
	var _t2064 = (J.sub(J.gp(J.gp(env["S"], "lay"), "floor"), J.gp(J.gp(env["S"], "lay"), "ph")) - 30.0)
	var _t2062 = J.gp(J.gp(env["A"], "MV"), J.gp(J.gp(v_g_1501, "d"), "key"))
	J.cl(_t2061, null, [_t2063, _t2064, J.gp((_t2062 if J.t(_t2062) else {"n": "嚇！"}), "n"), "#e8a088"])
	return true

func _f299(this_, a: Array, env):
	var v_e_1793 = null; var v_p_1794 = null; var v_b_1795 = null; var v_inPlay_1796 = null; var v___1797 = null; var v___1798 = null; var v___1799 = null
	v_e_1793 = J.arg(a, 0)
	J.mc(v_e_1793, "stopPropagation", [])
	J.mc(v_e_1793, "preventDefault", [])
	J.cl(env["ac"], null, [])
	if (not J.t(env["S"])):
		return null
	var _t2070 = env["pt"]
	v_p_1794 = J.cl(_t2070, null, [v_e_1793])
	var _t2071 = env["hit"]
	v_b_1795 = J.cl(_t2071, null, [J.gp(v_p_1794, "x"), J.gp(v_p_1794, "y")])
	if J.t(v_b_1795):
		var _t2072 = {"id": J.gp(v_b_1795, "id"), "t": J.S_performance_("now", [])}
		env["PRESS"] = _t2072
		if J.t(J.gp(J.G.get("navigator"), "vibrate")):
			J.S_navigator_("vibrate", [10.0])
		var _t2073 = {"id": J.gp(v_e_1793, "pointerId"), "btn": J.gp(v_b_1795, "id"), "sx": J.gp(v_p_1794, "x"), "sy": J.gp(v_p_1794, "y")}
		env["ptr"] = _t2073
		var _t2074 = env["S"]
		J.sp(_t2074, "joy", null)
		J.mc(env["cv"], "setPointerCapture", [J.gp(v_e_1793, "pointerId")])
		return null
	var _t2075 = J.cmp(J.gp(v_p_1794, "y"), J.gp(env["A"], "TOP"), ">")
	v_inPlay_1796 = (J.cmp(J.gp(v_p_1794, "y"), J.sub(env["H"], J.gp(env["A"], "BOT")), "<") if _t2075 else _t2075)
	var _t2076 = {"id": J.gp(v_e_1793, "pointerId"), "sx": J.gp(v_p_1794, "x"), "sy": J.gp(v_p_1794, "y"), "drag": false, "hud": (not J.t(v_inPlay_1796))}
	env["ptr"] = _t2076
	if J.t(v_inPlay_1796):
		var _t2077 = env["S"]
		var _t2078 = {"ox": J.gp(v_p_1794, "x"), "oy": J.gp(v_p_1794, "y"), "x": J.gp(v_p_1794, "x"), "y": J.gp(v_p_1794, "y"), "on": false}
		J.sp(_t2077, "joy", _t2078)
	J.mc(env["cv"], "setPointerCapture", [J.gp(v_e_1793, "pointerId")])

func _f300(this_, a: Array, env):
	var v_e_1802 = null; var v_p_1803 = null
	v_e_1802 = J.arg(a, 0)
	J.mc(v_e_1802, "stopPropagation", [])
	var _t2081 = (not J.t(env["S"]))
	var _t2082 = (_t2081 if _t2081 else (not J.t(env["ptr"])))
	if (_t2082 if _t2082 else (not J.seq(J.gp(env["ptr"], "id"), J.gp(v_e_1802, "pointerId")))):
		return null
	var _t2083 = env["pt"]
	v_p_1803 = J.cl(_t2083, null, [v_e_1802])
	var _t2084 = (not J.t(J.gp(env["ptr"], "btn")))
	if ((J.hypot_([J.sub(J.gp(v_p_1803, "x"), J.gp(env["ptr"], "sx")), J.sub(J.gp(v_p_1803, "y"), J.gp(env["ptr"], "sy"))]) > 12.0) if _t2084 else _t2084):
		var _t2085 = env["ptr"]
		J.sp(_t2085, "drag", true)
	if J.t(J.gp(env["S"], "joy")):
		var _t2086 = J.gp(env["S"], "joy")
		var _t2087 = J.gp(v_p_1803, "x")
		J.sp(_t2086, "x", _t2087)
		var _t2088 = J.gp(env["S"], "joy")
		var _t2089 = J.gp(v_p_1803, "y")
		J.sp(_t2088, "y", _t2089)
		if J.t(J.gp(env["ptr"], "drag")):
			var _t2090 = J.gp(env["S"], "joy")
			J.sp(_t2090, "on", true)

func _f301(this_, a: Array, env):
	var v_e_1806 = null; var v_p_1807 = null; var v_was_1808 = null; var v_j_1809 = null; var v_b_1810 = null
	v_e_1806 = J.arg(a, 0)
	J.mc(v_e_1806, "stopPropagation", [])
	if (not J.t(env["S"])):
		env["ptr"] = null
		return null
	if J.t(((not J.seq(J.gp(env["ptr"], "id"), J.gp(v_e_1806, "pointerId"))) if J.t(env["ptr"]) else env["ptr"])):
		return null
	var _t2093 = env["pt"]
	v_p_1807 = J.cl(_t2093, null, [v_e_1806])
	v_was_1808 = env["ptr"]
	env["ptr"] = null
	var _t2094 = J.gp(env["S"], "joy")
	v_j_1809 = (J.gp(J.gp(env["S"], "joy"), "on") if J.t(_t2094) else _t2094)
	var _t2095 = env["S"]
	J.sp(_t2095, "joy", null)
	if (not J.t(v_was_1808)):
		return null
	if J.t(J.gp(v_was_1808, "btn")):
		var _t2096 = env["hit"]
		v_b_1810 = J.cl(_t2096, null, [J.gp(v_p_1807, "x"), J.gp(v_p_1807, "y")])
		var _t2097 = (J.seq(J.gp(v_b_1810, "id"), J.gp(v_was_1808, "btn")) if J.t(v_b_1810) else v_b_1810)
		if J.t((_t2097 if J.t(_t2097) else (J.hypot_([J.sub(J.gp(v_p_1807, "x"), J.gp(v_was_1808, "sx")), J.sub(J.gp(v_p_1807, "y"), J.gp(v_was_1808, "sy"))]) < 24.0))):
			var _t2098 = env["press"]
			J.cl(_t2098, null, [J.gp(v_was_1808, "btn")])
		return null
	var _t2099 = (not J.t(J.gp(v_was_1808, "drag")))
	var _t2100 = ((not J.t(v_j_1809)) if _t2099 else _t2099)
	if ((not J.t(J.gp(v_was_1808, "hud"))) if _t2100 else _t2100):
		var _t2101 = env["worldTap"]
		J.cl(_t2101, null, [J.gp(v_p_1807, "x"), J.gp(v_p_1807, "y")])

func _f302(this_, a: Array, env):
	var v_e_1813 = null
	v_e_1813 = J.arg(a, 0)
	env["ptr"] = null
	if J.t(env["S"]):
		var _t2103 = env["S"]
		J.sp(_t2103, "joy", null)

func _f304(this_, a: Array, env):
	var v_e_1819 = null
	v_e_1819 = J.arg(a, 0)
	J.mc(v_e_1819, "stopPropagation", [])
	if (not J.seq(env["ev"], "touchstart")):
		J.mc(v_e_1819, "preventDefault", [])

func _f303(this_, a: Array, env):
	var _s750 = {"__p": env, "ev": null}
	_s750["ev"] = J.arg(a, 0)
	J.mc(_s750["__p"]["cv"], "addEventListener", [_s750["ev"], Callable(self, "_f304").bind(_s750), {"passive": false}])

func _f310(this_, a: Array, env):
	var v_un_1860 = null; var v_d_1861 = null
	v_un_1860 = J.arg(a, 0)
	var _t2108 = (not J.seq(J.gp(v_un_1860, "f"), J.gp(env["gn"], "f")))
	if not J.t(_t2108):
		var _t2107 = env["__p"]["isHH"]
		_t2108 = (not J.t(J.cl(_t2107, null, [v_un_1860])))
	if _t2108:
		return null
	v_d_1861 = absf(J.num(J.sub(J.gp(v_un_1860, "x"), J.gp(env["g"], "x"))))
	var _t2110 = J.cmp(v_d_1861, env["nd"], "<")
	if J.t(_t2110):
		var _t2109 = env["__p"]["enterable"]
		_t2110 = J.seq(J.cl(_t2109, null, [env["g"], v_un_1860]), true)
	if _t2110:
		env["nd"] = v_d_1861
		env["nearU"] = v_un_1860

func _f312(this_, a: Array, env):
	var v_r_1879 = null
	v_r_1879 = J.arg(a, 0)
	var _t2118 = J.seq(J.gp(v_r_1879, "state"), "flee")
	return (_t2118 if _t2118 else J.seq(J.gp(v_r_1879, "state"), "gone"))

func _f311(this_, a: Array, env):
	var v_un_1864 = null; var v_x_1865 = null; var v_y_1866 = null; var v_CL_1867 = null; var v_gr_1868 = null; var v_I_1869 = null; var v_tags_1870 = null; var v_tt_1871 = null; var v_ok_1872 = null; var v_bw_1873 = null; var v_bh_1874 = null; var v_bxw_1875 = null; var v_byw_1876 = null
	v_un_1864 = J.arg(a, 0)
	v_x_1865 = J.gp(v_un_1864, "x")
	v_y_1866 = J.gp(v_un_1864, "y")
	J.sp(v_un_1864, "_ib", null)
	v_CL_1867 = J.gp(J.G.get("window"), "__twCull")
	var _t2113 = v_CL_1867
	if J.t(_t2113):
		var _t2112 = J.cmp(v_y_1866, J.gp(v_CL_1867, "y0"), "<")
		_t2113 = (_t2112 if _t2112 else J.cmp(J.sub(v_y_1866, 120.0), J.gp(v_CL_1867, "y1"), ">"))
	if J.t(_t2113):
		return null
	if J.seq(J.gp(v_un_1864, "ot"), "deity"):
		v_gr_1868 = J.mc(env["ctx"], "createRadialGradient", [v_x_1865, J.sub(v_y_1866, 60.0), 2.0, v_x_1865, J.sub(v_y_1866, 60.0), 46.0])
		J.mc(v_gr_1868, "addColorStop", [0.0, (J.add("rgba(220,60,40,", (0.32 + (0.08 * sin(J.num(J.mul(env["T"], 2.0)))))) + ")")])
		J.mc(v_gr_1868, "addColorStop", [1.0, "rgba(220,60,40,0)"])
		var _t2114 = env["ctx"]
		J.sp(_t2114, "fillStyle", v_gr_1868)
		J.mc(env["ctx"], "fillRect", [J.sub(v_x_1865, 46.0), J.sub(v_y_1866, 106.0), 92.0, 92.0])
		var _t2115 = env["ctx"]
		J.sp(_t2115, "fillStyle", "rgba(200,40,30,0.85)")
		J.mc(env["ctx"], "fillRect", [J.sub(v_x_1865, 4.0), J.sub(v_y_1866, 104.0), 8.0, 4.0])
		return null
	var _t2116 = env["__p"]["isHH"]
	if (not J.t(J.cl(_t2116, null, [v_un_1864]))):
		return null
	v_I_1869 = J.gp(v_un_1864, "iu")
	v_tags_1870 = []
	if J.t((J.gp(v_I_1869, "done") if J.t(v_I_1869) else v_I_1869)):
		J.mc(v_tags_1870, "push", ["✓任務"])
	var _t2119 = J.len(J.gp(v_un_1864, "rs"))
	if J.t(_t2119):
		var _t2117 = J.gp(v_un_1864, "rs")
		_t2119 = J.mc(_t2117, "every", [Callable(self, "_f312").bind(env)])
	if J.t(_t2119):
		J.mc(v_tags_1870, "push", ["走晒"])
	if J.t((J.cmp(J.gp(v_I_1869, "ban"), 0.0, ">") if J.t(v_I_1869) else v_I_1869)):
		J.mc(v_tags_1870, "push", [(J.add("封 ", ceil(J.num(J.gp(v_I_1869, "ban")))) + "s")])
	if J.t(J.len(v_tags_1870)):
		var _t2120 = env["ctx"]
		var _t2121 = J.add("bold 11px ", J.gp(env["__p"]["A"], "FONT"))
		J.sp(_t2120, "font", _t2121)
		var _t2122 = env["ctx"]
		J.sp(_t2122, "textAlign", "center")
		var _t2123 = env["ctx"]
		J.sp(_t2123, "lineWidth", 3.0)
		var _t2124 = env["ctx"]
		J.sp(_t2124, "strokeStyle", "#000")
		v_tt_1871 = J.mc(v_tags_1870, "join", [" "])
		J.mc(env["ctx"], "strokeText", [v_tt_1871, v_x_1865, J.sub(v_y_1866, 72.0)])
		var _t2125 = env["ctx"]
		var _t2126 = ("#e48a78" if J.t((J.cmp(J.gp(v_I_1869, "ban"), 0.0, ">") if J.t(v_I_1869) else v_I_1869)) else "#b2d394")
		J.sp(_t2125, "fillStyle", _t2126)
		J.mc(env["ctx"], "fillText", [v_tt_1871, v_x_1865, J.sub(v_y_1866, 72.0)])
	var _t2127 = (not J.t(env["g"]))
	var _t2128 = (_t2127 if _t2127 else J.gp(env["g"], "home"))
	var _t2129 = (_t2128 if J.t(_t2128) else J.gp(env["g"], "out"))
	var _t2130 = (_t2129 if J.t(_t2129) else J.gp(env["g"], "inUnit"))
	if J.t((_t2130 if J.t(_t2130) else (not J.seq(v_un_1864, env["nearU"])))):
		return null
	var _t2131 = env["__p"]["enterable"]
	v_ok_1872 = J.seq(J.cl(_t2131, null, [env["g"], v_un_1864]), true)
	if (not J.t(v_ok_1872)):
		return null
	J.mc(env["ctx"], "save", [])
	var _t2132 = env["ctx"]
	var _t2133 = (0.35 + (0.25 * sin(J.num(J.mul(env["T"], 5.0)))))
	J.sp(_t2132, "globalAlpha", _t2133)
	var _t2134 = env["ctx"]
	J.sp(_t2134, "fillStyle", "#78ffbe")
	J.mc(env["ctx"], "fillRect", [J.sub(v_x_1865, 13.0), J.sub(v_y_1866, 62.0), 26.0, 58.0])
	J.mc(env["ctx"], "restore", [])
	v_bw_1873 = 70.0
	v_bh_1874 = 34.0
	v_bxw_1875 = J.sub(v_x_1865, J.div(v_bw_1873, 2.0))
	v_byw_1876 = J.sub(v_y_1866, 112.0)
	J.mc(env["__p"]["A"], "crBlit", [env["ctx"], J.mc(env["__p"]["A"], "crGet", [v_bw_1873, v_bh_1874, "moss", "n"]), v_bxw_1875, v_byw_1876])
	J.mc(env["__p"]["A"], "crText", [env["ctx"], "入屋", v_x_1865, J.add(J.add(v_byw_1876, J.div(v_bh_1874, 2.0)), 1.0), 16.0, "#e4ecd2", "center", J.sub(v_bw_1873, 8.0), true])
	var _t2135 = {"x": v_bxw_1875, "y": v_byw_1876, "w": v_bw_1873, "h": v_bh_1874}
	J.sp(v_un_1864, "_ib", _t2135)

func _f309(this_, a: Array, env):
	var v_g0_1852 = null
	var _s769 = {"__p": env, "ctx": null, "g": null, "T": null, "nearU": null, "nd": null, "gn": null}
	_s769["ctx"] = J.arg(a, 0)
	v_g0_1852 = J.cl(_s769["__p"]["G"], null, [])
	if (not J.t(v_g0_1852)):
		return null
	_s769["g"] = J.gp(J.gp(v_g0_1852, "gh"), J.gp(v_g0_1852, "active"))
	_s769["T"] = J.gp(v_g0_1852, "t")
	_s769["nearU"] = null
	_s769["nd"] = 150.0
	_s769["gn"] = (J.gp(J.gp(v_g0_1852, "nodes"), J.gp(_s769["g"], "node")) if J.t(_s769["g"]) else _s769["g"])
	if J.t(((not J.t(J.gp(_s769["g"], "inUnit"))) if J.t(_s769["gn"]) else _s769["gn"])):
		var _t2106 = J.gp(v_g0_1852, "units")
		J.mc(_t2106, "forEach", [Callable(self, "_f310").bind(_s769)])
	var _t2111 = J.gp(v_g0_1852, "units")
	J.mc(_t2111, "forEach", [Callable(self, "_f311").bind(_s769)])

func _f314(this_, a: Array, env):
	var v_un_1891 = null; var v_b_1892 = null; var v_onBtn_1893 = null; var v_onDoor_1894 = null
	v_un_1891 = J.arg(a, 0)
	if J.t(env["hitU"]):
		return null
	v_b_1892 = J.gp(v_un_1891, "_ib")
	var _t2141 = (J.cmp(env["wx"], J.sub(J.gp(v_b_1892, "x"), 8.0), ">=") if J.t(v_b_1892) else v_b_1892)
	var _t2142 = (J.cmp(env["wx"], J.add(J.add(J.gp(v_b_1892, "x"), J.gp(v_b_1892, "w")), 8.0), "<=") if J.t(_t2141) else _t2141)
	var _t2143 = (J.cmp(env["wy"], J.sub(J.gp(v_b_1892, "y"), 8.0), ">=") if J.t(_t2142) else _t2142)
	v_onBtn_1893 = (J.cmp(env["wy"], J.add(J.add(J.gp(v_b_1892, "y"), J.gp(v_b_1892, "h")), 8.0), "<=") if J.t(_t2143) else _t2143)
	var _t2144 = (absf(J.num(J.sub(env["wx"], J.gp(v_un_1891, "x")))) < 24.0)
	var _t2145 = (J.cmp(env["wy"], J.sub(J.gp(v_un_1891, "y"), 70.0), ">") if _t2144 else _t2144)
	v_onDoor_1894 = (J.cmp(env["wy"], J.add(J.gp(v_un_1891, "y"), 6.0), "<") if _t2145 else _t2145)
	if J.t((v_onBtn_1893 if J.t(v_onBtn_1893) else v_onDoor_1894)):
		env["hitU"] = v_un_1891

func _f313(this_, a: Array, env):
	var v_g0_1884 = null; var v_g_1885 = null; var v_un_1887 = null; var v_ok_1888 = null
	var _s776 = {"__p": env, "wx": null, "wy": null, "hitU": null}
	_s776["wx"] = J.arg(a, 0)
	_s776["wy"] = J.arg(a, 1)
	v_g0_1884 = J.cl(_s776["__p"]["G"], null, [])
	if (not J.t(v_g0_1884)):
		return false
	v_g_1885 = J.gp(J.gp(v_g0_1884, "gh"), J.gp(v_g0_1884, "active"))
	var _t2138 = (not J.t(v_g_1885))
	var _t2139 = (_t2138 if _t2138 else J.gp(v_g_1885, "home"))
	if J.t((_t2139 if J.t(_t2139) else J.gp(v_g_1885, "out"))):
		return false
	_s776["hitU"] = null
	var _t2140 = J.gp(v_g0_1884, "units")
	J.mc(_t2140, "forEach", [Callable(self, "_f314").bind(_s776)])
	v_un_1887 = _s776["hitU"]
	if (not J.t(v_un_1887)):
		return false
	if J.seq(J.gp(v_un_1887, "ot"), "deity"):
		var _t2146 = _s776["__p"]["blockedMsg"]
		J.cl(_t2146, null, [v_g_1885, v_un_1887, "deity"])
		return true
	var _t2147 = _s776["__p"]["isHH"]
	if (not J.t(J.cl(_t2147, null, [v_un_1887]))):
		return false
	var _t2148 = _s776["__p"]["enterable"]
	v_ok_1888 = J.cl(_t2148, null, [v_g_1885, v_un_1887])
	if (not J.seq(v_ok_1888, true)):
		var _t2149 = _s776["__p"]["blockedMsg"]
		J.cl(_t2149, null, [v_g_1885, v_un_1887, v_ok_1888])
		return true
	var _t2150 = J.seq(J.gp(v_g_1885, "node"), J.gp(v_un_1887, "did"))
	if ((not J.t(J.gp(v_g_1885, "to"))) if _t2150 else _t2150):
		J.mc(_s776["__p"]["U"], "enterFromDoor", [v_g_1885, v_un_1887])
		return true
	if J.t(J.mc(_s776["__p"]["A"], "gotoNode", [v_g_1885, J.gp(v_un_1887, "id")])):
		J.sp(v_g_1885, "autoS", null)
		J.mc(_s776["__p"]["A"], "float", [J.gp(v_un_1887, "x"), J.sub(J.gp(v_un_1887, "y"), 96.0), "行去入屋", "#9fd6bf"])
		return true
	J.mc(_s776["__p"]["A"], "float", [J.gp(v_un_1887, "x"), J.sub(J.gp(v_un_1887, "y"), 96.0), "去唔到", "#ffb0b0"])
	return true

func _f316(this_, a: Array, env):
	var v_u_1904 = null
	v_u_1904 = J.arg(a, 0)
	if J.seq(J.gp(v_u_1904, "did"), J.gp(env["n"], "id")):
		env["un"] = v_u_1904

func _f315(this_, a: Array, env):
	var v_g_1897 = null; var v_g0_1900 = null; var v_ok_1901 = null
	var _s782 = {"__p": env, "n": null, "un": null}
	v_g_1897 = J.arg(a, 0)
	_s782["n"] = J.arg(a, 1)
	if (not J.seq(J.gp(_s782["n"], "kind"), "door")):
		return null
	_s782["un"] = null
	v_g0_1900 = J.cl(_s782["__p"]["G"], null, [])
	var _t2153 = J.gp(v_g0_1900, "units")
	J.mc(_t2153, "forEach", [Callable(self, "_f316").bind(_s782)])
	if (not J.t(_s782["un"])):
		return null
	if J.seq(J.gp(_s782["un"], "ot"), "deity"):
		return {"k": "unitRespect", "t": "（神明鎮宅：要尊重，唔入）"}
	var _t2154 = _s782["__p"]["isHH"]
	if (not J.t(J.cl(_t2154, null, [_s782["un"]]))):
		return null
	var _t2155 = _s782["__p"]["enterable"]
	v_ok_1901 = J.cl(_t2155, null, [v_g_1897, _s782["un"]])
	if J.seq(v_ok_1901, true):
		return {"k": "unitIn", "t": J.add("入屋：", (J.gp(J.gp(J.gp(_s782["__p"]["A"], "HH"), J.gp(_s782["un"], "hh")), "n") if J.t(J.gp(J.gp(_s782["__p"]["A"], "HH"), J.gp(_s782["un"], "hh"))) else "住戶")), "un": _s782["un"]}
	var _t2156 = J.seq(v_ok_1901, "ban")
	if (_t2156 if _t2156 else J.seq(v_ok_1901, "cd")):
		return {"k": "unitBan", "t": (J.add((("（" + ("佢哋開晒燈守住" if J.seq(v_ok_1901, "ban") else "陰氣未回")) + "："), ceil(J.num((J.gp(J.gp(_s782["un"], "iu"), "ban") if J.seq(v_ok_1901, "ban") else J.gp(J.gp(_s782["un"], "iu"), "cd"))))) + " 秒）"), "un": _s782["un"]}
	return null

func _f318(this_, a: Array, env):
	var v_u_1913 = null
	v_u_1913 = J.arg(a, 0)
	return J.seq(J.gp(v_u_1913, "did"), J.gp(env["g"], "node"))

func _f317(this_, a: Array, env):
	var v_a_1908 = null; var v_g0_1909 = null; var v_un_1910 = null
	var _s784 = {"__p": env, "g": null}
	_s784["g"] = J.arg(a, 0)
	v_a_1908 = J.arg(a, 1)
	if J.seq(J.gp(v_a_1908, "k"), "unitIn"):
		J.mc(_s784["__p"]["U"], "enterFromDoor", [_s784["g"], J.gp(v_a_1908, "un")])
		return true
	if J.seq(J.gp(v_a_1908, "k"), "unitRespect"):
		v_g0_1909 = J.cl(_s784["__p"]["G"], null, [])
		var _t2159 = J.gp(v_g0_1909, "units")
		v_un_1910 = J.mc(_t2159, "find", [Callable(self, "_f318").bind(_s784)])
		if J.t(v_un_1910):
			var _t2160 = _s784["__p"]["blockedMsg"]
			J.cl(_t2160, null, [_s784["g"], v_un_1910, "deity"])
		return true
	if J.seq(J.gp(v_a_1908, "k"), "unitBan"):
		var _t2161 = _s784["__p"]["blockedMsg"]
		J.cl(_t2161, null, [_s784["g"], J.gp(v_a_1908, "un"), ("ban" if J.cmp(J.gp(J.gp(J.gp(v_a_1908, "un"), "iu"), "ban"), 0.0, ">") else "cd")])
		return true
	return false

func _f319(this_, a: Array, env):
	var v_g_1916 = null
	v_g_1916 = J.arg(a, 0)
	return (not (not J.t((J.seq(J.gp(env["S"], "g"), v_g_1916) if J.t(env["S"]) else env["S"]))))

func _f320(this_, a: Array, env):
	return J.cl(env["visible"], null, [])

func _f321(this_, a: Array, env):
	return (not (not J.t(env["S"])))

func _f323(this_, a: Array, env):
	var v_nc_1929 = null; var v_e_1930 = null
	v_nc_1929 = J.arg(a, 0)
	env["c"] = v_nc_1929
	J.cl(env["draw"], null, [])
	env["c"] = env["c0"]

func _f325(this_, a: Array, env):
	var v_a_1935 = null
	v_a_1935 = J.arg(a, 0)
	var _t2184 = J.gp(J.gp(v_a_1935, "r"), "hh")
	var _t2185 = J.round(J.num(J.gp(v_a_1935, "x")))
	var _t2183 = env["roomAt"]
	var _t2187 = J.cl(_t2183, null, [J.gp(v_a_1935, "x")])
	var _t2188 = J.gp(v_a_1935, "act")
	var _t2189 = J.gp(v_a_1935, "st")
	var _t2190 = (not (not J.t(J.gp(J.gp(v_a_1935, "r"), "awake"))))
	var _t2186 = J.gp(J.gp(v_a_1935, "r"), "fear")
	return {"hh": _t2184, "x": _t2185, "room": _t2187, "act": _t2188, "st": _t2189, "awake": _t2190, "fear": J.round(J.num((_t2186 if J.t(_t2186) else 0.0))), "rstate": J.gp(J.gp(v_a_1935, "r"), "state")}

func _f326(this_, a: Array, env):
	var v_p_1938 = null
	v_p_1938 = J.arg(a, 0)
	return {"k": J.gp(v_p_1938, "k"), "x": J.gp(v_p_1938, "x"), "y": J.gp(v_p_1938, "y"), "room": J.gp(v_p_1938, "room"), "cd": J.round(J.num(J.gp(v_p_1938, "cd")))}

func _f327(this_, a: Array, env):
	var v_p_1941 = null; var v_i_1942 = null
	v_p_1941 = J.arg(a, 0)
	v_i_1942 = J.arg(a, 1)
	var _t2197 = J.gp(v_p_1941, "x")
	var _t2198 = J.gp(v_p_1941, "y")
	var _t2196 = env["itemsAt"]
	return {"x": _t2197, "y": _t2198, "items": J.cl(_t2196, null, [v_i_1942])}

func _f324(this_, a: Array, env):
	if (not J.t(env["S"])):
		return null
	var _t2173 = J.gp(J.gp(env["S"], "un"), "id")
	var _t2174 = J.gp(J.gp(env["S"], "un"), "hh")
	var _t2175 = J.gp(J.gp(env["S"], "lay"), "key")
	var _t2176 = J.round(J.num(J.gp(env["S"], "gx")))
	var _t2172 = env["roomAt"]
	var _t2178 = J.cl(_t2172, null, [J.gp(env["S"], "gx")])
	var _t2179 = J.div(J.round(J.num(J.mul(J.gp(env["S"], "alert"), 10.0))), 10.0)
	var _t2180 = J.round(J.num(J.gp(env["S"], "limit")))
	var _t2181 = J.mc(J.gp(env["S"], "light"), "slice", [])
	var _t2177 = J.gp(env["S"], "dark")
	var _t2191 = J.mc(_t2177, "map", [J.gp(J.G.get("Math"), "round")])
	var _t2192 = {"k": J.gp(J.gp(env["S"], "task"), "k"), "t": J.gp(J.gp(env["S"], "task"), "t"), "done": (not (not J.t(J.gp(J.gp(env["S"], "task"), "done")))), "spot": J.gp(J.gp(env["S"], "task"), "spot"), "x": J.gp(J.gp(env["S"], "task"), "x")}
	var _t2182 = J.gp(env["S"], "actors")
	var _t2194 = J.mc(_t2182, "map", [Callable(self, "_f325").bind(env)])
	var _t2193 = J.gp(env["S"], "spots")
	var _t2199 = J.mc(_t2193, "map", [Callable(self, "_f326").bind(env)])
	var _t2195 = J.gp(env["S"], "search")
	var _t2201 = J.mc(_t2195, "map", [Callable(self, "_f327").bind(env)])
	var _t2200 = J.gp(env["U"], "_err")
	return {"un": _t2173, "hh": _t2174, "lay": _t2175, "gx": _t2176, "room": _t2178, "alert": _t2179, "limit": _t2180, "light": _t2181, "dark": _t2191, "task": _t2192, "actors": _t2194, "spots": _t2199, "search": _t2201, "err": (_t2200 if J.t(_t2200) else null), "sc": (not (not J.t(J.gp(env["S"], "sc")))), "scCd": J.gp(env["S"], "scCd"), "invT": J.gp(env["S"], "invT"), "stun": J.gp(env["S"], "stun")}

func _f328(this_, a: Array, env):
	var v_x_1945 = null; var v_y_1946 = null; var v_V_1947 = null; var v_q_1948 = null; var v_r_1949 = null
	v_x_1945 = J.arg(a, 0)
	v_y_1946 = J.arg(a, 1)
	if (not J.t(env["S"])):
		return null
	v_V_1947 = J.cl(env["view"], null, [])
	var _t2204 = env["P"]
	v_q_1948 = J.cl(_t2204, null, [v_x_1945, v_y_1946, v_V_1947])
	v_r_1949 = J.mc(env["cv"], "getBoundingClientRect", [])
	return {"x": J.add(J.gp(v_q_1948, "x"), J.gp(v_r_1949, "left")), "y": J.add(J.gp(v_q_1948, "y"), J.gp(v_r_1949, "top"))}

func _f329(this_, a: Array, env):
	var v_V_1952 = null
	if (not J.t(env["S"])):
		return null
	v_V_1952 = J.cl(env["view"], null, [])
	var _t2207 = J.gp(env["S"], "cam")
	var _t2208 = env["clamp"]
	var _t2209 = J.cl(_t2208, null, [(J.gp(J.gp(env["S"], "cam"), "free") if (not J.leq(J.gp(J.gp(env["S"], "cam"), "free"), null)) else J.sub(J.gp(env["S"], "gx"), J.div(J.gp(v_V_1952, "vw"), 2.0))), 0.0, J.max_([0.0, J.sub(J.gp(J.gp(env["S"], "lay"), "W"), J.gp(v_V_1952, "vw"))])])
	J.sp(_t2207, "x", _t2209)

func _f331(this_, a: Array, env):
	var v_b_1958 = null
	v_b_1958 = J.arg(a, 0)
	return {"id": J.gp(v_b_1958, "id"), "x": J.add(J.gp(v_b_1958, "x"), J.gp(env["r"], "left")), "y": J.add(J.gp(v_b_1958, "y"), J.gp(env["r"], "top")), "w": J.gp(v_b_1958, "w"), "h": J.gp(v_b_1958, "h")}

func _f330(this_, a: Array, env):
	var _s810 = {"__p": env, "r": null}
	_s810["r"] = J.mc(_s810["__p"]["cv"], "getBoundingClientRect", [])
	return J.mc(_s810["__p"]["BTN"], "map", [Callable(self, "_f331").bind(_s810)])

func _f332(this_, a: Array, env):
	var v_v_1961 = null
	v_v_1961 = J.arg(a, 0)
	if J.t(env["S"]):
		var _t2214 = env["S"]
		J.sp(_t2214, "alert", v_v_1961)

func _f333(this_, a: Array, env):
	var v_x_1964 = null
	v_x_1964 = J.arg(a, 0)
	if J.t(env["S"]):
		var _t2217 = env["S"]
		J.sp(_t2217, "gx", v_x_1964)
		var _t2218 = env["S"]
		J.sp(_t2218, "goX", null)

func _f334(this_, a: Array, env):
	var v_i_1967 = null
	v_i_1967 = J.arg(a, 0)
	var _t2222 = null
	if J.t(env["S"]):
		var _t2221 = env["trigger"]
		_t2222 = J.cl(_t2221, null, [J.gp(J.gp(env["S"], "spots"), v_i_1967), false])
	else:
		_t2222 = false
	return _t2222

func _f335(this_, a: Array, env):
	return env["S"]

func _f168(this_, a: Array, env):
	var v_ACTN_957 = null
	var _s381 = {"__p": env, "A": null, "U": null, "S": null, "lastG": null, "LIMIT": null, "BAN": null, "REIN": null, "SEE_LIT": null, "SEE_DARK": null, "RANGE_HOT": null, "RANGE_SCARE": null, "OMEN": null, "HOT": null, "LN": null, "lnUsed": null, "WANT": null, "TASK": null, "FB": null, "AC": null, "NB": null, "SND": null, "cv": null, "c0": null, "c": null, "W": null, "H": null, "DPR": null, "BTN": null, "PRESS": null, "ptr": null, "last": null, "line": null, "LAYS": null, "layFor": null, "G": null, "rnd": null, "pick": null, "img": null, "clamp": null, "wpick": null, "isHH": null, "iu": null, "roomAt": null, "sayR": null, "msg": null, "wfl": null, "part": null, "running": null, "visible": null, "ac": null, "tone": null, "hiss": null, "enterable": null, "blockedMsg": null, "open": null, "mkActor": null, "actPose": null, "pickAct": null, "searchUpdate": null, "itemsAt": null, "actorsUpdate": null, "lightsUpdate": null, "facing": null, "detect": null, "thresholds": null, "trigger": null, "addRFear": null, "roomTask": null, "taskDone": null, "taskCheck": null, "nearestActor": null, "scareAt": null, "strike": null, "hideNative": null, "layout": null, "view": null, "P": null, "sprite": null, "bubble": null, "btn": null, "txt": null, "drawBG": null, "drawSpot": null, "drawActor": null, "drawGhost": null, "draw": null, "drawHUD": null, "ctxBtn": null, "wrapT": null, "drawJoy": null, "pt": null, "hit": null, "press": null, "worldTap": null, "loop": null}
	_s381["A"] = J.arg(a, 0)
	_s381["line"] = Callable(self, "_f169").bind(_s381)
	_s381["LAYS"] = Callable(self, "_f171").bind(_s381)
	_s381["layFor"] = Callable(self, "_f172").bind(_s381)
	_s381["G"] = Callable(self, "_f173").bind(_s381)
	_s381["rnd"] = Callable(self, "_f174").bind(_s381)
	_s381["pick"] = Callable(self, "_f175").bind(_s381)
	_s381["img"] = Callable(self, "_f176").bind(_s381)
	_s381["clamp"] = Callable(self, "_f177").bind(_s381)
	_s381["wpick"] = Callable(self, "_f178").bind(_s381)
	_s381["isHH"] = Callable(self, "_f180").bind(_s381)
	_s381["iu"] = Callable(self, "_f181").bind(_s381)
	_s381["roomAt"] = Callable(self, "_f182").bind(_s381)
	_s381["sayR"] = Callable(self, "_f183").bind(_s381)
	_s381["msg"] = Callable(self, "_f184").bind(_s381)
	_s381["wfl"] = Callable(self, "_f185").bind(_s381)
	_s381["part"] = Callable(self, "_f187").bind(_s381)
	_s381["running"] = Callable(self, "_f188").bind(_s381)
	_s381["visible"] = Callable(self, "_f189").bind(_s381)
	_s381["ac"] = Callable(self, "_f190").bind(_s381)
	_s381["tone"] = Callable(self, "_f191").bind(_s381)
	_s381["hiss"] = Callable(self, "_f192").bind(_s381)
	_s381["enterable"] = Callable(self, "_f199").bind(_s381)
	_s381["blockedMsg"] = Callable(self, "_f202").bind(_s381)
	_s381["open"] = Callable(self, "_f204").bind(_s381)
	_s381["mkActor"] = Callable(self, "_f214").bind(_s381)
	_s381["actPose"] = Callable(self, "_f215").bind(_s381)
	_s381["pickAct"] = Callable(self, "_f216").bind(_s381)
	_s381["searchUpdate"] = Callable(self, "_f229").bind(_s381)
	_s381["itemsAt"] = Callable(self, "_f232").bind(_s381)
	_s381["actorsUpdate"] = Callable(self, "_f234").bind(_s381)
	_s381["lightsUpdate"] = Callable(self, "_f241").bind(_s381)
	_s381["facing"] = Callable(self, "_f244").bind(_s381)
	_s381["detect"] = Callable(self, "_f245").bind(_s381)
	_s381["thresholds"] = Callable(self, "_f250").bind(_s381)
	_s381["trigger"] = Callable(self, "_f254").bind(_s381)
	_s381["addRFear"] = Callable(self, "_f256").bind(_s381)
	_s381["roomTask"] = Callable(self, "_f257").bind(_s381)
	_s381["taskDone"] = Callable(self, "_f258").bind(_s381)
	_s381["taskCheck"] = Callable(self, "_f259").bind(_s381)
	_s381["nearestActor"] = Callable(self, "_f261").bind(_s381)
	_s381["scareAt"] = Callable(self, "_f263").bind(_s381)
	_s381["strike"] = Callable(self, "_f265").bind(_s381)
	_s381["hideNative"] = Callable(self, "_f266").bind(_s381)
	_s381["layout"] = Callable(self, "_f267").bind(_s381)
	_s381["view"] = Callable(self, "_f268").bind(_s381)
	_s381["P"] = Callable(self, "_f269").bind(_s381)
	_s381["sprite"] = Callable(self, "_f270").bind(_s381)
	_s381["bubble"] = Callable(self, "_f271").bind(_s381)
	_s381["btn"] = Callable(self, "_f272").bind(_s381)
	_s381["txt"] = Callable(self, "_f273").bind(_s381)
	_s381["drawBG"] = Callable(self, "_f274").bind(_s381)
	_s381["drawSpot"] = Callable(self, "_f277").bind(_s381)
	_s381["drawActor"] = Callable(self, "_f278").bind(_s381)
	_s381["drawGhost"] = Callable(self, "_f279").bind(_s381)
	_s381["draw"] = Callable(self, "_f280").bind(_s381)
	_s381["drawHUD"] = Callable(self, "_f290").bind(_s381)
	_s381["ctxBtn"] = Callable(self, "_f293").bind(_s381)
	_s381["wrapT"] = Callable(self, "_f295").bind(_s381)
	_s381["drawJoy"] = Callable(self, "_f296").bind(_s381)
	_s381["pt"] = Callable(self, "_f297").bind(_s381)
	_s381["hit"] = Callable(self, "_f298").bind(_s381)
	_s381["press"] = Callable(self, "_f305").bind(_s381)
	_s381["worldTap"] = Callable(self, "_f306").bind(_s381)
	_s381["loop"] = Callable(self, "_f322").bind(_s381)
	_s381["U"] = {}
	_s381["S"] = null
	_s381["lastG"] = null
	_s381["LIMIT"] = 80.0
	_s381["BAN"] = 25.0
	_s381["REIN"] = 6.0
	_s381["SEE_LIT"] = 26.0
	_s381["SEE_DARK"] = 7.0
	_s381["RANGE_HOT"] = 130.0
	_s381["RANGE_SCARE"] = 150.0
	_s381["OMEN"] = 0.6
	_s381["HOT"] = {"lamp": {"v": "閃燈熄燈", "f": 14.0, "loud": 0.0, "ln": ["盞燈做咩閃吓閃吓……", "跳掣？黑麻麻咁……", "又停電？"]}, "tv": {"v": "電視雪花", "f": 24.0, "loud": 1.0, "ln": ["部電視自己轉台？！", "雪花入面……好似有個人影", "我冇撳過遙控㗎！"]}, "tap": {"v": "水喉自己開", "f": 20.0, "loud": 1.0, "ln": ["邊個開咗水喉？", "水喉自己嘩啦嘩啦咁流……"]}, "fridge": {"v": "雪櫃門自己開", "f": 20.0, "loud": 0.0, "ln": ["雪櫃門自己彈開咗！", "點解成間屋咁凍……"]}, "wardrobe": {"v": "衣櫃門自己開", "f": 24.0, "loud": 1.0, "ln": ["衣櫃門……自己慢慢打開……", "入面係咪有人匿埋？"]}, "mirror": {"v": "鏡入面多個影", "f": 28.0, "loud": 0.0, "ln": ["面鏡……我後面有人？", "頭先鏡入面嗰個唔係我……"]}, "pc": {"v": "電腦彈鬼臉", "f": 26.0, "loud": 1.0, "ln": ["個 mon 彈咗張臉出嚟！", "我隻角色自己行開咗？！"]}, "fan": {"v": "風扇狂轉", "f": 18.0, "loud": 0.0, "ln": ["把風扇自己轉到咁大力？！", "啲窗簾吹到飛晒起……"]}, "shower": {"v": "花灑自己開", "f": 22.0, "loud": 1.0, "ln": ["花灑自己開咗……", "冇人喺度，點解有水聲？"]}, "radio": {"v": "收音機自己播", "f": 20.0, "loud": 1.0, "ln": ["收音機自己播粵曲……", "邊個開咗收音機？"]}, "pots": {"v": "鑊鏟自己跌", "f": 22.0, "loud": 1.0, "ln": ["乒乓聲！鑊鏟自己跌落地！", "廚房咩聲呀？！"]}, "net": {"v": "蚊帳自己郁", "f": 22.0, "loud": 0.0, "ln": ["蚊帳自己郁緊……", "冇風㗎喎，點解蚊帳會郁？"]}, "jar": {"v": "水缸冒泡", "f": 20.0, "loud": 0.0, "ln": ["水缸咕嚕咕嚕咁冒泡……", "水缸入面……有嘢？"]}}
	_s381["LN"] = {"see": ["嗰度……有嘢！", "頭先係咪有個影？", "邊個喺度？！", "我見到喇！唔好走！", "你……你係邊個？"], "lightOn": ["開燈先……", "咁黑，開咗盞燈先", "點解會跳掣嘅？開返先"], "go": ["咩聲嚟㗎？去睇睇", "我過去睇下……", "邊度傳嚟嘅聲？"], "look": ["冇嘢喎……", "係咪我聽錯？", "奇怪……明明有聲"], "wake": ["醒醒呀！屋企有嘢呀！", "起身呀，有怪聲呀！"], "phone": ["喂？管理處呀？我屋企有古怪，快啲上嚟！", "喂？保安呀？我哋呢層有嘢呀！"], "lights": ["開晒啲燈！開晒佢！", "全部燈開晒，睇佢仲點匿！"], "kick": ["出去呀！唔好再嚟！", "開晒燈大嗌：「唔該你出去！」"], "leave": ["返工喇，出門口先", "出去行下先"]}
	_s381["lnUsed"] = {}
	_s381["WANT"] = {"gamer": [["pc", 6.0], ["fridge", 1.5], ["sofa", 1.5], ["wash", 1.0]], "ot": [["desk", 4.0], ["tv", 3.0], ["cook", 2.0], ["shower", 1.0]], "gym": [["sofa", 2.0], ["shower", 3.0], ["cook", 3.0], ["tv", 2.0]], "nurse": [["cook", 3.0], ["tv", 3.0], ["shower", 3.0], ["desk", 1.0]], "elder": [["radio", 5.0], ["cook", 2.0], ["wash", 1.0], ["desk", 2.0]], "insomnia": [["radio", 5.0], ["cook", 2.0], ["desk", 3.0]], "granny": [["tv", 6.0], ["cook", 3.0], ["wash", 1.0]], "couple": [["tv", 5.0], ["cook", 2.5], ["shower", 2.5]], "mahjong": [["table", 1.0]], "shopper": [["sofa", 5.0], ["desk", 2.0], ["cook", 3.0]], "taxi": [["tv", 6.0], ["cook", 2.0], ["shower", 2.0]], "cook": [["cook", 7.0], ["tv", 3.0]], "helper": [["cook", 4.0], ["sink", 3.0], ["shower", 1.0], ["wash", 2.0]], "debt": [["sofa", 6.0], ["desk", 4.0]]}
	v_ACTN_957 = {"pc": "打機", "desk": "坐喺枱前", "sofa": "坐梳化", "tv": "睇電視", "radio": "聽收音機", "table": "打麻雀", "cook": "煮嘢食", "sink": "洗碗", "fridge": "搵嘢食", "shower": "沖涼", "wash": "洗面", "bed": "瞓覺"}
	_s381["TASK"] = {"gamer": {"k": "media"}, "ot": {"k": "steal", "o": "公司門卡", "at": "desk"}, "gym": {"k": "room", "room": "bath", "act": "shower"}, "nurse": {"k": "room", "room": "bath", "act": "shower"}, "elder": {"k": "media"}, "insomnia": {"k": "media"}, "granny": {"k": "steal", "o": "葵扇", "at": "sofa"}, "couple": {"k": "allout"}, "mahjong": {"k": "steal", "o": "一隻麻雀牌", "at": "table"}, "shopper": {"k": "steal", "o": "速遞包裹", "at": "door"}, "taxi": {"k": "media"}, "cook": {"k": "room", "room": "kitchen", "act": "cook"}, "helper": {"k": "steal", "o": "熨斗", "at": "cook"}, "debt": {"k": "steal", "o": "門口嗰封追數信", "at": "door"}}
	_s381["FB"] = {"img": null, "W": 1440.0, "H": 420.0, "crop": [20.0, 420.0], "floor": 396.0, "ceil": 40.0, "ph": 230.0, "door": 40.0, "fb": true, "rooms": [{"k": "living", "n": "客廳", "x0": 0.0, "x1": 360.0}, {"k": "kitchen", "n": "廚房", "x0": 360.0, "x1": 720.0}, {"k": "bed", "n": "睡房", "x0": 720.0, "x1": 1080.0}, {"k": "bath", "n": "廁所", "x0": 1080.0, "x1": 1440.0}], "spots": [{"k": "lamp", "x": 180.0, "y": 70.0}, {"k": "tv", "x": 300.0, "y": 270.0}, {"k": "fridge", "x": 640.0, "y": 270.0}, {"k": "tap", "x": 500.0, "y": 280.0}, {"k": "wardrobe", "x": 1000.0, "y": 260.0}, {"k": "mirror", "x": 1200.0, "y": 220.0}], "acts": {"sofa": {"x": 150.0, "pose": "sit", "look": "tv"}, "tv": {"x": 200.0, "pose": "sit", "look": "tv"}, "radio": {"x": 200.0, "pose": "sit", "look": "tv"}, "table": {"x": 180.0, "seats": [100.0, 150.0, 210.0, 260.0], "pose": "sit"}, "cook": {"x": 450.0, "look": "tap"}, "sink": {"x": 520.0, "look": "tap"}, "fridge": {"x": 610.0, "look": "fridge"}, "desk": {"x": 800.0, "pose": "sit", "look": "wardrobe"}, "pc": {"x": 800.0, "pose": "sit", "look": "wardrobe"}, "bed": {"x": 900.0, "pose": "lie", "lift": 60.0}, "shower": {"x": 1300.0}, "wash": {"x": 1200.0, "look": "mirror"}}, "search": [{"x": 90.0, "y": 360.0, "n": "櫃桶"}, {"x": 560.0, "y": 340.0, "n": "碗櫃"}, {"x": 1040.0, "y": 360.0, "n": "衣櫃底"}, {"x": 1380.0, "y": 370.0, "n": "膠桶"}], "steal": {}}
	_s381["AC"] = null
	_s381["NB"] = null
	_s381["SND"] = {"door": Callable(self, "_f193").bind(_s381), "hot": Callable(self, "_f194").bind(_s381), "scare": Callable(self, "_f195").bind(_s381), "see": Callable(self, "_f196").bind(_s381), "kick": Callable(self, "_f197").bind(_s381)}
	J.S_document_("addEventListener", ["pointerdown", Callable(self, "_f198").bind(_s381), {"passive": true}])
	var _t1891 = _s381["U"]
	var _t1893 = Callable(self, "_f200").bind(_s381)
	J.sp(_t1891, "canEnter", _t1893)
	var _t1894 = _s381["U"]
	var _t1900 = Callable(self, "_f201").bind(_s381)
	J.sp(_t1894, "enterFromDoor", _t1900)
	var _t1901 = _s381["U"]
	var _t1912 = Callable(self, "_f203").bind(_s381)
	J.sp(_t1901, "arrive", _t1912)
	var _t1913 = _s381["U"]
	var _t1927 = Callable(self, "_f218").bind(_s381)
	J.sp(_t1913, "exit", _t1927)
	var _t1928 = _s381["U"]
	var _t2040 = Callable(self, "_f219").bind(_s381)
	J.sp(_t1928, "step", _t2040)
	var _t2041 = _s381["U"]
	var _t2065 = Callable(self, "_f264").bind(_s381)
	J.sp(_t2041, "scare", _t2065)
	_s381["cv"] = J.S_document_("createElement", ["canvas"])
	var _t2066 = _s381["cv"]
	J.sp(_t2066, "id", "unit-cv")
	var _t2067 = J.gp(_s381["cv"], "style")
	J.sp(_t2067, "cssText", "position:fixed;z-index:63;left:0;top:0;display:none;touch-action:none")
	var _t2068 = J.gp(J.G.get("document"), "body")
	J.mc(_t2068, "appendChild", [_s381["cv"]])
	_s381["c0"] = J.mc(_s381["cv"], "getContext", ["2d"])
	_s381["c"] = _s381["c0"]
	_s381["W"] = 390.0
	_s381["H"] = 844.0
	_s381["DPR"] = 1.0
	_s381["BTN"] = []
	_s381["PRESS"] = null
	_s381["ptr"] = null
	var _t2069 = J.G.get("window")
	var _t2079 = Callable(self, "_f299").bind(_s381)
	J.sp(_t2069, "__twUPD", _t2079)
	J.mc(_s381["cv"], "addEventListener", ["pointerdown", _t2079])
	var _t2080 = J.G.get("window")
	var _t2091 = Callable(self, "_f300").bind(_s381)
	J.sp(_t2080, "__twUPM", _t2091)
	J.mc(_s381["cv"], "addEventListener", ["pointermove", _t2091])
	var _t2092 = J.G.get("window")
	var _t2102 = Callable(self, "_f301").bind(_s381)
	J.sp(_t2092, "__twUPU", _t2102)
	J.mc(_s381["cv"], "addEventListener", ["pointerup", _t2102])
	J.mc(_s381["cv"], "addEventListener", ["pointercancel", Callable(self, "_f302").bind(_s381)])
	var _t2104 = ["touchstart", "touchmove", "touchend", "click", "contextmenu"]
	J.mc(_t2104, "forEach", [Callable(self, "_f303").bind(_s381)])
	var _t2105 = _s381["U"]
	var _t2136 = Callable(self, "_f309").bind(_s381)
	J.sp(_t2105, "drawWorld", _t2136)
	var _t2137 = _s381["U"]
	var _t2151 = Callable(self, "_f313").bind(_s381)
	J.sp(_t2137, "worldTap", _t2151)
	var _t2152 = _s381["U"]
	var _t2157 = Callable(self, "_f315").bind(_s381)
	J.sp(_t2152, "action", _t2157)
	var _t2158 = _s381["U"]
	var _t2162 = Callable(self, "_f317").bind(_s381)
	J.sp(_t2158, "act", _t2162)
	var _t2163 = _s381["U"]
	var _t2164 = Callable(self, "_f319").bind(_s381)
	J.sp(_t2163, "holds", _t2164)
	var _t2165 = _s381["U"]
	var _t2166 = Callable(self, "_f320").bind(_s381)
	J.sp(_t2165, "covering", _t2166)
	var _t2167 = _s381["U"]
	var _t2168 = Callable(self, "_f321").bind(_s381)
	J.sp(_t2167, "on", _t2168)
	_s381["last"] = 0.0
	J.F_requestAnimationFrame([_s381["loop"]])
	var _t2169 = _s381["U"]
	var _t2170 = Callable(self, "_f323").bind(_s381)
	J.sp(_t2169, "drawN", _t2170)
	var _t2171 = _s381["U"]
	var _t2202 = Callable(self, "_f324").bind(_s381)
	J.sp(_t2171, "state", _t2202)
	var _t2203 = _s381["U"]
	var _t2205 = Callable(self, "_f328").bind(_s381)
	J.sp(_t2203, "toScreen", _t2205)
	var _t2206 = _s381["U"]
	var _t2210 = Callable(self, "_f329").bind(_s381)
	J.sp(_t2206, "camSnap", _t2210)
	var _t2211 = _s381["U"]
	var _t2212 = Callable(self, "_f330").bind(_s381)
	J.sp(_t2211, "btns", _t2212)
	var _t2213 = _s381["U"]
	var _t2215 = Callable(self, "_f332").bind(_s381)
	J.sp(_t2213, "setAlert", _t2215)
	var _t2216 = _s381["U"]
	var _t2219 = Callable(self, "_f333").bind(_s381)
	J.sp(_t2216, "setGX", _t2219)
	var _t2220 = _s381["U"]
	var _t2223 = Callable(self, "_f334").bind(_s381)
	J.sp(_t2220, "trig", _t2223)
	var _t2224 = _s381["U"]
	var _t2225 = _s381["press"]
	J.sp(_t2224, "press", _t2225)
	var _t2226 = _s381["U"]
	var _t2227 = _s381["layFor"]
	J.sp(_t2226, "layFor", _t2227)
	var _t2228 = _s381["U"]
	var _t2229 = _s381["HOT"]
	J.sp(_t2228, "HOT", _t2229)
	var _t2230 = _s381["U"]
	var _t2231 = Callable(self, "_f335").bind(_s381)
	J.sp(_t2230, "_S", _t2231)
	return _s381["U"]

func _f167(this_, a: Array, env):
	var _t1046 = J.G.get("window")
	var _t2232 = Callable(self, "_f168").bind(env)
	J.sp(_t1046, "UnitSys", _t2232)

func _f337(this_, a: Array, env):
	if (not J.t(J.gp(J.G.get("S"), "tower"))):
		var _t2233 = J.G.get("S")
		var _t2234 = {"unlocked": true, "cleared": {}, "best": 0.0, "nights": 0.0}
		J.sp(_t2233, "tower", _t2234)
	var _t2235 = J.gp(J.G.get("S"), "tower")
	var _t2236 = J.gp(J.gp(J.G.get("S"), "tower"), "cleared")
	var _t2237 = (_t2236 if J.t(_t2236) else {})
	J.sp(_t2235, "cleared", _t2237)
	return J.gp(J.G.get("S"), "tower")

func _f339(this_, a: Array, env):
	var v___2252 = null; var v_i_2253 = null
	v___2252 = J.arg(a, 0)
	v_i_2253 = J.arg(a, 1)
	return (J.add("第 ", J.add(v_i_2253, 1.0)) + " 段")

func _f338(this_, a: Array, env):
	var v_k_2248 = null; var v_T_2249 = null
	v_k_2248 = J.arg(a, 0)
	v_T_2249 = J.gp(env["LEVELS"], v_k_2248)
	var _t2238 = env["genLevel"]
	var _t2239 = J.cl(_t2238, null, [v_k_2248])
	env["LV"] = _t2239
	var _t2240 = env["LV"]
	var _t2241 = J.gp(v_T_2249, "story")
	J.sp(_t2240, "story", _t2241)
	var _t2242 = env["LV"]
	var _t2243 = J.gp(v_T_2249, "truth")
	J.sp(_t2242, "truth", _t2243)
	var _t2244 = env["LV"]
	var _t2245 = J.gp(v_T_2249, "story")
	var _t2246 = J.mc(_t2245, "map", [Callable(self, "_f339").bind(env)])
	J.sp(_t2244, "hint", _t2246)
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

func _f340(this_, a: Array, env):
	var v_f_2256 = null
	v_f_2256 = J.arg(a, 0)
	return J.gp(env["FYS"], v_f_2256)

func _f341(this_, a: Array, env):
	var _t2247 = J.mod(J.mul(env["seed"], 16807.0), 2147483647.0)
	env["seed"] = _t2247
	return J.div(J.sub(env["seed"], 1.0), 2147483646.0)

func _f342(this_, a: Array, env):
	var v_a_2261 = null
	v_a_2261 = J.arg(a, 0)
	return J.gp(v_a_2261, floor(J.num(J.mul(J.cl(env["rnd"], null, []), J.len(v_a_2261)))))

func _f343(this_, a: Array, env):
	var v_a_2264 = null; var v_i_2265 = null; var v_j_2266 = null; var v_t_2267 = null
	v_a_2264 = J.arg(a, 0)
	var _t2248 = J.mc(v_a_2264, "slice", [])
	v_a_2264 = _t2248
	v_i_2265 = (J.len(v_a_2264) - 1.0)
	while true:
		if not J.cmp(v_i_2265, 0.0, ">"): break
		v_j_2266 = floor(J.num(J.mul(J.cl(env["rnd"], null, []), J.add(v_i_2265, 1.0))))
		v_t_2267 = J.gp(v_a_2264, v_i_2265)
		var _t2249 = J.gp(v_a_2264, v_j_2266)
		J.sp(v_a_2264, v_i_2265, _t2249)
		J.sp(v_a_2264, v_j_2266, v_t_2267)
		v_i_2265 = J.num(v_i_2265) + -1.0
	return v_a_2264

func _f344(this_, a: Array, env):
	var v_v_2270 = null; var v_a_2271 = null; var v_b_2272 = null
	v_v_2270 = J.arg(a, 0)
	v_a_2271 = J.arg(a, 1)
	v_b_2272 = J.arg(a, 2)
	return (v_a_2271 if J.cmp(v_v_2270, v_a_2271, "<") else (v_b_2272 if J.cmp(v_v_2270, v_b_2272, ">") else v_v_2270))

func _f346(this_, a: Array, env):
	var v___2279 = null; var v_i_2280 = null
	v___2279 = J.arg(a, 0)
	v_i_2280 = J.arg(a, 1)
	return v_i_2280

func _f347(this_, a: Array, env):
	var v___2283 = null; var v_i_2284 = null
	v___2283 = J.arg(a, 0)
	v_i_2284 = J.arg(a, 1)
	return v_i_2284

func _f345(this_, a: Array, env):
	var v_k_2275 = null; var v_p_2276 = null
	v_k_2275 = J.arg(a, 0)
	v_p_2276 = J.gp(env["LINES"], v_k_2275)
	var _t2250 = env["used"]
	var _t2252 = J.gp(env["used"], v_k_2275)
	if not J.t(_t2252):
		var _t2251 = env["shuffle"]
		_t2252 = J.cl(_t2251, null, [J.mc(v_p_2276, "map", [Callable(self, "_f346").bind(env)])])
	J.sp(_t2250, v_k_2275, _t2252)
	if (not J.t(J.len(J.gp(env["used"], v_k_2275)))):
		var _t2253 = env["used"]
		var _t2254 = env["shuffle"]
		var _t2255 = J.cl(_t2254, null, [J.mc(v_p_2276, "map", [Callable(self, "_f347").bind(env)])])
		J.sp(_t2253, v_k_2275, _t2255)
	return J.gp(v_p_2276, J.mc(J.gp(env["used"], v_k_2275), "pop", []))

func _f348(this_, a: Array, env):
	var v_d_2287 = null; var v_P_2288 = null; var v_pw_2289 = null; var v_m_2290 = null; var v_e_2291 = null
	v_d_2287 = J.arg(a, 0)
	v_P_2288 = J.gp(J.G.get("window"), "GP")
	var _t2256 = (not J.t(v_P_2288))
	if (_t2256 if _t2256 else (not J.t(J.gp(v_d_2287, "gpk")))):
		return {"mul": 1.0, "pow": 0.0, "tr": false, "na": true}
	var _t2257 = J.mc(v_P_2288, "kindPow", [J.gp(v_d_2287, "gpk")])
	v_pw_2289 = (_t2257 if J.t(_t2257) else 0.0)
	v_m_2290 = J.mc(v_P_2288, "kindMul", [J.gp(v_d_2287, "gpk")])
	var _t2258 = (not J.t(J.F_isFinite([v_m_2290])))
	if (_t2258 if _t2258 else J.cmp(v_m_2290, 0.0, "<=")):
		v_m_2290 = 1.0
	return {"mul": v_m_2290, "pow": v_pw_2289, "tr": J.cmp(v_pw_2289, 0.0, "<="), "na": false}

func _f349(this_, a: Array, env):
	var v_g_2294 = null; var v_r_2295 = null; var v_m_2296 = null
	v_g_2294 = J.arg(a, 0)
	var _t2259 = env["gpRead"]
	v_r_2295 = J.cl(_t2259, null, [J.gp(v_g_2294, "d")])
	v_m_2296 = J.gp(v_r_2295, "mul")
	J.sp(v_g_2294, "mul", v_m_2296)
	var _t2260 = J.gp(v_r_2295, "pow")
	J.sp(v_g_2294, "pow", _t2260)
	var _t2261 = J.gp(v_r_2295, "tr")
	J.sp(v_g_2294, "trainee", _t2261)
	var _t2262 = J.gp(v_r_2295, "na")
	J.sp(v_g_2294, "gpNA", _t2262)
	var _t2263 = J.min_([1.12, (1.0 + (0.08 * J.sub(v_m_2296, 1.0)))])
	J.sp(v_g_2294, "spm", _t2263)
	var _t2264 = (1.0 + (0.2 * J.sub(v_m_2296, 1.0)))
	J.sp(v_g_2294, "em", _t2264)
	var _t2265 = J.min_([1.3, (1.0 + (0.1 * J.sub(v_m_2296, 1.0)))])
	J.sp(v_g_2294, "tm", _t2265)
	var _t2266 = J.max_([0.85, J.min_([1.35, (1.0 + (0.15 * J.sub(v_m_2296, 1.0)))])])
	J.sp(v_g_2294, "im", _t2266)
	var _t2267 = J.max_([0.7, J.min_([1.1, (1.0 - (0.15 * J.sub(v_m_2296, 1.0)))])])
	J.sp(v_g_2294, "icd", _t2267)
	var _t2268 = J.max_([0.9, J.min_([1.3, (1.0 + (0.15 * J.sub(v_m_2296, 1.0)))])])
	J.sp(v_g_2294, "um", _t2268)
	var _t2269 = J.gp(v_g_2294, "energy")
	var _t2270 = (_t2269 if J.t(_t2269) else 0.0)
	J.sp(v_g_2294, "_eL", _t2270)

func _f350(this_, a: Array, env):
	return J.cl(env["TS"], null, [])

func _f351(this_, a: Array, env):
	var v_sv_2301 = null
	v_sv_2301 = J.arg(a, 0)

func _f352(this_, a: Array, env):
	var v_lv_2304 = null; var v_sv_2305 = null
	v_lv_2304 = J.arg(a, 0)
	if (not J.t(J.gp(J.G.get("window"), "GP"))):
		return 0.0
	var _t2271 = J.cl(env["gpSv"], null, [])
	v_sv_2305 = (_t2271 if J.t(_t2271) else {})
	var _t2273 = env["GP_TIER_MAX"]
	var _t2272 = J.gp(v_sv_2305, J.add("win_", v_lv_2304))
	var _t2275 = env["GP_TIER_MAX"]
	var _t2274 = J.gp(v_sv_2305, J.add("win_", v_lv_2304))
	return J.min_([_t2275, J.num((_t2274 if J.t(_t2274) else 0.0))])

func _f353(this_, a: Array, env):
	var v_lv_2308 = null
	v_lv_2308 = J.arg(a, 0)
	var _t2276 = J.gp(env["GP_BASE"], v_lv_2308)
	var _t2278 = (_t2276 if J.t(_t2276) else 1100.0)
	var _t2277 = env["gpTier"]
	return (J.round(J.num(J.div(J.mul(_t2278, (1.0 + J.mul(0.18, J.cl(_t2277, null, [v_lv_2308])))), 10.0))) * 10.0)

func _f354(this_, a: Array, env):
	var v_lv_2311 = null
	v_lv_2311 = J.arg(a, 0)
	var _t2279 = env["gpTier"]
	return pow(J.num((1.0 + J.mul(0.18, J.cl(_t2279, null, [v_lv_2311])))), J.num(0.6))

func _f355(this_, a: Array, env):
	var v_d_2314 = null; var v_r_2315 = null
	v_d_2314 = J.arg(a, 0)
	var _t2280 = env["gpRead"]
	v_r_2315 = J.cl(_t2280, null, [v_d_2314])
	return (0.0 if J.t(J.gp(v_r_2315, "na")) else (env["GP_TRAINEE_POW"] if J.t(J.gp(v_r_2315, "tr")) else J.gp(v_r_2315, "pow")))

func _f357(this_, a: Array, env):
	var v_s_2320 = null; var v_d_2321 = null
	v_s_2320 = J.arg(a, 0)
	v_d_2321 = J.arg(a, 1)
	var _t2281 = env["gpPowOf"]
	return J.add(v_s_2320, J.cl(_t2281, null, [v_d_2321]))

func _f356(this_, a: Array, env):
	return J.mc(env["GH"], "reduce", [Callable(self, "_f357").bind(env), 0.0])

func _f358(this_, a: Array, env):
	var v_g_2324 = null
	v_g_2324 = J.arg(a, 0)
	var _t2282 = (J.gp(v_g_2324, "mul") if J.t(v_g_2324) else v_g_2324)
	var _t2284 = (_t2282 if J.t(_t2282) else 1.0)
	var _t2283 = (J.gp(env["G"], "gpD") if J.t(env["G"]) else env["G"])
	return J.div(_t2284, (_t2283 if J.t(_t2283) else 1.0))

func _f359(this_, a: Array, env):
	var v_g_2327 = null; var v_e_2328 = null; var v_L_2329 = null
	v_g_2327 = J.arg(a, 0)
	var _t2285 = J.gp(v_g_2327, "energy")
	v_e_2328 = (_t2285 if J.t(_t2285) else 0.0)
	v_L_2329 = J.gp(v_g_2327, "_eL")
	var _t2286 = (not J.leq(v_L_2329, null))
	var _t2287 = (J.cmp(v_e_2328, v_L_2329, ">") if _t2286 else _t2286)
	var _t2288 = (J.gp(v_g_2327, "em") if _t2287 else _t2287)
	if J.t(((not J.seq(J.gp(v_g_2327, "em"), 1.0)) if J.t(_t2288) else _t2288)):
		var _t2289 = J.min_([100.0, J.add(v_L_2329, J.mul(J.sub(v_e_2328, v_L_2329), J.gp(v_g_2327, "em")))])
		J.sp(v_g_2327, "energy", _t2289)
	var _t2290 = J.gp(v_g_2327, "energy")
	J.sp(v_g_2327, "_eL", _t2290)

func _f361(this_, a: Array, env):
	var v_g_2334 = null
	v_g_2334 = J.arg(a, 0)
	return J.gp(v_g_2334, "trainee")

func _f360(this_, a: Array, env):
	var _t2291 = J.gp(env["G"], "gh")
	J.mc(_t2291, "forEach", [env["gpApply"]])
	var _t2292 = env["G"]
	var _t2293 = (not (not J.t(J.gp(J.G.get("window"), "GP"))))
	J.sp(_t2292, "gpHas", _t2293)
	var _t2294 = env["G"]
	var _t2295 = env["gpTier"]
	var _t2296 = J.cl(_t2295, null, [env["curLv"]])
	J.sp(_t2294, "gpTier", _t2296)
	var _t2297 = env["G"]
	var _t2298 = env["gpDiff"]
	var _t2299 = J.cl(_t2298, null, [env["curLv"]])
	J.sp(_t2297, "gpD", _t2299)
	var _t2300 = env["G"]
	var _t2301 = env["gpNeed"]
	var _t2302 = J.cl(_t2301, null, [env["curLv"]])
	J.sp(_t2300, "gpNeed", _t2302)
	var _t2303 = env["G"]
	var _t2304 = J.cl(env["gpTeam"], null, [])
	J.sp(_t2303, "gpTeam", _t2304)
	var _t2305 = env["G"]
	var _t2308 = null
	if J.t(J.gp(env["G"], "gpHas")):
		var _t2307 = (J.add((J.add((J.add((J.add("今晚", J.gp(env["LV"], "name")) + "第 "), J.add(J.gp(env["G"], "gpTier"), 1.0)) + " 級：建議鬼力 "), J.gp(env["G"], "gpNeed")) + "，我哋三隻合共 "), J.gp(env["G"], "gpTeam")) + ("——唔夠喎，小心啲！打唔過就返村升級。" if J.cmp(J.gp(env["G"], "gpTeam"), J.gp(env["G"], "gpNeed"), "<") else "，夠晒膽！"))
		var _t2306 = J.gp(env["G"], "gh")
		_t2308 = (_t2307 + ("（有見習鬼）" if J.t(J.mc(_t2306, "some", [Callable(self, "_f361").bind(env)])) else ""))
	else:
		_t2308 = null
	J.sp(_t2305, "gpMsg", _t2308)

func _f362(this_, a: Array, env):
	var _t2309 = J.gp(env["G"], "gpMsg")
	if J.t((J.cmp(J.gp(env["G"], "t"), 5.6, ">=") if J.t(_t2309) else _t2309)):
		var _t2310 = env["toast"]
		J.cl(_t2310, null, [J.gp(env["G"], "gpMsg")])
		var _t2311 = env["G"]
		J.sp(_t2311, "gpMsg", null)

func _f363(this_, a: Array, env):
	var v_why_2339 = null; var v_o_2340 = null; var v_sv_2341 = null
	v_why_2339 = J.arg(a, 0)
	v_o_2340 = J.gp(env["G"], "over")
	var _t2312 = (not (not J.t(J.gp(env["G"], "gpHas"))))
	J.sp(v_o_2340, "gpHas", _t2312)
	var _t2313 = J.gp(env["G"], "gpNeed")
	J.sp(v_o_2340, "gpNeed", _t2313)
	var _t2314 = J.gp(env["G"], "gpTeam")
	J.sp(v_o_2340, "gpTeam", _t2314)
	var _t2315 = J.gp(env["G"], "gpTier")
	J.sp(v_o_2340, "gpTier", _t2315)
	var _t2316 = (not J.seq(v_why_2339, "fail"))
	if J.t((J.gp(env["G"], "gpHas") if _t2316 else _t2316)):
		var _t2317 = J.cl(env["gpSv"], null, [])
		v_sv_2341 = (_t2317 if J.t(_t2317) else {})
		var _t2318 = J.add("win_", env["curLv"])
		var _t2319 = J.gp(v_sv_2341, J.add("win_", env["curLv"]))
		var _t2320 = (J.num((_t2319 if J.t(_t2319) else 0.0)) + 1.0)
		J.sp(v_sv_2341, _t2318, _t2320)
		var _t2321 = env["gpSvPut"]
		J.cl(_t2321, null, [v_sv_2341])
		var _t2322 = env["gpTier"]
		var _t2323 = J.cmp(J.cl(_t2322, null, [env["curLv"]]), J.gp(env["G"], "gpTier"), ">")
		J.sp(v_o_2340, "gpUp", _t2323)

func _f364(this_, a: Array, env):
	var v_o_2344 = null; var v_need_2345 = null; var v_ok_2346 = null; var v_e_2347 = null; var v_e_2348 = null; var v_e_2349 = null
	v_o_2344 = (J.gp(env["G"], "over") if J.t(env["G"]) else env["G"])
	v_need_2345 = (J.gp(v_o_2344, "gpNeed") if J.t((J.cmp(J.gp(v_o_2344, "gpTeam"), J.gp(v_o_2344, "gpNeed"), "<") if J.t(v_o_2344) else v_o_2344)) else 0.0)
	J.cl(env["close"], null, [])
	if (not J.seq(J.typeof_(J.G.get("World")), "undefined")):
		J.mc(J.G.get("World"), "close", [])
	v_ok_2346 = false
	var _t2324 = (not J.seq(J.typeof_(J.G.get("UI")), "undefined"))
	if J.t((J.gp(J.G.get("UI"), "openRoster") if _t2324 else _t2324)):
		J.mc(J.G.get("UI"), "openRoster", [])
		v_ok_2346 = true
	J.mc(J.G.get("Fx"), "toast", [J.add(("" if J.t(v_ok_2346) else "返到村喇！"), (J.mc(J.G.get("GP"), "hint", [v_need_2345]) if J.t(J.gp(J.G.get("window"), "GP")) else "返村幫隻鬼升級再嚟過！"))])

func _f365(this_, a: Array, env):
	var v_x_2352 = null; var v_y_2353 = null; var v_w_2354 = null; var v_t_2355 = null; var v_bg_2356 = null; var v_fg_2357 = null
	v_x_2352 = J.arg(a, 0)
	v_y_2353 = J.arg(a, 1)
	v_w_2354 = J.arg(a, 2)
	v_t_2355 = J.arg(a, 3)
	v_bg_2356 = J.arg(a, 4)
	v_fg_2357 = J.arg(a, 5)
	J.mc(env["ctx"], "save", [])
	var _t2325 = env["ctx"]
	J.sp(_t2325, "fillStyle", v_bg_2356)
	var _t2326 = env["ctx"]
	J.sp(_t2326, "strokeStyle", "rgba(0,0,0,0.55)")
	var _t2327 = env["ctx"]
	J.sp(_t2327, "lineWidth", 1.5)
	J.mc(env["ctx"], "beginPath", [])
	if J.t(J.gp(env["ctx"], "roundRect")):
		J.mc(env["ctx"], "roundRect", [v_x_2352, v_y_2353, v_w_2354, 16.0, 8.0])
	else:
		J.mc(env["ctx"], "rect", [v_x_2352, v_y_2353, v_w_2354, 16.0])
	J.mc(env["ctx"], "fill", [])
	J.mc(env["ctx"], "stroke", [])
	J.mc(env["ctx"], "restore", [])
	var _t2328 = env["crText"]
	J.cl(_t2328, null, [env["ctx"], v_t_2355, J.add(v_x_2352, J.div(v_w_2354, 2.0)), J.add(v_y_2353, 12.5), 11.0, v_fg_2357, "center", J.sub(v_w_2354, 4.0)])

func _f366(this_, a: Array, env):
	var v_o_2360 = null; var v_x_2361 = null; var v_y_2362 = null
	v_o_2360 = J.arg(a, 0)
	v_x_2361 = J.arg(a, 1)
	v_y_2362 = J.arg(a, 2)
	if (not J.t(J.gp(env["G"], "gpHas"))):
		return null
	if J.t(J.gp(v_o_2360, "trainee")):
		var _t2329 = env["gpPill"]
		J.cl(_t2329, null, [J.add(v_x_2361, 8.0), J.sub(v_y_2362, 12.0), 48.0, "見習", "#7a2522", "#ffd9c8"])
	else:
		var _t2330 = env["gpPill"]
		J.cl(_t2330, null, [J.add(v_x_2361, 2.0), J.sub(v_y_2362, 12.0), 60.0, J.add("鬼力 ", J.gp(v_o_2360, "pow")), "#26331f", "#d8f0b8"])

func _f368(this_, a: Array, env):
	var v_d_2368 = null; var v_i_2369 = null; var v_r_2370 = null; var v_cx_2371 = null
	v_d_2368 = J.arg(a, 0)
	v_i_2369 = J.arg(a, 1)
	var _t2331 = env["__p"]["gpRead"]
	v_r_2370 = J.cl(_t2331, null, [v_d_2368])
	v_cx_2371 = (J.div(env["__p"]["VW"], 2.0) + (J.sub(v_i_2369, 1.0) * 100.0))
	var _t2332 = env["__p"]["crText"]
	J.cl(_t2332, null, [env["__p"]["ctx"], ("見習（未招募）" if J.t(J.gp(v_r_2370, "tr")) else J.add("鬼力 ", J.gp(v_r_2370, "pow"))), v_cx_2371, (J.mul(env["__p"]["VH"], 0.52) + 18.0), 13.0, ("#ff8a72" if J.t(J.gp(v_r_2370, "tr")) else "#c8e6a8"), "center", 96.0])

func _f369(this_, a: Array, env):
	var v_lv_2374 = null; var v_i_2375 = null; var v_need_2376 = null; var v_cx_2377 = null; var v_ok_2378 = null
	v_lv_2374 = J.arg(a, 0)
	v_i_2375 = J.arg(a, 1)
	var _t2335 = env["__p"]["gpNeed"]
	v_need_2376 = J.cl(_t2335, null, [v_lv_2374])
	v_cx_2377 = (((34.0 + J.div(J.sub(env["__p"]["VW"], 56.0), 2.0)) + J.div(J.sub(env["__p"]["VW"], 56.0), 4.0)) if J.t(v_i_2375) else (22.0 + J.div(J.sub(env["__p"]["VW"], 56.0), 4.0)))
	v_ok_2378 = J.cmp(env["team"], v_need_2376, ">=")
	var _t2336 = env["__p"]["crText"]
	J.cl(_t2336, null, [env["__p"]["ctx"], (J.add("建議鬼力 ", v_need_2376) + ("" if J.t(v_ok_2378) else "（唔夠）")), v_cx_2377, (J.mul(env["__p"]["VH"], 0.8) + 76.0), 13.0, ("#b2d394" if J.t(v_ok_2378) else "#ff6a5a"), "center", J.div(J.sub(env["__p"]["VW"], 56.0), 2.0)])

func _f367(this_, a: Array, env):
	var _s865 = {"__p": env, "team": null}
	if (not J.t(J.gp(J.G.get("window"), "GP"))):
		return null
	_s865["team"] = J.cl(_s865["__p"]["gpTeam"], null, [])
	J.mc(_s865["__p"]["GH"], "forEach", [Callable(self, "_f368").bind(_s865)])
	var _t2333 = _s865["__p"]["crText"]
	J.cl(_t2333, null, [_s865["__p"]["ctx"], J.add("三隻合共鬼力 ", _s865["team"]), J.div(_s865["__p"]["VW"], 2.0), (J.mul(_s865["__p"]["VH"], 0.52) + 40.0), 15.0, "#efe5cf", "center", J.sub(_s865["__p"]["VW"], 30.0)])
	var _t2334 = ["flat", "shop"]
	J.mc(_t2334, "forEach", [Callable(self, "_f369").bind(_s865)])

func _f370(this_, a: Array, env):
	var v_o_2381 = null; var v_y_2382 = null; var v_ok_2383 = null; var v_tx_2384 = null
	v_o_2381 = J.arg(a, 0)
	v_y_2382 = J.arg(a, 1)
	if (not J.t(J.gp(v_o_2381, "gpHas"))):
		return null
	v_ok_2383 = J.cmp(J.gp(v_o_2381, "gpTeam"), J.gp(v_o_2381, "gpNeed"), ">=")
	var _t2337 = env["ctx"]
	J.sp(_t2337, "textAlign", "center")
	var _t2338 = env["ctx"]
	var _t2339 = ("#d8f0b8" if J.t(v_ok_2383) else "#ff7a64")
	J.sp(_t2338, "fillStyle", _t2339)
	var _t2340 = env["ctx"]
	var _t2341 = J.add("bold 16px ", env["FONT"])
	J.sp(_t2340, "font", _t2341)
	var _t2342 = env["crFill"]
	J.cl(_t2342, null, [J.add((J.add("你嘅鬼力 ", J.gp(v_o_2381, "gpTeam")) + "／建議 "), J.gp(v_o_2381, "gpNeed")), J.div(env["VW"], 2.0), J.add(v_y_2382, 204.0), J.sub(env["VW"], 50.0)])
	var _t2343 = env["ctx"]
	J.sp(_t2343, "fillStyle", "#efdcb4")
	var _t2344 = env["ctx"]
	var _t2345 = J.add("bold 13px ", env["FONT"])
	J.sp(_t2344, "font", _t2345)
	var _t2346 = env["ctx"]
	J.sp(_t2346, "textAlign", "left")
	var _t2347 = J.gp(J.G.get("window"), "GP")
	v_tx_2384 = (J.mc(J.G.get("GP"), "hint", [(0.0 if J.t(v_ok_2383) else J.gp(v_o_2381, "gpNeed"))]) if J.t((J.gp(J.G.get("GP"), "hint") if J.t(_t2347) else _t2347)) else "")
	var _t2348 = env["wrap"]
	J.cl(_t2348, null, [v_tx_2384, 36.0, J.add(v_y_2382, 230.0), J.sub(env["VW"], 72.0), 18.0])
	var _t2349 = env["ctx"]
	J.sp(_t2349, "textAlign", "center")
	var _t2350 = env["btn"]
	J.cl(_t2350, null, ["toVillage", (J.div(env["VW"], 2.0) - 125.0), J.add(v_y_2382, 268.0), 250.0, 44.0, "返村升級", "#8a5a14"])

func _f372(this_, a: Array, env):
	var v_d_2391 = null; var v_i_2392 = null
	v_d_2391 = J.arg(a, 0)
	v_i_2392 = J.arg(a, 1)
	return {"d": v_d_2391, "i": v_i_2392, "node": "f0_e", "to": null, "p": 0.0, "x": 0.0, "y": 0.0, "dir": 1.0, "loot": 0.0, "taskP": 0.0, "inv": 0.0, "invCd": 0.0, "stun": 0.0, "scareCd": 0.0, "home": false, "energy": 0.0, "actT": 0.0, "hitT": 0.0, "bounceT": 0.0, "mv": 0.0, "ph": (randf() * 6.0), "still": 1.0, "caught": 0.0, "out": false, "mirrored": 0.0}

func _f373(this_, a: Array, env):
	var v_g_2395 = null; var v_n_2396 = null
	v_g_2395 = J.arg(a, 0)
	v_n_2396 = J.gp(J.gp(env["G"], "nodes"), J.gp(v_g_2395, "node"))
	var _t2358 = J.gp(v_n_2396, "x")
	J.sp(v_g_2395, "x", _t2358)
	var _t2359 = J.gp(v_n_2396, "y")
	J.sp(v_g_2395, "y", _t2359)

func _f371(this_, a: Array, env):
	var v_s_2387 = null; var v_lv_2388 = null
	v_s_2387 = J.arg(a, 0)
	v_lv_2388 = J.arg(a, 1)
	if J.t(v_lv_2388):
		env["curLv"] = v_lv_2388
	var _t2351 = (v_s_2387 if J.t(v_s_2387) else (J.mod(J.S_Date_("now", []), 100000.0) + 7.0))
	env["seed"] = _t2351
	var _t2352 = {}
	env["used"] = _t2352
	var _t2353 = env["useLevel"]
	J.cl(_t2353, null, [env["curLv"]])
	var _t2354 = {"t": 0.0, "phase": 0.0, "nodes": {}, "edges": [], "units": [], "res": [], "guards": [], "floats": [], "fear": 0.0, "fearNext": 30.0, "fearTotal": 0.0, "mods": {"spd": 1.0, "pow": 1.0, "inv": 3.0, "task": 1.0, "arm": 1.0, "fear": 1.0}, "story": [], "active": 0.0, "over": null, "choice": null, "toast": null, "toastT": 0.0, "alarm": [], "alert": 0.0, "alertLv": 0.0, "bag": [], "dolls": 0.0, "keys": {}, "wave": 0.0, "waveT": 20.0, "gate": null, "gateCharge": 0.0, "captured": 0.0}
	env["G"] = _t2354
	J.cl(env["buildMap2"], null, [])
	J.cl(env["placeUnits2"], null, [])
	var _t2355 = env["G"]
	var _t2356 = J.mc(env["GH"], "map", [Callable(self, "_f372").bind(env)])
	J.sp(_t2355, "gh", _t2356)
	var _t2357 = J.gp(env["G"], "gh")
	J.mc(_t2357, "forEach", [Callable(self, "_f373").bind(env)])
	J.cl(env["gpStart"], null, [])
	var _t2360 = env["cam"]
	J.sp(_t2360, "z", 1.0)
	var _t2361 = env["cam"]
	J.sp(_t2361, "free", null)
	var _t2362 = env["cam"]
	var _t2364 = env["VW"]
	var _t2363 = (J.gp(env["LV"], "camW") if J.t(env["LV"]) else env["LV"])
	var _t2365 = J.div(_t2364, (_t2363 if J.t(_t2363) else 600.0))
	J.sp(_t2362, "s", _t2365)
	var _t2366 = env["G"]
	var _t2367 = []
	J.sp(_t2366, "parts", _t2367)
	var _t2368 = env["G"]
	J.sp(_t2368, "ult", null)
	var _t2369 = env["G"]
	var _t2370 = []
	J.sp(_t2369, "wardFx", _t2370)
	var _t2371 = env["G"]
	var _t2372 = {}
	J.sp(_t2371, "dark", _t2372)
	J.cl(env["spawnZoneGuards"], null, [])
	J.cl(env["initSafe"], null, [])
	var _t2373 = env["G"]
	var _t2374 = []
	J.sp(_t2373, "pdrops", _t2374)
	env["scene"] = "play"
	env["paused"] = false
	var _t2375 = env["toast"]
	J.cl(_t2375, null, [(J.add(J.add(J.gp(env["LV"], "name"), "（"), J.sub(env["FL"], 1.0)) + " 層＋地庫＋天台）：鬆手企定先嚇得人、搜得嘢。保安唔係捉鬼師傅——附身電器、敲水管、叫𨋢可以引開佢哋。左上細地圖撳一下睇全棟。")])

func _f374(this_, a: Array, env):
	var v_id_2399 = null; var v_x_2400 = null; var v_y_2401 = null; var v_f_2402 = null; var v_kind_2403 = null
	v_id_2399 = J.arg(a, 0)
	v_x_2400 = J.arg(a, 1)
	v_y_2401 = J.arg(a, 2)
	v_f_2402 = J.arg(a, 3)
	v_kind_2403 = J.arg(a, 4)
	var _t2376 = J.gp(env["G"], "nodes")
	var _t2377 = {"id": v_id_2399, "x": v_x_2400, "y": v_y_2401, "f": v_f_2402, "kind": v_kind_2403, "links": []}
	J.sp(_t2376, v_id_2399, _t2377)

func _f375(this_, a: Array, env):
	var v_a_2406 = null; var v_b_2407 = null; var v_ward_2408 = null; var v_e_2409 = null
	v_a_2406 = J.arg(a, 0)
	v_b_2407 = J.arg(a, 1)
	v_ward_2408 = J.arg(a, 2)
	v_e_2409 = {"a": v_a_2406, "b": v_b_2407, "ward": (v_ward_2408 if J.t(v_ward_2408) else null)}
	var _t2378 = J.gp(env["G"], "edges")
	J.mc(_t2378, "push", [v_e_2409])
	var _t2379 = J.gp(J.gp(J.gp(env["G"], "nodes"), v_a_2406), "links")
	J.mc(_t2379, "push", [{"to": v_b_2407, "e": v_e_2409}])
	var _t2380 = J.gp(J.gp(J.gp(env["G"], "nodes"), v_b_2407), "links")
	J.mc(_t2380, "push", [{"to": v_a_2406, "e": v_e_2409}])
	return v_e_2409

func _f377(this_, a: Array, env):
	var v_L_2418 = null
	v_L_2418 = J.arg(a, 0)
	return J.seq(J.gp(v_L_2418, 0.0), env["f"])

func _f378(this_, a: Array, env):
	var v_L_2421 = null
	v_L_2421 = J.arg(a, 0)
	return {"x": J.gp(v_L_2421, 7.0), "u": J.gp(v_L_2421, 1.0)}

func _f379(this_, a: Array, env):
	var v_a_2424 = null; var v_b_2425 = null
	v_a_2424 = J.arg(a, 0)
	v_b_2425 = J.arg(a, 1)
	return J.sub(J.gp(v_a_2424, "x"), J.gp(v_b_2425, "x"))

func _f380(this_, a: Array, env):
	var v_st_2428 = null; var v_id_2429 = null; var v_e_2430 = null
	v_st_2428 = J.arg(a, 0)
	if J.t(J.gp(v_st_2428, "p")):
		v_id_2429 = "f0_e"
		var _t2386 = env["__p"]["node"]
		J.cl(_t2386, null, [v_id_2429, J.gp(v_st_2428, "x"), env["y"], 0.0, "portal"])
	else:
		var _t2387 = J.add((J.add("f", env["f"]) + "_d"), J.gp(v_st_2428, "u"))
		v_id_2429 = _t2387
		var _t2388 = env["__p"]["node"]
		J.cl(_t2388, null, [v_id_2429, J.gp(v_st_2428, "x"), env["y"], env["f"], "door"])
		var _t2389 = env["__p"]["node"]
		J.cl(_t2389, null, [J.add((J.add("f", env["f"]) + "_i"), J.gp(v_st_2428, "u")), J.sub(J.gp(v_st_2428, "x"), 14.0), J.sub(env["y"], 34.0), env["f"], "in"])
		var _t2390 = env["__p"]["link"]
		v_e_2430 = J.cl(_t2390, null, [v_id_2429, J.add((J.add("f", env["f"]) + "_i"), J.gp(v_st_2428, "u"))])
		J.sp(v_e_2430, "door", true)
	var _t2391 = env["__p"]["link"]
	J.cl(_t2391, null, [env["prev"], v_id_2429])
	env["prev"] = v_id_2429

func _f376(this_, a: Array, env):
	var v_stops_2414 = null
	var _s874 = {"__p": env, "f": null, "y": null, "prev": null}
	_s874["f"] = 0.0
	while true:
		if not J.cmp(_s874["f"], _s874["__p"]["FL"], "<="): break
		var _t2381 = _s874["__p"]["fy"]
		_s874["y"] = J.cl(_t2381, null, [_s874["f"]])
		var _t2382 = _s874["__p"]["node"]
		J.cl(_t2382, null, [(J.add("f", _s874["f"]) + "_s"), _s874["__p"]["SX"], _s874["y"], _s874["f"], "stair"])
		var _t2383 = _s874["__p"]["node"]
		J.cl(_t2383, null, [(J.add("f", _s874["f"]) + "_l"), (_s874["__p"]["GLX"] if J.seq(_s874["f"], 0.0) else _s874["__p"]["LX"]), _s874["y"], _s874["f"], "lift"])
		if J.cmp(_s874["f"], _s874["__p"]["FL"], "<"):
			var _t2384 = J.gp(_s874["__p"]["LV"], "units")
			var _t2385 = J.mc(_t2384, "filter", [Callable(self, "_f377").bind(_s874)])
			v_stops_2414 = J.mc(_t2385, "map", [Callable(self, "_f378").bind(_s874)])
			if J.seq(_s874["f"], 0.0):
				J.mc(v_stops_2414, "push", [{"x": _s874["__p"]["PX0"], "p": 1.0}])
			J.mc(v_stops_2414, "sort", [Callable(self, "_f379").bind(_s874)])
			_s874["prev"] = (J.add("f", _s874["f"]) + "_s")
			J.mc(v_stops_2414, "forEach", [Callable(self, "_f380").bind(_s874)])
			var _t2392 = _s874["__p"]["link"]
			J.cl(_t2392, null, [_s874["prev"], (J.add("f", _s874["f"]) + "_l")])
		else:
			var _t2393 = _s874["__p"]["node"]
			J.cl(_t2393, null, [(J.add("f", _s874["__p"]["FL"]) + "_p"), 300.0, _s874["y"], _s874["f"], "portal"])
			var _t2394 = _s874["__p"]["link"]
			J.cl(_t2394, null, [(J.add("f", _s874["__p"]["FL"]) + "_s"), (J.add("f", _s874["__p"]["FL"]) + "_p")])
			var _t2395 = _s874["__p"]["link"]
			J.cl(_t2395, null, [(J.add("f", _s874["__p"]["FL"]) + "_p"), (J.add("f", _s874["__p"]["FL"]) + "_l")])
		if J.cmp(_s874["f"], 0.0, ">"):
			var _t2396 = _s874["__p"]["link"]
			var _t2397 = J.cl(_t2396, null, [(J.add("f", J.sub(_s874["f"], 1.0)) + "_s"), (J.add("f", _s874["f"]) + "_s")])
			J.sp(_t2397, "vert", true)
			var _t2398 = _s874["__p"]["link"]
			var _t2399 = J.cl(_t2398, null, [(J.add("f", J.sub(_s874["f"], 1.0)) + "_l"), (J.add("f", _s874["f"]) + "_l")])
			J.sp(_t2399, "vert", true)
		_s874["f"] = J.num(_s874["f"]) + 1.0

func _f383(this_, a: Array, env):
	var v_l_2454 = null
	v_l_2454 = J.arg(a, 0)
	return J.seq(J.gp(v_l_2454, "to"), env["id"])

func _f382(this_, a: Array, env):
	var v_L_2441 = null; var v_f_2442 = null; var v_u_2443 = null; var v_w_2444 = null; var v_did_2446 = null; var v_e_2447 = null; var v_un_2448 = null; var v_cx_2449 = null; var v_rxp_2450 = null; var v_r_2451 = null
	var _s887 = {"__p": env, "id": null}
	v_L_2441 = J.arg(a, 0)
	v_f_2442 = J.gp(v_L_2441, 0.0)
	v_u_2443 = J.gp(v_L_2441, 1.0)
	v_w_2444 = J.gp(v_L_2441, 2.0)
	_s887["id"] = J.add((J.add("f", v_f_2442) + "_i"), v_u_2443)
	v_did_2446 = J.add((J.add("f", v_f_2442) + "_d"), v_u_2443)
	var _t2401 = J.gp(J.gp(J.gp(_s887["__p"]["__p"]["G"], "nodes"), v_did_2446), "links")
	v_e_2447 = J.gp(J.mc(_t2401, "find", [Callable(self, "_f383").bind(_s887)]), "e")
	J.sp(v_e_2447, "ward", v_w_2444)
	var _t2403 = _s887["id"]
	var _t2404 = J.gp(v_L_2441, 3.0)
	var _t2405 = J.cmp(J.gp(v_L_2441, 5.0), 0.0, ">=")
	var _t2406 = J.gp(v_L_2441, 5.0)
	var _t2407 = J.gp(v_L_2441, 6.0)
	var _t2408 = J.gp(J.gp(J.gp(_s887["__p"]["__p"]["G"], "nodes"), v_did_2446), "x")
	var _t2402 = _s887["__p"]["__p"]["fy"]
	v_un_2448 = {"f": v_f_2442, "u": v_u_2443, "id": _t2403, "did": v_did_2446, "ward": v_w_2444, "task": _t2404, "story": _t2405, "si": _t2406, "name": _t2407, "x": _t2408, "y": J.cl(_t2402, null, [v_f_2442]), "rx": J.gp(v_L_2441, 8.0), "lit": false, "litT": 0.0, "open": true, "ot": 0.0, "cost": 0.0, "paid": 0.0, "seen": false, "entered": false, "plus": (2.0 if J.cmp(J.gp(v_L_2441, 5.0), 0.0, ">=") else 1.0), "items": [], "door": false, "doorOpen": 0.0, "ambush": null, "dep": null, "keyNeed": null}
	var _t2409 = J.seq(v_w_2444, "fu")
	var _t2410 = (_t2409 if _t2409 else J.seq(v_w_2444, "menshen"))
	if (_t2410 if _t2410 else J.seq(v_w_2444, "datuk")):
		J.sp(v_un_2448, "open", false)
		J.sp(v_un_2448, "ot", "deity")
	else:
		if J.seq(v_w_2444, "zha"):
			J.sp(v_un_2448, "open", false)
			J.sp(v_un_2448, "ot", 2.0)
			var _t2411 = (8.0 if J.cmp(v_f_2442, 1.0, "<=") else 12.0)
			J.sp(v_un_2448, "cost", _t2411)
		else:
			if J.seq(v_w_2444, "nuomi"):
				J.sp(v_un_2448, "open", false)
				J.sp(v_un_2448, "ot", 2.0)
				var _t2412 = (6.0 if J.cmp(v_f_2442, 1.0, "<=") else 9.0)
				J.sp(v_un_2448, "cost", _t2412)
	if J.t(J.gp(v_L_2441, 3.0)):
		var _t2413 = J.gp(v_un_2448, "items")
		J.mc(_t2413, "push", [J.gp(v_L_2441, 3.0)])
	var _t2414 = J.seq(J.gp(v_L_2441, 3.0), "food")
	if (_t2414 if _t2414 else J.seq(J.gp(v_L_2441, 3.0), "money")):
		var _t2415 = J.gp(v_un_2448, "items")
		J.mc(_t2415, "push", [J.gp(v_L_2441, 3.0)])
	var _t2416 = J.gp(_s887["__p"]["__p"]["G"], "units")
	J.mc(_t2416, "push", [v_un_2448])
	J.sp(v_e_2447, "unit", v_un_2448)
	if J.t(J.gp(v_L_2441, 4.0)):
		v_cx_2449 = J.div(J.add(J.gp(J.gp(v_un_2448, "rx"), 0.0), J.gp(J.gp(v_un_2448, "rx"), 1.0)), 2.0)
		v_rxp_2450 = (J.sub(v_cx_2449, 34.0) if (absf(J.num(J.sub(v_cx_2449, J.gp(v_un_2448, "x")))) < 30.0) else v_cx_2449)
		var _t2418 = J.gp(v_L_2441, 4.0)
		var _t2417 = _s887["__p"]["__p"]["fy"]
		v_r_2451 = {"unit": v_un_2448, "sprite": _t2418, "x": v_rxp_2450, "y": J.sub(J.cl(_t2417, null, [v_f_2442]), 16.0), "fear": 0.0, "brave": 0.0, "state": "home", "vx": 0.0, "doorT": (8.0 + J.mul(J.cl(_s887["__p"]["__p"]["rnd"], null, []), 10.0))}
		var _t2419 = J.gp(_s887["__p"]["__p"]["G"], "res")
		J.mc(_t2419, "push", [v_r_2451])
		J.sp(v_un_2448, "res", v_r_2451)

func _f384(this_, a: Array, env):
	var v_u_2457 = null
	v_u_2457 = J.arg(a, 0)
	var _t2421 = J.gp(v_u_2457, "story")
	return (J.seq(J.gp(v_u_2457, "ot"), 0.0) if J.t(_t2421) else _t2421)

func _f385(this_, a: Array, env):
	var v_a_2460 = null; var v_b_2461 = null
	v_a_2460 = J.arg(a, 0)
	v_b_2461 = J.arg(a, 1)
	return J.sub(J.gp(v_b_2461, "f"), J.gp(v_a_2460, "f"))

func _f387(this_, a: Array, env):
	var v_v_2468 = null
	v_v_2468 = J.arg(a, 0)
	var _t2430 = J.seq(J.gp(v_v_2468, "f"), J.gp(env["u"], "f"))
	var _t2431 = ((not J.seq(v_v_2468, env["u"])) if _t2430 else _t2430)
	var _t2432 = (J.gp(v_v_2468, "res") if _t2431 else _t2431)
	return ((not J.seq(J.gp(v_v_2468, "ot"), "deity")) if J.t(_t2432) else _t2432)

func _f386(this_, a: Array, env):
	var v_nb_2465 = null
	var _s896 = {"__p": env, "u": null}
	_s896["u"] = J.arg(a, 0)
	var _t2427 = (not J.seq(J.gp(_s896["u"], "ot"), 0.0))
	var _t2428 = (_t2427 if _t2427 else J.seq(J.gp(_s896["u"], "f"), 0.0))
	if (_t2428 if _t2428 else J.seq(_s896["u"], _s896["__p"]["top"])):
		return null
	var _t2429 = J.gp(_s896["__p"]["__p"]["G"], "units")
	v_nb_2465 = J.gp(J.mc(_t2429, "filter", [Callable(self, "_f387").bind(_s896)]), 0.0)
	if J.t((J.gp(_s896["u"], "story") if J.t(v_nb_2465) else v_nb_2465)):
		var _t2433 = _s896["u"]
		J.sp(_t2433, "open", false)
		var _t2434 = _s896["u"]
		J.sp(_t2434, "ot", 1.0)
		var _t2435 = _s896["u"]
		J.sp(_t2435, "dep", v_nb_2465)

func _f388(this_, a: Array, env):
	var v_u_2471 = null
	v_u_2471 = J.arg(a, 0)
	var _t2437 = (not J.seq(J.gp(v_u_2471, "ot"), "deity"))
	return ((not J.seq(v_u_2471, env["keyUnit"])) if _t2437 else _t2437)

func _f389(this_, a: Array, env):
	var v_u_2474 = null
	v_u_2474 = J.arg(a, 0)
	var _t2441 = J.gp(v_u_2474, "items")
	J.mc(_t2441, "push", ["key"])

func _f390(this_, a: Array, env):
	var v_u_2477 = null
	v_u_2477 = J.arg(a, 0)
	if J.cmp(env["dolls"], 7.0, "<"):
		var _t2444 = J.gp(v_u_2477, "items")
		J.mc(_t2444, "push", ["doll"])
		env["dolls"] = J.num(env["dolls"]) + 1.0

func _f391(this_, a: Array, env):
	var v_u_2480 = null
	v_u_2480 = J.arg(a, 0)
	var _t2446 = J.gp(v_u_2480, "res")
	var _t2447 = (J.seq(J.gp(v_u_2480, "ot"), 0.0) if J.t(_t2446) else _t2446)
	return (J.cmp(J.gp(v_u_2480, "f"), 0.0, ">") if J.t(_t2447) else _t2447)

func _f392(this_, a: Array, env):
	var v_u_2483 = null
	v_u_2483 = J.arg(a, 0)
	var _t2450 = (not J.t(J.gp(v_u_2483, "res")))
	return ((not J.seq(J.gp(v_u_2483, "ot"), "deity")) if _t2450 else _t2450)

func _f393(this_, a: Array, env):
	var v_u_2486 = null
	v_u_2486 = J.arg(a, 0)
	return J.seq(J.gp(v_u_2486, "ot"), 2.0)

func _f394(this_, a: Array, env):
	var v_u_2489 = null
	v_u_2489 = J.arg(a, 0)
	var _t2454 = J.seq(J.gp(v_u_2489, "ot"), 0.0)
	var _t2455 = (_t2454 if _t2454 else J.seq(J.gp(v_u_2489, "ot"), "deity"))
	var _t2456 = ((not J.t(J.gp(v_u_2489, "ambush"))) if _t2455 else _t2455)
	J.sp(v_u_2489, "seen", _t2456)

func _f381(this_, a: Array, env):
	var v_cand_2435 = null; var v_dc_2437 = null; var v_amb_2438 = null
	var _s886 = {"__p": env, "keyUnit": null, "top": null, "dolls": null}
	_s886["keyUnit"] = null
	var _t2400 = J.gp(_s886["__p"]["LV"], "units")
	J.mc(_t2400, "forEach", [Callable(self, "_f382").bind(_s886)])
	var _t2420 = J.gp(_s886["__p"]["G"], "units")
	var _t2422 = J.mc(_t2420, "filter", [Callable(self, "_f384").bind(_s886)])
	_s886["top"] = J.gp(J.mc(_t2422, "sort", [Callable(self, "_f385").bind(_s886)]), 0.0)
	if J.t(_s886["top"]):
		var _t2423 = _s886["top"]
		J.sp(_t2423, "open", false)
		var _t2424 = _s886["top"]
		J.sp(_t2424, "ot", 11.0)
		var _t2425 = _s886["top"]
		J.sp(_t2425, "keyNeed", "key")
		_s886["keyUnit"] = _s886["top"]
	var _t2426 = J.gp(_s886["__p"]["G"], "units")
	J.mc(_t2426, "forEach", [Callable(self, "_f386").bind(_s886)])
	var _t2436 = J.gp(_s886["__p"]["G"], "units")
	v_cand_2435 = J.mc(_t2436, "filter", [Callable(self, "_f388").bind(_s886)])
	var _t2438 = _s886["__p"]["shuffle"]
	var _t2439 = J.cl(_t2438, null, [v_cand_2435])
	var _t2440 = J.mc(_t2439, "slice", [0.0, 1.0])
	J.mc(_t2440, "forEach", [Callable(self, "_f389").bind(_s886)])
	_s886["dolls"] = 0.0
	var _t2442 = _s886["__p"]["shuffle"]
	var _t2443 = J.cl(_t2442, null, [v_cand_2435])
	J.mc(_t2443, "forEach", [Callable(self, "_f390").bind(_s886)])
	var _t2445 = J.gp(_s886["__p"]["G"], "units")
	v_dc_2437 = J.mc(_t2445, "filter", [Callable(self, "_f391").bind(_s886)])
	if (J.len(v_dc_2437) >= 2.0):
		var _t2448 = J.gp(v_dc_2437, (J.len(v_dc_2437) - 1.0))
		J.sp(_t2448, "door", true)
	var _t2449 = J.gp(_s886["__p"]["G"], "units")
	var _t2452 = J.gp(J.mc(_t2449, "filter", [Callable(self, "_f392").bind(_s886)]), 0.0)
	if not J.t(_t2452):
		var _t2451 = J.gp(_s886["__p"]["G"], "units")
		_t2452 = J.gp(J.mc(_t2451, "filter", [Callable(self, "_f393").bind(_s886)]), 0.0)
	v_amb_2438 = _t2452
	if J.t(v_amb_2438):
		J.sp(v_amb_2438, "ambush", "dog")
	var _t2453 = J.gp(_s886["__p"]["G"], "units")
	J.mc(_t2453, "forEach", [Callable(self, "_f394").bind(_s886)])

func _f395(this_, a: Array, env):
	var v_did_2492 = null; var v_i_2493 = null
	v_did_2492 = J.arg(a, 0)
	v_i_2493 = 0.0
	while true:
		if not J.cmp(v_i_2493, J.len(J.gp(env["G"], "units")), "<"): break
		if J.seq(J.gp(J.gp(J.gp(env["G"], "units"), v_i_2493), "did"), v_did_2492):
			return J.gp(J.gp(env["G"], "units"), v_i_2493)
		v_i_2493 = J.num(v_i_2493) + 1.0
	return null

func _f396(this_, a: Array, env):
	var v_id_2496 = null; var v_i_2497 = null
	v_id_2496 = J.arg(a, 0)
	v_i_2497 = 0.0
	while true:
		if not J.cmp(v_i_2497, J.len(J.gp(env["G"], "units")), "<"): break
		if J.seq(J.gp(J.gp(J.gp(env["G"], "units"), v_i_2497), "id"), v_id_2496):
			return J.gp(J.gp(env["G"], "units"), v_i_2497)
		v_i_2497 = J.num(v_i_2497) + 1.0
	return null

func _f397(this_, a: Array, env):
	var v_kind_2500 = null; var v_nodeId_2501 = null; var v_extra_2502 = null; var v_n_2503 = null; var v_h_2504 = null; var v_k_2505 = null
	v_kind_2500 = J.arg(a, 0)
	v_nodeId_2501 = J.arg(a, 1)
	v_extra_2502 = J.arg(a, 2)
	v_n_2503 = J.gp(J.gp(env["G"], "nodes"), v_nodeId_2501)
	v_h_2504 = {"kind": v_kind_2500, "node": v_nodeId_2501, "to": null, "p": 0.0, "x": J.gp(v_n_2503, "x"), "y": J.gp(v_n_2503, "y"), "dir": 1.0, "wait": 1.0, "talkT": (3.0 + J.mul(J.cl(env["rnd"], null, []), 5.0)), "courage": (5.0 if J.seq(v_kind_2500, "compass") else (2.0 if J.seq(v_kind_2500, "decoy") else 1.0)), "path": null, "repath": 0.0, "chase": null, "alertT": 0.0, "state": "patrol"}
	for _t2457 in J.keys((v_extra_2502 if J.t(v_extra_2502) else {})):
		v_k_2505 = _t2457
		var _t2458 = J.gp(v_extra_2502, v_k_2505)
		J.sp(v_h_2504, v_k_2505, _t2458)
	return v_h_2504

func _f398(this_, a: Array, env):
	var v_nz_2508 = null; var v_span_2509 = null; var v_i_2510 = null; var v_a_2511 = null; var v_b_2512 = null; var v_h_2513 = null
	v_nz_2508 = J.max_([2.0, J.round(J.num(J.div(J.sub(env["FL"], 1.0), 3.0)))])
	v_span_2509 = J.div(J.sub(env["FL"], 1.0), v_nz_2508)
	v_i_2510 = 0.0
	while true:
		if not J.cmp(v_i_2510, v_nz_2508, "<"): break
		v_a_2511 = (1.0 + J.round(J.num(J.mul(v_i_2510, v_span_2509))))
		v_b_2512 = J.min_([J.sub(env["FL"], 1.0), J.round(J.num(J.mul(J.add(v_i_2510, 1.0), v_span_2509)))])
		var _t2459 = env["mkHuman"]
		v_h_2513 = J.cl(_t2459, null, ["guard", ((J.add("f", v_a_2511) + "_") + ("b" if J.t(J.mod(v_i_2510, 2.0)) else "s"))])
		var _t2460 = [v_a_2511, v_b_2512]
		J.sp(v_h_2513, "zone", _t2460)
		var _t2461 = J.gp(env["G"], "guards")
		J.mc(_t2461, "push", [v_h_2513])
		v_i_2510 = J.num(v_i_2510) + 1.0

func _f399(this_, a: Array, env):
	var v_h_2516 = null; var v_f_2517 = null; var v_pad_2518 = null
	v_h_2516 = J.arg(a, 0)
	v_f_2517 = J.arg(a, 1)
	v_pad_2518 = J.arg(a, 2)
	var _t2463 = (not J.t(J.gp(v_h_2516, "zone")))
	if not J.t(_t2463):
		var _t2462 = J.cmp(v_f_2517, J.sub(J.gp(J.gp(v_h_2516, "zone"), 0.0), (v_pad_2518 if J.t(v_pad_2518) else 0.0)), ">=")
		_t2463 = (J.cmp(v_f_2517, J.add(J.gp(J.gp(v_h_2516, "zone"), 1.0), (v_pad_2518 if J.t(v_pad_2518) else 0.0)), "<=") if _t2462 else _t2462)
	return _t2463

func _f400(this_, a: Array, env):
	var v_m_2521 = null
	v_m_2521 = J.arg(a, 0)
	var _t2464 = env["G"]
	J.sp(_t2464, "toast", v_m_2521)
	var _t2465 = env["G"]
	J.sp(_t2465, "toastT", 5.5)

func _f402(this_, a: Array, env):
	var v_f_2535 = null
	v_f_2535 = J.arg(a, 0)
	var _t2472 = J.seq(J.gp(v_f_2535, "t"), env["t"])
	var _t2473 = ((absf(J.num(J.sub(J.gp(v_f_2535, "x"), env["x"]))) < 260.0) if _t2472 else _t2472)
	return ((absf(J.num(J.sub(J.gp(v_f_2535, "y0"), env["y"]))) < 200.0) if _t2473 else _t2473)

func _f403(this_, a: Array, env):
	var v_f_2538 = null
	v_f_2538 = J.arg(a, 0)
	var _t2477 = (absf(J.num(J.sub(J.gp(v_f_2538, "x"), env["x"]))) < 120.0)
	return ((absf(J.num(J.sub(J.gp(v_f_2538, "y"), env["yy"]))) < 17.0) if _t2477 else _t2477)

func _f401(this_, a: Array, env):
	var v_c_2527 = null; var v_now_2528 = null; var v_fc_2529 = null; var v_L0_2530 = null; var v_k_2532 = null
	var _s918 = {"__p": env, "x": null, "y": null, "t": null, "yy": null}
	_s918["x"] = J.arg(a, 0)
	_s918["y"] = J.arg(a, 1)
	_s918["t"] = J.arg(a, 2)
	v_c_2527 = J.arg(a, 3)
	if (not J.t(_s918["__p"]["G"])):
		return null
	v_now_2528 = J.S_performance_("now", [])
	var _t2468 = J.gp(_s918["__p"]["G"], "fcd")
	if not J.t(_t2468):
		var _t2466 = _s918["__p"]["G"]
		var _t2467 = {}
		J.sp(_t2466, "fcd", _t2467)
		_t2468 = _t2467
	v_fc_2529 = _t2468
	v_L0_2530 = J.gp(v_fc_2529, _s918["t"])
	var _t2469 = ((J.sub(v_now_2528, J.gp(v_L0_2530, "t")) < 1500.0) if J.t(v_L0_2530) else v_L0_2530)
	var _t2470 = ((absf(J.num(J.sub(J.gp(v_L0_2530, "x"), _s918["x"]))) < 260.0) if J.t(_t2469) else _t2469)
	if J.t(((absf(J.num(J.sub(J.gp(v_L0_2530, "y"), _s918["y"]))) < 200.0) if J.t(_t2470) else _t2470)):
		return null
	var _t2471 = J.gp(_s918["__p"]["G"], "floats")
	if J.t(J.mc(_t2471, "some", [Callable(self, "_f402").bind(_s918)])):
		return null
	var _t2474 = _s918["t"]
	var _t2475 = {"t": v_now_2528, "x": _s918["x"], "y": _s918["y"]}
	J.sp(v_fc_2529, _t2474, _t2475)
	_s918["yy"] = _s918["y"]
	v_k_2532 = 0.0
	while true:
		var _t2478 = J.cmp(v_k_2532, 4.0, "<")
		if J.t(_t2478):
			var _t2476 = J.gp(_s918["__p"]["G"], "floats")
			_t2478 = J.mc(_t2476, "some", [Callable(self, "_f403").bind(_s918)])
		if not J.t(_t2478): break
		var _t2479 = J.sub(_s918["yy"], 18.0)
		_s918["yy"] = _t2479
		v_k_2532 = J.num(v_k_2532) + 1.0
	var _t2480 = J.gp(_s918["__p"]["G"], "floats")
	J.mc(_t2480, "push", [{"x": _s918["x"], "y": _s918["yy"], "y0": _s918["y"], "t": _s918["t"], "c": (v_c_2527 if J.t(v_c_2527) else "#fff"), "life": 1.6}])
	if (J.len(J.gp(_s918["__p"]["G"], "floats")) > 10.0):
		J.mc(J.gp(_s918["__p"]["G"], "floats"), "shift", [])

func _f404(this_, a: Array, env):
	var v_g_2541 = null; var v_e_2542 = null
	v_g_2541 = J.arg(a, 0)
	v_e_2542 = J.arg(a, 1)
	var _t2481 = J.gp(v_e_2542, "ward")
	return (J.gp(J.gp(J.gp(v_g_2541, "d"), "cross"), J.gp(v_e_2542, "ward")) if J.t(_t2481) else _t2481)

func _f405(this_, a: Array, env):
	var v_g_2545 = null; var v_e_2546 = null; var v_un_2547 = null
	v_g_2545 = J.arg(a, 0)
	v_e_2546 = J.arg(a, 1)
	var _t2482 = J.gp(env["G"], "gate")
	var _t2484 = (J.gp(v_e_2546, "vert") if J.t(_t2482) else _t2482)
	if J.t(_t2484):
		var _t2483 = J.seq(J.gp(J.gp(J.gp(env["G"], "nodes"), J.gp(v_e_2546, "a")), "f"), J.gp(J.gp(env["G"], "gate"), "f"))
		_t2484 = (_t2483 if _t2483 else J.seq(J.gp(J.gp(J.gp(env["G"], "nodes"), J.gp(v_e_2546, "b")), "f"), J.gp(J.gp(env["G"], "gate"), "f")))
	if J.t(_t2484):
		return "stairSeal"
	if (not J.t(J.gp(v_e_2546, "door"))):
		return true
	v_un_2547 = J.gp(v_e_2546, "unit")
	if J.seq(J.gp(v_un_2547, "ot"), "deity"):
		return "deity"
	var _t2486 = (not J.t(J.gp(v_un_2547, "open")))
	if J.t(_t2486):
		var _t2485 = env["shortcut"]
		_t2486 = (not J.t(J.cl(_t2485, null, [v_g_2545, v_e_2546])))
	if _t2486:
		return ("breach" if J.seq(J.gp(v_un_2547, "ot"), 2.0) else ("key" if J.seq(J.gp(v_un_2547, "ot"), 11.0) else "chain"))
	var _t2487 = J.gp(v_un_2547, "door")
	var _t2489 = (J.cmp(J.gp(v_un_2547, "doorOpen"), 0.0, "<=") if J.t(_t2487) else _t2487)
	if J.t(_t2489):
		var _t2488 = env["shortcut"]
		_t2489 = (not J.t(J.cl(_t2488, null, [v_g_2545, v_e_2546])))
	if J.t(_t2489):
		return "door"
	return true

func _f406(this_, a: Array, env):
	var v_h_2550 = null; var v_e_2551 = null
	v_h_2550 = J.arg(a, 0)
	v_e_2551 = J.arg(a, 1)
	if J.t(J.gp(v_e_2551, "pipe")):
		return false
	var _t2490 = J.gp(v_e_2551, "fire")
	if J.t((J.cmp(J.gp(J.gp(v_e_2551, "fire"), "shut"), 0.0, ">") if J.t(_t2490) else _t2490)):
		return false
	var _t2491 = J.seq(J.gp(v_h_2550, "kind"), "dog")
	var _t2492 = (J.gp(v_e_2551, "door") if _t2491 else _t2491)
	var _t2493 = (J.gp(J.gp(v_e_2551, "unit"), "door") if J.t(_t2492) else _t2492)
	if J.t((J.cmp(J.gp(J.gp(v_e_2551, "unit"), "doorOpen"), 0.0, "<=") if J.t(_t2493) else _t2493)):
		return false
	var _t2494 = J.gp(v_e_2551, "door")
	if J.t((J.seq(J.gp(J.gp(v_e_2551, "unit"), "ot"), "deity") if J.t(_t2494) else _t2494)):
		return false
	return true

func _f408(this_, a: Array, env):
	var v_l_2574 = null; var v_m_2575 = null; var v_dx_2576 = null; var v_dy_2577 = null; var v_D_2578 = null; var v_dot_2579 = null
	v_l_2574 = J.arg(a, 0)
	v_m_2575 = J.gp(J.gp(env["__p"]["G"], "nodes"), J.gp(v_l_2574, "to"))
	v_dx_2576 = J.sub(J.gp(v_m_2575, "x"), J.gp(env["n"], "x"))
	v_dy_2577 = J.sub(J.gp(v_m_2575, "y"), J.gp(env["n"], "y"))
	v_D_2578 = J.hypot_([v_dx_2576, v_dy_2577])
	v_dot_2579 = J.div((J.mul(v_dx_2576, env["jx"]) + J.mul(v_dy_2577, env["jy"])), v_D_2578)
	if (absf(J.num(v_dy_2577)) > absf(J.num(v_dx_2576))):
		var _t2506 = J.add(v_dot_2579, 0.12)
		v_dot_2579 = _t2506
	if J.cmp(v_dot_2579, env["bd"], ">"):
		env["bd"] = v_dot_2579
		env["best"] = v_l_2574

func _f407(this_, a: Array, env):
	var v_g_2554 = null; var v_dt_2557 = null; var v_L_2558 = null; var v_mt_2559 = null; var v_sp_2560 = null; var v_ok_2564 = null; var v_a_2565 = null; var v_b_2566 = null; var v_dx_2567 = null; var v_dy_2568 = null; var v_D_2569 = null; var v_dot_2570 = null; var v_t_2571 = null
	var _s925 = {"__p": env, "jx": null, "jy": null, "n": null, "best": null, "bd": null}
	v_g_2554 = J.arg(a, 0)
	_s925["jx"] = J.arg(a, 1)
	_s925["jy"] = J.arg(a, 2)
	v_dt_2557 = J.arg(a, 3)
	var _t2495 = J.cmp(J.gp(v_g_2554, "stun"), 0.0, ">")
	var _t2496 = (_t2495 if _t2495 else J.gp(v_g_2554, "home"))
	if J.t((_t2496 if J.t(_t2496) else J.gp(v_g_2554, "out"))):
		return null
	v_L_2558 = J.hypot_([_s925["jx"], _s925["jy"]])
	if J.cmp(v_L_2558, 0.25, "<"):
		return null
	var _t2497 = J.div(_s925["jx"], v_L_2558)
	_s925["jx"] = _t2497
	var _t2498 = J.div(_s925["jy"], v_L_2558)
	_s925["jy"] = _t2498
	var _t2499 = _s925["__p"]["mirrorOn"]
	v_mt_2559 = J.cl(_t2499, null, [v_g_2554])
	var _t2500 = (J.seq(signf(J.num(J.sub(J.gp(v_mt_2559, "x"), J.gp(v_g_2554, "x")))), signf(J.num(_s925["jx"]))) if J.t(v_mt_2559) else v_mt_2559)
	if J.t(((absf(J.num(_s925["jx"])) > 0.3) if J.t(_t2500) else _t2500)):
		var _t2501 = (not J.t(J.gp(v_g_2554, "blockT")))
		if (_t2501 if _t2501 else J.cmp(J.gp(v_g_2554, "blockT"), 0.0, "<=")):
			var _t2502 = _s925["__p"]["float"]
			J.cl(_t2502, null, [J.gp(v_g_2554, "x"), J.sub(J.gp(v_g_2554, "y"), 80.0), "被鏡照住！轉身先走得", "#ffe9a0"])
			J.sp(v_g_2554, "blockT", 1.0)
		return null
	var _t2504 = J.mul(J.gp(J.gp(v_g_2554, "d"), "sp"), J.gp(J.gp(_s925["__p"]["G"], "mods"), "spd"))
	var _t2503 = J.gp(v_g_2554, "spm")
	v_sp_2560 = J.mul(_t2504, (_t2503 if J.t(_t2503) else 1.0))
	if (not J.t(J.gp(v_g_2554, "to"))):
		_s925["n"] = J.gp(J.gp(_s925["__p"]["G"], "nodes"), J.gp(v_g_2554, "node"))
		_s925["best"] = null
		_s925["bd"] = 0.55
		var _t2505 = J.gp(_s925["n"], "links")
		J.mc(_t2505, "forEach", [Callable(self, "_f408").bind(_s925)])
		if (not J.t(_s925["best"])):
			return null
		var _t2507 = _s925["__p"]["canPass"]
		v_ok_2564 = J.cl(_t2507, null, [v_g_2554, J.gp(_s925["best"], "e")])
		if (not J.seq(v_ok_2564, true)):
			var _t2508 = (not J.t(J.gp(v_g_2554, "blockT")))
			if (_t2508 if _t2508 else J.cmp(J.gp(v_g_2554, "blockT"), 0.0, "<=")):
				var _t2509 = _s925["__p"]["float"]
				J.cl(_t2509, null, [J.gp(_s925["n"], "x"), J.sub(J.gp(_s925["n"], "y"), 80.0), J.gp(_s925["__p"]["BLOCKMSG"], v_ok_2564), "#ffd54a"])
				J.sp(v_g_2554, "blockT", 1.4)
				J.sp(v_g_2554, "bounceT", 0.45)
				if J.seq(v_ok_2564, "deity"):
					var _t2510 = J.gp(_s925["__p"]["G"], "wardFx")
					J.mc(_t2510, "push", [{"x": J.gp(_s925["n"], "x"), "y": J.gp(_s925["n"], "y"), "t": 0.9}])
			return null
		var _t2511 = J.gp(_s925["best"], "to")
		J.sp(v_g_2554, "to", _t2511)
		J.sp(v_g_2554, "p", 0.0)
	v_a_2565 = J.gp(J.gp(_s925["__p"]["G"], "nodes"), J.gp(v_g_2554, "node"))
	v_b_2566 = J.gp(J.gp(_s925["__p"]["G"], "nodes"), J.gp(v_g_2554, "to"))
	v_dx_2567 = J.sub(J.gp(v_b_2566, "x"), J.gp(v_a_2565, "x"))
	v_dy_2568 = J.sub(J.gp(v_b_2566, "y"), J.gp(v_a_2565, "y"))
	v_D_2569 = J.hypot_([v_dx_2567, v_dy_2568])
	v_dot_2570 = J.div((J.mul(v_dx_2567, _s925["jx"]) + J.mul(v_dy_2568, _s925["jy"])), v_D_2569)
	if J.cmp(v_dot_2570, (-0.3), "<"):
		v_t_2571 = J.gp(v_g_2554, "node")
		var _t2512 = J.gp(v_g_2554, "to")
		J.sp(v_g_2554, "node", _t2512)
		J.sp(v_g_2554, "to", v_t_2571)
		var _t2513 = J.sub(1.0, J.gp(v_g_2554, "p"))
		J.sp(v_g_2554, "p", _t2513)
		return null
	var _t2514 = J.add(J.gp(v_g_2554, "p"), J.div(J.mul(v_sp_2560, v_dt_2557), v_D_2569))
	J.sp(v_g_2554, "p", _t2514)
	if J.t(v_dx_2567):
		var _t2515 = (1.0 if J.cmp(v_dx_2567, 0.0, ">") else (-1.0))
		J.sp(v_g_2554, "dir", _t2515)
	J.sp(v_g_2554, "still", 0.0)
	J.sp(v_g_2554, "taskP", 0.0)
	if J.cmp(J.gp(v_g_2554, "p"), 1.0, ">="):
		var _t2516 = J.gp(v_g_2554, "to")
		J.sp(v_g_2554, "node", _t2516)
		J.sp(v_g_2554, "to", null)
		J.sp(v_g_2554, "p", 0.0)
		var _t2517 = _s925["__p"]["onArrive"]
		J.cl(_t2517, null, [v_g_2554])

func _f409(this_, a: Array, env):
	var v_o_2582 = null; var v_a_2583 = null; var v_b_2584 = null
	v_o_2582 = J.arg(a, 0)
	v_a_2583 = J.gp(J.gp(env["G"], "nodes"), J.gp(v_o_2582, "node"))
	if (not J.t(J.gp(v_o_2582, "to"))):
		return {"x": J.gp(v_a_2583, "x"), "y": J.gp(v_a_2583, "y")}
	v_b_2584 = J.gp(J.gp(env["G"], "nodes"), J.gp(v_o_2582, "to"))
	return {"x": J.add(J.gp(v_a_2583, "x"), J.mul(J.sub(J.gp(v_b_2584, "x"), J.gp(v_a_2583, "x")), J.gp(v_o_2582, "p"))), "y": J.add(J.gp(v_a_2583, "y"), J.mul(J.sub(J.gp(v_b_2584, "y"), J.gp(v_a_2583, "y")), J.gp(v_o_2582, "p")))}

func _f410(this_, a: Array, env):
	var v_g_2587 = null; var v_n_2588 = null; var v_un_2589 = null; var v_d_2590 = null
	v_g_2587 = J.arg(a, 0)
	v_n_2588 = J.gp(J.gp(env["G"], "nodes"), J.gp(v_g_2587, "node"))
	if J.seq(J.gp(v_n_2588, "kind"), "in"):
		var _t2518 = env["unitOf"]
		v_un_2589 = J.cl(_t2518, null, [J.gp(v_n_2588, "id")])
		if (not J.t(J.gp(v_un_2589, "entered"))):
			J.sp(v_un_2589, "entered", true)
			J.sp(v_un_2589, "seen", true)
			var _t2519 = env["G"]
			var _t2520 = J.add(J.gp(_t2519, "alert"), J.gp(v_un_2589, "plus"))
			J.sp(_t2519, "alert", _t2520)
			var _t2521 = env["float"]
			J.cl(_t2521, null, [J.gp(v_n_2588, "x"), J.sub(J.gp(v_n_2588, "y"), 90.0), J.add("全樓警覺 +", J.gp(v_un_2589, "plus")), "#ff9a9a"])
			J.cl(env["checkAlert"], null, [])
			if J.seq(J.gp(v_un_2589, "ambush"), "dog"):
				J.sp(v_un_2589, "ambush", null)
				var _t2522 = env["mkHuman"]
				v_d_2590 = J.cl(_t2522, null, ["dog", J.gp(v_un_2589, "did"), {"state": "chase"}])
				J.sp(v_d_2590, "alertT", 1.4)
				var _t2523 = J.gp(env["G"], "guards")
				J.mc(_t2523, "push", [v_d_2590])
				var _t2524 = env["G"]
				J.sp(_t2524, "shake", 0.4)
				var _t2525 = env["float"]
				J.cl(_t2525, null, [J.gp(v_n_2588, "x"), J.sub(J.gp(v_n_2588, "y"), 110.0), "黑屋有隻狗醒咗！", "#ffb0b0"])
				var _t2526 = env["G"]
				var _t2527 = J.add(J.gp(_t2526, "alert"), 1.0)
				J.sp(_t2526, "alert", _t2527)
	var _t2528 = J.seq(J.gp(v_n_2588, "kind"), "portal")
	if (J.seq(J.gp(v_g_2587, "i"), J.gp(env["G"], "active")) if _t2528 else _t2528):
		var _t2529 = env["float"]
		J.cl(_t2529, null, [J.gp(v_n_2588, "x"), J.sub(J.gp(v_n_2588, "y"), 70.0), "陰門：企定按「開陰門」", "#9fd6bf"])
	if J.t((J.seq(J.gp(v_n_2588, "kind"), "in") if J.t(env["UNIT"]) else env["UNIT"])):
		J.mc(env["UNIT"], "arrive", [v_g_2587, v_n_2588])

func _f412(this_, a: Array, env):
	var v_l_2602 = null
	v_l_2602 = J.arg(a, 0)
	var _t2534 = (not J.t(J.gp(env["seen"], J.gp(v_l_2602, "to"))))
	if J.t(_t2534):
		var _t2533 = env["__p"]["canPass"]
		_t2534 = J.seq(J.cl(_t2533, null, [env["g"], J.gp(v_l_2602, "e")]), true)
	if _t2534:
		var _t2535 = env["seen"]
		var _t2536 = J.gp(v_l_2602, "to")
		J.sp(_t2535, _t2536, 1.0)
		var _t2537 = env["prev"]
		var _t2538 = J.gp(v_l_2602, "to")
		var _t2539 = env["c"]
		J.sp(_t2537, _t2538, _t2539)
		J.mc(env["q"], "push", [J.gp(v_l_2602, "to")])

func _f411(this_, a: Array, env):
	var v_target_2594 = null; var v_path_2599 = null
	var _s940 = {"__p": env, "g": null, "prev": null, "q": null, "seen": null, "c": null}
	_s940["g"] = J.arg(a, 0)
	v_target_2594 = J.arg(a, 1)
	_s940["prev"] = {}
	_s940["q"] = [J.gp(_s940["g"], "node")]
	_s940["seen"] = {}
	var _t2530 = _s940["seen"]
	var _t2531 = J.gp(_s940["g"], "node")
	J.sp(_t2530, _t2531, 1.0)
	while true:
		if not J.t(J.len(_s940["q"])): break
		_s940["c"] = J.mc(_s940["q"], "shift", [])
		if J.seq(_s940["c"], v_target_2594):
			break
		var _t2532 = J.gp(J.gp(J.gp(_s940["__p"]["G"], "nodes"), _s940["c"]), "links")
		J.mc(_t2532, "forEach", [Callable(self, "_f412").bind(_s940)])
	if (not J.t(J.gp(_s940["seen"], v_target_2594))):
		return false
	v_path_2599 = [v_target_2594]
	while true:
		if not (not J.seq(J.gp(v_path_2599, 0.0), J.gp(_s940["g"], "node"))): break
		J.mc(v_path_2599, "unshift", [J.gp(_s940["prev"], J.gp(v_path_2599, 0.0))])
	var _t2540 = _s940["g"]
	var _t2541 = J.mc(v_path_2599, "slice", [1.0])
	J.sp(_t2540, "auto", _t2541)
	return true

func _f414(this_, a: Array, env):
	var v_k_2617 = null
	v_k_2617 = J.arg(a, 0)
	var _t2542 = env["dist"]
	J.sp(_t2542, v_k_2617, 1000000000.0)

func _f415(this_, a: Array, env):
	var v_l_2620 = null; var v_a_2621 = null; var v_b_2622 = null; var v_w_2623 = null
	v_l_2620 = J.arg(a, 0)
	var _t2547 = env["__p"]["humanPass"]
	if (not J.t(J.cl(_t2547, null, [env["h"], J.gp(v_l_2620, "e")]))):
		return null
	var _t2548 = env["__p"]["safeNode"]
	var _t2550 = J.cl(_t2548, null, [J.gp(v_l_2620, "to")])
	if J.t(_t2550):
		var _t2549 = env["__p"]["safeNode"]
		_t2550 = (not J.t(J.cl(_t2549, null, [env["src"]])))
	if J.t(_t2550):
		return null
	v_a_2621 = J.gp(J.gp(env["__p"]["G"], "nodes"), env["u"])
	v_b_2622 = J.gp(J.gp(env["__p"]["G"], "nodes"), J.gp(v_l_2620, "to"))
	v_w_2623 = J.hypot_([J.sub(J.gp(v_a_2621, "x"), J.gp(v_b_2622, "x")), J.sub(J.gp(v_a_2621, "y"), J.gp(v_b_2622, "y"))])
	if J.cmp(J.add(J.gp(env["dist"], env["u"]), v_w_2623), J.gp(env["dist"], J.gp(v_l_2620, "to")), "<"):
		var _t2551 = env["dist"]
		var _t2552 = J.gp(v_l_2620, "to")
		var _t2553 = J.add(J.gp(env["dist"], env["u"]), v_w_2623)
		J.sp(_t2551, _t2552, _t2553)
		var _t2554 = env["prev"]
		var _t2555 = J.gp(v_l_2620, "to")
		var _t2556 = env["u"]
		J.sp(_t2554, _t2555, _t2556)

func _f413(this_, a: Array, env):
	var v_dst_2607 = null; var v_Q_2610 = null; var v_bi_2611 = null; var v_i_2612 = null; var v_p_2614 = null
	var _s944 = {"__p": env, "h": null, "src": null, "dist": null, "prev": null, "u": null}
	_s944["h"] = J.arg(a, 0)
	_s944["src"] = J.arg(a, 1)
	v_dst_2607 = J.arg(a, 2)
	_s944["dist"] = {}
	_s944["prev"] = {}
	v_Q_2610 = J.S_Object_("keys", [J.gp(_s944["__p"]["G"], "nodes")])
	J.mc(v_Q_2610, "forEach", [Callable(self, "_f414").bind(_s944)])
	var _t2543 = _s944["dist"]
	var _t2544 = _s944["src"]
	J.sp(_t2543, _t2544, 0.0)
	while true:
		if not J.t(J.len(v_Q_2610)): break
		v_bi_2611 = 0.0
		v_i_2612 = 1.0
		while true:
			if not J.cmp(v_i_2612, J.len(v_Q_2610), "<"): break
			if J.cmp(J.gp(_s944["dist"], J.gp(v_Q_2610, v_i_2612)), J.gp(_s944["dist"], J.gp(v_Q_2610, v_bi_2611)), "<"):
				v_bi_2611 = v_i_2612
			v_i_2612 = J.num(v_i_2612) + 1.0
		_s944["u"] = J.gp(J.mc(v_Q_2610, "splice", [v_bi_2611, 1.0]), 0.0)
		var _t2545 = J.seq(_s944["u"], v_dst_2607)
		if (_t2545 if _t2545 else J.cmp(J.gp(_s944["dist"], _s944["u"]), 1000000000.0, ">=")):
			break
		var _t2546 = J.gp(J.gp(J.gp(_s944["__p"]["G"], "nodes"), _s944["u"]), "links")
		J.mc(_t2546, "forEach", [Callable(self, "_f415").bind(_s944)])
	if J.cmp(J.gp(_s944["dist"], v_dst_2607), 1000000000.0, ">="):
		return null
	v_p_2614 = [v_dst_2607]
	while true:
		if not (not J.seq(J.gp(v_p_2614, 0.0), _s944["src"])): break
		J.mc(v_p_2614, "unshift", [J.gp(_s944["prev"], J.gp(v_p_2614, 0.0))])
	return J.mc(v_p_2614, "slice", [1.0])

func _f417(this_, a: Array, env):
	var v_l_2632 = null
	v_l_2632 = J.arg(a, 0)
	return J.seq(J.gp(v_l_2632, "to"), J.gp(env["b"], "id"))

func _f416(this_, a: Array, env):
	var v_h_2626 = null; var v_a_2627 = null; var v_l_2629 = null
	var _s950 = {"__p": env, "b": null}
	v_h_2626 = J.arg(a, 0)
	v_a_2627 = J.arg(a, 1)
	_s950["b"] = J.arg(a, 2)
	var _t2557 = J.gp(v_a_2627, "links")
	v_l_2629 = J.mc(_t2557, "find", [Callable(self, "_f417").bind(_s950)])
	var _t2559 = (not J.t(v_l_2629))
	if not J.t(_t2559):
		var _t2558 = _s950["__p"]["humanPass"]
		_t2559 = J.cl(_t2558, null, [v_h_2626, J.gp(v_l_2629, "e")])
	return _t2559

func _f418(this_, a: Array, env):
	var v_o_2635 = null; var v_best_2636 = null; var v_bd_2637 = null; var v_k_2638 = null; var v_n_2639 = null; var v_d_2640 = null
	v_o_2635 = J.arg(a, 0)
	v_best_2636 = null
	v_bd_2637 = 1000000000.0
	for _t2560 in J.keys(J.gp(env["G"], "nodes")):
		v_k_2638 = _t2560
		v_n_2639 = J.gp(J.gp(env["G"], "nodes"), v_k_2638)
		if J.seq(J.gp(v_n_2639, "kind"), "in"):
			continue
		v_d_2640 = (absf(J.num(J.sub(J.gp(v_n_2639, "x"), J.gp(v_o_2635, "x")))) + (absf(J.num(J.sub(J.gp(v_n_2639, "y"), J.gp(v_o_2635, "y")))) * 3.0))
		if J.cmp(v_d_2640, v_bd_2637, "<"):
			v_bd_2637 = v_d_2640
			v_best_2636 = v_k_2638
	return v_best_2636

func _f420(this_, a: Array, env):
	var v_h_2647 = null; var v_dx_2648 = null
	v_h_2647 = J.arg(a, 0)
	var _t2563 = (not J.seq(J.gp(v_h_2647, "kind"), "mirror"))
	if (_t2563 if _t2563 else J.seq(J.gp(v_h_2647, "state"), "gone")):
		return null
	if (absf(J.num(J.sub(J.gp(v_h_2647, "y"), J.gp(env["g"], "y")))) > 40.0):
		return null
	v_dx_2648 = J.sub(J.gp(env["g"], "x"), J.gp(v_h_2647, "x"))
	if (absf(J.num(v_dx_2648)) > 220.0):
		return null
	var _t2564 = J.seq(signf(J.num(v_dx_2648)), J.gp(v_h_2647, "dir"))
	if (J.seq(J.gp(env["g"], "dir"), (-J.num(J.gp(v_h_2647, "dir")))) if _t2564 else _t2564):
		env["m"] = v_h_2647

func _f419(this_, a: Array, env):
	var _s956 = {"__p": env, "g": null, "m": null}
	_s956["g"] = J.arg(a, 0)
	var _t2561 = _s956["__p"]["inSafe"]
	if J.t(J.cl(_t2561, null, [_s956["g"]])):
		return null
	_s956["m"] = null
	var _t2562 = J.gp(_s956["__p"]["G"], "guards")
	J.mc(_t2562, "forEach", [Callable(self, "_f420").bind(_s956)])
	return _s956["m"]

func _f423(this_, a: Array, env):
	var v_l_2672 = null
	v_l_2672 = J.arg(a, 0)
	return J.seq(J.gp(v_l_2672, "to"), env["nx"])

func _f424(this_, a: Array, env):
	var v_k_2675 = null; var v_I_2676 = null
	v_k_2675 = J.arg(a, 0)
	v_I_2676 = J.gp(env["__p"]["__p"]["ITEM"], v_k_2675)
	var _t2685 = (not J.t(J.gp(v_I_2676, "who")))
	return (_t2685 if _t2685 else J.seq(J.gp(v_I_2676, "who"), J.gp(J.gp(env["g"], "d"), "key")))

func _f422(this_, a: Array, env):
	var v_ln_2659 = null; var v_a_2660 = null; var v_b_2661 = null; var v_D_2662 = null; var v_p_2663 = null; var v_n_2664 = null; var v_st_2665 = null; var v_un_2666 = null; var v_it_2667 = null; var v_pn_2668 = null; var v_du_2669 = null
	var _s965 = {"__p": env, "g": null, "nx": null}
	_s965["g"] = J.arg(a, 0)
	var _t2596 = _s965["__p"]["__p"]["gpE"]
	J.cl(_t2596, null, [_s965["g"]])
	var _t2597 = J.gp(_s965["g"], "home")
	if J.t((_t2597 if J.t(_t2597) else J.gp(_s965["g"], "out"))):
		return null
	var _t2598 = _s965["g"]
	var _t2599 = J.gp(_s965["g"], "blockT")
	var _t2600 = J.sub((_t2599 if J.t(_t2599) else 0.0), _s965["__p"]["dt"])
	J.sp(_t2598, "blockT", _t2600)
	var _t2601 = _s965["g"]
	var _t2602 = J.max_([0.0, J.sub(J.gp(_s965["g"], "inv"), _s965["__p"]["dt"])])
	J.sp(_t2601, "inv", _t2602)
	var _t2603 = _s965["g"]
	var _t2604 = J.max_([0.0, J.sub(J.gp(_s965["g"], "invCd"), _s965["__p"]["dt"])])
	J.sp(_t2603, "invCd", _t2604)
	var _t2605 = _s965["g"]
	var _t2606 = J.max_([0.0, J.sub(J.gp(_s965["g"], "stun"), _s965["__p"]["dt"])])
	J.sp(_t2605, "stun", _t2606)
	var _t2607 = _s965["g"]
	var _t2608 = J.max_([0.0, J.sub(J.gp(_s965["g"], "scareCd"), _s965["__p"]["dt"])])
	J.sp(_t2607, "scareCd", _t2608)
	var _t2609 = _s965["g"]
	var _t2610 = J.max_([0.0, J.sub(J.gp(_s965["g"], "actT"), _s965["__p"]["dt"])])
	J.sp(_t2609, "actT", _t2610)
	var _t2611 = _s965["g"]
	var _t2612 = J.max_([0.0, J.sub(J.gp(_s965["g"], "hitT"), _s965["__p"]["dt"])])
	J.sp(_t2611, "hitT", _t2612)
	var _t2613 = _s965["g"]
	var _t2614 = J.max_([0.0, J.sub(J.gp(_s965["g"], "bounceT"), _s965["__p"]["dt"])])
	J.sp(_t2613, "bounceT", _t2614)
	var _t2615 = _s965["g"]
	var _t2616 = J.gp(_s965["g"], "sealT")
	var _t2617 = J.gp(_s965["g"], "sealT")
	var _t2618 = J.max_([0.0, J.sub((_t2617 if J.t(_t2617) else 0.0), _s965["__p"]["dt"])])
	J.sp(_t2615, "sealT", _t2618)
	var _t2619 = _s965["g"]
	var _t2620 = J.gp(_s965["g"], "dropT")
	var _t2621 = J.gp(_s965["g"], "dropT")
	var _t2622 = J.max_([0.0, J.sub((_t2621 if J.t(_t2621) else 0.0), _s965["__p"]["dt"])])
	J.sp(_t2619, "dropT", _t2622)
	if J.t(J.gp(_s965["g"], "inUnit")):
		return null
	var _t2623 = _s965["__p"]["__p"]["moveUpdate"]
	J.cl(_t2623, null, [_s965["g"], _s965["__p"]["dt"]])
	var _t2624 = _s965["__p"]["__p"]["beansCheck"]
	J.cl(_t2624, null, [_s965["g"], _s965["__p"]["dt"]])
	if J.seq(J.gp(J.gp(_s965["g"], "d"), "key"), "toyol"):
		var _t2625 = _s965["g"]
		var _t2626 = J.gp(_s965["g"], "flipT")
		var _t2627 = J.gp(_s965["g"], "flipT")
		var _t2628 = J.max_([0.0, J.sub((_t2627 if J.t(_t2627) else 0.0), _s965["__p"]["dt"])])
		J.sp(_t2625, "flipT", _t2628)
		if J.cmp(J.gp(_s965["g"], "mv"), 0.0, ">"):
			var _t2629 = _s965["g"]
			var _t2630 = J.sub((1.2 if J.leq(J.gp(_s965["g"], "flipCd"), null) else J.gp(_s965["g"], "flipCd")), _s965["__p"]["dt"])
			J.sp(_t2629, "flipCd", _t2630)
			if J.cmp(J.gp(_s965["g"], "flipCd"), 0.0, "<="):
				var _t2631 = _s965["g"]
				J.sp(_t2631, "flipT", 0.55)
				var _t2632 = _s965["g"]
				var _t2633 = (2.2 + J.mul(J.cl(_s965["__p"]["__p"]["rnd"], null, []), 1.5))
				J.sp(_t2632, "flipCd", _t2633)
	var _t2634 = J.gp(_s965["g"], "auto")
	if J.t((J.len(J.gp(_s965["g"], "auto")) if J.t(_t2634) else _t2634)):
		_s965["nx"] = J.gp(J.gp(_s965["g"], "auto"), 0.0)
		if (not J.t(J.gp(_s965["g"], "to"))):
			if J.seq(J.gp(_s965["g"], "node"), _s965["nx"]):
				J.mc(J.gp(_s965["g"], "auto"), "shift", [])
			else:
				var _t2635 = J.gp(J.gp(J.gp(_s965["__p"]["__p"]["G"], "nodes"), J.gp(_s965["g"], "node")), "links")
				v_ln_2659 = J.mc(_t2635, "find", [Callable(self, "_f423").bind(_s965)])
				var _t2637 = v_ln_2659
				if J.t(_t2637):
					var _t2636 = _s965["__p"]["__p"]["canPass"]
					_t2637 = J.seq(J.cl(_t2636, null, [_s965["g"], J.gp(v_ln_2659, "e")]), true)
				if J.t(_t2637):
					var _t2638 = _s965["g"]
					var _t2639 = _s965["nx"]
					J.sp(_t2638, "to", _t2639)
					var _t2640 = _s965["g"]
					J.sp(_t2640, "p", 0.0)
				else:
					var _t2641 = _s965["g"]
					J.sp(_t2641, "auto", null)
		if J.t(J.gp(_s965["g"], "to")):
			v_a_2660 = J.gp(J.gp(_s965["__p"]["__p"]["G"], "nodes"), J.gp(_s965["g"], "node"))
			v_b_2661 = J.gp(J.gp(_s965["__p"]["__p"]["G"], "nodes"), J.gp(_s965["g"], "to"))
			v_D_2662 = J.hypot_([J.sub(J.gp(v_b_2661, "x"), J.gp(v_a_2660, "x")), J.sub(J.gp(v_b_2661, "y"), J.gp(v_a_2660, "y"))])
			var _t2642 = _s965["g"]
			var _t2644 = J.mul(J.gp(J.gp(_s965["g"], "d"), "sp"), J.gp(J.gp(_s965["__p"]["__p"]["G"], "mods"), "spd"))
			var _t2643 = J.gp(_s965["g"], "spm")
			var _t2645 = J.add(J.gp(_t2642, "p"), J.div(J.mul(J.mul(_t2644, (_t2643 if J.t(_t2643) else 1.0)), _s965["__p"]["dt"]), v_D_2662))
			J.sp(_t2642, "p", _t2645)
			var _t2646 = _s965["g"]
			J.sp(_t2646, "still", 0.0)
			var _t2647 = _s965["g"]
			J.sp(_t2647, "taskP", 0.0)
			if (not J.seq(J.gp(v_b_2661, "x"), J.gp(v_a_2660, "x"))):
				var _t2648 = _s965["g"]
				var _t2649 = (1.0 if J.cmp(J.gp(v_b_2661, "x"), J.gp(v_a_2660, "x"), ">") else (-1.0))
				J.sp(_t2648, "dir", _t2649)
			if J.cmp(J.gp(_s965["g"], "p"), 1.0, ">="):
				var _t2650 = _s965["g"]
				var _t2651 = J.gp(_s965["g"], "to")
				J.sp(_t2650, "node", _t2651)
				var _t2652 = _s965["g"]
				J.sp(_t2652, "to", null)
				var _t2653 = _s965["g"]
				J.sp(_t2653, "p", 0.0)
				var _t2654 = J.gp(_s965["g"], "auto")
				if J.t((J.seq(J.gp(J.gp(_s965["g"], "auto"), 0.0), J.gp(_s965["g"], "node")) if J.t(_t2654) else _t2654)):
					J.mc(J.gp(_s965["g"], "auto"), "shift", [])
				var _t2655 = _s965["__p"]["__p"]["onArrive"]
				J.cl(_t2655, null, [_s965["g"]])
	var _t2656 = _s965["__p"]["__p"]["posOf"]
	v_p_2663 = J.cl(_t2656, null, [_s965["g"]])
	var _t2657 = _s965["g"]
	var _t2658 = J.max_([0.0, J.sub(J.gp(_s965["g"], "mv"), _s965["__p"]["dt"])])
	J.sp(_t2657, "mv", _t2658)
	if ((absf(J.num(J.sub(J.gp(v_p_2663, "x"), J.gp(_s965["g"], "x")))) + absf(J.num(J.sub(J.gp(v_p_2663, "y"), J.gp(_s965["g"], "y"))))) > 0.2):
		var _t2659 = _s965["g"]
		J.sp(_t2659, "mv", 0.18)
		var _t2660 = _s965["g"]
		J.sp(_t2660, "still", 0.0)
	else:
		var _t2661 = _s965["g"]
		var _t2662 = J.add(J.gp(_t2661, "still"), _s965["__p"]["dt"])
		J.sp(_t2661, "still", _t2662)
	var _t2663 = _s965["g"]
	var _t2664 = J.gp(v_p_2663, "x")
	J.sp(_t2663, "x", _t2664)
	var _t2665 = _s965["g"]
	var _t2666 = J.gp(v_p_2663, "y")
	J.sp(_t2665, "y", _t2666)
	var _t2667 = J.gp(_s965["g"], "autoS")
	var _t2669 = ((not J.t(J.gp(_s965["g"], "to"))) if J.t(_t2667) else _t2667)
	if J.t(_t2669):
		var _t2668 = J.gp(_s965["g"], "auto")
		_t2669 = (not J.t((J.len(J.gp(_s965["g"], "auto")) if J.t(_t2668) else _t2668)))
	var _t2670 = (J.cmp(J.gp(_s965["g"], "still"), 0.12, ">=") if J.t(_t2669) else _t2669)
	var _t2671 = (J.cmp(J.gp(_s965["g"], "stun"), 0.0, "<=") if J.t(_t2670) else _t2670)
	if J.t((J.cmp(J.gp(_s965["g"], "scareCd"), 0.0, "<=") if J.t(_t2671) else _t2671)):
		var _t2672 = _s965["g"]
		J.sp(_t2672, "autoS", null)
		var _t2673 = J.seq(J.gp(_s965["__p"]["__p"]["G"], "active"), J.gp(_s965["g"], "i"))
		if (J.cmp(J.gp(_s965["g"], "scareCd"), 0.0, "<=") if _t2673 else _t2673):
			J.cl(_s965["__p"]["__p"]["scarePress"], null, [])
	v_n_2664 = J.gp(J.gp(_s965["__p"]["__p"]["G"], "nodes"), J.gp(_s965["g"], "node"))
	var _t2674 = (not J.t(J.gp(_s965["g"], "to")))
	var _t2675 = (J.cmp(J.gp(_s965["g"], "still"), 0.1, ">=") if _t2674 else _t2674)
	var _t2677 = (J.cmp(J.gp(_s965["g"], "stun"), 0.0, "<=") if _t2675 else _t2675)
	if J.t(_t2677):
		var _t2676 = _s965["__p"]["__p"]["mirrorOn"]
		_t2677 = (not J.t(J.cl(_t2676, null, [_s965["g"]])))
	v_st_2665 = _t2677
	if J.t((J.seq(J.gp(v_n_2664, "kind"), "in") if J.t(v_st_2665) else v_st_2665)):
		var _t2678 = _s965["__p"]["__p"]["unitOf"]
		v_un_2666 = J.cl(_t2678, null, [J.gp(v_n_2664, "id")])
		if J.t(J.gp(v_un_2666, "lit")):
			var _t2679 = _s965["__p"]["__p"]["float"]
			J.cl(_t2679, null, [J.gp(_s965["g"], "x"), J.sub(J.gp(_s965["g"], "y"), 70.0), "開咗燈！被逼返出去", "#ffb0b0"])
			var _t2680 = _s965["g"]
			var _t2681 = J.gp(v_un_2666, "did")
			J.sp(_t2680, "node", _t2681)
			var _t2682 = _s965["g"]
			J.sp(_t2682, "stun", 0.6)
			var _t2683 = _s965["__p"]["__p"]["loseLoot"]
			J.cl(_t2683, null, [_s965["g"], 0.3])
		else:
			var _t2684 = J.gp(v_un_2666, "items")
			v_it_2667 = J.mc(_t2684, "find", [Callable(self, "_f424").bind(_s965)])
			if J.t(v_it_2667):
				var _t2686 = (not J.seq(v_it_2667, "doll"))
				var _t2687 = ((not J.seq(v_it_2667, "key")) if _t2686 else _t2686)
				var _t2688 = ((not J.seq(v_it_2667, "key2")) if _t2687 else _t2687)
				var _t2689 = ((not J.seq(v_it_2667, "lost")) if _t2688 else _t2688)
				if (J.cmp(J.len(J.gp(_s965["__p"]["__p"]["G"], "bag")), _s965["__p"]["__p"]["BAGMAX"], ">=") if _t2689 else _t2689):
					var _t2690 = (not J.t(J.gp(_s965["g"], "fullT")))
					if (_t2690 if _t2690 else J.cmp(J.gp(_s965["g"], "fullT"), 0.0, "<=")):
						var _t2691 = _s965["__p"]["__p"]["float"]
						J.cl(_t2691, null, [J.gp(_s965["g"], "x"), J.sub(J.gp(_s965["g"], "y"), 80.0), "收穫格滿咗！", "#ffb0b0"])
						var _t2692 = _s965["g"]
						J.sp(_t2692, "fullT", 2.0)
					var _t2693 = _s965["g"]
					var _t2694 = J.sub(J.gp(_t2693, "fullT"), _s965["__p"]["dt"])
					J.sp(_t2693, "fullT", _t2694)
				else:
					var _t2695 = _s965["g"]
					var _t2697 = J.mul(_s965["__p"]["dt"], J.gp(J.gp(_s965["__p"]["__p"]["G"], "mods"), "task"))
					var _t2696 = J.gp(_s965["g"], "tm")
					var _t2698 = J.add(J.gp(_t2695, "taskP"), J.div(J.mul(_t2697, (_t2696 if J.t(_t2696) else 1.0)), J.gp(J.gp(_s965["__p"]["__p"]["ITEM"], v_it_2667), "t")))
					J.sp(_t2695, "taskP", _t2698)
					if J.cmp(J.cl(_s965["__p"]["__p"]["rnd"], null, []), J.mul(_s965["__p"]["dt"], 14.0), "<"):
						if J.seq(J.gp(J.gp(_s965["g"], "d"), "key"), "toyol"):
							v_pn_2668 = {"x": J.add(J.gp(_s965["g"], "x"), J.mul(J.gp(_s965["g"], "dir"), 30.0)), "y": J.sub(J.gp(_s965["g"], "y"), 36.0), "vx": J.cl(_s965["__p"]["__p"]["rnd"], null, []), "vy": 0.0, "life": 0.7, "max": 0.7, "type": "note"}
							var _t2699 = J.gp(_s965["g"], "x")
							J.sp(v_pn_2668, "tx", _t2699)
							var _t2700 = J.sub(J.gp(_s965["g"], "y"), J.mul(J.gp(J.gp(_s965["g"], "d"), "h"), 0.45))
							J.sp(v_pn_2668, "ty", _t2700)
							var _t2701 = J.gp(_s965["__p"]["__p"]["G"], "parts")
							J.mc(_t2701, "push", [v_pn_2668])
						else:
							if J.seq(J.gp(J.gp(_s965["g"], "d"), "key"), "tianhua"):
								var _t2702 = _s965["__p"]["__p"]["part"]
								J.cl(_t2702, null, [J.add(J.gp(_s965["g"], "x"), (J.sub(J.cl(_s965["__p"]["__p"]["rnd"], null, []), 0.5) * 20.0)), J.sub(J.gp(_s965["g"], "y"), J.mul(J.gp(J.gp(_s965["g"], "d"), "h"), 0.5)), (J.sub(J.cl(_s965["__p"]["__p"]["rnd"], null, []), 0.5) * 60.0), ((-40.0) - J.mul(J.cl(_s965["__p"]["__p"]["rnd"], null, []), 40.0)), 0.7, "hair"])
					if J.cmp(J.gp(_s965["g"], "taskP"), 1.0, ">="):
						var _t2703 = _s965["g"]
						J.sp(_t2703, "taskP", 0.0)
						var _t2704 = J.gp(v_un_2666, "items")
						var _t2705 = J.gp(v_un_2666, "items")
						J.mc(_t2704, "splice", [J.mc(_t2705, "indexOf", [v_it_2667]), 1.0])
						var _t2706 = _s965["__p"]["__p"]["takeItem"]
						J.cl(_t2706, null, [_s965["g"], v_it_2667, v_un_2666])
			var _t2707 = J.gp(v_un_2666, "res")
			if J.t((J.seq(J.gp(J.gp(v_un_2666, "res"), "state"), "home") if J.t(_t2707) else _t2707)):
				var _t2708 = J.gp(v_un_2666, "res")
				var _t2710 = J.mul(J.mul(_s965["__p"]["dt"], 3.0), J.gp(J.gp(_s965["__p"]["__p"]["G"], "mods"), "pow"))
				var _t2709 = _s965["__p"]["__p"]["gpF"]
				var _t2711 = J.add(J.gp(_t2708, "fear"), J.mul(_t2710, J.cl(_t2709, null, [_s965["g"]])))
				J.sp(_t2708, "fear", _t2711)
				if J.cmp(J.gp(J.gp(v_un_2666, "res"), "fear"), 100.0, ">="):
					var _t2712 = _s965["__p"]["__p"]["flee"]
					J.cl(_t2712, null, [J.gp(v_un_2666, "res"), _s965["g"]])
	else:
		if (not J.t(v_st_2665)):
			var _t2713 = _s965["g"]
			J.sp(_t2713, "taskP", 0.0)
	var _t2714 = (not J.t(J.gp(_s965["g"], "to")))
	if (J.seq(J.gp(v_n_2664, "kind"), "door") if _t2714 else _t2714):
		var _t2715 = _s965["__p"]["__p"]["unitByDoor"]
		v_du_2669 = J.cl(_t2715, null, [J.gp(v_n_2664, "id")])
		var _t2716 = _s965["g"]
		var _t2718 = null
		if J.t(v_st_2665):
			var _t2717 = J.gp(_s965["g"], "injT")
			_t2718 = J.add((_t2717 if J.t(_t2717) else 0.0), _s965["__p"]["dt"])
		else:
			_t2718 = 0.0
		J.sp(_t2716, "injT", _t2718)
		var _t2719 = ((not J.t(J.gp(v_du_2669, "open"))) if J.t(v_du_2669) else v_du_2669)
		var _t2720 = (J.seq(J.gp(v_du_2669, "ot"), 2.0) if J.t(_t2719) else _t2719)
		if J.t((J.cmp(J.gp(_s965["g"], "injT"), 0.5, ">=") if J.t(_t2720) else _t2720)):
			var _t2721 = _s965["g"]
			var _t2722 = J.gp(_s965["g"], "injAcc")
			var _t2723 = J.add((_t2722 if J.t(_t2722) else 0.0), _s965["__p"]["dt"])
			J.sp(_t2721, "injAcc", _t2723)
			while true:
				var _t2724 = J.cmp(J.gp(_s965["g"], "injAcc"), 0.1, ">=")
				var _t2725 = (J.cmp(J.gp(_s965["__p"]["__p"]["G"], "fear"), 0.0, ">") if _t2724 else _t2724)
				if not (J.cmp(J.gp(v_du_2669, "paid"), J.gp(v_du_2669, "cost"), "<") if _t2725 else _t2725): break
				var _t2726 = _s965["g"]
				var _t2727 = J.sub(J.gp(_t2726, "injAcc"), 0.1)
				J.sp(_t2726, "injAcc", _t2727)
				var _t2728 = _s965["__p"]["__p"]["G"]
				J.sp(_t2728, "fear", J.num(J.gp(_t2728, "fear")) + -1.0)
				J.sp(v_du_2669, "paid", J.num(J.gp(v_du_2669, "paid")) + 1.0)
				if J.cmp(J.cl(_s965["__p"]["__p"]["rnd"], null, []), 0.6, "<"):
					var _t2729 = _s965["__p"]["__p"]["part"]
					J.cl(_t2729, null, [J.gp(_s965["g"], "x"), J.sub(J.gp(_s965["g"], "y"), 40.0), (J.sub(J.gp(v_du_2669, "x"), J.gp(_s965["g"], "x")) * 2.0), (-20.0), 0.5, "suck"])
			if J.cmp(J.gp(v_du_2669, "paid"), J.gp(v_du_2669, "cost"), ">="):
				var _t2730 = _s965["__p"]["__p"]["unlockUnit"]
				J.cl(_t2730, null, [v_du_2669, "鎮宅破咗！"])
			else:
				var _t2732 = J.cmp(J.gp(_s965["__p"]["__p"]["G"], "fear"), 0.0, "<=")
				if J.t(_t2732):
					var _t2731 = (not J.t(J.gp(_s965["g"], "blockT")))
					_t2732 = (_t2731 if _t2731 else J.cmp(J.gp(_s965["g"], "blockT"), 0.0, "<="))
				if _t2732:
					var _t2733 = _s965["__p"]["__p"]["float"]
					J.cl(_t2733, null, [J.gp(_s965["g"], "x"), J.sub(J.gp(_s965["g"], "y"), 80.0), "怕意唔夠，去嚇多啲人", "#ffd54a"])
					var _t2734 = _s965["g"]
					J.sp(_t2734, "blockT", 6.0)
		var _t2735 = ((not J.t(J.gp(v_du_2669, "open"))) if J.t(v_du_2669) else v_du_2669)
		var _t2736 = (J.seq(J.gp(v_du_2669, "ot"), 11.0) if J.t(_t2735) else _t2735)
		var _t2737 = (v_st_2665 if J.t(_t2736) else _t2736)
		if J.t((J.gp(J.gp(_s965["__p"]["__p"]["G"], "keys"), J.gp(v_du_2669, "keyNeed")) if J.t(_t2737) else _t2737)):
			var _t2738 = J.gp(_s965["__p"]["__p"]["G"], "keys")
			var _t2739 = J.gp(v_du_2669, "keyNeed")
			J.sp(_t2738, _t2739, J.num(J.gp(_t2738, _t2739)) + -1.0)
			var _t2740 = _s965["__p"]["__p"]["unlockUnit"]
			J.cl(_t2740, null, [v_du_2669, (J.add("用", J.gp(J.gp(_s965["__p"]["__p"]["ITEM"], J.gp(v_du_2669, "keyNeed")), "n")) + "開咗門")])
	else:
		var _t2741 = _s965["g"]
		J.sp(_t2741, "injT", 0.0)

func _f425(this_, a: Array, env):
	var v_r_2679 = null
	v_r_2679 = J.arg(a, 0)
	var _t2743 = env["__p"]["pplResTick"]
	J.cl(_t2743, null, [v_r_2679, env["dt"]])
	var _t2744 = J.gp(v_r_2679, "jumpT")
	var _t2745 = J.gp(v_r_2679, "jumpT")
	var _t2746 = J.max_([0.0, J.sub((_t2745 if J.t(_t2745) else 0.0), env["dt"])])
	J.sp(v_r_2679, "jumpT", _t2746)
	var _t2747 = J.gp(v_r_2679, "jumpT")
	J.sp(v_r_2679, "_pj", _t2747)
	var _t2748 = J.gp(v_r_2679, "tangle")
	var _t2749 = J.gp(v_r_2679, "tangle")
	var _t2750 = J.max_([0.0, J.sub((_t2749 if J.t(_t2749) else 0.0), env["dt"])])
	J.sp(v_r_2679, "tangle", _t2750)
	if J.seq(J.gp(v_r_2679, "state"), "flee"):
		if J.cmp(J.gp(v_r_2679, "tripT"), 0.0, ">"):
			var _t2751 = J.sub(J.gp(v_r_2679, "tripT"), env["dt"])
			J.sp(v_r_2679, "tripT", _t2751)
			var _t2752 = J.add(J.gp(v_r_2679, "x"), J.mul(J.mul(J.gp(v_r_2679, "vx"), 0.18), env["dt"]))
			J.sp(v_r_2679, "x", _t2752)
		else:
			var _t2753 = J.add(J.gp(v_r_2679, "x"), J.mul(J.gp(v_r_2679, "vx"), env["dt"]))
			J.sp(v_r_2679, "x", _t2753)
		var _t2754 = J.cmp(J.gp(v_r_2679, "x"), env["__p"]["SX"], "<")
		if (_t2754 if _t2754 else J.cmp(J.gp(v_r_2679, "x"), env["__p"]["LX"], ">")):
			J.sp(v_r_2679, "state", "gone")
		if J.cmp(J.cl(env["__p"]["rnd"], null, []), J.mul(env["dt"], 8.0), "<"):
			var _t2755 = env["__p"]["part"]
			J.cl(_t2755, null, [J.sub(J.gp(v_r_2679, "x"), (signf(J.num(J.gp(v_r_2679, "vx"))) * 10.0)), J.sub(J.gp(v_r_2679, "y"), 4.0), ((-J.num(J.gp(v_r_2679, "vx"))) * 0.1), (-10.0), 0.5, "dust"])
	var _t2756 = J.seq(J.gp(v_r_2679, "state"), "home")
	if J.t((J.gp(J.gp(v_r_2679, "unit"), "door") if _t2756 else _t2756)):
		var _t2757 = J.sub(J.gp(v_r_2679, "doorT"), env["dt"])
		J.sp(v_r_2679, "doorT", _t2757)
		if J.cmp(J.gp(v_r_2679, "doorT"), 0.0, "<="):
			var _t2758 = J.gp(v_r_2679, "unit")
			J.sp(_t2758, "doorOpen", 2.6)
			var _t2759 = (12.0 + J.mul(J.cl(env["__p"]["rnd"], null, []), 8.0))
			J.sp(v_r_2679, "doorT", _t2759)
			var _t2760 = env["__p"]["say"]
			var _t2761 = env["__p"]["pick"]
			J.cl(_t2760, null, [v_r_2679, J.cl(_t2761, null, [["出去倒杯水先", "邊個喺門口？", "開門透下氣"]])])
	if J.cmp(J.gp(J.gp(v_r_2679, "unit"), "doorOpen"), 0.0, ">"):
		var _t2762 = J.gp(v_r_2679, "unit")
		var _t2763 = J.sub(J.gp(_t2762, "doorOpen"), env["dt"])
		J.sp(_t2762, "doorOpen", _t2763)

func _f426(this_, a: Array, env):
	var v_un_2682 = null
	v_un_2682 = J.arg(a, 0)
	var _t2765 = J.sub(J.gp(v_un_2682, "litT"), env["dt"])
	J.sp(v_un_2682, "litT", _t2765)
	var _t2766 = J.gp(v_un_2682, "res")
	var _t2767 = (J.seq(J.gp(J.gp(v_un_2682, "res"), "state"), "home") if J.t(_t2766) else _t2766)
	var _t2768 = ((not J.t(J.gp(v_un_2682, "lit"))) if J.t(_t2767) else _t2767)
	if J.t((J.cmp(J.cl(env["__p"]["rnd"], null, []), J.mul(env["dt"], 0.04), "<") if J.t(_t2768) else _t2768)):
		J.sp(v_un_2682, "lit", true)
		J.sp(v_un_2682, "litT", 7.0)
		var _t2769 = env["__p"]["say"]
		var _t2771 = J.gp(v_un_2682, "res")
		var _t2770 = env["__p"]["line"]
		J.cl(_t2769, null, [_t2771, J.cl(_t2770, null, ["wake"])])
	var _t2772 = J.gp(v_un_2682, "lit")
	if J.t((J.cmp(J.gp(v_un_2682, "litT"), 0.0, "<=") if J.t(_t2772) else _t2772)):
		J.sp(v_un_2682, "lit", false)

func _f427(this_, a: Array, env):
	var v_h_2685 = null
	v_h_2685 = J.arg(a, 0)
	var _t2781 = env["__p"]["humanUpdate"]
	J.cl(_t2781, null, [v_h_2685, env["dt"]])

func _f428(this_, a: Array, env):
	var v_h_2688 = null
	v_h_2688 = J.arg(a, 0)
	return (not J.seq(J.gp(v_h_2688, "state"), "gone"))

func _f429(this_, a: Array, env):
	var v_f_2691 = null
	v_f_2691 = J.arg(a, 0)
	var _t2800 = J.sub(J.gp(v_f_2691, "life"), env["dt"])
	J.sp(v_f_2691, "life", _t2800)
	var _t2801 = J.sub(J.gp(v_f_2691, "y"), J.mul(env["dt"], 22.0))
	J.sp(v_f_2691, "y", _t2801)

func _f430(this_, a: Array, env):
	var v_f_2694 = null
	v_f_2694 = J.arg(a, 0)
	return J.cmp(J.gp(v_f_2694, "life"), 0.0, ">")

func _f431(this_, a: Array, env):
	var v_r_2697 = null
	v_r_2697 = J.arg(a, 0)
	if J.t(J.gp(v_r_2697, "say")):
		var _t2806 = J.sub(J.gp(v_r_2697, "sayT"), env["dt"])
		J.sp(v_r_2697, "sayT", _t2806)
		if J.cmp(J.gp(v_r_2697, "sayT"), 0.0, "<="):
			J.sp(v_r_2697, "say", null)

func _f432(this_, a: Array, env):
	var v_g_2700 = null
	v_g_2700 = J.arg(a, 0)
	return J.gp(v_g_2700, "out")

func _f421(this_, a: Array, env):
	var v_np_2652 = null; var v_f_2653 = null; var v_h_2654 = null
	var _s958 = {"__p": env, "dt": null}
	_s958["dt"] = J.arg(a, 0)
	var _t2565 = J.gp(_s958["__p"]["G"], "over")
	var _t2566 = (_t2565 if J.t(_t2565) else J.gp(_s958["__p"]["G"], "choice"))
	if J.t((_t2566 if J.t(_t2566) else _s958["__p"]["paused"])):
		return null
	if J.t(J.gp(_s958["__p"]["G"], "ult")):
		var _t2567 = J.gp(_s958["__p"]["G"], "ult")
		var _t2568 = J.add(J.gp(_t2567, "t"), _s958["dt"])
		J.sp(_t2567, "t", _t2568)
		if J.cmp(J.gp(J.gp(_s958["__p"]["G"], "ult"), "t"), 1.3, "<"):
			var _t2569 = _s958["__p"]["stepFx"]
			J.cl(_t2569, null, [_s958["dt"]])
			return null
		if (not J.t(J.gp(J.gp(_s958["__p"]["G"], "ult"), "done"))):
			var _t2570 = J.gp(_s958["__p"]["G"], "ult")
			J.sp(_t2570, "done", true)
			var _t2571 = _s958["__p"]["applyUlt"]
			J.cl(_t2571, null, [J.gp(_s958["__p"]["G"], "ult")])
		if J.cmp(J.gp(J.gp(_s958["__p"]["G"], "ult"), "t"), 4.0, ">"):
			var _t2572 = _s958["__p"]["G"]
			J.sp(_t2572, "ult", null)
			var _t2573 = _s958["__p"]["G"]
			J.sp(_t2573, "ultCool", 1.5)
	var _t2574 = _s958["__p"]["G"]
	var _t2575 = J.add(J.gp(_t2574, "t"), _s958["dt"])
	J.sp(_t2574, "t", _t2575)
	v_np_2652 = J.min_([3.0, floor(J.num(J.div(J.gp(_s958["__p"]["G"], "t"), _s958["__p"]["PHT"])))])
	if (not J.seq(v_np_2652, J.gp(_s958["__p"]["G"], "phase"))):
		var _t2576 = _s958["__p"]["G"]
		J.sp(_t2576, "phase", v_np_2652)
		var _t2577 = _s958["__p"]["toast"]
		J.cl(_t2577, null, [(J.add(J.gp(_s958["__p"]["PH"], v_np_2652), "到喇——巡邏加派，越近天光人越精。") if J.cmp(v_np_2652, 3.0, "<") else "天光喇！樓下開始有人起身，追兵越嚟越快，快啲走！")])
	var _t2578 = _s958["__p"]["G"]
	var _t2579 = J.sub(J.gp(_t2578, "toastT"), _s958["dt"])
	J.sp(_t2578, "toastT", _t2579)
	J.cl(_s958["__p"]["gpTick"], null, [])
	if (not J.t(J.gp(_s958["__p"]["G"], "traces"))):
		var _t2580 = _s958["__p"]["G"]
		var _t2581 = []
		J.sp(_t2580, "traces", _t2581)
	J.cl(_s958["__p"]["setupBeans"], null, [])
	var _t2582 = _s958["__p"]["G"]
	var _t2583 = J.sub(J.gp(_t2582, "waveT"), _s958["dt"])
	J.sp(_t2582, "waveT", _t2583)
	var _t2584 = J.cmp(J.gp(_s958["__p"]["G"], "waveT"), 0.0, "<=")
	if ((not J.t(J.gp(_s958["__p"]["G"], "gate"))) if _t2584 else _t2584):
		var _t2585 = _s958["__p"]["G"]
		J.sp(_t2585, "wave", J.num(J.gp(_t2585, "wave")) + 1.0)
		var _t2586 = _s958["__p"]["G"]
		var _t2588 = (18.0 if J.cmp(J.gp(_s958["__p"]["G"], "phase"), 3.0, ">=") else 30.0)
		var _t2587 = J.gp(_s958["__p"]["G"], "gpTier")
		var _t2589 = J.div(_t2588, (1.0 + J.mul(0.06, (_t2587 if J.t(_t2587) else 0.0))))
		J.sp(_t2586, "waveT", _t2589)
		v_f_2653 = (1.0 + floor(J.num(J.mul(J.cl(_s958["__p"]["rnd"], null, []), J.sub(_s958["__p"]["FL"], 1.0)))))
		var _t2590 = _s958["__p"]["mkHuman"]
		v_h_2654 = J.cl(_t2590, null, ["guard", ((J.add("f", v_f_2653) + "_") + ("s" if J.cmp(J.cl(_s958["__p"]["rnd"], null, []), 0.5, "<") else "l"))])
		var _t2591 = [J.max_([1.0, J.sub(v_f_2653, 1.0)]), J.min_([J.sub(_s958["__p"]["FL"], 1.0), J.add(v_f_2653, 1.0)])]
		J.sp(v_h_2654, "zone", _t2591)
		var _t2592 = (pow(J.num(1.15), J.num(J.gp(_s958["__p"]["G"], "wave"))) if J.cmp(J.gp(_s958["__p"]["G"], "phase"), 3.0, ">=") else 1.0)
		J.sp(v_h_2654, "boost", _t2592)
		var _t2593 = J.gp(_s958["__p"]["G"], "guards")
		J.mc(_t2593, "push", [v_h_2654])
		var _t2594 = _s958["__p"]["float"]
		J.cl(_t2594, null, [J.gp(v_h_2654, "x"), J.sub(J.gp(v_h_2654, "y"), 80.0), "加派保安", "#ffb0b0"])
	var _t2595 = J.gp(_s958["__p"]["G"], "gh")
	J.mc(_t2595, "forEach", [Callable(self, "_f422").bind(_s958)])
	var _t2742 = J.gp(_s958["__p"]["G"], "res")
	J.mc(_t2742, "forEach", [Callable(self, "_f425").bind(_s958)])
	if J.cmp(J.gp(_s958["__p"]["G"], "phase"), 2.0, ">="):
		var _t2764 = J.gp(_s958["__p"]["G"], "units")
		J.mc(_t2764, "forEach", [Callable(self, "_f426").bind(_s958)])
	var _t2773 = _s958["__p"]["traceUpdate"]
	J.cl(_t2773, null, [_s958["dt"]])
	var _t2774 = _s958["__p"]["G"]
	var _t2775 = J.gp(_s958["__p"]["G"], "phoneCd")
	var _t2776 = J.gp(_s958["__p"]["G"], "phoneCd")
	var _t2777 = J.max_([0.0, J.sub((_t2776 if J.t(_t2776) else 0.0), _s958["dt"])])
	J.sp(_t2774, "phoneCd", _t2777)
	var _t2778 = _s958["__p"]["resUpdate2"]
	J.cl(_t2778, null, [_s958["dt"]])
	var _t2779 = _s958["__p"]["pplTick"]
	J.cl(_t2779, null, [_s958["dt"]])
	var _t2780 = J.gp(_s958["__p"]["G"], "guards")
	J.mc(_t2780, "forEach", [Callable(self, "_f427").bind(_s958)])
	var _t2782 = _s958["__p"]["G"]
	var _t2783 = J.gp(_s958["__p"]["G"], "guards")
	var _t2784 = J.mc(_t2783, "filter", [Callable(self, "_f428").bind(_s958)])
	J.sp(_t2782, "guards", _t2784)
	var _t2785 = _s958["__p"]["G"]
	var _t2786 = J.gp(_s958["__p"]["G"], "ultCool")
	var _t2787 = J.gp(_s958["__p"]["G"], "ultCool")
	var _t2788 = J.max_([0.0, J.sub((_t2787 if J.t(_t2787) else 0.0), _s958["dt"])])
	J.sp(_t2785, "ultCool", _t2788)
	var _t2789 = J.cmp(J.gp(_s958["__p"]["G"], "choiceQ"), 0.0, ">")
	var _t2790 = ((not J.t(J.gp(_s958["__p"]["G"], "ult"))) if _t2789 else _t2789)
	if (J.cmp(J.gp(_s958["__p"]["G"], "ultCool"), 0.0, "<=") if _t2790 else _t2790):
		var _t2791 = _s958["__p"]["G"]
		J.sp(_t2791, "choiceQ", J.num(J.gp(_t2791, "choiceQ")) + -1.0)
		var _t2792 = _s958["__p"]["G"]
		var _t2793 = _s958["__p"]["shuffle"]
		var _t2794 = J.cl(_t2793, null, [_s958["__p"]["CARDS"]])
		var _t2795 = J.mc(_t2794, "slice", [0.0, 3.0])
		J.sp(_t2792, "choice", _t2795)
	J.cl(_s958["__p"]["checkAlert"], null, [])
	var _t2796 = _s958["__p"]["taoUpdate"]
	J.cl(_t2796, null, [_s958["dt"]])
	var _t2797 = _s958["__p"]["gateUpdate"]
	J.cl(_t2797, null, [_s958["dt"]])
	var _t2798 = _s958["__p"]["stepFx"]
	J.cl(_t2798, null, [_s958["dt"]])
	var _t2799 = J.gp(_s958["__p"]["G"], "floats")
	J.mc(_t2799, "forEach", [Callable(self, "_f429").bind(_s958)])
	var _t2802 = _s958["__p"]["G"]
	var _t2803 = J.gp(_s958["__p"]["G"], "floats")
	var _t2804 = J.mc(_t2803, "filter", [Callable(self, "_f430").bind(_s958)])
	J.sp(_t2802, "floats", _t2804)
	var _t2805 = J.gp(_s958["__p"]["G"], "res")
	J.mc(_t2805, "forEach", [Callable(self, "_f431").bind(_s958)])
	var _t2807 = J.gp(_s958["__p"]["G"], "gh")
	if J.t(J.mc(_t2807, "every", [Callable(self, "_f432").bind(_s958)])):
		var _t2808 = _s958["__p"]["endNight"]
		J.cl(_t2808, null, ["fail"])

func _f434(this_, a: Array, env):
	var v_q_2709 = null
	v_q_2709 = J.arg(a, 0)
	return J.seq(J.gp(v_q_2709, "id"), "lost")

func _f433(this_, a: Array, env):
	var v_g_2703 = null; var v_it_2704 = null; var v_un_2705 = null; var v_q_2706 = null
	v_g_2703 = J.arg(a, 0)
	v_it_2704 = J.arg(a, 1)
	v_un_2705 = J.arg(a, 2)
	if J.seq(v_it_2704, "doll"):
		var _t2809 = env["G"]
		J.sp(_t2809, "dolls", J.num(J.gp(_t2809, "dolls")) + 1.0)
		var _t2810 = env["float"]
		J.cl(_t2810, null, [J.gp(v_g_2703, "x"), J.sub(J.gp(v_g_2703, "y"), 90.0), (J.add("替身紙人 ", J.gp(env["G"], "dolls")) + "/6"), "#e8d8b0"])
		if J.seq(J.gp(env["G"], "dolls"), 6.0):
			var _t2811 = env["toast"]
			J.cl(_t2811, null, ["替身紙人夠 6 個！隨時可以按「替身遁走」，但係故事碎片同部分收穫會留低。"])
		return null
	var _t2812 = J.seq(v_it_2704, "key")
	if (_t2812 if _t2812 else J.seq(v_it_2704, "key2")):
		var _t2813 = J.gp(env["G"], "keys")
		var _t2814 = J.gp(J.gp(env["G"], "keys"), v_it_2704)
		var _t2815 = J.add((_t2814 if J.t(_t2814) else 0.0), 1.0)
		J.sp(_t2813, v_it_2704, _t2815)
		var _t2816 = env["float"]
		J.cl(_t2816, null, [J.gp(v_g_2703, "x"), J.sub(J.gp(v_g_2703, "y"), 90.0), (J.add("偷到", J.gp(J.gp(env["ITEM"], v_it_2704), "n")) + "！"), "#ffd54a"])
		return null
	if J.seq(v_it_2704, "lost"):
		var _t2817 = env["G"]
		J.sp(_t2817, "carry", "lost")
		var _t2818 = J.gp(env["G"], "quests")
		var _t2819 = (_t2818 if J.t(_t2818) else [])
		v_q_2706 = J.mc(_t2819, "find", [Callable(self, "_f434").bind(env)])
		var _t2820 = env["float"]
		J.cl(_t2820, null, [J.gp(v_g_2703, "x"), J.sub(J.gp(v_g_2703, "y"), 90.0), (J.add((J.add("搵到", (J.gp(v_q_2706, "thing") if J.t(v_q_2706) else "失物")) + "！帶返去俾"), (J.gp(env["FLN"], J.gp(J.gp(v_q_2706, "owner"), "f")) if J.t(v_q_2706) else "")) + "嘅主人"), "#8affc8"])
		return null
	var _t2821 = J.seq(v_it_2704, "food")
	if (J.seq(J.gp(J.gp(v_g_2703, "d"), "key"), "eking") if _t2821 else _t2821):
		var _t2822 = J.gp(v_g_2703, "fat")
		var _t2823 = J.gp(v_g_2703, "fat")
		var _t2824 = J.min_([0.3, J.add((_t2823 if J.t(_t2823) else 0.0), 0.06)])
		J.sp(v_g_2703, "fat", _t2824)
		var _t2825 = env["float"]
		J.cl(_t2825, null, [J.gp(v_g_2703, "x"), (J.sub(J.gp(v_g_2703, "y"), J.gp(J.gp(v_g_2703, "d"), "h")) - 30.0), "越食越餓……", "#ffb7a0"])
	var _t2826 = J.gp(env["G"], "bag")
	J.mc(_t2826, "push", [{"t": v_it_2704, "o": J.gp(v_g_2703, "i")}])
	J.sp(v_g_2703, "loot", J.num(J.gp(v_g_2703, "loot")) + 1.0)
	var _t2827 = J.min_([100.0, J.add(J.gp(v_g_2703, "energy"), 12.0)])
	J.sp(v_g_2703, "energy", _t2827)
	var _t2828 = env["float"]
	J.cl(_t2828, null, [J.gp(v_g_2703, "x"), J.sub(J.gp(v_g_2703, "y"), 90.0), (J.add((J.add((J.add("收到", J.gp(J.gp(env["ITEM"], v_it_2704), "n")) + "（"), J.len(J.gp(env["G"], "bag"))) + "/"), env["BAGMAX"]) + "）"), "#ffd54a"])

func _f435(this_, a: Array, env):
	var v_u_2712 = null; var v_msg_2713 = null
	v_u_2712 = J.arg(a, 0)
	v_msg_2713 = J.arg(a, 1)
	if J.t(J.gp(v_u_2712, "open")):
		return null
	J.sp(v_u_2712, "open", true)
	var _t2829 = env["float"]
	J.cl(_t2829, null, [J.gp(v_u_2712, "x"), J.sub(J.gp(v_u_2712, "y"), 90.0), v_msg_2713, "#9fd6bf"])
	var _t2830 = J.gp(env["G"], "wardFx")
	J.mc(_t2830, "push", [{"x": J.gp(v_u_2712, "x"), "y": J.gp(v_u_2712, "y"), "t": 0.9}])
	J.sp(v_u_2712, "unlockFx", 1.2)

func _f436(this_, a: Array, env):
	var v_lv_2716 = null; var v_fr_2717 = null; var v_m_2718 = null; var v_real_2719 = null; var v_k_2720 = null; var v_d_2721 = null
	v_lv_2716 = (3.0 if J.cmp(J.gp(env["G"], "alert"), 10.0, ">=") else (2.0 if J.cmp(J.gp(env["G"], "alert"), 6.0, ">=") else (1.0 if J.cmp(J.gp(env["G"], "alert"), 3.0, ">=") else 0.0)))
	while true:
		if not J.cmp(J.gp(env["G"], "alertLv"), v_lv_2716, "<"): break
		var _t2831 = env["G"]
		J.sp(_t2831, "alertLv", J.num(J.gp(_t2831, "alertLv")) + 1.0)
		v_fr_2717 = (1.0 + floor(J.num(J.mul(J.cl(env["rnd"], null, []), J.sub(env["FL"], 1.0)))))
		if J.seq(J.gp(env["G"], "alertLv"), 1.0):
			var _t2832 = J.gp(env["G"], "guards")
			var _t2833 = env["mkHuman"]
			J.mc(_t2832, "push", [J.cl(_t2833, null, ["compass", (J.add("f", v_fr_2717) + "_s")])])
			var _t2834 = env["toast"]
			J.cl(_t2834, null, ["全樓警覺 3：管理處加派「羅盤保安」——每次只嚇得走佢一點膽，靠閂門同繞路避開佢。"])
		if J.seq(J.gp(env["G"], "alertLv"), 2.0):
			var _t2835 = env["mkHuman"]
			v_m_2718 = J.cl(_t2835, null, ["mirror", (J.add("f", v_fr_2717) + "_l")])
			var _t2836 = (-1.0)
			J.sp(v_m_2718, "dir", _t2836)
			var _t2837 = J.gp(env["G"], "guards")
			J.mc(_t2837, "push", [v_m_2718])
			var _t2838 = env["toast"]
			J.cl(_t2838, null, ["全樓警覺 6：「鏡子道士」到——唔好正面對住佢面鏡，要兜去佢背後先嚇得到。"])
		if J.seq(J.gp(env["G"], "alertLv"), 3.0):
			var _t2839 = env["G"]
			J.sp(_t2839, "taoWant", true)
			v_real_2719 = floor(J.num(J.mul(J.cl(env["rnd"], null, []), 3.0)))
			v_k_2720 = 0.0
			while true:
				if not J.cmp(v_k_2720, 3.0, "<"): break
				var _t2840 = env["mkHuman"]
				v_d_2721 = J.cl(_t2840, null, ["decoy", (J.add((J.add("f", v_fr_2717) + "_d"), v_k_2720) if J.has(J.gp(env["G"], "nodes"), J.add((J.add("f", v_fr_2717) + "_d"), v_k_2720)) else (J.add("f", v_fr_2717) + "_s")), {"real": J.seq(v_k_2720, v_real_2719)}])
				var _t2841 = J.gp(env["G"], "guards")
				J.mc(_t2841, "push", [v_d_2721])
				v_k_2720 = J.num(v_k_2720) + 1.0
			var _t2842 = env["toast"]
			J.cl(_t2842, null, ["全樓警覺 10：天師同「紙人替身陣」上樓——三個道士得一個係真身，試下嚇邊個。"])
		var _t2843 = env["G"]
		J.sp(_t2843, "shake", 0.4)

func _f437(this_, a: Array, env):
	var v_n_2724 = null; var v_k_2725 = null; var v_m_2726 = null
	v_n_2724 = J.gp(J.gp(env["G"], "nodes"), "f0_e")
	env["SAFE"] = null
	if (not J.t(v_n_2724)):
		return null
	var _t2844 = {"node": "f0_e", "x": J.gp(v_n_2724, "x"), "y": J.gp(v_n_2724, "y"), "f": J.gp(v_n_2724, "f"), "r": env["SAFE_R"], "nodes": {}, "a": 1.0, "was": true}
	env["SAFE"] = _t2844
	for _t2845 in J.keys(J.gp(env["G"], "nodes")):
		v_k_2725 = _t2845
		v_m_2726 = J.gp(J.gp(env["G"], "nodes"), v_k_2725)
		var _t2846 = J.seq(J.gp(v_m_2726, "f"), J.gp(v_n_2724, "f"))
		if (J.cmp(absf(J.num(J.sub(J.gp(v_m_2726, "x"), J.gp(v_n_2724, "x")))), env["SAFE_R"], "<=") if _t2846 else _t2846):
			var _t2847 = J.gp(env["SAFE"], "nodes")
			J.sp(_t2847, v_k_2725, 1.0)

func _f438(this_, a: Array, env):
	var _t2849 = (env["SAFE"] if J.t(env["G"]) else env["G"])
	if J.t(_t2849):
		var _t2848 = J.gp(env["G"], "gate")
		_t2849 = (not J.t((J.seq(J.gp(J.gp(env["G"], "gate"), "node"), J.gp(env["SAFE"], "node")) if J.t(_t2848) else _t2848)))
	return (not (not J.t(_t2849)))

func _f439(this_, a: Array, env):
	var v_x_2731 = null; var v_y_2732 = null
	v_x_2731 = J.arg(a, 0)
	v_y_2732 = J.arg(a, 1)
	var _t2850 = J.cl(env["safeOn"], null, [])
	var _t2851 = ((absf(J.num(J.sub(v_y_2732, J.gp(env["SAFE"], "y")))) < 30.0) if J.t(_t2850) else _t2850)
	return (J.cmp(absf(J.num(J.sub(v_x_2731, J.gp(env["SAFE"], "x")))), J.gp(env["SAFE"], "r"), "<=") if J.t(_t2851) else _t2851)

func _f440(this_, a: Array, env):
	var v_g_2735 = null
	v_g_2735 = J.arg(a, 0)
	var _t2852 = (not J.t(v_g_2735))
	var _t2853 = (_t2852 if _t2852 else J.gp(v_g_2735, "home"))
	if J.t((_t2853 if J.t(_t2853) else J.gp(v_g_2735, "out"))):
		return false
	var _t2854 = env["inSafeXY"]
	if J.t(J.cl(_t2854, null, [J.gp(v_g_2735, "x"), J.gp(v_g_2735, "y")])):
		var _t2855 = J.gp(env["G"], "t")
		J.sp(v_g_2735, "_sgT", _t2855)
		return true
	var _t2856 = J.cl(env["safeOn"], null, [])
	var _t2857 = ((not J.leq(J.gp(v_g_2735, "_sgT"), null)) if J.t(_t2856) else _t2856)
	var _t2858 = ((J.sub(J.gp(env["G"], "t"), J.gp(v_g_2735, "_sgT")) < 2.0) if J.t(_t2857) else _t2857)
	var _t2859 = ((absf(J.num(J.sub(J.gp(v_g_2735, "y"), J.gp(env["SAFE"], "y")))) < 30.0) if J.t(_t2858) else _t2858)
	return (J.cmp(absf(J.num(J.sub(J.gp(v_g_2735, "x"), J.gp(env["SAFE"], "x")))), J.add(J.gp(env["SAFE"], "r"), 110.0), "<=") if J.t(_t2859) else _t2859)

func _f441(this_, a: Array, env):
	var v_id_2738 = null
	v_id_2738 = J.arg(a, 0)
	var _t2860 = J.cl(env["safeOn"], null, [])
	return ((not (not J.t(J.gp(J.gp(env["SAFE"], "nodes"), v_id_2738)))) if J.t(_t2860) else _t2860)

func _f442(this_, a: Array, env):
	var v_h_2741 = null
	v_h_2741 = J.arg(a, 0)
	var _t2861 = (not (not J.t(env["SAFE"])))
	var _t2862 = ((absf(J.num(J.sub(J.gp(v_h_2741, "y"), J.gp(env["SAFE"], "y")))) < 200.0) if _t2861 else _t2861)
	return (J.cmp(absf(J.num(J.sub(J.gp(v_h_2741, "x"), J.gp(env["SAFE"], "x")))), J.add(J.gp(env["SAFE"], "r"), 340.0), "<") if _t2862 else _t2862)

func _f444(this_, a: Array, env):
	var v_g_2749 = null; var v_d_2750 = null
	v_g_2749 = J.arg(a, 0)
	var _t2864 = J.gp(v_g_2749, "home")
	var _t2865 = (_t2864 if J.t(_t2864) else J.gp(v_g_2749, "out"))
	if J.t((_t2865 if J.t(_t2865) else J.cmp(J.gp(v_g_2749, "inv"), 0.0, ">"))):
		return null
	v_d_2750 = (absf(J.num(J.sub(J.gp(v_g_2749, "x"), J.gp(env["h"], "x")))) + (absf(J.num(J.sub(J.gp(v_g_2749, "y"), J.gp(env["h"], "y")))) * 1.5))
	if J.cmp(v_d_2750, env["bd"], "<"):
		env["bd"] = v_d_2750
		env["best"] = v_g_2749

func _f443(this_, a: Array, env):
	var _s1034 = {"__p": env, "h": null, "best": null, "bd": null}
	_s1034["h"] = J.arg(a, 0)
	_s1034["best"] = null
	_s1034["bd"] = 1000000000.0
	var _t2863 = J.gp(_s1034["__p"]["G"], "gh")
	J.mc(_t2863, "forEach", [Callable(self, "_f444").bind(_s1034)])
	return _s1034["best"]

func _f445(this_, a: Array, env):
	var v_h_2753 = null; var v_best_2754 = null; var v_bd_2755 = null; var v_k_2756 = null; var v_n_2757 = null; var v_d_2758 = null
	v_h_2753 = J.arg(a, 0)
	v_best_2754 = null
	v_bd_2755 = 1000000000.0
	for _t2866 in J.keys(J.gp(env["G"], "nodes")):
		v_k_2756 = _t2866
		v_n_2757 = J.gp(J.gp(env["G"], "nodes"), v_k_2756)
		var _t2868 = J.seq(J.gp(v_n_2757, "kind"), "in")
		if not J.t(_t2868):
			var _t2867 = env["safeNode"]
			_t2868 = J.cl(_t2867, null, [v_k_2756])
		if J.t(_t2868):
			continue
		v_d_2758 = (absf(J.num(J.sub(J.gp(v_n_2757, "x"), J.gp(v_h_2753, "x")))) + (absf(J.num(J.sub(J.gp(v_n_2757, "y"), J.gp(v_h_2753, "y")))) * 3.0))
		if J.cmp(v_d_2758, v_bd_2755, "<"):
			v_bd_2755 = v_d_2758
			v_best_2754 = v_k_2756
	return v_best_2754

func _f447(this_, a: Array, env):
	var v_t_2767 = null
	v_t_2767 = J.arg(a, 0)
	return ((not J.t(J.gp(env["U"], v_t_2767))) if J.t(v_t_2767) else v_t_2767)

func _f446(this_, a: Array, env):
	var v_pool_2761 = null; var v_free_2763 = null; var v_t_2764 = null
	var _s1041 = {"__p": env, "U": null}
	v_pool_2761 = J.arg(a, 0)
	var _t2871 = J.gp(_s1041["__p"]["G"], "_uq")
	if not J.t(_t2871):
		var _t2869 = _s1041["__p"]["G"]
		var _t2870 = {}
		J.sp(_t2869, "_uq", _t2870)
		_t2871 = _t2870
	_s1041["U"] = _t2871
	v_free_2763 = J.mc(v_pool_2761, "filter", [Callable(self, "_f447").bind(_s1041)])
	if (not J.t(J.len(v_free_2763))):
		return null
	v_t_2764 = J.gp(v_free_2763, floor(J.num((randf() * J.len(v_free_2763)))))
	var _t2872 = _s1041["U"]
	J.sp(_t2872, v_t_2764, 1.0)
	return v_t_2764

func _f448(this_, a: Array, env):
	var v_o_2770 = null; var v_t_2771 = null
	v_o_2770 = J.arg(a, 0)
	var _t2873 = env["uniq"]
	v_t_2771 = J.cl(_t2873, null, [env["SCREAM"]])
	var _t2874 = ({"t": v_t_2771, "T": 1.9} if J.t(v_t_2771) else null)
	J.sp(v_o_2770, "scream", _t2874)
	if J.t(v_t_2771):
		J.sp(v_o_2770, "say", null)
		J.sp(v_o_2770, "sayT", 0.0)

func _f449(this_, a: Array, env):
	var v_h_2774 = null; var v_talk_2775 = null; var v_t_2776 = null
	v_h_2774 = J.arg(a, 0)
	v_talk_2775 = J.arg(a, 1)
	J.sp(v_h_2774, "state", "balk")
	J.sp(v_h_2774, "balkT", 2.6)
	J.sp(v_h_2774, "balkTurn", 0.0)
	J.sp(v_h_2774, "path", null)
	J.sp(v_h_2774, "lostT", 0.0)
	J.sp(v_h_2774, "alertT", 0.0)
	var _t2875 = (1.0 if J.t((J.cmp(J.gp(env["SAFE"], "x"), J.gp(v_h_2774, "x"), ">") if J.t(env["SAFE"]) else env["SAFE"])) else (-1.0))
	J.sp(v_h_2774, "dir", _t2875)
	if J.t(v_talk_2775):
		var _t2876 = env["uniq"]
		v_t_2776 = J.cl(_t2876, null, [env["BALKL"]])
		if J.t(v_t_2776):
			J.sp(v_h_2774, "say", v_t_2776)
			J.sp(v_h_2774, "sayT", 2.6)

func _f450(this_, a: Array, env):
	var v_r_2779 = null; var v_amp_2780 = null; var v_H_2781 = null; var v_k_2782 = null
	v_r_2779 = J.arg(a, 0)
	v_amp_2780 = J.arg(a, 1)
	J.sp(v_r_2779, "shockT", 0.9)
	J.sp(v_r_2779, "shockA", v_amp_2780)
	var _t2877 = J.gp(v_r_2779, "shockN")
	var _t2878 = J.add((_t2877 if J.t(_t2877) else 0.0), 1.0)
	J.sp(v_r_2779, "shockN", _t2878)
	var _t2879 = J.gp(v_r_2779, "h")
	v_H_2781 = J.mul((_t2879 if J.t(_t2879) else 66.0), 1.12)
	v_k_2782 = 0.0
	while true:
		if not J.cmp(v_k_2782, (5.0 if J.cmp(v_amp_2780, 1.0, ">=") else 3.0), "<"): break
		var _t2880 = env["part"]
		J.cl(_t2880, null, [J.add(J.gp(v_r_2779, "x"), ((randf() - 0.5) * 24.0)), J.sub(J.gp(v_r_2779, "y"), J.mul(v_H_2781, 0.82)), ((randf() - 0.5) * 150.0), ((-90.0) - (randf() * 70.0)), 0.75, ("tear" if J.t(J.mod(v_k_2782, 2.0)) else "sweat")])
		v_k_2782 = J.num(v_k_2782) + 1.0
	var _t2881 = J.cmp(v_amp_2780, 1.0, ">=")
	var _t2882 = ((not J.t(J.gp(v_r_2779, "dropped"))) if _t2881 else _t2881)
	var _t2883 = (J.seq(J.gp(v_r_2779, "state"), "home") if _t2882 else _t2882)
	var _t2884 = ((not J.t(J.mc(env["PPLFX"], "hasScared", [J.gp(v_r_2779, "sprite")]))) if _t2883 else _t2883)
	if J.t((J.gp(env["DROPK"], J.gp(v_r_2779, "hh")) if _t2884 else _t2884)):
		J.sp(v_r_2779, "dropped", 1.0)
		var _t2887 = J.gp(env["G"], "pdrops")
		if not J.t(_t2887):
			var _t2885 = env["G"]
			var _t2886 = []
			J.sp(_t2885, "pdrops", _t2886)
			_t2887 = _t2886
		J.mc(_t2887, "push", [{"k": J.gp(env["DROPK"], J.gp(v_r_2779, "hh")), "x": J.add(J.gp(v_r_2779, "x"), ((-10.0) if J.cmp(J.gp(v_r_2779, "vx"), 0.0, "<") else 10.0)), "y": J.sub(J.gp(v_r_2779, "y"), J.mul(v_H_2781, 0.5)), "fy": J.gp(v_r_2779, "y"), "vx": (((-1.0) if (randf() < 0.5) else 1.0) * (40.0 + (randf() * 50.0))), "vy": (-140.0), "rot": 0.0, "vr": ((randf() - 0.5) * 14.0), "life": 3.2}])

func _f451(this_, a: Array, env):
	var v_r_2785 = null; var v_dt_2786 = null
	v_r_2785 = J.arg(a, 0)
	v_dt_2786 = J.arg(a, 1)
	var _t2888 = J.gp(v_r_2785, "jumpT")
	var _t2890 = (_t2888 if J.t(_t2888) else 0.0)
	var _t2889 = J.gp(v_r_2785, "_pj")
	if J.cmp(_t2890, J.add((_t2889 if J.t(_t2889) else 0.0), 0.001), ">"):
		var _t2891 = env["startShock"]
		J.cl(_t2891, null, [v_r_2785, (1.0 if J.cmp(J.gp(v_r_2785, "jumpT"), 0.5, ">=") else 0.65)])
	var _t2892 = J.gp(v_r_2785, "shockT")
	var _t2893 = J.gp(v_r_2785, "shockT")
	var _t2894 = J.max_([0.0, J.sub((_t2893 if J.t(_t2893) else 0.0), v_dt_2786)])
	J.sp(v_r_2785, "shockT", _t2894)
	if J.t(J.gp(v_r_2785, "scream")):
		var _t2895 = J.gp(v_r_2785, "scream")
		var _t2896 = J.sub(J.gp(_t2895, "T"), v_dt_2786)
		J.sp(_t2895, "T", _t2896)
		if J.cmp(J.gp(J.gp(v_r_2785, "scream"), "T"), 0.0, "<="):
			J.sp(v_r_2785, "scream", null)
	var _t2897 = J.seq(J.gp(v_r_2785, "state"), "home")
	var _t2899 = (J.gp(v_r_2785, "awake") if _t2897 else _t2897)
	if J.t(_t2899):
		var _t2898 = J.gp(v_r_2785, "fear")
		_t2899 = J.cmp((_t2898 if J.t(_t2898) else 0.0), 55.0, ">=")
	if J.t(((randf() < J.mul(v_dt_2786, 1.1)) if J.t(_t2899) else _t2899)):
		var _t2900 = env["part"]
		var _t2903 = J.add(J.gp(v_r_2785, "x"), ((-12.0) if (randf() < 0.5) else 12.0))
		var _t2902 = J.gp(v_r_2785, "y")
		var _t2901 = J.gp(v_r_2785, "h")
		J.cl(_t2900, null, [_t2903, J.sub(_t2902, J.mul((_t2901 if J.t(_t2901) else 66.0), 0.95)), ((randf() - 0.5) * 30.0), (-20.0), 0.6, "sweat"])

func _f453(this_, a: Array, env):
	var v_d_2793 = null
	v_d_2793 = J.arg(a, 0)
	var _t2906 = J.sub(J.gp(v_d_2793, "life"), env["dt"])
	J.sp(v_d_2793, "life", _t2906)
	var _t2907 = J.add(J.gp(v_d_2793, "vy"), J.mul(520.0, env["dt"]))
	J.sp(v_d_2793, "vy", _t2907)
	var _t2908 = J.add(J.gp(v_d_2793, "x"), J.mul(J.gp(v_d_2793, "vx"), env["dt"]))
	J.sp(v_d_2793, "x", _t2908)
	var _t2909 = J.add(J.gp(v_d_2793, "y"), J.mul(J.gp(v_d_2793, "vy"), env["dt"]))
	J.sp(v_d_2793, "y", _t2909)
	var _t2910 = J.add(J.gp(v_d_2793, "rot"), J.mul(J.gp(v_d_2793, "vr"), env["dt"]))
	J.sp(v_d_2793, "rot", _t2910)
	if J.cmp(J.gp(v_d_2793, "y"), J.sub(J.gp(v_d_2793, "fy"), 3.0), ">="):
		var _t2911 = J.sub(J.gp(v_d_2793, "fy"), 3.0)
		J.sp(v_d_2793, "y", _t2911)
		var _t2912 = ((-absf(J.num(J.gp(v_d_2793, "vy")))) * 0.28)
		J.sp(v_d_2793, "vy", _t2912)
		var _t2913 = J.mul(J.gp(v_d_2793, "vx"), 0.55)
		J.sp(v_d_2793, "vx", _t2913)
		var _t2914 = J.mul(J.gp(v_d_2793, "vr"), 0.4)
		J.sp(v_d_2793, "vr", _t2914)
		if (absf(J.num(J.gp(v_d_2793, "vy"))) < 20.0):
			J.sp(v_d_2793, "vy", 0.0)

func _f454(this_, a: Array, env):
	var v_d_2796 = null
	v_d_2796 = J.arg(a, 0)
	return J.cmp(J.gp(v_d_2796, "life"), 0.0, ">")

func _f452(this_, a: Array, env):
	var v_on_2790 = null
	var _s1053 = {"__p": env, "dt": null}
	_s1053["dt"] = J.arg(a, 0)
	var _t2904 = J.gp(_s1053["__p"]["G"], "pdrops")
	var _t2905 = (_t2904 if J.t(_t2904) else [])
	J.mc(_t2905, "forEach", [Callable(self, "_f453").bind(_s1053)])
	if J.t(J.gp(_s1053["__p"]["G"], "pdrops")):
		var _t2915 = _s1053["__p"]["G"]
		var _t2916 = J.gp(_s1053["__p"]["G"], "pdrops")
		var _t2917 = J.mc(_t2916, "filter", [Callable(self, "_f454").bind(_s1053)])
		J.sp(_t2915, "pdrops", _t2917)
	if J.t(_s1053["__p"]["SAFE"]):
		v_on_2790 = J.cl(_s1053["__p"]["safeOn"], null, [])
		var _t2918 = J.gp(_s1053["__p"]["SAFE"], "was")
		if J.t(((not J.t(v_on_2790)) if J.t(_t2918) else _t2918)):
			var _t2919 = _s1053["__p"]["float"]
			J.cl(_t2919, null, [J.gp(_s1053["__p"]["SAFE"], "x"), J.sub(J.gp(_s1053["__p"]["SAFE"], "y"), 110.0), "陰門一開，陰氣散晒——保安殺到！", "#d8b8ff"])
		var _t2920 = _s1053["__p"]["SAFE"]
		J.sp(_t2920, "was", v_on_2790)

func _f456(this_, a: Array, env):
	var v_d_2801 = null
	v_d_2801 = J.arg(a, 0)
	J.mc(env["ctx"], "save", [])
	var _t2923 = env["ctx"]
	var _t2924 = J.min_([1.0, J.div(J.gp(v_d_2801, "life"), 0.6)])
	J.sp(_t2923, "globalAlpha", _t2924)
	J.mc(env["ctx"], "translate", [J.gp(v_d_2801, "x"), J.gp(v_d_2801, "y")])
	J.mc(env["ctx"], "rotate", [J.gp(v_d_2801, "rot")])
	var _t2925 = env["ctx"]
	J.sp(_t2925, "lineWidth", 1.5)
	var _t2926 = env["ctx"]
	J.sp(_t2926, "strokeStyle", "#1a1418")
	if J.seq(J.gp(v_d_2801, "k"), "cup"):
		var _t2927 = env["ctx"]
		J.sp(_t2927, "fillStyle", "#e8e2d4")
		J.mc(env["ctx"], "fillRect", [(-4.0), (-5.0), 8.0, 9.0])
		J.mc(env["ctx"], "strokeRect", [(-4.0), (-5.0), 8.0, 9.0])
		J.mc(env["ctx"], "beginPath", [])
		J.mc(env["ctx"], "arc", [5.0, (-1.0), 3.0, (-1.4), 1.4])
		J.mc(env["ctx"], "stroke", [])
	else:
		if J.seq(J.gp(v_d_2801, "k"), "tile"):
			var _t2928 = env["ctx"]
			J.sp(_t2928, "fillStyle", "#f2efe2")
			J.mc(env["ctx"], "fillRect", [(-4.0), (-6.0), 8.0, 11.0])
			J.mc(env["ctx"], "strokeRect", [(-4.0), (-6.0), 8.0, 11.0])
			var _t2929 = env["ctx"]
			J.sp(_t2929, "fillStyle", "#3a8a5a")
			J.mc(env["ctx"], "fillRect", [(-2.0), (-3.0), 4.0, 4.0])
		else:
			if J.seq(J.gp(v_d_2801, "k"), "bowl"):
				var _t2930 = env["ctx"]
				J.sp(_t2930, "fillStyle", "#f0e8d8")
				J.mc(env["ctx"], "beginPath", [])
				J.mc(env["ctx"], "arc", [0.0, (-2.0), 6.0, 0.0, PI])
				J.mc(env["ctx"], "closePath", [])
				J.mc(env["ctx"], "fill", [])
				J.mc(env["ctx"], "stroke", [])
			else:
				if J.seq(J.gp(v_d_2801, "k"), "pad"):
					var _t2931 = env["ctx"]
					J.sp(_t2931, "fillStyle", "#2a2a34")
					J.mc(env["ctx"], "fillRect", [(-7.0), (-3.0), 14.0, 7.0])
					J.mc(env["ctx"], "strokeRect", [(-7.0), (-3.0), 14.0, 7.0])
				else:
					if J.seq(J.gp(v_d_2801, "k"), "fan"):
						var _t2932 = env["ctx"]
						J.sp(_t2932, "fillStyle", "#d8c08a")
						J.mc(env["ctx"], "beginPath", [])
						J.mc(env["ctx"], "moveTo", [0.0, 4.0])
						J.mc(env["ctx"], "arc", [0.0, 4.0, 10.0, (-2.6), (-0.5)])
						J.mc(env["ctx"], "closePath", [])
						J.mc(env["ctx"], "fill", [])
						J.mc(env["ctx"], "stroke", [])
					else:
						var _t2933 = env["ctx"]
						J.sp(_t2933, "fillStyle", "#c89a5a")
						J.mc(env["ctx"], "fillRect", [(-6.0), (-5.0), 12.0, 10.0])
						J.mc(env["ctx"], "strokeRect", [(-6.0), (-5.0), 12.0, 10.0])
	J.mc(env["ctx"], "restore", [])

func _f455(this_, a: Array, env):
	var _t2921 = J.gp(env["G"], "pdrops")
	var _t2922 = (_t2921 if J.t(_t2921) else [])
	J.mc(_t2922, "forEach", [Callable(self, "_f456").bind(env)])

func _f457(this_, a: Array, env):
	var v_on_2804 = null; var v_A0_2805 = null; var v_x_2806 = null; var v_y_2807 = null; var v_R_2808 = null; var v_gr_2809 = null; var v_k_2810 = null; var v_u_2811 = null; var v_px_2812 = null; var v_py_2813 = null
	if (not J.t(env["SAFE"])):
		return null
	v_on_2804 = J.cl(env["safeOn"], null, [])
	var _t2934 = env["SAFE"]
	var _t2935 = J.add(J.gp(_t2934, "a"), (J.sub((1.0 if J.t(v_on_2804) else 0.0), J.gp(env["SAFE"], "a")) * 0.06))
	J.sp(_t2934, "a", _t2935)
	v_A0_2805 = J.gp(env["SAFE"], "a")
	if J.cmp(v_A0_2805, 0.02, "<"):
		return null
	v_x_2806 = J.gp(env["SAFE"], "x")
	v_y_2807 = J.gp(env["SAFE"], "y")
	v_R_2808 = J.gp(env["SAFE"], "r")
	J.mc(env["ctx"], "save", [])
	v_gr_2809 = J.mc(env["ctx"], "createRadialGradient", [v_x_2806, J.sub(v_y_2807, 6.0), 6.0, v_x_2806, J.sub(v_y_2807, 6.0), v_R_2808])
	J.mc(v_gr_2809, "addColorStop", [0.0, (J.add("rgba(150,95,205,", J.mul(0.24, v_A0_2805)) + ")")])
	J.mc(v_gr_2809, "addColorStop", [0.65, (J.add("rgba(125,75,185,", J.mul(0.11, v_A0_2805)) + ")")])
	J.mc(v_gr_2809, "addColorStop", [1.0, "rgba(110,60,170,0)"])
	var _t2936 = env["ctx"]
	J.sp(_t2936, "fillStyle", v_gr_2809)
	J.mc(env["ctx"], "beginPath", [])
	J.mc(env["ctx"], "ellipse", [v_x_2806, J.sub(v_y_2807, 5.0), v_R_2808, 20.0, 0.0, 0.0, 7.0])
	J.mc(env["ctx"], "fill", [])
	v_k_2810 = 0.0
	while true:
		if not J.cmp(v_k_2810, 7.0, "<"): break
		v_u_2811 = J.div(J.mod((J.mul(J.gp(env["G"], "t"), 8.0) + J.mul(v_k_2810, 13.0)), 46.0), 46.0)
		v_px_2812 = J.add(v_x_2806, (J.mul(sin(J.num((J.mul(J.gp(env["G"], "t"), 0.45) + J.mul(v_k_2810, 2.1)))), v_R_2808) * 0.78))
		v_py_2813 = (J.sub(v_y_2807, 8.0) - J.mul(v_u_2811, 46.0))
		var _t2937 = env["ctx"]
		var _t2938 = (J.add("rgba(190,150,235,", J.mul((J.sub(1.0, v_u_2811) * 0.15), v_A0_2805)) + ")")
		J.sp(_t2937, "fillStyle", _t2938)
		J.mc(env["ctx"], "beginPath", [])
		J.mc(env["ctx"], "ellipse", [v_px_2812, v_py_2813, (18.0 + (J.mod(v_k_2810, 3.0) * 7.0)), 4.5, 0.0, 0.0, 7.0])
		J.mc(env["ctx"], "fill", [])
		v_k_2810 = J.num(v_k_2810) + 1.0
	var _t2939 = env["ctx"]
	var _t2940 = (J.add("rgba(195,160,240,", J.mul(0.2, v_A0_2805)) + ")")
	J.sp(_t2939, "strokeStyle", _t2940)
	J.mc(env["ctx"], "setLineDash", [[5.0, 7.0]])
	var _t2941 = env["ctx"]
	J.sp(_t2941, "lineWidth", 1.5)
	J.mc(env["ctx"], "beginPath", [])
	J.mc(env["ctx"], "ellipse", [v_x_2806, J.sub(v_y_2807, 5.0), v_R_2808, 13.0, 0.0, 0.08, (PI - 0.08)])
	J.mc(env["ctx"], "stroke", [])
	J.mc(env["ctx"], "setLineDash", [[]])
	var _t2942 = env["ctx"]
	var _t2943 = J.mul(0.5, v_A0_2805)
	J.sp(_t2942, "globalAlpha", _t2943)
	var _t2944 = env["ctx"]
	var _t2945 = J.add("bold 10px ", env["FONT"])
	J.sp(_t2944, "font", _t2945)
	var _t2946 = env["ctx"]
	J.sp(_t2946, "textAlign", "center")
	var _t2947 = env["ctx"]
	J.sp(_t2947, "lineWidth", 3.0)
	var _t2948 = env["ctx"]
	J.sp(_t2948, "strokeStyle", "#120c16")
	J.mc(env["ctx"], "strokeText", ["陰氣地・保安止步", v_x_2806, J.add(v_y_2807, 14.0)])
	var _t2949 = env["ctx"]
	J.sp(_t2949, "fillStyle", "#d6c0f2")
	J.mc(env["ctx"], "fillText", ["陰氣地・保安止步", v_x_2806, J.add(v_y_2807, 14.0)])
	J.mc(env["ctx"], "restore", [])

func _f475(this_, a: Array, env):
	var v_r_2945 = null; var v_viewW_2946 = null; var v_viewH_2947 = null; var v_home_2948 = null; var v_F_2949 = null; var v_flee_2950 = null; var v_scared_2951 = null; var v_k2_2952 = null; var v_H_2953 = null; var v_art_2954 = null; var v_jy_2955 = null; var v_sh_2956 = null; var v_ro_2957 = null; var v_sy_2958 = null; var v_sx_2959 = null; var v_flip_2960 = null; var v_tint_2961 = null; var v_arms_2962 = null; var v_S0_2963 = null; var v_T0_2964 = null; var v_P_2965 = null; var v_by_2966 = null; var v_top_2967 = null
	v_r_2945 = J.arg(a, 0)
	v_viewW_2946 = J.arg(a, 1)
	v_viewH_2947 = J.arg(a, 2)
	var _t2950 = J.seq(J.gp(v_r_2945, "state"), "gone")
	if (_t2950 if _t2950 else J.seq(J.gp(v_r_2945, "state"), "away")):
		return null
	var _t2951 = J.cmp(J.gp(v_r_2945, "x"), J.sub(J.gp(env["cam"], "x"), 60.0), "<")
	var _t2952 = (_t2951 if _t2951 else J.cmp(J.gp(v_r_2945, "x"), J.add(J.add(J.gp(env["cam"], "x"), v_viewW_2946), 60.0), ">"))
	var _t2953 = (_t2952 if _t2952 else J.cmp(J.gp(v_r_2945, "y"), J.sub(J.gp(env["cam"], "y"), 20.0), "<"))
	if (_t2953 if _t2953 else J.cmp(J.gp(v_r_2945, "y"), J.add(J.add(J.gp(env["cam"], "y"), v_viewH_2947), 120.0), ">")):
		return null
	var _t2954 = J.seq(J.gp(v_r_2945, "state"), "leave")
	if (_t2954 if _t2954 else J.seq(J.gp(v_r_2945, "state"), "back")):
		var _t2955 = J.gp(v_r_2945, "vx")
		var _t2956 = (_t2955 if J.t(_t2955) else 1.0)
		J.sp(v_r_2945, "vx", _t2956)
	v_home_2948 = J.seq(J.gp(v_r_2945, "state"), "home")
	var _t2957 = J.gp(v_r_2945, "fear")
	v_F_2949 = (_t2957 if J.t(_t2957) else 0.0)
	v_flee_2950 = J.seq(J.gp(v_r_2945, "state"), "flee")
	var _t2958 = J.cmp(J.gp(v_r_2945, "shockT"), 0.0, ">")
	v_scared_2951 = (_t2958 if _t2958 else v_flee_2950)
	v_k2_2952 = J.mc(env["PPLFX"], "key", [J.gp(v_r_2945, "sprite"), v_scared_2951])
	var _t2960 = J.gp(v_r_2945, "sprite")
	var _t2959 = J.gp(v_r_2945, "h")
	v_H_2953 = J.mc(env["PPLFX"], "hgt", [_t2960, v_k2_2952, (_t2959 if J.t(_t2959) else 58.0)])
	v_art_2954 = (not J.seq(v_k2_2952, J.gp(v_r_2945, "sprite")))
	var _t2961 = env["ctx"]
	J.sp(_t2961, "fillStyle", "rgba(0,0,0,0.45)")
	J.mc(env["ctx"], "beginPath", [])
	J.mc(env["ctx"], "ellipse", [J.gp(v_r_2945, "x"), J.sub(J.gp(v_r_2945, "y"), 1.0), (20.0 if J.t(J.mc(env["PPLFX"], "chibi", [J.gp(v_r_2945, "sprite")])) else 16.0), 4.0, 0.0, 0.0, 7.0])
	J.mc(env["ctx"], "fill", [])
	v_jy_2955 = 0.0
	v_sh_2956 = 0.0
	v_ro_2957 = 0.0
	v_sy_2958 = 1.0
	v_sx_2959 = 1.0
	v_flip_2960 = J.cmp(J.gp(v_r_2945, "vx"), 0.0, "<")
	v_tint_2961 = 0.0
	v_arms_2962 = false
	if J.cmp(J.gp(v_r_2945, "shockT"), 0.0, ">"):
		var _t2963 = J.gp(v_r_2945, "shockT")
		var _t2962 = J.gp(v_r_2945, "shockA")
		v_S0_2963 = J.mc(env["PPLFX"], "shock", [_t2963, (_t2962 if J.t(_t2962) else 1.0)])
		v_sx_2959 = J.gp(v_S0_2963, "sx")
		v_sy_2958 = J.gp(v_S0_2963, "sy")
		var _t2964 = J.mul(J.gp(v_S0_2963, "jy"), v_H_2953)
		v_jy_2955 = _t2964
		var _t2965 = J.mul(J.gp(v_S0_2963, "sh"), v_H_2953)
		v_sh_2956 = _t2965
		var _t2966 = J.mul(J.gp(v_S0_2963, "tint"), (0.18 if J.t(v_art_2954) else 0.7))
		v_tint_2961 = _t2966
	else:
		var _t2967 = (J.gp(v_r_2945, "awake") if J.t(v_home_2948) else v_home_2948)
		if J.t((J.cmp(v_F_2949, 55.0, ">=") if J.t(_t2967) else _t2967)):
			v_T0_2964 = J.mc(env["PPLFX"], "tremble", [v_r_2945, J.gp(env["G"], "t")])
			var _t2968 = J.mul(J.gp(v_T0_2964, "sh"), v_H_2953)
			v_sh_2956 = _t2968
			v_sy_2958 = J.gp(v_T0_2964, "sy")
			if (not J.leq(J.gp(v_T0_2964, "flip"), null)):
				v_flip_2960 = J.gp(v_T0_2964, "flip")
			v_tint_2961 = J.gp(v_T0_2964, "tint")
		else:
			if J.t((J.cmp(v_F_2949, 60.0, ">") if J.t(v_home_2948) else v_home_2948)):
				var _t2969 = (sin(J.num(J.mul(J.gp(env["G"], "t"), 40.0))) * 1.6)
				v_sh_2956 = _t2969
	if J.t(v_flee_2950):
		if J.cmp(J.gp(v_r_2945, "tripT"), 0.0, ">"):
			var _t2970 = ((1.0 if J.cmp(J.gp(v_r_2945, "vx"), 0.0, ">") else (-1.0)) * 1.25)
			v_ro_2957 = _t2970
			v_jy_2955 = (-6.0)
		else:
			var _t2971 = ((-absf(J.num(sin(J.num(J.mul(J.gp(v_r_2945, "x"), 0.12)))))) * 7.0)
			v_jy_2955 = _t2971
			var _t2972 = ((1.0 if J.cmp(J.gp(v_r_2945, "vx"), 0.0, ">") else (-1.0)) * 0.18)
			v_ro_2957 = _t2972
			v_arms_2962 = (not J.t(v_art_2954))
		var _t2973 = J.max_([v_tint_2961, (0.0 if J.t(v_art_2954) else 0.15)])
		v_tint_2961 = _t2973
	if J.cmp(J.gp(v_r_2945, "tangle"), 0.0, ">"):
		var _t2974 = J.add(v_sh_2956, (sin(J.num(J.mul(J.gp(env["G"], "t"), 30.0))) * 2.0))
		v_sh_2956 = _t2974
		var _t2975 = J.mul(v_sy_2958, 0.96)
		v_sy_2958 = _t2975
	var _t2976 = J.seq(J.gp(v_r_2945, "state"), "leave")
	if (_t2976 if _t2976 else J.seq(J.gp(v_r_2945, "state"), "back")):
		var _t2977 = ((-absf(J.num(sin(J.num(J.mul(J.gp(v_r_2945, "x"), 0.2)))))) * 3.0)
		v_jy_2955 = _t2977
	var _t2978 = ((not J.t(J.gp(v_r_2945, "awake"))) if J.t(v_home_2948) else v_home_2948)
	if J.t(((not J.t(J.gp(v_r_2945, "react"))) if J.t(_t2978) else _t2978)):
		v_ro_2957 = (-1.45)
		v_jy_2955 = (-8.0)
		var _t2979 = env["ctx"]
		J.sp(_t2979, "fillStyle", "rgba(200,220,255,0.8)")
		var _t2980 = env["ctx"]
		var _t2981 = J.add("bold 12px ", env["FONT"])
		J.sp(_t2980, "font", _t2981)
		var _t2982 = env["ctx"]
		J.sp(_t2982, "textAlign", "center")
		J.mc(env["ctx"], "fillText", ["Z", J.add(J.gp(v_r_2945, "x"), 18.0), (J.sub(J.gp(v_r_2945, "y"), 30.0) - J.mod(J.mul(J.gp(env["G"], "t"), 12.0), 10.0))])
		var _t2983 = env["ctx"]
		var _t2984 = J.add("bold 9px ", env["FONT"])
		J.sp(_t2983, "font", _t2984)
		J.mc(env["ctx"], "fillText", ["z", J.add(J.gp(v_r_2945, "x"), 26.0), (J.sub(J.gp(v_r_2945, "y"), 40.0) - J.mod((J.mul(J.gp(env["G"], "t"), 12.0) + 5.0), 10.0))])
	v_P_2965 = {"sh": 0.0, "jy": 0.0, "ro": 0.0, "sy": 1.0}
	var _t2985 = env["reactPose"]
	J.cl(_t2985, null, [v_r_2945, v_P_2965])
	var _t2986 = J.add(v_sh_2956, J.gp(v_P_2965, "sh"))
	v_sh_2956 = _t2986
	var _t2987 = J.add(v_jy_2955, J.gp(v_P_2965, "jy"))
	v_jy_2955 = _t2987
	var _t2988 = J.add(v_ro_2957, J.gp(v_P_2965, "ro"))
	v_ro_2957 = _t2988
	var _t2989 = J.mul(v_sy_2958, J.gp(v_P_2965, "sy"))
	v_sy_2958 = _t2989
	var _t2991 = J.add(J.gp(v_r_2945, "y"), v_jy_2955)
	var _t2990 = J.gp(v_r_2945, "dy")
	v_by_2966 = J.add(_t2991, (_t2990 if J.t(_t2990) else 0.0))
	if J.t(v_arms_2962):
		J.mc(env["PPLFX"], "arms", [env["ctx"], J.add(J.gp(v_r_2945, "x"), v_sh_2956), v_by_2966, v_H_2953, (1.0 if J.cmp(J.gp(v_r_2945, "vx"), 0.0, ">") else (-1.0)), J.gp(env["G"], "t")])
	var _t2992 = env["ctx"]
	J.sp(_t2992, "shadowColor", "rgba(255,236,200,0.75)")
	var _t2993 = env["ctx"]
	J.sp(_t2993, "shadowBlur", 5.0)
	J.mc(env["PPLFX"], "draw", [env["ctx"], J.gp(v_r_2945, "sprite"), v_k2_2952, J.add(J.gp(v_r_2945, "x"), v_sh_2956), v_by_2966, v_H_2953, {"flip": v_flip_2960, "rot": v_ro_2957, "sx": v_sx_2959, "sy": v_sy_2958, "tint": v_tint_2961}])
	var _t2994 = env["ctx"]
	J.sp(_t2994, "shadowBlur", 0.0)
	var _t2995 = env["reactProps"]
	J.cl(_t2995, null, [v_r_2945, v_P_2965])
	v_top_2967 = J.sub(v_by_2966, J.mul(v_H_2953, J.min_([1.0, v_sy_2958])))
	if J.cmp(J.gp(v_r_2945, "shockT"), 0.0, ">"):
		J.mc(env["PPLFX"], "bang", [env["ctx"], J.add(J.add(J.gp(v_r_2945, "x"), v_sh_2956), (0.0 if J.t(v_art_2954) else 4.0)), J.sub(v_top_2967, 8.0), (1.0 - J.div(J.gp(v_r_2945, "shockT"), 0.9)), 0.9])
	else:
		if J.t(((not J.t(J.gp(v_r_2945, "tripT"))) if J.t(v_flee_2950) else v_flee_2950)):
			J.mc(env["PPLFX"], "bang", [env["ctx"], J.gp(v_r_2945, "x"), J.sub(v_top_2967, 6.0), 0.5, 0.7])
	if J.t((J.cmp(v_F_2949, 0.0, ">") if J.t(v_home_2948) else v_home_2948)):
		var _t2996 = env["crBar"]
		J.cl(_t2996, null, [env["ctx"], J.sub(J.gp(v_r_2945, "x"), 20.0), J.sub(v_top_2967, 10.0), 40.0, 7.0, J.div(v_F_2949, 100.0), "red"])
	if J.t(J.gp(v_r_2945, "scream")):
		J.mc(env["PPLFX"], "scream", [env["ctx"], J.gp(v_r_2945, "x"), J.sub(v_top_2967, 16.0), J.gp(v_r_2945, "scream"), 1.0])
	if J.t(J.gp(v_r_2945, "say")):
		var _t2997 = env["bubble"]
		J.cl(_t2997, null, [J.gp(v_r_2945, "x"), (J.sub(v_top_2967, 12.0) - (6.0 if J.t((J.cmp(v_F_2949, 0.0, ">") if J.t(v_home_2948) else v_home_2948)) else 0.0)), J.gp(v_r_2945, "say")])

func _f476(this_, a: Array, env):
	var v_s_2970 = null; var v_d_2971 = null; var v_run_2972 = null
	v_s_2970 = J.arg(a, 0)
	v_d_2971 = (0.0 if J.leq(J.gp(v_s_2970, "_lx"), null) else J.hypot_([J.sub(J.gp(v_s_2970, "x"), J.gp(v_s_2970, "_lx")), J.sub(J.gp(v_s_2970, "y"), J.gp(v_s_2970, "_ly"))]))
	var _t2998 = J.gp(v_s_2970, "x")
	J.sp(v_s_2970, "_lx", _t2998)
	var _t2999 = J.gp(v_s_2970, "y")
	J.sp(v_s_2970, "_ly", _t2999)
	if J.cmp(v_d_2971, 40.0, ">"):
		v_d_2971 = 0.0
	var _t3002 = J.seq(J.gp(v_s_2970, "state"), "flee")
	if not J.t(_t3002):
		var _t3001 = J.seq(J.gp(v_s_2970, "state"), "scared")
		if J.t(_t3001):
			var _t3000 = J.gp(v_s_2970, "scT")
			_t3001 = J.cmp((_t3000 if J.t(_t3000) else 0.0), 1.7, "<")
		_t3002 = _t3001
	v_run_2972 = _t3002
	var _t3003 = J.gp(v_s_2970, "stepPh")
	var _t3004 = J.add((_t3003 if J.t(_t3003) else 0.0), J.div(J.mul(v_d_2971, PI), (26.0 if J.t(v_run_2972) else 17.0)))
	J.sp(v_s_2970, "stepPh", _t3004)
	if J.cmp(v_d_2971, 0.05, ">"):
		J.sp(v_s_2970, "mvT", 0.15)
	else:
		var _t3005 = J.gp(v_s_2970, "mvT")
		var _t3006 = J.gp(v_s_2970, "mvT")
		var _t3007 = J.max_([0.0, J.sub((_t3006 if J.t(_t3006) else 0.0), J.div(1.0, 60.0))])
		J.sp(v_s_2970, "mvT", _t3007)
	if J.cmp(J.gp(v_s_2970, "mvT"), 0.0, ">"):
		var _t3008 = (sin(J.num(J.gp(v_s_2970, "stepPh"))) * 0.035)
		J.sp(v_s_2970, "_sway", _t3008)
		return ((-absf(J.num(sin(J.num(J.gp(v_s_2970, "stepPh")))))) * (4.0 if J.t(v_run_2972) else 2.4))
	J.sp(v_s_2970, "_sway", 0.0)
	return ((sin(J.num(J.add(J.mul(J.gp(env["G"], "t"), 1.8), J.gp(v_s_2970, "x")))) * 0.6) - 0.6)

func _f477(this_, a: Array, env):
	var v_s_2975 = null; var v_H_2976 = null; var v_bob_2977 = null; var v_fl_2978 = null; var v_scared_2979 = null; var v_k2_2980 = null; var v_HH_2981 = null; var v_art_2982 = null; var v_sx_2983 = null; var v_sy_2984 = null; var v_jy_2985 = null; var v_sh_2986 = null; var v_ro_2987 = null; var v_tint_2988 = null; var v_S0_2989 = null; var v_top_2990 = null
	v_s_2975 = J.arg(a, 0)
	v_H_2976 = J.arg(a, 1)
	v_bob_2977 = J.arg(a, 2)
	v_fl_2978 = J.arg(a, 3)
	var _t3009 = J.cmp(J.gp(v_s_2975, "shockT"), 0.0, ">")
	var _t3010 = (_t3009 if _t3009 else J.seq(J.gp(v_s_2975, "state"), "scared"))
	v_scared_2979 = (_t3010 if _t3010 else J.seq(J.gp(v_s_2975, "state"), "flee"))
	v_k2_2980 = J.mc(env["PPLFX"], "key", [J.gp(v_H_2976, "spr"), v_scared_2979])
	v_HH_2981 = J.mc(env["PPLFX"], "hgt", [J.gp(v_H_2976, "spr"), v_k2_2980, J.gp(v_H_2976, "h")])
	v_art_2982 = (not J.seq(v_k2_2980, J.gp(v_H_2976, "spr")))
	v_sx_2983 = 1.0
	v_sy_2984 = 1.0
	v_jy_2985 = 0.0
	v_sh_2986 = 0.0
	var _t3011 = J.gp(v_s_2975, "_sway")
	v_ro_2987 = (_t3011 if J.t(_t3011) else 0.0)
	v_tint_2988 = 0.0
	if J.cmp(J.gp(v_s_2975, "shockT"), 0.0, ">"):
		v_S0_2989 = J.mc(env["PPLFX"], "shock", [J.gp(v_s_2975, "shockT"), 1.0])
		v_sx_2983 = J.gp(v_S0_2989, "sx")
		v_sy_2984 = J.gp(v_S0_2989, "sy")
		var _t3012 = J.mul(J.gp(v_S0_2989, "jy"), v_HH_2981)
		v_jy_2985 = _t3012
		var _t3013 = J.mul(J.gp(v_S0_2989, "sh"), v_HH_2981)
		v_sh_2986 = _t3013
		var _t3014 = J.mul(J.gp(v_S0_2989, "tint"), (0.18 if J.t(v_art_2982) else 0.7))
		v_tint_2988 = _t3014
	else:
		if J.seq(J.gp(v_s_2975, "state"), "scared"):
			var _t3015 = (sin(J.num(J.add(J.mul(J.gp(env["G"], "t"), 45.0), J.gp(v_s_2975, "x")))) * 1.3)
			v_sh_2986 = _t3015
			v_sy_2984 = 0.95
			v_tint_2988 = 0.22
	if J.seq(J.gp(v_s_2975, "state"), "flee"):
		var _t3016 = (0.2 if J.cmp(J.gp(v_s_2975, "vx"), 0.0, ">") else (-0.2))
		v_ro_2987 = _t3016
		var _t3017 = J.max_([v_tint_2988, (0.0 if J.t(v_art_2982) else 0.15)])
		v_tint_2988 = _t3017
		if (not J.t(v_art_2982)):
			J.mc(env["PPLFX"], "arms", [env["ctx"], J.gp(v_s_2975, "x"), J.add(J.add(J.gp(v_s_2975, "y"), v_bob_2977), v_jy_2985), v_HH_2981, (1.0 if J.cmp(J.gp(v_s_2975, "vx"), 0.0, ">") else (-1.0)), J.gp(env["G"], "t")])
	J.mc(env["PPLFX"], "draw", [env["ctx"], J.gp(v_H_2976, "spr"), v_k2_2980, J.add(J.gp(v_s_2975, "x"), v_sh_2986), J.add(J.add(J.gp(v_s_2975, "y"), v_bob_2977), v_jy_2985), v_HH_2981, {"flip": v_fl_2978, "alpha": (0.88 if J.seq(J.gp(v_s_2975, "kind"), "decoy") else 1.0), "rot": v_ro_2987, "sx": v_sx_2983, "sy": v_sy_2984, "tint": v_tint_2988}])
	v_top_2990 = J.sub(J.add(J.add(J.gp(v_s_2975, "y"), v_bob_2977), v_jy_2985), J.mul(v_HH_2981, J.min_([1.0, v_sy_2984])))
	if J.cmp(J.gp(v_s_2975, "shockT"), 0.0, ">"):
		J.mc(env["PPLFX"], "bang", [env["ctx"], J.add(J.gp(v_s_2975, "x"), v_sh_2986), J.sub(v_top_2990, 8.0), (1.0 - J.div(J.gp(v_s_2975, "shockT"), 0.9)), 0.9])
	if J.t(J.gp(v_s_2975, "scream")):
		J.mc(env["PPLFX"], "scream", [env["ctx"], J.gp(v_s_2975, "x"), J.sub(v_top_2990, 34.0), J.gp(v_s_2975, "scream"), 1.0])

func _f479(this_, a: Array, env):
	var v_g_2998 = null; var v_d_2999 = null
	v_g_2998 = J.arg(a, 0)
	var _t3019 = J.gp(v_g_2998, "home")
	var _t3020 = (_t3019 if J.t(_t3019) else J.gp(v_g_2998, "out"))
	var _t3022 = (_t3020 if J.t(_t3020) else J.cmp(J.gp(v_g_2998, "inv"), 0.0, ">"))
	if not J.t(_t3022):
		var _t3021 = env["__p"]["inSafe"]
		_t3022 = J.cl(_t3021, null, [v_g_2998])
	if J.t(_t3022):
		return null
	v_d_2999 = (absf(J.num(J.sub(J.gp(v_g_2998, "x"), J.gp(env["h"], "x")))) + (absf(J.num(J.sub(J.gp(v_g_2998, "y"), J.gp(env["h"], "y")))) * 1.5))
	if J.cmp(v_d_2999, env["bd"], "<"):
		env["bd"] = v_d_2999
		env["best"] = v_g_2998

func _f478(this_, a: Array, env):
	var _s1110 = {"__p": env, "h": null, "best": null, "bd": null}
	_s1110["h"] = J.arg(a, 0)
	_s1110["best"] = null
	_s1110["bd"] = 1000000000.0
	var _t3018 = J.gp(_s1110["__p"]["G"], "gh")
	J.mc(_t3018, "forEach", [Callable(self, "_f479").bind(_s1110)])
	return _s1110["best"]

func _f481(this_, a: Array, env):
	var v_l_3031 = null; var v_m_3032 = null
	v_l_3031 = J.arg(a, 0)
	v_m_3032 = J.gp(J.gp(env["__p"]["G"], "nodes"), J.gp(v_l_3031, "to"))
	var _t3214 = (not J.seq(J.gp(v_m_3032, "kind"), "in"))
	var _t3216 = ((not J.seq(J.gp(v_m_3032, "kind"), "portal")) if _t3214 else _t3214)
	if J.t(_t3216):
		var _t3215 = env["__p"]["safeNode"]
		_t3216 = (not J.t(J.cl(_t3215, null, [J.gp(v_l_3031, "to")])))
	var _t3218 = _t3216
	if J.t(_t3218):
		var _t3217 = env["__p"]["humanPass"]
		_t3218 = J.cl(_t3217, null, [env["h"], J.gp(v_l_3031, "e")])
	var _t3223 = _t3218
	if J.t(_t3223):
		var _t3219 = env["__p"]["inZone"]
		var _t3222 = J.cl(_t3219, null, [env["h"], J.gp(v_m_3032, "f")])
		if not J.t(_t3222):
			var _t3220 = env["__p"]["inZone"]
			var _t3221 = (not J.t(J.cl(_t3220, null, [env["h"], J.gp(env["n"], "f")])))
			_t3222 = ((absf(J.num(J.sub(J.gp(v_m_3032, "f"), env["zm"]))) < absf(J.num(J.sub(J.gp(env["n"], "f"), env["zm"])))) if _t3221 else _t3221)
		_t3223 = _t3222
	return _t3223

func _f482(this_, a: Array, env):
	var v_g_3035 = null
	v_g_3035 = J.arg(a, 0)
	var _t3251 = J.gp(v_g_3035, "home")
	var _t3252 = (_t3251 if J.t(_t3251) else J.gp(v_g_3035, "out"))
	var _t3253 = (_t3252 if J.t(_t3252) else J.cmp(J.gp(v_g_3035, "inv"), 0.0, ">"))
	var _t3255 = (_t3253 if J.t(_t3253) else J.cmp(J.gp(v_g_3035, "stun"), 0.0, ">"))
	if not J.t(_t3255):
		var _t3254 = J.gp(env["h"], "catchCd")
		_t3255 = J.cmp((_t3254 if J.t(_t3254) else 0.0), 0.0, ">")
	var _t3257 = _t3255
	if not J.t(_t3257):
		var _t3256 = env["__p"]["inSafe"]
		_t3257 = J.cl(_t3256, null, [v_g_3035])
	if J.t(_t3257):
		return null
	var _t3258 = (absf(J.num(J.sub(J.gp(v_g_3035, "y"), J.gp(env["h"], "y")))) > 30.0)
	if (_t3258 if _t3258 else (absf(J.num(J.sub(J.gp(v_g_3035, "x"), J.gp(env["h"], "x")))) > 18.0)):
		return null
	if J.seq(J.gp(env["h"], "kind"), "dog"):
		J.sp(v_g_3035, "stun", 1.0)
		var _t3259 = env["__p"]["G"]
		var _t3260 = J.add(J.gp(_t3259, "alert"), 1.0)
		J.sp(_t3259, "alert", _t3260)
		J.cl(env["__p"]["checkAlert"], null, [])
		var _t3261 = env["__p"]["float"]
		J.cl(_t3261, null, [J.gp(v_g_3035, "x"), J.sub(J.gp(v_g_3035, "y"), 80.0), "狗吠到成棟樓醒晒！", "#ffb0b0"])
		var _t3262 = env["h"]
		J.sp(_t3262, "catchCd", 2.0)
		return null
	var _t3263 = J.seq(J.gp(env["h"], "kind"), "decoy")
	if ((not J.t(J.gp(env["h"], "real"))) if _t3263 else _t3263):
		return null
	var _t3264 = J.seq(J.gp(env["h"], "kind"), "guard")
	if ((not J.seq(J.gp(env["h"], "state"), "chase")) if _t3264 else _t3264):
		return null
	var _t3265 = env["__p"]["catchGhost"]
	J.cl(_t3265, null, [v_g_3035, env["h"]])
	var _t3266 = env["h"]
	J.sp(_t3266, "catchCd", 2.2)

func _f480(this_, a: Array, env):
	var v_dt_3003 = null; var v_H_3004 = null; var v_bk_3005 = null; var v_nx_3006 = null; var v_nn_3007 = null; var v_q0_3008 = null; var v_a0_3009 = null; var v_b0_3010 = null; var v_D0_3011 = null; var v_p0_3012 = null; var v_tg0_3013 = null; var v_tg1_3014 = null; var v_tgS_3015 = null; var v_tg2_3016 = null; var v_far_3017 = null; var v_tg_3018 = null; var v_chaser_3019 = null; var v_tn_3020 = null; var v_opts_3023 = null; var v_a_3024 = null; var v_b_3025 = null; var v_D_3026 = null; var v_sp_3027 = null; var v_p_3028 = null
	var _s1113 = {"__p": env, "h": null, "n": null, "zm": null}
	_s1113["h"] = J.arg(a, 0)
	v_dt_3003 = J.arg(a, 1)
	v_H_3004 = J.gp(_s1113["__p"]["HUM"], J.gp(_s1113["h"], "kind"))
	var _t3023 = _s1113["h"]
	var _t3024 = J.max_([0.0, J.sub(J.gp(_s1113["h"], "alertT"), v_dt_3003)])
	J.sp(_t3023, "alertT", _t3024)
	var _t3025 = _s1113["h"]
	var _t3026 = J.gp(_s1113["h"], "shockT")
	var _t3027 = J.gp(_s1113["h"], "shockT")
	var _t3028 = J.max_([0.0, J.sub((_t3027 if J.t(_t3027) else 0.0), v_dt_3003)])
	J.sp(_t3025, "shockT", _t3028)
	if J.t(J.gp(_s1113["h"], "scream")):
		var _t3029 = J.gp(_s1113["h"], "scream")
		var _t3030 = J.sub(J.gp(_t3029, "T"), v_dt_3003)
		J.sp(_t3029, "T", _t3030)
		if J.cmp(J.gp(J.gp(_s1113["h"], "scream"), "T"), 0.0, "<="):
			var _t3031 = _s1113["h"]
			J.sp(_t3031, "scream", null)
	var _t3032 = _s1113["h"]
	var _t3033 = J.sub(J.gp(_t3032, "talkT"), v_dt_3003)
	J.sp(_t3032, "talkT", _t3033)
	if J.cmp(J.gp(_s1113["h"], "sayT"), 0.0, ">"):
		var _t3034 = _s1113["h"]
		var _t3035 = J.sub(J.gp(_t3034, "sayT"), v_dt_3003)
		J.sp(_t3034, "sayT", _t3035)
	else:
		var _t3036 = _s1113["h"]
		J.sp(_t3036, "say", null)
	if J.seq(J.gp(_s1113["h"], "state"), "flee"):
		var _t3037 = _s1113["__p"]["inSafeXY"]
		if J.t(J.cl(_t3037, null, [J.add(J.gp(_s1113["h"], "x"), J.mul(J.gp(_s1113["h"], "vx"), v_dt_3003)), J.gp(_s1113["h"], "y")])):
			var _t3038 = _s1113["h"]
			var _t3039 = J.mul(J.gp(_t3038, "vx"), (-1.0))
			J.sp(_t3038, "vx", _t3039)
		if (randf() < J.mul(v_dt_3003, 8.0)):
			var _t3040 = _s1113["__p"]["part"]
			J.cl(_t3040, null, [J.sub(J.gp(_s1113["h"], "x"), (signf(J.num(J.gp(_s1113["h"], "vx"))) * 10.0)), J.sub(J.gp(_s1113["h"], "y"), 4.0), ((-J.num(J.gp(_s1113["h"], "vx"))) * 0.1), (-10.0), 0.5, "dust"])
		var _t3041 = _s1113["h"]
		var _t3042 = J.add(J.gp(_t3041, "x"), J.mul(J.gp(_s1113["h"], "vx"), v_dt_3003))
		J.sp(_t3041, "x", _t3042)
		var _t3043 = J.cmp(J.gp(_s1113["h"], "x"), J.sub(_s1113["__p"]["SX"], 20.0), "<")
		if (_t3043 if _t3043 else J.cmp(J.gp(_s1113["h"], "x"), J.add(_s1113["__p"]["LX"], 20.0), ">")):
			var _t3044 = _s1113["h"]
			J.sp(_t3044, "state", "gone")
		return null
	if J.seq(J.gp(_s1113["h"], "state"), "scared"):
		var _t3045 = _s1113["h"]
		var _t3046 = J.sub(J.gp(_t3045, "scT"), v_dt_3003)
		J.sp(_t3045, "scT", _t3046)
		v_bk_3005 = J.cmp(J.gp(_s1113["h"], "scT"), 1.7, ">")
		if J.t(J.gp(_s1113["h"], "scAway")):
			var _t3047 = _s1113["h"]
			var _t3048 = J.mul(J.gp(_s1113["h"], "scAway"), (55.0 if J.t(v_bk_3005) else 95.0))
			J.sp(_t3047, "vx", _t3048)
			var _t3049 = _s1113["h"]
			var _t3050 = ((-J.num(J.gp(_s1113["h"], "scAway"))) if J.t(v_bk_3005) else J.gp(_s1113["h"], "scAway"))
			J.sp(_t3049, "dir", _t3050)
		v_nx_3006 = J.add(J.gp(_s1113["h"], "x"), J.mul(J.gp(_s1113["h"], "vx"), v_dt_3003))
		var _t3051 = J.cmp(v_nx_3006, _s1113["__p"]["SX"], "<")
		var _t3053 = (_t3051 if _t3051 else J.cmp(v_nx_3006, _s1113["__p"]["LX"], ">"))
		if not J.t(_t3053):
			var _t3052 = _s1113["__p"]["inSafeXY"]
			_t3053 = J.cl(_t3052, null, [v_nx_3006, J.gp(_s1113["h"], "y")])
		if J.t(_t3053):
			var _t3054 = _s1113["h"]
			var _t3055 = J.mul(J.gp(_t3054, "vx"), (-1.0))
			J.sp(_t3054, "vx", _t3055)
			if J.t(J.gp(_s1113["h"], "scAway")):
				var _t3056 = _s1113["h"]
				var _t3057 = J.mul(J.gp(_t3056, "scAway"), (-1.0))
				J.sp(_t3056, "scAway", _t3057)
		else:
			var _t3058 = _s1113["h"]
			J.sp(_t3058, "x", v_nx_3006)
		if J.cmp(J.gp(_s1113["h"], "scT"), 0.0, "<="):
			var _t3059 = _s1113["h"]
			J.sp(_t3059, "state", "patrol")
			var _t3060 = _s1113["__p"]["nearNodeH"]
			v_nn_3007 = J.cl(_t3060, null, [_s1113["h"]])
			var _t3061 = _s1113["h"]
			J.sp(_t3061, "node", v_nn_3007)
			var _t3062 = _s1113["h"]
			J.sp(_t3062, "to", null)
			var _t3063 = _s1113["h"]
			J.sp(_t3063, "p", 0.0)
			v_q0_3008 = J.gp(J.gp(_s1113["__p"]["G"], "nodes"), v_nn_3007)
			var _t3064 = _s1113["h"]
			var _t3065 = J.gp(v_q0_3008, "x")
			J.sp(_t3064, "x", _t3065)
			var _t3066 = _s1113["h"]
			var _t3067 = J.gp(v_q0_3008, "y")
			J.sp(_t3066, "y", _t3067)
		return null
	var _t3068 = J.seq(J.gp(_s1113["h"], "state"), "shift")
	if (_t3068 if _t3068 else J.seq(J.gp(_s1113["h"], "state"), "inv")):
		if (not J.t(J.gp(_s1113["h"], "to"))):
			var _t3069 = (not J.t(J.gp(_s1113["h"], "path")))
			if (_t3069 if _t3069 else (not J.t(J.len(J.gp(_s1113["h"], "path"))))):
				if J.seq(J.gp(_s1113["h"], "state"), "shift"):
					var _t3070 = _s1113["h"]
					J.sp(_t3070, "state", "gone")
					return null
				var _t3071 = _s1113["h"]
				J.sp(_t3071, "state", "puzzle")
				var _t3072 = _s1113["h"]
				J.sp(_t3072, "puzzleT", 3.5)
				var _t3073 = _s1113["h"]
				var _t3074 = _s1113["__p"]["pick"]
				var _t3075 = J.cl(_t3074, null, [["咩都冇喎……", "係咪我聽錯？", "奇怪……啱啱明明有聲"]])
				J.sp(_t3073, "say", _t3075)
				var _t3076 = _s1113["h"]
				J.sp(_t3076, "sayT", 2.4)
				return null
			var _t3077 = _s1113["h"]
			var _t3078 = J.mc(J.gp(_s1113["h"], "path"), "shift", [])
			J.sp(_t3077, "to", _t3078)
			var _t3079 = _s1113["h"]
			J.sp(_t3079, "p", 0.0)
		v_a0_3009 = J.gp(J.gp(_s1113["__p"]["G"], "nodes"), J.gp(_s1113["h"], "node"))
		v_b0_3010 = J.gp(J.gp(_s1113["__p"]["G"], "nodes"), J.gp(_s1113["h"], "to"))
		var _t3080 = _s1113["__p"]["humanPassTo"]
		if (not J.t(J.cl(_t3080, null, [_s1113["h"], v_a0_3009, v_b0_3010]))):
			var _t3081 = _s1113["h"]
			J.sp(_t3081, "to", null)
			var _t3082 = _s1113["h"]
			var _t3083 = _s1113["__p"]["dijkstra"]
			var _t3084 = J.cl(_t3083, null, [_s1113["h"], J.gp(_s1113["h"], "node"), ("f1_s" if J.seq(J.gp(_s1113["h"], "state"), "shift") else J.gp(_s1113["h"], "invNode"))])
			J.sp(_t3082, "path", _t3084)
			if (not J.t(J.gp(_s1113["h"], "path"))):
				var _t3085 = _s1113["h"]
				J.sp(_t3085, "state", "patrol")
			return null
		v_D0_3011 = J.max_([1.0, J.hypot_([J.sub(J.gp(v_b0_3010, "x"), J.gp(v_a0_3009, "x")), J.sub(J.gp(v_b0_3010, "y"), J.gp(v_a0_3009, "y"))])])
		var _t3086 = _s1113["h"]
		var _t3087 = J.add(J.gp(_t3086, "p"), J.div(J.mul(J.mul(J.gp(v_H_3004, "sp"), 0.7), v_dt_3003), v_D0_3011))
		J.sp(_t3086, "p", _t3087)
		if (not J.seq(J.gp(v_b0_3010, "x"), J.gp(v_a0_3009, "x"))):
			var _t3088 = _s1113["h"]
			var _t3089 = (1.0 if J.cmp(J.gp(v_b0_3010, "x"), J.gp(v_a0_3009, "x"), ">") else (-1.0))
			J.sp(_t3088, "dir", _t3089)
		if J.cmp(J.gp(_s1113["h"], "p"), 1.0, ">="):
			var _t3090 = _s1113["h"]
			var _t3091 = J.gp(_s1113["h"], "to")
			J.sp(_t3090, "node", _t3091)
			var _t3092 = _s1113["h"]
			J.sp(_t3092, "to", null)
			var _t3093 = _s1113["h"]
			J.sp(_t3093, "p", 0.0)
		var _t3094 = _s1113["__p"]["posOf"]
		v_p0_3012 = J.cl(_t3094, null, [_s1113["h"]])
		var _t3095 = _s1113["h"]
		var _t3096 = J.gp(v_p0_3012, "x")
		J.sp(_t3095, "x", _t3096)
		var _t3097 = _s1113["h"]
		var _t3098 = J.gp(v_p0_3012, "y")
		J.sp(_t3097, "y", _t3098)
		if J.seq(J.gp(_s1113["h"], "state"), "inv"):
			var _t3099 = _s1113["__p"]["nearestGhost"]
			v_tg0_3013 = J.cl(_t3099, null, [_s1113["h"]])
			var _t3100 = ((absf(J.num(J.sub(J.gp(v_tg0_3013, "y"), J.gp(_s1113["h"], "y")))) < 40.0) if J.t(v_tg0_3013) else v_tg0_3013)
			var _t3101 = ((J.mul(J.sub(J.gp(v_tg0_3013, "x"), J.gp(_s1113["h"], "x")), J.gp(_s1113["h"], "dir")) > 0.0) if J.t(_t3100) else _t3100)
			if J.t(((absf(J.num(J.sub(J.gp(v_tg0_3013, "x"), J.gp(_s1113["h"], "x")))) < 150.0) if J.t(_t3101) else _t3101)):
				var _t3102 = _s1113["h"]
				J.sp(_t3102, "state", "chase")
				var _t3103 = _s1113["h"]
				J.sp(_t3103, "alertT", 1.2)
				var _t3104 = _s1113["h"]
				var _t3105 = _s1113["__p"]["line"]
				var _t3106 = J.cl(_t3105, null, ["guardHit"])
				J.sp(_t3104, "say", _t3106)
				var _t3107 = _s1113["h"]
				J.sp(_t3107, "sayT", 2.0)
		return null
	if J.seq(J.gp(_s1113["h"], "state"), "balk"):
		var _t3108 = _s1113["h"]
		var _t3109 = J.sub(J.gp(_t3108, "balkT"), v_dt_3003)
		J.sp(_t3108, "balkT", _t3109)
		var _t3110 = J.cmp(J.gp(_s1113["h"], "balkT"), 1.3, "<")
		if ((not J.t(J.gp(_s1113["h"], "balkTurn"))) if _t3110 else _t3110):
			var _t3111 = _s1113["h"]
			J.sp(_t3111, "balkTurn", 1.0)
			var _t3112 = _s1113["h"]
			var _t3113 = (-J.num(J.gp(_s1113["h"], "dir")))
			J.sp(_t3112, "dir", _t3113)
		if J.cmp(J.gp(_s1113["h"], "balkT"), 0.0, "<="):
			var _t3114 = _s1113["h"]
			J.sp(_t3114, "state", "patrol")
			var _t3115 = _s1113["h"]
			J.sp(_t3115, "wait", 0.2)
			var _t3116 = _s1113["h"]
			J.sp(_t3116, "repath", 0.0)
			var _t3117 = _s1113["h"]
			J.sp(_t3117, "path", null)
			var _t3118 = _s1113["h"]
			J.sp(_t3118, "balkCd", 6.0)
		return null
	if J.seq(J.gp(_s1113["h"], "state"), "puzzle"):
		var _t3119 = _s1113["h"]
		var _t3120 = J.sub(J.gp(_t3119, "puzzleT"), v_dt_3003)
		J.sp(_t3119, "puzzleT", _t3120)
		var _t3121 = _s1113["h"]
		var _t3122 = (1.0 if J.t(J.mod(floor(J.num(J.mul(J.gp(_s1113["h"], "puzzleT"), 1.2))), 2.0)) else (-1.0))
		J.sp(_t3121, "dir", _t3122)
		var _t3123 = _s1113["__p"]["nearestGhost"]
		v_tg1_3014 = J.cl(_t3123, null, [_s1113["h"]])
		var _t3124 = ((absf(J.num(J.sub(J.gp(v_tg1_3014, "y"), J.gp(_s1113["h"], "y")))) < 40.0) if J.t(v_tg1_3014) else v_tg1_3014)
		var _t3125 = ((J.mul(J.sub(J.gp(v_tg1_3014, "x"), J.gp(_s1113["h"], "x")), J.gp(_s1113["h"], "dir")) > 0.0) if J.t(_t3124) else _t3124)
		if J.t(((absf(J.num(J.sub(J.gp(v_tg1_3014, "x"), J.gp(_s1113["h"], "x")))) < 130.0) if J.t(_t3125) else _t3125)):
			var _t3126 = _s1113["h"]
			J.sp(_t3126, "state", "chase")
			var _t3127 = _s1113["h"]
			J.sp(_t3127, "alertT", 1.2)
			var _t3128 = _s1113["h"]
			var _t3129 = _s1113["__p"]["line"]
			var _t3130 = J.cl(_t3129, null, ["guardHit"])
			J.sp(_t3128, "say", _t3130)
			var _t3131 = _s1113["h"]
			J.sp(_t3131, "sayT", 2.0)
		else:
			if J.cmp(J.gp(_s1113["h"], "puzzleT"), 0.0, "<="):
				var _t3132 = _s1113["h"]
				J.sp(_t3132, "state", "patrol")
				var _t3133 = _s1113["h"]
				J.sp(_t3133, "wait", 0.5)
		return null
	if J.seq(J.gp(_s1113["h"], "kind"), "collector"):
		return null
	var _t3134 = _s1113["__p"]["nearestAny"]
	v_tgS_3015 = J.cl(_t3134, null, [_s1113["h"]])
	var _t3135 = _s1113["h"]
	var _t3136 = J.gp(_s1113["h"], "balkCd")
	var _t3137 = J.gp(_s1113["h"], "balkCd")
	var _t3138 = J.max_([0.0, J.sub((_t3137 if J.t(_t3137) else 0.0), v_dt_3003)])
	J.sp(_t3135, "balkCd", _t3138)
	var _t3140 = v_tgS_3015
	if J.t(_t3140):
		var _t3139 = _s1113["__p"]["inSafe"]
		_t3140 = J.cl(_t3139, null, [v_tgS_3015])
	var _t3142 = ((not J.cmp(J.gp(_s1113["h"], "balkCd"), 0.0, ">")) if J.t(_t3140) else _t3140)
	if J.t(_t3142):
		var _t3141 = _s1113["__p"]["nearSafe"]
		_t3142 = J.cl(_t3141, null, [_s1113["h"]])
	var _t3147 = _t3142
	if J.t(_t3147):
		var _t3146 = J.seq(J.gp(_s1113["h"], "state"), "chase")
		if not J.t(_t3146):
			var _t3143 = (not J.seq(J.gp(_s1113["h"], "kind"), "guard"))
			var _t3145 = ((not J.seq(J.gp(_s1113["h"], "kind"), "collector")) if _t3143 else _t3143)
			if J.t(_t3145):
				var _t3144 = J.seq(J.gp(_s1113["h"], "kind"), "decoy")
				_t3145 = (not ((not J.t(J.gp(_s1113["h"], "real"))) if _t3144 else _t3144))
			_t3146 = _t3145
		_t3147 = _t3146
	if J.t(_t3147):
		var _t3148 = _s1113["__p"]["balk"]
		J.cl(_t3148, null, [_s1113["h"], (not J.seq(J.gp(_s1113["h"], "kind"), "dog"))])
		return null
	var _t3149 = J.seq(J.gp(_s1113["h"], "state"), "chase")
	var _t3151 = (v_tgS_3015 if _t3149 else _t3149)
	if J.t(_t3151):
		var _t3150 = _s1113["__p"]["inSafe"]
		_t3151 = J.cl(_t3150, null, [v_tgS_3015])
	if J.t(_t3151):
		var _t3152 = _s1113["__p"]["balk"]
		J.cl(_t3152, null, [_s1113["h"], false])
		return null
	if J.seq(J.gp(_s1113["h"], "state"), "chase"):
		var _t3153 = _s1113["__p"]["nearestGhost"]
		v_tg2_3016 = J.cl(_t3153, null, [_s1113["h"]])
		var _t3154 = (not J.t(v_tg2_3016))
		var _t3155 = (_t3154 if _t3154 else (absf(J.num(J.sub(J.gp(J.gp(J.gp(_s1113["__p"]["G"], "nodes"), J.gp(v_tg2_3016, "node")), "f"), J.gp(J.gp(J.gp(_s1113["__p"]["G"], "nodes"), J.gp(_s1113["h"], "node")), "f")))) >= 2.0))
		v_far_3017 = (_t3155 if _t3155 else (absf(J.num(J.sub(J.gp(v_tg2_3016, "x"), J.gp(_s1113["h"], "x")))) > 460.0))
		var _t3157 = v_tg2_3016
		if J.t(_t3157):
			var _t3156 = _s1113["__p"]["inZone"]
			_t3157 = (not J.t(J.cl(_t3156, null, [_s1113["h"], J.gp(J.gp(J.gp(_s1113["__p"]["G"], "nodes"), J.gp(v_tg2_3016, "node")), "f"), 1.0])))
		if J.t(_t3157):
			var _t3158 = _s1113["h"]
			var _t3159 = J.gp(_s1113["h"], "lostT")
			var _t3160 = J.add((_t3159 if J.t(_t3159) else 0.0), J.mul(v_dt_3003, 3.0))
			J.sp(_t3158, "lostT", _t3160)
		var _t3161 = _s1113["h"]
		var _t3163 = null
		if J.t(v_far_3017):
			var _t3162 = J.gp(_s1113["h"], "lostT")
			_t3163 = J.add((_t3162 if J.t(_t3162) else 0.0), v_dt_3003)
		else:
			_t3163 = 0.0
		J.sp(_t3161, "lostT", _t3163)
		if J.cmp(J.gp(_s1113["h"], "lostT"), 8.0, ">"):
			var _t3164 = _s1113["h"]
			J.sp(_t3164, "state", "patrol")
			var _t3165 = _s1113["h"]
			J.sp(_t3165, "lostT", 0.0)
			var _t3166 = _s1113["h"]
			J.sp(_t3166, "path", null)
			var _t3167 = _s1113["h"]
			var _t3168 = _s1113["__p"]["pick"]
			var _t3169 = J.cl(_t3168, null, [["走甩咗……", "跑得咁快？算數", "嗰樣嘢去咗邊？"]])
			J.sp(_t3167, "say", _t3169)
			var _t3170 = _s1113["h"]
			J.sp(_t3170, "sayT", 2.2)
	var _t3171 = J.cmp(J.gp(_s1113["h"], "talkT"), 0.0, "<=")
	if ((not J.seq(J.gp(_s1113["h"], "kind"), "dog")) if _t3171 else _t3171):
		var _t3172 = _s1113["h"]
		var _t3177 = null
		if J.seq(J.gp(_s1113["h"], "kind"), "guard"):
			var _t3173 = _s1113["__p"]["line"]
			_t3177 = J.cl(_t3173, null, ["guard"])
		else:
			var _t3176 = null
			if J.seq(J.gp(_s1113["h"], "kind"), "compass"):
				var _t3174 = _s1113["__p"]["pick"]
				_t3176 = J.cl(_t3174, null, [["羅盤指住呢邊……", "針震緊，有嘢喺附近"]])
			else:
				var _t3175 = _s1113["__p"]["pick"]
				_t3176 = J.cl(_t3175, null, [["照妖鏡在此，莫要亂來", "鏡光到處，邪靈退後"]])
			_t3177 = _t3176
		J.sp(_t3172, "say", _t3177)
		var _t3178 = _s1113["h"]
		J.sp(_t3178, "sayT", 2.4)
		var _t3179 = _s1113["h"]
		var _t3180 = (8.0 + J.mul(J.cl(_s1113["__p"]["rnd"], null, []), 8.0))
		J.sp(_t3179, "talkT", _t3180)
	var _t3181 = _s1113["__p"]["nearestGhost"]
	v_tg_3018 = J.cl(_t3181, null, [_s1113["h"]])
	var _t3182 = (not J.seq(J.gp(_s1113["h"], "kind"), "guard"))
	v_chaser_3019 = (_t3182 if _t3182 else J.seq(J.gp(_s1113["h"], "state"), "chase"))
	var _t3183 = J.seq(J.gp(_s1113["h"], "kind"), "guard")
	var _t3184 = (v_tg_3018 if _t3183 else _t3183)
	var _t3185 = ((absf(J.num(J.sub(J.gp(v_tg_3018, "y"), J.gp(_s1113["h"], "y")))) < 40.0) if J.t(_t3184) else _t3184)
	var _t3186 = ((J.mul(J.sub(J.gp(v_tg_3018, "x"), J.gp(_s1113["h"], "x")), J.gp(_s1113["h"], "dir")) > 0.0) if J.t(_t3185) else _t3185)
	var _t3187 = ((absf(J.num(J.sub(J.gp(v_tg_3018, "x"), J.gp(_s1113["h"], "x")))) < 150.0) if J.t(_t3186) else _t3186)
	if J.t(((not J.seq(J.gp(_s1113["h"], "state"), "chase")) if J.t(_t3187) else _t3187)):
		var _t3188 = _s1113["h"]
		J.sp(_t3188, "state", "chase")
		var _t3189 = _s1113["h"]
		J.sp(_t3189, "alertT", 1.2)
		var _t3190 = _s1113["h"]
		var _t3191 = _s1113["__p"]["line"]
		var _t3192 = J.cl(_t3191, null, ["guardHit"])
		J.sp(_t3190, "say", _t3192)
		var _t3193 = _s1113["h"]
		J.sp(_t3193, "sayT", 2.0)
	var _t3194 = J.seq(J.gp(_s1113["h"], "kind"), "decoy")
	if ((not J.t(J.gp(_s1113["h"], "real"))) if _t3194 else _t3194):
		v_chaser_3019 = false
	if (not J.t(J.gp(_s1113["h"], "to"))):
		var _t3195 = _s1113["h"]
		var _t3196 = J.sub(J.gp(_t3195, "wait"), v_dt_3003)
		J.sp(_t3195, "wait", _t3196)
		if J.cmp(J.gp(_s1113["h"], "wait"), 0.0, ">"):
			return null
		var _t3197 = _s1113["h"]
		var _t3198 = J.sub(J.gp(_t3197, "repath"), v_dt_3003)
		J.sp(_t3197, "repath", _t3198)
		if J.t((v_tg_3018 if J.t(v_chaser_3019) else v_chaser_3019)):
			v_tn_3020 = ((J.gp(v_tg_3018, "node") if (absf(J.num(J.sub(J.gp(J.gp(J.gp(_s1113["__p"]["G"], "nodes"), J.gp(v_tg_3018, "node")), "x"), J.gp(v_tg_3018, "x")))) < absf(J.num(J.sub(J.gp(J.gp(J.gp(_s1113["__p"]["G"], "nodes"), J.gp(v_tg_3018, "to")), "x"), J.gp(v_tg_3018, "x"))))) else J.gp(v_tg_3018, "to")) if J.t(J.gp(v_tg_3018, "to")) else J.gp(v_tg_3018, "node"))
			var _t3199 = _s1113["__p"]["safeNode"]
			if J.t(J.cl(_t3199, null, [v_tn_3020])):
				var _t3200 = _s1113["__p"]["balk"]
				var _t3203 = _s1113["h"]
				var _t3202 = (not J.seq(J.gp(_s1113["h"], "kind"), "dog"))
				if J.t(_t3202):
					var _t3201 = _s1113["__p"]["nearSafe"]
					_t3202 = J.cl(_t3201, null, [_s1113["h"]])
				J.cl(_t3200, null, [_t3203, ((not J.cmp(J.gp(_s1113["h"], "balkCd"), 0.0, ">")) if J.t(_t3202) else _t3202)])
				return null
			var _t3204 = J.cmp(J.gp(_s1113["h"], "repath"), 0.0, "<=")
			if (_t3204 if _t3204 else (not J.t(J.gp(_s1113["h"], "path")))):
				var _t3205 = _s1113["h"]
				var _t3206 = _s1113["__p"]["dijkstra"]
				var _t3207 = J.cl(_t3206, null, [_s1113["h"], J.gp(_s1113["h"], "node"), v_tn_3020])
				J.sp(_t3205, "path", _t3207)
				var _t3208 = _s1113["h"]
				J.sp(_t3208, "repath", 0.5)
			var _t3209 = J.gp(_s1113["h"], "path")
			if J.t((J.len(J.gp(_s1113["h"], "path")) if J.t(_t3209) else _t3209)):
				var _t3210 = _s1113["h"]
				var _t3211 = J.mc(J.gp(_s1113["h"], "path"), "shift", [])
				J.sp(_t3210, "to", _t3211)
				var _t3212 = _s1113["h"]
				J.sp(_t3212, "p", 0.0)
		if (not J.t(J.gp(_s1113["h"], "to"))):
			_s1113["n"] = J.gp(J.gp(_s1113["__p"]["G"], "nodes"), J.gp(_s1113["h"], "node"))
			_s1113["zm"] = (J.div(J.add(J.gp(J.gp(_s1113["h"], "zone"), 0.0), J.gp(J.gp(_s1113["h"], "zone"), 1.0)), 2.0) if J.t(J.gp(_s1113["h"], "zone")) else 0.0)
			var _t3213 = J.gp(_s1113["n"], "links")
			v_opts_3023 = J.mc(_t3213, "filter", [Callable(self, "_f481").bind(_s1113)])
			if J.t(J.len(v_opts_3023)):
				var _t3224 = _s1113["h"]
				var _t3225 = _s1113["__p"]["pick"]
				var _t3226 = J.gp(J.cl(_t3225, null, [v_opts_3023]), "to")
				J.sp(_t3224, "to", _t3226)
				var _t3227 = _s1113["h"]
				J.sp(_t3227, "p", 0.0)
	v_a_3024 = J.gp(J.gp(_s1113["__p"]["G"], "nodes"), J.gp(_s1113["h"], "node"))
	v_b_3025 = J.gp(J.gp(_s1113["__p"]["G"], "nodes"), J.gp(_s1113["h"], "to"))
	if (not J.t(v_b_3025)):
		var _t3228 = _s1113["h"]
		J.sp(_t3228, "to", null)
		return null
	v_D_3026 = J.max_([1.0, J.hypot_([J.sub(J.gp(v_b_3025, "x"), J.gp(v_a_3024, "x")), J.sub(J.gp(v_b_3025, "y"), J.gp(v_a_3024, "y"))])])
	var _t3230 = J.gp(v_H_3004, "sp")
	var _t3229 = J.gp(_s1113["h"], "boost")
	v_sp_3027 = ((J.mul(_t3230, (_t3229 if J.t(_t3229) else 1.0)) * ((1.4 if J.cmp(J.gp(J.gp(_s1113["__p"]["G"], "gate"), "t"), 20.0, ">") else 1.2) if J.t(J.gp(_s1113["__p"]["G"], "gate")) else 1.0)) * (1.0 + J.mul(0.08, J.gp(_s1113["__p"]["G"], "phase"))))
	if J.t((v_chaser_3019 if J.t(v_tg_3018) else v_tg_3018)):
		var _t3231 = J.mul(v_sp_3027, (1.05 * pow(J.num(1.15), J.num(absf(J.num(J.sub(J.gp(J.gp(J.gp(_s1113["__p"]["G"], "nodes"), J.gp(v_tg_3018, "node")), "f"), J.gp(v_a_3024, "f"))))))))
		v_sp_3027 = _t3231
		var _t3232 = J.min_([v_sp_3027, (J.mul(J.gp(J.gp(v_tg_3018, "d"), "sp"), J.gp(J.gp(_s1113["__p"]["G"], "mods"), "spd")) * 0.85)])
		v_sp_3027 = _t3232
	else:
		var _t3233 = J.mul(v_sp_3027, 0.45)
		v_sp_3027 = _t3233
	var _t3234 = _s1113["h"]
	J.sp(_t3234, "walkSp", v_sp_3027)
	var _t3235 = _s1113["h"]
	var _t3236 = J.add(J.gp(_t3235, "p"), J.div(J.mul(v_sp_3027, v_dt_3003), v_D_3026))
	J.sp(_t3235, "p", _t3236)
	if (not J.seq(J.gp(v_b_3025, "x"), J.gp(v_a_3024, "x"))):
		var _t3237 = _s1113["h"]
		var _t3238 = (1.0 if J.cmp(J.gp(v_b_3025, "x"), J.gp(v_a_3024, "x"), ">") else (-1.0))
		J.sp(_t3237, "dir", _t3238)
	if J.cmp(J.gp(_s1113["h"], "p"), 1.0, ">="):
		var _t3239 = _s1113["h"]
		var _t3240 = J.gp(_s1113["h"], "to")
		J.sp(_t3239, "node", _t3240)
		var _t3241 = _s1113["h"]
		J.sp(_t3241, "to", null)
		var _t3242 = _s1113["h"]
		J.sp(_t3242, "p", 0.0)
		var _t3243 = _s1113["h"]
		var _t3244 = (0.0 if J.t(v_chaser_3019) else (0.3 + J.mul(J.cl(_s1113["__p"]["rnd"], null, []), 0.8)))
		J.sp(_t3243, "wait", _t3244)
	var _t3245 = _s1113["__p"]["posOf"]
	v_p_3028 = J.cl(_t3245, null, [_s1113["h"]])
	var _t3246 = _s1113["h"]
	var _t3247 = J.gp(v_p_3028, "x")
	J.sp(_t3246, "x", _t3247)
	var _t3248 = _s1113["h"]
	var _t3249 = J.gp(v_p_3028, "y")
	J.sp(_t3248, "y", _t3249)
	var _t3250 = J.gp(_s1113["__p"]["G"], "gh")
	J.mc(_t3250, "forEach", [Callable(self, "_f482").bind(_s1113)])
	var _t3267 = _s1113["h"]
	var _t3268 = J.gp(_s1113["h"], "catchCd")
	var _t3269 = J.gp(_s1113["h"], "catchCd")
	var _t3270 = J.max_([0.0, J.sub((_t3269 if J.t(_t3269) else 0.0), v_dt_3003)])
	J.sp(_t3267, "catchCd", _t3270)

func _f484(this_, a: Array, env):
	var v_o_3047 = null
	v_o_3047 = J.arg(a, 0)
	var _t3273 = (not J.seq(J.gp(v_o_3047, "state"), "flee"))
	var _t3275 = ((not J.seq(J.gp(v_o_3047, "kind"), "dog")) if _t3273 else _t3273)
	if J.t(_t3275):
		var _t3274 = J.seq(J.gp(v_o_3047, "kind"), "decoy")
		_t3275 = (not ((not J.t(J.gp(v_o_3047, "real"))) if _t3274 else _t3274))
	var _t3276 = ((absf(J.num(J.sub(J.gp(v_o_3047, "y"), J.gp(env["g"], "y")))) < 30.0) if _t3275 else _t3275)
	return ((absf(J.num(J.sub(J.gp(v_o_3047, "x"), J.gp(env["g"], "x")))) < 90.0) if _t3276 else _t3276)

func _f485(this_, a: Array, env):
	var v_b_3050 = null
	v_b_3050 = J.arg(a, 0)
	return J.seq(J.gp(v_b_3050, "o"), J.gp(env["g"], "i"))

func _f486(this_, a: Array, env):
	var v_b_3053 = null
	v_b_3053 = J.arg(a, 0)
	return (not J.seq(J.gp(v_b_3053, "o"), J.gp(env["g"], "i")))

func _f487(this_, a: Array, env):
	var v_o_3056 = null
	v_o_3056 = J.arg(a, 0)
	return (not J.t(J.gp(v_o_3056, "out")))

func _f488(this_, a: Array, env):
	var v_o_3059 = null
	v_o_3059 = J.arg(a, 0)
	var _t3304 = (not J.t(J.gp(v_o_3059, "out")))
	return ((not J.t(J.gp(v_o_3059, "home"))) if _t3304 else _t3304)

func _f489(this_, a: Array, env):
	var v_l_3062 = null
	v_l_3062 = J.arg(a, 0)
	return J.gp(J.gp(env["__p"]["G"], "nodes"), J.gp(v_l_3062, "to"))

func _f490(this_, a: Array, env):
	var v_m_3065 = null
	v_m_3065 = J.arg(a, 0)
	var _t3311 = (not J.seq(J.gp(v_m_3065, "kind"), "in"))
	return ((J.mul(J.sub(J.gp(v_m_3065, "x"), J.gp(env["h"], "x")), J.gp(env["h"], "dir")) > 0.0) if _t3311 else _t3311)

func _f483(this_, a: Array, env):
	var v_near_3040 = null; var v_k_3041 = null; var v_lost_3042 = null; var v_nx_3043 = null; var v_back_3044 = null
	var _s1155 = {"__p": env, "g": null, "h": null}
	_s1155["g"] = J.arg(a, 0)
	_s1155["h"] = J.arg(a, 1)
	var _t3271 = _s1155["__p"]["inSafe"]
	if J.t(J.cl(_t3271, null, [_s1155["g"]])):
		return null
	var _t3272 = J.gp(_s1155["__p"]["G"], "guards")
	v_near_3040 = J.len(J.mc(_t3272, "filter", [Callable(self, "_f484").bind(_s1155)]))
	var _t3277 = _s1155["g"]
	var _t3278 = J.add(J.gp(_t3277, "caught"), (3.0 if J.cmp(v_near_3040, 2.0, ">=") else 1.0))
	J.sp(_t3277, "caught", _t3278)
	if J.cmp(v_near_3040, 2.0, ">="):
		var _t3279 = _s1155["__p"]["float"]
		J.cl(_t3279, null, [J.gp(_s1155["g"], "x"), J.sub(J.gp(_s1155["g"], "y"), 110.0), "被圍！", "#ff5a4a"])
	var _t3280 = _s1155["g"]
	J.sp(_t3280, "hitT", 0.8)
	var _t3281 = _s1155["g"]
	var _t3282 = J.gp(_s1155["h"], "dir")
	J.sp(_t3281, "hitDir", _t3282)
	var _t3283 = _s1155["g"]
	J.sp(_t3283, "stun", 1.5)
	var _t3284 = _s1155["g"]
	J.sp(_t3284, "to", null)
	var _t3285 = _s1155["g"]
	J.sp(_t3285, "auto", null)
	var _t3286 = _s1155["h"]
	J.sp(_t3286, "alertT", 1.3)
	var _t3287 = _s1155["h"]
	var _t3288 = _s1155["__p"]["line"]
	var _t3289 = J.cl(_t3288, null, ["guardHit"])
	J.sp(_t3287, "say", _t3289)
	var _t3290 = _s1155["h"]
	J.sp(_t3290, "sayT", 2.0)
	var _t3291 = _s1155["__p"]["G"]
	J.sp(_t3291, "shake", 0.35)
	v_k_3041 = 0.0
	while true:
		if not J.cmp(v_k_3041, 10.0, "<"): break
		var _t3292 = _s1155["__p"]["part"]
		J.cl(_t3292, null, [J.gp(_s1155["g"], "x"), J.sub(J.gp(_s1155["g"], "y"), J.mul(J.gp(J.gp(_s1155["g"], "d"), "h"), 0.5)), ((J.sub(J.cl(_s1155["__p"]["rnd"], null, []), 0.5) * 50.0) + J.mul(J.gp(_s1155["h"], "dir"), 40.0)), ((-30.0) - J.mul(J.cl(_s1155["__p"]["rnd"], null, []), 40.0)), 0.9, "smoke"])
		v_k_3041 = J.num(v_k_3041) + 1.0
	if J.cmp(J.gp(_s1155["g"], "caught"), 3.0, ">="):
		var _t3293 = _s1155["g"]
		J.sp(_t3293, "out", true)
		var _t3294 = J.gp(_s1155["__p"]["G"], "bag")
		v_lost_3042 = J.len(J.mc(_t3294, "filter", [Callable(self, "_f485").bind(_s1155)]))
		var _t3295 = _s1155["__p"]["G"]
		var _t3296 = J.gp(_s1155["__p"]["G"], "bag")
		var _t3297 = J.mc(_t3296, "filter", [Callable(self, "_f486").bind(_s1155)])
		J.sp(_t3295, "bag", _t3297)
		var _t3298 = _s1155["g"]
		J.sp(_t3298, "loot", 0.0)
		var _t3299 = _s1155["__p"]["float"]
		J.cl(_t3299, null, [J.gp(_s1155["g"], "x"), J.sub(J.gp(_s1155["g"], "y"), 100.0), J.add(J.gp(J.gp(_s1155["g"], "d"), "name"), "被收服！"), "#ff7a5a"])
		var _t3300 = _s1155["__p"]["toast"]
		var _t3302 = (J.add(J.add(J.gp(J.gp(_s1155["g"], "d"), "name"), "畀人收服咗，佢身上 "), v_lost_3042) + " 件收穫冇埋。")
		var _t3301 = J.gp(_s1155["__p"]["G"], "gh")
		J.cl(_t3300, null, [(_t3302 + ("快啲切去其他鬼！" if J.t(J.mc(_t3301, "some", [Callable(self, "_f487").bind(_s1155)])) else ""))])
		if J.seq(J.gp(_s1155["__p"]["G"], "active"), J.gp(_s1155["g"], "i")):
			var _t3303 = J.gp(_s1155["__p"]["G"], "gh")
			v_nx_3043 = J.mc(_t3303, "find", [Callable(self, "_f488").bind(_s1155)])
			if J.t(v_nx_3043):
				var _t3305 = _s1155["__p"]["G"]
				var _t3306 = J.gp(v_nx_3043, "i")
				J.sp(_t3305, "active", _t3306)
	else:
		var _t3307 = _s1155["__p"]["loseLoot"]
		J.cl(_t3307, null, [_s1155["g"], 0.34])
		var _t3308 = _s1155["__p"]["float"]
		J.cl(_t3308, null, [J.gp(_s1155["g"], "x"), J.sub(J.gp(_s1155["g"], "y"), 80.0), (J.add("被捉住！（", J.gp(_s1155["g"], "caught")) + "/3）"), "#ffb0b0"])
		var _t3309 = J.gp(J.gp(J.gp(_s1155["__p"]["G"], "nodes"), J.gp(_s1155["g"], "node")), "links")
		var _t3310 = J.mc(_t3309, "map", [Callable(self, "_f489").bind(_s1155)])
		v_back_3044 = J.gp(J.mc(_t3310, "filter", [Callable(self, "_f490").bind(_s1155)]), 0.0)
		if J.t(v_back_3044):
			var _t3312 = _s1155["g"]
			var _t3313 = J.gp(v_back_3044, "id")
			J.sp(_t3312, "node", _t3313)

func _f492(this_, a: Array, env):
	var v_b_3076 = null
	v_b_3076 = J.arg(a, 0)
	return J.seq(J.gp(v_b_3076, "o"), J.gp(env["g"], "i"))

func _f491(this_, a: Array, env):
	var v_frac_3069 = null; var v_mine_3070 = null; var v_l_3071 = null; var v_k_3072 = null; var v_i_3073 = null
	var _s1167 = {"__p": env, "g": null}
	_s1167["g"] = J.arg(a, 0)
	v_frac_3069 = J.arg(a, 1)
	var _t3314 = J.gp(_s1167["__p"]["G"], "bag")
	v_mine_3070 = J.mc(_t3314, "filter", [Callable(self, "_f492").bind(_s1167)])
	v_l_3071 = ceil(J.num((J.mul(J.len(v_mine_3070), v_frac_3069) * (0.5 if J.cmp(J.gp(J.gp(_s1167["__p"]["G"], "mods"), "arm"), 1.0, "<") else 1.0))))
	v_k_3072 = 0.0
	while true:
		if not J.cmp(v_k_3072, v_l_3071, "<"): break
		var _t3315 = J.gp(_s1167["__p"]["G"], "bag")
		v_i_3073 = J.mc(_t3315, "indexOf", [J.gp(v_mine_3070, v_k_3072)])
		var _t3316 = J.gp(_s1167["__p"]["G"], "bag")
		J.mc(_t3316, "splice", [v_i_3073, 1.0])
		v_k_3072 = J.num(v_k_3072) + 1.0
	var _t3317 = _s1167["g"]
	var _t3318 = J.max_([0.0, J.sub(J.gp(_s1167["g"], "loot"), v_l_3071)])
	J.sp(_t3317, "loot", _t3318)
	if J.cmp(v_l_3071, 0.0, ">"):
		var _t3319 = _s1167["__p"]["float"]
		J.cl(_t3319, null, [J.gp(_s1167["g"], "x"), J.sub(J.gp(_s1167["g"], "y"), 95.0), J.add("跌咗收穫 -", v_l_3071), "#ff9a9a"])

func _f493(this_, a: Array, env):
	var v_f_3079 = null; var v_x_3080 = null
	v_f_3079 = J.arg(a, 0)
	v_x_3080 = J.arg(a, 1)
	var _t3320 = env["G"]
	var _t3322 = (1.0 if J.cmp(v_x_3080, J.div(env["WW"], 2.0), "<") else (-1.0))
	var _t3323 = []
	var _t3321 = env["pick"]
	var _t3324 = {"x": v_x_3080, "f": v_f_3079, "dir": _t3322, "ringT": 2.2, "life": 26.0, "waves": _t3323, "say": J.cl(_t3321, null, [env["TAOL"]]), "sayT": 2.6}
	J.sp(_t3320, "tao", _t3324)
	var _t3325 = env["float"]
	var _t3326 = env["fy"]
	J.cl(_t3325, null, [v_x_3080, J.sub(J.cl(_t3326, null, [v_f_3079]), 90.0), "天師嚟咗！", "#ffd54a"])

func _f496(this_, a: Array, env):
	var v_l_3094 = null
	v_l_3094 = J.arg(a, 0)
	return J.gp(J.gp(env["__p"]["__p"]["G"], "nodes"), J.gp(v_l_3094, "to"))

func _f497(this_, a: Array, env):
	var v_m_3097 = null
	v_m_3097 = J.arg(a, 0)
	var _t3361 = (not J.seq(J.gp(v_m_3097, "kind"), "in"))
	var _t3362 = (((J.sub(J.gp(v_m_3097, "x"), J.gp(env["__p"]["T"], "x")) * J.sub(J.gp(env["g"], "x"), J.gp(env["__p"]["T"], "x"))) >= 0.0) if _t3361 else _t3361)
	return ((absf(J.num(J.sub(J.gp(v_m_3097, "x"), J.gp(env["__p"]["T"], "x")))) > absf(J.num(J.sub(J.gp(env["n"], "x"), J.gp(env["__p"]["T"], "x"))))) if _t3362 else _t3362)

func _f495(this_, a: Array, env):
	var v_away_3090 = null; var v_k_3091 = null
	var _s1176 = {"__p": env, "g": null, "n": null}
	_s1176["g"] = J.arg(a, 0)
	var _t3350 = J.gp(_s1176["g"], "home")
	if J.t((_t3350 if J.t(_t3350) else J.gp(_s1176["g"], "out"))):
		return null
	if J.t(J.gp(_s1176["g"], "inUnit")):
		return null
	var _t3351 = _s1176["__p"]["__p"]["inSafe"]
	if J.t(J.cl(_t3351, null, [_s1176["g"]])):
		return null
	if (not J.seq(J.gp(J.gp(J.gp(_s1176["__p"]["__p"]["G"], "nodes"), J.gp(_s1176["g"], "node")), "f"), J.gp(_s1176["__p"]["T"], "f"))):
		return null
	if (absf(J.num(J.sub(J.gp(_s1176["g"], "x"), J.gp(_s1176["__p"]["T"], "x")))) > 140.0):
		return null
	var _t3352 = _s1176["g"]
	J.sp(_t3352, "sealT", 3.0)
	var _t3353 = _s1176["g"]
	J.sp(_t3353, "hitT", 0.8)
	var _t3354 = _s1176["g"]
	var _t3355 = (1.0 if J.cmp(J.gp(_s1176["g"], "x"), J.gp(_s1176["__p"]["T"], "x"), ">") else (-1.0))
	J.sp(_t3354, "hitDir", _t3355)
	var _t3356 = _s1176["g"]
	J.sp(_t3356, "to", null)
	var _t3357 = _s1176["g"]
	J.sp(_t3357, "auto", null)
	var _t3358 = _s1176["g"]
	J.sp(_t3358, "taskP", 0.0)
	_s1176["n"] = J.gp(J.gp(_s1176["__p"]["__p"]["G"], "nodes"), J.gp(_s1176["g"], "node"))
	var _t3359 = J.gp(_s1176["n"], "links")
	var _t3360 = J.mc(_t3359, "map", [Callable(self, "_f496").bind(_s1176)])
	v_away_3090 = J.gp(J.mc(_t3360, "filter", [Callable(self, "_f497").bind(_s1176)]), 0.0)
	if J.seq(J.gp(_s1176["n"], "kind"), "in"):
		var _t3363 = _s1176["g"]
		var _t3364 = J.gp(_s1176["n"], "id")
		var _t3365 = J.mc(_t3364, "replace", ["_i", "_d"])
		J.sp(_t3363, "node", _t3365)
	else:
		if J.t(v_away_3090):
			var _t3366 = _s1176["g"]
			var _t3367 = J.gp(v_away_3090, "id")
			J.sp(_t3366, "node", _t3367)
	var _t3368 = _s1176["__p"]["__p"]["float"]
	J.cl(_t3368, null, [J.gp(_s1176["g"], "x"), J.sub(J.gp(_s1176["g"], "y"), 90.0), "鈴聲逼退，暫時嚇唔到人", "#ffe9a0"])
	v_k_3091 = 0.0
	while true:
		if not J.cmp(v_k_3091, 8.0, "<"): break
		var _t3369 = _s1176["__p"]["__p"]["part"]
		J.cl(_t3369, null, [J.gp(_s1176["g"], "x"), J.sub(J.gp(_s1176["g"], "y"), 30.0), (J.sub(J.cl(_s1176["__p"]["__p"]["rnd"], null, []), 0.5) * 60.0), ((-30.0) - J.mul(J.cl(_s1176["__p"]["__p"]["rnd"], null, []), 40.0)), 0.9, "smoke"])
		v_k_3091 = J.num(v_k_3091) + 1.0

func _f498(this_, a: Array, env):
	var v_w_3100 = null
	v_w_3100 = J.arg(a, 0)
	var _t3371 = J.sub(J.gp(v_w_3100, "t"), env["dt"])
	J.sp(v_w_3100, "t", _t3371)
	var _t3372 = J.add(J.gp(v_w_3100, "r"), J.mul(180.0, env["dt"]))
	J.sp(v_w_3100, "r", _t3372)

func _f499(this_, a: Array, env):
	var v_w_3103 = null
	v_w_3103 = J.arg(a, 0)
	return J.cmp(J.gp(v_w_3103, "t"), 0.0, ">")

func _f494(this_, a: Array, env):
	var v_f_3084 = null
	var _s1172 = {"__p": env, "dt": null, "T": null}
	_s1172["dt"] = J.arg(a, 0)
	var _t3327 = J.gp(_s1172["__p"]["G"], "taoWant")
	var _t3328 = ((not J.t(J.gp(_s1172["__p"]["G"], "tao"))) if J.t(_t3327) else _t3327)
	if J.t(((not J.t(J.gp(_s1172["__p"]["G"], "gate"))) if J.t(_t3328) else _t3328)):
		var _t3329 = _s1172["__p"]["G"]
		var _t3330 = J.sub((2.0 if J.leq(J.gp(_s1172["__p"]["G"], "taoCd"), null) else J.gp(_s1172["__p"]["G"], "taoCd")), _s1172["dt"])
		J.sp(_t3329, "taoCd", _t3330)
		if J.cmp(J.gp(_s1172["__p"]["G"], "taoCd"), 0.0, "<="):
			v_f_3084 = (1.0 + floor(J.num(J.mul(J.cl(_s1172["__p"]["rnd"], null, []), J.sub(_s1172["__p"]["FL"], 1.0)))))
			var _t3331 = _s1172["__p"]["spawnTao"]
			J.cl(_t3331, null, [v_f_3084, (_s1172["__p"]["SX"] if J.cmp(J.cl(_s1172["__p"]["rnd"], null, []), 0.5, "<") else _s1172["__p"]["LX"])])
	_s1172["T"] = J.gp(_s1172["__p"]["G"], "tao")
	if (not J.t(_s1172["T"])):
		return null
	var _t3332 = _s1172["T"]
	var _t3333 = J.sub(J.gp(_t3332, "life"), _s1172["dt"])
	J.sp(_t3332, "life", _t3333)
	var _t3334 = _s1172["T"]
	var _t3335 = J.add(J.gp(_t3334, "x"), J.mul(J.mul(J.gp(_s1172["T"], "dir"), 36.0), _s1172["dt"]))
	J.sp(_t3334, "x", _t3335)
	var _t3336 = J.cmp(J.gp(_s1172["T"], "x"), J.sub(_s1172["__p"]["LX"], 10.0), ">")
	if (_t3336 if _t3336 else J.cmp(J.gp(_s1172["T"], "x"), J.add(_s1172["__p"]["SX"], 10.0), "<")):
		var _t3337 = _s1172["T"]
		var _t3338 = J.mul(J.gp(_t3337, "dir"), (-1.0))
		J.sp(_t3337, "dir", _t3338)
	var _t3339 = _s1172["T"]
	var _t3340 = J.sub(J.gp(_t3339, "sayT"), _s1172["dt"])
	J.sp(_t3339, "sayT", _t3340)
	var _t3341 = _s1172["T"]
	var _t3342 = J.sub(J.gp(_t3341, "ringT"), _s1172["dt"])
	J.sp(_t3341, "ringT", _t3342)
	if J.cmp(J.gp(_s1172["T"], "ringT"), 0.0, "<="):
		var _t3343 = _s1172["T"]
		J.sp(_t3343, "ringT", 4.0)
		var _t3344 = J.gp(_s1172["T"], "waves")
		J.mc(_t3344, "push", [{"r": 10.0, "t": 1.0}])
		var _t3345 = _s1172["T"]
		var _t3346 = _s1172["__p"]["pick"]
		var _t3347 = J.cl(_t3346, null, [_s1172["__p"]["TAOL"]])
		J.sp(_t3345, "say", _t3347)
		var _t3348 = _s1172["T"]
		J.sp(_t3348, "sayT", 2.4)
		var _t3349 = J.gp(_s1172["__p"]["G"], "gh")
		J.mc(_t3349, "forEach", [Callable(self, "_f495").bind(_s1172)])
	var _t3370 = J.gp(_s1172["T"], "waves")
	J.mc(_t3370, "forEach", [Callable(self, "_f498").bind(_s1172)])
	var _t3373 = _s1172["T"]
	var _t3374 = J.gp(_s1172["T"], "waves")
	var _t3375 = J.mc(_t3374, "filter", [Callable(self, "_f499").bind(_s1172)])
	J.sp(_t3373, "waves", _t3375)
	if J.cmp(J.gp(_s1172["T"], "life"), 0.0, "<="):
		var _t3376 = _s1172["__p"]["G"]
		J.sp(_t3376, "tao", null)
		var _t3377 = _s1172["__p"]["G"]
		var _t3378 = (16.0 + J.mul(J.cl(_s1172["__p"]["rnd"], null, []), 10.0))
		J.sp(_t3377, "taoCd", _t3378)

func _f500(this_, a: Array, env):
	var v_g_3106 = null; var v_n_3107 = null
	v_g_3106 = J.gp(J.gp(env["G"], "gh"), J.gp(env["G"], "active"))
	v_n_3107 = J.gp(J.gp(env["G"], "nodes"), J.gp(v_g_3106, "node"))
	var _t3379 = J.gp(env["G"], "gate")
	var _t3380 = (_t3379 if J.t(_t3379) else J.gp(v_g_3106, "to"))
	if J.t((_t3380 if J.t(_t3380) else (not J.seq(J.gp(v_n_3107, "kind"), "portal")))):
		return null
	var _t3381 = env["standStill"]
	J.cl(_t3381, null, [v_g_3106])
	var _t3382 = env["calm"]
	J.cl(_t3382, null, [v_g_3106])
	var _t3383 = env["G"]
	J.sp(_t3383, "gateCharge", 0.001)
	var _t3384 = env["G"]
	var _t3385 = J.gp(v_g_3106, "i")
	J.sp(_t3384, "gateG", _t3385)

func _f502(this_, a: Array, env):
	var v_g_3119 = null
	v_g_3119 = J.arg(a, 0)
	return (not J.t(J.gp(v_g_3119, "out")))

func _f503(this_, a: Array, env):
	var v_g_3122 = null
	v_g_3122 = J.arg(a, 0)
	J.sp(v_g_3122, "home", true)

func _f501(this_, a: Array, env):
	var v_dt_3110 = null; var v_g_3111 = null; var v_Gt_3112 = null; var v_side_3113 = null; var v_h_3114 = null; var v_d_3115 = null; var v_alive_3116 = null
	v_dt_3110 = J.arg(a, 0)
	var _t3386 = J.cmp(J.gp(env["G"], "gateCharge"), 0.0, ">")
	if ((not J.t(J.gp(env["G"], "gate"))) if _t3386 else _t3386):
		v_g_3111 = J.gp(J.gp(env["G"], "gh"), J.gp(env["G"], "gateG"))
		var _t3387 = J.gp(v_g_3111, "to")
		var _t3388 = (_t3387 if J.t(_t3387) else J.cmp(J.gp(v_g_3111, "still"), 0.1, "<"))
		if J.t((_t3388 if J.t(_t3388) else (not J.seq(J.gp(J.gp(J.gp(env["G"], "nodes"), J.gp(v_g_3111, "node")), "kind"), "portal")))):
			var _t3389 = env["G"]
			J.sp(_t3389, "gateCharge", 0.0)
			var _t3390 = env["float"]
			J.cl(_t3390, null, [J.gp(v_g_3111, "x"), J.sub(J.gp(v_g_3111, "y"), 80.0), "郁咗，陰門開唔到", "#ffb0b0"])
		else:
			var _t3391 = env["G"]
			var _t3392 = J.add(J.gp(_t3391, "gateCharge"), v_dt_3110)
			J.sp(_t3391, "gateCharge", _t3392)
			if J.cmp(J.gp(env["G"], "gateCharge"), 1.0, ">="):
				var _t3393 = env["G"]
				J.sp(_t3393, "gateCharge", 0.0)
				var _t3394 = env["G"]
				var _t3395 = {"t": 0.0, "f": J.gp(J.gp(J.gp(env["G"], "nodes"), J.gp(v_g_3111, "node")), "f"), "node": J.gp(v_g_3111, "node"), "sp": 1.2, "fin": false}
				J.sp(_t3394, "gate", _t3395)
				var _t3396 = env["G"]
				J.sp(_t3396, "tao", null)
				var _t3397 = env["toast"]
				J.cl(_t3397, null, ["陰門開咗！企穩 30 秒——樓梯封住，追兵會越嚟越快，最後 8 秒天師會喺你兩邊出現。"])
				var _t3398 = env["G"]
				J.sp(_t3398, "shake", 0.5)
	v_Gt_3112 = J.gp(env["G"], "gate")
	if (not J.t(v_Gt_3112)):
		return null
	var _t3399 = J.add(J.gp(v_Gt_3112, "t"), v_dt_3110)
	J.sp(v_Gt_3112, "t", _t3399)
	var _t3400 = J.sub(J.gp(v_Gt_3112, "sp"), v_dt_3110)
	J.sp(v_Gt_3112, "sp", _t3400)
	if J.cmp(J.gp(v_Gt_3112, "sp"), 0.0, "<="):
		var _t3401 = (2.6 if J.cmp(J.gp(v_Gt_3112, "t"), 20.0, "<") else 1.4)
		J.sp(v_Gt_3112, "sp", _t3401)
		v_side_3113 = J.cmp(J.cl(env["rnd"], null, []), 0.5, "<")
		var _t3402 = env["mkHuman"]
		v_h_3114 = J.cl(_t3402, null, ["guard", ((J.add("f", J.gp(v_Gt_3112, "f")) + "_") + ("s" if J.t(v_side_3113) else "l")), {"state": "chase"}])
		var _t3403 = J.gp(env["G"], "guards")
		J.mc(_t3403, "push", [v_h_3114])
	var _t3404 = J.cmp(J.gp(v_Gt_3112, "t"), 22.0, ">=")
	if ((not J.t(J.gp(v_Gt_3112, "fin"))) if _t3404 else _t3404):
		J.sp(v_Gt_3112, "fin", true)
		v_g_3111 = J.gp(J.gp(env["G"], "gh"), J.gp(env["G"], "active"))
		var _t3405 = env["spawnTao"]
		J.cl(_t3405, null, [J.gp(v_Gt_3112, "f"), J.max_([J.add(env["SX"], 10.0), J.sub(J.gp(v_g_3111, "x"), 120.0)])])
		var _t3406 = J.gp(env["G"], "tao")
		J.sp(_t3406, "ringT", 1.5)
		var _t3407 = env["mkHuman"]
		v_d_3115 = J.cl(_t3407, null, ["mirror", (J.add("f", J.gp(v_Gt_3112, "f")) + "_l")])
		var _t3408 = (-1.0)
		J.sp(v_d_3115, "dir", _t3408)
		var _t3409 = J.gp(env["G"], "guards")
		J.mc(_t3409, "push", [v_d_3115])
		var _t3410 = env["toast"]
		J.cl(_t3410, null, ["最後 8 秒！天師同道士喺兩邊殺到，頂住！"])
	if J.cmp(J.gp(v_Gt_3112, "t"), 30.0, ">="):
		var _t3411 = J.gp(env["G"], "gh")
		v_alive_3116 = J.mc(_t3411, "filter", [Callable(self, "_f502").bind(env)])
		J.mc(v_alive_3116, "forEach", [Callable(self, "_f503").bind(env)])
		var _t3412 = env["endNight"]
		J.cl(_t3412, null, ["gate"])

func _f505(this_, a: Array, env):
	var v_g_3127 = null
	v_g_3127 = J.arg(a, 0)
	if (not J.t(J.gp(v_g_3127, "out"))):
		J.sp(v_g_3127, "home", true)

func _f504(this_, a: Array, env):
	var _t3413 = J.cmp(J.gp(env["G"], "dolls"), 6.0, "<")
	if J.t((_t3413 if _t3413 else J.gp(env["G"], "gate"))):
		return null
	var _t3414 = J.gp(env["G"], "gh")
	J.mc(_t3414, "forEach", [Callable(self, "_f505").bind(env)])
	var _t3415 = env["endNight"]
	J.cl(_t3415, null, ["doll"])

func _f507(this_, a: Array, env):
	var v_g_3138 = null
	v_g_3138 = J.arg(a, 0)
	return (not J.t(J.gp(v_g_3138, "out")))

func _f506(this_, a: Array, env):
	var v_why_3130 = null; var v_kept_3131 = null; var v_story_3132 = null; var v_sv_3133 = null; var v_first_3134 = null; var v_rw_3135 = null; var v_e_3139 = null
	v_why_3130 = J.arg(a, 0)
	if J.t(J.gp(env["G"], "over")):
		return null
	v_kept_3131 = (J.len(J.gp(env["G"], "bag")) if J.seq(v_why_3130, "gate") else (floor(J.num(J.div(J.len(J.gp(env["G"], "bag")), 2.0))) if J.seq(v_why_3130, "doll") else 0.0))
	v_story_3132 = (J.len(J.gp(env["G"], "story")) if J.seq(v_why_3130, "gate") else 0.0)
	var _t3416 = env["G"]
	var _t3418 = (not J.seq(v_why_3130, "fail"))
	var _t3419 = J.sub(J.len(J.gp(env["G"], "bag")), v_kept_3131)
	var _t3417 = J.gp(env["G"], "gh")
	var _t3420 = {"ok": _t3418, "why": v_why_3130, "kept": v_kept_3131, "lost": _t3419, "home": J.len(J.mc(_t3417, "filter", [Callable(self, "_f507").bind(env)])), "fear": J.gp(env["G"], "fearTotal"), "story": v_story_3132, "storyLost": (J.len(J.gp(env["G"], "story")) if J.seq(v_why_3130, "doll") else 0.0), "alert": J.gp(env["G"], "alert")}
	J.sp(_t3416, "over", _t3420)
	var _t3421 = env["gpOnEnd"]
	J.cl(_t3421, null, [v_why_3130])
	v_sv_3133 = J.cl(env["TS"], null, [])
	var _t3422 = J.seq(v_why_3130, "gate")
	v_first_3134 = ((not J.t(J.gp(v_sv_3133, J.add("gate_", env["curLv"])))) if _t3422 else _t3422)
	if J.t(v_first_3134):
		var _t3423 = J.add("gate_", env["curLv"])
		J.sp(v_sv_3133, _t3423, 1.0)
	var _t3424 = J.gp(v_sv_3133, "nights")
	var _t3425 = J.add((_t3424 if J.t(_t3424) else 0.0), 1.0)
	J.sp(v_sv_3133, "nights", _t3425)
	var _t3428 = (((40.0 + J.mul(15.0, v_kept_3131)) + J.mul(25.0, v_story_3132)) if J.seq(v_why_3130, "gate") else ((20.0 + J.mul(8.0, v_kept_3131)) if J.seq(v_why_3130, "doll") else 0.0))
	var _t3427 = null
	if (not J.seq(v_why_3130, "fail")):
		var _t3426 = J.gp(env["G"], "unitCoins")
		_t3427 = (_t3426 if J.t(_t3426) else 0.0)
	else:
		_t3427 = 0.0
	v_rw_3135 = J.add(_t3428, _t3427)
	if J.t(v_first_3134):
		var _t3429 = J.add(v_rw_3135, 100.0)
		v_rw_3135 = _t3429
	if (not J.seq(v_why_3130, "fail")):
		var _t3430 = J.gp(v_sv_3133, "best")
		var _t3431 = J.gp(v_sv_3133, "best")
		var _t3432 = J.max_([(_t3431 if J.t(_t3431) else 0.0), v_kept_3131])
		J.sp(v_sv_3133, "best", _t3432)
		var _t3433 = J.gp(v_sv_3133, "cleared")
		var _t3434 = env["curLv"]
		J.sp(_t3433, _t3434, 1.0)
	var _t3435 = J.gp(env["G"], "over")
	J.sp(_t3435, "reward", v_rw_3135)
	var _t3436 = J.gp(J.G.get("S"), "res")
	var _t3437 = J.add(J.gp(_t3436, "coins"), v_rw_3135)
	J.sp(_t3436, "coins", _t3437)
	J.cl(J.G.get("save"), null, [])

func _f508(this_, a: Array, env):
	var v_r_3142 = null; var v_t_3143 = null
	v_r_3142 = J.arg(a, 0)
	v_t_3143 = J.arg(a, 1)
	J.sp(v_r_3142, "say", v_t_3143)
	J.sp(v_r_3142, "sayT", 2.6)

func _f510(this_, a: Array, env):
	var v_o_3152 = null
	v_o_3152 = J.arg(a, 0)
	var _t3447 = (not J.seq(v_o_3152, env["r"]))
	if (J.seq(J.gp(v_o_3152, "state"), "home") if _t3447 else _t3447):
		J.sp(v_o_3152, "awake", true)
		J.sp(v_o_3152, "woke", true)
		var _t3449 = J.mul(env["amt"], 0.35)
		var _t3448 = env["__p"]["gpF"]
		var _t3450 = J.add(J.gp(v_o_3152, "fear"), (J.mul(_t3449, J.cl(_t3448, null, [env["g"]])) * J.sub(1.0, J.gp(v_o_3152, "brave"))))
		J.sp(v_o_3152, "fear", _t3450)
		J.sp(v_o_3152, "jumpT", 0.4)
		var _t3451 = J.cmp(J.gp(v_o_3152, "fear"), 100.0, ">=")
		if ((not J.cmp(J.gp(v_o_3152, "fleeAfter"), 0.0, ">")) if _t3451 else _t3451):
			J.sp(v_o_3152, "fleeAfter", 1.0)
			var _t3452 = env["g"]
			J.sp(v_o_3152, "fleeG", _t3452)

func _f509(this_, a: Array, env):
	var v_k_3149 = null
	var _s1203 = {"__p": env, "r": null, "amt": null, "g": null}
	_s1203["r"] = J.arg(a, 0)
	_s1203["amt"] = J.arg(a, 1)
	_s1203["g"] = J.arg(a, 2)
	if (not J.seq(J.gp(_s1203["r"], "state"), "home")):
		return null
	if (not J.t(J.gp(_s1203["r"], "awake"))):
		var _t3438 = _s1203["r"]
		J.sp(_t3438, "awake", true)
		var _t3439 = _s1203["r"]
		J.sp(_t3439, "woke", true)
		var _t3440 = J.mul(_s1203["amt"], 0.6)
		_s1203["amt"] = _t3440
	var _t3441 = _s1203["r"]
	var _t3443 = J.mul(_s1203["amt"], J.gp(J.gp(_s1203["__p"]["G"], "mods"), "pow"))
	var _t3442 = _s1203["__p"]["gpF"]
	var _t3444 = J.add(J.gp(_t3441, "fear"), (J.mul(_t3443, J.cl(_t3442, null, [_s1203["g"]])) * J.sub(1.0, J.gp(_s1203["r"], "brave"))))
	J.sp(_t3441, "fear", _t3444)
	var _t3445 = J.gp(_s1203["r"], "unit")
	if J.t((J.gp(J.gp(_s1203["r"], "unit"), "rs") if J.t(_t3445) else _t3445)):
		var _t3446 = J.gp(J.gp(_s1203["r"], "unit"), "rs")
		J.mc(_t3446, "forEach", [Callable(self, "_f510").bind(_s1203)])
	var _t3453 = _s1203["r"]
	J.sp(_t3453, "jumpT", 0.5)
	if J.t(_s1203["g"]):
		var _t3454 = _s1203["g"]
		var _t3455 = J.min_([100.0, J.add(J.gp(_s1203["g"], "energy"), (8.0 if J.t(J.gp(_s1203["r"], "brave")) else 18.0))])
		J.sp(_t3454, "energy", _t3455)
	v_k_3149 = 0.0
	while true:
		if not J.cmp(v_k_3149, 5.0, "<"): break
		var _t3456 = _s1203["__p"]["part"]
		J.cl(_t3456, null, [J.gp(_s1203["r"], "x"), J.sub(J.gp(_s1203["r"], "y"), 48.0), (J.sub(J.cl(_s1203["__p"]["rnd"], null, []), 0.5) * 90.0), ((-60.0) - J.mul(J.cl(_s1203["__p"]["rnd"], null, []), 40.0)), 0.6, "sweat"])
		v_k_3149 = J.num(v_k_3149) + 1.0
	var _t3457 = _s1203["__p"]["doReact"]
	J.cl(_t3457, null, [_s1203["r"], _s1203["g"]])
	var _t3458 = J.cmp(J.gp(_s1203["r"], "fear"), 100.0, ">=")
	if ((not J.cmp(J.gp(_s1203["r"], "fleeAfter"), 0.0, ">")) if _t3458 else _t3458):
		var _t3459 = _s1203["r"]
		J.sp(_t3459, "fleeAfter", 0.9)
		var _t3460 = _s1203["r"]
		var _t3461 = _s1203["g"]
		J.sp(_t3460, "fleeG", _t3461)

func _f512(this_, a: Array, env):
	var v_u_3159 = null
	v_u_3159 = J.arg(a, 0)
	var _t3477 = J.seq(J.gp(v_u_3159, "ot"), 1.0)
	var _t3478 = (J.seq(J.gp(v_u_3159, "dep"), J.gp(env["r"], "unit")) if _t3477 else _t3477)
	if ((not J.t(J.gp(v_u_3159, "open"))) if _t3478 else _t3478):
		var _t3479 = env["__p"]["unlockUnit"]
		J.cl(_t3479, null, [v_u_3159, "隔籬人心惶惶，入得喇（黑屋）"])

func _f511(this_, a: Array, env):
	var v_g_3156 = null
	var _s1210 = {"__p": env, "r": null}
	_s1210["r"] = J.arg(a, 0)
	v_g_3156 = J.arg(a, 1)
	var _t3462 = _s1210["r"]
	J.sp(_t3462, "state", "flee")
	var _t3463 = _s1210["r"]
	var _t3464 = _s1210["__p"]["fy"]
	var _t3465 = J.cl(_t3464, null, [J.gp(J.gp(_s1210["r"], "unit"), "f")])
	J.sp(_t3463, "y", _t3465)
	var _t3466 = _s1210["r"]
	var _t3467 = (((-1.0) if J.cmp(J.gp(_s1210["r"], "x"), J.div(_s1210["__p"]["WW"], 2.0), "<") else 1.0) * 150.0)
	J.sp(_t3466, "vx", _t3467)
	var _t3468 = _s1210["__p"]["chain"]
	var _t3470 = J.gp(_s1210["r"], "unit")
	var _t3469 = J.gp(_s1210["r"], "chainD")
	J.cl(_t3468, null, [_t3470, 16.0, (_t3469 if J.t(_t3469) else 0.0)])
	var _t3471 = _s1210["r"]
	var _t3472 = (0.9 if J.cmp(J.cl(_s1210["__p"]["rnd"], null, []), 0.35, "<") else 0.0)
	J.sp(_t3471, "tripT", _t3472)
	var _t3473 = _s1210["__p"]["pplScream"]
	J.cl(_t3473, null, [_s1210["r"]])
	if J.t(v_g_3156):
		var _t3474 = J.min_([100.0, J.add(J.gp(v_g_3156, "energy"), 20.0)])
		J.sp(v_g_3156, "energy", _t3474)
	var _t3475 = _s1210["__p"]["addFear"]
	J.cl(_t3475, null, [J.round(J.num(J.mul(15.0, J.gp(J.gp(_s1210["__p"]["G"], "mods"), "fear")))), J.gp(_s1210["r"], "x"), J.sub(J.gp(_s1210["r"], "y"), 80.0)])
	var _t3476 = J.gp(_s1210["__p"]["G"], "units")
	J.mc(_t3476, "forEach", [Callable(self, "_f512").bind(_s1210)])
	var _t3481 = J.gp(J.gp(_s1210["r"], "unit"), "story")
	if J.t(_t3481):
		var _t3480 = J.gp(_s1210["__p"]["G"], "story")
		_t3481 = J.cmp(J.mc(_t3480, "indexOf", [J.gp(J.gp(_s1210["r"], "unit"), "si")]), 0.0, "<")
	if J.t(_t3481):
		var _t3482 = J.gp(_s1210["__p"]["G"], "story")
		J.mc(_t3482, "push", [J.gp(J.gp(_s1210["r"], "unit"), "si")])
		J.mc(J.gp(_s1210["__p"]["G"], "story"), "sort", [])
		var _t3483 = _s1210["__p"]["toast"]
		J.cl(_t3483, null, [(J.add("收集到故事碎片——", J.gp(_s1210["__p"]["STORY"], J.gp(J.gp(_s1210["r"], "unit"), "si"))) + "（要正規經陰門返去先帶得走）")])

func _f513(this_, a: Array, env):
	var v_a_3162 = null; var v_x_3163 = null; var v_y_3164 = null
	v_a_3162 = J.arg(a, 0)
	v_x_3163 = J.arg(a, 1)
	v_y_3164 = J.arg(a, 2)
	var _t3484 = env["G"]
	var _t3485 = J.add(J.gp(_t3484, "fear"), v_a_3162)
	J.sp(_t3484, "fear", _t3485)
	var _t3486 = env["G"]
	var _t3487 = J.add(J.gp(_t3486, "fearTotal"), v_a_3162)
	J.sp(_t3486, "fearTotal", _t3487)
	var _t3488 = env["float"]
	J.cl(_t3488, null, [v_x_3163, v_y_3164, J.add("怕意 +", v_a_3162), "#9fd6bf"])
	if J.cmp(J.gp(env["G"], "fearTotal"), J.gp(env["G"], "fearNext"), ">="):
		var _t3489 = env["G"]
		var _t3490 = J.add(J.gp(_t3489, "fearNext"), 30.0)
		J.sp(_t3489, "fearNext", _t3490)
		var _t3491 = env["G"]
		var _t3492 = J.gp(env["G"], "choiceQ")
		var _t3493 = J.add((_t3492 if J.t(_t3492) else 0.0), 1.0)
		J.sp(_t3491, "choiceQ", _t3493)

func _f514(this_, a: Array, env):
	var v_g_3167 = null
	v_g_3167 = J.arg(a, 0)
	J.sp(v_g_3167, "auto", null)
	J.sp(v_g_3167, "autoS", null)
	if J.t(env["joy"]):
		env["joy"] = null

func _f515(this_, a: Array, env):
	var v_g_3170 = null
	v_g_3170 = J.arg(a, 0)
	var _t3494 = J.gp(v_g_3170, "still")
	var _t3495 = J.gp(v_g_3170, "still")
	var _t3496 = J.max_([(_t3495 if J.t(_t3495) else 0.0), 0.12])
	J.sp(v_g_3170, "still", _t3496)
	J.sp(v_g_3170, "mv", 0.0)

func _f518(this_, a: Array, env):
	var v_k_3197 = null; var v_m_3198 = null
	v_k_3197 = J.arg(a, 0)
	v_m_3198 = J.gp(J.gp(env["__p"]["G"], "nodes"), v_k_3197)
	var _t3498 = J.add(env["L"], J.hypot_([J.sub(J.gp(v_m_3198, "x"), J.gp(env["c"], "x")), J.sub(J.gp(v_m_3198, "y"), J.gp(env["c"], "y"))]))
	env["L"] = _t3498
	env["c"] = v_m_3198

func _f517(this_, a: Array, env):
	var v_st_3191 = null; var v_arr_3192 = null
	var _s1220 = {"__p": env, "L": null, "c": null}
	v_st_3191 = J.arg(a, 0)
	v_arr_3192 = J.arg(a, 1)
	_s1220["L"] = 0.0
	_s1220["c"] = J.gp(J.gp(_s1220["__p"]["G"], "nodes"), v_st_3191)
	var _t3497 = (v_arr_3192 if J.t(v_arr_3192) else [])
	J.mc(_t3497, "forEach", [Callable(self, "_f518").bind(_s1220)])
	return _s1220["L"]

func _f516(this_, a: Array, env):
	var v_g_3173 = null; var v_target_3174 = null; var v_ok_3175 = null; var v_a_3176 = null; var v_b_3177 = null; var v_p_3178 = null; var v_na_3179 = null; var v_nb_3180 = null; var v_E_3181 = null; var v_okB_3182 = null; var v_pB_3183 = null; var v_okA_3184 = null; var v_pA_3185 = null; var v_cB_3186 = null; var v_cA_3187 = null; var v_plen_3188 = null
	v_g_3173 = J.arg(a, 0)
	v_target_3174 = J.arg(a, 1)
	v_plen_3188 = Callable(self, "_f517").bind(env)
	if (not J.t(J.gp(v_g_3173, "to"))):
		if J.seq(J.gp(v_g_3173, "node"), v_target_3174):
			return true
		var _t3499 = env["gotoNode"]
		v_ok_3175 = J.cl(_t3499, null, [v_g_3173, v_target_3174])
		return v_ok_3175
	v_a_3176 = J.gp(v_g_3173, "node")
	v_b_3177 = J.gp(v_g_3173, "to")
	v_p_3178 = J.gp(v_g_3173, "p")
	v_na_3179 = J.gp(J.gp(env["G"], "nodes"), v_a_3176)
	v_nb_3180 = J.gp(J.gp(env["G"], "nodes"), v_b_3177)
	v_E_3181 = J.hypot_([J.sub(J.gp(v_nb_3180, "x"), J.gp(v_na_3179, "x")), J.sub(J.gp(v_nb_3180, "y"), J.gp(v_na_3179, "y"))])
	J.sp(v_g_3173, "to", null)
	J.sp(v_g_3173, "node", v_b_3177)
	var _t3500 = env["gotoNode"]
	v_okB_3182 = J.cl(_t3500, null, [v_g_3173, v_target_3174])
	v_pB_3183 = J.gp(v_g_3173, "auto")
	J.sp(v_g_3173, "node", v_a_3176)
	var _t3501 = env["gotoNode"]
	v_okA_3184 = J.cl(_t3501, null, [v_g_3173, v_target_3174])
	v_pA_3185 = J.gp(v_g_3173, "auto")
	J.sp(v_g_3173, "auto", null)
	J.sp(v_g_3173, "node", v_a_3176)
	J.sp(v_g_3173, "to", v_b_3177)
	J.sp(v_g_3173, "p", v_p_3178)
	v_cB_3186 = (J.add(J.mul(v_E_3181, J.sub(1.0, v_p_3178)), J.cl(v_plen_3188, null, [v_b_3177, v_pB_3183])) if J.t(v_okB_3182) else 1000000000.0)
	v_cA_3187 = (J.add(J.mul(v_E_3181, v_p_3178), J.cl(v_plen_3188, null, [v_a_3176, v_pA_3185])) if J.t(v_okA_3184) else 1000000000.0)
	var _t3502 = (not J.t(v_okA_3184))
	if ((not J.t(v_okB_3182)) if _t3502 else _t3502):
		return false
	if J.cmp(v_cA_3187, v_cB_3186, "<"):
		J.sp(v_g_3173, "node", v_b_3177)
		J.sp(v_g_3173, "to", v_a_3176)
		var _t3503 = J.sub(1.0, v_p_3178)
		J.sp(v_g_3173, "p", _t3503)
		var _t3504 = [v_a_3176]
		var _t3505 = J.mc(_t3504, "concat", [(v_pA_3185 if J.t(v_pA_3185) else [])])
		J.sp(v_g_3173, "auto", _t3505)
	else:
		var _t3506 = [v_b_3177]
		var _t3507 = J.mc(_t3506, "concat", [(v_pB_3183 if J.t(v_pB_3183) else [])])
		J.sp(v_g_3173, "auto", _t3507)
	return true

func _f520(this_, a: Array, env):
	var v_r_3208 = null; var v_d_3209 = null
	v_r_3208 = J.arg(a, 0)
	var _t3509 = (not J.seq(J.gp(v_r_3208, "state"), "home"))
	var _t3510 = (_t3509 if _t3509 else (not J.t(J.gp(v_r_3208, "unit"))))
	if (_t3510 if _t3510 else (not J.seq(J.gp(J.gp(v_r_3208, "unit"), "f"), env["f"]))):
		return null
	v_d_3209 = absf(J.num(J.sub(J.gp(v_r_3208, "x"), J.gp(env["g"], "x"))))
	if J.cmp(v_d_3209, env["bd"], "<"):
		env["bd"] = v_d_3209
		env["best"] = v_r_3208

func _f519(this_, a: Array, env):
	var v_R_3202 = null
	var _s1223 = {"__p": env, "g": null, "f": null, "best": null, "bd": null}
	_s1223["g"] = J.arg(a, 0)
	v_R_3202 = J.arg(a, 1)
	_s1223["f"] = J.gp(J.gp(J.gp(_s1223["__p"]["G"], "nodes"), J.gp(_s1223["g"], "node")), "f")
	_s1223["best"] = null
	_s1223["bd"] = v_R_3202
	var _t3508 = J.gp(_s1223["__p"]["G"], "res")
	J.mc(_t3508, "forEach", [Callable(self, "_f520").bind(_s1223)])
	return _s1223["best"]

func _f522(this_, a: Array, env):
	var v_l_3219 = null
	v_l_3219 = J.arg(a, 0)
	return J.seq(J.gp(v_l_3219, "to"), J.gp(env["un"], "id"))

func _f521(this_, a: Array, env):
	var v_g_3212 = null; var v_dn_3214 = null; var v_l_3215 = null; var v_ok_3216 = null
	var _s1226 = {"__p": env, "un": null}
	v_g_3212 = J.arg(a, 0)
	_s1226["un"] = J.arg(a, 1)
	v_dn_3214 = J.gp(J.gp(_s1226["__p"]["G"], "nodes"), J.gp(_s1226["un"], "did"))
	var _t3512 = v_dn_3214
	if J.t(_t3512):
		var _t3511 = J.gp(v_dn_3214, "links")
		_t3512 = J.mc(_t3511, "find", [Callable(self, "_f522").bind(_s1226)])
	v_l_3215 = _t3512
	if (not J.t(v_l_3215)):
		return "door"
	var _t3513 = _s1226["__p"]["canPass"]
	v_ok_3216 = J.cl(_t3513, null, [v_g_3212, J.gp(v_l_3215, "e")])
	return (null if J.seq(v_ok_3216, true) else v_ok_3216)

func _f524(this_, a: Array, env):
	var v_o_3242 = null; var v_d_3243 = null
	v_o_3242 = J.arg(a, 0)
	var _t3530 = J.seq(J.gp(v_o_3242, "state"), "flee")
	if (_t3530 if _t3530 else J.seq(J.gp(v_o_3242, "state"), "gone")):
		return null
	if (absf(J.num(J.sub(J.gp(v_o_3242, "y"), J.gp(env["g"], "y")))) > 30.0):
		return null
	v_d_3243 = absf(J.num(J.sub(J.gp(v_o_3242, "x"), J.gp(env["g"], "x"))))
	if J.cmp(v_d_3243, env["bd"], "<"):
		env["bd"] = v_d_3243
		env["h"] = v_o_3242

func _f525(this_, a: Array, env):
	var v_q_3246 = null
	v_q_3246 = J.arg(a, 0)
	var _t3532 = J.seq(J.gp(v_q_3246, "state"), "home")
	var _t3533 = (J.gp(v_q_3246, "unit") if _t3532 else _t3532)
	var _t3534 = (J.seq(J.gp(J.gp(v_q_3246, "unit"), "f"), env["f0"]) if J.t(_t3533) else _t3533)
	return ((absf(J.num(J.sub(J.gp(v_q_3246, "x"), J.gp(env["g"], "x")))) < 260.0) if J.t(_t3534) else _t3534)

func _f526(this_, a: Array, env):
	var v_a_3249 = null; var v_b_3250 = null
	v_a_3249 = J.arg(a, 0)
	v_b_3250 = J.arg(a, 1)
	return (absf(J.num(J.sub(J.gp(v_a_3249, "x"), J.gp(env["g"], "x")))) - absf(J.num(J.sub(J.gp(v_b_3250, "x"), J.gp(env["g"], "x")))))

func _f527(this_, a: Array, env):
	var v_q_3253 = null
	v_q_3253 = J.arg(a, 0)
	var _t3563 = J.seq(J.gp(v_q_3253, "state"), "home")
	var _t3564 = (J.gp(v_q_3253, "unit") if _t3563 else _t3563)
	return (J.seq(J.gp(J.gp(v_q_3253, "unit"), "f"), env["f"]) if J.t(_t3564) else _t3564)

func _f528(this_, a: Array, env):
	var v_q_3256 = null
	v_q_3256 = J.arg(a, 0)
	var _t3566 = J.gp(v_q_3256, "unit")
	var _t3567 = (J.seq(J.gp(J.gp(v_q_3256, "unit"), "f"), env["f"]) if J.t(_t3566) else _t3566)
	var _t3570 = ((absf(J.num(J.sub(J.gp(v_q_3256, "x"), J.gp(env["g"], "x")))) < 190.0) if J.t(_t3567) else _t3567)
	if J.t(_t3570):
		var _t3568 = J.seq(J.gp(v_q_3256, "state"), "away")
		var _t3569 = (_t3568 if _t3568 else J.seq(J.gp(v_q_3256, "state"), "leave"))
		_t3570 = (_t3569 if _t3569 else J.seq(J.gp(v_q_3256, "state"), "back"))
	return _t3570

func _f523(this_, a: Array, env):
	var v_n_3223 = null; var v_un0_3224 = null; var v_cands_3228 = null; var v_r_3229 = null; var v_blocked_3230 = null; var v_ci_3231 = null; var v_cq_3232 = null; var v_wq_3233 = null; var v_lw_3234 = null; var v_un_3235 = null; var v_tr_3236 = null; var v_some_3238 = null; var v_out_3239 = null
	var _s1228 = {"__p": env, "g": null, "h": null, "bd": null, "f0": null, "f": null}
	_s1228["g"] = J.gp(J.gp(_s1228["__p"]["G"], "gh"), J.gp(_s1228["__p"]["G"], "active"))
	var _t3514 = (not J.t(_s1228["g"]))
	var _t3515 = (_t3514 if _t3514 else J.gp(_s1228["g"], "home"))
	if J.t((_t3515 if J.t(_t3515) else J.gp(_s1228["g"], "out"))):
		return null
	var _t3517 = (J.gp(_s1228["__p"]["LIFT"], "state") if J.t(_s1228["__p"]["LIFT"]) else _s1228["__p"]["LIFT"])
	if J.t(_t3517):
		var _t3516 = J.mc(_s1228["__p"]["LIFT"], "state", [])
		_t3517 = J.seq(J.gp((_t3516 if J.t(_t3516) else {}), "gi"), J.gp(_s1228["g"], "i"))
	if J.t(_t3517):
		return null
	if J.t(J.gp(_s1228["g"], "sc")):
		return null
	if J.cmp(J.gp(_s1228["g"], "scareCd"), 0.0, ">"):
		var _t3518 = _s1228["__p"]["float"]
		J.cl(_t3518, null, [J.gp(_s1228["g"], "x"), J.sub(J.gp(_s1228["g"], "y"), 80.0), "啱啱嚇完，等陣先", "#dddddd"])
		return null
	if J.cmp(J.gp(_s1228["g"], "stun"), 0.0, ">"):
		var _t3519 = _s1228["__p"]["float"]
		J.cl(_t3519, null, [J.gp(_s1228["g"], "x"), J.sub(J.gp(_s1228["g"], "y"), 80.0), ("跌咗落嚟，等陣先嚇得" if J.cmp(J.gp(_s1228["g"], "dropT"), 0.0, ">") else ("數緊綠豆，數完先嚇得" if J.cmp(J.gp(_s1228["g"], "countT"), 0.0, ">") else "暈緊，等陣先嚇得")), "#ffd54a"])
		return null
	var _t3520 = _s1228["__p"]["standStill"]
	J.cl(_t3520, null, [_s1228["g"]])
	if J.cmp(J.gp(_s1228["g"], "sealT"), 0.0, ">"):
		var _t3521 = _s1228["__p"]["float"]
		J.cl(_t3521, null, [J.gp(_s1228["g"], "x"), J.sub(J.gp(_s1228["g"], "y"), 80.0), "鈴聲未散，暫時嚇唔到人", "#ffe9a0"])
		return null
	var _t3522 = _s1228["__p"]["mirrorOn"]
	if J.t(J.cl(_t3522, null, [_s1228["g"]])):
		var _t3523 = _s1228["__p"]["float"]
		J.cl(_t3523, null, [J.gp(_s1228["g"], "x"), J.sub(J.gp(_s1228["g"], "y"), 80.0), "被鏡照住，嚇唔出", "#ffe9a0"])
		return null
	v_n_3223 = J.gp(J.gp(_s1228["__p"]["G"], "nodes"), J.gp(_s1228["g"], "node"))
	var _t3524 = (not J.t(J.gp(_s1228["g"], "to")))
	if (J.seq(J.gp(v_n_3223, "kind"), "in") if _t3524 else _t3524):
		var _t3525 = _s1228["__p"]["unitOf"]
		v_un0_3224 = J.cl(_t3525, null, [J.gp(v_n_3223, "id")])
		var _t3526 = J.gp(v_un0_3224, "res")
		if J.t((J.seq(J.gp(J.gp(v_un0_3224, "res"), "state"), "home") if J.t(_t3526) else _t3526)):
			var _t3527 = _s1228["__p"]["calm"]
			J.cl(_t3527, null, [_s1228["g"]])
			var _t3528 = _s1228["__p"]["startMove"]
			J.cl(_t3528, null, [_s1228["g"], J.gp(v_un0_3224, "res"), v_un0_3224])
			return null
	_s1228["h"] = null
	_s1228["bd"] = 90.0
	var _t3529 = J.gp(_s1228["__p"]["G"], "guards")
	J.mc(_t3529, "forEach", [Callable(self, "_f524").bind(_s1228)])
	_s1228["f0"] = J.gp(v_n_3223, "f")
	var _t3531 = J.gp(_s1228["__p"]["G"], "res")
	var _t3535 = J.mc(_t3531, "filter", [Callable(self, "_f525").bind(_s1228)])
	v_cands_3228 = J.mc(_t3535, "sort", [Callable(self, "_f526").bind(_s1228)])
	v_r_3229 = null
	v_blocked_3230 = null
	v_ci_3231 = 0.0
	while true:
		if not J.cmp(v_ci_3231, J.len(v_cands_3228), "<"): break
		v_cq_3232 = J.gp(v_cands_3228, v_ci_3231)
		var _t3536 = _s1228["__p"]["doorBlock"]
		v_wq_3233 = J.cl(_t3536, null, [_s1228["g"], J.gp(v_cq_3232, "unit")])
		if (not J.t(v_wq_3233)):
			v_r_3229 = v_cq_3232
			break
		var _t3537 = (not J.t(v_blocked_3230))
		if ((absf(J.num(J.sub(J.gp(v_cq_3232, "x"), J.gp(_s1228["g"], "x")))) < 190.0) if _t3537 else _t3537):
			var _t3538 = {"r": v_cq_3232, "why": v_wq_3233}
			v_blocked_3230 = _t3538
		v_ci_3231 = J.num(v_ci_3231) + 1.0
	var _t3540 = _s1228["h"]
	if J.t(_t3540):
		var _t3539 = (not J.t(v_r_3229))
		_t3540 = (_t3539 if _t3539 else (absf(J.num(J.sub(J.gp(_s1228["h"], "x"), J.gp(_s1228["g"], "x")))) <= (absf(J.num(J.sub(J.gp(v_r_3229, "x"), J.gp(_s1228["g"], "x")))) + 20.0)))
	if J.t(_t3540):
		var _t3541 = _s1228["__p"]["calm"]
		J.cl(_t3541, null, [_s1228["g"]])
		var _t3542 = _s1228["__p"]["scareGuard"]
		J.cl(_t3542, null, [_s1228["g"], _s1228["h"]])
		return null
	if J.t((J.gp(_s1228["__p"]["LIFT"], "scareWaiting") if J.t(_s1228["__p"]["LIFT"]) else _s1228["__p"]["LIFT"])):
		v_lw_3234 = J.mc(_s1228["__p"]["LIFT"], "scareWaiting", [_s1228["g"]])
		if J.t(v_lw_3234):
			var _t3543 = _s1228["__p"]["calm"]
			J.cl(_t3543, null, [_s1228["g"]])
			var _t3544 = _s1228["g"]
			J.sp(_t3544, "scareCd", 1.2)
			var _t3545 = _s1228["g"]
			J.sp(_t3545, "actT", 0.9)
			var _t3546 = _s1228["__p"]["G"]
			J.sp(_t3546, "shake", 0.25)
			return null
	if J.t(v_r_3229):
		v_un_3235 = J.gp(v_r_3229, "unit")
		var _t3547 = J.gp(v_un_3235, "res")
		v_tr_3236 = (J.gp(v_un_3235, "res") if J.t((J.seq(J.gp(J.gp(v_un_3235, "res"), "state"), "home") if J.t(_t3547) else _t3547)) else v_r_3229)
		var _t3548 = _s1228["__p"]["approach"]
		if J.t(J.cl(_t3548, null, [_s1228["g"], J.gp(v_un_3235, "id")])):
			var _t3549 = _s1228["g"]
			var _t3550 = {"r": v_tr_3236}
			J.sp(_t3549, "autoS", _t3550)
			var _t3552 = (not J.t(J.gp(_s1228["g"], "to")))
			if J.t(_t3552):
				var _t3551 = J.gp(_s1228["g"], "auto")
				_t3552 = (not J.t((J.len(J.gp(_s1228["g"], "auto")) if J.t(_t3551) else _t3551)))
			if _t3552:
				var _t3553 = _s1228["__p"]["calm"]
				J.cl(_t3553, null, [_s1228["g"]])
				var _t3554 = _s1228["g"]
				J.sp(_t3554, "autoS", null)
				var _t3555 = _s1228["__p"]["startMove"]
				J.cl(_t3555, null, [_s1228["g"], v_tr_3236, v_un_3235])
				return null
			var _t3556 = _s1228["__p"]["float"]
			J.cl(_t3556, null, [J.gp(v_tr_3236, "x"), J.sub(J.gp(v_tr_3236, "y"), 86.0), J.add("飄埋去嚇", (J.gp(J.gp(_s1228["__p"]["HH"], J.gp(v_tr_3236, "hh")), "n") if J.t(J.gp(_s1228["__p"]["HH"], J.gp(v_tr_3236, "hh"))) else "住戶")), "#ffb7a0"])
			return null
		var _t3557 = _s1228["__p"]["float"]
		J.cl(_t3557, null, [J.gp(v_r_3229, "x"), J.sub(J.gp(v_r_3229, "y"), 80.0), "嚇唔到：行唔到入呢戶", "#ffb0b0"])
		return null
	if J.t(v_blocked_3230):
		var _t3558 = _s1228["__p"]["float"]
		var _t3560 = J.gp(_s1228["g"], "x")
		var _t3561 = J.sub(J.gp(_s1228["g"], "y"), 80.0)
		var _t3559 = J.gp(_s1228["__p"]["BLOCKMSG"], J.gp(v_blocked_3230, "why"))
		J.cl(_t3558, null, [_t3560, _t3561, J.add("嚇唔到——", (_t3559 if J.t(_t3559) else "呢戶未入得")), "#ffb0b0"])
		return null
	_s1228["f"] = J.gp(v_n_3223, "f")
	var _t3562 = J.gp(_s1228["__p"]["G"], "res")
	v_some_3238 = J.mc(_t3562, "some", [Callable(self, "_f527").bind(_s1228)])
	var _t3565 = J.gp(_s1228["__p"]["G"], "res")
	v_out_3239 = J.mc(_t3565, "some", [Callable(self, "_f528").bind(_s1228)])
	var _t3571 = _s1228["__p"]["float"]
	J.cl(_t3571, null, [J.gp(_s1228["g"], "x"), J.sub(J.gp(_s1228["g"], "y"), 80.0), ("佢出咗門，唔喺屋企" if J.t(v_out_3239) else ("附近冇人：行近住戶（或者撳住戶）先嚇" if J.t(v_some_3238) else "呢層冇人喺屋企")), "#dddddd"])

func _f529(this_, a: Array, env):
	var v_g_3259 = null; var v_h_3260 = null; var v_k_3261 = null
	v_g_3259 = J.arg(a, 0)
	v_h_3260 = J.arg(a, 1)
	J.sp(v_g_3259, "scareCd", 1.2)
	J.sp(v_g_3259, "actT", 0.9)
	var _t3572 = (1.0 if J.cmp(J.gp(v_h_3260, "x"), J.gp(v_g_3259, "x"), ">") else (-1.0))
	J.sp(v_g_3259, "dir", _t3572)
	var _t3573 = env["G"]
	J.sp(_t3573, "shake", 0.25)
	var _t3574 = J.seq(J.gp(v_h_3260, "kind"), "mirror")
	if (J.seq(signf(J.num(J.sub(J.gp(v_g_3259, "x"), J.gp(v_h_3260, "x")))), J.gp(v_h_3260, "dir")) if _t3574 else _t3574):
		var _t3575 = env["float"]
		J.cl(_t3575, null, [J.gp(v_h_3260, "x"), J.sub(J.gp(v_h_3260, "y"), 90.0), "正面對住面鏡，嚇唔到！兜去背後", "#ffe9a0"])
		return null
	var _t3576 = J.seq(J.gp(v_h_3260, "kind"), "decoy")
	if ((not J.t(J.gp(v_h_3260, "real"))) if _t3576 else _t3576):
		J.sp(v_h_3260, "state", "gone")
		v_k_3261 = 0.0
		while true:
			if not J.cmp(v_k_3261, 12.0, "<"): break
			var _t3577 = env["part"]
			J.cl(_t3577, null, [J.gp(v_h_3260, "x"), J.sub(J.gp(v_h_3260, "y"), 30.0), (J.sub(J.cl(env["rnd"], null, []), 0.5) * 120.0), ((-60.0) - J.mul(J.cl(env["rnd"], null, []), 60.0)), 0.9, "paper"])
			v_k_3261 = J.num(v_k_3261) + 1.0
		var _t3578 = env["float"]
		J.cl(_t3578, null, [J.gp(v_h_3260, "x"), J.sub(J.gp(v_h_3260, "y"), 80.0), "紙人替身！", "#e8d8b0"])
		return null
	if J.seq(J.gp(v_h_3260, "kind"), "guard"):
		var _t3579 = env["spook"]
		var _t3580 = env["pick"]
		J.cl(_t3579, null, [v_h_3260, J.cl(_t3580, null, [["嘩！有嘢喺我後面！", "乜……乜嘢嚟㗎？！"]])])
		var _t3581 = J.min_([100.0, J.add(J.gp(v_g_3259, "energy"), 15.0)])
		J.sp(v_g_3259, "energy", _t3581)
		return null
	J.sp(v_h_3260, "courage", J.num(J.gp(v_h_3260, "courage")) + -1.0)
	J.sp(v_h_3260, "alertT", 0.8)
	J.sp(v_h_3260, "shockT", 0.9)
	var _t3582 = env["float"]
	J.cl(_t3582, null, [J.gp(v_h_3260, "x"), J.sub(J.gp(v_h_3260, "y"), 90.0), ((J.add("羅盤保安膽量 -1（剩 ", J.max_([0.0, J.gp(v_h_3260, "courage")])) + "）") if J.seq(J.gp(v_h_3260, "kind"), "compass") else "嚇！"), "#ff7a5a"])
	if J.cmp(J.gp(v_h_3260, "courage"), 0.0, "<="):
		J.sp(v_h_3260, "state", "flee")
		var _t3583 = (((-1.0) if J.cmp(J.gp(v_h_3260, "x"), J.div(env["WW"], 2.0), "<") else 1.0) * 170.0)
		J.sp(v_h_3260, "vx", _t3583)
		var _t3584 = env["pplScream"]
		J.cl(_t3584, null, [v_h_3260])
		var _t3585 = env["addFear"]
		J.cl(_t3585, null, [(6.0 if J.seq(J.gp(v_h_3260, "kind"), "dog") else 12.0), J.gp(v_h_3260, "x"), J.sub(J.gp(v_h_3260, "y"), 80.0)])
		var _t3586 = J.min_([100.0, J.add(J.gp(v_g_3259, "energy"), 20.0)])
		J.sp(v_g_3259, "energy", _t3586)

func _f530(this_, a: Array, env):
	var v_x_3264 = null; var v_y_3265 = null; var v_vx_3266 = null; var v_vy_3267 = null; var v_life_3268 = null; var v_type_3269 = null
	v_x_3264 = J.arg(a, 0)
	v_y_3265 = J.arg(a, 1)
	v_vx_3266 = J.arg(a, 2)
	v_vy_3267 = J.arg(a, 3)
	v_life_3268 = J.arg(a, 4)
	v_type_3269 = J.arg(a, 5)
	if (J.len(J.gp(env["G"], "parts")) < 260.0):
		var _t3587 = J.gp(env["G"], "parts")
		J.mc(_t3587, "push", [{"x": v_x_3264, "y": v_y_3265, "vx": v_vx_3266, "vy": v_vy_3267, "life": v_life_3268, "max": v_life_3268, "type": v_type_3269}])

func _f532(this_, a: Array, env):
	var v_p_3276 = null
	v_p_3276 = J.arg(a, 0)
	var _t3589 = J.sub(J.gp(v_p_3276, "life"), env["dt"])
	J.sp(v_p_3276, "life", _t3589)
	var _t3590 = J.add(J.gp(v_p_3276, "x"), J.mul(J.gp(v_p_3276, "vx"), env["dt"]))
	J.sp(v_p_3276, "x", _t3590)
	var _t3591 = J.add(J.gp(v_p_3276, "y"), J.mul(J.gp(v_p_3276, "vy"), env["dt"]))
	J.sp(v_p_3276, "y", _t3591)
	var _t3592 = J.seq(J.gp(v_p_3276, "type"), "coin")
	var _t3593 = (_t3592 if _t3592 else J.seq(J.gp(v_p_3276, "type"), "crumb"))
	var _t3594 = (_t3593 if _t3593 else J.seq(J.gp(v_p_3276, "type"), "sweat"))
	var _t3595 = (_t3594 if _t3594 else J.seq(J.gp(v_p_3276, "type"), "tear"))
	var _t3596 = (_t3595 if _t3595 else J.seq(J.gp(v_p_3276, "type"), "paper"))
	if (_t3596 if _t3596 else J.seq(J.gp(v_p_3276, "type"), "drip")):
		var _t3597 = J.add(J.gp(v_p_3276, "vy"), J.mul(220.0, env["dt"]))
		J.sp(v_p_3276, "vy", _t3597)
	if J.seq(J.gp(v_p_3276, "type"), "smoke"):
		var _t3598 = J.mul(J.gp(v_p_3276, "vx"), 0.96)
		J.sp(v_p_3276, "vx", _t3598)
		var _t3599 = J.mul(J.gp(v_p_3276, "vy"), 0.96)
		J.sp(v_p_3276, "vy", _t3599)
	if (not J.leq(J.gp(v_p_3276, "tx"), null)):
		var _t3600 = J.add(J.gp(v_p_3276, "x"), (J.mul(J.sub(J.gp(v_p_3276, "tx"), J.gp(v_p_3276, "x")), env["dt"]) * 3.0))
		J.sp(v_p_3276, "x", _t3600)
		var _t3601 = J.add(J.gp(v_p_3276, "y"), (J.mul(J.sub(J.gp(v_p_3276, "ty"), J.gp(v_p_3276, "y")), env["dt"]) * 3.0))
		J.sp(v_p_3276, "y", _t3601)

func _f533(this_, a: Array, env):
	var v_p_3279 = null
	v_p_3279 = J.arg(a, 0)
	return J.cmp(J.gp(v_p_3279, "life"), 0.0, ">")

func _f534(this_, a: Array, env):
	var v_w_3282 = null
	v_w_3282 = J.arg(a, 0)
	var _t3606 = J.sub(J.gp(v_w_3282, "t"), env["dt"])
	J.sp(v_w_3282, "t", _t3606)

func _f535(this_, a: Array, env):
	var v_w_3285 = null
	v_w_3285 = J.arg(a, 0)
	return J.cmp(J.gp(v_w_3285, "t"), 0.0, ">")

func _f536(this_, a: Array, env):
	var v_u_3288 = null
	v_u_3288 = J.arg(a, 0)
	if J.cmp(J.gp(v_u_3288, "unlockFx"), 0.0, ">"):
		var _t3615 = J.sub(J.gp(v_u_3288, "unlockFx"), env["dt"])
		J.sp(v_u_3288, "unlockFx", _t3615)

func _f531(this_, a: Array, env):
	var v_k_3273 = null
	var _s1258 = {"__p": env, "dt": null}
	_s1258["dt"] = J.arg(a, 0)
	var _t3588 = J.gp(_s1258["__p"]["G"], "parts")
	J.mc(_t3588, "forEach", [Callable(self, "_f532").bind(_s1258)])
	var _t3602 = _s1258["__p"]["G"]
	var _t3603 = J.gp(_s1258["__p"]["G"], "parts")
	var _t3604 = J.mc(_t3603, "filter", [Callable(self, "_f533").bind(_s1258)])
	J.sp(_t3602, "parts", _t3604)
	var _t3605 = J.gp(_s1258["__p"]["G"], "wardFx")
	J.mc(_t3605, "forEach", [Callable(self, "_f534").bind(_s1258)])
	var _t3607 = _s1258["__p"]["G"]
	var _t3608 = J.gp(_s1258["__p"]["G"], "wardFx")
	var _t3609 = J.mc(_t3608, "filter", [Callable(self, "_f535").bind(_s1258)])
	J.sp(_t3607, "wardFx", _t3609)
	var _t3610 = _s1258["__p"]["G"]
	var _t3611 = J.gp(_s1258["__p"]["G"], "shake")
	var _t3612 = J.gp(_s1258["__p"]["G"], "shake")
	var _t3613 = J.max_([0.0, J.sub((_t3612 if J.t(_t3612) else 0.0), _s1258["dt"])])
	J.sp(_t3610, "shake", _t3613)
	var _t3614 = J.gp(_s1258["__p"]["G"], "units")
	J.mc(_t3614, "forEach", [Callable(self, "_f536").bind(_s1258)])
	for _t3616 in J.keys(J.gp(_s1258["__p"]["G"], "dark")):
		v_k_3273 = _t3616
		var _t3617 = J.gp(_s1258["__p"]["G"], "dark")
		var _t3618 = J.sub(J.gp(_t3617, v_k_3273), _s1258["dt"])
		J.sp(_t3617, v_k_3273, _t3618)
		if J.cmp(J.gp(J.gp(_s1258["__p"]["G"], "dark"), v_k_3273), 0.0, "<="):
			J.del(J.gp(_s1258["__p"]["G"], "dark"), v_k_3273)

func _f537(this_, a: Array, env):
	var v_i_3291 = null; var v_g_3292 = null
	v_i_3291 = J.arg(a, 0)
	v_g_3292 = J.gp(J.gp(env["G"], "gh"), v_i_3291)
	var _t3619 = J.cmp(J.gp(v_g_3292, "energy"), 100.0, "<")
	var _t3620 = (_t3619 if _t3619 else J.gp(v_g_3292, "home"))
	var _t3621 = (_t3620 if J.t(_t3620) else J.gp(v_g_3292, "out"))
	if J.t((_t3621 if J.t(_t3621) else J.gp(env["G"], "ult"))):
		return false
	J.sp(v_g_3292, "energy", 0.0)
	var _t3622 = env["G"]
	var _t3623 = {"g": v_g_3292, "t": 0.0, "f": J.gp(J.gp(J.gp(env["G"], "nodes"), J.gp(v_g_3292, "node")), "f"), "done": false}
	J.sp(_t3622, "ult", _t3623)
	return true

func _f539(this_, a: Array, env):
	var v_r_3304 = null
	v_r_3304 = J.arg(a, 0)
	var _t3625 = J.seq(J.gp(J.gp(v_r_3304, "unit"), "f"), env["f"])
	return (J.seq(J.gp(v_r_3304, "state"), "home") if _t3625 else _t3625)

func _f540(this_, a: Array, env):
	var v_h_3307 = null
	v_h_3307 = J.arg(a, 0)
	var _t3627 = J.seq(J.gp(J.gp(J.gp(env["__p"]["G"], "nodes"), J.gp(v_h_3307, "node")), "f"), env["f"])
	return ((not J.seq(J.gp(v_h_3307, "state"), "flee")) if _t3627 else _t3627)

func _f541(this_, a: Array, env):
	var v_r_3310 = null; var v_q_3311 = null; var v_p_3312 = null
	v_r_3310 = J.arg(a, 0)
	var _t3632 = env["__p"]["scareRes"]
	J.cl(_t3632, null, [v_r_3310, 130.0, env["g"]])
	v_q_3311 = 0.0
	while true:
		if not J.cmp(v_q_3311, 6.0, "<"): break
		v_p_3312 = {"x": J.gp(v_r_3310, "x"), "y": J.sub(J.gp(v_r_3310, "y"), 30.0), "vx": 0.0, "vy": 0.0, "life": 1.4, "max": 1.4, "type": "suck"}
		var _t3633 = J.gp(env["g"], "x")
		J.sp(v_p_3312, "tx", _t3633)
		var _t3634 = J.sub(J.gp(env["g"], "y"), 30.0)
		J.sp(v_p_3312, "ty", _t3634)
		var _t3635 = J.gp(env["__p"]["G"], "parts")
		J.mc(_t3635, "push", [v_p_3312])
		v_q_3311 = J.num(v_q_3311) + 1.0

func _f542(this_, a: Array, env):
	var v_h_3315 = null
	v_h_3315 = J.arg(a, 0)
	var _t3636 = J.gp(env["g"], "um")
	var _t3637 = J.mul(3.0, (_t3636 if J.t(_t3636) else 1.0))
	J.sp(v_h_3315, "wait", _t3637)

func _f543(this_, a: Array, env):
	var v_j_3318 = null
	v_j_3318 = J.arg(a, 0)
	return {"x": (J.max_([60.0, J.sub(J.gp(J.gp(J.gp(env["__p"]["G"], "gh"), 0.0), "x"), 260.0)]) + J.mul(v_j_3318, 110.0)), "v": ((1.0 if J.t(J.mod(v_j_3318, 2.0)) else (-1.0)) * (220.0 + J.mul(v_j_3318, 30.0)))}

func _f544(this_, a: Array, env):
	var v_u_3321 = null; var v_q_3322 = null; var v_it_3323 = null
	v_u_3321 = J.arg(a, 0)
	var _t3641 = J.seq(J.gp(v_u_3321, "f"), env["f"])
	if J.t((J.gp(v_u_3321, "open") if _t3641 else _t3641)):
		v_q_3322 = (J.len(J.gp(v_u_3321, "items")) - 1.0)
		while true:
			if not J.cmp(v_q_3322, 0.0, ">="): break
			v_it_3323 = J.gp(J.gp(v_u_3321, "items"), v_q_3322)
			var _t3642 = J.seq(v_it_3323, "money")
			var _t3643 = (_t3642 if _t3642 else J.seq(v_it_3323, "key"))
			var _t3645 = (_t3643 if _t3643 else J.seq(v_it_3323, "doll"))
			if J.t(_t3645):
				var _t3644 = (not J.seq(v_it_3323, "money"))
				_t3645 = (_t3644 if _t3644 else J.cmp(J.len(J.gp(env["__p"]["G"], "bag")), env["__p"]["BAGMAX"], "<"))
			if _t3645:
				var _t3646 = J.gp(v_u_3321, "items")
				J.mc(_t3646, "splice", [v_q_3322, 1.0])
				var _t3647 = env["__p"]["takeItem"]
				J.cl(_t3647, null, [env["g"], v_it_3323, v_u_3321])
				env["got"] = J.num(env["got"]) + 1.0
			v_q_3322 = J.num(v_q_3322) + -1.0

func _f545(this_, a: Array, env):
	var v_r_3326 = null
	v_r_3326 = J.arg(a, 0)
	var _t3649 = env["__p"]["scareRes"]
	J.cl(_t3649, null, [v_r_3326, 85.0, env["g"]])

func _f546(this_, a: Array, env):
	var v_r_3329 = null
	v_r_3329 = J.arg(a, 0)
	var _t3650 = J.gp(env["g"], "um")
	var _t3651 = J.mul(3.2, (_t3650 if J.t(_t3650) else 1.0))
	J.sp(v_r_3329, "tangle", _t3651)
	var _t3652 = env["__p"]["scareRes"]
	J.cl(_t3652, null, [v_r_3329, 105.0, env["g"]])

func _f547(this_, a: Array, env):
	var v_h_3332 = null
	v_h_3332 = J.arg(a, 0)
	var _t3653 = J.gp(env["g"], "um")
	var _t3654 = J.mul(3.2, (_t3653 if J.t(_t3653) else 1.0))
	J.sp(v_h_3332, "wait", _t3654)
	J.sp(v_h_3332, "to", null)

func _f538(this_, a: Array, env):
	var v_U_3295 = null; var v_k_3298 = null; var v_rs_3299 = null; var v_hs_3300 = null
	var _s1269 = {"__p": env, "g": null, "f": null, "got": null}
	v_U_3295 = J.arg(a, 0)
	_s1269["g"] = J.gp(v_U_3295, "g")
	_s1269["f"] = J.gp(v_U_3295, "f")
	v_k_3298 = J.gp(J.gp(_s1269["g"], "d"), "key")
	var _t3624 = J.gp(_s1269["__p"]["G"], "res")
	v_rs_3299 = J.mc(_t3624, "filter", [Callable(self, "_f539").bind(_s1269)])
	var _t3626 = J.gp(_s1269["__p"]["G"], "guards")
	v_hs_3300 = J.mc(_t3626, "filter", [Callable(self, "_f540").bind(_s1269)])
	if J.seq(v_k_3298, "eking"):
		var _t3628 = J.gp(_s1269["__p"]["G"], "dark")
		var _t3629 = _s1269["f"]
		var _t3630 = J.gp(_s1269["g"], "um")
		var _t3631 = J.mul(3.2, (_t3630 if J.t(_t3630) else 1.0))
		J.sp(_t3628, _t3629, _t3631)
		J.mc(v_rs_3299, "forEach", [Callable(self, "_f541").bind(_s1269)])
		J.mc(v_hs_3300, "forEach", [Callable(self, "_f542").bind(_s1269)])
	if J.seq(v_k_3298, "toyol"):
		var _t3638 = [0.0, 1.0, 2.0, 3.0, 4.0]
		var _t3639 = J.mc(_t3638, "map", [Callable(self, "_f543").bind(_s1269)])
		J.sp(v_U_3295, "clones", _t3639)
		_s1269["got"] = 0.0
		var _t3640 = J.gp(_s1269["__p"]["G"], "units")
		J.mc(_t3640, "forEach", [Callable(self, "_f544").bind(_s1269)])
		var _t3648 = _s1269["__p"]["float"]
		J.cl(_t3648, null, [J.gp(_s1269["g"], "x"), J.sub(J.gp(_s1269["g"], "y"), 100.0), (J.add("一掃光！攞到 ", _s1269["got"]) + " 件"), "#ffd54a"])
		J.mc(v_rs_3299, "forEach", [Callable(self, "_f545").bind(_s1269)])
	if J.seq(v_k_3298, "tianhua"):
		J.mc(v_rs_3299, "forEach", [Callable(self, "_f546").bind(_s1269)])
		J.mc(v_hs_3300, "forEach", [Callable(self, "_f547").bind(_s1269)])
	var _t3655 = _s1269["__p"]["G"]
	J.sp(_t3655, "shake", 0.5)

func _f548(this_, a: Array, env):
	var v_g_3335 = null
	v_g_3335 = J.gp(J.gp(env["G"], "gh"), J.gp(env["G"], "active"))
	var _t3656 = J.cmp(J.gp(v_g_3335, "invCd"), 0.0, ">")
	if J.t((_t3656 if _t3656 else J.gp(v_g_3335, "out"))):
		return null
	var _t3658 = J.gp(J.gp(env["G"], "mods"), "inv")
	var _t3657 = J.gp(v_g_3335, "im")
	var _t3659 = J.mul(_t3658, (_t3657 if J.t(_t3657) else 1.0))
	J.sp(v_g_3335, "inv", _t3659)
	var _t3661 = J.gp(v_g_3335, "inv")
	var _t3660 = J.gp(v_g_3335, "icd")
	var _t3662 = J.add(_t3661, J.mul(9.0, (_t3660 if J.t(_t3660) else 1.0)))
	J.sp(v_g_3335, "invCd", _t3662)
	var _t3663 = env["float"]
	J.cl(_t3663, null, [J.gp(v_g_3335, "x"), J.sub(J.gp(v_g_3335, "y"), 90.0), "隱身", "#9fe0ff"])

func _f549(this_, a: Array, env):
	var v_i_3338 = null; var v_c_3339 = null; var v_m_3340 = null
	v_i_3338 = J.arg(a, 0)
	v_c_3339 = J.gp(J.gp(env["G"], "choice"), v_i_3338)
	if (not J.t(v_c_3339)):
		return null
	v_m_3340 = J.gp(env["G"], "mods")
	if J.seq(J.gp(v_c_3339, "id"), "spd"):
		var _t3664 = J.mul(J.gp(v_m_3340, "spd"), 1.2)
		J.sp(v_m_3340, "spd", _t3664)
	if J.seq(J.gp(v_c_3339, "id"), "pow"):
		var _t3665 = J.mul(J.gp(v_m_3340, "pow"), 1.4)
		J.sp(v_m_3340, "pow", _t3665)
	if J.seq(J.gp(v_c_3339, "id"), "inv"):
		var _t3666 = J.add(J.gp(v_m_3340, "inv"), 2.0)
		J.sp(v_m_3340, "inv", _t3666)
	if J.seq(J.gp(v_c_3339, "id"), "task"):
		var _t3667 = J.mul(J.gp(v_m_3340, "task"), 1.35)
		J.sp(v_m_3340, "task", _t3667)
	if J.seq(J.gp(v_c_3339, "id"), "arm"):
		J.sp(v_m_3340, "arm", 0.5)
	if J.seq(J.gp(v_c_3339, "id"), "fear"):
		var _t3668 = J.mul(J.gp(v_m_3340, "fear"), 1.3)
		J.sp(v_m_3340, "fear", _t3668)
	var _t3669 = env["G"]
	J.sp(_t3669, "choice", null)
	var _t3670 = env["toast"]
	J.cl(_t3670, null, [J.add((J.add("揀咗「", J.gp(v_c_3339, "t")) + "」："), J.gp(v_c_3339, "d"))])

func _f550(this_, a: Array, env):
	var v_g_3343 = null; var v_r_3344 = null; var v_un_3345 = null; var v_ceil_3346 = null; var v_side_3347 = null
	v_g_3343 = J.arg(a, 0)
	v_r_3344 = J.arg(a, 1)
	v_un_3345 = J.arg(a, 2)
	var _t3671 = J.add(J.add(J.add(env["OMEN"], env["STRIKE"]), env["AFTER"]), 0.3)
	J.sp(v_g_3343, "scareCd", _t3671)
	var _t3672 = (1.0 if J.cmp(J.gp(v_r_3344, "x"), J.gp(v_g_3343, "x"), ">") else (-1.0))
	J.sp(v_g_3343, "dir", _t3672)
	var _t3673 = env["fy"]
	v_ceil_3346 = J.add(J.cl(_t3673, null, [J.add(J.gp(v_un_3345, "f"), 1.0)]), 16.0)
	v_side_3347 = (1.0 if (J.sub(J.gp(v_r_3344, "x"), J.gp(J.gp(v_un_3345, "rx"), 0.0)) < J.div(J.sub(J.gp(J.gp(v_un_3345, "rx"), 1.0), J.gp(J.gp(v_un_3345, "rx"), 0.0)), 2.0)) else (-1.0))
	var _t3674 = {"t": 0.0, "r": v_r_3344, "un": v_un_3345, "k": J.gp(J.gp(v_g_3343, "d"), "key"), "hit": false, "tr": false, "ceil": v_ceil_3346, "side": v_side_3347, "sx": J.add(J.gp(v_r_3344, "x"), J.mul(v_side_3347, 42.0))}
	J.sp(v_g_3343, "sc", _t3674)
	var _t3675 = env["float"]
	J.cl(_t3675, null, [J.gp(v_g_3343, "x"), (J.sub(J.gp(v_g_3343, "y"), J.gp(J.gp(v_g_3343, "d"), "h")) - 18.0), J.gp(J.gp(env["MV"], J.gp(J.gp(v_g_3343, "d"), "key")), "n"), "#ffb7a0"])

func _f551(this_, a: Array, env):
	var v_g_3350 = null; var v_dt_3351 = null; var v_S_3352 = null; var v_t0_3353 = null; var v_r_3354 = null; var v_k_3355 = null; var v_q_3356 = null; var v_p_3357 = null
	v_g_3350 = J.arg(a, 0)
	v_dt_3351 = J.arg(a, 1)
	v_S_3352 = J.gp(v_g_3350, "sc")
	if (not J.t(v_S_3352)):
		return null
	var _t3677 = J.cmp(J.gp(v_S_3352, "t"), env["OMEN"], "<")
	if J.t(_t3677):
		var _t3676 = J.gp(v_g_3350, "to")
		_t3677 = (_t3676 if J.t(_t3676) else J.cmp(J.gp(v_g_3350, "mv"), 0.05, ">"))
	if J.t(_t3677):
		var _t3678 = env["float"]
		J.cl(_t3678, null, [J.gp(v_g_3350, "x"), J.sub(J.gp(v_g_3350, "y"), 80.0), "一郁就破功", "#ffd54a"])
		J.sp(v_g_3350, "sc", null)
		J.sp(v_g_3350, "scareCd", 0.4)
		return null
	v_t0_3353 = J.gp(v_S_3352, "t")
	var _t3679 = J.add(J.gp(v_S_3352, "t"), v_dt_3351)
	J.sp(v_S_3352, "t", _t3679)
	v_r_3354 = J.gp(v_S_3352, "r")
	v_k_3355 = J.gp(v_S_3352, "k")
	if J.cmp(J.gp(v_S_3352, "t"), env["OMEN"], "<"):
		var _t3680 = J.seq(v_k_3355, "tianhua")
		if (J.cmp(J.cl(env["rnd"], null, []), J.mul(v_dt_3351, 9.0), "<") if _t3680 else _t3680):
			var _t3681 = env["part"]
			J.cl(_t3681, null, [J.add(J.gp(v_r_3354, "x"), (J.sub(J.cl(env["rnd"], null, []), 0.5) * 30.0)), J.add(J.gp(v_S_3352, "ceil"), 4.0), 0.0, 30.0, 0.8, "drip"])
		var _t3682 = J.seq(v_k_3355, "toyol")
		if ((not J.seq(floor(J.num(J.mul(J.gp(v_S_3352, "t"), 8.0))), floor(J.num(J.mul(v_t0_3353, 8.0))))) if _t3682 else _t3682):
			v_q_3356 = floor(J.num(J.mul(J.gp(v_S_3352, "t"), 8.0)))
			var _t3683 = J.gp(v_S_3352, "prints")
			var _t3684 = (_t3683 if J.t(_t3683) else [])
			J.sp(v_S_3352, "prints", _t3684)
			J.mc(_t3684, "push", [{"x": J.add(J.add(J.gp(v_S_3352, "sx"), J.div(J.mul(J.sub(J.gp(v_r_3354, "x"), J.gp(v_S_3352, "sx")), v_q_3356), 6.0)), (4.0 if J.t(J.mod(v_q_3356, 2.0)) else (-4.0))), "y": J.sub(J.gp(v_r_3354, "y"), 2.0)}])
	var _t3685 = (not J.t(J.gp(v_S_3352, "hit")))
	if (J.cmp(J.gp(v_S_3352, "t"), env["OMEN"], ">=") if _t3685 else _t3685):
		J.sp(v_S_3352, "hit", true)
		var _t3686 = env["G"]
		J.sp(_t3686, "shake", 0.35)
		J.sp(v_g_3350, "actT", 0.0)
		if J.seq(v_k_3355, "toyol"):
			v_q_3356 = 0.0
			while true:
				if not J.cmp(v_q_3356, 6.0, "<"): break
				v_p_3357 = {"x": J.gp(v_r_3354, "x"), "y": J.sub(J.gp(v_r_3354, "y"), 34.0), "vx": 0.0, "vy": 0.0, "life": 0.9, "max": 0.9, "type": "note"}
				var _t3687 = J.gp(v_S_3352, "sx")
				J.sp(v_p_3357, "tx", _t3687)
				var _t3688 = J.sub(J.gp(v_r_3354, "y"), 14.0)
				J.sp(v_p_3357, "ty", _t3688)
				var _t3689 = J.gp(env["G"], "parts")
				J.mc(_t3689, "push", [v_p_3357])
				v_q_3356 = J.num(v_q_3356) + 1.0
		if J.seq(v_k_3355, "eking"):
			v_q_3356 = 0.0
			while true:
				if not J.cmp(v_q_3356, 8.0, "<"): break
				var _t3690 = env["part"]
				J.cl(_t3690, null, [J.gp(v_S_3352, "sx"), J.sub(J.gp(v_r_3354, "y"), 30.0), (J.sub(J.cl(env["rnd"], null, []), 0.5) * 160.0), ((-80.0) - J.mul(J.cl(env["rnd"], null, []), 60.0)), 0.8, "crumb"])
				v_q_3356 = J.num(v_q_3356) + 1.0
		if J.seq(v_k_3355, "tianhua"):
			v_q_3356 = 0.0
			while true:
				if not J.cmp(v_q_3356, 10.0, "<"): break
				var _t3691 = env["part"]
				J.cl(_t3691, null, [J.gp(v_r_3354, "x"), J.sub(J.gp(v_r_3354, "y"), 50.0), (J.sub(J.cl(env["rnd"], null, []), 0.5) * 80.0), (-20.0), 0.7, "drip"])
				v_q_3356 = J.num(v_q_3356) + 1.0
		var _t3692 = env["scareRes"]
		J.cl(_t3692, null, [v_r_3354, 38.0, v_g_3350])
	var _t3693 = (not J.t(J.gp(v_S_3352, "tr")))
	if (J.cmp(J.gp(v_S_3352, "t"), J.add(env["OMEN"], env["STRIKE"]), ">=") if _t3693 else _t3693):
		J.sp(v_S_3352, "tr", true)
		var _t3694 = env["addTrace"]
		J.cl(_t3694, null, [J.gp(J.gp(env["MV"], v_k_3355), "tr"), v_S_3352, v_g_3350])
		if J.seq(v_k_3355, "tianhua"):
			J.sp(v_g_3350, "dropT", 2.3)
			var _t3695 = J.max_([J.gp(v_g_3350, "stun"), 2.3])
			J.sp(v_g_3350, "stun", _t3695)
			J.sp(v_g_3350, "to", null)
			J.sp(v_g_3350, "auto", null)
			var _t3696 = env["float"]
			J.cl(_t3696, null, [J.gp(v_g_3350, "x"), J.sub(J.gp(v_g_3350, "y"), 70.0), "哎吔……腰骨痛", "#e8d8b0"])
	if J.cmp(J.gp(v_S_3352, "t"), J.add(J.add(env["OMEN"], env["STRIKE"]), env["AFTER"]), ">="):
		J.sp(v_g_3350, "sc", null)

func _f553(this_, a: Array, env):
	var v_h_3369 = null; var v_hf_3370 = null; var v_d_3371 = null
	v_h_3369 = J.arg(a, 0)
	var _t3706 = (not J.seq(J.gp(v_h_3369, "kind"), "guard"))
	if (_t3706 if _t3706 else J.seq(J.gp(v_h_3369, "state"), "flee")):
		return null
	v_hf_3370 = J.gp(J.gp(J.gp(env["__p"]["G"], "nodes"), J.gp(v_h_3369, "node")), "f")
	v_d_3371 = ((absf(J.num(J.sub(v_hf_3370, J.gp(env["un"], "f")))) * 400.0) + absf(J.num(J.sub(J.gp(v_h_3369, "x"), J.gp(env["un"], "x")))))
	if J.cmp(v_d_3371, env["bd"], "<"):
		env["bd"] = v_d_3371
		env["best"] = v_h_3369

func _f552(this_, a: Array, env):
	var v_kind_3360 = null; var v_S_3361 = null; var v_g_3362 = null; var v_T_3364 = null
	var _s1305 = {"__p": env, "un": null, "best": null, "bd": null}
	v_kind_3360 = J.arg(a, 0)
	v_S_3361 = J.arg(a, 1)
	v_g_3362 = J.arg(a, 2)
	_s1305["un"] = J.gp(v_S_3361, "un")
	var _t3698 = J.gp(_s1305["un"], "f")
	var _t3699 = _s1305["un"]
	var _t3700 = (J.gp(_s1305["un"], "x") if J.seq(v_kind_3360, "hair") else J.gp(J.gp(v_S_3361, "r"), "x"))
	var _t3697 = _s1305["__p"]["fy"]
	v_T_3364 = {"k": v_kind_3360, "f": _t3698, "un": _t3699, "x": _t3700, "y": J.cl(_t3697, null, [J.gp(_s1305["un"], "f")]), "life": (40.0 if J.seq(v_kind_3360, "hair") else 22.0), "used": false, "t": 0.0}
	var _t3701 = J.gp(_s1305["__p"]["G"], "traces")
	J.mc(_t3701, "push", [v_T_3364])
	if J.seq(v_kind_3360, "mess"):
		var _t3702 = _s1305["__p"]["G"]
		var _t3703 = J.add(J.gp(_t3702, "alert"), 1.0)
		J.sp(_t3702, "alert", _t3703)
		var _t3704 = _s1305["__p"]["float"]
		J.cl(_t3704, null, [J.gp(_s1305["un"], "x"), J.sub(J.gp(_s1305["un"], "y"), 96.0), "翻箱倒櫃好嘈！全樓警覺 +1", "#ffb0b0"])
		J.cl(_s1305["__p"]["checkAlert"], null, [])
		_s1305["best"] = null
		_s1305["bd"] = 1000000000.0
		var _t3705 = J.gp(_s1305["__p"]["G"], "guards")
		J.mc(_t3705, "forEach", [Callable(self, "_f553").bind(_s1305)])
		if J.t(_s1305["best"]):
			var _t3707 = _s1305["best"]
			J.sp(_t3707, "state", "chase")
			var _t3708 = _s1305["best"]
			J.sp(_t3708, "alertT", 1.2)
			var _t3709 = _s1305["best"]
			J.sp(_t3709, "say", "邊度咁嘈？上去睇睇！")
			var _t3710 = _s1305["best"]
			J.sp(_t3710, "sayT", 2.4)
		if J.seq(J.gp(J.gp(v_S_3361, "r"), "state"), "home"):
			var _t3711 = J.gp(v_S_3361, "r")
			J.sp(_t3711, "hunt", 4.0)
			var _t3712 = _s1305["__p"]["say"]
			var _t3714 = J.gp(v_S_3361, "r")
			var _t3713 = _s1305["__p"]["pick"]
			J.cl(_t3712, null, [_t3714, J.cl(_t3713, null, [["我啲錢呢？！", "銀包去咗邊呀？！", "邊個翻亂晒啲嘢？"]])])
	if J.seq(v_kind_3360, "food"):
		J.sp(v_T_3364, "wait", 3.2)
	if J.seq(v_kind_3360, "hair"):
		var _t3715 = _s1305["__p"]["float"]
		J.cl(_t3715, null, [J.gp(_s1305["un"], "x"), J.sub(J.gp(_s1305["un"], "y"), 96.0), "門框留低濕頭髮……", "#9fe0ff"])

func _f556(this_, a: Array, env):
	var _t3728 = env["r"]
	J.sp(_t3728, "jumpT", 0.5)
	var _t3729 = env["__p"]["__p"]["say"]
	J.cl(_t3729, null, [env["r"], "嘩！碗入面有隻眼！"])
	var _t3730 = env["__p"]["__p"]["scareRes"]
	J.cl(_t3730, null, [env["r"], 30.0, null])
	var _t3731 = env["__p"]["__p"]["addFear"]
	J.cl(_t3731, null, [6.0, J.gp(env["r"], "x"), J.sub(J.gp(env["r"], "y"), 90.0)])
	var _t3732 = env["__p"]["__p"]["float"]
	J.cl(_t3732, null, [J.gp(env["r"], "x"), J.sub(J.gp(env["r"], "y"), 110.0), "二次嚇！", "#ff7a5a"])

func _f557(this_, a: Array, env):
	var v_h_3384 = null
	v_h_3384 = J.arg(a, 0)
	var _t3735 = J.gp(env["T"], "used")
	var _t3736 = (_t3735 if J.t(_t3735) else J.seq(J.gp(v_h_3384, "state"), "flee"))
	if J.t((_t3736 if J.t(_t3736) else J.seq(J.gp(v_h_3384, "kind"), "dog"))):
		return null
	var _t3737 = (not J.seq(J.gp(J.gp(J.gp(env["__p"]["__p"]["G"], "nodes"), J.gp(v_h_3384, "node")), "f"), J.gp(env["T"], "f")))
	if (_t3737 if _t3737 else (absf(J.num(J.sub(J.gp(v_h_3384, "x"), J.gp(env["T"], "x")))) > 26.0)):
		return null
	var _t3738 = env["T"]
	J.sp(_t3738, "used", true)
	J.sp(v_h_3384, "wait", 1.6)
	J.sp(v_h_3384, "to", null)
	J.sp(v_h_3384, "say", "成地都係飯……咦？碗郁咗！")
	J.sp(v_h_3384, "sayT", 2.2)
	J.sp(v_h_3384, "alertT", 1.0)
	var _t3739 = env["__p"]["__p"]["addFear"]
	J.cl(_t3739, null, [6.0, J.gp(v_h_3384, "x"), J.sub(J.gp(v_h_3384, "y"), 90.0)])
	var _t3740 = env["__p"]["__p"]["float"]
	J.cl(_t3740, null, [J.gp(v_h_3384, "x"), J.sub(J.gp(v_h_3384, "y"), 110.0), "二次嚇！", "#ff7a5a"])

func _f558(this_, a: Array, env):
	var v_h_3387 = null
	v_h_3387 = J.arg(a, 0)
	var _t3743 = (not J.t(env["vic"]))
	var _t3744 = ((not J.seq(J.gp(v_h_3387, "state"), "flee")) if _t3743 else _t3743)
	var _t3745 = ((not J.seq(J.gp(v_h_3387, "kind"), "dog")) if _t3744 else _t3744)
	var _t3746 = ((absf(J.num(J.sub(J.gp(v_h_3387, "y"), J.gp(env["T"], "y")))) < 30.0) if _t3745 else _t3745)
	if ((absf(J.num(J.sub(J.gp(v_h_3387, "x"), J.gp(env["T"], "x")))) < 18.0) if _t3746 else _t3746):
		env["vic"] = v_h_3387

func _f559(this_, a: Array, env):
	var v_r_3390 = null
	v_r_3390 = J.arg(a, 0)
	var _t3748 = (not J.t(env["vic"]))
	var _t3749 = (J.seq(J.gp(v_r_3390, "state"), "flee") if _t3748 else _t3748)
	var _t3750 = ((absf(J.num(J.sub(J.gp(v_r_3390, "y"), J.gp(env["T"], "y")))) < 30.0) if _t3749 else _t3749)
	if ((absf(J.num(J.sub(J.gp(v_r_3390, "x"), J.gp(env["T"], "x")))) < 18.0) if _t3750 else _t3750):
		env["vic"] = v_r_3390

func _f555(this_, a: Array, env):
	var _s1312 = {"__p": env, "T": null, "r": null, "vic": null}
	_s1312["T"] = J.arg(a, 0)
	var _t3717 = _s1312["T"]
	var _t3718 = J.sub(J.gp(_t3717, "life"), _s1312["__p"]["dt"])
	J.sp(_t3717, "life", _t3718)
	var _t3719 = _s1312["T"]
	var _t3720 = J.add(J.gp(_t3719, "t"), _s1312["__p"]["dt"])
	J.sp(_t3719, "t", _t3720)
	var _t3721 = J.seq(J.gp(_s1312["T"], "k"), "food")
	if ((not J.t(J.gp(_s1312["T"], "used"))) if _t3721 else _t3721):
		_s1312["r"] = J.gp(J.gp(_s1312["T"], "un"), "res")
		if J.t((J.seq(J.gp(_s1312["r"], "state"), "home") if J.t(_s1312["r"]) else _s1312["r"])):
			var _t3722 = _s1312["T"]
			var _t3723 = J.sub(J.gp(_t3722, "wait"), _s1312["__p"]["dt"])
			J.sp(_t3722, "wait", _t3723)
			if J.cmp(J.gp(_s1312["T"], "wait"), 0.0, "<="):
				var _t3724 = _s1312["T"]
				J.sp(_t3724, "used", true)
				var _t3725 = _s1312["__p"]["__p"]["say"]
				J.cl(_t3725, null, [_s1312["r"], "邊個搞到成地都係飯……"])
				var _t3726 = _s1312["r"]
				J.sp(_t3726, "tidy", 1.2)
				var _t3727 = _s1312["r"]
				var _t3733 = Callable(self, "_f556").bind(_s1312)
				J.sp(_t3727, "tidyCb", _t3733)
		else:
			var _t3734 = J.gp(_s1312["__p"]["__p"]["G"], "guards")
			J.mc(_t3734, "forEach", [Callable(self, "_f557").bind(_s1312)])
	var _t3741 = J.seq(J.gp(_s1312["T"], "k"), "hair")
	if ((not J.t(J.gp(_s1312["T"], "used"))) if _t3741 else _t3741):
		_s1312["vic"] = null
		var _t3742 = J.gp(_s1312["__p"]["__p"]["G"], "guards")
		J.mc(_t3742, "forEach", [Callable(self, "_f558").bind(_s1312)])
		var _t3747 = J.gp(_s1312["__p"]["__p"]["G"], "res")
		J.mc(_t3747, "forEach", [Callable(self, "_f559").bind(_s1312)])
		if J.t(_s1312["vic"]):
			var _t3751 = _s1312["T"]
			J.sp(_t3751, "used", true)
			var _t3752 = _s1312["T"]
			var _t3753 = J.min_([J.gp(_s1312["T"], "life"), 2.5])
			J.sp(_t3752, "life", _t3753)
			var _t3754 = _s1312["vic"]
			J.sp(_t3754, "tangle", 2.2)
			if J.seq(J.gp(_s1312["vic"], "state"), "flee"):
				var _t3755 = _s1312["vic"]
				J.sp(_t3755, "tripT", 1.2)
			else:
				var _t3756 = _s1312["vic"]
				J.sp(_t3756, "wait", 2.2)
				var _t3757 = _s1312["vic"]
				J.sp(_t3757, "to", null)
				var _t3758 = _s1312["vic"]
				J.sp(_t3758, "path", null)
			var _t3759 = _s1312["vic"]
			J.sp(_t3759, "say", "咩嘢纏住我隻腳呀？！濕㗎！")
			var _t3760 = _s1312["vic"]
			J.sp(_t3760, "sayT", 2.2)
			var _t3761 = _s1312["__p"]["__p"]["addFear"]
			J.cl(_t3761, null, [6.0, J.gp(_s1312["vic"], "x"), J.sub(J.gp(_s1312["vic"], "y"), 90.0)])
			var _t3762 = _s1312["__p"]["__p"]["float"]
			J.cl(_t3762, null, [J.gp(_s1312["vic"], "x"), J.sub(J.gp(_s1312["vic"], "y"), 112.0), "濕髮纏腳！", "#9fe0ff"])

func _f560(this_, a: Array, env):
	var v_T_3393 = null
	v_T_3393 = J.arg(a, 0)
	return J.cmp(J.gp(v_T_3393, "life"), 0.0, ">")

func _f561(this_, a: Array, env):
	var v_r_3396 = null; var v_cb_3397 = null
	v_r_3396 = J.arg(a, 0)
	if J.cmp(J.gp(v_r_3396, "hunt"), 0.0, ">"):
		var _t3767 = J.sub(J.gp(v_r_3396, "hunt"), env["dt"])
		J.sp(v_r_3396, "hunt", _t3767)
		if J.seq(J.gp(v_r_3396, "state"), "home"):
			var _t3768 = J.add(J.gp(v_r_3396, "fear"), J.mul(env["dt"], 5.0))
			J.sp(v_r_3396, "fear", _t3768)
			if J.cmp(J.gp(v_r_3396, "fear"), 100.0, ">="):
				var _t3769 = env["__p"]["flee"]
				J.cl(_t3769, null, [v_r_3396, null])
	if J.cmp(J.gp(v_r_3396, "tidy"), 0.0, ">"):
		var _t3770 = J.sub(J.gp(v_r_3396, "tidy"), env["dt"])
		J.sp(v_r_3396, "tidy", _t3770)
		var _t3771 = J.cmp(J.gp(v_r_3396, "tidy"), 0.0, "<=")
		if J.t((J.gp(v_r_3396, "tidyCb") if _t3771 else _t3771)):
			v_cb_3397 = J.gp(v_r_3396, "tidyCb")
			J.sp(v_r_3396, "tidyCb", null)
			J.cl(v_cb_3397, null, [])
	if J.t(J.gp(v_r_3396, "react")):
		var _t3772 = J.gp(v_r_3396, "react")
		var _t3773 = J.sub(J.gp(_t3772, "t"), env["dt"])
		J.sp(_t3772, "t", _t3773)
		if J.cmp(J.gp(J.gp(v_r_3396, "react"), "t"), 0.0, "<="):
			J.sp(v_r_3396, "react", null)
	if J.cmp(J.gp(v_r_3396, "fleeAfter"), 0.0, ">"):
		var _t3774 = J.sub(J.gp(v_r_3396, "fleeAfter"), env["dt"])
		J.sp(v_r_3396, "fleeAfter", _t3774)
		var _t3775 = J.cmp(J.gp(v_r_3396, "fleeAfter"), 0.0, "<=")
		if (J.seq(J.gp(v_r_3396, "state"), "home") if _t3775 else _t3775):
			J.sp(v_r_3396, "fleeAfter", 0.0)
			var _t3776 = env["__p"]["flee"]
			J.cl(_t3776, null, [v_r_3396, J.gp(v_r_3396, "fleeG")])

func _f562(this_, a: Array, env):
	var v_h_3400 = null
	v_h_3400 = J.arg(a, 0)
	if J.cmp(J.gp(v_h_3400, "tangle"), 0.0, ">"):
		var _t3778 = J.sub(J.gp(v_h_3400, "tangle"), env["dt"])
		J.sp(v_h_3400, "tangle", _t3778)

func _f554(this_, a: Array, env):
	var _s1311 = {"__p": env, "dt": null}
	_s1311["dt"] = J.arg(a, 0)
	var _t3716 = J.gp(_s1311["__p"]["G"], "traces")
	J.mc(_t3716, "forEach", [Callable(self, "_f555").bind(_s1311)])
	var _t3763 = _s1311["__p"]["G"]
	var _t3764 = J.gp(_s1311["__p"]["G"], "traces")
	var _t3765 = J.mc(_t3764, "filter", [Callable(self, "_f560").bind(_s1311)])
	J.sp(_t3763, "traces", _t3765)
	var _t3766 = J.gp(_s1311["__p"]["G"], "res")
	J.mc(_t3766, "forEach", [Callable(self, "_f561").bind(_s1311)])
	var _t3777 = J.gp(_s1311["__p"]["G"], "guards")
	J.mc(_t3777, "forEach", [Callable(self, "_f562").bind(_s1311)])

func _f564(this_, a: Array, env):
	var v_o_3410 = null
	v_o_3410 = J.arg(a, 0)
	var _t3781 = (not J.seq(v_o_3410, env["r"]))
	var _t3782 = ((not J.seq(J.gp(v_o_3410, "state"), "flee")) if _t3781 else _t3781)
	var _t3783 = ((not J.seq(J.gp(v_o_3410, "state"), "gone")) if _t3782 else _t3782)
	var _t3784 = ((absf(J.num(J.sub(J.gp(v_o_3410, "y"), J.gp(env["r"], "y")))) < 30.0) if _t3783 else _t3783)
	return ((absf(J.num(J.sub(J.gp(v_o_3410, "x"), J.gp(env["r"], "x")))) < 130.0) if _t3784 else _t3784)

func _f563(this_, a: Array, env):
	var v_g_3404 = null; var v_opts_3405 = null; var v_near_3406 = null; var v_k_3407 = null
	var _s1334 = {"__p": env, "r": null}
	_s1334["r"] = J.arg(a, 0)
	v_g_3404 = J.arg(a, 1)
	if J.t(J.gp(_s1334["r"], "brave")):
		return "slipper"
	v_opts_3405 = ["scream", "kneel", "cover", "fall", "phone"]
	var _t3779 = J.gp(_s1334["__p"]["G"], "guards")
	var _t3780 = J.mc(_t3779, "concat", [J.gp(_s1334["__p"]["G"], "res")])
	v_near_3406 = J.mc(_t3780, "some", [Callable(self, "_f564").bind(_s1334)])
	if J.t(v_near_3406):
		J.mc(v_opts_3405, "push", ["push", "push"])
	var _t3785 = _s1334["__p"]["pick"]
	v_k_3407 = J.cl(_t3785, null, [v_opts_3405])
	if J.seq(v_k_3407, J.gp(_s1334["r"], "lastReact")):
		var _t3786 = _s1334["__p"]["pick"]
		var _t3787 = J.cl(_t3786, null, [v_opts_3405])
		v_k_3407 = _t3787
	var _t3788 = _s1334["r"]
	J.sp(_t3788, "lastReact", v_k_3407)
	return v_k_3407

func _f566(this_, a: Array, env):
	var v_q_3420 = null
	v_q_3420 = J.arg(a, 0)
	var _t3808 = (not J.t(env["o"]))
	var _t3809 = ((not J.seq(v_q_3420, env["r"])) if _t3808 else _t3808)
	var _t3810 = ((not J.seq(J.gp(v_q_3420, "state"), "flee")) if _t3809 else _t3809)
	var _t3811 = ((not J.seq(J.gp(v_q_3420, "state"), "gone")) if _t3810 else _t3810)
	var _t3812 = ((absf(J.num(J.sub(J.gp(v_q_3420, "y"), J.gp(env["r"], "y")))) < 30.0) if _t3811 else _t3811)
	if ((absf(J.num(J.sub(J.gp(v_q_3420, "x"), J.gp(env["r"], "x")))) < 130.0) if _t3812 else _t3812):
		env["o"] = v_q_3420

func _f565(this_, a: Array, env):
	var v_g_3414 = null; var v_k_3415 = null; var v_ok_3416 = null
	var _s1336 = {"__p": env, "r": null, "o": null}
	_s1336["r"] = J.arg(a, 0)
	v_g_3414 = J.arg(a, 1)
	var _t3789 = _s1336["__p"]["pickReact"]
	v_k_3415 = J.cl(_t3789, null, [_s1336["r"], v_g_3414])
	var _t3790 = _s1336["r"]
	var _t3791 = {"k": v_k_3415, "t": 1.7}
	J.sp(_t3790, "react", _t3791)
	var _t3792 = _s1336["__p"]["say"]
	var _t3794 = _s1336["r"]
	var _t3793 = _s1336["__p"]["pick"]
	J.cl(_t3792, null, [_t3794, J.cl(_t3793, null, [J.gp(_s1336["__p"]["REACT"], v_k_3415)])])
	if J.seq(v_k_3415, "phone"):
		var _t3795 = J.gp(_s1336["__p"]["G"], "phoneCd")
		var _t3797 = J.cmp((_t3795 if J.t(_t3795) else 0.0), 0.0, "<=")
		if J.t(_t3797):
			var _t3796 = J.gp(_s1336["__p"]["G"], "ult")
			_t3797 = (not J.t((J.gp(J.gp(_s1336["__p"]["G"], "ult"), "phoned") if J.t(_t3796) else _t3796)))
		v_ok_3416 = _t3797
		if J.t(v_ok_3416):
			var _t3798 = _s1336["__p"]["G"]
			var _t3799 = J.add(J.gp(_t3798, "alert"), 1.0)
			J.sp(_t3798, "alert", _t3799)
			var _t3800 = _s1336["__p"]["G"]
			J.sp(_t3800, "phoneCd", 8.0)
			if J.t(J.gp(_s1336["__p"]["G"], "ult")):
				var _t3801 = J.gp(_s1336["__p"]["G"], "ult")
				J.sp(_t3801, "phoned", true)
			var _t3802 = _s1336["__p"]["float"]
			J.cl(_t3802, null, [J.gp(_s1336["r"], "x"), J.sub(J.gp(_s1336["r"], "y"), 100.0), "打電話求救！警覺 +1", "#ffb0b0"])
		else:
			var _t3803 = _s1336["__p"]["float"]
			J.cl(_t3803, null, [J.gp(_s1336["r"], "x"), J.sub(J.gp(_s1336["r"], "y"), 100.0), "電話打唔通……", "#e8d8b0"])
	var _t3804 = J.seq(v_k_3415, "slipper")
	if J.t((v_g_3414 if _t3804 else _t3804)):
		J.sp(v_g_3414, "bounceT", 0.45)
		var _t3805 = _s1336["__p"]["float"]
		J.cl(_t3805, null, [J.gp(v_g_3414, "x"), (J.sub(J.gp(v_g_3414, "y"), J.gp(J.gp(v_g_3414, "d"), "h")) - 6.0), "拖鞋打空氣", "#e8d8b0"])
	if J.seq(v_k_3415, "push"):
		_s1336["o"] = null
		var _t3806 = J.gp(_s1336["__p"]["G"], "guards")
		var _t3807 = J.mc(_t3806, "concat", [J.gp(_s1336["__p"]["G"], "res")])
		J.mc(_t3807, "forEach", [Callable(self, "_f566").bind(_s1336)])
		if J.t(_s1336["o"]):
			var _t3813 = _s1336["r"]
			var _t3814 = (1.0 if J.cmp(J.gp(_s1336["o"], "x"), J.gp(_s1336["r"], "x"), ">") else (-1.0))
			J.sp(_t3813, "pushTo", _t3814)
			var _t3815 = _s1336["o"]
			J.sp(_t3815, "jumpT", 0.5)
			if J.t(J.gp(_s1336["o"], "unit")):
				var _t3816 = _s1336["o"]
				var _t3817 = J.add(J.gp(_t3816, "fear"), 10.0)
				J.sp(_t3816, "fear", _t3817)
			else:
				var _t3818 = _s1336["o"]
				var _t3819 = J.gp(_s1336["o"], "wait")
				var _t3820 = J.gp(_s1336["o"], "wait")
				var _t3821 = J.max_([(_t3820 if J.t(_t3820) else 0.0), 0.9])
				J.sp(_t3818, "wait", _t3821)

func _f568(this_, a: Array, env):
	var v_u_3427 = null
	v_u_3427 = J.arg(a, 0)
	var _t3824 = J.cmp(env["c"], 2.0, "<")
	var _t3825 = (J.gp(v_u_3427, "res") if _t3824 else _t3824)
	var _t3826 = ((not J.seq(J.gp(v_u_3427, "ot"), "deity")) if J.t(_t3825) else _t3825)
	var _t3827 = (J.cmp(J.gp(v_u_3427, "f"), 0.0, ">") if J.t(_t3826) else _t3826)
	if J.t((J.seq(J.mod(J.add(J.gp(v_u_3427, "f"), J.gp(v_u_3427, "u")), 2.0), 1.0) if J.t(_t3827) else _t3827)):
		J.sp(v_u_3427, "beans", true)
		env["c"] = J.num(env["c"]) + 1.0

func _f569(this_, a: Array, env):
	var v_u_3430 = null
	v_u_3430 = J.arg(a, 0)
	var _t3829 = J.gp(v_u_3430, "res")
	return ((not J.seq(J.gp(v_u_3430, "ot"), "deity")) if J.t(_t3829) else _t3829)

func _f567(this_, a: Array, env):
	var v_u_3424 = null
	var _s1345 = {"__p": env, "c": null}
	if J.t(J.gp(_s1345["__p"]["G"], "beansInit")):
		return null
	var _t3822 = _s1345["__p"]["G"]
	J.sp(_t3822, "beansInit", true)
	_s1345["c"] = 0.0
	var _t3823 = J.gp(_s1345["__p"]["G"], "units")
	J.mc(_t3823, "forEach", [Callable(self, "_f568").bind(_s1345)])
	if (not J.t(_s1345["c"])):
		var _t3828 = J.gp(_s1345["__p"]["G"], "units")
		v_u_3424 = J.mc(_t3828, "find", [Callable(self, "_f569").bind(_s1345)])
		if J.t(v_u_3424):
			J.sp(v_u_3424, "beans", true)

func _f570(this_, a: Array, env):
	var v_g_3433 = null; var v_dt_3434 = null; var v_n_3435 = null; var v_un_3436 = null
	v_g_3433 = J.arg(a, 0)
	v_dt_3434 = J.arg(a, 1)
	if (not J.seq(J.gp(J.gp(v_g_3433, "d"), "key"), "toyol")):
		return null
	v_n_3435 = J.gp(J.gp(env["G"], "nodes"), J.gp(v_g_3433, "node"))
	if J.cmp(J.gp(v_g_3433, "countT"), 0.0, ">"):
		var _t3830 = J.sub(J.gp(v_g_3433, "countT"), v_dt_3434)
		J.sp(v_g_3433, "countT", _t3830)
		var _t3831 = J.gp(v_g_3433, "cntAcc")
		var _t3832 = J.add((_t3831 if J.t(_t3831) else 0.0), v_dt_3434)
		J.sp(v_g_3433, "cntAcc", _t3832)
		if J.cmp(J.gp(v_g_3433, "cntAcc"), 0.32, ">"):
			J.sp(v_g_3433, "cntAcc", 0.0)
			var _t3833 = J.gp(v_g_3433, "cntN")
			var _t3834 = J.add((_t3833 if J.t(_t3833) else 0.0), 1.0)
			J.sp(v_g_3433, "cntN", _t3834)
		return null
	var _t3835 = J.seq(J.gp(v_n_3435, "kind"), "in")
	if ((not J.t(J.gp(v_g_3433, "to"))) if _t3835 else _t3835):
		var _t3836 = env["unitOf"]
		v_un_3436 = J.cl(_t3836, null, [J.gp(v_n_3435, "id")])
		var _t3837 = J.gp(v_un_3436, "beans")
		if J.t(((not J.t(J.gp(v_un_3436, "beansDone"))) if J.t(_t3837) else _t3837)):
			J.sp(v_un_3436, "beansDone", true)
			J.sp(v_g_3433, "countT", 2.6)
			J.sp(v_g_3433, "stun", 2.6)
			J.sp(v_g_3433, "cntN", 0.0)
			J.sp(v_g_3433, "taskP", 0.0)
			J.sp(v_g_3433, "sc", null)
			var _t3838 = env["float"]
			J.cl(_t3838, null, [J.gp(v_g_3433, "x"), (J.sub(J.gp(v_g_3433, "y"), J.gp(J.gp(v_g_3433, "d"), "h")) - 20.0), "地下有綠豆！忍唔住坐低數……", "#b8f0a0"])

func _f571(this_, a: Array, env):
	var v_x_3439 = null; var v_y_3440 = null; var v_fill_3441 = null
	v_x_3439 = J.arg(a, 0)
	v_y_3440 = J.arg(a, 1)
	v_fill_3441 = J.arg(a, 2)
	var _t3839 = env["ctx"]
	J.sp(_t3839, "fillStyle", "#d8d0c0")
	J.mc(env["ctx"], "beginPath", [])
	J.mc(env["ctx"], "moveTo", [J.sub(v_x_3439, 9.0), J.sub(v_y_3440, 6.0)])
	J.mc(env["ctx"], "quadraticCurveTo", [v_x_3439, J.add(v_y_3440, 5.0), J.add(v_x_3439, 9.0), J.sub(v_y_3440, 6.0)])
	J.mc(env["ctx"], "closePath", [])
	J.mc(env["ctx"], "fill", [])
	var _t3840 = env["ctx"]
	J.sp(_t3840, "strokeStyle", "#6a4a2a")
	var _t3841 = env["ctx"]
	J.sp(_t3841, "lineWidth", 1.0)
	J.mc(env["ctx"], "stroke", [])
	if J.cmp(v_fill_3441, 0.0, ">"):
		var _t3842 = env["ctx"]
		J.sp(_t3842, "fillStyle", "#f0e6c8")
		J.mc(env["ctx"], "beginPath", [])
		J.mc(env["ctx"], "ellipse", [v_x_3439, J.sub(v_y_3440, 6.0), J.mul(8.0, v_fill_3441), 2.6, 0.0, 0.0, 7.0])
		J.mc(env["ctx"], "fill", [])

func _f572(this_, a: Array, env):
	var v_x_3444 = null; var v_y_3445 = null; var v_R_3446 = null; var v_open_3447 = null; var v_dir_3448 = null; var v_n_3449 = null; var v_i_3450 = null; var v_tx_3451 = null
	v_x_3444 = J.arg(a, 0)
	v_y_3445 = J.arg(a, 1)
	v_R_3446 = J.arg(a, 2)
	v_open_3447 = J.arg(a, 3)
	v_dir_3448 = J.arg(a, 4)
	J.mc(env["ctx"], "save", [])
	J.mc(env["ctx"], "translate", [v_x_3444, v_y_3445])
	J.mc(env["ctx"], "scale", [v_dir_3448, 1.0])
	var _t3843 = env["ctx"]
	J.sp(_t3843, "fillStyle", "#120808")
	J.mc(env["ctx"], "beginPath", [])
	J.mc(env["ctx"], "ellipse", [0.0, 0.0, J.mul(v_R_3446, 1.1), J.mul(v_R_3446, 0.85), 0.0, 0.0, 7.0])
	J.mc(env["ctx"], "fill", [])
	var _t3844 = env["ctx"]
	J.sp(_t3844, "fillStyle", "#7a0e0e")
	J.mc(env["ctx"], "beginPath", [])
	J.mc(env["ctx"], "ellipse", [J.mul(v_R_3446, 0.15), 0.0, J.mul(v_R_3446, 0.85), (J.mul(J.mul(v_R_3446, 0.62), v_open_3447) + 2.0), 0.0, 0.0, 7.0])
	J.mc(env["ctx"], "fill", [])
	var _t3845 = env["ctx"]
	J.sp(_t3845, "fillStyle", "#e8e0cc")
	v_n_3449 = 7.0
	v_i_3450 = 0.0
	while true:
		if not J.cmp(v_i_3450, v_n_3449, "<"): break
		v_tx_3451 = (((-J.num(v_R_3446)) * 0.65) + J.div((J.mul(v_i_3450, v_R_3446) * 1.6), v_n_3449))
		J.mc(env["ctx"], "beginPath", [])
		J.mc(env["ctx"], "moveTo", [v_tx_3451, J.mul(((-J.num(v_R_3446)) * 0.62), v_open_3447)])
		J.mc(env["ctx"], "lineTo", [J.add(v_tx_3451, J.mul(v_R_3446, 0.11)), (J.mul(((-J.num(v_R_3446)) * 0.62), v_open_3447) + J.mul(v_R_3446, 0.28))])
		J.mc(env["ctx"], "lineTo", [J.add(v_tx_3451, J.mul(v_R_3446, 0.22)), J.mul(((-J.num(v_R_3446)) * 0.62), v_open_3447)])
		J.mc(env["ctx"], "fill", [])
		J.mc(env["ctx"], "beginPath", [])
		J.mc(env["ctx"], "moveTo", [v_tx_3451, J.mul(J.mul(v_R_3446, 0.62), v_open_3447)])
		J.mc(env["ctx"], "lineTo", [J.add(v_tx_3451, J.mul(v_R_3446, 0.11)), (J.mul(J.mul(v_R_3446, 0.62), v_open_3447) - J.mul(v_R_3446, 0.26))])
		J.mc(env["ctx"], "lineTo", [J.add(v_tx_3451, J.mul(v_R_3446, 0.22)), J.mul(J.mul(v_R_3446, 0.62), v_open_3447)])
		J.mc(env["ctx"], "fill", [])
		v_i_3450 = J.num(v_i_3450) + 1.0
	var _t3846 = env["ctx"]
	J.sp(_t3846, "fillStyle", "#d0c060")
	J.mc(env["ctx"], "beginPath", [])
	J.mc(env["ctx"], "arc", [((-J.num(v_R_3446)) * 0.55), ((-J.num(v_R_3446)) * 0.9), J.mul(v_R_3446, 0.12), 0.0, 7.0])
	J.mc(env["ctx"], "arc", [J.mul(v_R_3446, 0.35), ((-J.num(v_R_3446)) * 0.95), J.mul(v_R_3446, 0.12), 0.0, 7.0])
	J.mc(env["ctx"], "fill", [])
	J.mc(env["ctx"], "restore", [])

func _f573(this_, a: Array, env):
	var v_s_3454 = null; var v_x_3455 = null; var v_y_3456 = null; var v_c_3457 = null; var v_sz_3458 = null
	v_s_3454 = J.arg(a, 0)
	v_x_3455 = J.arg(a, 1)
	v_y_3456 = J.arg(a, 2)
	v_c_3457 = J.arg(a, 3)
	v_sz_3458 = J.arg(a, 4)
	var _t3847 = env["crText"]
	J.cl(_t3847, null, [env["ctx"], v_s_3454, v_x_3455, v_y_3456, (v_sz_3458 if J.t(v_sz_3458) else 12.0), v_c_3457, "center"])

func _f576(this_, a: Array, env):
	var v_p_3482 = null; var v_i_3483 = null
	v_p_3482 = J.arg(a, 0)
	v_i_3483 = J.arg(a, 1)
	var _t3859 = env["ctx"]
	var _t3860 = (J.add("rgba(120,200,150,", 0.55) + ")")
	J.sp(_t3859, "fillStyle", _t3860)
	J.mc(env["ctx"], "beginPath", [])
	J.mc(env["ctx"], "ellipse", [J.gp(v_p_3482, "x"), J.gp(v_p_3482, "y"), 2.6, 1.5, 0.0, 0.0, 7.0])
	J.mc(env["ctx"], "fill", [])
	J.mc(env["ctx"], "beginPath", [])
	J.mc(env["ctx"], "ellipse", [J.add(J.gp(v_p_3482, "x"), 3.0), J.sub(J.gp(v_p_3482, "y"), 3.0), 1.0, 1.0, 0.0, 0.0, 7.0])
	J.mc(env["ctx"], "fill", [])

func _f575(this_, a: Array, env):
	var v_g_3463 = null; var v_S_3464 = null; var v_r_3465 = null; var v_un_3466 = null; var v_top_3467 = null; var v_flo_3468 = null; var v_k_3469 = null; var v_t_3470 = null; var v_o_3471 = null; var v_i_3472 = null; var v_bx_3473 = null; var v_by_3474 = null; var v_s_3475 = null; var v_e_3476 = null; var v_yb_3477 = null; var v_hx_3478 = null; var v_a_3479 = null
	v_g_3463 = J.arg(a, 0)
	v_S_3464 = J.gp(v_g_3463, "sc")
	var _t3849 = (not J.t(v_S_3464))
	var _t3850 = (_t3849 if _t3849 else J.gp(v_g_3463, "home"))
	if J.t((_t3850 if J.t(_t3850) else J.gp(v_g_3463, "out"))):
		return null
	v_r_3465 = J.gp(v_S_3464, "r")
	v_un_3466 = J.gp(v_S_3464, "un")
	var _t3851 = env["fy"]
	v_top_3467 = J.add(J.cl(_t3851, null, [J.add(J.gp(v_un_3466, "f"), 1.0)]), 10.0)
	var _t3852 = env["fy"]
	v_flo_3468 = J.cl(_t3852, null, [J.gp(v_un_3466, "f")])
	v_k_3469 = J.gp(v_S_3464, "k")
	v_t_3470 = J.gp(v_S_3464, "t")
	J.mc(env["ctx"], "save", [])
	J.mc(env["ctx"], "beginPath", [])
	J.mc(env["ctx"], "rect", [J.sub(J.gp(J.gp(v_un_3466, "rx"), 0.0), 40.0), v_top_3467, (J.sub(J.gp(J.gp(v_un_3466, "rx"), 1.0), J.gp(J.gp(v_un_3466, "rx"), 0.0)) + 80.0), (J.sub(v_flo_3468, v_top_3467) + 2.0)])
	J.mc(env["ctx"], "clip", [])
	if J.cmp(v_t_3470, env["OMEN"], "<"):
		v_o_3471 = J.div(v_t_3470, env["OMEN"])
		if J.seq(v_k_3469, "eking"):
			v_i_3472 = 0.0
			while true:
				if not J.cmp(v_i_3472, 3.0, "<"): break
				v_bx_3473 = J.sub(J.gp(v_r_3465, "x"), J.mul(J.gp(v_S_3464, "side"), (14.0 + J.mul(v_i_3472, 14.0))))
				v_by_3474 = (J.sub(J.gp(v_r_3465, "y"), 22.0) - J.mul((absf(J.num(sin(J.num((J.mul(J.gp(env["G"], "t"), 18.0) + J.mul(v_i_3472, 2.0)))))) * 7.0), v_o_3471))
				J.mc(env["ctx"], "save", [])
				J.mc(env["ctx"], "translate", [v_bx_3473, v_by_3474])
				J.mc(env["ctx"], "rotate", [J.mul((sin(J.num(J.add(J.mul(J.gp(env["G"], "t"), 22.0), v_i_3472))) * 0.35), v_o_3471)])
				var _t3853 = env["drawBowl"]
				J.cl(_t3853, null, [0.0, 0.0, 1.0])
				J.mc(env["ctx"], "restore", [])
				var _t3854 = env["ctx"]
				J.sp(_t3854, "strokeStyle", "#c8a050")
				var _t3855 = env["ctx"]
				J.sp(_t3855, "lineWidth", 1.5)
				J.mc(env["ctx"], "beginPath", [])
				J.mc(env["ctx"], "moveTo", [J.add(v_bx_3473, 6.0), (J.sub(v_by_3474, 8.0) - (sin(J.num(J.add(J.mul(J.gp(env["G"], "t"), 30.0), v_i_3472))) * 4.0))])
				J.mc(env["ctx"], "lineTo", [J.add(v_bx_3473, 14.0), J.sub(v_by_3474, 18.0)])
				J.mc(env["ctx"], "stroke", [])
				v_i_3472 = J.num(v_i_3472) + 1.0
			var _t3856 = env["txt"]
			J.cl(_t3856, null, [J.gp(J.gp(env["MV"], "eking"), "omen"), J.sub(J.gp(v_r_3465, "x"), J.mul(J.gp(v_S_3464, "side"), 28.0)), (J.sub(J.gp(v_r_3465, "y"), 72.0) - J.mul(v_o_3471, 6.0)), "#ffe9a0", 11.0])
		if J.seq(v_k_3469, "toyol"):
			var _t3857 = J.gp(v_S_3464, "prints")
			var _t3858 = (_t3857 if J.t(_t3857) else [])
			J.mc(_t3858, "forEach", [Callable(self, "_f576").bind(env)])
			var _t3861 = env["ctx"]
			J.sp(_t3861, "fillStyle", "#3a2a1e")
			J.mc(env["ctx"], "fillRect", [J.sub(J.gp(v_S_3464, "sx"), 26.0), J.sub(v_flo_3468, 18.0), 52.0, 10.0])
			var _t3862 = env["ctx"]
			J.sp(_t3862, "fillStyle", "#7a6a5a")
			J.mc(env["ctx"], "fillRect", [J.sub(J.gp(v_S_3464, "sx"), 28.0), J.sub(v_flo_3468, 24.0), 56.0, 7.0])
			var _t3863 = env["txt"]
			J.cl(_t3863, null, [J.gp(J.gp(env["MV"], "toyol"), "omen"), J.gp(v_S_3464, "sx"), (J.sub(v_flo_3468, 36.0) - (sin(J.num(J.mul(J.gp(env["G"], "t"), 9.0))) * 3.0)), "#b8f0a0", 11.0])
		if J.seq(v_k_3469, "tianhua"):
			var _t3864 = env["ctx"]
			var _t3865 = (J.add("rgba(60,90,110,", J.mul(0.55, v_o_3471)) + ")")
			J.sp(_t3864, "fillStyle", _t3865)
			J.mc(env["ctx"], "beginPath", [])
			J.mc(env["ctx"], "ellipse", [J.gp(v_r_3465, "x"), J.add(J.gp(v_S_3464, "ceil"), 2.0), (10.0 + J.mul(v_o_3471, 26.0)), (4.0 + J.mul(v_o_3471, 4.0)), 0.0, 0.0, 7.0])
			J.mc(env["ctx"], "fill", [])
			var _t3866 = env["txt"]
			J.cl(_t3866, null, [J.gp(J.gp(env["MV"], "tianhua"), "omen"), J.add(J.gp(v_r_3465, "x"), 22.0), J.add(J.gp(v_S_3464, "ceil"), 22.0), "#9fe0ff", 11.0])
	else:
		if J.cmp(v_t_3470, J.add(env["OMEN"], env["STRIKE"]), "<"):
			v_s_3475 = J.div(J.sub(v_t_3470, env["OMEN"]), env["STRIKE"])
			v_e_3476 = (J.div(v_s_3475, 0.35) if J.cmp(v_s_3475, 0.35, "<") else 1.0)
			if J.seq(v_k_3469, "eking"):
				var _t3867 = env["ctx"]
				J.sp(_t3867, "fillStyle", "#2a2e32")
				J.mc(env["ctx"], "fillRect", [J.sub(J.gp(v_S_3464, "sx"), 15.0), J.sub(v_flo_3468, 60.0), 30.0, 58.0])
				var _t3868 = env["ctx"]
				J.sp(_t3868, "strokeStyle", "#8a9aa0")
				var _t3869 = env["ctx"]
				J.sp(_t3869, "lineWidth", 1.5)
				J.mc(env["ctx"], "strokeRect", [J.sub(J.gp(v_S_3464, "sx"), 15.0), J.sub(v_flo_3468, 60.0), 30.0, 58.0])
				J.mc(env["ctx"], "beginPath", [])
				J.mc(env["ctx"], "moveTo", [J.sub(J.gp(v_S_3464, "sx"), 15.0), J.sub(v_flo_3468, 38.0)])
				J.mc(env["ctx"], "lineTo", [J.add(J.gp(v_S_3464, "sx"), 15.0), J.sub(v_flo_3468, 38.0)])
				J.mc(env["ctx"], "stroke", [])
				var _t3870 = env["ctx"]
				var _t3871 = (J.add("rgba(255,240,200,", J.mul(0.5, v_e_3476)) + ")")
				J.sp(_t3870, "fillStyle", _t3871)
				J.mc(env["ctx"], "fillRect", [J.sub(J.gp(v_S_3464, "sx"), 15.0), J.sub(v_flo_3468, 60.0), 4.0, 58.0])
				var _t3872 = env["drawMouth"]
				J.cl(_t3872, null, [J.add(J.gp(v_S_3464, "sx"), J.mul((J.sub(J.gp(v_r_3465, "x"), J.gp(v_S_3464, "sx")) * 0.45), v_e_3476)), J.sub(v_flo_3468, 40.0), (10.0 + J.mul(28.0, v_e_3476)), (0.35 + (0.65 * absf(J.num(sin(J.num((J.mul(v_s_3475, PI) * 3.0))))))), (1.0 if J.cmp(J.gp(v_r_3465, "x"), J.gp(v_S_3464, "sx"), ">") else (-1.0))])
			if J.seq(v_k_3469, "toyol"):
				var _t3873 = env["ctx"]
				J.sp(_t3873, "fillStyle", "#3a2a1e")
				J.mc(env["ctx"], "fillRect", [J.sub(J.gp(v_S_3464, "sx"), 26.0), J.sub(v_flo_3468, 18.0), 52.0, 10.0])
				var _t3874 = env["spr"]
				J.cl(_t3874, null, ["toyol", J.add(J.gp(v_S_3464, "sx"), J.mul((J.sub(J.gp(v_r_3465, "x"), J.gp(v_S_3464, "sx")) * 0.4), v_e_3476)), (J.sub(v_flo_3468, 6.0) + (18.0 * J.sub(1.0, v_e_3476))), 40.0, {"flip": J.cmp(J.gp(v_r_3465, "x"), J.gp(v_S_3464, "sx"), "<"), "rot": (((1.0 if J.cmp(J.gp(v_r_3465, "x"), J.gp(v_S_3464, "sx"), ">") else (-1.0)) * 0.3) * J.sub(1.0, v_e_3476))}])
				var _t3875 = env["ctx"]
				J.sp(_t3875, "fillStyle", "#7a6a5a")
				J.mc(env["ctx"], "fillRect", [J.sub(J.gp(v_S_3464, "sx"), 28.0), J.sub(v_flo_3468, 24.0), 56.0, 7.0])
				if J.cmp(v_s_3475, 0.3, ">"):
					var _t3876 = env["txt"]
					J.cl(_t3876, null, ["搶咗！", J.gp(v_S_3464, "sx"), J.sub(v_flo_3468, 62.0), "#ffd54a", 13.0])
			if J.seq(v_k_3469, "tianhua"):
				v_yb_3477 = J.add(J.add(J.gp(v_S_3464, "ceil"), 8.0), J.mul((J.sub(J.sub(J.gp(v_r_3465, "y"), 30.0), J.gp(v_S_3464, "ceil")) - 8.0), v_e_3476))
				v_hx_3478 = J.add(J.gp(v_r_3465, "x"), ((-14.0) if J.cmp(J.gp(v_r_3465, "x"), J.gp(v_g_3463, "x"), ">") else 14.0))
				var _t3877 = env["ctx"]
				J.sp(_t3877, "strokeStyle", "rgba(14,14,18,0.9)")
				var _t3878 = env["ctx"]
				J.sp(_t3878, "lineWidth", 1.6)
				v_i_3472 = 0.0
				while true:
					if not J.cmp(v_i_3472, 10.0, "<"): break
					J.mc(env["ctx"], "beginPath", [])
					J.mc(env["ctx"], "moveTo", [(J.sub(v_hx_3478, 12.0) + J.mul(v_i_3472, 2.6)), J.gp(v_S_3464, "ceil")])
					J.mc(env["ctx"], "quadraticCurveTo", [((J.sub(v_hx_3478, 12.0) + J.mul(v_i_3472, 2.6)) + (sin(J.num(J.add(J.mul(J.gp(env["G"], "t"), 6.0), v_i_3472))) * 3.0)), J.div(J.add(J.gp(v_S_3464, "ceil"), v_yb_3477), 2.0), (J.sub(v_hx_3478, 14.0) + J.mul(v_i_3472, 3.0)), J.sub(v_yb_3477, 20.0)])
					J.mc(env["ctx"], "stroke", [])
					v_i_3472 = J.num(v_i_3472) + 1.0
				var _t3879 = env["spr"]
				J.cl(_t3879, null, ["tianhua_hang", v_hx_3478, v_yb_3477, 74.0, {"flip": J.cmp(J.gp(v_r_3465, "x"), J.gp(v_g_3463, "x"), "<"), "rot": (sin(J.num(J.mul(J.gp(env["G"], "t"), 4.0))) * 0.05)}])
				v_i_3472 = 0.0
				while true:
					if not J.cmp(v_i_3472, 3.0, "<"): break
					var _t3880 = env["ctx"]
					J.sp(_t3880, "fillStyle", "#9fe0ff")
					J.mc(env["ctx"], "beginPath", [])
					J.mc(env["ctx"], "arc", [(J.sub(v_hx_3478, 8.0) + J.mul(v_i_3472, 8.0)), J.add(J.add(v_yb_3477, 4.0), J.mod((J.mul(J.gp(env["G"], "t"), 60.0) + J.mul(v_i_3472, 9.0)), 22.0)), 1.8, 0.0, 7.0])
					J.mc(env["ctx"], "fill", [])
					v_i_3472 = J.num(v_i_3472) + 1.0
		else:
			v_a_3479 = (1.0 - J.div(J.sub(J.sub(v_t_3470, env["OMEN"]), env["STRIKE"]), env["AFTER"]))
			if J.seq(v_k_3469, "eking"):
				var _t3881 = env["ctx"]
				J.sp(_t3881, "globalAlpha", v_a_3479)
				var _t3882 = env["ctx"]
				J.sp(_t3882, "fillStyle", "#2a2e32")
				J.mc(env["ctx"], "fillRect", [J.sub(J.gp(v_S_3464, "sx"), 15.0), J.sub(v_flo_3468, 60.0), 30.0, 58.0])
				var _t3883 = env["ctx"]
				J.sp(_t3883, "globalAlpha", 1.0)
			if J.seq(v_k_3469, "toyol"):
				var _t3884 = env["ctx"]
				J.sp(_t3884, "globalAlpha", v_a_3479)
				var _t3885 = env["ctx"]
				J.sp(_t3885, "fillStyle", "#3a2a1e")
				J.mc(env["ctx"], "fillRect", [J.sub(J.gp(v_S_3464, "sx"), 26.0), J.sub(v_flo_3468, 18.0), 52.0, 10.0])
				var _t3886 = env["ctx"]
				J.sp(_t3886, "globalAlpha", 1.0)
	J.mc(env["ctx"], "restore", [])

func _f574(this_, a: Array, env):
	var _t3848 = J.gp(env["G"], "gh")
	J.mc(_t3848, "forEach", [Callable(self, "_f575").bind(env)])

func _f578(this_, a: Array, env):
	var v_T_3488 = null; var v_a_3489 = null; var v_i_3490 = null; var v_px_3491 = null; var v_py_3492 = null; var v_r_3493 = null; var v_top_3494 = null; var v_hx_3495 = null
	v_T_3488 = J.arg(a, 0)
	v_a_3489 = J.min_([1.0, J.div(J.gp(v_T_3488, "life"), 2.0)])
	var _t3888 = env["ctx"]
	J.sp(_t3888, "globalAlpha", v_a_3489)
	if J.seq(J.gp(v_T_3488, "k"), "food"):
		v_i_3490 = 0.0
		while true:
			if not J.cmp(v_i_3490, 9.0, "<"): break
			v_px_3491 = (J.sub(J.gp(v_T_3488, "x"), 26.0) + J.mod(J.mul(v_i_3490, 37.0), 52.0))
			v_py_3492 = (J.sub(J.gp(v_T_3488, "y"), 3.0) - J.mod(v_i_3490, 3.0))
			var _t3889 = env["ctx"]
			var _t3890 = ("#e8d8a0" if J.t(J.mod(v_i_3490, 3.0)) else "#c8784a")
			J.sp(_t3889, "fillStyle", _t3890)
			J.mc(env["ctx"], "beginPath", [])
			J.mc(env["ctx"], "ellipse", [v_px_3491, v_py_3492, (3.0 + (J.mod(v_i_3490, 2.0) * 2.0)), 1.6, 0.0, 0.0, 7.0])
			J.mc(env["ctx"], "fill", [])
			v_i_3490 = J.num(v_i_3490) + 1.0
		J.mc(env["ctx"], "save", [])
		J.mc(env["ctx"], "translate", [J.add(J.gp(v_T_3488, "x"), 10.0), J.sub(J.gp(v_T_3488, "y"), 6.0)])
		J.mc(env["ctx"], "rotate", [1.3])
		var _t3891 = env["drawBowl"]
		J.cl(_t3891, null, [0.0, 0.0, 0.0])
		J.mc(env["ctx"], "restore", [])
		J.mc(env["ctx"], "save", [])
		J.mc(env["ctx"], "translate", [J.sub(J.gp(v_T_3488, "x"), 18.0), J.sub(J.gp(v_T_3488, "y"), 5.0)])
		J.mc(env["ctx"], "rotate", [(-2.2)])
		var _t3892 = env["drawBowl"]
		J.cl(_t3892, null, [0.0, 0.0, 0.0])
		J.mc(env["ctx"], "restore", [])
		var _t3893 = env["ctx"]
		J.sp(_t3893, "strokeStyle", "#c8a050")
		var _t3894 = env["ctx"]
		J.sp(_t3894, "lineWidth", 1.4)
		J.mc(env["ctx"], "beginPath", [])
		J.mc(env["ctx"], "moveTo", [J.sub(J.gp(v_T_3488, "x"), 4.0), J.sub(J.gp(v_T_3488, "y"), 2.0)])
		J.mc(env["ctx"], "lineTo", [J.add(J.gp(v_T_3488, "x"), 14.0), J.sub(J.gp(v_T_3488, "y"), 5.0)])
		J.mc(env["ctx"], "moveTo", [J.sub(J.gp(v_T_3488, "x"), 2.0), J.sub(J.gp(v_T_3488, "y"), 1.0)])
		J.mc(env["ctx"], "lineTo", [J.add(J.gp(v_T_3488, "x"), 12.0), J.add(J.gp(v_T_3488, "y"), 1.0)])
		J.mc(env["ctx"], "stroke", [])
		v_r_3493 = J.gp(J.gp(v_T_3488, "un"), "res")
		if J.t((J.cmp(J.gp(v_r_3493, "tidy"), 0.0, ">") if J.t(v_r_3493) else v_r_3493)):
			var _t3895 = env["txt"]
			J.cl(_t3895, null, ["執緊……", J.gp(v_r_3493, "x"), J.sub(J.gp(v_r_3493, "y"), 80.0), "#e8d8b0", 11.0])
	if J.seq(J.gp(v_T_3488, "k"), "mess"):
		v_i_3490 = 0.0
		while true:
			if not J.cmp(v_i_3490, 10.0, "<"): break
			v_px_3491 = (J.sub(J.gp(v_T_3488, "x"), 34.0) + J.mod(J.mul(v_i_3490, 29.0), 68.0))
			v_py_3492 = (J.sub(J.gp(v_T_3488, "y"), 3.0) - (J.mod(v_i_3490, 2.0) * 2.0))
			J.mc(env["ctx"], "save", [])
			J.mc(env["ctx"], "translate", [v_px_3491, v_py_3492])
			J.mc(env["ctx"], "rotate", [J.mul(v_i_3490, 0.7)])
			var _t3896 = env["ctx"]
			var _t3897 = ("#e8e2d0" if J.t(J.mod(v_i_3490, 2.0)) else "#9cc89c")
			J.sp(_t3896, "fillStyle", _t3897)
			J.mc(env["ctx"], "fillRect", [(-4.0), (-2.5), 8.0, 5.0])
			J.mc(env["ctx"], "restore", [])
			v_i_3490 = J.num(v_i_3490) + 1.0
		var _t3898 = env["ctx"]
		J.sp(_t3898, "fillStyle", "#4a3424")
		J.mc(env["ctx"], "save", [])
		J.mc(env["ctx"], "translate", [J.add(J.gp(v_T_3488, "x"), 24.0), J.sub(J.gp(v_T_3488, "y"), 8.0)])
		J.mc(env["ctx"], "rotate", [0.5])
		J.mc(env["ctx"], "fillRect", [(-10.0), (-5.0), 20.0, 10.0])
		J.mc(env["ctx"], "restore", [])
		if J.cmp(J.gp(v_T_3488, "t"), 4.0, "<"):
			var _t3899 = env["txt"]
			J.cl(_t3899, null, ["乒乒乓乓", J.gp(v_T_3488, "x"), (J.sub(J.gp(v_T_3488, "y"), 84.0) - (sin(J.num(J.mul(J.gp(env["G"], "t"), 14.0))) * 2.0)), "#ffb0b0", 11.0])
	if J.seq(J.gp(v_T_3488, "k"), "hair"):
		var _t3900 = env["fy"]
		v_top_3494 = J.add(J.cl(_t3900, null, [J.add(J.gp(v_T_3488, "f"), 1.0)]), 16.0)
		var _t3901 = env["ctx"]
		var _t3902 = ("rgba(30,30,36,0.5)" if J.t(J.gp(v_T_3488, "used")) else "rgba(20,22,28,0.92)")
		J.sp(_t3901, "strokeStyle", _t3902)
		var _t3903 = env["ctx"]
		J.sp(_t3903, "lineWidth", 1.4)
		v_i_3490 = 0.0
		while true:
			if not J.cmp(v_i_3490, 8.0, "<"): break
			v_hx_3495 = ((J.sub(J.gp(v_T_3488, "x"), 14.0) + J.mul(v_i_3490, 1.6)) + (24.0 if J.cmp(v_i_3490, 3.0, ">") else 0.0))
			J.mc(env["ctx"], "beginPath", [])
			J.mc(env["ctx"], "moveTo", [v_hx_3495, J.add(v_top_3494, 4.0)])
			J.mc(env["ctx"], "quadraticCurveTo", [J.add(v_hx_3495, (sin(J.num(J.add(J.mul(J.gp(env["G"], "t"), 2.0), v_i_3490))) * 4.0)), J.add(v_top_3494, 30.0), J.add(v_hx_3495, (sin(J.num(J.add(J.mul(J.gp(env["G"], "t"), 1.5), v_i_3490))) * 3.0)), J.add(J.add(v_top_3494, 44.0), (J.mod(v_i_3490, 3.0) * 8.0))])
			J.mc(env["ctx"], "stroke", [])
			v_i_3490 = J.num(v_i_3490) + 1.0
		if (not J.t(J.gp(v_T_3488, "used"))):
			var _t3904 = env["ctx"]
			J.sp(_t3904, "fillStyle", "rgba(159,224,255,0.7)")
			J.mc(env["ctx"], "beginPath", [])
			J.mc(env["ctx"], "arc", [J.sub(J.gp(v_T_3488, "x"), 10.0), J.add(J.add(v_top_3494, 50.0), J.mod(J.mul(J.gp(env["G"], "t"), 40.0), 24.0)), 1.6, 0.0, 7.0])
			J.mc(env["ctx"], "fill", [])
	var _t3905 = env["ctx"]
	J.sp(_t3905, "globalAlpha", 1.0)

func _f579(this_, a: Array, env):
	var v_u_3498 = null; var v_cx_3499 = null; var v_y_3500 = null; var v_i_3501 = null
	v_u_3498 = J.arg(a, 0)
	var _t3907 = (not J.t(J.gp(v_u_3498, "beans")))
	if (_t3907 if _t3907 else (not J.t(J.gp(v_u_3498, "open")))):
		return null
	v_cx_3499 = (J.div(J.add(J.gp(J.gp(v_u_3498, "rx"), 0.0), J.gp(J.gp(v_u_3498, "rx"), 1.0)), 2.0) + 18.0)
	v_y_3500 = J.sub(J.gp(v_u_3498, "y"), 3.0)
	v_i_3501 = 0.0
	while true:
		if not J.cmp(v_i_3501, 16.0, "<"): break
		var _t3908 = env["ctx"]
		var _t3909 = ("#5a7a3a" if J.t(J.gp(v_u_3498, "beansDone")) else "#7ac04a")
		J.sp(_t3908, "fillStyle", _t3909)
		J.mc(env["ctx"], "beginPath", [])
		J.mc(env["ctx"], "arc", [(J.sub(v_cx_3499, 16.0) + J.mod(J.mul(v_i_3501, 13.0), 32.0)), J.sub(v_y_3500, (J.mod(v_i_3501, 3.0) * 1.4)), 1.7, 0.0, 7.0])
		J.mc(env["ctx"], "fill", [])
		v_i_3501 = J.num(v_i_3501) + 1.0
	var _t3910 = env["ctx"]
	J.sp(_t3910, "fillStyle", "#d24a3a")
	J.mc(env["ctx"], "beginPath", [])
	J.mc(env["ctx"], "arc", [J.add(v_cx_3499, 20.0), J.sub(v_y_3500, 4.0), 4.0, 0.0, 7.0])
	J.mc(env["ctx"], "fill", [])
	var _t3911 = env["ctx"]
	J.sp(_t3911, "fillStyle", "#ffd54a")
	J.mc(env["ctx"], "fillRect", [J.add(v_cx_3499, 24.0), J.sub(v_y_3500, 8.0), 6.0, 6.0])
	if J.t(J.gp(v_u_3498, "seen")):
		var _t3912 = env["txt"]
		J.cl(_t3912, null, [("綠豆（數過）" if J.t(J.gp(v_u_3498, "beansDone")) else "綠豆・玩具"), v_cx_3499, J.sub(v_y_3500, 14.0), "#b8f0a0", 10.0])

func _f577(this_, a: Array, env):
	var _t3887 = J.gp(env["G"], "traces")
	J.mc(_t3887, "forEach", [Callable(self, "_f578").bind(env)])
	var _t3906 = J.gp(env["G"], "units")
	J.mc(_t3906, "forEach", [Callable(self, "_f579").bind(env)])

func _f580(this_, a: Array, env):
	var v_r_3504 = null; var v_P_3505 = null; var v_R_3506 = null; var v_q_3507 = null
	v_r_3504 = J.arg(a, 0)
	v_P_3505 = J.arg(a, 1)
	v_R_3506 = J.gp(v_r_3504, "react")
	var _t3913 = (not J.t(v_R_3506))
	if (_t3913 if _t3913 else (not J.seq(J.gp(v_r_3504, "state"), "home"))):
		return null
	v_q_3507 = (1.0 - J.div(J.gp(v_R_3506, "t"), 1.7))
	if J.seq(J.gp(v_R_3506, "k"), "scream"):
		var _t3914 = (sin(J.num(J.mul(J.gp(env["G"], "t"), 50.0))) * 2.4)
		J.sp(v_P_3505, "sh", _t3914)
		var _t3915 = ((-absf(J.num(sin(J.num((J.mul(v_q_3507, PI) * 2.0)))))) * 8.0)
		J.sp(v_P_3505, "jy", _t3915)
	if J.seq(J.gp(v_R_3506, "k"), "kneel"):
		J.sp(v_P_3505, "sy", 0.66)
		J.sp(v_P_3505, "jy", 2.0)
		var _t3916 = (sin(J.num(J.mul(J.gp(env["G"], "t"), 6.0))) * 0.05)
		J.sp(v_P_3505, "ro", _t3916)
	if J.seq(J.gp(v_R_3506, "k"), "cover"):
		J.sp(v_P_3505, "sy", 0.86)
		var _t3917 = (sin(J.num(J.mul(J.gp(env["G"], "t"), 30.0))) * 1.4)
		J.sp(v_P_3505, "sh", _t3917)
		J.sp(v_P_3505, "hands", true)
	if J.seq(J.gp(v_R_3506, "k"), "fall"):
		var _t3918 = (((-1.0) if J.cmp(J.gp(v_r_3504, "x"), J.div(env["WW"], 2.0), "<") else 1.0) * J.min_([1.35, J.mul(v_q_3507, 5.0)]))
		J.sp(v_P_3505, "ro", _t3918)
		var _t3919 = (J.min_([1.0, J.mul(v_q_3507, 5.0)]) * 10.0)
		J.sp(v_P_3505, "jy", _t3919)
	if J.seq(J.gp(v_R_3506, "k"), "phone"):
		J.sp(v_P_3505, "phone", true)
		var _t3920 = (sin(J.num(J.mul(J.gp(env["G"], "t"), 20.0))) * 1.0)
		J.sp(v_P_3505, "sh", _t3920)
	if J.seq(J.gp(v_R_3506, "k"), "slipper"):
		J.sp(v_P_3505, "slip", true)
		var _t3921 = (sin(J.num(J.mul(J.gp(env["G"], "t"), 16.0))) * 0.12)
		J.sp(v_P_3505, "ro", _t3921)
	if J.seq(J.gp(v_R_3506, "k"), "push"):
		var _t3922 = J.gp(v_r_3504, "pushTo")
		var _t3923 = (J.mul((_t3922 if J.t(_t3922) else 1.0), 0.3) * absf(J.num(sin(J.num(J.mul(J.gp(env["G"], "t"), 10.0))))))
		J.sp(v_P_3505, "ro", _t3923)
		var _t3924 = J.gp(v_r_3504, "pushTo")
		var _t3925 = (J.mul((_t3924 if J.t(_t3924) else 1.0), absf(J.num(sin(J.num(J.mul(J.gp(env["G"], "t"), 10.0)))))) * 8.0)
		J.sp(v_P_3505, "sh", _t3925)
	if J.cmp(J.gp(v_r_3504, "tidy"), 0.0, ">"):
		J.sp(v_P_3505, "sy", 0.78)
		J.sp(v_P_3505, "ro", 0.25)

func _f581(this_, a: Array, env):
	var v_r_3510 = null; var v_P_3511 = null; var v_R_3512 = null; var v_i_3513 = null; var v_a_3514 = null; var v_an_3515 = null; var v_an2_3516 = null
	v_r_3510 = J.arg(a, 0)
	v_P_3511 = J.arg(a, 1)
	v_R_3512 = J.gp(v_r_3510, "react")
	var _t3926 = (not J.t(v_R_3512))
	if (_t3926 if _t3926 else (not J.seq(J.gp(v_r_3510, "state"), "home"))):
		return null
	if J.t(J.gp(v_P_3511, "hands")):
		var _t3927 = env["ctx"]
		J.sp(_t3927, "fillStyle", "#e8c0a0")
		J.mc(env["ctx"], "beginPath", [])
		J.mc(env["ctx"], "arc", [J.sub(J.gp(v_r_3510, "x"), 8.0), J.sub(J.gp(v_r_3510, "y"), 46.0), 5.0, 0.0, 7.0])
		J.mc(env["ctx"], "arc", [J.add(J.gp(v_r_3510, "x"), 8.0), J.sub(J.gp(v_r_3510, "y"), 46.0), 5.0, 0.0, 7.0])
		J.mc(env["ctx"], "fill", [])
	if J.t(J.gp(v_P_3511, "phone")):
		var _t3928 = env["ctx"]
		J.sp(_t3928, "fillStyle", "#202428")
		J.mc(env["ctx"], "fillRect", [J.add(J.gp(v_r_3510, "x"), 9.0), J.sub(J.gp(v_r_3510, "y"), 50.0), 6.0, 11.0])
		var _t3929 = env["ctx"]
		J.sp(_t3929, "fillStyle", "#9fe0ff")
		J.mc(env["ctx"], "fillRect", [J.add(J.gp(v_r_3510, "x"), 10.0), J.sub(J.gp(v_r_3510, "y"), 49.0), 4.0, 7.0])
		v_i_3513 = 0.0
		while true:
			if not J.cmp(v_i_3513, 2.0, "<"): break
			var _t3930 = env["ctx"]
			var _t3931 = (J.add("rgba(159,224,255,", (0.8 - J.mul(v_i_3513, 0.3))) + ")")
			J.sp(_t3930, "strokeStyle", _t3931)
			var _t3932 = env["ctx"]
			J.sp(_t3932, "lineWidth", 1.5)
			J.mc(env["ctx"], "beginPath", [])
			J.mc(env["ctx"], "arc", [J.add(J.gp(v_r_3510, "x"), 12.0), J.sub(J.gp(v_r_3510, "y"), 45.0), ((9.0 + J.mul(v_i_3513, 6.0)) + J.mod(J.mul(J.gp(env["G"], "t"), 20.0), 5.0)), (-0.8), 0.8])
			J.mc(env["ctx"], "stroke", [])
			v_i_3513 = J.num(v_i_3513) + 1.0
	if J.t(J.gp(v_P_3511, "slip")):
		v_a_3514 = (sin(J.num(J.mul(J.gp(env["G"], "t"), 16.0))) * 1.2)
		J.mc(env["ctx"], "save", [])
		J.mc(env["ctx"], "translate", [J.gp(v_r_3510, "x"), J.sub(J.gp(v_r_3510, "y"), 42.0)])
		J.mc(env["ctx"], "rotate", [v_a_3514])
		var _t3933 = env["ctx"]
		J.sp(_t3933, "fillStyle", "#3a6ad0")
		J.mc(env["ctx"], "fillRect", [14.0, (-4.0), 16.0, 7.0])
		J.mc(env["ctx"], "restore", [])
		var _t3934 = env["ctx"]
		J.sp(_t3934, "strokeStyle", "rgba(255,255,255,0.5)")
		var _t3935 = env["ctx"]
		J.sp(_t3935, "lineWidth", 2.0)
		J.mc(env["ctx"], "beginPath", [])
		J.mc(env["ctx"], "arc", [J.gp(v_r_3510, "x"), J.sub(J.gp(v_r_3510, "y"), 42.0), 26.0, (-1.2), 1.2])
		J.mc(env["ctx"], "stroke", [])
	if J.seq(J.gp(v_R_3512, "k"), "scream"):
		var _t3936 = env["ctx"]
		J.sp(_t3936, "strokeStyle", "rgba(255,255,255,0.75)")
		var _t3937 = env["ctx"]
		J.sp(_t3937, "lineWidth", 2.0)
		v_i_3513 = 0.0
		while true:
			if not J.cmp(v_i_3513, 3.0, "<"): break
			v_an_3515 = ((-2.2) + J.mul(v_i_3513, 0.6))
			J.mc(env["ctx"], "beginPath", [])
			J.mc(env["ctx"], "moveTo", [J.add(J.gp(v_r_3510, "x"), (cos(J.num(v_an_3515)) * 24.0)), (J.sub(J.gp(v_r_3510, "y"), 46.0) + (sin(J.num(v_an_3515)) * 24.0))])
			J.mc(env["ctx"], "lineTo", [J.add(J.gp(v_r_3510, "x"), (cos(J.num(v_an_3515)) * 34.0)), (J.sub(J.gp(v_r_3510, "y"), 46.0) + (sin(J.num(v_an_3515)) * 34.0))])
			J.mc(env["ctx"], "stroke", [])
			v_an2_3516 = ((-0.95) + J.mul(v_i_3513, 0.6))
			J.mc(env["ctx"], "beginPath", [])
			J.mc(env["ctx"], "moveTo", [J.add(J.gp(v_r_3510, "x"), (cos(J.num(v_an2_3516)) * 24.0)), (J.sub(J.gp(v_r_3510, "y"), 46.0) + (sin(J.num(v_an2_3516)) * 24.0))])
			J.mc(env["ctx"], "lineTo", [J.add(J.gp(v_r_3510, "x"), (cos(J.num(v_an2_3516)) * 34.0)), (J.sub(J.gp(v_r_3510, "y"), 46.0) + (sin(J.num(v_an2_3516)) * 34.0))])
			J.mc(env["ctx"], "stroke", [])
			v_i_3513 = J.num(v_i_3513) + 1.0

func _f582(this_, a: Array, env):
	var v_o_3519 = null; var v_by_3520 = null; var v_n_3521 = null; var v_k_3522 = null; var v_d_3523 = null; var v_p_3524 = null; var v_bx_3525 = null; var v_byy_3526 = null; var v_mx_3527 = null; var v_my_3528 = null; var v_q_3529 = null; var v_qx_3530 = null; var v_qy_3531 = null; var v_dx_3532 = null; var v_dy_3533 = null; var v_out_3534 = null; var v_cy_3535 = null
	v_o_3519 = J.arg(a, 0)
	v_by_3520 = J.arg(a, 1)
	if (not J.cmp(J.gp(v_o_3519, "taskP"), 0.0, ">")):
		return null
	v_n_3521 = J.gp(J.gp(env["G"], "nodes"), J.gp(v_o_3519, "node"))
	if (not J.seq(J.gp(v_n_3521, "kind"), "in")):
		return null
	v_k_3522 = J.gp(J.gp(v_o_3519, "d"), "key")
	v_d_3523 = J.gp(v_o_3519, "dir")
	v_p_3524 = J.gp(v_o_3519, "taskP")
	if J.seq(v_k_3522, "eking"):
		v_bx_3525 = J.add(J.gp(v_o_3519, "x"), J.mul(v_d_3523, 36.0))
		v_byy_3526 = J.sub(J.gp(v_o_3519, "y"), 14.0)
		var _t3938 = env["drawBowl"]
		J.cl(_t3938, null, [v_bx_3525, v_byy_3526, J.sub(1.0, v_p_3524)])
		v_mx_3527 = J.add(J.gp(v_o_3519, "x"), J.mul(v_d_3523, 6.0))
		v_my_3528 = J.sub(v_by_3520, J.mul(J.gp(J.gp(v_o_3519, "d"), "h"), 0.6))
		var _t3939 = env["ctx"]
		J.sp(_t3939, "strokeStyle", "#5a3a2c")
		var _t3940 = env["ctx"]
		J.sp(_t3940, "lineWidth", 3.2)
		J.mc(env["ctx"], "beginPath", [])
		J.mc(env["ctx"], "moveTo", [v_mx_3527, v_my_3528])
		J.mc(env["ctx"], "quadraticCurveTo", [J.add(J.gp(v_o_3519, "x"), J.mul(v_d_3523, 30.0)), (J.sub(v_my_3528, 16.0) + (sin(J.num(J.mul(J.gp(env["G"], "t"), 6.0))) * 3.0)), v_bx_3525, J.sub(v_byy_3526, 6.0)])
		J.mc(env["ctx"], "stroke", [])
		var _t3941 = env["ctx"]
		J.sp(_t3941, "strokeStyle", "#8a5a44")
		var _t3942 = env["ctx"]
		J.sp(_t3942, "lineWidth", 1.4)
		J.mc(env["ctx"], "stroke", [])
		v_q_3529 = J.mod(J.mul(J.gp(env["G"], "t"), 2.2), 1.0)
		v_qx_3530 = J.add(v_bx_3525, J.mul(J.sub(v_mx_3527, v_bx_3525), v_q_3529))
		v_qy_3531 = ((J.sub(v_byy_3526, 6.0) + J.mul((J.sub(v_my_3528, v_byy_3526) + 6.0), v_q_3529)) - (sin(J.num(J.mul(v_q_3529, PI))) * 14.0))
		var _t3943 = env["ctx"]
		J.sp(_t3943, "fillStyle", "#f0e6c8")
		J.mc(env["ctx"], "beginPath", [])
		J.mc(env["ctx"], "arc", [v_qx_3530, v_qy_3531, 3.2, 0.0, 7.0])
		J.mc(env["ctx"], "fill", [])
	if J.seq(v_k_3522, "toyol"):
		v_dx_3532 = J.add(J.gp(v_o_3519, "x"), J.mul(v_d_3523, 30.0))
		v_dy_3533 = J.sub(J.gp(v_o_3519, "y"), 34.0)
		v_out_3534 = (6.0 + (absf(J.num(sin(J.num(J.mul(J.gp(env["G"], "t"), 7.0))))) * 8.0))
		var _t3944 = env["ctx"]
		J.sp(_t3944, "fillStyle", "#4a3424")
		J.mc(env["ctx"], "fillRect", [J.sub(v_dx_3532, 16.0), J.sub(v_dy_3533, 10.0), 32.0, 26.0])
		var _t3945 = env["ctx"]
		J.sp(_t3945, "fillStyle", "#6a4a30")
		J.mc(env["ctx"], "fillRect", [(J.sub(v_dx_3532, 14.0) + J.mul(v_d_3523, v_out_3534)), J.sub(v_dy_3533, 6.0), 28.0, 10.0])
		var _t3946 = env["ctx"]
		J.sp(_t3946, "fillStyle", "#c8a050")
		J.mc(env["ctx"], "fillRect", [(J.sub(v_dx_3532, 2.0) + J.mul(v_d_3523, v_out_3534)), J.sub(v_dy_3533, 2.0), 4.0, 2.0])
	if J.seq(v_k_3522, "tianhua"):
		v_mx_3527 = J.add(J.gp(v_o_3519, "x"), J.mul(v_d_3523, 34.0))
		v_my_3528 = J.sub(J.gp(v_o_3519, "y"), 62.0)
		var _t3947 = env["ctx"]
		J.sp(_t3947, "fillStyle", "#c8a050")
		J.mc(env["ctx"], "fillRect", [J.sub(v_mx_3527, 13.0), J.sub(v_my_3528, 20.0), 26.0, 40.0])
		var _t3948 = env["ctx"]
		J.sp(_t3948, "fillStyle", "#1a2a30")
		J.mc(env["ctx"], "fillRect", [J.sub(v_mx_3527, 10.0), J.sub(v_my_3528, 17.0), 20.0, 34.0])
		J.mc(env["ctx"], "save", [])
		J.mc(env["ctx"], "beginPath", [])
		J.mc(env["ctx"], "rect", [J.sub(v_mx_3527, 10.0), J.sub(v_my_3528, 17.0), 20.0, 34.0])
		J.mc(env["ctx"], "clip", [])
		var _t3949 = env["spr"]
		J.cl(_t3949, null, ["tianhua", v_mx_3527, J.add(v_my_3528, 20.0), 40.0, {"flip": J.cmp(v_d_3523, 0.0, ">"), "alpha": J.min_([0.9, J.mul(v_p_3524, 2.6)])}])
		J.mc(env["ctx"], "restore", [])
		var _t3950 = env["ctx"]
		J.sp(_t3950, "fillStyle", "rgba(220,245,255,0.25)")
		J.mc(env["ctx"], "fillRect", [J.sub(v_mx_3527, 10.0), J.sub(v_my_3528, 17.0), 5.0, 34.0])
		v_cy_3535 = (J.sub(v_by_3520, J.mul(J.gp(J.gp(v_o_3519, "d"), "h"), 0.8)) + J.mod(J.mul(J.gp(env["G"], "t"), 40.0), J.mul(J.gp(J.gp(v_o_3519, "d"), "h"), 0.5)))
		var _t3951 = env["ctx"]
		J.sp(_t3951, "fillStyle", "#d8b878")
		J.mc(env["ctx"], "fillRect", [(J.sub(J.gp(v_o_3519, "x"), J.mul(v_d_3523, 10.0)) - 5.0), v_cy_3535, 10.0, 3.0])

func _f584(this_, a: Array, env):
	var v_c_3565 = null
	v_c_3565 = J.arg(a, 0)
	var _t3953 = J.add(env["W"], J.gp(v_c_3565, 1.0))
	env["W"] = _t3953

func _f585(this_, a: Array, env):
	var v_c_3568 = null
	v_c_3568 = J.arg(a, 0)
	J.mc(env["xs"], "push", [[env["x"], J.add(env["x"], J.gp(v_c_3568, 1.0)), J.gp(v_c_3568, 0.0)]])
	var _t3955 = J.add(env["x"], J.gp(v_c_3568, 1.0))
	env["x"] = _t3955

func _f587(this_, a: Array, env):
	var v_q_3575 = null
	v_q_3575 = J.arg(a, 0)
	return J.seq(J.gp(v_q_3575, 2.0), env["kind"])

func _f586(this_, a: Array, env):
	var v_c_3572 = null
	var _s1423 = {"__p": env, "kind": null}
	_s1423["kind"] = J.arg(a, 0)
	v_c_3572 = J.mc(_s1423["__p"]["xs"], "find", [Callable(self, "_f587").bind(_s1423)])
	return (J.div(J.add(J.gp(v_c_3572, 0.0), J.gp(v_c_3572, 1.0)), 2.0) if J.t(v_c_3572) else null)

func _f588(this_, a: Array, env):
	var v_q_3578 = null
	v_q_3578 = J.arg(a, 0)
	return J.seq(J.gp(v_q_3578, 2.0), "u")

func _f589(this_, a: Array, env):
	var v___3581 = null; var v_i_3582 = null
	v___3581 = J.arg(a, 0)
	v_i_3582 = J.arg(a, 1)
	return v_i_3582

func _f590(this_, a: Array, env):
	var v_c_3585 = null; var v_u_3586 = null; var v_w_3587 = null; var v_deity_3588 = null; var v_nm_3589 = null; var v_hh_3590 = null; var v_task_3591 = null; var v_doorX_3592 = null
	v_c_3585 = J.arg(a, 0)
	v_u_3586 = J.arg(a, 1)
	var _t3975 = J.gp(env["wardsF"], v_u_3586)
	v_w_3587 = (_t3975 if J.t(_t3975) else null)
	var _t3976 = J.seq(v_w_3587, "fu")
	var _t3977 = (_t3976 if _t3976 else J.seq(v_w_3587, "menshen"))
	v_deity_3588 = (_t3977 if _t3977 else J.seq(v_w_3587, "datuk"))
	v_hh_3590 = null
	v_task_3591 = null
	if J.seq(env["f"], 0.0):
		var _t3978 = J.gp(J.gp(env["B"], "base"), J.mod(v_u_3586, J.len(J.gp(env["B"], "base"))))
		v_nm_3589 = _t3978
		v_hh_3590 = null
	else:
		if J.seq(env["f"], 1.0):
			var _t3979 = J.gp(J.gp(env["B"], "ground"), J.mod(v_u_3586, J.len(J.gp(env["B"], "ground"))))
			v_nm_3589 = _t3979
			var _t3980 = J.seq(v_u_3586, 0.0)
			var _t3983 = null
			if J.t((_t3980 if _t3980 else v_deity_3588)):
				_t3983 = null
			else:
				var _t3982 = null
				if J.cmp(J.cl(env["R"], null, []), 0.5, "<"):
					var _t3981 = env["__p"]["pick"]
					_t3982 = J.cl(_t3981, null, [["insomnia", "cook", "gamer"]])
				else:
					_t3982 = null
				_t3983 = _t3982
			v_hh_3590 = _t3983
		else:
			var _t3986 = null
			if J.t(v_deity_3588):
				_t3986 = null
			else:
				var _t3985 = null
				if J.cmp(J.cl(env["R"], null, []), 0.96, "<"):
					var _t3984 = env["__p"]["wpick"]
					_t3985 = J.cl(_t3984, null, [env["__p"]["HHW"]])
				else:
					_t3985 = null
				_t3986 = _t3985
			v_hh_3590 = _t3986
			var _t3987 = (J.gp(J.gp(env["__p"]["HH"], v_hh_3590), "n") if J.t(v_hh_3590) else "空置單位")
			v_nm_3589 = _t3987
	v_doorX_3592 = J.round(J.num(J.add(J.gp(v_c_3585, 0.0), (J.sub(J.gp(v_c_3585, 1.0), J.gp(v_c_3585, 0.0)) * (0.24 if J.t(J.mod(v_u_3586, 2.0)) else 0.78)))))
	var _t3988 = J.gp(env["LVg"], "units")
	J.mc(_t3988, "push", [[env["f"], v_u_3586, v_w_3587, null, v_hh_3590, (-1.0), v_nm_3589, v_doorX_3592, [J.gp(v_c_3585, 0.0), J.gp(v_c_3585, 1.0)]]])

func _f591(this_, a: Array, env):
	var v_L_3595 = null
	v_L_3595 = J.arg(a, 0)
	var _t3990 = J.gp(v_L_3595, 4.0)
	var _t3991 = (J.cmp(J.gp(v_L_3595, 0.0), 3.0, ">=") if J.t(_t3990) else _t3990)
	return ((not J.t(J.gp(v_L_3595, 2.0))) if J.t(_t3991) else _t3991)

func _f592(this_, a: Array, env):
	var v_L_3598 = null
	v_L_3598 = J.arg(a, 0)
	var _t3997 = J.seq(J.gp(v_L_3598, 0.0), env["f"])
	var _t3998 = (J.gp(v_L_3598, 4.0) if _t3997 else _t3997)
	return ((not J.t(J.gp(v_L_3598, 2.0))) if J.t(_t3998) else _t3998)

func _f593(this_, a: Array, env):
	var v_L_3601 = null
	v_L_3601 = J.arg(a, 0)
	var _t4002 = J.gp(v_L_3601, 4.0)
	var _t4003 = (J.cmp(J.gp(v_L_3601, 5.0), 0.0, "<") if J.t(_t4002) else _t4002)
	return ((not J.t(J.gp(v_L_3601, 2.0))) if J.t(_t4003) else _t4003)

func _f583(this_, a: Array, env):
	var v_k_3538 = null; var v_NL_3541 = null; var v_FLn_3542 = null; var v_FH_3543 = null; var v_H_3545 = null; var v_ys_3546 = null; var v_colX_3550 = null; var v_ucols_3551 = null; var v_storyF_3553 = null; var v_si_3554 = null; var v_nU_3556 = null; var v_idx_3557 = null; var v_cands_3558 = null; var v_d_3559 = null; var v_STN_3560 = null; var v_c_3561 = null; var v_c2_3562 = null
	var _s1419 = {"__p": env, "B": null, "R": null, "W": null, "f": null, "xs": null, "x": null, "LVg": null, "wardsF": null}
	v_k_3538 = J.arg(a, 0)
	_s1419["B"] = J.gp(_s1419["__p"]["BLD"], v_k_3538)
	_s1419["R"] = _s1419["__p"]["rnd"]
	v_NL_3541 = J.len(J.gp(_s1419["B"], "levels"))
	v_FLn_3542 = J.sub(v_NL_3541, 1.0)
	v_FH_3543 = J.gp(_s1419["B"], "FH")
	_s1419["W"] = 0.0
	var _t3952 = J.gp(_s1419["B"], "cols")
	J.mc(_t3952, "forEach", [Callable(self, "_f584").bind(_s1419)])
	v_H_3545 = J.add(J.add((30.0 + J.mul(v_FLn_3542, v_FH_3543)), J.gp(_s1419["B"], "ROOF")), 40.0)
	v_ys_3546 = []
	_s1419["f"] = 0.0
	while true:
		if not J.cmp(_s1419["f"], v_FLn_3542, "<="): break
		J.mc(v_ys_3546, "push", [(J.sub(v_H_3545, 30.0) - J.mul(_s1419["f"], v_FH_3543))])
		_s1419["f"] = J.num(_s1419["f"]) + 1.0
	_s1419["xs"] = []
	_s1419["x"] = 0.0
	var _t3954 = J.gp(_s1419["B"], "cols")
	J.mc(_t3954, "forEach", [Callable(self, "_f585").bind(_s1419)])
	v_colX_3550 = Callable(self, "_f586").bind(_s1419)
	v_ucols_3551 = J.mc(_s1419["xs"], "filter", [Callable(self, "_f588").bind(_s1419)])
	_s1419["LVg"] = {"camW": J.gp(_s1419["B"], "camW"), "name": J.gp(_s1419["B"], "name"), "key": v_k_3538, "bg": null, "B": _s1419["B"], "FL": v_FLn_3542, "FYS": v_ys_3546, "WW": _s1419["W"], "WH": v_H_3545, "SX": J.cl(v_colX_3550, null, ["stair"]), "LX": J.cl(v_colX_3550, null, ["back"]), "GLX": J.cl(v_colX_3550, null, ["lift"]), "MX": J.cl(v_colX_3550, null, ["lift"]), "PX0": J.add(J.gp(J.gp(v_ucols_3551, 0.0), 0.0), 30.0), "fln": J.gp(_s1419["B"], "levels"), "xs": _s1419["xs"], "ucols": v_ucols_3551, "units": [], "pipes": J.gp(_s1419["B"], "pipes"), "lift": J.gp(_s1419["B"], "lift")}
	v_storyF_3553 = []
	v_si_3554 = 0.0
	_s1419["f"] = 0.0
	while true:
		if not J.cmp(_s1419["f"], v_FLn_3542, "<"): break
		_s1419["wardsF"] = {}
		v_nU_3556 = J.len(v_ucols_3551)
		if J.cmp(_s1419["f"], 2.0, ">="):
			var _t3956 = _s1419["__p"]["shuffle"]
			v_idx_3557 = J.cl(_t3956, null, [J.mc(v_ucols_3551, "map", [Callable(self, "_f589").bind(_s1419)])])
			var _t3957 = _s1419["wardsF"]
			var _t3958 = J.gp(v_idx_3557, 0.0)
			var _t3959 = _s1419["__p"]["pick"]
			var _t3960 = J.cl(_t3959, null, [["fu", "menshen", "datuk"]])
			J.sp(_t3957, _t3958, _t3960)
			var _t3961 = _s1419["wardsF"]
			var _t3962 = J.gp(v_idx_3557, 1.0)
			J.sp(_t3961, _t3962, "zha")
			var _t3963 = _s1419["wardsF"]
			var _t3964 = J.gp(v_idx_3557, 2.0)
			J.sp(_t3963, _t3964, "nuomi")
			if J.seq(J.mod(_s1419["f"], 2.0), 0.0):
				var _t3965 = _s1419["wardsF"]
				var _t3966 = J.gp(v_idx_3557, 3.0)
				var _t3967 = _s1419["__p"]["pick"]
				var _t3968 = J.cl(_t3967, null, [["zha", "nuomi"]])
				J.sp(_t3965, _t3966, _t3968)
			var _t3969 = J.cmp(v_nU_3556, 8.0, ">=")
			if (J.seq(J.mod(_s1419["f"], 3.0), 1.0) if _t3969 else _t3969):
				var _t3970 = _s1419["wardsF"]
				var _t3971 = J.gp(v_idx_3557, 4.0)
				J.sp(_t3970, _t3971, "zha")
		if J.seq(_s1419["f"], 1.0):
			var _t3972 = _s1419["wardsF"]
			J.sp(_t3972, 2.0, "datuk")
			var _t3973 = _s1419["wardsF"]
			J.sp(_t3973, 5.0, "zha")
		if J.seq(_s1419["f"], 0.0):
			var _t3974 = _s1419["wardsF"]
			J.sp(_t3974, 1.0, "zha")
		J.mc(v_ucols_3551, "forEach", [Callable(self, "_f590").bind(_s1419)])
		_s1419["f"] = J.num(_s1419["f"]) + 1.0
	var _t3989 = J.gp(_s1419["LVg"], "units")
	v_cands_3558 = J.mc(_t3989, "filter", [Callable(self, "_f591").bind(_s1419)])
	if J.t(J.len(v_cands_3558)):
		var _t3992 = _s1419["__p"]["pick"]
		v_d_3559 = J.cl(_t3992, null, [v_cands_3558])
		J.sp(v_d_3559, 4.0, "debt")
		var _t3993 = J.gp(J.gp(_s1419["__p"]["HH"], "debt"), "n")
		J.sp(v_d_3559, 6.0, _t3993)
	v_STN_3560 = J.len(J.gp(J.gp(_s1419["__p"]["LV0"], v_k_3538), "story"))
	_s1419["f"] = 1.0
	while true:
		var _t3994 = J.cmp(_s1419["f"], v_FLn_3542, "<")
		if not (J.cmp(v_si_3554, v_STN_3560, "<") if _t3994 else _t3994): break
		var _t3995 = _s1419["__p"]["shuffle"]
		var _t3996 = J.gp(_s1419["LVg"], "units")
		v_c_3561 = J.gp(J.cl(_t3995, null, [J.mc(_t3996, "filter", [Callable(self, "_f592").bind(_s1419)])]), 0.0)
		if J.t(v_c_3561):
			var _t3999 = J.num(v_si_3554)
			v_si_3554 = _t3999 + 1.0
			J.sp(v_c_3561, 5.0, _t3999)
		_s1419["f"] = J.num(_s1419["f"]) + 1.0
	while true:
		if not J.cmp(v_si_3554, v_STN_3560, "<"): break
		var _t4000 = _s1419["__p"]["shuffle"]
		var _t4001 = J.gp(_s1419["LVg"], "units")
		v_c2_3562 = J.gp(J.cl(_t4000, null, [J.mc(_t4001, "filter", [Callable(self, "_f593").bind(_s1419)])]), 0.0)
		if (not J.t(v_c2_3562)):
			break
		var _t4004 = J.num(v_si_3554)
		v_si_3554 = _t4004 + 1.0
		J.sp(v_c2_3562, 5.0, _t4004)
	return _s1419["LVg"]

func _f595(this_, a: Array, env):
	var v_p_3610 = null
	v_p_3610 = J.arg(a, 0)
	var _t4005 = J.add(env["t"], J.gp(v_p_3610, 1.0))
	env["t"] = _t4005

func _f594(this_, a: Array, env):
	var v_a_3604 = null; var v_r_3606 = null; var v_i_3607 = null
	var _s1444 = {"__p": env, "t": null}
	v_a_3604 = J.arg(a, 0)
	_s1444["t"] = 0.0
	J.mc(v_a_3604, "forEach", [Callable(self, "_f595").bind(_s1444)])
	v_r_3606 = J.mul(J.cl(_s1444["__p"]["rnd"], null, []), _s1444["t"])
	v_i_3607 = 0.0
	while true:
		if not J.cmp(v_i_3607, J.len(v_a_3604), "<"): break
		var _t4006 = J.sub(v_r_3606, J.gp(J.gp(v_a_3604, v_i_3607), 1.0))
		v_r_3606 = _t4006
		if J.cmp(v_r_3606, 0.0, "<="):
			return J.gp(J.gp(v_a_3604, v_i_3607), 0.0)
		v_i_3607 = J.num(v_i_3607) + 1.0
	return J.gp(J.gp(v_a_3604, 0.0), 0.0)

func _f597(this_, a: Array, env):
	var v_L_3623 = null
	v_L_3623 = J.arg(a, 0)
	return J.seq(J.gp(v_L_3623, 0.0), env["f"])

func _f598(this_, a: Array, env):
	var v_L_3626 = null
	v_L_3626 = J.arg(a, 0)
	J.mc(env["stops"], "push", [{"x": J.gp(v_L_3626, 7.0), "u": J.gp(v_L_3626, 1.0)}])

func _f599(this_, a: Array, env):
	var v_P_3629 = null; var v_i_3630 = null; var v_c_3631 = null
	v_P_3629 = J.arg(a, 0)
	v_i_3630 = J.arg(a, 1)
	var _t4015 = J.seq(J.gp(v_P_3629, 0.0), env["f"])
	if (_t4015 if _t4015 else J.seq(J.gp(v_P_3629, 1.0), env["f"])):
		v_c_3631 = J.gp(J.gp(env["__p"]["LV"], "ucols"), J.gp(v_P_3629, 2.0))
		J.mc(env["stops"], "push", [{"x": J.sub(J.gp(v_c_3631, 1.0), 6.0), "pipe": v_i_3630}])

func _f600(this_, a: Array, env):
	var v_P_3634 = null; var v_i_3635 = null; var v_c_3636 = null
	v_P_3634 = J.arg(a, 0)
	v_i_3635 = J.arg(a, 1)
	if J.seq(J.gp(v_P_3634, 1.0), env["f"]):
		v_c_3636 = J.gp(J.gp(env["__p"]["LV"], "ucols"), J.gp(v_P_3634, 2.0))
		J.mc(env["stops"], "push", [{"x": J.sub(J.gp(v_c_3636, 1.0), 6.0), "pipe": v_i_3635}])

func _f601(this_, a: Array, env):
	var v_a_3639 = null; var v_b_3640 = null
	v_a_3639 = J.arg(a, 0)
	v_b_3640 = J.arg(a, 1)
	return J.sub(J.gp(v_a_3639, "x"), J.gp(v_b_3640, "x"))

func _f602(this_, a: Array, env):
	var v_st_3643 = null; var v_id_3644 = null; var v_e_3645 = null; var v_le_3646 = null
	v_st_3643 = J.arg(a, 0)
	if J.seq(J.gp(v_st_3643, "p"), 1.0):
		v_id_3644 = "f0_e"
		var _t4017 = env["__p"]["node"]
		J.cl(_t4017, null, [v_id_3644, J.gp(v_st_3643, "x"), env["y"], 0.0, "portal"])
	else:
		if J.seq(J.gp(v_st_3643, "p"), 2.0):
			var _t4018 = (J.add("f", env["__p"]["FL"]) + "_p")
			v_id_3644 = _t4018
			var _t4019 = env["__p"]["node"]
			J.cl(_t4019, null, [v_id_3644, J.gp(v_st_3643, "x"), env["y"], env["f"], "portal"])
		else:
			if J.t(J.gp(v_st_3643, "lift")):
				var _t4020 = (J.add("f", env["f"]) + "_l")
				v_id_3644 = _t4020
			else:
				if J.t(J.gp(v_st_3643, "back")):
					var _t4021 = (J.add("f", env["f"]) + "_b")
					v_id_3644 = _t4021
				else:
					if (not J.leq(J.gp(v_st_3643, "pipe"), null)):
						var _t4022 = J.add((J.add("f", env["f"]) + "_q"), J.gp(v_st_3643, "pipe"))
						v_id_3644 = _t4022
						var _t4023 = env["__p"]["node"]
						J.cl(_t4023, null, [v_id_3644, J.gp(v_st_3643, "x"), env["y"], env["f"], "pipe"])
					else:
						var _t4024 = J.add((J.add("f", env["f"]) + "_d"), J.gp(v_st_3643, "u"))
						v_id_3644 = _t4024
						var _t4025 = env["__p"]["node"]
						J.cl(_t4025, null, [v_id_3644, J.gp(v_st_3643, "x"), env["y"], env["f"], "door"])
						var _t4026 = env["__p"]["node"]
						J.cl(_t4026, null, [J.add((J.add("f", env["f"]) + "_i"), J.gp(v_st_3643, "u")), J.sub(J.gp(v_st_3643, "x"), 14.0), J.sub(env["y"], 34.0), env["f"], "in"])
						var _t4027 = env["__p"]["link"]
						v_e_3645 = J.cl(_t4027, null, [v_id_3644, J.add((J.add("f", env["f"]) + "_i"), J.gp(v_st_3643, "u"))])
						J.sp(v_e_3645, "door", true)
	var _t4028 = env["__p"]["link"]
	v_le_3646 = J.cl(_t4028, null, [env["prev"], v_id_3644])
	if J.t(env["first"]):
		var _t4029 = {"shut": 0.0, "cd": 0.0, "x": J.div(J.add(J.gp(J.gp(J.gp(env["__p"]["G"], "nodes"), env["prev"]), "x"), J.gp(J.gp(J.gp(env["__p"]["G"], "nodes"), v_id_3644), "x")), 2.0), "f": env["f"]}
		J.sp(v_le_3646, "fire", _t4029)
		env["first"] = false
	env["prev"] = v_id_3644

func _f603(this_, a: Array, env):
	var v_P_3649 = null; var v_i_3650 = null; var v_e_3651 = null
	v_P_3649 = J.arg(a, 0)
	v_i_3650 = J.arg(a, 1)
	var _t4038 = env["__p"]["link"]
	v_e_3651 = J.cl(_t4038, null, [J.add((J.add("f", J.gp(v_P_3649, 0.0)) + "_q"), v_i_3650), J.add((J.add("f", J.gp(v_P_3649, 1.0)) + "_q"), v_i_3650)])
	J.sp(v_e_3651, "vert", true)
	J.sp(v_e_3651, "pipe", true)

func _f596(this_, a: Array, env):
	var v_B_3613 = null; var v_lastE_3619 = null; var v_le2_3620 = null
	var _s1448 = {"__p": env, "f": null, "y": null, "stops": null, "prev": null, "first": null}
	v_B_3613 = J.gp(_s1448["__p"]["LV"], "B")
	_s1448["f"] = 0.0
	while true:
		if not J.cmp(_s1448["f"], _s1448["__p"]["FL"], "<="): break
		var _t4007 = _s1448["__p"]["fy"]
		_s1448["y"] = J.cl(_t4007, null, [_s1448["f"]])
		_s1448["stops"] = []
		var _t4008 = _s1448["__p"]["node"]
		J.cl(_t4008, null, [(J.add("f", _s1448["f"]) + "_s"), _s1448["__p"]["SX"], _s1448["y"], _s1448["f"], "stair"])
		var _t4009 = J.cmp(_s1448["f"], 1.0, ">=")
		if (_t4009 if _t4009 else (not J.t(J.gp(v_B_3613, "lift")))):
			var _t4010 = _s1448["__p"]["node"]
			J.cl(_t4010, null, [(J.add("f", _s1448["f"]) + "_b"), _s1448["__p"]["LX"], _s1448["y"], _s1448["f"], "stair"])
		var _t4011 = _s1448["__p"]["node"]
		J.cl(_t4011, null, [(J.add("f", _s1448["f"]) + "_l"), J.gp(_s1448["__p"]["LV"], "MX"), _s1448["y"], _s1448["f"], ("lift" if J.t(J.gp(v_B_3613, "lift")) else "stair")])
		if J.cmp(_s1448["f"], _s1448["__p"]["FL"], "<"):
			var _t4012 = J.gp(_s1448["__p"]["LV"], "units")
			var _t4013 = J.mc(_t4012, "filter", [Callable(self, "_f597").bind(_s1448)])
			J.mc(_t4013, "forEach", [Callable(self, "_f598").bind(_s1448)])
			if J.seq(_s1448["f"], 0.0):
				J.mc(_s1448["stops"], "push", [{"x": J.gp(_s1448["__p"]["LV"], "PX0"), "p": 1.0}])
			var _t4014 = J.gp(_s1448["__p"]["LV"], "pipes")
			J.mc(_t4014, "forEach", [Callable(self, "_f599").bind(_s1448)])
		else:
			J.mc(_s1448["stops"], "push", [{"x": (J.round(J.num(J.mul(_s1448["__p"]["WW"], 0.5))) + 40.0), "p": 2.0}])
			var _t4016 = J.gp(_s1448["__p"]["LV"], "pipes")
			J.mc(_t4016, "forEach", [Callable(self, "_f600").bind(_s1448)])
		J.mc(_s1448["stops"], "push", [{"x": J.gp(_s1448["__p"]["LV"], "MX"), "lift": 1.0}])
		if J.t(J.gp(J.gp(_s1448["__p"]["G"], "nodes"), (J.add("f", _s1448["f"]) + "_b"))):
			J.mc(_s1448["stops"], "push", [{"x": _s1448["__p"]["LX"], "back": 1.0}])
		J.mc(_s1448["stops"], "sort", [Callable(self, "_f601").bind(_s1448)])
		_s1448["prev"] = (J.add("f", _s1448["f"]) + "_s")
		_s1448["first"] = true
		J.mc(_s1448["stops"], "forEach", [Callable(self, "_f602").bind(_s1448)])
		if J.seq(_s1448["prev"], (J.add("f", _s1448["f"]) + "_b")):
			v_lastE_3619 = J.gp(J.gp(J.gp(J.gp(J.gp(_s1448["__p"]["G"], "nodes"), _s1448["prev"]), "links"), (J.len(J.gp(J.gp(J.gp(_s1448["__p"]["G"], "nodes"), _s1448["prev"]), "links")) - 1.0)), "e")
			var _t4030 = {"shut": 0.0, "cd": 0.0, "x": J.div(J.add(J.gp(J.gp(J.gp(_s1448["__p"]["G"], "nodes"), J.gp(v_lastE_3619, "a")), "x"), J.gp(J.gp(J.gp(_s1448["__p"]["G"], "nodes"), J.gp(v_lastE_3619, "b")), "x")), 2.0), "f": _s1448["f"]}
			J.sp(v_lastE_3619, "fire", _t4030)
		if J.cmp(_s1448["f"], 0.0, ">"):
			var _t4031 = _s1448["__p"]["link"]
			var _t4032 = J.cl(_t4031, null, [(J.add("f", J.sub(_s1448["f"], 1.0)) + "_s"), (J.add("f", _s1448["f"]) + "_s")])
			J.sp(_t4032, "vert", true)
			var _t4033 = _s1448["__p"]["link"]
			v_le2_3620 = J.cl(_t4033, null, [(J.add("f", J.sub(_s1448["f"], 1.0)) + "_l"), (J.add("f", _s1448["f"]) + "_l")])
			J.sp(v_le2_3620, "vert", true)
			if J.t(J.gp(v_B_3613, "lift")):
				J.sp(v_le2_3620, "lift", true)
			var _t4034 = J.gp(J.gp(_s1448["__p"]["G"], "nodes"), (J.add("f", J.sub(_s1448["f"], 1.0)) + "_b"))
			if J.t((J.gp(J.gp(_s1448["__p"]["G"], "nodes"), (J.add("f", _s1448["f"]) + "_b")) if J.t(_t4034) else _t4034)):
				var _t4035 = _s1448["__p"]["link"]
				var _t4036 = J.cl(_t4035, null, [(J.add("f", J.sub(_s1448["f"], 1.0)) + "_b"), (J.add("f", _s1448["f"]) + "_b")])
				J.sp(_t4036, "vert", true)
		_s1448["f"] = J.num(_s1448["f"]) + 1.0
	var _t4037 = J.gp(_s1448["__p"]["LV"], "pipes")
	J.mc(_t4037, "forEach", [Callable(self, "_f603").bind(_s1448)])

func _f606(this_, a: Array, env):
	var v_l_3682 = null
	v_l_3682 = J.arg(a, 0)
	return J.seq(J.gp(v_l_3682, "to"), env["id"])

func _f607(this_, a: Array, env):
	var v_it_3685 = null
	v_it_3685 = J.arg(a, 0)
	var _t4063 = J.gp(env["un"], "items")
	J.mc(_t4063, "push", [v_it_3685])

func _f608(this_, a: Array, env):
	var v_sp_3688 = null; var v_i_3689 = null; var v_hw0_3690 = null; var v_px_3691 = null; var v_r_3692 = null
	v_sp_3688 = J.arg(a, 0)
	v_i_3689 = J.arg(a, 1)
	v_hw0_3690 = ((((60.0 if J.t(J.mod(v_i_3689, 2.0)) else 66.0) if J.cmp(env["n"], 3.0, ">=") else 74.0) * 0.47) + 4.0)
	v_px_3691 = J.add(J.gp(J.gp(env["un"], "rx"), 0.0), J.mul(env["w0"], (0.42 if J.seq(env["n"], 1.0) else ((0.18 + J.div(J.mul(0.64, v_i_3689), J.sub(env["n"], 1.0))) if J.cmp(env["n"], 3.0, ">=") else (0.28 + J.div(J.mul(0.44, v_i_3689), J.sub(env["n"], 1.0)))))))
	var _t4068 = J.cmp(env["n"], 3.0, "<")
	if ((absf(J.num(J.sub(v_px_3691, J.gp(env["un"], "x")))) < 22.0) if _t4068 else _t4068):
		var _t4069 = J.add(v_px_3691, ((-24.0) if J.cmp(v_px_3691, J.gp(env["un"], "x"), "<") else 24.0))
		v_px_3691 = _t4069
	var _t4070 = J.max_([J.add(J.gp(J.gp(env["un"], "rx"), 0.0), v_hw0_3690), J.min_([J.sub(J.gp(J.gp(env["un"], "rx"), 1.0), v_hw0_3690), v_px_3691])])
	v_px_3691 = _t4070
	var _t4072 = ((60.0 if J.t(J.mod(v_i_3689, 2.0)) else 66.0) if J.cmp(env["n"], 3.0, ">=") else 74.0)
	var _t4071 = J.cmp(env["n"], 3.0, ">=")
	var _t4074 = ((-8.0) if J.t((J.mod(v_i_3689, 2.0) if _t4071 else _t4071)) else 0.0)
	var _t4075 = env["un"]
	var _t4073 = env["__p"]["__p"]["fy"]
	var _t4077 = J.sub(J.cl(_t4073, null, [env["f"]]), 16.0)
	var _t4076 = J.gp(env["hh"], "brave")
	v_r_3692 = {"h": _t4072, "dy": _t4074, "unit": _t4075, "sprite": v_sp_3688, "x": v_px_3691, "y": _t4077, "fear": 0.0, "brave": (_t4076 if J.t(_t4076) else 0.0), "state": "home", "vx": 0.0, "doorT": (8.0 + J.mul(J.cl(env["__p"]["__p"]["rnd"], null, []), 10.0)), "hh": J.gp(env["L"], 4.0), "awake": J.seq(J.gp(J.gp(env["hh"], "awake"), 0.0), 1.0), "idleT": (4.0 + J.mul(J.cl(env["__p"]["__p"]["rnd"], null, []), 10.0))}
	if J.t(J.gp(env["hh"], "away")):
		J.sp(v_r_3692, "state", "away")
	var _t4078 = J.gp(env["__p"]["__p"]["G"], "res")
	J.mc(_t4078, "push", [v_r_3692])
	var _t4079 = J.gp(env["un"], "rs")
	J.mc(_t4079, "push", [v_r_3692])

func _f609(this_, a: Array, env):
	var v_p_3695 = null; var v_i_3696 = null
	v_p_3695 = J.arg(a, 0)
	v_i_3696 = J.arg(a, 1)
	var _t4083 = J.gp(env["un"], "props")
	J.mc(_t4083, "push", [{"k": v_p_3695, "x": J.add(J.add(J.gp(J.gp(env["un"], "rx"), 0.0), J.mul(env["w0"], (0.3 + J.mul(0.4, v_i_3696)))), (8.0 if J.t(v_i_3696) else (-8.0))), "t": 0.0, "cd": 0.0}])

func _f605(this_, a: Array, env):
	var v_u_3671 = null; var v_w_3672 = null; var v_did_3675 = null; var v_e_3676 = null
	var _s1472 = {"__p": env, "L": null, "f": null, "hh": null, "id": null, "un": null, "n": null, "w0": null}
	_s1472["L"] = J.arg(a, 0)
	_s1472["f"] = J.gp(_s1472["L"], 0.0)
	v_u_3671 = J.gp(_s1472["L"], 1.0)
	v_w_3672 = J.gp(_s1472["L"], 2.0)
	_s1472["hh"] = (J.gp(_s1472["__p"]["__p"]["HH"], J.gp(_s1472["L"], 4.0)) if J.t(J.gp(_s1472["L"], 4.0)) else null)
	_s1472["id"] = J.add((J.add("f", _s1472["f"]) + "_i"), v_u_3671)
	v_did_3675 = J.add((J.add("f", _s1472["f"]) + "_d"), v_u_3671)
	var _t4042 = J.gp(J.gp(J.gp(_s1472["__p"]["__p"]["G"], "nodes"), v_did_3675), "links")
	v_e_3676 = J.gp(J.mc(_t4042, "find", [Callable(self, "_f606").bind(_s1472)]), "e")
	J.sp(v_e_3676, "ward", v_w_3672)
	var _t4044 = _s1472["f"]
	var _t4045 = _s1472["id"]
	var _t4046 = J.cmp(J.gp(_s1472["L"], 5.0), 0.0, ">=")
	var _t4047 = J.gp(_s1472["L"], 5.0)
	var _t4048 = J.gp(_s1472["L"], 6.0)
	var _t4049 = J.gp(J.gp(J.gp(_s1472["__p"]["__p"]["G"], "nodes"), v_did_3675), "x")
	var _t4043 = _s1472["__p"]["__p"]["fy"]
	_s1472["un"] = {"f": _t4044, "u": v_u_3671, "id": _t4045, "did": v_did_3675, "ward": v_w_3672, "task": null, "story": _t4046, "si": _t4047, "name": _t4048, "x": _t4049, "y": J.cl(_t4043, null, [_s1472["f"]]), "rx": J.gp(_s1472["L"], 8.0), "lit": false, "litT": 0.0, "hh": J.gp(_s1472["L"], 4.0), "open": true, "ot": 0.0, "cost": 0.0, "paid": 0.0, "seen": false, "entered": false, "plus": (2.0 if J.cmp(J.gp(_s1472["L"], 5.0), 0.0, ">=") else 1.0), "items": [], "door": false, "doorOpen": 0.0, "ambush": null, "dep": null, "keyNeed": null, "rs": [], "props": []}
	var _t4050 = J.seq(v_w_3672, "fu")
	var _t4051 = (_t4050 if _t4050 else J.seq(v_w_3672, "menshen"))
	if (_t4051 if _t4051 else J.seq(v_w_3672, "datuk")):
		var _t4052 = _s1472["un"]
		J.sp(_t4052, "open", false)
		var _t4053 = _s1472["un"]
		J.sp(_t4053, "ot", "deity")
	else:
		if J.seq(v_w_3672, "zha"):
			var _t4054 = _s1472["un"]
			J.sp(_t4054, "open", false)
			var _t4055 = _s1472["un"]
			J.sp(_t4055, "ot", 2.0)
			var _t4056 = _s1472["un"]
			var _t4057 = J.add(4.0, _s1472["f"])
			J.sp(_t4056, "cost", _t4057)
		else:
			if J.seq(v_w_3672, "nuomi"):
				var _t4058 = _s1472["un"]
				J.sp(_t4058, "open", false)
				var _t4059 = _s1472["un"]
				J.sp(_t4059, "ot", 2.0)
				var _t4060 = _s1472["un"]
				var _t4061 = J.add(3.0, _s1472["f"])
				J.sp(_t4060, "cost", _t4061)
	if J.t(_s1472["hh"]):
		var _t4062 = J.gp(_s1472["hh"], "items")
		J.mc(_t4062, "forEach", [Callable(self, "_f607").bind(_s1472)])
	else:
		var _t4064 = J.seq(_s1472["f"], 1.0)
		if ((not J.seq(J.gp(_s1472["un"], "ot"), "deity")) if _t4064 else _t4064):
			var _t4065 = J.gp(_s1472["un"], "items")
			var _t4066 = _s1472["__p"]["__p"]["pick"]
			J.mc(_t4065, "push", [J.cl(_t4066, null, [["food", "money", "comb"]])])
	if J.t(((not J.seq(J.gp(_s1472["un"], "ot"), "deity")) if J.t(_s1472["hh"]) else _s1472["hh"])):
		_s1472["n"] = J.len(J.gp(_s1472["hh"], "sp"))
		_s1472["w0"] = J.sub(J.gp(J.gp(_s1472["un"], "rx"), 1.0), J.gp(J.gp(_s1472["un"], "rx"), 0.0))
		var _t4067 = J.gp(_s1472["hh"], "sp")
		J.mc(_t4067, "forEach", [Callable(self, "_f608").bind(_s1472)])
		var _t4080 = _s1472["un"]
		var _t4081 = J.gp(J.gp(_s1472["un"], "rs"), 0.0)
		J.sp(_t4080, "res", _t4081)
		var _t4082 = J.gp(_s1472["hh"], "props")
		J.mc(_t4082, "forEach", [Callable(self, "_f609").bind(_s1472)])
	var _t4084 = J.gp(_s1472["__p"]["__p"]["G"], "units")
	J.mc(_t4084, "push", [_s1472["un"]])
	var _t4085 = _s1472["un"]
	J.sp(v_e_3676, "unit", _t4085)

func _f611(this_, a: Array, env):
	var v_v_3703 = null
	v_v_3703 = J.arg(a, 0)
	var _t4089 = J.seq(J.gp(v_v_3703, "f"), J.gp(env["u"], "f"))
	var _t4090 = ((not J.seq(v_v_3703, env["u"])) if _t4089 else _t4089)
	var _t4091 = (J.len(J.gp(v_v_3703, "rs")) if _t4090 else _t4090)
	var _t4092 = ((not J.seq(J.gp(v_v_3703, "ot"), "deity")) if J.t(_t4091) else _t4091)
	return (J.seq(absf(J.num(J.sub(J.gp(v_v_3703, "u"), J.gp(env["u"], "u")))), 1.0) if J.t(_t4092) else _t4092)

func _f610(this_, a: Array, env):
	var v_nb_3700 = null
	var _s1482 = {"__p": env, "u": null}
	_s1482["u"] = J.arg(a, 0)
	var _t4087 = (not J.seq(J.gp(_s1482["u"], "ot"), 0.0))
	if (_t4087 if _t4087 else J.cmp(J.gp(_s1482["u"], "f"), 2.0, "<")):
		return null
	var _t4088 = J.gp(_s1482["__p"]["__p"]["G"], "units")
	v_nb_3700 = J.gp(J.mc(_t4088, "filter", [Callable(self, "_f611").bind(_s1482)]), 0.0)
	var _t4094 = v_nb_3700
	if J.t(_t4094):
		var _t4093 = J.gp(_s1482["u"], "story")
		_t4094 = (_t4093 if J.t(_t4093) else J.cmp(J.cl(_s1482["__p"]["__p"]["rnd"], null, []), 0.22, "<"))
	if J.t(_t4094):
		var _t4095 = _s1482["u"]
		J.sp(_t4095, "open", false)
		var _t4096 = _s1482["u"]
		J.sp(_t4096, "ot", 1.0)
		var _t4097 = _s1482["u"]
		J.sp(_t4097, "dep", v_nb_3700)

func _f612(this_, a: Array, env):
	var v_u_3706 = null
	v_u_3706 = J.arg(a, 0)
	var _t4099 = J.seq(J.gp(v_u_3706, "ot"), 0.0)
	var _t4100 = (J.cmp(J.gp(v_u_3706, "f"), J.sub(env["__p"]["FL"], 3.0), ">=") if _t4099 else _t4099)
	return (J.len(J.gp(v_u_3706, "rs")) if _t4100 else _t4100)

func _f613(this_, a: Array, env):
	var v_a_3709 = null; var v_b_3710 = null
	v_a_3709 = J.arg(a, 0)
	v_b_3710 = J.arg(a, 1)
	return J.sub(J.gp(v_b_3710, "f"), J.gp(v_a_3709, "f"))

func _f614(this_, a: Array, env):
	var v_kn_3713 = null; var v_i_3714 = null; var v_t_3715 = null
	v_kn_3713 = J.arg(a, 0)
	v_i_3714 = J.arg(a, 1)
	v_t_3715 = J.gp(env["tops"], J.mul(v_i_3714, 2.0))
	if J.t(v_t_3715):
		J.sp(v_t_3715, "open", false)
		J.sp(v_t_3715, "ot", 11.0)
		J.sp(v_t_3715, "keyNeed", v_kn_3713)
		J.mc(env["keyUnits"], "push", [v_t_3715])

func _f615(this_, a: Array, env):
	var v_u_3718 = null
	v_u_3718 = J.arg(a, 0)
	var _t4103 = (not J.seq(J.gp(v_u_3718, "ot"), "deity"))
	return (J.cmp(J.mc(env["keyUnits"], "indexOf", [v_u_3718]), 0.0, "<") if _t4103 else _t4103)

func _f617(this_, a: Array, env):
	var v_u_3726 = null
	v_u_3726 = J.arg(a, 0)
	return J.cmp(J.gp(v_u_3726, "f"), J.sub(J.gp(J.gp(env["__p"]["keyUnits"], env["i"]), "f"), 1.0), "<")

func _f616(this_, a: Array, env):
	var v_kn_3721 = null; var v_c_3723 = null
	var _s1490 = {"__p": env, "i": null}
	v_kn_3721 = J.arg(a, 0)
	_s1490["i"] = J.arg(a, 1)
	if (not J.t(J.gp(_s1490["__p"]["keyUnits"], _s1490["i"]))):
		return null
	var _t4104 = _s1490["__p"]["__p"]["shuffle"]
	v_c_3723 = J.gp(J.cl(_t4104, null, [J.mc(_s1490["__p"]["cand"], "filter", [Callable(self, "_f617").bind(_s1490)])]), 0.0)
	if J.t(v_c_3723):
		var _t4105 = J.gp(v_c_3723, "items")
		J.mc(_t4105, "push", [v_kn_3721])

func _f618(this_, a: Array, env):
	var v_u_3729 = null
	v_u_3729 = J.arg(a, 0)
	if J.cmp(env["dolls"], 12.0, "<"):
		var _t4108 = J.gp(v_u_3729, "items")
		J.mc(_t4108, "push", ["doll"])
		env["dolls"] = J.num(env["dolls"]) + 1.0

func _f619(this_, a: Array, env):
	var v_u_3732 = null
	v_u_3732 = J.arg(a, 0)
	var _t4111 = J.len(J.gp(v_u_3732, "rs"))
	var _t4112 = (J.seq(J.gp(v_u_3732, "ot"), 0.0) if J.t(_t4111) else _t4111)
	return (J.cmp(J.gp(v_u_3732, "f"), 2.0, ">=") if J.t(_t4112) else _t4112)

func _f620(this_, a: Array, env):
	var v_u_3735 = null
	v_u_3735 = J.arg(a, 0)
	J.sp(v_u_3735, "door", true)

func _f621(this_, a: Array, env):
	var v_u_3738 = null
	v_u_3738 = J.arg(a, 0)
	var _t4117 = (not J.t(J.len(J.gp(v_u_3738, "rs"))))
	var _t4118 = ((not J.seq(J.gp(v_u_3738, "ot"), "deity")) if _t4117 else _t4117)
	return (J.cmp(J.gp(v_u_3738, "f"), 1.0, ">=") if _t4118 else _t4118)

func _f622(this_, a: Array, env):
	var v_u_3741 = null
	v_u_3741 = J.arg(a, 0)
	J.sp(v_u_3741, "ambush", "dog")

func _f623(this_, a: Array, env):
	var v_u_3744 = null
	v_u_3744 = J.arg(a, 0)
	var _t4122 = J.seq(J.gp(v_u_3744, "ot"), 0.0)
	var _t4123 = (_t4122 if _t4122 else J.seq(J.gp(v_u_3744, "ot"), "deity"))
	var _t4124 = ((not J.t(J.gp(v_u_3744, "ambush"))) if _t4123 else _t4123)
	var _t4125 = (J.cmp(J.gp(v_u_3744, "f"), 1.0, "<=") if _t4124 else _t4124)
	J.sp(v_u_3744, "seen", _t4125)
	var _t4126 = J.seq(J.gp(v_u_3744, "ot"), 0.0)
	var _t4127 = ((not J.t(J.gp(v_u_3744, "ambush"))) if _t4126 else _t4126)
	var _t4128 = (J.cmp(J.gp(v_u_3744, "f"), 1.0, ">") if _t4127 else _t4127)
	if (J.cmp(J.cl(env["__p"]["rnd"], null, []), 0.5, "<") if _t4128 else _t4128):
		J.sp(v_u_3744, "seen", true)

func _f624(this_, a: Array, env):
	var v_u_3747 = null
	v_u_3747 = J.arg(a, 0)
	return J.seq(J.gp(v_u_3747, "f"), env["f"])

func _f625(this_, a: Array, env):
	var v_u_3750 = null
	v_u_3750 = J.arg(a, 0)
	var _t4138 = J.seq(J.gp(v_u_3750, "hh"), "elder")
	var _t4139 = (_t4138 if _t4138 else J.seq(J.gp(v_u_3750, "hh"), "granny"))
	var _t4140 = (J.cmp(J.gp(v_u_3750, "f"), 2.0, ">=") if _t4139 else _t4139)
	return (J.gp(v_u_3750, "open") if _t4140 else _t4140)

func _f626(this_, a: Array, env):
	var v_u_3753 = null
	v_u_3753 = J.arg(a, 0)
	var _t4142 = J.seq(J.gp(v_u_3753, "hh"), "elder")
	return (_t4142 if _t4142 else J.seq(J.gp(v_u_3753, "hh"), "granny"))

func _f627(this_, a: Array, env):
	var v_u_3756 = null
	v_u_3756 = J.arg(a, 0)
	var _t4147 = (not J.seq(v_u_3756, env["ow"]))
	return ((absf(J.num(J.sub(J.gp(v_u_3756, "f"), J.gp(env["ow"], "f")))) >= 2.0) if _t4147 else _t4147)

func _f628(this_, a: Array, env):
	var v_u_3759 = null
	v_u_3759 = J.arg(a, 0)
	return J.seq(J.gp(v_u_3759, "hh"), "debt")

func _f629(this_, a: Array, env):
	var v_u_3762 = null
	v_u_3762 = J.arg(a, 0)
	return J.seq(J.gp(v_u_3762, "hh"), "mahjong")

func _f604(this_, a: Array, env):
	var v_keyNames_3654 = null; var v_ds_3660 = null; var v_olds_3661 = null; var v_thing_3663 = null; var v_hid_3664 = null; var v_dbt_3665 = null; var v_mj_3666 = null
	var _s1471 = {"__p": env, "tops": null, "keyUnits": null, "cand": null, "dolls": null, "f": null, "ow": null}
	var _t4039 = _s1471["__p"]["G"]
	var _t4040 = []
	J.sp(_t4039, "traces", _t4040)
	var _t4041 = J.gp(_s1471["__p"]["LV"], "units")
	J.mc(_t4041, "forEach", [Callable(self, "_f605").bind(_s1471)])
	var _t4086 = J.gp(_s1471["__p"]["G"], "units")
	J.mc(_t4086, "forEach", [Callable(self, "_f610").bind(_s1471)])
	v_keyNames_3654 = ["key", "key2"]
	var _t4098 = J.gp(_s1471["__p"]["G"], "units")
	var _t4101 = J.mc(_t4098, "filter", [Callable(self, "_f612").bind(_s1471)])
	_s1471["tops"] = J.mc(_t4101, "sort", [Callable(self, "_f613").bind(_s1471)])
	_s1471["keyUnits"] = []
	J.mc(v_keyNames_3654, "forEach", [Callable(self, "_f614").bind(_s1471)])
	var _t4102 = J.gp(_s1471["__p"]["G"], "units")
	_s1471["cand"] = J.mc(_t4102, "filter", [Callable(self, "_f615").bind(_s1471)])
	J.mc(v_keyNames_3654, "forEach", [Callable(self, "_f616").bind(_s1471)])
	_s1471["dolls"] = 0.0
	var _t4106 = _s1471["__p"]["shuffle"]
	var _t4107 = J.cl(_t4106, null, [_s1471["cand"]])
	J.mc(_t4107, "forEach", [Callable(self, "_f618").bind(_s1471)])
	var _t4109 = _s1471["__p"]["shuffle"]
	var _t4110 = J.gp(_s1471["__p"]["G"], "units")
	var _t4113 = J.cl(_t4109, null, [J.mc(_t4110, "filter", [Callable(self, "_f619").bind(_s1471)])])
	var _t4114 = J.mc(_t4113, "slice", [0.0, 6.0])
	J.mc(_t4114, "forEach", [Callable(self, "_f620").bind(_s1471)])
	var _t4115 = _s1471["__p"]["shuffle"]
	var _t4116 = J.gp(_s1471["__p"]["G"], "units")
	var _t4119 = J.cl(_t4115, null, [J.mc(_t4116, "filter", [Callable(self, "_f621").bind(_s1471)])])
	var _t4120 = J.mc(_t4119, "slice", [0.0, 3.0])
	J.mc(_t4120, "forEach", [Callable(self, "_f622").bind(_s1471)])
	var _t4121 = J.gp(_s1471["__p"]["G"], "units")
	J.mc(_t4121, "forEach", [Callable(self, "_f623").bind(_s1471)])
	var _t4129 = _s1471["__p"]["G"]
	var _t4130 = []
	J.sp(_t4129, "cprops", _t4130)
	_s1471["f"] = 1.0
	while true:
		if not J.cmp(_s1471["f"], _s1471["__p"]["FL"], "<"): break
		var _t4131 = _s1471["__p"]["shuffle"]
		var _t4132 = J.gp(_s1471["__p"]["G"], "units")
		v_ds_3660 = J.cl(_t4131, null, [J.mc(_t4132, "filter", [Callable(self, "_f624").bind(_s1471)])])
		if J.t(J.gp(v_ds_3660, 0.0)):
			var _t4133 = J.gp(_s1471["__p"]["G"], "cprops")
			J.mc(_t4133, "push", [{"k": "pipeK", "node": J.gp(J.gp(v_ds_3660, 0.0), "did"), "f": _s1471["f"], "t": 0.0, "cd": 0.0}])
		if J.t(J.gp(v_ds_3660, 1.0)):
			var _t4134 = J.gp(_s1471["__p"]["G"], "cprops")
			J.mc(_t4134, "push", [{"k": "light", "node": J.gp(J.gp(v_ds_3660, 1.0), "did"), "f": _s1471["f"], "t": 0.0, "cd": 0.0}])
		_s1471["f"] = J.num(_s1471["f"]) + 1.0
	var _t4135 = _s1471["__p"]["G"]
	var _t4136 = []
	J.sp(_t4135, "quests", _t4136)
	var _t4137 = J.gp(_s1471["__p"]["G"], "units")
	v_olds_3661 = J.mc(_t4137, "filter", [Callable(self, "_f625").bind(_s1471)])
	if (not J.t(J.len(v_olds_3661))):
		var _t4141 = J.gp(_s1471["__p"]["G"], "units")
		var _t4143 = J.mc(_t4141, "filter", [Callable(self, "_f626").bind(_s1471)])
		v_olds_3661 = _t4143
	if J.t(J.len(v_olds_3661)):
		var _t4144 = _s1471["__p"]["pick"]
		_s1471["ow"] = J.cl(_t4144, null, [v_olds_3661])
		var _t4145 = _s1471["__p"]["pick"]
		v_thing_3663 = J.cl(_t4145, null, [["老花鏡", "假牙", "結婚戒指", "錢罌"]])
		var _t4146 = _s1471["__p"]["shuffle"]
		v_hid_3664 = J.gp(J.cl(_t4146, null, [J.mc(_s1471["cand"], "filter", [Callable(self, "_f627").bind(_s1471)])]), 0.0)
		if J.t(v_hid_3664):
			var _t4148 = J.gp(v_hid_3664, "items")
			J.mc(_t4148, "unshift", ["lost"])
			var _t4149 = J.gp(_s1471["__p"]["G"], "quests")
			J.mc(_t4149, "push", [{"id": "lost", "t": J.add((J.add(J.add("搵返", J.gp(_s1471["__p"]["FLN"], J.gp(_s1471["ow"], "f"))), J.mc(_s1471["__p"]["LV0K"], "who", [_s1471["ow"]])) + "嘅"), v_thing_3663), "thing": v_thing_3663, "owner": _s1471["ow"], "hid": v_hid_3664, "state": 0.0}])
			var _t4150 = _s1471["ow"]
			J.sp(_t4150, "questMark", 1.0)
	var _t4151 = J.gp(_s1471["__p"]["G"], "units")
	v_dbt_3665 = J.mc(_t4151, "find", [Callable(self, "_f628").bind(_s1471)])
	if J.t(v_dbt_3665):
		var _t4152 = J.gp(_s1471["__p"]["G"], "quests")
		J.mc(_t4152, "push", [{"id": "debt", "t": (J.add("嚇走", J.gp(_s1471["__p"]["FLN"], J.gp(v_dbt_3665, "f"))) + "拍門嘅收數佬"), "unit": v_dbt_3665, "state": 0.0, "at": (30.0 + J.mul(J.cl(_s1471["__p"]["rnd"], null, []), 25.0))}])
	var _t4153 = J.gp(_s1471["__p"]["G"], "units")
	v_mj_3666 = J.mc(_t4153, "find", [Callable(self, "_f629").bind(_s1471)])
	if J.t(v_mj_3666):
		var _t4154 = J.gp(_s1471["__p"]["G"], "quests")
		J.mc(_t4154, "push", [{"id": "mj", "t": (J.add("散咗", J.gp(_s1471["__p"]["FLN"], J.gp(v_mj_3666, "f"))) + "嘅麻雀局（四個都嚇走）"), "unit": v_mj_3666, "state": 0.0}])
	var _t4155 = _s1471["__p"]["G"]
	var _t4156 = []
	J.sp(_t4155, "relief", _t4156)
	var _t4157 = _s1471["__p"]["G"]
	J.sp(_t4157, "alertAcc", 0.0)

func _f632(this_, a: Array, env):
	var v_r_3791 = null; var v_dx_3792 = null; var v_dy_3793 = null; var v_dw_3794 = null; var v_dh_3795 = null; var v_flip_3796 = null; var v_dark_3797 = null
	v_r_3791 = J.arg(a, 0)
	v_dx_3792 = J.arg(a, 1)
	v_dy_3793 = J.arg(a, 2)
	v_dw_3794 = J.arg(a, 3)
	v_dh_3795 = J.arg(a, 4)
	v_flip_3796 = J.arg(a, 5)
	v_dark_3797 = J.arg(a, 6)
	var _t4158 = (not J.t(env["img"]))
	if (_t4158 if _t4158 else (not J.t(J.gp(env["img"], "width")))):
		var _t4159 = env["c"]
		J.sp(_t4159, "fillStyle", "#222")
		J.mc(env["c"], "fillRect", [v_dx_3792, v_dy_3793, v_dw_3794, v_dh_3795])
		return null
	J.mc(env["c"], "save", [])
	if J.t((v_flip_3796 if J.t(v_flip_3796) else J.gp(v_r_3791, 4.0))):
		J.mc(env["c"], "translate", [J.add(v_dx_3792, v_dw_3794), v_dy_3793])
		J.mc(env["c"], "scale", [(-1.0), 1.0])
		v_dx_3792 = 0.0
		v_dy_3793 = 0.0
	J.mc(env["c"], "drawImage", [env["img"], J.mul(J.gp(v_r_3791, 0.0), env["k"]), J.mul(J.gp(v_r_3791, 2.0), env["k"]), J.mul(J.sub(J.gp(v_r_3791, 1.0), J.gp(v_r_3791, 0.0)), env["k"]), J.mul(J.sub(J.gp(v_r_3791, 3.0), J.gp(v_r_3791, 2.0)), env["k"]), v_dx_3792, v_dy_3793, v_dw_3794, v_dh_3795])
	J.mc(env["c"], "restore", [])
	if J.t(v_dark_3797):
		var _t4160 = env["c"]
		J.sp(_t4160, "fillStyle", v_dark_3797)
		J.mc(env["c"], "fillRect", [(v_dx_3792 if J.t((v_flip_3796 if J.t(v_flip_3796) else J.gp(v_r_3791, 4.0))) else v_dx_3792), v_dy_3793, v_dw_3794, v_dh_3795])

func _f634(this_, a: Array, env):
	var v_k_3839 = null; var v_im_3840 = null
	v_k_3839 = J.arg(a, 0)
	var _t4161 = J.gp(env["__p"]["__p"]["IMG"], J.add("twt_", v_k_3839))
	v_im_3840 = (_t4161 if J.t(_t4161) else (J.gp(J.G.get("SPR"), J.add("twt_", v_k_3839)) if (not J.seq(J.typeof_(J.G.get("SPR")), "undefined")) else null))
	var _t4163 = v_im_3840
	if J.t(_t4163):
		var _t4162 = J.gp(v_im_3840, "naturalWidth")
		_t4163 = (_t4162 if J.t(_t4162) else J.gp(v_im_3840, "width"))
	return (v_im_3840 if J.t(_t4163) else null)

func _f636(this_, a: Array, env):
	var v_a_3846 = null; var v_b_3847 = null; var v_d_3848 = null; var v_h_3849 = null
	v_a_3846 = J.arg(a, 0)
	v_b_3847 = J.arg(a, 1)
	v_d_3848 = J.arg(a, 2)
	v_h_3849 = J.bxor(J.bxor(J.math("imul", [J.add(v_a_3846, 1.0), 73856093.0]), J.math("imul", [J.add(v_b_3847, 7.0), 19349663.0])), J.math("imul", [J.add(v_d_3848, 3.0), 83492791.0]))
	var _t4164 = J.math("imul", [J.bxor(v_h_3849, J.ushr(v_h_3849, 13.0)), 1274126177.0])
	v_h_3849 = _t4164
	return J.ushr(J.bxor(v_h_3849, J.ushr(v_h_3849, 16.0)), 0.0)

func _f637(this_, a: Array, env):
	var v_k_3852 = null; var v_sx0_3853 = null; var v_sx1_3854 = null; var v_sy0_3855 = null; var v_x0_3856 = null; var v_w_3857 = null; var v_top_3858 = null; var v_floor_3859 = null; var v_flip_3860 = null; var v_tint_3861 = null; var v_im_3862 = null; var v_q_3863 = null; var v_s_3864 = null; var v_h_3865 = null
	v_k_3852 = J.arg(a, 0)
	v_sx0_3853 = J.arg(a, 1)
	v_sx1_3854 = J.arg(a, 2)
	v_sy0_3855 = J.arg(a, 3)
	v_x0_3856 = J.arg(a, 4)
	v_w_3857 = J.arg(a, 5)
	v_top_3858 = J.arg(a, 6)
	v_floor_3859 = J.arg(a, 7)
	v_flip_3860 = J.arg(a, 8)
	v_tint_3861 = J.arg(a, 9)
	v_im_3862 = J.gp(env["T"], v_k_3852)
	var _t4165 = J.gp(v_im_3862, "naturalWidth")
	v_q_3863 = J.div((_t4165 if J.t(_t4165) else J.gp(v_im_3862, "width")), env["N"])
	v_s_3864 = J.div(J.sub(v_floor_3859, v_top_3858), J.sub(J.gp(env["FLY"], v_k_3852), v_sy0_3855))
	v_h_3865 = J.mul(J.sub(env["N"], v_sy0_3855), v_s_3864)
	J.mc(env["__p"]["c"], "save", [])
	if J.t(v_flip_3860):
		J.mc(env["__p"]["c"], "translate", [J.add(v_x0_3856, v_w_3857), 0.0])
		J.mc(env["__p"]["c"], "scale", [(-1.0), 1.0])
		J.mc(env["__p"]["c"], "drawImage", [v_im_3862, J.mul(v_sx0_3853, v_q_3863), J.mul(v_sy0_3855, v_q_3863), J.mul(J.sub(v_sx1_3854, v_sx0_3853), v_q_3863), J.mul(J.sub(env["N"], v_sy0_3855), v_q_3863), 0.0, v_top_3858, v_w_3857, v_h_3865])
	else:
		J.mc(env["__p"]["c"], "drawImage", [v_im_3862, J.mul(v_sx0_3853, v_q_3863), J.mul(v_sy0_3855, v_q_3863), J.mul(J.sub(v_sx1_3854, v_sx0_3853), v_q_3863), J.mul(J.sub(env["N"], v_sy0_3855), v_q_3863), v_x0_3856, v_top_3858, v_w_3857, v_h_3865])
	J.mc(env["__p"]["c"], "restore", [])
	if J.t(v_tint_3861):
		var _t4166 = env["__p"]["c"]
		J.sp(_t4166, "fillStyle", v_tint_3861)
		J.mc(env["__p"]["c"], "fillRect", [v_x0_3856, v_top_3858, v_w_3857, v_h_3865])

func _f635(this_, a: Array, env):
	var v_k_3843 = null
	v_k_3843 = J.arg(a, 0)
	var _t4168 = env["T"]
	var _t4169 = env["TI"]
	var _t4170 = J.cl(_t4169, null, [v_k_3843])
	J.sp(_t4168, v_k_3843, _t4170)
	if (not J.t(J.gp(env["T"], v_k_3843))):
		env["ok"] = false

func _f639(this_, a: Array, env):
	var v_q_3888 = null
	v_q_3888 = J.arg(a, 0)
	var _t4186 = J.seq(J.gp(v_q_3888, "f"), env["__p"]["f"])
	return (J.seq(J.gp(J.gp(v_q_3888, "rx"), 0.0), env["x0"]) if _t4186 else _t4186)

func _f638(this_, a: Array, env):
	var v_col_3868 = null; var v_ci_3869 = null; var v_w_3871 = null; var v_kd_3872 = null; var v_h0_3873 = null; var v_tn_3874 = null; var v_up_3875 = null; var v_un_3876 = null; var v_deity_3877 = null; var v_rk_3878 = null; var v_ri_3879 = null; var v_r_3880 = null; var v_two_3881 = null; var v_dx_3882 = null; var v_p_3883 = null; var v_px_3884 = null; var v_py_3885 = null
	var _s1526 = {"__p": env, "x0": null}
	v_col_3868 = J.arg(a, 0)
	v_ci_3869 = J.arg(a, 1)
	_s1526["x0"] = J.gp(v_col_3868, 0.0)
	v_w_3871 = J.sub(J.gp(v_col_3868, 1.0), J.gp(v_col_3868, 0.0))
	v_kd_3872 = J.gp(v_col_3868, 2.0)
	var _t4175 = _s1526["__p"]["hs"]
	v_h0_3873 = J.cl(_t4175, null, [_s1526["__p"]["KK"], _s1526["__p"]["f"], v_ci_3869])
	v_tn_3874 = (_s1526["__p"]["BT"] if J.seq(_s1526["__p"]["f"], 0.0) else null)
	var _t4176 = J.seq(v_kd_3872, "stair")
	var _t4178 = (_t4176 if _t4176 else J.seq(v_kd_3872, "back"))
	if not J.t(_t4178):
		var _t4177 = J.seq(v_kd_3872, "lift")
		_t4178 = ((not J.t(J.gp(_s1526["__p"]["__p"]["__p"]["LV"], "lift"))) if _t4177 else _t4177)
	if _t4178:
		var _t4179 = J.seq(v_kd_3872, "back")
		var _t4180 = (J.seq(_s1526["__p"]["f"], 0.0) if _t4179 else _t4179)
		if ((not J.t(J.gp(J.gp(_s1526["__p"]["__p"]["__p"]["G"], "nodes"), "f0_b"))) if _t4180 else _t4180):
			var _t4181 = _s1526["__p"]["tile"]
			J.cl(_t4181, null, ["carpark", 296.0, _s1526["__p"]["N"], 0.0, _s1526["x0"], v_w_3871, _s1526["__p"]["top"], _s1526["__p"]["floor"], false, "rgba(10,20,40,0.16)"])
			return null
		v_up_3875 = ("R" if J.seq(v_kd_3872, "stair") else ("L" if J.seq(v_kd_3872, "back") else ("L" if J.t(J.mod(_s1526["__p"]["f"], 2.0)) else "R")))
		if J.seq(v_up_3875, "R"):
			var _t4182 = _s1526["__p"]["tile"]
			J.cl(_t4182, null, ["stairR", 62.0, _s1526["__p"]["N"], 0.0, _s1526["x0"], v_w_3871, _s1526["__p"]["top"], _s1526["__p"]["floor"], false, v_tn_3874])
		else:
			var _t4183 = _s1526["__p"]["tile"]
			J.cl(_t4183, null, ["stairL", 0.0, 354.0, 0.0, _s1526["x0"], v_w_3871, _s1526["__p"]["top"], _s1526["__p"]["floor"], false, v_tn_3874])
		return null
	if J.seq(v_kd_3872, "lift"):
		var _t4184 = _s1526["__p"]["tile"]
		J.cl(_t4184, null, ["lift", 58.0, 360.0, (0.0 if J.seq(_s1526["__p"]["f"], J.sub(_s1526["__p"]["__p"]["__p"]["FL"], 1.0)) else 46.0), _s1526["x0"], v_w_3871, _s1526["__p"]["top"], _s1526["__p"]["floor"], false, v_tn_3874])
		return null
	var _t4185 = J.gp(_s1526["__p"]["__p"]["__p"]["G"], "units")
	v_un_3876 = J.mc(_t4185, "find", [Callable(self, "_f639").bind(_s1526)])
	v_deity_3877 = (J.seq(J.gp(v_un_3876, "ot"), "deity") if J.t(v_un_3876) else v_un_3876)
	var _t4187 = ((not J.t(v_deity_3877)) if J.t(v_un_3876) else v_un_3876)
	v_rk_3878 = (J.gp(_s1526["__p"]["RM"], J.gp(v_un_3876, "hh")) if J.t((J.cmp(_s1526["__p"]["f"], 1.0, ">=") if J.t(_t4187) else _t4187)) else null)
	v_ri_3879 = (J.gp(_s1526["__p"]["__p"]["__p"]["IMG"], v_rk_3878) if J.t(v_rk_3878) else v_rk_3878)
	if J.seq(_s1526["__p"]["f"], 0.0):
		var _t4188 = _s1526["__p"]["tile"]
		J.cl(_t4188, null, ["carpark", 0.0, _s1526["__p"]["N"], 0.0, _s1526["x0"], v_w_3871, _s1526["__p"]["top"], _s1526["__p"]["floor"], J.band(J.ushr(v_h0_3873, 5.0), 1.0), "rgba(10,20,40,0.16)"])
		_s1526["__p"]["c2prev"] = false
		return null
	if J.t((J.gp(v_ri_3879, "width") if J.t(v_ri_3879) else v_ri_3879)):
		J.mc(_s1526["__p"]["__p"]["c"], "save", [])
		if J.seq(J.mod(J.add(v_ci_3869, _s1526["__p"]["f"]), 2.0), 1.0):
			J.mc(_s1526["__p"]["__p"]["c"], "translate", [J.add(_s1526["x0"], v_w_3871), _s1526["__p"]["top"]])
			J.mc(_s1526["__p"]["__p"]["c"], "scale", [(-1.0), 1.0])
			J.mc(_s1526["__p"]["__p"]["c"], "drawImage", [v_ri_3879, 0.0, 0.0, v_w_3871, _s1526["__p"]["hgt"]])
		else:
			J.mc(_s1526["__p"]["__p"]["c"], "drawImage", [v_ri_3879, _s1526["x0"], _s1526["__p"]["top"], v_w_3871, _s1526["__p"]["hgt"]])
		J.mc(_s1526["__p"]["__p"]["c"], "restore", [])
		var _t4189 = _s1526["__p"]["__p"]["c"]
		J.sp(_t4189, "strokeStyle", "rgba(0,0,0,0.6)")
		var _t4190 = _s1526["__p"]["__p"]["c"]
		J.sp(_t4190, "lineWidth", 3.0)
		J.mc(_s1526["__p"]["__p"]["c"], "strokeRect", [J.add(_s1526["x0"], 1.0), J.add(_s1526["__p"]["top"], 1.0), J.sub(v_w_3871, 2.0), J.sub(_s1526["__p"]["hgt"], 2.0)])
		_s1526["__p"]["c2prev"] = false
		return null
	if J.t(_s1526["__p"]["SHOP"]):
		var _t4194 = null
		if J.t(v_deity_3877):
			_t4194 = J.gp(J.gp(J.gp(_s1526["__p"]["__p"]["B"], "src"), "deity"), 0.0)
		else:
			var _t4193 = null
			if J.seq(_s1526["__p"]["f"], 1.0):
				_t4193 = J.gp(_s1526["__p"]["gPool"], J.mod(J.add(v_ci_3869, _s1526["__p"]["f"]), J.len(_s1526["__p"]["gPool"])))
			else:
				var _t4192 = _s1526["__p"]["resPool"]
				var _t4191 = J.num(_s1526["__p"]["ui"])
				_s1526["__p"]["ui"] = _t4191 + 1.0
				_t4193 = J.gp(_t4192, J.mod(J.add((_t4191 * 5.0), _s1526["__p"]["f"]), J.len(_s1526["__p"]["resPool"])))
			_t4194 = _t4193
		v_r_3880 = _t4194
		var _t4195 = _s1526["__p"]["__p"]["put"]
		J.cl(_t4195, null, [v_r_3880, _s1526["x0"], _s1526["__p"]["top"], v_w_3871, _s1526["__p"]["hgt"], J.seq(J.mod(J.add(v_ci_3869, _s1526["__p"]["f"]), 2.0), 1.0), null])
		return null
	if J.seq(_s1526["__p"]["f"], 1.0):
		var _t4196 = _s1526["__p"]["tile"]
		J.cl(_t4196, null, ["lobby", 0.0, _s1526["__p"]["N"], 0.0, _s1526["x0"], v_w_3871, _s1526["__p"]["top"], _s1526["__p"]["floor"], J.seq(J.mod(v_ci_3869, 2.0), 1.0), null])
		return null
	var _t4197 = (not J.t(v_deity_3877))
	var _t4198 = ((not J.t(_s1526["__p"]["c2prev"])) if _t4197 else _t4197)
	v_two_3881 = ((J.mod(v_h0_3873, 100.0) < 40.0) if _t4198 else _t4198)
	_s1526["__p"]["c2prev"] = v_two_3881
	if J.t(v_two_3881):
		var _t4199 = _s1526["__p"]["tile"]
		J.cl(_t4199, null, ["corr2", 0.0, _s1526["__p"]["N"], 0.0, _s1526["x0"], v_w_3871, _s1526["__p"]["top"], _s1526["__p"]["floor"], J.band(J.ushr(v_h0_3873, 7.0), 1.0), null])
	else:
		var _t4200 = _s1526["__p"]["tile"]
		J.cl(_t4200, null, ["corr1", 0.0, _s1526["__p"]["N"], 0.0, _s1526["x0"], v_w_3871, _s1526["__p"]["top"], _s1526["__p"]["floor"], (J.seq(J.mod(J.gp(v_un_3876, "u"), 2.0), 0.0) if J.t(v_un_3876) else J.band(J.ushr(v_h0_3873, 7.0), 1.0)), null])
		if J.t(v_deity_3877):
			var _t4201 = _s1526["__p"]["__p"]["c"]
			J.sp(_t4201, "fillStyle", "rgba(110,8,8,0.20)")
			J.mc(_s1526["__p"]["__p"]["c"], "fillRect", [_s1526["x0"], _s1526["__p"]["top"], v_w_3871, J.sub(_s1526["__p"]["floor"], _s1526["__p"]["top"])])
			v_dx_3882 = J.gp(v_un_3876, "x")
			v_p_3883 = 0.0
			while true:
				if not J.cmp(v_p_3883, 7.0, "<"): break
				v_px_3884 = (J.sub(v_dx_3882, 15.0) + (J.band(J.ushr(v_h0_3873, J.mul(v_p_3883, 3.0)), 7.0) * 4.3))
				var _t4202 = _s1526["__p"]["__p"]["__p"]["fy"]
				v_py_3885 = ((J.sub(J.cl(_t4202, null, [_s1526["__p"]["f"]]), 92.0) + (J.band(J.ushr(v_h0_3873, (J.mul(v_p_3883, 2.0) + 5.0)), 7.0) * 9.0)) + J.mul(v_p_3883, 3.0))
				J.mc(_s1526["__p"]["__p"]["c"], "save", [])
				J.mc(_s1526["__p"]["__p"]["c"], "translate", [v_px_3884, v_py_3885])
				J.mc(_s1526["__p"]["__p"]["c"], "rotate", [((J.band(J.ushr(v_h0_3873, J.add(v_p_3883, 9.0)), 7.0) - 3.5) * 0.05)])
				var _t4203 = _s1526["__p"]["__p"]["c"]
				var _t4204 = ("#9e1e1a" if J.t(J.mod(v_p_3883, 3.0)) else "#c0281f")
				J.sp(_t4203, "fillStyle", _t4204)
				J.mc(_s1526["__p"]["__p"]["c"], "fillRect", [(-4.5), (-10.0), 9.0, 20.0])
				var _t4205 = _s1526["__p"]["__p"]["c"]
				J.sp(_t4205, "fillStyle", "rgba(30,0,0,0.35)")
				J.mc(_s1526["__p"]["__p"]["c"], "fillRect", [2.5, (-10.0), 2.0, 20.0])
				var _t4206 = _s1526["__p"]["__p"]["c"]
				J.sp(_t4206, "fillStyle", "rgba(240,200,90,0.6)")
				J.mc(_s1526["__p"]["__p"]["c"], "fillRect", [(-2.0), (-6.0), 4.0, 1.4])
				J.mc(_s1526["__p"]["__p"]["c"], "fillRect", [(-2.0), (-1.0), 4.0, 1.4])
				J.mc(_s1526["__p"]["__p"]["c"], "fillRect", [(-2.0), 4.0, 4.0, 1.4])
				J.mc(_s1526["__p"]["__p"]["c"], "restore", [])
				v_p_3883 = J.num(v_p_3883) + 1.0

func _f640(this_, a: Array, env):
	var v_col_3891 = null; var v_ci_3892 = null; var v_xb_3893 = null; var v_g_3894 = null
	v_col_3891 = J.arg(a, 0)
	v_ci_3892 = J.arg(a, 1)
	if (not J.t(v_ci_3892)):
		return null
	v_xb_3893 = J.gp(v_col_3891, 0.0)
	v_g_3894 = J.mc(env["__p"]["c"], "createLinearGradient", [J.sub(v_xb_3893, 8.0), 0.0, J.add(v_xb_3893, 8.0), 0.0])
	J.mc(v_g_3894, "addColorStop", [0.0, "rgba(0,0,0,0)"])
	J.mc(v_g_3894, "addColorStop", [0.5, "rgba(0,0,0,0.58)"])
	J.mc(v_g_3894, "addColorStop", [1.0, "rgba(0,0,0,0)"])
	var _t4218 = env["__p"]["c"]
	J.sp(_t4218, "fillStyle", v_g_3894)
	J.mc(env["__p"]["c"], "fillRect", [J.sub(v_xb_3893, 8.0), env["top"], 16.0, J.sub(env["floor"], env["top"])])

func _f641(this_, a: Array, env):
	var v_e_3897 = null; var v_g_3898 = null
	v_e_3897 = J.arg(a, 0)
	v_g_3898 = J.mc(env["__p"]["c"], "createLinearGradient", [J.gp(v_e_3897, 0.0), 0.0, J.add(J.gp(v_e_3897, 0.0), J.mul(J.gp(v_e_3897, 1.0), 28.0)), 0.0])
	J.mc(v_g_3898, "addColorStop", [0.0, "rgba(0,0,0,0.55)"])
	J.mc(v_g_3898, "addColorStop", [1.0, "rgba(0,0,0,0)"])
	var _t4222 = env["__p"]["c"]
	J.sp(_t4222, "fillStyle", v_g_3898)
	J.mc(env["__p"]["c"], "fillRect", [(0.0 if J.cmp(J.gp(v_e_3897, 1.0), 0.0, ">") else J.sub(env["__p"]["__p"]["WW"], 28.0)), 0.0, 28.0, env["__p"]["__p"]["WH"]])

func _f633(this_, a: Array, env):
	var v_bot_3814 = null; var v_rs_3817 = null; var v_rh_3818 = null; var v_rtop_3819 = null; var v_x_3820 = null; var v_i_3821 = null; var v_F_3822 = null; var v_im_3823 = null; var v_q_3824 = null; var v_A_3825 = null; var v_sx1_3826 = null; var v_w_3827 = null; var v_flip_3828 = null; var v_oc_3829 = null; var v_ox_3830 = null; var v_gr_3831 = null; var v_yb_3832 = null; var v_g_3833 = null
	var _s1517 = {"__p": env, "T": null, "ok": null, "N": null, "FLY": null, "KK": null, "SHOP": null, "BT": null, "RM": null, "resPool": null, "gPool": null, "ui": null, "f": null, "top": null, "floor": null, "hgt": null, "c2prev": null, "TI": null, "hs": null, "tile": null}
	_s1517["TI"] = Callable(self, "_f634").bind(_s1517)
	_s1517["hs"] = Callable(self, "_f636").bind(_s1517)
	_s1517["tile"] = Callable(self, "_f637").bind(_s1517)
	_s1517["T"] = {}
	_s1517["ok"] = true
	var _t4167 = ["corr1", "corr2", "stairR", "stairL", "lift", "roof", "lobby", "carpark"]
	J.mc(_t4167, "forEach", [Callable(self, "_f635").bind(_s1517)])
	if (not J.t(_s1517["ok"])):
		return false
	_s1517["N"] = 416.0
	_s1517["FLY"] = {"corr1": 400.0, "corr2": 400.0, "stairR": 398.0, "stairL": 398.0, "lift": 403.0, "roof": 402.0, "lobby": 405.0, "carpark": 405.0}
	_s1517["KK"] = (2.0 if J.seq(J.gp(_s1517["__p"]["__p"]["LV"], "key"), "shop") else 1.0)
	_s1517["SHOP"] = J.seq(J.gp(_s1517["__p"]["__p"]["LV"], "key"), "shop")
	_s1517["BT"] = "rgba(10,20,40,0.34)"
	_s1517["RM"] = {"mahjong": "room_mahjong", "gamer": "room_gamer", "nurse": "room_nurse", "helper": "room_helper", "gym": "room_gym", "shopper": "room_shopper"}
	_s1517["resPool"] = J.gp(J.gp(_s1517["__p"]["B"], "src"), "res")
	_s1517["gPool"] = J.gp(J.gp(_s1517["__p"]["B"], "src"), "ground")
	_s1517["ui"] = 0.0
	_s1517["f"] = 0.0
	while true:
		if not J.cmp(_s1517["f"], _s1517["__p"]["__p"]["FL"], "<"): break
		var _t4171 = _s1517["__p"]["__p"]["fy"]
		_s1517["top"] = J.cl(_t4171, null, [J.add(_s1517["f"], 1.0)])
		var _t4172 = _s1517["__p"]["__p"]["fy"]
		_s1517["floor"] = J.add(J.cl(_t4172, null, [_s1517["f"]]), 3.0)
		var _t4173 = _s1517["__p"]["__p"]["fy"]
		v_bot_3814 = J.add(J.cl(_t4173, null, [_s1517["f"]]), 12.0)
		_s1517["hgt"] = J.sub(v_bot_3814, _s1517["top"])
		_s1517["c2prev"] = false
		var _t4174 = J.gp(_s1517["__p"]["__p"]["LV"], "xs")
		J.mc(_t4174, "forEach", [Callable(self, "_f638").bind(_s1517)])
		_s1517["f"] = J.num(_s1517["f"]) + 1.0
	var _t4207 = _s1517["__p"]["__p"]["fy"]
	v_rs_3817 = J.div(J.add(J.add(J.cl(_t4207, null, [_s1517["__p"]["__p"]["FL"]]), 3.0), 8.0), J.gp(_s1517["FLY"], "roof"))
	v_rh_3818 = J.mul(_s1517["N"], v_rs_3817)
	var _t4208 = _s1517["__p"]["__p"]["fy"]
	v_rtop_3819 = J.sub(J.add(J.cl(_t4208, null, [_s1517["__p"]["__p"]["FL"]]), 3.0), J.mul(J.gp(_s1517["FLY"], "roof"), v_rs_3817))
	v_x_3820 = 0.0
	v_i_3821 = 0.0
	v_F_3822 = 30.0
	v_im_3823 = J.gp(_s1517["T"], "roof")
	var _t4209 = J.gp(v_im_3823, "naturalWidth")
	v_q_3824 = J.div((_t4209 if J.t(_t4209) else J.gp(v_im_3823, "width")), _s1517["N"])
	while true:
		if not J.cmp(v_x_3820, _s1517["__p"]["__p"]["WW"], "<"): break
		v_A_3825 = J.seq(J.mod(v_i_3821, 2.0), 1.0)
		v_sx1_3826 = (196.0 if J.t(v_A_3825) else _s1517["N"])
		v_w_3827 = J.mul(v_sx1_3826, v_rs_3817)
		var _t4211 = null
		if J.t(v_A_3825):
			var _t4210 = _s1517["hs"]
			_t4211 = J.band(J.ushr(J.cl(_t4210, null, [_s1517["KK"], 99.0, v_i_3821]), 3.0), 1.0)
		else:
			_t4211 = J.seq(J.mod(J.shr(v_i_3821, 1.0), 2.0), 1.0)
		v_flip_3828 = _t4211
		v_oc_3829 = J.S_document_("createElement", ["canvas"])
		var _t4212 = J.max_([1.0, ceil(J.num(J.mul(v_w_3827, _s1517["__p"]["SC"])))])
		J.sp(v_oc_3829, "width", _t4212)
		var _t4213 = J.max_([1.0, ceil(J.num(J.mul(v_rh_3818, _s1517["__p"]["SC"])))])
		J.sp(v_oc_3829, "height", _t4213)
		v_ox_3830 = J.mc(v_oc_3829, "getContext", ["2d"])
		if J.t(v_flip_3828):
			J.mc(v_ox_3830, "translate", [J.gp(v_oc_3829, "width"), 0.0])
			J.mc(v_ox_3830, "scale", [(-1.0), 1.0])
		J.mc(v_ox_3830, "drawImage", [v_im_3823, 0.0, 0.0, J.mul(v_sx1_3826, v_q_3824), J.mul(_s1517["N"], v_q_3824), 0.0, 0.0, J.gp(v_oc_3829, "width"), J.gp(v_oc_3829, "height")])
		J.mc(v_ox_3830, "setTransform", [1.0, 0.0, 0.0, 1.0, 0.0, 0.0])
		if J.cmp(v_i_3821, 0.0, ">"):
			J.sp(v_ox_3830, "globalCompositeOperation", "destination-in")
			v_gr_3831 = J.mc(v_ox_3830, "createLinearGradient", [0.0, 0.0, J.mul(v_F_3822, _s1517["__p"]["SC"]), 0.0])
			J.mc(v_gr_3831, "addColorStop", [0.0, "rgba(0,0,0,0)"])
			J.mc(v_gr_3831, "addColorStop", [1.0, "rgba(0,0,0,1)"])
			J.sp(v_ox_3830, "fillStyle", v_gr_3831)
			J.mc(v_ox_3830, "fillRect", [0.0, 0.0, J.gp(v_oc_3829, "width"), J.gp(v_oc_3829, "height")])
		J.mc(_s1517["__p"]["c"], "drawImage", [v_oc_3829, v_x_3820, v_rtop_3819, v_w_3827, v_rh_3818])
		var _t4214 = J.add(v_x_3820, J.sub(v_w_3827, v_F_3822))
		v_x_3820 = _t4214
		v_i_3821 = J.num(v_i_3821) + 1.0
	_s1517["f"] = 0.0
	while true:
		if not J.cmp(_s1517["f"], _s1517["__p"]["__p"]["FL"], "<"): break
		var _t4215 = _s1517["__p"]["__p"]["fy"]
		_s1517["top"] = J.cl(_t4215, null, [J.add(_s1517["f"], 1.0)])
		var _t4216 = _s1517["__p"]["__p"]["fy"]
		_s1517["floor"] = J.add(J.cl(_t4216, null, [_s1517["f"]]), 10.0)
		var _t4217 = J.gp(_s1517["__p"]["__p"]["LV"], "xs")
		J.mc(_t4217, "forEach", [Callable(self, "_f640").bind(_s1517)])
		_s1517["f"] = J.num(_s1517["f"]) + 1.0
	_s1517["f"] = 0.0
	while true:
		if not J.cmp(_s1517["f"], _s1517["__p"]["__p"]["FL"], "<="): break
		var _t4219 = _s1517["__p"]["__p"]["fy"]
		v_yb_3832 = J.add(J.cl(_t4219, null, [_s1517["f"]]), 3.0)
		v_g_3833 = J.mc(_s1517["__p"]["c"], "createLinearGradient", [0.0, v_yb_3832, 0.0, J.add(v_yb_3832, 26.0)])
		J.mc(v_g_3833, "addColorStop", [0.0, "rgba(0,0,0,0)"])
		J.mc(v_g_3833, "addColorStop", [0.28, "rgba(0,0,0,0.5)"])
		J.mc(v_g_3833, "addColorStop", [1.0, "rgba(0,0,0,0)"])
		if J.cmp(_s1517["f"], 0.0, ">"):
			var _t4220 = _s1517["__p"]["c"]
			J.sp(_t4220, "fillStyle", v_g_3833)
			J.mc(_s1517["__p"]["c"], "fillRect", [0.0, v_yb_3832, _s1517["__p"]["__p"]["WW"], 26.0])
		_s1517["f"] = J.num(_s1517["f"]) + 1.0
	var _t4221 = [[0.0, 1.0], [_s1517["__p"]["__p"]["WW"], (-1.0)]]
	J.mc(_t4221, "forEach", [Callable(self, "_f641").bind(_s1517)])
	return true

func _f642(this_, a: Array, env):
	return (J.mc(env["__p"]["staticCv"], "toDataURL", ["image/png"]) if J.t(env["__p"]["staticCv"]) else null)

func _f643(this_, a: Array, env):
	var v_x_3903 = null; var v_y_3904 = null
	v_x_3903 = J.arg(a, 0)
	v_y_3904 = J.arg(a, 1)
	var _t4236 = env["__p"]["cam"]
	var _t4237 = (null if J.leq(v_x_3903, null) else {"x": v_x_3903, "y": v_y_3904})
	J.sp(_t4236, "free", _t4237)

func _f645(this_, a: Array, env):
	var v_q_3918 = null
	v_q_3918 = J.arg(a, 0)
	var _t4251 = J.seq(J.gp(v_q_3918, "f"), env["__p"]["f"])
	return (J.seq(J.gp(J.gp(v_q_3918, "rx"), 0.0), env["x0"]) if _t4251 else _t4251)

func _f644(this_, a: Array, env):
	var v_col_3907 = null; var v_ci_3908 = null; var v_w_3910 = null; var v_un_3911 = null; var v_r_3912 = null; var v_RM_3913 = null; var v_rk_3914 = null; var v_ri_3915 = null
	var _s1555 = {"__p": env, "x0": null}
	v_col_3907 = J.arg(a, 0)
	v_ci_3908 = J.arg(a, 1)
	_s1555["x0"] = J.gp(v_col_3907, 0.0)
	v_w_3910 = J.sub(J.gp(v_col_3907, 1.0), J.gp(v_col_3907, 0.0))
	if J.seq(J.gp(v_col_3907, 2.0), "stair"):
		var _t4242 = _s1555["__p"]["put"]
		J.cl(_t4242, null, [(J.gp(J.gp(_s1555["__p"]["B"], "src"), "gstair") if J.cmp(_s1555["__p"]["f"], 1.0, "<=") else J.gp(J.gp(_s1555["__p"]["B"], "src"), "stair")), _s1555["x0"], _s1555["__p"]["top"], v_w_3910, _s1555["__p"]["hgt"], false, _s1555["__p"]["dark"]])
	else:
		if J.seq(J.gp(v_col_3907, 2.0), "lift"):
			var _t4243 = _s1555["__p"]["put"]
			J.cl(_t4243, null, [(J.gp(J.gp(_s1555["__p"]["B"], "src"), "glift") if J.cmp(_s1555["__p"]["f"], 1.0, "<=") else J.gp(J.gp(_s1555["__p"]["B"], "src"), "lift")), _s1555["x0"], _s1555["__p"]["top"], v_w_3910, _s1555["__p"]["hgt"], false, _s1555["__p"]["dark"]])
		else:
			if J.seq(J.gp(v_col_3907, 2.0), "back"):
				var _t4244 = _s1555["__p"]["put"]
				var _t4246 = J.gp(J.gp(_s1555["__p"]["B"], "src"), "back")
				var _t4247 = _s1555["x0"]
				var _t4248 = _s1555["__p"]["top"]
				var _t4249 = _s1555["__p"]["hgt"]
				var _t4245 = (not J.t(J.gp(J.gp(J.gp(_s1555["__p"]["B"], "src"), "back"), 4.0)))
				J.cl(_t4244, null, [_t4246, _t4247, _t4248, v_w_3910, _t4249, (J.seq(J.gp(_s1555["__p"]["__p"]["LV"], "key"), "flat") if _t4245 else _t4245), _s1555["__p"]["dark"]])
			else:
				var _t4250 = J.gp(_s1555["__p"]["__p"]["G"], "units")
				v_un_3911 = J.mc(_t4250, "find", [Callable(self, "_f645").bind(_s1555)])
				v_RM_3913 = {"mahjong": "room_mahjong", "gamer": "room_gamer", "nurse": "room_nurse", "helper": "room_helper", "gym": "room_gym", "shopper": "room_shopper"}
				var _t4254 = null
				if J.t(((not J.seq(J.gp(v_un_3911, "ot"), "deity")) if J.t(v_un_3911) else v_un_3911)):
					var _t4253 = null
					if J.seq(_s1555["__p"]["f"], 0.0):
						_t4253 = "room_carpark"
					else:
						var _t4252 = J.seq(_s1555["__p"]["f"], 1.0)
						_t4253 = ("room_lobby" if (J.seq(J.gp(v_un_3911, "u"), 0.0) if _t4252 else _t4252) else J.gp(v_RM_3913, J.gp(v_un_3911, "hh")))
					_t4254 = _t4253
				else:
					_t4254 = null
				v_rk_3914 = _t4254
				v_ri_3915 = (J.gp(_s1555["__p"]["__p"]["IMG"], v_rk_3914) if J.t(v_rk_3914) else v_rk_3914)
				if J.t((J.gp(v_ri_3915, "width") if J.t(v_ri_3915) else v_ri_3915)):
					J.mc(_s1555["__p"]["c"], "save", [])
					if J.seq(J.mod(J.add(v_ci_3908, _s1555["__p"]["f"]), 2.0), 1.0):
						J.mc(_s1555["__p"]["c"], "translate", [J.add(_s1555["x0"], v_w_3910), _s1555["__p"]["top"]])
						J.mc(_s1555["__p"]["c"], "scale", [(-1.0), 1.0])
						J.mc(_s1555["__p"]["c"], "drawImage", [v_ri_3915, 0.0, 0.0, v_w_3910, _s1555["__p"]["hgt"]])
					else:
						J.mc(_s1555["__p"]["c"], "drawImage", [v_ri_3915, _s1555["x0"], _s1555["__p"]["top"], v_w_3910, _s1555["__p"]["hgt"]])
					J.mc(_s1555["__p"]["c"], "restore", [])
					if J.t(_s1555["__p"]["dark"]):
						var _t4255 = _s1555["__p"]["c"]
						J.sp(_t4255, "fillStyle", "rgba(10,20,40,0.25)")
						J.mc(_s1555["__p"]["c"], "fillRect", [_s1555["x0"], _s1555["__p"]["top"], v_w_3910, _s1555["__p"]["hgt"]])
					var _t4256 = _s1555["__p"]["c"]
					J.sp(_t4256, "strokeStyle", "rgba(0,0,0,0.6)")
					var _t4257 = _s1555["__p"]["c"]
					J.sp(_t4257, "lineWidth", 3.0)
					J.mc(_s1555["__p"]["c"], "strokeRect", [J.add(_s1555["x0"], 1.0), J.add(_s1555["__p"]["top"], 1.0), J.sub(v_w_3910, 2.0), J.sub(_s1555["__p"]["hgt"], 2.0)])
				else:
					if J.t((J.seq(J.gp(v_un_3911, "ot"), "deity") if J.t(v_un_3911) else v_un_3911)):
						v_r_3912 = J.gp(J.gp(J.gp(_s1555["__p"]["B"], "src"), "deity"), 0.0)
					else:
						if J.cmp(_s1555["__p"]["f"], 1.0, "<="):
							var _t4258 = J.gp(_s1555["__p"]["gPool"], J.mod(J.add(v_ci_3908, _s1555["__p"]["f"]), J.len(_s1555["__p"]["gPool"])))
							v_r_3912 = _t4258
						else:
							var _t4260 = _s1555["__p"]["resPool"]
							var _t4259 = J.num(_s1555["__p"]["ui"])
							_s1555["__p"]["ui"] = _t4259 + 1.0
							var _t4261 = J.gp(_t4260, J.mod(J.add((_t4259 * 5.0), _s1555["__p"]["f"]), J.len(_s1555["__p"]["resPool"])))
							v_r_3912 = _t4261
					var _t4262 = _s1555["__p"]["put"]
					J.cl(_t4262, null, [v_r_3912, _s1555["x0"], _s1555["__p"]["top"], v_w_3910, _s1555["__p"]["hgt"], J.seq(J.mod(J.add(v_ci_3908, _s1555["__p"]["f"]), 2.0), 1.0), _s1555["__p"]["dark"]])

func _f646(this_, a: Array, env):
	var v_P_3921 = null; var v_px_3922 = null; var v_y_3923 = null
	v_P_3921 = J.arg(a, 0)
	v_px_3922 = J.sub(J.gp(J.gp(J.gp(env["__p"]["LV"], "ucols"), J.gp(v_P_3921, 2.0)), 1.0), 6.0)
	var _t4276 = env["c"]
	J.sp(_t4276, "strokeStyle", "#5a6a68")
	var _t4277 = env["c"]
	J.sp(_t4277, "lineWidth", 5.0)
	J.mc(env["c"], "beginPath", [])
	var _t4278 = env["__p"]["fy"]
	J.mc(env["c"], "moveTo", [v_px_3922, J.sub(J.cl(_t4278, null, [J.gp(v_P_3921, 1.0)]), 110.0)])
	var _t4279 = env["__p"]["fy"]
	J.mc(env["c"], "lineTo", [v_px_3922, J.cl(_t4279, null, [J.gp(v_P_3921, 0.0)])])
	J.mc(env["c"], "stroke", [])
	var _t4280 = env["c"]
	J.sp(_t4280, "strokeStyle", "#8a9a96")
	var _t4281 = env["c"]
	J.sp(_t4281, "lineWidth", 1.5)
	J.mc(env["c"], "stroke", [])
	var _t4282 = env["__p"]["fy"]
	v_y_3923 = J.sub(J.cl(_t4282, null, [J.gp(v_P_3921, 1.0)]), 100.0)
	while true:
		var _t4283 = env["__p"]["fy"]
		if not J.cmp(v_y_3923, J.cl(_t4283, null, [J.gp(v_P_3921, 0.0)]), "<"): break
		var _t4284 = env["c"]
		J.sp(_t4284, "fillStyle", "#3a4442")
		J.mc(env["c"], "fillRect", [J.sub(v_px_3922, 5.0), v_y_3923, 10.0, 4.0])
		var _t4285 = J.add(v_y_3923, 40.0)
		v_y_3923 = _t4285

func _f631(this_, a: Array, env):
	var v_sky_3773 = null; var v_i_3774 = null; var v_bot_3780 = null; var v_rt_3783 = null; var v_rh_3784 = null; var v_rw_3785 = null; var v_x_3786 = null; var v_bakeTiles_3788 = null
	var _s1510 = {"__p": env, "SC": null, "B": null, "c": null, "img": null, "k": null, "resPool": null, "gPool": null, "ui": null, "f": null, "top": null, "hgt": null, "dark": null, "put": null}
	_s1510["put"] = Callable(self, "_f632").bind(_s1510)
	v_bakeTiles_3788 = Callable(self, "_f633").bind(_s1510)
	_s1510["SC"] = J.min_([1.4, sqrt(J.num(J.div(6500000.0, J.mul(_s1510["__p"]["WW"], _s1510["__p"]["WH"]))))])
	_s1510["B"] = J.gp(_s1510["__p"]["LV"], "B")
	var _t4223 = J.S_document_("createElement", ["canvas"])
	_s1510["__p"]["staticCv"] = _t4223
	var _t4224 = _s1510["__p"]["staticCv"]
	var _t4225 = J.round(J.num(J.mul(_s1510["__p"]["WW"], _s1510["SC"])))
	J.sp(_t4224, "width", _t4225)
	var _t4226 = _s1510["__p"]["staticCv"]
	var _t4227 = J.round(J.num(J.mul(_s1510["__p"]["WH"], _s1510["SC"])))
	J.sp(_t4226, "height", _t4227)
	_s1510["c"] = J.mc(_s1510["__p"]["staticCv"], "getContext", ["2d"])
	J.mc(_s1510["c"], "scale", [_s1510["SC"], _s1510["SC"]])
	_s1510["img"] = J.gp(_s1510["__p"]["IMG"], J.gp(_s1510["B"], "skin"))
	_s1510["k"] = (J.div(J.gp(_s1510["img"], "width"), 600.0) if J.t((J.gp(_s1510["img"], "width") if J.t(_s1510["img"]) else _s1510["img"])) else 1.0)
	v_sky_3773 = J.mc(_s1510["c"], "createLinearGradient", [0.0, 0.0, 0.0, _s1510["__p"]["WH"]])
	J.mc(v_sky_3773, "addColorStop", [0.0, "#0b0d16"])
	J.mc(v_sky_3773, "addColorStop", [0.5, "#141622"])
	J.mc(v_sky_3773, "addColorStop", [1.0, "#0c0c10"])
	var _t4228 = _s1510["c"]
	J.sp(_t4228, "fillStyle", v_sky_3773)
	J.mc(_s1510["c"], "fillRect", [0.0, 0.0, _s1510["__p"]["WW"], _s1510["__p"]["WH"]])
	v_i_3774 = 0.0
	while true:
		if not J.cmp(v_i_3774, 60.0, "<"): break
		var _t4229 = _s1510["c"]
		var _t4230 = (J.add("rgba(230,230,255,", (0.2 + J.div(J.mod(J.mul(v_i_3774, 37.0), 10.0), 20.0))) + ")")
		J.sp(_t4229, "fillStyle", _t4230)
		var _t4234 = J.mod(J.mul(v_i_3774, 197.0), _s1510["__p"]["WW"])
		var _t4233 = J.mul(v_i_3774, 61.0)
		var _t4231 = _s1510["__p"]["fy"]
		var _t4232 = _s1510["__p"]["fy"]
		J.mc(_s1510["c"], "fillRect", [_t4234, J.mod(_t4233, J.max_([40.0, J.sub(J.cl(_t4232, null, [_s1510["__p"]["FL"]]), 60.0)])), 1.5, 1.5])
		v_i_3774 = J.num(v_i_3774) + 1.0
	var _t4235 = J.G.get("window")
	var _t4238 = {"bakeURL": Callable(self, "_f642").bind(_s1510), "camTo": Callable(self, "_f643").bind(_s1510)}
	J.sp(_t4235, "TW8", _t4238)
	if (not J.t(J.cl(v_bakeTiles_3788, null, []))):
		_s1510["resPool"] = J.gp(J.gp(_s1510["B"], "src"), "res")
		_s1510["gPool"] = J.gp(J.gp(_s1510["B"], "src"), "ground")
		_s1510["ui"] = 0.0
		_s1510["f"] = 0.0
		while true:
			if not J.cmp(_s1510["f"], _s1510["__p"]["FL"], "<"): break
			var _t4239 = _s1510["__p"]["fy"]
			_s1510["top"] = J.cl(_t4239, null, [J.add(_s1510["f"], 1.0)])
			var _t4240 = _s1510["__p"]["fy"]
			v_bot_3780 = J.add(J.cl(_t4240, null, [_s1510["f"]]), 12.0)
			_s1510["hgt"] = J.sub(v_bot_3780, _s1510["top"])
			_s1510["dark"] = ("rgba(10,20,40,0.45)" if J.seq(_s1510["f"], 0.0) else null)
			var _t4241 = J.gp(_s1510["__p"]["LV"], "xs")
			J.mc(_t4241, "forEach", [Callable(self, "_f644").bind(_s1510)])
			var _t4263 = _s1510["c"]
			J.sp(_t4263, "fillStyle", "rgba(0,0,0,0.55)")
			J.mc(_s1510["c"], "fillRect", [0.0, J.sub(v_bot_3780, 4.0), _s1510["__p"]["WW"], 6.0])
			_s1510["f"] = J.num(_s1510["f"]) + 1.0
		v_rt_3783 = J.gp(J.gp(_s1510["B"], "src"), "roof")
		v_rh_3784 = J.sub(J.gp(v_rt_3783, 3.0), J.gp(v_rt_3783, 2.0))
		v_rw_3785 = J.sub(J.gp(v_rt_3783, 1.0), J.gp(v_rt_3783, 0.0))
		v_x_3786 = 0.0
		while true:
			if not J.cmp(v_x_3786, _s1510["__p"]["WW"], "<"): break
			var _t4264 = _s1510["put"]
			var _t4265 = _s1510["__p"]["fy"]
			J.cl(_t4264, null, [v_rt_3783, v_x_3786, J.sub(J.cl(_t4265, null, [_s1510["__p"]["FL"]]), v_rh_3784), v_rw_3785, J.add(v_rh_3784, 8.0), J.seq(J.mod(J.div(v_x_3786, v_rw_3785), 2.0), 1.0)])
			var _t4266 = J.add(v_x_3786, v_rw_3785)
			v_x_3786 = _t4266
		var _t4267 = _s1510["c"]
		J.sp(_t4267, "strokeStyle", "rgba(120,140,150,0.5)")
		var _t4268 = _s1510["c"]
		J.sp(_t4268, "lineWidth", 4.0)
		J.mc(_s1510["c"], "beginPath", [])
		var _t4269 = _s1510["__p"]["fy"]
		J.mc(_s1510["c"], "moveTo", [0.0, J.add(J.cl(_t4269, null, [1.0]), 30.0)])
		var _t4271 = _s1510["__p"]["WW"]
		var _t4270 = _s1510["__p"]["fy"]
		J.mc(_s1510["c"], "lineTo", [_t4271, J.add(J.cl(_t4270, null, [1.0]), 30.0)])
		J.mc(_s1510["c"], "stroke", [])
		var _t4272 = _s1510["c"]
		J.sp(_t4272, "fillStyle", "rgba(220,220,160,0.25)")
		v_x_3786 = 120.0
		while true:
			if not J.cmp(v_x_3786, J.sub(_s1510["__p"]["WW"], 100.0), "<"): break
			var _t4273 = _s1510["__p"]["fy"]
			J.mc(_s1510["c"], "fillRect", [v_x_3786, J.sub(J.cl(_t4273, null, [0.0]), 4.0), 60.0, 3.0])
			var _t4274 = J.add(v_x_3786, 110.0)
			v_x_3786 = _t4274
	var _t4275 = J.gp(_s1510["__p"]["LV"], "pipes")
	J.mc(_t4275, "forEach", [Callable(self, "_f646").bind(_s1510)])
	var _t4286 = _s1510["c"]
	var _t4287 = J.add("bold 13px ", _s1510["__p"]["FONT"])
	J.sp(_t4286, "font", _t4287)
	var _t4288 = _s1510["c"]
	J.sp(_t4288, "textAlign", "left")
	_s1510["f"] = 0.0
	while true:
		if not J.cmp(_s1510["f"], _s1510["__p"]["FL"], "<="): break
		var _t4289 = _s1510["c"]
		J.sp(_t4289, "lineWidth", 3.0)
		var _t4290 = _s1510["c"]
		J.sp(_t4290, "strokeStyle", "#000")
		var _t4292 = J.gp(_s1510["__p"]["FLN"], _s1510["f"])
		var _t4291 = _s1510["__p"]["fy"]
		J.mc(_s1510["c"], "strokeText", [_t4292, 6.0, ((J.sub(J.cl(_t4291, null, [_s1510["f"]]), J.gp(J.gp(_s1510["__p"]["LV"], "B"), "FH")) + 44.0) + (60.0 if J.seq(_s1510["f"], _s1510["__p"]["FL"]) else 0.0))])
		var _t4293 = _s1510["c"]
		J.sp(_t4293, "fillStyle", "#e8d8b0")
		var _t4295 = J.gp(_s1510["__p"]["FLN"], _s1510["f"])
		var _t4294 = _s1510["__p"]["fy"]
		J.mc(_s1510["c"], "fillText", [_t4295, 6.0, ((J.sub(J.cl(_t4294, null, [_s1510["f"]]), J.gp(J.gp(_s1510["__p"]["LV"], "B"), "FH")) + 44.0) + (60.0 if J.seq(_s1510["f"], _s1510["__p"]["FL"]) else 0.0))])
		_s1510["f"] = J.num(_s1510["f"]) + 1.0

func _f648(this_, a: Array, env):
	var v_r_3931 = null; var v_hh_3932 = null; var v_want_3933 = null; var v_tx_3934 = null
	v_r_3931 = J.arg(a, 0)
	v_hh_3932 = J.gp(env["__p"]["HH"], J.gp(v_r_3931, "hh"))
	if (not J.t(v_hh_3932)):
		return null
	if J.seq(J.gp(v_r_3931, "state"), "home"):
		v_want_3933 = J.seq(J.gp(J.gp(v_hh_3932, "awake"), env["ph"]), 1.0)
		if J.t(((not J.t(J.gp(v_r_3931, "awake"))) if J.t(v_want_3933) else v_want_3933)):
			J.sp(v_r_3931, "awake", true)
			var _t4297 = env["__p"]["say"]
			var _t4298 = env["__p"]["pick"]
			J.cl(_t4297, null, [v_r_3931, J.cl(_t4298, null, [["又醒咗……", "咩鐘數呀而家？"]])])
		var _t4299 = (not J.t(v_want_3933))
		var _t4300 = (J.gp(v_r_3931, "awake") if _t4299 else _t4299)
		var _t4301 = ((not J.t(J.gp(v_r_3931, "woke"))) if J.t(_t4300) else _t4300)
		var _t4302 = (J.cmp(J.gp(v_r_3931, "fear"), 20.0, "<") if J.t(_t4301) else _t4301)
		if J.t((J.cmp(J.cl(env["__p"]["rnd"], null, []), J.mul(env["dt"], 0.05), "<") if J.t(_t4302) else _t4302)):
			J.sp(v_r_3931, "awake", false)
		var _t4303 = J.sub(J.gp(v_r_3931, "idleT"), env["dt"])
		J.sp(v_r_3931, "idleT", _t4303)
		if J.cmp(J.gp(v_r_3931, "idleT"), 0.0, "<="):
			var _t4304 = (10.0 + J.mul(J.cl(env["__p"]["rnd"], null, []), 14.0))
			J.sp(v_r_3931, "idleT", _t4304)
			var _t4305 = J.gp(v_r_3931, "awake")
			if J.t(((not J.t(J.gp(v_r_3931, "say"))) if J.t(_t4305) else _t4305)):
				var _t4306 = env["__p"]["say"]
				var _t4307 = env["__p"]["pick"]
				J.cl(_t4306, null, [v_r_3931, J.cl(_t4307, null, [J.gp(v_hh_3932, "idle")])])
		var _t4308 = J.gp(v_hh_3932, "leave")
		var _t4309 = ((not J.t(J.gp(v_r_3931, "left"))) if J.t(_t4308) else _t4308)
		if J.t((J.cmp(env["tt"], J.gp(v_hh_3932, "leave"), ">=") if J.t(_t4309) else _t4309)):
			J.sp(v_r_3931, "left", true)
			J.sp(v_r_3931, "state", "leave")
			J.sp(v_r_3931, "awake", true)
			var _t4310 = env["__p"]["say"]
			J.cl(_t4310, null, [v_r_3931, ("返工喇，出門口先" if J.seq(J.gp(v_r_3931, "hh"), "nurse") else "去晨運先")])
			var _t4311 = J.gp(v_r_3931, "unit")
			J.sp(_t4311, "doorOpen", 4.0)
			var _t4312 = (-70.0)
			J.sp(v_r_3931, "vx", _t4312)
	var _t4313 = J.seq(J.gp(v_r_3931, "state"), "away")
	var _t4314 = (J.gp(v_hh_3932, "away") if _t4313 else _t4313)
	if J.t((J.cmp(env["tt"], J.gp(v_hh_3932, "away"), ">=") if J.t(_t4314) else _t4314)):
		J.sp(v_r_3931, "state", "back")
		var _t4315 = env["__p"]["SX"]
		J.sp(v_r_3931, "x", _t4315)
		var _t4316 = env["__p"]["fy"]
		var _t4317 = J.sub(J.cl(_t4316, null, [J.gp(J.gp(v_r_3931, "unit"), "f")]), 16.0)
		J.sp(v_r_3931, "y", _t4317)
		J.sp(v_r_3931, "vx", 70.0)
		J.sp(v_r_3931, "awake", true)
		var _t4318 = env["__p"]["say"]
		J.cl(_t4318, null, [v_r_3931, "收工返屋企喇……"])
	if J.seq(J.gp(v_r_3931, "state"), "leave"):
		var _t4319 = J.add(J.gp(v_r_3931, "x"), J.mul(J.gp(v_r_3931, "vx"), env["dt"]))
		J.sp(v_r_3931, "x", _t4319)
		if J.cmp(J.gp(v_r_3931, "x"), env["__p"]["SX"], "<="):
			J.sp(v_r_3931, "state", "gone")
	if J.seq(J.gp(v_r_3931, "state"), "back"):
		v_tx_3934 = J.add(J.gp(J.gp(J.gp(v_r_3931, "unit"), "rx"), 0.0), 30.0)
		var _t4320 = J.add(J.gp(v_r_3931, "x"), J.mul((signf(J.num(J.sub(v_tx_3934, J.gp(v_r_3931, "x")))) * 70.0), env["dt"]))
		J.sp(v_r_3931, "x", _t4320)
		if (absf(J.num(J.sub(v_tx_3934, J.gp(v_r_3931, "x")))) < 4.0):
			J.sp(v_r_3931, "state", "home")
			var _t4321 = J.gp(v_r_3931, "unit")
			J.sp(_t4321, "doorOpen", 3.0)

func _f650(this_, a: Array, env):
	var v_r_3940 = null
	v_r_3940 = J.arg(a, 0)
	return J.seq(J.gp(v_r_3940, "state"), "home")

func _f651(this_, a: Array, env):
	var v_p_3943 = null
	v_p_3943 = J.arg(a, 0)
	var _t4328 = J.max_([0.0, J.sub(J.gp(v_p_3943, "t"), env["dt"])])
	J.sp(v_p_3943, "t", _t4328)
	var _t4329 = J.max_([0.0, J.sub(J.gp(v_p_3943, "cd"), env["dt"])])
	J.sp(v_p_3943, "cd", _t4329)

func _f649(this_, a: Array, env):
	var v_u_3937 = null
	v_u_3937 = J.arg(a, 0)
	if (not J.t(J.gp(v_u_3937, "rs"))):
		return null
	var _t4323 = J.gp(v_u_3937, "rs")
	var _t4324 = J.mc(_t4323, "find", [Callable(self, "_f650").bind(env)])
	var _t4325 = (_t4324 if J.t(_t4324) else J.gp(J.gp(v_u_3937, "rs"), 0.0))
	var _t4326 = (_t4325 if J.t(_t4325) else null)
	J.sp(v_u_3937, "res", _t4326)
	var _t4327 = J.gp(v_u_3937, "props")
	J.mc(_t4327, "forEach", [Callable(self, "_f651").bind(env)])

func _f652(this_, a: Array, env):
	var v_p_3946 = null
	v_p_3946 = J.arg(a, 0)
	var _t4332 = J.max_([0.0, J.sub(J.gp(v_p_3946, "t"), env["dt"])])
	J.sp(v_p_3946, "t", _t4332)
	var _t4333 = J.max_([0.0, J.sub(J.gp(v_p_3946, "cd"), env["dt"])])
	J.sp(v_p_3946, "cd", _t4333)

func _f653(this_, a: Array, env):
	var v_e_3949 = null
	v_e_3949 = J.arg(a, 0)
	if J.t(J.gp(v_e_3949, "fire")):
		var _t4335 = J.gp(v_e_3949, "fire")
		var _t4336 = J.max_([0.0, J.sub(J.gp(J.gp(v_e_3949, "fire"), "shut"), env["dt"])])
		J.sp(_t4335, "shut", _t4336)
		var _t4337 = J.gp(v_e_3949, "fire")
		var _t4338 = J.max_([0.0, J.sub(J.gp(J.gp(v_e_3949, "fire"), "cd"), env["dt"])])
		J.sp(_t4337, "cd", _t4338)

func _f647(this_, a: Array, env):
	var _s1570 = {"__p": env, "dt": null, "ph": null, "tt": null}
	_s1570["dt"] = J.arg(a, 0)
	_s1570["ph"] = J.min_([2.0, J.gp(_s1570["__p"]["G"], "phase")])
	_s1570["tt"] = J.div(J.gp(_s1570["__p"]["G"], "t"), _s1570["__p"]["PHT"])
	var _t4296 = J.gp(_s1570["__p"]["G"], "res")
	J.mc(_t4296, "forEach", [Callable(self, "_f648").bind(_s1570)])
	var _t4322 = J.gp(_s1570["__p"]["G"], "units")
	J.mc(_t4322, "forEach", [Callable(self, "_f649").bind(_s1570)])
	var _t4330 = J.gp(_s1570["__p"]["G"], "cprops")
	var _t4331 = (_t4330 if J.t(_t4330) else [])
	J.mc(_t4331, "forEach", [Callable(self, "_f652").bind(_s1570)])
	var _t4334 = J.gp(_s1570["__p"]["G"], "edges")
	J.mc(_t4334, "forEach", [Callable(self, "_f653").bind(_s1570)])
	var _t4339 = _s1570["__p"]["G"]
	var _t4340 = J.gp(_s1570["__p"]["G"], "lureCd")
	var _t4341 = J.gp(_s1570["__p"]["G"], "lureCd")
	var _t4342 = J.max_([0.0, J.sub((_t4341 if J.t(_t4341) else 0.0), _s1570["dt"])])
	J.sp(_t4339, "lureCd", _t4342)
	var _t4343 = _s1570["__p"]["questUpdate"]
	J.cl(_t4343, null, [_s1570["dt"]])
	var _t4344 = _s1570["__p"]["reliefUpdate"]
	J.cl(_t4344, null, [_s1570["dt"]])

func _f656(this_, a: Array, env):
	var v_r_3962 = null
	v_r_3962 = J.arg(a, 0)
	if (not J.seq(J.gp(v_r_3962, "state"), "home")):
		return null
	J.sp(v_r_3962, "awake", true)
	J.sp(v_r_3962, "woke", true)
	var _t4353 = J.add(J.gp(v_r_3962, "fear"), env["amt"])
	J.sp(v_r_3962, "fear", _t4353)
	J.sp(v_r_3962, "jumpT", 0.4)
	env["hit"] = J.num(env["hit"]) + 1.0
	if J.cmp(J.cl(env["__p"]["rnd"], null, []), 0.5, "<"):
		var _t4354 = env["__p"]["say"]
		var _t4355 = env["__p"]["pick"]
		J.cl(_t4354, null, [v_r_3962, J.cl(_t4355, null, [["隔籬做咩嗌成咁？", "樓上咩聲呀？！", "咩事咩事？！"]])])
	var _t4356 = J.cmp(J.gp(v_r_3962, "fear"), 100.0, ">=")
	if ((not J.cmp(J.gp(v_r_3962, "fleeAfter"), 0.0, ">")) if _t4356 else _t4356):
		J.sp(v_r_3962, "fleeAfter", 1.2)
		var _t4357 = J.add((env["depth"] if J.t(env["depth"]) else 0.0), 1.0)
		J.sp(v_r_3962, "chainD", _t4357)

func _f655(this_, a: Array, env):
	var v_v_3958 = null; var v_adj_3959 = null
	v_v_3958 = J.arg(a, 0)
	var _t4346 = J.seq(v_v_3958, env["un"])
	var _t4347 = (_t4346 if _t4346 else (not J.t(J.len(J.gp(v_v_3958, "rs")))))
	if (_t4347 if _t4347 else J.seq(J.gp(v_v_3958, "ot"), "deity")):
		return null
	var _t4348 = J.seq(J.gp(v_v_3958, "f"), J.gp(env["un"], "f"))
	var _t4351 = (J.seq(absf(J.num(J.sub(J.gp(v_v_3958, "u"), J.gp(env["un"], "u")))), 1.0) if _t4348 else _t4348)
	if not J.t(_t4351):
		var _t4349 = J.seq(absf(J.num(J.sub(J.gp(v_v_3958, "f"), J.gp(env["un"], "f")))), 1.0)
		var _t4350 = (J.cmp(J.gp(J.gp(v_v_3958, "rx"), 0.0), J.gp(J.gp(env["un"], "rx"), 1.0), "<") if _t4349 else _t4349)
		_t4351 = (J.cmp(J.gp(J.gp(v_v_3958, "rx"), 1.0), J.gp(J.gp(env["un"], "rx"), 0.0), ">") if _t4350 else _t4350)
	v_adj_3959 = _t4351
	if (not J.t(v_adj_3959)):
		return null
	var _t4352 = J.gp(v_v_3958, "rs")
	J.mc(_t4352, "forEach", [Callable(self, "_f656").bind(env)])

func _f654(this_, a: Array, env):
	var _s1588 = {"__p": env, "un": null, "amt": null, "depth": null, "hit": null}
	_s1588["un"] = J.arg(a, 0)
	_s1588["amt"] = J.arg(a, 1)
	_s1588["depth"] = J.arg(a, 2)
	if J.cmp((_s1588["depth"] if J.t(_s1588["depth"]) else 0.0), 1.0, ">"):
		return null
	_s1588["hit"] = 0.0
	var _t4345 = J.gp(_s1588["__p"]["G"], "units")
	J.mc(_t4345, "forEach", [Callable(self, "_f655").bind(_s1588)])
	if J.t(_s1588["hit"]):
		var _t4358 = _s1588["__p"]["float"]
		J.cl(_t4358, null, [J.gp(_s1588["un"], "x"), J.sub(J.gp(_s1588["un"], "y"), 120.0), (J.add("連鎖！隔籬 ", _s1588["hit"]) + " 個醒晒"), "#ffb7a0"])
		var _t4359 = _s1588["__p"]["addFear"]
		J.cl(_t4359, null, [J.min_([12.0, J.mul(_s1588["hit"], 2.0)]), J.gp(_s1588["un"], "x"), J.sub(J.gp(_s1588["un"], "y"), 140.0)])

func _f659(this_, a: Array, env):
	var v_id_3977 = null; var v_b_3978 = null
	v_id_3977 = J.arg(a, 0)
	v_b_3978 = J.gp(J.gp(env["__p"]["__p"]["G"], "nodes"), v_id_3977)
	var _t4371 = J.add(env["d"], (absf(J.num(J.sub(J.gp(env["a"], "x"), J.gp(v_b_3978, "x")))) + absf(J.num(J.sub(J.gp(env["a"], "y"), J.gp(v_b_3978, "y"))))))
	env["d"] = _t4371
	env["a"] = v_b_3978

func _f658(this_, a: Array, env):
	var v_h_3971 = null; var v_p_3972 = null
	var _s1594 = {"__p": env, "d": null, "a": null}
	v_h_3971 = J.arg(a, 0)
	var _t4365 = (not J.seq(J.gp(v_h_3971, "kind"), "guard"))
	var _t4366 = (_t4365 if _t4365 else J.seq(J.gp(v_h_3971, "state"), "chase"))
	var _t4367 = (_t4366 if _t4366 else J.seq(J.gp(v_h_3971, "state"), "scared"))
	var _t4368 = (_t4367 if _t4367 else J.seq(J.gp(v_h_3971, "state"), "shift"))
	var _t4369 = (_t4368 if _t4368 else J.seq(J.gp(v_h_3971, "state"), "flee"))
	if (_t4369 if _t4369 else J.seq(J.gp(v_h_3971, "state"), "gone")):
		return null
	var _t4370 = _s1594["__p"]["__p"]["dijkstra"]
	v_p_3972 = J.cl(_t4370, null, [v_h_3971, J.gp(v_h_3971, "node"), _s1594["__p"]["nodeId"]])
	if (not J.t(v_p_3972)):
		return null
	_s1594["d"] = 0.0
	_s1594["a"] = J.gp(J.gp(_s1594["__p"]["__p"]["G"], "nodes"), J.gp(v_h_3971, "node"))
	J.mc(v_p_3972, "forEach", [Callable(self, "_f659").bind(_s1594)])
	var _t4373 = J.cmp(_s1594["d"], J.mul(700.0, _s1594["__p"]["lvl"]), ">")
	if not J.t(_t4373):
		var _t4372 = _s1594["__p"]["__p"]["inZone"]
		_t4373 = (not J.t(J.cl(_t4372, null, [v_h_3971, J.gp(_s1594["__p"]["n"], "f"), 1.0])))
	if _t4373:
		return null
	var _t4374 = J.seq(J.gp(v_h_3971, "state"), "puzzle")
	if (J.seq(J.gp(v_h_3971, "invNode"), _s1594["__p"]["nodeId"]) if _t4374 else _t4374):
		var _t4375 = _s1594["__p"]["__p"]["spook"]
		J.cl(_t4375, null, [v_h_3971, "同一個位又有怪聲！"])
		return null
	J.sp(v_h_3971, "state", "inv")
	var _t4376 = _s1594["__p"]["nodeId"]
	J.sp(v_h_3971, "invNode", _t4376)
	J.sp(v_h_3971, "path", v_p_3972)
	J.sp(v_h_3971, "to", null)
	J.sp(v_h_3971, "wait", 0.0)
	J.sp(v_h_3971, "alertT", 0.8)
	var _t4377 = _s1594["__p"]["__p"]["pick"]
	var _t4378 = J.cl(_t4377, null, [["咩聲嚟㗎？過去睇睇", "邊度傳嚟嘅？", (J.add("又係", J.gp(_s1594["__p"]["__p"]["FLN"], J.gp(_s1594["__p"]["n"], "f"))) + "？")]])
	J.sp(v_h_3971, "say", _t4378)
	J.sp(v_h_3971, "sayT", 2.2)

func _f657(this_, a: Array, env):
	var v_why_3967 = null
	var _s1593 = {"__p": env, "nodeId": null, "lvl": null, "n": null}
	_s1593["nodeId"] = J.arg(a, 0)
	_s1593["lvl"] = J.arg(a, 1)
	v_why_3967 = J.arg(a, 2)
	_s1593["n"] = J.gp(J.gp(_s1593["__p"]["G"], "nodes"), _s1593["nodeId"])
	if (not J.t(_s1593["n"])):
		return null
	var _t4360 = _s1593["__p"]["G"]
	var _t4361 = J.gp(_s1593["__p"]["G"], "noiseFx")
	var _t4362 = (_t4361 if J.t(_t4361) else [])
	J.sp(_t4360, "noiseFx", _t4362)
	var _t4363 = J.gp(_s1593["__p"]["G"], "noiseFx")
	J.mc(_t4363, "push", [{"x": J.gp(_s1593["n"], "x"), "y": J.sub(J.gp(_s1593["n"], "y"), 40.0), "t": 1.2, "lvl": _s1593["lvl"]}])
	var _t4364 = J.gp(_s1593["__p"]["G"], "guards")
	J.mc(_t4364, "forEach", [Callable(self, "_f658").bind(_s1593)])

func _f661(this_, a: Array, env):
	var v_g_3987 = null; var v_d_3988 = null
	v_g_3987 = J.arg(a, 0)
	var _t4387 = J.gp(v_g_3987, "home")
	if J.t((_t4387 if J.t(_t4387) else J.gp(v_g_3987, "out"))):
		return null
	v_d_3988 = (absf(J.num(J.sub(J.gp(v_g_3987, "x"), J.gp(env["h"], "x")))) + (absf(J.num(J.sub(J.gp(v_g_3987, "y"), J.gp(env["h"], "y")))) * 3.0))
	if J.cmp(v_d_3988, env["dS"], "<"):
		env["dS"] = v_d_3988
		env["gS"] = v_g_3987

func _f660(this_, a: Array, env):
	var v_txt0_3982 = null
	var _s1597 = {"__p": env, "h": null, "gS": null, "dS": null}
	_s1597["h"] = J.arg(a, 0)
	v_txt0_3982 = J.arg(a, 1)
	var _t4379 = J.seq(J.gp(_s1597["h"], "state"), "shift")
	if (_t4379 if _t4379 else J.seq(J.gp(_s1597["h"], "state"), "gone")):
		return null
	var _t4380 = _s1597["h"]
	var _t4381 = J.sub((3.0 if J.leq(J.gp(_s1597["h"], "nerve"), null) else J.gp(_s1597["h"], "nerve")), 1.0)
	J.sp(_t4380, "nerve", _t4381)
	var _t4382 = _s1597["h"]
	J.sp(_t4382, "state", "scared")
	var _t4383 = _s1597["h"]
	J.sp(_t4383, "scT", 2.6)
	var _t4384 = _s1597["h"]
	J.sp(_t4384, "to", null)
	var _t4385 = _s1597["h"]
	J.sp(_t4385, "path", null)
	_s1597["gS"] = null
	_s1597["dS"] = 1000000000.0
	var _t4386 = J.gp(_s1597["__p"]["G"], "gh")
	J.mc(_t4386, "forEach", [Callable(self, "_f661").bind(_s1597)])
	var _t4388 = _s1597["h"]
	var _t4389 = ((1.0 if J.cmp(J.gp(_s1597["h"], "x"), J.gp(_s1597["gS"], "x"), ">=") else (-1.0)) if J.t((J.cmp(_s1597["dS"], 400.0, "<") if J.t(_s1597["gS"]) else _s1597["gS"])) else ((-1.0) if J.cmp(J.cl(_s1597["__p"]["rnd"], null, []), 0.5, "<") else 1.0))
	J.sp(_t4388, "scAway", _t4389)
	var _t4390 = _s1597["h"]
	var _t4391 = J.mul(J.gp(_s1597["h"], "scAway"), 55.0)
	J.sp(_t4390, "vx", _t4391)
	var _t4392 = _s1597["h"]
	var _t4393 = (-J.num(J.gp(_s1597["h"], "scAway")))
	J.sp(_t4392, "dir", _t4393)
	var _t4394 = _s1597["h"]
	J.sp(_t4394, "shockT", 0.9)
	var _t4395 = _s1597["h"]
	var _t4396 = _s1597["__p"]["uniq"]
	var _t4398 = J.cl(_t4396, null, [[v_txt0_3982]])
	if not J.t(_t4398):
		var _t4397 = _s1597["__p"]["uniq"]
		_t4398 = J.cl(_t4397, null, [_s1597["__p"]["SPOOKL"]])
	J.sp(_t4395, "say", _t4398)
	var _t4399 = _s1597["h"]
	J.sp(_t4399, "sayT", 2.0)
	var _t4400 = _s1597["h"]
	J.sp(_t4400, "alertT", 0.6)
	var _t4401 = _s1597["__p"]["addFear"]
	J.cl(_t4401, null, [6.0, J.gp(_s1597["h"], "x"), J.sub(J.gp(_s1597["h"], "y"), 90.0)])
	var _t4402 = _s1597["__p"]["float"]
	J.cl(_t4402, null, [J.gp(_s1597["h"], "x"), J.sub(J.gp(_s1597["h"], "y"), 110.0), "保安嚇親！", "#ffd54a"])
	if J.cmp(J.cl(_s1597["__p"]["rnd"], null, []), 0.3, "<"):
		var _t4403 = _s1597["__p"]["G"]
		var _t4404 = J.add(J.gp(_t4403, "alert"), 1.0)
		J.sp(_t4403, "alert", _t4404)
		J.cl(_s1597["__p"]["checkAlert"], null, [])
		var _t4405 = _s1597["__p"]["float"]
		J.cl(_t4405, null, [J.gp(_s1597["h"], "x"), J.sub(J.gp(_s1597["h"], "y"), 130.0), (J.add("對講機：「管理處！", J.gp(_s1597["__p"]["FLN"], J.gp(J.gp(J.gp(_s1597["__p"]["G"], "nodes"), J.gp(_s1597["h"], "node")), "f"))) + "有怪事！」警覺 +1"), "#ffb0b0"])
	if J.cmp(J.gp(_s1597["h"], "nerve"), 0.0, "<="):
		var _t4406 = _s1597["h"]
		J.sp(_t4406, "state", "shift")
		var _t4407 = _s1597["h"]
		J.sp(_t4407, "say", "唔做喇！交更！")
		var _t4408 = _s1597["h"]
		J.sp(_t4408, "sayT", 2.5)
		var _t4409 = _s1597["__p"]["float"]
		J.cl(_t4409, null, [J.gp(_s1597["h"], "x"), J.sub(J.gp(_s1597["h"], "y"), 130.0), "保安頂唔順，落樓交更", "#9fd6bf"])
		var _t4410 = J.gp(_s1597["__p"]["G"], "relief")
		J.mc(_t4410, "push", [{"t": 26.0, "zone": J.gp(_s1597["h"], "zone")}])
		var _t4411 = _s1597["h"]
		var _t4412 = _s1597["__p"]["dijkstra"]
		var _t4413 = J.cl(_t4412, null, [_s1597["h"], J.gp(_s1597["h"], "node"), "f1_s"])
		J.sp(_t4411, "path", _t4413)

func _f663(this_, a: Array, env):
	var v_r_3994 = null; var v_zn_3995 = null; var v_h_3996 = null
	v_r_3994 = J.arg(a, 0)
	var _t4416 = J.sub(J.gp(v_r_3994, "t"), env["dt"])
	J.sp(v_r_3994, "t", _t4416)
	var _t4417 = J.cmp(J.gp(v_r_3994, "t"), 0.0, "<=")
	if ((not J.t(J.gp(v_r_3994, "done"))) if _t4417 else _t4417):
		J.sp(v_r_3994, "done", true)
		var _t4418 = J.gp(v_r_3994, "zone")
		v_zn_3995 = (_t4418 if J.t(_t4418) else [1.0, 3.0])
		var _t4419 = env["__p"]["mkHuman"]
		v_h_3996 = J.cl(_t4419, null, ["guard", (J.add("f", J.gp(v_zn_3995, 0.0)) + "_s")])
		J.sp(v_h_3996, "zone", v_zn_3995)
		J.sp(v_h_3996, "nerve", 3.0)
		var _t4420 = J.gp(env["__p"]["G"], "guards")
		J.mc(_t4420, "push", [v_h_3996])
		var _t4421 = env["__p"]["float"]
		J.cl(_t4421, null, [J.gp(v_h_3996, "x"), J.sub(J.gp(v_h_3996, "y"), 80.0), "新一更保安上班", "#ffb0b0"])

func _f664(this_, a: Array, env):
	var v_r_3999 = null
	v_r_3999 = J.arg(a, 0)
	return (not J.t(J.gp(v_r_3999, "done")))

func _f662(this_, a: Array, env):
	var _s1602 = {"__p": env, "dt": null}
	_s1602["dt"] = J.arg(a, 0)
	var _t4414 = J.gp(_s1602["__p"]["G"], "relief")
	var _t4415 = (_t4414 if J.t(_t4414) else [])
	J.mc(_t4415, "forEach", [Callable(self, "_f663").bind(_s1602)])
	var _t4422 = _s1602["__p"]["G"]
	var _t4423 = J.gp(_s1602["__p"]["G"], "relief")
	var _t4424 = (_t4423 if J.t(_t4423) else [])
	var _t4425 = J.mc(_t4424, "filter", [Callable(self, "_f664").bind(_s1602)])
	J.sp(_t4422, "relief", _t4425)

func _f665(this_, a: Array, env):
	var _t4426 = env["G"]
	var _t4427 = J.gp(env["G"], "alertAcc")
	var _t4428 = J.add((_t4427 if J.t(_t4427) else 0.0), 0.34)
	J.sp(_t4426, "alertAcc", _t4428)
	if J.cmp(J.gp(env["G"], "alertAcc"), 1.0, ">="):
		var _t4429 = env["G"]
		var _t4430 = J.sub(J.gp(_t4429, "alertAcc"), 1.0)
		J.sp(_t4429, "alertAcc", _t4430)
		var _t4431 = env["G"]
		var _t4432 = J.add(J.gp(_t4431, "alert"), 1.0)
		J.sp(_t4431, "alert", _t4432)
		J.cl(env["checkAlert"], null, [])

func _f667(this_, a: Array, env):
	var v_q_4016 = null
	v_q_4016 = J.arg(a, 0)
	var _t4439 = J.seq(J.gp(v_q_4016, "id"), "lost")
	var _t4440 = (J.seq(J.gp(v_q_4016, "state"), 1.0) if _t4439 else _t4439)
	return (J.seq(J.gp(v_q_4016, "owner"), env["un"]) if _t4440 else _t4440)

func _f668(this_, a: Array, env):
	var v_p_4019 = null
	v_p_4019 = J.arg(a, 0)
	var _t4442 = J.gp(J.gp(env["__p"]["PROP"], J.gp(v_p_4019, "k")), "v")
	return (J.cmp(J.gp(v_p_4019, "cd"), 0.0, "<=") if J.t(_t4442) else _t4442)

func _f669(this_, a: Array, env):
	var v_p_4022 = null
	v_p_4022 = J.arg(a, 0)
	return J.seq(J.gp(v_p_4022, "k"), "ancestor")

func _f670(this_, a: Array, env):
	var v_p_4025 = null
	v_p_4025 = J.arg(a, 0)
	var _t4446 = J.seq(J.gp(v_p_4025, "node"), J.gp(env["n"], "id"))
	return (J.cmp(J.gp(v_p_4025, "cd"), 0.0, "<=") if _t4446 else _t4446)

func _f671(this_, a: Array, env):
	var v_l_4028 = null
	v_l_4028 = J.arg(a, 0)
	return J.gp(v_l_4028, "e")

func _f672(this_, a: Array, env):
	var v_e_4031 = null
	v_e_4031 = J.arg(a, 0)
	return J.gp(v_e_4031, "fire")

func _f666(this_, a: Array, env):
	var v_g_4004 = null; var v_q_4007 = null; var v_p_4008 = null; var v_anc_4009 = null; var v_cp_4010 = null; var v_ua_4011 = null; var v_la_4012 = null; var v_fe_4013 = null
	var _s1608 = {"__p": env, "n": null, "un": null}
	v_g_4004 = J.arg(a, 0)
	var _t4433 = (not J.t(v_g_4004))
	var _t4434 = (_t4433 if _t4433 else J.gp(v_g_4004, "to"))
	var _t4435 = (_t4434 if J.t(_t4434) else J.gp(v_g_4004, "home"))
	if J.t((_t4435 if J.t(_t4435) else J.gp(v_g_4004, "out"))):
		return null
	_s1608["n"] = J.gp(J.gp(_s1608["__p"]["G"], "nodes"), J.gp(v_g_4004, "node"))
	if J.seq(J.gp(_s1608["n"], "kind"), "in"):
		var _t4436 = _s1608["__p"]["unitOf"]
		_s1608["un"] = J.cl(_t4436, null, [J.gp(_s1608["n"], "id")])
		var _t4437 = J.gp(_s1608["__p"]["G"], "quests")
		var _t4438 = (_t4437 if J.t(_t4437) else [])
		v_q_4007 = J.mc(_t4438, "find", [Callable(self, "_f667").bind(_s1608)])
		if J.t(v_q_4007):
			return {"k": "deliver", "t": J.add("交還", J.gp(v_q_4007, "thing")), "q": v_q_4007}
		var _t4441 = J.gp(_s1608["un"], "props")
		v_p_4008 = J.mc(_t4441, "find", [Callable(self, "_f668").bind(_s1608)])
		if J.t(v_p_4008):
			return {"k": "prop", "t": J.gp(J.gp(_s1608["__p"]["PROP"], J.gp(v_p_4008, "k")), "v"), "p": v_p_4008, "un": _s1608["un"]}
		var _t4443 = J.gp(_s1608["un"], "props")
		v_anc_4009 = J.mc(_t4443, "find", [Callable(self, "_f669").bind(_s1608)])
		if J.t(v_anc_4009):
			return {"k": "respect", "t": "（祖先牌位：唔好郁）"}
		return null
	var _t4444 = J.gp(_s1608["__p"]["G"], "cprops")
	var _t4445 = (_t4444 if J.t(_t4444) else [])
	v_cp_4010 = J.mc(_t4445, "find", [Callable(self, "_f670").bind(_s1608)])
	if J.t(v_cp_4010):
		return {"k": "cprop", "t": ("敲水管" if J.seq(J.gp(v_cp_4010, "k"), "pipeK") else "整閃走廊燈"), "p": v_cp_4010}
	if J.t(_s1608["__p"]["UNIT"]):
		v_ua_4011 = J.mc(_s1608["__p"]["UNIT"], "action", [v_g_4004, _s1608["n"]])
		if J.t(v_ua_4011):
			return v_ua_4011
	if J.t(_s1608["__p"]["LIFT"]):
		v_la_4012 = J.mc(_s1608["__p"]["LIFT"], "action", [v_g_4004, _s1608["n"]])
		if J.t(v_la_4012):
			return v_la_4012
	var _t4447 = J.seq(J.gp(_s1608["n"], "kind"), "lift")
	var _t4449 = (J.gp(_s1608["__p"]["LV"], "lift") if _t4447 else _t4447)
	if J.t(_t4449):
		var _t4448 = J.gp(_s1608["__p"]["G"], "liftCd")
		_t4449 = J.cmp((_t4448 if J.t(_t4448) else 0.0), 0.0, "<=")
	if J.t(_t4449):
		return {"k": "lift", "t": "叫𨋢自己上落"}
	if J.seq(J.gp(_s1608["n"], "kind"), "pipe"):
		return {"k": "pipeN", "t": "敲雨水喉（另一層都聽到）"}
	var _t4450 = J.gp(_s1608["n"], "id")
	var _t4452 = J.seq(J.mc(_t4450, "slice", [(-2.0)]), "_s")
	if not J.t(_t4452):
		var _t4451 = J.gp(_s1608["n"], "id")
		_t4452 = J.seq(J.mc(_t4451, "slice", [(-2.0)]), "_b")
	if _t4452:
		var _t4453 = J.gp(_s1608["n"], "links")
		var _t4454 = J.mc(_t4453, "map", [Callable(self, "_f671").bind(_s1608)])
		v_fe_4013 = J.mc(_t4454, "find", [Callable(self, "_f672").bind(_s1608)])
		var _t4455 = (J.cmp(J.gp(J.gp(v_fe_4013, "fire"), "cd"), 0.0, "<=") if J.t(v_fe_4013) else v_fe_4013)
		if J.t((J.cmp(J.gp(J.gp(v_fe_4013, "fire"), "shut"), 0.0, "<=") if J.t(_t4455) else _t4455)):
			return {"k": "fire", "t": "閂防煙門（保安要兜路）", "e": v_fe_4013}
	return null

func _f674(this_, a: Array, env):
	var v_x_4053 = null
	v_x_4053 = J.arg(a, 0)
	var _t4465 = J.min_([100.0, J.add(J.gp(v_x_4053, "energy"), 30.0)])
	J.sp(v_x_4053, "energy", _t4465)

func _f675(this_, a: Array, env):
	var v_r_4056 = null
	v_r_4056 = J.arg(a, 0)
	if (not J.seq(J.gp(v_r_4056, "state"), "home")):
		return null
	if (not J.t(J.gp(v_r_4056, "awake"))):
		J.sp(v_r_4056, "awake", true)
		J.sp(v_r_4056, "woke", true)
		var _t4476 = J.mul(J.mul(J.gp(env["P"], "f"), 0.6), J.gp(J.gp(env["__p"]["G"], "mods"), "pow"))
		var _t4475 = env["__p"]["gpF"]
		var _t4477 = J.add(J.gp(v_r_4056, "fear"), (J.mul(_t4476, J.cl(_t4475, null, [env["g"]])) * J.sub(1.0, J.gp(v_r_4056, "brave"))))
		J.sp(v_r_4056, "fear", _t4477)
		J.sp(v_r_4056, "jumpT", 0.5)
		var _t4478 = env["__p"]["say"]
		var _t4479 = env["__p"]["pick"]
		J.cl(_t4478, null, [v_r_4056, J.cl(_t4479, null, [["咩聲呀……邊個？", "發開夢？"]])])
	else:
		var _t4480 = env["__p"]["scareRes"]
		J.cl(_t4480, null, [v_r_4056, J.gp(env["P"], "f"), env["g"]])
		if J.cmp(J.cl(env["__p"]["rnd"], null, []), 0.6, "<"):
			var _t4481 = env["__p"]["say"]
			var _t4482 = env["__p"]["pick"]
			J.cl(_t4481, null, [v_r_4056, J.cl(_t4482, null, [J.gp(env["__p"]["PROPLINE"], J.gp(env["p"], "k"))])])

func _f676(this_, a: Array, env):
	var v_h_4059 = null
	v_h_4059 = J.arg(a, 0)
	var _t4492 = J.seq(J.gp(v_h_4059, "kind"), "guard")
	var _t4493 = (J.seq(J.gp(J.gp(J.gp(env["__p"]["G"], "nodes"), J.gp(v_h_4059, "node")), "f"), J.gp(env["nn"], "f")) if _t4492 else _t4492)
	var _t4494 = ((absf(J.num(J.sub(J.gp(v_h_4059, "x"), J.gp(env["nn"], "x")))) < 260.0) if _t4493 else _t4493)
	if ((not J.seq(J.gp(v_h_4059, "state"), "chase")) if _t4494 else _t4494):
		var _t4495 = env["__p"]["spook"]
		J.cl(_t4495, null, [v_h_4059, "盞燈……盞燈做咩閃成咁？！"])

func _f677(this_, a: Array, env):
	var v_l_4062 = null
	v_l_4062 = J.arg(a, 0)
	return J.gp(v_l_4062, "e")

func _f678(this_, a: Array, env):
	var v_e_4065 = null
	v_e_4065 = J.arg(a, 0)
	return J.gp(v_e_4065, "pipe")

func _f679(this_, a: Array, env):
	var v_h_4068 = null
	v_h_4068 = J.arg(a, 0)
	J.sp(v_h_4068, "path", null)
	J.sp(v_h_4068, "repath", 0.0)

func _f673(this_, a: Array, env):
	var v_a_4035 = null; var v_q_4036 = null; var v_ow_4037 = null; var v_un_4039 = null; var v_q2_4041 = null; var v_cp_4042 = null; var v_fs_4044 = null; var v_f_4045 = null; var v_tf_4046 = null; var v_ln_4047 = null; var v_e_4048 = null; var v_other_4049 = null; var v_fe_4050 = null
	var _s1619 = {"__p": env, "g": null, "p": null, "P": null, "nn": null}
	_s1619["g"] = J.gp(J.gp(_s1619["__p"]["G"], "gh"), J.gp(_s1619["__p"]["G"], "active"))
	var _t4456 = _s1619["__p"]["ctxAction"]
	v_a_4035 = J.cl(_t4456, null, [_s1619["g"]])
	if (not J.t(v_a_4035)):
		return null
	var _t4457 = _s1619["__p"]["standStill"]
	J.cl(_t4457, null, [_s1619["g"]])
	if J.t(J.gp(_s1619["g"], "to")):
		var _t4458 = _s1619["__p"]["float"]
		J.cl(_t4458, null, [J.gp(_s1619["g"], "x"), J.sub(J.gp(_s1619["g"], "y"), 80.0), "行到位先做得", "#ffd54a"])
		return null
	var _t4459 = _s1619["__p"]["calm"]
	J.cl(_t4459, null, [_s1619["g"]])
	if J.seq(J.gp(v_a_4035, "k"), "liftIn"):
		J.mc(_s1619["__p"]["LIFT"], "enter", [_s1619["g"]])
		return null
	if J.t((J.mc(_s1619["__p"]["UNIT"], "act", [_s1619["g"], v_a_4035]) if J.t(_s1619["__p"]["UNIT"]) else _s1619["__p"]["UNIT"])):
		return null
	if J.seq(J.gp(v_a_4035, "k"), "respect"):
		var _t4460 = _s1619["__p"]["float"]
		J.cl(_t4460, null, [J.gp(_s1619["g"], "x"), J.sub(J.gp(_s1619["g"], "y"), 90.0), "祖先牌位要尊重，我哋唔郁", "#e8d8b0"])
		return null
	if J.seq(J.gp(v_a_4035, "k"), "deliver"):
		v_q_4036 = J.gp(v_a_4035, "q")
		J.sp(v_q_4036, "state", 2.0)
		var _t4461 = _s1619["__p"]["G"]
		J.sp(_t4461, "carry", null)
		v_ow_4037 = J.gp(J.gp(v_q_4036, "owner"), "res")
		if J.t(v_ow_4037):
			var _t4462 = _s1619["__p"]["say"]
			J.cl(_t4462, null, [v_ow_4037, (J.add("咦？我副", J.gp(v_q_4036, "thing")) + "點解會喺張枱度嘅？多謝晒……")])
			J.sp(v_ow_4037, "fear", 0.0)
		var _t4463 = _s1619["__p"]["addFear"]
		J.cl(_t4463, null, [25.0, J.gp(_s1619["g"], "x"), J.sub(J.gp(_s1619["g"], "y"), 90.0)])
		var _t4464 = J.gp(_s1619["__p"]["G"], "gh")
		J.mc(_t4464, "forEach", [Callable(self, "_f674").bind(_s1619)])
		var _t4466 = _s1619["__p"]["float"]
		J.cl(_t4466, null, [J.gp(_s1619["g"], "x"), J.sub(J.gp(_s1619["g"], "y"), 120.0), J.add("支線完成：", J.gp(v_q_4036, "t")), "#8affc8"])
		J.cl(_s1619["__p"]["giveStory"], null, [])
		var _t4467 = _s1619["__p"]["toast"]
		J.cl(_t4467, null, [(J.add("支線完成！", J.gp(v_q_4036, "t")) + "——怕意 +25、三隻鬼能量 +30。")])
		return null
	if J.seq(J.gp(v_a_4035, "k"), "prop"):
		_s1619["p"] = J.gp(v_a_4035, "p")
		v_un_4039 = J.gp(v_a_4035, "un")
		_s1619["P"] = J.gp(_s1619["__p"]["PROP"], J.gp(_s1619["p"], "k"))
		if J.cmp(J.gp(_s1619["__p"]["G"], "lureCd"), 0.0, ">"):
			return null
		var _t4468 = _s1619["p"]
		J.sp(_t4468, "t", 3.0)
		var _t4469 = _s1619["p"]
		J.sp(_t4469, "cd", 18.0)
		var _t4470 = _s1619["__p"]["G"]
		J.sp(_t4470, "lureCd", 1.5)
		var _t4471 = _s1619["g"]
		J.sp(_t4471, "actT", 0.9)
		var _t4472 = _s1619["g"]
		var _t4473 = (1.0 if J.cmp(J.gp(_s1619["p"], "x"), J.gp(_s1619["g"], "x"), ">") else (-1.0))
		J.sp(_t4472, "dir", _t4473)
		var _t4474 = J.gp(v_un_4039, "rs")
		J.mc(_t4474, "forEach", [Callable(self, "_f675").bind(_s1619)])
		if J.seq(J.gp(_s1619["p"], "k"), "mahjong"):
			v_q2_4041 = 0.0
			while true:
				if not J.cmp(v_q2_4041, 10.0, "<"): break
				var _t4483 = _s1619["__p"]["part"]
				J.cl(_t4483, null, [J.gp(_s1619["p"], "x"), J.sub(J.gp(v_un_4039, "y"), 40.0), (J.sub(J.cl(_s1619["__p"]["rnd"], null, []), 0.5) * 90.0), ((-60.0) - J.mul(J.cl(_s1619["__p"]["rnd"], null, []), 40.0)), 0.8, "paper"])
				v_q2_4041 = J.num(v_q2_4041) + 1.0
		var _t4484 = _s1619["__p"]["float"]
		J.cl(_t4484, null, [J.gp(_s1619["p"], "x"), J.sub(J.gp(v_un_4039, "y"), 96.0), J.add(J.gp(_s1619["P"], "v"), "！"), "#ffb7a0"])
		var _t4485 = _s1619["__p"]["noise"]
		J.cl(_t4485, null, [J.gp(v_un_4039, "did"), J.gp(_s1619["P"], "lv"), J.gp(_s1619["P"], "n")])
		J.cl(_s1619["__p"]["lureCost"], null, [])
		var _t4486 = _s1619["g"]
		var _t4487 = J.min_([100.0, J.add(J.gp(_s1619["g"], "energy"), 8.0)])
		J.sp(_t4486, "energy", _t4487)
		return null
	if J.seq(J.gp(v_a_4035, "k"), "cprop"):
		v_cp_4042 = J.gp(v_a_4035, "p")
		J.sp(v_cp_4042, "t", 3.0)
		J.sp(v_cp_4042, "cd", 20.0)
		J.cl(_s1619["__p"]["lureCost"], null, [])
		_s1619["nn"] = J.gp(J.gp(_s1619["__p"]["G"], "nodes"), J.gp(v_cp_4042, "node"))
		if J.seq(J.gp(v_cp_4042, "k"), "pipeK"):
			var _t4488 = _s1619["__p"]["float"]
			J.cl(_t4488, null, [J.gp(_s1619["nn"], "x"), J.sub(J.gp(_s1619["nn"], "y"), 90.0), "噹！噹！噹！", "#ffd54a"])
			var _t4489 = _s1619["__p"]["noise"]
			J.cl(_t4489, null, [J.gp(v_cp_4042, "node"), 2.0])
		else:
			var _t4490 = _s1619["__p"]["float"]
			J.cl(_t4490, null, [J.gp(_s1619["nn"], "x"), J.sub(J.gp(_s1619["nn"], "y"), 90.0), "走廊燈閃閃吓……", "#ffd54a"])
			var _t4491 = J.gp(_s1619["__p"]["G"], "guards")
			J.mc(_t4491, "forEach", [Callable(self, "_f676").bind(_s1619)])
			var _t4496 = _s1619["__p"]["noise"]
			J.cl(_t4496, null, [J.gp(v_cp_4042, "node"), 1.0])
		return null
	if J.seq(J.gp(v_a_4035, "k"), "lift"):
		var _t4497 = _s1619["__p"]["G"]
		J.sp(_t4497, "liftCd", 16.0)
		J.cl(_s1619["__p"]["lureCost"], null, [])
		v_fs_4044 = []
		v_f_4045 = 0.0
		while true:
			if not J.cmp(v_f_4045, _s1619["__p"]["FL"], "<"): break
			if (absf(J.num(J.sub(v_f_4045, J.gp(J.gp(J.gp(_s1619["__p"]["G"], "nodes"), J.gp(_s1619["g"], "node")), "f")))) >= 2.0):
				J.mc(v_fs_4044, "push", [v_f_4045])
			v_f_4045 = J.num(v_f_4045) + 1.0
		var _t4498 = _s1619["__p"]["pick"]
		v_tf_4046 = J.cl(_t4498, null, [(v_fs_4044 if J.t(J.len(v_fs_4044)) else [0.0])])
		v_ln_4047 = (J.add("f", v_tf_4046) + "_l")
		var _t4499 = _s1619["__p"]["G"]
		var _t4500 = {"f": v_tf_4046, "t": 2.5}
		J.sp(_t4499, "liftFx", _t4500)
		var _t4501 = _s1619["__p"]["float"]
		J.cl(_t4501, null, [J.gp(_s1619["g"], "x"), J.sub(J.gp(_s1619["g"], "y"), 90.0), (J.add("部𨋢自己落咗去", J.gp(_s1619["__p"]["FLN"], v_tf_4046)) + "……"), "#ffd54a"])
		var _t4502 = _s1619["__p"]["noise"]
		J.cl(_t4502, null, [v_ln_4047, 3.0])
		return null
	if J.seq(J.gp(v_a_4035, "k"), "pipeN"):
		if J.cmp(J.gp(_s1619["__p"]["G"], "lureCd"), 0.0, ">"):
			return null
		var _t4503 = _s1619["__p"]["G"]
		J.sp(_t4503, "lureCd", 6.0)
		J.cl(_s1619["__p"]["lureCost"], null, [])
		var _t4504 = J.gp(J.gp(J.gp(_s1619["__p"]["G"], "nodes"), J.gp(_s1619["g"], "node")), "links")
		var _t4505 = J.mc(_t4504, "map", [Callable(self, "_f677").bind(_s1619)])
		v_e_4048 = J.mc(_t4505, "find", [Callable(self, "_f678").bind(_s1619)])
		v_other_4049 = (J.gp(v_e_4048, "b") if J.seq(J.gp(v_e_4048, "a"), J.gp(_s1619["g"], "node")) else J.gp(v_e_4048, "a"))
		var _t4506 = _s1619["__p"]["float"]
		J.cl(_t4506, null, [J.gp(_s1619["g"], "x"), J.sub(J.gp(_s1619["g"], "y"), 90.0), (J.add("噹……（", J.gp(_s1619["__p"]["FLN"], J.gp(J.gp(J.gp(_s1619["__p"]["G"], "nodes"), v_other_4049), "f"))) + "都聽到）"), "#ffd54a"])
		var _t4507 = _s1619["__p"]["noise"]
		J.cl(_t4507, null, [v_other_4049, 2.0])
		return null
	if J.seq(J.gp(v_a_4035, "k"), "fire"):
		v_fe_4050 = J.gp(v_a_4035, "e")
		var _t4508 = J.gp(v_fe_4050, "fire")
		J.sp(_t4508, "shut", 14.0)
		var _t4509 = J.gp(v_fe_4050, "fire")
		J.sp(_t4509, "cd", 26.0)
		var _t4510 = _s1619["__p"]["float"]
		J.cl(_t4510, null, [J.gp(_s1619["g"], "x"), J.sub(J.gp(_s1619["g"], "y"), 90.0), "防煙門閂咗！保安要兜路", "#9fd6bf"])
		var _t4511 = J.gp(_s1619["__p"]["G"], "guards")
		J.mc(_t4511, "forEach", [Callable(self, "_f679").bind(_s1619)])
		return null

func _f680(this_, a: Array, env):
	var v_i_4071 = null
	v_i_4071 = 0.0
	while true:
		if not J.cmp(v_i_4071, J.len(env["STORY"]), "<"): break
		var _t4512 = J.gp(env["G"], "story")
		if J.cmp(J.mc(_t4512, "indexOf", [v_i_4071]), 0.0, "<"):
			var _t4513 = J.gp(env["G"], "story")
			J.mc(_t4513, "push", [v_i_4071])
			J.mc(J.gp(env["G"], "story"), "sort", [])
			var _t4514 = env["toast"]
			J.cl(_t4514, null, [J.add("收集到故事碎片——", J.gp(env["STORY"], v_i_4071))])
			return null
		v_i_4071 = J.num(v_i_4071) + 1.0

func _f683(this_, a: Array, env):
	var v_r_4081 = null
	v_r_4081 = J.arg(a, 0)
	if J.seq(J.gp(v_r_4081, "state"), "home"):
		var _t4529 = J.min_([90.0, J.add(J.gp(v_r_4081, "fear"), 4.0)])
		J.sp(v_r_4081, "fear", _t4529)

func _f684(this_, a: Array, env):
	var v_r_4084 = null
	v_r_4084 = J.arg(a, 0)
	if J.seq(J.gp(v_r_4084, "state"), "home"):
		J.sp(v_r_4084, "fear", 0.0)
		var _t4533 = env["__p"]["say"]
		J.cl(_t4533, null, [v_r_4084, "佢……佢走咗？好似有人幫緊我哋……"])

func _f685(this_, a: Array, env):
	var v_r_4087 = null
	v_r_4087 = J.arg(a, 0)
	return (not J.seq(J.gp(v_r_4087, "state"), "home"))

func _f682(this_, a: Array, env):
	var v_q_4077 = null; var v_h_4078 = null
	v_q_4077 = J.arg(a, 0)
	if J.seq(J.gp(v_q_4077, "id"), "debt"):
		var _t4517 = J.seq(J.gp(v_q_4077, "state"), 0.0)
		if (J.cmp(J.gp(env["__p"]["G"], "t"), J.gp(v_q_4077, "at"), ">=") if _t4517 else _t4517):
			J.sp(v_q_4077, "state", 1.0)
			var _t4518 = env["__p"]["mkHuman"]
			v_h_4078 = J.cl(_t4518, null, ["collector", J.gp(J.gp(v_q_4077, "unit"), "did"), {"courage": 3.0, "real": true}])
			J.sp(v_h_4078, "wait", 1000000000.0)
			var _t4519 = J.gp(env["__p"]["G"], "guards")
			J.mc(_t4519, "push", [v_h_4078])
			J.sp(v_q_4077, "h", v_h_4078)
			var _t4520 = env["__p"]["toast"]
			J.cl(_t4520, null, [J.add(J.gp(env["__p"]["FLN"], J.gp(J.gp(v_q_4077, "unit"), "f")), "有個收數佬拍門大嗌，屋企人嚇到唔敢出聲……嚇走佢！")])
		if J.seq(J.gp(v_q_4077, "state"), 1.0):
			v_h_4078 = J.gp(v_q_4077, "h")
			var _t4521 = J.gp(v_h_4078, "bangT")
			var _t4522 = J.sub((_t4521 if J.t(_t4521) else 0.0), env["dt"])
			J.sp(v_h_4078, "bangT", _t4522)
			var _t4523 = J.cmp(J.gp(v_h_4078, "bangT"), 0.0, "<=")
			if ((not J.seq(J.gp(v_h_4078, "state"), "flee")) if _t4523 else _t4523):
				J.sp(v_h_4078, "bangT", 3.2)
				var _t4524 = env["__p"]["pick"]
				var _t4525 = J.cl(_t4524, null, [["開門呀！還錢呀！", "我知你喺入面！", "唔還錢就淋紅油！"]])
				J.sp(v_h_4078, "say", _t4525)
				J.sp(v_h_4078, "sayT", 2.4)
				var _t4526 = env["__p"]["G"]
				var _t4527 = J.max_([J.gp(env["__p"]["G"], "shake"), 0.12])
				J.sp(_t4526, "shake", _t4527)
				var _t4528 = J.gp(J.gp(v_q_4077, "unit"), "rs")
				J.mc(_t4528, "forEach", [Callable(self, "_f683").bind(env)])
			var _t4530 = J.seq(J.gp(v_h_4078, "state"), "flee")
			if (_t4530 if _t4530 else J.seq(J.gp(v_h_4078, "state"), "gone")):
				J.sp(v_q_4077, "state", 2.0)
				var _t4531 = J.gp(J.gp(v_q_4077, "unit"), "items")
				J.mc(_t4531, "push", ["money", "money"])
				var _t4532 = J.gp(J.gp(v_q_4077, "unit"), "rs")
				J.mc(_t4532, "forEach", [Callable(self, "_f684").bind(env)])
				var _t4534 = env["__p"]["addFear"]
				J.cl(_t4534, null, [30.0, J.gp(J.gp(v_q_4077, "unit"), "x"), J.sub(J.gp(J.gp(v_q_4077, "unit"), "y"), 100.0)])
				var _t4535 = env["__p"]["float"]
				J.cl(_t4535, null, [J.gp(J.gp(v_q_4077, "unit"), "x"), J.sub(J.gp(J.gp(v_q_4077, "unit"), "y"), 130.0), J.add("支線完成：", J.gp(v_q_4077, "t")), "#8affc8"])
				J.cl(env["__p"]["giveStory"], null, [])
				var _t4536 = env["__p"]["toast"]
				J.cl(_t4536, null, ["收數佬嚇到碌落樓梯！佢跌低咗個銀包喺門口。"])
	var _t4537 = J.seq(J.gp(v_q_4077, "id"), "mj")
	var _t4539 = (J.seq(J.gp(v_q_4077, "state"), 0.0) if _t4537 else _t4537)
	if J.t(_t4539):
		var _t4538 = J.gp(J.gp(v_q_4077, "unit"), "rs")
		_t4539 = J.mc(_t4538, "every", [Callable(self, "_f685").bind(env)])
	if J.t(_t4539):
		J.sp(v_q_4077, "state", 2.0)
		var _t4540 = env["__p"]["addFear"]
		J.cl(_t4540, null, [20.0, J.gp(J.gp(v_q_4077, "unit"), "x"), J.sub(J.gp(J.gp(v_q_4077, "unit"), "y"), 100.0)])
		var _t4541 = J.gp(J.gp(v_q_4077, "unit"), "items")
		J.mc(_t4541, "push", ["money"])
		var _t4542 = env["__p"]["float"]
		J.cl(_t4542, null, [J.gp(J.gp(v_q_4077, "unit"), "x"), J.sub(J.gp(J.gp(v_q_4077, "unit"), "y"), 130.0), J.add("支線完成：", J.gp(v_q_4077, "t")), "#8affc8"])
		J.cl(env["__p"]["giveStory"], null, [])
	var _t4543 = J.seq(J.gp(v_q_4077, "id"), "lost")
	var _t4544 = (J.seq(J.gp(v_q_4077, "state"), 0.0) if _t4543 else _t4543)
	if (J.seq(J.gp(env["__p"]["G"], "carry"), "lost") if _t4544 else _t4544):
		J.sp(v_q_4077, "state", 1.0)

func _f681(this_, a: Array, env):
	var _s1646 = {"__p": env, "dt": null}
	_s1646["dt"] = J.arg(a, 0)
	var _t4515 = J.gp(_s1646["__p"]["G"], "quests")
	var _t4516 = (_t4515 if J.t(_t4515) else [])
	J.mc(_t4516, "forEach", [Callable(self, "_f682").bind(_s1646)])

func _f688(this_, a: Array, env):
	var v_p_4097 = null; var v_x_4098 = null; var v_y_4099 = null; var v_a_4100 = null; var v_T_4101 = null; var v_i_4102 = null; var v_o_4103 = null
	v_p_4097 = J.arg(a, 0)
	v_x_4098 = J.gp(v_p_4097, "x")
	v_y_4099 = J.sub(J.gp(env["u"], "y"), 4.0)
	v_a_4100 = J.cmp(J.gp(v_p_4097, "t"), 0.0, ">")
	v_T_4101 = J.gp(env["__p"]["G"], "t")
	if J.seq(J.gp(v_p_4097, "k"), "tv"):
		var _t4551 = env["__p"]["ctx"]
		J.sp(_t4551, "fillStyle", "#1a1a1e")
		J.mc(env["__p"]["ctx"], "fillRect", [J.sub(v_x_4098, 14.0), J.sub(v_y_4099, 40.0), 28.0, 20.0])
		var _t4552 = env["__p"]["ctx"]
		var _t4553 = ((J.add("rgba(220,230,240,", (0.5 + (0.5 * randf()))) + ")") if J.t(v_a_4100) else "#2a3440")
		J.sp(_t4552, "fillStyle", _t4553)
		J.mc(env["__p"]["ctx"], "fillRect", [J.sub(v_x_4098, 12.0), J.sub(v_y_4099, 38.0), 24.0, 16.0])
		if J.t(v_a_4100):
			var _t4554 = env["__p"]["ctx"]
			J.sp(_t4554, "fillStyle", "rgba(20,20,20,0.7)")
			J.mc(env["__p"]["ctx"], "beginPath", [])
			J.mc(env["__p"]["ctx"], "arc", [v_x_4098, J.sub(v_y_4099, 30.0), 5.0, 0.0, 7.0])
			J.mc(env["__p"]["ctx"], "fill", [])
		var _t4555 = env["__p"]["ctx"]
		J.sp(_t4555, "fillStyle", "#4a3424")
		J.mc(env["__p"]["ctx"], "fillRect", [J.sub(v_x_4098, 10.0), J.sub(v_y_4099, 20.0), 20.0, 16.0])
	else:
		if J.seq(J.gp(v_p_4097, "k"), "fan"):
			var _t4556 = env["__p"]["ctx"]
			J.sp(_t4556, "strokeStyle", "#bbb")
			var _t4557 = env["__p"]["ctx"]
			J.sp(_t4557, "lineWidth", 2.0)
			J.mc(env["__p"]["ctx"], "beginPath", [])
			J.mc(env["__p"]["ctx"], "moveTo", [v_x_4098, v_y_4099])
			J.mc(env["__p"]["ctx"], "lineTo", [v_x_4098, J.sub(v_y_4099, 30.0)])
			J.mc(env["__p"]["ctx"], "stroke", [])
			J.mc(env["__p"]["ctx"], "save", [])
			J.mc(env["__p"]["ctx"], "translate", [v_x_4098, J.sub(v_y_4099, 34.0)])
			J.mc(env["__p"]["ctx"], "rotate", [J.mul(v_T_4101, (40.0 if J.t(v_a_4100) else 6.0))])
			v_i_4102 = 0.0
			while true:
				if not J.cmp(v_i_4102, 3.0, "<"): break
				J.mc(env["__p"]["ctx"], "rotate", [2.094])
				var _t4558 = env["__p"]["ctx"]
				J.sp(_t4558, "fillStyle", "rgba(200,210,220,0.8)")
				J.mc(env["__p"]["ctx"], "fillRect", [0.0, (-2.0), 9.0, 4.0])
				v_i_4102 = J.num(v_i_4102) + 1.0
			J.mc(env["__p"]["ctx"], "restore", [])
			var _t4559 = env["__p"]["ctx"]
			J.sp(_t4559, "strokeStyle", "#888")
			J.mc(env["__p"]["ctx"], "beginPath", [])
			J.mc(env["__p"]["ctx"], "arc", [v_x_4098, J.sub(v_y_4099, 34.0), 10.0, 0.0, 7.0])
			J.mc(env["__p"]["ctx"], "stroke", [])
		else:
			if J.seq(J.gp(v_p_4097, "k"), "fridge"):
				var _t4560 = env["__p"]["ctx"]
				J.sp(_t4560, "fillStyle", "#7d8786")
				J.mc(env["__p"]["ctx"], "fillRect", [J.sub(v_x_4098, 9.0), J.sub(v_y_4099, 40.0), 18.0, 38.0])
				var _t4561 = env["__p"]["ctx"]
				J.sp(_t4561, "fillStyle", "rgba(255,255,255,0.12)")
				J.mc(env["__p"]["ctx"], "fillRect", [J.sub(v_x_4098, 9.0), J.sub(v_y_4099, 40.0), 5.0, 38.0])
				var _t4562 = env["__p"]["ctx"]
				J.sp(_t4562, "strokeStyle", "#2a2e2e")
				var _t4563 = env["__p"]["ctx"]
				J.sp(_t4563, "lineWidth", 1.5)
				J.mc(env["__p"]["ctx"], "strokeRect", [J.sub(v_x_4098, 9.0), J.sub(v_y_4099, 40.0), 18.0, 38.0])
				J.mc(env["__p"]["ctx"], "beginPath", [])
				J.mc(env["__p"]["ctx"], "moveTo", [J.sub(v_x_4098, 9.0), J.sub(v_y_4099, 26.0)])
				J.mc(env["__p"]["ctx"], "lineTo", [J.add(v_x_4098, 9.0), J.sub(v_y_4099, 26.0)])
				J.mc(env["__p"]["ctx"], "stroke", [])
				var _t4564 = env["__p"]["ctx"]
				J.sp(_t4564, "fillStyle", "#c8c8c0")
				J.mc(env["__p"]["ctx"], "fillRect", [J.add(v_x_4098, 5.0), J.sub(v_y_4099, 36.0), 2.0, 7.0])
				if J.t(v_a_4100):
					v_o_4103 = (absf(J.num(sin(J.num(J.mul(v_T_4101, 9.0))))) * 16.0)
					var _t4565 = env["__p"]["ctx"]
					J.sp(_t4565, "fillStyle", "#b8c0c0")
					J.mc(env["__p"]["ctx"], "fillRect", [J.add(v_x_4098, 10.0), J.sub(v_y_4099, 46.0), v_o_4103, 30.0])
					var _t4566 = env["__p"]["ctx"]
					J.sp(_t4566, "fillStyle", "rgba(200,240,255,0.5)")
					J.mc(env["__p"]["ctx"], "fillRect", [J.sub(v_x_4098, 8.0), J.sub(v_y_4099, 44.0), 16.0, 26.0])
			else:
				if J.seq(J.gp(v_p_4097, "k"), "pc"):
					var _t4567 = env["__p"]["ctx"]
					J.sp(_t4567, "fillStyle", "#202428")
					J.mc(env["__p"]["ctx"], "fillRect", [J.sub(v_x_4098, 13.0), J.sub(v_y_4099, 38.0), 26.0, 18.0])
					var _t4568 = env["__p"]["ctx"]
					var _t4569 = (("#e8e8e8" if J.t(J.mod(floor(J.num(J.mul(v_T_4101, 8.0))), 2.0)) else "#d02020") if J.t(v_a_4100) else "#3a6ad0")
					J.sp(_t4568, "fillStyle", _t4569)
					J.mc(env["__p"]["ctx"], "fillRect", [J.sub(v_x_4098, 11.0), J.sub(v_y_4099, 36.0), 22.0, 14.0])
					if J.t(v_a_4100):
						var _t4570 = env["__p"]["ctx"]
						J.sp(_t4570, "fillStyle", "#000")
						J.mc(env["__p"]["ctx"], "fillRect", [J.sub(v_x_4098, 5.0), J.sub(v_y_4099, 32.0), 3.0, 3.0])
						J.mc(env["__p"]["ctx"], "fillRect", [J.add(v_x_4098, 2.0), J.sub(v_y_4099, 32.0), 3.0, 3.0])
						J.mc(env["__p"]["ctx"], "fillRect", [J.sub(v_x_4098, 4.0), J.sub(v_y_4099, 26.0), 8.0, 2.0])
					var _t4571 = env["__p"]["ctx"]
					J.sp(_t4571, "fillStyle", "#4a3424")
					J.mc(env["__p"]["ctx"], "fillRect", [J.sub(v_x_4098, 16.0), J.sub(v_y_4099, 20.0), 32.0, 4.0])
				else:
					if J.seq(J.gp(v_p_4097, "k"), "radio"):
						var _t4572 = env["__p"]["ctx"]
						J.sp(_t4572, "fillStyle", "#8a5a3a")
						J.mc(env["__p"]["ctx"], "fillRect", [J.sub(v_x_4098, 10.0), J.sub(v_y_4099, 26.0), 20.0, 12.0])
						var _t4573 = env["__p"]["ctx"]
						J.sp(_t4573, "fillStyle", "#ffd54a")
						J.mc(env["__p"]["ctx"], "fillRect", [J.add(v_x_4098, 3.0), J.sub(v_y_4099, 23.0), 4.0, 4.0])
						if J.t(v_a_4100):
							var _t4574 = env["__p"]["ctx"]
							J.sp(_t4574, "fillStyle", "#ffe9a0")
							var _t4575 = env["__p"]["ctx"]
							var _t4576 = J.add("bold 12px ", env["__p"]["FONT"])
							J.sp(_t4575, "font", _t4576)
							var _t4577 = env["__p"]["ctx"]
							J.sp(_t4577, "textAlign", "center")
							J.mc(env["__p"]["ctx"], "fillText", ["♪", (J.sub(v_x_4098, 8.0) + (sin(J.num(J.mul(v_T_4101, 5.0))) * 6.0)), (J.sub(v_y_4099, 34.0) - J.mod(J.mul(v_T_4101, 30.0), 14.0))])
							J.mc(env["__p"]["ctx"], "fillText", ["♫", J.add(v_x_4098, 8.0), (J.sub(v_y_4099, 30.0) - J.mod((J.mul(v_T_4101, 30.0) + 7.0), 14.0))])
					else:
						if J.seq(J.gp(v_p_4097, "k"), "phone"):
							var _t4578 = env["__p"]["ctx"]
							J.sp(_t4578, "fillStyle", "#202428")
							J.mc(env["__p"]["ctx"], "fillRect", [J.sub(v_x_4098, 4.0), J.sub(v_y_4099, 22.0), 8.0, 12.0])
							if J.t(v_a_4100):
								var _t4579 = env["__p"]["ctx"]
								J.sp(_t4579, "strokeStyle", "rgba(159,224,255,0.8)")
								var _t4580 = env["__p"]["ctx"]
								J.sp(_t4580, "lineWidth", 1.5)
								v_i_4102 = 0.0
								while true:
									if not J.cmp(v_i_4102, 2.0, "<"): break
									J.mc(env["__p"]["ctx"], "beginPath", [])
									J.mc(env["__p"]["ctx"], "arc", [v_x_4098, J.sub(v_y_4099, 16.0), ((7.0 + J.mul(v_i_4102, 5.0)) + J.mod(J.mul(v_T_4101, 20.0), 5.0)), (-0.8), 0.8])
									J.mc(env["__p"]["ctx"], "stroke", [])
									v_i_4102 = J.num(v_i_4102) + 1.0
						else:
							if J.seq(J.gp(v_p_4097, "k"), "mahjong"):
								var _t4581 = env["__p"]["ctx"]
								J.sp(_t4581, "fillStyle", "#2a6a3a")
								J.mc(env["__p"]["ctx"], "fillRect", [J.sub(v_x_4098, 22.0), J.sub(v_y_4099, 24.0), 44.0, 6.0])
								var _t4582 = env["__p"]["ctx"]
								J.sp(_t4582, "fillStyle", "#4a3424")
								J.mc(env["__p"]["ctx"], "fillRect", [J.sub(v_x_4098, 20.0), J.sub(v_y_4099, 18.0), 4.0, 14.0])
								J.mc(env["__p"]["ctx"], "fillRect", [J.add(v_x_4098, 16.0), J.sub(v_y_4099, 18.0), 4.0, 14.0])
								v_i_4102 = 0.0
								while true:
									if not J.cmp(v_i_4102, 8.0, "<"): break
									var _t4583 = env["__p"]["ctx"]
									J.sp(_t4583, "fillStyle", "#f0ead8")
									J.mc(env["__p"]["ctx"], "fillRect", [(J.sub(v_x_4098, 18.0) + J.mul(v_i_4102, 4.6)), (J.sub(v_y_4099, 28.0) - ((absf(J.num(sin(J.num(J.add(J.mul(v_T_4101, 14.0), v_i_4102))))) * 6.0) if J.t(v_a_4100) else 0.0)), 3.6, 4.0])
									v_i_4102 = J.num(v_i_4102) + 1.0
							else:
								if J.seq(J.gp(v_p_4097, "k"), "doorbell"):
									var _t4584 = env["__p"]["ctx"]
									J.sp(_t4584, "fillStyle", "#c8a050")
									J.mc(env["__p"]["ctx"], "beginPath", [])
									J.mc(env["__p"]["ctx"], "arc", [J.add(J.gp(env["u"], "x"), 16.0), J.sub(v_y_4099, 52.0), 3.0, 0.0, 7.0])
									J.mc(env["__p"]["ctx"], "fill", [])
									var _t4585 = env["__p"]["ctx"]
									J.sp(_t4585, "fillStyle", "#a07040")
									v_i_4102 = 0.0
									while true:
										if not J.cmp(v_i_4102, 3.0, "<"): break
										J.mc(env["__p"]["ctx"], "fillRect", [(J.sub(v_x_4098, 14.0) + J.mul(v_i_4102, 9.0)), (J.sub(v_y_4099, 10.0) - (J.mod(v_i_4102, 2.0) * 8.0)), 10.0, 8.0])
										v_i_4102 = J.num(v_i_4102) + 1.0
									if J.t(v_a_4100):
										var _t4586 = env["__p"]["ctx"]
										J.sp(_t4586, "fillStyle", "#ffd54a")
										var _t4587 = env["__p"]["ctx"]
										var _t4588 = J.add("bold 11px ", env["__p"]["FONT"])
										J.sp(_t4587, "font", _t4588)
										var _t4589 = env["__p"]["ctx"]
										J.sp(_t4589, "textAlign", "center")
										J.mc(env["__p"]["ctx"], "fillText", ["叮噹", J.add(J.gp(env["u"], "x"), 16.0), J.sub(v_y_4099, 60.0)])
								else:
									if J.seq(J.gp(v_p_4097, "k"), "washer"):
										var _t4590 = env["__p"]["ctx"]
										J.sp(_t4590, "fillStyle", "#e8e8e2")
										J.mc(env["__p"]["ctx"], "fillRect", [J.sub(v_x_4098, 12.0), J.sub(v_y_4099, 30.0), 24.0, 28.0])
										var _t4591 = env["__p"]["ctx"]
										J.sp(_t4591, "strokeStyle", "#777")
										var _t4592 = env["__p"]["ctx"]
										J.sp(_t4592, "lineWidth", 1.0)
										J.mc(env["__p"]["ctx"], "strokeRect", [J.sub(v_x_4098, 12.0), J.sub(v_y_4099, 30.0), 24.0, 28.0])
										J.mc(env["__p"]["ctx"], "save", [])
										J.mc(env["__p"]["ctx"], "translate", [v_x_4098, J.sub(v_y_4099, 15.0)])
										J.mc(env["__p"]["ctx"], "rotate", [(J.mul(v_T_4101, 20.0) if J.t(v_a_4100) else 0.0)])
										var _t4593 = env["__p"]["ctx"]
										J.sp(_t4593, "fillStyle", "#6a8aa8")
										J.mc(env["__p"]["ctx"], "beginPath", [])
										J.mc(env["__p"]["ctx"], "arc", [0.0, 0.0, 8.0, 0.0, 7.0])
										J.mc(env["__p"]["ctx"], "fill", [])
										var _t4594 = env["__p"]["ctx"]
										J.sp(_t4594, "fillStyle", "#e8e2d0")
										J.mc(env["__p"]["ctx"], "fillRect", [(-2.0), (-7.0), 4.0, 6.0])
										J.mc(env["__p"]["ctx"], "restore", [])
									else:
										var _t4595 = J.seq(J.gp(v_p_4097, "k"), "kettle")
										if (_t4595 if _t4595 else J.seq(J.gp(v_p_4097, "k"), "rice")):
											var _t4596 = env["__p"]["ctx"]
											var _t4597 = ("#b8bcc0" if J.seq(J.gp(v_p_4097, "k"), "kettle") else "#e8e2d0")
											J.sp(_t4596, "fillStyle", _t4597)
											J.mc(env["__p"]["ctx"], "beginPath", [])
											J.mc(env["__p"]["ctx"], "ellipse", [v_x_4098, J.sub(v_y_4099, 26.0), 8.0, 7.0, 0.0, 0.0, 7.0])
											J.mc(env["__p"]["ctx"], "fill", [])
											if J.t(v_a_4100):
												v_i_4102 = 0.0
												while true:
													if not J.cmp(v_i_4102, 2.0, "<"): break
													var _t4598 = env["__p"]["ctx"]
													J.sp(_t4598, "fillStyle", "rgba(230,230,230,0.5)")
													J.mc(env["__p"]["ctx"], "beginPath", [])
													J.mc(env["__p"]["ctx"], "arc", [J.add(v_x_4098, (6.0 if J.t(v_i_4102) else (-2.0))), (J.sub(v_y_4099, 36.0) - J.mod((J.mul(v_T_4101, 30.0) + J.mul(v_i_4102, 8.0)), 16.0)), 3.0, 0.0, 7.0])
													J.mc(env["__p"]["ctx"], "fill", [])
													v_i_4102 = J.num(v_i_4102) + 1.0
										else:
											if J.seq(J.gp(v_p_4097, "k"), "ancestor"):
												var _t4599 = env["__p"]["ctx"]
												J.sp(_t4599, "fillStyle", "#6a1a16")
												J.mc(env["__p"]["ctx"], "fillRect", [J.sub(v_x_4098, 9.0), J.sub(v_y_4099, 56.0), 18.0, 22.0])
												var _t4600 = env["__p"]["ctx"]
												J.sp(_t4600, "fillStyle", "#ffd54a")
												J.mc(env["__p"]["ctx"], "fillRect", [J.sub(v_x_4098, 6.0), J.sub(v_y_4099, 53.0), 12.0, 3.0])
												var _t4601 = env["__p"]["ctx"]
												var _t4602 = (0.35 + (0.15 * sin(J.num(J.mul(v_T_4101, 3.0)))))
												J.sp(_t4601, "globalAlpha", _t4602)
												var _t4603 = env["__p"]["ctx"]
												J.sp(_t4603, "fillStyle", "#ff8a5a")
												J.mc(env["__p"]["ctx"], "beginPath", [])
												J.mc(env["__p"]["ctx"], "arc", [v_x_4098, J.sub(v_y_4099, 30.0), 4.0, 0.0, 7.0])
												J.mc(env["__p"]["ctx"], "fill", [])
												var _t4604 = env["__p"]["ctx"]
												J.sp(_t4604, "globalAlpha", 1.0)
	if J.t(((not J.seq(J.gp(v_p_4097, "k"), "ancestor")) if J.t(v_a_4100) else v_a_4100)):
		var _t4605 = env["__p"]["ctx"]
		var _t4606 = (J.add("rgba(138,255,200,", J.div(J.mul(0.4, J.gp(v_p_4097, "t")), 3.0)) + ")")
		J.sp(_t4605, "strokeStyle", _t4606)
		var _t4607 = env["__p"]["ctx"]
		J.sp(_t4607, "lineWidth", 2.0)
		J.mc(env["__p"]["ctx"], "beginPath", [])
		J.mc(env["__p"]["ctx"], "arc", [v_x_4098, J.sub(v_y_4099, 28.0), (22.0 + (J.sub(3.0, J.gp(v_p_4097, "t")) * 10.0)), 0.0, 7.0])
		J.mc(env["__p"]["ctx"], "stroke", [])

func _f687(this_, a: Array, env):
	var _s1660 = {"__p": env, "u": null}
	_s1660["u"] = J.arg(a, 0)
	var _t4548 = (not J.t(J.gp(_s1660["u"], "seen")))
	if ((not J.t(J.gp(_s1660["u"], "entered"))) if _t4548 else _t4548):
		return null
	var _t4549 = J.cmp(J.gp(_s1660["u"], "y"), J.gp(_s1660["__p"]["CULL"], "y0"), "<")
	if (_t4549 if _t4549 else J.cmp(J.sub(J.gp(_s1660["u"], "y"), 140.0), J.gp(_s1660["__p"]["CULL"], "y1"), ">")):
		return null
	var _t4550 = J.gp(_s1660["u"], "props")
	J.mc(_t4550, "forEach", [Callable(self, "_f688").bind(_s1660)])

func _f689(this_, a: Array, env):
	var v_p_4106 = null; var v_n_4107 = null; var v_x_4108 = null; var v_y_4109 = null; var v_i_4110 = null; var v_on_4111 = null; var v_gr_4112 = null
	v_p_4106 = J.arg(a, 0)
	v_n_4107 = J.gp(J.gp(env["G"], "nodes"), J.gp(v_p_4106, "node"))
	v_x_4108 = J.add(J.gp(v_n_4107, "x"), 22.0)
	v_y_4109 = J.gp(v_n_4107, "y")
	var _t4610 = J.cmp(v_y_4109, J.gp(env["CULL"], "y0"), "<")
	if (_t4610 if _t4610 else J.cmp(J.sub(v_y_4109, 130.0), J.gp(env["CULL"], "y1"), ">")):
		return null
	if J.seq(J.gp(v_p_4106, "k"), "pipeK"):
		var _t4611 = env["ctx"]
		J.sp(_t4611, "strokeStyle", "#7a8a86")
		var _t4612 = env["ctx"]
		J.sp(_t4612, "lineWidth", 3.0)
		J.mc(env["ctx"], "beginPath", [])
		J.mc(env["ctx"], "moveTo", [v_x_4108, J.sub(v_y_4109, 110.0)])
		J.mc(env["ctx"], "lineTo", [v_x_4108, J.sub(v_y_4109, 6.0)])
		J.mc(env["ctx"], "stroke", [])
		if J.cmp(J.gp(v_p_4106, "t"), 0.0, ">"):
			var _t4613 = env["ctx"]
			var _t4614 = (J.add("rgba(255,213,74,", J.div(J.gp(v_p_4106, "t"), 3.0)) + ")")
			J.sp(_t4613, "strokeStyle", _t4614)
			v_i_4110 = 0.0
			while true:
				if not J.cmp(v_i_4110, 3.0, "<"): break
				J.mc(env["ctx"], "beginPath", [])
				J.mc(env["ctx"], "arc", [v_x_4108, J.sub(v_y_4109, 60.0), ((8.0 + J.mul(v_i_4110, 7.0)) + (J.sub(3.0, J.gp(v_p_4106, "t")) * 6.0)), 0.0, 7.0])
				J.mc(env["ctx"], "stroke", [])
				v_i_4110 = J.num(v_i_4110) + 1.0
	else:
		v_on_4111 = (J.mod(floor(J.num(J.mul(J.gp(env["G"], "t"), 12.0))), 2.0) if J.cmp(J.gp(v_p_4106, "t"), 0.0, ">") else 1.0)
		var _t4615 = env["ctx"]
		var _t4616 = ("rgba(255,240,180,0.9)" if J.t(v_on_4111) else "#333")
		J.sp(_t4615, "fillStyle", _t4616)
		J.mc(env["ctx"], "fillRect", [J.sub(J.gp(v_n_4107, "x"), 10.0), J.sub(v_y_4109, 118.0), 20.0, 4.0])
		if J.t(v_on_4111):
			v_gr_4112 = J.mc(env["ctx"], "createRadialGradient", [J.gp(v_n_4107, "x"), J.sub(v_y_4109, 114.0), 2.0, J.gp(v_n_4107, "x"), J.sub(v_y_4109, 114.0), 40.0])
			J.mc(v_gr_4112, "addColorStop", [0.0, "rgba(255,240,180,0.25)"])
			J.mc(v_gr_4112, "addColorStop", [1.0, "rgba(255,240,180,0)"])
			var _t4617 = env["ctx"]
			J.sp(_t4617, "fillStyle", v_gr_4112)
			J.mc(env["ctx"], "fillRect", [J.sub(J.gp(v_n_4107, "x"), 40.0), J.sub(v_y_4109, 150.0), 80.0, 80.0])

func _f690(this_, a: Array, env):
	var v_e_4115 = null; var v_x_4116 = null; var v_y_4117 = null
	v_e_4115 = J.arg(a, 0)
	if (not J.t(J.gp(v_e_4115, "fire"))):
		return null
	v_x_4116 = J.gp(J.gp(v_e_4115, "fire"), "x")
	var _t4619 = env["fy"]
	v_y_4117 = J.cl(_t4619, null, [J.gp(J.gp(v_e_4115, "fire"), "f")])
	if J.cmp(J.gp(J.gp(v_e_4115, "fire"), "shut"), 0.0, ">"):
		var _t4620 = env["ctx"]
		J.sp(_t4620, "fillStyle", "#6a1e1a")
		J.mc(env["ctx"], "fillRect", [J.sub(v_x_4116, 6.0), J.sub(v_y_4117, 70.0), 12.0, 66.0])
		var _t4621 = env["ctx"]
		J.sp(_t4621, "strokeStyle", "#ffd54a")
		var _t4622 = env["ctx"]
		J.sp(_t4622, "lineWidth", 1.5)
		J.mc(env["ctx"], "strokeRect", [J.sub(v_x_4116, 6.0), J.sub(v_y_4117, 70.0), 12.0, 66.0])
		var _t4623 = env["ctx"]
		J.sp(_t4623, "fillStyle", "#e8e2d0")
		var _t4624 = env["ctx"]
		var _t4625 = J.add("9px ", env["FONT"])
		J.sp(_t4624, "font", _t4625)
		var _t4626 = env["ctx"]
		J.sp(_t4626, "textAlign", "center")
		J.mc(env["ctx"], "fillText", [ceil(J.num(J.gp(J.gp(v_e_4115, "fire"), "shut"))), v_x_4116, J.sub(v_y_4117, 74.0)])
	else:
		var _t4627 = env["ctx"]
		J.sp(_t4627, "strokeStyle", "rgba(160,60,50,0.5)")
		var _t4628 = env["ctx"]
		J.sp(_t4628, "lineWidth", 1.0)
		J.mc(env["ctx"], "strokeRect", [J.sub(v_x_4116, 6.0), J.sub(v_y_4117, 70.0), 12.0, 66.0])

func _f691(this_, a: Array, env):
	var v_z_4120 = null; var v_i_4121 = null
	v_z_4120 = J.arg(a, 0)
	var _t4640 = J.sub(J.gp(v_z_4120, "t"), 0.033)
	J.sp(v_z_4120, "t", _t4640)
	var _t4641 = env["ctx"]
	var _t4642 = (J.add("rgba(255,213,74,", J.max_([0.0, J.gp(v_z_4120, "t")])) + ")")
	J.sp(_t4641, "strokeStyle", _t4642)
	var _t4643 = env["ctx"]
	J.sp(_t4643, "lineWidth", 2.0)
	v_i_4121 = 0.0
	while true:
		if not J.cmp(v_i_4121, J.gp(v_z_4120, "lvl"), "<"): break
		J.mc(env["ctx"], "beginPath", [])
		J.mc(env["ctx"], "arc", [J.gp(v_z_4120, "x"), J.gp(v_z_4120, "y"), ((J.sub(1.2, J.gp(v_z_4120, "t")) * 90.0) + J.mul(v_i_4121, 16.0)), 0.0, 7.0])
		J.mc(env["ctx"], "stroke", [])
		v_i_4121 = J.num(v_i_4121) + 1.0

func _f692(this_, a: Array, env):
	var v_z_4124 = null
	v_z_4124 = J.arg(a, 0)
	return J.cmp(J.gp(v_z_4124, "t"), 0.0, ">")

func _f693(this_, a: Array, env):
	var v_q_4127 = null; var v_u_4128 = null
	v_q_4127 = J.arg(a, 0)
	var _t4650 = J.seq(J.gp(v_q_4127, "id"), "lost")
	if (J.cmp(J.gp(v_q_4127, "state"), 2.0, "<") if _t4650 else _t4650):
		v_u_4128 = J.gp(v_q_4127, "owner")
		var _t4651 = J.gp(v_u_4128, "seen")
		if J.t((_t4651 if J.t(_t4651) else J.gp(v_u_4128, "entered"))):
			var _t4652 = env["txt"]
			J.cl(_t4652, null, [(J.add("交還", J.gp(v_q_4127, "thing")) if J.seq(J.gp(v_q_4127, "state"), 1.0) else "？"), J.div(J.add(J.gp(J.gp(v_u_4128, "rx"), 0.0), J.gp(J.gp(v_u_4128, "rx"), 1.0)), 2.0), J.sub(J.gp(v_u_4128, "y"), 112.0), "#8affc8", 13.0])
		var _t4654 = J.seq(J.gp(v_q_4127, "state"), 0.0)
		if J.t(_t4654):
			var _t4653 = J.gp(J.gp(v_q_4127, "hid"), "seen")
			_t4654 = (_t4653 if J.t(_t4653) else J.gp(J.gp(v_q_4127, "hid"), "entered"))
		if J.t(_t4654):
			var _t4655 = env["txt"]
			J.cl(_t4655, null, [J.add("✦", J.gp(v_q_4127, "thing")), J.div(J.add(J.gp(J.gp(J.gp(v_q_4127, "hid"), "rx"), 0.0), J.gp(J.gp(J.gp(v_q_4127, "hid"), "rx"), 1.0)), 2.0), J.sub(J.gp(J.gp(v_q_4127, "hid"), "y"), 100.0), "#8affc8", 11.0])

func _f686(this_, a: Array, env):
	var v_NATP_4090 = null; var v_ln_4091 = null
	var _t4546 = J.gp(J.G.get("window"), "__twNat")
	if J.t(_t4546):
		var _t4545 = J.G.get("__nat_twProps")
		_t4546 = J.cl(_t4545, null, [env["ctx"], env["G"], env["CULL"], env["FYS"]])
	v_NATP_4090 = _t4546
	if (not J.t(v_NATP_4090)):
		var _t4547 = J.gp(env["G"], "units")
		J.mc(_t4547, "forEach", [Callable(self, "_f687").bind(env)])
	if (not J.t(v_NATP_4090)):
		var _t4608 = J.gp(env["G"], "cprops")
		var _t4609 = (_t4608 if J.t(_t4608) else [])
		J.mc(_t4609, "forEach", [Callable(self, "_f689").bind(env)])
	if (not J.t(v_NATP_4090)):
		var _t4618 = J.gp(env["G"], "edges")
		J.mc(_t4618, "forEach", [Callable(self, "_f690").bind(env)])
	var _t4629 = J.gp(env["G"], "liftFx")
	if J.t((J.cmp(J.gp(J.gp(env["G"], "liftFx"), "t"), 0.0, ">") if J.t(_t4629) else _t4629)):
		v_ln_4091 = J.gp(J.gp(env["G"], "nodes"), (J.add("f", J.gp(J.gp(env["G"], "liftFx"), "f")) + "_l"))
		var _t4630 = J.gp(env["G"], "liftFx")
		var _t4631 = J.sub(J.gp(_t4630, "t"), 0.033)
		J.sp(_t4630, "t", _t4631)
		var _t4632 = env["ctx"]
		var _t4633 = (J.add("rgba(255,230,140,", (0.5 + (0.4 * sin(J.num(J.mul(J.gp(env["G"], "t"), 20.0)))))) + ")")
		J.sp(_t4632, "fillStyle", _t4633)
		J.mc(env["ctx"], "fillRect", [J.sub(J.gp(v_ln_4091, "x"), 14.0), J.sub(J.gp(v_ln_4091, "y"), 80.0), 28.0, 74.0])
		var _t4634 = env["ctx"]
		J.sp(_t4634, "fillStyle", "#000")
		var _t4635 = env["ctx"]
		var _t4636 = J.add("bold 14px ", env["FONT"])
		J.sp(_t4635, "font", _t4636)
		var _t4637 = env["ctx"]
		J.sp(_t4637, "textAlign", "center")
		J.mc(env["ctx"], "fillText", ["叮！", J.gp(v_ln_4091, "x"), J.sub(J.gp(v_ln_4091, "y"), 86.0)])
	var _t4638 = J.gp(env["G"], "noiseFx")
	var _t4639 = (_t4638 if J.t(_t4638) else [])
	J.mc(_t4639, "forEach", [Callable(self, "_f691").bind(env)])
	var _t4644 = env["G"]
	var _t4645 = J.gp(env["G"], "noiseFx")
	var _t4646 = (_t4645 if J.t(_t4645) else [])
	var _t4647 = J.mc(_t4646, "filter", [Callable(self, "_f692").bind(env)])
	J.sp(_t4644, "noiseFx", _t4647)
	var _t4648 = J.gp(env["G"], "quests")
	var _t4649 = (_t4648 if J.t(_t4648) else [])
	J.mc(_t4649, "forEach", [Callable(self, "_f693").bind(env)])

func _f695(this_, a: Array, env):
	var v_q_4136 = null
	v_q_4136 = J.arg(a, 0)
	return J.seq(J.gp(v_q_4136, "id"), "mini")

func _f694(this_, a: Array, env):
	var v_b_4131 = null; var v_wx_4132 = null; var v_wy_4133 = null
	v_b_4131 = J.mc(env["buttons"], "find", [Callable(self, "_f695").bind(env)])
	var _t4656 = (not J.t(v_b_4131))
	if (_t4656 if _t4656 else (not J.t(env["LASTP"]))):
		return null
	v_wx_4132 = J.mul(J.div(J.sub(J.gp(env["LASTP"], "x"), J.gp(v_b_4131, "x")), J.gp(v_b_4131, "w")), env["WW"])
	v_wy_4133 = J.mul(J.div(J.sub(J.gp(env["LASTP"], "y"), J.gp(v_b_4131, "y")), J.gp(v_b_4131, "h")), env["WH"])
	var _t4657 = env["cam"]
	var _t4658 = env["clamp"]
	var _t4660 = J.cl(_t4658, null, [v_wx_4132, 0.0, env["WW"]])
	var _t4659 = env["clamp"]
	var _t4661 = {"x": _t4660, "y": J.cl(_t4659, null, [v_wy_4133, 0.0, env["WH"]])}
	J.sp(_t4657, "free", _t4661)

func _f697(this_, a: Array, env):
	var v_u_4148 = null; var v_top_4149 = null
	v_u_4148 = J.arg(a, 0)
	var _t4666 = env["__p"]["fy"]
	v_top_4149 = J.add(J.cl(_t4666, null, [J.add(J.gp(v_u_4148, "f"), 1.0)]), 16.0)
	var _t4667 = env["__p"]["ctx"]
	var _t4670 = null
	if J.seq(J.gp(v_u_4148, "ot"), "deity"):
		_t4670 = "#5a2420"
	else:
		var _t4669 = null
		if (not J.t(J.gp(v_u_4148, "open"))):
			_t4669 = "#2a2430"
		else:
			var _t4668 = J.gp(v_u_4148, "seen")
			_t4669 = ("#3a4632" if J.t((_t4668 if J.t(_t4668) else J.gp(v_u_4148, "entered"))) else "#1c1820")
		_t4670 = _t4669
	J.sp(_t4667, "fillStyle", _t4670)
	J.mc(env["__p"]["ctx"], "fillRect", [J.add(J.add(env["mx"], J.mul(J.gp(J.gp(v_u_4148, "rx"), 0.0), env["sx"])), 0.5), J.add(env["my"], J.mul(v_top_4149, env["sy"])), (J.mul(J.sub(J.gp(J.gp(v_u_4148, "rx"), 1.0), J.gp(J.gp(v_u_4148, "rx"), 0.0)), env["sx"]) - 1.0), J.mul(J.sub(J.gp(v_u_4148, "y"), v_top_4149), env["sy"])])

func _f698(this_, a: Array, env):
	var v_id_4152 = null; var v_n_4153 = null
	v_id_4152 = J.arg(a, 0)
	v_n_4153 = J.gp(J.gp(env["__p"]["G"], "nodes"), v_id_4152)
	J.mc(env["__p"]["ctx"], "fillRect", [J.sub(J.add(env["mx"], J.mul(J.gp(v_n_4153, "x"), env["sx"])), 2.0), J.sub(J.add(env["my"], J.mul(J.gp(v_n_4153, "y"), env["sy"])), 3.0), 4.0, 3.0])

func _f699(this_, a: Array, env):
	var v_h_4156 = null
	v_h_4156 = J.arg(a, 0)
	if J.seq(J.gp(v_h_4156, "state"), "gone"):
		return null
	var _t4674 = env["__p"]["ctx"]
	var _t4675 = ("#d87e3c" if J.seq(J.gp(v_h_4156, "kind"), "collector") else ("#e0483a" if J.seq(J.gp(v_h_4156, "state"), "chase") else "#b8786a"))
	J.sp(_t4674, "fillStyle", _t4675)
	J.mc(env["__p"]["ctx"], "fillRect", [J.sub(J.add(env["mx"], J.mul(J.gp(v_h_4156, "x"), env["sx"])), 1.5), J.sub(J.add(env["my"], J.mul(J.gp(v_h_4156, "y"), env["sy"])), 3.0), 3.0, 3.0])

func _f700(this_, a: Array, env):
	var v_g_4159 = null; var v_i_4160 = null
	v_g_4159 = J.arg(a, 0)
	v_i_4160 = J.arg(a, 1)
	var _t4677 = J.gp(v_g_4159, "home")
	if J.t((_t4677 if J.t(_t4677) else J.gp(v_g_4159, "out"))):
		return null
	var _t4678 = env["__p"]["ctx"]
	var _t4679 = ("#efe5cf" if J.seq(v_i_4160, J.gp(env["__p"]["G"], "active")) else "#9c88cc")
	J.sp(_t4678, "fillStyle", _t4679)
	J.mc(env["__p"]["ctx"], "beginPath", [])
	J.mc(env["__p"]["ctx"], "arc", [J.add(env["mx"], J.mul(J.gp(v_g_4159, "x"), env["sx"])), J.sub(J.add(env["my"], J.mul(J.gp(v_g_4159, "y"), env["sy"])), 2.0), (3.0 if J.seq(v_i_4160, J.gp(env["__p"]["G"], "active")) else 2.0), 0.0, 7.0])
	J.mc(env["__p"]["ctx"], "fill", [])

func _f696(this_, a: Array, env):
	var v_mw_4139 = null; var v_mh_4140 = null; var v_S_4145 = null
	var _s1710 = {"__p": env, "mx": null, "my": null, "sx": null, "sy": null}
	v_mw_4139 = 74.0
	v_mh_4140 = J.min_([110.0, J.round(J.num(J.div(J.mul(74.0, _s1710["__p"]["WH"]), _s1710["__p"]["WW"])))])
	_s1710["mx"] = 10.0
	_s1710["my"] = J.add(_s1710["__p"]["TOP"], 60.0)
	_s1710["sx"] = J.div(v_mw_4139, _s1710["__p"]["WW"])
	_s1710["sy"] = J.div(v_mh_4140, _s1710["__p"]["WH"])
	J.mc(_s1710["__p"]["buttons"], "push", [{"id": "mini", "x": _s1710["mx"], "y": _s1710["my"], "w": v_mw_4139, "h": v_mh_4140}])
	var _t4662 = _s1710["__p"]["crPanel"]
	J.cl(_t4662, null, [_s1710["__p"]["ctx"], J.sub(_s1710["mx"], 5.0), J.sub(_s1710["my"], 5.0), J.add(v_mw_4139, 10.0), J.add(v_mh_4140, 10.0), "ink"])
	var _t4664 = J.gp(J.G.get("window"), "__twNat")
	if J.t(_t4664):
		var _t4663 = J.G.get("__nat_twMini")
		_t4664 = J.cl(_t4663, null, [_s1710["__p"]["ctx"], _s1710["__p"]["G"], _s1710["__p"]["FYS"], _s1710["mx"], _s1710["my"], v_mw_4139, v_mh_4140, _s1710["__p"]["WW"], _s1710["__p"]["WH"], J.gp(_s1710["__p"]["cam"], "x"), J.gp(_s1710["__p"]["cam"], "y"), J.div(_s1710["__p"]["VW"], J.mul(J.gp(_s1710["__p"]["cam"], "s"), J.gp(_s1710["__p"]["cam"], "z"))), J.div(J.sub(J.sub(_s1710["__p"]["VH"], _s1710["__p"]["TOP"]), _s1710["__p"]["BOT"]), J.mul(J.gp(_s1710["__p"]["cam"], "s"), J.gp(_s1710["__p"]["cam"], "z"))), _s1710["__p"]["FL"]])
	if J.t(_t4664):
		return null
	var _t4665 = J.gp(_s1710["__p"]["G"], "units")
	J.mc(_t4665, "forEach", [Callable(self, "_f697").bind(_s1710)])
	var _t4671 = _s1710["__p"]["ctx"]
	J.sp(_t4671, "fillStyle", "#8aac6c")
	var _t4672 = ["f0_e", (J.add("f", _s1710["__p"]["FL"]) + "_p")]
	J.mc(_t4672, "forEach", [Callable(self, "_f698").bind(_s1710)])
	var _t4673 = J.gp(_s1710["__p"]["G"], "guards")
	J.mc(_t4673, "forEach", [Callable(self, "_f699").bind(_s1710)])
	var _t4676 = J.gp(_s1710["__p"]["G"], "gh")
	J.mc(_t4676, "forEach", [Callable(self, "_f700").bind(_s1710)])
	v_S_4145 = J.mul(J.gp(_s1710["__p"]["cam"], "s"), J.gp(_s1710["__p"]["cam"], "z"))
	var _t4680 = _s1710["__p"]["ctx"]
	J.sp(_t4680, "strokeStyle", "rgba(216,204,176,0.6)")
	var _t4681 = _s1710["__p"]["ctx"]
	J.sp(_t4681, "lineWidth", 1.2)
	J.mc(_s1710["__p"]["ctx"], "strokeRect", [J.add(_s1710["mx"], J.mul(J.gp(_s1710["__p"]["cam"], "x"), _s1710["sx"])), J.add(_s1710["my"], J.mul(J.gp(_s1710["__p"]["cam"], "y"), _s1710["sy"])), J.mul(J.div(_s1710["__p"]["VW"], v_S_4145), _s1710["sx"]), J.mul(J.div(J.sub(J.sub(_s1710["__p"]["VH"], _s1710["__p"]["TOP"]), _s1710["__p"]["BOT"]), v_S_4145), _s1710["sy"])])

func _f701(this_, a: Array, env):
	var v_NT_4163 = null
	v_NT_4163 = J.gp(J.G.get("window"), "__twNat")
	var _t4682 = (J.gp(v_NT_4163, "w") if J.t(v_NT_4163) else J.min_([J.gp(J.G.get("window"), "innerWidth"), 520.0]))
	env["VW"] = _t4682
	var _t4683 = (J.gp(v_NT_4163, "h") if J.t(v_NT_4163) else J.gp(J.G.get("window"), "innerHeight"))
	env["VH"] = _t4683
	if J.t(v_NT_4163):
		env["DPR"] = J.gp(v_NT_4163, "s")
	var _t4684 = J.gp(env["cv"], "style")
	var _t4685 = J.add(env["VW"], "px")
	J.sp(_t4684, "width", _t4685)
	var _t4686 = J.gp(env["cv"], "style")
	var _t4687 = J.add(env["VH"], "px")
	J.sp(_t4686, "height", _t4687)
	var _t4688 = env["cv"]
	var _t4689 = J.round(J.num(J.mul(env["VW"], env["DPR"])))
	J.sp(_t4688, "width", _t4689)
	var _t4690 = env["cv"]
	var _t4691 = J.round(J.num(J.mul(env["VH"], env["DPR"])))
	J.sp(_t4690, "height", _t4691)
	var _t4692 = env["cam"]
	var _t4694 = env["VW"]
	var _t4693 = (J.gp(env["LV"], "camW") if J.t(env["LV"]) else env["LV"])
	var _t4695 = J.div(_t4694, (_t4693 if J.t(_t4693) else 600.0))
	J.sp(_t4692, "s", _t4695)
	var _t4696 = J.div(env["VW"], env["WW"])
	env["BOTX"] = _t4696

func _f702(this_, a: Array, env):
	var v_c2_4166 = null; var v_x_4167 = null; var v_y_4168 = null; var v_w_4169 = null; var v_h_4170 = null; var v_col_4171 = null; var v_dens_4172 = null; var v_n_4173 = null; var v_i_4174 = null; var v_px_4175 = null; var v_py_4176 = null; var v_L_4177 = null
	v_c2_4166 = J.arg(a, 0)
	v_x_4167 = J.arg(a, 1)
	v_y_4168 = J.arg(a, 2)
	v_w_4169 = J.arg(a, 3)
	v_h_4170 = J.arg(a, 4)
	v_col_4171 = J.arg(a, 5)
	v_dens_4172 = J.arg(a, 6)
	J.sp(v_c2_4166, "fillStyle", v_col_4171)
	J.mc(v_c2_4166, "fillRect", [v_x_4167, v_y_4168, v_w_4169, v_h_4170])
	J.mc(v_c2_4166, "save", [])
	J.mc(v_c2_4166, "beginPath", [])
	J.mc(v_c2_4166, "rect", [v_x_4167, v_y_4168, v_w_4169, v_h_4170])
	J.mc(v_c2_4166, "clip", [])
	J.sp(v_c2_4166, "globalAlpha", 0.16)
	J.sp(v_c2_4166, "strokeStyle", "#000")
	J.sp(v_c2_4166, "lineWidth", 1.0)
	v_n_4173 = floor(J.num(J.div(J.mul(v_w_4169, v_h_4170), (v_dens_4172 if J.t(v_dens_4172) else 140.0))))
	v_i_4174 = 0.0
	while true:
		if not J.cmp(v_i_4174, v_n_4173, "<"): break
		v_px_4175 = J.add(v_x_4167, J.mul(randf(), v_w_4169))
		v_py_4176 = J.add(v_y_4168, J.mul(randf(), v_h_4170))
		v_L_4177 = (4.0 + (randf() * 9.0))
		J.mc(v_c2_4166, "beginPath", [])
		J.mc(v_c2_4166, "moveTo", [v_px_4175, v_py_4176])
		J.mc(v_c2_4166, "lineTo", [J.add(v_px_4175, v_L_4177), J.sub(v_py_4176, J.mul(v_L_4177, 0.35))])
		J.mc(v_c2_4166, "stroke", [])
		v_i_4174 = J.num(v_i_4174) + 1.0
	J.sp(v_c2_4166, "globalAlpha", 0.1)
	J.sp(v_c2_4166, "strokeStyle", "#fff")
	v_i_4174 = 0.0
	while true:
		if not J.cmp(v_i_4174, J.div(v_n_4173, 2.0), "<"): break
		v_px_4175 = J.add(v_x_4167, J.mul(randf(), v_w_4169))
		v_py_4176 = J.add(v_y_4168, J.mul(randf(), v_h_4170))
		J.mc(v_c2_4166, "beginPath", [])
		J.mc(v_c2_4166, "moveTo", [v_px_4175, v_py_4176])
		J.mc(v_c2_4166, "lineTo", [J.add(v_px_4175, 5.0), J.sub(v_py_4176, 2.0)])
		J.mc(v_c2_4166, "stroke", [])
		v_i_4174 = J.num(v_i_4174) + 1.0
	J.mc(v_c2_4166, "restore", [])

func _f703(this_, a: Array, env):
	var v_c_4180 = null; var v_bgi_4181 = null
	if J.t(J.gp(env["LV"], "B")):
		J.cl(env["bake2"], null, [])
		return null
	var _t4697 = J.S_document_("createElement", ["canvas"])
	env["staticCv"] = _t4697
	var _t4698 = env["staticCv"]
	var _t4699 = J.mul(env["WW"], 2.0)
	J.sp(_t4698, "width", _t4699)
	var _t4700 = env["staticCv"]
	var _t4701 = J.mul(env["WH"], 2.0)
	J.sp(_t4700, "height", _t4701)
	v_c_4180 = J.mc(env["staticCv"], "getContext", ["2d"])
	v_bgi_4181 = J.gp(env["IMG"], J.gp(env["LV"], "bg"))
	if J.t((J.gp(v_bgi_4181, "width") if J.t(v_bgi_4181) else v_bgi_4181)):
		J.mc(v_c_4180, "drawImage", [v_bgi_4181, 0.0, 0.0, J.mul(env["WW"], 2.0), J.mul(env["WH"], 2.0)])
	else:
		J.sp(v_c_4180, "fillStyle", "#1a1a1e")
		J.mc(v_c_4180, "fillRect", [0.0, 0.0, J.mul(env["WW"], 2.0), J.mul(env["WH"], 2.0)])

func _f704(this_, a: Array, env):
	var v_x_4184 = null; var v_y_4185 = null; var v_S_4186 = null
	v_x_4184 = J.arg(a, 0)
	v_y_4185 = J.arg(a, 1)
	v_S_4186 = J.mul(J.gp(env["cam"], "s"), J.gp(env["cam"], "z"))
	return {"x": J.mul(J.sub(v_x_4184, J.gp(env["cam"], "x")), v_S_4186), "y": J.add(J.mul(J.sub(v_y_4185, J.gp(env["cam"], "y")), v_S_4186), env["TOP"])}

func _f705(this_, a: Array, env):
	var v_k_4189 = null; var v_x_4190 = null; var v_y_4191 = null; var v_h_4192 = null; var v_o_4193 = null; var v_im_4194 = null; var v_w_4195 = null
	v_k_4189 = J.arg(a, 0)
	v_x_4190 = J.arg(a, 1)
	v_y_4191 = J.arg(a, 2)
	v_h_4192 = J.arg(a, 3)
	v_o_4193 = J.arg(a, 4)
	v_im_4194 = J.gp(env["IMG"], v_k_4189)
	var _t4702 = (not J.t(v_im_4194))
	if (_t4702 if _t4702 else (not J.t(J.gp(v_im_4194, "width")))):
		return null
	v_w_4195 = J.div(J.mul(v_h_4192, J.gp(v_im_4194, "width")), J.gp(v_im_4194, "height"))
	var _t4703 = (v_o_4193 if J.t(v_o_4193) else {})
	v_o_4193 = _t4703
	J.mc(env["ctx"], "save", [])
	var _t4704 = env["ctx"]
	var _t4705 = (1.0 if J.leq(J.gp(v_o_4193, "alpha"), null) else J.gp(v_o_4193, "alpha"))
	J.sp(_t4704, "globalAlpha", _t4705)
	var _t4706 = J.gp(v_o_4193, "ox")
	var _t4708 = J.add(v_x_4190, (_t4706 if J.t(_t4706) else 0.0))
	var _t4707 = J.gp(v_o_4193, "oy")
	J.mc(env["ctx"], "translate", [_t4708, J.add(v_y_4191, (_t4707 if J.t(_t4707) else 0.0))])
	if J.t(J.gp(v_o_4193, "rot")):
		J.mc(env["ctx"], "rotate", [J.gp(v_o_4193, "rot")])
	var _t4710 = ((-1.0) if J.t(J.gp(v_o_4193, "flip")) else 1.0)
	var _t4709 = J.gp(v_o_4193, "sx")
	var _t4712 = J.mul(_t4710, (_t4709 if J.t(_t4709) else 1.0))
	var _t4711 = J.gp(v_o_4193, "sy")
	J.mc(env["ctx"], "scale", [_t4712, (_t4711 if J.t(_t4711) else 1.0)])
	J.mc(env["ctx"], "drawImage", [v_im_4194, J.div((-J.num(v_w_4195)), 2.0), (-J.num(v_h_4192)), v_w_4195, v_h_4192])
	J.mc(env["ctx"], "restore", [])

func _f706(this_, a: Array, env):
	var v_k_4198 = null; var v_x_4199 = null; var v_y_4200 = null; var v_h_4201 = null; var v_flip_4202 = null; var v_alpha_4203 = null; var v_im_4204 = null; var v_w_4205 = null
	v_k_4198 = J.arg(a, 0)
	v_x_4199 = J.arg(a, 1)
	v_y_4200 = J.arg(a, 2)
	v_h_4201 = J.arg(a, 3)
	v_flip_4202 = J.arg(a, 4)
	v_alpha_4203 = J.arg(a, 5)
	v_im_4204 = J.gp(env["IMG"], v_k_4198)
	var _t4713 = (not J.t(v_im_4204))
	if (_t4713 if _t4713 else (not J.t(J.gp(v_im_4204, "width")))):
		return null
	v_w_4205 = J.div(J.mul(v_h_4201, J.gp(v_im_4204, "width")), J.gp(v_im_4204, "height"))
	var _t4714 = env["ctx"]
	var _t4715 = (1.0 if J.leq(v_alpha_4203, null) else v_alpha_4203)
	J.sp(_t4714, "globalAlpha", _t4715)
	if J.t(v_flip_4202):
		J.mc(env["ctx"], "save", [])
		J.mc(env["ctx"], "translate", [v_x_4199, 0.0])
		J.mc(env["ctx"], "scale", [(-1.0), 1.0])
		J.mc(env["ctx"], "drawImage", [v_im_4204, J.div((-J.num(v_w_4205)), 2.0), J.sub(v_y_4200, v_h_4201), v_w_4205, v_h_4201])
		J.mc(env["ctx"], "restore", [])
	else:
		J.mc(env["ctx"], "drawImage", [v_im_4204, J.sub(v_x_4199, J.div(v_w_4205, 2.0)), J.sub(v_y_4200, v_h_4201), v_w_4205, v_h_4201])
	var _t4716 = env["ctx"]
	J.sp(_t4716, "globalAlpha", 1.0)

func _f707(this_, a: Array, env):
	var v_e_4208 = null; var v_n_4209 = null; var v_x_4210 = null; var v_y_4211 = null; var v_w_4212 = null; var v_k_4213 = null
	v_e_4208 = J.arg(a, 0)
	v_n_4209 = (J.gp(J.gp(env["G"], "nodes"), J.gp(v_e_4208, "a")) if J.seq(J.gp(J.gp(J.gp(env["G"], "nodes"), J.gp(v_e_4208, "a")), "kind"), "door") else J.gp(J.gp(env["G"], "nodes"), J.gp(v_e_4208, "b")))
	v_x_4210 = J.gp(v_n_4209, "x")
	v_y_4211 = J.gp(v_n_4209, "y")
	v_w_4212 = J.gp(v_e_4208, "ward")
	if (not J.t(v_w_4212)):
		return null
	var _t4717 = J.cmp(v_y_4211, J.gp(env["CULL"], "y0"), "<")
	if (_t4717 if _t4717 else J.cmp(J.sub(v_y_4211, 100.0), J.gp(env["CULL"], "y1"), ">")):
		return null
	if J.seq(v_w_4212, "fu"):
		var _t4718 = env["ctx"]
		J.sp(_t4718, "fillStyle", "#d42a2a")
		J.mc(env["ctx"], "fillRect", [J.sub(v_x_4210, 6.0), J.sub(v_y_4211, 92.0), 12.0, 16.0])
		var _t4719 = env["ctx"]
		J.sp(_t4719, "strokeStyle", "#ffd54a")
		var _t4720 = env["ctx"]
		J.sp(_t4720, "lineWidth", 1.5)
		J.mc(env["ctx"], "strokeRect", [J.sub(v_x_4210, 6.0), J.sub(v_y_4211, 92.0), 12.0, 16.0])
	if J.seq(v_w_4212, "menshen"):
		var _t4721 = env["ctx"]
		J.sp(_t4721, "fillStyle", "#b7302a")
		J.mc(env["ctx"], "fillRect", [J.sub(v_x_4210, 14.0), J.sub(v_y_4211, 70.0), 13.0, 46.0])
		J.mc(env["ctx"], "fillRect", [J.add(v_x_4210, 1.0), J.sub(v_y_4211, 70.0), 13.0, 46.0])
		var _t4722 = env["ctx"]
		J.sp(_t4722, "strokeStyle", "#ffd54a")
		var _t4723 = env["ctx"]
		J.sp(_t4723, "lineWidth", 2.0)
		J.mc(env["ctx"], "strokeRect", [J.sub(v_x_4210, 14.0), J.sub(v_y_4211, 70.0), 13.0, 46.0])
		J.mc(env["ctx"], "strokeRect", [J.add(v_x_4210, 1.0), J.sub(v_y_4211, 70.0), 13.0, 46.0])
		var _t4724 = env["ctx"]
		J.sp(_t4724, "fillStyle", "#ffd54a")
		J.mc(env["ctx"], "beginPath", [])
		J.mc(env["ctx"], "arc", [J.sub(v_x_4210, 7.5), J.sub(v_y_4211, 56.0), 4.0, 0.0, 7.0])
		J.mc(env["ctx"], "arc", [J.add(v_x_4210, 7.5), J.sub(v_y_4211, 56.0), 4.0, 0.0, 7.0])
		J.mc(env["ctx"], "fill", [])
	if J.seq(v_w_4212, "zha"):
		var _t4725 = env["ctx"]
		J.sp(_t4725, "fillStyle", "#c8ccd8")
		J.mc(env["ctx"], "fillRect", [J.add(v_x_4210, 8.0), J.sub(v_y_4211, 44.0), 8.0, 6.0])
		var _t4726 = env["ctx"]
		J.sp(_t4726, "strokeStyle", "#2a2030")
		var _t4727 = env["ctx"]
		J.sp(_t4727, "lineWidth", 1.0)
		J.mc(env["ctx"], "strokeRect", [J.add(v_x_4210, 8.0), J.sub(v_y_4211, 44.0), 8.0, 6.0])
		J.mc(env["ctx"], "beginPath", [])
		J.mc(env["ctx"], "arc", [J.add(v_x_4210, 12.0), J.sub(v_y_4211, 46.0), 3.0, PI, 0.0])
		J.mc(env["ctx"], "stroke", [])
	if J.seq(v_w_4212, "nuomi"):
		var _t4728 = env["ctx"]
		J.sp(_t4728, "fillStyle", "#fffbe8")
		v_k_4213 = 0.0
		while true:
			if not J.cmp(v_k_4213, 20.0, "<"): break
			J.mc(env["ctx"], "fillRect", [(J.sub(v_x_4210, 24.0) + J.mul(v_k_4213, 2.5)), (J.sub(v_y_4211, 6.0) + (J.mod(v_k_4213, 3.0) * 1.5)), 2.0, 2.0])
			v_k_4213 = J.num(v_k_4213) + 1.0
	if J.seq(v_w_4212, "datuk"):
		var _t4729 = env["ctx"]
		var _t4730 = (0.3 + (0.15 * sin(J.num(J.mul(J.gp(env["G"], "t"), 3.0)))))
		J.sp(_t4729, "globalAlpha", _t4730)
		var _t4731 = env["ctx"]
		J.sp(_t4731, "fillStyle", "#ffcc66")
		J.mc(env["ctx"], "beginPath", [])
		J.mc(env["ctx"], "arc", [J.add(v_x_4210, 22.0), J.sub(v_y_4211, 14.0), 14.0, 0.0, 7.0])
		J.mc(env["ctx"], "fill", [])
		var _t4732 = env["ctx"]
		J.sp(_t4732, "globalAlpha", 1.0)
		var _t4733 = env["ctx"]
		J.sp(_t4733, "fillStyle", "#c4202a")
		J.mc(env["ctx"], "fillRect", [J.add(v_x_4210, 13.0), J.sub(v_y_4211, 24.0), 18.0, 20.0])
		var _t4734 = env["ctx"]
		J.sp(_t4734, "strokeStyle", "#ffd54a")
		var _t4735 = env["ctx"]
		J.sp(_t4735, "lineWidth", 1.5)
		J.mc(env["ctx"], "strokeRect", [J.add(v_x_4210, 13.0), J.sub(v_y_4211, 24.0), 18.0, 20.0])
		var _t4736 = env["ctx"]
		J.sp(_t4736, "fillStyle", "#ffd54a")
		J.mc(env["ctx"], "fillRect", [J.add(v_x_4210, 16.0), J.sub(v_y_4211, 20.0), 12.0, 3.0])

func _f708(this_, a: Array, env):
	var v_x_4216 = null; var v_y_4217 = null; var v_t_4218 = null; var v_col_4219 = null
	v_x_4216 = J.arg(a, 0)
	v_y_4217 = J.arg(a, 1)
	v_t_4218 = J.arg(a, 2)
	v_col_4219 = J.arg(a, 3)
	var _t4737 = env["crBubble"]
	J.cl(_t4737, null, [v_x_4216, v_y_4217, v_t_4218, v_col_4219])

func _f709(this_, a: Array, env):
	var v_x_4222 = null; var v_y_4223 = null; var v_w_4224 = null; var v_h_4225 = null; var v_r_4226 = null
	v_x_4222 = J.arg(a, 0)
	v_y_4223 = J.arg(a, 1)
	v_w_4224 = J.arg(a, 2)
	v_h_4225 = J.arg(a, 3)
	v_r_4226 = J.arg(a, 4)
	J.mc(env["ctx"], "beginPath", [])
	J.mc(env["ctx"], "moveTo", [J.add(v_x_4222, v_r_4226), v_y_4223])
	J.mc(env["ctx"], "arcTo", [J.add(v_x_4222, v_w_4224), v_y_4223, J.add(v_x_4222, v_w_4224), J.add(v_y_4223, v_h_4225), v_r_4226])
	J.mc(env["ctx"], "arcTo", [J.add(v_x_4222, v_w_4224), J.add(v_y_4223, v_h_4225), v_x_4222, J.add(v_y_4223, v_h_4225), v_r_4226])
	J.mc(env["ctx"], "arcTo", [v_x_4222, J.add(v_y_4223, v_h_4225), v_x_4222, v_y_4223, v_r_4226])
	J.mc(env["ctx"], "arcTo", [v_x_4222, v_y_4223, J.add(v_x_4222, v_w_4224), v_y_4223, v_r_4226])
	J.mc(env["ctx"], "closePath", [])

func _f710(this_, a: Array, env):
	var v_c_4229 = null; var v_k_4230 = null
	v_c_4229 = J.arg(a, 0)
	if (not J.seq(J.typeof_(v_c_4229), "string")):
		return v_c_4229
	v_k_4230 = J.mc(v_c_4229, "toLowerCase", [])
	if J.seq(v_k_4230, "#fff"):
		v_k_4230 = "#ffffff"
	var _t4738 = J.gp(env["CRC"], v_k_4230)
	return (_t4738 if J.t(_t4738) else v_c_4229)

func _f712(this_, a: Array, env):
	var _t4739 = J.mod(J.mul(env["s"], 16807.0), 2147483647.0)
	env["s"] = _t4739
	return J.div(J.sub(env["s"], 1.0), 2147483646.0)

func _f711(this_, a: Array, env):
	var v_seed_4233 = null
	var _s1739 = {"__p": env, "s": null}
	v_seed_4233 = J.arg(a, 0)
	_s1739["s"] = (J.mod(v_seed_4233, 2147483646.0) + 1.0)
	return Callable(self, "_f712").bind(_s1739)

func _f713(this_, a: Array, env):
	var v_str_4239 = null; var v_h_4240 = null; var v_i_4241 = null
	v_str_4239 = J.arg(a, 0)
	v_h_4240 = 2166136261.0
	v_i_4241 = 0.0
	while true:
		if not J.cmp(v_i_4241, J.len(v_str_4239), "<"): break
		var _t4740 = J.bxor(v_h_4240, J.mc(v_str_4239, "charCodeAt", [v_i_4241]))
		v_h_4240 = _t4740
		var _t4741 = J.math("imul", [v_h_4240, 16777619.0])
		v_h_4240 = _t4741
		v_i_4241 = J.num(v_i_4241) + 1.0
	return (J.mod(J.ushr(v_h_4240, 0.0), 2147483646.0) + 1.0)

func _f714(this_, a: Array, env):
	var v_c_4244 = null; var v_x_4245 = null; var v_r_4246 = null; var v_i_4247 = null; var v_v_4248 = null; var v_j_4249 = null; var v_px_4250 = null; var v_py_4251 = null
	if J.t(J.gp(env["CR"], "grain")):
		return J.gp(env["CR"], "grain")
	v_c_4244 = J.S_document_("createElement", ["canvas"])
	J.sp(v_c_4244, "height", 128.0)
	J.sp(v_c_4244, "width", 128.0)
	v_x_4245 = J.mc(v_c_4244, "getContext", ["2d"])
	var _t4742 = env["crRnd"]
	v_r_4246 = J.cl(_t4742, null, [99.0])
	v_i_4247 = 0.0
	while true:
		if not J.cmp(v_i_4247, 2600.0, "<"): break
		v_v_4248 = J.cl(v_r_4246, null, [])
		var _t4743 = ((J.add("rgba(0,0,0,", (0.1 + J.mul(J.cl(v_r_4246, null, []), 0.25))) + ")") if J.cmp(v_v_4248, 0.55, "<") else (J.add("rgba(255,240,220,", (0.03 + J.mul(J.cl(v_r_4246, null, []), 0.07))) + ")"))
		J.sp(v_x_4245, "fillStyle", _t4743)
		J.mc(v_x_4245, "fillRect", [J.mul(J.cl(v_r_4246, null, []), 128.0), J.mul(J.cl(v_r_4246, null, []), 128.0), (1.0 + J.mul(J.cl(v_r_4246, null, []), 1.6)), (1.0 + J.mul(J.cl(v_r_4246, null, []), 1.2))])
		v_i_4247 = J.num(v_i_4247) + 1.0
	J.sp(v_x_4245, "strokeStyle", "rgba(0,0,0,0.2)")
	J.sp(v_x_4245, "lineWidth", 0.7)
	v_j_4249 = 0.0
	while true:
		if not J.cmp(v_j_4249, 70.0, "<"): break
		v_px_4250 = J.mul(J.cl(v_r_4246, null, []), 128.0)
		v_py_4251 = J.mul(J.cl(v_r_4246, null, []), 128.0)
		J.mc(v_x_4245, "beginPath", [])
		J.mc(v_x_4245, "moveTo", [v_px_4250, v_py_4251])
		J.mc(v_x_4245, "lineTo", [J.add(J.add(v_px_4250, 4.0), J.mul(J.cl(v_r_4246, null, []), 10.0)), J.add(v_py_4251, (J.sub(J.cl(v_r_4246, null, []), 0.5) * 3.0))])
		J.mc(v_x_4245, "stroke", [])
		v_j_4249 = J.num(v_j_4249) + 1.0
	var _t4744 = env["CR"]
	J.sp(_t4744, "grain", v_c_4244)
	return v_c_4244

func _f716(this_, a: Array, env):
	var v_x0_4267 = null; var v_y0_4268 = null; var v_x1_4269 = null; var v_y1_4270 = null; var v_L_4271 = null; var v_n_4272 = null; var v_i_4273 = null; var v_t_4274 = null
	v_x0_4267 = J.arg(a, 0)
	v_y0_4268 = J.arg(a, 1)
	v_x1_4269 = J.arg(a, 2)
	v_y1_4270 = J.arg(a, 3)
	v_L_4271 = J.hypot_([J.sub(v_x1_4269, v_x0_4267), J.sub(v_y1_4270, v_y0_4268)])
	v_n_4272 = J.max_([2.0, J.round(J.num(J.div(v_L_4271, 16.0)))])
	v_i_4273 = 0.0
	while true:
		if not J.cmp(v_i_4273, v_n_4272, "<"): break
		v_t_4274 = J.div(v_i_4273, v_n_4272)
		J.mc(env["P"], "push", [[J.add(J.add(v_x0_4267, J.mul(J.sub(v_x1_4269, v_x0_4267), v_t_4274)), J.mul(J.sub(J.cl(env["r"], null, []), 0.5), env["j"])), J.add(J.add(v_y0_4268, J.mul(J.sub(v_y1_4270, v_y0_4268), v_t_4274)), J.mul(J.sub(J.cl(env["r"], null, []), 0.5), env["j"]))]])
		v_i_4273 = J.num(v_i_4273) + 1.0

func _f715(this_, a: Array, env):
	var v_w_4255 = null; var v_h_4256 = null; var v_ring_4258 = null; var v_R_4260 = null; var v_n_4261 = null; var v_i_4262 = null; var v_a_4263 = null; var v_seg_4264 = null
	var _s1749 = {"__p": env, "r": null, "j": null, "P": null}
	_s1749["r"] = J.arg(a, 0)
	v_w_4255 = J.arg(a, 1)
	v_h_4256 = J.arg(a, 2)
	_s1749["j"] = J.arg(a, 3)
	v_ring_4258 = J.arg(a, 4)
	v_seg_4264 = Callable(self, "_f716").bind(_s1749)
	_s1749["P"] = []
	if J.t(v_ring_4258):
		v_R_4260 = J.div(v_w_4255, 2.0)
		v_n_4261 = J.max_([18.0, J.round(J.num(J.mul(v_R_4260, 0.6)))])
		v_i_4262 = 0.0
		while true:
			if not J.cmp(v_i_4262, v_n_4261, "<"): break
			v_a_4263 = ((J.div(v_i_4262, v_n_4261) * PI) * 2.0)
			J.mc(_s1749["P"], "push", [[J.add(v_R_4260, J.mul(cos(J.num(v_a_4263)), J.add(v_R_4260, J.mul(J.sub(J.cl(_s1749["r"], null, []), 0.5), _s1749["j"])))), J.add(v_R_4260, J.mul(sin(J.num(v_a_4263)), J.add(v_R_4260, J.mul(J.sub(J.cl(_s1749["r"], null, []), 0.5), _s1749["j"]))))]])
			v_i_4262 = J.num(v_i_4262) + 1.0
		return _s1749["P"]
	J.cl(v_seg_4264, null, [0.0, 0.0, v_w_4255, 0.0])
	J.cl(v_seg_4264, null, [v_w_4255, 0.0, v_w_4255, v_h_4256])
	J.cl(v_seg_4264, null, [v_w_4255, v_h_4256, 0.0, v_h_4256])
	J.cl(v_seg_4264, null, [0.0, v_h_4256, 0.0, 0.0])
	return _s1749["P"]

func _f717(this_, a: Array, env):
	var v_c_4277 = null; var v_P_4278 = null; var v_i_4279 = null
	v_c_4277 = J.arg(a, 0)
	v_P_4278 = J.arg(a, 1)
	J.mc(v_c_4277, "beginPath", [])
	J.mc(v_c_4277, "moveTo", [J.gp(J.gp(v_P_4278, 0.0), 0.0), J.gp(J.gp(v_P_4278, 0.0), 1.0)])
	v_i_4279 = 1.0
	while true:
		if not J.cmp(v_i_4279, J.len(v_P_4278), "<"): break
		J.mc(v_c_4277, "lineTo", [J.gp(J.gp(v_P_4278, v_i_4279), 0.0), J.gp(J.gp(v_P_4278, v_i_4279), 1.0)])
		v_i_4279 = J.num(v_i_4279) + 1.0
	J.mc(v_c_4277, "closePath", [])

func _f719(this_, a: Array, env):
	var v_v_4316 = null
	v_v_4316 = J.arg(a, 0)
	return [J.add(J.gp(v_v_4316, 0.0), J.mul(J.sub(J.cl(env["r"], null, []), 0.5), env["jj"])), J.add(J.gp(v_v_4316, 1.0), J.mul(J.sub(J.cl(env["r"], null, []), 0.5), env["jj"]))]

func _f720(this_, a: Array, env):
	var v_o2_4319 = null
	v_o2_4319 = J.arg(a, 0)
	var _t4801 = env["c"]
	J.sp(_t4801, "globalAlpha", 0.6)
	J.mc(env["c"], "beginPath", [])
	J.mc(env["c"], "arc", [J.add(J.gp(v_o2_4319, 0.0), (J.sub(J.cl(env["r"], null, []), 0.5) * 2.0)), J.add(J.gp(v_o2_4319, 1.0), (J.sub(J.cl(env["r"], null, []), 0.5) * 2.0)), (1.3 + J.mul(J.cl(env["r"], null, []), 1.2)), 0.0, 7.0])
	J.mc(env["c"], "fill", [])

func _f718(this_, a: Array, env):
	var v_w_4282 = null; var v_h_4283 = null; var v_tone_4284 = null; var v_mode_4285 = null; var v_T_4286 = null; var v_M_4287 = null; var v_D_4288 = null; var v_o_4289 = null; var v_pr_4292 = null; var v_off_4293 = null; var v_pan_4294 = null; var v_bar_4295 = null; var v_ring_4296 = null; var v_J_4297 = null; var v_P_4298 = null; var v_gd_4299 = null; var v_g_4300 = null; var v_step_4301 = null; var v_k_4302 = null; var v_a0_4303 = null; var v_nq_4304 = null; var v_q_4305 = null; var v_qx_4306 = null; var v_qy_4307 = null; var v_s2_4308 = null; var v_yy_4309 = null; var v_passes_4310 = null; var v_p_4312 = null; var v_Q_4313 = null
	var _s1758 = {"__p": env, "c": null, "r": null, "jj": null}
	v_w_4282 = J.arg(a, 0)
	v_h_4283 = J.arg(a, 1)
	v_tone_4284 = J.arg(a, 2)
	v_mode_4285 = J.arg(a, 3)
	var _t4745 = J.gp(J.gp(_s1758["__p"]["CR"], "tones"), v_tone_4284)
	v_T_4286 = (_t4745 if J.t(_t4745) else J.gp(J.gp(_s1758["__p"]["CR"], "tones"), "ink"))
	v_M_4287 = J.gp(_s1758["__p"]["CR"], "M")
	v_D_4288 = _s1758["__p"]["DPR"]
	v_o_4289 = J.S_document_("createElement", ["canvas"])
	var _t4746 = ceil(J.num(J.mul(J.add(v_w_4282, J.mul(v_M_4287, 2.0)), v_D_4288)))
	J.sp(v_o_4289, "width", _t4746)
	var _t4747 = ceil(J.num(J.mul(J.add(v_h_4283, J.mul(v_M_4287, 2.0)), v_D_4288)))
	J.sp(v_o_4289, "height", _t4747)
	_s1758["c"] = J.mc(v_o_4289, "getContext", ["2d"])
	J.mc(_s1758["c"], "scale", [v_D_4288, v_D_4288])
	J.mc(_s1758["c"], "translate", [v_M_4287, v_M_4287])
	var _t4748 = _s1758["__p"]["crRnd"]
	var _t4749 = _s1758["__p"]["crHash"]
	_s1758["r"] = J.cl(_t4748, null, [J.cl(_t4749, null, [J.add(J.add(J.add(J.add(v_w_4282, "x"), v_h_4283), v_tone_4284), v_mode_4285)])])
	v_pr_4292 = J.seq(v_mode_4285, "p")
	v_off_4293 = J.seq(v_mode_4285, "off")
	v_pan_4294 = J.seq(v_mode_4285, "panel")
	var _t4750 = J.seq(v_mode_4285, "bar")
	v_bar_4295 = (_t4750 if _t4750 else J.seq(v_mode_4285, "fill"))
	v_ring_4296 = J.seq(J.mc(v_mode_4285, "indexOf", ["ring"]), 0.0)
	v_J_4297 = (2.4 if J.t(v_pan_4294) else (1.0 if J.t(v_bar_4295) else 1.7))
	var _t4751 = _s1758["__p"]["crShape"]
	v_P_4298 = J.cl(_t4751, null, [_s1758["r"], v_w_4282, v_h_4283, v_J_4297, v_ring_4296])
	var _t4752 = (not J.t(v_pr_4292))
	var _t4753 = ((not J.t(v_pan_4294)) if _t4752 else _t4752)
	if ((not J.t(v_bar_4295)) if _t4753 else _t4753):
		J.mc(_s1758["c"], "save", [])
		J.mc(_s1758["c"], "translate", [2.0, 3.0])
		var _t4754 = _s1758["__p"]["crTrace"]
		J.cl(_t4754, null, [_s1758["c"], v_P_4298])
		var _t4755 = _s1758["c"]
		J.sp(_t4755, "fillStyle", "rgba(0,0,0,0.55)")
		J.mc(_s1758["c"], "fill", [])
		J.mc(_s1758["c"], "restore", [])
	var _t4756 = _s1758["__p"]["crTrace"]
	J.cl(_t4756, null, [_s1758["c"], v_P_4298])
	var _t4757 = J.seq(v_mode_4285, "fill")
	if (J.seq(v_tone_4284, "dawn") if _t4757 else _t4757):
		v_gd_4299 = J.mc(_s1758["c"], "createLinearGradient", [0.0, 0.0, v_w_4282, 0.0])
		J.mc(v_gd_4299, "addColorStop", [0.0, "#24361f"])
		J.mc(v_gd_4299, "addColorStop", [0.62, "#6a2220"])
		J.mc(v_gd_4299, "addColorStop", [1.0, "#b8642c"])
		var _t4758 = _s1758["c"]
		J.sp(_t4758, "fillStyle", v_gd_4299)
	else:
		var _t4759 = _s1758["c"]
		var _t4760 = (J.gp(v_T_4286, "m") if J.seq(v_mode_4285, "fill") else J.gp(v_T_4286, "b"))
		J.sp(_t4759, "fillStyle", _t4760)
	J.mc(_s1758["c"], "fill", [])
	J.mc(_s1758["c"], "save", [])
	var _t4761 = _s1758["__p"]["crTrace"]
	J.cl(_t4761, null, [_s1758["c"], v_P_4298])
	J.mc(_s1758["c"], "clip", [])
	v_g_4300 = J.mc(_s1758["c"], "createLinearGradient", [0.0, 0.0, 0.0, v_h_4283])
	J.mc(v_g_4300, "addColorStop", [0.0, "rgba(255,240,220,0.06)"])
	J.mc(v_g_4300, "addColorStop", [1.0, "rgba(0,0,0,0.34)"])
	var _t4762 = _s1758["c"]
	J.sp(_t4762, "fillStyle", v_g_4300)
	J.mc(_s1758["c"], "fillRect", [0.0, 0.0, v_w_4282, v_h_4283])
	var _t4763 = _s1758["c"]
	var _t4764 = (J.gp(v_T_4286, "h") if J.seq(v_mode_4285, "fill") else J.gp(v_T_4286, "m"))
	J.sp(_t4763, "strokeStyle", _t4764)
	var _t4765 = _s1758["c"]
	J.sp(_t4765, "lineCap", "round")
	v_step_4301 = (7.0 if J.t(v_pan_4294) else (3.5 if J.t(v_bar_4295) else 5.0))
	v_k_4302 = ((-J.num(v_h_4283)) - 4.0)
	while true:
		if not J.cmp(v_k_4302, J.add(v_w_4282, v_h_4283), "<"): break
		var _t4766 = _s1758["c"]
		var _t4767 = ((0.22 if J.t(v_pan_4294) else (0.28 if J.seq(v_mode_4285, "fill") else 0.36)) + J.mul(J.cl(_s1758["r"], null, []), 0.25))
		J.sp(_t4766, "globalAlpha", _t4767)
		var _t4768 = _s1758["c"]
		var _t4769 = (0.8 + J.mul(J.cl(_s1758["r"], null, []), 1.4))
		J.sp(_t4768, "lineWidth", _t4769)
		J.mc(_s1758["c"], "beginPath", [])
		v_a0_4303 = J.add(v_k_4302, (J.sub(J.cl(_s1758["r"], null, []), 0.5) * 3.0))
		J.mc(_s1758["c"], "moveTo", [v_a0_4303, J.add(v_h_4283, 2.0)])
		J.mc(_s1758["c"], "lineTo", [J.add(J.add(v_a0_4303, J.mul(v_h_4283, 0.9)), (J.sub(J.cl(_s1758["r"], null, []), 0.5) * 4.0)), (-2.0)])
		J.mc(_s1758["c"], "stroke", [])
		var _t4770 = J.add(v_k_4302, J.add(v_step_4301, J.mul(J.cl(_s1758["r"], null, []), 2.0)))
		v_k_4302 = _t4770
	var _t4771 = _s1758["c"]
	var _t4772 = J.gp(v_T_4286, "e")
	J.sp(_t4771, "strokeStyle", _t4772)
	v_nq_4304 = (J.min_([260.0, J.div(J.mul(v_w_4282, v_h_4283), 900.0)]) if J.t(v_pan_4294) else J.div(v_w_4282, 6.0))
	v_q_4305 = 0.0
	while true:
		if not J.cmp(v_q_4305, v_nq_4304, "<"): break
		var _t4773 = _s1758["c"]
		var _t4774 = (0.05 + J.mul(J.cl(_s1758["r"], null, []), 0.08))
		J.sp(_t4773, "globalAlpha", _t4774)
		var _t4775 = _s1758["c"]
		var _t4776 = J.add(0.6, J.cl(_s1758["r"], null, []))
		J.sp(_t4775, "lineWidth", _t4776)
		v_qx_4306 = J.mul(J.cl(_s1758["r"], null, []), v_w_4282)
		v_qy_4307 = J.mul(J.cl(_s1758["r"], null, []), v_h_4283)
		J.mc(_s1758["c"], "beginPath", [])
		J.mc(_s1758["c"], "moveTo", [v_qx_4306, v_qy_4307])
		J.mc(_s1758["c"], "lineTo", [J.add(J.add(v_qx_4306, 6.0), J.mul(J.cl(_s1758["r"], null, []), 14.0)), (J.sub(v_qy_4307, 3.0) - J.mul(J.cl(_s1758["r"], null, []), 5.0))])
		J.mc(_s1758["c"], "stroke", [])
		v_q_4305 = J.num(v_q_4305) + 1.0
	var _t4777 = _s1758["c"]
	J.sp(_t4777, "globalAlpha", 1.0)
	var _t4778 = _s1758["c"]
	var _t4779 = J.mc(_s1758["c"], "createPattern", [J.cl(_s1758["__p"]["crGrain"], null, []), "repeat"])
	J.sp(_t4778, "fillStyle", _t4779)
	J.mc(_s1758["c"], "fillRect", [(-2.0), (-2.0), J.add(v_w_4282, 4.0), J.add(v_h_4283, 4.0)])
	var _t4780 = (not J.t(v_pan_4294))
	var _t4781 = ((not J.t(v_bar_4295)) if _t4780 else _t4780)
	if ((not J.t(v_ring_4296)) if _t4781 else _t4781):
		var _t4782 = _s1758["c"]
		var _t4783 = J.gp(v_T_4286, "h")
		J.sp(_t4782, "strokeStyle", _t4783)
		v_s2_4308 = 0.0
		while true:
			if not J.cmp(v_s2_4308, 3.0, "<"): break
			var _t4784 = _s1758["c"]
			var _t4785 = (0.08 + J.mul(J.cl(_s1758["r"], null, []), 0.12))
			J.sp(_t4784, "globalAlpha", _t4785)
			var _t4786 = _s1758["c"]
			var _t4787 = (2.0 + J.mul(J.cl(_s1758["r"], null, []), 2.0))
			J.sp(_t4786, "lineWidth", _t4787)
			J.mc(_s1758["c"], "beginPath", [])
			v_yy_4309 = J.add((3.0 + J.mul(v_s2_4308, 2.2)), J.cl(_s1758["r"], null, []))
			J.mc(_s1758["c"], "moveTo", [(6.0 + J.mul(J.cl(_s1758["r"], null, []), 6.0)), v_yy_4309])
			J.mc(_s1758["c"], "lineTo", [(J.sub(v_w_4282, 6.0) - J.mul(J.cl(_s1758["r"], null, []), 10.0)), J.add(v_yy_4309, (J.sub(J.cl(_s1758["r"], null, []), 0.5) * 2.0))])
			J.mc(_s1758["c"], "stroke", [])
			v_s2_4308 = J.num(v_s2_4308) + 1.0
	J.mc(_s1758["c"], "restore", [])
	v_passes_4310 = (4.0 if J.t(v_pr_4292) else (2.0 if J.t(v_bar_4295) else 3.0))
	_s1758["jj"] = (2.6 if J.t(v_pan_4294) else (1.0 if J.t(v_bar_4295) else 2.0))
	if (not J.seq(v_mode_4285, "fill")):
		v_p_4312 = 0.0
		while true:
			if not J.cmp(v_p_4312, v_passes_4310, "<"): break
			v_Q_4313 = J.mc(v_P_4298, "map", [Callable(self, "_f719").bind(_s1758)])
			var _t4788 = _s1758["c"]
			var _t4789 = (0.95 if J.seq(v_p_4312, 0.0) else (0.42 + J.mul(J.cl(_s1758["r"], null, []), 0.3)))
			J.sp(_t4788, "globalAlpha", _t4789)
			var _t4790 = _s1758["c"]
			var _t4791 = J.seq(v_p_4312, J.sub(v_passes_4310, 1.0))
			var _t4792 = ("rgba(0,0,0,0.55)" if ((not J.t(v_bar_4295)) if _t4791 else _t4791) else J.gp(v_T_4286, "e"))
			J.sp(_t4790, "strokeStyle", _t4792)
			var _t4793 = _s1758["c"]
			var _t4794 = (((3.4 if J.t(v_pr_4292) else (2.1 if J.t(v_pan_4294) else (1.3 if J.t(v_bar_4295) else 2.2))) - J.mul(v_p_4312, 0.35)) + J.mul(J.cl(_s1758["r"], null, []), 0.5))
			J.sp(_t4793, "lineWidth", _t4794)
			var _t4795 = _s1758["c"]
			J.sp(_t4795, "lineJoin", "round")
			var _t4796 = _s1758["__p"]["crTrace"]
			J.cl(_t4796, null, [_s1758["c"], v_Q_4313])
			J.mc(_s1758["c"], "stroke", [])
			v_p_4312 = J.num(v_p_4312) + 1.0
	var _t4797 = (not J.t(v_bar_4295))
	if ((not J.t(v_ring_4296)) if _t4797 else _t4797):
		var _t4798 = _s1758["c"]
		var _t4799 = J.gp(v_T_4286, "e")
		J.sp(_t4798, "fillStyle", _t4799)
		var _t4800 = [[0.0, 0.0], [v_w_4282, 0.0], [v_w_4282, v_h_4283], [0.0, v_h_4283]]
		J.mc(_t4800, "forEach", [Callable(self, "_f720").bind(_s1758)])
	var _t4802 = _s1758["c"]
	J.sp(_t4802, "globalAlpha", 1.0)
	if J.t(v_off_4293):
		var _t4803 = _s1758["c"]
		J.sp(_t4803, "globalCompositeOperation", "source-atop")
		var _t4804 = _s1758["c"]
		J.sp(_t4804, "fillStyle", "rgba(16,13,18,0.58)")
		J.mc(_s1758["c"], "fillRect", [(-J.num(v_M_4287)), (-J.num(v_M_4287)), J.add(v_w_4282, J.mul(2.0, v_M_4287)), J.add(v_h_4283, J.mul(2.0, v_M_4287))])
		var _t4805 = _s1758["c"]
		J.sp(_t4805, "globalCompositeOperation", "source-over")
	return v_o_4289

func _f721(this_, a: Array, env):
	var v_w_4322 = null; var v_h_4323 = null; var v_tone_4324 = null; var v_mode_4325 = null; var v_k_4326 = null; var v_v_4327 = null
	v_w_4322 = J.arg(a, 0)
	v_h_4323 = J.arg(a, 1)
	v_tone_4324 = J.arg(a, 2)
	v_mode_4325 = J.arg(a, 3)
	var _t4806 = J.max_([4.0, J.round(J.num(v_w_4322))])
	v_w_4322 = _t4806
	var _t4807 = J.max_([4.0, J.round(J.num(v_h_4323))])
	v_h_4323 = _t4807
	v_k_4326 = J.add((J.add((J.add((J.add(J.add(v_w_4322, "|"), v_h_4323) + "|"), v_tone_4324) + "|"), v_mode_4325) + "|"), env["DPR"])
	v_v_4327 = J.gp(J.gp(env["CR"], "cache"), v_k_4326)
	if (not J.t(v_v_4327)):
		if J.cmp(J.gp(env["CR"], "n"), 220.0, ">"):
			var _t4808 = env["CR"]
			var _t4809 = {}
			J.sp(_t4808, "cache", _t4809)
			var _t4810 = env["CR"]
			J.sp(_t4810, "n", 0.0)
		var _t4811 = J.gp(env["CR"], "cache")
		var _t4812 = env["crBuild"]
		var _t4813 = J.cl(_t4812, null, [v_w_4322, v_h_4323, v_tone_4324, v_mode_4325])
		J.sp(_t4811, v_k_4326, _t4813)
		v_v_4327 = _t4813
		var _t4814 = env["CR"]
		J.sp(_t4814, "n", J.num(J.gp(_t4814, "n")) + 1.0)
	return v_v_4327

func _f722(this_, a: Array, env):
	var v_c_4330 = null; var v_im_4331 = null; var v_x_4332 = null; var v_y_4333 = null; var v_M_4334 = null
	v_c_4330 = J.arg(a, 0)
	v_im_4331 = J.arg(a, 1)
	v_x_4332 = J.arg(a, 2)
	v_y_4333 = J.arg(a, 3)
	v_M_4334 = J.gp(env["CR"], "M")
	J.mc(v_c_4330, "drawImage", [v_im_4331, J.sub(v_x_4332, v_M_4334), J.sub(v_y_4333, v_M_4334), J.div(J.gp(v_im_4331, "width"), env["DPR"]), J.div(J.gp(v_im_4331, "height"), env["DPR"])])

func _f723(this_, a: Array, env):
	var v_c_4337 = null; var v_x_4338 = null; var v_y_4339 = null; var v_w_4340 = null; var v_h_4341 = null; var v_tone_4342 = null
	v_c_4337 = J.arg(a, 0)
	v_x_4338 = J.arg(a, 1)
	v_y_4339 = J.arg(a, 2)
	v_w_4340 = J.arg(a, 3)
	v_h_4341 = J.arg(a, 4)
	v_tone_4342 = J.arg(a, 5)
	var _t4815 = env["crBlit"]
	var _t4816 = env["crGet"]
	J.cl(_t4815, null, [v_c_4337, J.cl(_t4816, null, [v_w_4340, v_h_4341, (v_tone_4342 if J.t(v_tone_4342) else "paper"), "panel"]), v_x_4338, v_y_4339])

func _f725(this_, a: Array, env):
	var v_dx_4358 = null; var v_dy_4359 = null
	v_dx_4358 = J.arg(a, 0)
	v_dy_4359 = J.arg(a, 1)
	if J.t(env["mw"]):
		J.mc(env["c"], "fillText", [env["s"], J.add(env["x"], v_dx_4358), J.add(env["y"], v_dy_4359), env["mw"]])
	else:
		J.mc(env["c"], "fillText", [env["s"], J.add(env["x"], v_dx_4358), J.add(env["y"], v_dy_4359)])

func _f724(this_, a: Array, env):
	var v_sz_4349 = null; var v_col_4350 = null; var v_al_4351 = null; var v_mid_4353 = null; var v_wt_4354 = null; var v_F_4355 = null
	var _s1779 = {"__p": env, "c": null, "s": null, "x": null, "y": null, "mw": null}
	_s1779["c"] = J.arg(a, 0)
	_s1779["s"] = J.arg(a, 1)
	_s1779["x"] = J.arg(a, 2)
	_s1779["y"] = J.arg(a, 3)
	v_sz_4349 = J.arg(a, 4)
	v_col_4350 = J.arg(a, 5)
	v_al_4351 = J.arg(a, 6)
	_s1779["mw"] = J.arg(a, 7)
	v_mid_4353 = J.arg(a, 8)
	v_wt_4354 = J.arg(a, 9)
	var _t4817 = J.F_String([_s1779["s"]])
	_s1779["s"] = _t4817
	if J.t(J.gp(J.G.get("window"), "__twNat")):
		var _t4818 = J.G.get("__nat_crText")
		var _t4820 = _s1779["c"]
		var _t4821 = _s1779["s"]
		var _t4822 = _s1779["x"]
		var _t4823 = _s1779["y"]
		var _t4819 = _s1779["__p"]["crCol"]
		J.cl(_t4818, null, [_t4820, _t4821, _t4822, _t4823, v_sz_4349, J.cl(_t4819, null, [(v_col_4350 if J.t(v_col_4350) else "#efe5cf")]), (v_al_4351 if J.t(v_al_4351) else "left"), (_s1779["mw"] if J.t(_s1779["mw"]) else 0.0), (not (not J.t(v_mid_4353))), (v_wt_4354 if J.t(v_wt_4354) else "bold")])
		return null
	J.mc(_s1779["c"], "save", [])
	var _t4824 = _s1779["c"]
	var _t4825 = J.add((J.add(J.add((v_wt_4354 if J.t(v_wt_4354) else "bold"), " "), v_sz_4349) + "px "), _s1779["__p"]["FONT"])
	J.sp(_t4824, "font", _t4825)
	var _t4826 = _s1779["c"]
	var _t4827 = (v_al_4351 if J.t(v_al_4351) else "left")
	J.sp(_t4826, "textAlign", _t4827)
	var _t4828 = _s1779["c"]
	var _t4829 = ("middle" if J.t(v_mid_4353) else "alphabetic")
	J.sp(_t4828, "textBaseline", _t4829)
	var _t4830 = _s1779["c"]
	J.sp(_t4830, "lineJoin", "round")
	v_F_4355 = Callable(self, "_f725").bind(_s1779)
	var _t4831 = _s1779["c"]
	J.sp(_t4831, "fillStyle", "rgba(6,3,8,0.88)")
	J.cl(v_F_4355, null, [1.4, 2.0])
	var _t4832 = _s1779["c"]
	var _t4833 = J.max_([2.4, J.mul(v_sz_4349, 0.2)])
	J.sp(_t4832, "lineWidth", _t4833)
	var _t4834 = _s1779["c"]
	J.sp(_t4834, "strokeStyle", "rgba(8,5,10,0.82)")
	if J.t(_s1779["mw"]):
		J.mc(_s1779["c"], "strokeText", [_s1779["s"], _s1779["x"], _s1779["y"], _s1779["mw"]])
	else:
		J.mc(_s1779["c"], "strokeText", [_s1779["s"], _s1779["x"], _s1779["y"]])
	var _t4835 = _s1779["c"]
	var _t4836 = _s1779["__p"]["crCol"]
	var _t4837 = J.cl(_t4836, null, [(v_col_4350 if J.t(v_col_4350) else "#efe5cf")])
	J.sp(_t4835, "fillStyle", _t4837)
	J.cl(v_F_4355, null, [0.0, 0.0])
	var _t4838 = _s1779["c"]
	var _t4839 = J.mul(J.gp(_t4838, "globalAlpha"), 0.35)
	J.sp(_t4838, "globalAlpha", _t4839)
	J.cl(v_F_4355, null, [0.6, (-0.4)])
	J.mc(_s1779["c"], "restore", [])

func _f726(this_, a: Array, env):
	var v_s_4362 = null; var v_x_4363 = null; var v_y_4364 = null; var v_mw_4365 = null; var v_m_4366 = null; var v_sz_4367 = null; var v_bold_4368 = null
	v_s_4362 = J.arg(a, 0)
	v_x_4363 = J.arg(a, 1)
	v_y_4364 = J.arg(a, 2)
	v_mw_4365 = J.arg(a, 3)
	v_m_4366 = J.mc(J.re("(\\d+(?:\\.\\d+)?)px", ""), "exec", [J.gp(env["ctx"], "font")])
	v_sz_4367 = (J.num(J.gp(v_m_4366, 1.0)) if J.t(v_m_4366) else 13.0)
	v_bold_4368 = J.mc(J.re("bold", ""), "test", [J.gp(env["ctx"], "font")])
	var _t4840 = env["crText"]
	J.cl(_t4840, null, [env["ctx"], v_s_4362, v_x_4363, v_y_4364, v_sz_4367, J.gp(env["ctx"], "fillStyle"), J.gp(env["ctx"], "textAlign"), v_mw_4365, false, ("bold" if J.t(v_bold_4368) else "normal")])

func _f727(this_, a: Array, env):
	var v_c_4371 = null; var v_x_4372 = null; var v_y_4373 = null; var v_w_4374 = null; var v_h_4375 = null; var v_f_4376 = null; var v_tone_4377 = null
	v_c_4371 = J.arg(a, 0)
	v_x_4372 = J.arg(a, 1)
	v_y_4373 = J.arg(a, 2)
	v_w_4374 = J.arg(a, 3)
	v_h_4375 = J.arg(a, 4)
	v_f_4376 = J.arg(a, 5)
	v_tone_4377 = J.arg(a, 6)
	var _t4841 = env["crBlit"]
	var _t4842 = env["crGet"]
	J.cl(_t4841, null, [v_c_4371, J.cl(_t4842, null, [v_w_4374, v_h_4375, "ink", "bar"]), v_x_4372, v_y_4373])
	var _t4843 = J.max_([0.0, J.min_([1.0, (v_f_4376 if J.t(v_f_4376) else 0.0)])])
	v_f_4376 = _t4843
	if J.cmp(v_f_4376, 0.0, "<="):
		return null
	J.mc(v_c_4371, "save", [])
	J.mc(v_c_4371, "beginPath", [])
	J.mc(v_c_4371, "rect", [J.sub(v_x_4372, 2.0), J.sub(v_y_4373, 3.0), (J.mul(v_w_4374, v_f_4376) + 2.0), J.add(v_h_4375, 6.0)])
	J.mc(v_c_4371, "clip", [])
	var _t4844 = env["crBlit"]
	var _t4845 = env["crGet"]
	J.cl(_t4844, null, [v_c_4371, J.cl(_t4845, null, [v_w_4374, v_h_4375, (v_tone_4377 if J.t(v_tone_4377) else "red"), "fill"]), v_x_4372, v_y_4373])
	J.mc(v_c_4371, "restore", [])
	if J.cmp(v_f_4376, 1.0, "<"):
		var _t4846 = J.gp(J.gp(env["CR"], "tones"), v_tone_4377)
		var _t4847 = J.gp((_t4846 if J.t(_t4846) else J.gp(J.gp(env["CR"], "tones"), "red")), "e")
		J.sp(v_c_4371, "strokeStyle", _t4847)
		J.sp(v_c_4371, "globalAlpha", 0.8)
		J.sp(v_c_4371, "lineWidth", 2.0)
		J.mc(v_c_4371, "beginPath", [])
		J.mc(v_c_4371, "moveTo", [J.add(v_x_4372, J.mul(v_w_4374, v_f_4376)), J.sub(v_y_4373, 1.0)])
		J.mc(v_c_4371, "lineTo", [J.add(J.add(v_x_4372, J.mul(v_w_4374, v_f_4376)), 1.0), J.add(J.add(v_y_4373, v_h_4375), 1.0)])
		J.mc(v_c_4371, "stroke", [])
		J.sp(v_c_4371, "globalAlpha", 1.0)

func _f728(this_, a: Array, env):
	var v_col_4380 = null; var v_k_4381 = null
	v_col_4380 = J.arg(a, 0)
	v_k_4381 = J.mc(J.F_String([(v_col_4380 if J.t(v_col_4380) else "")]), "toLowerCase", [])
	var _t4848 = J.gp({"#6e1c1c": "red", "#5a1c1c": "red", "#2a4a7a": "violet", "#2f5a4a": "moss", "#3a5a2a": "moss", "#2e3a34": "moss", "#8a5a14": "rust", "#3a3a40": "ink", "#2c2c33": "ink", "#24242a": "ink", "#26262c": "ink"}, v_k_4381)
	return (_t4848 if J.t(_t4848) else "ink")

func _f729(this_, a: Array, env):
	var v_c_4384 = null; var v_x_4385 = null; var v_y_4386 = null; var v_w_4387 = null; var v_h_4388 = null; var v_label_4389 = null; var v_tone_4390 = null; var v_pressed_4391 = null; var v_off_4392 = null; var v_dy_4393 = null
	v_c_4384 = J.arg(a, 0)
	v_x_4385 = J.arg(a, 1)
	v_y_4386 = J.arg(a, 2)
	v_w_4387 = J.arg(a, 3)
	v_h_4388 = J.arg(a, 4)
	v_label_4389 = J.arg(a, 5)
	v_tone_4390 = J.arg(a, 6)
	v_pressed_4391 = J.arg(a, 7)
	v_off_4392 = J.arg(a, 8)
	v_dy_4393 = (2.0 if J.t(v_pressed_4391) else 0.0)
	var _t4849 = env["crBlit"]
	var _t4850 = env["crGet"]
	J.cl(_t4849, null, [v_c_4384, J.cl(_t4850, null, [v_w_4387, v_h_4388, v_tone_4390, ("p" if J.t(v_pressed_4391) else ("off" if J.t(v_off_4392) else "n"))]), v_x_4385, J.add(v_y_4386, v_dy_4393)])
	if J.t(v_label_4389):
		var _t4851 = env["crText"]
		var _t4854 = J.add(v_x_4385, J.div(v_w_4387, 2.0))
		var _t4855 = J.add(J.add(J.add(v_y_4386, J.div(v_h_4388, 2.0)), v_dy_4393), 1.0)
		var _t4856 = (17.0 if J.cmp(v_h_4388, 50.0, ">=") else 16.0)
		var _t4853 = null
		if J.t(v_off_4392):
			_t4853 = "#8a7e84"
		else:
			var _t4852 = J.gp(J.gp(env["CR"], "tones"), v_tone_4390)
			_t4853 = J.gp((_t4852 if J.t(_t4852) else J.gp(J.gp(env["CR"], "tones"), "ink")), "t")
		J.cl(_t4851, null, [v_c_4384, v_label_4389, _t4854, _t4855, _t4856, _t4853, "center", J.sub(v_w_4387, 10.0), true])

func _f730(this_, a: Array, env):
	var v_x_4396 = null; var v_y_4397 = null; var v_t_4398 = null; var v_col_4399 = null; var v_w_4400 = null
	v_x_4396 = J.arg(a, 0)
	v_y_4397 = J.arg(a, 1)
	v_t_4398 = J.arg(a, 2)
	v_col_4399 = J.arg(a, 3)
	var _t4857 = env["ctx"]
	var _t4858 = J.add("bold 12px ", env["FONT"])
	J.sp(_t4857, "font", _t4858)
	v_w_4400 = (ceil(J.num(J.div(J.min_([190.0, J.add(J.gp(J.mc(env["ctx"], "measureText", [v_t_4398]), "width"), 16.0)]), 8.0))) * 8.0)
	var _t4859 = env["crBlit"]
	var _t4861 = env["ctx"]
	var _t4860 = env["crGet"]
	J.cl(_t4859, null, [_t4861, J.cl(_t4860, null, [v_w_4400, 22.0, "note", "bar"]), J.sub(v_x_4396, J.div(v_w_4400, 2.0)), J.sub(v_y_4397, 24.0)])
	J.mc(env["ctx"], "save", [])
	var _t4862 = env["ctx"]
	var _t4863 = (v_col_4399 if J.t(v_col_4399) else "#2a1e1c")
	J.sp(_t4862, "fillStyle", _t4863)
	var _t4864 = env["ctx"]
	J.sp(_t4864, "textAlign", "center")
	J.mc(env["ctx"], "fillText", [v_t_4398, v_x_4396, J.sub(v_y_4397, 9.0), J.sub(v_w_4400, 8.0)])
	J.mc(env["ctx"], "restore", [])

func _f731(this_, a: Array, env):
	var _t4865 = env["crPanel"]
	J.cl(_t4865, null, [env["ctx"], (-8.0), (-8.0), J.add(env["VW"], 16.0), J.add(env["VH"], 16.0), "paper"])

func _f732(this_, a: Array, env):
	var v_id_4405 = null
	v_id_4405 = J.arg(a, 0)
	var _t4867 = (J.seq(J.gp(env["ptr"], "btn"), v_id_4405) if J.t(env["ptr"]) else env["ptr"])
	if not J.t(_t4867):
		var _t4866 = (J.seq(J.gp(env["PRESS"], "id"), v_id_4405) if J.t(env["PRESS"]) else env["PRESS"])
		_t4867 = ((J.sub(J.S_performance_("now", []), J.gp(env["PRESS"], "t")) < 200.0) if J.t(_t4866) else _t4866)
	return _t4867

func _f733(this_, a: Array, env):
	var v_id_4408 = null; var v_x_4409 = null; var v_y_4410 = null; var v_w_4411 = null; var v_h_4412 = null; var v_label_4413 = null; var v_col_4414 = null; var v_on_4415 = null
	v_id_4408 = J.arg(a, 0)
	v_x_4409 = J.arg(a, 1)
	v_y_4410 = J.arg(a, 2)
	v_w_4411 = J.arg(a, 3)
	v_h_4412 = J.arg(a, 4)
	v_label_4413 = J.arg(a, 5)
	v_col_4414 = J.arg(a, 6)
	v_on_4415 = J.arg(a, 7)
	J.mc(env["buttons"], "push", [{"id": v_id_4408, "x": v_x_4409, "y": v_y_4410, "w": v_w_4411, "h": v_h_4412}])
	var _t4868 = env["crBtn"]
	var _t4870 = env["ctx"]
	var _t4869 = env["crTone"]
	var _t4872 = J.cl(_t4869, null, [v_col_4414])
	var _t4871 = env["crPressed"]
	J.cl(_t4868, null, [_t4870, v_x_4409, v_y_4410, v_w_4411, v_h_4412, v_label_4413, _t4872, J.cl(_t4871, null, [v_id_4408]), J.seq(v_on_4415, false)])

func _f735(this_, a: Array, env):
	var v_un_4457 = null; var v_top_4458 = null; var v_col_4459 = null; var v_lb_4460 = null; var v_tx_4461 = null; var v_tt_4462 = null
	v_un_4457 = J.arg(a, 0)
	var _t4891 = env["__p"]["fy"]
	v_top_4458 = J.add(J.cl(_t4891, null, [J.add(J.gp(v_un_4457, "f"), 1.0)]), 16.0)
	var _t4892 = J.cmp(J.gp(v_un_4457, "y"), J.gp(env["__p"]["CULL"], "y0"), "<")
	if (_t4892 if _t4892 else J.cmp(v_top_4458, J.gp(env["__p"]["CULL"], "y1"), ">")):
		return null
	if J.t(J.gp(v_un_4457, "lit")):
		var _t4893 = env["__p"]["ctx"]
		J.sp(_t4893, "fillStyle", "rgba(255,230,140,0.38)")
		J.mc(env["__p"]["ctx"], "fillRect", [J.gp(J.gp(v_un_4457, "rx"), 0.0), v_top_4458, J.sub(J.gp(J.gp(v_un_4457, "rx"), 1.0), J.gp(J.gp(v_un_4457, "rx"), 0.0)), (J.sub(J.gp(v_un_4457, "y"), v_top_4458) - 4.0)])
	var _t4894 = J.gp(v_un_4457, "task")
	if J.t(((not J.t(J.gp(v_un_4457, "taskDone"))) if J.t(_t4894) else _t4894)):
		v_col_4459 = J.gp({"food": "#ffd54a", "money": "#ffe27a", "comb": "#e8b0a0"}, J.gp(v_un_4457, "task"))
		var _t4895 = env["__p"]["ctx"]
		J.sp(_t4895, "strokeStyle", v_col_4459)
		var _t4896 = env["__p"]["ctx"]
		J.sp(_t4896, "lineWidth", 3.0)
		var _t4897 = env["__p"]["ctx"]
		var _t4898 = (0.6 + (0.3 * sin(J.num(J.mul(J.gp(env["__p"]["G"], "t"), 4.0)))))
		J.sp(_t4897, "globalAlpha", _t4898)
		J.mc(env["__p"]["ctx"], "beginPath", [])
		J.mc(env["__p"]["ctx"], "ellipse", [J.gp(v_un_4457, "x"), J.sub(J.gp(v_un_4457, "y"), 34.0), 16.0, 5.0, 0.0, 0.0, 7.0])
		J.mc(env["__p"]["ctx"], "stroke", [])
		var _t4899 = env["__p"]["ctx"]
		J.sp(_t4899, "globalAlpha", 1.0)
		var _t4900 = env["__p"]["ctx"]
		var _t4901 = J.add("bold 11px ", env["__p"]["FONT"])
		J.sp(_t4900, "font", _t4901)
		var _t4902 = env["__p"]["ctx"]
		J.sp(_t4902, "lineWidth", 3.0)
		var _t4903 = env["__p"]["ctx"]
		J.sp(_t4903, "strokeStyle", "#0c0c0e")
		var _t4904 = env["__p"]["ctx"]
		J.sp(_t4904, "textAlign", "center")
		v_lb_4460 = J.gp({"food": "宵夜", "money": "銀包", "comb": "梳頭"}, J.gp(v_un_4457, "task"))
		J.mc(env["__p"]["ctx"], "strokeText", [v_lb_4460, J.gp(v_un_4457, "x"), J.sub(J.gp(v_un_4457, "y"), 44.0)])
		var _t4905 = env["__p"]["ctx"]
		J.sp(_t4905, "fillStyle", v_col_4459)
		J.mc(env["__p"]["ctx"], "fillText", [v_lb_4460, J.gp(v_un_4457, "x"), J.sub(J.gp(v_un_4457, "y"), 44.0)])
	if J.t(J.gp(v_un_4457, "story")):
		v_tx_4461 = J.div(J.add(J.gp(J.gp(v_un_4457, "rx"), 0.0), J.gp(J.gp(v_un_4457, "rx"), 1.0)), 2.0)
		var _t4906 = J.gp(env["__p"]["G"], "story")
		v_tt_4462 = ("✦已收集" if J.cmp(J.mc(_t4906, "indexOf", [J.gp(v_un_4457, "si")]), 0.0, ">=") else "✦故事")
		var _t4907 = env["__p"]["ctx"]
		var _t4908 = J.add("bold 11px ", env["__p"]["FONT"])
		J.sp(_t4907, "font", _t4908)
		var _t4909 = env["__p"]["ctx"]
		J.sp(_t4909, "textAlign", "center")
		var _t4910 = env["__p"]["ctx"]
		J.sp(_t4910, "lineWidth", 3.0)
		var _t4911 = env["__p"]["ctx"]
		J.sp(_t4911, "strokeStyle", "#0c0c0e")
		J.mc(env["__p"]["ctx"], "strokeText", [v_tt_4462, v_tx_4461, J.add(v_top_4458, 14.0)])
		var _t4912 = env["__p"]["ctx"]
		J.sp(_t4912, "fillStyle", "#cfe8dc")
		J.mc(env["__p"]["ctx"], "fillText", [v_tt_4462, v_tx_4461, J.add(v_top_4458, 14.0)])

func _f736(this_, a: Array, env):
	var v_e_4465 = null
	v_e_4465 = J.arg(a, 0)
	return (not (not J.t(J.gp(v_e_4465, "ward"))))

func _f737(this_, a: Array, env):
	var v_id_4468 = null; var v_n_4469 = null
	v_id_4468 = J.arg(a, 0)
	var _t4918 = J.gp(env["__p"]["G"], "gate")
	if J.t(((not J.seq(J.gp(J.gp(env["__p"]["G"], "gate"), "node"), v_id_4468)) if J.t(_t4918) else _t4918)):
		return null
	v_n_4469 = J.gp(J.gp(env["__p"]["G"], "nodes"), v_id_4468)
	var _t4919 = env["__p"]["ctx"]
	var _t4920 = (0.5 + (0.3 * sin(J.num(J.mul(J.gp(env["__p"]["G"], "t"), 2.5)))))
	J.sp(_t4919, "globalAlpha", _t4920)
	var _t4921 = env["__p"]["ctx"]
	J.sp(_t4921, "fillStyle", "#3fbf8f")
	J.mc(env["__p"]["ctx"], "beginPath", [])
	J.mc(env["__p"]["ctx"], "ellipse", [J.gp(v_n_4469, "x"), J.sub(J.gp(v_n_4469, "y"), 4.0), 26.0, 9.0, 0.0, 0.0, 7.0])
	J.mc(env["__p"]["ctx"], "fill", [])
	var _t4922 = env["__p"]["ctx"]
	J.sp(_t4922, "globalAlpha", 1.0)
	var _t4923 = env["__p"]["ctx"]
	J.sp(_t4923, "fillStyle", "#e2e6e0")
	var _t4924 = env["__p"]["ctx"]
	var _t4925 = J.add("bold 12px ", env["__p"]["FONT"])
	J.sp(_t4924, "font", _t4925)
	var _t4926 = env["__p"]["ctx"]
	J.sp(_t4926, "textAlign", "center")
	var _t4927 = env["__p"]["ctx"]
	J.sp(_t4927, "lineWidth", 3.0)
	var _t4928 = env["__p"]["ctx"]
	J.sp(_t4928, "strokeStyle", "#0c0c0e")
	J.mc(env["__p"]["ctx"], "strokeText", ["回陰間", J.gp(v_n_4469, "x"), J.sub(J.gp(v_n_4469, "y"), 14.0)])
	J.mc(env["__p"]["ctx"], "fillText", ["回陰間", J.gp(v_n_4469, "x"), J.sub(J.gp(v_n_4469, "y"), 14.0)])

func _f738(this_, a: Array, env):
	var v_u_4472 = null
	v_u_4472 = J.arg(a, 0)
	return J.seq(J.gp(v_u_4472, "f"), env["f"])

func _f739(this_, a: Array, env):
	var v_u_4475 = null
	v_u_4475 = J.arg(a, 0)
	return J.div(J.add(J.gp(J.gp(v_u_4475, "rx"), 0.0), J.gp(J.gp(v_u_4475, "rx"), 1.0)), 2.0)

func _f740(this_, a: Array, env):
	var v_lx_4478 = null; var v_gr_4479 = null
	v_lx_4478 = J.arg(a, 0)
	v_gr_4479 = J.mc(env["__p"]["ctx"], "createRadialGradient", [v_lx_4478, env["ly"], 2.0, v_lx_4478, env["ly"], 46.0])
	J.mc(v_gr_4479, "addColorStop", [0.0, (J.add("rgba(255,214,140,", J.mul(0.32, env["fl"])) + ")")])
	J.mc(v_gr_4479, "addColorStop", [1.0, "rgba(255,214,140,0)"])
	var _t4938 = env["__p"]["ctx"]
	J.sp(_t4938, "fillStyle", v_gr_4479)
	J.mc(env["__p"]["ctx"], "fillRect", [J.sub(v_lx_4478, 46.0), J.sub(env["ly"], 46.0), 92.0, 92.0])

func _f741(this_, a: Array, env):
	var v_w_4482 = null; var v_a_4483 = null; var v_gr_4484 = null
	v_w_4482 = J.arg(a, 0)
	v_a_4483 = J.div(J.gp(v_w_4482, "t"), 0.9)
	v_gr_4484 = J.mc(env["__p"]["ctx"], "createRadialGradient", [J.gp(v_w_4482, "x"), J.sub(J.gp(v_w_4482, "y"), 30.0), 4.0, J.gp(v_w_4482, "x"), J.sub(J.gp(v_w_4482, "y"), 30.0), 60.0])
	J.mc(v_gr_4484, "addColorStop", [0.0, (J.add("rgba(255,220,140,", J.mul(0.7, v_a_4483)) + ")")])
	J.mc(v_gr_4484, "addColorStop", [1.0, "rgba(255,220,140,0)"])
	var _t4950 = env["__p"]["ctx"]
	J.sp(_t4950, "fillStyle", v_gr_4484)
	J.mc(env["__p"]["ctx"], "fillRect", [J.sub(J.gp(v_w_4482, "x"), 60.0), J.sub(J.gp(v_w_4482, "y"), 90.0), 120.0, 120.0])
	var _t4951 = env["__p"]["ctx"]
	var _t4952 = (J.add("rgba(255,230,160,", v_a_4483) + ")")
	J.sp(_t4951, "strokeStyle", _t4952)
	var _t4953 = env["__p"]["ctx"]
	J.sp(_t4953, "lineWidth", 2.0)
	J.mc(env["__p"]["ctx"], "beginPath", [])
	J.mc(env["__p"]["ctx"], "arc", [J.gp(v_w_4482, "x"), J.sub(J.gp(v_w_4482, "y"), 30.0), (30.0 + (J.sub(1.0, v_a_4483) * 30.0)), 0.0, 7.0])
	J.mc(env["__p"]["ctx"], "stroke", [])

func _f742(this_, a: Array, env):
	var v_r_4487 = null
	v_r_4487 = J.arg(a, 0)
	var _t4955 = env["__p"]["pplDrawRes"]
	J.cl(_t4955, null, [v_r_4487, env["viewW"], env["viewH"]])

func _f743(this_, a: Array, env):
	var v_w_4490 = null
	v_w_4490 = J.arg(a, 0)
	var _t4958 = env["__p"]["ctx"]
	var _t4959 = (J.add("rgba(255,215,90,", J.mul(J.gp(v_w_4490, "t"), 0.85)) + ")")
	J.sp(_t4958, "strokeStyle", _t4959)
	var _t4960 = env["__p"]["ctx"]
	J.sp(_t4960, "lineWidth", 4.0)
	J.mc(env["__p"]["ctx"], "beginPath", [])
	J.mc(env["__p"]["ctx"], "ellipse", [J.gp(env["T"], "x"), J.sub(env["ty"], 30.0), J.gp(v_w_4490, "r"), J.mul(J.gp(v_w_4490, "r"), 0.45), 0.0, 0.0, 7.0])
	J.mc(env["__p"]["ctx"], "stroke", [])

func _f744(this_, a: Array, env):
	var v_o_4493 = null
	v_o_4493 = J.arg(a, 0)
	var _t4977 = J.cmp(J.gp(v_o_4493, "sealT"), 0.0, ">")
	if ((not J.t(J.gp(v_o_4493, "home"))) if _t4977 else _t4977):
		var _t4978 = env["__p"]["ctx"]
		J.sp(_t4978, "strokeStyle", "rgba(255,215,90,0.7)")
		var _t4979 = env["__p"]["ctx"]
		J.sp(_t4979, "lineWidth", 2.0)
		J.mc(env["__p"]["ctx"], "beginPath", [])
		J.mc(env["__p"]["ctx"], "arc", [J.gp(v_o_4493, "x"), J.sub(J.gp(v_o_4493, "y"), J.mul(J.gp(J.gp(v_o_4493, "d"), "h"), 0.5)), J.mul(J.gp(J.gp(v_o_4493, "d"), "h"), 0.55), 0.0, 7.0])
		J.mc(env["__p"]["ctx"], "stroke", [])

func _f746(this_, a: Array, env):
	var v_lx_4512 = null; var v_k_4513 = null
	v_lx_4512 = J.arg(a, 0)
	v_k_4513 = J.arg(a, 1)
	J.mc(env["__p"]["ctx"], "beginPath", [])
	J.mc(env["__p"]["ctx"], "moveTo", [v_lx_4512, (-8.0)])
	J.mc(env["__p"]["ctx"], "lineTo", [J.add(v_lx_4512, (sin(J.num(J.add(J.mul(J.gp(env["__p"]["G"], "t"), 20.0), v_k_4513))) * 4.0)), 0.0])
	J.mc(env["__p"]["ctx"], "stroke", [])

func _f745(this_, a: Array, env):
	var v_s_4496 = null; var v_H_4497 = null; var v_HHt_4498 = null; var v_sw_4499 = null; var v_bg_4500 = null; var v_bob_4501 = null; var v_fl_4502 = null; var v_mx_4503 = null; var v_my_4504 = null; var v_mg_4505 = null; var v_na_4506 = null; var v_q_4507 = null; var v_lab_4508 = null; var v_bb_4509 = null
	v_s_4496 = J.arg(a, 0)
	v_H_4497 = J.gp(env["__p"]["HUM"], J.gp(v_s_4496, "kind"))
	v_HHt_4498 = (J.mc(env["__p"]["PPLFX"], "hgt", [J.gp(v_H_4497, "spr"), J.gp(v_H_4497, "spr"), J.gp(v_H_4497, "h")]) if J.t(J.gp(v_H_4497, "spr")) else J.gp(v_H_4497, "h"))
	var _t4981 = J.gp(v_s_4496, "alertT")
	var _t4982 = J.gp(v_s_4496, "alertT")
	var _t4983 = J.max_([0.0, J.sub((_t4982 if J.t(_t4982) else 0.0), 0.0)])
	J.sp(v_s_4496, "alertT", _t4983)
	var _t4984 = J.seq(J.gp(v_s_4496, "kind"), "guard")
	if (_t4984 if _t4984 else J.seq(J.gp(v_s_4496, "kind"), "compass")):
		v_sw_4499 = (((sin(J.num(J.add(J.mul(J.gp(env["__p"]["G"], "t"), 23.0), J.gp(v_s_4496, "x")))) * 46.0) + (sin(J.num(J.mul(J.gp(env["__p"]["G"], "t"), 37.0))) * 18.0)) if J.seq(J.gp(v_s_4496, "state"), "scared") else (sin(J.num((J.mul(J.gp(env["__p"]["G"], "t"), 2.4) + J.mul(J.gp(v_s_4496, "x"), 0.01)))) * 14.0))
		v_bg_4500 = J.mc(env["__p"]["ctx"], "createLinearGradient", [J.gp(v_s_4496, "x"), 0.0, J.add(J.gp(v_s_4496, "x"), J.mul(J.gp(v_s_4496, "dir"), 150.0)), 0.0])
		var _t4985 = J.seq(J.gp(v_s_4496, "state"), "chase")
		J.mc(v_bg_4500, "addColorStop", [0.0, (J.add("rgba(255,245,180,", ((0.45 if (_t4985 if _t4985 else J.seq(J.gp(v_s_4496, "kind"), "compass")) else 0.3) * ((0.4 + (0.6 * absf(J.num(sin(J.num(J.mul(J.gp(env["__p"]["G"], "t"), 29.0))))))) if J.seq(J.gp(v_s_4496, "state"), "scared") else 1.0))) + ")")])
		J.mc(v_bg_4500, "addColorStop", [1.0, "rgba(255,245,180,0)"])
		var _t4986 = env["__p"]["ctx"]
		J.sp(_t4986, "fillStyle", v_bg_4500)
		J.mc(env["__p"]["ctx"], "beginPath", [])
		J.mc(env["__p"]["ctx"], "moveTo", [J.add(J.gp(v_s_4496, "x"), J.mul(J.gp(v_s_4496, "dir"), 8.0)), J.sub(J.gp(v_s_4496, "y"), 30.0)])
		J.mc(env["__p"]["ctx"], "lineTo", [J.add(J.gp(v_s_4496, "x"), J.mul(J.gp(v_s_4496, "dir"), 150.0)), J.add(J.sub(J.gp(v_s_4496, "y"), 56.0), v_sw_4499)])
		J.mc(env["__p"]["ctx"], "lineTo", [J.add(J.gp(v_s_4496, "x"), J.mul(J.gp(v_s_4496, "dir"), 150.0)), (J.sub(J.gp(v_s_4496, "y"), 4.0) + J.mul(v_sw_4499, 0.4))])
		J.mc(env["__p"]["ctx"], "closePath", [])
		J.mc(env["__p"]["ctx"], "fill", [])
	var _t4987 = env["__p"]["ctx"]
	J.sp(_t4987, "fillStyle", "rgba(0,0,0,0.45)")
	J.mc(env["__p"]["ctx"], "beginPath", [])
	J.mc(env["__p"]["ctx"], "ellipse", [J.gp(v_s_4496, "x"), J.sub(J.gp(v_s_4496, "y"), 1.0), 16.0, 4.0, 0.0, 0.0, 7.0])
	J.mc(env["__p"]["ctx"], "fill", [])
	var _t4989 = null
	if J.seq(J.gp(v_s_4496, "kind"), "dog"):
		_t4989 = ((-absf(J.num(sin(J.num(J.add(J.mul(J.gp(env["__p"]["G"], "t"), 18.0), J.gp(v_s_4496, "x"))))))) * 5.0)
	else:
		var _t4988 = env["__p"]["pplStep"]
		_t4989 = J.cl(_t4988, null, [v_s_4496])
	v_bob_4501 = _t4989
	v_fl_4502 = (J.cmp(J.gp(v_s_4496, "vx"), 0.0, "<") if J.seq(J.gp(v_s_4496, "state"), "flee") else J.cmp(J.gp(v_s_4496, "dir"), 0.0, "<"))
	if J.seq(J.gp(v_s_4496, "kind"), "dog"):
		J.mc(env["__p"]["ctx"], "save", [])
		J.mc(env["__p"]["ctx"], "translate", [J.gp(v_s_4496, "x"), J.add(J.gp(v_s_4496, "y"), v_bob_4501)])
		J.mc(env["__p"]["ctx"], "scale", [((-1.0) if J.t(v_fl_4502) else 1.0), 1.0])
		var _t4990 = env["__p"]["ctx"]
		J.sp(_t4990, "fillStyle", "#3a2e24")
		var _t4991 = env["__p"]["ctx"]
		J.sp(_t4991, "strokeStyle", "#e8d8b0")
		var _t4992 = env["__p"]["ctx"]
		J.sp(_t4992, "lineWidth", 1.5)
		J.mc(env["__p"]["ctx"], "beginPath", [])
		J.mc(env["__p"]["ctx"], "ellipse", [0.0, (-14.0), 20.0, 9.0, 0.0, 0.0, 7.0])
		J.mc(env["__p"]["ctx"], "fill", [])
		J.mc(env["__p"]["ctx"], "stroke", [])
		J.mc(env["__p"]["ctx"], "beginPath", [])
		J.mc(env["__p"]["ctx"], "ellipse", [18.0, (-22.0), 9.0, 7.0, 0.0, 0.0, 7.0])
		J.mc(env["__p"]["ctx"], "fill", [])
		J.mc(env["__p"]["ctx"], "stroke", [])
		var _t4993 = env["__p"]["ctx"]
		J.sp(_t4993, "fillStyle", "#ff4a3a")
		J.mc(env["__p"]["ctx"], "fillRect", [21.0, (-25.0), 3.0, 3.0])
		var _t4994 = env["__p"]["ctx"]
		J.sp(_t4994, "strokeStyle", "#3a2e24")
		var _t4995 = env["__p"]["ctx"]
		J.sp(_t4995, "lineWidth", 3.0)
		var _t4996 = [(-12.0), (-4.0), 6.0, 12.0]
		J.mc(_t4996, "forEach", [Callable(self, "_f746").bind(env)])
		J.mc(env["__p"]["ctx"], "beginPath", [])
		J.mc(env["__p"]["ctx"], "moveTo", [(-19.0), (-16.0)])
		J.mc(env["__p"]["ctx"], "lineTo", [(-28.0), ((-24.0) + (sin(J.num(J.mul(J.gp(env["__p"]["G"], "t"), 25.0))) * 3.0))])
		J.mc(env["__p"]["ctx"], "stroke", [])
		J.mc(env["__p"]["ctx"], "restore", [])
	else:
		var _t4997 = env["__p"]["ctx"]
		var _t4998 = J.seq(J.gp(v_s_4496, "kind"), "mirror")
		var _t4999 = ("rgba(255,215,90,0.8)" if (_t4998 if _t4998 else J.seq(J.gp(v_s_4496, "kind"), "decoy")) else "rgba(255,236,200,0.75)")
		J.sp(_t4997, "shadowColor", _t4999)
		var _t5000 = env["__p"]["ctx"]
		J.sp(_t5000, "shadowBlur", 6.0)
		var _t5001 = env["__p"]["pplGuard"]
		J.cl(_t5001, null, [v_s_4496, v_H_4497, v_bob_4501, v_fl_4502])
		var _t5002 = env["__p"]["ctx"]
		J.sp(_t5002, "shadowBlur", 0.0)
	if J.seq(J.gp(v_s_4496, "kind"), "mirror"):
		v_mx_4503 = J.add(J.gp(v_s_4496, "x"), J.mul(J.gp(v_s_4496, "dir"), 14.0))
		v_my_4504 = J.sub(J.gp(v_s_4496, "y"), 40.0)
		var _t5003 = env["__p"]["ctx"]
		J.sp(_t5003, "fillStyle", "#d8c070")
		J.mc(env["__p"]["ctx"], "beginPath", [])
		J.mc(env["__p"]["ctx"], "arc", [v_mx_4503, v_my_4504, 8.0, 0.0, 7.0])
		J.mc(env["__p"]["ctx"], "fill", [])
		var _t5004 = env["__p"]["ctx"]
		var _t5005 = (J.add("rgba(220,245,255,", (0.6 + (0.3 * sin(J.num(J.mul(J.gp(env["__p"]["G"], "t"), 6.0)))))) + ")")
		J.sp(_t5004, "fillStyle", _t5005)
		J.mc(env["__p"]["ctx"], "beginPath", [])
		J.mc(env["__p"]["ctx"], "arc", [v_mx_4503, v_my_4504, 5.5, 0.0, 7.0])
		J.mc(env["__p"]["ctx"], "fill", [])
		v_mg_4505 = J.mc(env["__p"]["ctx"], "createLinearGradient", [v_mx_4503, 0.0, J.add(v_mx_4503, J.mul(J.gp(v_s_4496, "dir"), 220.0)), 0.0])
		J.mc(v_mg_4505, "addColorStop", [0.0, "rgba(220,245,255,0.25)"])
		J.mc(v_mg_4505, "addColorStop", [1.0, "rgba(220,245,255,0)"])
		var _t5006 = env["__p"]["ctx"]
		J.sp(_t5006, "fillStyle", v_mg_4505)
		J.mc(env["__p"]["ctx"], "beginPath", [])
		J.mc(env["__p"]["ctx"], "moveTo", [v_mx_4503, v_my_4504])
		J.mc(env["__p"]["ctx"], "lineTo", [J.add(v_mx_4503, J.mul(J.gp(v_s_4496, "dir"), 220.0)), J.sub(v_my_4504, 26.0)])
		J.mc(env["__p"]["ctx"], "lineTo", [J.add(v_mx_4503, J.mul(J.gp(v_s_4496, "dir"), 220.0)), J.add(v_my_4504, 26.0)])
		J.mc(env["__p"]["ctx"], "closePath", [])
		J.mc(env["__p"]["ctx"], "fill", [])
	if J.seq(J.gp(v_s_4496, "kind"), "compass"):
		var _t5007 = env["__p"]["ctx"]
		J.sp(_t5007, "fillStyle", "#c8a050")
		J.mc(env["__p"]["ctx"], "beginPath", [])
		J.mc(env["__p"]["ctx"], "arc", [J.add(J.gp(v_s_4496, "x"), J.mul(J.gp(v_s_4496, "dir"), 12.0)), J.sub(J.gp(v_s_4496, "y"), 30.0), 6.0, 0.0, 7.0])
		J.mc(env["__p"]["ctx"], "fill", [])
		var _t5008 = env["__p"]["ctx"]
		J.sp(_t5008, "strokeStyle", "#600")
		var _t5009 = env["__p"]["ctx"]
		J.sp(_t5009, "lineWidth", 1.5)
		v_na_4506 = J.mul(J.gp(env["__p"]["G"], "t"), 7.0)
		J.mc(env["__p"]["ctx"], "beginPath", [])
		J.mc(env["__p"]["ctx"], "moveTo", [J.add(J.gp(v_s_4496, "x"), J.mul(J.gp(v_s_4496, "dir"), 12.0)), J.sub(J.gp(v_s_4496, "y"), 30.0)])
		J.mc(env["__p"]["ctx"], "lineTo", [J.add(J.add(J.gp(v_s_4496, "x"), J.mul(J.gp(v_s_4496, "dir"), 12.0)), (cos(J.num(v_na_4506)) * 5.0)), (J.sub(J.gp(v_s_4496, "y"), 30.0) + (sin(J.num(v_na_4506)) * 5.0))])
		J.mc(env["__p"]["ctx"], "stroke", [])
		v_q_4507 = 0.0
		while true:
			if not J.cmp(v_q_4507, J.gp(v_s_4496, "courage"), "<"): break
			var _t5010 = env["__p"]["ctx"]
			J.sp(_t5010, "fillStyle", "#ffd54a")
			J.mc(env["__p"]["ctx"], "fillRect", [(J.sub(J.gp(v_s_4496, "x"), 12.0) + J.mul(v_q_4507, 5.0)), (J.sub(J.gp(v_s_4496, "y"), v_HHt_4498) - 10.0), 4.0, 4.0])
			v_q_4507 = J.num(v_q_4507) + 1.0
	v_lab_4508 = J.gp(v_H_4497, "n")
	var _t5011 = env["__p"]["ctx"]
	var _t5012 = J.add("bold 11px ", env["__p"]["FONT"])
	J.sp(_t5011, "font", _t5012)
	var _t5013 = env["__p"]["ctx"]
	J.sp(_t5013, "textAlign", "center")
	var _t5014 = env["__p"]["ctx"]
	J.sp(_t5014, "lineWidth", 3.0)
	var _t5015 = env["__p"]["ctx"]
	J.sp(_t5015, "strokeStyle", "#000")
	J.mc(env["__p"]["ctx"], "strokeText", [v_lab_4508, J.gp(v_s_4496, "x"), (J.sub(J.gp(v_s_4496, "y"), v_HHt_4498) - 14.0)])
	var _t5016 = env["__p"]["ctx"]
	var _t5017 = ("#e8e4dc" if J.seq(J.gp(v_s_4496, "kind"), "guard") else "#ffe9a0")
	J.sp(_t5016, "fillStyle", _t5017)
	J.mc(env["__p"]["ctx"], "fillText", [v_lab_4508, J.gp(v_s_4496, "x"), (J.sub(J.gp(v_s_4496, "y"), v_HHt_4498) - 14.0)])
	if J.cmp(J.gp(v_s_4496, "alertT"), 0.0, ">"):
		var _t5018 = env["__p"]["ctx"]
		J.sp(_t5018, "fillStyle", "#ffe25a")
		var _t5019 = env["__p"]["ctx"]
		J.sp(_t5019, "strokeStyle", "#000")
		var _t5020 = env["__p"]["ctx"]
		J.sp(_t5020, "lineWidth", 3.0)
		var _t5021 = env["__p"]["ctx"]
		var _t5022 = J.add("bold 26px ", env["__p"]["FONT"])
		J.sp(_t5021, "font", _t5022)
		var _t5023 = env["__p"]["ctx"]
		J.sp(_t5023, "textAlign", "center")
		v_bb_4509 = (sin(J.num(J.mul(J.gp(env["__p"]["G"], "t"), 20.0))) * 2.0)
		J.mc(env["__p"]["ctx"], "strokeText", ["！", J.gp(v_s_4496, "x"), J.add((J.sub(J.gp(v_s_4496, "y"), v_HHt_4498) - 24.0), v_bb_4509)])
		J.mc(env["__p"]["ctx"], "fillText", ["！", J.gp(v_s_4496, "x"), J.add((J.sub(J.gp(v_s_4496, "y"), v_HHt_4498) - 24.0), v_bb_4509)])
	if J.t(J.gp(v_s_4496, "say")):
		var _t5024 = env["__p"]["bubble"]
		J.cl(_t5024, null, [J.gp(v_s_4496, "x"), (J.sub(J.gp(v_s_4496, "y"), v_HHt_4498) - 30.0), J.gp(v_s_4496, "say")])

func _f748(this_, a: Array, env):
	var v_k_4531 = null
	v_k_4531 = J.arg(a, 0)
	if (not J.t(J.gp(env["cnt"], v_k_4531))):
		var _t5067 = env["cnt"]
		J.sp(_t5067, v_k_4531, 0.0)
		J.mc(env["ord"], "push", [v_k_4531])
	var _t5068 = env["cnt"]
	J.sp(_t5068, v_k_4531, J.num(J.gp(_t5068, v_k_4531)) + 1.0)

func _f749(this_, a: Array, env):
	var v_k_4534 = null
	v_k_4534 = J.arg(a, 0)
	return J.add(J.gp(J.gp(env["__p"]["__p"]["ITEM"], v_k_4534), "n"), (J.add("×", J.gp(env["cnt"], v_k_4534)) if J.cmp(J.gp(env["cnt"], v_k_4534), 1.0, ">") else ""))

func _f747(this_, a: Array, env):
	var v_u_4516 = null; var v_top_4517 = null; var v_w_4518 = null; var v_hgt_4519 = null; var v_cx_4520 = null; var v_cy_4521 = null; var v_tx_4522 = null; var v_dx_4523 = null; var v_a_4524 = null; var v_ix_4525 = null; var v_tt_4528 = null
	var _s1823 = {"__p": env, "cnt": null, "ord": null}
	v_u_4516 = J.arg(a, 0)
	var _t5028 = _s1823["__p"]["__p"]["fy"]
	v_top_4517 = J.add(J.cl(_t5028, null, [J.add(J.gp(v_u_4516, "f"), 1.0)]), 16.0)
	v_w_4518 = J.sub(J.gp(J.gp(v_u_4516, "rx"), 1.0), J.gp(J.gp(v_u_4516, "rx"), 0.0))
	v_hgt_4519 = (J.sub(J.gp(v_u_4516, "y"), v_top_4517) - 4.0)
	var _t5029 = J.cmp(J.gp(v_u_4516, "y"), J.gp(_s1823["__p"]["__p"]["CULL"], "y0"), "<")
	if (_t5029 if _t5029 else J.cmp(v_top_4517, J.gp(_s1823["__p"]["__p"]["CULL"], "y1"), ">")):
		return null
	if (not J.t(J.gp(v_u_4516, "seen"))):
		var _t5030 = _s1823["__p"]["__p"]["ctx"]
		var _t5031 = (J.add("rgba(2,2,4,", (0.82 if J.t(J.gp(v_u_4516, "open")) else 0.9)) + ")")
		J.sp(_t5030, "fillStyle", _t5031)
		J.mc(_s1823["__p"]["__p"]["ctx"], "fillRect", [J.gp(J.gp(v_u_4516, "rx"), 0.0), v_top_4517, v_w_4518, v_hgt_4519])
		if J.cmp(J.gp(v_u_4516, "unlockFx"), 0.0, ">"):
			var _t5032 = _s1823["__p"]["__p"]["ctx"]
			var _t5033 = (J.add("rgba(159,214,191,", J.gp(v_u_4516, "unlockFx")) + ")")
			J.sp(_t5032, "strokeStyle", _t5033)
			var _t5034 = _s1823["__p"]["__p"]["ctx"]
			J.sp(_t5034, "lineWidth", 3.0)
			J.mc(_s1823["__p"]["__p"]["ctx"], "strokeRect", [J.add(J.gp(J.gp(v_u_4516, "rx"), 0.0), 2.0), J.add(v_top_4517, 2.0), J.sub(v_w_4518, 4.0), J.sub(v_hgt_4519, 4.0)])
	var _t5035 = (not J.t(J.gp(v_u_4516, "open")))
	if ((not J.seq(J.gp(v_u_4516, "ot"), "deity")) if _t5035 else _t5035):
		v_cx_4520 = J.div(J.add(J.gp(J.gp(v_u_4516, "rx"), 0.0), J.gp(J.gp(v_u_4516, "rx"), 1.0)), 2.0)
		v_cy_4521 = J.add(v_top_4517, J.mul(v_hgt_4519, 0.5))
		var _t5036 = _s1823["__p"]["__p"]["ctx"]
		J.sp(_t5036, "fillStyle", "rgba(0,0,0,0.6)")
		J.mc(_s1823["__p"]["__p"]["ctx"], "beginPath", [])
		J.mc(_s1823["__p"]["__p"]["ctx"], "arc", [v_cx_4520, v_cy_4521, 20.0, 0.0, 7.0])
		J.mc(_s1823["__p"]["__p"]["ctx"], "fill", [])
		var _t5037 = _s1823["__p"]["__p"]["ctx"]
		J.sp(_t5037, "strokeStyle", "#c8a050")
		var _t5038 = _s1823["__p"]["__p"]["ctx"]
		J.sp(_t5038, "lineWidth", 2.5)
		J.mc(_s1823["__p"]["__p"]["ctx"], "beginPath", [])
		J.mc(_s1823["__p"]["__p"]["ctx"], "arc", [v_cx_4520, J.sub(v_cy_4521, 5.0), 6.0, PI, 0.0])
		J.mc(_s1823["__p"]["__p"]["ctx"], "stroke", [])
		var _t5039 = _s1823["__p"]["__p"]["ctx"]
		J.sp(_t5039, "fillStyle", "#c8a050")
		J.mc(_s1823["__p"]["__p"]["ctx"], "fillRect", [J.sub(v_cx_4520, 8.0), J.sub(v_cy_4521, 4.0), 16.0, 12.0])
		v_tx_4522 = (J.add((J.add("破鎮宅 ", J.gp(v_u_4516, "paid")) + "/"), J.gp(v_u_4516, "cost")) if J.seq(J.gp(v_u_4516, "ot"), 2.0) else ("要鎖匙" if J.seq(J.gp(v_u_4516, "ot"), 11.0) else "隔籬未亂"))
		var _t5040 = _s1823["__p"]["__p"]["ctx"]
		var _t5041 = J.add("bold 11px ", _s1823["__p"]["__p"]["FONT"])
		J.sp(_t5040, "font", _t5041)
		var _t5042 = _s1823["__p"]["__p"]["ctx"]
		J.sp(_t5042, "textAlign", "center")
		var _t5043 = _s1823["__p"]["__p"]["ctx"]
		J.sp(_t5043, "lineWidth", 3.0)
		var _t5044 = _s1823["__p"]["__p"]["ctx"]
		J.sp(_t5044, "strokeStyle", "#000")
		J.mc(_s1823["__p"]["__p"]["ctx"], "strokeText", [v_tx_4522, v_cx_4520, J.add(v_cy_4521, 30.0)])
		var _t5045 = _s1823["__p"]["__p"]["ctx"]
		J.sp(_t5045, "fillStyle", "#ffe9a0")
		J.mc(_s1823["__p"]["__p"]["ctx"], "fillText", [v_tx_4522, v_cx_4520, J.add(v_cy_4521, 30.0)])
		var _t5046 = J.seq(J.gp(v_u_4516, "ot"), 2.0)
		if (J.cmp(J.gp(v_u_4516, "paid"), 0.0, ">") if _t5046 else _t5046):
			var _t5047 = _s1823["__p"]["__p"]["ctx"]
			J.sp(_t5047, "strokeStyle", "#9fd6bf")
			var _t5048 = _s1823["__p"]["__p"]["ctx"]
			J.sp(_t5048, "lineWidth", 4.0)
			J.mc(_s1823["__p"]["__p"]["ctx"], "beginPath", [])
			J.mc(_s1823["__p"]["__p"]["ctx"], "arc", [v_cx_4520, v_cy_4521, 24.0, J.div((-PI), 2.0), (J.div((-PI), 2.0) + J.div(J.mul((PI * 2.0), J.gp(v_u_4516, "paid")), J.gp(v_u_4516, "cost")))])
			J.mc(_s1823["__p"]["__p"]["ctx"], "stroke", [])
	if J.t(J.gp(v_u_4516, "door")):
		v_dx_4523 = J.gp(v_u_4516, "x")
		v_a_4524 = (0.25 if J.cmp(J.gp(v_u_4516, "doorOpen"), 0.0, ">") else 1.0)
		var _t5049 = _s1823["__p"]["__p"]["ctx"]
		J.sp(_t5049, "globalAlpha", v_a_4524)
		var _t5050 = _s1823["__p"]["__p"]["ctx"]
		J.sp(_t5050, "fillStyle", "#4a3020")
		J.mc(_s1823["__p"]["__p"]["ctx"], "fillRect", [J.sub(v_dx_4523, 12.0), J.sub(J.gp(v_u_4516, "y"), 62.0), 24.0, 58.0])
		var _t5051 = _s1823["__p"]["__p"]["ctx"]
		J.sp(_t5051, "strokeStyle", "#c8a050")
		var _t5052 = _s1823["__p"]["__p"]["ctx"]
		J.sp(_t5052, "lineWidth", 2.0)
		J.mc(_s1823["__p"]["__p"]["ctx"], "strokeRect", [J.sub(v_dx_4523, 12.0), J.sub(J.gp(v_u_4516, "y"), 62.0), 24.0, 58.0])
		var _t5053 = _s1823["__p"]["__p"]["ctx"]
		J.sp(_t5053, "fillStyle", "#c8a050")
		J.mc(_s1823["__p"]["__p"]["ctx"], "fillRect", [J.add(v_dx_4523, 6.0), J.sub(J.gp(v_u_4516, "y"), 34.0), 3.0, 3.0])
		var _t5054 = _s1823["__p"]["__p"]["ctx"]
		J.sp(_t5054, "globalAlpha", 1.0)
		if J.cmp(J.gp(v_u_4516, "doorOpen"), 0.0, ">"):
			var _t5055 = _s1823["__p"]["__p"]["ctx"]
			J.sp(_t5055, "fillStyle", "#9fd6bf")
			var _t5056 = _s1823["__p"]["__p"]["ctx"]
			var _t5057 = J.add("bold 11px ", _s1823["__p"]["__p"]["FONT"])
			J.sp(_t5056, "font", _t5057)
			var _t5058 = _s1823["__p"]["__p"]["ctx"]
			J.sp(_t5058, "textAlign", "center")
			J.mc(_s1823["__p"]["__p"]["ctx"], "fillText", ["門開咗！", v_dx_4523, J.sub(J.gp(v_u_4516, "y"), 68.0)])
	var _t5059 = J.gp(v_u_4516, "seen")
	var _t5060 = (J.len(J.gp(v_u_4516, "items")) if J.t(_t5059) else _t5059)
	if J.t((J.gp(v_u_4516, "open") if J.t(_t5060) else _t5060)):
		v_ix_4525 = J.div(J.add(J.gp(J.gp(v_u_4516, "rx"), 0.0), J.gp(J.gp(v_u_4516, "rx"), 1.0)), 2.0)
		var _t5061 = _s1823["__p"]["__p"]["ctx"]
		var _t5062 = J.add("10px ", _s1823["__p"]["__p"]["FONT"])
		J.sp(_t5061, "font", _t5062)
		var _t5063 = _s1823["__p"]["__p"]["ctx"]
		J.sp(_t5063, "textAlign", "center")
		var _t5064 = _s1823["__p"]["__p"]["ctx"]
		J.sp(_t5064, "lineWidth", 3.0)
		var _t5065 = _s1823["__p"]["__p"]["ctx"]
		J.sp(_t5065, "strokeStyle", "#000")
		_s1823["cnt"] = {}
		_s1823["ord"] = []
		var _t5066 = J.gp(v_u_4516, "items")
		J.mc(_t5066, "forEach", [Callable(self, "_f748").bind(_s1823)])
		var _t5069 = J.mc(_s1823["ord"], "map", [Callable(self, "_f749").bind(_s1823)])
		v_tt_4528 = J.mc(_t5069, "join", [" "])
		J.mc(_s1823["__p"]["__p"]["ctx"], "strokeText", [v_tt_4528, v_ix_4525, J.add(v_top_4517, 28.0)])
		var _t5070 = _s1823["__p"]["__p"]["ctx"]
		J.sp(_t5070, "fillStyle", "#e8d8b0")
		J.mc(_s1823["__p"]["__p"]["ctx"], "fillText", [v_tt_4528, v_ix_4525, J.add(v_top_4517, 28.0)])

func _f750(this_, a: Array, env):
	var v_o_4537 = null; var v_i_4538 = null; var v_n_4539 = null; var v_inside_4540 = null; var v_hang_4541 = null; var v_a_4542 = null; var v_T_4543 = null; var v_k_4544 = null; var v_ox_4545 = null; var v_oy_4546 = null; var v_ro_4547 = null; var v_sx_4548 = null; var v_sy_4549 = null; var v_key_4550 = null; var v_by_4551 = null; var v_st_4552 = null; var v_c_4553 = null; var v_h_4554 = null; var v_q_4555 = null; var v_hs_4556 = null; var v_hx_4557 = null; var v_bp_4558 = null; var v_fq_4559 = null; var v_na_4560 = null; var v_nb_4561 = null; var v_na2_4562 = null; var v_nb2_4563 = null; var v_ceil2_4564 = null; var v_flo2_4565 = null; var v_dq_4566 = null; var v_u2_4567 = null; var v_u3_4568 = null; var v_w2_4569 = null; var v_down_4570 = null; var v_cy0_4571 = null; var v_fa_4572 = null
	v_o_4537 = J.arg(a, 0)
	v_i_4538 = J.arg(a, 1)
	var _t5076 = J.gp(v_o_4537, "home")
	if J.t((_t5076 if J.t(_t5076) else J.gp(v_o_4537, "out"))):
		return null
	v_n_4539 = J.gp(J.gp(env["__p"]["G"], "nodes"), J.gp(v_o_4537, "node"))
	var _t5077 = J.seq(J.gp(v_n_4539, "kind"), "in")
	v_inside_4540 = ((not J.t(J.gp(v_o_4537, "to"))) if _t5077 else _t5077)
	var _t5078 = J.seq(J.gp(J.gp(v_o_4537, "d"), "key"), "tianhua")
	v_hang_4541 = (v_inside_4540 if _t5078 else _t5078)
	v_a_4542 = (0.35 if J.cmp(J.gp(v_o_4537, "inv"), 0.0, ">") else (1.0 if J.seq(v_i_4538, J.gp(env["__p"]["G"], "active")) else 0.75))
	var _t5079 = J.cmp(J.gp(v_o_4537, "stun"), 0.0, ">")
	var _t5080 = ((not J.cmp(J.gp(v_o_4537, "countT"), 0.0, ">")) if _t5079 else _t5079)
	if ((not J.cmp(J.gp(v_o_4537, "dropT"), 0.0, ">")) if _t5080 else _t5080):
		var _t5081 = J.mul(v_a_4542, (0.6 + (0.4 * sin(J.num(J.mul(J.gp(env["__p"]["G"], "t"), 30.0))))))
		v_a_4542 = _t5081
	if J.seq(v_i_4538, J.gp(env["__p"]["G"], "active")):
		var _t5082 = env["__p"]["ctx"]
		J.sp(_t5082, "fillStyle", "rgba(110,255,190,0.40)")
		J.mc(env["__p"]["ctx"], "beginPath", [])
		J.mc(env["__p"]["ctx"], "ellipse", [J.gp(v_o_4537, "x"), J.sub(J.gp(v_o_4537, "y"), 2.0), 24.0, 6.0, 0.0, 0.0, 7.0])
		J.mc(env["__p"]["ctx"], "fill", [])
	v_T_4543 = J.add(J.gp(env["__p"]["G"], "t"), J.gp(v_o_4537, "ph"))
	v_k_4544 = J.gp(J.gp(v_o_4537, "d"), "key")
	v_ox_4545 = 0.0
	v_oy_4546 = 0.0
	v_ro_4547 = 0.0
	v_sx_4548 = 1.0
	v_sy_4549 = 1.0
	v_key_4550 = ("tianhua_hang" if J.t(v_hang_4541) else J.gp(J.gp(v_o_4537, "d"), "sprite"))
	v_by_4551 = (J.sub(J.gp(v_o_4537, "y"), 50.0) if J.t(v_hang_4541) else J.gp(v_o_4537, "y"))
	if J.cmp(J.gp(v_o_4537, "countT"), 0.0, ">"):
		v_sy_4549 = 0.8
		v_oy_4546 = 3.0
		var _t5083 = (sin(J.num(J.mul(J.gp(env["__p"]["G"], "t"), 9.0))) * 0.1)
		v_ro_4547 = _t5083
	else:
		if J.t(J.gp(v_o_4537, "sc")):
			v_st_4552 = J.gp(J.gp(v_o_4537, "sc"), "t")
			if J.cmp(v_st_4552, env["__p"]["OMEN"], "<"):
				v_c_4553 = J.div(v_st_4552, env["__p"]["OMEN"])
				var _t5084 = ((1.0 - J.mul(0.08, v_c_4553)) + (0.03 * sin(J.num(J.mul(J.gp(env["__p"]["G"], "t"), 20.0)))))
				v_sy_4549 = _t5084
				v_sx_4548 = v_sy_4549
				var _t5085 = env["__p"]["ctx"]
				var _t5086 = J.add(J.add(J.gp({"eking": "rgba(210,90,40,", "toyol": "rgba(120,220,140,", "tianhua": "rgba(110,190,255,"}, v_k_4544), J.mul(0.25, v_c_4553)), ")")
				J.sp(_t5085, "fillStyle", _t5086)
				J.mc(env["__p"]["ctx"], "beginPath", [])
				J.mc(env["__p"]["ctx"], "arc", [J.gp(v_o_4537, "x"), J.sub(v_by_4551, J.mul(J.gp(J.gp(v_o_4537, "d"), "h"), 0.5)), (J.mul(J.gp(J.gp(v_o_4537, "d"), "h"), 0.6) * (0.6 + J.mul(0.4, v_c_4553))), 0.0, 7.0])
				J.mc(env["__p"]["ctx"], "fill", [])
			else:
				if J.cmp(v_st_4552, J.add(env["__p"]["OMEN"], env["__p"]["STRIKE"]), "<"):
					if J.seq(v_k_4544, "eking"):
						var _t5087 = (1.18 + (0.06 * sin(J.num(J.mul(J.gp(env["__p"]["G"], "t"), 30.0)))))
						v_sx_4548 = _t5087
						v_sy_4549 = 0.92
						var _t5088 = J.mul(J.gp(v_o_4537, "dir"), 0.1)
						v_ro_4547 = _t5088
					else:
						var _t5089 = J.mul(v_a_4542, 0.25)
						v_a_4542 = _t5089
				else:
					var _t5090 = J.mul(v_a_4542, (1.0 if J.seq(v_k_4544, "eking") else J.min_([1.0, (0.25 + J.div(J.sub(J.sub(v_st_4552, env["__p"]["OMEN"]), env["__p"]["STRIKE"]), env["__p"]["AFTER"]))])))
					v_a_4542 = _t5090
		else:
			if J.cmp(J.gp(v_o_4537, "hitT"), 0.0, ">"):
				v_h_4554 = J.div(J.gp(v_o_4537, "hitT"), 0.8)
				var _t5091 = J.gp(v_o_4537, "hitDir")
				var _t5093 = (((-J.num((_t5091 if J.t(_t5091) else 1.0))) * J.sub(1.0, v_h_4554)) * 0.0)
				var _t5092 = J.gp(v_o_4537, "hitDir")
				var _t5094 = (_t5093 + (J.mul((_t5092 if J.t(_t5092) else 1.0), v_h_4554) * 14.0))
				v_ox_4545 = _t5094
				var _t5095 = J.gp(v_o_4537, "hitDir")
				var _t5096 = J.mul(J.mul((_t5095 if J.t(_t5095) else 1.0), 0.25), v_h_4554)
				v_ro_4547 = _t5096
				var _t5097 = J.mul(v_a_4542, (0.5 + (0.5 * absf(J.num(sin(J.num(J.mul(J.gp(env["__p"]["G"], "t"), 35.0))))))))
				v_a_4542 = _t5097
			else:
				if J.cmp(J.gp(v_o_4537, "actT"), 0.0, ">"):
					v_q_4555 = (1.0 - J.div(J.gp(v_o_4537, "actT"), 0.9))
					if J.cmp(v_q_4555, 0.3, "<"):
						v_c_4553 = J.div(v_q_4555, 0.3)
						var _t5098 = (1.0 - J.mul(0.12, v_c_4553))
						v_sy_4549 = _t5098
						v_sx_4548 = v_sy_4549
						var _t5099 = J.mul(2.0, v_c_4553)
						v_oy_4546 = _t5099
						var _t5100 = J.mul(((-J.num(J.gp(v_o_4537, "dir"))) * 0.12), v_c_4553)
						v_ro_4547 = _t5100
						var _t5101 = env["__p"]["ctx"]
						var _t5102 = (J.add("rgba(200,30,30,", J.mul(0.35, v_c_4553)) + ")")
						J.sp(_t5101, "fillStyle", _t5102)
						J.mc(env["__p"]["ctx"], "beginPath", [])
						J.mc(env["__p"]["ctx"], "arc", [J.gp(v_o_4537, "x"), J.sub(v_by_4551, J.mul(J.gp(J.gp(v_o_4537, "d"), "h"), 0.5)), J.mul(J.gp(J.gp(v_o_4537, "d"), "h"), 0.7), 0.0, 7.0])
						J.mc(env["__p"]["ctx"], "fill", [])
					else:
						if J.cmp(v_q_4555, 0.6, "<"):
							v_c_4553 = J.div(J.sub(v_q_4555, 0.3), 0.3)
							var _t5103 = (0.88 + J.mul(0.55, v_c_4553))
							v_sy_4549 = _t5103
							v_sx_4548 = v_sy_4549
							var _t5104 = J.mul(J.mul(J.gp(v_o_4537, "dir"), 26.0), v_c_4553)
							v_ox_4545 = _t5104
							var _t5105 = J.mul(J.mul(J.gp(v_o_4537, "dir"), 0.15), v_c_4553)
							v_ro_4547 = _t5105
							if J.seq(v_k_4544, "tianhua"):
								var _t5106 = J.mul((-6.0), v_c_4553)
								v_oy_4546 = _t5106
						else:
							v_c_4553 = J.div(J.sub(v_q_4555, 0.6), 0.4)
							var _t5107 = (1.43 - J.mul(0.43, v_c_4553))
							v_sy_4549 = _t5107
							v_sx_4548 = v_sy_4549
							var _t5108 = (J.mul(J.gp(v_o_4537, "dir"), 26.0) * J.sub(1.0, v_c_4553))
							v_ox_4545 = _t5108
					var _t5109 = J.cmp(v_q_4555, 0.3, ">")
					var _t5110 = (J.cmp(v_q_4555, 0.75, "<") if _t5109 else _t5109)
					if (J.seq(v_k_4544, "tianhua") if _t5110 else _t5110):
						var _t5111 = env["__p"]["ctx"]
						J.sp(_t5111, "strokeStyle", "rgba(20,20,24,0.85)")
						var _t5112 = env["__p"]["ctx"]
						J.sp(_t5112, "lineWidth", 2.0)
						v_hs_4556 = 0.0
						while true:
							if not J.cmp(v_hs_4556, 9.0, "<"): break
							v_hx_4557 = J.add(J.gp(v_o_4537, "x"), J.mul(J.gp(v_o_4537, "dir"), (10.0 + J.mul(v_hs_4556, 5.0))))
							J.mc(env["__p"]["ctx"], "beginPath", [])
							J.mc(env["__p"]["ctx"], "moveTo", [v_hx_4557, J.sub(v_by_4551, J.gp(J.gp(v_o_4537, "d"), "h"))])
							J.mc(env["__p"]["ctx"], "quadraticCurveTo", [J.add(v_hx_4557, (sin(J.num(J.add(J.mul(J.gp(env["__p"]["G"], "t"), 9.0), v_hs_4556))) * 6.0)), J.sub(v_by_4551, J.mul(J.gp(J.gp(v_o_4537, "d"), "h"), 0.4)), J.add(v_hx_4557, (sin(J.num(J.add(J.mul(J.gp(env["__p"]["G"], "t"), 7.0), v_hs_4556))) * 4.0)), J.add(v_by_4551, 4.0)])
							J.mc(env["__p"]["ctx"], "stroke", [])
							v_hs_4556 = J.num(v_hs_4556) + 1.0
				else:
					if J.cmp(J.gp(v_o_4537, "taskP"), 0.0, ">"):
						if J.seq(v_k_4544, "eking"):
							var _t5113 = (1.0 + (0.09 * sin(J.num(J.mul(J.gp(env["__p"]["G"], "t"), 18.0)))))
							v_sy_4549 = _t5113
							var _t5114 = (1.0 - (0.05 * sin(J.num(J.mul(J.gp(env["__p"]["G"], "t"), 18.0)))))
							v_sx_4548 = _t5114
						else:
							if J.seq(v_k_4544, "toyol"):
								var _t5115 = (sin(J.num(J.mul(J.gp(env["__p"]["G"], "t"), 20.0))) * 0.14)
								v_ro_4547 = _t5115
								var _t5116 = ((-absf(J.num(sin(J.num(J.mul(J.gp(env["__p"]["G"], "t"), 10.0)))))) * 3.0)
								v_oy_4546 = _t5116
							else:
								var _t5117 = (sin(J.num(J.mul(J.gp(env["__p"]["G"], "t"), 5.0))) * 0.08)
								v_ro_4547 = _t5117
						if J.seq(v_k_4544, "tianhua"):
							var _t5118 = env["__p"]["ctx"]
							J.sp(_t5118, "strokeStyle", "rgba(30,30,34,0.8)")
							var _t5119 = env["__p"]["ctx"]
							J.sp(_t5119, "lineWidth", 1.5)
							v_hs_4556 = 0.0
							while true:
								if not J.cmp(v_hs_4556, 6.0, "<"): break
								v_hx_4557 = (J.sub(J.gp(v_o_4537, "x"), 8.0) + J.mul(v_hs_4556, 3.0))
								J.mc(env["__p"]["ctx"], "beginPath", [])
								J.mc(env["__p"]["ctx"], "moveTo", [v_hx_4557, J.sub(v_by_4551, J.mul(J.gp(J.gp(v_o_4537, "d"), "h"), 0.2))])
								J.mc(env["__p"]["ctx"], "lineTo", [J.add(v_hx_4557, (sin(J.num(J.add(J.mul(J.gp(env["__p"]["G"], "t"), 4.0), v_hs_4556))) * 3.0)), J.add(J.add(v_by_4551, 16.0), (J.mod(v_hs_4556, 2.0) * 6.0))])
								J.mc(env["__p"]["ctx"], "stroke", [])
								v_hs_4556 = J.num(v_hs_4556) + 1.0
					else:
						if J.cmp(J.gp(v_o_4537, "mv"), 0.0, ">"):
							if J.seq(v_k_4544, "eking"):
								var _t5120 = (sin(J.num(J.mul(v_T_4543, 8.0))) * 0.08)
								v_ro_4547 = _t5120
								var _t5121 = ((-absf(J.num(sin(J.num(J.mul(v_T_4543, 8.0)))))) * 2.0)
								v_oy_4546 = _t5121
								v_bp_4558 = sin(J.num(J.mul(v_T_4543, 9.0)))
								var _t5122 = (1.0 + J.mul(0.08, v_bp_4558))
								v_sx_4548 = _t5122
								var _t5123 = (1.0 - J.mul(0.035, v_bp_4558))
								v_sy_4549 = _t5123
							else:
								if J.seq(v_k_4544, "toyol"):
									var _t5124 = ((-absf(J.num(sin(J.num(J.mul(v_T_4543, 15.0)))))) * 7.0)
									v_oy_4546 = _t5124
									var _t5125 = (sin(J.num(J.mul(v_T_4543, 15.0))) * 0.13)
									v_ro_4547 = _t5125
									if J.cmp(J.gp(v_o_4537, "flipT"), 0.0, ">"):
										v_fq_4559 = (1.0 - J.div(J.gp(v_o_4537, "flipT"), 0.55))
										var _t5126 = J.mul((J.mul(J.gp(v_o_4537, "dir"), PI) * 2.0), v_fq_4559)
										v_ro_4547 = _t5126
										var _t5127 = (((-sin(J.num(J.mul(v_fq_4559, PI)))) * 22.0) - (J.mul(J.gp(J.gp(v_o_4537, "d"), "h"), 0.3) * sin(J.num(J.mul(v_fq_4559, PI)))))
										v_oy_4546 = _t5127
								else:
									v_na_4560 = J.gp(J.gp(env["__p"]["G"], "nodes"), J.gp(v_o_4537, "node"))
									v_nb_4561 = (J.gp(J.gp(env["__p"]["G"], "nodes"), J.gp(v_o_4537, "to")) if J.t(J.gp(v_o_4537, "to")) else v_na_4560)
									var _t5128 = J.seq(J.gp(v_na_4560, "f"), J.gp(v_nb_4561, "f"))
									var _t5129 = ((not J.seq(J.gp(v_na_4560, "kind"), "in")) if _t5128 else _t5128)
									if ((not J.seq(J.gp(v_nb_4561, "kind"), "in")) if _t5129 else _t5129):
										var _t5130 = env["__p"]["fy"]
										var _t5131 = J.add(J.cl(_t5130, null, [J.add(J.gp(v_na_4560, "f"), 1.0)]), 14.0)
										v_by_4551 = _t5131
										v_sy_4549 = (-1.0)
										var _t5132 = (sin(J.num(J.mul(v_T_4543, 10.0))) * 0.06)
										v_ro_4547 = _t5132
										var _t5133 = (sin(J.num(J.mul(v_T_4543, 10.0))) * 2.0)
										v_ox_4545 = _t5133
									else:
										var _t5134 = J.mul(J.gp(v_o_4537, "dir"), 0.12)
										v_ro_4547 = _t5134
										var _t5135 = ((-4.0) + (sin(J.num(J.mul(v_T_4543, 6.0))) * 3.0))
										v_oy_4546 = _t5135
						else:
							var _t5136 = ((sin(J.num(J.mul(v_T_4543, 2.5))) * 3.0) - (0.0 if J.seq(v_k_4544, "eking") else 3.0))
							v_oy_4546 = _t5136
							var _t5137 = (1.0 + (0.025 * sin(J.num(J.mul(v_T_4543, 2.5)))))
							v_sy_4549 = _t5137
	if J.cmp(J.gp(v_o_4537, "bounceT"), 0.0, ">"):
		var _t5138 = J.add(v_ox_4545, (((-J.num(J.gp(v_o_4537, "dir"))) * sin(J.num((J.div(J.gp(v_o_4537, "bounceT"), 0.45) * PI)))) * 12.0))
		v_ox_4545 = _t5138
	if J.seq(v_k_4544, "tianhua"):
		v_na2_4562 = J.gp(J.gp(env["__p"]["G"], "nodes"), J.gp(v_o_4537, "node"))
		v_nb2_4563 = (J.gp(J.gp(env["__p"]["G"], "nodes"), J.gp(v_o_4537, "to")) if J.t(J.gp(v_o_4537, "to")) else v_na2_4562)
		var _t5139 = env["__p"]["fy"]
		v_ceil2_4564 = J.add(J.cl(_t5139, null, [J.min_([env["__p"]["FL"], J.add(J.gp(v_na2_4562, "f"), 1.0)])]), 14.0)
		v_flo2_4565 = J.gp(v_o_4537, "y")
		if J.cmp(J.gp(v_o_4537, "dropT"), 0.0, ">"):
			v_key_4550 = J.gp(J.gp(v_o_4537, "d"), "sprite")
			v_dq_4566 = J.gp(v_o_4537, "dropT")
			if J.cmp(v_dq_4566, 2.05, ">"):
				v_u2_4567 = J.div(J.sub(2.3, v_dq_4566), 0.25)
				var _t5140 = J.add(v_ceil2_4564, J.mul(J.sub(v_flo2_4565, v_ceil2_4564), v_u2_4567))
				v_by_4551 = _t5140
				v_sy_4549 = 1.0
				v_sx_4548 = 1.0
				var _t5141 = (PI * J.sub(1.0, v_u2_4567))
				v_ro_4547 = _t5141
				v_oy_4546 = 0.0
				v_ox_4545 = 0.0
			else:
				if J.cmp(v_dq_4566, 0.5, "<"):
					v_u3_4568 = (1.0 - J.div(v_dq_4566, 0.5))
					var _t5142 = J.sub(v_flo2_4565, J.mul(J.sub(v_flo2_4565, v_ceil2_4564), v_u3_4568))
					v_by_4551 = _t5142
					v_sy_4549 = 1.0
					v_sx_4548 = 1.0
					v_ro_4547 = 0.0
					var _t5143 = (sin(J.num(J.mul(J.gp(env["__p"]["G"], "t"), 30.0))) * 1.5)
					v_ox_4545 = _t5143
				else:
					v_by_4551 = v_flo2_4565
					v_sy_4549 = 1.0
					v_sx_4548 = 1.0
					var _t5144 = (J.mul(J.gp(v_o_4537, "dir"), 0.24) + (sin(J.num(J.mul(J.gp(env["__p"]["G"], "t"), 3.0))) * 0.03))
					v_ro_4547 = _t5144
					v_ox_4545 = 0.0
					v_oy_4546 = 0.0
					if J.cmp(v_dq_4566, 0.8, ">"):
						var _t5145 = env["__p"]["ctx"]
						J.sp(_t5145, "strokeStyle", "rgba(255,230,160,0.8)")
						var _t5146 = env["__p"]["ctx"]
						J.sp(_t5146, "lineWidth", 2.0)
						v_w2_4569 = 0.0
						while true:
							if not J.cmp(v_w2_4569, 3.0, "<"): break
							J.mc(env["__p"]["ctx"], "beginPath", [])
							J.mc(env["__p"]["ctx"], "arc", [J.sub(J.gp(v_o_4537, "x"), J.mul(J.gp(v_o_4537, "dir"), 10.0)), J.sub(v_flo2_4565, J.mul(J.gp(J.gp(v_o_4537, "d"), "h"), 0.42)), ((6.0 + J.mul(v_w2_4569, 5.0)) + J.mod(J.mul(J.gp(env["__p"]["G"], "t"), 16.0), 5.0)), (PI * 0.6), (PI * 1.4)])
							J.mc(env["__p"]["ctx"], "stroke", [])
							v_w2_4569 = J.num(v_w2_4569) + 1.0
		else:
			if (not J.t(v_hang_4541)):
				if (not J.seq(J.gp(v_na2_4562, "f"), J.gp(v_nb2_4563, "f"))):
					v_down_4570 = J.cmp(J.gp(v_nb2_4563, "f"), J.gp(v_na2_4562, "f"), "<")
					var _t5147 = J.sub(J.gp(v_o_4537, "y"), (0.0 if J.t(v_down_4570) else 6.0))
					v_by_4551 = _t5147
					var _t5148 = (PI if J.t(v_down_4570) else 0.0)
					v_ro_4547 = _t5148
					var _t5149 = (J.mul(J.gp(v_o_4537, "dir"), 14.0) + (sin(J.num(J.mul(J.gp(env["__p"]["G"], "t"), 14.0))) * 2.0))
					v_ox_4545 = _t5149
					if J.t(v_down_4570):
						var _t5150 = J.sub(J.gp(v_o_4537, "y"), J.mul(J.gp(J.gp(v_o_4537, "d"), "h"), 0.9))
						v_by_4551 = _t5150
					var _t5151 = J.mul(v_sx_4548, 0.95)
					v_sx_4548 = _t5151
					var _t5152 = absf(J.num(v_sy_4549))
					v_sy_4549 = _t5152
				else:
					v_by_4551 = v_ceil2_4564
					var _t5153 = (-absf(J.num((v_sy_4549 if J.t(v_sy_4549) else 1.0))))
					v_sy_4549 = _t5153
					var _t5154 = J.mul((v_oy_4546 if J.t(v_oy_4546) else 0.0), 0.4)
					v_oy_4546 = _t5154
	if J.seq(v_k_4544, "eking"):
		var _t5155 = J.gp(v_o_4537, "fat")
		var _t5156 = J.mul(v_sx_4548, J.add(1.0, (_t5155 if J.t(_t5155) else 0.0)))
		v_sx_4548 = _t5156
	var _t5157 = env["__p"]["drawTaskProps"]
	J.cl(_t5157, null, [v_o_4537, v_by_4551])
	if J.cmp(J.gp(v_o_4537, "countT"), 0.0, ">"):
		v_cy0_4571 = (J.sub(J.gp(v_o_4537, "y"), J.gp(J.gp(v_o_4537, "d"), "h")) - 8.0)
		var _t5158 = J.gp(v_o_4537, "cntAcc")
		var _t5159 = J.gp(v_o_4537, "cntAcc")
		v_fa_4572 = J.min_([1.0, J.div((_t5159 if J.t(_t5159) else 0.0), 0.32)])
		if J.cmp(J.gp(v_o_4537, "cntN"), 0.0, ">"):
			var _t5160 = env["__p"]["ctx"]
			var _t5161 = J.sub(1.0, v_fa_4572)
			J.sp(_t5160, "globalAlpha", _t5161)
			var _t5162 = env["__p"]["txt"]
			J.cl(_t5162, null, [J.gp(env["__p"]["COUNT"], J.mod(J.sub(J.gp(v_o_4537, "cntN"), 1.0), 10.0)), J.add(J.gp(v_o_4537, "x"), 10.0), J.sub(v_cy0_4571, J.mul(v_fa_4572, 14.0)), "#b8f0a0", 13.0])
			var _t5163 = env["__p"]["ctx"]
			J.sp(_t5163, "globalAlpha", 1.0)
		var _t5164 = env["__p"]["ctx"]
		J.sp(_t5164, "globalAlpha", v_fa_4572)
		var _t5165 = env["__p"]["txt"]
		var _t5167 = env["__p"]["COUNT"]
		var _t5166 = J.gp(v_o_4537, "cntN")
		J.cl(_t5165, null, [J.add(J.gp(_t5167, J.mod((_t5166 if J.t(_t5166) else 0.0), 10.0)), "……"), J.add(J.gp(v_o_4537, "x"), 10.0), J.sub(J.add(v_cy0_4571, 6.0), J.mul(v_fa_4572, 6.0)), "#d8ffc0", 16.0])
		var _t5168 = env["__p"]["ctx"]
		J.sp(_t5168, "globalAlpha", 1.0)
	var _t5169 = env["__p"]["ctx"]
	J.sp(_t5169, "shadowColor", "rgba(140,255,200,0.85)")
	var _t5170 = env["__p"]["ctx"]
	J.sp(_t5170, "shadowBlur", 7.0)
	var _t5171 = env["__p"]["spr"]
	J.cl(_t5171, null, [v_key_4550, J.gp(v_o_4537, "x"), v_by_4551, J.gp(J.gp(v_o_4537, "d"), "h"), {"flip": J.cmp(J.gp(v_o_4537, "dir"), 0.0, "<"), "alpha": v_a_4542, "ox": v_ox_4545, "oy": v_oy_4546, "rot": v_ro_4547, "sx": v_sx_4548, "sy": v_sy_4549}])
	var _t5172 = env["__p"]["ctx"]
	J.sp(_t5172, "shadowBlur", 0.0)
	var _t5173 = J.seq(v_i_4538, J.gp(env["__p"]["G"], "active"))
	var _t5174 = ((not J.t(J.gp(v_o_4537, "to"))) if _t5173 else _t5173)
	var _t5175 = (J.cmp(J.gp(v_o_4537, "still"), 0.1, ">=") if _t5174 else _t5174)
	if (J.cmp(J.gp(v_o_4537, "mv"), 0.0, "<=") if _t5175 else _t5175):
		var _t5176 = env["__p"]["ctx"]
		J.sp(_t5176, "strokeStyle", "rgba(138,255,200,0.55)")
		J.mc(env["__p"]["ctx"], "setLineDash", [[4.0, 4.0]])
		J.mc(env["__p"]["ctx"], "beginPath", [])
		J.mc(env["__p"]["ctx"], "ellipse", [J.gp(v_o_4537, "x"), J.sub(J.gp(v_o_4537, "y"), 2.0), 30.0, 8.0, 0.0, 0.0, 7.0])
		J.mc(env["__p"]["ctx"], "stroke", [])
		J.mc(env["__p"]["ctx"], "setLineDash", [[]])
	if J.cmp(J.gp(v_o_4537, "taskP"), 0.0, ">"):
		var _t5177 = env["__p"]["ctx"]
		J.sp(_t5177, "strokeStyle", "#8affc8")
		var _t5178 = env["__p"]["ctx"]
		J.sp(_t5178, "lineWidth", 4.0)
		J.mc(env["__p"]["ctx"], "beginPath", [])
		J.mc(env["__p"]["ctx"], "arc", [J.gp(v_o_4537, "x"), (J.sub(J.gp(v_o_4537, "y"), J.gp(J.gp(v_o_4537, "d"), "h")) - 14.0), 10.0, J.div((-PI), 2.0), (J.div((-PI), 2.0) + J.mul((PI * 2.0), J.gp(v_o_4537, "taskP")))])
		J.mc(env["__p"]["ctx"], "stroke", [])

func _f751(this_, a: Array, env):
	var v_p_4575 = null; var v_a_4576 = null
	v_p_4575 = J.arg(a, 0)
	v_a_4576 = J.div(J.gp(v_p_4575, "life"), J.gp(v_p_4575, "max"))
	var _t5180 = env["__p"]["ctx"]
	var _t5181 = J.min_([1.0, J.mul(v_a_4576, 1.4)])
	J.sp(_t5180, "globalAlpha", _t5181)
	if J.seq(J.gp(v_p_4575, "type"), "coin"):
		var _t5182 = env["__p"]["ctx"]
		J.sp(_t5182, "fillStyle", "#ffd54a")
		J.mc(env["__p"]["ctx"], "beginPath", [])
		J.mc(env["__p"]["ctx"], "ellipse", [J.gp(v_p_4575, "x"), J.gp(v_p_4575, "y"), 4.0, (4.0 * absf(J.num(sin(J.num(J.add(J.mul(J.gp(env["__p"]["G"], "t"), 12.0), J.gp(v_p_4575, "x"))))))), 0.0, 0.0, 7.0])
		J.mc(env["__p"]["ctx"], "fill", [])
	else:
		if J.seq(J.gp(v_p_4575, "type"), "crumb"):
			var _t5183 = env["__p"]["ctx"]
			J.sp(_t5183, "fillStyle", "#e8c07a")
			J.mc(env["__p"]["ctx"], "fillRect", [J.gp(v_p_4575, "x"), J.gp(v_p_4575, "y"), 3.0, 3.0])
		else:
			if J.seq(J.gp(v_p_4575, "type"), "sweat"):
				var _t5184 = env["__p"]["ctx"]
				J.sp(_t5184, "fillStyle", "#9fe0ff")
				J.mc(env["__p"]["ctx"], "beginPath", [])
				J.mc(env["__p"]["ctx"], "arc", [J.gp(v_p_4575, "x"), J.gp(v_p_4575, "y"), 2.5, 0.0, 7.0])
				J.mc(env["__p"]["ctx"], "fill", [])
			else:
				if J.seq(J.gp(v_p_4575, "type"), "tear"):
					var _t5185 = env["__p"]["ctx"]
					J.sp(_t5185, "fillStyle", "#bfeaff")
					var _t5186 = env["__p"]["ctx"]
					J.sp(_t5186, "strokeStyle", "#2a4a5a")
					var _t5187 = env["__p"]["ctx"]
					J.sp(_t5187, "lineWidth", 0.8)
					J.mc(env["__p"]["ctx"], "beginPath", [])
					J.mc(env["__p"]["ctx"], "moveTo", [J.gp(v_p_4575, "x"), J.sub(J.gp(v_p_4575, "y"), 4.5)])
					J.mc(env["__p"]["ctx"], "quadraticCurveTo", [J.add(J.gp(v_p_4575, "x"), 3.2), J.gp(v_p_4575, "y"), J.gp(v_p_4575, "x"), J.add(J.gp(v_p_4575, "y"), 2.6)])
					J.mc(env["__p"]["ctx"], "quadraticCurveTo", [J.sub(J.gp(v_p_4575, "x"), 3.2), J.gp(v_p_4575, "y"), J.gp(v_p_4575, "x"), J.sub(J.gp(v_p_4575, "y"), 4.5)])
					J.mc(env["__p"]["ctx"], "fill", [])
					J.mc(env["__p"]["ctx"], "stroke", [])
				else:
					if J.seq(J.gp(v_p_4575, "type"), "hair"):
						var _t5188 = env["__p"]["ctx"]
						J.sp(_t5188, "strokeStyle", "#222")
						var _t5189 = env["__p"]["ctx"]
						J.sp(_t5189, "lineWidth", 1.0)
						J.mc(env["__p"]["ctx"], "beginPath", [])
						J.mc(env["__p"]["ctx"], "moveTo", [J.gp(v_p_4575, "x"), J.gp(v_p_4575, "y")])
						J.mc(env["__p"]["ctx"], "lineTo", [J.add(J.gp(v_p_4575, "x"), 3.0), J.add(J.gp(v_p_4575, "y"), 9.0)])
						J.mc(env["__p"]["ctx"], "stroke", [])
					else:
						if J.seq(J.gp(v_p_4575, "type"), "smoke"):
							var _t5190 = env["__p"]["ctx"]
							J.sp(_t5190, "fillStyle", "rgba(200,210,205,0.5)")
							J.mc(env["__p"]["ctx"], "beginPath", [])
							J.mc(env["__p"]["ctx"], "arc", [J.gp(v_p_4575, "x"), J.gp(v_p_4575, "y"), (4.0 + (J.sub(1.0, v_a_4576) * 10.0)), 0.0, 7.0])
							J.mc(env["__p"]["ctx"], "fill", [])
						else:
							if J.seq(J.gp(v_p_4575, "type"), "dust"):
								var _t5191 = env["__p"]["ctx"]
								J.sp(_t5191, "fillStyle", "rgba(180,170,150,0.5)")
								J.mc(env["__p"]["ctx"], "beginPath", [])
								J.mc(env["__p"]["ctx"], "arc", [J.gp(v_p_4575, "x"), J.gp(v_p_4575, "y"), (3.0 + (J.sub(1.0, v_a_4576) * 5.0)), 0.0, 7.0])
								J.mc(env["__p"]["ctx"], "fill", [])
							else:
								if J.seq(J.gp(v_p_4575, "type"), "drip"):
									var _t5192 = env["__p"]["ctx"]
									J.sp(_t5192, "fillStyle", "#9fe0ff")
									J.mc(env["__p"]["ctx"], "beginPath", [])
									J.mc(env["__p"]["ctx"], "ellipse", [J.gp(v_p_4575, "x"), J.gp(v_p_4575, "y"), 1.6, 3.0, 0.0, 0.0, 7.0])
									J.mc(env["__p"]["ctx"], "fill", [])
								else:
									if J.seq(J.gp(v_p_4575, "type"), "note"):
										var _t5193 = env["__p"]["ctx"]
										J.sp(_t5193, "fillStyle", "#9cc89c")
										J.mc(env["__p"]["ctx"], "save", [])
										J.mc(env["__p"]["ctx"], "translate", [J.gp(v_p_4575, "x"), J.gp(v_p_4575, "y")])
										J.mc(env["__p"]["ctx"], "rotate", [J.add(J.mul(J.gp(env["__p"]["G"], "t"), 8.0), J.gp(v_p_4575, "vx"))])
										J.mc(env["__p"]["ctx"], "fillRect", [(-5.0), (-3.0), 10.0, 6.0])
										J.mc(env["__p"]["ctx"], "restore", [])
									else:
										if J.seq(J.gp(v_p_4575, "type"), "suck"):
											var _t5194 = env["__p"]["ctx"]
											J.sp(_t5194, "fillStyle", "#d24a3a")
											J.mc(env["__p"]["ctx"], "beginPath", [])
											J.mc(env["__p"]["ctx"], "arc", [J.gp(v_p_4575, "x"), J.gp(v_p_4575, "y"), 3.0, 0.0, 7.0])
											J.mc(env["__p"]["ctx"], "fill", [])
	var _t5195 = env["__p"]["ctx"]
	J.sp(_t5195, "globalAlpha", 1.0)

func _f752(this_, a: Array, env):
	var v_c_4579 = null; var v_j_4580 = null
	v_c_4579 = J.arg(a, 0)
	v_j_4580 = J.arg(a, 1)
	var _t5201 = J.add(J.gp(v_c_4579, "x"), J.mul(J.gp(v_c_4579, "v"), 0.033))
	J.sp(v_c_4579, "x", _t5201)
	var _t5202 = J.cmp(J.gp(v_c_4579, "x"), 60.0, "<")
	if (_t5202 if _t5202 else J.cmp(J.gp(v_c_4579, "x"), J.sub(env["__p"]["WW"], 60.0), ">")):
		var _t5203 = J.mul(J.gp(v_c_4579, "v"), (-1.0))
		J.sp(v_c_4579, "v", _t5203)
	var _t5204 = env["__p"]["spr"]
	J.cl(_t5204, null, ["toyol", J.gp(v_c_4579, "x"), env["bot"], 40.0, {"flip": J.cmp(J.gp(v_c_4579, "v"), 0.0, "<"), "alpha": 0.75, "oy": ((-absf(J.num(sin(J.num(J.add(J.mul(J.gp(env["__p"]["G"], "t"), 14.0), v_j_4580)))))) * 8.0)}])
	if (randf() < 0.3):
		var _t5205 = env["__p"]["part"]
		J.cl(_t5205, null, [J.gp(v_c_4579, "x"), J.sub(env["bot"], 20.0), ((randf() - 0.5) * 60.0), (-80.0), 0.6, "coin"])

func _f753(this_, a: Array, env):
	var v_f_4583 = null
	v_f_4583 = J.arg(a, 0)
	var _t5214 = env["__p"]["ctx"]
	var _t5215 = J.min_([1.0, J.gp(v_f_4583, "life")])
	J.sp(_t5214, "globalAlpha", _t5215)
	var _t5216 = env["__p"]["crText"]
	J.cl(_t5216, null, [env["__p"]["ctx"], J.gp(v_f_4583, "t"), J.gp(v_f_4583, "x"), J.gp(v_f_4583, "y"), 14.0, J.gp(v_f_4583, "c"), "center"])
	var _t5217 = env["__p"]["ctx"]
	J.sp(_t5217, "globalAlpha", 1.0)

func _f734(this_, a: Array, env):
	var v_g_4418 = null; var v_S_4419 = null; var v_fxc_4422 = null; var v_fyc_4423 = null; var v_LB_4424 = null; var v_tx_4426 = null; var v_shk_4427 = null; var v_k_4431 = null; var v_fx_4432 = null; var v_bx_4434 = null; var v_byy_4435 = null; var v_gn_4436 = null; var v_rr2_4437 = null; var v_gg_4438 = null; var v_q_4439 = null; var v_U_4440 = null; var v_uf_4441 = null; var v_ut_4442 = null; var v_top_4443 = null; var v_len_4445 = null; var v_spread_4446 = null; var v_hx_4447 = null; var v_R0_4448 = null; var v_cy_4449 = null; var v_t_4450 = null; var v_gk_4451 = null; var v_ea_4452 = null; var v_by_4453 = null; var v_yy_4454 = null
	var _s1791 = {"__p": env, "viewH": null, "viewW": null, "ty": null, "f": null, "ly": null, "fl": null, "T": null, "bot": null}
	J.mc(_s1791["__p"]["ctx"], "setTransform", [_s1791["__p"]["DPR"], 0.0, 0.0, _s1791["__p"]["DPR"], 0.0, 0.0])
	var _t4873 = _s1791["__p"]["ctx"]
	J.sp(_t4873, "fillStyle", "#0b0b0d")
	J.mc(_s1791["__p"]["ctx"], "fillRect", [0.0, 0.0, _s1791["__p"]["VW"], _s1791["__p"]["VH"]])
	var _t4874 = []
	_s1791["__p"]["buttons"] = _t4874
	if J.seq(_s1791["__p"]["scene"], "title"):
		J.cl(_s1791["__p"]["drawTitle"], null, [])
		return null
	v_g_4418 = J.gp(J.gp(_s1791["__p"]["G"], "gh"), J.gp(_s1791["__p"]["G"], "active"))
	v_S_4419 = J.mul(J.gp(_s1791["__p"]["cam"], "s"), J.gp(_s1791["__p"]["cam"], "z"))
	_s1791["viewH"] = J.div(J.sub(J.sub(_s1791["__p"]["VH"], _s1791["__p"]["TOP"]), _s1791["__p"]["BOT"]), v_S_4419)
	_s1791["viewW"] = J.div(_s1791["__p"]["VW"], v_S_4419)
	v_fxc_4422 = (J.gp(J.gp(_s1791["__p"]["cam"], "free"), "x") if J.t(J.gp(_s1791["__p"]["cam"], "free")) else J.gp(v_g_4418, "x"))
	v_fyc_4423 = (J.gp(J.gp(_s1791["__p"]["cam"], "free"), "y") if J.t(J.gp(_s1791["__p"]["cam"], "free")) else J.gp(v_g_4418, "y"))
	var _t4875 = (not J.t(J.gp(_s1791["__p"]["cam"], "free")))
	var _t4876 = (_s1791["__p"]["LIFT"] if _t4875 else _t4875)
	v_LB_4424 = (J.mc(_s1791["__p"]["LIFT"], "band", []) if J.t((J.gp(_s1791["__p"]["LIFT"], "band") if J.t(_t4876) else _t4876)) else null)
	var _t4878 = null
	if J.t(v_LB_4424):
		_t4878 = J.sub(v_fyc_4423, J.div(J.sub(J.sub(J.gp(v_LB_4424, "y1"), 14.0), _s1791["__p"]["TOP"]), v_S_4419))
	else:
		var _t4877 = _s1791["__p"]["clamp"]
		_t4878 = J.cl(_t4877, null, [J.sub(v_fyc_4423, J.mul(_s1791["viewH"], 0.55)), 0.0, J.max_([0.0, (J.sub(_s1791["__p"]["WH"], _s1791["viewH"]) + 70.0)])])
	_s1791["ty"] = _t4878
	var _t4879 = _s1791["__p"]["clamp"]
	v_tx_4426 = J.cl(_t4879, null, [J.sub(v_fxc_4422, J.div(_s1791["viewW"], 2.0)), 0.0, J.max_([0.0, J.sub(_s1791["__p"]["WW"], _s1791["viewW"])])])
	var _t4880 = _s1791["__p"]["cam"]
	var _t4881 = J.add(J.gp(_t4880, "y"), (J.sub(_s1791["ty"], J.gp(_s1791["__p"]["cam"], "y")) * 0.15))
	J.sp(_t4880, "y", _t4881)
	var _t4882 = _s1791["__p"]["cam"]
	var _t4883 = J.add(J.gp(_t4882, "x"), (J.sub(v_tx_4426, J.gp(_s1791["__p"]["cam"], "x")) * 0.15))
	J.sp(_t4882, "x", _t4883)
	v_shk_4427 = ((J.mul((randf() - 0.5), J.gp(_s1791["__p"]["G"], "shake")) * 16.0) if J.cmp(J.gp(_s1791["__p"]["G"], "shake"), 0.0, ">") else 0.0)
	J.mc(_s1791["__p"]["ctx"], "save", [])
	J.mc(_s1791["__p"]["ctx"], "translate", [v_shk_4427, _s1791["__p"]["TOP"]])
	J.mc(_s1791["__p"]["ctx"], "beginPath", [])
	J.mc(_s1791["__p"]["ctx"], "rect", [0.0, 0.0, _s1791["__p"]["VW"], J.sub(J.sub(_s1791["__p"]["VH"], _s1791["__p"]["TOP"]), _s1791["__p"]["BOT"])])
	J.mc(_s1791["__p"]["ctx"], "clip", [])
	J.mc(_s1791["__p"]["ctx"], "scale", [v_S_4419, v_S_4419])
	J.mc(_s1791["__p"]["ctx"], "translate", [(-J.num(J.gp(_s1791["__p"]["cam"], "x"))), (-J.num(J.gp(_s1791["__p"]["cam"], "y")))])
	J.mc(_s1791["__p"]["ctx"], "drawImage", [_s1791["__p"]["staticCv"], 0.0, 0.0, _s1791["__p"]["WW"], _s1791["__p"]["WH"]])
	var _t4884 = _s1791["__p"]["CULL"]
	var _t4885 = J.sub(J.gp(_s1791["__p"]["cam"], "y"), 80.0)
	J.sp(_t4884, "y0", _t4885)
	var _t4886 = _s1791["__p"]["CULL"]
	var _t4887 = J.add(J.add(J.gp(_s1791["__p"]["cam"], "y"), _s1791["viewH"]), 80.0)
	J.sp(_t4886, "y1", _t4887)
	var _t4889 = (not J.t(J.gp(J.G.get("window"), "__twNat")))
	if not J.t(_t4889):
		var _t4888 = J.G.get("__nat_twUnits1")
		_t4889 = (not J.t(J.cl(_t4888, null, [_s1791["__p"]["ctx"], _s1791["__p"]["G"], _s1791["__p"]["CULL"], _s1791["__p"]["FYS"]])))
	if _t4889:
		var _t4890 = J.gp(_s1791["__p"]["G"], "units")
		J.mc(_t4890, "forEach", [Callable(self, "_f735").bind(_s1791)])
	var _t4916 = J.gp(_s1791["__p"]["G"], "_we")
	if not J.t(_t4916):
		var _t4913 = _s1791["__p"]["G"]
		var _t4914 = J.gp(_s1791["__p"]["G"], "edges")
		var _t4915 = J.mc(_t4914, "filter", [Callable(self, "_f736").bind(_s1791)])
		J.sp(_t4913, "_we", _t4915)
		_t4916 = _t4915
	J.mc(_t4916, "forEach", [_s1791["__p"]["drawWard"]])
	J.cl(_s1791["__p"]["drawProps2"], null, [])
	var _t4917 = ["f0_e", (J.add("f", _s1791["__p"]["FL"]) + "_p")]
	J.mc(_t4917, "forEach", [Callable(self, "_f737").bind(_s1791)])
	var _t4930 = (not J.t(J.gp(J.G.get("window"), "__twNat")))
	if not J.t(_t4930):
		var _t4929 = J.G.get("__nat_twLamps")
		_t4930 = (not J.t(J.cl(_t4929, null, [_s1791["__p"]["ctx"], _s1791["__p"]["G"], _s1791["__p"]["FYS"], _s1791["__p"]["FL"], J.gp(_s1791["__p"]["cam"], "y"), _s1791["viewH"], _s1791["__p"]["WW"]])))
	if _t4930:
		_s1791["f"] = 0.0
		while true:
			if not J.cmp(_s1791["f"], _s1791["__p"]["FL"], "<"): break
			var _t4931 = _s1791["__p"]["fy"]
			var _t4933 = J.cmp(J.cl(_t4931, null, [_s1791["f"]]), J.sub(J.gp(_s1791["__p"]["cam"], "y"), 20.0), "<")
			if not J.t(_t4933):
				var _t4932 = _s1791["__p"]["fy"]
				_t4933 = J.cmp(J.cl(_t4932, null, [J.add(_s1791["f"], 1.0)]), J.add(J.add(J.gp(_s1791["__p"]["cam"], "y"), _s1791["viewH"]), 40.0), ">")
			if _t4933:
				_s1791["f"] = J.num(_s1791["f"]) + 1.0
				continue
			var _t4934 = _s1791["__p"]["fy"]
			_s1791["ly"] = J.add(J.cl(_t4934, null, [J.add(_s1791["f"], 1.0)]), 18.0)
			_s1791["fl"] = (0.55 + ((0.45 * sin(J.num((J.mul(J.gp(_s1791["__p"]["G"], "t"), 13.0) + J.mul(_s1791["f"], 2.1))))) * sin(J.num(J.add(J.mul(J.gp(_s1791["__p"]["G"], "t"), 3.7), _s1791["f"])))))
			if J.seq(J.mod(floor(J.num((J.mul(J.gp(_s1791["__p"]["G"], "t"), 7.0) + J.mul(_s1791["f"], 5.0)))), 23.0), 0.0):
				_s1791["fl"] = 0.1
			if J.t(J.gp(J.gp(_s1791["__p"]["G"], "dark"), _s1791["f"])):
				_s1791["fl"] = 0.0
			var _t4935 = J.gp(_s1791["__p"]["G"], "units")
			var _t4936 = J.mc(_t4935, "filter", [Callable(self, "_f738").bind(_s1791)])
			var _t4937 = J.mc(_t4936, "map", [Callable(self, "_f739").bind(_s1791)])
			J.mc(_t4937, "forEach", [Callable(self, "_f740").bind(_s1791)])
			v_k_4431 = 0.0
			while true:
				if not J.cmp(v_k_4431, 3.0, "<"): break
				v_fx_4432 = (J.mod(((J.mul(J.gp(_s1791["__p"]["G"], "t"), (10.0 + J.mul(v_k_4431, 4.0))) + J.mul(v_k_4431, 200.0)) + J.mul(_s1791["f"], 90.0)), J.add(_s1791["__p"]["WW"], 100.0)) - 50.0)
				var _t4939 = _s1791["__p"]["ctx"]
				J.sp(_t4939, "fillStyle", "rgba(180,220,210,0.07)")
				J.mc(_s1791["__p"]["ctx"], "beginPath", [])
				var _t4940 = _s1791["__p"]["fy"]
				J.mc(_s1791["__p"]["ctx"], "ellipse", [v_fx_4432, J.sub(J.cl(_t4940, null, [_s1791["f"]]), 6.0), 70.0, 9.0, 0.0, 0.0, 7.0])
				J.mc(_s1791["__p"]["ctx"], "fill", [])
				v_k_4431 = J.num(v_k_4431) + 1.0
			if J.t(J.gp(J.gp(_s1791["__p"]["G"], "dark"), _s1791["f"])):
				var _t4941 = _s1791["__p"]["ctx"]
				var _t4942 = (J.add("rgba(0,0,0,", J.min_([0.78, J.mul(J.gp(J.gp(_s1791["__p"]["G"], "dark"), _s1791["f"]), 0.6)])) + ")")
				J.sp(_t4941, "fillStyle", _t4942)
				var _t4943 = _s1791["__p"]["fy"]
				var _t4947 = J.add(J.cl(_t4943, null, [J.add(_s1791["f"], 1.0)]), 8.0)
				var _t4948 = _s1791["__p"]["WW"]
				var _t4944 = _s1791["__p"]["fy"]
				var _t4946 = J.cl(_t4944, null, [_s1791["f"]])
				var _t4945 = _s1791["__p"]["fy"]
				J.mc(_s1791["__p"]["ctx"], "fillRect", [0.0, _t4947, _t4948, (J.sub(_t4946, J.cl(_t4945, null, [J.add(_s1791["f"], 1.0)])) - 6.0)])
			_s1791["f"] = J.num(_s1791["f"]) + 1.0
	var _t4949 = J.gp(_s1791["__p"]["G"], "wardFx")
	J.mc(_t4949, "forEach", [Callable(self, "_f741").bind(_s1791)])
	J.cl(_s1791["__p"]["drawTraces"], null, [])
	J.cl(_s1791["__p"]["drawSafe"], null, [])
	J.cl(_s1791["__p"]["drawDrops"], null, [])
	var _t4954 = J.gp(_s1791["__p"]["G"], "res")
	J.mc(_t4954, "forEach", [Callable(self, "_f742").bind(_s1791)])
	if J.t(J.gp(_s1791["__p"]["G"], "tao")):
		_s1791["T"] = J.gp(_s1791["__p"]["G"], "tao")
		var _t4956 = _s1791["__p"]["fy"]
		_s1791["ty"] = J.cl(_t4956, null, [J.gp(_s1791["T"], "f")])
		var _t4957 = J.gp(_s1791["T"], "waves")
		J.mc(_t4957, "forEach", [Callable(self, "_f743").bind(_s1791)])
		var _t4961 = _s1791["__p"]["ctx"]
		J.sp(_t4961, "fillStyle", "rgba(0,0,0,0.45)")
		J.mc(_s1791["__p"]["ctx"], "beginPath", [])
		J.mc(_s1791["__p"]["ctx"], "ellipse", [J.gp(_s1791["T"], "x"), J.sub(_s1791["ty"], 1.0), 16.0, 4.0, 0.0, 0.0, 7.0])
		J.mc(_s1791["__p"]["ctx"], "fill", [])
		var _t4962 = _s1791["__p"]["ctx"]
		J.sp(_t4962, "shadowColor", "rgba(255,215,90,0.9)")
		var _t4963 = _s1791["__p"]["ctx"]
		J.sp(_t4963, "shadowBlur", 9.0)
		var _t4964 = _s1791["__p"]["spr"]
		J.cl(_t4964, null, ["npc_boss", J.gp(_s1791["T"], "x"), _s1791["ty"], 62.0, {"flip": J.cmp(J.gp(_s1791["T"], "dir"), 0.0, "<"), "oy": ((-absf(J.num(sin(J.num(J.mul(J.gp(_s1791["__p"]["G"], "t"), 6.0)))))) * 2.0)}])
		var _t4965 = _s1791["__p"]["ctx"]
		J.sp(_t4965, "shadowBlur", 0.0)
		v_bx_4434 = J.add(J.gp(_s1791["T"], "x"), J.mul(J.gp(_s1791["T"], "dir"), 16.0))
		v_byy_4435 = (J.sub(_s1791["ty"], 40.0) + (sin(J.num(J.mul(J.gp(_s1791["__p"]["G"], "t"), 14.0))) * 2.0))
		var _t4966 = _s1791["__p"]["ctx"]
		J.sp(_t4966, "fillStyle", "#e8b830")
		J.mc(_s1791["__p"]["ctx"], "beginPath", [])
		J.mc(_s1791["__p"]["ctx"], "moveTo", [J.sub(v_bx_4434, 6.0), J.add(v_byy_4435, 8.0)])
		J.mc(_s1791["__p"]["ctx"], "quadraticCurveTo", [v_bx_4434, J.sub(v_byy_4435, 10.0), J.add(v_bx_4434, 6.0), J.add(v_byy_4435, 8.0)])
		J.mc(_s1791["__p"]["ctx"], "closePath", [])
		J.mc(_s1791["__p"]["ctx"], "fill", [])
		var _t4967 = _s1791["__p"]["ctx"]
		J.sp(_t4967, "strokeStyle", "#5a3a10")
		var _t4968 = _s1791["__p"]["ctx"]
		J.sp(_t4968, "lineWidth", 1.0)
		J.mc(_s1791["__p"]["ctx"], "stroke", [])
		var _t4969 = _s1791["__p"]["ctx"]
		J.sp(_t4969, "fillStyle", "#ffe9a0")
		var _t4970 = _s1791["__p"]["ctx"]
		var _t4971 = J.add("bold 12px ", _s1791["__p"]["FONT"])
		J.sp(_t4970, "font", _t4971)
		var _t4972 = _s1791["__p"]["ctx"]
		J.sp(_t4972, "textAlign", "center")
		var _t4973 = _s1791["__p"]["ctx"]
		J.sp(_t4973, "lineWidth", 3.0)
		var _t4974 = _s1791["__p"]["ctx"]
		J.sp(_t4974, "strokeStyle", "#000")
		J.mc(_s1791["__p"]["ctx"], "strokeText", ["天師", J.gp(_s1791["T"], "x"), J.sub(_s1791["ty"], 70.0)])
		J.mc(_s1791["__p"]["ctx"], "fillText", ["天師", J.gp(_s1791["T"], "x"), J.sub(_s1791["ty"], 70.0)])
		if J.cmp(J.gp(_s1791["T"], "sayT"), 0.0, ">"):
			var _t4975 = _s1791["__p"]["bubble"]
			J.cl(_t4975, null, [J.gp(_s1791["T"], "x"), J.sub(_s1791["ty"], 78.0), J.gp(_s1791["T"], "say")])
	var _t4976 = J.gp(_s1791["__p"]["G"], "gh")
	J.mc(_t4976, "forEach", [Callable(self, "_f744").bind(_s1791)])
	var _t4980 = J.gp(_s1791["__p"]["G"], "guards")
	J.mc(_t4980, "forEach", [Callable(self, "_f745").bind(_s1791)])
	var _t5026 = (not J.t(J.gp(J.G.get("window"), "__twNat")))
	if not J.t(_t5026):
		var _t5025 = J.G.get("__nat_twMask")
		_t5026 = (not J.t(J.cl(_t5025, null, [_s1791["__p"]["ctx"], _s1791["__p"]["G"], _s1791["__p"]["CULL"], _s1791["__p"]["FYS"], _s1791["__p"]["ITEM"]])))
	if _t5026:
		var _t5027 = J.gp(_s1791["__p"]["G"], "units")
		J.mc(_t5027, "forEach", [Callable(self, "_f747").bind(_s1791)])
	var _t5071 = J.gp(_s1791["__p"]["G"], "gate")
	if J.t((_t5071 if J.t(_t5071) else J.cmp(J.gp(_s1791["__p"]["G"], "gateCharge"), 0.0, ">"))):
		v_gn_4436 = J.gp(J.gp(_s1791["__p"]["G"], "nodes"), (J.gp(J.gp(_s1791["__p"]["G"], "gate"), "node") if J.t(J.gp(_s1791["__p"]["G"], "gate")) else J.gp(J.gp(J.gp(_s1791["__p"]["G"], "gh"), J.gp(_s1791["__p"]["G"], "gateG")), "node")))
		v_rr2_4437 = ((40.0 + (sin(J.num(J.mul(J.gp(_s1791["__p"]["G"], "t"), 4.0))) * 6.0)) if J.t(J.gp(_s1791["__p"]["G"], "gate")) else J.mul(20.0, J.gp(_s1791["__p"]["G"], "gateCharge")))
		v_gg_4438 = J.mc(_s1791["__p"]["ctx"], "createRadialGradient", [J.gp(v_gn_4436, "x"), J.sub(J.gp(v_gn_4436, "y"), 40.0), 4.0, J.gp(v_gn_4436, "x"), J.sub(J.gp(v_gn_4436, "y"), 40.0), J.mul(v_rr2_4437, 1.8)])
		J.mc(v_gg_4438, "addColorStop", [0.0, "rgba(120,255,200,0.75)"])
		J.mc(v_gg_4438, "addColorStop", [1.0, "rgba(40,120,90,0)"])
		var _t5072 = _s1791["__p"]["ctx"]
		J.sp(_t5072, "fillStyle", v_gg_4438)
		J.mc(_s1791["__p"]["ctx"], "beginPath", [])
		J.mc(_s1791["__p"]["ctx"], "arc", [J.gp(v_gn_4436, "x"), J.sub(J.gp(v_gn_4436, "y"), 40.0), J.mul(v_rr2_4437, 1.8), 0.0, 7.0])
		J.mc(_s1791["__p"]["ctx"], "fill", [])
		var _t5073 = _s1791["__p"]["ctx"]
		J.sp(_t5073, "strokeStyle", "rgba(160,255,210,0.8)")
		var _t5074 = _s1791["__p"]["ctx"]
		J.sp(_t5074, "lineWidth", 3.0)
		v_q_4439 = 0.0
		while true:
			if not J.cmp(v_q_4439, 3.0, "<"): break
			J.mc(_s1791["__p"]["ctx"], "beginPath", [])
			J.mc(_s1791["__p"]["ctx"], "arc", [J.gp(v_gn_4436, "x"), J.sub(J.gp(v_gn_4436, "y"), 40.0), J.mul(v_rr2_4437, (0.5 + J.mul(v_q_4439, 0.3))), J.mul(J.gp(_s1791["__p"]["G"], "t"), J.add(2.0, v_q_4439)), (J.mul(J.gp(_s1791["__p"]["G"], "t"), J.add(2.0, v_q_4439)) + 4.0)])
			J.mc(_s1791["__p"]["ctx"], "stroke", [])
			v_q_4439 = J.num(v_q_4439) + 1.0
	J.cl(_s1791["__p"]["drawMoves"], null, [])
	if J.t(_s1791["__p"]["UNIT"]):
		J.mc(_s1791["__p"]["UNIT"], "drawWorld", [_s1791["__p"]["ctx"]])
	var _t5075 = J.gp(_s1791["__p"]["G"], "gh")
	J.mc(_t5075, "forEach", [Callable(self, "_f750").bind(_s1791)])
	var _t5179 = J.gp(_s1791["__p"]["G"], "parts")
	J.mc(_t5179, "forEach", [Callable(self, "_f751").bind(_s1791)])
	var _t5196 = J.gp(_s1791["__p"]["G"], "ult")
	if J.t((J.cmp(J.gp(J.gp(_s1791["__p"]["G"], "ult"), "t"), 1.3, ">=") if J.t(_t5196) else _t5196)):
		v_U_4440 = J.gp(_s1791["__p"]["G"], "ult")
		v_uf_4441 = J.gp(v_U_4440, "f")
		v_ut_4442 = J.sub(J.gp(v_U_4440, "t"), 1.3)
		var _t5197 = _s1791["__p"]["fy"]
		v_top_4443 = J.add(J.cl(_t5197, null, [J.min_([_s1791["__p"]["FL"], J.add(v_uf_4441, 1.0)])]), 8.0)
		var _t5198 = _s1791["__p"]["fy"]
		_s1791["bot"] = J.cl(_t5198, null, [v_uf_4441])
		var _t5199 = J.seq(J.gp(J.gp(J.gp(v_U_4440, "g"), "d"), "key"), "toyol")
		if J.t((J.gp(v_U_4440, "clones") if _t5199 else _t5199)):
			var _t5200 = J.gp(v_U_4440, "clones")
			J.mc(_t5200, "forEach", [Callable(self, "_f752").bind(_s1791)])
		if J.seq(J.gp(J.gp(J.gp(v_U_4440, "g"), "d"), "key"), "tianhua"):
			var _t5206 = _s1791["__p"]["ctx"]
			J.sp(_t5206, "strokeStyle", "rgba(12,12,14,0.9)")
			var _t5207 = _s1791["__p"]["ctx"]
			J.sp(_t5207, "lineWidth", 2.2)
			v_len_4445 = (J.min_([1.0, J.mul(v_ut_4442, 1.6)]) * J.sub(_s1791["bot"], v_top_4443))
			v_spread_4446 = J.min_([300.0, J.mul(v_ut_4442, 190.0)])
			if J.cmp(v_spread_4446, 300.0, "<"):
				var _t5208 = _s1791["__p"]["txt"]
				J.cl(_t5208, null, ["頭髮沿走廊爬去隔籬屋……", J.gp(J.gp(v_U_4440, "g"), "x"), J.add(v_top_4443, 18.0), "#9fe0ff", 13.0])
			v_hx_4447 = J.max_([60.0, J.sub(J.gp(J.gp(v_U_4440, "g"), "x"), v_spread_4446)])
			while true:
				if not J.cmp(v_hx_4447, J.min_([J.sub(_s1791["__p"]["WW"], 55.0), J.add(J.gp(J.gp(v_U_4440, "g"), "x"), v_spread_4446)]), "<"): break
				J.mc(_s1791["__p"]["ctx"], "beginPath", [])
				J.mc(_s1791["__p"]["ctx"], "moveTo", [v_hx_4447, v_top_4443])
				J.mc(_s1791["__p"]["ctx"], "quadraticCurveTo", [J.add(v_hx_4447, (sin(J.num(J.add(J.mul(J.gp(_s1791["__p"]["G"], "t"), 3.0), v_hx_4447))) * 10.0)), J.add(v_top_4443, J.mul(v_len_4445, 0.5)), J.add(v_hx_4447, (sin(J.num((J.mul(J.gp(_s1791["__p"]["G"], "t"), 2.0) + J.mul(v_hx_4447, 0.3)))) * 8.0)), J.add(v_top_4443, v_len_4445)])
				J.mc(_s1791["__p"]["ctx"], "stroke", [])
				var _t5209 = J.add(v_hx_4447, 7.0)
				v_hx_4447 = _t5209
		if J.seq(J.gp(J.gp(J.gp(v_U_4440, "g"), "d"), "key"), "eking"):
			v_R0_4448 = (J.min_([1.0, J.mul(v_ut_4442, 1.5)]) * (J.sub(_s1791["bot"], v_top_4443) * 0.46))
			v_cy_4449 = (J.div(J.add(v_top_4443, _s1791["bot"]), 2.0) + 6.0)
			J.mc(_s1791["__p"]["ctx"], "save", [])
			J.mc(_s1791["__p"]["ctx"], "beginPath", [])
			J.mc(_s1791["__p"]["ctx"], "rect", [0.0, v_top_4443, _s1791["__p"]["WW"], J.sub(_s1791["bot"], v_top_4443)])
			J.mc(_s1791["__p"]["ctx"], "clip", [])
			var _t5210 = _s1791["__p"]["ctx"]
			J.sp(_t5210, "fillStyle", "rgba(0,0,0,0.55)")
			J.mc(_s1791["__p"]["ctx"], "fillRect", [0.0, v_top_4443, _s1791["__p"]["WW"], J.sub(_s1791["bot"], v_top_4443)])
			var _t5211 = _s1791["__p"]["drawMouth"]
			J.cl(_t5211, null, [J.gp(J.gp(v_U_4440, "g"), "x"), v_cy_4449, v_R0_4448, (0.3 + (0.7 * absf(J.num(sin(J.num(J.mul(v_ut_4442, 5.0))))))), 1.0])
			J.mc(_s1791["__p"]["ctx"], "restore", [])
			if J.cmp(v_ut_4442, 1.6, "<"):
				var _t5212 = _s1791["__p"]["txt"]
				J.cl(_t5212, null, ["開飯喇……", J.gp(J.gp(v_U_4440, "g"), "x"), J.add(v_top_4443, 16.0), "#ffb7a0", 13.0])
	var _t5213 = J.gp(_s1791["__p"]["G"], "floats")
	J.mc(_t5213, "forEach", [Callable(self, "_f753").bind(_s1791)])
	J.mc(_s1791["__p"]["ctx"], "restore", [])
	var _t5218 = J.gp(_s1791["__p"]["G"], "ult")
	if J.t((J.cmp(J.gp(J.gp(_s1791["__p"]["G"], "ult"), "t"), 1.3, "<") if J.t(_t5218) else _t5218)):
		v_t_4450 = J.gp(J.gp(_s1791["__p"]["G"], "ult"), "t")
		v_gk_4451 = J.gp(J.gp(J.gp(_s1791["__p"]["G"], "ult"), "g"), "d")
		v_ea_4452 = (J.min_([1.0, J.mul(v_t_4450, 4.0)]) * (J.div(J.sub(1.3, v_t_4450), 0.2) if J.cmp(v_t_4450, 1.1, ">") else 1.0))
		var _t5219 = _s1791["__p"]["ctx"]
		var _t5220 = (J.add("rgba(0,0,0,", J.mul(0.7, v_ea_4452)) + ")")
		J.sp(_t5219, "fillStyle", _t5220)
		J.mc(_s1791["__p"]["ctx"], "fillRect", [0.0, 0.0, _s1791["__p"]["VW"], _s1791["__p"]["VH"]])
		v_bx_4434 = (J.mul(_s1791["__p"]["VW"], (1.0 - J.div(v_t_4450, 0.25))) if J.cmp(v_t_4450, 0.25, "<") else 0.0)
		v_by_4453 = J.mul(_s1791["__p"]["VH"], 0.36)
		J.mc(_s1791["__p"]["ctx"], "save", [])
		J.mc(_s1791["__p"]["ctx"], "translate", [v_bx_4434, 0.0])
		var _t5221 = _s1791["__p"]["ctx"]
		J.sp(_t5221, "fillStyle", "rgba(110,20,20,0.92)")
		J.mc(_s1791["__p"]["ctx"], "beginPath", [])
		J.mc(_s1791["__p"]["ctx"], "moveTo", [0.0, v_by_4453])
		J.mc(_s1791["__p"]["ctx"], "lineTo", [_s1791["__p"]["VW"], J.sub(v_by_4453, 30.0)])
		J.mc(_s1791["__p"]["ctx"], "lineTo", [_s1791["__p"]["VW"], J.add(v_by_4453, 120.0)])
		J.mc(_s1791["__p"]["ctx"], "lineTo", [0.0, J.add(v_by_4453, 150.0)])
		J.mc(_s1791["__p"]["ctx"], "closePath", [])
		J.mc(_s1791["__p"]["ctx"], "fill", [])
		var _t5222 = _s1791["__p"]["ctx"]
		J.sp(_t5222, "strokeStyle", "#e8d0a0")
		var _t5223 = _s1791["__p"]["ctx"]
		J.sp(_t5223, "lineWidth", 3.0)
		J.mc(_s1791["__p"]["ctx"], "stroke", [])
		v_q_4439 = 0.0
		while true:
			if not J.cmp(v_q_4439, 14.0, "<"): break
			var _t5224 = _s1791["__p"]["ctx"]
			J.sp(_t5224, "strokeStyle", "rgba(255,220,180,0.25)")
			J.mc(_s1791["__p"]["ctx"], "beginPath", [])
			v_yy_4454 = J.add(v_by_4453, J.mod((J.mul(v_q_4439, 37.0) + J.mul(v_t_4450, 900.0)), 150.0))
			J.mc(_s1791["__p"]["ctx"], "moveTo", [0.0, v_yy_4454])
			J.mc(_s1791["__p"]["ctx"], "lineTo", [_s1791["__p"]["VW"], J.sub(v_yy_4454, 30.0)])
			J.mc(_s1791["__p"]["ctx"], "stroke", [])
			v_q_4439 = J.num(v_q_4439) + 1.0
		var _t5225 = _s1791["__p"]["spr"]
		J.cl(_t5225, null, [J.gp(v_gk_4451, "sprite"), (J.mul(_s1791["__p"]["VW"], 0.27) + (sin(J.num(J.mul(v_t_4450, 20.0))) * 2.0)), J.add(v_by_4453, 148.0), 190.0, {"sx": (1.0 + (0.04 * sin(J.num(J.mul(v_t_4450, 12.0)))))}])
		var _t5226 = _s1791["__p"]["ctx"]
		J.sp(_t5226, "fillStyle", "#ffe9c0")
		var _t5227 = _s1791["__p"]["ctx"]
		J.sp(_t5227, "strokeStyle", "#000")
		var _t5228 = _s1791["__p"]["ctx"]
		J.sp(_t5228, "lineWidth", 5.0)
		var _t5229 = _s1791["__p"]["ctx"]
		var _t5230 = J.add("bold 40px ", _s1791["__p"]["FONT"])
		J.sp(_t5229, "font", _t5230)
		var _t5231 = _s1791["__p"]["ctx"]
		J.sp(_t5231, "textAlign", "left")
		J.mc(_s1791["__p"]["ctx"], "strokeText", [J.gp(J.gp(_s1791["__p"]["ULT"], J.gp(v_gk_4451, "key")), "n"), J.mul(_s1791["__p"]["VW"], 0.5), J.add(v_by_4453, 58.0)])
		J.mc(_s1791["__p"]["ctx"], "fillText", [J.gp(J.gp(_s1791["__p"]["ULT"], J.gp(v_gk_4451, "key")), "n"), J.mul(_s1791["__p"]["VW"], 0.5), J.add(v_by_4453, 58.0)])
		var _t5232 = _s1791["__p"]["ctx"]
		var _t5233 = J.add("bold 14px ", _s1791["__p"]["FONT"])
		J.sp(_t5232, "font", _t5233)
		var _t5234 = _s1791["__p"]["ctx"]
		J.sp(_t5234, "lineWidth", 3.0)
		J.mc(_s1791["__p"]["ctx"], "strokeText", [J.gp(J.gp(_s1791["__p"]["ULT"], J.gp(v_gk_4451, "key")), "d"), (J.mul(_s1791["__p"]["VW"], 0.5) - 20.0), J.add(v_by_4453, 92.0), J.mul(_s1791["__p"]["VW"], 0.52)])
		J.mc(_s1791["__p"]["ctx"], "fillText", [J.gp(J.gp(_s1791["__p"]["ULT"], J.gp(v_gk_4451, "key")), "d"), (J.mul(_s1791["__p"]["VW"], 0.5) - 20.0), J.add(v_by_4453, 92.0), J.mul(_s1791["__p"]["VW"], 0.52)])
		J.mc(_s1791["__p"]["ctx"], "restore", [])
	var _t5235 = J.gp(J.G.get("window"), "__twNat")
	var _t5236 = (_s1791["__p"]["LIFT"] if J.t(_t5235) else _t5235)
	if J.t((J.gp(_s1791["__p"]["LIFT"], "drawW") if J.t(_t5236) else _t5236)):
		J.mc(_s1791["__p"]["LIFT"], "drawW", [])
	J.cl(_s1791["__p"]["drawHUD"], null, [])

func _f755(this_, a: Array, env):
	var v_o_4597 = null; var v_i_4598 = null; var v_x_4599 = null; var v_y_4600 = null; var v_full_4601 = null; var v_act_4602 = null; var v_pz_4603 = null; var v_dy_4604 = null
	v_o_4597 = J.arg(a, 0)
	v_i_4598 = J.arg(a, 1)
	v_x_4599 = (10.0 + J.mul(v_i_4598, 72.0))
	v_y_4600 = J.add(env["y0"], 12.0)
	var _t5261 = J.cmp(J.gp(v_o_4597, "energy"), 100.0, ">=")
	v_full_4601 = ((not J.t(J.gp(v_o_4597, "home"))) if _t5261 else _t5261)
	v_act_4602 = J.seq(v_i_4598, J.gp(env["__p"]["G"], "active"))
	J.mc(env["__p"]["buttons"], "push", [{"id": J.add("gh", v_i_4598), "x": v_x_4599, "y": v_y_4600, "w": 64.0, "h": 74.0}])
	var _t5262 = env["__p"]["crPressed"]
	v_pz_4603 = J.cl(_t5262, null, [J.add("gh", v_i_4598)])
	v_dy_4604 = (2.0 if J.t(v_pz_4603) else 0.0)
	if J.t(v_full_4601):
		J.mc(env["__p"]["ctx"], "save", [])
		var _t5263 = env["__p"]["ctx"]
		var _t5264 = (0.45 + (0.35 * sin(J.num(J.mul(J.gp(env["__p"]["G"], "t"), 8.0)))))
		J.sp(_t5263, "globalAlpha", _t5264)
		var _t5265 = env["__p"]["crBlit"]
		var _t5267 = env["__p"]["ctx"]
		var _t5266 = env["__p"]["crGet"]
		J.cl(_t5265, null, [_t5267, J.cl(_t5266, null, [72.0, 82.0, "rust", "panel"]), J.sub(v_x_4599, 4.0), J.add(J.sub(v_y_4600, 4.0), v_dy_4604)])
		J.mc(env["__p"]["ctx"], "restore", [])
	var _t5268 = env["__p"]["crBlit"]
	var _t5270 = env["__p"]["ctx"]
	var _t5269 = env["__p"]["crGet"]
	J.cl(_t5268, null, [_t5270, J.cl(_t5269, null, [64.0, 74.0, ("rust" if J.t(v_full_4601) else ("moss" if J.t(v_act_4602) else "ink")), ("p" if J.t(v_pz_4603) else "n")]), v_x_4599, J.add(v_y_4600, v_dy_4604)])
	var _t5271 = env["__p"]["sprite"]
	var _t5273 = J.gp(J.gp(v_o_4597, "d"), "sprite")
	var _t5274 = J.add(v_x_4599, 32.0)
	var _t5275 = J.add(J.add(v_y_4600, 58.0), v_dy_4604)
	var _t5272 = J.gp(v_o_4597, "home")
	J.cl(_t5271, null, [_t5273, _t5274, _t5275, 46.0, false, (0.3 if J.t((_t5272 if J.t(_t5272) else J.gp(v_o_4597, "out"))) else 1.0)])
	var _t5276 = env["__p"]["crBar"]
	J.cl(_t5276, null, [env["__p"]["ctx"], J.add(v_x_4599, 6.0), J.add(J.add(v_y_4600, 5.0), v_dy_4604), 52.0, 6.0, J.div(J.gp(v_o_4597, "energy"), 100.0), ("rust" if J.t(v_full_4601) else "red")])
	if J.t(v_full_4601):
		var _t5277 = env["__p"]["crText"]
		J.cl(_t5277, null, [env["__p"]["ctx"], "點我放大招", J.add(v_x_4599, 32.0), J.add(J.add(v_y_4600, 24.0), v_dy_4604), 11.0, "#f6dcb6", "center", 60.0])
	var _t5278 = env["__p"]["crText"]
	J.cl(_t5278, null, [env["__p"]["ctx"], ("被收服" if J.t(J.gp(v_o_4597, "out")) else ("已返" if J.t(J.gp(v_o_4597, "home")) else J.add(J.gp(J.gp(v_o_4597, "d"), "name"), ((J.add(" ", J.gp(v_o_4597, "caught")) + "/3") if J.t(J.gp(v_o_4597, "caught")) else "")))), J.add(v_x_4599, 32.0), J.add(J.add(v_y_4600, 69.0), v_dy_4604), 12.0, ("#e4ecd2" if J.t(v_act_4602) else "#ebe3d6"), "center", 60.0])
	var _t5279 = env["__p"]["gpBadge"]
	J.cl(_t5279, null, [v_o_4597, v_x_4599, J.add(v_y_4600, v_dy_4604)])

func _f754(this_, a: Array, env):
	var v_fr_4586 = null; var v_g_4588 = null; var v_n_4589 = null; var v_atP_4590 = null; var v_A_4591 = null; var v_U_4592 = null; var v_aw_4593 = null; var v_hw_4594 = null
	var _s1907 = {"__p": env, "y0": null}
	var _t5237 = _s1907["__p"]["crPanel"]
	J.cl(_t5237, null, [_s1907["__p"]["ctx"], (-8.0), (-8.0), J.add(_s1907["__p"]["VW"], 16.0), J.add(_s1907["__p"]["TOP"], 8.0), "paper"])
	v_fr_4586 = J.min_([1.0, J.div(J.gp(_s1907["__p"]["G"], "t"), J.mul(_s1907["__p"]["PHT"], 3.0))])
	var _t5238 = _s1907["__p"]["crBar"]
	J.cl(_t5238, null, [_s1907["__p"]["ctx"], 12.0, 8.0, J.sub(_s1907["__p"]["VW"], 24.0), 15.0, v_fr_4586, "dawn"])
	var _t5239 = _s1907["__p"]["crText"]
	J.cl(_t5239, null, [_s1907["__p"]["ctx"], J.add(((((J.add("陰門死守 ", ceil(J.num(J.sub(30.0, J.gp(J.gp(_s1907["__p"]["G"], "gate"), "t"))))) + " 秒　") if J.t(J.gp(_s1907["__p"]["G"], "gate")) else "") + ((J.add(J.add(J.gp(_s1907["__p"]["PH"], J.gp(_s1907["__p"]["G"], "phase")), "　天光 "), floor(J.num(J.mul(v_fr_4586, 100.0)))) + "%") if J.cmp(J.gp(_s1907["__p"]["G"], "phase"), 3.0, "<") else (J.add("天光後・追兵第 ", J.gp(_s1907["__p"]["G"], "wave")) + " 輪"))) + "　警覺 "), J.gp(_s1907["__p"]["G"], "alert")), 14.0, 44.0, 15.0, ("#e8b4a0" if J.cmp(J.gp(_s1907["__p"]["G"], "alert"), 3.0, ">=") else "#efe5cf"), "left", J.sub(_s1907["__p"]["VW"], 110.0)])
	var _t5240 = _s1907["__p"]["crText"]
	J.cl(_t5240, null, [_s1907["__p"]["ctx"], J.add("怕意 ", J.gp(_s1907["__p"]["G"], "fear")), J.sub(_s1907["__p"]["VW"], 14.0), 44.0, 15.0, "#b2d394", "right"])
	var _t5241 = _s1907["__p"]["crText"]
	var _t5246 = _s1907["__p"]["ctx"]
	var _t5243 = (J.add((J.add((J.add("收穫 ", J.len(J.gp(_s1907["__p"]["G"], "bag"))) + "/"), _s1907["__p"]["BAGMAX"]) + "　紙人 "), J.gp(_s1907["__p"]["G"], "dolls")) + "/6　匙 紅")
	var _t5242 = J.gp(J.gp(_s1907["__p"]["G"], "keys"), "key")
	var _t5245 = (J.add(_t5243, (_t5242 if J.t(_t5242) else 0.0)) + " 黃")
	var _t5244 = J.gp(J.gp(_s1907["__p"]["G"], "keys"), "key2")
	J.cl(_t5241, null, [_t5246, (J.add(_t5245, (_t5244 if J.t(_t5244) else 0.0)) + ("　帶住失物" if J.t(J.gp(_s1907["__p"]["G"], "carry")) else "")), 14.0, 68.0, 13.0, "#cfc4b0", "left", J.sub(_s1907["__p"]["VW"], 118.0)])
	var _t5247 = _s1907["__p"]["btn"]
	J.cl(_t5247, null, ["story", J.sub(_s1907["__p"]["VW"], 100.0), 48.0, 90.0, 44.0, J.add((J.add("故事 ", J.len(J.gp(_s1907["__p"]["G"], "story"))) + "/"), J.len(_s1907["__p"]["STORY"])), "#2e3a34"])
	J.cl(_s1907["__p"]["drawMini"], null, [])
	if J.t(J.gp(_s1907["__p"]["cam"], "free")):
		var _t5248 = _s1907["__p"]["btn"]
		J.cl(_t5248, null, ["follow", (J.div(_s1907["__p"]["VW"], 2.0) - 66.0), J.add(_s1907["__p"]["TOP"], 8.0), 132.0, 46.0, "◎ 跟返隻鬼", "#2f5a4a"])
	var _t5249 = _s1907["__p"]["btn"]
	J.cl(_t5249, null, ["quit", 10.0, J.add(_s1907["__p"]["TOP"], 8.0), 62.0, 46.0, "離開", "#2c2c33"])
	var _t5250 = _s1907["__p"]["btn"]
	J.cl(_t5250, null, ["zin", J.sub(_s1907["__p"]["VW"], 56.0), J.add(_s1907["__p"]["TOP"], 8.0), 46.0, 46.0, "＋", "#24242a"])
	var _t5251 = _s1907["__p"]["btn"]
	J.cl(_t5251, null, ["zout", J.sub(_s1907["__p"]["VW"], 56.0), J.add(_s1907["__p"]["TOP"], 60.0), 46.0, 46.0, "－", "#24242a"])
	_s1907["y0"] = J.sub(_s1907["__p"]["VH"], _s1907["__p"]["BOT"])
	var _t5252 = _s1907["__p"]["crPanel"]
	J.cl(_t5252, null, [_s1907["__p"]["ctx"], (-8.0), _s1907["y0"], J.add(_s1907["__p"]["VW"], 16.0), J.add(_s1907["__p"]["BOT"], 8.0), "paper"])
	var _t5253 = J.cmp(J.gp(_s1907["__p"]["G"], "toastT"), 0.0, ">")
	if J.t((J.gp(_s1907["__p"]["G"], "toast") if _t5253 else _t5253)):
		var _t5254 = _s1907["__p"]["crPanel"]
		J.cl(_t5254, null, [_s1907["__p"]["ctx"], 10.0, J.sub(_s1907["y0"], 58.0), J.sub(_s1907["__p"]["VW"], 20.0), 52.0, "sheet"])
		var _t5255 = _s1907["__p"]["ctx"]
		J.sp(_t5255, "fillStyle", "#efdcb4")
		var _t5256 = _s1907["__p"]["ctx"]
		var _t5257 = J.add("bold 13px ", _s1907["__p"]["FONT"])
		J.sp(_t5256, "font", _t5257)
		var _t5258 = _s1907["__p"]["ctx"]
		J.sp(_t5258, "textAlign", "left")
		var _t5259 = _s1907["__p"]["wrap"]
		J.cl(_t5259, null, [J.gp(_s1907["__p"]["G"], "toast"), 20.0, J.sub(_s1907["y0"], 37.0), J.sub(_s1907["__p"]["VW"], 40.0), 17.0])
	var _t5260 = J.gp(_s1907["__p"]["G"], "gh")
	J.mc(_t5260, "forEach", [Callable(self, "_f755").bind(_s1907)])
	v_g_4588 = J.gp(J.gp(_s1907["__p"]["G"], "gh"), J.gp(_s1907["__p"]["G"], "active"))
	v_n_4589 = J.gp(J.gp(_s1907["__p"]["G"], "nodes"), J.gp(v_g_4588, "node"))
	var _t5280 = (not J.t(J.gp(v_g_4588, "to")))
	var _t5281 = (J.seq(J.gp(v_n_4589, "kind"), "portal") if _t5280 else _t5280)
	v_atP_4590 = ((not J.t(J.gp(v_g_4588, "home"))) if _t5281 else _t5281)
	var _t5282 = _s1907["__p"]["btn"]
	J.cl(_t5282, null, ["scare", J.sub(_s1907["__p"]["VW"], 170.0), J.add(_s1907["y0"], 12.0), 74.0, 52.0, "嚇！", "#6e1c1c"])
	var _t5283 = _s1907["__p"]["btn"]
	J.cl(_t5283, null, ["inv", J.sub(_s1907["__p"]["VW"], 88.0), J.add(_s1907["y0"], 12.0), 76.0, 52.0, (J.add("隱身 ", ceil(J.num(J.gp(v_g_4588, "invCd")))) if J.cmp(J.gp(v_g_4588, "invCd"), 0.0, ">") else "隱身"), "#2a4a7a", J.cmp(J.gp(v_g_4588, "invCd"), 0.0, "<=")])
	var _t5284 = _s1907["__p"]["ctxAction"]
	v_A_4591 = J.cl(_t5284, null, [v_g_4588])
	var _t5285 = J.cmp(J.gp(v_g_4588, "energy"), 100.0, ">=")
	var _t5286 = ((not J.t(J.gp(v_g_4588, "home"))) if _t5285 else _t5285)
	var _t5287 = ((not J.t(J.gp(v_g_4588, "out"))) if _t5286 else _t5286)
	v_U_4592 = ((not J.t(J.gp(_s1907["__p"]["G"], "ult"))) if _t5287 else _t5287)
	v_aw_4593 = (J.div(J.sub(_s1907["__p"]["VW"], 30.0), 2.0) if J.t(v_U_4592) else J.sub(_s1907["__p"]["VW"], 20.0))
	if J.t(v_A_4591):
		var _t5288 = _s1907["__p"]["btn"]
		J.cl(_t5288, null, ["act", 10.0, J.add(_s1907["y0"], 92.0), v_aw_4593, 46.0, J.gp(v_A_4591, "t"), ("#3a3a40" if J.seq(J.gp(v_A_4591, "k"), "respect") else "#3a5a2a"), (not J.seq(J.gp(v_A_4591, "k"), "respect"))])
	else:
		if (not J.t(v_U_4592)):
			var _t5289 = _s1907["__p"]["crText"]
			J.cl(_t5289, null, [_s1907["__p"]["ctx"], "撳住戶＝行過去嚇；企喺電器、水管、𨋢口、樓梯口出「互動」", J.div(_s1907["__p"]["VW"], 2.0), J.add(_s1907["y0"], 120.0), 12.0, "#9a8e92", "center", J.sub(_s1907["__p"]["VW"], 20.0), false, "normal"])
	if J.t(v_U_4592):
		var _t5290 = _s1907["__p"]["btn"]
		J.cl(_t5290, null, ["ult", (J.add(20.0, v_aw_4593) if J.t(v_A_4591) else 10.0), J.add(_s1907["y0"], 92.0), (v_aw_4593 if J.t(v_A_4591) else J.sub(_s1907["__p"]["VW"], 20.0)), 46.0, J.add("放大招：", J.gp(J.gp(_s1907["__p"]["ULT"], J.gp(J.gp(v_g_4588, "d"), "key")), "n")), "#8a5a14"])
	v_hw_4594 = J.div(J.sub(_s1907["__p"]["VW"], 30.0), 2.0)
	var _t5291 = _s1907["__p"]["btn"]
	J.cl(_t5291, null, ["gate", 10.0, J.add(_s1907["y0"], 146.0), v_hw_4594, 44.0, ((J.add("陰門 ", ceil(J.num(J.sub(30.0, J.gp(J.gp(_s1907["__p"]["G"], "gate"), "t"))))) + "s") if J.t(J.gp(_s1907["__p"]["G"], "gate")) else ("開陰門（企定）" if J.t(v_atP_4590) else "陰門：天台/地庫")), "#2f5a4a", ((not J.t(J.gp(_s1907["__p"]["G"], "gate"))) if J.t(v_atP_4590) else v_atP_4590)])
	var _t5292 = _s1907["__p"]["btn"]
	var _t5294 = J.add(20.0, v_hw_4594)
	var _t5295 = J.add(_s1907["y0"], 146.0)
	var _t5296 = (J.add("替身遁走 ", J.gp(_s1907["__p"]["G"], "dolls")) + "/6")
	var _t5293 = J.cmp(J.gp(_s1907["__p"]["G"], "dolls"), 6.0, ">=")
	J.cl(_t5292, null, ["doll", _t5294, _t5295, v_hw_4594, 44.0, _t5296, "#5a1c1c", ((not J.t(J.gp(_s1907["__p"]["G"], "gate"))) if _t5293 else _t5293)])
	var _t5297 = _s1907["__p"]["crText"]
	J.cl(_t5297, null, [_s1907["__p"]["ctx"], "拖動＝移動；鬆手企定先嚇人、搜嘢、附身、破鎮宅", J.div(_s1907["__p"]["VW"], 2.0), J.sub(_s1907["__p"]["VH"], 12.0), 12.0, "#9a8e92", "center", J.sub(_s1907["__p"]["VW"], 16.0), false, "normal"])
	if J.t(J.gp(_s1907["__p"]["G"], "choice")):
		J.cl(_s1907["__p"]["drawChoice"], null, [])
	if J.t(J.gp(_s1907["__p"]["G"], "showStory")):
		J.cl(_s1907["__p"]["drawStory"], null, [])
	if J.t(J.gp(_s1907["__p"]["G"], "over")):
		J.cl(_s1907["__p"]["drawOver"], null, [])

func _f756(this_, a: Array, env):
	var v_t_4607 = null; var v_x_4608 = null; var v_y_4609 = null; var v_w_4610 = null; var v_lh_4611 = null; var v_line_4612 = null; var v_yy_4613 = null; var v_i_4614 = null; var v_tt_4615 = null
	v_t_4607 = J.arg(a, 0)
	v_x_4608 = J.arg(a, 1)
	v_y_4609 = J.arg(a, 2)
	v_w_4610 = J.arg(a, 3)
	v_lh_4611 = J.arg(a, 4)
	v_line_4612 = ""
	v_yy_4613 = v_y_4609
	v_i_4614 = 0.0
	while true:
		if not J.cmp(v_i_4614, J.len(v_t_4607), "<"): break
		v_tt_4615 = J.add(v_line_4612, J.gp(v_t_4607, v_i_4614))
		if J.cmp(J.gp(J.mc(env["ctx"], "measureText", [v_tt_4615]), "width"), v_w_4610, ">"):
			var _t5298 = env["crFill"]
			J.cl(_t5298, null, [v_line_4612, v_x_4608, v_yy_4613])
			v_line_4612 = J.gp(v_t_4607, v_i_4614)
			var _t5299 = J.add(v_yy_4613, v_lh_4611)
			v_yy_4613 = _t5299
		else:
			v_line_4612 = v_tt_4615
		v_i_4614 = J.num(v_i_4614) + 1.0
	var _t5300 = env["crFill"]
	J.cl(_t5300, null, [v_line_4612, v_x_4608, v_yy_4613])
	return v_yy_4613

func _f757(this_, a: Array, env):
	var v_h_4618 = null; var v_y_4619 = null
	v_h_4618 = J.arg(a, 0)
	var _t5301 = env["ctx"]
	J.sp(_t5301, "fillStyle", "rgba(6,3,8,0.78)")
	J.mc(env["ctx"], "fillRect", [0.0, 0.0, env["VW"], env["VH"]])
	v_y_4619 = J.div(J.sub(env["VH"], v_h_4618), 2.0)
	var _t5302 = env["crPanel"]
	J.cl(_t5302, null, [env["ctx"], 16.0, v_y_4619, J.sub(env["VW"], 32.0), v_h_4618, "sheet"])
	var _t5303 = []
	env["buttons"] = _t5303
	return v_y_4619

func _f759(this_, a: Array, env):
	var v_c_4626 = null; var v_i_4627 = null; var v_by_4628 = null
	v_c_4626 = J.arg(a, 0)
	v_i_4627 = J.arg(a, 1)
	v_by_4628 = J.add(J.add(env["y"], 52.0), J.mul(v_i_4627, 88.0))
	var _t5313 = env["__p"]["btn"]
	J.cl(_t5313, null, [J.add("card", v_i_4627), 26.0, v_by_4628, J.sub(env["__p"]["VW"], 52.0), 78.0, "", "#26262c"])
	var _t5314 = env["__p"]["ctx"]
	J.sp(_t5314, "fillStyle", "#ffd54a")
	var _t5315 = env["__p"]["ctx"]
	var _t5316 = J.add("bold 18px ", env["__p"]["FONT"])
	J.sp(_t5315, "font", _t5316)
	var _t5317 = env["__p"]["crFill"]
	J.cl(_t5317, null, [J.gp(v_c_4626, "t"), J.div(env["__p"]["VW"], 2.0), J.add(v_by_4628, 32.0), J.sub(env["__p"]["VW"], 70.0)])
	var _t5318 = env["__p"]["ctx"]
	J.sp(_t5318, "fillStyle", "#d6dad2")
	var _t5319 = env["__p"]["ctx"]
	var _t5320 = J.add("bold 14px ", env["__p"]["FONT"])
	J.sp(_t5319, "font", _t5320)
	var _t5321 = env["__p"]["crFill"]
	J.cl(_t5321, null, [J.gp(v_c_4626, "d"), J.div(env["__p"]["VW"], 2.0), J.add(v_by_4628, 58.0), J.sub(env["__p"]["VW"], 70.0)])

func _f758(this_, a: Array, env):
	var v_h_4622 = null
	var _s1917 = {"__p": env, "y": null}
	v_h_4622 = 330.0
	_s1917["y"] = (J.sub(_s1917["__p"]["VH"], v_h_4622) - 8.0)
	var _t5304 = _s1917["__p"]["ctx"]
	J.sp(_t5304, "fillStyle", "rgba(6,3,8,0.45)")
	J.mc(_s1917["__p"]["ctx"], "fillRect", [0.0, 0.0, _s1917["__p"]["VW"], _s1917["__p"]["VH"]])
	var _t5305 = _s1917["__p"]["crPanel"]
	J.cl(_t5305, null, [_s1917["__p"]["ctx"], 10.0, _s1917["y"], J.sub(_s1917["__p"]["VW"], 20.0), v_h_4622, "sheet"])
	var _t5306 = []
	_s1917["__p"]["buttons"] = _t5306
	var _t5307 = _s1917["__p"]["ctx"]
	J.sp(_t5307, "fillStyle", "#fff")
	var _t5308 = _s1917["__p"]["ctx"]
	var _t5309 = J.add("bold 19px ", _s1917["__p"]["FONT"])
	J.sp(_t5308, "font", _t5309)
	var _t5310 = _s1917["__p"]["ctx"]
	J.sp(_t5310, "textAlign", "center")
	var _t5311 = _s1917["__p"]["crFill"]
	J.cl(_t5311, null, ["怕意滿咗！揀一樣強化", J.div(_s1917["__p"]["VW"], 2.0), J.add(_s1917["y"], 36.0)])
	var _t5312 = J.gp(_s1917["__p"]["G"], "choice")
	J.mc(_t5312, "forEach", [Callable(self, "_f759").bind(_s1917)])

func _f761(this_, a: Array, env):
	var v_q_4637 = null
	v_q_4637 = J.arg(a, 0)
	var _t5349 = env["__p"]["ctx"]
	var _t5350 = ("#8affc8" if J.seq(J.gp(v_q_4637, "state"), 2.0) else "#d8d8d0")
	J.sp(_t5349, "fillStyle", _t5350)
	var _t5351 = env["__p"]["wrap"]
	var _t5353 = J.add(("✓ " if J.seq(J.gp(v_q_4637, "state"), 2.0) else "・"), J.gp(v_q_4637, "t"))
	var _t5352 = J.seq(J.gp(v_q_4637, "id"), "debt")
	var _t5354 = J.add(J.cl(_t5351, null, [(_t5353 + ("（遲啲先出現）" if (J.seq(J.gp(v_q_4637, "state"), 0.0) if _t5352 else _t5352) else "")), 28.0, env["yy"], J.sub(env["__p"]["VW"], 56.0), 16.0]), 20.0)
	env["yy"] = _t5354

func _f760(this_, a: Array, env):
	var v_H0_4631 = null; var v_y_4632 = null; var v_f_4634 = null
	var _s1919 = {"__p": env, "yy": null}
	v_H0_4631 = J.min_([J.sub(_s1919["__p"]["VH"], 40.0), 620.0])
	var _t5322 = _s1919["__p"]["panel"]
	v_y_4632 = J.cl(_t5322, null, [v_H0_4631])
	var _t5323 = _s1919["__p"]["ctx"]
	J.sp(_t5323, "fillStyle", "#fff")
	var _t5324 = _s1919["__p"]["ctx"]
	var _t5325 = J.add("bold 18px ", _s1919["__p"]["FONT"])
	J.sp(_t5324, "font", _t5325)
	var _t5326 = _s1919["__p"]["ctx"]
	J.sp(_t5326, "textAlign", "center")
	var _t5327 = _s1919["__p"]["crFill"]
	J.cl(_t5327, null, [(J.add((J.add(J.add(J.gp(_s1919["__p"]["LV"], "name"), "嘅故事（"), J.len(J.gp(_s1919["__p"]["G"], "story"))) + "/"), J.len(_s1919["__p"]["STORY"])) + "）"), J.div(_s1919["__p"]["VW"], 2.0), J.add(v_y_4632, 34.0)])
	var _t5328 = _s1919["__p"]["ctx"]
	J.sp(_t5328, "textAlign", "left")
	var _t5329 = _s1919["__p"]["ctx"]
	var _t5330 = J.add("13px ", _s1919["__p"]["FONT"])
	J.sp(_t5329, "font", _t5330)
	_s1919["yy"] = J.add(v_y_4632, 60.0)
	v_f_4634 = 0.0
	while true:
		if not J.cmp(v_f_4634, J.len(_s1919["__p"]["STORY"]), "<"): break
		var _t5331 = _s1919["__p"]["ctx"]
		var _t5332 = J.gp(_s1919["__p"]["G"], "story")
		var _t5333 = ("#ecece6" if J.cmp(J.mc(_t5332, "indexOf", [v_f_4634]), 0.0, ">=") else "#5a5e58")
		J.sp(_t5331, "fillStyle", _t5333)
		var _t5334 = _s1919["__p"]["wrap"]
		var _t5335 = J.gp(_s1919["__p"]["G"], "story")
		var _t5336 = J.add(J.cl(_t5334, null, [(J.gp(_s1919["__p"]["STORY"], v_f_4634) if J.cmp(J.mc(_t5335, "indexOf", [v_f_4634]), 0.0, ">=") else J.add(J.gp(J.gp(_s1919["__p"]["LV"], "hint"), v_f_4634), "：？？？（嚇走「✦故事」戶或者完成支線）")), 28.0, _s1919["yy"], J.sub(_s1919["__p"]["VW"], 56.0), 16.0]), 22.0)
		_s1919["yy"] = _t5336
		v_f_4634 = J.num(v_f_4634) + 1.0
	if J.seq(J.len(J.gp(_s1919["__p"]["G"], "story")), J.len(_s1919["__p"]["STORY"])):
		var _t5337 = _s1919["__p"]["ctx"]
		J.sp(_t5337, "fillStyle", "#ffd54a")
		var _t5338 = _s1919["__p"]["wrap"]
		var _t5339 = J.add(J.cl(_t5338, null, [_s1919["__p"]["TRUTH"], 28.0, _s1919["yy"], J.sub(_s1919["__p"]["VW"], 56.0), 16.0]), 24.0)
		_s1919["yy"] = _t5339
	var _t5340 = _s1919["__p"]["ctx"]
	J.sp(_t5340, "fillStyle", "#9fd6bf")
	var _t5341 = _s1919["__p"]["ctx"]
	var _t5342 = J.add("bold 13px ", _s1919["__p"]["FONT"])
	J.sp(_t5341, "font", _t5342)
	var _t5343 = _s1919["__p"]["crFill"]
	J.cl(_t5343, null, ["支線", 28.0, _s1919["yy"]])
	var _t5344 = J.add(_s1919["yy"], 20.0)
	_s1919["yy"] = _t5344
	var _t5345 = _s1919["__p"]["ctx"]
	var _t5346 = J.add("12px ", _s1919["__p"]["FONT"])
	J.sp(_t5345, "font", _t5346)
	var _t5347 = J.gp(_s1919["__p"]["G"], "quests")
	var _t5348 = (_t5347 if J.t(_t5347) else [])
	J.mc(_t5348, "forEach", [Callable(self, "_f761").bind(_s1919)])
	var _t5355 = _s1919["__p"]["btn"]
	J.cl(_t5355, null, ["closeStory", (J.div(_s1919["__p"]["VW"], 2.0) - 60.0), J.sub(J.add(v_y_4632, v_H0_4631), 56.0), 120.0, 46.0, "返去", "#5a1c1c"])

func _f763(this_, a: Array, env):
	var v_m_4645 = null; var v_i_4646 = null
	v_m_4645 = J.arg(a, 0)
	v_i_4646 = J.arg(a, 1)
	var _t5366 = env["__p"]["crFill"]
	J.cl(_t5366, null, [v_m_4645, J.div(env["__p"]["VW"], 2.0), J.add(J.add(env["y"], 90.0), J.mul(v_i_4646, 30.0)), J.sub(env["__p"]["VW"], 50.0)])

func _f762(this_, a: Array, env):
	var v_o_4640 = null; var v_msg_4642 = null
	var _s1924 = {"__p": env, "y": null}
	v_o_4640 = J.gp(_s1924["__p"]["G"], "over")
	var _t5356 = _s1924["__p"]["panel"]
	_s1924["y"] = J.cl(_t5356, null, [420.0])
	var _t5357 = _s1924["__p"]["ctx"]
	J.sp(_t5357, "textAlign", "center")
	var _t5358 = _s1924["__p"]["ctx"]
	var _t5359 = ("#8affc8" if J.t(J.gp(v_o_4640, "ok")) else "#ff9a9a")
	J.sp(_t5358, "fillStyle", _t5359)
	var _t5360 = _s1924["__p"]["ctx"]
	var _t5361 = J.add("bold 26px ", _s1924["__p"]["FONT"])
	J.sp(_t5360, "font", _t5361)
	var _t5362 = _s1924["__p"]["crFill"]
	J.cl(_t5362, null, [("陰門撤離成功！" if J.seq(J.gp(v_o_4640, "why"), "gate") else ("替身遁走！" if J.seq(J.gp(v_o_4640, "why"), "doll") else "被圍收服……")), J.div(_s1924["__p"]["VW"], 2.0), J.add(_s1924["y"], 44.0)])
	var _t5363 = _s1924["__p"]["ctx"]
	J.sp(_t5363, "fillStyle", "#fff")
	var _t5364 = _s1924["__p"]["ctx"]
	var _t5365 = J.add("bold 15px ", _s1924["__p"]["FONT"])
	J.sp(_t5364, "font", _t5365)
	v_msg_4642 = ([(J.add("返到陰間嘅鬼：", J.gp(v_o_4640, "home")) + " 隻"), (J.add("帶走全部收穫：", J.gp(v_o_4640, "kept")) + " 件"), J.add((J.add("收服故事碎片：", J.gp(v_o_4640, "story")) + "/"), J.len(_s1924["__p"]["STORY"])), J.add("今晚怕意總共：", J.gp(v_o_4640, "fear")), J.add("全樓警覺：", J.gp(v_o_4640, "alert"))] if J.seq(J.gp(v_o_4640, "why"), "gate") else ([(J.add("用替身紙人遁走：", J.gp(v_o_4640, "home")) + " 隻鬼"), (J.add((J.add("帶走一半收穫：", J.gp(v_o_4640, "kept")) + " 件（留低 "), J.gp(v_o_4640, "lost")) + " 件）"), (J.add("故事碎片冇得帶走（", J.gp(v_o_4640, "storyLost")) + " 塊留咗喺樓入面）"), J.add("今晚怕意總共：", J.gp(v_o_4640, "fear"))] if J.seq(J.gp(v_o_4640, "why"), "doll") else ["三隻鬼全部畀人收服", (J.add("收穫全部冇晒：", J.gp(v_o_4640, "lost")) + " 件"), J.add("今晚怕意總共：", J.gp(v_o_4640, "fear")), J.add("全樓警覺：", J.gp(v_o_4640, "alert"))]))
	J.mc(v_msg_4642, "forEach", [Callable(self, "_f763").bind(_s1924)])
	if J.seq(J.gp(v_o_4640, "story"), J.len(_s1924["__p"]["STORY"])):
		var _t5367 = _s1924["__p"]["ctx"]
		J.sp(_t5367, "fillStyle", "#ffd54a")
		var _t5368 = _s1924["__p"]["ctx"]
		var _t5369 = J.add("bold 13px ", _s1924["__p"]["FONT"])
		J.sp(_t5368, "font", _t5369)
		var _t5370 = _s1924["__p"]["ctx"]
		J.sp(_t5370, "textAlign", "left")
		var _t5371 = _s1924["__p"]["wrap"]
		J.cl(_t5371, null, [_s1924["__p"]["TRUTH"], 36.0, J.add(_s1924["y"], 250.0), J.sub(_s1924["__p"]["VW"], 72.0), 18.0])
	if (not J.t(J.gp(v_o_4640, "ok"))):
		var _t5372 = _s1924["__p"]["gpOver"]
		J.cl(_t5372, null, [v_o_4640, _s1924["y"]])
	var _t5373 = _s1924["__p"]["btn"]
	J.cl(_t5373, null, ["again", (J.div(_s1924["__p"]["VW"], 2.0) - 130.0), J.sub(J.add(_s1924["y"], 420.0), 60.0), 120.0, 44.0, "再嚟一晚", "#5a1c1c"])
	var _t5374 = _s1924["__p"]["btn"]
	J.cl(_t5374, null, ["toMap", (J.div(_s1924["__p"]["VW"], 2.0) + 10.0), J.sub(J.add(_s1924["y"], 420.0), 60.0), 120.0, 44.0, "返地圖", "#2c2c33"])
	if (not J.leq(J.gp(v_o_4640, "reward"), null)):
		var _t5375 = _s1924["__p"]["crText"]
		J.cl(_t5375, null, [_s1924["__p"]["ctx"], J.add("收到冥幣 +", J.gp(v_o_4640, "reward")), J.div(_s1924["__p"]["VW"], 2.0), J.sub(J.add(_s1924["y"], 420.0), 76.0), 17.0, "#e6a85a", "center"])

func _f764(this_, a: Array, env):
	var v_r_4649 = null; var v_y_4650 = null; var v_p_4651 = null; var v_k_4652 = null
	var _t5376 = env["crRnd"]
	v_r_4649 = J.cl(_t5376, null, [5.0])
	v_y_4650 = (J.mul(env["VH"], 0.24) + 52.0)
	J.mc(env["ctx"], "save", [])
	var _t5377 = env["ctx"]
	J.sp(_t5377, "strokeStyle", "#7a2522")
	var _t5378 = env["ctx"]
	J.sp(_t5378, "lineCap", "round")
	v_p_4651 = 0.0
	while true:
		if not J.cmp(v_p_4651, 3.0, "<"): break
		var _t5379 = env["ctx"]
		var _t5380 = (0.5 + J.mul(J.cl(v_r_4649, null, []), 0.4))
		J.sp(_t5379, "globalAlpha", _t5380)
		var _t5381 = env["ctx"]
		var _t5382 = (2.4 - J.mul(v_p_4651, 0.5))
		J.sp(_t5381, "lineWidth", _t5382)
		J.mc(env["ctx"], "beginPath", [])
		J.mc(env["ctx"], "moveTo", [(J.mul(env["VW"], 0.2) + J.mul(J.cl(v_r_4649, null, []), 6.0)), J.add(v_y_4650, J.mul(J.cl(v_r_4649, null, []), 3.0))])
		v_k_4652 = 1.0
		while true:
			if not J.cmp(v_k_4652, 8.0, "<="): break
			J.mc(env["ctx"], "lineTo", [(J.mul(env["VW"], 0.2) + J.div(J.mul(J.mul(env["VW"], 0.6), v_k_4652), 8.0)), J.add(v_y_4650, (J.sub(J.cl(v_r_4649, null, []), 0.5) * 4.0))])
			v_k_4652 = J.num(v_k_4652) + 1.0
		J.mc(env["ctx"], "stroke", [])
		v_p_4651 = J.num(v_p_4651) + 1.0
	J.mc(env["ctx"], "restore", [])
	var _t5383 = env["crPanel"]
	J.cl(_t5383, null, [env["ctx"], 14.0, (J.mul(env["VH"], 0.62) - 24.0), J.sub(env["VW"], 28.0), ((5.0 * 24.0) + 14.0), "ink"])

func _f766(this_, a: Array, env):
	var v_d_4659 = null; var v_i_4660 = null
	v_d_4659 = J.arg(a, 0)
	v_i_4660 = J.arg(a, 1)
	var _t5394 = env["sprite"]
	J.cl(_t5394, null, [J.gp(v_d_4659, "sprite"), (J.div(env["VW"], 2.0) + (J.sub(v_i_4660, 1.0) * 100.0)), J.mul(env["VH"], 0.52), J.mul(J.gp(v_d_4659, "h"), 1.5)])

func _f767(this_, a: Array, env):
	var v_t_4663 = null; var v_i_4664 = null
	v_t_4663 = J.arg(a, 0)
	v_i_4664 = J.arg(a, 1)
	var _t5399 = env["crFill"]
	J.cl(_t5399, null, [v_t_4663, J.div(env["VW"], 2.0), (J.mul(env["VH"], 0.62) + J.mul(v_i_4664, 24.0)), J.sub(env["VW"], 30.0)])

func _f765(this_, a: Array, env):
	var v_sv_4655 = null; var v_shopOpen_4656 = null
	J.cl(env["crBg"], null, [])
	J.cl(env["crTitleDeco"], null, [])
	var _t5384 = env["btn"]
	J.cl(_t5384, null, ["exit", 12.0, 14.0, 104.0, 46.0, "◀ 返地圖", "#2c2c33"])
	var _t5385 = env["ctx"]
	J.sp(_t5385, "textAlign", "center")
	var _t5386 = env["ctx"]
	J.sp(_t5386, "fillStyle", "#c4493c")
	var _t5387 = env["ctx"]
	var _t5388 = J.add("bold 40px ", env["FONT"])
	J.sp(_t5387, "font", _t5388)
	var _t5389 = env["crFill"]
	J.cl(_t5389, null, ["樓裡有鬼", J.div(env["VW"], 2.0), J.mul(env["VH"], 0.24)])
	var _t5390 = env["ctx"]
	var _t5391 = J.add("bold 16px ", env["FONT"])
	J.sp(_t5390, "font", _t5391)
	var _t5392 = env["ctx"]
	J.sp(_t5392, "fillStyle", "#d8ccb0")
	var _t5393 = env["crFill"]
	J.cl(_t5393, null, ["揀一棟樓・天光前返陰間", J.div(env["VW"], 2.0), (J.mul(env["VH"], 0.24) + 36.0)])
	J.mc(env["GH"], "forEach", [Callable(self, "_f766").bind(env)])
	var _t5395 = env["ctx"]
	J.sp(_t5395, "fillStyle", "#c8ccc4")
	var _t5396 = env["ctx"]
	var _t5397 = J.add("bold 14px ", env["FONT"])
	J.sp(_t5396, "font", _t5397)
	var _t5398 = ["三隻鬼一齊出動：餓鬼搵宵夜、Toyol 偷錢、天花姐梳頭。", "成棟樓幾十戶人：打機、返夜更、打麻雀、網購……", "保安唔係捉鬼師傅：附身電器、敲水管、叫𨋢引開佢。", "有紅紙符、門神、拿督公、祖先牌位要尊重，繞路行。", "子時→丑時→寅時，天光前由地庫或天台陰門返陰間。"]
	J.mc(_t5398, "forEach", [Callable(self, "_f767").bind(env)])
	v_sv_4655 = J.cl(env["TS"], null, [])
	var _t5400 = (not (not J.t(J.gp(J.gp(v_sv_4655, "cleared"), "flat"))))
	var _t5401 = (_t5400 if _t5400 else J.mc(env["Q"], "has", ["unlock"]))
	v_shopOpen_4656 = (_t5401 if J.t(_t5401) else (not (not J.t(J.gp(J.G.get("window"), "STN_TEST")))))
	var _t5402 = env["btn"]
	J.cl(_t5402, null, ["lv_flat", 22.0, J.mul(env["VH"], 0.8), J.div(J.sub(env["VW"], 56.0), 2.0), 58.0, ("組屋" + (" ✓" if J.t(J.gp(J.gp(v_sv_4655, "cleared"), "flat")) else "")), "#5a1c1c"])
	var _t5403 = env["btn"]
	J.cl(_t5403, null, ["lv_shop", (34.0 + J.div(J.sub(env["VW"], 56.0), 2.0)), J.mul(env["VH"], 0.8), J.div(J.sub(env["VW"], 56.0), 2.0), 58.0, (("老店屋" + (" ✓" if J.t(J.gp(J.gp(v_sv_4655, "cleared"), "shop")) else "")) if J.t(v_shopOpen_4656) else "老店屋（未解鎖）"), "#2f5a4a", v_shopOpen_4656])
	var _t5404 = env["ctx"]
	J.sp(_t5404, "fillStyle", "#7a7f78")
	var _t5405 = env["ctx"]
	var _t5406 = J.add("bold 13px ", env["FONT"])
	J.sp(_t5405, "font", _t5406)
	var _t5407 = env["ctx"]
	J.sp(_t5407, "textAlign", "center")
	var _t5408 = env["crFill"]
	J.cl(_t5408, null, [("揀一棟樓開始今晚" if J.t(v_shopOpen_4656) else "組屋過關（安全返陰間）就解鎖老店屋"), J.div(env["VW"], 2.0), (J.mul(env["VH"], 0.8) + (100.0 if J.t(J.gp(J.G.get("window"), "GP")) else 78.0))])
	J.cl(env["gpTitle"], null, [])

func _f772(this_, a: Array, env):
	var v_g_4699 = null; var v_R0_4700 = null; var v_a_4701 = null; var v_b_4702 = null; var v_E_4703 = null; var v_t_4704 = null
	v_g_4699 = J.arg(a, 0)
	v_R0_4700 = J.arg(a, 1)
	var _t5409 = (not J.t(v_g_4699))
	var _t5410 = (_t5409 if _t5409 else (not J.t(J.gp(v_g_4699, "to"))))
	var _t5411 = (_t5410 if _t5410 else J.gp(v_g_4699, "home"))
	if J.t((_t5411 if J.t(_t5411) else J.gp(v_g_4699, "out"))):
		return null
	v_a_4701 = J.gp(J.gp(env["G"], "nodes"), J.gp(v_g_4699, "node"))
	v_b_4702 = J.gp(J.gp(env["G"], "nodes"), J.gp(v_g_4699, "to"))
	v_E_4703 = J.hypot_([J.sub(J.gp(v_b_4702, "x"), J.gp(v_a_4701, "x")), J.sub(J.gp(v_b_4702, "y"), J.gp(v_a_4701, "y"))])
	if J.cmp(J.mul(v_E_4703, J.sub(1.0, J.gp(v_g_4699, "p"))), v_R0_4700, "<="):
		var _t5412 = [J.gp(v_g_4699, "to")]
		J.sp(v_g_4699, "auto", _t5412)
	else:
		if J.cmp(J.mul(v_E_4703, J.gp(v_g_4699, "p")), v_R0_4700, "<="):
			v_t_4704 = J.gp(v_g_4699, "node")
			var _t5413 = J.gp(v_g_4699, "to")
			J.sp(v_g_4699, "node", _t5413)
			J.sp(v_g_4699, "to", v_t_4704)
			var _t5414 = J.sub(1.0, J.gp(v_g_4699, "p"))
			J.sp(v_g_4699, "p", _t5414)
			var _t5415 = [v_t_4704]
			J.sp(v_g_4699, "auto", _t5415)

func _f773(this_, a: Array, env):
	var v_e_4707 = null; var v_r_4708 = null
	v_e_4707 = J.arg(a, 0)
	if (not J.leq(J.gp(v_e_4707, "nx"), null)):
		return {"x": J.gp(v_e_4707, "nx"), "y": J.gp(v_e_4707, "ny")}
	v_r_4708 = J.mc(env["cv"], "getBoundingClientRect", [])
	return {"x": J.sub(J.gp(v_e_4707, "clientX"), J.gp(v_r_4708, "left")), "y": J.sub(J.gp(v_e_4707, "clientY"), J.gp(v_r_4708, "top"))}

func _f774(this_, a: Array, env):
	var v_dx_4711 = null; var v_dy_4712 = null; var v_L_4713 = null
	var _t5416 = (not J.t(env["joy"]))
	if (_t5416 if _t5416 else (not J.t(J.gp(env["joy"], "on")))):
		return null
	v_dx_4711 = J.sub(J.gp(env["joy"], "x"), J.gp(env["joy"], "ox"))
	v_dy_4712 = J.sub(J.gp(env["joy"], "y"), J.gp(env["joy"], "oy"))
	v_L_4713 = J.hypot_([v_dx_4711, v_dy_4712])
	if J.cmp(v_L_4713, env["JR"], ">"):
		var _t5417 = J.mul(v_dx_4711, J.div(env["JR"], v_L_4713))
		v_dx_4711 = _t5417
		var _t5418 = J.mul(v_dy_4712, J.div(env["JR"], v_L_4713))
		v_dy_4712 = _t5418
	return {"x": J.div(v_dx_4711, env["JR"]), "y": J.div(v_dy_4712, env["JR"])}

func _f775(this_, a: Array, env):
	var v_v_4716 = null
	var _t5419 = (not J.t(env["joy"]))
	if (_t5419 if _t5419 else (not J.t(J.gp(env["joy"], "on")))):
		return null
	v_v_4716 = J.cl(env["joyVec"], null, [])
	J.mc(env["ctx"], "setTransform", [env["DPR"], 0.0, 0.0, env["DPR"], 0.0, 0.0])
	J.mc(env["ctx"], "save", [])
	var _t5420 = env["ctx"]
	J.sp(_t5420, "globalAlpha", 0.7)
	var _t5421 = env["crBlit"]
	var _t5423 = env["ctx"]
	var _t5422 = env["crGet"]
	J.cl(_t5421, null, [_t5423, J.cl(_t5422, null, [J.mul(env["JR"], 2.0), J.mul(env["JR"], 2.0), "paper", "ring"]), J.sub(J.gp(env["joy"], "ox"), env["JR"]), J.sub(J.gp(env["joy"], "oy"), env["JR"])])
	var _t5424 = env["ctx"]
	J.sp(_t5424, "globalAlpha", 0.92)
	var _t5425 = env["crBlit"]
	var _t5427 = env["ctx"]
	var _t5426 = env["crGet"]
	J.cl(_t5425, null, [_t5427, J.cl(_t5426, null, [48.0, 48.0, "bone", "ring2"]), J.sub(J.add(J.gp(env["joy"], "ox"), J.mul(J.gp(v_v_4716, "x"), env["JR"])), 24.0), J.sub(J.add(J.gp(env["joy"], "oy"), J.mul(J.gp(v_v_4716, "y"), env["JR"])), 24.0)])
	J.mc(env["ctx"], "restore", [])

func _f776(this_, a: Array, env):
	var v_x_4719 = null; var v_y_4720 = null; var v_best_4721 = null; var v_bd_4722 = null; var v_i_4723 = null; var v_b_4724 = null; var v_d_4725 = null
	v_x_4719 = J.arg(a, 0)
	v_y_4720 = J.arg(a, 1)
	v_best_4721 = null
	v_bd_4722 = 1000000000.0
	v_i_4723 = (J.len(env["buttons"]) - 1.0)
	while true:
		if not J.cmp(v_i_4723, 0.0, ">="): break
		v_b_4724 = J.gp(env["buttons"], v_i_4723)
		var _t5428 = J.cmp(v_x_4719, J.sub(J.gp(v_b_4724, "x"), env["PAD"]), ">=")
		var _t5429 = (J.cmp(v_x_4719, J.add(J.add(J.gp(v_b_4724, "x"), J.gp(v_b_4724, "w")), env["PAD"]), "<=") if _t5428 else _t5428)
		var _t5430 = (J.cmp(v_y_4720, J.sub(J.gp(v_b_4724, "y"), env["PAD"]), ">=") if _t5429 else _t5429)
		if (J.cmp(v_y_4720, J.add(J.add(J.gp(v_b_4724, "y"), J.gp(v_b_4724, "h")), env["PAD"]), "<=") if _t5430 else _t5430):
			var _t5431 = J.cmp(v_x_4719, J.gp(v_b_4724, "x"), ">=")
			var _t5432 = (J.cmp(v_x_4719, J.add(J.gp(v_b_4724, "x"), J.gp(v_b_4724, "w")), "<=") if _t5431 else _t5431)
			var _t5433 = (J.cmp(v_y_4720, J.gp(v_b_4724, "y"), ">=") if _t5432 else _t5432)
			v_d_4725 = ((-1.0) if (J.cmp(v_y_4720, J.add(J.gp(v_b_4724, "y"), J.gp(v_b_4724, "h")), "<=") if _t5433 else _t5433) else J.hypot_([J.sub(v_x_4719, J.add(J.gp(v_b_4724, "x"), J.div(J.gp(v_b_4724, "w"), 2.0))), J.sub(v_y_4720, J.add(J.gp(v_b_4724, "y"), J.div(J.gp(v_b_4724, "h"), 2.0)))]))
			if J.cmp(v_d_4725, v_bd_4722, "<"):
				v_bd_4722 = v_d_4725
				v_best_4721 = v_b_4724
		v_i_4723 = J.num(v_i_4723) + -1.0
	return v_best_4721

func _f777(this_, a: Array, env):
	var v_x_4728 = null; var v_y_4729 = null; var v_b_4730 = null
	v_x_4728 = J.arg(a, 0)
	v_y_4729 = J.arg(a, 1)
	var _t5434 = {"x": v_x_4728, "y": v_y_4729}
	env["LASTP"] = _t5434
	var _t5435 = env["hitBtn"]
	v_b_4730 = J.cl(_t5435, null, [v_x_4728, v_y_4729])
	if J.t(v_b_4730):
		var _t5436 = env["press"]
		J.cl(_t5436, null, [J.gp(v_b_4730, "id")])
		return null
	var _t5437 = J.seq(env["scene"], "play")
	var _t5438 = (env["G"] if _t5437 else _t5437)
	var _t5439 = ((not J.t(J.gp(env["G"], "over"))) if J.t(_t5438) else _t5438)
	var _t5440 = ((not J.t(J.gp(env["G"], "choice"))) if J.t(_t5439) else _t5439)
	var _t5441 = ((not J.t(J.gp(env["G"], "showStory"))) if J.t(_t5440) else _t5440)
	var _t5442 = (J.cmp(v_y_4729, env["TOP"], ">") if J.t(_t5441) else _t5441)
	if J.t((J.cmp(v_y_4729, J.sub(env["VH"], env["BOT"]), "<") if J.t(_t5442) else _t5442)):
		var _t5443 = env["worldTap"]
		J.cl(_t5443, null, [v_x_4728, v_y_4729])

func _f779(this_, a: Array, env):
	var v_g_4752 = null; var v_i_4753 = null; var v_d_4754 = null
	v_g_4752 = J.arg(a, 0)
	v_i_4753 = J.arg(a, 1)
	var _t5445 = J.gp(v_g_4752, "home")
	var _t5446 = (_t5445 if J.t(_t5445) else J.gp(v_g_4752, "out"))
	if J.t((_t5446 if J.t(_t5446) else J.seq(v_i_4753, J.gp(env["__p"]["G"], "active")))):
		return null
	v_d_4754 = J.hypot_([J.sub(J.gp(v_g_4752, "x"), env["wx"]), J.sub(J.sub(J.gp(v_g_4752, "y"), J.mul(J.gp(J.gp(v_g_4752, "d"), "h"), 0.5)), env["wy"])])
	if J.cmp(v_d_4754, env["gbd"], "<"):
		env["gbd"] = v_d_4754
		var _t5447 = {"g": v_i_4753}
		env["gb"] = _t5447

func _f780(this_, a: Array, env):
	var v_r_4757 = null; var v_d_4758 = null
	v_r_4757 = J.arg(a, 0)
	if (not J.seq(J.gp(v_r_4757, "state"), "home")):
		return null
	v_d_4758 = J.hypot_([J.sub(J.gp(v_r_4757, "x"), env["wx"]), J.sub(J.sub(J.gp(v_r_4757, "y"), 26.0), env["wy"])])
	if J.cmp(v_d_4758, env["bd"], "<"):
		env["bd"] = v_d_4758
		var _t5449 = {"r": v_r_4757}
		env["best"] = _t5449

func _f781(this_, a: Array, env):
	var v_h_4761 = null; var v_d_4762 = null
	v_h_4761 = J.arg(a, 0)
	var _t5451 = J.seq(J.gp(v_h_4761, "state"), "gone")
	if (_t5451 if _t5451 else J.seq(J.gp(v_h_4761, "state"), "flee")):
		return null
	v_d_4762 = J.hypot_([J.sub(J.gp(v_h_4761, "x"), env["wx"]), J.sub(J.sub(J.gp(v_h_4761, "y"), 30.0), env["wy"])])
	if J.cmp(v_d_4762, env["bd"], "<"):
		env["bd"] = v_d_4762
		var _t5452 = {"h": v_h_4761}
		env["best"] = _t5452

func _f778(this_, a: Array, env):
	var v_x_4733 = null; var v_y_4734 = null; var v_S_4735 = null; var v_g_4742 = null; var v_nn_4743 = null; var v_nd_4744 = null; var v_k_4745 = null; var v_n_4746 = null; var v_d_4747 = null; var v_un_4748 = null; var v_hn_4749 = null
	var _s1969 = {"__p": env, "wx": null, "wy": null, "best": null, "bd": null, "gb": null, "gbd": null}
	v_x_4733 = J.arg(a, 0)
	v_y_4734 = J.arg(a, 1)
	v_S_4735 = J.mul(J.gp(_s1969["__p"]["cam"], "s"), J.gp(_s1969["__p"]["cam"], "z"))
	_s1969["wx"] = J.add(J.div(v_x_4733, v_S_4735), J.gp(_s1969["__p"]["cam"], "x"))
	_s1969["wy"] = J.add(J.div(J.sub(v_y_4734, _s1969["__p"]["TOP"]), v_S_4735), J.gp(_s1969["__p"]["cam"], "y"))
	_s1969["best"] = null
	_s1969["bd"] = 40.0
	if J.t((J.mc(_s1969["__p"]["UNIT"], "worldTap", [_s1969["wx"], _s1969["wy"]]) if J.t(_s1969["__p"]["UNIT"]) else _s1969["__p"]["UNIT"])):
		return null
	_s1969["gb"] = null
	_s1969["gbd"] = 26.0
	var _t5444 = J.gp(_s1969["__p"]["G"], "gh")
	J.mc(_t5444, "forEach", [Callable(self, "_f779").bind(_s1969)])
	var _t5448 = J.gp(_s1969["__p"]["G"], "res")
	J.mc(_t5448, "forEach", [Callable(self, "_f780").bind(_s1969)])
	var _t5450 = J.gp(_s1969["__p"]["G"], "guards")
	J.mc(_t5450, "forEach", [Callable(self, "_f781").bind(_s1969)])
	var _t5453 = (not J.t(_s1969["best"]))
	if J.t((_s1969["gb"] if _t5453 else _t5453)):
		_s1969["best"] = _s1969["gb"]
	v_g_4742 = J.gp(J.gp(_s1969["__p"]["G"], "gh"), J.gp(_s1969["__p"]["G"], "active"))
	if (not J.t(_s1969["best"])):
		v_nn_4743 = null
		v_nd_4744 = 1000000000.0
		for _t5454 in J.keys(J.gp(_s1969["__p"]["G"], "nodes")):
			v_k_4745 = _t5454
			v_n_4746 = J.gp(J.gp(_s1969["__p"]["G"], "nodes"), v_k_4745)
			v_d_4747 = (absf(J.num(J.sub(J.gp(v_n_4746, "x"), _s1969["wx"]))) + (absf(J.num(J.sub(J.sub(J.gp(v_n_4746, "y"), 30.0), _s1969["wy"]))) * 1.6))
			if J.cmp(v_d_4747, v_nd_4744, "<"):
				v_nd_4744 = v_d_4747
				v_nn_4743 = v_k_4745
		if J.t((J.cmp(v_nd_4744, 120.0, "<") if J.t(v_nn_4743) else v_nn_4743)):
			var _t5455 = _s1969["__p"]["gotoNode"]
			if J.t(J.cl(_t5455, null, [v_g_4742, v_nn_4743])):
				J.sp(v_g_4742, "autoS", null)
				var _t5456 = _s1969["__p"]["float"]
				J.cl(_t5456, null, [J.gp(J.gp(J.gp(_s1969["__p"]["G"], "nodes"), v_nn_4743), "x"), J.sub(J.gp(J.gp(J.gp(_s1969["__p"]["G"], "nodes"), v_nn_4743), "y"), 70.0), "去呢度", "#9fd6bf"])
			else:
				var _t5457 = _s1969["__p"]["float"]
				J.cl(_t5457, null, [_s1969["wx"], _s1969["wy"], "去唔到", "#ffb0b0"])
		return null
	if (not J.leq(J.gp(_s1969["best"], "g"), null)):
		var _t5458 = _s1969["__p"]["G"]
		var _t5459 = J.gp(_s1969["best"], "g")
		J.sp(_t5458, "active", _t5459)
		var _t5460 = _s1969["__p"]["cam"]
		J.sp(_t5460, "free", null)
		return null
	if J.t(J.gp(_s1969["best"], "r")):
		v_un_4748 = J.gp(J.gp(_s1969["best"], "r"), "unit")
		var _t5461 = (not J.t(J.gp(v_un_4748, "open")))
		if ((not J.seq(J.gp(v_un_4748, "ot"), 1.0)) if _t5461 else _t5461):
			var _t5462 = _s1969["__p"]["float"]
			J.cl(_t5462, null, [J.gp(J.gp(_s1969["best"], "r"), "x"), J.sub(J.gp(J.gp(_s1969["best"], "r"), "y"), 80.0), "呢戶未入得", "#ffd54a"])
			return null
		var _t5463 = J.seq(J.gp(v_g_4742, "node"), J.gp(v_un_4748, "id"))
		if ((not J.t(J.gp(v_g_4742, "to"))) if _t5463 else _t5463):
			var _t5464 = J.max_([J.gp(v_g_4742, "still"), 0.11])
			J.sp(v_g_4742, "still", _t5464)
			J.cl(_s1969["__p"]["scarePress"], null, [])
			return null
		var _t5465 = _s1969["__p"]["gotoNode"]
		if J.t(J.cl(_t5465, null, [v_g_4742, J.gp(v_un_4748, "id")])):
			var _t5466 = {"r": J.gp(_s1969["best"], "r")}
			J.sp(v_g_4742, "autoS", _t5466)
			var _t5467 = _s1969["__p"]["float"]
			J.cl(_t5467, null, [J.gp(J.gp(_s1969["best"], "r"), "x"), J.sub(J.gp(J.gp(_s1969["best"], "r"), "y"), 86.0), J.add("目標：", (J.gp(J.gp(_s1969["__p"]["HH"], J.gp(J.gp(_s1969["best"], "r"), "hh")), "n") if J.t(J.gp(_s1969["__p"]["HH"], J.gp(J.gp(_s1969["best"], "r"), "hh"))) else "住戶")), "#ffb7a0"])
		else:
			var _t5468 = _s1969["__p"]["float"]
			J.cl(_t5468, null, [J.gp(J.gp(_s1969["best"], "r"), "x"), J.sub(J.gp(J.gp(_s1969["best"], "r"), "y"), 80.0), "去唔到（要先開門／破鎮宅）", "#ffb0b0"])
		return null
	if J.t(J.gp(_s1969["best"], "h")):
		var _t5469 = J.gp(J.gp(_s1969["best"], "h"), "to")
		v_hn_4749 = (J.gp(J.gp(_s1969["best"], "h"), "to") if J.t(((absf(J.num(J.sub(J.gp(J.gp(J.gp(_s1969["__p"]["G"], "nodes"), J.gp(J.gp(_s1969["best"], "h"), "to")), "x"), J.gp(J.gp(_s1969["best"], "h"), "x")))) < absf(J.num(J.sub(J.gp(J.gp(J.gp(_s1969["__p"]["G"], "nodes"), J.gp(J.gp(_s1969["best"], "h"), "node")), "x"), J.gp(J.gp(_s1969["best"], "h"), "x"))))) if J.t(_t5469) else _t5469)) else J.gp(J.gp(_s1969["best"], "h"), "node"))
		var _t5470 = _s1969["__p"]["gotoNode"]
		if J.t(J.cl(_t5470, null, [v_g_4742, v_hn_4749])):
			var _t5471 = {"h": J.gp(_s1969["best"], "h")}
			J.sp(v_g_4742, "autoS", _t5471)
			var _t5472 = _s1969["__p"]["float"]
			J.cl(_t5472, null, [J.gp(J.gp(_s1969["best"], "h"), "x"), J.sub(J.gp(J.gp(_s1969["best"], "h"), "y"), 90.0), J.add("目標：", J.gp(J.gp(_s1969["__p"]["HUM"], J.gp(J.gp(_s1969["best"], "h"), "kind")), "n")), "#ffb7a0"])
		return null

func _f782(this_, a: Array, env):
	var v_id_4765 = null; var v_sv_4766 = null; var v_i_4767 = null
	v_id_4765 = J.arg(a, 0)
	var _t5473 = J.seq(v_id_4765, "lv_flat")
	if (_t5473 if _t5473 else J.seq(v_id_4765, "start")):
		var _t5474 = env["newGame"]
		J.cl(_t5474, null, [null, "flat"])
		J.cl(env["bake"], null, [])
		return null
	if J.seq(v_id_4765, "exit"):
		J.cl(env["close"], null, [])
		return null
	if J.seq(v_id_4765, "quit"):
		env["scene"] = "title"
		return null
	if J.seq(v_id_4765, "lv_shop"):
		v_sv_4766 = J.cl(env["TS"], null, [])
		var _t5475 = J.gp(J.gp(v_sv_4766, "cleared"), "flat")
		var _t5476 = (_t5475 if J.t(_t5475) else J.mc(env["Q"], "has", ["unlock"]))
		if J.t((_t5476 if J.t(_t5476) else J.gp(J.G.get("window"), "STN_TEST"))):
			var _t5477 = env["newGame"]
			J.cl(_t5477, null, [null, "shop"])
			J.cl(env["bake"], null, [])
		return null
	if J.seq(v_id_4765, "again"):
		J.cl(env["newGame"], null, [])
		J.cl(env["bake"], null, [])
		return null
	if J.seq(v_id_4765, "toVillage"):
		J.cl(env["gpGoVillage"], null, [])
		return null
	if J.seq(v_id_4765, "title"):
		env["scene"] = "title"
		return null
	if J.seq(v_id_4765, "toMap"):
		J.cl(env["close"], null, [])
		return null
	if (not J.seq(env["scene"], "play")):
		return null
	if J.seq(J.mc(v_id_4765, "indexOf", ["card"]), 0.0):
		var _t5478 = env["chooseCard"]
		J.cl(_t5478, null, [J.num(J.mc(v_id_4765, "slice", [4.0]))])
		return null
	if J.seq(v_id_4765, "zin"):
		var _t5479 = env["cam"]
		var _t5480 = J.min_([1.5, J.mul(J.gp(env["cam"], "z"), 1.25)])
		J.sp(_t5479, "z", _t5480)
		return null
	if J.seq(v_id_4765, "zout"):
		var _t5481 = env["cam"]
		var _t5482 = J.max_([0.5, J.div(J.gp(env["cam"], "z"), 1.25)])
		J.sp(_t5481, "z", _t5482)
		return null
	if J.seq(v_id_4765, "mini"):
		J.cl(env["miniJump"], null, [])
		return null
	if J.seq(v_id_4765, "follow"):
		var _t5483 = env["cam"]
		J.sp(_t5483, "free", null)
		return null
	if J.seq(v_id_4765, "act"):
		J.cl(env["actPress"], null, [])
		return null
	if J.seq(v_id_4765, "ult"):
		var _t5484 = env["ultPress"]
		J.cl(_t5484, null, [J.gp(env["G"], "active")])
		return null
	if J.seq(v_id_4765, "story"):
		var _t5485 = env["G"]
		J.sp(_t5485, "showStory", true)
		return null
	if J.seq(v_id_4765, "closeStory"):
		var _t5486 = env["G"]
		J.sp(_t5486, "showStory", false)
		return null
	var _t5487 = J.gp(env["G"], "over")
	var _t5488 = (_t5487 if J.t(_t5487) else J.gp(env["G"], "choice"))
	if J.t((_t5488 if J.t(_t5488) else J.gp(env["G"], "showStory"))):
		return null
	if J.seq(J.mc(v_id_4765, "indexOf", ["gh"]), 0.0):
		var _t5489 = env["cam"]
		J.sp(_t5489, "free", null)
		v_i_4767 = J.num(J.mc(v_id_4765, "slice", [2.0]))
		if J.t(J.gp(J.gp(J.gp(env["G"], "gh"), v_i_4767), "home")):
			return null
		var _t5490 = J.seq(v_i_4767, J.gp(env["G"], "active"))
		if (J.cmp(J.gp(J.gp(J.gp(env["G"], "gh"), v_i_4767), "energy"), 100.0, ">=") if _t5490 else _t5490):
			var _t5491 = env["ultPress"]
			J.cl(_t5491, null, [v_i_4767])
			return null
		var _t5492 = env["G"]
		J.sp(_t5492, "active", v_i_4767)
		var _t5493 = env["toast"]
		J.cl(_t5493, null, [(env["GP_TRAINEE_MSG"] if J.t(J.gp(J.gp(J.gp(env["G"], "gh"), v_i_4767), "trainee")) else J.add(J.gp(J.gp(env["GH"], v_i_4767), "tip"), ("（能量滿！再點頭像放大招）" if J.cmp(J.gp(J.gp(J.gp(env["G"], "gh"), v_i_4767), "energy"), 100.0, ">=") else "")))])
		return null
	if J.seq(v_id_4765, "scare"):
		J.cl(env["scarePress"], null, [])
	if J.seq(v_id_4765, "inv"):
		J.cl(env["invPress"], null, [])
	if J.seq(v_id_4765, "gate"):
		J.cl(env["gatePress"], null, [])
	if J.seq(v_id_4765, "doll"):
		J.cl(env["dollEscape"], null, [])

func _f783(this_, a: Array, env):
	var v_ts_4770 = null; var v_dt_4771 = null; var v_v_4772 = null
	v_ts_4770 = J.arg(a, 0)
	if (not J.t(env["OPEN"])):
		env["RAF"] = 0.0
		return null
	var _t5494 = J.F_requestAnimationFrame([env["frame"]])
	env["RAF"] = _t5494
	if (not J.t(env["last"])):
		env["last"] = v_ts_4770
	v_dt_4771 = J.div(J.sub(v_ts_4770, env["last"]), 1000.0)
	if J.cmp(v_dt_4771, J.div(1.0, 31.0), "<"):
		return null
	env["last"] = v_ts_4770
	var _t5495 = J.min_([v_dt_4771, 0.1])
	v_dt_4771 = _t5495
	var _t5496 = J.seq(env["scene"], "play")
	if ((not J.t(J.gp(env["G"], "showStory"))) if _t5496 else _t5496):
		v_v_4772 = J.cl(env["joyVec"], null, [])
		var _t5497 = ((not J.t(J.gp(env["G"], "choice"))) if J.t(v_v_4772) else v_v_4772)
		if J.t(((not J.t(J.gp(env["G"], "over"))) if J.t(_t5497) else _t5497)):
			var _t5498 = J.gp(J.gp(env["G"], "gh"), J.gp(env["G"], "active"))
			J.sp(_t5498, "auto", null)
			var _t5499 = J.gp(J.gp(env["G"], "gh"), J.gp(env["G"], "active"))
			J.sp(_t5499, "autoS", null)
			var _t5500 = env["cam"]
			J.sp(_t5500, "free", null)
			var _t5501 = env["joyMove"]
			J.cl(_t5501, null, [J.gp(J.gp(env["G"], "gh"), J.gp(env["G"], "active")), J.gp(v_v_4772, "x"), J.gp(v_v_4772, "y"), v_dt_4771])
		var _t5502 = env["update"]
		J.cl(_t5502, null, [v_dt_4771])
	var _t5503 = (not J.t(J.gp(J.G.get("window"), "__twNat")))
	if ((not J.t((J.mc(env["UNIT"], "covering", []) if J.t(env["UNIT"]) else env["UNIT"]))) if _t5503 else _t5503):
		J.cl(env["draw"], null, [])
		J.cl(env["drawJoy"], null, [])

func _f842(this_, a: Array, env):
	var v_k_4922 = null
	v_k_4922 = J.arg(a, 0)
	var _t5505 = env["__p"]["IMG"]
	var _t5507 = J.G.get("SPR")
	var _t5506 = J.gp(env["M"], v_k_4922)
	var _t5508 = J.gp(_t5507, (_t5506 if J.t(_t5506) else v_k_4922))
	J.sp(_t5505, v_k_4922, _t5508)

func _f841(this_, a: Array, env):
	var _s2076 = {"__p": env, "M": null}
	_s2076["M"] = {"flatbg": "bg_tw_flat", "shopbg": "bg_tw_shop"}
	var _t5504 = ["res_gamer_scared", "res_uncle_scared", "res_granny_scared", "res_helper_scared", "res_mjaunty_scared", "res_shopper_scared", "res_collector_scared", "res_guard_scared", "res_ot_scared", "res_gym_scared", "eguiking", "toyol", "tianhua", "tianhua_hang", "npc_ken", "npc_auntie", "npc_guard", "npc_it", "npc_mis", "npc_boss", "npc_it_sit", "npc_ken_sit", "res_gamer", "res_uncle", "res_granny", "res_helper", "res_mjaunty", "res_shopper", "res_collector", "res_guard", "res_ot", "res_gym", "room_mahjong", "room_gamer", "room_nurse", "room_helper", "room_gym", "room_shopper", "room_carpark", "room_lobby", "flatbg", "shopbg", "gb_unit_ppr", "gb_unit_gamer", "gb_unit_shop"]
	J.mc(_t5504, "forEach", [Callable(self, "_f842").bind(_s2076)])

func _f843(this_, a: Array, env):
	var v_e_4925 = null; var v_e_4926 = null
	J.cl(env["loadImgs"], null, [])
	J.cl(env["TS"], null, [])
	var _t5509 = J.gp(env["ROOT"], "classList")
	J.mc(_t5509, "add", ["on"])
	env["OPEN"] = true
	if (not J.seq(J.typeof_(J.G.get("__nat_tower")), "undefined")):
		var _t5510 = J.G.get("__nat_tower")
		J.cl(_t5510, null, [true])
	env["scene"] = "title"
	J.cl(env["resize"], null, [])
	env["last"] = 0.0
	if (not J.t(env["RAF"])):
		var _t5511 = J.F_requestAnimationFrame([env["frame"]])
		env["RAF"] = _t5511
	if J.t(J.gp(J.G.get("Sound"), "setMode")):
		J.mc(J.G.get("Sound"), "setMode", ["story"])
	var _t5512 = J.gp(J.G.get("window"), "Policy")
	if J.t((J.gp(J.G.get("Policy"), "firstEnter") if J.t(_t5512) else _t5512)):
		J.mc(J.G.get("Policy"), "firstEnter", ["tower"])

func _f844(this_, a: Array, env):
	var v_e_4929 = null
	env["OPEN"] = false
	if (not J.seq(J.typeof_(J.G.get("__nat_tower")), "undefined")):
		var _t5513 = J.G.get("__nat_tower")
		J.cl(_t5513, null, [false])
	var _t5514 = J.gp(env["ROOT"], "classList")
	J.mc(_t5514, "remove", ["on"])
	env["joy"] = null
	env["ptr"] = null
	J.cl(J.G.get("save"), null, [])
	if J.t(J.gp(J.G.get("Sound"), "setMode")):
		J.mc(J.G.get("Sound"), "setMode", ["village"])
	if (not J.seq(J.typeof_(J.G.get("World")), "undefined")):
		J.mc(J.G.get("World"), "open", [])

func _f459(this_, a: Array, env):
	var v_k_2835 = null; var v_i_2836 = null
	v_k_2835 = J.arg(a, 0)
	v_i_2836 = (J.gp(env["__p"]["IMG"], v_k_2835) if J.t(v_k_2835) else v_k_2835)
	return (v_i_2836 if J.t((J.gp(v_i_2836, "width") if J.t(v_i_2836) else v_i_2836)) else null)

func _f460(this_, a: Array, env):
	var v_k_2839 = null
	v_k_2839 = J.arg(a, 0)
	var _t5523 = (not (not J.t(v_k_2839)))
	var _t5525 = (J.seq(J.mc(v_k_2839, "indexOf", ["res_"]), 0.0) if _t5523 else _t5523)
	if J.t(_t5525):
		var _t5524 = env["im"]
		_t5525 = (not (not J.t(J.cl(_t5524, null, [J.add(v_k_2839, "_scared")]))))
	return _t5525

func _f461(this_, a: Array, env):
	var v_k_2842 = null; var v_scared_2843 = null
	v_k_2842 = J.arg(a, 0)
	v_scared_2843 = J.arg(a, 1)
	var _t5527 = v_scared_2843
	if J.t(_t5527):
		var _t5526 = env["hasScared"]
		_t5527 = J.cl(_t5526, null, [v_k_2842])
	return (J.add(v_k_2842, "_scared") if J.t(_t5527) else v_k_2842)

func _f462(this_, a: Array, env):
	var v_k_2846 = null; var v_i_2847 = null
	v_k_2846 = J.arg(a, 0)
	var _t5528 = env["im"]
	v_i_2847 = J.cl(_t5528, null, [v_k_2846])
	var _t5529 = (not (not J.t(v_i_2847)))
	return ((J.div(J.gp(v_i_2847, "width"), J.gp(v_i_2847, "height")) >= 0.42) if _t5529 else _t5529)

func _f463(this_, a: Array, env):
	var v_base_2850 = null; var v_k2_2851 = null; var v_h_2852 = null; var v_m_2853 = null
	v_base_2850 = J.arg(a, 0)
	v_k2_2851 = J.arg(a, 1)
	v_h_2852 = J.arg(a, 2)
	v_m_2853 = J.gp(env["__p"]["PPL_META"], v_base_2850)
	var _t5530 = env["chibi"]
	var _t5533 = J.mul(v_h_2852, (env["CHIBI_K"] if J.t(J.cl(_t5530, null, [v_base_2850])) else 1.0))
	var _t5531 = (not J.seq(v_k2_2851, v_base_2850))
	var _t5532 = (v_m_2853 if _t5531 else _t5531)
	return J.mul(_t5533, (J.gp(J.gp(v_m_2853, "s"), "k") if J.t((J.gp(v_m_2853, "s") if J.t(_t5532) else _t5532)) else 1.0))

func _f464(this_, a: Array, env):
	var v_base_2856 = null; var v_k2_2857 = null; var v_m_2858 = null
	v_base_2856 = J.arg(a, 0)
	v_k2_2857 = J.arg(a, 1)
	v_m_2858 = J.gp(env["__p"]["PPL_META"], v_base_2856)
	if (not J.t(v_m_2858)):
		return 0.0
	var _t5538 = null
	if (not J.seq(v_k2_2857, v_base_2856)):
		var _t5534 = J.gp(v_m_2858, "s")
		var _t5535 = (J.gp(J.gp(v_m_2858, "s"), "foot") if J.t(_t5534) else _t5534)
		_t5538 = (_t5535 if J.t(_t5535) else 0.0)
	else:
		var _t5536 = J.gp(v_m_2858, "n")
		var _t5537 = (J.gp(J.gp(v_m_2858, "n"), "foot") if J.t(_t5536) else _t5536)
		_t5538 = (_t5537 if J.t(_t5537) else 0.0)
	return _t5538

func _f465(this_, a: Array, env):
	var v_k_2861 = null; var v_i_2862 = null; var v_c_2863 = null; var v_s_2864 = null; var v_x_2865 = null
	v_k_2861 = J.arg(a, 0)
	var _t5539 = env["im"]
	v_i_2862 = J.cl(_t5539, null, [v_k_2861])
	if (not J.t(v_i_2862)):
		return null
	v_c_2863 = J.gp(env["TC"], v_k_2861)
	if J.t((J.seq(J.gp(v_c_2863, "_src"), v_i_2862) if J.t(v_c_2863) else v_c_2863)):
		return v_c_2863
	var _t5540 = J.S_document_("createElement", ["canvas"])
	v_c_2863 = _t5540
	v_s_2864 = J.min_([1.0, J.div(220.0, J.gp(v_i_2862, "height"))])
	var _t5541 = J.max_([1.0, J.round(J.num(J.mul(J.gp(v_i_2862, "width"), v_s_2864)))])
	J.sp(v_c_2863, "width", _t5541)
	var _t5542 = J.max_([1.0, J.round(J.num(J.mul(J.gp(v_i_2862, "height"), v_s_2864)))])
	J.sp(v_c_2863, "height", _t5542)
	v_x_2865 = J.mc(v_c_2863, "getContext", ["2d"])
	J.mc(v_x_2865, "drawImage", [v_i_2862, 0.0, 0.0, J.gp(v_c_2863, "width"), J.gp(v_c_2863, "height")])
	J.sp(v_x_2865, "globalCompositeOperation", "source-atop")
	J.sp(v_x_2865, "fillStyle", "rgb(178,222,236)")
	J.mc(v_x_2865, "fillRect", [0.0, 0.0, J.gp(v_c_2863, "width"), J.gp(v_c_2863, "height")])
	J.sp(v_c_2863, "_src", v_i_2862)
	var _t5543 = env["TC"]
	J.sp(_t5543, v_k_2861, v_c_2863)
	return v_c_2863

func _f466(this_, a: Array, env):
	var v_c2_2868 = null; var v_i_2869 = null; var v_x_2870 = null; var v_y_2871 = null; var v_h_2872 = null; var v_o_2873 = null; var v_w_2874 = null
	v_c2_2868 = J.arg(a, 0)
	v_i_2869 = J.arg(a, 1)
	v_x_2870 = J.arg(a, 2)
	v_y_2871 = J.arg(a, 3)
	v_h_2872 = J.arg(a, 4)
	v_o_2873 = J.arg(a, 5)
	v_w_2874 = J.div(J.mul(v_h_2872, J.gp(v_i_2869, "width")), J.gp(v_i_2869, "height"))
	J.mc(v_c2_2868, "save", [])
	var _t5544 = (1.0 if J.leq(J.gp(v_o_2873, "alpha"), null) else J.gp(v_o_2873, "alpha"))
	J.sp(v_c2_2868, "globalAlpha", _t5544)
	J.mc(v_c2_2868, "translate", [v_x_2870, v_y_2871])
	if J.t(J.gp(v_o_2873, "rot")):
		J.mc(v_c2_2868, "rotate", [J.gp(v_o_2873, "rot")])
	var _t5546 = ((-1.0) if J.t(J.gp(v_o_2873, "flip")) else 1.0)
	var _t5545 = J.gp(v_o_2873, "sx")
	var _t5548 = J.mul(_t5546, (_t5545 if J.t(_t5545) else 1.0))
	var _t5547 = J.gp(v_o_2873, "sy")
	J.mc(v_c2_2868, "scale", [_t5548, (_t5547 if J.t(_t5547) else 1.0)])
	J.mc(v_c2_2868, "drawImage", [v_i_2869, J.div((-J.num(v_w_2874)), 2.0), (-J.num(v_h_2872)), v_w_2874, v_h_2872])
	J.mc(v_c2_2868, "restore", [])

func _f467(this_, a: Array, env):
	var v_c2_2877 = null; var v_base_2878 = null; var v_k2_2879 = null; var v_x_2880 = null; var v_y_2881 = null; var v_h_2882 = null; var v_o_2883 = null; var v_i_2884 = null; var v_fy0_2885 = null; var v_t_2886 = null; var v_sb_2887 = null
	v_c2_2877 = J.arg(a, 0)
	v_base_2878 = J.arg(a, 1)
	v_k2_2879 = J.arg(a, 2)
	v_x_2880 = J.arg(a, 3)
	v_y_2881 = J.arg(a, 4)
	v_h_2882 = J.arg(a, 5)
	v_o_2883 = J.arg(a, 6)
	var _t5549 = (v_o_2883 if J.t(v_o_2883) else {})
	v_o_2883 = _t5549
	var _t5550 = env["im"]
	v_i_2884 = J.cl(_t5550, null, [v_k2_2879])
	if (not J.t(v_i_2884)):
		return null
	var _t5551 = env["foot"]
	v_fy0_2885 = J.add(v_y_2881, J.mul(J.cl(_t5551, null, [v_base_2878, v_k2_2879]), v_h_2882))
	var _t5552 = env["blit"]
	J.cl(_t5552, null, [v_c2_2877, v_i_2884, v_x_2880, v_fy0_2885, v_h_2882, v_o_2883])
	if J.cmp(J.gp(v_o_2883, "tint"), 0.02, ">"):
		var _t5553 = env["tintCv"]
		v_t_2886 = J.cl(_t5553, null, [v_k2_2879])
		if J.t(v_t_2886):
			v_sb_2887 = J.gp(v_c2_2877, "shadowBlur")
			J.sp(v_c2_2877, "shadowBlur", 0.0)
			var _t5554 = env["blit"]
			J.cl(_t5554, null, [v_c2_2877, v_t_2886, v_x_2880, v_fy0_2885, v_h_2882, {"flip": J.gp(v_o_2883, "flip"), "rot": J.gp(v_o_2883, "rot"), "sx": J.gp(v_o_2883, "sx"), "sy": J.gp(v_o_2883, "sy"), "alpha": J.mul((1.0 if J.leq(J.gp(v_o_2883, "alpha"), null) else J.gp(v_o_2883, "alpha")), J.min_([0.4, J.mul(J.gp(v_o_2883, "tint"), 0.45)]))}])
			J.sp(v_c2_2877, "shadowBlur", v_sb_2887)

func _f468(this_, a: Array, env):
	var v_t_2890 = null; var v_amp_2891 = null; var v_q_2892 = null; var v_a_2893 = null; var v_o_2894 = null; var v_c_2895 = null; var v_c2_2896 = null; var v_c3_2897 = null
	v_t_2890 = J.arg(a, 0)
	v_amp_2891 = J.arg(a, 1)
	v_q_2892 = (1.0 - J.div(v_t_2890, 0.9))
	v_a_2893 = (v_amp_2891 if J.t(v_amp_2891) else 1.0)
	v_o_2894 = {"sx": 1.0, "sy": 1.0, "jy": 0.0, "sh": 0.0, "tint": (0.95 * (1.0 - J.mul(v_q_2892, 0.55)))}
	if J.cmp(v_q_2892, 0.12, "<"):
		v_c_2895 = J.div(v_q_2892, 0.12)
		var _t5555 = (1.0 - J.mul(J.mul(0.22, v_c_2895), v_a_2893))
		J.sp(v_o_2894, "sy", _t5555)
		var _t5556 = (1.0 + J.mul(J.mul(0.16, v_c_2895), v_a_2893))
		J.sp(v_o_2894, "sx", _t5556)
	else:
		if J.cmp(v_q_2892, 0.5, "<"):
			v_c2_2896 = J.div(J.sub(v_q_2892, 0.12), 0.38)
			var _t5557 = J.mul(((-sin(J.num(J.mul(v_c2_2896, PI)))) * 0.3), v_a_2893)
			J.sp(v_o_2894, "jy", _t5557)
			var _t5558 = (1.0 + J.mul((0.17 * J.sub(1.0, v_c2_2896)), v_a_2893))
			J.sp(v_o_2894, "sy", _t5558)
			var _t5559 = (1.0 - J.mul((0.11 * J.sub(1.0, v_c2_2896)), v_a_2893))
			J.sp(v_o_2894, "sx", _t5559)
		else:
			v_c3_2897 = J.div(J.sub(v_q_2892, 0.5), 0.5)
			var _t5560 = (1.0 - J.mul(((0.07 * sin(J.num(J.mul(v_c3_2897, PI)))) * J.sub(1.0, v_c3_2897)), v_a_2893))
			J.sp(v_o_2894, "sy", _t5560)
			var _t5561 = (1.0 + J.mul(((0.05 * sin(J.num(J.mul(v_c3_2897, PI)))) * J.sub(1.0, v_c3_2897)), v_a_2893))
			J.sp(v_o_2894, "sx", _t5561)
			var _t5562 = ((sin(J.num((J.div(J.S_performance_("now", []), 1000.0) * 62.0))) * 0.032) * J.sub(1.0, v_c3_2897))
			J.sp(v_o_2894, "sh", _t5562)
	return v_o_2894

func _f469(this_, a: Array, env):
	var v_r_2900 = null; var v_t_2901 = null; var v_ph_2902 = null
	v_r_2900 = J.arg(a, 0)
	v_t_2901 = J.arg(a, 1)
	var _t5563 = J.gp(v_r_2900, "x")
	v_ph_2902 = floor(J.num(J.mul(J.add(v_t_2901, J.mod((_t5563 if J.t(_t5563) else 0.0), 5.0)), 1.15)))
	var _t5565 = J.mul(v_t_2901, 47.0)
	var _t5564 = J.gp(v_r_2900, "x")
	return {"sh": (sin(J.num(J.add(_t5565, (_t5564 if J.t(_t5564) else 0.0)))) * 0.018), "sy": 0.93, "flip": (null if J.seq(J.mod(v_ph_2902, 3.0), 2.0) else J.seq(J.mod(v_ph_2902, 3.0), 1.0)), "tint": 0.16}

func _f470(this_, a: Array, env):
	var v_c2_2905 = null; var v_x_2906 = null; var v_y_2907 = null; var v_q_2908 = null; var v_s_2909 = null; var v_pop_2910 = null; var v_al_2911 = null; var v_i_2912 = null; var v_an_2913 = null; var v_an2_2914 = null
	v_c2_2905 = J.arg(a, 0)
	v_x_2906 = J.arg(a, 1)
	v_y_2907 = J.arg(a, 2)
	v_q_2908 = J.arg(a, 3)
	v_s_2909 = J.arg(a, 4)
	var _t5566 = (v_s_2909 if J.t(v_s_2909) else 1.0)
	v_s_2909 = _t5566
	v_pop_2910 = (1.0 + (0.7 * J.max_([0.0, (1.0 - J.div(v_q_2908, 0.16))])))
	v_al_2911 = (J.max_([0.0, J.div(J.sub(1.0, v_q_2908), 0.2)]) if J.cmp(v_q_2908, 0.8, ">") else 1.0)
	J.mc(v_c2_2905, "save", [])
	J.sp(v_c2_2905, "globalAlpha", v_al_2911)
	J.mc(v_c2_2905, "translate", [v_x_2906, v_y_2907])
	J.mc(v_c2_2905, "rotate", [(-0.12)])
	J.mc(v_c2_2905, "scale", [J.mul(v_pop_2910, v_s_2909), J.mul(v_pop_2910, v_s_2909)])
	var _t5567 = J.add("900 22px ", env["__p"]["FONT"])
	J.sp(v_c2_2905, "font", _t5567)
	J.sp(v_c2_2905, "textAlign", "center")
	J.sp(v_c2_2905, "lineJoin", "round")
	J.sp(v_c2_2905, "lineWidth", 5.0)
	J.sp(v_c2_2905, "strokeStyle", "#160c10")
	J.mc(v_c2_2905, "strokeText", ["!!", 0.0, 0.0])
	J.sp(v_c2_2905, "fillStyle", "#ffe25a")
	J.mc(v_c2_2905, "fillText", ["!!", 0.0, 0.0])
	J.sp(v_c2_2905, "strokeStyle", "#ffe25a")
	J.sp(v_c2_2905, "lineWidth", 2.0)
	v_i_2912 = 0.0
	while true:
		if not J.cmp(v_i_2912, 3.0, "<"): break
		v_an_2913 = ((-2.5) + J.mul(v_i_2912, 0.5))
		J.mc(v_c2_2905, "beginPath", [])
		J.mc(v_c2_2905, "moveTo", [((cos(J.num(v_an_2913)) * 15.0) - 2.0), ((sin(J.num(v_an_2913)) * 15.0) - 8.0)])
		J.mc(v_c2_2905, "lineTo", [((cos(J.num(v_an_2913)) * 22.0) - 2.0), ((sin(J.num(v_an_2913)) * 22.0) - 8.0)])
		J.mc(v_c2_2905, "stroke", [])
		v_an2_2914 = ((-0.65) - J.mul(v_i_2912, 0.5))
		J.mc(v_c2_2905, "beginPath", [])
		J.mc(v_c2_2905, "moveTo", [((cos(J.num(v_an2_2914)) * 15.0) + 2.0), ((sin(J.num(v_an2_2914)) * 15.0) - 8.0)])
		J.mc(v_c2_2905, "lineTo", [((cos(J.num(v_an2_2914)) * 22.0) + 2.0), ((sin(J.num(v_an2_2914)) * 22.0) - 8.0)])
		J.mc(v_c2_2905, "stroke", [])
		v_i_2912 = J.num(v_i_2912) + 1.0
	J.mc(v_c2_2905, "restore", [])

func _f471(this_, a: Array, env):
	var v_c2_2917 = null; var v_x_2918 = null; var v_y_2919 = null; var v_h_2920 = null; var v_dir_2921 = null; var v_t_2922 = null; var v_sh_2923 = null; var v_s_2924 = null; var v_w_2925 = null; var v_hx_2926 = null; var v_hy_2927 = null; var v_sx0_2928 = null
	v_c2_2917 = J.arg(a, 0)
	v_x_2918 = J.arg(a, 1)
	v_y_2919 = J.arg(a, 2)
	v_h_2920 = J.arg(a, 3)
	v_dir_2921 = J.arg(a, 4)
	v_t_2922 = J.arg(a, 5)
	v_sh_2923 = J.sub(v_y_2919, J.mul(v_h_2920, 0.5))
	J.mc(v_c2_2917, "save", [])
	J.sp(v_c2_2917, "lineCap", "round")
	v_s_2924 = (-1.0)
	while true:
		if not J.cmp(v_s_2924, 1.0, "<="): break
		v_w_2925 = (J.mul(sin(J.num(J.add(J.mul(v_t_2922, 19.0), v_s_2924))), v_h_2920) * 0.035)
		v_hx_2926 = J.add(J.add(v_x_2918, (J.mul(v_s_2924, v_h_2920) * 0.3)), v_w_2925)
		v_hy_2927 = (J.sub(v_y_2919, J.mul(v_h_2920, 0.97)) + (J.mul(cos(J.num(J.add(J.mul(v_t_2922, 19.0), v_s_2924))), v_h_2920) * 0.02))
		v_sx0_2928 = J.add(v_x_2918, (J.mul(v_s_2924, v_h_2920) * 0.12))
		J.sp(v_c2_2917, "strokeStyle", "#1a1214")
		var _t5568 = J.max_([3.0, J.mul(v_h_2920, 0.075)])
		J.sp(v_c2_2917, "lineWidth", _t5568)
		J.mc(v_c2_2917, "beginPath", [])
		J.mc(v_c2_2917, "moveTo", [v_sx0_2928, v_sh_2923])
		J.mc(v_c2_2917, "lineTo", [v_hx_2926, v_hy_2927])
		J.mc(v_c2_2917, "stroke", [])
		J.sp(v_c2_2917, "strokeStyle", "#f0c8a4")
		var _t5569 = J.max_([1.6, J.mul(v_h_2920, 0.045)])
		J.sp(v_c2_2917, "lineWidth", _t5569)
		J.mc(v_c2_2917, "beginPath", [])
		J.mc(v_c2_2917, "moveTo", [v_sx0_2928, v_sh_2923])
		J.mc(v_c2_2917, "lineTo", [v_hx_2926, v_hy_2927])
		J.mc(v_c2_2917, "stroke", [])
		J.sp(v_c2_2917, "fillStyle", "#f0c8a4")
		J.sp(v_c2_2917, "strokeStyle", "#1a1214")
		J.sp(v_c2_2917, "lineWidth", 1.5)
		J.mc(v_c2_2917, "beginPath", [])
		J.mc(v_c2_2917, "arc", [v_hx_2926, v_hy_2927, J.max_([2.5, J.mul(v_h_2920, 0.05)]), 0.0, 7.0])
		J.mc(v_c2_2917, "fill", [])
		J.mc(v_c2_2917, "stroke", [])
		var _t5570 = J.add(v_s_2924, 2.0)
		v_s_2924 = _t5570
	J.mc(v_c2_2917, "restore", [])

func _f472(this_, a: Array, env):
	var v_c2_2931 = null; var v_x_2932 = null; var v_y_2933 = null; var v_sc_2934 = null; var v_s_2935 = null; var v_u_2936 = null; var v_yy_2937 = null
	v_c2_2931 = J.arg(a, 0)
	v_x_2932 = J.arg(a, 1)
	v_y_2933 = J.arg(a, 2)
	v_sc_2934 = J.arg(a, 3)
	v_s_2935 = J.arg(a, 4)
	if (not J.t(v_sc_2934)):
		return null
	var _t5571 = (v_s_2935 if J.t(v_s_2935) else 1.0)
	v_s_2935 = _t5571
	v_u_2936 = (1.0 - J.div(J.gp(v_sc_2934, "T"), 1.9))
	J.mc(v_c2_2931, "save", [])
	var _t5572 = J.min_([1.0, J.div(J.gp(v_sc_2934, "T"), 0.45)])
	J.sp(v_c2_2931, "globalAlpha", _t5572)
	var _t5573 = J.add((J.add("900 ", J.round(J.num(J.mul(14.0, v_s_2935)))) + "px "), env["__p"]["FONT"])
	J.sp(v_c2_2931, "font", _t5573)
	J.sp(v_c2_2931, "textAlign", "center")
	J.sp(v_c2_2931, "lineJoin", "round")
	J.sp(v_c2_2931, "lineWidth", 4.0)
	J.sp(v_c2_2931, "strokeStyle", "#14080a")
	v_yy_2937 = J.sub(v_y_2933, J.mul(J.mul(v_u_2936, 22.0), v_s_2935))
	J.mc(v_c2_2931, "strokeText", [J.gp(v_sc_2934, "t"), v_x_2932, v_yy_2937])
	J.sp(v_c2_2931, "fillStyle", "#ff9a86")
	J.mc(v_c2_2931, "fillText", [J.gp(v_sc_2934, "t"), v_x_2932, v_yy_2937])
	J.mc(v_c2_2931, "restore", [])

func _f473(this_, a: Array, env):
	var _t5574 = env["__p"]["uniq"]
	return J.cl(_t5574, null, [env["__p"]["SCREAM"]])

func _f474(this_, a: Array, env):
	var v_o_2942 = null
	v_o_2942 = J.arg(a, 0)
	var _t5575 = env["__p"]["pplScream"]
	J.cl(_t5575, null, [v_o_2942])

func _f458(this_, a: Array, env):
	var v_key_2820 = null; var v_hgt_2822 = null; var v_draw_2826 = null; var v_shock_2827 = null; var v_tremble_2828 = null; var v_bang_2829 = null; var v_arms_2830 = null; var v_scream_2831 = null; var v_uq_2832 = null
	var _s1069 = {"__p": env, "CHIBI_K": null, "TC": null, "im": null, "hasScared": null, "chibi": null, "foot": null, "tintCv": null, "blit": null}
	_s1069["im"] = Callable(self, "_f459").bind(_s1069)
	_s1069["hasScared"] = Callable(self, "_f460").bind(_s1069)
	v_key_2820 = Callable(self, "_f461").bind(_s1069)
	_s1069["chibi"] = Callable(self, "_f462").bind(_s1069)
	v_hgt_2822 = Callable(self, "_f463").bind(_s1069)
	_s1069["foot"] = Callable(self, "_f464").bind(_s1069)
	_s1069["tintCv"] = Callable(self, "_f465").bind(_s1069)
	_s1069["blit"] = Callable(self, "_f466").bind(_s1069)
	v_draw_2826 = Callable(self, "_f467").bind(_s1069)
	v_shock_2827 = Callable(self, "_f468").bind(_s1069)
	v_tremble_2828 = Callable(self, "_f469").bind(_s1069)
	v_bang_2829 = Callable(self, "_f470").bind(_s1069)
	v_arms_2830 = Callable(self, "_f471").bind(_s1069)
	v_scream_2831 = Callable(self, "_f472").bind(_s1069)
	v_uq_2832 = Callable(self, "_f473").bind(_s1069)
	_s1069["CHIBI_K"] = 1.12
	_s1069["TC"] = {}
	return {"key": v_key_2820, "hasScared": _s1069["hasScared"], "chibi": _s1069["chibi"], "hgt": v_hgt_2822, "foot": _s1069["foot"], "draw": v_draw_2826, "shock": v_shock_2827, "tremble": v_tremble_2828, "bang": v_bang_2829, "arms": v_arms_2830, "scream": v_scream_2831, "screamOn": Callable(self, "_f474").bind(_s1069), "tint": _s1069["tintCv"], "CHIBI_K": _s1069["CHIBI_K"], "uniqScream": v_uq_2832}

func _f630(this_, a: Array, env):
	var v_u_3765 = null
	v_u_3765 = J.arg(a, 0)
	return ("伯伯" if J.seq(J.gp(v_u_3765, "hh"), "elder") else "婆婆")

func _f768(this_, a: Array, env):
	var v_e_4667 = null; var v_p_4668 = null; var v_hb_4669 = null; var v_ids_4670 = null; var v_a_4671 = null; var v_b_4672 = null; var v___4673 = null; var v___4674 = null; var v___4675 = null
	v_e_4667 = J.arg(a, 0)
	if J.t(J.gp(v_e_4667, "isPrimary")):
		var _t5580 = {}
		env["pts"] = _t5580
	var _t5581 = env["pt"]
	v_p_4668 = J.cl(_t5581, null, [v_e_4667])
	var _t5582 = env["pts"]
	var _t5583 = J.gp(v_e_4667, "pointerId")
	J.sp(_t5582, _t5583, v_p_4668)
	var _t5584 = env["hitBtn"]
	v_hb_4669 = J.cl(_t5584, null, [J.gp(v_p_4668, "x"), J.gp(v_p_4668, "y")])
	if J.t(v_hb_4669):
		var _t5585 = {"id": J.gp(v_hb_4669, "id"), "t": J.S_performance_("now", [])}
		env["PRESS"] = _t5585
		if J.t(J.gp(J.G.get("navigator"), "vibrate")):
			J.S_navigator_("vibrate", [12.0])
		var _t5586 = {"sx": J.gp(v_p_4668, "x"), "sy": J.gp(v_p_4668, "y"), "drag": false, "btn": J.gp(v_hb_4669, "id"), "id": J.gp(v_e_4667, "pointerId")}
		env["ptr"] = _t5586
		env["joy"] = null
		J.mc(env["cv"], "setPointerCapture", [J.gp(v_e_4667, "pointerId")])
		return null
	v_ids_4670 = J.S_Object_("keys", [env["pts"]])
	if J.seq(J.len(v_ids_4670), 2.0):
		v_a_4671 = J.gp(env["pts"], J.gp(v_ids_4670, 0.0))
		v_b_4672 = J.gp(env["pts"], J.gp(v_ids_4670, 1.0))
		var _t5587 = {"d": J.hypot_([J.sub(J.gp(v_a_4671, "x"), J.gp(v_b_4672, "x")), J.sub(J.gp(v_a_4671, "y"), J.gp(v_b_4672, "y"))]), "z": J.gp(env["cam"], "z")}
		env["pinch"] = _t5587
		env["joy"] = null
		env["ptr"] = null
		return null
	var _t5589 = J.gp(v_p_4668, "x")
	var _t5590 = J.gp(v_p_4668, "y")
	var _t5591 = J.gp(v_e_4667, "pointerId")
	var _t5588 = J.cmp(J.gp(v_p_4668, "y"), J.sub(env["VH"], env["BOT"]), ">=")
	var _t5592 = {"sx": _t5589, "sy": _t5590, "drag": false, "id": _t5591, "hud": (_t5588 if _t5588 else J.cmp(J.gp(v_p_4668, "y"), env["TOP"], "<="))}
	env["ptr"] = _t5592
	var _t5593 = J.seq(env["scene"], "play")
	var _t5594 = ((not J.t(J.gp(env["G"], "over"))) if _t5593 else _t5593)
	var _t5595 = ((not J.t(J.gp(env["G"], "choice"))) if _t5594 else _t5594)
	var _t5596 = ((not J.t(J.gp(env["G"], "showStory"))) if _t5595 else _t5595)
	var _t5597 = (J.cmp(J.gp(v_p_4668, "y"), env["TOP"], ">") if _t5596 else _t5596)
	if (J.cmp(J.gp(v_p_4668, "y"), J.sub(env["VH"], env["BOT"]), "<") if _t5597 else _t5597):
		var _t5598 = {"ox": J.gp(v_p_4668, "x"), "oy": J.gp(v_p_4668, "y"), "x": J.gp(v_p_4668, "x"), "y": J.gp(v_p_4668, "y"), "on": false}
		env["joy"] = _t5598
	J.mc(env["cv"], "setPointerCapture", [J.gp(v_e_4667, "pointerId")])

func _f769(this_, a: Array, env):
	var v_e_4678 = null; var v_p_4679 = null; var v_ids_4680 = null; var v_a_4681 = null; var v_b_4682 = null; var v_S9_4683 = null; var v_mxp_4684 = null; var v_myp_4685 = null; var v_c0_4686 = null
	v_e_4678 = J.arg(a, 0)
	var _t5601 = env["pt"]
	v_p_4679 = J.cl(_t5601, null, [v_e_4678])
	if J.t(J.gp(env["pts"], J.gp(v_e_4678, "pointerId"))):
		var _t5602 = env["pts"]
		var _t5603 = J.gp(v_e_4678, "pointerId")
		J.sp(_t5602, _t5603, v_p_4679)
	if J.t(env["pinch"]):
		v_ids_4680 = J.S_Object_("keys", [env["pts"]])
		if J.seq(J.len(v_ids_4680), 2.0):
			v_a_4681 = J.gp(env["pts"], J.gp(v_ids_4680, 0.0))
			v_b_4682 = J.gp(env["pts"], J.gp(v_ids_4680, 1.0))
			var _t5604 = env["cam"]
			var _t5605 = env["clamp"]
			var _t5606 = J.cl(_t5605, null, [J.div(J.mul(J.gp(env["pinch"], "z"), J.hypot_([J.sub(J.gp(v_a_4681, "x"), J.gp(v_b_4682, "x")), J.sub(J.gp(v_a_4681, "y"), J.gp(v_b_4682, "y"))])), J.gp(env["pinch"], "d")), 0.5, 1.5])
			J.sp(_t5604, "z", _t5606)
			v_S9_4683 = J.mul(J.gp(env["cam"], "s"), J.gp(env["cam"], "z"))
			v_mxp_4684 = J.div(J.add(J.gp(v_a_4681, "x"), J.gp(v_b_4682, "x")), 2.0)
			v_myp_4685 = J.div(J.add(J.gp(v_a_4681, "y"), J.gp(v_b_4682, "y")), 2.0)
			if (not J.leq(J.gp(env["pinch"], "mx"), null)):
				var _t5607 = J.gp(env["cam"], "free")
				v_c0_4686 = (_t5607 if J.t(_t5607) else {"x": J.add(J.gp(env["cam"], "x"), J.div(J.div(env["VW"], v_S9_4683), 2.0)), "y": J.add(J.gp(env["cam"], "y"), (J.div(J.sub(J.sub(env["VH"], env["TOP"]), env["BOT"]), v_S9_4683) * 0.55))})
				var _t5608 = env["cam"]
				var _t5609 = {"x": J.sub(J.gp(v_c0_4686, "x"), J.div(J.sub(v_mxp_4684, J.gp(env["pinch"], "mx")), v_S9_4683)), "y": J.sub(J.gp(v_c0_4686, "y"), J.div(J.sub(v_myp_4685, J.gp(env["pinch"], "my")), v_S9_4683))}
				J.sp(_t5608, "free", _t5609)
			var _t5610 = env["pinch"]
			J.sp(_t5610, "mx", v_mxp_4684)
			var _t5611 = env["pinch"]
			J.sp(_t5611, "my", v_myp_4685)
		return null
	var _t5612 = (not J.t(env["ptr"]))
	if (_t5612 if _t5612 else (not J.seq(J.gp(env["ptr"], "id"), J.gp(v_e_4678, "pointerId")))):
		return null
	var _t5613 = (not J.t(J.gp(env["ptr"], "btn")))
	if ((J.hypot_([J.sub(J.gp(v_p_4679, "x"), J.gp(env["ptr"], "sx")), J.sub(J.gp(v_p_4679, "y"), J.gp(env["ptr"], "sy"))]) > 12.0) if _t5613 else _t5613):
		var _t5614 = env["ptr"]
		J.sp(_t5614, "drag", true)
	if J.t(env["joy"]):
		var _t5615 = env["joy"]
		var _t5616 = J.gp(v_p_4679, "x")
		J.sp(_t5615, "x", _t5616)
		var _t5617 = env["joy"]
		var _t5618 = J.gp(v_p_4679, "y")
		J.sp(_t5617, "y", _t5618)
		if J.t(J.gp(env["ptr"], "drag")):
			var _t5619 = env["joy"]
			J.sp(_t5619, "on", true)

func _f770(this_, a: Array, env):
	var v_e_4689 = null; var v_p_4690 = null; var v_was_4691 = null; var v_j_4692 = null; var v_hb_4693 = null
	v_e_4689 = J.arg(a, 0)
	J.del(env["pts"], J.gp(v_e_4689, "pointerId"))
	if J.t(env["pinch"]):
		if (not J.t(J.len(J.S_Object_("keys", [env["pts"]])))):
			env["pinch"] = null
		return null
	var _t5622 = ((not J.leq(J.gp(env["ptr"], "id"), null)) if J.t(env["ptr"]) else env["ptr"])
	if J.t(((not J.seq(J.gp(env["ptr"], "id"), J.gp(v_e_4689, "pointerId"))) if J.t(_t5622) else _t5622)):
		return null
	var _t5623 = env["pt"]
	v_p_4690 = J.cl(_t5623, null, [v_e_4689])
	v_was_4691 = env["ptr"]
	env["ptr"] = null
	v_j_4692 = (J.gp(env["joy"], "on") if J.t(env["joy"]) else env["joy"])
	env["joy"] = null
	var _t5624 = (J.seq(env["scene"], "play") if J.t(v_j_4692) else v_j_4692)
	var _t5625 = (env["G"] if J.t(_t5624) else _t5624)
	if J.t(((not J.t(J.gp(env["G"], "over"))) if J.t(_t5625) else _t5625)):
		var _t5626 = env["settleNear"]
		J.cl(_t5626, null, [J.gp(J.gp(env["G"], "gh"), J.gp(env["G"], "active")), 44.0])
	if J.t((J.gp(v_was_4691, "btn") if J.t(v_was_4691) else v_was_4691)):
		env["LASTP"] = v_p_4690
		var _t5627 = env["hitBtn"]
		v_hb_4693 = J.cl(_t5627, null, [J.gp(v_p_4690, "x"), J.gp(v_p_4690, "y")])
		if J.t((J.seq(J.gp(v_hb_4693, "id"), J.gp(v_was_4691, "btn")) if J.t(v_hb_4693) else v_hb_4693)):
			var _t5628 = env["press"]
			J.cl(_t5628, null, [J.gp(v_hb_4693, "id")])
		else:
			if (J.hypot_([J.sub(J.gp(v_p_4690, "x"), J.gp(v_was_4691, "sx")), J.sub(J.gp(v_p_4690, "y"), J.gp(v_was_4691, "sy"))]) < 24.0):
				var _t5629 = env["press"]
				J.cl(_t5629, null, [J.gp(v_was_4691, "btn")])
		return null
	var _t5630 = ((not J.t(J.gp(v_was_4691, "drag"))) if J.t(v_was_4691) else v_was_4691)
	if J.t(((not J.t(v_j_4692)) if J.t(_t5630) else _t5630)):
		var _t5631 = env["tap"]
		J.cl(_t5631, null, [J.gp(v_p_4690, "x"), J.gp(v_p_4690, "y")])

func _f771(this_, a: Array, env):
	var v_e_4696 = null
	v_e_4696 = J.arg(a, 0)
	J.del(env["pts"], J.gp(v_e_4696, "pointerId"))
	env["pinch"] = null
	env["ptr"] = null
	env["joy"] = null

func _f784(this_, a: Array, env):
	return env["G"]

func _f785(this_, a: Array, env):
	return env["LV"]

func _f786(this_, a: Array, env):
	return env["FL"]

func _f787(this_, a: Array, env):
	return env["FLN"]

func _f788(this_, a: Array, env):
	return env["IMG"]

func _f789(this_, a: Array, env):
	return (env["scene"] if J.t(env["OPEN"]) else "closed")

func _f790(this_, a: Array, env):
	return env["paused"]

func _f791(this_, a: Array, env):
	return env["VW"]

func _f792(this_, a: Array, env):
	return env["VH"]

func _f793(this_, a: Array, env):
	return env["TOP"]

func _f794(this_, a: Array, env):
	return env["BOT"]

func _f795(this_, a: Array, env):
	return env["buttons"]

func _f796(this_, a: Array, env):
	return env["G"]

func _f797(this_, a: Array, env):
	return env["LV"]

func _f798(this_, a: Array, env):
	return env["FL"]

func _f799(this_, a: Array, env):
	return env["FLN"]

func _f800(this_, a: Array, env):
	return env["IMG"]

func _f801(this_, a: Array, env):
	return (env["scene"] if J.t(env["OPEN"]) else "closed")

func _f802(this_, a: Array, env):
	return env["paused"]

func _f803(this_, a: Array, env):
	return env["VW"]

func _f804(this_, a: Array, env):
	return env["VH"]

func _f805(this_, a: Array, env):
	return env["TOP"]

func _f806(this_, a: Array, env):
	return env["BOT"]

func _f808(this_, a: Array, env):
	var v_g_4823 = null
	v_g_4823 = J.arg(a, 0)
	return {"k": J.gp(J.gp(v_g_4823, "d"), "key"), "mul": J.gp(v_g_4823, "mul"), "pow": J.gp(v_g_4823, "pow"), "trainee": J.gp(v_g_4823, "trainee"), "spm": J.gp(v_g_4823, "spm"), "em": J.gp(v_g_4823, "em"), "tm": J.gp(v_g_4823, "tm"), "im": J.gp(v_g_4823, "im"), "icd": J.gp(v_g_4823, "icd"), "um": J.gp(v_g_4823, "um")}

func _f807(this_, a: Array, env):
	var _t5644 = env["G"]
	if J.t(_t5644):
		var _t5639 = J.gp(env["G"], "gpHas")
		var _t5640 = J.gp(env["G"], "gpNeed")
		var _t5641 = J.gp(env["G"], "gpTeam")
		var _t5642 = J.gp(env["G"], "gpD")
		var _t5643 = J.gp(env["G"], "gpTier")
		var _t5638 = J.gp(env["G"], "gh")
		_t5644 = {"has": _t5639, "need": _t5640, "team": _t5641, "D": _t5642, "tier": _t5643, "gh": J.mc(_t5638, "map", [Callable(self, "_f808").bind(env)])}
	return _t5644

func _f809(this_, a: Array, env):
	J.cl(env["gpStart"], null, [])

func _f810(this_, a: Array, env):
	var v_i_4828 = null
	v_i_4828 = J.arg(a, 0)
	var _t5645 = env["gpF"]
	return J.cl(_t5645, null, [J.gp(J.gp(env["G"], "gh"), v_i_4828)])

func _f811(this_, a: Array, env):
	var v_w_4831 = null
	v_w_4831 = J.arg(a, 0)
	var _t5646 = env["endNight"]
	J.cl(_t5646, null, [v_w_4831])

func _f812(this_, a: Array, env):
	var v_r_4834 = null; var v_amt_4835 = null; var v_i_4836 = null
	v_r_4834 = J.arg(a, 0)
	v_amt_4835 = J.arg(a, 1)
	v_i_4836 = J.arg(a, 2)
	var _t5647 = env["scareRes"]
	J.cl(_t5647, null, [v_r_4834, v_amt_4835, (null if J.leq(v_i_4836, null) else J.gp(J.gp(env["G"], "gh"), v_i_4836))])

func _f813(this_, a: Array, env):
	var v_sd_4839 = null; var v_lv_4840 = null
	v_sd_4839 = J.arg(a, 0)
	v_lv_4840 = J.arg(a, 1)
	var _t5648 = env["newGame"]
	J.cl(_t5648, null, [v_sd_4839, v_lv_4840])
	J.cl(env["bake"], null, [])

func _f814(this_, a: Array, env):
	return ({"x": J.gp(env["SAFE"], "x"), "y": J.gp(env["SAFE"], "y"), "r": J.gp(env["SAFE"], "r"), "f": J.gp(env["SAFE"], "f"), "nodes": J.S_Object_("keys", [J.gp(env["SAFE"], "nodes")]), "on": J.cl(env["safeOn"], null, [])} if J.t(env["SAFE"]) else null)

func _f815(this_, a: Array, env):
	var v_i_4845 = null
	v_i_4845 = J.arg(a, 0)
	var _t5649 = env["inSafe"]
	return J.cl(_t5649, null, [J.gp(J.gp(env["G"], "gh"), v_i_4845)])

func _f816(this_, a: Array, env):
	var v_x_4848 = null; var v_y_4849 = null
	v_x_4848 = J.arg(a, 0)
	v_y_4849 = J.arg(a, 1)
	var _t5650 = env["inSafeXY"]
	return J.cl(_t5650, null, [v_x_4848, v_y_4849])

func _f817(this_, a: Array, env):
	var _t5651 = J.gp(env["G"], "_uq")
	return J.S_Object_("keys", [(_t5651 if J.t(_t5651) else {})])

func _f818(this_, a: Array, env):
	return {"z": J.gp(env["cam"], "z"), "free": (not (not J.t(J.gp(env["cam"], "free")))), "x": J.gp(env["cam"], "x"), "y": J.gp(env["cam"], "y")}

func _f820(this_, a: Array, env):
	var v_b_4858 = null
	v_b_4858 = J.arg(a, 0)
	return {"id": J.gp(v_b_4858, "id"), "x": J.gp(v_b_4858, "x"), "y": J.gp(v_b_4858, "y"), "w": J.gp(v_b_4858, "w"), "h": J.gp(v_b_4858, "h")}

func _f819(this_, a: Array, env):
	return J.mc(env["buttons"], "map", [Callable(self, "_f820").bind(env)])

func _f821(this_, a: Array, env):
	J.cl(env["actPress"], null, [])

func _f822(this_, a: Array, env):
	var _t5652 = env["ctxAction"]
	return J.cl(_t5652, null, [J.gp(J.gp(env["G"], "gh"), J.gp(env["G"], "active"))])

func _f823(this_, a: Array, env):
	var v_id_4865 = null; var v_l_4866 = null
	v_id_4865 = J.arg(a, 0)
	v_l_4866 = J.arg(a, 1)
	var _t5653 = env["noise"]
	J.cl(_t5653, null, [v_id_4865, v_l_4866])

func _f824(this_, a: Array, env):
	var v_z_4869 = null
	v_z_4869 = J.arg(a, 0)
	var _t5654 = env["cam"]
	J.sp(_t5654, "z", v_z_4869)

func _f825(this_, a: Array, env):
	var v_v_4872 = null
	v_v_4872 = J.arg(a, 0)
	env["paused"] = v_v_4872

func _f826(this_, a: Array, env):
	var v_dt_4875 = null; var v_n_4876 = null; var v_pp_4877 = null; var v_i_4878 = null
	v_dt_4875 = J.arg(a, 0)
	v_n_4876 = J.arg(a, 1)
	v_pp_4877 = env["paused"]
	env["paused"] = false
	v_i_4878 = 0.0
	while true:
		if not J.cmp(v_i_4878, (v_n_4876 if J.t(v_n_4876) else 1.0), "<"): break
		var _t5655 = env["update"]
		J.cl(_t5655, null, [v_dt_4875])
		v_i_4878 = J.num(v_i_4878) + 1.0
	env["paused"] = v_pp_4877
	J.cl(env["draw"], null, [])

func _f827(this_, a: Array, env):
	var v_i_4881 = null
	v_i_4881 = J.arg(a, 0)
	var _t5656 = env["catchGhost"]
	var _t5658 = J.gp(J.gp(env["G"], "gh"), v_i_4881)
	var _t5657 = J.gp(J.gp(env["G"], "guards"), 0.0)
	J.cl(_t5656, null, [_t5658, (_t5657 if J.t(_t5657) else {"dir": 1.0})])

func _f828(this_, a: Array, env):
	var v_i_4884 = null; var v_id_4885 = null
	v_i_4884 = J.arg(a, 0)
	v_id_4885 = J.arg(a, 1)
	var _t5659 = env["gotoNode"]
	return J.cl(_t5659, null, [J.gp(J.gp(env["G"], "gh"), v_i_4884), v_id_4885])

func _f829(this_, a: Array, env):
	var v_s_4888 = null
	v_s_4888 = J.arg(a, 0)
	var _t5660 = env["G"]
	var _t5661 = J.add(J.gp(_t5660, "t"), v_s_4888)
	J.sp(_t5660, "t", _t5661)

func _f830(this_, a: Array, env):
	return env["G"]

func _f831(this_, a: Array, env):
	var v_v_4893 = null
	v_v_4893 = J.arg(a, 0)

func _f832(this_, a: Array, env):
	var v_x_4896 = null; var v_y_4897 = null
	v_x_4896 = J.arg(a, 0)
	v_y_4897 = J.arg(a, 1)
	var _t5662 = env["W2S"]
	return J.cl(_t5662, null, [v_x_4896, v_y_4897])

func _f833(this_, a: Array, env):
	var v_c_4900 = null; var v_o_4901 = null; var v_e_4902 = null
	v_c_4900 = J.arg(a, 0)
	v_o_4901 = env["ctx"]
	env["ctx"] = v_c_4900
	J.cl(env["draw"], null, [])
	J.cl(env["drawJoy"], null, [])
	env["ctx"] = v_o_4901

func _f834(this_, a: Array, env):
	return env["scene"]

func _f835(this_, a: Array, env):
	return env["OPEN"]

func _f836(this_, a: Array, env):
	return env["TOP"]

func _f837(this_, a: Array, env):
	return env["BOT"]

func _f838(this_, a: Array, env):
	return (not (not J.t((J.gp(env["joy"], "on") if J.t(env["joy"]) else env["joy"]))))

func _f839(this_, a: Array, env):
	return env["G"]

func _f840(this_, a: Array, env):
	if J.t(env["OPEN"]):
		J.cl(env["resize"], null, [])

func _f845(this_, a: Array, env):
	return env["OPEN"]

func _f336(this_, a: Array, env):
	var v__cv_1975 = null; var v_NIGHT_2001 = null; var v_WARD_2007 = null; var v_buildMap_2091 = null; var v_placeUnits_2092 = null; var v_nearNode_2109 = null; var v_nearRes_2151 = null; var v_crayon_2196 = null; var v_rr_2203 = null; var v_open_2242 = null
	var _s817 = {"__p": env, "OPEN": null, "RAF": null, "ROOT": null, "FONT": null, "cv": null, "ctx": null, "DPR": null, "VW": null, "VH": null, "TOP": null, "BOT": null, "IMG": null, "Q": null, "WW": null, "WH": null, "BOTX": null, "FL": null, "FYS": null, "SX": null, "LX": null, "GLX": null, "PX0": null, "LV": null, "STORY": null, "TRUTH": null, "FLN": null, "LV0": null, "LEVELS": null, "PH": null, "seed": null, "LINES": null, "used": null, "GH": null, "CARDS": null, "GP_TRAINEE_POW": null, "GP_BASE": null, "GP_TIER_MAX": null, "GP_TRAINEE_MSG": null, "G": null, "scene": null, "paused": null, "PHT": null, "HUM": null, "ITEM": null, "BAGMAX": null, "curLv": null, "BLOCKMSG": null, "PPL_META": null, "SAFE": null, "SAFE_R": null, "SCREAM": null, "SPOOKL": null, "BALKL": null, "DROPK": null, "PPLFX": null, "TAOL": null, "ULT": null, "MV": null, "OMEN": null, "STRIKE": null, "AFTER": null, "REACT": null, "COUNT": null, "BLD": null, "HH": null, "HHW": null, "PROP": null, "PROPLINE": null, "LV0K": null, "cam": null, "staticCv": null, "LASTP": null, "CULL": null, "buttons": null, "CR": null, "CRC": null, "joy": null, "ptr": null, "JR": null, "pts": null, "pinch": null, "PRESS": null, "PAD": null, "last": null, "LIFT": null, "UNIT": null, "TS": null, "useLevel": null, "fy": null, "rnd": null, "pick": null, "shuffle": null, "clamp": null, "line": null, "gpRead": null, "gpApply": null, "gpSv": null, "gpSvPut": null, "gpTier": null, "gpNeed": null, "gpDiff": null, "gpPowOf": null, "gpTeam": null, "gpF": null, "gpE": null, "gpStart": null, "gpTick": null, "gpOnEnd": null, "gpGoVillage": null, "gpPill": null, "gpBadge": null, "gpTitle": null, "gpOver": null, "newGame": null, "node": null, "link": null, "unitByDoor": null, "unitOf": null, "mkHuman": null, "spawnZoneGuards": null, "inZone": null, "toast": null, "float": null, "shortcut": null, "canPass": null, "humanPass": null, "joyMove": null, "posOf": null, "onArrive": null, "gotoNode": null, "dijkstra": null, "humanPassTo": null, "mirrorOn": null, "update": null, "takeItem": null, "unlockUnit": null, "checkAlert": null, "initSafe": null, "safeOn": null, "inSafeXY": null, "inSafe": null, "safeNode": null, "nearSafe": null, "nearestAny": null, "nearNodeH": null, "uniq": null, "pplScream": null, "balk": null, "startShock": null, "pplResTick": null, "pplTick": null, "drawDrops": null, "drawSafe": null, "pplDrawRes": null, "pplStep": null, "pplGuard": null, "nearestGhost": null, "humanUpdate": null, "catchGhost": null, "loseLoot": null, "spawnTao": null, "taoUpdate": null, "gatePress": null, "gateUpdate": null, "dollEscape": null, "endNight": null, "say": null, "scareRes": null, "flee": null, "addFear": null, "standStill": null, "calm": null, "approach": null, "doorBlock": null, "scarePress": null, "scareGuard": null, "part": null, "stepFx": null, "ultPress": null, "applyUlt": null, "invPress": null, "chooseCard": null, "startMove": null, "moveUpdate": null, "addTrace": null, "traceUpdate": null, "pickReact": null, "doReact": null, "setupBeans": null, "beansCheck": null, "drawBowl": null, "drawMouth": null, "txt": null, "drawMoves": null, "drawTraces": null, "reactPose": null, "reactProps": null, "drawTaskProps": null, "genLevel": null, "wpick": null, "buildMap2": null, "placeUnits2": null, "bake2": null, "resUpdate2": null, "chain": null, "noise": null, "spook": null, "reliefUpdate": null, "lureCost": null, "ctxAction": null, "actPress": null, "giveStory": null, "questUpdate": null, "drawProps2": null, "miniJump": null, "drawMini": null, "resize": null, "bake": null, "W2S": null, "spr": null, "sprite": null, "drawWard": null, "bubble": null, "crCol": null, "crRnd": null, "crHash": null, "crGrain": null, "crShape": null, "crTrace": null, "crBuild": null, "crGet": null, "crBlit": null, "crPanel": null, "crText": null, "crFill": null, "crBar": null, "crTone": null, "crBtn": null, "crBubble": null, "crBg": null, "crPressed": null, "btn": null, "draw": null, "drawHUD": null, "wrap": null, "panel": null, "drawChoice": null, "drawStory": null, "drawOver": null, "crTitleDeco": null, "drawTitle": null, "settleNear": null, "pt": null, "joyVec": null, "drawJoy": null, "hitBtn": null, "tap": null, "worldTap": null, "press": null, "frame": null, "loadImgs": null, "close": null}
	_s817["TS"] = Callable(self, "_f337").bind(_s817)
	_s817["useLevel"] = Callable(self, "_f338").bind(_s817)
	_s817["fy"] = Callable(self, "_f340").bind(_s817)
	_s817["rnd"] = Callable(self, "_f341").bind(_s817)
	_s817["pick"] = Callable(self, "_f342").bind(_s817)
	_s817["shuffle"] = Callable(self, "_f343").bind(_s817)
	_s817["clamp"] = Callable(self, "_f344").bind(_s817)
	_s817["line"] = Callable(self, "_f345").bind(_s817)
	_s817["gpRead"] = Callable(self, "_f348").bind(_s817)
	_s817["gpApply"] = Callable(self, "_f349").bind(_s817)
	_s817["gpSv"] = Callable(self, "_f350").bind(_s817)
	_s817["gpSvPut"] = Callable(self, "_f351").bind(_s817)
	_s817["gpTier"] = Callable(self, "_f352").bind(_s817)
	_s817["gpNeed"] = Callable(self, "_f353").bind(_s817)
	_s817["gpDiff"] = Callable(self, "_f354").bind(_s817)
	_s817["gpPowOf"] = Callable(self, "_f355").bind(_s817)
	_s817["gpTeam"] = Callable(self, "_f356").bind(_s817)
	_s817["gpF"] = Callable(self, "_f358").bind(_s817)
	_s817["gpE"] = Callable(self, "_f359").bind(_s817)
	_s817["gpStart"] = Callable(self, "_f360").bind(_s817)
	_s817["gpTick"] = Callable(self, "_f362").bind(_s817)
	_s817["gpOnEnd"] = Callable(self, "_f363").bind(_s817)
	_s817["gpGoVillage"] = Callable(self, "_f364").bind(_s817)
	_s817["gpPill"] = Callable(self, "_f365").bind(_s817)
	_s817["gpBadge"] = Callable(self, "_f366").bind(_s817)
	_s817["gpTitle"] = Callable(self, "_f367").bind(_s817)
	_s817["gpOver"] = Callable(self, "_f370").bind(_s817)
	_s817["newGame"] = Callable(self, "_f371").bind(_s817)
	_s817["node"] = Callable(self, "_f374").bind(_s817)
	_s817["link"] = Callable(self, "_f375").bind(_s817)
	v_buildMap_2091 = Callable(self, "_f376").bind(_s817)
	v_placeUnits_2092 = Callable(self, "_f381").bind(_s817)
	_s817["unitByDoor"] = Callable(self, "_f395").bind(_s817)
	_s817["unitOf"] = Callable(self, "_f396").bind(_s817)
	_s817["mkHuman"] = Callable(self, "_f397").bind(_s817)
	_s817["spawnZoneGuards"] = Callable(self, "_f398").bind(_s817)
	_s817["inZone"] = Callable(self, "_f399").bind(_s817)
	_s817["toast"] = Callable(self, "_f400").bind(_s817)
	_s817["float"] = Callable(self, "_f401").bind(_s817)
	_s817["shortcut"] = Callable(self, "_f404").bind(_s817)
	_s817["canPass"] = Callable(self, "_f405").bind(_s817)
	_s817["humanPass"] = Callable(self, "_f406").bind(_s817)
	_s817["joyMove"] = Callable(self, "_f407").bind(_s817)
	_s817["posOf"] = Callable(self, "_f409").bind(_s817)
	_s817["onArrive"] = Callable(self, "_f410").bind(_s817)
	_s817["gotoNode"] = Callable(self, "_f411").bind(_s817)
	_s817["dijkstra"] = Callable(self, "_f413").bind(_s817)
	_s817["humanPassTo"] = Callable(self, "_f416").bind(_s817)
	v_nearNode_2109 = Callable(self, "_f418").bind(_s817)
	_s817["mirrorOn"] = Callable(self, "_f419").bind(_s817)
	_s817["update"] = Callable(self, "_f421").bind(_s817)
	_s817["takeItem"] = Callable(self, "_f433").bind(_s817)
	_s817["unlockUnit"] = Callable(self, "_f435").bind(_s817)
	_s817["checkAlert"] = Callable(self, "_f436").bind(_s817)
	_s817["initSafe"] = Callable(self, "_f437").bind(_s817)
	_s817["safeOn"] = Callable(self, "_f438").bind(_s817)
	_s817["inSafeXY"] = Callable(self, "_f439").bind(_s817)
	_s817["inSafe"] = Callable(self, "_f440").bind(_s817)
	_s817["safeNode"] = Callable(self, "_f441").bind(_s817)
	_s817["nearSafe"] = Callable(self, "_f442").bind(_s817)
	_s817["nearestAny"] = Callable(self, "_f443").bind(_s817)
	_s817["nearNodeH"] = Callable(self, "_f445").bind(_s817)
	_s817["uniq"] = Callable(self, "_f446").bind(_s817)
	_s817["pplScream"] = Callable(self, "_f448").bind(_s817)
	_s817["balk"] = Callable(self, "_f449").bind(_s817)
	_s817["startShock"] = Callable(self, "_f450").bind(_s817)
	_s817["pplResTick"] = Callable(self, "_f451").bind(_s817)
	_s817["pplTick"] = Callable(self, "_f452").bind(_s817)
	_s817["drawDrops"] = Callable(self, "_f455").bind(_s817)
	_s817["drawSafe"] = Callable(self, "_f457").bind(_s817)
	_s817["pplDrawRes"] = Callable(self, "_f475").bind(_s817)
	_s817["pplStep"] = Callable(self, "_f476").bind(_s817)
	_s817["pplGuard"] = Callable(self, "_f477").bind(_s817)
	_s817["nearestGhost"] = Callable(self, "_f478").bind(_s817)
	_s817["humanUpdate"] = Callable(self, "_f480").bind(_s817)
	_s817["catchGhost"] = Callable(self, "_f483").bind(_s817)
	_s817["loseLoot"] = Callable(self, "_f491").bind(_s817)
	_s817["spawnTao"] = Callable(self, "_f493").bind(_s817)
	_s817["taoUpdate"] = Callable(self, "_f494").bind(_s817)
	_s817["gatePress"] = Callable(self, "_f500").bind(_s817)
	_s817["gateUpdate"] = Callable(self, "_f501").bind(_s817)
	_s817["dollEscape"] = Callable(self, "_f504").bind(_s817)
	_s817["endNight"] = Callable(self, "_f506").bind(_s817)
	_s817["say"] = Callable(self, "_f508").bind(_s817)
	_s817["scareRes"] = Callable(self, "_f509").bind(_s817)
	_s817["flee"] = Callable(self, "_f511").bind(_s817)
	_s817["addFear"] = Callable(self, "_f513").bind(_s817)
	_s817["standStill"] = Callable(self, "_f514").bind(_s817)
	_s817["calm"] = Callable(self, "_f515").bind(_s817)
	_s817["approach"] = Callable(self, "_f516").bind(_s817)
	v_nearRes_2151 = Callable(self, "_f519").bind(_s817)
	_s817["doorBlock"] = Callable(self, "_f521").bind(_s817)
	_s817["scarePress"] = Callable(self, "_f523").bind(_s817)
	_s817["scareGuard"] = Callable(self, "_f529").bind(_s817)
	_s817["part"] = Callable(self, "_f530").bind(_s817)
	_s817["stepFx"] = Callable(self, "_f531").bind(_s817)
	_s817["ultPress"] = Callable(self, "_f537").bind(_s817)
	_s817["applyUlt"] = Callable(self, "_f538").bind(_s817)
	_s817["invPress"] = Callable(self, "_f548").bind(_s817)
	_s817["chooseCard"] = Callable(self, "_f549").bind(_s817)
	_s817["startMove"] = Callable(self, "_f550").bind(_s817)
	_s817["moveUpdate"] = Callable(self, "_f551").bind(_s817)
	_s817["addTrace"] = Callable(self, "_f552").bind(_s817)
	_s817["traceUpdate"] = Callable(self, "_f554").bind(_s817)
	_s817["pickReact"] = Callable(self, "_f563").bind(_s817)
	_s817["doReact"] = Callable(self, "_f565").bind(_s817)
	_s817["setupBeans"] = Callable(self, "_f567").bind(_s817)
	_s817["beansCheck"] = Callable(self, "_f570").bind(_s817)
	_s817["drawBowl"] = Callable(self, "_f571").bind(_s817)
	_s817["drawMouth"] = Callable(self, "_f572").bind(_s817)
	_s817["txt"] = Callable(self, "_f573").bind(_s817)
	_s817["drawMoves"] = Callable(self, "_f574").bind(_s817)
	_s817["drawTraces"] = Callable(self, "_f577").bind(_s817)
	_s817["reactPose"] = Callable(self, "_f580").bind(_s817)
	_s817["reactProps"] = Callable(self, "_f581").bind(_s817)
	_s817["drawTaskProps"] = Callable(self, "_f582").bind(_s817)
	_s817["genLevel"] = Callable(self, "_f583").bind(_s817)
	_s817["wpick"] = Callable(self, "_f594").bind(_s817)
	_s817["buildMap2"] = Callable(self, "_f596").bind(_s817)
	_s817["placeUnits2"] = Callable(self, "_f604").bind(_s817)
	_s817["bake2"] = Callable(self, "_f631").bind(_s817)
	_s817["resUpdate2"] = Callable(self, "_f647").bind(_s817)
	_s817["chain"] = Callable(self, "_f654").bind(_s817)
	_s817["noise"] = Callable(self, "_f657").bind(_s817)
	_s817["spook"] = Callable(self, "_f660").bind(_s817)
	_s817["reliefUpdate"] = Callable(self, "_f662").bind(_s817)
	_s817["lureCost"] = Callable(self, "_f665").bind(_s817)
	_s817["ctxAction"] = Callable(self, "_f666").bind(_s817)
	_s817["actPress"] = Callable(self, "_f673").bind(_s817)
	_s817["giveStory"] = Callable(self, "_f680").bind(_s817)
	_s817["questUpdate"] = Callable(self, "_f681").bind(_s817)
	_s817["drawProps2"] = Callable(self, "_f686").bind(_s817)
	_s817["miniJump"] = Callable(self, "_f694").bind(_s817)
	_s817["drawMini"] = Callable(self, "_f696").bind(_s817)
	_s817["resize"] = Callable(self, "_f701").bind(_s817)
	v_crayon_2196 = Callable(self, "_f702").bind(_s817)
	_s817["bake"] = Callable(self, "_f703").bind(_s817)
	_s817["W2S"] = Callable(self, "_f704").bind(_s817)
	_s817["spr"] = Callable(self, "_f705").bind(_s817)
	_s817["sprite"] = Callable(self, "_f706").bind(_s817)
	_s817["drawWard"] = Callable(self, "_f707").bind(_s817)
	_s817["bubble"] = Callable(self, "_f708").bind(_s817)
	v_rr_2203 = Callable(self, "_f709").bind(_s817)
	_s817["crCol"] = Callable(self, "_f710").bind(_s817)
	_s817["crRnd"] = Callable(self, "_f711").bind(_s817)
	_s817["crHash"] = Callable(self, "_f713").bind(_s817)
	_s817["crGrain"] = Callable(self, "_f714").bind(_s817)
	_s817["crShape"] = Callable(self, "_f715").bind(_s817)
	_s817["crTrace"] = Callable(self, "_f717").bind(_s817)
	_s817["crBuild"] = Callable(self, "_f718").bind(_s817)
	_s817["crGet"] = Callable(self, "_f721").bind(_s817)
	_s817["crBlit"] = Callable(self, "_f722").bind(_s817)
	_s817["crPanel"] = Callable(self, "_f723").bind(_s817)
	_s817["crText"] = Callable(self, "_f724").bind(_s817)
	_s817["crFill"] = Callable(self, "_f726").bind(_s817)
	_s817["crBar"] = Callable(self, "_f727").bind(_s817)
	_s817["crTone"] = Callable(self, "_f728").bind(_s817)
	_s817["crBtn"] = Callable(self, "_f729").bind(_s817)
	_s817["crBubble"] = Callable(self, "_f730").bind(_s817)
	_s817["crBg"] = Callable(self, "_f731").bind(_s817)
	_s817["crPressed"] = Callable(self, "_f732").bind(_s817)
	_s817["btn"] = Callable(self, "_f733").bind(_s817)
	_s817["draw"] = Callable(self, "_f734").bind(_s817)
	_s817["drawHUD"] = Callable(self, "_f754").bind(_s817)
	_s817["wrap"] = Callable(self, "_f756").bind(_s817)
	_s817["panel"] = Callable(self, "_f757").bind(_s817)
	_s817["drawChoice"] = Callable(self, "_f758").bind(_s817)
	_s817["drawStory"] = Callable(self, "_f760").bind(_s817)
	_s817["drawOver"] = Callable(self, "_f762").bind(_s817)
	_s817["crTitleDeco"] = Callable(self, "_f764").bind(_s817)
	_s817["drawTitle"] = Callable(self, "_f765").bind(_s817)
	_s817["settleNear"] = Callable(self, "_f772").bind(_s817)
	_s817["pt"] = Callable(self, "_f773").bind(_s817)
	_s817["joyVec"] = Callable(self, "_f774").bind(_s817)
	_s817["drawJoy"] = Callable(self, "_f775").bind(_s817)
	_s817["hitBtn"] = Callable(self, "_f776").bind(_s817)
	_s817["tap"] = Callable(self, "_f777").bind(_s817)
	_s817["worldTap"] = Callable(self, "_f778").bind(_s817)
	_s817["press"] = Callable(self, "_f782").bind(_s817)
	_s817["frame"] = Callable(self, "_f783").bind(_s817)
	_s817["loadImgs"] = Callable(self, "_f841").bind(_s817)
	v_open_2242 = Callable(self, "_f843").bind(_s817)
	_s817["close"] = Callable(self, "_f844").bind(_s817)
	_s817["OPEN"] = false
	_s817["RAF"] = 0.0
	_s817["ROOT"] = J.S_document_("createElement", ["section"])
	var _t5515 = _s817["ROOT"]
	J.sp(_t5515, "id", "tw-root")
	var _t5516 = _s817["ROOT"]
	J.sp(_t5516, "className", "tw-root")
	v__cv_1975 = J.S_document_("createElement", ["canvas"])
	J.sp(v__cv_1975, "className", "tw-cv")
	J.mc(_s817["ROOT"], "appendChild", [v__cv_1975])
	var _t5517 = J.gp(J.G.get("document"), "body")
	J.mc(_t5517, "appendChild", [_s817["ROOT"]])
	if (not J.seq(J.typeof_(J.G.get("World")), "undefined")):
		var _t5518 = J.gp(J.G.get("World"), "ICON")
		J.sp(_t5518, "tower", "樓")
	_s817["FONT"] = "\"PingFang HK\",\"PingFang TC\",\"Noto Sans CJK TC\",\"Noto Sans TC\",\"Microsoft JhengHei\",sans-serif"
	_s817["cv"] = v__cv_1975
	_s817["ctx"] = J.mc(_s817["cv"], "getContext", ["2d"])
	var _t5519 = J.gp(J.G.get("window"), "devicePixelRatio")
	var _t5520 = J.gp(J.G.get("window"), "devicePixelRatio")
	_s817["DPR"] = J.min_([2.0, (_t5520 if J.t(_t5520) else 1.0)])
	_s817["VW"] = 390.0
	_s817["VH"] = 844.0
	_s817["TOP"] = 96.0
	_s817["BOT"] = 240.0
	_s817["IMG"] = {}
	_s817["Q"] = J.construct(J.G.get("URLSearchParams"), [J.gp(J.G.get("location"), "search")])
	_s817["WW"] = 600.0
	_s817["WH"] = 900.0
	_s817["BOTX"] = 0.0
	_s817["FL"] = 5.0
	_s817["LEVELS"] = {"flat": {"name": "組屋", "bg": "flatbg", "FL": 5.0, "FYS": [873.0, 711.0, 549.0, 405.0, 261.0, 117.0], "SX": 45.0, "LX": 555.0, "GLX": 555.0, "PX0": 105.0, "guard0": "f0_d2", "fln": ["地下", "二樓", "三樓", "四樓", "五樓", "天台"], "units": [[0.0, 1.0, "zha", "money", "npc_ken", 0.0, "雜貨舖", 330.0, [255.0, 405.0]], [0.0, 2.0, "datuk", null, null, (-1.0), "保安亭", 470.0, [405.0, 520.0]], [1.0, 0.0, null, "food", "npc_it", (-1.0), "學生房", 226.0, [78.0, 240.0]], [1.0, 1.0, "nuomi", "comb", "npc_auntie", 1.0, "老夫妻", 366.0, [240.0, 378.0]], [1.0, 2.0, null, null, null, (-1.0), "空置單位", 496.0, [378.0, 516.0]], [2.0, 0.0, null, "food", "npc_ken", 2.0, "大家庭", 226.0, [78.0, 240.0]], [2.0, 1.0, "nuomi", "comb", "npc_mis", (-1.0), "家庭理髮", 366.0, [240.0, 378.0]], [2.0, 2.0, "zha", "money", "npc_boss", (-1.0), "麻雀館", 496.0, [378.0, 516.0]], [3.0, 0.0, "menshen", null, null, (-1.0), "夜班護士", 226.0, [78.0, 240.0]], [3.0, 1.0, "zha", "money", "npc_ken", (-1.0), "囤積屋", 366.0, [240.0, 378.0]], [3.0, 2.0, null, "food", "npc_mis", 3.0, "卡拉OK", 496.0, [378.0, 516.0]], [4.0, 0.0, "fu", null, null, (-1.0), "封咗嘅單位", 226.0, [78.0, 240.0]], [4.0, 1.0, null, null, "npc_boss", 4.0, "養雀伯伯", 366.0, [240.0, 378.0]], [4.0, 2.0, "nuomi", "comb", "npc_auntie", (-1.0), "新婚夫婦", 496.0, [378.0, 516.0]]], "story": ["地庫：管理員話，停車場盡頭成日有部單車自己響鈴，佢話係陳伯以前架單車。", "地下：管理處話，頂樓嗰個貼滿紅紙嘅單位封咗好多年，但係夜晚成日有收音機聲。", "二樓：以前陳伯朝朝喺走廊淋花，見到人就問「食咗飯未呀？」", "三樓：有年七月，陳伯敲過我哋門借鹽，我扮唔喺屋企，冇開門……", "四樓：之後成座樓都聞到陣怪味，大家都以為係垃圾槽。", "五樓：陳伯隻雀仔而家我養住，佢一聽到收音機聲就唱歌，好似等緊有人敲門。", "六樓：天台門口有張舊相，係陳伯同成座樓街坊嘅中秋合照，個個都笑到見牙唔見眼。", "天台：陳伯以前晚晚上嚟淋花，佢話「花要有人睇住，人都係」。"], "hint": ["地下", "二樓", "三樓", "四樓", "五樓"], "truth": "呢座樓唔係真係鬧鬼——係有個伯伯等咗好耐，想有人記得佢。今晚之後，總算有人知道陳伯嘅名。"}, "shop": {"name": "老店屋", "bg": "shopbg", "FL": 4.0, "FYS": [812.0, 585.0, 420.0, 262.0, 74.0], "SX": 62.0, "LX": 552.0, "GLX": 520.0, "PX0": 122.0, "guard0": "f0_d1", "fln": ["地下", "二樓", "三樓", "四樓", "天台"], "units": [[0.0, 0.0, null, "food", "npc_ken", 0.0, "茶餐室", 232.0, [100.0, 370.0]], [0.0, 1.0, "datuk", null, null, (-1.0), "後廚", 430.0, [380.0, 560.0]], [1.0, 0.0, "zha", "money", "npc_boss", (-1.0), "中藥舖", 205.0, [100.0, 310.0]], [1.0, 1.0, "nuomi", "comb", "npc_auntie", 1.0, "老租客房", 420.0, [320.0, 530.0]], [2.0, 0.0, null, "food", "npc_it", 2.0, "工人房", 210.0, [100.0, 320.0]], [2.0, 1.0, "zha", "money", "npc_mis", 3.0, "麻雀房", 430.0, [330.0, 530.0]], [3.0, 0.0, null, null, "npc_ken", 4.0, "雜物房", 232.0, [100.0, 370.0]], [3.0, 1.0, "fu", null, null, (-1.0), "封咗嘅房", 445.0, [380.0, 530.0]]], "story": ["地庫：貨倉入面有部舊衣車，車針仲插住半件未補好嘅工衣。", "地下：茶餐室阿叔話，以前四樓住咗個車衫嘅芳姐，成條街啲工人都搵佢補衫。", "二樓：芳姐同我做咗三十年鄰居，佢話呢間屋就係佢一世，點都唔肯搬。", "三樓：收樓嗰年芳姐病咗入院，之後佢間房就封咗，門口貼滿紅紙。", "三樓：之後打麻雀打到三更，成日聽到樓上有車衣車聲，嗒嗒嗒咁響。", "四樓：我執雜物嗰陣搵到佢本記帳簿，最後一頁寫住「仲有十件衫未補完」。", "五樓：涼茶舖老闆娘話，芳姐每年冬至都會煲一大煲湯，逐層逐戶咁送。", "天台：芳姐以前喺天台曬衫，曬好就摺得四四正正，放喺各家門口。"], "hint": ["地下茶餐室", "二樓老租客", "三樓工人房", "三樓麻雀房", "四樓雜物房"], "truth": "芳姐唔係嚟嚇人——佢只係想做完手上最後嗰幾件衫。今晚之後，會有人幫佢將衫交返俾街坊。"}}
	_s817["LV0"] = _s817["LEVELS"]
	var _t5521 = J.mc(_s817["Q"], "get", ["night"])
	v_NIGHT_2001 = J.num((_t5521 if J.t(_t5521) else 150.0))
	_s817["PH"] = ["子時", "丑時", "寅時"]
	_s817["seed"] = 1.0
	_s817["LINES"] = {"afraid": ["咦？頭先咩聲嚟㗎？", "做咩部電視自己閃吓閃吓……", "我成身起晒雞皮，真係", "係咪隔籬屋喺度敲牆呀？", "唔好玩啦，邊個喺度？", "點解間屋凍到咁嘅？", "我好似見到有嘢郁咗一下", "背脊涼颼颼，唔對路", "冇嘢嘅冇嘢嘅，自己嚇自己", "頭先個影係咪你嚟㗎？"], "flee": ["鬼呀——！走先！", "救命呀！屋企有嘢呀！", "唔理啦，我落樓先！", "開門開門！我要出去！", "死啦死啦，真係有鬼！", "拖鞋都唔要啦，走呀！", "保安！保安！快啲上嚟！", "唔好追我呀——！"], "brave": ["嚇邊個呀？我見得多", "又係風啫，瞓覺", "想嚇我？等下世啦", "我後生做過夜更㗎"], "guard": ["巡樓囉，三樓啲燈又壞", "呢座樓夜晚真係陰陰哋", "巡完呢轉我要飲杯咖啡", "又要行樓梯，腳都軟埋"], "guardHit": ["照到喇！邊個喺度？", "手電筒照住你！唔好走！", "嗰度有嘢！我睇到！"], "wake": ["我開燈先，唔該晒", "念番兩句先瞓得著", "開晒啲燈佢就唔敢嚟"]}
	_s817["used"] = {}
	_s817["GH"] = [{"key": "eking", "gpk": "eguiking", "name": "餓鬼", "sprite": "eguiking", "h": 76.0, "sp": 104.0, "task": "food", "cross": {}, "tip": "餓鬼：入屋搵宵夜，站喺金圈讀條。"}, {"key": "toyol", "gpk": "toyol", "name": "Toyol", "sprite": "toyol", "h": 70.0, "sp": 132.0, "task": "money", "cross": {"zha": 1.0}, "tip": "Toyol：細隻，鐵閘罅都鑽得過，專偷銀包。"}, {"key": "tianhua", "gpk": "tianhua", "name": "天花姐", "sprite": "tianhua", "h": 74.0, "sp": 114.0, "task": "comb", "cross": {"nuomi": 1.0}, "tip": "天花姐：喺天花爬，地下撒嘅糯米攔佢唔住。"}]
	v_WARD_2007 = {"fu": {"n": "紅紙符", "m": "門頂貼住紅紙符，入唔到，繞路啦"}, "menshen": {"n": "門神", "m": "門神守住度門，我哋唔好亂嚟，繞路"}, "zha": {"n": "鐵閘", "m": "鐵閘鎖住，得 Toyol 鑽得入"}, "nuomi": {"n": "糯米", "m": "門口撒咗糯米，得天花姐過得去"}, "datuk": {"n": "拿督公神位", "m": "門口供住拿督公，要尊重，唔好入"}}
	_s817["CARDS"] = [{"id": "spd", "t": "鬼步加速", "d": "全部鬼移動快 20%"}, {"id": "pow", "t": "嚇人加倍", "d": "嚇人威力 +40%"}, {"id": "inv", "t": "隱身延長", "d": "隱身時間 +2 秒"}, {"id": "task", "t": "手快腳快", "d": "讀條快 35%"}, {"id": "arm", "t": "陰氣護體", "d": "被手電照到損失減半"}, {"id": "fear", "t": "怕意加成", "d": "嚇走人掉多 30% 怕意"}]
	_s817["GP_TRAINEE_POW"] = 250.0
	_s817["GP_BASE"] = {"flat": 1100.0, "shop": 1500.0}
	_s817["GP_TIER_MAX"] = 8.0
	_s817["GP_TRAINEE_MSG"] = "村入面未有呢隻鬼，只係見習水平。返村招募／升級先會變強！"
	_s817["G"] = null
	_s817["scene"] = "title"
	_s817["paused"] = false
	_s817["PHT"] = 60.0
	_s817["HUM"] = {"collector": {"n": "收數佬", "sp": 0.0, "spr": "res_collector", "h": 76.0}, "guard": {"n": "保安", "sp": 43.0, "spr": "res_guard", "h": 78.0}, "compass": {"n": "羅盤保安", "sp": 45.0, "spr": "npc_guard", "h": 78.0}, "mirror": {"n": "鏡子道士", "sp": 38.0, "spr": "npc_boss", "h": 76.0}, "decoy": {"n": "道士", "sp": 37.0, "spr": "npc_boss", "h": 76.0}, "dog": {"n": "看門狗", "sp": 230.0, "spr": null, "h": 38.0}}
	_s817["ITEM"] = {"food": {"n": "宵夜", "t": 0.8, "who": "eking"}, "money": {"n": "銀包", "t": 1.3, "who": "toyol"}, "comb": {"n": "木梳", "t": 1.6, "who": "tianhua"}, "doll": {"n": "替身紙人", "t": 2.0}, "key": {"n": "紅鎖匙", "t": 2.6}, "key2": {"n": "黃鎖匙", "t": 2.6}, "lost": {"n": "失物", "t": 1.5}}
	_s817["BAGMAX"] = 10.0
	_s817["curLv"] = "flat"
	_s817["BLOCKMSG"] = {"deity": "呢度有神明鎮宅，要尊重，繞路", "breach": "鎮宅未破：企定喺門口注入怕意", "key": "要先喺別戶偷到鎖匙", "chain": "隔籬戶未亂，呢度仲未入得", "door": "度門閂住，等住客開門嗰下先入", "stairSeal": "陰門開咗，樓梯封住"}
	_s817["PPL_META"] = {"res_gamer": {"n": {"foot": 0.0}, "s": {"k": 1.031, "foot": 0.0}}, "res_uncle": {"n": {"foot": 0.0}, "s": {"k": 1.0167, "foot": 0.0}}, "res_granny": {"n": {"foot": 0.0}, "s": {"k": 1.0071, "foot": 0.0}}, "res_helper": {"n": {"foot": 0.0}, "s": {"k": 1.0238, "foot": 0.0}}, "res_mjaunty": {"n": {"foot": 0.0}, "s": {"k": 0.9929, "foot": 0.0}}, "res_shopper": {"n": {"foot": 0.0}, "s": {"k": 0.9548, "foot": 0.0}}, "res_collector": {"n": {"foot": 0.0}, "s": {"k": 0.9167, "foot": 0.0}}, "res_guard": {"n": {"foot": 0.0}, "s": {"k": 0.9429, "foot": 0.0}}, "res_ot": {"n": {"foot": 0.0}, "s": {"k": 0.9262, "foot": 0.0}}, "res_gym": {"n": {"foot": 0.0}, "s": {"k": 0.9429, "foot": 0.0}}}
	_s817["SAFE"] = null
	_s817["SAFE_R"] = 150.0
	_s817["SCREAM"] = ["鬼呀——！走先！", "救命呀！屋企有嘢呀！", "唔理啦，我落樓先！", "開門開門！我要出去！", "死啦死啦，真係有鬼！", "拖鞋都唔要啦，走呀！", "保安！保安！快啲上嚟！", "唔好追我呀——！", "媽呀——！", "嘩——！唔關我事㗎！", "我唔住喇！聽日搬！", "走呀走呀！咪理銀包喇！", "有鬼呀！真係有鬼呀！", "我仲未想死呀——！", "乜嘢嚟㗎嗰樣嘢？！走！", "唔好搵我呀，我好人嚟㗎！", "頂唔順喇，走為上着！", "喂！等埋我呀——！", "我以後唔夜瞓喇！", "唔好過嚟呀——！", "救命呀！有冇人呀？！", "我對腳軟晒……走呀！", "今晚去酒店瞓好過！", "係咪我眼花……唔理喇走！", "嗚哇——！嚇死人咩！", "我發誓以後唔講粗口！", "快啲快啲，落樓梯！", "唔好捉我呀——！", "咩鬼嘢呀！走呀！", "喊都喊唔出呀！", "我要返鄉下！", "頭先嗰個……唔係人嚟！", "電話呢？算啦，走先！", "我心口好翳……走呀！", "冇眼睇喇，閃！", "條頸凍晒，走呀！", "唔玩喇唔玩喇！", "鬼打牆呀——！", "我以後晚晚開晒燈！", "快啲開門呀——！", "嘩呀——！頂唔順！", "救命呀——！鬼呀！", "我唔要命呀……唔係，我要命呀！", "走啦走啦，唔好望！", "阿媽救我呀——！", "嗰度有對眼呀——！", "我條腳唔聽話呀！", "落樓！落樓！快啲！", "冇得傾，我走先！", "唔好掂我呀——！", "咩呀咩呀咩呀——！", "我好驚呀——！", "點解會咁㗎——！", "我錯喇我錯喇！", "唔好嚇我呀大佬！", "走得快好世界！", "我出去搵人幫手先！", "救我呀，邊個都好！", "嘩，佢望住我呀！", "我今晚唔返嚟瞓喇！", "頭皮發晒麻呀！", "我要報警呀——！", "佢喺我後面呀——！", "唔好再跟住我呀！", "我以後唔睇鬼片喇！", "嚇到魂都冇埋！", "係真㗎！係真㗎！", "我唔信邪……但我信喇！", "快走，唔好回頭！", "我把聲都震晒呀！", "佢冇腳㗎——！", "好凍呀！好凍呀！", "開燈呀！開晒啲燈呀！", "唔好笑呀——！", "我唔識你呀——！", "冇得頂！", "我寧願返工都唔留喺度！", "呢間屋有嘢㗎！", "我仲有供樓未還㗎！", "我唔玩捉迷藏呀！", "我隻手凍到冇知覺！", "跑呀，唔好企喺度！", "我眼花，一定係眼花……走！", "邊個喺度笑呀——！", "我隻拖鞋呢？唔要喇！", "我發夢……一定係發夢！", "我收工喇！收工喇！", "鬼呀鬼呀鬼呀——！", "唔好拉我呀——！", "我未食飯㗎，唔好食我！", "嗰把聲喺耳邊呀——！", "啲燈熄晒喇，走呀！", "我唔夠膽再望多一眼！", "我腳都軟埋——走！", "唔關事，真係唔關事！", "我出去瞓街好過！", "隻手！有隻手呀——！", "我啲寒毛企晒起身！", "我同你冇仇㗎——！", "嗚嗚嗚，我要返屋企……", "我錯晒，我以後早啲瞓！", "快啲搵人嚟呀——！", "我把心跳到出嚟！", "嗰陣味好臭呀，走！", "個天花板有嘢呀——！", "我唔做呢份工喇！", "邊度走得最快呀？！", "我出去等天光！", "佢叫咗我個名呀——！", "唔好企喺門口呀，走！"]
	_s817["SPOOKL"] = ["嘩！！", "乜……乜嘢嚟㗎？！", "我唔做喇……", "嘩！有嘢喺我後面！", "咩、咩聲呀？！", "手電筒點解閃㗎？！", "冇嘢嘅冇嘢嘅……", "頭先係咪有嘢掂我？", "我……我去飲杯水先", "邊個喺度？！出嚟！", "唔好玩嘢呀！", "份人工唔包驚㗎！", "對講機！對講機呢？！", "我對腳震緊……", "係風……一定係風……", "老細冇講過有呢樣嘢㗎！", "佢、佢郁咗！", "我要加人工先得！", "嚇到我心都離一離", "背脊涼晒……"]
	_s817["BALKL"] = ["頂……嗰邊陰陰森森，唔過去喇", "嗰度凍到入骨，我唔行埋去", "老細話過嗰邊夜晚唔好去……", "算數，嗰度我唔跟喇", "嗰邊陰風陣陣……返轉頭先", "唔通真係有嘢？我返轉頭好過", "嗰度啲燈成日閃，唔去喇", "我條命緊要過份工", "嗰邊冇人去㗎，我都唔去", "唔該，嗰度我真係唔敢入"]
	_s817["DROPK"] = {"couple": "cup", "mahjong": "tile", "taxi": "cup", "cook": "bowl", "insomnia": "cup", "nurse": "cup", "debt": "cup", "gamer": "pad", "granny": "fan", "elder": "cup", "helper": "cup", "shopper": "box", "ot": "cup", "gym": "cup"}
	var _t5522 = J.G.get("window")
	var _t5576 = J.cl(Callable(self, "_f458").bind(_s817), null, [])
	J.sp(_t5522, "PPLFX", _t5576)
	_s817["PPLFX"] = _t5576
	_s817["TAOL"] = ["鈴……鈴……各位街坊安心瞓", "天師巡樓，邪氣退散", "聽住鈴聲，唔好亂走", "鈴聲到處，夜路平安"]
	_s817["ULT"] = {"eking": {"n": "大胃王", "d": "整層熄燈，黑暗中得返一張巨口！"}, "toyol": {"n": "一掃光", "d": "分身滿層亂竄，偷到一個唔留！"}, "tianhua": {"n": "千絲垂髮", "d": "頭髮沿走廊爬去隔籬屋，纏實成層人！"}}
	_s817["MV"] = {"eking": {"n": "碗筷自己郁・米缸巨口", "omen": "叮叮噹噹……", "tr": "food"}, "toyol": {"n": "細腳印・床底搶嘢", "omen": "嘻嘻……嘻嘻……", "tr": "mess"}, "tianhua": {"n": "天花滲水・倒吊貼面", "omen": "嘀……嘀……", "tr": "hair"}}
	_s817["OMEN"] = 0.75
	_s817["STRIKE"] = 0.65
	_s817["AFTER"] = 0.6
	_s817["REACT"] = {"scream": ["啊——！！", "嘩呀——！！", "救——命——！"], "kneel": ["唔好搵我……我冇做壞事㗎", "放過我啦……", "我同你無仇無怨㗎……"], "cover": ["睇唔到睇唔到睇唔到……", "唔好望唔好望……"], "fall": ["哎呀！", "跌親呀——"], "phone": ["喂？管理處呀！有嘢呀！", "喂喂喂！快啲上嚟！"], "slipper": ["打死你！打死你！", "睇我隻拖鞋！"], "push": ["你行先！", "唔好推我呀！"]}
	_s817["COUNT"] = ["一", "二", "三", "四", "五", "六", "七", "八", "九", "十"]
	_s817["BLD"] = {"flat": {"name": "組屋", "skin": "flatbg", "FH": 184.0, "ROOF": 150.0, "camW": 400.0, "levels": ["地庫", "地下", "一樓", "二樓", "三樓", "四樓", "五樓", "六樓", "七樓", "八樓", "九樓", "十樓", "天台"], "cols": [["stair", 112.0], ["u", 180.0], ["u", 180.0], ["u", 180.0], ["u", 180.0], ["lift", 124.0], ["u", 180.0], ["u", 180.0], ["u", 180.0], ["u", 180.0], ["back", 112.0]], "src": {"stair": [0.0, 78.0, 261.0, 405.0], "lift": [516.0, 600.0, 261.0, 405.0], "back": [0.0, 78.0, 261.0, 405.0, 1.0], "gstair": [0.0, 78.0, 711.0, 873.0], "glift": [520.0, 600.0, 711.0, 873.0], "roof": [0.0, 600.0, 0.0, 117.0], "res": [[78.0, 240.0, 117.0, 261.0], [240.0, 378.0, 117.0, 261.0], [378.0, 516.0, 117.0, 261.0], [78.0, 240.0, 261.0, 405.0], [240.0, 378.0, 261.0, 405.0], [378.0, 516.0, 261.0, 405.0], [78.0, 240.0, 405.0, 549.0], [240.0, 378.0, 405.0, 549.0], [378.0, 516.0, 405.0, 549.0], [78.0, 240.0, 549.0, 711.0], [240.0, 378.0, 549.0, 711.0], [378.0, 516.0, 549.0, 711.0]], "deity": [[78.0, 240.0, 117.0, 261.0]], "ground": [[78.0, 240.0, 711.0, 873.0], [240.0, 405.0, 711.0, 873.0], [405.0, 520.0, 711.0, 873.0]]}, "ground": ["信箱大堂", "士多", "管理處", "茶餐廳", "單車房", "垃圾房", "藥房", "洗衣舖"], "base": ["停車場", "機房", "水錶房", "貨倉", "雜物房", "停車場", "冷氣機房", "電錶房"], "pipes": [[2.0, 4.0, 3.0], [4.0, 7.0, 6.0], [1.0, 3.0, 0.0], [5.0, 7.0, 2.0], [7.0, 10.0, 5.0], [9.0, 12.0, 1.0], [8.0, 11.0, 7.0]], "lift": true}, "shop": {"name": "老店屋", "skin": "shopbg", "FH": 194.0, "ROOF": 140.0, "camW": 500.0, "levels": ["地庫", "地下", "一樓", "二樓", "三樓", "四樓", "五樓", "六樓", "七樓", "八樓", "天台"], "cols": [["stair", 124.0], ["u", 236.0], ["u", 236.0], ["u", 236.0], ["lift", 116.0], ["u", 236.0], ["u", 236.0], ["back", 96.0]], "src": {"stair": [0.0, 100.0, 262.0, 420.0], "lift": [0.0, 100.0, 420.0, 585.0, 1.0], "back": [530.0, 600.0, 262.0, 420.0], "gstair": [0.0, 100.0, 585.0, 812.0], "glift": [0.0, 100.0, 585.0, 812.0, 1.0], "roof": [0.0, 600.0, 0.0, 74.0], "res": [[100.0, 320.0, 262.0, 420.0], [320.0, 530.0, 262.0, 420.0], [100.0, 320.0, 420.0, 585.0], [320.0, 530.0, 420.0, 585.0], [100.0, 320.0, 74.0, 262.0]], "deity": [[320.0, 530.0, 74.0, 262.0]], "ground": [[100.0, 320.0, 585.0, 812.0], [320.0, 530.0, 585.0, 812.0]]}, "ground": ["茶餐室", "中藥舖", "車衣舖", "五金舖", "涼茶舖"], "base": ["貨倉", "雜物房", "米倉", "舊工場", "冷房"], "pipes": [[1.0, 3.0, 2.0], [3.0, 6.0, 4.0], [2.0, 5.0, 0.0], [5.0, 8.0, 1.0], [7.0, 10.0, 3.0]], "lift": false}}
	_s817["HH"] = {"gamer": {"n": "打機青年", "sp": ["res_gamer"], "awake": [1.0, 1.0, 1.0], "brave": 0.25, "props": ["pc", "fridge"], "items": ["food", "food"], "idle": ["再打多鋪先瞓", "隊友又送頭……", "聽日唔使返工，打通宵！"]}, "nurse": {"n": "夜班護士", "sp": ["npc_mis"], "awake": [1.0, 0.0, 0.0], "leave": 0.55, "props": ["phone", "kettle"], "items": ["money", "comb"], "idle": ["今晚又返通宵", "飲杯熱水先出門"]}, "elder": {"n": "獨居伯伯", "sp": ["res_uncle"], "awake": [0.0, 0.0, 1.0], "leave": 2.35, "props": ["radio", "ancestor"], "items": ["comb", "food"], "idle": ["唉，又瞓唔著", "聽朝早啲去飲茶"]}, "granny": {"n": "婆婆", "sp": ["res_granny"], "awake": [0.0, 0.0, 1.0], "props": ["radio", "fan"], "items": ["food", "comb"], "idle": ["個仔又冇打電話嚟……", "風扇開細啲先"]}, "couple": {"n": "新婚夫婦", "sp": ["npc_ken", "npc_mis"], "awake": [1.0, 0.0, 0.0], "props": ["tv", "fridge"], "items": ["food", "comb"], "idle": ["睇埋呢集先瞓", "聽日去邊度食早餐？"]}, "mahjong": {"n": "麻雀腳", "sp": ["res_mjaunty", "npc_boss", "npc_ken", "npc_mis"], "awake": [1.0, 1.0, 1.0], "props": ["mahjong", "fan"], "items": ["money", "money", "food"], "noisy": 1.0, "idle": ["碰！", "食糊！自摸！", "到你出牌喇", "今晚手氣真係差"]}, "shopper": {"n": "網購狂", "sp": ["res_shopper"], "awake": [1.0, 1.0, 0.0], "props": ["doorbell", "tv"], "items": ["money", "comb"], "idle": ["又有速遞到？", "買多件先，平呀嘛"]}, "taxi": {"n": "夜更的士佬", "sp": ["npc_ken"], "awake": [1.0, 1.0, 1.0], "away": 1.35, "props": ["fridge", "tv"], "items": ["food", "money"], "idle": ["收工喇，攰到死", "今晚載咗個好奇怪嘅客……"]}, "cook": {"n": "宵夜佬", "sp": ["npc_ken_sit"], "awake": [1.0, 1.0, 0.0], "props": ["rice", "fridge"], "items": ["food", "food"], "idle": ["煮個公仔麵先", "加隻蛋！"]}, "insomnia": {"n": "失眠阿叔", "sp": ["npc_boss"], "awake": [1.0, 1.0, 1.0], "brave": 0.4, "props": ["radio", "fan"], "items": ["money"], "idle": ["我喺呢度住咗四十年，咩未見過", "收音機陪我瞓"]}, "helper": {"n": "家務姐姐", "sp": ["res_helper"], "awake": [1.0, 1.0, 0.0], "props": ["washer", "fridge"], "items": ["food", "comb"], "idle": ["仲有一籃衫未熨……", "聽朝一早要陪婆婆睇醫生", "洗埋呢籃先瞓"]}, "ot": {"n": "加班族", "sp": ["res_ot"], "awake": [1.0, 1.0, 0.0], "away": 0.75, "props": ["pc", "tv"], "items": ["food", "food"], "idle": ["又OT到咁夜……", "食完個外賣就瞓", "老細仲WhatsApp我？"]}, "gym": {"n": "健身仔", "sp": ["res_gym"], "awake": [1.0, 1.0, 1.0], "brave": 0.5, "props": ["radio", "fan"], "items": ["food"], "idle": ["再做多十下！", "練完先食宵夜", "今晚練胸"]}, "debt": {"n": "欠債人家", "sp": ["npc_ken", "npc_auntie"], "awake": [1.0, 1.0, 0.0], "props": ["phone", "tv"], "items": ["food"], "idle": ["唔好出聲，佢哋又嚟……", "下個月一定還到"]}}
	_s817["HHW"] = [["gamer", 3.0], ["nurse", 2.0], ["elder", 2.0], ["granny", 2.0], ["couple", 3.0], ["mahjong", 1.0], ["shopper", 2.0], ["taxi", 1.0], ["cook", 2.0], ["insomnia", 1.0], ["helper", 1.0], ["ot", 2.0], ["gym", 1.0]]
	_s817["PROP"] = {"tv": {"n": "電視", "v": "附身電視", "lv": 1.0, "f": 24.0}, "fan": {"n": "風扇", "v": "附身風扇", "lv": 1.0, "f": 18.0}, "fridge": {"n": "雪櫃", "v": "附身雪櫃", "lv": 1.0, "f": 22.0}, "pc": {"n": "電腦", "v": "附身電腦", "lv": 1.0, "f": 26.0}, "radio": {"n": "收音機", "v": "開收音機", "lv": 2.0, "f": 20.0}, "phone": {"n": "電話", "v": "整響電話", "lv": 2.0, "f": 22.0}, "mahjong": {"n": "麻雀枱", "v": "自動洗牌", "lv": 2.0, "f": 30.0}, "doorbell": {"n": "門鐘", "v": "撳門鐘", "lv": 2.0, "f": 20.0}, "kettle": {"n": "水煲", "v": "自己煲水", "lv": 1.0, "f": 16.0}, "washer": {"n": "洗衣機", "v": "洗衣機自己轉", "lv": 2.0, "f": 20.0}, "rice": {"n": "電飯煲", "v": "電飯煲跳掣", "lv": 1.0, "f": 16.0}, "ancestor": {"n": "祖先牌位", "v": null}}
	_s817["PROPLINE"] = {"tv": ["部電視做咩自己開咗？！", "雪花……入面好似有個人影"], "fan": ["風扇自己轉到咁大力？！", "窗簾吹到飛晒起……"], "fridge": ["雪櫃門自己開咗！", "點解咁凍……"], "pc": ["電腦彈咗張鬼臉出嚟！", "我隻角色自己行開咗？！"], "radio": ["收音機自己播粵曲……", "邊個開咗收音機？"], "phone": ["三點幾有人打嚟……冇聲嘅", "喂？喂？邊位呀？"], "mahjong": ["啲牌自己洗緊！", "邊個郁咗我啲牌？！"], "doorbell": ["叮噹——門口冇人㗎喎", "又係速遞？咁夜？"], "kettle": ["水煲自己嗚嗚叫……", "我冇煲水㗎喎"], "washer": ["洗衣機自己開咗？！", "入面啲衫……好似有隻手"], "rice": ["電飯煲自己跳掣？", "啲飯冇咗一半！"]}
	_s817["LV0K"] = {"who": Callable(self, "_f630").bind(_s817)}
	_s817["cam"] = {"x": 0.0, "y": 0.0, "s": 1.0, "z": 1.0, "free": null}
	_s817["staticCv"] = null
	_s817["LASTP"] = null
	_s817["CULL"] = {"y0": (-1000000000.0), "y1": 1000000000.0}
	var _t5577 = J.G.get("window")
	var _t5578 = _s817["CULL"]
	J.sp(_t5577, "__twCull", _t5578)
	_s817["buttons"] = []
	_s817["CR"] = {"cache": {}, "n": 0.0, "M": 8.0, "tones": {"red": {"b": "#2b1012", "m": "#7a2522", "e": "#c4493c", "t": "#f2e3cc", "h": "#e07a62"}, "bone": {"b": "#1e1a16", "m": "#5c5246", "e": "#d8ccb0", "t": "#efe5cf", "h": "#f4ead2"}, "rust": {"b": "#2a190d", "m": "#8c4b1d", "e": "#d87e3c", "t": "#f6dcb6", "h": "#eea060"}, "violet": {"b": "#19132a", "m": "#4b3b6e", "e": "#9c88cc", "t": "#e8e0fa", "h": "#bfaee8"}, "moss": {"b": "#121a11", "m": "#3b5431", "e": "#8aac6c", "t": "#e4ecd2", "h": "#b4d090"}, "ink": {"b": "#18141b", "m": "#3c3544", "e": "#958a9c", "t": "#ebe3d6", "h": "#b8aec0"}, "paper": {"b": "#141016", "m": "#2e2430", "e": "#6a5a68", "t": "#e9e1d4", "h": "#8a7a8c"}, "sheet": {"b": "#1a1418", "m": "#3a2a34", "e": "#cdbf9f", "t": "#efe5cf", "h": "#e8dcc0"}, "note": {"b": "#d6c9ab", "m": "#b3a283", "e": "#3a2c28", "t": "#2a1e1c", "h": "#efe4c8"}, "dawn": {"b": "#1a1418", "m": "#3a5230", "e": "#d87e3c", "t": "#efe5cf", "h": "#eea060"}}}
	_s817["CRC"] = {"#ffffff": "#efe5cf", "#fff3c8": "#efdcb4", "#ffd54a": "#e6a85a", "#ffcc55": "#e6a85a", "#ffe9a0": "#e8d2a0", "#ffe9c0": "#efdcb8", "#8affc8": "#b2d394", "#9fd6bf": "#a9c79a", "#9fe0ff": "#a9a0d8", "#ff9a9a": "#e48a78", "#ffb0b0": "#e48a78", "#ffb7a0": "#e8a088", "#ff8a5a": "#e0844a", "#dddddd": "#ddd2bd", "#d8d8d0": "#ddd2bd", "#c8ccc4": "#cfc4b0", "#ecece6": "#efe5cf", "#d6dad2": "#ddd2bd", "#e2e6e0": "#efe5cf", "#7a7f78": "#9a8e92", "#55585a": "#8a7e84", "#5a5e58": "#7a6e74", "#e8e2d0": "#e6dcc6", "#ffd8c8": "#e8c4b0", "#ff3a2a": "#d2463a", "#d24a3a": "#c4493c"}
	_s817["joy"] = null
	_s817["ptr"] = null
	_s817["JR"] = 58.0
	_s817["pts"] = {}
	_s817["pinch"] = null
	var _t5579 = J.G.get("window")
	var _t5599 = Callable(self, "_f768").bind(_s817)
	J.sp(_t5579, "__twPD", _t5599)
	J.mc(_s817["cv"], "addEventListener", ["pointerdown", _t5599])
	var _t5600 = J.G.get("window")
	var _t5620 = Callable(self, "_f769").bind(_s817)
	J.sp(_t5600, "__twPM", _t5620)
	J.mc(_s817["cv"], "addEventListener", ["pointermove", _t5620])
	var _t5621 = J.G.get("window")
	var _t5632 = Callable(self, "_f770").bind(_s817)
	J.sp(_t5621, "__twPU", _t5632)
	J.mc(_s817["cv"], "addEventListener", ["pointerup", _t5632])
	J.mc(_s817["cv"], "addEventListener", ["pointercancel", Callable(self, "_f771").bind(_s817)])
	_s817["PRESS"] = null
	_s817["PAD"] = 10.0
	_s817["last"] = 0.0
	_s817["LIFT"] = (J.S_window_("LiftSys", [{"FONT": _s817["FONT"], "HUM": _s817["HUM"], "HH": _s817["HH"], "cv": _s817["cv"], "fy": _s817["fy"], "rnd": _s817["rnd"], "float": _s817["float"], "toast": _s817["toast"], "say": _s817["say"], "addFear": _s817["addFear"], "noise": _s817["noise"], "spook": _s817["spook"], "W2S": _s817["W2S"], "__getters": {"G": Callable(self, "_f784").bind(_s817), "LV": Callable(self, "_f785").bind(_s817), "FL": Callable(self, "_f786").bind(_s817), "FLN": Callable(self, "_f787").bind(_s817), "IMG": Callable(self, "_f788").bind(_s817), "scene": Callable(self, "_f789").bind(_s817), "paused": Callable(self, "_f790").bind(_s817), "VW": Callable(self, "_f791").bind(_s817), "VH": Callable(self, "_f792").bind(_s817), "TOP": Callable(self, "_f793").bind(_s817), "BOT": Callable(self, "_f794").bind(_s817), "BTNS": Callable(self, "_f795").bind(_s817)}}]) if J.t(J.gp(J.G.get("window"), "LiftSys")) else null)
	var _t5633 = J.G.get("window")
	var _t5634 = _s817["LIFT"]
	J.sp(_t5633, "LIFT", _t5634)
	_s817["UNIT"] = (J.S_window_("UnitSys", [{"FONT": _s817["FONT"], "HH": _s817["HH"], "ITEM": _s817["ITEM"], "BAGMAX": _s817["BAGMAX"], "MV": _s817["MV"], "BLOCKMSG": _s817["BLOCKMSG"], "PH": _s817["PH"], "PHT": _s817["PHT"], "cv": _s817["cv"], "fy": _s817["fy"], "rnd": _s817["rnd"], "float": _s817["float"], "toast": _s817["toast"], "say": _s817["say"], "addFear": _s817["addFear"], "scareRes": _s817["scareRes"], "gpF": _s817["gpF"], "takeItem": _s817["takeItem"], "onArrive": _s817["onArrive"], "unitOf": _s817["unitOf"], "doorBlock": _s817["doorBlock"], "ctxAction": _s817["ctxAction"], "actPress": _s817["actPress"], "gotoNode": _s817["gotoNode"], "noise": _s817["noise"], "checkAlert": _s817["checkAlert"], "crPanel": _s817["crPanel"], "crText": _s817["crText"], "crBtn": _s817["crBtn"], "crBar": _s817["crBar"], "crGet": _s817["crGet"], "crBlit": _s817["crBlit"], "__getters": {"G": Callable(self, "_f796").bind(_s817), "LV": Callable(self, "_f797").bind(_s817), "FL": Callable(self, "_f798").bind(_s817), "FLN": Callable(self, "_f799").bind(_s817), "IMG": Callable(self, "_f800").bind(_s817), "scene": Callable(self, "_f801").bind(_s817), "paused": Callable(self, "_f802").bind(_s817), "VW": Callable(self, "_f803").bind(_s817), "VH": Callable(self, "_f804").bind(_s817), "TOP": Callable(self, "_f805").bind(_s817), "BOT": Callable(self, "_f806").bind(_s817)}}]) if J.t(J.gp(J.G.get("window"), "UnitSys")) else null)
	var _t5635 = J.G.get("window")
	var _t5636 = _s817["UNIT"]
	J.sp(_t5635, "UNIT", _t5636)
	var _t5637 = J.G.get("window")
	var _t5663 = {"gp": Callable(self, "_f807").bind(_s817), "gpRe": Callable(self, "_f809").bind(_s817), "gpF": Callable(self, "_f810").bind(_s817), "end": Callable(self, "_f811").bind(_s817), "sr": Callable(self, "_f812").bind(_s817), "ng": Callable(self, "_f813").bind(_s817), "safe": Callable(self, "_f814").bind(_s817), "inSafe": Callable(self, "_f815").bind(_s817), "inSafeXY": Callable(self, "_f816").bind(_s817), "uq": Callable(self, "_f817").bind(_s817), "cam": Callable(self, "_f818").bind(_s817), "btns": Callable(self, "_f819").bind(_s817), "act": Callable(self, "_f821").bind(_s817), "ctx": Callable(self, "_f822").bind(_s817), "noise": Callable(self, "_f823").bind(_s817), "zoom": Callable(self, "_f824").bind(_s817), "pause": Callable(self, "_f825").bind(_s817), "step": Callable(self, "_f826").bind(_s817), "gate": _s817["gatePress"], "doll": _s817["dollEscape"], "catchG": Callable(self, "_f827").bind(_s817), "ult": _s817["ultPress"], "press": _s817["press"], "tap": _s817["tap"], "goto": Callable(self, "_f828").bind(_s817), "choose": _s817["chooseCard"], "skip": Callable(self, "_f829").bind(_s817), "w2s": Callable(self, "_f832").bind(_s817), "__getters": {"G": Callable(self, "_f830").bind(_s817)}}
	J.sp(_t5637, "TW", _t5663)
	var _t5664 = J.G.get("window")
	var _t5665 = {"draw": Callable(self, "_f833").bind(_s817), "scene": Callable(self, "_f834").bind(_s817), "open": Callable(self, "_f835").bind(_s817), "top": Callable(self, "_f836").bind(_s817), "bot": Callable(self, "_f837").bind(_s817), "resize": _s817["resize"], "unit": _s817["UNIT"], "lift": _s817["LIFT"], "joy": Callable(self, "_f838").bind(_s817), "cr": {"btn": _s817["crBtn"], "panel": _s817["crPanel"], "text": _s817["crText"]}, "press": _s817["press"], "G": Callable(self, "_f839").bind(_s817)}
	J.sp(_t5664, "TWX", _t5665)
	J.S_window_("addEventListener", ["resize", Callable(self, "_f840").bind(_s817)])
	return {"open": v_open_2242, "close": _s817["close"], "__getters": {"on": Callable(self, "_f845").bind(_s817)}}
