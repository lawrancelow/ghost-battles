# 自動轉譯自 rivals.js（tools/jsgd.js）——唔好直接改，改原 JS 再轉
extends RefCounted

func run(env):
	var this_ = null; var a = []
	J.G["Rivals"] = J.cl(Callable(self, "_f1").bind(env), null, [])

func _f4(this_, a: Array, env):
	var v_a_53 = null
	var _t1 = J.seq(J.typeof_(J.G.get("S")), "undefined")
	if (_t1 if _t1 else (not J.t(J.G.get("S")))):
		return null
	var _t2 = J.G.get("S")
	var _t3 = J.gp(J.G.get("S"), "antag")
	var _t4 = (_t3 if J.t(_t3) else {})
	J.sp(_t2, "antag", _t4)
	v_a_53 = _t4
	var _t5 = J.gp(v_a_53, "clock")
	var _t6 = (_t5 if J.t(_t5) else 0.0)
	J.sp(v_a_53, "clock", _t6)
	if (not J.seq(J.typeof_(J.gp(v_a_53, "gap")), "number")):
		J.sp(v_a_53, "gap", 200.0)
	var _t7 = J.gp(v_a_53, "n")
	var _t8 = (_t7 if J.t(_t7) else {})
	J.sp(v_a_53, "n", _t8)
	var _t10 = {"task": null, "visits": 0.0, "pass": 0.0, "fail": 0.0, "slowUntil": 0.0}
	var _t9 = J.gp(v_a_53, "boss")
	var _t11 = J.S_Object_("assign", [_t10, (_t9 if J.t(_t9) else {})])
	J.sp(v_a_53, "boss", _t11)
	var _t13 = {"met": false, "arc": 0.0, "pend": null, "rumor": null, "stolen": 0.0, "grudge": 0.0, "peaceUntil": 0.0, "beaten": false, "duels": 0.0}
	var _t12 = J.gp(v_a_53, "rival")
	var _t14 = J.S_Object_("assign", [_t13, (_t12 if J.t(_t12) else {})])
	J.sp(v_a_53, "rival", _t14)
	var _t16 = {"met": false, "warn": 0.0, "visits": 0.0, "done": {}}
	var _t15 = J.gp(v_a_53, "hr")
	var _t17 = J.S_Object_("assign", [_t16, (_t15 if J.t(_t15) else {})])
	J.sp(v_a_53, "hr", _t17)
	return v_a_53

func _f5(this_, a: Array, env):
	var v_key_56 = null; var v_pool_57 = null; var v_a_58 = null; var v_i_59 = null
	v_key_56 = J.arg(a, 0)
	v_pool_57 = J.arg(a, 1)
	v_a_58 = J.cl(env["st"], null, [])
	var _t18 = J.gp(v_a_58, "n")
	var _t19 = J.gp(J.gp(v_a_58, "n"), v_key_56)
	var _t20 = J.add((_t19 if J.t(_t19) else 0.0), 1.0)
	J.sp(_t18, v_key_56, _t20)
	v_i_59 = J.sub(_t20, 1.0)
	return J.gp(v_pool_57, J.mod(v_i_59, J.len(v_pool_57)))

func _f9(this_, a: Array, env):
	var v_l_64 = null; var v_w_65 = null; var v_t_66 = null; var v_a_67 = null
	v_l_64 = J.arg(a, 0)
	var _t21 = (not J.t(J.S_Array_("isArray", [v_l_64])))
	if J.t((_t21 if _t21 else J.gp(v_l_64, 2.0))):
		return v_l_64
	var _t22 = J.gp(v_l_64, 0.0)
	v_w_65 = _t22
	var _t23 = J.gp(v_l_64, 1.0)
	v_t_66 = _t23
	v_a_67 = null
	var _t24 = J.seq(v_w_65, "冼小姐")
	if J.t((J.mc(J.re("蓋印|批。|駁回|警告信", ""), "test", [v_t_66]) if _t24 else _t24)):
		v_a_67 = "ag:stamp"
	else:
		var _t25 = J.seq(v_w_65, "龐總")
		if J.t((J.mc(J.re("未達標|差少少|失禮|冇用", ""), "test", [v_t_66]) if _t25 else _t25)):
			v_a_67 = "ag:yell"
		else:
			var _t26 = J.seq(v_w_65, "龐總")
			if J.t((J.mc(J.re("唔達標|罰", ""), "test", [v_t_66]) if _t26 else _t26)):
				v_a_67 = "ag:sigh"
			else:
				var _t27 = J.seq(v_w_65, "Bryan")
				if J.t((J.mc(J.re("轉述|唔好話我講|不值|私底下|細細聲", ""), "test", [v_t_66]) if _t27 else _t27)):
					v_a_67 = "ag:gossip"
				else:
					var _t28 = J.seq(v_w_65, "Bryan")
					if J.t((J.mc(J.re("假波|助攻！|沖茶點計", ""), "test", [v_t_66]) if _t28 else _t28)):
						v_a_67 = "ag:jump"
					else:
						var _t29 = J.seq(v_w_65, "Bryan")
						if J.t((J.mc(J.re("承讓|我入嘅|三分", ""), "test", [v_t_66]) if _t29 else _t29)):
							v_a_67 = "ag:jumpshot"
	var _t31 = null
	if J.t(v_a_67):
		var _t30 = [v_w_65, v_t_66, v_a_67]
		_t31 = J.mc(_t30, "concat", [J.mc(v_l_64, "slice", [3.0])])
	else:
		_t31 = v_l_64
	return _t31

func _f8(this_, a: Array, env):
	var v_lines_63 = null
	v_lines_63 = J.arg(a, 0)
	return J.mc(v_lines_63, "map", [Callable(self, "_f9").bind(env)])

func _f11(this_, a: Array, env):
	var v_c_73 = null
	v_c_73 = J.arg(a, 0)
	var _t38 = null
	if J.t(J.gp(env["__p"]["LOOK"], J.gp(v_c_73, 0.0))):
		var _t36 = J.gp(v_c_73, 0.0)
		var _t37 = J.gp(v_c_73, 1.0)
		var _t34 = {}
		var _t35 = J.gp(env["__p"]["LOOK"], J.gp(v_c_73, 0.0))
		var _t33 = J.gp(v_c_73, 2.0)
		_t38 = [_t36, _t37, J.S_Object_("assign", [_t34, _t35, (_t33 if J.t(_t33) else {})])]
	else:
		_t38 = v_c_73
	return _t38

func _f13(this_, a: Array, env):
	var v_p_78 = null; var v_r_79 = null
	v_p_78 = J.arg(a, 0)
	var _t46 = env["on"]
	v_r_79 = J.cl(_t46, null, [v_p_78])
	var _t48 = null
	if J.t(J.S_Array_("isArray", [v_r_79])):
		var _t47 = env["__p"]["__p"]["deco"]
		_t48 = J.cl(_t47, null, [v_r_79])
	else:
		_t48 = v_r_79
	return _t48

func _f14(this_, a: Array, env):
	var v_p_81 = null
	v_p_81 = J.arg(a, 0)
	var _t50 = env["__p"]["wrapC"]
	var _t51 = env["nx"]
	return J.cl(_t50, null, [J.cl(_t51, null, [v_p_81])])

func _f12(this_, a: Array, env):
	var v_c_74 = null; var v_k_75 = null; var v_o_76 = null
	v_c_74 = J.arg(a, 0)
	if (not J.t(v_c_74)):
		return v_c_74
	for _t42 in J.iter(["a", "b", "c"]):
		v_k_75 = _t42
		if J.t(J.gp(v_c_74, v_k_75)):
			v_o_76 = J.gp(v_c_74, v_k_75)
			var _t43 = env["__p"]["deco"]
			var _t44 = J.gp(v_o_76, "lines")
			var _t45 = J.cl(_t43, null, [(_t44 if J.t(_t44) else [])])
			J.sp(v_o_76, "lines", _t45)
			if J.t(J.gp(v_o_76, "on")):
				var _s16 = {"__p": env, "on": null}
				_s16["on"] = J.gp(v_o_76, "on")
				var _t49 = Callable(self, "_f13").bind(_s16)
				J.sp(v_o_76, "on", _t49)
			if J.t(J.gp(v_o_76, "next")):
				var _s18 = {"__p": env, "nx": null}
				_s18["nx"] = J.gp(v_o_76, "next")
				var _t53 = null
				if J.seq(J.typeof_(_s18["nx"]), "function"):
					_t53 = Callable(self, "_f14").bind(_s18)
				else:
					var _t52 = _s18["__p"]["wrapC"]
					_t53 = J.cl(_t52, null, [_s18["nx"]])
				J.sp(v_o_76, "next", _t53)
	return v_c_74

func _f10(this_, a: Array, env):
	var v_sc_70 = null; var v_cb_71 = null
	var _s11 = {"__p": env, "wrapC": null}
	v_sc_70 = J.arg(a, 0)
	v_cb_71 = J.arg(a, 1)
	var _t32 = J.gp(v_sc_70, "cast")
	var _t39 = J.mc(_t32, "map", [Callable(self, "_f11").bind(_s11)])
	J.sp(v_sc_70, "cast", _t39)
	var _t40 = _s11["__p"]["deco"]
	var _t41 = J.cl(_t40, null, [J.gp(v_sc_70, "lines")])
	J.sp(v_sc_70, "lines", _t41)
	_s11["wrapC"] = Callable(self, "_f12").bind(_s11)
	var _t54 = _s11["wrapC"]
	var _t55 = J.cl(_t54, null, [J.gp(v_sc_70, "choice")])
	J.sp(v_sc_70, "choice", _t55)
	J.mc(J.G.get("Theater"), "play", [v_sc_70, v_cb_71])

func _f15(this_, a: Array, env):
	var v_h_84 = null; var v_e_85 = null
	v_h_84 = J.arg(a, 0)
	J.mc(J.G.get("Fx"), "toast", [v_h_84])

func _f16(this_, a: Array, env):
	var v_e_88 = null
	J.cl(J.G.get("save"), null, [])
	J.mc(J.G.get("UI"), "refresh", [])

func _f19(this_, a: Array, env):
	var v_ci_103 = null; var v_si_104 = null; var v_sid_105 = null; var v_stg_106 = null; var v_prev_107 = null; var v_e_108 = null
	v_ci_103 = 0.0
	while true:
		if not J.cmp(v_ci_103, J.len(J.G.get("CHAPTERS")), "<"): break
		v_si_104 = 0.0
		while true:
			if not J.cmp(v_si_104, J.len(J.gp(J.gp(J.G.get("CHAPTERS"), v_ci_103), "stages")), "<"): break
			v_sid_105 = J.mc(J.G.get("Battle"), "sidOf", [v_ci_103, v_si_104])
			v_stg_106 = J.gp(J.gp(J.gp(J.G.get("CHAPTERS"), v_ci_103), "stages"), v_si_104)
			if J.t(J.gp(J.gp(J.G.get("S"), "cleared"), v_sid_105)):
				v_si_104 = J.num(v_si_104) + 1.0
				continue
			v_prev_107 = (J.mc(J.G.get("Battle"), "sidOf", [v_ci_103, J.sub(v_si_104, 1.0)]) if J.cmp(v_si_104, 0.0, ">") else (J.mc(J.G.get("Battle"), "sidOf", [J.sub(v_ci_103, 1.0), (J.len(J.gp(J.gp(J.G.get("CHAPTERS"), J.sub(v_ci_103, 1.0)), "stages")) - 1.0)]) if J.cmp(v_ci_103, 0.0, ">") else null))
			var _t56 = (not J.t(v_prev_107))
			var _t57 = (_t56 if _t56 else J.gp(J.gp(J.G.get("S"), "cleared"), v_prev_107))
			if J.t((J.cmp(J.gp(J.G.get("S"), "lv"), J.gp(v_stg_106, "req"), ">=") if J.t(_t57) else _t57)):
				return true
			return false
			v_si_104 = J.num(v_si_104) + 1.0
		v_ci_103 = J.num(v_ci_103) + 1.0
	return false

func _f44(this_, a: Array, env):
	var v_t_137 = null
	var _t67 = J.G.get("give")
	var _t68 = J.G.get("rwd")
	v_t_137 = J.cl(_t67, null, [{"coins": J.cl(_t68, null, [18.0])}])
	return [["旁白", ("阿福躲過了。" + J.str(v_t_137))]]

func _f45(this_, a: Array, env):
	var _t69 = env["b"]
	var _t70 = J.add(J.cl(env["__p"]["now"], null, []), (5.0 * 60000.0))
	J.sp(_t69, "slowUntil", _t70)
	return [["旁白", "阿福一句「收到」，全村陪他加班。懲罰：全村工作速度 −15%（5 分鐘）。"]]

func _f46(this_, a: Array, env):
	return J.cl(env["__p"]["done"], null, [])

func _f47(this_, a: Array, env):
	var v_k_138 = null
	v_k_138 = J.arg(a, 0)
	return J.mc(J.gp(env["__p"]["TASKS"], v_k_138), "ok", [])

func _f48(this_, a: Array, env):
	J.cl(env["__p"]["done"], null, [])
	J.cl(env["__p"]["hud"], null, [])

