# 自動轉譯自 guide.js（tools/jsgd.js）——唔好直接改，改原 JS 再轉
extends RefCounted

func run(env):
	var this_ = null; var a = []
	J.G["Guide"] = J.cl(Callable(self, "_f1").bind(env), null, [])

func _f6(this_, a: Array, env):
	var v_pos_23 = null
	v_pos_23 = J.arg(a, 0)
	if J.cmp(env["old"], v_pos_23, ">="):
		env["add"] = J.num(env["add"]) + 1.0

func _f5(this_, a: Array, env):
	var v_fresh_20 = null; var v_s_24 = null
	var _s8 = {"__p": env, "old": null, "add": null}
	v_fresh_20 = J.arg(a, 0)
	if (not J.t(J.gp(J.G.get("S"), "visit"))):
		var _t1 = J.G.get("S")
		var _t2 = {}
		J.sp(_t1, "visit", _t2)
	if (not J.t(J.gp(J.G.get("S"), "wmSeen"))):
		var _t3 = J.G.get("S")
		var _t4 = {}
		J.sp(_t3, "wmSeen", _t4)
	if J.t(v_fresh_20):
		var _t5 = J.G.get("S")
		var _t6 = _s8["__p"]["QV"]
		J.sp(_t5, "qv", _t6)
	var _t7 = J.gp(J.G.get("S"), "qv")
	if J.cmp((_t7 if J.t(_t7) else 1.0), _s8["__p"]["QV"], ">="):
		return null
	_s8["old"] = J.gp(J.G.get("S"), "qi")
	_s8["add"] = 0.0
	J.mc(_s8["__p"]["at"], "forEach", [Callable(self, "_f6").bind(_s8)])
	var _t8 = J.G.get("S")
	var _t9 = J.add(_s8["old"], _s8["add"])
	J.sp(_t8, "qi", _t9)
	var _t10 = J.G.get("S")
	var _t11 = _s8["__p"]["QV"]
	J.sp(_t10, "qv", _t11)
	if (not J.seq(J.typeof_(J.G.get("World")), "undefined")):
		for _t12 in J.iter(J.gp(J.G.get("World"), "SPOTS")):
			v_s_24 = _t12
			var _t13 = _s8["__p"]["open"]
			if J.t(J.cl(_t13, null, [v_s_24])):
				var _t14 = J.gp(J.G.get("S"), "wmSeen")
				var _t15 = J.gp(v_s_24, "id")
				J.sp(_t14, _t15, 1.0)

func _f7(this_, a: Array, env):
	var v_s_27 = null
	v_s_27 = J.arg(a, 0)
	var _t16 = (not J.t(J.gp(v_s_27, "ready")))
	var _t18 = (_t16 if _t16 else J.mc(v_s_27, "ready", []))
	if J.t(_t18):
		var _t17 = (not J.t(J.gp(v_s_27, "need")))
		_t18 = (_t17 if _t17 else J.mc(v_s_27, "need", []))
	return _t18

func _f9(this_, a: Array, env):
	var v_x_32 = null
	v_x_32 = J.arg(a, 0)
	return J.seq(J.gp(v_x_32, "id"), env["id"])

func _f8(this_, a: Array, env):
	var v_s_31 = null
	var _s12 = {"__p": env, "id": null}
	_s12["id"] = J.arg(a, 0)
	if (not J.t(J.gp(J.G.get("S"), "visit"))):
		return false
	var _t19 = J.gp(J.G.get("World"), "SPOTS")
	v_s_31 = J.mc(_t19, "find", [Callable(self, "_f9").bind(_s12)])
	var _t21 = (not (not J.t(v_s_31)))
	if J.t(_t21):
		var _t20 = _s12["__p"]["open"]
		_t21 = (not (not J.t(J.cl(_t20, null, [v_s_31]))))
	var _t23 = ((not J.t(J.gp(J.gp(J.G.get("S"), "visit"), _s12["id"]))) if _t21 else _t21)
	if J.t(_t23):
		var _t22 = J.gp(J.G.get("S"), "wmSeen")
		_t23 = (not J.t(J.gp((_t22 if J.t(_t22) else {}), _s12["id"])))
	return ((not J.seq(_s12["id"], "battle")) if _t23 else _t23)

func _f11(this_, a: Array, env):
	var v_s_35 = null
	v_s_35 = J.arg(a, 0)
	var _t25 = env["dot"]
	return J.cl(_t25, null, [J.gp(v_s_35, "id")])

func _f10(this_, a: Array, env):
	var _t26 = (not J.seq(J.typeof_(J.G.get("World")), "undefined"))
	if J.t(_t26):
		var _t24 = J.gp(J.G.get("World"), "SPOTS")
		_t26 = J.mc(_t24, "some", [Callable(self, "_f11").bind(env)])
	return _t26

func _f12(this_, a: Array, env):
	var v_id_38 = null
	v_id_38 = J.arg(a, 0)
	if (not J.t(J.gp(J.G.get("S"), "visit"))):
		var _t27 = J.G.get("S")
		var _t28 = {}
		J.sp(_t27, "visit", _t28)
	var _t29 = J.gp(J.G.get("S"), "visit")
	J.sp(_t29, v_id_38, 1.0)
	J.mc(J.G.get("Quest"), "check", [])
	J.cl(J.G.get("save"), null, [])

