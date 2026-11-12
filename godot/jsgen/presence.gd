# 自動轉譯自 presence.js（tools/jsgd.js）——唔好直接改，改原 JS 再轉
extends RefCounted

func run(env):
	var this_ = null; var a = []
	J.G["Presence"] = J.cl(Callable(self, "_f1").bind(env), null, [])
	J.cl(Callable(self, "_f112").bind(env), null, [])

func _f7(this_, a: Array, env):
	var v_p_67 = null
	var _t1 = J.cl(env["S_"], null, [])
	v_p_67 = (J.gp(J.G.get("S"), "presence") if J.t(_t1) else _t1)
	var _t3 = J.S_Date_("now", [])
	var _t2 = (J.gp(v_p_67, "skew") if J.t(v_p_67) else v_p_67)
	return J.add(_t3, (_t2 if J.t(_t2) else 0.0))

func _f8(this_, a: Array, env):
	var v_ms_70 = null; var v_d_71 = null
	v_ms_70 = J.arg(a, 0)
	v_d_71 = J.new_("Date", [v_ms_70])
	return floor(J.num(J.div(J.sub(v_ms_70, J.mul(J.mc(v_d_71, "getTimezoneOffset", []), 60000.0)), env["DAY"])))

func _f10(this_, a: Array, env):
	var v_g_75 = null
	v_g_75 = J.arg(a, 0)
	if (not J.seq(J.typeof_(J.gp(J.gp(env["p"], "p"), J.gp(v_g_75, "id"))), "number")):
		var _t42 = J.gp(env["p"], "p")
		var _t43 = J.gp(v_g_75, "id")
		J.sp(_t42, _t43, 100.0)

func _f9(this_, a: Array, env):
	var _s10 = {"__p": env, "p": null}
	if (not J.t(J.cl(_s10["__p"]["S_"], null, []))):
		return null
	if (not J.t(J.gp(J.G.get("S"), "presence"))):
		var _t4 = J.G.get("S")
		var _t6 = {}
		var _t7 = J.S_Date_("now", [])
		var _t8 = J.add(J.S_Date_("now", []), J.mul(J.gp(_s10["__p"]["TUNE"], "GRACE"), _s10["__p"]["DAY"]))
		var _t9 = {}
		var _t10 = {}
		var _t11 = []
		var _t12 = {}
		var _t5 = _s10["__p"]["gday"]
		var _t13 = {"v": 1.0, "p": _t6, "t": _t7, "grace": _t8, "skew": 0.0, "warn": _t9, "cd": _t10, "gone": _t11, "haunt": _t12, "day": J.cl(_t5, null, [J.S_Date_("now", [])]), "mailed": {}}
		J.sp(_t4, "presence", _t13)
	_s10["p"] = J.gp(J.G.get("S"), "presence")
	var _t14 = _s10["p"]
	var _t15 = J.gp(_s10["p"], "p")
	var _t16 = (_t15 if J.t(_t15) else {})
	J.sp(_t14, "p", _t16)
	var _t17 = _s10["p"]
	var _t18 = J.gp(_s10["p"], "warn")
	var _t19 = (_t18 if J.t(_t18) else {})
	J.sp(_t17, "warn", _t19)
	var _t20 = _s10["p"]
	var _t21 = J.gp(_s10["p"], "cd")
	var _t22 = (_t21 if J.t(_t21) else {})
	J.sp(_t20, "cd", _t22)
	var _t23 = _s10["p"]
	var _t24 = J.gp(_s10["p"], "gone")
	var _t25 = (_t24 if J.t(_t24) else [])
	J.sp(_t23, "gone", _t25)
	var _t26 = _s10["p"]
	var _t27 = J.gp(_s10["p"], "haunt")
	var _t28 = (_t27 if J.t(_t27) else {})
	J.sp(_t26, "haunt", _t28)
	var _t29 = _s10["p"]
	var _t30 = J.gp(_s10["p"], "mailed")
	var _t31 = (_t30 if J.t(_t30) else {})
	J.sp(_t29, "mailed", _t31)
	if (not J.seq(J.typeof_(J.gp(_s10["p"], "skew")), "number")):
		var _t32 = _s10["p"]
		J.sp(_t32, "skew", 0.0)
	if (not J.t(J.gp(_s10["p"], "t"))):
		var _t33 = _s10["p"]
		var _t34 = J.cl(_s10["__p"]["clock"], null, [])
		J.sp(_t33, "t", _t34)
	if J.leq(J.gp(_s10["p"], "grace"), null):
		var _t35 = _s10["p"]
		var _t36 = J.add(J.cl(_s10["__p"]["clock"], null, []), J.mul(J.gp(_s10["__p"]["TUNE"], "GRACE"), _s10["__p"]["DAY"]))
		J.sp(_t35, "grace", _t36)
	if J.leq(J.gp(_s10["p"], "day"), null):
		var _t37 = _s10["p"]
		var _t38 = _s10["__p"]["gday"]
		var _t39 = J.cl(_t38, null, [J.cl(_s10["__p"]["clock"], null, [])])
		J.sp(_t37, "day", _t39)
	var _t40 = J.gp(J.G.get("S"), "ghosts")
	var _t41 = (_t40 if J.t(_t40) else [])
	J.mc(_t41, "forEach", [Callable(self, "_f10").bind(_s10)])
	return _s10["p"]

func _f11(this_, a: Array, env):
	var v_c_78 = null
	if (not J.t(J.cl(env["S_"], null, []))):
		return null
	var _t44 = J.G.get("S")
	var _t45 = J.gp(J.G.get("S"), "contract")
	var _t46 = (_t45 if J.t(_t45) else {"rank": 0.0, "state": "none", "start": 0.0, "end": 0.0, "kpi": 0.0, "target": 0.0, "taunted": false, "crisis": null, "hist": []})
	J.sp(_t44, "contract", _t46)
	v_c_78 = _t46
	var _t47 = J.gp(v_c_78, "hist")
	var _t48 = (_t47 if J.t(_t47) else [])
	J.sp(v_c_78, "hist", _t48)
	return v_c_78

func _f13(this_, a: Array, env):
	var v_g_82 = null; var v_p_83 = null
	v_g_82 = J.arg(a, 0)
	v_p_83 = J.cl(env["st"], null, [])
	return ((J.gp(J.gp(v_p_83, "p"), J.gp(v_g_82, "id")) if J.seq(J.typeof_(J.gp(J.gp(v_p_83, "p"), J.gp(v_g_82, "id"))), "number") else 100.0) if J.t((v_g_82 if J.t(v_p_83) else v_p_83)) else 100.0)

func _f14(this_, a: Array, env):
	var v_g_86 = null; var v_v_87 = null; var v_p_88 = null
	v_g_86 = J.arg(a, 0)
	v_v_87 = J.arg(a, 1)
	v_p_88 = J.cl(env["st"], null, [])
	var _t49 = J.gp(v_p_88, "p")
	var _t50 = J.gp(v_g_86, "id")
	var _t51 = J.max_([0.0, J.min_([100.0, v_v_87])])
	J.sp(_t49, _t50, _t51)
	if J.cmp(J.gp(J.gp(v_p_88, "p"), J.gp(v_g_86, "id")), J.add(J.gp(env["TUNE"], "WARN"), 5.0), ">"):
		J.del(J.gp(v_p_88, "warn"), J.gp(v_g_86, "id"))
	if J.cmp(J.gp(J.gp(v_p_88, "p"), J.gp(v_g_86, "id")), J.gp(env["TUNE"], "COUNT"), ">"):
		J.del(J.gp(v_p_88, "cd"), J.gp(v_g_86, "id"))

func _f15(this_, a: Array, env):
	var v_g_91 = null; var v_amt_92 = null
	v_g_91 = J.arg(a, 0)
	v_amt_92 = J.arg(a, 1)
	if (not J.t(v_g_91)):
		return null
	var _t52 = env["isAfu"]
	var _t53 = J.cl(_t52, null, [v_g_91])
	if J.t((J.seq(J.gp(J.cl(env["cst"], null, []), "state"), "crisis") if J.t(_t53) else _t53)):
		return null
	var _t54 = env["set"]
	var _t55 = env["val"]
	J.cl(_t54, null, [v_g_91, J.add(J.cl(_t55, null, [v_g_91]), v_amt_92)])

func _f16(this_, a: Array, env):
	var v_name_95 = null; var v_r_96 = null
	v_name_95 = J.arg(a, 0)
	var _t56 = J.cl(env["cst"], null, [])
	var _t57 = (J.gp(J.cl(env["cst"], null, []), "rank") if J.t(_t56) else _t56)
	v_r_96 = (_t57 if J.t(_t57) else 0.0)
	if J.seq(v_name_95, "squad"):
		return ((1.0 if J.cmp(v_r_96, 1.0, ">=") else 0.0) + (1.0 if J.cmp(v_r_96, 3.0, ">=") else 0.0))
	if J.seq(v_name_95, "decay"):
		return (0.7 if J.cmp(v_r_96, 4.0, ">=") else (0.85 if J.cmp(v_r_96, 1.0, ">=") else 1.0))
	if J.seq(v_name_95, "ripple"):
		return (3.0 if J.cmp(v_r_96, 2.0, ">=") else 0.0)
	if J.seq(v_name_95, "atk"):
		return (1.05 if J.cmp(v_r_96, 4.0, ">=") else (1.03 if J.cmp(v_r_96, 2.0, ">=") else 1.0))
	return 0.0

func _f18(this_, a: Array, env):
	var v_s_114 = null
	v_s_114 = J.arg(a, 0)
	var _t93 = J.seq(J.gp(v_s_114, "kind"), "farewell")
	return (J.seq(J.gp(v_s_114, "g"), env["g"]) if _t93 else _t93)

func _f17(this_, a: Array, env):
	var v_p_99 = null; var v_c_100 = null; var v_now_101 = null; var v_from_102 = null; var v_dt_103 = null; var v_offline_104 = null; var v_newWarn_105 = null; var v_today_106 = null; var v_d_107 = null; var v_g_108 = null; var v_v_109 = null; var v_a_110 = null; var v_v_112 = null; var v_e_113 = null; var v_g_115 = null; var v_locs_116 = null; var v_s_117 = null; var v_l_118 = null
	v_p_99 = J.cl(env["st"], null, [])
	v_c_100 = J.cl(env["cst"], null, [])
	if (not J.t(v_p_99)):
		return null
	v_now_101 = J.cl(env["clock"], null, [])
	v_from_102 = J.max_([J.gp(v_p_99, "t"), J.gp(v_p_99, "grace")])
	v_dt_103 = J.max_([0.0, J.sub(v_now_101, v_from_102)])
	v_offline_104 = (J.sub(v_now_101, J.gp(v_p_99, "t")) > J.mul(6.0, env["HOUR"]))
	J.sp(v_p_99, "t", v_now_101)
	if J.cmp(v_dt_103, 0.0, ">"):
		var _t59 = J.gp(env["TUNE"], "DECAY")
		var _t58 = env["perk"]
		v_d_107 = J.div(J.mul(J.mul(_t59, J.cl(_t58, null, ["decay"])), v_dt_103), env["DAY"])
		for _t60 in J.iter(J.gp(J.G.get("S"), "ghosts")):
			v_g_108 = _t60
			var _t61 = env["val"]
			v_v_109 = J.sub(J.cl(_t61, null, [v_g_108]), v_d_107)
			var _t62 = env["isAfu"]
			if J.t(J.cl(_t62, null, [v_g_108])):
				var _t65 = null
				if J.seq(J.gp(v_c_100, "state"), "crisis"):
					var _t63 = env["val"]
					var _t64 = env["val"]
					_t65 = J.min_([J.cl(_t64, null, [v_g_108]), 18.0])
				else:
					_t65 = J.max_([J.gp(env["TUNE"], "AFU_FLOOR"), v_v_109])
				v_v_109 = _t65
			else:
				if J.t(((not J.t(J.gp(J.gp(v_p_99, "warn"), J.gp(v_g_108, "id")))) if J.t(v_offline_104) else v_offline_104)):
					var _t66 = env["val"]
					var _t67 = env["val"]
					var _t68 = env["val"]
					var _t69 = env["val"]
					var _t70 = J.max_([J.min_([J.cl(_t69, null, [v_g_108]), J.gp(env["TUNE"], "OFFLINE_FLOOR")]), v_v_109])
					v_v_109 = _t70
			var _t71 = J.gp(v_p_99, "p")
			var _t72 = J.gp(v_g_108, "id")
			var _t73 = J.max_([0.0, J.min_([100.0, v_v_109])])
			J.sp(_t71, _t72, _t73)
	if J.seq(J.gp(v_c_100, "state"), "crisis"):
		var _t74 = J.gp(J.G.get("S"), "ghosts")
		v_a_110 = J.mc(_t74, "find", [env["isAfu"]])
		if J.t(v_a_110):
			var _t75 = J.gp(v_p_99, "p")
			var _t76 = J.gp(v_a_110, "id")
			var _t77 = env["val"]
			var _t78 = env["val"]
			var _t79 = J.min_([J.cl(_t78, null, [v_a_110]), 18.0])
			J.sp(_t75, _t76, _t79)
	v_newWarn_105 = []
	for _t80 in J.iter(J.gp(J.G.get("S"), "ghosts")):
		var _s23 = {"__p": env, "g": null}
		_s23["g"] = _t80
		var _t81 = _s23["__p"]["isAfu"]
		if J.t(J.cl(_t81, null, [_s23["g"]])):
			continue
		var _t82 = _s23["__p"]["val"]
		v_v_112 = J.cl(_t82, null, [_s23["g"]])
		var _t83 = J.cmp(v_v_112, J.gp(_s23["__p"]["TUNE"], "WARN"), "<=")
		if ((not J.t(J.gp(J.gp(v_p_99, "warn"), J.gp(_s23["g"], "id")))) if _t83 else _t83):
			var _t84 = J.gp(v_p_99, "warn")
			var _t85 = J.gp(_s23["g"], "id")
			J.sp(_t84, _t85, 1.0)
			J.mc(v_newWarn_105, "push", [_s23["g"]])
		var _t86 = J.cmp(v_v_112, J.gp(_s23["__p"]["TUNE"], "COUNT"), "<=")
		var _t87 = (J.gp(J.gp(v_p_99, "warn"), J.gp(_s23["g"], "id")) if _t86 else _t86)
		if J.t(((not J.t(J.gp(J.gp(v_p_99, "cd"), J.gp(_s23["g"], "id")))) if J.t(_t87) else _t87)):
			var _t88 = J.gp(v_p_99, "cd")
			var _t89 = J.gp(_s23["g"], "id")
			var _t90 = J.add(v_now_101, J.mul(J.gp(_s23["__p"]["TUNE"], "CD_DAYS"), _s23["__p"]["DAY"]))
			J.sp(_t88, _t89, _t90)
			J.mc(J.G.get("Fx"), "toast", [("<b>" + J.str(J.gp(_s23["g"], "name")) + "</b> 存在感只剩 " + J.str(J.round(J.num(v_v_112))) + "：魂飛魄散倒數 " + J.str(J.gp(_s23["__p"]["TUNE"], "CD_DAYS")) + " 日")])
		var _t91 = J.gp(J.gp(v_p_99, "cd"), J.gp(_s23["g"], "id"))
		var _t92 = (J.cmp(v_now_101, J.gp(J.gp(v_p_99, "cd"), J.gp(_s23["g"], "id")), ">=") if J.t(_t91) else _t91)
		var _t94 = (J.cmp(v_v_112, J.gp(_s23["__p"]["TUNE"], "COUNT"), "<=") if J.t(_t92) else _t92)
		if J.t(((not J.t(J.mc(_s23["__p"]["scenes"], "some", [Callable(self, "_f18").bind(_s23)]))) if J.t(_t94) else _t94)):
			J.mc(_s23["__p"]["scenes"], "push", [{"kind": "farewell", "g": _s23["g"]}])
	if J.t(J.len(v_newWarn_105)):
		J.mc(env["scenes"], "push", [{"kind": "mail", "list": v_newWarn_105}])
	var _t95 = env["gday"]
	v_today_106 = J.cl(_t95, null, [v_now_101])
	if (not J.seq(v_today_106, J.gp(v_p_99, "day"))):
		J.sp(v_p_99, "day", v_today_106)
		for _t96 in J.iter(J.gp(J.G.get("S"), "ghosts")):
			v_g_115 = _t96
			v_locs_116 = J.gp(J.gp(v_p_99, "haunt"), J.gp(v_g_115, "id"))
			var _t97 = (not J.t(v_locs_116))
			if (_t97 if _t97 else (not J.t(J.len(v_locs_116)))):
				continue
			v_s_117 = 0.0
			for _t98 in J.iter(v_locs_116):
				v_l_118 = _t98
				var _t99 = env["legendLv"]
				var _t100 = J.add(v_s_117, J.cl(_t99, null, [v_l_118]))
				v_s_117 = _t100
			if J.cmp(v_s_117, 0.0, ">"):
				var _t101 = env["add"]
				J.cl(_t101, null, [v_g_115, J.min_([J.gp(env["TUNE"], "DAILY_LEGEND"), v_s_117])])

