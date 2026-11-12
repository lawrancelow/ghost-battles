# 自動轉譯自 office.js（tools/jsgd.js）——唔好直接改，改原 JS 再轉
extends RefCounted

func run(env):
	var this_ = null; var a = []
	var _t1 = (not J.seq(J.typeof_(J.G.get("MeshAnim")), "undefined"))
	if ((not J.t(J.gp(J.gp(J.G.get("MeshAnim"), "RIG"), "npc_it"))) if _t1 else _t1):
		var _t2 = J.gp(J.G.get("MeshAnim"), "RIG")
		var _t3 = {"legs": true, "bones": [["hips", null, 0.52, 0.7, 0.52, 0.52, 0.22], ["legF", "hips", 0.43, 0.72, 0.42, 0.98, 0.1], ["legB", "hips", 0.62, 0.72, 0.62, 0.98, 0.1], ["body", "hips", 0.52, 0.65, 0.52, 0.37, 0.26], ["head", "body", 0.52, 0.37, 0.5, 0.03, 0.3], ["hairR", "head", 0.8, 0.18, 0.92, 0.48, 0.12], ["armF", "body", 0.33, 0.44, 0.2, 0.52, 0.13], ["armB", "body", 0.7, 0.44, 0.74, 0.52, 0.11]]}
		J.sp(_t2, "npc_it", _t3)
	if (not J.seq(J.typeof_(J.G.get("MeshAnim")), "undefined")):
		if (not J.t(J.gp(J.gp(J.G.get("MeshAnim"), "RIG"), "npc_mis"))):
			var _t4 = J.gp(J.G.get("MeshAnim"), "RIG")
			var _t5 = {"legs": true, "bones": [["hips", null, 0.45, 0.62, 0.45, 0.48, 0.22], ["legF", "hips", 0.36, 0.66, 0.34, 0.98, 0.1], ["legB", "hips", 0.5, 0.66, 0.52, 0.98, 0.1], ["body", "hips", 0.45, 0.58, 0.45, 0.32, 0.25], ["head", "body", 0.45, 0.32, 0.4, 0.03, 0.3], ["hairR", "head", 0.72, 0.2, 0.86, 0.52, 0.13], ["armF", "body", 0.3, 0.38, 0.12, 0.22, 0.12], ["armB", "body", 0.62, 0.4, 0.7, 0.5, 0.1]]}
			J.sp(_t4, "npc_mis", _t5)
		if (not J.t(J.gp(J.gp(J.G.get("MeshAnim"), "RIG"), "npc_mis_walk"))):
			var _t6 = J.gp(J.G.get("MeshAnim"), "RIG")
			var _t7 = {"legs": true, "bones": [["hips", null, 0.48, 0.62, 0.48, 0.48, 0.22], ["legF", "hips", 0.4, 0.66, 0.14, 0.94, 0.11], ["legB", "hips", 0.56, 0.66, 0.62, 0.95, 0.1], ["body", "hips", 0.48, 0.58, 0.45, 0.3, 0.25], ["head", "body", 0.45, 0.3, 0.42, 0.03, 0.3], ["hairR", "head", 0.75, 0.2, 0.86, 0.55, 0.14], ["armF", "body", 0.33, 0.4, 0.15, 0.45, 0.1], ["armB", "body", 0.7, 0.42, 0.85, 0.62, 0.15]]}
			J.sp(_t6, "npc_mis_walk", _t7)
		if (not J.t(J.gp(J.gp(J.G.get("MeshAnim"), "RIG"), "npc_mis_selfie"))):
			var _t8 = J.gp(J.G.get("MeshAnim"), "RIG")
			var _t9 = {"legs": true, "bones": [["hips", null, 0.48, 0.62, 0.48, 0.48, 0.22], ["legF", "hips", 0.4, 0.66, 0.38, 0.98, 0.1], ["legB", "hips", 0.55, 0.66, 0.56, 0.98, 0.1], ["body", "hips", 0.48, 0.58, 0.48, 0.32, 0.25], ["head", "body", 0.5, 0.32, 0.48, 0.03, 0.3], ["hairR", "head", 0.76, 0.2, 0.88, 0.52, 0.13], ["armF", "body", 0.3, 0.4, 0.12, 0.18, 0.11], ["armB", "body", 0.68, 0.42, 0.72, 0.25, 0.1]]}
			J.sp(_t8, "npc_mis_selfie", _t9)
	J.G["OFFICE"] = J.cl(Callable(self, "_f1").bind(env), null, [])

func _f11(this_, a: Array, env):
	var v_k_129 = null; var v_dark_130 = null; var v_key_131 = null; var v_im_132 = null; var v_c_133 = null; var v_x_134 = null
	v_k_129 = J.arg(a, 0)
	v_dark_130 = J.arg(a, 1)
	var _t10 = env["ok"]
	if (not J.t(J.cl(_t10, null, [v_k_129]))):
		return null
	v_key_131 = J.add(v_k_129, (v_dark_130 if J.t(v_dark_130) else ""))
	if J.t(J.gp(env["TC"], v_key_131)):
		return J.gp(env["TC"], v_key_131)
	v_im_132 = J.gp(J.G.get("SPR"), v_k_129)
	v_c_133 = J.S_document_("createElement", ["canvas"])
	var _t11 = J.gp(v_im_132, "naturalWidth")
	J.sp(v_c_133, "width", _t11)
	var _t12 = J.gp(v_im_132, "naturalHeight")
	J.sp(v_c_133, "height", _t12)
	v_x_134 = J.mc(v_c_133, "getContext", ["2d"])
	J.mc(v_x_134, "drawImage", [v_im_132, 0.0, 0.0])
	J.sp(v_x_134, "globalCompositeOperation", "source-atop")
	var _t13 = ("rgba(14,10,30,.62)" if J.seq(v_dark_130, "off") else "rgba(26,18,58,.30)")
	J.sp(v_x_134, "fillStyle", _t13)
	J.mc(v_x_134, "fillRect", [0.0, 0.0, J.gp(v_c_133, "width"), J.gp(v_c_133, "height")])
	var _t14 = env["TC"]
	J.sp(_t14, v_key_131, v_c_133)
	return v_c_133

func _f12(this_, a: Array, env):
	var v_im_137 = null; var v_c_138 = null; var v_x_139 = null; var v_g_140 = null; var v_wx_141 = null; var v_wy_142 = null; var v_ww_143 = null; var v_wh_144 = null
	if J.t(env["BGC"]):
		return env["BGC"]
	var _t15 = env["ok"]
	if (not J.t(J.cl(_t15, null, ["bg_office_empty"]))):
		return null
	v_im_137 = J.gp(J.G.get("SPR"), "bg_office_empty")
	v_c_138 = J.S_document_("createElement", ["canvas"])
	var _t16 = J.gp(v_im_137, "naturalWidth")
	J.sp(v_c_138, "width", _t16)
	var _t17 = J.gp(v_im_137, "naturalHeight")
	J.sp(v_c_138, "height", _t17)
	v_x_139 = J.mc(v_c_138, "getContext", ["2d"])
	J.mc(v_x_139, "drawImage", [v_im_137, 0.0, 0.0])
	J.sp(v_x_139, "globalCompositeOperation", "multiply")
	J.sp(v_x_139, "fillStyle", "rgb(150,140,196)")
	J.mc(v_x_139, "fillRect", [0.0, 0.0, J.gp(v_c_138, "width"), J.gp(v_c_138, "height")])
	v_g_140 = J.mc(v_x_139, "createLinearGradient", [0.0, J.mul(J.gp(v_c_138, "height"), 0.45), 0.0, J.gp(v_c_138, "height")])
	J.mc(v_g_140, "addColorStop", [0.0, "rgb(255,255,255)"])
	J.mc(v_g_140, "addColorStop", [1.0, "rgb(150,145,180)"])
	J.sp(v_x_139, "fillStyle", v_g_140)
	J.mc(v_x_139, "fillRect", [0.0, J.mul(J.gp(v_c_138, "height"), 0.45), J.gp(v_c_138, "width"), J.mul(J.gp(v_c_138, "height"), 0.55)])
	J.sp(v_x_139, "globalCompositeOperation", "screen")
	J.sp(v_x_139, "globalAlpha", 0.35)
	v_wx_141 = J.mul(J.gp(v_c_138, "width"), 0.105)
	v_wy_142 = J.mul(J.gp(v_c_138, "height"), 0.235)
	v_ww_143 = J.mul(J.gp(v_c_138, "width"), 0.675)
	v_wh_144 = J.mul(J.gp(v_c_138, "height"), 0.22)
	J.mc(v_x_139, "drawImage", [v_im_137, v_wx_141, v_wy_142, v_ww_143, v_wh_144, v_wx_141, v_wy_142, v_ww_143, v_wh_144])
	env["BGC"] = v_c_138
	return env["BGC"]

func _f13(this_, a: Array, env):
	var v_s_147 = null
	v_s_147 = J.arg(a, 0)
	env["STN"] = v_s_147
	env["SEAT"] = J.gp(v_s_147, "seat")
	env["SEATV"] = J.gp(v_s_147, "SEATV")
	env["K"] = J.gp(v_s_147, "K")
	return v_s_147

func _f18(this_, a: Array, env):
	var v_S_160 = null; var v_d_161 = null; var v_it_162 = null; var v_k_163 = null; var v_c_164 = null; var v_k_165 = null; var v_s_166 = null
	v_S_160 = J.arg(a, 0)
	env["SC"] = v_S_160
	var _t18 = {}
	env["items"] = _t18
	var _t19 = []
	env["list"] = _t19
	var _t20 = []
	env["kids"] = _t20
	var _t21 = []
	env["flying"] = _t21
	var _t22 = []
	env["floor"] = _t22
	var _t23 = []
	env["drops"] = _t23
	for _t24 in J.iter(env["DEF"]):
		v_d_161 = _t24
		v_it_162 = J.S_Object_("assign", [{"ax": 0.5, "ay": 1.0, "dx": 0.0, "dy": 0.0, "rot": 0.0, "vr": 0.0, "sx": 1.0, "sy": 1.0, "ph": (randf() * 6.0)}, v_d_161, {"kids": []}])
		if (not J.leq(J.gp(v_d_161, "wx"), null)):
			var _t25 = J.gp(v_d_161, "wx")
			J.sp(v_it_162, "x", _t25)
			var _t26 = J.gp(v_d_161, "wy")
			J.sp(v_it_162, "y", _t26)
		else:
			if (not J.t(J.gp(v_d_161, "stn"))):
				var _t27 = J.mc(J.G.get("OFFMAP"), "M", [J.gp(v_d_161, "x")])
				J.sp(v_it_162, "x", _t27)
				var _t28 = J.mc(J.G.get("OFFMAP"), "MY", [J.gp(v_d_161, "y")])
				J.sp(v_it_162, "y", _t28)
		if J.t(J.gp(v_d_161, "water")):
			var _t29 = J.mc(J.G.get("OFFMAP"), "npx", [4050.0])
			J.sp(v_it_162, "x", _t29)
		if J.t(J.gp(v_d_161, "copier")):
			var _t30 = J.gp(J.gp(J.gp(J.G.get("OFFMAP"), "SPOT"), "copier"), 0.0)
			J.sp(v_it_162, "x", _t30)
			var _t31 = J.gp(J.gp(J.gp(J.G.get("OFFMAP"), "SPOT"), "copier"), 1.0)
			J.sp(v_it_162, "y", _t31)
			J.sp(v_it_162, "h", 0.62)
		var _t32 = env["items"]
		var _t33 = J.gp(v_d_161, "id")
		J.sp(_t32, _t33, v_it_162)
		J.mc(env["list"], "push", [v_it_162])
		var _t35 = J.gp(v_d_161, "kids")
		for _t34 in J.iter((_t35 if J.t(_t35) else [])):
			v_k_163 = _t34
			var _t36 = J.gp(v_k_163, "rot")
			var _t38 = (_t36 if J.t(_t36) else 0.0)
			var _t37 = J.gp(v_k_163, "rot")
			v_c_164 = J.S_Object_("assign", [{"ax": 0.5, "ay": 1.0, "dx": 0.0, "dy": 0.0, "rot": _t38, "base": (_t37 if J.t(_t37) else 0.0), "vr": 0.0, "sx": 1.0, "sy": 1.0, "hide": 0.0, "ph": (randf() * 6.0)}, v_k_163, {"parent": v_it_162}])
			var _t39 = J.gp(v_it_162, "kids")
			J.mc(_t39, "push", [v_c_164])
			var _t40 = env["items"]
			var _t41 = J.gp(v_k_163, "id")
			J.sp(_t40, _t41, v_c_164)
			J.mc(env["kids"], "push", [v_c_164])
	var _t42 = {"t": 0.0, "fan": {"osc": 0.0, "spin": 0.0, "boost": 0.0}, "clock": {"spin": 0.0, "ang": 0.0}, "lamp": {"flick": 0.0, "sway": 0.0, "vs": 0.0}, "ac": {"blow": 0.0}, "water": {"glug": 0.0}, "copier": {"print": 0.0, "out": 0.0}, "tubes": 0.0, "rustle": 0.0, "flutter": 0.0, "lights": null, "dropQ": [], "clockF": null, "chairSpin": 0.0, "creak": 0.0}
	env["st"] = _t42
	for _t43 in J.keys(env["STATIONS"]):
		v_k_165 = _t43
		var _t44 = env["use"]
		v_s_166 = J.cl(_t44, null, [J.gp(env["STATIONS"], v_k_165)])
		var _t45 = {"seq": (-1.0)}
		J.sp(v_s_166, "monSt", _t45)
		J.sp(v_s_166, "offline", false)
		J.cl(env["layoutKen"], null, [])
		J.cl(env["resetKen"], null, [])
	var _t46 = env["use"]
	J.cl(_t46, null, [J.gp(env["STATIONS"], "ken")])

func _f19(this_, a: Array, env):
	var v_d_169 = null; var v_pp_170 = null; var v_uf_171 = null
	v_d_169 = J.gp(env["items"], J.gp(env["STN"], "desk"))
	v_pp_170 = J.mc(env["SC"], "persp", [])
	v_uf_171 = J.mul(J.mul(J.gp(v_pp_170, "c"), J.sub(J.gp(env["SEAT"], "y"), J.gp(v_pp_170, "hz"))), env["KEN_H"])
	var _t49 = J.gp(env["SEATV"], "x")
	var _t48 = J.gp(J.gp(env["STN"], "hand"), 0.0)
	var _t47 = env["KEN_UW"]
	var _t50 = J.sub(_t49, J.mul(_t48, J.cl(_t47, null, [J.gp(env["SEAT"], "y")])))
	J.sp(v_d_169, "x", _t50)
	var _t51 = J.sub(J.gp(env["SEAT"], "y"), J.mul(J.gp(J.gp(env["STN"], "hand"), 1.0), v_uf_171))
	J.sp(v_d_169, "y", _t51)
	var _t52 = J.add(J.gp(v_d_169, "y"), J.mul(J.mul(J.sub(J.gp(v_d_169, "floorV"), J.gp(v_d_169, "ay")), J.gp(v_d_169, "h")), v_uf_171))
	J.sp(v_d_169, "z", _t52)
	var _t53 = J.gp(env["SEAT"], "y")
	J.sp(v_d_169, "uy", _t53)

func _f21(this_, a: Array, env):
	var _t54 = env["STN"]
	var _t55 = {"mode": "sit", "mt": 0.0, "act": "type", "at": 0.0, "dur": 6.0, "cd": {}, "w": 1.0, "pop": 0.0, "keys": [], "ch": {"dx": 0.0, "dz": 0.0, "vx": 0.0, "vz": 0.0, "sw": 0.0, "vs": 0.0, "lean": 0.0, "occ": true}, "kick": 0.0, "look": 0.0}
	J.sp(_t54, "K", _t55)
	env["K"] = _t55

func _f23(this_, a: Array, env):
	var v_e_180 = null
	v_e_180 = J.arg(a, 0)
	var _t57 = J.gp(J.gp(env["K"], "cd"), J.gp(v_e_180, 0.0))
	var _t58 = J.cmp((_t57 if J.t(_t57) else 0.0), 0.0, "<=")
	return ((not J.seq(J.gp(v_e_180, 0.0), J.gp(env["K"], "act"))) if _t58 else _t58)

func _f24(this_, a: Array, env):
	var v_s_181 = null; var v_e_182 = null
	v_s_181 = J.arg(a, 0)
	v_e_182 = J.arg(a, 1)
	return J.add(v_s_181, J.gp(v_e_182, 1.0))

func _f22(this_, a: Array, env):
	var v_opts_177 = null; var v_r_178 = null; var v_e_179 = null; var v_o_183 = null
	var _t56 = J.gp(env["STN"], "acts")
	v_opts_177 = J.mc(_t56, "filter", [Callable(self, "_f23").bind(env)])
	v_r_178 = J.mul(randf(), J.mc(v_opts_177, "reduce", [Callable(self, "_f24").bind(env), 0.0]))
	v_e_179 = J.gp(v_opts_177, 0.0)
	for _t59 in J.iter(v_opts_177):
		v_o_183 = _t59
		var _t60 = J.sub(v_r_178, J.gp(v_o_183, 1.0))
		v_r_178 = _t60
		if J.cmp(v_r_178, 0.0, "<="):
			v_e_179 = v_o_183
			break
	var _t61 = env["K"]
	var _t62 = J.gp(v_e_179, 0.0)
	J.sp(_t61, "act", _t62)
	var _t63 = env["K"]
	J.sp(_t63, "at", 0.0)
	var _t64 = env["K"]
	var _t65 = J.add(J.gp(J.gp(v_e_179, 2.0), 0.0), (randf() * J.sub(J.gp(J.gp(v_e_179, 2.0), 1.0), J.gp(J.gp(v_e_179, 2.0), 0.0))))
	J.sp(_t64, "dur", _t65)
	var _t66 = J.gp(env["K"], "cd")
	var _t67 = J.gp(v_e_179, 0.0)
	var _t68 = J.add(J.gp(v_e_179, 3.0), J.gp(env["K"], "dur"))
	J.sp(_t66, _t67, _t68)
	var _t69 = (not J.seq(J.gp(env["K"], "act"), "type"))
	if (_t69 if _t69 else (randf() < 0.5)):
		var _t70 = env["K"]
		J.sp(_t70, "pop", 0.18)

func _f25(this_, a: Array, env):
	var v_n_186 = null
	v_n_186 = J.arg(a, 0)
	var _t71 = (not J.t(J.gp(v_n_186, "fleeing")))
	var _t72 = ((not J.t(J.gp(v_n_186, "gone"))) if _t71 else _t71)
	var _t73 = (J.seq(J.gp(v_n_186, "act"), "work") if _t72 else _t72)
	var _t74 = ((absf(J.num(J.sub(J.gp(v_n_186, "x"), J.gp(env["SEAT"], "x")))) < 0.002) if _t73 else _t73)
	return ((absf(J.num(J.sub(J.gp(v_n_186, "y"), J.gp(env["SEAT"], "y")))) < 0.002) if _t74 else _t74)

func _f26(this_, a: Array, env):
	var v_n_189 = null; var v_s_190 = null; var v_K_191 = null
	v_n_189 = J.arg(a, 0)
	var _t75 = env["stnOf"]
	v_s_190 = J.cl(_t75, null, [v_n_189])
	var _t76 = (not J.t(v_s_190))
	if (_t76 if _t76 else (not J.t(J.gp(v_s_190, "K")))):
		return false
	v_K_191 = J.gp(v_s_190, "K")
	var _t77 = J.seq(J.gp(v_K_191, "mode"), "sit")
	var _t78 = (_t77 if _t77 else J.seq(J.gp(v_K_191, "mode"), "jump"))
	var _t79 = (_t78 if _t78 else J.seq(J.gp(v_K_191, "mode"), "rise"))
	return (_t79 if _t79 else J.seq(J.gp(v_K_191, "mode"), "sitdown"))

func _f28(this_, a: Array, env):
	var v_k_212 = null
	v_k_212 = J.arg(a, 0)
	var _t193 = J.sub(J.gp(v_k_212, "life"), env["dt"])
	J.sp(v_k_212, "life", _t193)
	return (_t193 > 0.0)

func _f27(this_, a: Array, env):
	var v_n_194 = null; var v_s_196 = null; var v_rx_197 = null; var v_ch_198 = null; var v_big_199 = null; var v_calm_200 = null; var v_wantDx_201 = null; var v_wantSw_202 = null; var v_wantLean_203 = null; var v_k_204 = null; var v_s_205 = null; var v_k_206 = null; var v_f_207 = null; var v_a_208 = null; var v_e_209 = null; var v_a_210 = null; var v_b_211 = null
	var _s44 = {"__p": env, "dt": null}
	v_n_194 = J.arg(a, 0)
	_s44["dt"] = J.arg(a, 1)
	var _t80 = J.gp(v_n_194, "d")
	if J.t((J.seq(J.gp(J.gp(v_n_194, "d"), "k"), "mis") if J.t(_t80) else _t80)):
		var _t81 = _s44["__p"]["misTick"]
		J.cl(_t81, null, [v_n_194, _s44["dt"]])
		return null
	var _t82 = _s44["__p"]["stnOf"]
	v_s_196 = J.cl(_t82, null, [v_n_194])
	var _t83 = (not J.t(v_s_196))
	if (_t83 if _t83 else (not J.t(J.gp(v_s_196, "K")))):
		return null
	var _t84 = _s44["__p"]["use"]
	J.cl(_t84, null, [v_s_196])
	var _t85 = J.gp(v_n_194, "rx")
	v_rx_197 = (J.gp(v_n_194, "rx") if J.t((J.cmp(J.gp(J.gp(v_n_194, "rx"), "t"), 0.0, ">=") if J.t(_t85) else _t85)) else null)
	v_ch_198 = J.gp(_s44["__p"]["K"], "ch")
	var _t88 = v_rx_197
	if J.t(_t88):
		var _t86 = J.seq(J.gp(v_rx_197, "k"), "startle")
		var _t87 = (_t86 if _t86 else J.seq(J.gp(v_rx_197, "k"), "weakjump"))
		_t88 = (_t87 if _t87 else J.seq(J.gp(v_rx_197, "k"), "burst"))
	v_big_199 = _t88
	var _t91 = J.cmp(J.gp(v_n_194, "fear"), 25.0, "<")
	if J.t(_t91):
		var _t89 = (not J.t(v_rx_197))
		var _t90 = (_t89 if _t89 else J.seq(J.gp(v_rx_197, "k"), "numb"))
		_t91 = (_t90 if _t90 else J.seq(J.gp(v_rx_197, "k"), "sip"))
	v_calm_200 = _t91
	var _t92 = _s44["__p"]["K"]
	var _t93 = J.add(J.gp(_t92, "mt"), _s44["dt"])
	J.sp(_t92, "mt", _t93)
	var _t94 = _s44["__p"]["K"]
	var _t95 = J.max_([0.0, J.sub(J.gp(_s44["__p"]["K"], "pop"), _s44["dt"])])
	J.sp(_t94, "pop", _t95)
	for _t96 in J.keys(J.gp(_s44["__p"]["K"], "cd")):
		v_k_204 = _t96
		var _t97 = J.gp(_s44["__p"]["K"], "cd")
		var _t98 = J.sub(J.gp(_t97, v_k_204), _s44["dt"])
		J.sp(_t97, v_k_204, _t98)
	var _t99 = J.gp(_s44["__p"]["K"], "mode")
	var _t100 = -1
	var _t101 = false
	if _t100 == -1 and J.seq(_t99, "sit"): _t100 = 0
	if _t100 == -1 and J.seq(_t99, "jump"): _t100 = 1
	if _t100 == -1 and J.seq(_t99, "rise"): _t100 = 2
	if _t100 == -1 and J.seq(_t99, "up"): _t100 = 3
	if _t100 == -1 and J.seq(_t99, "pull"): _t100 = 4
	if _t100 == -1 and J.seq(_t99, "sitdown"): _t100 = 5
	while true:
		if _t100 <= 0 and _t100 >= 0:
			J.sp(v_ch_198, "occ", true)
			var _t102 = _s44["__p"]["atDesk"]
			if (not J.t(J.cl(_t102, null, [v_n_194]))):
				var _t103 = _s44["__p"]["K"]
				J.sp(_t103, "mode", "rise")
				var _t104 = _s44["__p"]["K"]
				J.sp(_t104, "mt", 0.0)
				J.sp(v_ch_198, "vx", 0.12)
				var _t105 = (-0.03)
				J.sp(v_ch_198, "vz", _t105)
				break
			if J.t((v_big_199 if J.t(v_big_199) else J.cmp(J.gp(v_n_194, "fear"), 50.0, ">="))):
				var _t106 = _s44["__p"]["K"]
				J.sp(_t106, "mode", "jump")
				var _t107 = _s44["__p"]["K"]
				J.sp(_t107, "mt", 0.0)
				var _t108 = ((not J.leq(J.gp(v_rx_197, "src"), null)) if J.t(v_rx_197) else v_rx_197)
				v_s_205 = ((-1.0) if J.t((J.cmp(J.gp(v_rx_197, "src"), J.gp(v_n_194, "x"), ">") if J.t(_t108) else _t108)) else 1.0)
				var _t109 = (J.mul(0.16, v_s_205) + 0.1)
				J.sp(v_ch_198, "vx", _t109)
				var _t110 = ((-0.03) - (randf() * 0.015))
				J.sp(v_ch_198, "vz", _t110)
				var _t111 = (((-1.0) if (randf() < 0.5) else 1.0) * (6.0 + (randf() * 4.0)))
				J.sp(v_ch_198, "vs", _t111)
				var _t112 = _s44["__p"]["K"]
				J.sp(_t112, "kick", 1.0)
				if J.t(J.gp(_s44["__p"]["STN"], "mug")):
					var _t113 = _s44["__p"]["spill"]
					J.cl(_t113, null, [J.gp(_s44["__p"]["items"], J.gp(_s44["__p"]["STN"], "mug")), 0.8])
				var _t114 = _s44["__p"]["onScare"]
				J.cl(_t114, null, [J.sub(J.gp(_s44["__p"]["SEATV"], "x"), 0.06), J.gp(_s44["__p"]["SEAT"], "y"), 0.7])
				break
			var _t115 = _s44["__p"]["K"]
			var _t116 = J.add(J.gp(_t115, "at"), _s44["dt"])
			J.sp(_t115, "at", _t116)
			if J.cmp(J.gp(_s44["__p"]["K"], "at"), J.gp(_s44["__p"]["K"], "dur"), ">="):
				J.cl(_s44["__p"]["pickAct"], null, [])
			break
		if _t100 <= 1 and _t100 >= 0:
			J.sp(v_ch_198, "occ", false)
			if J.cmp(J.gp(_s44["__p"]["K"], "mt"), 0.62, ">"):
				var _t117 = _s44["__p"]["K"]
				J.sp(_t117, "mode", "up")
				var _t118 = _s44["__p"]["K"]
				J.sp(_t118, "mt", 0.0)
			break
		if _t100 <= 2 and _t100 >= 0:
			J.sp(v_ch_198, "occ", true)
			if J.cmp(J.gp(_s44["__p"]["K"], "mt"), 0.34, ">"):
				var _t119 = _s44["__p"]["K"]
				J.sp(_t119, "mode", "up")
				var _t120 = _s44["__p"]["K"]
				J.sp(_t120, "mt", 0.0)
				J.sp(v_ch_198, "occ", false)
			break
		if _t100 <= 3 and _t100 >= 0:
			J.sp(v_ch_198, "occ", false)
			var _t121 = _s44["__p"]["atDesk"]
			var _t122 = J.cl(_t121, null, [v_n_194])
			var _t123 = (v_calm_200 if J.t(_t122) else _t122)
			if J.t((J.cmp(J.gp(_s44["__p"]["K"], "mt"), 0.6, ">") if J.t(_t123) else _t123)):
				var _t124 = _s44["__p"]["K"]
				J.sp(_t124, "mode", "pull")
				var _t125 = _s44["__p"]["K"]
				J.sp(_t125, "mt", 0.0)
				var _t126 = _s44["__p"]["K"]
				var _t127 = {"dx": J.gp(v_ch_198, "dx"), "dz": J.gp(v_ch_198, "dz"), "sw": J.gp(v_ch_198, "sw")}
				J.sp(_t126, "p0", _t127)
				J.sp(v_ch_198, "vs", 0.0)
				J.sp(v_ch_198, "vz", 0.0)
				J.sp(v_ch_198, "vx", 0.0)
			break
		if _t100 <= 4 and _t100 >= 0:
			J.sp(v_ch_198, "occ", false)
			var _t128 = _s44["__p"]["ss"]
			v_k_206 = J.cl(_t128, null, [J.div(J.gp(_s44["__p"]["K"], "mt"), 0.7)])
			var _t129 = _s44["__p"]["atDesk"]
			var _t130 = (not J.t(J.cl(_t129, null, [v_n_194])))
			if (_t130 if _t130 else (not J.t(v_calm_200))):
				var _t131 = _s44["__p"]["K"]
				J.sp(_t131, "mode", "up")
				var _t132 = _s44["__p"]["K"]
				J.sp(_t132, "mt", 0.0)
				break
			var _t133 = _s44["__p"]["lerp"]
			var _t134 = J.cl(_t133, null, [J.gp(J.gp(_s44["__p"]["K"], "p0"), "dx"), 0.0, v_k_206])
			J.sp(v_ch_198, "dx", _t134)
			var _t135 = _s44["__p"]["lerp"]
			var _t136 = J.cl(_t135, null, [J.gp(J.gp(_s44["__p"]["K"], "p0"), "dz"), 0.0, v_k_206])
			J.sp(v_ch_198, "dz", _t136)
			var _t137 = _s44["__p"]["lerp"]
			var _t138 = J.cl(_t137, null, [J.gp(J.gp(_s44["__p"]["K"], "p0"), "sw"), J.mul((J.round(J.num(J.div(J.gp(J.gp(_s44["__p"]["K"], "p0"), "sw"), J.mul(2.0, _s44["__p"]["PI"])))) * 2.0), _s44["__p"]["PI"]), v_k_206])
			J.sp(v_ch_198, "sw", _t138)
			if J.cmp(J.gp(_s44["__p"]["K"], "mt"), 0.7, ">="):
				J.sp(v_ch_198, "sw", 0.0)
				var _t139 = _s44["__p"]["K"]
				J.sp(_t139, "mode", "sitdown")
				var _t140 = _s44["__p"]["K"]
				J.sp(_t140, "mt", 0.0)
			break
		if _t100 <= 5 and _t100 >= 0:
			J.sp(v_ch_198, "occ", true)
			if J.cmp(J.gp(_s44["__p"]["K"], "mt"), 0.32, ">"):
				var _t141 = _s44["__p"]["K"]
				J.sp(_t141, "mode", "sit")
				var _t142 = _s44["__p"]["K"]
				J.sp(_t142, "mt", 0.0)
				var _t143 = _s44["__p"]["K"]
				J.sp(_t143, "act", "type")
				var _t144 = _s44["__p"]["K"]
				J.sp(_t144, "at", 0.0)
				var _t145 = _s44["__p"]["K"]
				var _t146 = (3.0 + (randf() * 3.0))
				J.sp(_t145, "dur", _t146)
			break
		break
	var _t147 = (not J.t(J.gp(v_ch_198, "occ")))
	if ((not J.seq(J.gp(_s44["__p"]["K"], "mode"), "jump")) if _t147 else _t147):
		var _t148 = _s44["__p"]["selfSpin"]
		J.cl(_t148, null, [v_ch_198, J.add(J.gp(_s44["__p"]["SEATV"], "x"), J.gp(v_ch_198, "dx")), J.add(J.gp(_s44["__p"]["SEAT"], "y"), J.gp(v_ch_198, "dz")), _s44["dt"]])
	var _t149 = (not J.t(J.gp(v_ch_198, "occ")))
	if (_t149 if _t149 else J.seq(J.gp(_s44["__p"]["K"], "mode"), "jump")):
		var _t150 = J.add(J.gp(v_ch_198, "dx"), J.mul(J.gp(v_ch_198, "vx"), _s44["dt"]))
		J.sp(v_ch_198, "dx", _t150)
		var _t151 = J.add(J.gp(v_ch_198, "dz"), J.mul(J.gp(v_ch_198, "vz"), _s44["dt"]))
		J.sp(v_ch_198, "dz", _t151)
		var _t152 = J.add(J.gp(v_ch_198, "sw"), J.mul(J.gp(v_ch_198, "vs"), _s44["dt"]))
		J.sp(v_ch_198, "sw", _t152)
		v_f_207 = exp(J.num(((-J.num(_s44["dt"])) * (0.6 if J.t((J.cmp(J.gp(_s44["__p"]["st"], "chairSpin"), 0.0, ">") if J.t(_s44["__p"]["st"]) else _s44["__p"]["st"])) else 2.0))))
		var _t153 = J.mul(J.gp(v_ch_198, "vx"), v_f_207)
		J.sp(v_ch_198, "vx", _t153)
		var _t154 = J.mul(J.gp(v_ch_198, "vz"), v_f_207)
		J.sp(v_ch_198, "vz", _t154)
		var _t155 = J.mul(J.gp(v_ch_198, "vs"), exp(J.num(((-J.num(_s44["dt"])) * (0.2 if J.t((J.cmp(J.gp(_s44["__p"]["st"], "chairSpin"), 0.0, ">") if J.t(_s44["__p"]["st"]) else _s44["__p"]["st"])) else 1.4)))))
		J.sp(v_ch_198, "vs", _t155)
		if J.cmp(J.gp(v_ch_198, "dx"), 0.13, ">"):
			J.sp(v_ch_198, "dx", 0.13)
			var _t156 = ((-absf(J.num(J.gp(v_ch_198, "vx")))) * 0.3)
			J.sp(v_ch_198, "vx", _t156)
		if J.cmp(J.gp(v_ch_198, "dx"), (-0.01), "<"):
			var _t157 = (-0.01)
			J.sp(v_ch_198, "dx", _t157)
			var _t158 = (absf(J.num(J.gp(v_ch_198, "vx"))) * 0.3)
			J.sp(v_ch_198, "vx", _t158)
		if J.cmp(J.gp(v_ch_198, "dz"), 0.05, ">"):
			J.sp(v_ch_198, "dz", 0.05)
			var _t159 = ((-absf(J.num(J.gp(v_ch_198, "vz")))) * 0.3)
			J.sp(v_ch_198, "vz", _t159)
		if J.cmp(J.gp(v_ch_198, "dz"), (-0.035), "<"):
			var _t160 = (-0.035)
			J.sp(v_ch_198, "dz", _t160)
			J.sp(v_ch_198, "vz", 0.0)
		if (absf(J.num(J.gp(v_ch_198, "vs"))) < 0.6):
			var _t161 = _s44["__p"]["lerp"]
			var _t162 = J.cl(_t161, null, [J.gp(v_ch_198, "sw"), J.mul((J.round(J.num(J.div(J.gp(v_ch_198, "sw"), J.mul(2.0, _s44["__p"]["PI"])))) * 2.0), _s44["__p"]["PI"]), (1.0 - exp(J.num(((-J.num(_s44["dt"])) * 2.0))))])
			J.sp(v_ch_198, "sw", _t162)
			var _t163 = J.mul(J.gp(v_ch_198, "vs"), 0.9)
			J.sp(v_ch_198, "vs", _t163)
	v_wantDx_201 = 0.0
	v_wantSw_202 = 0.0
	v_wantLean_203 = 0.0
	if J.seq(J.gp(_s44["__p"]["K"], "mode"), "sit"):
		v_a_208 = J.gp(_s44["__p"]["K"], "at")
		var _t164 = _s44["__p"]["ss"]
		var _t166 = J.cl(_t164, null, [J.div(v_a_208, 0.4)])
		var _t165 = _s44["__p"]["ss"]
		v_e_209 = J.mul(_t166, J.cl(_t165, null, [J.div(J.sub(J.gp(_s44["__p"]["K"], "dur"), v_a_208), 0.4)]))
		var _t167 = J.cmp(J.gp(v_n_194, "fear"), 25.0, ">=")
		if ((not J.t(v_big_199)) if _t167 else _t167):
			var _t168 = (sin(J.num(J.mul(J.gp(_s44["__p"]["K"], "mt"), 1.6))) * 0.28)
			v_wantSw_202 = _t168
		else:
			if J.seq(J.gp(_s44["__p"]["K"], "act"), "roll"):
				var _t169 = J.mul((sin(J.num(J.mul(v_a_208, 2.1))) * 0.016), v_e_209)
				v_wantDx_201 = _t169
			else:
				if J.seq(J.gp(_s44["__p"]["K"], "act"), "spin"):
					var _t170 = J.mul((sin(J.num(J.mul(v_a_208, 2.4))) * 0.55), v_e_209)
					v_wantSw_202 = _t170
				else:
					var _t171 = J.seq(J.gp(_s44["__p"]["K"], "act"), "stretch")
					if (_t171 if _t171 else J.seq(J.gp(_s44["__p"]["K"], "act"), "neck")):
						var _t173 = (-0.12)
						var _t172 = _s44["__p"]["bump"]
						var _t174 = J.mul(_t173, J.cl(_t172, null, [v_a_208, 0.2, 0.6, 2.8]))
						v_wantLean_203 = _t174
					else:
						var _t175 = J.seq(J.gp(_s44["__p"]["K"], "act"), "drink")
						if (J.seq(J.gp(_s44["__p"]["STN"], "k"), "it") if _t175 else _t175):
							var _t177 = (-0.08)
							var _t176 = _s44["__p"]["bump"]
							var _t178 = J.mul(_t177, J.cl(_t176, null, [v_a_208, 0.4, 0.9, 3.4]))
							v_wantLean_203 = _t178
		var _t179 = _s44["__p"]["lerp"]
		var _t180 = J.cl(_t179, null, [J.gp(v_ch_198, "dx"), v_wantDx_201, (1.0 - exp(J.num(((-J.num(_s44["dt"])) * 8.0))))])
		J.sp(v_ch_198, "dx", _t180)
		var _t181 = _s44["__p"]["lerp"]
		var _t182 = J.cl(_t181, null, [J.gp(v_ch_198, "sw"), v_wantSw_202, (1.0 - exp(J.num(((-J.num(_s44["dt"])) * 6.0))))])
		J.sp(v_ch_198, "sw", _t182)
		var _t183 = _s44["__p"]["lerp"]
		var _t184 = J.cl(_t183, null, [J.gp(v_ch_198, "dz"), 0.0, (1.0 - exp(J.num(((-J.num(_s44["dt"])) * 6.0))))])
		J.sp(v_ch_198, "dz", _t184)
	var _t185 = _s44["__p"]["lerp"]
	var _t186 = J.cl(_t185, null, [J.gp(v_ch_198, "lean"), v_wantLean_203, (1.0 - exp(J.num(((-J.num(_s44["dt"])) * 7.0))))])
	J.sp(v_ch_198, "lean", _t186)
	var _t187 = J.seq(J.gp(_s44["__p"]["K"], "mode"), "sit")
	var _t188 = (J.seq(J.gp(_s44["__p"]["K"], "act"), "type") if _t187 else _t187)
	var _t189 = (J.cmp(J.gp(v_n_194, "fear"), 25.0, "<") if _t188 else _t188)
	if ((randf() < J.mul(_s44["dt"], 14.0)) if _t189 else _t189):
		v_a_210 = ((randf() - 0.5) * 2.0)
		v_b_211 = ((randf() - 0.5) * 2.0)
		var _t190 = J.gp(_s44["__p"]["K"], "keys")
		J.mc(_t190, "push", [{"u": J.div(((375.0 + J.mul(v_a_210, 80.0)) - J.mul(v_b_211, 5.0)), 567.0), "v": J.div(((47.0 + J.mul(v_a_210, 25.0)) + J.mul(v_b_211, 15.0)), 435.0), "life": 0.18}])
	var _t191 = _s44["__p"]["K"]
	var _t192 = J.gp(_s44["__p"]["K"], "keys")
	var _t194 = J.mc(_t192, "filter", [Callable(self, "_f28").bind(_s44)])
	J.sp(_t191, "keys", _t194)

