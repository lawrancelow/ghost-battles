# 自動轉譯自 limbs.js（tools/jsgd.js）——唔好直接改，改原 JS 再轉
extends RefCounted

func run(env):
	var this_ = null; var a = []
	J.G["Limbs"] = J.cl(Callable(self, "_f1").bind(env), null, [])

func _f9(this_, a: Array, env):
	var v_type_28 = null; var v_c_29 = null
	v_type_28 = J.arg(a, 0)
	v_c_29 = J.gp(J.cl(env["C"], null, []), v_type_28)
	var _t2 = v_c_29
	if J.t(_t2):
		var _t1 = env["ok"]
		_t2 = J.cl(_t1, null, [J.add(v_type_28, "__body")])
	var _t4 = _t2
	if J.t(_t4):
		var _t3 = env["ok"]
		_t4 = J.cl(_t3, null, [J.add(v_type_28, "__arm")])
	return (not (not J.t(_t4)))

func _f10(this_, a: Array, env):
	var v_type_32 = null; var v_src_33 = null; var v_o_34 = null; var v_n_35 = null
	v_type_32 = J.arg(a, 0)
	var _t5 = J.gp(J.cl(env["C"], null, []), v_type_32)
	var _t6 = (J.gp(J.gp(J.cl(env["C"], null, []), v_type_32), "K") if J.t(_t5) else _t5)
	v_src_33 = (_t6 if J.t(_t6) else env["DEFK"])
	var _t7 = J.gp(env["KN"], v_type_32)
	if J.t((J.seq(J.gp(J.gp(env["KN"], v_type_32), "src"), v_src_33) if J.t(_t7) else _t7)):
		return J.gp(J.gp(env["KN"], v_type_32), "k")
	v_o_34 = {}
	for _t8 in J.keys(v_src_33):
		v_n_35 = _t8
		var _t9 = J.S_Object_("assign", [{"th": 0.0, "lean": 0.0, "dx": 0.0, "dy": 0.0, "sx": 1.0, "sy": 1.0, "hx": 0.0, "hy": 0.0, "bend": 0.0}, J.gp(v_src_33, v_n_35)])
		J.sp(v_o_34, v_n_35, _t9)
	var _t10 = env["KN"]
	var _t11 = {"src": v_src_33, "k": v_o_34}
	J.sp(_t10, v_type_32, _t11)
	return v_o_34

func _f11(this_, a: Array, env):
	var v_type_38 = null; var v_pose_39 = null; var v_p_40 = null; var v_K_41 = null; var v_q_42 = null
	v_type_38 = J.arg(a, 0)
	v_pose_39 = J.arg(a, 1)
	v_p_40 = J.arg(a, 2)
	var _t12 = env["keysOf"]
	v_K_41 = J.cl(_t12, null, [v_type_38])
	var _t13 = J.max_([0.0, J.min_([1.0, (v_p_40 if J.t(v_p_40) else 0.0)])])
	v_p_40 = _t13
	var _t14 = -1
	var _t15 = false
	if _t14 == -1 and J.seq(v_pose_39, "windup"): _t14 = 0
	if _t14 == -1 and J.seq(v_pose_39, "strike"): _t14 = 1
	if _t14 == -1 and J.seq(v_pose_39, "follow"): _t14 = 2
	if _t14 == -1 and J.seq(v_pose_39, "recover"): _t14 = 3
	if _t14 == -1 and J.seq(v_pose_39, "chop"): _t14 = 4
	if _t14 == -1 and J.seq(v_pose_39, "hammer"): _t14 = 5
	while true:
		if _t14 <= 0 and _t14 >= 0:
			var _t16 = env["lerp"]
			return J.cl(_t16, null, [J.gp(v_K_41, "idle"), J.gp(v_K_41, "antic"), J.mc(env["ez"], "o", [v_p_40])])
		if _t14 <= 1 and _t14 >= 0:
			var _t19 = null
			if J.cmp(v_p_40, 0.42, "<"):
				var _t17 = env["lerp"]
				_t19 = J.cl(_t17, null, [J.gp(v_K_41, "antic"), J.gp(v_K_41, "contact"), J.mc(env["ez"], "i", [J.div(v_p_40, 0.42)])])
			else:
				var _t18 = env["lerp"]
				_t19 = J.cl(_t18, null, [J.gp(v_K_41, "contact"), J.gp(v_K_41, "follow"), J.mc(env["ez"], "o3", [J.div(J.sub(v_p_40, 0.42), 0.58)])])
			return _t19
		if _t14 <= 2 and _t14 >= 0:
			var _t20 = env["lerp"]
			return J.cl(_t20, null, [J.gp(v_K_41, "contact"), J.gp(v_K_41, "follow"), J.mc(env["ez"], "o3", [v_p_40])])
		if _t14 <= 3 and _t14 >= 0:
			var _t21 = env["lerp"]
			return J.cl(_t21, null, [J.gp(v_K_41, "follow"), J.gp(v_K_41, "idle"), J.mc(env["ez"], "io", [v_p_40])])
		if _t14 <= 4 and _t14 >= 0:
			pass
		if _t14 <= 5 and _t14 >= 0:
			v_q_42 = (J.mod(J.mul(v_p_40, 2.0), 1.0) if J.seq(v_pose_39, "hammer") else v_p_40)
			if J.cmp(v_q_42, 0.62, "<"):
				var _t22 = env["lerp"]
				return J.cl(_t22, null, [J.gp(v_K_41, "idle"), J.gp(v_K_41, "antic"), J.mc(env["ez"], "o", [J.div(v_q_42, 0.62)])])
			if J.cmp(v_q_42, 0.8, "<"):
				var _t23 = env["lerp"]
				return J.cl(_t23, null, [J.gp(v_K_41, "antic"), J.gp(v_K_41, "contact"), J.mc(env["ez"], "i", [J.div(J.sub(v_q_42, 0.62), 0.18)])])
			var _t24 = env["lerp"]
			return J.cl(_t24, null, [J.gp(v_K_41, "contact"), J.gp(v_K_41, "follow"), J.mc(env["ez"], "o3", [J.div(J.sub(v_q_42, 0.8), 0.2)])])
		break
	return J.gp(v_K_41, "idle")

