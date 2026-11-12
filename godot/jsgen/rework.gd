# 自動轉譯自 rework.js（tools/jsgd.js）——唔好直接改，改原 JS 再轉
extends RefCounted

func run(env):
	var this_ = null; var a = []
	J.G["Rework"] = J.cl(Callable(self, "_f1").bind(env), null, [])

func _f4(this_, a: Array, env):
	var v_s_44 = null; var v_h_45 = null; var v_c_46 = null
	v_s_44 = J.arg(a, 0)
	v_h_45 = 2166136261.0
	for _t1 in J.iter(v_s_44):
		v_c_46 = _t1
		var _t2 = J.bxor(v_h_45, J.mc(v_c_46, "charCodeAt", [0.0]))
		v_h_45 = _t2
		var _t3 = J.math("imul", [v_h_45, 16777619.0])
		v_h_45 = _t3
	return J.ushr(v_h_45, 0.0)

func _f5(this_, a: Array, env):
	var v_k_49 = null; var v_g_50 = null
	v_k_49 = J.arg(a, 0)
	var _t4 = env["has"]
	var _t5 = J.cl(_t4, null, [J.G.get("SCARE_GHOSTS")])
	v_g_50 = (J.gp(J.G.get("SCARE_GHOSTS"), v_k_49) if J.t(_t5) else _t5)
	var _t7 = null
	if J.t(v_g_50):
		var _t6 = J.gp(v_g_50, "types")
		_t7 = (_t6 if J.t(_t6) else [J.gp(v_g_50, "type")])
	else:
		_t7 = null
	return _t7

func _f7(this_, a: Array, env):
	var v_t_60 = null
	v_t_60 = J.arg(a, 0)
	return (not J.t(J.mc(env["own"], "includes", [v_t_60])))

func _f8(this_, a: Array, env):
	var v_t_61 = null
	v_t_61 = J.arg(a, 0)
	return (not J.seq(v_t_61, env["a"]))

func _f6(this_, a: Array, env):
	var v_k_53 = null; var v_rest_55 = null; var v_h_56 = null; var v_r2_58 = null; var v_b_59 = null
	var _s9 = {"__p": env, "own": null, "a": null}
	v_k_53 = J.arg(a, 0)
	if J.t(J.gp(_s9["__p"]["EFEAR"], v_k_53)):
		return J.gp(_s9["__p"]["EFEAR"], v_k_53)
	if J.t(J.gp(_s9["__p"]["cache"], v_k_53)):
		return J.gp(_s9["__p"]["cache"], v_k_53)
	var _t8 = _s9["__p"]["typesOf"]
	var _t11 = J.cl(_t8, null, [v_k_53])
	if not J.t(_t11):
		var _t10 = _s9["__p"]["TYPES"]
		var _t9 = _s9["__p"]["hash"]
		_t11 = [J.gp(_t10, J.mod(J.cl(_t9, null, [v_k_53]), 8.0))]
	_s9["own"] = _t11
	v_rest_55 = J.mc(_s9["__p"]["TYPES"], "filter", [Callable(self, "_f7").bind(_s9)])
	var _t12 = _s9["__p"]["hash"]
	v_h_56 = J.cl(_t12, null, [v_k_53])
	_s9["a"] = J.gp(v_rest_55, J.mod(v_h_56, J.len(v_rest_55)))
	v_r2_58 = J.mc(v_rest_55, "filter", [Callable(self, "_f8").bind(_s9)])
	v_b_59 = J.gp(v_r2_58, J.mod(J.ushr(v_h_56, 8.0), J.len(v_r2_58)))
	var _t13 = _s9["__p"]["cache"]
	var _t14 = {"w": [_s9["a"], v_b_59], "i": J.mc(_s9["own"], "slice", [0.0, 1.0]), "why": "自己識玩的把戲不怕"}
	J.sp(_t13, v_k_53, _t14)
	return _t14

func _f10(this_, a: Array, env):
	var v_k_65 = null; var v_f_66 = null
	v_k_65 = J.arg(a, 0)
	var _t15 = env["fearOf"]
	v_f_66 = J.cl(_t15, null, [v_k_65])
	var _t16 = J.gp(v_f_66, "w")
	var _t17 = J.mc(_t16, "map", [env["word"]])
	var _t20 = J.mc(_t17, "join", ["、"])
	var _t18 = J.gp(v_f_66, "i")
	var _t19 = J.mc(_t18, "map", [env["word"]])
	return ("怕" + J.str(_t20) + "　不怕" + J.str(J.mc(_t19, "join", ["、"])))

func _f12(this_, a: Array, env):
	var v_e_72 = null
	v_e_72 = J.arg(a, 0)
	var _t23 = (J.gp(J.gp(J.G.get("ENEMY_T"), v_e_72), 2.0) if J.t(J.gp(J.G.get("ENEMY_T"), v_e_72)) else v_e_72)
	var _t22 = env["fearLine"]
	return ("<span class=\"rw-ef\"><b>" + J.str(_t23) + "</b> " + J.str(J.cl(_t22, null, [v_e_72])) + "</span>")

func _f11(this_, a: Array, env):
	var v_en_69 = null; var v_seen_70 = null; var v_e_71 = null
	v_en_69 = J.arg(a, 0)
	v_seen_70 = []
	for _t21 in J.iter(v_en_69):
		v_e_71 = _t21
		if (not J.t(J.mc(v_seen_70, "includes", [v_e_71]))):
			J.mc(v_seen_70, "push", [v_e_71])
	var _t24 = J.mc(v_seen_70, "map", [Callable(self, "_f12").bind(env)])
	return J.mc(_t24, "join", [""])

func _f13(this_, a: Array, env):
	var v_g_75 = null; var v_ts_76 = null
	v_g_75 = J.arg(a, 0)
	var _t25 = env["typesOf"]
	v_ts_76 = J.cl(_t25, null, [J.gp(v_g_75, "k")])
	var _t29 = null
	if J.t(v_ts_76):
		var _t26 = J.mc(v_ts_76, "map", [env["word"]])
		var _t28 = J.mc(_t26, "join", ["／"])
		var _t27 = env["drillLv"]
		_t29 = ("嚇法：" + J.str(_t28) + "　嚇功 Lv" + J.str(J.cl(_t27, null, [J.gp(v_g_75, "k")])))
	else:
		_t29 = ""
	return _t29

func _f14(this_, a: Array, env):
	if (not J.t(J.gp(J.G.get("S"), "drill"))):
		var _t30 = J.G.get("S")
		var _t31 = {}
		J.sp(_t30, "drill", _t31)
	return J.gp(J.G.get("S"), "drill")

