# 自動轉譯自 scare_ops.js（tools/jsgd.js）——唔好直接改，改原 JS 再轉
extends RefCounted

func run(env):
	var this_ = null; var a = []
	J.G["ScareOps"] = J.cl(Callable(self, "_f1").bind(env), null, [])

func _f6(this_, a: Array, env):
	var v_Sc_33 = null; var v_n_34 = null; var v_st_35 = null; var v_room_36 = null; var v_act_37 = null; var v_atDesk_38 = null
	v_Sc_33 = J.arg(a, 0)
	v_n_34 = J.arg(a, 1)
	var _t1 = J.gp(v_n_34, "step")
	v_st_35 = (_t1 if J.t(_t1) else {})
	v_room_36 = (J.mc(v_Sc_33, "roomOf", [v_n_34]) if J.t(J.gp(J.gp(v_Sc_33, "site"), "pano")) else "")
	var _t3 = J.gp(v_n_34, "act")
	if not J.t(_t3):
		var _t2 = J.gp(v_st_35, "arrived")
		_t3 = (J.gp(v_st_35, "act") if J.t(_t2) else _t2)
	v_act_37 = (_t3 if J.t(_t3) else "")
	var _t4 = J.gp(env["OPS"], J.gp(J.gp(v_n_34, "d"), "k"))
	var _t6 = (J.gp(J.gp(env["OPS"], J.gp(J.gp(v_n_34, "d"), "k")), "pc") if J.t(_t4) else _t4)
	if J.t(_t6):
		var _t5 = ["work", "call"]
		_t6 = J.mc(_t5, "includes", [v_act_37])
	v_atDesk_38 = (not (not J.t(((not J.seq(v_room_36, "pantry")) if J.t(_t6) else _t6))))
	return {"room": v_room_36, "atDesk": v_atDesk_38, "pantry": J.seq(v_room_36, "pantry")}

func _f7(this_, a: Array, env):
	var v_Sc_41 = null; var v_n_42 = null; var v_O_43 = null; var v_c_44 = null; var v_h_45 = null
	v_Sc_41 = J.arg(a, 0)
	v_n_42 = J.arg(a, 1)
	v_O_43 = J.gp(env["OPS"], J.gp(J.gp(v_n_42, "d"), "k"))
	var _t7 = (not J.t(v_O_43))
	if J.t((_t7 if _t7 else J.gp(v_n_42, "out"))):
		return ""
	var _t8 = env["ctx"]
	v_c_44 = J.cl(_t8, null, [v_Sc_41, v_n_42])
	v_h_45 = ""
	if J.t(J.gp(v_O_43, "apps")):
		var _t9 = J.add(v_h_45, ("<button class=\"btn sm\" data-op=\"phone\">手機</button>"))
		v_h_45 = _t9
	if J.t(J.gp(v_c_44, "atDesk")):
		var _t10 = J.add(v_h_45, ("<button class=\"btn sm gold\" data-op=\"pc\">電腦</button>"))
		v_h_45 = _t10
	var _t11 = J.gp(v_c_44, "pantry")
	if J.t(((not J.t(J.gp(J.gp(v_n_42, "d"), "guard"))) if J.t(_t11) else _t11)):
		var _t12 = J.add(v_h_45, ("<button class=\"btn sm gold\" data-op=\"pantry\">茶水間</button>"))
		v_h_45 = _t12
	return v_h_45

func _f10(this_, a: Array, env):
	var _t18 = env["__p"]["close"]
	return J.cl(_t18, null, [env["Sc"]])

func _f9(this_, a: Array, env):
	var v_b_52 = null
	v_b_52 = J.arg(a, 0)
	var _t19 = Callable(self, "_f10").bind(env)
	J.sp(v_b_52, "onclick", _t19)
	return _t19

func _f8(this_, a: Array, env):
	var v_html_49 = null; var v_cls_50 = null; var v_p_51 = null
	var _s9 = {"__p": env, "Sc": null}
	_s9["Sc"] = J.arg(a, 0)
	v_html_49 = J.arg(a, 1)
	v_cls_50 = J.arg(a, 2)
	var _t13 = _s9["Sc"]
	J.sp(_t13, "paused", true)
	var _t14 = J.G.get("$")
	v_p_51 = J.cl(_t14, null, ["#sc-phone"])
	var _t15 = ("<div class=\"" + J.str(v_cls_50) + "\">" + J.str(v_html_49) + "</div>")
	J.sp(v_p_51, "innerHTML", _t15)
	var _t16 = J.gp(v_p_51, "classList")
	J.mc(_t16, "add", ["on"])
	var _t17 = J.mc(v_p_51, "querySelectorAll", ["[data-x]"])
	J.mc(_t17, "forEach", [Callable(self, "_f9").bind(_s9)])
	return v_p_51

func _f11(this_, a: Array, env):
	var v_Sc_55 = null; var v_p_56 = null
	v_Sc_55 = J.arg(a, 0)
	var _t20 = J.G.get("$")
	v_p_56 = J.cl(_t20, null, ["#sc-phone"])
	var _t21 = J.gp(v_p_56, "classList")
	J.mc(_t21, "remove", ["on"])
	J.sp(v_p_56, "innerHTML", "")
	J.sp(v_Sc_55, "paused", false)
	var _t22 = J.S_performance_("now", [])
	J.sp(v_Sc_55, "last", _t22)
	J.mc(v_Sc_55, "renderTarget", [])

func _f13(this_, a: Array, env):
	var v_t_72 = null
	v_t_72 = J.arg(a, 0)
	return J.mc(env["K"], "add", [v_t_72])

func _f14(this_, a: Array, env):
	var v_k_73 = null
	v_k_73 = J.arg(a, 0)
	if J.t(((not J.t(J.mc(env["I"], "has", [v_k_73]))) if J.t(v_k_73) else v_k_73)):
		J.mc(env["I"], "add", [v_k_73])
		var _t34 = J.gp(env["__p"]["INTEL_NAME"], v_k_73)
		J.mc(env["got"], "push", [(_t34 if J.t(_t34) else v_k_73)])

func _f16(this_, a: Array, env):
	var v_m_75 = null
	v_m_75 = J.arg(a, 0)
	return (("<div class=\"sc-m " + ("me" if J.seq(J.gp(v_m_75, 0.0), J.gp(J.gp(env["n"], "d"), "name")) else "") + "\"><i>" + J.str(J.gp(v_m_75, 0.0)) + "・" + J.str(J.gp(v_m_75, 1.0)) + "</i>" + J.str(J.gp(v_m_75, 2.0)) + "</div>") if J.t(J.gp(v_m_75, 0.0)) else ("<div class=\"so-sys\">" + J.str(J.gp(v_m_75, 2.0)) + "</div>"))

func _f15(this_, a: Array, env):
	var v_c_74 = null
	v_c_74 = J.arg(a, 0)
	var _t36 = env["learn"]
	J.cl(_t36, null, [J.gp(v_c_74, "intel")])
	var _t39 = J.gp(v_c_74, "title")
	var _t37 = J.gp(v_c_74, "items")
	var _t38 = J.mc(_t37, "map", [Callable(self, "_f16").bind(env)])
	return ("<div class=\"so-chat\"><div class=\"so-ct\">" + J.str(_t39) + "</div>" + J.str(J.mc(_t38, "join", [""])) + "</div>")

func _f17(this_, a: Array, env):
	var v_p_76 = null; var v_i_77 = null
	v_p_76 = J.arg(a, 0)
	v_i_77 = J.arg(a, 1)
	return ("<div class=\"so-ph\"><span>" + J.str(J.add(v_i_77, 1.0)) + "</span>" + J.str(v_p_76) + "</div>")

