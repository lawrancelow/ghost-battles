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
	if J.t(J.gp(v_o_413, "weapon")):
		var _t78 = J.gp(v_o_413, "weapon")
		J.sp(v_pz_419, "wpn", _t78)
		var _t79 = (not J.t(J.gp(v_pz_419, "tool")))
		if (J.seq(v_type_409, "afu") if _t79 else _t79):
			J.sp(v_pz_419, "tool", "_W")
			var _t80 = ((-J.num(J.add(J.gp(v_pz_419, "aF"), J.gp(v_pz_419, "eF")))) + 0.25)
			J.sp(v_pz_419, "tr", _t80)
	if J.t(J.gp(v_o_413, "cloth")):
		var _t81 = J.gp(v_o_413, "cloth")
		J.sp(v_pz_419, "cloth", _t81)
	if J.t(J.gp(v_o_413, "badge")):
		var _t82 = J.gp(v_o_413, "badge")
		J.sp(v_pz_419, "badge", _t82)
	var _t83 = (not J.t(J.gp(v_pz_419, "tool")))
	var _t84 = ((not J.seq(v_type_409, "afu")) if _t83 else _t83)
	var _t85 = ((not J.t(v_human_417)) if _t84 else _t84)
	if J.t((J.mc(J.G.get("Puppet"), "armed", [v_type_409]) if _t85 else _t85)):
		J.sp(v_pz_419, "tool", "_W")
		var _t86 = ((-J.num(J.add(J.gp(v_pz_419, "aF"), J.gp(v_pz_419, "eF")))) + 0.15)
		J.sp(v_pz_419, "tr", _t86)
	var _t87 = (not J.t(J.gp(env["PUPPET_ANIM"], v_name_415)))
	if J.t((J.gp(v_o_413, "atk") if _t87 else _t87)):
		J.S_Object_("assign", [v_pz_419, {"aF": 1.6, "eF": 0.1}])
	var _t89 = J.gp(env["HOP"], v_type_409)
	if J.t(_t89):
		var _t88 = J.seq(v_name_415, "idle")
		_t89 = (_t88 if _t88 else J.seq(v_name_415, "move"))
	if J.t(_t89):
		J.S_Object_("assign", [v_pz_419, {"aF": 1.5, "eF": 0.05, "aB": 1.4, "eB": 0.05, "lean": 0.0}])
		var _t90 = J.seq(v_name_415, "move")
		if J.t((_t90 if _t90 else J.gp(v_o_413, "enemy"))):
			var _t91 = ((-absf(J.num(sin(J.num(J.mul(J.gp(v_o_413, "t"), 5.0)))))) * 7.0)
			J.sp(v_pz_419, "dy", _t91)
	v_SOLIDP_420 = J.gp(env["SOLID"], v_type_409)
	if (not J.seq(J.gp(v_o_413, "shadow"), false)):
		var _t92 = env["shadow"]
		J.cl(_t92, null, [v_ctx_408, v_x_410, J.add(v_y_411, J.mul(1.0, v_s_412)), J.mul(v_s_412, (1.0 if J.t(v_SOLIDP_420) else 0.8))])
	J.mc(J.G.get("Puppet"), "draw", [v_ctx_408, v_type_409, v_x_410, J.sub(v_y_411, (0.0 if J.t(v_SOLIDP_420) else J.mul((3.0 + (sin(J.num(J.mul(J.gp(v_o_413, "t"), 2.4))) * 2.0)), v_s_412))), (J.mul(J.gp(env["CHAR_H"], v_type_409), v_s_412) * 1.08), v_pz_419, (not J.t(J.gp(v_o_413, "flip")))])

func _f40(this_, a: Array, env):
	var v_q_429 = null
	v_q_429 = J.arg(a, 0)
	return (J.mc(env["A"], "windup", [J.div(v_q_429, 0.72), env["t"], env["type"]]) if J.cmp(v_q_429, 0.72, "<") else J.mc(env["A"], "strike", [J.div(J.sub(v_q_429, 0.72), 0.28), env["t"], env["type"]]))

func _f39(this_, a: Array, env):
	var v_o_424 = null; var v_p_427 = null; var v_atk_428 = null; var v_z_430 = null; var v_z_431 = null
	var _s97 = {"__p": env, "type": null, "A": null, "t": null}
	_s97["type"] = J.arg(a, 0)
	v_o_424 = J.arg(a, 1)
	_s97["A"] = J.gp(J.G.get("MeshAnim"), "ANIM")
	_s97["t"] = J.gp(v_o_424, "t")
	var _t93 = J.gp(v_o_424, "pt")
	var _t94 = J.gp(v_o_424, "pt")
	var _t95 = J.gp(v_o_424, "pt")
	var _t96 = J.gp(v_o_424, "pt")
	v_p_427 = J.max_([0.0, J.min_([1.0, (_t96 if J.t(_t96) else 0.0)])])
	v_atk_428 = Callable(self, "_f40").bind(_s97)
	var _t97 = J.gp(v_o_424, "pose")
	var _t98 = -1
	var _t99 = false
	if _t98 == -1 and J.seq(_t97, "windup"): _t98 = 0
	if _t98 == -1 and J.seq(_t97, "strike"): _t98 = 1
	if _t98 == -1 and J.seq(_t97, "follow"): _t98 = 2
	if _t98 == -1 and J.seq(_t97, "recover"): _t98 = 3
	if _t98 == -1 and J.seq(_t97, "cast"): _t98 = 4
	if _t98 == -1 and J.seq(_t97, "die"): _t98 = 5
	if _t98 == -1 and J.seq(_t97, "air"): _t98 = 6
	if _t98 == -1 and J.seq(_t97, "down"): _t98 = 7
	if _t98 == -1 and J.seq(_t97, "faint"): _t98 = 8
	if _t98 == -1 and J.seq(_t97, "hurt"): _t98 = 9
	if _t98 == -1 and J.seq(_t97, "scared"): _t98 = 10
	if _t98 == -1 and J.seq(_t97, "startle"): _t98 = 11
	if _t98 == -1 and J.seq(_t97, "tremble"): _t98 = 12
	if _t98 == -1 and J.seq(_t97, "cower"): _t98 = 13
	if _t98 == -1 and J.seq(_t97, "chop"): _t98 = 14
	if _t98 == -1 and J.seq(_t97, "hammer"): _t98 = 15
	if _t98 == -1 and J.seq(_t97, "reap"): _t98 = 16
	if _t98 == -1 and J.seq(_t97, "knead"): _t98 = 17
	if _t98 == -1 and J.seq(_t97, "proud"): _t98 = 18
	if _t98 == -1 and J.seq(_t97, "run"): _t98 = 19
	if _t98 == -1 and J.seq(_t97, "move"): _t98 = 20
	if _t98 == -1 and J.seq(_t97, "walk"): _t98 = 21
	while true:
		if _t98 <= 0 and _t98 >= 0:
			pass
		if _t98 <= 1 and _t98 >= 0:
			pass
		if _t98 <= 2 and _t98 >= 0:
			pass
		if _t98 <= 3 and _t98 >= 0:
			var _t100 = _s97["A"]
			var _t101 = J.gp(v_o_424, "pose")
			return J.mc(_t100, _t101, [v_p_427, _s97["t"], _s97["type"]])
		if _t98 <= 4 and _t98 >= 0:
			pass
		if _t98 <= 5 and _t98 >= 0:
			pass
		if _t98 <= 6 and _t98 >= 0:
			pass
		if _t98 <= 7 and _t98 >= 0:
			var _t102 = _s97["A"]
			var _t103 = J.gp(v_o_424, "pose")
			return J.mc(_t102, _t103, [v_p_427, _s97["t"], _s97["type"]])
		if _t98 <= 8 and _t98 >= 0:
			return J.mc(_s97["A"], "die", [v_p_427, _s97["t"]])
		if _t98 <= 9 and _t98 >= 0:
			return J.mc(_s97["A"], "hurtP", [v_p_427, _s97["t"]])
		if _t98 <= 10 and _t98 >= 0:
			pass
		if _t98 <= 11 and _t98 >= 0:
			pass
		if _t98 <= 12 and _t98 >= 0:
			pass
		if _t98 <= 13 and _t98 >= 0:
			return J.mc(_s97["A"], "scared", [_s97["t"]])
		if _t98 <= 14 and _t98 >= 0:
			return J.cl(v_atk_428, null, [v_p_427])
		if _t98 <= 15 and _t98 >= 0:
			return J.cl(v_atk_428, null, [J.mod(J.mul(v_p_427, 2.0), 1.0)])
		if _t98 <= 16 and _t98 >= 0:
			return J.mc(_s97["A"], "strike", [absf(J.num(sin(J.num((J.mul(v_p_427, PI) * 3.0))))), _s97["t"], _s97["type"]])
		if _t98 <= 17 and _t98 >= 0:
			v_z_430 = J.mc(_s97["A"], "idle", [_s97["t"]])
			var _t104 = (0.15 + (sin(J.num((J.mul(v_p_427, PI) * 4.0))) * 0.05))
			J.sp(v_z_430, "body", _t104)
			var _t105 = J.gp(v_z_430, "y")
			var _t106 = J.add((_t105 if J.t(_t105) else 0.0), (absf(J.num(sin(J.num((J.mul(v_p_427, PI) * 4.0))))) * 0.02))
			J.sp(v_z_430, "y", _t106)
			J.sp(v_z_430, "armF", 0.3)
			var _t107 = (-0.3)
			J.sp(v_z_430, "armB", _t107)
			return v_z_430
		if _t98 <= 18 and _t98 >= 0:
			v_z_431 = J.mc(_s97["A"], "idle", [_s97["t"]])
			var _t108 = (-0.12)
			J.sp(v_z_431, "head", _t108)
			var _t109 = (-0.05)
			J.sp(v_z_431, "body", _t109)
			return v_z_431
		if _t98 <= 19 and _t98 >= 0:
			pass
		if _t98 <= 20 and _t98 >= 0:
			pass
		if _t98 <= 21 and _t98 >= 0:
			return J.mc(_s97["A"], "walk", [J.mul(_s97["t"], (1.8 if J.seq(J.gp(v_o_424, "pose"), "run") else 1.0))])
		break
	if J.t(J.gp(v_o_424, "hurt")):
		return J.mc(_s97["A"], "hurtP", [0.3, _s97["t"]])
	if J.t(J.gp(v_o_424, "atk")):
		return J.mc(_s97["A"], "strike", [0.6, _s97["t"], _s97["type"]])
	if J.t(J.gp(v_o_424, "walk")):
		return J.mc(_s97["A"], "walk", [_s97["t"]])
	return J.mc(_s97["A"], "idle", [_s97["t"]])

func _f42(this_, a: Array, env):
	var v_cx_444 = null; var v_k_445 = null
	v_cx_444 = J.arg(a, 0)
	v_k_445 = J.arg(a, 1)
	var _t116 = env["__p"]["shadow"]
	return J.cl(_t116, null, [env["ctx"], v_cx_444, J.add(env["y"], J.mul(1.0, env["s"])), J.mul(env["s"], (v_k_445 if J.t(v_k_445) else (1.0 if J.t(env["solid"]) else 0.8)))])

func _f43(this_, a: Array, env):
	var v_cx_447 = null; var v_k_448 = null
	v_cx_447 = J.arg(a, 0)
	v_k_448 = J.arg(a, 1)
	var _t125 = env["__p"]["shadow"]
	return J.cl(_t125, null, [env["ctx"], v_cx_447, J.add(env["y"], J.mul(1.0, env["s"])), J.mul(env["s"], (v_k_448 if J.t(v_k_448) else (1.0 if J.t(env["solid"]) else 0.8)))])

func _f44(this_, a: Array, env):
	var v_cx_450 = null; var v_k_451 = null
	v_cx_450 = J.arg(a, 0)
	v_k_451 = J.arg(a, 1)
	var _t129 = env["__p"]["shadow"]
	return J.cl(_t129, null, [env["ctx"], v_cx_450, J.add(env["y"], J.mul(1.0, env["s"])), J.mul(env["s"], (v_k_451 if J.t(v_k_451) else (1.0 if J.t(env["solid"]) else 0.8)))])

func _f41(this_, a: Array, env):
	var v_type_435 = null; var v_x_436 = null; var v_o_439 = null; var v_H_441 = null; var v_pz_442 = null; var v_done_443 = null; var v_done_446 = null; var v_done_449 = null; var v_A_452 = null; var v_mp_453 = null; var v_tip_454 = null
	var _s102 = {"__p": env, "ctx": null, "y": null, "s": null, "solid": null}
	_s102["ctx"] = J.arg(a, 0)
	v_type_435 = J.arg(a, 1)
	v_x_436 = J.arg(a, 2)
	_s102["y"] = J.arg(a, 3)
	_s102["s"] = J.arg(a, 4)
	v_o_439 = J.arg(a, 5)
	_s102["solid"] = J.gp(_s102["__p"]["SOLID"], v_type_435)
	v_H_441 = J.mul(J.gp(_s102["__p"]["CHAR_H"], v_type_435), _s102["s"])
	var _t110 = J.gp(v_o_439, "act")
	var _t111 = ((not J.seq(J.typeof_(J.G.get("DAILY")), "undefined")) if J.t(_t110) else _t110)
	if J.t((J.gp(J.G.get("DAILY"), J.gp(v_o_439, "act")) if J.t(_t111) else _t111)):
		J.mc(_s102["ctx"], "save", [])
		if (not J.leq(J.gp(v_o_439, "alpha"), null)):
			var _t112 = _s102["ctx"]
			var _t113 = J.gp(v_o_439, "alpha")
			J.sp(_t112, "globalAlpha", _t113)
		var _t114 = J.G.get("DAILY")
		var _t115 = J.gp(v_o_439, "act")
		v_done_443 = J.mc(_t114, _t115, [_s102["ctx"], {"type": v_type_435, "x": v_x_436, "y": _s102["y"], "s": _s102["s"], "H": v_H_441, "o": v_o_439, "faceRight": (not J.t(J.gp(v_o_439, "flip"))), "solid": _s102["solid"], "shadow": Callable(self, "_f42").bind(_s102)}])
		J.mc(_s102["ctx"], "restore", [])
		if (not J.seq(v_done_443, false)):
			return null
	var _t117 = (not J.seq(J.typeof_(J.G.get("MOVES")), "undefined"))
	var _t121 = (J.gp(J.G.get("MOVES"), v_type_435) if _t117 else _t117)
	if J.t(_t121):
		var _t118 = J.seq(J.gp(v_o_439, "pose"), "windup")
		var _t119 = (_t118 if _t118 else J.seq(J.gp(v_o_439, "pose"), "strike"))
		var _t120 = (_t119 if _t119 else J.seq(J.gp(v_o_439, "pose"), "follow"))
		_t121 = (_t120 if _t120 else J.seq(J.gp(v_o_439, "pose"), "recover"))
	if J.t(_t121):
		J.mc(_s102["ctx"], "save", [])
		if (not J.leq(J.gp(v_o_439, "alpha"), null)):
			var _t122 = _s102["ctx"]
			var _t123 = J.gp(v_o_439, "alpha")
			J.sp(_t122, "globalAlpha", _t123)
		var _t124 = J.G.get("MOVES")
		v_done_446 = J.mc(_t124, v_type_435, [_s102["ctx"], {"type": v_type_435, "x": v_x_436, "y": _s102["y"], "s": _s102["s"], "H": v_H_441, "o": v_o_439, "faceRight": (not J.t(J.gp(v_o_439, "flip"))), "solid": _s102["solid"], "shadow": Callable(self, "_f43").bind(_s102)}])
		J.mc(_s102["ctx"], "restore", [])
		if (not J.seq(v_done_446, false)):
			return null
	if J.t(J.gp(J.gp(J.gp(J.G.get("MeshAnim"), "RIG"), v_type_435), "custom")):
		J.mc(_s102["ctx"], "save", [])
		if (not J.leq(J.gp(v_o_439, "alpha"), null)):
			var _t126 = _s102["ctx"]
			var _t127 = J.gp(v_o_439, "alpha")
			J.sp(_t126, "globalAlpha", _t127)
		var _t128 = J.gp(J.gp(J.G.get("MeshAnim"), "RIG"), v_type_435)
		v_done_449 = J.mc(_t128, "custom", [_s102["ctx"], {"type": v_type_435, "x": v_x_436, "y": _s102["y"], "s": _s102["s"], "H": v_H_441, "o": v_o_439, "faceRight": (not J.t(J.gp(v_o_439, "flip"))), "solid": _s102["solid"], "shadow": Callable(self, "_f44").bind(_s102)}])
		J.mc(_s102["ctx"], "restore", [])
		if (not J.seq(v_done_449, false)):
			return null
	var _t130 = (not J.seq(J.typeof_(J.G.get("Limbs")), "undefined"))
	var _t131 = (J.mc(J.G.get("Limbs"), "has", [v_type_435]) if _t130 else _t130)
	var _t132 = (J.gp(_s102["__p"]["LIMB_POSES"], J.gp(v_o_439, "pose")) if J.t(_t131) else _t131)
	if J.t(((not J.t(J.gp(v_o_439, "hurt"))) if J.t(_t132) else _t132)):
		v_A_452 = J.gp(J.G.get("MeshAnim"), "ANIM")
		var _t133 = J.gp(v_o_439, "walk")
		var _t134 = (_t133 if J.t(_t133) else J.seq(J.gp(v_o_439, "pose"), "move"))
		var _t135 = (_t134 if J.t(_t134) else J.seq(J.gp(v_o_439, "pose"), "walk"))
		v_mp_453 = (J.mc(v_A_452, "walk", [J.gp(v_o_439, "t")]) if J.t((_t135 if J.t(_t135) else J.seq(J.gp(v_o_439, "pose"), "run"))) else J.mc(v_A_452, "idle", [J.gp(v_o_439, "t")]))
		J.mc(_s102["ctx"], "save", [])
		if (not J.leq(J.gp(v_o_439, "alpha"), null)):
			var _t136 = _s102["ctx"]
			var _t137 = J.gp(v_o_439, "alpha")
			J.sp(_t136, "globalAlpha", _t137)
		if (not J.seq(J.gp(v_o_439, "shadow"), false)):
			J.mc(_s102["ctx"], "save", [])
			if (not J.t(_s102["solid"])):
				var _t138 = _s102["ctx"]
				var _t139 = J.mul(J.gp(_t138, "globalAlpha"), 0.55)
				J.sp(_t138, "globalAlpha", _t139)
			var _t140 = _s102["__p"]["shadow"]
			J.cl(_t140, null, [_s102["ctx"], v_x_436, J.add(_s102["y"], J.mul(1.0, _s102["s"])), J.mul(_s102["s"], (1.0 if J.t(_s102["solid"]) else 0.8))])
			J.mc(_s102["ctx"], "restore", [])
		v_tip_454 = J.mc(J.G.get("Limbs"), "draw", [_s102["ctx"], v_type_435, v_x_436, J.sub(_s102["y"], (0.0 if J.t(_s102["solid"]) else J.mul((3.0 + (sin(J.num(J.mul(J.gp(v_o_439, "t"), 2.4))) * 2.0)), _s102["s"]))), v_H_441, v_o_439, (not J.t(J.gp(v_o_439, "flip"))), v_mp_453])
		J.mc(_s102["ctx"], "restore", [])
		if J.t(J.gp(v_o_439, "tipOut")):
			var _t141 = J.gp(v_o_439, "tipOut")
			J.sp(_t141, "p", v_tip_454)
		return null
	var _t142 = _s102["__p"]["meshPose"]
	v_pz_442 = J.cl(_t142, null, [v_type_435, v_o_439])
	if J.t(J.gp(J.gp(J.gp(J.G.get("MeshAnim"), "RIG"), v_type_435), "tweak")):
		var _t143 = J.gp(J.gp(J.G.get("MeshAnim"), "RIG"), v_type_435)
		J.mc(_t143, "tweak", [v_pz_442, v_o_439])
	var _t146 = J.gp(J.gp(J.gp(J.G.get("MeshAnim"), "RIG"), v_type_435), "hop")
	if J.t(_t146):
		var _t144 = J.gp(v_o_439, "walk")
		var _t145 = (_t144 if J.t(_t144) else J.gp(v_o_439, "enemy"))
		_t146 = (_t145 if J.t(_t145) else J.seq(J.gp(v_o_439, "pose"), "move"))
	if J.t(_t146):
		var _t147 = J.gp(v_pz_442, "y")
		var _t148 = J.sub((_t147 if J.t(_t147) else 0.0), (absf(J.num(sin(J.num(J.mul(J.gp(v_o_439, "t"), 5.0))))) * 0.09))
		J.sp(v_pz_442, "y", _t148)
	J.mc(_s102["ctx"], "save", [])
	if (not J.leq(J.gp(v_o_439, "alpha"), null)):
		var _t149 = _s102["ctx"]
		var _t150 = J.gp(v_o_439, "alpha")
		J.sp(_t149, "globalAlpha", _t150)
	if (not J.seq(J.gp(v_o_439, "shadow"), false)):
		J.mc(_s102["ctx"], "save", [])
		if (not J.t(_s102["solid"])):
			var _t151 = _s102["ctx"]
			var _t152 = J.mul(J.gp(_t151, "globalAlpha"), 0.55)
			J.sp(_t151, "globalAlpha", _t152)
		var _t153 = _s102["__p"]["shadow"]
		J.cl(_t153, null, [_s102["ctx"], v_x_436, J.add(_s102["y"], J.mul(1.0, _s102["s"])), J.mul(_s102["s"], (1.0 if J.t(_s102["solid"]) else 0.8))])
		J.mc(_s102["ctx"], "restore", [])
	J.mc(J.G.get("MeshAnim"), "draw", [_s102["ctx"], v_type_435, v_x_436, J.sub(_s102["y"], (0.0 if J.t(_s102["solid"]) else J.mul((3.0 + (sin(J.num(J.mul(J.gp(v_o_439, "t"), 2.4))) * 2.0)), _s102["s"]))), v_H_441, v_pz_442, (not J.t(J.gp(v_o_439, "flip")))])
	J.mc(_s102["ctx"], "restore", [])

func _f46(this_, a: Array, env):
	var v_c_476 = null; var v_xx_477 = null; var v_yy_478 = null; var v_ss_479 = null; var v_oo_480 = null
	v_c_476 = J.arg(a, 0)
	v_xx_477 = J.arg(a, 1)
	v_yy_478 = J.arg(a, 2)
	v_ss_479 = J.arg(a, 3)
	v_oo_480 = J.arg(a, 4)
	var _t167 = env["__p"]["drawSprite"]
	return J.cl(_t167, null, [v_c_476, env["type"], v_xx_477, v_yy_478, v_ss_479, v_oo_480])