func _f12(this_, a: Array, env):
	var v_type_45 = null; var v_wid_46 = null; var v_W_47 = null; var v_id_48 = null
	v_type_45 = J.arg(a, 0)
	v_wid_46 = J.arg(a, 1)
	v_W_47 = J.gp(J.G.get("LIMBS_DATA"), "weapons")
	v_id_48 = (v_wid_46 if J.t(v_wid_46) else J.gp(J.gp(J.cl(env["C"], null, []), v_type_45), "weapon"))
	var _t26 = (J.gp(v_W_47, v_id_48) if J.t(v_id_48) else v_id_48)
	if J.t(_t26):
		var _t25 = env["ok"]
		_t26 = J.cl(_t25, null, [J.gp(J.gp(v_W_47, v_id_48), "img")])
	return (J.gp(v_W_47, v_id_48) if J.t(_t26) else null)

func _f14(this_, a: Array, env):
	J.mc(env["ctx"], "save", [])
	J.mc(env["ctx"], "rotate", [J.mul((-J.num(J.gp(env["wp"], "ang"))), env["__p"]["D"])])
	J.mc(env["ctx"], "drawImage", [env["im"], J.mul((-J.num(J.gp(J.gp(env["wp"], "grip"), 0.0))), env["ww"]), J.mul((-J.num(J.gp(J.gp(env["wp"], "grip"), 1.0))), env["wh"]), env["ww"], env["wh"]])
	J.mc(env["ctx"], "restore", [])

