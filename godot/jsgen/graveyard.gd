# 自動轉譯自 graveyard.js（tools/jsgd.js）——唔好直接改，改原 JS 再轉
extends RefCounted

func run(env):
	var this_ = null; var a = []
	J.G["GY_SPOTS"] = {"A": {"x": 0.25, "y": 0.375, "row": 0.0, "side": 0.0, "name": "左上"}, "B": {"x": 0.76, "y": 0.37, "row": 0.0, "side": 2.0, "name": "右上"}, "C": {"x": 0.52, "y": 0.475, "row": 1.0, "side": 1.0, "name": "正中間"}, "D": {"x": 0.24, "y": 0.585, "row": 2.0, "side": 0.0, "name": "左下"}, "E": {"x": 0.76, "y": 0.58, "row": 2.0, "side": 2.0, "name": "右下"}}
	J.G["GY_TOMB_TAB"] = [[0.5, 0.29, 0.52, 0.38, 0.62], [0.49, 0.24, 0.55, 0.37, 0.61], [0.5, 0.3, 0.52, 0.38, 0.62], [0.5, 0.24, 0.52, 0.38, 0.62]]
	J.G["GY_TAGS"] = ["①", "②", "③", "④", "⑤"]
	J.G["GY_LEVELS"] = {"1": {"n": 3.0, "g": 3.0, "direct": 2.0}, "2": {"n": 4.0, "g": 4.0, "direct": 1.0}, "3": {"n": 4.0, "g": 5.0, "direct": 1.0}, "4": {"n": 5.0, "g": 5.0, "direct": 1.0}}
	J.G["GY_JOBS"] = {"會計": {"ep": [["數了一輩子別人的錢", ["一輩子", "別人的錢"]], ["帳終於對平了", ["對平"]]], "last": "帳……對平了。"}, "保安": {"ep": [["守了三十年大門，今天準時下班", ["大門", "準時下班"]], ["大家都回家了，我也回家", ["回家"]]], "last": "可以關燈了。"}, "外賣員": {"ep": [["這一單，終於送到了", ["送到了", "這一單"]], ["風雨無阻，請給五星", ["五星", "風雨無阻"]]], "last": "這一單……送到了。"}, "補習老師": {"ep": [["下課鐘響了，不用再補", ["下課", "不用再補"]], ["考試範圍：無", ["考試範圍"]]], "last": "今天，不留功課。"}, "茶室頭手": {"ep": [["最後一杯，走甜", ["走甜", "最後一杯"]], ["爐火熄了，人也歇了", ["爐火"]]], "last": "Kopi-O，走甜。"}, "地產經紀": {"ep": [["此地永久地契，不設轉售", ["永久地契", "不設轉售"]], ["風水一流，近地鐵站", ["風水", "地鐵站"]]], "last": "這個單位……我自己住。"}, "夜班護士": {"ep": [["換班了，這次真的睡了", ["換班", "真的睡了"]], ["不用再叫醒我了", ["叫醒"]]], "last": "下一更，交給你們了。"}, "羅里司機": {"ep": [["跑了一百萬公里，終於泊好", ["泊好", "一百萬公里"]], ["前路不再塞車", ["塞車"]]], "last": "引擎，熄了。"}, "收銀員": {"ep": [["找你零錢，不用謝", ["零錢", "不用謝"]], ["收工了，抽屜對數", ["抽屜"]]], "last": "下一位……沒有了。"}, "銀行櫃員": {"ep": [["請取號，下一位", ["取號", "下一位"]], ["本櫃台暫停服務", ["暫停服務"]]], "last": "本櫃台，暫停服務。"}, "文員": {"ep": [["影印了半生，終於原件歸檔", ["原件歸檔", "影印"]], ["已讀，不回", ["已讀"]]], "last": "這份，不用再改了。"}, "Grab司機": {"ep": [["目的地：已抵達", ["已抵達", "目的地"]], ["乘客已下車，請給好評", ["下車", "好評"]]], "last": "目的地，到了。"}, "小販": {"ep": [["今天早點收檔", ["收檔", "早點"]], ["賣完了，明天請早", ["明天請早"]]], "last": "今天，賣完了。"}, "人事專員": {"ep": [["您的離職申請已批准", ["離職申請", "已批准"]], ["恭喜轉正，永不續約", ["轉正", "永不續約"]]], "last": "這次，是我自己批准的。"}}
	J.G["GY_OFFERS"] = ["榴槤", "麻將牌", "一封沒拆的公司信", "老花眼鏡", "Milo 罐", "椰漿飯", "計算機", "粉筆", "安全帽", "一串鑰匙", "舊手機", "萬字票", "紅包", "藍白拖鞋"]
	J.G["GY_SURN"] = ["陳", "林", "黃", "李", "張", "王", "吳", "劉", "蔡", "楊", "鄭", "何", "謝", "羅", "梁", "周", "許", "曾", "蕭", "郭"]
	J.G["GY_GIVEN"] = ["美玲", "志強", "國華", "秀英", "家豪", "淑芬", "偉明", "亞清", "文傑", "麗珠", "金水", "月娥", "俊傑", "寶珠", "德福", "玉蘭", "振興", "素貞", "建國", "惠敏"]
	J.G["GY_DEC"] = ["", "", "二", "三", "四", "五", "六", "七", "八"]
	J.G["GY_TPL"] = {"job_is": ["我生前是{job}。", "每天上班、下班……我是{job}。"], "job_not": ["我生前不是{job}。", "我沒做過{job}。"], "ojob_not": ["{J}生前不是{job}。", "{J}沒做過{job}。"], "off_is": ["我的墳前，有人放了{off}。", "我記得墳前放著{off}。"], "off_not": ["我的墳前放的不是{off}。"], "quote": ["碑文我只記得『{q}』。", "我的碑文裡有『{q}』。"], "quote_not": ["我的碑文裡沒有『{q}』。"], "age": ["我走的時候{d}十幾歲。"], "surname": ["我姓{sn}。"], "row_is": ["我睡在{row}。"], "row_not": ["我不是睡在{row}。"], "side_is": ["我睡在{side}。"], "side_not": ["我不是睡在{side}。"], "tree": ["我睡在牌坊旁邊那座。"], "tree_not": ["我不是睡在牌坊旁邊那座。"], "rel": ["我的墳在{J}的墳{dir}。"], "same_row": ["我和{J}睡在同一排。"], "died": ["我比{J}{when}。"]}
	J.G["GY_ROWW"] = ["上排", "正中間那座", "下排"]
	J.G["GY_SIDEW"] = ["左側", null, "右側"]
	J.G["GY_GEN"] = {"rng": Callable(self, "_f1").bind(env), "levelOf": Callable(self, "_f3").bind(env), "holds": Callable(self, "_f4").bind(env), "solve": Callable(self, "_f5").bind(env), "text": Callable(self, "_f8").bind(env), "gen": Callable(self, "_f9").bind(env), "shuffle": Callable(self, "_f10").bind(env), "tryGen": Callable(self, "_f11").bind(env)}
	var _t83 = J.G.get("GY_GEN")
	var _t84 = Callable(self, "_f42").bind(env)
	J.sp(_t83, "card", _t84)
	J.G["GY_COLORS"] = ["#9fe8ff", "#ffd27a", "#d0b0ff", "#a8ffb8", "#ffa8c0"]
	J.G["GY_ALPHA"] = [0.9, 0.84, 0.88, 0.86, 0.8]
	J.G["GY_RULES"] = [["他們記得的，都是真的", "每一晚只有一種擺法說得通。擺錯了，就是哪一步想錯了。"], ["排（高低）", "上排＝上面兩座（左上、右上）；正中間那座自成一排；下排＝下面兩座（左下、右下）。"], ["側（左右）", "左側＝左上、左下；右側＝右上、右下。正中間那座不算左側，也不算右側。"], ["上面／下面", "只比排：上排在正中間上面，正中間在下排上面。同一排不算上下，不用對正。"], ["左邊／右邊", "只比側：左側在正中間左邊，正中間在右側左邊。同一側不算左右，不用對齊。"], ["同一排", "兩座都在上排，或都在下排。"], ["牌坊旁邊那座", "左下那座（就在石牌坊旁邊）。"], ["幾十幾歲", "卒年減生年。"], ["早走／晚走", "卒年比較早／比較晚。"], ["碑文", "墓碑卡上「碑文」那一行；『』裡的字一字不差出現在碑文裡。"], ["只算立了碑的", "沒立碑的空地不是墳。有時會多一座墳，裡面的人早就安息了，不屬於今晚任何一個魂。"]]
	J.G["Graveyard"] = {"active": false, "ensure": Callable(self, "_f43").bind(env), "open": Callable(self, "_f44").bind(env), "close": Callable(self, "_f59").bind(env), "hint": Callable(self, "_f60").bind(env), "resize": Callable(self, "_f63").bind(env), "bgScale": Callable(self, "_f64").bind(env), "pt": Callable(self, "_f65").bind(env), "unit": Callable(self, "_f66").bind(env), "soulH": Callable(self, "_f67").bind(env), "homeOf": Callable(self, "_f68").bind(env), "graveAt": Callable(self, "_f69").bind(env), "standOf": Callable(self, "_f70").bind(env), "targetOf": Callable(self, "_f71").bind(env), "stoneRect": Callable(self, "_f72").bind(env), "local": Callable(self, "_f73").bind(env), "soulAtPx": Callable(self, "_f74").bind(env), "graveAtPx": Callable(self, "_f75").bind(env), "down": Callable(self, "_f77").bind(env), "move": Callable(self, "_f78").bind(env), "up": Callable(self, "_f79").bind(env), "place": Callable(self, "_f80").bind(env), "allPlaced": Callable(self, "_f81").bind(env), "correct": Callable(self, "_f83").bind(env), "submit": Callable(self, "_f85").bind(env), "say": Callable(self, "_f88").bind(env), "rest": Callable(self, "_f89").bind(env), "finish": Callable(self, "_f93").bind(env), "renderPanel": Callable(self, "_f99").bind(env), "frame": Callable(self, "_f107").bind(env), "step": Callable(self, "_f110").bind(env), "draw": Callable(self, "_f113").bind(env), "fog": Callable(self, "_f117").bind(env), "drawStone": Callable(self, "_f118").bind(env), "drawSoul": Callable(self, "_f122").bind(env), "rgba": Callable(self, "_f123").bind(env), "bubble": Callable(self, "_f124").bind(env)}

func _f2(this_, a: Array, env):
	var v_t_22 = null
	var _t1 = J.ushr(J.add(env["a"], 1831565813.0), 0.0)
	env["a"] = _t1
	v_t_22 = env["a"]
	var _t2 = J.math("imul", [J.bxor(v_t_22, J.ushr(v_t_22, 15.0)), J.bor(v_t_22, 1.0)])
	v_t_22 = _t2
	var _t3 = J.bxor(v_t_22, J.add(v_t_22, J.math("imul", [J.bxor(v_t_22, J.ushr(v_t_22, 7.0)), J.bor(v_t_22, 61.0)])))
	v_t_22 = _t3
	return J.div(J.ushr(J.bxor(v_t_22, J.ushr(v_t_22, 14.0)), 0.0), 4294967296.0)

func _f1(this_, a: Array, env):
	var v_seed_20 = null
	var _s2 = {"__p": env, "a": null}
	v_seed_20 = J.arg(a, 0)
	_s2["a"] = J.ushr(v_seed_20, 0.0)
	return Callable(self, "_f2").bind(_s2)

func _f3(this_, a: Array, env):
	var v_night_25 = null
	v_night_25 = J.arg(a, 0)
	return (1.0 if J.cmp(v_night_25, 2.0, "<=") else (2.0 if J.cmp(v_night_25, 4.0, "<=") else (3.0 if J.cmp(v_night_25, 7.0, "<=") else 4.0)))

func _f4(this_, a: Array, env):
	var v_c_28 = null; var v_asg_29 = null; var v_graves_30 = null; var v_me_31 = null; var v_o_32 = null; var v_sp_33 = null; var v_so_34 = null
	v_c_28 = J.arg(a, 0)
	v_asg_29 = J.arg(a, 1)
	v_graves_30 = J.arg(a, 2)
	v_me_31 = J.gp(v_graves_30, J.gp(v_asg_29, J.gp(v_c_28, "who")))
	v_o_32 = (J.gp(v_graves_30, J.gp(v_asg_29, J.gp(v_c_28, "j"))) if (not J.leq(J.gp(v_c_28, "j"), null)) else null)
	v_sp_33 = J.gp(J.G.get("GY_SPOTS"), J.gp(v_me_31, "spot"))
	v_so_34 = (J.gp(J.G.get("GY_SPOTS"), J.gp(v_o_32, "spot")) if J.t(v_o_32) else v_o_32)
	var _t4 = J.gp(v_c_28, "t")
	var _t5 = -1
	var _t6 = false
	if _t5 == -1 and J.seq(_t4, "job_is"): _t5 = 0
	if _t5 == -1 and J.seq(_t4, "job_not"): _t5 = 1
	if _t5 == -1 and J.seq(_t4, "ojob_not"): _t5 = 2
	if _t5 == -1 and J.seq(_t4, "off_is"): _t5 = 3
	if _t5 == -1 and J.seq(_t4, "off_not"): _t5 = 4
	if _t5 == -1 and J.seq(_t4, "quote"): _t5 = 5
	if _t5 == -1 and J.seq(_t4, "quote_not"): _t5 = 6
	if _t5 == -1 and J.seq(_t4, "age"): _t5 = 7
	if _t5 == -1 and J.seq(_t4, "surname"): _t5 = 8
	if _t5 == -1 and J.seq(_t4, "row_is"): _t5 = 9
	if _t5 == -1 and J.seq(_t4, "row_not"): _t5 = 10
	if _t5 == -1 and J.seq(_t4, "side_is"): _t5 = 11
	if _t5 == -1 and J.seq(_t4, "side_not"): _t5 = 12
	if _t5 == -1 and J.seq(_t4, "tree"): _t5 = 13
	if _t5 == -1 and J.seq(_t4, "tree_not"): _t5 = 14
	if _t5 == -1 and J.seq(_t4, "rel"): _t5 = 15
	if _t5 == -1 and J.seq(_t4, "same_row"): _t5 = 16
	if _t5 == -1 and J.seq(_t4, "died"): _t5 = 17
	while true:
		if _t5 <= 0 and _t5 >= 0:
			return J.seq(J.gp(v_me_31, "job"), J.gp(v_c_28, "v"))
		if _t5 <= 1 and _t5 >= 0:
			return (not J.seq(J.gp(v_me_31, "job"), J.gp(v_c_28, "v")))
		if _t5 <= 2 and _t5 >= 0:
			return (not J.seq(J.gp(v_o_32, "job"), J.gp(v_c_28, "v")))
		if _t5 <= 3 and _t5 >= 0:
			return J.seq(J.gp(v_me_31, "off"), J.gp(v_c_28, "v"))
		if _t5 <= 4 and _t5 >= 0:
			return (not J.seq(J.gp(v_me_31, "off"), J.gp(v_c_28, "v")))
		if _t5 <= 5 and _t5 >= 0:
			var _t7 = J.gp(v_me_31, "ep")
			return J.mc(_t7, "includes", [J.gp(v_c_28, "v")])
		if _t5 <= 6 and _t5 >= 0:
			var _t8 = J.gp(v_me_31, "ep")
			return (not J.t(J.mc(_t8, "includes", [J.gp(v_c_28, "v")])))
		if _t5 <= 7 and _t5 >= 0:
			return J.seq(floor(J.num(J.div(J.sub(J.gp(v_me_31, "death"), J.gp(v_me_31, "birth")), 10.0))), J.gp(v_c_28, "v"))
		if _t5 <= 8 and _t5 >= 0:
			return J.seq(J.gp(J.gp(v_me_31, "name"), 0.0), J.gp(v_c_28, "v"))
		if _t5 <= 9 and _t5 >= 0:
			return J.seq(J.gp(v_sp_33, "row"), J.gp(v_c_28, "v"))
		if _t5 <= 10 and _t5 >= 0:
			return (not J.seq(J.gp(v_sp_33, "row"), J.gp(v_c_28, "v")))
		if _t5 <= 11 and _t5 >= 0:
			return J.seq(J.gp(v_sp_33, "side"), J.gp(v_c_28, "v"))
		if _t5 <= 12 and _t5 >= 0:
			return (not J.seq(J.gp(v_sp_33, "side"), J.gp(v_c_28, "v")))
		if _t5 <= 13 and _t5 >= 0:
			return J.seq(J.gp(v_me_31, "spot"), "D")
		if _t5 <= 14 and _t5 >= 0:
			return (not J.seq(J.gp(v_me_31, "spot"), "D"))
		if _t5 <= 15 and _t5 >= 0:
			return (J.cmp(J.gp(v_sp_33, "row"), J.gp(v_so_34, "row"), "<") if J.seq(J.gp(v_c_28, "v"), "up") else (J.cmp(J.gp(v_sp_33, "row"), J.gp(v_so_34, "row"), ">") if J.seq(J.gp(v_c_28, "v"), "down") else (J.cmp(J.gp(v_sp_33, "side"), J.gp(v_so_34, "side"), "<") if J.seq(J.gp(v_c_28, "v"), "left") else J.cmp(J.gp(v_sp_33, "side"), J.gp(v_so_34, "side"), ">"))))
		if _t5 <= 16 and _t5 >= 0:
			return J.seq(J.gp(v_sp_33, "row"), J.gp(v_so_34, "row"))
		if _t5 <= 17 and _t5 >= 0:
			return (J.cmp(J.gp(v_me_31, "death"), J.gp(v_o_32, "death"), "<") if J.seq(J.gp(v_c_28, "v"), "early") else J.cmp(J.gp(v_me_31, "death"), J.gp(v_o_32, "death"), ">"))
		break
	return false

func _f7(this_, a: Array, env):
	var v_c_50 = null
	v_c_50 = J.arg(a, 0)
	return J.mc(env["this"], "holds", [v_c_50, env["asg"], env["graves"]])

func _f6(this_, a: Array, env):
	var v_i_48 = null; var v_g_49 = null
	v_i_48 = J.arg(a, 0)
	if J.t((J.cmp(J.len(env["out"]), env["cap"], ">=") if J.t(env["cap"]) else env["cap"])):
		return null
	if J.seq(v_i_48, env["n"]):
		J.mc(env["out"], "push", [J.mc(env["asg"], "slice", [])])
		return null
	v_g_49 = 0.0
	while true:
		if not J.cmp(v_g_49, J.len(env["graves"]), "<"): break
		if J.t(J.gp(env["used"], v_g_49)):
			v_g_49 = J.num(v_g_49) + 1.0
			continue
		var _t12 = env["used"]
		J.sp(_t12, v_g_49, true)
		var _t13 = env["asg"]
		J.sp(_t13, v_i_48, v_g_49)
		var _t14 = J.gp(env["byWho"], v_i_48)
		if J.t(J.mc(_t14, "every", [Callable(self, "_f7").bind(env)])):
			var _t15 = env["rec"]
			J.cl(_t15, null, [J.add(v_i_48, 1.0)])
		var _t16 = env["used"]
		J.sp(_t16, v_g_49, false)
		v_g_49 = J.num(v_g_49) + 1.0

func _f5(this_, a: Array, env):
	var v_clues_39 = null; var v_i_46 = null; var v_c_47 = null
	var _s7 = {"__p": env, "this": null, "n": null, "graves": null, "cap": null, "out": null, "asg": null, "used": null, "byWho": null, "rec": null}
	_s7["this"] = this_
	_s7["n"] = J.arg(a, 0)
	_s7["graves"] = J.arg(a, 1)
	v_clues_39 = J.arg(a, 2)
	_s7["cap"] = J.arg(a, 3)
	_s7["out"] = []
	_s7["asg"] = []
	var _t9 = J.new_("Array", [J.len(_s7["graves"])])
	_s7["used"] = J.mc(_t9, "fill", [false])
	_s7["byWho"] = []
	v_i_46 = 0.0
	while true:
		if not J.cmp(v_i_46, _s7["n"], "<"): break
		J.mc(_s7["byWho"], "push", [[]])
		v_i_46 = J.num(v_i_46) + 1.0
	for _t10 in J.iter(v_clues_39):
		v_c_47 = _t10
		var _t11 = J.gp(_s7["byWho"], J.max_([J.gp(v_c_47, "who"), (J.gp(v_c_47, "j") if (not J.leq(J.gp(v_c_47, "j"), null)) else (-1.0))]))
		J.mc(_t11, "push", [v_c_47])
	_s7["rec"] = Callable(self, "_f6").bind(_s7)
	var _t17 = _s7["rec"]
	J.cl(_t17, null, [0.0])
	return _s7["out"]

func _f8(this_, a: Array, env):
	var v_c_53 = null; var v_rnd_54 = null; var v_tp_55 = null; var v_s_56 = null; var v_J_57 = null; var v_v_58 = null
	v_c_53 = J.arg(a, 0)
	v_rnd_54 = J.arg(a, 1)
	v_tp_55 = J.gp(J.G.get("GY_TPL"), J.gp(v_c_53, "t"))
	v_s_56 = J.gp(v_tp_55, floor(J.num(J.mul(J.cl(v_rnd_54, null, []), J.len(v_tp_55)))))
	v_J_57 = (J.gp(J.G.get("GY_TAGS"), J.gp(v_c_53, "j")) if (not J.leq(J.gp(v_c_53, "j"), null)) else "")
	v_v_58 = J.gp(v_c_53, "v")
	if J.seq(J.gp(v_c_53, "t"), "age"):
		v_v_58 = J.gp(J.G.get("GY_DEC"), J.gp(v_c_53, "v"))
	var _t18 = J.mc(v_s_56, "replace", ["{job}", J.gp(v_c_53, "v")])
	var _t19 = J.mc(_t18, "replace", ["{off}", J.gp(v_c_53, "v")])
	var _t20 = J.mc(_t19, "replace", ["{q}", J.gp(v_c_53, "v")])
	var _t21 = J.mc(_t20, "replace", ["{d}", v_v_58])
	var _t22 = J.mc(_t21, "replace", ["{sn}", J.gp(v_c_53, "v")])
	var _t23 = J.mc(_t22, "replace", ["{row}", J.gp(J.G.get("GY_ROWW"), J.gp(v_c_53, "v"))])
	var _t24 = J.mc(_t23, "replace", ["{side}", J.gp(J.G.get("GY_SIDEW"), J.gp(v_c_53, "v"))])
	var _t25 = J.mc(_t24, "replace", ["{J}", v_J_57])
	var _t26 = J.mc(_t25, "replace", ["{dir}", J.gp({"up": "上面", "down": "下面", "left": "左邊", "right": "右邊"}, J.gp(v_c_53, "v"))])
	return J.mc(_t26, "replace", ["{when}", ("早走" if J.seq(J.gp(v_c_53, "v"), "early") else "晚走")])