func _f15(this_, a: Array, env):
	var v_k_81 = null
	v_k_81 = J.arg(a, 0)
	var _t32 = (J.gp(J.G.get("S"), "drill") if J.t(J.G.get("S")) else J.G.get("S"))
	var _t33 = (J.gp(J.gp(J.G.get("S"), "drill"), v_k_81) if J.t(_t32) else _t32)
	return (_t33 if J.t(_t33) else 0.0)

func _f16(this_, a: Array, env):
	var v_k_84 = null; var v_x_85 = null; var v_lv_86 = null
	v_k_84 = J.arg(a, 0)
	var _t34 = env["drillXp"]
	v_x_85 = J.cl(_t34, null, [v_k_84])
	v_lv_86 = 1.0
	while true:
		var _t35 = J.cmp(v_lv_86, 5.0, "<")
		if not (J.cmp(v_x_85, J.gp(env["DRILL"], v_lv_86), ">=") if _t35 else _t35): break
		v_lv_86 = J.num(v_lv_86) + 1.0
	return v_lv_86

func _f17(this_, a: Array, env):
	var v_k_89 = null; var v_lv_90 = null
	v_k_89 = J.arg(a, 0)
	var _t36 = env["drillLv"]
	v_lv_90 = J.cl(_t36, null, [v_k_89])
	return (J.gp(env["DRILL"], v_lv_90) if J.cmp(v_lv_90, 5.0, "<") else null)

func _f18(this_, a: Array, env):
	var v_t_93 = null
	if (not J.t(J.gp(J.G.get("S"), "turf"))):
		var _t37 = J.G.get("S")
		var _t38 = {"lost": {}, "gang": {}, "next": 0.0, "day": null, "gain": 0.0}
		J.sp(_t37, "turf", _t38)
	v_t_93 = J.gp(J.G.get("S"), "turf")
	var _t39 = J.gp(v_t_93, "lost")
	var _t40 = (_t39 if J.t(_t39) else {})
	J.sp(v_t_93, "lost", _t40)
	var _t41 = J.gp(v_t_93, "gang")
	var _t42 = (_t41 if J.t(_t41) else {})
	J.sp(v_t_93, "gang", _t42)
	return v_t_93

func _f21(this_, a: Array, env):
	var v_st_99 = null; var v_si_100 = null
	v_st_99 = J.arg(a, 0)
	v_si_100 = J.arg(a, 1)
	return J.mc(env["__p"]["a"], "push", [(J.str(J.add(env["ci"], 1.0)) + "-" + J.str(J.add(v_si_100, 1.0)))])

func _f20(this_, a: Array, env):
	var v_ch_97 = null
	var _s24 = {"__p": env, "ci": null}
	v_ch_97 = J.arg(a, 0)
	_s24["ci"] = J.arg(a, 1)
	var _t43 = J.gp(v_ch_97, "stages")
	return J.mc(_t43, "forEach", [Callable(self, "_f21").bind(_s24)])

func _f19(this_, a: Array, env):
	var _s23 = {"__p": env, "a": null}
	_s23["a"] = []
	J.mc(J.G.get("CHAPTERS"), "forEach", [Callable(self, "_f20").bind(_s23)])
	return _s23["a"]

func _f22(this_, a: Array, env):
	var v_sid_103 = null; var v_c_104 = null; var v_s_105 = null
	v_sid_103 = J.arg(a, 0)
	var _t44 = J.mc(v_sid_103, "split", ["-"])
	var _t45 = J.mc(_t44, "map", [J.G.get("Number")])
	var _t46 = J.gp(_t45, 0.0)
	v_c_104 = _t46
	var _t47 = J.gp(_t45, 1.0)
	v_s_105 = _t47
	var _t48 = J.gp(J.G.get("CHAPTERS"), J.sub(v_c_104, 1.0))
	return (J.gp(J.gp(J.gp(J.G.get("CHAPTERS"), J.sub(v_c_104, 1.0)), "stages"), J.sub(v_s_105, 1.0)) if J.t(_t48) else _t48)

func _f24(this_, a: Array, env):
	var v_s_109 = null
	v_s_109 = J.arg(a, 0)
	var _t50 = J.gp(J.G.get("S"), "cleared")
	var _t51 = (J.gp(J.gp(J.G.get("S"), "cleared"), v_s_109) if J.t(_t50) else _t50)
	return ((not J.t(J.gp(J.gp(env["t"], "lost"), v_s_109))) if J.t(_t51) else _t51)

func _f23(this_, a: Array, env):
	var _s27 = {"__p": env, "t": null}
	_s27["t"] = J.cl(_s27["__p"]["turf"], null, [])
	var _t49 = J.cl(_s27["__p"]["allSids"], null, [])
	return J.mc(_t49, "filter", [Callable(self, "_f24").bind(_s27)])

func _f25(this_, a: Array, env):
	var v_sid_112 = null
	v_sid_112 = J.arg(a, 0)
	return (not (not J.t(J.gp(J.gp(J.cl(env["turf"], null, []), "lost"), v_sid_112))))

func _f27(this_, a: Array, env):
	var v_ms_115 = null; var v_d_116 = null
	v_ms_115 = J.arg(a, 0)
	v_d_116 = J.new_("Date", [v_ms_115])
	return floor(J.num(J.div(J.sub(v_ms_115, J.mul(J.mc(v_d_116, "getTimezoneOffset", []), 60000.0)), env["DAY"])))

func _f29(this_, a: Array, env):
	var v_s_131 = null
	v_s_131 = J.arg(a, 0)
	var _t67 = env["stageOf"]
	return (not J.t(J.gp(J.cl(_t67, null, [v_s_131]), "boss")))