func _f19(this_, a: Array, env):
	var v_loc_121 = null; var v_r_122 = null; var v_e_123 = null
	v_loc_121 = J.arg(a, 0)
	var _t102 = (not J.seq(J.typeof_(J.G.get("Scare")), "undefined"))
	if J.t((J.gp(J.G.get("Scare"), "legend") if _t102 else _t102)):
		v_r_122 = J.mc(J.G.get("Scare"), "legend", [v_loc_121])
		var _t106 = null
		if J.seq(J.typeof_(v_r_122), "number"):
			_t106 = v_r_122
		else:
			var _t105 = v_r_122
			if J.t(_t105):
				var _t103 = J.gp(v_r_122, "lv")
				var _t104 = (_t103 if J.t(_t103) else J.gp(v_r_122, "legendLv"))
				_t105 = (_t104 if J.t(_t104) else J.gp(v_r_122, "level"))
			_t106 = (_t105 if J.t(_t105) else 0.0)
		return _t106
	return 0.0

func _f20(this_, a: Array, env):
	var v_g_126 = null; var v_p_127 = null
	v_g_126 = J.arg(a, 0)
	v_p_127 = J.cl(env["st"], null, [])
	return (J.max_([0.0, ceil(J.num(J.div(J.sub(J.gp(J.gp(v_p_127, "cd"), J.gp(v_g_126, "id")), J.cl(env["clock"], null, [])), env["DAY"])))]) if J.t(J.gp(J.gp(v_p_127, "cd"), J.gp(v_g_126, "id"))) else null)

func _f22(this_, a: Array, env):
	var v_g_131 = null
	v_g_131 = J.arg(a, 0)
	return J.seq(J.gp(v_g_131, "id"), env["key"])

func _f23(this_, a: Array, env):
	var v_g_132 = null
	v_g_132 = J.arg(a, 0)
	return J.seq(J.gp(v_g_132, "k"), env["key"])

func _f21(this_, a: Array, env):
	var _s41 = {"__p": env, "key": null}
	_s41["key"] = J.arg(a, 0)
	var _t107 = J.gp(J.G.get("S"), "ghosts")
	var _t109 = J.mc(_t107, "find", [Callable(self, "_f22").bind(_s41)])
	if not J.t(_t109):
		var _t108 = J.gp(J.G.get("S"), "ghosts")
		_t109 = J.mc(_t108, "find", [Callable(self, "_f23").bind(_s41)])
	return _t109

func _f24(this_, a: Array, env):
	var v_d_135 = null; var v_p_136 = null; var v_c_137 = null; var v_stars_138 = null; var v_lv_139 = null; var v_ripple_140 = null; var v_squad_141 = null; var v_per_142 = null; var v_sq_143 = null; var v_pts_144 = null; var v_k_145 = null; var v_g_146 = null; var v_g_147 = null; var v_a_148 = null; var v_sc_149 = null; var v_b_150 = null; var v_h_151 = null; var v_e_152 = null; var v_e_153 = null
	v_d_135 = J.arg(a, 0)
	var _t110 = (not J.t(J.cl(env["S_"], null, [])))
	if (_t110 if _t110 else (not J.t(v_d_135))):
		return null
	J.cl(env["update"], null, [])
	v_p_136 = J.cl(env["st"], null, [])
	v_c_137 = J.cl(env["cst"], null, [])
	v_stars_138 = J.max_([0.0, J.min_([3.0, J.bor(J.gp(v_d_135, "stars"), 0.0)])])
	v_lv_139 = J.bor(J.gp(v_d_135, "legendLv"), 0.0)
	var _t112 = J.add(J.gp(env["TUNE"], "RIPPLE"), J.mul(J.gp(env["TUNE"], "RIPPLE_STAR"), v_stars_138))
	var _t111 = env["perk"]
	v_ripple_140 = J.add(_t112, J.cl(_t111, null, ["ripple"]))
	var _t113 = J.gp(v_d_135, "ghosts")
	var _t114 = (_t113 if J.t(_t113) else [])
	var _t115 = J.mc(_t114, "map", [env["findG"]])
	v_squad_141 = J.new_("Set", [J.mc(_t115, "filter", [J.G.get("Boolean")])])
	var _t116 = J.gp(v_d_135, "perGhost")
	v_per_142 = (_t116 if J.t(_t116) else {})
	for _t117 in J.keys(v_per_142):
		v_k_145 = _t117
		var _t118 = env["findG"]
		v_g_146 = J.cl(_t118, null, [v_k_145])
		if J.t(v_g_146):
			J.mc(v_squad_141, "add", [v_g_146])
	var _t119 = J.seq(J.gp(v_c_137, "state"), "crisis")
	if (J.cmp(v_stars_138, 1.0, ">=") if _t119 else _t119):
		pass
	v_sq_143 = 0.0
	for _t120 in J.iter(J.gp(J.G.get("S"), "ghosts")):
		v_g_147 = _t120
		var _t121 = env["isAfu"]
		var _t122 = J.cl(_t121, null, [v_g_147])
		if J.t((J.seq(J.gp(v_c_137, "state"), "crisis") if J.t(_t122) else _t122)):
			continue
		v_a_148 = v_ripple_140
		if J.t(J.mc(v_squad_141, "has", [v_g_147])):
			var _t123 = J.gp(v_per_142, J.gp(v_g_147, "id"))
			var _t124 = (_t123 if J.t(_t123) else J.gp(v_per_142, J.gp(v_g_147, "k")))
			v_sc_149 = J.bor(J.gp((_t124 if J.t(_t124) else {}), "scares"), 0.0)
			v_b_150 = J.min_([J.gp(env["TUNE"], "SQUAD_CAP"), J.add(J.gp(env["TUNE"], "SQUAD"), J.mul(J.gp(env["TUNE"], "SQUAD_SCARE"), J.min_([6.0, v_sc_149])))])
			var _t125 = J.add(v_a_148, v_b_150)
			v_a_148 = _t125
			var _t126 = J.max_([v_sq_143, v_b_150])
			v_sq_143 = _t126
			if J.t(J.gp(v_d_135, "loc")):
				var _t127 = J.gp(v_p_136, "haunt")
				var _t128 = J.gp(v_g_147, "id")
				var _t129 = J.gp(J.gp(v_p_136, "haunt"), J.gp(v_g_147, "id"))
				var _t130 = (_t129 if J.t(_t129) else [])
				J.sp(_t127, _t128, _t130)
				v_h_151 = _t130
				if (not J.t(J.mc(v_h_151, "includes", [J.gp(v_d_135, "loc")]))):
					J.mc(v_h_151, "push", [J.gp(v_d_135, "loc")])
		else:
			var _t131 = J.gp(v_d_135, "loc")
			var _t133 = (J.gp(J.gp(v_p_136, "haunt"), J.gp(v_g_147, "id")) if J.t(_t131) else _t131)
			if J.t(_t133):
				var _t132 = J.gp(J.gp(v_p_136, "haunt"), J.gp(v_g_147, "id"))
				_t133 = J.mc(_t132, "includes", [J.gp(v_d_135, "loc")])
			if J.t(_t133):
				var _t134 = J.add(v_a_148, J.mul(J.gp(env["TUNE"], "LEGEND"), v_lv_139))
				v_a_148 = _t134
		var _t135 = env["set"]
		var _t136 = env["val"]
		J.cl(_t135, null, [v_g_147, J.add(J.cl(_t136, null, [v_g_147]), v_a_148)])
	var _t137 = env["kpiOf"]
	v_pts_144 = J.cl(_t137, null, [v_d_135])
	if J.seq(J.gp(v_c_137, "state"), "active"):
		var _t138 = J.add(J.gp(v_c_137, "kpi"), v_pts_144)
		J.sp(v_c_137, "kpi", _t138)
	var _t139 = J.seq(J.gp(v_c_137, "state"), "crisis")
	if (J.cmp(v_stars_138, 1.0, ">=") if _t139 else _t139):
		var _t140 = J.gp(v_c_137, "crisis")
		J.sp(_t140, "ok", true)
	J.mc(J.G.get("Fx"), "toast", [("回陽間收工：全村存在感 +" + J.str(v_ripple_140) + (("，出動的鬼再 +" + J.str(v_sq_143)) if J.t(v_sq_143) else "") + (("；合約 KPI +" + J.str(v_pts_144)) if J.seq(J.gp(v_c_137, "state"), "active") else ""))])
	J.cl(J.G.get("save"), null, [])
	return {"ripple": v_ripple_140, "squad": v_sq_143, "pts": v_pts_144}

func _f25(this_, a: Array, env):
	var v_d_156 = null; var v_stars_157 = null
	v_d_156 = J.arg(a, 0)
	v_stars_157 = J.max_([0.0, J.min_([3.0, J.bor(J.gp(v_d_156, "stars"), 0.0)])])
	return (((J.mul(10.0, v_stars_157) + J.min_([25.0, (5.0 * J.bor(J.gp(v_d_156, "legendLv"), 0.0))])) + (5.0 if (J.bor(J.gp(v_d_156, "score"), 0.0) > 0.0) else 0.0)) - (5.0 if J.t(J.gp(v_d_156, "exorcised")) else 0.0))

func _f26(this_, a: Array, env):
	var v_i_160 = null
	v_i_160 = J.arg(a, 0)
	return J.gp(J.G.get("PRES_RANKS"), J.min_([v_i_160, (J.len(J.G.get("PRES_RANKS")) - 1.0)]))

func _f27(this_, a: Array, env):
	var v_extra_163 = null; var v_c_164 = null; var v_r_165 = null; var v_now_166 = null
	v_extra_163 = J.arg(a, 0)
	v_c_164 = J.cl(env["cst"], null, [])
	var _t141 = env["rankOf"]
	v_r_165 = J.cl(_t141, null, [J.gp(v_c_164, "rank")])
	v_now_166 = J.cl(env["clock"], null, [])
	J.S_Object_("assign", [v_c_164, {"state": "active", "start": v_now_166, "end": J.add(v_now_166, J.mul(J.add(J.gp(v_r_165, "days"), (v_extra_163 if J.t(v_extra_163) else 0.0)), env["DAY"])), "kpi": 0.0, "target": J.gp(v_r_165, "target"), "taunted": false, "crisis": null}])

func _f30(this_, a: Array, env):
	var v_c_171 = null; var v_now_172 = null; var v_a_173 = null; var v_el_174 = null
	v_c_171 = J.cl(env["cst"], null, [])
	v_now_172 = J.cl(env["clock"], null, [])
	var _t142 = J.gp(J.G.get("S"), "ghosts")
	v_a_173 = J.mc(_t142, "find", [env["isAfu"]])
	if J.seq(J.gp(v_c_171, "state"), "none"):
		var _t143 = env["seen"]
		var _t145 = J.cl(_t143, null, ["ch1_end"])
		if J.t(_t145):
			var _t144 = env["has"]
			_t145 = (not J.t(J.cl(_t144, null, ["issue"])))
		if J.t(_t145):
			J.mc(env["scenes"], "push", [{"kind": "issue"}])
		return null
	if J.seq(J.gp(v_c_171, "state"), "active"):
		var _t147 = J.cmp(J.gp(v_c_171, "kpi"), J.gp(v_c_171, "target"), ">=")
		if J.t(_t147):
			var _t146 = env["has"]
			_t147 = (not J.t(J.cl(_t146, null, ["promote"])))
		if _t147:
			J.mc(env["scenes"], "push", [{"kind": "promote"}])
			return null
		var _t148 = J.cmp(v_now_172, J.gp(v_c_171, "end"), ">=")
		var _t150 = (J.cmp(J.gp(v_c_171, "kpi"), J.gp(v_c_171, "target"), "<") if _t148 else _t148)
		if J.t(_t150):
			var _t149 = env["has"]
			_t150 = (not J.t(J.cl(_t149, null, ["crisis"])))
		if _t150:
			J.mc(env["scenes"], "push", [{"kind": "crisis"}])
			return null
		v_el_174 = J.div(J.sub(v_now_172, J.gp(v_c_171, "start")), J.sub(J.gp(v_c_171, "end"), J.gp(v_c_171, "start")))
		var _t151 = (not J.t(J.gp(v_c_171, "taunted")))
		var _t152 = (J.cmp(v_el_174, 0.55, ">") if _t151 else _t151)
		var _t154 = (J.cmp(J.gp(v_c_171, "kpi"), J.mul(J.gp(v_c_171, "target"), 0.5), "<") if _t152 else _t152)
		if J.t(_t154):
			var _t153 = env["has"]
			_t154 = (not J.t(J.cl(_t153, null, ["taunt"])))
		if _t154:
			J.mc(env["scenes"], "push", [{"kind": "taunt"}])
	if J.seq(J.gp(v_c_171, "state"), "crisis"):
		if J.t(v_a_173):
			var _t155 = J.gp(J.cl(env["st"], null, []), "p")
			var _t156 = J.gp(v_a_173, "id")
			var _t157 = env["val"]
			var _t158 = env["val"]
			var _t159 = J.min_([J.cl(_t158, null, [v_a_173]), 18.0])
			J.sp(_t155, _t156, _t159)
		var _t161 = J.gp(J.gp(v_c_171, "crisis"), "ok")
		if J.t(_t161):
			var _t160 = env["has"]
			_t161 = (not J.t(J.cl(_t160, null, ["redeem"])))
		if J.t(_t161):
			J.mc(env["scenes"], "push", [{"kind": "redeem"}])
		else:
			var _t162 = (not J.t(J.gp(J.gp(v_c_171, "crisis"), "ok")))
			var _t164 = (J.cmp(v_now_172, J.gp(J.gp(v_c_171, "crisis"), "end"), ">=") if _t162 else _t162)
			if J.t(_t164):
				var _t163 = env["has"]
				_t164 = (not J.t(J.cl(_t163, null, ["more"])))
			if _t164:
				J.mc(env["scenes"], "push", [{"kind": "more"}])