func _f9(this_, a: Array, env):
	var v_night_61 = null; var v_seed_62 = null; var v_level_63 = null; var v_L_64 = null; var v_tries_65 = null; var v_r_66 = null; var v_p_67 = null
	v_night_61 = J.arg(a, 0)
	v_seed_62 = J.arg(a, 1)
	v_level_63 = J.mc(this_, "levelOf", [v_night_61])
	v_L_64 = J.gp(J.G.get("GY_LEVELS"), v_level_63)
	v_tries_65 = 0.0
	while true:
		if not J.cmp(v_tries_65, 400.0, "<"): break
		v_r_66 = J.mc(this_, "rng", [(J.ushr(v_seed_62, 0.0) + J.mul(v_tries_65, 7919.0))])
		v_p_67 = J.mc(this_, "tryGen", [v_L_64, v_r_66])
		if J.t(v_p_67):
			J.sp(v_p_67, "level", v_level_63)
			J.sp(v_p_67, "night", v_night_61)
			J.sp(v_p_67, "seed", v_seed_62)
			J.sp(v_p_67, "tries", v_tries_65)
			return v_p_67
		v_tries_65 = J.num(v_tries_65) + 1.0
	J.throw_(J.new_("Error", ["graveyard gen failed"]))
	return null

func _f10(this_, a: Array, env):
	var v_a_70 = null; var v_r_71 = null; var v_i_72 = null; var v_j_73 = null
	v_a_70 = J.arg(a, 0)
	v_r_71 = J.arg(a, 1)
	v_i_72 = (J.len(v_a_70) - 1.0)
	while true:
		if not J.cmp(v_i_72, 0.0, ">"): break
		v_j_73 = floor(J.num(J.mul(J.cl(v_r_71, null, []), J.add(v_i_72, 1.0))))
		var _t27 = [J.gp(v_a_70, v_j_73), J.gp(v_a_70, v_i_72)]
		var _t28 = J.gp(_t27, 0.0)
		J.sp(v_a_70, v_i_72, _t28)
		var _t29 = J.gp(_t27, 1.0)
		J.sp(v_a_70, v_j_73, _t29)
		v_i_72 = J.num(v_i_72) + -1.0
	return v_a_70

func _f12(this_, a: Array, env):
	var v_arr_110 = null; var v_k_111 = null
	v_arr_110 = J.arg(a, 0)
	v_k_111 = J.arg(a, 1)
	var _t30 = J.mc(env["this"], "shuffle", [J.mc(v_arr_110, "slice", []), env["r"]])
	return J.mc(_t30, "slice", [0.0, v_k_111])

func _f13(this_, a: Array, env):
	var v_x_113 = null
	v_x_113 = J.arg(a, 0)
	return (absf(J.num(J.sub(v_x_113, env["d"]))) >= 2.0)

func _f14(this_, a: Array, env):
	var v_s_114 = null; var v_i_115 = null; var v_dec_116 = null; var v_age_117 = null; var v_eps_118 = null; var v_e_119 = null
	v_s_114 = J.arg(a, 0)
	v_i_115 = J.arg(a, 1)
	v_dec_116 = (2.0 + floor(J.num(J.mul(J.cl(env["r"], null, []), 7.0))))
	v_age_117 = ((J.mul(v_dec_116, 10.0) + 2.0) + floor(J.num(J.mul(J.cl(env["r"], null, []), 7.0))))
	v_eps_118 = J.gp(J.gp(J.G.get("GY_JOBS"), J.gp(env["jobs"], v_i_115)), "ep")
	v_e_119 = J.gp(v_eps_118, floor(J.num(J.mul(J.cl(env["r"], null, []), J.len(v_eps_118)))))
	return {"spot": v_s_114, "name": J.add(J.gp(env["sn"], v_i_115), J.gp(env["gv"], v_i_115)), "job": J.gp(env["jobs"], v_i_115), "off": J.gp(env["offs"], v_i_115), "ep": J.gp(v_e_119, 0.0), "keys": J.gp(v_e_119, 1.0), "death": J.gp(env["deaths"], v_i_115), "birth": J.sub(J.gp(env["deaths"], v_i_115), v_age_117)}

func _f15(this_, a: Array, env):
	var v_g_120 = null
	v_g_120 = J.arg(a, 0)
	return J.gp(v_g_120, "ep")

func _f16(this_, a: Array, env):
	var v___121 = null; var v_i_122 = null
	v___121 = J.arg(a, 0)
	v_i_122 = J.arg(a, 1)
	return v_i_122

func _f17(this_, a: Array, env):
	var v_c_123 = null
	v_c_123 = J.arg(a, 0)
	if J.t(J.mc(env["this"], "holds", [v_c_123, env["truth"], env["graves"]])):
		J.mc(env["pool"], "push", [v_c_123])

func _f18(this_, a: Array, env):
	var v_g_124 = null
	v_g_124 = J.arg(a, 0)
	return J.gp(J.gp(J.G.get("GY_SPOTS"), J.gp(v_g_124, "spot")), "row")

func _f19(this_, a: Array, env):
	var v_g_125 = null
	v_g_125 = J.arg(a, 0)
	return J.gp(J.gp(J.G.get("GY_SPOTS"), J.gp(v_g_125, "spot")), "side")

func _f20(this_, a: Array, env):
	var v_g_130 = null
	v_g_130 = J.arg(a, 0)
	return (not J.seq(v_g_130, env["me"]))

func _f21(this_, a: Array, env):
	var v_g_137 = null
	v_g_137 = J.arg(a, 0)
	return J.seq(J.gp(v_g_137, "spot"), "D")

func _f23(this_, a: Array, env):
	var v_x_147 = null
	v_x_147 = J.arg(a, 0)
	return (not J.t(v_x_147))

func _f22(this_, a: Array, env):
	var v_c_142 = null; var v_ok_143 = null; var v_g_144 = null; var v_h_145 = null; var v_asg_146 = null
	v_c_142 = J.arg(a, 0)
	v_ok_143 = []
	v_g_144 = 0.0
	while true:
		if not J.cmp(v_g_144, J.len(env["graves"]), "<"): break
		v_h_145 = 0.0
		while true:
			if not J.cmp(v_h_145, J.len(env["graves"]), "<"): break
			var _t42 = J.leq(J.gp(v_c_142, "j"), null)
			if (J.cmp(v_h_145, 0.0, ">") if _t42 else _t42):
				break
			var _t43 = (not J.leq(J.gp(v_c_142, "j"), null))
			if (J.seq(v_g_144, v_h_145) if _t43 else _t43):
				v_h_145 = J.num(v_h_145) + 1.0
				continue
			v_asg_146 = []
			var _t44 = J.gp(v_c_142, "who")
			J.sp(v_asg_146, _t44, v_g_144)
			if (not J.leq(J.gp(v_c_142, "j"), null)):
				var _t45 = J.gp(v_c_142, "j")
				J.sp(v_asg_146, _t45, v_h_145)
			J.mc(v_ok_143, "push", [J.mc(env["this"], "holds", [v_c_142, v_asg_146, env["graves"]])])
			v_h_145 = J.num(v_h_145) + 1.0
		v_g_144 = J.num(v_g_144) + 1.0
	return J.mc(v_ok_143, "some", [Callable(self, "_f23").bind(env)])

func _f25(this_, a: Array, env):
	var v___149 = null; var v_g_150 = null; var v_asg_151 = null
	v___149 = J.arg(a, 0)
	v_g_150 = J.arg(a, 1)
	v_asg_151 = []
	var _t46 = J.gp(env["c"], "who")
	J.sp(v_asg_151, _t46, v_g_150)
	return J.mc(env["__p"]["this"], "holds", [env["c"], v_asg_151, env["__p"]["graves"]])

func _f24(this_, a: Array, env):
	var _s56 = {"__p": env, "c": null}
	_s56["c"] = J.arg(a, 0)
	var _t47 = J.leq(J.gp(_s56["c"], "j"), null)
	return (J.seq(J.len(J.mc(_s56["__p"]["graves"], "filter", [Callable(self, "_f25").bind(_s56)])), 1.0) if _t47 else _t47)

func _f26(this_, a: Array, env):
	var v_arr_152 = null; var v_by_153 = null; var v_ts_154 = null; var v_s_155 = null; var v_x_156 = null; var v_l_157 = null; var v_c_158 = null; var v_t_159 = null; var v_t_160 = null
	v_arr_152 = J.arg(a, 0)
	v_by_153 = {}
	for _t48 in J.iter(v_arr_152):
		v_c_158 = _t48
		var _t49 = J.gp(v_c_158, "t")
		var _t50 = J.gp(v_by_153, J.gp(v_c_158, "t"))
		var _t51 = (_t50 if J.t(_t50) else [])
		J.sp(v_by_153, _t49, _t51)
		J.mc(_t51, "push", [v_c_158])
	v_ts_154 = J.S_Object_("keys", [v_by_153])
	v_s_155 = 0.0
	for _t52 in J.iter(v_ts_154):
		v_t_159 = _t52
		var _t53 = J.add(v_s_155, J.gp(env["W"], v_t_159))
		v_s_155 = _t53
	v_x_156 = J.mul(J.cl(env["r"], null, []), v_s_155)
	for _t54 in J.iter(v_ts_154):
		v_t_160 = _t54
		var _t55 = J.sub(v_x_156, J.gp(env["W"], v_t_160))
		v_x_156 = _t55
		if J.cmp(v_x_156, 0.0, "<="):
			return J.gp(J.gp(v_by_153, v_t_160), floor(J.num(J.mul(J.cl(env["r"], null, []), J.len(J.gp(v_by_153, v_t_160))))))
	v_l_157 = J.gp(v_by_153, J.gp(v_ts_154, (J.len(v_ts_154) - 1.0)))
	return J.gp(v_l_157, floor(J.num(J.mul(J.cl(env["r"], null, []), J.len(v_l_157)))))

func _f27(this_, a: Array, env):
	var v_c_162 = null
	v_c_162 = J.arg(a, 0)
	return J.seq(J.gp(v_c_162, "who"), env["i"])

func _f28(this_, a: Array, env):
	var v_c_163 = null
	v_c_163 = J.arg(a, 0)
	return J.S_JSON_("stringify", [[J.gp(v_c_163, "t"), J.gp(v_c_163, "who"), J.gp(v_c_163, "j"), J.gp(v_c_163, "v")]])

func _f29(this_, a: Array, env):
	var v_c_164 = null; var v_a_165 = null; var v_b_166 = null
	v_c_164 = J.arg(a, 0)
	v_a_165 = J.gp(v_c_164, "who")
	v_b_166 = J.gp(v_c_164, "j")
	var _t56 = J.gp(v_c_164, "t")
	var _t57 = -1
	var _t58 = false
	if _t57 == -1 and J.seq(_t56, "job_is"): _t57 = 0
	if _t57 == -1 and J.seq(_t56, "job_not"): _t57 = 1
	if _t57 == -1 and J.seq(_t56, "ojob_not"): _t57 = 2
	if _t57 == -1 and J.seq(_t56, "same_row"): _t57 = 3
	if _t57 == -1 and J.seq(_t56, "died"): _t57 = 4
	if _t57 == -1 and J.seq(_t56, "rel"): _t57 = 5
	if _t57 == -1: _t57 = 6
	while true:
		if _t57 <= 0 and _t57 >= 0:
			return J.S_JSON_("stringify", [["job", v_a_165, J.gp(v_c_164, "v")]])
		if _t57 <= 1 and _t57 >= 0:
			return J.S_JSON_("stringify", [["job", v_a_165, J.gp(v_c_164, "v")]])
		if _t57 <= 2 and _t57 >= 0:
			return J.S_JSON_("stringify", [["job", v_b_166, J.gp(v_c_164, "v")]])
		if _t57 <= 3 and _t57 >= 0:
			return J.S_JSON_("stringify", [["row=", J.min_([v_a_165, v_b_166]), J.max_([v_a_165, v_b_166])]])
		if _t57 <= 4 and _t57 >= 0:
			return J.S_JSON_("stringify", [["died", (v_a_165 if J.seq(J.gp(v_c_164, "v"), "early") else v_b_166), (v_b_166 if J.seq(J.gp(v_c_164, "v"), "early") else v_a_165)]])
		if _t57 <= 5 and _t57 >= 0:
			return J.S_JSON_("stringify", [(["above", v_a_165, v_b_166] if J.seq(J.gp(v_c_164, "v"), "up") else (["above", v_b_166, v_a_165] if J.seq(J.gp(v_c_164, "v"), "down") else (["leftof", v_a_165, v_b_166] if J.seq(J.gp(v_c_164, "v"), "left") else ["leftof", v_b_166, v_a_165])))])
		if _t57 <= 6 and _t57 >= 0:
			return J.S_JSON_("stringify", [[J.gp(v_c_164, "t"), v_a_165, J.gp(v_c_164, "v")]])
		break

func _f30(this_, a: Array, env):
	var v_c_167 = null
	v_c_167 = J.arg(a, 0)
	J.mc(env["chosen"], "push", [v_c_167])
	var _t59 = env["key"]
	J.mc(env["has"], "add", [J.cl(_t59, null, [v_c_167])])
	var _t60 = env["sig"]
	J.mc(env["said"], "add", [J.cl(_t60, null, [v_c_167])])
	var _t61 = env["isDirect"]
	if J.t(J.cl(_t61, null, [v_c_167])):
		env["nDirect"] = J.num(env["nDirect"]) + 1.0

func _f32(this_, a: Array, env):
	var v_c_169 = null
	v_c_169 = J.arg(a, 0)
	var _t63 = env["key"]
	var _t65 = (not J.t(J.mc(env["has"], "has", [J.cl(_t63, null, [v_c_169])])))
	if J.t(_t65):
		var _t64 = env["sig"]
		_t65 = (not J.t(J.mc(env["said"], "has", [J.cl(_t64, null, [v_c_169])])))
	var _t68 = _t65
	if J.t(_t68):
		var _t66 = env["isDirect"]
		var _t67 = (not J.t(J.cl(_t66, null, [v_c_169])))
		_t68 = (_t67 if _t67 else J.cmp(env["nDirect"], J.gp(env["L"], "direct"), "<"))
	return _t68

func _f31(this_, a: Array, env):
	var v_i_168 = null
	v_i_168 = J.arg(a, 0)
	var _t62 = J.gp(env["per"], v_i_168)
	return J.mc(_t62, "filter", [Callable(self, "_f32").bind(env)])

func _f33(this_, a: Array, env):
	var v_c_177 = null
	v_c_177 = J.arg(a, 0)
	return J.seq(J.gp(v_c_177, "who"), env["i"])

func _f34(this_, a: Array, env):
	var v_x_184 = null
	v_x_184 = J.arg(a, 0)
	return J.seq(J.gp(v_x_184, "who"), J.gp(env["c"], "who"))

func _f35(this_, a: Array, env):
	var v_x_185 = null
	v_x_185 = J.arg(a, 0)
	return (not J.seq(v_x_185, env["c"]))

func _f36(this_, a: Array, env):
	var v_c_186 = null
	v_c_186 = J.arg(a, 0)
	return (not J.leq(J.gp(v_c_186, "j"), null))

func _f37(this_, a: Array, env):
	var v_c_190 = null
	v_c_190 = J.arg(a, 0)
	return J.seq(J.gp(v_c_190, "who"), env["i"])

func _f38(this_, a: Array, env):
	var v_c_191 = null; var v_t_192 = null; var v_k_193 = null
	v_c_191 = J.arg(a, 0)
	v_t_192 = null
	v_k_193 = 0.0
	var _t77 = true
	while true:
		if not _t77:
			var _t79 = J.mc(env["__p"]["lines"], "has", [v_t_192])
			if J.t(_t79):
				var _t78 = J.num(v_k_193)
				v_k_193 = _t78 + 1.0
				_t79 = (_t78 < 8.0)
			if not J.t(_t79): break
		_t77 = false
		var _t80 = J.mc(env["__p"]["this"], "text", [v_c_191, env["__p"]["r"]])
		v_t_192 = _t80
	return v_t_192

func _f39(this_, a: Array, env):
	var v_t_194 = null
	v_t_194 = J.arg(a, 0)
	return J.mc(env["__p"]["lines"], "has", [v_t_194])

func _f40(this_, a: Array, env):
	var v_t_195 = null
	v_t_195 = J.arg(a, 0)
	return J.mc(env["__p"]["lines"], "add", [v_t_195])

func _f41(this_, a: Array, env):
	var v_g_196 = null; var v_i_197 = null
	v_g_196 = J.arg(a, 0)
	v_i_197 = J.arg(a, 1)
	return (not J.seq(v_g_196, J.gp(env["truth"], v_i_197)))

