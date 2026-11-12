# 自動轉譯自 scene.js（tools/jsgd.js）——唔好直接改，改原 JS 再轉
extends RefCounted

func run(env):
	var this_ = null; var a = []
	J.G["SCENE"] = J.cl(Callable(self, "_f1").bind(env), null, [])

func _f3(this_, a: Array, env):
	var v_ctx_23 = null; var v_im_24 = null; var v_x_25 = null; var v_y_26 = null; var v_w_27 = null; var v_h_28 = null
	v_ctx_23 = J.arg(a, 0)
	v_im_24 = J.arg(a, 1)
	v_x_25 = J.arg(a, 2)
	v_y_26 = J.arg(a, 3)
	v_w_27 = J.arg(a, 4)
	v_h_28 = J.arg(a, 5)
	if (not J.t(v_h_28)):
		var _t1 = J.div(J.mul(v_w_27, J.gp(v_im_24, "naturalHeight")), J.gp(v_im_24, "naturalWidth"))
		v_h_28 = _t1
	if (not J.t(v_w_27)):
		var _t2 = J.div(J.mul(v_h_28, J.gp(v_im_24, "naturalWidth")), J.gp(v_im_24, "naturalHeight"))
		v_w_27 = _t2
	J.mc(v_ctx_23, "drawImage", [v_im_24, J.sub(v_x_25, J.div(v_w_27, 2.0)), J.sub(v_y_26, v_h_28), v_w_27, v_h_28])
	return {"x": J.sub(v_x_25, J.div(v_w_27, 2.0)), "y": J.sub(v_y_26, v_h_28), "w": v_w_27, "h": v_h_28}

func _f4(this_, a: Array, env):
	var v_ctx_31 = null; var v_x_32 = null; var v_y_33 = null; var v_lv_34 = null
	v_ctx_31 = J.arg(a, 0)
	v_x_32 = J.arg(a, 1)
	v_y_33 = J.arg(a, 2)
	v_lv_34 = J.arg(a, 3)
	J.mc(v_ctx_31, "save", [])
	J.mc(v_ctx_31, "translate", [v_x_32, v_y_33])
	J.mc(v_ctx_31, "rotate", [0.12])
	J.mc(J.G.get("ART"), "rr", [v_ctx_31, (-1.0), (-8.0), 22.0, 16.0, 2.0, "#c2362b", "#f0c8b4", 1.0])
	J.sp(v_ctx_31, "fillStyle", "#fff3e0")
	J.sp(v_ctx_31, "font", "900 10px sans-serif")
	J.sp(v_ctx_31, "textAlign", "center")
	J.sp(v_ctx_31, "textBaseline", "middle")
	J.mc(v_ctx_31, "fillText", [v_lv_34, 10.0, 0.5])
	J.mc(v_ctx_31, "restore", [])

