# 自動轉譯自 policy.js（tools/jsgd.js）——唔好直接改，改原 JS 再轉
extends RefCounted

func run(env):
	var this_ = null; var a = []
	J.G["Policy"] = J.cl(Callable(self, "_f1").bind(env), null, [])
	var _t59 = J.G.get("window")
	var _t60 = J.G.get("Policy")
	J.sp(_t59, "Policy", _t60)

func _f4(this_, a: Array, env):
	var v_k_22 = null; var v_e_23 = null
	v_k_22 = J.arg(a, 0)
	var _t1 = J.G.get("S")
	var _t2 = J.gp(J.G.get("S"), "seen")
	var _t3 = (_t2 if J.t(_t2) else {})
	J.sp(_t1, "seen", _t3)
	var _t4 = J.gp(J.G.get("S"), "seen")
	J.sp(_t4, v_k_22, true)
	J.cl(J.G.get("save"), null, [])

func _f6(this_, a: Array, env):
	return (J.cl(env["cb"], null, []) if J.t(env["cb"]) else env["cb"])

func _f5(this_, a: Array, env):
	var v_title_26 = null; var v_lines_27 = null
	var _s9 = {"__p": env, "cb": null}
	v_title_26 = J.arg(a, 0)
	v_lines_27 = J.arg(a, 1)
	_s9["cb"] = J.arg(a, 2)
	J.mc(J.G.get("Theater"), "play", [{"tag": "新政策", "title": v_title_26, "bg": "hq", "cast": J.cl(_s9["__p"]["cast"], null, []), "lines": v_lines_27}, Callable(self, "_f6").bind(_s9)])

func _f9(this_, a: Array, env):
	var v_w_52 = null; var v_t_53 = null; var v_bd_54 = null; var v_bt_55 = null; var v_bh_56 = null; var v_above_57 = null
	var _t10 = J.gp(env["lines"], env["i"])
	var _t11 = J.gp(_t10, 0.0)
	v_w_52 = _t11
	var _t12 = J.gp(_t10, 1.0)
	v_t_53 = _t12
	var _t13 = J.mc(env["box"], "querySelector", ["b"])
	J.sp(_t13, "textContent", v_w_52)
	var _t14 = J.mc(env["box"], "querySelector", ["span"])
	var _t16 = null
	if J.seq(J.typeof_(J.G.get("L")), "function"):
		var _t15 = J.G.get("L")
		_t16 = J.cl(_t15, null, [v_t_53])
	else:
		_t16 = v_t_53
	J.sp(_t14, "textContent", _t16)
	v_bd_54 = J.mc(env["wm"], "querySelector", [".wm-board"])
	v_bt_55 = (J.sub(J.gp(J.mc(v_bd_54, "getBoundingClientRect", []), "top"), J.gp(env["hr"], "top")) if J.t(v_bd_54) else (J.sub(env["y"], env["pad"]) - 30.0))
	v_bh_56 = J.gp(env["box"], "offsetHeight")
	v_above_57 = (J.sub(J.min_([v_bt_55, (J.sub(env["y"], env["pad"]) - 20.0)]), v_bh_56) - 8.0)
	if J.cmp(v_above_57, 56.0, ">="):
		var _t17 = J.gp(env["box"], "style")
		var _t18 = J.add(v_above_57, "px")
		J.sp(_t17, "top", _t18)
		var _t19 = J.gp(env["box"], "style")
		J.sp(_t19, "bottom", "")
	else:
		var _t20 = J.gp(env["box"], "style")
		var _t21 = J.add(J.add(J.add(J.add(env["y"], J.gp(env["r"], "height")), env["pad"]), 12.0), "px")
		J.sp(_t20, "top", _t21)

func _f10(this_, a: Array, env):
	var v_e_58 = null
	v_e_58 = J.arg(a, 0)
	J.mc(v_e_58, "stopPropagation", [])
	if (J.sub(J.S_performance_("now", []), env["t0"]) < 350.0):
		return null
	if J.t(J.gp(J.G.get("Sound"), "play")):
		J.mc(J.G.get("Sound"), "play", ["click"])
	env["i"] = J.num(env["i"]) + 1.0
	if (env["i"] < J.len(env["lines"])):
		J.cl(env["show"], null, [])
	else:
		J.mc(env["ov"], "remove", [])
		J.cl(env["cb"], null, [])