func _f13(this_, a: Array, env):
	var v_c_52 = null; var v_H_54 = null; var v_bend_55 = null; var v_tx_59 = null; var v_ty_60 = null; var v_n_61 = null; var v_len_62 = null; var v_seg_63 = null; var v_big_64 = null; var v_ov_65 = null; var v_img_66 = null; var v_i_67 = null; var v_y0_68 = null; var v_y1_69 = null
	var _s18 = {"__p": env, "ctx": null, "wp": null, "im": null, "ww": null, "wh": null}
	_s18["ctx"] = J.arg(a, 0)
	v_c_52 = J.arg(a, 1)
	_s18["wp"] = J.arg(a, 2)
	v_H_54 = J.arg(a, 3)
	v_bend_55 = J.arg(a, 4)
	_s18["im"] = J.gp(J.G.get("SPR"), J.gp(_s18["wp"], "img"))
	_s18["ww"] = J.mul(J.gp(_s18["wp"], "w"), v_H_54)
	_s18["wh"] = J.mul(J.gp(_s18["wp"], "h"), v_H_54)
	v_tx_59 = J.mul(J.sub(J.gp(J.gp(_s18["wp"], "tip"), 0.0), J.gp(J.gp(_s18["wp"], "grip"), 0.0)), _s18["ww"])
	v_ty_60 = J.mul(J.sub(J.gp(J.gp(_s18["wp"], "tip"), 1.0), J.gp(J.gp(_s18["wp"], "grip"), 1.0)), _s18["wh"])
	var _t27 = J.gp(_s18["wp"], "flex")
	v_n_61 = (_t27 if J.t(_t27) else 0.0)
	var _t28 = (not J.t(v_n_61))
	if (_t28 if _t28 else (not J.t(v_bend_55))):
		J.mc(_s18["ctx"], "rotate", [J.mul(J.sub(J.gp(v_c_52, "hold"), J.gp(_s18["wp"], "ang")), _s18["__p"]["D"])])
		J.mc(_s18["ctx"], "drawImage", [_s18["im"], J.mul((-J.num(J.gp(J.gp(_s18["wp"], "grip"), 0.0))), _s18["ww"]), J.mul((-J.num(J.gp(J.gp(_s18["wp"], "grip"), 1.0))), _s18["wh"]), _s18["ww"], _s18["wh"]])
		J.mc(_s18["ctx"], "translate", [v_tx_59, v_ty_60])
		return J.mc(_s18["ctx"], "getTransform", [])
	v_len_62 = J.hypot_([v_tx_59, v_ty_60])
	v_seg_63 = J.div(v_len_62, v_n_61)
	v_big_64 = (J.max_([_s18["ww"], _s18["wh"]]) * 2.0)
	v_ov_65 = J.mul(v_seg_63, 0.15)
	J.mc(_s18["ctx"], "rotate", [J.mul(J.gp(v_c_52, "hold"), _s18["__p"]["D"])])
	v_img_66 = Callable(self, "_f14").bind(_s18)
	v_i_67 = 0.0
	while true:
		if not J.cmp(v_i_67, v_n_61, "<"): break
		if J.cmp(v_i_67, 0.0, ">"):
			J.mc(_s18["ctx"], "translate", [0.0, J.mul((-J.num(v_seg_63)), v_i_67)])
			J.mc(_s18["ctx"], "rotate", [J.mul(J.div(v_bend_55, v_n_61), _s18["__p"]["D"])])
			J.mc(_s18["ctx"], "translate", [0.0, J.mul(v_seg_63, v_i_67)])
		v_y0_68 = (v_big_64 if J.seq(v_i_67, 0.0) else J.add(J.mul((-J.num(v_seg_63)), v_i_67), v_ov_65))
		v_y1_69 = ((-J.num(v_big_64)) if J.seq(v_i_67, J.sub(v_n_61, 1.0)) else J.sub(J.mul((-J.num(v_seg_63)), J.add(v_i_67, 1.0)), v_ov_65))
		J.mc(_s18["ctx"], "save", [])
		J.mc(_s18["ctx"], "beginPath", [])
		J.mc(_s18["ctx"], "rect", [(-J.num(v_big_64)), v_y1_69, J.mul(v_big_64, 2.0), J.sub(v_y0_68, v_y1_69)])
		J.mc(_s18["ctx"], "clip", [])
		J.cl(v_img_66, null, [])
		J.mc(_s18["ctx"], "restore", [])
		v_i_67 = J.num(v_i_67) + 1.0
	J.mc(_s18["ctx"], "translate", [0.0, (-J.num(v_len_62))])
	return J.mc(_s18["ctx"], "getTransform", [])

