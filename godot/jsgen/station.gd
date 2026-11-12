# 自動轉譯自 station.js（tools/jsgd.js）——唔好直接改，改原 JS 再轉
extends RefCounted

func run(env):
	var this_ = null; var a = []
	J.G["Station"] = J.cl(Callable(self, "_f1").bind(env), null, [])
	J.cl(Callable(self, "_f147").bind(env), null, [])

func _f13(this_, a: Array, env):
	var v_g_79 = null; var v_def_80 = null; var v_lines_81 = null
	v_g_79 = J.arg(a, 0)
	v_def_80 = J.arg(a, 1)
	var _t3 = J.gp(env["SKIT"], J.gp(v_g_79, "k"))
	if not J.t(_t3):
		var _t2 = J.gp(v_def_80, "short")
		var _t1 = env["legendName"]
		_t3 = [["旁白", (J.str(_t2) + "附近開始有人講起「" + J.str(J.cl(_t1, null, [J.gp(v_g_79, "k"), v_g_79])) + "」。")], [J.gp(v_g_79, "name"), "終於有人記得我了。"]]
	v_lines_81 = _t3
	var _t4 = env["legendName"]
	return {"style": "talk", "title": ("怪談成形：" + J.str(J.cl(_t4, null, [J.gp(v_g_79, "k"), v_g_79]))), "lines": v_lines_81}

func _f15(this_, a: Array, env):
	return null

func _f16(this_, a: Array, env):
	return null

func _f14(this_, a: Array, env):
	var v_s_84 = null; var v_m_85 = null; var v_m_86 = null; var v_ms_87 = null
	if (not J.t(J.gp(J.G.get("S"), "station"))):
		var _t5 = J.G.get("S")
		var _t6 = {"maps": {}, "t": J.S_Date_("now", []), "log": []}
		J.sp(_t5, "station", _t6)
	v_s_84 = J.gp(J.G.get("S"), "station")
	var _t7 = J.gp(v_s_84, "maps")
	var _t8 = (_t7 if J.t(_t7) else {})
	J.sp(v_s_84, "maps", _t8)
	var _t9 = J.gp(v_s_84, "log")
	var _t10 = (_t9 if J.t(_t9) else [])
	J.sp(v_s_84, "log", _t10)
	for _t11 in J.iter(env["MAPS"]):
		v_m_85 = _t11
		if (not J.t(J.gp(J.gp(v_s_84, "maps"), J.gp(v_m_85, "id")))):
			var _t12 = J.gp(v_s_84, "maps")
			var _t13 = J.gp(v_m_85, "id")
			var _t14 = J.gp(v_m_85, "posts")
			var _t16 = J.mc(_t14, "map", [Callable(self, "_f15").bind(env)])
			var _t17 = []
			var _t18 = {}
			var _t15 = J.gp(v_m_85, "posts")
			var _t19 = {"posts": _t16, "habit": 1.0, "hist": _t17, "used": _t18, "stableAt": 0.0, "stable": false, "enemy": J.mc(_t15, "map", [Callable(self, "_f16").bind(env)]), "morale": {}, "leg": {}, "nextRaid": 0.0, "nextBryan": 0.0, "bank": 0.0, "cd": {}, "boost": {}}
			J.sp(_t12, _t13, _t19)
	for _t20 in J.iter(env["MAPS"]):
		v_m_86 = _t20
		v_ms_87 = J.gp(J.gp(v_s_84, "maps"), J.gp(v_m_86, "id"))
		while true:
			if not (J.len(J.gp(v_ms_87, "posts")) < J.len(J.gp(v_m_86, "posts"))): break
			var _t21 = J.gp(v_ms_87, "posts")
			J.mc(_t21, "push", [null])
		while true:
			if not (J.len(J.gp(v_ms_87, "enemy")) < J.len(J.gp(v_m_86, "posts"))): break
			var _t22 = J.gp(v_ms_87, "enemy")
			J.mc(_t22, "push", [null])
	return v_s_84

func _f20(this_, a: Array, env):
	var v_k_93 = null; var v_g_94 = null; var v_t_95 = null
	v_k_93 = J.arg(a, 0)
	var _t23 = env["has"]
	if J.t(J.cl(_t23, null, [J.G.get("Rework")])):
		v_t_95 = J.mc(J.G.get("Rework"), "typesOf", [v_k_93])
		if J.t(v_t_95):
			return v_t_95
	var _t24 = env["has"]
	var _t25 = J.cl(_t24, null, [J.G.get("SCARE_GHOSTS")])
	v_g_94 = (J.gp(J.G.get("SCARE_GHOSTS"), v_k_93) if J.t(_t25) else _t25)
	var _t27 = null
	if J.t(v_g_94):
		var _t26 = J.gp(v_g_94, "types")
		_t27 = (_t26 if J.t(_t26) else [J.gp(v_g_94, "type")])
	else:
		_t27 = [J.gp(env["TYPES"], J.mod((J.len(v_k_93) * 7.0), 8.0))]
	return _t27

func _f21(this_, a: Array, env):
	var v_k_98 = null
	v_k_98 = J.arg(a, 0)
	var _t28 = env["has"]
	return (J.mc(J.G.get("Rework"), "drillLv", [v_k_98]) if J.t(J.cl(_t28, null, [J.G.get("Rework")])) else 1.0)

func _f22(this_, a: Array, env):
	var v_k_101 = null; var v_f_102 = null
	v_k_101 = J.arg(a, 0)
	if J.seq(v_k_101, "bryan"):
		return "sound"
	var _t29 = env["has"]
	v_f_102 = (J.mc(J.G.get("Rework"), "fearOf", [v_k_101]) if J.t(J.cl(_t29, null, [J.G.get("Rework")])) else null)
	return (J.gp(J.gp(v_f_102, "i"), 0.0) if J.t(v_f_102) else "shadow")

func _f23(this_, a: Array, env):
	var v_g_105 = null
	v_g_105 = J.arg(a, 0)
	var _t30 = env["has"]
	return J.mul(34.0, (J.mc(J.G.get("GP"), "mul", [v_g_105]) if J.t(J.cl(_t30, null, [J.G.get("GP")])) else 1.0))

func _f24(this_, a: Array, env):
	var v_k_108 = null; var v_m_109 = null
	v_k_108 = J.arg(a, 0)
	v_m_109 = J.arg(a, 1)
	return (70.0 if J.seq(v_k_108, "bryan") else (30.0 + J.mul(J.gp(v_m_109, "habit"), 2.2)))

func _f27(this_, a: Array, env):
	var v_m_119 = null; var v_s_120 = null
	v_m_119 = J.arg(a, 0)
	var _t31 = env["share"]
	v_s_120 = J.cl(_t31, null, [v_m_119])
	if J.cmp(J.gp(v_s_120, "n"), 10.0, "<"):
		return {"k": "new", "t": "剛開始"}
	if J.cmp(J.gp(v_s_120, "me"), 0.6, ">="):
		return {"k": "own", "t": "佔領"}
	if J.cmp(J.gp(v_s_120, "me"), 0.4, ">="):
		return {"k": "war", "t": "爭奪中"}
	return {"k": "lost", "t": "失守"}

func _f29(this_, a: Array, env):
	var v_a_128 = null; var v_b_129 = null
	v_a_128 = J.arg(a, 0)
	v_b_129 = J.arg(a, 1)
	return J.add(v_a_128, v_b_129)

func _f28(this_, a: Array, env):
	var v_m_123 = null; var v_type_124 = null; var v_u_125 = null; var v_tot_126 = null; var v_f_127 = null
	v_m_123 = J.arg(a, 0)
	v_type_124 = J.arg(a, 1)
	v_u_125 = J.gp(v_m_123, "used")
	var _t32 = J.S_Object_("values", [v_u_125])
	var _t33 = J.mc(_t32, "reduce", [Callable(self, "_f29").bind(env), 0.0])
	v_tot_126 = (_t33 if J.t(_t33) else 1.0)
	var _t34 = J.gp(v_u_125, v_type_124)
	v_f_127 = J.div((_t34 if J.t(_t34) else 0.0), v_tot_126)
	return (1.0 - J.max_([0.0, J.min_([0.4, (J.sub(v_f_127, 0.34) * 0.6)])]))

func _f30(this_, a: Array, env):
	var v_m_132 = null; var v_gid_133 = null; var v_n_134 = null
	v_m_132 = J.arg(a, 0)
	v_gid_133 = J.arg(a, 1)
	var _t35 = J.gp(J.gp(v_m_132, "leg"), v_gid_133)
	v_n_134 = (_t35 if J.t(_t35) else 0.0)
	return (3.0 if J.cmp(v_n_134, J.gp(env["LEG_N"], 2.0), ">=") else (2.0 if J.cmp(v_n_134, J.gp(env["LEG_N"], 1.0), ">=") else (1.0 if J.cmp(v_n_134, J.gp(env["LEG_N"], 0.0), ">=") else 0.0)))

func _f32(this_, a: Array, env):
	return (randf() - 0.5)

func _f31(this_, a: Array, env):
	var v_def_137 = null; var v_m_138 = null; var v_p_139 = null; var v_hb_140 = null; var v_weak_141 = null; var v_nWeak_142 = null; var v_tough_143 = null
	v_def_137 = J.arg(a, 0)
	v_m_138 = J.arg(a, 1)
	v_p_139 = J.gp(J.gp(v_def_137, "people"), floor(J.num((randf() * J.len(J.gp(v_def_137, "people"))))))
	v_hb_140 = J.gp(v_m_138, "habit")
	var _t36 = J.mc(J.gp(v_p_139, "weak"), "slice", [])
	v_weak_141 = J.mc(_t36, "sort", [Callable(self, "_f32").bind(env)])
	v_nWeak_142 = (2.0 if J.cmp(v_hb_140, 4.0, "<") else ((2.0 if (randf() < 0.5) else 1.0) if J.cmp(v_hb_140, 7.0, "<") else 1.0))
	var _t37 = J.mc(v_weak_141, "slice", [0.0, v_nWeak_142])
	v_weak_141 = _t37
	v_tough_143 = (3.0 if J.cmp(v_hb_140, 10.0, ">=") else (2.0 if J.cmp(v_hb_140, 7.0, ">=") else 1.0))
	var _t40 = J.gp(v_p_139, "spr")
	var _t41 = J.gp(v_p_139, "name")
	var _t42 = J.gp(v_p_139, "imm")
	var _t39 = J.add(J.gp(env["TUNE"], "hp0"), J.mul(J.min_([10.0, v_hb_140]), J.gp(env["TUNE"], "hpLv")))
	var _t38 = J.gp(v_def_137, "easy")
	return {"def": v_p_139, "spr": _t40, "name": _t41, "weak": v_weak_141, "imm": _t42, "hp": J.mul(_t39, (_t38 if J.t(_t38) else 1.0)), "fear": 0.0, "dazed": null, "hits": 0.0, "tough": v_tough_143, "done": false, "by": 0.0, "x": 0.0, "i": 0.0, "t": 0.0, "react": 0.0, "say": null}

func _f33(this_, a: Array, env):
	var v_def_146 = null; var v_m_147 = null; var v_pi_148 = null; var v_P_149 = null; var v_who_150 = null; var v_post_151 = null; var v_type_152 = null; var v_pw_153 = null; var v_g_154 = null; var v_legend_155 = null; var v_mul_156 = null; var v_tag_157 = null; var v_combo_158 = null; var v_dmg_159 = null; var v_coin_160 = null; var v_e_161 = null
	v_def_146 = J.arg(a, 0)
	v_m_147 = J.arg(a, 1)
	v_pi_148 = J.arg(a, 2)
	v_P_149 = J.arg(a, 3)
	v_who_150 = J.arg(a, 4)
	v_post_151 = J.gp(J.gp(v_def_146, "posts"), v_pi_148)
	v_type_152 = null
	v_pw_153 = null
	v_g_154 = null
	v_legend_155 = 0.0
	if J.seq(v_who_150, 1.0):
		var _t43 = env["ghost"]
		var _t44 = J.cl(_t43, null, [J.gp(J.gp(v_m_147, "posts"), v_pi_148)])
		v_g_154 = _t44
		if (not J.t(v_g_154)):
			return null
		var _t45 = env["typesOf"]
		var _t46 = J.gp(J.cl(_t45, null, [J.gp(v_g_154, "k")]), 0.0)
		v_type_152 = _t46
		var _t47 = env["power"]
		var _t48 = J.cl(_t47, null, [v_g_154])
		v_pw_153 = _t48
		var _t49 = env["legLv"]
		var _t50 = J.cl(_t49, null, [v_m_147, J.gp(v_g_154, "id")])
		v_legend_155 = _t50
		if J.seq(J.gp(v_g_154, "k"), "toyol"):
			v_coin_160 = (1.0 + floor(J.num(J.div(J.gp(v_m_147, "habit"), 3.0))))
			var _t51 = env["has"]
			var _t52 = J.cl(_t51, null, [J.G.get("S")])
			if J.t((J.gp(J.G.get("S"), "res") if J.t(_t52) else _t52)):
				var _t53 = J.gp(J.G.get("S"), "res")
				var _t54 = J.add(J.gp(_t53, "coins"), v_coin_160)
				J.sp(_t53, "coins", _t54)
			var _t55 = J.gp(v_m_147, "stolen")
			var _t56 = J.add((_t55 if J.t(_t55) else 0.0), v_coin_160)
			J.sp(v_m_147, "stolen", _t56)
			J.sp(v_P_149, "dazed", "steal")
			J.sp(v_P_149, "stolen", true)
			var _t57 = J.gp(v_m_147, "leg")
			var _t58 = J.gp(v_g_154, "id")
			var _t59 = J.gp(J.gp(v_m_147, "leg"), J.gp(v_g_154, "id"))
			var _t60 = J.add((_t59 if J.t(_t59) else 0.0), 0.34)
			J.sp(_t57, _t58, _t60)
			return {"dmg": J.mul(J.gp(v_P_149, "hp"), 0.25), "combo": false, "tag": ("偷了 " + J.str(v_coin_160) + " 冥幣"), "type": "steal", "g": v_g_154}
	else:
		v_e_161 = J.gp(J.gp(v_m_147, "enemy"), v_pi_148)
		if (not J.t(v_e_161)):
			return null
		var _t61 = env["rivalType"]
		var _t62 = J.cl(_t61, null, [J.gp(v_e_161, "k")])
		v_type_152 = _t62
		var _t63 = env["rivalPower"]
		var _t64 = J.cl(_t63, null, [J.gp(v_e_161, "k"), v_m_147])
		v_pw_153 = _t64
	v_mul_156 = 1.0
	v_tag_157 = ""
	var _t65 = J.gp(v_P_149, "imm")
	var _t66 = J.mc(_t65, "includes", [v_type_152])
	if J.t(((not J.cmp(v_legend_155, 3.0, ">=")) if J.t(_t66) else _t66)):
		var _t67 = J.mul(v_mul_156, 0.5)
		v_mul_156 = _t67
		v_tag_157 = "不怕"
	else:
		var _t68 = J.gp(v_P_149, "weak")
		var _t69 = J.mc(_t68, "includes", [v_type_152])
		if J.t((_t69 if J.t(_t69) else J.cmp(v_legend_155, 3.0, ">="))):
			var _t70 = J.mul(v_mul_156, 1.5)
			v_mul_156 = _t70
			v_tag_157 = "怕"
	if J.seq(J.gp(v_post_151, "fit"), v_type_152):
		var _t71 = J.mul(v_mul_156, 1.3)
		v_mul_156 = _t71
	v_combo_158 = false
	var _t72 = J.gp(v_P_149, "dazed")
	var _t75 = ((not J.seq(J.gp(v_P_149, "dazed"), v_type_152)) if J.t(_t72) else _t72)
	if J.t(_t75):
		var _t73 = J.gp(v_P_149, "imm")
		var _t74 = (not J.t(J.mc(_t73, "includes", [v_type_152])))
		_t75 = (_t74 if _t74 else J.cmp(v_legend_155, 3.0, ">="))
	if J.t(_t75):
		var _t76 = J.mul(v_mul_156, 1.5)
		v_mul_156 = _t76
		v_combo_158 = true
	var _t77 = env["adapt"]
	var _t78 = J.mul(v_mul_156, J.cl(_t77, null, [v_m_147, v_type_152]))
	v_mul_156 = _t78
	var _t79 = J.cmp(J.gp(v_P_149, "tough"), 1.0, ">")
	if (J.seq(J.gp(v_P_149, "hits"), 0.0) if _t79 else _t79):
		var _t80 = J.mul(v_mul_156, 0.5)
		v_mul_156 = _t80
	var _t81 = J.seq(v_who_150, 1.0)
	if J.t((J.gp(J.gp(v_m_147, "boost"), v_pi_148) if _t81 else _t81)):
		var _t82 = J.mul(v_mul_156, 2.5)
		v_mul_156 = _t82
		var _t83 = J.gp(v_m_147, "boost")
		J.sp(_t83, v_pi_148, 0.0)
		v_tag_157 = "大招"
	var _t84 = J.seq(v_who_150, 1.0)
	if (J.cmp(v_legend_155, 1.0, ">=") if _t84 else _t84):
		var _t85 = J.mul(v_mul_156, (1.0 + J.mul(0.08, v_legend_155)))
		v_mul_156 = _t85
	var _t86 = J.seq(v_who_150, 2.0)
	if J.t((J.gp(v_m_147, "stable") if _t86 else _t86)):
		var _t87 = J.mul(v_mul_156, 0.8)
		v_mul_156 = _t87
	var _t89 = J.mul(v_pw_153, v_mul_156)
	var _t88 = env["R"]
	v_dmg_159 = J.mul(_t89, J.cl(_t88, null, [0.85, 1.15]))
	var _t90 = J.gp(v_m_147, "used")
	var _t91 = J.gp(J.gp(v_m_147, "used"), v_type_152)
	var _t92 = (J.mul((_t91 if J.t(_t91) else 0.0), 0.98) + 1.0)
	J.sp(_t90, v_type_152, _t92)
	return {"dmg": v_dmg_159, "combo": v_combo_158, "tag": v_tag_157, "type": v_type_152, "g": v_g_154}

func _f34(this_, a: Array, env):
	var v_def_164 = null; var v_m_165 = null; var v_pi_166 = null; var v_P_167 = null; var v_res_168 = null; var v_who_169 = null; var v_r_170 = null; var v_broke_171 = null
	v_def_164 = J.arg(a, 0)
	v_m_165 = J.arg(a, 1)
	v_pi_166 = J.arg(a, 2)
	v_P_167 = J.arg(a, 3)
	v_res_168 = []
	for _t93 in J.iter([2.0, 1.0]):
		v_who_169 = _t93
		if J.t(J.gp(v_P_167, "done")):
			break
		var _t94 = env["strike"]
		v_r_170 = J.cl(_t94, null, [v_def_164, v_m_165, v_pi_166, v_P_167, v_who_169])
		if (not J.t(v_r_170)):
			continue
		var _t95 = J.add(J.gp(v_P_167, "fear"), J.gp(v_r_170, "dmg"))
		J.sp(v_P_167, "fear", _t95)
		J.sp(v_P_167, "hits", J.num(J.gp(v_P_167, "hits")) + 1.0)
		if J.t(J.gp(v_r_170, "combo")):
			var _t96 = J.gp(v_P_167, "combos")
			var _t97 = J.add((_t96 if J.t(_t96) else 0.0), 1.0)
			J.sp(v_P_167, "combos", _t97)
		var _t100 = J.cmp(J.gp(v_P_167, "fear"), J.gp(v_P_167, "hp"), ">=")
		if J.t(_t100):
			var _t99 = J.cmp(J.gp(v_P_167, "tough"), 1.0, "<=")
			if not J.t(_t99):
				var _t98 = J.gp(v_P_167, "combos")
				_t99 = J.cmp((_t98 if J.t(_t98) else 0.0), J.sub(J.gp(v_P_167, "tough"), 1.0), ">=")
			_t100 = _t99
		v_broke_171 = _t100
		if J.cmp(J.gp(v_P_167, "fear"), J.mul(J.gp(v_P_167, "hp"), 0.5), ">="):
			var _t101 = J.gp(v_r_170, "type")
			J.sp(v_P_167, "dazed", _t101)
		var _t102 = {}
		_t102["who"] = v_who_169
		J.assign(_t102, [v_r_170])
		_t102["broke"] = v_broke_171
		J.mc(v_res_168, "push", [_t102])
		if J.t(v_broke_171):
			J.sp(v_P_167, "done", true)
			J.sp(v_P_167, "by", v_who_169)
	return v_res_168

func _f36(this_, a: Array, env):
	var v_n_178 = null
	v_n_178 = J.arg(a, 0)
	return J.cmp(v_n_178, J.gp(env["LEG_N"], 0.0), ">=")

func _f35(this_, a: Array, env):
	var v_def_174 = null; var v_m_175 = null; var v_P_176 = null; var v_slow_177 = null; var v_pts_179 = null; var v_gid_180 = null
	v_def_174 = J.arg(a, 0)
	v_m_175 = J.arg(a, 1)
	v_P_176 = J.arg(a, 2)
	var _t103 = J.gp(v_m_175, "hist")
	var _t104 = J.gp(v_P_176, "by")
	J.mc(_t103, "push", [(_t104 if J.t(_t104) else 0.0)])
	if (J.len(J.gp(v_m_175, "hist")) > 100.0):
		J.mc(J.gp(v_m_175, "hist"), "shift", [])
	var _t105 = J.S_Object_("values", [J.gp(v_m_175, "leg")])
	v_slow_177 = (0.8 if J.t(J.mc(_t105, "some", [Callable(self, "_f36").bind(env)])) else 1.0)
	var _t106 = J.min_([10.0, J.add(J.gp(v_m_175, "habit"), J.mul(J.add(J.gp(env["TUNE"], "habitSeen"), (0.0 if J.t(J.gp(v_P_176, "by")) else J.gp(env["TUNE"], "habitUp"))), v_slow_177))])
	J.sp(v_m_175, "habit", _t106)
	if (not J.t(J.gp(v_P_176, "by"))):
		return null
	if J.seq(J.gp(v_P_176, "by"), 1.0):
		v_pts_179 = (1.0 + J.mul(J.gp(v_m_175, "habit"), 0.3))
		var _t107 = J.add(J.gp(v_m_175, "bank"), v_pts_179)
		J.sp(v_m_175, "bank", _t107)
		v_gid_180 = J.gp(J.gp(v_m_175, "posts"), J.gp(v_P_176, "atPost"))
		if (not J.leq(v_gid_180, null)):
			var _t108 = J.gp(v_m_175, "leg")
			var _t109 = J.gp(J.gp(v_m_175, "leg"), v_gid_180)
			var _t110 = J.add((_t109 if J.t(_t109) else 0.0), 1.0)
			J.sp(_t108, v_gid_180, _t110)