func _f43(this_, a: Array, env):
	var v_a_123 = null; var v_first_125 = null; var v_cast_126 = null; var v_open_127 = null; var v_kinds_128 = null; var v_k_129 = null; var v_T_130 = null; var v_n_131 = null; var v_m_132 = null; var v_d_133 = null; var v_smartIsA_134 = null; var v_smart_135 = null; var v_dumb_136 = null
	var _s65 = {"__p": env, "b": null}
	v_a_123 = J.cl(_s65["__p"]["st"], null, [])
	_s65["b"] = J.gp(v_a_123, "boss")
	v_first_125 = (not J.t(J.gp(_s65["b"], "visits")))
	var _t58 = _s65["b"]
	J.sp(_t58, "visits", J.num(J.gp(_t58, "visits")) + 1.0)
	v_cast_126 = [["阿福", "afu"], ["龐總", J.gp(_s65["__p"]["ART"], "boss")]]
	var _t60 = null
	if J.t(v_first_125):
		_t60 = [["旁白", "一隻矮矮胖胖、頭髮梳得發亮的鬼，拿著一部平板飄進村子。平板上，一條紅線一路向下。"], ["龐總", "阿福。我係地府集團營運總監，龐總。我唔係針對你，我係針對你嘅數字。"]]
	else:
		var _t59 = _s65["__p"]["rot"]
		_t60 = [["龐總", J.cl(_t59, null, ["bossOpen", _s65["__p"]["BOSS_OPEN"]])]]
	v_open_127 = _t60
	var _t61 = (not J.t(v_first_125))
	if (J.cmp(J.cl(_s65["__p"]["R"], null, []), 0.3, "<") if _t61 else _t61):
		var _t62 = _s65["__p"]["rot"]
		v_d_133 = J.cl(_t62, null, ["absurd", _s65["__p"]["ABSURD"]])
		v_smartIsA_134 = J.cmp(J.cl(_s65["__p"]["R"], null, []), 0.5, "<")
		var _t66 = J.gp(v_d_133, "smart")
		var _t63 = J.G.get("L")
		var _t64 = J.cl(_t63, null, [J.gp(v_d_133, "smart")])
		var _t65 = [["阿福", J.mc(_t64, "replace", [J.re("[「」]", "g"), ""])]]
		v_smart_135 = {"label": _t66, "lines": J.mc(_t65, "concat", [J.gp(v_d_133, "dodge")]), "on": Callable(self, "_f44").bind(_s65)}
		v_dumb_136 = {"label": "「收到。」", "lines": [["阿福", "收到。"], ["龐總", "好。我就鍾意你呢種員工。"]], "on": Callable(self, "_f45").bind(_s65)}
		var _t71 = _s65["__p"]["play"]
		var _t73 = J.mc(v_open_127, "concat", [[["龐總", J.gp(v_d_133, "ask")]]])
		var _t72 = J.G.get("L")
		J.cl(_t71, null, [{"tag": "察 KPI", "title": "龐總：要求", "bg": "village", "cast": v_cast_126, "lines": _t73, "choice": {"plain": true, "q": J.add("龐總要求：", J.cl(_t72, null, [J.gp(v_d_133, "ask")])), "a": (v_smart_135 if J.t(v_smartIsA_134) else v_dumb_136), "b": (v_dumb_136 if J.t(v_smartIsA_134) else v_smart_135)}}, Callable(self, "_f46").bind(_s65)])
		return null
	var _t74 = J.S_Object_("keys", [_s65["__p"]["TASKS"]])
	v_kinds_128 = J.mc(_t74, "filter", [Callable(self, "_f47").bind(_s65)])
	v_k_129 = J.gp(v_kinds_128, floor(J.num(J.mul(J.cl(_s65["__p"]["R"], null, []), J.len(v_kinds_128)))))
	v_T_130 = J.gp(_s65["__p"]["TASKS"], v_k_129)
	v_n_131 = J.mc(v_T_130, "n", [])
	v_m_132 = J.gp(v_T_130, "m")
	var _t75 = _s65["b"]
	var _t76 = {"k": v_k_129, "n": v_n_131, "base": (0.0 if J.t(J.gp(v_T_130, "abs")) else J.mc(v_T_130, "val", [])), "due": J.add(J.gp(v_a_123, "clock"), J.mul(v_m_132, 60.0)), "set": J.gp(v_a_123, "clock"), "what": J.gp(v_T_130, "what"), "unit": J.gp(v_T_130, "unit")}
	J.sp(_t75, "task", _t76)
	var _t77 = _s65["__p"]["play"]
	var _t78 = J.mc(v_open_127, "concat", [J.mc(v_T_130, "lines", [v_n_131, v_m_132])])
	J.cl(_t77, null, [{"tag": "察 KPI", "title": "龐總：突擊巡查", "bg": "village", "cast": v_cast_126, "lines": J.mc(_t78, "concat", [[["旁白", ("KPI：" + J.str(v_m_132) + " 分鐘內" + J.str(J.gp(v_T_130, "what")) + " " + J.str(v_n_131) + J.str(J.gp(v_T_130, "unit")) + "。進度見左下角。")]]])}, Callable(self, "_f48").bind(_s65)])

func _f50(this_, a: Array, env):
	var _t80 = J.gp(env["a"], "boss")
	var _t81 = J.add(J.cl(env["__p"]["now"], null, []), (4.0 * 60000.0))
	J.sp(_t80, "slowUntil", _t81)
	return [["旁白", "懲罰：全村陪你熬夜，工作速度 −15%（4 分鐘）"]]

func _f51(this_, a: Array, env):
	var _t82 = J.G.get("give")
	var _t83 = J.G.get("rwd")
	var _t85 = J.cl(_t83, null, [20.0])
	var _t84 = J.G.get("rwd")
	return [["旁白", ("睡飽了：" + J.str(J.cl(_t82, null, [{"coins": _t85, "exp": J.cl(_t84, null, [8.0])}])))]]

func _f54(this_, a: Array, env):
	return J.cl(env["__p"]["done"], null, [])

func _f53(this_, a: Array, env):
	var _t89 = env["__p"]["play"]
	return J.cl(_t89, null, [{"tag": "察 KPI", "title": "已讀不回", "bg": "village", "cast": [["阿福", "afu", {"onstage": true}]], "lines": [["旁白", "阿福看著手機，手指在發抖。三年來，他每晚都是這樣，馬上回覆「收到」。"]], "choice": env["choice"]}, Callable(self, "_f54").bind(env)])

func _f52(this_, a: Array, env):
	return J.F_setTimeout([Callable(self, "_f53").bind(env), 80.0])

func _f49(this_, a: Array, env):
	var v_chat_142 = null; var v_x_144 = null
	var _s72 = {"__p": env, "a": null, "choice": null}
	_s72["a"] = J.cl(_s72["__p"]["st"], null, [])
	var _t79 = J.gp(_s72["a"], "boss")
	J.sp(_t79, "group", 1.0)
	v_chat_142 = {"style": "chat", "title": "地府集團優化小組", "group": "龐總、白無常、黑無常、阿福…", "av": ["優", "#6a3a3a"], "lines": [["龐總", "23:58|各位，由聽日起，每隻鬼每日要嚇夠三個人，計入 KPI"], ["白無常", "23:58|收到！一見生財！"], ["黑無常", "23:59|知道。"], ["龐總", "00:01|仲有，聽朝大家提早半個鐘出嚟"], ["白無常", "00:02|龐總，我哋係鬼，朝早出唔到嚟喎"], ["龐總", "00:02|唔好俾藉口我"], ["龐總", "00:03|@阿福 你呢？"]]}
	_s72["choice"] = {"plain": true, "q": "凌晨十二點零三分。龐總在等你回覆。", "a": {"label": "回覆：「收到。」", "lines": [["旁白", "手指比腦袋快，「收到」已經送出。"], ["旁白", "龐總秒回：「好。順便交埋份報告。」"]], "on": Callable(self, "_f50").bind(_s72)}, "b": {"label": "已讀。不回。把手機放下。", "lines": [["旁白", "已讀，不回。"], ["旁白", "那是阿福做鬼以來，睡得最好的一個晚上。"]], "on": Callable(self, "_f51").bind(_s72)}}
	if J.cmp(J.cl(_s72["__p"]["R"], null, []), 0.5, "<"):
		v_x_144 = J.gp(_s72["choice"], "a")
		var _t86 = _s72["choice"]
		var _t87 = J.gp(_s72["choice"], "b")
		J.sp(_t86, "a", _t87)
		var _t88 = _s72["choice"]
		J.sp(_t88, "b", v_x_144)
	J.mc(J.G.get("Story"), "queue", [v_chat_142, Callable(self, "_f52").bind(_s72)])

func _f55(this_, a: Array, env):
	var v_a_147 = null; var v_t_148 = null; var v_T_149 = null; var v_v_150 = null
	v_a_147 = J.cl(env["st"], null, [])
	v_t_148 = J.gp(J.gp(v_a_147, "boss"), "task")
	if (not J.t(v_t_148)):
		return null
	v_T_149 = J.gp(env["TASKS"], J.gp(v_t_148, "k"))
	v_v_150 = J.sub(J.mc(v_T_149, "val", []), J.gp(v_t_148, "base"))
	return {"v": J.max_([0.0, v_v_150]), "n": J.gp(v_t_148, "n"), "left": J.max_([0.0, J.sub(J.gp(v_t_148, "due"), J.gp(v_a_147, "clock"))])}

func _f57(this_, a: Array, env):
	J.cl(env["done"], null, [])
	J.cl(env["hud"], null, [])

func _f56(this_, a: Array, env):
	var v_a_153 = null; var v_b_154 = null; var v_p_155 = null; var v_pass_156 = null; var v_t_157 = null; var v_lines_158 = null; var v_r_159 = null; var v_c_160 = null
	v_a_153 = J.cl(env["st"], null, [])
	v_b_154 = J.gp(v_a_153, "boss")
	v_p_155 = J.cl(env["taskProg"], null, [])
	v_pass_156 = J.cmp(J.gp(v_p_155, "v"), J.gp(v_p_155, "n"), ">=")
	v_t_157 = J.gp(v_b_154, "task")
	J.sp(v_b_154, "task", null)
	var _t90 = J.G.get("Lf")
	v_lines_158 = [["龐總", J.cl(_t90, null, ["嚟收數。KPI：{w} {n}{u}。你做到 {v}{u}。", {"w": J.gp(v_t_157, "what"), "n": J.gp(v_t_157, "n"), "u": J.gp(v_t_157, "unit"), "v": J.min_([J.gp(v_p_155, "v"), 999.0])}])]]
	if J.t(v_pass_156):
		J.sp(v_b_154, "pass", J.num(J.gp(v_b_154, "pass")) + 1.0)
		var _t91 = env["rot"]
		var _t92 = J.mc(v_lines_158, "concat", [J.cl(_t91, null, ["bossPass", env["BOSS_PASS"]])])
		v_lines_158 = _t92
		var _t93 = J.G.get("give")
		var _t94 = J.G.get("rwd")
		var _t96 = J.cl(_t94, null, [30.0])
		var _t95 = J.G.get("rwd")
		v_r_159 = J.cl(_t93, null, [{"coins": _t96, "exp": J.cl(_t95, null, [6.0])}])
		J.mc(v_lines_158, "push", [["旁白", ("達標獎勵：" + J.str(v_r_159))]])
	else:
		J.sp(v_b_154, "fail", J.num(J.gp(v_b_154, "fail")) + 1.0)
		var _t97 = env["rot"]
		var _t98 = J.mc(v_lines_158, "concat", [J.cl(_t97, null, ["bossFail", env["BOSS_FAIL"]])])
		v_lines_158 = _t98
		if J.t(J.mod(J.gp(v_b_154, "fail"), 2.0)):
			var _t100 = floor(J.num(J.gp(J.gp(J.G.get("S"), "res"), "coins")))
			var _t99 = J.G.get("rwd")
			var _t102 = floor(J.num(J.gp(J.gp(J.G.get("S"), "res"), "coins")))
			var _t101 = J.G.get("rwd")
			v_c_160 = J.min_([_t102, J.cl(_t101, null, [20.0])])
			var _t103 = J.gp(J.G.get("S"), "res")
			var _t104 = J.sub(J.gp(_t103, "coins"), v_c_160)
			J.sp(_t103, "coins", _t104)
			J.mc(v_lines_158, "push", [["旁白", (("懲罰：冥幣 −" + J.str(v_c_160)) if J.t(v_c_160) else "懲罰：冥幣——可惜你身上沒有冥幣。龐總在平板上記下：「此員工連罰都罰唔落。」")]])
		else:
			var _t105 = J.add(J.cl(env["now"], null, []), (5.0 * 60000.0))
			J.sp(v_b_154, "slowUntil", _t105)
			J.mc(v_lines_158, "push", [["旁白", "懲罰：全村工作速度 −15%（5 分鐘）"]])
	var _t106 = env["play"]
	J.cl(_t106, null, [{"tag": "察 KPI", "title": ("龐總：收數（達標）" if J.t(v_pass_156) else "龐總：收數（唔達標）"), "bg": "village", "cast": [["阿福", "afu"], ["龐總", J.gp(env["ART"], "boss")]], "lines": v_lines_158}, Callable(self, "_f57").bind(env)])

func _f58(this_, a: Array, env):
	var v_best_163 = null; var v_v_164 = null; var v_g_165 = null; var v_x_166 = null
	v_best_163 = null
	v_v_164 = (-1.0)
	for _t107 in J.iter(J.gp(J.G.get("S"), "ghosts")):
		v_g_165 = _t107
		if J.seq(J.gp(v_g_165, "k"), "afu"):
			continue
		v_x_166 = J.mc(J.G.get("F"), "stat", [v_g_165, 1.0])
		if J.cmp(v_x_166, v_v_164, ">"):
			v_v_164 = v_x_166
			v_best_163 = v_g_165
	return ({"g": v_best_163, "v": v_v_164} if J.t(v_best_163) else null)

func _f59(this_, a: Array, env):
	var v_a_169 = null
	v_a_169 = J.cl(env["st"], null, [])
	if J.t(J.gp(J.gp(v_a_169, "rival"), "met")):
		return []
	var _t108 = J.gp(v_a_169, "rival")
	J.sp(_t108, "met", true)
	return [["旁白", "一隻高高瘦瘦、留著銀灰色平頭的鬼，一邊拍著籃球一邊飄過來。"], ["阿福", "……Bryan？你點會喺度？"], ["Bryan", "兄弟！好耐冇見！上個月公司籃球賽，我入咗個 slam dunk，太興奮，就落咗嚟。"], ["Bryan", "而家我喺地府集團做業務拓展。我哋又係同事喇！"], ["阿福", "（細細聲）生前佢坐我隔籬。我做嘅 report，佢 present。"]]

