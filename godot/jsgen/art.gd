# 自動轉譯自 art.js（tools/jsgd.js）——唔好直接改，改原 JS 再轉
extends RefCounted

func run(env):
	var this_ = null; var a = []
	J.G["ART"] = J.cl(Callable(self, "_f1").bind(env), null, [])

func _f2(this_, a: Array, env):
	var v_ctx_56 = null; var v_x_57 = null; var v_y_58 = null; var v_rx_59 = null; var v_ry_60 = null; var v_fill_61 = null; var v_stroke_62 = null; var v_lw_63 = null
	v_ctx_56 = J.arg(a, 0)
	v_x_57 = J.arg(a, 1)
	v_y_58 = J.arg(a, 2)
	v_rx_59 = J.arg(a, 3)
	v_ry_60 = J.arg(a, 4)
	v_fill_61 = J.arg(a, 5)
	v_stroke_62 = J.arg(a, 6)
	v_lw_63 = J.arg(a, 7)
	J.mc(v_ctx_56, "beginPath", [])
	J.mc(v_ctx_56, "ellipse", [v_x_57, v_y_58, J.max_([0.1, v_rx_59]), J.max_([0.1, v_ry_60]), 0.0, 0.0, env["TAU"]])
	if J.t(v_fill_61):
		J.sp(v_ctx_56, "fillStyle", v_fill_61)
		J.mc(v_ctx_56, "fill", [])
	if J.t(v_stroke_62):
		var _t1 = (v_lw_63 if J.t(v_lw_63) else 1.5)
		J.sp(v_ctx_56, "lineWidth", _t1)
		J.sp(v_ctx_56, "strokeStyle", v_stroke_62)
		J.mc(v_ctx_56, "stroke", [])

func _f3(this_, a: Array, env):
	var v_ctx_66 = null; var v_x_67 = null; var v_y_68 = null; var v_w_69 = null; var v_h_70 = null; var v_r_71 = null; var v_fill_72 = null; var v_stroke_73 = null; var v_lw_74 = null
	v_ctx_66 = J.arg(a, 0)
	v_x_67 = J.arg(a, 1)
	v_y_68 = J.arg(a, 2)
	v_w_69 = J.arg(a, 3)
	v_h_70 = J.arg(a, 4)
	v_r_71 = J.arg(a, 5)
	v_fill_72 = J.arg(a, 6)
	v_stroke_73 = J.arg(a, 7)
	v_lw_74 = J.arg(a, 8)
	J.mc(v_ctx_66, "beginPath", [])
	J.mc(v_ctx_66, "roundRect", [v_x_67, v_y_68, v_w_69, v_h_70, v_r_71])
	if J.t(v_fill_72):
		J.sp(v_ctx_66, "fillStyle", v_fill_72)
		J.mc(v_ctx_66, "fill", [])
	if J.t(v_stroke_73):
		var _t2 = (v_lw_74 if J.t(v_lw_74) else 1.5)
		J.sp(v_ctx_66, "lineWidth", _t2)
		J.sp(v_ctx_66, "strokeStyle", v_stroke_73)
		J.mc(v_ctx_66, "stroke", [])

func _f4(this_, a: Array, env):
	var v_ctx_77 = null; var v_pts_78 = null; var v_fill_79 = null; var v_stroke_80 = null; var v_lw_81 = null; var v_i_82 = null
	v_ctx_77 = J.arg(a, 0)
	v_pts_78 = J.arg(a, 1)
	v_fill_79 = J.arg(a, 2)
	v_stroke_80 = J.arg(a, 3)
	v_lw_81 = J.arg(a, 4)
	J.mc(v_ctx_77, "beginPath", [])
	J.mc(v_ctx_77, "moveTo", [J.gp(v_pts_78, 0.0), J.gp(v_pts_78, 1.0)])
	v_i_82 = 2.0
	while true:
		if not J.cmp(v_i_82, J.len(v_pts_78), "<"): break
		J.mc(v_ctx_77, "lineTo", [J.gp(v_pts_78, v_i_82), J.gp(v_pts_78, J.add(v_i_82, 1.0))])
		var _t3 = J.add(v_i_82, 2.0)
		v_i_82 = _t3
	J.mc(v_ctx_77, "closePath", [])
	if J.t(v_fill_79):
		J.sp(v_ctx_77, "fillStyle", v_fill_79)
		J.mc(v_ctx_77, "fill", [])
	if J.t(v_stroke_80):
		var _t4 = (v_lw_81 if J.t(v_lw_81) else 1.5)
		J.sp(v_ctx_77, "lineWidth", _t4)
		J.sp(v_ctx_77, "strokeStyle", v_stroke_80)
		J.mc(v_ctx_77, "stroke", [])

func _f5(this_, a: Array, env):
	var v_ctx_85 = null; var v_hx_86 = null; var v_hy_87 = null; var v_s_88 = null; var v_kind_89 = null; var v_dx_90 = null; var v_ey_91 = null
	v_ctx_85 = J.arg(a, 0)
	v_hx_86 = J.arg(a, 1)
	v_hy_87 = J.arg(a, 2)
	v_s_88 = J.arg(a, 3)
	v_kind_89 = J.arg(a, 4)
	v_dx_90 = J.mul(5.0, v_s_88)
	v_ey_91 = J.add(v_hy_87, J.mul(1.0, v_s_88))
	if J.seq(v_kind_89, "tired"):
		var _t5 = env["el"]
		J.cl(_t5, null, [v_ctx_85, J.sub(v_hx_86, v_dx_90), v_ey_91, J.mul(2.6, v_s_88), J.mul(2.6, v_s_88), "#fff"])
		var _t6 = env["el"]
		J.cl(_t6, null, [v_ctx_85, J.add(v_hx_86, v_dx_90), v_ey_91, J.mul(2.6, v_s_88), J.mul(2.6, v_s_88), "#fff"])
		var _t7 = env["el"]
		J.cl(_t7, null, [v_ctx_85, J.sub(v_hx_86, v_dx_90), J.add(v_ey_91, J.mul(0.6, v_s_88)), J.mul(1.4, v_s_88), J.mul(1.6, v_s_88), env["OUT"]])
		var _t8 = env["el"]
		J.cl(_t8, null, [v_ctx_85, J.add(v_hx_86, v_dx_90), J.add(v_ey_91, J.mul(0.6, v_s_88)), J.mul(1.4, v_s_88), J.mul(1.6, v_s_88), env["OUT"]])
		J.sp(v_ctx_85, "strokeStyle", "#7a5a9a")
		var _t9 = J.mul(1.2, v_s_88)
		J.sp(v_ctx_85, "lineWidth", _t9)
		J.mc(v_ctx_85, "beginPath", [])
		J.mc(v_ctx_85, "arc", [J.sub(v_hx_86, v_dx_90), J.add(v_ey_91, J.mul(1.5, v_s_88)), J.mul(3.0, v_s_88), 0.2, (PI - 0.2)])
		J.mc(v_ctx_85, "stroke", [])
		J.mc(v_ctx_85, "beginPath", [])
		J.mc(v_ctx_85, "arc", [J.add(v_hx_86, v_dx_90), J.add(v_ey_91, J.mul(1.5, v_s_88)), J.mul(3.0, v_s_88), 0.2, (PI - 0.2)])
		J.mc(v_ctx_85, "stroke", [])
		var _t10 = env["OUT"]
		J.sp(v_ctx_85, "fillStyle", _t10)
		J.mc(v_ctx_85, "fillRect", [(J.sub(v_hx_86, v_dx_90) - J.mul(3.0, v_s_88)), J.sub(v_ey_91, J.mul(2.4, v_s_88)), J.mul(6.0, v_s_88), J.mul(1.2, v_s_88)])
		J.mc(v_ctx_85, "fillRect", [J.sub(J.add(v_hx_86, v_dx_90), J.mul(3.0, v_s_88)), J.sub(v_ey_91, J.mul(2.4, v_s_88)), J.mul(6.0, v_s_88), J.mul(1.2, v_s_88)])
	else:
		if J.seq(v_kind_89, "red"):
			var _t11 = env["el"]
			J.cl(_t11, null, [v_ctx_85, J.sub(v_hx_86, v_dx_90), v_ey_91, J.mul(2.4, v_s_88), J.mul(2.0, v_s_88), "#ff3355"])
			var _t12 = env["el"]
			J.cl(_t12, null, [v_ctx_85, J.add(v_hx_86, v_dx_90), v_ey_91, J.mul(2.4, v_s_88), J.mul(2.0, v_s_88), "#ff3355"])
			var _t13 = env["el"]
			J.cl(_t13, null, [v_ctx_85, J.sub(v_hx_86, v_dx_90), v_ey_91, J.mul(0.9, v_s_88), J.mul(1.6, v_s_88), "#300"])
			var _t14 = env["el"]
			J.cl(_t14, null, [v_ctx_85, J.add(v_hx_86, v_dx_90), v_ey_91, J.mul(0.9, v_s_88), J.mul(1.6, v_s_88), "#300"])
		else:
			if J.seq(v_kind_89, "paper"):
				var _t15 = env["OUT"]
				J.sp(v_ctx_85, "fillStyle", _t15)
				J.mc(v_ctx_85, "fillRect", [(J.sub(v_hx_86, v_dx_90) - J.mul(2.0, v_s_88)), J.sub(v_ey_91, J.mul(0.5, v_s_88)), J.mul(4.0, v_s_88), J.mul(1.4, v_s_88)])
				J.mc(v_ctx_85, "fillRect", [J.sub(J.add(v_hx_86, v_dx_90), J.mul(2.0, v_s_88)), J.sub(v_ey_91, J.mul(0.5, v_s_88)), J.mul(4.0, v_s_88), J.mul(1.4, v_s_88)])
			else:
				if J.seq(v_kind_89, "closed"):
					var _t16 = env["OUT"]
					J.sp(v_ctx_85, "strokeStyle", _t16)
					var _t17 = J.mul(1.4, v_s_88)
					J.sp(v_ctx_85, "lineWidth", _t17)
					J.mc(v_ctx_85, "beginPath", [])
					J.mc(v_ctx_85, "arc", [J.sub(v_hx_86, v_dx_90), J.sub(v_ey_91, J.mul(0.5, v_s_88)), J.mul(2.4, v_s_88), 0.1, (PI - 0.1)])
					J.mc(v_ctx_85, "stroke", [])
					J.mc(v_ctx_85, "beginPath", [])
					J.mc(v_ctx_85, "arc", [J.add(v_hx_86, v_dx_90), J.sub(v_ey_91, J.mul(0.5, v_s_88)), J.mul(2.4, v_s_88), 0.1, (PI - 0.1)])
					J.mc(v_ctx_85, "stroke", [])
				else:
					if J.seq(v_kind_89, "big"):
						var _t18 = env["el"]
						J.cl(_t18, null, [v_ctx_85, J.sub(v_hx_86, v_dx_90), v_ey_91, J.mul(3.4, v_s_88), J.mul(3.8, v_s_88), "#fff"])
						var _t19 = env["el"]
						J.cl(_t19, null, [v_ctx_85, J.add(v_hx_86, v_dx_90), v_ey_91, J.mul(3.4, v_s_88), J.mul(3.8, v_s_88), "#fff"])
						var _t20 = env["el"]
						J.cl(_t20, null, [v_ctx_85, J.sub(v_hx_86, v_dx_90), J.add(v_ey_91, J.mul(0.5, v_s_88)), J.mul(2.3, v_s_88), J.mul(2.8, v_s_88), "#1a1a1a"])
						var _t21 = env["el"]
						J.cl(_t21, null, [v_ctx_85, J.add(v_hx_86, v_dx_90), J.add(v_ey_91, J.mul(0.5, v_s_88)), J.mul(2.3, v_s_88), J.mul(2.8, v_s_88), "#1a1a1a"])
						var _t22 = env["el"]
						J.cl(_t22, null, [v_ctx_85, (J.sub(v_hx_86, v_dx_90) + J.mul(1.0, v_s_88)), J.sub(v_ey_91, J.mul(1.0, v_s_88)), J.mul(0.8, v_s_88), J.mul(0.8, v_s_88), "#fff"])
						var _t23 = env["el"]
						J.cl(_t23, null, [v_ctx_85, J.add(J.add(v_hx_86, v_dx_90), J.mul(1.0, v_s_88)), J.sub(v_ey_91, J.mul(1.0, v_s_88)), J.mul(0.8, v_s_88), J.mul(0.8, v_s_88), "#fff"])
					else:
						if J.seq(v_kind_89, "dot"):
							var _t24 = env["el"]
							J.cl(_t24, null, [v_ctx_85, J.sub(v_hx_86, v_dx_90), v_ey_91, J.mul(1.5, v_s_88), J.mul(1.8, v_s_88), env["OUT"]])
							var _t25 = env["el"]
							J.cl(_t25, null, [v_ctx_85, J.add(v_hx_86, v_dx_90), v_ey_91, J.mul(1.5, v_s_88), J.mul(1.8, v_s_88), env["OUT"]])
						else:
							if J.seq(v_kind_89, "angry"):
								var _t26 = env["el"]
								J.cl(_t26, null, [v_ctx_85, J.sub(v_hx_86, v_dx_90), J.add(v_ey_91, J.mul(0.5, v_s_88)), J.mul(1.7, v_s_88), J.mul(1.9, v_s_88), env["OUT"]])
								var _t27 = env["el"]
								J.cl(_t27, null, [v_ctx_85, J.add(v_hx_86, v_dx_90), J.add(v_ey_91, J.mul(0.5, v_s_88)), J.mul(1.7, v_s_88), J.mul(1.9, v_s_88), env["OUT"]])
								var _t28 = env["OUT"]
								J.sp(v_ctx_85, "strokeStyle", _t28)
								var _t29 = J.mul(1.5, v_s_88)
								J.sp(v_ctx_85, "lineWidth", _t29)
								J.mc(v_ctx_85, "beginPath", [])
								J.mc(v_ctx_85, "moveTo", [(J.sub(v_hx_86, v_dx_90) - J.mul(3.0, v_s_88)), J.sub(v_ey_91, J.mul(3.5, v_s_88))])
								J.mc(v_ctx_85, "lineTo", [(J.sub(v_hx_86, v_dx_90) + J.mul(2.5, v_s_88)), J.sub(v_ey_91, J.mul(1.8, v_s_88))])
								J.mc(v_ctx_85, "moveTo", [J.add(J.add(v_hx_86, v_dx_90), J.mul(3.0, v_s_88)), J.sub(v_ey_91, J.mul(3.5, v_s_88))])
								J.mc(v_ctx_85, "lineTo", [J.sub(J.add(v_hx_86, v_dx_90), J.mul(2.5, v_s_88)), J.sub(v_ey_91, J.mul(1.8, v_s_88))])
								J.mc(v_ctx_85, "stroke", [])
							else:
								var _t30 = env["el"]
								J.cl(_t30, null, [v_ctx_85, J.sub(v_hx_86, v_dx_90), v_ey_91, J.mul(2.0, v_s_88), J.mul(2.4, v_s_88), env["OUT"]])
								var _t31 = env["el"]
								J.cl(_t31, null, [v_ctx_85, J.add(v_hx_86, v_dx_90), v_ey_91, J.mul(2.0, v_s_88), J.mul(2.4, v_s_88), env["OUT"]])
								var _t32 = env["el"]
								J.cl(_t32, null, [v_ctx_85, (J.sub(v_hx_86, v_dx_90) + J.mul(0.7, v_s_88)), J.sub(v_ey_91, J.mul(0.8, v_s_88)), J.mul(0.7, v_s_88), J.mul(0.7, v_s_88), "#fff"])
								var _t33 = env["el"]
								J.cl(_t33, null, [v_ctx_85, J.add(J.add(v_hx_86, v_dx_90), J.mul(0.7, v_s_88)), J.sub(v_ey_91, J.mul(0.8, v_s_88)), J.mul(0.7, v_s_88), J.mul(0.7, v_s_88), "#fff"])

func _f6(this_, a: Array, env):
	var v_ctx_94 = null; var v_hx_95 = null; var v_hy_96 = null; var v_s_97 = null; var v_kind_98 = null; var v_my_99 = null
	v_ctx_94 = J.arg(a, 0)
	v_hx_95 = J.arg(a, 1)
	v_hy_96 = J.arg(a, 2)
	v_s_97 = J.arg(a, 3)
	v_kind_98 = J.arg(a, 4)
	v_my_99 = J.add(v_hy_96, J.mul(7.0, v_s_97))
	var _t34 = env["OUT"]
	J.sp(v_ctx_94, "strokeStyle", _t34)
	var _t35 = J.mul(1.2, v_s_97)
	J.sp(v_ctx_94, "lineWidth", _t35)
	if J.seq(v_kind_98, "smile"):
		J.mc(v_ctx_94, "beginPath", [])
		J.mc(v_ctx_94, "arc", [v_hx_95, J.sub(v_my_99, J.mul(1.5, v_s_97)), J.mul(2.2, v_s_97), 0.3, (PI - 0.3)])
		J.mc(v_ctx_94, "stroke", [])
	else:
		if J.seq(v_kind_98, "flat"):
			J.mc(v_ctx_94, "beginPath", [])
			J.mc(v_ctx_94, "moveTo", [J.sub(v_hx_95, J.mul(2.0, v_s_97)), v_my_99])
			J.mc(v_ctx_94, "lineTo", [J.add(v_hx_95, J.mul(2.0, v_s_97)), v_my_99])
			J.mc(v_ctx_94, "stroke", [])
		else:
			if J.seq(v_kind_98, "open"):
				var _t36 = env["el"]
				J.cl(_t36, null, [v_ctx_94, v_hx_95, v_my_99, J.mul(2.2, v_s_97), J.mul(1.8, v_s_97), "#5a1020"])
			else:
				if J.seq(v_kind_98, "red"):
					var _t37 = env["el"]
					J.cl(_t37, null, [v_ctx_94, v_hx_95, J.sub(v_my_99, J.mul(0.5, v_s_97)), J.mul(1.6, v_s_97), J.mul(1.1, v_s_97), "#d0102a"])
				else:
					if J.seq(v_kind_98, "fang"):
						var _t38 = env["el"]
						J.cl(_t38, null, [v_ctx_94, v_hx_95, v_my_99, J.mul(2.6, v_s_97), J.mul(1.6, v_s_97), "#3a0510"])
						var _t39 = env["poly"]
						J.cl(_t39, null, [v_ctx_94, [J.sub(v_hx_95, J.mul(1.6, v_s_97)), J.sub(v_my_99, J.mul(1.2, v_s_97)), J.sub(v_hx_95, J.mul(0.8, v_s_97)), J.add(v_my_99, J.mul(0.8, v_s_97)), v_hx_95, J.sub(v_my_99, J.mul(1.2, v_s_97))], "#fff"])
						var _t40 = env["poly"]
						J.cl(_t40, null, [v_ctx_94, [J.add(v_hx_95, J.mul(1.6, v_s_97)), J.sub(v_my_99, J.mul(1.2, v_s_97)), J.add(v_hx_95, J.mul(0.8, v_s_97)), J.add(v_my_99, J.mul(0.8, v_s_97)), v_hx_95, J.sub(v_my_99, J.mul(1.2, v_s_97))], "#fff"])
					else:
						if J.seq(v_kind_98, "wavy"):
							J.mc(v_ctx_94, "beginPath", [])
							J.mc(v_ctx_94, "moveTo", [J.sub(v_hx_95, J.mul(3.0, v_s_97)), v_my_99])
							J.mc(v_ctx_94, "quadraticCurveTo", [J.sub(v_hx_95, J.mul(1.5, v_s_97)), J.sub(v_my_99, J.mul(1.5, v_s_97)), v_hx_95, v_my_99])
							J.mc(v_ctx_94, "quadraticCurveTo", [J.add(v_hx_95, J.mul(1.5, v_s_97)), J.add(v_my_99, J.mul(1.5, v_s_97)), J.add(v_hx_95, J.mul(3.0, v_s_97)), v_my_99])
							J.mc(v_ctx_94, "stroke", [])

func _f7(this_, a: Array, env):
	var v_ctx_102 = null; var v_hx_103 = null; var v_hy_104 = null; var v_s_105 = null; var v_c_106 = null
	v_ctx_102 = J.arg(a, 0)
	v_hx_103 = J.arg(a, 1)
	v_hy_104 = J.arg(a, 2)
	v_s_105 = J.arg(a, 3)
	v_c_106 = J.arg(a, 4)
	var _t41 = env["el"]
	J.cl(_t41, null, [v_ctx_102, J.sub(v_hx_103, J.mul(8.0, v_s_105)), J.add(v_hy_104, J.mul(4.0, v_s_105)), J.mul(2.6, v_s_105), J.mul(1.6, v_s_105), (v_c_106 if J.t(v_c_106) else "rgba(255,110,140,.45)")])
	var _t42 = env["el"]
	J.cl(_t42, null, [v_ctx_102, J.add(v_hx_103, J.mul(8.0, v_s_105)), J.add(v_hy_104, J.mul(4.0, v_s_105)), J.mul(2.6, v_s_105), J.mul(1.6, v_s_105), (v_c_106 if J.t(v_c_106) else "rgba(255,110,140,.45)")])

func _f8(this_, a: Array, env):
	var v_ctx_109 = null; var v_x_110 = null; var v_y_111 = null; var v_s_112 = null
	v_ctx_109 = J.arg(a, 0)
	v_x_110 = J.arg(a, 1)
	v_y_111 = J.arg(a, 2)
	v_s_112 = J.arg(a, 3)
	var _t43 = env["el"]
	J.cl(_t43, null, [v_ctx_109, v_x_110, v_y_111, J.mul(14.0, v_s_112), J.mul(4.0, v_s_112), "rgba(0,0,0,.35)"])

func _f9(this_, a: Array, env):
	var v_ctx_115 = null; var v_x_116 = null; var v_y_117 = null; var v_s_118 = null; var v_col_119 = null; var v_w_120 = null; var v_h_121 = null
	v_ctx_115 = J.arg(a, 0)
	v_x_116 = J.arg(a, 1)
	v_y_117 = J.arg(a, 2)
	v_s_118 = J.arg(a, 3)
	v_col_119 = J.arg(a, 4)
	v_w_120 = J.arg(a, 5)
	v_h_121 = J.arg(a, 6)
	var _t44 = J.mul((v_w_120 if J.t(v_w_120) else 18.0), v_s_118)
	v_w_120 = _t44
	var _t45 = J.mul((v_h_121 if J.t(v_h_121) else 18.0), v_s_118)
	v_h_121 = _t45
	var _t46 = env["rr"]
	J.cl(_t46, null, [v_ctx_115, J.sub(v_x_116, J.div(v_w_120, 2.0)), J.sub(v_y_117, v_h_121), v_w_120, v_h_121, J.mul(6.0, v_s_118), v_col_119, env["OUT"], J.mul(1.6, v_s_118)])

func _f10(this_, a: Array, env):
	var v_ctx_124 = null; var v_x_125 = null; var v_y_126 = null; var v_s_127 = null; var v_col_128 = null; var v_ph_129 = null; var v_a_130 = null
	v_ctx_124 = J.arg(a, 0)
	v_x_125 = J.arg(a, 1)
	v_y_126 = J.arg(a, 2)
	v_s_127 = J.arg(a, 3)
	v_col_128 = J.arg(a, 4)
	v_ph_129 = J.arg(a, 5)
	v_a_130 = J.mul((sin(J.num((v_ph_129 if J.t(v_ph_129) else 0.0))) * 3.0), v_s_127)
	var _t47 = env["rr"]
	J.cl(_t47, null, [v_ctx_124, J.add(J.sub(v_x_125, J.mul(6.0, v_s_127)), v_a_130), J.sub(v_y_126, J.mul(6.0, v_s_127)), J.mul(5.0, v_s_127), J.mul(6.0, v_s_127), J.mul(2.0, v_s_127), v_col_128, env["OUT"], J.mul(1.2, v_s_127)])
	var _t48 = env["rr"]
	J.cl(_t48, null, [v_ctx_124, J.sub(J.add(v_x_125, J.mul(1.0, v_s_127)), v_a_130), J.sub(v_y_126, J.mul(6.0, v_s_127)), J.mul(5.0, v_s_127), J.mul(6.0, v_s_127), J.mul(2.0, v_s_127), v_col_128, env["OUT"], J.mul(1.2, v_s_127)])

func _f11(this_, a: Array, env):
	var v_ctx_133 = null; var v_x_134 = null; var v_y_135 = null; var v_s_136 = null; var v_col_137 = null; var v_t_138 = null; var v_w_139 = null; var v_sw_140 = null; var v_top_141 = null
	v_ctx_133 = J.arg(a, 0)
	v_x_134 = J.arg(a, 1)
	v_y_135 = J.arg(a, 2)
	v_s_136 = J.arg(a, 3)
	v_col_137 = J.arg(a, 4)
	v_t_138 = J.arg(a, 5)
	v_w_139 = J.arg(a, 6)
	v_sw_140 = J.mul((sin(J.num(J.mul(v_t_138, 3.0))) * 3.0), v_s_136)
	v_top_141 = J.sub(v_y_135, J.mul(9.0, v_s_136))
	J.mc(v_ctx_133, "beginPath", [])
	J.mc(v_ctx_133, "moveTo", [J.sub(v_x_134, J.mul(v_w_139, v_s_136)), v_top_141])
	J.mc(v_ctx_133, "bezierCurveTo", [J.sub(v_x_134, J.mul(J.mul(v_w_139, 0.95), v_s_136)), J.sub(v_y_135, J.mul(2.0, v_s_136)), (J.sub(v_x_134, J.mul(3.0, v_s_136)) + J.mul(v_sw_140, 0.5)), J.add(v_y_135, J.mul(1.0, v_s_136)), J.add(J.add(v_x_134, J.mul(2.0, v_s_136)), v_sw_140), J.add(v_y_135, J.mul(5.0, v_s_136))])
	J.mc(v_ctx_133, "quadraticCurveTo", [J.add(J.add(v_x_134, J.mul(7.0, v_s_136)), J.mul(v_sw_140, 1.3)), J.add(v_y_135, J.mul(6.0, v_s_136)), J.add(J.add(v_x_134, J.mul(6.0, v_s_136)), v_sw_140), J.add(v_y_135, J.mul(2.0, v_s_136))])
	J.mc(v_ctx_133, "bezierCurveTo", [J.add(v_x_134, J.mul(J.mul(v_w_139, 0.7), v_s_136)), J.sub(v_y_135, J.mul(1.0, v_s_136)), J.add(v_x_134, J.mul(v_w_139, v_s_136)), J.sub(v_y_135, J.mul(4.0, v_s_136)), J.add(v_x_134, J.mul(v_w_139, v_s_136)), v_top_141])
	J.mc(v_ctx_133, "closePath", [])
	J.sp(v_ctx_133, "fillStyle", v_col_137)
	J.mc(v_ctx_133, "fill", [])
	var _t49 = env["OUT"]
	J.sp(v_ctx_133, "strokeStyle", _t49)
	var _t50 = J.mul(1.4, v_s_136)
	J.sp(v_ctx_133, "lineWidth", _t50)
	J.mc(v_ctx_133, "stroke", [])

func _f12(this_, a: Array, env):
	var v_ctx_144 = null; var v_x_145 = null; var v_y_146 = null; var v_s_147 = null; var v_col_148 = null; var v_t_149 = null
	v_ctx_144 = J.arg(a, 0)
	v_x_145 = J.arg(a, 1)
	v_y_146 = J.arg(a, 2)
	v_s_147 = J.arg(a, 3)
	v_col_148 = J.arg(a, 4)
	v_t_149 = J.arg(a, 5)
	J.mc(v_ctx_144, "beginPath", [])
	J.mc(v_ctx_144, "moveTo", [J.sub(v_x_145, J.mul(9.0, v_s_147)), J.sub(v_y_146, J.mul(16.0, v_s_147))])
	J.mc(v_ctx_144, "quadraticCurveTo", [J.sub(v_x_145, J.mul(10.0, v_s_147)), J.sub(v_y_146, J.mul(4.0, v_s_147)), (J.sub(v_x_145, J.mul(4.0, v_s_147)) + J.mul((sin(J.num(J.mul(v_t_149, 4.0))) * 2.0), v_s_147)), v_y_146])
	J.mc(v_ctx_144, "quadraticCurveTo", [v_x_145, J.sub(v_y_146, J.mul(5.0, v_s_147)), J.add(J.add(v_x_145, J.mul(4.0, v_s_147)), J.mul((sin(J.num((J.mul(v_t_149, 4.0) + 1.0))) * 2.0), v_s_147)), J.add(v_y_146, J.mul(1.0, v_s_147))])
	J.mc(v_ctx_144, "quadraticCurveTo", [J.add(v_x_145, J.mul(10.0, v_s_147)), J.sub(v_y_146, J.mul(4.0, v_s_147)), J.add(v_x_145, J.mul(9.0, v_s_147)), J.sub(v_y_146, J.mul(16.0, v_s_147))])
	J.mc(v_ctx_144, "closePath", [])
	J.sp(v_ctx_144, "fillStyle", v_col_148)
	J.mc(v_ctx_144, "fill", [])
	var _t51 = env["OUT"]
	J.sp(v_ctx_144, "strokeStyle", _t51)
	var _t52 = J.mul(1.5, v_s_147)
	J.sp(v_ctx_144, "lineWidth", _t52)
	J.mc(v_ctx_144, "stroke", [])

func _f13(this_, a: Array, env):
	var v_ctx_152 = null; var v_x1_153 = null; var v_y1_154 = null; var v_x2_155 = null; var v_y2_156 = null; var v_s_157 = null; var v_col_158 = null
	v_ctx_152 = J.arg(a, 0)
	v_x1_153 = J.arg(a, 1)
	v_y1_154 = J.arg(a, 2)
	v_x2_155 = J.arg(a, 3)
	v_y2_156 = J.arg(a, 4)
	v_s_157 = J.arg(a, 5)
	v_col_158 = J.arg(a, 6)
	var _t53 = env["OUT"]
	J.sp(v_ctx_152, "strokeStyle", _t53)
	J.sp(v_ctx_152, "lineCap", "round")
	var _t54 = J.mul(5.4, v_s_157)
	J.sp(v_ctx_152, "lineWidth", _t54)
	J.mc(v_ctx_152, "beginPath", [])
	J.mc(v_ctx_152, "moveTo", [v_x1_153, v_y1_154])
	J.mc(v_ctx_152, "lineTo", [v_x2_155, v_y2_156])
	J.mc(v_ctx_152, "stroke", [])
	J.sp(v_ctx_152, "strokeStyle", v_col_158)
	var _t55 = J.mul(3.4, v_s_157)
	J.sp(v_ctx_152, "lineWidth", _t55)
	J.mc(v_ctx_152, "beginPath", [])
	J.mc(v_ctx_152, "moveTo", [v_x1_153, v_y1_154])
	J.mc(v_ctx_152, "lineTo", [v_x2_155, v_y2_156])
	J.mc(v_ctx_152, "stroke", [])

func _f37(this_, a: Array, env):
	var v_ctx_374 = null; var v_type_375 = null; var v_x_376 = null; var v_y_377 = null; var v_s_378 = null; var v_o_379 = null; var v_img_380 = null; var v_iw_381 = null; var v_ih_382 = null; var v_t_383 = null; var v_H_384 = null; var v_Wd_385 = null; var v_sy_386 = null; var v_sx_387 = null; var v_r_388 = null; var v_dy_389 = null; var v_tie_390 = null; var v_p_391 = null; var v_kx_392 = null; var v_ky_393 = null; var v_sx0_394 = null; var v_sx1_395 = null; var v_sy0_396 = null; var v_sh_397 = null; var v_len_398 = null; var v_step_399 = null; var v_amp_400 = null; var v_cx_401 = null; var v_d_402 = null; var v_fr_403 = null; var v_off_404 = null; var v_w_405 = null
	v_ctx_374 = J.arg(a, 0)
	v_type_375 = J.arg(a, 1)
	v_x_376 = J.arg(a, 2)
	v_y_377 = J.arg(a, 3)
	v_s_378 = J.arg(a, 4)
	v_o_379 = J.arg(a, 5)
	var _t56 = (not J.seq(J.typeof_(J.G.get("SPECIAL")), "undefined"))
	if J.t((J.mc(J.G.get("SPECIAL"), "has", [v_type_375]) if _t56 else _t56)):
		return J.mc(J.G.get("SPECIAL"), "draw", [v_ctx_374, v_type_375, v_x_376, v_y_377, v_s_378, v_o_379])
	var _t58 = J.G.get("SPR")
	var _t57 = env["sprKey"]
	v_img_380 = J.gp(_t58, J.cl(_t57, null, [v_type_375]))
	v_iw_381 = J.gp(v_img_380, "naturalWidth")
	v_ih_382 = J.gp(v_img_380, "naturalHeight")
	var _t59 = J.gp(v_o_379, "t")
	v_t_383 = (_t59 if J.t(_t59) else 0.0)
	v_H_384 = J.mul(J.gp(env["CHAR_H"], v_type_375), v_s_378)
	v_Wd_385 = J.div(J.mul(v_H_384, v_iw_381), v_ih_382)
	v_sy_386 = (1.0 + (sin(J.num(J.mul(v_t_383, 2.2))) * 0.02))
	v_sx_387 = (1.0 - (J.sub(v_sy_386, 1.0) * 0.5))
	v_r_388 = 0.0
	v_dy_389 = 0.0
	if J.t(J.gp(v_o_379, "walk")):
		var _t60 = J.add(v_r_388, (sin(J.num(J.mul(v_t_383, 9.0))) * 0.07))
		v_r_388 = _t60
		var _t61 = J.sub(v_dy_389, J.mul((absf(J.num(sin(J.num(J.mul(v_t_383, 9.0))))) * 1.5), v_s_378))
		v_dy_389 = _t61
	if J.t(J.gp(v_o_379, "work")):
		var _t62 = J.add(v_r_388, (sin(J.num(J.mul(v_t_383, 12.0))) * 0.12))
		v_r_388 = _t62
	var _t64 = J.gp(env["HOP"], v_type_375)
	if J.t(_t64):
		var _t63 = J.gp(v_o_379, "walk")
		_t64 = (_t63 if J.t(_t63) else J.gp(v_o_379, "enemy"))
	if J.t(_t64):
		var _t65 = J.sub(v_dy_389, J.mul((absf(J.num(sin(J.num(J.mul(v_t_383, 5.0))))) * 5.0), v_s_378))
		v_dy_389 = _t65
	if J.t(J.gp(v_o_379, "atk")):
		var _t66 = J.mul(v_sx_387, 1.08)
		v_sx_387 = _t66
		var _t67 = J.mul(v_sy_386, 1.08)
		v_sy_386 = _t67
	J.mc(v_ctx_374, "save", [])
	J.mc(v_ctx_374, "translate", [v_x_376, J.add(v_y_377, v_dy_389)])
	J.mc(v_ctx_374, "rotate", [v_r_388])
	J.mc(v_ctx_374, "scale", [v_sx_387, v_sy_386])
	J.mc(v_ctx_374, "drawImage", [v_img_380, J.div((-J.num(v_Wd_385)), 2.0), (-J.num(v_H_384)), v_Wd_385, v_H_384])
	var _t69 = J.seq(v_type_375, "afu")
	if J.t(_t69):
		var _t68 = J.G.get("sprOk")
		_t69 = J.cl(_t68, null, ["afu_tie"])
	if J.t(_t69):
		v_tie_390 = J.gp(J.G.get("SPR"), "afu_tie")
		v_p_391 = J.div(J.gp(v_tie_390, "naturalWidth"), J.gp(env["TIE"], "ow"))
		v_kx_392 = J.div(v_Wd_385, J.gp(v_tie_390, "naturalWidth"))
		v_ky_393 = J.div(v_H_384, J.gp(v_tie_390, "naturalHeight"))
		v_sx0_394 = J.mul(J.gp(env["TIE"], "x0"), v_p_391)
		v_sx1_395 = J.min_([J.gp(v_tie_390, "naturalWidth"), J.mul(J.gp(env["TIE"], "x1"), v_p_391)])
		v_sy0_396 = J.mul(J.gp(env["TIE"], "y0"), v_p_391)
		v_sh_397 = J.mul(J.sub(J.gp(env["TIE"], "y1"), J.gp(env["TIE"], "y0")), v_p_391)
		v_len_398 = J.sub(v_sx1_395, v_sx0_394)
		v_step_399 = J.max_([1.0, J.mul(2.0, v_p_391)])
		v_amp_400 = J.mul(v_H_384, 0.032)
		v_cx_401 = v_sx0_394
		while true:
			if not J.cmp(v_cx_401, v_sx1_395, "<"): break
			v_d_402 = J.div(J.sub(v_cx_401, v_sx0_394), v_p_391)
			v_fr_403 = J.div(J.sub(v_cx_401, v_sx0_394), v_len_398)
			v_off_404 = ((J.mul(sin(J.num((J.mul(v_t_383, 6.0) - J.mul(v_d_402, 0.016)))), v_amp_400) * pow(J.num(v_fr_403), J.num(1.3))) + J.mul((J.mul(sin(J.num(J.mul(v_t_383, 2.7))), v_amp_400) * 0.45), v_fr_403))
			v_w_405 = J.min_([v_step_399, J.sub(v_sx1_395, v_cx_401)])
			J.mc(v_ctx_374, "drawImage", [v_tie_390, v_cx_401, v_sy0_396, v_w_405, v_sh_397, (J.div((-J.num(v_Wd_385)), 2.0) + J.mul(v_cx_401, v_kx_392)), J.add(((-J.num(v_H_384)) + J.mul(v_sy0_396, v_ky_393)), v_off_404), (J.mul(v_w_405, v_kx_392) + 0.6), J.mul(v_sh_397, v_ky_393)])
			var _t70 = J.add(v_cx_401, v_step_399)
			v_cx_401 = _t70
	J.mc(v_ctx_374, "restore", [])

