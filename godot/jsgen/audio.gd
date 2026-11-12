# 自動轉譯自 audio.js（tools/jsgd.js）——唔好直接改，改原 JS 再轉
extends RefCounted

func run(env):
	var this_ = null; var a = []
	J.G["Sound"] = J.cl(Callable(self, "_f1").bind(env), null, [])

func _f2(this_, a: Array, env):
	var v_AC_38 = null; var v_comp_39 = null; var v_len_40 = null; var v_ir_41 = null; var v_nd_42 = null; var v_c_43 = null; var v_d_44 = null; var v_i_45 = null; var v_i_46 = null
	if J.t(env["ac"]):
		return true
	var _t1 = J.gp(J.G.get("window"), "AudioContext")
	v_AC_38 = (_t1 if J.t(_t1) else J.gp(J.G.get("window"), "webkitAudioContext"))
	if (not J.t(v_AC_38)):
		return false
	var _t2 = J.construct(v_AC_38, [])
	env["ac"] = _t2
	var _t3 = J.mc(env["ac"], "createGain", [])
	env["master"] = _t3
	var _t4 = J.gp(env["master"], "gain")
	var _t5 = (0.9 if J.t(env["on"]) else 0.0)
	J.sp(_t4, "value", _t5)
	J.mc(env["master"], "connect", [J.gp(env["ac"], "destination")])
	v_comp_39 = J.mc(env["ac"], "createDynamicsCompressor", [])
	var _t6 = J.gp(v_comp_39, "threshold")
	var _t7 = (-18.0)
	J.sp(_t6, "value", _t7)
	var _t8 = J.gp(v_comp_39, "ratio")
	J.sp(_t8, "value", 4.0)
	J.mc(v_comp_39, "connect", [env["master"]])
	var _t9 = J.mc(env["ac"], "createGain", [])
	env["music"] = _t9
	var _t10 = J.gp(env["music"], "gain")
	J.sp(_t10, "value", 0.5)
	J.mc(env["music"], "connect", [v_comp_39])
	var _t11 = J.mc(env["ac"], "createGain", [])
	env["sfx"] = _t11
	var _t12 = J.gp(env["sfx"], "gain")
	J.sp(_t12, "value", 0.85)
	J.mc(env["sfx"], "connect", [v_comp_39])
	var _t13 = J.mc(env["ac"], "createConvolver", [])
	env["verb"] = _t13
	v_len_40 = J.mul(J.gp(env["ac"], "sampleRate"), 3.2)
	v_ir_41 = J.mc(env["ac"], "createBuffer", [2.0, v_len_40, J.gp(env["ac"], "sampleRate")])
	v_c_43 = 0.0
	while true:
		if not J.cmp(v_c_43, 2.0, "<"): break
		v_d_44 = J.mc(v_ir_41, "getChannelData", [v_c_43])
		v_i_45 = 0.0
		while true:
			if not J.cmp(v_i_45, v_len_40, "<"): break
			var _t14 = (((randf() * 2.0) - 1.0) * pow(J.num((1.0 - J.div(v_i_45, v_len_40))), J.num(2.6)))
			J.sp(v_d_44, v_i_45, _t14)
			v_i_45 = J.num(v_i_45) + 1.0
		v_c_43 = J.num(v_c_43) + 1.0
	var _t15 = env["verb"]
	J.sp(_t15, "buffer", v_ir_41)
	var _t16 = J.mc(env["ac"], "createGain", [])
	env["verbIn"] = _t16
	var _t17 = J.gp(env["verbIn"], "gain")
	J.sp(_t17, "value", 0.6)
	J.mc(env["verbIn"], "connect", [env["verb"]])
	J.mc(env["verb"], "connect", [v_comp_39])
	var _t18 = J.mc(env["ac"], "createBuffer", [1.0, J.mul(J.gp(env["ac"], "sampleRate"), 2.0), J.gp(env["ac"], "sampleRate")])
	env["noiseBuf"] = _t18
	v_nd_42 = J.mc(env["noiseBuf"], "getChannelData", [0.0])
	v_i_46 = 0.0
	while true:
		if not J.cmp(v_i_46, J.len(v_nd_42), "<"): break
		var _t19 = ((randf() * 2.0) - 1.0)
		J.sp(v_nd_42, v_i_46, _t19)
		v_i_46 = J.num(v_i_46) + 1.0
	return true

func _f3(this_, a: Array, env):
	if (not J.t(J.cl(env["init"], null, []))):
		return null
	var _t20 = J.seq(J.gp(env["ac"], "state"), "suspended")
	var _t21 = (env["on"] if _t20 else _t20)
	if J.t(((not J.t(J.gp(J.G.get("document"), "hidden"))) if J.t(_t21) else _t21)):
		J.mc(env["ac"], "resume", [])
	if J.t(((not J.seq(env["want"], env["mode"])) if J.t(env["want"]) else env["want"])):
		var _t22 = env["setMode"]
		J.cl(_t22, null, [env["want"], true])
	J.cl(env["sync"], null, [])

func _f6(this_, a: Array, env):
	var v_g_52 = null; var v_t_53 = null; var v_a_54 = null; var v_peak_55 = null; var v_d_56 = null
	v_g_52 = J.arg(a, 0)
	v_t_53 = J.arg(a, 1)
	v_a_54 = J.arg(a, 2)
	v_peak_55 = J.arg(a, 3)
	v_d_56 = J.arg(a, 4)
	var _t23 = J.gp(v_g_52, "gain")
	J.mc(_t23, "setValueAtTime", [0.0001, v_t_53])
	var _t24 = J.gp(v_g_52, "gain")
	J.mc(_t24, "exponentialRampToValueAtTime", [v_peak_55, J.add(v_t_53, v_a_54)])
	var _t25 = J.gp(v_g_52, "gain")
	J.mc(_t25, "exponentialRampToValueAtTime", [0.0001, J.add(J.add(v_t_53, v_a_54), v_d_56)])