func _f5(this_, a: Array, env):
	var v_ctx_37 = null; var v_r_38 = null; var v_p_39 = null; var v_text_40 = null; var v_lv_41 = null; var v_cx_42 = null; var v_cy_43 = null; var v_pw_44 = null; var v_fs_45 = null
	v_ctx_37 = J.arg(a, 0)
	v_r_38 = J.arg(a, 1)
	v_p_39 = J.arg(a, 2)
	v_text_40 = J.arg(a, 3)
	v_lv_41 = J.arg(a, 4)
	v_cx_42 = J.add(J.gp(v_r_38, "x"), J.mul(J.gp(v_r_38, "w"), J.gp(v_p_39, 0.0)))
	v_cy_43 = J.add(J.gp(v_r_38, "y"), J.mul(J.gp(v_r_38, "h"), J.gp(v_p_39, 1.0)))
	v_pw_44 = J.mul(J.gp(v_r_38, "w"), J.gp(v_p_39, 2.0))
	v_fs_45 = J.min_([15.0, J.div(v_pw_44, (J.len(v_text_40) * 1.08))])
	var _t3 = J.max_([7.0, v_fs_45])
	v_fs_45 = _t3
	J.mc(v_ctx_37, "save", [])
	var _t4 = ("900 " + J.str(v_fs_45) + "px " + J.str(env["SERIF"]))
	J.sp(v_ctx_37, "font", _t4)
	J.sp(v_ctx_37, "textAlign", "center")
	J.sp(v_ctx_37, "textBaseline", "middle")
	var _t5 = J.max_([2.0, J.mul(v_fs_45, 0.28)])
	J.sp(v_ctx_37, "lineWidth", _t5)
	J.sp(v_ctx_37, "strokeStyle", "rgba(40,20,8,.95)")
	J.sp(v_ctx_37, "lineJoin", "round")
	J.mc(v_ctx_37, "strokeText", [v_text_40, v_cx_42, J.add(v_cy_43, 0.5)])
	J.sp(v_ctx_37, "fillStyle", "#f6d58a")
	J.mc(v_ctx_37, "fillText", [v_text_40, v_cx_42, J.add(v_cy_43, 0.5)])
	J.mc(v_ctx_37, "restore", [])
	if J.t(v_lv_41):
		var _t6 = env["lvBadge"]
		J.cl(_t6, null, [v_ctx_37, J.sub(J.add(v_cx_42, J.div(v_pw_44, 2.0)), 2.0), J.sub(v_cy_43, 9.0), v_lv_41])

func _f6(this_, a: Array, env):
	var v_ctx_48 = null; var v_x_49 = null; var v_y_50 = null; var v_text_51 = null; var v_lv_52 = null; var v_w_53 = null
	v_ctx_48 = J.arg(a, 0)
	v_x_49 = J.arg(a, 1)
	v_y_50 = J.arg(a, 2)
	v_text_51 = J.arg(a, 3)
	v_lv_52 = J.arg(a, 4)
	J.mc(v_ctx_48, "save", [])
	var _t7 = ("900 11.5px " + J.str(env["SERIF"]))
	J.sp(v_ctx_48, "font", _t7)
	v_w_53 = J.add(J.gp(J.mc(v_ctx_48, "measureText", [v_text_51]), "width"), 14.0)
	J.mc(J.G.get("ART"), "rr", [v_ctx_48, J.sub(v_x_49, 1.5), J.sub(v_y_50, 6.0), 3.0, 10.0, 1.0, "#4a3020"])
	J.mc(J.G.get("ART"), "rr", [v_ctx_48, J.sub(v_x_49, J.div(v_w_53, 2.0)), J.sub(v_y_50, 21.0), v_w_53, 16.0, 2.0, "#7a5634", "#2a1a0e", 1.4])
	J.sp(v_ctx_48, "fillStyle", "rgba(255,230,180,.15)")
	J.mc(v_ctx_48, "fillRect", [(J.sub(v_x_49, J.div(v_w_53, 2.0)) + 2.0), J.sub(v_y_50, 19.0), J.sub(v_w_53, 4.0), 2.0])
	J.sp(v_ctx_48, "fillStyle", "#f6e2b0")
	J.sp(v_ctx_48, "textAlign", "center")
	J.sp(v_ctx_48, "textBaseline", "middle")
	J.mc(v_ctx_48, "fillText", [v_text_51, v_x_49, J.sub(v_y_50, 12.5)])
	J.mc(v_ctx_48, "restore", [])
	if J.t(v_lv_52):
		var _t8 = env["lvBadge"]
		J.cl(_t8, null, [v_ctx_48, J.sub(J.add(v_x_49, J.div(v_w_53, 2.0)), 1.0), J.sub(v_y_50, 23.0), v_lv_52])