func _f45(this_, a: Array, env):
	var v_ctx_457 = null; var v_x_459 = null; var v_y_460 = null; var v_s_461 = null; var v_o_462 = null; var v_spr_463 = null; var v_f_464 = null; var v_ghost_465 = null; var v_fy_466 = null; var v_m_467 = null; var v_k_468 = null; var v_L_469 = null; var v_T_470 = null; var v_Wd_471 = null; var v_Ht_472 = null; var v_pw_473 = null; var v_ph_474 = null; var v_g_475 = null
	var _s112 = {"__p": env, "type": null}
	v_ctx_457 = J.arg(a, 0)
	_s112["type"] = J.arg(a, 1)
	v_x_459 = J.arg(a, 2)
	v_y_460 = J.arg(a, 3)
	v_s_461 = J.arg(a, 4)
	v_o_462 = J.arg(a, 5)
	var _t154 = (v_o_462 if J.t(v_o_462) else {})
	v_o_462 = _t154
	var _t155 = J.gp(v_o_462, "t")
	var _t156 = (_t155 if J.t(_t155) else 0.0)
	J.sp(v_o_462, "t", _t156)
	var _t157 = (not J.seq(J.typeof_(J.G.get("MeshAnim")), "undefined"))
	var _t158 = (J.gp(_s112["__p"]["CHAR_H"], _s112["type"]) if _t157 else _t157)
	var _t160 = (J.mc(J.G.get("MeshAnim"), "has", [_s112["type"]]) if J.t(_t158) else _t158)
	if J.t(_t160):
		var _t159 = (not J.seq(J.typeof_(J.G.get("SPECIAL")), "undefined"))
		_t160 = (not J.t((J.mc(J.G.get("SPECIAL"), "has", [_s112["type"]]) if _t159 else _t159)))
	if J.t(((not J.t(J.gp(v_o_462, "noMesh"))) if J.t(_t160) else _t160)):
		var _t161 = _s112["__p"]["drawMesh"]
		return J.cl(_t161, null, [v_ctx_457, _s112["type"], v_x_459, v_y_460, v_s_461, v_o_462])
	var _t162 = (not J.seq(J.typeof_(J.G.get("Puppet")), "undefined"))
	var _t163 = (J.mc(J.G.get("Puppet"), "has", [_s112["type"]]) if _t162 else _t162)
	if J.t(((not J.t(J.gp(v_o_462, "noPuppet"))) if J.t(_t163) else _t163)):
		J.mc(v_ctx_457, "save", [])
		if (not J.leq(J.gp(v_o_462, "alpha"), null)):
			var _t164 = J.gp(v_o_462, "alpha")
			J.sp(v_ctx_457, "globalAlpha", _t164)
		if J.t(J.gp(v_o_462, "rot")):
			J.mc(v_ctx_457, "translate", [v_x_459, J.sub(v_y_460, J.mul(15.0, v_s_461))])
			J.mc(v_ctx_457, "rotate", [J.gp(v_o_462, "rot")])
			J.mc(v_ctx_457, "translate", [(-J.num(v_x_459)), (-J.sub(v_y_460, J.mul(15.0, v_s_461)))])
		var _t165 = _s112["__p"]["drawPuppet"]
		J.cl(_t165, null, [v_ctx_457, _s112["type"], v_x_459, v_y_460, v_s_461, v_o_462])
		J.mc(v_ctx_457, "restore", [])
		return null
	var _t166 = _s112["__p"]["hasSpr"]
	v_spr_463 = J.cl(_t166, null, [_s112["type"]])
	var _t169 = null
	if J.t(v_spr_463):
		_t169 = Callable(self, "_f46").bind(_s112)
	else:
		var _t168 = J.gp(_s112["__p"]["DRAW"], _s112["type"])
		_t169 = (_t168 if J.t(_t168) else J.gp(_s112["__p"]["DRAW"], "youhun"))
	v_f_464 = _t169
	v_ghost_465 = (not J.t(J.gp(_s112["__p"]["SOLID"], _s112["type"])))
	J.mc(v_ctx_457, "save", [])
	if (not J.leq(J.gp(v_o_462, "alpha"), null)):
		var _t170 = J.gp(v_o_462, "alpha")
		J.sp(v_ctx_457, "globalAlpha", _t170)
	if (not J.seq(J.gp(v_o_462, "shadow"), false)):
		if J.t(v_ghost_465):
			J.mc(v_ctx_457, "save", [])
			var _t171 = J.mul(J.gp(v_ctx_457, "globalAlpha"), 0.55)
			J.sp(v_ctx_457, "globalAlpha", _t171)
			var _t172 = _s112["__p"]["shadow"]
			J.cl(_t172, null, [v_ctx_457, v_x_459, J.add(v_y_460, J.mul(1.0, v_s_461)), J.mul(v_s_461, 0.8)])
			J.mc(v_ctx_457, "restore", [])
		else:
			var _t173 = _s112["__p"]["shadow"]
			J.cl(_t173, null, [v_ctx_457, v_x_459, J.add(v_y_460, J.mul(1.0, v_s_461)), v_s_461])
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
	var _t174 = J.cmp(J.gp(_s112["__p"]["buf"], "width"), v_pw_473, "<")
	if (_t174 if _t174 else J.cmp(J.gp(_s112["__p"]["buf"], "height"), v_ph_474, "<")):
		var _t175 = _s112["__p"]["buf"]
		var _t176 = J.max_([J.gp(_s112["__p"]["buf"], "width"), v_pw_473])
		J.sp(_t175, "width", _t176)
		var _t177 = _s112["__p"]["buf"]
		var _t178 = J.max_([J.gp(_s112["__p"]["buf"], "height"), v_ph_474])
		J.sp(_t177, "height", _t178)
	J.mc(_s112["__p"]["bctx"], "setTransform", [1.0, 0.0, 0.0, 1.0, 0.0, 0.0])
	J.mc(_s112["__p"]["bctx"], "clearRect", [0.0, 0.0, v_pw_473, v_ph_474])
	J.mc(_s112["__p"]["bctx"], "setTransform", [v_k_468, 0.0, 0.0, v_k_468, J.mul(J.sub(v_L_469, v_x_459), v_k_468), J.mul(J.sub(v_T_470, v_fy_466), v_k_468)])
	var _t179 = _s112["__p"]["bctx"]
	J.sp(_t179, "globalCompositeOperation", "source-over")
	var _t180 = _s112["__p"]["bctx"]
	J.sp(_t180, "globalAlpha", 1.0)
	J.cl(v_f_464, null, [_s112["__p"]["bctx"], v_x_459, v_fy_466, v_s_461, v_o_462])
	var _t181 = _s112["__p"]["bctx"]
	J.sp(_t181, "globalCompositeOperation", "destination-out")
	v_g_475 = J.mc(_s112["__p"]["bctx"], "createLinearGradient", [0.0, J.sub(v_fy_466, J.mul(13.0, v_s_461)), 0.0, J.add(v_fy_466, J.mul(6.0, v_s_461))])
	if J.t(v_spr_463):
		J.mc(v_g_475, "addColorStop", [0.0, "rgba(0,0,0,0)"])
		J.mc(v_g_475, "addColorStop", [0.6, "rgba(0,0,0,.22)"])
		J.mc(v_g_475, "addColorStop", [1.0, "rgba(0,0,0,.55)"])
	else:
		J.mc(v_g_475, "addColorStop", [0.0, "rgba(0,0,0,0)"])
		J.mc(v_g_475, "addColorStop", [0.55, "rgba(0,0,0,.55)"])
		J.mc(v_g_475, "addColorStop", [1.0, "rgba(0,0,0,.92)"])
	var _t182 = _s112["__p"]["bctx"]
	J.sp(_t182, "fillStyle", v_g_475)
	J.mc(_s112["__p"]["bctx"], "fillRect", [J.sub(v_x_459, v_L_469), J.sub(v_fy_466, J.mul(13.0, v_s_461)), v_Wd_471, J.mul(30.0, v_s_461)])
	var _t183 = _s112["__p"]["bctx"]
	J.sp(_t183, "globalCompositeOperation", "source-over")
	J.mc(v_ctx_457, "drawImage", [_s112["__p"]["buf"], 0.0, 0.0, v_pw_473, v_ph_474, J.sub(v_x_459, v_L_469), J.sub(v_fy_466, v_T_470), J.div(v_pw_473, v_k_468), J.div(v_ph_474, v_k_468)])
	J.mc(v_ctx_457, "restore", [])

func _f47(this_, a: Array, env):
	var v_type_483 = null; var v_size_484 = null; var v_opt_485 = null; var v_spr_486 = null; var v_key_487 = null; var v_c_488 = null; var v_dpr_489 = null; var v_ctx_490 = null; var v_s_491 = null; var v_img_492 = null; var v_iw_493 = null; var v_ih_494 = null; var v_top_495 = null; var v_fr_496 = null; var v_S_497 = null; var v_sx_498 = null; var v_sy_499 = null
	v_type_483 = J.arg(a, 0)
	v_size_484 = J.arg(a, 1)
	v_opt_485 = J.arg(a, 2)
	var _t184 = env["hasSpr"]
	v_spr_486 = J.cl(_t184, null, [v_type_483])
	v_key_487 = (J.add((J.add(J.add(v_type_483, "_"), v_size_484) + "_"), J.S_JSON_("stringify", [(v_opt_485 if J.t(v_opt_485) else {})])) + ("_s" if J.t(v_spr_486) else ""))
	if J.t(J.gp(env["portraitCache"], v_key_487)):
		return J.gp(env["portraitCache"], v_key_487)
	v_c_488 = J.S_document_("createElement", ["canvas"])
	var _t185 = J.gp(J.G.get("window"), "devicePixelRatio")
	var _t186 = J.gp(J.G.get("window"), "devicePixelRatio")
	v_dpr_489 = J.min_([2.0, (_t186 if J.t(_t186) else 1.0)])
	var _t187 = J.mul(v_size_484, v_dpr_489)
	J.sp(v_c_488, "width", _t187)
	var _t188 = J.mul(v_size_484, v_dpr_489)
	J.sp(v_c_488, "height", _t188)
	v_ctx_490 = J.mc(v_c_488, "getContext", ["2d"])
	J.mc(v_ctx_490, "scale", [v_dpr_489, v_dpr_489])
	if J.t(v_spr_486):
		var _t190 = J.G.get("SPR")
		var _t189 = env["sprKey"]
		v_img_492 = J.gp(_t190, J.cl(_t189, null, [v_type_483]))
		v_iw_493 = J.gp(v_img_492, "naturalWidth")
		v_ih_494 = J.gp(v_img_492, "naturalHeight")
		var _t191 = J.gp(env["PCROP"], v_type_483)
		var _t192 = (_t191 if J.t(_t191) else [0.0, 0.86])
		var _t193 = J.gp(_t192, 0.0)
		v_top_495 = _t193
		var _t194 = J.gp(_t192, 1.0)
		v_fr_496 = _t194
		v_S_497 = J.min_([J.mul(v_iw_493, v_fr_496), v_ih_494])
		v_sx_498 = (J.div(J.sub(v_iw_493, v_S_497), 2.0) + (J.mul(v_iw_493, 0.1) if J.seq(v_type_483, "afu") else 0.0))
		v_sy_499 = J.min_([J.sub(v_ih_494, v_S_497), J.mul(v_iw_493, v_top_495)])
		J.sp(v_ctx_490, "imageSmoothingQuality", "high")
		J.mc(v_ctx_490, "drawImage", [v_img_492, J.max_([0.0, J.min_([J.sub(v_iw_493, v_S_497), v_sx_498])]), J.max_([0.0, v_sy_499]), v_S_497, v_S_497, J.mul(v_size_484, 0.04), J.mul(v_size_484, 0.04), J.mul(v_size_484, 0.92), J.mul(v_size_484, 0.92)])
		var _t195 = env["portraitCache"]
		J.sp(_t195, v_key_487, v_c_488)
		return v_c_488
	v_s_491 = J.div(v_size_484, 52.0)
	var _t196 = env["drawChar"]
	var _t203 = J.div(v_size_484, 2.0)
	var _t198 = J.mul(v_size_484, 0.98)
	var _t197 = ["penanggal"]
	var _t200 = (_t198 + (((-J.num(v_size_484)) * 0.05) if J.t(J.mc(_t197, "includes", [v_type_483])) else 0.0))
	var _t199 = ["baiwu", "heiwu"]
	var _t202 = (_t200 + (J.mul(v_size_484, 0.3) if J.t(J.mc(_t199, "includes", [v_type_483])) else 0.0))
	var _t201 = ["eguiking", "huang", "niutou", "mamian"]
	var _t205 = (_t202 + (J.mul(v_size_484, 0.12) if J.t(J.mc(_t201, "includes", [v_type_483])) else 0.0))
	var _t204 = ["baiwu", "heiwu"]
	J.cl(_t196, null, [v_ctx_490, v_type_483, _t203, _t205, J.mul(v_s_491, (0.85 if J.t(J.mc(_t204, "includes", [v_type_483])) else 1.0)), J.S_Object_("assign", [{"shadow": false, "t": 0.3}, (v_opt_485 if J.t(v_opt_485) else {})])])
	var _t206 = J.seq(J.typeof_(J.G.get("SPR")), "undefined")
	if (_t206 if _t206 else (not J.t(J.gp(env["CHAR_H"], v_type_483)))):
		var _t207 = env["portraitCache"]
		J.sp(_t207, v_key_487, v_c_488)
	return v_c_488

func _f48(this_, a: Array, env):
	var v_size_502 = null; var v_c_503 = null; var v_dpr_504 = null; var v_ctx_505 = null; var v_g_506 = null
	v_size_502 = J.arg(a, 0)
	v_c_503 = J.S_document_("createElement", ["canvas"])
	var _t208 = J.gp(J.G.get("window"), "devicePixelRatio")
	var _t209 = J.gp(J.G.get("window"), "devicePixelRatio")
	v_dpr_504 = J.min_([2.0, (_t209 if J.t(_t209) else 1.0)])
	var _t210 = J.mul(v_size_502, v_dpr_504)
	J.sp(v_c_503, "width", _t210)
	var _t211 = J.mul(v_size_502, v_dpr_504)
	J.sp(v_c_503, "height", _t211)
	v_ctx_505 = J.mc(v_c_503, "getContext", ["2d"])
	J.mc(v_ctx_505, "scale", [v_dpr_504, v_dpr_504])
	v_g_506 = J.mc(v_ctx_505, "createRadialGradient", [J.div(v_size_502, 2.0), J.div(v_size_502, 2.0), 2.0, J.div(v_size_502, 2.0), J.div(v_size_502, 2.0), J.div(v_size_502, 2.0)])
	J.mc(v_g_506, "addColorStop", [0.0, "rgba(120,255,220,.9)"])
	J.mc(v_g_506, "addColorStop", [1.0, "rgba(120,255,220,0)"])
	J.sp(v_ctx_505, "fillStyle", v_g_506)
	J.mc(v_ctx_505, "fillRect", [0.0, 0.0, v_size_502, v_size_502])
	var _t212 = env["rr"]
	J.cl(_t212, null, [v_ctx_505, J.mul(v_size_502, 0.24), J.mul(v_size_502, 0.18), J.mul(v_size_502, 0.52), J.mul(v_size_502, 0.64), J.mul(v_size_502, 0.08), "#0e2a2a", "#6ff0d0", 2.0])
	J.sp(v_ctx_505, "fillStyle", "#6ff0d0")
	var _t213 = ("bold " + J.str(J.mul(v_size_502, 0.2)) + "px sans-serif")
	J.sp(v_ctx_505, "font", _t213)
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
	var _t214 = env["OUT"]
	J.sp(v_ctx_509, "strokeStyle", _t214)
	J.sp(v_ctx_509, "lineWidth", 2.0)
	J.mc(v_ctx_509, "stroke", [])
	var _t215 = (v_edge_515 if J.t(v_edge_515) else "rgba(255,255,255,.12)")
	J.sp(v_ctx_509, "strokeStyle", _t215)
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
	var _t216 = env["poly"]
	J.cl(_t216, null, [v_ctx_509, [(J.sub(v_x_510, J.div(v_w_512, 2.0)) - 10.0), J.add(v_y_511, v_h_513), (J.sub(v_x_510, J.div(v_w_512, 2.0)) - 14.0), J.sub(J.add(v_y_511, v_h_513), 7.0), (J.sub(v_x_510, J.div(v_w_512, 2.0)) - 4.0), J.sub(J.add(v_y_511, v_h_513), 2.0)], v_col_514, env["OUT"], 1.5])
	var _t217 = env["poly"]
	J.cl(_t217, null, [v_ctx_509, [J.add(J.add(v_x_510, J.div(v_w_512, 2.0)), 10.0), J.add(v_y_511, v_h_513), J.add(J.add(v_x_510, J.div(v_w_512, 2.0)), 14.0), J.sub(J.add(v_y_511, v_h_513), 7.0), J.add(J.add(v_x_510, J.div(v_w_512, 2.0)), 4.0), J.sub(J.add(v_y_511, v_h_513), 2.0)], v_col_514, env["OUT"], 1.5])

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
	var _t218 = env["el"]
	J.cl(_t218, null, [v_ctx_520, J.add(v_x_521, (sin(J.num(J.add(J.mul(v_t_523, 2.0), v_x_521))) * 0.8)), J.add(v_y_522, 5.0), 5.0, 7.0, (v_col_524 if J.t(v_col_524) else "#d8343c"), env["OUT"], 1.2])
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
	var _t219 = "900 13px \"Songti TC\",\"Noto Serif CJK TC\",\"Noto Serif TC\",serif"
	J.sp(v_ctx_528, "font", _t219)
	v_w_533 = J.add(J.gp(J.mc(v_ctx_528, "measureText", [v_text_531]), "width"), 16.0)
	var _t220 = env["rr"]
	J.cl(_t220, null, [v_ctx_528, (J.sub(v_x_529, J.div(v_w_533, 2.0)) - 2.0), J.sub(v_y_530, 11.0), J.add(v_w_533, 4.0), 22.0, 2.0, "#1a0e08"])
	var _t221 = env["rr"]
	J.cl(_t221, null, [v_ctx_528, J.sub(v_x_529, J.div(v_w_533, 2.0)), J.sub(v_y_530, 9.0), v_w_533, 18.0, 1.0, "#3a1a10", "#c99a3e", 1.2])
	J.sp(v_ctx_528, "fillStyle", "#f3d68a")
	J.sp(v_ctx_528, "textAlign", "center")
	J.sp(v_ctx_528, "textBaseline", "middle")
	J.mc(v_ctx_528, "fillText", [v_text_531, v_x_529, J.add(v_y_530, 1.0)])
	if J.t(v_lv_532):
		v_sx_534 = J.add(J.add(v_x_529, J.div(v_w_533, 2.0)), 3.0)
		v_sy_535 = J.sub(v_y_530, 13.0)
		J.mc(v_ctx_528, "translate", [v_sx_534, v_sy_535])
		J.mc(v_ctx_528, "rotate", [0.12])
		var _t222 = env["rr"]
		J.cl(_t222, null, [v_ctx_528, (-1.0), (-8.0), 20.0, 16.0, 2.0, "#c2362b", "#f0c8b4", 1.0])
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
	var _t223 = env["rr"]
	J.cl(_t223, null, [v_ctx_538, J.sub(v_x_539, J.div(v_w_541, 2.0)), J.sub(v_y_540, v_h_542), v_w_541, v_h_542, 3.0, v_wall_543, env["OUT"], 2.0])
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
	var _t224 = env["BDRAW"]
	J.mc(_t224, v_id_633, [v_ctx_632, v_x_634, v_y_635, v_lv_636, v_t_637, v_extra_638])

func _f64(this_, a: Array, env):
	var v_ctx_641 = null; var v_x_642 = null; var v_y_643 = null; var v_name_644 = null; var v_w_645 = null
	v_ctx_641 = J.arg(a, 0)
	v_x_642 = J.arg(a, 1)
	v_y_643 = J.arg(a, 2)
	v_name_644 = J.arg(a, 3)
	J.mc(v_ctx_641, "save", [])
	var _t225 = "700 12px \"PingFang TC\",\"Noto Sans TC\",sans-serif"
	J.sp(v_ctx_641, "font", _t225)
	v_w_645 = J.max_([64.0, J.add(J.gp(J.mc(v_ctx_641, "measureText", [v_name_644]), "width"), 22.0)])
	var _t226 = env["el"]
	J.cl(_t226, null, [v_ctx_641, v_x_642, J.sub(v_y_643, 2.0), J.mul(v_w_645, 0.7), 9.0, "rgba(60,48,36,.45)"])
	J.mc(v_ctx_641, "setLineDash", [[3.0, 4.0]])
	J.sp(v_ctx_641, "strokeStyle", "rgba(236,217,164,.35)")
	J.sp(v_ctx_641, "lineWidth", 1.2)
	J.mc(v_ctx_641, "beginPath", [])
	J.mc(v_ctx_641, "ellipse", [v_x_642, J.sub(v_y_643, 2.0), J.mul(v_w_645, 0.7), 11.0, 0.0, 0.0, env["TAU"]])
	J.mc(v_ctx_641, "stroke", [])
	J.mc(v_ctx_641, "setLineDash", [[]])
	var _t227 = env["rr"]
	J.cl(_t227, null, [v_ctx_641, J.sub(v_x_642, 1.5), J.sub(v_y_643, 30.0), 3.0, 28.0, 1.0, "#5a4030"])
	var _t228 = env["rr"]
	J.cl(_t228, null, [v_ctx_641, J.sub(v_x_642, J.div(v_w_645, 2.0)), J.sub(v_y_643, 44.0), v_w_645, 20.0, 2.0, "#ecd9a4", "#5a4030", 1.5])
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
		var _t229 = env["el"]
		J.cl(_t229, null, [v_ctx_648, 0.0, 0.0, 6.0, 4.2, "#121014", "#000", 0.8])
		var _t230 = env["el"]
		J.cl(_t230, null, [v_ctx_648, 4.5, (-3.5), 3.0, 2.8, "#121014"])
		var _t231 = env["poly"]
		J.cl(_t231, null, [v_ctx_648, [7.0, (-4.0), 10.5, (-3.0), 7.0, (-2.4)], "#5a524a"])
		var _t232 = env["el"]
		J.cl(_t232, null, [v_ctx_648, 5.4, (-4.2), 0.7, 0.7, "#e03a3a"])
		var _t233 = env["poly"]
		J.cl(_t233, null, [v_ctx_648, [(-5.0), (-1.0), (-11.0), 2.0, (-6.0), 2.5], "#0c0a0e"])
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
		var _t234 = env["poly"]
		J.cl(_t234, null, [v_ctx_648, [(-2.0), 0.0, (-7.0), J.sub((-6.0), v_w_655), 2.0, (-1.0)], "#0c0a0e", "#6a6078", 0.7])
		var _t235 = env["poly"]
		J.cl(_t235, null, [v_ctx_648, [(-1.0), 0.0, (-4.0), (6.0 + J.mul(v_w_655, 0.4)), 3.0, 0.0], "#16141a"])
		var _t236 = env["el"]
		J.cl(_t236, null, [v_ctx_648, 0.0, 0.0, 6.0, 3.2, "#121014", "#6a6078", 0.7])
		var _t237 = env["el"]
		J.cl(_t237, null, [v_ctx_648, 5.0, (-1.0), 2.6, 2.4, "#121014", "#6a6078", 0.6])
		var _t238 = env["poly"]
		J.cl(_t238, null, [v_ctx_648, [7.0, (-1.6), 10.5, (-0.6), 7.0, 0.2], "#5a524a"])
		var _t239 = env["poly"]
		J.cl(_t239, null, [v_ctx_648, [(-5.0), (-0.5), (-10.0), (-2.5), (-10.0), 2.0], "#0c0a0e"])
		var _t240 = env["el"]
		J.cl(_t240, null, [v_ctx_648, 5.8, (-1.6), 0.6, 0.6, "#e03a3a"])
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
	var _t258 = env["ctx"]
	J.sp(_t258, "strokeStyle", "#2b2321")
	var _t259 = env["ctx"]
	J.sp(_t259, "lineCap", "round")
	var _t260 = env["ctx"]
	var _t261 = J.add(v_w_679, 1.6)
	J.sp(_t260, "lineWidth", _t261)
	J.mc(env["ctx"], "beginPath", [])
	J.mc(env["ctx"], "moveTo", [v_x1_673, v_y1_674])
	J.mc(env["ctx"], "quadraticCurveTo", [v_cx_677, v_cy_678, v_x2_675, v_y2_676])
	var _t262 = env["ctx"]
	var _t263 = env["__p"]["OUT"]
	J.sp(_t262, "strokeStyle", _t263)
	J.mc(env["ctx"], "stroke", [])
	var _t264 = env["ctx"]
	J.sp(_t264, "lineWidth", v_w_679)
	var _t265 = env["ctx"]
	J.sp(_t265, "strokeStyle", "#2b2321")
	J.mc(env["ctx"], "stroke", [])

func _f68(this_, a: Array, env):
	var v_dx_680 = null; var v_dy_681 = null; var v_rx_682 = null; var v_ry_683 = null; var v_c_684 = null
	var _t267 = J.gp(J.arg(a, 0), 0.0)
	v_dx_680 = _t267
	var _t268 = J.gp(J.arg(a, 0), 1.0)
	v_dy_681 = _t268
	var _t269 = J.gp(J.arg(a, 0), 2.0)
	v_rx_682 = _t269
	var _t270 = J.gp(J.arg(a, 0), 3.0)
	v_ry_683 = _t270
	var _t271 = J.gp(J.arg(a, 0), 4.0)
	v_c_684 = _t271
	var _t272 = env["ctx"]
	J.sp(_t272, "globalAlpha", 0.92)
	var _t273 = env["__p"]["el"]
	J.cl(_t273, null, [env["ctx"], J.add(env["x"], v_dx_680), J.add(env["y"], v_dy_681), v_rx_682, v_ry_683, v_c_684, env["__p"]["OUT"], 1.0])
	var _t274 = env["ctx"]
	J.sp(_t274, "globalAlpha", 1.0)

func _f69(this_, a: Array, env):
	var v_dx_685 = null; var v_dy_686 = null; var v_d_687 = null; var v_k_688 = null
	var _t282 = J.gp(J.arg(a, 0), 0.0)
	v_dx_685 = _t282
	var _t283 = J.gp(J.arg(a, 0), 1.0)
	v_dy_686 = _t283
	var _t284 = J.gp(J.arg(a, 0), 2.0)
	v_d_687 = _t284
	v_k_688 = J.arg(a, 1)
	var _t285 = J.seq(v_k_688, 2.0)
	if (J.seq(env["v"], 2.0) if _t285 else _t285):
		return null
	var _t286 = env["__p"]["drawCrow"]
	J.cl(_t286, null, [env["ctx"], J.add(J.add(env["x"], v_dx_685), env["sx"]), J.sub(J.add(env["y"], v_dy_686), 3.0), 0.75, 0.0, v_d_687, true])