func _f7(this_, a: Array, env):
	var v_o_59 = null; var v_t_60 = null; var v_osc_61 = null; var v_g_62 = null; var v_last_63 = null; var v_p_64 = null; var v_w_65 = null
	v_o_59 = J.arg(a, 0)
	var _t26 = J.gp(v_o_59, "t")
	v_t_60 = (_t26 if J.t(_t26) else J.cl(env["now"], null, []))
	v_osc_61 = J.mc(env["ac"], "createOscillator", [])
	v_g_62 = J.mc(env["ac"], "createGain", [])
	var _t27 = J.gp(v_o_59, "type")
	var _t28 = (_t27 if J.t(_t27) else "sine")
	J.sp(v_osc_61, "type", _t28)
	var _t29 = J.gp(v_osc_61, "frequency")
	J.mc(_t29, "setValueAtTime", [J.gp(v_o_59, "f"), v_t_60])
	if J.t(J.gp(v_o_59, "f2")):
		var _t30 = J.gp(v_osc_61, "frequency")
		var _t32 = J.gp(v_o_59, "f2")
		var _t31 = J.gp(v_o_59, "slide")
		J.mc(_t30, "exponentialRampToValueAtTime", [_t32, J.add(v_t_60, (_t31 if J.t(_t31) else J.gp(v_o_59, "d")))])
	if J.t(J.gp(v_o_59, "detune")):
		var _t33 = J.gp(v_osc_61, "detune")
		var _t34 = J.gp(v_o_59, "detune")
		J.sp(_t33, "value", _t34)
	var _t35 = env["env"]
	var _t36 = J.gp(v_o_59, "a")
	var _t38 = (_t36 if J.t(_t36) else 0.005)
	var _t37 = J.gp(v_o_59, "v")
	var _t40 = (_t37 if J.t(_t37) else 0.2)
	var _t39 = J.gp(v_o_59, "d")
	J.cl(_t35, null, [v_g_62, v_t_60, _t38, _t40, (_t39 if J.t(_t39) else 0.3)])
	v_last_63 = v_g_62
	if J.t(J.gp(v_o_59, "pan")):
		v_p_64 = J.mc(env["ac"], "createStereoPanner", [])
		var _t41 = J.gp(v_p_64, "pan")
		var _t42 = J.gp(v_o_59, "pan")
		J.sp(_t41, "value", _t42)
		J.mc(v_g_62, "connect", [v_p_64])
		v_last_63 = v_p_64
	J.mc(v_osc_61, "connect", [v_g_62])
	var _t43 = J.gp(v_o_59, "dest")
	J.mc(v_last_63, "connect", [(_t43 if J.t(_t43) else env["sfx"])])
	if J.t(J.gp(v_o_59, "wet")):
		v_w_65 = J.mc(env["ac"], "createGain", [])
		var _t44 = J.gp(v_w_65, "gain")
		var _t45 = J.gp(v_o_59, "wet")
		J.sp(_t44, "value", _t45)
		J.mc(v_last_63, "connect", [v_w_65])
		J.mc(v_w_65, "connect", [env["verbIn"]])
	J.mc(v_osc_61, "start", [v_t_60])
	var _t46 = J.gp(v_o_59, "a")
	var _t48 = J.add(v_t_60, (_t46 if J.t(_t46) else 0.005))
	var _t47 = J.gp(v_o_59, "d")
	J.mc(v_osc_61, "stop", [J.add(J.add(_t48, (_t47 if J.t(_t47) else 0.3)), 0.05)])
	return v_osc_61

func _f8(this_, a: Array, env):
	var v_o_68 = null; var v_t_69 = null; var v_src_70 = null; var v_fl_71 = null; var v_g_72 = null; var v_w_73 = null
	v_o_68 = J.arg(a, 0)
	var _t49 = J.gp(v_o_68, "t")
	v_t_69 = (_t49 if J.t(_t49) else J.cl(env["now"], null, []))
	v_src_70 = J.mc(env["ac"], "createBufferSource", [])
	var _t50 = env["noiseBuf"]
	J.sp(v_src_70, "buffer", _t50)
	J.sp(v_src_70, "loop", true)
	v_fl_71 = J.mc(env["ac"], "createBiquadFilter", [])
	var _t51 = J.gp(v_o_68, "type")
	var _t52 = (_t51 if J.t(_t51) else "bandpass")
	J.sp(v_fl_71, "type", _t52)
	var _t53 = J.gp(v_fl_71, "frequency")
	var _t54 = J.gp(v_o_68, "f")
	J.mc(_t53, "setValueAtTime", [(_t54 if J.t(_t54) else 1000.0), v_t_69])
	if J.t(J.gp(v_o_68, "f2")):
		var _t55 = J.gp(v_fl_71, "frequency")
		J.mc(_t55, "exponentialRampToValueAtTime", [J.gp(v_o_68, "f2"), J.add(v_t_69, J.gp(v_o_68, "d"))])
	var _t56 = J.gp(v_fl_71, "Q")
	var _t57 = J.gp(v_o_68, "q")
	var _t58 = (_t57 if J.t(_t57) else 1.0)
	J.sp(_t56, "value", _t58)
	v_g_72 = J.mc(env["ac"], "createGain", [])
	var _t59 = env["env"]
	var _t60 = J.gp(v_o_68, "a")
	var _t62 = (_t60 if J.t(_t60) else 0.003)
	var _t61 = J.gp(v_o_68, "v")
	var _t64 = (_t61 if J.t(_t61) else 0.2)
	var _t63 = J.gp(v_o_68, "d")
	J.cl(_t59, null, [v_g_72, v_t_69, _t62, _t64, (_t63 if J.t(_t63) else 0.2)])
	J.mc(v_src_70, "connect", [v_fl_71])
	J.mc(v_fl_71, "connect", [v_g_72])
	var _t65 = J.gp(v_o_68, "dest")
	J.mc(v_g_72, "connect", [(_t65 if J.t(_t65) else env["sfx"])])
	if J.t(J.gp(v_o_68, "wet")):
		v_w_73 = J.mc(env["ac"], "createGain", [])
		var _t66 = J.gp(v_w_73, "gain")
		var _t67 = J.gp(v_o_68, "wet")
		J.sp(_t66, "value", _t67)
		J.mc(v_g_72, "connect", [v_w_73])
		J.mc(v_w_73, "connect", [env["verbIn"]])
	J.mc(v_src_70, "start", [v_t_69, randf()])
	var _t68 = J.gp(v_o_68, "a")
	J.mc(v_src_70, "stop", [J.add(J.add(J.add(v_t_69, (_t68 if J.t(_t68) else 0.003)), J.gp(v_o_68, "d")), 0.05)])

func _f10(this_, a: Array, env):
	var v_n_79 = null; var v_e_80 = null
	v_n_79 = J.arg(a, 0)
	if J.t(J.gp(v_n_79, "gain")):
		var _t69 = J.gp(v_n_79, "gain")
		J.mc(_t69, "cancelScheduledValues", [env["t"]])
		var _t70 = J.gp(v_n_79, "gain")
		J.mc(_t70, "setValueAtTime", [J.gp(J.gp(v_n_79, "gain"), "value"), env["t"]])
		var _t71 = J.gp(v_n_79, "gain")
		J.mc(_t71, "linearRampToValueAtTime", [0.0, J.add(env["t"], env["fade"])])

func _f12(this_, a: Array, env):
	var v_n_81 = null; var v_e_82 = null
	v_n_81 = J.arg(a, 0)
	if J.t(J.gp(v_n_81, "stop")):
		J.mc(v_n_81, "stop", [])
	J.mc(v_n_81, "disconnect", [])

func _f11(this_, a: Array, env):
	return J.mc(env["old"], "forEach", [Callable(self, "_f12").bind(env)])

func _f9(this_, a: Array, env):
	var _s20 = {"__p": env, "fade": null, "t": null, "old": null}
	_s20["fade"] = J.arg(a, 0)
	_s20["t"] = J.cl(_s20["__p"]["now"], null, [])
	J.mc(_s20["__p"]["nodes"], "forEach", [Callable(self, "_f10").bind(_s20)])
	_s20["old"] = _s20["__p"]["nodes"]
	var _t72 = []
	_s20["__p"]["nodes"] = _t72
	J.F_setTimeout([Callable(self, "_f11").bind(_s20), (J.mul(_s20["fade"], 1000.0) + 100.0)])
	J.mc(_s20["__p"]["timers"], "forEach", [J.G.get("clearTimeout")])
	var _t73 = []
	_s20["__p"]["timers"] = _t73

func _f14(this_, a: Array, env):
	if (not J.t(env["__p"]["ac"])):
		return null
	J.cl(env["fn"], null, [])
	J.mc(env["__p"]["timers"], "push", [J.F_setTimeout([env["go"], J.mul(J.add(env["min"], (randf() * J.sub(env["max"], env["min"]))), 1000.0)])])

func _f13(this_, a: Array, env):
	var _s31 = {"__p": env, "fn": null, "min": null, "max": null, "go": null}
	_s31["fn"] = J.arg(a, 0)
	_s31["min"] = J.arg(a, 1)
	_s31["max"] = J.arg(a, 2)
	_s31["go"] = Callable(self, "_f14").bind(_s31)
	J.mc(_s31["__p"]["timers"], "push", [J.F_setTimeout([_s31["go"], J.mul(_s31["min"], 500.0)])])