func _f38(this_, a: Array, env):
	var v___187 = null; var v_i_188 = null
	v___187 = J.arg(a, 0)
	v_i_188 = J.arg(a, 1)
	return v_i_188

func _f37(this_, a: Array, env):
	var v_def_183 = null; var v_m_184 = null; var v_P_185 = null; var v_order_186 = null; var v_i_189 = null; var v_reps_190 = null; var v_r_191 = null
	v_def_183 = J.arg(a, 0)
	v_m_184 = J.arg(a, 1)
	var _t111 = env["makePerson"]
	v_P_185 = J.cl(_t111, null, [v_def_183, v_m_184])
	var _t112 = J.gp(v_def_183, "posts")
	v_order_186 = J.mc(_t112, "map", [Callable(self, "_f38").bind(env)])
	for _t113 in J.iter(v_order_186):
		v_i_189 = _t113
		var _t114 = J.gp(v_def_183, "wait")
		v_reps_190 = (J.gp(v_def_183, "wait") if J.t((J.seq(v_i_189, 1.0) if J.t(_t114) else _t114)) else 1.0)
		v_r_191 = 0.0
		while true:
			var _t115 = J.cmp(v_r_191, v_reps_190, "<")
			if not ((not J.t(J.gp(v_P_185, "done"))) if _t115 else _t115): break
			var _t116 = env["passPost"]
			J.cl(_t116, null, [v_def_183, v_m_184, v_i_189, v_P_185])
			if J.t(J.gp(v_P_185, "done")):
				J.sp(v_P_185, "atPost", v_i_189)
			v_r_191 = J.num(v_r_191) + 1.0
	var _t117 = env["finish"]
	J.cl(_t117, null, [v_def_183, v_m_184, v_P_185])
	return v_P_185

func _f40(this_, a: Array, env):
	var v_d_199 = null
	v_d_199 = J.arg(a, 0)
	var _t118 = env["__p"]["open"]
	var _t121 = J.cl(_t118, null, [v_d_199])
	if J.t(_t121):
		var _t119 = env["__p"]["status"]
		var _t120 = env["__p"]["ms"]
		_t121 = J.seq(J.gp(J.cl(_t119, null, [J.cl(_t120, null, [J.gp(v_d_199, "id")])]), "k"), "own")
	return _t121

func _f41(this_, a: Array, env):
	var v_e_204 = null; var v_i_205 = null
	v_e_204 = J.arg(a, 0)
	v_i_205 = J.arg(a, 1)
	var _t131 = (not J.t(v_e_204))
	return (v_i_205 if (J.leq(J.gp(J.gp(env["m"], "posts"), v_i_205), null) if _t131 else _t131) else (-1.0))

func _f42(this_, a: Array, env):
	var v_i_206 = null
	v_i_206 = J.arg(a, 0)
	return J.cmp(v_i_206, 0.0, ">=")

func _f43(this_, a: Array, env):
	var v_e_207 = null; var v_i_208 = null
	v_e_207 = J.arg(a, 0)
	v_i_208 = J.arg(a, 1)
	var _t134 = (not J.t(v_e_207))
	return (v_i_208 if ((not J.leq(J.gp(J.gp(env["m"], "posts"), v_i_208), null)) if _t134 else _t134) else (-1.0))

func _f44(this_, a: Array, env):
	var v_i_209 = null
	v_i_209 = J.arg(a, 0)
	return J.cmp(v_i_209, 0.0, ">=")

func _f46(this_, a: Array, env):
	var v_x_211 = null; var v_y_212 = null
	v_x_211 = J.arg(a, 0)
	v_y_212 = J.arg(a, 1)
	return J.sub(v_x_211, v_y_212)

func _f45(this_, a: Array, env):
	var v_a_210 = null
	v_a_210 = J.arg(a, 0)
	return J.gp(J.mc(v_a_210, "sort", [Callable(self, "_f46").bind(env)]), 0.0)

func _f47(this_, a: Array, env):
	var v_e_215 = null; var v_i_216 = null
	v_e_215 = J.arg(a, 0)
	v_i_216 = J.arg(a, 1)
	return (v_i_216 if (not J.t(v_e_215)) else (-1.0))

func _f48(this_, a: Array, env):
	var v_i_217 = null
	v_i_217 = J.arg(a, 0)
	return J.cmp(v_i_217, 0.0, ">=")

func _f49(this_, a: Array, env):
	var v_e_218 = null; var v_i_219 = null; var v_gid_220 = null; var v_mor_221 = null; var v_g_222 = null
	v_e_218 = J.arg(a, 0)
	v_i_219 = J.arg(a, 1)
	var _t165 = (not J.t(v_e_218))
	if (_t165 if _t165 else J.leq(J.gp(J.gp(env["m"], "posts"), v_i_219), null)):
		return null
	v_gid_220 = J.gp(J.gp(env["m"], "posts"), v_i_219)
	v_mor_221 = J.sub((J.gp(env["__p"]["TUNE"], "morale") if J.leq(J.gp(J.gp(env["m"], "morale"), v_gid_220), null) else J.gp(J.gp(env["m"], "morale"), v_gid_220)), (J.mul(J.gp(env["__p"]["TUNE"], "harass"), env["mins"]) * (2.0 if J.seq(J.gp(v_e_218, "k"), "bryan") else 1.0)))
	var _t166 = J.gp(env["m"], "morale")
	var _t167 = J.max_([0.0, v_mor_221])
	J.sp(_t166, v_gid_220, _t167)
	if J.cmp(J.gp(J.gp(env["m"], "morale"), v_gid_220), 0.0, "<="):
		var _t168 = env["__p"]["ghost"]
		v_g_222 = J.cl(_t168, null, [v_gid_220])
		var _t169 = J.gp(env["m"], "posts")
		J.sp(_t169, v_i_219, null)
		if J.t(v_g_222):
			J.sp(v_g_222, "post", null)
			var _t170 = J.add(env["now"], (30.0 * 60000.0))
			J.sp(v_g_222, "tiredUntil", _t170)
		var _t171 = J.gp(env["m"], "morale")
		var _t172 = J.gp(env["__p"]["TUNE"], "morale")
		J.sp(_t171, v_gid_220, _t172)
		var _t173 = env["__p"]["log"]
		J.cl(_t173, null, [("<b>" + J.str((J.gp(v_g_222, "name") if J.t(v_g_222) else "我方的鬼")) + "</b>在" + J.str(J.gp(env["def"], "short")) + "・" + J.str(J.gp(J.gp(J.gp(env["def"], "posts"), v_i_219), "name")) + "被" + J.str(J.gp(env["__p"]["RNAME"], J.gp(v_e_218, "k"))) + "趕走了，崗位被搶。")])

func _f50(this_, a: Array, env):
	var v_gid_223 = null; var v_i_224 = null
	v_gid_223 = J.arg(a, 0)
	v_i_224 = J.arg(a, 1)
	var _t175 = (not J.leq(v_gid_223, null))
	if ((not J.t(J.gp(J.gp(env["m"], "enemy"), v_i_224))) if _t175 else _t175):
		var _t176 = J.gp(env["m"], "morale")
		var _t177 = J.min_([J.gp(env["__p"]["TUNE"], "morale"), J.add((J.gp(env["__p"]["TUNE"], "morale") if J.leq(J.gp(J.gp(env["m"], "morale"), v_gid_223), null) else J.gp(J.gp(env["m"], "morale"), v_gid_223)), J.mul(6.0, env["mins"]))])
		J.sp(_t176, v_gid_223, _t177)

func _f39(this_, a: Array, env):
	var v_heldN_198 = null; var v_empty_200 = null; var v_mine_201 = null; var v_front_202 = null; var v_i_203 = null; var v_free_213 = null; var v_i_214 = null
	var _s61 = {"__p": env, "def": null, "m": null, "mins": null, "now": null}
	_s61["def"] = J.arg(a, 0)
	_s61["m"] = J.arg(a, 1)
	_s61["mins"] = J.arg(a, 2)
	_s61["now"] = J.S_Date_("now", [])
	v_heldN_198 = J.len(J.mc(_s61["__p"]["MAPS"], "filter", [Callable(self, "_f40").bind(_s61)]))
	if (not J.t(J.gp(_s61["m"], "nextRaid"))):
		var _t122 = _s61["m"]
		var _t124 = _s61["now"]
		var _t123 = _s61["__p"]["R"]
		var _t125 = J.add(_t124, J.div(J.mul(J.cl(_t123, null, [J.gp(_s61["__p"]["TUNE"], "raidMin"), J.gp(_s61["__p"]["TUNE"], "raidMax")]), 60000.0), (1.0 + J.mul(v_heldN_198, 0.3))))
		J.sp(_t122, "nextRaid", _t125)
	if J.cmp(_s61["now"], J.gp(_s61["m"], "nextRaid"), ">="):
		var _t126 = _s61["m"]
		var _t128 = _s61["now"]
		var _t127 = _s61["__p"]["R"]
		var _t129 = J.add(_t128, J.div(J.mul(J.cl(_t127, null, [J.gp(_s61["__p"]["TUNE"], "raidMin"), J.gp(_s61["__p"]["TUNE"], "raidMax")]), 60000.0), (1.0 + J.mul(v_heldN_198, 0.3))))
		J.sp(_t126, "nextRaid", _t129)
		var _t130 = J.gp(_s61["m"], "enemy")
		var _t132 = J.mc(_t130, "map", [Callable(self, "_f41").bind(_s61)])
		v_empty_200 = J.mc(_t132, "filter", [Callable(self, "_f42").bind(_s61)])
		var _t133 = J.gp(_s61["m"], "enemy")
		var _t135 = J.mc(_t133, "map", [Callable(self, "_f43").bind(_s61)])
		v_mine_201 = J.mc(_t135, "filter", [Callable(self, "_f44").bind(_s61)])
		v_front_202 = Callable(self, "_f45").bind(_s61)
		var _t138 = null
		if J.t(J.len(v_empty_200)):
			_t138 = J.cl(v_front_202, null, [v_empty_200])
		else:
			var _t137 = null
			if J.t(J.len(v_mine_201)):
				var _t136 = _s61["__p"]["pick"]
				_t137 = J.cl(_t136, null, [v_mine_201])
			else:
				_t137 = (-1.0)
			_t138 = _t137
		v_i_203 = _t138
		if J.cmp(v_i_203, 0.0, ">="):
			var _t139 = J.gp(_s61["m"], "enemy")
			var _t140 = _s61["__p"]["pick"]
			var _t141 = {"k": J.cl(_t140, null, [_s61["__p"]["RIVALS"]]), "hp": 100.0, "at": _s61["now"]}
			J.sp(_t139, v_i_203, _t141)
			var _t142 = _s61["__p"]["log"]
			J.cl(_t142, null, [("夜冷村派了" + J.str(J.gp(_s61["__p"]["RNAME"], J.gp(J.gp(J.gp(_s61["m"], "enemy"), v_i_203), "k"))) + "到<b>" + J.str(J.gp(_s61["def"], "short")) + "・" + J.str(J.gp(J.gp(J.gp(_s61["def"], "posts"), v_i_203), "name")) + "</b>" + ("，正在騷擾我方的鬼" if (not J.leq(J.gp(J.gp(_s61["m"], "posts"), v_i_203), null)) else ""))])
	if (not J.t(J.gp(_s61["m"], "nextBryan"))):
		var _t143 = _s61["m"]
		var _t146 = _s61["now"]
		var _t145 = J.mul(J.gp(_s61["__p"]["TUNE"], "bryanH"), 3600000.0)
		var _t144 = _s61["__p"]["R"]
		var _t147 = J.add(_t146, J.mul(_t145, J.cl(_t144, null, [0.6, 1.2])))
		J.sp(_t143, "nextBryan", _t147)
	var _t149 = J.cmp(_s61["now"], J.gp(_s61["m"], "nextBryan"), ">=")
	if J.t(_t149):
		var _t148 = _s61["__p"]["status"]
		_t149 = (not J.seq(J.gp(J.cl(_t148, null, [_s61["m"]]), "k"), "new"))
	if _t149:
		var _t150 = _s61["m"]
		var _t153 = _s61["now"]
		var _t152 = J.mul(J.gp(_s61["__p"]["TUNE"], "bryanH"), 3600000.0)
		var _t151 = _s61["__p"]["R"]
		var _t154 = J.add(_t153, J.mul(_t152, J.cl(_t151, null, [0.8, 1.3])))
		J.sp(_t150, "nextBryan", _t154)
		var _t155 = J.gp(_s61["m"], "enemy")
		var _t156 = J.mc(_t155, "map", [Callable(self, "_f47").bind(_s61)])
		v_free_213 = J.mc(_t156, "filter", [Callable(self, "_f48").bind(_s61)])
		v_i_214 = (J.gp(v_free_213, 0.0) if J.t(J.len(v_free_213)) else 0.0)
		var _t157 = J.gp(_s61["m"], "enemy")
		var _t158 = {"k": "bryan", "hp": 220.0, "at": _s61["now"]}
		J.sp(_t157, v_i_214, _t158)
		var _t159 = _s61["__p"]["log"]
		var _t162 = J.gp(_s61["def"], "short")
		var _t163 = J.gp(J.gp(J.gp(_s61["def"], "posts"), v_i_214), "name")
		var _t160 = _s61["__p"]["L"]
		var _t161 = _s61["__p"]["pick"]
		J.cl(_t159, null, [("<b>Bryan 親自站崗</b>：" + J.str(_t162) + "・" + J.str(_t163) + "。" + J.str(J.cl(_t160, null, [J.cl(_t161, null, [_s61["__p"]["BRYAN_LINES"]])])))])
	var _t164 = J.gp(_s61["m"], "enemy")
	J.mc(_t164, "forEach", [Callable(self, "_f49").bind(_s61)])
	var _t174 = J.gp(_s61["m"], "posts")
	J.mc(_t174, "forEach", [Callable(self, "_f50").bind(_s61)])

func _f51(this_, a: Array, env):
	var v_html_227 = null; var v_s_228 = null; var v_e_229 = null
	v_html_227 = J.arg(a, 0)
	v_s_228 = J.cl(env["st"], null, [])
	var _t178 = J.gp(v_s_228, "log")
	J.mc(_t178, "unshift", [{"t": J.S_Date_("now", []), "h": v_html_227}])
	if (J.len(J.gp(v_s_228, "log")) > 30.0):
		var _t179 = J.gp(v_s_228, "log")
		J.sp(_t179, "length", 30.0)
	var _t180 = env["has"]
	var _t181 = J.cl(_t180, null, [J.G.get("Fx")])
	var _t182 = ((not J.t(J.gp(env["Live"], "on"))) if J.t(_t181) else _t181)
	if J.t(((not J.t(J.gp(env["Live"], "_quiet"))) if J.t(_t182) else _t182)):
		J.mc(J.G.get("Fx"), "toast", [v_html_227])

func _f52(this_, a: Array, env):
	var v_def_232 = null; var v_m_233 = null; var v_s_234 = null; var v_ok_235 = null
	v_def_232 = J.arg(a, 0)
	v_m_233 = J.arg(a, 1)
	var _t183 = env["share"]
	v_s_234 = J.cl(_t183, null, [v_m_233])
	var _t184 = J.cmp(J.gp(v_m_233, "habit"), 10.0, ">=")
	var _t185 = (J.cmp(J.gp(v_s_234, "n"), 50.0, ">=") if _t184 else _t184)
	v_ok_235 = (J.cmp(J.gp(v_s_234, "me"), J.gp(env["TUNE"], "stableRatio"), ">=") if _t185 else _t185)
	if J.t(v_ok_235):
		if (not J.t(J.gp(v_m_233, "stableAt"))):
			var _t186 = J.S_Date_("now", [])
			J.sp(v_m_233, "stableAt", _t186)
		var _t187 = (not J.t(J.gp(v_m_233, "stable")))
		if ((J.sub(J.S_Date_("now", []), J.gp(v_m_233, "stableAt")) >= J.mul(J.gp(env["TUNE"], "stableHours"), 3600000.0)) if _t187 else _t187):
			J.sp(v_m_233, "stable", true)
			var _t188 = env["log"]
			J.cl(_t188, null, [("<b>" + J.str(J.gp(v_def_232, "name")) + "</b> 地盤穩定了！見慣度封頂也頂得住，之後固定產出，離線照算。")])
	else:
		J.sp(v_m_233, "stableAt", 0.0)
		var _t189 = J.gp(v_m_233, "stable")
		if J.t((J.cmp(J.gp(v_s_234, "me"), J.gp(env["TUNE"], "failRatio"), "<") if J.t(_t189) else _t189)):
			J.sp(v_m_233, "stable", false)
			var _t190 = env["log"]
			J.cl(_t190, null, [("<b>" + J.str(J.gp(v_def_232, "name")) + "</b> 撐不住，不再穩定。")])

func _f54(this_, a: Array, env):
	var v_gid_240 = null; var v_g_241 = null
	v_gid_240 = J.arg(a, 0)
	var _t198 = (not J.leq(v_gid_240, null))
	if J.t(_t198):
		var _t197 = env["ghost"]
		_t198 = J.cl(_t197, null, [v_gid_240])
	v_g_241 = _t198
	if J.t(v_g_241):
		J.mc(J.G.get("Presence"), "add", [v_g_241, 1.5])

func _f53(this_, a: Array, env):
	var v_def_238 = null; var v_m_239 = null
	v_def_238 = J.arg(a, 0)
	v_m_239 = J.arg(a, 1)
	while true:
		if not J.cmp(J.gp(v_m_239, "bank"), 40.0, ">="): break
		var _t191 = J.sub(J.gp(v_m_239, "bank"), 40.0)
		J.sp(v_m_239, "bank", _t191)
		var _t192 = J.gp(J.G.get("S"), "contract")
		if J.t((J.seq(J.gp(J.gp(J.G.get("S"), "contract"), "state"), "active") if J.t(_t192) else _t192)):
			var _t193 = J.gp(J.G.get("S"), "contract")
			var _t194 = J.add(J.gp(_t193, "kpi"), 1.0)
			J.sp(_t193, "kpi", _t194)
		var _t195 = env["has"]
		if J.t(J.cl(_t195, null, [J.G.get("Presence")])):
			var _t196 = J.gp(v_m_239, "posts")
			J.mc(_t196, "forEach", [Callable(self, "_f54").bind(env)])
		var _t199 = J.cl(env["st"], null, [])
		var _t200 = J.gp(J.cl(env["st"], null, []), "earned")
		var _t201 = J.add((_t200 if J.t(_t200) else 0.0), 1.0)
		J.sp(_t199, "earned", _t201)

func _f55(this_, a: Array, env):
	var v_def_244 = null; var v_m_245 = null; var v_gid_246 = null; var v_lv_247 = null; var v_g_248 = null; var v_e_249 = null
	v_def_244 = J.arg(a, 0)
	v_m_245 = J.arg(a, 1)
	var _t202 = J.gp(v_m_245, "legSeen")
	var _t203 = (_t202 if J.t(_t202) else {})
	J.sp(v_m_245, "legSeen", _t203)
	for _t204 in J.keys(J.gp(v_m_245, "leg")):
		v_gid_246 = _t204
		var _t205 = env["legLv"]
		v_lv_247 = J.cl(_t205, null, [v_m_245, v_gid_246])
		var _t206 = J.gp(J.gp(v_m_245, "legSeen"), v_gid_246)
		if J.cmp(v_lv_247, (_t206 if J.t(_t206) else 0.0), ">"):
			var _t207 = J.gp(v_m_245, "legSeen")
			J.sp(_t207, v_gid_246, v_lv_247)
			var _t208 = env["ghost"]
			var _t210 = J.cl(_t208, null, [J.num(v_gid_246)])
			if not J.t(_t210):
				var _t209 = env["ghost"]
				_t210 = J.cl(_t209, null, [v_gid_246])
			v_g_248 = _t210
			if J.t(v_g_248):
				var _t211 = env["log"]
				var _t213 = J.gp(v_g_248, "name")
				var _t214 = J.gp(v_def_244, "short")
				var _t215 = J.gp(env["LEG_T"], v_lv_247)
				var _t212 = env["legendName"]
				J.cl(_t211, null, [("<b>" + J.str(_t213) + "</b> 在" + J.str(_t214) + "的怪談升級為「" + J.str(_t215) + "」：" + J.str(J.cl(_t212, null, [J.gp(v_g_248, "k"), v_g_248])))])
				var _t217 = J.seq(v_lv_247, 2.0)
				if J.t(_t217):
					var _t216 = env["has"]
					_t217 = J.cl(_t216, null, [J.G.get("Story")])
				if J.t(_t217):
					var _t218 = J.gp(v_m_245, "skit")
					var _t219 = (_t218 if J.t(_t218) else {})
					J.sp(v_m_245, "skit", _t219)
					if (not J.t(J.gp(J.gp(v_m_245, "skit"), J.gp(v_g_248, "k")))):
						var _t220 = J.gp(v_m_245, "skit")
						var _t221 = J.gp(v_g_248, "k")
						J.sp(_t220, _t221, 1.0)
						var _t222 = env["skitFor"]
						J.mc(J.G.get("Story"), "queue", [J.cl(_t222, null, [v_g_248, v_def_244])])

func _f57(this_, a: Array, env):
	var v_gid_254 = null; var v_i_255 = null; var v_g_256 = null
	v_gid_254 = J.arg(a, 0)
	v_i_255 = J.arg(a, 1)
	if J.leq(v_gid_254, null):
		return null
	var _t226 = env["__p"]["ghost"]
	v_g_256 = J.cl(_t226, null, [v_gid_254])
	var _t227 = (not J.t(v_g_256))
	if (_t227 if _t227 else (not J.seq(J.gp(v_g_256, "post"), "station"))):
		var _t228 = J.gp(env["m"], "posts")
		J.sp(_t228, v_i_255, null)

func _f56(this_, a: Array, env):
	var v_d_252 = null
	for _t223 in J.iter(env["MAPS"]):
		v_d_252 = _t223
		var _s102 = {"__p": env, "m": null}
		var _t224 = _s102["__p"]["ms"]
		_s102["m"] = J.cl(_t224, null, [J.gp(v_d_252, "id")])
		var _t225 = J.gp(_s102["m"], "posts")
		J.mc(_t225, "forEach", [Callable(self, "_f57").bind(_s102)])

func _f59(this_, a: Array, env):
	var v_x_267 = null
	v_x_267 = J.arg(a, 0)
	return (not J.leq(v_x_267, null))

func _f60(this_, a: Array, env):
	var v_x_269 = null
	v_x_269 = J.arg(a, 0)
	return J.cmp(J.gp(v_x_269, "t"), J.gp(env["rep"], "log0"), ">")