func _f11(this_, a: Array, env):
	var v_pickN_78 = null; var v_spots_79 = null; var v_n_86 = null; var v_add_89 = null; var v_usedRows_90 = null; var v_usedSides_91 = null; var v_useful_92 = null; var v_wpick_95 = null; var v_take_103 = null; var v_avail_104 = null; var v_sols_105 = null; var v_guard_106 = null; var v_souls_108 = null; var v_sol_109 = null; var v_i_126 = null; var v_others_128 = null; var v_sp_129 = null; var v_o_131 = null; var v_q_132 = null; var v_o_133 = null; var v_q_134 = null; var v_rw_135 = null; var v_sd_136 = null; var v_j_138 = null; var v_v_139 = null; var v_v_140 = null; var v_o_141 = null; var v_i_170 = null; var v_k_171 = null; var v_a_172 = null; var v_cand_173 = null; var v_best_174 = null; var v_bs_175 = null; var v_c_178 = null; var v_c_179 = null; var v_s_180 = null; var v_sc_181 = null; var v_rest_183 = null; var v_mine_188 = null; var v_ls_189 = null
	var _s23 = {"__p": env, "this": null, "L": null, "r": null, "sn": null, "gv": null, "jobs": null, "offs": null, "deaths": null, "graves": null, "truth": null, "pool": null, "isDirect": null, "W": null, "per": null, "chosen": null, "key": null, "has": null, "nDirect": null, "sig": null, "said": null, "lines": null}
	_s23["this"] = this_
	_s23["L"] = J.arg(a, 0)
	_s23["r"] = J.arg(a, 1)
	v_pickN_78 = Callable(self, "_f12").bind(_s23)
	v_spots_79 = J.mc(J.cl(v_pickN_78, null, [J.S_Object_("keys", [J.G.get("GY_SPOTS")]), J.gp(_s23["L"], "g")]), "sort", [])
	_s23["sn"] = J.cl(v_pickN_78, null, [J.G.get("GY_SURN"), J.gp(_s23["L"], "g")])
	_s23["gv"] = J.cl(v_pickN_78, null, [J.G.get("GY_GIVEN"), J.gp(_s23["L"], "g")])
	_s23["jobs"] = J.cl(v_pickN_78, null, [J.S_Object_("keys", [J.G.get("GY_JOBS")]), J.gp(_s23["L"], "g")])
	_s23["offs"] = J.cl(v_pickN_78, null, [J.G.get("GY_OFFERS"), J.gp(_s23["L"], "g")])
	_s23["deaths"] = []
	while true:
		if not J.cmp(J.len(_s23["deaths"]), J.gp(_s23["L"], "g"), "<"): break
		var _s25 = {"__p": _s23, "d": null}
		_s25["d"] = (1986.0 + floor(J.num(J.mul(J.cl(_s25["__p"]["r"], null, []), 39.0))))
		if J.t(J.mc(_s25["__p"]["deaths"], "every", [Callable(self, "_f13").bind(_s25)])):
			J.mc(_s25["__p"]["deaths"], "push", [_s25["d"]])
	_s23["graves"] = J.mc(v_spots_79, "map", [Callable(self, "_f14").bind(_s23)])
	if (not J.seq(J.gp(J.new_("Set", [J.mc(_s23["graves"], "map", [Callable(self, "_f15").bind(_s23)])]), "size"), J.len(_s23["graves"]))):
		return null
	v_n_86 = J.gp(_s23["L"], "n")
	var _t31 = J.mc(_s23["this"], "shuffle", [J.mc(_s23["graves"], "map", [Callable(self, "_f16").bind(_s23)]), _s23["r"]])
	_s23["truth"] = J.mc(_t31, "slice", [0.0, v_n_86])
	_s23["pool"] = []
	v_add_89 = Callable(self, "_f17").bind(_s23)
	v_usedRows_90 = J.new_("Set", [J.mc(_s23["graves"], "map", [Callable(self, "_f18").bind(_s23)])])
	v_usedSides_91 = J.new_("Set", [J.mc(_s23["graves"], "map", [Callable(self, "_f19").bind(_s23)])])
	v_i_126 = 0.0
	while true:
		if not J.cmp(v_i_126, v_n_86, "<"): break
		var _s34 = {"__p": _s23, "me": null}
		_s34["me"] = J.gp(_s34["__p"]["graves"], J.gp(_s34["__p"]["truth"], v_i_126))
		v_others_128 = J.mc(_s34["__p"]["graves"], "filter", [Callable(self, "_f20").bind(_s34)])
		v_sp_129 = J.gp(J.G.get("GY_SPOTS"), J.gp(_s34["me"], "spot"))
		J.cl(v_add_89, null, [{"t": "job_is", "who": v_i_126, "v": J.gp(_s34["me"], "job")}])
		for _t32 in J.iter(v_others_128):
			v_o_131 = _t32
			J.cl(v_add_89, null, [{"t": "job_not", "who": v_i_126, "v": J.gp(v_o_131, "job")}])
			J.cl(v_add_89, null, [{"t": "off_not", "who": v_i_126, "v": J.gp(v_o_131, "off")}])
		J.cl(v_add_89, null, [{"t": "off_is", "who": v_i_126, "v": J.gp(_s34["me"], "off")}])
		for _t33 in J.iter(J.gp(_s34["me"], "keys")):
			v_q_132 = _t33
			J.cl(v_add_89, null, [{"t": "quote", "who": v_i_126, "v": v_q_132}])
		for _t34 in J.iter(v_others_128):
			v_o_133 = _t34
			for _t35 in J.iter(J.gp(v_o_133, "keys")):
				v_q_134 = _t35
				var _t36 = J.gp(_s34["me"], "ep")
				if (not J.t(J.mc(_t36, "includes", [v_q_134]))):
					J.cl(v_add_89, null, [{"t": "quote_not", "who": v_i_126, "v": v_q_134}])
		J.cl(v_add_89, null, [{"t": "age", "who": v_i_126, "v": floor(J.num(J.div(J.sub(J.gp(_s34["me"], "death"), J.gp(_s34["me"], "birth")), 10.0)))}])
		J.cl(v_add_89, null, [{"t": "surname", "who": v_i_126, "v": J.gp(J.gp(_s34["me"], "name"), 0.0)}])
		for _t37 in J.iter(v_usedRows_90):
			v_rw_135 = _t37
			if J.seq(v_rw_135, J.gp(v_sp_129, "row")):
				J.cl(v_add_89, null, [{"t": "row_is", "who": v_i_126, "v": v_rw_135}])
			else:
				J.cl(v_add_89, null, [{"t": "row_not", "who": v_i_126, "v": v_rw_135}])
		for _t38 in J.iter(v_usedSides_91):
			v_sd_136 = _t38
			if J.seq(v_sd_136, 1.0):
				continue
			if J.seq(v_sd_136, J.gp(v_sp_129, "side")):
				J.cl(v_add_89, null, [{"t": "side_is", "who": v_i_126, "v": v_sd_136}])
			else:
				J.cl(v_add_89, null, [{"t": "side_not", "who": v_i_126, "v": v_sd_136}])
		if J.t(J.mc(_s34["__p"]["graves"], "some", [Callable(self, "_f21").bind(_s34)])):
			J.cl(v_add_89, null, [{"t": ("tree" if J.seq(J.gp(_s34["me"], "spot"), "D") else "tree_not"), "who": v_i_126}])
		v_j_138 = 0.0
		while true:
			if not J.cmp(v_j_138, v_n_86, "<"): break
			if J.seq(v_j_138, v_i_126):
				v_j_138 = J.num(v_j_138) + 1.0
				continue
			for _t39 in J.iter(["up", "down", "left", "right"]):
				v_v_139 = _t39
				J.cl(v_add_89, null, [{"t": "rel", "who": v_i_126, "j": v_j_138, "v": v_v_139}])
			J.cl(v_add_89, null, [{"t": "same_row", "who": v_i_126, "j": v_j_138}])
			for _t40 in J.iter(["early", "late"]):
				v_v_140 = _t40
				J.cl(v_add_89, null, [{"t": "died", "who": v_i_126, "j": v_j_138, "v": v_v_140}])
			for _t41 in J.iter(_s34["__p"]["graves"]):
				v_o_141 = _t41
				if (not J.seq(v_o_141, J.gp(_s34["__p"]["graves"], J.gp(_s34["__p"]["truth"], v_j_138)))):
					J.cl(v_add_89, null, [{"t": "ojob_not", "who": v_i_126, "j": v_j_138, "v": J.gp(v_o_141, "job")}])
			v_j_138 = J.num(v_j_138) + 1.0
		v_i_126 = J.num(v_i_126) + 1.0
	v_useful_92 = J.mc(_s23["pool"], "filter", [Callable(self, "_f22").bind(_s23)])
	_s23["isDirect"] = Callable(self, "_f24").bind(_s23)
	_s23["W"] = {"job_is": 1.0, "job_not": 3.0, "ojob_not": 2.0, "off_is": 1.0, "off_not": 2.0, "quote": 3.0, "quote_not": 2.0, "age": 3.0, "surname": 1.0, "row_is": 2.0, "row_not": 2.0, "side_is": 2.0, "side_not": 2.0, "tree": 1.0, "tree_not": 2.0, "rel": 5.0, "same_row": 4.0, "died": 4.0}
	if J.seq(J.gp(_s23["L"], "n"), 3.0):
		J.S_Object_("assign", [_s23["W"], {"rel": 2.0, "died": 2.0, "same_row": 1.0, "ojob_not": 1.0, "quote": 4.0, "age": 3.0, "job_not": 3.0, "off_not": 3.0}])
	v_wpick_95 = Callable(self, "_f26").bind(_s23)
	_s23["per"] = []
	var _s63 = {"__p": _s23, "i": null}
	_s63["i"] = 0.0
	while true:
		_s63 = _s63.duplicate()
		if not J.cmp(_s63["i"], v_n_86, "<"): break
		J.mc(_s63["__p"]["per"], "push", [J.mc(v_useful_92, "filter", [Callable(self, "_f27").bind(_s63)])])
		_s63["i"] = J.num(_s63["i"]) + 1.0
	_s23["chosen"] = []
	_s23["key"] = Callable(self, "_f28").bind(_s23)
	_s23["has"] = J.new_("Set", [])
	_s23["nDirect"] = 0.0
	_s23["sig"] = Callable(self, "_f29").bind(_s23)
	_s23["said"] = J.new_("Set", [])
	v_take_103 = Callable(self, "_f30").bind(_s23)
	v_avail_104 = Callable(self, "_f31").bind(_s23)
	v_i_170 = 0.0
	while true:
		if not J.cmp(v_i_170, v_n_86, "<"): break
		v_k_171 = 0.0
		while true:
			if not J.cmp(v_k_171, 2.0, "<"): break
			v_a_172 = J.cl(v_avail_104, null, [v_i_170])
			if (not J.t(J.len(v_a_172))):
				return null
			J.cl(v_take_103, null, [J.cl(v_wpick_95, null, [v_a_172])])
			v_k_171 = J.num(v_k_171) + 1.0
		v_i_170 = J.num(v_i_170) + 1.0
	v_sols_105 = J.mc(_s23["this"], "solve", [v_n_86, _s23["graves"], _s23["chosen"], 3.0])
	v_guard_106 = 0.0
	while true:
		var _t70 = (J.len(v_sols_105) > 1.0)
		if J.t(_t70):
			var _t69 = J.num(v_guard_106)
			v_guard_106 = _t69 + 1.0
			_t70 = (_t69 < 20.0)
		if not _t70: break
		v_cand_173 = []
		var _s75 = {"__p": _s23, "i": null}
		_s75["i"] = 0.0
		while true:
			_s75 = _s75.duplicate()
			if not J.cmp(_s75["i"], v_n_86, "<"): break
			if (J.len(J.mc(_s75["__p"]["chosen"], "filter", [Callable(self, "_f33").bind(_s75)])) < 3.0):
				for _t71 in J.iter(J.cl(v_avail_104, null, [_s75["i"]])):
					v_c_178 = _t71
					J.mc(v_cand_173, "push", [v_c_178])
			_s75["i"] = J.num(_s75["i"]) + 1.0
		if (not J.t(J.len(v_cand_173))):
			return null
		J.mc(_s23["this"], "shuffle", [v_cand_173, _s23["r"]])
		v_best_174 = null
		v_bs_175 = 1000000000.0
		for _t72 in J.iter(J.mc(v_cand_173, "slice", [0.0, 24.0])):
			v_c_179 = _t72
			v_s_180 = J.len(J.mc(_s23["this"], "solve", [v_n_86, _s23["graves"], J.mc(_s23["chosen"], "concat", [[v_c_179]]), 0.0]))
			v_sc_181 = J.sub(J.mul(v_s_180, 10.0), J.gp(_s23["W"], J.gp(v_c_179, "t")))
			var _t73 = J.cmp(v_s_180, 1.0, ">=")
			if (J.cmp(v_sc_181, v_bs_175, "<") if _t73 else _t73):
				v_bs_175 = v_sc_181
				v_best_174 = v_c_179
		J.cl(v_take_103, null, [v_best_174])
		var _t74 = J.mc(_s23["this"], "solve", [v_n_86, _s23["graves"], _s23["chosen"], 3.0])
		v_sols_105 = _t74
	if (not J.seq(J.len(v_sols_105), 1.0)):
		return null
	for _t75 in J.iter(J.mc(_s23["this"], "shuffle", [J.mc(_s23["chosen"], "slice", []), _s23["r"]])):
		var _s81 = {"__p": _s23, "c": null}
		_s81["c"] = _t75
		if (J.len(J.mc(_s81["__p"]["chosen"], "filter", [Callable(self, "_f34").bind(_s81)])) <= 2.0):
			continue
		v_rest_183 = J.mc(_s81["__p"]["chosen"], "filter", [Callable(self, "_f35").bind(_s81)])
		if J.seq(J.len(J.mc(_s81["__p"]["this"], "solve", [v_n_86, _s81["__p"]["graves"], v_rest_183, 2.0])), 1.0):
			J.mc(_s81["__p"]["chosen"], "splice", [J.mc(_s81["__p"]["chosen"], "indexOf", [_s81["c"]]), 1.0])
	var _t76 = J.cmp(J.gp(_s23["L"], "n"), 4.0, ">=")
	if ((not J.t(J.mc(_s23["chosen"], "some", [Callable(self, "_f36").bind(_s23)]))) if _t76 else _t76):
		return null
	_s23["lines"] = J.new_("Set", [])
	v_souls_108 = []
	var _s86 = {"__p": _s23, "i": null}
	_s86["i"] = 0.0
	while true:
		_s86 = _s86.duplicate()
		if not J.cmp(_s86["i"], v_n_86, "<"): break
		v_mine_188 = J.mc(_s86["__p"]["this"], "shuffle", [J.mc(_s86["__p"]["chosen"], "filter", [Callable(self, "_f37").bind(_s86)]), _s86["__p"]["r"]])
		v_ls_189 = J.mc(v_mine_188, "map", [Callable(self, "_f38").bind(_s86)])
		if J.t(J.mc(v_ls_189, "some", [Callable(self, "_f39").bind(_s86)])):
			return null
		J.mc(v_ls_189, "forEach", [Callable(self, "_f40").bind(_s86)])
		J.mc(v_souls_108, "push", [{"tag": J.gp(J.G.get("GY_TAGS"), _s86["i"]), "grave": J.gp(_s86["__p"]["truth"], _s86["i"]), "clues": v_mine_188, "lines": v_ls_189}])
		_s86["i"] = J.num(_s86["i"]) + 1.0
	v_sol_109 = J.mc(_s23["this"], "solve", [v_n_86, _s23["graves"], _s23["chosen"], 0.0])
	var _t82 = (not J.seq(J.len(v_sol_109), 1.0))
	if not J.t(_t82):
		var _t81 = J.gp(v_sol_109, 0.0)
		_t82 = J.mc(_t81, "some", [Callable(self, "_f41").bind(_s23)])
	if J.t(_t82):
		return null
	return {"graves": _s23["graves"], "souls": v_souls_108}

func _f42(this_, a: Array, env):
	var v_g_198 = null
	v_g_198 = J.arg(a, 0)
	return {"spot": J.gp(v_g_198, "spot"), "name": J.gp(v_g_198, "name"), "years": (J.str(J.gp(v_g_198, "birth")) + " – " + J.str(J.gp(v_g_198, "death"))), "job": J.gp(v_g_198, "job"), "ep": J.gp(v_g_198, "ep"), "off": J.gp(v_g_198, "off")}

func _f43(this_, a: Array, env):
	var v_y_201 = null
	var _t85 = (not J.t(J.gp(J.G.get("S"), "yard")))
	if (_t85 if _t85 else (not J.seq(J.typeof_(J.gp(J.G.get("S"), "yard")), "object"))):
		var _t86 = J.G.get("S")
		var _t87 = {}
		J.sp(_t86, "yard", _t87)
	v_y_201 = J.gp(J.G.get("S"), "yard")
	if (not J.cmp(J.gp(v_y_201, "night"), 1.0, ">=")):
		J.sp(v_y_201, "night", 1.0)
	var _t88 = floor(J.num(J.gp(v_y_201, "night")))
	J.sp(v_y_201, "night", _t88)
	if (not J.cmp(J.gp(v_y_201, "best"), 0.0, ">=")):
		J.sp(v_y_201, "best", 0.0)
	if (not J.t(J.S_Array_("isArray", [J.gp(v_y_201, "rested")]))):
		var _t89 = []
		J.sp(v_y_201, "rested", _t89)
	if (not J.cmp(J.gp(v_y_201, "seed"), 0.0, ">")):
		var _t90 = (1.0 + floor(J.num((randf() * 2000000000.0))))
		J.sp(v_y_201, "seed", _t90)
	return v_y_201

func _f45(this_, a: Array, env):
	var v_s_209 = null; var v_i_210 = null
	v_s_209 = J.arg(a, 0)
	v_i_210 = J.arg(a, 1)
	return {"i": v_i_210, "tag": J.gp(v_s_209, "tag"), "place": null, "x": 0.0, "y": 0.0, "ph": (randf() * 6.0), "rx": null, "col": J.gp(J.G.get("GY_COLORS"), v_i_210), "a": J.gp(J.G.get("GY_ALPHA"), v_i_210)}

func _f46(this_, a: Array, env):
	var v_g_212 = null; var v_gi_213 = null; var v_r_214 = null; var v_st_215 = null; var v_k_216 = null
	v_g_212 = J.arg(a, 0)
	v_gi_213 = J.arg(a, 1)
	v_r_214 = J.mc(J.G.get("GY_GEN"), "rng", [J.add(J.gp(J.gp(env["this"], "p"), "seed"), J.mul(v_gi_213, 101.0))])
	v_st_215 = []
	v_k_216 = 0.0
	while true:
		if not J.cmp(v_k_216, 26.0, "<"): break
		J.mc(v_st_215, "push", [[J.cl(v_r_214, null, []), J.cl(v_r_214, null, []), (J.sub(J.cl(v_r_214, null, []), 0.5) * 0.5), J.cl(v_r_214, null, [])]])
		v_k_216 = J.num(v_k_216) + 1.0
	return v_st_215

func _f47(this_, a: Array, env):
	if (not J.seq(J.gp(env["this"], "phase"), "play")):
		return null
	var _t107 = J.G.get("confirmInline")
	var _t108 = J.G.get("$")
	if (not J.t(J.cl(_t107, null, [J.cl(_t108, null, ["#gy-quit"]), "確定收工？"]))):
		return null
	J.mc(env["this"], "close", [])

func _f48(this_, a: Array, env):
	if J.seq(J.gp(J.gp(env["this"], "view"), "k"), "rules"):
		var _t112 = env["this"]
		var _t113 = ({"k": "soul", "i": J.gp(env["this"], "sel")} if (not J.leq(J.gp(env["this"], "sel"), null)) else {"k": "soul", "i": 0.0})
		J.sp(_t112, "view", _t113)
		var _t114 = env["this"]
		J.sp(_t114, "guide", false)
	else:
		var _t115 = env["this"]
		var _t116 = {"k": "rules"}
		J.sp(_t115, "view", _t116)
		var _t117 = env["this"]
		J.sp(_t117, "guide", true)
	J.mc(env["this"], "renderPanel", [])

func _f50(this_, a: Array, env):
	var v_s_217 = null
	v_s_217 = J.arg(a, 0)
	J.sp(v_s_217, "place", null)
	return null

func _f49(this_, a: Array, env):
	if (not J.seq(J.gp(env["this"], "phase"), "play")):
		return null
	var _t121 = J.gp(env["this"], "souls")
	J.mc(_t121, "forEach", [Callable(self, "_f50").bind(env)])
	var _t122 = env["this"]
	J.sp(_t122, "sel", null)
	J.mc(env["this"], "renderPanel", [])

func _f51(this_, a: Array, env):
	return J.mc(env["this"], "submit", [])

func _f52(this_, a: Array, env):
	var v_e_218 = null
	v_e_218 = J.arg(a, 0)
	return J.mc(env["this"], "down", [v_e_218])

func _f53(this_, a: Array, env):
	var v_e_219 = null
	v_e_219 = J.arg(a, 0)
	return J.mc(env["this"], "move", [v_e_219])

func _f54(this_, a: Array, env):
	var v_e_220 = null
	v_e_220 = J.arg(a, 0)
	return J.mc(env["this"], "up", [v_e_220])

func _f55(this_, a: Array, env):
	if J.t(J.gp(env["this"], "drag")):
		var _t128 = env["this"]
		J.sp(_t128, "drag", null)

func _f56(this_, a: Array, env):
	if J.t(J.gp(env["this"], "active")):
		J.mc(env["this"], "resize", [])

func _f57(this_, a: Array, env):
	var _t133 = J.gp(env["this"], "active")
	if J.t(_t133):
		var _t132 = J.G.get("$")
		_t133 = J.cl(_t132, null, ["#gy-stage"])
	if J.t(_t133):
		J.mc(env["this"], "resize", [])

func _f58(this_, a: Array, env):
	var v_now_221 = null
	v_now_221 = J.arg(a, 0)
	return J.mc(env["this"], "frame", [v_now_221, env["tok"]])

func _f44(this_, a: Array, env):
	var v_y_204 = null; var v_n_205 = null; var v_el_206 = null; var v_cv_207 = null; var v_i_211 = null
	var _s96 = {"__p": env, "this": null, "tok": null}
	_s96["this"] = this_
	v_y_204 = J.mc(_s96["this"], "ensure", [])
	J.cl(J.G.get("save"), null, [])
	var _t91 = _s96["this"]
	var _t92 = J.mc(J.G.get("GY_GEN"), "gen", [J.gp(v_y_204, "night"), J.gp(v_y_204, "seed")])
	J.sp(_t91, "p", _t92)
	v_n_205 = J.len(J.gp(J.gp(_s96["this"], "p"), "souls"))
	J.S_Object_("assign", [_s96["this"], {"active": true, "t": 0.0, "tries": 0.0, "phase": "play", "sel": null, "view": {"k": "soul", "i": 0.0}, "drag": null, "parts": [], "crows": [], "crowT": 4.0, "bub": null, "restT": 0.0, "guide": false}])
	var _t93 = _s96["this"]
	var _t94 = J.gp(J.gp(_s96["this"], "p"), "souls")
	var _t95 = J.mc(_t94, "map", [Callable(self, "_f45").bind(_s96)])
	J.sp(_t93, "souls", _t95)
	var _t96 = _s96["this"]
	var _t97 = []
	J.sp(_t96, "wisps", _t97)
	v_i_211 = 0.0
	while true:
		if not J.cmp(v_i_211, 7.0, "<"): break
		var _t98 = J.gp(_s96["this"], "wisps")
		J.mc(_t98, "push", [{"x": randf(), "y": (0.35 + (randf() * 0.55)), "ph": (randf() * 9.0), "sp": (0.3 + (randf() * 0.5))}])
		v_i_211 = J.num(v_i_211) + 1.0
	var _t99 = _s96["this"]
	var _t100 = J.gp(J.gp(_s96["this"], "p"), "graves")
	var _t101 = J.mc(_t100, "map", [Callable(self, "_f46").bind(_s96)])
	J.sp(_t99, "stones", _t101)
	var _t102 = J.G.get("$")
	v_el_206 = J.cl(_t102, null, ["#gyard"])
	var _t103 = J.gp(v_el_206, "classList")
	J.mc(_t103, "add", ["on"])
	var _t104 = ("<div id=\"gy-top\"><button class=\"btn sm ghost\" id=\"gy-quit\">收工</button><b>亂葬崗・第 " + J.str(J.gp(v_y_204, "night")) + " 夜</b><span id=\"gy-tries\"></span><button class=\"btn sm\" id=\"gy-rule\">規矩</button></div>\n      <div id=\"gy-hint\"></div><div id=\"gy-stage\"><canvas id=\"gy-cvs\"></canvas></div>\n      <div id=\"gy-panel\"><div id=\"gy-chips\"></div><div id=\"gy-info\"></div><div class=\"gy-acts\"><button class=\"btn\" id=\"gy-reset\">全部退回</button><button class=\"btn gold\" id=\"gy-go\">送他們安息</button></div></div><div id=\"gy-end\"></div>")
	J.sp(v_el_206, "innerHTML", _t104)
	var _t105 = J.G.get("$")
	var _t106 = J.cl(_t105, null, ["#gy-quit"])
	var _t109 = Callable(self, "_f47").bind(_s96)
	J.sp(_t106, "onclick", _t109)
	var _t110 = J.G.get("$")
	var _t111 = J.cl(_t110, null, ["#gy-rule"])
	var _t118 = Callable(self, "_f48").bind(_s96)
	J.sp(_t111, "onclick", _t118)
	var _t119 = J.G.get("$")
	var _t120 = J.cl(_t119, null, ["#gy-reset"])
	var _t123 = Callable(self, "_f49").bind(_s96)
	J.sp(_t120, "onclick", _t123)
	var _t124 = J.G.get("$")
	var _t125 = J.cl(_t124, null, ["#gy-go"])
	var _t126 = Callable(self, "_f51").bind(_s96)
	J.sp(_t125, "onclick", _t126)
	var _t127 = J.G.get("$")
	v_cv_207 = J.cl(_t127, null, ["#gy-cvs"])
	J.mc(v_cv_207, "addEventListener", ["pointerdown", Callable(self, "_f52").bind(_s96)])
	J.mc(v_cv_207, "addEventListener", ["pointermove", Callable(self, "_f53").bind(_s96)])
	J.mc(v_cv_207, "addEventListener", ["pointerup", Callable(self, "_f54").bind(_s96)])
	J.mc(v_cv_207, "addEventListener", ["pointercancel", Callable(self, "_f55").bind(_s96)])
	if (not J.t(J.gp(_s96["this"], "_rs"))):
		var _t129 = _s96["this"]
		J.sp(_t129, "_rs", true)
		J.S_window_("addEventListener", ["resize", Callable(self, "_f56").bind(_s96)])
	J.mc(J.G.get("Sound"), "setMode", ["story"])
	J.mc(J.G.get("Sound"), "play", ["crow", (-0.6)])
	J.mc(_s96["this"], "renderPanel", [])
	J.mc(_s96["this"], "resize", [])
	var _t130 = (not J.t(J.gp(_s96["this"], "_ro")))
	if ((not J.seq(J.typeof_(J.G.get("ResizeObserver")), "undefined")) if _t130 else _t130):
		var _t131 = _s96["this"]
		var _t134 = J.construct(J.G.get("ResizeObserver"), [Callable(self, "_f57").bind(_s96)])
		J.sp(_t131, "_ro", _t134)
	if J.t(J.gp(_s96["this"], "_ro")):
		var _t135 = J.gp(_s96["this"], "_ro")
		var _t136 = J.G.get("$")
		J.mc(_t135, "observe", [J.cl(_t136, null, ["#gy-stage"])])
	if (not J.t(J.gp(v_y_204, "seen"))):
		J.sp(v_y_204, "seen", 1.0)
		J.cl(J.G.get("save"), null, [])
		J.mc(_s96["this"], "hint", ["點魂，聽他記得什麼；點墓碑，看碑文。把每個魂拖到自己的墳前（或先點魂再點墳）。方位怎麼算，按右上「規矩」。", 14.0])
	else:
		J.mc(_s96["this"], "hint", [("今晚 " + J.str(v_n_205) + " 個魂" + (("，" + J.str(J.len(J.gp(J.gp(_s96["this"], "p"), "graves"))) + " 座墳（有一座不是他們的）") if J.cmp(J.len(J.gp(J.gp(_s96["this"], "p"), "graves")), v_n_205, ">") else "") + "。"), 5.0])
	var _t137 = _s96["this"]
	var _t138 = {}
	J.sp(_t137, "_tok", _t138)
	_s96["tok"] = _t138
	var _t139 = _s96["this"]
	var _t140 = J.S_performance_("now", [])
	J.sp(_t139, "last", _t140)
	J.F_requestAnimationFrame([Callable(self, "_f58").bind(_s96)])