func _f14(this_, a: Array, env):
	var v_ctx_137 = null; var v_w_138 = null; var v_h_139 = null; var v_bg_140 = null; var v_im_141 = null; var v_s_142 = null; var v_iw_143 = null; var v_ih_144 = null; var v_v_145 = null
	v_ctx_137 = J.arg(a, 0)
	v_w_138 = J.arg(a, 1)
	v_h_139 = J.arg(a, 2)
	v_bg_140 = J.arg(a, 3)
	var _t9 = env["img"]
	v_im_141 = J.cl(_t9, null, [J.add("bg_", v_bg_140)])
	if (not J.t(v_im_141)):
		return false
	v_s_142 = J.max_([J.div(v_w_138, J.gp(v_im_141, "naturalWidth")), J.div(v_h_139, J.gp(v_im_141, "naturalHeight"))])
	v_iw_143 = J.mul(J.gp(v_im_141, "naturalWidth"), v_s_142)
	v_ih_144 = J.mul(J.gp(v_im_141, "naturalHeight"), v_s_142)
	J.mc(v_ctx_137, "drawImage", [v_im_141, J.div(J.sub(v_w_138, v_iw_143), 2.0), J.div(J.sub(v_h_139, v_ih_144), 2.0), v_iw_143, v_ih_144])
	v_v_145 = J.mc(v_ctx_137, "createLinearGradient", [0.0, 0.0, 0.0, v_h_139])
	J.mc(v_v_145, "addColorStop", [0.0, "rgba(10,8,14,.18)"])
	J.mc(v_v_145, "addColorStop", [0.5, "rgba(10,8,14,0)"])
	J.mc(v_v_145, "addColorStop", [1.0, "rgba(10,8,14,.32)"])
	J.sp(v_ctx_137, "fillStyle", v_v_145)
	J.mc(v_ctx_137, "fillRect", [0.0, 0.0, v_w_138, v_h_139])
	return true

func _f2(this_, a: Array, env):
	var v_n_19 = null; var v_s_20 = null
	v_n_19 = J.arg(a, 0)
	var _t10 = (not J.seq(J.typeof_(J.G.get("SPR")), "undefined"))
	v_s_20 = (J.gp(J.G.get("SPR"), v_n_19) if _t10 else _t10)
	var _t11 = (J.gp(v_s_20, "complete") if J.t(v_s_20) else v_s_20)
	return (v_s_20 if J.t((J.gp(v_s_20, "naturalWidth") if J.t(_t11) else _t11)) else null)

func _f7(this_, a: Array, env):
	var v_ctx_56 = null; var v_id_57 = null; var v_x_58 = null; var v_y_59 = null; var v_lv_60 = null; var v_t_61 = null; var v_extra_62 = null; var v_im_63 = null; var v_r_64 = null; var v_name_65 = null; var v_fx_66 = null; var v_fy_67 = null; var v_a_68 = null; var v_g_69 = null
	v_ctx_56 = J.arg(a, 0)
	v_id_57 = J.arg(a, 1)
	v_x_58 = J.arg(a, 2)
	v_y_59 = J.arg(a, 3)
	v_lv_60 = J.arg(a, 4)
	v_t_61 = J.arg(a, 5)
	v_extra_62 = J.arg(a, 6)
	var _t13 = env["img"]
	v_im_63 = J.cl(_t13, null, [v_id_57])
	if (not J.t(v_im_63)):
		var _t14 = env["origBuilding"]
		return J.cl(_t14, null, [v_ctx_56, v_id_57, v_x_58, v_y_59, v_lv_60, v_t_61, v_extra_62])
	J.mc(J.G.get("ART"), "el", [v_ctx_56, v_x_58, J.add(v_y_59, 1.0), J.mul(J.gp(env["BW"], v_id_57), 0.44), 7.0, "rgba(0,0,0,.28)"])
	var _t15 = env["put"]
	v_r_64 = J.cl(_t15, null, [v_ctx_56, v_im_63, v_x_58, J.add(v_y_59, 6.0), J.gp(env["BW"], v_id_57)])
	v_name_65 = J.gp(J.gp(J.G.get("BUILDINGS"), v_id_57), "name")
	if J.t(J.gp(env["PLAQUE"], v_id_57)):
		var _t16 = env["plaqueText"]
		J.cl(_t16, null, [v_ctx_56, v_r_64, J.gp(env["PLAQUE"], v_id_57), v_name_65, v_lv_60])
	else:
		var _t17 = env["signBoard"]
		J.cl(_t17, null, [v_ctx_56, J.add(v_x_58, (0.0 if J.seq(v_id_57, "furnace") else J.mul(J.gp(env["BW"], v_id_57), 0.3))), J.add(v_y_59, 12.0), v_name_65, v_lv_60])
	var _t18 = J.seq(v_id_57, "furnace")
	if J.t((v_extra_62 if _t18 else _t18)):
		v_fx_66 = J.add(J.gp(v_r_64, "x"), J.mul(J.gp(v_r_64, "w"), 0.5))
		v_fy_67 = J.add(J.gp(v_r_64, "y"), J.mul(J.gp(v_r_64, "h"), 0.62))
		v_a_68 = (0.35 + (sin(J.num(J.mul(v_t_61, 7.0))) * 0.12))
		v_g_69 = J.mc(v_ctx_56, "createRadialGradient", [v_fx_66, v_fy_67, 2.0, v_fx_66, v_fy_67, 30.0])
		J.mc(v_g_69, "addColorStop", [0.0, ("rgba(255,170,60," + J.str(v_a_68) + ")")])
		J.mc(v_g_69, "addColorStop", [1.0, "rgba(255,170,60,0)"])
		J.sp(v_ctx_56, "fillStyle", v_g_69)
		J.mc(v_ctx_56, "fillRect", [J.sub(v_fx_66, 30.0), J.sub(v_fy_67, 30.0), 60.0, 60.0])

