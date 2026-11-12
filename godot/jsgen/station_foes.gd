# 自動轉譯自 station_foes.js（tools/jsgd.js）——唔好直接改，改原 JS 再轉
extends RefCounted

func run(env):
	var this_ = null; var a = []
	J.G["StnFoes"] = J.cl(Callable(self, "_f1").bind(env), null, [])
	var _t400 = (not J.seq(J.typeof_(J.G.get("module")), "undefined"))
	if J.t((J.gp(J.G.get("module"), "exports") if _t400 else _t400)):
		var _t401 = J.G.get("module")
		var _t402 = J.G.get("StnFoes")
		J.sp(_t401, "exports", _t402)

func _f6(this_, a: Array, env):
	var _t1 = {"seals": [], "brk": [], "pause": J.new_("Map", []), "salt": J.new_("Map", []), "saltFx": [], "beams": [], "wave": 0.0, "warned": J.new_("Set", []), "lines": J.new_("Set", [])}
	env["S"] = _t1

func _f10(this_, a: Array, env):
	var v_q_63 = null
	v_q_63 = J.arg(a, 0)
	var _t2 = J.gp(env["__p"]["S"], "lines")
	return (not J.t(J.mc(_t2, "has", [J.gp(v_q_63, 0.0)])))

func _f11(this_, a: Array, env):
	var _t11 = env["__p"]["S"]
	if J.t(_t11):
		var _t10 = J.gp(env["__p"]["S"], "lines")
		_t11 = J.mc(_t10, "delete", [J.gp(env["q"], 0.0)])
	return _t11

func _f9(this_, a: Array, env):
	var v_w_58 = null; var v_pool_59 = null; var v_dur_60 = null; var v_free_61 = null
	var _s13 = {"__p": env, "q": null}
	v_w_58 = J.arg(a, 0)
	v_pool_59 = J.arg(a, 1)
	v_dur_60 = J.arg(a, 2)
	v_free_61 = J.mc(v_pool_59, "filter", [Callable(self, "_f10").bind(_s13)])
	var _t3 = _s13["__p"]["pick"]
	_s13["q"] = J.cl(_t3, null, [(v_free_61 if J.t(J.len(v_free_61)) else v_pool_59)])
	var _t4 = J.gp(v_w_58, "say")
	if J.t((J.gp(J.gp(v_w_58, "say"), "_foe") if J.t(_t4) else _t4)):
		var _t5 = J.gp(_s13["__p"]["S"], "lines")
		J.mc(_t5, "delete", [J.gp(J.gp(v_w_58, "say"), "_foe")])
	var _t6 = J.gp(_s13["__p"]["S"], "lines")
	J.mc(_t6, "add", [J.gp(_s13["q"], 0.0)])
	var _t7 = _s13["__p"]["T"]
	var _t8 = {"s": J.cl(_t7, null, [J.gp(_s13["q"], 0.0), J.gp(_s13["q"], 1.0)]), "t": (v_dur_60 if J.t(v_dur_60) else 1.6), "_foe": J.gp(_s13["q"], 0.0)}
	J.sp(v_w_58, "say", _t8)
	var _t9 = _s13["__p"]["setTimeoutSafe"]
	J.cl(_t9, null, [Callable(self, "_f11").bind(_s13), (J.mul((v_dur_60 if J.t(v_dur_60) else 1.6), 1000.0) + 200.0)])

func _f13(this_, a: Array, env):
	var v_lv_69 = null
	v_lv_69 = J.arg(a, 0)
	return J.min_([0.3, (J.max_([0.0, (0.03 + (0.012 * J.sub(v_lv_69, 2.0)))]) * (1.0 + J.min_([1.0, J.div(J.gp(env["S"], "wave"), 20.0)])))])

func _f15(this_, a: Array, env):
	var v_id_76 = null
	v_id_76 = J.arg(a, 0)
	return J.cmp(env["lv"], J.gp(J.gp(env["__p"]["FOES"], v_id_76), "minLv"), ">=")

func _f16(this_, a: Array, env):
	var v_a_77 = null; var v_id_78 = null
	v_a_77 = J.arg(a, 0)
	v_id_78 = J.arg(a, 1)
	return J.add(v_a_77, J.gp(J.gp(env["__p"]["FOES"], v_id_78), "w"))

func _f17(this_, a: Array, env):
	var v_id_79 = null
	v_id_79 = J.arg(a, 0)
	var _t14 = env["__p"]["T"]
	return {"id": v_id_79, "name": J.cl(_t14, null, [J.gp(J.gp(J.gp(env["__p"]["FOES"], v_id_79), "n"), 0.0), J.gp(J.gp(J.gp(env["__p"]["FOES"], v_id_79), "n"), 1.0)]), "weight": J.gp(J.gp(env["__p"]["FOES"], v_id_79), "w"), "chance": J.div(J.mul(env["pc"], J.gp(J.gp(env["__p"]["FOES"], v_id_79), "w")), env["tw"]), "hpMul": J.gp(J.gp(env["__p"]["FOES"], v_id_79), "hp")}

func _f14(this_, a: Array, env):
	var v_ok_73 = null
	var _s21 = {"__p": env, "lv": null, "tw": null, "pc": null}
	_s21["lv"] = J.arg(a, 0)
	v_ok_73 = J.mc(_s21["__p"]["IDS"], "filter", [Callable(self, "_f15").bind(_s21)])
	_s21["tw"] = J.mc(v_ok_73, "reduce", [Callable(self, "_f16").bind(_s21), 0.0])
	var _t13 = null
	if J.t(J.len(v_ok_73)):
		var _t12 = _s21["__p"]["slotChance"]
		_t13 = J.cl(_t12, null, [_s21["lv"]])
	else:
		_t13 = 0.0
	_s21["pc"] = _t13
	return J.mc(v_ok_73, "map", [Callable(self, "_f17").bind(_s21)])

func _f19(this_, a: Array, env):
	var v_lv_83 = null; var v_q_84 = null; var v_tb_85 = null; var v_r_86 = null; var v_e_87 = null
	v_lv_83 = J.arg(a, 0)
	v_q_84 = J.arg(a, 1)
	if J.t(v_q_84):
		var _t15 = J.cmp(J.gp(v_q_84, "made"), 1.0, "<=")
		if (_t15 if _t15 else (not J.seq(J.gp(v_q_84, "_foeWave"), v_q_84))):
			J.sp(v_q_84, "_foeN", 0.0)
			J.sp(v_q_84, "_foeWave", v_q_84)
		if J.cmp(J.gp(v_q_84, "made"), 1.0, "<="):
			var _t16 = env["S"]
			J.sp(_t16, "wave", J.num(J.gp(_t16, "wave")) + 1.0)
		var _t18 = J.gp(v_q_84, "_foeN")
		var _t17 = env["waveCap"]
		if J.cmp(_t18, J.cl(_t17, null, [v_lv_83]), ">="):
			return null
	var _t19 = env["spawnTable"]
	v_tb_85 = J.cl(_t19, null, [v_lv_83])
	if (not J.t(J.len(v_tb_85))):
		return null
	v_r_86 = randf()
	for _t20 in J.iter(v_tb_85):
		v_e_87 = _t20
		if J.cmp(v_r_86, J.gp(v_e_87, "chance"), "<"):
			if J.t(v_q_84):
				var _t21 = J.gp(v_q_84, "_foeN")
				var _t22 = J.add((_t21 if J.t(_t21) else 0.0), 1.0)
				J.sp(v_q_84, "_foeN", _t22)
			return J.gp(v_e_87, "id")
		var _t23 = J.sub(v_r_86, J.gp(v_e_87, "chance"))
		v_r_86 = _t23
	return null

func _f20(this_, a: Array, env):
	var v_w_90 = null; var v_id_91 = null; var v_C_92 = null
	v_w_90 = J.arg(a, 0)
	v_id_91 = J.arg(a, 1)
	v_C_92 = J.gp(env["FOES"], v_id_91)
	var _t24 = (not J.t(v_C_92))
	if (_t24 if _t24 else (not J.t(v_w_90))):
		return v_w_90
	var _t26 = {}
	var _t25 = env["R"]
	var _t28 = J.cl(_t25, null, [1.0, 2.0])
	var _t27 = env["R"]
	var _t30 = J.cl(_t27, null, [1.5, 3.0])
	var _t29 = env["R"]
	var _t32 = J.cl(_t29, null, [4.0, 6.0])
	var _t31 = env["R"]
	var _t33 = {"id": v_id_91, "by": _t26, "cd": _t28, "bcd": _t30, "scd": _t32, "lt": J.cl(_t31, null, [1.0, 3.0]), "chant": null, "scan": 0.0, "retreated": false}
	J.sp(v_w_90, "foe", _t33)
	J.sp(v_w_90, "tr", null)
	J.sp(v_w_90, "mate", null)
	J.sp(v_w_90, "tint", null)
	J.sp(v_w_90, "el", null)
	J.sp(v_w_90, "tT", 99.0)
	var _t34 = {"id": J.add("foe_", v_id_91), "n": J.gp(J.gp(v_C_92, "n"), 0.0), "zh": J.gp(J.gp(v_C_92, "n"), 1.0), "re": J.gp(v_C_92, "re"), "big": J.gp(v_C_92, "big"), "hp": 1.0, "spd": 1.0, "w": 0.0}
	J.sp(v_w_90, "p", _t34)
	var _t35 = env["T"]
	var _t36 = J.cl(_t35, null, [J.gp(J.gp(v_C_92, "n"), 0.0), J.gp(J.gp(v_C_92, "n"), 1.0)])
	J.sp(v_w_90, "n", _t36)
	var _t37 = J.add("foe_", v_id_91)
	J.sp(v_w_90, "spr", _t37)
	var _t38 = J.round(J.num(J.mul(J.gp(v_w_90, "max"), J.gp(v_C_92, "hp"))))
	J.sp(v_w_90, "max", _t38)
	J.sp(v_w_90, "hp", _t38)
	var _t39 = J.mul(J.gp(v_w_90, "spd"), J.gp(v_C_92, "spd"))
	J.sp(v_w_90, "spd", _t39)
	var _t40 = J.round(J.num(J.mul(13.0, J.gp(v_C_92, "award"))))
	J.sp(v_w_90, "award", _t40)
	return v_w_90

func _f23(this_, a: Array, env):
	var v_o_97 = null; var v_s_98 = null
	v_o_97 = J.arg(a, 0)
	var _t42 = v_o_97
	if J.t(_t42):
		var _t41 = env["sealOf"]
		_t42 = J.cl(_t41, null, [v_o_97])
	v_s_98 = _t42
	return (J.max_([0.0, J.sub(J.gp(v_s_98, "dur"), J.gp(v_s_98, "t"))]) if J.t(v_s_98) else 0.0)

func _f24(this_, a: Array, env):
	var v_p_101 = null; var v_s_102 = null
	v_p_101 = J.arg(a, 0)
	var _t44 = v_p_101
	if J.t(_t44):
		var _t43 = J.gp(env["S"], "pause")
		_t44 = J.mc(_t43, "get", [v_p_101])
	v_s_102 = _t44
	return (J.max_([0.0, J.sub(J.gp(v_s_102, "dur"), J.gp(v_s_102, "t"))]) if J.t(v_s_102) else 0.0)

func _f25(this_, a: Array, env):
	var v_o_105 = null
	v_o_105 = J.arg(a, 0)
	var _t45 = env["isSealed"]
	var _t47 = J.cmp(J.cl(_t45, null, [v_o_105]), 0.0, ">")
	if not J.t(_t47):
		var _t46 = env["isPaused"]
		_t47 = J.cmp(J.cl(_t46, null, [v_o_105]), 0.0, ">")
	return _t47

func _f26(this_, a: Array, env):
	var v_p_108 = null; var v_s_109 = null
	v_p_108 = J.arg(a, 0)
	var _t49 = v_p_108
	if J.t(_t49):
		var _t48 = J.gp(env["S"], "salt")
		_t49 = J.mc(_t48, "get", [v_p_108])
	v_s_109 = _t49
	return (J.gp(J.gp(J.gp(env["FOES"], "hunter"), "salt"), "mul") if J.t(v_s_109) else 1.0)

func _f28(this_, a: Array, env):
	var v_q_121 = null
	v_q_121 = J.arg(a, 0)
	var _t55 = (not J.seq(v_q_121, env["__p"]["w"]))
	var _t56 = (J.gp(v_q_121, "foe") if _t55 else _t55)
	var _t57 = (J.seq(J.gp(J.gp(v_q_121, "foe"), "id"), "streamer") if J.t(_t56) else _t56)
	var _t58 = (J.mc(env["__p"]["W"], "alive", [v_q_121]) if J.t(_t57) else _t57)
	return (J.cmp(J.mc(env["__p"]["W"], "dist", [J.mc(env["__p"]["W"], "wp", [v_q_121]), env["pos"]]), J.mul(J.gp(env["A"], "r"), env["__p"]["__p"]["PX"]), "<") if J.t(_t58) else _t58)

func _f27(this_, a: Array, env):
	var v_dmg_113 = null; var v_o_114 = null; var v_role_116 = null; var v_F_117 = null; var v_C_118 = null; var v_capAmt_122 = null; var v_done_123 = null; var v_full_124 = null; var v_eff_125 = null; var v_x_126 = null; var v_y_127 = null
	var _s39 = {"__p": env, "w": null, "W": null}
	_s39["w"] = J.arg(a, 0)
	v_dmg_113 = J.arg(a, 1)
	v_o_114 = J.arg(a, 2)
	_s39["W"] = J.arg(a, 3)
	var _t50 = (v_o_114 if J.t(v_o_114) else {})
	v_o_114 = _t50
	var _t51 = (J.gp(_s39["W"], "_foeRole") if J.t(_s39["W"]) else _s39["W"])
	v_role_116 = (_t51 if J.t(_t51) else "other")
	var _t53 = _s39["W"]
	if J.t(_t53):
		var _t52 = (not J.t(J.gp(_s39["w"], "foe")))
		_t53 = (_t52 if _t52 else (not J.seq(J.gp(J.gp(_s39["w"], "foe"), "id"), "streamer")))
	if J.t(_t53):
		var _s40 = {"__p": _s39, "pos": null, "A": null}
		_s40["pos"] = J.mc(_s40["__p"]["W"], "wp", [_s40["__p"]["w"]])
		_s40["A"] = J.gp(J.gp(_s40["__p"]["__p"]["FOES"], "streamer"), "aura")
		var _t54 = J.gp(_s40["__p"]["W"], "walkers")
		if J.t(J.mc(_t54, "some", [Callable(self, "_f28").bind(_s40)])):
			var _t59 = J.div(v_dmg_113, J.gp(_s40["A"], "mul"))
			v_dmg_113 = _t59
	if (not J.t(J.gp(_s39["w"], "foe"))):
		return v_dmg_113
	v_F_117 = J.gp(_s39["w"], "foe")
	v_C_118 = J.gp(_s39["__p"]["FOES"], J.gp(v_F_117, "id"))
	if J.t(J.gp(v_C_118, "take")):
		var _t60 = J.mul(v_dmg_113, J.gp(v_C_118, "take"))
		v_dmg_113 = _t60
	var _t61 = J.gp(v_C_118, "res")
	if J.t(((not J.t(J.gp(v_o_114, "force"))) if J.t(_t61) else _t61)):
		v_capAmt_122 = J.mul(J.gp(_s39["__p"]["RES"], "cap"), J.gp(_s39["w"], "max"))
		var _t62 = J.gp(J.gp(v_F_117, "by"), v_role_116)
		v_done_123 = (_t62 if J.t(_t62) else 0.0)
		v_full_124 = J.min_([v_dmg_113, J.max_([0.0, J.sub(v_capAmt_122, v_done_123)])])
		v_eff_125 = J.add(v_full_124, J.mul(J.sub(v_dmg_113, v_full_124), J.gp(_s39["__p"]["RES"], "tail")))
		var _t63 = J.gp(v_F_117, "by")
		var _t64 = J.add(v_done_123, v_eff_125)
		J.sp(_t63, v_role_116, _t64)
		var _t66 = (J.sub(v_dmg_113, v_full_124) > 0.0)
		if J.t(_t66):
			var _t65 = J.gp(_s39["__p"]["S"], "warned")
			_t66 = (not J.t(J.mc(_t65, "has", [_s39["w"]])))
		if J.t((_s39["W"] if _t66 else _t66)):
			var _t67 = J.gp(_s39["__p"]["S"], "warned")
			J.mc(_t67, "add", [_s39["w"]])
			var _t68 = J.mc(_s39["W"], "wp", [_s39["w"]])
			var _t69 = J.gp(_t68, 0.0)
			v_x_126 = _t69
			var _t70 = J.gp(_t68, 1.0)
			v_y_127 = _t70
			var _t72 = J.sub(v_y_127, 0.12)
			var _t71 = _s39["__p"]["T"]
			J.mc(_s39["W"], "float", [v_x_126, _t72, J.cl(_t71, null, ["同一招唔夠嚇佢，夾埋第二類設備！", "同一招嚇不倒他，搭配其他類設備！"]), "#ffcf7a"])
		v_dmg_113 = v_eff_125
	else:
		var _t73 = J.gp(v_F_117, "by")
		var _t74 = J.gp(J.gp(v_F_117, "by"), v_role_116)
		var _t75 = J.add((_t74 if J.t(_t74) else 0.0), v_dmg_113)
		J.sp(_t73, v_role_116, _t75)
	var _t76 = J.gp(v_F_117, "chant")
	if J.t((J.cmp(v_dmg_113, J.mul(0.06, J.gp(_s39["w"], "max")), ">=") if J.t(_t76) else _t76)):
		var _t77 = J.gp(v_F_117, "chant")
		var _t78 = J.max_([0.0, J.sub(J.gp(J.gp(v_F_117, "chant"), "t"), 0.5)])
		J.sp(_t77, "t", _t78)
		var _t79 = J.gp(v_F_117, "chant")
		J.sp(_t79, "jolt", 0.4)
	return v_dmg_113

func _f30(this_, a: Array, env):
	var v_s_133 = null; var v_p_134 = null
	v_s_133 = J.arg(a, 0)
	if (not J.seq(J.gp(v_s_133, "by"), env["by"])):
		return true
	if J.t(env["W"]):
		var _t82 = env["__p"]["brkAdd"]
		J.cl(_t82, null, [v_s_133, env["W"]])
	var _t83 = (not J.t(env["quiet"]))
	if J.t((env["W"] if _t83 else _t83)):
		var _t84 = env["__p"]["spotOf"]
		v_p_134 = J.cl(_t84, null, [v_s_133, env["W"]])
		if J.t(v_p_134):
			var _t86 = J.gp(v_p_134, 0.0)
			var _t87 = J.sub(J.gp(v_p_134, 1.0), 0.06)
			var _t85 = env["__p"]["T"]
			J.mc(env["W"], "float", [_t86, _t87, J.cl(_t85, null, ["黃符撤走", "黃符撤走"]), "#ffe9a0"])
	return false

func _f29(this_, a: Array, env):
	var _s45 = {"__p": env, "by": null, "W": null, "quiet": null}
	_s45["by"] = J.arg(a, 0)
	_s45["W"] = J.arg(a, 1)
	_s45["quiet"] = J.arg(a, 2)
	var _t80 = _s45["__p"]["S"]
	var _t81 = J.gp(_s45["__p"]["S"], "seals")
	var _t88 = J.mc(_t81, "filter", [Callable(self, "_f30").bind(_s45)])
	J.sp(_t80, "seals", _t88)