func _f61(this_, a: Array, env):
	var v_t_184 = null
	var _t133 = env["r"]
	J.sp(_t133, "arc", J.num(J.gp(_t133, "arc")) + 1.0)
	var _t134 = env["r"]
	var _t135 = J.max_([0.0, J.sub(J.gp(env["r"], "grudge"), 1.0)])
	J.sp(_t134, "grudge", _t135)
	var _t136 = J.G.get("give")
	var _t137 = J.G.get("rwd")
	v_t_184 = J.cl(_t136, null, [{J.key(env["res"]): J.cl(_t137, null, [15.0])}])
	var _t138 = env["__p"]["rot"]
	return [["Bryan", J.cl(_t138, null, ["run", env["__p"]["BRYAN_RUN"]])], ["旁白", ("證據確鑿，一分也沒被拿走。另外獲得：" + J.str(v_t_184))]]

func _f62(this_, a: Array, env):
	var _t140 = env["r"]
	J.sp(_t140, "arc", J.num(J.gp(_t140, "arc")) + 1.0)
	var _t141 = env["r"]
	J.sp(_t141, "grudge", J.num(J.gp(_t141, "grudge")) + 1.0)
	return []

func _f63(this_, a: Array, env):
	var _t142 = J.gp(J.G.get("S"), "res")
	var _t143 = env["res"]
	var _t144 = J.sub(J.gp(_t142, _t143), env["amt"])
	J.sp(_t142, _t143, _t144)
	var _t145 = env["r"]
	var _t146 = J.add(J.gp(_t145, "stolen"), (env["amt"] if J.seq(env["res"], "coins") else 0.0))
	J.sp(_t145, "stolen", _t146)
	var _t147 = env["r"]
	J.sp(_t147, "arc", J.num(J.gp(_t147, "arc")) + 1.0)
	var _t148 = env["r"]
	var _t149 = J.add(J.gp(env["a"], "clock"), (15.0 * 60.0))
	J.sp(_t148, "peaceUntil", _t149)
	return []

func _f64(this_, a: Array, env):
	var v_res2_185 = null
	v_res2_185 = J.arg(a, 0)
	var _t151 = J.gp(v_res2_185, "skipped")
	if J.t(((not J.t(J.len(J.gp(v_res2_185, "picks")))) if J.t(_t151) else _t151)):
		var _t152 = env["r"]
		J.sp(_t152, "grudge", J.num(J.gp(_t152, "grudge")) + 1.0)
	J.cl(env["__p"]["done"], null, [])

func _f60(this_, a: Array, env):
	var v_p_174 = null; var v_amtTxt_177 = null; var v_need_178 = null; var v_sm_179 = null; var v_cast_180 = null; var v_lines_181 = null; var v_okEv_182 = null; var v_choice_183 = null
	var _s91 = {"__p": env, "a": null, "r": null, "amt": null, "res": null}
	_s91["a"] = J.cl(_s91["__p"]["st"], null, [])
	_s91["r"] = J.gp(_s91["a"], "rival")
	v_p_174 = J.gp(_s91["r"], "pend")
	var _t109 = _s91["r"]
	J.sp(_t109, "pend", null)
	var _t111 = floor(J.num(J.gp(J.gp(J.G.get("S"), "res"), "coins")))
	var _t110 = J.G.get("rwd")
	var _t113 = floor(J.num(J.gp(J.gp(J.G.get("S"), "res"), "coins")))
	var _t112 = J.G.get("rwd")
	_s91["amt"] = J.min_([_t113, J.cl(_t112, null, [25.0])])
	_s91["res"] = "coins"
	if J.cmp(_s91["amt"], 8.0, "<"):
		var _t115 = floor(J.num(J.gp(J.gp(J.G.get("S"), "res"), "buns")))
		var _t114 = J.G.get("rwd")
		var _t117 = floor(J.num(J.gp(J.gp(J.G.get("S"), "res"), "buns")))
		var _t116 = J.G.get("rwd")
		var _t118 = J.min_([_t117, J.cl(_t116, null, [20.0])])
		_s91["amt"] = _t118
		_s91["res"] = "buns"
	v_amtTxt_177 = (J.str(J.gp(J.G.get("RES_NAMES"), _s91["res"])) + " " + J.str(_s91["amt"]))
	v_need_178 = (60.0 + (12.0 * J.min_([3.0, J.gp(_s91["r"], "arc")])))
	v_sm_179 = J.cl(_s91["__p"]["smartest"], null, [])
	v_cast_180 = [["阿福", "afu"], ["Bryan", J.gp(_s91["__p"]["ART"], "rival")]]
	if J.t(v_sm_179):
		J.mc(v_cast_180, "splice", [1.0, 0.0, [J.gp(J.gp(v_sm_179, "g"), "name"), J.gp(J.gp(v_sm_179, "g"), "k")]])
	var _t119 = J.cl(_s91["__p"]["rivalIntro"], null, [])
	var _t120 = J.G.get("Lf")
	var _t121 = _s91["__p"]["rot"]
	var _t123 = ["Bryan", J.cl(_t120, null, [J.cl(_t121, null, ["claim", _s91["__p"]["BRYAN_CLAIM"]]), {"w": J.gp(v_p_174, "what")}]), "wave"]
	var _t122 = J.G.get("Lf")
	v_lines_181 = J.mc(_t119, "concat", [[_t123, ["Bryan", J.cl(_t122, null, ["所以呢份獎勵，我攞返我應得嗰份：{a}。大家隊友，唔好計得咁盡啦。", {"a": v_amtTxt_177}])]]])
	v_okEv_182 = (J.cmp(J.gp(v_sm_179, "v"), v_need_178, ">=") if J.t(v_sm_179) else v_sm_179)
	var _t139 = ("Bryan 想分走你的獎勵（" + J.str(v_amtTxt_177) + "）。")
	var _t131 = ((("派" + J.str(J.gp(J.gp(v_sm_179, "g"), "name")) + "出示證據（智 " + J.str(J.gp(v_sm_179, "v")) + "，需 " + J.str(v_need_178) + "）") if J.t(v_okEv_182) else ("出示證據（" + J.str(J.gp(J.gp(v_sm_179, "g"), "name")) + "智 " + J.str(J.gp(v_sm_179, "v")) + "，不足 " + J.str(v_need_178) + "）")) if J.t(v_sm_179) else "出示證據（沒有幫手）")
	var _t132 = (not J.t(v_okEv_182))
	var _t130 = null
	if J.t(v_okEv_182):
		var _t128 = J.gp(J.gp(v_sm_179, "g"), "name")
		var _t124 = J.G.get("Lf")
		var _t127 = J.gp(v_p_174, "what")
		var _t125 = J.G.get("L")
		var _t126 = _s91["__p"]["rot"]
		var _t129 = [[_t128, J.cl(_t124, null, ["（攤開一疊紙）記錄喺度：{w}，由頭到尾都係少爺做嘅。嗰陣你喺{a}。", {"w": _t127, "a": J.cl(_t125, null, [J.cl(_t126, null, ["alibi", _s91["__p"]["ALIBI"]])])}])]]
		_t130 = J.mc(_t129, "concat", [_s91["__p"]["BRYAN_LOSE"], [[J.gp(J.gp(v_sm_179, "g"), "name"), "重播都喺度。你個波，三次都出界。"]]])
	else:
		_t130 = []
	v_choice_183 = {"plain": true, "q": _t139, "a": {"label": _t131, "disabled": _t132, "lines": _t130, "on": Callable(self, "_f61").bind(_s91)}, "b": {"label": "跟他爭（不給，但他會記仇）", "lines": [["阿福", "Bryan，嗰陣你喺邊？"], ["Bryan", "我……我喺精神上支持你！"], ["阿福", "精神上支持，冇獎金。"], ["Bryan", "好，好。兄弟，你小心啲。"]], "on": Callable(self, "_f62").bind(_s91)}, "c": {"label": ("給他（" + J.str(v_amtTxt_177) + "；他會安靜一陣子）"), "lines": [["阿福", "攞去啦。"], ["Bryan", "爽快！我就話你係好隊友！下次我一定 pass 波俾你。"], ["旁白", "他從來沒有傳過球給任何人。"]], "on": Callable(self, "_f63").bind(_s91)}}
	var _t150 = _s91["__p"]["play"]
	J.cl(_t150, null, [{"tag": "死對頭", "title": "Bryan：搶功勞", "bg": "village", "cast": v_cast_180, "lines": v_lines_181, "choice": v_choice_183}, Callable(self, "_f64").bind(_s91)])

func _f66(this_, a: Array, env):
	var v_g_197 = null
	v_g_197 = J.arg(a, 0)
	var _t154 = J.gp(v_g_197, "post")
	var _t156 = ((not J.seq(J.gp(v_g_197, "k"), "afu")) if J.t(_t154) else _t154)
	if J.t(_t156):
		var _t155 = env["__p"]["art"]
		_t156 = J.cl(_t155, null, [J.gp(v_g_197, "k")])
	return _t156

func _f67(this_, a: Array, env):
	var _t165 = env["r"]
	var _t166 = {"gid": J.gp(env["g"], "id"), "name": J.gp(env["g"], "name"), "until": J.add(J.cl(env["__p"]["now"], null, []), (8.0 * 60000.0))}
	J.sp(_t165, "rumor", _t166)
	J.cl(env["__p"]["hud"], null, [])

func _f68(this_, a: Array, env):
	var _t167 = J.gp(J.G.get("S"), "res")
	var _t168 = J.sub(J.gp(_t167, "buns"), env["cost"])
	J.sp(_t167, "buns", _t168)
	var _t169 = env["r"]
	J.sp(_t169, "rumor", null)
	var _t170 = env["r"]
	J.sp(_t170, "arc", J.num(J.gp(_t170, "arc")) + 1.0)
	return [["旁白", "謠言澄清了。"]]

func _f69(this_, a: Array, env):
	var _t175 = J.gp(J.G.get("S"), "res")
	var _t176 = J.G.get("rwd")
	var _t177 = J.sub(J.gp(_t175, "coins"), J.cl(_t176, null, [8.0]))
	J.sp(_t175, "coins", _t177)
	var _t178 = env["r"]
	J.sp(_t178, "rumor", null)
	var _t179 = env["r"]
	J.sp(_t179, "arc", J.num(J.gp(_t179, "arc")) + 1.0)
	return [["旁白", "謠言澄清了。Bryan 收到人生第一封澄清通告。"]]

func _f70(this_, a: Array, env):
	J.cl(env["set"], null, [])
	var _t182 = env["r"]
	J.sp(_t182, "arc", J.num(J.gp(_t182, "arc")) + 1.0)
	return [["旁白", (J.str(J.gp(env["g"], "name")) + "工作速度減半，持續 8 分鐘。")]]

func _f71(this_, a: Array, env):
	var v_res_198 = null
	v_res_198 = J.arg(a, 0)
	if (not J.t(J.len(J.gp(v_res_198, "picks")))):
		J.cl(env["set"], null, [])
	J.cl(env["__p"]["done"], null, [])

func _f65(this_, a: Array, env):
	var v_a_188 = null; var v_cand_190 = null; var v_lines_193 = null; var v_choice_195 = null; var v_cast_196 = null
	var _s97 = {"__p": env, "r": null, "g": null, "cost": null, "set": null}
	v_a_188 = J.cl(_s97["__p"]["st"], null, [])
	_s97["r"] = J.gp(v_a_188, "rival")
	var _t153 = J.gp(J.G.get("S"), "ghosts")
	v_cand_190 = J.mc(_t153, "filter", [Callable(self, "_f66").bind(_s97)])
	if (not J.t(J.len(v_cand_190))):
		return false
	_s97["g"] = J.gp(v_cand_190, floor(J.num(J.mul(J.cl(_s97["__p"]["R"], null, []), J.len(v_cand_190)))))
	var _t157 = J.G.get("rwd")
	_s97["cost"] = J.cl(_t157, null, [15.0])
	var _t158 = J.cl(_s97["__p"]["rivalIntro"], null, [])
	var _t161 = ["旁白", ("Bryan 摟著" + J.str(J.gp(_s97["g"], "name")) + "的肩膀，壓低聲音說話。")]
	var _t159 = J.G.get("Lf")
	var _t160 = _s97["__p"]["rot"]
	var _t164 = ["Bryan", J.cl(_t159, null, [J.cl(_t160, null, ["rumor", _s97["__p"]["RUMORS"]]), {"n": J.gp(_s97["g"], "name")}])]
	var _t163 = J.gp(_s97["g"], "name")
	var _t162 = _s97["__p"]["rot"]
	v_lines_193 = J.mc(_t158, "concat", [[_t161, _t164, [_t163, J.cl(_t162, null, ["hurt", _s97["__p"]["HURT"]]), "look"], ["阿福", "Bryan，你同佢講咩？"], ["Bryan", "冇呀，打吓氣嘛。我哋要有 team spirit。"]]])
	_s97["set"] = Callable(self, "_f67").bind(_s97)
	var _t180 = (J.str(J.gp(_s97["g"], "name")) + "聽信謠言，工作速度減半。怎麼處理？")
	var _t181 = {"label": ("請全村吃宵夜澄清（壽包 " + J.str(_s97["cost"]) + "）"), "disabled": J.cmp(J.gp(J.gp(J.G.get("S"), "res"), "buns"), _s97["cost"], "<"), "lines": [["阿福", "今晚宵夜我請，順便講清楚：冇呢回事。"], [J.gp(_s97["g"], "name"), "……少爺，我信你。"], ["Bryan", "（揸住個波）宵夜有冇我份？"], ["阿福", "冇。"]], "on": Callable(self, "_f68").bind(_s97)}
	var _t171 = J.G.get("rwd")
	var _t174 = ("請冼小姐發澄清通告（行政費：冥幣 " + J.str(J.cl(_t171, null, [8.0])) + "）")
	var _t173 = J.gp(J.gp(J.G.get("S"), "res"), "coins")
	var _t172 = J.G.get("rwd")
	v_choice_195 = {"plain": true, "q": _t180, "a": _t181, "b": {"label": _t174, "disabled": J.cmp(_t173, J.cl(_t172, null, [8.0]), "<"), "lines": [["冼小姐", "澄清通告，一式三份：正本貼公告板，一份副本俾當事人，一份俾造謠者。"], ["Bryan", "點解有我份？"], ["冼小姐", "因為通告上面寫住你個名呀，親愛嘅同事～"]], "on": Callable(self, "_f69").bind(_s97)}, "c": {"label": "不理會（清者自清）", "lines": [["阿福", "清者自清。"]], "on": Callable(self, "_f70").bind(_s97)}}
	v_cast_196 = [["阿福", "afu"], [J.gp(_s97["g"], "name"), J.gp(_s97["g"], "k")], ["Bryan", J.gp(_s97["__p"]["ART"], "rival")]]
	var _t183 = _s97["__p"]["play"]
	J.cl(_t183, null, [{"tag": "死對頭", "title": "Bryan：搬弄是非", "bg": "village", "cast": v_cast_196, "lines": v_lines_193, "choice": v_choice_195}, Callable(self, "_f71").bind(_s97)])
	return true