func _f18(this_, a: Array, env):
	var v_s_78 = null
	v_s_78 = J.arg(a, 0)
	var _t47 = env["learn"]
	J.cl(_t47, null, [J.gp(v_s_78, 1.0)])
	return ("<div class=\"so-search\">🔍 " + J.str(J.gp(v_s_78, 0.0)) + "</div>")

func _f19(this_, a: Array, env):
	var v_l_79 = null
	v_l_79 = J.arg(a, 0)
	return ("<p>" + J.str(v_l_79) + "</p>")

func _f20(this_, a: Array, env):
	var v_k_80 = null
	v_k_80 = J.arg(a, 0)
	return ("<button class=\"" + ("on" if J.seq(v_k_80, env["tab"]) else "") + "\" data-tab=\"" + J.str(v_k_80) + "\">" + J.str(J.gp(env["__p"]["TAB"], v_k_80)) + "</button>")

func _f22(this_, a: Array, env):
	var _t61 = env["__p"]["__p"]["openPhone"]
	return J.cl(_t61, null, [env["__p"]["Sc"], env["__p"]["n"], J.gp(J.gp(env["b"], "dataset"), "tab")])

func _f21(this_, a: Array, env):
	var _s26 = {"__p": env, "b": null}
	_s26["b"] = J.arg(a, 0)
	var _t60 = _s26["b"]
	var _t62 = Callable(self, "_f22").bind(_s26)
	J.sp(_t60, "onclick", _t62)
	return _t62

func _f23(this_, a: Array, env):
	var _t63 = env["__p"]["compose"]
	return J.cl(_t63, null, [env["Sc"], env["n"]])

func _f12(this_, a: Array, env):
	var v_O_62 = null; var v_A_63 = null; var v_body_68 = null; var v_msgs_69 = null; var v_p_70 = null; var v_s_71 = null
	var _s13 = {"__p": env, "Sc": null, "n": null, "tab": null, "I": null, "K": null, "got": null, "learn": null}
	_s13["Sc"] = J.arg(a, 0)
	_s13["n"] = J.arg(a, 1)
	_s13["tab"] = J.arg(a, 2)
	v_O_62 = J.gp(_s13["__p"]["OPS"], J.gp(J.gp(_s13["n"], "d"), "k"))
	v_A_63 = J.gp(v_O_62, "apps")
	var _t23 = _s13["__p"]["intel"]
	_s13["I"] = J.cl(_t23, null, [_s13["Sc"], J.gp(J.gp(_s13["n"], "d"), "k")])
	var _t24 = (_s13["tab"] if J.t(_s13["tab"]) else "msg")
	_s13["tab"] = _t24
	var _t25 = _s13["Sc"]
	var _t26 = J.gp(_s13["Sc"], "known")
	var _t27 = (_t26 if J.t(_t26) else {})
	J.sp(_t25, "known", _t27)
	var _t28 = J.gp(_s13["Sc"], "known")
	var _t29 = J.gp(J.gp(_s13["n"], "d"), "k")
	var _t30 = J.gp(J.gp(_s13["Sc"], "known"), J.gp(J.gp(_s13["n"], "d"), "k"))
	var _t31 = (_t30 if J.t(_t30) else J.new_("Set", []))
	J.sp(_t28, _t29, _t31)
	_s13["K"] = _t31
	var _t32 = J.gp(J.gp(_s13["n"], "d"), "hide")
	var _t33 = (_t32 if J.t(_t32) else [])
	J.mc(_t33, "forEach", [Callable(self, "_f13").bind(_s13)])
	_s13["got"] = []
	_s13["learn"] = Callable(self, "_f14").bind(_s13)
	v_body_68 = ""
	if J.seq(_s13["tab"], "msg"):
		var _t35 = J.gp(v_A_63, "msg")
		var _t40 = J.mc(_t35, "map", [Callable(self, "_f15").bind(_s13)])
		var _t41 = J.mc(_t40, "join", [""])
		v_body_68 = _t41
	if J.seq(_s13["tab"], "photo"):
		var _t42 = _s13["learn"]
		J.cl(_t42, null, [J.gp(v_A_63, "intelPhoto")])
		var _t43 = J.gp(v_A_63, "photo")
		var _t44 = J.mc(_t43, "map", [Callable(self, "_f17").bind(_s13)])
		var _t45 = ("<div class=\"so-photos\">" + J.str(J.mc(_t44, "join", [""])) + "</div>")
		v_body_68 = _t45
	if J.seq(_s13["tab"], "search"):
		var _t46 = J.gp(v_A_63, "search")
		var _t48 = J.mc(_t46, "map", [Callable(self, "_f18").bind(_s13)])
		var _t49 = J.mc(_t48, "join", [""])
		v_body_68 = _t49
	if J.seq(_s13["tab"], "note"):
		var _t50 = J.gp(v_A_63, "note")
		var _t51 = J.mc(_t50, "map", [Callable(self, "_f19").bind(_s13)])
		var _t52 = ("<div class=\"so-note\">" + J.str(J.mc(_t51, "join", [""])) + "</div>")
		v_body_68 = _t52
	var _t53 = J.gp(v_O_62, "msgs")
	v_msgs_69 = (_t53 if J.t(_t53) else [])
	var _t54 = _s13["__p"]["modal"]
	var _t58 = _s13["Sc"]
	var _t57 = J.gp(J.gp(_s13["n"], "d"), "name")
	var _t55 = J.S_Object_("keys", [_s13["__p"]["TAB"]])
	var _t56 = J.mc(_t55, "map", [Callable(self, "_f20").bind(_s13)])
	v_p_70 = J.cl(_t54, null, [_t58, ("<div class=\"sc-ph-h\">" + J.str(_t57) + " 的手機<button data-x>✕</button></div>\n      <div class=\"so-tabs\">" + J.str(J.mc(_t56, "join", [""])) + "</div>\n      <div class=\"sc-ph-b\">" + J.str(v_body_68) + "</div>\n      " + (("<div class=\"so-got\">得到情報：" + J.str(J.mc(_s13["got"], "join", ["、"])) + "</div>") if J.t(J.len(_s13["got"])) else "") + "\n      <div class=\"sc-ph-f\">" + (("<button class=\"btn gold wide\" data-send>傳訊息嚇他</button>") if J.t(J.len(v_msgs_69)) else "") + "<small>看手機時，時間是停的。</small></div>"), "sc-ph so-phone"])
	var _t59 = J.mc(v_p_70, "querySelectorAll", ["[data-tab]"])
	J.mc(_t59, "forEach", [Callable(self, "_f21").bind(_s13)])
	v_s_71 = J.mc(v_p_70, "querySelector", ["[data-send]"])
	if J.t(v_s_71):
		var _t64 = Callable(self, "_f23").bind(_s13)
		J.sp(v_s_71, "onclick", _t64)
	var _t65 = J.len(_s13["got"])
	if J.t(((not J.t(J.gp(_s13["Sc"], "headless"))) if J.t(_t65) else _t65)):
		J.mc(_s13["Sc"], "renderTarget", [])