func _f66(this_, a: Array, env):
	var v_hp_661 = null; var v_t_662 = null; var v_shake_663 = null; var v_perched_664 = null; var v_idx_665 = null; var v_glow_668 = null; var v_br_669 = null; var v_c1_670 = null; var v_c2_671 = null; var v_sw_672 = null
	var _s167 = {"__p": env, "ctx": null, "x": null, "y": null, "sx": null, "v": null}
	_s167["ctx"] = J.arg(a, 0)
	_s167["x"] = J.arg(a, 1)
	_s167["y"] = J.arg(a, 2)
	v_hp_661 = J.arg(a, 3)
	v_t_662 = J.arg(a, 4)
	v_shake_663 = J.arg(a, 5)
	v_perched_664 = J.arg(a, 6)
	v_idx_665 = J.arg(a, 7)
	_s167["sx"] = ((sin(J.num(J.mul(v_t_662, 60.0))) * 2.2) if J.t(v_shake_663) else 0.0)
	_s167["v"] = J.mod((v_idx_665 if J.t(v_idx_665) else 0.0), 3.0)
	var _t241 = _s167["__p"]["el"]
	J.cl(_t241, null, [_s167["ctx"], _s167["x"], J.add(_s167["y"], 2.0), 18.0, 5.0, "rgba(0,0,0,.4)"])
	if J.cmp(v_hp_661, 0.0, "<="):
		var _t242 = _s167["__p"]["rr"]
		J.cl(_t242, null, [_s167["ctx"], J.sub(_s167["x"], 8.0), J.sub(_s167["y"], 8.0), 16.0, 9.0, 2.0, "#2a2220", _s167["__p"]["OUT"], 1.2])
		var _t243 = _s167["__p"]["el"]
		J.cl(_t243, null, [_s167["ctx"], _s167["x"], J.sub(_s167["y"], 8.0), 8.0, 2.8, "#6a4a3a", _s167["__p"]["OUT"], 1.0])
		var _t244 = _s167["__p"]["el"]
		J.cl(_t244, null, [_s167["ctx"], _s167["x"], J.sub(_s167["y"], 8.0), 4.0, 1.4, "#8a2a24"])
		var _t245 = _s167["ctx"]
		J.sp(_t245, "strokeStyle", "rgba(140,30,30,.7)")
		var _t246 = _s167["ctx"]
		J.sp(_t246, "lineWidth", 1.2)
		J.mc(_s167["ctx"], "beginPath", [])
		J.mc(_s167["ctx"], "moveTo", [J.add(_s167["x"], 3.0), J.sub(_s167["y"], 7.0)])
		J.mc(_s167["ctx"], "quadraticCurveTo", [J.add(_s167["x"], 4.0), J.sub(_s167["y"], 3.0), J.add(_s167["x"], 3.0), J.add(_s167["y"], 1.0)])
		J.mc(_s167["ctx"], "stroke", [])
		return null
	J.mc(_s167["ctx"], "save", [])
	J.mc(_s167["ctx"], "translate", [_s167["sx"], 0.0])
	J.mc(_s167["ctx"], "beginPath", [])
	J.mc(_s167["ctx"], "moveTo", [J.sub(_s167["x"], 9.0), J.add(_s167["y"], 1.0)])
	J.mc(_s167["ctx"], "quadraticCurveTo", [J.sub(_s167["x"], 4.0), J.sub(_s167["y"], 14.0), J.sub(_s167["x"], 8.0), J.sub(_s167["y"], 26.0)])
	J.mc(_s167["ctx"], "quadraticCurveTo", [J.sub(_s167["x"], 9.0), J.sub(_s167["y"], 34.0), J.sub(_s167["x"], 3.0), J.sub(_s167["y"], 40.0)])
	J.mc(_s167["ctx"], "lineTo", [J.add(_s167["x"], 4.0), J.sub(_s167["y"], 40.0)])
	J.mc(_s167["ctx"], "quadraticCurveTo", [J.add(_s167["x"], 9.0), J.sub(_s167["y"], 30.0), J.add(_s167["x"], 5.0), J.sub(_s167["y"], 20.0)])
	J.mc(_s167["ctx"], "quadraticCurveTo", [J.add(_s167["x"], 3.0), J.sub(_s167["y"], 8.0), J.add(_s167["x"], 10.0), J.add(_s167["y"], 1.0)])
	J.mc(_s167["ctx"], "closePath", [])
	var _t247 = _s167["ctx"]
	J.sp(_t247, "fillStyle", "#2b2321")
	J.mc(_s167["ctx"], "fill", [])
	var _t248 = _s167["ctx"]
	var _t249 = _s167["__p"]["OUT"]
	J.sp(_t248, "strokeStyle", _t249)
	var _t250 = _s167["ctx"]
	J.sp(_t250, "lineWidth", 1.6)
	J.mc(_s167["ctx"], "stroke", [])
	var _t251 = _s167["ctx"]
	J.sp(_t251, "strokeStyle", "rgba(0,0,0,.45)")
	var _t252 = _s167["ctx"]
	J.sp(_t252, "lineWidth", 1.0)
	J.mc(_s167["ctx"], "beginPath", [])
	J.mc(_s167["ctx"], "moveTo", [J.sub(_s167["x"], 4.0), J.sub(_s167["y"], 2.0)])
	J.mc(_s167["ctx"], "quadraticCurveTo", [J.sub(_s167["x"], 1.0), J.sub(_s167["y"], 14.0), J.sub(_s167["x"], 5.0), J.sub(_s167["y"], 30.0)])
	J.mc(_s167["ctx"], "moveTo", [J.add(_s167["x"], 4.0), J.sub(_s167["y"], 4.0)])
	J.mc(_s167["ctx"], "quadraticCurveTo", [J.add(_s167["x"], 2.0), J.sub(_s167["y"], 18.0), J.add(_s167["x"], 3.0), J.sub(_s167["y"], 34.0)])
	J.mc(_s167["ctx"], "stroke", [])
	var _t253 = _s167["__p"]["el"]
	J.cl(_t253, null, [_s167["ctx"], J.sub(_s167["x"], 2.8), J.sub(_s167["y"], 21.0), 2.0, 2.8, "#0a0708"])
	var _t254 = _s167["__p"]["el"]
	J.cl(_t254, null, [_s167["ctx"], J.add(_s167["x"], 2.8), J.sub(_s167["y"], 21.5), 2.0, 2.6, "#0a0708"])
	v_glow_668 = (0.45 + (sin(J.num(J.add(J.mul(v_t_662, 1.7), _s167["x"]))) * 0.35))
	var _t255 = _s167["__p"]["el"]
	J.cl(_t255, null, [_s167["ctx"], J.sub(_s167["x"], 2.8), J.sub(_s167["y"], 20.5), 0.8, 0.8, ("rgba(255,60,50," + J.str(v_glow_668) + ")")])
	var _t256 = _s167["__p"]["el"]
	J.cl(_t256, null, [_s167["ctx"], J.add(_s167["x"], 2.8), J.sub(_s167["y"], 21.0), 0.8, 0.8, ("rgba(255,60,50," + J.str(v_glow_668) + ")")])
	var _t257 = _s167["__p"]["el"]
	J.cl(_t257, null, [_s167["ctx"], _s167["x"], J.sub(_s167["y"], 14.0), 1.8, 3.0, "#0a0708"])
	v_br_669 = Callable(self, "_f67").bind(_s167)
	J.cl(v_br_669, null, [J.sub(_s167["x"], 4.0), J.sub(_s167["y"], 38.0), J.sub(_s167["x"], 24.0), J.sub(_s167["y"], 46.0), J.sub(_s167["x"], 12.0), J.sub(_s167["y"], 48.0), 3.0])
	J.cl(v_br_669, null, [J.sub(_s167["x"], 20.0), J.sub(_s167["y"], 46.0), J.sub(_s167["x"], 27.0), J.sub(_s167["y"], 56.0), J.sub(_s167["x"], 26.0), J.sub(_s167["y"], 49.0), 1.4])
	J.cl(v_br_669, null, [J.add(_s167["x"], 2.0), J.sub(_s167["y"], 39.0), J.add(_s167["x"], 20.0), J.sub(_s167["y"], 52.0), J.add(_s167["x"], 14.0), J.sub(_s167["y"], 40.0), 3.0])
	J.cl(v_br_669, null, [J.add(_s167["x"], 17.0), J.sub(_s167["y"], 49.0), J.add(_s167["x"], 27.0), J.sub(_s167["y"], 50.0), J.add(_s167["x"], 22.0), J.sub(_s167["y"], 47.0), 1.4])
	J.cl(v_br_669, null, [_s167["x"], J.sub(_s167["y"], 40.0), J.sub(_s167["x"], 4.0), J.sub(_s167["y"], 66.0), J.add(_s167["x"], 4.0), J.sub(_s167["y"], 54.0), 2.6])
	J.cl(v_br_669, null, [J.sub(_s167["x"], 3.0), J.sub(_s167["y"], 60.0), J.add(_s167["x"], 8.0), J.sub(_s167["y"], 70.0), J.add(_s167["x"], 1.0), J.sub(_s167["y"], 68.0), 1.3])
	v_c1_670 = J.gp(["#17221c", "#1b241a", "#202018"], _s167["v"])
	v_c2_671 = J.gp(["#1e2b22", "#22291c", "#26261c"], _s167["v"])
	var _t266 = [[(-24.0), (-52.0), 8.0, 6.0, v_c1_670], [(-14.0), (-60.0), 9.0, 6.5, v_c2_671], [6.0, (-66.0), 10.0, 6.5, v_c1_670], [20.0, (-56.0), 9.0, 6.0, v_c2_671], [(-2.0), (-56.0), 8.0, 5.0, v_c1_670]]
	J.mc(_t266, "forEach", [Callable(self, "_f68").bind(_s167)])
	v_sw_672 = (sin(J.num((J.mul(v_t_662, 1.8) + J.mul(_s167["x"], 0.1)))) * 0.18)
	J.mc(_s167["ctx"], "save", [])
	J.mc(_s167["ctx"], "translate", [J.add(_s167["x"], 18.0), J.sub(_s167["y"], 48.0)])
	J.mc(_s167["ctx"], "rotate", [v_sw_672])
	var _t275 = _s167["ctx"]
	J.sp(_t275, "strokeStyle", "#b8262a")
	var _t276 = _s167["ctx"]
	J.sp(_t276, "lineWidth", 1.0)
	J.mc(_s167["ctx"], "beginPath", [])
	J.mc(_s167["ctx"], "moveTo", [0.0, 0.0])
	J.mc(_s167["ctx"], "lineTo", [0.0, 9.0])
	J.mc(_s167["ctx"], "stroke", [])
	var _t277 = _s167["__p"]["rr"]
	J.cl(_t277, null, [_s167["ctx"], (-2.6), 9.0, 5.2, 11.0, 0.5, "#e8c44a", "#8a6a1a", 0.7])
	var _t278 = _s167["ctx"]
	J.sp(_t278, "strokeStyle", "#b8262a")
	var _t279 = _s167["ctx"]
	J.sp(_t279, "lineWidth", 0.7)
	J.mc(_s167["ctx"], "beginPath", [])
	J.mc(_s167["ctx"], "moveTo", [0.0, 10.5])
	J.mc(_s167["ctx"], "quadraticCurveTo", [1.6, 12.5, (-0.6), 14.0])
	J.mc(_s167["ctx"], "quadraticCurveTo", [(-1.8), 15.6, 0.8, 17.0])
	J.mc(_s167["ctx"], "lineTo", [0.0, 19.0])
	J.mc(_s167["ctx"], "stroke", [])
	var _t280 = _s167["__p"]["el"]
	J.cl(_t280, null, [_s167["ctx"], 0.0, 11.2, 0.9, 0.9, null, "#b8262a", 0.6])
	J.mc(_s167["ctx"], "restore", [])
	if (not J.seq(_s167["v"], 1.0)):
		J.mc(_s167["ctx"], "save", [])
		J.mc(_s167["ctx"], "translate", [J.sub(_s167["x"], 22.0), J.sub(_s167["y"], 46.0)])
		J.mc(_s167["ctx"], "rotate", [((-J.num(v_sw_672)) * 1.4)])
		J.mc(_s167["ctx"], "beginPath", [])
		J.mc(_s167["ctx"], "moveTo", [(-1.5), 0.0])
		J.mc(_s167["ctx"], "quadraticCurveTo", [((-3.0) + (sin(J.num(J.mul(v_t_662, 2.5))) * 2.0)), 9.0, ((-1.0) + (sin(J.num(J.mul(v_t_662, 2.2))) * 3.0)), 17.0])
		J.mc(_s167["ctx"], "lineTo", [(2.0 + (sin(J.num(J.mul(v_t_662, 2.2))) * 3.0)), 16.0])
		J.mc(_s167["ctx"], "quadraticCurveTo", [(0.0 + (sin(J.num(J.mul(v_t_662, 2.5))) * 2.0)), 8.0, 1.5, 0.0])
		J.mc(_s167["ctx"], "closePath", [])
		var _t281 = _s167["ctx"]
		J.sp(_t281, "fillStyle", "rgba(232,228,216,.85)")
		J.mc(_s167["ctx"], "fill", [])
		J.mc(_s167["ctx"], "restore", [])
	J.mc(_s167["ctx"], "restore", [])
	if J.t(v_perched_664):
		J.mc(_s167["__p"]["PERCH"], "forEach", [Callable(self, "_f69").bind(_s167)])

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
	var _t287 = ("rgba(225,225,235," + J.str((v_alpha_697 if J.t(v_alpha_697) else 0.38)) + ")")
	J.sp(v_ctx_691, "strokeStyle", _t287)
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
	var _t288 = J.mul(0.9, v_s_714)
	J.sp(v_ctx_710, "lineWidth", _t288)
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
	var _t289 = env["el"]
	J.cl(_t289, null, [v_ctx_710, v_x_711, J.add(v_y_712, J.mul(1.5, v_s_714)), J.mul(2.6, v_s_714), J.mul(3.0, v_s_714), "#100c10"])
	var _t290 = env["el"]
	J.cl(_t290, null, [v_ctx_710, v_x_711, J.sub(v_y_712, J.mul(1.2, v_s_714)), J.mul(1.6, v_s_714), J.mul(1.5, v_s_714), "#100c10"])
	var _t291 = env["el"]
	J.cl(_t291, null, [v_ctx_710, v_x_711, J.add(v_y_712, J.mul(1.6, v_s_714)), J.mul(0.9, v_s_714), J.mul(1.2, v_s_714), "#a01818"])

func _f72(this_, a: Array, env):
	var v_ctx_719 = null; var v_x_720 = null; var v_y_721 = null; var v_ripe_722 = null; var v_t_723 = null; var v_i_724 = null; var v_a_725 = null; var v_b_726 = null; var v_bx_727 = null; var v_by_728 = null; var v_sway_729 = null
	v_ctx_719 = J.arg(a, 0)
	v_x_720 = J.arg(a, 1)
	v_y_721 = J.arg(a, 2)
	v_ripe_722 = J.arg(a, 3)
	v_t_723 = J.arg(a, 4)
	v_i_724 = J.arg(a, 5)
	var _t292 = env["rr"]
	J.cl(_t292, null, [v_ctx_719, J.sub(v_x_720, 24.0), J.sub(v_y_721, 15.0), 48.0, 20.0, 3.0, "#151b17", "#0c100d", 1.5])
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
				var _t293 = env["el"]
				J.cl(_t293, null, [v_ctx_719, J.add(J.add(v_bx_727, 5.0), v_sway_729), J.sub(v_by_728, 8.0), 1.6, 2.6, "#c8bc8a"])
				var _t294 = env["el"]
				J.cl(_t294, null, [v_ctx_719, J.add(J.add(v_bx_727, 3.5), v_sway_729), J.sub(v_by_728, 10.0), 1.4, 2.2, "#b0a474"])
			else:
				J.sp(v_ctx_719, "strokeStyle", "#3a4430")
				J.sp(v_ctx_719, "lineWidth", 1.3)
				J.mc(v_ctx_719, "beginPath", [])
				J.mc(v_ctx_719, "moveTo", [v_bx_727, v_by_728])
				J.mc(v_ctx_719, "lineTo", [J.add(J.add(v_bx_727, 1.5), v_sway_729), J.sub(v_by_728, 4.0)])
				J.mc(v_ctx_719, "stroke", [])
			v_b_726 = J.num(v_b_726) + 1.0
		v_a_725 = J.num(v_a_725) + 1.0
	var _t295 = env["drawWeb"]
	J.cl(_t295, null, [v_ctx_719, J.sub(v_x_720, 22.0), J.sub(v_y_721, 13.0), 12.0, 0.0, J.div(PI, 2.0), 0.42])
	if J.seq(J.mod((v_i_724 if J.t(v_i_724) else 0.0), 2.0), 0.0):
		var _t296 = env["drawSpider"]
		J.cl(_t296, null, [v_ctx_719, J.add(v_x_720, 14.0), (J.sub(v_y_721, 16.0) + (sin(J.num(J.add(J.mul(v_t_723, 1.3), (v_i_724 if J.t(v_i_724) else 0.0)))) * 3.0)), J.sub(v_y_721, 34.0), 0.9])

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
	var _s189 = {"__p": env, "ctx": null}
	_s189["ctx"] = J.arg(a, 0)
	v_x_733 = J.arg(a, 1)
	v_y_734 = J.arg(a, 2)
	v_t_735 = J.arg(a, 3)
	v_sw_736 = (sin(J.num(J.mul(v_t_735, 0.9))) * 0.05)
	var _t297 = _s189["__p"]["el"]
	J.cl(_t297, null, [_s189["ctx"], v_x_733, J.add(v_y_734, 2.0), 12.0, 3.5, "rgba(0,0,0,.35)"])
	J.mc(_s189["ctx"], "save", [])
	J.mc(_s189["ctx"], "translate", [v_x_733, v_y_734])
	J.mc(_s189["ctx"], "rotate", [v_sw_736])
	var _t298 = _s189["__p"]["rr"]
	J.cl(_t298, null, [_s189["ctx"], (-1.6), (-46.0), 3.2, 46.0, 1.0, "#4a3424", _s189["__p"]["OUT"], 1.0])
	var _t299 = _s189["__p"]["rr"]
	J.cl(_t299, null, [_s189["ctx"], (-20.0), (-36.0), 40.0, 3.0, 1.0, "#4a3424", _s189["__p"]["OUT"], 1.0])
	var _t300 = _s189["__p"]["poly"]
	J.cl(_t300, null, [_s189["ctx"], [(-12.0), (-37.0), 12.0, (-37.0), 15.0, (-14.0), 8.0, (-18.0), 3.0, (-12.0), (-3.0), (-17.0), (-9.0), (-12.0), (-15.0), (-16.0)], "#4a3a40", _s189["__p"]["OUT"], 1.3])
	var _t301 = _s189["ctx"]
	J.sp(_t301, "strokeStyle", "#a89058")
	var _t302 = _s189["ctx"]
	J.sp(_t302, "lineWidth", 1.0)
	var _t303 = [(-19.0), 19.0]
	J.mc(_t303, "forEach", [Callable(self, "_f74").bind(_s189)])
	var _t304 = _s189["__p"]["el"]
	J.cl(_t304, null, [_s189["ctx"], 0.0, (-46.0), 9.0, 9.5, "#b8a47a", _s189["__p"]["OUT"], 1.4])
	var _t305 = _s189["ctx"]
	J.sp(_t305, "strokeStyle", "#2a1a10")
	var _t306 = _s189["ctx"]
	J.sp(_t306, "lineWidth", 1.2)
	J.mc(_s189["ctx"], "beginPath", [])
	J.mc(_s189["ctx"], "moveTo", [(-5.0), (-49.0)])
	J.mc(_s189["ctx"], "lineTo", [(-2.0), (-46.0)])
	J.mc(_s189["ctx"], "moveTo", [(-2.0), (-49.0)])
	J.mc(_s189["ctx"], "lineTo", [(-5.0), (-46.0)])
	J.mc(_s189["ctx"], "moveTo", [2.0, (-49.0)])
	J.mc(_s189["ctx"], "lineTo", [5.0, (-46.0)])
	J.mc(_s189["ctx"], "moveTo", [5.0, (-49.0)])
	J.mc(_s189["ctx"], "lineTo", [2.0, (-46.0)])
	J.mc(_s189["ctx"], "stroke", [])
	J.mc(_s189["ctx"], "beginPath", [])
	J.mc(_s189["ctx"], "moveTo", [(-5.0), (-41.0)])
	J.mc(_s189["ctx"], "lineTo", [5.0, (-41.0)])
	J.mc(_s189["ctx"], "stroke", [])
	v_k_739 = (-4.0)
	while true:
		if not J.cmp(v_k_739, 4.0, "<="): break
		J.mc(_s189["ctx"], "beginPath", [])
		J.mc(_s189["ctx"], "moveTo", [v_k_739, (-43.0)])
		J.mc(_s189["ctx"], "lineTo", [v_k_739, (-39.0)])
		J.mc(_s189["ctx"], "stroke", [])
		var _t307 = J.add(v_k_739, 2.0)
		v_k_739 = _t307
	var _t308 = _s189["__p"]["poly"]
	J.cl(_t308, null, [_s189["ctx"], [(-11.0), (-52.0), 11.0, (-52.0), 6.0, (-62.0), (-5.0), (-61.0)], "#3a2a1a", _s189["__p"]["OUT"], 1.2])
	J.mc(_s189["ctx"], "restore", [])
	var _t309 = _s189["__p"]["drawCrow"]
	J.cl(_t309, null, [_s189["ctx"], J.add(v_x_733, 18.0), J.sub(v_y_734, 40.0), 0.7, 0.0, (-1.0), true])

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
	var _t310 = ("rgba(190,240,255," + J.str(J.add(v_a_747, 0.2)) + ")")
	J.sp(v_ctx_742, "fillStyle", _t310)
	J.mc(v_ctx_742, "fill", [])

func _f76(this_, a: Array, env):
	var v_ctx_751 = null; var v_x_752 = null; var v_y_753 = null; var v_t_754 = null
	v_ctx_751 = J.arg(a, 0)
	v_x_752 = J.arg(a, 1)
	v_y_753 = J.arg(a, 2)
	v_t_754 = J.arg(a, 3)
	var _t311 = env["el"]
	J.cl(_t311, null, [v_ctx_751, v_x_752, J.add(v_y_753, 4.0), 60.0, 10.0, "rgba(0,0,0,.3)"])
	var _t312 = env["rr"]
	J.cl(_t312, null, [v_ctx_751, J.sub(v_x_752, 52.0), J.sub(v_y_753, 54.0), 14.0, 54.0, 2.0, "#5a2a2a", env["OUT"], 2.0])
	var _t313 = env["rr"]
	J.cl(_t313, null, [v_ctx_751, J.add(v_x_752, 38.0), J.sub(v_y_753, 54.0), 14.0, 54.0, 2.0, "#5a2a2a", env["OUT"], 2.0])
	var _t314 = env["rr"]
	J.cl(_t314, null, [v_ctx_751, J.sub(v_x_752, 60.0), J.sub(v_y_753, 66.0), 120.0, 12.0, 3.0, "#3a2a3a", env["OUT"], 2.0])
	var _t315 = env["rr"]
	J.cl(_t315, null, [v_ctx_751, J.sub(v_x_752, 50.0), J.sub(v_y_753, 50.0), 100.0, 8.0, 2.0, "#7a3a3a", env["OUT"], 1.5])
	var _t316 = env["roof"]
	J.cl(_t316, null, [v_ctx_751, v_x_752, J.sub(v_y_753, 84.0), 110.0, 18.0, "#2a2438"])
	var _t317 = env["plaque"]
	J.cl(_t317, null, [v_ctx_751, v_x_752, J.sub(v_y_753, 46.0), "地盤", 0.0])
	var _t318 = env["lantern"]
	J.cl(_t318, null, [v_ctx_751, J.sub(v_x_752, 45.0), J.sub(v_y_753, 40.0), v_t_754])
	var _t319 = env["lantern"]
	J.cl(_t319, null, [v_ctx_751, J.add(v_x_752, 45.0), J.sub(v_y_753, 40.0), v_t_754])