func _f31(this_, a: Array, env):
	var v_n_177 = null; var v_k_178 = null
	v_n_177 = J.arg(a, 0)
	if J.t(J.gp(env["ART3"], v_n_177)):
		return J.gp(env["ART3"], v_n_177)
	for _t165 in J.keys(J.G.get("GHOSTS")):
		v_k_178 = _t165
		if J.seq(J.gp(J.gp(J.G.get("GHOSTS"), v_k_178), "name"), v_n_177):
			return v_k_178
	return null

func _f34(this_, a: Array, env):
	var v_g_184 = null
	v_g_184 = J.arg(a, 0)
	return J.seq(J.gp(v_g_184, "k"), env["k"])

func _f33(this_, a: Array, env):
	var _s72 = {"__p": env, "k": null}
	_s72["k"] = J.arg(a, 0)
	var _t167 = J.gp(J.G.get("S"), "ghosts")
	var _t169 = J.mc(_t167, "some", [Callable(self, "_f34").bind(_s72)])
	if J.t(_t169):
		var _t168 = (not J.t(_s72["__p"]["not"]))
		_t169 = (_t168 if _t168 else (not J.seq(_s72["k"], J.gp(_s72["__p"]["not"], "k"))))
	return _t169

func _f35(this_, a: Array, env):
	var v_g_185 = null
	v_g_185 = J.arg(a, 0)
	return J.seq(J.gp(v_g_185, "k"), J.gp(env["pool"], 0.0))

func _f36(this_, a: Array, env):
	var v_g_186 = null
	v_g_186 = J.arg(a, 0)
	var _t172 = env["__p"]["isAfu"]
	var _t173 = (not J.t(J.cl(_t172, null, [v_g_186])))
	var _t174 = ((not J.seq(v_g_186, env["not"])) if _t173 else _t173)
	return (J.gp(J.G.get("GHOSTS"), J.gp(v_g_186, "k")) if _t174 else _t174)

func _f32(this_, a: Array, env):
	var _s71 = {"__p": env, "not": null, "pool": null}
	_s71["not"] = J.arg(a, 0)
	var _t166 = ["xiaozhi", "mengpo", "eguiking", "tianhua", "laojiang", "toyol"]
	_s71["pool"] = J.mc(_t166, "filter", [Callable(self, "_f33").bind(_s71)])
	if J.t(J.len(_s71["pool"])):
		var _t170 = J.gp(J.G.get("S"), "ghosts")
		return J.mc(_t170, "find", [Callable(self, "_f35").bind(_s71)])
	var _t171 = J.gp(J.G.get("S"), "ghosts")
	var _t175 = J.mc(_t171, "find", [Callable(self, "_f36").bind(_s71)])
	return (_t175 if J.t(_t175) else null)

func _f38(this_, a: Array, env):
	var v_w_199 = null
	v_w_199 = J.arg(a, 0)
	return ((J.gp(env["g"], "name") if J.t(env["g"]) else "？") if J.seq(v_w_199, "G") else ((J.gp(env["R"], "name") if J.t(env["R"]) else "小紙") if J.seq(v_w_199, "R") else v_w_199))

func _f39(this_, a: Array, env):
	var v_l_200 = null
	v_l_200 = J.arg(a, 0)
	var _t177 = env["nm"]
	var _t181 = J.cl(_t177, null, [J.gp(v_l_200, 0.0)])
	var _t178 = env["__p"]["T"]
	var _t179 = J.cl(_t178, null, [v_l_200])
	var _t180 = J.mc(_t179, "split", ["{n}"])
	var _t183 = J.mc(_t180, "join", [(J.gp(env["g"], "name") if J.t(env["g"]) else "")])
	var _t182 = J.gp(v_l_200, 3.0)
	return [_t181, _t183, (_t182 if J.t(_t182) else null)]

func _f40(this_, a: Array, env):
	var v_n_202 = null; var v_k_203 = null
	v_n_202 = J.arg(a, 0)
	var _t190 = null
	if J.seq(v_n_202, (J.gp(env["g"], "name") if J.t(env["g"]) else env["g"])):
		_t190 = J.gp(env["g"], "k")
	else:
		var _t189 = null
		if J.seq(v_n_202, (J.gp(env["R"], "name") if J.t(env["R"]) else env["R"])):
			_t189 = J.gp(env["R"], "k")
		else:
			var _t188 = env["__p"]["keyOf"]
			_t189 = J.cl(_t188, null, [v_n_202])
		_t190 = _t189
	v_k_203 = _t190
	return [v_n_202, (v_k_203 if J.t(v_k_203) else "afu"), (J.S_Object_("assign", [{}, J.gp(env["__p"]["LOOK"], v_n_202)]) if J.t(J.gp(env["__p"]["LOOK"], v_n_202)) else null)]

func _f37(this_, a: Array, env):
	var v_lines_189 = null; var v_title_191 = null; var v_tag_192 = null; var v_cb_193 = null; var v_lns_196 = null; var v_names_197 = null; var v_cast_198 = null; var v_l_201 = null
	var _s76 = {"__p": env, "g": null, "R": null, "nm": null}
	v_lines_189 = J.arg(a, 0)
	_s76["g"] = J.arg(a, 1)
	v_title_191 = J.arg(a, 2)
	v_tag_192 = J.arg(a, 3)
	v_cb_193 = J.arg(a, 4)
	var _t176 = _s76["__p"]["reactor"]
	_s76["R"] = J.cl(_t176, null, [_s76["g"]])
	_s76["nm"] = Callable(self, "_f38").bind(_s76)
	v_lns_196 = J.mc(v_lines_189, "map", [Callable(self, "_f39").bind(_s76)])
	v_names_197 = []
	for _t184 in J.iter(v_lns_196):
		v_l_201 = _t184
		var _t185 = (not J.seq(J.gp(v_l_201, 0.0), "旁白"))
		var _t186 = ((not J.seq(J.gp(v_l_201, 0.0), "系統")) if _t185 else _t185)
		if ((not J.t(J.mc(v_names_197, "includes", [J.gp(v_l_201, 0.0)]))) if _t186 else _t186):
			J.mc(v_names_197, "push", [J.gp(v_l_201, 0.0)])
	var _t187 = J.mc(v_names_197, "slice", [0.0, 4.0])
	v_cast_198 = J.mc(_t187, "map", [Callable(self, "_f40").bind(_s76)])
	J.mc(J.G.get("Theater"), "play", [{"tag": v_tag_192, "title": v_title_191, "bg": "village", "cast": v_cast_198, "lines": v_lns_196}, v_cb_193])

func _f42(this_, a: Array, env):
	var v_l_209 = null
	v_l_209 = J.arg(a, 0)
	var _t192 = J.gp(v_l_209, 0.0)
	var _t191 = env["T"]
	return [_t192, J.cl(_t191, null, [v_l_209])]

func _f41(this_, a: Array, env):
	var v_lines_206 = null; var v_title_207 = null; var v_cb_208 = null
	v_lines_206 = J.arg(a, 0)
	v_title_207 = J.arg(a, 1)
	v_cb_208 = J.arg(a, 2)
	J.mc(J.G.get("Story"), "queue", [{"style": "chat", "title": v_title_207, "group": "小紙、孟婆、餓鬼王、Toyol…", "av": ["村", "#3f6a5a"], "lines": J.mc(v_lines_206, "map", [Callable(self, "_f42").bind(env)])}, v_cb_208])

func _f43(this_, a: Array, env):
	var _t194 = env["playing"]
	if not J.t(_t194):
		var _t193 = (not J.seq(J.typeof_(J.G.get("Theater")), "undefined"))
		_t194 = (J.gp(J.G.get("Theater"), "on") if _t193 else _t193)
	if J.t(_t194):
		return false
	var _t195 = (not J.seq(J.typeof_(J.G.get("Skits")), "undefined"))
	if J.t((J.gp(J.G.get("Skits"), "quiet") if _t195 else _t195)):
		return J.mc(J.G.get("Skits"), "quiet", [])
	var _t196 = (not J.seq(J.typeof_(J.G.get("Story")), "undefined"))
	var _t198 = (not J.t((J.mc(J.G.get("Story"), "busy", []) if _t196 else _t196)))
	if J.t(_t198):
		var _t197 = (not J.seq(J.typeof_(J.G.get("Battle")), "undefined"))
		_t198 = (not J.t((J.gp(J.G.get("Battle"), "active") if _t197 else _t197)))
	return _t198

func _f45(this_, a: Array, env):
	var v_e_217 = null; var v_e_218 = null
	env["__p"]["playing"] = false
	env["__p"]["cur"] = null
	env["__p"]["sceneGap"] = 4.0
	J.cl(J.G.get("save"), null, [])
	if J.t(J.gp(J.G.get("UI"), "refresh")):
		J.mc(J.G.get("UI"), "refresh", [])
	J.cl(env["__p"]["hud"], null, [])

func _f46(this_, a: Array, env):
	var v_e_219 = null
	var _t200 = env["__p"]["newPeriod"]
	J.cl(_t200, null, [3.0])
	J.cl(env["done"], null, [])
	J.mc(J.G.get("Fx"), "toast", [("試用期合約：<b>" + J.str(J.add(J.gp(J.gp(J.G.get("PRES_RANKS"), 0.0), "days"), 3.0)) + " 日</b>內 KPI " + J.str(J.gp(J.gp(J.G.get("PRES_RANKS"), 0.0), "target")) + "。右下角可以查看合約。")])

func _f47(this_, a: Array, env):
	var v_e_223 = null; var v_e_224 = null; var v_e_225 = null
	var _t205 = J.gp(env["__p"]["c"], "hist")
	J.mc(_t205, "push", [{"rank": J.gp(env["__p"]["c"], "rank"), "ok": true, "at": J.cl(env["__p"]["__p"]["clock"], null, [])}])
	if (not J.t(env["top"])):
		var _t206 = env["__p"]["c"]
		var _t207 = env["nr"]
		J.sp(_t206, "rank", _t207)
		if J.seq(env["nr"], 3.0):
			var _t208 = J.G.get("give")
			J.cl(_t208, null, [{"coins": 3000.0}])
	else:
		var _t209 = J.G.get("give")
		J.cl(_t209, null, [{"coins": 2000.0}])
	var _t210 = env["__p"]["__p"]["newPeriod"]
	J.cl(_t210, null, [0.0])
	J.cl(env["__p"]["done"], null, [])
	J.mc(J.G.get("Fx"), "toast", [("年度考核過關：花紅 冥幣 2000" if J.t(env["top"]) else ("升職：<b>" + J.str(J.gp(J.gp(J.G.get("PRES_RANKS"), env["nr"]), "name")) + "</b>　解鎖：" + J.str(J.gp(J.gp(J.G.get("PRES_RANKS"), env["nr"]), "unlock"))))])

func _f48(this_, a: Array, env):
	var _t219 = env["__p"]["chat"]
	return J.cl(_t219, null, [J.gp(J.G.get("PRES_TXT"), "crisis_chat"), "落魄村村民群", env["done"]])

func _f49(this_, a: Array, env):
	var v_a_227 = null; var v_e_228 = null
	var _t221 = J.gp(J.G.get("S"), "ghosts")
	v_a_227 = J.mc(_t221, "find", [env["__p"]["isAfu"]])
	var _t222 = env["__p"]["newPeriod"]
	J.cl(_t222, null, [0.0])
	if J.t(v_a_227):
		var _t223 = env["__p"]["set"]
		J.cl(_t223, null, [v_a_227, 100.0])
	J.cl(env["done"], null, [])
	J.mc(J.G.get("Fx"), "toast", ["阿福被記起了：合約重新計日"])

func _f50(this_, a: Array, env):
	var v_g_230 = null
	v_g_230 = J.arg(a, 0)
	var _t228 = J.gp(J.G.get("S"), "ghosts")
	var _t230 = J.mc(_t228, "includes", [v_g_230])
	if J.t(_t230):
		var _t229 = env["__p"]["__p"]["val"]
		_t230 = J.cmp(J.cl(_t229, null, [v_g_230]), J.gp(env["__p"]["__p"]["TUNE"], "WARN"), "<=")
	return _t230

func _f51(this_, a: Array, env):
	var v_g_231 = null
	v_g_231 = J.arg(a, 0)
	return J.gp(v_g_231, "name")

func _f52(this_, a: Array, env):
	var v_l_232 = null
	v_l_232 = J.arg(a, 0)
	var _t237 = J.gp(v_l_232, 0.0)
	var _t234 = env["__p"]["__p"]["T"]
	var _t235 = J.cl(_t234, null, [v_l_232])
	var _t236 = J.mc(_t235, "split", ["{list}"])
	return [_t237, J.mc(_t236, "join", [env["list"]])]