func _f30(this_, a: Array, env):
	var v_q_220 = null
	v_q_220 = J.arg(a, 0)
	var _t217 = J.sub(J.gp(v_q_220, "at"), env["dt"])
	J.sp(v_q_220, "at", _t217)
	if J.cmp(J.gp(v_q_220, "at"), 0.0, ">"):
		return true
	if J.t(J.gp(v_q_220, "clock")):
		if (not J.t(J.gp(env["__p"]["st"], "clockF"))):
			var _t218 = env["__p"]["st"]
			var _t219 = {"t": 0.0, "z": 0.15, "vz": 0.0, "rot": 0.0, "b": 0.0, "rest": 0.0}
			J.sp(_t218, "clockF", _t219)
	else:
		var _t220 = env["__p"]["startFall"]
		J.cl(_t220, null, [J.gp(env["__p"]["items"], J.gp(v_q_220, "id")), J.gp(v_q_220, "dir"), 0.15])
	return false

func _f31(this_, a: Array, env):
	var v_p_226 = null
	v_p_226 = J.arg(a, 0)
	return (not J.t(J.gp(v_p_226, "landed")))

func _f32(this_, a: Array, env):
	var v_p_227 = null
	v_p_227 = J.arg(a, 0)
	var _t281 = J.sub(J.gp(v_p_227, "life"), env["dt"])
	J.sp(v_p_227, "life", _t281)
	return (_t281 > 0.0)

func _f33(this_, a: Array, env):
	var v_p_228 = null
	v_p_228 = J.arg(a, 0)
	var _t283 = J.sub(J.gp(v_p_228, "life"), env["dt"])
	J.sp(v_p_228, "life", _t283)
	return (_t283 > 0.0)

func _f29(this_, a: Array, env):
	var v_t_216 = null; var v_f_217 = null; var v_L_218 = null; var v_C_219 = null; var v_F_221 = null; var v_k_222 = null; var v_m_223 = null; var v_c_224 = null; var v_p_225 = null; var v_d_229 = null
	var _s67 = {"__p": env, "dt": null}
	_s67["dt"] = J.arg(a, 0)
	if (not J.t(_s67["__p"]["st"])):
		return null
	var _t195 = _s67["__p"]["st"]
	var _t196 = J.add(J.gp(_t195, "t"), _s67["dt"])
	J.sp(_t195, "t", _t196)
	v_t_216 = J.gp(_s67["__p"]["st"], "t")
	v_f_217 = J.gp(_s67["__p"]["st"], "fan")
	var _t197 = J.max_([0.0, J.sub(J.gp(v_f_217, "boost"), J.mul(_s67["dt"], 0.18))])
	J.sp(v_f_217, "boost", _t197)
	var _t198 = J.add(J.gp(v_f_217, "osc"), J.mul(_s67["dt"], (0.55 + J.mul(J.gp(v_f_217, "boost"), 1.6))))
	J.sp(v_f_217, "osc", _t198)
	var _t199 = J.add(J.gp(v_f_217, "spin"), J.mul(_s67["dt"], (9.0 + J.mul(J.gp(v_f_217, "boost"), 28.0))))
	J.sp(v_f_217, "spin", _t199)
	var _t200 = J.gp(_s67["__p"]["st"], "clock")
	var _t201 = J.max_([0.0, J.sub(J.gp(J.gp(_s67["__p"]["st"], "clock"), "spin"), _s67["dt"])])
	J.sp(_t200, "spin", _t201)
	var _t202 = J.gp(_s67["__p"]["st"], "clock")
	var _t203 = J.add(J.gp(_t202, "ang"), (J.mul(_s67["dt"], J.gp(J.gp(_s67["__p"]["st"], "clock"), "spin")) * 14.0))
	J.sp(_t202, "ang", _t203)
	v_L_218 = J.gp(_s67["__p"]["st"], "lamp")
	var _t204 = J.max_([0.0, J.sub(J.gp(v_L_218, "flick"), _s67["dt"])])
	J.sp(v_L_218, "flick", _t204)
	var _t205 = J.add(J.gp(v_L_218, "vs"), J.mul((((-J.num(J.gp(v_L_218, "sway"))) * 60.0) - J.mul(J.gp(v_L_218, "vs"), 4.0)), _s67["dt"]))
	J.sp(v_L_218, "vs", _t205)
	var _t206 = J.add(J.gp(v_L_218, "sway"), J.mul(J.gp(v_L_218, "vs"), _s67["dt"]))
	J.sp(v_L_218, "sway", _t206)
	var _t207 = J.gp(_s67["__p"]["st"], "ac")
	var _t208 = J.max_([0.0, J.sub(J.gp(J.gp(_s67["__p"]["st"], "ac"), "blow"), _s67["dt"])])
	J.sp(_t207, "blow", _t208)
	var _t209 = J.gp(_s67["__p"]["st"], "water")
	var _t210 = J.max_([0.0, J.sub(J.gp(J.gp(_s67["__p"]["st"], "water"), "glug"), _s67["dt"])])
	J.sp(_t209, "glug", _t210)
	var _t211 = _s67["__p"]["st"]
	var _t212 = J.max_([0.0, J.sub(J.gp(_s67["__p"]["st"], "rustle"), J.mul(_s67["dt"], 0.8))])
	J.sp(_t211, "rustle", _t212)
	var _t213 = _s67["__p"]["st"]
	var _t214 = J.max_([0.0, J.sub(J.gp(_s67["__p"]["st"], "flutter"), J.mul(_s67["dt"], 0.7))])
	J.sp(_t213, "flutter", _t214)
	var _t215 = _s67["__p"]["st"]
	var _t216 = J.gp(_s67["__p"]["st"], "dropQ")
	var _t221 = J.mc(_t216, "filter", [Callable(self, "_f30").bind(_s67)])
	J.sp(_t215, "dropQ", _t221)
	if J.t(J.gp(_s67["__p"]["st"], "clockF")):
		v_F_221 = J.gp(_s67["__p"]["st"], "clockF")
		var _t222 = J.add(J.gp(v_F_221, "t"), _s67["dt"])
		J.sp(v_F_221, "t", _t222)
		if J.cmp(J.gp(v_F_221, "t"), 0.3, ">"):
			var _t223 = J.sub(J.gp(v_F_221, "vz"), J.mul(1.3, _s67["dt"]))
			J.sp(v_F_221, "vz", _t223)
			var _t224 = J.add(J.gp(v_F_221, "z"), J.mul(J.gp(v_F_221, "vz"), _s67["dt"]))
			J.sp(v_F_221, "z", _t224)
			var _t225 = J.add(J.gp(v_F_221, "rot"), (J.mul(_s67["dt"], 3.0) * (1.0 if J.cmp(J.gp(v_F_221, "z"), 0.0, ">") else 0.0)))
			J.sp(v_F_221, "rot", _t225)
		if J.cmp(J.gp(v_F_221, "z"), 0.0, "<="):
			J.sp(v_F_221, "z", 0.0)
			if J.leq(J.gp(v_F_221, "land"), null):
				var _t226 = J.gp(v_F_221, "t")
				J.sp(v_F_221, "land", _t226)
			var _t227 = (absf(J.num(J.gp(v_F_221, "vz"))) > 0.08)
			if (J.cmp(J.gp(v_F_221, "b"), 1.0, "<") if _t227 else _t227):
				var _t228 = ((-J.num(J.gp(v_F_221, "vz"))) * 0.3)
				J.sp(v_F_221, "vz", _t228)
				J.sp(v_F_221, "b", J.num(J.gp(v_F_221, "b")) + 1.0)
			else:
				J.sp(v_F_221, "vz", 0.0)
				var _t229 = J.add(J.gp(v_F_221, "rest"), _s67["dt"])
				J.sp(v_F_221, "rest", _t229)
				var _t230 = _s67["__p"]["lerp"]
				var _t231 = J.cl(_t230, null, [J.gp(v_F_221, "rot"), 1.35, (1.0 - exp(J.num(((-J.num(_s67["dt"])) * 8.0))))])
				J.sp(v_F_221, "rot", _t231)
		if J.cmp(J.gp(v_F_221, "rest"), 11.0, ">"):
			var _t232 = _s67["__p"]["st"]
			J.sp(_t232, "clockF", null)
			var _t233 = _s67["__p"]["st"]
			J.sp(_t233, "clockBack", 0.6)
	var _t234 = _s67["__p"]["st"]
	var _t235 = J.gp(_s67["__p"]["st"], "clockBack")
	var _t236 = J.gp(_s67["__p"]["st"], "clockBack")
	var _t237 = J.max_([0.0, J.sub((_t236 if J.t(_t236) else 0.0), _s67["dt"])])
	J.sp(_t234, "clockBack", _t237)
	if J.t(J.gp(_s67["__p"]["st"], "lights")):
		var _t238 = J.gp(_s67["__p"]["st"], "lights")
		var _t239 = J.add(J.gp(_t238, "t"), _s67["dt"])
		J.sp(_t238, "t", _t239)
		if J.cmp(J.gp(J.gp(_s67["__p"]["st"], "lights"), "t"), 3.6, ">"):
			var _t240 = _s67["__p"]["st"]
			J.sp(_t240, "lights", null)
	var _t241 = _s67["__p"]["st"]
	var _t242 = J.max_([0.0, J.sub(J.gp(_s67["__p"]["st"], "chairSpin"), _s67["dt"])])
	J.sp(_t241, "chairSpin", _t242)
	var _t243 = _s67["__p"]["st"]
	var _t244 = J.max_([0.0, J.sub(J.gp(_s67["__p"]["st"], "creak"), _s67["dt"])])
	J.sp(_t243, "creak", _t244)
	v_C_219 = J.gp(_s67["__p"]["st"], "copier")
	var _t245 = J.max_([0.0, J.sub(J.gp(v_C_219, "print"), _s67["dt"])])
	J.sp(v_C_219, "print", _t245)
	var _t246 = J.gp(v_C_219, "idle")
	var _t247 = J.gp(v_C_219, "idle")
	var _t248 = J.max_([0.0, J.sub((_t247 if J.t(_t247) else 0.0), _s67["dt"])])
	J.sp(v_C_219, "idle", _t248)
	var _t249 = _s67["__p"]["st"]
	var _t250 = J.gp(_s67["__p"]["st"], "door")
	var _t251 = J.gp(_s67["__p"]["st"], "door")
	var _t252 = J.max_([0.0, J.sub((_t251 if J.t(_t251) else 0.0), _s67["dt"])])
	J.sp(_t249, "door", _t252)
	if J.cmp(J.gp(v_C_219, "print"), 0.2, ">"):
		var _t253 = J.sub(J.gp(v_C_219, "out"), _s67["dt"])
		J.sp(v_C_219, "out", _t253)
		if J.cmp(J.gp(v_C_219, "out"), 0.0, "<="):
			var _t254 = (0.12 + (randf() * 0.1))
			J.sp(v_C_219, "out", _t254)
			J.cl(_s67["__p"]["copierPaper"], null, [])
	for _t255 in J.keys(_s67["__p"]["STATIONS"]):
		v_k_222 = _t255
		v_m_223 = J.gp(J.gp(_s67["__p"]["STATIONS"], v_k_222), "monSt")
		if J.t((J.cmp(J.gp(v_m_223, "seq"), 0.0, ">=") if J.t(v_m_223) else v_m_223)):
			var _t256 = J.add(J.gp(v_m_223, "seq"), _s67["dt"])
			J.sp(v_m_223, "seq", _t256)
			if J.cmp(J.gp(v_m_223, "seq"), 1.7, ">"):
				var _t257 = (-1.0)
				J.sp(v_m_223, "seq", _t257)
	if (randf() < J.mul(_s67["dt"], 0.25)):
		var _t258 = _s67["__p"]["st"]
		J.sp(_t258, "tubes", 0.25)
	var _t259 = _s67["__p"]["st"]
	var _t260 = J.max_([0.0, J.sub(J.gp(_s67["__p"]["st"], "tubes"), _s67["dt"])])
	J.sp(_t259, "tubes", _t260)
	for _t261 in J.iter(J.mc(_s67["__p"]["kids"], "concat", [_s67["__p"]["list"]])):
		v_c_224 = _t261
		var _t264 = J.gp(v_c_224, "vr")
		if not J.t(_t264):
			var _t263 = J.gp(v_c_224, "rot")
			var _t262 = J.gp(v_c_224, "base")
			_t264 = (not J.seq(_t263, (_t262 if J.t(_t262) else 0.0)))
		if J.t(_t264):
			var _t266 = J.gp(v_c_224, "rot")
			var _t265 = J.gp(v_c_224, "base")
			var _t267 = J.add(J.gp(v_c_224, "vr"), J.mul((((-J.sub(_t266, (_t265 if J.t(_t265) else 0.0))) * (90.0 if J.t(J.gp(v_c_224, "mug")) else 40.0)) - J.mul(J.gp(v_c_224, "vr"), (5.0 if J.t(J.gp(v_c_224, "mug")) else 3.0))), _s67["dt"]))
			J.sp(v_c_224, "vr", _t267)
			var _t268 = J.add(J.gp(v_c_224, "rot"), J.mul(J.gp(v_c_224, "vr"), _s67["dt"]))
			J.sp(v_c_224, "rot", _t268)
			var _t271 = (absf(J.num(J.gp(v_c_224, "vr"))) < 0.001)
			if J.t(_t271):
				var _t270 = J.gp(v_c_224, "rot")
				var _t269 = J.gp(v_c_224, "base")
				_t271 = (absf(J.num(J.sub(_t270, (_t269 if J.t(_t269) else 0.0)))) < 0.001)
			if _t271:
				J.sp(v_c_224, "vr", 0.0)
				var _t272 = J.gp(v_c_224, "base")
				var _t273 = (_t272 if J.t(_t272) else 0.0)
				J.sp(v_c_224, "rot", _t273)
		if J.cmp(J.gp(v_c_224, "hide"), 0.0, ">"):
			var _t274 = J.max_([0.0, J.sub(J.gp(v_c_224, "hide"), _s67["dt"])])
			J.sp(v_c_224, "hide", _t274)
		if J.t(J.gp(v_c_224, "falling")):
			var _t275 = _s67["__p"]["fallTick"]
			J.cl(_t275, null, [v_c_224, _s67["dt"]])
		var _t276 = J.gp(v_c_224, "chair")
		if J.t((J.leq(J.gp(v_c_224, "parent"), null) if J.t(_t276) else _t276)):
			var _t277 = _s67["__p"]["chairTick"]
			J.cl(_t277, null, [v_c_224, _s67["dt"]])
	for _t278 in J.iter(_s67["__p"]["flying"]):
		v_p_225 = _t278
		var _t279 = _s67["__p"]["paperTick"]
		J.cl(_t279, null, [v_p_225, _s67["dt"]])
	var _t280 = J.mc(_s67["__p"]["flying"], "filter", [Callable(self, "_f31").bind(_s67)])
	_s67["__p"]["flying"] = _t280
	var _t282 = J.mc(_s67["__p"]["floor"], "filter", [Callable(self, "_f32").bind(_s67)])
	_s67["__p"]["floor"] = _t282
	var _t284 = J.mc(_s67["__p"]["drops"], "filter", [Callable(self, "_f33").bind(_s67)])
	_s67["__p"]["drops"] = _t284
	for _t285 in J.iter(_s67["__p"]["drops"]):
		v_d_229 = _t285
		if (not J.t(J.gp(v_d_229, "land"))):
			var _t286 = J.sub(J.gp(v_d_229, "vz"), J.mul(2.2, _s67["dt"]))
			J.sp(v_d_229, "vz", _t286)
			var _t287 = J.add(J.gp(v_d_229, "z"), J.mul(J.gp(v_d_229, "vz"), _s67["dt"]))
			J.sp(v_d_229, "z", _t287)
			var _t288 = J.add(J.gp(v_d_229, "ox"), J.mul(J.gp(v_d_229, "vx"), _s67["dt"]))
			J.sp(v_d_229, "ox", _t288)
			if J.cmp(J.gp(v_d_229, "z"), 0.0, "<="):
				J.sp(v_d_229, "z", 0.0)
				J.sp(v_d_229, "land", true)

func _f34(this_, a: Array, env):
	var v_x_232 = null; var v_y_233 = null; var v_b_234 = null; var v_bd_235 = null; var v_n_236 = null; var v_d_237 = null
	v_x_232 = J.arg(a, 0)
	v_y_233 = J.arg(a, 1)
	v_b_234 = null
	v_bd_235 = 9.0
	var _t290 = J.gp(env["SC"], "npcs")
	for _t289 in J.iter((_t290 if J.t(_t290) else [])):
		v_n_236 = _t289
		if J.t(J.gp(v_n_236, "gone")):
			continue
		v_d_237 = J.hypot_([J.sub(J.gp(v_n_236, "x"), v_x_232), J.sub(J.gp(v_n_236, "y"), v_y_233)])
		if J.cmp(v_d_237, v_bd_235, "<"):
			v_bd_235 = v_d_237
			v_b_234 = v_n_236
	return v_b_234

func _f35(this_, a: Array, env):
	var v_ch_240 = null; var v_x_241 = null; var v_y_242 = null; var v_dt_243 = null; var v_maxOz_244 = null; var v_k_245 = null; var v_n_246 = null; var v_dx_247 = null; var v_dy_248 = null; var v_d_249 = null
	v_ch_240 = J.arg(a, 0)
	v_x_241 = J.arg(a, 1)
	v_y_242 = J.arg(a, 2)
	v_dt_243 = J.arg(a, 3)
	v_maxOz_244 = J.arg(a, 4)
	if J.cmp(J.gp(env["st"], "chairSpin"), 0.0, "<="):
		return null
	v_k_245 = J.min_([1.0, J.div(J.gp(env["st"], "chairSpin"), 0.6)])
	var _t291 = env["nearestTo"]
	v_n_246 = J.cl(_t291, null, [v_x_241, v_y_242])
	var _t292 = ((1.0 if J.cmp(J.gp(v_ch_240, "vs"), 0.0, ">=") else (-1.0)) * J.max_([absf(J.num(J.gp(v_ch_240, "vs"))), (J.mul(7.0, v_k_245) + 1.0)]))
	J.sp(v_ch_240, "vs", _t292)
	if J.t(v_n_246):
		v_dx_247 = J.sub(J.gp(v_n_246, "x"), v_x_241)
		v_dy_248 = J.sub(J.gp(v_n_246, "y"), v_y_242)
		var _t293 = J.hypot_([v_dx_247, v_dy_248])
		v_d_249 = (_t293 if J.t(_t293) else 1.0)
		if J.cmp(v_d_249, 0.08, ">"):
			var _t294 = J.add(J.gp(v_ch_240, "vx"), J.mul(J.mul((J.div(v_dx_247, v_d_249) * 0.09), v_k_245), v_dt_243))
			J.sp(v_ch_240, "vx", _t294)
			var _t295 = J.gp(v_ch_240, "vz")
			var _t296 = J.add((_t295 if J.t(_t295) else 0.0), J.mul(J.mul((J.div(v_dy_248, v_d_249) * 0.05), v_k_245), v_dt_243))
			J.sp(v_ch_240, "vz", _t296)

func _f36(this_, a: Array, env):
	var v_c_252 = null; var v_dt_253 = null
	v_c_252 = J.arg(a, 0)
	v_dt_253 = J.arg(a, 1)
	var _t297 = J.gp(v_c_252, "vx")
	var _t298 = (_t297 if J.t(_t297) else 0.0)
	J.sp(v_c_252, "vx", _t298)
	var _t299 = J.gp(v_c_252, "vs")
	var _t300 = (_t299 if J.t(_t299) else 0.0)
	J.sp(v_c_252, "vs", _t300)
	var _t301 = J.gp(v_c_252, "sw")
	var _t302 = (_t301 if J.t(_t301) else 0.0)
	J.sp(v_c_252, "sw", _t302)
	var _t303 = J.gp(v_c_252, "ox")
	var _t304 = (_t303 if J.t(_t303) else 0.0)
	J.sp(v_c_252, "ox", _t304)
	var _t305 = J.gp(v_c_252, "oz")
	var _t306 = (_t305 if J.t(_t305) else 0.0)
	J.sp(v_c_252, "oz", _t306)
	var _t307 = J.gp(v_c_252, "vz")
	var _t308 = (_t307 if J.t(_t307) else 0.0)
	J.sp(v_c_252, "vz", _t308)
	var _t309 = env["selfSpin"]
	J.cl(_t309, null, [v_c_252, J.add(J.gp(v_c_252, "x"), J.gp(v_c_252, "ox")), J.add(J.gp(v_c_252, "y"), J.gp(v_c_252, "oz")), v_dt_253])
	var _t310 = J.add(J.gp(v_c_252, "ox"), J.mul(J.gp(v_c_252, "vx"), v_dt_253))
	J.sp(v_c_252, "ox", _t310)
	var _t311 = J.mul(J.gp(v_c_252, "vx"), exp(J.num(((-J.num(v_dt_253)) * (0.6 if J.cmp(J.gp(env["st"], "chairSpin"), 0.0, ">") else 2.2)))))
	J.sp(v_c_252, "vx", _t311)
	var _t312 = J.add(J.gp(v_c_252, "sw"), J.mul(J.gp(v_c_252, "vs"), v_dt_253))
	J.sp(v_c_252, "sw", _t312)
	var _t313 = J.mul(J.gp(v_c_252, "vs"), exp(J.num(((-J.num(v_dt_253)) * (0.2 if J.cmp(J.gp(env["st"], "chairSpin"), 0.0, ">") else 1.5)))))
	J.sp(v_c_252, "vs", _t313)
	var _t314 = J.add(J.gp(v_c_252, "oz"), J.mul(J.gp(v_c_252, "vz"), v_dt_253))
	J.sp(v_c_252, "oz", _t314)
	var _t315 = J.mul(J.gp(v_c_252, "vz"), exp(J.num(((-J.num(v_dt_253)) * 1.2))))
	J.sp(v_c_252, "vz", _t315)
	var _t316 = env["cl"]
	var _t317 = J.cl(_t316, null, [J.gp(v_c_252, "oz"), (-0.01), 0.1])
	J.sp(v_c_252, "oz", _t317)
	var _t318 = env["cl"]
	var _t319 = J.cl(_t318, null, [J.gp(v_c_252, "ox"), (-0.12), 0.2])
	J.sp(v_c_252, "ox", _t319)
	if J.cmp(J.gp(env["st"], "chairSpin"), 0.0, "<="):
		var _t320 = J.add(J.gp(v_c_252, "ox"), (J.mul((-J.num(J.gp(v_c_252, "ox"))), v_dt_253) * 0.25))
		J.sp(v_c_252, "ox", _t320)
		var _t321 = J.add(J.gp(v_c_252, "oz"), (J.mul((-J.num(J.gp(v_c_252, "oz"))), v_dt_253) * 0.25))
		J.sp(v_c_252, "oz", _t321)
	if (absf(J.num(J.gp(v_c_252, "vs"))) < 0.6):
		var _t322 = env["lerp"]
		var _t323 = J.cl(_t322, null, [J.gp(v_c_252, "sw"), J.mul((J.round(J.num(J.div(J.gp(v_c_252, "sw"), J.mul(2.0, env["PI"])))) * 2.0), env["PI"]), (1.0 - exp(J.num(((-J.num(v_dt_253)) * 2.0))))])
		J.sp(v_c_252, "sw", _t323)

func _f37(this_, a: Array, env):
	var v_c_256 = null; var v_dir_257 = null; var v_kick_258 = null; var v_p_259 = null; var v_fv_260 = null
	v_c_256 = J.arg(a, 0)
	v_dir_257 = J.arg(a, 1)
	v_kick_258 = J.arg(a, 2)
	var _t324 = (not J.t(v_c_256))
	var _t325 = (_t324 if _t324 else J.gp(v_c_256, "falling"))
	if J.t((_t325 if J.t(_t325) else J.cmp(J.gp(v_c_256, "hide"), 0.0, ">"))):
		return null
	v_p_259 = J.gp(v_c_256, "parent")
	v_fv_260 = (J.gp(v_p_259, "floorV") if (not J.leq(J.gp(v_p_259, "floorV"), null)) else J.gp(v_p_259, "ay"))
	var _t326 = {"t": 0.0, "z": J.max_([0.05, J.mul(J.sub(v_fv_260, J.gp(v_c_256, "v")), J.gp(v_p_259, "h"))]), "vz": J.add(0.25, (v_kick_258 if J.t(v_kick_258) else 0.0)), "vx": J.mul(v_dir_257, (0.18 + (randf() * 0.15))), "x": 0.0, "dir": v_dir_257, "b": 0.0, "tip": (0.25 if J.seq(J.gp(v_c_256, "spr"), "op_binder") else 0.12), "off": false, "land": (-1.0)}
	J.sp(v_c_256, "falling", _t326)

func _f38(this_, a: Array, env):
	var v_c_263 = null; var v_dt_264 = null; var v_F_265 = null
	v_c_263 = J.arg(a, 0)
	v_dt_264 = J.arg(a, 1)
	v_F_265 = J.gp(v_c_263, "falling")
	var _t327 = J.add(J.gp(v_F_265, "t"), v_dt_264)
	J.sp(v_F_265, "t", _t327)
	if J.cmp(J.gp(v_F_265, "t"), J.gp(v_F_265, "tip"), "<"):
		var _t330 = J.gp(v_c_263, "base")
		var _t329 = J.gp(v_F_265, "dir")
		var _t328 = env["ss"]
		var _t331 = J.add(_t330, (J.mul(_t329, J.cl(_t328, null, [J.div(J.gp(v_F_265, "t"), J.gp(v_F_265, "tip"))])) * 0.5))
		J.sp(v_c_263, "rot", _t331)
		return null
	J.sp(v_F_265, "off", true)
	var _t332 = J.sub(J.gp(v_F_265, "vz"), J.mul(6.0, v_dt_264))
	J.sp(v_F_265, "vz", _t332)
	var _t333 = J.add(J.gp(v_F_265, "z"), J.mul(J.gp(v_F_265, "vz"), v_dt_264))
	J.sp(v_F_265, "z", _t333)
	var _t334 = J.add(J.gp(v_F_265, "x"), J.mul(J.gp(v_F_265, "vx"), v_dt_264))
	J.sp(v_F_265, "x", _t334)
	var _t335 = J.add(J.gp(v_c_263, "rot"), (J.mul(J.mul(J.gp(v_F_265, "dir"), 7.0), v_dt_264) * (1.0 if J.cmp(J.gp(v_F_265, "z"), 0.0, ">") else 0.0)))
	J.sp(v_c_263, "rot", _t335)
	if J.cmp(J.gp(v_F_265, "z"), 0.0, "<="):
		J.sp(v_F_265, "z", 0.0)
		if J.cmp(J.gp(v_F_265, "land"), 0.0, "<"):
			var _t336 = J.gp(v_F_265, "t")
			J.sp(v_F_265, "land", _t336)
		var _t337 = (absf(J.num(J.gp(v_F_265, "vz"))) > 0.5)
		if (J.cmp(J.gp(v_F_265, "b"), 1.0, "<") if _t337 else _t337):
			var _t338 = ((-J.num(J.gp(v_F_265, "vz"))) * 0.3)
			J.sp(v_F_265, "vz", _t338)
			J.sp(v_F_265, "b", J.num(J.gp(v_F_265, "b")) + 1.0)
		else:
			J.sp(v_F_265, "vz", 0.0)
			var _t339 = J.mul(J.gp(v_F_265, "vx"), exp(J.num(((-J.num(v_dt_264)) * 8.0))))
			J.sp(v_F_265, "vx", _t339)
			var _t340 = J.gp(v_F_265, "rest")
			var _t341 = J.add((_t340 if J.t(_t340) else 0.0), v_dt_264)
			J.sp(v_F_265, "rest", _t341)
			var _t342 = env["lerp"]
			var _t343 = J.cl(_t342, null, [J.gp(v_c_263, "rot"), J.mul(J.gp(v_F_265, "dir"), (J.div(env["PI"], 2.0) if J.t(J.gp(v_c_263, "mug")) else (0.15 if J.seq(J.gp(v_c_263, "spr"), "op_stack") else J.div(env["PI"], 2.0)))), (1.0 - exp(J.num(((-J.num(v_dt_264)) * 10.0))))])
			J.sp(v_c_263, "rot", _t343)
	if J.cmp(J.gp(v_F_265, "rest"), 11.0, ">"):
		J.sp(v_c_263, "falling", null)
		var _t344 = J.gp(v_c_263, "base")
		J.sp(v_c_263, "rot", _t344)
		J.sp(v_c_263, "hide", 0.6)

func _f39(this_, a: Array, env):
	var v_p_268 = null; var v_dt_269 = null
	v_p_268 = J.arg(a, 0)
	v_dt_269 = J.arg(a, 1)
	var _t345 = J.add(J.gp(v_p_268, "t"), v_dt_269)
	J.sp(v_p_268, "t", _t345)
	var _t346 = J.sub(J.gp(v_p_268, "vz"), J.mul(1.1, v_dt_269))
	J.sp(v_p_268, "vz", _t346)
	var _t347 = J.max_([J.gp(v_p_268, "vz"), (-0.25)])
	J.sp(v_p_268, "vz", _t347)
	var _t348 = J.add(J.gp(v_p_268, "z"), J.mul(J.gp(v_p_268, "vz"), v_dt_269))
	J.sp(v_p_268, "z", _t348)
	var _t349 = J.add(J.gp(v_p_268, "x"), J.mul(J.add(J.gp(v_p_268, "vx"), (sin(J.num(J.add(J.mul(J.gp(v_p_268, "t"), 4.0), J.gp(v_p_268, "ph")))) * 0.05)), v_dt_269))
	J.sp(v_p_268, "x", _t349)
	var _t350 = J.add(J.gp(v_p_268, "y"), J.mul(J.gp(v_p_268, "vy"), v_dt_269))
	J.sp(v_p_268, "y", _t350)
	var _t351 = J.mul(J.gp(v_p_268, "vx"), exp(J.num(((-J.num(v_dt_269)) * 0.8))))
	J.sp(v_p_268, "vx", _t351)
	var _t352 = J.add(J.gp(v_p_268, "rot"), J.mul(J.gp(v_p_268, "vr"), v_dt_269))
	J.sp(v_p_268, "rot", _t352)
	var _t353 = J.mul(J.gp(v_p_268, "vr"), exp(J.num(((-J.num(v_dt_269)) * 0.6))))
	J.sp(v_p_268, "vr", _t353)
	if J.cmp(J.gp(v_p_268, "z"), 0.0, "<="):
		J.sp(v_p_268, "landed", true)
		J.mc(env["floor"], "push", [{"x": J.gp(v_p_268, "x"), "y": J.gp(v_p_268, "y"), "rot": J.mul(J.gp(v_p_268, "rot"), 0.3), "life": 14.0, "max": 14.0, "w": J.mul(J.gp(v_p_268, "w"), 1.3)}])

func _f40(this_, a: Array, env):
	var v_c_272 = null; var v_x0_273 = null
	v_c_272 = J.gp(env["items"], "copier")
	var _t356 = J.gp(v_c_272, "x")
	var _t355 = (0.33 * 0.74)
	var _t354 = env["UW"]
	var _t357 = [J.sub(_t356, J.mul(_t355, J.cl(_t354, null, [J.gp(v_c_272, "y")])))]
	var _t358 = J.gp(_t357, 0.0)
	v_x0_273 = _t358
	J.mc(env["flying"], "push", [{"x": v_x0_273, "y": J.add(J.gp(v_c_272, "y"), 0.004), "z": 0.42, "vx": ((-0.05) - (randf() * 0.1)), "vy": (0.02 + (randf() * 0.05)), "vz": (0.25 + (randf() * 0.3)), "rot": (randf() * 6.0), "vr": ((randf() - 0.5) * 9.0), "t": 0.0, "ph": (randf() * 6.0), "w": 0.16}])

func _f41(this_, a: Array, env):
	var v_c_276 = null; var v_pow_277 = null; var v_p_278 = null; var v_x_279 = null; var v_y_280 = null
	v_c_276 = J.arg(a, 0)
	v_pow_277 = J.arg(a, 1)
	var _t359 = J.cmp(J.gp(v_c_276, "hide"), 0.0, ">")
	if (_t359 if _t359 else J.cmp(J.gp(v_c_276, "flown"), 0.0, ">")):
		return null
	v_p_278 = J.gp(v_c_276, "parent")
	var _t366 = J.gp(v_p_278, "x")
	var _t361 = J.mul(J.sub(J.gp(v_c_276, "u"), J.gp(v_p_278, "ax")), J.gp(v_p_278, "h"))
	var _t360 = env["UW"]
	var _t363 = J.mul(_t361, J.cl(_t360, null, [J.gp(v_p_278, "y")]))
	var _t362 = env["img"]
	var _t365 = J.mul(_t363, J.gp(J.cl(_t362, null, [J.gp(v_p_278, "spr")]), "width"))
	var _t364 = env["img"]
	var _t367 = [J.add(_t366, J.div(_t365, J.gp(J.cl(_t364, null, [J.gp(v_p_278, "spr")]), "height"))), J.gp(v_p_278, "y")]
	var _t368 = J.gp(_t367, 0.0)
	v_x_279 = _t368
	var _t369 = J.gp(_t367, 1.0)
	v_y_280 = _t369
	J.mc(env["flying"], "push", [{"x": v_x_279, "y": J.add(v_y_280, 0.004), "z": 0.47, "vx": J.mul(((randf() - 0.5) * 0.25), v_pow_277), "vy": (0.03 + (randf() * 0.04)), "vz": (0.3 + J.mul((randf() * 0.4), v_pow_277)), "rot": J.gp(v_c_276, "rot"), "vr": ((randf() - 0.5) * 12.0), "t": 0.0, "ph": (randf() * 6.0), "w": 0.15}])
	J.sp(v_c_276, "hide", 16.0)

