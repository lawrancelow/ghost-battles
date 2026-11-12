# 自動轉譯自 lang.js（tools/jsgd.js）——唔好直接改，改原 JS 再轉
extends RefCounted

func run(env):
	var this_ = null; var a = []
	J.G["L"] = Callable(self, "_f9").bind(env)
	J.G["Lf"] = Callable(self, "_f10").bind(env)
	J.G["LANG"] = J.cl(Callable(self, "_f1").bind(env), null, [])

func _f9(this_, a: Array, env):
	var v_s_30 = null; var v_t_31 = null
	v_s_30 = J.arg(a, 0)
	var _t1 = (not J.seq(J.typeof_(v_s_30), "string"))
	if (_t1 if _t1 else (not J.seq(J.gp(J.G.get("LANG"), "cur"), "zh"))):
		return v_s_30
	v_t_31 = J.gp(J.gp(J.G.get("LANG"), "ZH"), v_s_30)
	var _t2 = (not J.leq(v_t_31, null))
	return (v_t_31 if ((not J.seq(v_t_31, "")) if _t2 else _t2) else v_s_30)

func _f10(this_, a: Array, env):
	var v_s_34 = null; var v_v_35 = null; var v_r_36 = null; var v_k_37 = null
	v_s_34 = J.arg(a, 0)
	v_v_35 = J.arg(a, 1)
	var _t3 = J.G.get("L")
	v_r_36 = J.cl(_t3, null, [v_s_34])
	if J.t(v_v_35):
		for _t4 in J.keys(v_v_35):
			v_k_37 = _t4
			var _t5 = J.mc(v_r_36, "split", [(J.add("{", v_k_37) + "}")])
			var _t6 = J.mc(_t5, "join", [J.gp(v_v_35, v_k_37)])
			v_r_36 = _t6
	return v_r_36

func _f2(this_, a: Array, env):
	return env["cur"]

func _f4(this_, a: Array, env):
	var v_f_15 = null; var v_e_16 = null
	v_f_15 = J.arg(a, 0)
	J.cl(v_f_15, null, [env["cur"]])

func _f3(this_, a: Array, env):
	var v_v_13 = null; var v_e_14 = null
	v_v_13 = J.arg(a, 0)
	var _t8 = ("yue" if J.seq(v_v_13, "yue") else "zh")
	env["cur"] = _t8
	J.S_localStorage_("setItem", ["gb_dialogue_lang", env["cur"]])
	J.mc(env["subs"], "forEach", [Callable(self, "_f4").bind(env)])

func _f5(this_, a: Array, env):
	J.mc(this_, "set", [("yue" if J.seq(env["cur"], "zh") else "zh")])
	return env["cur"]

func _f6(this_, a: Array, env):
	var v_f_21 = null
	v_f_21 = J.arg(a, 0)
	J.mc(env["subs"], "push", [v_f_21])

func _f7(this_, a: Array, env):
	var v_t_24 = null; var v_k_25 = null
	v_t_24 = J.arg(a, 0)
	for _t9 in J.keys(v_t_24):
		v_k_25 = _t9
		var _t10 = env["ZH"]
		var _t11 = J.gp(v_t_24, v_k_25)
		J.sp(_t10, v_k_25, _t11)

func _f8(this_, a: Array, env):
	return ("中文" if J.seq(env["cur"], "zh") else "粵語")

func _f1(this_, a: Array, env):
	var v_v_7 = null; var v_e_8 = null
	var _s2 = {"__p": env, "cur": null, "ZH": null, "subs": null}
	_s2["cur"] = "zh"
	v_v_7 = J.S_localStorage_("getItem", ["gb_dialogue_lang"])
	var _t7 = J.seq(v_v_7, "zh")
	if (_t7 if _t7 else J.seq(v_v_7, "yue")):
		_s2["cur"] = v_v_7
	_s2["ZH"] = {}
	_s2["subs"] = []
	return {"ZH": _s2["ZH"], "set": Callable(self, "_f3").bind(_s2), "toggle": Callable(self, "_f5").bind(_s2), "on": Callable(self, "_f6").bind(_s2), "add": Callable(self, "_f7").bind(_s2), "name": Callable(self, "_f8").bind(_s2), "__getters": {"cur": Callable(self, "_f2").bind(_s2)}}