func _f8(this_, a: Array, env):
	var v_ctx_72 = null; var v_x_73 = null; var v_y_74 = null; var v_t_75 = null; var v_im_76 = null; var v_r_77 = null
	v_ctx_72 = J.arg(a, 0)
	v_x_73 = J.arg(a, 1)
	v_y_74 = J.arg(a, 2)
	v_t_75 = J.arg(a, 3)
	var _t21 = env["img"]
	v_im_76 = J.cl(_t21, null, ["gate"])
	if (not J.t(v_im_76)):
		var _t22 = env["origGate"]
		return J.cl(_t22, null, [v_ctx_72, v_x_73, v_y_74, v_t_75])
	var _t23 = env["put"]
	v_r_77 = J.cl(_t23, null, [v_ctx_72, v_im_76, v_x_73, J.add(v_y_74, 6.0), J.gp(env["BW"], "gate")])
	var _t24 = env["plaqueText"]
	J.cl(_t24, null, [v_ctx_72, v_r_77, J.gp(env["PLAQUE"], "gate"), "出村", 0.0])
	if (not J.seq(J.typeof_(J.G.get("Guide")), "undefined")):
		J.mc(J.G.get("Guide"), "drawGateDot", [v_ctx_72, J.add(J.gp(v_r_77, "x"), J.mul(J.gp(v_r_77, "w"), 0.78)), J.add(J.gp(v_r_77, "y"), J.mul(J.gp(v_r_77, "h"), 0.52)), v_t_75])

func _f10(this_, a: Array, env):
	var v_fx_97 = null; var v_fy_98 = null; var v_d_99 = null; var v_cx_100 = null; var v_cy_101 = null
	var _t36 = J.gp(J.arg(a, 0), 0.0)
	v_fx_97 = _t36
	var _t37 = J.gp(J.arg(a, 0), 1.0)
	v_fy_98 = _t37
	var _t38 = J.gp(J.arg(a, 0), 2.0)
	v_d_99 = _t38
	v_cx_100 = J.add(J.add(env["__p"]["x"], (J.mul(J.gp(env["__p"]["r"], "w"), v_fx_97) * ((-1.0) if J.t(env["__p"]["flip"]) else 1.0))), env["__p"]["sx"])
	v_cy_101 = J.add(J.gp(env["__p"]["r"], "y"), J.mul(J.gp(env["__p"]["r"], "h"), v_fy_98))
	J.mc(env["__p"]["ctx"], "save", [])
	J.mc(env["__p"]["ctx"], "translate", [v_cx_100, v_cy_101])
	J.mc(env["__p"]["ctx"], "scale", [J.mul(v_d_99, ((-1.0) if J.t(env["__p"]["flip"]) else 1.0)), 1.0])
	var _t39 = env["__p"]["__p"]["put"]
	J.cl(_t39, null, [env["__p"]["ctx"], env["cs"], 0.0, 0.0, 13.0])
	J.mc(env["__p"]["ctx"], "restore", [])