func _f16(this_, a: Array, env):
	var v_f_99 = null; var v_i_100 = null; var v_o_101 = null
	v_f_99 = J.arg(a, 0)
	v_i_100 = J.arg(a, 1)
	v_o_101 = J.mc(env["__p"]["ac"], "createOscillator", [])
	var _t82 = ("sine" if J.seq(v_i_100, 0.0) else "sawtooth")
	J.sp(v_o_101, "type", _t82)
	var _t83 = J.gp(v_o_101, "frequency")
	J.sp(_t83, "value", v_f_99)
	var _t84 = J.gp(v_o_101, "detune")
	var _t85 = (7.0 if J.t(J.mod(v_i_100, 2.0)) else (-6.0))
	J.sp(_t84, "value", _t85)
	J.mc(v_o_101, "connect", [env["lp"]])
	J.mc(v_o_101, "start", [])
	J.mc(env["__p"]["nodes"], "push", [v_o_101])

func _f15(this_, a: Array, env):
	var v_freqs_91 = null; var v_cutoff_92 = null; var v_vol_93 = null; var v_g_94 = null; var v_lfo_96 = null; var v_lg_97 = null; var v_w_98 = null
	var _s33 = {"__p": env, "lp": null}
	v_freqs_91 = J.arg(a, 0)
	v_cutoff_92 = J.arg(a, 1)
	v_vol_93 = J.arg(a, 2)
	v_g_94 = J.mc(_s33["__p"]["ac"], "createGain", [])
	var _t74 = J.gp(v_g_94, "gain")
	J.mc(_t74, "setValueAtTime", [0.0, J.cl(_s33["__p"]["now"], null, [])])
	var _t75 = J.gp(v_g_94, "gain")
	J.mc(_t75, "linearRampToValueAtTime", [v_vol_93, J.add(J.cl(_s33["__p"]["now"], null, []), 3.0)])
	J.mc(v_g_94, "connect", [_s33["__p"]["music"]])
	J.mc(_s33["__p"]["nodes"], "push", [v_g_94])
	_s33["lp"] = J.mc(_s33["__p"]["ac"], "createBiquadFilter", [])
	var _t76 = _s33["lp"]
	J.sp(_t76, "type", "lowpass")
	var _t77 = J.gp(_s33["lp"], "frequency")
	J.sp(_t77, "value", v_cutoff_92)
	var _t78 = J.gp(_s33["lp"], "Q")
	J.sp(_t78, "value", 3.0)
	J.mc(_s33["lp"], "connect", [v_g_94])
	v_lfo_96 = J.mc(_s33["__p"]["ac"], "createOscillator", [])
	v_lg_97 = J.mc(_s33["__p"]["ac"], "createGain", [])
	var _t79 = J.gp(v_lfo_96, "frequency")
	J.sp(_t79, "value", 0.06)
	var _t80 = J.gp(v_lg_97, "gain")
	var _t81 = J.mul(v_cutoff_92, 0.45)
	J.sp(_t80, "value", _t81)
	J.mc(v_lfo_96, "connect", [v_lg_97])
	J.mc(v_lg_97, "connect", [J.gp(_s33["lp"], "frequency")])
	J.mc(v_lfo_96, "start", [])
	J.mc(_s33["__p"]["nodes"], "push", [v_lfo_96])
	J.mc(v_freqs_91, "forEach", [Callable(self, "_f16").bind(_s33)])
	v_w_98 = J.mc(_s33["__p"]["ac"], "createGain", [])
	var _t86 = J.gp(v_w_98, "gain")
	J.sp(_t86, "value", 0.35)
	J.mc(v_g_94, "connect", [v_w_98])
	J.mc(v_w_98, "connect", [_s33["__p"]["verbIn"]])
	J.mc(_s33["__p"]["nodes"], "push", [v_w_98])

func _f17(this_, a: Array, env):
	var v_vol_104 = null; var v_src_105 = null; var v_bp_106 = null; var v_lfo_107 = null; var v_lg_108 = null; var v_g_109 = null
	v_vol_104 = J.arg(a, 0)
	v_src_105 = J.mc(env["ac"], "createBufferSource", [])
	var _t87 = env["noiseBuf"]
	J.sp(v_src_105, "buffer", _t87)
	J.sp(v_src_105, "loop", true)
	v_bp_106 = J.mc(env["ac"], "createBiquadFilter", [])
	J.sp(v_bp_106, "type", "bandpass")
	var _t88 = J.gp(v_bp_106, "frequency")
	J.sp(_t88, "value", 500.0)
	var _t89 = J.gp(v_bp_106, "Q")
	J.sp(_t89, "value", 1.2)
	v_lfo_107 = J.mc(env["ac"], "createOscillator", [])
	v_lg_108 = J.mc(env["ac"], "createGain", [])
	var _t90 = J.gp(v_lfo_107, "frequency")
	J.sp(_t90, "value", 0.045)
	var _t91 = J.gp(v_lg_108, "gain")
	J.sp(_t91, "value", 320.0)
	J.mc(v_lfo_107, "connect", [v_lg_108])
	J.mc(v_lg_108, "connect", [J.gp(v_bp_106, "frequency")])
	J.mc(v_lfo_107, "start", [])
	v_g_109 = J.mc(env["ac"], "createGain", [])
	var _t92 = J.gp(v_g_109, "gain")
	J.mc(_t92, "setValueAtTime", [0.0, J.cl(env["now"], null, [])])
	var _t93 = J.gp(v_g_109, "gain")
	J.mc(_t93, "linearRampToValueAtTime", [v_vol_104, J.add(J.cl(env["now"], null, []), 4.0)])
	J.mc(v_src_105, "connect", [v_bp_106])
	J.mc(v_bp_106, "connect", [v_g_109])
	J.mc(v_g_109, "connect", [env["music"]])
	J.mc(v_src_105, "start", [])
	J.mc(env["nodes"], "push", [v_src_105, v_lfo_107, v_g_109])

