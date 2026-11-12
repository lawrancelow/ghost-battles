# 自動轉譯自 world.js（tools/jsgd.js）——唔好直接改，改原 JS 再轉
extends RefCounted

func run(env):
	var this_ = null; var a = []
	J.G["World"] = {"YARD_READY": true, "SPOTS": [{"id": "battle", "x": 0.2, "y": 0.68, "lx": 0.25, "ly": 0.745, "name": "搶地盤", "sub": "陽間地盤", "go": Callable(self, "_f1").bind(env)}, {"id": "yard", "x": 0.76, "y": 0.7, "lx": 0.79, "ly": 0.745, "name": "亂葬崗", "sub": "無名墳", "go": Callable(self, "_f2").bind(env), "ready": Callable(self, "_f3").bind(env)}, {"id": "street", "x": 0.22, "y": 0.53, "lx": 0.25, "ly": 0.565, "name": "冥街夜市", "sub": "下班後的陰間", "go": Callable(self, "_f4").bind(env), "ready": Callable(self, "_f5").bind(env)}, {"id": "station", "x": 0.8, "y": 0.52, "lx": 0.735, "ly": 0.555, "name": "陽間站崗", "sub": "派鬼嚇路人", "go": Callable(self, "_f6").bind(env), "ready": Callable(self, "_f7").bind(env), "need": Callable(self, "_f8").bind(env), "lock": "打完第一章才開放"}, {"id": "scare", "x": 0.5, "y": 0.4, "lx": 0.5, "ly": 0.47, "name": "回陽間", "sub": "夜班嚇人", "go": Callable(self, "_f9").bind(env), "need": Callable(self, "_f10").bind(env), "lock": "打完第一章才開放"}, {"id": "tower", "x": 0.22, "y": 0.24, "lx": 0.23, "ly": 0.325, "name": "樓裡有鬼", "sub": "揀一棟樓嚇到天光", "go": Callable(self, "_f11").bind(env), "ready": Callable(self, "_f12").bind(env), "need": Callable(self, "_f13").bind(env), "lock": "打完第一章才開放"}], "RESERVED": 3.0, "ICON": {"battle": "戰", "yard": "墳", "street": "市", "scare": "嚇", "station": "崗"}, "DESC": {"battle": "帶鬼出陣，同陽間各路人馬爭地盤。", "yard": "無名墳一排排，聽清楚邊個講大話。", "street": "收工後嘅陰間夜市，食嘢、行街、見老友。", "station": "喺陽間地盤擺鬼站崗，嚇走路過嘅人。", "scare": "返去陽間返夜班，一間間辦公室嚇過去。", "tower": "揀一棟樓，由地下嚇到天台，天光前返陰間。"}, "RES_SPOTS": [{"x": 0.78, "y": 0.27, "lx": 0.8, "ly": 0.325}, {"x": 0.5, "y": 0.06, "lx": 0.5, "ly": 0.135}, {"x": 0.15, "y": 0.07, "lx": 0.15, "ly": 0.135}], "open": Callable(self, "_f14").bind(env), "close": Callable(self, "_f31").bind(env)}

func _f1(this_, a: Array, env):
	return J.mc(J.G.get("UI"), "open", ["battle"])

func _f2(this_, a: Array, env):
	return J.mc(J.G.get("Graveyard"), "open", [])

func _f3(this_, a: Array, env):
	var _t1 = (not J.seq(J.typeof_(J.G.get("Graveyard")), "undefined"))
	return (J.gp(J.G.get("World"), "YARD_READY") if _t1 else _t1)

func _f4(this_, a: Array, env):
	return J.mc(J.G.get("GhostStreet"), "open", [])

func _f5(this_, a: Array, env):
	return (not J.seq(J.typeof_(J.G.get("GhostStreet")), "undefined"))

func _f6(this_, a: Array, env):
	return J.mc(J.G.get("Street"), "open", [])

func _f7(this_, a: Array, env):
	return (not J.seq(J.typeof_(J.G.get("Street")), "undefined"))

func _f8(this_, a: Array, env):
	var _t2 = J.gp(J.gp(J.G.get("S"), "seen"), "ch1_end")
	return (_t2 if J.t(_t2) else J.gp(J.G.get("window"), "STN_TEST"))