func _f9(this_, a: Array, env):
	var v_y_82 = null; var v_hp_83 = null; var v_t_84 = null; var v_shake_85 = null; var v_perched_86 = null; var v_idx_87 = null; var v_bare_88 = null; var v_full_89 = null; var v_H_91 = null; var v_tree_92 = null; var v_st_95 = null
	var _s11 = {"__p": env, "ctx": null, "x": null, "sx": null, "flip": null, "r": null}
	_s11["ctx"] = J.arg(a, 0)
	_s11["x"] = J.arg(a, 1)
	v_y_82 = J.arg(a, 2)
	v_hp_83 = J.arg(a, 3)
	v_t_84 = J.arg(a, 4)
	v_shake_85 = J.arg(a, 5)
	v_perched_86 = J.arg(a, 6)
	v_idx_87 = J.arg(a, 7)
	if J.cmp(v_hp_83, 0.0, "<="):
		var _t27 = _s11["__p"]["img"]
		v_st_95 = J.cl(_t27, null, ["stump"])
		if (not J.t(v_st_95)):
			var _t28 = _s11["__p"]["origTree"]
			return J.cl(_t28, null, [_s11["ctx"], _s11["x"], v_y_82, v_hp_83, v_t_84, v_shake_85, v_perched_86, v_idx_87])
		var _t29 = _s11["__p"]["put"]
		J.cl(_t29, null, [_s11["ctx"], v_st_95, _s11["x"], J.add(v_y_82, 3.0), 38.0])
		return null
	var _t30 = _s11["__p"]["img"]
	v_bare_88 = J.cl(_t30, null, ["tree_bare"])
	var _t31 = _s11["__p"]["img"]
	v_full_89 = J.cl(_t31, null, ["tree"])
	var _t32 = (not J.t(v_full_89))
	if ((not J.t(v_bare_88)) if _t32 else _t32):
		var _t33 = _s11["__p"]["origTree"]
		return J.cl(_t33, null, [_s11["ctx"], _s11["x"], v_y_82, v_hp_83, v_t_84, v_shake_85, v_perched_86, v_idx_87])
	_s11["sx"] = ((sin(J.num(J.mul(v_t_84, 60.0))) * 2.2) if J.t(v_shake_85) else 0.0)
	v_H_91 = (80.0 + (J.mod((v_idx_87 if J.t(v_idx_87) else 0.0), 3.0) * 4.0))
	J.mc(J.G.get("ART"), "el", [_s11["ctx"], _s11["x"], J.add(v_y_82, 2.0), 20.0, 5.0, "rgba(0,0,0,.35)"])
	J.mc(_s11["ctx"], "save", [])
	if J.t(v_shake_85):
		J.mc(_s11["ctx"], "translate", [_s11["x"], v_y_82])
		J.mc(_s11["ctx"], "rotate", [(sin(J.num(J.mul(v_t_84, 60.0))) * 0.02)])
		J.mc(_s11["ctx"], "translate", [(-J.num(_s11["x"])), (-J.num(v_y_82))])
	v_tree_92 = (v_bare_88 if J.t(v_bare_88) else v_full_89)
	_s11["flip"] = J.seq(J.mod((v_idx_87 if J.t(v_idx_87) else 0.0), 2.0), 1.0)
	if J.t(_s11["flip"]):
		J.mc(_s11["ctx"], "translate", [_s11["x"], 0.0])
		J.mc(_s11["ctx"], "scale", [(-1.0), 1.0])
		J.mc(_s11["ctx"], "translate", [(-J.num(_s11["x"])), 0.0])
	var _t34 = _s11["__p"]["put"]
	_s11["r"] = J.cl(_t34, null, [_s11["ctx"], v_tree_92, J.add(_s11["x"], _s11["sx"]), J.add(v_y_82, 4.0), 0.0, v_H_91])
	J.mc(_s11["ctx"], "restore", [])
	if J.t((v_perched_86 if J.t(v_bare_88) else v_bare_88)):
		var _s15 = {"__p": _s11, "cs": null}
		var _t35 = _s15["__p"]["__p"]["img"]
		_s15["cs"] = J.cl(_t35, null, ["crowsit"])
		if J.t(_s15["cs"]):
			J.mc(_s15["__p"]["__p"]["PERCH"], "forEach", [Callable(self, "_f10").bind(_s15)])