func _f19(this_, a: Array, env):
	var v_f1_115 = null; var v_f2_116 = null; var v_t_117 = null; var v_dur_118 = null; var v_v_119 = null; var v_o_120 = null; var v_vib_121 = null; var v_vg_122 = null; var v_bp_123 = null; var v_g_124 = null; var v_w_125 = null
	v_f1_115 = J.arg(a, 0)
	v_f2_116 = J.arg(a, 1)
	v_t_117 = J.arg(a, 2)
	v_dur_118 = J.arg(a, 3)
	v_v_119 = J.arg(a, 4)
	v_o_120 = J.mc(env["ac"], "createOscillator", [])
	J.sp(v_o_120, "type", "sawtooth")
	var _t94 = J.gp(v_o_120, "frequency")
	J.mc(_t94, "setValueAtTime", [v_f1_115, v_t_117])
	var _t95 = J.gp(v_o_120, "frequency")
	J.mc(_t95, "exponentialRampToValueAtTime", [v_f2_116, J.add(v_t_117, J.mul(v_dur_118, 0.8))])
	v_vib_121 = J.mc(env["ac"], "createOscillator", [])
	v_vg_122 = J.mc(env["ac"], "createGain", [])
	var _t96 = J.gp(v_vib_121, "frequency")
	J.sp(_t96, "value", 5.2)
	var _t97 = J.gp(v_vg_122, "gain")
	J.mc(_t97, "setValueAtTime", [0.0, v_t_117])
	var _t98 = J.gp(v_vg_122, "gain")
	J.mc(_t98, "linearRampToValueAtTime", [J.mul(v_f1_115, 0.018), J.add(v_t_117, J.mul(v_dur_118, 0.5))])
	J.mc(v_vib_121, "connect", [v_vg_122])
	J.mc(v_vg_122, "connect", [J.gp(v_o_120, "frequency")])
	v_bp_123 = J.mc(env["ac"], "createBiquadFilter", [])
	J.sp(v_bp_123, "type", "bandpass")
	var _t99 = J.gp(v_bp_123, "frequency")
	J.sp(_t99, "value", 1100.0)
	var _t100 = J.gp(v_bp_123, "Q")
	J.sp(_t100, "value", 2.2)
	v_g_124 = J.mc(env["ac"], "createGain", [])
	var _t101 = J.gp(v_g_124, "gain")
	J.mc(_t101, "setValueAtTime", [0.0001, v_t_117])
	var _t102 = J.gp(v_g_124, "gain")
	J.mc(_t102, "exponentialRampToValueAtTime", [v_v_119, J.add(v_t_117, 0.35)])
	var _t103 = J.gp(v_g_124, "gain")
	J.mc(_t103, "setValueAtTime", [v_v_119, J.sub(J.add(v_t_117, v_dur_118), 0.5)])
	var _t104 = J.gp(v_g_124, "gain")
	J.mc(_t104, "exponentialRampToValueAtTime", [0.0001, J.add(v_t_117, v_dur_118)])
	J.mc(v_o_120, "connect", [v_bp_123])
	J.mc(v_bp_123, "connect", [v_g_124])
	J.mc(v_g_124, "connect", [env["music"]])
	v_w_125 = J.mc(env["ac"], "createGain", [])
	var _t105 = J.gp(v_w_125, "gain")
	J.sp(_t105, "value", 0.8)
	J.mc(v_g_124, "connect", [v_w_125])
	J.mc(v_w_125, "connect", [env["verbIn"]])
	J.mc(v_o_120, "start", [v_t_117])
	J.mc(v_vib_121, "start", [v_t_117])
	J.mc(v_o_120, "stop", [J.add(J.add(v_t_117, v_dur_118), 0.1)])
	J.mc(v_vib_121, "stop", [J.add(J.add(v_t_117, v_dur_118), 0.1)])

func _f21(this_, a: Array, env):
	var v_m_131 = null; var v_i_132 = null
	v_m_131 = J.arg(a, 0)
	v_i_132 = J.arg(a, 1)
	var _t107 = env["__p"]["tone"]
	return J.cl(_t107, null, [{"f": J.mul(env["f"], v_m_131), "t": env["t"], "a": 0.004, "d": J.div(4.5, J.add(v_i_132, 1.0)), "v": J.div(env["v"], J.add(v_i_132, 1.2)), "dest": env["__p"]["music"], "wet": 1.0}])

func _f20(this_, a: Array, env):
	var _s38 = {"__p": env, "f": null, "t": null, "v": null}
	_s38["f"] = J.arg(a, 0)
	_s38["t"] = J.arg(a, 1)
	_s38["v"] = J.arg(a, 2)
	var _t106 = [1.0, 2.76, 5.4, 8.93]
	J.mc(_t106, "forEach", [Callable(self, "_f21").bind(_s38)])

func _f22(this_, a: Array, env):
	var v_t_135 = null; var v_v_136 = null
	v_t_135 = J.arg(a, 0)
	v_v_136 = J.arg(a, 1)
	var _t108 = env["tone"]
	J.cl(_t108, null, [{"f": 120.0, "f2": 48.0, "slide": 0.25, "t": v_t_135, "d": 0.45, "v": (v_v_136 if J.t(v_v_136) else 0.5), "dest": env["music"]}])
	var _t109 = env["noise"]
	J.cl(_t109, null, [{"t": v_t_135, "d": 0.06, "type": "lowpass", "f": 900.0, "v": J.mul((v_v_136 if J.t(v_v_136) else 0.5), 0.4), "dest": env["music"]}])

func _f34(this_, a: Array, env):
	var v_m_168 = null; var v_force_169 = null
	v_m_168 = J.arg(a, 0)
	v_force_169 = J.arg(a, 1)
	env["want"] = v_m_168
	var _t110 = (not J.t(env["ac"]))
	if (_t110 if _t110 else (not J.seq(J.gp(env["ac"], "state"), "running"))):
		return null
	var _t111 = J.seq(v_m_168, env["mode"])
	if ((not J.t(v_force_169)) if _t111 else _t111):
		return null
	var _t112 = env["stopAll"]
	J.cl(_t112, null, [1.2])
	env["mode"] = v_m_168
	var _t113 = J.gp(env["MODES"], v_m_168)
	J.cl((_t113 if J.t(_t113) else J.gp(env["MODES"], "silent")), null, [])

func _f64(this_, a: Array, env):
	var v_name_258 = null; var v_a_259 = null; var v_e_260 = null
	v_name_258 = J.arg(a, 0)
	v_a_259 = a.slice(1)
	var _t114 = (not J.t(env["ac"]))
	var _t115 = (_t114 if _t114 else (not J.t(env["on"])))
	if (_t115 if _t115 else (not J.seq(J.gp(env["ac"], "state"), "running"))):
		return null
	if J.t(J.gp(env["S"], v_name_258)):
		var _t116 = env["S"]
		J.mc(_t116, v_name_258, J.spread([J.SP(v_a_259)]))

func _f65(this_, a: Array, env):
	var v_want_263 = null; var v_e_264 = null
	if (not J.t(env["ac"])):
		return null
	var _t118 = env["on"]
	if J.t(_t118):
		var _t117 = (not J.seq(J.typeof_(J.G.get("document")), "undefined"))
		_t118 = (not J.t((J.gp(J.G.get("document"), "hidden") if _t117 else _t117)))
	v_want_263 = _t118
	if J.t((J.seq(J.gp(env["ac"], "state"), "suspended") if J.t(v_want_263) else v_want_263)):
		J.mc(env["ac"], "resume", [])
	else:
		var _t119 = (not J.t(v_want_263))
		if (J.seq(J.gp(env["ac"], "state"), "running") if _t119 else _t119):
			J.mc(env["ac"], "suspend", [])

func _f66(this_, a: Array, env):
	var v_e_267 = null
	env["on"] = (not J.t(env["on"]))
	J.S_localStorage_("setItem", ["gb_sound", ("1" if J.t(env["on"]) else "0")])
	if J.t(env["ac"]):
		var _t120 = J.gp(env["master"], "gain")
		J.mc(_t120, "setTargetAtTime", [(0.9 if J.t(env["on"]) else 0.0), J.cl(env["now"], null, []), 0.05])
		if J.t(env["on"]):
			J.cl(env["sync"], null, [])
		else:
			J.F_setTimeout([env["sync"], 150.0])
	return env["on"]

func _f4(this_, a: Array, env):
	var v_ev_49 = null
	v_ev_49 = J.arg(a, 0)
	return J.S_window_("addEventListener", [v_ev_49, env["unlock"], {"passive": true}])

func _f5(this_, a: Array, env):
	return J.gp(env["ac"], "currentTime")

