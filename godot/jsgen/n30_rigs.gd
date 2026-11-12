# 自動轉譯自 n30_rigs.js（tools/jsgd.js）——唔好直接改，改原 JS 再轉
extends RefCounted

func run(env):
	var this_ = null; var a = []
	J.G["N30"] = J.cl(Callable(self, "_f1").bind(env), null, [])

func _f4(this_, a: Array, env):
	var v_pz_19 = null; var v_o_20 = null; var v_t_21 = null; var v_ps_22 = null; var v_walking_23 = null; var v_idle_24 = null; var v_A_25 = null; var v_b_26 = null; var v_am_27 = null; var v_f_28 = null; var v_ph_29 = null; var v_f_30 = null; var v_ph_31 = null; var v_up_32 = null; var v_land_33 = null; var v_b_34 = null; var v_w_35 = null; var v_w_36 = null; var v_w_37 = null; var v_q_38 = null; var v_j_39 = null; var v_w_40 = null; var v_k_41 = null; var v_w_42 = null; var v_q_43 = null; var v_lurch_44 = null
	v_pz_19 = J.arg(a, 0)
	v_o_20 = J.arg(a, 1)
	var _t3 = J.gp(v_o_20, "t")
	v_t_21 = (_t3 if J.t(_t3) else 0.0)
	v_ps_22 = J.gp(v_o_20, "pose")
	var _t4 = J.gp(v_o_20, "walk")
	var _t5 = (_t4 if J.t(_t4) else J.seq(v_ps_22, "move"))
	var _t6 = (_t5 if J.t(_t5) else J.seq(v_ps_22, "walk"))
	v_walking_23 = (not (not J.t((_t6 if J.t(_t6) else J.seq(v_ps_22, "run")))))
	var _t8 = (not J.t(v_walking_23))
	if J.t(_t8):
		var _t7 = (not J.t(v_ps_22))
		_t8 = (_t7 if _t7 else J.seq(v_ps_22, "idle"))
	v_idle_24 = _t8
	var _t9 = (not J.t(v_walking_23))
	if ((not J.t(v_idle_24)) if _t9 else _t9):
		return null
	v_A_25 = J.gp(J.G.get("MeshAnim"), "ANIM")
	for _t10 in J.keys(env["sec"]):
		v_b_26 = _t10
		var _t11 = J.gp(env["sec"], v_b_26)
		var _t12 = J.gp(_t11, 0.0)
		v_am_27 = _t12
		var _t13 = J.gp(_t11, 1.0)
		v_f_28 = _t13
		var _t14 = J.gp(_t11, 2.0)
		v_ph_29 = _t14
		var _t15 = J.gp(v_pz_19, v_b_26)
		var _t17 = (_t15 if J.t(_t15) else 0.0)
		var _t16 = env["__p"]["S"]
		var _t18 = J.add(_t17, (J.mul(J.cl(_t16, null, [J.add(J.mul(v_t_21, v_f_28), v_ph_29)]), v_am_27) * (1.6 if J.t(v_walking_23) else 1.0)))
		J.sp(v_pz_19, v_b_26, _t18)
	if J.seq(env["loco"], "float"):
		J.sp(v_pz_19, "legF", 0.0)
		J.sp(v_pz_19, "legB", 0.0)
		if J.t(v_walking_23):
			J.sp(v_pz_19, "body", 0.14)
			var _t19 = env["__p"]["S"]
			var _t20 = J.mul(J.cl(_t19, null, [J.mul(v_t_21, 3.0)]), 0.08)
			J.sp(v_pz_19, "armF", _t20)
			var _t21 = env["__p"]["S"]
			var _t22 = ((-J.num(J.cl(_t21, null, [J.mul(v_t_21, 3.0)]))) * 0.08)
			J.sp(v_pz_19, "armB", _t22)
			var _t24 = (-0.03)
			var _t23 = env["__p"]["S"]
			var _t25 = (_t24 - J.mul(J.cl(_t23, null, [J.mul(v_t_21, 3.0)]), 0.02))
			J.sp(v_pz_19, "y", _t25)
			var _t27 = (-0.25)
			var _t26 = env["__p"]["S"]
			var _t28 = (_t27 + J.mul(J.cl(_t26, null, [J.mul(v_t_21, 4.0)]), 0.12))
			J.sp(v_pz_19, "tail1", _t28)
			var _t30 = (-0.35)
			var _t29 = env["__p"]["S"]
			var _t31 = (_t30 + J.mul(J.cl(_t29, null, [(J.mul(v_t_21, 4.0) - 1.0)]), 0.2))
			J.sp(v_pz_19, "tail2", _t31)
			J.sp(v_pz_19, "rot", 0.04)
		else:
			var _t32 = env["__p"]["S"]
			var _t33 = J.mul(J.cl(_t32, null, [J.mul(v_t_21, 0.8)]), 0.012)
			J.sp(v_pz_19, "x", _t33)
			var _t34 = env["__p"]["S"]
			var _t35 = J.mul(J.cl(_t34, null, [J.mul(v_t_21, 1.1)]), 0.025)
			J.sp(v_pz_19, "rot", _t35)
	else:
		var _t36 = J.seq(env["loco"], "onefoot")
		if (_t36 if _t36 else J.seq(env["loco"], "bottle")):
			v_f_30 = (4.5 if J.seq(env["loco"], "bottle") else 5.5)
			v_ph_31 = J.mod(J.mul(v_t_21, v_f_30), PI)
			var _t37 = env["__p"]["S"]
			v_up_32 = J.cl(_t37, null, [v_ph_31])
			v_land_33 = ((1.0 - J.div(v_ph_31, 0.35)) if J.cmp(v_ph_31, 0.35, "<") else 0.0)
			if J.t(v_walking_23):
				var _t38 = ((-0.02) - J.mul(v_up_32, 0.1))
				J.sp(v_pz_19, "y", _t38)
				var _t39 = ((1.0 - J.mul(v_land_33, 0.08)) + J.mul(v_up_32, 0.03))
				J.sp(v_pz_19, "sy", _t39)
				var _t40 = (1.0 + J.mul(v_land_33, 0.06))
				J.sp(v_pz_19, "sx", _t40)
				J.sp(v_pz_19, "body", 0.05)
				J.sp(v_pz_19, "legB", 0.0)
				J.sp(v_pz_19, "legF", 0.1)
				var _t41 = J.mul(v_up_32, 0.25)
				J.sp(v_pz_19, "armF", _t41)
				var _t42 = ((-J.num(v_up_32)) * 0.25)
				J.sp(v_pz_19, "armB", _t42)
			else:
				var _t43 = env["__p"]["S"]
				v_b_34 = absf(J.num(J.cl(_t43, null, [J.mul(v_t_21, 2.2)])))
				var _t44 = ((-0.01) - J.mul(v_b_34, 0.02))
				J.sp(v_pz_19, "y", _t44)
				var _t45 = (1.0 + J.mul(v_b_34, 0.015))
				J.sp(v_pz_19, "sy", _t45)
				J.sp(v_pz_19, "legB", 0.0)
				J.sp(v_pz_19, "legF", 0.0)
		else:
			if J.seq(env["loco"], "stride"):
				if J.t(v_walking_23):
					v_w_35 = J.mc(v_A_25, "walk", [J.mul(v_t_21, 0.62)])
					var _t46 = J.mul(J.gp(v_w_35, "legF"), 0.42)
					J.sp(v_pz_19, "legF", _t46)
					var _t47 = J.mul(J.gp(v_w_35, "legB"), 0.42)
					J.sp(v_pz_19, "legB", _t47)
					var _t48 = J.mul(J.gp(v_w_35, "armF"), 1.2)
					J.sp(v_pz_19, "armF", _t48)
					var _t49 = J.mul(J.gp(v_w_35, "armB"), 1.2)
					J.sp(v_pz_19, "armB", _t49)
					J.sp(v_pz_19, "body", 0.06)
					var _t50 = env["__p"]["S"]
					var _t51 = J.mul(J.cl(_t50, null, [J.mul(v_t_21, 4.34)]), 0.05)
					J.sp(v_pz_19, "head", _t51)
					var _t52 = env["__p"]["S"]
					var _t53 = ((-absf(J.num(J.cl(_t52, null, [J.mul(v_t_21, 4.34)])))) * 0.03)
					J.sp(v_pz_19, "y", _t53)
					var _t54 = env["__p"]["S"]
					var _t55 = J.mul(J.cl(_t54, null, [J.mul(v_t_21, 4.34)]), 0.03)
					J.sp(v_pz_19, "rot", _t55)
				else:
					var _t56 = env["__p"]["S"]
					var _t57 = J.mul(J.cl(_t56, null, [J.mul(v_t_21, 0.9)]), 0.03)
					J.sp(v_pz_19, "body", _t57)
			else:
				if J.seq(env["loco"], "neck"):
					var _t58 = env["__p"]["S"]
					var _t59 = (J.mul(J.cl(_t58, null, [J.mul(v_t_21, 1.1)]), 0.1) * (1.6 if J.t(v_walking_23) else 1.0))
					J.sp(v_pz_19, "neck1", _t59)
					var _t60 = env["__p"]["S"]
					var _t61 = (J.mul(J.cl(_t60, null, [(J.mul(v_t_21, 1.1) - 0.9)]), 0.18) * (1.5 if J.t(v_walking_23) else 1.0))
					J.sp(v_pz_19, "neck2", _t61)
					var _t62 = J.gp(v_pz_19, "head")
					var _t64 = (_t62 if J.t(_t62) else 0.0)
					var _t63 = env["__p"]["S"]
					var _t65 = J.sub(_t64, J.mul(J.cl(_t63, null, [(J.mul(v_t_21, 1.1) - 1.6)]), 0.1))
					J.sp(v_pz_19, "head", _t65)
					if J.t(v_walking_23):
						J.sp(v_pz_19, "legF", 0.0)
						J.sp(v_pz_19, "legB", 0.0)
						var _t66 = env["__p"]["S"]
						var _t67 = ((-absf(J.num(J.cl(_t66, null, [J.mul(v_t_21, 6.0)])))) * 0.012)
						J.sp(v_pz_19, "y", _t67)
				else:
					if J.seq(env["loco"], "heavy"):
						if J.t(v_walking_23):
							v_w_36 = J.mc(v_A_25, "walk", [J.mul(v_t_21, 0.6)])
							var _t68 = J.mul(J.gp(v_w_36, "legF"), 1.1)
							J.sp(v_pz_19, "legF", _t68)
							var _t69 = J.mul(J.gp(v_w_36, "legB"), 1.1)
							J.sp(v_pz_19, "legB", _t69)
							var _t70 = J.mul(J.gp(v_w_36, "armF"), 0.8)
							J.sp(v_pz_19, "armF", _t70)
							var _t71 = J.mul(J.gp(v_w_36, "armB"), 0.8)
							J.sp(v_pz_19, "armB", _t71)
							var _t72 = env["__p"]["S"]
							var _t73 = J.mul(J.cl(_t72, null, [J.mul(v_t_21, 4.2)]), 0.05)
							J.sp(v_pz_19, "rot", _t73)
							var _t74 = env["__p"]["S"]
							var _t75 = ((-absf(J.num(J.cl(_t74, null, [J.mul(v_t_21, 4.2)])))) * 0.03)
							J.sp(v_pz_19, "y", _t75)
							J.sp(v_pz_19, "body", 0.06)
						else:
							var _t76 = env["__p"]["S"]
							var _t77 = J.mul(J.cl(_t76, null, [J.mul(v_t_21, 0.9)]), 0.015)
							J.sp(v_pz_19, "rot", _t77)
							var _t78 = J.gp(v_pz_19, "sy")
							var _t80 = (_t78 if J.t(_t78) else 1.0)
							var _t79 = env["__p"]["S"]
							var _t81 = J.add(_t80, J.mul(J.cl(_t79, null, [J.mul(v_t_21, 1.2)]), 0.012))
							J.sp(v_pz_19, "sy", _t81)
					else:
						if J.seq(env["loco"], "skitter"):
							if J.t(v_walking_23):
								var _t82 = env["__p"]["S"]
								var _t83 = J.mul(J.cl(_t82, null, [J.mul(v_t_21, 22.0)]), 0.18)
								J.sp(v_pz_19, "legF", _t83)
								var _t84 = env["__p"]["S"]
								var _t85 = J.mul(J.cl(_t84, null, [J.mul(v_t_21, 11.0)]), 0.1)
								J.sp(v_pz_19, "legB", _t85)
								var _t86 = env["__p"]["S"]
								var _t87 = ((-absf(J.num(J.cl(_t86, null, [J.mul(v_t_21, 11.0)])))) * 0.05)
								J.sp(v_pz_19, "y", _t87)
								J.sp(v_pz_19, "body", 0.0)
							else:
								var _t88 = env["__p"]["S"]
								var _t89 = J.mul(J.cl(_t88, null, [J.mul(v_t_21, 9.0)]), 0.03)
								J.sp(v_pz_19, "legF", _t89)
								var _t90 = env["__p"]["S"]
								var _t91 = J.mul(J.cl(_t90, null, [J.mul(v_t_21, 3.0)]), 0.12)
								J.sp(v_pz_19, "hairL", _t91)
								var _t92 = env["__p"]["S"]
								var _t93 = J.mul(J.cl(_t92, null, [(J.mul(v_t_21, 3.0) + 1.0)]), 0.12)
								J.sp(v_pz_19, "hairR", _t93)
						else:
							if J.seq(env["loco"], "creep"):
								if J.t(v_walking_23):
									v_w_37 = J.mc(v_A_25, "walk", [J.mul(v_t_21, 0.8)])
									var _t94 = J.gp(v_w_37, "legF")
									J.sp(v_pz_19, "legF", _t94)
									var _t95 = J.gp(v_w_37, "legB")
									J.sp(v_pz_19, "legB", _t95)
									J.sp(v_pz_19, "body", 0.16)
									var _t96 = env["__p"]["S"]
									var _t97 = (0.06 + J.mul(J.cl(_t96, null, [J.mul(v_t_21, 5.6)]), 0.04))
									J.sp(v_pz_19, "head", _t97)
									var _t98 = env["__p"]["S"]
									var _t99 = ((-absf(J.num(J.cl(_t98, null, [J.mul(v_t_21, 5.6)])))) * 0.015)
									J.sp(v_pz_19, "y", _t99)
							else:
								if J.seq(env["loco"], "drunk"):
									var _t100 = env["__p"]["S"]
									var _t102 = J.mul(J.cl(_t100, null, [J.mul(v_t_21, 1.3)]), 0.07)
									var _t101 = env["__p"]["S"]
									var _t103 = (_t102 + J.mul(J.cl(_t101, null, [J.mul(v_t_21, 2.9)]), 0.03))
									J.sp(v_pz_19, "rot", _t103)
									var _t104 = env["__p"]["S"]
									var _t105 = J.mul(J.cl(_t104, null, [J.mul(v_t_21, 0.9)]), 0.02)
									J.sp(v_pz_19, "x", _t105)
									var _t106 = J.gp(v_pz_19, "head")
									var _t108 = (_t106 if J.t(_t106) else 0.0)
									var _t107 = env["__p"]["S"]
									var _t109 = J.add(_t108, J.mul(J.cl(_t107, null, [J.mul(v_t_21, 1.7)]), 0.08))
									J.sp(v_pz_19, "head", _t109)
									if J.t(v_walking_23):
										var _t110 = env["__p"]["S"]
										var _t111 = J.add(J.gp(v_pz_19, "rot"), J.mul(J.cl(_t110, null, [J.mul(v_t_21, 3.5)]), 0.08))
										J.sp(v_pz_19, "rot", _t111)
								else:
									if J.seq(env["loco"], "shiver"):
										var _t112 = J.gp(v_pz_19, "x")
										var _t114 = (_t112 if J.t(_t112) else 0.0)
										var _t113 = env["__p"]["S"]
										var _t115 = J.add(_t114, J.mul(J.cl(_t113, null, [J.mul(v_t_21, 47.0)]), 0.005))
										J.sp(v_pz_19, "x", _t115)
										var _t116 = J.gp(v_pz_19, "head")
										var _t118 = (_t116 if J.t(_t116) else 0.0)
										var _t117 = env["__p"]["S"]
										var _t119 = J.add(_t118, J.mul(J.cl(_t117, null, [J.mul(v_t_21, 39.0)]), 0.02))
										J.sp(v_pz_19, "head", _t119)
										if J.t(v_walking_23):
											var _t120 = (-0.04)
											J.sp(v_pz_19, "body", _t120)
											var _t121 = env["__p"]["S"]
											var _t122 = ((-absf(J.num(J.cl(_t121, null, [J.mul(v_t_21, 9.0)])))) * 0.02)
											J.sp(v_pz_19, "y", _t122)
									else:
										if J.seq(env["loco"], "twitch"):
											v_q_38 = J.mod(J.mul(v_t_21, 0.9), 1.0)
											var _t124 = null
											if J.cmp(v_q_38, 0.85, ">"):
												var _t123 = env["__p"]["S"]
												_t124 = J.cl(_t123, null, [J.mul(v_q_38, 120.0)])
											else:
												_t124 = 0.0
											v_j_39 = _t124
											var _t125 = J.gp(v_pz_19, "x")
											var _t126 = J.add((_t125 if J.t(_t125) else 0.0), J.mul(v_j_39, 0.012))
											J.sp(v_pz_19, "x", _t126)
											var _t127 = J.gp(v_pz_19, "head")
											var _t128 = J.add((_t127 if J.t(_t127) else 0.0), J.mul(v_j_39, 0.08))
											J.sp(v_pz_19, "head", _t128)
											var _t129 = J.gp(v_pz_19, "armF")
											var _t130 = J.add((_t129 if J.t(_t129) else 0.0), J.mul(v_j_39, 0.15))
											J.sp(v_pz_19, "armF", _t130)
											var _t131 = J.gp(v_pz_19, "armB")
											var _t132 = J.sub((_t131 if J.t(_t131) else 0.0), J.mul(v_j_39, 0.15))
											J.sp(v_pz_19, "armB", _t132)
											if J.t(v_walking_23):
												v_w_40 = J.mc(v_A_25, "walk", [v_t_21])
												var _t133 = J.mul(J.gp(v_w_40, "legF"), 0.8)
												J.sp(v_pz_19, "legF", _t133)
												var _t134 = J.mul(J.gp(v_w_40, "legB"), 0.8)
												J.sp(v_pz_19, "legB", _t134)
										else:
											if J.seq(env["loco"], "laugh"):
												var _t135 = J.gp(v_pz_19, "body")
												var _t137 = J.add((_t135 if J.t(_t135) else 0.0), 0.05)
												var _t136 = env["__p"]["S"]
												var _t138 = J.add(_t137, (absf(J.num(J.cl(_t136, null, [J.mul(v_t_21, 9.0)]))) * 0.05))
												J.sp(v_pz_19, "body", _t138)
												var _t139 = J.gp(v_pz_19, "head")
												var _t141 = (_t139 if J.t(_t139) else 0.0)
												var _t140 = env["__p"]["S"]
												var _t142 = J.add(_t141, (absf(J.num(J.cl(_t140, null, [J.mul(v_t_21, 9.0)]))) * 0.08))
												J.sp(v_pz_19, "head", _t142)
												var _t143 = J.gp(v_pz_19, "y")
												var _t145 = (_t143 if J.t(_t143) else 0.0)
												var _t144 = env["__p"]["S"]
												var _t146 = J.sub(_t145, (absf(J.num(J.cl(_t144, null, [J.mul(v_t_21, 9.0)]))) * 0.01))
												J.sp(v_pz_19, "y", _t146)
											else:
												if J.seq(env["loco"], "paper"):
													J.sp(v_pz_19, "legF", 0.0)
													J.sp(v_pz_19, "legB", 0.0)
													v_k_41 = (1.0 if J.t(v_walking_23) else 0.35)
													var _t147 = env["__p"]["S"]
													var _t148 = (1.0 + J.mul(J.mul(J.cl(_t147, null, [J.mul(v_t_21, (6.0 if J.t(v_walking_23) else 2.0))]), 0.08), v_k_41))
													J.sp(v_pz_19, "sy", _t148)
													var _t149 = env["__p"]["S"]
													var _t150 = J.mul(J.mul(J.cl(_t149, null, [(J.mul(v_t_21, (6.0 if J.t(v_walking_23) else 2.0)) + 1.0)]), 0.08), v_k_41)
													J.sp(v_pz_19, "rot", _t150)
													var _t153 = (-0.02)
													var _t152 = null
													if J.t(v_walking_23):
														var _t151 = env["__p"]["S"]
														_t152 = (absf(J.num(J.cl(_t151, null, [J.mul(v_t_21, 6.0)]))) * 0.06)
													else:
														_t152 = 0.0
													var _t154 = (_t153 - _t152)
													J.sp(v_pz_19, "y", _t154)
													var _t155 = env["__p"]["S"]
													var _t156 = J.mul(J.mul(J.cl(_t155, null, [J.mul(v_t_21, 3.0)]), 0.15), v_k_41)
													J.sp(v_pz_19, "armF", _t156)
													var _t157 = env["__p"]["S"]
													var _t158 = J.mul(((-J.num(J.cl(_t157, null, [J.mul(v_t_21, 3.0)]))) * 0.15), v_k_41)
													J.sp(v_pz_19, "armB", _t158)
												else:
													if J.seq(env["loco"], "flee"):
														if J.t(v_walking_23):
															v_w_42 = J.mc(v_A_25, "walk", [J.mul(v_t_21, 1.6)])
															var _t159 = J.mul(J.gp(v_w_42, "legF"), 1.2)
															J.sp(v_pz_19, "legF", _t159)
															var _t160 = J.mul(J.gp(v_w_42, "legB"), 1.2)
															J.sp(v_pz_19, "legB", _t160)
															var _t161 = J.mul(J.gp(v_w_42, "armF"), 1.4)
															J.sp(v_pz_19, "armF", _t161)
															var _t162 = J.mul(J.gp(v_w_42, "armB"), 1.4)
															J.sp(v_pz_19, "armB", _t162)
															var _t163 = env["__p"]["S"]
															var _t164 = ((-absf(J.num(J.cl(_t163, null, [J.mul(v_t_21, 11.0)])))) * 0.03)
															J.sp(v_pz_19, "y", _t164)
														else:
															var _t165 = J.gp(v_pz_19, "y")
															var _t167 = (_t165 if J.t(_t165) else 0.0)
															var _t166 = env["__p"]["S"]
															var _t168 = J.sub(_t167, (absf(J.num(J.cl(_t166, null, [J.mul(v_t_21, 4.0)]))) * 0.01))
															J.sp(v_pz_19, "y", _t168)
															var _t169 = J.gp(v_pz_19, "armF")
															var _t171 = (_t169 if J.t(_t169) else 0.0)
															var _t170 = env["__p"]["S"]
															var _t172 = J.add(_t171, J.mul(J.cl(_t170, null, [J.mul(v_t_21, 4.0)]), 0.05))
															J.sp(v_pz_19, "armF", _t172)
													else:
														if J.seq(env["loco"], "stumble"):
															if J.t(v_walking_23):
																v_q_43 = J.mod(J.mul(v_t_21, 0.7), 1.0)
																var _t174 = null
																if J.cmp(v_q_43, 0.8, ">"):
																	var _t173 = env["__p"]["S"]
																	_t174 = J.cl(_t173, null, [(J.div(J.sub(v_q_43, 0.8), 0.2) * PI)])
																else:
																	_t174 = 0.0
																v_lurch_44 = _t174
																var _t175 = (0.04 + J.mul(v_lurch_44, 0.18))
																J.sp(v_pz_19, "rot", _t175)
																var _t176 = J.gp(v_pz_19, "body")
																var _t177 = J.add((_t176 if J.t(_t176) else 0.0), J.mul(v_lurch_44, 0.2))
																J.sp(v_pz_19, "body", _t177)
																var _t178 = J.gp(v_pz_19, "armF")
																var _t179 = J.sub((_t178 if J.t(_t178) else 0.0), J.mul(v_lurch_44, 0.6))
																J.sp(v_pz_19, "armF", _t179)
																var _t180 = J.gp(v_pz_19, "armB")
																var _t181 = J.add((_t180 if J.t(_t180) else 0.0), J.mul(v_lurch_44, 0.5))
																J.sp(v_pz_19, "armB", _t181)