func _f61(this_, a: Array, env):
	var v_x_270 = null
	v_x_270 = J.arg(a, 0)
	return J.gp(v_x_270, "h")

func _f58(this_, a: Array, env):
	var v_s_259 = null; var v_now_260 = null; var v_dt_261 = null; var v_def_263 = null; var v_m_264 = null; var v_mine_265 = null; var v_anyone_266 = null; var v_P_268 = null
	var _s104 = {"__p": env, "rep": null}
	var _t229 = _s104["__p"]["has"]
	var _t230 = (not J.t(J.cl(_t229, null, [J.G.get("S")])))
	if (_t230 if _t230 else (not J.t(J.gp(J.G.get("S"), "ghosts")))):
		return null
	v_s_259 = J.cl(_s104["__p"]["st"], null, [])
	v_now_260 = J.S_Date_("now", [])
	J.cl(_s104["__p"]["validate"], null, [])
	var _t232 = J.mul(J.gp(_s104["__p"]["TUNE"], "offlineCap"), 3600.0)
	var _t231 = J.gp(v_s_259, "t")
	var _t234 = J.mul(J.gp(_s104["__p"]["TUNE"], "offlineCap"), 3600.0)
	var _t233 = J.gp(v_s_259, "t")
	var _t236 = J.mul(J.gp(_s104["__p"]["TUNE"], "offlineCap"), 3600.0)
	var _t235 = J.gp(v_s_259, "t")
	var _t238 = J.mul(J.gp(_s104["__p"]["TUNE"], "offlineCap"), 3600.0)
	var _t237 = J.gp(v_s_259, "t")
	v_dt_261 = J.max_([0.0, J.min_([_t238, J.div(J.sub(v_now_260, (_t237 if J.t(_t237) else v_now_260)), 1000.0)])])
	J.sp(v_s_259, "t", v_now_260)
	var _t241 = null
	if J.cmp(v_dt_261, 600.0, ">"):
		var _t240 = J.round(J.num(J.div(v_dt_261, 60.0)))
		var _t239 = J.gp(v_s_259, "earned")
		_t241 = {"mins": _t240, "n": 0.0, "me": 0.0, "en": 0.0, "kpi0": (_t239 if J.t(_t239) else 0.0), "log0": (J.gp(J.gp(J.gp(v_s_259, "log"), 0.0), "t") if J.t(J.len(J.gp(v_s_259, "log"))) else 0.0)}
	else:
		_t241 = null
	_s104["rep"] = _t241
	if J.t(_s104["rep"]):
		var _t242 = _s104["__p"]["Live"]
		J.sp(_t242, "_quiet", true)
	for _t243 in J.iter(_s104["__p"]["MAPS"]):
		v_def_263 = _t243
		var _t244 = _s104["__p"]["open"]
		if (not J.t(J.cl(_t244, null, [v_def_263]))):
			continue
		var _t245 = _s104["__p"]["ms"]
		v_m_264 = J.cl(_t245, null, [J.gp(v_def_263, "id")])
		var _t246 = J.gp(v_m_264, "posts")
		v_mine_265 = J.mc(_t246, "some", [Callable(self, "_f59").bind(_s104)])
		var _t248 = v_mine_265
		if not J.t(_t248):
			var _t247 = J.gp(v_m_264, "enemy")
			_t248 = J.mc(_t247, "some", [J.G.get("Boolean")])
		v_anyone_266 = _t248
		var _t250 = v_anyone_266
		if J.t(_t250):
			var _t249 = J.gp(_s104["__p"]["Live"], "on")
			_t250 = (not J.t((J.seq(J.gp(_s104["__p"]["Live"], "def"), v_def_263) if J.t(_t249) else _t249)))
		if J.t(_t250):
			var _t251 = J.gp(v_m_264, "acc")
			var _t252 = J.add((_t251 if J.t(_t251) else 0.0), v_dt_261)
			J.sp(v_m_264, "acc", _t252)
			while true:
				if not J.cmp(J.gp(v_m_264, "acc"), J.gp(_s104["__p"]["TUNE"], "every"), ">="): break
				var _t253 = J.sub(J.gp(v_m_264, "acc"), J.gp(_s104["__p"]["TUNE"], "every"))
				J.sp(v_m_264, "acc", _t253)
				var _t254 = _s104["__p"]["simOne"]
				v_P_268 = J.cl(_t254, null, [v_def_263, v_m_264])
				if J.t(_s104["rep"]):
					var _t255 = _s104["rep"]
					J.sp(_t255, "n", J.num(J.gp(_t255, "n")) + 1.0)
					if J.seq(J.gp(v_P_268, "by"), 1.0):
						var _t256 = _s104["rep"]
						J.sp(_t256, "me", J.num(J.gp(_t256, "me")) + 1.0)
					else:
						if J.seq(J.gp(v_P_268, "by"), 2.0):
							var _t257 = _s104["rep"]
							J.sp(_t257, "en", J.num(J.gp(_t257, "en")) + 1.0)
		var _t259 = v_mine_265
		if not J.t(_t259):
			var _t258 = J.gp(v_m_264, "enemy")
			_t259 = J.mc(_t258, "some", [J.G.get("Boolean")])
		if J.t(_t259):
			var _t260 = _s104["__p"]["rivalStep"]
			J.cl(_t260, null, [v_def_263, v_m_264, J.div(v_dt_261, 60.0)])
		var _t261 = _s104["__p"]["stableStep"]
		J.cl(_t261, null, [v_def_263, v_m_264])
		var _t262 = _s104["__p"]["payStep"]
		J.cl(_t262, null, [v_def_263, v_m_264])
		var _t263 = _s104["__p"]["legendStep"]
		J.cl(_t263, null, [v_def_263, v_m_264])
	if J.t(_s104["rep"]):
		var _t264 = _s104["__p"]["Live"]
		J.sp(_t264, "_quiet", false)
		if J.t(J.gp(_s104["rep"], "n")):
			var _t265 = _s104["rep"]
			var _t266 = J.gp(v_s_259, "earned")
			var _t267 = J.sub((_t266 if J.t(_t266) else 0.0), J.gp(_s104["rep"], "kpi0"))
			J.sp(_t265, "kpi", _t267)
			var _t268 = _s104["rep"]
			var _t269 = J.gp(v_s_259, "log")
			var _t270 = J.mc(_t269, "filter", [Callable(self, "_f60").bind(_s104)])
			var _t271 = J.mc(_t270, "slice", [0.0, 6.0])
			var _t272 = J.mc(_t271, "map", [Callable(self, "_f61").bind(_s104)])
			J.sp(_t268, "events", _t272)
			var _t273 = _s104["rep"]
			J.sp(v_s_259, "report", _t273)

func _f63(this_, a: Array, env):
	var v_x_283 = null; var v_i_284 = null
	v_x_283 = J.arg(a, 0)
	v_i_284 = J.arg(a, 1)
	if J.seq(v_x_283, env["__p"]["gid"]):
		var _t282 = J.gp(env["mm"], "posts")
		J.sp(_t282, v_i_284, null)

func _f62(this_, a: Array, env):
	var v_mapId_273 = null; var v_pi_274 = null; var v_def_276 = null; var v_m_277 = null; var v_old_278 = null; var v_g_279 = null; var v_og_280 = null; var v_d_281 = null
	var _s115 = {"__p": env, "gid": null}
	v_mapId_273 = J.arg(a, 0)
	v_pi_274 = J.arg(a, 1)
	_s115["gid"] = J.arg(a, 2)
	var _t274 = _s115["__p"]["mapOf"]
	v_def_276 = J.cl(_t274, null, [v_mapId_273])
	var _t275 = _s115["__p"]["ms"]
	v_m_277 = J.cl(_t275, null, [v_mapId_273])
	v_old_278 = J.gp(J.gp(v_m_277, "posts"), v_pi_274)
	if (not J.leq(v_old_278, null)):
		var _t276 = _s115["__p"]["ghost"]
		v_og_280 = J.cl(_t276, null, [v_old_278])
		if J.t((J.seq(J.gp(v_og_280, "post"), "station") if J.t(v_og_280) else v_og_280)):
			J.sp(v_og_280, "post", null)
	if J.leq(_s115["gid"], null):
		var _t277 = J.gp(v_m_277, "posts")
		J.sp(_t277, v_pi_274, null)
		return null
	var _t278 = _s115["__p"]["ghost"]
	v_g_279 = J.cl(_t278, null, [_s115["gid"]])
	if (not J.t(v_g_279)):
		return null
	for _t279 in J.iter(_s115["__p"]["MAPS"]):
		v_d_281 = _t279
		var _s119 = {"__p": _s115, "mm": null}
		var _t280 = _s119["__p"]["__p"]["ms"]
		_s119["mm"] = J.cl(_t280, null, [J.gp(v_d_281, "id")])
		var _t281 = J.gp(_s119["mm"], "posts")
		J.mc(_t281, "forEach", [Callable(self, "_f63").bind(_s119)])
	J.sp(v_g_279, "post", "station")
	var _t283 = J.gp(v_m_277, "posts")
	var _t284 = _s115["gid"]
	J.sp(_t283, v_pi_274, _t284)
	if J.leq(J.gp(J.gp(v_m_277, "morale"), _s115["gid"]), null):
		var _t285 = J.gp(v_m_277, "morale")
		var _t286 = _s115["gid"]
		var _t287 = J.gp(_s115["__p"]["TUNE"], "morale")
		J.sp(_t285, _t286, _t287)
	var _t288 = J.gp(J.gp(v_m_277, "enemy"), v_pi_274)
	if J.t(((not J.seq(J.gp(J.gp(J.gp(v_m_277, "enemy"), v_pi_274), "k"), "bryan")) if J.t(_t288) else _t288)):
		pass

func _f65(this_, a: Array, env):
	var v_g_288 = null
	v_g_288 = J.arg(a, 0)
	var _t290 = (not J.seq(J.gp(v_g_288, "k"), "afu"))
	var _t291 = ((not J.t(J.gp(v_g_288, "post"))) if _t290 else _t290)
	return ((not J.cmp(J.gp(v_g_288, "tiredUntil"), env["now"], ">")) if _t291 else _t291)

func _f64(this_, a: Array, env):
	var _s122 = {"__p": env, "now": null}
	_s122["now"] = J.S_Date_("now", [])
	var _t289 = J.gp(J.G.get("S"), "ghosts")
	return J.mc(_t289, "filter", [Callable(self, "_f65").bind(_s122)])

func _f67(this_, a: Array, env):
	var v_x_306 = null; var v_i_307 = null
	v_x_306 = J.arg(a, 0)
	v_i_307 = J.arg(a, 1)
	return (v_i_307 if (not J.leq(v_x_306, null)) else (-1.0))

func _f68(this_, a: Array, env):
	var v_i_308 = null
	v_i_308 = J.arg(a, 0)
	return J.cmp(v_i_308, 0.0, ">=")

func _f69(this_, a: Array, env):
	var v_a_309 = null; var v_b_310 = null
	v_a_309 = J.arg(a, 0)
	v_b_310 = J.arg(a, 1)
	return (absf(J.num(J.sub(v_a_309, env["pi"]))) - absf(J.num(J.sub(v_b_310, env["pi"]))))

func _f66(this_, a: Array, env):
	var v_mapId_291 = null; var v_def_293 = null; var v_m_294 = null; var v_e_295 = null; var v_now_296 = null; var v_gi_297 = null; var v_g_298 = null; var v_type_299 = null; var v_f_300 = null; var v_mul_301 = null; var v_tag_302 = null; var v_dmg_303 = null; var v_gone_304 = null; var v_near_305 = null
	var _s124 = {"__p": env, "pi": null}
	v_mapId_291 = J.arg(a, 0)
	_s124["pi"] = J.arg(a, 1)
	var _t292 = _s124["__p"]["mapOf"]
	v_def_293 = J.cl(_t292, null, [v_mapId_291])
	var _t293 = _s124["__p"]["ms"]
	v_m_294 = J.cl(_t293, null, [v_mapId_291])
	v_e_295 = J.gp(J.gp(v_m_294, "enemy"), _s124["pi"])
	if (not J.t(v_e_295)):
		return null
	v_now_296 = J.S_Date_("now", [])
	var _t294 = J.gp(v_m_294, "hitCd")
	if J.cmp((_t294 if J.t(_t294) else 0.0), v_now_296, ">"):
		return {"msg": "喘口氣……", "cd": true}
	var _t295 = J.add(v_now_296, 1400.0)
	J.sp(v_m_294, "hitCd", _t295)
	v_gi_297 = J.gp(J.gp(v_m_294, "posts"), _s124["pi"])
	if J.leq(v_gi_297, null):
		var _t296 = J.gp(v_m_294, "posts")
		var _t297 = J.mc(_t296, "map", [Callable(self, "_f67").bind(_s124)])
		var _t298 = J.mc(_t297, "filter", [Callable(self, "_f68").bind(_s124)])
		v_near_305 = J.mc(_t298, "sort", [Callable(self, "_f69").bind(_s124)])
		var _t299 = (J.gp(J.gp(v_m_294, "posts"), J.gp(v_near_305, 0.0)) if J.t(J.len(v_near_305)) else null)
		v_gi_297 = _t299
	var _t301 = null
	if (not J.leq(v_gi_297, null)):
		var _t300 = _s124["__p"]["ghost"]
		_t301 = J.cl(_t300, null, [v_gi_297])
	else:
		_t301 = null
	v_g_298 = _t301
	if (not J.t(v_g_298)):
		return {"msg": "這張地圖沒有我方的鬼可以出手"}
	var _t302 = _s124["__p"]["typesOf"]
	v_type_299 = J.gp(J.cl(_t302, null, [J.gp(v_g_298, "k")]), 0.0)
	var _t304 = null
	if J.seq(J.gp(v_e_295, "k"), "bryan"):
		_t304 = {"w": ["light", "face"], "i": ["sound"]}
	else:
		var _t303 = _s124["__p"]["has"]
		_t304 = (J.mc(J.G.get("Rework"), "fearOf", [J.gp(v_e_295, "k")]) if J.t(J.cl(_t303, null, [J.G.get("Rework")])) else {"w": [], "i": []})
	v_f_300 = _t304
	var _t305 = J.gp(v_f_300, "w")
	var _t307 = null
	if J.t(J.mc(_t305, "includes", [v_type_299])):
		_t307 = 1.6
	else:
		var _t306 = J.gp(v_f_300, "i")
		_t307 = (0.4 if J.t(J.mc(_t306, "includes", [v_type_299])) else 1.0)
	v_mul_301 = _t307
	var _t308 = J.gp(v_f_300, "w")
	var _t310 = null
	if J.t(J.mc(_t308, "includes", [v_type_299])):
		_t310 = "怕"
	else:
		var _t309 = J.gp(v_f_300, "i")
		_t310 = ("不怕" if J.t(J.mc(_t309, "includes", [v_type_299])) else "")
	v_tag_302 = _t310
	var _t311 = _s124["__p"]["power"]
	var _t313 = J.mul(J.mul(J.cl(_t311, null, [v_g_298]), 0.55), v_mul_301)
	var _t312 = _s124["__p"]["R"]
	v_dmg_303 = J.round(J.num(J.mul(_t313, J.cl(_t312, null, [0.85, 1.15]))))
	var _t314 = J.sub(J.gp(v_e_295, "hp"), v_dmg_303)
	J.sp(v_e_295, "hp", _t314)
	v_gone_304 = false
	if J.cmp(J.gp(v_e_295, "hp"), 0.0, "<="):
		v_gone_304 = true
		var _t315 = J.gp(v_m_294, "enemy")
		var _t316 = _s124["pi"]
		J.sp(_t315, _t316, null)
		var _t317 = _s124["__p"]["log"]
		J.cl(_t317, null, [("把" + J.str(J.gp(_s124["__p"]["RNAME"], J.gp(v_e_295, "k"))) + "從" + J.str(J.gp(v_def_293, "short")) + "・" + J.str(J.gp(J.gp(J.gp(v_def_293, "posts"), _s124["pi"]), "name")) + "趕走了！")])
		var _t318 = J.seq(J.gp(v_e_295, "k"), "bryan")
		var _t319 = (J.gp(J.G.get("S"), "contract") if _t318 else _t318)
		if J.t((J.seq(J.gp(J.gp(J.G.get("S"), "contract"), "state"), "active") if J.t(_t319) else _t319)):
			var _t320 = J.gp(J.G.get("S"), "contract")
			var _t321 = J.add(J.gp(_t320, "kpi"), 3.0)
			J.sp(_t320, "kpi", _t321)
	return {"dmg": v_dmg_303, "tag": v_tag_302, "gone": v_gone_304, "g": v_g_298, "type": v_type_299}

func _f70(this_, a: Array, env):
	var v_mapId_313 = null; var v_pi_314 = null; var v_m_315 = null; var v_now_316 = null
	v_mapId_313 = J.arg(a, 0)
	v_pi_314 = J.arg(a, 1)
	var _t322 = env["ms"]
	v_m_315 = J.cl(_t322, null, [v_mapId_313])
	v_now_316 = J.S_Date_("now", [])
	var _t323 = J.gp(J.gp(v_m_315, "cd"), v_pi_314)
	if J.cmp((_t323 if J.t(_t323) else 0.0), v_now_316, ">"):
		return ceil(J.num(J.div(J.sub(J.gp(J.gp(v_m_315, "cd"), v_pi_314), v_now_316), 1000.0)))
	var _t324 = J.gp(v_m_315, "boost")
	J.sp(_t324, v_pi_314, 1.0)
	var _t325 = J.gp(v_m_315, "cd")
	var _t326 = J.add(v_now_316, 20000.0)
	J.sp(_t325, v_pi_314, _t326)
	return 0.0

func _f74(this_, a: Array, env):
	var v_t_333 = null
	v_t_333 = J.arg(a, 0)
	return J.gp(env["__p"]["W"], v_t_333)

func _f73(this_, a: Array, env):
	var v_p_327 = null; var v_i_328 = null; var v_g_329 = null; var v_e_330 = null; var v_mor_331 = null; var v_lv_332 = null
	v_p_327 = J.arg(a, 0)
	v_i_328 = J.arg(a, 1)
	var _t349 = null
	if (not J.leq(J.gp(J.gp(env["m"], "posts"), v_i_328), null)):
		var _t348 = env["__p"]["ghost"]
		_t349 = J.cl(_t348, null, [J.gp(J.gp(env["m"], "posts"), v_i_328)])
	else:
		_t349 = null
	v_g_329 = _t349
	v_e_330 = J.gp(J.gp(env["m"], "enemy"), v_i_328)
	v_mor_331 = (J.round(J.num((100.0 if J.leq(J.gp(J.gp(env["m"], "morale"), J.gp(v_g_329, "id")), null) else J.gp(J.gp(env["m"], "morale"), J.gp(v_g_329, "id"))))) if J.t(v_g_329) else 0.0)
	var _t351 = null
	if J.t(v_g_329):
		var _t350 = env["__p"]["legLv"]
		_t351 = J.cl(_t350, null, [env["m"], J.gp(v_g_329, "id")])
	else:
		_t351 = 0.0
	v_lv_332 = _t351
	var _t352 = J.add(env["h"], ("<div class=\"stn-post " + ("raid" if J.t(v_e_330) else "") + "\"><div class=\"stn-pn\">" + J.str(J.add(v_i_328, 1.0)) + ". " + J.str(J.gp(v_p_327, "name")) + "<small>適合：" + J.str(J.gp(env["__p"]["W"], J.gp(v_p_327, "fit"))) + "</small></div>"))
	env["h"] = _t352
	var _t358 = null
	if J.t(v_g_329):
		var _t356 = J.gp(v_g_329, "k")
		var _t357 = J.gp(v_g_329, "name")
		var _t353 = env["__p"]["typesOf"]
		var _t354 = J.cl(_t353, null, [J.gp(v_g_329, "k")])
		var _t355 = J.mc(_t354, "map", [Callable(self, "_f74").bind(env)])
		_t358 = ("<div class=\"stn-g\"><canvas data-por=\"" + J.str(_t356) + "\"></canvas><span><b>" + J.str(_t357) + "</b><small>" + J.str(J.mc(_t355, "join", ["／"])) + "　氣勢 " + J.str(v_mor_331) + (("　<i class=\"stn-leg\">" + J.str(J.gp(env["__p"]["LEG_T"], v_lv_332)) + "</i>") if J.t(v_lv_332) else "") + "</small></span></div>")
	else:
		_t358 = ("<div class=\"stn-g empty\">空崗</div>")
	var _t359 = J.add(env["h"], _t358)
	env["h"] = _t359
	if J.t(v_e_330):
		var _t362 = J.gp(env["__p"]["RNAME"], J.gp(v_e_330, "k"))
		var _t361 = env["__p"]["W"]
		var _t360 = env["__p"]["rivalType"]
		var _t363 = J.add(env["h"], ("<div class=\"stn-en\">⚑ " + J.str(_t362) + "（" + J.str(J.gp(_t361, J.cl(_t360, null, [J.gp(v_e_330, "k")]))) + "）" + ("騷擾中" if J.t(v_g_329) else "佔了這個崗位") + "</div>"))
		env["h"] = _t363
	var _t364 = J.add(env["h"], ("<div class=\"stn-btns\"><button class=\"btn sm\" data-st-as=\"" + J.str(J.gp(env["def"], "id")) + ":" + J.str(v_i_328) + "\">" + ("換鬼" if J.t(v_g_329) else "派鬼") + "</button>" + (("<button class=\"btn sm ghost\" data-st-un=\"" + J.str(J.gp(env["def"], "id")) + ":" + J.str(v_i_328) + "\">撤回</button>") if J.t(v_g_329) else "") + (("<button class=\"btn sm red\" data-st-hit=\"" + J.str(J.gp(env["def"], "id")) + ":" + J.str(v_i_328) + "\">出手驅趕</button>") if J.t(v_e_330) else "") + "</div></div>"))
	env["h"] = _t364