func _f38(this_, a: Array, env):
	var v_ctx_408 = null; var v_type_409 = null; var v_x_410 = null; var v_y_411 = null; var v_s_412 = null; var v_o_413 = null; var v_A_414 = null; var v_name_415 = null; var v_R_416 = null; var v_human_417 = null; var v_T1_418 = null; var v_pz_419 = null; var v_SOLIDP_420 = null
	v_ctx_408 = J.arg(a, 0)
	v_type_409 = J.arg(a, 1)
	v_x_410 = J.arg(a, 2)
	v_y_411 = J.arg(a, 3)
	v_s_412 = J.arg(a, 4)
	v_o_413 = J.arg(a, 5)
	v_A_414 = J.gp(J.G.get("Puppet"), "ANIMS")
	var _t71 = J.gp(v_o_413, "pose")
	v_name_415 = (J.gp(v_o_413, "pose") if J.t((J.gp(v_A_414, J.gp(v_o_413, "pose")) if J.t(_t71) else _t71)) else ("move" if J.t(J.gp(v_o_413, "walk")) else "idle"))
	var _t72 = (not J.t(J.mc(J.G.get("Puppet"), "armed", [v_type_409])))
	if J.t((J.gp(v_A_414, J.add(v_name_415, "C")) if _t72 else _t72)):
		var _t73 = J.add(v_name_415, "C")
		v_name_415 = _t73
	var _t74 = J.gp(v_o_413, "hurt")
	if J.t((J.gp(v_A_414, "hurt") if J.t(_t74) else _t74)):
		v_name_415 = "hurt"
	v_R_416 = J.gp(J.gp(J.G.get("Puppet"), "RIGS"), v_type_409)
	v_human_417 = (not (not J.t((J.gp(v_R_416, "lF") if J.t(v_R_416) else v_R_416))))
	if J.t((J.seq(v_name_415, "idle") if J.t(v_human_417) else v_human_417)):
		v_name_415 = "stand"
	if J.t((J.seq(v_name_415, "move") if J.t(v_human_417) else v_human_417)):
		v_name_415 = "walk"
	v_T1_418 = {"idle": 1.0, "move": 1.0, "walk": 1.0, "run": 1.0, "look": 1.0, "mop": 1.0, "sip": 1.0, "stand": 1.0, "hold": 1.0}
	var _t76 = null
	if J.t(J.gp(v_T1_418, v_name_415)):
		_t76 = J.mc(v_A_414, v_name_415, [J.gp(v_o_413, "t")])
	else:
		var _t75 = J.gp(v_o_413, "pt")
		_t76 = J.mc(v_A_414, v_name_415, [(_t75 if J.t(_t75) else 0.0), J.gp(v_o_413, "t")])
	v_pz_419 = _t76
	if J.t(J.gp(v_o_413, "face")):
		var _t77 = J.gp(v_o_413, "face")
		J.sp(v_pz_419, "hk", _t77)
	var _t78 = (not J.t(J.gp(v_pz_419, "tool")))
	var _t79 = ((not J.seq(v_type_409, "afu")) if _t78 else _t78)
	var _t80 = ((not J.t(v_human_417)) if _t79 else _t79)
	if J.t((J.mc(J.G.get("Puppet"), "armed", [v_type_409]) if _t80 else _t80)):
		J.sp(v_pz_419, "tool", "_W")
		var _t81 = ((-J.num(J.add(J.gp(v_pz_419, "aF"), J.gp(v_pz_419, "eF")))) + 0.15)
		J.sp(v_pz_419, "tr", _t81)
	var _t82 = (not J.t(J.gp(env["PUPPET_ANIM"], v_name_415)))
	if J.t((J.gp(v_o_413, "atk") if _t82 else _t82)):
		J.S_Object_("assign", [v_pz_419, {"aF": 1.6, "eF": 0.1}])
	var _t84 = J.gp(env["HOP"], v_type_409)
	if J.t(_t84):
		var _t83 = J.seq(v_name_415, "idle")
		_t84 = (_t83 if _t83 else J.seq(v_name_415, "move"))
	if J.t(_t84):
		J.S_Object_("assign", [v_pz_419, {"aF": 1.5, "eF": 0.05, "aB": 1.4, "eB": 0.05, "lean": 0.0}])
		var _t85 = J.seq(v_name_415, "move")
		if J.t((_t85 if _t85 else J.gp(v_o_413, "enemy"))):
			var _t86 = ((-absf(J.num(sin(J.num(J.mul(J.gp(v_o_413, "t"), 5.0)))))) * 7.0)
			J.sp(v_pz_419, "dy", _t86)
	v_SOLIDP_420 = J.gp(env["SOLID"], v_type_409)
	if (not J.seq(J.gp(v_o_413, "shadow"), false)):
		var _t87 = env["shadow"]
		J.cl(_t87, null, [v_ctx_408, v_x_410, J.add(v_y_411, J.mul(1.0, v_s_412)), J.mul(v_s_412, (1.0 if J.t(v_SOLIDP_420) else 0.8))])
	J.mc(J.G.get("Puppet"), "draw", [v_ctx_408, v_type_409, v_x_410, J.sub(v_y_411, (0.0 if J.t(v_SOLIDP_420) else J.mul((3.0 + (sin(J.num(J.mul(J.gp(v_o_413, "t"), 2.4))) * 2.0)), v_s_412))), (J.mul(J.gp(env["CHAR_H"], v_type_409), v_s_412) * 1.08), v_pz_419, (not J.t(J.gp(v_o_413, "flip")))])

func _f40(this_, a: Array, env):
	var v_q_429 = null
	v_q_429 = J.arg(a, 0)
	return (J.mc(env["A"], "windup", [J.div(v_q_429, 0.72), env["t"], env["type"]]) if J.cmp(v_q_429, 0.72, "<") else J.mc(env["A"], "strike", [J.div(J.sub(v_q_429, 0.72), 0.28), env["t"], env["type"]]))

func _f39(this_, a: Array, env):
	var v_o_424 = null; var v_p_427 = null; var v_atk_428 = null; var v_z_430 = null; var v_z_431 = null
	var _s95 = {"__p": env, "type": null, "A": null, "t": null}
	_s95["type"] = J.arg(a, 0)
	v_o_424 = J.arg(a, 1)
	_s95["A"] = J.gp(J.G.get("MeshAnim"), "ANIM")
	_s95["t"] = J.gp(v_o_424, "t")
	var _t88 = J.gp(v_o_424, "pt")
	var _t89 = J.gp(v_o_424, "pt")
	var _t90 = J.gp(v_o_424, "pt")
	var _t91 = J.gp(v_o_424, "pt")
	v_p_427 = J.max_([0.0, J.min_([1.0, (_t91 if J.t(_t91) else 0.0)])])
	v_atk_428 = Callable(self, "_f40").bind(_s95)
	var _t92 = J.gp(v_o_424, "pose")
	var _t93 = -1
	var _t94 = false
	if _t93 == -1 and J.seq(_t92, "windup"): _t93 = 0
	if _t93 == -1 and J.seq(_t92, "strike"): _t93 = 1
	if _t93 == -1 and J.seq(_t92, "follow"): _t93 = 2
	if _t93 == -1 and J.seq(_t92, "recover"): _t93 = 3
	if _t93 == -1 and J.seq(_t92, "cast"): _t93 = 4
	if _t93 == -1 and J.seq(_t92, "die"): _t93 = 5
	if _t93 == -1 and J.seq(_t92, "air"): _t93 = 6
	if _t93 == -1 and J.seq(_t92, "down"): _t93 = 7
	if _t93 == -1 and J.seq(_t92, "faint"): _t93 = 8
	if _t93 == -1 and J.seq(_t92, "hurt"): _t93 = 9
	if _t93 == -1 and J.seq(_t92, "scared"): _t93 = 10
	if _t93 == -1 and J.seq(_t92, "startle"): _t93 = 11
	if _t93 == -1 and J.seq(_t92, "tremble"): _t93 = 12
	if _t93 == -1 and J.seq(_t92, "cower"): _t93 = 13
	if _t93 == -1 and J.seq(_t92, "chop"): _t93 = 14
	if _t93 == -1 and J.seq(_t92, "hammer"): _t93 = 15
	if _t93 == -1 and J.seq(_t92, "reap"): _t93 = 16
	if _t93 == -1 and J.seq(_t92, "knead"): _t93 = 17
	if _t93 == -1 and J.seq(_t92, "proud"): _t93 = 18
	if _t93 == -1 and J.seq(_t92, "run"): _t93 = 19
	if _t93 == -1 and J.seq(_t92, "move"): _t93 = 20
	if _t93 == -1 and J.seq(_t92, "walk"): _t93 = 21
	while true:
		if _t93 <= 0 and _t93 >= 0:
			pass
		if _t93 <= 1 and _t93 >= 0:
			pass
		if _t93 <= 2 and _t93 >= 0:
			pass
		if _t93 <= 3 and _t93 >= 0:
			var _t95 = _s95["A"]
			var _t96 = J.gp(v_o_424, "pose")
			return J.mc(_t95, _t96, [v_p_427, _s95["t"], _s95["type"]])
		if _t93 <= 4 and _t93 >= 0:
			pass
		if _t93 <= 5 and _t93 >= 0:
			pass
		if _t93 <= 6 and _t93 >= 0:
			pass
		if _t93 <= 7 and _t93 >= 0:
			var _t97 = _s95["A"]
			var _t98 = J.gp(v_o_424, "pose")
			return J.mc(_t97, _t98, [v_p_427, _s95["t"], _s95["type"]])
		if _t93 <= 8 and _t93 >= 0:
			return J.mc(_s95["A"], "die", [v_p_427, _s95["t"]])
		if _t93 <= 9 and _t93 >= 0:
			return J.mc(_s95["A"], "hurtP", [v_p_427, _s95["t"]])
		if _t93 <= 10 and _t93 >= 0:
			pass
		if _t93 <= 11 and _t93 >= 0:
			pass
		if _t93 <= 12 and _t93 >= 0:
			pass
		if _t93 <= 13 and _t93 >= 0:
			return J.mc(_s95["A"], "scared", [_s95["t"]])
		if _t93 <= 14 and _t93 >= 0:
			return J.cl(v_atk_428, null, [v_p_427])
		if _t93 <= 15 and _t93 >= 0:
			return J.cl(v_atk_428, null, [J.mod(J.mul(v_p_427, 2.0), 1.0)])
		if _t93 <= 16 and _t93 >= 0:
			return J.mc(_s95["A"], "strike", [absf(J.num(sin(J.num((J.mul(v_p_427, PI) * 3.0))))), _s95["t"], _s95["type"]])
		if _t93 <= 17 and _t93 >= 0:
			v_z_430 = J.mc(_s95["A"], "idle", [_s95["t"]])
			var _t99 = (0.15 + (sin(J.num((J.mul(v_p_427, PI) * 4.0))) * 0.05))
			J.sp(v_z_430, "body", _t99)
			var _t100 = J.gp(v_z_430, "y")
			var _t101 = J.add((_t100 if J.t(_t100) else 0.0), (absf(J.num(sin(J.num((J.mul(v_p_427, PI) * 4.0))))) * 0.02))
			J.sp(v_z_430, "y", _t101)
			J.sp(v_z_430, "armF", 0.3)
			var _t102 = (-0.3)
			J.sp(v_z_430, "armB", _t102)
			return v_z_430
		if _t93 <= 18 and _t93 >= 0:
			v_z_431 = J.mc(_s95["A"], "idle", [_s95["t"]])
			var _t103 = (-0.12)
			J.sp(v_z_431, "head", _t103)
			var _t104 = (-0.05)
			J.sp(v_z_431, "body", _t104)
			return v_z_431
		if _t93 <= 19 and _t93 >= 0:
			pass
		if _t93 <= 20 and _t93 >= 0:
			pass
		if _t93 <= 21 and _t93 >= 0:
			return J.mc(_s95["A"], "walk", [J.mul(_s95["t"], (1.8 if J.seq(J.gp(v_o_424, "pose"), "run") else 1.0))])
		break
	if J.t(J.gp(v_o_424, "hurt")):
		return J.mc(_s95["A"], "hurtP", [0.3, _s95["t"]])
	if J.t(J.gp(v_o_424, "atk")):
		return J.mc(_s95["A"], "strike", [0.6, _s95["t"], _s95["type"]])
	if J.t(J.gp(v_o_424, "walk")):
		return J.mc(_s95["A"], "walk", [_s95["t"]])
	return J.mc(_s95["A"], "idle", [_s95["t"]])

func _f42(this_, a: Array, env):
	var v_cx_444 = null; var v_k_445 = null
	v_cx_444 = J.arg(a, 0)
	v_k_445 = J.arg(a, 1)
	var _t111 = env["__p"]["shadow"]
	return J.cl(_t111, null, [env["ctx"], v_cx_444, J.add(env["y"], J.mul(1.0, env["s"])), J.mul(env["s"], (v_k_445 if J.t(v_k_445) else (1.0 if J.t(env["solid"]) else 0.8)))])

func _f43(this_, a: Array, env):
	var v_cx_447 = null; var v_k_448 = null
	v_cx_447 = J.arg(a, 0)
	v_k_448 = J.arg(a, 1)
	var _t120 = env["__p"]["shadow"]
	return J.cl(_t120, null, [env["ctx"], v_cx_447, J.add(env["y"], J.mul(1.0, env["s"])), J.mul(env["s"], (v_k_448 if J.t(v_k_448) else (1.0 if J.t(env["solid"]) else 0.8)))])

func _f44(this_, a: Array, env):
	var v_cx_450 = null; var v_k_451 = null
	v_cx_450 = J.arg(a, 0)
	v_k_451 = J.arg(a, 1)
	var _t124 = env["__p"]["shadow"]
	return J.cl(_t124, null, [env["ctx"], v_cx_450, J.add(env["y"], J.mul(1.0, env["s"])), J.mul(env["s"], (v_k_451 if J.t(v_k_451) else (1.0 if J.t(env["solid"]) else 0.8)))])

func _f41(this_, a: Array, env):
	var v_type_435 = null; var v_x_436 = null; var v_o_439 = null; var v_H_441 = null; var v_pz_442 = null; var v_done_443 = null; var v_done_446 = null; var v_done_449 = null; var v_A_452 = null; var v_mp_453 = null; var v_tip_454 = null
	var _s100 = {"__p": env, "ctx": null, "y": null, "s": null, "solid": null}
	_s100["ctx"] = J.arg(a, 0)
	v_type_435 = J.arg(a, 1)
	v_x_436 = J.arg(a, 2)
	_s100["y"] = J.arg(a, 3)
	_s100["s"] = J.arg(a, 4)
	v_o_439 = J.arg(a, 5)
	_s100["solid"] = J.gp(_s100["__p"]["SOLID"], v_type_435)
	v_H_441 = J.mul(J.gp(_s100["__p"]["CHAR_H"], v_type_435), _s100["s"])
	var _t105 = J.gp(v_o_439, "act")
	var _t106 = ((not J.seq(J.typeof_(J.G.get("DAILY")), "undefined")) if J.t(_t105) else _t105)
	if J.t((J.gp(J.G.get("DAILY"), J.gp(v_o_439, "act")) if J.t(_t106) else _t106)):
		J.mc(_s100["ctx"], "save", [])
		if (not J.leq(J.gp(v_o_439, "alpha"), null)):
			var _t107 = _s100["ctx"]
			var _t108 = J.gp(v_o_439, "alpha")
			J.sp(_t107, "globalAlpha", _t108)
		var _t109 = J.G.get("DAILY")
		var _t110 = J.gp(v_o_439, "act")
		v_done_443 = J.mc(_t109, _t110, [_s100["ctx"], {"type": v_type_435, "x": v_x_436, "y": _s100["y"], "s": _s100["s"], "H": v_H_441, "o": v_o_439, "faceRight": (not J.t(J.gp(v_o_439, "flip"))), "solid": _s100["solid"], "shadow": Callable(self, "_f42").bind(_s100)}])
		J.mc(_s100["ctx"], "restore", [])
		if (not J.seq(v_done_443, false)):
			return null
	var _t112 = (not J.seq(J.typeof_(J.G.get("MOVES")), "undefined"))
	var _t116 = (J.gp(J.G.get("MOVES"), v_type_435) if _t112 else _t112)
	if J.t(_t116):
		var _t113 = J.seq(J.gp(v_o_439, "pose"), "windup")
		var _t114 = (_t113 if _t113 else J.seq(J.gp(v_o_439, "pose"), "strike"))
		var _t115 = (_t114 if _t114 else J.seq(J.gp(v_o_439, "pose"), "follow"))
		_t116 = (_t115 if _t115 else J.seq(J.gp(v_o_439, "pose"), "recover"))
	if J.t(_t116):
		J.mc(_s100["ctx"], "save", [])
		if (not J.leq(J.gp(v_o_439, "alpha"), null)):
			var _t117 = _s100["ctx"]
			var _t118 = J.gp(v_o_439, "alpha")
			J.sp(_t117, "globalAlpha", _t118)
		var _t119 = J.G.get("MOVES")
		v_done_446 = J.mc(_t119, v_type_435, [_s100["ctx"], {"type": v_type_435, "x": v_x_436, "y": _s100["y"], "s": _s100["s"], "H": v_H_441, "o": v_o_439, "faceRight": (not J.t(J.gp(v_o_439, "flip"))), "solid": _s100["solid"], "shadow": Callable(self, "_f43").bind(_s100)}])
		J.mc(_s100["ctx"], "restore", [])
		if (not J.seq(v_done_446, false)):
			return null
	if J.t(J.gp(J.gp(J.gp(J.G.get("MeshAnim"), "RIG"), v_type_435), "custom")):
		J.mc(_s100["ctx"], "save", [])
		if (not J.leq(J.gp(v_o_439, "alpha"), null)):
			var _t121 = _s100["ctx"]
			var _t122 = J.gp(v_o_439, "alpha")
			J.sp(_t121, "globalAlpha", _t122)
		var _t123 = J.gp(J.gp(J.G.get("MeshAnim"), "RIG"), v_type_435)
		v_done_449 = J.mc(_t123, "custom", [_s100["ctx"], {"type": v_type_435, "x": v_x_436, "y": _s100["y"], "s": _s100["s"], "H": v_H_441, "o": v_o_439, "faceRight": (not J.t(J.gp(v_o_439, "flip"))), "solid": _s100["solid"], "shadow": Callable(self, "_f44").bind(_s100)}])
		J.mc(_s100["ctx"], "restore", [])
		if (not J.seq(v_done_449, false)):
			return null
	var _t125 = (not J.seq(J.typeof_(J.G.get("Limbs")), "undefined"))
	var _t126 = (J.mc(J.G.get("Limbs"), "has", [v_type_435]) if _t125 else _t125)
	var _t127 = (J.gp(_s100["__p"]["LIMB_POSES"], J.gp(v_o_439, "pose")) if J.t(_t126) else _t126)
	if J.t(((not J.t(J.gp(v_o_439, "hurt"))) if J.t(_t127) else _t127)):
		v_A_452 = J.gp(J.G.get("MeshAnim"), "ANIM")
		var _t128 = J.gp(v_o_439, "walk")
		var _t129 = (_t128 if J.t(_t128) else J.seq(J.gp(v_o_439, "pose"), "move"))
		var _t130 = (_t129 if J.t(_t129) else J.seq(J.gp(v_o_439, "pose"), "walk"))
		v_mp_453 = (J.mc(v_A_452, "walk", [J.gp(v_o_439, "t")]) if J.t((_t130 if J.t(_t130) else J.seq(J.gp(v_o_439, "pose"), "run"))) else J.mc(v_A_452, "idle", [J.gp(v_o_439, "t")]))
		J.mc(_s100["ctx"], "save", [])
		if (not J.leq(J.gp(v_o_439, "alpha"), null)):
			var _t131 = _s100["ctx"]
			var _t132 = J.gp(v_o_439, "alpha")
			J.sp(_t131, "globalAlpha", _t132)
		if (not J.seq(J.gp(v_o_439, "shadow"), false)):
			J.mc(_s100["ctx"], "save", [])
			if (not J.t(_s100["solid"])):
				var _t133 = _s100["ctx"]
				var _t134 = J.mul(J.gp(_t133, "globalAlpha"), 0.55)
				J.sp(_t133, "globalAlpha", _t134)
			var _t135 = _s100["__p"]["shadow"]
			J.cl(_t135, null, [_s100["ctx"], v_x_436, J.add(_s100["y"], J.mul(1.0, _s100["s"])), J.mul(_s100["s"], (1.0 if J.t(_s100["solid"]) else 0.8))])
			J.mc(_s100["ctx"], "restore", [])
		v_tip_454 = J.mc(J.G.get("Limbs"), "draw", [_s100["ctx"], v_type_435, v_x_436, J.sub(_s100["y"], (0.0 if J.t(_s100["solid"]) else J.mul((3.0 + (sin(J.num(J.mul(J.gp(v_o_439, "t"), 2.4))) * 2.0)), _s100["s"]))), v_H_441, v_o_439, (not J.t(J.gp(v_o_439, "flip"))), v_mp_453])
		J.mc(_s100["ctx"], "restore", [])
		if J.t(J.gp(v_o_439, "tipOut")):
			var _t136 = J.gp(v_o_439, "tipOut")
			J.sp(_t136, "p", v_tip_454)
		return null
	var _t137 = _s100["__p"]["meshPose"]
	v_pz_442 = J.cl(_t137, null, [v_type_435, v_o_439])
	if J.t(J.gp(J.gp(J.gp(J.G.get("MeshAnim"), "RIG"), v_type_435), "tweak")):
		var _t138 = J.gp(J.gp(J.G.get("MeshAnim"), "RIG"), v_type_435)
		J.mc(_t138, "tweak", [v_pz_442, v_o_439])
	var _t141 = J.gp(J.gp(J.gp(J.G.get("MeshAnim"), "RIG"), v_type_435), "hop")
	if J.t(_t141):
		var _t139 = J.gp(v_o_439, "walk")
		var _t140 = (_t139 if J.t(_t139) else J.gp(v_o_439, "enemy"))
		_t141 = (_t140 if J.t(_t140) else J.seq(J.gp(v_o_439, "pose"), "move"))
	if J.t(_t141):
		var _t142 = J.gp(v_pz_442, "y")
		var _t143 = J.sub((_t142 if J.t(_t142) else 0.0), (absf(J.num(sin(J.num(J.mul(J.gp(v_o_439, "t"), 5.0))))) * 0.09))
		J.sp(v_pz_442, "y", _t143)
	J.mc(_s100["ctx"], "save", [])
	if (not J.leq(J.gp(v_o_439, "alpha"), null)):
		var _t144 = _s100["ctx"]
		var _t145 = J.gp(v_o_439, "alpha")
		J.sp(_t144, "globalAlpha", _t145)
	if (not J.seq(J.gp(v_o_439, "shadow"), false)):
		J.mc(_s100["ctx"], "save", [])
		if (not J.t(_s100["solid"])):
			var _t146 = _s100["ctx"]
			var _t147 = J.mul(J.gp(_t146, "globalAlpha"), 0.55)
			J.sp(_t146, "globalAlpha", _t147)
		var _t148 = _s100["__p"]["shadow"]
		J.cl(_t148, null, [_s100["ctx"], v_x_436, J.add(_s100["y"], J.mul(1.0, _s100["s"])), J.mul(_s100["s"], (1.0 if J.t(_s100["solid"]) else 0.8))])
		J.mc(_s100["ctx"], "restore", [])
	J.mc(J.G.get("MeshAnim"), "draw", [_s100["ctx"], v_type_435, v_x_436, J.sub(_s100["y"], (0.0 if J.t(_s100["solid"]) else J.mul((3.0 + (sin(J.num(J.mul(J.gp(v_o_439, "t"), 2.4))) * 2.0)), _s100["s"]))), v_H_441, v_pz_442, (not J.t(J.gp(v_o_439, "flip")))])
	J.mc(_s100["ctx"], "restore", [])

func _f46(this_, a: Array, env):
	var v_c_476 = null; var v_xx_477 = null; var v_yy_478 = null; var v_ss_479 = null; var v_oo_480 = null
	v_c_476 = J.arg(a, 0)
	v_xx_477 = J.arg(a, 1)
	v_yy_478 = J.arg(a, 2)
	v_ss_479 = J.arg(a, 3)
	v_oo_480 = J.arg(a, 4)
	var _t162 = env["__p"]["drawSprite"]
	return J.cl(_t162, null, [v_c_476, env["type"], v_xx_477, v_yy_478, v_ss_479, v_oo_480])

func _f45(this_, a: Array, env):
	var v_ctx_457 = null; var v_x_459 = null; var v_y_460 = null; var v_s_461 = null; var v_o_462 = null; var v_spr_463 = null; var v_f_464 = null; var v_ghost_465 = null; var v_fy_466 = null; var v_m_467 = null; var v_k_468 = null; var v_L_469 = null; var v_T_470 = null; var v_Wd_471 = null; var v_Ht_472 = null; var v_pw_473 = null; var v_ph_474 = null; var v_g_475 = null
	var _s110 = {"__p": env, "type": null}
	v_ctx_457 = J.arg(a, 0)
	_s110["type"] = J.arg(a, 1)
	v_x_459 = J.arg(a, 2)
	v_y_460 = J.arg(a, 3)
	v_s_461 = J.arg(a, 4)
	v_o_462 = J.arg(a, 5)
	var _t149 = (v_o_462 if J.t(v_o_462) else {})
	v_o_462 = _t149
	var _t150 = J.gp(v_o_462, "t")
	var _t151 = (_t150 if J.t(_t150) else 0.0)
	J.sp(v_o_462, "t", _t151)
	var _t152 = (not J.seq(J.typeof_(J.G.get("MeshAnim")), "undefined"))
	var _t153 = (J.gp(_s110["__p"]["CHAR_H"], _s110["type"]) if _t152 else _t152)
	var _t155 = (J.mc(J.G.get("MeshAnim"), "has", [_s110["type"]]) if J.t(_t153) else _t153)
	if J.t(_t155):
		var _t154 = (not J.seq(J.typeof_(J.G.get("SPECIAL")), "undefined"))
		_t155 = (not J.t((J.mc(J.G.get("SPECIAL"), "has", [_s110["type"]]) if _t154 else _t154)))
	if J.t(((not J.t(J.gp(v_o_462, "noMesh"))) if J.t(_t155) else _t155)):
		var _t156 = _s110["__p"]["drawMesh"]
		return J.cl(_t156, null, [v_ctx_457, _s110["type"], v_x_459, v_y_460, v_s_461, v_o_462])
	var _t157 = (not J.seq(J.typeof_(J.G.get("Puppet")), "undefined"))
	var _t158 = (J.mc(J.G.get("Puppet"), "has", [_s110["type"]]) if _t157 else _t157)
	if J.t(((not J.t(J.gp(v_o_462, "noPuppet"))) if J.t(_t158) else _t158)):
		J.mc(v_ctx_457, "save", [])
		if (not J.leq(J.gp(v_o_462, "alpha"), null)):
			var _t159 = J.gp(v_o_462, "alpha")
			J.sp(v_ctx_457, "globalAlpha", _t159)
		if J.t(J.gp(v_o_462, "rot")):
			J.mc(v_ctx_457, "translate", [v_x_459, J.sub(v_y_460, J.mul(15.0, v_s_461))])
			J.mc(v_ctx_457, "rotate", [J.gp(v_o_462, "rot")])
			J.mc(v_ctx_457, "translate", [(-J.num(v_x_459)), (-J.sub(v_y_460, J.mul(15.0, v_s_461)))])
		var _t160 = _s110["__p"]["drawPuppet"]
		J.cl(_t160, null, [v_ctx_457, _s110["type"], v_x_459, v_y_460, v_s_461, v_o_462])
		J.mc(v_ctx_457, "restore", [])
		return null
	var _t161 = _s110["__p"]["hasSpr"]
	v_spr_463 = J.cl(_t161, null, [_s110["type"]])
	var _t164 = null
	if J.t(v_spr_463):
		_t164 = Callable(self, "_f46").bind(_s110)
	else:
		var _t163 = J.gp(_s110["__p"]["DRAW"], _s110["type"])
		_t164 = (_t163 if J.t(_t163) else J.gp(_s110["__p"]["DRAW"], "youhun"))
	v_f_464 = _t164
	v_ghost_465 = (not J.t(J.gp(_s110["__p"]["SOLID"], _s110["type"])))
	J.mc(v_ctx_457, "save", [])
	if (not J.leq(J.gp(v_o_462, "alpha"), null)):
		var _t165 = J.gp(v_o_462, "alpha")
		J.sp(v_ctx_457, "globalAlpha", _t165)
	if (not J.seq(J.gp(v_o_462, "shadow"), false)):
		if J.t(v_ghost_465):
			J.mc(v_ctx_457, "save", [])
			var _t166 = J.mul(J.gp(v_ctx_457, "globalAlpha"), 0.55)
			J.sp(v_ctx_457, "globalAlpha", _t166)
			var _t167 = _s110["__p"]["shadow"]
			J.cl(_t167, null, [v_ctx_457, v_x_459, J.add(v_y_460, J.mul(1.0, v_s_461)), J.mul(v_s_461, 0.8)])
			J.mc(v_ctx_457, "restore", [])
		else:
			var _t168 = _s110["__p"]["shadow"]
			J.cl(_t168, null, [v_ctx_457, v_x_459, J.add(v_y_460, J.mul(1.0, v_s_461)), v_s_461])
	if J.t(J.gp(v_o_462, "flip")):
		J.mc(v_ctx_457, "translate", [v_x_459, 0.0])
		J.mc(v_ctx_457, "scale", [(-1.0), 1.0])
		J.mc(v_ctx_457, "translate", [(-J.num(v_x_459)), 0.0])
	if J.t(J.gp(v_o_462, "rot")):
		J.mc(v_ctx_457, "translate", [v_x_459, J.sub(v_y_460, J.mul(15.0, v_s_461))])
		J.mc(v_ctx_457, "rotate", [J.gp(v_o_462, "rot")])
		J.mc(v_ctx_457, "translate", [(-J.num(v_x_459)), (-J.sub(v_y_460, J.mul(15.0, v_s_461)))])
	if (not J.t(v_ghost_465)):
		J.cl(v_f_464, null, [v_ctx_457, v_x_459, v_y_460, v_s_461, v_o_462])
		J.mc(v_ctx_457, "restore", [])
		return null
	v_fy_466 = J.sub(v_y_460, J.mul((3.0 + (sin(J.num(J.mul(J.gp(v_o_462, "t"), 2.4))) * 2.0)), v_s_461))
	v_m_467 = J.mc(v_ctx_457, "getTransform", [])
	v_k_468 = J.min_([4.0, J.max_([1.0, J.hypot_([J.gp(v_m_467, "a"), J.gp(v_m_467, "b")])])])
	v_L_469 = J.mul(48.0, v_s_461)
	v_T_470 = J.mul(96.0, v_s_461)
	v_Wd_471 = J.mul(96.0, v_s_461)
	v_Ht_472 = J.mul(106.0, v_s_461)
	v_pw_473 = ceil(J.num(J.mul(v_Wd_471, v_k_468)))
	v_ph_474 = ceil(J.num(J.mul(v_Ht_472, v_k_468)))
	var _t169 = J.cmp(J.gp(_s110["__p"]["buf"], "width"), v_pw_473, "<")
	if (_t169 if _t169 else J.cmp(J.gp(_s110["__p"]["buf"], "height"), v_ph_474, "<")):
		var _t170 = _s110["__p"]["buf"]
		var _t171 = J.max_([J.gp(_s110["__p"]["buf"], "width"), v_pw_473])
		J.sp(_t170, "width", _t171)
		var _t172 = _s110["__p"]["buf"]
		var _t173 = J.max_([J.gp(_s110["__p"]["buf"], "height"), v_ph_474])
		J.sp(_t172, "height", _t173)
	J.mc(_s110["__p"]["bctx"], "setTransform", [1.0, 0.0, 0.0, 1.0, 0.0, 0.0])
	J.mc(_s110["__p"]["bctx"], "clearRect", [0.0, 0.0, v_pw_473, v_ph_474])
	J.mc(_s110["__p"]["bctx"], "setTransform", [v_k_468, 0.0, 0.0, v_k_468, J.mul(J.sub(v_L_469, v_x_459), v_k_468), J.mul(J.sub(v_T_470, v_fy_466), v_k_468)])
	var _t174 = _s110["__p"]["bctx"]
	J.sp(_t174, "globalCompositeOperation", "source-over")
	var _t175 = _s110["__p"]["bctx"]
	J.sp(_t175, "globalAlpha", 1.0)
	J.cl(v_f_464, null, [_s110["__p"]["bctx"], v_x_459, v_fy_466, v_s_461, v_o_462])
	var _t176 = _s110["__p"]["bctx"]
	J.sp(_t176, "globalCompositeOperation", "destination-out")
	v_g_475 = J.mc(_s110["__p"]["bctx"], "createLinearGradient", [0.0, J.sub(v_fy_466, J.mul(13.0, v_s_461)), 0.0, J.add(v_fy_466, J.mul(6.0, v_s_461))])
	if J.t(v_spr_463):
		J.mc(v_g_475, "addColorStop", [0.0, "rgba(0,0,0,0)"])
		J.mc(v_g_475, "addColorStop", [0.6, "rgba(0,0,0,.22)"])
		J.mc(v_g_475, "addColorStop", [1.0, "rgba(0,0,0,.55)"])
	else:
		J.mc(v_g_475, "addColorStop", [0.0, "rgba(0,0,0,0)"])
		J.mc(v_g_475, "addColorStop", [0.55, "rgba(0,0,0,.55)"])
		J.mc(v_g_475, "addColorStop", [1.0, "rgba(0,0,0,.92)"])
	var _t177 = _s110["__p"]["bctx"]
	J.sp(_t177, "fillStyle", v_g_475)
	J.mc(_s110["__p"]["bctx"], "fillRect", [J.sub(v_x_459, v_L_469), J.sub(v_fy_466, J.mul(13.0, v_s_461)), v_Wd_471, J.mul(30.0, v_s_461)])
	var _t178 = _s110["__p"]["bctx"]
	J.sp(_t178, "globalCompositeOperation", "source-over")
	J.mc(v_ctx_457, "drawImage", [_s110["__p"]["buf"], 0.0, 0.0, v_pw_473, v_ph_474, J.sub(v_x_459, v_L_469), J.sub(v_fy_466, v_T_470), J.div(v_pw_473, v_k_468), J.div(v_ph_474, v_k_468)])
	J.mc(v_ctx_457, "restore", [])