func _f75(this_, a: Array, env):
	var v_out_216 = null
	if J.t(env["right"]):
		env["__p"]["__p"]["wins"] = J.num(env["__p"]["__p"]["wins"]) + 1.0
	v_out_216 = [["旁白", ("比數：阿福 " + J.str(env["__p"]["__p"]["wins"]) + "：" + J.str(J.sub(J.add(env["__p"]["i"], 1.0), env["__p"]["__p"]["wins"])) + " Bryan")]]
	if J.cmp(env["__p"]["i"], 2.0, "<"):
		J.mc(v_out_216, "push", [["Bryan", J.gp(J.gp(env["__p"]["__p"]["__p"]["ROUNDS"], J.add(env["__p"]["i"], 1.0)), "tell"), "wave"]])
	return v_out_216

func _f76(this_, a: Array, env):
	var _t185 = env["__p"]["__p"]["round"]
	return J.cl(_t185, null, [J.add(env["__p"]["i"], 1.0)])

func _f74(this_, a: Array, env):
	var _s106 = {"__p": env, "right": null}
	_s106["right"] = J.arg(a, 0)
	return {"label": (J.gp(_s106["__p"]["d"], "right") if J.t(_s106["right"]) else J.gp(_s106["__p"]["d"], "wrong")), "lines": (J.gp(_s106["__p"]["d"], "win") if J.t(_s106["right"]) else J.gp(_s106["__p"]["d"], "lose")), "on": Callable(self, "_f75").bind(_s106), "next": (Callable(self, "_f76").bind(_s106) if J.cmp(_s106["__p"]["i"], 2.0, "<") else null)}

func _f73(this_, a: Array, env):
	var v_ra_213 = null; var v_mk_214 = null
	var _s105 = {"__p": env, "i": null, "d": null}
	_s105["i"] = J.arg(a, 0)
	_s105["d"] = J.gp(_s105["__p"]["__p"]["ROUNDS"], _s105["i"])
	v_ra_213 = J.cmp(J.cl(_s105["__p"]["__p"]["R"], null, []), 0.5, "<")
	v_mk_214 = Callable(self, "_f74").bind(_s105)
	return {"plain": true, "q": J.gp(_s105["d"], "q"), "a": J.cl(v_mk_214, null, [v_ra_213]), "b": J.cl(v_mk_214, null, [(not J.t(v_ra_213))])}

func _f77(this_, a: Array, env):
	var v_back_217 = null; var v_t_218 = null
	if J.cmp(env["wins"], 2.0, ">="):
		var _t186 = env["r"]
		J.sp(_t186, "beaten", true)
		var _t188 = J.gp(env["r"], "stolen")
		var _t187 = J.G.get("rwd")
		var _t190 = J.gp(env["r"], "stolen")
		var _t189 = J.G.get("rwd")
		v_back_217 = J.min_([_t190, J.cl(_t189, null, [120.0])])
		var _t191 = J.G.get("give")
		var _t192 = J.G.get("rwd")
		v_t_218 = J.cl(_t191, null, [J.S_Object_("assign", [{"chest": "p", "coins": J.add(J.cl(_t192, null, [60.0]), v_back_217)}])])
		return [["龐總", "（揭開平板）順便講埋：我睇過數據。Bryan 呢三年嘅 KPI，九成係人哋做嘅。"], ["Bryan", "龐總，嗰啲係……助攻！"], ["龐總", "由今日起，你調去落魄村茶水間。職位：茶水間主任。KPI：沖茶。"], ["Bryan", "……沖茶點計 KPI？"], ["龐總", "你沖嘅每一杯，都要寫你自己個名。"], ["旁白", ("Bryan 被揭穿。之前被他拿走的冥幣全數追回。獎勵：" + J.str(v_t_218))]]
	return [["Bryan", "承讓承讓！兄弟，下次再嚟過，我隨時候教。"], ["龐總", "（喺平板寫低）Bryan：勝。阿福：仲有改善空間。"], ["旁白", "輸了沒有損失。過一陣子，Bryan 會再來挑戰。"]]

func _f79(this_, a: Array, env):
	var _t195 = env["__p"]["last"]
	return J.cl(_t195, null, [J.cl(env["nx"], null, [])])

func _f80(this_, a: Array, env):
	var v_p_224 = null
	v_p_224 = J.arg(a, 0)
	var _t197 = env["on"]
	var _t198 = J.cl(_t197, null, [v_p_224])
	return J.mc(_t198, "concat", [J.cl(env["__p"]["tail"], null, [])])

func _f78(this_, a: Array, env):
	var v_c_219 = null; var v_k_220 = null; var v_o_221 = null
	v_c_219 = J.arg(a, 0)
	for _t194 in J.iter(["a", "b"]):
		v_k_220 = _t194
		v_o_221 = J.gp(v_c_219, v_k_220)
		if J.t(J.gp(v_o_221, "next")):
			var _s114 = {"__p": env, "nx": null}
			_s114["nx"] = J.gp(v_o_221, "next")
			var _t196 = Callable(self, "_f79").bind(_s114)
			J.sp(v_o_221, "next", _t196)
		else:
			var _s116 = {"__p": env, "on": null}
			_s116["on"] = J.gp(v_o_221, "on")
			var _t199 = Callable(self, "_f80").bind(_s116)
			J.sp(v_o_221, "on", _t199)
	return v_c_219

func _f81(this_, a: Array, env):
	return J.cl(env["__p"]["done"], null, [])

func _f72(this_, a: Array, env):
	var v_a_201 = null; var v_cast_203 = null; var v_intro_204 = null; var v_lines_207 = null; var v_choice_209 = null
	var _s104 = {"__p": env, "r": null, "wins": null, "round": null, "tail": null, "last": null}
	v_a_201 = J.cl(_s104["__p"]["st"], null, [])
	_s104["r"] = J.gp(v_a_201, "rival")
	var _t184 = _s104["r"]
	J.sp(_t184, "duels", J.num(J.gp(_t184, "duels")) + 1.0)
	v_cast_203 = [["阿福", "afu"], ["Bryan", J.gp(_s104["__p"]["ART"], "rival")], ["龐總", J.gp(_s104["__p"]["ART"], "boss")]]
	v_intro_204 = [["Bryan", "兄弟，我哋咁樣拗落去都唔係辦法。一對一，三球。你贏，我認晒以前啲功勞係你嘅。"], ["阿福", "我輸呢？"], ["Bryan", "你輸，以後你啲功勞都係我嘅。"], ["阿福", "……同而家有咩分別？"], ["Bryan", "有。以後係正式嘅。"], ["龐總", "我做旁證。Data 唔會呃人。"]]
	_s104["wins"] = 0.0
	_s104["round"] = Callable(self, "_f73").bind(_s104)
	v_lines_207 = J.mc(v_intro_204, "concat", [[["Bryan", J.gp(J.gp(_s104["__p"]["ROUNDS"], 0.0), "tell"), "wave"]]])
	_s104["tail"] = Callable(self, "_f77").bind(_s104)
	var _t193 = _s104["round"]
	v_choice_209 = J.cl(_t193, null, [0.0])
	_s104["last"] = Callable(self, "_f78").bind(_s104)
	var _t200 = _s104["__p"]["play"]
	var _t201 = _s104["last"]
	J.cl(_t200, null, [{"tag": "死對頭", "title": "Bryan：一對一，三球", "bg": "office", "cast": v_cast_203, "lines": v_lines_207, "choice": J.cl(_t201, null, [v_choice_209])}, Callable(self, "_f81").bind(_s104)])

func _f93(this_, a: Array, env):
	var v_e_241 = null
	v_e_241 = J.arg(a, 0)
	var _t209 = (not J.t(J.gp(v_e_241, "team")))
	if not J.t(_t209):
		var _t203 = J.gp(J.gp(env["a"], "rival"), "met")
		var _t204 = ((not J.t(J.gp(J.gp(env["a"], "rival"), "beaten"))) if J.t(_t203) else _t203)
		var _t206 = (J.cmp(J.gp(J.gp(env["a"], "rival"), "arc"), 2.0, ">=") if J.t(_t204) else _t204)
		if J.t(_t206):
			var _t205 = env["__p"]["seen"]
			_t206 = J.cl(_t205, null, ["ch4_end"])
		var _t208 = _t206
		if J.t(_t208):
			var _t207 = env["__p"]["art"]
			_t208 = J.cl(_t207, null, [J.gp(env["__p"]["ART"], "rival")])
		_t209 = _t208
	return _t209

func _f94(this_, a: Array, env):
	var v_x_242 = null
	v_x_242 = J.arg(a, 0)
	return J.seq(J.gp(v_x_242, "id"), env["force"])

func _f95(this_, a: Array, env):
	var v_x_245 = null
	v_x_245 = J.arg(a, 0)
	return (not J.t(J.gp(J.gp(env["h"], "done"), J.gp(v_x_245, "id"))))

func _f97(this_, a: Array, env):
	var v_out_247 = null
	v_out_247 = []
	if J.t(J.gp(env["o"], "cost")):
		var _t223 = J.gp(J.G.get("S"), "res")
		var _t224 = J.G.get("rwd")
		var _t225 = J.sub(J.gp(_t223, "buns"), J.cl(_t224, null, [J.gp(J.gp(env["o"], "cost"), "buns")]))
		J.sp(_t223, "buns", _t225)
	if J.t(J.gp(env["o"], "give")):
		var _t226 = J.G.get("give")
		J.mc(v_out_247, "push", [["旁白", ("出了一口氣：" + J.str(J.cl(_t226, null, [J.mc(env["o"], "give", [])])))]])
	if J.t(J.gp(env["o"], "warn")):
		var _t227 = env["__p"]["__p"]["warn"]
		var _t228 = J.cl(_t227, null, [v_out_247])
		v_out_247 = _t228
	if J.t(J.gp(env["o"], "slow")):
		var _t229 = J.gp(env["__p"]["a"], "boss")
		var _t230 = J.max_([J.gp(J.gp(env["__p"]["a"], "boss"), "slowUntil"), J.add(J.cl(env["__p"]["__p"]["now"], null, []), (4.0 * 60000.0))])
		J.sp(_t229, "slowUntil", _t230)
		J.mc(v_out_247, "push", [["旁白", "懲罰：全村陪你處理文件，工作速度 −15%（4 分鐘）"]])
	if J.t(J.gp(env["o"], "arc")):
		var _t231 = J.gp(env["__p"]["a"], "rival")
		J.sp(_t231, "arc", J.num(J.gp(_t231, "arc")) + 1.0)
	return v_out_247

func _f96(this_, a: Array, env):
	var _s135 = {"__p": env, "o": null}
	_s135["o"] = J.arg(a, 0)
	var _t232 = _s135["o"]
	if J.t(_t232):
		var _t218 = J.gp(_s135["o"], "label")
		var _t217 = null
		if J.t(J.gp(_s135["o"], "cost")):
			var _t216 = J.G.get("rwd")
			_t217 = ("（壽包 " + J.str(J.cl(_t216, null, [J.gp(J.gp(_s135["o"], "cost"), "buns")])) + "）")
		else:
			_t217 = ""
		var _t222 = J.add(_t218, _t217)
		var _t221 = null
		if J.t(J.gp(_s135["o"], "cost")):
			var _t220 = J.gp(J.gp(J.G.get("S"), "res"), "buns")
			var _t219 = J.G.get("rwd")
			_t221 = J.cmp(_t220, J.cl(_t219, null, [J.gp(J.gp(_s135["o"], "cost"), "buns")]), "<")
		else:
			_t221 = false
		_t232 = {"label": _t222, "disabled": _t221, "lines": J.gp(_s135["o"], "lines"), "on": Callable(self, "_f97").bind(_s135)}
	return _t232

func _f98(this_, a: Array, env):
	return J.cl(env["__p"]["done"], null, [])