func _f8(this_, a: Array, env):
	var v_id_35 = null; var v_card_39 = null; var v_host_40 = null; var v_x_44 = null; var v_e_51 = null
	var _s12 = {"__p": env, "lines": null, "cb": null, "wm": null, "ov": null, "hr": null, "r": null, "y": null, "pad": null, "box": null, "i": null, "show": null, "t0": null}
	v_id_35 = J.arg(a, 0)
	_s12["lines"] = J.arg(a, 1)
	_s12["cb"] = J.arg(a, 2)
	_s12["wm"] = J.S_document_("getElementById", ["world"])
	v_card_39 = (J.mc(_s12["wm"], "querySelector", [(".wm-card[data-id=\"" + J.str(v_id_35) + "\"]")]) if J.t(_s12["wm"]) else _s12["wm"])
	if (not J.t(v_card_39)):
		J.cl(_s12["cb"], null, [])
		return null
	J.mc(v_card_39, "scrollIntoView", [{"block": "nearest"}])
	var _t5 = J.S_document_("getElementById", ["app"])
	v_host_40 = (_t5 if J.t(_t5) else J.gp(J.G.get("document"), "body"))
	_s12["ov"] = J.S_document_("getElementById", ["pol-ov"])
	if J.t(_s12["ov"]):
		J.mc(_s12["ov"], "remove", [])
	var _t6 = J.S_document_("createElement", ["div"])
	_s12["ov"] = _t6
	var _t7 = _s12["ov"]
	J.sp(_t7, "id", "pol-ov")
	J.mc(v_host_40, "appendChild", [_s12["ov"]])
	_s12["hr"] = J.mc(_s12["ov"], "getBoundingClientRect", [])
	_s12["r"] = J.mc(v_card_39, "getBoundingClientRect", [])
	v_x_44 = J.sub(J.gp(_s12["r"], "left"), J.gp(_s12["hr"], "left"))
	_s12["y"] = J.sub(J.gp(_s12["r"], "top"), J.gp(_s12["hr"], "top"))
	_s12["pad"] = 5.0
	var _t8 = _s12["ov"]
	var _t9 = ("<i class=\"pol-ring\" style=\"left:" + J.str(J.sub(v_x_44, _s12["pad"])) + "px;top:" + J.str(J.sub(_s12["y"], _s12["pad"])) + "px;width:" + J.str(J.add(J.gp(_s12["r"], "width"), J.mul(_s12["pad"], 2.0))) + "px;height:" + J.str(J.add(J.gp(_s12["r"], "height"), J.mul(_s12["pad"], 2.0))) + "px\"></i>\n      <i class=\"pol-arr\" style=\"left:" + J.str(J.add(v_x_44, J.div(J.gp(_s12["r"], "width"), 2.0))) + "px;top:" + J.str((J.sub(_s12["y"], _s12["pad"]) - 14.0)) + "px\"></i><div class=\"pol-box\"><b></b><span></span><small>撳一下繼續 ▸</small></div>")
	J.sp(_t8, "innerHTML", _t9)
	_s12["box"] = J.mc(_s12["ov"], "querySelector", [".pol-box"])
	_s12["i"] = 0.0
	_s12["show"] = Callable(self, "_f9").bind(_s12)
	J.cl(_s12["show"], null, [])
	_s12["t0"] = J.S_performance_("now", [])
	var _t22 = _s12["ov"]
	var _t23 = Callable(self, "_f10").bind(_s12)
	J.sp(_t22, "onclick", _t23)

func _f12(this_, a: Array, env):
	env["__p"]["busy"] = false

func _f13(this_, a: Array, env):
	return (not (not J.t(J.S_document_("querySelector", ["#world .wm-card[data-id=\"tower\"]"]))))

func _f17(this_, a: Array, env):
	var _t28 = env["__p"]["stage"]
	return J.cl(_t28, null, ["KPI", env["__p"]["C"], env["end"]])

func _f16(this_, a: Array, env):
	var _t27 = env["__p"]["point"]
	return J.cl(_t27, null, ["tower", env["__p"]["B_MAP"], Callable(self, "_f17").bind(env)])