func _f47(this_, a: Array, env):
	var v_type_483 = null; var v_size_484 = null; var v_opt_485 = null; var v_spr_486 = null; var v_key_487 = null; var v_c_488 = null; var v_dpr_489 = null; var v_ctx_490 = null; var v_s_491 = null; var v_img_492 = null; var v_iw_493 = null; var v_ih_494 = null; var v_top_495 = null; var v_fr_496 = null; var v_S_497 = null; var v_sx_498 = null; var v_sy_499 = null
	v_type_483 = J.arg(a, 0)
	v_size_484 = J.arg(a, 1)
	v_opt_485 = J.arg(a, 2)
	var _t179 = env["hasSpr"]
	v_spr_486 = J.cl(_t179, null, [v_type_483])
	v_key_487 = (J.add((J.add(J.add(v_type_483, "_"), v_size_484) + "_"), J.S_JSON_("stringify", [(v_opt_485 if J.t(v_opt_485) else {})])) + ("_s" if J.t(v_spr_486) else ""))
	if J.t(J.gp(env["portraitCache"], v_key_487)):
		return J.gp(env["portraitCache"], v_key_487)
	v_c_488 = J.S_document_("createElement", ["canvas"])
	var _t180 = J.gp(J.G.get("window"), "devicePixelRatio")
	var _t181 = J.gp(J.G.get("window"), "devicePixelRatio")
	v_dpr_489 = J.min_([2.0, (_t181 if J.t(_t181) else 1.0)])
	var _t182 = J.mul(v_size_484, v_dpr_489)
	J.sp(v_c_488, "width", _t182)
	var _t183 = J.mul(v_size_484, v_dpr_489)
	J.sp(v_c_488, "height", _t183)
	v_ctx_490 = J.mc(v_c_488, "getContext", ["2d"])
	J.mc(v_ctx_490, "scale", [v_dpr_489, v_dpr_489])
	if J.t(v_spr_486):
		var _t185 = J.G.get("SPR")
		var _t184 = env["sprKey"]
		v_img_492 = J.gp(_t185, J.cl(_t184, null, [v_type_483]))
		v_iw_493 = J.gp(v_img_492, "naturalWidth")
		v_ih_494 = J.gp(v_img_492, "naturalHeight")
		var _t186 = J.gp(env["PCROP"], v_type_483)
		var _t187 = (_t186 if J.t(_t186) else [0.0, 0.86])
		var _t188 = J.gp(_t187, 0.0)
		v_top_495 = _t188
		var _t189 = J.gp(_t187, 1.0)
		v_fr_496 = _t189
		v_S_497 = J.min_([J.mul(v_iw_493, v_fr_496), v_ih_494])
		v_sx_498 = (J.div(J.sub(v_iw_493, v_S_497), 2.0) + (J.mul(v_iw_493, 0.1) if J.seq(v_type_483, "afu") else 0.0))
		v_sy_499 = J.min_([J.sub(v_ih_494, v_S_497), J.mul(v_iw_493, v_top_495)])
		J.sp(v_ctx_490, "imageSmoothingQuality", "high")
		J.mc(v_ctx_490, "drawImage", [v_img_492, J.max_([0.0, J.min_([J.sub(v_iw_493, v_S_497), v_sx_498])]), J.max_([0.0, v_sy_499]), v_S_497, v_S_497, J.mul(v_size_484, 0.04), J.mul(v_size_484, 0.04), J.mul(v_size_484, 0.92), J.mul(v_size_484, 0.92)])
		var _t190 = env["portraitCache"]
		J.sp(_t190, v_key_487, v_c_488)
		return v_c_488
	v_s_491 = J.div(v_size_484, 52.0)
	var _t191 = env["drawChar"]
	var _t198 = J.div(v_size_484, 2.0)
	var _t193 = J.mul(v_size_484, 0.98)
	var _t192 = ["penanggal"]
	var _t195 = (_t193 + (((-J.num(v_size_484)) * 0.05) if J.t(J.mc(_t192, "includes", [v_type_483])) else 0.0))
	var _t194 = ["baiwu", "heiwu"]
	var _t197 = (_t195 + (J.mul(v_size_484, 0.3) if J.t(J.mc(_t194, "includes", [v_type_483])) else 0.0))
	var _t196 = ["eguiking", "huang", "niutou", "mamian"]
	var _t200 = (_t197 + (J.mul(v_size_484, 0.12) if J.t(J.mc(_t196, "includes", [v_type_483])) else 0.0))
	var _t199 = ["baiwu", "heiwu"]
	J.cl(_t191, null, [v_ctx_490, v_type_483, _t198, _t200, J.mul(v_s_491, (0.85 if J.t(J.mc(_t199, "includes", [v_type_483])) else 1.0)), J.S_Object_("assign", [{"shadow": false, "t": 0.3}, (v_opt_485 if J.t(v_opt_485) else {})])])
	var _t201 = J.seq(J.typeof_(J.G.get("SPR")), "undefined")
	if (_t201 if _t201 else (not J.t(J.gp(env["CHAR_H"], v_type_483)))):
		var _t202 = env["portraitCache"]
		J.sp(_t202, v_key_487, v_c_488)
	return v_c_488

func _f48(this_, a: Array, env):
	var v_size_502 = null; var v_c_503 = null; var v_dpr_504 = null; var v_ctx_505 = null; var v_g_506 = null
	v_size_502 = J.arg(a, 0)
	v_c_503 = J.S_document_("createElement", ["canvas"])
	var _t203 = J.gp(J.G.get("window"), "devicePixelRatio")
	var _t204 = J.gp(J.G.get("window"), "devicePixelRatio")
	v_dpr_504 = J.min_([2.0, (_t204 if J.t(_t204) else 1.0)])
	var _t205 = J.mul(v_size_502, v_dpr_504)
	J.sp(v_c_503, "width", _t205)
	var _t206 = J.mul(v_size_502, v_dpr_504)
	J.sp(v_c_503, "height", _t206)
	v_ctx_505 = J.mc(v_c_503, "getContext", ["2d"])
	J.mc(v_ctx_505, "scale", [v_dpr_504, v_dpr_504])
	v_g_506 = J.mc(v_ctx_505, "createRadialGradient", [J.div(v_size_502, 2.0), J.div(v_size_502, 2.0), 2.0, J.div(v_size_502, 2.0), J.div(v_size_502, 2.0), J.div(v_size_502, 2.0)])
	J.mc(v_g_506, "addColorStop", [0.0, "rgba(120,255,220,.9)"])
	J.mc(v_g_506, "addColorStop", [1.0, "rgba(120,255,220,0)"])
	J.sp(v_ctx_505, "fillStyle", v_g_506)
	J.mc(v_ctx_505, "fillRect", [0.0, 0.0, v_size_502, v_size_502])
	var _t207 = env["rr"]
	J.cl(_t207, null, [v_ctx_505, J.mul(v_size_502, 0.24), J.mul(v_size_502, 0.18), J.mul(v_size_502, 0.52), J.mul(v_size_502, 0.64), J.mul(v_size_502, 0.08), "#0e2a2a", "#6ff0d0", 2.0])
	J.sp(v_ctx_505, "fillStyle", "#6ff0d0")
	var _t208 = ("bold " + J.str(J.mul(v_size_502, 0.2)) + "px sans-serif")
	J.sp(v_ctx_505, "font", _t208)
	J.sp(v_ctx_505, "textAlign", "center")
	J.sp(v_ctx_505, "textBaseline", "middle")
	J.mc(v_ctx_505, "fillText", ["KPI", J.div(v_size_502, 2.0), J.mul(v_size_502, 0.42)])
	J.mc(v_ctx_505, "fillRect", [J.mul(v_size_502, 0.34), J.mul(v_size_502, 0.6), J.mul(v_size_502, 0.32), J.mul(v_size_502, 0.05)])
	return v_c_503

func _f49(this_, a: Array, env):
	var v_ctx_509 = null; var v_x_510 = null; var v_y_511 = null; var v_w_512 = null; var v_h_513 = null; var v_col_514 = null; var v_edge_515 = null; var v_i_516 = null; var v_yy_517 = null
	v_ctx_509 = J.arg(a, 0)
	v_x_510 = J.arg(a, 1)
	v_y_511 = J.arg(a, 2)
	v_w_512 = J.arg(a, 3)
	v_h_513 = J.arg(a, 4)
	v_col_514 = J.arg(a, 5)
	v_edge_515 = J.arg(a, 6)
	J.mc(v_ctx_509, "beginPath", [])
	J.mc(v_ctx_509, "moveTo", [(J.sub(v_x_510, J.div(v_w_512, 2.0)) - 8.0), J.add(v_y_511, v_h_513)])
	J.mc(v_ctx_509, "quadraticCurveTo", [J.sub(v_x_510, J.div(v_w_512, 2.0)), J.add(v_y_511, J.mul(v_h_513, 0.4)), J.sub(v_x_510, J.div(v_w_512, 4.0)), v_y_511])
	J.mc(v_ctx_509, "lineTo", [J.add(v_x_510, J.div(v_w_512, 4.0)), v_y_511])
	J.mc(v_ctx_509, "quadraticCurveTo", [J.add(v_x_510, J.div(v_w_512, 2.0)), J.add(v_y_511, J.mul(v_h_513, 0.4)), J.add(J.add(v_x_510, J.div(v_w_512, 2.0)), 8.0), J.add(v_y_511, v_h_513)])
	J.mc(v_ctx_509, "closePath", [])
	J.sp(v_ctx_509, "fillStyle", v_col_514)
	J.mc(v_ctx_509, "fill", [])
	var _t209 = env["OUT"]
	J.sp(v_ctx_509, "strokeStyle", _t209)
	J.sp(v_ctx_509, "lineWidth", 2.0)
	J.mc(v_ctx_509, "stroke", [])
	var _t210 = (v_edge_515 if J.t(v_edge_515) else "rgba(255,255,255,.12)")
	J.sp(v_ctx_509, "strokeStyle", _t210)
	J.sp(v_ctx_509, "lineWidth", 1.0)
	v_i_516 = 1.0
	while true:
		if not J.cmp(v_i_516, 6.0, "<"): break
		v_yy_517 = J.add(v_y_511, J.div(J.mul(v_h_513, v_i_516), 6.0))
		J.mc(v_ctx_509, "beginPath", [])
		J.mc(v_ctx_509, "moveTo", [((J.sub(v_x_510, J.div(v_w_512, 2.0)) + 2.0) - J.div(J.mul(8.0, v_i_516), 6.0)), v_yy_517])
		J.mc(v_ctx_509, "lineTo", [(J.sub(J.add(v_x_510, J.div(v_w_512, 2.0)), 2.0) + J.div(J.mul(8.0, v_i_516), 6.0)), v_yy_517])
		J.mc(v_ctx_509, "stroke", [])
		v_i_516 = J.num(v_i_516) + 1.0
	var _t211 = env["poly"]
	J.cl(_t211, null, [v_ctx_509, [(J.sub(v_x_510, J.div(v_w_512, 2.0)) - 10.0), J.add(v_y_511, v_h_513), (J.sub(v_x_510, J.div(v_w_512, 2.0)) - 14.0), J.sub(J.add(v_y_511, v_h_513), 7.0), (J.sub(v_x_510, J.div(v_w_512, 2.0)) - 4.0), J.sub(J.add(v_y_511, v_h_513), 2.0)], v_col_514, env["OUT"], 1.5])
	var _t212 = env["poly"]
	J.cl(_t212, null, [v_ctx_509, [J.add(J.add(v_x_510, J.div(v_w_512, 2.0)), 10.0), J.add(v_y_511, v_h_513), J.add(J.add(v_x_510, J.div(v_w_512, 2.0)), 14.0), J.sub(J.add(v_y_511, v_h_513), 7.0), J.add(J.add(v_x_510, J.div(v_w_512, 2.0)), 4.0), J.sub(J.add(v_y_511, v_h_513), 2.0)], v_col_514, env["OUT"], 1.5])

func _f50(this_, a: Array, env):
	var v_ctx_520 = null; var v_x_521 = null; var v_y_522 = null; var v_t_523 = null; var v_col_524 = null; var v_g_525 = null
	v_ctx_520 = J.arg(a, 0)
	v_x_521 = J.arg(a, 1)
	v_y_522 = J.arg(a, 2)
	v_t_523 = J.arg(a, 3)
	v_col_524 = J.arg(a, 4)
	J.sp(v_ctx_520, "strokeStyle", "#222")
	J.sp(v_ctx_520, "lineWidth", 1.0)
	J.mc(v_ctx_520, "beginPath", [])
	J.mc(v_ctx_520, "moveTo", [v_x_521, J.sub(v_y_522, 6.0)])
	J.mc(v_ctx_520, "lineTo", [v_x_521, J.sub(v_y_522, 2.0)])
	J.mc(v_ctx_520, "stroke", [])
	v_g_525 = J.mc(v_ctx_520, "createRadialGradient", [v_x_521, J.add(v_y_522, 5.0), 1.0, v_x_521, J.add(v_y_522, 5.0), 16.0])
	J.mc(v_g_525, "addColorStop", [0.0, "rgba(255,90,70,.35)"])
	J.mc(v_g_525, "addColorStop", [1.0, "rgba(255,90,70,0)"])
	J.sp(v_ctx_520, "fillStyle", v_g_525)
	J.mc(v_ctx_520, "fillRect", [J.sub(v_x_521, 16.0), J.sub(v_y_522, 11.0), 32.0, 32.0])
	var _t213 = env["el"]
	J.cl(_t213, null, [v_ctx_520, J.add(v_x_521, (sin(J.num(J.add(J.mul(v_t_523, 2.0), v_x_521))) * 0.8)), J.add(v_y_522, 5.0), 5.0, 7.0, (v_col_524 if J.t(v_col_524) else "#d8343c"), env["OUT"], 1.2])
	J.sp(v_ctx_520, "fillStyle", "#f2c14a")
	J.mc(v_ctx_520, "fillRect", [J.sub(v_x_521, 3.0), J.sub(v_y_522, 2.0), 6.0, 1.5])
	J.mc(v_ctx_520, "fillRect", [J.sub(v_x_521, 3.0), J.add(v_y_522, 11.0), 6.0, 1.5])

func _f51(this_, a: Array, env):
	var v_ctx_528 = null; var v_x_529 = null; var v_y_530 = null; var v_text_531 = null; var v_lv_532 = null; var v_w_533 = null; var v_sx_534 = null; var v_sy_535 = null
	v_ctx_528 = J.arg(a, 0)
	v_x_529 = J.arg(a, 1)
	v_y_530 = J.arg(a, 2)
	v_text_531 = J.arg(a, 3)
	v_lv_532 = J.arg(a, 4)
	J.mc(v_ctx_528, "save", [])
	var _t214 = "900 13px \"Songti TC\",\"Noto Serif CJK TC\",\"Noto Serif TC\",serif"
	J.sp(v_ctx_528, "font", _t214)
	v_w_533 = J.add(J.gp(J.mc(v_ctx_528, "measureText", [v_text_531]), "width"), 16.0)
	var _t215 = env["rr"]
	J.cl(_t215, null, [v_ctx_528, (J.sub(v_x_529, J.div(v_w_533, 2.0)) - 2.0), J.sub(v_y_530, 11.0), J.add(v_w_533, 4.0), 22.0, 2.0, "#1a0e08"])
	var _t216 = env["rr"]
	J.cl(_t216, null, [v_ctx_528, J.sub(v_x_529, J.div(v_w_533, 2.0)), J.sub(v_y_530, 9.0), v_w_533, 18.0, 1.0, "#3a1a10", "#c99a3e", 1.2])
	J.sp(v_ctx_528, "fillStyle", "#f3d68a")
	J.sp(v_ctx_528, "textAlign", "center")
	J.sp(v_ctx_528, "textBaseline", "middle")
	J.mc(v_ctx_528, "fillText", [v_text_531, v_x_529, J.add(v_y_530, 1.0)])
	if J.t(v_lv_532):
		v_sx_534 = J.add(J.add(v_x_529, J.div(v_w_533, 2.0)), 3.0)
		v_sy_535 = J.sub(v_y_530, 13.0)
		J.mc(v_ctx_528, "translate", [v_sx_534, v_sy_535])
		J.mc(v_ctx_528, "rotate", [0.12])
		var _t217 = env["rr"]
		J.cl(_t217, null, [v_ctx_528, (-1.0), (-8.0), 20.0, 16.0, 2.0, "#c2362b", "#f0c8b4", 1.0])
		J.sp(v_ctx_528, "fillStyle", "#fff3e0")
		J.sp(v_ctx_528, "font", "900 10px sans-serif")
		J.mc(v_ctx_528, "fillText", [v_lv_532, 9.0, 0.5])
	J.mc(v_ctx_528, "restore", [])

func _f52(this_, a: Array, env):
	var v_ctx_538 = null; var v_x_539 = null; var v_y_540 = null; var v_w_541 = null; var v_h_542 = null; var v_wall_543 = null; var v_roofCol_544 = null
	v_ctx_538 = J.arg(a, 0)
	v_x_539 = J.arg(a, 1)
	v_y_540 = J.arg(a, 2)
	v_w_541 = J.arg(a, 3)
	v_h_542 = J.arg(a, 4)
	v_wall_543 = J.arg(a, 5)
	v_roofCol_544 = J.arg(a, 6)
	var _t218 = env["rr"]
	J.cl(_t218, null, [v_ctx_538, J.sub(v_x_539, J.div(v_w_541, 2.0)), J.sub(v_y_540, v_h_542), v_w_541, v_h_542, 3.0, v_wall_543, env["OUT"], 2.0])
	J.sp(v_ctx_538, "fillStyle", "rgba(0,0,0,.15)")
	J.mc(v_ctx_538, "fillRect", [(J.sub(v_x_539, J.div(v_w_541, 2.0)) + 2.0), J.sub(v_y_540, 8.0), J.sub(v_w_541, 4.0), 6.0])

func _f63(this_, a: Array, env):
	var v_ctx_632 = null; var v_id_633 = null; var v_x_634 = null; var v_y_635 = null; var v_lv_636 = null; var v_t_637 = null; var v_extra_638 = null
	v_ctx_632 = J.arg(a, 0)
	v_id_633 = J.arg(a, 1)
	v_x_634 = J.arg(a, 2)
	v_y_635 = J.arg(a, 3)
	v_lv_636 = J.arg(a, 4)
	v_t_637 = J.arg(a, 5)
	v_extra_638 = J.arg(a, 6)
	var _t219 = env["BDRAW"]
	J.mc(_t219, v_id_633, [v_ctx_632, v_x_634, v_y_635, v_lv_636, v_t_637, v_extra_638])

func _f64(this_, a: Array, env):
	var v_ctx_641 = null; var v_x_642 = null; var v_y_643 = null; var v_name_644 = null; var v_w_645 = null
	v_ctx_641 = J.arg(a, 0)
	v_x_642 = J.arg(a, 1)
	v_y_643 = J.arg(a, 2)
	v_name_644 = J.arg(a, 3)
	J.mc(v_ctx_641, "save", [])
	var _t220 = "700 12px \"PingFang TC\",\"Noto Sans TC\",sans-serif"
	J.sp(v_ctx_641, "font", _t220)
	v_w_645 = J.max_([64.0, J.add(J.gp(J.mc(v_ctx_641, "measureText", [v_name_644]), "width"), 22.0)])
	var _t221 = env["el"]
	J.cl(_t221, null, [v_ctx_641, v_x_642, J.sub(v_y_643, 2.0), J.mul(v_w_645, 0.7), 9.0, "rgba(60,48,36,.45)"])
	J.mc(v_ctx_641, "setLineDash", [[3.0, 4.0]])
	J.sp(v_ctx_641, "strokeStyle", "rgba(236,217,164,.35)")
	J.sp(v_ctx_641, "lineWidth", 1.2)
	J.mc(v_ctx_641, "beginPath", [])
	J.mc(v_ctx_641, "ellipse", [v_x_642, J.sub(v_y_643, 2.0), J.mul(v_w_645, 0.7), 11.0, 0.0, 0.0, env["TAU"]])
	J.mc(v_ctx_641, "stroke", [])
	J.mc(v_ctx_641, "setLineDash", [[]])
	var _t222 = env["rr"]
	J.cl(_t222, null, [v_ctx_641, J.sub(v_x_642, 1.5), J.sub(v_y_643, 30.0), 3.0, 28.0, 1.0, "#5a4030"])
	var _t223 = env["rr"]
	J.cl(_t223, null, [v_ctx_641, J.sub(v_x_642, J.div(v_w_645, 2.0)), J.sub(v_y_643, 44.0), v_w_645, 20.0, 2.0, "#ecd9a4", "#5a4030", 1.5])
	J.sp(v_ctx_641, "fillStyle", "#2b1d12")
	J.sp(v_ctx_641, "textAlign", "center")
	J.sp(v_ctx_641, "textBaseline", "middle")
	J.mc(v_ctx_641, "fillText", [v_name_644, v_x_642, J.sub(v_y_643, 33.5)])
	J.sp(v_ctx_641, "fillStyle", "#c2362b")
	J.sp(v_ctx_641, "font", "900 10px sans-serif")
	J.mc(v_ctx_641, "fillText", ["待建", v_x_642, J.sub(v_y_643, 14.0)])
	J.mc(v_ctx_641, "restore", [])

func _f65(this_, a: Array, env):
	var v_ctx_648 = null; var v_x_649 = null; var v_y_650 = null; var v_s_651 = null; var v_ph_652 = null; var v_dir_653 = null; var v_perched_654 = null; var v_w_655 = null
	v_ctx_648 = J.arg(a, 0)
	v_x_649 = J.arg(a, 1)
	v_y_650 = J.arg(a, 2)
	v_s_651 = J.arg(a, 3)
	v_ph_652 = J.arg(a, 4)
	v_dir_653 = J.arg(a, 5)
	v_perched_654 = J.arg(a, 6)
	J.mc(v_ctx_648, "save", [])
	J.mc(v_ctx_648, "translate", [v_x_649, v_y_650])
	J.mc(v_ctx_648, "scale", [((-J.num(v_s_651)) if J.cmp(v_dir_653, 0.0, "<") else v_s_651), v_s_651])
	if J.t(v_perched_654):
		var _t224 = env["el"]
		J.cl(_t224, null, [v_ctx_648, 0.0, 0.0, 6.0, 4.2, "#121014", "#000", 0.8])
		var _t225 = env["el"]
		J.cl(_t225, null, [v_ctx_648, 4.5, (-3.5), 3.0, 2.8, "#121014"])
		var _t226 = env["poly"]
		J.cl(_t226, null, [v_ctx_648, [7.0, (-4.0), 10.5, (-3.0), 7.0, (-2.4)], "#5a524a"])
		var _t227 = env["el"]
		J.cl(_t227, null, [v_ctx_648, 5.4, (-4.2), 0.7, 0.7, "#e03a3a"])
		var _t228 = env["poly"]
		J.cl(_t228, null, [v_ctx_648, [(-5.0), (-1.0), (-11.0), 2.0, (-6.0), 2.5], "#0c0a0e"])
		J.sp(v_ctx_648, "strokeStyle", "#3a3530")
		J.sp(v_ctx_648, "lineWidth", 0.8)
		J.mc(v_ctx_648, "beginPath", [])
		J.mc(v_ctx_648, "moveTo", [(-1.0), 4.0])
		J.mc(v_ctx_648, "lineTo", [(-1.0), 6.5])
		J.mc(v_ctx_648, "moveTo", [1.5, 4.0])
		J.mc(v_ctx_648, "lineTo", [1.5, 6.5])
		J.mc(v_ctx_648, "stroke", [])
	else:
		v_w_655 = (sin(J.num(v_ph_652)) * 7.0)
		var _t229 = env["poly"]
		J.cl(_t229, null, [v_ctx_648, [(-2.0), 0.0, (-7.0), J.sub((-6.0), v_w_655), 2.0, (-1.0)], "#0c0a0e", "#6a6078", 0.7])
		var _t230 = env["poly"]
		J.cl(_t230, null, [v_ctx_648, [(-1.0), 0.0, (-4.0), (6.0 + J.mul(v_w_655, 0.4)), 3.0, 0.0], "#16141a"])
		var _t231 = env["el"]
		J.cl(_t231, null, [v_ctx_648, 0.0, 0.0, 6.0, 3.2, "#121014", "#6a6078", 0.7])
		var _t232 = env["el"]
		J.cl(_t232, null, [v_ctx_648, 5.0, (-1.0), 2.6, 2.4, "#121014", "#6a6078", 0.6])
		var _t233 = env["poly"]
		J.cl(_t233, null, [v_ctx_648, [7.0, (-1.6), 10.5, (-0.6), 7.0, 0.2], "#5a524a"])
		var _t234 = env["poly"]
		J.cl(_t234, null, [v_ctx_648, [(-5.0), (-0.5), (-10.0), (-2.5), (-10.0), 2.0], "#0c0a0e"])
		var _t235 = env["el"]
		J.cl(_t235, null, [v_ctx_648, 5.8, (-1.6), 0.6, 0.6, "#e03a3a"])
	J.mc(v_ctx_648, "restore", [])

func _f67(this_, a: Array, env):
	var v_x1_673 = null; var v_y1_674 = null; var v_x2_675 = null; var v_y2_676 = null; var v_cx_677 = null; var v_cy_678 = null; var v_w_679 = null
	v_x1_673 = J.arg(a, 0)
	v_y1_674 = J.arg(a, 1)
	v_x2_675 = J.arg(a, 2)
	v_y2_676 = J.arg(a, 3)
	v_cx_677 = J.arg(a, 4)
	v_cy_678 = J.arg(a, 5)
	v_w_679 = J.arg(a, 6)
	var _t253 = env["ctx"]
	J.sp(_t253, "strokeStyle", "#2b2321")
	var _t254 = env["ctx"]
	J.sp(_t254, "lineCap", "round")
	var _t255 = env["ctx"]
	var _t256 = J.add(v_w_679, 1.6)
	J.sp(_t255, "lineWidth", _t256)
	J.mc(env["ctx"], "beginPath", [])
	J.mc(env["ctx"], "moveTo", [v_x1_673, v_y1_674])
	J.mc(env["ctx"], "quadraticCurveTo", [v_cx_677, v_cy_678, v_x2_675, v_y2_676])
	var _t257 = env["ctx"]
	var _t258 = env["__p"]["OUT"]
	J.sp(_t257, "strokeStyle", _t258)
	J.mc(env["ctx"], "stroke", [])
	var _t259 = env["ctx"]
	J.sp(_t259, "lineWidth", v_w_679)
	var _t260 = env["ctx"]
	J.sp(_t260, "strokeStyle", "#2b2321")
	J.mc(env["ctx"], "stroke", [])

func _f68(this_, a: Array, env):
	var v_dx_680 = null; var v_dy_681 = null; var v_rx_682 = null; var v_ry_683 = null; var v_c_684 = null
	var _t262 = J.gp(J.arg(a, 0), 0.0)
	v_dx_680 = _t262
	var _t263 = J.gp(J.arg(a, 0), 1.0)
	v_dy_681 = _t263
	var _t264 = J.gp(J.arg(a, 0), 2.0)
	v_rx_682 = _t264
	var _t265 = J.gp(J.arg(a, 0), 3.0)
	v_ry_683 = _t265
	var _t266 = J.gp(J.arg(a, 0), 4.0)
	v_c_684 = _t266
	var _t267 = env["ctx"]
	J.sp(_t267, "globalAlpha", 0.92)
	var _t268 = env["__p"]["el"]
	J.cl(_t268, null, [env["ctx"], J.add(env["x"], v_dx_680), J.add(env["y"], v_dy_681), v_rx_682, v_ry_683, v_c_684, env["__p"]["OUT"], 1.0])
	var _t269 = env["ctx"]
	J.sp(_t269, "globalAlpha", 1.0)

func _f69(this_, a: Array, env):
	var v_dx_685 = null; var v_dy_686 = null; var v_d_687 = null; var v_k_688 = null
	var _t277 = J.gp(J.arg(a, 0), 0.0)
	v_dx_685 = _t277
	var _t278 = J.gp(J.arg(a, 0), 1.0)
	v_dy_686 = _t278
	var _t279 = J.gp(J.arg(a, 0), 2.0)
	v_d_687 = _t279
	v_k_688 = J.arg(a, 1)
	var _t280 = J.seq(v_k_688, 2.0)
	if (J.seq(env["v"], 2.0) if _t280 else _t280):
		return null
	var _t281 = env["__p"]["drawCrow"]
	J.cl(_t281, null, [env["ctx"], J.add(J.add(env["x"], v_dx_685), env["sx"]), J.sub(J.add(env["y"], v_dy_686), 3.0), 0.75, 0.0, v_d_687, true])