func _f72(this_, a: Array, env):
	var v_s_322 = null; var v_sta_323 = null; var v_stbl_324 = null; var v_stProg_325 = null
	var _s132 = {"__p": env, "def": null, "m": null, "h": null}
	_s132["def"] = J.arg(a, 0)
	var _t327 = _s132["__p"]["open"]
	if (not J.t(J.cl(_t327, null, [_s132["def"]]))):
		return ("<div class=\"stn-card soon\"><div class=\"stn-h\"><b>" + J.str(J.gp(_s132["def"], "name")) + "</b><em>" + ("即將開放" if J.t(J.gp(_s132["def"], "soon")) else "未解鎖") + "</em></div><small>" + J.str(J.gp(_s132["def"], "desc")) + "</small></div>")
	var _t328 = _s132["__p"]["ms"]
	_s132["m"] = J.cl(_t328, null, [J.gp(_s132["def"], "id")])
	var _t329 = _s132["__p"]["share"]
	v_s_322 = J.cl(_t329, null, [_s132["m"]])
	var _t330 = _s132["__p"]["status"]
	v_sta_323 = J.cl(_t330, null, [_s132["m"]])
	v_stbl_324 = ("<em class=\"stn-stable\">地盤穩定</em>" if J.t(J.gp(_s132["m"], "stable")) else "")
	var _t334 = null
	if J.t(J.gp(_s132["m"], "stable")):
		_t334 = ""
	else:
		var _t333 = null
		if J.t(J.gp(_s132["m"], "stableAt")):
			_t333 = ("穩定倒數 " + J.str(J.max_([0.0, ceil(J.num(J.div((J.mul(J.gp(_s132["__p"]["TUNE"], "stableHours"), 3600000.0) - J.sub(J.S_Date_("now", []), J.gp(_s132["m"], "stableAt"))), 3600000.0)))])) + " 小時")
		else:
			var _t332 = null
			if J.cmp(J.gp(_s132["m"], "habit"), 10.0, ">="):
				var _t331 = _s132["__p"]["pct"]
				_t332 = ("嚇破膽要 ≥" + J.str(J.cl(_t331, null, [J.gp(_s132["__p"]["TUNE"], "stableRatio")])) + " 才開始計穩定")
			else:
				_t332 = ("見慣度到 10 才能穩定")
			_t333 = _t332
		_t334 = _t333
	v_stProg_325 = _t334
	_s132["h"] = ("<div class=\"stn-card\"><div class=\"stn-h\"><b>" + J.str(J.gp(_s132["def"], "name")) + "</b><em class=\"stn-" + J.str(J.gp(v_sta_323, "k")) + "\">" + J.str(J.gp(v_sta_323, "t")) + "</em>" + J.str(v_stbl_324) + "</div>")
	var _t335 = _s132["__p"]["pct"]
	var _t337 = J.cl(_t335, null, [J.gp(v_s_322, "me")])
	var _t336 = _s132["__p"]["pct"]
	var _t339 = J.cl(_t336, null, [J.gp(v_s_322, "en")])
	var _t338 = _s132["__p"]["pct"]
	var _t341 = J.cl(_t338, null, [J.gp(v_s_322, "me")])
	var _t340 = _s132["__p"]["pct"]
	var _t343 = J.cl(_t340, null, [J.gp(v_s_322, "en")])
	var _t342 = _s132["__p"]["pct"]
	var _t344 = J.add(_s132["h"], ("<div class=\"stn-bar\"><i class=\"me\" style=\"width:" + J.str(_t337) + "\"></i><i class=\"en\" style=\"width:" + J.str(_t339) + "\"></i></div><small class=\"stn-sub\">我方 " + J.str(_t341) + "　夜冷村 " + J.str(_t343) + "　沒嚇到 " + J.str(J.cl(_t342, null, [J.max_([0.0, J.sub(J.sub(1.0, J.gp(v_s_322, "me")), J.gp(v_s_322, "en"))])])) + "（最近 " + J.str(J.gp(v_s_322, "n")) + " 個路人）</small>"))
	_s132["h"] = _t344
	var _t345 = J.gp(_s132["m"], "habit")
	var _t346 = J.add(_s132["h"], ("<small class=\"stn-sub\">見慣度 <b>" + J.str(J.mc(_t345, "toFixed", [1.0])) + "</b> / 10　" + J.str(v_stProg_325) + "</small><div class=\"stn-posts\">"))
	_s132["h"] = _t346
	var _t347 = J.gp(_s132["def"], "posts")
	J.mc(_t347, "forEach", [Callable(self, "_f73").bind(_s132)])
	var _t365 = J.add(_s132["h"], ("</div><div class=\"stn-acts\"><button class=\"btn gold\" data-st-live=\"" + J.str(J.gp(_s132["def"], "id")) + "\">看實況</button></div></div>"))
	_s132["h"] = _t365
	return _s132["h"]

func _f76(this_, a: Array, env):
	var v_x_339 = null
	v_x_339 = J.arg(a, 0)
	return ("<p class=\"ev\">" + J.str(v_x_339) + "</p>")

func _f77(this_, a: Array, env):
	var v_x_340 = null
	v_x_340 = J.arg(a, 0)
	return ("<p>" + J.str(J.gp(v_x_340, "h")) + "</p>")

func _f75(this_, a: Array, env):
	var v_s_336 = null; var v_h_337 = null; var v_r_338 = null
	v_s_336 = J.cl(env["st"], null, [])
	v_h_337 = ""
	if J.t(J.gp(v_s_336, "report")):
		v_r_338 = J.gp(v_s_336, "report")
		var _t367 = (J.add(floor(J.num(J.div(J.gp(v_r_338, "mins"), 60.0))), " 小時") if J.cmp(J.gp(v_r_338, "mins"), 60.0, ">=") else "")
		var _t368 = (J.add(J.mod(J.gp(v_r_338, "mins"), 60.0), " 分鐘") if J.t(J.mod(J.gp(v_r_338, "mins"), 60.0)) else "")
		var _t369 = J.gp(v_r_338, "n")
		var _t370 = J.gp(v_r_338, "me")
		var _t371 = J.gp(v_r_338, "en")
		var _t366 = J.gp(v_r_338, "kpi")
		var _t375 = (_t366 if J.t(_t366) else 0.0)
		var _t372 = J.gp(v_r_338, "events")
		var _t373 = (_t372 if J.t(_t372) else [])
		var _t374 = J.mc(_t373, "map", [Callable(self, "_f76").bind(env)])
		var _t376 = J.add(v_h_337, ("<div class=\"stn-report\"><b>你不在的 " + _t367 + _t368 + "裡</b><p>經過 " + J.str(_t369) + " 個路人：我方嚇破膽 " + J.str(_t370) + " 個，夜冷村搶走 " + J.str(_t371) + " 個。合約 KPI +" + J.str(_t375) + "。</p>" + J.str(J.mc(_t374, "join", [""])) + "</div>"))
		v_h_337 = _t376
		J.sp(v_s_336, "report", null)
	var _t378 = J.gp(env["TUNE"], "stableHours")
	var _t377 = env["pct"]
	var _t380 = J.cl(_t377, null, [J.gp(env["TUNE"], "stableRatio")])
	var _t379 = J.gp(v_s_336, "earned")
	var _t381 = J.add(v_h_337, ("<div class=\"stn-top\"><p>派鬼到陽間各張地圖站崗，嚇路過的人。路人會越來越難嚇，但見慣度最高 10；在 10 也頂得住、而且連續 " + J.str(_t378) + " 小時嚇破膽 ≥" + J.str(_t380) + "，地盤就穩定。夜冷村的 Bryan 會來搶崗位、搶功、騷擾你的鬼。</p><small>站崗的鬼不能同時在村裡幹活。站崗累積的業績已換成合約 KPI <b>" + J.str((_t379 if J.t(_t379) else 0.0)) + "</b> 點。</small></div>"))
	v_h_337 = _t381
	var _t382 = J.mc(env["MAPS"], "map", [env["mapCard"]])
	var _t383 = J.add(v_h_337, J.mc(_t382, "join", [""]))
	v_h_337 = _t383
	if J.t(J.len(J.gp(v_s_336, "log"))):
		var _t384 = J.gp(v_s_336, "log")
		var _t385 = J.mc(_t384, "slice", [0.0, 8.0])
		var _t386 = J.mc(_t385, "map", [Callable(self, "_f77").bind(env)])
		var _t387 = J.add(v_h_337, ("<div class=\"stn-log\"><b>最近發生</b>" + J.str(J.mc(_t386, "join", [""])) + "</div>"))
		v_h_337 = _t387
	return v_h_337

func _f79(this_, a: Array, env):
	var v_x_350 = null
	v_x_350 = J.arg(a, 0)
	return J.gp(v_x_350, "name")

func _f81(this_, a: Array, env):
	var v_t_354 = null
	v_t_354 = J.arg(a, 0)
	return J.gp(env["__p"]["W"], v_t_354)

func _f80(this_, a: Array, env):
	var v_g_351 = null; var v_ts_352 = null; var v_fit_353 = null
	v_g_351 = J.arg(a, 0)
	var _t395 = env["__p"]["typesOf"]
	v_ts_352 = J.cl(_t395, null, [J.gp(v_g_351, "k")])
	v_fit_353 = J.mc(v_ts_352, "includes", [J.gp(env["p"], "fit")])
	var _t397 = J.gp(v_g_351, "id")
	var _t398 = J.gp(v_g_351, "k")
	var _t399 = J.gp(v_g_351, "name")
	var _t400 = J.gp(v_g_351, "q")
	var _t401 = J.gp(v_g_351, "q")
	var _t396 = J.mc(v_ts_352, "map", [Callable(self, "_f81").bind(env)])
	var _t403 = J.mc(_t396, "join", ["／"])
	var _t404 = ("　<em class=\"stn-fit\">啱這個崗位</em>" if J.t(v_fit_353) else "")
	var _t402 = env["__p"]["drillLv"]
	var _t406 = J.cl(_t402, null, [J.gp(v_g_351, "k")])
	var _t405 = env["__p"]["has"]
	var _t408 = (J.mc(J.G.get("GP"), "pow", [v_g_351]) if J.t(J.cl(_t405, null, [J.G.get("GP")])) else "-")
	var _t407 = env["__p"]["power"]
	return ("<div class=\"gi\" data-st-pick=\"" + J.str(_t397) + "\"><canvas data-por=\"" + J.str(_t398) + "\"></canvas><div><b>" + J.str(_t399) + "</b> <i class=\"q q" + J.str(_t400) + "\">" + J.str(_t401) + "</i><small>嚇法：" + J.str(_t403) + _t404 + "　嚇功 Lv" + J.str(_t406) + "　鬼力 " + J.str(_t408) + "　威力 " + J.str(J.round(J.num(J.cl(_t407, null, [v_g_351])))) + "</small></div></div>")

func _f78(this_, a: Array, env):
	var v_mapId_343 = null; var v_pi_344 = null; var v_def_345 = null; var v_list_347 = null; var v_cur_348 = null; var v_h_349 = null
	var _s139 = {"__p": env, "p": null}
	v_mapId_343 = J.arg(a, 0)
	v_pi_344 = J.arg(a, 1)
	var _t388 = _s139["__p"]["mapOf"]
	v_def_345 = J.cl(_t388, null, [v_mapId_343])
	_s139["p"] = J.gp(J.gp(v_def_345, "posts"), v_pi_344)
	v_list_347 = J.cl(_s139["__p"]["freeGhosts"], null, [])
	var _t389 = _s139["__p"]["ms"]
	v_cur_348 = J.gp(J.gp(J.cl(_t389, null, [v_mapId_343]), "posts"), v_pi_344)
	var _t392 = J.gp(v_def_345, "short")
	var _t393 = J.gp(_s139["p"], "name")
	var _t394 = J.gp(_s139["__p"]["W"], J.gp(_s139["p"], "fit"))
	var _t390 = J.gp(v_def_345, "people")
	var _t391 = J.mc(_t390, "map", [Callable(self, "_f79").bind(_s139)])
	v_h_349 = ("<p class=\"desc\">派一隻鬼到 <b>" + J.str(_t392) + "・" + J.str(_t393) + "</b>。這個崗位適合「" + J.str(_t394) + "」。路人：" + J.str(J.mc(_t391, "join", ["、"])) + "。</p>")
	var _t410 = ("<div class=\"stn-pick\">")
	var _t409 = J.mc(v_list_347, "map", [Callable(self, "_f80").bind(_s139)])
	var _t411 = J.add(v_h_349, (J.add(_t410, J.mc(_t409, "join", [""])) + ("</div>")))
	v_h_349 = _t411
	if (not J.t(J.len(v_list_347))):
		var _t412 = J.add(v_h_349, ("<p class=\"desc\">沒有空閒的鬼。先把村裡幹活的鬼撤下來，或等被趕走的鬼休息好。</p>"))
		v_h_349 = _t412
	var _t413 = J.add(v_h_349, ("<button class=\"btn\" data-st-back=\"1\">返回</button>"))
	v_h_349 = _t413
	return v_h_349

func _f83(this_, a: Array, env):
	return J.cl(env["__p"]["panelHTML"], null, [])

func _f84(this_, a: Array, env):
	var v_b_358 = null
	var _t414 = J.G.get("$")
	v_b_358 = J.cl(_t414, null, ["#sheet .sh-body"])
	if J.t(((not J.t(J.gp(J.gp(v_b_358, "dataset"), "picking"))) if J.t(v_b_358) else v_b_358)):
		var _t415 = J.cl(env["render"], null, [])
		J.sp(v_b_358, "innerHTML", _t415)
		J.cl(env["__p"]["bind"], null, [])
		J.cl(env["__p"]["drawPors"], null, [])

func _f82(this_, a: Array, env):
	var _s143 = {"__p": env, "render": null}
	J.cl(_s143["__p"]["tick"], null, [])
	_s143["render"] = Callable(self, "_f83").bind(_s143)
	J.mc(J.G.get("UI"), "sheet", ["陽間地盤・站崗", J.cl(_s143["render"], null, []), Callable(self, "_f84").bind(_s143)])
	J.cl(_s143["__p"]["bind"], null, [])
	J.cl(_s143["__p"]["drawPors"], null, [])

func _f85(this_, a: Array, env):
	var v_e_361 = null
	var _t416 = J.G.get("paintPortraits")
	var _t417 = J.G.get("$")
	J.cl(_t416, null, [J.cl(_t417, null, ["#sheet"])])

func _f90(this_, a: Array, env):
	var _t431 = env["__p"]["__p"]["__p"]["__p"]["assign"]
	var _t433 = env["__p"]["id"]
	var _t434 = J.num(env["__p"]["i"])
	var _t432 = J.num(J.gp(J.gp(env["y"], "dataset"), "stPick"))
	J.cl(_t431, null, [_t433, _t434, (_t432 if J.t(_t432) else J.gp(J.gp(env["y"], "dataset"), "stPick"))])
	if J.t(J.gp(J.G.get("Sound"), "play")):
		J.mc(J.G.get("Sound"), "play", ["click"])
	J.cl(env["__p"]["__p"]["__p"]["__p"]["openPanel"], null, [])

func _f89(this_, a: Array, env):
	var _s154 = {"__p": env, "y": null}
	_s154["y"] = J.arg(a, 0)
	var _t430 = _s154["y"]
	var _t435 = Callable(self, "_f90").bind(_s154)
	J.sp(_t430, "onclick", _t435)
	return _t435

func _f91(this_, a: Array, env):
	return J.cl(env["__p"]["__p"]["__p"]["openPanel"], null, [])

func _f88(this_, a: Array, env):
	var _s153 = {"__p": env, "id": null, "i": null}
	var _t421 = J.gp(J.gp(_s153["__p"]["x"], "dataset"), "stAs")
	var _t422 = J.mc(_t421, "split", [":"])
	var _t423 = J.gp(_t422, 0.0)
	_s153["id"] = _t423
	var _t424 = J.gp(_t422, 1.0)
	_s153["i"] = _t424
	var _t425 = J.gp(_s153["__p"]["__p"]["b"], "dataset")
	J.sp(_t425, "picking", 1.0)
	var _t426 = _s153["__p"]["__p"]["b"]
	var _t427 = _s153["__p"]["__p"]["__p"]["pickHTML"]
	var _t428 = J.cl(_t427, null, [_s153["id"], J.num(_s153["i"])])
	J.sp(_t426, "innerHTML", _t428)
	J.cl(_s153["__p"]["__p"]["__p"]["drawPors"], null, [])
	var _t429 = J.mc(_s153["__p"]["__p"]["b"], "querySelectorAll", ["[data-st-pick]"])
	J.mc(_t429, "forEach", [Callable(self, "_f89").bind(_s153)])
	var _t436 = J.mc(_s153["__p"]["__p"]["b"], "querySelector", ["[data-st-back]"])
	var _t437 = Callable(self, "_f91").bind(_s153)
	J.sp(_t436, "onclick", _t437)

func _f87(this_, a: Array, env):
	var _s152 = {"__p": env, "x": null}
	_s152["x"] = J.arg(a, 0)
	var _t420 = _s152["x"]
	var _t438 = Callable(self, "_f88").bind(_s152)
	J.sp(_t420, "onclick", _t438)
	return _t438

func _f93(this_, a: Array, env):
	var v_id_370 = null; var v_i_371 = null
	var _t441 = J.gp(J.gp(env["x"], "dataset"), "stUn")
	var _t442 = J.mc(_t441, "split", [":"])
	var _t443 = J.gp(_t442, 0.0)
	v_id_370 = _t443
	var _t444 = J.gp(_t442, 1.0)
	v_i_371 = _t444
	var _t445 = env["__p"]["__p"]["assign"]
	J.cl(_t445, null, [v_id_370, J.num(v_i_371), null])
	J.cl(env["__p"]["__p"]["openPanel"], null, [])

func _f92(this_, a: Array, env):
	var _s157 = {"__p": env, "x": null}
	_s157["x"] = J.arg(a, 0)
	var _t440 = _s157["x"]
	var _t446 = Callable(self, "_f93").bind(_s157)
	J.sp(_t440, "onclick", _t446)
	return _t446

func _f95(this_, a: Array, env):
	var v_id_373 = null; var v_i_374 = null; var v_r_375 = null
	var _t449 = J.gp(J.gp(env["x"], "dataset"), "stHit")
	var _t450 = J.mc(_t449, "split", [":"])
	var _t451 = J.gp(_t450, 0.0)
	v_id_373 = _t451
	var _t452 = J.gp(_t450, 1.0)
	v_i_374 = _t452
	var _t453 = env["__p"]["__p"]["hitRival"]
	v_r_375 = J.cl(_t453, null, [v_id_373, J.num(v_i_374)])
	if J.t((J.gp(v_r_375, "msg") if J.t(v_r_375) else v_r_375)):
		J.mc(J.G.get("Fx"), "toast", [J.gp(v_r_375, "msg")])
	else:
		if J.t(v_r_375):
			J.mc(J.G.get("Fx"), "toast", [(J.str(J.gp(J.gp(v_r_375, "g"), "name")) + "出手（" + J.str(J.gp(env["__p"]["__p"]["W"], J.gp(v_r_375, "type"))) + "）" + (("，對方" + J.str(J.gp(v_r_375, "tag"))) if J.t(J.gp(v_r_375, "tag")) else "") + "：−" + J.str(J.gp(v_r_375, "dmg")) + ("，趕走了！" if J.t(J.gp(v_r_375, "gone")) else ""))])
	J.cl(env["__p"]["__p"]["openPanel"], null, [])

func _f94(this_, a: Array, env):
	var _s159 = {"__p": env, "x": null}
	_s159["x"] = J.arg(a, 0)
	var _t448 = _s159["x"]
	var _t454 = Callable(self, "_f95").bind(_s159)
	J.sp(_t448, "onclick", _t454)
	return _t454

func _f97(this_, a: Array, env):
	J.mc(J.G.get("UI"), "close", [])
	J.mc(env["__p"]["__p"]["Live"], "open", [J.gp(J.gp(env["x"], "dataset"), "stLive")])

func _f96(this_, a: Array, env):
	var _s161 = {"__p": env, "x": null}
	_s161["x"] = J.arg(a, 0)
	var _t456 = _s161["x"]
	var _t457 = Callable(self, "_f97").bind(_s161)
	J.sp(_t456, "onclick", _t457)
	return _t457

func _f86(this_, a: Array, env):
	var _s151 = {"__p": env, "b": null}
	var _t418 = J.G.get("$")
	_s151["b"] = J.cl(_t418, null, ["#sheet .sh-body"])
	if (not J.t(_s151["b"])):
		return null
	J.del(J.gp(_s151["b"], "dataset"), "picking")
	var _t419 = J.mc(_s151["b"], "querySelectorAll", ["[data-st-as]"])
	J.mc(_t419, "forEach", [Callable(self, "_f87").bind(_s151)])
	var _t439 = J.mc(_s151["b"], "querySelectorAll", ["[data-st-un]"])
	J.mc(_t439, "forEach", [Callable(self, "_f92").bind(_s151)])
	var _t447 = J.mc(_s151["b"], "querySelectorAll", ["[data-st-hit]"])
	J.mc(_t447, "forEach", [Callable(self, "_f94").bind(_s151)])
	var _t455 = J.mc(_s151["b"], "querySelectorAll", ["[data-st-live]"])
	J.mc(_t455, "forEach", [Callable(self, "_f96").bind(_s151)])

func _f99(this_, a: Array, env):
	var v_d_383 = null
	v_d_383 = J.arg(a, 0)
	var _t458 = env["open"]
	var _t461 = J.cl(_t458, null, [v_d_383])
	if J.t(_t461):
		var _t459 = env["status"]
		var _t460 = env["ms"]
		_t461 = J.seq(J.gp(J.cl(_t459, null, [J.cl(_t460, null, [J.gp(v_d_383, "id")])]), "k"), "own")
	return _t461

func _f100(this_, a: Array, env):
	var v_d_384 = null
	v_d_384 = J.arg(a, 0)
	var _t462 = env["open"]
	var _t465 = J.cl(_t462, null, [v_d_384])
	if J.t(_t465):
		var _t463 = env["ms"]
		var _t464 = J.gp(J.cl(_t463, null, [J.gp(v_d_384, "id")]), "enemy")
		_t465 = J.mc(_t464, "some", [J.G.get("Boolean")])
	return _t465

func _f98(this_, a: Array, env):
	var v_n_379 = null; var v_s_380 = null; var v_own_381 = null; var v_raid_382 = null
	v_n_379 = J.len(J.mc(env["MAPS"], "filter", [env["open"]]))
	if (not J.t(v_n_379)):
		return ""
	v_s_380 = J.cl(env["st"], null, [])
	v_own_381 = J.len(J.mc(env["MAPS"], "filter", [Callable(self, "_f99").bind(env)]))
	v_raid_382 = J.mc(env["MAPS"], "some", [Callable(self, "_f100").bind(env)])
	return ("<div class=\"sc-entry stn-entry\"><div><b>陽間地盤・站崗</b><small>佔領 " + J.str(v_own_381) + " 張地圖" + ("　<em class=\"stn-alert\">⚑ 夜冷村在搶</em>" if J.t(v_raid_382) else "") + "　派鬼站崗嚇路人</small></div><button class=\"btn gold\" id=\"stn-open\">打開</button></div>")

func _f138(this_, a: Array, env):
	var v_e_555 = null
	if (not J.seq(J.typeof_(J.G.get("Street")), "undefined")):
		J.mc(J.G.get("Street"), "open", [])