func _f15(this_, a: Array, env):
	var v_b_63 = null
	v_b_63 = (J.mc(env["__p"]["B"], "concat", [[["龐總", "地圖上面有張新卡，自己搵。"]]]) if J.t(J.cl(env["hasTower"], null, [])) else env["__p"]["B"])
	var _t26 = env["__p"]["stage"]
	J.cl(_t26, null, ["《陽間業務拓展計劃》", v_b_63, Callable(self, "_f16").bind(env)])

func _f14(this_, a: Array, env):
	var _t25 = env["__p"]["point"]
	return J.cl(_t25, null, ["station", env["__p"]["A_MAP"], Callable(self, "_f15").bind(env)])

func _f11(this_, a: Array, env):
	var _s22 = {"__p": env, "end": null, "hasTower": null}
	if J.t((_s22["__p"]["busy"] if J.t(_s22["__p"]["busy"]) else J.seq(J.typeof_(J.G.get("Theater")), "undefined"))):
		return null
	_s22["__p"]["busy"] = true
	_s22["end"] = Callable(self, "_f12").bind(_s22)
	_s22["hasTower"] = Callable(self, "_f13").bind(_s22)
	var _t24 = _s22["__p"]["stage"]
	J.cl(_t24, null, ["新政策發佈會", _s22["__p"]["A"], Callable(self, "_f14").bind(_s22)])

func _f19(this_, a: Array, env):
	var _t34 = J.S_document_("querySelector", ["#world.on"])
	if J.t(((not J.t(J.gp(J.G.get("Theater"), "on"))) if J.t(_t34) else _t34)):
		J.cl(env["announce"], null, [])

func _f18(this_, a: Array, env):
	var v_e_66 = null
	var _t29 = J.seq(J.typeof_(J.G.get("S")), "undefined")
	var _t30 = (_t29 if _t29 else (not J.t(J.G.get("S"))))
	if (_t30 if _t30 else (not J.t(J.gp(J.G.get("S"), "seen")))):
		return null
	var _t31 = J.gp(J.gp(J.G.get("S"), "seen"), "ch1_end")
	var _t32 = (not J.t((_t31 if J.t(_t31) else J.gp(J.G.get("window"), "STN_TEST"))))
	if J.t((_t32 if _t32 else J.gp(J.gp(J.G.get("S"), "seen"), "policy_v1"))):
		return null
	var _t33 = env["mark"]
	J.cl(_t33, null, ["policy_v1"])
	J.F_setTimeout([Callable(self, "_f19").bind(env), 600.0])

func _f22(this_, a: Array, env):
	var _t42 = env["el"]
	var _t43 = ("<b>龐總（" + J.str(J.add(env["i"], 1.0)) + "/" + J.str(J.len(env["__p"]["tips"])) + "）</b><span></span><small>撳一下" + ("下一句" if J.cmp(J.add(env["i"], 1.0), J.len(env["__p"]["tips"]), "<") else "收埋") + " ▸</small>")
	J.sp(_t42, "innerHTML", _t43)
	var _t44 = J.mc(env["el"], "querySelector", ["span"])
	var _t46 = null
	if J.seq(J.typeof_(J.G.get("L")), "function"):
		var _t45 = J.G.get("L")
		_t46 = J.cl(_t45, null, [J.gp(env["__p"]["tips"], env["i"])])
	else:
		_t46 = J.gp(env["__p"]["tips"], env["i"])
	J.sp(_t44, "textContent", _t46)

func _f23(this_, a: Array, env):
	var v_e_78 = null
	v_e_78 = J.arg(a, 0)
	J.mc(v_e_78, "stopPropagation", [])
	if J.t(J.gp(J.G.get("Sound"), "play")):
		J.mc(J.G.get("Sound"), "play", ["click"])
	env["i"] = J.num(env["i"]) + 1.0
	if (env["i"] < J.len(env["__p"]["tips"])):
		J.cl(env["show"], null, [])
	else:
		J.mc(env["el"], "remove", [])

func _f24(this_, a: Array, env):
	var v_ev_79 = null
	v_ev_79 = J.arg(a, 0)
	var _t49 = J.gp(J.G.get("document"), "body")
	if (not J.t(J.mc(_t49, "contains", [env["el"]]))):
		J.S_document_("removeEventListener", ["pointerdown", env["off"], true])
		return null
	if (not J.t(J.mc(env["el"], "contains", [J.gp(v_ev_79, "target")]))):
		J.mc(env["el"], "remove", [])
		J.S_document_("removeEventListener", ["pointerdown", env["off"], true])