func _f66(this_, a: Array, env):
	var v_hp_661 = null; var v_t_662 = null; var v_shake_663 = null; var v_perched_664 = null; var v_idx_665 = null; var v_glow_668 = null; var v_br_669 = null; var v_c1_670 = null; var v_c2_671 = null; var v_sw_672 = null
	var _s165 = {"__p": env, "ctx": null, "x": null, "y": null, "sx": null, "v": null}
	_s165["ctx"] = J.arg(a, 0)
	_s165["x"] = J.arg(a, 1)
	_s165["y"] = J.arg(a, 2)
	v_hp_661 = J.arg(a, 3)
	v_t_662 = J.arg(a, 4)
	v_shake_663 = J.arg(a, 5)
	v_perched_664 = J.arg(a, 6)
	v_idx_665 = J.arg(a, 7)
	_s165["sx"] = ((sin(J.num(J.mul(v_t_662, 60.0))) * 2.2) if J.t(v_shake_663) else 0.0)
	_s165["v"] = J.mod((v_idx_665 if J.t(v_idx_665) else 0.0), 3.0)
	var _t236 = _s165["__p"]["el"]
	J.cl(_t236, null, [_s165["ctx"], _s165["x"], J.add(_s165["y"], 2.0), 18.0, 5.0, "rgba(0,0,0,.4)"])
	if J.cmp(v_hp_661, 0.0, "<="):
		var _t237 = _s165["__p"]["rr"]
		J.cl(_t237, null, [_s165["ctx"], J.sub(_s165["x"], 8.0), J.sub(_s165["y"], 8.0), 16.0, 9.0, 2.0, "#2a2220", _s165["__p"]["OUT"], 1.2])
		var _t238 = _s165["__p"]["el"]
		J.cl(_t238, null, [_s165["ctx"], _s165["x"], J.sub(_s165["y"], 8.0), 8.0, 2.8, "#6a4a3a", _s165["__p"]["OUT"], 1.0])
		var _t239 = _s165["__p"]["el"]
		J.cl(_t239, null, [_s165["ctx"], _s165["x"], J.sub(_s165["y"], 8.0), 4.0, 1.4, "#8a2a24"])
		var _t240 = _s165["ctx"]
		J.sp(_t240, "strokeStyle", "rgba(140,30,30,.7)")
		var _t241 = _s165["ctx"]
		J.sp(_t241, "lineWidth", 1.2)
		J.mc(_s165["ctx"], "beginPath", [])
		J.mc(_s165["ctx"], "moveTo", [J.add(_s165["x"], 3.0), J.sub(_s165["y"], 7.0)])
		J.mc(_s165["ctx"], "quadraticCurveTo", [J.add(_s165["x"], 4.0), J.sub(_s165["y"], 3.0), J.add(_s165["x"], 3.0), J.add(_s165["y"], 1.0)])
		J.mc(_s165["ctx"], "stroke", [])
		return null
	J.mc(_s165["ctx"], "save", [])
	J.mc(_s165["ctx"], "translate", [_s165["sx"], 0.0])
	J.mc(_s165["ctx"], "beginPath", [])
	J.mc(_s165["ctx"], "moveTo", [J.sub(_s165["x"], 9.0), J.add(_s165["y"], 1.0)])
	J.mc(_s165["ctx"], "quadraticCurveTo", [J.sub(_s165["x"], 4.0), J.sub(_s165["y"], 14.0), J.sub(_s165["x"], 8.0), J.sub(_s165["y"], 26.0)])
	J.mc(_s165["ctx"], "quadraticCurveTo", [J.sub(_s165["x"], 9.0), J.sub(_s165["y"], 34.0), J.sub(_s165["x"], 3.0), J.sub(_s165["y"], 40.0)])
	J.mc(_s165["ctx"], "lineTo", [J.add(_s165["x"], 4.0), J.sub(_s165["y"], 40.0)])
	J.mc(_s165["ctx"], "quadraticCurveTo", [J.add(_s165["x"], 9.0), J.sub(_s165["y"], 30.0), J.add(_s165["x"], 5.0), J.sub(_s165["y"], 20.0)])
	J.mc(_s165["ctx"], "quadraticCurveTo", [J.add(_s165["x"], 3.0), J.sub(_s165["y"], 8.0), J.add(_s165["x"], 10.0), J.add(_s165["y"], 1.0)])
	J.mc(_s165["ctx"], "closePath", [])
	var _t242 = _s165["ctx"]
	J.sp(_t242, "fillStyle", "#2b2321")
	J.mc(_s165["ctx"], "fill", [])
	var _t243 = _s165["ctx"]
	var _t244 = _s165["__p"]["OUT"]
	J.sp(_t243, "strokeStyle", _t244)
	var _t245 = _s165["ctx"]
	J.sp(_t245, "lineWidth", 1.6)
	J.mc(_s165["ctx"], "stroke", [])
	var _t246 = _s165["ctx"]
	J.sp(_t246, "strokeStyle", "rgba(0,0,0,.45)")
	var _t247 = _s165["ctx"]
	J.sp(_t247, "lineWidth", 1.0)
	J.mc(_s165["ctx"], "beginPath", [])
	J.mc(_s165["ctx"], "moveTo", [J.sub(_s165["x"], 4.0), J.sub(_s165["y"], 2.0)])
	J.mc(_s165["ctx"], "quadraticCurveTo", [J.sub(_s165["x"], 1.0), J.sub(_s165["y"], 14.0), J.sub(_s165["x"], 5.0), J.sub(_s165["y"], 30.0)])
	J.mc(_s165["ctx"], "moveTo", [J.add(_s165["x"], 4.0), J.sub(_s165["y"], 4.0)])
	J.mc(_s165["ctx"], "quadraticCurveTo", [J.add(_s165["x"], 2.0), J.sub(_s165["y"], 18.0), J.add(_s165["x"], 3.0), J.sub(_s165["y"], 34.0)])
	J.mc(_s165["ctx"], "stroke", [])
	var _t248 = _s165["__p"]["el"]
	J.cl(_t248, null, [_s165["ctx"], J.sub(_s165["x"], 2.8), J.sub(_s165["y"], 21.0), 2.0, 2.8, "#0a0708"])
	var _t249 = _s165["__p"]["el"]
	J.cl(_t249, null, [_s165["ctx"], J.add(_s165["x"], 2.8), J.sub(_s165["y"], 21.5), 2.0, 2.6, "#0a0708"])
	v_glow_668 = (0.45 + (sin(J.num(J.add(J.mul(v_t_662, 1.7), _s165["x"]))) * 0.35))
	var _t250 = _s165["__p"]["el"]
	J.cl(_t250, null, [_s165["ctx"], J.sub(_s165["x"], 2.8), J.sub(_s165["y"], 20.5), 0.8, 0.8, ("rgba(255,60,50," + J.str(v_glow_668) + ")")])
	var _t251 = _s165["__p"]["el"]
	J.cl(_t251, null, [_s165["ctx"], J.add(_s165["x"], 2.8), J.sub(_s165["y"], 21.0), 0.8, 0.8, ("rgba(255,60,50," + J.str(v_glow_668) + ")")])
	var _t252 = _s165["__p"]["el"]
	J.cl(_t252, null, [_s165["ctx"], _s165["x"], J.sub(_s165["y"], 14.0), 1.8, 3.0, "#0a0708"])
	v_br_669 = Callable(self, "_f67").bind(_s165)
	J.cl(v_br_669, null, [J.sub(_s165["x"], 4.0), J.sub(_s165["y"], 38.0), J.sub(_s165["x"], 24.0), J.sub(_s165["y"], 46.0), J.sub(_s165["x"], 12.0), J.sub(_s165["y"], 48.0), 3.0])
	J.cl(v_br_669, null, [J.sub(_s165["x"], 20.0), J.sub(_s165["y"], 46.0), J.sub(_s165["x"], 27.0), J.sub(_s165["y"], 56.0), J.sub(_s165["x"], 26.0), J.sub(_s165["y"], 49.0), 1.4])
	J.cl(v_br_669, null, [J.add(_s165["x"], 2.0), J.sub(_s165["y"], 39.0), J.add(_s165["x"], 20.0), J.sub(_s165["y"], 52.0), J.add(_s165["x"], 14.0), J.sub(_s165["y"], 40.0), 3.0])
	J.cl(v_br_669, null, [J.add(_s165["x"], 17.0), J.sub(_s165["y"], 49.0), J.add(_s165["x"], 27.0), J.sub(_s165["y"], 50.0), J.add(_s165["x"], 22.0), J.sub(_s165["y"], 47.0), 1.4])
	J.cl(v_br_669, null, [_s165["x"], J.sub(_s165["y"], 40.0), J.sub(_s165["x"], 4.0), J.sub(_s165["y"], 66.0), J.add(_s165["x"], 4.0), J.sub(_s165["y"], 54.0), 2.6])
	J.cl(v_br_669, null, [J.sub(_s165["x"], 3.0), J.sub(_s165["y"], 60.0), J.add(_s165["x"], 8.0), J.sub(_s165["y"], 70.0), J.add(_s165["x"], 1.0), J.sub(_s165["y"], 68.0), 1.3])
	v_c1_670 = J.gp(["#17221c", "#1b241a", "#202018"], _s165["v"])
	v_c2_671 = J.gp(["#1e2b22", "#22291c", "#26261c"], _s165["v"])
	var _t261 = [[(-24.0), (-52.0), 8.0, 6.0, v_c1_670], [(-14.0), (-60.0), 9.0, 6.5, v_c2_671], [6.0, (-66.0), 10.0, 6.5, v_c1_670], [20.0, (-56.0), 9.0, 6.0, v_c2_671], [(-2.0), (-56.0), 8.0, 5.0, v_c1_670]]
	J.mc(_t261, "forEach", [Callable(self, "_f68").bind(_s165)])
	v_sw_672 = (sin(J.num((J.mul(v_t_662, 1.8) + J.mul(_s165["x"], 0.1)))) * 0.18)
	J.mc(_s165["ctx"], "save", [])
	J.mc(_s165["ctx"], "translate", [J.add(_s165["x"], 18.0), J.sub(_s165["y"], 48.0)])
	J.mc(_s165["ctx"], "rotate", [v_sw_672])
	var _t270 = _s165["ctx"]
	J.sp(_t270, "strokeStyle", "#b8262a")
	var _t271 = _s165["ctx"]
	J.sp(_t271, "lineWidth", 1.0)
	J.mc(_s165["ctx"], "beginPath", [])
	J.mc(_s165["ctx"], "moveTo", [0.0, 0.0])
	J.mc(_s165["ctx"], "lineTo", [0.0, 9.0])
	J.mc(_s165["ctx"], "stroke", [])
	var _t272 = _s165["__p"]["rr"]
	J.cl(_t272, null, [_s165["ctx"], (-2.6), 9.0, 5.2, 11.0, 0.5, "#e8c44a", "#8a6a1a", 0.7])
	var _t273 = _s165["ctx"]
	J.sp(_t273, "strokeStyle", "#b8262a")
	var _t274 = _s165["ctx"]
	J.sp(_t274, "lineWidth", 0.7)
	J.mc(_s165["ctx"], "beginPath", [])
	J.mc(_s165["ctx"], "moveTo", [0.0, 10.5])
	J.mc(_s165["ctx"], "quadraticCurveTo", [1.6, 12.5, (-0.6), 14.0])
	J.mc(_s165["ctx"], "quadraticCurveTo", [(-1.8), 15.6, 0.8, 17.0])
	J.mc(_s165["ctx"], "lineTo", [0.0, 19.0])
	J.mc(_s165["ctx"], "stroke", [])
	var _t275 = _s165["__p"]["el"]
	J.cl(_t275, null, [_s165["ctx"], 0.0, 11.2, 0.9, 0.9, null, "#b8262a", 0.6])
	J.mc(_s165["ctx"], "restore", [])
	if (not J.seq(_s165["v"], 1.0)):
		J.mc(_s165["ctx"], "save", [])
		J.mc(_s165["ctx"], "translate", [J.sub(_s165["x"], 22.0), J.sub(_s165["y"], 46.0)])
		J.mc(_s165["ctx"], "rotate", [((-J.num(v_sw_672)) * 1.4)])
		J.mc(_s165["ctx"], "beginPath", [])
		J.mc(_s165["ctx"], "moveTo", [(-1.5), 0.0])
		J.mc(_s165["ctx"], "quadraticCurveTo", [((-3.0) + (sin(J.num(J.mul(v_t_662, 2.5))) * 2.0)), 9.0, ((-1.0) + (sin(J.num(J.mul(v_t_662, 2.2))) * 3.0)), 17.0])
		J.mc(_s165["ctx"], "lineTo", [(2.0 + (sin(J.num(J.mul(v_t_662, 2.2))) * 3.0)), 16.0])
		J.mc(_s165["ctx"], "quadraticCurveTo", [(0.0 + (sin(J.num(J.mul(v_t_662, 2.5))) * 2.0)), 8.0, 1.5, 0.0])
		J.mc(_s165["ctx"], "closePath", [])
		var _t276 = _s165["ctx"]
		J.sp(_t276, "fillStyle", "rgba(232,228,216,.85)")
		J.mc(_s165["ctx"], "fill", [])
		J.mc(_s165["ctx"], "restore", [])
	J.mc(_s165["ctx"], "restore", [])
	if J.t(v_perched_664):
		J.mc(_s165["__p"]["PERCH"], "forEach", [Callable(self, "_f69").bind(_s165)])

func _f70(this_, a: Array, env):
	var v_ctx_691 = null; var v_cx_692 = null; var v_cy_693 = null; var v_r_694 = null; var v_a0_695 = null; var v_a1_696 = null; var v_alpha_697 = null; var v_n_698 = null; var v_k_699 = null; var v_a_700 = null; var v_ring_701 = null; var v_rr2_702 = null; var v_k_703 = null; var v_a_704 = null; var v_sag_705 = null; var v_px_706 = null; var v_py_707 = null
	v_ctx_691 = J.arg(a, 0)
	v_cx_692 = J.arg(a, 1)
	v_cy_693 = J.arg(a, 2)
	v_r_694 = J.arg(a, 3)
	v_a0_695 = J.arg(a, 4)
	v_a1_696 = J.arg(a, 5)
	v_alpha_697 = J.arg(a, 6)
	J.mc(v_ctx_691, "save", [])
	var _t282 = ("rgba(225,225,235," + J.str((v_alpha_697 if J.t(v_alpha_697) else 0.38)) + ")")
	J.sp(v_ctx_691, "strokeStyle", _t282)
	J.sp(v_ctx_691, "lineWidth", 0.6)
	v_n_698 = 7.0
	v_k_699 = 0.0
	while true:
		if not J.cmp(v_k_699, v_n_698, "<="): break
		v_a_700 = J.add(v_a0_695, J.div(J.mul(J.sub(v_a1_696, v_a0_695), v_k_699), v_n_698))
		J.mc(v_ctx_691, "beginPath", [])
		J.mc(v_ctx_691, "moveTo", [v_cx_692, v_cy_693])
		J.mc(v_ctx_691, "lineTo", [J.add(v_cx_692, J.mul(cos(J.num(v_a_700)), v_r_694)), J.add(v_cy_693, J.mul(sin(J.num(v_a_700)), v_r_694))])
		J.mc(v_ctx_691, "stroke", [])
		v_k_699 = J.num(v_k_699) + 1.0
	v_ring_701 = 1.0
	while true:
		if not J.cmp(v_ring_701, 5.0, "<="): break
		v_rr2_702 = J.div(J.mul(v_r_694, v_ring_701), 5.4)
		J.mc(v_ctx_691, "beginPath", [])
		v_k_703 = 0.0
		while true:
			if not J.cmp(v_k_703, v_n_698, "<="): break
			v_a_704 = J.add(v_a0_695, J.div(J.mul(J.sub(v_a1_696, v_a0_695), v_k_703), v_n_698))
			v_sag_705 = (0.88 if J.t(J.mod(v_k_703, 2.0)) else 1.0)
			v_px_706 = J.add(v_cx_692, J.mul(J.mul(cos(J.num(v_a_704)), v_rr2_702), v_sag_705))
			v_py_707 = J.add(v_cy_693, J.mul(J.mul(sin(J.num(v_a_704)), v_rr2_702), v_sag_705))
			if J.t(v_k_703):
				J.mc(v_ctx_691, "lineTo", [v_px_706, v_py_707])
			else:
				J.mc(v_ctx_691, "moveTo", [v_px_706, v_py_707])
			v_k_703 = J.num(v_k_703) + 1.0
		J.mc(v_ctx_691, "stroke", [])
		v_ring_701 = J.num(v_ring_701) + 1.0
	J.mc(v_ctx_691, "restore", [])

func _f71(this_, a: Array, env):
	var v_ctx_710 = null; var v_x_711 = null; var v_y_712 = null; var v_top_713 = null; var v_s_714 = null; var v_k_715 = null; var v_dy_716 = null
	v_ctx_710 = J.arg(a, 0)
	v_x_711 = J.arg(a, 1)
	v_y_712 = J.arg(a, 2)
	v_top_713 = J.arg(a, 3)
	v_s_714 = J.arg(a, 4)
	J.sp(v_ctx_710, "strokeStyle", "rgba(220,220,230,.45)")
	J.sp(v_ctx_710, "lineWidth", 0.6)
	J.mc(v_ctx_710, "beginPath", [])
	J.mc(v_ctx_710, "moveTo", [v_x_711, v_top_713])
	J.mc(v_ctx_710, "lineTo", [v_x_711, J.sub(v_y_712, J.mul(2.0, v_s_714))])
	J.mc(v_ctx_710, "stroke", [])
	J.sp(v_ctx_710, "strokeStyle", "#0c0a0e")
	var _t283 = J.mul(0.9, v_s_714)
	J.sp(v_ctx_710, "lineWidth", _t283)
	v_k_715 = 0.0
	while true:
		if not J.cmp(v_k_715, 4.0, "<"): break
		v_dy_716 = J.add((-1.5), v_k_715)
		J.mc(v_ctx_710, "beginPath", [])
		J.mc(v_ctx_710, "moveTo", [J.sub(v_x_711, 1.0), J.add(v_y_712, (J.mul(v_dy_716, v_s_714) * 0.6))])
		J.mc(v_ctx_710, "quadraticCurveTo", [J.sub(v_x_711, J.mul(4.0, v_s_714)), J.add(v_y_712, J.mul(J.sub(v_dy_716, 2.0), v_s_714)), J.sub(v_x_711, J.mul(5.0, v_s_714)), J.add(v_y_712, J.mul(J.add(v_dy_716, 1.5), v_s_714))])
		J.mc(v_ctx_710, "moveTo", [J.add(v_x_711, 1.0), J.add(v_y_712, (J.mul(v_dy_716, v_s_714) * 0.6))])
		J.mc(v_ctx_710, "quadraticCurveTo", [J.add(v_x_711, J.mul(4.0, v_s_714)), J.add(v_y_712, J.mul(J.sub(v_dy_716, 2.0), v_s_714)), J.add(v_x_711, J.mul(5.0, v_s_714)), J.add(v_y_712, J.mul(J.add(v_dy_716, 1.5), v_s_714))])
		J.mc(v_ctx_710, "stroke", [])
		v_k_715 = J.num(v_k_715) + 1.0
	var _t284 = env["el"]
	J.cl(_t284, null, [v_ctx_710, v_x_711, J.add(v_y_712, J.mul(1.5, v_s_714)), J.mul(2.6, v_s_714), J.mul(3.0, v_s_714), "#100c10"])
	var _t285 = env["el"]
	J.cl(_t285, null, [v_ctx_710, v_x_711, J.sub(v_y_712, J.mul(1.2, v_s_714)), J.mul(1.6, v_s_714), J.mul(1.5, v_s_714), "#100c10"])
	var _t286 = env["el"]
	J.cl(_t286, null, [v_ctx_710, v_x_711, J.add(v_y_712, J.mul(1.6, v_s_714)), J.mul(0.9, v_s_714), J.mul(1.2, v_s_714), "#a01818"])

func _f72(this_, a: Array, env):
	var v_ctx_719 = null; var v_x_720 = null; var v_y_721 = null; var v_ripe_722 = null; var v_t_723 = null; var v_i_724 = null; var v_a_725 = null; var v_b_726 = null; var v_bx_727 = null; var v_by_728 = null; var v_sway_729 = null
	v_ctx_719 = J.arg(a, 0)
	v_x_720 = J.arg(a, 1)
	v_y_721 = J.arg(a, 2)
	v_ripe_722 = J.arg(a, 3)
	v_t_723 = J.arg(a, 4)
	v_i_724 = J.arg(a, 5)
	var _t287 = env["rr"]
	J.cl(_t287, null, [v_ctx_719, J.sub(v_x_720, 24.0), J.sub(v_y_721, 15.0), 48.0, 20.0, 3.0, "#151b17", "#0c100d", 1.5])
	J.sp(v_ctx_719, "fillStyle", "rgba(80,110,100,.12)")
	J.mc(v_ctx_719, "fillRect", [J.sub(v_x_720, 22.0), J.sub(v_y_721, 2.0), 44.0, 3.0])
	v_a_725 = 0.0
	while true:
		if not J.cmp(v_a_725, 5.0, "<"): break
		v_b_726 = 0.0
		while true:
			if not J.cmp(v_b_726, 2.0, "<"): break
			v_bx_727 = (J.sub(v_x_720, 17.0) + J.mul(v_a_725, 8.5))
			v_by_728 = (J.sub(v_y_721, 7.0) + J.mul(v_b_726, 8.0))
			v_sway_729 = (sin(J.num(J.add(J.add(J.mul(v_t_723, 1.4), v_a_725), v_b_726))) * 0.8)
			if J.t(v_ripe_722):
				J.sp(v_ctx_719, "strokeStyle", "#7a7048")
				J.sp(v_ctx_719, "lineWidth", 1.5)
				J.mc(v_ctx_719, "beginPath", [])
				J.mc(v_ctx_719, "moveTo", [v_bx_727, v_by_728])
				J.mc(v_ctx_719, "quadraticCurveTo", [J.add(v_bx_727, 1.0), J.sub(v_by_728, 10.0), J.add(J.add(v_bx_727, 5.0), v_sway_729), J.sub(v_by_728, 9.0)])
				J.mc(v_ctx_719, "stroke", [])
				var _t288 = env["el"]
				J.cl(_t288, null, [v_ctx_719, J.add(J.add(v_bx_727, 5.0), v_sway_729), J.sub(v_by_728, 8.0), 1.6, 2.6, "#c8bc8a"])
				var _t289 = env["el"]
				J.cl(_t289, null, [v_ctx_719, J.add(J.add(v_bx_727, 3.5), v_sway_729), J.sub(v_by_728, 10.0), 1.4, 2.2, "#b0a474"])
			else:
				J.sp(v_ctx_719, "strokeStyle", "#3a4430")
				J.sp(v_ctx_719, "lineWidth", 1.3)
				J.mc(v_ctx_719, "beginPath", [])
				J.mc(v_ctx_719, "moveTo", [v_bx_727, v_by_728])
				J.mc(v_ctx_719, "lineTo", [J.add(J.add(v_bx_727, 1.5), v_sway_729), J.sub(v_by_728, 4.0)])
				J.mc(v_ctx_719, "stroke", [])
			v_b_726 = J.num(v_b_726) + 1.0
		v_a_725 = J.num(v_a_725) + 1.0
	var _t290 = env["drawWeb"]
	J.cl(_t290, null, [v_ctx_719, J.sub(v_x_720, 22.0), J.sub(v_y_721, 13.0), 12.0, 0.0, J.div(PI, 2.0), 0.42])
	if J.seq(J.mod((v_i_724 if J.t(v_i_724) else 0.0), 2.0), 0.0):
		var _t291 = env["drawSpider"]
		J.cl(_t291, null, [v_ctx_719, J.add(v_x_720, 14.0), (J.sub(v_y_721, 16.0) + (sin(J.num(J.add(J.mul(v_t_723, 1.3), (v_i_724 if J.t(v_i_724) else 0.0)))) * 3.0)), J.sub(v_y_721, 34.0), 0.9])

func _f74(this_, a: Array, env):
	var v_d_737 = null; var v_k_738 = null
	v_d_737 = J.arg(a, 0)
	v_k_738 = 0.0
	while true:
		if not J.cmp(v_k_738, 3.0, "<"): break
		J.mc(env["ctx"], "beginPath", [])
		J.mc(env["ctx"], "moveTo", [v_d_737, (-35.0)])
		J.mc(env["ctx"], "lineTo", [J.add(v_d_737, J.mul(signf(J.num(v_d_737)), J.add(3.0, v_k_738))), ((-32.0) + J.mul(v_k_738, 2.0))])
		J.mc(env["ctx"], "stroke", [])
		v_k_738 = J.num(v_k_738) + 1.0

func _f73(this_, a: Array, env):
	var v_x_733 = null; var v_y_734 = null; var v_t_735 = null; var v_sw_736 = null; var v_k_739 = null
	var _s187 = {"__p": env, "ctx": null}
	_s187["ctx"] = J.arg(a, 0)
	v_x_733 = J.arg(a, 1)
	v_y_734 = J.arg(a, 2)
	v_t_735 = J.arg(a, 3)
	v_sw_736 = (sin(J.num(J.mul(v_t_735, 0.9))) * 0.05)
	var _t292 = _s187["__p"]["el"]
	J.cl(_t292, null, [_s187["ctx"], v_x_733, J.add(v_y_734, 2.0), 12.0, 3.5, "rgba(0,0,0,.35)"])
	J.mc(_s187["ctx"], "save", [])
	J.mc(_s187["ctx"], "translate", [v_x_733, v_y_734])
	J.mc(_s187["ctx"], "rotate", [v_sw_736])
	var _t293 = _s187["__p"]["rr"]
	J.cl(_t293, null, [_s187["ctx"], (-1.6), (-46.0), 3.2, 46.0, 1.0, "#4a3424", _s187["__p"]["OUT"], 1.0])
	var _t294 = _s187["__p"]["rr"]
	J.cl(_t294, null, [_s187["ctx"], (-20.0), (-36.0), 40.0, 3.0, 1.0, "#4a3424", _s187["__p"]["OUT"], 1.0])
	var _t295 = _s187["__p"]["poly"]
	J.cl(_t295, null, [_s187["ctx"], [(-12.0), (-37.0), 12.0, (-37.0), 15.0, (-14.0), 8.0, (-18.0), 3.0, (-12.0), (-3.0), (-17.0), (-9.0), (-12.0), (-15.0), (-16.0)], "#4a3a40", _s187["__p"]["OUT"], 1.3])
	var _t296 = _s187["ctx"]
	J.sp(_t296, "strokeStyle", "#a89058")
	var _t297 = _s187["ctx"]
	J.sp(_t297, "lineWidth", 1.0)
	var _t298 = [(-19.0), 19.0]
	J.mc(_t298, "forEach", [Callable(self, "_f74").bind(_s187)])
	var _t299 = _s187["__p"]["el"]
	J.cl(_t299, null, [_s187["ctx"], 0.0, (-46.0), 9.0, 9.5, "#b8a47a", _s187["__p"]["OUT"], 1.4])
	var _t300 = _s187["ctx"]
	J.sp(_t300, "strokeStyle", "#2a1a10")
	var _t301 = _s187["ctx"]
	J.sp(_t301, "lineWidth", 1.2)
	J.mc(_s187["ctx"], "beginPath", [])
	J.mc(_s187["ctx"], "moveTo", [(-5.0), (-49.0)])
	J.mc(_s187["ctx"], "lineTo", [(-2.0), (-46.0)])
	J.mc(_s187["ctx"], "moveTo", [(-2.0), (-49.0)])
	J.mc(_s187["ctx"], "lineTo", [(-5.0), (-46.0)])
	J.mc(_s187["ctx"], "moveTo", [2.0, (-49.0)])
	J.mc(_s187["ctx"], "lineTo", [5.0, (-46.0)])
	J.mc(_s187["ctx"], "moveTo", [5.0, (-49.0)])
	J.mc(_s187["ctx"], "lineTo", [2.0, (-46.0)])
	J.mc(_s187["ctx"], "stroke", [])
	J.mc(_s187["ctx"], "beginPath", [])
	J.mc(_s187["ctx"], "moveTo", [(-5.0), (-41.0)])
	J.mc(_s187["ctx"], "lineTo", [5.0, (-41.0)])
	J.mc(_s187["ctx"], "stroke", [])
	v_k_739 = (-4.0)
	while true:
		if not J.cmp(v_k_739, 4.0, "<="): break
		J.mc(_s187["ctx"], "beginPath", [])
		J.mc(_s187["ctx"], "moveTo", [v_k_739, (-43.0)])
		J.mc(_s187["ctx"], "lineTo", [v_k_739, (-39.0)])
		J.mc(_s187["ctx"], "stroke", [])
		var _t302 = J.add(v_k_739, 2.0)
		v_k_739 = _t302
	var _t303 = _s187["__p"]["poly"]
	J.cl(_t303, null, [_s187["ctx"], [(-11.0), (-52.0), 11.0, (-52.0), 6.0, (-62.0), (-5.0), (-61.0)], "#3a2a1a", _s187["__p"]["OUT"], 1.2])
	J.mc(_s187["ctx"], "restore", [])
	var _t304 = _s187["__p"]["drawCrow"]
	J.cl(_t304, null, [_s187["ctx"], J.add(v_x_733, 18.0), J.sub(v_y_734, 40.0), 0.7, 0.0, (-1.0), true])

func _f75(this_, a: Array, env):
	var v_ctx_742 = null; var v_x_743 = null; var v_y_744 = null; var v_t_745 = null; var v_fy_746 = null; var v_a_747 = null; var v_g_748 = null
	v_ctx_742 = J.arg(a, 0)
	v_x_743 = J.arg(a, 1)
	v_y_744 = J.arg(a, 2)
	v_t_745 = J.arg(a, 3)
	v_fy_746 = J.add(v_y_744, (sin(J.num(J.add(J.mul(v_t_745, 1.6), v_x_743))) * 5.0))
	v_a_747 = (0.5 + (sin(J.num(J.add(J.mul(v_t_745, 3.0), v_x_743))) * 0.25))
	v_g_748 = J.mc(v_ctx_742, "createRadialGradient", [v_x_743, v_fy_746, 1.0, v_x_743, v_fy_746, 14.0])
	J.mc(v_g_748, "addColorStop", [0.0, ("rgba(140,220,255," + J.str(v_a_747) + ")")])
	J.mc(v_g_748, "addColorStop", [1.0, "rgba(140,220,255,0)"])
	J.sp(v_ctx_742, "fillStyle", v_g_748)
	J.mc(v_ctx_742, "fillRect", [J.sub(v_x_743, 14.0), J.sub(v_fy_746, 14.0), 28.0, 28.0])
	J.mc(v_ctx_742, "beginPath", [])
	J.mc(v_ctx_742, "moveTo", [J.sub(v_x_743, 3.0), J.add(v_fy_746, 2.0)])
	J.mc(v_ctx_742, "quadraticCurveTo", [J.sub(v_x_743, 3.0), J.sub(v_fy_746, 5.0), J.add(v_x_743, (sin(J.num(J.mul(v_t_745, 5.0))) * 1.5)), J.sub(v_fy_746, 9.0)])
	J.mc(v_ctx_742, "quadraticCurveTo", [J.add(v_x_743, 3.0), J.sub(v_fy_746, 5.0), J.add(v_x_743, 3.0), J.add(v_fy_746, 2.0)])
	J.mc(v_ctx_742, "arc", [v_x_743, J.add(v_fy_746, 2.0), 3.0, 0.0, PI])
	var _t305 = ("rgba(190,240,255," + J.str(J.add(v_a_747, 0.2)) + ")")
	J.sp(v_ctx_742, "fillStyle", _t305)
	J.mc(v_ctx_742, "fill", [])

func _f76(this_, a: Array, env):
	var v_ctx_751 = null; var v_x_752 = null; var v_y_753 = null; var v_t_754 = null
	v_ctx_751 = J.arg(a, 0)
	v_x_752 = J.arg(a, 1)
	v_y_753 = J.arg(a, 2)
	v_t_754 = J.arg(a, 3)
	var _t306 = env["el"]
	J.cl(_t306, null, [v_ctx_751, v_x_752, J.add(v_y_753, 4.0), 60.0, 10.0, "rgba(0,0,0,.3)"])
	var _t307 = env["rr"]
	J.cl(_t307, null, [v_ctx_751, J.sub(v_x_752, 52.0), J.sub(v_y_753, 54.0), 14.0, 54.0, 2.0, "#5a2a2a", env["OUT"], 2.0])
	var _t308 = env["rr"]
	J.cl(_t308, null, [v_ctx_751, J.add(v_x_752, 38.0), J.sub(v_y_753, 54.0), 14.0, 54.0, 2.0, "#5a2a2a", env["OUT"], 2.0])
	var _t309 = env["rr"]
	J.cl(_t309, null, [v_ctx_751, J.sub(v_x_752, 60.0), J.sub(v_y_753, 66.0), 120.0, 12.0, 3.0, "#3a2a3a", env["OUT"], 2.0])
	var _t310 = env["rr"]
	J.cl(_t310, null, [v_ctx_751, J.sub(v_x_752, 50.0), J.sub(v_y_753, 50.0), 100.0, 8.0, 2.0, "#7a3a3a", env["OUT"], 1.5])
	var _t311 = env["roof"]
	J.cl(_t311, null, [v_ctx_751, v_x_752, J.sub(v_y_753, 84.0), 110.0, 18.0, "#2a2438"])
	var _t312 = env["plaque"]
	J.cl(_t312, null, [v_ctx_751, v_x_752, J.sub(v_y_753, 46.0), "地盤", 0.0])
	var _t313 = env["lantern"]
	J.cl(_t313, null, [v_ctx_751, J.sub(v_x_752, 45.0), J.sub(v_y_753, 40.0), v_t_754])
	var _t314 = env["lantern"]
	J.cl(_t314, null, [v_ctx_751, J.add(v_x_752, 45.0), J.sub(v_y_753, 40.0), v_t_754])

func _f77(this_, a: Array, env):
	var v_ctx_757 = null; var v_kind_758 = null; var v_x_759 = null; var v_y_760 = null; var v_t_761 = null; var v_k_762 = null; var v_k_763 = null; var v_k_764 = null
	v_ctx_757 = J.arg(a, 0)
	v_kind_758 = J.arg(a, 1)
	v_x_759 = J.arg(a, 2)
	v_y_760 = J.arg(a, 3)
	v_t_761 = J.arg(a, 4)
	if J.seq(v_kind_758, "grave"):
		var _t315 = env["el"]
		J.cl(_t315, null, [v_ctx_757, v_x_759, J.add(v_y_760, 2.0), 13.0, 4.0, "rgba(0,0,0,.3)"])
		J.mc(v_ctx_757, "beginPath", [])
		J.mc(v_ctx_757, "moveTo", [J.sub(v_x_759, 10.0), v_y_760])
		J.mc(v_ctx_757, "lineTo", [J.sub(v_x_759, 10.0), J.sub(v_y_760, 18.0)])
		J.mc(v_ctx_757, "arc", [v_x_759, J.sub(v_y_760, 18.0), 10.0, PI, 0.0])
		J.mc(v_ctx_757, "lineTo", [J.add(v_x_759, 10.0), v_y_760])
		J.mc(v_ctx_757, "closePath", [])
		J.sp(v_ctx_757, "fillStyle", "#4a4660")
		J.mc(v_ctx_757, "fill", [])
		var _t316 = env["OUT"]
		J.sp(v_ctx_757, "strokeStyle", _t316)
		J.sp(v_ctx_757, "lineWidth", 1.5)
		J.mc(v_ctx_757, "stroke", [])
		J.sp(v_ctx_757, "fillStyle", "rgba(255,255,255,.16)")
		v_k_762 = 0.0
		while true:
			if not J.cmp(v_k_762, 3.0, "<"): break
			J.mc(v_ctx_757, "fillRect", [J.sub(v_x_759, 1.2), (J.sub(v_y_760, 23.0) + J.mul(v_k_762, 6.0)), 2.4, 3.6])
			v_k_762 = J.num(v_k_762) + 1.0
	else:
		if J.seq(v_kind_758, "post"):
			var _t317 = env["rr"]
			J.cl(_t317, null, [v_ctx_757, J.sub(v_x_759, 2.0), J.sub(v_y_760, 40.0), 4.0, 40.0, 1.0, "#3a2a20", env["OUT"], 1.0])
			var _t318 = env["lantern"]
			J.cl(_t318, null, [v_ctx_757, v_x_759, J.sub(v_y_760, 38.0), v_t_761, "#e8e0c8"])
		else:
			if J.seq(v_kind_758, "banana"):
				var _t319 = env["rr"]
				J.cl(_t319, null, [v_ctx_757, J.sub(v_x_759, 3.0), J.sub(v_y_760, 34.0), 6.0, 34.0, 2.0, "#3a5a3a", env["OUT"], 1.2])
				v_k_763 = 0.0
				while true:
					if not J.cmp(v_k_763, 5.0, "<"): break
					J.mc(v_ctx_757, "save", [])
					J.mc(v_ctx_757, "translate", [v_x_759, J.sub(v_y_760, 34.0)])
					J.mc(v_ctx_757, "rotate", [(((-2.4) + J.mul(v_k_763, 0.55)) + (sin(J.num(J.add(v_t_761, v_k_763))) * 0.04))])
					var _t320 = env["el"]
					J.cl(_t320, null, [v_ctx_757, 17.0, 0.0, 18.0, 5.0, ("#2e5a3a" if J.t(J.mod(v_k_763, 2.0)) else "#3a6a44"), env["OUT"], 1.0])
					J.mc(v_ctx_757, "restore", [])
					v_k_763 = J.num(v_k_763) + 1.0
			else:
				if J.seq(v_kind_758, "scarecrow"):
					var _t321 = env["drawScarecrow"]
					J.cl(_t321, null, [v_ctx_757, v_x_759, v_y_760, v_t_761])
				else:
					if J.seq(v_kind_758, "willo"):
						var _t322 = env["drawWillo"]
						J.cl(_t322, null, [v_ctx_757, v_x_759, v_y_760, v_t_761])
					else:
						if J.seq(v_kind_758, "webTL"):
							var _t323 = env["drawWeb"]
							J.cl(_t323, null, [v_ctx_757, v_x_759, v_y_760, 30.0, 0.0, J.div(PI, 2.0), 0.32])
						else:
							if J.seq(v_kind_758, "webTR"):
								var _t324 = env["drawWeb"]
								J.cl(_t324, null, [v_ctx_757, v_x_759, v_y_760, 30.0, J.div(PI, 2.0), PI, 0.32])
							else:
								if J.seq(v_kind_758, "offer"):
									var _t325 = env["rr"]
									J.cl(_t325, null, [v_ctx_757, J.sub(v_x_759, 9.0), J.sub(v_y_760, 6.0), 18.0, 6.0, 1.0, "#7a3a2a", env["OUT"], 1.0])
									v_k_764 = (-1.0)
									while true:
										if not J.cmp(v_k_764, 1.0, "<="): break
										var _t326 = env["rr"]
										J.cl(_t326, null, [v_ctx_757, J.sub(J.add(v_x_759, J.mul(v_k_764, 4.0)), 0.6), J.sub(v_y_760, 16.0), 1.2, 10.0, 0.5, "#c8a050"])
										var _t327 = env["el"]
										J.cl(_t327, null, [v_ctx_757, J.add(v_x_759, J.mul(v_k_764, 4.0)), J.sub(v_y_760, 16.0), 1.2, 1.2, "#ff8040"])
										v_k_764 = J.num(v_k_764) + 1.0
									J.sp(v_ctx_757, "strokeStyle", "rgba(220,220,240,.25)")
									J.sp(v_ctx_757, "lineWidth", 1.0)
									J.mc(v_ctx_757, "beginPath", [])
									J.mc(v_ctx_757, "moveTo", [v_x_759, J.sub(v_y_760, 17.0)])
									J.mc(v_ctx_757, "quadraticCurveTo", [J.add(J.add(v_x_759, 4.0), (sin(J.num(J.mul(v_t_761, 2.0))) * 3.0)), J.sub(v_y_760, 26.0), v_x_759, J.sub(v_y_760, 34.0)])
									J.mc(v_ctx_757, "stroke", [])