func _f59(this_, a: Array, env):
	var v_el_224 = null
	var _t141 = this_
	J.sp(_t141, "active", false)
	var _t142 = this_
	J.sp(_t142, "_tok", null)
	if J.t(J.gp(this_, "_ro")):
		J.mc(J.gp(this_, "_ro"), "disconnect", [])
	var _t143 = J.G.get("$")
	v_el_224 = J.cl(_t143, null, ["#gyard"])
	var _t144 = J.gp(v_el_224, "classList")
	J.mc(_t144, "remove", ["on"])
	J.sp(v_el_224, "innerHTML", "")
	J.mc(J.G.get("Sound"), "setMode", ["village"])
	J.mc(J.G.get("UI"), "refresh", [])

func _f61(this_, a: Array, env):
	var _t150 = J.gp(env["h"], "classList")
	return J.mc(_t150, "remove", ["on"])

func _f62(this_, a: Array, env):
	var _t153 = J.gp(env["h"], "classList")
	return J.mc(_t153, "remove", ["on"])

func _f60(this_, a: Array, env):
	var v_text_227 = null; var v_sec_228 = null
	var _s120 = {"__p": env, "h": null}
	v_text_227 = J.arg(a, 0)
	v_sec_228 = J.arg(a, 1)
	var _t145 = J.G.get("$")
	_s120["h"] = J.cl(_t145, null, ["#gy-hint"])
	if (not J.t(_s120["h"])):
		return null
	var _t146 = _s120["h"]
	var _t147 = ("<span>" + J.str(v_text_227) + "</span><button aria-label=\"關閉\">✕</button>")
	J.sp(_t146, "innerHTML", _t147)
	var _t148 = J.gp(_s120["h"], "classList")
	J.mc(_t148, "add", ["on"])
	var _t149 = J.mc(_s120["h"], "querySelector", ["button"])
	var _t151 = Callable(self, "_f61").bind(_s120)
	J.sp(_t149, "onclick", _t151)
	J.F_clearTimeout([J.gp(this_, "_ht")])
	var _t152 = this_
	var _t154 = J.F_setTimeout([Callable(self, "_f62").bind(_s120), J.mul((v_sec_228 if J.t(v_sec_228) else 6.0), 1000.0)])
	J.sp(_t152, "_ht", _t154)

func _f63(this_, a: Array, env):
	var v_c_232 = null; var v_box_233 = null; var v_dpr_234 = null
	var _t155 = J.G.get("$")
	v_c_232 = J.cl(_t155, null, ["#gy-cvs"])
	var _t156 = J.G.get("$")
	v_box_233 = J.mc(J.cl(_t156, null, ["#gy-stage"]), "getBoundingClientRect", [])
	var _t157 = J.gp(J.G.get("window"), "devicePixelRatio")
	var _t158 = J.gp(J.G.get("window"), "devicePixelRatio")
	v_dpr_234 = J.min_([2.0, (_t158 if J.t(_t158) else 1.0)])
	var _t159 = J.mul(J.gp(v_box_233, "width"), v_dpr_234)
	J.sp(v_c_232, "width", _t159)
	var _t160 = J.mul(J.gp(v_box_233, "height"), v_dpr_234)
	J.sp(v_c_232, "height", _t160)
	var _t161 = J.gp(v_c_232, "style")
	var _t162 = J.add(J.gp(v_box_233, "width"), "px")
	J.sp(_t161, "width", _t162)
	var _t163 = J.gp(v_c_232, "style")
	var _t164 = J.add(J.gp(v_box_233, "height"), "px")
	J.sp(_t163, "height", _t164)
	var _t165 = this_
	var _t166 = J.gp(v_box_233, "width")
	J.sp(_t165, "W", _t166)
	var _t167 = this_
	var _t168 = J.gp(v_box_233, "height")
	J.sp(_t167, "H", _t168)
	var _t169 = this_
	J.sp(_t169, "dpr", v_dpr_234)

func _f64(this_, a: Array, env):
	var v_img_237 = null; var v_iw_238 = null; var v_ih_239 = null; var v_W_240 = null; var v_H_241 = null; var v_s_242 = null
	v_img_237 = J.gp(J.G.get("SPR"), "bg_graveyard")
	var _t170 = (J.gp(v_img_237, "naturalWidth") if J.t(v_img_237) else v_img_237)
	v_iw_238 = (_t170 if J.t(_t170) else 768.0)
	var _t171 = (J.gp(v_img_237, "naturalHeight") if J.t(v_img_237) else v_img_237)
	v_ih_239 = (_t171 if J.t(_t171) else 1152.0)
	var _t172 = J.gp(this_, "W")
	v_W_240 = (_t172 if J.t(_t172) else 390.0)
	var _t173 = J.gp(this_, "H")
	v_H_241 = (_t173 if J.t(_t173) else 560.0)
	v_s_242 = J.max_([J.div(v_W_240, v_iw_238), J.div(v_H_241, v_ih_239)])
	if J.cmp((J.mul(v_ih_239, v_s_242) * 0.75), v_H_241, ">"):
		var _t174 = J.div(v_H_241, J.mul(v_ih_239, 0.75))
		v_s_242 = _t174
	return {"s": v_s_242, "iw": v_iw_238, "ih": v_ih_239, "ox": J.div(J.sub(v_W_240, J.mul(v_iw_238, v_s_242)), 2.0), "oy": J.sub(v_H_241, J.mul(v_ih_239, v_s_242))}

func _f65(this_, a: Array, env):
	var v_fx_245 = null; var v_fy_246 = null; var v_b_247 = null
	v_fx_245 = J.arg(a, 0)
	v_fy_246 = J.arg(a, 1)
	v_b_247 = J.mc(this_, "bgScale", [])
	return [J.add(J.mul(J.mul(v_fx_245, J.gp(v_b_247, "iw")), J.gp(v_b_247, "s")), J.gp(v_b_247, "ox")), J.add(J.mul(J.mul(v_fy_246, J.gp(v_b_247, "ih")), J.gp(v_b_247, "s")), J.gp(v_b_247, "oy"))]

func _f66(this_, a: Array, env):
	var v_b_250 = null
	v_b_250 = J.mc(this_, "bgScale", [])
	return J.div(J.mul(J.gp(v_b_250, "iw"), J.gp(v_b_250, "s")), 390.0)

func _f67(this_, a: Array, env):
	return J.mul(64.0, J.mc(this_, "unit", []))

func _f68(this_, a: Array, env):
	var v_i_255 = null; var v_n_256 = null; var v_x0_257 = null; var v_x1_258 = null
	v_i_255 = J.arg(a, 0)
	v_n_256 = J.len(J.gp(this_, "souls"))
	v_x0_257 = 0.32
	v_x1_258 = 0.9
	return [J.add(v_x0_257, ((0.5 if J.seq(v_n_256, 1.0) else J.div(v_i_255, J.sub(v_n_256, 1.0))) * J.sub(v_x1_258, v_x0_257))), 0.955]

func _f69(this_, a: Array, env):
	var v_gi_261 = null; var v_g_262 = null; var v_s_263 = null
	v_gi_261 = J.arg(a, 0)
	v_g_262 = J.gp(J.gp(J.gp(this_, "p"), "graves"), v_gi_261)
	v_s_263 = J.gp(J.G.get("GY_SPOTS"), J.gp(v_g_262, "spot"))
	return [J.gp(v_s_263, "x"), J.gp(v_s_263, "y")]

func _f70(this_, a: Array, env):
	var v_gi_266 = null; var v_x_267 = null; var v_y_268 = null
	v_gi_266 = J.arg(a, 0)
	var _t175 = J.mc(this_, "graveAt", [v_gi_266])
	var _t176 = J.gp(_t175, 0.0)
	v_x_267 = _t176
	var _t177 = J.gp(_t175, 1.0)
	v_y_268 = _t177
	return [J.add(v_x_267, 0.13), J.add(v_y_268, 0.045)]

func _f71(this_, a: Array, env):
	var v_s_271 = null
	v_s_271 = J.arg(a, 0)
	return (J.mc(this_, "standOf", [J.gp(v_s_271, "place")]) if (not J.leq(J.gp(v_s_271, "place"), null)) else J.mc(this_, "homeOf", [J.gp(v_s_271, "i")]))

func _f72(this_, a: Array, env):
	var v_gi_274 = null; var v_x_275 = null; var v_y_276 = null; var v_u_277 = null; var v_w_278 = null; var v_h_279 = null
	v_gi_274 = J.arg(a, 0)
	var _t178 = J.mc(this_, "pt", J.spread([J.SP(J.mc(this_, "graveAt", [v_gi_274]))]))
	var _t179 = J.gp(_t178, 0.0)
	v_x_275 = _t179
	var _t180 = J.gp(_t178, 1.0)
	v_y_276 = _t180
	v_u_277 = J.mc(this_, "unit", [])
	v_w_278 = J.mul(50.0, v_u_277)
	v_h_279 = J.mul(64.0, v_u_277)
	return {"x": J.sub(v_x_275, J.div(v_w_278, 2.0)), "y": (J.sub(v_y_276, v_h_279) + J.mul(6.0, v_u_277)), "w": v_w_278, "h": v_h_279, "cx": v_x_275, "by": J.add(v_y_276, J.mul(6.0, v_u_277))}

func _f73(this_, a: Array, env):
	var v_e_282 = null; var v_r_283 = null
	v_e_282 = J.arg(a, 0)
	var _t181 = J.G.get("$")
	v_r_283 = J.mc(J.cl(_t181, null, ["#gy-cvs"]), "getBoundingClientRect", [])
	return [J.sub(J.gp(v_e_282, "clientX"), J.gp(v_r_283, "left")), J.sub(J.gp(v_e_282, "clientY"), J.gp(v_r_283, "top"))]

func _f74(this_, a: Array, env):
	var v_mx_286 = null; var v_my_287 = null; var v_hh_288 = null; var v_best_289 = null; var v_bd_290 = null; var v_s_291 = null; var v_x_292 = null; var v_y_293 = null; var v_d_294 = null
	v_mx_286 = J.arg(a, 0)
	v_my_287 = J.arg(a, 1)
	v_hh_288 = J.mc(this_, "soulH", [])
	v_best_289 = null
	v_bd_290 = 1000000000.0
	for _t182 in J.iter(J.gp(this_, "souls")):
		v_s_291 = _t182
		v_x_292 = J.gp(v_s_291, "px")
		v_y_293 = J.gp(v_s_291, "py")
		if J.leq(v_x_292, null):
			continue
		var _t183 = J.cmp(v_mx_286, J.sub(v_x_292, J.mul(v_hh_288, 0.42)), ">")
		var _t184 = (J.cmp(v_mx_286, J.add(v_x_292, J.mul(v_hh_288, 0.42)), "<") if _t183 else _t183)
		var _t185 = (J.cmp(v_my_287, J.sub(v_y_293, J.mul(v_hh_288, 1.05)), ">") if _t184 else _t184)
		if (J.cmp(v_my_287, J.add(v_y_293, 8.0), "<") if _t185 else _t185):
			v_d_294 = (absf(J.num(J.sub(v_mx_286, v_x_292))) + absf(J.num(J.sub(v_my_287, J.sub(v_y_293, J.div(v_hh_288, 2.0))))))
			if J.cmp(v_d_294, v_bd_290, "<"):
				v_bd_290 = v_d_294
				v_best_289 = v_s_291
	return v_best_289

func _f76(this_, a: Array, env):
	var v_g_302 = null; var v_gi_303 = null; var v_r_304 = null; var v_cy_305 = null; var v_d_306 = null
	v_g_302 = J.arg(a, 0)
	v_gi_303 = J.arg(a, 1)
	v_r_304 = J.mc(env["this"], "stoneRect", [v_gi_303])
	v_cy_305 = J.sub(J.gp(v_r_304, "by"), J.mul(10.0, env["u"]))
	v_d_306 = J.hypot_([J.div(J.sub(env["mx"], J.gp(v_r_304, "cx")), 1.25), J.sub(env["my"], v_cy_305)])
	var _t187 = J.cmp(v_d_306, J.mul(58.0, env["u"]), "<")
	if (J.cmp(v_d_306, env["bd"], "<") if _t187 else _t187):
		env["bd"] = v_d_306
		env["best"] = v_gi_303

func _f75(this_, a: Array, env):
	var _s139 = {"__p": env, "this": null, "mx": null, "my": null, "best": null, "bd": null, "u": null}
	_s139["this"] = this_
	_s139["mx"] = J.arg(a, 0)
	_s139["my"] = J.arg(a, 1)
	_s139["best"] = null
	_s139["bd"] = 1000000000.0
	_s139["u"] = J.mc(_s139["this"], "unit", [])
	var _t186 = J.gp(J.gp(_s139["this"], "p"), "graves")
	J.mc(_t186, "forEach", [Callable(self, "_f76").bind(_s139)])
	return _s139["best"]

func _f77(this_, a: Array, env):
	var v_e_309 = null; var v_mx_310 = null; var v_my_311 = null; var v_s_312 = null; var v_g_313 = null; var v_er_314 = null
	v_e_309 = J.arg(a, 0)
	if (not J.seq(J.gp(this_, "phase"), "play")):
		return null
	var _t188 = J.mc(this_, "local", [v_e_309])
	var _t189 = J.gp(_t188, 0.0)
	v_mx_310 = _t189
	var _t190 = J.gp(_t188, 1.0)
	v_my_311 = _t190
	v_s_312 = J.mc(this_, "soulAtPx", [v_mx_310, v_my_311])
	if J.t(v_s_312):
		var _t191 = this_
		var _t192 = {"s": v_s_312, "x0": v_mx_310, "y0": v_my_311, "mx": v_mx_310, "my": v_my_311, "moved": false}
		J.sp(_t191, "drag", _t192)
		var _t193 = J.G.get("$")
		var _t194 = J.cl(_t193, null, ["#gy-cvs"])
		J.mc(_t194, "setPointerCapture", [J.gp(v_e_309, "pointerId")])
		return null
	v_g_313 = J.mc(this_, "graveAtPx", [v_mx_310, v_my_311])
	if (not J.leq(v_g_313, null)):
		if (not J.leq(J.gp(this_, "sel"), null)):
			J.mc(this_, "place", [J.gp(this_, "sel"), v_g_313])
		else:
			var _t195 = this_
			var _t196 = {"k": "grave", "i": v_g_313}
			J.sp(_t195, "view", _t196)
			var _t197 = this_
			J.sp(_t197, "guide", false)
			J.mc(J.G.get("Sound"), "play", ["paper"])
			J.mc(this_, "renderPanel", [])
		return null
	if (not J.leq(J.gp(this_, "sel"), null)):
		var _t198 = this_
		J.sp(_t198, "sel", null)
		J.mc(this_, "renderPanel", [])

func _f78(this_, a: Array, env):
	var v_e_317 = null; var v_d_318 = null; var v_mx_319 = null; var v_my_320 = null
	v_e_317 = J.arg(a, 0)
	v_d_318 = J.gp(this_, "drag")
	if (not J.t(v_d_318)):
		return null
	var _t199 = J.mc(this_, "local", [v_e_317])
	var _t200 = J.gp(_t199, 0.0)
	v_mx_319 = _t200
	var _t201 = J.gp(_t199, 1.0)
	v_my_320 = _t201
	J.sp(v_d_318, "mx", v_mx_319)
	J.sp(v_d_318, "my", v_my_320)
	if (J.hypot_([J.sub(v_mx_319, J.gp(v_d_318, "x0")), J.sub(v_my_320, J.gp(v_d_318, "y0"))]) > 9.0):
		J.sp(v_d_318, "moved", true)

func _f79(this_, a: Array, env):
	var v_e_323 = null; var v_d_324 = null; var v_mx_325 = null; var v_my_326 = null; var v_g_327 = null
	v_e_323 = J.arg(a, 0)
	v_d_324 = J.gp(this_, "drag")
	if (not J.t(v_d_324)):
		return null
	var _t202 = this_
	J.sp(_t202, "drag", null)
	var _t203 = J.mc(this_, "local", [v_e_323])
	var _t204 = J.gp(_t203, 0.0)
	v_mx_325 = _t204
	var _t205 = J.gp(_t203, 1.0)
	v_my_326 = _t205
	if (not J.t(J.gp(v_d_324, "moved"))):
		var _t206 = this_
		var _t207 = (null if J.seq(J.gp(this_, "sel"), J.gp(J.gp(v_d_324, "s"), "i")) else J.gp(J.gp(v_d_324, "s"), "i"))
		J.sp(_t206, "sel", _t207)
		if (not J.leq(J.gp(this_, "sel"), null)):
			var _t208 = this_
			var _t209 = {"k": "soul", "i": J.gp(J.gp(v_d_324, "s"), "i")}
			J.sp(_t208, "view", _t209)
			var _t210 = this_
			J.sp(_t210, "guide", false)
			J.mc(J.G.get("Sound"), "play", ["click"])
		J.mc(this_, "renderPanel", [])
		return null
	v_g_327 = J.mc(this_, "graveAtPx", [v_mx_325, J.sub(v_my_326, J.mul(20.0, J.mc(this_, "unit", [])))])
	if (not J.leq(v_g_327, null)):
		J.mc(this_, "place", [J.gp(J.gp(v_d_324, "s"), "i"), v_g_327])
	else:
		var _t211 = J.gp(v_d_324, "s")
		J.sp(_t211, "place", null)
		J.mc(this_, "renderPanel", [])

func _f80(this_, a: Array, env):
	var v_si_330 = null; var v_gi_331 = null; var v_o_332 = null
	v_si_330 = J.arg(a, 0)
	v_gi_331 = J.arg(a, 1)
	if (not J.seq(J.gp(this_, "phase"), "play")):
		return null
	for _t212 in J.iter(J.gp(this_, "souls")):
		v_o_332 = _t212
		var _t213 = J.seq(J.gp(v_o_332, "place"), v_gi_331)
		if ((not J.seq(J.gp(v_o_332, "i"), v_si_330)) if _t213 else _t213):
			J.sp(v_o_332, "place", null)
	var _t214 = J.gp(J.gp(this_, "souls"), v_si_330)
	J.sp(_t214, "place", v_gi_331)
	var _t215 = this_
	J.sp(_t215, "sel", null)
	var _t216 = this_
	var _t217 = {"k": "grave", "i": v_gi_331, "who": v_si_330}
	J.sp(_t216, "view", _t217)
	var _t218 = this_
	J.sp(_t218, "guide", false)
	J.mc(J.G.get("Sound"), "play", ["whoosh"])
	J.mc(this_, "renderPanel", [])

func _f82(this_, a: Array, env):
	var v_s_335 = null
	v_s_335 = J.arg(a, 0)
	return (not J.leq(J.gp(v_s_335, "place"), null))

func _f81(this_, a: Array, env):
	var _t219 = J.gp(this_, "souls")
	return J.mc(_t219, "every", [Callable(self, "_f82").bind(env)])

func _f84(this_, a: Array, env):
	var v_s_338 = null
	v_s_338 = J.arg(a, 0)
	return J.seq(J.gp(v_s_338, "place"), J.gp(J.gp(J.gp(J.gp(env["this"], "p"), "souls"), J.gp(v_s_338, "i")), "grave"))

func _f83(this_, a: Array, env):
	var _s159 = {"__p": env, "this": null}
	_s159["this"] = this_
	var _t220 = J.gp(_s159["this"], "souls")
	return J.len(J.mc(_t220, "filter", [Callable(self, "_f84").bind(_s159)]))