func _f11(this_, a: Array, env):
	var v_ctx_104 = null; var v_x_105 = null; var v_y_106 = null; var v_ripe_107 = null; var v_t_108 = null; var v_i_109 = null; var v_ripeIm_110 = null; var v_cut_111 = null
	v_ctx_104 = J.arg(a, 0)
	v_x_105 = J.arg(a, 1)
	v_y_106 = J.arg(a, 2)
	v_ripe_107 = J.arg(a, 3)
	v_t_108 = J.arg(a, 4)
	v_i_109 = J.arg(a, 5)
	var _t42 = env["img"]
	v_ripeIm_110 = J.cl(_t42, null, ["paddy"])
	var _t43 = env["img"]
	v_cut_111 = J.cl(_t43, null, ["paddy_cut"])
	if (not J.t(v_ripeIm_110)):
		var _t44 = env["origPaddy"]
		return J.cl(_t44, null, [v_ctx_104, v_x_105, v_y_106, v_ripe_107, v_t_108, v_i_109])
	if J.t(v_ripe_107):
		var _t45 = env["put"]
		J.cl(_t45, null, [v_ctx_104, v_ripeIm_110, v_x_105, J.add(v_y_106, 9.0), 56.0])
		return null
	if J.t(v_cut_111):
		var _t46 = env["put"]
		J.cl(_t46, null, [v_ctx_104, v_cut_111, v_x_105, J.add(v_y_106, 9.0), 56.0])
		return null
	J.mc(v_ctx_104, "save", [])
	J.sp(v_ctx_104, "globalAlpha", 0.55)
	J.sp(v_ctx_104, "filter", "brightness(.55) saturate(.4)")
	var _t47 = env["put"]
	J.cl(_t47, null, [v_ctx_104, v_ripeIm_110, v_x_105, J.add(v_y_106, 9.0), 56.0, 34.0])
	J.mc(v_ctx_104, "restore", [])