func _f14(this_, a: Array, env):
	var v_ctx_161 = null; var v_x_162 = null; var v_y_163 = null; var v_s_164 = null; var v_o_165 = null; var v_t_166 = null; var v_hy_167 = null; var v_sw_168 = null; var v_ax_169 = null; var v_ay_170 = null
	v_ctx_161 = J.arg(a, 0)
	v_x_162 = J.arg(a, 1)
	v_y_163 = J.arg(a, 2)
	v_s_164 = J.arg(a, 3)
	v_o_165 = J.arg(a, 4)
	v_t_166 = J.gp(v_o_165, "t")
	v_hy_167 = J.sub(v_y_163, J.mul(34.0, v_s_164))
	var _t328 = env["wisp"]
	J.cl(_t328, null, [v_ctx_161, v_x_162, v_y_163, v_s_164, "#2b2f45", v_t_166, 8.0])
	var _t329 = env["body"]
	J.cl(_t329, null, [v_ctx_161, v_x_162, J.sub(v_y_163, J.mul(5.0, v_s_164)), v_s_164, "#eef1f8"])
	var _t330 = env["poly"]
	J.cl(_t330, null, [v_ctx_161, [J.sub(v_x_162, J.mul(1.5, v_s_164)), J.sub(v_y_163, J.mul(22.0, v_s_164)), J.add(v_x_162, J.mul(1.5, v_s_164)), J.sub(v_y_163, J.mul(22.0, v_s_164)), J.add(v_x_162, J.mul(2.5, v_s_164)), J.sub(v_y_163, J.mul(10.0, v_s_164)), v_x_162, J.sub(v_y_163, J.mul(8.0, v_s_164)), J.sub(v_x_162, J.mul(2.5, v_s_164)), J.sub(v_y_163, J.mul(10.0, v_s_164))], "#c0283c", env["OUT"], J.mul(1.0, v_s_164)])
	var _t331 = env["rr"]
	J.cl(_t331, null, [v_ctx_161, J.add(v_x_162, J.mul(3.0, v_s_164)), J.sub(v_y_163, J.mul(15.0, v_s_164)), J.mul(5.0, v_s_164), J.mul(6.0, v_s_164), J.mul(1.0, v_s_164), "#4a8ad8", env["OUT"], J.mul(1.0, v_s_164)])
	v_sw_168 = (sin(J.num(J.mul(v_t_166, 12.0))) if J.t(J.gp(v_o_165, "work")) else 0.0)
	var _t332 = env["arm"]
	J.cl(_t332, null, [v_ctx_161, J.sub(v_x_162, J.mul(8.0, v_s_164)), J.sub(v_y_163, J.mul(19.0, v_s_164)), J.sub(v_x_162, J.mul(12.0, v_s_164)), J.sub(v_y_163, J.mul(10.0, v_s_164)), v_s_164, "#eef1f8"])
	v_ax_169 = J.add(J.add(v_x_162, J.mul(12.0, v_s_164)), J.mul(J.mul(v_sw_168, 3.0), v_s_164))
	v_ay_170 = (J.sub(v_y_163, J.mul(14.0, v_s_164)) - J.mul(J.mul(v_sw_168, 6.0), v_s_164))
	var _t333 = env["arm"]
	J.cl(_t333, null, [v_ctx_161, J.add(v_x_162, J.mul(8.0, v_s_164)), J.sub(v_y_163, J.mul(19.0, v_s_164)), v_ax_169, v_ay_170, v_s_164, "#eef1f8"])
	if (not J.seq(J.gp(v_o_165, "tool"), false)):
		J.mc(v_ctx_161, "save", [])
		J.mc(v_ctx_161, "translate", [v_ax_169, v_ay_170])
		J.mc(v_ctx_161, "rotate", [((-0.9) + J.mul(v_sw_168, 0.9))])
		var _t334 = env["rr"]
		J.cl(_t334, null, [v_ctx_161, J.mul((-1.2), v_s_164), J.mul((-14.0), v_s_164), J.mul(2.4, v_s_164), J.mul(16.0, v_s_164), J.mul(1.0, v_s_164), "#8a5a2b", env["OUT"], J.mul(1.0, v_s_164)])
		var _t335 = env["poly"]
		J.cl(_t335, null, [v_ctx_161, [J.mul(1.0, v_s_164), J.mul((-14.0), v_s_164), J.mul(8.0, v_s_164), J.mul((-16.0), v_s_164), J.mul(8.0, v_s_164), J.mul((-8.0), v_s_164), J.mul(1.0, v_s_164), J.mul((-10.0), v_s_164)], "#b8c2d0", env["OUT"], J.mul(1.0, v_s_164)])
		J.mc(v_ctx_161, "restore", [])
	var _t336 = env["el"]
	J.cl(_t336, null, [v_ctx_161, v_x_162, v_hy_167, J.mul(14.0, v_s_164), J.mul(13.0, v_s_164), "#dfe6f5", env["OUT"], J.mul(1.8, v_s_164)])
	J.sp(v_ctx_161, "fillStyle", "#20232f")
	J.mc(v_ctx_161, "beginPath", [])
	J.mc(v_ctx_161, "ellipse", [v_x_162, J.sub(v_hy_167, J.mul(6.0, v_s_164)), J.mul(14.5, v_s_164), J.mul(8.5, v_s_164), 0.0, PI, env["TAU"]])
	J.mc(v_ctx_161, "fill", [])
	var _t337 = env["poly"]
	J.cl(_t337, null, [v_ctx_161, [J.sub(v_x_162, J.mul(14.0, v_s_164)), J.sub(v_hy_167, J.mul(6.0, v_s_164)), J.sub(v_x_162, J.mul(6.0, v_s_164)), J.sub(v_hy_167, J.mul(4.0, v_s_164)), J.sub(v_x_162, J.mul(2.0, v_s_164)), J.sub(v_hy_167, J.mul(9.0, v_s_164)), J.add(v_x_162, J.mul(4.0, v_s_164)), J.sub(v_hy_167, J.mul(4.0, v_s_164)), J.add(v_x_162, J.mul(14.0, v_s_164)), J.sub(v_hy_167, J.mul(6.0, v_s_164)), J.add(v_x_162, J.mul(12.0, v_s_164)), J.sub(v_hy_167, J.mul(12.0, v_s_164)), J.sub(v_x_162, J.mul(12.0, v_s_164)), J.sub(v_hy_167, J.mul(12.0, v_s_164))], "#20232f"])
	var _t338 = env["eyes"]
	J.cl(_t338, null, [v_ctx_161, v_x_162, J.add(v_hy_167, J.mul(1.0, v_s_164)), v_s_164, "tired"])
	var _t339 = env["mouth"]
	J.cl(_t339, null, [v_ctx_161, v_x_162, v_hy_167, v_s_164, ("smile" if J.seq(J.gp(v_o_165, "mood"), "happy") else "wavy")])
	var _t340 = env["el"]
	J.cl(_t340, null, [v_ctx_161, J.add(v_x_162, J.mul(12.0, v_s_164)), (J.sub(v_hy_167, J.mul(13.0, v_s_164)) + J.mul((sin(J.num(J.mul(v_t_166, 3.0))) * 1.5), v_s_164)), J.mul(2.5, v_s_164), J.mul(3.5, v_s_164), "rgba(140,220,255,.75)"])

func _f15(this_, a: Array, env):
	var v_ctx_173 = null; var v_x_174 = null; var v_y_175 = null; var v_s_176 = null; var v_o_177 = null; var v_t_178 = null; var v_hy_179 = null; var v_sw_180 = null
	v_ctx_173 = J.arg(a, 0)
	v_x_174 = J.arg(a, 1)
	v_y_175 = J.arg(a, 2)
	v_s_176 = J.arg(a, 3)
	v_o_177 = J.arg(a, 4)
	v_t_178 = J.gp(v_o_177, "t")
	v_hy_179 = J.sub(v_y_175, J.mul(33.0, v_s_176))
	var _t341 = env["legs"]
	J.cl(_t341, null, [v_ctx_173, v_x_174, v_y_175, v_s_176, "#f6efe3", (J.mul(v_t_178, 10.0) if J.t(J.gp(v_o_177, "walk")) else 0.0)])
	var _t342 = env["poly"]
	J.cl(_t342, null, [v_ctx_173, [J.sub(v_x_174, J.mul(10.0, v_s_176)), J.sub(v_y_175, J.mul(5.0, v_s_176)), J.add(v_x_174, J.mul(10.0, v_s_176)), J.sub(v_y_175, J.mul(5.0, v_s_176)), J.add(v_x_174, J.mul(7.0, v_s_176)), J.sub(v_y_175, J.mul(23.0, v_s_176)), J.sub(v_x_174, J.mul(7.0, v_s_176)), J.sub(v_y_175, J.mul(23.0, v_s_176))], "#e84a5f", env["OUT"], J.mul(1.5, v_s_176)])
	J.sp(v_ctx_173, "fillStyle", "#ffd25a")
	J.mc(v_ctx_173, "fillRect", [J.sub(v_x_174, J.mul(10.0, v_s_176)), J.sub(v_y_175, J.mul(9.0, v_s_176)), J.mul(20.0, v_s_176), J.mul(2.0, v_s_176)])
	v_sw_180 = (J.mul((sin(J.num(J.mul(v_t_178, 10.0))) * 3.0), v_s_176) if J.t(J.gp(v_o_177, "work")) else 0.0)
	var _t343 = env["arm"]
	J.cl(_t343, null, [v_ctx_173, J.sub(v_x_174, J.mul(7.0, v_s_176)), J.sub(v_y_175, J.mul(20.0, v_s_176)), J.sub(v_x_174, J.mul(11.0, v_s_176)), J.add(J.sub(v_y_175, J.mul(12.0, v_s_176)), v_sw_180), v_s_176, "#f6efe3"])
	var _t344 = env["arm"]
	J.cl(_t344, null, [v_ctx_173, J.add(v_x_174, J.mul(7.0, v_s_176)), J.sub(v_y_175, J.mul(20.0, v_s_176)), J.add(v_x_174, J.mul(11.0, v_s_176)), J.sub(J.sub(v_y_175, J.mul(12.0, v_s_176)), v_sw_180), v_s_176, "#f6efe3"])
	var _t345 = env["el"]
	J.cl(_t345, null, [v_ctx_173, v_x_174, v_hy_179, J.mul(13.0, v_s_176), J.mul(12.5, v_s_176), "#fbf6ec", env["OUT"], J.mul(1.8, v_s_176)])
	J.sp(v_ctx_173, "fillStyle", "#16131c")
	J.mc(v_ctx_173, "beginPath", [])
	J.mc(v_ctx_173, "ellipse", [v_x_174, J.sub(v_hy_179, J.mul(4.0, v_s_176)), J.mul(13.5, v_s_176), J.mul(9.0, v_s_176), 0.0, PI, env["TAU"]])
	J.mc(v_ctx_173, "fill", [])
	var _t346 = env["el"]
	J.cl(_t346, null, [v_ctx_173, J.sub(v_x_174, J.mul(11.0, v_s_176)), J.sub(v_hy_179, J.mul(10.0, v_s_176)), J.mul(5.0, v_s_176), J.mul(5.0, v_s_176), "#16131c"])
	var _t347 = env["el"]
	J.cl(_t347, null, [v_ctx_173, J.add(v_x_174, J.mul(11.0, v_s_176)), J.sub(v_hy_179, J.mul(10.0, v_s_176)), J.mul(5.0, v_s_176), J.mul(5.0, v_s_176), "#16131c"])
	var _t348 = env["el"]
	J.cl(_t348, null, [v_ctx_173, J.sub(v_x_174, J.mul(11.0, v_s_176)), J.sub(v_hy_179, J.mul(10.0, v_s_176)), J.mul(1.8, v_s_176), J.mul(1.8, v_s_176), "#e84a5f"])
	var _t349 = env["el"]
	J.cl(_t349, null, [v_ctx_173, J.add(v_x_174, J.mul(11.0, v_s_176)), J.sub(v_hy_179, J.mul(10.0, v_s_176)), J.mul(1.8, v_s_176), J.mul(1.8, v_s_176), "#e84a5f"])
	var _t350 = env["eyes"]
	J.cl(_t350, null, [v_ctx_173, v_x_174, J.add(v_hy_179, J.mul(1.0, v_s_176)), v_s_176, "paper"])
	var _t351 = env["blush"]
	J.cl(_t351, null, [v_ctx_173, v_x_174, v_hy_179, v_s_176, "#ff6f8a"])
	var _t352 = env["mouth"]
	J.cl(_t352, null, [v_ctx_173, v_x_174, v_hy_179, v_s_176, "red"])

func _f16(this_, a: Array, env):
	var v_ctx_183 = null; var v_x_184 = null; var v_y_185 = null; var v_s_186 = null; var v_o_187 = null; var v_t_188 = null; var v_hy_189 = null
	v_ctx_183 = J.arg(a, 0)
	v_x_184 = J.arg(a, 1)
	v_y_185 = J.arg(a, 2)
	v_s_186 = J.arg(a, 3)
	v_o_187 = J.arg(a, 4)
	v_t_188 = J.gp(v_o_187, "t")
	v_hy_189 = J.sub(v_y_185, J.mul(32.0, v_s_186))
	var _t353 = env["legs"]
	J.cl(_t353, null, [v_ctx_183, v_x_184, v_y_185, v_s_186, "#f6efe3", (J.mul(v_t_188, 10.0) if J.t(J.gp(v_o_187, "walk")) else 0.0)])
	var _t354 = env["poly"]
	J.cl(_t354, null, [v_ctx_183, [J.sub(v_x_184, J.mul(10.0, v_s_186)), J.sub(v_y_185, J.mul(5.0, v_s_186)), J.add(v_x_184, J.mul(10.0, v_s_186)), J.sub(v_y_185, J.mul(5.0, v_s_186)), J.add(v_x_184, J.mul(7.0, v_s_186)), J.sub(v_y_185, J.mul(22.0, v_s_186)), J.sub(v_x_184, J.mul(7.0, v_s_186)), J.sub(v_y_185, J.mul(22.0, v_s_186))], "#3a8ad6", env["OUT"], J.mul(1.5, v_s_186)])
	J.sp(v_ctx_183, "fillStyle", "#ffd25a")
	J.mc(v_ctx_183, "fillRect", [J.sub(v_x_184, J.mul(10.0, v_s_186)), J.sub(v_y_185, J.mul(9.0, v_s_186)), J.mul(20.0, v_s_186), J.mul(2.0, v_s_186)])
	var _t355 = env["arm"]
	J.cl(_t355, null, [v_ctx_183, J.sub(v_x_184, J.mul(7.0, v_s_186)), J.sub(v_y_185, J.mul(19.0, v_s_186)), J.sub(v_x_184, J.mul(11.0, v_s_186)), J.sub(v_y_185, J.mul(11.0, v_s_186)), v_s_186, "#f6efe3"])
	var _t356 = env["arm"]
	J.cl(_t356, null, [v_ctx_183, J.add(v_x_184, J.mul(7.0, v_s_186)), J.sub(v_y_185, J.mul(19.0, v_s_186)), J.add(v_x_184, J.mul(11.0, v_s_186)), J.sub(v_y_185, J.mul(11.0, v_s_186)), v_s_186, "#f6efe3"])
	var _t357 = env["el"]
	J.cl(_t357, null, [v_ctx_183, v_x_184, v_hy_189, J.mul(12.5, v_s_186), J.mul(12.0, v_s_186), "#fbf6ec", env["OUT"], J.mul(1.8, v_s_186)])
	J.sp(v_ctx_183, "fillStyle", "#16131c")
	J.mc(v_ctx_183, "beginPath", [])
	J.mc(v_ctx_183, "ellipse", [v_x_184, J.sub(v_hy_189, J.mul(5.0, v_s_186)), J.mul(13.0, v_s_186), J.mul(7.5, v_s_186), 0.0, PI, env["TAU"]])
	J.mc(v_ctx_183, "fill", [])
	var _t358 = env["el"]
	J.cl(_t358, null, [v_ctx_183, v_x_184, J.sub(v_hy_189, J.mul(13.0, v_s_186)), J.mul(4.0, v_s_186), J.mul(3.0, v_s_186), "#16131c"])
	var _t359 = env["eyes"]
	J.cl(_t359, null, [v_ctx_183, v_x_184, J.add(v_hy_189, J.mul(1.0, v_s_186)), v_s_186, "paper"])
	var _t360 = env["blush"]
	J.cl(_t360, null, [v_ctx_183, v_x_184, v_hy_189, v_s_186, "#ff6f8a"])
	var _t361 = env["mouth"]
	J.cl(_t361, null, [v_ctx_183, v_x_184, v_hy_189, v_s_186, "red"])

func _f17(this_, a: Array, env):
	var v_ctx_192 = null; var v_x_193 = null; var v_y_194 = null; var v_s_195 = null; var v_o_196 = null; var v_t_197 = null; var v_hy_198 = null
	v_ctx_192 = J.arg(a, 0)
	v_x_193 = J.arg(a, 1)
	v_y_194 = J.arg(a, 2)
	v_s_195 = J.arg(a, 3)
	v_o_196 = J.arg(a, 4)
	v_t_197 = J.gp(v_o_196, "t")
	v_hy_198 = (J.sub(v_y_194, J.mul(26.0, v_s_195)) - J.mul((sin(J.num(J.mul(v_t_197, 3.0))) * 2.0), v_s_195))
	var _t362 = J.mul(J.gp(v_ctx_192, "globalAlpha"), 0.88)
	J.sp(v_ctx_192, "globalAlpha", _t362)
	var _t363 = env["ghostTail"]
	J.cl(_t363, null, [v_ctx_192, v_x_193, J.sub(v_y_194, J.mul((sin(J.num(J.mul(v_t_197, 3.0))) * 2.0), v_s_195)), v_s_195, "#dfeaff", v_t_197])
	var _t364 = env["el"]
	J.cl(_t364, null, [v_ctx_192, v_x_193, v_hy_198, J.mul(12.0, v_s_195), J.mul(12.0, v_s_195), "#e9f1ff", env["OUT"], J.mul(1.6, v_s_195)])
	var _t365 = env["eyes"]
	J.cl(_t365, null, [v_ctx_192, v_x_193, J.add(v_hy_198, J.mul(1.0, v_s_195)), v_s_195, ("angry" if J.t(J.gp(v_o_196, "enemy")) else "dot")])
	var _t366 = env["mouth"]
	J.cl(_t366, null, [v_ctx_192, v_x_193, v_hy_198, v_s_195, "open"])
	var _t367 = env["el"]
	J.cl(_t367, null, [v_ctx_192, J.add(v_x_193, J.mul(10.0, v_s_195)), J.sub(v_hy_198, J.mul(10.0, v_s_195)), J.mul(2.0, v_s_195), J.mul(3.0, v_s_195), "rgba(160,230,255,.8)"])

func _f18(this_, a: Array, env):
	var v_ctx_201 = null; var v_x_202 = null; var v_y_203 = null; var v_s_204 = null; var v_o_205 = null; var v_t_206 = null; var v_hy_207 = null
	v_ctx_201 = J.arg(a, 0)
	v_x_202 = J.arg(a, 1)
	v_y_203 = J.arg(a, 2)
	v_s_204 = J.arg(a, 3)
	v_o_205 = J.arg(a, 4)
	v_t_206 = J.gp(v_o_205, "t")
	v_hy_207 = J.sub(v_y_203, J.mul(34.0, v_s_204))
	var _t368 = env["wisp"]
	J.cl(_t368, null, [v_ctx_201, v_x_202, v_y_203, v_s_204, "#9cb38a", v_t_206, 7.0])
	var _t369 = env["el"]
	J.cl(_t369, null, [v_ctx_201, v_x_202, J.sub(v_y_203, J.mul(13.0, v_s_204)), J.mul(12.0, v_s_204), J.mul(10.0, v_s_204), "#9cb38a", env["OUT"], J.mul(1.6, v_s_204)])
	J.sp(v_ctx_201, "strokeStyle", "#6a7d5c")
	var _t370 = J.mul(1.0, v_s_204)
	J.sp(v_ctx_201, "lineWidth", _t370)
	J.mc(v_ctx_201, "beginPath", [])
	J.mc(v_ctx_201, "arc", [v_x_202, J.sub(v_y_203, J.mul(13.0, v_s_204)), J.mul(2.0, v_s_204), 0.0, env["TAU"]])
	J.mc(v_ctx_201, "stroke", [])
	var _t371 = env["rr"]
	J.cl(_t371, null, [v_ctx_201, J.sub(v_x_202, J.mul(1.2, v_s_204)), J.sub(v_y_203, J.mul(25.0, v_s_204)), J.mul(2.4, v_s_204), J.mul(5.0, v_s_204), J.mul(1.0, v_s_204), "#9cb38a", env["OUT"], J.mul(1.0, v_s_204)])
	var _t372 = env["arm"]
	J.cl(_t372, null, [v_ctx_201, J.sub(v_x_202, J.mul(9.0, v_s_204)), J.sub(v_y_203, J.mul(16.0, v_s_204)), J.sub(v_x_202, J.mul(13.0, v_s_204)), (J.sub(v_y_203, J.mul(22.0, v_s_204)) + J.mul((sin(J.num(J.mul(v_t_206, 6.0))) * 2.0), v_s_204)), v_s_204, "#9cb38a"])
	var _t373 = env["arm"]
	J.cl(_t373, null, [v_ctx_201, J.add(v_x_202, J.mul(9.0, v_s_204)), J.sub(v_y_203, J.mul(16.0, v_s_204)), J.add(v_x_202, J.mul(13.0, v_s_204)), (J.sub(v_y_203, J.mul(22.0, v_s_204)) - J.mul((sin(J.num(J.mul(v_t_206, 6.0))) * 2.0), v_s_204)), v_s_204, "#9cb38a"])
	var _t374 = env["el"]
	J.cl(_t374, null, [v_ctx_201, v_x_202, v_hy_207, J.mul(11.0, v_s_204), J.mul(10.0, v_s_204), "#a9c196", env["OUT"], J.mul(1.6, v_s_204)])
	var _t375 = env["eyes"]
	J.cl(_t375, null, [v_ctx_201, v_x_202, v_hy_207, v_s_204, "big"])
	var _t376 = env["mouth"]
	J.cl(_t376, null, [v_ctx_201, v_x_202, J.sub(v_hy_207, J.mul(1.0, v_s_204)), v_s_204, "open"])

func _f19(this_, a: Array, env):
	var v_ctx_210 = null; var v_x_211 = null; var v_y_212 = null; var v_s_213 = null; var v_o_214 = null; var v_t_215 = null; var v_hy_216 = null
	v_ctx_210 = J.arg(a, 0)
	v_x_211 = J.arg(a, 1)
	v_y_212 = J.arg(a, 2)
	v_s_213 = J.arg(a, 3)
	v_o_214 = J.arg(a, 4)
	v_t_215 = J.gp(v_o_214, "t")
	v_hy_216 = J.sub(v_y_212, J.mul(42.0, v_s_213))
	var _t377 = env["wisp"]
	J.cl(_t377, null, [v_ctx_210, v_x_211, v_y_212, v_s_213, "#7f9c6e", v_t_215, 11.0])
	var _t378 = env["el"]
	J.cl(_t378, null, [v_ctx_210, v_x_211, J.sub(v_y_212, J.mul(17.0, v_s_213)), J.mul(17.0, v_s_213), J.mul(14.0, v_s_213), "#7f9c6e", env["OUT"], J.mul(1.8, v_s_213)])
	J.sp(v_ctx_210, "fillStyle", "#c33")
	J.mc(v_ctx_210, "fillRect", [J.sub(v_x_211, J.mul(17.0, v_s_213)), J.sub(v_y_212, J.mul(20.0, v_s_213)), J.mul(34.0, v_s_213), J.mul(3.0, v_s_213)])
	var _t379 = env["rr"]
	J.cl(_t379, null, [v_ctx_210, J.sub(v_x_211, J.mul(1.5, v_s_213)), J.sub(v_y_212, J.mul(34.0, v_s_213)), J.mul(3.0, v_s_213), J.mul(5.0, v_s_213), J.mul(1.0, v_s_213), "#7f9c6e", env["OUT"], J.mul(1.0, v_s_213)])
	var _t380 = env["arm"]
	J.cl(_t380, null, [v_ctx_210, J.sub(v_x_211, J.mul(14.0, v_s_213)), J.sub(v_y_212, J.mul(22.0, v_s_213)), J.sub(v_x_211, J.mul(20.0, v_s_213)), (J.sub(v_y_212, J.mul(30.0, v_s_213)) + J.mul((sin(J.num(J.mul(v_t_215, 5.0))) * 2.0), v_s_213)), J.mul(v_s_213, 1.3), "#7f9c6e"])
	var _t381 = env["arm"]
	J.cl(_t381, null, [v_ctx_210, J.add(v_x_211, J.mul(14.0, v_s_213)), J.sub(v_y_212, J.mul(22.0, v_s_213)), J.add(v_x_211, J.mul(20.0, v_s_213)), J.sub(v_y_212, J.mul(30.0, v_s_213)), J.mul(v_s_213, 1.3), "#7f9c6e"])
	var _t382 = env["el"]
	J.cl(_t382, null, [v_ctx_210, J.add(v_x_211, J.mul(22.0, v_s_213)), J.sub(v_y_212, J.mul(33.0, v_s_213)), J.mul(5.0, v_s_213), J.mul(4.0, v_s_213), "#fff", env["OUT"], J.mul(1.0, v_s_213)])
	var _t383 = env["el"]
	J.cl(_t383, null, [v_ctx_210, v_x_211, v_hy_216, J.mul(13.0, v_s_213), J.mul(12.0, v_s_213), "#8eae7b", env["OUT"], J.mul(1.8, v_s_213)])
	var _t384 = env["poly"]
	J.cl(_t384, null, [v_ctx_210, [J.sub(v_x_211, J.mul(9.0, v_s_213)), J.sub(v_hy_216, J.mul(9.0, v_s_213)), J.sub(v_x_211, J.mul(6.0, v_s_213)), J.sub(v_hy_216, J.mul(17.0, v_s_213)), J.sub(v_x_211, J.mul(2.0, v_s_213)), J.sub(v_hy_216, J.mul(10.0, v_s_213)), J.add(v_x_211, J.mul(2.0, v_s_213)), J.sub(v_hy_216, J.mul(17.0, v_s_213)), J.add(v_x_211, J.mul(6.0, v_s_213)), J.sub(v_hy_216, J.mul(10.0, v_s_213)), J.add(v_x_211, J.mul(9.0, v_s_213)), J.sub(v_hy_216, J.mul(17.0, v_s_213)), J.add(v_x_211, J.mul(10.0, v_s_213)), J.sub(v_hy_216, J.mul(8.0, v_s_213))], "#e0b23a", env["OUT"], J.mul(1.2, v_s_213)])
	var _t385 = env["eyes"]
	J.cl(_t385, null, [v_ctx_210, v_x_211, v_hy_216, v_s_213, "angry"])
	var _t386 = env["mouth"]
	J.cl(_t386, null, [v_ctx_210, v_x_211, v_hy_216, v_s_213, "fang"])

func _f20(this_, a: Array, env):
	var v_ctx_219 = null; var v_x_220 = null; var v_y_221 = null; var v_s_222 = null; var v_o_223 = null; var v_t_224 = null; var v_hy_225 = null
	v_ctx_219 = J.arg(a, 0)
	v_x_220 = J.arg(a, 1)
	v_y_221 = J.arg(a, 2)
	v_s_222 = J.arg(a, 3)
	v_o_223 = J.arg(a, 4)
	v_t_224 = J.gp(v_o_223, "t")
	v_hy_225 = J.sub(v_y_221, J.mul(24.0, v_s_222))
	var _t387 = env["wisp"]
	J.cl(_t387, null, [v_ctx_219, v_x_220, v_y_221, v_s_222, "#7da59a", v_t_224, 6.0])
	var _t388 = env["el"]
	J.cl(_t388, null, [v_ctx_219, v_x_220, J.sub(v_y_221, J.mul(9.0, v_s_222)), J.mul(7.0, v_s_222), J.mul(6.0, v_s_222), "#7da59a", env["OUT"], J.mul(1.4, v_s_222)])
	var _t389 = env["el"]
	J.cl(_t389, null, [v_ctx_219, v_x_220, v_hy_225, J.mul(11.0, v_s_222), J.mul(10.5, v_s_222), "#8fb8ac", env["OUT"], J.mul(1.6, v_s_222)])
	var _t390 = env["poly"]
	J.cl(_t390, null, [v_ctx_219, [J.sub(v_x_220, J.mul(10.0, v_s_222)), J.sub(v_hy_225, J.mul(2.0, v_s_222)), J.sub(v_x_220, J.mul(17.0, v_s_222)), J.sub(v_hy_225, J.mul(5.0, v_s_222)), J.sub(v_x_220, J.mul(10.0, v_s_222)), J.add(v_hy_225, J.mul(3.0, v_s_222))], "#8fb8ac", env["OUT"], J.mul(1.2, v_s_222)])
	var _t391 = env["poly"]
	J.cl(_t391, null, [v_ctx_219, [J.add(v_x_220, J.mul(10.0, v_s_222)), J.sub(v_hy_225, J.mul(2.0, v_s_222)), J.add(v_x_220, J.mul(17.0, v_s_222)), J.sub(v_hy_225, J.mul(5.0, v_s_222)), J.add(v_x_220, J.mul(10.0, v_s_222)), J.add(v_hy_225, J.mul(3.0, v_s_222))], "#8fb8ac", env["OUT"], J.mul(1.2, v_s_222)])
	var _t392 = env["eyes"]
	J.cl(_t392, null, [v_ctx_219, v_x_220, v_hy_225, v_s_222, ("red" if J.t(J.gp(v_o_223, "enemy")) else "big")])
	var _t393 = env["mouth"]
	J.cl(_t393, null, [v_ctx_219, v_x_220, J.sub(v_hy_225, J.mul(1.0, v_s_222)), v_s_222, "smile"])

func _f21(this_, a: Array, env):
	var v_ctx_228 = null; var v_x_229 = null; var v_y_230 = null; var v_s_231 = null; var v_o_232 = null; var v_t_233 = null; var v_hy_234 = null
	v_ctx_228 = J.arg(a, 0)
	v_x_229 = J.arg(a, 1)
	v_y_230 = J.arg(a, 2)
	v_s_231 = J.arg(a, 3)
	v_o_232 = J.arg(a, 4)
	v_t_233 = J.gp(v_o_232, "t")
	v_hy_234 = J.sub(v_y_230, J.mul(26.0, v_s_231))
	var _t394 = env["wisp"]
	J.cl(_t394, null, [v_ctx_228, v_x_229, v_y_230, v_s_231, "#5e9b7c", v_t_233, 6.5])
	var _t395 = env["el"]
	J.cl(_t395, null, [v_ctx_228, v_x_229, J.sub(v_y_230, J.mul(10.0, v_s_231)), J.mul(8.0, v_s_231), J.mul(7.0, v_s_231), "#5e9b7c", env["OUT"], J.mul(1.4, v_s_231)])
	var _t396 = env["rr"]
	J.cl(_t396, null, [v_ctx_228, J.sub(v_x_229, J.mul(7.0, v_s_231)), J.sub(v_y_230, J.mul(12.0, v_s_231)), J.mul(14.0, v_s_231), J.mul(6.0, v_s_231), J.mul(2.0, v_s_231), "#f2f2f2", env["OUT"], J.mul(1.0, v_s_231)])
	var _t397 = env["arm"]
	J.cl(_t397, null, [v_ctx_228, J.add(v_x_229, J.mul(7.0, v_s_231)), J.sub(v_y_230, J.mul(13.0, v_s_231)), J.add(v_x_229, J.mul(12.0, v_s_231)), J.sub(v_y_230, J.mul(18.0, v_s_231)), v_s_231, "#5e9b7c"])
	var _t398 = env["el"]
	J.cl(_t398, null, [v_ctx_228, J.add(v_x_229, J.mul(14.0, v_s_231)), J.sub(v_y_230, J.mul(20.0, v_s_231)), J.mul(4.0, v_s_231), J.mul(3.0, v_s_231), "#e6c25a", env["OUT"], J.mul(1.0, v_s_231)])
	var _t399 = env["el"]
	J.cl(_t399, null, [v_ctx_228, v_x_229, v_hy_234, J.mul(12.0, v_s_231), J.mul(11.5, v_s_231), "#6cad8b", env["OUT"], J.mul(1.6, v_s_231)])
	var _t400 = env["poly"]
	J.cl(_t400, null, [v_ctx_228, [J.sub(v_x_229, J.mul(11.0, v_s_231)), J.sub(v_hy_234, J.mul(1.0, v_s_231)), J.sub(v_x_229, J.mul(18.0, v_s_231)), J.sub(v_hy_234, J.mul(7.0, v_s_231)), J.sub(v_x_229, J.mul(11.0, v_s_231)), J.add(v_hy_234, J.mul(4.0, v_s_231))], "#6cad8b", env["OUT"], J.mul(1.2, v_s_231)])
	var _t401 = env["poly"]
	J.cl(_t401, null, [v_ctx_228, [J.add(v_x_229, J.mul(11.0, v_s_231)), J.sub(v_hy_234, J.mul(1.0, v_s_231)), J.add(v_x_229, J.mul(18.0, v_s_231)), J.sub(v_hy_234, J.mul(7.0, v_s_231)), J.add(v_x_229, J.mul(11.0, v_s_231)), J.add(v_hy_234, J.mul(4.0, v_s_231))], "#6cad8b", env["OUT"], J.mul(1.2, v_s_231)])
	var _t402 = env["eyes"]
	J.cl(_t402, null, [v_ctx_228, v_x_229, J.add(v_hy_234, J.mul(1.0, v_s_231)), v_s_231, ("red" if J.t(J.gp(v_o_232, "enemy")) else "big")])
	var _t403 = env["mouth"]
	J.cl(_t403, null, [v_ctx_228, v_x_229, v_hy_234, v_s_231, "smile"])

func _f22(this_, a: Array, env):
	var v_ctx_237 = null; var v_x_238 = null; var v_y_239 = null; var v_s_240 = null; var v_o_241 = null
	v_ctx_237 = J.arg(a, 0)
	v_x_238 = J.arg(a, 1)
	v_y_239 = J.arg(a, 2)
	v_s_240 = J.arg(a, 3)
	v_o_241 = J.arg(a, 4)
	J.mc(env["DRAW"], "laojiang", [v_ctx_237, v_x_238, v_y_239, J.mul(v_s_240, 0.88), J.S_Object_("assign", [{}, v_o_241, {"minor": true}])])