func _f42(this_, a: Array, env):
	var v_m_283 = null; var v_pow_284 = null; var v_p_285 = null; var v_i_286 = null
	v_m_283 = J.arg(a, 0)
	v_pow_284 = J.arg(a, 1)
	var _t370 = (not J.t(v_m_283))
	if (_t370 if _t370 else J.cmp(J.gp(v_m_283, "hide"), 0.0, ">")):
		return null
	var _t371 = J.add(J.gp(v_m_283, "vr"), (((-1.0) if (randf() < 0.5) else 1.0) * (4.0 + J.mul(v_pow_284, 8.0))))
	J.sp(v_m_283, "vr", _t371)
	if J.cmp(v_pow_284, 0.7, "<"):
		return null
	v_p_285 = J.gp(v_m_283, "parent")
	v_i_286 = 0.0
	while true:
		if not J.cmp(v_i_286, 7.0, "<"): break
		J.mc(env["drops"], "push", [{"u": J.gp(v_m_283, "u"), "v": J.gp(v_m_283, "v"), "ox": 0.0, "z": 0.06, "vx": ((randf() - 0.5) * 0.25), "vz": (0.25 + (randf() * 0.3)), "life": 2.5, "desk": v_p_285}])
		v_i_286 = J.num(v_i_286) + 1.0
	J.sp(v_m_283, "puddle", 6.0)

func _f44(this_, a: Array, env):
	var v_it_294 = null; var v_r_295 = null
	v_it_294 = J.arg(a, 0)
	v_r_295 = J.arg(a, 1)
	return J.cmp(J.hypot_([J.sub(J.gp(v_it_294, "x"), env["x"]), (J.sub(J.gp(v_it_294, "y"), env["y"]) * 1.6)]), v_r_295, "<")

func _f45(this_, a: Array, env):
	if (not J.t(J.gp(J.gp(env["__p"]["K"], "ch"), "occ"))):
		var _t401 = J.gp(env["__p"]["K"], "ch")
		var _t402 = J.sub(J.add(J.gp(env["__p"]["SEATV"], "x"), J.gp(J.gp(env["__p"]["K"], "ch"), "dx")), env["x"])
		var _t403 = J.add(J.gp(_t401, "vx"), J.mul((signf(J.num((_t402 if J.t(_t402) else 1.0))) * 0.08), env["pow"]))
		J.sp(_t401, "vx", _t403)
		var _t404 = J.gp(env["__p"]["K"], "ch")
		var _t405 = J.add(J.gp(_t404, "vs"), J.mul(((randf() - 0.5) * 8.0), env["pow"]))
		J.sp(_t404, "vs", _t405)

func _f43(this_, a: Array, env):
	var v_near_292 = null; var v_a_293 = null; var v_c_296 = null; var v_p_297 = null
	var _s115 = {"__p": env, "x": null, "y": null, "pow": null}
	_s115["x"] = J.arg(a, 0)
	_s115["y"] = J.arg(a, 1)
	_s115["pow"] = J.arg(a, 2)
	if (not J.t(_s115["__p"]["st"])):
		return null
	var _t372 = _s115["__p"]["cl"]
	var _t373 = J.cl(_t372, null, [_s115["pow"], 0.0, 1.2])
	_s115["pow"] = _t373
	v_near_292 = Callable(self, "_f44").bind(_s115)
	var _t374 = J.gp(_s115["__p"]["st"], "fan")
	var _t375 = J.min_([1.5, J.add(J.gp(J.gp(_s115["__p"]["st"], "fan"), "boost"), J.mul(_s115["pow"], 0.8))])
	J.sp(_t374, "boost", _t375)
	var _t376 = J.gp(_s115["__p"]["st"], "clock")
	var _t377 = J.max_([J.gp(J.gp(_s115["__p"]["st"], "clock"), "spin"), J.add(1.2, _s115["pow"])])
	J.sp(_t376, "spin", _t377)
	var _t378 = _s115["__p"]["st"]
	var _t379 = J.max_([J.gp(_s115["__p"]["st"], "flutter"), _s115["pow"]])
	J.sp(_t378, "flutter", _t379)
	for _t380 in J.iter(_s115["__p"]["kids"]):
		v_c_296 = _t380
		v_p_297 = J.gp(v_c_296, "parent")
		if (not J.t(J.cl(v_near_292, null, [v_p_297, 0.42]))):
			continue
		if J.t(J.gp(v_c_296, "paper")):
			if J.cmp(_s115["pow"], 0.55, ">"):
				var _t381 = _s115["__p"]["paperFly"]
				J.cl(_t381, null, [v_c_296, _s115["pow"]])
			else:
				var _t382 = J.add(J.gp(v_c_296, "vr"), J.mul(((randf() - 0.5) * 6.0), _s115["pow"]))
				J.sp(v_c_296, "vr", _t382)
		if J.t(J.gp(v_c_296, "mug")):
			var _t383 = _s115["__p"]["spill"]
			J.cl(_t383, null, [v_c_296, _s115["pow"]])
		var _t384 = J.gp(v_c_296, "mon")
		var _t385 = (J.cmp(_s115["pow"], 0.3, ">") if J.t(_t384) else _t384)
		if J.t((J.gp(v_c_296, "stn") if J.t(_t385) else _t385)):
			var _t386 = J.gp(J.gp(_s115["__p"]["STATIONS"], J.gp(v_c_296, "stn")), "monSt")
			J.sp(_t386, "seq", 0.0)
		var _t387 = J.gp(v_c_296, "fall")
		var _t388 = (J.cmp(_s115["pow"], 0.5, ">") if J.t(_t387) else _t387)
		var _t390 = ((not J.t(J.gp(v_c_296, "falling"))) if J.t(_t388) else _t388)
		if J.t(_t390):
			var _t389 = J.seq(J.gp(v_c_296, "id"), "binder1")
			_t390 = (_t389 if _t389 else J.seq(J.gp(v_c_296, "id"), "binder2"))
		if J.t(((randf() < 0.8) if J.t(_t390) else _t390)):
			var _t391 = _s115["__p"]["startFall"]
			J.cl(_t391, null, [v_c_296, ((-1.0) if J.seq(J.gp(v_c_296, "id"), "binder1") else 1.0)])
		if J.t(J.gp(v_c_296, "lamp")):
			var _t392 = J.gp(_s115["__p"]["st"], "lamp")
			var _t393 = J.add(J.gp(_t392, "vs"), J.mul(((randf() - 0.5) * 3.0), _s115["pow"]))
			J.sp(_t392, "vs", _t393)
	v_a_293 = J.gp(_s115["__p"]["items"], "achair")
	if J.t(J.cl(v_near_292, null, [v_a_293, 0.5])):
		var _t394 = J.gp(v_a_293, "vx")
		var _t396 = (_t394 if J.t(_t394) else 0.0)
		var _t395 = J.sub(J.gp(v_a_293, "x"), _s115["x"])
		var _t397 = J.add(_t396, J.mul((signf(J.num((_t395 if J.t(_t395) else 1.0))) * 0.1), _s115["pow"]))
		J.sp(v_a_293, "vx", _t397)
		var _t398 = J.gp(v_a_293, "vs")
		var _t399 = J.add((_t398 if J.t(_t398) else 0.0), J.mul(((randf() - 0.5) * 9.0), _s115["pow"]))
		J.sp(v_a_293, "vs", _t399)
	var _t400 = _s115["__p"]["eachStn"]
	J.cl(_t400, null, [Callable(self, "_f45").bind(_s115)])
	var _t406 = J.gp(_s115["__p"]["items"], "plant")
	if J.t((J.cl(v_near_292, null, [J.gp(_s115["__p"]["items"], "plant"), 0.5]) if J.t(_t406) else _t406)):
		var _t407 = _s115["__p"]["st"]
		var _t408 = J.max_([J.gp(_s115["__p"]["st"], "rustle"), _s115["pow"]])
		J.sp(_t407, "rustle", _t408)
	if J.t(J.cl(v_near_292, null, [J.gp(_s115["__p"]["items"], "water"), 0.4])):
		var _t409 = J.gp(_s115["__p"]["items"], "water")
		var _t410 = J.add(J.gp(_t409, "vr"), J.mul(((randf() - 0.5) * 2.0), _s115["pow"]))
		J.sp(_t409, "vr", _t410)

func _f47(this_, a: Array, env):
	var v_e_304 = null
	v_e_304 = J.arg(a, 0)
	var _t433 = J.seq(J.gp(v_e_304, 0.0), "kmug")
	return (not J.t((env["cofe"] if _t433 else _t433)))

func _f48(this_, a: Array, env):
	var v_e_305 = null
	v_e_305 = J.arg(a, 0)
	return {"id": J.gp(v_e_305, 0.0), "dir": J.gp(v_e_305, 1.0), "at": J.gp(v_e_305, 2.0)}

func _f49(this_, a: Array, env):
	if (not J.t(J.gp(J.gp(env["K"], "ch"), "occ"))):
		var _t442 = J.gp(env["K"], "ch")
		var _t443 = J.add(J.gp(_t442, "vs"), 6.0)
		J.sp(_t442, "vs", _t443)

func _f46(this_, a: Array, env):
	var v_k_300 = null; var v_c_301 = null; var v_kk_302 = null; var v_a_306 = null
	v_k_300 = J.arg(a, 0)
	if (not J.t(env["st"])):
		return null
	if J.seq(v_k_300, "lamp"):
		var _t411 = J.gp(env["st"], "lamp")
		J.sp(_t411, "flick", 2.2)
		var _t412 = J.gp(env["st"], "lamp")
		var _t413 = J.add(J.gp(_t412, "vs"), 3.5)
		J.sp(_t412, "vs", _t413)
		var _t414 = env["st"]
		J.sp(_t414, "tubes", 2.2)
		var _t415 = env["onScare"]
		J.cl(_t415, null, [J.gp(J.gp(env["items"], "idesk"), "x"), J.gp(J.gp(env["items"], "idesk"), "y"), 0.35])
	if J.seq(v_k_300, "ac"):
		var _t416 = J.gp(env["st"], "ac")
		J.sp(_t416, "blow", 2.6)
		for _t417 in J.iter(env["kids"]):
			v_c_301 = _t417
			if J.t(J.gp(v_c_301, "paper")):
				var _t418 = J.add(J.gp(v_c_301, "vr"), ((randf() - 0.5) * 5.0))
				J.sp(v_c_301, "vr", _t418)
		var _t419 = env["st"]
		J.sp(_t419, "flutter", 1.2)
		var _t420 = env["st"]
		J.sp(_t420, "rustle", 1.2)
	if J.seq(v_k_300, "water"):
		var _t421 = J.gp(env["st"], "water")
		J.sp(_t421, "glug", 2.4)
		var _t422 = J.gp(env["items"], "water")
		var _t423 = J.add(J.gp(_t422, "vr"), 1.6)
		J.sp(_t422, "vr", _t423)
	if J.seq(v_k_300, "printer"):
		var _t424 = J.gp(env["st"], "copier")
		J.sp(_t424, "print", 2.2)
		var _t425 = J.gp(env["st"], "copier")
		J.sp(_t425, "out", 0.0)
		var _t426 = env["onScare"]
		J.cl(_t426, null, [J.gp(J.gp(env["items"], "copier"), "x"), J.gp(J.gp(env["items"], "copier"), "y"), 0.6])
	if J.seq(v_k_300, "lights"):
		var _t427 = env["st"]
		var _t428 = {"t": 0.0}
		J.sp(_t427, "lights", _t428)
		var _t429 = env["st"]
		J.sp(_t429, "tubes", 0.0)
	if J.seq(v_k_300, "drop"):
		var _s130 = {"__p": env, "cofe": null}
		v_kk_302 = J.gp(J.gp(_s130["__p"]["STATIONS"], "ken"), "K")
		var _t430 = (J.seq(J.gp(v_kk_302, "mode"), "sit") if J.t(v_kk_302) else v_kk_302)
		_s130["cofe"] = (J.seq(J.gp(v_kk_302, "act"), "drink") if J.t(_t430) else _t430)
		var _t431 = _s130["__p"]["st"]
		var _t432 = [["binder1", (-1.0), 0.0], ["binder2", 1.0, 0.22], ["stack", 1.0, 0.45], ["kmug", (-1.0), 0.75], ["icactus", 1.0, 1.0]]
		var _t434 = J.mc(_t432, "filter", [Callable(self, "_f47").bind(_s130)])
		var _t435 = J.mc(_t434, "map", [Callable(self, "_f48").bind(_s130)])
		J.sp(_t431, "dropQ", _t435)
		var _t436 = _s130["__p"]["onScare"]
		J.cl(_t436, null, [J.gp(J.gp(_s130["__p"]["items"], "cabinet"), "x"), J.gp(J.gp(_s130["__p"]["items"], "cabinet"), "y"), 0.3])
	if J.seq(v_k_300, "chair"):
		var _t437 = env["st"]
		J.sp(_t437, "chairSpin", 2.8)
		var _t438 = env["st"]
		J.sp(_t438, "creak", 2.8)
		v_a_306 = J.gp(env["items"], "achair")
		var _t439 = J.gp(v_a_306, "vs")
		var _t440 = J.add((_t439 if J.t(_t439) else 0.0), 6.0)
		J.sp(v_a_306, "vs", _t440)
		var _t441 = env["eachStn"]
		J.cl(_t441, null, [Callable(self, "_f49").bind(env)])

func _f51(this_, a: Array, env):
	var v_i_313 = null; var v_t0_314 = null
	v_i_313 = J.arg(a, 0)
	v_t0_314 = (0.9 + J.mul(v_i_313, 0.3))
	return (env["fl"] if J.cmp(env["q"], v_t0_314, "<") else J.min_([0.74, (0.2 + (J.sub(env["q"], v_t0_314) * 3.0))]))

func _f50(this_, a: Array, env):
	var v_t_309 = null; var v_L_310 = null
	var _s135 = {"__p": env, "q": null, "fl": null}
	v_t_309 = J.arg(a, 0)
	v_L_310 = (J.gp(_s135["__p"]["st"], "lights") if J.t(_s135["__p"]["st"]) else _s135["__p"]["st"])
	if (not J.t(v_L_310)):
		return [0.0, 0.0, 0.0]
	_s135["q"] = J.gp(v_L_310, "t")
	_s135["fl"] = (0.55 if ((sin(J.num(J.mul(_s135["q"], 37.0))) + sin(J.num(J.mul(_s135["q"], 23.0)))) > 0.6) else 0.08)
	if J.cmp(_s135["q"], 0.9, "<"):
		return [_s135["fl"], _s135["fl"], _s135["fl"]]
	if J.cmp(_s135["q"], 2.7, "<"):
		var _t444 = [0.0, 1.0, 2.0]
		return J.mc(_t444, "map", [Callable(self, "_f51").bind(_s135)])
	return [0.0, 0.0, 0.0]

func _f52(this_, a: Array, env):
	var v_c_317 = null; var v_p_318 = null; var v_F_319 = null; var v_sg_320 = null
	v_c_317 = J.arg(a, 0)
	v_p_318 = J.gp(v_c_317, "parent")
	var _t445 = env["frameOf"]
	v_F_319 = J.cl(_t445, null, [v_p_318])
	v_sg_320 = ((-1.0) if J.t(J.gp(v_p_318, "flip")) else 1.0)
	return [J.add(J.gp(v_F_319, "x"), J.mul(J.mul(v_sg_320, J.sub(J.gp(v_c_317, "u"), J.gp(v_p_318, "ax"))), J.gp(v_F_319, "w"))), J.add(J.gp(v_F_319, "y"), J.mul(J.sub(J.gp(v_c_317, "v"), J.gp(v_p_318, "ay")), J.gp(v_F_319, "h"))), J.gp(v_F_319, "u")]

func _f54(this_, a: Array, env):
	var v_v_329 = null
	v_v_329 = J.arg(a, 0)
	return J.cmp(v_v_329, 0.0, ">")

func _f55(this_, a: Array, env):
	var v_c_333 = null; var v_col_334 = null; var v_r_335 = null; var v_x_336 = null; var v_y_337 = null; var v_u_338 = null; var v_R_339 = null; var v_g_340 = null
	v_c_333 = J.arg(a, 0)
	v_col_334 = J.arg(a, 1)
	v_r_335 = J.arg(a, 2)
	var _t450 = env["__p"]["kidPos"]
	var _t451 = J.cl(_t450, null, [v_c_333])
	var _t452 = J.gp(_t451, 0.0)
	v_x_336 = _t452
	var _t453 = J.gp(_t451, 1.0)
	v_y_337 = _t453
	var _t454 = J.gp(_t451, 2.0)
	v_u_338 = _t454
	v_R_339 = J.mul(v_u_338, v_r_335)
	v_g_340 = J.mc(env["ctx"], "createRadialGradient", [v_x_336, J.sub(v_y_337, J.mul(v_u_338, 0.25)), 0.0, v_x_336, J.sub(v_y_337, J.mul(v_u_338, 0.25)), v_R_339])
	J.mc(v_g_340, "addColorStop", [0.0, v_col_334])
	J.mc(v_g_340, "addColorStop", [1.0, "rgba(0,0,0,0)"])
	var _t455 = env["ctx"]
	J.sp(_t455, "fillStyle", v_g_340)
	J.mc(env["ctx"], "beginPath", [])
	J.mc(env["ctx"], "arc", [v_x_336, J.sub(v_y_337, J.mul(v_u_338, 0.25)), v_R_339, 0.0, J.mul(env["__p"]["PI"], 2.0)])
	J.mc(env["ctx"], "fill", [])

func _f56(this_, a: Array, env):
	var v_kx_348 = null; var v_ky_349 = null
	if (not J.t(J.gp(J.gp(env["__p"]["__p"]["K"], "ch"), "occ"))):
		var _t476 = env["__p"]["__p"]["P"]
		var _t477 = J.cl(_t476, null, [J.add(J.gp(env["__p"]["__p"]["SEATV"], "x"), J.gp(J.gp(env["__p"]["__p"]["K"], "ch"), "dx")), J.add(J.gp(env["__p"]["__p"]["SEAT"], "y"), J.gp(J.gp(env["__p"]["__p"]["K"], "ch"), "dz"))])
		var _t478 = J.gp(_t477, 0.0)
		v_kx_348 = _t478
		var _t479 = J.gp(_t477, 1.0)
		v_ky_349 = _t479
		var _t480 = env["__p"]["__p"]["text"]
		J.cl(_t480, null, [env["__p"]["ctx"], v_kx_348, J.sub(v_ky_349, J.mul(env["u"], 0.8)), "吱——", J.mul(env["u"], 0.14), J.mul(env["k"], 0.9)])

func _f53(this_, a: Array, env):
	var v_t_324 = null; var v_W_325 = null; var v_H_326 = null; var v_D_327 = null; var v_L_328 = null; var v_glow_330 = null; var v_dk_331 = null; var v_i_332 = null; var v_k_341 = null; var v_m_342 = null; var v_a_343 = null; var v_x_344 = null; var v_y_345 = null
	var _s138 = {"__p": env, "ctx": null}
	_s138["ctx"] = J.arg(a, 0)
	v_t_324 = J.arg(a, 1)
	if (not J.t(_s138["__p"]["st"])):
		return null
	v_W_325 = J.gp(_s138["__p"]["SC"], "W")
	v_H_326 = J.gp(_s138["__p"]["SC"], "H")
	var _t446 = _s138["__p"]["lightsDark"]
	v_D_327 = J.cl(_t446, null, [v_t_324])
	v_L_328 = J.gp(_s138["__p"]["st"], "lights")
	if J.t(J.mc(v_D_327, "some", [Callable(self, "_f54").bind(_s138)])):
		J.mc(_s138["ctx"], "save", [])
		v_i_332 = 0.0
		while true:
			if not J.cmp(v_i_332, 3.0, "<"): break
			if J.cmp(J.gp(v_D_327, v_i_332), 0.0, ">"):
				var _t447 = _s138["ctx"]
				var _t448 = ("rgba(4,3,14," + J.str(J.gp(v_D_327, v_i_332)) + ")")
				J.sp(_t447, "fillStyle", _t448)
				J.mc(_s138["ctx"], "fillRect", [(J.div(J.mul(v_W_325, v_i_332), 3.0) - 1.0), 0.0, (J.div(v_W_325, 3.0) + 2.0), v_H_326])
			v_i_332 = J.num(v_i_332) + 1.0
		var _t449 = _s138["ctx"]
		J.sp(_t449, "globalCompositeOperation", "lighter")
		v_glow_330 = Callable(self, "_f55").bind(_s138)
		v_dk_331 = J.max_(J.spread([J.SP(v_D_327)]))
		for _t456 in J.keys(_s138["__p"]["STATIONS"]):
			v_k_341 = _t456
			v_m_342 = J.gp(_s138["__p"]["items"], J.gp(J.gp(_s138["__p"]["STATIONS"], v_k_341), "mon"))
			var _t458 = v_m_342
			if J.t(_t458):
				var _t457 = _s138["__p"]["monState"]
				_t458 = J.seq(J.cl(_t457, null, [v_m_342]), "on")
			if J.t(_t458):
				J.cl(v_glow_330, null, [v_m_342, ("rgba(110,180,255," + J.str(J.mul(0.5, v_dk_331)) + ")"), 0.7])
		J.cl(v_glow_330, null, [J.gp(_s138["__p"]["items"], "lamp"), ("rgba(255,190,100," + J.str(J.mul(0.45, v_dk_331)) + ")"), 0.6])
		J.mc(_s138["ctx"], "restore", [])
	var _t459 = (J.cmp(J.gp(v_L_328, "t"), 2.7, ">=") if J.t(v_L_328) else v_L_328)
	if J.t((J.cmp(J.gp(v_L_328, "t"), 3.1, "<") if J.t(_t459) else _t459)):
		var _t460 = _s138["ctx"]
		var _t461 = ("rgba(255,250,230," + J.str((0.35 * (1.0 - J.div(J.sub(J.gp(v_L_328, "t"), 2.7), 0.4)))) + ")")
		J.sp(_t460, "fillStyle", _t461)
		J.mc(_s138["ctx"], "fillRect", [0.0, 0.0, v_W_325, v_H_326])
	var _t462 = (J.cmp(J.gp(v_L_328, "t"), 0.95, ">") if J.t(v_L_328) else v_L_328)
	if J.t((J.cmp(J.gp(v_L_328, "t"), 2.6, "<") if J.t(_t462) else _t462)):
		var _t463 = _s138["__p"]["text"]
		J.cl(_t463, null, [_s138["ctx"], J.mul(v_W_325, (0.15 + (0.35 * J.min_([2.0, floor(J.num(J.div(J.sub(J.gp(v_L_328, "t"), 0.9), 0.3)))])))), J.mul(v_H_326, 0.12), "啪", J.mul(v_H_326, 0.035), (1.0 - J.div(J.mod(J.sub(J.gp(v_L_328, "t"), 0.9), 0.3), 0.3))])
	if J.cmp(J.gp(_s138["__p"]["st"], "creak"), 0.0, ">"):
		var _s147 = {"__p": _s138, "u": null, "k": null}
		v_a_343 = J.gp(_s147["__p"]["__p"]["items"], "achair")
		var _t464 = _s147["__p"]["__p"]["P"]
		var _t466 = J.gp(v_a_343, "x")
		var _t465 = J.gp(v_a_343, "ox")
		var _t469 = J.add(_t466, (_t465 if J.t(_t465) else 0.0))
		var _t468 = J.gp(v_a_343, "y")
		var _t467 = J.gp(v_a_343, "oz")
		var _t470 = J.cl(_t464, null, [_t469, J.add(_t468, (_t467 if J.t(_t467) else 0.0))])
		var _t471 = J.gp(_t470, 0.0)
		v_x_344 = _t471
		var _t472 = J.gp(_t470, 1.0)
		v_y_345 = _t472
		var _t473 = _s147["__p"]["__p"]["U"]
		_s147["u"] = J.cl(_t473, null, [J.gp(v_a_343, "y")])
		_s147["k"] = (J.min_([1.0, J.gp(_s147["__p"]["__p"]["st"], "creak")]) * (0.6 + (0.4 * sin(J.num(J.mul(v_t_324, 9.0))))))
		var _t474 = _s147["__p"]["__p"]["text"]
		J.cl(_t474, null, [_s147["__p"]["ctx"], J.add(v_x_344, (sin(J.num(J.mul(v_t_324, 13.0))) * 2.0)), J.sub(v_y_345, J.mul(_s147["u"], 0.78)), "吱——", J.mul(_s147["u"], 0.14), _s147["k"]])
		var _t475 = _s147["__p"]["__p"]["eachStn"]
		J.cl(_t475, null, [Callable(self, "_f56").bind(_s147)])

func _f57(this_, a: Array, env):
	var v_ctx_352 = null; var v_x_353 = null; var v_y_354 = null; var v_w_355 = null; var v_a_356 = null
	v_ctx_352 = J.arg(a, 0)
	v_x_353 = J.arg(a, 1)
	v_y_354 = J.arg(a, 2)
	v_w_355 = J.arg(a, 3)
	v_a_356 = J.arg(a, 4)
	J.mc(v_ctx_352, "save", [])
	var _t481 = ("rgba(6,4,18," + J.str((0.38 if J.leq(v_a_356, null) else v_a_356)) + ")")
	J.sp(v_ctx_352, "fillStyle", _t481)
	J.mc(v_ctx_352, "beginPath", [])
	J.mc(v_ctx_352, "ellipse", [v_x_353, v_y_354, J.div(v_w_355, 2.0), J.mul(v_w_355, 0.13), 0.0, 0.0, J.mul(env["PI"], 2.0)])
	J.mc(v_ctx_352, "fill", [])
	J.mc(v_ctx_352, "restore", [])

func _f58(this_, a: Array, env):
	var v_ctx_359 = null; var v_t_360 = null
	v_ctx_359 = J.arg(a, 0)
	v_t_360 = J.arg(a, 1)
	J.mc(J.G.get("OFFMAP"), "drawBack", [v_ctx_359, v_t_360])
	if (not J.t(env["st"])):
		return null
	var _t482 = env["drawDoor"]
	J.cl(_t482, null, [v_ctx_359, v_t_360])

func _f60(this_, a: Array, env):
	var v_x_374 = null
	v_x_374 = J.arg(a, 0)
	return J.add(J.gp(J.gp(env["__p"]["ELEV"], "top"), 0.0), (J.div(J.sub(v_x_374, J.gp(env["__p"]["ELEV"], "x0")), J.sub(J.gp(env["__p"]["ELEV"], "x1"), J.gp(env["__p"]["ELEV"], "x0"))) * J.sub(J.gp(J.gp(env["__p"]["ELEV"], "top"), 1.0), J.gp(J.gp(env["__p"]["ELEV"], "top"), 0.0))))

func _f61(this_, a: Array, env):
	var v_x_375 = null
	v_x_375 = J.arg(a, 0)
	return J.add(J.gp(J.gp(env["__p"]["ELEV"], "bot"), 0.0), (J.div(J.sub(v_x_375, J.gp(env["__p"]["ELEV"], "x0")), J.sub(J.gp(env["__p"]["ELEV"], "x1"), J.gp(env["__p"]["ELEV"], "x0"))) * J.sub(J.gp(J.gp(env["__p"]["ELEV"], "bot"), 1.0), J.gp(J.gp(env["__p"]["ELEV"], "bot"), 0.0))))

func _f62(this_, a: Array, env):
	var v_p_378 = null; var v_i_379 = null
	v_p_378 = J.arg(a, 0)
	v_i_379 = J.arg(a, 1)
	return (J.mc(env["ctx"], "lineTo", [J.gp(v_p_378, 0.0), J.gp(v_p_378, 1.0)]) if J.t(v_i_379) else J.mc(env["ctx"], "moveTo", [J.gp(v_p_378, 0.0), J.gp(v_p_378, 1.0)]))

func _f59(this_, a: Array, env):
	var v_t_364 = null; var v_k0_365 = null; var v_tt_366 = null; var v_open_367 = null; var v_yt_368 = null; var v_yb_369 = null; var v_a_370 = null; var v_b_371 = null; var v_bx_372 = null; var v_by_373 = null; var v_Q_376 = null; var v_g_377 = null; var v_dx_380 = null; var v_dy_381 = null
	var _s152 = {"__p": env, "ctx": null}
	_s152["ctx"] = J.arg(a, 0)
	v_t_364 = J.arg(a, 1)
	var _t483 = J.gp(_s152["__p"]["st"], "door")
	v_k0_365 = (_t483 if J.t(_t483) else 0.0)
	if J.cmp(v_k0_365, 0.0, "<="):
		return null
	v_tt_366 = J.sub(1.8, v_k0_365)
	var _t487 = null
	if J.cmp(v_tt_366, 0.35, "<"):
		var _t484 = _s152["__p"]["ss"]
		_t487 = J.cl(_t484, null, [J.div(v_tt_366, 0.35)])
	else:
		var _t486 = null
		if J.cmp(v_tt_366, 1.4, ">"):
			var _t485 = _s152["__p"]["ss"]
			_t486 = J.sub(1.0, J.cl(_t485, null, [J.div(J.sub(v_tt_366, 1.4), 0.4)]))
		else:
			_t486 = 1.0
		_t487 = _t486
	v_open_367 = _t487
	v_yt_368 = Callable(self, "_f60").bind(_s152)
	v_yb_369 = Callable(self, "_f61").bind(_s152)
	v_a_370 = J.sub(J.gp(_s152["__p"]["ELEV"], "seam"), J.mul(v_open_367, (J.sub(J.gp(_s152["__p"]["ELEV"], "seam"), J.gp(_s152["__p"]["ELEV"], "x0")) - 0.004)))
	v_b_371 = J.add(J.gp(_s152["__p"]["ELEV"], "seam"), J.mul(v_open_367, (J.sub(J.gp(_s152["__p"]["ELEV"], "x1"), J.gp(_s152["__p"]["ELEV"], "seam")) - 0.004)))
	if J.cmp(v_open_367, 0.01, ">"):
		var _t488 = _s152["__p"]["P"]
		var _t490 = J.cl(_t488, null, [v_a_370, J.cl(v_yt_368, null, [v_a_370])])
		var _t489 = _s152["__p"]["P"]
		var _t492 = J.cl(_t489, null, [v_b_371, J.cl(v_yt_368, null, [v_b_371])])
		var _t491 = _s152["__p"]["P"]
		var _t494 = J.cl(_t491, null, [v_b_371, J.cl(v_yb_369, null, [v_b_371])])
		var _t493 = _s152["__p"]["P"]
		v_Q_376 = [_t490, _t492, _t494, J.cl(_t493, null, [v_a_370, J.cl(v_yb_369, null, [v_a_370])])]
		J.mc(_s152["ctx"], "save", [])
		J.mc(_s152["ctx"], "beginPath", [])
		J.mc(v_Q_376, "forEach", [Callable(self, "_f62").bind(_s152)])
		J.mc(_s152["ctx"], "closePath", [])
		v_g_377 = J.mc(_s152["ctx"], "createLinearGradient", [0.0, J.gp(J.gp(v_Q_376, 0.0), 1.0), 0.0, J.gp(J.gp(v_Q_376, 3.0), 1.0)])
		J.mc(v_g_377, "addColorStop", [0.0, "rgba(255,236,180,.95)"])
		J.mc(v_g_377, "addColorStop", [1.0, "rgba(190,160,110,.95)"])
		var _t495 = _s152["ctx"]
		J.sp(_t495, "fillStyle", v_g_377)
		J.mc(_s152["ctx"], "fill", [])
		var _t496 = _s152["ctx"]
		J.sp(_t496, "strokeStyle", "rgba(40,30,30,.8)")
		var _t497 = _s152["ctx"]
		J.sp(_t497, "lineWidth", 1.5)
		J.mc(_s152["ctx"], "stroke", [])
		J.mc(_s152["ctx"], "restore", [])
	var _t498 = _s152["__p"]["P"]
	var _t499 = J.cl(_t498, null, [J.gp(J.gp(_s152["__p"]["EV"], "btn"), 0.0), J.gp(J.gp(_s152["__p"]["EV"], "btn"), 1.0)])
	var _t500 = J.gp(_t499, 0.0)
	v_bx_372 = _t500
	var _t501 = J.gp(_t499, 1.0)
	v_by_373 = _t501
	J.mc(_s152["ctx"], "save", [])
	var _t502 = _s152["ctx"]
	J.sp(_t502, "globalCompositeOperation", "lighter")
	var _t503 = _s152["ctx"]
	var _t504 = ("rgba(255,220,120," + J.str((0.6 * J.min_([1.0, v_k0_365]))) + ")")
	J.sp(_t503, "fillStyle", _t504)
	J.mc(_s152["ctx"], "beginPath", [])
	J.mc(_s152["ctx"], "arc", [v_bx_372, v_by_373, 4.0, 0.0, J.mul(_s152["__p"]["PI"], 2.0)])
	J.mc(_s152["ctx"], "fill", [])
	J.mc(_s152["ctx"], "restore", [])
	if J.cmp(v_tt_366, 0.8, "<"):
		var _t505 = _s152["__p"]["P"]
		var _t506 = J.cl(_t505, null, [J.gp(_s152["__p"]["EV"], "seam"), J.sub(J.gp(_s152["__p"]["EV"], "top"), 0.04)])
		var _t507 = J.gp(_t506, 0.0)
		v_dx_380 = _t507
		var _t508 = J.gp(_t506, 1.0)
		v_dy_381 = _t508
		var _t509 = _s152["__p"]["text"]
		var _t511 = _s152["ctx"]
		var _t512 = J.sub(v_dy_381, J.mul(v_tt_366, 14.0))
		var _t510 = _s152["__p"]["U"]
		J.cl(_t509, null, [_t511, v_dx_380, _t512, "叮！", J.mul(J.cl(_t510, null, [0.65]), 0.16), (1.0 - J.div(v_tt_366, 0.8))])

func _f64(this_, a: Array, env):
	var v_a_401 = null; var v_l_402 = null; var v_w_403 = null
	v_a_401 = J.arg(a, 0)
	v_l_402 = J.arg(a, 1)
	v_w_403 = J.arg(a, 2)
	var _t530 = env["ctx"]
	J.sp(_t530, "lineWidth", v_w_403)
	J.mc(env["ctx"], "beginPath", [])
	J.mc(env["ctx"], "moveTo", [0.0, 0.0])
	J.mc(env["ctx"], "lineTo", [J.mul(sin(J.num(v_a_401)), v_l_402), J.mul((-cos(J.num(v_a_401))), v_l_402)])
	J.mc(env["ctx"], "stroke", [])