func _f16(this_, a: Array, env):
	if (not J.t(env["wp"])):
		return null
	J.mc(env["ctx"], "save", [])
	J.mc(env["ctx"], "translate", [env["lx"], env["ly"]])
	J.mc(env["ctx"], "rotate", [J.mul(env["ath"], env["__p"]["D"])])
	if J.t(env["nr"]):
		J.mc(env["ctx"], "scale", [(-1.0), 1.0])
	J.mc(env["ctx"], "translate", [J.mul(J.sub(J.gp(J.gp(env["c"], "grip"), 0.0), J.gp(J.gp(env["c"], "pivot"), 0.0)), env["W"]), J.mul(J.sub(J.gp(J.gp(env["c"], "grip"), 1.0), J.gp(J.gp(env["c"], "pivot"), 1.0)), env["H"])])
	J.mc(env["ctx"], "rotate", [(J.mul(env["wth"], env["__p"]["D"]) * ((-1.0) if J.t(env["nr"]) else 1.0))])
	var _t50 = env["__p"]["drawWeapon"]
	var _t51 = J.cl(_t50, null, [env["ctx"], env["c"], env["wp"], env["H"], J.gp(env["s"], "bend")])
	env["tipM"] = _t51
	J.mc(env["ctx"], "restore", [])

func _f17(this_, a: Array, env):
	J.mc(env["ctx"], "save", [])
	J.mc(env["ctx"], "translate", [env["lx"], env["ly"]])
	J.mc(env["ctx"], "rotate", [J.mul(env["ath"], env["__p"]["D"])])
	if J.t(env["nr"]):
		J.mc(env["ctx"], "scale", [(-1.0), 1.0])
	var _t52 = (not J.t(env["wp"]))
	if J.t((J.gp(env["c"], "tip") if _t52 else _t52)):
		J.mc(env["ctx"], "save", [])
		J.mc(env["ctx"], "translate", [J.mul(J.sub(J.gp(J.gp(env["c"], "tip"), 0.0), J.gp(J.gp(env["c"], "pivot"), 0.0)), env["W"]), J.mul(J.sub(J.gp(J.gp(env["c"], "tip"), 1.0), J.gp(J.gp(env["c"], "pivot"), 1.0)), env["H"])])
		var _t53 = J.mc(env["ctx"], "getTransform", [])
		env["tipM"] = _t53
		J.mc(env["ctx"], "restore", [])
	J.mc(env["ctx"], "drawImage", [env["arm"], J.mul((-J.num(J.gp(J.gp(env["c"], "pivot"), 0.0))), env["W"]), J.mul((-J.num(J.gp(J.gp(env["c"], "pivot"), 1.0))), env["H"]), env["W"], env["H"]])
	J.mc(env["ctx"], "restore", [])