func _f28(this_, a: Array, env):
	var v_t_119 = null; var v_now_120 = null; var v_h_121 = null; var v_today_122 = null; var v_days_123 = null; var v_kpi_124 = null; var v_pres_125 = null; var v_g_126 = null; var v_e_127 = null; var v_lostN_128 = null; var v_pool_129 = null; var v_sid_130 = null; var v_gi_132 = null; var v_e_133 = null
	var _t52 = (not J.t(J.G.get("S")))
	if (_t52 if _t52 else (not J.t(J.gp(J.G.get("S"), "cleared")))):
		return null
	v_t_119 = J.cl(env["turf"], null, [])
	v_now_120 = J.cl(env["clock"], null, [])
	v_h_121 = J.cl(env["held"], null, [])
	if (not J.seq(J.typeof_(J.G.get("Station")), "undefined")):
		var _t53 = {}
		J.sp(v_t_119, "lost", _t53)
		var _t54 = {}
		J.sp(v_t_119, "gang", _t54)
		return null
	var _t55 = env["gday"]
	v_today_122 = J.cl(_t55, null, [v_now_120])
	if J.leq(J.gp(v_t_119, "day"), null):
		J.sp(v_t_119, "day", v_today_122)
	if J.cmp(v_today_122, J.gp(v_t_119, "day"), ">"):
		v_days_123 = J.min_([7.0, J.sub(v_today_122, J.gp(v_t_119, "day"))])
		J.sp(v_t_119, "day", v_today_122)
		v_kpi_124 = J.mul(J.min_([8.0, floor(J.num(J.div(J.len(v_h_121), 3.0)))]), v_days_123)
		v_pres_125 = J.mul(J.min_([6.0, (J.len(v_h_121) * 0.4)]), v_days_123)
		if J.t((v_kpi_124 if J.t(v_kpi_124) else v_pres_125)):
			var _t56 = J.gp(J.G.get("S"), "contract")
			var _t57 = (J.seq(J.gp(J.gp(J.G.get("S"), "contract"), "state"), "active") if J.t(_t56) else _t56)
			if J.t((v_kpi_124 if J.t(_t57) else _t57)):
				var _t58 = J.gp(J.G.get("S"), "contract")
				var _t59 = J.add(J.gp(_t58, "kpi"), v_kpi_124)
				J.sp(_t58, "kpi", _t59)
			var _t60 = env["has"]
			var _t61 = J.cl(_t60, null, [J.G.get("Presence")])
			if J.t((v_pres_125 if J.t(_t61) else _t61)):
				for _t62 in J.iter(J.gp(J.G.get("S"), "ghosts")):
					v_g_126 = _t62
					if (not J.seq(J.gp(v_g_126, "k"), "afu")):
						J.mc(J.G.get("Presence"), "add", [v_g_126, v_pres_125])
			J.sp(v_t_119, "gain", v_kpi_124)
			J.mc(J.G.get("Fx"), "toast", [("地盤收租：" + J.str(J.len(v_h_121)) + " 個地盤" + (("，合約 KPI +" + J.str(v_kpi_124)) if J.t(v_kpi_124) else "") + "，全村存在感 +" + J.str(J.round(J.num(v_pres_125))))])
	if (not J.t(J.gp(v_t_119, "next"))):
		var _t63 = J.add(v_now_120, J.mul((8.0 + (randf() * 6.0)), env["HOUR"]))
		J.sp(v_t_119, "next", _t63)
	if J.cmp(v_now_120, J.gp(v_t_119, "next"), ">="):
		var _t64 = J.add(v_now_120, J.mul((8.0 + (randf() * 6.0)), env["HOUR"]))
		J.sp(v_t_119, "next", _t64)
		v_lostN_128 = J.len(J.S_Object_("keys", [J.gp(v_t_119, "lost")]))
		var _t65 = (J.len(v_h_121) >= 3.0)
		var _t66 = (J.cmp(v_lostN_128, 2.0, "<") if _t65 else _t65)
		if (J.cmp(J.gp(J.G.get("S"), "lv"), 6.0, ">=") if _t66 else _t66):
			v_pool_129 = J.mc(v_h_121, "filter", [Callable(self, "_f29").bind(env)])
			v_sid_130 = J.gp(v_pool_129, floor(J.num((randf() * J.len(v_pool_129)))))
			if J.t(v_sid_130):
				v_gi_132 = floor(J.num((randf() * J.len(env["GANGS"]))))
				var _t68 = J.gp(v_t_119, "lost")
				J.sp(_t68, v_sid_130, v_now_120)
				var _t69 = J.gp(v_t_119, "gang")
				J.sp(_t69, v_sid_130, v_gi_132)
				var _t70 = env["stageOf"]
				J.mc(J.G.get("Fx"), "toast", [("<b>" + J.str(J.gp(J.cl(_t70, null, [v_sid_130]), "name")) + "</b> 被" + J.str(J.gp(J.gp(env["GANGS"], v_gi_132), "name")) + "搶走了！到「地盤」奪回。")])

func _f30(this_, a: Array, env):
	var v_sid_136 = null; var v_t_137 = null; var v_g_138 = null
	v_sid_136 = J.arg(a, 0)
	var _t71 = (not J.t(J.gp(J.G.get("S"), "cleared")))
	var _t72 = (_t71 if _t71 else (not J.t(J.gp(J.gp(J.G.get("S"), "cleared"), v_sid_136))))
	if (_t72 if _t72 else (not J.seq(J.typeof_(J.G.get("Station")), "undefined"))):
		return ""
	v_t_137 = J.cl(env["turf"], null, [])
	if J.t(J.gp(J.gp(v_t_137, "lost"), v_sid_136)):
		var _t74 = env["GANGS"]
		var _t73 = J.gp(J.gp(v_t_137, "gang"), v_sid_136)
		v_g_138 = J.gp(_t74, (_t73 if J.t(_t73) else 0.0))
		return ("<em class=\"rw-lost\">被" + J.str(J.gp(v_g_138, "name")) + "搶走</em>")
	return "<em class=\"rw-own\">我方地盤</em>"

func _f32(this_, a: Array, env):
	var v_sid_145 = null; var v_g_146 = null
	v_sid_145 = J.arg(a, 0)
	var _t76 = env["__p"]["GANGS"]
	var _t75 = J.gp(J.gp(env["t"], "gang"), v_sid_145)
	v_g_146 = J.gp(_t76, (_t75 if J.t(_t75) else 0.0))
	var _t77 = env["__p"]["stageOf"]
	var _t80 = J.gp(J.cl(_t77, null, [v_sid_145]), "name")
	var _t81 = J.gp(v_g_146, "name")
	var _t79 = null
	if J.seq(J.typeof_(J.G.get("L")), "function"):
		var _t78 = J.G.get("L")
		_t79 = J.cl(_t78, null, [J.gp(v_g_146, "line")])
	else:
		_t79 = J.gp(v_g_146, "line")
	return ("<p class=\"rw-raid\">⚑ <b>" + J.str(_t80) + "</b>（" + J.str(v_sid_145) + "）被" + J.str(_t81) + "搶走：<br><i>" + J.str(_t79) + "</i></p>")