func _f12(this_, a: Array, env):
	var v_ctx_114 = null; var v_kind_115 = null; var v_x_116 = null; var v_y_117 = null; var v_t_118 = null; var v_d_119 = null; var v_im_120 = null; var v_a_121 = null; var v_g_122 = null
	v_ctx_114 = J.arg(a, 0)
	v_kind_115 = J.arg(a, 1)
	v_x_116 = J.arg(a, 2)
	v_y_117 = J.arg(a, 3)
	v_t_118 = J.arg(a, 4)
	v_d_119 = J.gp(env["DECO"], v_kind_115)
	var _t51 = v_d_119
	if J.t(_t51):
		var _t50 = env["img"]
		_t51 = J.cl(_t50, null, [J.gp(v_d_119, 0.0)])
	v_im_120 = _t51
	if (not J.t(v_im_120)):
		var _t52 = env["origDecor"]
		return J.cl(_t52, null, [v_ctx_114, v_kind_115, v_x_116, v_y_117, v_t_118])
	if J.seq(v_kind_115, "banana"):
		J.mc(v_ctx_114, "save", [])
		J.mc(v_ctx_114, "translate", [v_x_116, v_y_117])
		J.mc(v_ctx_114, "rotate", [(sin(J.num(J.add(J.mul(v_t_118, 0.8), v_x_116))) * 0.02)])
		var _t53 = env["put"]
		J.cl(_t53, null, [v_ctx_114, v_im_120, 0.0, 2.0, J.gp(v_d_119, 1.0), J.gp(v_d_119, 2.0)])
		J.mc(v_ctx_114, "restore", [])
		return null
	if J.seq(v_kind_115, "scarecrow"):
		J.mc(v_ctx_114, "save", [])
		J.mc(v_ctx_114, "translate", [v_x_116, v_y_117])
		J.mc(v_ctx_114, "rotate", [(sin(J.num(J.mul(v_t_118, 0.9))) * 0.03)])
		var _t54 = env["put"]
		J.cl(_t54, null, [v_ctx_114, v_im_120, 0.0, 4.0, J.gp(v_d_119, 1.0), J.gp(v_d_119, 2.0)])
		J.mc(v_ctx_114, "restore", [])
		return null
	var _t55 = env["put"]
	J.cl(_t55, null, [v_ctx_114, v_im_120, v_x_116, J.add(v_y_117, 3.0), J.gp(v_d_119, 1.0), J.gp(v_d_119, 2.0)])
	if J.seq(v_kind_115, "post"):
		v_a_121 = (0.22 + (sin(J.num(J.add(J.mul(v_t_118, 2.0), v_x_116))) * 0.06))
		v_g_122 = J.mc(v_ctx_114, "createRadialGradient", [J.add(v_x_116, 6.0), J.sub(v_y_117, 30.0), 1.0, J.add(v_x_116, 6.0), J.sub(v_y_117, 30.0), 18.0])
		J.mc(v_g_122, "addColorStop", [0.0, ("rgba(255,236,190," + J.str(v_a_121) + ")")])
		J.mc(v_g_122, "addColorStop", [1.0, "rgba(255,236,190,0)"])
		J.sp(v_ctx_114, "fillStyle", v_g_122)
		J.mc(v_ctx_114, "fillRect", [J.sub(v_x_116, 14.0), J.sub(v_y_117, 50.0), 40.0, 40.0])

func _f13(this_, a: Array, env):
	var v_ctx_125 = null; var v_x_126 = null; var v_y_127 = null; var v_s_128 = null; var v_ph_129 = null; var v_dir_130 = null; var v_perched_131 = null; var v_im_132 = null; var v_w_133 = null; var v_h_134 = null
	v_ctx_125 = J.arg(a, 0)
	v_x_126 = J.arg(a, 1)
	v_y_127 = J.arg(a, 2)
	v_s_128 = J.arg(a, 3)
	v_ph_129 = J.arg(a, 4)
	v_dir_130 = J.arg(a, 5)
	v_perched_131 = J.arg(a, 6)
	var _t58 = env["img"]
	v_im_132 = J.cl(_t58, null, [("crowsit" if J.t(v_perched_131) else "crowfly")])
	if (not J.t(v_im_132)):
		var _t59 = env["origCrow"]
		return J.cl(_t59, null, [v_ctx_125, v_x_126, v_y_127, v_s_128, v_ph_129, v_dir_130, v_perched_131])
	J.mc(v_ctx_125, "save", [])
	J.mc(v_ctx_125, "translate", [v_x_126, v_y_127])
	J.mc(v_ctx_125, "scale", [((-1.0) if J.cmp(v_dir_130, 0.0, "<") else 1.0), (1.0 if J.t(v_perched_131) else (0.55 + (absf(J.num(sin(J.num(v_ph_129)))) * 0.55)))])
	v_w_133 = J.mul((12.0 if J.t(v_perched_131) else 20.0), v_s_128)
	v_h_134 = J.div(J.mul(v_w_133, J.gp(v_im_132, "naturalHeight")), J.gp(v_im_132, "naturalWidth"))
	J.mc(v_ctx_125, "drawImage", [v_im_132, J.div((-J.num(v_w_133)), 2.0), J.div((-J.num(v_h_134)), 2.0), v_w_133, v_h_134])
	J.mc(v_ctx_125, "restore", [])