func _f3(this_, a: Array, env):
	var v_d_14 = null
	var _s4 = {"__p": env, "loco": null, "sec": null}
	v_d_14 = J.arg(a, 0)
	var _t1 = J.gp(v_d_14, "loco")
	_s4["loco"] = (_t1 if J.t(_t1) else "walk")
	var _t2 = J.gp(v_d_14, "sec")
	_s4["sec"] = (_t2 if J.t(_t2) else {})
	return Callable(self, "_f4").bind(_s4)

func _f8(this_, a: Array, env):
	var v_id_55 = null; var v_pieces_56 = null; var v_key_57 = null; var v_img_58 = null; var v_c_59 = null; var v_g_60 = null; var v_mk_61 = null; var v_mg_62 = null; var v_p_63 = null; var v_p_64 = null; var v_bd_65 = null; var v_md_66 = null; var v_b_67 = null; var v_i_68 = null; var v_m_69 = null; var v_e_70 = null
	v_id_55 = J.arg(a, 0)
	v_pieces_56 = J.arg(a, 1)
	v_key_57 = J.arg(a, 2)
	var _t182 = J.gp(J.G.get("SPR"), v_key_57)
	if J.t((J.gp(J.gp(J.G.get("SPR"), v_key_57), "_ok") if J.t(_t182) else _t182)):
		return v_key_57
	var _t183 = env["ok"]
	if (not J.t(J.cl(_t183, null, [v_id_55]))):
		return null
	for _t184 in J.iter(v_pieces_56):
		v_p_63 = _t184
		var _t185 = env["ok"]
		if (not J.t(J.cl(_t185, null, [J.add(J.add(v_id_55, "__"), v_p_63)]))):
			return null
	v_img_58 = J.gp(J.G.get("SPR"), v_id_55)
	v_c_59 = J.S_document_("createElement", ["canvas"])
	var _t186 = J.gp(v_img_58, "naturalWidth")
	J.sp(v_c_59, "width", _t186)
	var _t187 = J.gp(v_img_58, "naturalHeight")
	J.sp(v_c_59, "height", _t187)
	v_g_60 = J.mc(v_c_59, "getContext", ["2d"])
	J.mc(v_g_60, "drawImage", [v_img_58, 0.0, 0.0])
	v_mk_61 = J.S_document_("createElement", ["canvas"])
	var _t188 = J.gp(v_c_59, "width")
	J.sp(v_mk_61, "width", _t188)
	var _t189 = J.gp(v_c_59, "height")
	J.sp(v_mk_61, "height", _t189)
	v_mg_62 = J.mc(v_mk_61, "getContext", ["2d"])
	for _t190 in J.iter(v_pieces_56):
		v_p_64 = _t190
		J.mc(v_mg_62, "drawImage", [J.gp(J.G.get("SPR"), J.add(J.add(v_id_55, "__"), v_p_64)), 0.0, 0.0, J.gp(v_c_59, "width"), J.gp(v_c_59, "height")])
	v_bd_65 = J.mc(v_g_60, "getImageData", [0.0, 0.0, J.gp(v_c_59, "width"), J.gp(v_c_59, "height")])
	v_md_66 = J.gp(J.mc(v_mg_62, "getImageData", [0.0, 0.0, J.gp(v_c_59, "width"), J.gp(v_c_59, "height")]), "data")
	v_b_67 = J.gp(v_bd_65, "data")
	v_i_68 = 3.0
	while true:
		if not J.cmp(v_i_68, J.len(v_b_67), "<"): break
		v_m_69 = J.gp(v_md_66, v_i_68)
		if J.cmp(v_m_69, 8.0, ">"):
			J.sp(v_b_67, v_i_68, 0.0)
		else:
			if J.cmp(v_m_69, 0.0, ">"):
				var _t191 = J.bor(J.mul(J.gp(v_b_67, v_i_68), (1.0 - J.div(v_m_69, 8.0))), 0.0)
				J.sp(v_b_67, v_i_68, _t191)
		var _t192 = J.add(v_i_68, 4.0)
		v_i_68 = _t192
	J.mc(v_g_60, "putImageData", [v_bd_65, 0.0, 0.0])
	var _t193 = env["ok"]
	if J.t(J.cl(_t193, null, [J.add(v_id_55, "__fill")])):
		J.sp(v_g_60, "globalCompositeOperation", "destination-over")
		J.mc(v_g_60, "drawImage", [J.gp(J.G.get("SPR"), J.add(v_id_55, "__fill")), 0.0, 0.0, J.gp(v_c_59, "width"), J.gp(v_c_59, "height")])
	var _t194 = J.gp(v_c_59, "width")
	J.sp(v_c_59, "naturalWidth", _t194)
	var _t195 = J.gp(v_c_59, "height")
	J.sp(v_c_59, "naturalHeight", _t195)
	J.sp(v_c_59, "_ok", true)
	J.sp(v_c_59, "complete", true)
	var _t196 = J.G.get("SPR")
	J.sp(_t196, v_key_57, v_c_59)
	if J.t(J.gp(J.gp(J.G.get("MeshAnim"), "RIG"), v_id_55)):
		var _t197 = J.gp(J.G.get("MeshAnim"), "RIG")
		var _t198 = J.gp(J.gp(J.G.get("MeshAnim"), "RIG"), v_id_55)
		J.sp(_t197, v_key_57, _t198)
	return v_key_57