func _f25(this_, a: Array, env):
	var v_r_80 = null; var v_vis_81 = null
	var _t50 = J.gp(J.G.get("document"), "body")
	if (not J.t(J.mc(_t50, "contains", [env["el"]]))):
		J.F_clearInterval([env["wt"]])
		return null
	var _t51 = J.gp(env["ROOTS"], env["__p"]["__p"]["mode"])
	v_r_80 = J.S_document_("querySelector", [(_t51 if J.t(_t51) else "#none")])
	var _t53 = v_r_80
	if J.t(_t53):
		var _t52 = J.gp(v_r_80, "classList")
		_t53 = J.mc(_t52, "contains", ["on"])
	v_vis_81 = ((not J.seq(J.gp(J.F_getComputedStyle([v_r_80]), "display"), "none")) if J.t(_t53) else _t53)
	if (not J.t(v_vis_81)):
		J.mc(env["el"], "remove", [])
		J.F_clearInterval([env["wt"]])

func _f21(this_, a: Array, env):
	var _s36 = {"__p": env, "el": null, "i": null, "show": null, "off": null, "ROOTS": null, "wt": null}
	_s36["el"] = J.S_document_("getElementById", ["pol-tip"])
	if J.t(_s36["el"]):
		J.mc(_s36["el"], "remove", [])
	var _t38 = J.S_document_("createElement", ["div"])
	_s36["el"] = _t38
	var _t39 = _s36["el"]
	J.sp(_t39, "id", "pol-tip")
	var _t40 = _s36["el"]
	J.sp(_t40, "className", "pol-box")
	var _t41 = J.gp(J.G.get("document"), "body")
	J.mc(_t41, "appendChild", [_s36["el"]])
	_s36["i"] = 0.0
	_s36["show"] = Callable(self, "_f22").bind(_s36)
	J.cl(_s36["show"], null, [])
	var _t47 = _s36["el"]
	var _t48 = Callable(self, "_f23").bind(_s36)
	J.sp(_t47, "onclick", _t48)
	_s36["off"] = Callable(self, "_f24").bind(_s36)
	J.S_document_("addEventListener", ["pointerdown", _s36["off"], true])
	_s36["ROOTS"] = {"station": "#st-street", "tower": "#tw-root"}
	_s36["wt"] = J.F_setInterval([Callable(self, "_f25").bind(_s36), 400.0])

func _f20(this_, a: Array, env):
	var v_k_70 = null; var v_e_82 = null
	var _s34 = {"__p": env, "mode": null}
	_s34["mode"] = J.arg(a, 0)
	var _s35 = {"__p": _s34, "tips": null}
	v_k_70 = J.add("policy_", _s35["__p"]["mode"])
	_s35["tips"] = J.gp(_s35["__p"]["__p"]["TIPS"], _s35["__p"]["mode"])
	var _t36 = (not J.t(_s35["tips"]))
	if not J.t(_t36):
		var _t35 = _s35["__p"]["__p"]["seen"]
		_t36 = J.cl(_t35, null, [v_k_70])
	if J.t(_t36):
		return null
	var _t37 = _s35["__p"]["__p"]["mark"]
	J.cl(_t37, null, [v_k_70])
	J.F_setTimeout([Callable(self, "_f21").bind(_s35), 500.0])

func _f2(this_, a: Array, env):
	return [["阿福", "afu"], ["龐總", env["BOSS"], J.S_Object_("assign", [{}, J.gp(env["LOOK"], "龐總")])]]

func _f3(this_, a: Array, env):
	var v_k_19 = null
	v_k_19 = J.arg(a, 0)
	var _t54 = (not J.seq(J.typeof_(J.G.get("S")), "undefined"))
	var _t55 = (J.G.get("S") if _t54 else _t54)
	var _t56 = (J.gp(J.G.get("S"), "seen") if J.t(_t55) else _t55)
	return (not (not J.t((J.gp(J.gp(J.G.get("S"), "seen"), v_k_19) if J.t(_t56) else _t56))))