func _f31(this_, a: Array, env):
	var v_s_137 = null; var v_W_138 = null; var v_sp_139 = null
	v_s_137 = J.arg(a, 0)
	v_W_138 = J.arg(a, 1)
	if J.seq(J.gp(v_s_137, "kind"), "boss"):
		return (J.mc(v_W_138, "bpos", [J.gp(v_s_137, "tgt")]) if J.t(J.gp(v_W_138, "bpos")) else null)
	v_sp_139 = J.gp(J.gp(J.gp(v_W_138, "lay"), "posts"), J.gp(v_s_137, "i"))
	return ([J.gp(v_sp_139, "x"), J.gp(v_sp_139, "y")] if J.t(v_sp_139) else null)

func _f33(this_, a: Array, env):
	var v_p_144 = null; var v_i_145 = null; var v_sp_146 = null
	v_p_144 = J.arg(a, 0)
	v_i_145 = J.arg(a, 1)
	v_sp_146 = J.gp(J.gp(J.gp(env["W"], "lay"), "posts"), v_i_145)
	var _t91 = (J.gp(v_p_144, "role") if J.t(v_p_144) else v_p_144)
	var _t92 = ((not J.cmp(J.gp(v_p_144, "build"), 0.0, ">")) if J.t(_t91) else _t91)
	if J.t((v_sp_146 if J.t(_t92) else _t92)):
		J.mc(env["out"], "push", [{"p": v_p_144, "i": v_i_145, "sp": v_sp_146}])

func _f32(this_, a: Array, env):
	var _s49 = {"__p": env, "W": null, "out": null}
	_s49["W"] = J.arg(a, 0)
	_s49["out"] = []
	var _t89 = J.gp(J.gp(_s49["W"], "sd"), "posts")
	var _t90 = (_t89 if J.t(_t89) else [])
	J.mc(_t90, "forEach", [Callable(self, "_f33").bind(_s49)])
	return _s49["out"]

func _f35(this_, a: Array, env):
	var v_s_152 = null; var v_gone_153 = null; var v_p_154 = null
	v_s_152 = J.arg(a, 0)
	var _t99 = null
	if J.seq(J.gp(v_s_152, "kind"), "boss"):
		var _t97 = J.gp(env["W"], "bosses")
		var _t98 = (_t97 if J.t(_t97) else [])
		_t99 = (not J.t(J.mc(_t98, "includes", [J.gp(v_s_152, "tgt")])))
	else:
		_t99 = (not J.seq(J.gp(J.gp(J.gp(env["W"], "sd"), "posts"), J.gp(v_s_152, "i")), J.gp(v_s_152, "tgt")))
	v_gone_153 = _t99
	if J.t(v_gone_153):
		return false
	if J.cmp(J.gp(v_s_152, "t"), J.gp(v_s_152, "dur"), "<"):
		return true
	var _t100 = env["__p"]["brkAdd"]
	J.cl(_t100, null, [v_s_152, env["W"]])
	var _t101 = env["__p"]["spotOf"]
	v_p_154 = J.cl(_t101, null, [v_s_152, env["W"]])
	if J.t(v_p_154):
		var _t103 = J.gp(v_p_154, 0.0)
		var _t104 = J.sub(J.gp(v_p_154, 1.0), 0.06)
		var _t102 = env["__p"]["T"]
		J.mc(env["W"], "float", [_t103, _t104, J.cl(_t102, null, ["解封！", "解封！"]), "#9ef0b0"])
	return false

func _f36(this_, a: Array, env):
	var v_f_158 = null
	v_f_158 = J.arg(a, 0)
	var _t113 = J.add(J.gp(v_f_158, "t"), env["dt"])
	J.sp(v_f_158, "t", _t113)
	return J.cmp(_t113, J.gp(v_f_158, "dur"), "<")

func _f37(this_, a: Array, env):
	var v_f_159 = null
	v_f_159 = J.arg(a, 0)
	var _t118 = J.add(J.gp(v_f_159, "t"), env["dt"])
	J.sp(v_f_159, "t", _t118)
	return J.cmp(_t118, J.gp(v_f_159, "dur"), "<")

func _f38(this_, a: Array, env):
	var v_f_160 = null
	v_f_160 = J.arg(a, 0)
	var _t122 = J.add(J.gp(v_f_160, "t"), env["dt"])
	J.sp(v_f_160, "t", _t122)
	return J.cmp(_t122, J.gp(v_f_160, "dur"), "<")

func _f34(this_, a: Array, env):
	var v_s_151 = null; var v_M_155 = null; var v_k_156 = null; var v_v_157 = null; var v_w_161 = null; var v_F_162 = null
	var _s51 = {"__p": env, "dt": null, "W": null}
	_s51["dt"] = J.arg(a, 0)
	_s51["W"] = J.arg(a, 1)
	for _t93 in J.iter(J.gp(_s51["__p"]["S"], "seals")):
		v_s_151 = _t93
		var _t94 = J.add(J.gp(v_s_151, "t"), _s51["dt"])
		J.sp(v_s_151, "t", _t94)
	var _t95 = _s51["__p"]["S"]
	var _t96 = J.gp(_s51["__p"]["S"], "seals")
	var _t105 = J.mc(_t96, "filter", [Callable(self, "_f35").bind(_s51)])
	J.sp(_t95, "seals", _t105)
	for _t106 in J.iter([J.gp(_s51["__p"]["S"], "pause"), J.gp(_s51["__p"]["S"], "salt")]):
		v_M_155 = _t106
		for _t107 in J.iter(v_M_155):
			var _t108 = J.gp(_t107, 0.0)
			v_k_156 = _t108
			var _t109 = J.gp(_t107, 1.0)
			v_v_157 = _t109
			var _t110 = J.add(J.gp(v_v_157, "t"), _s51["dt"])
			J.sp(v_v_157, "t", _t110)
			if J.cmp(J.gp(v_v_157, "t"), J.gp(v_v_157, "dur"), ">="):
				J.mc(v_M_155, "delete", [v_k_156])
	var _t111 = _s51["__p"]["S"]
	var _t112 = J.gp(_s51["__p"]["S"], "saltFx")
	var _t114 = J.mc(_t112, "filter", [Callable(self, "_f36").bind(_s51)])
	J.sp(_t111, "saltFx", _t114)
	var _t115 = _s51["__p"]["S"]
	var _t116 = J.gp(_s51["__p"]["S"], "brk")
	var _t117 = (_t116 if J.t(_t116) else [])
	var _t119 = J.mc(_t117, "filter", [Callable(self, "_f37").bind(_s51)])
	J.sp(_t115, "brk", _t119)
	var _t120 = _s51["__p"]["S"]
	var _t121 = J.gp(_s51["__p"]["S"], "beams")
	var _t123 = J.mc(_t121, "filter", [Callable(self, "_f38").bind(_s51)])
	J.sp(_t120, "beams", _t123)
	for _t124 in J.iter(J.gp(_s51["W"], "walkers")):
		v_w_161 = _t124
		if (not J.t(J.gp(v_w_161, "foe"))):
			continue
		v_F_162 = J.gp(v_w_161, "foe")
		if J.t(J.gp(v_w_161, "gone")):
			var _t125 = J.seq(J.gp(v_F_162, "id"), "taoist")
			if ((not J.t(J.gp(v_F_162, "released"))) if _t125 else _t125):
				J.sp(v_F_162, "released", true)
				var _t126 = _s51["__p"]["release"]
				J.cl(_t126, null, [v_w_161, _s51["W"]])
			continue
		if (not J.t(J.mc(_s51["W"], "alive", [v_w_161]))):
			continue
		if J.seq(J.gp(v_F_162, "id"), "taoist"):
			var _t127 = _s51["__p"]["taoTick"]
			J.cl(_t127, null, [v_w_161, v_F_162, _s51["dt"], _s51["W"]])
		else:
			if J.seq(J.gp(v_F_162, "id"), "hunter"):
				var _t128 = _s51["__p"]["huntTick"]
				J.cl(_t128, null, [v_w_161, v_F_162, _s51["dt"], _s51["W"]])
			else:
				var _t129 = _s51["__p"]["streamTick"]
				J.cl(_t129, null, [v_w_161, v_F_162, _s51["dt"], _s51["W"]])

func _f40(this_, a: Array, env):
	var v_s_176 = null
	v_s_176 = J.arg(a, 0)
	return J.seq(J.gp(v_s_176, "by"), env["w"])

func _f39(this_, a: Array, env):
	var v_F_166 = null; var v_dt_167 = null; var v_W_168 = null; var v_C_169 = null; var v_pos_170 = null; var v_best_171 = null; var v_bd_172 = null; var v_ch_173 = null; var v_tgtOk_174 = null; var v_p_175 = null; var v_d_177 = null; var v_r_178 = null; var v_B_179 = null; var v_r_180 = null
	var _s64 = {"__p": env, "w": null}
	_s64["w"] = J.arg(a, 0)
	v_F_166 = J.arg(a, 1)
	v_dt_167 = J.arg(a, 2)
	v_W_168 = J.arg(a, 3)
	v_C_169 = J.gp(_s64["__p"]["FOES"], "taoist")
	v_pos_170 = J.mc(v_W_168, "wp", [_s64["w"]])
	var _t130 = J.sub(J.gp(v_F_166, "cd"), v_dt_167)
	J.sp(v_F_166, "cd", _t130)
	var _t131 = (not J.t(J.gp(v_F_166, "retreated")))
	if (J.cmp(J.div(J.gp(_s64["w"], "hp"), J.gp(_s64["w"], "max")), J.gp(v_C_169, "retreat"), "<") if _t131 else _t131):
		J.sp(v_F_166, "retreated", true)
		J.sp(v_F_166, "chant", null)
		var _t132 = _s64["__p"]["release"]
		J.cl(_t132, null, [_s64["w"], v_W_168])
		var _t133 = _s64["__p"]["line"]
		J.cl(_t133, null, [_s64["w"], J.gp(v_C_169, "retreatL"), 1.8])
		return null
	if J.t(J.gp(v_F_166, "chant")):
		v_ch_173 = J.gp(v_F_166, "chant")
		if J.cmp(J.gp(v_ch_173, "jolt"), 0.0, ">"):
			var _t134 = J.sub(J.gp(v_ch_173, "jolt"), v_dt_167)
			J.sp(v_ch_173, "jolt", _t134)
		var _t141 = null
		if J.seq(J.gp(v_ch_173, "kind"), "boss"):
			var _t135 = J.gp(v_W_168, "bosses")
			var _t136 = (_t135 if J.t(_t135) else [])
			var _t138 = J.mc(_t136, "includes", [J.gp(v_ch_173, "tgt")])
			if J.t(_t138):
				var _t137 = _s64["__p"]["isSealed"]
				_t138 = (not J.t(J.cl(_t137, null, [J.gp(v_ch_173, "tgt")])))
			_t141 = _t138
		else:
			var _t140 = J.seq(J.gp(J.gp(J.gp(v_W_168, "sd"), "posts"), J.gp(v_ch_173, "i")), J.gp(v_ch_173, "tgt"))
			if J.t(_t140):
				var _t139 = _s64["__p"]["isSealed"]
				_t140 = (not J.t(J.cl(_t139, null, [J.gp(v_ch_173, "tgt")])))
			_t141 = _t140
		v_tgtOk_174 = _t141
		if (not J.t(v_tgtOk_174)):
			J.sp(v_F_166, "chant", null)
			J.sp(v_F_166, "cd", 1.0)
			return null
		var _t142 = _s64["w"]
		var _t143 = J.gp(_s64["w"], "block")
		var _t144 = J.gp(_s64["w"], "block")
		var _t145 = J.max_([(_t144 if J.t(_t144) else 0.0), 0.15])
		J.sp(_t142, "block", _t145)
		var _t146 = J.add(J.gp(v_ch_173, "t"), v_dt_167)
		J.sp(v_ch_173, "t", _t146)
		if J.cmp(J.gp(v_ch_173, "t"), J.gp(v_ch_173, "dur"), ">="):
			var _t147 = J.gp(_s64["__p"]["S"], "seals")
			var _t149 = J.gp(v_ch_173, "tgt")
			var _t150 = J.gp(v_ch_173, "kind")
			var _t151 = J.gp(v_ch_173, "i")
			var _t148 = _s64["__p"]["R"]
			J.mc(_t147, "push", [{"tgt": _t149, "kind": _t150, "i": _t151, "t": 0.0, "dur": J.cl(_t148, null, [J.gp(J.gp(v_C_169, "seal"), 0.0), J.gp(J.gp(v_C_169, "seal"), 1.0)]), "by": _s64["w"], "seed": (randf() * 9.0)}])
			J.sp(v_F_166, "chant", null)
			var _t152 = J.gp(v_C_169, "cd")
			J.sp(v_F_166, "cd", _t152)
			var _t153 = _s64["__p"]["spotOf"]
			v_p_175 = J.cl(_t153, null, [J.gp(J.gp(_s64["__p"]["S"], "seals"), (J.len(J.gp(_s64["__p"]["S"], "seals")) - 1.0)), v_W_168])
			if J.t(v_p_175):
				var _t157 = J.gp(v_p_175, 0.0)
				var _t158 = J.sub(J.gp(v_p_175, 1.0), 0.08)
				var _t156 = null
				if J.seq(J.gp(v_ch_173, "kind"), "boss"):
					var _t154 = _s64["__p"]["T"]
					_t156 = J.cl(_t154, null, ["名鬼被封印！", "名鬼被封印！"])
				else:
					var _t155 = _s64["__p"]["T"]
					_t156 = J.cl(_t155, null, ["設備被封！", "設備被封！"])
				J.mc(v_W_168, "float", [_t157, _t158, _t156, "#ffd45a"])
		return null
	var _t159 = J.gp(v_F_166, "retreated")
	var _t161 = (_t159 if J.t(_t159) else J.cmp(J.gp(v_F_166, "cd"), 0.0, ">"))
	if not J.t(_t161):
		var _t160 = J.gp(_s64["__p"]["S"], "seals")
		_t161 = J.cmp(J.len(J.mc(_t160, "filter", [Callable(self, "_f40").bind(_s64)])), J.gp(v_C_169, "maxSeal"), ">=")
	if J.t(_t161):
		return null
	v_best_171 = null
	v_bd_172 = J.mul(J.gp(v_C_169, "range"), _s64["__p"]["PX"])
	var _t163 = _s64["__p"]["devList"]
	for _t162 in J.iter(J.cl(_t163, null, [v_W_168])):
		v_d_177 = _t162
		var _t164 = _s64["__p"]["isSealed"]
		if J.t(J.cl(_t164, null, [J.gp(v_d_177, "p")])):
			continue
		v_r_178 = (J.mc(v_W_168, "rdist", [v_pos_170, J.gp(v_d_177, "sp")]) if J.t(J.gp(v_W_168, "rdist")) else J.mc(v_W_168, "dist", [v_pos_170, [J.gp(J.gp(v_d_177, "sp"), "x"), J.gp(J.gp(v_d_177, "sp"), "y")]]))
		if J.cmp(v_r_178, v_bd_172, "<="):
			v_bd_172 = v_r_178
			var _t165 = {"tgt": J.gp(v_d_177, "p"), "kind": "dev", "i": J.gp(v_d_177, "i")}
			v_best_171 = _t165
	var _t167 = J.gp(v_W_168, "bosses")
	for _t166 in J.iter((_t167 if J.t(_t167) else [])):
		v_B_179 = _t166
		var _t169 = J.gp(v_B_179, "hid")
		if not J.t(_t169):
			var _t168 = _s64["__p"]["isSealed"]
			_t169 = J.cl(_t168, null, [v_B_179])
		if J.t((_t169 if J.t(_t169) else (not J.t(J.gp(v_W_168, "bpos"))))):
			continue
		v_r_180 = J.mc(v_W_168, "dist", [v_pos_170, J.mc(v_W_168, "bpos", [v_B_179])])
		if J.cmp(v_r_180, v_bd_172, "<="):
			v_bd_172 = v_r_180
			var _t170 = {"tgt": v_B_179, "kind": "boss", "i": (-1.0)}
			v_best_171 = _t170
	if (not J.t(v_best_171)):
		J.sp(v_F_166, "cd", 0.4)
		return null
	var _t171 = J.S_Object_("assign", [v_best_171, {"t": 0.0, "dur": J.gp(v_C_169, "chant"), "jolt": 0.0}])
	J.sp(v_F_166, "chant", _t171)
	var _t172 = _s64["w"]
	var _t173 = J.gp(_s64["w"], "block")
	var _t174 = J.gp(_s64["w"], "block")
	var _t175 = J.max_([(_t174 if J.t(_t174) else 0.0), 0.15])
	J.sp(_t172, "block", _t175)
	var _t176 = _s64["__p"]["line"]
	J.cl(_t176, null, [_s64["w"], J.gp(v_C_169, "chantL"), 1.8])

func _f42(this_, a: Array, env):
	var v_d_193 = null; var v_dx_194 = null; var v_dy_195 = null; var v_r_196 = null; var v_da_197 = null
	v_d_193 = J.arg(a, 0)
	v_dx_194 = J.sub(J.gp(J.gp(v_d_193, "sp"), "x"), J.gp(env["__p"]["pos"], 0.0))
	v_dy_195 = (J.sub(J.gp(J.gp(v_d_193, "sp"), "y"), J.gp(env["__p"]["pos"], 1.0)) * 1.5)
	v_r_196 = J.hypot_([v_dx_194, v_dy_195])
	if J.cmp(v_r_196, J.mul(J.gp(env["B"], "r"), env["__p"]["__p"]["PX"]), ">"):
		return false
	v_da_197 = J.sub(atan2(J.num(v_dy_195), J.num(v_dx_194)), env["dir"])
	var _t185 = atan2(J.num(sin(J.num(v_da_197))), J.num(cos(J.num(v_da_197))))
	v_da_197 = _t185
	return J.cmp(absf(J.num(v_da_197)), J.gp(env["B"], "half"), "<=")

func _f43(this_, a: Array, env):
	var v_d_198 = null; var v_o_199 = null
	v_d_198 = J.arg(a, 0)
	var _t186 = J.gp(env["__p"]["__p"]["S"], "pause")
	v_o_199 = J.mc(_t186, "get", [J.gp(v_d_198, "p")])
	var _t187 = (not J.t(v_o_199))
	if (_t187 if _t187 else J.cmp(J.sub(J.gp(v_o_199, "dur"), J.gp(v_o_199, "t")), J.gp(env["B"], "dur"), "<")):
		var _t188 = J.gp(env["__p"]["__p"]["S"], "pause")
		J.mc(_t188, "set", [J.gp(v_d_198, "p"), {"t": 0.0, "dur": J.gp(env["B"], "dur"), "i": J.gp(v_d_198, "i")}])

func _f44(this_, a: Array, env):
	var v_d_207 = null
	v_d_207 = J.arg(a, 0)
	return J.cmp(J.mc(env["__p"]["W"], "dist", [env["__p"]["pos"], [J.gp(J.gp(v_d_207, "sp"), "x"), J.gp(J.gp(v_d_207, "sp"), "y")]]), J.mul(J.gp(J.gp(env["__p"]["C"], "salt"), "reach"), env["__p"]["__p"]["PX"]), "<=")

func _f46(this_, a: Array, env):
	var v_e_209 = null
	v_e_209 = J.arg(a, 0)
	return J.cmp(J.mc(env["__p"]["__p"]["W"], "dist", [[J.gp(J.gp(env["d"], "sp"), "x"), J.gp(J.gp(env["d"], "sp"), "y")], [J.gp(J.gp(v_e_209, "sp"), "x"), J.gp(J.gp(v_e_209, "sp"), "y")]]), env["__p"]["rr"], "<=")