func _f31(this_, a: Array, env):
	var v_h_142 = null; var v_lost_143 = null; var v_s_144 = null
	var _s49 = {"__p": env, "t": null}
	_s49["t"] = J.cl(_s49["__p"]["turf"], null, [])
	v_h_142 = J.cl(_s49["__p"]["held"], null, [])
	v_lost_143 = J.S_Object_("keys", [J.gp(_s49["t"], "lost")])
	v_s_144 = ("<div class=\"rw-turf\"><b>陽間地盤 " + J.str(J.len(v_h_142)) + "</b><small>每日收租：合約 KPI +" + J.str(J.min_([8.0, floor(J.num(J.div(J.len(v_h_142), 3.0)))])) + "，全村存在感 +" + J.str(J.round(J.num(J.min_([6.0, (J.len(v_h_142) * 0.4)])))) + "。打下一關就多一個地盤；鄰村鬼幫會不時來搶。</small>")
	if J.t(J.len(v_lost_143)):
		var _t82 = J.mc(v_lost_143, "map", [Callable(self, "_f32").bind(_s49)])
		var _t83 = J.add(v_s_144, J.mc(_t82, "join", [""]))
		v_s_144 = _t83
	return J.add(v_s_144, "</div>")

func _f34(this_, a: Array, env):
	var v_g_152 = null
	v_g_152 = J.arg(a, 0)
	return J.mc(J.G.get("Presence"), "add", [v_g_152, 6.0])

func _f33(this_, a: Array, env):
	var v_sid_149 = null; var v_t_150 = null; var v_kp_151 = null; var v_e_153 = null
	v_sid_149 = J.arg(a, 0)
	v_t_150 = J.cl(env["turf"], null, [])
	if (not J.t(J.gp(J.gp(v_t_150, "lost"), v_sid_149))):
		return null
	J.del(J.gp(v_t_150, "lost"), v_sid_149)
	J.del(J.gp(v_t_150, "gang"), v_sid_149)
	v_kp_151 = 0.0
	var _t84 = J.gp(J.G.get("S"), "contract")
	if J.t((J.seq(J.gp(J.gp(J.G.get("S"), "contract"), "state"), "active") if J.t(_t84) else _t84)):
		var _t85 = J.gp(J.G.get("S"), "contract")
		var _t86 = J.add(J.gp(_t85, "kpi"), 4.0)
		J.sp(_t85, "kpi", _t86)
		v_kp_151 = 4.0
	var _t87 = env["has"]
	if J.t(J.cl(_t87, null, [J.G.get("Presence")])):
		var _t88 = J.gp(J.G.get("S"), "team")
		var _t89 = J.mc(_t88, "map", [J.G.get("ghostById")])
		var _t90 = J.mc(_t89, "filter", [J.G.get("Boolean")])
		J.mc(_t90, "forEach", [Callable(self, "_f34").bind(env)])
	var _t91 = env["stageOf"]
	J.mc(J.G.get("Fx"), "toast", [("奪回地盤：<b>" + J.str(J.gp(J.cl(_t91, null, [v_sid_149]), "name")) + "</b>" + (("　合約 KPI +" + J.str(v_kp_151)) if J.t(v_kp_151) else "") + "，出陣的鬼存在感 +6")])

func _f36(this_, a: Array, env):
	var v_k_156 = null; var v_K_157 = null; var v_on_158 = null; var v_ok_159 = null
	v_k_156 = J.arg(a, 0)
	v_K_157 = J.gp(env["KITS"], v_k_156)
	v_on_158 = (not (not J.t(J.gp(J.gp(J.G.get("S"), "scareKit"), v_k_156))))
	var _t96 = J.G.get("canPay")
	v_ok_159 = J.cl(_t96, null, [J.gp(v_K_157, "cost")])
	var _t98 = ("on" if J.t(v_on_158) else "")
	var _t99 = ("" if J.t(v_ok_159) else "dim")
	var _t100 = J.gp(v_K_157, "name")
	var _t97 = J.G.get("costText")
	return ("<button class=\"rw-kb " + _t98 + " " + _t99 + "\" data-kit=\"" + J.str(v_k_156) + "\"><b>" + J.str(_t100) + "</b><small>" + J.str(J.cl(_t97, null, [J.gp(v_K_157, "cost")])) + "</small><i>" + J.str(J.gp(v_K_157, "desc")) + "</i></button>")

func _f35(this_, a: Array, env):
	var _t92 = J.G.get("S")
	var _t93 = J.gp(J.G.get("S"), "scareKit")
	var _t94 = (_t93 if J.t(_t93) else {})
	J.sp(_t92, "scareKit", _t94)
	var _t95 = J.S_Object_("keys", [env["KITS"]])
	var _t101 = J.mc(_t95, "map", [Callable(self, "_f36").bind(env)])
	return ("<div class=\"rw-kit\"><p class=\"desc\"><b>帶上村裡的產出</b>（出發時扣）：</p>" + J.str(J.mc(_t101, "join", [""])) + "</div>")

func _f39(this_, a: Array, env):
	var v_k_164 = null
	v_k_164 = J.gp(J.gp(env["b"], "dataset"), "kit")
	var _t104 = J.G.get("S")
	var _t105 = J.gp(J.G.get("S"), "scareKit")
	var _t106 = (_t105 if J.t(_t105) else {})
	J.sp(_t104, "scareKit", _t106)
	var _t108 = (not J.t(J.gp(J.gp(J.G.get("S"), "scareKit"), v_k_164)))
	if J.t(_t108):
		var _t107 = J.G.get("canPay")
		_t108 = (not J.t(J.cl(_t107, null, [J.gp(J.gp(env["__p"]["KITS"], v_k_164), "cost")])))
	if _t108:
		J.mc(J.G.get("Fx"), "toast", ["材料不夠"])
		return null
	var _t109 = J.gp(J.G.get("S"), "scareKit")
	var _t110 = (not J.t(J.gp(J.gp(J.G.get("S"), "scareKit"), v_k_164)))
	J.sp(_t109, v_k_164, _t110)
	var _t111 = J.gp(env["b"], "classList")
	J.mc(_t111, "toggle", ["on", J.gp(J.gp(J.G.get("S"), "scareKit"), v_k_164)])
	J.cl(J.G.get("save"), null, [])

func _f38(this_, a: Array, env):
	var _s60 = {"__p": env, "b": null}
	_s60["b"] = J.arg(a, 0)
	var _t103 = _s60["b"]
	var _t112 = Callable(self, "_f39").bind(_s60)
	J.sp(_t103, "onclick", _t112)
	return _t112

func _f37(this_, a: Array, env):
	var v_root_162 = null
	v_root_162 = J.arg(a, 0)
	var _t102 = J.mc(v_root_162, "querySelectorAll", ["[data-kit]"])
	J.mc(_t102, "forEach", [Callable(self, "_f38").bind(env)])

func _f42(this_, a: Array, env):
	var v_x_188 = null
	v_x_188 = J.arg(a, 0)
	var _t122 = J.gp(env["f"], "w")
	return J.mc(_t122, "includes", [v_x_188])

func _f43(this_, a: Array, env):
	var v_x_189 = null
	v_x_189 = J.arg(a, 0)
	var _t123 = J.gp(env["f"], "i")
	return (not J.t(J.mc(_t123, "includes", [v_x_189])))