func _f53(this_, a: Array, env):
	var _t243 = env["__p"]["__p"]["vanish"]
	J.cl(_t243, null, [env["g"]])
	J.cl(env["__p"]["done"], null, [])

func _f44(this_, a: Array, env):
	var v_s_214 = null; var v_lines_222 = null; var v_a_226 = null
	var _s84 = {"__p": env, "c": null, "done": null}
	v_s_214 = J.arg(a, 0)
	_s84["c"] = J.cl(_s84["__p"]["cst"], null, [])
	_s84["done"] = Callable(self, "_f45").bind(_s84)
	_s84["__p"]["playing"] = true
	_s84["__p"]["cur"] = J.gp(v_s_214, "kind")
	if J.seq(J.gp(v_s_214, "kind"), "issue"):
		var _t199 = _s84["__p"]["stage"]
		J.cl(_t199, null, [J.gp(J.G.get("PRES_TXT"), "issue"), null, "試用期合約", "合約", Callable(self, "_f46").bind(_s84)])
	else:
		if J.seq(J.gp(v_s_214, "kind"), "taunt"):
			var _t201 = _s84["c"]
			J.sp(_t201, "taunted", true)
			var _t202 = _s84["__p"]["stage"]
			var _t203 = _s84["__p"]["rnd"]
			J.cl(_t202, null, [J.cl(_t203, null, [J.gp(J.G.get("PRES_TXT"), "taunt")]), null, "Bryan 的冷嘲熱諷", "合約", _s84["done"]])
		else:
			if J.seq(J.gp(v_s_214, "kind"), "promote"):
				var _s98 = {"__p": _s84, "top": null, "nr": null}
				_s98["top"] = J.cmp(J.gp(_s98["__p"]["c"], "rank"), (J.len(J.G.get("PRES_RANKS")) - 1.0), ">=")
				_s98["nr"] = J.min_([J.add(J.gp(_s98["__p"]["c"], "rank"), 1.0), (J.len(J.G.get("PRES_RANKS")) - 1.0)])
				v_lines_222 = (J.gp(J.G.get("PRES_TXT"), "renew") if J.t(_s98["top"]) else J.gp(J.gp(J.G.get("PRES_TXT"), "promote"), _s98["nr"]))
				var _t204 = _s98["__p"]["__p"]["stage"]
				J.cl(_t204, null, [v_lines_222, null, ("年度考核" if J.t(_s98["top"]) else ("升職：" + J.str(J.gp(J.gp(J.G.get("PRES_RANKS"), _s98["nr"]), "name")))), "合約", Callable(self, "_f47").bind(_s98)])
			else:
				if J.seq(J.gp(v_s_214, "kind"), "crisis"):
					var _t211 = J.gp(_s84["c"], "hist")
					J.mc(_t211, "push", [{"rank": J.gp(_s84["c"], "rank"), "ok": false, "at": J.cl(_s84["__p"]["clock"], null, [])}])
					var _t212 = _s84["c"]
					J.sp(_t212, "state", "crisis")
					var _t213 = _s84["c"]
					var _t214 = {"end": J.add(J.cl(_s84["__p"]["clock"], null, []), J.mul(3.0, _s84["__p"]["DAY"])), "ok": false}
					J.sp(_t213, "crisis", _t214)
					var _t215 = J.gp(J.G.get("S"), "ghosts")
					v_a_226 = J.mc(_t215, "find", [_s84["__p"]["isAfu"]])
					if J.t(v_a_226):
						var _t216 = J.gp(J.cl(_s84["__p"]["st"], null, []), "p")
						var _t217 = J.gp(v_a_226, "id")
						J.sp(_t216, _t217, 18.0)
					var _t218 = _s84["__p"]["stage"]
					J.cl(_t218, null, [J.gp(J.G.get("PRES_TXT"), "crisis"), null, "淡化危機", "合約", Callable(self, "_f48").bind(_s84)])
				else:
					if J.seq(J.gp(v_s_214, "kind"), "redeem"):
						var _t220 = _s84["__p"]["stage"]
						J.cl(_t220, null, [J.gp(J.G.get("PRES_TXT"), "redeem"), null, "被記起", "合約", Callable(self, "_f49").bind(_s84)])
					else:
						if J.seq(J.gp(v_s_214, "kind"), "more"):
							var _t224 = J.gp(_s84["c"], "crisis")
							var _t225 = J.add(J.cl(_s84["__p"]["clock"], null, []), J.mul(3.0, _s84["__p"]["DAY"]))
							J.sp(_t224, "end", _t225)
							var _t226 = _s84["__p"]["stage"]
							J.cl(_t226, null, [J.gp(J.G.get("PRES_TXT"), "crisis_more"), null, "延期", "合約", _s84["done"]])
						else:
							if J.seq(J.gp(v_s_214, "kind"), "mail"):
								var _s118 = {"__p": _s84, "list": null}
								var _t227 = J.gp(v_s_214, "list")
								var _t231 = J.mc(_t227, "filter", [Callable(self, "_f50").bind(_s118)])
								var _t232 = J.mc(_t231, "map", [Callable(self, "_f51").bind(_s118)])
								_s118["list"] = J.mc(_t232, "join", ["、"])
								if (not J.t(_s118["list"])):
									J.cl(_s118["__p"]["done"], null, [])
									return null
								var _t233 = J.gp(J.G.get("PRES_TXT"), "warn_mail")
								J.mc(J.G.get("Story"), "queue", [{"style": "mail", "title": "存在感不足警告", "lines": J.mc(_t233, "map", [Callable(self, "_f52").bind(_s118)])}, _s118["__p"]["done"]])
							else:
								if J.seq(J.gp(v_s_214, "kind"), "farewell"):
									var _s123 = {"__p": _s84, "g": null}
									_s123["g"] = J.gp(v_s_214, "g")
									var _t238 = J.gp(J.G.get("S"), "ghosts")
									var _t240 = (not J.t(J.mc(_t238, "includes", [_s123["g"]])))
									if not J.t(_t240):
										var _t239 = _s123["__p"]["__p"]["val"]
										_t240 = J.cmp(J.cl(_t239, null, [_s123["g"]]), J.gp(_s123["__p"]["__p"]["TUNE"], "COUNT"), ">")
									if _t240:
										J.cl(_s123["__p"]["done"], null, [])
										return null
									var _t241 = _s123["__p"]["__p"]["stage"]
									var _t242 = _s123["__p"]["__p"]["rnd"]
									J.cl(_t241, null, [J.cl(_t242, null, [J.G.get("PRES_FAREWELL")]), _s123["g"], (J.str(J.gp(_s123["g"], "name")) + "・魂飛魄散"), "道別", Callable(self, "_f53").bind(_s123)])
								else:
									if J.seq(J.gp(v_s_214, "kind"), "amnesia"):
										var _t244 = _s84["__p"]["stage"]
										var _t245 = _s84["__p"]["rnd"]
										J.cl(_t244, null, [J.cl(_t245, null, [J.G.get("PRES_AMNESIA")]), J.gp(v_s_214, "g"), (J.str(J.gp(J.gp(v_s_214, "g"), "name")) + "・失憶回歸"), "重新招魂", _s84["done"]])
									else:
										J.cl(_s84["done"], null, [])

func _f55(this_, a: Array, env):
	var v_x_238 = null
	v_x_238 = J.arg(a, 0)
	return (not J.seq(v_x_238, env["g"]))

func _f56(this_, a: Array, env):
	var v_x_239 = null
	v_x_239 = J.arg(a, 0)
	return (null if J.seq(v_x_239, J.gp(env["g"], "id")) else v_x_239)

func _f54(this_, a: Array, env):
	var v_p_237 = null; var v_e_240 = null; var v_e_241 = null
	var _s127 = {"__p": env, "g": null}
	_s127["g"] = J.arg(a, 0)
	v_p_237 = J.cl(_s127["__p"]["st"], null, [])
	var _t246 = J.gp(v_p_237, "gone")
	var _t248 = J.gp(_s127["g"], "k")
	var _t249 = J.gp(_s127["g"], "name")
	var _t250 = J.gp(_s127["g"], "q")
	var _t251 = J.gp(_s127["g"], "lv")
	var _t252 = J.gp(_s127["g"], "st")
	var _t247 = J.gp(_s127["g"], "arch")
	J.mc(_t246, "push", [{"k": _t248, "name": _t249, "q": _t250, "lv": _t251, "st": _t252, "arch": (_t247 if J.t(_t247) else null), "at": J.cl(_s127["__p"]["clock"], null, [])}])
	var _t253 = J.G.get("S")
	var _t254 = J.gp(J.G.get("S"), "ghosts")
	var _t255 = J.mc(_t254, "filter", [Callable(self, "_f55").bind(_s127)])
	J.sp(_t253, "ghosts", _t255)
	var _t256 = J.G.get("S")
	var _t257 = J.gp(J.G.get("S"), "team")
	var _t258 = J.mc(_t257, "map", [Callable(self, "_f56").bind(_s127)])
	J.sp(_t256, "team", _t258)
	if J.seq(J.gp(J.G.get("S"), "adviser"), J.gp(_s127["g"], "id")):
		var _t259 = J.G.get("S")
		J.sp(_t259, "adviser", null)
	J.del(J.gp(v_p_237, "p"), J.gp(_s127["g"], "id"))
	J.del(J.gp(v_p_237, "warn"), J.gp(_s127["g"], "id"))
	J.del(J.gp(v_p_237, "cd"), J.gp(_s127["g"], "id"))
	J.del(J.gp(v_p_237, "haunt"), J.gp(_s127["g"], "id"))
	J.mc(J.G.get("Fx"), "toast", [("<b>" + J.str(J.gp(_s127["g"], "name")) + "</b> 魂飛魄散了。可以在招魂台重新招魂（會失憶）。")])
	J.cl(J.G.get("save"), null, [])
	J.mc(J.G.get("UI"), "refresh", [])

func _f58(this_, a: Array, env):
	var v_x_253 = null
	v_x_253 = J.arg(a, 0)
	return J.seq(J.gp(v_x_253, "k"), J.gp(env["o"], "k"))

func _f57(this_, a: Array, env):
	var v_i_244 = null; var v_silent_245 = null; var v_p_246 = null; var v_named_248 = null; var v_c_249 = null; var v_g_250 = null; var v_e_251 = null; var v_e_252 = null; var v_Fd_254 = null; var v_e_255 = null
	var _s136 = {"__p": env, "o": null}
	v_i_244 = J.arg(a, 0)
	v_silent_245 = J.arg(a, 1)
	v_p_246 = J.cl(_s136["__p"]["st"], null, [])
	_s136["o"] = J.gp(J.gp(v_p_246, "gone"), v_i_244)
	if (not J.t(_s136["o"])):
		return null
	v_named_248 = J.seq(J.gp(_s136["o"], "q"), "名")
	var _t260 = (not J.t(v_named_248))
	var _t261 = (J.seq(J.typeof_(J.G.get("fodderCount")), "function") if _t260 else _t260)
	if (J.cmp(J.cl(J.G.get("fodderCount"), null, []), J.mc(J.G.get("F"), "rosterCap", []), ">=") if _t261 else _t261):
		J.mc(J.G.get("Fx"), "toast", ["雜鬼名額已滿"])
		return null
	v_c_249 = J.mc(J.G.get("F"), "recruitCost", [])
	if (not J.t(v_silent_245)):
		var _t262 = J.G.get("canPay")
		if (not J.t(J.cl(_t262, null, [v_c_249]))):
			J.mc(J.G.get("Fx"), "toast", ["冥幣或壽包不夠"])
			return null
		var _t263 = J.G.get("pay")
		J.cl(_t263, null, [v_c_249])
	v_g_250 = null
	if J.t(v_named_248):
		var _t264 = J.G.get("joinGhost")
		J.cl(_t264, null, [J.gp(_s136["o"], "k")])
		var _t265 = J.gp(J.G.get("S"), "ghosts")
		var _t266 = J.mc(_t265, "find", [Callable(self, "_f58").bind(_s136)])
		v_g_250 = _t266
	else:
		var _t267 = J.G.get("S")
		var _t268 = J.num(J.gp(_t267, "uid"))
		J.sp(_t267, "uid", _t268 + 1.0)
		var _t269 = {"id": J.add("g", _t268), "k": J.gp(_s136["o"], "k"), "name": J.gp(_s136["o"], "name"), "q": J.gp(_s136["o"], "q"), "lv": 1.0, "st": J.gp(_s136["o"], "st"), "post": null, "spent": 0.0, "arch": J.gp(_s136["o"], "arch")}
		v_g_250 = _t269
		var _t270 = J.gp(J.G.get("S"), "ghosts")
		J.mc(_t270, "push", [v_g_250])
	if (not J.t(v_g_250)):
		return null
	var _t271 = J.gp(_s136["o"], "lv")
	var _t272 = J.gp(_s136["o"], "lv")
	var _t273 = J.max_([1.0, J.round(J.num(J.mul((_t272 if J.t(_t272) else 1.0), 0.5)))])
	J.sp(v_g_250, "lv", _t273)
	var _t274 = J.gp(v_p_246, "gone")
	J.mc(_t274, "splice", [v_i_244, 1.0])
	var _t275 = _s136["__p"]["set"]
	J.cl(_t275, null, [v_g_250, 70.0])
	var _t276 = (not J.seq(J.typeof_(J.G.get("BOND_FEUDS")), "undefined"))
	var _t277 = (J.gp(J.G.get("S"), "bonds") if _t276 else _t276)
	if J.t((J.gp(J.gp(J.G.get("S"), "bonds"), "feud") if J.t(_t277) else _t277)):
		for _t278 in J.iter(J.G.get("BOND_FEUDS")):
			v_Fd_254 = _t278
			var _t279 = J.seq(J.gp(v_Fd_254, "a"), J.gp(v_g_250, "k"))
			if (_t279 if _t279 else J.seq(J.gp(v_Fd_254, "b"), J.gp(v_g_250, "k"))):
				J.del(J.gp(J.gp(J.G.get("S"), "bonds"), "feud"), J.gp(v_Fd_254, "id"))
	J.mc(_s136["__p"]["scenes"], "unshift", [{"kind": "amnesia", "g": v_g_250}])
	J.cl(J.G.get("save"), null, [])
	J.mc(J.G.get("UI"), "refresh", [])
	return v_g_250