func _f15(this_, a: Array, env):
	var v_type_73 = null; var v_x_74 = null; var v_y_75 = null; var v_o_77 = null; var v_faceRight_78 = null; var v_meshPose_79 = null; var v_body_82 = null; var v_pvx_87 = null; var v_R_88 = null; var v_atk_89 = null; var v_walking_90 = null; var v_thAdd_91 = null; var v_mp_92 = null; var v_px_93 = null; var v_py_94 = null; var v_lift_95 = null; var v_hk_98 = null; var v_wpn_102 = null; var v_drawArm_103 = null; var v_behind_104 = null; var v_wb_105 = null; var v_wBehind_106 = null; var v_b_107 = null
	var _s24 = {"__p": env, "ctx": null, "H": null, "c": null, "s": null, "arm": null, "W": null, "wp": null, "nr": null, "lx": null, "ly": null, "ath": null, "wth": null, "tipM": null}
	_s24["ctx"] = J.arg(a, 0)
	v_type_73 = J.arg(a, 1)
	v_x_74 = J.arg(a, 2)
	v_y_75 = J.arg(a, 3)
	_s24["H"] = J.arg(a, 4)
	v_o_77 = J.arg(a, 5)
	v_faceRight_78 = J.arg(a, 6)
	v_meshPose_79 = J.arg(a, 7)
	_s24["c"] = J.gp(J.cl(_s24["__p"]["C"], null, []), v_type_73)
	var _t29 = _s24["__p"]["stateOf"]
	_s24["s"] = J.cl(_t29, null, [v_type_73, J.gp(v_o_77, "pose"), J.gp(v_o_77, "pt")])
	v_body_82 = J.gp(J.G.get("SPR"), J.add(v_type_73, "__body"))
	_s24["arm"] = J.gp(J.G.get("SPR"), J.add(v_type_73, "__arm"))
	_s24["W"] = J.div(J.mul(_s24["H"], J.gp(v_body_82, "naturalWidth")), J.gp(v_body_82, "naturalHeight"))
	var _t30 = _s24["__p"]["weaponOf"]
	_s24["wp"] = J.cl(_t30, null, [v_type_73, J.gp(v_o_77, "weapon")])
	var _t31 = J.gp(_s24["__p"]["NATIVE_R"], v_type_73)
	_s24["nr"] = (not (not J.t((_t31 if J.t(_t31) else J.gp(_s24["c"], "nativeR")))))
	v_pvx_87 = (J.sub(1.0, J.gp(J.gp(_s24["c"], "pivot"), 0.0)) if J.t(_s24["nr"]) else J.gp(J.gp(_s24["c"], "pivot"), 0.0))
	var _t32 = (not J.seq(J.typeof_(J.G.get("MeshAnim")), "undefined"))
	v_R_88 = (J.gp(J.gp(J.G.get("MeshAnim"), "RIG"), v_type_73) if _t32 else _t32)
	var _t33 = J.seq(J.gp(v_o_77, "pose"), "windup")
	var _t34 = (_t33 if _t33 else J.seq(J.gp(v_o_77, "pose"), "strike"))
	var _t35 = (_t34 if _t34 else J.seq(J.gp(v_o_77, "pose"), "follow"))
	v_atk_89 = (_t35 if _t35 else J.seq(J.gp(v_o_77, "pose"), "recover"))
	var _t36 = (J.gp(v_R_88, "hop") if J.t(v_R_88) else v_R_88)
	var _t41 = ((not J.t(v_atk_89)) if J.t(_t36) else _t36)
	if J.t(_t41):
		var _t37 = J.gp(v_o_77, "walk")
		var _t38 = (_t37 if J.t(_t37) else J.gp(v_o_77, "enemy"))
		var _t39 = (_t38 if J.t(_t38) else J.seq(J.gp(v_o_77, "pose"), "move"))
		var _t40 = (_t39 if J.t(_t39) else J.seq(J.gp(v_o_77, "pose"), "walk"))
		_t41 = (_t40 if J.t(_t40) else J.seq(J.gp(v_o_77, "pose"), "run"))
	if J.t(_t41):
		var _t42 = J.sub(v_y_75, J.mul((absf(J.num(sin(J.num(J.mul(J.gp(v_o_77, "t"), 5.0))))) * 0.09), _s24["H"]))
		v_y_75 = _t42
	var _t43 = J.gp(v_o_77, "walk")
	var _t44 = (_t43 if J.t(_t43) else J.seq(J.gp(v_o_77, "pose"), "move"))
	var _t45 = (_t44 if J.t(_t44) else J.seq(J.gp(v_o_77, "pose"), "walk"))
	v_walking_90 = (_t45 if J.t(_t45) else J.seq(J.gp(v_o_77, "pose"), "run"))
	var _t46 = (not J.t(J.gp(_s24["c"], "weapon")))
	v_thAdd_91 = (J.mul(sin(J.num(J.mul(J.gp(v_o_77, "t"), 7.0))), (J.gp(_s24["c"], "swing") if (not J.leq(J.gp(_s24["c"], "swing"), null)) else 7.0)) if J.t((v_walking_90 if _t46 else _t46)) else 0.0)
	J.mc(_s24["ctx"], "save", [])
	J.mc(_s24["ctx"], "translate", [v_x_74, v_y_75])
	if J.t(v_faceRight_78):
		J.mc(_s24["ctx"], "scale", [(-1.0), 1.0])
	J.mc(_s24["ctx"], "translate", [J.mul((-J.num(J.gp(_s24["s"], "dx"))), _s24["W"]), J.mul(J.gp(_s24["s"], "dy"), _s24["H"])])
	J.mc(_s24["ctx"], "translate", [0.0, ((-J.num(_s24["H"])) * 0.28)])
	J.mc(_s24["ctx"], "rotate", [J.mul(J.gp(_s24["s"], "lean"), _s24["__p"]["D"])])
	J.mc(_s24["ctx"], "translate", [0.0, J.mul(_s24["H"], 0.28)])
	J.mc(_s24["ctx"], "scale", [J.gp(_s24["s"], "sx"), J.gp(_s24["s"], "sy")])
	v_mp_92 = J.S_Object_("assign", [{}, v_meshPose_79])
	J.sp(v_mp_92, "armF", 0.0)
	J.sp(v_mp_92, "axe", 0.0)
	J.sp(v_mp_92, "body", 0.0)
	J.sp(v_mp_92, "x", 0.0)
	if J.t(J.gp(_s24["c"], "still")):
		for _t47 in J.iter(J.gp(_s24["c"], "still")):
			v_b_107 = _t47
			J.sp(v_mp_92, v_b_107, 0.0)
	v_px_93 = J.mul(J.sub(v_pvx_87, 0.5), _s24["W"])
	var _t49 = ((-J.num(_s24["H"])) + J.mul(J.gp(J.gp(_s24["c"], "pivot"), 1.0), _s24["H"]))
	var _t48 = J.gp(v_mp_92, "y")
	v_py_94 = (_t49 + J.mul((_t48 if J.t(_t48) else 0.0), _s24["H"]))
	v_lift_95 = J.max_([0.0, J.min_([1.0, J.div(J.sub(J.gp(_s24["s"], "th"), 25.0), 40.0)])])
	_s24["lx"] = J.add(v_px_93, J.mul(J.add(J.mul(v_lift_95, J.gp(J.gp(_s24["c"], "lift"), 0.0)), J.gp(_s24["s"], "hx")), _s24["W"]))
	_s24["ly"] = J.sub(v_py_94, J.mul(J.add(J.mul(v_lift_95, J.gp(J.gp(_s24["c"], "lift"), 1.0)), J.gp(_s24["s"], "hy")), _s24["H"]))
	v_hk_98 = (J.gp(_s24["c"], "hk") if (not J.leq(J.gp(_s24["c"], "hk"), null)) else 1.0)
	_s24["ath"] = J.mul(J.add(J.gp(_s24["s"], "th"), v_thAdd_91), v_hk_98)
	_s24["wth"] = J.sub(J.add(J.gp(_s24["s"], "th"), v_thAdd_91), _s24["ath"])
	_s24["tipM"] = null
	v_wpn_102 = Callable(self, "_f16").bind(_s24)
	v_drawArm_103 = Callable(self, "_f17").bind(_s24)
	var _t55 = J.cmp(J.gp(_s24["s"], "th"), J.gp(_s24["c"], "behind"), ">")
	if not J.t(_t55):
		var _t54 = (not J.leq(J.gp(_s24["c"], "behindLo"), null))
		_t55 = (J.cmp(J.gp(_s24["s"], "th"), J.gp(_s24["c"], "behindLo"), "<") if _t54 else _t54)
	v_behind_104 = _t55
	v_wb_105 = J.gp(_s24["c"], "wbehind")
	var _t57 = null
	if J.t(v_wb_105):
		var _t56 = J.cmp(J.gp(_s24["s"], "th"), J.gp(v_wb_105, 0.0), ">")
		_t57 = (J.cmp(J.gp(_s24["s"], "th"), J.gp(v_wb_105, 1.0), "<") if _t56 else _t56)
	else:
		_t57 = v_behind_104
	v_wBehind_106 = _t57
	if J.t(v_wBehind_106):
		J.cl(v_wpn_102, null, [])
	if J.t(v_behind_104):
		J.cl(v_drawArm_103, null, [])
	if J.t(_s24["nr"]):
		J.mc(_s24["ctx"], "save", [])
		J.mc(_s24["ctx"], "scale", [(-1.0), 1.0])
	J.mc(J.G.get("MeshAnim"), "drawBody", [_s24["ctx"], v_type_73, J.add(v_type_73, "__body"), _s24["H"], v_mp_92])
	if J.t(_s24["nr"]):
		J.mc(_s24["ctx"], "restore", [])
	if (not J.t(v_wBehind_106)):
		J.cl(v_wpn_102, null, [])
	if (not J.t(v_behind_104)):
		J.cl(v_drawArm_103, null, [])
	J.mc(_s24["ctx"], "restore", [])
	return ({"x": J.gp(_s24["tipM"], "e"), "y": J.gp(_s24["tipM"], "f")} if J.t(_s24["tipM"]) else null)