func _f86(this_, a: Array, env):
	var v_s_343 = null; var v_j_344 = null
	v_s_343 = J.arg(a, 0)
	v_j_344 = J.arg(a, 1)
	var _t224 = {"k": "hurt", "t": ((-J.num(v_j_344)) * 0.08), "dur": 1.3}
	J.sp(v_s_343, "rx", _t224)
	return _t224

func _f87(this_, a: Array, env):
	return J.mc(env["this"], "finish", [false, env["k"]])

func _f85(this_, a: Array, env):
	var v_n_342 = null
	var _s161 = {"__p": env, "this": null, "k": null}
	_s161["this"] = this_
	var _t221 = (not J.seq(J.gp(_s161["this"], "phase"), "play"))
	if (_t221 if _t221 else (not J.t(J.mc(_s161["this"], "allPlaced", [])))):
		return null
	_s161["k"] = J.mc(_s161["this"], "correct", [])
	v_n_342 = J.len(J.gp(_s161["this"], "souls"))
	if J.seq(_s161["k"], v_n_342):
		J.mc(_s161["this"], "rest", [])
		return null
	var _t222 = _s161["this"]
	J.sp(_t222, "tries", J.num(J.gp(_t222, "tries")) + 1.0)
	var _t223 = J.gp(_s161["this"], "souls")
	J.mc(_t223, "forEach", [Callable(self, "_f86").bind(_s161)])
	J.mc(J.G.get("Sound"), "play", ["lose"])
	if J.cmp(J.gp(_s161["this"], "tries"), 2.0, ">="):
		var _t225 = _s161["this"]
		J.sp(_t225, "phase", "fail")
		J.mc(_s161["this"], "say", [("還是不對……只有 " + J.str(_s161["k"]) + " 個擺對了。天快亮了。"), 3.0])
		J.F_setTimeout([Callable(self, "_f87").bind(_s161), 1900.0])
	else:
		J.mc(_s161["this"], "say", [("他們不肯躺下。只有 " + J.str(_s161["k"]) + " 個擺對了。"), 4.5])
		J.mc(_s161["this"], "hint", [("只有 " + J.str(_s161["k"]) + " 個擺對了（不告訴你是哪幾個）。還有一次機會。"), 8.0])
	J.mc(_s161["this"], "renderPanel", [])

func _f88(this_, a: Array, env):
	var v_text_347 = null; var v_sec_348 = null
	v_text_347 = J.arg(a, 0)
	v_sec_348 = J.arg(a, 1)
	var _t226 = this_
	var _t227 = {"text": v_text_347, "life": (v_sec_348 if J.t(v_sec_348) else 3.0), "max": (v_sec_348 if J.t(v_sec_348) else 3.0)}
	J.sp(_t226, "bub", _t227)

func _f90(this_, a: Array, env):
	return J.mc(J.G.get("Sound"), "play", ["crow", (-0.4)])

func _f91(this_, a: Array, env):
	return J.mc(J.G.get("Sound"), "play", ["crow", 0.3])

func _f92(this_, a: Array, env):
	return J.mc(env["this"], "finish", [true, J.len(J.gp(env["this"], "souls"))])

func _f89(this_, a: Array, env):
	var v_i_351 = null
	var _s168 = {"__p": env, "this": null}
	_s168["this"] = this_
	var _t228 = _s168["this"]
	J.sp(_t228, "phase", "rest")
	var _t229 = _s168["this"]
	J.sp(_t229, "restT", 0.0)
	var _t230 = _s168["this"]
	J.sp(_t230, "sel", null)
	J.mc(J.G.get("Sound"), "play", ["gong"])
	J.F_setTimeout([Callable(self, "_f90").bind(_s168), 900.0])
	J.F_setTimeout([Callable(self, "_f91").bind(_s168), 1400.0])
	v_i_351 = 0.0
	while true:
		if not J.cmp(v_i_351, 6.0, "<"): break
		var _t231 = J.gp(_s168["this"], "crows")
		J.mc(_t231, "push", [{"x": (0.08 + (randf() * 0.2)), "y": (0.12 + (randf() * 0.12)), "vx": (0.16 + (randf() * 0.12)), "vy": ((-0.05) - (randf() * 0.06)), "ph": (randf() * 6.0), "s": (0.9 + (randf() * 0.5)), "delay": (0.8 + J.mul(v_i_351, 0.18)), "life": 4.0}])
		v_i_351 = J.num(v_i_351) + 1.0
	J.mc(_s168["this"], "say", ["都對了。去吧，下班了。", 3.0])
	J.mc(_s168["this"], "renderPanel", [])
	J.F_setTimeout([Callable(self, "_f92").bind(_s168), 3600.0])

func _f94(this_, a: Array, env):
	var v_g_371 = null
	v_g_371 = J.arg(a, 0)
	return J.seq(J.gp(v_g_371, "k"), "youhun")

func _f95(this_, a: Array, env):
	var v_s_373 = null; var v_i_374 = null; var v_g_375 = null; var v_wrong_376 = null
	v_s_373 = J.arg(a, 0)
	v_i_374 = J.arg(a, 1)
	v_g_375 = J.gp(J.gp(J.gp(env["this"], "p"), "graves"), J.gp(v_s_373, "grave"))
	v_wrong_376 = (not J.seq(J.gp(J.gp(J.gp(env["this"], "souls"), v_i_374), "place"), J.gp(v_s_373, "grave")))
	return ("<li><b style=\"color:" + J.str(J.gp(J.G.get("GY_COLORS"), v_i_374)) + "\">" + J.str(J.gp(v_s_373, "tag")) + "</b> <span>" + J.str(J.gp(v_g_375, "name")) + "・" + J.str(J.gp(v_g_375, "job")) + "・" + J.str(J.gp(v_g_375, "birth")) + "–" + J.str(J.gp(v_g_375, "death")) + "<br><small>" + (("「" + J.str(J.gp(J.gp(J.G.get("GY_JOBS"), J.gp(v_g_375, "job")), "last")) + "」") if J.t(env["ok"]) else (("其實睡在" if J.t(v_wrong_376) else "睡在") + J.str(J.gp(J.gp(J.G.get("GY_SPOTS"), J.gp(v_g_375, "spot")), "name")) + "那座" + ("" if J.t(v_wrong_376) else "，你擺對了"))) + "</small></span></li>")

func _f96(this_, a: Array, env):
	var v_k_377 = null
	if J.t(J.gp(env["this"], "_join")):
		var _t261 = env["this"]
		J.sp(_t261, "_join", false)
		var _t262 = J.G.get("joinGhost")
		J.cl(_t262, null, ["youhun"])
		J.cl(J.G.get("save"), null, [])
	if J.t(J.gp(env["this"], "_joinK")):
		v_k_377 = J.gp(env["this"], "_joinK")
		var _t263 = env["this"]
		J.sp(_t263, "_joinK", null)
		var _t264 = J.G.get("joinGhost")
		J.cl(_t264, null, [v_k_377])
		J.cl(J.G.get("save"), null, [])

func _f97(this_, a: Array, env):
	J.mc(env["this"], "close", [])
	J.cl(env["after"], null, [])

func _f98(this_, a: Array, env):
	J.cl(env["after"], null, [])
	if J.t(J.gp(env["this"], "_ro")):
		J.mc(J.gp(env["this"], "_ro"), "disconnect", [])
	J.mc(env["this"], "open", [])

func _f93(this_, a: Array, env):
	var v_k_355 = null; var v_y_356 = null; var v_n_357 = null; var v_night_358 = null; var v_perfect_359 = null; var v_hn_360 = null; var v_rw_361 = null; var v_got_362 = null; var v_stay_363 = null; var v_rows_364 = null; var v_title_365 = null; var v_word_366 = null; var v_s_368 = null; var v_s_369 = null; var v_nm_370 = null; var v_v_372 = null
	var _s173 = {"__p": env, "this": null, "ok": null, "after": null}
	_s173["this"] = this_
	_s173["ok"] = J.arg(a, 0)
	v_k_355 = J.arg(a, 1)
	var _t232 = (not J.t(J.gp(_s173["this"], "active")))
	if (_t232 if _t232 else J.seq(J.gp(_s173["this"], "phase"), "end")):
		return null
	v_y_356 = J.mc(_s173["this"], "ensure", [])
	v_n_357 = J.len(J.gp(_s173["this"], "souls"))
	v_night_358 = J.gp(v_y_356, "night")
	v_perfect_359 = (J.seq(J.gp(_s173["this"], "tries"), 0.0) if J.t(_s173["ok"]) else _s173["ok"])
	var _t233 = _s173["this"]
	J.sp(_t233, "phase", "end")
	J.F_clearTimeout([J.gp(_s173["this"], "_ht")])
	var _t234 = J.G.get("$")
	v_hn_360 = J.cl(_t234, null, ["#gy-hint"])
	if J.t(v_hn_360):
		var _t235 = J.gp(v_hn_360, "classList")
		J.mc(_t235, "remove", ["on"])
	v_rw_361 = null
	if J.t(_s173["ok"]):
		var _t236 = {"coins": J.round(J.num(((J.mul(25.0, v_n_357) + (5.0 * J.min_([v_night_358, 20.0]))) * (1.0 if J.t(v_perfect_359) else 0.6)))), "exp": J.round(J.num(J.mul(J.add(J.mul(5.0, v_n_357), v_night_358), (1.0 if J.t(v_perfect_359) else 0.6))))}
		v_rw_361 = _t236
		if J.t(v_perfect_359):
			var _t237 = ("b" if J.cmp(v_night_358, 5.0, ">=") else "g")
			J.sp(v_rw_361, "chest", _t237)
	else:
		var _t238 = {"coins": J.max_([5.0, J.mul(8.0, v_k_355)]), "exp": J.mul(2.0, v_k_355)}
		v_rw_361 = _t238
	var _t239 = J.G.get("give")
	v_got_362 = J.cl(_t239, null, [v_rw_361])
	v_stay_363 = ""
	if J.t(_s173["ok"]):
		var _t240 = J.max_([J.gp(v_y_356, "best"), v_night_358])
		J.sp(v_y_356, "best", _t240)
		for _t241 in J.iter(J.gp(J.gp(_s173["this"], "p"), "souls")):
			v_s_368 = _t241
			var _t242 = J.gp(v_y_356, "rested")
			J.mc(_t242, "push", [J.gp(J.gp(J.gp(J.gp(_s173["this"], "p"), "graves"), J.gp(v_s_368, "grave")), "name")])
		if (J.len(J.gp(v_y_356, "rested")) > 200.0):
			var _t243 = J.gp(v_y_356, "rested")
			var _t244 = J.mc(_t243, "slice", [(-200.0)])
			J.sp(v_y_356, "rested", _t244)
		if (randf() < 0.12):
			v_s_369 = J.gp(J.gp(J.gp(_s173["this"], "p"), "souls"), floor(J.num(J.mul(randf(), v_n_357))))
			v_nm_370 = J.gp(J.gp(J.gp(J.gp(_s173["this"], "p"), "graves"), J.gp(v_s_369, "grave")), "name")
			var _t245 = J.gp(J.G.get("S"), "ghosts")
			if (not J.t(J.mc(_t245, "some", [Callable(self, "_f94").bind(_s173)]))):
				v_stay_363 = (J.str(J.gp(v_s_369, "tag")) + "（" + J.str(v_nm_370) + "）回頭看了一眼：「村子裡……還缺人嗎？」")
				var _t246 = _s173["this"]
				J.sp(_t246, "_join", true)
			else:
				v_stay_363 = (J.str(J.gp(v_s_369, "tag")) + "（" + J.str(v_nm_370) + "）本來想留下，可是村裡已經有遊魂了。他把身上的冥幣都留給你。")
				var _t247 = J.G.get("give")
				var _t248 = J.add(v_got_362, J.add("，", J.cl(_t247, null, [{"coins": 30.0}])))
				v_got_362 = _t248
		var _t249 = (not J.t(v_stay_363))
		if ((not J.seq(J.typeof_(J.G.get("N30W")), "undefined")) if _t249 else _t249):
			v_v_372 = J.mc(J.G.get("N30W"), "graveVisit", [])
			if J.t(v_v_372):
				v_stay_363 = J.gp(v_v_372, "text")
				var _t250 = _s173["this"]
				var _t251 = J.gp(v_v_372, "k")
				J.sp(_t250, "_joinK", _t251)
	var _t252 = J.add(v_night_358, 1.0)
	J.sp(v_y_356, "night", _t252)
	var _t253 = (1.0 + floor(J.num((randf() * 2000000000.0))))
	J.sp(v_y_356, "seed", _t253)
	J.cl(J.G.get("save"), null, [])
	var _t254 = J.gp(J.gp(_s173["this"], "p"), "souls")
	var _t255 = J.mc(_t254, "map", [Callable(self, "_f95").bind(_s173)])
	v_rows_364 = J.mc(_t255, "join", [""])
	v_title_365 = (("一次就全對" if J.t(v_perfect_359) else "都安息了") if J.t(_s173["ok"]) else "天亮了")
	v_word_366 = (("陰司 KPI 系統：零投訴，五星好評。" if J.t(v_perfect_359) else "陰司 KPI 系統：有投訴，但最後都結案了。") if J.t(_s173["ok"]) else "陰司 KPI 系統：未結案。他們明晚還會在這裡等。")
	var _t256 = J.G.get("$")
	var _t257 = J.cl(_t256, null, ["#gy-end"])
	var _t258 = ("<div class=\"gy-card\"><h3>" + J.str(v_title_365) + "</h3><p class=\"desc\">" + J.str(v_word_366) + "</p><ul class=\"gy-who\">" + J.str(v_rows_364) + "</ul>" + (("<p class=\"desc gy-stay\">" + J.str(v_stay_363) + "</p>") if J.t(v_stay_363) else "") + "<p class=\"desc\">獎勵：" + J.str(v_got_362) + "</p><div class=\"gy-acts\"><button class=\"btn\" id=\"gy-back\">回村子</button><button class=\"btn gold\" id=\"gy-next\">下一夜</button></div></div>")
	J.sp(_t257, "innerHTML", _t258)
	var _t259 = J.G.get("$")
	var _t260 = J.gp(J.cl(_t259, null, ["#gy-end"]), "classList")
	J.mc(_t260, "add", ["on"])
	_s173["after"] = Callable(self, "_f96").bind(_s173)
	var _t265 = J.G.get("$")
	var _t266 = J.cl(_t265, null, ["#gy-back"])
	var _t267 = Callable(self, "_f97").bind(_s173)
	J.sp(_t266, "onclick", _t267)
	var _t268 = J.G.get("$")
	var _t269 = J.cl(_t268, null, ["#gy-next"])
	var _t270 = Callable(self, "_f98").bind(_s173)
	J.sp(_t269, "onclick", _t270)

func _f100(this_, a: Array, env):
	var v_s_384 = null; var v_g_385 = null
	v_s_384 = J.arg(a, 0)
	v_g_385 = (J.gp(J.gp(J.gp(env["this"], "p"), "graves"), J.gp(v_s_384, "place")) if (not J.leq(J.gp(v_s_384, "place"), null)) else null)
	var _t280 = ("sel" if J.seq(J.gp(env["this"], "sel"), J.gp(v_s_384, "i")) else "")
	var _t279 = J.seq(J.gp(J.gp(env["this"], "view"), "k"), "soul")
	return ("<button class=\"gy-chip " + _t280 + " " + ("on" if (J.seq(J.gp(J.gp(env["this"], "view"), "i"), J.gp(v_s_384, "i")) if _t279 else _t279) else "") + "\" data-i=\"" + J.str(J.gp(v_s_384, "i")) + "\" style=\"--c:" + J.str(J.gp(v_s_384, "col")) + "\"><b>" + J.str(J.gp(v_s_384, "tag")) + "</b><small>" + (J.add(J.gp(J.gp(v_g_385, "name"), 0.0), "家墳前") if J.t(v_g_385) else "還沒安置") + "</small></button>")

func _f102(this_, a: Array, env):
	var v_i_387 = null
	v_i_387 = J.num(J.gp(J.gp(env["b"], "dataset"), "i"))
	var _t287 = env["__p"]["this"]
	var _t288 = {"k": "soul", "i": v_i_387}
	J.sp(_t287, "view", _t288)
	var _t289 = env["__p"]["this"]
	J.sp(_t289, "guide", false)
	var _t290 = env["__p"]["this"]
	var _t291 = ((null if J.seq(J.gp(env["__p"]["this"], "sel"), v_i_387) else v_i_387) if J.seq(J.gp(env["__p"]["this"], "phase"), "play") else null)
	J.sp(_t290, "sel", _t291)
	J.mc(env["__p"]["this"], "renderPanel", [])

func _f101(this_, a: Array, env):
	var _s191 = {"__p": env, "b": null}
	_s191["b"] = J.arg(a, 0)
	var _t286 = _s191["b"]
	var _t292 = Callable(self, "_f102").bind(_s191)
	J.sp(_t286, "onclick", _t292)
	return _t292

func _f103(this_, a: Array, env):
	var v_r_388 = null
	v_r_388 = J.arg(a, 0)
	return ("<p><b>" + J.str(J.gp(v_r_388, 0.0)) + "</b>" + J.str(J.gp(v_r_388, 1.0)) + "</p>")

func _f104(this_, a: Array, env):
	var v_s_392 = null
	v_s_392 = J.arg(a, 0)
	return J.seq(J.gp(v_s_392, "place"), J.gp(env["v"], "i"))

func _f105(this_, a: Array, env):
	var v_l_395 = null
	v_l_395 = J.arg(a, 0)
	return ("<li>" + J.str(v_l_395) + "</li>")

func _f106(this_, a: Array, env):
	var v_s_396 = null
	v_s_396 = J.arg(a, 0)
	return J.leq(J.gp(v_s_396, "place"), null)

func _f99(this_, a: Array, env):
	var v_n_380 = null; var v_h_382 = null; var v_go_383 = null; var v_g_389 = null; var v_c_390 = null; var v_who_391 = null; var v_s_393 = null; var v_d_394 = null
	var _s189 = {"__p": env, "this": null, "v": null}
	_s189["this"] = this_
	var _t272 = (not J.t(J.gp(_s189["this"], "active")))
	if not J.t(_t272):
		var _t271 = J.G.get("$")
		_t272 = (not J.t(J.cl(_t271, null, ["#gy-panel"])))
	if _t272:
		return null
	v_n_380 = J.len(J.gp(_s189["this"], "souls"))
	var _t273 = J.G.get("$")
	var _t274 = J.cl(_t273, null, ["#gy-tries"])
	var _t275 = ("機會 " + J.str(J.mc("●", "repeat", [J.sub(2.0, J.gp(_s189["this"], "tries"))])) + J.str(J.mc("○", "repeat", [J.gp(_s189["this"], "tries")])))
	J.sp(_t274, "innerHTML", _t275)
	var _t276 = J.G.get("$")
	var _t277 = J.cl(_t276, null, ["#gy-chips"])
	var _t278 = J.gp(_s189["this"], "souls")
	var _t281 = J.mc(_t278, "map", [Callable(self, "_f100").bind(_s189)])
	var _t282 = J.mc(_t281, "join", [""])
	J.sp(_t277, "innerHTML", _t282)
	var _t283 = J.G.get("$")
	var _t284 = J.cl(_t283, null, ["#gy-chips"])
	var _t285 = J.mc(_t284, "querySelectorAll", [".gy-chip"])
	J.mc(_t285, "forEach", [Callable(self, "_f101").bind(_s189)])
	_s189["v"] = J.gp(_s189["this"], "view")
	v_h_382 = ""
	if J.seq(J.gp(_s189["v"], "k"), "rules"):
		var _t293 = J.mc(J.G.get("GY_RULES"), "map", [Callable(self, "_f103").bind(_s189)])
		var _t294 = ("<div class=\"gy-rules\">" + J.str(J.mc(_t293, "join", [""])) + "</div>")
		v_h_382 = _t294
	else:
		if J.seq(J.gp(_s189["v"], "k"), "grave"):
			v_g_389 = J.gp(J.gp(J.gp(_s189["this"], "p"), "graves"), J.gp(_s189["v"], "i"))
			v_c_390 = J.mc(J.G.get("GY_GEN"), "card", [v_g_389])
			var _t295 = J.gp(_s189["this"], "souls")
			v_who_391 = J.mc(_t295, "find", [Callable(self, "_f104").bind(_s189)])
			var _t296 = ("<div class=\"gy-grave\"><div class=\"gy-gh\"><b>" + J.str(J.gp(v_c_390, "name")) + "</b><span>" + J.str(J.gp(v_c_390, "years")) + "</span><em>" + J.str(J.gp(J.gp(J.G.get("GY_SPOTS"), J.gp(v_g_389, "spot")), "name")) + "</em></div>\n        <p><i>生前</i>" + J.str(J.gp(v_c_390, "job")) + "</p><p><i>碑文</i>" + J.str(J.gp(v_c_390, "ep")) + "</p><p><i>祭品</i>" + J.str(J.gp(v_c_390, "off")) + "</p>\n        <p class=\"gy-note\">" + (("<b style=\"color:" + J.str(J.gp(v_who_391, "col")) + "\">" + J.str(J.gp(v_who_391, "tag")) + "</b> 站在這座墳前。") if J.t(v_who_391) else ("" if (not J.leq(J.gp(_s189["this"], "sel"), null)) else "先點一個魂，再點這座墳，就能把他送過來。")) + "</p></div>")
			v_h_382 = _t296
		else:
			v_s_393 = J.gp(J.gp(_s189["this"], "souls"), J.gp(_s189["v"], "i"))
			v_d_394 = J.gp(J.gp(J.gp(_s189["this"], "p"), "souls"), J.gp(_s189["v"], "i"))
			var _t299 = J.gp(v_s_393, "col")
			var _t300 = J.gp(v_s_393, "tag")
			var _t301 = ("選好了：點一座墳，把他送過去" if J.seq(J.gp(_s189["this"], "sel"), J.gp(v_s_393, "i")) else "他記得的事")
			var _t297 = J.gp(v_d_394, "lines")
			var _t298 = J.mc(_t297, "map", [Callable(self, "_f105").bind(_s189)])
			var _t302 = ("<div class=\"gy-soul\"><div class=\"gy-sh\" style=\"--c:" + J.str(_t299) + "\"><b>" + J.str(_t300) + "</b><span>" + _t301 + "</span></div><ul>" + J.str(J.mc(_t298, "join", [""])) + "</ul></div>")
			v_h_382 = _t302
	var _t303 = J.G.get("$")
	var _t304 = J.cl(_t303, null, ["#gy-info"])
	J.sp(_t304, "innerHTML", v_h_382)
	var _t305 = J.G.get("$")
	v_go_383 = J.cl(_t305, null, ["#gy-go"])
	var _t306 = (not J.seq(J.gp(_s189["this"], "phase"), "play"))
	var _t307 = (_t306 if _t306 else (not J.t(J.mc(_s189["this"], "allPlaced", []))))
	J.sp(v_go_383, "disabled", _t307)
	var _t309 = null
	if J.t(J.mc(_s189["this"], "allPlaced", [])):
		_t309 = "送他們安息"
	else:
		var _t308 = J.gp(_s189["this"], "souls")
		_t309 = ("送他們安息（差 " + J.str(J.len(J.mc(_t308, "filter", [Callable(self, "_f106").bind(_s189)]))) + "）")
	J.sp(v_go_383, "textContent", _t309)
	var _t310 = J.G.get("$")
	var _t311 = J.cl(_t310, null, ["#gy-reset"])
	var _t312 = (not J.seq(J.gp(_s189["this"], "phase"), "play"))
	J.sp(_t311, "disabled", _t312)