func _f24(this_, a: Array, env):
	var v_Sc_84 = null; var v_n_85 = null; var v_o_86 = null; var v_locked_87 = null; var v_cd_88 = null; var v_poor_89 = null
	v_Sc_84 = J.arg(a, 0)
	v_n_85 = J.arg(a, 1)
	v_o_86 = J.arg(a, 2)
	v_locked_87 = J.arg(a, 3)
	var _t66 = env["cdOf"]
	v_cd_88 = J.cl(_t66, null, [v_Sc_84, v_n_85, J.gp(v_o_86, "id")])
	v_poor_89 = J.cmp(J.gp(v_Sc_84, "mana"), J.gp(v_o_86, "cost"), "<")
	var _t71 = ("lock" if J.t(v_locked_87) else "")
	var _t72 = ("dim" if J.t((v_cd_88 if J.t(v_cd_88) else v_poor_89)) else "")
	var _t73 = J.gp(v_o_86, "id")
	var _t74 = ("disabled" if J.t((v_locked_87 if J.t(v_locked_87) else v_cd_88)) else "")
	var _t75 = (("<b>" + J.str(J.gp(v_o_86, "who")) + "</b>") if J.t(J.gp(v_o_86, "who")) else "")
	var _t76 = J.gp(v_o_86, "text")
	var _t70 = null
	if J.t(v_locked_87):
		_t70 = ("需要情報：" + J.str(J.gp(env["INTEL_NAME"], J.gp(v_o_86, "need"))) + "（先看他的手機）")
	else:
		var _t69 = null
		if J.t(v_cd_88):
			_t69 = ("冷卻 " + J.str(ceil(J.num(v_cd_88))) + " 秒")
		else:
			var _t68 = J.gp(v_o_86, "cost")
			var _t67 = J.gp(v_o_86, "trap")
			_t69 = ("陰氣 " + J.str(_t68) + ("" if J.t((_t67 if J.t(_t67) else J.gp(v_o_86, "warm"))) else ("・算「" + J.str(J.gp(J.G.get("FEAR_WORD"), J.gp(v_o_86, "type"))) + "」")))
		_t70 = _t69
	return ("<button class=\"so-op " + _t71 + " " + _t72 + "\" data-o=\"" + J.str(_t73) + "\" " + _t74 + ">\n      " + _t75 + "<span>" + J.str(_t76) + "</span><small>" + _t70 + "</small></button>")

func _f26(this_, a: Array, env):
	var v_o_97 = null
	v_o_97 = J.arg(a, 0)
	var _t80 = env["__p"]["optRow"]
	var _t82 = env["Sc"]
	var _t83 = env["n"]
	var _t81 = J.gp(v_o_97, "need")
	return J.cl(_t80, null, [_t82, _t83, v_o_97, ((not J.t(J.mc(env["I"], "has", [J.gp(v_o_97, "need")]))) if J.t(_t81) else _t81)])

func _f27(this_, a: Array, env):
	var _t88 = env["__p"]["openPhone"]
	return J.cl(_t88, null, [env["Sc"], env["n"]])

func _f25(this_, a: Array, env):
	var v_O_94 = null; var v_p_96 = null
	var _s30 = {"__p": env, "Sc": null, "n": null, "I": null}
	_s30["Sc"] = J.arg(a, 0)
	_s30["n"] = J.arg(a, 1)
	v_O_94 = J.gp(_s30["__p"]["OPS"], J.gp(J.gp(_s30["n"], "d"), "k"))
	var _t77 = _s30["__p"]["intel"]
	_s30["I"] = J.cl(_t77, null, [_s30["Sc"], J.gp(J.gp(_s30["n"], "d"), "k")])
	var _t78 = _s30["__p"]["modal"]
	var _t86 = _s30["Sc"]
	var _t85 = J.gp(J.gp(_s30["n"], "d"), "name")
	var _t79 = J.gp(v_O_94, "msgs")
	var _t84 = J.mc(_t79, "map", [Callable(self, "_f26").bind(_s30)])
	v_p_96 = J.cl(_t78, null, [_t86, ("<div class=\"sc-ph-h\">傳訊息給 " + J.str(_t85) + "<button data-x>✕</button></div><div class=\"sc-ph-b so-list\"><p class=\"so-hint\">選冒充誰、傳什麼。對準他怕的、用上情報，嚇得最狠；選錯了可能反效果。</p>" + J.str(J.mc(_t84, "join", [""])) + "</div><div class=\"sc-ph-f\"><button class=\"btn sm\" data-back>返回手機</button></div>"), "sc-ph so-phone"])
	var _t87 = J.mc(v_p_96, "querySelector", ["[data-back]"])
	var _t89 = Callable(self, "_f27").bind(_s30)
	J.sp(_t87, "onclick", _t89)
	var _t90 = _s30["__p"]["bindOps"]
	J.cl(_t90, null, [_s30["Sc"], _s30["n"], v_p_96, J.gp(v_O_94, "msgs"), "msg"])

func _f29(this_, a: Array, env):
	var v_l_104 = null
	v_l_104 = J.arg(a, 0)
	return ("<p>" + J.str(v_l_104) + "</p>")

func _f30(this_, a: Array, env):
	var v_o_105 = null
	v_o_105 = J.arg(a, 0)
	var _t97 = env["__p"]["optRow"]
	return J.cl(_t97, null, [env["Sc"], env["n"], v_o_105])

func _f28(this_, a: Array, env):
	var v_P_102 = null; var v_p_103 = null
	var _s33 = {"__p": env, "Sc": null, "n": null}
	_s33["Sc"] = J.arg(a, 0)
	_s33["n"] = J.arg(a, 1)
	v_P_102 = J.gp(J.gp(_s33["__p"]["OPS"], J.gp(J.gp(_s33["n"], "d"), "k")), "pc")
	var _t91 = _s33["__p"]["modal"]
	var _t100 = _s33["Sc"]
	var _t94 = J.gp(J.gp(_s33["n"], "d"), "name")
	var _t95 = J.gp(v_P_102, "title")
	var _t92 = J.gp(v_P_102, "lines")
	var _t93 = J.mc(_t92, "map", [Callable(self, "_f29").bind(_s33)])
	var _t99 = J.mc(_t93, "join", [""])
	var _t96 = J.gp(v_P_102, "ops")
	var _t98 = J.mc(_t96, "map", [Callable(self, "_f30").bind(_s33)])
	v_p_103 = J.cl(_t91, null, [_t100, ("<div class=\"so-mon\"><div class=\"so-mh\">" + J.str(_t94) + " 的電腦<button data-x>✕</button></div><div class=\"so-scr\"><b>" + J.str(_t95) + "</b>" + J.str(_t99) + "</div></div><div class=\"so-list\">" + J.str(J.mc(_t98, "join", [""])) + "</div>"), "so-pc"])
	var _t101 = _s33["__p"]["bindOps"]
	J.cl(_t101, null, [_s33["Sc"], _s33["n"], v_p_103, J.gp(v_P_102, "ops"), "pc"])

func _f32(this_, a: Array, env):
	var v_o_111 = null
	v_o_111 = J.arg(a, 0)
	var _t103 = env["__p"]["optRow"]
	return J.cl(_t103, null, [env["Sc"], env["n"], v_o_111])

func _f31(this_, a: Array, env):
	var v_p_110 = null
	var _s36 = {"__p": env, "Sc": null, "n": null}
	_s36["Sc"] = J.arg(a, 0)
	_s36["n"] = J.arg(a, 1)
	var _t102 = _s36["__p"]["modal"]
	var _t106 = _s36["Sc"]
	var _t105 = J.gp(J.gp(_s36["n"], "d"), "name")
	var _t104 = J.mc(_s36["__p"]["PANTRY"], "map", [Callable(self, "_f32").bind(_s36)])
	v_p_110 = J.cl(_t102, null, [_t106, ("<div class=\"so-mh\">茶水間・" + J.str(_t105) + "<button data-x>✕</button></div><div class=\"so-list\"><p class=\"so-hint\">他在茶水間。選一樣他怕的。</p>" + J.str(J.mc(_t104, "join", [""])) + "</div>"), "so-pc"])
	var _t107 = _s36["__p"]["bindOps"]
	J.cl(_t107, null, [_s36["Sc"], _s36["n"], v_p_110, _s36["__p"]["PANTRY"], "pantry"])

func _f36(this_, a: Array, env):
	var v_x_121 = null
	v_x_121 = J.arg(a, 0)
	return J.seq(J.gp(v_x_121, "id"), J.gp(J.gp(env["b"], "dataset"), "o"))