func _f9(this_, a: Array, env):
	return J.mc(J.G.get("Scare"), "open", ["office"])

func _f10(this_, a: Array, env):
	return J.gp(J.gp(J.G.get("S"), "seen"), "ch1_end")

func _f11(this_, a: Array, env):
	return J.mc(J.G.get("Tower"), "open", [])

func _f12(this_, a: Array, env):
	return (not J.seq(J.typeof_(J.G.get("Tower")), "undefined"))

func _f13(this_, a: Array, env):
	var _t3 = J.gp(J.gp(J.G.get("S"), "seen"), "ch1_end")
	return (_t3 if J.t(_t3) else J.gp(J.G.get("window"), "STN_TEST"))

func _f15(this_, a: Array, env):
	var v_e_11 = null
	v_e_11 = J.arg(a, 0)
	return J.mc(v_e_11, "remove", [])

func _f16(this_, a: Array, env):
	var v_r_16 = null; var v_i_17 = null
	v_r_16 = J.arg(a, 0)
	v_i_17 = J.arg(a, 1)
	var _t22 = J.add(env["h"], ("<i class=\"wm-fog\" style=\"left:" + J.str(J.mul(J.gp(v_r_16, "x"), 100.0)) + "%;top:" + J.str(J.mul(J.gp(v_r_16, "y"), 100.0)) + "%\"></i>"))
	env["h"] = _t22
	var _t23 = J.add(env["h"], ("<button class=\"wm-card wm-tag res\" data-res=\"1\" style=\"left:" + J.str(J.mul(J.gp(v_r_16, "lx"), 100.0)) + "%;top:" + J.str(J.mul(J.gp(v_r_16, "ly"), 100.0)) + "%\"><b>保留地</b><small>濃霧未散</small></button>"))
	env["h"] = _t23

func _f17(this_, a: Array, env):
	return (J.sub(J.S_performance_("now", []), env["t0"]) < 450.0)

func _f19(this_, a: Array, env):
	var v_x_20 = null
	v_x_20 = J.arg(a, 0)
	return J.seq(J.gp(v_x_20, "id"), J.gp(J.gp(env["b"], "dataset"), "id"))

func _f18(this_, a: Array, env):
	var v_s_19 = null
	var _s22 = {"__p": env, "b": null}
	_s22["b"] = J.arg(a, 0)
	if J.t(J.cl(_s22["__p"]["ghost"], null, [])):
		return null
	if J.t(J.gp(J.gp(_s22["b"], "dataset"), "res")):
		J.mc(J.G.get("Fx"), "toast", ["呢塊地仲俾濃霧封住，遲啲再嚟"])
		return null
	var _t29 = J.gp(_s22["__p"]["this"], "SPOTS")
	v_s_19 = J.mc(_t29, "find", [Callable(self, "_f19").bind(_s22)])
	var _t30 = J.gp(_s22["b"], "classList")
	if J.t(J.mc(_t30, "contains", ["off"])):
		var _t31 = J.gp(v_s_19, "ready")
		var _t33 = null
		if J.t(((not J.t(J.mc(v_s_19, "ready", []))) if J.t(_t31) else _t31)):
			_t33 = (J.str(J.gp(v_s_19, "name")) + "還在施工，快好了")
		else:
			var _t32 = J.gp(v_s_19, "lock")
			_t33 = (_t32 if J.t(_t32) else "")
		J.mc(J.G.get("Fx"), "toast", [_t33])
		return null
	J.mc(_s22["__p"]["this"], "close", [])
	if (not J.seq(J.typeof_(J.G.get("Guide")), "undefined")):
		J.mc(J.G.get("Guide"), "visit", [J.gp(v_s_19, "id")])
	J.mc(v_s_19, "go", [])

func _f21(this_, a: Array, env):
	var v_x_26 = null
	v_x_26 = J.arg(a, 0)
	var _t38 = J.gp(v_x_26, "classList")
	return J.mc(_t38, "remove", ["sel"])

func _f22(this_, a: Array, env):
	var v_x_27 = null
	v_x_27 = J.arg(a, 0)
	return J.seq(J.gp(v_x_27, "id"), J.gp(J.gp(env["b"], "dataset"), "id"))

