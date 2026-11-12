# 自動轉譯自 sprites.js（tools/jsgd.js）——唔好直接改，改原 JS 再轉
extends RefCounted

func run(env):
	var this_ = null; var a = []
	J.G["sprOk"] = Callable(self, "_f8").bind(env)
	J.G["SPR"] = {}
	J.G["SPR_READY"] = J.cl(Callable(self, "_f1").bind(env), null, [])

func _f8(this_, a: Array, env):
	var v_k_15 = null; var v_i_16 = null
	v_k_15 = J.arg(a, 0)
	v_i_16 = J.gp(J.G.get("SPR"), v_k_15)
	var _t3 = v_i_16
	if J.t(_t3):
		var _t2 = J.gp(v_i_16, "_ok")
		if not J.t(_t2):
			var _t1 = J.gp(v_i_16, "complete")
			_t2 = (J.gp(v_i_16, "naturalWidth") if J.t(_t1) else _t1)
		_t3 = _t2
	return (not (not J.t(_t3)))

func _f4(this_, a: Array, env):
	var _t7 = env["__p"]["img"]
	J.sp(_t7, "_ok", true)
	J.cl(env["res"], null, [])

func _f6(this_, a: Array, env):
	return J.cl(env["res"], null, [])

func _f5(this_, a: Array, env):
	var _t9 = env["__p"]["img"]
	var _t10 = env["ok"]
	J.sp(_t9, "onload", _t10)
	var _t11 = env["__p"]["img"]
	var _t12 = Callable(self, "_f6").bind(env)
	J.sp(_t11, "onerror", _t12)
	var _t13 = J.gp(env["__p"]["img"], "complete")
	if J.t((J.gp(env["__p"]["img"], "naturalWidth") if J.t(_t13) else _t13)):
		J.cl(env["ok"], null, [])

func _f7(this_, a: Array, env):
	return J.cl(env["res"], null, [])

func _f3(this_, a: Array, env):
	var _s4 = {"__p": env, "res": null, "ok": null}
	_s4["res"] = J.arg(a, 0)
	_s4["ok"] = Callable(self, "_f4").bind(_s4)
	if J.t(J.gp(_s4["__p"]["img"], "decode")):
		var _t8 = J.mc(_s4["__p"]["img"], "decode", [])
		J.mc(_t8, "then", [_s4["ok"], Callable(self, "_f5").bind(_s4)])
	else:
		var _t14 = _s4["__p"]["img"]
		var _t15 = _s4["ok"]
		J.sp(_t14, "onload", _t15)
		var _t16 = _s4["__p"]["img"]
		var _t17 = Callable(self, "_f7").bind(_s4)
		J.sp(_t16, "onerror", _t17)

func _f2(this_, a: Array, env):
	var v_key_6 = null; var v_src_7 = null
	var _s3 = {"__p": env, "img": null}
	v_key_6 = J.arg(a, 0)
	v_src_7 = J.arg(a, 1)
	_s3["img"] = J.new_("Image", [])
	var _t4 = _s3["img"]
	J.sp(_t4, "src", v_src_7)
	var _t5 = J.G.get("SPR")
	var _t6 = _s3["img"]
	J.sp(_t5, v_key_6, _t6)
	J.mc(_s3["__p"]["jobs"], "push", [J.new_("Promise", [Callable(self, "_f3").bind(_s3)])])

func _f1(this_, a: Array, env):
	var v_load_5 = null; var v_k_11 = null; var v_k_12 = null
	var _s2 = {"__p": env, "jobs": null}
	_s2["jobs"] = []
	v_load_5 = Callable(self, "_f2").bind(_s2)
	if (not J.seq(J.typeof_(J.G.get("SPR_SRC")), "undefined")):
		for _t18 in J.keys(J.G.get("SPR_SRC")):
			v_k_11 = _t18
			J.cl(v_load_5, null, [v_k_11, J.gp(J.G.get("SPR_SRC"), v_k_11)])
	if (not J.seq(J.typeof_(J.G.get("BG_SRC")), "undefined")):
		for _t19 in J.keys(J.G.get("BG_SRC")):
			v_k_12 = _t19
			J.cl(v_load_5, null, [J.add("bg_", v_k_12), J.gp(J.G.get("BG_SRC"), v_k_12)])
	return J.S_Promise_("all", [_s2["jobs"]])