func _f59(this_, a: Array, env):
	var v_g_258 = null; var v_v_259 = null; var v_a_260 = null
	v_g_258 = J.arg(a, 0)
	if (not J.t(v_g_258)):
		return 1.0
	var _t280 = env["val"]
	v_v_259 = J.cl(_t280, null, [v_g_258])
	if J.cmp(v_v_259, J.gp(env["TUNE"], "FADE"), ">="):
		return 1.0
	v_a_260 = (0.3 + (0.7 * J.div(v_v_259, J.gp(env["TUNE"], "FADE"))))
	var _t281 = J.cmp(v_v_259, 15.0, "<")
	if ((randf() < 0.12) if _t281 else _t281):
		var _t282 = J.mul(v_a_260, 0.25)
		v_a_260 = _t282
	return v_a_260

func _f61(this_, a: Array, env):
	var v_g_265 = null
	v_g_265 = J.arg(a, 0)
	return J.seq(J.gp(v_g_265, "k"), env["k"])

func _f60(this_, a: Array, env):
	var v_gs_264 = null
	var _s154 = {"__p": env, "k": null}
	_s154["k"] = J.arg(a, 0)
	var _t283 = (not J.t(J.cl(_s154["__p"]["S_"], null, [])))
	if (_t283 if _t283 else (not J.t(J.gp(J.G.get("S"), "ghosts")))):
		return null
	if J.seq(_s154["k"], "afu"):
		var _t284 = J.gp(J.G.get("S"), "ghosts")
		return J.mc(_t284, "find", [_s154["__p"]["isAfu"]])
	var _t285 = J.gp(J.G.get("S"), "ghosts")
	v_gs_264 = J.mc(_t285, "filter", [Callable(self, "_f61").bind(_s154)])
	var _t286 = J.seq(J.len(v_gs_264), 1.0)
	return (J.gp(v_gs_264, 0.0) if (J.seq(J.gp(J.gp(v_gs_264, 0.0), "q"), "名") if _t286 else _t286) else null)

func _f62(this_, a: Array, env):
	var v_g_268 = null; var v_v_269 = null
	v_g_268 = J.arg(a, 0)
	var _t287 = env["val"]
	v_v_269 = J.cl(_t287, null, [v_g_268])
	return (1.0 if J.cmp(v_v_269, J.gp(env["TUNE"], "LOWSTAT"), ">=") else (0.9 + J.div(J.mul(0.1, v_v_269), J.gp(env["TUNE"], "LOWSTAT"))))

func _f63(this_, a: Array, env):
	var v_v_272 = null; var v_col_273 = null
	v_v_272 = J.arg(a, 0)
	v_col_273 = ("#6ec27a" if J.cmp(v_v_272, J.gp(env["TUNE"], "FADE"), ">") else ("#e0b44a" if J.cmp(v_v_272, J.gp(env["TUNE"], "WARN"), ">") else "#e0604a"))
	return ("<span style=\"display:inline-block;vertical-align:middle;width:70px;height:7px;border-radius:4px;background:rgba(0,0,0,.18);overflow:hidden;margin:0 4px\"><i style=\"display:block;height:100%;width:" + J.str(J.round(J.num(v_v_272))) + "%;background:" + J.str(v_col_273) + "\"></i></span>")

func _f64(this_, a: Array, env):
	var v_g_276 = null; var v_v_277 = null; var v_d_278 = null
	v_g_276 = J.arg(a, 0)
	var _t288 = env["val"]
	v_v_277 = J.cl(_t288, null, [v_g_276])
	var _t289 = env["daysLeft"]
	v_d_278 = J.cl(_t289, null, [v_g_276])
	return (("<b style=\"color:#c0392b\">魂飛魄散倒數 " + J.str(v_d_278) + " 日</b>") if (not J.leq(v_d_278, null)) else ("<b style=\"color:#c0392b\">⚠ 存在感不足</b>" if J.cmp(v_v_277, J.gp(env["TUNE"], "WARN"), "<=") else ("<span style=\"color:#9a7a3a\">變淡中</span>" if J.cmp(v_v_277, J.gp(env["TUNE"], "FADE"), "<") else "")))

func _f67(this_, a: Array, env):
	var v_x_290 = null
	v_x_290 = J.arg(a, 0)
	var _t294 = J.gp(v_x_290, "id")
	var _t293 = J.gp(J.gp(env["up"], "dataset"), "up")
	return J.seq(_t294, (_t293 if J.t(_t293) else J.gp(J.gp(env["up"], "dataset"), "rel")))

func _f68(this_, a: Array, env):
	var v_x_292 = null
	v_x_292 = J.arg(a, 0)
	return J.seq(J.gp(v_x_292, "name"), J.gp(env["nm"], "textContent"))

func _f66(this_, a: Array, env):
	var v_c_283 = null; var v_main_284 = null; var v_g_286 = null; var v_v_287 = null; var v_e_288 = null; var v_cv_289 = null
	var _s160 = {"__p": env, "up": null}
	v_c_283 = J.arg(a, 0)
	if J.t(J.mc(v_c_283, "querySelector", [".presln"])):
		return null
	v_main_284 = J.mc(v_c_283, "querySelector", [".gc-main"])
	if (not J.t(v_main_284)):
		return null
	_s160["up"] = J.mc(v_c_283, "querySelector", ["[data-up],[data-rel]"])
	var _t295 = null
	if J.t(_s160["up"]):
		var _t292 = J.gp(J.G.get("S"), "ghosts")
		_t295 = J.mc(_t292, "find", [Callable(self, "_f67").bind(_s160)])
	else:
		_t295 = null
	v_g_286 = _t295
	if (not J.t(v_g_286)):
		var _s162 = {"__p": _s160, "nm": null}
		_s162["nm"] = J.mc(v_main_284, "querySelector", ["b"])
		var _t297 = _s162["nm"]
		if J.t(_t297):
			var _t296 = J.gp(J.G.get("S"), "ghosts")
			_t297 = J.mc(_t296, "find", [Callable(self, "_f68").bind(_s162)])
		v_g_286 = _t297
	if (not J.t(v_g_286)):
		return null
	var _t298 = _s160["__p"]["val"]
	v_v_287 = J.cl(_t298, null, [v_g_286])
	v_e_288 = J.S_document_("createElement", ["small"])
	J.sp(v_e_288, "className", "tr presln")
	var _t300 = J.round(J.num(v_v_287))
	var _t299 = _s160["__p"]["bar"]
	var _t302 = J.cl(_t299, null, [v_v_287])
	var _t301 = _s160["__p"]["badge"]
	var _t303 = ("存在感 " + J.str(_t300) + J.str(_t302) + J.str(J.cl(_t301, null, [v_g_286])))
	J.sp(v_e_288, "innerHTML", _t303)
	J.mc(v_main_284, "appendChild", [v_e_288])
	v_cv_289 = J.mc(v_c_283, "querySelector", ["canvas"])
	if J.t(v_cv_289):
		var _t304 = J.gp(v_cv_289, "style")
		var _t305 = _s160["__p"]["alphaOf"]
		var _t306 = J.cl(_t305, null, [v_g_286])
		J.sp(_t304, "opacity", _t306)
	var _t307 = _s160["__p"]["isAfu"]
	var _t308 = J.cl(_t307, null, [v_g_286])
	if J.t((J.cmp(J.gp(J.cl(_s160["__p"]["cst"], null, []), "rank"), 5.0, ">=") if J.t(_t308) else _t308)):
		var _t309 = J.gp(v_c_283, "style")
		J.sp(_t309, "boxShadow", "0 0 0 2px #d9b440, 0 0 10px rgba(217,180,64,.55)")
		var _t310 = J.gp(v_c_283, "style")
		J.sp(_t310, "borderRadius", "10px")

func _f69(this_, a: Array, env):
	var v_o_295 = null; var v_i_296 = null
	v_o_295 = J.arg(a, 0)
	v_i_296 = J.arg(a, 1)
	return ("<div class=\"row\"><span>" + J.str(J.gp(v_o_295, "name")) + "　Lv" + J.str(J.gp(v_o_295, "lv")) + "</span><button class=\"btn sm gold\" data-regone=\"" + J.str(v_i_296) + "\">重新招魂</button></div>")

func _f71(this_, a: Array, env):
	var v_g_298 = null
	var _t318 = env["__p"]["resummon"]
	v_g_298 = J.cl(_t318, null, [J.num(J.gp(J.gp(env["b"], "dataset"), "regone"))])
	if J.t(v_g_298):
		J.mc(J.G.get("UI"), "close", [])

func _f70(this_, a: Array, env):
	var _s167 = {"__p": env, "b": null}
	_s167["b"] = J.arg(a, 0)
	var _t317 = _s167["b"]
	var _t319 = Callable(self, "_f71").bind(_s167)
	J.sp(_t317, "onclick", _t319)
	return _t319

func _f65(this_, a: Array, env):
	var v_sh_281 = null; var v_rc_282 = null; var v_p_293 = null; var v_d_294 = null
	v_sh_281 = J.S_document_("querySelector", ["#sheet"])
	var _t290 = (not J.t(v_sh_281))
	if (_t290 if _t290 else (not J.t(J.cl(env["S_"], null, [])))):
		return null
	var _t291 = J.mc(v_sh_281, "querySelectorAll", [".gcard"])
	J.mc(_t291, "forEach", [Callable(self, "_f66").bind(env)])
	v_rc_282 = J.mc(v_sh_281, "querySelector", ["[data-act=recruit]"])
	if J.t(((not J.t(J.mc(v_sh_281, "querySelector", ["#pres-gone"]))) if J.t(v_rc_282) else v_rc_282)):
		v_p_293 = J.cl(env["st"], null, [])
		if (not J.t(J.len(J.gp(v_p_293, "gone")))):
			return null
		v_d_294 = J.S_document_("createElement", ["div"])
		J.sp(v_d_294, "id", "pres-gone")
		var _t313 = ("<h4 class=\"stand-h\">魂飛魄散名單</h4><p class=\"desc\">淡走了的鬼，招魂台上還留著寫有他們名字的黃紙。重新招魂費用跟招魂一樣；回來的會失憶（等級剩一半，冤家關係重新開始）。</p>")
		var _t311 = J.gp(v_p_293, "gone")
		var _t312 = J.mc(_t311, "map", [Callable(self, "_f69").bind(env)])
		var _t314 = J.add(_t313, J.mc(_t312, "join", [""]))
		J.sp(v_d_294, "innerHTML", _t314)
		var _t315 = J.gp(J.mc(v_rc_282, "closest", [".row"]), "parentNode")
		J.mc(_t315, "appendChild", [v_d_294])
		var _t316 = J.mc(v_d_294, "querySelectorAll", ["[data-regone]"])
		J.mc(_t316, "forEach", [Callable(self, "_f70").bind(env)])

func _f73(this_, a: Array, env):
	var v_a_311 = null; var v_b_312 = null
	v_a_311 = J.arg(a, 0)
	v_b_312 = J.arg(a, 1)
	var _t345 = env["__p"]["val"]
	var _t347 = J.cl(_t345, null, [v_a_311])
	var _t346 = env["__p"]["val"]
	return J.sub(_t347, J.cl(_t346, null, [v_b_312]))

func _f74(this_, a: Array, env):
	var v_g_313 = null
	v_g_313 = J.arg(a, 0)
	var _t350 = J.gp(v_g_313, "name")
	var _t349 = env["__p"]["val"]
	var _t353 = J.round(J.num(J.cl(_t349, null, [v_g_313])))
	var _t351 = env["__p"]["bar"]
	var _t352 = env["__p"]["val"]
	var _t355 = J.cl(_t351, null, [J.cl(_t352, null, [v_g_313])])
	var _t354 = env["__p"]["badge"]
	var _t359 = J.cl(_t354, null, [v_g_313])
	var _t356 = env["__p"]["isAfu"]
	var _t358 = (not J.t(J.cl(_t356, null, [v_g_313])))
	if J.t(_t358):
		var _t357 = env["__p"]["val"]
		_t358 = J.cmp(J.cl(_t357, null, [v_g_313]), 100.0, "<")
	return ("<div class=\"row\"><span>" + J.str(_t350) + "</span><span>" + J.str(_t353) + J.str(_t355) + J.str(_t359) + ((" <button class=\"btn sm " + ("" if J.seq(J.gp(env["od"], J.gp(v_g_313, "id")), env["today"]) else "gold") + "\" data-offer=\"" + J.str(J.gp(v_g_313, "id")) + "\" " + ("disabled" if J.seq(J.gp(env["od"], J.gp(v_g_313, "id")), env["today"]) else "") + ">" + ("已上供" if J.seq(J.gp(env["od"], J.gp(v_g_313, "id")), env["today"]) else "上供") + "</button>") if _t358 else "") + "</span></div>")