func _f18(this_, a: Array, env):
	var v_f_110 = null; var v_t_111 = null; var v_v_112 = null
	v_f_110 = J.arg(a, 0)
	v_t_111 = J.arg(a, 1)
	v_v_112 = J.arg(a, 2)
	var _t123 = env["tone"]
	J.cl(_t123, null, [{"f": v_f_110, "t": v_t_111, "d": 2.6, "v": (v_v_112 if J.t(v_v_112) else 0.07), "dest": env["music"], "wet": 0.9, "detune": (-18.0)}])
	var _t124 = env["tone"]
	J.cl(_t124, null, [{"f": J.mul(v_f_110, 2.0), "t": v_t_111, "d": 1.2, "v": J.mul((v_v_112 if J.t(v_v_112) else 0.07), 0.35), "dest": env["music"], "wet": 0.9, "detune": (-12.0)}])

func _f24(this_, a: Array, env):
	var v_t_139 = null; var v_i_140 = null
	v_t_139 = J.add(J.cl(env["now"], null, []), 0.05)
	v_i_140 = floor(J.num((randf() * J.len(env["SCALE"]))))
	var _t128 = env["musicBox"]
	J.cl(_t128, null, [J.mul(J.gp(env["SCALE"], v_i_140), 2.0), v_t_139])
	if (randf() < 0.4):
		var _t129 = env["musicBox"]
		J.cl(_t129, null, [J.mul(J.gp(env["SCALE"], J.mod(J.add(v_i_140, 2.0), J.len(env["SCALE"]))), 2.0), J.add(v_t_139, 0.45), 0.05])

func _f25(this_, a: Array, env):
	var v_t_141 = null
	v_t_141 = J.add(J.cl(env["now"], null, []), 0.1)
	if (randf() < 0.5):
		var _t131 = env["bell"]
		J.cl(_t131, null, [146.83, v_t_141, 0.09])
	else:
		var _t132 = env["erhu"]
		J.cl(_t132, null, [440.0, 349.23, v_t_141, 2.6, 0.05])

func _f23(this_, a: Array, env):
	var _t125 = env["drone"]
	J.cl(_t125, null, [[36.71, 73.42, 110.3], 320.0, 0.16])
	var _t126 = env["wind"]
	J.cl(_t126, null, [0.05])
	var _t127 = env["every"]
	J.cl(_t127, null, [Callable(self, "_f24").bind(env), 2.4, 4.8])
	var _t130 = env["every"]
	J.cl(_t130, null, [Callable(self, "_f25").bind(env), 11.0, 19.0])

func _f27(this_, a: Array, env):
	var _t136 = env["bell"]
	return J.cl(_t136, null, [110.0, J.add(J.cl(env["now"], null, []), 0.1), 0.06])

func _f26(this_, a: Array, env):
	var _t133 = env["drone"]
	J.cl(_t133, null, [[36.71, 73.42], 260.0, 0.12])
	var _t134 = env["wind"]
	J.cl(_t134, null, [0.03])
	var _t135 = env["every"]
	J.cl(_t135, null, [Callable(self, "_f27").bind(env), 9.0, 16.0])

func _f29(this_, a: Array, env):
	env["k"] = J.num(env["k"]) + 1.0
	var _t141 = env["__p"]["tone"]
	J.cl(_t141, null, [{"f": (2400.0 if J.t(J.mod(env["k"], 2.0)) else 2100.0), "t": J.add(J.cl(env["__p"]["now"], null, []), 0.02), "d": 0.03, "v": 0.035, "dest": env["__p"]["music"], "wet": 0.3}])

func _f28(this_, a: Array, env):
	var v_o_146 = null; var v_lp_147 = null; var v_g_148 = null
	var _s46 = {"__p": env, "k": null}
	v_o_146 = J.mc(_s46["__p"]["ac"], "createOscillator", [])
	J.sp(v_o_146, "type", "sawtooth")
	var _t137 = J.gp(v_o_146, "frequency")
	J.sp(_t137, "value", 50.0)
	v_lp_147 = J.mc(_s46["__p"]["ac"], "createBiquadFilter", [])
	J.sp(v_lp_147, "type", "lowpass")
	var _t138 = J.gp(v_lp_147, "frequency")
	J.sp(_t138, "value", 180.0)
	v_g_148 = J.mc(_s46["__p"]["ac"], "createGain", [])
	var _t139 = J.gp(v_g_148, "gain")
	J.sp(_t139, "value", 0.025)
	J.mc(v_o_146, "connect", [v_lp_147])
	J.mc(v_lp_147, "connect", [v_g_148])
	J.mc(v_g_148, "connect", [_s46["__p"]["music"]])
	J.mc(v_o_146, "start", [])
	J.mc(_s46["__p"]["nodes"], "push", [v_o_146, v_g_148])
	_s46["k"] = 0.0
	var _t140 = _s46["__p"]["every"]
	J.cl(_t140, null, [Callable(self, "_f29").bind(_s46), 1.0, 1.0])

func _f32(this_, a: Array, env):
	var v_b_161 = null; var v_v_162 = null
	var _t143 = J.gp(J.arg(a, 0), 0.0)
	v_b_161 = _t143
	var _t144 = J.gp(J.arg(a, 0), 1.0)
	v_v_162 = _t144
	var _t145 = env["__p"]["__p"]["taiko"]
	var _t147 = J.add(env["t"], J.mul(v_b_161, env["__p"]["beat"]))
	var _t146 = J.seq(J.mod(env["__p"]["n"], 4.0), 3.0)
	return J.cl(_t145, null, [_t147, J.mul(v_v_162, (1.4 if (J.seq(v_b_161, 3.5) if _t146 else _t146) else 1.0))])

func _f31(this_, a: Array, env):
	var v_s_163 = null
	var _s49 = {"__p": env, "t": null}
	if (not J.t(_s49["__p"]["__p"]["ac"])):
		return null
	_s49["t"] = J.add(_s49["__p"]["t0"], J.mul(_s49["__p"]["n"], _s49["__p"]["bar"]))
	J.mc(_s49["__p"]["pat"], "forEach", [Callable(self, "_f32").bind(_s49)])
	v_s_163 = 0.0
	while true:
		if not J.cmp(v_s_163, 8.0, "<"): break
		if (randf() < 0.55):
			var _t148 = J.max_([0.0, J.min_([(J.len(_s49["__p"]["__p"]["SCALE"]) - 1.0), J.add(_s49["__p"]["note"], J.gp([(-2.0), (-1.0), 1.0, 2.0], floor(J.num((randf() * 4.0)))))])])
			_s49["__p"]["note"] = _t148
			var _t149 = _s49["__p"]["__p"]["tone"]
			J.cl(_t149, null, [{"f": J.mul(J.gp(_s49["__p"]["__p"]["SCALE"], _s49["__p"]["note"]), 2.0), "type": "triangle", "t": J.add(_s49["t"], J.div(J.mul(v_s_163, _s49["__p"]["beat"]), 2.0)), "d": 0.35, "v": 0.06, "dest": _s49["__p"]["__p"]["music"], "wet": 0.4}])
		v_s_163 = J.num(v_s_163) + 1.0
	var _t150 = _s49["__p"]["__p"]["tone"]
	J.cl(_t150, null, [{"f": 73.42, "type": "triangle", "t": _s49["t"], "d": J.mul(_s49["__p"]["beat"], 1.6), "v": 0.12, "dest": _s49["__p"]["__p"]["music"]}])
	var _t151 = _s49["__p"]["__p"]["tone"]
	J.cl(_t151, null, [{"f": (87.31 if J.t(J.mod(_s49["__p"]["n"], 2.0)) else 65.41), "type": "triangle", "t": J.add(_s49["t"], J.mul(_s49["__p"]["beat"], 2.0)), "d": J.mul(_s49["__p"]["beat"], 1.6), "v": 0.1, "dest": _s49["__p"]["__p"]["music"]}])
	if J.seq(J.mod(_s49["__p"]["n"], 4.0), 0.0):
		var _t152 = _s49["__p"]["__p"]["noise"]
		J.cl(_t152, null, [{"t": _s49["t"], "d": 1.4, "type": "highpass", "f": 6000.0, "v": 0.05, "dest": _s49["__p"]["__p"]["music"], "wet": 0.6, "a": 0.01}])
	_s49["__p"]["n"] = J.num(_s49["__p"]["n"]) + 1.0
	J.mc(_s49["__p"]["__p"]["timers"], "push", [J.F_setTimeout([_s49["__p"]["schedule"], J.max_([10.0, ((J.sub(J.add(_s49["__p"]["t0"], J.mul(_s49["__p"]["n"], _s49["__p"]["bar"])), J.cl(_s49["__p"]["__p"]["now"], null, [])) - 0.25) * 1000.0)])])])