func _f35(this_, a: Array, env):
	var v_o_120 = null
	v_o_120 = J.mc(env["__p"]["list"], "find", [Callable(self, "_f36").bind(env)])
	if J.t(v_o_120):
		var _t110 = env["__p"]["__p"]["act"]
		J.cl(_t110, null, [env["__p"]["Sc"], env["__p"]["n"], v_o_120, env["__p"]["kind"]])

func _f34(this_, a: Array, env):
	var _s39 = {"__p": env, "b": null}
	_s39["b"] = J.arg(a, 0)
	var _t109 = _s39["b"]
	var _t111 = Callable(self, "_f35").bind(_s39)
	J.sp(_t109, "onclick", _t111)
	return _t111

func _f33(this_, a: Array, env):
	var v_p_116 = null
	var _s38 = {"__p": env, "Sc": null, "n": null, "list": null, "kind": null}
	_s38["Sc"] = J.arg(a, 0)
	_s38["n"] = J.arg(a, 1)
	v_p_116 = J.arg(a, 2)
	_s38["list"] = J.arg(a, 3)
	_s38["kind"] = J.arg(a, 4)
	var _t108 = J.mc(v_p_116, "querySelectorAll", ["[data-o]"])
	J.mc(_t108, "forEach", [Callable(self, "_f34").bind(_s38)])

func _f38(this_, a: Array, env):
	var _t141 = J.gp(env["Sc"], "active")
	if J.t(((not J.t(J.gp(env["n"], "gone"))) if J.t(_t141) else _t141)):
		var _t142 = env["n"]
		J.sp(_t142, "bubT", 0.0)
		var _t144 = env["n"]
		var _t143 = env["__p"]["Lx"]
		J.mc(env["Sc"], "bubble", [_t144, J.cl(_t143, null, [J.gp(env["o"], "say")]), 2.8])

func _f37(this_, a: Array, env):
	var v_kind_127 = null; var v_tag_128 = null; var v_personal_129 = null; var v_e_130 = null; var v_e_131 = null; var v_say_132 = null
	var _s42 = {"__p": env, "Sc": null, "n": null, "o": null}
	_s42["Sc"] = J.arg(a, 0)
	_s42["n"] = J.arg(a, 1)
	_s42["o"] = J.arg(a, 2)
	v_kind_127 = J.arg(a, 3)
	if J.cmp(J.gp(_s42["Sc"], "mana"), J.gp(_s42["o"], "cost"), "<"):
		J.mc(_s42["Sc"], "toast", ["陰氣不夠，等一下"])
		return null
	var _t112 = _s42["__p"]["cdOf"]
	if J.cmp(J.cl(_t112, null, [_s42["Sc"], _s42["n"], J.gp(_s42["o"], "id")]), 0.0, ">"):
		return null
	var _t113 = _s42["__p"]["close"]
	J.cl(_t113, null, [_s42["Sc"]])
	var _t114 = J.gp(_s42["n"], "gone")
	var _t115 = (_t114 if J.t(_t114) else J.gp(_s42["n"], "out"))
	if J.t((_t115 if J.t(_t115) else J.gp(_s42["n"], "fleeing"))):
		J.mc(_s42["Sc"], "toast", [(J.str(J.gp(J.gp(_s42["n"], "d"), "name")) + "不在")])
		return null
	var _t116 = _s42["Sc"]
	var _t117 = J.sub(J.gp(_t116, "mana"), J.gp(_s42["o"], "cost"))
	J.sp(_t116, "mana", _t117)
	var _t118 = _s42["Sc"]
	var _t119 = J.gp(_s42["Sc"], "_opcd")
	var _t120 = (_t119 if J.t(_t119) else {})
	J.sp(_t118, "_opcd", _t120)
	var _t121 = J.gp(_s42["Sc"], "_opcd")
	var _t122 = J.add(J.gp(J.gp(_s42["n"], "d"), "k"), J.gp(_s42["o"], "id"))
	var _t123 = J.add(J.gp(_s42["Sc"], "t"), _s42["__p"]["CD"])
	J.sp(_t121, _t122, _t123)
	if (not J.t(J.gp(_s42["Sc"], "headless"))):
		J.mc(J.G.get("Sound"), "play", [("click" if J.seq(v_kind_127, "msg") else ("paper" if J.seq(v_kind_127, "pc") else "whoosh"))])
		var _t124 = J.gp(_s42["Sc"], "fx")
		J.mc(_t124, "push", [{"kind": ("phone" if J.seq(v_kind_127, "msg") else "breath"), "life": 1.6, "max": 1.6, "n": _s42["n"]}])
	v_tag_128 = (("📱 " + J.str(J.gp(_s42["o"], "who")) + "：" + J.str(J.gp(_s42["o"], "text"))) if J.seq(v_kind_127, "msg") else J.gp(_s42["o"], "text"))
	J.mc(_s42["Sc"], "float", [J.gp(_s42["n"], "x"), J.sub(J.gp(_s42["n"], "y"), 0.3), (J.add(J.mc(v_tag_128, "slice", [0.0, 25.0]), "…") if (J.len(v_tag_128) > 26.0) else v_tag_128), "#e8d8ff", 2.0])
	var _t125 = J.gp(_s42["o"], "fx")
	var _t126 = ((not J.seq(J.typeof_(J.G.get("Pantry")), "undefined")) if J.t(_t125) else _t125)
	if J.t(((not J.t(J.gp(_s42["Sc"], "headless"))) if J.t(_t126) else _t126)):
		J.mc(J.G.get("Pantry"), "fx", [J.gp(_s42["o"], "fx"), _s42["n"]])
	if J.t(J.gp(_s42["o"], "trap")):
		var _t127 = _s42["n"]
		var _t128 = J.max_([0.0, J.sub(J.gp(_s42["n"], "fear"), 20.0)])
		J.sp(_t127, "fear", _t128)
		var _t129 = _s42["n"]
		J.sp(_t129, "combo", 0.0)
		var _t131 = _s42["n"]
		var _t130 = _s42["__p"]["Lx"]
		J.mc(_s42["Sc"], "bubble", [_t131, J.cl(_t130, null, [J.gp(_s42["o"], "say")]), 2.6])
		J.mc(_s42["Sc"], "float", [J.gp(_s42["n"], "x"), J.sub(J.gp(_s42["n"], "y"), 0.34), ("反效果：" + J.str(J.gp(_s42["o"], "why"))), "#ff9a8a", 2.0])
		return null
	if J.t(J.gp(_s42["o"], "warm")):
		var _t132 = _s42["n"]
		var _t133 = J.max_([0.0, J.sub(J.gp(_s42["n"], "fear"), 10.0)])
		J.sp(_t132, "fear", _t133)
		var _t135 = _s42["n"]
		var _t134 = _s42["__p"]["Lx"]
		J.mc(_s42["Sc"], "bubble", [_t135, J.cl(_t134, null, [J.gp(_s42["o"], "say")]), 2.8])
		J.mc(_s42["Sc"], "addKarma", [J.gp(_s42["n"], "d"), 1.0, (J.str(J.gp(J.gp(_s42["n"], "d"), "name")) + "：" + J.str(J.gp(_s42["o"], "why")))])
		J.mc(_s42["Sc"], "float", [J.gp(_s42["n"], "x"), J.sub(J.gp(_s42["n"], "y"), 0.34), "陰德 +1", "#a8f0b0", 2.0])
		return null
	v_personal_129 = (not (not J.t(J.gp(_s42["o"], "need"))))
	var _t136 = _s42["Sc"]
	J.sp(_t136, "_src", null)
	var _t137 = _s42["Sc"]
	J.sp(_t137, "_dl", 0.0)
	var _t138 = _s42["Sc"]
	J.sp(_t138, "_vis", false)
	J.mc(_s42["Sc"], "hit", [_s42["n"], J.gp(_s42["o"], "type"), J.round(J.num(J.mul(J.gp(_s42["o"], "base"), (1.4 if J.t(v_personal_129) else 1.0)))), J.gp(_s42["o"], "tier"), null, true])
	if J.t(((not J.t(J.gp(_s42["Sc"], "headless"))) if J.t(v_personal_129) else v_personal_129)):
		J.mc(_s42["Sc"], "float", [J.gp(_s42["n"], "x"), J.sub(J.gp(_s42["n"], "y"), 0.38), "用上情報：正中要害", "#ffd84a", 1.8])
	var _t140 = J.gp(_s42["o"], "say")
	if J.t(_t140):
		var _t139 = J.gp(J.gp(_s42["n"], "d"), "immune")
		_t140 = (not J.t(J.mc(_t139, "includes", [J.gp(_s42["o"], "type")])))
	if J.t(_t140):
		v_say_132 = Callable(self, "_f38").bind(_s42)
		J.cl(v_say_132, null, [])
		if (not J.t(J.gp(_s42["Sc"], "headless"))):
			J.F_setTimeout([v_say_132, 1100.0])