func _f1(this_, a: Array, env):
	var v_drawBg_18 = null
	var _s2 = {"__p": env, "img": null, "put": null, "SERIF": null, "BW": null, "PLAQUE": null, "lvBadge": null, "plaqueText": null, "signBoard": null, "origBuilding": null, "origTree": null, "origPaddy": null, "origGate": null, "origDecor": null, "origCrow": null, "PERCH": null, "DECO": null}
	_s2["put"] = Callable(self, "_f3").bind(_s2)
	_s2["lvBadge"] = Callable(self, "_f4").bind(_s2)
	_s2["plaqueText"] = Callable(self, "_f5").bind(_s2)
	_s2["signBoard"] = Callable(self, "_f6").bind(_s2)
	v_drawBg_18 = Callable(self, "_f14").bind(_s2)
	_s2["img"] = Callable(self, "_f2").bind(_s2)
	_s2["SERIF"] = "\"Songti TC\",\"Noto Serif CJK TC\",\"Noto Serif TC\",\"STSong\",serif"
	_s2["BW"] = {"house": 150.0, "gate": 124.0, "plank": 106.0, "bun": 106.0, "wood": 108.0, "rice": 108.0, "store": 112.0, "home": 104.0, "camp": 108.0, "altar": 104.0, "furnace": 62.0}
	_s2["PLAQUE"] = {"house": [0.47, 0.49, 0.24], "gate": [0.5, 0.36, 0.3], "plank": [0.44, 0.36, 0.32], "store": [0.48, 0.43, 0.33], "wood": [0.4, 0.36, 0.26]}
	_s2["origBuilding"] = J.gp(J.G.get("ART"), "drawBuilding")
	_s2["origTree"] = J.gp(J.G.get("ART"), "drawTree")
	_s2["origPaddy"] = J.gp(J.G.get("ART"), "drawPaddy")
	_s2["origGate"] = J.gp(J.G.get("ART"), "drawGate")
	_s2["origDecor"] = J.gp(J.G.get("ART"), "drawDecor")
	_s2["origCrow"] = J.gp(J.G.get("ART"), "drawCrow")
	var _t12 = J.G.get("ART")
	var _t19 = Callable(self, "_f7").bind(_s2)
	J.sp(_t12, "drawBuilding", _t19)
	var _t20 = J.G.get("ART")
	var _t25 = Callable(self, "_f8").bind(_s2)
	J.sp(_t20, "drawGate", _t25)
	_s2["PERCH"] = [[(-0.22), 0.4, 1.0], [0.24, 0.3, (-1.0)]]
	var _t26 = J.G.get("ART")
	var _t40 = Callable(self, "_f9").bind(_s2)
	J.sp(_t26, "drawTree", _t40)
	var _t41 = J.G.get("ART")
	var _t48 = Callable(self, "_f11").bind(_s2)
	J.sp(_t41, "drawPaddy", _t48)
	_s2["DECO"] = {"scarecrow": ["scarecrow", 0.0, 62.0], "grave": ["grave", 26.0, 0.0], "post": ["lamppost", 0.0, 46.0], "banana": ["banana", 0.0, 64.0]}
	var _t49 = J.G.get("ART")
	var _t56 = Callable(self, "_f12").bind(_s2)
	J.sp(_t49, "drawDecor", _t56)
	var _t57 = J.G.get("ART")
	var _t60 = Callable(self, "_f13").bind(_s2)
	J.sp(_t57, "drawCrow", _t60)
	return {"drawBg": v_drawBg_18, "img": _s2["img"]}