func _f137(this_, a: Array, env):
	var v_tt_554 = null; var v_e_556 = null
	var _t468 = env["has"]
	var _t469 = J.cl(_t468, null, [J.G.get("S")])
	var _t470 = (J.G.get("S") if J.t(_t469) else _t469)
	var _t471 = (J.gp(J.G.get("S"), "ghosts") if J.t(_t470) else _t470)
	if J.t(((not J.t(J.gp(J.G.get("S"), "_stnTest"))) if J.t(_t471) else _t471)):
		J.cl(env["testHook"], null, [])
	v_tt_554 = J.S_document_("getElementById", ["title"])
	var _t474 = (not J.t(J.gp(J.G.get("window"), "_stnAuto")))
	if J.t(_t474):
		var _t473 = v_tt_554
		if J.t(_t473):
			var _t472 = J.gp(v_tt_554, "classList")
			_t473 = J.mc(_t472, "contains", ["on"])
		_t474 = (not J.t(_t473))
	if _t474:
		var _t475 = J.G.get("window")
		J.sp(_t475, "_stnAuto", 1.0)
		J.F_setTimeout([Callable(self, "_f138").bind(env), 800.0])

func _f139(this_, a: Array, env):
	var v_k_558 = null; var v_i_559 = null; var v_a_560 = null
	v_k_558 = J.arg(a, 0)
	v_i_559 = J.arg(a, 1)
	v_a_560 = J.arg(a, 2)
	var _t484 = J.seq(J.mc(v_a_560, "indexOf", [v_k_558]), v_i_559)
	return ((not J.seq(v_k_558, "afu")) if _t484 else _t484)

func _f141(this_, a: Array, env):
	var v_g_562 = null
	v_g_562 = J.arg(a, 0)
	return J.seq(J.gp(v_g_562, "k"), env["k"])

func _f140(this_, a: Array, env):
	var v_e_563 = null
	var _s262 = {"__p": env, "k": null}
	_s262["k"] = J.arg(a, 0)
	var _t486 = _s262["__p"]["has"]
	var _t488 = J.cl(_t486, null, [J.G.get("joinGhost")])
	if J.t(_t488):
		var _t487 = _s262["__p"]["has"]
		_t488 = J.cl(_t487, null, [J.G.get("GHOSTS")])
	var _t490 = (J.gp(J.G.get("GHOSTS"), _s262["k"]) if J.t(_t488) else _t488)
	if J.t(_t490):
		var _t489 = J.gp(J.G.get("S"), "ghosts")
		_t490 = (not J.t(J.mc(_t489, "some", [Callable(self, "_f141").bind(_s262)])))
	if J.t(_t490):
		var _t491 = J.G.get("joinGhost")
		J.cl(_t491, null, [_s262["k"]])

func _f142(this_, a: Array, env):
	var v_e_565 = null
	if (not J.seq(J.typeof_(J.G.get("Street")), "undefined")):
		J.mc(J.G.get("Street"), "open", [])

func _f143(this_, a: Array, env):
	var v_tt_566 = null; var v_sh_567 = null; var v_e_568 = null
	v_tt_566 = J.S_document_("getElementById", ["title"])
	v_sh_567 = J.S_document_("getElementById", ["sheet"])
	var _t497 = J.gp(env["b"], "style")
	var _t500 = J.gp(env["__p"]["Live"], "on")
	if not J.t(_t500):
		var _t499 = v_tt_566
		if J.t(_t499):
			var _t498 = J.gp(v_tt_566, "classList")
			_t499 = J.mc(_t498, "contains", ["on"])
		_t500 = _t499
	var _t503 = _t500
	if not J.t(_t503):
		var _t502 = v_sh_567
		if J.t(_t502):
			var _t501 = J.gp(v_sh_567, "classList")
			_t502 = J.mc(_t501, "contains", ["on"])
		_t503 = _t502
	var _t504 = ("none" if J.t(_t503) else "")
	J.sp(_t497, "display", _t504)

func _f136(this_, a: Array, env):
	var v_e_557 = null; var v_e_569 = null
	var _t466 = J.seq(J.typeof_(J.G.get("window")), "undefined")
	if (_t466 if _t466 else (not J.t(J.gp(J.G.get("window"), "STN_TEST")))):
		return null
	if (not J.t(J.gp(J.G.get("window"), "_stnTestT"))):
		var _t467 = J.G.get("window")
		var _t476 = J.F_setInterval([Callable(self, "_f137").bind(env), 1500.0])
		J.sp(_t467, "_stnTestT", _t476)
	var _t477 = env["has"]
	var _t478 = J.cl(_t477, null, [J.G.get("LANG")])
	if J.t(((not J.t(J.S_localStorage_("getItem", ["gb_stntest_yue"]))) if J.t(_t478) else _t478)):
		J.S_localStorage_("setItem", ["gb_stntest_yue", "1"])
		J.mc(J.G.get("LANG"), "set", ["yue"])
	var _t479 = J.G.get("S")
	J.sp(_t479, "_stnTest", 1.0)
	var _t480 = J.gp(J.G.get("S"), "seen")
	J.sp(_t480, "ch1_end", 1.0)
	var _t481 = ["tianhua", "eguiking", "laojiang", "pontianak", "xiaozhi", "toyol"]
	var _t482 = env["has"]
	var _t483 = J.mc(_t481, "concat", [(J.S_Object_("keys", [J.G.get("GHOSTS")]) if J.t(J.cl(_t482, null, [J.G.get("GHOSTS")])) else [])])
	var _t485 = J.mc(_t483, "filter", [Callable(self, "_f139").bind(env)])
	J.mc(_t485, "forEach", [Callable(self, "_f140").bind(env)])
	if (not J.t(J.S_document_("getElementById", ["stn-testbtn"]))):
		var _s267 = {"__p": env, "b": null}
		_s267["b"] = J.S_document_("createElement", ["button"])
		var _t492 = _s267["b"]
		J.sp(_t492, "id", "stn-testbtn")
		var _t493 = _s267["b"]
		J.sp(_t493, "textContent", "站崗測試")
		var _t494 = _s267["b"]
		var _t495 = Callable(self, "_f142").bind(_s267)
		J.sp(_t494, "onclick", _t495)
		var _t496 = _s267["b"]
		J.sp(_t496, "textContent", "陽間站崗（點我）")
		J.F_setInterval([Callable(self, "_f143").bind(_s267), 300.0])
		var _t505 = J.gp(_s267["b"], "style")
		J.sp(_t505, "cssText", "position:fixed;left:50%;transform:translateX(-50%);bottom:calc(env(safe-area-inset-bottom) + 86px);z-index:99999;padding:12px 22px;border-radius:14px;border:2px solid #ffd98a;background:#b8341f;color:#fff;font-weight:800;font-size:18px;box-shadow:0 3px 10px #000a")
		var _t506 = J.gp(J.G.get("document"), "body")
		J.mc(_t506, "appendChild", [_s267["b"]])
	J.cl(J.G.get("save"), null, [])

func _f145(this_, a: Array, env):
	var v_e_574 = null
	if (not J.t(J.gp(env["Live"], "on"))):
		J.cl(env["tick"], null, [])

func _f146(this_, a: Array, env):
	if J.t(J.gp(env["Live"], "on")):
		J.mc(env["Live"], "resize", [])

func _f144(this_, a: Array, env):
	var v_e_572 = null; var v_e_573 = null
	J.cl(env["testHook"], null, [])
	var _t507 = env["has"]
	var _t508 = J.cl(_t507, null, [J.G.get("POSTS")])
	if J.t(((not J.t(J.gp(J.G.get("POSTS"), "station"))) if J.t(_t508) else _t508)):
		var _t509 = J.G.get("POSTS")
		var _t510 = {"name": "陽間站崗", "bld": null, "stat": 2.0, "desc": "在陽間地盤站崗嚇路人"}
		J.sp(_t509, "station", _t510)
	J.cl(env["st"], null, [])
	J.F_setInterval([Callable(self, "_f145").bind(env), 5000.0])
	J.S_window_("addEventListener", ["resize", Callable(self, "_f146").bind(env)])

func _f2(this_, a: Array, env):
	var v_o_62 = null
	v_o_62 = J.arg(a, 0)
	return (not J.seq(J.typeof_(v_o_62), "undefined"))

func _f3(this_, a: Array, env):
	var v_a_63 = null; var v_b_64 = null
	v_a_63 = J.arg(a, 0)
	v_b_64 = J.arg(a, 1)
	return J.add(v_a_63, (randf() * J.sub(v_b_64, v_a_63)))

func _f4(this_, a: Array, env):
	var v_a_65 = null
	v_a_65 = J.arg(a, 0)
	return J.gp(v_a_65, floor(J.num((randf() * J.len(v_a_65)))))

func _f5(this_, a: Array, env):
	var v_t_66 = null
	v_t_66 = J.arg(a, 0)
	return (not J.seq(v_t_66, "steal"))

func _f7(this_, a: Array, env):
	var v_m_68 = null
	v_m_68 = J.arg(a, 0)
	return J.seq(J.gp(v_m_68, "id"), env["id"])

func _f6(this_, a: Array, env):
	var _s7 = {"__p": env, "id": null}
	_s7["id"] = J.arg(a, 0)
	return J.mc(_s7["__p"]["MAPS"], "find", [Callable(self, "_f7").bind(_s7)])

func _f8(this_, a: Array, env):
	var v_m_69 = null
	v_m_69 = J.arg(a, 0)
	var _t516 = (not J.t(J.gp(v_m_69, "soon")))
	if J.t(_t516):
		var _t515 = (not J.t(J.gp(v_m_69, "need")))
		if not J.t(_t515):
			var _t512 = env["has"]
			var _t513 = J.cl(_t512, null, [J.G.get("S")])
			var _t514 = (J.gp(J.G.get("S"), "seen") if J.t(_t513) else _t513)
			_t515 = (J.gp(J.gp(J.G.get("S"), "seen"), J.gp(v_m_69, "need")) if J.t(_t514) else _t514)
		_t516 = _t515
	var _t520 = _t516
	if J.t(_t520):
		var _t519 = (not J.t(J.gp(v_m_69, "bg")))
		if not J.t(_t519):
			var _t517 = env["has"]
			var _t518 = J.cl(_t517, null, [J.G.get("SPR")])
			_t519 = (J.gp(J.G.get("SPR"), J.gp(v_m_69, "bg")) if J.t(_t518) else _t518)
		_t520 = _t519
	return (not (not J.t(_t520)))

func _f9(this_, a: Array, env):
	var v_yue_70 = null; var v_zh_71 = null
	v_yue_70 = J.arg(a, 0)
	v_zh_71 = J.arg(a, 1)
	var _t521 = env["has"]
	if J.t(J.cl(_t521, null, [J.G.get("LANG")])):
		J.mc(J.G.get("LANG"), "add", [{J.key(v_yue_70): v_zh_71}])
	return v_yue_70

func _f10(this_, a: Array, env):
	var v_l_72 = null; var v_i_73 = null
	v_l_72 = J.arg(a, 0)
	v_i_73 = J.arg(a, 1)
	var _t522 = env["D"]
	return J.cl(_t522, null, [v_l_72, J.gp(["Bryan：「這個客人是我嚇走的，你們不要亂講。」", "Bryan：「你那邊的人怕什麼，我全部抄下來了。謝謝分享。」", "Bryan：「籃球拍一下，整條走廊都安靜了。學一下吧。」", "Bryan：「功勞不用分，我全拿就行。」"], v_i_73)])

func _f11(this_, a: Array, env):
	var v_s_74 = null
	v_s_74 = J.arg(a, 0)
	var _t523 = (not J.seq(J.typeof_(J.G.get("window")), "undefined"))
	return (J.S_window_("L", [v_s_74]) if J.t((J.gp(J.G.get("window"), "L") if _t523 else _t523)) else v_s_74)

func _f12(this_, a: Array, env):
	var v_k_75 = null; var v_g_76 = null
	v_k_75 = J.arg(a, 0)
	v_g_76 = J.arg(a, 1)
	var _t524 = J.gp(env["LEGEND"], v_k_75)
	return (_t524 if J.t(_t524) else (J.str((J.gp(v_g_76, "name") if J.t(v_g_76) else v_k_75)) + "的怪談"))

func _f17(this_, a: Array, env):
	var v_id_88 = null
	v_id_88 = J.arg(a, 0)
	return J.gp(J.gp(J.cl(env["st"], null, []), "maps"), v_id_88)

func _f19(this_, a: Array, env):
	var v_g_90 = null
	v_g_90 = J.arg(a, 0)
	return J.seq(J.gp(v_g_90, "id"), env["id"])

func _f18(this_, a: Array, env):
	var _s22 = {"__p": env, "id": null}
	_s22["id"] = J.arg(a, 0)
	var _t560 = J.gp(J.G.get("S"), "ghosts")
	return J.mc(_t560, "find", [Callable(self, "_f19").bind(_s22)])

func _f25(this_, a: Array, env):
	var v_m_110 = null; var v_h_111 = null; var v_a_112 = null; var v_b_113 = null; var v_x_114 = null
	v_m_110 = J.arg(a, 0)
	v_h_111 = J.gp(v_m_110, "hist")
	if (not J.t(J.len(v_h_111))):
		return {"me": 0.0, "en": 0.0, "n": 0.0}
	v_a_112 = 0.0
	v_b_113 = 0.0
	for _t561 in J.iter(v_h_111):
		v_x_114 = _t561
		if J.seq(v_x_114, 1.0):
			v_a_112 = J.num(v_a_112) + 1.0
		else:
			if J.seq(v_x_114, 2.0):
				v_b_113 = J.num(v_b_113) + 1.0
	return {"me": J.div(v_a_112, J.len(v_h_111)), "en": J.div(v_b_113, J.len(v_h_111)), "n": J.len(v_h_111)}

func _f26(this_, a: Array, env):
	var v_m_115 = null; var v_s_116 = null
	v_m_115 = J.arg(a, 0)
	var _t562 = env["share"]
	v_s_116 = J.cl(_t562, null, [v_m_115])
	return J.add(J.gp(v_s_116, "me"), J.gp(v_s_116, "en"))

func _f71(this_, a: Array, env):
	var v_x_317 = null
	v_x_317 = J.arg(a, 0)
	return J.add(J.round(J.num(J.mul(v_x_317, 100.0))), "%")

func _f102(this_, a: Array, env):
	return J.mc(env["this"], "close", [])

func _f103(this_, a: Array, env):
	var v_n_391 = null
	v_n_391 = J.arg(a, 0)
	return J.mc(env["this"], "frame", [v_n_391])

func _f101(this_, a: Array, env):
	var v_id_387 = null; var v_def_388 = null; var v_el_389 = null; var v_tb_390 = null; var v_e_392 = null
	var _s166 = {"__p": env, "this": null}
	_s166["this"] = this_
	v_id_387 = J.arg(a, 0)
	var _t563 = _s166["__p"]["mapOf"]
	v_def_388 = J.cl(_t563, null, [v_id_387])
	var _t565 = (not J.t(v_def_388))
	if not J.t(_t565):
		var _t564 = _s166["__p"]["open"]
		_t565 = (not J.t(J.cl(_t564, null, [v_def_388])))
	if _t565:
		return null
	J.cl(_s166["__p"]["tick"], null, [])
	var _t566 = _s166["this"]
	J.sp(_t566, "def", v_def_388)
	var _t567 = _s166["this"]
	J.sp(_t567, "on", true)
	var _t568 = _s166["this"]
	var _t569 = []
	J.sp(_t568, "walkers", _t569)
	var _t570 = _s166["this"]
	var _t571 = []
	J.sp(_t570, "fx", _t571)
	var _t572 = _s166["this"]
	var _t573 = J.sub(J.gp(_s166["__p"]["TUNE"], "every"), 1.5)
	J.sp(_t572, "spawnAcc", _t573)
	var _t574 = _s166["this"]
	J.sp(_t574, "t", 0.0)
	var _t575 = J.G.get("$")
	v_el_389 = J.cl(_t575, null, ["#stn-live"])
	if (not J.t(v_el_389)):
		var _t576 = J.S_document_("createElement", ["div"])
		v_el_389 = _t576
		J.sp(v_el_389, "id", "stn-live")
		var _t577 = J.gp(J.G.get("document"), "body")
		J.mc(_t577, "appendChild", [v_el_389])
	var _t578 = ("<canvas id=\"stn-cv\"></canvas><div class=\"stn-hud\"><button class=\"btn sm\" id=\"stn-x\">返回</button><div class=\"stn-hh\"><b>" + J.str(J.gp(v_def_388, "name")) + "</b><span id=\"stn-info\"></span></div></div><div class=\"stn-board\" id=\"stn-board\"></div><div class=\"stn-tip\" id=\"stn-tip\">點站崗的鬼放大招（下一個路人 ×2.5，冷卻 20 秒）。點夜冷村的鬼出手驅趕。左右拖動看整條路。</div>")
	J.sp(v_el_389, "innerHTML", _t578)
	var _t579 = J.gp(v_el_389, "classList")
	J.mc(_t579, "add", ["on"])
	var _t580 = _s166["this"]
	var _t581 = J.G.get("$")
	var _t582 = J.cl(_t581, null, ["#stn-cv"])
	J.sp(_t580, "cv", _t582)
	v_tb_390 = J.S_document_("getElementById", ["stn-testbtn"])
	if J.t(v_tb_390):
		var _t583 = J.gp(v_tb_390, "style")
		J.sp(_t583, "display", "none")
	var _t584 = _s166["this"]
	var _t585 = J.gp(_s166["this"], "cv")
	var _t586 = J.mc(_t585, "getContext", ["2d"])
	J.sp(_t584, "ctx", _t586)
	J.mc(_s166["this"], "resize", [])
	var _t587 = _s166["this"]
	var _t588 = J.mc(_s166["this"], "maxCam", [])
	J.sp(_t587, "camX", _t588)
	var _t589 = J.G.get("$")
	var _t590 = J.cl(_t589, null, ["#stn-x"])
	var _t591 = Callable(self, "_f102").bind(_s166)
	J.sp(_t590, "onclick", _t591)
	J.mc(_s166["this"], "bindPan", [])
	var _t592 = _s166["this"]
	var _t593 = J.S_performance_("now", [])
	J.sp(_t592, "last", _t593)
	J.F_cancelAnimationFrame([J.gp(_s166["this"], "raf")])
	var _t594 = _s166["this"]
	var _t595 = J.F_requestAnimationFrame([Callable(self, "_f103").bind(_s166)])
	J.sp(_t594, "raf", _t595)
	var _t596 = _s166["__p"]["has"]
	var _t597 = J.cl(_t596, null, [J.G.get("Sound")])
	if J.t((J.gp(J.G.get("Sound"), "setMode") if J.t(_t597) else _t597)):
		J.mc(J.G.get("Sound"), "setMode", ["scare"])

func _f104(this_, a: Array, env):
	var v_el_395 = null; var v_tb_396 = null; var v_e_397 = null
	var _t598 = this_
	J.sp(_t598, "on", false)
	J.F_cancelAnimationFrame([J.gp(this_, "raf")])
	var _t599 = J.G.get("$")
	v_el_395 = J.cl(_t599, null, ["#stn-live"])
	if J.t(v_el_395):
		var _t600 = J.gp(v_el_395, "classList")
		J.mc(_t600, "remove", ["on"])
	v_tb_396 = J.S_document_("getElementById", ["stn-testbtn"])
	if J.t(v_tb_396):
		var _t601 = J.gp(v_tb_396, "style")
		J.sp(_t601, "display", "")
	var _t602 = J.cl(env["st"], null, [])
	var _t603 = J.S_Date_("now", [])
	J.sp(_t602, "t", _t603)
	var _t604 = env["has"]
	var _t605 = J.cl(_t604, null, [J.G.get("Sound")])
	if J.t((J.gp(J.G.get("Sound"), "setMode") if J.t(_t605) else _t605)):
		J.mc(J.G.get("Sound"), "setMode", ["village"])
	J.cl(env["openPanel"], null, [])

func _f105(this_, a: Array, env):
	var v_dpr_400 = null; var v_r_401 = null
	var _t606 = J.gp(J.G.get("window"), "devicePixelRatio")
	var _t607 = J.gp(J.G.get("window"), "devicePixelRatio")
	v_dpr_400 = J.min_([2.0, (_t607 if J.t(_t607) else 1.0)])
	v_r_401 = J.mc(J.gp(this_, "cv"), "getBoundingClientRect", [])
	var _t608 = this_
	var _t609 = J.gp(v_r_401, "width")
	var _t610 = (_t609 if J.t(_t609) else J.G.get("innerWidth"))
	J.sp(_t608, "W", _t610)
	var _t611 = this_
	var _t612 = J.gp(v_r_401, "height")
	var _t613 = (_t612 if J.t(_t612) else J.G.get("innerHeight"))
	J.sp(_t611, "H", _t613)
	var _t614 = J.gp(this_, "cv")
	var _t615 = J.round(J.num(J.mul(J.gp(this_, "W"), v_dpr_400)))
	J.sp(_t614, "width", _t615)
	var _t616 = J.gp(this_, "cv")
	var _t617 = J.round(J.num(J.mul(J.gp(this_, "H"), v_dpr_400)))
	J.sp(_t616, "height", _t617)
	var _t618 = J.gp(this_, "ctx")
	J.mc(_t618, "setTransform", [v_dpr_400, 0.0, 0.0, v_dpr_400, 0.0, 0.0])
	var _t619 = this_
	J.sp(_t619, "dpr", v_dpr_400)

func _f106(this_, a: Array, env):
	var v_c_404 = null
	var _t621 = J.seq(J.gp(J.gp(this_, "def"), "id"), "office")
	if J.t(_t621):
		var _t620 = env["has"]
		_t621 = J.cl(_t620, null, [J.G.get("OFFMAP")])
	if J.t((J.gp(J.G.get("OFFMAP"), "pano") if J.t(_t621) else _t621)):
		v_c_404 = J.mc(J.G.get("OFFMAP"), "pano", [])
		if J.t(v_c_404):
			return v_c_404
	return J.gp(J.G.get("SPR"), J.gp(J.gp(this_, "def"), "bg"))

func _f107(this_, a: Array, env):
	return J.min_([J.mul(J.gp(this_, "H"), 0.56), J.mul(J.gp(this_, "W"), 1.25)])

func _f108(this_, a: Array, env):
	return J.max_([270.0, (J.sub(J.gp(this_, "H"), J.mc(this_, "bgH", [])) - J.mul(J.gp(this_, "H"), 0.15))])

func _f109(this_, a: Array, env):
	var v_img_411 = null
	v_img_411 = J.mc(this_, "img", [])
	return J.div(J.mc(this_, "bgH", []), J.gp(v_img_411, "height"))