func _f92(this_, a: Array, env):
	var v_pool_233 = null; var v_e_234 = null; var v_intro_235 = null; var v_cast_236 = null; var v_mk_237 = null; var v_sA_238 = null; var v_opts_239 = null; var v_choice_240 = null; var v_fresh_243 = null; var v_p2_244 = null
	var _s130 = {"__p": env, "force": null, "a": null, "h": null}
	_s130["force"] = J.arg(a, 0)
	_s130["a"] = J.cl(_s130["__p"]["st"], null, [])
	_s130["h"] = J.gp(_s130["a"], "hr")
	var _t202 = _s130["h"]
	J.sp(_t202, "visits", J.num(J.gp(_t202, "visits")) + 1.0)
	v_pool_233 = J.mc(_s130["__p"]["HR_EV"], "filter", [Callable(self, "_f93").bind(_s130)])
	v_e_234 = (J.mc(_s130["__p"]["HR_EV"], "find", [Callable(self, "_f94").bind(_s130)]) if J.t(_s130["force"]) else null)
	if (not J.t(v_e_234)):
		v_fresh_243 = J.mc(v_pool_233, "filter", [Callable(self, "_f95").bind(_s130)])
		if (not J.t(J.len(v_fresh_243))):
			var _t210 = _s130["h"]
			var _t211 = {}
			J.sp(_t210, "done", _t211)
		v_p2_244 = (v_fresh_243 if J.t(J.len(v_fresh_243)) else v_pool_233)
		var _t212 = J.gp(v_p2_244, floor(J.num(J.mul(J.cl(_s130["__p"]["R"], null, []), J.len(v_p2_244)))))
		v_e_234 = _t212
	var _t213 = J.gp(_s130["h"], "done")
	var _t214 = J.gp(v_e_234, "id")
	J.sp(_t213, _t214, 1.0)
	v_intro_235 = ([] if J.t(J.gp(_s130["h"], "met")) else _s130["__p"]["HR_INTRO"])
	var _t215 = _s130["h"]
	J.sp(_t215, "met", true)
	v_cast_236 = [["阿福", "afu"], ["冼小姐", J.gp(_s130["__p"]["ART"], "hr")]]
	if J.t(J.gp(v_e_234, "team")):
		J.mc(v_cast_236, "push", [["Bryan", J.gp(_s130["__p"]["ART"], "rival")]])
	v_mk_237 = Callable(self, "_f96").bind(_s130)
	v_sA_238 = J.cmp(J.cl(_s130["__p"]["R"], null, []), 0.5, "<")
	v_opts_239 = [J.cl(v_mk_237, null, [J.gp(v_e_234, "smart")]), J.cl(v_mk_237, null, [J.gp(v_e_234, "dumb")])]
	if (not J.t(v_sA_238)):
		J.mc(v_opts_239, "reverse", [])
	v_choice_240 = {"plain": true, "q": J.gp(v_e_234, "q"), "a": J.gp(v_opts_239, 0.0), "b": J.gp(v_opts_239, 1.0)}
	if J.t(J.gp(v_e_234, "third")):
		var _t233 = J.cl(v_mk_237, null, [J.gp(v_e_234, "third")])
		J.sp(v_choice_240, "c", _t233)
	var _t234 = _s130["__p"]["play"]
	J.cl(_t234, null, [{"tag": "HR", "title": J.gp(v_e_234, "title"), "bg": "village", "cast": v_cast_236, "lines": J.mc(v_intro_235, "concat", [J.gp(v_e_234, "lines")]), "choice": v_choice_240}, Callable(self, "_f98").bind(_s130)])

func _f100(this_, a: Array, env):
	return J.cl(env["hrEvent"], null, [])

func _f99(this_, a: Array, env):
	var v_a_250 = null; var v_b_251 = null; var v_r_252 = null; var v_opts_253 = null; var v_tot_254 = null; var v_x_255 = null; var v_f_256 = null; var v_p_257 = null; var v_o_258 = null; var v_o_259 = null
	v_a_250 = J.cl(env["st"], null, [])
	var _t236 = (not J.t(v_a_250))
	if not J.t(_t236):
		var _t235 = env["seen"]
		_t236 = (not J.t(J.cl(_t235, null, ["ch1_end"])))
	if _t236:
		return false
	J.sp(v_a_250, "clock", J.num(J.gp(v_a_250, "clock")) + 1.0)
	J.sp(v_a_250, "gap", J.num(J.gp(v_a_250, "gap")) + 1.0)
	v_b_251 = J.gp(v_a_250, "boss")
	v_r_252 = J.gp(v_a_250, "rival")
	var _t237 = J.gp(v_b_251, "task")
	var _t239 = (J.cmp(J.gp(v_a_250, "gap"), env["REVIEW_GAP"], ">=") if J.t(_t237) else _t237)
	if J.t(_t239):
		var _t238 = env["art"]
		_t239 = J.cl(_t238, null, [J.gp(env["ART"], "boss")])
	if J.t(_t239):
		v_p_257 = J.cl(env["taskProg"], null, [])
		var _t240 = J.cmp(J.gp(v_p_257, "v"), J.gp(v_p_257, "n"), ">=")
		if (_t240 if _t240 else J.cmp(J.gp(v_p_257, "left"), 0.0, "<=")):
			J.sp(v_a_250, "gap", 0.0)
			J.cl(env["bossReview"], null, [])
			return true
	var _t241 = J.gp(v_r_252, "pend")
	var _t242 = ((not J.t(J.gp(v_r_252, "beaten"))) if J.t(_t241) else _t241)
	var _t244 = (J.cmp(J.gp(v_a_250, "gap"), 25.0, ">=") if J.t(_t242) else _t242)
	if J.t(_t244):
		var _t243 = env["art"]
		_t244 = J.cl(_t243, null, [J.gp(env["ART"], "rival")])
	if J.t(_t244):
		J.sp(v_a_250, "gap", 0.0)
		J.cl(env["rivalTheft"], null, [])
		return true
	var _t245 = J.cmp(J.gp(v_a_250, "gap"), env["GAP"], "<")
	if (_t245 if _t245 else J.cmp(J.cl(env["R"], null, []), J.div(1.0, 90.0), ">")):
		return false
	v_opts_253 = []
	var _t247 = (not J.t(J.gp(v_b_251, "task")))
	if J.t(_t247):
		var _t246 = env["art"]
		_t247 = J.cl(_t246, null, [J.gp(env["ART"], "boss")])
	if J.t(_t247):
		J.mc(v_opts_253, "push", [[3.0, env["bossVisit"]]])
	var _t248 = (not J.t(J.gp(v_b_251, "group")))
	var _t250 = (J.cmp(J.gp(v_b_251, "visits"), 2.0, ">=") if _t248 else _t248)
	if J.t(_t250):
		var _t249 = env["seen"]
		_t250 = J.cl(_t249, null, ["gift_phone"])
	if J.t(_t250):
		J.mc(v_opts_253, "push", [[3.0, env["bossGroup"]]])
	var _t251 = (not J.t(J.gp(v_r_252, "beaten")))
	var _t253 = (J.gp(v_r_252, "met") if _t251 else _t251)
	if J.t(_t253):
		var _t252 = env["seen"]
		_t253 = J.cl(_t252, null, ["ch2_end"])
	var _t255 = _t253
	if J.t(_t255):
		var _t254 = J.gp(v_r_252, "rumor")
		_t255 = (not J.t((J.cmp(J.gp(J.gp(v_r_252, "rumor"), "until"), J.cl(env["now"], null, []), ">") if J.t(_t254) else _t254)))
	var _t257 = (J.cmp(J.gp(v_a_250, "clock"), J.gp(v_r_252, "peaceUntil"), ">") if J.t(_t255) else _t255)
	if J.t(_t257):
		var _t256 = env["art"]
		_t257 = J.cl(_t256, null, [J.gp(env["ART"], "rival")])
	if J.t(_t257):
		J.mc(v_opts_253, "push", [[J.add(1.5, J.gp(v_r_252, "grudge")), env["rivalGossip"]]])
	var _t258 = (not J.t(J.gp(v_r_252, "beaten")))
	var _t260 = (J.cmp(J.gp(v_r_252, "arc"), 3.0, ">=") if _t258 else _t258)
	if J.t(_t260):
		var _t259 = env["seen"]
		_t260 = J.cl(_t259, null, ["ch5_end"])
	var _t262 = _t260
	if J.t(_t262):
		var _t261 = env["art"]
		_t262 = J.cl(_t261, null, [J.gp(env["ART"], "rival")])
	if J.t(_t262):
		J.mc(v_opts_253, "push", [[4.0, env["rivalShowdown"]]])
	var _t263 = env["seen"]
	var _t265 = J.cl(_t263, null, ["ch2_end"])
	if J.t(_t265):
		var _t264 = env["art"]
		_t265 = J.cl(_t264, null, [J.gp(env["ART"], "hr")])
	if J.t(_t265):
		J.mc(v_opts_253, "push", [[2.5, Callable(self, "_f100").bind(env)]])
	if (not J.t(J.len(v_opts_253))):
		return false
	v_tot_254 = 0.0
	for _t266 in J.iter(v_opts_253):
		v_o_258 = _t266
		var _t267 = J.add(v_tot_254, J.gp(v_o_258, 0.0))
		v_tot_254 = _t267
	v_x_255 = J.mul(J.cl(env["R"], null, []), v_tot_254)
	v_f_256 = J.gp(J.gp(v_opts_253, (J.len(v_opts_253) - 1.0)), 1.0)
	for _t268 in J.iter(v_opts_253):
		v_o_259 = _t268
		var _t269 = J.sub(v_x_255, J.gp(v_o_259, 0.0))
		v_x_255 = _t269
		if (v_x_255 <= 0.0):
			v_f_256 = J.gp(v_o_259, 1.0)
			break
	J.sp(v_a_250, "gap", 0.0)
	if J.seq(J.cl(v_f_256, null, []), false):
		return false
	return true

func _f101(this_, a: Array, env):
	var v_what_262 = null; var v_a_263 = null; var v_r_264 = null
	v_what_262 = J.arg(a, 0)
	v_a_263 = J.cl(env["st"], null, [])
	var _t271 = (not J.t(v_a_263))
	if not J.t(_t271):
		var _t270 = env["seen"]
		_t271 = (not J.t(J.cl(_t270, null, ["ch1_end"])))
	if _t271:
		return null
	v_r_264 = J.gp(v_a_263, "rival")
	var _t272 = J.gp(v_r_264, "beaten")
	var _t273 = (_t272 if J.t(_t272) else J.gp(v_r_264, "pend"))
	if J.t((_t273 if J.t(_t273) else J.cmp(J.gp(v_a_263, "clock"), J.gp(v_r_264, "peaceUntil"), "<"))):
		return null
	if J.cmp(J.cl(env["R"], null, []), (0.3 if J.t(J.gp(v_r_264, "met")) else 0.6), "<"):
		var _t274 = {"what": v_what_262}
		J.sp(v_r_264, "pend", _t274)

func _f103(this_, a: Array, env):
	var v_q_271 = null; var v_r_272 = null; var v_e_273 = null
	var _t277 = J.gp(J.G.get("Quest"), "cur")
	v_q_271 = (J.mc(J.G.get("Quest"), "cur", []) if J.t(_t277) else _t277)
	v_r_272 = J.mc(env["oc"], "apply", [this_, a])
	if J.t(v_q_271):
		var _t278 = env["__p"]["__p"]["credit"]
		J.cl(_t278, null, [J.gp(v_q_271, "text")])
	return v_r_272

func _f104(this_, a: Array, env):
	var v_n_274 = null
	var _t280 = J.seq(J.typeof_(J.G.get("S")), "undefined")
	var _t281 = (_t280 if _t280 else (not J.t(J.G.get("S"))))
	if (_t281 if _t281 else (not J.t(J.gp(J.G.get("S"), "cleared")))):
		return null
	v_n_274 = J.len(J.S_Object_("keys", [J.gp(J.G.get("S"), "cleared")]))
	var _t282 = J.cmp(env["lastCleared"], 0.0, ">=")
	var _t283 = (J.cmp(v_n_274, env["lastCleared"], ">") if _t282 else _t282)
	if ((not J.t(J.gp(J.G.get("Battle"), "active"))) if _t283 else _t283):
		var _t284 = env["__p"]["credit"]
		J.cl(_t284, null, ["打通新關卡"])
	if (not J.t(J.gp(J.G.get("Battle"), "active"))):
		env["lastCleared"] = v_n_274
	J.cl(env["__p"]["hud"], null, [])

func _f102(this_, a: Array, env):
	var _s149 = {"__p": env, "lastCleared": null}
	var _t275 = (not J.seq(J.typeof_(J.G.get("Quest")), "undefined"))
	if J.t((J.gp(J.G.get("Quest"), "complete") if _t275 else _t275)):
		var _s150 = {"__p": _s149, "oc": null}
		_s150["oc"] = J.gp(J.G.get("Quest"), "complete")
		var _t276 = J.G.get("Quest")
		var _t279 = Callable(self, "_f103").bind(_s150)
		J.sp(_t276, "complete", _t279)
	_s149["lastCleared"] = (-1.0)
	J.F_setInterval([Callable(self, "_f104").bind(_s149), 1000.0])

func _f106(this_, a: Array, env):
	var _t297 = env["toast"]
	return J.cl(_t297, null, ["龐總 KPI：時限內達標有獎勵，未達標有輕微懲罰。時限只計算你在村子裡遊玩的時間。<br>謠言：8 分鐘後自行消散。"])