func _f108(this_, a: Array, env):
	var v_n_402 = null
	v_n_402 = J.arg(a, 0)
	return J.mc(env["this"], "frame", [v_n_402, env["tok"]])

func _f109(this_, a: Array, env):
	var v_n_403 = null
	v_n_403 = J.arg(a, 0)
	return J.mc(env["this"], "frame", [v_n_403, env["tok"]])

func _f107(this_, a: Array, env):
	var v_now_399 = null; var v_dt_401 = null
	var _s200 = {"__p": env, "this": null, "tok": null}
	_s200["this"] = this_
	v_now_399 = J.arg(a, 0)
	_s200["tok"] = J.arg(a, 1)
	var _t313 = (not J.t(J.gp(_s200["this"], "active")))
	if (_t313 if _t313 else (not J.seq(_s200["tok"], J.gp(_s200["this"], "_tok")))):
		return null
	if (J.sub(v_now_399, J.gp(_s200["this"], "last")) < (J.div(1000.0, 30.0) - 2.0)):
		J.F_requestAnimationFrame([Callable(self, "_f108").bind(_s200)])
		return null
	v_dt_401 = J.min_([0.05, J.div(J.sub(v_now_399, J.gp(_s200["this"], "last")), 1000.0)])
	var _t314 = _s200["this"]
	J.sp(_t314, "last", v_now_399)
	J.mc(_s200["this"], "step", [v_dt_401])
	J.mc(_s200["this"], "draw", [J.gp(_s200["this"], "t")])
	J.F_requestAnimationFrame([Callable(self, "_f109").bind(_s200)])

func _f111(this_, a: Array, env):
	var v_c_412 = null
	v_c_412 = J.arg(a, 0)
	if J.cmp(J.gp(v_c_412, "delay"), 0.0, ">"):
		var _t341 = J.sub(J.gp(v_c_412, "delay"), env["dt"])
		J.sp(v_c_412, "delay", _t341)
		return true
	var _t342 = J.sub(J.gp(v_c_412, "life"), env["dt"])
	J.sp(v_c_412, "life", _t342)
	var _t343 = J.add(J.gp(v_c_412, "x"), J.mul(J.gp(v_c_412, "vx"), env["dt"]))
	J.sp(v_c_412, "x", _t343)
	var _t344 = J.add(J.gp(v_c_412, "y"), J.mul(J.gp(v_c_412, "vy"), env["dt"]))
	J.sp(v_c_412, "y", _t344)
	var _t345 = J.add(J.gp(v_c_412, "ph"), J.mul(env["dt"], 14.0))
	J.sp(v_c_412, "ph", _t345)
	var _t346 = J.cmp(J.gp(v_c_412, "life"), 0.0, ">")
	return (J.cmp(J.gp(v_c_412, "x"), 1.2, "<") if _t346 else _t346)

func _f112(this_, a: Array, env):
	var v_p_413 = null
	v_p_413 = J.arg(a, 0)
	var _t350 = J.sub(J.gp(v_p_413, "life"), env["dt"])
	J.sp(v_p_413, "life", _t350)
	var _t351 = J.add(J.gp(v_p_413, "x"), J.mul(J.gp(v_p_413, "vx"), env["dt"]))
	J.sp(v_p_413, "x", _t351)
	var _t352 = J.add(J.gp(v_p_413, "y"), J.mul(J.gp(v_p_413, "vy"), env["dt"]))
	J.sp(v_p_413, "y", _t352)
	return J.cmp(J.gp(v_p_413, "life"), 0.0, ">")

func _f110(this_, a: Array, env):
	var v_s_407 = null; var v_tx_408 = null; var v_ty_409 = null; var v_k_410 = null; var v_w_411 = null; var v_s_414 = null
	var _s204 = {"__p": env, "dt": null}
	_s204["dt"] = J.arg(a, 0)
	var _t315 = this_
	var _t316 = J.add(J.gp(_t315, "t"), _s204["dt"])
	J.sp(_t315, "t", _t316)
	if J.seq(J.gp(this_, "phase"), "rest"):
		var _t317 = this_
		var _t318 = J.add(J.gp(_t317, "restT"), _s204["dt"])
		J.sp(_t317, "restT", _t318)
	for _t319 in J.iter(J.gp(this_, "souls")):
		v_s_407 = _t319
		if J.t(J.gp(v_s_407, "rx")):
			var _t320 = J.gp(v_s_407, "rx")
			var _t321 = J.add(J.gp(_t320, "t"), _s204["dt"])
			J.sp(_t320, "t", _t321)
			if J.cmp(J.gp(J.gp(v_s_407, "rx"), "t"), J.gp(J.gp(v_s_407, "rx"), "dur"), ">="):
				J.sp(v_s_407, "rx", null)
		var _t322 = J.mc(this_, "targetOf", [v_s_407])
		var _t323 = J.gp(_t322, 0.0)
		v_tx_408 = _t323
		var _t324 = J.gp(_t322, 1.0)
		v_ty_409 = _t324
		var _t325 = J.seq(J.gp(v_s_407, "x"), 0.0)
		if (J.seq(J.gp(v_s_407, "y"), 0.0) if _t325 else _t325):
			J.sp(v_s_407, "x", v_tx_408)
			J.sp(v_s_407, "y", v_ty_409)
		v_k_410 = J.min_([1.0, J.mul(_s204["dt"], 6.0)])
		var _t326 = J.add(J.gp(v_s_407, "x"), J.mul(J.sub(v_tx_408, J.gp(v_s_407, "x")), v_k_410))
		J.sp(v_s_407, "x", _t326)
		var _t327 = J.add(J.gp(v_s_407, "y"), J.mul(J.sub(v_ty_409, J.gp(v_s_407, "y")), v_k_410))
		J.sp(v_s_407, "y", _t327)
	for _t328 in J.iter(J.gp(this_, "wisps")):
		v_w_411 = _t328
		var _t329 = J.add(J.gp(v_w_411, "ph"), J.mul(_s204["dt"], J.gp(v_w_411, "sp")))
		J.sp(v_w_411, "ph", _t329)
		var _t330 = J.add(J.gp(v_w_411, "x"), (J.mul(sin(J.num(J.mul(J.gp(v_w_411, "ph"), 0.7))), _s204["dt"]) * 0.02))
		J.sp(v_w_411, "x", _t330)
		var _t331 = J.add(J.gp(v_w_411, "y"), (J.mul(cos(J.num(J.mul(J.gp(v_w_411, "ph"), 0.5))), _s204["dt"]) * 0.012))
		J.sp(v_w_411, "y", _t331)
		if J.cmp(J.gp(v_w_411, "x"), (-0.05), "<"):
			J.sp(v_w_411, "x", 1.05)
		if J.cmp(J.gp(v_w_411, "x"), 1.05, ">"):
			var _t332 = (-0.05)
			J.sp(v_w_411, "x", _t332)
	var _t333 = this_
	var _t334 = J.sub(J.gp(_t333, "crowT"), _s204["dt"])
	J.sp(_t333, "crowT", _t334)
	var _t335 = J.cmp(J.gp(this_, "crowT"), 0.0, "<=")
	if (J.seq(J.gp(this_, "phase"), "play") if _t335 else _t335):
		var _t336 = this_
		var _t337 = (8.0 + (randf() * 8.0))
		J.sp(_t336, "crowT", _t337)
		var _t338 = J.gp(this_, "crows")
		J.mc(_t338, "push", [{"x": (-0.05), "y": (0.08 + (randf() * 0.1)), "vx": 0.13, "vy": (-0.01), "ph": 0.0, "s": 0.8, "delay": 0.0, "life": 9.0}])
	var _t339 = this_
	var _t340 = J.gp(this_, "crows")
	var _t347 = J.mc(_t340, "filter", [Callable(self, "_f111").bind(_s204)])
	J.sp(_t339, "crows", _t347)
	var _t348 = this_
	var _t349 = J.gp(this_, "parts")
	var _t353 = J.mc(_t349, "filter", [Callable(self, "_f112").bind(_s204)])
	J.sp(_t348, "parts", _t353)
	var _t354 = J.seq(J.gp(this_, "phase"), "rest")
	if ((randf() < J.mul(_s204["dt"], 40.0)) if _t354 else _t354):
		v_s_414 = J.gp(J.gp(this_, "souls"), floor(J.num((randf() * J.len(J.gp(this_, "souls"))))))
		var _t355 = J.gp(this_, "parts")
		J.mc(_t355, "push", [{"x": J.add(J.gp(v_s_414, "x"), ((randf() - 0.5) * 0.08)), "y": (J.sub(J.gp(v_s_414, "y"), 0.05) - J.mul(J.gp(this_, "restT"), 0.07)), "vx": ((randf() - 0.5) * 0.03), "vy": ((-0.08) - (randf() * 0.06)), "life": 1.4, "col": J.gp(v_s_414, "col")}])
	if J.t(J.gp(this_, "bub")):
		var _t356 = J.gp(this_, "bub")
		var _t357 = J.sub(J.gp(_t356, "life"), _s204["dt"])
		J.sp(_t356, "life", _t357)
		if J.cmp(J.gp(J.gp(this_, "bub"), "life"), 0.0, "<="):
			var _t358 = this_
			J.sp(_t358, "bub", null)

func _f114(this_, a: Array, env):
	var v_g_442 = null; var v_gi_443 = null
	v_g_442 = J.arg(a, 0)
	v_gi_443 = J.arg(a, 1)
	return J.mc(env["this"], "drawStone", [env["ctx"], v_g_442, v_gi_443, env["t"]])

func _f115(this_, a: Array, env):
	var v_g_444 = null; var v_gi_445 = null; var v_r_446 = null; var v_al_447 = null
	v_g_444 = J.arg(a, 0)
	v_gi_445 = J.arg(a, 1)
	v_r_446 = J.mc(env["this"], "stoneRect", [v_gi_445])
	v_al_447 = (0.75 + (0.25 * sin(J.num(J.mul(env["t"], 4.0)))))
	var _t392 = env["ctx"]
	var _t393 = ("rgba(160,255,200," + J.str(J.mul(0.1, v_al_447)) + ")")
	J.sp(_t392, "fillStyle", _t393)
	var _t394 = env["ctx"]
	var _t395 = ("rgba(200,255,225," + J.str(v_al_447) + ")")
	J.sp(_t394, "strokeStyle", _t395)
	var _t396 = env["ctx"]
	J.sp(_t396, "lineWidth", 3.0)
	J.mc(env["ctx"], "setLineDash", [[7.0, 5.0]])
	J.mc(env["ctx"], "beginPath", [])
	J.mc(env["ctx"], "ellipse", [J.gp(v_r_446, "cx"), J.sub(J.gp(v_r_446, "by"), J.mul(4.0, env["u"])), J.mul(54.0, env["u"]), J.mul(22.0, env["u"]), 0.0, 0.0, (PI * 2.0)])
	J.mc(env["ctx"], "fill", [])
	J.mc(env["ctx"], "stroke", [])
	J.mc(env["ctx"], "setLineDash", [[]])

func _f116(this_, a: Array, env):
	var v_a_454 = null; var v_c2_455 = null
	v_a_454 = J.arg(a, 0)
	v_c2_455 = J.arg(a, 1)
	return J.sub(J.gp(v_a_454, "y"), J.gp(v_c2_455, "y"))