func _f110(this_, a: Array, env):
	var v_a_414 = null; var v_b_415 = null
	var _t622 = J.gp(J.gp(this_, "def"), "seg")
	var _t623 = J.gp(_t622, 0.0)
	v_a_414 = _t623
	var _t624 = J.gp(_t622, 1.0)
	v_b_415 = _t624
	return J.max_([0.0, J.sub(J.mul(J.sub(v_b_415, v_a_414), J.mc(this_, "sc", [])), J.gp(this_, "W"))])

func _f111(this_, a: Array, env):
	var v_px_418 = null
	v_px_418 = J.arg(a, 0)
	return J.sub(J.mul(J.sub(v_px_418, J.gp(J.gp(J.gp(this_, "def"), "seg"), 0.0)), J.mc(this_, "sc", [])), J.gp(this_, "camX"))

func _f112(this_, a: Array, env):
	return J.mul(J.mc(this_, "bgH", []), 0.4)

func _f114(this_, a: Array, env):
	var v_e_425 = null; var v___426 = null
	v_e_425 = J.arg(a, 0)
	var _t626 = {"x0": J.gp(v_e_425, "clientX"), "c0": J.gp(env["this"], "camX"), "moved": false}
	env["d"] = _t626
	J.mc(env["cv"], "setPointerCapture", [J.gp(v_e_425, "pointerId")])

func _f115(this_, a: Array, env):
	var v_e_427 = null; var v_dx_428 = null
	v_e_427 = J.arg(a, 0)
	if (not J.t(env["d"])):
		return null
	v_dx_428 = J.sub(J.gp(v_e_427, "clientX"), J.gp(env["d"], "x0"))
	if (absf(J.num(v_dx_428)) > 8.0):
		var _t629 = env["d"]
		J.sp(_t629, "moved", true)
	if J.t(J.gp(env["d"], "moved")):
		var _t630 = env["this"]
		var _t631 = J.max_([0.0, J.min_([J.mc(env["this"], "maxCam", []), J.sub(J.gp(env["d"], "c0"), v_dx_428)])])
		J.sp(_t630, "camX", _t631)

func _f116(this_, a: Array, env):
	var v_e_429 = null; var v_was_430 = null
	v_e_429 = J.arg(a, 0)
	v_was_430 = env["d"]
	env["d"] = null
	if J.t(((not J.t(J.gp(v_was_430, "moved"))) if J.t(v_was_430) else v_was_430)):
		J.mc(env["this"], "tap", [v_e_429])

func _f117(this_, a: Array, env):
	env["d"] = null

func _f113(this_, a: Array, env):
	var _s186 = {"__p": env, "this": null, "cv": null, "d": null}
	_s186["this"] = this_
	_s186["cv"] = J.gp(_s186["this"], "cv")
	_s186["d"] = null
	var _t625 = _s186["cv"]
	var _t627 = Callable(self, "_f114").bind(_s186)
	J.sp(_t625, "onpointerdown", _t627)
	var _t628 = _s186["cv"]
	var _t632 = Callable(self, "_f115").bind(_s186)
	J.sp(_t628, "onpointermove", _t632)
	var _t633 = _s186["cv"]
	var _t634 = Callable(self, "_f116").bind(_s186)
	J.sp(_t633, "onpointerup", _t634)
	var _t635 = _s186["cv"]
	var _t636 = Callable(self, "_f117").bind(_s186)
	J.sp(_t635, "onpointercancel", _t636)

func _f118(this_, a: Array, env):
	var v_i_433 = null; var v_p_434 = null
	v_i_433 = J.arg(a, 0)
	v_p_434 = J.gp(J.gp(J.gp(this_, "def"), "posts"), v_i_433)
	return [J.mc(this_, "sx", [J.gp(v_p_434, "x")]), J.add(J.mc(this_, "top", []), J.mul(J.mc(this_, "bgH", []), J.gp(J.gp(this_, "def"), "walkY")))]

func _f119(this_, a: Array, env):
	var v_e_437 = null; var v_r_438 = null; var v_x_439 = null; var v_y_440 = null; var v_m_441 = null; var v_h_442 = null; var v_i_443 = null; var v_px_444 = null; var v_py_445 = null; var v_res_446 = null; var v_left_447 = null
	v_e_437 = J.arg(a, 0)
	v_r_438 = J.mc(J.gp(this_, "cv"), "getBoundingClientRect", [])
	v_x_439 = J.sub(J.gp(v_e_437, "clientX"), J.gp(v_r_438, "left"))
	v_y_440 = J.sub(J.gp(v_e_437, "clientY"), J.gp(v_r_438, "top"))
	var _t637 = env["ms"]
	v_m_441 = J.cl(_t637, null, [J.gp(J.gp(this_, "def"), "id")])
	v_h_442 = J.mc(this_, "personH", [])
	v_i_443 = 0.0
	while true:
		if not J.cmp(v_i_443, J.len(J.gp(J.gp(this_, "def"), "posts")), "<"): break
		var _t638 = J.mc(this_, "postXY", [v_i_443])
		var _t639 = J.gp(_t638, 0.0)
		v_px_444 = _t639
		var _t640 = J.gp(_t638, 1.0)
		v_py_445 = _t640
		var _t641 = J.gp(J.gp(v_m_441, "enemy"), v_i_443)
		var _t642 = ((absf(J.num(J.sub(v_x_439, J.add(v_px_444, J.mul(v_h_442, 0.32))))) < J.mul(v_h_442, 0.28)) if J.t(_t641) else _t641)
		var _t643 = (J.cmp(v_y_440, J.sub(v_py_445, J.mul(v_h_442, 1.1)), ">") if J.t(_t642) else _t642)
		if J.t((J.cmp(v_y_440, J.add(v_py_445, 10.0), "<") if J.t(_t643) else _t643)):
			var _t644 = env["hitRival"]
			v_res_446 = J.cl(_t644, null, [J.gp(J.gp(this_, "def"), "id"), v_i_443])
			if (not J.t(v_res_446)):
				return null
			if J.t(J.gp(v_res_446, "msg")):
				J.mc(this_, "float", [v_px_444, J.sub(v_py_445, v_h_442), J.gp(v_res_446, "msg"), "#ffd"])
			else:
				J.mc(this_, "float", [J.add(v_px_444, J.mul(v_h_442, 0.32)), J.sub(v_py_445, J.mul(v_h_442, 1.05)), (J.str(J.gp(env["W"], J.gp(v_res_446, "type"))) + (J.add("・", J.gp(v_res_446, "tag")) if J.t(J.gp(v_res_446, "tag")) else "") + " −" + J.str(J.gp(v_res_446, "dmg"))), ("#ff8" if J.seq(J.gp(v_res_446, "tag"), "怕") else ("#aab" if J.seq(J.gp(v_res_446, "tag"), "不怕") else "#fff"))])
				if J.t(J.gp(v_res_446, "gone")):
					J.mc(this_, "float", [J.add(v_px_444, J.mul(v_h_442, 0.32)), J.sub(v_py_445, J.mul(v_h_442, 1.3)), "趕走了！", "#7f7"])
			return null
		var _t645 = (not J.leq(J.gp(J.gp(v_m_441, "posts"), v_i_443), null))
		var _t646 = ((absf(J.num(J.sub(v_x_439, J.sub(v_px_444, J.mul(v_h_442, 0.18))))) < J.mul(v_h_442, 0.3)) if _t645 else _t645)
		var _t647 = (J.cmp(v_y_440, J.sub(v_py_445, J.mul(v_h_442, 1.1)), ">") if _t646 else _t646)
		if (J.cmp(v_y_440, J.add(v_py_445, 10.0), "<") if _t647 else _t647):
			var _t648 = env["boost"]
			v_left_447 = J.cl(_t648, null, [J.gp(J.gp(this_, "def"), "id"), v_i_443])
			J.mc(this_, "float", [J.sub(v_px_444, J.mul(v_h_442, 0.18)), J.sub(v_py_445, J.mul(v_h_442, 1.1)), (("冷卻中 " + J.str(v_left_447) + " 秒") if J.t(v_left_447) else "大招準備好！下一個路人 ×2.5"), ("#aab" if J.t(v_left_447) else "#ffb347")])
			return null
		v_i_443 = J.num(v_i_443) + 1.0

func _f120(this_, a: Array, env):
	var v_x_450 = null; var v_y_451 = null; var v_t_452 = null; var v_c_453 = null; var v_k_454 = null; var v_f_455 = null
	v_x_450 = J.arg(a, 0)
	v_y_451 = J.arg(a, 1)
	v_t_452 = J.arg(a, 2)
	v_c_453 = J.arg(a, 3)
	v_k_454 = 0.0
	for _t649 in J.iter(J.gp(this_, "fx")):
		v_f_455 = _t649
		var _t650 = J.cmp(J.gp(v_f_455, "a"), 0.9, "<")
		var _t651 = ((absf(J.num(J.sub(J.gp(v_f_455, "x"), v_x_450))) < 120.0) if _t650 else _t650)
		if ((absf(J.num(J.sub(J.gp(v_f_455, "y0"), v_y_451))) < 40.0) if _t651 else _t651):
			v_k_454 = J.num(v_k_454) + 1.0
	var _t652 = J.gp(this_, "fx")
	J.mc(_t652, "push", [{"x": v_x_450, "y": J.sub(v_y_451, J.mul(v_k_454, 26.0)), "y0": v_y_451, "t": v_t_452, "c": v_c_453, "a": 0.0}])

func _f122(this_, a: Array, env):
	var v_n_460 = null
	v_n_460 = J.arg(a, 0)
	return J.mc(env["this"], "frame", [v_n_460])

func _f121(this_, a: Array, env):
	var v_now_458 = null; var v_dt_459 = null
	var _s203 = {"__p": env, "this": null}
	_s203["this"] = this_
	v_now_458 = J.arg(a, 0)
	if (not J.t(J.gp(_s203["this"], "on"))):
		return null
	var _t653 = _s203["this"]
	var _t654 = J.F_requestAnimationFrame([Callable(self, "_f122").bind(_s203)])
	J.sp(_t653, "raf", _t654)
	if (J.sub(v_now_458, J.gp(_s203["this"], "last")) < (J.div(1000.0, 30.0) - 2.0)):
		return null
	v_dt_459 = J.min_([0.1, J.div(J.sub(v_now_458, J.gp(_s203["this"], "last")), 1000.0)])
	var _t655 = _s203["this"]
	J.sp(_t655, "last", v_now_458)
	var _t656 = _s203["this"]
	var _t657 = J.add(J.gp(_t656, "t"), v_dt_459)
	J.sp(_t656, "t", _t657)
	J.mc(_s203["this"], "step", [v_dt_459])
	J.mc(_s203["this"], "draw", [])

func _f124(this_, a: Array, env):
	var v_p_471 = null; var v_i_472 = null
	v_p_471 = J.arg(a, 0)
	v_i_472 = J.arg(a, 1)
	return v_i_472

func _f125(this_, a: Array, env):
	var v_r_480 = null; var v_k_481 = null; var v_who_482 = null; var v_txt_483 = null
	v_r_480 = J.arg(a, 0)
	v_k_481 = J.arg(a, 1)
	v_who_482 = ("" if J.seq(J.gp(v_r_480, "who"), 1.0) else "夜冷村　")
	v_txt_483 = (J.str(v_who_482) + J.str(J.gp(env["__p"]["__p"]["__p"]["W"], J.gp(v_r_480, "type"))) + ("・連嚇" if J.t(J.gp(v_r_480, "combo")) else "") + (J.add("・", J.gp(v_r_480, "tag")) if J.t(J.gp(v_r_480, "tag")) else "") + ("　嚇破膽！" if J.t(J.gp(v_r_480, "broke")) else ""))
	J.mc(env["__p"]["__p"]["this"], "float", [env["px"], J.sub(env["py"], J.mul(env["h"], (1.15 + J.mul(v_k_481, 0.18)))), v_txt_483, ("#ff7b7b" if J.seq(J.gp(v_r_480, "who"), 2.0) else ("#ffe066" if J.t(J.gp(v_r_480, "broke")) else ("#aab" if J.seq(J.gp(v_r_480, "tag"), "不怕") else "#e8f4ff")))])
	var _t699 = J.seq(J.gp(v_r_480, "who"), 1.0)
	if J.t((J.gp(v_r_480, "g") if _t699 else _t699)):
		var _t700 = J.gp(v_r_480, "g")
		var _t701 = J.gp(env["__p"]["__p"]["this"], "t")
		J.sp(_t700, "_act", _t701)

func _f126(this_, a: Array, env):
	var v_x_484 = null; var v_j_485 = null
	v_x_484 = J.arg(a, 0)
	v_j_485 = J.arg(a, 1)
	var _t710 = J.cmp(v_j_485, env["__p"]["i"], "<")
	return ((not J.leq(v_x_484, null)) if _t710 else _t710)

func _f127(this_, a: Array, env):
	var v_P_486 = null
	v_P_486 = J.arg(a, 0)
	return (not J.t(J.gp(v_P_486, "gone")))

func _f128(this_, a: Array, env):
	var v_f_488 = null
	v_f_488 = J.arg(a, 0)
	return J.cmp(J.gp(v_f_488, "a"), 2.2, "<")

func _f129(this_, a: Array, env):
	var v_x_491 = null
	v_x_491 = J.arg(a, 0)
	var _t756 = J.gp(v_x_491, "h")
	return J.mc(_t756, "includes", [J.gp(env["def"], "short")])

func _f130(this_, a: Array, env):
	var v_x_492 = null
	v_x_492 = J.arg(a, 0)
	return ("<p>" + J.str(J.gp(v_x_492, "h")) + "</p>")

func _f123(this_, a: Array, env):
	var v_dt_463 = null; var v_m_465 = null; var v_order_466 = null; var v_s_467 = null; var v_sta_468 = null; var v_info_469 = null; var v_P_470 = null; var v_P_473 = null; var v_stay_475 = null; var v_res_476 = null; var v_f_487 = null; var v_bd_489 = null; var v_stp_490 = null
	var _s205 = {"__p": env, "this": null, "def": null}
	_s205["this"] = this_
	v_dt_463 = J.arg(a, 0)
	_s205["def"] = J.gp(_s205["this"], "def")
	var _t658 = _s205["__p"]["ms"]
	v_m_465 = J.cl(_t658, null, [J.gp(_s205["def"], "id")])
	var _t659 = J.cl(_s205["__p"]["st"], null, [])
	var _t660 = J.S_Date_("now", [])
	J.sp(_t659, "t", _t660)
	var _t661 = _s205["__p"]["rivalStep"]
	J.cl(_t661, null, [_s205["def"], v_m_465, J.div(v_dt_463, 60.0)])
	var _t662 = _s205["__p"]["stableStep"]
	J.cl(_t662, null, [_s205["def"], v_m_465])
	var _t663 = _s205["__p"]["payStep"]
	J.cl(_t663, null, [_s205["def"], v_m_465])
	var _t664 = _s205["__p"]["legendStep"]
	J.cl(_t664, null, [_s205["def"], v_m_465])
	var _t665 = _s205["this"]
	var _t666 = J.add(J.gp(_t665, "spawnAcc"), v_dt_463)
	J.sp(_t665, "spawnAcc", _t666)
	if J.cmp(J.gp(_s205["this"], "spawnAcc"), J.gp(_s205["__p"]["TUNE"], "every"), ">="):
		var _t667 = _s205["this"]
		var _t668 = J.sub(J.gp(_t667, "spawnAcc"), J.gp(_s205["__p"]["TUNE"], "every"))
		J.sp(_t667, "spawnAcc", _t668)
		var _t669 = _s205["__p"]["makePerson"]
		v_P_470 = J.cl(_t669, null, [_s205["def"], v_m_465])
		var _t670 = (J.sub(J.gp(J.gp(_s205["def"], "seg"), 1.0), 40.0) if J.cmp(J.gp(_s205["def"], "dir"), 0.0, "<") else J.add(J.gp(J.gp(_s205["def"], "seg"), 0.0), 40.0))
		J.sp(v_P_470, "x", _t670)
		J.sp(v_P_470, "next", 0.0)
		var _t671 = _s205["__p"]["R"]
		var _t672 = J.cl(_t671, null, [150.0, 190.0])
		J.sp(v_P_470, "speed", _t672)
		var _t673 = J.gp(_s205["this"], "walkers")
		J.mc(_t673, "push", [v_P_470])
	var _t674 = J.gp(_s205["def"], "posts")
	v_order_466 = J.mc(_t674, "map", [Callable(self, "_f124").bind(_s205)])
	for _t675 in J.iter(J.gp(_s205["this"], "walkers")):
		v_P_473 = _t675
		var _s209 = {"__p": _s205, "i": null}
		if J.cmp(J.gp(v_P_473, "react"), 0.0, ">"):
			var _t676 = J.sub(J.gp(v_P_473, "react"), v_dt_463)
			J.sp(v_P_473, "react", _t676)
			continue
		var _t677 = J.gp(v_P_473, "done")
		if J.t((J.gp(v_P_473, "by") if J.t(_t677) else _t677)):
			var _t678 = J.add(J.gp(v_P_473, "x"), J.mul((J.mul(J.gp(_s209["__p"]["def"], "dir"), J.gp(v_P_473, "speed")) * 2.2), v_dt_463))
			J.sp(v_P_473, "x", _t678)
			J.sp(v_P_473, "flee", true)
			var _t679 = J.cmp(J.gp(_s209["__p"]["def"], "dir"), 0.0, "<")
			var _t681 = (J.cmp(J.gp(v_P_473, "x"), J.sub(J.gp(J.gp(_s209["__p"]["def"], "seg"), 0.0), 200.0), "<") if _t679 else _t679)
			if not J.t(_t681):
				var _t680 = J.cmp(J.gp(_s209["__p"]["def"], "dir"), 0.0, ">")
				_t681 = (J.cmp(J.gp(v_P_473, "x"), J.add(J.gp(J.gp(_s209["__p"]["def"], "seg"), 1.0), 200.0), ">") if _t680 else _t680)
			if _t681:
				J.sp(v_P_473, "gone", true)
			continue
		var _t682 = J.add(J.gp(v_P_473, "x"), J.mul(J.mul(J.gp(_s209["__p"]["def"], "dir"), J.gp(v_P_473, "speed")), v_dt_463))
		J.sp(v_P_473, "x", _t682)
		_s209["i"] = J.gp(v_order_466, J.gp(v_P_473, "next"))
		var _t686 = (not J.leq(_s209["i"], null))
		if J.t(_t686):
			var _t683 = J.cmp(J.gp(_s209["__p"]["def"], "dir"), 0.0, "<")
			var _t685 = (J.cmp(J.gp(v_P_473, "x"), J.gp(J.gp(J.gp(_s209["__p"]["def"], "posts"), _s209["i"]), "x"), "<=") if _t683 else _t683)
			if not J.t(_t685):
				var _t684 = J.cmp(J.gp(_s209["__p"]["def"], "dir"), 0.0, ">")
				_t685 = (J.cmp(J.gp(v_P_473, "x"), J.gp(J.gp(J.gp(_s209["__p"]["def"], "posts"), _s209["i"]), "x"), ">=") if _t684 else _t684)
			_t686 = _t685
		if _t686:
			var _s212 = {"__p": _s209, "px": null, "py": null, "h": null}
			var _t687 = J.gp(_s212["__p"]["__p"]["def"], "wait")
			var _t690 = (J.seq(_s212["__p"]["i"], 1.0) if J.t(_t687) else _t687)
			if J.t(_t690):
				var _t688 = J.gp(v_P_473, "wt")
				var _t689 = J.add((_t688 if J.t(_t688) else 0.0), 1.0)
				J.sp(v_P_473, "wt", _t689)
				_t690 = J.cmp(_t689, J.gp(_s212["__p"]["__p"]["def"], "wait"), "<")
			v_stay_475 = _t690
			if (not J.t(v_stay_475)):
				J.sp(v_P_473, "next", J.num(J.gp(v_P_473, "next")) + 1.0)
			var _t691 = _s212["__p"]["__p"]["__p"]["passPost"]
			v_res_476 = J.cl(_t691, null, [_s212["__p"]["__p"]["def"], v_m_465, _s212["__p"]["i"], v_P_473])
			if J.t(((not J.t(J.gp(v_P_473, "done"))) if J.t(v_stay_475) else v_stay_475)):
				var _t692 = J.gp(v_P_473, "react")
				var _t693 = J.gp(v_P_473, "react")
				var _t694 = J.max_([(_t693 if J.t(_t693) else 0.0), 2.4])
				J.sp(v_P_473, "react", _t694)
			if J.t(J.gp(v_P_473, "done")):
				var _t695 = _s212["__p"]["i"]
				J.sp(v_P_473, "atPost", _t695)
			var _t696 = J.mc(_s212["__p"]["__p"]["this"], "postXY", [_s212["__p"]["i"]])
			var _t697 = J.gp(_t696, 0.0)
			_s212["px"] = _t697
			var _t698 = J.gp(_t696, 1.0)
			_s212["py"] = _t698
			_s212["h"] = J.mc(_s212["__p"]["__p"]["this"], "personH", [])
			J.mc(v_res_476, "forEach", [Callable(self, "_f125").bind(_s212)])
			if J.t(J.len(v_res_476)):
				var _t702 = J.gp(v_P_473, "react")
				var _t703 = J.gp(v_P_473, "react")
				var _t704 = J.max_([(_t703 if J.t(_t703) else 0.0), 0.7])
				J.sp(v_P_473, "react", _t704)
				var _t705 = J.gp(_s212["__p"]["__p"]["this"], "t")
				J.sp(v_P_473, "scaredT", _t705)
			var _t706 = J.gp(v_P_473, "done")
			var _t707 = (J.seq(J.gp(v_P_473, "by"), 2.0) if J.t(_t706) else _t706)
			var _t708 = (J.len(v_res_476) if J.t(_t707) else _t707)
			var _t711 = (J.seq(J.gp(J.gp(v_res_476, (J.len(v_res_476) - 1.0)), "who"), 2.0) if J.t(_t708) else _t708)
			if J.t(_t711):
				var _t709 = J.gp(v_m_465, "posts")
				_t711 = J.mc(_t709, "some", [Callable(self, "_f126").bind(_s212)])
			if J.t(_t711):
				if (randf() < 0.35):
					var _t715 = _s212["px"]
					var _t716 = J.sub(_s212["py"], J.mul(_s212["h"], 1.6))
					var _t712 = _s212["__p"]["__p"]["__p"]["L"]
					var _t713 = _s212["__p"]["__p"]["__p"]["pick"]
					var _t714 = J.cl(_t712, null, [J.cl(_t713, null, [_s212["__p"]["__p"]["__p"]["BRYAN_LINES"]])])
					J.mc(_s212["__p"]["__p"]["this"], "float", [_t715, _t716, J.mc(_t714, "replace", [J.re("^Bryan：", ""), "Bryan："]), "#ff9a9a"])
		var _t717 = J.cmp(J.gp(_s209["__p"]["def"], "dir"), 0.0, "<")
		var _t719 = (J.cmp(J.gp(v_P_473, "x"), J.sub(J.gp(J.gp(_s209["__p"]["def"], "seg"), 0.0), 100.0), "<") if _t717 else _t717)
		if not J.t(_t719):
			var _t718 = J.cmp(J.gp(_s209["__p"]["def"], "dir"), 0.0, ">")
			_t719 = (J.cmp(J.gp(v_P_473, "x"), J.add(J.gp(J.gp(_s209["__p"]["def"], "seg"), 1.0), 100.0), ">") if _t718 else _t718)
		if _t719:
			if (not J.t(J.gp(v_P_473, "done"))):
				J.sp(v_P_473, "done", true)
				J.sp(v_P_473, "by", 0.0)
			J.sp(v_P_473, "gone", true)
		var _t720 = J.gp(v_P_473, "gone")
		if J.t(((not J.t(J.gp(v_P_473, "fin"))) if J.t(_t720) else _t720)):
			J.sp(v_P_473, "fin", true)
			var _t721 = _s209["__p"]["__p"]["finish"]
			J.cl(_t721, null, [_s209["__p"]["def"], v_m_465, v_P_473])
	var _t722 = _s205["this"]
	var _t723 = J.gp(_s205["this"], "walkers")
	var _t724 = J.mc(_t723, "filter", [Callable(self, "_f127").bind(_s205)])
	J.sp(_t722, "walkers", _t724)
	for _t725 in J.iter(J.gp(_s205["this"], "fx")):
		v_f_487 = _t725
		var _t726 = J.add(J.gp(v_f_487, "a"), v_dt_463)
		J.sp(v_f_487, "a", _t726)
	var _t727 = _s205["this"]
	var _t728 = J.gp(_s205["this"], "fx")
	var _t729 = J.mc(_t728, "filter", [Callable(self, "_f128").bind(_s205)])
	J.sp(_t727, "fx", _t729)
	var _t730 = _s205["__p"]["share"]
	v_s_467 = J.cl(_t730, null, [v_m_465])
	var _t731 = _s205["__p"]["status"]
	v_sta_468 = J.cl(_t731, null, [v_m_465])
	var _t732 = J.G.get("$")
	v_info_469 = J.cl(_t732, null, ["#stn-info"])
	var _t734 = v_info_469
	if J.t(_t734):
		var _t733 = (not J.t(J.gp(_s205["this"], "_it")))
		_t734 = (_t733 if _t733 else (J.sub(J.gp(_s205["this"], "t"), J.gp(_s205["this"], "_it")) > 0.5))
	if J.t(_t734):
		var _t735 = _s205["this"]
		var _t736 = J.gp(_s205["this"], "t")
		J.sp(_t735, "_it", _t736)
		var _t737 = (J.str(J.gp(v_sta_468, "t")) + ("　<em>地盤穩定</em>" if J.t(J.gp(v_m_465, "stable")) else ""))
		J.sp(v_info_469, "innerHTML", _t737)
		var _t738 = J.G.get("$")
		v_bd_489 = J.cl(_t738, null, ["#stn-board"])
		if J.t(v_bd_489):
			var _t744 = null
			if J.t(J.gp(v_m_465, "stable")):
				_t744 = "已穩定：固定產出，離線照算"
			else:
				var _t743 = null
				if J.t(J.gp(v_m_465, "stableAt")):
					_t743 = ("穩定倒數 " + J.str(J.max_([0.0, ceil(J.num(J.div((J.mul(J.gp(_s205["__p"]["TUNE"], "stableHours"), 3600000.0) - J.sub(J.S_Date_("now", []), J.gp(v_m_465, "stableAt"))), 3600000.0)))])) + " 小時")
				else:
					var _t742 = null
					if J.cmp(J.gp(v_m_465, "habit"), 10.0, ">="):
						var _t739 = _s205["__p"]["pct"]
						var _t741 = J.cl(_t739, null, [J.gp(_s205["__p"]["TUNE"], "stableRatio")])
						var _t740 = _s205["__p"]["pct"]
						_t742 = ("嚇破膽要 ≥" + J.str(_t741) + " 才開始計穩定（現在 " + J.str(J.cl(_t740, null, [J.gp(v_s_467, "me")])) + "）")
					else:
						_t742 = "見慣度到 10 才能穩定"
					_t743 = _t742
				_t744 = _t743
			v_stp_490 = _t744
			var _t745 = _s205["__p"]["pct"]
			var _t747 = J.cl(_t745, null, [J.gp(v_s_467, "me")])
			var _t746 = _s205["__p"]["pct"]
			var _t749 = J.cl(_t746, null, [J.gp(v_s_467, "en")])
			var _t748 = _s205["__p"]["pct"]
			var _t751 = J.cl(_t748, null, [J.gp(v_s_467, "me")])
			var _t750 = _s205["__p"]["pct"]
			var _t754 = ("<div class=\"stn-bar\"><i class=\"me\" style=\"width:" + J.str(_t747) + "\"></i><i class=\"en\" style=\"width:" + J.str(_t749) + "\"></i></div><div class=\"stn-bl\"><span class=\"me\">我方 " + J.str(_t751) + "</span><span class=\"en\">夜冷村 " + J.str(J.cl(_t750, null, [J.gp(v_s_467, "en")])) + "</span><span>最近 " + J.str(J.gp(v_s_467, "n")) + " 人</span></div>")
			var _t753 = J.mul(J.gp(v_m_465, "habit"), 10.0)
			var _t752 = J.gp(v_m_465, "habit")
			var _t760 = (_t754 + ("<div class=\"stn-hab\"><span>見慣度</span><div class=\"stn-hm\"><i style=\"width:" + J.str(_t753) + "%\"></i></div><b>" + J.str(J.mc(_t752, "toFixed", [1.0])) + "</b></div><small>" + J.str(v_stp_490) + "</small>"))
			var _t755 = J.gp(J.cl(_s205["__p"]["st"], null, []), "log")
			var _t757 = J.mc(_t755, "filter", [Callable(self, "_f129").bind(_s205)])
			var _t758 = J.mc(_t757, "slice", [0.0, 3.0])
			var _t759 = J.mc(_t758, "map", [Callable(self, "_f130").bind(_s205)])
			var _t761 = J.add(_t760, J.mc(_t759, "join", [""]))
			J.sp(v_bd_489, "innerHTML", _t761)