func _f7(this_, a: Array, env):
	var v_css_31 = null; var v_s_32 = null
	v_css_31 = Callable(self, "_f7").bind(env)
	if J.t(J.S_document_("getElementById", ["pol-css"])):
		return null
	v_s_32 = J.S_document_("createElement", ["style"])
	J.sp(v_s_32, "id", "pol-css")
	var _t57 = ("\n.wm-pol{margin-left:auto;flex:none;padding:6px 10px;border-radius:10px;border:2px solid #6b3b1f;background:rgba(248,232,196,.95);color:#3a2212;font-family:inherit;font-size:14px;font-weight:700;box-shadow:0 3px 10px rgba(0,0,0,.45);white-space:nowrap}\n#pol-ov{position:absolute;inset:0;z-index:50;background:rgba(10,8,14,.25)}\n#pol-ov .pol-ring{position:absolute;border-radius:18px;pointer-events:none;box-shadow:0 0 0 3px #ffd36a,0 0 18px 6px rgba(255,200,90,.85);animation:polPulse 1.1s ease-in-out infinite}\n@keyframes polPulse{50%{box-shadow:0 0 0 3px #fff1b8,0 0 28px 10px rgba(255,210,110,.95)}}\n#pol-ov .pol-arr{position:absolute;width:0;height:0;margin-left:-10px;border:10px solid transparent;border-top:13px solid #ffd36a;border-bottom:0;filter:drop-shadow(0 2px 3px rgba(0,0,0,.6));pointer-events:none;animation:polBob .8s ease-in-out infinite}\n@keyframes polBob{50%{transform:translateY(6px)}}\n.pol-box{position:absolute;left:16px;right:16px;padding:10px 14px 12px;background:#f6ecd2;color:#2a1a10;border-radius:14px;box-shadow:0 0 0 2px #3a2a1a,0 6px 16px rgba(0,0,0,.55);font-size:18px;line-height:1.5;font-weight:700;overflow-wrap:anywhere}\n.pol-box b{display:block;font-family:var(--serif);font-size:14px;font-weight:900;color:var(--cinnabar,#b0302a);margin-bottom:2px;letter-spacing:1px}\n.pol-box small{display:block;text-align:right;font-size:12px;font-weight:400;color:#8a6a4a;margin-top:2px}\n#pol-tip{position:fixed;z-index:100050;bottom:calc(env(safe-area-inset-bottom) + 10px);font-size:16px;padding:8px 12px 9px;background:rgba(246,236,210,.96);cursor:pointer}\n")
	J.sp(v_s_32, "textContent", _t57)
	var _t58 = J.gp(J.G.get("document"), "head")
	J.mc(_t58, "appendChild", [v_s_32])