func _f63(this_, a: Array, env):
	var v_t_385 = null; var v_im_386 = null; var v_x_387 = null; var v_y_388 = null; var v_d_389 = null; var v_F_390 = null; var v_y2_391 = null; var v_rot_392 = null; var v_sq_393 = null; var v_al_394 = null; var v_hrs_395 = null; var v_sec_396 = null; var v_ha_397 = null; var v_ma_398 = null; var v_sa_399 = null; var v_hand_400 = null
	var _s158 = {"__p": env, "ctx": null}
	_s158["ctx"] = J.arg(a, 0)
	v_t_385 = J.arg(a, 1)
	var _t513 = _s158["__p"]["img"]
	v_im_386 = J.cl(_t513, null, ["op_clockface"])
	if (not J.t(v_im_386)):
		return null
	var _t514 = _s158["__p"]["P"]
	var _t515 = J.cl(_t514, null, [J.gp(_s158["__p"]["CLOCK"], "x"), J.gp(_s158["__p"]["CLOCK"], "y")])
	var _t516 = J.gp(_t515, 0.0)
	v_x_387 = _t516
	var _t517 = J.gp(_t515, 1.0)
	v_y_388 = _t517
	var _t519 = J.gp(_s158["__p"]["CLOCK"], "d")
	var _t518 = _s158["__p"]["U"]
	v_d_389 = (J.mul(_t519, J.cl(_t518, null, [J.gp(_s158["__p"]["CLOCK"], "depth")])) * 0.6)
	v_F_390 = J.gp(_s158["__p"]["st"], "clockF")
	v_y2_391 = v_y_388
	v_rot_392 = 0.0
	v_sq_393 = 1.0
	v_al_394 = ((1.0 - J.div(J.gp(_s158["__p"]["st"], "clockBack"), 0.6)) if J.cmp(J.gp(_s158["__p"]["st"], "clockBack"), 0.0, ">") else 1.0)
	if J.t(v_F_390):
		var _t520 = _s158["__p"]["P"]
		var _t521 = J.gp(J.cl(_t520, null, [J.gp(_s158["__p"]["CLOCK"], "x"), J.sub(0.485, J.gp(v_F_390, "z"))]), 1.0)
		v_y2_391 = _t521
		v_rot_392 = J.gp(v_F_390, "rot")
		var _t522 = J.cmp(J.gp(v_F_390, "z"), 0.0, "<=")
		if (J.cmp(J.gp(v_F_390, "rest"), 0.0, ">") if _t522 else _t522):
			var _t523 = (1.0 - (0.45 * J.min_([1.0, J.mul(J.gp(v_F_390, "rest"), 4.0)])))
			v_sq_393 = _t523
	var _t524 = ((not J.leq(J.gp(v_F_390, "land"), null)) if J.t(v_F_390) else v_F_390)
	if J.t(((J.sub(J.gp(v_F_390, "t"), J.gp(v_F_390, "land")) < 0.5) if J.t(_t524) else _t524)):
		var _t525 = _s158["__p"]["text"]
		J.cl(_t525, null, [_s158["ctx"], J.sub(v_x_387, J.mul(v_d_389, 0.8)), J.sub(v_y2_391, J.mul(v_d_389, 0.9)), "哐啷！", J.mul(v_d_389, 0.9), (1.0 - J.div(J.sub(J.gp(v_F_390, "t"), J.gp(v_F_390, "land")), 0.5))])
	v_hrs_395 = (J.div(J.gp(_s158["__p"]["SC"], "t"), 180.0) * 6.0)
	v_sec_396 = J.mod(floor(J.num(J.mul(J.gp(_s158["__p"]["SC"], "t"), 2.0))), 60.0)
	v_ha_397 = (J.mul((J.div(v_hrs_395, 12.0) * 2.0), _s158["__p"]["PI"]) + J.mul(J.gp(J.gp(_s158["__p"]["st"], "clock"), "ang"), 0.08))
	v_ma_398 = J.add(J.mul((J.mod(v_hrs_395, 1.0) * 2.0), _s158["__p"]["PI"]), J.gp(J.gp(_s158["__p"]["st"], "clock"), "ang"))
	v_sa_399 = (J.mul((J.div(v_sec_396, 60.0) * 2.0), _s158["__p"]["PI"]) + J.mul(J.gp(J.gp(_s158["__p"]["st"], "clock"), "ang"), 2.5))
	J.mc(_s158["ctx"], "save", [])
	var _t526 = _s158["ctx"]
	var _t527 = J.mul(J.gp(_t526, "globalAlpha"), v_al_394)
	J.sp(_t526, "globalAlpha", _t527)
	J.mc(_s158["ctx"], "translate", [v_x_387, v_y2_391])
	if J.t(v_F_390):
		J.mc(_s158["ctx"], "translate", [0.0, J.mul(v_d_389, 0.5)])
		J.mc(_s158["ctx"], "rotate", [v_rot_392])
		J.mc(_s158["ctx"], "scale", [1.0, v_sq_393])
		J.mc(_s158["ctx"], "translate", [0.0, ((-J.num(v_d_389)) * 0.5)])
	J.mc(_s158["ctx"], "scale", [0.58, 1.0])
	J.mc(_s158["ctx"], "drawImage", [v_im_386, J.div((-J.num(v_d_389)), 2.0), J.div((-J.num(v_d_389)), 2.0), v_d_389, v_d_389])
	var _t528 = _s158["ctx"]
	J.sp(_t528, "lineCap", "round")
	var _t529 = _s158["ctx"]
	J.sp(_t529, "strokeStyle", "rgba(52,32,26,.92)")
	v_hand_400 = Callable(self, "_f64").bind(_s158)
	J.cl(v_hand_400, null, [v_ha_397, J.mul(v_d_389, 0.2), J.max_([1.6, J.mul(v_d_389, 0.07)])])
	J.cl(v_hand_400, null, [v_ma_398, J.mul(v_d_389, 0.3), J.max_([1.2, J.mul(v_d_389, 0.05)])])
	var _t531 = _s158["ctx"]
	J.sp(_t531, "strokeStyle", "rgba(170,40,40,.8)")
	J.cl(v_hand_400, null, [v_sa_399, J.mul(v_d_389, 0.32), 0.8])
	var _t532 = _s158["ctx"]
	J.sp(_t532, "fillStyle", "#3a221a")
	J.mc(_s158["ctx"], "beginPath", [])
	J.mc(_s158["ctx"], "arc", [0.0, 0.0, J.max_([1.2, J.mul(v_d_389, 0.04)]), 0.0, J.mul(_s158["__p"]["PI"], 2.0)])
	J.mc(_s158["ctx"], "fill", [])
	J.mc(_s158["ctx"], "restore", [])

func _f65(this_, a: Array, env):
	var v_ctx_406 = null; var v_t_407 = null; var v_x1_408 = null; var v_y1_409 = null; var v_x2_410 = null; var v_y2_411 = null; var v_w_412 = null; var v_h_413 = null; var v_k_414 = null; var v_e_415 = null; var v_fl_416 = null; var v_i_417 = null; var v_q_418 = null; var v_sx_419 = null; var v_sy_420 = null; var v_ex_421 = null; var v_ey_422 = null
	v_ctx_406 = J.arg(a, 0)
	v_t_407 = J.arg(a, 1)
	var _t533 = env["P"]
	var _t534 = J.cl(_t533, null, [J.gp(env["AC"], 0.0), J.gp(env["AC"], 1.0)])
	var _t535 = J.gp(_t534, 0.0)
	v_x1_408 = _t535
	var _t536 = J.gp(_t534, 1.0)
	v_y1_409 = _t536
	var _t537 = env["P"]
	var _t538 = J.cl(_t537, null, [J.add(J.gp(env["AC"], 0.0), J.gp(env["AC"], 2.0)), J.add(J.gp(env["AC"], 1.0), J.gp(env["AC"], 3.0))])
	var _t539 = J.gp(_t538, 0.0)
	v_x2_410 = _t539
	var _t540 = J.gp(_t538, 1.0)
	v_y2_411 = _t540
	v_w_412 = J.sub(v_x2_410, v_x1_408)
	v_h_413 = J.sub(v_y2_411, v_y1_409)
	v_k_414 = J.gp(J.gp(env["st"], "ac"), "blow")
	if J.cmp(v_k_414, 0.0, "<="):
		return null
	v_e_415 = J.min_([1.0, J.mul(v_k_414, 2.0), (J.sub(2.6, v_k_414) * 4.0)])
	J.mc(v_ctx_406, "save", [])
	var _t541 = ("rgba(40,40,60," + J.str(J.mul(0.7, v_e_415)) + ")")
	J.sp(v_ctx_406, "strokeStyle", _t541)
	J.sp(v_ctx_406, "lineWidth", 2.0)
	v_fl_416 = ((sin(J.num(J.mul(v_t_407, 18.0))) * 0.5) + 0.5)
	J.mc(v_ctx_406, "beginPath", [])
	J.mc(v_ctx_406, "moveTo", [J.add(v_x1_408, J.mul(v_w_412, 0.12)), J.add(v_y1_409, J.mul(v_h_413, 0.78))])
	J.mc(v_ctx_406, "lineTo", [J.sub(v_x2_410, J.mul(v_w_412, 0.1)), J.add(v_y1_409, J.mul(v_h_413, (0.78 + J.mul(0.12, v_fl_416))))])
	J.mc(v_ctx_406, "stroke", [])
	J.sp(v_ctx_406, "lineCap", "round")
	v_i_417 = 0.0
	while true:
		if not J.cmp(v_i_417, 7.0, "<"): break
		v_q_418 = J.mod((J.mul(v_t_407, 0.9) + J.div(v_i_417, 7.0)), 1.0)
		var _t542 = env["rnd"]
		v_sx_419 = J.add(v_x1_408, J.mul(v_w_412, (0.15 + J.mul(0.7, J.cl(_t542, null, [v_i_417])))))
		v_sy_420 = J.sub(v_y2_411, 2.0)
		v_ex_421 = (J.sub(v_sx_419, (J.mul(v_q_418, v_w_412) * 1.6)) - 10.0)
		v_ey_422 = J.add(v_sy_420, (J.mul(v_q_418, v_h_413) * 3.4))
		var _t543 = ("rgba(210,235,255," + J.str((J.mul(0.55, v_e_415) * J.sub(1.0, v_q_418))) + ")")
		J.sp(v_ctx_406, "strokeStyle", _t543)
		var _t544 = (2.2 * (1.0 - J.mul(v_q_418, 0.5)))
		J.sp(v_ctx_406, "lineWidth", _t544)
		J.mc(v_ctx_406, "beginPath", [])
		J.mc(v_ctx_406, "moveTo", [v_sx_419, v_sy_420])
		J.mc(v_ctx_406, "quadraticCurveTo", [(J.sub(v_sx_419, 4.0) + (sin(J.num(J.add(J.mul(v_t_407, 6.0), v_i_417))) * 6.0)), J.div(J.add(v_sy_420, v_ey_422), 2.0), v_ex_421, v_ey_422])
		J.mc(v_ctx_406, "stroke", [])
		v_i_417 = J.num(v_i_417) + 1.0
	J.mc(v_ctx_406, "restore", [])

func _f66(this_, a: Array, env):
	var v_ctx_425 = null; var v_W0_426 = null; var v_x1_427 = null; var v_y1_428 = null; var v_x2_429 = null; var v_y2_430 = null
	v_ctx_425 = J.arg(a, 0)
	v_W0_426 = J.gp(J.G.get("OFFMAP"), "WINMAIN")
	var _t545 = env["P"]
	var _t546 = J.cl(_t545, null, [J.gp(v_W0_426, 0.0), J.gp(v_W0_426, 1.0)])
	var _t547 = J.gp(_t546, 0.0)
	v_x1_427 = _t547
	var _t548 = J.gp(_t546, 1.0)
	v_y1_428 = _t548
	var _t549 = env["P"]
	var _t550 = J.cl(_t549, null, [J.add(J.gp(v_W0_426, 0.0), J.gp(v_W0_426, 2.0)), J.add(J.gp(v_W0_426, 1.0), J.gp(v_W0_426, 3.0))])
	var _t551 = J.gp(_t550, 0.0)
	v_x2_429 = _t551
	var _t552 = J.gp(_t550, 1.0)
	v_y2_430 = _t552
	J.mc(v_ctx_425, "beginPath", [])
	J.mc(v_ctx_425, "rect", [v_x1_427, v_y1_428, J.sub(v_x2_429, v_x1_427), J.sub(v_y2_430, v_y1_428)])
	J.mc(v_ctx_425, "clip", [])
	return [v_x1_427, v_y1_428, v_x2_429, v_y2_430]

func _f68(this_, a: Array, env):
	var v_ctx_436 = null
	v_ctx_436 = J.arg(a, 0)
	var _t556 = env["__p"]["__p"]["drawFreeChair"]
	return J.cl(_t556, null, [v_ctx_436, env["it"], env["__p"]["t"]])

func _f69(this_, a: Array, env):
	var v_ctx_437 = null
	v_ctx_437 = J.arg(a, 0)
	var _t559 = env["__p"]["__p"]["drawItem"]
	return J.cl(_t559, null, [v_ctx_437, env["it"], env["__p"]["t"]])

func _f71(this_, a: Array, env):
	var v_ctx_439 = null; var v_keep_440 = null
	v_ctx_439 = J.arg(a, 0)
	v_keep_440 = env["__p"]["__p"]["STN"]
	var _t561 = env["__p"]["__p"]["use"]
	J.cl(_t561, null, [env["s"]])
	var _t562 = env["__p"]["__p"]["drawKenChair"]
	J.cl(_t562, null, [v_ctx_439, null, env["__p"]["t"]])
	var _t563 = env["__p"]["__p"]["use"]
	J.cl(_t563, null, [v_keep_440])

func _f70(this_, a: Array, env):
	var _s172 = {"__p": env, "s": null}
	_s172["s"] = J.arg(a, 0)
	if (not J.t(J.gp(J.gp(_s172["__p"]["__p"]["K"], "ch"), "occ"))):
		J.mc(_s172["__p"]["out"], "push", [[J.sub(J.add(J.gp(_s172["__p"]["__p"]["SEAT"], "y"), J.gp(J.gp(_s172["__p"]["__p"]["K"], "ch"), "dz")), 0.03), Callable(self, "_f71").bind(_s172)]])

func _f72(this_, a: Array, env):
	var v_ctx_442 = null
	v_ctx_442 = J.arg(a, 0)
	var _t566 = env["__p"]["__p"]["drawFallen"]
	return J.cl(_t566, null, [v_ctx_442, env["c"]])

func _f73(this_, a: Array, env):
	var v_ctx_444 = null
	v_ctx_444 = J.arg(a, 0)
	var _t568 = env["__p"]["__p"]["drawFlying"]
	return J.cl(_t568, null, [v_ctx_444, env["p"], env["__p"]["t"]])

func _f67(this_, a: Array, env):
	var _s166 = {"__p": env, "t": null, "out": null}
	_s166["t"] = J.arg(a, 0)
	_s166["out"] = []
	for _t553 in J.iter(_s166["__p"]["list"]):
		var _s167 = {"__p": _s166, "it": null}
		_s167["it"] = _t553
		if J.t(J.gp(_s167["it"], "chair")):
			var _t555 = J.gp(_s167["it"], "y")
			var _t554 = J.gp(_s167["it"], "oz")
			J.mc(_s167["__p"]["out"], "push", [[J.add(_t555, (_t554 if J.t(_t554) else 0.0)), Callable(self, "_f68").bind(_s167)]])
			continue
		var _t558 = J.gp(_s167["it"], "stn")
		if J.t(_t558):
			var _t557 = _s167["__p"]["__p"]["kenAtDesk"]
			_t558 = J.cl(_t557, null, [J.gp(_s167["__p"]["__p"]["STATIONS"], J.gp(_s167["it"], "stn"))])
		if J.t(_t558):
			continue
		J.mc(_s167["__p"]["out"], "push", [[(J.gp(_s167["it"], "z") if (not J.leq(J.gp(_s167["it"], "z"), null)) else J.gp(_s167["it"], "y")), Callable(self, "_f69").bind(_s167)]])
	var _t560 = _s166["__p"]["eachStn"]
	J.cl(_t560, null, [Callable(self, "_f70").bind(_s166)])
	for _t564 in J.iter(_s166["__p"]["kids"]):
		var _s174 = {"__p": _s166, "c": null}
		_s174["c"] = _t564
		var _t565 = J.gp(_s174["c"], "falling")
		if J.t((J.gp(J.gp(_s174["c"], "falling"), "off") if J.t(_t565) else _t565)):
			J.mc(_s174["__p"]["out"], "push", [[J.add((J.gp(J.gp(_s174["c"], "parent"), "z") if (not J.leq(J.gp(J.gp(_s174["c"], "parent"), "z"), null)) else J.gp(J.gp(_s174["c"], "parent"), "y")), 0.006), Callable(self, "_f72").bind(_s174)]])
	for _t567 in J.iter(_s166["__p"]["flying"]):
		var _s176 = {"__p": _s166, "p": null}
		_s176["p"] = _t567
		J.mc(_s176["__p"]["out"], "push", [[J.gp(_s176["p"], "y"), Callable(self, "_f73").bind(_s176)]])
	return _s166["out"]

func _f74(this_, a: Array, env):
	var v_ctx_447 = null; var v_t_448 = null; var v_im_449 = null; var v_p_450 = null; var v_x_451 = null; var v_y_452 = null; var v_u_453 = null; var v_w_454 = null; var v_a_455 = null
	v_ctx_447 = J.arg(a, 0)
	v_t_448 = J.arg(a, 1)
	var _t569 = env["img"]
	v_im_449 = J.cl(_t569, null, ["op_paper"])
	if (not J.t(v_im_449)):
		return null
	for _t570 in J.iter(env["floor"]):
		v_p_450 = _t570
		var _t571 = env["P"]
		var _t572 = J.cl(_t571, null, [J.gp(v_p_450, "x"), J.gp(v_p_450, "y")])
		var _t573 = J.gp(_t572, 0.0)
		v_x_451 = _t573
		var _t574 = J.gp(_t572, 1.0)
		v_y_452 = _t574
		var _t575 = env["U"]
		v_u_453 = J.cl(_t575, null, [J.gp(v_p_450, "y")])
		v_w_454 = (J.mul(J.gp(v_p_450, "w"), v_u_453) * 1.4)
		v_a_455 = J.min_([1.0, J.div(J.gp(v_p_450, "life"), 1.5)])
		J.mc(v_ctx_447, "save", [])
		J.sp(v_ctx_447, "globalAlpha", v_a_455)
		J.mc(v_ctx_447, "translate", [v_x_451, v_y_452])
		J.mc(v_ctx_447, "scale", [1.0, 0.55])
		J.mc(v_ctx_447, "rotate", [J.gp(v_p_450, "rot")])
		J.mc(v_ctx_447, "drawImage", [v_im_449, J.div((-J.num(v_w_454)), 2.0), J.div(J.div(J.mul((-J.num(v_w_454)), J.gp(v_im_449, "height")), J.gp(v_im_449, "width")), 2.0), v_w_454, J.div(J.mul(v_w_454, J.gp(v_im_449, "height")), J.gp(v_im_449, "width"))])
		J.mc(v_ctx_447, "restore", [])

func _f75(this_, a: Array, env):
	var v_it_458 = null; var v_im_459 = null; var v_u_460 = null; var v_h_461 = null; var v_w_462 = null; var v_x_463 = null; var v_y_464 = null
	v_it_458 = J.arg(a, 0)
	var _t576 = env["img"]
	var _t577 = J.cl(_t576, null, [J.gp(v_it_458, "spr")])
	v_im_459 = (_t577 if J.t(_t577) else {"width": 1.0, "height": 1.0})
	var _t578 = env["U"]
	v_u_460 = J.cl(_t578, null, [(J.gp(v_it_458, "uy") if (not J.leq(J.gp(v_it_458, "uy"), null)) else J.gp(v_it_458, "y"))])
	v_h_461 = J.mul(J.gp(v_it_458, "h"), v_u_460)
	v_w_462 = J.div(J.mul(v_h_461, J.gp(v_im_459, "width")), J.gp(v_im_459, "height"))
	var _t579 = env["P"]
	var _t580 = J.cl(_t579, null, [J.gp(v_it_458, "x"), J.gp(v_it_458, "y")])
	var _t581 = J.gp(_t580, 0.0)
	v_x_463 = _t581
	var _t582 = J.gp(_t580, 1.0)
	v_y_464 = _t582
	return {"x": v_x_463, "y": v_y_464, "u": v_u_460, "w": v_w_462, "h": v_h_461, "im": v_im_459}

func _f76(this_, a: Array, env):
	var v_ctx_467 = null; var v_it_468 = null; var v_t_469 = null; var v_mode_470 = null; var v_F_471 = null; var v_x_472 = null; var v_y_473 = null; var v_u_474 = null; var v_w_475 = null; var v_h_476 = null; var v_im_477 = null; var v_L_478 = null; var v_T_479 = null; var v_g_480 = null; var v_k_481 = null; var v_c_482 = null; var v_gx_483 = null; var v_gy_484 = null; var v_r_485 = null; var v_g_486 = null
	v_ctx_467 = J.arg(a, 0)
	v_it_468 = J.arg(a, 1)
	v_t_469 = J.arg(a, 2)
	v_mode_470 = J.arg(a, 3)
	var _t583 = env["frameOf"]
	v_F_471 = J.cl(_t583, null, [v_it_468])
	var _t584 = env["img"]
	if (not J.t(J.cl(_t584, null, [J.gp(v_it_468, "spr")]))):
		return null
	var _t585 = J.gp(v_F_471, "x")
	v_x_472 = _t585
	var _t586 = J.gp(v_F_471, "y")
	v_y_473 = _t586
	var _t587 = J.gp(v_F_471, "u")
	v_u_474 = _t587
	var _t588 = J.gp(v_F_471, "w")
	v_w_475 = _t588
	var _t589 = J.gp(v_F_471, "h")
	v_h_476 = _t589
	var _t590 = env["img"]
	v_im_477 = J.cl(_t590, null, [J.gp(v_it_468, "spr")])
	var _t591 = J.gp(v_it_468, "shadow")
	if J.t(((not J.seq(v_mode_470, "kids")) if J.t(_t591) else _t591)):
		if (not J.leq(J.gp(v_it_468, "shu"), null)):
			var _t592 = env["shadowAt"]
			J.cl(_t592, null, [v_ctx_467, J.add(v_x_472, J.mul(J.sub(J.gp(v_it_468, "shu"), J.gp(v_it_468, "ax")), v_w_475)), J.add(v_y_473, J.mul(J.sub(J.gp(v_it_468, "shv"), J.gp(v_it_468, "ay")), v_h_476)), J.mul(J.gp(v_it_468, "shadow"), v_u_474)])
		else:
			var _t593 = env["shadowAt"]
			J.cl(_t593, null, [v_ctx_467, v_x_472, J.sub(v_y_473, J.mul(v_h_476, 0.01)), J.mul(J.gp(v_it_468, "shadow"), v_u_474)])
	J.mc(v_ctx_467, "save", [])
	J.mc(v_ctx_467, "translate", [v_x_472, v_y_473])
	if J.t(J.gp(v_it_468, "water")):
		v_g_480 = J.gp(J.gp(env["st"], "water"), "glug")
		var _t594 = J.gp(v_it_468, "rot")
		var _t595 = J.add((_t594 if J.t(_t594) else 0.0), (((sin(J.num(J.mul(v_t_469, 22.0))) * 0.012) * J.min_([1.0, v_g_480])) if J.cmp(v_g_480, 0.0, ">") else 0.0))
		J.sp(v_it_468, "rot", _t595)
	var _t596 = J.gp(v_it_468, "copier")
	if J.t((J.cmp(J.gp(J.gp(env["st"], "copier"), "print"), 0.0, ">") if J.t(_t596) else _t596)):
		J.mc(v_ctx_467, "translate", [(J.mul(sin(J.num(J.mul(v_t_469, 60.0))), v_u_474) * 0.006), (J.mul(sin(J.num(J.mul(v_t_469, 47.0))), v_u_474) * 0.004)])
	if J.t(J.gp(v_it_468, "rot")):
		J.mc(v_ctx_467, "rotate", [J.gp(v_it_468, "rot")])
	if J.t(J.gp(v_it_468, "flip")):
		J.mc(v_ctx_467, "scale", [(-1.0), 1.0])
	if J.t(J.gp(v_it_468, "fan")):
		var _t597 = env["drawFan"]
		J.cl(_t597, null, [v_ctx_467, v_it_468, v_F_471, v_t_469])
		J.mc(v_ctx_467, "restore", [])
		return null
	if J.t(J.gp(v_it_468, "plant")):
		v_k_481 = (((J.mul(J.gp(env["st"], "rustle"), sin(J.num(J.mul(v_t_469, 11.0)))) * 0.05) + (sin(J.num(J.add(J.mul(v_t_469, 0.9), J.gp(v_it_468, "ph")))) * 0.006)) + (J.mul(J.gp(env["st"], "flutter"), sin(J.num(J.mul(v_t_469, 7.0)))) * 0.02))
		J.mc(v_ctx_467, "transform", [1.0, 0.0, v_k_481, 1.0, 0.0, 0.0])
	v_L_478 = J.mul((-J.num(J.gp(v_it_468, "ax"))), v_w_475)
	v_T_479 = J.mul((-J.num(J.gp(v_it_468, "ay"))), v_h_476)
	if (not J.seq(v_mode_470, "kids")):
		J.mc(v_ctx_467, "drawImage", [v_im_477, v_L_478, v_T_479, v_w_475, v_h_476])
	var _t598 = J.gp(v_it_468, "back")
	if J.t(((not J.seq(v_mode_470, "base")) if J.t(_t598) else _t598)):
		var _t599 = J.gp(v_it_468, "stn")
		var _t600 = (J.gp(env["items"], J.gp(J.gp(env["STATIONS"], J.gp(v_it_468, "stn")), "mon")) if J.t(_t599) else _t599)
		env["this_mon"] = _t600
		var _t601 = env["deskSpill"]
		J.cl(_t601, null, [v_ctx_467, v_L_478, v_T_479, v_w_475, v_h_476, v_u_474, v_t_469])
	if (not J.seq(v_mode_470, "base")):
		for _t602 in J.iter(J.gp(v_it_468, "kids")):
			v_c_482 = _t602
			var _t603 = env["drawKid"]
			J.cl(_t603, null, [v_ctx_467, v_c_482, v_L_478, v_T_479, v_w_475, v_h_476, v_u_474, v_t_469])
	if J.seq(v_mode_470, "base"):
		J.mc(v_ctx_467, "restore", [])
		return null
	if J.t(J.gp(v_it_468, "copier")):
		var _t604 = env["copierFx"]
		J.cl(_t604, null, [v_ctx_467, v_L_478, v_T_479, v_w_475, v_h_476, v_u_474, v_t_469])
	if J.t(J.gp(v_it_468, "water")):
		var _t605 = env["waterFx"]
		J.cl(_t605, null, [v_ctx_467, v_L_478, v_T_479, v_w_475, v_h_476, v_u_474, v_t_469])
	if J.t(J.gp(v_it_468, "stn")):
		var _t606 = env["deskFx"]
		J.cl(_t606, null, [v_ctx_467, v_it_468, v_L_478, v_T_479, v_w_475, v_h_476, v_u_474, v_t_469])
	if J.t(J.gp(v_it_468, "glow")):
		J.mc(v_ctx_467, "save", [])
		J.sp(v_ctx_467, "globalCompositeOperation", "lighter")
		v_gx_483 = J.add(v_L_478, J.mul(v_w_475, 0.47))
		v_gy_484 = J.add(v_T_479, J.mul(v_h_476, 0.05))
		v_r_485 = J.mul(v_w_475, 0.55)
		v_g_486 = J.mc(v_ctx_467, "createRadialGradient", [v_gx_483, v_gy_484, 0.0, v_gx_483, v_gy_484, v_r_485])
		J.mc(v_g_486, "addColorStop", [0.0, ("rgba(120,170,255," + J.str((0.22 + (0.03 * sin(J.num(J.add(J.mul(v_t_469, 2.0), J.gp(v_it_468, "ph"))))))) + ")")])
		J.mc(v_g_486, "addColorStop", [1.0, "rgba(120,170,255,0)"])
		J.sp(v_ctx_467, "fillStyle", v_g_486)
		J.mc(v_ctx_467, "fillRect", [J.sub(v_gx_483, v_r_485), J.sub(v_gy_484, v_r_485), J.mul(v_r_485, 2.0), J.mul(v_r_485, 2.0)])
		J.mc(v_ctx_467, "restore", [])
	J.mc(v_ctx_467, "restore", [])

func _f78(this_, a: Array, env):
	var v_c_491 = null; var v_m_492 = null; var v_q_493 = null
	v_c_491 = J.arg(a, 0)
	var _t607 = J.gp(v_c_491, "stn")
	v_m_492 = (J.gp(J.gp(env["STATIONS"], J.gp(v_c_491, "stn")), "monSt") if J.t(_t607) else _t607)
	v_q_493 = (J.gp(v_m_492, "seq") if J.t(v_m_492) else (-1.0))
	var _t608 = (not J.t(v_m_492))
	if J.t((_t608 if _t608 else J.gp(J.gp(env["STATIONS"], J.gp(v_c_491, "stn")), "offline"))):
		return "off"
	if J.cmp(v_q_493, 0.0, "<"):
		return "on"
	if J.cmp(v_q_493, 0.55, "<"):
		return "static"
	if J.cmp(v_q_493, 1.4, "<"):
		return "off"
	return ("static" if (sin(J.num(J.mul(v_q_493, 60.0))) > 0.0) else "on")

func _f79(this_, a: Array, env):
	var v_c_496 = null; var v_m_497 = null; var v_q_498 = null; var v_sd_499 = null; var v_S0_500 = null
	v_c_496 = J.arg(a, 0)
	if J.t(J.gp(v_c_496, "back")):
		return J.gp(v_c_496, "spr")
	if J.t(J.gp(v_c_496, "mon")):
		v_m_497 = (J.gp(env["st"], "mon") if J.t(J.gp(v_c_496, "ken")) else J.gp(env["st"], "amon"))
		v_q_498 = J.gp(v_m_497, "seq")
		v_sd_499 = ("op_mon_side_" if J.t(J.gp(v_c_496, "side")) else "op_mon_")
		v_S0_500 = ("op_mon_side_off" if J.t(J.gp(v_c_496, "side")) else "op_mon_static")
		if J.cmp(v_q_498, 0.0, ">="):
			return (v_S0_500 if J.cmp(v_q_498, 0.55, "<") else (J.add(v_sd_499, "off") if J.cmp(v_q_498, 1.4, "<") else (v_S0_500 if (sin(J.num(J.mul(v_q_498, 60.0))) > 0.0) else (J.add(v_sd_499, "on") if J.t(J.gp(v_c_496, "ken")) else J.add(v_sd_499, "off")))))
		return (J.add(v_sd_499, "on") if J.t(J.gp(v_c_496, "ken")) else J.add(v_sd_499, "off"))
	return J.gp(v_c_496, "spr")

func _f81(this_, a: Array, env):
	var v_k_523 = null
	v_k_523 = J.arg(a, 0)
	return J.seq(J.gp(v_k_523, "id"), J.gp(env["c"], "on"))

func _f80(this_, a: Array, env):
	var v_ctx_503 = null; var v_L_505 = null; var v_T_506 = null; var v_w_507 = null; var v_h_508 = null; var v_u_509 = null; var v_t_510 = null; var v_key_511 = null; var v_im_512 = null; var v_a_513 = null; var v_ch_514 = null; var v_cw_515 = null; var v_chh_516 = null; var v_x_517 = null; var v_y_518 = null; var v_r_519 = null; var v_kay_520 = null; var v_sK_521 = null; var v_m_522 = null; var v_g_524 = null; var v_i_525 = null
	var _s195 = {"__p": env, "c": null}
	v_ctx_503 = J.arg(a, 0)
	_s195["c"] = J.arg(a, 1)
	v_L_505 = J.arg(a, 2)
	v_T_506 = J.arg(a, 3)
	v_w_507 = J.arg(a, 4)
	v_h_508 = J.arg(a, 5)
	v_u_509 = J.arg(a, 6)
	v_t_510 = J.arg(a, 7)
	var _t609 = J.gp(_s195["c"], "falling")
	if J.t((J.gp(J.gp(_s195["c"], "falling"), "off") if J.t(_t609) else _t609)):
		return null
	var _t610 = J.gp(J.gp(_s195["c"], "parent"), "stn")
	v_sK_521 = (J.gp(J.gp(_s195["__p"]["STATIONS"], J.gp(J.gp(_s195["c"], "parent"), "stn")), "K") if J.t(_t610) else _t610)
	var _t611 = J.gp(_s195["c"], "mug")
	var _t612 = (v_sK_521 if J.t(_t611) else _t611)
	var _t613 = (J.seq(J.gp(v_sK_521, "mode"), "sit") if J.t(_t612) else _t612)
	var _t614 = (J.seq(J.gp(v_sK_521, "act"), "drink") if J.t(_t613) else _t613)
	var _t615 = (J.cmp(J.gp(v_sK_521, "at"), 0.45, ">") if J.t(_t614) else _t614)
	if J.t((J.cmp(J.gp(v_sK_521, "at"), J.sub(J.gp(v_sK_521, "dur"), 0.4), "<") if J.t(_t615) else _t615)):
		return null
	var _t616 = _s195["__p"]["kidImg"]
	v_key_511 = J.cl(_t616, null, [_s195["c"]])
	var _t617 = _s195["__p"]["img"]
	v_im_512 = J.cl(_t617, null, [v_key_511])
	if (not J.t(v_im_512)):
		return null
	v_a_513 = (((1.0 - J.div(J.gp(_s195["c"], "hide"), 0.6)) if J.cmp(J.gp(_s195["c"], "hide"), 0.6, "<") else 0.0) if J.cmp(J.gp(_s195["c"], "hide"), 0.0, ">") else 1.0)
	if J.cmp(v_a_513, 0.0, "<="):
		return null
	v_ch_514 = J.mul(J.gp(_s195["c"], "h"), v_u_509)
	var _t618 = J.gp(_s195["c"], "mon")
	v_cw_515 = (J.mul(0.47, v_u_509) if J.t(((not J.t(J.gp(_s195["c"], "side"))) if J.t(_t618) else _t618)) else J.div(J.mul(v_ch_514, J.gp(v_im_512, "width")), J.gp(v_im_512, "height")))
	var _t619 = J.gp(_s195["c"], "mon")
	v_chh_516 = (J.div(J.mul(v_cw_515, J.gp(v_im_512, "height")), J.gp(v_im_512, "width")) if J.t(((not J.t(J.gp(_s195["c"], "side"))) if J.t(_t619) else _t619)) else v_ch_514)
	v_x_517 = J.add(v_L_505, J.mul(J.gp(_s195["c"], "u"), v_w_507))
	v_y_518 = J.add(v_T_506, J.mul(J.gp(_s195["c"], "v"), v_h_508))
	if J.t(J.gp(_s195["c"], "on")):
		var _t620 = J.gp(J.gp(_s195["c"], "parent"), "kids")
		v_m_522 = J.mc(_t620, "find", [Callable(self, "_f81").bind(_s195)])
		if J.t(v_m_522):
			var _t621 = J.add(J.add(v_L_505, J.mul(J.gp(v_m_522, "u"), v_w_507)), J.mul((J.sub(J.gp(_s195["c"], "u"), 0.5) * 0.47), v_u_509))
			v_x_517 = _t621
			var _t622 = J.sub(J.add(v_T_506, J.mul(J.gp(v_m_522, "v"), v_h_508)), (J.mul((J.sub(1.0, J.gp(_s195["c"], "v")) * 0.47), v_u_509) * 0.98))
			v_y_518 = _t622
	J.mc(v_ctx_503, "save", [])
	var _t623 = J.mul(J.gp(v_ctx_503, "globalAlpha"), v_a_513)
	J.sp(v_ctx_503, "globalAlpha", _t623)
	J.mc(v_ctx_503, "translate", [v_x_517, v_y_518])
	v_r_519 = J.gp(_s195["c"], "rot")
	if J.t(J.gp(_s195["c"], "paper")):
		var _t624 = J.add(v_r_519, J.mul((sin(J.num(J.add(J.mul(v_t_510, 9.0), J.gp(_s195["c"], "ph")))) * 0.06), J.gp(_s195["__p"]["st"], "flutter")))
		v_r_519 = _t624
	if J.t(J.gp(_s195["c"], "lamp")):
		var _t625 = J.add(v_r_519, J.gp(J.gp(_s195["__p"]["st"], "lamp"), "sway"))
		v_r_519 = _t625
	J.mc(v_ctx_503, "rotate", [v_r_519])
	if J.t(J.gp(_s195["c"], "flip")):
		J.mc(v_ctx_503, "scale", [(-1.0), 1.0])
	if J.t(J.gp(_s195["c"], "paper")):
		J.mc(v_ctx_503, "scale", [1.0, (0.62 - (J.mul(0.12, J.gp(_s195["__p"]["st"], "flutter")) * (0.5 + (0.5 * sin(J.num(J.add(J.mul(v_t_510, 13.0), J.gp(_s195["c"], "ph"))))))))])
	v_kay_520 = (1.0 if J.leq(J.gp(_s195["c"], "ay"), null) else J.gp(_s195["c"], "ay"))
	var _t626 = J.gp(_s195["c"], "back")
	if J.t((J.gp(_s195["c"], "mon") if J.t(_t626) else _t626)):
		var _t627 = _s195["__p"]["monHalo"]
		var _t628 = _s195["__p"]["monState"]
		J.cl(_t627, null, [v_ctx_503, J.cl(_t628, null, [_s195["c"]]), J.mul((-J.num((0.5 if J.leq(J.gp(_s195["c"], "ax"), null) else J.gp(_s195["c"], "ax")))), v_cw_515), J.mul((-J.num(v_kay_520)), v_chh_516), v_cw_515, v_chh_516, v_u_509, v_t_510])
	J.mc(v_ctx_503, "drawImage", [v_im_512, J.mul((-J.num((0.5 if J.leq(J.gp(_s195["c"], "ax"), null) else J.gp(_s195["c"], "ax")))), v_cw_515), J.mul((-J.num(v_kay_520)), v_chh_516), v_cw_515, v_chh_516])
	if J.t(J.gp(_s195["c"], "side")):
		var _t629 = _s195["__p"]["monScreen"]
		J.cl(_t629, null, [v_ctx_503, _s195["c"], v_key_511, J.mul((-J.num((0.5 if J.leq(J.gp(_s195["c"], "ax"), null) else J.gp(_s195["c"], "ax")))), v_cw_515), J.mul((-J.num(v_kay_520)), v_chh_516), v_cw_515, v_chh_516, v_t_510])
	if J.t(J.gp(_s195["c"], "lamp")):
		var _t630 = _s195["__p"]["lampFx"]
		J.cl(_t630, null, [v_ctx_503, v_cw_515, v_chh_516, v_u_509, v_t_510])
	var _t631 = J.gp(_s195["c"], "mon")
	var _t632 = ((not J.t(J.gp(_s195["c"], "side"))) if J.t(_t631) else _t631)
	if J.t((J.seq(v_key_511, "op_mon_on") if J.t(_t632) else _t632)):
		v_g_524 = ((0.12 + (0.04 * sin(J.num(J.mul(v_t_510, 5.0))))) + (0.08 if (sin(J.num(J.mul(v_t_510, 0.7))) > 0.9) else 0.0))
		J.sp(v_ctx_503, "globalCompositeOperation", "lighter")
		var _t633 = ("rgba(120,190,255," + J.str(v_g_524) + ")")
		J.sp(v_ctx_503, "fillStyle", _t633)
		J.mc(v_ctx_503, "fillRect", [((-J.num(v_cw_515)) * 0.44), ((-J.num(v_chh_516)) * 0.95), J.mul(v_cw_515, 0.88), J.mul(v_chh_516, 0.68)])
	var _t634 = J.gp(_s195["c"], "mon")
	if J.t((J.seq(v_key_511, "op_mon_static") if J.t(_t634) else _t634)):
		J.sp(v_ctx_503, "globalCompositeOperation", "lighter")
		v_i_525 = 0.0
		while true:
			if not J.cmp(v_i_525, 5.0, "<"): break
			var _t635 = ("rgba(255,255,255," + J.str((0.15 * randf())) + ")")
			J.sp(v_ctx_503, "fillStyle", _t635)
			J.mc(v_ctx_503, "fillRect", [((-J.num(v_cw_515)) * 0.42), ((-J.num(v_chh_516)) * (0.92 - (randf() * 0.62))), J.mul(v_cw_515, 0.84), 1.5])
			v_i_525 = J.num(v_i_525) + 1.0
	J.mc(v_ctx_503, "restore", [])
	var _t636 = J.gp(_s195["c"], "mug")
	if J.t((J.cmp(J.gp(_s195["c"], "puddle"), 0.0, ">") if J.t(_t636) else _t636)):
		var _t637 = _s195["c"]
		var _t638 = J.sub(J.gp(_t637, "puddle"), J.div(1.0, 60.0))
		J.sp(_t637, "puddle", _t638)
		J.mc(v_ctx_503, "save", [])
		var _t639 = ("rgba(70,40,20," + J.str((0.55 * J.min_([1.0, J.div(J.gp(_s195["c"], "puddle"), 2.0)]))) + ")")
		J.sp(v_ctx_503, "fillStyle", _t639)
		J.mc(v_ctx_503, "beginPath", [])
		J.mc(v_ctx_503, "ellipse", [J.add(v_x_517, J.mul(v_u_509, 0.06)), J.add(v_y_518, J.mul(v_u_509, 0.01)), J.mul(v_u_509, 0.07), J.mul(v_u_509, 0.016), 0.0, 0.0, J.mul(_s195["__p"]["PI"], 2.0)])
		J.mc(v_ctx_503, "fill", [])
		J.mc(v_ctx_503, "restore", [])