func _f2(this_, a: Array, env):
	var v_t_16 = null
	v_t_16 = J.arg(a, 0)
	return (1.0 - (J.sub(1.0, v_t_16) * J.sub(1.0, v_t_16)))

func _f3(this_, a: Array, env):
	var v_t_17 = null
	v_t_17 = J.arg(a, 0)
	return J.mul(v_t_17, v_t_17)

func _f4(this_, a: Array, env):
	var v_t_18 = null
	v_t_18 = J.arg(a, 0)
	return (J.mul(J.mul(2.0, v_t_18), v_t_18) if J.cmp(v_t_18, 0.5, "<") else (1.0 - ((2.0 * J.sub(1.0, v_t_18)) * J.sub(1.0, v_t_18))))

func _f5(this_, a: Array, env):
	var v_t_19 = null
	v_t_19 = J.arg(a, 0)
	return (1.0 - pow(J.num(J.sub(1.0, v_t_19)), J.num(3.0)))

func _f6(this_, a: Array, env):
	var v_a_20 = null; var v_b_21 = null; var v_k_22 = null; var v_o_23 = null; var v_n_24 = null
	v_a_20 = J.arg(a, 0)
	v_b_21 = J.arg(a, 1)
	v_k_22 = J.arg(a, 2)
	v_o_23 = {}
	for _t58 in J.keys(v_a_20):
		v_n_24 = _t58
		var _t59 = J.add(J.gp(v_a_20, v_n_24), J.mul(J.sub(J.gp(v_b_21, v_n_24), J.gp(v_a_20, v_n_24)), v_k_22))
		J.sp(v_o_23, v_n_24, _t59)
	return v_o_23