func _f45(this_, a: Array, env):
	var _s86 = {"__p": env, "d": null}
	_s86["d"] = J.arg(a, 0)
	return J.sub(J.len(J.mc(_s86["__p"]["ds"], "filter", [Callable(self, "_f46").bind(_s86)])), J.mc(_s86["__p"]["__p"]["W"], "dist", [_s86["__p"]["__p"]["pos"], [J.gp(J.gp(_s86["d"], "sp"), "x"), J.gp(J.gp(_s86["d"], "sp"), "y")]]))

func _f47(this_, a: Array, env):
	var v_a_210 = null; var v_b_211 = null
	v_a_210 = J.arg(a, 0)
	v_b_211 = J.arg(a, 1)
	var _t200 = env["score"]
	var _t202 = J.cl(_t200, null, [v_b_211])
	var _t201 = env["score"]
	return J.sub(_t202, J.cl(_t201, null, [v_a_210]))

func _f48(this_, a: Array, env):
	var v_d_212 = null
	v_d_212 = J.arg(a, 0)
	return J.cmp(J.mc(env["__p"]["W"], "dist", [[env["cx"], env["cy"]], [J.gp(J.gp(v_d_212, "sp"), "x"), J.gp(J.gp(v_d_212, "sp"), "y")]]), env["rr"], "<=")

func _f49(this_, a: Array, env):
	var v_d_213 = null
	v_d_213 = J.arg(a, 0)
	var _t206 = J.gp(env["__p"]["__p"]["S"], "salt")
	return J.mc(_t206, "set", [J.gp(v_d_213, "p"), {"t": 0.0, "dur": J.gp(J.gp(env["__p"]["C"], "salt"), "dur"), "i": J.gp(v_d_213, "i")}])

func _f41(this_, a: Array, env):
	var v_w_183 = null; var v_F_184 = null; var v_dt_185 = null; var v_ah_189 = null; var v_hitL_192 = null; var v_c0_203 = null; var v_gr_206 = null; var v_j_214 = null; var v_a_215 = null; var v_k_216 = null
	var _s77 = {"__p": env, "W": null, "C": null, "pos": null}
	v_w_183 = J.arg(a, 0)
	v_F_184 = J.arg(a, 1)
	v_dt_185 = J.arg(a, 2)
	_s77["W"] = J.arg(a, 3)
	_s77["C"] = J.gp(_s77["__p"]["FOES"], "hunter")
	_s77["pos"] = J.mc(_s77["W"], "wp", [v_w_183])
	var _t177 = J.sub(J.gp(v_F_184, "bcd"), v_dt_185)
	J.sp(v_F_184, "bcd", _t177)
	var _t178 = J.sub(J.gp(v_F_184, "scd"), v_dt_185)
	J.sp(v_F_184, "scd", _t178)
	if J.cmp(J.gp(v_F_184, "scan"), 0.0, ">"):
		var _t179 = J.sub(J.gp(v_F_184, "scan"), v_dt_185)
		J.sp(v_F_184, "scan", _t179)
		var _t180 = J.gp(v_w_183, "block")
		var _t181 = J.gp(v_w_183, "block")
		var _t182 = J.max_([(_t181 if J.t(_t181) else 0.0), 0.15])
		J.sp(v_w_183, "block", _t182)
		return null
	if J.cmp(J.gp(v_F_184, "bcd"), 0.0, "<="):
		var _s79 = {"__p": _s77, "dir": null, "B": null}
		v_ah_189 = J.mc(_s79["__p"]["W"], "wp", [v_w_183, J.mul(_s79["__p"]["__p"]["CELL"], 0.6)])
		_s79["dir"] = atan2(J.num((J.sub(J.gp(v_ah_189, 1.0), J.gp(_s79["__p"]["pos"], 1.0)) * 1.5)), J.num(J.sub(J.gp(v_ah_189, 0.0), J.gp(_s79["__p"]["pos"], 0.0))))
		_s79["B"] = J.gp(_s79["__p"]["C"], "beam")
		var _t183 = _s79["__p"]["__p"]["devList"]
		var _t184 = J.cl(_t183, null, [_s79["__p"]["W"]])
		v_hitL_192 = J.mc(_t184, "filter", [Callable(self, "_f42").bind(_s79)])
		if J.t(J.len(v_hitL_192)):
			J.mc(v_hitL_192, "forEach", [Callable(self, "_f43").bind(_s79)])
			var _t189 = J.gp(_s79["__p"]["__p"]["S"], "beams")
			J.mc(_t189, "push", [{"w": v_w_183, "dir": _s79["dir"], "t": 0.0, "dur": J.add(J.gp(_s79["B"], "scan"), 0.3), "r": J.mul(J.gp(_s79["B"], "r"), _s79["__p"]["__p"]["PX"]), "half": J.gp(_s79["B"], "half"), "x": J.gp(_s79["__p"]["pos"], 0.0), "y": J.gp(_s79["__p"]["pos"], 1.0)}])
			var _t190 = J.gp(_s79["B"], "scan")
			J.sp(v_F_184, "scan", _t190)
			var _t191 = _s79["__p"]["__p"]["R"]
			var _t192 = J.cl(_t191, null, [J.gp(J.gp(_s79["B"], "cd"), 0.0), J.gp(J.gp(_s79["B"], "cd"), 1.0)])
			J.sp(v_F_184, "bcd", _t192)
			var _t193 = J.gp(v_w_183, "block")
			var _t194 = J.gp(v_w_183, "block")
			var _t195 = J.max_([(_t194 if J.t(_t194) else 0.0), 0.15])
			J.sp(v_w_183, "block", _t195)
			var _t196 = _s79["__p"]["__p"]["line"]
			J.cl(_t196, null, [v_w_183, J.gp(_s79["__p"]["C"], "beamL"), 1.5])
			return null
		J.sp(v_F_184, "bcd", 0.6)
	if J.cmp(J.gp(v_F_184, "scd"), 0.0, "<="):
		var _s83 = {"__p": _s77, "ds": null, "rr": null, "score": null, "cx": null, "cy": null}
		var _t197 = _s83["__p"]["__p"]["devList"]
		var _t198 = J.cl(_t197, null, [_s83["__p"]["W"]])
		_s83["ds"] = J.mc(_t198, "filter", [Callable(self, "_f44").bind(_s83)])
		if (not J.t(J.len(_s83["ds"]))):
			J.sp(v_F_184, "scd", 1.0)
			return null
		_s83["rr"] = J.mul(J.gp(J.gp(_s83["__p"]["C"], "salt"), "r"), _s83["__p"]["__p"]["CELL"])
		_s83["score"] = Callable(self, "_f45").bind(_s83)
		var _t199 = J.mc(_s83["ds"], "slice", [])
		v_c0_203 = J.gp(J.mc(_t199, "sort", [Callable(self, "_f47").bind(_s83)]), 0.0)
		_s83["cx"] = J.gp(J.gp(v_c0_203, "sp"), "x")
		_s83["cy"] = J.gp(J.gp(v_c0_203, "sp"), "y")
		var _t203 = _s83["__p"]["__p"]["devList"]
		var _t204 = J.cl(_t203, null, [_s83["__p"]["W"]])
		var _t205 = J.mc(_t204, "filter", [Callable(self, "_f48").bind(_s83)])
		J.mc(_t205, "forEach", [Callable(self, "_f49").bind(_s83)])
		v_gr_206 = []
		v_j_214 = 0.0
		while true:
			if not J.cmp(v_j_214, 46.0, "<"): break
			v_a_215 = (randf() * 6.283)
			v_k_216 = sqrt(J.num(randf()))
			J.mc(v_gr_206, "push", [[J.mul(J.mul(cos(J.num(v_a_215)), v_k_216), _s83["rr"]), J.div(J.mul(J.mul(sin(J.num(v_a_215)), v_k_216), _s83["rr"]), 1.5), randf()]])
			v_j_214 = J.num(v_j_214) + 1.0
		var _t207 = J.gp(_s83["__p"]["__p"]["S"], "saltFx")
		J.mc(_t207, "push", [{"x": _s83["cx"], "y": _s83["cy"], "fx": J.gp(_s83["__p"]["pos"], 0.0), "fy": J.gp(_s83["__p"]["pos"], 1.0), "r": _s83["rr"], "t": 0.0, "dur": J.gp(J.gp(_s83["__p"]["C"], "salt"), "dur"), "gr": v_gr_206}])
		var _t208 = _s83["__p"]["__p"]["R"]
		var _t209 = J.cl(_t208, null, [J.gp(J.gp(J.gp(_s83["__p"]["C"], "salt"), "cd"), 0.0), J.gp(J.gp(J.gp(_s83["__p"]["C"], "salt"), "cd"), 1.0)])
		J.sp(v_F_184, "scd", _t209)
		var _t210 = _s83["__p"]["__p"]["line"]
		J.cl(_t210, null, [v_w_183, J.gp(_s83["__p"]["C"], "saltL"), 1.4])

func _f50(this_, a: Array, env):
	var v_w_219 = null; var v_F_220 = null; var v_dt_221 = null; var v_C_222 = null
	v_w_219 = J.arg(a, 0)
	v_F_220 = J.arg(a, 1)
	v_dt_221 = J.arg(a, 2)
	v_C_222 = J.gp(env["FOES"], "streamer")
	var _t211 = J.sub(J.gp(v_F_220, "lt"), v_dt_221)
	J.sp(v_F_220, "lt", _t211)
	var _t212 = J.cmp(J.gp(v_F_220, "lt"), 0.0, "<=")
	if ((not J.t(J.gp(v_w_219, "say"))) if _t212 else _t212):
		var _t213 = env["R"]
		var _t214 = J.cl(_t213, null, [J.gp(J.gp(v_C_222, "talkCd"), 0.0), J.gp(J.gp(v_C_222, "talkCd"), 1.0)])
		J.sp(v_F_220, "lt", _t214)
		var _t215 = env["line"]
		J.cl(_t215, null, [v_w_219, J.gp(v_C_222, "talkL"), 1.6])

func _f51(this_, a: Array, env):
	var v_cv_225 = null; var v_g_226 = null; var v_gr_227 = null; var v_j_228 = null; var v_y_229 = null; var v_cx_230 = null; var v_cy_231 = null; var v_s_232 = null; var v_a_233 = null; var v_r_234 = null; var v_y_235 = null
	if J.t((env["FU"] if J.t(env["FU"]) else J.seq(J.typeof_(J.G.get("document")), "undefined"))):
		return env["FU"]
	v_cv_225 = J.S_document_("createElement", ["canvas"])
	J.sp(v_cv_225, "width", 64.0)
	J.sp(v_cv_225, "height", 160.0)
	v_g_226 = J.mc(v_cv_225, "getContext", ["2d"])
	J.sp(v_g_226, "fillStyle", "#f2cf45")
	J.mc(v_g_226, "fillRect", [0.0, 0.0, 64.0, 160.0])
	v_gr_227 = J.mc(v_g_226, "createLinearGradient", [0.0, 0.0, 64.0, 0.0])
	J.mc(v_gr_227, "addColorStop", [0.0, "rgba(160,100,10,0.25)"])
	J.mc(v_gr_227, "addColorStop", [0.5, "rgba(255,255,255,0)"])
	J.mc(v_gr_227, "addColorStop", [1.0, "rgba(160,100,10,0.25)"])
	J.sp(v_g_226, "fillStyle", v_gr_227)
	J.mc(v_g_226, "fillRect", [0.0, 0.0, 64.0, 160.0])
	J.sp(v_g_226, "strokeStyle", "#b8261c")
	J.sp(v_g_226, "fillStyle", "#b8261c")
	J.sp(v_g_226, "lineCap", "round")
	J.sp(v_g_226, "lineJoin", "round")
	J.sp(v_g_226, "lineWidth", 2.0)
	J.mc(v_g_226, "strokeRect", [4.0, 4.0, 56.0, 152.0])
	v_j_228 = 0.0
	while true:
		if not J.cmp(v_j_228, 3.0, "<"): break
		J.mc(v_g_226, "beginPath", [])
		J.mc(v_g_226, "arc", [(18.0 + J.mul(v_j_228, 14.0)), 18.0, 4.5, 0.0, 7.0])
		J.mc(v_g_226, "fill", [])
		v_j_228 = J.num(v_j_228) + 1.0
	J.sp(v_g_226, "lineWidth", 3.2)
	J.mc(v_g_226, "beginPath", [])
	J.mc(v_g_226, "moveTo", [10.0, 30.0])
	J.mc(v_g_226, "lineTo", [54.0, 30.0])
	J.mc(v_g_226, "stroke", [])
	J.mc(v_g_226, "beginPath", [])
	J.mc(v_g_226, "moveTo", [32.0, 30.0])
	v_y_229 = 30.0
	while true:
		if not J.cmp(v_y_229, 120.0, "<="): break
		J.mc(v_g_226, "lineTo", [(32.0 + (sin(J.num(J.mul(v_y_229, 0.16))) * 9.0)), v_y_229])
		var _t216 = J.add(v_y_229, 3.0)
		v_y_229 = _t216
	J.mc(v_g_226, "stroke", [])
	J.sp(v_g_226, "lineWidth", 2.4)
	for _t217 in J.iter([[17.0, 56.0, 1.0], [47.0, 74.0, (-1.0)], [17.0, 94.0, 1.0]]):
		var _t218 = J.gp(_t217, 0.0)
		v_cx_230 = _t218
		var _t219 = J.gp(_t217, 1.0)
		v_cy_231 = _t219
		var _t220 = J.gp(_t217, 2.0)
		v_s_232 = _t220
		J.mc(v_g_226, "beginPath", [])
		v_a_233 = 0.0
		while true:
			if not J.cmp(v_a_233, 12.0, "<"): break
			v_r_234 = (1.0 + J.mul(v_a_233, 0.75))
			J.mc(v_g_226, "lineTo", [J.add(v_cx_230, J.mul(cos(J.num(J.mul(v_a_233, v_s_232))), v_r_234)), J.add(v_cy_231, J.mul(sin(J.num(J.mul(v_a_233, v_s_232))), v_r_234))])
			var _t221 = J.add(v_a_233, 0.25)
			v_a_233 = _t221
		J.mc(v_g_226, "stroke", [])
	J.sp(v_g_226, "lineWidth", 2.6)
	for _t222 in J.iter([44.0, 84.0, 108.0]):
		v_y_235 = _t222
		J.mc(v_g_226, "beginPath", [])
		J.mc(v_g_226, "moveTo", [40.0, v_y_235])
		J.mc(v_g_226, "lineTo", [54.0, J.sub(v_y_235, 4.0)])
		J.mc(v_g_226, "stroke", [])
		J.mc(v_g_226, "beginPath", [])
		J.mc(v_g_226, "moveTo", [10.0, J.add(v_y_235, 6.0)])
		J.mc(v_g_226, "lineTo", [22.0, J.add(v_y_235, 10.0)])
		J.mc(v_g_226, "stroke", [])
	J.sp(v_g_226, "lineWidth", 3.0)
	J.mc(v_g_226, "beginPath", [])
	J.mc(v_g_226, "moveTo", [18.0, 126.0])
	J.mc(v_g_226, "lineTo", [46.0, 126.0])
	J.mc(v_g_226, "lineTo", [46.0, 146.0])
	J.mc(v_g_226, "lineTo", [18.0, 146.0])
	J.mc(v_g_226, "closePath", [])
	J.mc(v_g_226, "stroke", [])
	J.mc(v_g_226, "beginPath", [])
	J.mc(v_g_226, "moveTo", [18.0, 126.0])
	J.mc(v_g_226, "lineTo", [46.0, 146.0])
	J.mc(v_g_226, "moveTo", [46.0, 126.0])
	J.mc(v_g_226, "lineTo", [18.0, 146.0])
	J.mc(v_g_226, "stroke", [])
	env["FU"] = v_cv_225
	return env["FU"]

func _f52(this_, a: Array, env):
	var v_c_238 = null; var v_x_239 = null; var v_y_240 = null; var v_w_241 = null; var v_h_242 = null; var v_t_243 = null; var v_seed_244 = null; var v_alpha_245 = null; var v_im_246 = null; var v_n_247 = null; var v_sh_248 = null; var v_k_249 = null; var v_e_250 = null; var v_off_251 = null; var v_sk_252 = null
	v_c_238 = J.arg(a, 0)
	v_x_239 = J.arg(a, 1)
	v_y_240 = J.arg(a, 2)
	v_w_241 = J.arg(a, 3)
	v_h_242 = J.arg(a, 4)
	v_t_243 = J.arg(a, 5)
	v_seed_244 = J.arg(a, 6)
	v_alpha_245 = J.arg(a, 7)
	v_im_246 = J.cl(env["fuCanvas"], null, [])
	J.mc(v_c_238, "save", [])
	var _t223 = J.mul(J.gp(v_c_238, "globalAlpha"), (1.0 if J.leq(v_alpha_245, null) else v_alpha_245))
	J.sp(v_c_238, "globalAlpha", _t223)
	v_n_247 = 18.0
	v_sh_248 = J.div(v_h_242, v_n_247)
	v_k_249 = 0.0
	while true:
		if not J.cmp(v_k_249, v_n_247, "<"): break
		v_e_250 = J.div(v_k_249, J.sub(v_n_247, 1.0))
		v_off_251 = J.mul(J.mul((J.mul(sin(J.num(J.sub(J.add(J.mul(v_t_243, 5.5), v_seed_244), J.mul(v_k_249, 0.32)))), v_w_241) * 0.13), v_e_250), v_e_250)
		v_sk_252 = (1.0 - (J.mul(0.06, v_e_250) * absf(J.num(sin(J.num(J.add(J.add(J.mul(v_t_243, 3.0), v_seed_244), J.mul(v_k_249, 0.3))))))))
		if J.t(v_im_246):
			J.mc(v_c_238, "drawImage", [v_im_246, 0.0, J.div(J.mul(v_k_249, 160.0), v_n_247), 64.0, (J.div(160.0, v_n_247) + 0.5), J.add(J.sub(v_x_239, J.div(J.mul(v_w_241, v_sk_252), 2.0)), v_off_251), J.add(v_y_240, J.mul(v_k_249, v_sh_248)), J.mul(v_w_241, v_sk_252), J.add(v_sh_248, 0.8)])
		else:
			J.sp(v_c_238, "fillStyle", "#f2cf45")
			J.mc(v_c_238, "fillRect", [J.add(J.sub(v_x_239, J.div(J.mul(v_w_241, v_sk_252), 2.0)), v_off_251), J.add(v_y_240, J.mul(v_k_249, v_sh_248)), J.mul(v_w_241, v_sk_252), J.add(v_sh_248, 0.8)])
		v_k_249 = J.num(v_k_249) + 1.0
	J.mc(v_c_238, "restore", [])