func _f41(this_, a: Array, env):
	var v_b_143 = null
	v_b_143 = J.arg(a, 0)
	return J.mc(v_b_143, "remove", [])

func _f43(this_, a: Array, env):
	var v_k_145 = null
	v_k_145 = J.gp(J.gp(env["b"], "dataset"), "op")
	if J.seq(v_k_145, "phone"):
		var _t154 = env["__p"]["__p"]["__p"]["__p"]["openPhone"]
		J.cl(_t154, null, [env["__p"]["__p"]["this"], env["__p"]["n"]])
	else:
		if J.seq(v_k_145, "pc"):
			var _t155 = env["__p"]["__p"]["__p"]["__p"]["openPC"]
			J.cl(_t155, null, [env["__p"]["__p"]["this"], env["__p"]["n"]])
		else:
			var _t156 = env["__p"]["__p"]["__p"]["__p"]["openPantry"]
			J.cl(_t156, null, [env["__p"]["__p"]["this"], env["__p"]["n"]])

func _f42(this_, a: Array, env):
	var _s62 = {"__p": env, "b": null}
	_s62["b"] = J.arg(a, 0)
	var _t153 = _s62["b"]
	var _t157 = Callable(self, "_f43").bind(_s62)
	J.sp(_t153, "onclick", _t157)
	return _t157

func _f40(this_, a: Array, env):
	var v_r_139 = null; var v_who_141 = null; var v_box_142 = null; var v_e_146 = null
	var _s59 = {"__p": env, "this": null}
	_s59["this"] = this_
	v_r_139 = J.mc(_s59["__p"]["ort"], "apply", [_s59["this"], a])
	var _s60 = {"__p": _s59, "n": null}
	var _t146 = J.gp(_s60["__p"]["this"], "sel")
	var _t147 = ((not J.t(J.gp(J.gp(_s60["__p"]["this"], "sel"), "gone"))) if J.t(_t146) else _t146)
	_s60["n"] = (J.gp(_s60["__p"]["this"], "sel") if J.t(((not J.t(J.gp(J.gp(_s60["__p"]["this"], "sel"), "fleeing"))) if J.t(_t147) else _t147)) else null)
	if (not J.t(_s60["n"])):
		return v_r_139
	var _t148 = J.G.get("$")
	v_who_141 = J.cl(_t148, null, ["#sc-target .sc-who"])
	if (not J.t(v_who_141)):
		return v_r_139
	var _t149 = J.mc(v_who_141, "querySelectorAll", ["#sc-peek,#sc-wa"])
	J.mc(_t149, "forEach", [Callable(self, "_f41").bind(_s60)])
	v_box_142 = J.S_document_("createElement", ["span"])
	J.sp(v_box_142, "className", "so-btns")
	var _t150 = _s60["__p"]["__p"]["__p"]["buttons"]
	var _t151 = J.cl(_t150, null, [_s60["__p"]["this"], _s60["n"]])
	J.sp(v_box_142, "innerHTML", _t151)
	J.mc(v_who_141, "insertBefore", [v_box_142, J.mc(v_who_141, "querySelector", ["#sc-br"])])
	var _t152 = J.mc(v_box_142, "querySelectorAll", ["[data-op]"])
	J.mc(_t152, "forEach", [Callable(self, "_f42").bind(_s60)])
	var _t158 = _s60["__p"]["this"]
	var _t159 = _s60["__p"]["__p"]["__p"]["ctx"]
	var _t160 = J.S_JSON_("stringify", [J.cl(_t159, null, [_s60["__p"]["this"], _s60["n"]])])
	J.sp(_t158, "_opCtx", _t160)
	return v_r_139

func _f44(this_, a: Array, env):
	var v_r_149 = null; var v_n_150 = null; var v_e_151 = null
	v_r_149 = J.mc(env["ohud"], "apply", [this_, a])
	v_n_150 = J.gp(this_, "sel")
	var _t163 = ((not J.t(J.gp(v_n_150, "gone"))) if J.t(v_n_150) else v_n_150)
	var _t165 = ((not J.t(J.gp(this_, "paused"))) if J.t(_t163) else _t163)
	if J.t(_t165):
		var _t164 = env["__p"]["ctx"]
		_t165 = (not J.seq(J.S_JSON_("stringify", [J.cl(_t164, null, [this_, v_n_150])]), J.gp(this_, "_opCtx")))
	if J.t(_t165):
		J.mc(this_, "renderTarget", [])
	return v_r_149

func _f39(this_, a: Array, env):
	var _s58 = {"__p": env, "ort": null, "ohud": null}
	_s58["ort"] = J.gp(J.G.get("Scare"), "renderTarget")
	var _t145 = J.G.get("Scare")
	var _t161 = Callable(self, "_f40").bind(_s58)
	J.sp(_t145, "renderTarget", _t161)
	_s58["ohud"] = J.gp(J.G.get("Scare"), "hud")
	var _t162 = J.G.get("Scare")
	var _t166 = Callable(self, "_f44").bind(_s58)
	J.sp(_t162, "hud", _t166)

func _f2(this_, a: Array, env):
	var v_yue_23 = null; var v_zh_24 = null
	v_yue_23 = J.arg(a, 0)
	v_zh_24 = J.arg(a, 1)
	if (not J.seq(J.typeof_(J.G.get("LANG")), "undefined")):
		J.mc(J.G.get("LANG"), "add", [{J.key(v_yue_23): v_zh_24}])
	return v_yue_23

func _f3(this_, a: Array, env):
	var v_s_25 = null
	v_s_25 = J.arg(a, 0)
	var _t168 = null
	if J.seq(J.typeof_(J.G.get("L")), "function"):
		var _t167 = J.G.get("L")
		_t168 = J.cl(_t167, null, [v_s_25])
	else:
		_t168 = v_s_25
	return _t168

func _f4(this_, a: Array, env):
	var v_Sc_26 = null; var v_k_27 = null
	v_Sc_26 = J.arg(a, 0)
	v_k_27 = J.arg(a, 1)
	var _t169 = J.gp(v_Sc_26, "_intel")
	var _t170 = (_t169 if J.t(_t169) else {})
	J.sp(v_Sc_26, "_intel", _t170)
	var _t171 = J.gp(v_Sc_26, "_intel")
	var _t172 = J.gp(J.gp(v_Sc_26, "_intel"), v_k_27)
	var _t173 = (_t172 if J.t(_t172) else J.new_("Set", []))
	J.sp(_t171, v_k_27, _t173)
	return _t173