func _f7(this_, a: Array, env):
	return (J.gp(J.G.get("LIMBS_DATA"), "chars") if (not J.seq(J.typeof_(J.G.get("LIMBS_DATA")), "undefined")) else {})

func _f8(this_, a: Array, env):
	var v_k_25 = null
	v_k_25 = J.arg(a, 0)
	var _t61 = J.seq(J.typeof_(J.G.get("sprOk")), "function")
	if J.t(_t61):
		var _t60 = J.G.get("sprOk")
		_t61 = J.cl(_t60, null, [v_k_25])
	return _t61

func _f1(this_, a: Array, env):
	var v_has_8 = null; var v_draw_15 = null
	var _s2 = {"__p": env, "D": null, "ez": null, "lerp": null, "DEFK": null, "C": null, "ok": null, "KN": null, "keysOf": null, "stateOf": null, "weaponOf": null, "drawWeapon": null, "NATIVE_R": null}
	v_has_8 = Callable(self, "_f9").bind(_s2)
	_s2["keysOf"] = Callable(self, "_f10").bind(_s2)
	_s2["stateOf"] = Callable(self, "_f11").bind(_s2)
	_s2["weaponOf"] = Callable(self, "_f12").bind(_s2)
	_s2["drawWeapon"] = Callable(self, "_f13").bind(_s2)
	v_draw_15 = Callable(self, "_f15").bind(_s2)
	_s2["D"] = J.div(PI, 180.0)
	_s2["ez"] = {"o": Callable(self, "_f2").bind(_s2), "i": Callable(self, "_f3").bind(_s2), "io": Callable(self, "_f4").bind(_s2), "o3": Callable(self, "_f5").bind(_s2)}
	_s2["lerp"] = Callable(self, "_f6").bind(_s2)
	_s2["DEFK"] = {"idle": {"th": 0.0, "lean": 0.0, "dx": 0.0, "dy": 0.0, "sx": 1.0, "sy": 1.0}, "antic": {"th": 60.0, "lean": 8.0, "dx": (-0.04), "dy": (-0.02), "sx": 0.96, "sy": 1.05}, "contact": {"th": (-70.0), "lean": (-10.0), "dx": 0.11, "dy": 0.0, "sx": 1.06, "sy": 0.96}, "follow": {"th": (-120.0), "lean": (-18.0), "dx": 0.14, "dy": 0.02, "sx": 1.04, "sy": 0.95}}
	_s2["C"] = Callable(self, "_f7").bind(_s2)
	_s2["ok"] = Callable(self, "_f8").bind(_s2)
	_s2["KN"] = {}
	var _t62 = (not J.seq(J.typeof_(J.G.get("MeshAnim")), "undefined"))
	var _t63 = (J.gp(J.G.get("MeshAnim"), "NATIVE_R") if _t62 else _t62)
	_s2["NATIVE_R"] = (_t63 if J.t(_t63) else {"egui": 1.0, "xiaogui": 1.0, "shuigui": 1.0, "toyol": 1.0})
	return {"has": v_has_8, "draw": v_draw_15, "stateOf": _s2["stateOf"], "weaponOf": _s2["weaponOf"]}