func _f77(this_, a: Array, env):
	var v_ctx_757 = null; var v_kind_758 = null; var v_x_759 = null; var v_y_760 = null; var v_t_761 = null; var v_k_762 = null; var v_k_763 = null; var v_k_764 = null
	v_ctx_757 = J.arg(a, 0)
	v_kind_758 = J.arg(a, 1)
	v_x_759 = J.arg(a, 2)
	v_y_760 = J.arg(a, 3)
	v_t_761 = J.arg(a, 4)
	if J.seq(v_kind_758, "grave"):
		var _t320 = env["el"]
		J.cl(_t320, null, [v_ctx_757, v_x_759, J.add(v_y_760, 2.0), 13.0, 4.0, "rgba(0,0,0,.3)"])
		J.mc(v_ctx_757, "beginPath", [])
		J.mc(v_ctx_757, "moveTo", [J.sub(v_x_759, 10.0), v_y_760])
		J.mc(v_ctx_757, "lineTo", [J.sub(v_x_759, 10.0), J.sub(v_y_760, 18.0)])
		J.mc(v_ctx_757, "arc", [v_x_759, J.sub(v_y_760, 18.0), 10.0, PI, 0.0])
		J.mc(v_ctx_757, "lineTo", [J.add(v_x_759, 10.0), v_y_760])
		J.mc(v_ctx_757, "closePath", [])
		J.sp(v_ctx_757, "fillStyle", "#4a4660")
		J.mc(v_ctx_757, "fill", [])
		var _t321 = env["OUT"]
		J.sp(v_ctx_757, "strokeStyle", _t321)
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
			var _t322 = env["rr"]
			J.cl(_t322, null, [v_ctx_757, J.sub(v_x_759, 2.0), J.sub(v_y_760, 40.0), 4.0, 40.0, 1.0, "#3a2a20", env["OUT"], 1.0])
			var _t323 = env["lantern"]
			J.cl(_t323, null, [v_ctx_757, v_x_759, J.sub(v_y_760, 38.0), v_t_761, "#e8e0c8"])
		else:
			if J.seq(v_kind_758, "banana"):
				var _t324 = env["rr"]
				J.cl(_t324, null, [v_ctx_757, J.sub(v_x_759, 3.0), J.sub(v_y_760, 34.0), 6.0, 34.0, 2.0, "#3a5a3a", env["OUT"], 1.2])
				v_k_763 = 0.0
				while true:
					if not J.cmp(v_k_763, 5.0, "<"): break
					J.mc(v_ctx_757, "save", [])
					J.mc(v_ctx_757, "translate", [v_x_759, J.sub(v_y_760, 34.0)])
					J.mc(v_ctx_757, "rotate", [(((-2.4) + J.mul(v_k_763, 0.55)) + (sin(J.num(J.add(v_t_761, v_k_763))) * 0.04))])
					var _t325 = env["el"]
					J.cl(_t325, null, [v_ctx_757, 17.0, 0.0, 18.0, 5.0, ("#2e5a3a" if J.t(J.mod(v_k_763, 2.0)) else "#3a6a44"), env["OUT"], 1.0])
					J.mc(v_ctx_757, "restore", [])
					v_k_763 = J.num(v_k_763) + 1.0
			else:
				if J.seq(v_kind_758, "scarecrow"):
					var _t326 = env["drawScarecrow"]
					J.cl(_t326, null, [v_ctx_757, v_x_759, v_y_760, v_t_761])
				else:
					if J.seq(v_kind_758, "willo"):
						var _t327 = env["drawWillo"]
						J.cl(_t327, null, [v_ctx_757, v_x_759, v_y_760, v_t_761])
					else:
						if J.seq(v_kind_758, "webTL"):
							var _t328 = env["drawWeb"]
							J.cl(_t328, null, [v_ctx_757, v_x_759, v_y_760, 30.0, 0.0, J.div(PI, 2.0), 0.32])
						else:
							if J.seq(v_kind_758, "webTR"):
								var _t329 = env["drawWeb"]
								J.cl(_t329, null, [v_ctx_757, v_x_759, v_y_760, 30.0, J.div(PI, 2.0), PI, 0.32])
							else:
								if J.seq(v_kind_758, "offer"):
									var _t330 = env["rr"]
									J.cl(_t330, null, [v_ctx_757, J.sub(v_x_759, 9.0), J.sub(v_y_760, 6.0), 18.0, 6.0, 1.0, "#7a3a2a", env["OUT"], 1.0])
									v_k_764 = (-1.0)
									while true:
										if not J.cmp(v_k_764, 1.0, "<="): break
										var _t331 = env["rr"]
										J.cl(_t331, null, [v_ctx_757, J.sub(J.add(v_x_759, J.mul(v_k_764, 4.0)), 0.6), J.sub(v_y_760, 16.0), 1.2, 10.0, 0.5, "#c8a050"])
										var _t332 = env["el"]
										J.cl(_t332, null, [v_ctx_757, J.add(v_x_759, J.mul(v_k_764, 4.0)), J.sub(v_y_760, 16.0), 1.2, 1.2, "#ff8040"])
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
	var _t333 = env["wisp"]
	J.cl(_t333, null, [v_ctx_161, v_x_162, v_y_163, v_s_164, "#2b2f45", v_t_166, 8.0])
	var _t334 = env["body"]
	J.cl(_t334, null, [v_ctx_161, v_x_162, J.sub(v_y_163, J.mul(5.0, v_s_164)), v_s_164, "#eef1f8"])
	var _t335 = env["poly"]
	J.cl(_t335, null, [v_ctx_161, [J.sub(v_x_162, J.mul(1.5, v_s_164)), J.sub(v_y_163, J.mul(22.0, v_s_164)), J.add(v_x_162, J.mul(1.5, v_s_164)), J.sub(v_y_163, J.mul(22.0, v_s_164)), J.add(v_x_162, J.mul(2.5, v_s_164)), J.sub(v_y_163, J.mul(10.0, v_s_164)), v_x_162, J.sub(v_y_163, J.mul(8.0, v_s_164)), J.sub(v_x_162, J.mul(2.5, v_s_164)), J.sub(v_y_163, J.mul(10.0, v_s_164))], "#c0283c", env["OUT"], J.mul(1.0, v_s_164)])
	var _t336 = env["rr"]
	J.cl(_t336, null, [v_ctx_161, J.add(v_x_162, J.mul(3.0, v_s_164)), J.sub(v_y_163, J.mul(15.0, v_s_164)), J.mul(5.0, v_s_164), J.mul(6.0, v_s_164), J.mul(1.0, v_s_164), "#4a8ad8", env["OUT"], J.mul(1.0, v_s_164)])
	v_sw_168 = (sin(J.num(J.mul(v_t_166, 12.0))) if J.t(J.gp(v_o_165, "work")) else 0.0)
	var _t337 = env["arm"]
	J.cl(_t337, null, [v_ctx_161, J.sub(v_x_162, J.mul(8.0, v_s_164)), J.sub(v_y_163, J.mul(19.0, v_s_164)), J.sub(v_x_162, J.mul(12.0, v_s_164)), J.sub(v_y_163, J.mul(10.0, v_s_164)), v_s_164, "#eef1f8"])
	v_ax_169 = J.add(J.add(v_x_162, J.mul(12.0, v_s_164)), J.mul(J.mul(v_sw_168, 3.0), v_s_164))
	v_ay_170 = (J.sub(v_y_163, J.mul(14.0, v_s_164)) - J.mul(J.mul(v_sw_168, 6.0), v_s_164))
	var _t338 = env["arm"]
	J.cl(_t338, null, [v_ctx_161, J.add(v_x_162, J.mul(8.0, v_s_164)), J.sub(v_y_163, J.mul(19.0, v_s_164)), v_ax_169, v_ay_170, v_s_164, "#eef1f8"])
	if (not J.seq(J.gp(v_o_165, "tool"), false)):
		J.mc(v_ctx_161, "save", [])
		J.mc(v_ctx_161, "translate", [v_ax_169, v_ay_170])
		J.mc(v_ctx_161, "rotate", [((-0.9) + J.mul(v_sw_168, 0.9))])
		var _t339 = env["rr"]
		J.cl(_t339, null, [v_ctx_161, J.mul((-1.2), v_s_164), J.mul((-14.0), v_s_164), J.mul(2.4, v_s_164), J.mul(16.0, v_s_164), J.mul(1.0, v_s_164), "#8a5a2b", env["OUT"], J.mul(1.0, v_s_164)])
		var _t340 = env["poly"]
		J.cl(_t340, null, [v_ctx_161, [J.mul(1.0, v_s_164), J.mul((-14.0), v_s_164), J.mul(8.0, v_s_164), J.mul((-16.0), v_s_164), J.mul(8.0, v_s_164), J.mul((-8.0), v_s_164), J.mul(1.0, v_s_164), J.mul((-10.0), v_s_164)], "#b8c2d0", env["OUT"], J.mul(1.0, v_s_164)])
		J.mc(v_ctx_161, "restore", [])
	var _t341 = env["el"]
	J.cl(_t341, null, [v_ctx_161, v_x_162, v_hy_167, J.mul(14.0, v_s_164), J.mul(13.0, v_s_164), "#dfe6f5", env["OUT"], J.mul(1.8, v_s_164)])
	J.sp(v_ctx_161, "fillStyle", "#20232f")
	J.mc(v_ctx_161, "beginPath", [])
	J.mc(v_ctx_161, "ellipse", [v_x_162, J.sub(v_hy_167, J.mul(6.0, v_s_164)), J.mul(14.5, v_s_164), J.mul(8.5, v_s_164), 0.0, PI, env["TAU"]])
	J.mc(v_ctx_161, "fill", [])
	var _t342 = env["poly"]
	J.cl(_t342, null, [v_ctx_161, [J.sub(v_x_162, J.mul(14.0, v_s_164)), J.sub(v_hy_167, J.mul(6.0, v_s_164)), J.sub(v_x_162, J.mul(6.0, v_s_164)), J.sub(v_hy_167, J.mul(4.0, v_s_164)), J.sub(v_x_162, J.mul(2.0, v_s_164)), J.sub(v_hy_167, J.mul(9.0, v_s_164)), J.add(v_x_162, J.mul(4.0, v_s_164)), J.sub(v_hy_167, J.mul(4.0, v_s_164)), J.add(v_x_162, J.mul(14.0, v_s_164)), J.sub(v_hy_167, J.mul(6.0, v_s_164)), J.add(v_x_162, J.mul(12.0, v_s_164)), J.sub(v_hy_167, J.mul(12.0, v_s_164)), J.sub(v_x_162, J.mul(12.0, v_s_164)), J.sub(v_hy_167, J.mul(12.0, v_s_164))], "#20232f"])
	var _t343 = env["eyes"]
	J.cl(_t343, null, [v_ctx_161, v_x_162, J.add(v_hy_167, J.mul(1.0, v_s_164)), v_s_164, "tired"])
	var _t344 = env["mouth"]
	J.cl(_t344, null, [v_ctx_161, v_x_162, v_hy_167, v_s_164, ("smile" if J.seq(J.gp(v_o_165, "mood"), "happy") else "wavy")])
	var _t345 = env["el"]
	J.cl(_t345, null, [v_ctx_161, J.add(v_x_162, J.mul(12.0, v_s_164)), (J.sub(v_hy_167, J.mul(13.0, v_s_164)) + J.mul((sin(J.num(J.mul(v_t_166, 3.0))) * 1.5), v_s_164)), J.mul(2.5, v_s_164), J.mul(3.5, v_s_164), "rgba(140,220,255,.75)"])

func _f15(this_, a: Array, env):
	var v_ctx_173 = null; var v_x_174 = null; var v_y_175 = null; var v_s_176 = null; var v_o_177 = null; var v_t_178 = null; var v_hy_179 = null; var v_sw_180 = null
	v_ctx_173 = J.arg(a, 0)
	v_x_174 = J.arg(a, 1)
	v_y_175 = J.arg(a, 2)
	v_s_176 = J.arg(a, 3)
	v_o_177 = J.arg(a, 4)
	v_t_178 = J.gp(v_o_177, "t")
	v_hy_179 = J.sub(v_y_175, J.mul(33.0, v_s_176))
	var _t346 = env["legs"]
	J.cl(_t346, null, [v_ctx_173, v_x_174, v_y_175, v_s_176, "#f6efe3", (J.mul(v_t_178, 10.0) if J.t(J.gp(v_o_177, "walk")) else 0.0)])
	var _t347 = env["poly"]
	J.cl(_t347, null, [v_ctx_173, [J.sub(v_x_174, J.mul(10.0, v_s_176)), J.sub(v_y_175, J.mul(5.0, v_s_176)), J.add(v_x_174, J.mul(10.0, v_s_176)), J.sub(v_y_175, J.mul(5.0, v_s_176)), J.add(v_x_174, J.mul(7.0, v_s_176)), J.sub(v_y_175, J.mul(23.0, v_s_176)), J.sub(v_x_174, J.mul(7.0, v_s_176)), J.sub(v_y_175, J.mul(23.0, v_s_176))], "#e84a5f", env["OUT"], J.mul(1.5, v_s_176)])
	J.sp(v_ctx_173, "fillStyle", "#ffd25a")
	J.mc(v_ctx_173, "fillRect", [J.sub(v_x_174, J.mul(10.0, v_s_176)), J.sub(v_y_175, J.mul(9.0, v_s_176)), J.mul(20.0, v_s_176), J.mul(2.0, v_s_176)])
	v_sw_180 = (J.mul((sin(J.num(J.mul(v_t_178, 10.0))) * 3.0), v_s_176) if J.t(J.gp(v_o_177, "work")) else 0.0)
	var _t348 = env["arm"]
	J.cl(_t348, null, [v_ctx_173, J.sub(v_x_174, J.mul(7.0, v_s_176)), J.sub(v_y_175, J.mul(20.0, v_s_176)), J.sub(v_x_174, J.mul(11.0, v_s_176)), J.add(J.sub(v_y_175, J.mul(12.0, v_s_176)), v_sw_180), v_s_176, "#f6efe3"])
	var _t349 = env["arm"]
	J.cl(_t349, null, [v_ctx_173, J.add(v_x_174, J.mul(7.0, v_s_176)), J.sub(v_y_175, J.mul(20.0, v_s_176)), J.add(v_x_174, J.mul(11.0, v_s_176)), J.sub(J.sub(v_y_175, J.mul(12.0, v_s_176)), v_sw_180), v_s_176, "#f6efe3"])
	var _t350 = env["el"]
	J.cl(_t350, null, [v_ctx_173, v_x_174, v_hy_179, J.mul(13.0, v_s_176), J.mul(12.5, v_s_176), "#fbf6ec", env["OUT"], J.mul(1.8, v_s_176)])
	J.sp(v_ctx_173, "fillStyle", "#16131c")
	J.mc(v_ctx_173, "beginPath", [])
	J.mc(v_ctx_173, "ellipse", [v_x_174, J.sub(v_hy_179, J.mul(4.0, v_s_176)), J.mul(13.5, v_s_176), J.mul(9.0, v_s_176), 0.0, PI, env["TAU"]])
	J.mc(v_ctx_173, "fill", [])
	var _t351 = env["el"]
	J.cl(_t351, null, [v_ctx_173, J.sub(v_x_174, J.mul(11.0, v_s_176)), J.sub(v_hy_179, J.mul(10.0, v_s_176)), J.mul(5.0, v_s_176), J.mul(5.0, v_s_176), "#16131c"])
	var _t352 = env["el"]
	J.cl(_t352, null, [v_ctx_173, J.add(v_x_174, J.mul(11.0, v_s_176)), J.sub(v_hy_179, J.mul(10.0, v_s_176)), J.mul(5.0, v_s_176), J.mul(5.0, v_s_176), "#16131c"])
	var _t353 = env["el"]
	J.cl(_t353, null, [v_ctx_173, J.sub(v_x_174, J.mul(11.0, v_s_176)), J.sub(v_hy_179, J.mul(10.0, v_s_176)), J.mul(1.8, v_s_176), J.mul(1.8, v_s_176), "#e84a5f"])
	var _t354 = env["el"]
	J.cl(_t354, null, [v_ctx_173, J.add(v_x_174, J.mul(11.0, v_s_176)), J.sub(v_hy_179, J.mul(10.0, v_s_176)), J.mul(1.8, v_s_176), J.mul(1.8, v_s_176), "#e84a5f"])
	var _t355 = env["eyes"]
	J.cl(_t355, null, [v_ctx_173, v_x_174, J.add(v_hy_179, J.mul(1.0, v_s_176)), v_s_176, "paper"])
	var _t356 = env["blush"]
	J.cl(_t356, null, [v_ctx_173, v_x_174, v_hy_179, v_s_176, "#ff6f8a"])
	var _t357 = env["mouth"]
	J.cl(_t357, null, [v_ctx_173, v_x_174, v_hy_179, v_s_176, "red"])

func _f16(this_, a: Array, env):
	var v_ctx_183 = null; var v_x_184 = null; var v_y_185 = null; var v_s_186 = null; var v_o_187 = null; var v_t_188 = null; var v_hy_189 = null
	v_ctx_183 = J.arg(a, 0)
	v_x_184 = J.arg(a, 1)
	v_y_185 = J.arg(a, 2)
	v_s_186 = J.arg(a, 3)
	v_o_187 = J.arg(a, 4)
	v_t_188 = J.gp(v_o_187, "t")
	v_hy_189 = J.sub(v_y_185, J.mul(32.0, v_s_186))
	var _t358 = env["legs"]
	J.cl(_t358, null, [v_ctx_183, v_x_184, v_y_185, v_s_186, "#f6efe3", (J.mul(v_t_188, 10.0) if J.t(J.gp(v_o_187, "walk")) else 0.0)])
	var _t359 = env["poly"]
	J.cl(_t359, null, [v_ctx_183, [J.sub(v_x_184, J.mul(10.0, v_s_186)), J.sub(v_y_185, J.mul(5.0, v_s_186)), J.add(v_x_184, J.mul(10.0, v_s_186)), J.sub(v_y_185, J.mul(5.0, v_s_186)), J.add(v_x_184, J.mul(7.0, v_s_186)), J.sub(v_y_185, J.mul(22.0, v_s_186)), J.sub(v_x_184, J.mul(7.0, v_s_186)), J.sub(v_y_185, J.mul(22.0, v_s_186))], "#3a8ad6", env["OUT"], J.mul(1.5, v_s_186)])
	J.sp(v_ctx_183, "fillStyle", "#ffd25a")
	J.mc(v_ctx_183, "fillRect", [J.sub(v_x_184, J.mul(10.0, v_s_186)), J.sub(v_y_185, J.mul(9.0, v_s_186)), J.mul(20.0, v_s_186), J.mul(2.0, v_s_186)])
	var _t360 = env["arm"]
	J.cl(_t360, null, [v_ctx_183, J.sub(v_x_184, J.mul(7.0, v_s_186)), J.sub(v_y_185, J.mul(19.0, v_s_186)), J.sub(v_x_184, J.mul(11.0, v_s_186)), J.sub(v_y_185, J.mul(11.0, v_s_186)), v_s_186, "#f6efe3"])
	var _t361 = env["arm"]
	J.cl(_t361, null, [v_ctx_183, J.add(v_x_184, J.mul(7.0, v_s_186)), J.sub(v_y_185, J.mul(19.0, v_s_186)), J.add(v_x_184, J.mul(11.0, v_s_186)), J.sub(v_y_185, J.mul(11.0, v_s_186)), v_s_186, "#f6efe3"])
	var _t362 = env["el"]
	J.cl(_t362, null, [v_ctx_183, v_x_184, v_hy_189, J.mul(12.5, v_s_186), J.mul(12.0, v_s_186), "#fbf6ec", env["OUT"], J.mul(1.8, v_s_186)])
	J.sp(v_ctx_183, "fillStyle", "#16131c")
	J.mc(v_ctx_183, "beginPath", [])
	J.mc(v_ctx_183, "ellipse", [v_x_184, J.sub(v_hy_189, J.mul(5.0, v_s_186)), J.mul(13.0, v_s_186), J.mul(7.5, v_s_186), 0.0, PI, env["TAU"]])
	J.mc(v_ctx_183, "fill", [])
	var _t363 = env["el"]
	J.cl(_t363, null, [v_ctx_183, v_x_184, J.sub(v_hy_189, J.mul(13.0, v_s_186)), J.mul(4.0, v_s_186), J.mul(3.0, v_s_186), "#16131c"])
	var _t364 = env["eyes"]
	J.cl(_t364, null, [v_ctx_183, v_x_184, J.add(v_hy_189, J.mul(1.0, v_s_186)), v_s_186, "paper"])
	var _t365 = env["blush"]
	J.cl(_t365, null, [v_ctx_183, v_x_184, v_hy_189, v_s_186, "#ff6f8a"])
	var _t366 = env["mouth"]
	J.cl(_t366, null, [v_ctx_183, v_x_184, v_hy_189, v_s_186, "red"])

func _f17(this_, a: Array, env):
	var v_ctx_192 = null; var v_x_193 = null; var v_y_194 = null; var v_s_195 = null; var v_o_196 = null; var v_t_197 = null; var v_hy_198 = null
	v_ctx_192 = J.arg(a, 0)
	v_x_193 = J.arg(a, 1)
	v_y_194 = J.arg(a, 2)
	v_s_195 = J.arg(a, 3)
	v_o_196 = J.arg(a, 4)
	v_t_197 = J.gp(v_o_196, "t")
	v_hy_198 = (J.sub(v_y_194, J.mul(26.0, v_s_195)) - J.mul((sin(J.num(J.mul(v_t_197, 3.0))) * 2.0), v_s_195))
	var _t367 = J.mul(J.gp(v_ctx_192, "globalAlpha"), 0.88)
	J.sp(v_ctx_192, "globalAlpha", _t367)
	var _t368 = env["ghostTail"]
	J.cl(_t368, null, [v_ctx_192, v_x_193, J.sub(v_y_194, J.mul((sin(J.num(J.mul(v_t_197, 3.0))) * 2.0), v_s_195)), v_s_195, "#dfeaff", v_t_197])
	var _t369 = env["el"]
	J.cl(_t369, null, [v_ctx_192, v_x_193, v_hy_198, J.mul(12.0, v_s_195), J.mul(12.0, v_s_195), "#e9f1ff", env["OUT"], J.mul(1.6, v_s_195)])
	var _t370 = env["eyes"]
	J.cl(_t370, null, [v_ctx_192, v_x_193, J.add(v_hy_198, J.mul(1.0, v_s_195)), v_s_195, ("angry" if J.t(J.gp(v_o_196, "enemy")) else "dot")])
	var _t371 = env["mouth"]
	J.cl(_t371, null, [v_ctx_192, v_x_193, v_hy_198, v_s_195, "open"])
	var _t372 = env["el"]
	J.cl(_t372, null, [v_ctx_192, J.add(v_x_193, J.mul(10.0, v_s_195)), J.sub(v_hy_198, J.mul(10.0, v_s_195)), J.mul(2.0, v_s_195), J.mul(3.0, v_s_195), "rgba(160,230,255,.8)"])

func _f18(this_, a: Array, env):
	var v_ctx_201 = null; var v_x_202 = null; var v_y_203 = null; var v_s_204 = null; var v_o_205 = null; var v_t_206 = null; var v_hy_207 = null
	v_ctx_201 = J.arg(a, 0)
	v_x_202 = J.arg(a, 1)
	v_y_203 = J.arg(a, 2)
	v_s_204 = J.arg(a, 3)
	v_o_205 = J.arg(a, 4)
	v_t_206 = J.gp(v_o_205, "t")
	v_hy_207 = J.sub(v_y_203, J.mul(34.0, v_s_204))
	var _t373 = env["wisp"]
	J.cl(_t373, null, [v_ctx_201, v_x_202, v_y_203, v_s_204, "#9cb38a", v_t_206, 7.0])
	var _t374 = env["el"]
	J.cl(_t374, null, [v_ctx_201, v_x_202, J.sub(v_y_203, J.mul(13.0, v_s_204)), J.mul(12.0, v_s_204), J.mul(10.0, v_s_204), "#9cb38a", env["OUT"], J.mul(1.6, v_s_204)])
	J.sp(v_ctx_201, "strokeStyle", "#6a7d5c")
	var _t375 = J.mul(1.0, v_s_204)
	J.sp(v_ctx_201, "lineWidth", _t375)
	J.mc(v_ctx_201, "beginPath", [])
	J.mc(v_ctx_201, "arc", [v_x_202, J.sub(v_y_203, J.mul(13.0, v_s_204)), J.mul(2.0, v_s_204), 0.0, env["TAU"]])
	J.mc(v_ctx_201, "stroke", [])
	var _t376 = env["rr"]
	J.cl(_t376, null, [v_ctx_201, J.sub(v_x_202, J.mul(1.2, v_s_204)), J.sub(v_y_203, J.mul(25.0, v_s_204)), J.mul(2.4, v_s_204), J.mul(5.0, v_s_204), J.mul(1.0, v_s_204), "#9cb38a", env["OUT"], J.mul(1.0, v_s_204)])
	var _t377 = env["arm"]
	J.cl(_t377, null, [v_ctx_201, J.sub(v_x_202, J.mul(9.0, v_s_204)), J.sub(v_y_203, J.mul(16.0, v_s_204)), J.sub(v_x_202, J.mul(13.0, v_s_204)), (J.sub(v_y_203, J.mul(22.0, v_s_204)) + J.mul((sin(J.num(J.mul(v_t_206, 6.0))) * 2.0), v_s_204)), v_s_204, "#9cb38a"])
	var _t378 = env["arm"]
	J.cl(_t378, null, [v_ctx_201, J.add(v_x_202, J.mul(9.0, v_s_204)), J.sub(v_y_203, J.mul(16.0, v_s_204)), J.add(v_x_202, J.mul(13.0, v_s_204)), (J.sub(v_y_203, J.mul(22.0, v_s_204)) - J.mul((sin(J.num(J.mul(v_t_206, 6.0))) * 2.0), v_s_204)), v_s_204, "#9cb38a"])
	var _t379 = env["el"]
	J.cl(_t379, null, [v_ctx_201, v_x_202, v_hy_207, J.mul(11.0, v_s_204), J.mul(10.0, v_s_204), "#a9c196", env["OUT"], J.mul(1.6, v_s_204)])
	var _t380 = env["eyes"]
	J.cl(_t380, null, [v_ctx_201, v_x_202, v_hy_207, v_s_204, "big"])
	var _t381 = env["mouth"]
	J.cl(_t381, null, [v_ctx_201, v_x_202, J.sub(v_hy_207, J.mul(1.0, v_s_204)), v_s_204, "open"])