func _f30(this_, a: Array, env):
	var v_bpm_152 = null
	var _s48 = {"__p": env, "beat": null, "bar": null, "t0": null, "n": null, "pat": null, "note": null, "schedule": null}
	var _t142 = _s48["__p"]["drone"]
	J.cl(_t142, null, [[36.71, 73.42], 420.0, 0.11])
	v_bpm_152 = 108.0
	_s48["beat"] = J.div(60.0, v_bpm_152)
	_s48["bar"] = J.mul(_s48["beat"], 4.0)
	_s48["t0"] = J.add(J.cl(_s48["__p"]["now"], null, []), 0.15)
	_s48["n"] = 0.0
	_s48["pat"] = [[0.0, 0.55], [1.5, 0.35], [2.0, 0.5], [3.5, 0.3]]
	_s48["note"] = 4.0
	_s48["schedule"] = Callable(self, "_f31").bind(_s48)
	J.cl(_s48["schedule"], null, [])

func _f33(this_, a: Array, env):
	pass

func _f35(this_, a: Array, env):
	var v_t_172 = null
	v_t_172 = J.cl(env["now"], null, [])
	var _t153 = env["noise"]
	J.cl(_t153, null, [{"t": v_t_172, "d": 0.09, "f": 1700.0, "q": 1.4, "v": 0.45}])
	var _t154 = env["tone"]
	J.cl(_t154, null, [{"f": 150.0, "f2": 55.0, "t": v_t_172, "d": 0.16, "v": 0.5}])
	var _t155 = env["tone"]
	J.cl(_t155, null, [{"f": 420.0, "f2": 300.0, "t": v_t_172, "d": 0.05, "v": 0.12, "type": "triangle"}])

func _f36(this_, a: Array, env):
	var v_t_175 = null
	v_t_175 = J.cl(env["now"], null, [])
	var _t156 = env["noise"]
	J.cl(_t156, null, [{"t": v_t_175, "d": 0.7, "type": "lowpass", "f": 900.0, "f2": 200.0, "v": 0.35, "a": 0.05}])
	var _t157 = env["tone"]
	J.cl(_t157, null, [{"f": 90.0, "f2": 40.0, "t": J.add(v_t_175, 0.5), "d": 0.4, "v": 0.5}])

func _f38(this_, a: Array, env):
	var v_t_181 = null; var v_o_182 = null; var v_fm_183 = null; var v_fg_184 = null; var v_bp_185 = null; var v_g_186 = null; var v_p_187 = null; var v_w_188 = null
	v_t_181 = J.arg(a, 0)
	v_o_182 = J.mc(env["__p"]["ac"], "createOscillator", [])
	J.sp(v_o_182, "type", "sawtooth")
	var _t158 = J.gp(v_o_182, "frequency")
	J.mc(_t158, "setValueAtTime", [560.0, v_t_181])
	var _t159 = J.gp(v_o_182, "frequency")
	J.mc(_t159, "exponentialRampToValueAtTime", [400.0, J.add(v_t_181, 0.24)])
	v_fm_183 = J.mc(env["__p"]["ac"], "createOscillator", [])
	v_fg_184 = J.mc(env["__p"]["ac"], "createGain", [])
	var _t160 = J.gp(v_fm_183, "frequency")
	J.sp(_t160, "value", 38.0)
	var _t161 = J.gp(v_fg_184, "gain")
	J.sp(_t161, "value", 140.0)
	J.mc(v_fm_183, "connect", [v_fg_184])
	J.mc(v_fg_184, "connect", [J.gp(v_o_182, "frequency")])
	v_bp_185 = J.mc(env["__p"]["ac"], "createBiquadFilter", [])
	J.sp(v_bp_185, "type", "bandpass")
	var _t162 = J.gp(v_bp_185, "frequency")
	J.sp(_t162, "value", 1500.0)
	var _t163 = J.gp(v_bp_185, "Q")
	J.sp(_t163, "value", 3.0)
	v_g_186 = J.mc(env["__p"]["ac"], "createGain", [])
	var _t164 = env["__p"]["env"]
	J.cl(_t164, null, [v_g_186, v_t_181, 0.015, 0.16, 0.24])
	v_p_187 = J.mc(env["__p"]["ac"], "createStereoPanner", [])
	var _t165 = J.gp(v_p_187, "pan")
	var _t166 = (env["pan"] if J.t(env["pan"]) else 0.0)
	J.sp(_t165, "value", _t166)
	J.mc(v_o_182, "connect", [v_bp_185])
	J.mc(v_bp_185, "connect", [v_g_186])
	J.mc(v_g_186, "connect", [v_p_187])
	J.mc(v_p_187, "connect", [env["__p"]["sfx"]])
	v_w_188 = J.mc(env["__p"]["ac"], "createGain", [])
	var _t167 = J.gp(v_w_188, "gain")
	J.sp(_t167, "value", 0.5)
	J.mc(v_p_187, "connect", [v_w_188])
	J.mc(v_w_188, "connect", [env["__p"]["verbIn"]])
	J.mc(v_o_182, "start", [v_t_181])
	J.mc(v_fm_183, "start", [v_t_181])
	J.mc(v_o_182, "stop", [J.add(v_t_181, 0.32)])
	J.mc(v_fm_183, "stop", [J.add(v_t_181, 0.32)])

func _f37(this_, a: Array, env):
	var v_caw_179 = null; var v_t_180 = null; var v_i_189 = null
	var _s57 = {"__p": env, "pan": null}
	_s57["pan"] = J.arg(a, 0)
	v_caw_179 = Callable(self, "_f38").bind(_s57)
	v_t_180 = J.add(J.cl(_s57["__p"]["now"], null, []), (randf() * 0.06))
	J.cl(v_caw_179, null, [v_t_180])
	if (randf() < 0.7):
		J.cl(v_caw_179, null, [J.add(v_t_180, 0.3)])
	v_i_189 = 0.0
	while true:
		if not J.cmp(v_i_189, 5.0, "<"): break
		var _t168 = _s57["__p"]["noise"]
		J.cl(_t168, null, [{"t": J.add(v_t_180, J.mul(v_i_189, 0.07)), "d": 0.05, "type": "bandpass", "f": 900.0, "q": 0.8, "v": 0.06}])
		v_i_189 = J.num(v_i_189) + 1.0

func _f39(this_, a: Array, env):
	var _t169 = env["noise"]
	J.cl(_t169, null, [{"d": 0.32, "f": 3200.0, "f2": 700.0, "q": 0.9, "v": 0.32, "a": 0.02}])