func _f53(this_, a: Array, env):
	var v_c_255 = null; var v_ax_256 = null; var v_ay_257 = null; var v_bx_258 = null; var v_by_259 = null; var v_U_260 = null; var v_t_261 = null; var v_L_262 = null; var v_n_263 = null; var v_ang_264 = null; var v_j_265 = null; var v_k_266 = null; var v_x_267 = null; var v_y_268 = null
	v_c_255 = J.arg(a, 0)
	v_ax_256 = J.arg(a, 1)
	v_ay_257 = J.arg(a, 2)
	v_bx_258 = J.arg(a, 3)
	v_by_259 = J.arg(a, 4)
	v_U_260 = J.arg(a, 5)
	v_t_261 = J.arg(a, 6)
	v_L_262 = J.hypot_([J.sub(v_bx_258, v_ax_256), J.sub(v_by_259, v_ay_257)])
	v_n_263 = J.max_([3.0, floor(J.num(J.div(v_L_262, J.mul(9.0, v_U_260))))])
	v_ang_264 = atan2(J.num(J.sub(v_by_259, v_ay_257)), J.num(J.sub(v_bx_258, v_ax_256)))
	v_j_265 = 0.0
	while true:
		if not J.cmp(v_j_265, v_n_263, "<="): break
		v_k_266 = J.div(v_j_265, v_n_263)
		v_x_267 = J.add(v_ax_256, J.mul(J.sub(v_bx_258, v_ax_256), v_k_266))
		v_y_268 = J.add(J.add(v_ay_257, J.mul(J.sub(v_by_259, v_ay_257), v_k_266)), J.mul((sin(J.num(J.mul(v_k_266, PI))) * 4.0), v_U_260))
		J.mc(v_c_255, "save", [])
		J.mc(v_c_255, "translate", [v_x_267, v_y_268])
		J.mc(v_c_255, "rotate", [v_ang_264])
		var _t224 = J.mul(2.6, v_U_260)
		J.sp(v_c_255, "lineWidth", _t224)
		J.sp(v_c_255, "strokeStyle", "#5a3c08")
		J.mc(v_c_255, "beginPath", [])
		if J.t(J.mod(v_j_265, 2.0)):
			J.mc(v_c_255, "ellipse", [0.0, 0.0, J.mul(5.5, v_U_260), J.mul(1.6, v_U_260), 0.0, 0.0, 7.0])
		else:
			J.mc(v_c_255, "ellipse", [0.0, 0.0, J.mul(5.5, v_U_260), J.mul(3.4, v_U_260), 0.0, 0.0, 7.0])
		J.mc(v_c_255, "stroke", [])
		var _t225 = J.mul(1.6, v_U_260)
		J.sp(v_c_255, "lineWidth", _t225)
		var _t226 = ("hsl(45,95%," + J.str((58.0 + (12.0 * sin(J.num(J.add(J.mul(v_t_261, 4.0), v_j_265)))))) + "%)")
		J.sp(v_c_255, "strokeStyle", _t226)
		J.mc(v_c_255, "stroke", [])
		J.mc(v_c_255, "restore", [])
		v_j_265 = J.num(v_j_265) + 1.0

func _f55(this_, a: Array, env):
	var v_W_278 = null; var v_i_279 = null; var v_sp_280 = null; var v_b_281 = null; var v_q_282 = null
	v_W_278 = J.arg(a, 0)
	v_i_279 = J.arg(a, 1)
	v_sp_280 = J.gp(J.gp(J.gp(v_W_278, "lay"), "posts"), v_i_279)
	v_b_281 = J.gp(v_W_278, "box")
	if (not J.t(v_sp_280)):
		return null
	v_q_282 = (J.mc(v_W_278, "rect", [v_sp_280]) if J.t(J.gp(v_W_278, "rect")) else [J.sub(J.gp(v_sp_280, "x"), J.div(env["CELL"], 2.0)), J.sub(J.gp(v_sp_280, "y"), J.div(env["CELL"], 3.0)), J.add(J.gp(v_sp_280, "x"), J.div(env["CELL"], 2.0)), J.add(J.gp(v_sp_280, "y"), J.div(env["CELL"], 3.0))])
	return [J.add(J.gp(v_b_281, "x"), J.mul(J.gp(v_q_282, 0.0), J.gp(v_b_281, "w"))), J.add(J.gp(v_b_281, "y"), J.mul(J.gp(v_q_282, 1.0), J.gp(v_b_281, "h"))), J.mul(J.sub(J.gp(v_q_282, 2.0), J.gp(v_q_282, 0.0)), J.gp(v_b_281, "w")), J.mul(J.sub(J.gp(v_q_282, 3.0), J.gp(v_q_282, 1.0)), J.gp(v_b_281, "h"))]

func _f57(this_, a: Array, env):
	var v_sp_398 = null
	v_sp_398 = J.gp(J.gp(J.gp(env["__p"]["W"], "lay"), "posts"), J.gp(J.gp(env["F"], "chant"), "i"))
	return (J.mc(env["__p"]["W"], "P", [J.gp(v_sp_398, "x"), J.gp(v_sp_398, "y")]) if J.t(v_sp_398) else v_sp_398)

func _f58(this_, a: Array, env):
	var v_k_399 = null
	v_k_399 = J.arg(a, 0)
	var _t340 = (not J.seq(v_k_399, "other"))
	return (J.cmp(J.gp(J.gp(env["F"], "by"), v_k_399), 0.0, ">") if _t340 else _t340)