func _f19(this_, a: Array, env):
	var v_ctx_210 = null; var v_x_211 = null; var v_y_212 = null; var v_s_213 = null; var v_o_214 = null; var v_t_215 = null; var v_hy_216 = null
	v_ctx_210 = J.arg(a, 0)
	v_x_211 = J.arg(a, 1)
	v_y_212 = J.arg(a, 2)
	v_s_213 = J.arg(a, 3)
	v_o_214 = J.arg(a, 4)
	v_t_215 = J.gp(v_o_214, "t")
	v_hy_216 = J.sub(v_y_212, J.mul(42.0, v_s_213))
	var _t382 = env["wisp"]
	J.cl(_t382, null, [v_ctx_210, v_x_211, v_y_212, v_s_213, "#7f9c6e", v_t_215, 11.0])
	var _t383 = env["el"]
	J.cl(_t383, null, [v_ctx_210, v_x_211, J.sub(v_y_212, J.mul(17.0, v_s_213)), J.mul(17.0, v_s_213), J.mul(14.0, v_s_213), "#7f9c6e", env["OUT"], J.mul(1.8, v_s_213)])
	J.sp(v_ctx_210, "fillStyle", "#c33")
	J.mc(v_ctx_210, "fillRect", [J.sub(v_x_211, J.mul(17.0, v_s_213)), J.sub(v_y_212, J.mul(20.0, v_s_213)), J.mul(34.0, v_s_213), J.mul(3.0, v_s_213)])
	var _t384 = env["rr"]
	J.cl(_t384, null, [v_ctx_210, J.sub(v_x_211, J.mul(1.5, v_s_213)), J.sub(v_y_212, J.mul(34.0, v_s_213)), J.mul(3.0, v_s_213), J.mul(5.0, v_s_213), J.mul(1.0, v_s_213), "#7f9c6e", env["OUT"], J.mul(1.0, v_s_213)])
	var _t385 = env["arm"]
	J.cl(_t385, null, [v_ctx_210, J.sub(v_x_211, J.mul(14.0, v_s_213)), J.sub(v_y_212, J.mul(22.0, v_s_213)), J.sub(v_x_211, J.mul(20.0, v_s_213)), (J.sub(v_y_212, J.mul(30.0, v_s_213)) + J.mul((sin(J.num(J.mul(v_t_215, 5.0))) * 2.0), v_s_213)), J.mul(v_s_213, 1.3), "#7f9c6e"])
	var _t386 = env["arm"]
	J.cl(_t386, null, [v_ctx_210, J.add(v_x_211, J.mul(14.0, v_s_213)), J.sub(v_y_212, J.mul(22.0, v_s_213)), J.add(v_x_211, J.mul(20.0, v_s_213)), J.sub(v_y_212, J.mul(30.0, v_s_213)), J.mul(v_s_213, 1.3), "#7f9c6e"])
	var _t387 = env["el"]
	J.cl(_t387, null, [v_ctx_210, J.add(v_x_211, J.mul(22.0, v_s_213)), J.sub(v_y_212, J.mul(33.0, v_s_213)), J.mul(5.0, v_s_213), J.mul(4.0, v_s_213), "#fff", env["OUT"], J.mul(1.0, v_s_213)])
	var _t388 = env["el"]
	J.cl(_t388, null, [v_ctx_210, v_x_211, v_hy_216, J.mul(13.0, v_s_213), J.mul(12.0, v_s_213), "#8eae7b", env["OUT"], J.mul(1.8, v_s_213)])
	var _t389 = env["poly"]
	J.cl(_t389, null, [v_ctx_210, [J.sub(v_x_211, J.mul(9.0, v_s_213)), J.sub(v_hy_216, J.mul(9.0, v_s_213)), J.sub(v_x_211, J.mul(6.0, v_s_213)), J.sub(v_hy_216, J.mul(17.0, v_s_213)), J.sub(v_x_211, J.mul(2.0, v_s_213)), J.sub(v_hy_216, J.mul(10.0, v_s_213)), J.add(v_x_211, J.mul(2.0, v_s_213)), J.sub(v_hy_216, J.mul(17.0, v_s_213)), J.add(v_x_211, J.mul(6.0, v_s_213)), J.sub(v_hy_216, J.mul(10.0, v_s_213)), J.add(v_x_211, J.mul(9.0, v_s_213)), J.sub(v_hy_216, J.mul(17.0, v_s_213)), J.add(v_x_211, J.mul(10.0, v_s_213)), J.sub(v_hy_216, J.mul(8.0, v_s_213))], "#e0b23a", env["OUT"], J.mul(1.2, v_s_213)])
	var _t390 = env["eyes"]
	J.cl(_t390, null, [v_ctx_210, v_x_211, v_hy_216, v_s_213, "angry"])
	var _t391 = env["mouth"]
	J.cl(_t391, null, [v_ctx_210, v_x_211, v_hy_216, v_s_213, "fang"])

func _f20(this_, a: Array, env):
	var v_ctx_219 = null; var v_x_220 = null; var v_y_221 = null; var v_s_222 = null; var v_o_223 = null; var v_t_224 = null; var v_hy_225 = null
	v_ctx_219 = J.arg(a, 0)
	v_x_220 = J.arg(a, 1)
	v_y_221 = J.arg(a, 2)
	v_s_222 = J.arg(a, 3)
	v_o_223 = J.arg(a, 4)
	v_t_224 = J.gp(v_o_223, "t")
	v_hy_225 = J.sub(v_y_221, J.mul(24.0, v_s_222))
	var _t392 = env["wisp"]
	J.cl(_t392, null, [v_ctx_219, v_x_220, v_y_221, v_s_222, "#7da59a", v_t_224, 6.0])
	var _t393 = env["el"]
	J.cl(_t393, null, [v_ctx_219, v_x_220, J.sub(v_y_221, J.mul(9.0, v_s_222)), J.mul(7.0, v_s_222), J.mul(6.0, v_s_222), "#7da59a", env["OUT"], J.mul(1.4, v_s_222)])
	var _t394 = env["el"]
	J.cl(_t394, null, [v_ctx_219, v_x_220, v_hy_225, J.mul(11.0, v_s_222), J.mul(10.5, v_s_222), "#8fb8ac", env["OUT"], J.mul(1.6, v_s_222)])
	var _t395 = env["poly"]
	J.cl(_t395, null, [v_ctx_219, [J.sub(v_x_220, J.mul(10.0, v_s_222)), J.sub(v_hy_225, J.mul(2.0, v_s_222)), J.sub(v_x_220, J.mul(17.0, v_s_222)), J.sub(v_hy_225, J.mul(5.0, v_s_222)), J.sub(v_x_220, J.mul(10.0, v_s_222)), J.add(v_hy_225, J.mul(3.0, v_s_222))], "#8fb8ac", env["OUT"], J.mul(1.2, v_s_222)])
	var _t396 = env["poly"]
	J.cl(_t396, null, [v_ctx_219, [J.add(v_x_220, J.mul(10.0, v_s_222)), J.sub(v_hy_225, J.mul(2.0, v_s_222)), J.add(v_x_220, J.mul(17.0, v_s_222)), J.sub(v_hy_225, J.mul(5.0, v_s_222)), J.add(v_x_220, J.mul(10.0, v_s_222)), J.add(v_hy_225, J.mul(3.0, v_s_222))], "#8fb8ac", env["OUT"], J.mul(1.2, v_s_222)])
	var _t397 = env["eyes"]
	J.cl(_t397, null, [v_ctx_219, v_x_220, v_hy_225, v_s_222, ("red" if J.t(J.gp(v_o_223, "enemy")) else "big")])
	var _t398 = env["mouth"]
	J.cl(_t398, null, [v_ctx_219, v_x_220, J.sub(v_hy_225, J.mul(1.0, v_s_222)), v_s_222, "smile"])

func _f21(this_, a: Array, env):
	var v_ctx_228 = null; var v_x_229 = null; var v_y_230 = null; var v_s_231 = null; var v_o_232 = null; var v_t_233 = null; var v_hy_234 = null
	v_ctx_228 = J.arg(a, 0)
	v_x_229 = J.arg(a, 1)
	v_y_230 = J.arg(a, 2)
	v_s_231 = J.arg(a, 3)
	v_o_232 = J.arg(a, 4)
	v_t_233 = J.gp(v_o_232, "t")
	v_hy_234 = J.sub(v_y_230, J.mul(26.0, v_s_231))
	var _t399 = env["wisp"]
	J.cl(_t399, null, [v_ctx_228, v_x_229, v_y_230, v_s_231, "#5e9b7c", v_t_233, 6.5])
	var _t400 = env["el"]
	J.cl(_t400, null, [v_ctx_228, v_x_229, J.sub(v_y_230, J.mul(10.0, v_s_231)), J.mul(8.0, v_s_231), J.mul(7.0, v_s_231), "#5e9b7c", env["OUT"], J.mul(1.4, v_s_231)])
	var _t401 = env["rr"]
	J.cl(_t401, null, [v_ctx_228, J.sub(v_x_229, J.mul(7.0, v_s_231)), J.sub(v_y_230, J.mul(12.0, v_s_231)), J.mul(14.0, v_s_231), J.mul(6.0, v_s_231), J.mul(2.0, v_s_231), "#f2f2f2", env["OUT"], J.mul(1.0, v_s_231)])
	var _t402 = env["arm"]
	J.cl(_t402, null, [v_ctx_228, J.add(v_x_229, J.mul(7.0, v_s_231)), J.sub(v_y_230, J.mul(13.0, v_s_231)), J.add(v_x_229, J.mul(12.0, v_s_231)), J.sub(v_y_230, J.mul(18.0, v_s_231)), v_s_231, "#5e9b7c"])
	var _t403 = env["el"]
	J.cl(_t403, null, [v_ctx_228, J.add(v_x_229, J.mul(14.0, v_s_231)), J.sub(v_y_230, J.mul(20.0, v_s_231)), J.mul(4.0, v_s_231), J.mul(3.0, v_s_231), "#e6c25a", env["OUT"], J.mul(1.0, v_s_231)])
	var _t404 = env["el"]
	J.cl(_t404, null, [v_ctx_228, v_x_229, v_hy_234, J.mul(12.0, v_s_231), J.mul(11.5, v_s_231), "#6cad8b", env["OUT"], J.mul(1.6, v_s_231)])
	var _t405 = env["poly"]
	J.cl(_t405, null, [v_ctx_228, [J.sub(v_x_229, J.mul(11.0, v_s_231)), J.sub(v_hy_234, J.mul(1.0, v_s_231)), J.sub(v_x_229, J.mul(18.0, v_s_231)), J.sub(v_hy_234, J.mul(7.0, v_s_231)), J.sub(v_x_229, J.mul(11.0, v_s_231)), J.add(v_hy_234, J.mul(4.0, v_s_231))], "#6cad8b", env["OUT"], J.mul(1.2, v_s_231)])
	var _t406 = env["poly"]
	J.cl(_t406, null, [v_ctx_228, [J.add(v_x_229, J.mul(11.0, v_s_231)), J.sub(v_hy_234, J.mul(1.0, v_s_231)), J.add(v_x_229, J.mul(18.0, v_s_231)), J.sub(v_hy_234, J.mul(7.0, v_s_231)), J.add(v_x_229, J.mul(11.0, v_s_231)), J.add(v_hy_234, J.mul(4.0, v_s_231))], "#6cad8b", env["OUT"], J.mul(1.2, v_s_231)])
	var _t407 = env["eyes"]
	J.cl(_t407, null, [v_ctx_228, v_x_229, J.add(v_hy_234, J.mul(1.0, v_s_231)), v_s_231, ("red" if J.t(J.gp(v_o_232, "enemy")) else "big")])
	var _t408 = env["mouth"]
	J.cl(_t408, null, [v_ctx_228, v_x_229, v_hy_234, v_s_231, "smile"])

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
	var _t410 = absf(J.num(sin(J.num(J.mul(v_t_249, 5.0)))))
	var _t409 = J.gp(v_o_248, "walk")
	v_hop_250 = J.mul((_t410 * (5.0 if J.t((_t409 if J.t(_t409) else J.gp(v_o_248, "enemy"))) else 1.5)), v_s_247)
	var _t411 = J.sub(v_y_246, v_hop_250)
	v_y_246 = _t411
	v_hy_251 = J.sub(v_y_246, J.mul(36.0, v_s_247))
	var _t412 = env["rr"]
	J.cl(_t412, null, [v_ctx_244, J.sub(v_x_245, J.mul(6.0, v_s_247)), J.sub(v_y_246, J.mul(6.0, v_s_247)), J.mul(5.0, v_s_247), J.mul(6.0, v_s_247), J.mul(1.0, v_s_247), "#222", env["OUT"], J.mul(1.0, v_s_247)])
	var _t413 = env["rr"]
	J.cl(_t413, null, [v_ctx_244, J.add(v_x_245, J.mul(1.0, v_s_247)), J.sub(v_y_246, J.mul(6.0, v_s_247)), J.mul(5.0, v_s_247), J.mul(6.0, v_s_247), J.mul(1.0, v_s_247), "#222", env["OUT"], J.mul(1.0, v_s_247)])
	v_rob_252 = ("#3b5d8a" if J.t(J.gp(v_o_248, "minor")) else "#26386b")
	var _t414 = env["poly"]
	J.cl(_t414, null, [v_ctx_244, [J.sub(v_x_245, J.mul(11.0, v_s_247)), J.sub(v_y_246, J.mul(5.0, v_s_247)), J.add(v_x_245, J.mul(11.0, v_s_247)), J.sub(v_y_246, J.mul(5.0, v_s_247)), J.add(v_x_245, J.mul(9.0, v_s_247)), J.sub(v_y_246, J.mul(25.0, v_s_247)), J.sub(v_x_245, J.mul(9.0, v_s_247)), J.sub(v_y_246, J.mul(25.0, v_s_247))], v_rob_252, env["OUT"], J.mul(1.6, v_s_247)])
	var _t415 = env["rr"]
	J.cl(_t415, null, [v_ctx_244, J.sub(v_x_245, J.mul(6.0, v_s_247)), J.sub(v_y_246, J.mul(21.0, v_s_247)), J.mul(12.0, v_s_247), J.mul(9.0, v_s_247), J.mul(1.0, v_s_247), "#c79a3a", env["OUT"], J.mul(1.0, v_s_247)])
	var _t416 = env["el"]
	J.cl(_t416, null, [v_ctx_244, v_x_245, J.sub(v_y_246, J.mul(16.5, v_s_247)), J.mul(2.5, v_s_247), J.mul(2.5, v_s_247), "#fff"])
	var _t417 = env["arm"]
	J.cl(_t417, null, [v_ctx_244, J.sub(v_x_245, J.mul(8.0, v_s_247)), J.sub(v_y_246, J.mul(22.0, v_s_247)), J.sub(v_x_245, J.mul(6.0, v_s_247)), (J.sub(v_y_246, J.mul(24.0, v_s_247)) - 0.0), v_s_247, v_rob_252])
	var _t418 = env["OUT"]
	J.sp(v_ctx_244, "strokeStyle", _t418)
	var _t419 = J.mul(5.0, v_s_247)
	J.sp(v_ctx_244, "lineWidth", _t419)
	J.sp(v_ctx_244, "lineCap", "round")
	J.mc(v_ctx_244, "beginPath", [])
	J.mc(v_ctx_244, "moveTo", [J.sub(v_x_245, J.mul(6.0, v_s_247)), J.sub(v_y_246, J.mul(23.0, v_s_247))])
	J.mc(v_ctx_244, "lineTo", [J.add(v_x_245, J.mul(14.0, v_s_247)), J.sub(v_y_246, J.mul(24.0, v_s_247))])
	J.mc(v_ctx_244, "moveTo", [J.add(v_x_245, J.mul(6.0, v_s_247)), J.sub(v_y_246, J.mul(21.0, v_s_247))])
	J.mc(v_ctx_244, "lineTo", [J.add(v_x_245, J.mul(16.0, v_s_247)), J.sub(v_y_246, J.mul(21.0, v_s_247))])
	J.mc(v_ctx_244, "stroke", [])
	J.sp(v_ctx_244, "strokeStyle", v_rob_252)
	var _t420 = J.mul(3.0, v_s_247)
	J.sp(v_ctx_244, "lineWidth", _t420)
	J.mc(v_ctx_244, "beginPath", [])
	J.mc(v_ctx_244, "moveTo", [J.sub(v_x_245, J.mul(6.0, v_s_247)), J.sub(v_y_246, J.mul(23.0, v_s_247))])
	J.mc(v_ctx_244, "lineTo", [J.add(v_x_245, J.mul(14.0, v_s_247)), J.sub(v_y_246, J.mul(24.0, v_s_247))])
	J.mc(v_ctx_244, "moveTo", [J.add(v_x_245, J.mul(6.0, v_s_247)), J.sub(v_y_246, J.mul(21.0, v_s_247))])
	J.mc(v_ctx_244, "lineTo", [J.add(v_x_245, J.mul(16.0, v_s_247)), J.sub(v_y_246, J.mul(21.0, v_s_247))])
	J.mc(v_ctx_244, "stroke", [])
	var _t421 = env["el"]
	J.cl(_t421, null, [v_ctx_244, J.add(v_x_245, J.mul(15.5, v_s_247)), J.sub(v_y_246, J.mul(24.0, v_s_247)), J.mul(2.0, v_s_247), J.mul(1.8, v_s_247), "#b8d0b0", env["OUT"], J.mul(0.8, v_s_247)])
	var _t422 = env["el"]
	J.cl(_t422, null, [v_ctx_244, J.add(v_x_245, J.mul(17.0, v_s_247)), J.sub(v_y_246, J.mul(21.0, v_s_247)), J.mul(2.0, v_s_247), J.mul(1.8, v_s_247), "#b8d0b0", env["OUT"], J.mul(0.8, v_s_247)])
	var _t423 = env["el"]
	J.cl(_t423, null, [v_ctx_244, v_x_245, v_hy_251, J.mul(12.5, v_s_247), J.mul(12.0, v_s_247), "#b8d0b0", env["OUT"], J.mul(1.8, v_s_247)])
	var _t424 = env["el"]
	J.cl(_t424, null, [v_ctx_244, v_x_245, J.sub(v_hy_251, J.mul(9.0, v_s_247)), J.mul(15.0, v_s_247), J.mul(4.0, v_s_247), "#1c1c1c", env["OUT"], J.mul(1.2, v_s_247)])
	J.sp(v_ctx_244, "fillStyle", "#1c1c1c")
	J.mc(v_ctx_244, "beginPath", [])
	J.mc(v_ctx_244, "ellipse", [v_x_245, J.sub(v_hy_251, J.mul(10.0, v_s_247)), J.mul(10.0, v_s_247), J.mul(7.0, v_s_247), 0.0, PI, env["TAU"]])
	J.mc(v_ctx_244, "fill", [])
	J.sp(v_ctx_244, "strokeStyle", "#b22")
	var _t425 = J.mul(1.2, v_s_247)
	J.sp(v_ctx_244, "lineWidth", _t425)
	v_i_254 = (-3.0)
	while true:
		if not J.cmp(v_i_254, 3.0, "<="): break
		J.mc(v_ctx_244, "beginPath", [])
		J.mc(v_ctx_244, "moveTo", [v_x_245, J.sub(v_hy_251, J.mul(17.0, v_s_247))])
		J.mc(v_ctx_244, "lineTo", [J.add(v_x_245, J.mul(J.mul(v_i_254, 3.0), v_s_247)), J.sub(v_hy_251, J.mul(10.0, v_s_247))])
		J.mc(v_ctx_244, "stroke", [])
		v_i_254 = J.num(v_i_254) + 1.0
	var _t426 = env["el"]
	J.cl(_t426, null, [v_ctx_244, v_x_245, J.sub(v_hy_251, J.mul(17.5, v_s_247)), J.mul(2.0, v_s_247), J.mul(2.0, v_s_247), ("#2a7" if J.t(J.gp(v_o_248, "minor")) else "#d22"), env["OUT"], J.mul(0.8, v_s_247)])
	v_fl_253 = J.mul((sin(J.num(J.mul(v_t_249, 6.0))) * 1.5), v_s_247)
	var _t427 = env["poly"]
	J.cl(_t427, null, [v_ctx_244, [J.sub(v_x_245, J.mul(3.0, v_s_247)), J.sub(v_hy_251, J.mul(6.0, v_s_247)), J.add(v_x_245, J.mul(3.0, v_s_247)), J.sub(v_hy_251, J.mul(6.0, v_s_247)), J.add(J.add(v_x_245, J.mul(3.5, v_s_247)), v_fl_253), J.add(v_hy_251, J.mul(9.0, v_s_247)), J.add(J.sub(v_x_245, J.mul(2.5, v_s_247)), v_fl_253), J.add(v_hy_251, J.mul(9.0, v_s_247))], "#f3d24a", "#a5741a", J.mul(0.8, v_s_247)])
	J.sp(v_ctx_244, "strokeStyle", "#c41")
	var _t428 = J.mul(0.9, v_s_247)
	J.sp(v_ctx_244, "lineWidth", _t428)
	J.mc(v_ctx_244, "beginPath", [])
	J.mc(v_ctx_244, "moveTo", [v_x_245, J.sub(v_hy_251, J.mul(4.0, v_s_247))])
	J.mc(v_ctx_244, "lineTo", [J.add(v_x_245, J.mul(v_fl_253, 0.6)), J.add(v_hy_251, J.mul(7.0, v_s_247))])
	J.mc(v_ctx_244, "moveTo", [J.sub(v_x_245, J.mul(1.5, v_s_247)), v_hy_251])
	J.mc(v_ctx_244, "lineTo", [J.add(v_x_245, J.mul(1.5, v_s_247)), v_hy_251])
	J.mc(v_ctx_244, "stroke", [])
	var _t429 = env["el"]
	J.cl(_t429, null, [v_ctx_244, J.sub(v_x_245, J.mul(6.0, v_s_247)), J.add(v_hy_251, J.mul(1.0, v_s_247)), J.mul(1.4, v_s_247), J.mul(1.4, v_s_247), env["OUT"]])
	var _t430 = env["el"]
	J.cl(_t430, null, [v_ctx_244, J.add(v_x_245, J.mul(6.0, v_s_247)), J.add(v_hy_251, J.mul(1.0, v_s_247)), J.mul(1.4, v_s_247), J.mul(1.4, v_s_247), env["OUT"]])
	var _t431 = env["mouth"]
	J.cl(_t431, null, [v_ctx_244, v_x_245, J.add(v_hy_251, J.mul(1.0, v_s_247)), v_s_247, "flat"])

func _f24(this_, a: Array, env):
	var v_ctx_257 = null; var v_x_258 = null; var v_y_259 = null; var v_s_260 = null; var v_o_261 = null; var v_t_262 = null; var v_hy_263 = null; var v_i_264 = null; var v_i_265 = null
	v_ctx_257 = J.arg(a, 0)
	v_x_258 = J.arg(a, 1)
	v_y_259 = J.arg(a, 2)
	v_s_260 = J.arg(a, 3)
	v_o_261 = J.arg(a, 4)
	v_t_262 = J.gp(v_o_261, "t")
	v_hy_263 = J.sub(v_y_259, J.mul(32.0, v_s_260))
	var _t432 = env["wisp"]
	J.cl(_t432, null, [v_ctx_257, v_x_258, v_y_259, v_s_260, "#4c7c8a", v_t_262, 8.0])
	var _t433 = env["body"]
	J.cl(_t433, null, [v_ctx_257, v_x_258, J.sub(v_y_259, J.mul(5.0, v_s_260)), v_s_260, "#4c7c8a"])
	v_i_264 = 0.0
	while true:
		if not J.cmp(v_i_264, 3.0, "<"): break
		var _t434 = env["el"]
		J.cl(_t434, null, [v_ctx_257, (J.sub(v_x_258, J.mul(6.0, v_s_260)) + J.mul(J.mul(v_i_264, 6.0), v_s_260)), (J.sub(v_y_259, J.mul(2.0, v_s_260)) + J.mul(J.mod((J.mul(v_t_262, 30.0) + J.mul(v_i_264, 9.0)), 8.0), v_s_260)), J.mul(1.0, v_s_260), J.mul(1.5, v_s_260), "rgba(140,200,230,.8)"])
		v_i_264 = J.num(v_i_264) + 1.0
	var _t435 = env["arm"]
	J.cl(_t435, null, [v_ctx_257, J.sub(v_x_258, J.mul(8.0, v_s_260)), J.sub(v_y_259, J.mul(18.0, v_s_260)), J.sub(v_x_258, J.mul(13.0, v_s_260)), J.sub(v_y_259, J.mul(9.0, v_s_260)), v_s_260, "#6aa0ae"])
	var _t436 = env["arm"]
	J.cl(_t436, null, [v_ctx_257, J.add(v_x_258, J.mul(8.0, v_s_260)), J.sub(v_y_259, J.mul(18.0, v_s_260)), J.add(v_x_258, J.mul(13.0, v_s_260)), J.sub(v_y_259, J.mul(9.0, v_s_260)), v_s_260, "#6aa0ae"])
	var _t437 = env["el"]
	J.cl(_t437, null, [v_ctx_257, v_x_258, v_hy_263, J.mul(12.0, v_s_260), J.mul(12.0, v_s_260), "#8cc0cc", env["OUT"], J.mul(1.6, v_s_260)])
	J.sp(v_ctx_257, "fillStyle", "#163238")
	J.mc(v_ctx_257, "beginPath", [])
	J.mc(v_ctx_257, "ellipse", [v_x_258, J.sub(v_hy_263, J.mul(3.0, v_s_260)), J.mul(13.0, v_s_260), J.mul(10.0, v_s_260), 0.0, PI, env["TAU"]])
	J.mc(v_ctx_257, "fill", [])
	v_i_265 = (-2.0)
	while true:
		if not J.cmp(v_i_265, 2.0, "<="): break
		var _t438 = env["rr"]
		J.cl(_t438, null, [v_ctx_257, J.sub(J.add(v_x_258, J.mul(J.mul(v_i_265, 4.5), v_s_260)), J.mul(1.5, v_s_260)), J.sub(v_hy_263, J.mul(4.0, v_s_260)), J.mul(3.0, v_s_260), (J.mul(9.0, v_s_260) + J.mul((absf(J.num(v_i_265)) * 2.0), v_s_260)), J.mul(1.5, v_s_260), "#163238"])
		v_i_265 = J.num(v_i_265) + 1.0
	var _t439 = env["eyes"]
	J.cl(_t439, null, [v_ctx_257, v_x_258, J.add(v_hy_263, J.mul(2.0, v_s_260)), v_s_260, ("red" if J.t(J.gp(v_o_261, "enemy")) else "dot")])
	var _t440 = env["mouth"]
	J.cl(_t440, null, [v_ctx_257, v_x_258, J.add(v_hy_263, J.mul(1.0, v_s_260)), v_s_260, "wavy"])