func _f5(this_, a: Array, env):
	var v_Sc_28 = null; var v_n_29 = null; var v_id_30 = null
	v_Sc_28 = J.arg(a, 0)
	v_n_29 = J.arg(a, 1)
	v_id_30 = J.arg(a, 2)
	var _t174 = J.gp(v_Sc_28, "_opcd")
	var _t175 = (_t174 if J.t(_t174) else {})
	J.sp(v_Sc_28, "_opcd", _t175)
	var _t176 = J.gp(J.gp(v_Sc_28, "_opcd"), J.add(J.gp(J.gp(v_n_29, "d"), "k"), v_id_30))
	var _t177 = J.gp(J.gp(v_Sc_28, "_opcd"), J.add(J.gp(J.gp(v_n_29, "d"), "k"), v_id_30))
	return J.max_([0.0, J.sub((_t177 if J.t(_t177) else 0.0), J.gp(v_Sc_28, "t"))])

func _f45(this_, a: Array, env):
	var v_boot_154 = null; var v_e_155 = null
	v_boot_154 = Callable(self, "_f45").bind(env)
	var _t178 = J.seq(J.typeof_(J.G.get("Scare")), "undefined")
	if (_t178 if _t178 else (not J.t(J.gp(J.G.get("Scare"), "renderTarget")))):
		J.F_setTimeout([v_boot_154, 200.0])
		return null
	J.cl(env["init"], null, [])