func _f56(this_, a: Array, env):
	var v_c_285 = null; var v_b_287 = null; var v_U_288 = null; var v_hh_289 = null; var v_t_290 = null; var v_f_291 = null; var v_cx_292 = null; var v_cy_293 = null; var v_fade_294 = null; var v_land_295 = null; var v_ax_296 = null; var v_ay_297 = null; var v_g_298 = null; var v_k_299 = null; var v_x_300 = null; var v_y_301 = null; var v_g_302 = null; var v_tw_303 = null; var v_B_304 = null; var v_w_305 = null; var v_pos_306 = null; var v_x_307 = null; var v_y_308 = null; var v_k_309 = null; var v_al_310 = null; var v_r_311 = null; var v_g_312 = null; var v_w_313 = null; var v_x_314 = null; var v_y_315 = null; var v_r_316 = null; var v_pu_317 = null; var v_g_318 = null; var v_q_319 = null; var v_qx_320 = null; var v_qy_321 = null; var v_p_322 = null; var v_v_323 = null; var v_rc_324 = null; var v_x0_325 = null; var v_y0_326 = null; var v_cw_327 = null; var v_ch_328 = null; var v_left_329 = null; var v_p_330 = null; var v_v_331 = null; var v_rc_332 = null; var v_x0_333 = null; var v_y0_334 = null; var v_cw_335 = null; var v_ch_336 = null; var v_left_337 = null; var v_oy_338 = null; var v_bw_339 = null; var v_s_340 = null; var v_left_341 = null; var v_pop_342 = null; var v_endBlink_343 = null; var v_rc_344 = null; var v_x0_345 = null; var v_y0_346 = null; var v_cw_347 = null; var v_ch_348 = null; var v_cx_349 = null; var v_SI_350 = null; var v_named_351 = null; var v_H0_352 = null; var v_sc_353 = null; var v_hW_354 = null; var v_g_355 = null; var v_fw_356 = null; var v_fh_357 = null; var v_bx_358 = null; var v_by_359 = null; var v_br_360 = null; var v_x_361 = null; var v_y_362 = null; var v_top_363 = null; var v_fw_364 = null; var v_SI_365 = null; var v_H0_366 = null; var v_hW_367 = null; var v_f_368 = null; var v_SI_369 = null; var v_k_370 = null; var v_e_371 = null; var v_px_372 = null; var v_py_373 = null; var v_rc_374 = null; var v_cx_375 = null; var v_cy_376 = null; var v_H0_377 = null; var v_hW_378 = null; var v_iw_379 = null; var v_ih_380 = null; var v_sd_381 = null; var v_sx_382 = null; var v_j_383 = null; var v_a_384 = null; var v_d_385 = null; var v_w_386 = null; var v_C_388 = null; var v_x_389 = null; var v_y_390 = null; var v_used_391 = null; var v_k_392 = null; var v_cy_393 = null; var v_r_394 = null; var v_jx_395 = null; var v_tg_396 = null; var v_j_397 = null; var v_px_400 = null; var v_py_401 = null; var v_j_402 = null
	var _s114 = {"__p": env, "W": null}
	v_c_285 = J.arg(a, 0)
	_s114["W"] = J.arg(a, 1)
	v_b_287 = J.gp(_s114["W"], "box")
	v_U_288 = J.div(J.gp(v_b_287, "w"), 840.0)
	v_hh_289 = J.mul(J.gp(v_b_287, "h"), 0.042)
	v_t_290 = J.cl(_s114["__p"]["now"], null, [])
	J.mc(v_c_285, "save", [])
	for _t227 in J.iter(J.gp(_s114["__p"]["S"], "saltFx")):
		v_f_291 = _t227
		var _t228 = J.mc(_s114["W"], "P", [J.gp(v_f_291, "x"), J.gp(v_f_291, "y")])
		var _t229 = J.gp(_t228, 0.0)
		v_cx_292 = _t229
		var _t230 = J.gp(_t228, 1.0)
		v_cy_293 = _t230
		v_fade_294 = J.min_([1.0, J.div(J.sub(J.gp(v_f_291, "dur"), J.gp(v_f_291, "t")), 0.8)])
		v_land_295 = J.min_([1.0, J.div(J.gp(v_f_291, "t"), 0.35)])
		if J.cmp(v_land_295, 1.0, "<"):
			var _t231 = J.mc(_s114["W"], "P", [J.gp(v_f_291, "fx"), J.gp(v_f_291, "fy")])
			var _t232 = J.gp(_t231, 0.0)
			v_ax_296 = _t232
			var _t233 = J.gp(_t231, 1.0)
			v_ay_297 = _t233
			for _t234 in J.iter(J.gp(v_f_291, "gr")):
				v_g_298 = _t234
				v_k_299 = J.min_([1.0, J.mul(v_land_295, (0.8 + J.mul(J.gp(v_g_298, 2.0), 0.4)))])
				v_x_300 = J.add(v_ax_296, J.mul(J.sub(J.add(v_cx_292, J.mul(J.gp(v_g_298, 0.0), J.gp(v_b_287, "w"))), v_ax_296), v_k_299))
				v_y_301 = J.sub(J.add(v_ay_297, J.mul(J.sub(J.add(v_cy_293, J.mul(J.gp(v_g_298, 1.0), J.gp(v_b_287, "w"))), v_ay_297), v_k_299)), J.mul((sin(J.num(J.mul(v_k_299, PI))) * 40.0), v_U_288))
				J.sp(v_c_285, "fillStyle", "rgba(255,255,255,0.95)")
				J.mc(v_c_285, "fillRect", [J.sub(v_x_300, J.mul(1.5, v_U_288)), J.sub(v_y_301, J.mul(1.5, v_U_288)), J.mul(3.0, v_U_288), J.mul(3.0, v_U_288)])
			continue
		var _t235 = ("rgba(230,240,255," + J.str(J.mul(0.1, v_fade_294)) + ")")
		J.sp(v_c_285, "fillStyle", _t235)
		J.mc(v_c_285, "beginPath", [])
		J.mc(v_c_285, "ellipse", [v_cx_292, v_cy_293, J.mul(J.gp(v_f_291, "r"), J.gp(v_b_287, "w")), J.div(J.mul(J.gp(v_f_291, "r"), J.gp(v_b_287, "w")), 1.5), 0.0, 0.0, 7.0])
		J.mc(v_c_285, "fill", [])
		var _t236 = ("rgba(240,248,255," + J.str(J.mul(0.35, v_fade_294)) + ")")
		J.sp(v_c_285, "strokeStyle", _t236)
		J.mc(v_c_285, "setLineDash", [[J.mul(2.0, v_U_288), J.mul(5.0, v_U_288)]])
		var _t237 = J.mul(1.5, v_U_288)
		J.sp(v_c_285, "lineWidth", _t237)
		J.mc(v_c_285, "stroke", [])
		J.mc(v_c_285, "setLineDash", [[]])
		for _t238 in J.iter(J.gp(v_f_291, "gr")):
			v_g_302 = _t238
			v_tw_303 = (0.55 + (0.45 * sin(J.num((J.mul(v_t_290, 6.0) + J.mul(J.gp(v_g_302, 2.0), 20.0))))))
			var _t239 = (("rgba(240,220,170," + J.str(J.mul(J.mul(0.9, v_fade_294), v_tw_303)) + ")") if J.cmp(J.gp(v_g_302, 2.0), 0.35, "<") else ("rgba(255,255,255," + J.str(J.mul(J.mul(0.95, v_fade_294), v_tw_303)) + ")"))
			J.sp(v_c_285, "fillStyle", _t239)
			J.mc(v_c_285, "beginPath", [])
			J.mc(v_c_285, "arc", [J.add(v_cx_292, J.mul(J.gp(v_g_302, 0.0), J.gp(v_b_287, "w"))), J.add(v_cy_293, J.mul(J.gp(v_g_302, 1.0), J.gp(v_b_287, "w"))), J.mul((2.2 if J.cmp(J.gp(v_g_302, 2.0), 0.35, "<") else 1.7), v_U_288), 0.0, 7.0])
			J.mc(v_c_285, "fill", [])
	for _t240 in J.iter(J.gp(_s114["__p"]["S"], "beams")):
		v_B_304 = _t240
		v_w_305 = J.gp(v_B_304, "w")
		v_pos_306 = (J.mc(_s114["W"], "wp", [v_w_305]) if J.t(((not J.t(J.gp(v_w_305, "gone"))) if J.t(v_w_305) else v_w_305)) else [J.gp(v_B_304, "x"), J.gp(v_B_304, "y")])
		var _t241 = J.mc(_s114["W"], "P", [J.gp(v_pos_306, 0.0), J.sub(J.gp(v_pos_306, 1.0), 0.012)])
		var _t242 = J.gp(_t241, 0.0)
		v_x_307 = _t242
		var _t243 = J.gp(_t241, 1.0)
		v_y_308 = _t243
		v_k_309 = J.div(J.gp(v_B_304, "t"), J.gp(v_B_304, "dur"))
		v_al_310 = ((J.div(v_k_309, 0.15) if J.cmp(v_k_309, 0.15, "<") else (1.0 - J.div(J.max_([0.0, J.sub(v_k_309, 0.6)]), 0.4))) * (0.85 + (0.15 * sin(J.num(J.mul(v_t_290, 30.0))))))
		v_r_311 = J.mul(J.gp(v_B_304, "r"), J.gp(v_b_287, "w"))
		J.mc(v_c_285, "save", [])
		J.mc(v_c_285, "translate", [v_x_307, v_y_308])
		J.mc(v_c_285, "scale", [1.0, J.div(1.0, 1.5)])
		v_g_312 = J.mc(v_c_285, "createRadialGradient", [0.0, 0.0, J.mul(4.0, v_U_288), 0.0, 0.0, v_r_311])
		J.mc(v_g_312, "addColorStop", [0.0, ("rgba(255,252,215," + J.str(J.mul(0.75, v_al_310)) + ")")])
		J.mc(v_g_312, "addColorStop", [0.6, ("rgba(255,248,190," + J.str(J.mul(0.32, v_al_310)) + ")")])
		J.mc(v_g_312, "addColorStop", [1.0, "rgba(255,245,180,0)"])
		J.sp(v_c_285, "fillStyle", v_g_312)
		J.mc(v_c_285, "beginPath", [])
		J.mc(v_c_285, "moveTo", [0.0, 0.0])
		J.mc(v_c_285, "arc", [0.0, 0.0, v_r_311, J.sub(J.gp(v_B_304, "dir"), J.gp(v_B_304, "half")), J.add(J.gp(v_B_304, "dir"), J.gp(v_B_304, "half"))])
		J.mc(v_c_285, "closePath", [])
		J.mc(v_c_285, "fill", [])
		var _t244 = ("rgba(255,250,210," + J.str(J.mul(0.5, v_al_310)) + ")")
		J.sp(v_c_285, "strokeStyle", _t244)
		var _t245 = J.mul(2.0, v_U_288)
		J.sp(v_c_285, "lineWidth", _t245)
		J.mc(v_c_285, "beginPath", [])
		J.mc(v_c_285, "moveTo", [0.0, 0.0])
		J.mc(v_c_285, "lineTo", [J.mul(cos(J.num(J.sub(J.gp(v_B_304, "dir"), J.gp(v_B_304, "half")))), v_r_311), J.mul(sin(J.num(J.sub(J.gp(v_B_304, "dir"), J.gp(v_B_304, "half")))), v_r_311)])
		J.mc(v_c_285, "moveTo", [0.0, 0.0])
		J.mc(v_c_285, "lineTo", [J.mul(cos(J.num(J.add(J.gp(v_B_304, "dir"), J.gp(v_B_304, "half")))), v_r_311), J.mul(sin(J.num(J.add(J.gp(v_B_304, "dir"), J.gp(v_B_304, "half")))), v_r_311)])
		J.mc(v_c_285, "stroke", [])
		J.mc(v_c_285, "restore", [])
	for _t246 in J.iter(J.gp(_s114["W"], "walkers")):
		v_w_313 = _t246
		var _t247 = (not J.t(J.gp(v_w_313, "foe")))
		var _t248 = (_t247 if _t247 else (not J.seq(J.gp(J.gp(v_w_313, "foe"), "id"), "streamer")))
		if (_t248 if _t248 else (not J.t(J.mc(_s114["W"], "alive", [v_w_313])))):
			continue
		var _t249 = J.mc(_s114["W"], "P", J.spread([J.SP(J.mc(_s114["W"], "wp", [v_w_313]))]))
		var _t250 = J.gp(_t249, 0.0)
		v_x_314 = _t250
		var _t251 = J.gp(_t249, 1.0)
		v_y_315 = _t251
		v_r_316 = J.mul(J.mul(J.gp(J.gp(J.gp(_s114["__p"]["FOES"], "streamer"), "aura"), "r"), _s114["__p"]["PX"]), J.gp(v_b_287, "w"))
		v_pu_317 = (0.8 + (0.2 * sin(J.num(J.mul(v_t_290, 3.0)))))
		v_g_318 = J.mc(v_c_285, "createRadialGradient", [v_x_314, v_y_315, J.mul(v_r_316, 0.2), v_x_314, v_y_315, v_r_316])
		J.mc(v_g_318, "addColorStop", [0.0, "rgba(255,150,210,0)"])
		J.mc(v_g_318, "addColorStop", [0.75, ("rgba(255,150,210," + J.str(J.mul(0.12, v_pu_317)) + ")")])
		J.mc(v_g_318, "addColorStop", [1.0, "rgba(255,150,210,0)"])
		J.sp(v_c_285, "fillStyle", v_g_318)
		J.mc(v_c_285, "beginPath", [])
		J.mc(v_c_285, "ellipse", [v_x_314, v_y_315, v_r_316, J.div(v_r_316, 1.5), 0.0, 0.0, 7.0])
		J.mc(v_c_285, "fill", [])
		var _t252 = ("rgba(255,170,220," + J.str(J.mul(0.55, v_pu_317)) + ")")
		J.sp(v_c_285, "strokeStyle", _t252)
		var _t253 = J.mul(2.0, v_U_288)
		J.sp(v_c_285, "lineWidth", _t253)
		J.mc(v_c_285, "setLineDash", [[J.mul(6.0, v_U_288), J.mul(5.0, v_U_288)]])
		var _t254 = ((-J.num(v_t_290)) * 20.0)
		J.sp(v_c_285, "lineDashOffset", _t254)
		J.mc(v_c_285, "beginPath", [])
		J.mc(v_c_285, "ellipse", [v_x_314, v_y_315, v_r_316, J.div(v_r_316, 1.5), 0.0, 0.0, 7.0])
		J.mc(v_c_285, "stroke", [])
		J.mc(v_c_285, "setLineDash", [[]])
		for _t255 in J.iter(J.gp(_s114["W"], "walkers")):
			v_q_319 = _t255
			var _t256 = J.seq(v_q_319, v_w_313)
			var _t257 = (_t256 if _t256 else J.gp(v_q_319, "foe"))
			var _t258 = (_t257 if J.t(_t257) else (not J.t(J.mc(_s114["W"], "alive", [v_q_319]))))
			if J.t((_t258 if J.t(_t258) else J.cmp(J.mc(_s114["W"], "dist", [J.mc(_s114["W"], "wp", [v_q_319]), J.mc(_s114["W"], "wp", [v_w_313])]), J.mul(J.gp(J.gp(J.gp(_s114["__p"]["FOES"], "streamer"), "aura"), "r"), _s114["__p"]["PX"]), ">="))):
				continue
			var _t259 = J.mc(_s114["W"], "P", J.spread([J.SP(J.mc(_s114["W"], "wp", [v_q_319]))]))
			var _t260 = J.gp(_t259, 0.0)
			v_qx_320 = _t260
			var _t261 = J.gp(_t259, 1.0)
			v_qy_321 = _t261
			var _t262 = _s114["__p"]["bigTxt"]
			J.cl(_t262, null, [v_c_285, "膽+30%", v_qx_320, (J.sub(v_qy_321, v_hh_289) - J.mul(20.0, v_U_288)), J.mul(9.0, v_U_288), "#ffb0dc"])
	for _t263 in J.iter(J.gp(_s114["__p"]["S"], "pause")):
		var _t264 = J.gp(_t263, 0.0)
		v_p_322 = _t264
		var _t265 = J.gp(_t263, 1.0)
		v_v_323 = _t265
		var _t266 = _s114["__p"]["devRect"]
		v_rc_324 = J.cl(_t266, null, [_s114["W"], J.gp(v_v_323, "i")])
		var _t268 = (not J.t(v_rc_324))
		if not J.t(_t268):
			var _t267 = _s114["__p"]["isSealed"]
			_t268 = J.cl(_t267, null, [v_p_322])
		if J.t(_t268):
			continue
		var _t269 = J.gp(v_rc_324, 0.0)
		v_x0_325 = _t269
		var _t270 = J.gp(v_rc_324, 1.0)
		v_y0_326 = _t270
		var _t271 = J.gp(v_rc_324, 2.0)
		v_cw_327 = _t271
		var _t272 = J.gp(v_rc_324, 3.0)
		v_ch_328 = _t272
		v_left_329 = J.sub(J.gp(v_v_323, "dur"), J.gp(v_v_323, "t"))
		var _t273 = ("rgba(255,250,205," + J.str((0.38 + (0.1 * sin(J.num(J.mul(v_t_290, 12.0)))))) + ")")
		J.sp(v_c_285, "fillStyle", _t273)
		J.mc(v_c_285, "fillRect", [v_x0_325, v_y0_326, v_cw_327, v_ch_328])
		J.sp(v_c_285, "strokeStyle", "#fff6c0")
		var _t274 = J.mul(2.5, v_U_288)
		J.sp(v_c_285, "lineWidth", _t274)
		J.mc(v_c_285, "strokeRect", [v_x0_325, v_y0_326, v_cw_327, v_ch_328])
		var _t275 = _s114["__p"]["bigTxt"]
		var _t276 = _s114["__p"]["T"]
		J.cl(_t275, null, [v_c_285, J.add(J.add(J.cl(_t276, null, ["暫停", "暫停"]), " "), ceil(J.num(v_left_329))), J.add(v_x0_325, J.div(v_cw_327, 2.0)), J.add(v_y0_326, J.mul(v_ch_328, 0.62)), J.mul(12.0, v_U_288), "#fff3a0"])
	for _t277 in J.iter(J.gp(_s114["__p"]["S"], "salt")):
		var _t278 = J.gp(_t277, 0.0)
		v_p_330 = _t278
		var _t279 = J.gp(_t277, 1.0)
		v_v_331 = _t279
		var _t280 = _s114["__p"]["devRect"]
		v_rc_332 = J.cl(_t280, null, [_s114["W"], J.gp(v_v_331, "i")])
		if (not J.t(v_rc_332)):
			continue
		var _t281 = J.gp(v_rc_332, 0.0)
		v_x0_333 = _t281
		var _t282 = J.gp(v_rc_332, 1.0)
		v_y0_334 = _t282
		var _t283 = J.gp(v_rc_332, 2.0)
		v_cw_335 = _t283
		var _t284 = J.gp(v_rc_332, 3.0)
		v_ch_336 = _t284
		v_left_337 = J.sub(J.gp(v_v_331, "dur"), J.gp(v_v_331, "t"))
		var _t285 = ("rgba(255,255,255," + J.str((0.6 + (0.3 * sin(J.num(J.mul(v_t_290, 8.0)))))) + ")")
		J.sp(v_c_285, "strokeStyle", _t285)
		J.mc(v_c_285, "setLineDash", [[J.mul(3.0, v_U_288), J.mul(3.0, v_U_288)]])
		var _t286 = J.mul(2.0, v_U_288)
		J.sp(v_c_285, "lineWidth", _t286)
		J.mc(v_c_285, "strokeRect", [J.sub(v_x0_333, J.mul(3.0, v_U_288)), J.sub(v_y0_334, J.mul(3.0, v_U_288)), J.add(v_cw_335, J.mul(6.0, v_U_288)), J.add(v_ch_336, J.mul(6.0, v_U_288))])
		J.mc(v_c_285, "setLineDash", [[]])
		var _t287 = _s114["__p"]["isSealed"]
		v_oy_338 = (J.mul(18.0, v_U_288) if J.t(J.cl(_t287, null, [v_p_330])) else 0.0)
		J.sp(v_c_285, "fillStyle", "rgba(20,24,36,0.82)")
		v_bw_339 = J.mul(52.0, v_U_288)
		J.mc(v_c_285, "fillRect", [J.sub(J.add(v_x0_333, J.div(v_cw_335, 2.0)), J.div(v_bw_339, 2.0)), J.add(J.add(J.add(v_y0_334, v_ch_336), J.mul(2.0, v_U_288)), v_oy_338), v_bw_339, J.mul(13.0, v_U_288)])
		var _t288 = ("bold " + J.str(J.mul(9.5, v_U_288)) + "px sans-serif")
		J.sp(v_c_285, "font", _t288)
		J.sp(v_c_285, "textAlign", "center")
		J.sp(v_c_285, "fillStyle", "#f4f8ff")
		var _t289 = _s114["__p"]["T"]
		J.mc(v_c_285, "fillText", [(J.str(J.cl(_t289, null, ["鹽米", "鹽米"])) + " −40% " + J.str(ceil(J.num(v_left_337)))), J.add(v_x0_333, J.div(v_cw_335, 2.0)), J.add(J.add(J.add(v_y0_334, v_ch_336), J.mul(12.0, v_U_288)), v_oy_338)])
	for _t290 in J.iter(J.gp(_s114["__p"]["S"], "seals")):
		v_s_340 = _t290
		v_left_341 = J.sub(J.gp(v_s_340, "dur"), J.gp(v_s_340, "t"))
		v_pop_342 = J.min_([1.0, J.div(J.gp(v_s_340, "t"), 0.25)])
		v_endBlink_343 = ((0.6 + (0.4 * sin(J.num(J.mul(v_t_290, 18.0))))) if J.cmp(v_left_341, 1.5, "<") else 1.0)
		if J.seq(J.gp(v_s_340, "kind"), "dev"):
			var _t291 = _s114["__p"]["devRect"]
			v_rc_344 = J.cl(_t291, null, [_s114["W"], J.gp(v_s_340, "i")])
			if (not J.t(v_rc_344)):
				continue
			var _t292 = J.gp(v_rc_344, 0.0)
			v_x0_345 = _t292
			var _t293 = J.gp(v_rc_344, 1.0)
			v_y0_346 = _t293
			var _t294 = J.gp(v_rc_344, 2.0)
			v_cw_347 = _t294
			var _t295 = J.gp(v_rc_344, 3.0)
			v_ch_348 = _t295
			v_cx_349 = J.add(v_x0_345, J.div(v_cw_347, 2.0))
			J.sp(v_c_285, "fillStyle", "rgba(40,24,0,0.5)")
			J.mc(v_c_285, "fillRect", [v_x0_345, v_y0_346, v_cw_347, v_ch_348])
			v_SI_350 = J.cl(_s114["__p"]["sealIm"], null, [])
			if J.t(v_SI_350):
				v_H0_352 = (J.max_([J.mul(v_ch_348, 1.25), J.mul(v_cw_347, 0.95)]) * J.min_([1.3, J.max_([0.9, 1.0])]))
				v_sc_353 = (((1.5 - J.mul(0.5, v_pop_342)) + (sin(J.num(J.mul(v_pop_342, PI))) * 0.12)) if J.cmp(v_pop_342, 1.0, "<") else (1.0 + (sin(J.num(J.add(J.mul(v_t_290, 2.2), J.gp(v_s_340, "seed")))) * 0.025)))
				v_hW_354 = J.div(J.mul(v_H0_352, J.gp(v_SI_350, "naturalWidth")), J.gp(v_SI_350, "naturalHeight"))
				J.mc(v_c_285, "save", [])
				var _t296 = J.mul(J.min_([1.0, J.mul(v_pop_342, 1.5)]), v_endBlink_343)
				J.sp(v_c_285, "globalAlpha", _t296)
				J.mc(v_c_285, "translate", [v_cx_349, J.add(v_y0_346, J.mul(v_ch_348, 0.5))])
				J.mc(v_c_285, "rotate", [(sin(J.num(J.add(J.mul(v_t_290, 1.6), J.gp(v_s_340, "seed")))) * 0.04)])
				J.mc(v_c_285, "scale", [v_sc_353, v_sc_353])
				v_g_355 = J.mc(v_c_285, "createRadialGradient", [0.0, 0.0, J.mul(4.0, v_U_288), 0.0, 0.0, J.mul(v_H0_352, 0.62)])
				J.mc(v_g_355, "addColorStop", [0.0, ("rgba(255,215,90," + J.str((0.32 + (0.12 * sin(J.num(J.mul(v_t_290, 4.0)))))) + ")")])
				J.mc(v_g_355, "addColorStop", [1.0, "rgba(255,215,90,0)"])
				J.sp(v_c_285, "fillStyle", v_g_355)
				J.mc(v_c_285, "beginPath", [])
				J.mc(v_c_285, "arc", [0.0, 0.0, J.mul(v_H0_352, 0.62), 0.0, 7.0])
				J.mc(v_c_285, "fill", [])
				J.mc(v_c_285, "drawImage", [v_SI_350, J.div((-J.num(v_hW_354)), 2.0), J.div((-J.num(v_H0_352)), 2.0), v_hW_354, v_H0_352])
				J.mc(v_c_285, "restore", [])
			else:
				J.mc(v_c_285, "save", [])
				J.sp(v_c_285, "globalAlpha", v_endBlink_343)
				var _t297 = _s114["__p"]["chainLine"]
				J.cl(_t297, null, [v_c_285, J.sub(v_x0_345, J.mul(4.0, v_U_288)), J.add(v_y0_346, J.mul(4.0, v_U_288)), J.add(J.add(v_x0_345, v_cw_347), J.mul(4.0, v_U_288)), J.sub(J.add(v_y0_346, v_ch_348), J.mul(4.0, v_U_288)), v_U_288, v_t_290])
				var _t298 = _s114["__p"]["chainLine"]
				J.cl(_t298, null, [v_c_285, J.add(J.add(v_x0_345, v_cw_347), J.mul(4.0, v_U_288)), J.add(v_y0_346, J.mul(4.0, v_U_288)), J.sub(v_x0_345, J.mul(4.0, v_U_288)), J.sub(J.add(v_y0_346, v_ch_348), J.mul(4.0, v_U_288)), v_U_288, J.add(v_t_290, 1.0)])
				J.mc(v_c_285, "restore", [])
				v_fw_356 = J.mul(J.min_([J.mul(v_cw_347, 0.42), J.mul(30.0, v_U_288)]), v_pop_342)
				v_fh_357 = J.mul(v_fw_356, 2.5)
				var _t299 = _s114["__p"]["drawFu"]
				J.cl(_t299, null, [v_c_285, v_cx_349, J.sub(v_y0_346, J.mul(v_fh_357, 0.32)), v_fw_356, v_fh_357, v_t_290, J.gp(v_s_340, "seed"), v_endBlink_343])
			var _t300 = J.gp(v_s_340, "tgt")
			var _t301 = ((not J.leq(J.gp(J.gp(v_s_340, "tgt"), "staff"), null)) if J.t(_t300) else _t300)
			var _t302 = (J.gp(_s114["W"], "staffMul") if J.t(_t301) else _t301)
			v_named_351 = (J.gp(J.mc(_s114["W"], "staffMul", [J.gp(v_s_340, "tgt")]), "named") if J.t(_t302) else _t302)
			v_bx_358 = J.add(J.add(v_x0_345, v_cw_347), J.mul(2.0, v_U_288))
			v_by_359 = J.add(v_y0_346, J.mul(2.0, v_U_288))
			v_br_360 = J.mul(12.0, v_U_288)
			J.sp(v_c_285, "fillStyle", "rgba(40,20,0,0.9)")
			J.mc(v_c_285, "beginPath", [])
			J.mc(v_c_285, "arc", [v_bx_358, v_by_359, v_br_360, 0.0, 7.0])
			J.mc(v_c_285, "fill", [])
			J.sp(v_c_285, "strokeStyle", "#ffd45a")
			var _t303 = J.mul(2.5, v_U_288)
			J.sp(v_c_285, "lineWidth", _t303)
			J.mc(v_c_285, "beginPath", [])
			J.mc(v_c_285, "arc", [v_bx_358, v_by_359, v_br_360, J.div((-PI), 2.0), (J.div((-PI), 2.0) + J.div(J.mul(6.283, v_left_341), J.gp(v_s_340, "dur")))])
			J.mc(v_c_285, "stroke", [])
			var _t304 = _s114["__p"]["bigTxt"]
			J.cl(_t304, null, [v_c_285, J.F_String([ceil(J.num(v_left_341))]), v_bx_358, J.add(v_by_359, J.mul(6.0, v_U_288)), J.mul(17.0, v_U_288), "#ffd45a", "#2a1600"])
			var _t305 = _s114["__p"]["bigTxt"]
			var _t308 = null
			if J.t(v_named_351):
				var _t306 = _s114["__p"]["T"]
				_t308 = J.cl(_t306, null, [("名鬼被封印 " + J.str(ceil(J.num(v_left_341))) + " 秒"), ("名鬼被封印 " + J.str(ceil(J.num(v_left_341))) + " 秒")])
			else:
				var _t307 = _s114["__p"]["T"]
				_t308 = J.cl(_t307, null, ["封禁中", "封禁中"])
			J.cl(_t305, null, [v_c_285, _t308, v_cx_349, J.add(J.add(v_y0_346, v_ch_348), J.mul(14.0, v_U_288)), J.mul(10.0, v_U_288), "#ffe9a0"])
		else:
			if J.t(J.gp(_s114["W"], "bpos")):
				var _t309 = J.mc(_s114["W"], "P", J.spread([J.SP(J.mc(_s114["W"], "bpos", [J.gp(v_s_340, "tgt")]))]))
				var _t310 = J.gp(_t309, 0.0)
				v_x_361 = _t310
				var _t311 = J.gp(_t309, 1.0)
				v_y_362 = _t311
				v_top_363 = J.sub(v_y_362, J.mul(v_hh_289, 1.55))
				var _t312 = ("rgba(255,212,90," + J.str(J.mul(0.5, v_endBlink_343)) + ")")
				J.sp(v_c_285, "strokeStyle", _t312)
				var _t313 = J.mul(3.0, v_U_288)
				J.sp(v_c_285, "lineWidth", _t313)
				J.mc(v_c_285, "beginPath", [])
				J.mc(v_c_285, "ellipse", [v_x_361, v_y_362, J.mul(v_hh_289, 0.8), J.mul(v_hh_289, 0.26), 0.0, J.mul(v_t_290, 2.0), (J.mul(v_t_290, 2.0) + 5.2)])
				J.mc(v_c_285, "stroke", [])
				v_fw_364 = J.mul(J.mul(18.0, v_U_288), v_pop_342)
				v_SI_365 = J.cl(_s114["__p"]["sealIm"], null, [])
				if J.t(v_SI_365):
					v_H0_366 = J.mul(v_fw_364, 3.2)
					v_hW_367 = J.div(J.mul(v_H0_366, J.gp(v_SI_365, "naturalWidth")), J.gp(v_SI_365, "naturalHeight"))
					J.mc(v_c_285, "save", [])
					J.sp(v_c_285, "globalAlpha", v_endBlink_343)
					J.mc(v_c_285, "translate", [v_x_361, J.sub(v_top_363, J.mul(v_H0_366, 0.42))])
					J.mc(v_c_285, "rotate", [(sin(J.num(J.add(J.mul(v_t_290, 1.8), J.gp(v_s_340, "seed")))) * 0.06)])
					J.mc(v_c_285, "drawImage", [v_SI_365, J.div((-J.num(v_hW_367)), 2.0), J.div((-J.num(v_H0_366)), 2.0), v_hW_367, v_H0_366])
					J.mc(v_c_285, "restore", [])
				else:
					var _t314 = _s114["__p"]["drawFu"]
					J.cl(_t314, null, [v_c_285, v_x_361, J.sub(v_top_363, J.mul(v_fw_364, 2.4)), v_fw_364, J.mul(v_fw_364, 2.4), v_t_290, J.gp(v_s_340, "seed"), v_endBlink_343])
				var _t315 = _s114["__p"]["bigTxt"]
				var _t316 = _s114["__p"]["T"]
				J.cl(_t315, null, [v_c_285, J.cl(_t316, null, [("被封印 " + J.str(ceil(J.num(v_left_341))) + " 秒"), ("被封印 " + J.str(ceil(J.num(v_left_341))) + " 秒")]), v_x_361, J.sub(v_top_363, J.mul(v_fw_364, 2.6)), J.mul(12.0, v_U_288), "#ffd45a"])
	var _t318 = J.gp(_s114["__p"]["S"], "brk")
	for _t317 in J.iter((_t318 if J.t(_t318) else [])):
		v_f_368 = _t317
		v_SI_369 = J.cl(_s114["__p"]["sealIm"], null, [])
		v_k_370 = J.div(J.gp(v_f_368, "t"), J.gp(v_f_368, "dur"))
		v_e_371 = (1.0 - pow(J.num(J.sub(1.0, v_k_370)), J.num(2.0)))
		var _t319 = J.mc(_s114["W"], "P", [J.gp(v_f_368, "x"), J.gp(v_f_368, "y")])
		var _t320 = J.gp(_t319, 0.0)
		v_px_372 = _t320
		var _t321 = J.gp(_t319, 1.0)
		v_py_373 = _t321
		var _t323 = null
		if J.seq(J.gp(v_f_368, "kind"), "dev"):
			var _t322 = _s114["__p"]["devRect"]
			_t323 = J.cl(_t322, null, [_s114["W"], J.gp(v_f_368, "i")])
		else:
			_t323 = null
		v_rc_374 = _t323
		v_cx_375 = (J.add(J.gp(v_rc_374, 0.0), J.div(J.gp(v_rc_374, 2.0), 2.0)) if J.t(v_rc_374) else v_px_372)
		v_cy_376 = (J.add(J.gp(v_rc_374, 1.0), J.div(J.gp(v_rc_374, 3.0), 2.0)) if J.t(v_rc_374) else J.sub(v_py_373, J.mul(v_hh_289, 1.9)))
		v_H0_377 = (J.max_([J.mul(J.gp(v_rc_374, 3.0), 1.25), J.mul(J.gp(v_rc_374, 2.0), 0.95)]) if J.t(v_rc_374) else (J.mul(18.0, v_U_288) * 3.2))
		J.mc(v_c_285, "save", [])
		var _t324 = J.sub(1.0, v_k_370)
		J.sp(v_c_285, "globalAlpha", _t324)
		if J.t(v_SI_369):
			v_hW_378 = J.div(J.mul(v_H0_377, J.gp(v_SI_369, "naturalWidth")), J.gp(v_SI_369, "naturalHeight"))
			v_iw_379 = J.gp(v_SI_369, "naturalWidth")
			v_ih_380 = J.gp(v_SI_369, "naturalHeight")
			for _t325 in J.iter([(-1.0), 1.0]):
				v_sd_381 = _t325
				J.mc(v_c_285, "save", [])
				J.mc(v_c_285, "translate", [J.add(v_cx_375, (J.mul(J.mul(v_sd_381, v_e_371), v_H0_377) * 0.55)), (J.sub(v_cy_376, (J.mul(sin(J.num(J.mul(v_k_370, PI))), v_H0_377) * 0.25)) + (J.mul(v_e_371, v_H0_377) * 0.2))])
				J.mc(v_c_285, "rotate", [(J.mul(v_sd_381, v_e_371) * 0.9)])
				v_sx_382 = (0.0 if J.cmp(v_sd_381, 0.0, "<") else J.div(v_iw_379, 2.0))
				J.mc(v_c_285, "drawImage", [v_SI_369, v_sx_382, 0.0, J.div(v_iw_379, 2.0), v_ih_380, (J.div((-J.num(v_hW_378)), 2.0) if J.cmp(v_sd_381, 0.0, "<") else 0.0), J.div((-J.num(v_H0_377)), 2.0), J.div(v_hW_378, 2.0), v_H0_377])
				J.mc(v_c_285, "restore", [])
		v_j_383 = 0.0
		while true:
			if not J.cmp(v_j_383, 14.0, "<"): break
			v_a_384 = J.add(J.mul(v_j_383, 0.449), J.gp(v_f_368, "seed"))
			v_d_385 = (J.mul(v_e_371, v_H0_377) * (0.4 + (J.mod(v_j_383, 4.0) * 0.15)))
			var _t326 = (("rgba(255,214,90," + J.str(J.sub(1.0, v_k_370)) + ")") if J.t(J.mod(v_j_383, 3.0)) else ("rgba(255,250,220," + J.str(J.sub(1.0, v_k_370)) + ")"))
			J.sp(v_c_285, "fillStyle", _t326)
			J.mc(v_c_285, "beginPath", [])
			J.mc(v_c_285, "arc", [J.add(v_cx_375, J.mul(cos(J.num(v_a_384)), v_d_385)), J.add(J.add(v_cy_376, (J.mul(sin(J.num(v_a_384)), v_d_385) * 0.7)), J.mul((J.mul(v_k_370, v_k_370) * 20.0), v_U_288)), J.mul((2.6 - J.mul(v_k_370, 1.5)), v_U_288), 0.0, 7.0])
			J.mc(v_c_285, "fill", [])
			v_j_383 = J.num(v_j_383) + 1.0
		J.mc(v_c_285, "restore", [])
	for _t327 in J.iter(J.gp(_s114["W"], "walkers")):
		v_w_386 = _t327
		var _s148 = {"__p": _s114, "F": null}
		var _t328 = (not J.t(J.gp(v_w_386, "foe")))
		var _t329 = (_t328 if _t328 else J.gp(v_w_386, "gone"))
		if J.t((_t329 if J.t(_t329) else (not J.t(J.mc(_s148["__p"]["W"], "alive", [v_w_386]))))):
			continue
		_s148["F"] = J.gp(v_w_386, "foe")
		v_C_388 = J.gp(_s148["__p"]["__p"]["FOES"], J.gp(_s148["F"], "id"))
		var _t330 = J.mc(_s148["__p"]["W"], "P", J.spread([J.SP(J.mc(_s148["__p"]["W"], "wp", [v_w_386]))]))
		var _t331 = J.gp(_t330, 0.0)
		v_x_389 = _t331
		var _t332 = J.gp(_t330, 1.0)
		v_y_390 = _t332
		if J.t(J.gp(_s148["F"], "chant")):
			v_k_392 = J.min_([1.0, J.div(J.gp(J.gp(_s148["F"], "chant"), "t"), J.gp(J.gp(_s148["F"], "chant"), "dur"))])
			v_cy_393 = J.sub(v_y_390, J.mul(v_hh_289, 1.55))
			v_r_394 = J.mul(13.0, v_U_288)
			v_jx_395 = (J.mul(((randf() - 0.5) * 5.0), v_U_288) if J.cmp(J.gp(J.gp(_s148["F"], "chant"), "jolt"), 0.0, ">") else 0.0)
			J.sp(v_c_285, "fillStyle", "rgba(30,18,0,0.7)")
			J.mc(v_c_285, "beginPath", [])
			J.mc(v_c_285, "arc", [J.add(v_x_389, v_jx_395), v_cy_393, J.add(v_r_394, J.mul(3.0, v_U_288)), 0.0, 7.0])
			J.mc(v_c_285, "fill", [])
			J.sp(v_c_285, "strokeStyle", "rgba(255,212,90,0.25)")
			var _t333 = J.mul(4.0, v_U_288)
			J.sp(v_c_285, "lineWidth", _t333)
			J.mc(v_c_285, "beginPath", [])
			J.mc(v_c_285, "arc", [J.add(v_x_389, v_jx_395), v_cy_393, v_r_394, 0.0, 7.0])
			J.mc(v_c_285, "stroke", [])
			var _t334 = ("#ff8a6a" if J.cmp(J.gp(J.gp(_s148["F"], "chant"), "jolt"), 0.0, ">") else "#ffd45a")
			J.sp(v_c_285, "strokeStyle", _t334)
			J.mc(v_c_285, "beginPath", [])
			J.mc(v_c_285, "arc", [J.add(v_x_389, v_jx_395), v_cy_393, v_r_394, J.div((-PI), 2.0), (J.div((-PI), 2.0) + J.mul(v_k_392, 6.283))])
			J.mc(v_c_285, "stroke", [])
			J.mc(v_c_285, "save", [])
			J.mc(v_c_285, "translate", [J.add(v_x_389, v_jx_395), v_cy_393])
			J.mc(v_c_285, "rotate", [J.mul(v_t_290, 2.0)])
			J.sp(v_c_285, "strokeStyle", "#ffe9a0")
			var _t335 = J.mul(1.4, v_U_288)
			J.sp(v_c_285, "lineWidth", _t335)
			v_j_397 = 0.0
			while true:
				if not J.cmp(v_j_397, 3.0, "<"): break
				J.mc(v_c_285, "rotate", [2.094])
				J.mc(v_c_285, "beginPath", [])
				J.mc(v_c_285, "arc", [0.0, ((-J.num(v_r_394)) * 0.42), J.mul(v_r_394, 0.28), 0.0, 4.4])
				J.mc(v_c_285, "stroke", [])
				v_j_397 = J.num(v_j_397) + 1.0
			J.mc(v_c_285, "restore", [])
			v_tg_396 = ((J.mc(_s148["__p"]["W"], "P", J.spread([J.SP(J.mc(_s148["__p"]["W"], "bpos", [J.gp(J.gp(_s148["F"], "chant"), "tgt")]))])) if J.t(J.gp(_s148["__p"]["W"], "bpos")) else null) if J.seq(J.gp(J.gp(_s148["F"], "chant"), "kind"), "boss") else J.cl(Callable(self, "_f57").bind(_s148), null, []))
			if J.t(v_tg_396):
				var _t336 = ("rgba(255,212,90," + J.str((0.35 + J.mul(0.3, v_k_392))) + ")")
				J.sp(v_c_285, "strokeStyle", _t336)
				J.mc(v_c_285, "setLineDash", [[J.mul(4.0, v_U_288), J.mul(4.0, v_U_288)]])
				var _t337 = ((-J.num(v_t_290)) * 30.0)
				J.sp(v_c_285, "lineDashOffset", _t337)
				var _t338 = J.mul(2.0, v_U_288)
				J.sp(v_c_285, "lineWidth", _t338)
				J.mc(v_c_285, "beginPath", [])
				J.mc(v_c_285, "moveTo", [v_x_389, J.sub(v_y_390, J.mul(v_hh_289, 0.7))])
				J.mc(v_c_285, "lineTo", [J.gp(v_tg_396, 0.0), J.gp(v_tg_396, 1.0)])
				J.mc(v_c_285, "stroke", [])
				J.mc(v_c_285, "setLineDash", [[]])
		var _t339 = J.S_Object_("keys", [J.gp(_s148["F"], "by")])
		v_used_391 = J.len(J.mc(_t339, "filter", [Callable(self, "_f58").bind(_s148)]))
		var _t341 = J.gp(v_C_388, "res")
		if J.t((J.len(J.S_Object_("keys", [J.gp(_s148["F"], "by")])) if J.t(_t341) else _t341)):
			v_px_400 = J.add(J.add(v_x_389, J.mul(v_hh_289, 0.31)), J.mul(7.0, v_U_288))
			v_py_401 = (J.sub(v_y_390, v_hh_289) - J.mul(6.5, v_U_288))
			v_j_402 = 0.0
			while true:
				if not J.cmp(v_j_402, 3.0, "<"): break
				J.mc(v_c_285, "beginPath", [])
				J.mc(v_c_285, "arc", [J.add(v_px_400, J.mul(J.mul(v_j_402, 8.0), v_U_288)), v_py_401, J.mul(3.0, v_U_288), 0.0, 7.0])
				var _t342 = (J.gp(v_C_388, "tag") if J.cmp(v_j_402, v_used_391, "<") else "rgba(30,24,40,0.85)")
				J.sp(v_c_285, "fillStyle", _t342)
				J.mc(v_c_285, "fill", [])
				var _t343 = ("#1a1208" if J.cmp(v_j_402, v_used_391, "<") else "rgba(255,233,176,0.7)")
				J.sp(v_c_285, "strokeStyle", _t343)
				var _t344 = J.mul(1.3, v_U_288)
				J.sp(v_c_285, "lineWidth", _t344)
				J.mc(v_c_285, "stroke", [])
				v_j_402 = J.num(v_j_402) + 1.0
		if J.t(J.gp(_s148["F"], "retreated")):
			var _t345 = _s148["__p"]["__p"]["bigTxt"]
			var _t346 = _s148["__p"]["__p"]["T"]
			J.cl(_t345, null, [v_c_285, J.cl(_t346, null, ["撤符", "撤符"]), v_x_389, (J.sub(v_y_390, v_hh_289) - J.mul(26.0, v_U_288)), J.mul(10.0, v_U_288), "#ffe9a0"])
	J.mc(v_c_285, "restore", [])