func _f9(this_, a: Array, env):
	var v_id_73 = null; var v_d_74 = null
	v_id_73 = J.arg(a, 0)
	v_d_74 = J.gp(env["DEF"], J.mc(v_id_73, "slice", [4.0]))
	var _t199 = (not J.t(v_d_74))
	if (_t199 if _t199 else (not J.t(J.gp(v_d_74, "cut")))):
		return null
	var _t200 = env["cutBody"]
	return J.cl(_t200, null, [v_id_73, J.gp(v_d_74, "cut"), J.add(v_id_73, "__nb")])

func _f2(this_, a: Array, env):
	var v_id_10 = null; var v_d_11 = null
	v_id_10 = J.arg(a, 0)
	v_d_11 = J.arg(a, 1)
	var _t201 = env["DEF"]
	J.sp(_t201, v_id_10, v_d_11)

func _f5(this_, a: Array, env):
	var v_k_45 = null
	v_k_45 = J.arg(a, 0)
	return J.add("n30_", v_k_45)

func _f6(this_, a: Array, env):
	var v_b_51 = null
	v_b_51 = J.arg(a, 0)
	return J.seq(J.gp(v_b_51, 0.0), "legF")

func _f7(this_, a: Array, env):
	var v_k_52 = null
	v_k_52 = J.arg(a, 0)
	var _t216 = J.seq(J.typeof_(J.G.get("sprOk")), "function")
	if J.t(_t216):
		var _t215 = J.G.get("sprOk")
		_t216 = J.cl(_t215, null, [v_k_52])
	return _t216