func _f23(this_, a: Array, env):
	var _t54 = env["__p"]["go"]
	return J.cl(_t54, null, [env["b"]])

func _f20(this_, a: Array, env):
	var v_info_22 = null; var v_s_23 = null; var v_off_24 = null; var v_g_25 = null
	var _s26 = {"__p": env, "b": null}
	_s26["b"] = J.arg(a, 0)
	var _t34 = J.cl(_s26["__p"]["ghost"], null, [])
	if J.t((_t34 if J.t(_t34) else (not J.t(_s26["b"])))):
		return null
	var _t35 = J.gp(_s26["b"], "classList")
	if J.t(J.mc(_t35, "contains", ["sel"])):
		var _t36 = _s26["__p"]["go"]
		J.cl(_t36, null, [_s26["b"]])
		return null
	var _t37 = J.mc(_s26["__p"]["el"], "querySelectorAll", [".wm-tag.sel"])
	J.mc(_t37, "forEach", [Callable(self, "_f21").bind(_s26)])
	var _t39 = J.gp(_s26["b"], "classList")
	J.mc(_t39, "add", ["sel"])
	if J.t(J.gp(J.G.get("Sound"), "play")):
		J.mc(J.G.get("Sound"), "play", ["click"])
	var _t40 = J.G.get("$")
	v_info_22 = J.cl(_t40, null, ["#wm-info"])
	if J.t(J.gp(J.gp(_s26["b"], "dataset"), "res")):
		var _t41 = ("<b>保留地</b><p>呢度仲俾濃霧封住。總部話遲啲會開發，敬請期待。</p>")
		J.sp(v_info_22, "innerHTML", _t41)
		return null
	var _t42 = J.gp(_s26["__p"]["this"], "SPOTS")
	v_s_23 = J.mc(_t42, "find", [Callable(self, "_f22").bind(_s26)])
	var _t43 = J.gp(_s26["b"], "classList")
	v_off_24 = J.mc(_t43, "contains", ["off"])
	var _t45 = J.gp(v_s_23, "name")
	var _t46 = J.gp(v_s_23, "sub")
	var _t44 = J.gp(J.gp(_s26["__p"]["this"], "DESC"), J.gp(v_s_23, "id"))
	var _t51 = (_t44 if J.t(_t44) else "")
	var _t50 = null
	if J.t(v_off_24):
		var _t47 = J.gp(v_s_23, "ready")
		var _t49 = null
		if J.t(((not J.t(J.mc(v_s_23, "ready", []))) if J.t(_t47) else _t47)):
			_t49 = "施工中"
		else:
			var _t48 = J.gp(v_s_23, "lock")
			_t49 = (_t48 if J.t(_t48) else "")
		_t50 = ("<div class=\"wm-lock\">🔒 " + J.str(_t49) + "</div>")
	else:
		_t50 = ("<button class=\"wm-go\" id=\"wm-go\">出發 ▶</button>")
	var _t52 = ("<b>" + J.str(_t45) + "</b><small>" + J.str(_t46) + "</small><p>" + J.str(_t51) + "</p>" + _t50)
	J.sp(v_info_22, "innerHTML", _t52)
	var _t53 = J.G.get("$")
	v_g_25 = J.cl(_t53, null, ["#wm-go"])
	if J.t(v_g_25):
		var _t55 = Callable(self, "_f23").bind(_s26)
		J.sp(v_g_25, "onclick", _t55)

func _f25(this_, a: Array, env):
	var _t58 = env["__p"]["pick"]
	return J.cl(_t58, null, [env["b"]])

func _f24(this_, a: Array, env):
	var _s32 = {"__p": env, "b": null}
	_s32["b"] = J.arg(a, 0)
	var _t57 = _s32["b"]
	var _t59 = Callable(self, "_f25").bind(_s32)
	J.sp(_t57, "onclick", _t59)
	return _t59

func _f27(this_, a: Array, env):
	var _t62 = env["__p"]["pick"]
	return J.cl(_t62, null, [J.mc(env["__p"]["el"], "querySelector", [(".wm-card[data-id=\"" + J.str(J.gp(J.gp(env["b"], "dataset"), "for")) + "\"]")])])