func _f41(this_, a: Array, env):
	var v_src_175 = null; var v_v_176 = null; var v_mult_177 = null; var v_sk_178 = null; var v_ts_179 = null; var v_t_181 = null; var v_m_182 = null; var v_tag_183 = null; var v_col_184 = null; var v_chain_185 = null; var v_marked_186 = null; var v_dmg_187 = null
	var _s64 = {"__p": env, "f": null}
	v_src_175 = J.arg(a, 0)
	v_v_176 = J.arg(a, 1)
	v_mult_177 = J.arg(a, 2)
	v_sk_178 = J.arg(a, 3)
	var _t114 = (not J.t(v_sk_178))
	var _t115 = (_t114 if _t114 else (not J.t(v_src_175)))
	var _t116 = (_t115 if _t115 else (not J.seq(J.gp(v_src_175, "side"), 0.0)))
	var _t117 = (_t116 if _t116 else (not J.t(v_v_176)))
	var _t118 = (_t117 if _t117 else (not J.seq(J.gp(v_v_176, "side"), 1.0)))
	var _t119 = (_t118 if _t118 else J.seq(J.gp(v_sk_178, "kind"), "heal"))
	if J.t((_t119 if _t119 else J.gp(v_src_175, "minion"))):
		return J.mc(_s64["__p"]["oh"], "call", [this_, v_src_175, v_v_176, v_mult_177, v_sk_178])
	var _t120 = _s64["__p"]["__p"]["typesOf"]
	v_ts_179 = J.cl(_t120, null, [J.gp(v_src_175, "k")])
	if (not J.t(v_ts_179)):
		return J.mc(_s64["__p"]["oh"], "call", [this_, v_src_175, v_v_176, v_mult_177, v_sk_178])
	var _t121 = _s64["__p"]["__p"]["fearOf"]
	_s64["f"] = J.cl(_t121, null, [J.gp(v_v_176, "k")])
	var _t124 = J.mc(v_ts_179, "find", [Callable(self, "_f42").bind(_s64)])
	var _t125 = (_t124 if J.t(_t124) else J.mc(v_ts_179, "find", [Callable(self, "_f43").bind(_s64)]))
	v_t_181 = (_t125 if J.t(_t125) else J.gp(v_ts_179, 0.0))
	var _t126 = _s64["__p"]["__p"]["drillLv"]
	v_m_182 = J.mul(v_mult_177, (1.0 + (0.05 * J.sub(J.cl(_t126, null, [J.gp(v_src_175, "k")]), 1.0))))
	v_tag_183 = null
	v_col_184 = "#e8d0ff"
	v_chain_185 = false
	var _t127 = J.gp(v_v_176, "fearT")
	v_marked_186 = (J.cmp(J.gp(J.gp(v_v_176, "fearT"), "until"), J.gp(this_, "t"), ">") if J.t(_t127) else _t127)
	var _t128 = J.gp(_s64["f"], "i")
	if J.t(J.mc(_t128, "includes", [v_t_181])):
		var _t129 = J.mul(v_m_182, 0.6)
		v_m_182 = _t129
		var _t130 = _s64["__p"]["__p"]["word"]
		var _t131 = ("不怕" + J.str(J.cl(_t130, null, [v_t_181])))
		v_tag_183 = _t131
		v_col_184 = "#9aa"
	else:
		var _t132 = J.gp(_s64["f"], "w")
		if J.t(J.mc(_t132, "includes", [v_t_181])):
			var _t133 = J.mul(v_m_182, 1.35)
			v_m_182 = _t133
			if J.t(((not J.seq(J.gp(J.gp(v_v_176, "fearT"), "t"), v_t_181)) if J.t(v_marked_186) else v_marked_186)):
				var _t134 = J.mul(v_m_182, 1.8)
				v_m_182 = _t134
				v_chain_185 = true
				var _t135 = _s64["__p"]["__p"]["word"]
				var _t137 = J.cl(_t135, null, [J.gp(J.gp(v_v_176, "fearT"), "t")])
				var _t136 = _s64["__p"]["__p"]["word"]
				var _t138 = (J.str(_t137) + "＋" + J.str(J.cl(_t136, null, [v_t_181])) + "・連嚇")
				v_tag_183 = _t138
				v_col_184 = "#ffd84a"
			else:
				var _t139 = _s64["__p"]["__p"]["word"]
				var _t140 = ("怕" + J.str(J.cl(_t139, null, [v_t_181])) + "・失神")
				v_tag_183 = _t140
			var _t141 = {"t": v_t_181, "until": J.add(J.gp(this_, "t"), 3.2)}
			J.sp(v_v_176, "fearT", _t141)
		else:
			if J.t(((not J.seq(J.gp(J.gp(v_v_176, "fearT"), "t"), v_t_181)) if J.t(v_marked_186) else v_marked_186)):
				var _t142 = J.mul(v_m_182, 1.3)
				v_m_182 = _t142
				v_tag_183 = "追嚇"
				v_col_184 = "#ffe8a0"
	v_dmg_187 = J.mc(_s64["__p"]["oh"], "call", [this_, v_src_175, v_v_176, v_m_182, v_sk_178])
	if J.t(((not J.leq(J.gp(v_v_176, "x"), null)) if J.t(v_tag_183) else v_tag_183)):
		var _t143 = J.gp(this_, "fx")
		J.mc(_t143, "push", [{"x": J.gp(v_v_176, "x"), "y": J.sub(J.mc(this_, "uy", [v_v_176]), J.mul(100.0, J.mc(this_, "scaleOf", [v_v_176]))), "text": v_tag_183, "col": v_col_184, "t": 0.0, "life": 1.1}])
	if J.t(v_chain_185):
		J.mc(J.G.get("Sound"), "play", ["combo", J.gp(this_, "combo")])
		var _t144 = this_
		var _t145 = (J.add(J.gp(this_, "combo"), 1.0) if J.cmp(J.gp(this_, "comboT"), 0.0, ">") else 1.0)
		J.sp(_t144, "combo", _t145)
		var _t146 = this_
		J.sp(_t146, "comboT", 3.0)
		var _t147 = this_
		J.sp(_t147, "comboPop", 1.0)
		var _t148 = J.gp(this_, "fx")
		var _t149 = J.gp(this_, "H")
		J.mc(_t148, "push", [{"x": 195.0, "y": J.mul((_t149 if J.t(_t149) else 640.0), 0.3), "text": ("連嚇 ×" + J.str(J.add(J.gp(this_, "combo"), 1.0)) + "！"), "col": "#ffd84a", "t": 0.0, "life": 1.2, "center": true}])
	return v_dmg_187