func _f23(this_, a: Array, env):
	var v_ctx_244 = null; var v_x_245 = null; var v_y_246 = null; var v_s_247 = null; var v_o_248 = null; var v_t_249 = null; var v_hop_250 = null; var v_hy_251 = null; var v_rob_252 = null; var v_fl_253 = null; var v_i_254 = null
	v_ctx_244 = J.arg(a, 0)
	v_x_245 = J.arg(a, 1)
	v_y_246 = J.arg(a, 2)
	v_s_247 = J.arg(a, 3)
	v_o_248 = J.arg(a, 4)
	v_t_249 = J.gp(v_o_248, "t")
	var _t405 = absf(J.num(sin(J.num(J.mul(v_t_249, 5.0)))))
	var _t404 = J.gp(v_o_248, "walk")
	v_hop_250 = J.mul((_t405 * (5.0 if J.t((_t404 if J.t(_t404) else J.gp(v_o_248, "enemy"))) else 1.5)), v_s_247)
	var _t406 = J.sub(v_y_246, v_hop_250)
	v_y_246 = _t406
	v_hy_251 = J.sub(v_y_246, J.mul(36.0, v_s_247))
	var _t407 = env["rr"]
	J.cl(_t407, null, [v_ctx_244, J.sub(v_x_245, J.mul(6.0, v_s_247)), J.sub(v_y_246, J.mul(6.0, v_s_247)), J.mul(5.0, v_s_247), J.mul(6.0, v_s_247), J.mul(1.0, v_s_247), "#222", env["OUT"], J.mul(1.0, v_s_247)])
	var _t408 = env["rr"]
	J.cl(_t408, null, [v_ctx_244, J.add(v_x_245, J.mul(1.0, v_s_247)), J.sub(v_y_246, J.mul(6.0, v_s_247)), J.mul(5.0, v_s_247), J.mul(6.0, v_s_247), J.mul(1.0, v_s_247), "#222", env["OUT"], J.mul(1.0, v_s_247)])
	v_rob_252 = ("#3b5d8a" if J.t(J.gp(v_o_248, "minor")) else "#26386b")
	var _t409 = env["poly"]
	J.cl(_t409, null, [v_ctx_244, [J.sub(v_x_245, J.mul(11.0, v_s_247)), J.sub(v_y_246, J.mul(5.0, v_s_247)), J.add(v_x_245, J.mul(11.0, v_s_247)), J.sub(v_y_246, J.mul(5.0, v_s_247)), J.add(v_x_245, J.mul(9.0, v_s_247)), J.sub(v_y_246, J.mul(25.0, v_s_247)), J.sub(v_x_245, J.mul(9.0, v_s_247)), J.sub(v_y_246, J.mul(25.0, v_s_247))], v_rob_252, env["OUT"], J.mul(1.6, v_s_247)])
	var _t410 = env["rr"]
	J.cl(_t410, null, [v_ctx_244, J.sub(v_x_245, J.mul(6.0, v_s_247)), J.sub(v_y_246, J.mul(21.0, v_s_247)), J.mul(12.0, v_s_247), J.mul(9.0, v_s_247), J.mul(1.0, v_s_247), "#c79a3a", env["OUT"], J.mul(1.0, v_s_247)])
	var _t411 = env["el"]
	J.cl(_t411, null, [v_ctx_244, v_x_245, J.sub(v_y_246, J.mul(16.5, v_s_247)), J.mul(2.5, v_s_247), J.mul(2.5, v_s_247), "#fff"])
	var _t412 = env["arm"]
	J.cl(_t412, null, [v_ctx_244, J.sub(v_x_245, J.mul(8.0, v_s_247)), J.sub(v_y_246, J.mul(22.0, v_s_247)), J.sub(v_x_245, J.mul(6.0, v_s_247)), (J.sub(v_y_246, J.mul(24.0, v_s_247)) - 0.0), v_s_247, v_rob_252])
	var _t413 = env["OUT"]
	J.sp(v_ctx_244, "strokeStyle", _t413)
	var _t414 = J.mul(5.0, v_s_247)
	J.sp(v_ctx_244, "lineWidth", _t414)
	J.sp(v_ctx_244, "lineCap", "round")
	J.mc(v_ctx_244, "beginPath", [])
	J.mc(v_ctx_244, "moveTo", [J.sub(v_x_245, J.mul(6.0, v_s_247)), J.sub(v_y_246, J.mul(23.0, v_s_247))])
	J.mc(v_ctx_244, "lineTo", [J.add(v_x_245, J.mul(14.0, v_s_247)), J.sub(v_y_246, J.mul(24.0, v_s_247))])
	J.mc(v_ctx_244, "moveTo", [J.add(v_x_245, J.mul(6.0, v_s_247)), J.sub(v_y_246, J.mul(21.0, v_s_247))])
	J.mc(v_ctx_244, "lineTo", [J.add(v_x_245, J.mul(16.0, v_s_247)), J.sub(v_y_246, J.mul(21.0, v_s_247))])
	J.mc(v_ctx_244, "stroke", [])
	J.sp(v_ctx_244, "strokeStyle", v_rob_252)
	var _t415 = J.mul(3.0, v_s_247)
	J.sp(v_ctx_244, "lineWidth", _t415)
	J.mc(v_ctx_244, "beginPath", [])
	J.mc(v_ctx_244, "moveTo", [J.sub(v_x_245, J.mul(6.0, v_s_247)), J.sub(v_y_246, J.mul(23.0, v_s_247))])
	J.mc(v_ctx_244, "lineTo", [J.add(v_x_245, J.mul(14.0, v_s_247)), J.sub(v_y_246, J.mul(24.0, v_s_247))])
	J.mc(v_ctx_244, "moveTo", [J.add(v_x_245, J.mul(6.0, v_s_247)), J.sub(v_y_246, J.mul(21.0, v_s_247))])
	J.mc(v_ctx_244, "lineTo", [J.add(v_x_245, J.mul(16.0, v_s_247)), J.sub(v_y_246, J.mul(21.0, v_s_247))])
	J.mc(v_ctx_244, "stroke", [])
	var _t416 = env["el"]
	J.cl(_t416, null, [v_ctx_244, J.add(v_x_245, J.mul(15.5, v_s_247)), J.sub(v_y_246, J.mul(24.0, v_s_247)), J.mul(2.0, v_s_247), J.mul(1.8, v_s_247), "#b8d0b0", env["OUT"], J.mul(0.8, v_s_247)])
	var _t417 = env["el"]
	J.cl(_t417, null, [v_ctx_244, J.add(v_x_245, J.mul(17.0, v_s_247)), J.sub(v_y_246, J.mul(21.0, v_s_247)), J.mul(2.0, v_s_247), J.mul(1.8, v_s_247), "#b8d0b0", env["OUT"], J.mul(0.8, v_s_247)])
	var _t418 = env["el"]
	J.cl(_t418, null, [v_ctx_244, v_x_245, v_hy_251, J.mul(12.5, v_s_247), J.mul(12.0, v_s_247), "#b8d0b0", env["OUT"], J.mul(1.8, v_s_247)])
	var _t419 = env["el"]
	J.cl(_t419, null, [v_ctx_244, v_x_245, J.sub(v_hy_251, J.mul(9.0, v_s_247)), J.mul(15.0, v_s_247), J.mul(4.0, v_s_247), "#1c1c1c", env["OUT"], J.mul(1.2, v_s_247)])
	J.sp(v_ctx_244, "fillStyle", "#1c1c1c")
	J.mc(v_ctx_244, "beginPath", [])
	J.mc(v_ctx_244, "ellipse", [v_x_245, J.sub(v_hy_251, J.mul(10.0, v_s_247)), J.mul(10.0, v_s_247), J.mul(7.0, v_s_247), 0.0, PI, env["TAU"]])
	J.mc(v_ctx_244, "fill", [])
	J.sp(v_ctx_244, "strokeStyle", "#b22")
	var _t420 = J.mul(1.2, v_s_247)
	J.sp(v_ctx_244, "lineWidth", _t420)
	v_i_254 = (-3.0)
	while true:
		if not J.cmp(v_i_254, 3.0, "<="): break
		J.mc(v_ctx_244, "beginPath", [])
		J.mc(v_ctx_244, "moveTo", [v_x_245, J.sub(v_hy_251, J.mul(17.0, v_s_247))])
		J.mc(v_ctx_244, "lineTo", [J.add(v_x_245, J.mul(J.mul(v_i_254, 3.0), v_s_247)), J.sub(v_hy_251, J.mul(10.0, v_s_247))])
		J.mc(v_ctx_244, "stroke", [])
		v_i_254 = J.num(v_i_254) + 1.0
	var _t421 = env["el"]
	J.cl(_t421, null, [v_ctx_244, v_x_245, J.sub(v_hy_251, J.mul(17.5, v_s_247)), J.mul(2.0, v_s_247), J.mul(2.0, v_s_247), ("#2a7" if J.t(J.gp(v_o_248, "minor")) else "#d22"), env["OUT"], J.mul(0.8, v_s_247)])
	v_fl_253 = J.mul((sin(J.num(J.mul(v_t_249, 6.0))) * 1.5), v_s_247)
	var _t422 = env["poly"]
	J.cl(_t422, null, [v_ctx_244, [J.sub(v_x_245, J.mul(3.0, v_s_247)), J.sub(v_hy_251, J.mul(6.0, v_s_247)), J.add(v_x_245, J.mul(3.0, v_s_247)), J.sub(v_hy_251, J.mul(6.0, v_s_247)), J.add(J.add(v_x_245, J.mul(3.5, v_s_247)), v_fl_253), J.add(v_hy_251, J.mul(9.0, v_s_247)), J.add(J.sub(v_x_245, J.mul(2.5, v_s_247)), v_fl_253), J.add(v_hy_251, J.mul(9.0, v_s_247))], "#f3d24a", "#a5741a", J.mul(0.8, v_s_247)])
	J.sp(v_ctx_244, "strokeStyle", "#c41")
	var _t423 = J.mul(0.9, v_s_247)
	J.sp(v_ctx_244, "lineWidth", _t423)
	J.mc(v_ctx_244, "beginPath", [])
	J.mc(v_ctx_244, "moveTo", [v_x_245, J.sub(v_hy_251, J.mul(4.0, v_s_247))])
	J.mc(v_ctx_244, "lineTo", [J.add(v_x_245, J.mul(v_fl_253, 0.6)), J.add(v_hy_251, J.mul(7.0, v_s_247))])
	J.mc(v_ctx_244, "moveTo", [J.sub(v_x_245, J.mul(1.5, v_s_247)), v_hy_251])
	J.mc(v_ctx_244, "lineTo", [J.add(v_x_245, J.mul(1.5, v_s_247)), v_hy_251])
	J.mc(v_ctx_244, "stroke", [])
	var _t424 = env["el"]
	J.cl(_t424, null, [v_ctx_244, J.sub(v_x_245, J.mul(6.0, v_s_247)), J.add(v_hy_251, J.mul(1.0, v_s_247)), J.mul(1.4, v_s_247), J.mul(1.4, v_s_247), env["OUT"]])
	var _t425 = env["el"]
	J.cl(_t425, null, [v_ctx_244, J.add(v_x_245, J.mul(6.0, v_s_247)), J.add(v_hy_251, J.mul(1.0, v_s_247)), J.mul(1.4, v_s_247), J.mul(1.4, v_s_247), env["OUT"]])
	var _t426 = env["mouth"]
	J.cl(_t426, null, [v_ctx_244, v_x_245, J.add(v_hy_251, J.mul(1.0, v_s_247)), v_s_247, "flat"])

func _f24(this_, a: Array, env):
	var v_ctx_257 = null; var v_x_258 = null; var v_y_259 = null; var v_s_260 = null; var v_o_261 = null; var v_t_262 = null; var v_hy_263 = null; var v_i_264 = null; var v_i_265 = null
	v_ctx_257 = J.arg(a, 0)
	v_x_258 = J.arg(a, 1)
	v_y_259 = J.arg(a, 2)
	v_s_260 = J.arg(a, 3)
	v_o_261 = J.arg(a, 4)
	v_t_262 = J.gp(v_o_261, "t")
	v_hy_263 = J.sub(v_y_259, J.mul(32.0, v_s_260))
	var _t427 = env["wisp"]
	J.cl(_t427, null, [v_ctx_257, v_x_258, v_y_259, v_s_260, "#4c7c8a", v_t_262, 8.0])
	var _t428 = env["body"]
	J.cl(_t428, null, [v_ctx_257, v_x_258, J.sub(v_y_259, J.mul(5.0, v_s_260)), v_s_260, "#4c7c8a"])
	v_i_264 = 0.0
	while true:
		if not J.cmp(v_i_264, 3.0, "<"): break
		var _t429 = env["el"]
		J.cl(_t429, null, [v_ctx_257, (J.sub(v_x_258, J.mul(6.0, v_s_260)) + J.mul(J.mul(v_i_264, 6.0), v_s_260)), (J.sub(v_y_259, J.mul(2.0, v_s_260)) + J.mul(J.mod((J.mul(v_t_262, 30.0) + J.mul(v_i_264, 9.0)), 8.0), v_s_260)), J.mul(1.0, v_s_260), J.mul(1.5, v_s_260), "rgba(140,200,230,.8)"])
		v_i_264 = J.num(v_i_264) + 1.0
	var _t430 = env["arm"]
	J.cl(_t430, null, [v_ctx_257, J.sub(v_x_258, J.mul(8.0, v_s_260)), J.sub(v_y_259, J.mul(18.0, v_s_260)), J.sub(v_x_258, J.mul(13.0, v_s_260)), J.sub(v_y_259, J.mul(9.0, v_s_260)), v_s_260, "#6aa0ae"])
	var _t431 = env["arm"]
	J.cl(_t431, null, [v_ctx_257, J.add(v_x_258, J.mul(8.0, v_s_260)), J.sub(v_y_259, J.mul(18.0, v_s_260)), J.add(v_x_258, J.mul(13.0, v_s_260)), J.sub(v_y_259, J.mul(9.0, v_s_260)), v_s_260, "#6aa0ae"])
	var _t432 = env["el"]
	J.cl(_t432, null, [v_ctx_257, v_x_258, v_hy_263, J.mul(12.0, v_s_260), J.mul(12.0, v_s_260), "#8cc0cc", env["OUT"], J.mul(1.6, v_s_260)])
	J.sp(v_ctx_257, "fillStyle", "#163238")
	J.mc(v_ctx_257, "beginPath", [])
	J.mc(v_ctx_257, "ellipse", [v_x_258, J.sub(v_hy_263, J.mul(3.0, v_s_260)), J.mul(13.0, v_s_260), J.mul(10.0, v_s_260), 0.0, PI, env["TAU"]])
	J.mc(v_ctx_257, "fill", [])
	v_i_265 = (-2.0)
	while true:
		if not J.cmp(v_i_265, 2.0, "<="): break
		var _t433 = env["rr"]
		J.cl(_t433, null, [v_ctx_257, J.sub(J.add(v_x_258, J.mul(J.mul(v_i_265, 4.5), v_s_260)), J.mul(1.5, v_s_260)), J.sub(v_hy_263, J.mul(4.0, v_s_260)), J.mul(3.0, v_s_260), (J.mul(9.0, v_s_260) + J.mul((absf(J.num(v_i_265)) * 2.0), v_s_260)), J.mul(1.5, v_s_260), "#163238"])
		v_i_265 = J.num(v_i_265) + 1.0
	var _t434 = env["eyes"]
	J.cl(_t434, null, [v_ctx_257, v_x_258, J.add(v_hy_263, J.mul(2.0, v_s_260)), v_s_260, ("red" if J.t(J.gp(v_o_261, "enemy")) else "dot")])
	var _t435 = env["mouth"]
	J.cl(_t435, null, [v_ctx_257, v_x_258, J.add(v_hy_263, J.mul(1.0, v_s_260)), v_s_260, "wavy"])

func _f25(this_, a: Array, env):
	var v_ctx_268 = null; var v_x_269 = null; var v_y_270 = null; var v_s_271 = null; var v_o_272 = null; var v_t_273 = null; var v_fl_274 = null; var v_hy_275 = null; var v_sw_276 = null; var v_i_277 = null; var v_i_278 = null
	v_ctx_268 = J.arg(a, 0)
	v_x_269 = J.arg(a, 1)
	v_y_270 = J.arg(a, 2)
	v_s_271 = J.arg(a, 3)
	v_o_272 = J.arg(a, 4)
	v_t_273 = J.gp(v_o_272, "t")
	v_fl_274 = J.mul((sin(J.num(J.mul(v_t_273, 2.5))) * 2.0), v_s_271)
	var _t436 = J.sub(v_y_270, J.add(J.mul(3.0, v_s_271), v_fl_274))
	v_y_270 = _t436
	v_hy_275 = J.sub(v_y_270, J.mul(36.0, v_s_271))
	J.sp(v_ctx_268, "fillStyle", "#0d0a12")
	J.mc(v_ctx_268, "beginPath", [])
	J.mc(v_ctx_268, "moveTo", [J.sub(v_x_269, J.mul(13.0, v_s_271)), J.sub(v_hy_275, J.mul(2.0, v_s_271))])
	J.mc(v_ctx_268, "quadraticCurveTo", [J.sub(v_x_269, J.mul(17.0, v_s_271)), J.sub(v_y_270, J.mul(10.0, v_s_271)), (J.sub(v_x_269, J.mul(12.0, v_s_271)) + J.mul((sin(J.num(J.mul(v_t_273, 3.0))) * 2.0), v_s_271)), J.sub(v_y_270, J.mul(2.0, v_s_271))])
	J.mc(v_ctx_268, "lineTo", [J.add(J.add(v_x_269, J.mul(12.0, v_s_271)), J.mul((sin(J.num((J.mul(v_t_273, 3.0) + 1.0))) * 2.0), v_s_271)), J.sub(v_y_270, J.mul(2.0, v_s_271))])
	J.mc(v_ctx_268, "quadraticCurveTo", [J.add(v_x_269, J.mul(17.0, v_s_271)), J.sub(v_y_270, J.mul(10.0, v_s_271)), J.add(v_x_269, J.mul(13.0, v_s_271)), J.sub(v_hy_275, J.mul(2.0, v_s_271))])
	J.mc(v_ctx_268, "fill", [])
	var _t437 = env["poly"]
	J.cl(_t437, null, [v_ctx_268, [J.sub(v_x_269, J.mul(9.0, v_s_271)), J.sub(v_y_270, J.mul(25.0, v_s_271)), J.add(v_x_269, J.mul(9.0, v_s_271)), J.sub(v_y_270, J.mul(25.0, v_s_271)), J.add(v_x_269, J.mul(13.0, v_s_271)), J.add(v_y_270, J.mul(2.0, v_s_271)), J.sub(v_x_269, J.mul(13.0, v_s_271)), J.add(v_y_270, J.mul(2.0, v_s_271))], "#f4f2f6", env["OUT"], J.mul(1.6, v_s_271)])
	J.sp(v_ctx_268, "strokeStyle", "#cfcbe0")
	var _t438 = J.mul(1.0, v_s_271)
	J.sp(v_ctx_268, "lineWidth", _t438)
	v_i_277 = (-2.0)
	while true:
		if not J.cmp(v_i_277, 2.0, "<="): break
		J.mc(v_ctx_268, "beginPath", [])
		J.mc(v_ctx_268, "moveTo", [J.add(v_x_269, J.mul(J.mul(v_i_277, 3.0), v_s_271)), J.sub(v_y_270, J.mul(20.0, v_s_271))])
		J.mc(v_ctx_268, "lineTo", [J.add(v_x_269, J.mul(J.mul(v_i_277, 4.5), v_s_271)), J.add(v_y_270, J.mul(1.0, v_s_271))])
		J.mc(v_ctx_268, "stroke", [])
		v_i_277 = J.num(v_i_277) + 1.0
	v_sw_276 = (J.mul(6.0, v_s_271) if J.t(J.gp(v_o_272, "atk")) else 0.0)
	var _t439 = env["arm"]
	J.cl(_t439, null, [v_ctx_268, J.sub(v_x_269, J.mul(8.0, v_s_271)), J.sub(v_y_270, J.mul(22.0, v_s_271)), J.sub(v_x_269, J.mul(13.0, v_s_271)), J.sub(v_y_270, J.mul(13.0, v_s_271)), v_s_271, "#f4f2f6"])
	var _t440 = env["arm"]
	J.cl(_t440, null, [v_ctx_268, J.add(v_x_269, J.mul(8.0, v_s_271)), J.sub(v_y_270, J.mul(22.0, v_s_271)), J.add(J.add(v_x_269, J.mul(14.0, v_s_271)), v_sw_276), J.sub(J.sub(v_y_270, J.mul(16.0, v_s_271)), v_sw_276), v_s_271, "#f4f2f6"])
	J.sp(v_ctx_268, "strokeStyle", "#b8b0c8")
	var _t441 = J.mul(1.0, v_s_271)
	J.sp(v_ctx_268, "lineWidth", _t441)
	v_i_278 = 0.0
	while true:
		if not J.cmp(v_i_278, 3.0, "<"): break
		J.mc(v_ctx_268, "beginPath", [])
		J.mc(v_ctx_268, "moveTo", [J.add(J.add(v_x_269, J.mul(14.0, v_s_271)), v_sw_276), (J.sub(J.sub(v_y_270, J.mul(16.0, v_s_271)), v_sw_276) + J.mul(v_i_278, v_s_271))])
		J.mc(v_ctx_268, "lineTo", [J.add(J.add(v_x_269, J.mul(19.0, v_s_271)), v_sw_276), (J.sub(J.sub(v_y_270, J.mul(18.0, v_s_271)), v_sw_276) + J.mul(J.mul(v_i_278, 2.0), v_s_271))])
		J.mc(v_ctx_268, "stroke", [])
		v_i_278 = J.num(v_i_278) + 1.0
	var _t442 = env["el"]
	J.cl(_t442, null, [v_ctx_268, v_x_269, v_hy_275, J.mul(12.0, v_s_271), J.mul(12.5, v_s_271), "#efe9f2", env["OUT"], J.mul(1.8, v_s_271)])
	J.sp(v_ctx_268, "fillStyle", "#0d0a12")
	J.mc(v_ctx_268, "beginPath", [])
	J.mc(v_ctx_268, "ellipse", [v_x_269, J.sub(v_hy_275, J.mul(2.0, v_s_271)), J.mul(13.0, v_s_271), J.mul(11.0, v_s_271), 0.0, PI, env["TAU"]])
	J.mc(v_ctx_268, "fill", [])
	var _t443 = env["rr"]
	J.cl(_t443, null, [v_ctx_268, J.sub(v_x_269, J.mul(13.0, v_s_271)), J.sub(v_hy_275, J.mul(3.0, v_s_271)), J.mul(5.0, v_s_271), J.mul(15.0, v_s_271), J.mul(2.0, v_s_271), "#0d0a12"])
	var _t444 = env["rr"]
	J.cl(_t444, null, [v_ctx_268, J.add(v_x_269, J.mul(8.0, v_s_271)), J.sub(v_hy_275, J.mul(3.0, v_s_271)), J.mul(5.0, v_s_271), J.mul(15.0, v_s_271), J.mul(2.0, v_s_271), "#0d0a12"])
	if J.t(J.gp(v_o_272, "tamed")):
		var _t445 = env["eyes"]
		J.cl(_t445, null, [v_ctx_268, v_x_269, J.add(v_hy_275, J.mul(2.0, v_s_271)), v_s_271, "closed"])
		var _t446 = env["blush"]
		J.cl(_t446, null, [v_ctx_268, v_x_269, J.add(v_hy_275, J.mul(1.0, v_s_271)), v_s_271])
		var _t447 = env["mouth"]
		J.cl(_t447, null, [v_ctx_268, v_x_269, J.add(v_hy_275, J.mul(1.0, v_s_271)), v_s_271, "smile"])
	else:
		var _t448 = env["eyes"]
		J.cl(_t448, null, [v_ctx_268, v_x_269, J.add(v_hy_275, J.mul(2.0, v_s_271)), v_s_271, "red"])
		var _t449 = env["mouth"]
		J.cl(_t449, null, [v_ctx_268, v_x_269, J.add(v_hy_275, J.mul(1.0, v_s_271)), v_s_271, "fang"])

func _f26(this_, a: Array, env):
	var v_ctx_281 = null; var v_x_282 = null; var v_y_283 = null; var v_s_284 = null; var v_o_285 = null; var v_t_286 = null; var v_hop_287 = null; var v_hy_288 = null; var v_i_289 = null
	v_ctx_281 = J.arg(a, 0)
	v_x_282 = J.arg(a, 1)
	v_y_283 = J.arg(a, 2)
	v_s_284 = J.arg(a, 3)
	v_o_285 = J.arg(a, 4)
	v_t_286 = J.gp(v_o_285, "t")
	v_hop_287 = J.mul((absf(J.num(sin(J.num(J.mul(v_t_286, 5.0))))) * 6.0), v_s_284)
	var _t450 = J.sub(v_y_283, v_hop_287)
	v_y_283 = _t450
	v_hy_288 = J.sub(v_y_283, J.mul(34.0, v_s_284))
	var _t451 = env["el"]
	J.cl(_t451, null, [v_ctx_281, v_x_282, J.sub(v_y_283, J.mul(14.0, v_s_284)), J.mul(11.0, v_s_284), J.mul(16.0, v_s_284), "#f1efe8", env["OUT"], J.mul(1.8, v_s_284)])
	J.sp(v_ctx_281, "strokeStyle", "#c9c4b4")
	var _t452 = J.mul(1.2, v_s_284)
	J.sp(v_ctx_281, "lineWidth", _t452)
	v_i_289 = 0.0
	while true:
		if not J.cmp(v_i_289, 3.0, "<"): break
		J.mc(v_ctx_281, "beginPath", [])
		J.mc(v_ctx_281, "moveTo", [J.sub(v_x_282, J.mul(10.0, v_s_284)), (J.sub(v_y_283, J.mul(22.0, v_s_284)) + J.mul(J.mul(v_i_289, 7.0), v_s_284))])
		J.mc(v_ctx_281, "quadraticCurveTo", [v_x_282, (J.sub(v_y_283, J.mul(18.0, v_s_284)) + J.mul(J.mul(v_i_289, 7.0), v_s_284)), J.add(v_x_282, J.mul(10.0, v_s_284)), (J.sub(v_y_283, J.mul(22.0, v_s_284)) + J.mul(J.mul(v_i_289, 7.0), v_s_284))])
		J.mc(v_ctx_281, "stroke", [])
		v_i_289 = J.num(v_i_289) + 1.0
	J.sp(v_ctx_281, "strokeStyle", "#9b927a")
	var _t453 = J.mul(1.6, v_s_284)
	J.sp(v_ctx_281, "lineWidth", _t453)
	J.mc(v_ctx_281, "beginPath", [])
	J.mc(v_ctx_281, "moveTo", [J.sub(v_x_282, J.mul(9.0, v_s_284)), J.sub(v_y_283, J.mul(4.0, v_s_284))])
	J.mc(v_ctx_281, "lineTo", [J.add(v_x_282, J.mul(9.0, v_s_284)), J.sub(v_y_283, J.mul(4.0, v_s_284))])
	J.mc(v_ctx_281, "stroke", [])
	var _t454 = env["el"]
	J.cl(_t454, null, [v_ctx_281, v_x_282, v_hy_288, J.mul(12.0, v_s_284), J.mul(12.5, v_s_284), "#f1efe8", env["OUT"], J.mul(1.8, v_s_284)])
	var _t455 = env["el"]
	J.cl(_t455, null, [v_ctx_281, v_x_282, J.add(v_hy_288, J.mul(2.0, v_s_284)), J.mul(7.5, v_s_284), J.mul(8.0, v_s_284), "#cfd6c9", env["OUT"], J.mul(1.0, v_s_284)])
	if (not J.t(J.gp(v_o_285, "untied"))):
		var _t456 = env["poly"]
		J.cl(_t456, null, [v_ctx_281, [v_x_282, J.sub(v_hy_288, J.mul(12.0, v_s_284)), J.sub(v_x_282, J.mul(5.0, v_s_284)), J.sub(v_hy_288, J.mul(20.0, v_s_284)), J.add(v_x_282, J.mul(1.0, v_s_284)), J.sub(v_hy_288, J.mul(16.0, v_s_284))], "#f1efe8", env["OUT"], J.mul(1.2, v_s_284)])
		var _t457 = env["poly"]
		J.cl(_t457, null, [v_ctx_281, [v_x_282, J.sub(v_hy_288, J.mul(12.0, v_s_284)), J.add(v_x_282, J.mul(6.0, v_s_284)), J.sub(v_hy_288, J.mul(20.0, v_s_284)), J.add(v_x_282, J.mul(1.0, v_s_284)), J.sub(v_hy_288, J.mul(16.0, v_s_284))], "#f1efe8", env["OUT"], J.mul(1.2, v_s_284)])
	else:
		var _t458 = env["el"]
		J.cl(_t458, null, [v_ctx_281, v_x_282, J.sub(v_hy_288, J.mul(12.0, v_s_284)), J.mul(3.0, v_s_284), J.mul(2.0, v_s_284), "#f1efe8", env["OUT"], J.mul(1.0, v_s_284)])
		var _t459 = env["arm"]
		J.cl(_t459, null, [v_ctx_281, J.add(v_x_282, J.mul(9.0, v_s_284)), J.sub(v_y_283, J.mul(20.0, v_s_284)), J.add(v_x_282, J.mul(14.0, v_s_284)), J.sub(v_y_283, J.mul(34.0, v_s_284)), v_s_284, "#f1efe8"])
	var _t460 = env["eyes"]
	J.cl(_t460, null, [v_ctx_281, v_x_282, J.add(v_hy_288, J.mul(2.5, v_s_284)), J.mul(v_s_284, 0.8), ("red" if J.t(J.gp(v_o_285, "enemy")) else "dot")])
	var _t461 = env["mouth"]
	J.cl(_t461, null, [v_ctx_281, v_x_282, J.sub(v_hy_288, J.mul(0.5, v_s_284)), J.mul(v_s_284, 0.8), "open"])

func _f27(this_, a: Array, env):
	var v_ctx_292 = null; var v_x_293 = null; var v_y_294 = null; var v_s_295 = null; var v_o_296 = null; var v_t_297 = null; var v_hy_298 = null; var v_i_299 = null; var v_bx_300 = null; var v_i_301 = null
	v_ctx_292 = J.arg(a, 0)
	v_x_293 = J.arg(a, 1)
	v_y_294 = J.arg(a, 2)
	v_s_295 = J.arg(a, 3)
	v_o_296 = J.arg(a, 4)
	v_t_297 = J.gp(v_o_296, "t")
	v_hy_298 = (J.sub(v_y_294, J.mul(40.0, v_s_295)) + J.mul((sin(J.num(J.mul(v_t_297, 2.5))) * 3.0), v_s_295))
	v_i_299 = 0.0
	while true:
		if not J.cmp(v_i_299, 4.0, "<"): break
		var _t462 = J.gp(["#e0607a", "#c84466", "#f08aa0", "#b8385a"], v_i_299)
		J.sp(v_ctx_292, "strokeStyle", _t462)
		var _t463 = J.mul(3.0, v_s_295)
		J.sp(v_ctx_292, "lineWidth", _t463)
		J.sp(v_ctx_292, "lineCap", "round")
		J.mc(v_ctx_292, "beginPath", [])
		v_bx_300 = (J.sub(v_x_293, J.mul(6.0, v_s_295)) + J.mul(J.mul(v_i_299, 4.0), v_s_295))
		J.mc(v_ctx_292, "moveTo", [v_bx_300, J.add(v_hy_298, J.mul(8.0, v_s_295))])
		J.mc(v_ctx_292, "bezierCurveTo", [J.add(v_bx_300, J.mul((sin(J.num(J.add(J.mul(v_t_297, 3.0), v_i_299))) * 5.0), v_s_295)), J.add(v_hy_298, J.mul(18.0, v_s_295)), J.sub(v_bx_300, J.mul((sin(J.num(J.add(J.mul(v_t_297, 3.0), v_i_299))) * 5.0), v_s_295)), J.add(v_hy_298, J.mul(26.0, v_s_295)), J.add(v_bx_300, J.mul((sin(J.num(J.add(J.mul(v_t_297, 2.0), v_i_299))) * 3.0), v_s_295)), J.add(v_hy_298, J.mul(34.0, v_s_295))])
		J.mc(v_ctx_292, "stroke", [])
		v_i_299 = J.num(v_i_299) + 1.0
	var _t464 = env["el"]
	J.cl(_t464, null, [v_ctx_292, v_x_293, v_hy_298, J.mul(13.0, v_s_295), J.mul(12.5, v_s_295), "#e8d4c4", env["OUT"], J.mul(1.8, v_s_295)])
	J.sp(v_ctx_292, "fillStyle", "#1b0f14")
	J.mc(v_ctx_292, "beginPath", [])
	J.mc(v_ctx_292, "ellipse", [v_x_293, J.sub(v_hy_298, J.mul(3.0, v_s_295)), J.mul(14.0, v_s_295), J.mul(11.0, v_s_295), 0.0, PI, env["TAU"]])
	J.mc(v_ctx_292, "fill", [])
	v_i_301 = (-3.0)
	while true:
		if not J.cmp(v_i_301, 3.0, "<="): break
		J.sp(v_ctx_292, "strokeStyle", "#1b0f14")
		var _t465 = J.mul(2.5, v_s_295)
		J.sp(v_ctx_292, "lineWidth", _t465)
		J.mc(v_ctx_292, "beginPath", [])
		J.mc(v_ctx_292, "moveTo", [J.add(v_x_293, J.mul(J.mul(v_i_301, 4.0), v_s_295)), J.sub(v_hy_298, J.mul(6.0, v_s_295))])
		J.mc(v_ctx_292, "quadraticCurveTo", [J.add(J.add(v_x_293, J.mul(J.mul(v_i_301, 6.0), v_s_295)), J.mul((sin(J.num(J.add(J.mul(v_t_297, 4.0), v_i_301))) * 3.0), v_s_295)), J.sub(v_hy_298, J.mul(16.0, v_s_295)), J.add(v_x_293, J.mul(J.mul(v_i_301, 7.0), v_s_295)), J.sub(v_hy_298, J.mul(22.0, v_s_295))])
		J.mc(v_ctx_292, "stroke", [])
		v_i_301 = J.num(v_i_301) + 1.0
	var _t466 = env["rr"]
	J.cl(_t466, null, [v_ctx_292, J.sub(v_x_293, J.mul(14.0, v_s_295)), J.sub(v_hy_298, J.mul(3.0, v_s_295)), J.mul(4.0, v_s_295), J.mul(10.0, v_s_295), J.mul(2.0, v_s_295), "#1b0f14"])
	var _t467 = env["rr"]
	J.cl(_t467, null, [v_ctx_292, J.add(v_x_293, J.mul(10.0, v_s_295)), J.sub(v_hy_298, J.mul(3.0, v_s_295)), J.mul(4.0, v_s_295), J.mul(10.0, v_s_295), J.mul(2.0, v_s_295), "#1b0f14"])
	var _t468 = env["eyes"]
	J.cl(_t468, null, [v_ctx_292, v_x_293, J.add(v_hy_298, J.mul(1.0, v_s_295)), v_s_295, ("red" if J.t(J.gp(v_o_296, "enemy")) else "normal")])
	var _t469 = env["mouth"]
	J.cl(_t469, null, [v_ctx_292, v_x_293, v_hy_298, v_s_295, ("fang" if J.t(J.gp(v_o_296, "enemy")) else "smile")])