func _f83(this_, a: Array, env):
	var v_p_541 = null; var v_i_542 = null; var v_x_543 = null; var v_y_544 = null
	v_p_541 = J.arg(a, 0)
	v_i_542 = J.arg(a, 1)
	v_x_543 = J.add(env["L"], J.mul(J.gp(v_p_541, 0.0), env["w"]))
	v_y_544 = J.add(env["T"], J.mul(J.gp(v_p_541, 1.0), env["h"]))
	if J.t(v_i_542):
		J.mc(env["ctx"], "lineTo", [v_x_543, v_y_544])
	else:
		J.mc(env["ctx"], "moveTo", [v_x_543, v_y_544])

func _f82(this_, a: Array, env):
	var v_c_529 = null; var v_key_530 = null; var v_t_535 = null; var v_Q_536 = null; var v_m_537 = null; var v_q_538 = null; var v_isStatic_539 = null; var v_on_540 = null; var v_g_545 = null; var v_i_546 = null; var v_yy_547 = null; var v_a_548 = null; var v_i_549 = null
	var _s206 = {"__p": env, "ctx": null, "L": null, "T": null, "w": null, "h": null}
	_s206["ctx"] = J.arg(a, 0)
	v_c_529 = J.arg(a, 1)
	v_key_530 = J.arg(a, 2)
	_s206["L"] = J.arg(a, 3)
	_s206["T"] = J.arg(a, 4)
	_s206["w"] = J.arg(a, 5)
	_s206["h"] = J.arg(a, 6)
	v_t_535 = J.arg(a, 7)
	v_Q_536 = J.gp(_s206["__p"]["QUAD"], v_key_530)
	if (not J.t(v_Q_536)):
		return null
	v_m_537 = (J.gp(_s206["__p"]["st"], "mon") if J.t(J.gp(v_c_529, "ken")) else J.gp(_s206["__p"]["st"], "amon"))
	v_q_538 = J.gp(v_m_537, "seq")
	var _t640 = J.cmp(v_q_538, 0.0, ">=")
	var _t643 = (J.seq(v_key_530, "op_mon_side_off") if _t640 else _t640)
	if J.t(_t643):
		var _t642 = J.cmp(v_q_538, 0.55, "<")
		if not J.t(_t642):
			var _t641 = J.cmp(v_q_538, 1.4, ">=")
			_t642 = ((sin(J.num(J.mul(v_q_538, 60.0))) > 0.0) if _t641 else _t641)
		_t643 = _t642
	v_isStatic_539 = _t643
	v_on_540 = J.seq(v_key_530, "op_mon_side_on")
	var _t644 = (not J.t(v_on_540))
	if ((not J.t(v_isStatic_539)) if _t644 else _t644):
		return null
	J.mc(_s206["ctx"], "save", [])
	J.mc(_s206["ctx"], "beginPath", [])
	J.mc(v_Q_536, "forEach", [Callable(self, "_f83").bind(_s206)])
	J.mc(_s206["ctx"], "closePath", [])
	J.mc(_s206["ctx"], "clip", [])
	var _t645 = _s206["ctx"]
	J.sp(_t645, "globalCompositeOperation", "lighter")
	if J.t(v_on_540):
		v_g_545 = ((0.1 + (0.04 * sin(J.num(J.mul(v_t_535, 5.0))))) + (0.08 if (sin(J.num(J.mul(v_t_535, 0.7))) > 0.9) else 0.0))
		var _t646 = _s206["ctx"]
		var _t647 = ("rgba(120,190,255," + J.str(v_g_545) + ")")
		J.sp(_t646, "fillStyle", _t647)
		J.mc(_s206["ctx"], "fillRect", [_s206["L"], _s206["T"], _s206["w"], _s206["h"]])
	else:
		var _t648 = _s206["ctx"]
		J.sp(_t648, "fillStyle", "rgba(120,120,150,.25)")
		J.mc(_s206["ctx"], "fillRect", [_s206["L"], _s206["T"], _s206["w"], _s206["h"]])
		v_i_546 = 0.0
		while true:
			if not J.cmp(v_i_546, 14.0, "<"): break
			v_yy_547 = J.add(_s206["T"], J.mul(_s206["h"], (0.05 + (randf() * 0.7))))
			v_a_548 = (0.25 + (randf() * 0.5))
			var _t649 = _s206["ctx"]
			var _t650 = ("rgba(" + J.str(J.bor((200.0 + (randf() * 55.0)), 0.0)) + "," + J.str(J.bor((200.0 + (randf() * 55.0)), 0.0)) + ",255," + J.str(v_a_548) + ")")
			J.sp(_t649, "fillStyle", _t650)
			J.mc(_s206["ctx"], "fillRect", [J.add(_s206["L"], J.mul(_s206["w"], 0.2)), v_yy_547, J.mul(_s206["w"], 0.75), J.max_([1.0, J.mul(_s206["h"], 0.012)])])
			v_i_546 = J.num(v_i_546) + 1.0
		v_i_549 = 0.0
		while true:
			if not J.cmp(v_i_549, 40.0, "<"): break
			var _t651 = _s206["ctx"]
			var _t652 = ("rgba(255,255,255," + J.str((randf() * 0.6)) + ")")
			J.sp(_t651, "fillStyle", _t652)
			J.mc(_s206["ctx"], "fillRect", [J.add(_s206["L"], J.mul(_s206["w"], (0.22 + (randf() * 0.68)))), J.add(_s206["T"], J.mul(_s206["h"], (0.08 + (randf() * 0.62)))), 1.5, 1.5])
			v_i_549 = J.num(v_i_549) + 1.0
	J.mc(_s206["ctx"], "restore", [])

func _f84(this_, a: Array, env):
	var v_s_552 = null; var v_t_553 = null
	v_s_552 = J.arg(a, 0)
	v_t_553 = J.arg(a, 1)
	if J.seq(v_s_552, "on"):
		return [120.0, 185.0, 255.0, ((0.5 + (0.08 * sin(J.num(J.mul(v_t_553, 5.0))))) + (0.15 if (sin(J.num(J.mul(v_t_553, 0.7))) > 0.9) else 0.0))]
	if J.seq(v_s_552, "static"):
		return [235.0, 240.0, 255.0, (0.35 + (0.5 * randf()))]
	return null

func _f85(this_, a: Array, env):
	var v_ctx_556 = null; var v_s_557 = null; var v_L_558 = null; var v_T_559 = null; var v_w_560 = null; var v_h_561 = null; var v_u_562 = null; var v_t_563 = null; var v_c_564 = null; var v_cx_565 = null; var v_cy_566 = null; var v_R_567 = null; var v_g_568 = null
	v_ctx_556 = J.arg(a, 0)
	v_s_557 = J.arg(a, 1)
	v_L_558 = J.arg(a, 2)
	v_T_559 = J.arg(a, 3)
	v_w_560 = J.arg(a, 4)
	v_h_561 = J.arg(a, 5)
	v_u_562 = J.arg(a, 6)
	v_t_563 = J.arg(a, 7)
	var _t653 = env["monLight"]
	v_c_564 = J.cl(_t653, null, [v_s_557, v_t_563])
	if (not J.t(v_c_564)):
		return null
	v_cx_565 = J.add(v_L_558, J.mul(v_w_560, 0.5))
	v_cy_566 = J.add(v_T_559, J.mul(v_h_561, 0.36))
	v_R_567 = (J.max_([v_w_560, J.mul(v_h_561, 0.75)]) * 0.8)
	J.mc(v_ctx_556, "save", [])
	J.sp(v_ctx_556, "globalCompositeOperation", "lighter")
	v_g_568 = J.mc(v_ctx_556, "createRadialGradient", [v_cx_565, v_cy_566, J.mul(v_R_567, 0.4), v_cx_565, v_cy_566, v_R_567])
	J.mc(v_g_568, "addColorStop", [0.0, ("rgba(" + J.str(J.gp(v_c_564, 0.0)) + "," + J.str(J.gp(v_c_564, 1.0)) + "," + J.str(J.gp(v_c_564, 2.0)) + "," + J.str(J.mul(0.9, J.gp(v_c_564, 3.0))) + ")")])
	J.mc(v_g_568, "addColorStop", [1.0, ("rgba(" + J.str(J.gp(v_c_564, 0.0)) + "," + J.str(J.gp(v_c_564, 1.0)) + "," + J.str(J.gp(v_c_564, 2.0)) + ",0)")])
	J.sp(v_ctx_556, "fillStyle", v_g_568)
	J.mc(v_ctx_556, "beginPath", [])
	J.mc(v_ctx_556, "ellipse", [v_cx_565, v_cy_566, v_R_567, J.mul(v_R_567, 0.85), 0.0, 0.0, J.mul(env["PI"], 2.0)])
	J.mc(v_ctx_556, "fill", [])
	J.mc(v_ctx_556, "restore", [])

func _f86(this_, a: Array, env):
	var v_ctx_571 = null; var v_L_572 = null; var v_T_573 = null; var v_w_574 = null; var v_h_575 = null; var v_u_576 = null; var v_t_577 = null; var v_m_578 = null; var v_c_579 = null; var v_x_580 = null; var v_y_581 = null; var v_g_582 = null
	v_ctx_571 = J.arg(a, 0)
	v_L_572 = J.arg(a, 1)
	v_T_573 = J.arg(a, 2)
	v_w_574 = J.arg(a, 3)
	v_h_575 = J.arg(a, 4)
	v_u_576 = J.arg(a, 5)
	v_t_577 = J.arg(a, 6)
	v_m_578 = env["this_mon"]
	var _t656 = v_m_578
	if J.t(_t656):
		var _t654 = env["monLight"]
		var _t655 = env["monState"]
		_t656 = J.cl(_t654, null, [J.cl(_t655, null, [v_m_578]), v_t_577])
	v_c_579 = _t656
	if (not J.t(v_c_579)):
		return null
	v_x_580 = J.add(v_L_572, J.mul(J.gp(v_m_578, "u"), v_w_574))
	v_y_581 = J.add(v_T_573, J.mul(J.gp(v_m_578, "v"), v_h_575))
	J.mc(v_ctx_571, "save", [])
	J.sp(v_ctx_571, "globalCompositeOperation", "lighter")
	v_g_582 = J.mc(v_ctx_571, "createRadialGradient", [J.add(v_x_580, J.mul(v_u_576, 0.12)), J.sub(v_y_581, J.mul(v_u_576, 0.02)), 0.0, J.add(v_x_580, J.mul(v_u_576, 0.12)), J.sub(v_y_581, J.mul(v_u_576, 0.02)), J.mul(v_u_576, 0.32)])
	J.mc(v_g_582, "addColorStop", [0.0, ("rgba(" + J.str(J.gp(v_c_579, 0.0)) + "," + J.str(J.gp(v_c_579, 1.0)) + "," + J.str(J.gp(v_c_579, 2.0)) + "," + J.str(J.mul(0.22, J.gp(v_c_579, 3.0))) + ")")])
	J.mc(v_g_582, "addColorStop", [1.0, ("rgba(" + J.str(J.gp(v_c_579, 0.0)) + "," + J.str(J.gp(v_c_579, 1.0)) + "," + J.str(J.gp(v_c_579, 2.0)) + ",0)")])
	J.sp(v_ctx_571, "fillStyle", v_g_582)
	J.mc(v_ctx_571, "beginPath", [])
	J.mc(v_ctx_571, "ellipse", [J.add(v_x_580, J.mul(v_u_576, 0.12)), J.sub(v_y_581, J.mul(v_u_576, 0.02)), J.mul(v_u_576, 0.32), J.mul(v_u_576, 0.12), (-0.3), 0.0, J.mul(env["PI"], 2.0)])
	J.mc(v_ctx_571, "fill", [])
	J.mc(v_ctx_571, "restore", [])

func _f87(this_, a: Array, env):
	var v_ctx_585 = null; var v_w_586 = null; var v_h_587 = null; var v_u_588 = null; var v_t_589 = null; var v_L_590 = null; var v_on_591 = null; var v_bx_592 = null; var v_by_593 = null; var v_g_594 = null
	v_ctx_585 = J.arg(a, 0)
	v_w_586 = J.arg(a, 1)
	v_h_587 = J.arg(a, 2)
	v_u_588 = J.arg(a, 3)
	v_t_589 = J.arg(a, 4)
	v_L_590 = J.gp(env["st"], "lamp")
	v_on_591 = (false if J.t(J.gp(J.gp(env["STATIONS"], "it"), "offline")) else (((sin(J.num(J.mul(v_t_589, 31.0))) + sin(J.num(J.mul(v_t_589, 13.0)))) > 0.3) if J.cmp(J.gp(v_L_590, "flick"), 0.0, ">") else true))
	v_bx_592 = J.mul((0.88 - 0.78), v_w_586)
	v_by_593 = ((-J.num(v_h_587)) * (1.0 - 0.4))
	J.mc(v_ctx_585, "save", [])
	J.sp(v_ctx_585, "globalCompositeOperation", "lighter")
	if J.t(v_on_591):
		v_g_594 = J.mc(v_ctx_585, "createRadialGradient", [v_bx_592, J.add(v_by_593, J.mul(v_h_587, 0.25)), 0.0, v_bx_592, J.add(v_by_593, J.mul(v_h_587, 0.25)), J.mul(v_u_588, 0.55)])
		J.mc(v_g_594, "addColorStop", [0.0, "rgba(255,200,110,.38)"])
		J.mc(v_g_594, "addColorStop", [1.0, "rgba(255,200,110,0)"])
		J.sp(v_ctx_585, "fillStyle", v_g_594)
		J.mc(v_ctx_585, "beginPath", [])
		J.mc(v_ctx_585, "arc", [v_bx_592, J.add(v_by_593, J.mul(v_h_587, 0.25)), J.mul(v_u_588, 0.55), 0.0, J.mul(env["PI"], 2.0)])
		J.mc(v_ctx_585, "fill", [])
	J.mc(v_ctx_585, "restore", [])
	if (not J.t(v_on_591)):
		J.mc(v_ctx_585, "save", [])
		J.sp(v_ctx_585, "fillStyle", "rgba(20,14,30,.75)")
		J.mc(v_ctx_585, "beginPath", [])
		J.mc(v_ctx_585, "ellipse", [J.add(v_bx_592, J.mul(v_w_586, 0.02)), J.add(v_by_593, J.mul(v_h_587, 0.02)), J.mul(v_w_586, 0.12), J.mul(v_h_587, 0.07), (-0.5), 0.0, J.mul(env["PI"], 2.0)])
		J.mc(v_ctx_585, "fill", [])
		J.mc(v_ctx_585, "restore", [])

func _f88(this_, a: Array, env):
	var v_ctx_597 = null; var v_L_598 = null; var v_T_599 = null; var v_w_600 = null; var v_h_601 = null; var v_u_602 = null; var v_t_603 = null; var v_k_604 = null; var v_q_605 = null; var v_x_606 = null; var v_e_607 = null; var v_g_608 = null
	v_ctx_597 = J.arg(a, 0)
	v_L_598 = J.arg(a, 1)
	v_T_599 = J.arg(a, 2)
	v_w_600 = J.arg(a, 3)
	v_h_601 = J.arg(a, 4)
	v_u_602 = J.arg(a, 5)
	v_t_603 = J.arg(a, 6)
	var _t658 = J.gp(J.gp(env["st"], "copier"), "print")
	var _t657 = J.gp(J.gp(env["st"], "copier"), "idle")
	var _t660 = J.gp(J.gp(env["st"], "copier"), "print")
	var _t659 = J.gp(J.gp(env["st"], "copier"), "idle")
	v_k_604 = J.max_([_t660, (_t659 if J.t(_t659) else 0.0)])
	if J.cmp(v_k_604, 0.0, "<="):
		return null
	v_q_605 = J.mod(J.mul(v_t_603, 1.6), 1.0)
	v_x_606 = J.add(v_L_598, J.mul(v_w_600, (0.42 + J.mul(0.3, v_q_605))))
	v_e_607 = J.min_([1.0, J.mul(v_k_604, 3.0)])
	J.mc(v_ctx_597, "save", [])
	J.sp(v_ctx_597, "globalCompositeOperation", "lighter")
	var _t661 = ("rgba(150,255,190," + J.str(J.mul(0.55, v_e_607)) + ")")
	J.sp(v_ctx_597, "fillStyle", _t661)
	J.mc(v_ctx_597, "fillRect", [v_x_606, J.add(v_T_599, J.mul(v_h_601, 0.27)), J.mul(v_w_600, 0.03), J.mul(v_h_601, 0.06)])
	v_g_608 = J.mc(v_ctx_597, "createRadialGradient", [J.add(v_L_598, J.mul(v_w_600, 0.55)), J.add(v_T_599, J.mul(v_h_601, 0.3)), 0.0, J.add(v_L_598, J.mul(v_w_600, 0.55)), J.add(v_T_599, J.mul(v_h_601, 0.3)), J.mul(v_w_600, 0.5)])
	J.mc(v_g_608, "addColorStop", [0.0, ("rgba(150,255,190," + J.str(J.mul(0.25, v_e_607)) + ")")])
	J.mc(v_g_608, "addColorStop", [1.0, "rgba(150,255,190,0)"])
	J.sp(v_ctx_597, "fillStyle", v_g_608)
	J.mc(v_ctx_597, "fillRect", [v_L_598, v_T_599, v_w_600, J.mul(v_h_601, 0.7)])
	J.mc(v_ctx_597, "restore", [])

func _f89(this_, a: Array, env):
	var v_ctx_611 = null; var v_L_612 = null; var v_T_613 = null; var v_w_614 = null; var v_h_615 = null; var v_u_616 = null; var v_t_617 = null; var v_k_618 = null; var v_i_619 = null; var v_q_620 = null; var v_bx_621 = null; var v_by_622 = null; var v_r_623 = null
	v_ctx_611 = J.arg(a, 0)
	v_L_612 = J.arg(a, 1)
	v_T_613 = J.arg(a, 2)
	v_w_614 = J.arg(a, 3)
	v_h_615 = J.arg(a, 4)
	v_u_616 = J.arg(a, 5)
	v_t_617 = J.arg(a, 6)
	v_k_618 = J.gp(J.gp(env["st"], "water"), "glug")
	if J.cmp(v_k_618, 0.0, "<="):
		return null
	J.mc(v_ctx_611, "save", [])
	J.mc(v_ctx_611, "beginPath", [])
	J.mc(v_ctx_611, "ellipse", [J.add(v_L_612, J.mul(v_w_614, 0.48)), J.add(v_T_613, J.mul(v_h_615, 0.21)), J.mul(v_w_614, 0.33), J.mul(v_h_615, 0.17), 0.0, 0.0, J.mul(env["PI"], 2.0)])
	J.mc(v_ctx_611, "clip", [])
	v_i_619 = 0.0
	while true:
		if not J.cmp(v_i_619, 9.0, "<"): break
		var _t662 = env["rnd"]
		var _t664 = J.mul(v_t_617, (0.7 + J.mul(J.cl(_t662, null, [v_i_619]), 0.6)))
		var _t663 = env["rnd"]
		v_q_620 = J.mod(J.add(_t664, J.cl(_t663, null, [J.add(v_i_619, 9.0)])), 1.0)
		var _t665 = env["rnd"]
		v_bx_621 = J.add(J.add(v_L_612, J.mul(v_w_614, (0.3 + J.mul(0.36, J.cl(_t665, null, [J.add(v_i_619, 3.0)]))))), (J.mul(sin(J.num(J.add(J.mul(v_t_617, 5.0), v_i_619))), v_w_614) * 0.03))
		v_by_622 = J.add(v_T_613, J.mul(v_h_615, (0.37 - J.mul(v_q_620, 0.3))))
		var _t666 = env["rnd"]
		v_r_623 = (J.mul(v_w_614, (0.03 + J.mul(0.05, J.cl(_t666, null, [J.add(v_i_619, 5.0)])))) * (0.6 + J.mul(v_q_620, 0.6)))
		var _t667 = ("rgba(225,245,255," + J.str((0.85 * J.min_([1.0, v_k_618]))) + ")")
		J.sp(v_ctx_611, "strokeStyle", _t667)
		J.sp(v_ctx_611, "lineWidth", 1.4)
		J.mc(v_ctx_611, "beginPath", [])
		J.mc(v_ctx_611, "arc", [v_bx_621, v_by_622, v_r_623, 0.0, J.mul(env["PI"], 2.0)])
		J.mc(v_ctx_611, "stroke", [])
		v_i_619 = J.num(v_i_619) + 1.0
	J.mc(v_ctx_611, "restore", [])

func _f90(this_, a: Array, env):
	var v_ctx_626 = null; var v_it_627 = null; var v_L_628 = null; var v_T_629 = null; var v_w_630 = null; var v_h_631 = null; var v_u_632 = null; var v_t_633 = null; var v_K_634 = null; var v_k_635 = null; var v_d_636 = null; var v_x_637 = null; var v_y_638 = null
	v_ctx_626 = J.arg(a, 0)
	v_it_627 = J.arg(a, 1)
	v_L_628 = J.arg(a, 2)
	v_T_629 = J.arg(a, 3)
	v_w_630 = J.arg(a, 4)
	v_h_631 = J.arg(a, 5)
	v_u_632 = J.arg(a, 6)
	v_t_633 = J.arg(a, 7)
	var _t668 = J.gp(v_it_627, "stn")
	v_K_634 = (J.gp(J.gp(env["STATIONS"], J.gp(v_it_627, "stn")), "K") if J.t(_t668) else _t668)
	if (not J.t(v_K_634)):
		return null
	J.mc(v_ctx_626, "save", [])
	J.sp(v_ctx_626, "globalCompositeOperation", "lighter")
	for _t669 in J.iter(J.gp(v_K_634, "keys")):
		v_k_635 = _t669
		var _t670 = ("rgba(200,240,255," + J.str(J.mul(J.gp(v_k_635, "life"), 3.0)) + ")")
		J.sp(v_ctx_626, "fillStyle", _t670)
		J.mc(v_ctx_626, "fillRect", [J.add(v_L_628, J.mul(J.gp(v_k_635, "u"), v_w_630)), J.add(v_T_629, J.mul(J.gp(v_k_635, "v"), v_h_631)), J.mul(v_w_630, 0.022), J.mul(v_h_631, 0.014)])
	J.mc(v_ctx_626, "restore", [])
	for _t671 in J.iter(env["drops"]):
		v_d_636 = _t671
		if J.seq(J.gp(v_d_636, "desk"), v_it_627):
			v_x_637 = J.add(J.add(v_L_628, J.mul(J.gp(v_d_636, "u"), v_w_630)), J.mul(J.gp(v_d_636, "ox"), v_u_632))
			v_y_638 = J.sub(J.add(v_T_629, J.mul(J.gp(v_d_636, "v"), v_h_631)), J.mul(J.gp(v_d_636, "z"), v_u_632))
			var _t672 = ("rgba(80,46,22," + J.str((0.85 * J.min_([1.0, J.gp(v_d_636, "life")]))) + ")")
			J.sp(v_ctx_626, "fillStyle", _t672)
			J.mc(v_ctx_626, "beginPath", [])
			J.mc(v_ctx_626, "ellipse", [v_x_637, v_y_638, J.mul(v_u_632, 0.009), (J.mul(v_u_632, 0.005) if J.t(J.gp(v_d_636, "land")) else J.mul(v_u_632, 0.012)), 0.0, 0.0, J.mul(env["PI"], 2.0)])
			J.mc(v_ctx_626, "fill", [])

func _f91(this_, a: Array, env):
	var v_ctx_641 = null; var v_it_642 = null; var v_F_643 = null; var v_t_644 = null; var v_im_645 = null; var v_w_646 = null; var v_h_647 = null; var v_u_648 = null; var v_L_649 = null; var v_T_650 = null; var v_osc_651 = null; var v_cut_652 = null; var v_cx_653 = null; var v_cy_654 = null; var v_sx_655 = null; var v_r_656 = null; var v_spd_657 = null; var v_i_658 = null; var v_a_659 = null; var v_i_660 = null; var v_q_661 = null; var v_x_662 = null; var v_y_663 = null
	v_ctx_641 = J.arg(a, 0)
	v_it_642 = J.arg(a, 1)
	v_F_643 = J.arg(a, 2)
	v_t_644 = J.arg(a, 3)
	var _t673 = env["img"]
	v_im_645 = J.cl(_t673, null, [J.gp(v_it_642, "spr")])
	var _t674 = J.gp(v_F_643, "w")
	v_w_646 = _t674
	var _t675 = J.gp(v_F_643, "h")
	v_h_647 = _t675
	var _t676 = J.gp(v_F_643, "u")
	v_u_648 = _t676
	v_L_649 = J.mul((-0.5), v_w_646)
	v_T_650 = (-J.num(v_h_647))
	v_osc_651 = (sin(J.num(J.gp(J.gp(env["st"], "fan"), "osc"))) * (0.7 + J.mul(J.gp(J.gp(env["st"], "fan"), "boost"), 0.2)))
	v_cut_652 = 0.5
	J.mc(v_ctx_641, "drawImage", [v_im_645, 0.0, J.mul(J.gp(v_im_645, "height"), v_cut_652), J.gp(v_im_645, "width"), J.mul(J.gp(v_im_645, "height"), J.sub(1.0, v_cut_652)), v_L_649, J.add(v_T_650, J.mul(v_h_647, v_cut_652)), v_w_646, J.mul(v_h_647, J.sub(1.0, v_cut_652))])
	v_cx_653 = 0.0
	v_cy_654 = J.add(v_T_650, J.mul(v_h_647, 0.237))
	v_sx_655 = ((cos(J.num(v_osc_651)) * 0.85) + 0.15)
	J.mc(v_ctx_641, "save", [])
	J.mc(v_ctx_641, "translate", [v_cx_653, v_cy_654])
	J.mc(v_ctx_641, "scale", [v_sx_655, 1.0])
	J.mc(v_ctx_641, "translate", [(-J.num(v_cx_653)), (-J.num(v_cy_654))])
	J.mc(v_ctx_641, "drawImage", [v_im_645, 0.0, 0.0, J.gp(v_im_645, "width"), J.mul(J.gp(v_im_645, "height"), v_cut_652), v_L_649, v_T_650, v_w_646, J.mul(v_h_647, v_cut_652)])
	v_r_656 = J.mul(v_w_646, 0.36)
	v_spd_657 = (1.0 + J.mul(J.gp(J.gp(env["st"], "fan"), "boost"), 2.5))
	J.sp(v_ctx_641, "globalCompositeOperation", "source-over")
	v_i_658 = 0.0
	while true:
		if not J.cmp(v_i_658, 3.0, "<"): break
		v_a_659 = J.add(J.gp(J.gp(env["st"], "fan"), "spin"), J.div(J.mul(J.mul(v_i_658, 2.0), env["PI"]), 3.0))
		var _t677 = ("rgba(235,230,210," + J.str((0.18 + (0.1 * J.min_([1.0, J.div(v_spd_657, 3.0)])))) + ")")
		J.sp(v_ctx_641, "strokeStyle", _t677)
		var _t678 = J.mul(v_r_656, 0.28)
		J.sp(v_ctx_641, "lineWidth", _t678)
		J.mc(v_ctx_641, "beginPath", [])
		J.mc(v_ctx_641, "arc", [v_cx_653, v_cy_654, J.mul(v_r_656, 0.62), v_a_659, J.add(J.add(v_a_659, 0.5), (0.35 * J.min_([1.0, J.div(v_spd_657, 3.0)])))])
		J.mc(v_ctx_641, "stroke", [])
		v_i_658 = J.num(v_i_658) + 1.0
	J.mc(v_ctx_641, "restore", [])
	if J.cmp(J.gp(J.gp(env["st"], "fan"), "boost"), 0.2, ">"):
		J.mc(v_ctx_641, "save", [])
		var _t679 = ("rgba(230,240,255," + J.str((0.35 * J.min_([1.0, J.gp(J.gp(env["st"], "fan"), "boost")]))) + ")")
		J.sp(v_ctx_641, "strokeStyle", _t679)
		J.sp(v_ctx_641, "lineWidth", 1.5)
		v_i_660 = 0.0
		while true:
			if not J.cmp(v_i_660, 3.0, "<"): break
			v_q_661 = J.mod((J.mul(v_t_644, 2.0) + J.div(v_i_660, 3.0)), 1.0)
			v_x_662 = (((-J.num(v_w_646)) * 0.6) - (J.mul(v_q_661, v_w_646) * 1.5))
			v_y_663 = J.add(v_cy_654, (J.mul(J.sub(v_i_660, 1.0), v_h_647) * 0.08))
			J.mc(v_ctx_641, "beginPath", [])
			J.mc(v_ctx_641, "moveTo", [v_x_662, v_y_663])
			J.mc(v_ctx_641, "quadraticCurveTo", [J.sub(v_x_662, J.mul(v_w_646, 0.3)), J.add(v_y_663, (sin(J.num(J.add(J.mul(v_t_644, 8.0), v_i_660))) * 4.0)), J.sub(v_x_662, J.mul(v_w_646, 0.6)), v_y_663])
			J.mc(v_ctx_641, "stroke", [])
			v_i_660 = J.num(v_i_660) + 1.0
		J.mc(v_ctx_641, "restore", [])

func _f92(this_, a: Array, env):
	var v_ctx_666 = null; var v_it_667 = null; var v_t_668 = null; var v_ox_669 = null; var v_oz_670 = null; var v_x_671 = null; var v_y_672 = null; var v_u_673 = null
	v_ctx_666 = J.arg(a, 0)
	v_it_667 = J.arg(a, 1)
	v_t_668 = J.arg(a, 2)
	var _t680 = J.gp(v_it_667, "ox")
	v_ox_669 = (_t680 if J.t(_t680) else 0.0)
	var _t681 = J.gp(v_it_667, "oz")
	v_oz_670 = (_t681 if J.t(_t681) else 0.0)
	var _t682 = env["P"]
	var _t683 = J.cl(_t682, null, [J.add(J.gp(v_it_667, "x"), v_ox_669), J.add(J.gp(v_it_667, "y"), v_oz_670)])
	var _t684 = J.gp(_t683, 0.0)
	v_x_671 = _t684
	var _t685 = J.gp(_t683, 1.0)
	v_y_672 = _t685
	var _t686 = env["U"]
	v_u_673 = J.cl(_t686, null, [J.add(J.gp(v_it_667, "y"), v_oz_670)])
	var _t687 = env["chairSprite"]
	var _t688 = J.gp(v_it_667, "sw")
	J.cl(_t687, null, [v_ctx_666, v_x_671, v_y_672, v_u_673, (_t688 if J.t(_t688) else 0.0), 0.0, "of_chair_back", J.gp(v_it_667, "h"), false])

func _f93(this_, a: Array, env):
	var v_ctx_676 = null; var v_x_677 = null; var v_y_678 = null; var v_u_679 = null; var v_sw_680 = null; var v_lean_681 = null; var v_front_682 = null; var v_hU_683 = null; var v_flipFront_684 = null; var v_anchorU_685 = null; var v_c_686 = null; var v_useBack_687 = null; var v_key_688 = null; var v_im_689 = null; var v_h_690 = null; var v_w_691 = null; var v_sx_692 = null; var v_ax_693 = null
	v_ctx_676 = J.arg(a, 0)
	v_x_677 = J.arg(a, 1)
	v_y_678 = J.arg(a, 2)
	v_u_679 = J.arg(a, 3)
	v_sw_680 = J.arg(a, 4)
	v_lean_681 = J.arg(a, 5)
	v_front_682 = J.arg(a, 6)
	v_hU_683 = J.arg(a, 7)
	v_flipFront_684 = J.arg(a, 8)
	v_anchorU_685 = J.arg(a, 9)
	v_c_686 = cos(J.num(v_sw_680))
	v_useBack_687 = J.cmp(v_c_686, 0.0, "<")
	v_key_688 = (("of_chair_front" if J.seq(v_front_682, "of_chair_back") else "of_chair_back") if J.t(v_useBack_687) else v_front_682)
	var _t689 = env["img"]
	v_im_689 = J.cl(_t689, null, [v_key_688])
	if (not J.t(v_im_689)):
		return null
	v_h_690 = J.mul(v_hU_683, v_u_679)
	v_w_691 = J.div(J.mul(v_h_690, J.gp(v_im_689, "width")), J.gp(v_im_689, "height"))
	v_sx_692 = (J.max_([0.35, absf(J.num(v_c_686))]) * (1.0 if (not J.seq((sin(J.num(v_sw_680)) > 0.0), v_useBack_687)) else 1.0))
	var _t690 = env["shadowAt"]
	J.cl(_t690, null, [v_ctx_676, v_x_677, v_y_678, J.mul(v_w_691, 0.85), 0.34])
	J.mc(v_ctx_676, "save", [])
	J.mc(v_ctx_676, "translate", [v_x_677, v_y_678])
	if J.t(v_lean_681):
		J.mc(v_ctx_676, "translate", [0.0, ((-J.num(v_h_690)) * 0.4)])
		J.mc(v_ctx_676, "rotate", [v_lean_681])
		J.mc(v_ctx_676, "translate", [0.0, J.mul(v_h_690, 0.4)])
	var _t693 = ((not J.t(v_useBack_687)) if J.t(v_flipFront_684) else v_flipFront_684)
	if not J.t(_t693):
		var _t691 = (not J.t(v_flipFront_684))
		var _t692 = (v_useBack_687 if _t691 else _t691)
		_t693 = ((not J.seq(v_front_682, "of_chair_back")) if J.t(_t692) else _t692)
	J.mc(v_ctx_676, "scale", [J.mul(v_sx_692, ((-1.0) if J.t(_t693) else 1.0)), 1.0])
	v_ax_693 = ((J.sub(1.0, v_anchorU_685) if J.t(v_useBack_687) else v_anchorU_685) if (not J.leq(v_anchorU_685, null)) else 0.5)
	J.mc(v_ctx_676, "drawImage", [v_im_689, J.mul((-J.num(v_ax_693)), v_w_691), (-J.num(v_h_690)), v_w_691, v_h_690])
	J.mc(v_ctx_676, "restore", [])