func _f44(this_, a: Array, env):
	var v_ci_192 = null; var v_si_193 = null; var v_wild_194 = null; var v_r_195 = null; var v_u_196 = null; var v_e_197 = null
	v_ci_192 = J.arg(a, 0)
	v_si_193 = J.arg(a, 1)
	v_wild_194 = J.arg(a, 2)
	v_r_195 = J.mc(env["os"], "apply", [this_, a])
	var _t152 = this_
	var _t154 = (not J.t(v_wild_194))
	if J.t(_t154):
		var _t153 = env["__p"]["isLost"]
		_t154 = J.cl(_t153, null, [J.gp(this_, "sid")])
	J.sp(_t152, "retake", _t154)
	if J.t(J.gp(this_, "retake")):
		for _t155 in J.iter(J.gp(this_, "units")):
			v_u_196 = _t155
			if J.seq(J.gp(v_u_196, "side"), 1.0):
				var _t156 = J.mul(J.gp(v_u_196, "hp"), 1.15)
				J.sp(v_u_196, "hp", _t156)
				var _t157 = J.mul(J.gp(v_u_196, "maxhp"), 1.15)
				J.sp(v_u_196, "maxhp", _t157)
				var _t158 = J.mul(J.gp(v_u_196, "atk"), 1.1)
				J.sp(v_u_196, "atk", _t158)
		var _t159 = J.G.get("$")
		var _t160 = J.cl(_t159, null, ["#b-title"])
		var _t161 = ("奪回地盤　" + J.str(J.gp(J.gp(this_, "stage"), "name")))
		J.sp(_t160, "textContent", _t161)
	return v_r_195

func _f45(this_, a: Array, env):
	var v_win_200 = null; var v_was_201 = null; var v_rt_202 = null; var v_sid_203 = null; var v_r_204 = null; var v_e_205 = null
	v_win_200 = J.arg(a, 0)
	v_was_201 = (not J.t(J.gp(this_, "result")))
	v_rt_202 = J.gp(this_, "retake")
	v_sid_203 = J.gp(this_, "sid")
	v_r_204 = J.mc(env["of"], "apply", [this_, a])
	var _t164 = (v_win_200 if J.t(v_was_201) else v_was_201)
	if J.t((v_rt_202 if J.t(_t164) else _t164)):
		var _t165 = env["__p"]["retake"]
		J.cl(_t165, null, [v_sid_203])
	var _t166 = this_
	J.sp(_t166, "retake", false)
	return v_r_204

func _f47(this_, a: Array, env):
	var v_k_216 = null
	v_k_216 = J.arg(a, 0)
	return J.gp(J.gp(env["__p"]["KITS"], v_k_216), "name")

func _f46(this_, a: Array, env):
	var v_siteId_208 = null; var v_team_209 = null; var v_headless_210 = null; var v_seed_211 = null; var v_kit_212 = null; var v_r_213 = null; var v_k_214 = null; var v_k_215 = null; var v_e_217 = null
	v_siteId_208 = J.arg(a, 0)
	v_team_209 = J.arg(a, 1)
	v_headless_210 = J.arg(a, 2)
	v_seed_211 = J.arg(a, 3)
	v_kit_212 = {}
	var _t169 = (not J.t(v_headless_210))
	if J.t((J.gp(J.G.get("S"), "scareKit") if _t169 else _t169)):
		for _t170 in J.keys(J.gp(J.G.get("S"), "scareKit")):
			v_k_214 = _t170
			var _t172 = J.gp(J.gp(J.G.get("S"), "scareKit"), v_k_214)
			if J.t(_t172):
				var _t171 = J.G.get("canPay")
				_t172 = J.cl(_t171, null, [J.gp(J.gp(env["__p"]["KITS"], v_k_214), "cost")])
			if J.t(_t172):
				var _t173 = J.G.get("pay")
				J.cl(_t173, null, [J.gp(J.gp(env["__p"]["KITS"], v_k_214), "cost")])
				J.sp(v_kit_212, v_k_214, true)
	var _t174 = this_
	J.sp(_t174, "kit", v_kit_212)
	v_r_213 = J.mc(env["ostart"], "apply", [this_, a])
	if (not J.t(v_headless_210)):
		var _t175 = this_
		var _t176 = {}
		J.sp(_t175, "_drill", _t176)
		for _t177 in J.iter(v_team_209):
			v_k_215 = _t177
			var _t178 = J.gp(this_, "_drill")
			var _t179 = env["__p"]["drillLv"]
			var _t180 = J.cl(_t179, null, [v_k_215])
			J.sp(_t178, v_k_215, _t180)
	if J.t(J.gp(v_kit_212, "offer")):
		var _t181 = this_
		var _t182 = J.add(J.gp(_t181, "mana"), 30.0)
		J.sp(_t181, "mana", _t182)
	if J.t(J.len(J.S_Object_("keys", [v_kit_212]))):
		J.cl(J.G.get("save"), null, [])
		var _t183 = J.S_Object_("keys", [v_kit_212])
		var _t184 = J.mc(_t183, "map", [Callable(self, "_f47").bind(env)])
		J.mc(this_, "toast", [("帶上：" + J.str(J.mc(_t184, "join", ["、"])))])
	return v_r_213

func _f48(this_, a: Array, env):
	var v_k_220 = null; var v_n_221 = null; var v_g_222 = null; var v_lv_223 = null; var v_b_224 = null; var v_c_225 = null
	v_k_220 = J.arg(a, 0)
	v_n_221 = J.arg(a, 1)
	v_g_222 = J.gp(J.G.get("SCARE_GHOSTS"), v_k_220)
	var _t187 = J.gp(this_, "_drill")
	var _t188 = (J.gp(J.gp(this_, "_drill"), v_k_220) if J.t(_t187) else _t187)
	v_lv_223 = (_t188 if J.t(_t188) else 1.0)
	var _t189 = (not J.t(v_g_222))
	if (_t189 if _t189 else J.cmp(v_lv_223, 1.0, "<=")):
		return J.mc(env["oug"], "apply", [this_, a])
	v_b_224 = J.gp(v_g_222, "base")
	v_c_225 = J.gp(v_g_222, "cost")
	var _t190 = J.round(J.num(J.mul(v_b_224, (1.0 + (0.1 * J.sub(v_lv_223, 1.0))))))
	J.sp(v_g_222, "base", _t190)
	var _t191 = J.max_([18.0, J.sub((v_c_225 if J.t(v_c_225) else 35.0), (2.0 * J.sub(v_lv_223, 1.0)))])
	J.sp(v_g_222, "cost", _t191)
	return J.mc(env["oug"], "apply", [this_, a])
	J.sp(v_g_222, "base", v_b_224)
	J.sp(v_g_222, "cost", v_c_225)