func _f72(this_, a: Array, env):
	var v_c_301 = null; var v_r_302 = null; var v_now_303 = null; var v_h_304 = null; var v_p_305 = null; var v_nx_308 = null; var v_left_309 = null; var v_pr_310 = null
	var _s170 = {"__p": env, "od": null, "today": null}
	v_c_301 = J.cl(_s170["__p"]["cst"], null, [])
	var _t320 = _s170["__p"]["rankOf"]
	v_r_302 = J.cl(_t320, null, [J.gp(v_c_301, "rank")])
	v_now_303 = J.cl(_s170["__p"]["clock"], null, [])
	v_h_304 = ""
	if J.seq(J.gp(v_c_301, "state"), "none"):
		var _t321 = J.add(v_h_304, ("<p class=\"desc\">打完第一章後，龐總會來跟你簽試用期合約。</p>"))
		v_h_304 = _t321
	else:
		var _t322 = J.add(v_h_304, ("<p class=\"desc\">職級：<b>" + J.str(J.gp(J.gp(J.G.get("PRES_RANKS"), J.gp(v_c_301, "rank")), "name")) + "</b>" + ("（年度考核）" if J.cmp(J.gp(v_c_301, "rank"), (J.len(J.G.get("PRES_RANKS")) - 1.0), ">=") else "") + "</p>"))
		v_h_304 = _t322
		if J.seq(J.gp(v_c_301, "state"), "active"):
			v_left_309 = J.max_([0.0, J.div(J.sub(J.gp(v_c_301, "end"), v_now_303), _s170["__p"]["DAY"])])
			v_pr_310 = J.min_([1.0, J.div(J.gp(v_c_301, "kpi"), J.gp(v_c_301, "target"))])
			var _t323 = J.add(v_h_304, ("<p class=\"desc\">KPI " + J.str(J.gp(v_c_301, "kpi")) + "／" + J.str(J.gp(v_c_301, "target")) + "<span style=\"display:block;height:10px;border-radius:5px;background:rgba(0,0,0,.18);overflow:hidden;margin:4px 0\"><i style=\"display:block;height:100%;width:" + J.str(J.mul(v_pr_310, 100.0)) + "%;background:#d9a441\"></i></span>剩下 <b>" + J.str(J.mc(v_left_309, "toFixed", [1.0])) + "</b> 日</p>"))
			v_h_304 = _t323
		else:
			var _t324 = J.max_([0.0, J.div(J.sub(J.gp(J.gp(v_c_301, "crisis"), "end"), v_now_303), _s170["__p"]["DAY"])])
			var _t325 = J.add(v_h_304, ("<p class=\"desc\" style=\"color:#c0392b\"><b>淡化危機</b>：" + J.str(J.mc(_t324, "toFixed", [1.0])) + " 日內回陽間完成一晚（一星或以上），阿福就會被記起。不會遊戲結束。</p>"))
			v_h_304 = _t325
		v_nx_308 = J.gp(J.G.get("PRES_RANKS"), J.add(J.gp(v_c_301, "rank"), 1.0))
		var _t326 = J.add(v_h_304, ("<p class=\"desc\">" + (("下一級：<b>" + J.str(J.gp(v_nx_308, "name")) + "</b>　解鎖：" + J.str(J.gp(v_nx_308, "unlock"))) if J.t(v_nx_308) else "已經是最高職級。每期過關有花紅。") + "</p>"))
		v_h_304 = _t326
		var _t327 = J.add(v_h_304, ("<p class=\"desc\">KPI 怎樣算：每晚回陽間，每顆星 10 分；傳說熱度每級 5 分（最多 25）；有驚嚇值 5 分；被道士請走扣 5 分。另外陽間地盤每日收租（每 3 個地盤 +1），奪回被搶的地盤 +4。</p>"))
		v_h_304 = _t327
	var _t329 = J.gp(_s170["__p"]["TUNE"], "DECAY")
	var _t328 = _s170["__p"]["perk"]
	var _t330 = J.mul(_t329, J.cl(_t328, null, ["decay"]))
	var _t333 = J.mc(_t330, "toFixed", [1.0])
	var _t334 = J.gp(_s170["__p"]["TUNE"], "RIPPLE")
	var _t332 = J.add(J.gp(_s170["__p"]["TUNE"], "RIPPLE"), J.mul(J.gp(_s170["__p"]["TUNE"], "RIPPLE_STAR"), 3.0))
	var _t331 = _s170["__p"]["perk"]
	var _t335 = J.add(v_h_304, ("<h4 class=\"stand-h\">村裡的存在感</h4><p class=\"desc\">鬼要有人記得才存在。每天自然流失 " + J.str(_t333) + "；回陽間一晚全村 +" + J.str(_t334) + "～" + J.str(J.add(_t332, J.cl(_t331, null, ["ripple"]))) + "，出動的鬼更多。上台講棟篤笑、打贏仗、在陰間日常出場也有少少。</p>"))
	v_h_304 = _t335
	v_p_305 = J.cl(_s170["__p"]["st"], null, [])
	if J.cmp(J.cl(_s170["__p"]["clock"], null, []), J.gp(v_p_305, "grace"), "<"):
		var _t336 = J.div(J.sub(J.gp(v_p_305, "grace"), J.cl(_s170["__p"]["clock"], null, [])), _s170["__p"]["DAY"])
		var _t337 = J.add(v_h_304, ("<p class=\"desc\">新功能保護期：還有 " + J.str(J.mc(_t336, "toFixed", [1.0])) + " 日不會流失。</p>"))
		v_h_304 = _t337
	var _t339 = J.gp(_s170["__p"]["OFFER"], "buns")
	var _t340 = J.gp(_s170["__p"]["OFFER"], "add")
	var _t338 = J.G.get("fmt")
	var _t341 = J.add(v_h_304, ("<p class=\"desc\">上供品：用 " + J.str(_t339) + " 個壽包替一隻鬼上供，存在感 +" + J.str(_t340) + "（每隻鬼每日一次）。壽包 " + J.str(J.cl(_t338, null, [J.gp(J.gp(J.G.get("S"), "res"), "buns")])) + "</p>"))
	v_h_304 = _t341
	var _t342 = J.gp(v_p_305, "offered")
	_s170["od"] = (_t342 if J.t(_t342) else {})
	var _t343 = _s170["__p"]["gday"]
	_s170["today"] = J.cl(_t343, null, [J.cl(_s170["__p"]["clock"], null, [])])
	var _t344 = J.mc(J.gp(J.G.get("S"), "ghosts"), "slice", [])
	var _t348 = J.mc(_t344, "sort", [Callable(self, "_f73").bind(_s170)])
	var _t360 = J.mc(_t348, "map", [Callable(self, "_f74").bind(_s170)])
	var _t361 = J.add(v_h_304, J.mc(_t360, "join", [""]))
	v_h_304 = _t361
	return v_h_304

func _f76(this_, a: Array, env):
	var v_x_320 = null
	v_x_320 = J.arg(a, 0)
	return J.seq(J.gp(v_x_320, "id"), env["id"])

func _f75(this_, a: Array, env):
	var v_g_317 = null; var v_p_318 = null; var v_today_319 = null; var v_e_321 = null; var v_e_322 = null
	var _s175 = {"__p": env, "id": null}
	_s175["id"] = J.arg(a, 0)
	var _t362 = J.gp(J.G.get("S"), "ghosts")
	v_g_317 = J.mc(_t362, "find", [Callable(self, "_f76").bind(_s175)])
	v_p_318 = J.cl(_s175["__p"]["st"], null, [])
	var _t363 = _s175["__p"]["gday"]
	v_today_319 = J.cl(_t363, null, [J.cl(_s175["__p"]["clock"], null, [])])
	if (not J.t(v_g_317)):
		return null
	var _t364 = J.gp(v_p_318, "offered")
	var _t365 = (_t364 if J.t(_t364) else {})
	J.sp(v_p_318, "offered", _t365)
	if J.seq(J.gp(J.gp(v_p_318, "offered"), J.gp(v_g_317, "id")), v_today_319):
		return null
	var _t366 = J.gp(J.gp(J.G.get("S"), "res"), "buns")
	if J.cmp((_t366 if J.t(_t366) else 0.0), J.gp(_s175["__p"]["OFFER"], "buns"), "<"):
		J.mc(J.G.get("Fx"), "toast", ["壽包不夠"])
		return null
	var _t367 = J.gp(J.G.get("S"), "res")
	var _t368 = J.sub(J.gp(_t367, "buns"), J.gp(_s175["__p"]["OFFER"], "buns"))
	J.sp(_t367, "buns", _t368)
	var _t369 = J.gp(v_p_318, "offered")
	var _t370 = J.gp(v_g_317, "id")
	J.sp(_t369, _t370, v_today_319)
	var _t371 = _s175["__p"]["set"]
	var _t372 = _s175["__p"]["val"]
	J.cl(_t371, null, [v_g_317, J.add(J.cl(_t372, null, [v_g_317]), J.gp(_s175["__p"]["OFFER"], "add"))])
	J.mc(J.G.get("Fx"), "toast", [("替 <b>" + J.str(J.gp(v_g_317, "name")) + "</b> 上供：存在感 +" + J.str(J.gp(_s175["__p"]["OFFER"], "add")))])
	J.cl(J.G.get("save"), null, [])

func _f77(this_, a: Array, env):
	var v_e_325 = null
	J.mc(J.G.get("UI"), "sheet", ["合約與存在感", J.cl(env["panelHTML"], null, [])])
	J.cl(env["bindPanel"], null, [])

func _f80(this_, a: Array, env):
	var v_sc_330 = null; var v_y_331 = null
	var _t375 = env["__p"]["__p"]["offer"]
	J.cl(_t375, null, [J.gp(J.gp(env["b"], "dataset"), "offer")])
	v_sc_330 = J.mc(env["__p"]["sh"], "querySelector", [".sh-body"])
	v_y_331 = (J.gp(v_sc_330, "scrollTop") if J.t(v_sc_330) else 0.0)
	if J.t(v_sc_330):
		var _t376 = J.cl(env["__p"]["__p"]["panelHTML"], null, [])
		J.sp(v_sc_330, "innerHTML", _t376)
		J.cl(env["__p"]["__p"]["bindPanel"], null, [])
		J.sp(v_sc_330, "scrollTop", v_y_331)

func _f79(this_, a: Array, env):
	var _s189 = {"__p": env, "b": null}
	_s189["b"] = J.arg(a, 0)
	var _t374 = _s189["b"]
	var _t377 = Callable(self, "_f80").bind(_s189)
	J.sp(_t374, "onclick", _t377)
	return _t377

func _f78(this_, a: Array, env):
	var _s188 = {"__p": env, "sh": null}
	_s188["sh"] = J.S_document_("querySelector", ["#sheet"])
	if (not J.t(_s188["sh"])):
		return null
	var _t373 = J.mc(_s188["sh"], "querySelectorAll", ["[data-offer]"])
	J.mc(_t373, "forEach", [Callable(self, "_f79").bind(_s188)])

func _f82(this_, a: Array, env):
	var v_g_341 = null
	v_g_341 = J.arg(a, 0)
	var _t383 = env["isAfu"]
	var _t385 = (not J.t(J.cl(_t383, null, [v_g_341])))
	if J.t(_t385):
		var _t384 = env["val"]
		_t385 = J.cmp(J.cl(_t384, null, [v_g_341]), J.gp(env["TUNE"], "WARN"), "<=")
	return _t385

func _f81(this_, a: Array, env):
	var v_wrap_334 = null; var v_el_335 = null; var v_c_336 = null; var v_now_337 = null; var v_warnN_338 = null; var v_h_339 = null; var v_s_340 = null
	v_wrap_334 = J.S_document_("getElementById", ["stagewrap"])
	var _t378 = (not J.t(v_wrap_334))
	if (_t378 if _t378 else (not J.t(J.cl(env["S_"], null, [])))):
		return null
	v_el_335 = J.S_document_("getElementById", ["pres-chip"])
	v_c_336 = J.cl(env["cst"], null, [])
	if J.seq(J.gp(v_c_336, "state"), "none"):
		if J.t(v_el_335):
			J.mc(v_el_335, "remove", [])
		return null
	if (not J.t(v_el_335)):
		var _t379 = J.S_document_("createElement", ["div"])
		v_el_335 = _t379
		J.sp(v_el_335, "id", "pres-chip")
		J.mc(v_wrap_334, "appendChild", [v_el_335])
		var _t380 = env["openPanel"]
		J.sp(v_el_335, "onclick", _t380)
		v_s_340 = J.S_document_("createElement", ["style"])
		J.sp(v_s_340, "textContent", "#pres-chip{position:absolute;right:8px;bottom:8px;z-index:4;padding:6px 10px;background:rgba(20,12,22,.86);color:#f3e6c8;font-size:13px;line-height:1.45;border-radius:4px;box-shadow:inset 0 0 0 1px rgba(243,214,138,.45);cursor:pointer;text-align:right}#pres-chip.cr{box-shadow:inset 0 0 0 1.5px #e0604a;color:#ffb4a0}")
		var _t381 = J.gp(J.G.get("document"), "head")
		J.mc(_t381, "appendChild", [v_s_340])
	v_now_337 = J.cl(env["clock"], null, [])
	var _t382 = J.gp(J.G.get("S"), "ghosts")
	v_warnN_338 = J.len(J.mc(_t382, "filter", [Callable(self, "_f82").bind(env)]))
	var _t391 = null
	if J.seq(J.gp(v_c_336, "state"), "crisis"):
		var _t386 = J.max_([0.0, J.div(J.sub(J.gp(J.gp(v_c_336, "crisis"), "end"), v_now_337), env["DAY"])])
		_t391 = ("<b>淡化危機</b>　剩 " + J.str(J.mc(_t386, "toFixed", [1.0])) + " 日")
	else:
		var _t388 = J.gp(J.gp(J.G.get("PRES_RANKS"), J.gp(v_c_336, "rank")), "name")
		var _t389 = J.gp(v_c_336, "kpi")
		var _t390 = J.gp(v_c_336, "target")
		var _t387 = J.max_([0.0, J.div(J.sub(J.gp(v_c_336, "end"), v_now_337), env["DAY"])])
		_t391 = ("<b>" + J.str(_t388) + "</b>　KPI " + J.str(_t389) + "/" + J.str(_t390) + "　剩 " + J.str(J.mc(_t387, "toFixed", [1.0])) + " 日" + (("<br>⚠ " + J.str(v_warnN_338) + " 隻鬼存在感不足") if J.t(v_warnN_338) else ""))
	v_h_339 = _t391
	if (not J.seq(J.gp(v_el_335, "innerHTML"), v_h_339)):
		J.sp(v_el_335, "innerHTML", v_h_339)
	var _t392 = ("cr" if J.seq(J.gp(v_c_336, "state"), "crisis") else "")
	J.sp(v_el_335, "className", _t392)

func _f83(this_, a: Array, env):
	var v_s_344 = null
	var _t393 = (not J.t(J.cl(env["S_"], null, [])))
	if (_t393 if _t393 else (not J.t(J.gp(J.G.get("S"), "ghosts")))):
		return null
	J.cl(env["update"], null, [])
	J.cl(env["contractTick"], null, [])
	J.cl(env["hud"], null, [])
	if J.cmp(env["sceneGap"], 0.0, ">"):
		var _t394 = J.sub(env["sceneGap"], 2.0)
		env["sceneGap"] = _t394
		return null
	var _t395 = J.len(env["scenes"])
	if J.t((J.cl(env["quiet"], null, []) if J.t(_t395) else _t395)):
		v_s_344 = J.mc(env["scenes"], "shift", [])
		var _t396 = env["runScene"]
		J.cl(_t396, null, [v_s_344])

func _f85(this_, a: Array, env):
	var v_e_348 = null; var v_err_349 = null
	v_e_348 = J.arg(a, 0)
	var _t397 = env["__p"]["nightEnd"]
	var _t398 = J.gp(v_e_348, "detail")
	J.cl(_t397, null, [(_t398 if J.t(_t398) else {})])

func _f87(this_, a: Array, env):
	var v_z_361 = null
	v_z_361 = J.arg(a, 0)
	return J.seq(J.gp(v_z_361, "id"), J.gp(env["o"], "wkey"))