func _f59(this_, a: Array, env):
	var v_c_405 = null; var v_w_406 = null; var v_hh_407 = null; var v_t_408 = null; var v_o_409 = null; var v_id_410 = null; var v_im_411 = null; var v_cast_412 = null; var v_walk_413 = null; var v_H_414 = null; var v_Wd_415 = null
	v_c_405 = J.arg(a, 0)
	v_w_406 = J.arg(a, 1)
	v_hh_407 = J.arg(a, 2)
	v_t_408 = J.arg(a, 3)
	v_o_409 = J.arg(a, 4)
	var _t347 = (not J.t(v_w_406))
	if (_t347 if _t347 else (not J.t(J.gp(v_w_406, "foe")))):
		return false
	var _t348 = (v_o_409 if J.t(v_o_409) else {})
	v_o_409 = _t348
	v_id_410 = J.gp(J.gp(v_w_406, "foe"), "id")
	var _t349 = (not J.seq(J.typeof_(J.G.get("SPR")), "undefined"))
	v_im_411 = (J.gp(J.G.get("SPR"), J.add("foe_", v_id_410)) if _t349 else _t349)
	if J.t((J.gp(v_im_411, "naturalWidth") if J.t(v_im_411) else v_im_411)):
		v_H_414 = J.mul(v_hh_407, 1.0)
		v_Wd_415 = J.div(J.mul(v_H_414, J.gp(v_im_411, "naturalWidth")), J.gp(v_im_411, "naturalHeight"))
		J.mc(v_c_405, "save", [])
		var _t351 = J.mul(v_t_408, 5.0)
		var _t350 = J.gp(v_w_406, "seed")
		var _t353 = J.mul((-absf(J.num(sin(J.num(J.add(_t351, (_t350 if J.t(_t350) else 0.0))))))), v_hh_407)
		var _t352 = J.cmp(J.gp(v_w_406, "stay"), 0.0, ">")
		J.mc(v_c_405, "translate", [0.0, (_t353 * (0.0 if (_t352 if _t352 else J.cmp(J.gp(v_w_406, "block"), 0.0, ">")) else 0.035))])
		if J.t(J.gp(v_o_409, "flip")):
			J.mc(v_c_405, "scale", [(-1.0), 1.0])
		J.mc(v_c_405, "drawImage", [v_im_411, J.div((-J.num(v_Wd_415)), 2.0), (-J.num(v_H_414)), v_Wd_415, v_H_414])
		J.mc(v_c_405, "restore", [])
		return true
	var _t355 = null
	if (not J.leq(J.gp(v_o_409, "cast"), null)):
		_t355 = J.gp(v_o_409, "cast")
	else:
		var _t354 = J.gp(J.gp(v_w_406, "foe"), "chant")
		_t355 = (not (not J.t((_t354 if J.t(_t354) else J.cmp(J.gp(J.gp(v_w_406, "foe"), "scan"), 0.0, ">")))))
	v_cast_412 = _t355
	var _t358 = null
	if (not J.leq(J.gp(v_o_409, "walk"), null)):
		_t358 = J.gp(v_o_409, "walk")
	else:
		var _t356 = (not J.t(v_cast_412))
		var _t357 = ((not J.cmp(J.gp(v_w_406, "block"), 0.0, ">")) if _t356 else _t356)
		_t358 = ((not J.cmp(J.gp(v_w_406, "stay"), 0.0, ">")) if _t357 else _t357)
	v_walk_413 = _t358
	var _t359 = env["drawQ"]
	var _t361 = J.mul(v_hh_407, 1.12)
	var _t360 = J.gp(v_w_406, "seed")
	J.cl(_t359, null, [v_c_405, v_id_410, _t361, J.add(v_t_408, (_t360 if J.t(_t360) else 0.0)), (not (not J.t(J.gp(v_o_409, "flip")))), v_walk_413, v_cast_412])
	return true