func _f25(this_, a: Array, env):
	var v_ctx_268 = null; var v_x_269 = null; var v_y_270 = null; var v_s_271 = null; var v_o_272 = null; var v_t_273 = null; var v_fl_274 = null; var v_hy_275 = null; var v_sw_276 = null; var v_i_277 = null; var v_i_278 = null
	v_ctx_268 = J.arg(a, 0)
	v_x_269 = J.arg(a, 1)
	v_y_270 = J.arg(a, 2)
	v_s_271 = J.arg(a, 3)
	v_o_272 = J.arg(a, 4)
	v_t_273 = J.gp(v_o_272, "t")
	v_fl_274 = J.mul((sin(J.num(J.mul(v_t_273, 2.5))) * 2.0), v_s_271)
	var _t441 = J.sub(v_y_270, J.add(J.mul(3.0, v_s_271), v_fl_274))
	v_y_270 = _t441
	v_hy_275 = J.sub(v_y_270, J.mul(36.0, v_s_271))
	J.sp(v_ctx_268, "fillStyle", "#0d0a12")
	J.mc(v_ctx_268, "beginPath", [])
	J.mc(v_ctx_268, "moveTo", [J.sub(v_x_269, J.mul(13.0, v_s_271)), J.sub(v_hy_275, J.mul(2.0, v_s_271))])
	J.mc(v_ctx_268, "quadraticCurveTo", [J.sub(v_x_269, J.mul(17.0, v_s_271)), J.sub(v_y_270, J.mul(10.0, v_s_271)), (J.sub(v_x_269, J.mul(12.0, v_s_271)) + J.mul((sin(J.num(J.mul(v_t_273, 3.0))) * 2.0), v_s_271)), J.sub(v_y_270, J.mul(2.0, v_s_271))])
	J.mc(v_ctx_268, "lineTo", [J.add(J.add(v_x_269, J.mul(12.0, v_s_271)), J.mul((sin(J.num((J.mul(v_t_273, 3.0) + 1.0))) * 2.0), v_s_271)), J.sub(v_y_270, J.mul(2.0, v_s_271))])
	J.mc(v_ctx_268, "quadraticCurveTo", [J.add(v_x_269, J.mul(17.0, v_s_271)), J.sub(v_y_270, J.mul(10.0, v_s_271)), J.add(v_x_269, J.mul(13.0, v_s_271)), J.sub(v_hy_275, J.mul(2.0, v_s_271))])
	J.mc(v_ctx_268, "fill", [])
	var _t442 = env["poly"]
	J.cl(_t442, null, [v_ctx_268, [J.sub(v_x_269, J.mul(9.0, v_s_271)), J.sub(v_y_270, J.mul(25.0, v_s_271)), J.add(v_x_269, J.mul(9.0, v_s_271)), J.sub(v_y_270, J.mul(25.0, v_s_271)), J.add(v_x_269, J.mul(13.0, v_s_271)), J.add(v_y_270, J.mul(2.0, v_s_271)), J.sub(v_x_269, J.mul(13.0, v_s_271)), J.add(v_y_270, J.mul(2.0, v_s_271))], "#f4f2f6", env["OUT"], J.mul(1.6, v_s_271)])
	J.sp(v_ctx_268, "strokeStyle", "#cfcbe0")
	var _t443 = J.mul(1.0, v_s_271)
	J.sp(v_ctx_268, "lineWidth", _t443)
	v_i_277 = (-2.0)
	while true:
		if not J.cmp(v_i_277, 2.0, "<="): break
		J.mc(v_ctx_268, "beginPath", [])
		J.mc(v_ctx_268, "moveTo", [J.add(v_x_269, J.mul(J.mul(v_i_277, 3.0), v_s_271)), J.sub(v_y_270, J.mul(20.0, v_s_271))])
		J.mc(v_ctx_268, "lineTo", [J.add(v_x_269, J.mul(J.mul(v_i_277, 4.5), v_s_271)), J.add(v_y_270, J.mul(1.0, v_s_271))])
		J.mc(v_ctx_268, "stroke", [])
		v_i_277 = J.num(v_i_277) + 1.0
	v_sw_276 = (J.mul(6.0, v_s_271) if J.t(J.gp(v_o_272, "atk")) else 0.0)
	var _t444 = env["arm"]
	J.cl(_t444, null, [v_ctx_268, J.sub(v_x_269, J.mul(8.0, v_s_271)), J.sub(v_y_270, J.mul(22.0, v_s_271)), J.sub(v_x_269, J.mul(13.0, v_s_271)), J.sub(v_y_270, J.mul(13.0, v_s_271)), v_s_271, "#f4f2f6"])
	var _t445 = env["arm"]
	J.cl(_t445, null, [v_ctx_268, J.add(v_x_269, J.mul(8.0, v_s_271)), J.sub(v_y_270, J.mul(22.0, v_s_271)), J.add(J.add(v_x_269, J.mul(14.0, v_s_271)), v_sw_276), J.sub(J.sub(v_y_270, J.mul(16.0, v_s_271)), v_sw_276), v_s_271, "#f4f2f6"])
	J.sp(v_ctx_268, "strokeStyle", "#b8b0c8")
	var _t446 = J.mul(1.0, v_s_271)
	J.sp(v_ctx_268, "lineWidth", _t446)
	v_i_278 = 0.0
	while true:
		if not J.cmp(v_i_278, 3.0, "<"): break
		J.mc(v_ctx_268, "beginPath", [])
		J.mc(v_ctx_268, "moveTo", [J.add(J.add(v_x_269, J.mul(14.0, v_s_271)), v_sw_276), (J.sub(J.sub(v_y_270, J.mul(16.0, v_s_271)), v_sw_276) + J.mul(v_i_278, v_s_271))])
		J.mc(v_ctx_268, "lineTo", [J.add(J.add(v_x_269, J.mul(19.0, v_s_271)), v_sw_276), (J.sub(J.sub(v_y_270, J.mul(18.0, v_s_271)), v_sw_276) + J.mul(J.mul(v_i_278, 2.0), v_s_271))])
		J.mc(v_ctx_268, "stroke", [])
		v_i_278 = J.num(v_i_278) + 1.0
	var _t447 = env["el"]
	J.cl(_t447, null, [v_ctx_268, v_x_269, v_hy_275, J.mul(12.0, v_s_271), J.mul(12.5, v_s_271), "#efe9f2", env["OUT"], J.mul(1.8, v_s_271)])
	J.sp(v_ctx_268, "fillStyle", "#0d0a12")
	J.mc(v_ctx_268, "beginPath", [])
	J.mc(v_ctx_268, "ellipse", [v_x_269, J.sub(v_hy_275, J.mul(2.0, v_s_271)), J.mul(13.0, v_s_271), J.mul(11.0, v_s_271), 0.0, PI, env["TAU"]])
	J.mc(v_ctx_268, "fill", [])
	var _t448 = env["rr"]
	J.cl(_t448, null, [v_ctx_268, J.sub(v_x_269, J.mul(13.0, v_s_271)), J.sub(v_hy_275, J.mul(3.0, v_s_271)), J.mul(5.0, v_s_271), J.mul(15.0, v_s_271), J.mul(2.0, v_s_271), "#0d0a12"])
	var _t449 = env["rr"]
	J.cl(_t449, null, [v_ctx_268, J.add(v_x_269, J.mul(8.0, v_s_271)), J.sub(v_hy_275, J.mul(3.0, v_s_271)), J.mul(5.0, v_s_271), J.mul(15.0, v_s_271), J.mul(2.0, v_s_271), "#0d0a12"])
	if J.t(J.gp(v_o_272, "tamed")):
		var _t450 = env["eyes"]
		J.cl(_t450, null, [v_ctx_268, v_x_269, J.add(v_hy_275, J.mul(2.0, v_s_271)), v_s_271, "closed"])
		var _t451 = env["blush"]
		J.cl(_t451, null, [v_ctx_268, v_x_269, J.add(v_hy_275, J.mul(1.0, v_s_271)), v_s_271])
		var _t452 = env["mouth"]
		J.cl(_t452, null, [v_ctx_268, v_x_269, J.add(v_hy_275, J.mul(1.0, v_s_271)), v_s_271, "smile"])
	else:
		var _t453 = env["eyes"]
		J.cl(_t453, null, [v_ctx_268, v_x_269, J.add(v_hy_275, J.mul(2.0, v_s_271)), v_s_271, "red"])
		var _t454 = env["mouth"]
		J.cl(_t454, null, [v_ctx_268, v_x_269, J.add(v_hy_275, J.mul(1.0, v_s_271)), v_s_271, "fang"])

func _f26(this_, a: Array, env):
	var v_ctx_281 = null; var v_x_282 = null; var v_y_283 = null; var v_s_284 = null; var v_o_285 = null; var v_t_286 = null; var v_hop_287 = null; var v_hy_288 = null; var v_i_289 = null
	v_ctx_281 = J.arg(a, 0)
	v_x_282 = J.arg(a, 1)
	v_y_283 = J.arg(a, 2)
	v_s_284 = J.arg(a, 3)
	v_o_285 = J.arg(a, 4)
	v_t_286 = J.gp(v_o_285, "t")
	v_hop_287 = J.mul((absf(J.num(sin(J.num(J.mul(v_t_286, 5.0))))) * 6.0), v_s_284)
	var _t455 = J.sub(v_y_283, v_hop_287)
	v_y_283 = _t455
	v_hy_288 = J.sub(v_y_283, J.mul(34.0, v_s_284))
	var _t456 = env["el"]
	J.cl(_t456, null, [v_ctx_281, v_x_282, J.sub(v_y_283, J.mul(14.0, v_s_284)), J.mul(11.0, v_s_284), J.mul(16.0, v_s_284), "#f1efe8", env["OUT"], J.mul(1.8, v_s_284)])
	J.sp(v_ctx_281, "strokeStyle", "#c9c4b4")
	var _t457 = J.mul(1.2, v_s_284)
	J.sp(v_ctx_281, "lineWidth", _t457)
	v_i_289 = 0.0
	while true:
		if not J.cmp(v_i_289, 3.0, "<"): break
		J.mc(v_ctx_281, "beginPath", [])
		J.mc(v_ctx_281, "moveTo", [J.sub(v_x_282, J.mul(10.0, v_s_284)), (J.sub(v_y_283, J.mul(22.0, v_s_284)) + J.mul(J.mul(v_i_289, 7.0), v_s_284))])
		J.mc(v_ctx_281, "quadraticCurveTo", [v_x_282, (J.sub(v_y_283, J.mul(18.0, v_s_284)) + J.mul(J.mul(v_i_289, 7.0), v_s_284)), J.add(v_x_282, J.mul(10.0, v_s_284)), (J.sub(v_y_283, J.mul(22.0, v_s_284)) + J.mul(J.mul(v_i_289, 7.0), v_s_284))])
		J.mc(v_ctx_281, "stroke", [])
		v_i_289 = J.num(v_i_289) + 1.0
	J.sp(v_ctx_281, "strokeStyle", "#9b927a")
	var _t458 = J.mul(1.6, v_s_284)
	J.sp(v_ctx_281, "lineWidth", _t458)
	J.mc(v_ctx_281, "beginPath", [])
	J.mc(v_ctx_281, "moveTo", [J.sub(v_x_282, J.mul(9.0, v_s_284)), J.sub(v_y_283, J.mul(4.0, v_s_284))])
	J.mc(v_ctx_281, "lineTo", [J.add(v_x_282, J.mul(9.0, v_s_284)), J.sub(v_y_283, J.mul(4.0, v_s_284))])
	J.mc(v_ctx_281, "stroke", [])
	var _t459 = env["el"]
	J.cl(_t459, null, [v_ctx_281, v_x_282, v_hy_288, J.mul(12.0, v_s_284), J.mul(12.5, v_s_284), "#f1efe8", env["OUT"], J.mul(1.8, v_s_284)])
	var _t460 = env["el"]
	J.cl(_t460, null, [v_ctx_281, v_x_282, J.add(v_hy_288, J.mul(2.0, v_s_284)), J.mul(7.5, v_s_284), J.mul(8.0, v_s_284), "#cfd6c9", env["OUT"], J.mul(1.0, v_s_284)])
	if (not J.t(J.gp(v_o_285, "untied"))):
		var _t461 = env["poly"]
		J.cl(_t461, null, [v_ctx_281, [v_x_282, J.sub(v_hy_288, J.mul(12.0, v_s_284)), J.sub(v_x_282, J.mul(5.0, v_s_284)), J.sub(v_hy_288, J.mul(20.0, v_s_284)), J.add(v_x_282, J.mul(1.0, v_s_284)), J.sub(v_hy_288, J.mul(16.0, v_s_284))], "#f1efe8", env["OUT"], J.mul(1.2, v_s_284)])
		var _t462 = env["poly"]
		J.cl(_t462, null, [v_ctx_281, [v_x_282, J.sub(v_hy_288, J.mul(12.0, v_s_284)), J.add(v_x_282, J.mul(6.0, v_s_284)), J.sub(v_hy_288, J.mul(20.0, v_s_284)), J.add(v_x_282, J.mul(1.0, v_s_284)), J.sub(v_hy_288, J.mul(16.0, v_s_284))], "#f1efe8", env["OUT"], J.mul(1.2, v_s_284)])
	else:
		var _t463 = env["el"]
		J.cl(_t463, null, [v_ctx_281, v_x_282, J.sub(v_hy_288, J.mul(12.0, v_s_284)), J.mul(3.0, v_s_284), J.mul(2.0, v_s_284), "#f1efe8", env["OUT"], J.mul(1.0, v_s_284)])
		var _t464 = env["arm"]
		J.cl(_t464, null, [v_ctx_281, J.add(v_x_282, J.mul(9.0, v_s_284)), J.sub(v_y_283, J.mul(20.0, v_s_284)), J.add(v_x_282, J.mul(14.0, v_s_284)), J.sub(v_y_283, J.mul(34.0, v_s_284)), v_s_284, "#f1efe8"])
	var _t465 = env["eyes"]
	J.cl(_t465, null, [v_ctx_281, v_x_282, J.add(v_hy_288, J.mul(2.5, v_s_284)), J.mul(v_s_284, 0.8), ("red" if J.t(J.gp(v_o_285, "enemy")) else "dot")])
	var _t466 = env["mouth"]
	J.cl(_t466, null, [v_ctx_281, v_x_282, J.sub(v_hy_288, J.mul(0.5, v_s_284)), J.mul(v_s_284, 0.8), "open"])

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
		var _t467 = J.gp(["#e0607a", "#c84466", "#f08aa0", "#b8385a"], v_i_299)
		J.sp(v_ctx_292, "strokeStyle", _t467)
		var _t468 = J.mul(3.0, v_s_295)
		J.sp(v_ctx_292, "lineWidth", _t468)
		J.sp(v_ctx_292, "lineCap", "round")
		J.mc(v_ctx_292, "beginPath", [])
		v_bx_300 = (J.sub(v_x_293, J.mul(6.0, v_s_295)) + J.mul(J.mul(v_i_299, 4.0), v_s_295))
		J.mc(v_ctx_292, "moveTo", [v_bx_300, J.add(v_hy_298, J.mul(8.0, v_s_295))])
		J.mc(v_ctx_292, "bezierCurveTo", [J.add(v_bx_300, J.mul((sin(J.num(J.add(J.mul(v_t_297, 3.0), v_i_299))) * 5.0), v_s_295)), J.add(v_hy_298, J.mul(18.0, v_s_295)), J.sub(v_bx_300, J.mul((sin(J.num(J.add(J.mul(v_t_297, 3.0), v_i_299))) * 5.0), v_s_295)), J.add(v_hy_298, J.mul(26.0, v_s_295)), J.add(v_bx_300, J.mul((sin(J.num(J.add(J.mul(v_t_297, 2.0), v_i_299))) * 3.0), v_s_295)), J.add(v_hy_298, J.mul(34.0, v_s_295))])
		J.mc(v_ctx_292, "stroke", [])
		v_i_299 = J.num(v_i_299) + 1.0
	var _t469 = env["el"]
	J.cl(_t469, null, [v_ctx_292, v_x_293, v_hy_298, J.mul(13.0, v_s_295), J.mul(12.5, v_s_295), "#e8d4c4", env["OUT"], J.mul(1.8, v_s_295)])
	J.sp(v_ctx_292, "fillStyle", "#1b0f14")
	J.mc(v_ctx_292, "beginPath", [])
	J.mc(v_ctx_292, "ellipse", [v_x_293, J.sub(v_hy_298, J.mul(3.0, v_s_295)), J.mul(14.0, v_s_295), J.mul(11.0, v_s_295), 0.0, PI, env["TAU"]])
	J.mc(v_ctx_292, "fill", [])
	v_i_301 = (-3.0)
	while true:
		if not J.cmp(v_i_301, 3.0, "<="): break
		J.sp(v_ctx_292, "strokeStyle", "#1b0f14")
		var _t470 = J.mul(2.5, v_s_295)
		J.sp(v_ctx_292, "lineWidth", _t470)
		J.mc(v_ctx_292, "beginPath", [])
		J.mc(v_ctx_292, "moveTo", [J.add(v_x_293, J.mul(J.mul(v_i_301, 4.0), v_s_295)), J.sub(v_hy_298, J.mul(6.0, v_s_295))])
		J.mc(v_ctx_292, "quadraticCurveTo", [J.add(J.add(v_x_293, J.mul(J.mul(v_i_301, 6.0), v_s_295)), J.mul((sin(J.num(J.add(J.mul(v_t_297, 4.0), v_i_301))) * 3.0), v_s_295)), J.sub(v_hy_298, J.mul(16.0, v_s_295)), J.add(v_x_293, J.mul(J.mul(v_i_301, 7.0), v_s_295)), J.sub(v_hy_298, J.mul(22.0, v_s_295))])
		J.mc(v_ctx_292, "stroke", [])
		v_i_301 = J.num(v_i_301) + 1.0
	var _t471 = env["rr"]
	J.cl(_t471, null, [v_ctx_292, J.sub(v_x_293, J.mul(14.0, v_s_295)), J.sub(v_hy_298, J.mul(3.0, v_s_295)), J.mul(4.0, v_s_295), J.mul(10.0, v_s_295), J.mul(2.0, v_s_295), "#1b0f14"])
	var _t472 = env["rr"]
	J.cl(_t472, null, [v_ctx_292, J.add(v_x_293, J.mul(10.0, v_s_295)), J.sub(v_hy_298, J.mul(3.0, v_s_295)), J.mul(4.0, v_s_295), J.mul(10.0, v_s_295), J.mul(2.0, v_s_295), "#1b0f14"])
	var _t473 = env["eyes"]
	J.cl(_t473, null, [v_ctx_292, v_x_293, J.add(v_hy_298, J.mul(1.0, v_s_295)), v_s_295, ("red" if J.t(J.gp(v_o_296, "enemy")) else "normal")])
	var _t474 = env["mouth"]
	J.cl(_t474, null, [v_ctx_292, v_x_293, v_hy_298, v_s_295, ("fang" if J.t(J.gp(v_o_296, "enemy")) else "smile")])