func _f94(this_, a: Array, env):
	var v_ctx_696 = null; var v___697 = null; var v_t_698 = null; var v_ch_699 = null; var v_x_700 = null; var v_y_701 = null; var v_u_702 = null; var v_bx_703 = null
	v_ctx_696 = J.arg(a, 0)
	v___697 = J.arg(a, 1)
	v_t_698 = J.arg(a, 2)
	v_ch_699 = J.gp(env["K"], "ch")
	var _t694 = env["P"]
	var _t695 = J.cl(_t694, null, [J.add(J.gp(env["SEATV"], "x"), J.gp(v_ch_699, "dx")), J.add(J.gp(env["SEAT"], "y"), J.gp(v_ch_699, "dz"))])
	var _t696 = J.gp(_t695, 0.0)
	v_x_700 = _t696
	var _t697 = J.gp(_t695, 1.0)
	v_y_701 = _t697
	var _t698 = env["U"]
	v_u_702 = J.cl(_t698, null, [J.add(J.gp(env["SEAT"], "y"), J.gp(v_ch_699, "dz"))])
	v_bx_703 = v_x_700
	var _t699 = env["chairSprite"]
	J.cl(_t699, null, [v_ctx_696, v_bx_703, v_y_701, v_u_702, J.gp(v_ch_699, "sw"), 0.0, J.gp(env["CHAIR"], "spr"), J.gp(env["CHAIR"], "h"), true, J.sub(1.0, J.gp(env["CHAIR"], "back"))])

func _f95(this_, a: Array, env):
	var v_ctx_706 = null; var v_c_707 = null; var v_p_708 = null; var v_F_709 = null; var v_im_710 = null; var v_G_711 = null; var v_fv_712 = null; var v_ch_713 = null; var v_cw_714 = null; var v_sg_715 = null; var v_fx_716 = null; var v_fy_717 = null; var v_q_718 = null
	v_ctx_706 = J.arg(a, 0)
	v_c_707 = J.arg(a, 1)
	v_p_708 = J.gp(v_c_707, "parent")
	var _t700 = env["frameOf"]
	v_F_709 = J.cl(_t700, null, [v_p_708])
	var _t701 = env["img"]
	v_im_710 = J.cl(_t701, null, [J.gp(v_c_707, "spr")])
	if (not J.t(v_im_710)):
		return null
	v_G_711 = J.gp(v_c_707, "falling")
	v_fv_712 = (J.gp(v_p_708, "floorV") if (not J.leq(J.gp(v_p_708, "floorV"), null)) else J.gp(v_p_708, "ay"))
	v_ch_713 = J.mul(J.gp(v_c_707, "h"), J.gp(v_F_709, "u"))
	v_cw_714 = J.div(J.mul(v_ch_713, J.gp(v_im_710, "width")), J.gp(v_im_710, "height"))
	v_sg_715 = ((-1.0) if J.t(J.gp(v_p_708, "flip")) else 1.0)
	v_fx_716 = J.add(J.add(J.gp(v_F_709, "x"), J.mul(J.mul(v_sg_715, J.sub(J.gp(v_c_707, "u"), J.gp(v_p_708, "ax"))), J.gp(v_F_709, "w"))), J.mul(J.gp(v_G_711, "x"), J.gp(v_F_709, "u")))
	v_fy_717 = J.add(J.add(J.gp(v_F_709, "y"), J.mul(J.sub(v_fv_712, J.gp(v_p_708, "ay")), J.gp(v_F_709, "h"))), J.mul(J.gp(v_F_709, "u"), 0.03))
	if J.cmp(J.gp(v_G_711, "z"), 0.3, "<"):
		var _t702 = env["shadowAt"]
		J.cl(_t702, null, [v_ctx_706, v_fx_716, v_fy_717, J.mul(v_cw_714, 0.9), (0.25 * (1.0 - J.div(J.gp(v_G_711, "z"), 0.3)))])
	J.mc(v_ctx_706, "save", [])
	J.mc(v_ctx_706, "translate", [v_fx_716, J.sub(v_fy_717, J.mul(J.gp(v_G_711, "z"), J.gp(v_F_709, "u")))])
	J.mc(v_ctx_706, "rotate", [J.gp(v_c_707, "rot")])
	if J.t(J.gp(v_c_707, "flip")):
		J.mc(v_ctx_706, "scale", [(-1.0), 1.0])
	var _t705 = J.div((-J.num(v_cw_714)), 2.0)
	var _t704 = (-J.num(v_ch_713))
	var _t703 = J.gp(v_G_711, "off")
	J.mc(v_ctx_706, "drawImage", [v_im_710, _t705, (_t704 * (0.6 if J.t((J.cmp(J.gp(v_G_711, "z"), 0.0, "<=") if J.t(_t703) else _t703)) else 1.0)), v_cw_714, v_ch_713])
	J.mc(v_ctx_706, "restore", [])
	if J.cmp(J.gp(v_G_711, "land"), 0.0, ">="):
		v_q_718 = J.div(J.sub(J.gp(v_G_711, "t"), J.gp(v_G_711, "land")), 0.5)
		if J.cmp(v_q_718, 1.0, "<"):
			J.mc(v_ctx_706, "save", [])
			var _t706 = ("rgba(220,210,190," + J.str((0.6 * J.sub(1.0, v_q_718))) + ")")
			J.sp(v_ctx_706, "strokeStyle", _t706)
			J.sp(v_ctx_706, "lineWidth", 2.0)
			J.mc(v_ctx_706, "beginPath", [])
			J.mc(v_ctx_706, "ellipse", [v_fx_716, v_fy_717, J.mul(J.gp(v_F_709, "u"), (0.08 + J.mul(v_q_718, 0.12))), J.mul(J.gp(v_F_709, "u"), (0.02 + J.mul(v_q_718, 0.03))), 0.0, 0.0, J.mul(env["PI"], 2.0)])
			J.mc(v_ctx_706, "stroke", [])
			var _t707 = env["text"]
			J.cl(_t707, null, [v_ctx_706, v_fx_716, J.sub(v_fy_717, J.mul(J.gp(v_F_709, "u"), (0.2 + J.mul(v_q_718, 0.08)))), ("鏘！" if J.t(J.gp(v_c_707, "mug")) else ("啪！" if J.seq(J.gp(v_c_707, "spr"), "op_stack") else "哐！")), J.mul(J.gp(v_F_709, "u"), 0.13), J.sub(1.0, v_q_718)])
			J.mc(v_ctx_706, "restore", [])

func _f96(this_, a: Array, env):
	var v_ctx_721 = null; var v_p_722 = null; var v_t_723 = null; var v_im_724 = null; var v_x_725 = null; var v_y_726 = null; var v_u_727 = null; var v_w_728 = null; var v_h_729 = null
	v_ctx_721 = J.arg(a, 0)
	v_p_722 = J.arg(a, 1)
	v_t_723 = J.arg(a, 2)
	var _t708 = env["img"]
	v_im_724 = J.cl(_t708, null, ["op_paper_fly"])
	if (not J.t(v_im_724)):
		return null
	var _t709 = env["P"]
	var _t710 = J.cl(_t709, null, [J.gp(v_p_722, "x"), J.gp(v_p_722, "y")])
	var _t711 = J.gp(_t710, 0.0)
	v_x_725 = _t711
	var _t712 = J.gp(_t710, 1.0)
	v_y_726 = _t712
	var _t713 = env["U"]
	v_u_727 = J.cl(_t713, null, [J.gp(v_p_722, "y")])
	v_w_728 = (J.mul(J.gp(v_p_722, "w"), v_u_727) * 1.3)
	v_h_729 = J.div(J.mul(v_w_728, J.gp(v_im_724, "height")), J.gp(v_im_724, "width"))
	var _t714 = env["shadowAt"]
	J.cl(_t714, null, [v_ctx_721, v_x_725, v_y_726, (J.mul(v_w_728, 0.6) * J.max_([0.3, J.sub(1.0, J.gp(v_p_722, "z"))])), 0.18])
	J.mc(v_ctx_721, "save", [])
	J.mc(v_ctx_721, "translate", [v_x_725, J.sub(v_y_726, J.mul(J.gp(v_p_722, "z"), v_u_727))])
	J.mc(v_ctx_721, "rotate", [J.gp(v_p_722, "rot")])
	J.mc(v_ctx_721, "scale", [cos(J.num(J.add(J.mul(J.gp(v_p_722, "t"), 5.0), J.gp(v_p_722, "ph")))), 1.0])
	J.mc(v_ctx_721, "drawImage", [v_im_724, J.div((-J.num(v_w_728)), 2.0), J.div((-J.num(v_h_729)), 2.0), v_w_728, v_h_729])
	J.mc(v_ctx_721, "restore", [])

func _f97(this_, a: Array, env):
	var _t715 = J.seq(J.typeof_(J.G.get("MeshAnim")), "undefined")
	if J.t((_t715 if _t715 else J.gp(J.gp(J.G.get("MeshAnim"), "RIG"), J.gp(env["STN"], "base")))):
		return null
	var _t716 = J.gp(J.G.get("MeshAnim"), "RIG")
	var _t717 = J.gp(env["STN"], "base")
	var _t718 = {"bones": J.gp(env["STN"], "bones")}
	J.sp(_t716, _t717, _t718)

func _f98(this_, a: Array, env):
	var v_u_734 = null
	v_u_734 = J.arg(a, 0)
	return J.mul(env["SIT_H"], v_u_734)

func _f100(this_, a: Array, env):
	var v_s_768 = null
	v_s_768 = J.arg(a, 0)
	var _t747 = env["__p"]["rnd"]
	return (J.sub(J.cl(_t747, null, [floor(J.num(J.add(J.mul(env["t"], 9.0), v_s_768)))]), 0.5) * 2.0)

func _f101(this_, a: Array, env):
	var v_clipArms_778 = null; var v_A_779 = null; var v_gx_780 = null; var v_gy_781 = null; var v_R_782 = null; var v_g_783 = null; var v_a0_784 = null
	v_clipArms_778 = J.arg(a, 0)
	J.mc(env["ctx"], "save", [])
	J.mc(env["ctx"], "translate", [J.add(env["bx"], env["jx"]), env["by"]])
	if J.t(env["rot"]):
		J.mc(env["ctx"], "translate", [0.0, ((-J.num(env["u"])) * 0.28)])
		J.mc(env["ctx"], "rotate", [env["rot"]])
		J.mc(env["ctx"], "translate", [0.0, J.mul(env["u"], 0.28)])
	J.mc(env["ctx"], "scale", [env["sc"], env["sq"]])
	if J.t(v_clipArms_778):
		v_A_779 = J.gp(env["__p"]["STN"], "arms")
		J.mc(env["ctx"], "beginPath", [])
		J.mc(env["ctx"], "rect", [(J.mul((-J.num(J.gp(env["S"], 0.0))), env["W"]) + J.mul(J.gp(v_A_779, 0.0), env["W"])), (J.mul((-J.num(J.gp(env["S"], 1.0))), env["H"]) + J.mul(J.gp(v_A_779, 1.0), env["H"])), J.mul(J.gp(v_A_779, 2.0), env["W"]), J.mul(J.gp(v_A_779, 3.0), env["H"])])
		J.mc(env["ctx"], "clip", [])
	var _t797 = ((not J.seq(J.typeof_(J.G.get("MeshAnim")), "undefined")) if J.t(env["mesh"]) else env["mesh"])
	if J.t((J.seq(env["key"], J.gp(env["__p"]["STN"], "base")) if J.t(_t797) else _t797)):
		J.mc(J.G.get("MeshAnim"), "draw", [env["ctx"], env["key"], J.mul((-J.sub(J.gp(env["S"], 0.0), 0.5)), env["W"]), J.mul(J.sub(1.0, J.gp(env["S"], 1.0)), env["H"]), env["H"], env["pose"], false])
	else:
		J.mc(env["ctx"], "drawImage", [env["im"], J.mul((-J.num(J.gp(env["S"], 0.0))), env["W"]), J.mul((-J.num(J.gp(env["S"], 1.0))), env["H"]), env["W"], env["H"]])
	var _t798 = (not J.t(v_clipArms_778))
	if (J.seq(env["key"], "npc_ken_sit_coffee") if _t798 else _t798):
		var _t799 = env["__p"]["steam"]
		J.cl(_t799, null, [env["ctx"], (J.mul((-J.num(J.gp(env["S"], 0.0))), env["W"]) + J.mul(env["W"], 0.28)), (J.mul((-J.num(J.gp(env["S"], 1.0))), env["H"]) + J.mul(env["H"], 0.27)), env["u"], env["t"]])
	if J.t(((not J.seq(J.gp(env["__p"]["K"], "mode"), "jump")) if J.t(env["ml"]) else env["ml"])):
		v_gx_780 = (J.mul((-J.num(J.gp(env["S"], 0.0))), env["W"]) + J.mul(env["W"], J.gp(J.gp(env["__p"]["STN"], "face"), 0.0)))
		v_gy_781 = (J.mul((-J.num(J.gp(env["S"], 1.0))), env["H"]) + J.mul(env["H"], J.gp(J.gp(env["__p"]["STN"], "face"), 1.0)))
		v_R_782 = J.mul(env["u"], 0.42)
		v_g_783 = J.mc(env["ctx"], "createRadialGradient", [v_gx_780, v_gy_781, 0.0, v_gx_780, v_gy_781, v_R_782])
		v_a0_784 = J.mul(0.42, J.gp(env["ml"], 3.0))
		J.mc(v_g_783, "addColorStop", [0.0, ("rgba(" + J.str(J.gp(env["ml"], 0.0)) + "," + J.str(J.gp(env["ml"], 1.0)) + "," + J.str(J.gp(env["ml"], 2.0)) + "," + J.str(v_a0_784) + ")")])
		J.mc(v_g_783, "addColorStop", [1.0, ("rgba(" + J.str(J.gp(env["ml"], 0.0)) + "," + J.str(J.gp(env["ml"], 1.0)) + "," + J.str(J.gp(env["ml"], 2.0)) + ",0)")])
		var _t800 = env["ctx"]
		J.sp(_t800, "globalCompositeOperation", "lighter")
		var _t801 = env["ctx"]
		J.sp(_t801, "fillStyle", v_g_783)
		J.mc(env["ctx"], "beginPath", [])
		J.mc(env["ctx"], "arc", [v_gx_780, v_gy_781, v_R_782, 0.0, J.mul(env["__p"]["PI"], 2.0)])
		J.mc(env["ctx"], "fill", [])
	J.mc(env["ctx"], "restore", [])

func _f99(this_, a: Array, env):
	var v_n_738 = null; var v_s0_740 = null; var v_ch_741 = null; var v_x_742 = null; var v_y_743 = null; var v_sw_745 = null; var v_rx_746 = null; var v_lift_748 = null; var v_a_754 = null; var v_body_763 = null; var v_type_764 = null; var v_tap_765 = null; var v_on_766 = null; var v_on_767 = null; var v_e_769 = null; var v_q_770 = null; var v_e_771 = null; var v_beat_772 = null; var v_p_773 = null; var v_s_774 = null; var v_p_775 = null; var v_p_776 = null; var v_p_777 = null; var v_i_785 = null; var v_q_786 = null
	var _s245 = {"__p": env, "ctx": null, "t": null, "u": null, "key": null, "sq": null, "rot": null, "jx": null, "mesh": null, "pose": null, "sc": null, "im": null, "S": null, "H": null, "W": null, "bx": null, "by": null, "ml": null}
	_s245["ctx"] = J.arg(a, 0)
	v_n_738 = J.arg(a, 1)
	_s245["t"] = J.arg(a, 2)
	var _t719 = _s245["__p"]["stnOf"]
	v_s0_740 = J.cl(_t719, null, [v_n_738])
	var _t720 = (not J.t(v_s0_740))
	if (_t720 if _t720 else (not J.t(J.gp(v_s0_740, "K")))):
		return {"x": 0.0, "top": 0.0, "H": 0.0}
	var _t721 = _s245["__p"]["use"]
	J.cl(_t721, null, [v_s0_740])
	J.cl(_s245["__p"]["rig"], null, [])
	v_ch_741 = J.gp(_s245["__p"]["K"], "ch")
	var _t722 = _s245["__p"]["P"]
	var _t723 = J.cl(_t722, null, [J.add(J.gp(_s245["__p"]["SEATV"], "x"), J.gp(v_ch_741, "dx")), J.add(J.gp(_s245["__p"]["SEAT"], "y"), J.gp(v_ch_741, "dz"))])
	var _t724 = J.gp(_t723, 0.0)
	v_x_742 = _t724
	var _t725 = J.gp(_t723, 1.0)
	v_y_743 = _t725
	var _t726 = _s245["__p"]["U"]
	_s245["u"] = J.cl(_t726, null, [J.gp(_s245["__p"]["SEAT"], "y")])
	v_sw_745 = J.gp(v_ch_741, "sw")
	var _t727 = J.gp(v_n_738, "rx")
	v_rx_746 = (J.gp(v_n_738, "rx") if J.t((J.cmp(J.gp(J.gp(v_n_738, "rx"), "t"), 0.0, ">=") if J.t(_t727) else _t727)) else null)
	_s245["key"] = J.gp(_s245["__p"]["STN"], "base")
	v_lift_748 = 0.0
	_s245["sq"] = 1.0
	_s245["rot"] = J.gp(v_ch_741, "lean")
	_s245["jx"] = 0.0
	_s245["mesh"] = true
	_s245["pose"] = {}
	v_a_754 = J.gp(_s245["__p"]["K"], "at")
	_s245["sc"] = J.max_([0.35, absf(J.num(cos(J.num(v_sw_745))))])
	if J.seq(J.gp(_s245["__p"]["K"], "mode"), "sit"):
		var _t728 = J.seq(J.gp(_s245["__p"]["K"], "act"), "stretch")
		if (J.cmp(J.gp(v_n_738, "fear"), 25.0, "<") if _t728 else _t728):
			var _t729 = J.cmp(v_a_754, 0.3, ">")
			v_on_766 = (J.cmp(v_a_754, J.sub(J.gp(_s245["__p"]["K"], "dur"), 0.35), "<") if _t729 else _t729)
			if J.t(v_on_766):
				_s245["key"] = J.gp(_s245["__p"]["STN"], "stretch")
				_s245["mesh"] = false
			var _t730 = _s245["__p"]["bump"]
			var _t734 = (1.0 + J.mul(0.04, J.cl(_t730, null, [v_a_754, 0.3, 0.6, 1.2])))
			var _t731 = _s245["__p"]["bump"]
			var _t733 = J.cl(_t731, null, [v_a_754, 0.15, 0.3, 0.45])
			var _t732 = _s245["__p"]["bump"]
			var _t735 = (_t734 - J.mul(0.05, J.add(_t733, J.cl(_t732, null, [v_a_754, J.sub(J.gp(_s245["__p"]["K"], "dur"), 0.5), J.sub(J.gp(_s245["__p"]["K"], "dur"), 0.35), J.sub(J.gp(_s245["__p"]["K"], "dur"), 0.2)]))))
			_s245["sq"] = _t735
			var _t736 = _s245["__p"]["bump"]
			var _t737 = J.mul(0.02, J.cl(_t736, null, [v_a_754, 0.5, 1.3, 2.6]))
			v_lift_748 = _t737
		else:
			var _t738 = J.seq(J.gp(_s245["__p"]["K"], "act"), "drink")
			if (J.cmp(J.gp(v_n_738, "fear"), 25.0, "<") if _t738 else _t738):
				var _t739 = J.cmp(v_a_754, 0.45, ">")
				v_on_767 = (J.cmp(v_a_754, J.sub(J.gp(_s245["__p"]["K"], "dur"), 0.4), "<") if _t739 else _t739)
				if J.t(v_on_767):
					_s245["key"] = J.gp(_s245["__p"]["STN"], "drink")
					_s245["mesh"] = false
					var _t740 = _s245["__p"]["bump"]
					var _t741 = J.sub(_s245["rot"], J.mul(0.06, J.cl(_t740, null, [v_a_754, 1.0, 1.6, 2.8])))
					_s245["rot"] = _t741
				var _t742 = _s245["__p"]["bump"]
				var _t744 = J.cl(_t742, null, [v_a_754, 0.3, 0.45, 0.6])
				var _t743 = _s245["__p"]["bump"]
				var _t745 = (1.0 - J.mul(0.04, J.add(_t744, J.cl(_t743, null, [v_a_754, J.sub(J.gp(_s245["__p"]["K"], "dur"), 0.55), J.sub(J.gp(_s245["__p"]["K"], "dur"), 0.4), J.sub(J.gp(_s245["__p"]["K"], "dur"), 0.25)]))))
				_s245["sq"] = _t745
		var _t746 = J.seq(J.gp(_s245["__p"]["K"], "act"), "type")
		v_type_764 = (J.cmp(J.gp(v_n_738, "fear"), 25.0, "<") if _t746 else _t746)
		v_tap_765 = Callable(self, "_f100").bind(_s245)
		var _t748 = {"armF": ((J.mul(0.035, J.cl(v_tap_765, null, [0.0])) + (0.02 * sin(J.num(J.mul(_s245["t"], 18.0))))) if J.t(v_type_764) else (0.01 * sin(J.num(J.mul(_s245["t"], 1.6))))), "head": (((0.012 * sin(J.num(J.mul(_s245["t"], 3.1)))) if J.t(v_type_764) else (0.025 * sin(J.num(J.mul(_s245["t"], 1.2))))) + ((sin(J.num(J.mul(J.gp(_s245["__p"]["K"], "mt"), 1.6))) * 0.06) if J.cmp(J.gp(v_n_738, "fear"), 25.0, ">=") else 0.0)), "body": (0.012 * sin(J.num(J.mul(_s245["t"], 1.8)))), "sy": (1.0 + (0.01 * sin(J.num(J.mul(_s245["t"], 1.8)))))}
		_s245["pose"] = _t748
		var _t749 = J.seq(J.gp(_s245["__p"]["K"], "act"), "neck")
		if (J.cmp(J.gp(v_n_738, "fear"), 25.0, "<") if _t749 else _t749):
			var _t750 = _s245["__p"]["ss"]
			var _t752 = J.cl(_t750, null, [J.div(v_a_754, 0.4)])
			var _t751 = _s245["__p"]["ss"]
			v_e_769 = J.mul(_t752, J.cl(_t751, null, [J.div(J.sub(J.gp(_s245["__p"]["K"], "dur"), v_a_754), 0.4)]))
			var _t753 = _s245["__p"]["cl"]
			v_q_770 = J.mul(J.mul(J.cl(_t753, null, [J.div(J.sub(v_a_754, 0.3), 2.2)]), 2.0), _s245["__p"]["PI"])
			var _t754 = _s245["pose"]
			var _t755 = J.mul(((sin(J.num(v_q_770)) * 0.16) - 0.04), v_e_769)
			J.sp(_t754, "head", _t755)
			var _t756 = _s245["pose"]
			var _t757 = (J.mul((-0.05), v_e_769) * sin(J.num(J.mul(v_q_770, 0.5))))
			J.sp(_t756, "body", _t757)
			var _t758 = _s245["pose"]
			var _t759 = J.mul((sin(J.num(J.sub(v_q_770, 0.6))) * 0.12), v_e_769)
			J.sp(_t758, "hair", _t759)
			var _t760 = _s245["pose"]
			var _t761 = J.mul(0.06, v_e_769)
			J.sp(_t760, "armF", _t761)
			var _t762 = J.mul(_s245["sq"], (1.0 + J.mul(0.02, v_e_769)))
			_s245["sq"] = _t762
		var _t763 = J.seq(J.gp(_s245["__p"]["K"], "act"), "vibe")
		if (J.cmp(J.gp(v_n_738, "fear"), 25.0, "<") if _t763 else _t763):
			var _t764 = _s245["__p"]["ss"]
			var _t766 = J.cl(_t764, null, [J.div(v_a_754, 0.4)])
			var _t765 = _s245["__p"]["ss"]
			v_e_771 = J.mul(_t766, J.cl(_t765, null, [J.div(J.sub(J.gp(_s245["__p"]["K"], "dur"), v_a_754), 0.4)]))
			v_beat_772 = absf(J.num(sin(J.num((J.mul(v_a_754, _s245["__p"]["PI"]) * 2.2)))))
			var _t767 = _s245["pose"]
			var _t768 = J.mul((J.mul((-0.05), v_beat_772) + 0.02), v_e_771)
			J.sp(_t767, "head", _t768)
			var _t769 = _s245["pose"]
			var _t770 = J.mul((0.1 * sin(J.num(((J.mul(v_a_754, _s245["__p"]["PI"]) * 2.2) - 0.8)))), v_e_771)
			J.sp(_t769, "hair", _t770)
			var _t771 = _s245["pose"]
			var _t772 = _s245["__p"]["rnd"]
			var _t773 = ((0.03 * J.sub(J.cl(_t772, null, [floor(J.num(J.mul(_s245["t"], 9.0)))]), 0.5)) * 2.0)
			J.sp(_t771, "armF", _t773)
		if J.t(v_rx_746):
			v_p_773 = J.div(J.gp(v_rx_746, "t"), J.gp(v_rx_746, "dur"))
			if J.seq(J.gp(v_rx_746, "k"), "flinch"):
				var _t774 = (1.0 - (0.06 * J.sub(1.0, v_p_773)))
				_s245["sq"] = _t774
				var _t775 = (((randf() - 0.5) * 3.0) * J.sub(1.0, v_p_773))
				_s245["jx"] = _t775
				var _t776 = _s245["pose"]
				var _t777 = ((-0.08) * J.sub(1.0, v_p_773))
				J.sp(_t776, "head", _t777)
			if J.seq(J.gp(v_rx_746, "k"), "rational"):
				v_s_774 = sin(J.num(J.mul(J.min_([1.0, J.div(J.gp(v_rx_746, "t"), 0.55)]), _s245["__p"]["PI"])))
				var _t778 = (1.0 + J.mul(0.04, v_s_774))
				_s245["sq"] = _t778
				var _t779 = J.mul(0.02, v_s_774)
				v_lift_748 = _t779
		var _t780 = J.cmp(J.gp(v_n_738, "fear"), 25.0, ">=")
		if (J.cmp(J.gp(v_n_738, "fear"), 50.0, "<") if _t780 else _t780):
			var _t781 = J.add(_s245["jx"], ((randf() - 0.5) * 1.2))
			_s245["jx"] = _t781
	else:
		if J.seq(J.gp(_s245["__p"]["K"], "mode"), "jump"):
			_s245["key"] = J.gp(_s245["__p"]["STN"], "jump")
			_s245["mesh"] = false
			v_p_775 = J.div(J.gp(_s245["__p"]["K"], "mt"), 0.62)
			var _t782 = ((sin(J.num(J.mul(J.min_([1.0, J.mul(v_p_775, 1.3)]), _s245["__p"]["PI"]))) * 0.16) + ((-0.02) if J.cmp(v_p_775, 0.12, "<") else 0.0))
			v_lift_748 = _t782
			var _t783 = (0.92 if J.cmp(v_p_775, 0.12, "<") else (1.0 + (0.08 * sin(J.num(J.mul(J.min_([1.0, J.mul(v_p_775, 1.3)]), _s245["__p"]["PI"]))))))
			_s245["sq"] = _t783
			var _t784 = ((randf() - 0.5) * 2.0)
			_s245["jx"] = _t784
		else:
			if J.seq(J.gp(_s245["__p"]["K"], "mode"), "rise"):
				v_p_776 = J.div(J.gp(_s245["__p"]["K"], "mt"), 0.34)
				var _t785 = J.sub(_s245["rot"], (0.18 * sin(J.num((J.mul(v_p_776, _s245["__p"]["PI"]) * 0.5)))))
				_s245["rot"] = _t785
				var _t786 = J.mul(0.04, v_p_776)
				v_lift_748 = _t786
				var _t787 = (1.0 - (0.05 * sin(J.num(J.mul(v_p_776, _s245["__p"]["PI"])))))
				_s245["sq"] = _t787
				_s245["mesh"] = false
			else:
				if J.seq(J.gp(_s245["__p"]["K"], "mode"), "sitdown"):
					v_p_777 = J.div(J.gp(_s245["__p"]["K"], "mt"), 0.32)
					var _t788 = _s245["__p"]["ss"]
					var _t789 = (0.07 * J.sub(1.0, J.cl(_t788, null, [v_p_777])))
					v_lift_748 = _t789
					var _t790 = ((1.0 - (0.06 * sin(J.num(J.mul(J.div(J.sub(v_p_777, 0.6), 0.4), _s245["__p"]["PI"]))))) if J.cmp(v_p_777, 0.6, ">") else 1.0)
					_s245["sq"] = _t790
	if J.cmp(J.gp(_s245["__p"]["K"], "pop"), 0.0, ">"):
		var _t791 = J.mul(_s245["sq"], (1.0 - (0.05 * sin(J.num(J.mul(J.div(J.gp(_s245["__p"]["K"], "pop"), 0.18), _s245["__p"]["PI"]))))))
		_s245["sq"] = _t791
	if (not J.seq(J.gp(_s245["__p"]["K"], "mode"), "jump")):
		var _t792 = _s245["__p"]["chairSprite"]
		J.cl(_t792, null, [_s245["ctx"], v_x_742, v_y_743, _s245["u"], v_sw_745, J.gp(v_ch_741, "lean"), J.gp(_s245["__p"]["CHAIR"], "spr"), J.gp(_s245["__p"]["CHAIR"], "h"), true, J.sub(1.0, J.gp(_s245["__p"]["CHAIR"], "back"))])
	_s245["im"] = J.gp(J.G.get("SPR"), _s245["key"])
	var _t793 = _s245["__p"]["ok"]
	if (not J.t(J.cl(_t793, null, [_s245["key"]]))):
		return {"x": v_x_742, "top": J.sub(v_y_743, _s245["u"])}
	_s245["S"] = J.gp(_s245["__p"]["SIT"], _s245["key"])
	var _t794 = _s245["__p"]["seatH"]
	_s245["H"] = J.div(J.mul(J.cl(_t794, null, [_s245["u"]]), J.gp(_s245["im"], "naturalHeight")), J.gp(J.gp(J.G.get("SPR"), "npc_ken_sit"), "naturalHeight"))
	_s245["W"] = J.div(J.mul(_s245["H"], J.gp(_s245["im"], "naturalWidth")), J.gp(_s245["im"], "naturalHeight"))
	_s245["bx"] = v_x_742
	_s245["by"] = J.sub(v_y_743, J.mul(v_lift_748, _s245["u"]))
	var _t795 = _s245["__p"]["monLight"]
	var _t796 = _s245["__p"]["monState"]
	_s245["ml"] = J.cl(_t795, null, [J.cl(_t796, null, [J.gp(_s245["__p"]["items"], J.gp(_s245["__p"]["STN"], "mon"))]), _s245["t"]])
	v_body_763 = Callable(self, "_f101").bind(_s245)
	J.cl(v_body_763, null, [false])
	var _t802 = _s245["__p"]["drawItem"]
	J.cl(_t802, null, [_s245["ctx"], J.gp(_s245["__p"]["items"], J.gp(_s245["__p"]["STN"], "desk")), _s245["t"], "base"])
	var _t803 = J.seq(_s245["key"], J.gp(_s245["__p"]["STN"], "base"))
	if ((not J.seq(J.gp(_s245["__p"]["K"], "mode"), "jump")) if _t803 else _t803):
		J.cl(v_body_763, null, [true])
	var _t804 = _s245["__p"]["drawItem"]
	J.cl(_t804, null, [_s245["ctx"], J.gp(_s245["__p"]["items"], J.gp(_s245["__p"]["STN"], "desk")), _s245["t"], "kids"])
	var _t805 = J.seq(J.gp(_s245["__p"]["K"], "mode"), "sit")
	var _t806 = (J.seq(J.gp(_s245["__p"]["K"], "act"), "stretch") if _t805 else _t805)
	var _t807 = (J.gp(_s245["__p"]["STN"], "stretchSay") if _t806 else _t806)
	var _t808 = (J.cmp(v_a_754, 0.6, ">") if J.t(_t807) else _t807)
	if J.t((J.cmp(v_a_754, 2.4, "<") if J.t(_t808) else _t808)):
		var _t809 = _s245["__p"]["text"]
		var _t811 = _s245["ctx"]
		var _t812 = J.sub(v_x_742, J.mul(_s245["u"], 0.78))
		var _t813 = J.sub(v_y_743, J.mul(_s245["u"], 0.72))
		var _t814 = J.gp(_s245["__p"]["STN"], "stretchSay")
		var _t815 = J.mul(_s245["u"], 0.15)
		var _t810 = _s245["__p"]["bump"]
		J.cl(_t809, null, [_t811, _t812, _t813, _t814, _t815, J.cl(_t810, null, [v_a_754, 0.7, 0.9, 2.3])])
	var _t816 = J.seq(J.gp(_s245["__p"]["K"], "mode"), "sit")
	var _t817 = (J.seq(J.gp(_s245["__p"]["K"], "act"), "drink") if _t816 else _t816)
	var _t818 = (J.gp(_s245["__p"]["STN"], "drinkSay") if _t817 else _t817)
	var _t819 = (J.cmp(v_a_754, 0.9, ">") if J.t(_t818) else _t818)
	var _t820 = (J.cmp(v_a_754, 3.0, "<") if J.t(_t819) else _t819)
	if J.t((J.cmp(J.gp(v_n_738, "fear"), 25.0, "<") if J.t(_t820) else _t820)):
		var _t821 = _s245["__p"]["text"]
		var _t823 = _s245["ctx"]
		var _t824 = J.sub(v_x_742, J.mul(_s245["u"], 0.62))
		var _t825 = J.sub(v_y_743, J.mul(_s245["u"], 0.86))
		var _t826 = J.gp(_s245["__p"]["STN"], "drinkSay")
		var _t827 = J.mul(_s245["u"], 0.12)
		var _t822 = _s245["__p"]["bump"]
		J.cl(_t821, null, [_t823, _t824, _t825, _t826, _t827, J.cl(_t822, null, [v_a_754, 1.0, 1.3, 2.8])])
	var _t828 = J.seq(J.gp(_s245["__p"]["K"], "mode"), "sit")
	var _t829 = (J.seq(J.gp(_s245["__p"]["K"], "act"), "vibe") if _t828 else _t828)
	if (J.cmp(J.gp(v_n_738, "fear"), 25.0, "<") if _t829 else _t829):
		v_i_785 = 0.0
		while true:
			if not J.cmp(v_i_785, 2.0, "<"): break
			v_q_786 = J.mod((J.mul(v_a_754, 0.6) + J.mul(v_i_785, 0.5)), 1.0)
			var _t830 = _s245["__p"]["text"]
			var _t833 = _s245["ctx"]
			var _t834 = (J.sub(v_x_742, J.mul(_s245["u"], (0.05 - J.mul(0.1, v_q_786)))) + (J.mul(v_i_785, _s245["u"]) * 0.08))
			var _t835 = J.sub(v_y_743, J.mul(_s245["u"], (0.9 + J.mul(0.2, v_q_786))))
			var _t836 = ("♫" if J.t(v_i_785) else "♪")
			var _t837 = J.mul(_s245["u"], 0.12)
			var _t832 = sin(J.num(J.mul(v_q_786, _s245["__p"]["PI"])))
			var _t831 = _s245["__p"]["ss"]
			J.cl(_t830, null, [_t833, _t834, _t835, _t836, _t837, J.mul(_t832, J.cl(_t831, null, [J.div(v_a_754, 0.5)]))])
			v_i_785 = J.num(v_i_785) + 1.0
	var _t838 = J.seq(J.gp(_s245["__p"]["K"], "mode"), "sit")
	var _t839 = (J.seq(J.gp(_s245["__p"]["K"], "act"), "neck") if _t838 else _t838)
	if (J.cmp(J.gp(v_n_738, "fear"), 25.0, "<") if _t839 else _t839):
		var _t840 = _s245["__p"]["text"]
		var _t842 = _s245["ctx"]
		var _t843 = J.sub(v_x_742, J.mul(_s245["u"], 0.7))
		var _t844 = J.sub(v_y_743, J.mul(_s245["u"], 0.8))
		var _t845 = J.mul(_s245["u"], 0.11)
		var _t841 = _s245["__p"]["bump"]
		J.cl(_t840, null, [_t842, _t843, _t844, "喀", _t845, J.cl(_t841, null, [v_a_754, 1.2, 1.35, 1.7])])
	var _t848 = J.sub(v_x_742, J.mul(_s245["u"], 0.22))
	var _t847 = J.sub(v_y_743, J.mul(v_lift_748, _s245["u"]))
	var _t846 = _s245["__p"]["seatH"]
	var _t850 = (_t847 - J.mul(J.cl(_t846, null, [_s245["u"]]), (1.0 if J.seq(_s245["key"], J.gp(_s245["__p"]["STN"], "stretch")) else 0.98)))
	var _t849 = _s245["__p"]["seatH"]
	return {"x": _t848, "top": _t850, "H": J.cl(_t849, null, [_s245["u"]])}