func _f60(this_, a: Array, env):
	var v_c_418 = null; var v_id_419 = null; var v_H_420 = null; var v_t_421 = null; var v_flip_422 = null; var v_walk_423 = null; var v_cast_424 = null; var v_r_425 = null; var v_hy_426 = null; var v_bodyTop_427 = null; var v_lw_428 = null; var v_bob_429 = null; var v_sw_430 = null; var v_OL_431 = null; var v_SK_432 = null; var v_P_433 = null; var v_armY_434 = null; var v_ex_435 = null; var v_ey_436 = null; var v_s_437 = null; var v_lx_438 = null; var v_raise_439 = null; var v_g_440 = null; var v_g_441 = null; var v_s_442 = null
	v_c_418 = J.arg(a, 0)
	v_id_419 = J.arg(a, 1)
	v_H_420 = J.arg(a, 2)
	v_t_421 = J.arg(a, 3)
	v_flip_422 = J.arg(a, 4)
	v_walk_423 = J.arg(a, 5)
	v_cast_424 = J.arg(a, 6)
	v_r_425 = J.mul(v_H_420, 0.25)
	v_hy_426 = J.add((-J.num(v_H_420)), v_r_425)
	v_bodyTop_427 = J.add(v_hy_426, J.mul(v_r_425, 0.85))
	v_lw_428 = J.max_([1.4, J.mul(v_H_420, 0.028)])
	v_bob_429 = ((J.mul(absf(J.num(sin(J.num(J.mul(v_t_421, 8.0))))), v_H_420) * 0.03) if J.t(v_walk_423) else 0.0)
	v_sw_430 = (sin(J.num(J.mul(v_t_421, 8.0))) if J.t(v_walk_423) else 0.0)
	v_OL_431 = "#1a1208"
	v_SK_432 = "#f3d2a8"
	J.mc(v_c_418, "save", [])
	if J.t(v_flip_422):
		J.mc(v_c_418, "scale", [(-1.0), 1.0])
	J.mc(v_c_418, "translate", [0.0, (-J.num(v_bob_429))])
	J.sp(v_c_418, "lineJoin", "round")
	J.sp(v_c_418, "lineCap", "round")
	J.sp(v_c_418, "lineWidth", v_lw_428)
	J.sp(v_c_418, "strokeStyle", v_OL_431)
	v_P_433 = J.gp({"taoist": {"body": "#e9bd3a", "trim": "#8a5a12", "leg": "#2b2320", "shoe": "#141010"}, "hunter": {"body": "#3f5a4a", "trim": "#24342b", "leg": "#2c3a5c", "shoe": "#1a1a1a"}, "streamer": {"body": "#e45a9a", "trim": "#a83470", "leg": "#2a2a3a", "shoe": "#f4f4f4"}}, v_id_419)
	for _t362 in J.iter([(-1.0), 1.0]):
		v_s_437 = _t362
		v_lx_438 = ((J.mul(v_s_437, v_H_420) * 0.07) + (J.mul(J.mul(v_sw_430, v_s_437), v_H_420) * 0.04))
		var _t363 = J.gp(v_P_433, "leg")
		J.sp(v_c_418, "fillStyle", _t363)
		J.mc(v_c_418, "beginPath", [])
		J.mc(v_c_418, "rect", [J.sub(v_lx_438, J.mul(v_H_420, 0.035)), ((-J.num(v_H_420)) * 0.16), J.mul(v_H_420, 0.07), J.mul(v_H_420, 0.14)])
		J.mc(v_c_418, "fill", [])
		J.mc(v_c_418, "stroke", [])
		var _t364 = J.gp(v_P_433, "shoe")
		J.sp(v_c_418, "fillStyle", _t364)
		J.mc(v_c_418, "beginPath", [])
		J.mc(v_c_418, "ellipse", [J.add(v_lx_438, J.mul(v_H_420, 0.015)), ((-J.num(v_H_420)) * 0.02), J.mul(v_H_420, 0.055), J.mul(v_H_420, 0.03), 0.0, 0.0, 7.0])
		J.mc(v_c_418, "fill", [])
		J.mc(v_c_418, "stroke", [])
	var _t365 = J.gp(v_P_433, "body")
	J.sp(v_c_418, "fillStyle", _t365)
	J.mc(v_c_418, "beginPath", [])
	if J.seq(v_id_419, "taoist"):
		J.mc(v_c_418, "moveTo", [((-J.num(v_H_420)) * 0.12), v_bodyTop_427])
		J.mc(v_c_418, "lineTo", [J.mul(v_H_420, 0.12), v_bodyTop_427])
		J.mc(v_c_418, "lineTo", [J.mul(v_H_420, 0.19), ((-J.num(v_H_420)) * 0.12)])
		J.mc(v_c_418, "quadraticCurveTo", [0.0, ((-J.num(v_H_420)) * 0.09), ((-J.num(v_H_420)) * 0.19), ((-J.num(v_H_420)) * 0.12)])
		J.mc(v_c_418, "closePath", [])
	else:
		J.mc(v_c_418, "moveTo", [((-J.num(v_H_420)) * 0.12), v_bodyTop_427])
		J.mc(v_c_418, "lineTo", [J.mul(v_H_420, 0.12), v_bodyTop_427])
		J.mc(v_c_418, "lineTo", [J.mul(v_H_420, 0.14), ((-J.num(v_H_420)) * 0.15)])
		J.mc(v_c_418, "lineTo", [((-J.num(v_H_420)) * 0.14), ((-J.num(v_H_420)) * 0.15)])
		J.mc(v_c_418, "closePath", [])
	J.mc(v_c_418, "fill", [])
	J.mc(v_c_418, "stroke", [])
	if J.seq(v_id_419, "taoist"):
		var _t366 = J.gp(v_P_433, "trim")
		J.sp(v_c_418, "strokeStyle", _t366)
		var _t367 = J.mul(v_lw_428, 1.4)
		J.sp(v_c_418, "lineWidth", _t367)
		J.mc(v_c_418, "beginPath", [])
		J.mc(v_c_418, "moveTo", [((-J.num(v_H_420)) * 0.07), J.add(v_bodyTop_427, J.mul(v_H_420, 0.01))])
		J.mc(v_c_418, "lineTo", [J.mul(v_H_420, 0.03), J.add(v_bodyTop_427, J.mul(v_H_420, 0.13))])
		J.mc(v_c_418, "moveTo", [J.mul(v_H_420, 0.07), J.add(v_bodyTop_427, J.mul(v_H_420, 0.01))])
		J.mc(v_c_418, "lineTo", [J.mul(v_H_420, 0.0), J.add(v_bodyTop_427, J.mul(v_H_420, 0.09))])
		J.mc(v_c_418, "stroke", [])
		J.sp(v_c_418, "fillStyle", "#7a2a1a")
		J.mc(v_c_418, "fillRect", [((-J.num(v_H_420)) * 0.15), J.add(v_bodyTop_427, J.mul(v_H_420, 0.17)), J.mul(v_H_420, 0.3), J.mul(v_H_420, 0.035)])
		J.sp(v_c_418, "strokeStyle", v_OL_431)
		J.sp(v_c_418, "lineWidth", v_lw_428)
	else:
		if J.seq(v_id_419, "hunter"):
			var _t368 = J.gp(v_P_433, "trim")
			J.sp(v_c_418, "strokeStyle", _t368)
			J.mc(v_c_418, "beginPath", [])
			J.mc(v_c_418, "moveTo", [0.0, J.add(v_bodyTop_427, J.mul(v_H_420, 0.02))])
			J.mc(v_c_418, "lineTo", [0.0, ((-J.num(v_H_420)) * 0.16)])
			J.mc(v_c_418, "stroke", [])
			J.sp(v_c_418, "fillStyle", "#6a4a2a")
			J.mc(v_c_418, "fillRect", [((-J.num(v_H_420)) * 0.16), J.add(v_bodyTop_427, J.mul(v_H_420, 0.02)), J.mul(v_H_420, 0.05), J.mul(v_H_420, 0.2)])
			J.sp(v_c_418, "strokeStyle", v_OL_431)
			J.mc(v_c_418, "strokeRect", [((-J.num(v_H_420)) * 0.16), J.add(v_bodyTop_427, J.mul(v_H_420, 0.02)), J.mul(v_H_420, 0.05), J.mul(v_H_420, 0.2)])
			J.sp(v_c_418, "fillStyle", "#d8a83a")
			J.mc(v_c_418, "beginPath", [])
			J.mc(v_c_418, "arc", [((-J.num(v_H_420)) * 0.07), J.add(v_bodyTop_427, J.mul(v_H_420, 0.17)), J.mul(v_H_420, 0.035), 0.0, 7.0])
			J.mc(v_c_418, "fill", [])
			J.mc(v_c_418, "stroke", [])
			J.sp(v_c_418, "strokeStyle", "#a02020")
			J.mc(v_c_418, "beginPath", [])
			J.mc(v_c_418, "moveTo", [((-J.num(v_H_420)) * 0.07), J.add(v_bodyTop_427, J.mul(v_H_420, 0.17))])
			J.mc(v_c_418, "lineTo", [(((-J.num(v_H_420)) * 0.07) + (J.mul(cos(J.num(J.mul(v_t_421, 7.0))), v_H_420) * 0.028)), J.add(J.add(v_bodyTop_427, J.mul(v_H_420, 0.17)), (J.mul(sin(J.num(J.mul(v_t_421, 7.0))), v_H_420) * 0.028))])
			J.mc(v_c_418, "stroke", [])
			J.sp(v_c_418, "strokeStyle", v_OL_431)
		else:
			var _t369 = J.gp(v_P_433, "trim")
			J.sp(v_c_418, "fillStyle", _t369)
			J.mc(v_c_418, "beginPath", [])
			J.mc(v_c_418, "ellipse", [0.0, J.add(v_bodyTop_427, J.mul(v_H_420, 0.15)), J.mul(v_H_420, 0.07), J.mul(v_H_420, 0.03), 0.0, 0.0, 7.0])
			J.mc(v_c_418, "fill", [])
	v_armY_434 = J.add(v_bodyTop_427, J.mul(v_H_420, 0.05))
	if J.seq(v_id_419, "taoist"):
		v_raise_439 = (1.0 if J.t(v_cast_424) else 0.0)
		J.mc(v_c_418, "save", [])
		J.mc(v_c_418, "translate", [J.mul(v_H_420, 0.11), v_armY_434])
		J.mc(v_c_418, "rotate", [(((-1.9) + (sin(J.num(J.mul(v_t_421, 6.0))) * 0.08)) if J.t(v_cast_424) else (0.5 + J.mul(v_sw_430, 0.15)))])
		var _t370 = J.gp(v_P_433, "body")
		J.sp(v_c_418, "fillStyle", _t370)
		J.mc(v_c_418, "beginPath", [])
		J.mc(v_c_418, "rect", [((-J.num(v_H_420)) * 0.03), 0.0, J.mul(v_H_420, 0.06), J.mul(v_H_420, 0.13)])
		J.mc(v_c_418, "fill", [])
		J.mc(v_c_418, "stroke", [])
		J.sp(v_c_418, "fillStyle", v_SK_432)
		J.mc(v_c_418, "beginPath", [])
		J.mc(v_c_418, "arc", [0.0, J.mul(v_H_420, 0.15), J.mul(v_H_420, 0.032), 0.0, 7.0])
		J.mc(v_c_418, "fill", [])
		J.mc(v_c_418, "stroke", [])
		J.mc(v_c_418, "translate", [0.0, J.mul(v_H_420, 0.15)])
		J.mc(v_c_418, "rotate", [(2.0 if J.t(v_cast_424) else 0.3)])
		J.sp(v_c_418, "fillStyle", "#a5652e")
		J.mc(v_c_418, "beginPath", [])
		J.mc(v_c_418, "moveTo", [((-J.num(v_H_420)) * 0.022), ((-J.num(v_H_420)) * 0.02)])
		J.mc(v_c_418, "lineTo", [((-J.num(v_H_420)) * 0.02), ((-J.num(v_H_420)) * 0.36)])
		J.mc(v_c_418, "lineTo", [0.0, ((-J.num(v_H_420)) * 0.4)])
		J.mc(v_c_418, "lineTo", [J.mul(v_H_420, 0.02), ((-J.num(v_H_420)) * 0.36)])
		J.mc(v_c_418, "lineTo", [J.mul(v_H_420, 0.022), ((-J.num(v_H_420)) * 0.02)])
		J.mc(v_c_418, "closePath", [])
		J.mc(v_c_418, "fill", [])
		J.mc(v_c_418, "stroke", [])
		J.sp(v_c_418, "strokeStyle", "#d99a58")
		J.mc(v_c_418, "beginPath", [])
		J.mc(v_c_418, "moveTo", [0.0, ((-J.num(v_H_420)) * 0.05)])
		J.mc(v_c_418, "lineTo", [0.0, ((-J.num(v_H_420)) * 0.33)])
		J.mc(v_c_418, "stroke", [])
		J.sp(v_c_418, "strokeStyle", v_OL_431)
		J.sp(v_c_418, "fillStyle", "#6a3a1a")
		J.mc(v_c_418, "fillRect", [((-J.num(v_H_420)) * 0.05), ((-J.num(v_H_420)) * 0.04), J.mul(v_H_420, 0.1), J.mul(v_H_420, 0.025)])
		J.mc(v_c_418, "strokeRect", [((-J.num(v_H_420)) * 0.05), ((-J.num(v_H_420)) * 0.04), J.mul(v_H_420, 0.1), J.mul(v_H_420, 0.025)])
		J.sp(v_c_418, "strokeStyle", "#c8281e")
		var _t371 = J.mul(v_lw_428, 1.5)
		J.sp(v_c_418, "lineWidth", _t371)
		J.mc(v_c_418, "beginPath", [])
		J.mc(v_c_418, "moveTo", [0.0, 0.0])
		J.mc(v_c_418, "quadraticCurveTo", [(J.mul(v_H_420, 0.03) + (J.mul(sin(J.num(J.mul(v_t_421, 5.0))), v_H_420) * 0.02)), J.mul(v_H_420, 0.06), (J.mul(sin(J.num(J.mul(v_t_421, 4.0))), v_H_420) * 0.03), J.mul(v_H_420, 0.1)])
		J.mc(v_c_418, "stroke", [])
		J.mc(v_c_418, "restore", [])
		J.sp(v_c_418, "lineWidth", v_lw_428)
		J.sp(v_c_418, "strokeStyle", v_OL_431)
		J.mc(v_c_418, "save", [])
		J.mc(v_c_418, "translate", [((-J.num(v_H_420)) * 0.11), v_armY_434])
		J.mc(v_c_418, "rotate", [(0.9 if J.t(v_cast_424) else ((-0.4) - J.mul(v_sw_430, 0.15)))])
		var _t372 = J.gp(v_P_433, "body")
		J.sp(v_c_418, "fillStyle", _t372)
		J.mc(v_c_418, "beginPath", [])
		J.mc(v_c_418, "rect", [((-J.num(v_H_420)) * 0.03), 0.0, J.mul(v_H_420, 0.06), J.mul(v_H_420, 0.13)])
		J.mc(v_c_418, "fill", [])
		J.mc(v_c_418, "stroke", [])
		J.sp(v_c_418, "fillStyle", v_SK_432)
		J.mc(v_c_418, "beginPath", [])
		J.mc(v_c_418, "arc", [0.0, J.mul(v_H_420, 0.15), J.mul(v_H_420, 0.032), 0.0, 7.0])
		J.mc(v_c_418, "fill", [])
		J.mc(v_c_418, "stroke", [])
		J.mc(v_c_418, "restore", [])
	else:
		if J.seq(v_id_419, "hunter"):
			J.mc(v_c_418, "save", [])
			J.mc(v_c_418, "translate", [J.mul(v_H_420, 0.11), v_armY_434])
			J.mc(v_c_418, "rotate", [((-1.45) if J.t(v_cast_424) else (0.35 + J.mul(v_sw_430, 0.15)))])
			var _t373 = J.gp(v_P_433, "body")
			J.sp(v_c_418, "fillStyle", _t373)
			J.mc(v_c_418, "beginPath", [])
			J.mc(v_c_418, "rect", [((-J.num(v_H_420)) * 0.03), 0.0, J.mul(v_H_420, 0.06), J.mul(v_H_420, 0.13)])
			J.mc(v_c_418, "fill", [])
			J.mc(v_c_418, "stroke", [])
			J.sp(v_c_418, "fillStyle", v_SK_432)
			J.mc(v_c_418, "beginPath", [])
			J.mc(v_c_418, "arc", [0.0, J.mul(v_H_420, 0.15), J.mul(v_H_420, 0.032), 0.0, 7.0])
			J.mc(v_c_418, "fill", [])
			J.mc(v_c_418, "stroke", [])
			J.mc(v_c_418, "translate", [0.0, J.mul(v_H_420, 0.15)])
			J.mc(v_c_418, "rotate", [(J.div((-PI), 2.0) + (0.0 if J.t(v_cast_424) else 0.3))])
			J.sp(v_c_418, "fillStyle", "#5a5e66")
			J.mc(v_c_418, "fillRect", [((-J.num(v_H_420)) * 0.02), ((-J.num(v_H_420)) * 0.03), J.mul(v_H_420, 0.15), J.mul(v_H_420, 0.06)])
			J.mc(v_c_418, "strokeRect", [((-J.num(v_H_420)) * 0.02), ((-J.num(v_H_420)) * 0.03), J.mul(v_H_420, 0.15), J.mul(v_H_420, 0.06)])
			var _t374 = ("#fffbd0" if J.t(v_cast_424) else "#e8e0a0")
			J.sp(v_c_418, "fillStyle", _t374)
			J.mc(v_c_418, "beginPath", [])
			J.mc(v_c_418, "ellipse", [J.mul(v_H_420, 0.135), 0.0, J.mul(v_H_420, 0.018), J.mul(v_H_420, 0.04), 0.0, 0.0, 7.0])
			J.mc(v_c_418, "fill", [])
			J.mc(v_c_418, "stroke", [])
			if J.t(v_cast_424):
				v_g_440 = J.mc(v_c_418, "createRadialGradient", [J.mul(v_H_420, 0.14), 0.0, 1.0, J.mul(v_H_420, 0.14), 0.0, J.mul(v_H_420, 0.12)])
				J.mc(v_g_440, "addColorStop", [0.0, "rgba(255,255,220,0.9)"])
				J.mc(v_g_440, "addColorStop", [1.0, "rgba(255,255,220,0)"])
				J.sp(v_c_418, "fillStyle", v_g_440)
				J.mc(v_c_418, "beginPath", [])
				J.mc(v_c_418, "arc", [J.mul(v_H_420, 0.14), 0.0, J.mul(v_H_420, 0.12), 0.0, 7.0])
				J.mc(v_c_418, "fill", [])
			J.mc(v_c_418, "restore", [])
			J.mc(v_c_418, "save", [])
			J.mc(v_c_418, "translate", [((-J.num(v_H_420)) * 0.11), v_armY_434])
			J.mc(v_c_418, "rotate", [((-0.35) - J.mul(v_sw_430, 0.15))])
			var _t375 = J.gp(v_P_433, "body")
			J.sp(v_c_418, "fillStyle", _t375)
			J.mc(v_c_418, "beginPath", [])
			J.mc(v_c_418, "rect", [((-J.num(v_H_420)) * 0.03), 0.0, J.mul(v_H_420, 0.06), J.mul(v_H_420, 0.13)])
			J.mc(v_c_418, "fill", [])
			J.mc(v_c_418, "stroke", [])
			J.sp(v_c_418, "fillStyle", v_SK_432)
			J.mc(v_c_418, "beginPath", [])
			J.mc(v_c_418, "arc", [0.0, J.mul(v_H_420, 0.15), J.mul(v_H_420, 0.032), 0.0, 7.0])
			J.mc(v_c_418, "fill", [])
			J.mc(v_c_418, "stroke", [])
			J.mc(v_c_418, "restore", [])
		else:
			J.mc(v_c_418, "save", [])
			J.mc(v_c_418, "translate", [J.mul(v_H_420, 0.11), v_armY_434])
			J.mc(v_c_418, "rotate", [((-2.3) + (sin(J.num(J.mul(v_t_421, 2.0))) * 0.1))])
			var _t376 = J.gp(v_P_433, "body")
			J.sp(v_c_418, "fillStyle", _t376)
			J.mc(v_c_418, "beginPath", [])
			J.mc(v_c_418, "rect", [((-J.num(v_H_420)) * 0.03), 0.0, J.mul(v_H_420, 0.06), J.mul(v_H_420, 0.13)])
			J.mc(v_c_418, "fill", [])
			J.mc(v_c_418, "stroke", [])
			J.sp(v_c_418, "strokeStyle", "#888")
			var _t377 = J.mul(v_lw_428, 1.2)
			J.sp(v_c_418, "lineWidth", _t377)
			J.mc(v_c_418, "beginPath", [])
			J.mc(v_c_418, "moveTo", [0.0, J.mul(v_H_420, 0.13)])
			J.mc(v_c_418, "lineTo", [0.0, J.mul(v_H_420, 0.36)])
			J.mc(v_c_418, "stroke", [])
			J.sp(v_c_418, "strokeStyle", v_OL_431)
			J.sp(v_c_418, "lineWidth", v_lw_428)
			J.mc(v_c_418, "translate", [0.0, J.mul(v_H_420, 0.4)])
			J.sp(v_c_418, "fillStyle", "#222")
			J.mc(v_c_418, "fillRect", [((-J.num(v_H_420)) * 0.035), ((-J.num(v_H_420)) * 0.05), J.mul(v_H_420, 0.07), J.mul(v_H_420, 0.1)])
			var _t378 = J.mul(v_H_420, 0.02)
			J.sp(v_c_418, "lineWidth", _t378)
			var _t379 = ("rgba(255,250,250," + J.str((0.85 + (0.15 * sin(J.num(J.mul(v_t_421, 9.0)))))) + ")")
			J.sp(v_c_418, "strokeStyle", _t379)
			J.mc(v_c_418, "beginPath", [])
			J.mc(v_c_418, "arc", [0.0, 0.0, J.mul(v_H_420, 0.085), 0.0, 7.0])
			J.mc(v_c_418, "stroke", [])
			v_g_441 = J.mc(v_c_418, "createRadialGradient", [0.0, 0.0, J.mul(v_H_420, 0.05), 0.0, 0.0, J.mul(v_H_420, 0.16)])
			J.mc(v_g_441, "addColorStop", [0.0, "rgba(255,240,250,0.5)"])
			J.mc(v_g_441, "addColorStop", [1.0, "rgba(255,240,250,0)"])
			J.sp(v_c_418, "fillStyle", v_g_441)
			J.mc(v_c_418, "beginPath", [])
			J.mc(v_c_418, "arc", [0.0, 0.0, J.mul(v_H_420, 0.16), 0.0, 7.0])
			J.mc(v_c_418, "fill", [])
			J.mc(v_c_418, "restore", [])
			J.sp(v_c_418, "lineWidth", v_lw_428)
			J.sp(v_c_418, "strokeStyle", v_OL_431)
			J.mc(v_c_418, "save", [])
			J.mc(v_c_418, "translate", [((-J.num(v_H_420)) * 0.11), v_armY_434])
			J.mc(v_c_418, "rotate", [((-0.3) - J.mul(v_sw_430, 0.15))])
			var _t380 = J.gp(v_P_433, "body")
			J.sp(v_c_418, "fillStyle", _t380)
			J.mc(v_c_418, "beginPath", [])
			J.mc(v_c_418, "rect", [((-J.num(v_H_420)) * 0.03), 0.0, J.mul(v_H_420, 0.06), J.mul(v_H_420, 0.13)])
			J.mc(v_c_418, "fill", [])
			J.mc(v_c_418, "stroke", [])
			J.sp(v_c_418, "fillStyle", v_SK_432)
			J.mc(v_c_418, "beginPath", [])
			J.mc(v_c_418, "arc", [0.0, J.mul(v_H_420, 0.15), J.mul(v_H_420, 0.032), 0.0, 7.0])
			J.mc(v_c_418, "fill", [])
			J.mc(v_c_418, "stroke", [])
			J.mc(v_c_418, "restore", [])
	J.sp(v_c_418, "fillStyle", v_SK_432)
	J.mc(v_c_418, "beginPath", [])
	J.mc(v_c_418, "arc", [0.0, v_hy_426, v_r_425, 0.0, 7.0])
	J.mc(v_c_418, "fill", [])
	J.mc(v_c_418, "stroke", [])
	if J.seq(v_id_419, "taoist"):
		J.sp(v_c_418, "fillStyle", "#1c1a1a")
		J.mc(v_c_418, "beginPath", [])
		J.mc(v_c_418, "arc", [0.0, v_hy_426, v_r_425, (PI * 1.05), (PI * 1.95)])
		J.mc(v_c_418, "quadraticCurveTo", [0.0, J.sub(v_hy_426, J.mul(v_r_425, 0.45)), ((-J.num(v_r_425)) * 0.98), J.sub(v_hy_426, J.mul(v_r_425, 0.2))])
		J.mc(v_c_418, "fill", [])
		J.mc(v_c_418, "stroke", [])
		J.sp(v_c_418, "fillStyle", "#1c1a1a")
		J.mc(v_c_418, "beginPath", [])
		J.mc(v_c_418, "arc", [0.0, J.sub(v_hy_426, J.mul(v_r_425, 1.02)), J.mul(v_r_425, 0.3), 0.0, 7.0])
		J.mc(v_c_418, "fill", [])
		J.mc(v_c_418, "stroke", [])
		J.sp(v_c_418, "fillStyle", "#2a2a2a")
		J.mc(v_c_418, "fillRect", [((-J.num(v_r_425)) * 0.36), J.sub(v_hy_426, J.mul(v_r_425, 1.32)), J.mul(v_r_425, 0.72), J.mul(v_r_425, 0.22)])
		J.mc(v_c_418, "strokeRect", [((-J.num(v_r_425)) * 0.36), J.sub(v_hy_426, J.mul(v_r_425, 1.32)), J.mul(v_r_425, 0.72), J.mul(v_r_425, 0.22)])
		J.sp(v_c_418, "fillStyle", "#d9b23a")
		J.mc(v_c_418, "beginPath", [])
		J.mc(v_c_418, "arc", [0.0, J.sub(v_hy_426, J.mul(v_r_425, 1.21)), J.mul(v_r_425, 0.07), 0.0, 7.0])
		J.mc(v_c_418, "fill", [])
	else:
		if J.seq(v_id_419, "hunter"):
			J.sp(v_c_418, "fillStyle", "#26303a")
			J.mc(v_c_418, "beginPath", [])
			J.mc(v_c_418, "arc", [0.0, J.sub(v_hy_426, J.mul(v_r_425, 0.08)), J.mul(v_r_425, 1.02), (PI * 1.02), (PI * 1.98)])
			J.mc(v_c_418, "closePath", [])
			J.mc(v_c_418, "fill", [])
			J.mc(v_c_418, "stroke", [])
			J.mc(v_c_418, "beginPath", [])
			J.mc(v_c_418, "moveTo", [J.mul(v_r_425, 0.5), J.sub(v_hy_426, J.mul(v_r_425, 0.18))])
			J.mc(v_c_418, "lineTo", [J.mul(v_r_425, 1.35), J.sub(v_hy_426, J.mul(v_r_425, 0.12))])
			J.mc(v_c_418, "lineTo", [J.mul(v_r_425, 0.95), J.sub(v_hy_426, J.mul(v_r_425, 0.02))])
			J.mc(v_c_418, "closePath", [])
			J.mc(v_c_418, "fill", [])
			J.mc(v_c_418, "stroke", [])
		else:
			J.sp(v_c_418, "fillStyle", "#5a2a4a")
			J.mc(v_c_418, "beginPath", [])
			J.mc(v_c_418, "arc", [0.0, v_hy_426, J.mul(v_r_425, 1.04), (PI * 0.95), (PI * 2.05)])
			J.mc(v_c_418, "quadraticCurveTo", [J.mul(v_r_425, 0.3), J.sub(v_hy_426, J.mul(v_r_425, 0.35)), ((-J.num(v_r_425)) * 1.0), J.add(v_hy_426, J.mul(v_r_425, 0.15))])
			J.mc(v_c_418, "fill", [])
			J.mc(v_c_418, "stroke", [])
			var _t381 = J.gp(v_P_433, "body")
			J.sp(v_c_418, "fillStyle", _t381)
			J.mc(v_c_418, "beginPath", [])
			J.mc(v_c_418, "arc", [0.0, J.add(v_hy_426, J.mul(v_r_425, 0.1)), J.mul(v_r_425, 1.12), (PI * 0.08), (PI * 0.92)])
			J.mc(v_c_418, "lineTo", [((-J.num(v_r_425)) * 0.9), J.add(v_hy_426, J.mul(v_r_425, 0.75))])
			J.mc(v_c_418, "lineTo", [J.mul(v_r_425, 0.9), J.add(v_hy_426, J.mul(v_r_425, 0.75))])
			J.mc(v_c_418, "closePath", [])
			J.mc(v_c_418, "fill", [])
			J.mc(v_c_418, "stroke", [])
	v_ex_435 = J.mul(v_r_425, 0.38)
	v_ey_436 = J.add(v_hy_426, J.mul(v_r_425, 0.12))
	J.sp(v_c_418, "fillStyle", v_OL_431)
	for _t382 in J.iter([(-1.0), 1.0]):
		v_s_442 = _t382
		J.mc(v_c_418, "beginPath", [])
		J.mc(v_c_418, "ellipse", [(J.mul(v_s_442, v_ex_435) + J.mul(v_r_425, 0.12)), v_ey_436, J.mul(v_r_425, 0.09), J.mul(v_r_425, (0.04 if J.t(((not J.seq(v_id_419, "streamer")) if J.t(v_cast_424) else v_cast_424)) else 0.13)), 0.0, 0.0, 7.0])
		J.mc(v_c_418, "fill", [])
	var _t383 = J.mul(v_lw_428, 0.9)
	J.sp(v_c_418, "lineWidth", _t383)
	J.mc(v_c_418, "beginPath", [])
	if J.seq(v_id_419, "streamer"):
		J.mc(v_c_418, "arc", [J.mul(v_r_425, 0.12), J.add(v_ey_436, J.mul(v_r_425, 0.32)), J.mul(v_r_425, 0.16), 0.2, (PI - 0.2)])
	else:
		J.mc(v_c_418, "moveTo", [J.mul(v_r_425, 0.0), J.add(v_ey_436, J.mul(v_r_425, 0.4))])
		J.mc(v_c_418, "lineTo", [J.mul(v_r_425, 0.24), J.add(v_ey_436, J.mul(v_r_425, 0.38))])
	J.mc(v_c_418, "stroke", [])
	if (not J.seq(v_id_419, "streamer")):
		J.mc(v_c_418, "beginPath", [])
		J.mc(v_c_418, "moveTo", [((-J.num(v_ex_435)) + J.mul(v_r_425, 0.0)), J.sub(v_ey_436, J.mul(v_r_425, 0.24))])
		J.mc(v_c_418, "lineTo", [((-J.num(v_ex_435)) + J.mul(v_r_425, 0.24)), J.sub(v_ey_436, J.mul(v_r_425, 0.18))])
		J.mc(v_c_418, "moveTo", [J.add(v_ex_435, J.mul(v_r_425, 0.0)), J.sub(v_ey_436, J.mul(v_r_425, 0.18))])
		J.mc(v_c_418, "lineTo", [J.add(v_ex_435, J.mul(v_r_425, 0.24)), J.sub(v_ey_436, J.mul(v_r_425, 0.24))])
		J.mc(v_c_418, "stroke", [])
	J.mc(v_c_418, "restore", [])