func _f28(this_, a: Array, env):
	var v_ctx_304 = null; var v_x_305 = null; var v_y_306 = null; var v_s_307 = null; var v_o_308 = null; var v_t_309 = null; var v_hy_310 = null; var v_sw_311 = null
	v_ctx_304 = J.arg(a, 0)
	v_x_305 = J.arg(a, 1)
	v_y_306 = J.arg(a, 2)
	v_s_307 = J.arg(a, 3)
	v_o_308 = J.arg(a, 4)
	v_t_309 = J.gp(v_o_308, "t")
	v_hy_310 = J.sub(v_y_306, J.mul(32.0, v_s_307))
	var _t475 = env["wisp"]
	J.cl(_t475, null, [v_ctx_304, v_x_305, v_y_306, v_s_307, "#6b4a7a", v_t_309, 9.0])
	var _t476 = env["poly"]
	J.cl(_t476, null, [v_ctx_304, [J.sub(v_x_305, J.mul(11.0, v_s_307)), J.sub(v_y_306, J.mul(5.0, v_s_307)), J.add(v_x_305, J.mul(11.0, v_s_307)), J.sub(v_y_306, J.mul(5.0, v_s_307)), J.add(v_x_305, J.mul(8.0, v_s_307)), J.sub(v_y_306, J.mul(23.0, v_s_307)), J.sub(v_x_305, J.mul(8.0, v_s_307)), J.sub(v_y_306, J.mul(23.0, v_s_307))], "#6b4a7a", env["OUT"], J.mul(1.6, v_s_307)])
	var _t477 = env["rr"]
	J.cl(_t477, null, [v_ctx_304, J.sub(v_x_305, J.mul(8.0, v_s_307)), J.sub(v_y_306, J.mul(16.0, v_s_307)), J.mul(16.0, v_s_307), J.mul(11.0, v_s_307), J.mul(2.0, v_s_307), "#e9e1d2", env["OUT"], J.mul(1.0, v_s_307)])
	var _t478 = env["arm"]
	J.cl(_t478, null, [v_ctx_304, J.sub(v_x_305, J.mul(8.0, v_s_307)), J.sub(v_y_306, J.mul(20.0, v_s_307)), J.sub(v_x_305, J.mul(12.0, v_s_307)), J.sub(v_y_306, J.mul(12.0, v_s_307)), v_s_307, "#6b4a7a"])
	v_sw_311 = (J.mul((sin(J.num(J.mul(v_t_309, 8.0))) * 3.0), v_s_307) if J.t(J.gp(v_o_308, "work")) else 0.0)
	var _t479 = env["arm"]
	J.cl(_t479, null, [v_ctx_304, J.add(v_x_305, J.mul(8.0, v_s_307)), J.sub(v_y_306, J.mul(20.0, v_s_307)), J.add(v_x_305, J.mul(13.0, v_s_307)), J.add(J.sub(v_y_306, J.mul(16.0, v_s_307)), v_sw_311), v_s_307, "#6b4a7a"])
	var _t480 = env["el"]
	J.cl(_t480, null, [v_ctx_304, J.add(v_x_305, J.mul(15.0, v_s_307)), J.add(J.sub(v_y_306, J.mul(13.0, v_s_307)), v_sw_311), J.mul(5.0, v_s_307), J.mul(3.0, v_s_307), "#c9b38a", env["OUT"], J.mul(1.0, v_s_307)])
	var _t481 = env["el"]
	J.cl(_t481, null, [v_ctx_304, J.add(v_x_305, J.mul(15.0, v_s_307)), J.add(J.sub(v_y_306, J.mul(14.0, v_s_307)), v_sw_311), J.mul(3.5, v_s_307), J.mul(1.4, v_s_307), "#7a6a9a"])
	var _t482 = env["el"]
	J.cl(_t482, null, [v_ctx_304, v_x_305, v_hy_310, J.mul(12.5, v_s_307), J.mul(12.0, v_s_307), "#e8d8c8", env["OUT"], J.mul(1.8, v_s_307)])
	J.sp(v_ctx_304, "fillStyle", "#d8d8d8")
	J.mc(v_ctx_304, "beginPath", [])
	J.mc(v_ctx_304, "ellipse", [v_x_305, J.sub(v_hy_310, J.mul(4.0, v_s_307)), J.mul(13.0, v_s_307), J.mul(9.0, v_s_307), 0.0, PI, env["TAU"]])
	J.mc(v_ctx_304, "fill", [])
	var _t483 = env["el"]
	J.cl(_t483, null, [v_ctx_304, v_x_305, J.sub(v_hy_310, J.mul(13.0, v_s_307)), J.mul(6.0, v_s_307), J.mul(5.0, v_s_307), "#d8d8d8", env["OUT"], J.mul(1.0, v_s_307)])
	J.sp(v_ctx_304, "fillStyle", "#c33")
	J.mc(v_ctx_304, "fillRect", [J.sub(v_x_305, J.mul(1.0, v_s_307)), J.sub(v_hy_310, J.mul(18.0, v_s_307)), J.mul(2.0, v_s_307), J.mul(6.0, v_s_307)])
	var _t484 = env["eyes"]
	J.cl(_t484, null, [v_ctx_304, v_x_305, J.add(v_hy_310, J.mul(1.0, v_s_307)), v_s_307, "closed"])
	var _t485 = env["mouth"]
	J.cl(_t485, null, [v_ctx_304, v_x_305, v_hy_310, v_s_307, "smile"])
	J.sp(v_ctx_304, "strokeStyle", "rgba(80,60,40,.5)")
	var _t486 = J.mul(0.8, v_s_307)
	J.sp(v_ctx_304, "lineWidth", _t486)
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
	var _t487 = env["wisp"]
	J.cl(_t487, null, [v_ctx_314, v_x_315, v_y_316, v_s_317, v_col_322, v_t_320, 10.0])
	var _t488 = env["poly"]
	J.cl(_t488, null, [v_ctx_314, [J.sub(v_x_315, J.mul(12.0, v_s_317)), J.sub(v_y_316, J.mul(5.0, v_s_317)), J.add(v_x_315, J.mul(12.0, v_s_317)), J.sub(v_y_316, J.mul(5.0, v_s_317)), J.add(v_x_315, J.mul(9.0, v_s_317)), J.sub(v_y_316, J.mul(26.0, v_s_317)), J.sub(v_x_315, J.mul(9.0, v_s_317)), J.sub(v_y_316, J.mul(26.0, v_s_317))], v_col_322, env["OUT"], J.mul(1.6, v_s_317)])
	var _t489 = env["arm"]
	J.cl(_t489, null, [v_ctx_314, J.sub(v_x_315, J.mul(8.0, v_s_317)), J.sub(v_y_316, J.mul(22.0, v_s_317)), J.sub(v_x_315, J.mul(13.0, v_s_317)), J.sub(v_y_316, J.mul(12.0, v_s_317)), v_s_317, v_col_322])
	var _t490 = env["arm"]
	J.cl(_t490, null, [v_ctx_314, J.add(v_x_315, J.mul(8.0, v_s_317)), J.sub(v_y_316, J.mul(22.0, v_s_317)), J.add(v_x_315, J.mul(14.0, v_s_317)), J.sub(v_y_316, J.mul(16.0, v_s_317)), v_s_317, v_col_322])
	if J.t(v_white_319):
		var _t491 = env["rr"]
		J.cl(_t491, null, [v_ctx_314, J.add(v_x_315, J.mul(13.0, v_s_317)), J.sub(v_y_316, J.mul(34.0, v_s_317)), J.mul(2.0, v_s_317), J.mul(24.0, v_s_317), J.mul(1.0, v_s_317), "#8a6a3a", env["OUT"], J.mul(0.8, v_s_317)])
		var _t492 = env["el"]
		J.cl(_t492, null, [v_ctx_314, J.add(v_x_315, J.mul(14.0, v_s_317)), J.sub(v_y_316, J.mul(35.0, v_s_317)), J.mul(5.0, v_s_317), J.mul(4.0, v_s_317), "#f8f8ff", env["OUT"], J.mul(1.0, v_s_317)])
	else:
		J.sp(v_ctx_314, "strokeStyle", "#8890a0")
		var _t493 = J.mul(2.0, v_s_317)
		J.sp(v_ctx_314, "lineWidth", _t493)
		J.mc(v_ctx_314, "setLineDash", [[J.mul(2.5, v_s_317), J.mul(1.5, v_s_317)]])
		J.mc(v_ctx_314, "beginPath", [])
		J.mc(v_ctx_314, "moveTo", [J.add(v_x_315, J.mul(14.0, v_s_317)), J.sub(v_y_316, J.mul(16.0, v_s_317))])
		J.mc(v_ctx_314, "quadraticCurveTo", [J.add(v_x_315, J.mul(20.0, v_s_317)), J.sub(v_y_316, J.mul(6.0, v_s_317)), J.add(v_x_315, J.mul(12.0, v_s_317)), J.sub(v_y_316, J.mul(2.0, v_s_317))])
		J.mc(v_ctx_314, "stroke", [])
		J.mc(v_ctx_314, "setLineDash", [[]])
	var _t494 = env["el"]
	J.cl(_t494, null, [v_ctx_314, v_x_315, v_hy_321, J.mul(12.5, v_s_317), J.mul(12.0, v_s_317), v_skin_323, env["OUT"], J.mul(1.8, v_s_317)])
	var _t495 = env["poly"]
	J.cl(_t495, null, [v_ctx_314, [J.sub(v_x_315, J.mul(10.0, v_s_317)), J.sub(v_hy_321, J.mul(8.0, v_s_317)), J.add(v_x_315, J.mul(10.0, v_s_317)), J.sub(v_hy_321, J.mul(8.0, v_s_317)), J.add(v_x_315, J.mul(5.0, v_s_317)), J.sub(v_hy_321, J.mul(36.0, v_s_317)), J.sub(v_x_315, J.mul(5.0, v_s_317)), J.sub(v_hy_321, J.mul(36.0, v_s_317))], v_col_322, env["OUT"], J.mul(1.6, v_s_317)])
	J.mc(v_ctx_314, "save", [])
	var _t496 = ("#c41a2a" if J.t(v_white_319) else "#e8e8f0")
	J.sp(v_ctx_314, "fillStyle", _t496)
	var _t497 = ("bold " + J.str(J.mul(5.2, v_s_317)) + "px \"PingFang TC\",\"Noto Sans TC\",sans-serif")
	J.sp(v_ctx_314, "font", _t497)
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
		var _t498 = env["eyes"]
		J.cl(_t498, null, [v_ctx_314, v_x_315, J.add(v_hy_321, J.mul(2.0, v_s_317)), v_s_317, "closed"])
		var _t499 = env["poly"]
		J.cl(_t499, null, [v_ctx_314, [J.sub(v_x_315, J.mul(1.5, v_s_317)), J.add(v_hy_321, J.mul(6.0, v_s_317)), J.add(v_x_315, J.mul(1.5, v_s_317)), J.add(v_hy_321, J.mul(6.0, v_s_317)), J.add(v_x_315, J.mul(1.0, v_s_317)), J.add(v_hy_321, J.mul(16.0, v_s_317)), J.sub(v_x_315, J.mul(1.0, v_s_317)), J.add(v_hy_321, J.mul(16.0, v_s_317))], "#d22", env["OUT"], J.mul(0.8, v_s_317)])
	else:
		var _t500 = env["eyes"]
		J.cl(_t500, null, [v_ctx_314, v_x_315, J.add(v_hy_321, J.mul(2.0, v_s_317)), v_s_317, "angry"])
		var _t501 = env["mouth"]
		J.cl(_t501, null, [v_ctx_314, v_x_315, J.add(v_hy_321, J.mul(1.0, v_s_317)), v_s_317, "flat"])

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
	var _t502 = env["wisp"]
	J.cl(_t502, null, [v_ctx_342, v_x_343, v_y_344, v_s_345, "#7a4a32", v_t_347, 10.0])
	var _t503 = env["body"]
	J.cl(_t503, null, [v_ctx_342, v_x_343, J.sub(v_y_344, J.mul(5.0, v_s_345)), J.mul(v_s_345, 1.15), "#7a4a32"])
	var _t504 = env["rr"]
	J.cl(_t504, null, [v_ctx_342, J.sub(v_x_343, J.mul(9.0, v_s_345)), J.sub(v_y_344, J.mul(20.0, v_s_345)), J.mul(18.0, v_s_345), J.mul(8.0, v_s_345), J.mul(2.0, v_s_345), "#9a9aa8", env["OUT"], J.mul(1.0, v_s_345)])
	var _t505 = env["arm"]
	J.cl(_t505, null, [v_ctx_342, J.sub(v_x_343, J.mul(10.0, v_s_345)), J.sub(v_y_344, J.mul(20.0, v_s_345)), J.sub(v_x_343, J.mul(15.0, v_s_345)), J.sub(v_y_344, J.mul(10.0, v_s_345)), J.mul(v_s_345, 1.2), "#7a4a32"])
	var _t506 = env["arm"]
	J.cl(_t506, null, [v_ctx_342, J.add(v_x_343, J.mul(10.0, v_s_345)), J.sub(v_y_344, J.mul(20.0, v_s_345)), J.add(v_x_343, J.mul(16.0, v_s_345)), J.sub(v_y_344, J.mul(13.0, v_s_345)), J.mul(v_s_345, 1.2), "#7a4a32"])
	var _t507 = env["rr"]
	J.cl(_t507, null, [v_ctx_342, J.add(v_x_343, J.mul(15.0, v_s_345)), J.sub(v_y_344, J.mul(40.0, v_s_345)), J.mul(2.5, v_s_345), J.mul(34.0, v_s_345), J.mul(1.0, v_s_345), "#5a3a1a", env["OUT"], J.mul(0.8, v_s_345)])
	var _t508 = env["poly"]
	J.cl(_t508, null, [v_ctx_342, [J.add(v_x_343, J.mul(16.0, v_s_345)), J.sub(v_y_344, J.mul(46.0, v_s_345)), J.add(v_x_343, J.mul(21.0, v_s_345)), J.sub(v_y_344, J.mul(38.0, v_s_345)), J.add(v_x_343, J.mul(11.0, v_s_345)), J.sub(v_y_344, J.mul(38.0, v_s_345))], "#bfc8d6", env["OUT"], J.mul(1.0, v_s_345)])
	var _t509 = env["el"]
	J.cl(_t509, null, [v_ctx_342, v_x_343, v_hy_348, J.mul(14.0, v_s_345), J.mul(12.0, v_s_345), "#8a5a3c", env["OUT"], J.mul(1.8, v_s_345)])
	var _t510 = env["poly"]
	J.cl(_t510, null, [v_ctx_342, [J.sub(v_x_343, J.mul(12.0, v_s_345)), J.sub(v_hy_348, J.mul(6.0, v_s_345)), J.sub(v_x_343, J.mul(22.0, v_s_345)), J.sub(v_hy_348, J.mul(16.0, v_s_345)), J.sub(v_x_343, J.mul(9.0, v_s_345)), J.sub(v_hy_348, J.mul(10.0, v_s_345))], "#efe6cf", env["OUT"], J.mul(1.2, v_s_345)])
	var _t511 = env["poly"]
	J.cl(_t511, null, [v_ctx_342, [J.add(v_x_343, J.mul(12.0, v_s_345)), J.sub(v_hy_348, J.mul(6.0, v_s_345)), J.add(v_x_343, J.mul(22.0, v_s_345)), J.sub(v_hy_348, J.mul(16.0, v_s_345)), J.add(v_x_343, J.mul(9.0, v_s_345)), J.sub(v_hy_348, J.mul(10.0, v_s_345))], "#efe6cf", env["OUT"], J.mul(1.2, v_s_345)])
	var _t512 = env["el"]
	J.cl(_t512, null, [v_ctx_342, v_x_343, J.add(v_hy_348, J.mul(6.0, v_s_345)), J.mul(8.0, v_s_345), J.mul(5.0, v_s_345), "#c09078", env["OUT"], J.mul(1.0, v_s_345)])
	var _t513 = env["el"]
	J.cl(_t513, null, [v_ctx_342, J.sub(v_x_343, J.mul(3.0, v_s_345)), J.add(v_hy_348, J.mul(6.0, v_s_345)), J.mul(1.2, v_s_345), J.mul(1.5, v_s_345), env["OUT"]])
	var _t514 = env["el"]
	J.cl(_t514, null, [v_ctx_342, J.add(v_x_343, J.mul(3.0, v_s_345)), J.add(v_hy_348, J.mul(6.0, v_s_345)), J.mul(1.2, v_s_345), J.mul(1.5, v_s_345), env["OUT"]])
	var _t515 = env["el"]
	J.cl(_t515, null, [v_ctx_342, v_x_343, J.add(v_hy_348, J.mul(10.0, v_s_345)), J.mul(2.5, v_s_345), J.mul(1.5, v_s_345), null, "#e0c040", J.mul(1.0, v_s_345)])
	var _t516 = env["eyes"]
	J.cl(_t516, null, [v_ctx_342, v_x_343, J.sub(v_hy_348, J.mul(3.0, v_s_345)), v_s_345, "angry"])

func _f33(this_, a: Array, env):
	var v_ctx_351 = null; var v_x_352 = null; var v_y_353 = null; var v_s_354 = null; var v_o_355 = null; var v_t_356 = null; var v_hy_357 = null; var v_i_358 = null
	v_ctx_351 = J.arg(a, 0)
	v_x_352 = J.arg(a, 1)
	v_y_353 = J.arg(a, 2)
	v_s_354 = J.arg(a, 3)
	v_o_355 = J.arg(a, 4)
	v_t_356 = J.gp(v_o_355, "t")
	v_hy_357 = J.sub(v_y_353, J.mul(36.0, v_s_354))
	var _t517 = env["wisp"]
	J.cl(_t517, null, [v_ctx_351, v_x_352, v_y_353, v_s_354, "#3c4a6a", v_t_356, 10.0])
	var _t518 = env["body"]
	J.cl(_t518, null, [v_ctx_351, v_x_352, J.sub(v_y_353, J.mul(5.0, v_s_354)), J.mul(v_s_354, 1.1), "#3c4a6a"])
	var _t519 = env["rr"]
	J.cl(_t519, null, [v_ctx_351, J.sub(v_x_352, J.mul(9.0, v_s_354)), J.sub(v_y_353, J.mul(20.0, v_s_354)), J.mul(18.0, v_s_354), J.mul(8.0, v_s_354), J.mul(2.0, v_s_354), "#9a9aa8", env["OUT"], J.mul(1.0, v_s_354)])
	var _t520 = env["arm"]
	J.cl(_t520, null, [v_ctx_351, J.sub(v_x_352, J.mul(10.0, v_s_354)), J.sub(v_y_353, J.mul(20.0, v_s_354)), J.sub(v_x_352, J.mul(15.0, v_s_354)), J.sub(v_y_353, J.mul(10.0, v_s_354)), J.mul(v_s_354, 1.2), "#3c4a6a"])
	var _t521 = env["arm"]
	J.cl(_t521, null, [v_ctx_351, J.add(v_x_352, J.mul(10.0, v_s_354)), J.sub(v_y_353, J.mul(20.0, v_s_354)), J.add(v_x_352, J.mul(16.0, v_s_354)), J.sub(v_y_353, J.mul(13.0, v_s_354)), J.mul(v_s_354, 1.2), "#3c4a6a"])
	var _t522 = env["rr"]
	J.cl(_t522, null, [v_ctx_351, J.add(v_x_352, J.mul(15.0, v_s_354)), J.sub(v_y_353, J.mul(42.0, v_s_354)), J.mul(2.5, v_s_354), J.mul(36.0, v_s_354), J.mul(1.0, v_s_354), "#5a3a1a", env["OUT"], J.mul(0.8, v_s_354)])
	var _t523 = env["poly"]
	J.cl(_t523, null, [v_ctx_351, [J.add(v_x_352, J.mul(13.0, v_s_354)), J.sub(v_y_353, J.mul(42.0, v_s_354)), J.add(v_x_352, J.mul(22.0, v_s_354)), J.sub(v_y_353, J.mul(46.0, v_s_354)), J.add(v_x_352, J.mul(20.0, v_s_354)), J.sub(v_y_353, J.mul(38.0, v_s_354))], "#bfc8d6", env["OUT"], J.mul(1.0, v_s_354)])
	var _t524 = env["el"]
	J.cl(_t524, null, [v_ctx_351, v_x_352, v_hy_357, J.mul(11.0, v_s_354), J.mul(13.0, v_s_354), "#e8e0d8", env["OUT"], J.mul(1.8, v_s_354)])
	var _t525 = env["el"]
	J.cl(_t525, null, [v_ctx_351, v_x_352, J.add(v_hy_357, J.mul(9.0, v_s_354)), J.mul(8.0, v_s_354), J.mul(6.0, v_s_354), "#d0c4b8", env["OUT"], J.mul(1.2, v_s_354)])
	var _t526 = env["el"]
	J.cl(_t526, null, [v_ctx_351, J.sub(v_x_352, J.mul(3.0, v_s_354)), J.add(v_hy_357, J.mul(9.0, v_s_354)), J.mul(1.2, v_s_354), J.mul(1.6, v_s_354), env["OUT"]])
	var _t527 = env["el"]
	J.cl(_t527, null, [v_ctx_351, J.add(v_x_352, J.mul(3.0, v_s_354)), J.add(v_hy_357, J.mul(9.0, v_s_354)), J.mul(1.2, v_s_354), J.mul(1.6, v_s_354), env["OUT"]])
	var _t528 = env["poly"]
	J.cl(_t528, null, [v_ctx_351, [J.sub(v_x_352, J.mul(8.0, v_s_354)), J.sub(v_hy_357, J.mul(9.0, v_s_354)), J.sub(v_x_352, J.mul(10.0, v_s_354)), J.sub(v_hy_357, J.mul(19.0, v_s_354)), J.sub(v_x_352, J.mul(3.0, v_s_354)), J.sub(v_hy_357, J.mul(12.0, v_s_354))], "#e8e0d8", env["OUT"], J.mul(1.2, v_s_354)])
	var _t529 = env["poly"]
	J.cl(_t529, null, [v_ctx_351, [J.add(v_x_352, J.mul(8.0, v_s_354)), J.sub(v_hy_357, J.mul(9.0, v_s_354)), J.add(v_x_352, J.mul(10.0, v_s_354)), J.sub(v_hy_357, J.mul(19.0, v_s_354)), J.add(v_x_352, J.mul(3.0, v_s_354)), J.sub(v_hy_357, J.mul(12.0, v_s_354))], "#e8e0d8", env["OUT"], J.mul(1.2, v_s_354)])
	J.sp(v_ctx_351, "fillStyle", "#2a2a3a")
	v_i_358 = 0.0
	while true:
		if not J.cmp(v_i_358, 4.0, "<"): break
		var _t530 = env["rr"]
		J.cl(_t530, null, [v_ctx_351, J.sub(v_x_352, J.mul(2.0, v_s_354)), (J.sub(v_hy_357, J.mul(14.0, v_s_354)) + J.mul(J.mul(v_i_358, 4.0), v_s_354)), (J.mul(4.0, v_s_354) + J.mul(J.mul(v_i_358, 0.5), v_s_354)), J.mul(4.0, v_s_354), J.mul(1.0, v_s_354), "#2a2a3a"])
		v_i_358 = J.num(v_i_358) + 1.0
	var _t531 = env["eyes"]
	J.cl(_t531, null, [v_ctx_351, v_x_352, J.sub(v_hy_357, J.mul(2.0, v_s_354)), J.mul(v_s_354, 0.9), "angry"])

func _f34(this_, a: Array, env):
	var v_ctx_361 = null; var v_x_362 = null; var v_y_363 = null; var v_s_364 = null; var v_o_365 = null; var v_t_366 = null; var v_hy_367 = null; var v_sw_368 = null; var v_i_369 = null
	v_ctx_361 = J.arg(a, 0)
	v_x_362 = J.arg(a, 1)
	v_y_363 = J.arg(a, 2)
	v_s_364 = J.arg(a, 3)
	v_o_365 = J.arg(a, 4)
	v_t_366 = J.gp(v_o_365, "t")
	v_hy_367 = J.sub(v_y_363, J.mul(40.0, v_s_364))
	var _t532 = env["wisp"]
	J.cl(_t532, null, [v_ctx_361, v_x_362, v_y_363, v_s_364, "#2a2f48", v_t_366, 11.0])
	var _t533 = env["el"]
	J.cl(_t533, null, [v_ctx_361, v_x_362, J.sub(v_y_363, J.mul(16.0, v_s_364)), J.mul(16.0, v_s_364), J.mul(13.0, v_s_364), "#2a2f48", env["OUT"], J.mul(1.8, v_s_364)])
	var _t534 = env["poly"]
	J.cl(_t534, null, [v_ctx_361, [J.sub(v_x_362, J.mul(4.0, v_s_364)), J.sub(v_y_363, J.mul(28.0, v_s_364)), J.add(v_x_362, J.mul(4.0, v_s_364)), J.sub(v_y_363, J.mul(28.0, v_s_364)), v_x_362, J.sub(v_y_363, J.mul(16.0, v_s_364))], "#f2f2f2"])
	var _t535 = env["poly"]
	J.cl(_t535, null, [v_ctx_361, [J.sub(v_x_362, J.mul(1.5, v_s_364)), J.sub(v_y_363, J.mul(27.0, v_s_364)), J.add(v_x_362, J.mul(1.5, v_s_364)), J.sub(v_y_363, J.mul(27.0, v_s_364)), J.add(v_x_362, J.mul(2.0, v_s_364)), J.sub(v_y_363, J.mul(17.0, v_s_364)), J.sub(v_x_362, J.mul(2.0, v_s_364)), J.sub(v_y_363, J.mul(17.0, v_s_364))], "#c4a020", env["OUT"], J.mul(0.8, v_s_364)])
	var _t536 = env["arm"]
	J.cl(_t536, null, [v_ctx_361, J.sub(v_x_362, J.mul(14.0, v_s_364)), J.sub(v_y_363, J.mul(22.0, v_s_364)), J.sub(v_x_362, J.mul(18.0, v_s_364)), J.sub(v_y_363, J.mul(12.0, v_s_364)), J.mul(v_s_364, 1.2), "#2a2f48"])
	var _t537 = env["el"]
	J.cl(_t537, null, [v_ctx_361, J.sub(v_x_362, J.mul(18.0, v_s_364)), J.sub(v_y_363, J.mul(13.0, v_s_364)), J.mul(2.5, v_s_364), J.mul(1.6, v_s_364), "#e0b030"])
	v_sw_368 = ((-1.2) if J.t(J.gp(v_o_365, "atk")) else (sin(J.num(J.mul(v_t_366, 2.0))) * 0.2))
	var _t538 = env["arm"]
	J.cl(_t538, null, [v_ctx_361, J.add(v_x_362, J.mul(14.0, v_s_364)), J.sub(v_y_363, J.mul(22.0, v_s_364)), J.add(v_x_362, J.mul(19.0, v_s_364)), J.sub(v_y_363, J.mul(14.0, v_s_364)), J.mul(v_s_364, 1.2), "#2a2f48"])
	J.mc(v_ctx_361, "save", [])
	J.mc(v_ctx_361, "translate", [J.add(v_x_362, J.mul(19.0, v_s_364)), J.sub(v_y_363, J.mul(14.0, v_s_364))])
	J.mc(v_ctx_361, "rotate", [v_sw_368])
	var _t539 = env["rr"]
	J.cl(_t539, null, [v_ctx_361, J.mul((-1.0), v_s_364), J.mul((-24.0), v_s_364), J.mul(2.0, v_s_364), J.mul(24.0, v_s_364), J.mul(1.0, v_s_364), "#c8ccd8", env["OUT"], J.mul(0.8, v_s_364)])
	var _t540 = env["rr"]
	J.cl(_t540, null, [v_ctx_361, J.mul((-2.0), v_s_364), J.mul((-27.0), v_s_364), J.mul(8.0, v_s_364), J.mul(4.0, v_s_364), J.mul(1.5, v_s_364), "#9aa0b0", env["OUT"], J.mul(0.8, v_s_364)])
	J.mc(v_ctx_361, "restore", [])
	var _t541 = env["el"]
	J.cl(_t541, null, [v_ctx_361, v_x_362, v_hy_367, J.mul(14.0, v_s_364), J.mul(13.0, v_s_364), "#d8c0a8", env["OUT"], J.mul(1.8, v_s_364)])
	J.sp(v_ctx_361, "fillStyle", "#2a2a2a")
	J.mc(v_ctx_361, "beginPath", [])
	J.mc(v_ctx_361, "ellipse", [v_x_362, J.sub(v_hy_367, J.mul(7.0, v_s_364)), J.mul(14.0, v_s_364), J.mul(6.0, v_s_364), 0.0, PI, env["TAU"]])
	J.mc(v_ctx_361, "fill", [])
	J.sp(v_ctx_361, "strokeStyle", "#2a2a2a")
	var _t542 = J.mul(1.5, v_s_364)
	J.sp(v_ctx_361, "lineWidth", _t542)
	v_i_369 = (-2.0)
	while true:
		if not J.cmp(v_i_369, 2.0, "<="): break
		J.mc(v_ctx_361, "beginPath", [])
		J.mc(v_ctx_361, "moveTo", [J.sub(v_x_362, J.mul(10.0, v_s_364)), J.add(J.sub(v_hy_367, J.mul(9.0, v_s_364)), v_i_369)])
		J.mc(v_ctx_361, "quadraticCurveTo", [v_x_362, J.sub(v_hy_367, J.mul(14.0, v_s_364)), J.add(v_x_362, J.mul(11.0, v_s_364)), J.add(J.sub(v_hy_367, J.mul(8.0, v_s_364)), v_i_369)])
		J.mc(v_ctx_361, "stroke", [])
		v_i_369 = J.num(v_i_369) + 1.0
	var _t543 = env["rr"]
	J.cl(_t543, null, [v_ctx_361, J.sub(v_x_362, J.mul(10.0, v_s_364)), J.sub(v_hy_367, J.mul(2.0, v_s_364)), J.mul(8.0, v_s_364), J.mul(5.0, v_s_364), J.mul(1.5, v_s_364), "rgba(20,20,30,.85)", "#c4a020", J.mul(1.0, v_s_364)])
	var _t544 = env["rr"]
	J.cl(_t544, null, [v_ctx_361, J.add(v_x_362, J.mul(2.0, v_s_364)), J.sub(v_hy_367, J.mul(2.0, v_s_364)), J.mul(8.0, v_s_364), J.mul(5.0, v_s_364), J.mul(1.5, v_s_364), "rgba(20,20,30,.85)", "#c4a020", J.mul(1.0, v_s_364)])
	var _t545 = env["mouth"]
	J.cl(_t545, null, [v_ctx_361, v_x_362, J.add(v_hy_367, J.mul(1.0, v_s_364)), v_s_364, ("open" if J.t(J.gp(v_o_365, "enemy")) else "smile")])
	var _t546 = env["el"]
	J.cl(_t546, null, [v_ctx_361, J.sub(v_x_362, J.mul(10.0, v_s_364)), J.add(v_hy_367, J.mul(6.0, v_s_364)), J.mul(3.0, v_s_364), J.mul(2.0, v_s_364), "rgba(255,120,120,.35)"])
	var _t547 = env["el"]
	J.cl(_t547, null, [v_ctx_361, J.add(v_x_362, J.mul(10.0, v_s_364)), J.add(v_hy_367, J.mul(6.0, v_s_364)), J.mul(3.0, v_s_364), J.mul(2.0, v_s_364), "rgba(255,120,120,.35)"])

func _f35(this_, a: Array, env):
	var v_type_370 = null
	v_type_370 = J.arg(a, 0)
	return ("afu_body" if J.seq(v_type_370, "afu") else v_type_370)

func _f36(this_, a: Array, env):
	var v_type_371 = null
	v_type_371 = J.arg(a, 0)
	var _t548 = J.seq(J.typeof_(J.G.get("sprOk")), "function")
	var _t551 = (J.gp(env["CHAR_H"], v_type_371) if _t548 else _t548)
	if J.t(_t551):
		var _t549 = J.G.get("sprOk")
		var _t550 = env["sprKey"]
		_t551 = J.cl(_t549, null, [J.cl(_t550, null, [v_type_371])])
	return _t551