func _f86(this_, a: Array, env):
	var v_ctx_353 = null; var v_k_354 = null; var v_x_355 = null; var v_y_356 = null; var v_s_357 = null; var v_g_359 = null; var v_m_360 = null
	var _s205 = {"__p": env, "o": null}
	v_ctx_353 = J.arg(a, 0)
	v_k_354 = J.arg(a, 1)
	v_x_355 = J.arg(a, 2)
	v_y_356 = J.arg(a, 3)
	v_s_357 = J.arg(a, 4)
	_s205["o"] = J.arg(a, 5)
	var _t401 = (not J.t(_s205["__p"]["__p"]["__p"]["inPlaza"]))
	var _t402 = (J.cl(_s205["__p"]["__p"]["__p"]["S_"], null, []) if _t401 else _t401)
	if J.t((J.gp(J.G.get("S"), "presence") if J.t(_t402) else _t402)):
		var _t405 = null
		if J.t(((not J.leq(J.gp(_s205["o"], "wkey"), null)) if J.t(_s205["o"]) else _s205["o"])):
			var _t403 = J.gp(J.G.get("S"), "ghosts")
			_t405 = J.mc(_t403, "find", [Callable(self, "_f87").bind(_s205)])
		else:
			var _t404 = _s205["__p"]["__p"]["__p"]["gOfKey"]
			_t405 = J.cl(_t404, null, [v_k_354])
		v_g_359 = _t405
		var _t407 = null
		if J.t(v_g_359):
			var _t406 = _s205["__p"]["__p"]["__p"]["alphaOf"]
			_t407 = J.cl(_t406, null, [v_g_359])
		else:
			_t407 = 1.0
		v_m_360 = _t407
		if J.cmp(v_m_360, 1.0, "<"):
			var _t408 = J.S_Object_("assign", [{}, (_s205["o"] if J.t(_s205["o"]) else {})])
			_s205["o"] = _t408
			var _t409 = _s205["o"]
			var _t410 = J.mul((J.gp(_s205["o"], "alpha") if (not J.leq(J.gp(_s205["o"], "alpha"), null)) else J.gp(v_ctx_353, "globalAlpha")), v_m_360)
			J.sp(_t409, "alpha", _t410)
	return J.mc(_s205["__p"]["od"], "call", [this_, v_ctx_353, v_k_354, v_x_355, v_y_356, v_s_357, _s205["o"]])

func _f90(this_, a: Array, env):
	var v_m_380 = null
	var _t415 = env["__p"]["__p"]["__p"]["__p"]["alphaOf"]
	v_m_380 = J.cl(_t415, null, [env["g"]])
	env["__p"]["__p"]["__p"]["__p"]["inPlaza"] = true
	J.mc(env["__p"]["ctx"], "save", [])
	var _t416 = env["__p"]["ctx"]
	var _t417 = J.mul(J.gp(_t416, "globalAlpha"), v_m_380)
	J.sp(_t416, "globalAlpha", _t417)
	J.cl(env["f"], null, [])
	J.mc(env["__p"]["ctx"], "restore", [])
	env["__p"]["__p"]["__p"]["__p"]["inPlaza"] = false

func _f89(this_, a: Array, env):
	var v_it_376 = null; var v_j_377 = null
	var _s211 = {"__p": env, "g": null, "f": null}
	v_it_376 = J.arg(a, 0)
	v_j_377 = J.arg(a, 1)
	var _t414 = J.gp(_s211["__p"]["nv"], v_j_377)
	_s211["g"] = (J.gp(J.gp(_s211["__p"]["nv"], v_j_377), "g") if J.t(_t414) else _t414)
	_s211["f"] = J.gp(v_it_376, "f")
	var _t418 = Callable(self, "_f90").bind(_s211)
	J.sp(v_it_376, "f", _t418)

func _f88(this_, a: Array, env):
	var v_V_365 = null; var v_idle_366 = null; var v_items_367 = null; var v_vis_368 = null; var v_t_370 = null; var v_i0_371 = null; var v_v0_372 = null; var v_r_373 = null; var v_ag_375 = null
	var _s210 = {"__p": env, "ctx": null, "nv": null}
	v_V_365 = J.arg(a, 0)
	v_idle_366 = J.arg(a, 1)
	v_items_367 = J.arg(a, 2)
	v_vis_368 = J.arg(a, 3)
	_s210["ctx"] = J.arg(a, 4)
	v_t_370 = J.arg(a, 5)
	v_i0_371 = J.len(v_items_367)
	v_v0_372 = J.len(v_vis_368)
	v_r_373 = J.mc(_s210["__p"]["of"], "apply", [this_, a])
	_s210["nv"] = J.mc(v_vis_368, "slice", [v_v0_372])
	v_ag_375 = J.mc(v_items_367, "slice", [(J.len(v_items_367) - J.len(_s210["nv"]))])
	if (J.sub(J.len(v_items_367), v_i0_371) >= J.len(_s210["nv"])):
		J.mc(v_ag_375, "forEach", [Callable(self, "_f89").bind(_s210)])
	return v_r_373

func _f92(this_, a: Array, env):
	var v_x_387 = null
	v_x_387 = J.arg(a, 0)
	return J.seq(J.gp(v_x_387, "id"), J.gp(env["b"], "id"))

func _f91(this_, a: Array, env):
	var v_r_384 = null; var v_g_386 = null; var v_d_388 = null; var v_pool_389 = null; var v_l_390 = null; var v_e_391 = null
	v_r_384 = J.mc(env["ou"], "apply", [this_, a])
	var _s217 = {"__p": env, "b": null}
	_s217["b"] = J.gp(this_, "bubble")
	if J.t(((not J.seq(_s217["b"], _s217["__p"]["__p"]["__p"]["lastBub"])) if J.t(_s217["b"]) else _s217["b"])):
		_s217["__p"]["__p"]["__p"]["lastBub"] = _s217["b"]
		var _t424 = null
		if J.t(J.gp(_s217["b"], "hero")):
			var _t422 = J.gp(J.G.get("S"), "ghosts")
			_t424 = J.mc(_t422, "find", [_s217["__p"]["__p"]["__p"]["isAfu"]])
		else:
			var _t423 = J.gp(J.G.get("S"), "ghosts")
			_t424 = J.mc(_t423, "find", [Callable(self, "_f92").bind(_s217)])
		v_g_386 = _t424
		var _t426 = v_g_386
		if J.t(_t426):
			var _t425 = _s217["__p"]["__p"]["__p"]["isAfu"]
			_t426 = (not J.t(J.cl(_t425, null, [v_g_386])))
		var _t428 = _t426
		if J.t(_t428):
			var _t427 = _s217["__p"]["__p"]["__p"]["val"]
			_t428 = J.cmp(J.cl(_t427, null, [v_g_386]), J.gp(_s217["__p"]["__p"]["__p"]["TUNE"], "WARN"), "<=")
		var _t429 = (J.cmp(J.gp(_s217["b"], "t"), 0.2, "<") if J.t(_t428) else _t428)
		if J.t(((randf() < 0.6) if J.t(_t429) else _t429)):
			var _t430 = _s217["__p"]["__p"]["__p"]["daysLeft"]
			v_d_388 = J.cl(_t430, null, [v_g_386])
			v_pool_389 = (J.G.get("PRES_COUNT") if (not J.leq(v_d_388, null)) else J.G.get("PRES_WORRY"))
			var _t431 = _s217["__p"]["__p"]["__p"]["rnd"]
			v_l_390 = J.cl(_t431, null, [v_pool_389])
			var _t432 = _s217["b"]
			var _t433 = (J.gp(v_l_390, 1.0) if J.t(J.cl(_s217["__p"]["__p"]["__p"]["zh"], null, [])) else J.gp(v_l_390, 0.0))
			var _t434 = J.mc(_t433, "split", ["{n}"])
			var _t435 = J.mc(_t434, "join", [J.gp(v_g_386, "name")])
			var _t436 = J.mc(_t435, "split", ["{d}"])
			var _t437 = J.mc(_t436, "join", [(v_d_388 if (not J.leq(v_d_388, null)) else "")])
			J.sp(_t432, "text", _t437)
	return v_r_384

func _f93(this_, a: Array, env):
	var v_g_395 = null; var v_u_396 = null; var v_m_397 = null; var v_hm_398 = null; var v_e_399 = null
	v_g_395 = J.arg(a, 0)
	v_u_396 = J.mc(env["om"], "apply", [this_, a])
	var _t440 = env["__p"]["__p"]["statMult"]
	var _t442 = J.cl(_t440, null, [v_g_395])
	var _t441 = env["__p"]["__p"]["perk"]
	v_m_397 = J.mul(_t442, J.cl(_t441, null, ["atk"]))
	var _t443 = J.mul(J.gp(v_u_396, "atk"), v_m_397)
	J.sp(v_u_396, "atk", _t443)
	var _t444 = env["__p"]["__p"]["statMult"]
	v_hm_398 = J.cl(_t444, null, [v_g_395])
	var _t445 = J.mul(J.gp(v_u_396, "hp"), v_hm_398)
	J.sp(v_u_396, "hp", _t445)
	var _t446 = J.mul(J.gp(v_u_396, "maxhp"), v_hm_398)
	J.sp(v_u_396, "maxhp", _t446)
	return v_u_396

func _f95(this_, a: Array, env):
	var v_u_404 = null
	v_u_404 = J.arg(a, 0)
	var _t451 = J.seq(J.gp(v_u_404, "side"), 0.0)
	return (J.gp(v_u_404, "gid") if _t451 else _t451)

func _f97(this_, a: Array, env):
	var v_g_406 = null
	v_g_406 = J.arg(a, 0)
	return J.seq(J.gp(v_g_406, "id"), J.gp(env["u"], "gid"))

func _f96(this_, a: Array, env):
	var _s233 = {"__p": env, "u": null}
	_s233["u"] = J.arg(a, 0)
	var _t453 = _s233["__p"]["__p"]["__p"]["add"]
	var _t454 = J.gp(J.G.get("S"), "ghosts")
	return J.cl(_t453, null, [J.mc(_t454, "find", [Callable(self, "_f97").bind(_s233)]), J.gp(_s233["__p"]["__p"]["__p"]["TUNE"], "WIN")])

func _f94(this_, a: Array, env):
	var v_win_403 = null; var v_e_407 = null
	v_win_403 = J.arg(a, 0)
	if J.t(((not J.t(J.gp(this_, "result"))) if J.t(v_win_403) else v_win_403)):
		var _t449 = J.gp(this_, "units")
		var _t450 = (_t449 if J.t(_t449) else [])
		var _t452 = J.mc(_t450, "filter", [Callable(self, "_f95").bind(env)])
		J.mc(_t452, "forEach", [Callable(self, "_f96").bind(env)])
	return J.mc(env["of"], "apply", [this_, a])

func _f99(this_, a: Array, env):
	var v_x_414 = null
	v_x_414 = J.arg(a, 0)
	return J.seq(J.gp(v_x_414, "id"), env["__p"]["id"])

func _f100(this_, a: Array, env):
	var v_g_415 = null
	v_g_415 = J.arg(a, 0)
	return J.seq(J.gp(v_g_415, "k"), J.gp(env["b"], "k"))

func _f98(this_, a: Array, env):
	var v_opt_412 = null; var v_e_416 = null
	var _s238 = {"__p": env, "id": null}
	_s238["id"] = J.arg(a, 0)
	v_opt_412 = J.arg(a, 1)
	var _s239 = {"__p": _s238, "b": null}
	var _t458 = J.gp(J.G.get("Standup"), "list")
	var _t459 = (_t458 if J.t(_t458) else [])
	_s239["b"] = J.mc(_t459, "find", [Callable(self, "_f99").bind(_s239)])
	if J.t(((not J.t((J.gp(v_opt_412, "replay") if J.t(v_opt_412) else v_opt_412))) if J.t(_s239["b"]) else _s239["b"])):
		var _t460 = _s239["__p"]["__p"]["__p"]["__p"]["add"]
		var _t461 = J.gp(J.G.get("S"), "ghosts")
		J.cl(_t460, null, [J.mc(_t461, "find", [Callable(self, "_f100").bind(_s239)]), J.gp(_s239["__p"]["__p"]["__p"]["__p"]["TUNE"], "STANDUP")])
	return J.mc(_s238["__p"]["op"], "apply", [this_, a])

func _f103(this_, a: Array, env):
	var v_x_423 = null
	v_x_423 = J.arg(a, 0)
	var _t468 = J.seq(J.gp(v_x_423, "k"), J.gp(env["c"], 1.0))
	return (J.seq(J.gp(v_x_423, "q"), "名") if _t468 else _t468)

func _f102(this_, a: Array, env):
	var v_g_422 = null
	var _s247 = {"__p": env, "c": null}
	_s247["c"] = J.arg(a, 0)
	var _t467 = J.gp(J.G.get("S"), "ghosts")
	v_g_422 = J.mc(_t467, "find", [Callable(self, "_f103").bind(_s247)])
	if J.t(v_g_422):
		var _t469 = _s247["__p"]["__p"]["__p"]["add"]
		J.cl(_t469, null, [v_g_422, J.gp(_s247["__p"]["__p"]["__p"]["TUNE"], "SKIT")])

func _f101(this_, a: Array, env):
	var v_sc_420 = null; var v_e_424 = null
	v_sc_420 = J.arg(a, 0)
	if J.t((J.seq(J.gp(v_sc_420, "tag"), "陰間日常") if J.t(v_sc_420) else v_sc_420)):
		var _t465 = J.gp(v_sc_420, "cast")
		var _t466 = (_t465 if J.t(_t465) else [])
		J.mc(_t466, "forEach", [Callable(self, "_f102").bind(env)])
	return J.mc(env["op"], "apply", [this_, a])

func _f104(this_, a: Array, env):
	if J.t(J.mc(env["sh"], "querySelector", [".gcard,[data-act=recruit]"])):
		J.cl(env["__p"]["paintSheet"], null, [])