func _f41(this_, a: Array, env):
	var v_d_195 = null
	v_d_195 = J.arg(a, 0)
	var _t171 = env["__p"]["tone"]
	J.cl(_t171, null, [{"f": 330.0, "f2": 180.0, "t": J.add(env["t"], v_d_195), "d": 0.08, "v": 0.35, "type": "triangle"}])
	var _t172 = env["__p"]["noise"]
	J.cl(_t172, null, [{"t": J.add(env["t"], v_d_195), "d": 0.03, "f": 2500.0, "v": 0.2}])

func _f40(this_, a: Array, env):
	var _s61 = {"__p": env, "t": null}
	_s61["t"] = J.cl(_s61["__p"]["now"], null, [])
	var _t170 = [0.0, 0.13]
	J.mc(_t170, "forEach", [Callable(self, "_f41").bind(_s61)])

func _f42(this_, a: Array, env):
	var v_t_198 = null
	v_t_198 = J.cl(env["now"], null, [])
	var _t173 = env["tone"]
	J.cl(_t173, null, [{"f": 1320.0, "t": v_t_198, "d": 0.35, "v": 0.12, "wet": 0.3}])
	var _t174 = env["tone"]
	J.cl(_t174, null, [{"f": 1980.0, "t": J.add(v_t_198, 0.06), "d": 0.4, "v": 0.1, "wet": 0.3}])

func _f43(this_, a: Array, env):
	var v_t_201 = null; var v_i_202 = null
	v_t_201 = J.cl(env["now"], null, [])
	v_i_202 = 0.0
	while true:
		if not J.cmp(v_i_202, 3.0, "<"): break
		var _t175 = env["tone"]
		J.cl(_t175, null, [{"f": 220.0, "f2": 110.0, "t": J.add(v_t_201, J.mul(v_i_202, 0.16)), "d": 0.09, "v": 0.4, "type": "triangle"}])
		var _t176 = env["noise"]
		J.cl(_t176, null, [{"t": J.add(v_t_201, J.mul(v_i_202, 0.16)), "d": 0.04, "f": 1800.0, "v": 0.25}])
		v_i_202 = J.num(v_i_202) + 1.0

func _f45(this_, a: Array, env):
	var v_m_206 = null; var v_i_207 = null
	v_m_206 = J.arg(a, 0)
	v_i_207 = J.arg(a, 1)
	var _t178 = env["__p"]["tone"]
	return J.cl(_t178, null, [{"f": J.mul(98.0, v_m_206), "f2": J.mul(96.0, v_m_206), "t": env["t"], "a": 0.01, "d": J.div(3.2, (J.mul(v_i_207, 0.5) + 1.0)), "v": J.div(0.18, J.add(v_i_207, 1.0)), "wet": 0.9}])

func _f44(this_, a: Array, env):
	var _s67 = {"__p": env, "t": null}
	_s67["t"] = J.cl(_s67["__p"]["now"], null, [])
	var _t177 = [1.0, 1.48, 2.02, 2.76, 3.9]
	J.mc(_t177, "forEach", [Callable(self, "_f45").bind(_s67)])
	var _t179 = _s67["__p"]["noise"]
	J.cl(_t179, null, [{"t": _s67["t"], "d": 0.05, "type": "lowpass", "f": 600.0, "v": 0.3}])

func _f47(this_, a: Array, env):
	var v_k_211 = null; var v_i_212 = null
	v_k_211 = J.arg(a, 0)
	v_i_212 = J.arg(a, 1)
	var _t181 = env["__p"]["musicBox"]
	return J.cl(_t181, null, [J.mul(J.gp(env["__p"]["SCALE"], J.min_([8.0, J.add(v_k_211, 1.0)])), 2.0), J.add(J.add(env["t"], 0.25), J.mul(v_i_212, 0.12)), 0.09])

func _f46(this_, a: Array, env):
	var _s69 = {"__p": env, "t": null}
	J.mc(this_, "gong", [])
	_s69["t"] = J.cl(_s69["__p"]["now"], null, [])
	var _t180 = [0.0, 2.0, 4.0, 7.0]
	J.mc(_t180, "forEach", [Callable(self, "_f47").bind(_s69)])

func _f48(this_, a: Array, env):
	var _t182 = env["tone"]
	J.cl(_t182, null, [{"f": 1700.0, "d": 0.025, "v": 0.06, "type": "triangle"}])

func _f49(this_, a: Array, env):
	var _t183 = env["noise"]
	J.cl(_t183, null, [{"d": 0.12, "type": "highpass", "f": 2500.0, "v": 0.12, "a": 0.01}])

func _f50(this_, a: Array, env):
	var v_t_219 = null
	v_t_219 = J.cl(env["now"], null, [])
	var _t184 = env["tone"]
	J.cl(_t184, null, [{"f": 880.0, "t": v_t_219, "d": 0.09, "v": 0.13}])
	var _t185 = env["tone"]
	J.cl(_t185, null, [{"f": 1318.0, "t": J.add(v_t_219, 0.09), "d": 0.16, "v": 0.13}])

func _f51(this_, a: Array, env):
	var _t186 = env["noise"]
	J.cl(_t186, null, [{"d": 0.14, "type": "highpass", "f": 1500.0, "f2": 5000.0, "v": 0.12, "a": 0.01}])
	var _t187 = env["tone"]
	J.cl(_t187, null, [{"f": 1046.0, "d": 0.06, "v": 0.05}])

func _f52(this_, a: Array, env):
	var _t188 = env["tone"]
	J.cl(_t188, null, [{"f": (2600.0 + (randf() * 600.0)), "d": 0.015, "v": 0.03, "type": "square"}])

func _f53(this_, a: Array, env):
	var v_t_226 = null
	v_t_226 = J.cl(env["now"], null, [])
	var _t189 = env["tone"]
	J.cl(_t189, null, [{"f": 1568.0, "t": v_t_226, "d": 0.12, "v": 0.06, "type": "square"}])
	var _t190 = env["tone"]
	J.cl(_t190, null, [{"f": 2093.0, "t": J.add(v_t_226, 0.08), "d": 0.16, "v": 0.06, "type": "square"}])

func _f54(this_, a: Array, env):
	var v_t_229 = null
	v_t_229 = J.cl(env["now"], null, [])
	var _t191 = env["noise"]
	J.cl(_t191, null, [{"t": v_t_229, "d": 0.07, "type": "lowpass", "f": 1200.0, "v": 0.35}])
	var _t192 = env["tone"]
	J.cl(_t192, null, [{"f": 110.0, "f2": 55.0, "t": v_t_229, "d": 0.1, "v": 0.35}])

func _f55(this_, a: Array, env):
	var v_t_232 = null
	v_t_232 = J.cl(env["now"], null, [])
	var _t193 = env["noise"]
	J.cl(_t193, null, [{"t": v_t_232, "d": 0.35, "f": 400.0, "f2": 3000.0, "q": 2.0, "v": 0.25, "a": 0.05}])
	var _t194 = env["tone"]
	J.cl(_t194, null, [{"f": 880.0, "t": J.add(v_t_232, 0.25), "d": 0.8, "v": 0.08, "wet": 0.8}])

func _f56(this_, a: Array, env):
	var v_n_235 = null; var v_t_236 = null; var v_i_237 = null
	v_n_235 = J.arg(a, 0)
	v_t_236 = J.cl(env["now"], null, [])
	v_i_237 = 0.0
	while true:
		if not J.cmp(v_i_237, 3.0, "<"): break
		var _t195 = env["tone"]
		J.cl(_t195, null, [{"f": J.mul(J.gp(env["SCALE"], J.min_([8.0, J.add(J.add(3.0, v_i_237), J.mod((v_n_235 if J.t(v_n_235) else 0.0), 3.0))])), 2.0), "type": "triangle", "t": J.add(v_t_236, J.mul(v_i_237, 0.06)), "d": 0.2, "v": 0.1}])
		v_i_237 = J.num(v_i_237) + 1.0