func _f105(this_, a: Array, env):
	var v_wrap_277 = null; var v_el_278 = null; var v_a_279 = null; var v_rows_280 = null; var v_h_281 = null; var v_p_282 = null
	v_wrap_277 = J.S_document_("getElementById", ["stagewrap"])
	var _t285 = (not J.t(v_wrap_277))
	var _t286 = (_t285 if _t285 else J.seq(J.typeof_(J.G.get("S")), "undefined"))
	if (_t286 if _t286 else (not J.t(J.G.get("S")))):
		return null
	v_el_278 = J.S_document_("getElementById", ["antag-chip"])
	v_a_279 = J.gp(J.G.get("S"), "antag")
	v_rows_280 = []
	if J.t((J.gp(J.gp(v_a_279, "boss"), "task") if J.t(v_a_279) else v_a_279)):
		v_p_282 = J.cl(env["taskProg"], null, [])
		var _t288 = J.gp(J.gp(J.gp(v_a_279, "boss"), "task"), "what")
		var _t289 = J.min_([J.gp(v_p_282, "v"), J.gp(v_p_282, "n")])
		var _t290 = J.gp(v_p_282, "n")
		var _t291 = floor(J.num(J.div(J.gp(v_p_282, "left"), 60.0)))
		var _t287 = J.F_String([J.mod(J.gp(v_p_282, "left"), 60.0)])
		J.mc(v_rows_280, "push", [("<b>龐總 KPI</b> " + J.str(_t288) + " " + J.str(_t289) + "/" + J.str(_t290) + "　⏱" + J.str(_t291) + ":" + J.str(J.mc(_t287, "padStart", [2.0, "0"])))])
	var _t292 = (J.gp(J.gp(v_a_279, "rival"), "rumor") if J.t(v_a_279) else v_a_279)
	if J.t((J.cmp(J.gp(J.gp(J.gp(v_a_279, "rival"), "rumor"), "until"), J.cl(env["now"], null, []), ">") if J.t(_t292) else _t292)):
		var _t294 = J.gp(J.gp(J.gp(v_a_279, "rival"), "rumor"), "name")
		var _t293 = env["mins"]
		J.mc(v_rows_280, "push", [("<b>謠言</b> " + J.str(_t294) + "工作速度減半　" + J.str(J.cl(_t293, null, [J.sub(J.gp(J.gp(J.gp(v_a_279, "rival"), "rumor"), "until"), J.cl(env["now"], null, []))])) + " 分鐘")])
	if J.t((J.cmp(J.gp(J.gp(v_a_279, "boss"), "slowUntil"), J.cl(env["now"], null, []), ">") if J.t(v_a_279) else v_a_279)):
		var _t295 = env["mins"]
		J.mc(v_rows_280, "push", [("<b>懲罰</b> 全村工作速度 −15%　" + J.str(J.cl(_t295, null, [J.sub(J.gp(J.gp(v_a_279, "boss"), "slowUntil"), J.cl(env["now"], null, []))])) + " 分鐘")])
	if (not J.t(J.len(v_rows_280))):
		if J.t(v_el_278):
			J.mc(v_el_278, "remove", [])
		return null
	if (not J.t(v_el_278)):
		var _t296 = J.S_document_("createElement", ["div"])
		v_el_278 = _t296
		J.sp(v_el_278, "id", "antag-chip")
		J.mc(v_wrap_277, "appendChild", [v_el_278])
		var _t298 = Callable(self, "_f106").bind(env)
		J.sp(v_el_278, "onclick", _t298)
	v_h_281 = J.mc(v_rows_280, "join", ["<br>"])
	if (not J.seq(J.gp(v_el_278, "innerHTML"), v_h_281)):
		J.sp(v_el_278, "innerHTML", v_h_281)

func _f109(this_, a: Array, env):
	return 0.9

func _f110(this_, a: Array, env):
	var _t307 = J.num(env["i"])
	env["i"] = _t307 + 1.0
	return (0.1 if J.seq(_t307, 0.0) else 0.5)

func _f108(this_, a: Array, env):
	var v_kind_289 = null; var v_a_290 = null; var v_o_291 = null; var v_o_292 = null; var v_T_294 = null
	v_kind_289 = J.arg(a, 0)
	v_a_290 = J.cl(env["st"], null, [])
	if J.seq(v_kind_289, "boss"):
		var _t299 = J.gp(v_a_290, "boss")
		J.sp(_t299, "task", null)
		var _t300 = J.gp(v_a_290, "n")
		J.sp(_t300, "absurd", 0.0)
		v_o_291 = J.gp(J.G.get("Math"), "random")
		var _t301 = J.G.get("Math")
		var _t302 = Callable(self, "_f109").bind(env)
		J.sp(_t301, "random", _t302)
		J.cl(env["bossVisit"], null, [])
		var _t303 = J.G.get("Math")
		J.sp(_t303, "random", v_o_291)
	else:
		if J.seq(v_kind_289, "absurd"):
			var _s167 = {"__p": env, "i": null}
			var _t304 = J.gp(v_a_290, "boss")
			var _t305 = J.max_([1.0, J.gp(J.gp(v_a_290, "boss"), "visits")])
			J.sp(_t304, "visits", _t305)
			v_o_292 = J.gp(J.G.get("Math"), "random")
			_s167["i"] = 0.0
			var _t306 = J.G.get("Math")
			var _t308 = Callable(self, "_f110").bind(_s167)
			J.sp(_t306, "random", _t308)
			J.cl(_s167["__p"]["bossVisit"], null, [])
			var _t309 = J.G.get("Math")
			J.sp(_t309, "random", v_o_292)
		else:
			if J.seq(v_kind_289, "group"):
				J.cl(env["bossGroup"], null, [])
			else:
				if J.seq(v_kind_289, "review"):
					if (not J.t(J.gp(J.gp(v_a_290, "boss"), "task"))):
						v_T_294 = J.gp(env["TASKS"], "chop")
						var _t310 = J.gp(v_a_290, "boss")
						var _t311 = {"k": "chop", "n": 3.0, "base": J.sub(J.mc(v_T_294, "val", []), 1.0), "due": J.gp(v_a_290, "clock"), "set": J.gp(v_a_290, "clock"), "what": J.gp(v_T_294, "what"), "unit": J.gp(v_T_294, "unit")}
						J.sp(_t310, "task", _t311)
					J.cl(env["bossReview"], null, [])
				else:
					if J.seq(v_kind_289, "theft"):
						var _t312 = J.gp(v_a_290, "rival")
						var _t313 = {"what": "砍倒 3 棵槐樹"}
						J.sp(_t312, "pend", _t313)
						J.cl(env["rivalTheft"], null, [])
					else:
						if J.seq(v_kind_289, "gossip"):
							var _t314 = J.gp(v_a_290, "rival")
							J.sp(_t314, "met", true)
							if (not J.t(J.cl(env["rivalGossip"], null, []))):
								var _t315 = env["toast"]
								J.cl(_t315, null, ["要先派一隻鬼到崗位工作，Bryan 才有造謠對象。"])
						else:
							if J.seq(v_kind_289, "showdown"):
								var _t316 = J.gp(v_a_290, "rival")
								J.sp(_t316, "met", true)
								J.cl(env["rivalShowdown"], null, [])
							else:
								if J.t((J.seq(J.mc(v_kind_289, "indexOf", ["hr:"]), 0.0) if J.t(v_kind_289) else v_kind_289)):
									var _t317 = env["hrEvent"]
									J.cl(_t317, null, [J.mc(v_kind_289, "slice", [3.0])])

func _f2(this_, a: Array, env):
	var v_k_49 = null
	v_k_49 = J.arg(a, 0)
	var _t319 = (not J.seq(J.typeof_(J.G.get("sprOk")), "function"))
	if not J.t(_t319):
		var _t318 = J.G.get("sprOk")
		_t319 = J.cl(_t318, null, [v_k_49])
	return _t319

func _f3(this_, a: Array, env):
	var v_id_50 = null
	v_id_50 = J.arg(a, 0)
	var _t320 = (J.gp(J.G.get("S"), "seen") if J.t(J.G.get("S")) else J.G.get("S"))
	return (not (not J.t((J.gp(J.gp(J.G.get("S"), "seen"), v_id_50) if J.t(_t320) else _t320))))

func _f6(this_, a: Array, env):
	return J.S_Date_("now", [])

func _f7(this_, a: Array, env):
	var v_ms_60 = null
	v_ms_60 = J.arg(a, 0)
	return J.max_([1.0, J.round(J.num(J.div(v_ms_60, 60000.0)))])

func _f18(this_, a: Array, env):
	var v_x_96 = null
	v_x_96 = J.arg(a, 0)
	return J.seq(J.gp(v_x_96, "id"), J.gp(env["ru"], "gid"))

func _f17(this_, a: Array, env):
	var v_r_92 = null; var v_a_93 = null; var v_g_95 = null; var v_p_97 = null; var v_wo_98 = null; var v_k_99 = null; var v_k_100 = null
	var _s29 = {"__p": env, "ru": null}
	v_r_92 = J.mc(_s29["__p"]["orig"], "apply", [this_, a])
	var _t321 = (not J.seq(J.typeof_(J.G.get("S")), "undefined"))
	var _t322 = (J.G.get("S") if _t321 else _t321)
	v_a_93 = (J.gp(J.G.get("S"), "antag") if J.t(_t322) else _t322)
	if (not J.t(v_a_93)):
		return v_r_92
	var _t323 = J.gp(v_a_93, "rival")
	_s29["ru"] = (J.gp(J.gp(v_a_93, "rival"), "rumor") if J.t(_t323) else _t323)
	if J.t((J.cmp(J.gp(_s29["ru"], "until"), J.cl(_s29["__p"]["__p"]["now"], null, []), ">") if J.t(_s29["ru"]) else _s29["ru"])):
		var _t324 = J.gp(J.G.get("S"), "ghosts")
		v_g_95 = J.mc(_t324, "find", [Callable(self, "_f18").bind(_s29)])
		if J.t((J.gp(v_g_95, "post") if J.t(v_g_95) else v_g_95)):
			v_p_97 = J.gp(v_g_95, "post")
			J.sp(v_g_95, "post", null)
			v_wo_98 = J.mc(_s29["__p"]["orig"], "apply", [this_, a])
			J.sp(v_g_95, "post", v_p_97)
			for _t325 in J.keys(v_r_92):
				v_k_99 = _t325
				var _t326 = J.add(J.gp(v_wo_98, v_k_99), (0.5 * J.sub(J.gp(v_r_92, v_k_99), J.gp(v_wo_98, v_k_99))))
				J.sp(v_r_92, v_k_99, _t326)
	var _t327 = J.gp(v_a_93, "boss")
	if J.t((J.cmp(J.gp(J.gp(v_a_93, "boss"), "slowUntil"), J.cl(_s29["__p"]["__p"]["now"], null, []), ">") if J.t(_t327) else _t327)):
		for _t328 in J.keys(v_r_92):
			v_k_100 = _t328
			var _t329 = J.mul(J.gp(v_r_92, v_k_100), 0.85)
			J.sp(v_r_92, v_k_100, _t329)
	return v_r_92

func _f20(this_, a: Array, env):
	return true

func _f21(this_, a: Array, env):
	return (3.0 + floor(J.num(J.mul(J.cl(env["R"], null, []), 3.0))))

func _f22(this_, a: Array, env):
	return J.gp(J.gp(J.G.get("S"), "cnt"), "chop")

func _f23(this_, a: Array, env):
	var v_n_109 = null; var v_m_110 = null
	v_n_109 = J.arg(a, 0)
	v_m_110 = J.arg(a, 1)
	var _t330 = J.G.get("Lf")
	return [["龐總", J.cl(_t330, null, ["今次 KPI：{m} 分鐘之內，你親手斬 {n} 棵槐樹。唔准叫人幫，我要睇到你把斧頭有熱情。", {"n": v_n_109, "m": v_m_110}])], ["阿福", "斧頭點會有熱情？"], ["龐總", "所以先要你補返。"]]

func _f24(this_, a: Array, env):
	return true

func _f25(this_, a: Array, env):
	return (3.0 + floor(J.num(J.mul(J.cl(env["R"], null, []), 3.0))))

func _f26(this_, a: Array, env):
	return J.gp(J.gp(J.G.get("S"), "cnt"), "rice")

func _f27(this_, a: Array, env):
	var v_n_111 = null; var v_m_112 = null
	v_n_111 = J.arg(a, 0)
	v_m_112 = J.arg(a, 1)
	var _t331 = J.G.get("Lf")
	return [["龐總", J.cl(_t331, null, ["{m} 分鐘之內，割 {n} 次糯米。糯米係本季戰略物資：殭屍好驚，投資者好鍾意。", {"n": v_n_111, "m": v_m_112}])], ["阿福", "投資者係邊個？"], ["龐總", "你唔使知。你淨係要知，佢哋唔開心。"]]

func _f28(this_, a: Array, env):
	return J.cmp(J.gp(J.gp(J.G.get("S"), "bld"), "bun"), 0.0, ">")

func _f29(this_, a: Array, env):
	return (3.0 + floor(J.num(J.mul(J.cl(env["R"], null, []), 3.0))))

func _f30(this_, a: Array, env):
	return J.gp(J.gp(J.G.get("S"), "cnt"), "craftBun")

func _f31(this_, a: Array, env):
	var v_n_113 = null; var v_m_114 = null
	v_n_113 = J.arg(a, 0)
	v_m_114 = J.arg(a, 1)
	var _t332 = J.G.get("Lf")
	return [["龐總", J.cl(_t332, null, ["{m} 分鐘之內，你親手包 {n} 次壽包。", {"n": v_n_113, "m": v_m_114}])], ["阿福", "包子鋪有鬼包㗎。"], ["龐總", "佢哋包嘅係佢哋嘅 KPI。你包嘅，先係你嘅。"]]

func _f32(this_, a: Array, env):
	return J.cmp(J.gp(J.gp(J.G.get("S"), "bld"), "plank"), 0.0, ">")

func _f33(this_, a: Array, env):
	return (3.0 + floor(J.num(J.mul(J.cl(env["R"], null, []), 3.0))))

func _f34(this_, a: Array, env):
	return J.gp(J.gp(J.G.get("S"), "cnt"), "craftPlank")