func _f113(this_, a: Array, env):
	var v_c_418 = null; var v_W_420 = null; var v_H_421 = null; var v_b_422 = null; var v_img_423 = null; var v_restK_425 = null; var v_order_426 = null; var v_vg_427 = null; var v_g_428 = null; var v_k_429 = null; var v_x_430 = null; var v_y_431 = null; var v_lx_432 = null; var v_ly_433 = null; var v_r_434 = null; var v_g_435 = null; var v_k_436 = null; var v_sp_437 = null; var v_x_438 = null; var v_y_439 = null; var v_lab_440 = null; var v_w_441 = null; var v_ax_448 = null; var v_ay_449 = null; var v_s_450 = null; var v_lx_451 = null; var v_ly_452 = null; var v_g_453 = null; var v_s_456 = null; var v_p_457 = null; var v_x_458 = null; var v_y_459 = null; var v_w_460 = null; var v_x_461 = null; var v_y_462 = null; var v_a_463 = null; var v_r_464 = null; var v_g_465 = null; var v_cw_466 = null; var v_x_467 = null; var v_y_468 = null
	var _s217 = {"__p": env, "this": null, "t": null, "ctx": null, "u": null}
	_s217["this"] = this_
	_s217["t"] = J.arg(a, 0)
	var _t359 = J.G.get("$")
	v_c_418 = J.cl(_t359, null, ["#gy-cvs"])
	if (not J.t(v_c_418)):
		return null
	_s217["ctx"] = J.mc(v_c_418, "getContext", ["2d"])
	J.mc(_s217["ctx"], "setTransform", [J.gp(_s217["this"], "dpr"), 0.0, 0.0, J.gp(_s217["this"], "dpr"), 0.0, 0.0])
	v_W_420 = J.gp(_s217["this"], "W")
	v_H_421 = J.gp(_s217["this"], "H")
	v_b_422 = J.mc(_s217["this"], "bgScale", [])
	v_img_423 = J.gp(J.G.get("SPR"), "bg_graveyard")
	_s217["u"] = J.mc(_s217["this"], "unit", [])
	var _t360 = _s217["ctx"]
	J.sp(_t360, "fillStyle", "#0d0b10")
	J.mc(_s217["ctx"], "fillRect", [0.0, 0.0, v_W_420, v_H_421])
	var _t362 = v_img_423
	if J.t(_t362):
		var _t361 = J.G.get("sprOk")
		_t362 = J.cl(_t361, null, ["bg_graveyard"])
	if J.t(_t362):
		J.mc(_s217["ctx"], "drawImage", [v_img_423, J.gp(v_b_422, "ox"), J.gp(v_b_422, "oy"), J.mul(J.gp(v_b_422, "iw"), J.gp(v_b_422, "s")), J.mul(J.gp(v_b_422, "ih"), J.gp(v_b_422, "s"))])
	else:
		v_g_428 = J.mc(_s217["ctx"], "createLinearGradient", [0.0, 0.0, 0.0, v_H_421])
		J.mc(v_g_428, "addColorStop", [0.0, "#1c2030"])
		J.mc(v_g_428, "addColorStop", [1.0, "#2a2a22"])
		var _t363 = _s217["ctx"]
		J.sp(_t363, "fillStyle", v_g_428)
		J.mc(_s217["ctx"], "fillRect", [0.0, 0.0, v_W_420, v_H_421])
		for _t364 in J.keys(J.G.get("GY_SPOTS")):
			v_k_429 = _t364
			var _t365 = J.mc(_s217["this"], "pt", [J.gp(J.gp(J.G.get("GY_SPOTS"), v_k_429), "x"), J.gp(J.gp(J.G.get("GY_SPOTS"), v_k_429), "y")])
			var _t366 = J.gp(_t365, 0.0)
			v_x_430 = _t366
			var _t367 = J.gp(_t365, 1.0)
			v_y_431 = _t367
			var _t368 = _s217["ctx"]
			J.sp(_t368, "fillStyle", "#6a5038")
			J.mc(_s217["ctx"], "beginPath", [])
			J.mc(_s217["ctx"], "ellipse", [v_x_430, v_y_431, J.mul(62.0, _s217["u"]), J.mul(30.0, _s217["u"]), 0.0, 0.0, (PI * 2.0)])
			J.mc(_s217["ctx"], "fill", [])
	var _t369 = _s217["ctx"]
	J.sp(_t369, "fillStyle", "rgba(10,12,34,.18)")
	J.mc(_s217["ctx"], "fillRect", [0.0, 0.0, v_W_420, v_H_421])
	var _t370 = J.mc(_s217["this"], "pt", [0.25, 0.29])
	var _t371 = J.gp(_t370, 0.0)
	v_lx_432 = _t371
	var _t372 = J.gp(_t370, 1.0)
	v_ly_433 = _t372
	v_r_434 = (J.mul(60.0, _s217["u"]) * (1.0 + (0.06 * sin(J.num(J.mul(_s217["t"], 2.3))))))
	v_g_435 = J.mc(_s217["ctx"], "createRadialGradient", [v_lx_432, v_ly_433, 2.0, v_lx_432, v_ly_433, v_r_434])
	J.mc(v_g_435, "addColorStop", [0.0, "rgba(255,170,90,.32)"])
	J.mc(v_g_435, "addColorStop", [1.0, "rgba(255,140,60,0)"])
	var _t373 = _s217["ctx"]
	J.sp(_t373, "globalCompositeOperation", "lighter")
	var _t374 = _s217["ctx"]
	J.sp(_t374, "fillStyle", v_g_435)
	J.mc(_s217["ctx"], "fillRect", [J.sub(v_lx_432, v_r_434), J.sub(v_ly_433, v_r_434), J.mul(v_r_434, 2.0), J.mul(v_r_434, 2.0)])
	var _t375 = _s217["ctx"]
	J.sp(_t375, "globalCompositeOperation", "source-over")
	J.mc(_s217["this"], "fog", [_s217["ctx"], _s217["t"], 0.0])
	if J.t(J.gp(_s217["this"], "guide")):
		for _t376 in J.keys(J.G.get("GY_SPOTS")):
			v_k_436 = _t376
			v_sp_437 = J.gp(J.G.get("GY_SPOTS"), v_k_436)
			var _t377 = J.mc(_s217["this"], "pt", [J.gp(v_sp_437, "x"), J.gp(v_sp_437, "y")])
			var _t378 = J.gp(_t377, 0.0)
			v_x_438 = _t378
			var _t379 = J.gp(_t377, 1.0)
			v_y_439 = _t379
			var _t380 = J.gp(J.G.get("GY_ROWW"), J.gp(v_sp_437, "row"))
			var _t381 = [J.mc(_t380, "replace", ["那座", ""]), ("" if J.seq(J.gp(v_sp_437, "side"), 1.0) else J.gp(J.G.get("GY_SIDEW"), J.gp(v_sp_437, "side")))]
			var _t382 = J.mc(_t381, "filter", [J.G.get("Boolean")])
			v_lab_440 = J.add(J.mc(_t382, "join", ["・"]), ("・牌坊旁" if J.seq(v_k_436, "D") else ""))
			var _t383 = _s217["ctx"]
			var _t384 = ("800 " + J.str(J.round(J.num(J.mul(13.0, _s217["u"])))) + "px sans-serif")
			J.sp(_t383, "font", _t384)
			var _t385 = _s217["ctx"]
			J.sp(_t385, "textAlign", "center")
			v_w_441 = J.add(J.gp(J.mc(_s217["ctx"], "measureText", [v_lab_440]), "width"), 12.0)
			var _t386 = _s217["ctx"]
			J.sp(_t386, "fillStyle", "rgba(20,14,30,.82)")
			J.mc(_s217["ctx"], "beginPath", [])
			J.mc(_s217["ctx"], "roundRect", [J.sub(v_x_438, J.div(v_w_441, 2.0)), J.add(v_y_439, J.mul(14.0, _s217["u"])), v_w_441, J.mul(20.0, _s217["u"]), 6.0])
			J.mc(_s217["ctx"], "fill", [])
			var _t387 = _s217["ctx"]
			J.sp(_t387, "fillStyle", "#ffe9a8")
			J.mc(_s217["ctx"], "fillText", [v_lab_440, v_x_438, J.add(v_y_439, J.mul(29.0, _s217["u"]))])
	v_restK_425 = (J.min_([1.0, J.div(J.gp(_s217["this"], "restT"), 2.6)]) if J.cmp(J.gp(_s217["this"], "restT"), 0.0, ">") else 0.0)
	var _t388 = J.gp(J.gp(_s217["this"], "p"), "graves")
	J.mc(_t388, "forEach", [Callable(self, "_f114").bind(_s217)])
	var _t390 = (not J.leq(J.gp(_s217["this"], "sel"), null))
	if not J.t(_t390):
		var _t389 = J.gp(_s217["this"], "drag")
		_t390 = (J.gp(J.gp(_s217["this"], "drag"), "moved") if J.t(_t389) else _t389)
	if J.t(_t390):
		var _t391 = J.gp(J.gp(_s217["this"], "p"), "graves")
		J.mc(_t391, "forEach", [Callable(self, "_f115").bind(_s217)])
	var _t397 = J.mc(_s217["this"], "pt", [0.12, 0.965])
	var _t398 = J.gp(_t397, 0.0)
	v_ax_448 = _t398
	var _t399 = J.gp(_t397, 1.0)
	v_ay_449 = _t399
	v_s_450 = J.mul(1.2, _s217["u"])
	if (not J.seq(J.typeof_(J.G.get("ART")), "undefined")):
		J.mc(J.G.get("ART"), "drawChar", [_s217["ctx"], "afu", v_ax_448, v_ay_449, v_s_450, {"t": _s217["t"], "pose": "idle", "shadow": false}])
	v_lx_451 = J.add(v_ax_448, J.mul(30.0, _s217["u"]))
	v_ly_452 = (J.sub(v_ay_449, J.mul(46.0, _s217["u"])) + J.mul((sin(J.num(J.mul(_s217["t"], 1.8))) * 1.5), _s217["u"]))
	v_g_453 = J.mc(_s217["ctx"], "createRadialGradient", [v_lx_451, J.add(v_ly_452, J.mul(6.0, _s217["u"])), 1.0, v_lx_451, J.add(v_ly_452, J.mul(6.0, _s217["u"])), J.mul(46.0, _s217["u"])])
	J.mc(v_g_453, "addColorStop", [0.0, "rgba(255,190,110,.42)"])
	J.mc(v_g_453, "addColorStop", [1.0, "rgba(255,160,80,0)"])
	var _t400 = _s217["ctx"]
	J.sp(_t400, "globalCompositeOperation", "lighter")
	var _t401 = _s217["ctx"]
	J.sp(_t401, "fillStyle", v_g_453)
	J.mc(_s217["ctx"], "fillRect", [J.sub(v_lx_451, J.mul(46.0, _s217["u"])), J.sub(v_ly_452, J.mul(40.0, _s217["u"])), J.mul(92.0, _s217["u"]), J.mul(92.0, _s217["u"])])
	var _t402 = _s217["ctx"]
	J.sp(_t402, "globalCompositeOperation", "source-over")
	var _t403 = _s217["ctx"]
	J.sp(_t403, "strokeStyle", "#3a2a1a")
	var _t404 = _s217["ctx"]
	var _t405 = J.mul(2.0, _s217["u"])
	J.sp(_t404, "lineWidth", _t405)
	J.mc(_s217["ctx"], "beginPath", [])
	J.mc(_s217["ctx"], "moveTo", [J.add(v_ax_448, J.mul(14.0, _s217["u"])), J.sub(v_ay_449, J.mul(36.0, _s217["u"]))])
	J.mc(_s217["ctx"], "lineTo", [v_lx_451, J.sub(v_ly_452, J.mul(12.0, _s217["u"]))])
	J.mc(_s217["ctx"], "stroke", [])
	J.mc(_s217["ctx"], "save", [])
	J.mc(_s217["ctx"], "translate", [v_lx_451, v_ly_452])
	J.mc(_s217["ctx"], "scale", [J.mul(1.6, _s217["u"]), J.mul(1.6, _s217["u"])])
	if J.t(J.gp(J.G.get("ART"), "lantern")):
		J.mc(J.G.get("ART"), "lantern", [_s217["ctx"], 0.0, 0.0, _s217["t"], "#e0a040"])
	J.mc(_s217["ctx"], "restore", [])
	if J.t(J.gp(_s217["this"], "bub")):
		J.mc(_s217["this"], "bubble", [_s217["ctx"], J.gp(J.gp(_s217["this"], "bub"), "text"), J.add(v_ax_448, J.mul(10.0, _s217["u"])), J.sub(v_ay_449, J.mul(80.0, _s217["u"])), J.min_([1.0, J.mul(J.gp(J.gp(_s217["this"], "bub"), "life"), 2.0)])])
	var _t406 = J.mc(J.gp(_s217["this"], "souls"), "slice", [])
	v_order_426 = J.mc(_t406, "sort", [Callable(self, "_f116").bind(_s217)])
	for _t407 in J.iter(v_order_426):
		v_s_456 = _t407
		J.mc(_s217["this"], "drawSoul", [_s217["ctx"], v_s_456, _s217["t"], v_restK_425])
	for _t408 in J.iter(J.gp(_s217["this"], "parts")):
		v_p_457 = _t408
		var _t409 = J.mc(_s217["this"], "pt", [J.gp(v_p_457, "x"), J.gp(v_p_457, "y")])
		var _t410 = J.gp(_t409, 0.0)
		v_x_458 = _t410
		var _t411 = J.gp(_t409, 1.0)
		v_y_459 = _t411
		var _t412 = _s217["ctx"]
		var _t413 = J.min_([1.0, J.gp(v_p_457, "life")])
		J.sp(_t412, "globalAlpha", _t413)
		var _t414 = _s217["ctx"]
		var _t415 = J.gp(v_p_457, "col")
		var _t416 = (_t415 if J.t(_t415) else "#fff")
		J.sp(_t414, "fillStyle", _t416)
		J.mc(_s217["ctx"], "beginPath", [])
		J.mc(_s217["ctx"], "arc", [v_x_458, v_y_459, J.mul(2.4, _s217["u"]), 0.0, (PI * 2.0)])
		J.mc(_s217["ctx"], "fill", [])
		var _t417 = _s217["ctx"]
		J.sp(_t417, "globalAlpha", 1.0)
	for _t418 in J.iter(J.gp(_s217["this"], "wisps")):
		v_w_460 = _t418
		var _t419 = J.mc(_s217["this"], "pt", [J.gp(v_w_460, "x"), J.add(J.gp(v_w_460, "y"), (sin(J.num(J.mul(J.gp(v_w_460, "ph"), 2.0))) * 0.01))])
		var _t420 = J.gp(_t419, 0.0)
		v_x_461 = _t420
		var _t421 = J.gp(_t419, 1.0)
		v_y_462 = _t421
		v_a_463 = (0.45 + (0.35 * sin(J.num(J.mul(J.gp(v_w_460, "ph"), 3.0)))))
		v_r_464 = J.mul(14.0, _s217["u"])
		v_g_465 = J.mc(_s217["ctx"], "createRadialGradient", [v_x_461, v_y_462, 0.0, v_x_461, v_y_462, v_r_464])
		J.mc(v_g_465, "addColorStop", [0.0, ("rgba(170,255,240," + J.str(v_a_463) + ")")])
		J.mc(v_g_465, "addColorStop", [0.35, ("rgba(90,220,210," + J.str(J.mul(v_a_463, 0.45)) + ")")])
		J.mc(v_g_465, "addColorStop", [1.0, "rgba(60,200,200,0)"])
		var _t422 = _s217["ctx"]
		J.sp(_t422, "globalCompositeOperation", "lighter")
		var _t423 = _s217["ctx"]
		J.sp(_t423, "fillStyle", v_g_465)
		J.mc(_s217["ctx"], "beginPath", [])
		J.mc(_s217["ctx"], "arc", [v_x_461, v_y_462, v_r_464, 0.0, (PI * 2.0)])
		J.mc(_s217["ctx"], "fill", [])
		var _t424 = _s217["ctx"]
		J.sp(_t424, "globalCompositeOperation", "source-over")
	for _t425 in J.iter(J.gp(_s217["this"], "crows")):
		v_cw_466 = _t425
		if J.cmp(J.gp(v_cw_466, "delay"), 0.0, ">"):
			continue
		var _t426 = J.mc(_s217["this"], "pt", [J.gp(v_cw_466, "x"), J.gp(v_cw_466, "y")])
		var _t427 = J.gp(_t426, 0.0)
		v_x_467 = _t427
		var _t428 = J.gp(_t426, 1.0)
		v_y_468 = _t428
		var _t429 = _s217["ctx"]
		var _t430 = J.min_([1.0, J.gp(v_cw_466, "life")])
		J.sp(_t429, "globalAlpha", _t430)
		if J.t(J.gp(J.G.get("ART"), "drawCrow")):
			J.mc(J.G.get("ART"), "drawCrow", [_s217["ctx"], v_x_467, v_y_468, J.mul(J.mul(J.gp(v_cw_466, "s"), 1.4), _s217["u"]), J.gp(v_cw_466, "ph"), 1.0, false])
		var _t431 = _s217["ctx"]
		J.sp(_t431, "globalAlpha", 1.0)
	J.mc(_s217["this"], "fog", [_s217["ctx"], _s217["t"], 1.0])
	if J.cmp(v_restK_425, 0.0, ">"):
		var _t432 = _s217["ctx"]
		var _t433 = ("rgba(255,240,200," + J.str((0.12 * sin(J.num(J.mul(v_restK_425, PI))))) + ")")
		J.sp(_t432, "fillStyle", _t433)
		J.mc(_s217["ctx"], "fillRect", [0.0, 0.0, v_W_420, v_H_421])
	v_vg_427 = J.mc(_s217["ctx"], "createRadialGradient", [J.div(v_W_420, 2.0), J.mul(v_H_421, 0.55), J.mul(v_H_421, 0.3), J.div(v_W_420, 2.0), J.mul(v_H_421, 0.55), J.mul(v_H_421, 0.85)])
	J.mc(v_vg_427, "addColorStop", [0.0, "rgba(0,0,0,0)"])
	J.mc(v_vg_427, "addColorStop", [1.0, "rgba(0,0,0,.5)"])
	var _t434 = _s217["ctx"]
	J.sp(_t434, "fillStyle", v_vg_427)
	J.mc(_s217["ctx"], "fillRect", [0.0, 0.0, v_W_420, v_H_421])

func _f117(this_, a: Array, env):
	var v_ctx_471 = null; var v_t_472 = null; var v_front_473 = null; var v_W_474 = null; var v_u_475 = null; var v_i_476 = null; var v_fy_477 = null; var v_sp_478 = null; var v_fx_479 = null; var v_x_480 = null; var v_y_481 = null; var v_rx_482 = null; var v_ry_483 = null; var v_a_484 = null; var v_g_485 = null
	v_ctx_471 = J.arg(a, 0)
	v_t_472 = J.arg(a, 1)
	v_front_473 = J.arg(a, 2)
	v_W_474 = J.gp(this_, "W")
	v_u_475 = J.mc(this_, "unit", [])
	v_i_476 = 0.0
	while true:
		if not J.cmp(v_i_476, 4.0, "<"): break
		v_fy_477 = ((0.86 + J.mul(v_i_476, 0.03)) if J.t(v_front_473) else (0.5 + J.mul(v_i_476, 0.09)))
		v_sp_478 = ((0.012 if J.t(v_front_473) else 0.008) * (1.0 if J.t(J.mod(v_i_476, 2.0)) else (-1.0)))
		v_fx_479 = (J.mod((J.mod((J.mul(v_i_476, 0.37) + J.mul(v_t_472, v_sp_478)), 1.4) + 1.4), 1.4) - 0.2)
		var _t435 = J.mc(this_, "pt", [v_fx_479, v_fy_477])
		var _t436 = J.gp(_t435, 0.0)
		v_x_480 = _t436
		var _t437 = J.gp(_t435, 1.0)
		v_y_481 = _t437
		v_rx_482 = J.mul(v_W_474, 0.55)
		v_ry_483 = J.mul(34.0, v_u_475)
		v_a_484 = (0.1 if J.t(v_front_473) else 0.09)
		J.mc(v_ctx_471, "save", [])
		J.mc(v_ctx_471, "translate", [v_x_480, v_y_481])
		J.mc(v_ctx_471, "scale", [1.0, J.div(v_ry_483, v_rx_482)])
		v_g_485 = J.mc(v_ctx_471, "createRadialGradient", [0.0, 0.0, 0.0, 0.0, 0.0, v_rx_482])
		J.mc(v_g_485, "addColorStop", [0.0, ("rgba(200,210,230," + J.str(v_a_484) + ")")])
		J.mc(v_g_485, "addColorStop", [1.0, "rgba(200,210,230,0)"])
		J.sp(v_ctx_471, "fillStyle", v_g_485)
		J.mc(v_ctx_471, "beginPath", [])
		J.mc(v_ctx_471, "arc", [0.0, 0.0, v_rx_482, 0.0, (PI * 2.0)])
		J.mc(v_ctx_471, "fill", [])
		J.mc(v_ctx_471, "restore", [])
		v_i_476 = J.num(v_i_476) + 1.0

func _f119(this_, a: Array, env):
	J.mc(env["__p"]["ctx"], "beginPath", [])
	J.mc(env["__p"]["ctx"], "moveTo", [env["x"], J.sub(J.gp(env["__p"]["r"], "by"), J.mul(6.0, env["__p"]["u"]))])
	J.mc(env["__p"]["ctx"], "lineTo", [env["x"], J.add(env["y"], env["rr"])])
	J.mc(env["__p"]["ctx"], "arc", [J.add(env["x"], env["rr"]), J.add(env["y"], env["rr"]), env["rr"], PI, 0.0])
	J.mc(env["__p"]["ctx"], "lineTo", [J.add(env["x"], env["w"]), J.sub(J.gp(env["__p"]["r"], "by"), J.mul(6.0, env["__p"]["u"]))])
	J.mc(env["__p"]["ctx"], "closePath", [])

func _f120(this_, a: Array, env):
	var v_ch_519 = null; var v_k_520 = null; var v_yy_521 = null
	v_ch_519 = J.arg(a, 0)
	v_k_520 = J.arg(a, 1)
	v_yy_521 = J.add(env["y1"], (J.mul(v_k_520, env["fs"]) * 1.04))
	var _t461 = env["__p"]["ctx"]
	J.sp(_t461, "fillStyle", "rgba(255,255,255,.3)")
	J.mc(env["__p"]["ctx"], "fillText", [v_ch_519, J.add(J.gp(env["__p"]["tab"], "cx"), 0.7), J.add(v_yy_521, 0.7)])
	var _t462 = env["__p"]["ctx"]
	J.sp(_t462, "fillStyle", "#8a1e16")
	J.mc(env["__p"]["ctx"], "fillText", [v_ch_519, J.gp(env["__p"]["tab"], "cx"), v_yy_521])

func _f121(this_, a: Array, env):
	var v_ch_523 = null; var v_k_524 = null; var v_yy_525 = null
	v_ch_523 = J.arg(a, 0)
	v_k_524 = J.arg(a, 1)
	v_yy_525 = J.add(J.add(J.gp(env["__p"]["r"], "y"), J.mul(20.0, env["__p"]["u"])), J.mul(v_k_524, J.add(env["fs"], 1.0)))
	var _t468 = env["__p"]["ctx"]
	J.sp(_t468, "fillStyle", "rgba(255,255,255,.25)")
	J.mc(env["__p"]["ctx"], "fillText", [v_ch_523, J.add(J.gp(env["__p"]["r"], "cx"), 0.8), J.add(v_yy_525, 0.8)])
	var _t469 = env["__p"]["ctx"]
	J.sp(_t469, "fillStyle", "#1e1c22")
	J.mc(env["__p"]["ctx"], "fillText", [v_ch_523, J.gp(env["__p"]["r"], "cx"), v_yy_525])