func _f58(this_, a: Array, env):
	var v_k_241 = null; var v_i_242 = null
	v_k_241 = J.arg(a, 0)
	v_i_242 = J.arg(a, 1)
	var _t197 = env["__p"]["musicBox"]
	return J.cl(_t197, null, [J.mul(J.gp(env["__p"]["SCALE"], v_k_241), 2.0), J.add(J.add(env["t"], 0.4), J.mul(v_i_242, 0.18)), 0.1])

func _f57(this_, a: Array, env):
	var _s81 = {"__p": env, "t": null}
	J.mc(this_, "gong", [])
	_s81["t"] = J.cl(_s81["__p"]["now"], null, [])
	var _t196 = [4.0, 5.0, 6.0, 8.0]
	J.mc(_t196, "forEach", [Callable(self, "_f58").bind(_s81)])

func _f59(this_, a: Array, env):
	var _t198 = env["erhu"]
	J.cl(_t198, null, [392.0, 196.0, J.add(J.cl(env["now"], null, []), 0.05), 2.4, 0.09])
	var _t199 = env["bell"]
	J.cl(_t199, null, [73.42, J.add(J.cl(env["now"], null, []), 0.1), 0.12])

func _f60(this_, a: Array, env):
	var v_t_247 = null
	v_t_247 = J.cl(env["now"], null, [])
	var _t200 = env["tone"]
	J.cl(_t200, null, [{"f": 180.0, "f2": 320.0, "t": v_t_247, "d": 0.35, "v": 0.15, "type": "sawtooth"}])
	J.mc(this_, "coin", [])

func _f61(this_, a: Array, env):
	var v_t_250 = null
	v_t_250 = J.cl(env["now"], null, [])
	var _t201 = env["tone"]
	J.cl(_t201, null, [{"f": 988.0, "t": v_t_250, "a": 0.01, "d": 3.2, "v": 0.09, "type": "sine"}])

func _f62(this_, a: Array, env):
	var v_t_253 = null
	v_t_253 = J.cl(env["now"], null, [])
	var _t202 = env["tone"]
	J.cl(_t202, null, [{"f": 60.0, "f2": 40.0, "t": v_t_253, "d": 0.12, "v": 0.5}])
	var _t203 = env["tone"]
	J.cl(_t203, null, [{"f": 55.0, "f2": 38.0, "t": J.add(v_t_253, 0.22), "d": 0.12, "v": 0.35}])

func _f63(this_, a: Array, env):
	var _t204 = env["noise"]
	J.cl(_t204, null, [{"d": 0.5, "f": 300.0, "f2": 2500.0, "q": 1.5, "v": 0.2, "a": 0.15}])

func _f67(this_, a: Array, env):
	return env["on"]

func _f1(this_, a: Array, env):
	var v_play_32 = null; var v_toggle_34 = null; var v_e_35 = null
	var _s2 = {"__p": env, "ac": null, "master": null, "music": null, "sfx": null, "verb": null, "verbIn": null, "noiseBuf": null, "mode": null, "want": null, "nodes": null, "timers": null, "on": null, "SCALE": null, "init": null, "unlock": null, "now": null, "env": null, "tone": null, "noise": null, "stopAll": null, "every": null, "drone": null, "wind": null, "musicBox": null, "erhu": null, "bell": null, "taiko": null, "MODES": null, "setMode": null, "S": null, "sync": null}
	_s2["init"] = Callable(self, "_f2").bind(_s2)
	_s2["unlock"] = Callable(self, "_f3").bind(_s2)
	_s2["env"] = Callable(self, "_f6").bind(_s2)
	_s2["tone"] = Callable(self, "_f7").bind(_s2)
	_s2["noise"] = Callable(self, "_f8").bind(_s2)
	_s2["stopAll"] = Callable(self, "_f9").bind(_s2)
	_s2["every"] = Callable(self, "_f13").bind(_s2)
	_s2["drone"] = Callable(self, "_f15").bind(_s2)
	_s2["wind"] = Callable(self, "_f17").bind(_s2)
	_s2["erhu"] = Callable(self, "_f19").bind(_s2)
	_s2["bell"] = Callable(self, "_f20").bind(_s2)
	_s2["taiko"] = Callable(self, "_f22").bind(_s2)
	_s2["setMode"] = Callable(self, "_f34").bind(_s2)
	v_play_32 = Callable(self, "_f64").bind(_s2)
	_s2["sync"] = Callable(self, "_f65").bind(_s2)
	v_toggle_34 = Callable(self, "_f66").bind(_s2)
	_s2["ac"] = null
	_s2["master"] = null
	_s2["music"] = null
	_s2["sfx"] = null
	_s2["verb"] = null
	_s2["verbIn"] = null
	_s2["noiseBuf"] = null
	_s2["mode"] = null
	_s2["want"] = null
	_s2["nodes"] = []
	_s2["timers"] = []
	_s2["on"] = true
	var _t121 = (not J.seq(J.S_localStorage_("getItem", ["gb_sound"]), "0"))
	_s2["on"] = _t121
	_s2["SCALE"] = [146.83, 174.61, 196.0, 220.0, 261.63, 293.66, 349.23, 392.0, 440.0]
	var _t122 = ["pointerdown", "keydown", "touchstart"]
	J.mc(_t122, "forEach", [Callable(self, "_f4").bind(_s2)])
	_s2["now"] = Callable(self, "_f5").bind(_s2)
	_s2["musicBox"] = Callable(self, "_f18").bind(_s2)
	_s2["MODES"] = {"village": Callable(self, "_f23").bind(_s2), "story": Callable(self, "_f26").bind(_s2), "office": Callable(self, "_f28").bind(_s2), "battle": Callable(self, "_f30").bind(_s2), "silent": Callable(self, "_f33").bind(_s2)}
	_s2["S"] = {"chop": Callable(self, "_f35").bind(_s2), "treeFall": Callable(self, "_f36").bind(_s2), "crow": Callable(self, "_f37").bind(_s2), "harvest": Callable(self, "_f39").bind(_s2), "craft": Callable(self, "_f40").bind(_s2), "coin": Callable(self, "_f42").bind(_s2), "build": Callable(self, "_f43").bind(_s2), "gong": Callable(self, "_f44").bind(_s2), "levelUp": Callable(self, "_f46").bind(_s2), "click": Callable(self, "_f48").bind(_s2), "paper": Callable(self, "_f49").bind(_s2), "waIn": Callable(self, "_f50").bind(_s2), "waOut": Callable(self, "_f51").bind(_s2), "key": Callable(self, "_f52").bind(_s2), "praise": Callable(self, "_f53").bind(_s2), "hit": Callable(self, "_f54").bind(_s2), "skill": Callable(self, "_f55").bind(_s2), "combo": Callable(self, "_f56").bind(_s2), "win": Callable(self, "_f57").bind(_s2), "lose": Callable(self, "_f59").bind(_s2), "chest": Callable(self, "_f60").bind(_s2), "flatline": Callable(self, "_f61").bind(_s2), "heartbeat": Callable(self, "_f62").bind(_s2), "whoosh": Callable(self, "_f63").bind(_s2)}
	if (not J.seq(J.typeof_(J.G.get("document")), "undefined")):
		J.S_document_("addEventListener", ["visibilitychange", _s2["sync"]])
	return {"play": v_play_32, "setMode": _s2["setMode"], "toggle": v_toggle_34, "isOn": Callable(self, "_f67").bind(_s2), "unlock": _s2["unlock"]}