func _f49(this_, a: Array, env):
	var v_k_228 = null; var v_before_229 = null; var v_r_230 = null; var v_e_231 = null
	v_k_228 = J.arg(a, 0)
	var _t194 = J.gp(this_, "pcd")
	v_before_229 = (J.gp(J.gp(this_, "pcd"), v_k_228) if J.t(_t194) else _t194)
	v_r_230 = J.mc(env["oup"], "apply", [this_, a])
	var _t195 = J.gp(this_, "kit")
	var _t196 = (J.gp(J.gp(this_, "kit"), "props") if J.t(_t195) else _t195)
	var _t197 = (J.gp(this_, "pcd") if J.t(_t196) else _t196)
	var _t198 = (J.cmp(J.gp(J.gp(this_, "pcd"), v_k_228), 0.0, ">") if J.t(_t197) else _t197)
	if J.t(((not J.seq(J.gp(J.gp(this_, "pcd"), v_k_228), v_before_229)) if J.t(_t198) else _t198)):
		var _t199 = J.gp(this_, "pcd")
		var _t200 = J.mul(J.gp(_t199, v_k_228), 0.5)
		J.sp(_t199, v_k_228, _t200)
	return v_r_230

func _f50(this_, a: Array, env):
	var v_e_232 = null
	J.cl(env["__p"]["turfTick"], null, [])

func _f40(this_, a: Array, env):
	var _s63 = {"__p": env, "oh": null, "os": null, "of": null, "ostart": null, "oug": null, "oup": null}
	if J.t(_s63["__p"]["started"]):
		return null
	_s63["__p"]["started"] = true
	_s63["oh"] = J.gp(J.G.get("Battle"), "hit")
	var _t113 = J.G.get("Battle")
	var _t150 = Callable(self, "_f41").bind(_s63)
	J.sp(_t113, "hit", _t150)
	_s63["os"] = J.gp(J.G.get("Battle"), "start")
	var _t151 = J.G.get("Battle")
	var _t162 = Callable(self, "_f44").bind(_s63)
	J.sp(_t151, "start", _t162)
	_s63["of"] = J.gp(J.G.get("Battle"), "finish")
	var _t163 = J.G.get("Battle")
	var _t167 = Callable(self, "_f45").bind(_s63)
	J.sp(_t163, "finish", _t167)
	_s63["ostart"] = J.gp(J.G.get("Scare"), "start")
	var _t168 = J.G.get("Scare")
	var _t185 = Callable(self, "_f46").bind(_s63)
	J.sp(_t168, "start", _t185)
	_s63["oug"] = J.gp(J.G.get("Scare"), "useGhost")
	var _t186 = J.G.get("Scare")
	var _t192 = Callable(self, "_f48").bind(_s63)
	J.sp(_t186, "useGhost", _t192)
	_s63["oup"] = J.gp(J.G.get("Scare"), "useProp")
	var _t193 = J.G.get("Scare")
	var _t201 = Callable(self, "_f49").bind(_s63)
	J.sp(_t193, "useProp", _t201)
	J.F_setInterval([Callable(self, "_f50").bind(_s63), 5000.0])
	J.cl(_s63["__p"]["turfTick"], null, [])

func _f2(this_, a: Array, env):
	var v_yue_39 = null; var v_zh_40 = null
	v_yue_39 = J.arg(a, 0)
	v_zh_40 = J.arg(a, 1)
	if (not J.seq(J.typeof_(J.G.get("LANG")), "undefined")):
		J.mc(J.G.get("LANG"), "add", [{J.key(v_yue_39): v_zh_40}])
	return v_yue_39

func _f3(this_, a: Array, env):
	var v_o_41 = null
	v_o_41 = J.arg(a, 0)
	return (not J.seq(J.typeof_(v_o_41), "undefined"))

func _f9(this_, a: Array, env):
	var v_t_62 = null
	v_t_62 = J.arg(a, 0)
	var _t202 = J.gp(env["W"], v_t_62)
	return (_t202 if J.t(_t202) else v_t_62)

func _f26(this_, a: Array, env):
	var _t203 = env["has"]
	var _t204 = J.cl(_t203, null, [J.G.get("Presence")])
	var _t205 = (J.gp(J.G.get("Presence"), "st") if J.t(_t204) else _t204)
	var _t208 = null
	if J.t((J.gp(J.G.get("S"), "presence") if J.t(_t205) else _t205)):
		var _t207 = J.S_Date_("now", [])
		var _t206 = J.gp(J.gp(J.G.get("S"), "presence"), "skew")
		_t208 = J.add(_t207, (_t206 if J.t(_t206) else 0.0))
	else:
		_t208 = J.S_Date_("now", [])
	return _t208

func _f51(this_, a: Array, env):
	var v_boot_235 = null; var v_e_236 = null
	v_boot_235 = Callable(self, "_f51").bind(env)
	var _t209 = J.seq(J.typeof_(J.G.get("S")), "undefined")
	var _t211 = (_t209 if _t209 else (not J.t(J.G.get("S"))))
	if not J.t(_t211):
		var _t210 = env["has"]
		_t211 = (not J.t(J.cl(_t210, null, [J.G.get("Battle")])))
	var _t213 = (_t211 if _t211 else (not J.t(J.gp(J.G.get("Battle"), "hit"))))
	if not J.t(_t213):
		var _t212 = env["has"]
		_t213 = (not J.t(J.cl(_t212, null, [J.G.get("Scare")])))
	if _t213:
		J.F_setTimeout([v_boot_235, 300.0])
		return null
	J.cl(env["init"], null, [])