func _f131(this_, a: Array, env):
	var v_ctx_495 = null; var v_id_496 = null; var v_x_497 = null; var v_y_498 = null; var v_h_499 = null; var v_pose_500 = null; var v_right_501 = null; var v_alpha_502 = null; var v_ok_503 = null; var v_e_504 = null; var v_img_505 = null; var v_w_506 = null; var v_bob_507 = null
	v_ctx_495 = J.arg(a, 0)
	v_id_496 = J.arg(a, 1)
	v_x_497 = J.arg(a, 2)
	v_y_498 = J.arg(a, 3)
	v_h_499 = J.arg(a, 4)
	v_pose_500 = J.arg(a, 5)
	v_right_501 = J.arg(a, 6)
	v_alpha_502 = J.arg(a, 7)
	J.mc(v_ctx_495, "save", [])
	if (not J.leq(v_alpha_502, null)):
		J.sp(v_ctx_495, "globalAlpha", v_alpha_502)
	v_ok_503 = false
	var _t762 = env["has"]
	var _t763 = J.cl(_t762, null, [J.G.get("MeshAnim")])
	var _t764 = (J.gp(J.gp(J.G.get("MeshAnim"), "RIG"), v_id_496) if J.t(_t763) else _t763)
	var _t765 = (J.mc(J.G.get("MeshAnim"), "draw", [v_ctx_495, v_id_496, v_x_497, v_y_498, v_h_499, v_pose_500, v_right_501]) if J.t(_t764) else _t764)
	v_ok_503 = _t765
	if (not J.t(v_ok_503)):
		v_img_505 = J.gp(J.G.get("SPR"), v_id_496)
		if J.t(v_img_505):
			v_w_506 = J.div(J.mul(v_h_499, J.gp(v_img_505, "width")), J.gp(v_img_505, "height"))
			var _t766 = (J.gp(v_pose_500, "_bob") if J.t(v_pose_500) else v_pose_500)
			v_bob_507 = (_t766 if J.t(_t766) else 0.0)
			J.mc(v_ctx_495, "translate", [v_x_497, J.add(v_y_498, v_bob_507)])
			if (not J.t(v_right_501)):
				J.mc(v_ctx_495, "scale", [(-1.0), 1.0])
			J.mc(v_ctx_495, "drawImage", [v_img_505, J.div((-J.num(v_w_506)), 2.0), (-J.num(v_h_499)), v_w_506, v_h_499])
	J.mc(v_ctx_495, "restore", [])

func _f133(this_, a: Array, env):
	var v_p_526 = null; var v_i_527 = null; var v_px_528 = null; var v_py_529 = null; var v_gid_530 = null; var v_g_531 = null; var v_e_532 = null; var v_act_533 = null; var v_pose_534 = null; var v_mor_535 = null; var v_id_536 = null; var v_eh_537 = null
	v_p_526 = J.arg(a, 0)
	v_i_527 = J.arg(a, 1)
	var _t777 = J.mc(env["this"], "postXY", [v_i_527])
	var _t778 = J.gp(_t777, 0.0)
	v_px_528 = _t778
	var _t779 = J.gp(_t777, 1.0)
	v_py_529 = _t779
	var _t780 = J.cmp(v_px_528, (-J.num(env["h"])), "<")
	if (_t780 if _t780 else J.cmp(v_px_528, J.add(env["W0"], env["h"]), ">")):
		return null
	var _t781 = env["ctx"]
	J.sp(_t781, "fillStyle", "rgba(160,120,255,0.18)")
	J.mc(env["ctx"], "beginPath", [])
	J.mc(env["ctx"], "ellipse", [v_px_528, J.add(v_py_529, 4.0), J.mul(env["h"], 0.42), J.mul(env["h"], 0.07), 0.0, 0.0, (PI * 2.0)])
	J.mc(env["ctx"], "fill", [])
	var _t782 = env["ctx"]
	var _t783 = ("bold " + J.str(J.round(J.num(J.mul(env["h"], 0.075)))) + "px sans-serif")
	J.sp(_t782, "font", _t783)
	var _t784 = env["ctx"]
	J.sp(_t784, "textAlign", "center")
	var _t785 = env["ctx"]
	J.sp(_t785, "fillStyle", "#d9ccff")
	var _t786 = env["ctx"]
	J.sp(_t786, "strokeStyle", "rgba(0,0,0,.7)")
	var _t787 = env["ctx"]
	J.sp(_t787, "lineWidth", 3.0)
	J.mc(env["ctx"], "strokeText", [(J.str(J.add(v_i_527, 1.0)) + ". " + J.str(J.gp(v_p_526, "name"))), v_px_528, J.add(v_py_529, J.mul(env["h"], 0.17))])
	J.mc(env["ctx"], "fillText", [(J.str(J.add(v_i_527, 1.0)) + ". " + J.str(J.gp(v_p_526, "name"))), v_px_528, J.add(v_py_529, J.mul(env["h"], 0.17))])
	v_gid_530 = J.gp(J.gp(env["m"], "posts"), v_i_527)
	var _t789 = null
	if (not J.leq(v_gid_530, null)):
		var _t788 = env["__p"]["ghost"]
		_t789 = J.cl(_t788, null, [v_gid_530])
	else:
		_t789 = null
	v_g_531 = _t789
	if J.t(v_g_531):
		var _t790 = J.gp(v_g_531, "_act")
		v_act_533 = ((J.sub(env["t"], J.gp(v_g_531, "_act")) < 0.8) if J.t(_t790) else _t790)
		var _t793 = null
		if J.t(v_act_533):
			var _t791 = J.gp(J.G.get("MeshAnim"), "ANIM")
			_t793 = J.mc(_t791, "attack", [((J.sub(env["t"], J.gp(v_g_531, "_act")) * 1.4) + 0.5)])
		else:
			var _t792 = J.gp(J.G.get("MeshAnim"), "ANIM")
			_t793 = J.mc(_t792, "idle", [J.add(env["t"], v_i_527)])
		v_pose_534 = _t793
		J.mc(env["this"], "drawChar", [env["ctx"], J.gp(v_g_531, "k"), J.sub(v_px_528, J.mul(env["h"], 0.18)), (J.sub(v_py_529, J.mul(env["h"], 0.05)) + (sin(J.num(J.add(J.mul(env["t"], 2.0), v_i_527))) * 3.0)), J.mul(env["h"], 0.82), v_pose_534, true, 0.85])
		v_mor_535 = (100.0 if J.leq(J.gp(J.gp(env["m"], "morale"), v_gid_530), null) else J.gp(J.gp(env["m"], "morale"), v_gid_530))
		var _t794 = env["ctx"]
		J.sp(_t794, "fillStyle", "rgba(0,0,0,.55)")
		J.mc(env["ctx"], "fillRect", [J.sub(v_px_528, J.mul(env["h"], 0.4)), J.sub(v_py_529, J.mul(env["h"], 1.02)), J.mul(env["h"], 0.44), 6.0])
		var _t795 = env["ctx"]
		var _t796 = ("#7be08a" if J.cmp(v_mor_535, 40.0, ">") else "#ff7070")
		J.sp(_t795, "fillStyle", _t796)
		J.mc(env["ctx"], "fillRect", [J.sub(v_px_528, J.mul(env["h"], 0.4)), J.sub(v_py_529, J.mul(env["h"], 1.02)), J.div(J.mul(J.mul(env["h"], 0.44), v_mor_535), 100.0), 6.0])
		if J.t(J.gp(J.gp(env["m"], "boost"), v_i_527)):
			var _t797 = env["ctx"]
			J.sp(_t797, "fillStyle", "#ffb347")
			J.mc(env["ctx"], "fillText", ["大招", J.sub(v_px_528, J.mul(env["h"], 0.18)), J.sub(v_py_529, J.mul(env["h"], 1.08))])
	v_e_532 = J.gp(J.gp(env["m"], "enemy"), v_i_527)
	if J.t(v_e_532):
		v_id_536 = ("npc_rival" if J.seq(J.gp(v_e_532, "k"), "bryan") else J.gp(v_e_532, "k"))
		v_eh_537 = (J.mul(env["h"], 0.95) if J.seq(J.gp(v_e_532, "k"), "bryan") else J.mul(env["h"], 0.72))
		var _t799 = env["ctx"]
		var _t800 = J.add(v_px_528, J.mul(env["h"], 0.32))
		var _t801 = (J.sub(v_py_529, J.mul(env["h"], 0.04)) + (sin(J.num((J.mul(env["t"], 2.4) + J.mul(v_i_527, 2.0)))) * 3.0))
		var _t798 = J.gp(J.G.get("MeshAnim"), "ANIM")
		J.mc(env["this"], "drawChar", [_t799, v_id_536, _t800, _t801, v_eh_537, J.mc(_t798, "idle", [J.add(J.mul(env["t"], 1.2), v_i_527)]), false, (1.0 if J.seq(J.gp(v_e_532, "k"), "bryan") else 0.85)])
		var _t802 = env["ctx"]
		J.sp(_t802, "fillStyle", "rgba(0,0,0,.55)")
		J.mc(env["ctx"], "fillRect", [J.add(v_px_528, J.mul(env["h"], 0.12)), J.sub(v_py_529, J.mul(env["h"], 1.02)), J.mul(env["h"], 0.4), 6.0])
		var _t803 = env["ctx"]
		J.sp(_t803, "fillStyle", "#ff6a6a")
		J.mc(env["ctx"], "fillRect", [J.add(v_px_528, J.mul(env["h"], 0.12)), J.sub(v_py_529, J.mul(env["h"], 1.02)), J.div((J.mul(env["h"], 0.4) * J.max_([0.0, J.gp(v_e_532, "hp")])), (220.0 if J.seq(J.gp(v_e_532, "k"), "bryan") else 100.0)), 6.0])
		var _t804 = env["ctx"]
		J.sp(_t804, "fillStyle", "#ffb0b0")
		J.mc(env["ctx"], "strokeText", [("夜冷村・" + J.str(J.gp(env["__p"]["RNAME"], J.gp(v_e_532, "k")))), J.add(v_px_528, J.mul(env["h"], 0.32)), J.sub(v_py_529, J.mul(env["h"], 1.08))])
		J.mc(env["ctx"], "fillText", [("夜冷村・" + J.str(J.gp(env["__p"]["RNAME"], J.gp(v_e_532, "k")))), J.add(v_px_528, J.mul(env["h"], 0.32)), J.sub(v_py_529, J.mul(env["h"], 1.08))])

func _f134(this_, a: Array, env):
	var v_a_538 = null; var v_b_539 = null
	v_a_538 = J.arg(a, 0)
	v_b_539 = J.arg(a, 1)
	return J.sub(J.gp(v_a_538, "x"), J.gp(v_b_539, "x"))

func _f135(this_, a: Array, env):
	var v_k_548 = null
	v_k_548 = J.arg(a, 0)
	return J.gp(env["__p"]["W"], v_k_548)

func _f132(this_, a: Array, env):
	var v_def_511 = null; var v_H0_514 = null; var v_img_515 = null; var v_sc_516 = null; var v_T_517 = null; var v_BH_518 = null; var v_y0_520 = null; var v_sorted_522 = null; var v_g_523 = null; var v_sx_524 = null; var v_sw_525 = null; var v_P_540 = null; var v_x_541 = null; var v_scared_542 = null; var v_right_543 = null; var v_pose_544 = null; var v_fw_545 = null; var v_fy_546 = null; var v_lab_547 = null; var v_f_549 = null; var v_a_550 = null; var v_y_551 = null
	var _s234 = {"__p": env, "this": null, "ctx": null, "m": null, "W0": null, "h": null, "t": null}
	_s234["this"] = this_
	_s234["ctx"] = J.gp(_s234["this"], "ctx")
	v_def_511 = J.gp(_s234["this"], "def")
	var _t767 = _s234["__p"]["ms"]
	_s234["m"] = J.cl(_t767, null, [J.gp(v_def_511, "id")])
	_s234["W0"] = J.gp(_s234["this"], "W")
	v_H0_514 = J.gp(_s234["this"], "H")
	v_img_515 = J.mc(_s234["this"], "img", [])
	v_sc_516 = J.mc(_s234["this"], "sc", [])
	v_T_517 = J.mc(_s234["this"], "top", [])
	v_BH_518 = J.mc(_s234["this"], "bgH", [])
	var _t768 = (not J.t(J.gp(_s234["this"], "_sky")))
	if (_t768 if _t768 else (not J.seq(J.gp(J.gp(_s234["this"], "_sky"), "h"), v_H0_514))):
		v_g_523 = J.mc(_s234["ctx"], "createLinearGradient", [0.0, 0.0, 0.0, v_H0_514])
		J.mc(v_g_523, "addColorStop", [0.0, "#0b0818"])
		J.mc(v_g_523, "addColorStop", [0.5, "#1c1430"])
		J.mc(v_g_523, "addColorStop", [1.0, "#100b1c"])
		var _t769 = _s234["this"]
		var _t770 = {"g": v_g_523, "h": v_H0_514}
		J.sp(_t769, "_sky", _t770)
	var _t771 = _s234["ctx"]
	var _t772 = J.gp(J.gp(_s234["this"], "_sky"), "g")
	J.sp(_t771, "fillStyle", _t772)
	J.mc(_s234["ctx"], "fillRect", [0.0, 0.0, _s234["W0"], v_H0_514])
	if J.t(v_img_515):
		v_sx_524 = J.add(J.gp(J.gp(v_def_511, "seg"), 0.0), J.div(J.gp(_s234["this"], "camX"), v_sc_516))
		v_sw_525 = J.div(_s234["W0"], v_sc_516)
		J.mc(_s234["ctx"], "drawImage", [v_img_515, v_sx_524, 0.0, v_sw_525, J.gp(v_img_515, "height"), 0.0, v_T_517, _s234["W0"], v_BH_518])
	var _t773 = _s234["ctx"]
	J.sp(_t773, "fillStyle", "rgba(40,20,80,0.22)")
	J.mc(_s234["ctx"], "fillRect", [0.0, v_T_517, _s234["W0"], v_BH_518])
	var _t774 = _s234["ctx"]
	J.sp(_t774, "fillStyle", "#2a1f3d")
	J.mc(_s234["ctx"], "fillRect", [0.0, J.add(v_T_517, v_BH_518), _s234["W0"], J.sub(J.sub(v_H0_514, v_T_517), v_BH_518)])
	var _t775 = _s234["ctx"]
	J.sp(_t775, "fillStyle", "rgba(0,0,0,.35)")
	J.mc(_s234["ctx"], "fillRect", [0.0, J.add(v_T_517, v_BH_518), _s234["W0"], 3.0])
	_s234["h"] = J.mc(_s234["this"], "personH", [])
	v_y0_520 = J.add(v_T_517, J.mul(v_BH_518, J.gp(v_def_511, "walkY")))
	_s234["t"] = J.gp(_s234["this"], "t")
	var _t776 = J.gp(v_def_511, "posts")
	J.mc(_t776, "forEach", [Callable(self, "_f133").bind(_s234)])
	var _t805 = J.mc(J.gp(_s234["this"], "walkers"), "slice", [])
	v_sorted_522 = J.mc(_t805, "sort", [Callable(self, "_f134").bind(_s234)])
	for _t806 in J.iter(v_sorted_522):
		v_P_540 = _t806
		v_x_541 = J.mc(_s234["this"], "sx", [J.gp(v_P_540, "x")])
		var _t807 = J.cmp(v_x_541, (-J.num(_s234["h"])), "<")
		if (_t807 if _t807 else J.cmp(v_x_541, J.add(_s234["W0"], _s234["h"]), ">")):
			continue
		var _t808 = (not J.leq(J.gp(v_P_540, "scaredT"), null))
		v_scared_542 = ((J.sub(_s234["t"], J.gp(v_P_540, "scaredT")) < 0.8) if _t808 else _t808)
		v_right_543 = (J.cmp(J.gp(v_def_511, "dir"), 0.0, ">") if J.t(J.gp(v_P_540, "flee")) else J.cmp(J.gp(v_def_511, "dir"), 0.0, ">"))
		var _t811 = null
		if J.t(v_scared_542):
			var _t809 = J.gp(J.G.get("MeshAnim"), "ANIM")
			_t811 = J.mc(_t809, "scared", [J.sub(_s234["t"], J.gp(v_P_540, "scaredT"))])
		else:
			var _t810 = J.gp(J.G.get("MeshAnim"), "ANIM")
			_t811 = J.mc(_t810, "walk", [J.add(J.mul(_s234["t"], (1.8 if J.t(J.gp(v_P_540, "flee")) else 1.0)), J.gp(v_P_540, "hp"))])
		v_pose_544 = _t811
		var _t812 = ((-8.0) if J.t(v_scared_542) else (absf(J.num(sin(J.num(J.add(J.mul(_s234["t"], 7.0), J.gp(v_P_540, "hp")))))) * (-3.0)))
		J.sp(v_pose_544, "_bob", _t812)
		J.mc(_s234["this"], "drawChar", [_s234["ctx"], J.gp(v_P_540, "spr"), v_x_541, J.add(v_y0_520, 6.0), _s234["h"], v_pose_544, v_right_543])
		v_fw_545 = J.mul(_s234["h"], 0.5)
		v_fy_546 = J.sub(v_y0_520, J.mul(_s234["h"], 1.08))
		var _t813 = _s234["ctx"]
		J.sp(_t813, "fillStyle", "rgba(0,0,0,.55)")
		J.mc(_s234["ctx"], "fillRect", [J.sub(v_x_541, J.div(v_fw_545, 2.0)), v_fy_546, v_fw_545, 7.0])
		var _t814 = _s234["ctx"]
		var _t815 = ("#ffe066" if J.cmp(J.gp(v_P_540, "fear"), J.gp(v_P_540, "hp"), ">=") else "#c58bff")
		J.sp(_t814, "fillStyle", _t815)
		J.mc(_s234["ctx"], "fillRect", [J.sub(v_x_541, J.div(v_fw_545, 2.0)), v_fy_546, J.mul(v_fw_545, J.min_([1.0, J.div(J.gp(v_P_540, "fear"), J.gp(v_P_540, "hp"))])), 7.0])
		var _t816 = _s234["ctx"]
		var _t817 = (J.str(J.round(J.num(J.mul(_s234["h"], 0.07)))) + "px sans-serif")
		J.sp(_t816, "font", _t817)
		var _t818 = _s234["ctx"]
		J.sp(_t818, "textAlign", "center")
		var _t819 = _s234["ctx"]
		J.sp(_t819, "lineWidth", 3.0)
		var _t820 = _s234["ctx"]
		J.sp(_t820, "strokeStyle", "rgba(0,0,0,.75)")
		var _t824 = null
		if J.t(J.gp(v_P_540, "flee")):
			_t824 = ("被夜冷村嚇走" if J.seq(J.gp(v_P_540, "by"), 2.0) else "嚇破膽！")
		else:
			var _t823 = J.gp(v_P_540, "name")
			var _t821 = J.gp(v_P_540, "weak")
			var _t822 = J.mc(_t821, "map", [Callable(self, "_f135").bind(_s234)])
			_t824 = (J.str(_t823) + "　怕" + J.str(J.mc(_t822, "join", ["、"])) + (("　要" + J.str(J.gp(v_P_540, "tough")) + "連嚇") if J.cmp(J.gp(v_P_540, "tough"), 1.0, ">") else ""))
		v_lab_547 = _t824
		var _t825 = _s234["ctx"]
		var _t826 = (("#ff8a8a" if J.seq(J.gp(v_P_540, "by"), 2.0) else "#ffe066") if J.t(J.gp(v_P_540, "flee")) else "#fff")
		J.sp(_t825, "fillStyle", _t826)
		J.mc(_s234["ctx"], "strokeText", [v_lab_547, v_x_541, J.sub(v_fy_546, 6.0)])
		J.mc(_s234["ctx"], "fillText", [v_lab_547, v_x_541, J.sub(v_fy_546, 6.0)])
	for _t827 in J.iter(J.gp(_s234["this"], "fx")):
		v_f_549 = _t827
		v_a_550 = J.max_([0.0, (1.0 - J.div(J.gp(v_f_549, "a"), 2.2))])
		var _t828 = _s234["ctx"]
		J.sp(_t828, "globalAlpha", v_a_550)
		var _t829 = _s234["ctx"]
		var _t830 = ("bold " + J.str(J.round(J.num(J.mul(_s234["h"], 0.085)))) + "px sans-serif")
		J.sp(_t829, "font", _t830)
		var _t831 = _s234["ctx"]
		J.sp(_t831, "textAlign", "center")
		var _t832 = _s234["ctx"]
		J.sp(_t832, "lineWidth", 4.0)
		var _t833 = _s234["ctx"]
		J.sp(_t833, "strokeStyle", "rgba(0,0,0,.8)")
		var _t834 = _s234["ctx"]
		var _t835 = J.gp(v_f_549, "c")
		J.sp(_t834, "fillStyle", _t835)
		v_y_551 = J.sub(J.gp(v_f_549, "y"), J.mul(J.gp(v_f_549, "a"), 28.0))
		J.mc(_s234["ctx"], "strokeText", [J.gp(v_f_549, "t"), J.gp(v_f_549, "x"), v_y_551])
		J.mc(_s234["ctx"], "fillText", [J.gp(v_f_549, "t"), J.gp(v_f_549, "x"), v_y_551])
	var _t836 = _s234["ctx"]
	J.sp(_t836, "globalAlpha", 1.0)