func _f102(this_, a: Array, env):
	var v_ctx_789 = null; var v_x_790 = null; var v_y_791 = null; var v_u_792 = null; var v_t_793 = null; var v_i_794 = null; var v_q_795 = null; var v_sx_796 = null
	v_ctx_789 = J.arg(a, 0)
	v_x_790 = J.arg(a, 1)
	v_y_791 = J.arg(a, 2)
	v_u_792 = J.arg(a, 3)
	v_t_793 = J.arg(a, 4)
	J.mc(v_ctx_789, "save", [])
	J.sp(v_ctx_789, "lineCap", "round")
	v_i_794 = 0.0
	while true:
		if not J.cmp(v_i_794, 2.0, "<"): break
		v_q_795 = J.mod((J.mul(v_t_793, 0.6) + J.mul(v_i_794, 0.5)), 1.0)
		var _t851 = ("rgba(240,240,240," + J.str((0.5 * J.sub(1.0, v_q_795))) + ")")
		J.sp(v_ctx_789, "strokeStyle", _t851)
		var _t852 = J.mul(v_u_792, 0.012)
		J.sp(v_ctx_789, "lineWidth", _t852)
		J.mc(v_ctx_789, "beginPath", [])
		v_sx_796 = J.add(v_x_790, (J.mul(J.sub(v_i_794, 0.5), v_u_792) * 0.03))
		J.mc(v_ctx_789, "moveTo", [v_sx_796, J.sub(v_y_791, (J.mul(v_q_795, v_u_792) * 0.05))])
		J.mc(v_ctx_789, "bezierCurveTo", [J.add(v_sx_796, J.mul(v_u_792, 0.02)), (J.sub(v_y_791, J.mul(v_u_792, 0.05)) - (J.mul(v_q_795, v_u_792) * 0.1)), J.sub(v_sx_796, J.mul(v_u_792, 0.02)), (J.sub(v_y_791, J.mul(v_u_792, 0.09)) - (J.mul(v_q_795, v_u_792) * 0.1)), J.add(v_sx_796, (J.mul(sin(J.num(J.add(J.mul(v_t_793, 2.0), v_i_794))), v_u_792) * 0.015)), (J.sub(v_y_791, J.mul(v_u_792, 0.14)) - (J.mul(v_q_795, v_u_792) * 0.1))])
		J.mc(v_ctx_789, "stroke", [])
		v_i_794 = J.num(v_i_794) + 1.0
	J.mc(v_ctx_789, "restore", [])

func _f103(this_, a: Array, env):
	var v_ctx_799 = null; var v_x_800 = null; var v_y_801 = null; var v_s_802 = null; var v_sz_803 = null; var v_a_804 = null
	v_ctx_799 = J.arg(a, 0)
	v_x_800 = J.arg(a, 1)
	v_y_801 = J.arg(a, 2)
	v_s_802 = J.arg(a, 3)
	v_sz_803 = J.arg(a, 4)
	v_a_804 = J.arg(a, 5)
	if J.cmp(v_a_804, 0.01, "<="):
		return null
	J.mc(v_ctx_799, "save", [])
	var _t853 = env["cl"]
	var _t854 = J.mul(J.gp(v_ctx_799, "globalAlpha"), J.cl(_t853, null, [v_a_804]))
	J.sp(v_ctx_799, "globalAlpha", _t854)
	var _t855 = ("900 " + J.str(J.round(J.num(v_sz_803))) + "px sans-serif")
	J.sp(v_ctx_799, "font", _t855)
	J.sp(v_ctx_799, "textAlign", "center")
	J.sp(v_ctx_799, "lineWidth", 3.0)
	J.sp(v_ctx_799, "strokeStyle", "#1a1020")
	J.mc(v_ctx_799, "strokeText", [v_s_802, v_x_800, v_y_801])
	J.sp(v_ctx_799, "fillStyle", "#fff3d0")
	J.mc(v_ctx_799, "fillText", [v_s_802, v_x_800, v_y_801])
	J.mc(v_ctx_799, "restore", [])

func _f104(this_, a: Array, env):
	if J.t(env["st"]):
		var _t856 = J.gp(env["st"], "copier")
		var _t857 = J.gp(J.gp(env["st"], "copier"), "idle")
		var _t858 = J.gp(J.gp(env["st"], "copier"), "idle")
		var _t859 = J.max_([(_t858 if J.t(_t858) else 0.0), 0.4])
		J.sp(_t856, "idle", _t859)

func _f106(this_, a: Array, env):
	var v_m_817 = null
	v_m_817 = J.arg(a, 0)
	var _t877 = (not J.seq(v_m_817, env["n"]))
	var _t879 = ((not J.t(J.gp(v_m_817, "gone"))) if _t877 else _t877)
	if J.t(_t879):
		var _t878 = J.seq(J.gp(J.gp(v_m_817, "d"), "k"), "ken")
		_t879 = (_t878 if _t878 else J.seq(J.gp(J.gp(v_m_817, "d"), "k"), "it"))
	var _t880 = (J.seq(J.gp(v_m_817, "act"), "walk") if _t879 else _t879)
	return ((J.hypot_([J.sub(J.gp(v_m_817, "x"), J.gp(env["n"], "x")), J.sub(J.gp(v_m_817, "y"), J.gp(env["n"], "y"))]) < 0.2) if _t880 else _t880)

func _f107(this_, a: Array, env):
	var v_e_821 = null
	v_e_821 = J.arg(a, 0)
	var _t890 = J.gp(J.gp(env["s"], "cd"), J.gp(v_e_821, 0.0))
	var _t891 = J.cmp((_t890 if J.t(_t890) else 0.0), 0.0, "<=")
	var _t893 = ((not J.seq(J.gp(v_e_821, 0.0), J.gp(env["s"], "act"))) if _t891 else _t891)
	if J.t(_t893):
		var _t892 = (not J.seq(J.gp(v_e_821, 0.0), "copy"))
		_t893 = (_t892 if _t892 else (J.hypot_([J.sub(J.gp(env["n"], "x"), J.add(J.gp(J.gp(J.gp(J.G.get("OFFMAP"), "SPOT"), "copier"), 0.0), 0.16)), J.sub(J.gp(env["n"], "y"), J.add(J.gp(J.gp(J.gp(J.G.get("OFFMAP"), "SPOT"), "copier"), 1.0), 0.05))]) < 0.06))
	return _t893

func _f108(this_, a: Array, env):
	var v_q_822 = null
	v_q_822 = J.arg(a, 0)
	return J.seq(J.gp(v_q_822, 0.0), "stand")

func _f109(this_, a: Array, env):
	var v_q_823 = null; var v_e_824 = null
	v_q_823 = J.arg(a, 0)
	v_e_824 = J.arg(a, 1)
	return J.add(v_q_823, J.gp(v_e_824, 1.0))

func _f105(this_, a: Array, env):
	var v_dt_810 = null; var v_rx_812 = null; var v_calm_813 = null; var v_big_814 = null; var v_k_815 = null; var v_pass_816 = null; var v_opts_818 = null; var v_r_819 = null; var v_e_820 = null; var v_q_825 = null
	var _s271 = {"__p": env, "n": null, "s": null}
	_s271["n"] = J.arg(a, 0)
	v_dt_810 = J.arg(a, 1)
	var _t860 = _s271["n"]
	var _t861 = J.gp(_s271["n"], "mis")
	var _t862 = (_t861 if J.t(_t861) else {"act": "stand", "at": 0.0, "dur": 2.0, "cd": {}, "jumpT": (-1.0), "rollT": (-9.0)})
	J.sp(_t860, "mis", _t862)
	_s271["s"] = _t862
	var _t863 = J.gp(_s271["n"], "rx")
	v_rx_812 = (J.gp(_s271["n"], "rx") if J.t((J.cmp(J.gp(J.gp(_s271["n"], "rx"), "t"), 0.0, ">=") if J.t(_t863) else _t863)) else null)
	var _t864 = (not J.t(J.gp(_s271["n"], "fleeing")))
	var _t866 = (J.cmp(J.gp(_s271["n"], "fear"), 25.0, "<") if _t864 else _t864)
	if J.t(_t866):
		var _t865 = (not J.t(v_rx_812))
		_t866 = (_t865 if _t865 else J.seq(J.gp(v_rx_812, "k"), "numb"))
	v_calm_813 = ((not J.seq(J.gp(_s271["n"], "act"), "walk")) if _t866 else _t866)
	for _t867 in J.keys(J.gp(_s271["s"], "cd")):
		v_k_815 = _t867
		var _t868 = J.gp(_s271["s"], "cd")
		var _t869 = J.sub(J.gp(_t868, v_k_815), v_dt_810)
		J.sp(_t868, v_k_815, _t869)
	var _t870 = _s271["s"]
	var _t871 = J.add(J.gp(_t870, "at"), v_dt_810)
	J.sp(_t870, "at", _t871)
	if (not J.t(v_calm_813)):
		if (not J.seq(J.gp(_s271["s"], "act"), "stand")):
			var _t872 = _s271["s"]
			J.sp(_t872, "act", "stand")
			var _t873 = _s271["s"]
			J.sp(_t873, "at", 0.0)
			var _t874 = _s271["s"]
			J.sp(_t874, "dur", 1.0)
	else:
		var _t875 = J.gp(_s271["__p"]["SC"], "npcs")
		var _t876 = (_t875 if J.t(_t875) else [])
		v_pass_816 = J.mc(_t876, "find", [Callable(self, "_f106").bind(_s271)])
		var _t882 = ((not J.seq(J.gp(_s271["s"], "act"), "roll")) if J.t(v_pass_816) else v_pass_816)
		if J.t(_t882):
			var _t881 = J.gp(J.gp(_s271["s"], "cd"), "roll")
			_t882 = J.cmp((_t881 if J.t(_t881) else 0.0), 0.0, "<=")
		if J.t(_t882):
			var _t883 = _s271["s"]
			J.sp(_t883, "act", "roll")
			var _t884 = _s271["s"]
			J.sp(_t884, "at", 0.0)
			var _t885 = _s271["s"]
			J.sp(_t885, "dur", 1.8)
			var _t886 = J.gp(_s271["s"], "cd")
			J.sp(_t886, "roll", 9.0)
			var _t887 = _s271["s"]
			var _t888 = J.gp(v_pass_816, "x")
			J.sp(_t887, "rollAt", _t888)
			var _t889 = (randf() < 0.5)
			if J.t((J.gp(_s271["__p"]["SC"], "bubble") if _t889 else _t889)):
				J.mc(_s271["__p"]["SC"], "bubble", [_s271["n"], J.gp(_s271["__p"]["MIS_SAY"], "roll"), 2.0])
		else:
			if J.cmp(J.gp(_s271["s"], "at"), J.gp(_s271["s"], "dur"), ">="):
				v_opts_818 = J.mc(_s271["__p"]["MIS_ACTS"], "filter", [Callable(self, "_f107").bind(_s271)])
				if (not J.t(J.len(v_opts_818))):
					var _t894 = J.mc(_s271["__p"]["MIS_ACTS"], "find", [Callable(self, "_f108").bind(_s271)])
					J.mc(v_opts_818, "push", [(_t894 if J.t(_t894) else J.gp(_s271["__p"]["MIS_ACTS"], 0.0))])
				v_r_819 = J.mul(randf(), J.mc(v_opts_818, "reduce", [Callable(self, "_f109").bind(_s271), 0.0]))
				v_e_820 = J.gp(v_opts_818, 0.0)
				for _t895 in J.iter(v_opts_818):
					v_q_825 = _t895
					var _t896 = J.sub(v_r_819, J.gp(v_q_825, 1.0))
					v_r_819 = _t896
					if J.cmp(v_r_819, 0.0, "<="):
						v_e_820 = v_q_825
						break
				var _t897 = _s271["s"]
				var _t898 = J.gp(v_e_820, 0.0)
				J.sp(_t897, "act", _t898)
				var _t899 = _s271["s"]
				J.sp(_t899, "at", 0.0)
				var _t900 = _s271["s"]
				var _t901 = J.add(J.gp(J.gp(v_e_820, 2.0), 0.0), (randf() * J.sub(J.gp(J.gp(v_e_820, 2.0), 1.0), J.gp(J.gp(v_e_820, 2.0), 0.0))))
				J.sp(_t900, "dur", _t901)
				var _t902 = J.gp(_s271["s"], "cd")
				var _t903 = J.gp(v_e_820, 0.0)
				var _t904 = J.add(J.gp(v_e_820, 3.0), J.gp(_s271["s"], "dur"))
				J.sp(_t902, _t903, _t904)
				var _t905 = J.gp(_s271["__p"]["SC"], "bubble")
				if J.t(((randf() < 0.35) if J.t(_t905) else _t905)):
					J.mc(_s271["__p"]["SC"], "bubble", [_s271["n"], (J.gp(_s271["__p"]["MIS_SAY"], "selfie") if J.seq(J.gp(_s271["s"], "act"), "selfie") else J.gp(_s271["__p"]["MIS_SAY"], "sigh")), 2.2])
	var _t908 = v_rx_812
	if J.t(_t908):
		var _t906 = J.seq(J.gp(v_rx_812, "k"), "startle")
		var _t907 = (_t906 if _t906 else J.seq(J.gp(v_rx_812, "k"), "weakjump"))
		_t908 = (_t907 if _t907 else J.seq(J.gp(v_rx_812, "k"), "burst"))
	v_big_814 = _t908
	if J.t((J.cmp(J.gp(_s271["s"], "jumpT"), 0.0, "<") if J.t(v_big_814) else v_big_814)):
		var _t909 = _s271["s"]
		J.sp(_t909, "jumpT", 0.0)
	if J.cmp(J.gp(_s271["s"], "jumpT"), 0.0, ">="):
		var _t910 = _s271["s"]
		var _t911 = J.add(J.gp(_t910, "jumpT"), v_dt_810)
		J.sp(_t910, "jumpT", _t911)
		var _t912 = J.cmp(J.gp(_s271["s"], "jumpT"), 1.5, ">")
		if ((not J.t(v_big_814)) if _t912 else _t912):
			var _t913 = _s271["s"]
			var _t914 = (-1.0)
			J.sp(_t913, "jumpT", _t914)

func _f111(this_, a: Array, env):
	var v_key_846 = null; var v_pose_847 = null; var v_h_848 = null
	v_key_846 = J.arg(a, 0)
	v_pose_847 = J.arg(a, 1)
	var _t916 = env["__p"]["ok"]
	if (not J.t(J.cl(_t916, null, [v_key_846]))):
		return false
	v_h_848 = J.div(J.mul(env["H"], J.gp(J.gp(J.G.get("SPR"), v_key_846), "naturalHeight")), J.gp(J.gp(J.G.get("SPR"), "npc_mis"), "naturalHeight"))
	return J.mc(J.G.get("MeshAnim"), "draw", [env["ctx"], v_key_846, 0.0, 0.0, v_h_848, v_pose_847, env["right"]])

func _f112(this_, a: Array, env):
	var v_f_849 = null
	v_f_849 = J.arg(a, 0)
	var _t918 = J.seq(J.gp(v_f_849, "kind"), "phone")
	var _t919 = (J.seq(J.gp(v_f_849, "n"), env["n"]) if _t918 else _t918)
	return (J.cmp(J.gp(v_f_849, "life"), 0.8, ">") if _t919 else _t919)

func _f110(this_, a: Array, env):
	var v_o_830 = null; var v_hh_831 = null; var v_t_833 = null; var v_s_834 = null; var v_A_836 = null; var v_fx_837 = null; var v_draw_838 = null; var v_phoneFx_839 = null; var v_fAge_840 = null; var v_z_841 = null; var v_at_842 = null; var v_dur_843 = null; var v_e_844 = null; var v_pz_845 = null; var v_k_850 = null; var v_px_851 = null; var v_py_852 = null; var v_pc_853 = null; var v_sz_854 = null; var v_i_855 = null; var v_key_856 = null; var v_q_857 = null; var v_up_858 = null; var v_sq_859 = null; var v_im_860 = null; var v_h_861 = null; var v_w_862 = null; var v_k_863 = null; var v_cx_864 = null; var v_cy_865 = null; var v_i_866 = null; var v_a_867 = null; var v_r_868 = null; var v_i_869 = null; var v_vx_870 = null; var v_vy_871 = null; var v_px_872 = null; var v_py_873 = null; var v_sp_874 = null; var v_ph_875 = null; var v_bob_876 = null; var v_sway_877 = null; var v_pz_878 = null; var v_r2_879 = null; var v_k_880 = null; var v_pose2_881 = null; var v_fl_882 = null; var v_px_883 = null; var v_py_884 = null; var v_g_885 = null; var v_k_886 = null; var v_wig_887 = null; var v_sx_888 = null; var v_sy_889 = null; var v_k_890 = null; var v_tap_891 = null; var v_k_892 = null; var v_sw_893 = null; var v_k_894 = null; var v_i_895 = null; var v_bx_896 = null
	var _s286 = {"__p": env, "ctx": null, "n": null, "right": null, "H": null}
	_s286["ctx"] = J.arg(a, 0)
	_s286["n"] = J.arg(a, 1)
	v_o_830 = J.arg(a, 2)
	v_hh_831 = J.arg(a, 3)
	_s286["right"] = J.arg(a, 4)
	v_t_833 = J.arg(a, 5)
	v_s_834 = J.gp(_s286["n"], "mis")
	var _t915 = (not J.t(v_s_834))
	if (_t915 if _t915 else J.seq(J.typeof_(J.G.get("MeshAnim")), "undefined")):
		return false
	_s286["H"] = J.div(J.mul(v_hh_831, 62.0), (64.0 * 1.08))
	v_A_836 = J.gp(J.G.get("MeshAnim"), "ANIM")
	v_fx_837 = (1.0 if J.t(_s286["right"]) else (-1.0))
	v_draw_838 = Callable(self, "_f111").bind(_s286)
	var _t920 = J.gp(_s286["__p"]["SC"], "fx")
	if J.t(_t920):
		var _t917 = J.gp(_s286["__p"]["SC"], "fx")
		_t920 = J.mc(_t917, "find", [Callable(self, "_f112").bind(_s286)])
	v_phoneFx_839 = _t920
	if J.t(((not J.t(J.gp(v_o_830, "run"))) if J.t(v_phoneFx_839) else v_phoneFx_839)):
		v_k_850 = (1.0 - J.div(J.gp(v_phoneFx_839, "life"), 1.6))
		J.cl(v_draw_838, null, ["npc_mis_selfie", J.mc(v_A_836, "idle", [v_t_833])])
		v_px_851 = (J.mul((-J.num(v_fx_837)), _s286["H"]) * 0.17)
		v_py_852 = ((-J.num(_s286["H"])) * 0.83)
		J.mc(_s286["ctx"], "save", [])
		var _t921 = _s286["ctx"]
		var _t922 = J.mul(J.gp(_t921, "globalAlpha"), (0.5 + (0.5 * randf())))
		J.sp(_t921, "globalAlpha", _t922)
		var _t923 = (not J.seq(J.typeof_(J.G.get("ART")), "undefined"))
		if J.t((J.gp(J.G.get("ART"), "portrait") if _t923 else _t923)):
			v_pc_853 = J.mc(J.G.get("ART"), "portrait", ["afu", 64.0, {"tamed": true}])
			var _t924 = _s286["ctx"]
			J.sp(_t924, "globalCompositeOperation", "lighter")
			v_sz_854 = J.mul(_s286["H"], 0.16)
			J.mc(_s286["ctx"], "drawImage", [v_pc_853, (J.sub(v_px_851, J.div(v_sz_854, 2.0)) + ((randf() - 0.5) * 3.0)), J.sub(v_py_852, J.div(v_sz_854, 2.0)), v_sz_854, v_sz_854])
		var _t925 = _s286["ctx"]
		J.sp(_t925, "globalCompositeOperation", "source-over")
		v_i_855 = 0.0
		while true:
			if not J.cmp(v_i_855, 5.0, "<"): break
			var _t926 = _s286["ctx"]
			var _t927 = ("rgba(" + ("255,60,120" if (randf() < 0.5) else "80,220,255") + ",.6)")
			J.sp(_t926, "fillStyle", _t927)
			J.mc(_s286["ctx"], "fillRect", [J.sub(v_px_851, J.mul(_s286["H"], 0.08)), (J.sub(v_py_852, J.mul(_s286["H"], 0.08)) + (J.mul(randf(), _s286["H"]) * 0.16)), J.mul(_s286["H"], 0.16), 1.5])
			v_i_855 = J.num(v_i_855) + 1.0
		J.mc(_s286["ctx"], "restore", [])
		return true
	var _t928 = J.gp(_s286["n"], "fleeing")
	var _t931 = null
	if J.t(((not J.leq(J.gp(_s286["n"], "fleeT"), null)) if J.t(_t928) else _t928)):
		var _t930 = J.sub(J.gp(_s286["__p"]["SC"], "t"), J.gp(_s286["n"], "fleeT"))
		var _t929 = J.gp(_s286["n"], "fleeHold")
		_t931 = (_t930 - J.sub((_t929 if J.t(_t929) else 0.0), 0.4))
	else:
		_t931 = (-1.0)
	v_fAge_840 = _t931
	var _t940 = (not J.t(v_phoneFx_839))
	if J.t(_t940):
		var _t932 = J.cmp(v_fAge_840, 0.0, ">=")
		var _t939 = (J.cmp(v_fAge_840, 0.55, "<") if _t932 else _t932)
		if not J.t(_t939):
			var _t933 = (not J.t(J.gp(_s286["n"], "fleeing")))
			var _t934 = (J.cmp(J.gp(v_s_834, "jumpT"), 0.0, ">=") if _t933 else _t933)
			var _t938 = (J.cmp(J.gp(v_s_834, "jumpT"), 1.3, "<") if _t934 else _t934)
			if J.t(_t938):
				var _t935 = J.seq(J.gp(v_o_830, "pose"), "startle")
				var _t936 = (_t935 if _t935 else J.seq(J.gp(v_o_830, "rxk"), "startle"))
				var _t937 = (_t936 if _t936 else J.seq(J.gp(v_o_830, "rxk"), "weakjump"))
				_t938 = (_t937 if _t937 else J.seq(J.gp(v_o_830, "rxk"), "burst"))
			_t939 = _t938
		_t940 = _t939
	if _t940:
		v_key_856 = "npc_mis_jump"
		var _t941 = _s286["__p"]["ok"]
		if (not J.t(J.cl(_t941, null, [v_key_856]))):
			return false
		v_q_857 = (v_fAge_840 if J.cmp(v_fAge_840, 0.0, ">=") else J.gp(v_s_834, "jumpT"))
		v_up_858 = J.mul((sin(J.num(J.mul(J.min_([1.0, J.div(v_q_857, 0.6)]), _s286["__p"]["PI"]))) * 0.12), _s286["H"])
		v_sq_859 = (0.9 if J.cmp(v_q_857, 0.08, "<") else (1.0 + (0.06 * sin(J.num(J.mul(J.min_([1.0, J.div(v_q_857, 0.6)]), _s286["__p"]["PI"]))))))
		v_im_860 = J.gp(J.G.get("SPR"), v_key_856)
		v_h_861 = J.div(J.mul(_s286["H"], J.gp(v_im_860, "naturalHeight")), J.gp(J.gp(J.G.get("SPR"), "npc_mis"), "naturalHeight"))
		v_w_862 = J.div(J.mul(v_h_861, J.gp(v_im_860, "naturalWidth")), J.gp(v_im_860, "naturalHeight"))
		J.mc(_s286["ctx"], "save", [])
		J.mc(_s286["ctx"], "translate", [((randf() - 0.5) * 2.0), (-J.num(v_up_858))])
		J.mc(_s286["ctx"], "scale", [J.div(1.0, v_sq_859), v_sq_859])
		J.mc(_s286["ctx"], "scale", [(-J.num(v_fx_837)), 1.0])
		J.mc(_s286["ctx"], "drawImage", [v_im_860, ((-J.num(v_w_862)) * 0.58), (-J.num(v_h_861)), v_w_862, v_h_861])
		v_k_863 = J.min_([1.2, J.mul(v_q_857, 1.3)])
		v_cx_864 = (((-J.num(v_w_862)) * 0.58) + J.mul(v_w_862, 0.06))
		v_cy_865 = ((-J.num(v_h_861)) + J.mul(v_h_861, 0.56))
		v_i_866 = 0.0
		while true:
			if not J.cmp(v_i_866, 10.0, "<"): break
			var _t943 = _s286["__p"]["PI"]
			var _t942 = _s286["__p"]["rnd"]
			v_a_867 = J.mul(_t943, (0.75 + J.mul(J.cl(_t942, null, [v_i_866]), 0.6)))
			var _t946 = _s286["H"]
			var _t945 = J.mul(0.3, v_k_863)
			var _t944 = _s286["__p"]["rnd"]
			v_r_868 = J.mul(_t946, (0.05 + J.mul(_t945, J.add(0.5, J.cl(_t944, null, [J.add(v_i_866, 4.0)])))))
			var _t947 = _s286["ctx"]
			var _t948 = ("rgba(250,225,205," + J.str(J.max_([0.0, (0.6 - J.mul(v_q_857, 0.45))])) + ")")
			J.sp(_t947, "fillStyle", _t948)
			J.mc(_s286["ctx"], "beginPath", [])
			var _t952 = J.add(v_cx_864, J.mul(cos(J.num(v_a_867)), v_r_868))
			var _t951 = J.add(v_cy_865, J.mul(sin(J.num(v_a_867)), v_r_868))
			var _t950 = J.mul(J.mul(J.mul(0.3, _s286["H"]), v_k_863), v_k_863)
			var _t949 = _s286["__p"]["rnd"]
			J.mc(_s286["ctx"], "arc", [_t952, J.add(_t951, J.mul(_t950, J.cl(_t949, null, [J.add(v_i_866, 7.0)]))), J.mul(_s286["H"], (0.02 + J.mul(0.03, v_k_863))), 0.0, J.mul(_s286["__p"]["PI"], 2.0)])
			J.mc(_s286["ctx"], "fill", [])
			v_i_866 = J.num(v_i_866) + 1.0
		v_i_869 = 0.0
		while true:
			if not J.cmp(v_i_869, 8.0, "<"): break
			var _t953 = _s286["__p"]["rnd"]
			v_vx_870 = J.mul((-(0.1 + J.mul(J.cl(_t953, null, [J.add(v_i_869, 11.0)]), 0.4))), _s286["H"])
			var _t954 = _s286["__p"]["rnd"]
			v_vy_871 = J.mul((-(0.2 + J.mul(J.cl(_t954, null, [J.add(v_i_869, 13.0)]), 0.35))), _s286["H"])
			v_px_872 = (((-J.num(v_w_862)) * 0.2) + J.mul(v_vx_870, v_k_863))
			v_py_873 = ((((-J.num(v_h_861)) * 0.75) + J.mul(v_vy_871, v_k_863)) + J.mul(J.mul(J.mul(0.8, _s286["H"]), v_k_863), v_k_863))
			var _t955 = _s286["ctx"]
			var _t956 = ("rgba(255," + J.str((180.0 + (J.mod(v_i_869, 3.0) * 30.0))) + ",220," + J.str(J.max_([0.0, (1.0 - J.div(v_q_857, 1.3))])) + ")")
			J.sp(_t955, "fillStyle", _t956)
			J.mc(_s286["ctx"], "save", [])
			J.mc(_s286["ctx"], "translate", [v_px_872, v_py_873])
			J.mc(_s286["ctx"], "rotate", [J.add(J.mul(v_t_833, 8.0), v_i_869)])
			J.mc(_s286["ctx"], "fillRect", [((-J.num(_s286["H"])) * 0.01), ((-J.num(_s286["H"])) * 0.01), J.mul(_s286["H"], 0.02), J.mul(_s286["H"], 0.02)])
			J.mc(_s286["ctx"], "restore", [])
			v_i_869 = J.num(v_i_869) + 1.0
		J.mc(_s286["ctx"], "restore", [])
		return true
	var _t957 = J.gp(v_o_830, "run")
	if J.t((_t957 if J.t(_t957) else J.gp(v_o_830, "walk"))):
		v_sp_874 = (13.0 if J.t(J.gp(v_o_830, "run")) else 7.0)
		v_ph_875 = J.mul(v_t_833, v_sp_874)
		v_bob_876 = (J.mul(absf(J.num(sin(J.num(v_ph_875)))), _s286["H"]) * (0.04 if J.t(J.gp(v_o_830, "run")) else 0.015))
		v_sway_877 = (J.mul(sin(J.num(v_ph_875)), _s286["H"]) * (0.01 if J.t(J.gp(v_o_830, "run")) else 0.025))
		v_pz_878 = {"hips": (sin(J.num(v_ph_875)) * 0.09), "body": (((-sin(J.num(v_ph_875))) * 0.06) + (0.12 if J.t(J.gp(v_o_830, "run")) else 0.0)), "head": (sin(J.num(v_ph_875)) * 0.04), "legF": (sin(J.num(v_ph_875)) * 0.18), "legB": ((-sin(J.num(v_ph_875))) * 0.18), "armB": (sin(J.num(J.sub(v_ph_875, 0.8))) * 0.18), "armF": ((-sin(J.num(v_ph_875))) * 0.08), "hairR": (sin(J.num(J.sub(v_ph_875, 1.2))) * 0.12), "y": 0.0}
		J.mc(_s286["ctx"], "save", [])
		J.mc(_s286["ctx"], "translate", [v_sway_877, (-J.num(v_bob_876))])
		v_r2_879 = J.cl(v_draw_838, null, ["npc_mis_walk", v_pz_878])
		J.mc(_s286["ctx"], "restore", [])
		return v_r2_879
	var _t958 = J.cmp(J.gp(_s286["n"], "fear"), 25.0, ">=")
	if J.t((_t958 if _t958 else J.gp(_s286["n"], "rx"))):
		return false
	v_z_841 = J.mc(v_A_836, "idle", [v_t_833])
	v_at_842 = J.gp(v_s_834, "at")
	v_dur_843 = J.gp(v_s_834, "dur")
	var _t959 = _s286["__p"]["ss"]
	var _t961 = J.cl(_t959, null, [J.div(v_at_842, 0.35)])
	var _t960 = _s286["__p"]["ss"]
	v_e_844 = J.mul(_t961, J.cl(_t960, null, [J.div(J.sub(v_dur_843, v_at_842), 0.35)]))
	v_pz_845 = J.S_Object_("assign", [{}, v_z_841])
	J.sp(v_pz_845, "armF", 0.0)
	J.sp(v_pz_845, "armB", 0.0)
	if J.seq(J.gp(v_s_834, "act"), "selfie"):
		v_k_880 = v_e_844
		v_pose2_881 = J.S_Object_("assign", [{}, v_pz_845, {"head": J.mul((0.05 * sin(J.num(J.mul(v_at_842, 2.0)))), v_k_880), "body": J.mul((-0.03), v_k_880), "armB": J.mul((0.06 * sin(J.num(J.mul(v_at_842, 7.0)))), v_k_880)}])
		J.cl(v_draw_838, null, ["npc_mis_selfie", v_pose2_881])
		var _t962 = (J.mod(v_at_842, 1.1) < 0.12)
		v_fl_882 = (J.cmp(v_at_842, 0.6, ">") if _t962 else _t962)
		if J.t(v_fl_882):
			v_px_883 = (J.mul((-J.num(v_fx_837)), _s286["H"]) * 0.17)
			v_py_884 = ((-J.num(_s286["H"])) * 0.83)
			J.mc(_s286["ctx"], "save", [])
			var _t963 = _s286["ctx"]
			J.sp(_t963, "globalCompositeOperation", "lighter")
			v_g_885 = J.mc(_s286["ctx"], "createRadialGradient", [v_px_883, v_py_884, 0.0, v_px_883, v_py_884, J.mul(_s286["H"], 0.25)])
			J.mc(v_g_885, "addColorStop", [0.0, "rgba(255,255,255,.9)"])
			J.mc(v_g_885, "addColorStop", [1.0, "rgba(255,255,255,0)"])
			var _t964 = _s286["ctx"]
			J.sp(_t964, "fillStyle", v_g_885)
			J.mc(_s286["ctx"], "beginPath", [])
			J.mc(_s286["ctx"], "arc", [v_px_883, v_py_884, J.mul(_s286["H"], 0.25), 0.0, J.mul(_s286["__p"]["PI"], 2.0)])
			J.mc(_s286["ctx"], "fill", [])
			J.mc(_s286["ctx"], "restore", [])
			var _t965 = _s286["__p"]["text"]
			J.cl(_t965, null, [_s286["ctx"], v_px_883, J.sub(v_py_884, J.mul(_s286["H"], 0.12)), "咔嚓", J.mul(_s286["H"], 0.08), 1.0])
		return true
	if J.seq(J.gp(v_s_834, "act"), "nails"):
		v_k_886 = v_e_844
		var _t967 = sin(J.num(J.mul(v_at_842, 9.0)))
		var _t966 = _s286["__p"]["bump"]
		v_wig_887 = J.mul(_t967, J.cl(_t966, null, [v_at_842, 0.6, 1.0, J.sub(v_dur_843, 0.6)]))
		var _t968 = J.mul((0.06 + (0.02 * sin(J.num(J.mul(v_at_842, 1.5))))), v_k_886)
		J.sp(v_pz_845, "head", _t968)
		var _t969 = J.mul(((-0.06) + J.mul(0.05, v_wig_887)), v_k_886)
		J.sp(v_pz_845, "armF", _t969)
		var _t970 = J.mul(0.03, v_k_886)
		J.sp(v_pz_845, "hips", _t970)
		J.cl(v_draw_838, null, ["npc_mis", v_pz_845])
		if (sin(J.num(J.mul(v_at_842, 2.5))) > 0.6):
			v_sx_888 = (J.mul((-J.num(v_fx_837)), _s286["H"]) * 0.35)
			v_sy_889 = ((-J.num(_s286["H"])) * 0.86)
			J.mc(_s286["ctx"], "save", [])
			var _t971 = _s286["ctx"]
			J.sp(_t971, "strokeStyle", "rgba(255,240,170,.9)")
			var _t972 = _s286["ctx"]
			J.sp(_t972, "lineWidth", 1.6)
			J.mc(_s286["ctx"], "beginPath", [])
			J.mc(_s286["ctx"], "moveTo", [J.sub(v_sx_888, 5.0), v_sy_889])
			J.mc(_s286["ctx"], "lineTo", [J.add(v_sx_888, 5.0), v_sy_889])
			J.mc(_s286["ctx"], "moveTo", [v_sx_888, J.sub(v_sy_889, 5.0)])
			J.mc(_s286["ctx"], "lineTo", [v_sx_888, J.add(v_sy_889, 5.0)])
			J.mc(_s286["ctx"], "stroke", [])
			J.mc(_s286["ctx"], "restore", [])
		return true
	if J.seq(J.gp(v_s_834, "act"), "copy"):
		v_k_890 = v_e_844
		var _t973 = _s286["__p"]["bump"]
		v_tap_891 = J.cl(_t973, null, [J.mod(v_at_842, 1.6), 0.2, 0.4, 0.7])
		var _t974 = J.mul(((-0.12) - J.mul(0.06, v_tap_891)), v_k_890)
		J.sp(v_pz_845, "armF", _t974)
		var _t975 = J.mul(0.03, v_k_890)
		J.sp(v_pz_845, "body", _t975)
		var _t976 = J.mul(0.06, v_k_890)
		J.sp(v_pz_845, "head", _t976)
		J.cl(v_draw_838, null, ["npc_mis", v_pz_845])
		if J.cmp(v_at_842, 0.5, ">"):
			J.cl(_s286["__p"]["copyIdle"], null, [])
		return true
	if J.seq(J.gp(v_s_834, "act"), "hair"):
		var _t977 = _s286["__p"]["bump"]
		v_k_892 = J.mul(v_e_844, J.cl(_t977, null, [v_at_842, 0.1, 0.6, 2.2]))
		var _t979 = sin(J.num(J.mul(v_at_842, 8.0)))
		var _t978 = _s286["__p"]["bump"]
		v_sw_893 = J.mul(_t979, J.cl(_t978, null, [v_at_842, 0.4, 0.8, 1.8]))
		var _t980 = (J.mul((-0.12), v_k_892) + J.mul(0.04, v_sw_893))
		J.sp(v_pz_845, "head", _t980)
		var _t981 = (J.mul((-0.3), v_k_892) + J.mul(0.12, v_sw_893))
		J.sp(v_pz_845, "hairR", _t981)
		var _t982 = J.mul((-0.03), v_k_892)
		J.sp(v_pz_845, "body", _t982)
		var _t983 = J.mul((-0.1), v_k_892)
		J.sp(v_pz_845, "armB", _t983)
		J.cl(v_draw_838, null, ["npc_mis", v_pz_845])
		return true
	if J.seq(J.gp(v_s_834, "act"), "roll"):
		var _t984 = _s286["__p"]["bump"]
		v_k_894 = J.cl(_t984, null, [v_at_842, 0.1, 0.4, 1.6])
		var _t985 = J.mul((-0.16), v_k_894)
		J.sp(v_pz_845, "head", _t985)
		var _t986 = J.mul((-0.04), v_k_894)
		J.sp(v_pz_845, "body", _t986)
		var _t987 = J.mul((-0.15), v_k_894)
		J.sp(v_pz_845, "hairR", _t987)
		J.cl(v_draw_838, null, ["npc_mis", v_pz_845])
		var _t988 = _s286["__p"]["text"]
		var _t990 = _s286["ctx"]
		var _t991 = (J.mul((-J.num(v_fx_837)), _s286["H"]) * 0.3)
		var _t992 = ((-J.num(_s286["H"])) * 1.02)
		var _t993 = J.mul(_s286["H"], 0.11)
		var _t989 = _s286["__p"]["bump"]
		J.cl(_t988, null, [_t990, _t991, _t992, "哼", _t993, J.cl(_t989, null, [v_at_842, 0.2, 0.4, 1.4])])
		J.mc(_s286["ctx"], "save", [])
		var _t994 = _s286["ctx"]
		var _t995 = ("rgba(40,30,60," + J.str(J.mul(0.8, v_k_894)) + ")")
		J.sp(_t994, "strokeStyle", _t995)
		var _t996 = _s286["ctx"]
		J.sp(_t996, "lineWidth", 1.5)
		v_i_895 = 0.0
		while true:
			if not J.cmp(v_i_895, 3.0, "<"): break
			v_bx_896 = ((J.mul(v_fx_837, _s286["H"]) * 0.12) + J.mul(v_i_895, 4.0))
			J.mc(_s286["ctx"], "beginPath", [])
			J.mc(_s286["ctx"], "moveTo", [v_bx_896, ((-J.num(_s286["H"])) * 0.95)])
			J.mc(_s286["ctx"], "lineTo", [v_bx_896, ((-J.num(_s286["H"])) * 0.88)])
			J.mc(_s286["ctx"], "stroke", [])
			v_i_895 = J.num(v_i_895) + 1.0
		J.mc(_s286["ctx"], "restore", [])
		return true
	J.cl(v_draw_838, null, ["npc_mis", v_pz_845])
	return true