func _f10(this_, a: Array, env):
	var v_id_75 = null
	v_id_75 = J.arg(a, 0)
	var _t217 = J.gp(env["DEF"], J.mc(v_id_75, "replace", [J.re("^n30_", ""), ""]))
	return J.gp((_t217 if J.t(_t217) else {}), "zh")

func _f1(this_, a: Array, env):
	var v_G_3 = null; var v_tweaker_5 = null; var v_IDS_6 = null; var v_body_9 = null; var v_k_46 = null; var v_d_47 = null; var v_id_48 = null; var v_r_49 = null; var v_R_50 = null
	var _s2 = {"__p": env, "DEF": null, "S": null, "ok": null, "cutBody": null}
	v_tweaker_5 = Callable(self, "_f3").bind(_s2)
	_s2["cutBody"] = Callable(self, "_f8").bind(_s2)
	v_body_9 = Callable(self, "_f9").bind(_s2)
	_s2["DEF"] = {}
	v_G_3 = Callable(self, "_f2").bind(_s2)
	J.cl(v_G_3, null, ["diaosi", {"zh": "吊死鬼", "h": 60.0, "solid": 1.0, "loco": "creep", "rig": {"c": 0.5, "n": 0.36, "ht": 0.03, "hr": 0.3, "L": [0.3, 0.48, 0.1, 0.66], "R": [0.7, 0.48, 0.88, 0.66], "legs": [0.78, 0.36, 0.62], "hair": [0.14, 0.86], "x": [["rope", "head", 0.58, 0.42, 0.6, 0.58, 0.07]]}, "sec": {"rope": [0.1, 2.2, 0.5]}, "cut": ["tongue"]}])
	J.cl(v_G_3, null, ["wutou", {"zh": "無頭鬼", "h": 62.0, "solid": 1.0, "rig": {"c": 0.38, "n": 0.24, "h": 0.34, "ht": 0.04, "hr": 0.16, "L": [0.2, 0.36, 0.06, 0.62], "R": [0.58, 0.36, 0.86, 0.58], "legs": [0.84, 0.32, 0.52], "x": [["held", "armB", 0.72, 0.42, 0.74, 0.7, 0.17]]}, "sec": {"head": [0.12, 1.4, 0.0]}, "cut": ["head"]}])
	J.cl(v_G_3, null, ["yecha", {"zh": "夜叉", "h": 66.0, "solid": 1.0, "loco": "heavy", "rig": {"c": 0.56, "n": 0.4, "h": 0.62, "ht": 0.05, "hr": 0.3, "L": [0.4, 0.44, 0.2, 0.5], "R": [0.76, 0.46, 0.86, 0.68], "legs": [0.74, 0.44, 0.74], "hair": [0.4, 0.92]}, "sec": {"hairL": [0.08, 1.7, 0.0], "hairR": [0.1, 1.7, 1.0]}, "cut": ["trident"]}])
	J.cl(v_G_3, null, ["hanba", {"zh": "旱魃", "h": 60.0, "solid": 1.0, "loco": "creep", "rig": {"c": 0.48, "n": 0.36, "ht": 0.02, "hr": 0.34, "L": [0.32, 0.44, 0.08, 0.52], "R": [0.66, 0.44, 0.92, 0.54], "legs": [0.76, 0.42, 0.58], "hair": [0.3, 0.66]}}])
	J.cl(v_G_3, null, ["changgui", {"zh": "倀鬼", "h": 62.0, "solid": 1.0, "loco": "creep", "rig": {"c": 0.4, "n": 0.42, "h": 0.33, "ht": 0.03, "hr": 0.3, "L": [0.3, 0.48, 0.04, 0.5], "R": [0.58, 0.46, 0.64, 0.7], "legs": [0.7, 0.3, 0.54], "x": [["tiger", null, 0.8, 0.99, 0.79, 0.7, 0.15], ["tie", "head", 0.6, 0.13, 0.76, 0.17, 0.07]]}, "sec": {"tiger": [0.05, 3.1, 0.0]}, "cut": ["tiger"]}])
	J.cl(v_G_3, null, ["guixinniang", {"zh": "鬼新娘", "h": 62.0, "solid": 0.0, "loco": "float", "rig": {"c": 0.47, "n": 0.45, "ht": 0.02, "hr": 0.3, "L": [0.24, 0.48, 0.3, 0.62], "R": [0.64, 0.48, 0.56, 0.66], "tail": 0.48, "hair": [0.08, 0.88]}, "sec": {"hairL": [0.05, 1.3, 0.0], "hairR": [0.05, 1.3, 1.2]}, "cut": ["ball"]}])
	J.cl(v_G_3, null, ["shanxiao", {"zh": "山魈", "h": 64.0, "solid": 1.0, "loco": "onefoot", "rig": {"bones": [["hips", null, 0.48, 0.62, 0.48, 0.5, 0.22], ["legB", "hips", 0.5, 0.64, 0.5, 0.98, 0.1], ["legF", "hips", 0.4, 0.6, 0.33, 0.66, 0.09], ["body", "hips", 0.47, 0.58, 0.45, 0.36, 0.26], ["head", "body", 0.42, 0.36, 0.42, 0.04, 0.3], ["armF", "body", 0.26, 0.4, 0.12, 0.86, 0.13], ["armB", "body", 0.72, 0.4, 0.88, 0.86, 0.13], ["hairL", "head", 0.16, 0.3, 0.1, 0.6, 0.12], ["hairR", "head", 0.8, 0.3, 0.88, 0.6, 0.12]]}}])
	J.cl(v_G_3, null, ["baigujing", {"zh": "白骨精", "h": 64.0, "solid": 0.0, "loco": "float", "rig": {"c": 0.48, "n": 0.32, "h": 0.45, "ht": 0.02, "hr": 0.28, "L": [0.36, 0.38, 0.22, 0.3], "R": [0.62, 0.4, 0.8, 0.66], "tail": 0.52, "hair": [0.22, 0.72], "x": [["orn", "head", 0.84, 0.12, 0.85, 0.3, 0.06]]}, "sec": {"orn": [0.14, 2.6, 0.0]}}])
	J.cl(v_G_3, null, ["qionggui", {"zh": "窮鬼", "h": 56.0, "solid": 0.0, "loco": "float", "rig": {"c": 0.4, "n": 0.38, "ht": 0.02, "hr": 0.3, "L": [0.26, 0.46, 0.1, 0.62], "R": [0.56, 0.46, 0.66, 0.62], "tail": 0.3, "x": [["moth", null, 0.84, 0.46, 0.84, 0.4, 0.07]]}, "sec": {"moth": [0.25, 5.0, 0.0]}, "cut": ["moth"]}])
	J.cl(v_G_3, null, ["dugui", {"zh": "賭鬼", "h": 58.0, "solid": 0.0, "loco": "float", "rig": {"c": 0.45, "n": 0.5, "ht": 0.04, "hr": 0.34, "L": [0.3, 0.56, 0.15, 0.5], "R": [0.66, 0.56, 0.84, 0.44], "tail": 0.25}, "cut": ["dice"]}])
	J.cl(v_G_3, null, ["jiugui", {"zh": "酒鬼", "h": 58.0, "solid": 0.0, "loco": "drunk", "rig": {"c": 0.4, "n": 0.36, "h": 0.32, "ht": 0.02, "hr": 0.3, "L": [0.24, 0.42, 0.36, 0.52], "R": [0.56, 0.4, 0.68, 0.48], "tail": 0.25, "x": [["tie", "head", 0.16, 0.16, 0.02, 0.2, 0.08]]}}])
	J.cl(v_G_3, null, ["yangui", {"zh": "煙鬼", "h": 58.0, "solid": 0.0, "loco": "float", "nr": 1.0, "rig": {"c": 0.4, "n": 0.38, "ht": 0.03, "hr": 0.32, "L": [0.3, 0.44, 0.34, 0.38], "R": [0.5, 0.44, 0.64, 0.44], "tail": 0.34}}])
	J.cl(v_G_3, null, ["guhangui", {"zh": "孤寒鬼", "h": 60.0, "solid": 1.0, "loco": "creep", "rig": {"c": 0.46, "n": 0.42, "h": 0.4, "ht": 0.02, "hr": 0.3, "L": [0.3, 0.48, 0.16, 0.36], "R": [0.7, 0.5, 0.7, 0.64], "legs": [0.78, 0.3, 0.55], "x": [["orn", "head", 0.83, 0.13, 0.83, 0.4, 0.06]]}, "sec": {"orn": [0.12, 2.3, 0.0]}, "cut": ["abacus"]}])
	J.cl(v_G_3, null, ["taozhai", {"zh": "討債鬼", "h": 62.0, "solid": 1.0, "loco": "heavy", "rig": {"c": 0.5, "n": 0.42, "h": 0.48, "ht": 0.03, "hr": 0.3, "L": [0.3, 0.42, 0.17, 0.28], "R": [0.72, 0.46, 0.8, 0.6], "legs": [0.74, 0.34, 0.6], "x": [["tie", "head", 0.74, 0.27, 0.84, 0.38, 0.07], ["paper", "armF", 0.12, 0.28, 0.12, 0.66, 0.11]]}, "sec": {"paper": [0.06, 1.9, 0.4]}, "cut": ["bucket"]}])
	J.cl(v_G_3, null, ["danxiao", {"zh": "膽小鬼", "h": 56.0, "solid": 1.0, "loco": "shiver", "nr": 1.0, "rig": {"c": 0.5, "n": 0.4, "ht": 0.02, "hr": 0.32, "L": [0.32, 0.44, 0.6, 0.48], "R": [0.66, 0.44, 0.4, 0.5], "legs": [0.76, 0.4, 0.6], "hair": [0.2, 0.82]}}])
	J.cl(v_G_3, null, ["maoshi", {"zh": "冒失鬼", "h": 58.0, "solid": 1.0, "loco": "stumble", "rig": {"c": 0.42, "n": 0.42, "h": 0.3, "ht": 0.04, "hr": 0.3, "L": [0.28, 0.46, 0.04, 0.42], "R": [0.52, 0.44, 0.62, 0.4], "legs": [0.66, 0.38, 0.62]}}])
	J.cl(v_G_3, null, ["hanturaya", {"zh": "Hantu Raya", "h": 76.0, "solid": 1.0, "loco": "heavy", "rig": {"c": 0.48, "n": 0.28, "ht": 0.02, "hr": 0.26, "L": [0.26, 0.32, 0.14, 0.82], "R": [0.72, 0.32, 0.86, 0.82], "legs": [0.62, 0.36, 0.62], "hair": [0.08, 0.9]}, "sec": {"hairL": [0.1, 1.2, 0.0], "hairR": [0.1, 1.2, 1.5]}}])
	J.cl(v_G_3, null, ["polong", {"zh": "Polong", "h": 58.0, "solid": 1.0, "loco": "bottle", "rig": {"bones": [["body", null, 0.48, 0.97, 0.48, 0.62, 0.3], ["tail1", "body", 0.46, 0.58, 0.44, 0.44, 0.13], ["tail2", "tail1", 0.44, 0.44, 0.4, 0.32, 0.12], ["head", "tail2", 0.36, 0.33, 0.32, 0.03, 0.22], ["armF", "tail1", 0.34, 0.4, 0.08, 0.43, 0.1], ["armB", "tail1", 0.5, 0.42, 0.48, 0.52, 0.09], ["hairL", "head", 0.18, 0.25, 0.08, 0.4, 0.1], ["hairR", "head", 0.55, 0.15, 0.92, 0.4, 0.16]]}, "sec": {"hairR": [0.1, 1.6, 0.0]}, "cut": ["spirit"]}])
	J.cl(v_G_3, null, ["pelesit", {"zh": "Pelesit", "h": 42.0, "solid": 1.0, "loco": "skitter", "rig": {"bones": [["body", null, 0.6, 0.7, 0.3, 0.45, 0.3], ["head", "body", 0.3, 0.45, 0.14, 0.45, 0.17], ["hairL", "head", 0.22, 0.3, 0.42, 0.05, 0.1], ["hairR", "head", 0.26, 0.3, 0.7, 0.08, 0.1], ["legF", "body", 0.3, 0.66, 0.2, 0.95, 0.12], ["legB", "body", 0.7, 0.5, 0.86, 0.96, 0.15], ["cape", "body", 0.55, 0.4, 0.85, 0.45, 0.14]]}}])
	J.cl(v_G_3, null, ["jenglot", {"zh": "Jenglot", "h": 50.0, "solid": 1.0, "loco": "creep", "rig": {"c": 0.45, "n": 0.4, "h": 0.42, "ht": 0.03, "hr": 0.3, "L": [0.32, 0.44, 0.2, 0.74], "R": [0.58, 0.44, 0.66, 0.72], "legs": [0.78, 0.36, 0.56], "x": [["hairL", "head", 0.18, 0.3, 0.08, 0.86, 0.15], ["hairR", "head", 0.76, 0.3, 0.88, 0.86, 0.15]]}, "sec": {"hairL": [0.06, 1.3, 0.0], "hairR": [0.06, 1.3, 1.1]}}])
	J.cl(v_G_3, null, ["hantugalah", {"zh": "Hantu Galah", "h": 86.0, "solid": 1.0, "loco": "stride", "nr": 1.0, "rig": {"c": 0.46, "n": 0.24, "h": 0.55, "ht": 0.02, "hr": 0.4, "L": [0.36, 0.28, 0.28, 0.5], "R": [0.6, 0.28, 0.86, 0.36], "legs": [0.5, 0.3, 0.62], "hair": [0.24, 0.8], "ar": 0.18}}])
	J.cl(v_G_3, null, ["jerangkung", {"zh": "Jerangkung", "h": 62.0, "solid": 1.0, "loco": "creep", "nr": 1.0, "rig": {"c": 0.38, "n": 0.32, "h": 0.48, "ht": 0.03, "hr": 0.28, "L": [0.36, 0.33, 0.06, 0.58], "R": [0.5, 0.34, 0.92, 0.44], "legs": [0.64, 0.18, 0.54], "hair": [0.3, 0.66]}, "cut": ["arm"]}])
	J.cl(v_G_3, null, ["genderuwo", {"zh": "Genderuwo", "h": 70.0, "solid": 1.0, "loco": "heavy", "rig": {"c": 0.5, "n": 0.34, "ht": 0.02, "hr": 0.3, "L": [0.26, 0.4, 0.1, 0.78], "R": [0.74, 0.4, 0.9, 0.74], "legs": [0.74, 0.32, 0.66]}}])
	J.cl(v_G_3, null, ["bunian", {"zh": "Orang Bunian", "h": 62.0, "solid": 0.0, "loco": "float", "nr": 1.0, "rig": {"c": 0.48, "n": 0.28, "ht": 0.02, "hr": 0.26, "L": [0.34, 0.36, 0.14, 0.42], "R": [0.6, 0.36, 0.86, 0.4], "tail": 0.52, "hair": [0.32, 0.66]}, "sec": {"hairL": [0.06, 1.2, 0.0], "hairR": [0.06, 1.2, 1.0]}}])
	J.cl(v_G_3, null, ["maenak", {"zh": "Mae Nak", "h": 62.0, "solid": 1.0, "rig": {"c": 0.64, "n": 0.38, "h": 0.62, "ht": 0.02, "hr": 0.28, "L": [0.56, 0.4, 0.06, 0.48], "R": [0.78, 0.45, 0.88, 0.72], "legs": [0.74, 0.55, 0.7], "hair": [0.52, 0.9], "ar": 0.1}, "cut": ["arm", "hand"]}])
	J.cl(v_G_3, null, ["phiam", {"zh": "Phi Am", "h": 54.0, "solid": 1.0, "loco": "heavy", "rig": {"c": 0.42, "n": 0.5, "ht": 0.08, "hr": 0.34, "L": [0.2, 0.52, 0.14, 0.78], "R": [0.62, 0.52, 0.6, 0.78], "legs": [0.8, 0.2, 0.56], "x": [["tie", "head", 0.62, 0.16, 0.84, 0.25, 0.1]]}}])
	J.cl(v_G_3, null, ["churel", {"zh": "Churel", "h": 64.0, "solid": 1.0, "rig": {"c": 0.42, "n": 0.34, "h": 0.4, "ht": 0.02, "hr": 0.3, "L": [0.3, 0.4, 0.14, 0.62], "R": [0.62, 0.4, 0.66, 0.64], "legs": [0.72, 0.42, 0.6], "hair": [0.14, 0.86]}, "sec": {"hairR": [0.06, 1.4, 0.0]}}])
	J.cl(v_G_3, null, ["vetala", {"zh": "Vetala", "h": 66.0, "solid": 1.0, "loco": "creep", "rig": {"c": 0.46, "n": 0.34, "h": 0.36, "ht": 0.04, "hr": 0.28, "L": [0.3, 0.4, 0.12, 0.48], "R": [0.56, 0.4, 0.62, 0.62], "legs": [0.72, 0.38, 0.64], "x": [["cape", "body", 0.7, 0.3, 0.88, 0.52, 0.12]]}}])
	J.cl(v_G_3, null, ["kappa", {"zh": "河童", "h": 54.0, "solid": 1.0, "loco": "creep", "rig": {"c": 0.48, "n": 0.36, "h": 0.45, "ht": 0.02, "hr": 0.3, "L": [0.36, 0.44, 0.16, 0.42], "R": [0.62, 0.46, 0.62, 0.7], "legs": [0.7, 0.32, 0.58]}}])
	J.cl(v_G_3, null, ["rokurokubi", {"zh": "轆轤首", "h": 62.0, "solid": 1.0, "loco": "neck", "rig": {"bones": [["body", null, 0.68, 0.95, 0.64, 0.6, 0.3], ["neck1", "body", 0.61, 0.58, 0.72, 0.36, 0.08], ["neck2", "neck1", 0.72, 0.34, 0.48, 0.29, 0.08], ["head", "neck2", 0.44, 0.3, 0.25, 0.1, 0.24], ["armF", "body", 0.52, 0.64, 0.38, 0.78, 0.1], ["armB", "body", 0.74, 0.64, 0.7, 0.8, 0.1]]}, "cut": ["head", "neck"]}])
	J.cl(v_G_3, null, ["kuchisake", {"zh": "裂口女", "h": 62.0, "solid": 1.0, "rig": {"c": 0.5, "n": 0.3, "h": 0.47, "ht": 0.02, "hr": 0.26, "L": [0.36, 0.38, 0.2, 0.52], "R": [0.68, 0.4, 0.74, 0.66], "legs": [0.74, 0.42, 0.58], "hair": [0.26, 0.8]}, "sec": {"hairR": [0.05, 1.3, 0.0]}, "cut": ["scissors"]}])
	J.cl(v_G_3, null, ["yukionna", {"zh": "雪女", "h": 64.0, "solid": 0.0, "loco": "float", "rig": {"c": 0.56, "n": 0.33, "h": 0.55, "ht": 0.03, "hr": 0.28, "L": [0.42, 0.42, 0.26, 0.48], "R": [0.68, 0.42, 0.72, 0.6], "tail": 0.56, "hair": [0.42, 0.94]}, "sec": {"hairR": [0.08, 1.1, 0.0]}}])
	J.cl(v_G_3, null, ["kasaobake", {"zh": "唐傘妖", "h": 58.0, "solid": 1.0, "loco": "onefoot", "nr": 1.0, "rig": {"bones": [["body", null, 0.45, 0.98, 0.45, 0.62, 0.13], ["head", "body", 0.45, 0.62, 0.45, 0.03, 0.45], ["tongue", "head", 0.58, 0.48, 0.75, 0.66, 0.1], ["tie", "head", 0.12, 0.58, 0.06, 0.74, 0.08], ["legF", "body", 0.44, 0.75, 0.36, 0.84, 0.06]]}, "sec": {"tongue": [0.12, 2.4, 0.0]}, "cut": ["tongue"]}])
	J.cl(v_G_3, null, ["nopperabo", {"zh": "無臉鬼", "h": 64.0, "solid": 1.0, "rig": {"c": 0.6, "n": 0.36, "ht": 0.02, "hr": 0.3, "L": [0.38, 0.42, 0.22, 0.64], "R": [0.78, 0.42, 0.88, 0.68], "legs": [0.62, 0.42, 0.7]}, "cut": ["case"]}])
	J.cl(v_G_3, null, ["chochin", {"zh": "提燈妖", "h": 56.0, "solid": 0.0, "loco": "float", "nr": 1.0, "rig": {"bones": [["body", null, 0.5, 0.95, 0.5, 0.2, 0.4], ["head", "body", 0.5, 0.22, 0.48, 0.1, 0.1], ["tongue", "body", 0.6, 0.62, 0.7, 0.86, 0.1], ["stick", "body", 0.38, 0.1, 0.1, 0.3, 0.14], ["tie", "stick", 0.1, 0.3, 0.1, 0.6, 0.09], ["flame", null, 0.9, 0.3, 0.9, 0.08, 0.09]]}, "sec": {"tongue": [0.1, 2.2, 0.0], "flame": [0.12, 5.5, 0.0], "stick": [0.03, 1.4, 0.5]}}])
	J.cl(v_G_3, null, ["gashadokuro", {"zh": "餓者髑髏", "h": 72.0, "solid": 1.0, "loco": "heavy", "rig": {"bones": [["body", null, 0.7, 0.62, 0.4, 0.3, 0.3], ["head", "body", 0.32, 0.3, 0.18, 0.18, 0.18], ["armF", "body", 0.32, 0.42, 0.1, 0.88, 0.12], ["armB", "body", 0.56, 0.4, 0.62, 0.88, 0.12], ["legF", "body", 0.76, 0.5, 0.74, 0.92, 0.11], ["legB", "body", 0.88, 0.4, 0.88, 0.8, 0.1]]}}])
	J.cl(v_G_3, null, ["banshee", {"zh": "Banshee", "h": 62.0, "solid": 0.0, "loco": "float", "rig": {"c": 0.5, "n": 0.38, "ht": 0.02, "hr": 0.3, "L": [0.3, 0.46, 0.18, 0.64], "R": [0.7, 0.46, 0.8, 0.64], "tail": 0.5, "hair": [0.12, 0.88]}, "sec": {"hairL": [0.09, 1.0, 0.0], "hairR": [0.09, 1.0, 1.3]}}])
	J.cl(v_G_3, null, ["hannya", {"zh": "般若", "h": 62.0, "solid": 0.0, "loco": "float", "rig": {"c": 0.44, "n": 0.38, "h": 0.42, "ht": 0.02, "hr": 0.3, "L": [0.3, 0.44, 0.06, 0.48], "R": [0.66, 0.44, 0.94, 0.5], "tail": 0.45, "hair": [0.14, 0.76]}}])
	J.cl(v_G_3, null, ["aswang", {"zh": "Aswang", "h": 60.0, "solid": 1.0, "loco": "creep", "rig": {"c": 0.46, "n": 0.36, "h": 0.32, "ht": 0.04, "hr": 0.28, "L": [0.36, 0.42, 0.18, 0.68], "R": [0.52, 0.44, 0.46, 0.72], "legs": [0.68, 0.3, 0.6], "hair": [0.12, 0.78], "x": [["cape", "body", 0.58, 0.4, 0.86, 0.56, 0.14]]}, "cut": ["tongue"]}])
	J.cl(v_G_3, null, ["tikbalang", {"zh": "Tikbalang", "h": 68.0, "solid": 1.0, "loco": "stride", "rig": {"c": 0.5, "n": 0.32, "h": 0.32, "ht": 0.02, "hr": 0.24, "L": [0.4, 0.36, 0.2, 0.55], "R": [0.58, 0.36, 0.7, 0.46], "legs": [0.54, 0.4, 0.66], "x": [["cape", "body", 0.7, 0.36, 0.86, 0.66, 0.12]], "hair": [0.42, 0.6]}}])
	J.cl(v_G_3, null, ["chehuo", {"zh": "車禍鬼", "h": 60.0, "solid": 1.0, "grp": "death", "rig": {"c": 0.52, "n": 0.4, "h": 0.47, "ht": 0.02, "hr": 0.34, "L": [0.32, 0.44, 0.24, 0.44], "R": [0.76, 0.46, 0.88, 0.7], "legs": [0.72, 0.36, 0.64]}}])
	J.cl(v_G_3, null, ["diansi", {"zh": "電死鬼", "h": 60.0, "solid": 1.0, "grp": "death", "loco": "twitch", "rig": {"c": 0.55, "n": 0.48, "ht": 0.02, "hr": 0.4, "L": [0.4, 0.52, 0.18, 0.55], "R": [0.68, 0.52, 0.76, 0.74], "legs": [0.76, 0.42, 0.62], "hair": [0.26, 0.86], "x": [["tie", "armF", 0.14, 0.58, 0.1, 0.9, 0.07]]}, "sec": {"hairL": [0.05, 7.0, 0.0], "hairR": [0.05, 7.0, 1.0]}}])
	J.cl(v_G_3, null, ["dongsi", {"zh": "凍死鬼", "h": 60.0, "solid": 1.0, "grp": "death", "loco": "shiver", "rig": {"c": 0.48, "n": 0.4, "ht": 0.02, "hr": 0.32, "L": [0.34, 0.46, 0.5, 0.52], "R": [0.64, 0.46, 0.5, 0.5], "legs": [0.78, 0.42, 0.62]}}])
	J.cl(v_G_3, null, ["yezi", {"zh": "椰子砸死鬼", "h": 58.0, "solid": 1.0, "grp": "death", "loco": "stumble", "rig": {"c": 0.44, "n": 0.48, "h": 0.42, "ht": 0.05, "hr": 0.36, "L": [0.26, 0.55, 0.14, 0.66], "R": [0.56, 0.52, 0.4, 0.64], "legs": [0.78, 0.3, 0.56]}}])
	J.cl(v_G_3, null, ["liulian", {"zh": "榴槤砸死鬼", "h": 58.0, "solid": 1.0, "grp": "death", "rig": {"c": 0.46, "n": 0.48, "h": 0.42, "ht": 0.03, "hr": 0.36, "L": [0.3, 0.52, 0.15, 0.66], "R": [0.62, 0.52, 0.6, 0.66], "legs": [0.78, 0.35, 0.62]}}])
	J.cl(v_G_3, null, ["yesi", {"zh": "噎死鬼", "h": 60.0, "solid": 1.0, "grp": "death", "rig": {"c": 0.5, "n": 0.4, "ht": 0.02, "hr": 0.32, "L": [0.34, 0.44, 0.14, 0.5], "R": [0.68, 0.46, 0.7, 0.64], "legs": [0.78, 0.4, 0.66]}}])
	J.cl(v_G_3, null, ["xiaosi", {"zh": "笑死鬼", "h": 58.0, "solid": 1.0, "grp": "death", "loco": "laugh", "rig": {"c": 0.46, "n": 0.42, "h": 0.38, "ht": 0.02, "hr": 0.32, "L": [0.34, 0.48, 0.4, 0.56], "R": [0.6, 0.44, 0.56, 0.56], "legs": [0.72, 0.3, 0.7]}}])
	J.cl(v_G_3, null, ["xiasi", {"zh": "嚇死鬼", "h": 62.0, "solid": 1.0, "grp": "death", "loco": "shiver", "rig": {"c": 0.48, "n": 0.4, "ht": 0.02, "hr": 0.3, "L": [0.3, 0.44, 0.08, 0.38], "R": [0.66, 0.44, 0.86, 0.38], "legs": [0.72, 0.3, 0.62], "hair": [0.24, 0.86]}, "sec": {"hairL": [0.04, 9.0, 0.0], "hairR": [0.04, 9.0, 1.0]}}])
	J.cl(v_G_3, null, ["leipi", {"zh": "雷劈鬼", "h": 58.0, "solid": 0.0, "grp": "death", "loco": "float", "rig": {"c": 0.35, "n": 0.5, "h": 0.35, "ht": 0.05, "hr": 0.3, "L": [0.24, 0.55, 0.1, 0.68], "R": [0.46, 0.55, 0.64, 0.62], "tail": 0.3, "x": [["umb", "armB", 0.66, 0.62, 0.74, 0.25, 0.17]]}, "sec": {"umb": [0.05, 1.6, 0.0]}}])
	J.cl(v_G_3, null, ["zipai", {"zh": "自拍跌死鬼", "h": 58.0, "solid": 0.0, "grp": "death", "loco": "float", "nr": 1.0, "rig": {"c": 0.36, "n": 0.46, "h": 0.38, "ht": 0.02, "hr": 0.3, "L": [0.26, 0.52, 0.1, 0.52], "R": [0.48, 0.55, 0.62, 0.58], "tail": 0.32, "x": [["stick", "armB", 0.62, 0.58, 0.8, 0.16, 0.08]]}, "sec": {"stick": [0.04, 1.3, 0.0]}}])
	J.cl(v_G_3, null, ["zhongshu", {"zh": "中暑鬼", "h": 60.0, "solid": 0.0, "grp": "death", "loco": "float", "rig": {"c": 0.46, "n": 0.46, "h": 0.45, "ht": 0.05, "hr": 0.34, "L": [0.3, 0.52, 0.16, 0.56], "R": [0.62, 0.52, 0.7, 0.46], "tail": 0.4}, "sec": {"armB": [0.04, 2.0, 0.0]}}])
	J.cl(v_G_3, null, ["chengsi", {"zh": "撐死鬼", "h": 62.0, "solid": 0.0, "grp": "death", "loco": "float", "rig": {"c": 0.5, "n": 0.38, "h": 0.38, "ht": 0.02, "hr": 0.28, "L": [0.22, 0.42, 0.08, 0.38], "R": [0.66, 0.36, 0.82, 0.26], "tail": 0.4}}])
	J.cl(v_G_3, null, ["shedu", {"zh": "蛇咬鬼", "h": 60.0, "solid": 1.0, "grp": "death", "loco": "flee", "rig": {"c": 0.42, "n": 0.46, "h": 0.38, "ht": 0.02, "hr": 0.32, "L": [0.26, 0.5, 0.04, 0.45], "R": [0.36, 0.56, 0.14, 0.64], "legs": [0.7, 0.26, 0.46], "x": [["snake", "hips", 0.8, 0.7, 0.9, 0.48, 0.12]]}, "sec": {"snake": [0.08, 3.3, 0.0]}, "cut": ["snake"]}])
	J.cl(v_G_3, null, ["shidu", {"zh": "食物中毒鬼", "h": 58.0, "solid": 1.0, "grp": "death", "loco": "creep", "rig": {"c": 0.46, "n": 0.4, "h": 0.42, "ht": 0.02, "hr": 0.3, "L": [0.3, 0.46, 0.42, 0.6], "R": [0.62, 0.46, 0.7, 0.62], "legs": [0.76, 0.36, 0.6], "x": [["tie", "armB", 0.74, 0.58, 0.8, 0.76, 0.08]]}, "sec": {"tie": [0.12, 2.5, 0.0]}}])
	J.cl(v_G_3, null, ["daji", {"zh": "打機猝死鬼", "h": 60.0, "solid": 1.0, "grp": "death", "loco": "creep", "rig": {"c": 0.44, "n": 0.46, "h": 0.42, "ht": 0.02, "hr": 0.32, "L": [0.26, 0.52, 0.32, 0.62], "R": [0.62, 0.52, 0.52, 0.62], "legs": [0.76, 0.36, 0.56], "x": [["tie", "body", 0.14, 0.66, 0.1, 0.88, 0.07]]}, "sec": {"tie": [0.06, 1.7, 0.0]}}])
	J.cl(v_G_3, null, ["xiangcai", {"zh": "大象踩扁鬼", "h": 44.0, "solid": 1.0, "grp": "death", "loco": "paper", "rig": {"bones": [["body", null, 0.52, 0.66, 0.45, 0.52, 0.42], ["head", "body", 0.5, 0.52, 0.44, 0.38, 0.16], ["armF", "body", 0.3, 0.46, 0.06, 0.38, 0.11], ["armB", "body", 0.72, 0.48, 0.94, 0.36, 0.11], ["legF", "body", 0.3, 0.78, 0.06, 0.82, 0.11], ["legB", "body", 0.74, 0.78, 0.96, 0.82, 0.11], ["bubble", null, 0.72, 0.3, 0.82, 0.1, 0.16]]}, "sec": {"bubble": [0.05, 1.8, 0.0]}}])
	_s2["S"] = J.gp(J.G.get("Math"), "sin")
	var _t202 = J.S_Object_("keys", [_s2["DEF"]])
	v_IDS_6 = J.mc(_t202, "map", [Callable(self, "_f5").bind(_s2)])
	for _t203 in J.keys(_s2["DEF"]):
		v_k_46 = _t203
		v_d_47 = J.gp(_s2["DEF"], v_k_46)
		v_id_48 = J.add("n30_", v_k_46)
		v_r_49 = J.gp(v_d_47, "rig")
		var _t206 = null
		if J.t(J.gp(v_r_49, "bones")):
			var _t205 = J.gp(v_r_49, "bones")
			var _t204 = J.gp(v_r_49, "bones")
			_t206 = {"bones": _t205, "legs": (not (not J.t(J.mc(_t204, "find", [Callable(self, "_f6").bind(_s2)]))))}
		else:
			_t206 = J.mc(J.G.get("MeshAnim"), "mk", [v_r_49])
		v_R_50 = _t206
		if J.t(J.gp(v_r_49, "x")):
			var _t207 = J.gp(v_R_50, "bones")
			var _t208 = J.mc(_t207, "concat", [J.gp(v_r_49, "x")])
			J.sp(v_R_50, "bones", _t208)
		var _t209 = J.cl(v_tweaker_5, null, [v_d_47])
		J.sp(v_R_50, "tweak", _t209)
		var _t210 = J.gp(J.G.get("MeshAnim"), "RIG")
		J.sp(_t210, v_id_48, v_R_50)
		if J.t(J.gp(v_d_47, "nr")):
			var _t211 = J.gp(J.G.get("MeshAnim"), "NATIVE_R")
			J.sp(_t211, v_id_48, 1.0)
		var _t212 = J.gp(J.G.get("ART"), "CHAR_H")
		var _t213 = J.gp(v_d_47, "h")
		J.sp(_t212, v_id_48, _t213)
		if J.t(J.gp(v_d_47, "solid")):
			var _t214 = J.gp(J.G.get("ART"), "SOLID")
			J.sp(_t214, v_id_48, 1.0)
	_s2["ok"] = Callable(self, "_f7").bind(_s2)
	return {"DEF": _s2["DEF"], "IDS": v_IDS_6, "body": v_body_9, "cutBody": _s2["cutBody"], "name": Callable(self, "_f10").bind(_s2)}