func _f28(this_, a: Array, env):
	var v_ctx_304 = null; var v_x_305 = null; var v_y_306 = null; var v_s_307 = null; var v_o_308 = null; var v_t_309 = null; var v_hy_310 = null; var v_sw_311 = null
	v_ctx_304 = J.arg(a, 0)
	v_x_305 = J.arg(a, 1)
	v_y_306 = J.arg(a, 2)
	v_s_307 = J.arg(a, 3)
	v_o_308 = J.arg(a, 4)
	v_t_309 = J.gp(v_o_308, "t")
	v_hy_310 = J.sub(v_y_306, J.mul(32.0, v_s_307))
	var _t470 = env["wisp"]
	J.cl(_t470, null, [v_ctx_304, v_x_305, v_y_306, v_s_307, "#6b4a7a", v_t_309, 9.0])
	var _t471 = env["poly"]
	J.cl(_t471, null, [v_ctx_304, [J.sub(v_x_305, J.mul(11.0, v_s_307)), J.sub(v_y_306, J.mul(5.0, v_s_307)), J.add(v_x_305, J.mul(11.0, v_s_307)), J.sub(v_y_306, J.mul(5.0, v_s_307)), J.add(v_x_305, J.mul(8.0, v_s_307)), J.sub(v_y_306, J.mul(23.0, v_s_307)), J.sub(v_x_305, J.mul(8.0, v_s_307)), J.sub(v_y_306, J.mul(23.0, v_s_307))], "#6b4a7a", env["OUT"], J.mul(1.6, v_s_307)])
	var _t472 = env["rr"]
	J.cl(_t472, null, [v_ctx_304, J.sub(v_x_305, J.mul(8.0, v_s_307)), J.sub(v_y_306, J.mul(16.0, v_s_307)), J.mul(16.0, v_s_307), J.mul(11.0, v_s_307), J.mul(2.0, v_s_307), "#e9e1d2", env["OUT"], J.mul(1.0, v_s_307)])
	var _t473 = env["arm"]
	J.cl(_t473, null, [v_ctx_304, J.sub(v_x_305, J.mul(8.0, v_s_307)), J.sub(v_y_306, J.mul(20.0, v_s_307)), J.sub(v_x_305, J.mul(12.0, v_s_307)), J.sub(v_y_306, J.mul(12.0, v_s_307)), v_s_307, "#6b4a7a"])
	v_sw_311 = (J.mul((sin(J.num(J.mul(v_t_309, 8.0))) * 3.0), v_s_307) if J.t(J.gp(v_o_308, "work")) else 0.0)
	var _t474 = env["arm"]
	J.cl(_t474, null, [v_ctx_304, J.add(v_x_305, J.mul(8.0, v_s_307)), J.sub(v_y_306, J.mul(20.0, v_s_307)), J.add(v_x_305, J.mul(13.0, v_s_307)), J.add(J.sub(v_y_306, J.mul(16.0, v_s_307)), v_sw_311), v_s_307, "#6b4a7a"])
	var _t475 = env["el"]
	J.cl(_t475, null, [v_ctx_304, J.add(v_x_305, J.mul(15.0, v_s_307)), J.add(J.sub(v_y_306, J.mul(13.0, v_s_307)), v_sw_311), J.mul(5.0, v_s_307), J.mul(3.0, v_s_307), "#c9b38a", env["OUT"], J.mul(1.0, v_s_307)])
	var _t476 = env["el"]
	J.cl(_t476, null, [v_ctx_304, J.add(v_x_305, J.mul(15.0, v_s_307)), J.add(J.sub(v_y_306, J.mul(14.0, v_s_307)), v_sw_311), J.mul(3.5, v_s_307), J.mul(1.4, v_s_307), "#7a6a9a"])
	var _t477 = env["el"]
	J.cl(_t477, null, [v_ctx_304, v_x_305, v_hy_310, J.mul(12.5, v_s_307), J.mul(12.0, v_s_307), "#e8d8c8", env["OUT"], J.mul(1.8, v_s_307)])
	J.sp(v_ctx_304, "fillStyle", "#d8d8d8")
	J.mc(v_ctx_304, "beginPath", [])
	J.mc(v_ctx_304, "ellipse", [v_x_305, J.sub(v_hy_310, J.mul(4.0, v_s_307)), J.mul(13.0, v_s_307), J.mul(9.0, v_s_307), 0.0, PI, env["TAU"]])
	J.mc(v_ctx_304, "fill", [])
	var _t478 = env["el"]
	J.cl(_t478, null, [v_ctx_304, v_x_305, J.sub(v_hy_310, J.mul(13.0, v_s_307)), J.mul(6.0, v_s_307), J.mul(5.0, v_s_307), "#d8d8d8", env["OUT"], J.mul(1.0, v_s_307)])
	J.sp(v_ctx_304, "fillStyle", "#c33")
	J.mc(v_ctx_304, "fillRect", [J.sub(v_x_305, J.mul(1.0, v_s_307)), J.sub(v_hy_310, J.mul(18.0, v_s_307)), J.mul(2.0, v_s_307), J.mul(6.0, v_s_307)])
	var _t479 = env["eyes"]
	J.cl(_t479, null, [v_ctx_304, v_x_305, J.add(v_hy_310, J.mul(1.0, v_s_307)), v_s_307, "closed"])
	var _t480 = env["mouth"]
	J.cl(_t480, null, [v_ctx_304, v_x_305, v_hy_310, v_s_307, "smile"])
	J.sp(v_ctx_304, "strokeStyle", "rgba(80,60,40,.5)")
	var _t481 = J.mul(0.8, v_s_307)
	J.sp(v_ctx_304, "lineWidth", _t481)
	J.mc(v_ctx_304, "beginPath", [])
	J.mc(v_ctx_304, "moveTo", [J.sub(v_x_305, J.mul(9.0, v_s_307)), J.add(v_hy_310, J.mul(6.0, v_s_307))])
	J.mc(v_ctx_304, "lineTo", [J.sub(v_x_305, J.mul(6.0, v_s_307)), J.add(v_hy_310, J.mul(7.0, v_s_307))])
	J.mc(v_ctx_304, "moveTo", [J.add(v_x_305, J.mul(9.0, v_s_307)), J.add(v_hy_310, J.mul(6.0, v_s_307))])
	J.mc(v_ctx_304, "lineTo", [J.add(v_x_305, J.mul(6.0, v_s_307)), J.add(v_hy_310, J.mul(7.0, v_s_307))])
	J.mc(v_ctx_304, "stroke", [])

func _f29(this_, a: Array, env):
	var v_ctx_314 = null; var v_x_315 = null; var v_y_316 = null; var v_s_317 = null; var v_o_318 = null; var v_white_319 = null; var v_t_320 = null; var v_hy_321 = null; var v_col_322 = null; var v_skin_323 = null; var v_txt_324 = null; var v_i_325 = null
	v_ctx_314 = J.arg(a, 0)
	v_x_315 = J.arg(a, 1)
	v_y_316 = J.arg(a, 2)
	v_s_317 = J.arg(a, 3)
	v_o_318 = J.arg(a, 4)
	v_white_319 = J.arg(a, 5)
	v_t_320 = J.gp(v_o_318, "t")
	v_hy_321 = J.sub(v_y_316, J.mul(36.0, v_s_317))
	v_col_322 = ("#f2f2f6" if J.t(v_white_319) else "#22222c")
	v_skin_323 = ("#f4f4fa" if J.t(v_white_319) else "#5a5a6a")
	var _t482 = env["wisp"]
	J.cl(_t482, null, [v_ctx_314, v_x_315, v_y_316, v_s_317, v_col_322, v_t_320, 10.0])
	var _t483 = env["poly"]
	J.cl(_t483, null, [v_ctx_314, [J.sub(v_x_315, J.mul(12.0, v_s_317)), J.sub(v_y_316, J.mul(5.0, v_s_317)), J.add(v_x_315, J.mul(12.0, v_s_317)), J.sub(v_y_316, J.mul(5.0, v_s_317)), J.add(v_x_315, J.mul(9.0, v_s_317)), J.sub(v_y_316, J.mul(26.0, v_s_317)), J.sub(v_x_315, J.mul(9.0, v_s_317)), J.sub(v_y_316, J.mul(26.0, v_s_317))], v_col_322, env["OUT"], J.mul(1.6, v_s_317)])
	var _t484 = env["arm"]
	J.cl(_t484, null, [v_ctx_314, J.sub(v_x_315, J.mul(8.0, v_s_317)), J.sub(v_y_316, J.mul(22.0, v_s_317)), J.sub(v_x_315, J.mul(13.0, v_s_317)), J.sub(v_y_316, J.mul(12.0, v_s_317)), v_s_317, v_col_322])
	var _t485 = env["arm"]
	J.cl(_t485, null, [v_ctx_314, J.add(v_x_315, J.mul(8.0, v_s_317)), J.sub(v_y_316, J.mul(22.0, v_s_317)), J.add(v_x_315, J.mul(14.0, v_s_317)), J.sub(v_y_316, J.mul(16.0, v_s_317)), v_s_317, v_col_322])
	if J.t(v_white_319):
		var _t486 = env["rr"]
		J.cl(_t486, null, [v_ctx_314, J.add(v_x_315, J.mul(13.0, v_s_317)), J.sub(v_y_316, J.mul(34.0, v_s_317)), J.mul(2.0, v_s_317), J.mul(24.0, v_s_317), J.mul(1.0, v_s_317), "#8a6a3a", env["OUT"], J.mul(0.8, v_s_317)])
		var _t487 = env["el"]
		J.cl(_t487, null, [v_ctx_314, J.add(v_x_315, J.mul(14.0, v_s_317)), J.sub(v_y_316, J.mul(35.0, v_s_317)), J.mul(5.0, v_s_317), J.mul(4.0, v_s_317), "#f8f8ff", env["OUT"], J.mul(1.0, v_s_317)])
	else:
		J.sp(v_ctx_314, "strokeStyle", "#8890a0")
		var _t488 = J.mul(2.0, v_s_317)
		J.sp(v_ctx_314, "lineWidth", _t488)
		J.mc(v_ctx_314, "setLineDash", [[J.mul(2.5, v_s_317), J.mul(1.5, v_s_317)]])
		J.mc(v_ctx_314, "beginPath", [])
		J.mc(v_ctx_314, "moveTo", [J.add(v_x_315, J.mul(14.0, v_s_317)), J.sub(v_y_316, J.mul(16.0, v_s_317))])
		J.mc(v_ctx_314, "quadraticCurveTo", [J.add(v_x_315, J.mul(20.0, v_s_317)), J.sub(v_y_316, J.mul(6.0, v_s_317)), J.add(v_x_315, J.mul(12.0, v_s_317)), J.sub(v_y_316, J.mul(2.0, v_s_317))])
		J.mc(v_ctx_314, "stroke", [])
		J.mc(v_ctx_314, "setLineDash", [[]])
	var _t489 = env["el"]
	J.cl(_t489, null, [v_ctx_314, v_x_315, v_hy_321, J.mul(12.5, v_s_317), J.mul(12.0, v_s_317), v_skin_323, env["OUT"], J.mul(1.8, v_s_317)])
	var _t490 = env["poly"]
	J.cl(_t490, null, [v_ctx_314, [J.sub(v_x_315, J.mul(10.0, v_s_317)), J.sub(v_hy_321, J.mul(8.0, v_s_317)), J.add(v_x_315, J.mul(10.0, v_s_317)), J.sub(v_hy_321, J.mul(8.0, v_s_317)), J.add(v_x_315, J.mul(5.0, v_s_317)), J.sub(v_hy_321, J.mul(36.0, v_s_317)), J.sub(v_x_315, J.mul(5.0, v_s_317)), J.sub(v_hy_321, J.mul(36.0, v_s_317))], v_col_322, env["OUT"], J.mul(1.6, v_s_317)])
	J.mc(v_ctx_314, "save", [])
	var _t491 = ("#c41a2a" if J.t(v_white_319) else "#e8e8f0")
	J.sp(v_ctx_314, "fillStyle", _t491)
	var _t492 = ("bold " + J.str(J.mul(5.2, v_s_317)) + "px \"PingFang TC\",\"Noto Sans TC\",sans-serif")
	J.sp(v_ctx_314, "font", _t492)
	J.sp(v_ctx_314, "textAlign", "center")
	J.sp(v_ctx_314, "textBaseline", "middle")
	v_txt_324 = ("一見生財" if J.t(v_white_319) else "天下太平")
	v_i_325 = 0.0
	while true:
		if not J.cmp(v_i_325, 4.0, "<"): break
		J.mc(v_ctx_314, "fillText", [J.gp(v_txt_324, v_i_325), v_x_315, (J.sub(v_hy_321, J.mul(31.0, v_s_317)) + J.mul(J.mul(v_i_325, 5.6), v_s_317))])
		v_i_325 = J.num(v_i_325) + 1.0
	J.mc(v_ctx_314, "restore", [])
	if J.t(v_white_319):
		var _t493 = env["eyes"]
		J.cl(_t493, null, [v_ctx_314, v_x_315, J.add(v_hy_321, J.mul(2.0, v_s_317)), v_s_317, "closed"])
		var _t494 = env["poly"]
		J.cl(_t494, null, [v_ctx_314, [J.sub(v_x_315, J.mul(1.5, v_s_317)), J.add(v_hy_321, J.mul(6.0, v_s_317)), J.add(v_x_315, J.mul(1.5, v_s_317)), J.add(v_hy_321, J.mul(6.0, v_s_317)), J.add(v_x_315, J.mul(1.0, v_s_317)), J.add(v_hy_321, J.mul(16.0, v_s_317)), J.sub(v_x_315, J.mul(1.0, v_s_317)), J.add(v_hy_321, J.mul(16.0, v_s_317))], "#d22", env["OUT"], J.mul(0.8, v_s_317)])
	else:
		var _t495 = env["eyes"]
		J.cl(_t495, null, [v_ctx_314, v_x_315, J.add(v_hy_321, J.mul(2.0, v_s_317)), v_s_317, "angry"])
		var _t496 = env["mouth"]
		J.cl(_t496, null, [v_ctx_314, v_x_315, J.add(v_hy_321, J.mul(1.0, v_s_317)), v_s_317, "flat"])

func _f30(this_, a: Array, env):
	var v_ctx_328 = null; var v_x_329 = null; var v_y_330 = null; var v_s_331 = null; var v_o_332 = null
	v_ctx_328 = J.arg(a, 0)
	v_x_329 = J.arg(a, 1)
	v_y_330 = J.arg(a, 2)
	v_s_331 = J.arg(a, 3)
	v_o_332 = J.arg(a, 4)
	J.mc(env["DRAW"], "wuchang", [v_ctx_328, v_x_329, v_y_330, v_s_331, v_o_332, true])

func _f31(this_, a: Array, env):
	var v_ctx_335 = null; var v_x_336 = null; var v_y_337 = null; var v_s_338 = null; var v_o_339 = null
	v_ctx_335 = J.arg(a, 0)
	v_x_336 = J.arg(a, 1)
	v_y_337 = J.arg(a, 2)
	v_s_338 = J.arg(a, 3)
	v_o_339 = J.arg(a, 4)
	J.mc(env["DRAW"], "wuchang", [v_ctx_335, v_x_336, v_y_337, v_s_338, v_o_339, false])

func _f32(this_, a: Array, env):
	var v_ctx_342 = null; var v_x_343 = null; var v_y_344 = null; var v_s_345 = null; var v_o_346 = null; var v_t_347 = null; var v_hy_348 = null
	v_ctx_342 = J.arg(a, 0)
	v_x_343 = J.arg(a, 1)
	v_y_344 = J.arg(a, 2)
	v_s_345 = J.arg(a, 3)
	v_o_346 = J.arg(a, 4)
	v_t_347 = J.gp(v_o_346, "t")
	v_hy_348 = J.sub(v_y_344, J.mul(36.0, v_s_345))
	var _t497 = env["wisp"]
	J.cl(_t497, null, [v_ctx_342, v_x_343, v_y_344, v_s_345, "#7a4a32", v_t_347, 10.0])
	var _t498 = env["body"]
	J.cl(_t498, null, [v_ctx_342, v_x_343, J.sub(v_y_344, J.mul(5.0, v_s_345)), J.mul(v_s_345, 1.15), "#7a4a32"])
	var _t499 = env["rr"]
	J.cl(_t499, null, [v_ctx_342, J.sub(v_x_343, J.mul(9.0, v_s_345)), J.sub(v_y_344, J.mul(20.0, v_s_345)), J.mul(18.0, v_s_345), J.mul(8.0, v_s_345), J.mul(2.0, v_s_345), "#9a9aa8", env["OUT"], J.mul(1.0, v_s_345)])
	var _t500 = env["arm"]
	J.cl(_t500, null, [v_ctx_342, J.sub(v_x_343, J.mul(10.0, v_s_345)), J.sub(v_y_344, J.mul(20.0, v_s_345)), J.sub(v_x_343, J.mul(15.0, v_s_345)), J.sub(v_y_344, J.mul(10.0, v_s_345)), J.mul(v_s_345, 1.2), "#7a4a32"])
	var _t501 = env["arm"]
	J.cl(_t501, null, [v_ctx_342, J.add(v_x_343, J.mul(10.0, v_s_345)), J.sub(v_y_344, J.mul(20.0, v_s_345)), J.add(v_x_343, J.mul(16.0, v_s_345)), J.sub(v_y_344, J.mul(13.0, v_s_345)), J.mul(v_s_345, 1.2), "#7a4a32"])
	var _t502 = env["rr"]
	J.cl(_t502, null, [v_ctx_342, J.add(v_x_343, J.mul(15.0, v_s_345)), J.sub(v_y_344, J.mul(40.0, v_s_345)), J.mul(2.5, v_s_345), J.mul(34.0, v_s_345), J.mul(1.0, v_s_345), "#5a3a1a", env["OUT"], J.mul(0.8, v_s_345)])
	var _t503 = env["poly"]
	J.cl(_t503, null, [v_ctx_342, [J.add(v_x_343, J.mul(16.0, v_s_345)), J.sub(v_y_344, J.mul(46.0, v_s_345)), J.add(v_x_343, J.mul(21.0, v_s_345)), J.sub(v_y_344, J.mul(38.0, v_s_345)), J.add(v_x_343, J.mul(11.0, v_s_345)), J.sub(v_y_344, J.mul(38.0, v_s_345))], "#bfc8d6", env["OUT"], J.mul(1.0, v_s_345)])
	var _t504 = env["el"]
	J.cl(_t504, null, [v_ctx_342, v_x_343, v_hy_348, J.mul(14.0, v_s_345), J.mul(12.0, v_s_345), "#8a5a3c", env["OUT"], J.mul(1.8, v_s_345)])
	var _t505 = env["poly"]
	J.cl(_t505, null, [v_ctx_342, [J.sub(v_x_343, J.mul(12.0, v_s_345)), J.sub(v_hy_348, J.mul(6.0, v_s_345)), J.sub(v_x_343, J.mul(22.0, v_s_345)), J.sub(v_hy_348, J.mul(16.0, v_s_345)), J.sub(v_x_343, J.mul(9.0, v_s_345)), J.sub(v_hy_348, J.mul(10.0, v_s_345))], "#efe6cf", env["OUT"], J.mul(1.2, v_s_345)])
	var _t506 = env["poly"]
	J.cl(_t506, null, [v_ctx_342, [J.add(v_x_343, J.mul(12.0, v_s_345)), J.sub(v_hy_348, J.mul(6.0, v_s_345)), J.add(v_x_343, J.mul(22.0, v_s_345)), J.sub(v_hy_348, J.mul(16.0, v_s_345)), J.add(v_x_343, J.mul(9.0, v_s_345)), J.sub(v_hy_348, J.mul(10.0, v_s_345))], "#efe6cf", env["OUT"], J.mul(1.2, v_s_345)])
	var _t507 = env["el"]
	J.cl(_t507, null, [v_ctx_342, v_x_343, J.add(v_hy_348, J.mul(6.0, v_s_345)), J.mul(8.0, v_s_345), J.mul(5.0, v_s_345), "#c09078", env["OUT"], J.mul(1.0, v_s_345)])
	var _t508 = env["el"]
	J.cl(_t508, null, [v_ctx_342, J.sub(v_x_343, J.mul(3.0, v_s_345)), J.add(v_hy_348, J.mul(6.0, v_s_345)), J.mul(1.2, v_s_345), J.mul(1.5, v_s_345), env["OUT"]])
	var _t509 = env["el"]
	J.cl(_t509, null, [v_ctx_342, J.add(v_x_343, J.mul(3.0, v_s_345)), J.add(v_hy_348, J.mul(6.0, v_s_345)), J.mul(1.2, v_s_345), J.mul(1.5, v_s_345), env["OUT"]])
	var _t510 = env["el"]
	J.cl(_t510, null, [v_ctx_342, v_x_343, J.add(v_hy_348, J.mul(10.0, v_s_345)), J.mul(2.5, v_s_345), J.mul(1.5, v_s_345), null, "#e0c040", J.mul(1.0, v_s_345)])
	var _t511 = env["eyes"]
	J.cl(_t511, null, [v_ctx_342, v_x_343, J.sub(v_hy_348, J.mul(3.0, v_s_345)), v_s_345, "angry"])

func _f33(this_, a: Array, env):
	var v_ctx_351 = null; var v_x_352 = null; var v_y_353 = null; var v_s_354 = null; var v_o_355 = null; var v_t_356 = null; var v_hy_357 = null; var v_i_358 = null
	v_ctx_351 = J.arg(a, 0)
	v_x_352 = J.arg(a, 1)
	v_y_353 = J.arg(a, 2)
	v_s_354 = J.arg(a, 3)
	v_o_355 = J.arg(a, 4)
	v_t_356 = J.gp(v_o_355, "t")
	v_hy_357 = J.sub(v_y_353, J.mul(36.0, v_s_354))
	var _t512 = env["wisp"]
	J.cl(_t512, null, [v_ctx_351, v_x_352, v_y_353, v_s_354, "#3c4a6a", v_t_356, 10.0])
	var _t513 = env["body"]
	J.cl(_t513, null, [v_ctx_351, v_x_352, J.sub(v_y_353, J.mul(5.0, v_s_354)), J.mul(v_s_354, 1.1), "#3c4a6a"])
	var _t514 = env["rr"]
	J.cl(_t514, null, [v_ctx_351, J.sub(v_x_352, J.mul(9.0, v_s_354)), J.sub(v_y_353, J.mul(20.0, v_s_354)), J.mul(18.0, v_s_354), J.mul(8.0, v_s_354), J.mul(2.0, v_s_354), "#9a9aa8", env["OUT"], J.mul(1.0, v_s_354)])
	var _t515 = env["arm"]
	J.cl(_t515, null, [v_ctx_351, J.sub(v_x_352, J.mul(10.0, v_s_354)), J.sub(v_y_353, J.mul(20.0, v_s_354)), J.sub(v_x_352, J.mul(15.0, v_s_354)), J.sub(v_y_353, J.mul(10.0, v_s_354)), J.mul(v_s_354, 1.2), "#3c4a6a"])
	var _t516 = env["arm"]
	J.cl(_t516, null, [v_ctx_351, J.add(v_x_352, J.mul(10.0, v_s_354)), J.sub(v_y_353, J.mul(20.0, v_s_354)), J.add(v_x_352, J.mul(16.0, v_s_354)), J.sub(v_y_353, J.mul(13.0, v_s_354)), J.mul(v_s_354, 1.2), "#3c4a6a"])
	var _t517 = env["rr"]
	J.cl(_t517, null, [v_ctx_351, J.add(v_x_352, J.mul(15.0, v_s_354)), J.sub(v_y_353, J.mul(42.0, v_s_354)), J.mul(2.5, v_s_354), J.mul(36.0, v_s_354), J.mul(1.0, v_s_354), "#5a3a1a", env["OUT"], J.mul(0.8, v_s_354)])
	var _t518 = env["poly"]
	J.cl(_t518, null, [v_ctx_351, [J.add(v_x_352, J.mul(13.0, v_s_354)), J.sub(v_y_353, J.mul(42.0, v_s_354)), J.add(v_x_352, J.mul(22.0, v_s_354)), J.sub(v_y_353, J.mul(46.0, v_s_354)), J.add(v_x_352, J.mul(20.0, v_s_354)), J.sub(v_y_353, J.mul(38.0, v_s_354))], "#bfc8d6", env["OUT"], J.mul(1.0, v_s_354)])
	var _t519 = env["el"]
	J.cl(_t519, null, [v_ctx_351, v_x_352, v_hy_357, J.mul(11.0, v_s_354), J.mul(13.0, v_s_354), "#e8e0d8", env["OUT"], J.mul(1.8, v_s_354)])
	var _t520 = env["el"]
	J.cl(_t520, null, [v_ctx_351, v_x_352, J.add(v_hy_357, J.mul(9.0, v_s_354)), J.mul(8.0, v_s_354), J.mul(6.0, v_s_354), "#d0c4b8", env["OUT"], J.mul(1.2, v_s_354)])
	var _t521 = env["el"]
	J.cl(_t521, null, [v_ctx_351, J.sub(v_x_352, J.mul(3.0, v_s_354)), J.add(v_hy_357, J.mul(9.0, v_s_354)), J.mul(1.2, v_s_354), J.mul(1.6, v_s_354), env["OUT"]])
	var _t522 = env["el"]
	J.cl(_t522, null, [v_ctx_351, J.add(v_x_352, J.mul(3.0, v_s_354)), J.add(v_hy_357, J.mul(9.0, v_s_354)), J.mul(1.2, v_s_354), J.mul(1.6, v_s_354), env["OUT"]])
	var _t523 = env["poly"]
	J.cl(_t523, null, [v_ctx_351, [J.sub(v_x_352, J.mul(8.0, v_s_354)), J.sub(v_hy_357, J.mul(9.0, v_s_354)), J.sub(v_x_352, J.mul(10.0, v_s_354)), J.sub(v_hy_357, J.mul(19.0, v_s_354)), J.sub(v_x_352, J.mul(3.0, v_s_354)), J.sub(v_hy_357, J.mul(12.0, v_s_354))], "#e8e0d8", env["OUT"], J.mul(1.2, v_s_354)])
	var _t524 = env["poly"]
	J.cl(_t524, null, [v_ctx_351, [J.add(v_x_352, J.mul(8.0, v_s_354)), J.sub(v_hy_357, J.mul(9.0, v_s_354)), J.add(v_x_352, J.mul(10.0, v_s_354)), J.sub(v_hy_357, J.mul(19.0, v_s_354)), J.add(v_x_352, J.mul(3.0, v_s_354)), J.sub(v_hy_357, J.mul(12.0, v_s_354))], "#e8e0d8", env["OUT"], J.mul(1.2, v_s_354)])
	J.sp(v_ctx_351, "fillStyle", "#2a2a3a")
	v_i_358 = 0.0
	while true:
		if not J.cmp(v_i_358, 4.0, "<"): break
		var _t525 = env["rr"]
		J.cl(_t525, null, [v_ctx_351, J.sub(v_x_352, J.mul(2.0, v_s_354)), (J.sub(v_hy_357, J.mul(14.0, v_s_354)) + J.mul(J.mul(v_i_358, 4.0), v_s_354)), (J.mul(4.0, v_s_354) + J.mul(J.mul(v_i_358, 0.5), v_s_354)), J.mul(4.0, v_s_354), J.mul(1.0, v_s_354), "#2a2a3a"])
		v_i_358 = J.num(v_i_358) + 1.0
	var _t526 = env["eyes"]
	J.cl(_t526, null, [v_ctx_351, v_x_352, J.sub(v_hy_357, J.mul(2.0, v_s_354)), J.mul(v_s_354, 0.9), "angry"])

func _f34(this_, a: Array, env):
	var v_ctx_361 = null; var v_x_362 = null; var v_y_363 = null; var v_s_364 = null; var v_o_365 = null; var v_t_366 = null; var v_hy_367 = null; var v_sw_368 = null; var v_i_369 = null
	v_ctx_361 = J.arg(a, 0)
	v_x_362 = J.arg(a, 1)
	v_y_363 = J.arg(a, 2)
	v_s_364 = J.arg(a, 3)
	v_o_365 = J.arg(a, 4)
	v_t_366 = J.gp(v_o_365, "t")
	v_hy_367 = J.sub(v_y_363, J.mul(40.0, v_s_364))
	var _t527 = env["wisp"]
	J.cl(_t527, null, [v_ctx_361, v_x_362, v_y_363, v_s_364, "#2a2f48", v_t_366, 11.0])
	var _t528 = env["el"]
	J.cl(_t528, null, [v_ctx_361, v_x_362, J.sub(v_y_363, J.mul(16.0, v_s_364)), J.mul(16.0, v_s_364), J.mul(13.0, v_s_364), "#2a2f48", env["OUT"], J.mul(1.8, v_s_364)])
	var _t529 = env["poly"]
	J.cl(_t529, null, [v_ctx_361, [J.sub(v_x_362, J.mul(4.0, v_s_364)), J.sub(v_y_363, J.mul(28.0, v_s_364)), J.add(v_x_362, J.mul(4.0, v_s_364)), J.sub(v_y_363, J.mul(28.0, v_s_364)), v_x_362, J.sub(v_y_363, J.mul(16.0, v_s_364))], "#f2f2f2"])
	var _t530 = env["poly"]
	J.cl(_t530, null, [v_ctx_361, [J.sub(v_x_362, J.mul(1.5, v_s_364)), J.sub(v_y_363, J.mul(27.0, v_s_364)), J.add(v_x_362, J.mul(1.5, v_s_364)), J.sub(v_y_363, J.mul(27.0, v_s_364)), J.add(v_x_362, J.mul(2.0, v_s_364)), J.sub(v_y_363, J.mul(17.0, v_s_364)), J.sub(v_x_362, J.mul(2.0, v_s_364)), J.sub(v_y_363, J.mul(17.0, v_s_364))], "#c4a020", env["OUT"], J.mul(0.8, v_s_364)])
	var _t531 = env["arm"]
	J.cl(_t531, null, [v_ctx_361, J.sub(v_x_362, J.mul(14.0, v_s_364)), J.sub(v_y_363, J.mul(22.0, v_s_364)), J.sub(v_x_362, J.mul(18.0, v_s_364)), J.sub(v_y_363, J.mul(12.0, v_s_364)), J.mul(v_s_364, 1.2), "#2a2f48"])
	var _t532 = env["el"]
	J.cl(_t532, null, [v_ctx_361, J.sub(v_x_362, J.mul(18.0, v_s_364)), J.sub(v_y_363, J.mul(13.0, v_s_364)), J.mul(2.5, v_s_364), J.mul(1.6, v_s_364), "#e0b030"])
	v_sw_368 = ((-1.2) if J.t(J.gp(v_o_365, "atk")) else (sin(J.num(J.mul(v_t_366, 2.0))) * 0.2))
	var _t533 = env["arm"]
	J.cl(_t533, null, [v_ctx_361, J.add(v_x_362, J.mul(14.0, v_s_364)), J.sub(v_y_363, J.mul(22.0, v_s_364)), J.add(v_x_362, J.mul(19.0, v_s_364)), J.sub(v_y_363, J.mul(14.0, v_s_364)), J.mul(v_s_364, 1.2), "#2a2f48"])
	J.mc(v_ctx_361, "save", [])
	J.mc(v_ctx_361, "translate", [J.add(v_x_362, J.mul(19.0, v_s_364)), J.sub(v_y_363, J.mul(14.0, v_s_364))])
	J.mc(v_ctx_361, "rotate", [v_sw_368])
	var _t534 = env["rr"]
	J.cl(_t534, null, [v_ctx_361, J.mul((-1.0), v_s_364), J.mul((-24.0), v_s_364), J.mul(2.0, v_s_364), J.mul(24.0, v_s_364), J.mul(1.0, v_s_364), "#c8ccd8", env["OUT"], J.mul(0.8, v_s_364)])
	var _t535 = env["rr"]
	J.cl(_t535, null, [v_ctx_361, J.mul((-2.0), v_s_364), J.mul((-27.0), v_s_364), J.mul(8.0, v_s_364), J.mul(4.0, v_s_364), J.mul(1.5, v_s_364), "#9aa0b0", env["OUT"], J.mul(0.8, v_s_364)])
	J.mc(v_ctx_361, "restore", [])
	var _t536 = env["el"]
	J.cl(_t536, null, [v_ctx_361, v_x_362, v_hy_367, J.mul(14.0, v_s_364), J.mul(13.0, v_s_364), "#d8c0a8", env["OUT"], J.mul(1.8, v_s_364)])
	J.sp(v_ctx_361, "fillStyle", "#2a2a2a")
	J.mc(v_ctx_361, "beginPath", [])
	J.mc(v_ctx_361, "ellipse", [v_x_362, J.sub(v_hy_367, J.mul(7.0, v_s_364)), J.mul(14.0, v_s_364), J.mul(6.0, v_s_364), 0.0, PI, env["TAU"]])
	J.mc(v_ctx_361, "fill", [])
	J.sp(v_ctx_361, "strokeStyle", "#2a2a2a")
	var _t537 = J.mul(1.5, v_s_364)
	J.sp(v_ctx_361, "lineWidth", _t537)
	v_i_369 = (-2.0)
	while true:
		if not J.cmp(v_i_369, 2.0, "<="): break
		J.mc(v_ctx_361, "beginPath", [])
		J.mc(v_ctx_361, "moveTo", [J.sub(v_x_362, J.mul(10.0, v_s_364)), J.add(J.sub(v_hy_367, J.mul(9.0, v_s_364)), v_i_369)])
		J.mc(v_ctx_361, "quadraticCurveTo", [v_x_362, J.sub(v_hy_367, J.mul(14.0, v_s_364)), J.add(v_x_362, J.mul(11.0, v_s_364)), J.add(J.sub(v_hy_367, J.mul(8.0, v_s_364)), v_i_369)])
		J.mc(v_ctx_361, "stroke", [])
		v_i_369 = J.num(v_i_369) + 1.0
	var _t538 = env["rr"]
	J.cl(_t538, null, [v_ctx_361, J.sub(v_x_362, J.mul(10.0, v_s_364)), J.sub(v_hy_367, J.mul(2.0, v_s_364)), J.mul(8.0, v_s_364), J.mul(5.0, v_s_364), J.mul(1.5, v_s_364), "rgba(20,20,30,.85)", "#c4a020", J.mul(1.0, v_s_364)])
	var _t539 = env["rr"]
	J.cl(_t539, null, [v_ctx_361, J.add(v_x_362, J.mul(2.0, v_s_364)), J.sub(v_hy_367, J.mul(2.0, v_s_364)), J.mul(8.0, v_s_364), J.mul(5.0, v_s_364), J.mul(1.5, v_s_364), "rgba(20,20,30,.85)", "#c4a020", J.mul(1.0, v_s_364)])
	var _t540 = env["mouth"]
	J.cl(_t540, null, [v_ctx_361, v_x_362, J.add(v_hy_367, J.mul(1.0, v_s_364)), v_s_364, ("open" if J.t(J.gp(v_o_365, "enemy")) else "smile")])
	var _t541 = env["el"]
	J.cl(_t541, null, [v_ctx_361, J.sub(v_x_362, J.mul(10.0, v_s_364)), J.add(v_hy_367, J.mul(6.0, v_s_364)), J.mul(3.0, v_s_364), J.mul(2.0, v_s_364), "rgba(255,120,120,.35)"])
	var _t542 = env["el"]
	J.cl(_t542, null, [v_ctx_361, J.add(v_x_362, J.mul(10.0, v_s_364)), J.add(v_hy_367, J.mul(6.0, v_s_364)), J.mul(3.0, v_s_364), J.mul(2.0, v_s_364), "rgba(255,120,120,.35)"])

func _f35(this_, a: Array, env):
	var v_type_370 = null
	v_type_370 = J.arg(a, 0)
	return ("afu_body" if J.seq(v_type_370, "afu") else v_type_370)

func _f36(this_, a: Array, env):
	var v_type_371 = null
	v_type_371 = J.arg(a, 0)
	var _t543 = J.seq(J.typeof_(J.G.get("sprOk")), "function")
	var _t546 = (J.gp(env["CHAR_H"], v_type_371) if _t543 else _t543)
	if J.t(_t546):
		var _t544 = J.G.get("sprOk")
		var _t545 = env["sprKey"]
		_t546 = J.cl(_t544, null, [J.cl(_t545, null, [v_type_371])])
	return _t546

func _f53(this_, a: Array, env):
	var v_ctx_547 = null; var v_x_548 = null; var v_y_549 = null; var v_lv_550 = null; var v_t_551 = null; var v_i_552 = null
	v_ctx_547 = J.arg(a, 0)
	v_x_548 = J.arg(a, 1)
	v_y_549 = J.arg(a, 2)
	v_lv_550 = J.arg(a, 3)
	v_t_551 = J.arg(a, 4)
	var _t547 = env["el"]
	J.cl(_t547, null, [v_ctx_547, v_x_548, J.add(v_y_549, 4.0), 70.0, 12.0, "rgba(0,0,0,.3)"])
	var _t548 = env["rr"]
	J.cl(_t548, null, [v_ctx_547, J.sub(v_x_548, 64.0), J.sub(v_y_549, 6.0), 128.0, 12.0, 3.0, "#4a4458", env["OUT"], 2.0])
	var _t549 = env["house"]
	J.cl(_t549, null, [v_ctx_547, v_x_548, J.sub(v_y_549, 6.0), 104.0, 46.0, "#5c3b3b"])
	v_i_552 = 0.0
	while true:
		if not J.cmp(v_i_552, 4.0, "<"): break
		var _t550 = env["rr"]
		J.cl(_t550, null, [v_ctx_547, (J.sub(v_x_548, 48.0) + J.mul(v_i_552, 30.0)), J.sub(v_y_549, 50.0), 6.0, 44.0, 2.0, "#8a2a2a", env["OUT"], 1.2])
		v_i_552 = J.num(v_i_552) + 1.0
	var _t551 = env["rr"]
	J.cl(_t551, null, [v_ctx_547, J.sub(v_x_548, 14.0), J.sub(v_y_549, 38.0), 28.0, 32.0, 3.0, "#26161a", env["OUT"], 1.5])
	var _t552 = env["el"]
	J.cl(_t552, null, [v_ctx_547, J.sub(v_x_548, 5.0), J.sub(v_y_549, 22.0), 1.8, 1.8, "#d9a84a"])
	var _t553 = env["el"]
	J.cl(_t553, null, [v_ctx_547, J.add(v_x_548, 5.0), J.sub(v_y_549, 22.0), 1.8, 1.8, "#d9a84a"])
	var _t554 = env["roof"]
	J.cl(_t554, null, [v_ctx_547, v_x_548, J.sub(v_y_549, 82.0), 120.0, 30.0, "#2e2a40"])
	var _t555 = env["roof"]
	J.cl(_t555, null, [v_ctx_547, v_x_548, J.sub(v_y_549, 102.0), 70.0, 22.0, "#2e2a40"])
	var _t556 = env["lantern"]
	J.cl(_t556, null, [v_ctx_547, J.sub(v_x_548, 36.0), J.sub(v_y_549, 50.0), v_t_551])
	var _t557 = env["lantern"]
	J.cl(_t557, null, [v_ctx_547, J.add(v_x_548, 36.0), J.sub(v_y_549, 50.0), v_t_551])
	var _t558 = env["plaque"]
	J.cl(_t558, null, [v_ctx_547, v_x_548, J.sub(v_y_549, 62.0), "鬼宅", v_lv_550])