func _f118(this_, a: Array, env):
	var v_g_489 = null; var v_gi_490 = null; var v_t_491 = null; var v_view_494 = null; var v_tk_495 = null; var v_im_497 = null; var v_w_498 = null; var v_h_499 = null; var v_x0_500 = null; var v_y0_501 = null; var v_T_502 = null; var v_h_506 = null; var v_path_508 = null; var v_gr_509 = null; var v_a_510 = null; var v_b2_511 = null; var v_ang_512 = null; var v_k_513 = null; var v_sx_514 = null; var v_sy_515 = null; var v_chs_516 = null; var v_k_526 = null; var v_hx_527 = null; var v_hy_528 = null; var v_fs_529 = null; var v_txt_530 = null; var v_tw_531 = null; var v_th_532 = null; var v_ty_533 = null
	var _s239 = {"__p": env, "ctx": null, "r": null, "u": null, "tab": null}
	_s239["ctx"] = J.arg(a, 0)
	v_g_489 = J.arg(a, 1)
	v_gi_490 = J.arg(a, 2)
	v_t_491 = J.arg(a, 3)
	_s239["r"] = J.mc(this_, "stoneRect", [v_gi_490])
	_s239["u"] = J.mc(this_, "unit", [])
	var _t438 = J.seq(J.gp(J.gp(this_, "view"), "k"), "grave")
	v_view_494 = (J.seq(J.gp(J.gp(this_, "view"), "i"), v_gi_490) if _t438 else _t438)
	J.mc(_s239["ctx"], "save", [])
	var _t439 = _s239["ctx"]
	J.sp(_t439, "fillStyle", "rgba(0,0,0,.35)")
	J.mc(_s239["ctx"], "beginPath", [])
	J.mc(_s239["ctx"], "ellipse", [J.gp(_s239["r"], "cx"), J.gp(_s239["r"], "by"), J.mul(J.gp(_s239["r"], "w"), 0.62), J.mul(7.0, _s239["u"]), 0.0, 0.0, (PI * 2.0)])
	J.mc(_s239["ctx"], "fill", [])
	v_tk_495 = J.add("tomb", (J.mod(v_gi_490, 4.0) + 1.0))
	_s239["tab"] = null
	var _t440 = J.G.get("sprOk")
	if J.t(J.cl(_t440, null, [v_tk_495])):
		v_im_497 = J.gp(J.G.get("SPR"), v_tk_495)
		v_w_498 = J.mul(J.gp(_s239["r"], "w"), 2.25)
		v_h_499 = J.div(J.mul(v_w_498, J.gp(v_im_497, "naturalHeight")), J.gp(v_im_497, "naturalWidth"))
		v_x0_500 = J.sub(J.gp(_s239["r"], "cx"), J.div(v_w_498, 2.0))
		v_y0_501 = J.sub(J.add(J.gp(_s239["r"], "by"), J.mul(4.0, _s239["u"])), v_h_499)
		v_T_502 = J.gp(J.G.get("GY_TOMB_TAB"), J.mod(v_gi_490, 4.0))
		J.mc(_s239["ctx"], "drawImage", [v_im_497, v_x0_500, v_y0_501, v_w_498, v_h_499])
		var _t441 = {"cx": J.add(v_x0_500, J.mul(J.gp(v_T_502, 0.0), v_w_498)), "top": J.add(v_y0_501, J.mul(J.gp(v_T_502, 1.0), v_h_499)), "bot": J.add(v_y0_501, J.mul(J.gp(v_T_502, 2.0), v_h_499)), "w": J.mul(J.sub(J.gp(v_T_502, 4.0), J.gp(v_T_502, 3.0)), v_w_498)}
		_s239["tab"] = _t441
	else:
		var _s241 = {"__p": _s239, "x": null, "y": null, "w": null, "rr": null}
		_s241["x"] = J.gp(_s241["__p"]["r"], "x")
		_s241["y"] = J.gp(_s241["__p"]["r"], "y")
		_s241["w"] = J.gp(_s241["__p"]["r"], "w")
		v_h_506 = J.gp(_s241["__p"]["r"], "h")
		_s241["rr"] = J.div(_s241["w"], 2.0)
		v_path_508 = Callable(self, "_f119").bind(_s241)
		v_gr_509 = J.mc(_s241["__p"]["ctx"], "createLinearGradient", [_s241["x"], _s241["y"], J.add(_s241["x"], _s241["w"]), J.gp(_s241["__p"]["r"], "by")])
		J.mc(v_gr_509, "addColorStop", [0.0, "#9aa0a6"])
		J.mc(v_gr_509, "addColorStop", [1.0, "#5c6168"])
		var _t442 = _s241["__p"]["ctx"]
		J.sp(_t442, "fillStyle", v_gr_509)
		J.cl(v_path_508, null, [])
		J.mc(_s241["__p"]["ctx"], "fill", [])
		J.mc(_s241["__p"]["ctx"], "save", [])
		J.cl(v_path_508, null, [])
		J.mc(_s241["__p"]["ctx"], "clip", [])
		for _t443 in J.iter(J.gp(J.gp(this_, "stones"), v_gi_490)):
			var _t444 = J.gp(_t443, 0.0)
			v_a_510 = _t444
			var _t445 = J.gp(_t443, 1.0)
			v_b2_511 = _t445
			var _t446 = J.gp(_t443, 2.0)
			v_ang_512 = _t446
			var _t447 = J.gp(_t443, 3.0)
			v_k_513 = _t447
			var _t448 = _s241["__p"]["ctx"]
			var _t449 = ("rgba(255,255,255,.13)" if J.cmp(v_k_513, 0.5, ">") else "rgba(30,30,40,.16)")
			J.sp(_t448, "strokeStyle", _t449)
			var _t450 = _s241["__p"]["ctx"]
			var _t451 = J.mul(1.6, _s241["__p"]["u"])
			J.sp(_t450, "lineWidth", _t451)
			v_sx_514 = J.add(_s241["x"], J.mul(v_a_510, _s241["w"]))
			v_sy_515 = J.add(_s241["y"], J.mul(v_b2_511, v_h_506))
			J.mc(_s241["__p"]["ctx"], "beginPath", [])
			J.mc(_s241["__p"]["ctx"], "moveTo", [v_sx_514, v_sy_515])
			J.mc(_s241["__p"]["ctx"], "lineTo", [J.add(v_sx_514, J.mul(10.0, _s241["__p"]["u"])), J.add(v_sy_515, J.mul(J.mul(v_ang_512, 10.0), _s241["__p"]["u"]))])
			J.mc(_s241["__p"]["ctx"], "stroke", [])
		var _t452 = _s241["__p"]["ctx"]
		J.sp(_t452, "fillStyle", "rgba(80,110,60,.5)")
		J.mc(_s241["__p"]["ctx"], "beginPath", [])
		J.mc(_s241["__p"]["ctx"], "ellipse", [J.add(_s241["x"], J.mul(_s241["w"], 0.2)), J.sub(J.gp(_s241["__p"]["r"], "by"), J.mul(7.0, _s241["__p"]["u"])), J.mul(9.0, _s241["__p"]["u"]), J.mul(4.0, _s241["__p"]["u"]), 0.0, 0.0, (PI * 2.0)])
		J.mc(_s241["__p"]["ctx"], "fill", [])
		J.mc(_s241["__p"]["ctx"], "restore", [])
		var _t453 = _s241["__p"]["ctx"]
		J.sp(_t453, "strokeStyle", "#26232a")
		var _t454 = _s241["__p"]["ctx"]
		var _t455 = J.mul(2.4, _s241["__p"]["u"])
		J.sp(_t454, "lineWidth", _t455)
		J.cl(v_path_508, null, [])
		J.mc(_s241["__p"]["ctx"], "stroke", [])
		var _t456 = _s241["__p"]["ctx"]
		J.sp(_t456, "fillStyle", "#4a4e55")
		J.mc(_s241["__p"]["ctx"], "fillRect", [J.sub(_s241["x"], J.mul(5.0, _s241["__p"]["u"])), J.sub(J.gp(_s241["__p"]["r"], "by"), J.mul(7.0, _s241["__p"]["u"])), J.add(_s241["w"], J.mul(10.0, _s241["__p"]["u"])), J.mul(7.0, _s241["__p"]["u"])])
		J.mc(_s241["__p"]["ctx"], "strokeRect", [J.sub(_s241["x"], J.mul(5.0, _s241["__p"]["u"])), J.sub(J.gp(_s241["__p"]["r"], "by"), J.mul(7.0, _s241["__p"]["u"])), J.add(_s241["w"], J.mul(10.0, _s241["__p"]["u"])), J.mul(7.0, _s241["__p"]["u"])])
	if J.t(_s239["tab"]):
		var _s245 = {"__p": _s239, "fs": null, "y1": null}
		v_chs_516 = J.spread([J.SP(J.gp(v_g_489, "name"))])
		_s245["fs"] = J.min_([J.mul(J.gp(_s245["__p"]["tab"], "w"), 0.62), J.div(J.sub(J.gp(_s245["__p"]["tab"], "bot"), J.gp(_s245["__p"]["tab"], "top")), (J.len(v_chs_516) + 0.6))])
		var _t457 = _s245["__p"]["ctx"]
		var _t458 = ("900 " + J.str(_s245["fs"]) + "px \"Songti TC\",\"Noto Serif CJK TC\",serif")
		J.sp(_t457, "font", _t458)
		var _t459 = _s245["__p"]["ctx"]
		J.sp(_t459, "textAlign", "center")
		var _t460 = _s245["__p"]["ctx"]
		J.sp(_t460, "textBaseline", "middle")
		_s245["y1"] = (J.div(J.add(J.gp(_s245["__p"]["tab"], "top"), J.gp(_s245["__p"]["tab"], "bot")), 2.0) - (J.mul((J.len(v_chs_516) - 1.0), _s245["fs"]) * 0.52))
		J.mc(v_chs_516, "forEach", [Callable(self, "_f120").bind(_s245)])
		var _t463 = _s245["__p"]["ctx"]
		J.sp(_t463, "textBaseline", "alphabetic")
	else:
		var _s247 = {"__p": _s239, "fs": null}
		_s247["fs"] = J.round(J.num(J.mul(12.5, _s247["__p"]["u"])))
		var _t464 = _s247["__p"]["ctx"]
		var _t465 = ("900 " + J.str(_s247["fs"]) + "px \"Songti TC\",\"Noto Serif CJK TC\",serif")
		J.sp(_t464, "font", _t465)
		var _t466 = _s247["__p"]["ctx"]
		J.sp(_t466, "textAlign", "center")
		var _t467 = J.spread([J.SP(J.gp(v_g_489, "name"))])
		J.mc(_t467, "forEach", [Callable(self, "_f121").bind(_s247)])
	if (not J.t(_s239["tab"])):
		v_k_526 = (-1.0)
		while true:
			if not J.cmp(v_k_526, 1.0, "<="): break
			v_hx_527 = J.sub(J.add(J.gp(_s239["r"], "cx"), J.mul(J.mul(v_k_526, 5.0), _s239["u"])), J.mul(J.gp(_s239["r"], "w"), 0.66))
			v_hy_528 = J.add(J.gp(_s239["r"], "by"), J.mul(2.0, _s239["u"]))
			var _t470 = _s239["ctx"]
			J.sp(_t470, "strokeStyle", "#b8742a")
			var _t471 = _s239["ctx"]
			var _t472 = J.mul(1.4, _s239["u"])
			J.sp(_t471, "lineWidth", _t472)
			J.mc(_s239["ctx"], "beginPath", [])
			J.mc(_s239["ctx"], "moveTo", [v_hx_527, v_hy_528])
			J.mc(_s239["ctx"], "lineTo", [J.add(v_hx_527, J.mul(J.mul(v_k_526, 1.5), _s239["u"])), J.sub(v_hy_528, J.mul(14.0, _s239["u"]))])
			J.mc(_s239["ctx"], "stroke", [])
			var _t473 = _s239["ctx"]
			var _t474 = ("rgba(255," + J.str((120.0 + (60.0 * sin(J.num(J.add(J.add(J.mul(v_t_491, 5.0), v_k_526), v_gi_490)))))) + ",60,.95)")
			J.sp(_t473, "fillStyle", _t474)
			J.mc(_s239["ctx"], "beginPath", [])
			J.mc(_s239["ctx"], "arc", [J.add(v_hx_527, J.mul(J.mul(v_k_526, 1.5), _s239["u"])), J.sub(v_hy_528, J.mul(14.0, _s239["u"])), J.mul(1.6, _s239["u"]), 0.0, (PI * 2.0)])
			J.mc(_s239["ctx"], "fill", [])
			v_k_526 = J.num(v_k_526) + 1.0
	if J.t(v_view_494):
		var _t475 = _s239["ctx"]
		J.sp(_t475, "strokeStyle", "rgba(255,230,140,.9)")
		var _t476 = _s239["ctx"]
		J.sp(_t476, "lineWidth", 2.5)
		J.mc(_s239["ctx"], "beginPath", [])
		J.mc(_s239["ctx"], "roundRect", [J.sub(J.gp(_s239["r"], "x"), J.mul(6.0, _s239["u"])), J.sub(J.gp(_s239["r"], "y"), J.mul(6.0, _s239["u"])), J.add(J.gp(_s239["r"], "w"), J.mul(12.0, _s239["u"])), J.add(J.gp(_s239["r"], "h"), J.mul(8.0, _s239["u"])), J.mul(10.0, _s239["u"])])
		J.mc(_s239["ctx"], "stroke", [])
	if J.t(J.gp(v_g_489, "off")):
		v_fs_529 = J.max_([11.0, J.round(J.num(J.mul(11.5, _s239["u"])))])
		var _t477 = _s239["ctx"]
		var _t478 = ("800 " + J.str(v_fs_529) + "px \"PingFang TC\",\"Noto Sans CJK TC\",sans-serif")
		J.sp(_t477, "font", _t478)
		var _t479 = _s239["ctx"]
		J.sp(_t479, "textAlign", "center")
		var _t480 = _s239["ctx"]
		J.sp(_t480, "textBaseline", "middle")
		v_txt_530 = J.add("祭品・", J.gp(v_g_489, "off"))
		v_tw_531 = J.add(J.gp(J.mc(_s239["ctx"], "measureText", [v_txt_530]), "width"), J.mul(12.0, _s239["u"]))
		v_th_532 = J.add(v_fs_529, J.mul(8.0, _s239["u"]))
		v_ty_533 = J.add(J.add(J.gp(_s239["r"], "by"), J.mul(10.0, _s239["u"])), J.div(v_th_532, 2.0))
		var _t481 = _s239["ctx"]
		J.sp(_t481, "fillStyle", "rgba(250,240,214,.94)")
		var _t482 = _s239["ctx"]
		J.sp(_t482, "strokeStyle", "#6b4a2b")
		var _t483 = _s239["ctx"]
		var _t484 = J.mul(1.6, _s239["u"])
		J.sp(_t483, "lineWidth", _t484)
		J.mc(_s239["ctx"], "beginPath", [])
		J.mc(_s239["ctx"], "roundRect", [J.sub(J.gp(_s239["r"], "cx"), J.div(v_tw_531, 2.0)), J.sub(v_ty_533, J.div(v_th_532, 2.0)), v_tw_531, v_th_532, J.mul(5.0, _s239["u"])])
		J.mc(_s239["ctx"], "fill", [])
		J.mc(_s239["ctx"], "stroke", [])
		var _t485 = _s239["ctx"]
		J.sp(_t485, "fillStyle", "#3a2614")
		J.mc(_s239["ctx"], "fillText", [v_txt_530, J.gp(_s239["r"], "cx"), J.add(v_ty_533, 0.5)])
		var _t486 = _s239["ctx"]
		J.sp(_t486, "textBaseline", "alphabetic")
	J.mc(_s239["ctx"], "restore", [])

func _f122(this_, a: Array, env):
	var v_ctx_536 = null; var v_s_537 = null; var v_t_538 = null; var v_restK_539 = null; var v_u_540 = null; var v_hh_541 = null; var v_d_542 = null; var v_x_543 = null; var v_y_544 = null; var v_pose_545 = null; var v_pt_546 = null; var v_alpha_547 = null; var v_lift_548 = null; var v_flip_549 = null; var v_g_550 = null; var v_ty_551 = null; var v_r_552 = null
	v_ctx_536 = J.arg(a, 0)
	v_s_537 = J.arg(a, 1)
	v_t_538 = J.arg(a, 2)
	v_restK_539 = J.arg(a, 3)
	v_u_540 = J.mc(this_, "unit", [])
	v_hh_541 = J.mc(this_, "soulH", [])
	var _t487 = J.gp(this_, "drag")
	var _t488 = (J.seq(J.gp(J.gp(this_, "drag"), "s"), v_s_537) if J.t(_t487) else _t487)
	v_d_542 = (J.gp(this_, "drag") if J.t((J.gp(J.gp(this_, "drag"), "moved") if J.t(_t488) else _t488)) else null)
	var _t489 = J.mc(this_, "pt", [J.gp(v_s_537, "x"), J.gp(v_s_537, "y")])
	var _t490 = J.gp(_t489, 0.0)
	v_x_543 = _t490
	var _t491 = J.gp(_t489, 1.0)
	v_y_544 = _t491
	if J.t(v_d_542):
		v_x_543 = J.gp(v_d_542, "mx")
		var _t492 = J.add(J.gp(v_d_542, "my"), J.mul(18.0, v_u_540))
		v_y_544 = _t492
	v_pose_545 = ("idle" if (not J.leq(J.gp(v_s_537, "place"), null)) else "idle")
	v_pt_546 = 0.0
	v_alpha_547 = J.gp(v_s_537, "a")
	v_lift_548 = 0.0
	v_flip_549 = false
	if J.t(v_d_542):
		v_pose_545 = "move"
	if (not J.leq(J.gp(v_s_537, "place"), null)):
		v_flip_549 = true
	var _t493 = J.gp(v_s_537, "rx")
	if J.t((J.cmp(J.gp(J.gp(v_s_537, "rx"), "t"), 0.0, ">=") if J.t(_t493) else _t493)):
		v_pose_545 = "hurt"
		var _t494 = J.min_([1.0, J.div(J.gp(J.gp(v_s_537, "rx"), "t"), J.gp(J.gp(v_s_537, "rx"), "dur"))])
		v_pt_546 = _t494
		var _t495 = J.add(v_x_543, (J.mul((sin(J.num(J.mul(J.gp(J.gp(v_s_537, "rx"), "t"), 40.0))) * 3.0), v_u_540) * J.sub(1.0, v_pt_546)))
		v_x_543 = _t495
	if J.cmp(v_restK_539, 0.0, ">"):
		v_pose_545 = "cast"
		v_pt_546 = v_restK_539
		var _t496 = (J.mul(J.mul(v_restK_539, v_restK_539), v_hh_541) * 1.6)
		v_lift_548 = _t496
		var _t497 = J.mul(J.gp(v_s_537, "a"), (1.0 - J.max_([0.0, J.div(J.sub(v_restK_539, 0.45), 0.55)])))
		v_alpha_547 = _t497
	J.sp(v_s_537, "px", v_x_543)
	J.sp(v_s_537, "py", v_y_544)
	if J.cmp(v_alpha_547, 0.01, "<="):
		return null
	v_g_550 = J.mc(v_ctx_536, "createRadialGradient", [v_x_543, J.sub(J.sub(v_y_544, J.mul(v_hh_541, 0.5)), v_lift_548), 2.0, v_x_543, J.sub(J.sub(v_y_544, J.mul(v_hh_541, 0.5)), v_lift_548), J.mul(v_hh_541, (0.75 + J.mul(v_restK_539, 0.8)))])
	J.mc(v_g_550, "addColorStop", [0.0, J.mc(this_, "rgba", [J.gp(v_s_537, "col"), (J.mul((0.55 if J.seq(J.gp(this_, "sel"), J.gp(v_s_537, "i")) else 0.3), v_alpha_547) + J.mul(v_restK_539, 0.3))])])
	J.mc(v_g_550, "addColorStop", [1.0, J.mc(this_, "rgba", [J.gp(v_s_537, "col"), 0.0])])
	J.sp(v_ctx_536, "globalCompositeOperation", "lighter")
	J.sp(v_ctx_536, "fillStyle", v_g_550)
	J.mc(v_ctx_536, "beginPath", [])
	J.mc(v_ctx_536, "arc", [v_x_543, J.sub(J.sub(v_y_544, J.mul(v_hh_541, 0.5)), v_lift_548), J.mul(v_hh_541, (0.75 + J.mul(v_restK_539, 0.8))), 0.0, (PI * 2.0)])
	J.mc(v_ctx_536, "fill", [])
	J.sp(v_ctx_536, "globalCompositeOperation", "source-over")
	if J.seq(J.gp(this_, "sel"), J.gp(v_s_537, "i")):
		var _t498 = J.mc(this_, "rgba", [J.gp(v_s_537, "col"), 0.9])
		J.sp(v_ctx_536, "strokeStyle", _t498)
		J.sp(v_ctx_536, "lineWidth", 2.5)
		J.mc(v_ctx_536, "setLineDash", [[5.0, 4.0]])
		J.mc(v_ctx_536, "beginPath", [])
		J.mc(v_ctx_536, "ellipse", [v_x_543, v_y_544, J.mul(v_hh_541, 0.4), J.mul(v_hh_541, 0.11), 0.0, 0.0, (PI * 2.0)])
		J.mc(v_ctx_536, "stroke", [])
		J.mc(v_ctx_536, "setLineDash", [[]])
	if (not J.seq(J.typeof_(J.G.get("ART")), "undefined")):
		J.mc(J.G.get("ART"), "drawChar", [v_ctx_536, "youhun", v_x_543, J.sub(v_y_544, v_lift_548), J.div(v_hh_541, 50.0), {"t": J.add(J.mul(v_t_538, (1.5 if J.seq(v_pose_545, "hurt") else 1.0)), J.gp(v_s_537, "ph")), "pose": v_pose_545, "pt": v_pt_546, "flip": v_flip_549, "alpha": v_alpha_547, "shadow": false}])
	v_ty_551 = (J.sub(J.sub(v_y_544, J.mul(v_hh_541, 1.1)), v_lift_548) + J.mul((sin(J.num(J.add(J.mul(v_t_538, 2.0), J.gp(v_s_537, "ph")))) * 3.0), v_u_540))
	v_r_552 = J.mul(13.0, v_u_540)
	var _t499 = J.min_([1.0, J.mul(v_alpha_547, 1.15)])
	J.sp(v_ctx_536, "globalAlpha", _t499)
	J.sp(v_ctx_536, "fillStyle", "rgba(14,10,20,.85)")
	J.mc(v_ctx_536, "beginPath", [])
	J.mc(v_ctx_536, "arc", [v_x_543, v_ty_551, v_r_552, 0.0, (PI * 2.0)])
	J.mc(v_ctx_536, "fill", [])
	var _t500 = J.gp(v_s_537, "col")
	J.sp(v_ctx_536, "strokeStyle", _t500)
	J.sp(v_ctx_536, "lineWidth", 2.2)
	J.mc(v_ctx_536, "stroke", [])
	var _t501 = ("900 " + J.str(J.round(J.num(J.mul(18.0, v_u_540)))) + "px sans-serif")
	J.sp(v_ctx_536, "font", _t501)
	J.sp(v_ctx_536, "textAlign", "center")
	J.sp(v_ctx_536, "textBaseline", "middle")
	var _t502 = J.gp(v_s_537, "col")
	J.sp(v_ctx_536, "fillStyle", _t502)
	J.mc(v_ctx_536, "fillText", [J.gp(v_s_537, "tag"), v_x_543, J.add(v_ty_551, 1.0)])
	J.sp(v_ctx_536, "textBaseline", "alphabetic")
	J.sp(v_ctx_536, "globalAlpha", 1.0)

func _f123(this_, a: Array, env):
	var v_hex_555 = null; var v_a_556 = null; var v_v_557 = null
	v_hex_555 = J.arg(a, 0)
	v_a_556 = J.arg(a, 1)
	v_v_557 = J.F_parseInt([J.mc(v_hex_555, "slice", [1.0]), 16.0])
	return ("rgba(" + J.str(J.band(J.shr(v_v_557, 16.0), 255.0)) + "," + J.str(J.band(J.shr(v_v_557, 8.0), 255.0)) + "," + J.str(J.band(v_v_557, 255.0)) + "," + J.str(J.max_([0.0, J.min_([1.0, v_a_556])])) + ")")

func _f125(this_, a: Array, env):
	var v_l_575 = null
	v_l_575 = J.arg(a, 0)
	return J.gp(J.mc(env["ctx"], "measureText", [v_l_575]), "width")

func _f126(this_, a: Array, env):
	var v_l_576 = null; var v_i_577 = null
	v_l_576 = J.arg(a, 0)
	v_i_577 = J.arg(a, 1)
	return J.mc(env["ctx"], "fillText", [v_l_576, J.add(env["bx"], 9.0), J.add(J.add(env["by"], 6.0), J.mul(env["lh"], J.add(v_i_577, 0.78)))])

func _f124(this_, a: Array, env):
	var v_text_561 = null; var v_x_562 = null; var v_y_563 = null; var v_a_564 = null; var v_u_565 = null; var v_maxW_566 = null; var v_lines_567 = null; var v_cur_568 = null; var v_w_570 = null; var v_h_571 = null; var v_ch_574 = null
	var _s260 = {"__p": env, "ctx": null, "lh": null, "bx": null, "by": null}
	_s260["ctx"] = J.arg(a, 0)
	v_text_561 = J.arg(a, 1)
	v_x_562 = J.arg(a, 2)
	v_y_563 = J.arg(a, 3)
	v_a_564 = J.arg(a, 4)
	v_u_565 = J.mc(this_, "unit", [])
	J.mc(_s260["ctx"], "save", [])
	var _t503 = _s260["ctx"]
	J.sp(_t503, "globalAlpha", v_a_564)
	var _t504 = _s260["ctx"]
	var _t505 = ("700 " + J.str(J.round(J.num(J.mul(14.0, v_u_565)))) + "px sans-serif")
	J.sp(_t504, "font", _t505)
	v_maxW_566 = J.mul(J.gp(this_, "W"), 0.62)
	v_lines_567 = []
	v_cur_568 = ""
	for _t506 in J.iter(v_text_561):
		v_ch_574 = _t506
		if J.cmp(J.gp(J.mc(_s260["ctx"], "measureText", [J.add(v_cur_568, v_ch_574)]), "width"), v_maxW_566, ">"):
			J.mc(v_lines_567, "push", [v_cur_568])
			v_cur_568 = v_ch_574
		else:
			var _t507 = J.add(v_cur_568, v_ch_574)
			v_cur_568 = _t507
	J.mc(v_lines_567, "push", [v_cur_568])
	_s260["lh"] = J.mul(19.0, v_u_565)
	v_w_570 = (J.max_(J.spread([J.SP(J.mc(v_lines_567, "map", [Callable(self, "_f125").bind(_s260)]))])) + 18.0)
	v_h_571 = (J.mul(J.len(v_lines_567), _s260["lh"]) + 12.0)
	_s260["bx"] = J.max_([6.0, J.min_([(J.sub(J.gp(this_, "W"), v_w_570) - 6.0), J.sub(v_x_562, 20.0)])])
	_s260["by"] = J.sub(v_y_563, v_h_571)
	var _t508 = _s260["ctx"]
	J.sp(_t508, "fillStyle", "rgba(255,250,236,.95)")
	var _t509 = _s260["ctx"]
	J.sp(_t509, "strokeStyle", "#3a2a1a")
	var _t510 = _s260["ctx"]
	J.sp(_t510, "lineWidth", 1.5)
	J.mc(_s260["ctx"], "beginPath", [])
	J.mc(_s260["ctx"], "roundRect", [_s260["bx"], _s260["by"], v_w_570, v_h_571, 9.0])
	J.mc(_s260["ctx"], "fill", [])
	J.mc(_s260["ctx"], "stroke", [])
	J.mc(_s260["ctx"], "beginPath", [])
	J.mc(_s260["ctx"], "moveTo", [J.sub(v_x_562, 6.0), J.add(_s260["by"], v_h_571)])
	J.mc(_s260["ctx"], "lineTo", [J.sub(v_x_562, 2.0), J.add(J.add(_s260["by"], v_h_571), 9.0)])
	J.mc(_s260["ctx"], "lineTo", [J.add(v_x_562, 6.0), J.add(_s260["by"], v_h_571)])
	J.mc(_s260["ctx"], "fill", [])
	var _t511 = _s260["ctx"]
	J.sp(_t511, "fillStyle", "#2a1a10")
	var _t512 = _s260["ctx"]
	J.sp(_t512, "textAlign", "left")
	J.mc(v_lines_567, "forEach", [Callable(self, "_f126").bind(_s260)])
	J.mc(_s260["ctx"], "restore", [])