func _f84(this_, a: Array, env):
	var _s199 = {"__p": env, "sh": null}
	if J.t(_s199["__p"]["started"]):
		return null
	_s199["__p"]["started"] = true
	J.cl(_s199["__p"]["st"], null, [])
	J.cl(_s199["__p"]["cst"], null, [])
	J.S_window_("addEventListener", ["gb:nightEnd", Callable(self, "_f85").bind(_s199)])
	var _t399 = (not J.seq(J.typeof_(J.G.get("ART")), "undefined"))
	if J.t((J.gp(J.G.get("ART"), "drawChar") if _t399 else _t399)):
		var _s204 = {"__p": _s199, "od": null}
		_s204["od"] = J.gp(J.G.get("ART"), "drawChar")
		var _t400 = J.G.get("ART")
		var _t411 = Callable(self, "_f86").bind(_s204)
		J.sp(_t400, "drawChar", _t411)
	var _t412 = (not J.seq(J.typeof_(J.G.get("PlazaLife")), "undefined"))
	if J.t((J.gp(J.G.get("PlazaLife"), "frame") if _t412 else _t412)):
		var _s209 = {"__p": _s199, "of": null}
		_s209["of"] = J.gp(J.G.get("PlazaLife"), "frame")
		var _t413 = J.G.get("PlazaLife")
		var _t419 = Callable(self, "_f88").bind(_s209)
		J.sp(_t413, "frame", _t419)
	var _t420 = (not J.seq(J.typeof_(J.G.get("Village")), "undefined"))
	if J.t((J.gp(J.G.get("Village"), "update") if _t420 else _t420)):
		var _s215 = {"__p": _s199, "ou": null}
		_s215["ou"] = J.gp(J.G.get("Village"), "update")
		var _t421 = J.G.get("Village")
		var _t438 = Callable(self, "_f91").bind(_s215)
		J.sp(_t421, "update", _t438)
	if (not J.seq(J.typeof_(J.G.get("Battle")), "undefined")):
		if J.t(J.gp(J.G.get("Battle"), "mkGhostUnit")):
			var _s224 = {"__p": _s199, "om": null}
			_s224["om"] = J.gp(J.G.get("Battle"), "mkGhostUnit")
			var _t439 = J.G.get("Battle")
			var _t447 = Callable(self, "_f93").bind(_s224)
			J.sp(_t439, "mkGhostUnit", _t447)
		if J.t(J.gp(J.G.get("Battle"), "finish")):
			var _s229 = {"__p": _s199, "of": null}
			_s229["of"] = J.gp(J.G.get("Battle"), "finish")
			var _t448 = J.G.get("Battle")
			var _t455 = Callable(self, "_f94").bind(_s229)
			J.sp(_t448, "finish", _t455)
	var _t456 = (not J.seq(J.typeof_(J.G.get("Standup")), "undefined"))
	if J.t((J.gp(J.G.get("Standup"), "play") if _t456 else _t456)):
		var _s237 = {"__p": _s199, "op": null}
		_s237["op"] = J.gp(J.G.get("Standup"), "play")
		var _t457 = J.G.get("Standup")
		var _t462 = Callable(self, "_f98").bind(_s237)
		J.sp(_t457, "play", _t462)
	var _t463 = (not J.seq(J.typeof_(J.G.get("Theater")), "undefined"))
	if J.t((J.gp(J.G.get("Theater"), "play") if _t463 else _t463)):
		var _s244 = {"__p": _s199, "op": null}
		_s244["op"] = J.gp(J.G.get("Theater"), "play")
		var _t464 = J.G.get("Theater")
		var _t470 = Callable(self, "_f101").bind(_s244)
		J.sp(_t464, "play", _t470)
	_s199["sh"] = J.S_document_("querySelector", ["#sheet"])
	if J.t(((not J.seq(J.typeof_(J.G.get("MutationObserver")), "undefined")) if J.t(_s199["sh"]) else _s199["sh"])):
		var _t471 = J.new_("MutationObserver", [Callable(self, "_f104").bind(_s199)])
		J.mc(_t471, "observe", [_s199["sh"], {"childList": true, "subtree": true}])
	J.F_setInterval([_s199["__p"]["tick"], 2000.0])
	J.cl(_s199["__p"]["tick"], null, [])

func _f2(this_, a: Array, env):
	return (J.G.get("S") if (not J.seq(J.typeof_(J.G.get("S")), "undefined")) else null)

func _f3(this_, a: Array, env):
	var _t472 = J.seq(J.typeof_(J.G.get("LANG")), "undefined")
	return (_t472 if _t472 else (not J.seq(J.gp(J.G.get("LANG"), "cur"), "yue")))

func _f4(this_, a: Array, env):
	var v_l_62 = null
	v_l_62 = J.arg(a, 0)
	var _t473 = J.cl(env["zh"], null, [])
	return (J.gp(v_l_62, 2.0) if J.t((_t473 if J.t(_t473) else J.gp(env["WRITTEN"], J.gp(v_l_62, 0.0)))) else J.gp(v_l_62, 1.0))

func _f5(this_, a: Array, env):
	var v_id_63 = null
	v_id_63 = J.arg(a, 0)
	var _t474 = (J.gp(J.G.get("S"), "seen") if J.t(J.G.get("S")) else J.G.get("S"))
	return (not (not J.t((J.gp(J.gp(J.G.get("S"), "seen"), v_id_63) if J.t(_t474) else _t474))))

func _f6(this_, a: Array, env):
	var v_a_64 = null
	v_a_64 = J.arg(a, 0)
	return J.gp(v_a_64, floor(J.num((randf() * J.len(v_a_64)))))

func _f12(this_, a: Array, env):
	var v_g_79 = null
	v_g_79 = J.arg(a, 0)
	return (J.seq(J.gp(v_g_79, "k"), "afu") if J.t(v_g_79) else v_g_79)

func _f29(this_, a: Array, env):
	var v_s_168 = null
	v_s_168 = J.arg(a, 0)
	return J.seq(J.gp(v_s_168, "kind"), env["k"])

func _f28(this_, a: Array, env):
	var _s61 = {"__p": env, "k": null}
	_s61["k"] = J.arg(a, 0)
	var _t475 = J.seq(_s61["__p"]["cur"], _s61["k"])
	return (_t475 if _t475 else J.mc(_s61["__p"]["scenes"], "some", [Callable(self, "_f29").bind(_s61)]))

func _f105(this_, a: Array, env):
	var v_n_427 = null; var v_p_428 = null
	v_n_427 = J.arg(a, 0)
	v_p_428 = J.cl(env["st"], null, [])
	var _t476 = J.add(J.gp(v_p_428, "skew"), J.mul(v_n_427, env["DAY"]))
	J.sp(v_p_428, "skew", _t476)
	J.cl(env["update"], null, [])
	J.cl(env["contractTick"], null, [])
	J.cl(env["hud"], null, [])

func _f106(this_, a: Array, env):
	var v_g_431 = null; var v_v_432 = null
	v_g_431 = J.arg(a, 0)
	v_v_432 = J.arg(a, 1)
	var _t477 = env["set"]
	J.cl(_t477, null, [v_g_431, v_v_432])

func _f107(this_, a: Array, env):
	return env["scenes"]

func _f108(this_, a: Array, env):
	if J.t(J.len(env["scenes"])):
		var _t478 = env["runScene"]
		J.cl(_t478, null, [J.mc(env["scenes"], "shift", [])])

func _f109(this_, a: Array, env):
	var v_kind_437 = null; var v_extra_438 = null
	v_kind_437 = J.arg(a, 0)
	v_extra_438 = J.arg(a, 1)
	var _t479 = env["runScene"]
	J.cl(_t479, null, [J.S_Object_("assign", [{"kind": v_kind_437}, (v_extra_438 if J.t(v_extra_438) else {})])])

func _f110(this_, a: Array, env):
	var _t480 = env["newPeriod"]
	J.cl(_t480, null, [3.0])

func _f111(this_, a: Array, env):
	return env["playing"]

func _f1(this_, a: Array, env):
	var v_init_60 = null; var v_dev_61 = null
	var _s2 = {"__p": env, "DAY": null, "HOUR": null, "TUNE": null, "S_": null, "zh": null, "WRITTEN": null, "T": null, "seen": null, "rnd": null, "started": null, "scenes": null, "playing": null, "inPlaza": null, "lastBub": null, "sceneGap": null, "cur": null, "clock": null, "gday": null, "st": null, "cst": null, "isAfu": null, "val": null, "set": null, "add": null, "perk": null, "update": null, "legendLv": null, "daysLeft": null, "findG": null, "nightEnd": null, "kpiOf": null, "rankOf": null, "newPeriod": null, "has": null, "contractTick": null, "ART3": null, "LOOK": null, "keyOf": null, "reactor": null, "stage": null, "chat": null, "quiet": null, "runScene": null, "vanish": null, "resummon": null, "alphaOf": null, "gOfKey": null, "statMult": null, "bar": null, "badge": null, "paintSheet": null, "panelHTML": null, "OFFER": null, "offer": null, "openPanel": null, "bindPanel": null, "hud": null, "tick": null}
	_s2["clock"] = Callable(self, "_f7").bind(_s2)
	_s2["gday"] = Callable(self, "_f8").bind(_s2)
	_s2["st"] = Callable(self, "_f9").bind(_s2)
	_s2["cst"] = Callable(self, "_f11").bind(_s2)
	_s2["val"] = Callable(self, "_f13").bind(_s2)
	_s2["set"] = Callable(self, "_f14").bind(_s2)
	_s2["add"] = Callable(self, "_f15").bind(_s2)
	_s2["perk"] = Callable(self, "_f16").bind(_s2)
	_s2["update"] = Callable(self, "_f17").bind(_s2)
	_s2["legendLv"] = Callable(self, "_f19").bind(_s2)
	_s2["daysLeft"] = Callable(self, "_f20").bind(_s2)
	_s2["findG"] = Callable(self, "_f21").bind(_s2)
	_s2["nightEnd"] = Callable(self, "_f24").bind(_s2)
	_s2["kpiOf"] = Callable(self, "_f25").bind(_s2)
	_s2["rankOf"] = Callable(self, "_f26").bind(_s2)
	_s2["newPeriod"] = Callable(self, "_f27").bind(_s2)
	_s2["contractTick"] = Callable(self, "_f30").bind(_s2)
	_s2["keyOf"] = Callable(self, "_f31").bind(_s2)
	_s2["reactor"] = Callable(self, "_f32").bind(_s2)
	_s2["stage"] = Callable(self, "_f37").bind(_s2)
	_s2["chat"] = Callable(self, "_f41").bind(_s2)
	_s2["quiet"] = Callable(self, "_f43").bind(_s2)
	_s2["runScene"] = Callable(self, "_f44").bind(_s2)
	_s2["vanish"] = Callable(self, "_f54").bind(_s2)
	_s2["resummon"] = Callable(self, "_f57").bind(_s2)
	_s2["alphaOf"] = Callable(self, "_f59").bind(_s2)
	_s2["gOfKey"] = Callable(self, "_f60").bind(_s2)
	_s2["statMult"] = Callable(self, "_f62").bind(_s2)
	_s2["bar"] = Callable(self, "_f63").bind(_s2)
	_s2["badge"] = Callable(self, "_f64").bind(_s2)
	_s2["paintSheet"] = Callable(self, "_f65").bind(_s2)
	_s2["panelHTML"] = Callable(self, "_f72").bind(_s2)
	_s2["offer"] = Callable(self, "_f75").bind(_s2)
	_s2["openPanel"] = Callable(self, "_f77").bind(_s2)
	_s2["bindPanel"] = Callable(self, "_f78").bind(_s2)
	_s2["hud"] = Callable(self, "_f81").bind(_s2)
	_s2["tick"] = Callable(self, "_f83").bind(_s2)
	v_init_60 = Callable(self, "_f84").bind(_s2)
	_s2["DAY"] = 86400000.0
	_s2["HOUR"] = 3600000.0
	_s2["TUNE"] = {"DECAY": 4.0, "GRACE": 7.0, "FADE": 60.0, "LOWSTAT": 50.0, "WARN": 25.0, "COUNT": 12.0, "CD_DAYS": 3.0, "AFU_FLOOR": 35.0, "OFFLINE_FLOOR": 13.0, "RIPPLE": 6.0, "RIPPLE_STAR": 3.0, "SQUAD": 18.0, "SQUAD_SCARE": 4.0, "SQUAD_CAP": 45.0, "LEGEND": 2.0, "DAILY_LEGEND": 4.0, "WIN": 2.0, "STANDUP": 8.0, "SKIT": 3.0}
	_s2["S_"] = Callable(self, "_f2").bind(_s2)
	_s2["zh"] = Callable(self, "_f3").bind(_s2)
	_s2["WRITTEN"] = {"旁白": 1.0, "系統": 1.0, "寄件人": 1.0, "主旨": 1.0}
	_s2["T"] = Callable(self, "_f4").bind(_s2)
	_s2["seen"] = Callable(self, "_f5").bind(_s2)
	_s2["rnd"] = Callable(self, "_f6").bind(_s2)
	_s2["started"] = false
	_s2["scenes"] = []
	_s2["playing"] = false
	_s2["inPlaza"] = false
	_s2["lastBub"] = null
	_s2["sceneGap"] = 0.0
	_s2["cur"] = null
	_s2["isAfu"] = Callable(self, "_f12").bind(_s2)
	_s2["has"] = Callable(self, "_f28").bind(_s2)
	_s2["ART3"] = {"阿福": "afu", "冼小姐": "npc_hr", "龐總": "npc_kpiboss", "Bryan": "npc_rival"}
	_s2["LOOK"] = {"龐總": {"base": "ag:inspect", "talk": "ag:tap"}, "Bryan": {"base": "ag:spin", "talk": "ag:dribble"}, "冼小姐": {"base": "ag:clip", "talk": "ag:glasses"}}
	_s2["OFFER"] = {"buns": 30.0, "add": 12.0}
	v_dev_61 = {"days": Callable(self, "_f105").bind(_s2), "set": Callable(self, "_f106").bind(_s2), "scenes": Callable(self, "_f107").bind(_s2), "run": Callable(self, "_f108").bind(_s2), "play": Callable(self, "_f109").bind(_s2), "issue": Callable(self, "_f110").bind(_s2), "newPeriod": _s2["newPeriod"], "vanish": _s2["vanish"], "resummon": _s2["resummon"]}
	return {"TUNE": _s2["TUNE"], "st": _s2["st"], "cst": _s2["cst"], "val": _s2["val"], "add": _s2["add"], "perk": _s2["perk"], "alphaOf": _s2["alphaOf"], "statMult": _s2["statMult"], "nightEnd": _s2["nightEnd"], "kpiOf": _s2["kpiOf"], "update": _s2["update"], "contractTick": _s2["contractTick"], "daysLeft": _s2["daysLeft"], "openPanel": _s2["openPanel"], "panelHTML": _s2["panelHTML"], "hud": _s2["hud"], "init": v_init_60, "tick": _s2["tick"], "dev": v_dev_61, "__getters": {"playing": Callable(self, "_f111").bind(_s2)}}

func _f112(this_, a: Array, env):
	var v_presenceBoot_445 = null; var v_e_446 = null
	v_presenceBoot_445 = Callable(self, "_f112").bind(env)
	var _t481 = J.seq(J.typeof_(J.G.get("S")), "undefined")
	var _t482 = (_t481 if _t481 else (not J.t(J.G.get("S"))))
	var _t483 = (_t482 if _t482 else J.seq(J.typeof_(J.G.get("Village")), "undefined"))
	if (_t483 if _t483 else (not J.t(J.S_document_("querySelector", ["#sheet"])))):
		J.F_setTimeout([v_presenceBoot_445, 300.0])
		return null
	J.mc(J.G.get("Presence"), "init", [])