func _f1(this_, a: Array, env):
	var v_D_2 = null; var v_enemyHint_15 = null; var v_teamHint_16 = null; var v_drill_18 = null; var v_drillNext_21 = null; var v_turfTag_31 = null; var v_turfHead_32 = null; var v_kitHTML_35 = null; var v_bindKit_36 = null
	var _s2 = {"__p": env, "DAY": null, "HOUR": null, "W": null, "TYPES": null, "has": null, "EFEAR": null, "hash": null, "typesOf": null, "cache": null, "fearOf": null, "word": null, "fearLine": null, "DRILL": null, "drillXp": null, "drillLv": null, "GANGS": null, "turf": null, "allSids": null, "stageOf": null, "held": null, "isLost": null, "clock": null, "gday": null, "turfTick": null, "retake": null, "KITS": null, "started": null, "init": null}
	_s2["hash"] = Callable(self, "_f4").bind(_s2)
	_s2["typesOf"] = Callable(self, "_f5").bind(_s2)
	_s2["fearOf"] = Callable(self, "_f6").bind(_s2)
	_s2["fearLine"] = Callable(self, "_f10").bind(_s2)
	v_enemyHint_15 = Callable(self, "_f11").bind(_s2)
	v_teamHint_16 = Callable(self, "_f13").bind(_s2)
	v_drill_18 = Callable(self, "_f14").bind(_s2)
	_s2["drillXp"] = Callable(self, "_f15").bind(_s2)
	_s2["drillLv"] = Callable(self, "_f16").bind(_s2)
	v_drillNext_21 = Callable(self, "_f17").bind(_s2)
	_s2["turf"] = Callable(self, "_f18").bind(_s2)
	_s2["allSids"] = Callable(self, "_f19").bind(_s2)
	_s2["stageOf"] = Callable(self, "_f22").bind(_s2)
	_s2["held"] = Callable(self, "_f23").bind(_s2)
	_s2["isLost"] = Callable(self, "_f25").bind(_s2)
	_s2["gday"] = Callable(self, "_f27").bind(_s2)
	_s2["turfTick"] = Callable(self, "_f28").bind(_s2)
	v_turfTag_31 = Callable(self, "_f30").bind(_s2)
	v_turfHead_32 = Callable(self, "_f31").bind(_s2)
	_s2["retake"] = Callable(self, "_f33").bind(_s2)
	v_kitHTML_35 = Callable(self, "_f35").bind(_s2)
	v_bindKit_36 = Callable(self, "_f37").bind(_s2)
	_s2["init"] = Callable(self, "_f40").bind(_s2)
	v_D_2 = Callable(self, "_f2").bind(_s2)
	_s2["DAY"] = 86400000.0
	_s2["HOUR"] = 3600000.0
	_s2["W"] = {"breath": "吹氣", "light": "燈", "cold": "凍", "sound": "怪聲", "paper": "紙", "phone": "電話", "face": "鬼臉", "shadow": "黑影"}
	_s2["TYPES"] = J.S_Object_("keys", [_s2["W"]])
	_s2["has"] = Callable(self, "_f3").bind(_s2)
	_s2["EFEAR"] = {"youhun": {"w": ["light", "sound"], "i": ["breath"], "why": "飄慣了，吹氣嚇不到"}, "egui": {"w": ["face", "cold"], "i": ["sound"], "why": "肚子叫得比你還大聲"}, "xiaogui": {"w": ["shadow", "sound"], "i": ["face"], "why": "自己最愛扮鬼臉"}, "zombie": {"w": ["light", "breath"], "i": ["cold"], "why": "屍體本來就是凍的"}, "shuigui": {"w": ["light", "paper"], "i": ["cold"], "why": "泡在水裡泡慣了"}, "zhiren": {"w": ["light", "breath"], "i": ["paper"], "why": "自己就是紙"}, "niutou": {"w": ["phone", "paper"], "i": ["face"], "why": "自己個樣已經夠嚇人"}, "mamian": {"w": ["phone", "sound"], "i": ["face"], "why": "自己個樣已經夠嚇人"}, "eguiking": {"w": ["face", "shadow"], "i": ["sound"], "why": "肚子打鼓打了五百年"}, "toyol": {"w": ["light", "face"], "i": ["sound"], "why": "偷錢從來不怕聲響"}, "laojiang": {"w": ["light", "breath"], "i": ["cold"], "why": "躺了兩百年棺材"}, "pontianak": {"w": ["phone", "light"], "i": ["sound"], "why": "笑聲是她的專利"}, "pocong": {"w": ["shadow", "paper"], "i": ["breath"], "why": "包得密密實實"}, "penanggal": {"w": ["light", "cold"], "i": ["face"], "why": "飛頭比你更嚇人"}, "baiwu": {"w": ["phone", "paper"], "i": ["face"], "why": "舌頭比你長"}, "heiwu": {"w": ["phone", "light"], "i": ["sound"], "why": "整天拖鐵鏈"}, "huang": {"w": ["phone", "paper"], "i": ["face"], "why": "最怕電話響和新文件"}}
	_s2["cache"] = {}
	_s2["word"] = Callable(self, "_f9").bind(_s2)
	_s2["DRILL"] = [0.0, 300.0, 1000.0, 2500.0, 5000.0]
	_s2["GANGS"] = [{"name": "鄰村・夜冷村", "boss": "Bryan", "line": J.cl(v_D_2, null, ["Bryan：「呢度？我哋夜冷村接手喇。你慢慢跑，我哋慢慢嚇。」", "Bryan：「這裡？我們夜冷村接手了。你慢慢跑，我們慢慢嚇。」"])}, {"name": "鄰村・夜冷村", "boss": "Bryan", "line": J.cl(v_D_2, null, ["Bryan：「你嗰度啲人怕咩，我全部抄低咗。多謝分享。」", "Bryan：「你那邊的人怕什麼，我全部抄下來了。謝謝分享。」"])}, {"name": "無牌鬼幫", "boss": "", "line": J.cl(v_D_2, null, ["一班無牌鬼插咗支旗：「呢度而家我哋話事，KPI 我哋計。」", "一群無牌鬼插了一支旗：「這裡現在我們說了算，KPI 我們來算。」"])}, {"name": "過江鬼聯盟", "boss": "", "line": J.cl(v_D_2, null, ["一群過江鬼：「我哋喺第二區冇人驚，過嚟借你地方用下。」", "一群過江鬼：「我們在別區沒人怕，過來借你的地方用一下。」"])}]
	_s2["clock"] = Callable(self, "_f26").bind(_s2)
	_s2["KITS"] = {"offer": {"name": "供品", "cost": {"buns": 40.0}, "desc": "開局陰氣 +30"}, "props": {"name": "道具箱", "cost": {"planks": 60.0}, "desc": "機關冷卻減半"}}
	_s2["started"] = false
	J.cl(Callable(self, "_f51").bind(_s2), null, [])
	return {"W": _s2["W"], "TYPES": _s2["TYPES"], "word": _s2["word"], "fearOf": _s2["fearOf"], "fearLine": _s2["fearLine"], "enemyHint": v_enemyHint_15, "teamHint": v_teamHint_16, "typesOf": _s2["typesOf"], "drillXp": _s2["drillXp"], "drillLv": _s2["drillLv"], "drillNext": v_drillNext_21, "DRILL": _s2["DRILL"], "turf": _s2["turf"], "held": _s2["held"], "isLost": _s2["isLost"], "turfTag": v_turfTag_31, "turfHead": v_turfHead_32, "turfTick": _s2["turfTick"], "retake": _s2["retake"], "GANGS": _s2["GANGS"], "KITS": _s2["KITS"], "kitHTML": v_kitHTML_35, "bindKit": v_bindKit_36, "stageOf": _s2["stageOf"]}