func _f26(this_, a: Array, env):
	var _s34 = {"__p": env, "b": null}
	_s34["b"] = J.arg(a, 0)
	var _t61 = _s34["b"]
	var _t63 = Callable(self, "_f27").bind(_s34)
	J.sp(_t61, "onclick", _t63)
	return _t63

func _f28(this_, a: Array, env):
	if (not J.t(J.cl(env["ghost"], null, []))):
		J.mc(env["this"], "close", [])

func _f29(this_, a: Array, env):
	if (not J.t(J.cl(env["ghost"], null, []))):
		J.mc(env["this"], "close", [])

func _f30(this_, a: Array, env):
	var _t72 = (not J.t(J.cl(env["ghost"], null, [])))
	if J.t((J.gp(J.G.get("window"), "Policy") if _t72 else _t72)):
		J.mc(J.G.get("Policy"), "announce", [])

func _f14(this_, a: Array, env):
	var v_src_5 = null; var v_s_12 = null; var v_ready_13 = null; var v_open_14 = null; var v_dot_15 = null
	var _s15 = {"__p": env, "this": null, "el": null, "h": null, "t0": null, "ghost": null, "go": null, "pick": null}
	_s15["this"] = this_
	var _t4 = J.S_document_("querySelectorAll", ["#pol-tip"])
	J.mc(_t4, "forEach", [Callable(self, "_f15").bind(_s15)])
	var _t5 = J.G.get("$")
	_s15["el"] = J.cl(_t5, null, ["#world"])
	if (not J.t(_s15["el"])):
		var _t6 = J.S_document_("createElement", ["section"])
		_s15["el"] = _t6
		var _t7 = _s15["el"]
		J.sp(_t7, "id", "world")
		var _t8 = J.gp(J.G.get("document"), "body")
		J.mc(_t8, "appendChild", [_s15["el"]])
	var _t10 = (not J.seq(J.typeof_(J.G.get("BG_SRC")), "undefined"))
	if J.t(_t10):
		var _t9 = J.gp(J.G.get("BG_SRC"), "worldmap2")
		_t10 = (_t9 if J.t(_t9) else J.gp(J.G.get("BG_SRC"), "worldmap"))
	var _t12 = null
	if J.t(_t10):
		var _t11 = J.gp(J.G.get("BG_SRC"), "worldmap2")
		_t12 = (_t11 if J.t(_t11) else J.gp(J.G.get("BG_SRC"), "worldmap"))
	else:
		_t12 = ""
	v_src_5 = _t12
	_s15["h"] = ("<div class=\"wm-scroll\"><div class=\"wm-map2\"><img class=\"wm-img\" src=\"" + J.str(v_src_5) + "\" alt=\"\">")
	for _t13 in J.iter(J.gp(_s15["this"], "SPOTS")):
		v_s_12 = _t13
		var _t14 = (not J.t(J.gp(v_s_12, "ready")))
		v_ready_13 = (_t14 if _t14 else J.mc(v_s_12, "ready", []))
		var _t15 = (not J.t(J.gp(v_s_12, "need")))
		v_open_14 = (_t15 if _t15 else J.mc(v_s_12, "need", []))
		var _t16 = (not J.seq(J.typeof_(J.G.get("Guide")), "undefined"))
		v_dot_15 = (J.mc(J.G.get("Guide"), "dot", [J.gp(v_s_12, "id")]) if _t16 else _t16)
		var _t17 = J.add(_s15["h"], ("<i class=\"wm-glow " + ("" if J.t((v_open_14 if J.t(v_ready_13) else v_ready_13)) else "dim") + "\" style=\"left:" + J.str(J.mul(J.gp(v_s_12, "x"), 100.0)) + "%;top:" + J.str(J.mul(J.gp(v_s_12, "y"), 100.0)) + "%\"></i>"))
		_s15["h"] = _t17
		var _t18 = J.add(_s15["h"], ("<button class=\"wm-hit\" data-for=\"" + J.str(J.gp(v_s_12, "id")) + "\" style=\"left:" + J.str(J.mul(J.gp(v_s_12, "x"), 100.0)) + "%;top:" + J.str(J.mul(J.gp(v_s_12, "y"), 100.0)) + "%\" aria-label=\"" + J.str(J.gp(v_s_12, "name")) + "\"></button>"))
		_s15["h"] = _t18
		var _t19 = J.add(_s15["h"], ("<button class=\"wm-card wm-tag " + ("" if J.t((v_open_14 if J.t(v_ready_13) else v_ready_13)) else "off") + " " + ("dot" if J.t(v_dot_15) else "") + "\" data-id=\"" + J.str(J.gp(v_s_12, "id")) + "\" style=\"left:" + J.str(J.mul(J.gp(v_s_12, "lx"), 100.0)) + "%;top:" + J.str(J.mul(J.gp(v_s_12, "ly"), 100.0)) + "%\"><b>" + J.str(J.gp(v_s_12, "name")) + "</b><small>" + J.str(("施工中" if (not J.t(v_ready_13)) else (J.gp(v_s_12, "lock") if (not J.t(v_open_14)) else J.gp(v_s_12, "sub")))) + "</small></button>"))
		_s15["h"] = _t19
	var _t20 = J.gp(_s15["this"], "RES_SPOTS")
	var _t21 = J.mc(_t20, "slice", [0.0, J.gp(_s15["this"], "RESERVED")])
	J.mc(_t21, "forEach", [Callable(self, "_f16").bind(_s15)])
	var _t24 = J.add(_s15["h"], ("<button class=\"wm-tag wm-gate\" id=\"wm-gate\" style=\"left:50%;top:88%\"><b>落魄村</b><small>返村</small></button>"))
	_s15["h"] = _t24
	var _t25 = J.add(_s15["h"], ("</div><div class=\"wm-info\" id=\"wm-info\"><p class=\"wm-hint\">撳地圖上嘅木牌，揀今晚去邊度。</p></div></div><div class=\"wm-top\"><button class=\"wm-home\" id=\"wm-home\">◀ 回村</button><b>陰間地圖</b><span>揀個去處</span><button class=\"wm-pol\" id=\"wm-pol\">📋 新政策</button></div>"))
	_s15["h"] = _t25
	var _t26 = _s15["el"]
	var _t27 = _s15["h"]
	J.sp(_t26, "innerHTML", _t27)
	var _t28 = J.gp(_s15["el"], "classList")
	J.mc(_t28, "add", ["on"])
	if J.t(J.gp(J.G.get("Sound"), "play")):
		J.mc(J.G.get("Sound"), "play", ["click"])
	_s15["t0"] = J.S_performance_("now", [])
	_s15["ghost"] = Callable(self, "_f17").bind(_s15)
	_s15["go"] = Callable(self, "_f18").bind(_s15)
	_s15["pick"] = Callable(self, "_f20").bind(_s15)
	var _t56 = J.mc(_s15["el"], "querySelectorAll", [".wm-card"])
	J.mc(_t56, "forEach", [Callable(self, "_f24").bind(_s15)])
	var _t60 = J.mc(_s15["el"], "querySelectorAll", [".wm-hit"])
	J.mc(_t60, "forEach", [Callable(self, "_f26").bind(_s15)])
	var _t64 = J.G.get("$")
	var _t65 = J.cl(_t64, null, ["#wm-home"])
	var _t66 = Callable(self, "_f28").bind(_s15)
	J.sp(_t65, "onclick", _t66)
	var _t67 = J.G.get("$")
	var _t68 = J.cl(_t67, null, ["#wm-gate"])
	var _t69 = Callable(self, "_f29").bind(_s15)
	J.sp(_t68, "onclick", _t69)
	var _t70 = J.G.get("$")
	var _t71 = J.cl(_t70, null, ["#wm-pol"])
	var _t73 = Callable(self, "_f30").bind(_s15)
	J.sp(_t71, "onclick", _t73)
	if J.t(J.gp(J.G.get("window"), "Policy")):
		J.mc(J.G.get("Policy"), "maybe", [])

func _f31(this_, a: Array, env):
	var v_el_32 = null
	var _t74 = J.G.get("$")
	v_el_32 = J.cl(_t74, null, ["#world"])
	if J.t(v_el_32):
		var _t75 = J.gp(v_el_32, "classList")
		J.mc(_t75, "remove", ["on"])
		J.sp(v_el_32, "innerHTML", "")
	if J.t(J.gp(J.G.get("UI"), "refresh")):
		J.mc(J.G.get("UI"), "refresh", [])