func _f35(this_, a: Array, env):
	var v_n_115 = null; var v_m_116 = null
	v_n_115 = J.arg(a, 0)
	v_m_116 = J.arg(a, 1)
	var _t333 = J.G.get("Lf")
	return [["龐總", J.cl(_t333, null, ["{m} 分鐘之內，你親手做 {n} 次棺材板。", {"n": v_n_115, "m": v_m_116}])], ["阿福", "點解要我親手做？"], ["龐總", "棺材係我哋嘅核心產品。客戶一世人只用一次，所以唔准有第二次機會。"]]

func _f36(this_, a: Array, env):
	return J.cmp(J.gp(J.gp(J.G.get("S"), "bld"), "bun"), 0.0, ">")

func _f37(this_, a: Array, env):
	return J.min_([floor(J.num(J.mul(J.mc(J.G.get("F"), "cap", []), 0.9))), (floor(J.num(J.gp(J.gp(J.G.get("S"), "res"), "buns"))) + J.max_([12.0, J.round(J.num(J.mul(J.gp(J.cl(J.G.get("ratesPerMin"), null, []), "buns"), 4.0)))]))])

func _f38(this_, a: Array, env):
	return floor(J.num(J.gp(J.gp(J.G.get("S"), "res"), "buns")))

func _f39(this_, a: Array, env):
	var v_n_117 = null; var v_m_118 = null
	v_n_117 = J.arg(a, 0)
	v_m_118 = J.arg(a, 1)
	var _t334 = J.G.get("Lf")
	return [["龐總", J.cl(_t334, null, ["我下次嚟嘅時候，倉入面要有 {n} 個壽包。少一個，我都會知。", {"n": v_n_117}])], ["阿福", "你點會知？"], ["龐總", "（拍一拍部平板）佢話我知。"]]

func _f40(this_, a: Array, env):
	return 1.0

func _f41(this_, a: Array, env):
	return J.len(J.S_Object_("keys", [J.gp(J.G.get("S"), "cleared")]))

func _f42(this_, a: Array, env):
	var v_n_119 = null; var v_m_120 = null
	v_n_119 = J.arg(a, 0)
	v_m_120 = J.arg(a, 1)
	return [["龐總", "下次我嚟之前，你要打通一關新關卡。市場佔有率，係打返嚟嘅。"], ["阿福", "係真係打仗嚟㗎喎。"], ["龐總", "所以先叫市場。"]]

func _f82(this_, a: Array, env):
	var v_lines_225 = null; var v_h_226 = null; var v_c_227 = null
	v_lines_225 = J.arg(a, 0)
	v_h_226 = J.gp(J.cl(env["st"], null, []), "hr")
	J.sp(v_h_226, "warn", J.num(J.gp(v_h_226, "warn")) + 1.0)
	if J.cmp(J.gp(v_h_226, "warn"), 3.0, ">="):
		J.sp(v_h_226, "warn", 0.0)
		var _t336 = floor(J.num(J.gp(J.gp(J.G.get("S"), "res"), "coins")))
		var _t335 = J.G.get("rwd")
		var _t338 = floor(J.num(J.gp(J.gp(J.G.get("S"), "res"), "coins")))
		var _t337 = J.G.get("rwd")
		v_c_227 = J.min_([_t338, J.cl(_t337, null, [12.0])])
		var _t339 = J.gp(J.G.get("S"), "res")
		var _t340 = J.sub(J.gp(_t339, "coins"), v_c_227)
		J.sp(_t339, "coins", _t340)
		return J.mc(v_lines_225, "concat", [[["冼小姐", "恭喜你～集齊三封警告信，可以換一個大過！"], ["旁白", ("記大過：冥幣 −" + J.str(v_c_227) + "。警告信歸零。")]]])
	return J.mc(v_lines_225, "concat", [[["旁白", ("警告信 +1（集滿三封記大過）。目前：" + J.str(J.gp(v_h_226, "warn")) + " 封。")]]])

func _f83(this_, a: Array, env):
	var _t341 = J.G.get("rwd")
	return {"coins": J.cl(_t341, null, [15.0])}

func _f84(this_, a: Array, env):
	var _t342 = J.G.get("rwd")
	return {"exp": J.cl(_t342, null, [8.0])}

func _f85(this_, a: Array, env):
	var _t343 = J.G.get("rwd")
	return {"exp": J.cl(_t343, null, [8.0])}

func _f86(this_, a: Array, env):
	var _t344 = J.G.get("rwd")
	return {"exp": J.cl(_t344, null, [10.0])}

func _f87(this_, a: Array, env):
	var _t345 = J.G.get("rwd")
	return {"buns": J.cl(_t345, null, [15.0])}

func _f88(this_, a: Array, env):
	var _t346 = J.G.get("rwd")
	return {"coins": J.cl(_t346, null, [12.0])}

func _f89(this_, a: Array, env):
	var _t347 = J.G.get("rwd")
	return {"coins": J.cl(_t347, null, [15.0])}

func _f90(this_, a: Array, env):
	var _t348 = J.G.get("rwd")
	return {"exp": J.cl(_t348, null, [8.0])}

func _f91(this_, a: Array, env):
	var _t349 = J.G.get("rwd")
	return {"coins": J.cl(_t349, null, [18.0])}

func _f107(this_, a: Array, env):
	var v_css_285 = null; var v_s_286 = null
	v_css_285 = Callable(self, "_f107").bind(env)
	v_s_286 = J.S_document_("createElement", ["style"])
	J.sp(v_s_286, "textContent", "#antag-chip{position:absolute;left:8px;bottom:8px;z-index:4;max-width:78%;padding:6px 10px;background:rgba(20,12,22,.86);color:#f3e6c8;font-size:13.5px;line-height:1.5;border-radius:4px;box-shadow:inset 0 0 0 1px rgba(243,214,138,.45)}#antag-chip b{color:#ff8a6a;margin-right:4px}")
	var _t350 = J.gp(J.G.get("document"), "head")
	J.mc(_t350, "appendChild", [v_s_286])