func _f1(this_, a: Array, env):
	var v_brokeRatio_31 = null; var v_entryHTML_58 = null; var v_init_61 = null
	var _s2 = {"__p": env, "has": null, "R": null, "pick": null, "W": null, "TYPES": null, "TUNE": null, "MAPS": null, "mapOf": null, "open": null, "RIVALS": null, "RNAME": null, "BRYAN_LINES": null, "D": null, "L": null, "LEGEND": null, "LEG_N": null, "LEG_T": null, "legendName": null, "SKIT": null, "skitFor": null, "st": null, "ms": null, "ghost": null, "typesOf": null, "drillLv": null, "rivalType": null, "power": null, "rivalPower": null, "share": null, "status": null, "adapt": null, "legLv": null, "makePerson": null, "strike": null, "passPost": null, "finish": null, "simOne": null, "rivalStep": null, "log": null, "stableStep": null, "payStep": null, "legendStep": null, "validate": null, "tick": null, "assign": null, "freeGhosts": null, "hitRival": null, "boost": null, "pct": null, "mapCard": null, "panelHTML": null, "pickHTML": null, "openPanel": null, "drawPors": null, "bind": null, "Live": null, "testHook": null}
	_s2["skitFor"] = Callable(self, "_f13").bind(_s2)
	_s2["st"] = Callable(self, "_f14").bind(_s2)
	_s2["typesOf"] = Callable(self, "_f20").bind(_s2)
	_s2["drillLv"] = Callable(self, "_f21").bind(_s2)
	_s2["rivalType"] = Callable(self, "_f22").bind(_s2)
	_s2["power"] = Callable(self, "_f23").bind(_s2)
	_s2["rivalPower"] = Callable(self, "_f24").bind(_s2)
	_s2["status"] = Callable(self, "_f27").bind(_s2)
	_s2["adapt"] = Callable(self, "_f28").bind(_s2)
	_s2["legLv"] = Callable(self, "_f30").bind(_s2)
	_s2["makePerson"] = Callable(self, "_f31").bind(_s2)
	_s2["strike"] = Callable(self, "_f33").bind(_s2)
	_s2["passPost"] = Callable(self, "_f34").bind(_s2)
	_s2["finish"] = Callable(self, "_f35").bind(_s2)
	_s2["simOne"] = Callable(self, "_f37").bind(_s2)
	_s2["rivalStep"] = Callable(self, "_f39").bind(_s2)
	_s2["log"] = Callable(self, "_f51").bind(_s2)
	_s2["stableStep"] = Callable(self, "_f52").bind(_s2)
	_s2["payStep"] = Callable(self, "_f53").bind(_s2)
	_s2["legendStep"] = Callable(self, "_f55").bind(_s2)
	_s2["validate"] = Callable(self, "_f56").bind(_s2)
	_s2["tick"] = Callable(self, "_f58").bind(_s2)
	_s2["assign"] = Callable(self, "_f62").bind(_s2)
	_s2["freeGhosts"] = Callable(self, "_f64").bind(_s2)
	_s2["hitRival"] = Callable(self, "_f66").bind(_s2)
	_s2["boost"] = Callable(self, "_f70").bind(_s2)
	_s2["mapCard"] = Callable(self, "_f72").bind(_s2)
	_s2["panelHTML"] = Callable(self, "_f75").bind(_s2)
	_s2["pickHTML"] = Callable(self, "_f78").bind(_s2)
	_s2["openPanel"] = Callable(self, "_f82").bind(_s2)
	_s2["drawPors"] = Callable(self, "_f85").bind(_s2)
	_s2["bind"] = Callable(self, "_f86").bind(_s2)
	v_entryHTML_58 = Callable(self, "_f98").bind(_s2)
	_s2["testHook"] = Callable(self, "_f136").bind(_s2)
	v_init_61 = Callable(self, "_f144").bind(_s2)
	_s2["has"] = Callable(self, "_f2").bind(_s2)
	_s2["R"] = Callable(self, "_f3").bind(_s2)
	_s2["pick"] = Callable(self, "_f4").bind(_s2)
	_s2["W"] = {"steal": "偷錢", "breath": "吹氣", "light": "燈", "cold": "凍", "sound": "怪聲", "paper": "紙", "phone": "電話", "face": "鬼臉", "shadow": "黑影"}
	var _t511 = J.S_Object_("keys", [_s2["W"]])
	_s2["TYPES"] = J.mc(_t511, "filter", [Callable(self, "_f5").bind(_s2)])
	_s2["TUNE"] = {"every": 8.0, "hp0": 60.0, "hpLv": 15.0, "habitUp": 0.03, "habitSeen": 0.004, "stableRatio": 0.7, "stableHours": 24.0, "failRatio": 0.4, "morale": 100.0, "harass": 4.0, "raidMin": 25.0, "raidMax": 45.0, "bryanH": 6.0, "offlineCap": 8.0}
	_s2["MAPS"] = [{"id": "office", "name": "舊公司・二十三樓", "short": "舊公司", "bg": "bg_office_pano", "seg": [3232.0, 7628.0], "walkY": 0.8, "dir": (-1.0), "need": "ch1_end", "desc": "加班仔收工、IT 值夜、阿姨倒垃圾，全部經茶水間、工位走道行去電梯。", "posts": [{"x": 6890.0, "name": "茶水間", "fit": "cold"}, {"x": 6300.0, "name": "影印機", "fit": "paper"}, {"x": 5300.0, "name": "工位走道", "fit": "light"}, {"x": 3700.0, "name": "電梯口", "fit": "sound"}], "people": [{"spr": "npc_ken", "name": "加班仔", "weak": ["phone", "face", "paper"], "imm": ["light", "cold"]}, {"spr": "npc_it", "name": "IT 值夜", "weak": ["phone", "sound", "shadow"], "imm": ["light", "paper"]}, {"spr": "npc_auntie", "name": "清潔阿姨", "weak": ["face", "shadow", "breath"], "imm": ["sound", "cold"]}, {"spr": "npc_mis", "name": "前台秘書", "weak": ["face", "cold", "shadow"], "imm": ["phone", "paper"]}, {"spr": "npc_boss", "name": "老闆", "weak": ["phone", "paper", "breath"], "imm": ["face", "shadow"]}]}, {"id": "flat", "name": "組屋走廊", "short": "組屋", "bg": "st_flat", "seg": [0.0, 1536.0], "walkY": 0.84, "dir": 1.0, "need": "ch1_end", "easy": 0.85, "desc": "夜歸上班族、倒垃圾的阿姨、打遊戲的學生。路人膽子小，入門地圖。", "posts": [{"x": 230.0, "name": "電梯口", "fit": "sound"}, {"x": 430.0, "name": "垃圾槽", "fit": "shadow"}, {"x": 820.0, "name": "住戶門口", "fit": "face"}, {"x": 1300.0, "name": "樓梯間", "fit": "breath"}], "people": [{"spr": "npc_ken", "name": "夜歸上班族", "weak": ["phone", "face", "shadow"], "imm": ["light", "cold"]}, {"spr": "npc_auntie", "name": "倒垃圾阿姨", "weak": ["face", "shadow", "breath"], "imm": ["sound", "cold"]}, {"spr": "npc_it", "name": "打機學生", "weak": ["sound", "shadow", "cold"], "imm": ["phone", "light"]}]}, {"id": "bus", "name": "巴士站", "short": "巴士站", "bg": "st_bus", "seg": [0.0, 1536.0], "walkY": 0.84, "dir": 1.0, "need": "ch1_end", "wait": 2.0, "desc": "等末班車的人會停很久：站牌那個崗位會重複嚇同一個人。", "posts": [{"x": 250.0, "name": "路燈下", "fit": "light"}, {"x": 700.0, "name": "站牌後", "fit": "paper"}, {"x": 1150.0, "name": "草叢", "fit": "sound"}], "people": [{"spr": "npc_ken", "name": "等末班車的上班族", "weak": ["phone", "breath", "paper"], "imm": ["light", "face"]}, {"spr": "npc_mis", "name": "夜歸女子", "weak": ["sound", "cold", "shadow"], "imm": ["phone", "paper"]}, {"spr": "npc_boss", "name": "等司機的老闆", "weak": ["phone", "paper", "shadow"], "imm": ["face", "sound"]}]}]
	_s2["mapOf"] = Callable(self, "_f6").bind(_s2)
	_s2["open"] = Callable(self, "_f8").bind(_s2)
	_s2["RIVALS"] = ["youhun", "egui", "xiaogui", "zombie", "zhiren", "shuigui", "niutou", "mamian"]
	_s2["RNAME"] = {"youhun": "遊魂", "egui": "餓鬼", "xiaogui": "小鬼", "zombie": "殭屍", "zhiren": "紙人", "shuigui": "水鬼", "niutou": "牛頭", "mamian": "馬面", "bryan": "Bryan"}
	_s2["BRYAN_LINES"] = ["Bryan：「呢個客係我嚇走嘅，你哋唔好亂講。」", "Bryan：「你嗰度啲人怕咩，我全部抄低咗。多謝分享。」", "Bryan：「籃球拍一下，成條走廊都靜晒。學下啦。」", "Bryan：「功勞唔使分，我攞晒就得。」"]
	_s2["D"] = Callable(self, "_f9").bind(_s2)
	J.mc(_s2["BRYAN_LINES"], "forEach", [Callable(self, "_f10").bind(_s2)])
	_s2["L"] = Callable(self, "_f11").bind(_s2)
	_s2["LEGEND"] = {"afu": "半夜亮著燈的空工位", "tianhua": "天花板上的女人", "eguiking": "收攤後的開飯鈴", "laojiang": "走廊一跳一跳的影子", "xiaozhi": "門縫下的紙人", "pontianak": "窗外的笑聲", "penanggal": "窗外飄過的頭", "toyol": "錢包少了錢"}
	_s2["LEG_N"] = [50.0, 200.0, 600.0]
	_s2["LEG_T"] = ["", "傳聞", "都市傳說", "經典"]
	_s2["legendName"] = Callable(self, "_f12").bind(_s2)
	var _t525 = _s2["D"]
	var _t527 = ["旁白", J.cl(_t525, null, ["組屋群組有人貼咗張相：走廊天花板，一束長頭髮垂落嚟。", "組屋群組有人貼了一張相片：走廊天花板，一束長頭髮垂下來。"])]
	var _t526 = _s2["D"]
	var _t529 = ["天花姐", J.cl(_t526, null, ["影到我好肥喎。邊個影㗎？叫佢刪咗佢。", "把我拍得好胖。誰拍的？叫他刪掉。"])]
	var _t528 = _s2["D"]
	var _t535 = [_t527, _t529, ["天花姐", J.cl(_t528, null, ["……算啦，留住佢。最少有人記得我。", "……算了，留著吧。至少有人記得我。"])]]
	var _t530 = _s2["D"]
	var _t532 = ["旁白", J.cl(_t530, null, ["公司 IT 部收到投訴：二十三樓有部電腦，每晚三點自己開機，打一句「好的老闆，收到」。", "公司 IT 部收到投訴：二十三樓有一部電腦，每晚三點自己開機，打一句「好的老闆，收到」。"])]
	var _t531 = _s2["D"]
	var _t534 = ["阿福", J.cl(_t531, null, ["我淨係想交埋份報告先走。", "我只是想把報告交了再走。"])]
	var _t533 = _s2["D"]
	var _t541 = [_t532, _t534, ["旁白", J.cl(_t533, null, ["份報告冇人收。但成間公司都記得咗佢個名。", "那份報告沒有人收。但整間公司都記住了他的名字。"])]]
	var _t536 = _s2["D"]
	var _t538 = ["旁白", J.cl(_t536, null, ["保安巡樓報告：「凌晨兩點，閉路電視見到有人跳過走廊。追出去，乜都冇。」", "保安巡樓報告：「凌晨兩點，監控看到有人跳過走廊。追出去，什麼都沒有。」"])]
	var _t537 = _s2["D"]
	var _t540 = ["老殭", J.cl(_t537, null, ["我唔係跳，我係行。行咗兩百年都係咁行。", "我不是跳，我是走。走了兩百年都是這樣走。"])]
	var _t539 = _s2["D"]
	var _t547 = [_t538, _t540, ["老殭", J.cl(_t539, null, ["叫我都市傳說？好過叫我老人家。", "叫我都市傳說？總比叫我老人家好。"])]]
	var _t542 = _s2["D"]
	var _t544 = ["旁白", J.cl(_t542, null, ["夜市攤主互相提醒：「收檔數錢記住數兩次，聽講有細路仔偷錢。」", "夜市攤主互相提醒：「收攤數錢記得數兩次，聽說有小孩偷錢。」"])]
	var _t543 = _s2["D"]
	var _t546 = ["Toyol", J.cl(_t543, null, ["我淨係攞散紙！大紙我唔郁㗎！", "我只拿零錢！大鈔我不碰的！"])]
	var _t545 = _s2["D"]
	var _t551 = [_t544, _t546, ["Toyol", J.cl(_t545, null, ["……今晚郁咗少少啫。", "……今晚碰了一點點而已。"])]]
	var _t548 = _s2["D"]
	var _t550 = ["旁白", J.cl(_t548, null, ["夜市後巷傳開：「收檔之後聽到有人敲碗，敲足成條巷。」", "夜市後巷傳開了：「收攤之後聽到有人敲碗，敲遍整條巷子。」"])]
	var _t549 = _s2["D"]
	var _t555 = [_t550, ["餓鬼王", J.cl(_t549, null, ["敲碗係禮貌嚟㗎，即係話我想開飯。", "敲碗是禮貌，意思是我想開飯了。"])]]
	var _t552 = _s2["D"]
	var _t554 = ["旁白", J.cl(_t552, null, ["網上有人發帖：「半夜聽到窗外有女人笑，笑完之後好香。」", "網上有人發帖：「半夜聽到窗外有女人在笑，笑完之後好香。」"])]
	var _t553 = _s2["D"]
	var _t559 = [_t554, ["Pontianak", J.cl(_t553, null, ["香？我今晚噴咗新香水。佢哋識貨。", "香？我今晚噴了新的香水。他們識貨。"])]]
	var _t556 = _s2["D"]
	var _t558 = ["旁白", J.cl(_t556, null, ["住戶投訴：「門縫底下成日塞咗張紙公仔入嚟，對住我笑。」", "住戶投訴：「門縫底下常常塞進來一張紙人，對著我笑。」"])]
	var _t557 = _s2["D"]
	_s2["SKIT"] = {"tianhua": _t535, "afu": _t541, "laojiang": _t547, "toyol": _t551, "eguiking": _t555, "pontianak": _t559, "xiaozhi": [_t558, ["小紙", J.cl(_t557, null, ["我唔係塞入嚟，我係自己行入嚟。好大分別。", "我不是被塞進來，我是自己走進來的。差很多。"])]]}
	_s2["ms"] = Callable(self, "_f17").bind(_s2)
	_s2["ghost"] = Callable(self, "_f18").bind(_s2)
	_s2["share"] = Callable(self, "_f25").bind(_s2)
	v_brokeRatio_31 = Callable(self, "_f26").bind(_s2)
	_s2["pct"] = Callable(self, "_f71").bind(_s2)
	_s2["Live"] = {"on": false, "def": null, "cv": null, "ctx": null, "camX": 0.0, "last": 0.0, "walkers": [], "fx": [], "spawnAcc": 0.0, "raf": 0.0, "open": Callable(self, "_f101").bind(_s2), "close": Callable(self, "_f104").bind(_s2), "resize": Callable(self, "_f105").bind(_s2), "img": Callable(self, "_f106").bind(_s2), "bgH": Callable(self, "_f107").bind(_s2), "top": Callable(self, "_f108").bind(_s2), "sc": Callable(self, "_f109").bind(_s2), "maxCam": Callable(self, "_f110").bind(_s2), "sx": Callable(self, "_f111").bind(_s2), "personH": Callable(self, "_f112").bind(_s2), "bindPan": Callable(self, "_f113").bind(_s2), "postXY": Callable(self, "_f118").bind(_s2), "tap": Callable(self, "_f119").bind(_s2), "float": Callable(self, "_f120").bind(_s2), "frame": Callable(self, "_f121").bind(_s2), "step": Callable(self, "_f123").bind(_s2), "drawChar": Callable(self, "_f131").bind(_s2), "draw": Callable(self, "_f132").bind(_s2)}
	return {"MAPS": _s2["MAPS"], "TUNE": _s2["TUNE"], "st": _s2["st"], "ms": _s2["ms"], "tick": _s2["tick"], "simOne": _s2["simOne"], "assign": _s2["assign"], "hitRival": _s2["hitRival"], "boost": _s2["boost"], "share": _s2["share"], "status": _s2["status"], "openPanel": _s2["openPanel"], "entryHTML": v_entryHTML_58, "panelHTML": _s2["panelHTML"], "Live": _s2["Live"], "init": v_init_61, "power": _s2["power"], "freeGhosts": _s2["freeGhosts"], "legLv": _s2["legLv"], "mapOf": _s2["mapOf"], "open": _s2["open"]}

func _f147(this_, a: Array, env):
	var v_stationBoot_577 = null; var v_e_578 = null
	v_stationBoot_577 = Callable(self, "_f147").bind(env)
	var _t837 = J.seq(J.typeof_(J.G.get("S")), "undefined")
	var _t838 = (_t837 if _t837 else (not J.t(J.G.get("S"))))
	var _t839 = (_t838 if _t838 else (not J.t(J.gp(J.G.get("S"), "ghosts"))))
	if (_t839 if _t839 else J.seq(J.typeof_(J.G.get("UI")), "undefined")):
		J.F_setTimeout([v_stationBoot_577, 300.0])
		return null
	J.mc(J.G.get("Station"), "init", [])