func _f53(this_, a: Array, env):
	var v_ctx_547 = null; var v_x_548 = null; var v_y_549 = null; var v_lv_550 = null; var v_t_551 = null; var v_i_552 = null
	v_ctx_547 = J.arg(a, 0)
	v_x_548 = J.arg(a, 1)
	v_y_549 = J.arg(a, 2)
	v_lv_550 = J.arg(a, 3)
	v_t_551 = J.arg(a, 4)
	var _t552 = env["el"]
	J.cl(_t552, null, [v_ctx_547, v_x_548, J.add(v_y_549, 4.0), 70.0, 12.0, "rgba(0,0,0,.3)"])
	var _t553 = env["rr"]
	J.cl(_t553, null, [v_ctx_547, J.sub(v_x_548, 64.0), J.sub(v_y_549, 6.0), 128.0, 12.0, 3.0, "#4a4458", env["OUT"], 2.0])
	var _t554 = env["house"]
	J.cl(_t554, null, [v_ctx_547, v_x_548, J.sub(v_y_549, 6.0), 104.0, 46.0, "#5c3b3b"])
	v_i_552 = 0.0
	while true:
		if not J.cmp(v_i_552, 4.0, "<"): break
		var _t555 = env["rr"]
		J.cl(_t555, null, [v_ctx_547, (J.sub(v_x_548, 48.0) + J.mul(v_i_552, 30.0)), J.sub(v_y_549, 50.0), 6.0, 44.0, 2.0, "#8a2a2a", env["OUT"], 1.2])
		v_i_552 = J.num(v_i_552) + 1.0
	var _t556 = env["rr"]
	J.cl(_t556, null, [v_ctx_547, J.sub(v_x_548, 14.0), J.sub(v_y_549, 38.0), 28.0, 32.0, 3.0, "#26161a", env["OUT"], 1.5])
	var _t557 = env["el"]
	J.cl(_t557, null, [v_ctx_547, J.sub(v_x_548, 5.0), J.sub(v_y_549, 22.0), 1.8, 1.8, "#d9a84a"])
	var _t558 = env["el"]
	J.cl(_t558, null, [v_ctx_547, J.add(v_x_548, 5.0), J.sub(v_y_549, 22.0), 1.8, 1.8, "#d9a84a"])
	var _t559 = env["roof"]
	J.cl(_t559, null, [v_ctx_547, v_x_548, J.sub(v_y_549, 82.0), 120.0, 30.0, "#2e2a40"])
	var _t560 = env["roof"]
	J.cl(_t560, null, [v_ctx_547, v_x_548, J.sub(v_y_549, 102.0), 70.0, 22.0, "#2e2a40"])
	var _t561 = env["lantern"]
	J.cl(_t561, null, [v_ctx_547, J.sub(v_x_548, 36.0), J.sub(v_y_549, 50.0), v_t_551])
	var _t562 = env["lantern"]
	J.cl(_t562, null, [v_ctx_547, J.add(v_x_548, 36.0), J.sub(v_y_549, 50.0), v_t_551])
	var _t563 = env["plaque"]
	J.cl(_t563, null, [v_ctx_547, v_x_548, J.sub(v_y_549, 62.0), "鬼宅", v_lv_550])

func _f54(this_, a: Array, env):
	var v_ctx_555 = null; var v_x_556 = null; var v_y_557 = null; var v_lv_558 = null; var v_t_559 = null; var v_i_560 = null; var v_j_561 = null
	v_ctx_555 = J.arg(a, 0)
	v_x_556 = J.arg(a, 1)
	v_y_557 = J.arg(a, 2)
	v_lv_558 = J.arg(a, 3)
	v_t_559 = J.arg(a, 4)
	var _t564 = env["el"]
	J.cl(_t564, null, [v_ctx_555, v_x_556, J.add(v_y_557, 3.0), 40.0, 8.0, "rgba(0,0,0,.3)"])
	v_i_560 = 0.0
	while true:
		if not J.cmp(v_i_560, 3.0, "<"): break
		v_j_561 = 0.0
		while true:
			if not J.cmp(v_j_561, J.sub(3.0, v_i_560), "<"): break
			var _t565 = env["el"]
			J.cl(_t565, null, [v_ctx_555, ((J.sub(v_x_556, 22.0) + J.mul(v_j_561, 11.0)) + J.mul(v_i_560, 5.5)), (J.sub(v_y_557, 5.0) - J.mul(v_i_560, 9.0)), 6.0, 5.0, "#7a5230", env["OUT"], 1.2])
			var _t566 = env["el"]
			J.cl(_t566, null, [v_ctx_555, ((J.sub(v_x_556, 22.0) + J.mul(v_j_561, 11.0)) + J.mul(v_i_560, 5.5)), (J.sub(v_y_557, 5.0) - J.mul(v_i_560, 9.0)), 3.0, 2.5, "#b8875a"])
			v_j_561 = J.num(v_j_561) + 1.0
		v_i_560 = J.num(v_i_560) + 1.0
	var _t567 = env["rr"]
	J.cl(_t567, null, [v_ctx_555, J.add(v_x_556, 8.0), J.sub(v_y_557, 30.0), 30.0, 30.0, 2.0, "#5a4030", env["OUT"], 1.5])
	var _t568 = env["poly"]
	J.cl(_t568, null, [v_ctx_555, [J.add(v_x_556, 2.0), J.sub(v_y_557, 28.0), J.add(v_x_556, 23.0), J.sub(v_y_557, 46.0), J.add(v_x_556, 44.0), J.sub(v_y_557, 28.0)], "#3a3048", env["OUT"], 1.8])
	var _t569 = env["rr"]
	J.cl(_t569, null, [v_ctx_555, J.sub(v_x_556, 40.0), J.sub(v_y_557, 14.0), 14.0, 12.0, 2.0, "#8a6038", env["OUT"], 1.2])
	var _t570 = env["plaque"]
	J.cl(_t570, null, [v_ctx_555, v_x_556, J.sub(v_y_557, 54.0), "伐木場", v_lv_558])

func _f55(this_, a: Array, env):
	var v_ctx_564 = null; var v_x_565 = null; var v_y_566 = null; var v_lv_567 = null; var v_t_568 = null; var v_i_569 = null
	v_ctx_564 = J.arg(a, 0)
	v_x_565 = J.arg(a, 1)
	v_y_566 = J.arg(a, 2)
	v_lv_567 = J.arg(a, 3)
	v_t_568 = J.arg(a, 4)
	var _t571 = env["rr"]
	J.cl(_t571, null, [v_ctx_564, J.sub(v_x_565, 24.0), J.sub(v_y_566, 26.0), 48.0, 26.0, 2.0, "#4a3a2a", env["OUT"], 1.5])
	var _t572 = env["poly"]
	J.cl(_t572, null, [v_ctx_564, [J.sub(v_x_565, 30.0), J.sub(v_y_566, 24.0), v_x_565, J.sub(v_y_566, 44.0), J.add(v_x_565, 30.0), J.sub(v_y_566, 24.0)], "#7a6a3a", env["OUT"], 1.8])
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
	var _t573 = env["rr"]
	J.cl(_t573, null, [v_ctx_564, J.sub(v_x_565, 8.0), J.sub(v_y_566, 18.0), 16.0, 18.0, 2.0, "#2a1a10", env["OUT"], 1.0])
	var _t574 = env["plaque"]
	J.cl(_t574, null, [v_ctx_564, v_x_565, J.sub(v_y_566, 52.0), "糯米田", v_lv_567])

func _f56(this_, a: Array, env):
	var v_ctx_572 = null; var v_x_573 = null; var v_y_574 = null; var v_lv_575 = null; var v_t_576 = null
	v_ctx_572 = J.arg(a, 0)
	v_x_573 = J.arg(a, 1)
	v_y_574 = J.arg(a, 2)
	v_lv_575 = J.arg(a, 3)
	v_t_576 = J.arg(a, 4)
	var _t575 = env["el"]
	J.cl(_t575, null, [v_ctx_572, v_x_573, J.add(v_y_574, 4.0), 48.0, 9.0, "rgba(0,0,0,.3)"])
	var _t576 = env["house"]
	J.cl(_t576, null, [v_ctx_572, v_x_573, v_y_574, 78.0, 40.0, "#4a3a2e"])
	var _t577 = env["rr"]
	J.cl(_t577, null, [v_ctx_572, J.sub(v_x_573, 30.0), J.sub(v_y_574, 30.0), 22.0, 26.0, 2.0, "#2a1a10", env["OUT"], 1.2])
	J.mc(v_ctx_572, "save", [])
	J.mc(v_ctx_572, "translate", [J.add(v_x_573, 18.0), J.sub(v_y_574, 6.0)])
	var _t578 = env["poly"]
	J.cl(_t578, null, [v_ctx_572, [(-12.0), 0.0, 12.0, 0.0, 15.0, (-12.0), 10.0, (-22.0), (-10.0), (-22.0), (-15.0), (-12.0)], "#5a2a1a", env["OUT"], 1.5])
	J.sp(v_ctx_572, "fillStyle", "#d9a84a")
	J.sp(v_ctx_572, "font", "bold 10px serif")
	J.sp(v_ctx_572, "textAlign", "center")
	J.mc(v_ctx_572, "fillText", ["壽", 0.0, (-8.0)])
	J.mc(v_ctx_572, "restore", [])
	var _t579 = env["roof"]
	J.cl(_t579, null, [v_ctx_572, v_x_573, J.sub(v_y_574, 66.0), 86.0, 26.0, "#3a2a3a"])
	var _t580 = env["lantern"]
	J.cl(_t580, null, [v_ctx_572, J.sub(v_x_573, 40.0), J.sub(v_y_574, 42.0), v_t_576, "#f0f0f0"])
	var _t581 = env["plaque"]
	J.cl(_t581, null, [v_ctx_572, v_x_573, J.sub(v_y_574, 54.0), "棺材鋪", v_lv_575])

func _f57(this_, a: Array, env):
	var v_ctx_579 = null; var v_x_580 = null; var v_y_581 = null; var v_lv_582 = null; var v_t_583 = null; var v_i_584 = null; var v_k_585 = null; var v_sx_586 = null
	v_ctx_579 = J.arg(a, 0)
	v_x_580 = J.arg(a, 1)
	v_y_581 = J.arg(a, 2)
	v_lv_582 = J.arg(a, 3)
	v_t_583 = J.arg(a, 4)
	var _t582 = env["el"]
	J.cl(_t582, null, [v_ctx_579, v_x_580, J.add(v_y_581, 4.0), 48.0, 9.0, "rgba(0,0,0,.3)"])
	var _t583 = env["house"]
	J.cl(_t583, null, [v_ctx_579, v_x_580, v_y_581, 78.0, 40.0, "#6a4232"])
	var _t584 = env["rr"]
	J.cl(_t584, null, [v_ctx_579, J.sub(v_x_580, 34.0), J.sub(v_y_581, 24.0), 68.0, 6.0, 2.0, "#8a5a3a", env["OUT"], 1.2])
	v_i_584 = 0.0
	while true:
		if not J.cmp(v_i_584, 3.0, "<"): break
		var _t585 = env["el"]
		J.cl(_t585, null, [v_ctx_579, (J.sub(v_x_580, 20.0) + J.mul(v_i_584, 20.0)), J.sub(v_y_581, 14.0), 9.0, 6.0, "#c8a878", env["OUT"], 1.2])
		var _t586 = env["el"]
		J.cl(_t586, null, [v_ctx_579, (J.sub(v_x_580, 20.0) + J.mul(v_i_584, 20.0)), J.sub(v_y_581, 18.0), 9.0, 3.0, "#d8b888", env["OUT"], 1.0])
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
	var _t587 = env["roof"]
	J.cl(_t587, null, [v_ctx_579, v_x_580, J.sub(v_y_581, 66.0), 86.0, 26.0, "#4a2a2a"])
	var _t588 = env["lantern"]
	J.cl(_t588, null, [v_ctx_579, J.add(v_x_580, 40.0), J.sub(v_y_581, 42.0), v_t_583])
	var _t589 = env["plaque"]
	J.cl(_t589, null, [v_ctx_579, v_x_580, J.sub(v_y_581, 54.0), "包子鋪", v_lv_582])

func _f58(this_, a: Array, env):
	var v_ctx_589 = null; var v_x_590 = null; var v_y_591 = null; var v_lv_592 = null; var v_t_593 = null; var v_i_594 = null
	v_ctx_589 = J.arg(a, 0)
	v_x_590 = J.arg(a, 1)
	v_y_591 = J.arg(a, 2)
	v_lv_592 = J.arg(a, 3)
	v_t_593 = J.arg(a, 4)
	var _t590 = env["el"]
	J.cl(_t590, null, [v_ctx_589, v_x_590, J.add(v_y_591, 4.0), 52.0, 9.0, "rgba(0,0,0,.3)"])
	var _t591 = env["house"]
	J.cl(_t591, null, [v_ctx_589, v_x_590, v_y_591, 90.0, 44.0, "#3e3a4e"])
	var _t592 = env["rr"]
	J.cl(_t592, null, [v_ctx_589, J.sub(v_x_590, 22.0), J.sub(v_y_591, 34.0), 44.0, 34.0, 2.0, "#2a2236", env["OUT"], 1.5])
	var _t593 = env["OUT"]
	J.sp(v_ctx_589, "strokeStyle", _t593)
	J.sp(v_ctx_589, "lineWidth", 1.5)
	J.mc(v_ctx_589, "beginPath", [])
	J.mc(v_ctx_589, "moveTo", [v_x_590, J.sub(v_y_591, 34.0)])
	J.mc(v_ctx_589, "lineTo", [v_x_590, v_y_591])
	J.mc(v_ctx_589, "stroke", [])
	v_i_594 = 0.0
	while true:
		if not J.cmp(v_i_594, 2.0, "<"): break
		var _t594 = env["rr"]
		J.cl(_t594, null, [v_ctx_589, J.add(v_x_590, 28.0), (J.sub(v_y_591, 16.0) - J.mul(v_i_594, 12.0)), 14.0, 12.0, 1.0, "#7a5a30", env["OUT"], 1.0])
		v_i_594 = J.num(v_i_594) + 1.0
	var _t595 = env["roof"]
	J.cl(_t595, null, [v_ctx_589, v_x_590, J.sub(v_y_591, 72.0), 98.0, 26.0, "#2a2a3a"])
	var _t596 = env["plaque"]
	J.cl(_t596, null, [v_ctx_589, v_x_590, J.sub(v_y_591, 58.0), "倉庫", v_lv_592])

func _f59(this_, a: Array, env):
	var v_ctx_597 = null; var v_x_598 = null; var v_y_599 = null; var v_lv_600 = null; var v_t_601 = null; var v_i_602 = null; var v_i_603 = null
	v_ctx_597 = J.arg(a, 0)
	v_x_598 = J.arg(a, 1)
	v_y_599 = J.arg(a, 2)
	v_lv_600 = J.arg(a, 3)
	v_t_601 = J.arg(a, 4)
	var _t597 = env["el"]
	J.cl(_t597, null, [v_ctx_597, v_x_598, J.add(v_y_599, 4.0), 44.0, 8.0, "rgba(0,0,0,.3)"])
	v_i_602 = 0.0
	while true:
		if not J.cmp(v_i_602, 4.0, "<"): break
		var _t598 = env["rr"]
		J.cl(_t598, null, [v_ctx_597, (J.sub(v_x_598, 30.0) + J.mul(v_i_602, 19.0)), J.sub(v_y_599, 16.0), 4.0, 16.0, 1.0, "#4a3424", env["OUT"], 1.0])
		v_i_602 = J.num(v_i_602) + 1.0
	var _t599 = env["rr"]
	J.cl(_t599, null, [v_ctx_597, J.sub(v_x_598, 34.0), J.sub(v_y_599, 42.0), 68.0, 26.0, 2.0, "#7a5a3a", env["OUT"], 1.5])
	v_i_603 = 0.0
	while true:
		if not J.cmp(v_i_603, 7.0, "<"): break
		J.sp(v_ctx_597, "strokeStyle", "rgba(0,0,0,.25)")
		J.mc(v_ctx_597, "beginPath", [])
		J.mc(v_ctx_597, "moveTo", [(J.sub(v_x_598, 34.0) + J.mul(v_i_603, 10.0)), J.sub(v_y_599, 42.0)])
		J.mc(v_ctx_597, "lineTo", [(J.sub(v_x_598, 34.0) + J.mul(v_i_603, 10.0)), J.sub(v_y_599, 16.0)])
		J.mc(v_ctx_597, "stroke", [])
		v_i_603 = J.num(v_i_603) + 1.0
	var _t600 = env["rr"]
	J.cl(_t600, null, [v_ctx_597, J.sub(v_x_598, 8.0), J.sub(v_y_599, 36.0), 14.0, 14.0, 1.0, "#ffd88a", env["OUT"], 1.0])
	var _t601 = env["poly"]
	J.cl(_t601, null, [v_ctx_597, [J.sub(v_x_598, 42.0), J.sub(v_y_599, 40.0), v_x_598, J.sub(v_y_599, 66.0), J.add(v_x_598, 42.0), J.sub(v_y_599, 40.0)], "#5a4a3a", env["OUT"], 1.8])
	var _t602 = env["plaque"]
	J.cl(_t602, null, [v_ctx_597, v_x_598, J.sub(v_y_599, 58.0), "民宅", v_lv_600])

func _f60(this_, a: Array, env):
	var v_ctx_606 = null; var v_x_607 = null; var v_y_608 = null; var v_lv_609 = null; var v_t_610 = null
	v_ctx_606 = J.arg(a, 0)
	v_x_607 = J.arg(a, 1)
	v_y_608 = J.arg(a, 2)
	v_lv_609 = J.arg(a, 3)
	v_t_610 = J.arg(a, 4)
	var _t603 = env["el"]
	J.cl(_t603, null, [v_ctx_606, v_x_607, J.add(v_y_608, 4.0), 48.0, 9.0, "rgba(0,0,0,.3)"])
	var _t604 = env["poly"]
	J.cl(_t604, null, [v_ctx_606, [J.sub(v_x_607, 38.0), v_y_608, v_x_607, J.sub(v_y_608, 46.0), J.add(v_x_607, 38.0), v_y_608], "#3a4a3a", env["OUT"], 2.0])
	var _t605 = env["poly"]
	J.cl(_t605, null, [v_ctx_606, [J.sub(v_x_607, 10.0), v_y_608, v_x_607, J.sub(v_y_608, 30.0), J.add(v_x_607, 10.0), v_y_608], "#1a2418", env["OUT"], 1.2])
	var _t606 = env["rr"]
	J.cl(_t606, null, [v_ctx_606, J.add(v_x_607, 30.0), J.sub(v_y_608, 58.0), 2.0, 58.0, 1.0, "#5a3a1a"])
	var _t607 = env["poly"]
	J.cl(_t607, null, [v_ctx_606, [J.add(v_x_607, 32.0), J.sub(v_y_608, 58.0), J.add(J.add(v_x_607, 52.0), (sin(J.num(J.mul(v_t_610, 3.0))) * 3.0)), J.sub(v_y_608, 52.0), J.add(v_x_607, 32.0), J.sub(v_y_608, 46.0)], "#7a2a8a", env["OUT"], 1.0])
	J.sp(v_ctx_606, "fillStyle", "#fff")
	J.sp(v_ctx_606, "font", "bold 8px sans-serif")
	J.mc(v_ctx_606, "fillText", ["陰", J.add(v_x_607, 36.0), J.sub(v_y_608, 49.0)])
	var _t608 = env["plaque"]
	J.cl(_t608, null, [v_ctx_606, J.sub(v_x_607, 6.0), J.sub(v_y_608, 56.0), "嚇人班", v_lv_609])

func _f61(this_, a: Array, env):
	var v_ctx_613 = null; var v_x_614 = null; var v_y_615 = null; var v_lv_616 = null; var v_t_617 = null; var v_g_618 = null; var v_i_619 = null
	v_ctx_613 = J.arg(a, 0)
	v_x_614 = J.arg(a, 1)
	v_y_615 = J.arg(a, 2)
	v_lv_616 = J.arg(a, 3)
	v_t_617 = J.arg(a, 4)
	var _t609 = env["el"]
	J.cl(_t609, null, [v_ctx_613, v_x_614, J.add(v_y_615, 4.0), 40.0, 9.0, "rgba(0,0,0,.3)"])
	var _t610 = env["rr"]
	J.cl(_t610, null, [v_ctx_613, J.sub(v_x_614, 34.0), J.sub(v_y_615, 14.0), 68.0, 14.0, 2.0, "#4a4458", env["OUT"], 1.5])
	var _t611 = env["rr"]
	J.cl(_t611, null, [v_ctx_613, J.sub(v_x_614, 24.0), J.sub(v_y_615, 26.0), 48.0, 12.0, 2.0, "#5a5468", env["OUT"], 1.5])
	v_i_619 = (-1.0)
	while true:
		if not J.cmp(v_i_619, 1.0, "<="): break
		var _t612 = env["rr"]
		J.cl(_t612, null, [v_ctx_613, J.sub(J.add(v_x_614, J.mul(v_i_619, 30.0)), 1.0), J.sub(v_y_615, 58.0), 2.0, 44.0, 1.0, "#3a2a1a"])
		var _t613 = env["poly"]
		J.cl(_t613, null, [v_ctx_613, [J.add(v_x_614, J.mul(v_i_619, 30.0)), J.sub(v_y_615, 58.0), J.add(J.add(J.add(v_x_614, J.mul(v_i_619, 30.0)), J.mul(v_i_619, 4.0)), (sin(J.num(J.add(J.mul(v_t_617, 2.0), v_i_619))) * 2.0)), J.sub(v_y_615, 52.0), J.add(J.add(v_x_614, J.mul(v_i_619, 30.0)), J.mul(v_i_619, 3.0)), J.sub(v_y_615, 30.0), J.add(v_x_614, J.mul(v_i_619, 30.0)), J.sub(v_y_615, 34.0)], "#e8e0c8", env["OUT"], 1.0])
		var _t614 = J.add(v_i_619, 2.0)
		v_i_619 = _t614
	v_g_618 = J.mc(v_ctx_613, "createRadialGradient", [v_x_614, J.sub(v_y_615, 34.0), 2.0, v_x_614, J.sub(v_y_615, 34.0), 22.0])
	J.mc(v_g_618, "addColorStop", [0.0, "rgba(120,255,200,.6)"])
	J.mc(v_g_618, "addColorStop", [1.0, "rgba(120,255,200,0)"])
	J.sp(v_ctx_613, "fillStyle", v_g_618)
	J.mc(v_ctx_613, "fillRect", [J.sub(v_x_614, 24.0), J.sub(v_y_615, 58.0), 48.0, 48.0])
	var _t615 = env["el"]
	J.cl(_t615, null, [v_ctx_613, v_x_614, (J.sub(v_y_615, 34.0) + (sin(J.num(J.mul(v_t_617, 2.0))) * 2.0)), 5.0, 6.0, "rgba(180,255,230,.9)"])
	var _t616 = env["plaque"]
	J.cl(_t616, null, [v_ctx_613, v_x_614, J.sub(v_y_615, 68.0), "招魂台", v_lv_616])

func _f62(this_, a: Array, env):
	var v_ctx_622 = null; var v_x_623 = null; var v_y_624 = null; var v_lv_625 = null; var v_t_626 = null; var v_ready_627 = null; var v_fl_628 = null; var v_g_629 = null
	v_ctx_622 = J.arg(a, 0)
	v_x_623 = J.arg(a, 1)
	v_y_624 = J.arg(a, 2)
	v_lv_625 = J.arg(a, 3)
	v_t_626 = J.arg(a, 4)
	v_ready_627 = J.arg(a, 5)
	var _t617 = env["el"]
	J.cl(_t617, null, [v_ctx_622, v_x_623, J.add(v_y_624, 3.0), 26.0, 7.0, "rgba(0,0,0,.3)"])
	var _t618 = env["rr"]
	J.cl(_t618, null, [v_ctx_622, J.sub(v_x_623, 18.0), J.sub(v_y_624, 36.0), 36.0, 36.0, 6.0, "#6a3a2a", env["OUT"], 1.8])
	var _t619 = env["roof"]
	J.cl(_t619, null, [v_ctx_622, v_x_623, J.sub(v_y_624, 52.0), 30.0, 14.0, "#4a2a2a"])
	var _t620 = env["rr"]
	J.cl(_t620, null, [v_ctx_622, J.sub(v_x_623, 8.0), J.sub(v_y_624, 26.0), 16.0, 14.0, 4.0, "#1a0a08", env["OUT"], 1.0])
	v_fl_628 = (1.0 if J.t(v_ready_627) else 0.35)
	var _t621 = env["el"]
	J.cl(_t621, null, [v_ctx_622, v_x_623, (J.sub(v_y_624, 18.0) - (sin(J.num(J.mul(v_t_626, 8.0))) * 1.0)), (J.mul(5.0, v_fl_628) + 1.0), (J.mul(6.0, v_fl_628) + 1.0), ("#ffb030" if J.t(v_ready_627) else "#a04020")])
	if J.t(v_ready_627):
		v_g_629 = J.mc(v_ctx_622, "createRadialGradient", [v_x_623, J.sub(v_y_624, 20.0), 2.0, v_x_623, J.sub(v_y_624, 20.0), 26.0])
		J.mc(v_g_629, "addColorStop", [0.0, "rgba(255,170,60,.45)"])
		J.mc(v_g_629, "addColorStop", [1.0, "rgba(255,170,60,0)"])
		J.sp(v_ctx_622, "fillStyle", v_g_629)
		J.mc(v_ctx_622, "fillRect", [J.sub(v_x_623, 26.0), J.sub(v_y_624, 46.0), 52.0, 52.0])
	var _t622 = env["plaque"]
	J.cl(_t622, null, [v_ctx_622, v_x_623, J.sub(v_y_624, 62.0), "化寶爐", v_lv_625])

func _f78(this_, a: Array, env):
	var v_type_765 = null
	v_type_765 = J.arg(a, 0)
	var _t623 = (not J.seq(J.typeof_(J.G.get("MeshAnim")), "undefined"))
	var _t624 = ((not (not J.t(J.gp(env["CHAR_H"], v_type_765)))) if _t623 else _t623)
	return (J.mc(J.G.get("MeshAnim"), "has", [v_type_765]) if _t624 else _t624)

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