func _f114(this_, a: Array, env):
	var v_px_914 = null; var v_py_915 = null
	v_px_914 = J.arg(a, 0)
	v_py_915 = J.arg(a, 1)
	return [J.div(J.sub(v_px_914, J.gp(env["b"], "ox")), J.mul(J.gp(env["b"], "iw"), J.gp(env["b"], "s"))), J.div(J.sub(v_py_915, J.gp(env["b"], "oy")), J.mul(J.gp(env["b"], "ih"), J.gp(env["b"], "s")))]

func _f113(this_, a: Array, env):
	var v_id_899 = null; var v_it_900 = null; var v_p_901 = null; var v_F_902 = null; var v_toF_904 = null; var v_im_905 = null; var v_ch_906 = null; var v_cw_907 = null; var v_cx_908 = null; var v_cy_909 = null; var v_x1_910 = null; var v_y1_911 = null; var v_x2_912 = null; var v_y2_913 = null; var v_x1_916 = null; var v_y1_917 = null; var v_x2_918 = null; var v_y2_919 = null
	var _s308 = {"__p": env, "b": null}
	v_id_899 = J.arg(a, 0)
	v_it_900 = J.gp(_s308["__p"]["items"], v_id_899)
	var _t998 = (not J.t(v_it_900))
	if not J.t(_t998):
		var _t997 = _s308["__p"]["img"]
		_t998 = (not J.t(J.cl(_t997, null, [(J.gp(J.gp(v_it_900, "parent"), "spr") if J.t(J.gp(v_it_900, "parent")) else J.gp(v_it_900, "spr"))])))
	if _t998:
		return null
	var _t999 = J.gp(v_it_900, "parent")
	v_p_901 = (_t999 if J.t(_t999) else v_it_900)
	var _t1000 = _s308["__p"]["frameOf"]
	v_F_902 = J.cl(_t1000, null, [v_p_901])
	_s308["b"] = J.mc(_s308["__p"]["SC"], "bgScale", [])
	v_toF_904 = Callable(self, "_f114").bind(_s308)
	if (not J.t(J.gp(v_it_900, "parent"))):
		var _t1001 = J.cl(v_toF_904, null, [J.sub(J.gp(v_F_902, "x"), J.mul(J.gp(v_it_900, "ax"), J.gp(v_F_902, "w"))), J.sub(J.gp(v_F_902, "y"), J.mul(J.gp(v_it_900, "ay"), J.gp(v_F_902, "h")))])
		var _t1002 = J.gp(_t1001, 0.0)
		v_x1_916 = _t1002
		var _t1003 = J.gp(_t1001, 1.0)
		v_y1_917 = _t1003
		var _t1004 = J.cl(v_toF_904, null, [J.add(J.gp(v_F_902, "x"), J.mul(J.sub(1.0, J.gp(v_it_900, "ax")), J.gp(v_F_902, "w"))), J.add(J.gp(v_F_902, "y"), J.mul(J.sub(1.0, J.gp(v_it_900, "ay")), J.gp(v_F_902, "h")))])
		var _t1005 = J.gp(_t1004, 0.0)
		v_x2_918 = _t1005
		var _t1006 = J.gp(_t1004, 1.0)
		v_y2_919 = _t1006
		return [v_x1_916, v_y1_917, J.sub(v_x2_918, v_x1_916), J.sub(v_y2_919, v_y1_917)]
	var _t1007 = _s308["__p"]["img"]
	v_im_905 = J.cl(_t1007, null, [J.gp(v_it_900, "spr")])
	v_ch_906 = J.mul(J.gp(v_it_900, "h"), J.gp(v_F_902, "u"))
	v_cw_907 = J.div(J.mul(v_ch_906, J.gp(v_im_905, "width")), J.gp(v_im_905, "height"))
	v_cx_908 = (J.sub(J.gp(v_F_902, "x"), J.mul(J.gp(v_p_901, "ax"), J.gp(v_F_902, "w"))) + J.mul(J.gp(v_it_900, "u"), J.gp(v_F_902, "w")))
	v_cy_909 = (J.sub(J.gp(v_F_902, "y"), J.mul(J.gp(v_p_901, "ay"), J.gp(v_F_902, "h"))) + J.mul(J.gp(v_it_900, "v"), J.gp(v_F_902, "h")))
	var _t1008 = J.cl(v_toF_904, null, [J.sub(v_cx_908, J.mul((0.5 if J.leq(J.gp(v_it_900, "ax"), null) else J.gp(v_it_900, "ax")), v_cw_907)), J.sub(v_cy_909, v_ch_906)])
	var _t1009 = J.gp(_t1008, 0.0)
	v_x1_910 = _t1009
	var _t1010 = J.gp(_t1008, 1.0)
	v_y1_911 = _t1010
	var _t1011 = J.cl(v_toF_904, null, [J.add(v_cx_908, J.mul(J.sub(1.0, (0.5 if J.leq(J.gp(v_it_900, "ax"), null) else J.gp(v_it_900, "ax"))), v_cw_907)), v_cy_909])
	var _t1012 = J.gp(_t1011, 0.0)
	v_x2_912 = _t1012
	var _t1013 = J.gp(_t1011, 1.0)
	v_y2_913 = _t1013
	return [v_x1_910, v_y1_911, J.sub(v_x2_912, v_x1_910), J.sub(v_y2_913, v_y1_911)]

func _f2(this_, a: Array, env):
	var v_v_109 = null; var v_a_110 = null; var v_b_111 = null
	v_v_109 = J.arg(a, 0)
	var _t1014 = J.arg(a, 1)
	if _t1014 == null:
		_t1014 = 0.0
	v_a_110 = _t1014
	var _t1015 = J.arg(a, 2)
	if _t1015 == null:
		_t1015 = 1.0
	v_b_111 = _t1015
	return (v_a_110 if J.cmp(v_v_109, v_a_110, "<") else (v_b_111 if J.cmp(v_v_109, v_b_111, ">") else v_v_109))

func _f3(this_, a: Array, env):
	var v_a_112 = null; var v_b_113 = null; var v_k_114 = null
	v_a_112 = J.arg(a, 0)
	v_b_113 = J.arg(a, 1)
	v_k_114 = J.arg(a, 2)
	return J.add(v_a_112, J.mul(J.sub(v_b_113, v_a_112), v_k_114))

func _f4(this_, a: Array, env):
	var v_t_115 = null
	v_t_115 = J.arg(a, 0)
	var _t1016 = env["cl"]
	var _t1017 = J.cl(_t1016, null, [v_t_115])
	v_t_115 = _t1017
	return (J.mul(v_t_115, v_t_115) * (3.0 - J.mul(2.0, v_t_115)))

func _f5(this_, a: Array, env):
	var v_t_116 = null; var v_a_117 = null; var v_m_118 = null; var v_b_119 = null
	v_t_116 = J.arg(a, 0)
	v_a_117 = J.arg(a, 1)
	v_m_118 = J.arg(a, 2)
	v_b_119 = J.arg(a, 3)
	var _t1018 = J.cmp(v_t_116, v_a_117, "<=")
	var _t1022 = null
	if (_t1018 if _t1018 else J.cmp(v_t_116, v_b_119, ">=")):
		_t1022 = 0.0
	else:
		var _t1021 = null
		if J.cmp(v_t_116, v_m_118, "<"):
			var _t1019 = env["ss"]
			_t1021 = J.cl(_t1019, null, [J.div(J.sub(v_t_116, v_a_117), J.sub(v_m_118, v_a_117))])
		else:
			var _t1020 = env["ss"]
			_t1021 = J.sub(1.0, J.cl(_t1020, null, [J.div(J.sub(v_t_116, v_m_118), J.sub(v_b_119, v_m_118))]))
		_t1022 = _t1021
	return _t1022

func _f6(this_, a: Array, env):
	var v_s_120 = null; var v_x_121 = null
	v_s_120 = J.arg(a, 0)
	v_x_121 = (sin(J.num((J.mul(v_s_120, 127.1) + 311.7))) * 43758.5453)
	return J.sub(v_x_121, floor(J.num(v_x_121)))

func _f7(this_, a: Array, env):
	var v_k_122 = null
	v_k_122 = J.arg(a, 0)
	var _t1024 = J.seq(J.typeof_(J.G.get("sprOk")), "function")
	if J.t(_t1024):
		var _t1023 = J.G.get("sprOk")
		_t1024 = J.cl(_t1023, null, [v_k_122])
	return _t1024

func _f8(this_, a: Array, env):
	var v_y_123 = null
	v_y_123 = J.arg(a, 0)
	return J.mul(J.mc(env["SC"], "hh", [v_y_123]), env["KEN_H"])

func _f9(this_, a: Array, env):
	var v_y_124 = null
	v_y_124 = J.arg(a, 0)
	return J.mul(J.mul(J.mc(env["SC"], "hhF", [v_y_124]), env["KEN_H"]), J.mc(env["SC"], "bgAR", []))

func _f10(this_, a: Array, env):
	var v_x_125 = null; var v_y_126 = null
	v_x_125 = J.arg(a, 0)
	v_y_126 = J.arg(a, 1)
	return J.mc(env["SC"], "pt", [v_x_125, v_y_126])

func _f14(this_, a: Array, env):
	var v_n_148 = null
	v_n_148 = J.arg(a, 0)
	var _t1029 = (J.gp(v_n_148, "d") if J.t(v_n_148) else v_n_148)
	var _t1030 = (J.gp(env["STATIONS"], J.gp(J.gp(v_n_148, "d"), "k")) if J.t(_t1029) else _t1029)
	return (_t1030 if J.t(_t1030) else null)

func _f15(this_, a: Array, env):
	var v_n_149 = null; var v_s_150 = null
	v_n_149 = J.arg(a, 0)
	var _t1031 = env["stnOf"]
	v_s_150 = J.cl(_t1031, null, [v_n_149])
	return (J.mul(J.gp(v_s_150, "koff"), J.max_([0.0, (1.0 - J.div(J.hypot_([J.sub(J.gp(v_n_149, "x"), J.gp(J.gp(v_s_150, "seat"), "x")), J.sub(J.gp(v_n_149, "y"), J.gp(J.gp(v_s_150, "seat"), "y"))]), 0.07))])) if J.t(v_s_150) else 0.0)

func _f16(this_, a: Array, env):
	var v_fn_151 = null; var v_keep_152 = null; var v_k_153 = null
	v_fn_151 = J.arg(a, 0)
	v_keep_152 = env["STN"]
	for _t1032 in J.keys(env["STATIONS"]):
		v_k_153 = _t1032
		if J.t(J.gp(J.gp(env["STATIONS"], v_k_153), "K")):
			var _t1033 = env["use"]
			J.cl(_t1033, null, [J.gp(env["STATIONS"], v_k_153)])
			J.cl(v_fn_151, null, [J.gp(env["STATIONS"], v_k_153)])
	var _t1034 = env["use"]
	J.cl(_t1034, null, [v_keep_152])

func _f17(this_, a: Array, env):
	var v_px_154 = null; var v_y_155 = null; var v_on_156 = null; var v_i_157 = null
	var _t1035 = J.gp(J.arg(a, 0), 0.0)
	v_px_154 = _t1035
	var _t1036 = J.gp(J.arg(a, 0), 1.0)
	v_y_155 = _t1036
	var _t1037 = J.gp(J.arg(a, 0), 2.0)
	v_on_156 = _t1037
	v_i_157 = J.arg(a, 1)
	J.mc(env["DEF"], "push", [{"id": J.add("wsch", v_i_157), "spr": "of_chair_front", "wx": (J.div(v_px_154, J.gp(J.G.get("OFFMAP"), "PXU")) + ((-0.085) if J.t(J.mod(v_i_157, 2.0)) else 0.085)), "wy": J.sub(v_y_155, 0.004), "h": 0.6, "ay": 0.98, "shadow": 0.45, "flip": J.mod(v_i_157, 2.0)}])
	var _t1039 = J.add("ws", v_i_157)
	var _t1040 = J.div(v_px_154, J.gp(J.G.get("OFFMAP"), "PXU"))
	var _t1038 = [{"id": J.add("wsm", v_i_157), "spr": "op_mon_back", "u": 0.47, "v": 0.33, "h": 0.5, "ax": 0.5, "ay": 0.96}, {"id": J.add("wsk", v_i_157), "spr": "op_keyboard", "u": 0.5, "v": 0.2, "h": 0.06}]
	J.mc(env["DEF"], "push", [{"id": _t1039, "spr": "of_desk_back_empty", "wx": _t1040, "wy": v_y_155, "h": 0.9, "ay": 0.97, "shadow": 1.1, "glow": v_on_156, "kids": J.mc(_t1038, "concat", [([{"id": J.add("wsg", v_i_157), "spr": "op_mug_back", "u": 0.2, "v": 0.34, "h": 0.12}] if J.seq(J.mod(v_i_157, 3.0), 1.0) else [])])}])

func _f20(this_, a: Array, env):
	var v_y_172 = null
	v_y_172 = J.arg(a, 0)
	return J.mul(J.mul(J.mul(J.gp(J.mc(env["SC"], "persp", []), "c"), J.sub(v_y_172, J.gp(J.mc(env["SC"], "persp", []), "hz"))), env["KEN_H"]), J.mc(env["SC"], "bgAR", []))

func _f77(this_, a: Array, env):
	var v_s_487 = null; var v_K_488 = null
	v_s_487 = J.arg(a, 0)
	v_K_488 = J.gp((v_s_487 if J.t(v_s_487) else env["STN"]), "K")
	var _t1044 = (not (not J.t(v_K_488)))
	if J.t(_t1044):
		var _t1041 = J.seq(J.gp(v_K_488, "mode"), "sit")
		var _t1042 = (_t1041 if _t1041 else J.seq(J.gp(v_K_488, "mode"), "jump"))
		var _t1043 = (_t1042 if _t1042 else J.seq(J.gp(v_K_488, "mode"), "rise"))
		_t1044 = (_t1043 if _t1043 else J.seq(J.gp(v_K_488, "mode"), "sitdown"))
	return _t1044

func _f115(this_, a: Array, env):
	if J.t(env["st"]):
		var _t1045 = env["st"]
		J.sp(_t1045, "door", 1.8)

func _f116(this_, a: Array, env):
	var v_k_920 = null; var v_v_921 = null
	v_k_920 = J.arg(a, 0)
	v_v_921 = J.arg(a, 1)
	if J.t(J.gp(env["STATIONS"], v_k_920)):
		var _t1046 = J.gp(env["STATIONS"], v_k_920)
		var _t1047 = (not (not J.t(v_v_921)))
		J.sp(_t1046, "offline", _t1047)

func _f117(this_, a: Array, env):
	var v_n_922 = null; var v_s_923 = null
	v_n_922 = J.arg(a, 0)
	var _t1048 = env["stnOf"]
	v_s_923 = J.cl(_t1048, null, [v_n_922])
	return (J.gp(J.gp(env["items"], J.gp(v_s_923, "desk")), "z") if J.t((J.gp(env["items"], J.gp(v_s_923, "desk")) if J.t(v_s_923) else v_s_923)) else (J.gp(v_n_922, "y") if J.t(v_n_922) else 0.6))

func _f118(this_, a: Array, env):
	return env["items"]

func _f119(this_, a: Array, env):
	var v_k_924 = null
	v_k_924 = J.arg(a, 0)
	return J.gp(J.gp(env["STATIONS"], (v_k_924 if J.t(v_k_924) else "ken")), "K")

func _f1(this_, a: Array, env):
	var v_bgCanvas_18 = null; var v_kenOff_26 = null; var v_WS_29 = null; var v_TUBES_31 = null; var v_WIN_33 = null; var v_init_44 = null; var v_seated_50 = null; var v_kenTick_51 = null; var v_tick_52 = null; var v_onProp_63 = null; var v_drawDark_66 = null; var v_drawBack_68 = null; var v_drawClock_72 = null; var v_drawAC_73 = null; var v_clipWindow_74 = null; var v_drawables_75 = null; var v_drawFloor_76 = null; var v_drawKen_100 = null; var v_drawMis_107 = null; var v_rectOf_108 = null
	var _s3 = {"__p": env, "PI": null, "cl": null, "lerp": null, "ss": null, "bump": null, "rnd": null, "ok": null, "KEN_H": null, "SIT_H": null, "SC": null, "U": null, "UW": null, "P": null, "TC": null, "img": null, "BGC": null, "STATIONS": null, "STN": null, "SEAT": null, "SEATV": null, "K": null, "use": null, "stnOf": null, "eachStn": null, "DEF": null, "CLOCK": null, "AC": null, "SIT": null, "CHAIR": null, "this_mon": null, "items": null, "list": null, "kids": null, "flying": null, "floor": null, "drops": null, "st": null, "layoutKen": null, "KEN_UW": null, "resetKen": null, "pickAct": null, "atDesk": null, "nearestTo": null, "selfSpin": null, "chairTick": null, "startFall": null, "fallTick": null, "paperTick": null, "copierPaper": null, "paperFly": null, "spill": null, "onScare": null, "lightsDark": null, "kidPos": null, "shadowAt": null, "EV": null, "ELEV": null, "drawDoor": null, "frameOf": null, "drawItem": null, "kenAtDesk": null, "monState": null, "kidImg": null, "drawKid": null, "QUAD": null, "monScreen": null, "monLight": null, "monHalo": null, "deskSpill": null, "lampFx": null, "copierFx": null, "waterFx": null, "deskFx": null, "drawFan": null, "drawFreeChair": null, "chairSprite": null, "drawKenChair": null, "drawFallen": null, "drawFlying": null, "rig": null, "seatH": null, "steam": null, "text": null, "MIS_ACTS": null, "MIS_SAY": null, "copyIdle": null, "misTick": null}
	_s3["img"] = Callable(self, "_f11").bind(_s3)
	v_bgCanvas_18 = Callable(self, "_f12").bind(_s3)
	_s3["use"] = Callable(self, "_f13").bind(_s3)
	v_init_44 = Callable(self, "_f18").bind(_s3)
	_s3["layoutKen"] = Callable(self, "_f19").bind(_s3)
	_s3["resetKen"] = Callable(self, "_f21").bind(_s3)
	_s3["pickAct"] = Callable(self, "_f22").bind(_s3)
	_s3["atDesk"] = Callable(self, "_f25").bind(_s3)
	v_seated_50 = Callable(self, "_f26").bind(_s3)
	v_kenTick_51 = Callable(self, "_f27").bind(_s3)
	v_tick_52 = Callable(self, "_f29").bind(_s3)
	_s3["nearestTo"] = Callable(self, "_f34").bind(_s3)
	_s3["selfSpin"] = Callable(self, "_f35").bind(_s3)
	_s3["chairTick"] = Callable(self, "_f36").bind(_s3)
	_s3["startFall"] = Callable(self, "_f37").bind(_s3)
	_s3["fallTick"] = Callable(self, "_f38").bind(_s3)
	_s3["paperTick"] = Callable(self, "_f39").bind(_s3)
	_s3["copierPaper"] = Callable(self, "_f40").bind(_s3)
	_s3["paperFly"] = Callable(self, "_f41").bind(_s3)
	_s3["spill"] = Callable(self, "_f42").bind(_s3)
	_s3["onScare"] = Callable(self, "_f43").bind(_s3)
	v_onProp_63 = Callable(self, "_f46").bind(_s3)
	_s3["lightsDark"] = Callable(self, "_f50").bind(_s3)
	_s3["kidPos"] = Callable(self, "_f52").bind(_s3)
	v_drawDark_66 = Callable(self, "_f53").bind(_s3)
	_s3["shadowAt"] = Callable(self, "_f57").bind(_s3)
	v_drawBack_68 = Callable(self, "_f58").bind(_s3)
	_s3["drawDoor"] = Callable(self, "_f59").bind(_s3)
	v_drawClock_72 = Callable(self, "_f63").bind(_s3)
	v_drawAC_73 = Callable(self, "_f65").bind(_s3)
	v_clipWindow_74 = Callable(self, "_f66").bind(_s3)
	v_drawables_75 = Callable(self, "_f67").bind(_s3)
	v_drawFloor_76 = Callable(self, "_f74").bind(_s3)
	_s3["frameOf"] = Callable(self, "_f75").bind(_s3)
	_s3["drawItem"] = Callable(self, "_f76").bind(_s3)
	_s3["monState"] = Callable(self, "_f78").bind(_s3)
	_s3["kidImg"] = Callable(self, "_f79").bind(_s3)
	_s3["drawKid"] = Callable(self, "_f80").bind(_s3)
	_s3["monScreen"] = Callable(self, "_f82").bind(_s3)
	_s3["monLight"] = Callable(self, "_f84").bind(_s3)
	_s3["monHalo"] = Callable(self, "_f85").bind(_s3)
	_s3["deskSpill"] = Callable(self, "_f86").bind(_s3)
	_s3["lampFx"] = Callable(self, "_f87").bind(_s3)
	_s3["copierFx"] = Callable(self, "_f88").bind(_s3)
	_s3["waterFx"] = Callable(self, "_f89").bind(_s3)
	_s3["deskFx"] = Callable(self, "_f90").bind(_s3)
	_s3["drawFan"] = Callable(self, "_f91").bind(_s3)
	_s3["drawFreeChair"] = Callable(self, "_f92").bind(_s3)
	_s3["chairSprite"] = Callable(self, "_f93").bind(_s3)
	_s3["drawKenChair"] = Callable(self, "_f94").bind(_s3)
	_s3["drawFallen"] = Callable(self, "_f95").bind(_s3)
	_s3["drawFlying"] = Callable(self, "_f96").bind(_s3)
	_s3["rig"] = Callable(self, "_f97").bind(_s3)
	_s3["seatH"] = Callable(self, "_f98").bind(_s3)
	v_drawKen_100 = Callable(self, "_f99").bind(_s3)
	_s3["steam"] = Callable(self, "_f102").bind(_s3)
	_s3["text"] = Callable(self, "_f103").bind(_s3)
	_s3["copyIdle"] = Callable(self, "_f104").bind(_s3)
	_s3["misTick"] = Callable(self, "_f105").bind(_s3)
	v_drawMis_107 = Callable(self, "_f110").bind(_s3)
	v_rectOf_108 = Callable(self, "_f113").bind(_s3)
	_s3["PI"] = PI
	_s3["cl"] = Callable(self, "_f2").bind(_s3)
	_s3["lerp"] = Callable(self, "_f3").bind(_s3)
	_s3["ss"] = Callable(self, "_f4").bind(_s3)
	_s3["bump"] = Callable(self, "_f5").bind(_s3)
	_s3["rnd"] = Callable(self, "_f6").bind(_s3)
	_s3["ok"] = Callable(self, "_f7").bind(_s3)
	_s3["KEN_H"] = J.div(64.0, (64.0 * 1.08))
	_s3["SIT_H"] = 0.876
	_s3["SC"] = null
	_s3["U"] = Callable(self, "_f8").bind(_s3)
	_s3["UW"] = Callable(self, "_f9").bind(_s3)
	_s3["P"] = Callable(self, "_f10").bind(_s3)
	_s3["TC"] = {}
	_s3["BGC"] = null
	_s3["STATIONS"] = {"ken": {"k": "ken", "seat": {"x": J.mc(J.G.get("OFFMAP"), "M", [0.24]), "y": J.mc(J.G.get("OFFMAP"), "MY", [0.6])}, "koff": 0.065, "desk": "kdesk", "mon": "kmon", "mug": "kmug", "base": "npc_ken_sit", "stretch": "npc_ken_sit_stretch", "drink": "npc_ken_sit_coffee", "jump": "npc_ken_sit_jump", "hand": [0.39, 0.315], "arms": [(-0.05), 0.5, 0.67, 0.185], "face": [0.3, 0.28], "drinkSay": null, "stretchSay": "哈～", "acts": [["type", 5.0, [4.0, 8.0], 0.0], ["stretch", 1.2, [3.2, 3.2], 11.0], ["drink", 1.3, [3.8, 3.8], 12.0], ["roll", 1.0, [3.0, 3.0], 7.0], ["spin", 0.6, [2.6, 2.6], 14.0]], "bones": [["thigh", null, 0.92, 0.74, 0.22, 0.7, 0.13], ["shin", null, 0.3, 0.72, 0.3, 0.99, 0.14], ["body", null, 0.85, 0.72, 0.68, 0.42, 0.2], ["head", "body", 0.64, 0.4, 0.52, 0.06, 0.32], ["armF", "body", 0.62, 0.55, 0.1, 0.63, 0.085]]}, "it": {"k": "it", "seat": {"x": J.mc(J.G.get("OFFMAP"), "M", [0.66]), "y": 0.8}, "koff": 0.0, "desk": "idesk", "mon": "imon", "mug": null, "base": "npc_it_sit", "stretch": null, "drink": "npc_it_sit_tea", "jump": "npc_it_sit_jump", "hand": [0.385, 0.37], "arms": [(-0.03), 0.47, 0.62, 0.16], "face": [0.32, 0.3], "drinkSay": "啜——", "stretchSay": null, "acts": [["type", 5.0, [4.0, 8.0], 0.0], ["drink", 1.4, [3.8, 3.8], 11.0], ["neck", 1.1, [3.0, 3.0], 9.0], ["vibe", 1.2, [3.5, 5.0], 8.0], ["roll", 0.8, [3.0, 3.0], 8.0], ["spin", 0.5, [2.6, 2.6], 14.0]], "bones": [["thigh", null, 0.8, 0.7, 0.2, 0.7, 0.13], ["shin", null, 0.25, 0.72, 0.22, 0.99, 0.14], ["body", null, 0.72, 0.68, 0.55, 0.45, 0.22], ["hair", "body", 0.62, 0.3, 0.86, 0.55, 0.16], ["head", "body", 0.48, 0.44, 0.42, 0.06, 0.34], ["armF", "body", 0.52, 0.48, 0.06, 0.56, 0.09]]}}
	var _t1025 = J.gp(_s3["STATIONS"], "ken")
	var _t1026 = {"x": J.add(J.gp(J.gp(J.gp(_s3["STATIONS"], "ken"), "seat"), "x"), J.gp(J.gp(_s3["STATIONS"], "ken"), "koff")), "y": J.gp(J.gp(J.gp(_s3["STATIONS"], "ken"), "seat"), "y")}
	J.sp(_t1025, "SEATV", _t1026)
	var _t1027 = J.gp(_s3["STATIONS"], "it")
	var _t1028 = {"x": J.add(J.gp(J.gp(J.gp(_s3["STATIONS"], "it"), "seat"), "x"), J.gp(J.gp(_s3["STATIONS"], "it"), "koff")), "y": J.gp(J.gp(J.gp(_s3["STATIONS"], "it"), "seat"), "y")}
	J.sp(_t1027, "SEATV", _t1028)
	_s3["STN"] = J.gp(_s3["STATIONS"], "ken")
	_s3["SEAT"] = J.gp(_s3["STN"], "seat")
	_s3["SEATV"] = J.gp(_s3["STN"], "SEATV")
	_s3["K"] = null
	_s3["stnOf"] = Callable(self, "_f14").bind(_s3)
	v_kenOff_26 = Callable(self, "_f15").bind(_s3)
	_s3["eachStn"] = Callable(self, "_f16").bind(_s3)
	_s3["DEF"] = [{"id": "cabinet", "spr": "of_cabinet", "x": 0.135, "y": 0.505, "h": 0.7, "shadow": 0.62, "kids": [{"id": "binder1", "spr": "op_binder", "u": 0.3, "v": 0.055, "h": 0.19, "fall": 1.0}, {"id": "binder2", "spr": "op_binder", "u": 0.47, "v": 0.05, "h": 0.19, "fall": 1.0, "flip": 1.0}, {"id": "stack", "spr": "op_stack", "u": 0.74, "v": 0.07, "h": 0.13, "fall": 1.0}]}, {"id": "idesk", "spr": "of_desk_back_empty", "x": 0.0, "y": 0.0, "uy": 0.515, "z": 0.515, "h": 0.9, "ax": J.div(360.0, 567.0), "ay": J.div(52.0, 435.0), "shadow": 1.25, "shu": 0.5, "shv": 0.9, "floorV": 0.966, "stn": "it", "back": 1.0, "kids": [{"id": "lamp", "spr": "of_lamp", "u": 0.16, "v": 0.31, "h": 0.3, "ax": 0.78, "lamp": 1.0}, {"id": "icactus", "spr": "op_cactus", "u": 0.86, "v": 0.3, "h": 0.11, "fall": 1.0}, {"id": "ipaper", "spr": "op_paper", "u": 0.28, "v": 0.16, "h": 0.075, "paper": 1.0, "rot": 0.2}, {"id": "imon", "spr": "op_mon_back", "u": 0.45, "v": 0.33, "h": 0.5, "ax": 0.5, "ay": 0.96, "mon": 1.0, "stn": "it", "back": 1.0}]}, {"id": "achair", "spr": "of_chair_back", "x": 0.45, "y": 0.59, "h": 0.66, "shadow": 0.5, "chair": 1.0}, {"id": "copier", "spr": "of_copier", "x": 0.705, "y": 0.515, "h": 0.74, "ay": 0.97, "shadow": 0.9, "copier": 1.0}, {"id": "water", "spr": "of_water", "x": 0.83, "y": 0.51, "h": 0.8, "ay": 0.985, "shadow": 0.42, "water": 1.0}, {"id": "fan", "spr": "of_fan", "x": 0.03, "y": 0.56, "wx": J.mc(J.G.get("OFFMAP"), "npx", [5180.0]), "wy": 0.74, "h": 0.78, "shadow": 0.42, "fan": 1.0}, {"id": "bin", "spr": "op_bin", "x": 0.245, "y": 0.522, "h": 0.22, "shadow": 0.3}, {"id": "kdesk", "spr": "of_desk_back_empty", "x": 0.0, "y": 0.0, "uy": 0.6, "z": 0.6, "h": 0.9, "ax": J.div(360.0, 567.0), "ay": J.div(52.0, 435.0), "shadow": 1.25, "shu": 0.5, "shv": 0.9, "floorV": 0.966, "stn": "ken", "back": 1.0, "kids": [{"id": "kmug", "spr": "op_mug_back", "u": 0.22, "v": 0.34, "h": 0.12, "mug": 1.0, "fall": 1.0}, {"id": "kpaper", "spr": "op_paper", "u": 0.3, "v": 0.15, "h": 0.075, "paper": 1.0, "rot": 0.25}, {"id": "kmon", "spr": "op_mon_back", "u": 0.45, "v": 0.33, "h": 0.5, "ax": 0.5, "ay": 0.96, "mon": 1.0, "stn": "ken", "back": 1.0}]}]
	v_WS_29 = [[5430.0, 0.715, 1.0], [5810.0, 0.715, 0.0], [8790.0, 0.715, 1.0], [9170.0, 0.715, 0.0], [9550.0, 0.715, 1.0], [10330.0, 0.885, 1.0]]
	J.mc(v_WS_29, "forEach", [Callable(self, "_f17").bind(_s3)])
	_s3["CLOCK"] = {"x": 0.815, "y": 0.335, "d": 0.42, "depth": 0.48}
	v_TUBES_31 = [[0.075, 0.042, 0.34, 0.034], [0.59, 0.042, 0.345, 0.038], [0.165, 0.148, 0.24, 0.022], [0.535, 0.148, 0.25, 0.022], [0.215, 0.204, 0.185, 0.012], [0.51, 0.204, 0.18, 0.012]]
	_s3["AC"] = [0.815, 0.148, 0.16, 0.097]
	v_WIN_33 = J.gp(J.G.get("OFFMAP"), "WINMAIN")
	_s3["SIT"] = {"npc_ken_sit": [0.982, 0.99, 598.0], "npc_ken_sit_stretch": [0.603, 0.99, 606.0], "npc_ken_sit_coffee": [0.87, 0.992, 621.0], "npc_ken_sit_jump": [0.822, 0.992, 627.0], "npc_it_sit": [0.8, 0.99, 598.0], "npc_it_sit_tea": [0.71, 0.99, 606.0], "npc_it_sit_jump": [0.64, 0.99, 618.0]}
	_s3["CHAIR"] = {"spr": "of_chair_front", "back": 0.64, "seat": 0.4, "h": 0.6}
	_s3["this_mon"] = null
	_s3["items"] = {}
	_s3["list"] = []
	_s3["kids"] = []
	_s3["flying"] = []
	_s3["floor"] = []
	_s3["drops"] = []
	_s3["st"] = null
	_s3["KEN_UW"] = Callable(self, "_f20").bind(_s3)
	_s3["EV"] = J.gp(J.G.get("OFFMAP"), "ELEV")
	_s3["ELEV"] = {"x0": J.gp(_s3["EV"], "x0"), "x1": J.gp(_s3["EV"], "x1"), "seam": J.gp(_s3["EV"], "seam"), "top": [J.gp(_s3["EV"], "top"), J.gp(_s3["EV"], "top")], "bot": [J.gp(_s3["EV"], "bot"), J.gp(_s3["EV"], "bot")]}
	_s3["kenAtDesk"] = Callable(self, "_f77").bind(_s3)
	_s3["QUAD"] = {"op_mon_side_on": [[0.245, 0.218], [0.887, 0.065], [0.887, 0.632], [0.245, 0.719]], "op_mon_side_off": [[0.23, 0.226], [0.897, 0.086], [0.897, 0.645], [0.23, 0.742]]}
	_s3["MIS_ACTS"] = [["copy", 2.4, [3.0, 5.0], 3.0], ["nails", 2.2, [3.0, 5.0], 0.0], ["selfie", 1.6, [3.2, 3.2], 7.0], ["hair", 1.3, [2.6, 2.6], 6.0], ["stand", 1.0, [1.5, 3.0], 0.0]]
	_s3["MIS_SAY"] = {"selfie": "唔該你哋行開少少，阻住我影相。", "sigh": "陳總～人哋要放假啦～", "roll": "呢啲嘢搵阿Ken做啦。"}
	return {"elevator": Callable(self, "_f115").bind(_s3), "offline": Callable(self, "_f116").bind(_s3), "drawMis": v_drawMis_107, "kenOff": v_kenOff_26, "init": v_init_44, "tick": v_tick_52, "kenTick": v_kenTick_51, "onScare": _s3["onScare"], "onProp": v_onProp_63, "drawBack": v_drawBack_68, "drawFloor": v_drawFloor_76, "drawables": v_drawables_75, "drawKen": v_drawKen_100, "drawDark": v_drawDark_66, "kenZ": Callable(self, "_f117").bind(_s3), "STATIONS": _s3["STATIONS"], "seated": v_seated_50, "clipWindow": v_clipWindow_74, "rectOf": v_rectOf_108, "SEAT": J.gp(J.gp(_s3["STATIONS"], "ken"), "seat"), "items": Callable(self, "_f118").bind(_s3), "K": Callable(self, "_f119").bind(_s3), "AC": _s3["AC"], "WIN": v_WIN_33, "CLOCK": _s3["CLOCK"]}