func _f1(this_, a: Array, env):
	var v_maybe_17 = null; var v_firstEnter_18 = null
	var _s2 = {"__p": env, "BOSS": null, "LOOK": null, "cast": null, "seen": null, "mark": null, "stage": null, "A": null, "A_MAP": null, "B": null, "B_MAP": null, "C": null, "TIPS": null, "point": null, "busy": null, "announce": null}
	_s2["mark"] = Callable(self, "_f4").bind(_s2)
	_s2["stage"] = Callable(self, "_f5").bind(_s2)
	_s2["point"] = Callable(self, "_f8").bind(_s2)
	_s2["announce"] = Callable(self, "_f11").bind(_s2)
	v_maybe_17 = Callable(self, "_f18").bind(_s2)
	v_firstEnter_18 = Callable(self, "_f20").bind(_s2)
	_s2["BOSS"] = "npc_kpiboss"
	_s2["LOOK"] = {"龐總": {"base": "ag:inspect", "talk": "ag:tap"}}
	_s2["cast"] = Callable(self, "_f2").bind(_s2)
	_s2["seen"] = Callable(self, "_f3").bind(_s2)
	_s2["A"] = [["旁白", "陰間集團總部，三樓會議室。投影機風扇嘅聲，大過成個部門。"], ["龐總", "各位，今日召開新政策發佈會。我只講一次，重複係浪費 resources。", "ag:tap"], ["阿福", "成間會議室得我一個，你叫「各位」？"], ["龐總", "我係對住未來嘅編制講。下季呢度坐唔坐得滿，睇你啲數。"], ["龐總", "本集團正式推出《陽間業務拓展計劃》。陰間市場已經飽和，增長要去陽間搵。", "ag:yell"], ["阿福", "講人話啦。"], ["龐總", "即係去陽間嚇人。第一條：「陽間站崗」。"], ["龐總", "陽間有幾個地盤，我已經 secure 咗位。你派鬼過去企位，路人行過就嚇佢。"], ["阿福", "企邊度有冇得揀㗎？"], ["龐總", "睇格仔。咩類型嘅格，就擺咩鬼。擺錯位，叫做資源錯配。"], ["阿福", "咁我啲小鬼，可唔可以一隻擺幾次？"], ["龐總", "普通鬼大把，重複擺冇問題。有名有姓嗰啲就唔同，一張地圖最多三隻，仲可以同設備勵鬼加持——物以罕為貴。"], ["阿福", "即係佢哋人工高啲？"], ["龐總", "即係佢哋要求多啲。另外，鬼嚇人會儲能量，儲滿就放大招，一嚇嚇一堆。呢個叫規模效應。", "ag:tap"], ["阿福", "嚇完一間房，咪收得工囉？"], ["龐總", "收工？嚇得夠多，地圖會延伸，第二間、第三間房陸續開放。業務係要擴張嘅。"], ["龐總", "（指住窗外塊地圖）自己望吓。"]]
	_s2["A_MAP"] = [["龐總", "就係呢張卡：陽間站崗。"], ["阿福", "個框閃到咁，想睇唔到都難。"]]
	_s2["B"] = [["龐總", "第二條：「樓裡有鬼」。呢條係我哋嘅 premium 產品線。", "ag:tap"], ["阿福", "又 premium？上次 premium 係加班冇補水。"], ["龐總", "你揀一棟樓，組屋又得，老店屋又得，由地下開始，一層一層向上嚇住戶。"], ["阿福", "由下而上，好似升職咁喎。"], ["龐總", "升職係由上而下指派嘅，唔好亂比喻。重點：鬼要企定先出得手，郁緊嘅鬼嚇唔到人。", "ag:sigh"], ["阿福", "同返工一樣，要坐定定扮忙。"], ["龐總", "仲有，見到門口有門神，或者貼住紅紙符，一律繞路。"], ["阿福", "唔可以硬闖？"], ["龐總", "唔可以。門神係守住戶嘅，神明要尊重。呢條係公司紅線，唔係 KPI，冇得 negotiate。"], ["阿福", "難得你都有一樣嘢係尊重嘅。"], ["龐總", "最後，開工時間係子時到寅時。天光之前，一定要返到陰間。"], ["阿福", "遲咗會點？"], ["龐總", "遲咗你就變晨運阿伯嘅話題。公司唔會幫你報工傷。", "ag:yell"]]
	_s2["B_MAP"] = [["龐總", "呢張就係樓裡有鬼。揀棟樓，由地下嚇上去。"], ["阿福", "睇落層數唔少喎……"]]
	_s2["C"] = [["龐總", "總結：兩條產品線同步推進。本季 KPI，陽間嚇人數字要按月增長。", "ag:tap"], ["阿福", "增長幾多？"], ["龐總", "比上個月多。上個月係零，所以你做幾多都算增長——呢個就係領導藝術。"], ["阿福", "……你第一次講咗句對我有著數嘅嘢。"], ["龐總", "唔好誤會。下個月嘅 baseline，就係你今個月嘅數字。散會。", "ag:sigh"], ["旁白", "投影機熄咗。風扇聲仲響緊。"]]
	_s2["TIPS"] = {"station": ["站崗守則第一條：橙色格係路崗，放鬼拉腳、鬼打牆、卡到陰；紫色格貼牆，放驚嚇、氛圍、投擲。", "鬼打牆一圍，路人原地兜圈搵唔到路；佢哋合力衝破咗，要等佢重新圍返。", "升級要冥幣，唔夠錢個掣會灰咗。回靈速度愈快，出手愈密。", "雜鬼或者名鬼可以幫設備勵鬼加持，名鬼加持最勁。", "紙皮箱、手推車會擋住視線；保安阿伯嘅電筒會照停你啲設備，小心佢。"], "tower": ["由地下開始，一層一層向上嚇，唔好跳級。", "鬼企定咗先出得手，郁緊嘅唔計數。", "見到門神同紅紙符就繞路——神明要尊重，唔准亂嚟。", "子時開工，寅時前一定要返陰間，天光就遲。"]}
	J.cl(Callable(self, "_f7").bind(_s2), null, [])
	_s2["busy"] = false
	return {"announce": _s2["announce"], "maybe": v_maybe_17, "firstEnter": v_firstEnter_18, "TIPS": _s2["TIPS"]}