func _f54(this_, a: Array, env):
	var v_ctx_555 = null; var v_x_556 = null; var v_y_557 = null; var v_lv_558 = null; var v_t_559 = null; var v_i_560 = null; var v_j_561 = null
	v_ctx_555 = J.arg(a, 0)
	v_x_556 = J.arg(a, 1)
	v_y_557 = J.arg(a, 2)
	v_lv_558 = J.arg(a, 3)
	v_t_559 = J.arg(a, 4)
	var _t559 = env["el"]
	J.cl(_t559, null, [v_ctx_555, v_x_556, J.add(v_y_557, 3.0), 40.0, 8.0, "rgba(0,0,0,.3)"])
	v_i_560 = 0.0
	while true:
		if not J.cmp(v_i_560, 3.0, "<"): break
		v_j_561 = 0.0
		while true:
			if not J.cmp(v_j_561, J.sub(3.0, v_i_560), "<"): break
			var _t560 = env["el"]
			J.cl(_t560, null, [v_ctx_555, ((J.sub(v_x_556, 22.0) + J.mul(v_j_561, 11.0)) + J.mul(v_i_560, 5.5)), (J.sub(v_y_557, 5.0) - J.mul(v_i_560, 9.0)), 6.0, 5.0, "#7a5230", env["OUT"], 1.2])
			var _t561 = env["el"]
			J.cl(_t561, null, [v_ctx_555, ((J.sub(v_x_556, 22.0) + J.mul(v_j_561, 11.0)) + J.mul(v_i_560, 5.5)), (J.sub(v_y_557, 5.0) - J.mul(v_i_560, 9.0)), 3.0, 2.5, "#b8875a"])
			v_j_561 = J.num(v_j_561) + 1.0
		v_i_560 = J.num(v_i_560) + 1.0
	var _t562 = env["rr"]
	J.cl(_t562, null, [v_ctx_555, J.add(v_x_556, 8.0), J.sub(v_y_557, 30.0), 30.0, 30.0, 2.0, "#5a4030", env["OUT"], 1.5])
	var _t563 = env["poly"]
	J.cl(_t563, null, [v_ctx_555, [J.add(v_x_556, 2.0), J.sub(v_y_557, 28.0), J.add(v_x_556, 23.0), J.sub(v_y_557, 46.0), J.add(v_x_556, 44.0), J.sub(v_y_557, 28.0)], "#3a3048", env["OUT"], 1.8])
	var _t564 = env["rr"]
	J.cl(_t564, null, [v_ctx_555, J.sub(v_x_556, 40.0), J.sub(v_y_557, 14.0), 14.0, 12.0, 2.0, "#8a6038", env["OUT"], 1.2])
	var _t565 = env["plaque"]
	J.cl(_t565, null, [v_ctx_555, v_x_556, J.sub(v_y_557, 54.0), "伐木場", v_lv_558])

func _f55(this_, a: Array, env):
	var v_ctx_564 = null; var v_x_565 = null; var v_y_566 = null; var v_lv_567 = null; var v_t_568 = null; var v_i_569 = null
	v_ctx_564 = J.arg(a, 0)
	v_x_565 = J.arg(a, 1)
	v_y_566 = J.arg(a, 2)
	v_lv_567 = J.arg(a, 3)
	v_t_568 = J.arg(a, 4)
	var _t566 = env["rr"]
	J.cl(_t566, null, [v_ctx_564, J.sub(v_x_565, 24.0), J.sub(v_y_566, 26.0), 48.0, 26.0, 2.0, "#4a3a2a", env["OUT"], 1.5])
	var _t567 = env["poly"]
	J.cl(_t567, null, [v_ctx_564, [J.sub(v_x_565, 30.0), J.sub(v_y_566, 24.0), v_x_565, J.sub(v_y_566, 44.0), J.add(v_x_565, 30.0), J.sub(v_y_566, 24.0)], "#7a6a3a", env["OUT"], 1.8])
	J.sp(v_ctx_564, "strokeStyle", "#a89058")
	J.sp(v_ctx_564, "lineWidth", 1.0)
	v_i_569 = 0.0
	while true:
		if not J.cmp(v_i_569, 6.0, "<"): break
		J.mc(v_ctx_564, "beginPath", [])
		J.mc(v_ctx_564, "moveTo", [(J.sub(v_x_565, 24.0) + J.mul(v_i_569, 9.0)), (J.sub(v_y_566, 24.0) - J.mul((v_i_569 if J.cmp(v_i_569, 3.0, "<") else J.sub(5.0, v_i_569)), 5.0))])
		J.mc(v_ctx_564, "lineTo", [(J.sub(v_x_565, 22.0) + J.mul(v_i_569, 9.0)), (J.sub(v_y_566, 28.0) - J.mul((v_i_569 if J.cmp(v_i_569, 3.0, "<") else J.sub(5.0, v_i_569)), 5.0))])
		J.mc(v_ctx_564, "stroke", [])
		v_i_569 = J.num(v_i_569) + 1.0
	var _t568 = env["rr"]
	J.cl(_t568, null, [v_ctx_564, J.sub(v_x_565, 8.0), J.sub(v_y_566, 18.0), 16.0, 18.0, 2.0, "#2a1a10", env["OUT"], 1.0])
	var _t569 = env["plaque"]
	J.cl(_t569, null, [v_ctx_564, v_x_565, J.sub(v_y_566, 52.0), "糯米田", v_lv_567])

func _f56(this_, a: Array, env):
	var v_ctx_572 = null; var v_x_573 = null; var v_y_574 = null; var v_lv_575 = null; var v_t_576 = null
	v_ctx_572 = J.arg(a, 0)
	v_x_573 = J.arg(a, 1)
	v_y_574 = J.arg(a, 2)
	v_lv_575 = J.arg(a, 3)
	v_t_576 = J.arg(a, 4)
	var _t570 = env["el"]
	J.cl(_t570, null, [v_ctx_572, v_x_573, J.add(v_y_574, 4.0), 48.0, 9.0, "rgba(0,0,0,.3)"])
	var _t571 = env["house"]
	J.cl(_t571, null, [v_ctx_572, v_x_573, v_y_574, 78.0, 40.0, "#4a3a2e"])
	var _t572 = env["rr"]
	J.cl(_t572, null, [v_ctx_572, J.sub(v_x_573, 30.0), J.sub(v_y_574, 30.0), 22.0, 26.0, 2.0, "#2a1a10", env["OUT"], 1.2])
	J.mc(v_ctx_572, "save", [])
	J.mc(v_ctx_572, "translate", [J.add(v_x_573, 18.0), J.sub(v_y_574, 6.0)])
	var _t573 = env["poly"]
	J.cl(_t573, null, [v_ctx_572, [(-12.0), 0.0, 12.0, 0.0, 15.0, (-12.0), 10.0, (-22.0), (-10.0), (-22.0), (-15.0), (-12.0)], "#5a2a1a", env["OUT"], 1.5])
	J.sp(v_ctx_572, "fillStyle", "#d9a84a")
	J.sp(v_ctx_572, "font", "bold 10px serif")
	J.sp(v_ctx_572, "textAlign", "center")
	J.mc(v_ctx_572, "fillText", ["壽", 0.0, (-8.0)])
	J.mc(v_ctx_572, "restore", [])
	var _t574 = env["roof"]
	J.cl(_t574, null, [v_ctx_572, v_x_573, J.sub(v_y_574, 66.0), 86.0, 26.0, "#3a2a3a"])
	var _t575 = env["lantern"]
	J.cl(_t575, null, [v_ctx_572, J.sub(v_x_573, 40.0), J.sub(v_y_574, 42.0), v_t_576, "#f0f0f0"])
	var _t576 = env["plaque"]
	J.cl(_t576, null, [v_ctx_572, v_x_573, J.sub(v_y_574, 54.0), "棺材鋪", v_lv_575])

func _f57(this_, a: Array, env):
	var v_ctx_579 = null; var v_x_580 = null; var v_y_581 = null; var v_lv_582 = null; var v_t_583 = null; var v_i_584 = null; var v_k_585 = null; var v_sx_586 = null
	v_ctx_579 = J.arg(a, 0)
	v_x_580 = J.arg(a, 1)
	v_y_581 = J.arg(a, 2)
	v_lv_582 = J.arg(a, 3)
	v_t_583 = J.arg(a, 4)
	var _t577 = env["el"]
	J.cl(_t577, null, [v_ctx_579, v_x_580, J.add(v_y_581, 4.0), 48.0, 9.0, "rgba(0,0,0,.3)"])
	var _t578 = env["house"]
	J.cl(_t578, null, [v_ctx_579, v_x_580, v_y_581, 78.0, 40.0, "#6a4232"])
	var _t579 = env["rr"]
	J.cl(_t579, null, [v_ctx_579, J.sub(v_x_580, 34.0), J.sub(v_y_581, 24.0), 68.0, 6.0, 2.0, "#8a5a3a", env["OUT"], 1.2])
	v_i_584 = 0.0
	while true:
		if not J.cmp(v_i_584, 3.0, "<"): break
		var _t580 = env["el"]
		J.cl(_t580, null, [v_ctx_579, (J.sub(v_x_580, 20.0) + J.mul(v_i_584, 20.0)), J.sub(v_y_581, 14.0), 9.0, 6.0, "#c8a878", env["OUT"], 1.2])
		var _t581 = env["el"]
		J.cl(_t581, null, [v_ctx_579, (J.sub(v_x_580, 20.0) + J.mul(v_i_584, 20.0)), J.sub(v_y_581, 18.0), 9.0, 3.0, "#d8b888", env["OUT"], 1.0])
		v_k_585 = 0.0
		while true:
			if not J.cmp(v_k_585, 2.0, "<"): break
			J.sp(v_ctx_579, "strokeStyle", "rgba(255,255,255,.35)")
			J.sp(v_ctx_579, "lineWidth", 2.0)
			J.mc(v_ctx_579, "beginPath", [])
			v_sx_586 = ((J.sub(v_x_580, 22.0) + J.mul(v_i_584, 20.0)) + J.mul(v_k_585, 4.0))
			J.mc(v_ctx_579, "moveTo", [v_sx_586, J.sub(v_y_581, 22.0)])
			J.mc(v_ctx_579, "quadraticCurveTo", [J.add(J.add(v_sx_586, 4.0), (sin(J.num(J.add(J.add(J.mul(v_t_583, 3.0), v_i_584), v_k_585))) * 3.0)), J.sub(v_y_581, 30.0), v_sx_586, (J.sub(v_y_581, 38.0) - J.mod((J.mul(v_t_583, 10.0) + J.mul(v_i_584, 7.0)), 6.0))])
			J.mc(v_ctx_579, "stroke", [])
			v_k_585 = J.num(v_k_585) + 1.0
		v_i_584 = J.num(v_i_584) + 1.0
	var _t582 = env["roof"]
	J.cl(_t582, null, [v_ctx_579, v_x_580, J.sub(v_y_581, 66.0), 86.0, 26.0, "#4a2a2a"])
	var _t583 = env["lantern"]
	J.cl(_t583, null, [v_ctx_579, J.add(v_x_580, 40.0), J.sub(v_y_581, 42.0), v_t_583])
	var _t584 = env["plaque"]
	J.cl(_t584, null, [v_ctx_579, v_x_580, J.sub(v_y_581, 54.0), "包子鋪", v_lv_582])

func _f58(this_, a: Array, env):
	var v_ctx_589 = null; var v_x_590 = null; var v_y_591 = null; var v_lv_592 = null; var v_t_593 = null; var v_i_594 = null
	v_ctx_589 = J.arg(a, 0)
	v_x_590 = J.arg(a, 1)
	v_y_591 = J.arg(a, 2)
	v_lv_592 = J.arg(a, 3)
	v_t_593 = J.arg(a, 4)
	var _t585 = env["el"]
	J.cl(_t585, null, [v_ctx_589, v_x_590, J.add(v_y_591, 4.0), 52.0, 9.0, "rgba(0,0,0,.3)"])
	var _t586 = env["house"]
	J.cl(_t586, null, [v_ctx_589, v_x_590, v_y_591, 90.0, 44.0, "#3e3a4e"])
	var _t587 = env["rr"]
	J.cl(_t587, null, [v_ctx_589, J.sub(v_x_590, 22.0), J.sub(v_y_591, 34.0), 44.0, 34.0, 2.0, "#2a2236", env["OUT"], 1.5])
	var _t588 = env["OUT"]
	J.sp(v_ctx_589, "strokeStyle", _t588)
	J.sp(v_ctx_589, "lineWidth", 1.5)
	J.mc(v_ctx_589, "beginPath", [])
	J.mc(v_ctx_589, "moveTo", [v_x_590, J.sub(v_y_591, 34.0)])
	J.mc(v_ctx_589, "lineTo", [v_x_590, v_y_591])
	J.mc(v_ctx_589, "stroke", [])
	v_i_594 = 0.0
	while true:
		if not J.cmp(v_i_594, 2.0, "<"): break
		var _t589 = env["rr"]
		J.cl(_t589, null, [v_ctx_589, J.add(v_x_590, 28.0), (J.sub(v_y_591, 16.0) - J.mul(v_i_594, 12.0)), 14.0, 12.0, 1.0, "#7a5a30", env["OUT"], 1.0])
		v_i_594 = J.num(v_i_594) + 1.0
	var _t590 = env["roof"]
	J.cl(_t590, null, [v_ctx_589, v_x_590, J.sub(v_y_591, 72.0), 98.0, 26.0, "#2a2a3a"])
	var _t591 = env["plaque"]
	J.cl(_t591, null, [v_ctx_589, v_x_590, J.sub(v_y_591, 58.0), "倉庫", v_lv_592])

func _f59(this_, a: Array, env):
	var v_ctx_597 = null; var v_x_598 = null; var v_y_599 = null; var v_lv_600 = null; var v_t_601 = null; var v_i_602 = null; var v_i_603 = null
	v_ctx_597 = J.arg(a, 0)
	v_x_598 = J.arg(a, 1)
	v_y_599 = J.arg(a, 2)
	v_lv_600 = J.arg(a, 3)
	v_t_601 = J.arg(a, 4)
	var _t592 = env["el"]
	J.cl(_t592, null, [v_ctx_597, v_x_598, J.add(v_y_599, 4.0), 44.0, 8.0, "rgba(0,0,0,.3)"])
	v_i_602 = 0.0
	while true:
		if not J.cmp(v_i_602, 4.0, "<"): break
		var _t593 = env["rr"]
		J.cl(_t593, null, [v_ctx_597, (J.sub(v_x_598, 30.0) + J.mul(v_i_602, 19.0)), J.sub(v_y_599, 16.0), 4.0, 16.0, 1.0, "#4a3424", env["OUT"], 1.0])
		v_i_602 = J.num(v_i_602) + 1.0
	var _t594 = env["rr"]
	J.cl(_t594, null, [v_ctx_597, J.sub(v_x_598, 34.0), J.sub(v_y_599, 42.0), 68.0, 26.0, 2.0, "#7a5a3a", env["OUT"], 1.5])
	v_i_603 = 0.0
	while true:
		if not J.cmp(v_i_603, 7.0, "<"): break
		J.sp(v_ctx_597, "strokeStyle", "rgba(0,0,0,.25)")
		J.mc(v_ctx_597, "beginPath", [])
		J.mc(v_ctx_597, "moveTo", [(J.sub(v_x_598, 34.0) + J.mul(v_i_603, 10.0)), J.sub(v_y_599, 42.0)])
		J.mc(v_ctx_597, "lineTo", [(J.sub(v_x_598, 34.0) + J.mul(v_i_603, 10.0)), J.sub(v_y_599, 16.0)])
		J.mc(v_ctx_597, "stroke", [])
		v_i_603 = J.num(v_i_603) + 1.0
	var _t595 = env["rr"]
	J.cl(_t595, null, [v_ctx_597, J.sub(v_x_598, 8.0), J.sub(v_y_599, 36.0), 14.0, 14.0, 1.0, "#ffd88a", env["OUT"], 1.0])
	var _t596 = env["poly"]
	J.cl(_t596, null, [v_ctx_597, [J.sub(v_x_598, 42.0), J.sub(v_y_599, 40.0), v_x_598, J.sub(v_y_599, 66.0), J.add(v_x_598, 42.0), J.sub(v_y_599, 40.0)], "#5a4a3a", env["OUT"], 1.8])
	var _t597 = env["plaque"]
	J.cl(_t597, null, [v_ctx_597, v_x_598, J.sub(v_y_599, 58.0), "民宅", v_lv_600])

func _f60(this_, a: Array, env):
	var v_ctx_606 = null; var v_x_607 = null; var v_y_608 = null; var v_lv_609 = null; var v_t_610 = null
	v_ctx_606 = J.arg(a, 0)
	v_x_607 = J.arg(a, 1)
	v_y_608 = J.arg(a, 2)
	v_lv_609 = J.arg(a, 3)
	v_t_610 = J.arg(a, 4)
	var _t598 = env["el"]
	J.cl(_t598, null, [v_ctx_606, v_x_607, J.add(v_y_608, 4.0), 48.0, 9.0, "rgba(0,0,0,.3)"])
	var _t599 = env["poly"]
	J.cl(_t599, null, [v_ctx_606, [J.sub(v_x_607, 38.0), v_y_608, v_x_607, J.sub(v_y_608, 46.0), J.add(v_x_607, 38.0), v_y_608], "#3a4a3a", env["OUT"], 2.0])
	var _t600 = env["poly"]
	J.cl(_t600, null, [v_ctx_606, [J.sub(v_x_607, 10.0), v_y_608, v_x_607, J.sub(v_y_608, 30.0), J.add(v_x_607, 10.0), v_y_608], "#1a2418", env["OUT"], 1.2])
	var _t601 = env["rr"]
	J.cl(_t601, null, [v_ctx_606, J.add(v_x_607, 30.0), J.sub(v_y_608, 58.0), 2.0, 58.0, 1.0, "#5a3a1a"])
	var _t602 = env["poly"]
	J.cl(_t602, null, [v_ctx_606, [J.add(v_x_607, 32.0), J.sub(v_y_608, 58.0), J.add(J.add(v_x_607, 52.0), (sin(J.num(J.mul(v_t_610, 3.0))) * 3.0)), J.sub(v_y_608, 52.0), J.add(v_x_607, 32.0), J.sub(v_y_608, 46.0)], "#7a2a8a", env["OUT"], 1.0])
	J.sp(v_ctx_606, "fillStyle", "#fff")
	J.sp(v_ctx_606, "font", "bold 8px sans-serif")
	J.mc(v_ctx_606, "fillText", ["陰", J.add(v_x_607, 36.0), J.sub(v_y_608, 49.0)])
	var _t603 = env["plaque"]
	J.cl(_t603, null, [v_ctx_606, J.sub(v_x_607, 6.0), J.sub(v_y_608, 56.0), "嚇人班", v_lv_609])

func _f61(this_, a: Array, env):
	var v_ctx_613 = null; var v_x_614 = null; var v_y_615 = null; var v_lv_616 = null; var v_t_617 = null; var v_g_618 = null; var v_i_619 = null
	v_ctx_613 = J.arg(a, 0)
	v_x_614 = J.arg(a, 1)
	v_y_615 = J.arg(a, 2)
	v_lv_616 = J.arg(a, 3)
	v_t_617 = J.arg(a, 4)
	var _t604 = env["el"]
	J.cl(_t604, null, [v_ctx_613, v_x_614, J.add(v_y_615, 4.0), 40.0, 9.0, "rgba(0,0,0,.3)"])
	var _t605 = env["rr"]
	J.cl(_t605, null, [v_ctx_613, J.sub(v_x_614, 34.0), J.sub(v_y_615, 14.0), 68.0, 14.0, 2.0, "#4a4458", env["OUT"], 1.5])
	var _t606 = env["rr"]
	J.cl(_t606, null, [v_ctx_613, J.sub(v_x_614, 24.0), J.sub(v_y_615, 26.0), 48.0, 12.0, 2.0, "#5a5468", env["OUT"], 1.5])
	v_i_619 = (-1.0)
	while true:
		if not J.cmp(v_i_619, 1.0, "<="): break
		var _t607 = env["rr"]
		J.cl(_t607, null, [v_ctx_613, J.sub(J.add(v_x_614, J.mul(v_i_619, 30.0)), 1.0), J.sub(v_y_615, 58.0), 2.0, 44.0, 1.0, "#3a2a1a"])
		var _t608 = env["poly"]
		J.cl(_t608, null, [v_ctx_613, [J.add(v_x_614, J.mul(v_i_619, 30.0)), J.sub(v_y_615, 58.0), J.add(J.add(J.add(v_x_614, J.mul(v_i_619, 30.0)), J.mul(v_i_619, 4.0)), (sin(J.num(J.add(J.mul(v_t_617, 2.0), v_i_619))) * 2.0)), J.sub(v_y_615, 52.0), J.add(J.add(v_x_614, J.mul(v_i_619, 30.0)), J.mul(v_i_619, 3.0)), J.sub(v_y_615, 30.0), J.add(v_x_614, J.mul(v_i_619, 30.0)), J.sub(v_y_615, 34.0)], "#e8e0c8", env["OUT"], 1.0])
		var _t609 = J.add(v_i_619, 2.0)
		v_i_619 = _t609
	v_g_618 = J.mc(v_ctx_613, "createRadialGradient", [v_x_614, J.sub(v_y_615, 34.0), 2.0, v_x_614, J.sub(v_y_615, 34.0), 22.0])
	J.mc(v_g_618, "addColorStop", [0.0, "rgba(120,255,200,.6)"])
	J.mc(v_g_618, "addColorStop", [1.0, "rgba(120,255,200,0)"])
	J.sp(v_ctx_613, "fillStyle", v_g_618)
	J.mc(v_ctx_613, "fillRect", [J.sub(v_x_614, 24.0), J.sub(v_y_615, 58.0), 48.0, 48.0])
	var _t610 = env["el"]
	J.cl(_t610, null, [v_ctx_613, v_x_614, (J.sub(v_y_615, 34.0) + (sin(J.num(J.mul(v_t_617, 2.0))) * 2.0)), 5.0, 6.0, "rgba(180,255,230,.9)"])
	var _t611 = env["plaque"]
	J.cl(_t611, null, [v_ctx_613, v_x_614, J.sub(v_y_615, 68.0), "招魂台", v_lv_616])

func _f62(this_, a: Array, env):
	var v_ctx_622 = null; var v_x_623 = null; var v_y_624 = null; var v_lv_625 = null; var v_t_626 = null; var v_ready_627 = null; var v_fl_628 = null; var v_g_629 = null
	v_ctx_622 = J.arg(a, 0)
	v_x_623 = J.arg(a, 1)
	v_y_624 = J.arg(a, 2)
	v_lv_625 = J.arg(a, 3)
	v_t_626 = J.arg(a, 4)
	v_ready_627 = J.arg(a, 5)
	var _t612 = env["el"]
	J.cl(_t612, null, [v_ctx_622, v_x_623, J.add(v_y_624, 3.0), 26.0, 7.0, "rgba(0,0,0,.3)"])
	var _t613 = env["rr"]
	J.cl(_t613, null, [v_ctx_622, J.sub(v_x_623, 18.0), J.sub(v_y_624, 36.0), 36.0, 36.0, 6.0, "#6a3a2a", env["OUT"], 1.8])
	var _t614 = env["roof"]
	J.cl(_t614, null, [v_ctx_622, v_x_623, J.sub(v_y_624, 52.0), 30.0, 14.0, "#4a2a2a"])
	var _t615 = env["rr"]
	J.cl(_t615, null, [v_ctx_622, J.sub(v_x_623, 8.0), J.sub(v_y_624, 26.0), 16.0, 14.0, 4.0, "#1a0a08", env["OUT"], 1.0])
	v_fl_628 = (1.0 if J.t(v_ready_627) else 0.35)
	var _t616 = env["el"]
	J.cl(_t616, null, [v_ctx_622, v_x_623, (J.sub(v_y_624, 18.0) - (sin(J.num(J.mul(v_t_626, 8.0))) * 1.0)), (J.mul(5.0, v_fl_628) + 1.0), (J.mul(6.0, v_fl_628) + 1.0), ("#ffb030" if J.t(v_ready_627) else "#a04020")])
	if J.t(v_ready_627):
		v_g_629 = J.mc(v_ctx_622, "createRadialGradient", [v_x_623, J.sub(v_y_624, 20.0), 2.0, v_x_623, J.sub(v_y_624, 20.0), 26.0])
		J.mc(v_g_629, "addColorStop", [0.0, "rgba(255,170,60,.45)"])
		J.mc(v_g_629, "addColorStop", [1.0, "rgba(255,170,60,0)"])
		J.sp(v_ctx_622, "fillStyle", v_g_629)
		J.mc(v_ctx_622, "fillRect", [J.sub(v_x_623, 26.0), J.sub(v_y_624, 46.0), 52.0, 52.0])
	var _t617 = env["plaque"]
	J.cl(_t617, null, [v_ctx_622, v_x_623, J.sub(v_y_624, 62.0), "化寶爐", v_lv_625])

func _f78(this_, a: Array, env):
	var v_type_765 = null
	v_type_765 = J.arg(a, 0)
	var _t618 = (not J.seq(J.typeof_(J.G.get("MeshAnim")), "undefined"))
	var _t619 = ((not (not J.t(J.gp(env["CHAR_H"], v_type_765)))) if _t618 else _t618)
	return (J.mc(J.G.get("MeshAnim"), "has", [v_type_765]) if _t619 else _t619)

func _f1(this_, a: Array, env):
	var v_portrait_34 = null; var v_sysIcon_35 = null; var v_drawBuilding_41 = null; var v_drawSite_42 = null; var v_drawTree_45 = null; var v_drawPaddy_48 = null; var v_drawGate_51 = null; var v_drawDecor_52 = null; var v_hasRig_53 = null
	var _s2 = {"__p": env, "TAU": null, "el": null, "rr": null, "poly": null, "OUT": null, "eyes": null, "mouth": null, "blush": null, "shadow": null, "body": null, "legs": null, "wisp": null, "ghostTail": null, "arm": null, "DRAW": null, "SOLID": null, "HOP": null, "CHAR_H": null, "sprKey": null, "hasSpr": null, "TIE": null, "drawSprite": null, "buf": null, "bctx": null, "PUPPET_ANIM": null, "drawPuppet": null, "meshPose": null, "LIMB_POSES": null, "drawMesh": null, "drawChar": null, "portraitCache": null, "PCROP": null, "roof": null, "lantern": null, "plaque": null, "house": null, "BDRAW": null, "drawCrow": null, "PERCH": null, "drawWeb": null, "drawSpider": null, "drawScarecrow": null, "drawWillo": null}
	_s2["el"] = Callable(self, "_f2").bind(_s2)
	_s2["rr"] = Callable(self, "_f3").bind(_s2)
	_s2["poly"] = Callable(self, "_f4").bind(_s2)
	_s2["eyes"] = Callable(self, "_f5").bind(_s2)
	_s2["mouth"] = Callable(self, "_f6").bind(_s2)
	_s2["blush"] = Callable(self, "_f7").bind(_s2)
	_s2["shadow"] = Callable(self, "_f8").bind(_s2)
	_s2["body"] = Callable(self, "_f9").bind(_s2)
	_s2["legs"] = Callable(self, "_f10").bind(_s2)
	_s2["wisp"] = Callable(self, "_f11").bind(_s2)
	_s2["ghostTail"] = Callable(self, "_f12").bind(_s2)
	_s2["arm"] = Callable(self, "_f13").bind(_s2)
	_s2["drawSprite"] = Callable(self, "_f37").bind(_s2)
	_s2["drawPuppet"] = Callable(self, "_f38").bind(_s2)
	_s2["meshPose"] = Callable(self, "_f39").bind(_s2)
	_s2["drawMesh"] = Callable(self, "_f41").bind(_s2)
	_s2["drawChar"] = Callable(self, "_f45").bind(_s2)
	v_portrait_34 = Callable(self, "_f47").bind(_s2)
	v_sysIcon_35 = Callable(self, "_f48").bind(_s2)
	_s2["roof"] = Callable(self, "_f49").bind(_s2)
	_s2["lantern"] = Callable(self, "_f50").bind(_s2)
	_s2["plaque"] = Callable(self, "_f51").bind(_s2)
	_s2["house"] = Callable(self, "_f52").bind(_s2)
	v_drawBuilding_41 = Callable(self, "_f63").bind(_s2)
	v_drawSite_42 = Callable(self, "_f64").bind(_s2)
	_s2["drawCrow"] = Callable(self, "_f65").bind(_s2)
	v_drawTree_45 = Callable(self, "_f66").bind(_s2)
	_s2["drawWeb"] = Callable(self, "_f70").bind(_s2)
	_s2["drawSpider"] = Callable(self, "_f71").bind(_s2)
	v_drawPaddy_48 = Callable(self, "_f72").bind(_s2)
	_s2["drawScarecrow"] = Callable(self, "_f73").bind(_s2)
	_s2["drawWillo"] = Callable(self, "_f75").bind(_s2)
	v_drawGate_51 = Callable(self, "_f76").bind(_s2)
	v_drawDecor_52 = Callable(self, "_f77").bind(_s2)
	_s2["TAU"] = (PI * 2.0)
	_s2["OUT"] = "#1a1426"
	_s2["DRAW"] = {"afu": Callable(self, "_f14").bind(_s2), "xiaozhi": Callable(self, "_f15").bind(_s2), "zhiren": Callable(self, "_f16").bind(_s2), "youhun": Callable(self, "_f17").bind(_s2), "egui": Callable(self, "_f18").bind(_s2), "eguiking": Callable(self, "_f19").bind(_s2), "xiaogui": Callable(self, "_f20").bind(_s2), "toyol": Callable(self, "_f21").bind(_s2), "zombie": Callable(self, "_f22").bind(_s2), "laojiang": Callable(self, "_f23").bind(_s2), "shuigui": Callable(self, "_f24").bind(_s2), "pontianak": Callable(self, "_f25").bind(_s2), "pocong": Callable(self, "_f26").bind(_s2), "penanggal": Callable(self, "_f27").bind(_s2), "mengpo": Callable(self, "_f28").bind(_s2), "wuchang": Callable(self, "_f29").bind(_s2), "baiwu": Callable(self, "_f30").bind(_s2), "heiwu": Callable(self, "_f31").bind(_s2), "niutou": Callable(self, "_f32").bind(_s2), "mamian": Callable(self, "_f33").bind(_s2), "huang": Callable(self, "_f34").bind(_s2)}
	_s2["SOLID"] = {"npc_it": 1.0, "npc_mis": 1.0, "npc_ken": 1.0, "npc_boss": 1.0, "npc_guard": 1.0, "npc_auntie": 1.0, "laojiang": 1.0, "zombie": 1.0, "pocong": 1.0, "xiaozhi": 1.0, "zhiren": 1.0, "penanggal": 1.0}
	_s2["HOP"] = {"laojiang": 1.0, "zombie": 1.0, "pocong": 1.0}
	_s2["CHAR_H"] = {"npc_it": 60.0, "npc_mis": 62.0, "npc_ken": 64.0, "npc_boss": 64.0, "npc_guard": 64.0, "npc_auntie": 60.0, "afu": 58.0, "xiaozhi": 54.0, "egui": 54.0, "eguiking": 66.0, "xiaogui": 46.0, "toyol": 46.0, "laojiang": 58.0, "zombie": 54.0, "shuigui": 56.0, "pontianak": 60.0, "pocong": 54.0, "penanggal": 52.0, "mengpo": 56.0, "youhun": 46.0, "baiwu": 76.0, "heiwu": 76.0, "niutou": 64.0, "mamian": 64.0, "huang": 62.0, "zhiren": 54.0, "tianhua": 60.0}
	_s2["sprKey"] = Callable(self, "_f35").bind(_s2)
	_s2["hasSpr"] = Callable(self, "_f36").bind(_s2)
	_s2["TIE"] = {"x0": 618.0, "x1": 946.0, "y0": 462.0, "y1": 648.0, "ow": 953.0}
	_s2["buf"] = J.S_document_("createElement", ["canvas"])
	_s2["bctx"] = J.mc(_s2["buf"], "getContext", ["2d"])
	_s2["PUPPET_ANIM"] = {"walk": 1.0, "run": 1.0, "startle": 1.0, "cower": 1.0, "tremble": 1.0, "phone": 1.0, "look": 1.0, "mop": 1.0, "faint": 1.0, "sip": 1.0, "stand": 1.0, "hold": 1.0, "shrug": 1.0, "windup": 1.0, "strike": 1.0, "recover": 1.0, "hurt": 1.0, "cast": 1.0, "die": 1.0, "chop": 1.0, "hammer": 1.0, "knead": 1.0, "reap": 1.0, "proud": 1.0}
	_s2["LIMB_POSES"] = {"undefined": 1.0, "null": 1.0, "idle": 1.0, "move": 1.0, "walk": 1.0, "run": 1.0, "windup": 1.0, "strike": 1.0, "follow": 1.0, "recover": 1.0, "chop": 1.0, "hammer": 1.0, "proud": 1.0}
	_s2["portraitCache"] = {}
	_s2["PCROP"] = {"baiwu": [0.3, 0.95], "heiwu": [0.3, 0.95], "penanggal": [0.02, 0.85], "eguiking": [0.0, 0.8], "huang": [0.0, 0.8], "niutou": [0.04, 0.82], "mamian": [0.04, 0.82], "afu": [0.0, 0.72], "tree": [0.0, 1.0]}
	_s2["BDRAW"] = {"house": Callable(self, "_f53").bind(_s2), "wood": Callable(self, "_f54").bind(_s2), "rice": Callable(self, "_f55").bind(_s2), "plank": Callable(self, "_f56").bind(_s2), "bun": Callable(self, "_f57").bind(_s2), "store": Callable(self, "_f58").bind(_s2), "home": Callable(self, "_f59").bind(_s2), "camp": Callable(self, "_f60").bind(_s2), "altar": Callable(self, "_f61").bind(_s2), "furnace": Callable(self, "_f62").bind(_s2)}
	_s2["PERCH"] = [[(-19.0), (-46.0), 1.0], [16.0, (-52.0), (-1.0)], [(-4.0), (-64.0), 1.0]]
	v_hasRig_53 = Callable(self, "_f78").bind(_s2)
	return {"CHAR_H": _s2["CHAR_H"], "SOLID": _s2["SOLID"], "hasRig": v_hasRig_53, "drawCrow": _s2["drawCrow"], "drawDecor": v_drawDecor_52, "drawChar": _s2["drawChar"], "portrait": v_portrait_34, "sysIcon": v_sysIcon_35, "drawBuilding": v_drawBuilding_41, "drawSite": v_drawSite_42, "drawTree": v_drawTree_45, "drawPaddy": v_drawPaddy_48, "drawGate": v_drawGate_51, "el": _s2["el"], "rr": _s2["rr"], "poly": _s2["poly"], "lantern": _s2["lantern"], "OUT": _s2["OUT"]}