func _f1(this_, a: Array, env):
	var v_D_2 = null
	var _s2 = {"__p": env, "Lx": null, "CD": null, "OPS": null, "PANTRY": null, "TAB": null, "INTEL_NAME": null, "intel": null, "cdOf": null, "ctx": null, "buttons": null, "modal": null, "close": null, "openPhone": null, "optRow": null, "compose": null, "openPC": null, "openPantry": null, "bindOps": null, "act": null, "init": null}
	_s2["ctx"] = Callable(self, "_f6").bind(_s2)
	_s2["buttons"] = Callable(self, "_f7").bind(_s2)
	_s2["modal"] = Callable(self, "_f8").bind(_s2)
	_s2["close"] = Callable(self, "_f11").bind(_s2)
	_s2["openPhone"] = Callable(self, "_f12").bind(_s2)
	_s2["optRow"] = Callable(self, "_f24").bind(_s2)
	_s2["compose"] = Callable(self, "_f25").bind(_s2)
	_s2["openPC"] = Callable(self, "_f28").bind(_s2)
	_s2["openPantry"] = Callable(self, "_f31").bind(_s2)
	_s2["bindOps"] = Callable(self, "_f33").bind(_s2)
	_s2["act"] = Callable(self, "_f37").bind(_s2)
	_s2["init"] = Callable(self, "_f39").bind(_s2)
	v_D_2 = Callable(self, "_f2").bind(_s2)
	_s2["Lx"] = Callable(self, "_f3").bind(_s2)
	_s2["CD"] = 25.0
	_s2["OPS"] = {"ken": {"apps": {"msg": [{"title": "老闆", "items": [["老闆", "23:02", "阿Ken，明早九點董事會，PPT 再改一版。"], ["阿Ken", "23:03", "好的老闆，收到。"], ["老闆", "01:40", "在嗎？"], ["阿Ken", "01:40", "在！"]]}, {"title": "阿福哥", "intel": "afu", "items": [["阿福哥", "三個月前", "今晚又 OT，你先走吧，我幫你頂。"], ["阿Ken", "三個月前", "阿福哥，你都早點走。"], ["阿福哥", "三個月前", "做完這份就走。"], ["", "", "（之後再沒有訊息）"]]}, {"title": "家庭群組", "intel": "mom", "items": [["媽", "昨天", "阿Ken，這個禮拜回來吃飯嗎？媽煲了湯。"], ["阿Ken", "昨天", "下次吧，最近很忙"], ["爸", "昨天", "（貼圖：一碗湯）"], ["媽", "今天", "湯還在。"]]}], "photo": ["董事會PPT_第23版（截圖）", "公司樓下的雲吞麵（第 31 次）", "阿福哥的生日蛋糕（三個月前，辦公室）", "媽煲的湯（媽傳來的）"], "search": [["辭職信 範本 禮貌", "quit"], ["老闆半夜發訊息 違法嗎", ""], ["PPT 字體 老闆說不夠專業", ""], ["回家 機票 便宜", "mom"]], "note": ["PPT 改：", "1. logo 放大", "2. logo 縮回原本大小", "3. 改回第一版", "4. ？？？"]}, "msgs": [{"id": "k1", "who": "陌生號碼", "text": "你後面那張椅子，是誰坐著？", "type": "phone", "tier": 1.0, "base": 22.0, "cost": 18.0}, {"id": "k2", "who": "老闆", "text": "在嗎？", "type": "phone", "tier": 1.0, "base": 26.0, "cost": 16.0, "say": J.cl(v_D_2, null, ["（條件反射彈起身）在！我在！", "（條件反射彈起身）在！我在！"])}, {"id": "k3", "who": "阿Ken（他自己）", "text": "（一張相：他現在的背影，從他身後拍的）", "type": "phone", "tier": 3.0, "base": 34.0, "cost": 28.0}, {"id": "k4", "who": "阿福哥", "need": "afu", "text": "今晚又 OT？你都早點走。", "type": "face", "tier": 3.0, "base": 40.0, "cost": 30.0, "say": J.cl(v_D_2, null, ["阿……阿福哥？你個號碼……仲用緊？", "阿……阿福哥？你的號碼……還在用？"])}, {"id": "k5", "who": "媽", "need": "mom", "text": "阿Ken，湯凍了。媽在你後面。", "type": "phone", "tier": 3.0, "base": 38.0, "cost": 26.0, "say": J.cl(v_D_2, null, ["媽？你……你喺邊？", "媽？你……你在哪裡？"])}, {"id": "k6", "who": "人事部", "need": "quit", "text": "你的辭職信已收到，即日生效，不用再回來。", "trap": true, "cost": 16.0, "say": J.cl(v_D_2, null, ["（偷偷笑咗出嚟）真係……真係得咗？", "（偷偷笑了出來）真的……真的可以？"]), "why": "他太開心，反而一點都不怕了"}], "pc": {"title": "董事會簡報_最終版_v23_真最終.pptx", "lines": ["第 1 頁：本季業績（陳總要求：要好睇）", "第 2 頁：增長 3%（陳總要求：改成 30%）", "第 3 頁：謝謝（陳總要求：字大啲）", "自動儲存：關閉"], "ops": [{"id": "kp1", "text": "拔電線（他還沒儲存）", "type": "paper", "tier": 1.0, "base": 24.0, "cost": 20.0, "say": J.cl(v_D_2, null, ["我未 save 呀！！第 23 版呀！！", "我還沒存檔啊！！第 23 版啊！！"])}, {"id": "kp2", "text": "把每一頁的標題改成「救我」", "type": "paper", "tier": 3.0, "base": 38.0, "cost": 30.0, "say": J.cl(v_D_2, null, ["邊……邊個改咗我啲 slide？！", "誰……誰改了我的投影片？！"])}, {"id": "kp3", "text": "用他的帳號寄電郵給陳總：「我不幹了」", "type": "paper", "tier": 3.0, "base": 36.0, "cost": 28.0, "say": J.cl(v_D_2, null, ["唔係我寄㗎！撤回！點撤回呀？！", "不是我寄的！收回！怎麼收回？！"])}, {"id": "kp4", "text": "打開視像鏡頭：畫面裡他身後多了一個人", "type": "face", "tier": 3.0, "base": 40.0, "cost": 32.0}, {"id": "kp5", "text": "桌布換成阿福哥的員工證", "type": "face", "tier": 1.0, "base": 24.0, "cost": 20.0, "say": J.cl(v_D_2, null, ["……阿福哥張工作證，點解會喺度？", "……阿福哥的員工證，怎麼會在這裡？"])}]}}, "it": {"apps": {"msg": [{"title": "值班系統", "items": [["值班系統", "01:12", "【P1】23 樓伺服器溫度 4°C，請立即處理。"], ["值班系統", "01:13", "【P1】溫度 2°C。"], ["值班系統", "01:14", "【P1】溫度 -1°C。伺服器室有人呼吸。"]]}, {"title": "二十三樓八卦群", "intel": "gossip", "items": [["阿Ken", "00:30", "聽說 23 樓半夜影印機會自己印東西"], ["小晴", "00:31", "是驅動程式的問題，不要迷信。"], ["美美", "00:32", "小晴你最膽小，上次停電你叫得最大聲"], ["小晴", "00:32", "那是 UPS 響！不是我！"]]}, {"title": "珍奶店", "intel": "boba", "items": [["珍奶店", "22:58", "您的訂單：全糖、多珍珠、去冰（第 3 杯）已送達。"], ["珍奶店", "23:59", "感謝您本月第 41 杯！您已成為鑽石會員。"]]}, {"title": "媽", "items": [["媽", "23:40", "妹，又值夜班？記得吃飯。"], ["小晴", "23:41", "有啦，珍奶算一餐。"]]}], "photo": ["珍奶 ×47", "伺服器機櫃（自拍）", "停電那晚的監控截圖（角落有一團白色）"], "search": [["伺服器 溫度 突然 4度 原因", ""], ["23樓 影印機 半夜 自己印", "gossip"], ["珍奶 一日 幾杯 太多", "boba"], ["UPS 響 聲音 像人叫", "gossip"]], "note": ["root 密碼：不要寫在這裡", "值班表：我、我、我、我"]}, "msgs": [{"id": "i1", "who": "值班系統", "text": "【P0】伺服器室有人登入。用戶名：AFU", "type": "phone", "tier": 1.0, "base": 24.0, "cost": 18.0, "say": J.cl(v_D_2, null, ["AFU？我哋公司冇呢個 user……", "AFU？我們公司沒有這個帳號……"])}, {"id": "i2", "who": "陌生號碼", "text": "（語音訊息，只有呼吸聲。她戴著耳機。）", "type": "sound", "tier": 3.0, "base": 36.0, "cost": 28.0}, {"id": "i3", "who": "珍奶店", "need": "boba", "text": "您的第 4 杯已送達。送貨員說：放在您後面了。", "type": "phone", "tier": 3.0, "base": 40.0, "cost": 28.0, "say": J.cl(v_D_2, null, ["我……我冇叫第四杯……", "我……我沒叫第四杯……"])}, {"id": "i4", "who": "美美", "need": "gossip", "text": "小晴你又在公司？UPS 又響了，你聽到嗎？", "type": "sound", "tier": 1.0, "base": 26.0, "cost": 18.0, "say": J.cl(v_D_2, null, ["UPS……今晚冇響呀……", "UPS……今晚沒響啊……"])}, {"id": "i5", "who": "陳總", "text": "小晴，網站是不是慢了？", "trap": true, "cost": 14.0, "say": J.cl(v_D_2, null, ["（反白眼）陳總，係你屋企 Wi-Fi。", "（翻白眼）陳總，是你家的 Wi-Fi。"]), "why": "她只覺得煩，完全清醒了"}], "pc": {"title": "終端機 — server-23f.log", "lines": ["01:12  WARN  temp 4°C", "01:13  WARN  temp 2°C", "01:14  INFO  user login: ???", "01:14  INFO  door 23F-server opened"], "ops": [{"id": "ip1", "text": "拔伺服器電源：全層警報大響", "type": "sound", "tier": 1.0, "base": 24.0, "cost": 20.0, "say": J.cl(v_D_2, null, ["production 跌咗？！唔好呀！", "production 掛了？！不要啊！"])}, {"id": "ip2", "text": "把 log 每一行改成「小晴你好」", "type": "light", "tier": 3.0, "base": 38.0, "cost": 30.0, "say": J.cl(v_D_2, null, ["呢個唔係 bug……呢個唔係 bug……", "這不是 bug……這不是 bug……"])}, {"id": "ip3", "text": "遠端控制：游標自己動，慢慢打出「我好凍」", "type": "light", "tier": 3.0, "base": 40.0, "cost": 32.0}, {"id": "ip4", "text": "在她耳機播：「小晴……還在嗎……」", "type": "sound", "tier": 3.0, "base": 40.0, "cost": 32.0}, {"id": "ip5", "text": "把她電腦的冷氣控制調到 16°C", "type": "cold", "tier": 1.0, "base": 20.0, "cost": 16.0}]}}, "mis": {"apps": {"msg": [{"title": "陳總", "intel": "boss", "items": [["陳總", "00:45", "美美，明天陪我去見客，記得穿漂亮點。"], ["美美", "00:46", "陳總～人家要放假啦～"], ["陳總", "00:46", "放！做完這季就放！"]]}, {"title": "姊妹群", "items": [["姊妹", "01:02", "你還在公司？"], ["美美", "01:03", "是呀，陳總說他一個人怕 🙄"], ["姊妹", "01:04", "你們 23 樓不是有那個傳說嗎"]]}, {"title": "阿Ken", "items": [["美美", "01:20", "阿Ken，那份報告你幫我打完吧，陳總要的。"], ["阿Ken", "01:21", "……好。"]]}], "photo": ["自拍 #382（今晚，辦公室）", "自拍 #383（今晚，辦公室，背景有點模糊）", "自拍 #384（她刪了）", "日本機票（已收藏）"], "search": [["甩妝 急救 方法", ""], ["日本 購物 壓驚", ""], ["自拍 背景 多了一個人", "selfie"]], "note": ["IG 文案：今晚又陪老闆加班～ #努力", "要阿Ken做：報告、PPT、陳總的生日卡"], "intelPhoto": "selfie"}, "msgs": [{"id": "m1", "who": "Instagram", "need": "selfie", "text": "有人在你最新的自拍留言：「你後面那位是誰？」", "type": "phone", "tier": 3.0, "base": 40.0, "cost": 28.0, "say": J.cl(v_D_2, null, ["我後面……冇人㗎……", "我後面……沒有人啊……"])}, {"id": "m2", "who": "陳總", "need": "boss", "text": "美美，進來我房。", "type": "phone", "tier": 1.0, "base": 24.0, "cost": 16.0, "say": J.cl(v_D_2, null, ["嚟緊喇陳總～……咦，陳總唔係出咗去咩？", "來了陳總～……咦，陳總不是出去了嗎？"])}, {"id": "m3", "who": "姊妹群", "text": "你還在公司？你後面那個……", "type": "phone", "tier": 1.0, "base": 22.0, "cost": 16.0}, {"id": "m4", "who": "（前鏡頭自己打開）", "text": "自拍畫面裡，她肩膀上多了一隻手", "type": "breath", "tier": 3.0, "base": 38.0, "cost": 30.0}, {"id": "m5", "who": "網購", "text": "您訂購的「防甩妝噴霧 ×6」已送達：二十三樓，阿福的座位。", "type": "phone", "tier": 1.0, "base": 22.0, "cost": 16.0, "say": J.cl(v_D_2, null, ["阿福……係邊個？", "阿福……是誰？"])}]}, "boss": {"apps": {"msg": [{"title": "Master Lee", "intel": "master", "items": [["Master Lee", "昨天", "陳總，你這層樓陰氣很重，水晶球記得對著窗口。"], ["Master Lee", "昨天", "還有，千萬不要讓影印機半夜自己開。"], ["陳總", "昨天", "收到大師！轉帳了。"]]}, {"title": "美美", "items": [["陳總", "00:45", "美美，明天陪我去見客，記得穿漂亮點。"], ["美美", "00:46", "陳總～人家要放假啦～"]]}, {"title": "董事會", "intel": "board", "items": [["董事會秘書", "20:00", "提醒：明早九點董事會，請準備本季業績。"], ["陳總", "20:01", "沒問題，業績很好。"]]}], "photo": ["水晶球（對著窗口）", "高爾夫一桿進洞（其實是別人的）", "本季虧損報表（截圖，標題：不要給董事會看）"], "search": [["水晶球 擺放 位置 辦公室", "master"], ["虧損 怎樣 不讓董事會知道", "board"], ["Master Lee 電話", "master"]], "note": ["明天：叫阿Ken 改 PPT", "後天：叫阿Ken 再改 PPT", "叫 Master Lee 來看風水（又）"]}, "msgs": [{"id": "b1", "who": "陌生號碼", "text": "陳總，你後面有人。", "type": "phone", "tier": 1.0, "base": 22.0, "cost": 14.0}, {"id": "b2", "who": "Master Lee", "need": "master", "text": "陳總，我看到你房裡有個黑影站在水晶球後面。", "type": "shadow", "tier": 3.0, "base": 40.0, "cost": 30.0, "say": J.cl(v_D_2, null, ["大師！你點睇到㗎？！你喺邊呀？！", "大師！你怎麼看得到？！你在哪裡？！"])}, {"id": "b3", "who": "Master Lee", "need": "master", "text": "影印機開了沒有？開了就快走。", "type": "paper", "tier": 1.0, "base": 26.0, "cost": 18.0, "say": J.cl(v_D_2, null, ["（望住影印機）……佢未開。佢未開，係咪？", "（盯著影印機）……它沒開。它沒開，對吧？"])}, {"id": "b4", "who": "董事會秘書", "need": "board", "text": "通知：董事會改為今晚三點，地點：二十三樓，陳總的房。", "type": "paper", "tier": 3.0, "base": 36.0, "cost": 28.0, "say": J.cl(v_D_2, null, ["今晚？！我份數未整靚呀！", "今晚？！我的數字還沒整理好！"])}], "pc": {"title": "高爾夫教學影片（全螢幕）", "lines": ["（背景開著：本季虧損報表.xlsx）", "（另一個分頁：Master Lee 開運水晶網購）"], "ops": [{"id": "bp1", "text": "把虧損報表切到全螢幕", "type": "paper", "tier": 3.0, "base": 38.0, "cost": 30.0, "say": J.cl(v_D_2, null, ["邊個開咗呢份嘢出嚟？！", "誰把這份東西打開了？！"])}, {"id": "bp2", "text": "自動把虧損報表寄給董事會", "type": "paper", "tier": 3.0, "base": 42.0, "cost": 34.0, "say": J.cl(v_D_2, null, ["唔好寄！唔好寄呀！！", "不要寄！不要寄啊！！"])}, {"id": "bp3", "text": "影片裡的球童慢慢轉頭，望著他", "type": "shadow", "tier": 1.0, "base": 26.0, "cost": 20.0}, {"id": "bp4", "text": "拔電線：螢幕黑了，反光裡多了一個影", "type": "shadow", "tier": 3.0, "base": 36.0, "cost": 28.0}]}}, "auntie": {"apps": {"msg": [{"title": "兒子", "intel": "son", "items": [["兒子", "22:30", "媽，又做到幾點？"], ["清潔安娣", "22:31", "做完就回。你先吃，不用等。"], ["兒子", "22:32", "我買了你最愛的雞飯，放在桌上。"]]}, {"title": "老闆娘", "items": [["老闆娘", "20:00", "安娣，今晚地板要拖三次，陳總說要亮。"], ["清潔安娣", "20:01", "好。"]]}], "photo": ["孫子的生日（去年）", "地板（拖完，很亮）"], "search": [["雞飯 外賣", "son"], ["膝蓋 痛 拖地", ""]], "note": ["23 樓：拖三次", "22 樓：不用拖（說那層有東西）"]}, "msgs": [{"id": "a1", "who": "陌生號碼", "text": "剛拖完的地，又有腳印了。", "type": "face", "tier": 1.0, "base": 22.0, "cost": 16.0, "say": J.cl(v_D_2, null, ["邊個踩我啲地？！", "誰踩我的地？！"])}, {"id": "a2", "who": "兒子", "need": "son", "text": "媽，早點回來，雞飯凍了。", "warm": true, "cost": 10.0, "say": J.cl(v_D_2, null, ["（望住手機笑咗一笑）……好，拖埋呢間就走。", "（看著手機笑了笑）……好，拖完這間就走。"]), "why": "她沒有被嚇到，但今晚會早點回家"}]}, "guard": {"apps": {"msg": [{"title": "阿福", "intel": "afu", "items": [["阿福", "三個月前", "阿伯，我又加班，今晚不用幫我留燈。"], ["保安阿伯", "三個月前", "留咯。你走了我才關。"]]}, {"title": "女兒", "items": [["女兒", "今天", "爸，今晚幾點下班？"], ["保安阿伯", "今天", "天亮。"], ["保安阿伯", "今天", "那個阿Ken，跟阿福一樣，都不回家。"]]}], "photo": ["23 樓的燈（三個月前，很晚，還亮著）"], "search": [["怎樣叫年輕人早點回家", ""]], "note": ["23 樓的燈：等阿Ken 走了才關"]}, "msgs": []}}
	_s2["PANTRY"] = [{"id": "p1", "text": "販賣機自己「哐咚」掉出一罐汽水，滾到他腳邊", "type": "sound", "tier": 1.0, "base": 24.0, "cost": 18.0, "fx": "vend"}, {"id": "p2", "text": "販賣機玻璃後面黑影一閃，一包零食自己掉了出來", "type": "shadow", "tier": 2.0, "base": 30.0, "cost": 22.0, "fx": "snack"}, {"id": "p3", "text": "雪櫃門自己開了又關、關了又開，冷氣一陣一陣湧出來", "type": "cold", "tier": 1.0, "base": 22.0, "cost": 16.0, "fx": "fridgeloop"}, {"id": "p4", "text": "水機自己漏水，一滴一滴，地上積了一灘冰水", "type": "cold", "tier": 2.0, "base": 28.0, "cost": 20.0, "fx": "water"}, {"id": "p5", "text": "咖啡機自己沖了一杯咖啡，熱氣呼到他臉上", "type": "breath", "tier": 2.0, "base": 30.0, "cost": 22.0, "fx": "coffee"}, {"id": "p6", "text": "微波爐自己轉起來「叮」一聲，門後貼著一張臉", "type": "face", "tier": 3.0, "base": 38.0, "cost": 30.0, "fx": "micro"}, {"id": "p7", "text": "熱水壺咕嚕咕嚕，好像在說：「好凍……」", "type": "sound", "tier": 1.0, "base": 20.0, "cost": 14.0, "fx": "kettle"}, {"id": "p8", "text": "茶水間的燈一閃一閃", "type": "light", "tier": 1.0, "base": 22.0, "cost": 16.0, "fx": "lights"}]
	_s2["TAB"] = {"msg": "訊息", "photo": "相簿", "search": "搜尋紀錄", "note": "備忘錄"}
	_s2["INTEL_NAME"] = {"afu": "阿福哥的舊訊息", "mom": "媽媽的湯", "quit": "他想辭職", "gossip": "八卦群的傳聞", "boba": "珍奶店訂單", "selfie": "自拍裡的模糊人影", "boss": "陳總的訊息", "master": "Master Lee 的叮囑", "board": "董事會", "son": "兒子的雞飯"}
	_s2["intel"] = Callable(self, "_f4").bind(_s2)
	_s2["cdOf"] = Callable(self, "_f5").bind(_s2)
	J.cl(Callable(self, "_f45").bind(_s2), null, [])
	return {"OPS": _s2["OPS"], "PANTRY": _s2["PANTRY"], "ctx": _s2["ctx"], "openPhone": _s2["openPhone"], "openPC": _s2["openPC"], "openPantry": _s2["openPantry"], "compose": _s2["compose"], "act": _s2["act"], "intel": _s2["intel"]}