func _f2(this_, a: Array, env):
	var v_a_44 = null; var v_b_45 = null
	v_a_44 = J.arg(a, 0)
	v_b_45 = J.arg(a, 1)
	return J.add(v_a_44, (randf() * J.sub(v_b_45, v_a_44)))

func _f3(this_, a: Array, env):
	var v_a_46 = null
	v_a_46 = J.arg(a, 0)
	return J.gp(v_a_46, floor(J.num((randf() * J.len(v_a_46)))))

func _f4(this_, a: Array, env):
	var v_yue_47 = null; var v_zh_48 = null; var v_e_49 = null
	v_yue_47 = J.arg(a, 0)
	v_zh_48 = J.arg(a, 1)
	var _t384 = (not J.seq(J.typeof_(J.G.get("LANG")), "undefined"))
	if J.t((J.gp(J.G.get("LANG"), "add") if _t384 else _t384)):
		J.mc(J.G.get("LANG"), "add", [{J.key(v_yue_47): v_zh_48}])
	var _t385 = (not J.seq(J.typeof_(J.G.get("window")), "undefined"))
	if J.t((J.gp(J.G.get("window"), "L") if _t385 else _t385)):
		return J.S_window_("L", [v_yue_47])
	return v_yue_47

func _f5(this_, a: Array, env):
	return J.div((J.S_performance_("now", []) if (not J.seq(J.typeof_(J.G.get("performance")), "undefined")) else J.S_Date_("now", [])), 1000.0)

func _f7(this_, a: Array, env):
	var v_s_52 = null; var v_W_53 = null; var v_p_54 = null
	v_s_52 = J.arg(a, 0)
	v_W_53 = J.arg(a, 1)
	if (not J.t(J.gp(env["S"], "brk"))):
		var _t386 = env["S"]
		var _t387 = []
		J.sp(_t386, "brk", _t387)
	var _t388 = env["spotOf"]
	v_p_54 = J.cl(_t388, null, [v_s_52, v_W_53])
	if J.t(v_p_54):
		var _t389 = J.gp(env["S"], "brk")
		var _t391 = J.gp(v_s_52, "kind")
		var _t392 = J.gp(v_s_52, "i")
		var _t393 = J.gp(v_p_54, 0.0)
		var _t394 = J.gp(v_p_54, 1.0)
		var _t390 = J.gp(v_s_52, "seed")
		J.mc(_t389, "push", [{"kind": _t391, "i": _t392, "x": _t393, "y": _t394, "t": 0.0, "dur": 1.0, "seed": (_t390 if J.t(_t390) else 0.0)}])

func _f8(this_, a: Array, env):
	var v_im_55 = null
	var _t395 = (not J.seq(J.typeof_(J.G.get("SPR")), "undefined"))
	v_im_55 = (J.gp(J.G.get("SPR"), "vfx_seal") if _t395 else _t395)
	return (v_im_55 if J.t((J.gp(v_im_55, "naturalWidth") if J.t(v_im_55) else v_im_55)) else null)

func _f12(this_, a: Array, env):
	var v_f_64 = null; var v_ms_65 = null; var v_e_66 = null
	v_f_64 = J.arg(a, 0)
	v_ms_65 = J.arg(a, 1)
	J.F_setTimeout([v_f_64, v_ms_65])

func _f18(this_, a: Array, env):
	var v_lv_80 = null
	v_lv_80 = J.arg(a, 0)
	return (1.0 if J.cmp(v_lv_80, 8.0, "<") else (2.0 if J.cmp(v_lv_80, 18.0, "<") else 3.0))

func _f22(this_, a: Array, env):
	var v_s_94 = null
	v_s_94 = J.arg(a, 0)
	return J.seq(J.gp(v_s_94, "tgt"), env["o"])

func _f21(this_, a: Array, env):
	var _s33 = {"__p": env, "o": null}
	_s33["o"] = J.arg(a, 0)
	var _t396 = J.gp(_s33["__p"]["S"], "seals")
	return J.mc(_t396, "find", [Callable(self, "_f22").bind(_s33)])

func _f54(this_, a: Array, env):
	var v_c_269 = null; var v_s_270 = null; var v_x_271 = null; var v_y_272 = null; var v_px_273 = null; var v_fill_274 = null; var v_stroke_275 = null
	v_c_269 = J.arg(a, 0)
	v_s_270 = J.arg(a, 1)
	v_x_271 = J.arg(a, 2)
	v_y_272 = J.arg(a, 3)
	v_px_273 = J.arg(a, 4)
	v_fill_274 = J.arg(a, 5)
	v_stroke_275 = J.arg(a, 6)
	var _t397 = ("900 " + J.str(v_px_273) + "px sans-serif")
	J.sp(v_c_269, "font", _t397)
	J.sp(v_c_269, "textAlign", "center")
	J.sp(v_c_269, "lineJoin", "round")
	var _t398 = J.max_([3.0, J.mul(v_px_273, 0.22)])
	J.sp(v_c_269, "lineWidth", _t398)
	var _t399 = (v_stroke_275 if J.t(v_stroke_275) else "#1a0f04")
	J.sp(v_c_269, "strokeStyle", _t399)
	J.mc(v_c_269, "strokeText", [v_s_270, v_x_271, v_y_272])
	J.sp(v_c_269, "fillStyle", v_fill_274)
	J.mc(v_c_269, "fillText", [v_s_270, v_x_271, v_y_272])

func _f61(this_, a: Array, env):
	return env["S"]

func _f1(this_, a: Array, env):
	var v_reset_12 = null; var v_roll_20 = null; var v_decorate_21 = null; var v_blocks_25 = null; var v_devMul_26 = null; var v_onHit_27 = null; var v_update_31 = null; var v_draw_41 = null; var v_drawBody_42 = null
	var _s2 = {"__p": env, "PX": null, "CELL": null, "R": null, "pick": null, "T": null, "now": null, "RES": null, "FOES": null, "IDS": null, "S": null, "brkAdd": null, "sealIm": null, "line": null, "setTimeoutSafe": null, "slotChance": null, "spawnTable": null, "waveCap": null, "sealOf": null, "isSealed": null, "isPaused": null, "release": null, "spotOf": null, "devList": null, "taoTick": null, "huntTick": null, "streamTick": null, "FU": null, "fuCanvas": null, "drawFu": null, "chainLine": null, "bigTxt": null, "devRect": null, "drawQ": null}
	v_reset_12 = Callable(self, "_f6").bind(_s2)
	_s2["line"] = Callable(self, "_f9").bind(_s2)
	_s2["slotChance"] = Callable(self, "_f13").bind(_s2)
	_s2["spawnTable"] = Callable(self, "_f14").bind(_s2)
	v_roll_20 = Callable(self, "_f19").bind(_s2)
	v_decorate_21 = Callable(self, "_f20").bind(_s2)
	_s2["isSealed"] = Callable(self, "_f23").bind(_s2)
	_s2["isPaused"] = Callable(self, "_f24").bind(_s2)
	v_blocks_25 = Callable(self, "_f25").bind(_s2)
	v_devMul_26 = Callable(self, "_f26").bind(_s2)
	v_onHit_27 = Callable(self, "_f27").bind(_s2)
	_s2["release"] = Callable(self, "_f29").bind(_s2)
	_s2["spotOf"] = Callable(self, "_f31").bind(_s2)
	_s2["devList"] = Callable(self, "_f32").bind(_s2)
	v_update_31 = Callable(self, "_f34").bind(_s2)
	_s2["taoTick"] = Callable(self, "_f39").bind(_s2)
	_s2["huntTick"] = Callable(self, "_f41").bind(_s2)
	_s2["streamTick"] = Callable(self, "_f50").bind(_s2)
	_s2["fuCanvas"] = Callable(self, "_f51").bind(_s2)
	_s2["drawFu"] = Callable(self, "_f52").bind(_s2)
	_s2["chainLine"] = Callable(self, "_f53").bind(_s2)
	_s2["devRect"] = Callable(self, "_f55").bind(_s2)
	v_draw_41 = Callable(self, "_f56").bind(_s2)
	v_drawBody_42 = Callable(self, "_f59").bind(_s2)
	_s2["drawQ"] = Callable(self, "_f60").bind(_s2)
	_s2["PX"] = J.div(1.0, 2160.0)
	_s2["CELL"] = J.mul(150.0, _s2["PX"])
	_s2["R"] = Callable(self, "_f2").bind(_s2)
	_s2["pick"] = Callable(self, "_f3").bind(_s2)
	_s2["T"] = Callable(self, "_f4").bind(_s2)
	_s2["now"] = Callable(self, "_f5").bind(_s2)
	_s2["RES"] = {"cap": 0.4, "tail": 0.2}
	_s2["FOES"] = {"taoist": {"n": ["茅山道士", "茅山道士"], "tag": "#ffd45a", "minLv": 6.0, "w": 1.0, "hp": 3.6, "spd": 0.8, "award": 4.0, "res": true, "range": 240.0, "chant": 1.6, "seal": [6.0, 10.0], "maxSeal": 2.0, "cd": 3.5, "retreat": 0.45, "chantL": [["孽障，乖乖返去！", "孽障，乖乖回去！"], ["呢度唔到你放肆！", "這裡輪不到你放肆！"], ["貧道今晚當值，咪搞事。", "貧道今晚值班，別搗亂。"], ["陰陽有別，退！", "陰陽有別，退！"], ["定！", "定！"]], "retreatL": [["好重陰氣……撤符先！", "陰氣好重……先撤符！"], ["今晚算你哋叻。", "今晚算你們厲害。"]], "re": [["嗯？有啲門道。", "嗯？有點門道。"], ["穩住，唔好亂。", "穩住，不要亂。"], ["小把戲。", "小把戲。"]], "big": [["改日再嚟會你！", "改天再來會你！"], ["道行唔夠，收工！", "道行不夠，收工！"]]}, "hunter": {"n": ["現代捉鬼師", "現代捉鬼師"], "tag": "#7fd0ff", "minLv": 4.0, "w": 1.2, "hp": 3.0, "spd": 0.95, "award": 3.5, "res": true, "beam": {"r": 300.0, "half": 0.75, "dur": 4.0, "cd": [5.0, 7.0], "scan": 1.1}, "salt": {"r": 1.3, "reach": 300.0, "dur": 6.0, "mul": 0.6, "cd": [9.0, 13.0]}, "beamL": [["照住你，咪郁！", "照住你，別動！"], ["羅盤轉到癲咗，就喺度！", "羅盤轉瘋了，就在這！"], ["讀數爆錶！", "讀數爆表！"]], "saltL": [["鹽米開路！", "鹽米開路！"], ["灑啲鹽米先，穩陣啲。", "先撒點鹽米，穩妥點。"]], "re": [["數據有異動……", "數據有異動……"], ["冇事，計我嘅。", "沒事，交給我。"]], "big": [["數據唔對路，撤！", "數據不對勁，撤！"], ["器材頂唔順喇！", "器材撐不住了！"]]}, "streamer": {"n": ["靈異直播主", "靈異直播主"], "tag": "#ff7ab8", "minLv": 2.0, "w": 1.4, "hp": 0.7, "spd": 0.9, "award": 2.5, "res": false, "take": 1.3, "aura": {"r": 170.0, "mul": 1.3}, "talkCd": [6.0, 9.0], "talkL": [["家人們，入嚟睇吓！", "家人們，進來看看！"], ["打賞夠一千我就行入去！", "打賞滿一千我就走進去！"], ["唔使驚，有我喺度！", "不用怕，有我在！"], ["燈開大啲，畀大家睇清楚！", "燈開大點，讓大家看清楚！"]], "re": [["啊！你哋見唔見到？", "啊！你們看到沒有？"], ["冇事冇事……", "沒事沒事……"]], "big": [["哇！斷咗線先！", "哇！先斷線！"], ["今晚唔播喇！", "今晚不播了！"]]}}
	_s2["IDS"] = J.S_Object_("keys", [_s2["FOES"]])
	_s2["S"] = null
	_s2["brkAdd"] = Callable(self, "_f7").bind(_s2)
	_s2["sealIm"] = Callable(self, "_f8").bind(_s2)
	J.cl(v_reset_12, null, [])
	_s2["setTimeoutSafe"] = Callable(self, "_f12").bind(_s2)
	_s2["waveCap"] = Callable(self, "_f18").bind(_s2)
	_s2["sealOf"] = Callable(self, "_f21").bind(_s2)
	_s2["FU"] = null
	_s2["bigTxt"] = Callable(self, "_f54").bind(_s2)
	return {"FOES": _s2["FOES"], "RES": _s2["RES"], "reset": v_reset_12, "spawnTable": _s2["spawnTable"], "roll": v_roll_20, "decorate": v_decorate_21, "update": v_update_31, "draw": v_draw_41, "drawBody": v_drawBody_42, "drawFu": _s2["drawFu"], "onHit": v_onHit_27, "isSealed": _s2["isSealed"], "isPaused": _s2["isPaused"], "blocks": v_blocks_25, "devMul": v_devMul_26, "__getters": {"state": Callable(self, "_f61").bind(_s2)}}