func _f1(this_, a: Array, env):
	var v_NM_3 = null; var v_stageOpen_18 = null; var v_tick_44 = null; var v_init_46 = null; var v_demo_48 = null
	var _s2 = {"__p": env, "ART": null, "GAP": null, "REVIEW_GAP": null, "art": null, "seen": null, "R": null, "st": null, "rot": null, "now": null, "mins": null, "LOOK": null, "deco": null, "play": null, "toast": null, "done": null, "TASKS": null, "ABSURD": null, "BOSS_OPEN": null, "BOSS_PASS": null, "BOSS_FAIL": null, "bossVisit": null, "bossGroup": null, "taskProg": null, "bossReview": null, "BRYAN_CLAIM": null, "ALIBI": null, "BRYAN_LOSE": null, "BRYAN_RUN": null, "smartest": null, "rivalIntro": null, "rivalTheft": null, "RUMORS": null, "HURT": null, "rivalGossip": null, "ROUNDS": null, "rivalShowdown": null, "HR_INTRO": null, "warn": null, "HR_EV": null, "hrEvent": null, "credit": null, "hud": null}
	_s2["st"] = Callable(self, "_f4").bind(_s2)
	_s2["rot"] = Callable(self, "_f5").bind(_s2)
	_s2["deco"] = Callable(self, "_f8").bind(_s2)
	_s2["play"] = Callable(self, "_f10").bind(_s2)
	_s2["toast"] = Callable(self, "_f15").bind(_s2)
	_s2["done"] = Callable(self, "_f16").bind(_s2)
	v_stageOpen_18 = Callable(self, "_f19").bind(_s2)
	_s2["bossVisit"] = Callable(self, "_f43").bind(_s2)
	_s2["bossGroup"] = Callable(self, "_f49").bind(_s2)
	_s2["taskProg"] = Callable(self, "_f55").bind(_s2)
	_s2["bossReview"] = Callable(self, "_f56").bind(_s2)
	_s2["smartest"] = Callable(self, "_f58").bind(_s2)
	_s2["rivalIntro"] = Callable(self, "_f59").bind(_s2)
	_s2["rivalTheft"] = Callable(self, "_f60").bind(_s2)
	_s2["rivalGossip"] = Callable(self, "_f65").bind(_s2)
	_s2["rivalShowdown"] = Callable(self, "_f72").bind(_s2)
	_s2["hrEvent"] = Callable(self, "_f92").bind(_s2)
	v_tick_44 = Callable(self, "_f99").bind(_s2)
	_s2["credit"] = Callable(self, "_f101").bind(_s2)
	v_init_46 = Callable(self, "_f102").bind(_s2)
	_s2["hud"] = Callable(self, "_f105").bind(_s2)
	v_demo_48 = Callable(self, "_f108").bind(_s2)
	_s2["ART"] = {"boss": "npc_kpiboss", "rival": "npc_rival", "hr": "npc_hr"}
	v_NM_3 = {"boss": "龐總", "rival": "Bryan", "hr": "冼小姐"}
	_s2["GAP"] = 360.0
	_s2["REVIEW_GAP"] = 45.0
	_s2["art"] = Callable(self, "_f2").bind(_s2)
	_s2["seen"] = Callable(self, "_f3").bind(_s2)
	_s2["R"] = J.gp(J.G.get("Math"), "random")
	_s2["now"] = Callable(self, "_f6").bind(_s2)
	_s2["mins"] = Callable(self, "_f7").bind(_s2)
	_s2["LOOK"] = {"龐總": {"base": "ag:inspect", "talk": "ag:tap"}, "Bryan": {"base": "ag:spin", "talk": "ag:dribble"}, "冼小姐": {"base": "ag:clip", "talk": "ag:glasses"}}
	if J.seq(J.typeof_(J.G.get("ratesPerMin")), "function"):
		var _s28 = {"__p": _s2, "orig": null}
		_s28["orig"] = J.G.get("ratesPerMin")
		J.G["ratesPerMin"] = Callable(self, "_f17").bind(_s28)
	_s2["TASKS"] = {"chop": {"ok": Callable(self, "_f20").bind(_s2), "n": Callable(self, "_f21").bind(_s2), "m": 5.0, "val": Callable(self, "_f22").bind(_s2), "unit": "棵", "what": "親手砍槐樹", "lines": Callable(self, "_f23").bind(_s2)}, "rice": {"ok": Callable(self, "_f24").bind(_s2), "n": Callable(self, "_f25").bind(_s2), "m": 5.0, "val": Callable(self, "_f26").bind(_s2), "unit": "次", "what": "親手收割糯米", "lines": Callable(self, "_f27").bind(_s2)}, "bun": {"ok": Callable(self, "_f28").bind(_s2), "n": Callable(self, "_f29").bind(_s2), "m": 6.0, "val": Callable(self, "_f30").bind(_s2), "unit": "次", "what": "親手包壽包", "lines": Callable(self, "_f31").bind(_s2)}, "plank": {"ok": Callable(self, "_f32").bind(_s2), "n": Callable(self, "_f33").bind(_s2), "m": 6.0, "val": Callable(self, "_f34").bind(_s2), "unit": "次", "what": "親手做棺材板", "lines": Callable(self, "_f35").bind(_s2)}, "stock": {"ok": Callable(self, "_f36").bind(_s2), "n": Callable(self, "_f37").bind(_s2), "m": 7.0, "val": Callable(self, "_f38").bind(_s2), "abs": true, "unit": "個", "what": "倉庫存有壽包", "lines": Callable(self, "_f39").bind(_s2)}, "stage": {"ok": v_stageOpen_18, "n": Callable(self, "_f40").bind(_s2), "m": 10.0, "val": Callable(self, "_f41").bind(_s2), "unit": "關", "what": "打通新關卡", "lines": Callable(self, "_f42").bind(_s2)}}
	_s2["ABSURD"] = [{"ask": "下個月，全村 KPI 要增長三百個巴仙。", "smart": "「龐總，咁上個月嘅 baseline 係幾多？」", "dodge": [["龐總", "（睇平板）落魄村上個月啱啱開張……baseline 係零。"], ["阿福", "零嘅三倍係幾多？"], ["龐總", "……我返去 align 一下。"]]}, {"ask": "由今日起，全村鬼要朝九晚五返工。", "smart": "「冇問題，朝九晚五：晚上九點到朝早五點。」", "dodge": [["龐總", "……即係同而家一樣？"], ["阿福", "一樣。不過而家有制度。"], ["龐總", "好。我要寫入報告：已落實制度化。"]]}, {"ask": "每隻鬼每日要交一份手寫日報，一式三份。", "smart": "「要紙，紙要燒落嚟，燒要冥幣。預算批咗未？」", "dodge": [["龐總", "預算……"], ["阿福", "冇預算，就冇紙。冇紙，就冇日報。"], ["龐總", "（收埋平板）呢個 project，下季再議。"]]}, {"ask": "我要你哋 work harder，同時 work smarter，同時 work-life balance。", "smart": "「三樣揀兩樣。龐總你揀邊兩樣？」", "dodge": [["龐總", "……harder 同 smarter。"], ["阿福", "咁 balance 呢？"], ["龐總", "……smarter 同 balance。"], ["阿福", "咁 harder 呢？"], ["旁白", "龐總站在原地想了一個鐘頭，想到下班。"]]}, {"ask": "清明之前，我要見到陽間家屬滿意度提升。", "smart": "「好，我叫家屬填問卷。問卷燒落嚟，答案燒返上去，每份手續費你批？」", "dodge": [["龐總", "燒返上去要幾多手續費？"], ["阿福", "陰陽兩界轉賬費，一成半。"], ["龐總", "……滿意度呢個指標，我決定唔追。"]]}]
	_s2["BOSS_OPEN"] = ["又係我。唔使驚，驚都冇用，數字唔會因為你驚而升。", "突擊巡查。我唔預約，預約咗你哋就會準備，準備咗啲數就唔真。", "我順路經過。通常我順路經過嘅地方，都會順手裁人。", "我今日心情好，所以只係察 KPI，唔係察你。"]
	_s2["BOSS_PASS"] = [[["龐總", "（望住平板好耐）……達標。我唔會讚你，讚咗你下季就鬆懈。"]], [["龐總", "做到。好，下季目標我加倍——呢個係對你嘅肯定。"]], [["龐總", "合格。唔好笑。你一笑，我就覺得目標定得太低。"]], [["龐總", "……過關。（細細聲）點解每個都過關嘅？係咪我太善良？"]]]
	_s2["BOSS_FAIL"] = [[["龐總", "未達標。你知唔知，你嘅效率輸畀殭屍跳？佢哋膝頭都唔識彎㗎。"]], [["龐總", "差少少。我哋公司冇「差少少」呢個欄位，只有「得」同「你」。"]], [["龐總", "你生前過勞死，死咗又唔過勞。你自己諗吓邊樣比較失禮。"]], [["龐總", "我見過好多冇用嘅員工。你係第一個，冇用得咁有規律。"]]]
	_s2["BRYAN_CLAIM"] = ["兄弟！頭先（{w}），好在有我幫你 cover 住。呢球，我入嘅。", "Bro～恭喜晒！不過頭先（{w}），其實係我助攻。助攻都計分㗎嘛。", "嘩，{w}！我哋做得好呀！我已經同上面報咗，寫我個名先，方便啲嘛。", "{w}？呢個 play 係我喺白板度畫嘅。你只係照住跑啫，兄弟。"]
	_s2["ALIBI"] = ["茶水間度練緊三分波", "廁所度影緊 selfie", "同冼小姐飲緊下午茶", "天台度同龐總影緊合照"]
	_s2["BRYAN_LOSE"] = [["Bryan", "……呢個係假波！我要睇重播！"]]
	_s2["BRYAN_RUN"] = ["好，好，今次當我傳失波。", "你哋玩得咁認真，冇 team spirit 㗎。", "我去熱吓身先，你哋繼續。"]
	_s2["RUMORS"] = ["{n}，我唔係想搬弄是非，不過阿福話你做嘢慢過殭屍跳。我淨係轉述，我好中立㗎。", "{n}，聽講下季你個位要俾 AI 取代。唔好話我講㗎，我只係 pass 個波俾你。", "{n}，你知唔知全村個個都加咗人工？淨係你冇。我都係為你不值啫。", "{n}，阿福私底下話，你係全村最易替代嘅鬼。佢原話係：「隨便搵隻都得。」"]
	_s2["HURT"] = ["……少爺真係咁講？", "（手上啲嘢跌晒落地）", "我……我做咗咁耐……", "原來我喺佢心目中係咁……"]
	_s2["ROUNDS"] = [{"tell": "呢球我唔使郁，自然有人傳俾我。", "q": "第一球：Bryan 守在籃下一動不動。", "right": "自己運球上籃，不傳球", "wrong": "傳給隊友", "win": [["旁白", "阿福自己運球上籃。Bryan 在籃下等了整場，沒人傳球給他。"]], "lose": [["旁白", "球一傳出去，就被 Bryan 截走：「多謝助攻！」"]]}, {"tell": "你掂我一下，我即刻搵冼小姐。", "q": "第二球：Bryan 衝了過來。", "right": "站定不動，等他自己衝過來", "wrong": "貼身防守", "win": [["旁白", "Bryan 衝過來，發現沒人可撞，自己摔在地上。冼小姐舉起印章，無處可蓋。"]], "lose": [["旁白", "阿福一貼身，Bryan 立刻倒地。冼小姐蓋印：「犯規～」"]]}, {"tell": "龐總望緊，呢球我一定要入。", "q": "最後一球：Bryan 望著場邊的龐總起跳。", "right": "請龐總看看平板上的數據", "wrong": "跳起來封阻", "win": [["旁白", "龐總一低頭看平板，就沒人看著 Bryan 了。他一慌，球連籃框都沒碰到。"]], "lose": [["旁白", "Bryan 比阿福高一個頭，假動作騙阿福起跳，再慢慢把球放進去。"]]}]
	_s2["HR_INTRO"] = [["旁白", "一隻梳著髮髻、戴著貓眼眼鏡的女鬼飄進村子，手拿文件夾，腰間掛著一個大紅印。她的笑容很標準，標準得像是印上去的。"], ["冼小姐", "親愛嘅同事～我係人力資源部冼小姐。由今日起，落魄村納入集團員工手冊管理。"], ["冼小姐", "溫馨提示：手冊有三千頁。冇睇過，唔係藉口。"]]
	_s2["warn"] = Callable(self, "_f82").bind(_s2)
	_s2["HR_EV"] = [{"id": "mc", "title": "冼小姐：病假紙", "lines": [["冼小姐", "親愛嘅同事～上個禮拜三你冇出席晨會。根據手冊第 214 條，缺席要補交病假紙。"], ["阿福", "我死咗喇。"], ["冼小姐", "死亡唔係病，係一種長期狀態。長期狀態，要交長期病假紙，一式三份。"]], "q": "冼小姐要你交病假單。", "smart": {"label": "「手冊第一條：員工須在生。我唔在生，手冊唔適用。」", "lines": [["冼小姐", "（揭返去第一頁）……第一條……"], ["冼小姐", "呢條係邊個寫㗎？"], ["阿福", "你。"], ["冼小姐", "（蓋印）批。今次當我冇嚟過。"]], "give": Callable(self, "_f83").bind(_s2)}, "dumb": {"label": "「好，我補交。」", "lines": [["冼小姐", "好乖～七個工作天內交到，逾期當自動辭職。"], ["阿福", "辭職可以去邊？"], ["冼小姐", "返陽間囉，親愛嘅同事～"], ["旁白", "沒有醫生肯替鬼開病假單。"]], "warn": true}}, {"id": "gps", "title": "冼小姐：打卡", "lines": [["冼小姐", "打卡系統顯示：你返工時間，GPS 喺墳場。屬擅離職守。"], ["阿福", "我住喺墳場。"]], "q": "冼小姐說你擅離職守。", "smart": {"label": "「我喺屋企返工，即係 WFH。」", "lines": [["冼小姐", "WFH 要預先申請。"], ["阿福", "申請表喺邊？"], ["冼小姐", "喺公司，要返公司攞。"], ["阿福", "咁我返公司攞表嗰陣，係咪就唔算擅離職守？"], ["冼小姐", "（諗咗好耐，蓋印）……批。你好煩。"]], "give": Callable(self, "_f84").bind(_s2)}, "dumb": {"label": "「我即刻返去補打卡。」", "lines": [["冼小姐", "打卡時間已過，而家打屬於遲到。"], ["阿福", "咁遲到嘅定義係？"], ["冼小姐", "你出現嘅時候。"]], "warn": true}}, {"id": "team", "title": "冼小姐：強制 team-building", "lines": [["冼小姐", "強制性 team-building！今日活動：信任跌。一個向後跌，其他人接住。"], ["阿福", "我哋係鬼，會穿過去。"], ["冼小姐", "所以先要練呀～"]], "q": "怎麼應付這次 team-building？", "smart": {"label": "「參加。」", "lines": [["旁白", "十二隻鬼輪流往後倒，十二次都穿過地面掉了下去。"], ["冼小姐", "好！大家建立咗「冇人會接住你」嘅共識，非常真實。"]], "give": Callable(self, "_f85").bind(_s2)}, "dumb": {"label": "「我今日請病假。」", "lines": [["冼小姐", "病假紙呢？"], ["阿福", "……"]], "warn": true}, "third": {"label": "「改做宵夜啦，增進感情。」", "lines": [["冼小姐", "好主意～預算你出。"], ["旁白", "全村吃了一頓宵夜，大家都很開心，除了冼小姐的預算表。"]], "give": Callable(self, "_f86").bind(_s2), "cost": {"buns": 12.0}}}, {"id": "forms", "title": "冼小姐：一式三份", "lines": [["阿福", "冼小姐，我想申請一日假。"], ["冼小姐", "當然可以～請填 A 表。A 表要附 B 表副本，B 表要先有 C 表批核，C 表要附 A 表正本。"], ["阿福", "……咁我由邊張開始？"], ["冼小姐", "由你諗清楚嗰陣開始。"]], "q": "怎樣才拿得到這一天假？", "smart": {"label": "「我填 D 表：申請豁免填表。」", "lines": [["冼小姐", "D 表？我哋冇 D 表。"], ["阿福", "冇 D 表，即係冇規定唔准。"], ["冼小姐", "（揭咗好耐手冊，蓋印）……批。下年我會加 D 表。"]], "give": Callable(self, "_f87").bind(_s2)}, "dumb": {"label": "「我逐張填。」", "lines": [["旁白", "阿福填了三天三夜，填到第三張才發現：需要第一張的正本，而正本附在第三張上。"], ["冼小姐", "表格有錯，駁回～"]], "slow": true}}, {"id": "happy", "title": "冼小姐：快樂指數", "lines": [["冼小姐", "年度員工快樂指數問卷！一至十分，低過七分要強制參加快樂工作坊。"], ["冼小姐", "溫馨提示：十分屬於異常。異常要寫報告，解釋點解咁開心。"]], "q": "你填幾分？", "smart": {"label": "七分", "lines": [["冼小姐", "七分，標準。你係一個非常正常嘅員工。"], ["阿福", "多謝。"], ["冼小姐", "正常員工下年冇加薪，因為你已經夠快樂～"]], "give": Callable(self, "_f88").bind(_s2)}, "dumb": {"label": "三分", "lines": [["冼小姐", "好～快樂工作坊逢星期六朝早九點。"], ["阿福", "我哋夜晚先出得嚟。"], ["冼小姐", "所以要早啲出門呀～"]], "warn": true}, "third": {"label": "十分", "lines": [["冼小姐", "十分？好可疑。請寫一千字報告，解釋你點解咁開心。"], ["阿福", "寫完我就唔開心喇。"], ["冼小姐", "咁就啱喇～"]], "slow": true}}, {"id": "notice", "title": "冼小姐：病假通告", "lines": [["冼小姐", "溫馨提示～新通告：由今日起，請病假要提早三日通知。"], ["阿福", "我上次請病假，你哋未批，我就直接放咗永久嗰種。"], ["冼小姐", "所以先要提早通知呀，親愛嘅同事～"], ["冼小姐", "另外，你三年前申請嘅年假，今日批咗。請注意：放假期間，請保持電話暢通。"]], "q": "冼小姐要大家遵守新通告。", "smart": {"label": "「好。我禮拜五會病，病因未知。」", "lines": [["冼小姐", "……（望住板夾好耐）"], ["冼小姐", "呢份通告，一個鐘之後收回。"]], "give": Callable(self, "_f89").bind(_s2)}, "dumb": {"label": "「收到。」", "lines": [["冼小姐", "好乖～三日之後，記得準時病。"], ["旁白", "三天後，阿福忘了病。"]], "warn": true}}, {"id": "toilet", "title": "冼小姐：廁所計時器", "lines": [["冼小姐", "新政策！村口茅廁裝咗計時器，每次唔准超過十五分鐘，超時自動 email 龐總。"], ["阿福", "我生前加班到半夜，冇人幫我計時。去個廁所，就有人計。"], ["冼小姐", "所以話公司好關心你呀～"]], "q": "冼小姐要你簽名確認新政策。", "smart": {"label": "「你哋規定唔准超過十五分鐘，冇規定死喺入面點計。」", "lines": [["冼小姐", "（揭手冊）……死喺入面……"], ["冼小姐", "手冊冇寫。（蓋印）呢條，下年先加。"], ["旁白", "計時器暫停使用。門上貼著：「故障，請勿使用」。其實沒有故障，裡面有人。"]], "give": Callable(self, "_f90").bind(_s2)}, "dumb": {"label": "「好，我簽。」", "lines": [["旁白", "計時器每十五分鐘響一次，全村的鬼在茅廁門口排起長龍。"]], "slow": true}}, {"id": "cctv", "title": "冼小姐 × Bryan：舉報", "team": true, "lines": [["冼小姐", "阿福，有同事舉報你上班時間玩手機，有相為證。"], ["Bryan", "我都唔想㗎，兄弟。不過公司利益行先。"], ["阿福", "張相係邊個影㗎？"], ["Bryan", "……一位熱心同事。"]], "q": "冼小姐要發警告信給你。", "smart": {"label": "「調 CCTV 睇吓。」", "lines": [["旁白", "CCTV：Bryan 在辦公室運了一整天球，中途停下來拍了阿福一張照片，然後繼續運球。"], ["冼小姐", "……Bryan，你上班時間打波。"], ["Bryan", "嗰個係 team-building 嚟㗎！"], ["冼小姐", "Team-building 要預先申請～（蓋印）警告信。"], ["Bryan", "……兄弟，呢球算你入。"]], "give": Callable(self, "_f91").bind(_s2), "arc": true}, "dumb": {"label": "「認咗佢，算數。」", "lines": [["Bryan", "好隊友！我會記住你嘅犧牲。"], ["旁白", "他不會。"]], "warn": true}}]
	J.cl(Callable(self, "_f107").bind(_s2), null, [])
	J.cl(v_init_46, null, [])
	return {"st": _s2["st"], "tick": v_tick_44, "credit": _s2["credit"], "hud": _s2["hud"], "demo": v_demo_48, "taskProg": _s2["taskProg"], "HR_EV": _s2["HR_EV"], "ABSURD": _s2["ABSURD"], "TASKS": _s2["TASKS"], "ROUNDS": _s2["ROUNDS"], "RUMORS": _s2["RUMORS"], "BRYAN_CLAIM": _s2["BRYAN_CLAIM"], "BOSS_OPEN": _s2["BOSS_OPEN"], "BOSS_PASS": _s2["BOSS_PASS"], "BOSS_FAIL": _s2["BOSS_FAIL"], "NM": v_NM_3, "ART": _s2["ART"]}