func _f13(this_, a: Array, env):
	var v_ctx_41 = null; var v_x_42 = null; var v_y_43 = null; var v_t_44 = null; var v_r_45 = null
	v_ctx_41 = J.arg(a, 0)
	v_x_42 = J.arg(a, 1)
	v_y_43 = J.arg(a, 2)
	v_t_44 = J.arg(a, 3)
	if (not J.t(J.cl(env["anyDot"], null, []))):
		return null
	v_r_45 = (7.0 + (sin(J.num(J.mul(v_t_44, 5.0))) * 1.2))
	J.mc(v_ctx_41, "save", [])
	J.sp(v_ctx_41, "fillStyle", "#e8303a")
	J.sp(v_ctx_41, "strokeStyle", "#fff3e0")
	J.sp(v_ctx_41, "lineWidth", 2.0)
	J.mc(v_ctx_41, "beginPath", [])
	J.mc(v_ctx_41, "arc", [v_x_42, v_y_43, v_r_45, 0.0, 7.0])
	J.mc(v_ctx_41, "fill", [])
	J.mc(v_ctx_41, "stroke", [])
	J.mc(v_ctx_41, "restore", [])

func _f2(this_, a: Array, env):
	var v_q_13 = null
	v_q_13 = J.arg(a, 0)
	var _t35 = J.seq(J.gp(v_q_13, "t"), "stage")
	return (J.seq(J.gp(v_q_13, "s"), J.gp(env["a"], "after")) if _t35 else _t35)

func _f4(this_, a: Array, env):
	var v_q_17 = null
	v_q_17 = J.arg(a, 0)
	var _t37 = J.seq(J.gp(v_q_17, "t"), "stage")
	return (J.seq(J.gp(v_q_17, "s"), J.gp(env["a"], "after")) if _t37 else _t37)

func _f3(this_, a: Array, env):
	var v_n_15 = null; var v_i_16 = null
	var _s6 = {"__p": env, "a": null}
	_s6["a"] = J.arg(a, 0)
	v_n_15 = J.arg(a, 1)
	v_i_16 = J.mc(J.G.get("QUESTS"), "findIndex", [Callable(self, "_f4").bind(_s6)])
	if J.cmp(v_i_16, 0.0, ">="):
		J.mc(J.G.get("QUESTS"), "splice", [J.add(v_i_16, 1.0), 0.0, J.gp(_s6["a"], "q")])

func _f1(this_, a: Array, env):
	var v_ADD_2 = null; var v_migrate_5 = null; var v_visit_9 = null; var v_drawGateDot_10 = null; var v_i_12 = null
	var _s2 = {"__p": env, "at": null, "QV": null, "open": null, "dot": null, "anyDot": null}
	v_migrate_5 = Callable(self, "_f5").bind(_s2)
	_s2["open"] = Callable(self, "_f7").bind(_s2)
	_s2["dot"] = Callable(self, "_f8").bind(_s2)
	_s2["anyDot"] = Callable(self, "_f10").bind(_s2)
	v_visit_9 = Callable(self, "_f12").bind(_s2)
	v_drawGateDot_10 = Callable(self, "_f13").bind(_s2)
	var _t30 = J.G.get("SCENES")
	var _t31 = {"style": "talk", "bg": "village", "title": "下班後", "lines": [["小紙", "少爺，你做到成隻鬼咁殘喇。"], ["阿福", "我本來就係鬼。"], ["小紙", "咁更加要放工啦！出村口行過去，有條冥街夜市，成晚都開。宵夜、講價、燒紙紮，乜都有。"], ["阿福", "……有冇得加班？"], ["小紙", "冇！今晚唔准加班。行，我帶你去。"]]}
	J.sp(_t30, "q_street", _t31)
	var _t32 = J.G.get("SCENES")
	var _t33 = {"style": "talk", "bg": "village", "title": "無名墳", "lines": [["小紙", "少爺，打贏餓鬼王之後，村外面多咗啲鬼喺度徘徊。"], ["阿福", "又係搶包？"], ["小紙", "唔係。佢哋喺亂葬崗搵唔返自己個墳，瞓唔到。"], ["阿福", "搵唔返自己個墳……咁點算？"], ["小紙", "睇墓碑、聽佢哋講，幫佢哋一個個對返落去。出村口，地圖上嗰個「亂葬崗」。"]]}
	J.sp(_t32, "q_yard", _t33)
	v_ADD_2 = [{"after": "1-2", "q": {"t": "visit", "place": "street", "text": "下班後去冥街夜市逛逛", "go": "gate", "r": {"exp": 40.0, "coins": 60.0}, "onStart": ["q_street"]}}, {"after": "1-3", "q": {"t": "visit", "place": "yard", "text": "去亂葬崗找無名墳", "go": "gate", "r": {"exp": 60.0, "coins": 80.0}, "onStart": ["q_yard"]}}]
	_s2["at"] = []
	for _t34 in J.iter(v_ADD_2):
		var _s3 = {"__p": _s2, "a": null}
		_s3["a"] = _t34
		v_i_12 = J.mc(J.G.get("QUESTS"), "findIndex", [Callable(self, "_f2").bind(_s3)])
		if J.cmp(v_i_12, 0.0, ">="):
			J.mc(_s3["__p"]["at"], "push", [J.add(v_i_12, 1.0)])
	var _t36 = J.mc(J.mc(v_ADD_2, "slice", []), "reverse", [])
	J.mc(_t36, "forEach", [Callable(self, "_f3").bind(_s2)])
	_s2["QV"] = 2.0
	return {"migrate": v_migrate_5, "dot": _s2["dot"], "anyDot": _s2["anyDot"], "visit": v_visit_9, "drawGateDot": v_drawGateDot_10}
