# 自動轉譯自 graveyard.js（tools/jsgd.js）——唔好直接改，改原 JS 再轉
extends RefCounted

func run(env):
	var this_ = null; var a = []
	J.G["GY_SPOTS"] = {"A": {"x": 0.25, "y": 0.375, "row": 0.0, "side": 0.0, "name": "左上"}, "B": {"x": 0.76, "y": 0.37, "row": 0.0, "side": 2.0, "name": "右上"}, "C": {"x": 0.52, "y": 0.475, "row": 1.0, "side": 1.0, "name": "正中間"}, "D": {"x": 0.24, "y": 0.585, "row": 2.0, "side": 0.0, "name": "左下"}, "E": {"x": 0.76, "y": 0.58, "row": 2.0, "side": 2.0, "name": "右下"}}
	J.G["GY_TOMB_TAB"] = [[0.5, 0.29, 0.52, 0.38, 0.62], [0.49, 0.24, 0.55, 0.37, 0.61], [0.5, 0.3, 0.52, 0.38, 0.62], [0.5, 0.24, 0.52, 0.38, 0.62]]
	J.G["GY_TAGS"] = ["①", "②", "③", "④", "⑤"]
	J.G["GY_LEVELS"] = {"1": {"n": 3.0, "g": 3.0, "direct": 2.0}, "2": {"n": 4.0, "g": 4.0, "direct": 1.0}, "3": {"n": 4.0, "g": 5.0, "direct": 1.0}, "4": {"n": 5.0, "g": 5.0, "direct": 1.0}}
	J.G["GY_JOBS"] = {"會計": {"ep": [["數了一輩子別人的錢", ["一輩子", "別人的錢"]], ["帳終於對平了", ["對平"]]], "last": "帳……對平了。"}, "保安": {"ep": [["守了三十年大門，今天準時下班", ["大門", "準時下班"]], ["大家都回家了，我也回家", ["回家"]]], "last": "可以關燈了。"}, "外賣員": {"ep": [["這一單，終於送到了", ["送到了", "這一單"]], ["風雨無阻，請給五星", ["五星", "風雨無阻"]]], "last": "這一單……送到了。"}, "補習老師": {"ep": [["下課鐘響了，不用再補", ["下課", "不用再補"]], ["考試範圍：無", ["考試範圍"]]], "last": "今天，不留功課。"}, "茶室頭手": {"ep": [["最後一杯，走甜", ["走甜", "最後一杯"]], ["爐火熄了，人也歇了", ["爐火"]]], "last": "Kopi-O，走甜。"}, "地產經紀": {"ep": [["此地永久地契，不設轉售", ["永久地契", "不設轉售"]], ["風水一流，近地鐵站", ["風水", "地鐵站"]]], "last": "這個單位……我自己住。"}, "夜班護士": {"ep": [["換班了，這次真的睡了", ["換班", "真的睡了"]], ["不用再叫醒我了", ["叫醒"]]], "last": "下一更，交給你們了。"}, "羅里司機": {"ep": [["跑了一百萬公里，終於泊好", ["泊好", "一百萬公里"]], ["前路不再塞車", ["塞車"]]], "last": "引擎，熄了。"}, "收銀員": {"ep": [["找你零錢，不用謝", ["零錢", "不用謝"]], ["收工了，抽屜對數", ["抽屜"]]], "last": "下一位……沒有了。"}, "銀行櫃員": {"ep": [["請取號，下一位", ["取號", "下一位"]], ["本櫃台暫停服務", ["暫停服務"]]], "last": "本櫃台，暫停服務。"}, "文員": {"ep": [["影印了半生，終於原件歸檔", ["原件歸檔", "影印"]], ["已讀，不回", ["已讀"]]], "last": "這份，不用再改了。"}, "網約車司機": {"ep": [["目的地：已抵達", ["已抵達", "目的地"]], ["乘客已下車，請給好評", ["下車", "好評"]]], "last": "目的地，到了。"}, "小販": {"ep": [["今天早點收檔", ["收檔", "早點"]], ["賣完了，明天請早", ["明天請早"]]], "last": "今天，賣完了。"}, "人事專員": {"ep": [["您的離職申請已批准", ["離職申請", "已批准"]], ["恭喜轉正，永不續約", ["轉正", "永不續約"]]], "last": "這次，是我自己批准的。"}}
	J.G["GY_OFFERS"] = ["榴槤", "麻將牌", "一封沒拆的公司信", "老花眼鏡", "麥芽飲品罐", "椰漿飯", "計算機", "粉筆", "安全帽", "一串鑰匙", "舊手機", "萬字票", "紅包", "藍白拖鞋"]
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
	J.G["__gyDC"] = Callable(self, "_f43").bind(env)
	J.G["Graveyard"] = {"_nd": Callable(self, "_f44").bind(env), "active": false, "ensure": Callable(self, "_f45").bind(env), "open": Callable(self, "_f46").bind(env), "close": Callable(self, "_f61").bind(env), "hint": Callable(self, "_f62").bind(env), "resize": Callable(self, "_f65").bind(env), "bgScale": Callable(self, "_f67").bind(env), "pt": Callable(self, "_f68").bind(env), "unit": Callable(self, "_f69").bind(env), "soulH": Callable(self, "_f70").bind(env), "homeOf": Callable(self, "_f71").bind(env), "graveAt": Callable(self, "_f72").bind(env), "standOf": Callable(self, "_f73").bind(env), "targetOf": Callable(self, "_f74").bind(env), "stoneRect": Callable(self, "_f75").bind(env), "local": Callable(self, "_f76").bind(env), "soulAtPx": Callable(self, "_f77").bind(env), "graveAtPx": Callable(self, "_f78").bind(env), "down": Callable(self, "_f80").bind(env), "move": Callable(self, "_f81").bind(env), "up": Callable(self, "_f82").bind(env), "place": Callable(self, "_f83").bind(env), "allPlaced": Callable(self, "_f84").bind(env), "correct": Callable(self, "_f86").bind(env), "submit": Callable(self, "_f88").bind(env), "say": Callable(self, "_f91").bind(env), "rest": Callable(self, "_f92").bind(env), "finish": Callable(self, "_f96").bind(env), "renderPanel": Callable(self, "_f103").bind(env), "frame": Callable(self, "_f111").bind(env), "step": Callable(self, "_f114").bind(env), "draw": Callable(self, "_f117").bind(env), "fog": Callable(self, "_f121").bind(env), "drawStone": Callable(self, "_f122").bind(env), "drawSoul": Callable(self, "_f126").bind(env), "rgba": Callable(self, "_f127").bind(env), "bubble": Callable(self, "_f128").bind(env)}

func _f2(this_, a: Array, env):
	var v_t_23 = null
	var _t1 = J.ushr(J.add(env["a"], 1831565813.0), 0.0)
	env["a"] = _t1
	v_t_23 = env["a"]
	var _t2 = J.math("imul", [J.bxor(v_t_23, J.ushr(v_t_23, 15.0)), J.bor(v_t_23, 1.0)])
	v_t_23 = _t2
	var _t3 = J.bxor(v_t_23, J.add(v_t_23, J.math("imul", [J.bxor(v_t_23, J.ushr(v_t_23, 7.0)), J.bor(v_t_23, 61.0)])))
	v_t_23 = _t3
	return J.div(J.ushr(J.bxor(v_t_23, J.ushr(v_t_23, 14.0)), 0.0), 4294967296.0)

func _f1(this_, a: Array, env):
	var v_seed_21 = null
	var _s2 = {"__p": env, "a": null}
	v_seed_21 = J.arg(a, 0)
	_s2["a"] = J.ushr(v_seed_21, 0.0)
	return Callable(self, "_f2").bind(_s2)

func _f3(this_, a: Array, env):
	var v_night_26 = null
	v_night_26 = J.arg(a, 0)
	return (1.0 if J.cmp(v_night_26, 2.0, "<=") else (2.0 if J.cmp(v_night_26, 4.0, "<=") else (3.0 if J.cmp(v_night_26, 7.0, "<=") else 4.0)))

func _f4(this_, a: Array, env):
	var v_c_29 = null; var v_asg_30 = null; var v_graves_31 = null; var v_me_32 = null; var v_o_33 = null; var v_sp_34 = null; var v_so_35 = null
	v_c_29 = J.arg(a, 0)
	v_asg_30 = J.arg(a, 1)
	v_graves_31 = J.arg(a, 2)
	v_me_32 = J.gp(v_graves_31, J.gp(v_asg_30, J.gp(v_c_29, "who")))
	v_o_33 = (J.gp(v_graves_31, J.gp(v_asg_30, J.gp(v_c_29, "j"))) if (not J.leq(J.gp(v_c_29, "j"), null)) else null)
	v_sp_34 = J.gp(J.G.get("GY_SPOTS"), J.gp(v_me_32, "spot"))
	v_so_35 = (J.gp(J.G.get("GY_SPOTS"), J.gp(v_o_33, "spot")) if J.t(v_o_33) else v_o_33)
	var _t4 = J.gp(v_c_29, "t")
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
			return J.seq(J.gp(v_me_32, "job"), J.gp(v_c_29, "v"))
		if _t5 <= 1 and _t5 >= 0:
			return (not J.seq(J.gp(v_me_32, "job"), J.gp(v_c_29, "v")))
		if _t5 <= 2 and _t5 >= 0:
			return (not J.seq(J.gp(v_o_33, "job"), J.gp(v_c_29, "v")))
		if _t5 <= 3 and _t5 >= 0:
			return J.seq(J.gp(v_me_32, "off"), J.gp(v_c_29, "v"))
		if _t5 <= 4 and _t5 >= 0:
			return (not J.seq(J.gp(v_me_32, "off"), J.gp(v_c_29, "v")))
		if _t5 <= 5 and _t5 >= 0:
			var _t7 = J.gp(v_me_32, "ep")
			return J.mc(_t7, "includes", [J.gp(v_c_29, "v")])
		if _t5 <= 6 and _t5 >= 0:
			var _t8 = J.gp(v_me_32, "ep")
			return (not J.t(J.mc(_t8, "includes", [J.gp(v_c_29, "v")])))
		if _t5 <= 7 and _t5 >= 0:
			return J.seq(floor(J.num(J.div(J.sub(J.gp(v_me_32, "death"), J.gp(v_me_32, "birth")), 10.0))), J.gp(v_c_29, "v"))
		if _t5 <= 8 and _t5 >= 0:
			return J.seq(J.gp(J.gp(v_me_32, "name"), 0.0), J.gp(v_c_29, "v"))
		if _t5 <= 9 and _t5 >= 0:
			return J.seq(J.gp(v_sp_34, "row"), J.gp(v_c_29, "v"))
		if _t5 <= 10 and _t5 >= 0:
			return (not J.seq(J.gp(v_sp_34, "row"), J.gp(v_c_29, "v")))
		if _t5 <= 11 and _t5 >= 0:
			return J.seq(J.gp(v_sp_34, "side"), J.gp(v_c_29, "v"))
		if _t5 <= 12 and _t5 >= 0:
			return (not J.seq(J.gp(v_sp_34, "side"), J.gp(v_c_29, "v")))
		if _t5 <= 13 and _t5 >= 0:
			return J.seq(J.gp(v_me_32, "spot"), "D")
		if _t5 <= 14 and _t5 >= 0:
			return (not J.seq(J.gp(v_me_32, "spot"), "D"))
		if _t5 <= 15 and _t5 >= 0:
			return (J.cmp(J.gp(v_sp_34, "row"), J.gp(v_so_35, "row"), "<") if J.seq(J.gp(v_c_29, "v"), "up") else (J.cmp(J.gp(v_sp_34, "row"), J.gp(v_so_35, "row"), ">") if J.seq(J.gp(v_c_29, "v"), "down") else (J.cmp(J.gp(v_sp_34, "side"), J.gp(v_so_35, "side"), "<") if J.seq(J.gp(v_c_29, "v"), "left") else J.cmp(J.gp(v_sp_34, "side"), J.gp(v_so_35, "side"), ">"))))
		if _t5 <= 16 and _t5 >= 0:
			return J.seq(J.gp(v_sp_34, "row"), J.gp(v_so_35, "row"))
		if _t5 <= 17 and _t5 >= 0:
			return (J.cmp(J.gp(v_me_32, "death"), J.gp(v_o_33, "death"), "<") if J.seq(J.gp(v_c_29, "v"), "early") else J.cmp(J.gp(v_me_32, "death"), J.gp(v_o_33, "death"), ">"))
		break
	return false

func _f7(this_, a: Array, env):
	var v_c_51 = null
	v_c_51 = J.arg(a, 0)
	return J.mc(env["this"], "holds", [v_c_51, env["asg"], env["graves"]])

func _f6(this_, a: Array, env):
	var v_i_49 = null; var v_g_50 = null
	v_i_49 = J.arg(a, 0)
	if J.t((J.cmp(J.len(env["out"]), env["cap"], ">=") if J.t(env["cap"]) else env["cap"])):
		return null
	if J.seq(v_i_49, env["n"]):
		J.mc(env["out"], "push", [J.mc(env["asg"], "slice", [])])
		return null
	v_g_50 = 0.0
	while true:
		if not J.cmp(v_g_50, J.len(env["graves"]), "<"): break
		if J.t(J.gp(env["used"], v_g_50)):
			v_g_50 = J.num(v_g_50) + 1.0
			continue
		var _t12 = env["used"]
		J.sp(_t12, v_g_50, true)
		var _t13 = env["asg"]
		J.sp(_t13, v_i_49, v_g_50)
		var _t14 = J.gp(env["byWho"], v_i_49)
		if J.t(J.mc(_t14, "every", [Callable(self, "_f7").bind(env)])):
			var _t15 = env["rec"]
			J.cl(_t15, null, [J.add(v_i_49, 1.0)])
		var _t16 = env["used"]
		J.sp(_t16, v_g_50, false)
		v_g_50 = J.num(v_g_50) + 1.0

func _f5(this_, a: Array, env):
	var v_clues_40 = null; var v_i_47 = null; var v_c_48 = null
	var _s7 = {"__p": env, "this": null, "n": null, "graves": null, "cap": null, "out": null, "asg": null, "used": null, "byWho": null, "rec": null}
	_s7["this"] = this_
	_s7["n"] = J.arg(a, 0)
	_s7["graves"] = J.arg(a, 1)
	v_clues_40 = J.arg(a, 2)
	_s7["cap"] = J.arg(a, 3)
	_s7["out"] = []
	_s7["asg"] = []
	var _t9 = J.new_("Array", [J.len(_s7["graves"])])
	_s7["used"] = J.mc(_t9, "fill", [false])
	_s7["byWho"] = []
	v_i_47 = 0.0
	while true:
		if not J.cmp(v_i_47, _s7["n"], "<"): break
		J.mc(_s7["byWho"], "push", [[]])
		v_i_47 = J.num(v_i_47) + 1.0
	for _t10 in J.iter(v_clues_40):
		v_c_48 = _t10
		var _t11 = J.gp(_s7["byWho"], J.max_([J.gp(v_c_48, "who"), (J.gp(v_c_48, "j") if (not J.leq(J.gp(v_c_48, "j"), null)) else (-1.0))]))
		J.mc(_t11, "push", [v_c_48])
	_s7["rec"] = Callable(self, "_f6").bind(_s7)
	var _t17 = _s7["rec"]
	J.cl(_t17, null, [0.0])
	return _s7["out"]

func _f8(this_, a: Array, env):
	var v_c_54 = null; var v_rnd_55 = null; var v_tp_56 = null; var v_s_57 = null; var v_J_58 = null; var v_v_59 = null
	v_c_54 = J.arg(a, 0)
	v_rnd_55 = J.arg(a, 1)
	v_tp_56 = J.gp(J.G.get("GY_TPL"), J.gp(v_c_54, "t"))
	v_s_57 = J.gp(v_tp_56, floor(J.num(J.mul(J.cl(v_rnd_55, null, []), J.len(v_tp_56)))))
	v_J_58 = (J.gp(J.G.get("GY_TAGS"), J.gp(v_c_54, "j")) if (not J.leq(J.gp(v_c_54, "j"), null)) else "")
	v_v_59 = J.gp(v_c_54, "v")
	if J.seq(J.gp(v_c_54, "t"), "age"):
		v_v_59 = J.gp(J.G.get("GY_DEC"), J.gp(v_c_54, "v"))
	var _t18 = J.mc(v_s_57, "replace", ["{job}", J.gp(v_c_54, "v")])
	var _t19 = J.mc(_t18, "replace", ["{off}", J.gp(v_c_54, "v")])
	var _t20 = J.mc(_t19, "replace", ["{q}", J.gp(v_c_54, "v")])
	var _t21 = J.mc(_t20, "replace", ["{d}", v_v_59])
	var _t22 = J.mc(_t21, "replace", ["{sn}", J.gp(v_c_54, "v")])
	var _t23 = J.mc(_t22, "replace", ["{row}", J.gp(J.G.get("GY_ROWW"), J.gp(v_c_54, "v"))])
	var _t24 = J.mc(_t23, "replace", ["{side}", J.gp(J.G.get("GY_SIDEW"), J.gp(v_c_54, "v"))])
	var _t25 = J.mc(_t24, "replace", ["{J}", v_J_58])
	var _t26 = J.mc(_t25, "replace", ["{dir}", J.gp({"up": "上面", "down": "下面", "left": "左邊", "right": "右邊"}, J.gp(v_c_54, "v"))])
	return J.mc(_t26, "replace", ["{when}", ("早走" if J.seq(J.gp(v_c_54, "v"), "early") else "晚走")])

func _f9(this_, a: Array, env):
	var v_night_62 = null; var v_seed_63 = null; var v_level_64 = null; var v_L_65 = null; var v_tries_66 = null; var v_r_67 = null; var v_p_68 = null
	v_night_62 = J.arg(a, 0)
	v_seed_63 = J.arg(a, 1)
	v_level_64 = J.mc(this_, "levelOf", [v_night_62])
	v_L_65 = J.gp(J.G.get("GY_LEVELS"), v_level_64)
	v_tries_66 = 0.0
	while true:
		if not J.cmp(v_tries_66, 400.0, "<"): break
		v_r_67 = J.mc(this_, "rng", [(J.ushr(v_seed_63, 0.0) + J.mul(v_tries_66, 7919.0))])
		v_p_68 = J.mc(this_, "tryGen", [v_L_65, v_r_67])
		if J.t(v_p_68):
			J.sp(v_p_68, "level", v_level_64)
			J.sp(v_p_68, "night", v_night_62)
			J.sp(v_p_68, "seed", v_seed_63)
			J.sp(v_p_68, "tries", v_tries_66)
			return v_p_68
		v_tries_66 = J.num(v_tries_66) + 1.0
	J.throw_(J.new_("Error", ["graveyard gen failed"]))
	return null

func _f10(this_, a: Array, env):
	var v_a_71 = null; var v_r_72 = null; var v_i_73 = null; var v_j_74 = null
	v_a_71 = J.arg(a, 0)
	v_r_72 = J.arg(a, 1)
	v_i_73 = (J.len(v_a_71) - 1.0)
	while true:
		if not J.cmp(v_i_73, 0.0, ">"): break
		v_j_74 = floor(J.num(J.mul(J.cl(v_r_72, null, []), J.add(v_i_73, 1.0))))
		var _t27 = [J.gp(v_a_71, v_j_74), J.gp(v_a_71, v_i_73)]
		var _t28 = J.gp(_t27, 0.0)
		J.sp(v_a_71, v_i_73, _t28)
		var _t29 = J.gp(_t27, 1.0)
		J.sp(v_a_71, v_j_74, _t29)
		v_i_73 = J.num(v_i_73) + -1.0
	return v_a_71

func _f12(this_, a: Array, env):
	var v_arr_111 = null; var v_k_112 = null
	v_arr_111 = J.arg(a, 0)
	v_k_112 = J.arg(a, 1)
	var _t30 = J.mc(env["this"], "shuffle", [J.mc(v_arr_111, "slice", []), env["r"]])
	return J.mc(_t30, "slice", [0.0, v_k_112])

func _f13(this_, a: Array, env):
	var v_x_114 = null
	v_x_114 = J.arg(a, 0)
	return (absf(J.num(J.sub(v_x_114, env["d"]))) >= 2.0)

func _f14(this_, a: Array, env):
	var v_s_115 = null; var v_i_116 = null; var v_dec_117 = null; var v_age_118 = null; var v_eps_119 = null; var v_e_120 = null
	v_s_115 = J.arg(a, 0)
	v_i_116 = J.arg(a, 1)
	v_dec_117 = (2.0 + floor(J.num(J.mul(J.cl(env["r"], null, []), 7.0))))
	v_age_118 = ((J.mul(v_dec_117, 10.0) + 2.0) + floor(J.num(J.mul(J.cl(env["r"], null, []), 7.0))))
	v_eps_119 = J.gp(J.gp(J.G.get("GY_JOBS"), J.gp(env["jobs"], v_i_116)), "ep")
	v_e_120 = J.gp(v_eps_119, floor(J.num(J.mul(J.cl(env["r"], null, []), J.len(v_eps_119)))))
	return {"spot": v_s_115, "name": J.add(J.gp(env["sn"], v_i_116), J.gp(env["gv"], v_i_116)), "job": J.gp(env["jobs"], v_i_116), "off": J.gp(env["offs"], v_i_116), "ep": J.gp(v_e_120, 0.0), "keys": J.gp(v_e_120, 1.0), "death": J.gp(env["deaths"], v_i_116), "birth": J.sub(J.gp(env["deaths"], v_i_116), v_age_118)}

func _f15(this_, a: Array, env):
	var v_g_121 = null
	v_g_121 = J.arg(a, 0)
	return J.gp(v_g_121, "ep")

func _f16(this_, a: Array, env):
	var v___122 = null; var v_i_123 = null
	v___122 = J.arg(a, 0)
	v_i_123 = J.arg(a, 1)
	return v_i_123

func _f17(this_, a: Array, env):
	var v_c_124 = null
	v_c_124 = J.arg(a, 0)
	if J.t(J.mc(env["this"], "holds", [v_c_124, env["truth"], env["graves"]])):
		J.mc(env["pool"], "push", [v_c_124])

func _f18(this_, a: Array, env):
	var v_g_125 = null
	v_g_125 = J.arg(a, 0)
	return J.gp(J.gp(J.G.get("GY_SPOTS"), J.gp(v_g_125, "spot")), "row")

func _f19(this_, a: Array, env):
	var v_g_126 = null
	v_g_126 = J.arg(a, 0)
	return J.gp(J.gp(J.G.get("GY_SPOTS"), J.gp(v_g_126, "spot")), "side")

func _f20(this_, a: Array, env):
	var v_g_131 = null
	v_g_131 = J.arg(a, 0)
	return (not J.seq(v_g_131, env["me"]))

func _f21(this_, a: Array, env):
	var v_g_138 = null
	v_g_138 = J.arg(a, 0)
	return J.seq(J.gp(v_g_138, "spot"), "D")

func _f23(this_, a: Array, env):
	var v_x_148 = null
	v_x_148 = J.arg(a, 0)
	return (not J.t(v_x_148))

func _f22(this_, a: Array, env):
	var v_c_143 = null; var v_ok_144 = null; var v_g_145 = null; var v_h_146 = null; var v_asg_147 = null
	v_c_143 = J.arg(a, 0)
	v_ok_144 = []
	v_g_145 = 0.0
	while true:
		if not J.cmp(v_g_145, J.len(env["graves"]), "<"): break
		v_h_146 = 0.0
		while true:
			if not J.cmp(v_h_146, J.len(env["graves"]), "<"): break
			var _t42 = J.leq(J.gp(v_c_143, "j"), null)
			if (J.cmp(v_h_146, 0.0, ">") if _t42 else _t42):
				break
			var _t43 = (not J.leq(J.gp(v_c_143, "j"), null))
			if (J.seq(v_g_145, v_h_146) if _t43 else _t43):
				v_h_146 = J.num(v_h_146) + 1.0
				continue
			v_asg_147 = []
			var _t44 = J.gp(v_c_143, "who")
			J.sp(v_asg_147, _t44, v_g_145)
			if (not J.leq(J.gp(v_c_143, "j"), null)):
				var _t45 = J.gp(v_c_143, "j")
				J.sp(v_asg_147, _t45, v_h_146)
			J.mc(v_ok_144, "push", [J.mc(env["this"], "holds", [v_c_143, v_asg_147, env["graves"]])])
			v_h_146 = J.num(v_h_146) + 1.0
		v_g_145 = J.num(v_g_145) + 1.0
	return J.mc(v_ok_144, "some", [Callable(self, "_f23").bind(env)])

func _f25(this_, a: Array, env):
	var v___150 = null; var v_g_151 = null; var v_asg_152 = null
	v___150 = J.arg(a, 0)
	v_g_151 = J.arg(a, 1)
	v_asg_152 = []
	var _t46 = J.gp(env["c"], "who")
	J.sp(v_asg_152, _t46, v_g_151)
	return J.mc(env["__p"]["this"], "holds", [env["c"], v_asg_152, env["__p"]["graves"]])

func _f24(this_, a: Array, env):
	var _s56 = {"__p": env, "c": null}
	_s56["c"] = J.arg(a, 0)
	var _t47 = J.leq(J.gp(_s56["c"], "j"), null)
	return (J.seq(J.len(J.mc(_s56["__p"]["graves"], "filter", [Callable(self, "_f25").bind(_s56)])), 1.0) if _t47 else _t47)

func _f26(this_, a: Array, env):
	var v_arr_153 = null; var v_by_154 = null; var v_ts_155 = null; var v_s_156 = null; var v_x_157 = null; var v_l_158 = null; var v_c_159 = null; var v_t_160 = null; var v_t_161 = null
	v_arr_153 = J.arg(a, 0)
	v_by_154 = {}
	for _t48 in J.iter(v_arr_153):
		v_c_159 = _t48
		var _t49 = J.gp(v_c_159, "t")
		var _t50 = J.gp(v_by_154, J.gp(v_c_159, "t"))
		var _t51 = (_t50 if J.t(_t50) else [])
		J.sp(v_by_154, _t49, _t51)
		J.mc(_t51, "push", [v_c_159])
	v_ts_155 = J.S_Object_("keys", [v_by_154])
	v_s_156 = 0.0
	for _t52 in J.iter(v_ts_155):
		v_t_160 = _t52
		var _t53 = J.add(v_s_156, J.gp(env["W"], v_t_160))
		v_s_156 = _t53
	v_x_157 = J.mul(J.cl(env["r"], null, []), v_s_156)
	for _t54 in J.iter(v_ts_155):
		v_t_161 = _t54
		var _t55 = J.sub(v_x_157, J.gp(env["W"], v_t_161))
		v_x_157 = _t55
		if J.cmp(v_x_157, 0.0, "<="):
			return J.gp(J.gp(v_by_154, v_t_161), floor(J.num(J.mul(J.cl(env["r"], null, []), J.len(J.gp(v_by_154, v_t_161))))))
	v_l_158 = J.gp(v_by_154, J.gp(v_ts_155, (J.len(v_ts_155) - 1.0)))
	return J.gp(v_l_158, floor(J.num(J.mul(J.cl(env["r"], null, []), J.len(v_l_158)))))

func _f27(this_, a: Array, env):
	var v_c_163 = null
	v_c_163 = J.arg(a, 0)
	return J.seq(J.gp(v_c_163, "who"), env["i"])

func _f28(this_, a: Array, env):
	var v_c_164 = null
	v_c_164 = J.arg(a, 0)
	return J.S_JSON_("stringify", [[J.gp(v_c_164, "t"), J.gp(v_c_164, "who"), J.gp(v_c_164, "j"), J.gp(v_c_164, "v")]])

func _f29(this_, a: Array, env):
	var v_c_165 = null; var v_a_166 = null; var v_b_167 = null
	v_c_165 = J.arg(a, 0)
	v_a_166 = J.gp(v_c_165, "who")
	v_b_167 = J.gp(v_c_165, "j")
	var _t56 = J.gp(v_c_165, "t")
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
			return J.S_JSON_("stringify", [["job", v_a_166, J.gp(v_c_165, "v")]])
		if _t57 <= 1 and _t57 >= 0:
			return J.S_JSON_("stringify", [["job", v_a_166, J.gp(v_c_165, "v")]])
		if _t57 <= 2 and _t57 >= 0:
			return J.S_JSON_("stringify", [["job", v_b_167, J.gp(v_c_165, "v")]])
		if _t57 <= 3 and _t57 >= 0:
			return J.S_JSON_("stringify", [["row=", J.min_([v_a_166, v_b_167]), J.max_([v_a_166, v_b_167])]])
		if _t57 <= 4 and _t57 >= 0:
			return J.S_JSON_("stringify", [["died", (v_a_166 if J.seq(J.gp(v_c_165, "v"), "early") else v_b_167), (v_b_167 if J.seq(J.gp(v_c_165, "v"), "early") else v_a_166)]])
		if _t57 <= 5 and _t57 >= 0:
			return J.S_JSON_("stringify", [(["above", v_a_166, v_b_167] if J.seq(J.gp(v_c_165, "v"), "up") else (["above", v_b_167, v_a_166] if J.seq(J.gp(v_c_165, "v"), "down") else (["leftof", v_a_166, v_b_167] if J.seq(J.gp(v_c_165, "v"), "left") else ["leftof", v_b_167, v_a_166])))])
		if _t57 <= 6 and _t57 >= 0:
			return J.S_JSON_("stringify", [[J.gp(v_c_165, "t"), v_a_166, J.gp(v_c_165, "v")]])
		break

func _f30(this_, a: Array, env):
	var v_c_168 = null
	v_c_168 = J.arg(a, 0)
	J.mc(env["chosen"], "push", [v_c_168])
	var _t59 = env["key"]
	J.mc(env["has"], "add", [J.cl(_t59, null, [v_c_168])])
	var _t60 = env["sig"]
	J.mc(env["said"], "add", [J.cl(_t60, null, [v_c_168])])
	var _t61 = env["isDirect"]
	if J.t(J.cl(_t61, null, [v_c_168])):
		env["nDirect"] = J.num(env["nDirect"]) + 1.0

func _f32(this_, a: Array, env):
	var v_c_170 = null
	v_c_170 = J.arg(a, 0)
	var _t63 = env["key"]
	var _t65 = (not J.t(J.mc(env["has"], "has", [J.cl(_t63, null, [v_c_170])])))
	if J.t(_t65):
		var _t64 = env["sig"]
		_t65 = (not J.t(J.mc(env["said"], "has", [J.cl(_t64, null, [v_c_170])])))
	var _t68 = _t65
	if J.t(_t68):
		var _t66 = env["isDirect"]
		var _t67 = (not J.t(J.cl(_t66, null, [v_c_170])))
		_t68 = (_t67 if _t67 else J.cmp(env["nDirect"], J.gp(env["L"], "direct"), "<"))
	return _t68

func _f31(this_, a: Array, env):
	var v_i_169 = null
	v_i_169 = J.arg(a, 0)
	var _t62 = J.gp(env["per"], v_i_169)
	return J.mc(_t62, "filter", [Callable(self, "_f32").bind(env)])

func _f33(this_, a: Array, env):
	var v_c_178 = null
	v_c_178 = J.arg(a, 0)
	return J.seq(J.gp(v_c_178, "who"), env["i"])

func _f34(this_, a: Array, env):
	var v_x_185 = null
	v_x_185 = J.arg(a, 0)
	return J.seq(J.gp(v_x_185, "who"), J.gp(env["c"], "who"))

func _f35(this_, a: Array, env):
	var v_x_186 = null
	v_x_186 = J.arg(a, 0)
	return (not J.seq(v_x_186, env["c"]))

func _f36(this_, a: Array, env):
	var v_c_187 = null
	v_c_187 = J.arg(a, 0)
	return (not J.leq(J.gp(v_c_187, "j"), null))

func _f37(this_, a: Array, env):
	var v_c_191 = null
	v_c_191 = J.arg(a, 0)
	return J.seq(J.gp(v_c_191, "who"), env["i"])

func _f38(this_, a: Array, env):
	var v_c_192 = null; var v_t_193 = null; var v_k_194 = null
	v_c_192 = J.arg(a, 0)
	v_t_193 = null
	v_k_194 = 0.0
	var _t77 = true
	while true:
		if not _t77:
			var _t79 = J.mc(env["__p"]["lines"], "has", [v_t_193])
			if J.t(_t79):
				var _t78 = J.num(v_k_194)
				v_k_194 = _t78 + 1.0
				_t79 = (_t78 < 8.0)
			if not J.t(_t79): break
		_t77 = false
		var _t80 = J.mc(env["__p"]["this"], "text", [v_c_192, env["__p"]["r"]])
		v_t_193 = _t80
	return v_t_193

func _f39(this_, a: Array, env):
	var v_t_195 = null
	v_t_195 = J.arg(a, 0)
	return J.mc(env["__p"]["lines"], "has", [v_t_195])

func _f40(this_, a: Array, env):
	var v_t_196 = null
	v_t_196 = J.arg(a, 0)
	return J.mc(env["__p"]["lines"], "add", [v_t_196])

func _f41(this_, a: Array, env):
	var v_g_197 = null; var v_i_198 = null
	v_g_197 = J.arg(a, 0)
	v_i_198 = J.arg(a, 1)
	return (not J.seq(v_g_197, J.gp(env["truth"], v_i_198)))

func _f11(this_, a: Array, env):
	var v_pickN_79 = null; var v_spots_80 = null; var v_n_87 = null; var v_add_90 = null; var v_usedRows_91 = null; var v_usedSides_92 = null; var v_useful_93 = null; var v_wpick_96 = null; var v_take_104 = null; var v_avail_105 = null; var v_sols_106 = null; var v_guard_107 = null; var v_souls_109 = null; var v_sol_110 = null; var v_i_127 = null; var v_others_129 = null; var v_sp_130 = null; var v_o_132 = null; var v_q_133 = null; var v_o_134 = null; var v_q_135 = null; var v_rw_136 = null; var v_sd_137 = null; var v_j_139 = null; var v_v_140 = null; var v_v_141 = null; var v_o_142 = null; var v_i_171 = null; var v_k_172 = null; var v_a_173 = null; var v_cand_174 = null; var v_best_175 = null; var v_bs_176 = null; var v_c_179 = null; var v_c_180 = null; var v_s_181 = null; var v_sc_182 = null; var v_rest_184 = null; var v_mine_189 = null; var v_ls_190 = null
	var _s23 = {"__p": env, "this": null, "L": null, "r": null, "sn": null, "gv": null, "jobs": null, "offs": null, "deaths": null, "graves": null, "truth": null, "pool": null, "isDirect": null, "W": null, "per": null, "chosen": null, "key": null, "has": null, "nDirect": null, "sig": null, "said": null, "lines": null}
	_s23["this"] = this_
	_s23["L"] = J.arg(a, 0)
	_s23["r"] = J.arg(a, 1)
	v_pickN_79 = Callable(self, "_f12").bind(_s23)
	v_spots_80 = J.mc(J.cl(v_pickN_79, null, [J.S_Object_("keys", [J.G.get("GY_SPOTS")]), J.gp(_s23["L"], "g")]), "sort", [])
	_s23["sn"] = J.cl(v_pickN_79, null, [J.G.get("GY_SURN"), J.gp(_s23["L"], "g")])
	_s23["gv"] = J.cl(v_pickN_79, null, [J.G.get("GY_GIVEN"), J.gp(_s23["L"], "g")])
	_s23["jobs"] = J.cl(v_pickN_79, null, [J.S_Object_("keys", [J.G.get("GY_JOBS")]), J.gp(_s23["L"], "g")])
	_s23["offs"] = J.cl(v_pickN_79, null, [J.G.get("GY_OFFERS"), J.gp(_s23["L"], "g")])
	_s23["deaths"] = []
	while true:
		if not J.cmp(J.len(_s23["deaths"]), J.gp(_s23["L"], "g"), "<"): break
		var _s25 = {"__p": _s23, "d": null}
		_s25["d"] = (1986.0 + floor(J.num(J.mul(J.cl(_s25["__p"]["r"], null, []), 39.0))))
		if J.t(J.mc(_s25["__p"]["deaths"], "every", [Callable(self, "_f13").bind(_s25)])):
			J.mc(_s25["__p"]["deaths"], "push", [_s25["d"]])
	_s23["graves"] = J.mc(v_spots_80, "map", [Callable(self, "_f14").bind(_s23)])
	if (not J.seq(J.gp(J.new_("Set", [J.mc(_s23["graves"], "map", [Callable(self, "_f15").bind(_s23)])]), "size"), J.len(_s23["graves"]))):
		return null
	v_n_87 = J.gp(_s23["L"], "n")
	var _t31 = J.mc(_s23["this"], "shuffle", [J.mc(_s23["graves"], "map", [Callable(self, "_f16").bind(_s23)]), _s23["r"]])
	_s23["truth"] = J.mc(_t31, "slice", [0.0, v_n_87])
	_s23["pool"] = []
	v_add_90 = Callable(self, "_f17").bind(_s23)
	v_usedRows_91 = J.new_("Set", [J.mc(_s23["graves"], "map", [Callable(self, "_f18").bind(_s23)])])
	v_usedSides_92 = J.new_("Set", [J.mc(_s23["graves"], "map", [Callable(self, "_f19").bind(_s23)])])
	v_i_127 = 0.0
	while true:
		if not J.cmp(v_i_127, v_n_87, "<"): break
		var _s34 = {"__p": _s23, "me": null}
		_s34["me"] = J.gp(_s34["__p"]["graves"], J.gp(_s34["__p"]["truth"], v_i_127))
		v_others_129 = J.mc(_s34["__p"]["graves"], "filter", [Callable(self, "_f20").bind(_s34)])
		v_sp_130 = J.gp(J.G.get("GY_SPOTS"), J.gp(_s34["me"], "spot"))
		J.cl(v_add_90, null, [{"t": "job_is", "who": v_i_127, "v": J.gp(_s34["me"], "job")}])
		for _t32 in J.iter(v_others_129):
			v_o_132 = _t32
			J.cl(v_add_90, null, [{"t": "job_not", "who": v_i_127, "v": J.gp(v_o_132, "job")}])
			J.cl(v_add_90, null, [{"t": "off_not", "who": v_i_127, "v": J.gp(v_o_132, "off")}])
		J.cl(v_add_90, null, [{"t": "off_is", "who": v_i_127, "v": J.gp(_s34["me"], "off")}])
		for _t33 in J.iter(J.gp(_s34["me"], "keys")):
			v_q_133 = _t33
			J.cl(v_add_90, null, [{"t": "quote", "who": v_i_127, "v": v_q_133}])
		for _t34 in J.iter(v_others_129):
			v_o_134 = _t34
			for _t35 in J.iter(J.gp(v_o_134, "keys")):
				v_q_135 = _t35
				var _t36 = J.gp(_s34["me"], "ep")
				if (not J.t(J.mc(_t36, "includes", [v_q_135]))):
					J.cl(v_add_90, null, [{"t": "quote_not", "who": v_i_127, "v": v_q_135}])
		J.cl(v_add_90, null, [{"t": "age", "who": v_i_127, "v": floor(J.num(J.div(J.sub(J.gp(_s34["me"], "death"), J.gp(_s34["me"], "birth")), 10.0)))}])
		J.cl(v_add_90, null, [{"t": "surname", "who": v_i_127, "v": J.gp(J.gp(_s34["me"], "name"), 0.0)}])
		for _t37 in J.iter(v_usedRows_91):
			v_rw_136 = _t37
			if J.seq(v_rw_136, J.gp(v_sp_130, "row")):
				J.cl(v_add_90, null, [{"t": "row_is", "who": v_i_127, "v": v_rw_136}])
			else:
				J.cl(v_add_90, null, [{"t": "row_not", "who": v_i_127, "v": v_rw_136}])
		for _t38 in J.iter(v_usedSides_92):
			v_sd_137 = _t38
			if J.seq(v_sd_137, 1.0):
				continue
			if J.seq(v_sd_137, J.gp(v_sp_130, "side")):
				J.cl(v_add_90, null, [{"t": "side_is", "who": v_i_127, "v": v_sd_137}])
			else:
				J.cl(v_add_90, null, [{"t": "side_not", "who": v_i_127, "v": v_sd_137}])
		if J.t(J.mc(_s34["__p"]["graves"], "some", [Callable(self, "_f21").bind(_s34)])):
			J.cl(v_add_90, null, [{"t": ("tree" if J.seq(J.gp(_s34["me"], "spot"), "D") else "tree_not"), "who": v_i_127}])
		v_j_139 = 0.0
		while true:
			if not J.cmp(v_j_139, v_n_87, "<"): break
			if J.seq(v_j_139, v_i_127):
				v_j_139 = J.num(v_j_139) + 1.0
				continue
			for _t39 in J.iter(["up", "down", "left", "right"]):
				v_v_140 = _t39
				J.cl(v_add_90, null, [{"t": "rel", "who": v_i_127, "j": v_j_139, "v": v_v_140}])
			J.cl(v_add_90, null, [{"t": "same_row", "who": v_i_127, "j": v_j_139}])
			for _t40 in J.iter(["early", "late"]):
				v_v_141 = _t40
				J.cl(v_add_90, null, [{"t": "died", "who": v_i_127, "j": v_j_139, "v": v_v_141}])
			for _t41 in J.iter(_s34["__p"]["graves"]):
				v_o_142 = _t41
				if (not J.seq(v_o_142, J.gp(_s34["__p"]["graves"], J.gp(_s34["__p"]["truth"], v_j_139)))):
					J.cl(v_add_90, null, [{"t": "ojob_not", "who": v_i_127, "j": v_j_139, "v": J.gp(v_o_142, "job")}])
			v_j_139 = J.num(v_j_139) + 1.0
		v_i_127 = J.num(v_i_127) + 1.0
	v_useful_93 = J.mc(_s23["pool"], "filter", [Callable(self, "_f22").bind(_s23)])
	_s23["isDirect"] = Callable(self, "_f24").bind(_s23)
	_s23["W"] = {"job_is": 1.0, "job_not": 3.0, "ojob_not": 2.0, "off_is": 1.0, "off_not": 2.0, "quote": 3.0, "quote_not": 2.0, "age": 3.0, "surname": 1.0, "row_is": 2.0, "row_not": 2.0, "side_is": 2.0, "side_not": 2.0, "tree": 1.0, "tree_not": 2.0, "rel": 5.0, "same_row": 4.0, "died": 4.0}
	if J.seq(J.gp(_s23["L"], "n"), 3.0):
		J.S_Object_("assign", [_s23["W"], {"rel": 2.0, "died": 2.0, "same_row": 1.0, "ojob_not": 1.0, "quote": 4.0, "age": 3.0, "job_not": 3.0, "off_not": 3.0}])
	v_wpick_96 = Callable(self, "_f26").bind(_s23)
	_s23["per"] = []
	var _s63 = {"__p": _s23, "i": null}
	_s63["i"] = 0.0
	while true:
		_s63 = _s63.duplicate()
		if not J.cmp(_s63["i"], v_n_87, "<"): break
		J.mc(_s63["__p"]["per"], "push", [J.mc(v_useful_93, "filter", [Callable(self, "_f27").bind(_s63)])])
		_s63["i"] = J.num(_s63["i"]) + 1.0
	_s23["chosen"] = []
	_s23["key"] = Callable(self, "_f28").bind(_s23)
	_s23["has"] = J.new_("Set", [])
	_s23["nDirect"] = 0.0
	_s23["sig"] = Callable(self, "_f29").bind(_s23)
	_s23["said"] = J.new_("Set", [])
	v_take_104 = Callable(self, "_f30").bind(_s23)
	v_avail_105 = Callable(self, "_f31").bind(_s23)
	v_i_171 = 0.0
	while true:
		if not J.cmp(v_i_171, v_n_87, "<"): break
		v_k_172 = 0.0
		while true:
			if not J.cmp(v_k_172, 2.0, "<"): break
			v_a_173 = J.cl(v_avail_105, null, [v_i_171])
			if (not J.t(J.len(v_a_173))):
				return null
			J.cl(v_take_104, null, [J.cl(v_wpick_96, null, [v_a_173])])
			v_k_172 = J.num(v_k_172) + 1.0
		v_i_171 = J.num(v_i_171) + 1.0
	v_sols_106 = J.mc(_s23["this"], "solve", [v_n_87, _s23["graves"], _s23["chosen"], 3.0])
	v_guard_107 = 0.0
	while true:
		var _t70 = (J.len(v_sols_106) > 1.0)
		if J.t(_t70):
			var _t69 = J.num(v_guard_107)
			v_guard_107 = _t69 + 1.0
			_t70 = (_t69 < 20.0)
		if not _t70: break
		v_cand_174 = []
		var _s75 = {"__p": _s23, "i": null}
		_s75["i"] = 0.0
		while true:
			_s75 = _s75.duplicate()
			if not J.cmp(_s75["i"], v_n_87, "<"): break
			if (J.len(J.mc(_s75["__p"]["chosen"], "filter", [Callable(self, "_f33").bind(_s75)])) < 3.0):
				for _t71 in J.iter(J.cl(v_avail_105, null, [_s75["i"]])):
					v_c_179 = _t71
					J.mc(v_cand_174, "push", [v_c_179])
			_s75["i"] = J.num(_s75["i"]) + 1.0
		if (not J.t(J.len(v_cand_174))):
			return null
		J.mc(_s23["this"], "shuffle", [v_cand_174, _s23["r"]])
		v_best_175 = null
		v_bs_176 = 1000000000.0
		for _t72 in J.iter(J.mc(v_cand_174, "slice", [0.0, 24.0])):
			v_c_180 = _t72
			v_s_181 = J.len(J.mc(_s23["this"], "solve", [v_n_87, _s23["graves"], J.mc(_s23["chosen"], "concat", [[v_c_180]]), 0.0]))
			v_sc_182 = J.sub(J.mul(v_s_181, 10.0), J.gp(_s23["W"], J.gp(v_c_180, "t")))
			var _t73 = J.cmp(v_s_181, 1.0, ">=")
			if (J.cmp(v_sc_182, v_bs_176, "<") if _t73 else _t73):
				v_bs_176 = v_sc_182
				v_best_175 = v_c_180
		J.cl(v_take_104, null, [v_best_175])
		var _t74 = J.mc(_s23["this"], "solve", [v_n_87, _s23["graves"], _s23["chosen"], 3.0])
		v_sols_106 = _t74
	if (not J.seq(J.len(v_sols_106), 1.0)):
		return null
	for _t75 in J.iter(J.mc(_s23["this"], "shuffle", [J.mc(_s23["chosen"], "slice", []), _s23["r"]])):
		var _s81 = {"__p": _s23, "c": null}
		_s81["c"] = _t75
		if (J.len(J.mc(_s81["__p"]["chosen"], "filter", [Callable(self, "_f34").bind(_s81)])) <= 2.0):
			continue
		v_rest_184 = J.mc(_s81["__p"]["chosen"], "filter", [Callable(self, "_f35").bind(_s81)])
		if J.seq(J.len(J.mc(_s81["__p"]["this"], "solve", [v_n_87, _s81["__p"]["graves"], v_rest_184, 2.0])), 1.0):
			J.mc(_s81["__p"]["chosen"], "splice", [J.mc(_s81["__p"]["chosen"], "indexOf", [_s81["c"]]), 1.0])
	var _t76 = J.cmp(J.gp(_s23["L"], "n"), 4.0, ">=")
	if ((not J.t(J.mc(_s23["chosen"], "some", [Callable(self, "_f36").bind(_s23)]))) if _t76 else _t76):
		return null
	_s23["lines"] = J.new_("Set", [])
	v_souls_109 = []
	var _s86 = {"__p": _s23, "i": null}
	_s86["i"] = 0.0
	while true:
		_s86 = _s86.duplicate()
		if not J.cmp(_s86["i"], v_n_87, "<"): break
		v_mine_189 = J.mc(_s86["__p"]["this"], "shuffle", [J.mc(_s86["__p"]["chosen"], "filter", [Callable(self, "_f37").bind(_s86)]), _s86["__p"]["r"]])
		v_ls_190 = J.mc(v_mine_189, "map", [Callable(self, "_f38").bind(_s86)])
		if J.t(J.mc(v_ls_190, "some", [Callable(self, "_f39").bind(_s86)])):
			return null
		J.mc(v_ls_190, "forEach", [Callable(self, "_f40").bind(_s86)])
		J.mc(v_souls_109, "push", [{"tag": J.gp(J.G.get("GY_TAGS"), _s86["i"]), "grave": J.gp(_s86["__p"]["truth"], _s86["i"]), "clues": v_mine_189, "lines": v_ls_190}])
		_s86["i"] = J.num(_s86["i"]) + 1.0
	v_sol_110 = J.mc(_s23["this"], "solve", [v_n_87, _s23["graves"], _s23["chosen"], 0.0])
	var _t82 = (not J.seq(J.len(v_sol_110), 1.0))
	if not J.t(_t82):
		var _t81 = J.gp(v_sol_110, 0.0)
		_t82 = J.mc(_t81, "some", [Callable(self, "_f41").bind(_s23)])
	if J.t(_t82):
		return null
	return {"graves": _s23["graves"], "souls": v_souls_109}

func _f42(this_, a: Array, env):
	var v_g_199 = null
	v_g_199 = J.arg(a, 0)
	return {"spot": J.gp(v_g_199, "spot"), "name": J.gp(v_g_199, "name"), "years": (J.str(J.gp(v_g_199, "birth")) + " – " + J.str(J.gp(v_g_199, "death"))), "job": J.gp(v_g_199, "job"), "ep": J.gp(v_g_199, "ep"), "off": J.gp(v_g_199, "off")}

func _f43(this_, a: Array, env):
	var v_c_200 = null; var v_k_201 = null; var v_x_202 = null; var v_y_203 = null; var v_s_204 = null; var v_o_205 = null
	v_c_200 = J.arg(a, 0)
	v_k_201 = J.arg(a, 1)
	v_x_202 = J.arg(a, 2)
	v_y_203 = J.arg(a, 3)
	v_s_204 = J.arg(a, 4)
	v_o_205 = J.arg(a, 5)
	var _t85 = J.gp(J.G.get("Graveyard"), "_nat")
	var _t88 = null
	if J.t(((not J.seq(J.typeof_(J.G.get("__nat_drawChar")), "undefined")) if J.t(_t85) else _t85)):
		var _t86 = J.G.get("__nat_drawChar")
		_t88 = J.cl(_t86, null, [v_c_200, v_k_201, v_x_202, v_y_203, v_s_204, (v_o_205 if J.t(v_o_205) else {})])
	else:
		var _t87 = J.G.get("ART")
		_t88 = J.mc(_t87, "drawChar", [v_c_200, v_k_201, v_x_202, v_y_203, v_s_204, v_o_205])
	return _t88

func _f44(this_, a: Array, env):
	J.mc(this_, "draw", [J.gp(this_, "t")])

func _f45(this_, a: Array, env):
	var v_y_210 = null
	var _t89 = (not J.t(J.gp(J.G.get("S"), "yard")))
	if (_t89 if _t89 else (not J.seq(J.typeof_(J.gp(J.G.get("S"), "yard")), "object"))):
		var _t90 = J.G.get("S")
		var _t91 = {}
		J.sp(_t90, "yard", _t91)
	v_y_210 = J.gp(J.G.get("S"), "yard")
	if (not J.cmp(J.gp(v_y_210, "night"), 1.0, ">=")):
		J.sp(v_y_210, "night", 1.0)
	var _t92 = floor(J.num(J.gp(v_y_210, "night")))
	J.sp(v_y_210, "night", _t92)
	if (not J.cmp(J.gp(v_y_210, "best"), 0.0, ">=")):
		J.sp(v_y_210, "best", 0.0)
	if (not J.t(J.S_Array_("isArray", [J.gp(v_y_210, "rested")]))):
		var _t93 = []
		J.sp(v_y_210, "rested", _t93)
	if (not J.cmp(J.gp(v_y_210, "seed"), 0.0, ">")):
		var _t94 = (1.0 + floor(J.num((randf() * 2000000000.0))))
		J.sp(v_y_210, "seed", _t94)
	return v_y_210

func _f47(this_, a: Array, env):
	var v_s_218 = null; var v_i_219 = null
	v_s_218 = J.arg(a, 0)
	v_i_219 = J.arg(a, 1)
	return {"i": v_i_219, "tag": J.gp(v_s_218, "tag"), "place": null, "x": 0.0, "y": 0.0, "ph": (randf() * 6.0), "rx": null, "col": J.gp(J.G.get("GY_COLORS"), v_i_219), "a": J.gp(J.G.get("GY_ALPHA"), v_i_219)}

func _f48(this_, a: Array, env):
	var v_g_221 = null; var v_gi_222 = null; var v_r_223 = null; var v_st_224 = null; var v_k_225 = null
	v_g_221 = J.arg(a, 0)
	v_gi_222 = J.arg(a, 1)
	v_r_223 = J.mc(J.G.get("GY_GEN"), "rng", [J.add(J.gp(J.gp(env["this"], "p"), "seed"), J.mul(v_gi_222, 101.0))])
	v_st_224 = []
	v_k_225 = 0.0
	while true:
		if not J.cmp(v_k_225, 26.0, "<"): break
		J.mc(v_st_224, "push", [[J.cl(v_r_223, null, []), J.cl(v_r_223, null, []), (J.sub(J.cl(v_r_223, null, []), 0.5) * 0.5), J.cl(v_r_223, null, [])]])
		v_k_225 = J.num(v_k_225) + 1.0
	return v_st_224

func _f49(this_, a: Array, env):
	if (not J.seq(J.gp(env["this"], "phase"), "play")):
		return null
	var _t111 = J.G.get("confirmInline")
	var _t112 = J.G.get("$")
	if (not J.t(J.cl(_t111, null, [J.cl(_t112, null, ["#gy-quit"]), "確定收工？"]))):
		return null
	J.mc(env["this"], "close", [])

func _f50(this_, a: Array, env):
	if J.seq(J.gp(J.gp(env["this"], "view"), "k"), "rules"):
		var _t116 = env["this"]
		var _t117 = ({"k": "soul", "i": J.gp(env["this"], "sel")} if (not J.leq(J.gp(env["this"], "sel"), null)) else {"k": "soul", "i": 0.0})
		J.sp(_t116, "view", _t117)
		var _t118 = env["this"]
		J.sp(_t118, "guide", false)
	else:
		var _t119 = env["this"]
		var _t120 = {"k": "rules"}
		J.sp(_t119, "view", _t120)
		var _t121 = env["this"]
		J.sp(_t121, "guide", true)
	J.mc(env["this"], "renderPanel", [])

func _f52(this_, a: Array, env):
	var v_s_226 = null
	v_s_226 = J.arg(a, 0)
	J.sp(v_s_226, "place", null)
	return null

func _f51(this_, a: Array, env):
	if (not J.seq(J.gp(env["this"], "phase"), "play")):
		return null
	var _t125 = J.gp(env["this"], "souls")
	J.mc(_t125, "forEach", [Callable(self, "_f52").bind(env)])
	var _t126 = env["this"]
	J.sp(_t126, "sel", null)
	J.mc(env["this"], "renderPanel", [])

func _f53(this_, a: Array, env):
	return J.mc(env["this"], "submit", [])

func _f54(this_, a: Array, env):
	var v_e_227 = null
	v_e_227 = J.arg(a, 0)
	return J.mc(env["this"], "down", [v_e_227])

func _f55(this_, a: Array, env):
	var v_e_228 = null
	v_e_228 = J.arg(a, 0)
	return J.mc(env["this"], "move", [v_e_228])

func _f56(this_, a: Array, env):
	var v_e_229 = null
	v_e_229 = J.arg(a, 0)
	return J.mc(env["this"], "up", [v_e_229])

func _f57(this_, a: Array, env):
	if J.t(J.gp(env["this"], "drag")):
		var _t132 = env["this"]
		J.sp(_t132, "drag", null)

func _f58(this_, a: Array, env):
	if J.t(J.gp(env["this"], "active")):
		J.mc(env["this"], "resize", [])

func _f59(this_, a: Array, env):
	var _t137 = J.gp(env["this"], "active")
	if J.t(_t137):
		var _t136 = J.G.get("$")
		_t137 = J.cl(_t136, null, ["#gy-stage"])
	if J.t(_t137):
		J.mc(env["this"], "resize", [])

func _f60(this_, a: Array, env):
	var v_now_230 = null
	v_now_230 = J.arg(a, 0)
	return J.mc(env["this"], "frame", [v_now_230, env["tok"]])

func _f46(this_, a: Array, env):
	var v_y_213 = null; var v_n_214 = null; var v_el_215 = null; var v_cv_216 = null; var v_i_220 = null
	var _s98 = {"__p": env, "this": null, "tok": null}
	_s98["this"] = this_
	v_y_213 = J.mc(_s98["this"], "ensure", [])
	J.cl(J.G.get("save"), null, [])
	var _t95 = _s98["this"]
	var _t96 = J.mc(J.G.get("GY_GEN"), "gen", [J.gp(v_y_213, "night"), J.gp(v_y_213, "seed")])
	J.sp(_t95, "p", _t96)
	v_n_214 = J.len(J.gp(J.gp(_s98["this"], "p"), "souls"))
	J.S_Object_("assign", [_s98["this"], {"active": true, "t": 0.0, "tries": 0.0, "phase": "play", "sel": null, "view": {"k": "soul", "i": 0.0}, "drag": null, "parts": [], "crows": [], "crowT": 4.0, "bub": null, "restT": 0.0, "guide": false}])
	var _t97 = _s98["this"]
	var _t98 = J.gp(J.gp(_s98["this"], "p"), "souls")
	var _t99 = J.mc(_t98, "map", [Callable(self, "_f47").bind(_s98)])
	J.sp(_t97, "souls", _t99)
	var _t100 = _s98["this"]
	var _t101 = []
	J.sp(_t100, "wisps", _t101)
	v_i_220 = 0.0
	while true:
		if not J.cmp(v_i_220, 7.0, "<"): break
		var _t102 = J.gp(_s98["this"], "wisps")
		J.mc(_t102, "push", [{"x": randf(), "y": (0.35 + (randf() * 0.55)), "ph": (randf() * 9.0), "sp": (0.3 + (randf() * 0.5))}])
		v_i_220 = J.num(v_i_220) + 1.0
	var _t103 = _s98["this"]
	var _t104 = J.gp(J.gp(_s98["this"], "p"), "graves")
	var _t105 = J.mc(_t104, "map", [Callable(self, "_f48").bind(_s98)])
	J.sp(_t103, "stones", _t105)
	var _t106 = J.G.get("$")
	v_el_215 = J.cl(_t106, null, ["#gyard"])
	var _t107 = J.gp(v_el_215, "classList")
	J.mc(_t107, "add", ["on"])
	var _t108 = ("<div id=\"gy-top\"><button class=\"btn sm ghost\" id=\"gy-quit\">收工</button><b>亂葬崗・第 " + J.str(J.gp(v_y_213, "night")) + " 夜</b><span id=\"gy-tries\"></span><button class=\"btn sm\" id=\"gy-rule\">規矩</button></div>\n      <div id=\"gy-hint\"></div><div id=\"gy-stage\"><canvas id=\"gy-cvs\"></canvas></div>\n      <div id=\"gy-panel\"><div id=\"gy-chips\"></div><div id=\"gy-info\"></div><div class=\"gy-acts\"><button class=\"btn\" id=\"gy-reset\">全部退回</button><button class=\"btn gold\" id=\"gy-go\">送他們安息</button></div></div><div id=\"gy-end\"></div>")
	J.sp(v_el_215, "innerHTML", _t108)
	var _t109 = J.G.get("$")
	var _t110 = J.cl(_t109, null, ["#gy-quit"])
	var _t113 = Callable(self, "_f49").bind(_s98)
	J.sp(_t110, "onclick", _t113)
	var _t114 = J.G.get("$")
	var _t115 = J.cl(_t114, null, ["#gy-rule"])
	var _t122 = Callable(self, "_f50").bind(_s98)
	J.sp(_t115, "onclick", _t122)
	var _t123 = J.G.get("$")
	var _t124 = J.cl(_t123, null, ["#gy-reset"])
	var _t127 = Callable(self, "_f51").bind(_s98)
	J.sp(_t124, "onclick", _t127)
	var _t128 = J.G.get("$")
	var _t129 = J.cl(_t128, null, ["#gy-go"])
	var _t130 = Callable(self, "_f53").bind(_s98)
	J.sp(_t129, "onclick", _t130)
	var _t131 = J.G.get("$")
	v_cv_216 = J.cl(_t131, null, ["#gy-cvs"])
	J.mc(v_cv_216, "addEventListener", ["pointerdown", Callable(self, "_f54").bind(_s98)])
	J.mc(v_cv_216, "addEventListener", ["pointermove", Callable(self, "_f55").bind(_s98)])
	J.mc(v_cv_216, "addEventListener", ["pointerup", Callable(self, "_f56").bind(_s98)])
	J.mc(v_cv_216, "addEventListener", ["pointercancel", Callable(self, "_f57").bind(_s98)])
	if (not J.t(J.gp(_s98["this"], "_rs"))):
		var _t133 = _s98["this"]
		J.sp(_t133, "_rs", true)
		J.S_window_("addEventListener", ["resize", Callable(self, "_f58").bind(_s98)])
	J.mc(J.G.get("Sound"), "setMode", ["story"])
	J.mc(J.G.get("Sound"), "play", ["crow", (-0.6)])
	J.mc(_s98["this"], "renderPanel", [])
	J.mc(_s98["this"], "resize", [])
	var _t134 = (not J.t(J.gp(_s98["this"], "_ro")))
	if ((not J.seq(J.typeof_(J.G.get("ResizeObserver")), "undefined")) if _t134 else _t134):
		var _t135 = _s98["this"]
		var _t138 = J.construct(J.G.get("ResizeObserver"), [Callable(self, "_f59").bind(_s98)])
		J.sp(_t135, "_ro", _t138)
	if J.t(J.gp(_s98["this"], "_ro")):
		var _t139 = J.gp(_s98["this"], "_ro")
		var _t140 = J.G.get("$")
		J.mc(_t139, "observe", [J.cl(_t140, null, ["#gy-stage"])])
	if (not J.t(J.gp(v_y_213, "seen"))):
		J.sp(v_y_213, "seen", 1.0)
		J.cl(J.G.get("save"), null, [])
		J.mc(_s98["this"], "hint", ["點魂，聽他記得什麼；點墓碑，看碑文。把每個魂拖到自己的墳前（或先點魂再點墳）。方位怎麼算，按右上「規矩」。", 14.0])
	else:
		J.mc(_s98["this"], "hint", [("今晚 " + J.str(v_n_214) + " 個魂" + (("，" + J.str(J.len(J.gp(J.gp(_s98["this"], "p"), "graves"))) + " 座墳（有一座不是他們的）") if J.cmp(J.len(J.gp(J.gp(_s98["this"], "p"), "graves")), v_n_214, ">") else "") + "。"), 5.0])
	var _t141 = _s98["this"]
	var _t143 = (not J.seq(J.typeof_(J.G.get("__nat_mini")), "undefined"))
	if J.t(_t143):
		var _t142 = J.G.get("__nat_mini")
		_t143 = J.cl(_t142, null, [_s98["this"], "#gy-stage", "#gyard", "_nd", "", "#gy-panel"])
	J.sp(_t141, "_nat", _t143)
	var _t144 = _s98["this"]
	var _t145 = {}
	J.sp(_t144, "_tok", _t145)
	_s98["tok"] = _t145
	var _t146 = _s98["this"]
	var _t147 = J.S_performance_("now", [])
	J.sp(_t146, "last", _t147)
	J.F_requestAnimationFrame([Callable(self, "_f60").bind(_s98)])

func _f61(this_, a: Array, env):
	var v_el_233 = null
	var _t148 = this_
	J.sp(_t148, "active", false)
	var _t149 = this_
	J.sp(_t149, "_tok", null)
	var _t150 = J.gp(this_, "_nat")
	if J.t(((not J.seq(J.typeof_(J.G.get("__nat_miniEnd")), "undefined")) if J.t(_t150) else _t150)):
		var _t151 = J.G.get("__nat_miniEnd")
		J.cl(_t151, null, ["#gyard"])
		var _t152 = this_
		J.sp(_t152, "_nat", false)
	if J.t(J.gp(this_, "_ro")):
		J.mc(J.gp(this_, "_ro"), "disconnect", [])
	var _t153 = J.G.get("$")
	v_el_233 = J.cl(_t153, null, ["#gyard"])
	var _t154 = J.gp(v_el_233, "classList")
	J.mc(_t154, "remove", ["on"])
	J.sp(v_el_233, "innerHTML", "")
	J.mc(J.G.get("Sound"), "setMode", ["village"])
	J.mc(J.G.get("UI"), "refresh", [])

func _f63(this_, a: Array, env):
	var _t160 = J.gp(env["h"], "classList")
	return J.mc(_t160, "remove", ["on"])

func _f64(this_, a: Array, env):
	var _t163 = J.gp(env["h"], "classList")
	return J.mc(_t163, "remove", ["on"])

func _f62(this_, a: Array, env):
	var v_text_236 = null; var v_sec_237 = null
	var _s123 = {"__p": env, "h": null}
	v_text_236 = J.arg(a, 0)
	v_sec_237 = J.arg(a, 1)
	var _t155 = J.G.get("$")
	_s123["h"] = J.cl(_t155, null, ["#gy-hint"])
	if (not J.t(_s123["h"])):
		return null
	var _t156 = _s123["h"]
	var _t157 = ("<span>" + J.str(v_text_236) + "</span><button aria-label=\"關閉\">✕</button>")
	J.sp(_t156, "innerHTML", _t157)
	var _t158 = J.gp(_s123["h"], "classList")
	J.mc(_t158, "add", ["on"])
	var _t159 = J.mc(_s123["h"], "querySelector", ["button"])
	var _t161 = Callable(self, "_f63").bind(_s123)
	J.sp(_t159, "onclick", _t161)
	J.F_clearTimeout([J.gp(this_, "_ht")])
	var _t162 = this_
	var _t164 = J.F_setTimeout([Callable(self, "_f64").bind(_s123), J.mul((v_sec_237 if J.t(v_sec_237) else 6.0), 1000.0)])
	J.sp(_t162, "_ht", _t164)

func _f66(this_, a: Array, env):
	var v_r_244 = null
	var _t166 = J.G.get("__nat_miniSize")
	v_r_244 = J.cl(_t166, null, ["#gyard"])
	return {"width": J.gp(v_r_244, 0.0), "height": J.gp(v_r_244, 1.0)}

func _f65(this_, a: Array, env):
	var v_c_241 = null; var v_box_242 = null; var v_dpr_243 = null
	var _t165 = J.G.get("$")
	v_c_241 = J.cl(_t165, null, ["#gy-cvs"])
	var _t168 = null
	if J.t(J.gp(this_, "_nat")):
		_t168 = J.cl(Callable(self, "_f66").bind(env), null, [])
	else:
		var _t167 = J.G.get("$")
		_t168 = J.mc(J.cl(_t167, null, ["#gy-stage"]), "getBoundingClientRect", [])
	v_box_242 = _t168
	var _t171 = null
	if J.t(J.gp(this_, "_nat")):
		_t171 = 1.0
	else:
		var _t169 = J.gp(J.G.get("window"), "devicePixelRatio")
		var _t170 = J.gp(J.G.get("window"), "devicePixelRatio")
		_t171 = J.min_([2.0, (_t170 if J.t(_t170) else 1.0)])
	v_dpr_243 = _t171
	var _t172 = J.mul(J.gp(v_box_242, "width"), v_dpr_243)
	J.sp(v_c_241, "width", _t172)
	var _t173 = J.mul(J.gp(v_box_242, "height"), v_dpr_243)
	J.sp(v_c_241, "height", _t173)
	var _t174 = J.gp(v_c_241, "style")
	var _t175 = J.add(J.gp(v_box_242, "width"), "px")
	J.sp(_t174, "width", _t175)
	var _t176 = J.gp(v_c_241, "style")
	var _t177 = J.add(J.gp(v_box_242, "height"), "px")
	J.sp(_t176, "height", _t177)
	var _t178 = this_
	var _t179 = J.gp(v_box_242, "width")
	J.sp(_t178, "W", _t179)
	var _t180 = this_
	var _t181 = J.gp(v_box_242, "height")
	J.sp(_t180, "H", _t181)
	var _t182 = this_
	J.sp(_t182, "dpr", v_dpr_243)

func _f67(this_, a: Array, env):
	var v_img_247 = null; var v_iw_248 = null; var v_ih_249 = null; var v_W_250 = null; var v_H_251 = null; var v_s_252 = null
	v_img_247 = J.gp(J.G.get("SPR"), "bg_graveyard")
	var _t183 = (J.gp(v_img_247, "naturalWidth") if J.t(v_img_247) else v_img_247)
	v_iw_248 = (_t183 if J.t(_t183) else 768.0)
	var _t184 = (J.gp(v_img_247, "naturalHeight") if J.t(v_img_247) else v_img_247)
	v_ih_249 = (_t184 if J.t(_t184) else 1152.0)
	var _t185 = J.gp(this_, "W")
	v_W_250 = (_t185 if J.t(_t185) else 390.0)
	var _t186 = J.gp(this_, "H")
	v_H_251 = (_t186 if J.t(_t186) else 560.0)
	v_s_252 = J.max_([J.div(v_W_250, v_iw_248), J.div(v_H_251, v_ih_249)])
	if J.cmp((J.mul(v_ih_249, v_s_252) * 0.75), v_H_251, ">"):
		var _t187 = J.div(v_H_251, J.mul(v_ih_249, 0.75))
		v_s_252 = _t187
	return {"s": v_s_252, "iw": v_iw_248, "ih": v_ih_249, "ox": J.div(J.sub(v_W_250, J.mul(v_iw_248, v_s_252)), 2.0), "oy": J.sub(v_H_251, J.mul(v_ih_249, v_s_252))}

func _f68(this_, a: Array, env):
	var v_fx_255 = null; var v_fy_256 = null; var v_b_257 = null
	v_fx_255 = J.arg(a, 0)
	v_fy_256 = J.arg(a, 1)
	v_b_257 = J.mc(this_, "bgScale", [])
	return [J.add(J.mul(J.mul(v_fx_255, J.gp(v_b_257, "iw")), J.gp(v_b_257, "s")), J.gp(v_b_257, "ox")), J.add(J.mul(J.mul(v_fy_256, J.gp(v_b_257, "ih")), J.gp(v_b_257, "s")), J.gp(v_b_257, "oy"))]

func _f69(this_, a: Array, env):
	var v_b_260 = null
	v_b_260 = J.mc(this_, "bgScale", [])
	return J.div(J.mul(J.gp(v_b_260, "iw"), J.gp(v_b_260, "s")), 390.0)

func _f70(this_, a: Array, env):
	return J.mul(64.0, J.mc(this_, "unit", []))

func _f71(this_, a: Array, env):
	var v_i_265 = null; var v_n_266 = null; var v_x0_267 = null; var v_x1_268 = null
	v_i_265 = J.arg(a, 0)
	v_n_266 = J.len(J.gp(this_, "souls"))
	v_x0_267 = 0.32
	v_x1_268 = 0.9
	return [J.add(v_x0_267, ((0.5 if J.seq(v_n_266, 1.0) else J.div(v_i_265, J.sub(v_n_266, 1.0))) * J.sub(v_x1_268, v_x0_267))), 0.955]

func _f72(this_, a: Array, env):
	var v_gi_271 = null; var v_g_272 = null; var v_s_273 = null
	v_gi_271 = J.arg(a, 0)
	v_g_272 = J.gp(J.gp(J.gp(this_, "p"), "graves"), v_gi_271)
	v_s_273 = J.gp(J.G.get("GY_SPOTS"), J.gp(v_g_272, "spot"))
	return [J.gp(v_s_273, "x"), J.gp(v_s_273, "y")]

func _f73(this_, a: Array, env):
	var v_gi_276 = null; var v_x_277 = null; var v_y_278 = null
	v_gi_276 = J.arg(a, 0)
	var _t188 = J.mc(this_, "graveAt", [v_gi_276])
	var _t189 = J.gp(_t188, 0.0)
	v_x_277 = _t189
	var _t190 = J.gp(_t188, 1.0)
	v_y_278 = _t190
	return [J.add(v_x_277, 0.13), J.add(v_y_278, 0.045)]

func _f74(this_, a: Array, env):
	var v_s_281 = null
	v_s_281 = J.arg(a, 0)
	return (J.mc(this_, "standOf", [J.gp(v_s_281, "place")]) if (not J.leq(J.gp(v_s_281, "place"), null)) else J.mc(this_, "homeOf", [J.gp(v_s_281, "i")]))

func _f75(this_, a: Array, env):
	var v_gi_284 = null; var v_x_285 = null; var v_y_286 = null; var v_u_287 = null; var v_w_288 = null; var v_h_289 = null
	v_gi_284 = J.arg(a, 0)
	var _t191 = J.mc(this_, "pt", J.spread([J.SP(J.mc(this_, "graveAt", [v_gi_284]))]))
	var _t192 = J.gp(_t191, 0.0)
	v_x_285 = _t192
	var _t193 = J.gp(_t191, 1.0)
	v_y_286 = _t193
	v_u_287 = J.mc(this_, "unit", [])
	v_w_288 = J.mul(50.0, v_u_287)
	v_h_289 = J.mul(64.0, v_u_287)
	return {"x": J.sub(v_x_285, J.div(v_w_288, 2.0)), "y": (J.sub(v_y_286, v_h_289) + J.mul(6.0, v_u_287)), "w": v_w_288, "h": v_h_289, "cx": v_x_285, "by": J.add(v_y_286, J.mul(6.0, v_u_287))}

func _f76(this_, a: Array, env):
	var v_e_292 = null; var v_r_293 = null
	v_e_292 = J.arg(a, 0)
	var _t194 = J.G.get("$")
	v_r_293 = J.mc(J.cl(_t194, null, ["#gy-cvs"]), "getBoundingClientRect", [])
	return [J.sub(J.gp(v_e_292, "clientX"), J.gp(v_r_293, "left")), J.sub(J.gp(v_e_292, "clientY"), J.gp(v_r_293, "top"))]

func _f77(this_, a: Array, env):
	var v_mx_296 = null; var v_my_297 = null; var v_hh_298 = null; var v_best_299 = null; var v_bd_300 = null; var v_s_301 = null; var v_x_302 = null; var v_y_303 = null; var v_d_304 = null
	v_mx_296 = J.arg(a, 0)
	v_my_297 = J.arg(a, 1)
	v_hh_298 = J.mc(this_, "soulH", [])
	v_best_299 = null
	v_bd_300 = 1000000000.0
	for _t195 in J.iter(J.gp(this_, "souls")):
		v_s_301 = _t195
		v_x_302 = J.gp(v_s_301, "px")
		v_y_303 = J.gp(v_s_301, "py")
		if J.leq(v_x_302, null):
			continue
		var _t196 = J.cmp(v_mx_296, J.sub(v_x_302, J.mul(v_hh_298, 0.42)), ">")
		var _t197 = (J.cmp(v_mx_296, J.add(v_x_302, J.mul(v_hh_298, 0.42)), "<") if _t196 else _t196)
		var _t198 = (J.cmp(v_my_297, J.sub(v_y_303, J.mul(v_hh_298, 1.05)), ">") if _t197 else _t197)
		if (J.cmp(v_my_297, J.add(v_y_303, 8.0), "<") if _t198 else _t198):
			v_d_304 = (absf(J.num(J.sub(v_mx_296, v_x_302))) + absf(J.num(J.sub(v_my_297, J.sub(v_y_303, J.div(v_hh_298, 2.0))))))
			if J.cmp(v_d_304, v_bd_300, "<"):
				v_bd_300 = v_d_304
				v_best_299 = v_s_301
	return v_best_299

func _f79(this_, a: Array, env):
	var v_g_312 = null; var v_gi_313 = null; var v_r_314 = null; var v_cy_315 = null; var v_d_316 = null
	v_g_312 = J.arg(a, 0)
	v_gi_313 = J.arg(a, 1)
	v_r_314 = J.mc(env["this"], "stoneRect", [v_gi_313])
	v_cy_315 = J.sub(J.gp(v_r_314, "by"), J.mul(10.0, env["u"]))
	v_d_316 = J.hypot_([J.div(J.sub(env["mx"], J.gp(v_r_314, "cx")), 1.25), J.sub(env["my"], v_cy_315)])
	var _t200 = J.cmp(v_d_316, J.mul(58.0, env["u"]), "<")
	if (J.cmp(v_d_316, env["bd"], "<") if _t200 else _t200):
		env["bd"] = v_d_316
		env["best"] = v_gi_313

func _f78(this_, a: Array, env):
	var _s143 = {"__p": env, "this": null, "mx": null, "my": null, "best": null, "bd": null, "u": null}
	_s143["this"] = this_
	_s143["mx"] = J.arg(a, 0)
	_s143["my"] = J.arg(a, 1)
	_s143["best"] = null
	_s143["bd"] = 1000000000.0
	_s143["u"] = J.mc(_s143["this"], "unit", [])
	var _t199 = J.gp(J.gp(_s143["this"], "p"), "graves")
	J.mc(_t199, "forEach", [Callable(self, "_f79").bind(_s143)])
	return _s143["best"]

func _f80(this_, a: Array, env):
	var v_e_319 = null; var v_mx_320 = null; var v_my_321 = null; var v_s_322 = null; var v_g_323 = null; var v_er_324 = null
	v_e_319 = J.arg(a, 0)
	if (not J.seq(J.gp(this_, "phase"), "play")):
		return null
	var _t201 = J.mc(this_, "local", [v_e_319])
	var _t202 = J.gp(_t201, 0.0)
	v_mx_320 = _t202
	var _t203 = J.gp(_t201, 1.0)
	v_my_321 = _t203
	v_s_322 = J.mc(this_, "soulAtPx", [v_mx_320, v_my_321])
	if J.t(v_s_322):
		var _t204 = this_
		var _t205 = {"s": v_s_322, "x0": v_mx_320, "y0": v_my_321, "mx": v_mx_320, "my": v_my_321, "moved": false}
		J.sp(_t204, "drag", _t205)
		var _t206 = J.G.get("$")
		var _t207 = J.cl(_t206, null, ["#gy-cvs"])
		J.mc(_t207, "setPointerCapture", [J.gp(v_e_319, "pointerId")])
		return null
	v_g_323 = J.mc(this_, "graveAtPx", [v_mx_320, v_my_321])
	if (not J.leq(v_g_323, null)):
		if (not J.leq(J.gp(this_, "sel"), null)):
			J.mc(this_, "place", [J.gp(this_, "sel"), v_g_323])
		else:
			var _t208 = this_
			var _t209 = {"k": "grave", "i": v_g_323}
			J.sp(_t208, "view", _t209)
			var _t210 = this_
			J.sp(_t210, "guide", false)
			J.mc(J.G.get("Sound"), "play", ["paper"])
			J.mc(this_, "renderPanel", [])
		return null
	if (not J.leq(J.gp(this_, "sel"), null)):
		var _t211 = this_
		J.sp(_t211, "sel", null)
		J.mc(this_, "renderPanel", [])

func _f81(this_, a: Array, env):
	var v_e_327 = null; var v_d_328 = null; var v_mx_329 = null; var v_my_330 = null
	v_e_327 = J.arg(a, 0)
	v_d_328 = J.gp(this_, "drag")
	if (not J.t(v_d_328)):
		return null
	var _t212 = J.mc(this_, "local", [v_e_327])
	var _t213 = J.gp(_t212, 0.0)
	v_mx_329 = _t213
	var _t214 = J.gp(_t212, 1.0)
	v_my_330 = _t214
	J.sp(v_d_328, "mx", v_mx_329)
	J.sp(v_d_328, "my", v_my_330)
	if (J.hypot_([J.sub(v_mx_329, J.gp(v_d_328, "x0")), J.sub(v_my_330, J.gp(v_d_328, "y0"))]) > 9.0):
		J.sp(v_d_328, "moved", true)

func _f82(this_, a: Array, env):
	var v_e_333 = null; var v_d_334 = null; var v_mx_335 = null; var v_my_336 = null; var v_g_337 = null
	v_e_333 = J.arg(a, 0)
	v_d_334 = J.gp(this_, "drag")
	if (not J.t(v_d_334)):
		return null
	var _t215 = this_
	J.sp(_t215, "drag", null)
	var _t216 = J.mc(this_, "local", [v_e_333])
	var _t217 = J.gp(_t216, 0.0)
	v_mx_335 = _t217
	var _t218 = J.gp(_t216, 1.0)
	v_my_336 = _t218
	if (not J.t(J.gp(v_d_334, "moved"))):
		var _t219 = this_
		var _t220 = (null if J.seq(J.gp(this_, "sel"), J.gp(J.gp(v_d_334, "s"), "i")) else J.gp(J.gp(v_d_334, "s"), "i"))
		J.sp(_t219, "sel", _t220)
		if (not J.leq(J.gp(this_, "sel"), null)):
			var _t221 = this_
			var _t222 = {"k": "soul", "i": J.gp(J.gp(v_d_334, "s"), "i")}
			J.sp(_t221, "view", _t222)
			var _t223 = this_
			J.sp(_t223, "guide", false)
			J.mc(J.G.get("Sound"), "play", ["click"])
		J.mc(this_, "renderPanel", [])
		return null
	v_g_337 = J.mc(this_, "graveAtPx", [v_mx_335, J.sub(v_my_336, J.mul(20.0, J.mc(this_, "unit", [])))])
	if (not J.leq(v_g_337, null)):
		J.mc(this_, "place", [J.gp(J.gp(v_d_334, "s"), "i"), v_g_337])
	else:
		var _t224 = J.gp(v_d_334, "s")
		J.sp(_t224, "place", null)
		J.mc(this_, "renderPanel", [])

func _f83(this_, a: Array, env):
	var v_si_340 = null; var v_gi_341 = null; var v_o_342 = null
	v_si_340 = J.arg(a, 0)
	v_gi_341 = J.arg(a, 1)
	if (not J.seq(J.gp(this_, "phase"), "play")):
		return null
	for _t225 in J.iter(J.gp(this_, "souls")):
		v_o_342 = _t225
		var _t226 = J.seq(J.gp(v_o_342, "place"), v_gi_341)
		if ((not J.seq(J.gp(v_o_342, "i"), v_si_340)) if _t226 else _t226):
			J.sp(v_o_342, "place", null)
	var _t227 = J.gp(J.gp(this_, "souls"), v_si_340)
	J.sp(_t227, "place", v_gi_341)
	var _t228 = this_
	J.sp(_t228, "sel", null)
	var _t229 = this_
	var _t230 = {"k": "grave", "i": v_gi_341, "who": v_si_340}
	J.sp(_t229, "view", _t230)
	var _t231 = this_
	J.sp(_t231, "guide", false)
	J.mc(J.G.get("Sound"), "play", ["whoosh"])
	J.mc(this_, "renderPanel", [])

func _f85(this_, a: Array, env):
	var v_s_345 = null
	v_s_345 = J.arg(a, 0)
	return (not J.leq(J.gp(v_s_345, "place"), null))

func _f84(this_, a: Array, env):
	var _t232 = J.gp(this_, "souls")
	return J.mc(_t232, "every", [Callable(self, "_f85").bind(env)])

func _f87(this_, a: Array, env):
	var v_s_348 = null
	v_s_348 = J.arg(a, 0)
	return J.seq(J.gp(v_s_348, "place"), J.gp(J.gp(J.gp(J.gp(env["this"], "p"), "souls"), J.gp(v_s_348, "i")), "grave"))

func _f86(this_, a: Array, env):
	var _s163 = {"__p": env, "this": null}
	_s163["this"] = this_
	var _t233 = J.gp(_s163["this"], "souls")
	return J.len(J.mc(_t233, "filter", [Callable(self, "_f87").bind(_s163)]))

func _f89(this_, a: Array, env):
	var v_s_353 = null; var v_j_354 = null
	v_s_353 = J.arg(a, 0)
	v_j_354 = J.arg(a, 1)
	var _t237 = {"k": "hurt", "t": ((-J.num(v_j_354)) * 0.08), "dur": 1.3}
	J.sp(v_s_353, "rx", _t237)
	return _t237

func _f90(this_, a: Array, env):
	return J.mc(env["this"], "finish", [false, env["k"]])

func _f88(this_, a: Array, env):
	var v_n_352 = null
	var _s165 = {"__p": env, "this": null, "k": null}
	_s165["this"] = this_
	var _t234 = (not J.seq(J.gp(_s165["this"], "phase"), "play"))
	if (_t234 if _t234 else (not J.t(J.mc(_s165["this"], "allPlaced", [])))):
		return null
	_s165["k"] = J.mc(_s165["this"], "correct", [])
	v_n_352 = J.len(J.gp(_s165["this"], "souls"))
	if J.seq(_s165["k"], v_n_352):
		J.mc(_s165["this"], "rest", [])
		return null
	var _t235 = _s165["this"]
	J.sp(_t235, "tries", J.num(J.gp(_t235, "tries")) + 1.0)
	var _t236 = J.gp(_s165["this"], "souls")
	J.mc(_t236, "forEach", [Callable(self, "_f89").bind(_s165)])
	J.mc(J.G.get("Sound"), "play", ["lose"])
	if J.cmp(J.gp(_s165["this"], "tries"), 2.0, ">="):
		var _t238 = _s165["this"]
		J.sp(_t238, "phase", "fail")
		J.mc(_s165["this"], "say", [("還是不對……只有 " + J.str(_s165["k"]) + " 個擺對了。天快亮了。"), 3.0])
		J.F_setTimeout([Callable(self, "_f90").bind(_s165), 1900.0])
	else:
		J.mc(_s165["this"], "say", [("他們不肯躺下。只有 " + J.str(_s165["k"]) + " 個擺對了。"), 4.5])
		J.mc(_s165["this"], "hint", [("只有 " + J.str(_s165["k"]) + " 個擺對了（不告訴你是哪幾個）。還有一次機會。"), 8.0])
	J.mc(_s165["this"], "renderPanel", [])

func _f91(this_, a: Array, env):
	var v_text_357 = null; var v_sec_358 = null
	v_text_357 = J.arg(a, 0)
	v_sec_358 = J.arg(a, 1)
	var _t239 = this_
	var _t240 = {"text": v_text_357, "life": (v_sec_358 if J.t(v_sec_358) else 3.0), "max": (v_sec_358 if J.t(v_sec_358) else 3.0)}
	J.sp(_t239, "bub", _t240)

func _f93(this_, a: Array, env):
	return J.mc(J.G.get("Sound"), "play", ["crow", (-0.4)])

func _f94(this_, a: Array, env):
	return J.mc(J.G.get("Sound"), "play", ["crow", 0.3])

func _f95(this_, a: Array, env):
	return J.mc(env["this"], "finish", [true, J.len(J.gp(env["this"], "souls"))])

func _f92(this_, a: Array, env):
	var v_i_361 = null
	var _s172 = {"__p": env, "this": null}
	_s172["this"] = this_
	var _t241 = _s172["this"]
	J.sp(_t241, "phase", "rest")
	var _t242 = _s172["this"]
	J.sp(_t242, "restT", 0.0)
	var _t243 = _s172["this"]
	J.sp(_t243, "sel", null)
	J.mc(J.G.get("Sound"), "play", ["gong"])
	J.F_setTimeout([Callable(self, "_f93").bind(_s172), 900.0])
	J.F_setTimeout([Callable(self, "_f94").bind(_s172), 1400.0])
	v_i_361 = 0.0
	while true:
		if not J.cmp(v_i_361, 6.0, "<"): break
		var _t244 = J.gp(_s172["this"], "crows")
		J.mc(_t244, "push", [{"x": (0.08 + (randf() * 0.2)), "y": (0.12 + (randf() * 0.12)), "vx": (0.16 + (randf() * 0.12)), "vy": ((-0.05) - (randf() * 0.06)), "ph": (randf() * 6.0), "s": (0.9 + (randf() * 0.5)), "delay": (0.8 + J.mul(v_i_361, 0.18)), "life": 4.0}])
		v_i_361 = J.num(v_i_361) + 1.0
	J.mc(_s172["this"], "say", ["都對了。去吧，下班了。", 3.0])
	J.mc(_s172["this"], "renderPanel", [])
	J.F_setTimeout([Callable(self, "_f95").bind(_s172), 3600.0])

func _f97(this_, a: Array, env):
	var v_g_381 = null
	v_g_381 = J.arg(a, 0)
	return J.seq(J.gp(v_g_381, "k"), "youhun")

func _f98(this_, a: Array, env):
	var v_s_383 = null; var v_i_384 = null; var v_g_385 = null; var v_wrong_386 = null
	v_s_383 = J.arg(a, 0)
	v_i_384 = J.arg(a, 1)
	v_g_385 = J.gp(J.gp(J.gp(env["this"], "p"), "graves"), J.gp(v_s_383, "grave"))
	v_wrong_386 = (not J.seq(J.gp(J.gp(J.gp(env["this"], "souls"), v_i_384), "place"), J.gp(v_s_383, "grave")))
	return ("<li><b style=\"color:" + J.str(J.gp(J.G.get("GY_COLORS"), v_i_384)) + "\">" + J.str(J.gp(v_s_383, "tag")) + "</b> <span>" + J.str(J.gp(v_g_385, "name")) + "・" + J.str(J.gp(v_g_385, "job")) + "・" + J.str(J.gp(v_g_385, "birth")) + "–" + J.str(J.gp(v_g_385, "death")) + "<br><small>" + (("「" + J.str(J.gp(J.gp(J.G.get("GY_JOBS"), J.gp(v_g_385, "job")), "last")) + "」") if J.t(env["ok"]) else (("其實睡在" if J.t(v_wrong_386) else "睡在") + J.str(J.gp(J.gp(J.G.get("GY_SPOTS"), J.gp(v_g_385, "spot")), "name")) + "那座" + ("" if J.t(v_wrong_386) else "，你擺對了"))) + "</small></span></li>")

func _f99(this_, a: Array, env):
	var v_s_387 = null; var v_i_388 = null; var v_g_389 = null; var v_wrong_390 = null
	v_s_387 = J.arg(a, 0)
	v_i_388 = J.arg(a, 1)
	v_g_389 = J.gp(J.gp(J.gp(env["this"], "p"), "graves"), J.gp(v_s_387, "grave"))
	v_wrong_390 = (not J.seq(J.gp(J.gp(J.gp(env["this"], "souls"), v_i_388), "place"), J.gp(v_s_387, "grave")))
	return {"tag": J.gp(v_s_387, "tag"), "col": J.gp(J.G.get("GY_COLORS"), v_i_388), "a": (J.str(J.gp(v_g_389, "name")) + "・" + J.str(J.gp(v_g_389, "job")) + "・" + J.str(J.gp(v_g_389, "birth")) + "–" + J.str(J.gp(v_g_389, "death"))), "b": (("「" + J.str(J.gp(J.gp(J.G.get("GY_JOBS"), J.gp(v_g_389, "job")), "last")) + "」") if J.t(env["ok"]) else (("其實睡在" if J.t(v_wrong_390) else "睡在") + J.str(J.gp(J.gp(J.G.get("GY_SPOTS"), J.gp(v_g_389, "spot")), "name")) + "那座" + ("" if J.t(v_wrong_390) else "，你擺對了")))}

func _f100(this_, a: Array, env):
	var v_k_391 = null
	if J.t(J.gp(env["this"], "_join")):
		var _t282 = env["this"]
		J.sp(_t282, "_join", false)
		var _t283 = J.G.get("joinGhost")
		J.cl(_t283, null, ["youhun"])
		J.cl(J.G.get("save"), null, [])
	if J.t(J.gp(env["this"], "_joinK")):
		v_k_391 = J.gp(env["this"], "_joinK")
		var _t284 = env["this"]
		J.sp(_t284, "_joinK", null)
		var _t285 = J.G.get("joinGhost")
		J.cl(_t285, null, [v_k_391])
		J.cl(J.G.get("save"), null, [])

func _f101(this_, a: Array, env):
	J.mc(env["this"], "close", [])
	J.cl(env["after"], null, [])

func _f102(this_, a: Array, env):
	J.cl(env["after"], null, [])
	if J.t(J.gp(env["this"], "_ro")):
		J.mc(J.gp(env["this"], "_ro"), "disconnect", [])
	J.mc(env["this"], "open", [])

func _f96(this_, a: Array, env):
	var v_k_365 = null; var v_y_366 = null; var v_n_367 = null; var v_night_368 = null; var v_perfect_369 = null; var v_hn_370 = null; var v_rw_371 = null; var v_got_372 = null; var v_stay_373 = null; var v_rows_374 = null; var v_title_375 = null; var v_word_376 = null; var v_s_378 = null; var v_s_379 = null; var v_nm_380 = null; var v_v_382 = null
	var _s177 = {"__p": env, "this": null, "ok": null, "after": null}
	_s177["this"] = this_
	_s177["ok"] = J.arg(a, 0)
	v_k_365 = J.arg(a, 1)
	var _t245 = (not J.t(J.gp(_s177["this"], "active")))
	if (_t245 if _t245 else J.seq(J.gp(_s177["this"], "phase"), "end")):
		return null
	v_y_366 = J.mc(_s177["this"], "ensure", [])
	v_n_367 = J.len(J.gp(_s177["this"], "souls"))
	v_night_368 = J.gp(v_y_366, "night")
	v_perfect_369 = (J.seq(J.gp(_s177["this"], "tries"), 0.0) if J.t(_s177["ok"]) else _s177["ok"])
	var _t246 = _s177["this"]
	J.sp(_t246, "phase", "end")
	J.F_clearTimeout([J.gp(_s177["this"], "_ht")])
	var _t247 = J.G.get("$")
	v_hn_370 = J.cl(_t247, null, ["#gy-hint"])
	if J.t(v_hn_370):
		var _t248 = J.gp(v_hn_370, "classList")
		J.mc(_t248, "remove", ["on"])
	v_rw_371 = null
	if J.t(_s177["ok"]):
		var _t249 = {"coins": J.round(J.num(((J.mul(25.0, v_n_367) + (5.0 * J.min_([v_night_368, 20.0]))) * (1.0 if J.t(v_perfect_369) else 0.6)))), "exp": J.round(J.num(J.mul(J.add(J.mul(5.0, v_n_367), v_night_368), (1.0 if J.t(v_perfect_369) else 0.6))))}
		v_rw_371 = _t249
		if J.t(v_perfect_369):
			var _t250 = ("b" if J.cmp(v_night_368, 5.0, ">=") else "g")
			J.sp(v_rw_371, "chest", _t250)
	else:
		var _t251 = {"coins": J.max_([5.0, J.mul(8.0, v_k_365)]), "exp": J.mul(2.0, v_k_365)}
		v_rw_371 = _t251
	var _t252 = J.G.get("give")
	v_got_372 = J.cl(_t252, null, [v_rw_371])
	v_stay_373 = ""
	if J.t(_s177["ok"]):
		var _t253 = J.max_([J.gp(v_y_366, "best"), v_night_368])
		J.sp(v_y_366, "best", _t253)
		for _t254 in J.iter(J.gp(J.gp(_s177["this"], "p"), "souls")):
			v_s_378 = _t254
			var _t255 = J.gp(v_y_366, "rested")
			J.mc(_t255, "push", [J.gp(J.gp(J.gp(J.gp(_s177["this"], "p"), "graves"), J.gp(v_s_378, "grave")), "name")])
		if (J.len(J.gp(v_y_366, "rested")) > 200.0):
			var _t256 = J.gp(v_y_366, "rested")
			var _t257 = J.mc(_t256, "slice", [(-200.0)])
			J.sp(v_y_366, "rested", _t257)
		if (randf() < 0.12):
			v_s_379 = J.gp(J.gp(J.gp(_s177["this"], "p"), "souls"), floor(J.num(J.mul(randf(), v_n_367))))
			v_nm_380 = J.gp(J.gp(J.gp(J.gp(_s177["this"], "p"), "graves"), J.gp(v_s_379, "grave")), "name")
			var _t258 = J.gp(J.G.get("S"), "ghosts")
			if (not J.t(J.mc(_t258, "some", [Callable(self, "_f97").bind(_s177)]))):
				v_stay_373 = (J.str(J.gp(v_s_379, "tag")) + "（" + J.str(v_nm_380) + "）回頭看了一眼：「村子裡……還缺人嗎？」")
				var _t259 = _s177["this"]
				J.sp(_t259, "_join", true)
			else:
				v_stay_373 = (J.str(J.gp(v_s_379, "tag")) + "（" + J.str(v_nm_380) + "）本來想留下，可是村裡已經有遊魂了。他把身上的冥幣都留給你。")
				var _t260 = J.G.get("give")
				var _t261 = J.add(v_got_372, J.add("，", J.cl(_t260, null, [{"coins": 30.0}])))
				v_got_372 = _t261
		var _t262 = (not J.t(v_stay_373))
		if ((not J.seq(J.typeof_(J.G.get("N30W")), "undefined")) if _t262 else _t262):
			v_v_382 = J.mc(J.G.get("N30W"), "graveVisit", [])
			if J.t(v_v_382):
				v_stay_373 = J.gp(v_v_382, "text")
				var _t263 = _s177["this"]
				var _t264 = J.gp(v_v_382, "k")
				J.sp(_t263, "_joinK", _t264)
	var _t265 = J.add(v_night_368, 1.0)
	J.sp(v_y_366, "night", _t265)
	var _t266 = (1.0 + floor(J.num((randf() * 2000000000.0))))
	J.sp(v_y_366, "seed", _t266)
	J.cl(J.G.get("save"), null, [])
	var _t267 = J.gp(J.gp(_s177["this"], "p"), "souls")
	var _t268 = J.mc(_t267, "map", [Callable(self, "_f98").bind(_s177)])
	v_rows_374 = J.mc(_t268, "join", [""])
	v_title_375 = (("一次就全對" if J.t(v_perfect_369) else "都安息了") if J.t(_s177["ok"]) else "天亮了")
	v_word_376 = (("陰司 KPI 系統：零投訴，五星好評。" if J.t(v_perfect_369) else "陰司 KPI 系統：有投訴，但最後都結案了。") if J.t(_s177["ok"]) else "陰司 KPI 系統：未結案。他們明晚還會在這裡等。")
	var _t269 = J.G.get("$")
	var _t270 = J.cl(_t269, null, ["#gy-end"])
	var _t271 = ("<div class=\"gy-card\"><h3>" + J.str(v_title_375) + "</h3><p class=\"desc\">" + J.str(v_word_376) + "</p><ul class=\"gy-who\">" + J.str(v_rows_374) + "</ul>" + (("<p class=\"desc gy-stay\">" + J.str(v_stay_373) + "</p>") if J.t(v_stay_373) else "") + "<p class=\"desc\">獎勵：" + J.str(v_got_372) + "</p><div class=\"gy-acts\"><button class=\"btn\" id=\"gy-back\">回村子</button><button class=\"btn gold\" id=\"gy-next\">下一夜</button></div></div>")
	J.sp(_t270, "innerHTML", _t271)
	var _t272 = _s177["this"]
	var _t273 = J.gp(J.gp(_s177["this"], "p"), "souls")
	var _t274 = J.mc(_t273, "map", [Callable(self, "_f99").bind(_s177)])
	J.sp(_t272, "_endRows", _t274)
	var _t275 = _s177["this"]
	var _t276 = {"title": v_title_375, "word": v_word_376, "stay": v_stay_373, "got": v_got_372}
	J.sp(_t275, "_endInfo", _t276)
	var _t277 = J.gp(_s177["this"], "_nat")
	var _t279 = ((not J.seq(J.typeof_(J.G.get("__nat_gyEnd")), "undefined")) if J.t(_t277) else _t277)
	if J.t(_t279):
		var _t278 = J.G.get("__nat_gyEnd")
		_t279 = J.cl(_t278, null, [_s177["this"]])
	if (not J.t(_t279)):
		var _t280 = J.G.get("$")
		var _t281 = J.gp(J.cl(_t280, null, ["#gy-end"]), "classList")
		J.mc(_t281, "add", ["on"])
	_s177["after"] = Callable(self, "_f100").bind(_s177)
	var _t286 = J.G.get("$")
	var _t287 = J.cl(_t286, null, ["#gy-back"])
	var _t288 = _s177["this"]
	var _t289 = Callable(self, "_f101").bind(_s177)
	J.sp(_t288, "_endBack", _t289)
	J.sp(_t287, "onclick", _t289)
	var _t290 = J.G.get("$")
	var _t291 = J.cl(_t290, null, ["#gy-next"])
	var _t292 = _s177["this"]
	var _t293 = Callable(self, "_f102").bind(_s177)
	J.sp(_t292, "_endNext", _t293)
	J.sp(_t291, "onclick", _t293)

func _f104(this_, a: Array, env):
	var v_s_398 = null; var v_g_399 = null
	v_s_398 = J.arg(a, 0)
	v_g_399 = (J.gp(J.gp(J.gp(env["this"], "p"), "graves"), J.gp(v_s_398, "place")) if (not J.leq(J.gp(v_s_398, "place"), null)) else null)
	var _t303 = ("sel" if J.seq(J.gp(env["this"], "sel"), J.gp(v_s_398, "i")) else "")
	var _t302 = J.seq(J.gp(J.gp(env["this"], "view"), "k"), "soul")
	return ("<button class=\"gy-chip " + _t303 + " " + ("on" if (J.seq(J.gp(J.gp(env["this"], "view"), "i"), J.gp(v_s_398, "i")) if _t302 else _t302) else "") + "\" data-i=\"" + J.str(J.gp(v_s_398, "i")) + "\" style=\"--c:" + J.str(J.gp(v_s_398, "col")) + "\"><b>" + J.str(J.gp(v_s_398, "tag")) + "</b><small>" + (J.add(J.gp(J.gp(v_g_399, "name"), 0.0), "家墳前") if J.t(v_g_399) else "還沒安置") + "</small></button>")

func _f106(this_, a: Array, env):
	var v_i_401 = null
	v_i_401 = J.num(J.gp(J.gp(env["b"], "dataset"), "i"))
	var _t310 = env["__p"]["this"]
	var _t311 = {"k": "soul", "i": v_i_401}
	J.sp(_t310, "view", _t311)
	var _t312 = env["__p"]["this"]
	J.sp(_t312, "guide", false)
	var _t313 = env["__p"]["this"]
	var _t314 = ((null if J.seq(J.gp(env["__p"]["this"], "sel"), v_i_401) else v_i_401) if J.seq(J.gp(env["__p"]["this"], "phase"), "play") else null)
	J.sp(_t313, "sel", _t314)
	J.mc(env["__p"]["this"], "renderPanel", [])

func _f105(this_, a: Array, env):
	var _s196 = {"__p": env, "b": null}
	_s196["b"] = J.arg(a, 0)
	var _t309 = _s196["b"]
	var _t315 = Callable(self, "_f106").bind(_s196)
	J.sp(_t309, "onclick", _t315)
	return _t315

func _f107(this_, a: Array, env):
	var v_r_402 = null
	v_r_402 = J.arg(a, 0)
	return ("<p><b>" + J.str(J.gp(v_r_402, 0.0)) + "</b>" + J.str(J.gp(v_r_402, 1.0)) + "</p>")

func _f108(this_, a: Array, env):
	var v_s_406 = null
	v_s_406 = J.arg(a, 0)
	return J.seq(J.gp(v_s_406, "place"), J.gp(env["v"], "i"))

func _f109(this_, a: Array, env):
	var v_l_409 = null
	v_l_409 = J.arg(a, 0)
	return ("<li>" + J.str(v_l_409) + "</li>")

func _f110(this_, a: Array, env):
	var v_s_410 = null
	v_s_410 = J.arg(a, 0)
	return J.leq(J.gp(v_s_410, "place"), null)

func _f103(this_, a: Array, env):
	var v_n_394 = null; var v_h_396 = null; var v_go_397 = null; var v_g_403 = null; var v_c_404 = null; var v_who_405 = null; var v_s_407 = null; var v_d_408 = null
	var _s194 = {"__p": env, "this": null, "v": null}
	_s194["this"] = this_
	var _t295 = (not J.t(J.gp(_s194["this"], "active")))
	if not J.t(_t295):
		var _t294 = J.G.get("$")
		_t295 = (not J.t(J.cl(_t294, null, ["#gy-panel"])))
	if _t295:
		return null
	v_n_394 = J.len(J.gp(_s194["this"], "souls"))
	var _t296 = J.G.get("$")
	var _t297 = J.cl(_t296, null, ["#gy-tries"])
	var _t298 = ("機會 " + J.str(J.mc("●", "repeat", [J.sub(2.0, J.gp(_s194["this"], "tries"))])) + J.str(J.mc("○", "repeat", [J.gp(_s194["this"], "tries")])))
	J.sp(_t297, "innerHTML", _t298)
	var _t299 = J.G.get("$")
	var _t300 = J.cl(_t299, null, ["#gy-chips"])
	var _t301 = J.gp(_s194["this"], "souls")
	var _t304 = J.mc(_t301, "map", [Callable(self, "_f104").bind(_s194)])
	var _t305 = J.mc(_t304, "join", [""])
	J.sp(_t300, "innerHTML", _t305)
	var _t306 = J.G.get("$")
	var _t307 = J.cl(_t306, null, ["#gy-chips"])
	var _t308 = J.mc(_t307, "querySelectorAll", [".gy-chip"])
	J.mc(_t308, "forEach", [Callable(self, "_f105").bind(_s194)])
	_s194["v"] = J.gp(_s194["this"], "view")
	v_h_396 = ""
	if J.seq(J.gp(_s194["v"], "k"), "rules"):
		var _t316 = J.mc(J.G.get("GY_RULES"), "map", [Callable(self, "_f107").bind(_s194)])
		var _t317 = ("<div class=\"gy-rules\">" + J.str(J.mc(_t316, "join", [""])) + "</div>")
		v_h_396 = _t317
	else:
		if J.seq(J.gp(_s194["v"], "k"), "grave"):
			v_g_403 = J.gp(J.gp(J.gp(_s194["this"], "p"), "graves"), J.gp(_s194["v"], "i"))
			v_c_404 = J.mc(J.G.get("GY_GEN"), "card", [v_g_403])
			var _t318 = J.gp(_s194["this"], "souls")
			v_who_405 = J.mc(_t318, "find", [Callable(self, "_f108").bind(_s194)])
			var _t319 = ("<div class=\"gy-grave\"><div class=\"gy-gh\"><b>" + J.str(J.gp(v_c_404, "name")) + "</b><span>" + J.str(J.gp(v_c_404, "years")) + "</span><em>" + J.str(J.gp(J.gp(J.G.get("GY_SPOTS"), J.gp(v_g_403, "spot")), "name")) + "</em></div>\n        <p><i>生前</i>" + J.str(J.gp(v_c_404, "job")) + "</p><p><i>碑文</i>" + J.str(J.gp(v_c_404, "ep")) + "</p><p><i>祭品</i>" + J.str(J.gp(v_c_404, "off")) + "</p>\n        <p class=\"gy-note\">" + (("<b style=\"color:" + J.str(J.gp(v_who_405, "col")) + "\">" + J.str(J.gp(v_who_405, "tag")) + "</b> 站在這座墳前。") if J.t(v_who_405) else ("" if (not J.leq(J.gp(_s194["this"], "sel"), null)) else "先點一個魂，再點這座墳，就能把他送過來。")) + "</p></div>")
			v_h_396 = _t319
		else:
			v_s_407 = J.gp(J.gp(_s194["this"], "souls"), J.gp(_s194["v"], "i"))
			v_d_408 = J.gp(J.gp(J.gp(_s194["this"], "p"), "souls"), J.gp(_s194["v"], "i"))
			var _t322 = J.gp(v_s_407, "col")
			var _t323 = J.gp(v_s_407, "tag")
			var _t324 = ("選好了：點一座墳，把他送過去" if J.seq(J.gp(_s194["this"], "sel"), J.gp(v_s_407, "i")) else "他記得的事")
			var _t320 = J.gp(v_d_408, "lines")
			var _t321 = J.mc(_t320, "map", [Callable(self, "_f109").bind(_s194)])
			var _t325 = ("<div class=\"gy-soul\"><div class=\"gy-sh\" style=\"--c:" + J.str(_t322) + "\"><b>" + J.str(_t323) + "</b><span>" + _t324 + "</span></div><ul>" + J.str(J.mc(_t321, "join", [""])) + "</ul></div>")
			v_h_396 = _t325
	var _t326 = J.G.get("$")
	var _t327 = J.cl(_t326, null, ["#gy-info"])
	J.sp(_t327, "innerHTML", v_h_396)
	var _t328 = J.G.get("$")
	v_go_397 = J.cl(_t328, null, ["#gy-go"])
	var _t329 = (not J.seq(J.gp(_s194["this"], "phase"), "play"))
	var _t330 = (_t329 if _t329 else (not J.t(J.mc(_s194["this"], "allPlaced", []))))
	J.sp(v_go_397, "disabled", _t330)
	var _t332 = null
	if J.t(J.mc(_s194["this"], "allPlaced", [])):
		_t332 = "送他們安息"
	else:
		var _t331 = J.gp(_s194["this"], "souls")
		_t332 = ("送他們安息（差 " + J.str(J.len(J.mc(_t331, "filter", [Callable(self, "_f110").bind(_s194)]))) + "）")
	J.sp(v_go_397, "textContent", _t332)
	var _t333 = J.G.get("$")
	var _t334 = J.cl(_t333, null, ["#gy-reset"])
	var _t335 = (not J.seq(J.gp(_s194["this"], "phase"), "play"))
	J.sp(_t334, "disabled", _t335)

func _f112(this_, a: Array, env):
	var v_n_416 = null
	v_n_416 = J.arg(a, 0)
	return J.mc(env["this"], "frame", [v_n_416, env["tok"]])

func _f113(this_, a: Array, env):
	var v_n_417 = null
	v_n_417 = J.arg(a, 0)
	return J.mc(env["this"], "frame", [v_n_417, env["tok"]])

func _f111(this_, a: Array, env):
	var v_now_413 = null; var v_dt_415 = null
	var _s205 = {"__p": env, "this": null, "tok": null}
	_s205["this"] = this_
	v_now_413 = J.arg(a, 0)
	_s205["tok"] = J.arg(a, 1)
	var _t336 = (not J.t(J.gp(_s205["this"], "active")))
	if (_t336 if _t336 else (not J.seq(_s205["tok"], J.gp(_s205["this"], "_tok")))):
		return null
	if (J.sub(v_now_413, J.gp(_s205["this"], "last")) < (J.div(1000.0, 30.0) - 2.0)):
		J.F_requestAnimationFrame([Callable(self, "_f112").bind(_s205)])
		return null
	v_dt_415 = J.min_([0.05, J.div(J.sub(v_now_413, J.gp(_s205["this"], "last")), 1000.0)])
	var _t337 = _s205["this"]
	J.sp(_t337, "last", v_now_413)
	J.mc(_s205["this"], "step", [v_dt_415])
	if (not J.t(J.gp(_s205["this"], "_nat"))):
		J.mc(_s205["this"], "draw", [J.gp(_s205["this"], "t")])
	J.F_requestAnimationFrame([Callable(self, "_f113").bind(_s205)])

func _f115(this_, a: Array, env):
	var v_c_426 = null
	v_c_426 = J.arg(a, 0)
	if J.cmp(J.gp(v_c_426, "delay"), 0.0, ">"):
		var _t364 = J.sub(J.gp(v_c_426, "delay"), env["dt"])
		J.sp(v_c_426, "delay", _t364)
		return true
	var _t365 = J.sub(J.gp(v_c_426, "life"), env["dt"])
	J.sp(v_c_426, "life", _t365)
	var _t366 = J.add(J.gp(v_c_426, "x"), J.mul(J.gp(v_c_426, "vx"), env["dt"]))
	J.sp(v_c_426, "x", _t366)
	var _t367 = J.add(J.gp(v_c_426, "y"), J.mul(J.gp(v_c_426, "vy"), env["dt"]))
	J.sp(v_c_426, "y", _t367)
	var _t368 = J.add(J.gp(v_c_426, "ph"), J.mul(env["dt"], 14.0))
	J.sp(v_c_426, "ph", _t368)
	var _t369 = J.cmp(J.gp(v_c_426, "life"), 0.0, ">")
	return (J.cmp(J.gp(v_c_426, "x"), 1.2, "<") if _t369 else _t369)

func _f116(this_, a: Array, env):
	var v_p_427 = null
	v_p_427 = J.arg(a, 0)
	var _t373 = J.sub(J.gp(v_p_427, "life"), env["dt"])
	J.sp(v_p_427, "life", _t373)
	var _t374 = J.add(J.gp(v_p_427, "x"), J.mul(J.gp(v_p_427, "vx"), env["dt"]))
	J.sp(v_p_427, "x", _t374)
	var _t375 = J.add(J.gp(v_p_427, "y"), J.mul(J.gp(v_p_427, "vy"), env["dt"]))
	J.sp(v_p_427, "y", _t375)
	return J.cmp(J.gp(v_p_427, "life"), 0.0, ">")

func _f114(this_, a: Array, env):
	var v_s_421 = null; var v_tx_422 = null; var v_ty_423 = null; var v_k_424 = null; var v_w_425 = null; var v_s_428 = null
	var _s209 = {"__p": env, "dt": null}
	_s209["dt"] = J.arg(a, 0)
	var _t338 = this_
	var _t339 = J.add(J.gp(_t338, "t"), _s209["dt"])
	J.sp(_t338, "t", _t339)
	if J.seq(J.gp(this_, "phase"), "rest"):
		var _t340 = this_
		var _t341 = J.add(J.gp(_t340, "restT"), _s209["dt"])
		J.sp(_t340, "restT", _t341)
	for _t342 in J.iter(J.gp(this_, "souls")):
		v_s_421 = _t342
		if J.t(J.gp(v_s_421, "rx")):
			var _t343 = J.gp(v_s_421, "rx")
			var _t344 = J.add(J.gp(_t343, "t"), _s209["dt"])
			J.sp(_t343, "t", _t344)
			if J.cmp(J.gp(J.gp(v_s_421, "rx"), "t"), J.gp(J.gp(v_s_421, "rx"), "dur"), ">="):
				J.sp(v_s_421, "rx", null)
		var _t345 = J.mc(this_, "targetOf", [v_s_421])
		var _t346 = J.gp(_t345, 0.0)
		v_tx_422 = _t346
		var _t347 = J.gp(_t345, 1.0)
		v_ty_423 = _t347
		var _t348 = J.seq(J.gp(v_s_421, "x"), 0.0)
		if (J.seq(J.gp(v_s_421, "y"), 0.0) if _t348 else _t348):
			J.sp(v_s_421, "x", v_tx_422)
			J.sp(v_s_421, "y", v_ty_423)
		v_k_424 = J.min_([1.0, J.mul(_s209["dt"], 6.0)])
		var _t349 = J.add(J.gp(v_s_421, "x"), J.mul(J.sub(v_tx_422, J.gp(v_s_421, "x")), v_k_424))
		J.sp(v_s_421, "x", _t349)
		var _t350 = J.add(J.gp(v_s_421, "y"), J.mul(J.sub(v_ty_423, J.gp(v_s_421, "y")), v_k_424))
		J.sp(v_s_421, "y", _t350)
	for _t351 in J.iter(J.gp(this_, "wisps")):
		v_w_425 = _t351
		var _t352 = J.add(J.gp(v_w_425, "ph"), J.mul(_s209["dt"], J.gp(v_w_425, "sp")))
		J.sp(v_w_425, "ph", _t352)
		var _t353 = J.add(J.gp(v_w_425, "x"), (J.mul(sin(J.num(J.mul(J.gp(v_w_425, "ph"), 0.7))), _s209["dt"]) * 0.02))
		J.sp(v_w_425, "x", _t353)
		var _t354 = J.add(J.gp(v_w_425, "y"), (J.mul(cos(J.num(J.mul(J.gp(v_w_425, "ph"), 0.5))), _s209["dt"]) * 0.012))
		J.sp(v_w_425, "y", _t354)
		if J.cmp(J.gp(v_w_425, "x"), (-0.05), "<"):
			J.sp(v_w_425, "x", 1.05)
		if J.cmp(J.gp(v_w_425, "x"), 1.05, ">"):
			var _t355 = (-0.05)
			J.sp(v_w_425, "x", _t355)
	var _t356 = this_
	var _t357 = J.sub(J.gp(_t356, "crowT"), _s209["dt"])
	J.sp(_t356, "crowT", _t357)
	var _t358 = J.cmp(J.gp(this_, "crowT"), 0.0, "<=")
	if (J.seq(J.gp(this_, "phase"), "play") if _t358 else _t358):
		var _t359 = this_
		var _t360 = (8.0 + (randf() * 8.0))
		J.sp(_t359, "crowT", _t360)
		var _t361 = J.gp(this_, "crows")
		J.mc(_t361, "push", [{"x": (-0.05), "y": (0.08 + (randf() * 0.1)), "vx": 0.13, "vy": (-0.01), "ph": 0.0, "s": 0.8, "delay": 0.0, "life": 9.0}])
	var _t362 = this_
	var _t363 = J.gp(this_, "crows")
	var _t370 = J.mc(_t363, "filter", [Callable(self, "_f115").bind(_s209)])
	J.sp(_t362, "crows", _t370)
	var _t371 = this_
	var _t372 = J.gp(this_, "parts")
	var _t376 = J.mc(_t372, "filter", [Callable(self, "_f116").bind(_s209)])
	J.sp(_t371, "parts", _t376)
	var _t377 = J.seq(J.gp(this_, "phase"), "rest")
	if ((randf() < J.mul(_s209["dt"], 40.0)) if _t377 else _t377):
		v_s_428 = J.gp(J.gp(this_, "souls"), floor(J.num((randf() * J.len(J.gp(this_, "souls"))))))
		var _t378 = J.gp(this_, "parts")
		J.mc(_t378, "push", [{"x": J.add(J.gp(v_s_428, "x"), ((randf() - 0.5) * 0.08)), "y": (J.sub(J.gp(v_s_428, "y"), 0.05) - J.mul(J.gp(this_, "restT"), 0.07)), "vx": ((randf() - 0.5) * 0.03), "vy": ((-0.08) - (randf() * 0.06)), "life": 1.4, "col": J.gp(v_s_428, "col")}])
	if J.t(J.gp(this_, "bub")):
		var _t379 = J.gp(this_, "bub")
		var _t380 = J.sub(J.gp(_t379, "life"), _s209["dt"])
		J.sp(_t379, "life", _t380)
		if J.cmp(J.gp(J.gp(this_, "bub"), "life"), 0.0, "<="):
			var _t381 = this_
			J.sp(_t381, "bub", null)

func _f118(this_, a: Array, env):
	var v_g_457 = null; var v_gi_458 = null
	v_g_457 = J.arg(a, 0)
	v_gi_458 = J.arg(a, 1)
	return J.mc(env["this"], "drawStone", [env["ctx"], v_g_457, v_gi_458, env["t"]])

func _f119(this_, a: Array, env):
	var v_g_459 = null; var v_gi_460 = null; var v_r_461 = null; var v_al_462 = null
	v_g_459 = J.arg(a, 0)
	v_gi_460 = J.arg(a, 1)
	v_r_461 = J.mc(env["this"], "stoneRect", [v_gi_460])
	v_al_462 = (0.75 + (0.25 * sin(J.num(J.mul(env["t"], 4.0)))))
	var _t419 = env["ctx"]
	var _t420 = ("rgba(160,255,200," + J.str(J.mul(0.1, v_al_462)) + ")")
	J.sp(_t419, "fillStyle", _t420)
	var _t421 = env["ctx"]
	var _t422 = ("rgba(200,255,225," + J.str(v_al_462) + ")")
	J.sp(_t421, "strokeStyle", _t422)
	var _t423 = env["ctx"]
	J.sp(_t423, "lineWidth", 3.0)
	J.mc(env["ctx"], "setLineDash", [[7.0, 5.0]])
	J.mc(env["ctx"], "beginPath", [])
	J.mc(env["ctx"], "ellipse", [J.gp(v_r_461, "cx"), J.sub(J.gp(v_r_461, "by"), J.mul(4.0, env["u"])), J.mul(54.0, env["u"]), J.mul(22.0, env["u"]), 0.0, 0.0, (PI * 2.0)])
	J.mc(env["ctx"], "fill", [])
	J.mc(env["ctx"], "stroke", [])
	J.mc(env["ctx"], "setLineDash", [[]])

func _f120(this_, a: Array, env):
	var v_a_469 = null; var v_c2_470 = null
	v_a_469 = J.arg(a, 0)
	v_c2_470 = J.arg(a, 1)
	return J.sub(J.gp(v_a_469, "y"), J.gp(v_c2_470, "y"))

func _f117(this_, a: Array, env):
	var v_c_432 = null; var v_dp_434 = null; var v_W_435 = null; var v_H_436 = null; var v_b_437 = null; var v_img_438 = null; var v_restK_440 = null; var v_order_441 = null; var v_vg_442 = null; var v_g_443 = null; var v_k_444 = null; var v_x_445 = null; var v_y_446 = null; var v_lx_447 = null; var v_ly_448 = null; var v_r_449 = null; var v_g_450 = null; var v_k_451 = null; var v_sp_452 = null; var v_x_453 = null; var v_y_454 = null; var v_lab_455 = null; var v_w_456 = null; var v_ax_463 = null; var v_ay_464 = null; var v_s_465 = null; var v_lx_466 = null; var v_ly_467 = null; var v_g_468 = null; var v_s_471 = null; var v_p_472 = null; var v_x_473 = null; var v_y_474 = null; var v_w_475 = null; var v_x_476 = null; var v_y_477 = null; var v_a_478 = null; var v_r_479 = null; var v_g_480 = null; var v_cw_481 = null; var v_x_482 = null; var v_y_483 = null
	var _s222 = {"__p": env, "this": null, "t": null, "ctx": null, "u": null}
	_s222["this"] = this_
	_s222["t"] = J.arg(a, 0)
	var _t382 = J.gp(_s222["this"], "_nat")
	if J.t(((not J.t(J.gp(_s222["this"], "_natCtx"))) if J.t(_t382) else _t382)):
		return null
	var _t384 = null
	if J.t(J.gp(_s222["this"], "_natCtx")):
		_t384 = null
	else:
		var _t383 = J.G.get("$")
		_t384 = J.cl(_t383, null, ["#gy-cvs"])
	v_c_432 = _t384
	var _t385 = (not J.t(J.gp(_s222["this"], "_natCtx")))
	if ((not J.t(v_c_432)) if _t385 else _t385):
		return null
	var _t386 = J.gp(_s222["this"], "_natCtx")
	_s222["ctx"] = (_t386 if J.t(_t386) else J.mc(v_c_432, "getContext", ["2d"]))
	v_dp_434 = (1.0 if J.t(J.gp(_s222["this"], "_natCtx")) else J.gp(_s222["this"], "dpr"))
	J.mc(_s222["ctx"], "setTransform", [v_dp_434, 0.0, 0.0, v_dp_434, 0.0, 0.0])
	v_W_435 = J.gp(_s222["this"], "W")
	v_H_436 = J.gp(_s222["this"], "H")
	v_b_437 = J.mc(_s222["this"], "bgScale", [])
	v_img_438 = J.gp(J.G.get("SPR"), "bg_graveyard")
	_s222["u"] = J.mc(_s222["this"], "unit", [])
	var _t387 = _s222["ctx"]
	J.sp(_t387, "fillStyle", "#0d0b10")
	J.mc(_s222["ctx"], "fillRect", [0.0, 0.0, v_W_435, v_H_436])
	var _t389 = v_img_438
	if J.t(_t389):
		var _t388 = J.G.get("sprOk")
		_t389 = J.cl(_t388, null, ["bg_graveyard"])
	if J.t(_t389):
		J.mc(_s222["ctx"], "drawImage", [v_img_438, J.gp(v_b_437, "ox"), J.gp(v_b_437, "oy"), J.mul(J.gp(v_b_437, "iw"), J.gp(v_b_437, "s")), J.mul(J.gp(v_b_437, "ih"), J.gp(v_b_437, "s"))])
	else:
		v_g_443 = J.mc(_s222["ctx"], "createLinearGradient", [0.0, 0.0, 0.0, v_H_436])
		J.mc(v_g_443, "addColorStop", [0.0, "#1c2030"])
		J.mc(v_g_443, "addColorStop", [1.0, "#2a2a22"])
		var _t390 = _s222["ctx"]
		J.sp(_t390, "fillStyle", v_g_443)
		J.mc(_s222["ctx"], "fillRect", [0.0, 0.0, v_W_435, v_H_436])
		for _t391 in J.keys(J.G.get("GY_SPOTS")):
			v_k_444 = _t391
			var _t392 = J.mc(_s222["this"], "pt", [J.gp(J.gp(J.G.get("GY_SPOTS"), v_k_444), "x"), J.gp(J.gp(J.G.get("GY_SPOTS"), v_k_444), "y")])
			var _t393 = J.gp(_t392, 0.0)
			v_x_445 = _t393
			var _t394 = J.gp(_t392, 1.0)
			v_y_446 = _t394
			var _t395 = _s222["ctx"]
			J.sp(_t395, "fillStyle", "#6a5038")
			J.mc(_s222["ctx"], "beginPath", [])
			J.mc(_s222["ctx"], "ellipse", [v_x_445, v_y_446, J.mul(62.0, _s222["u"]), J.mul(30.0, _s222["u"]), 0.0, 0.0, (PI * 2.0)])
			J.mc(_s222["ctx"], "fill", [])
	var _t396 = _s222["ctx"]
	J.sp(_t396, "fillStyle", "rgba(10,12,34,.18)")
	J.mc(_s222["ctx"], "fillRect", [0.0, 0.0, v_W_435, v_H_436])
	var _t397 = J.mc(_s222["this"], "pt", [0.25, 0.29])
	var _t398 = J.gp(_t397, 0.0)
	v_lx_447 = _t398
	var _t399 = J.gp(_t397, 1.0)
	v_ly_448 = _t399
	v_r_449 = (J.mul(60.0, _s222["u"]) * (1.0 + (0.06 * sin(J.num(J.mul(_s222["t"], 2.3))))))
	v_g_450 = J.mc(_s222["ctx"], "createRadialGradient", [v_lx_447, v_ly_448, 2.0, v_lx_447, v_ly_448, v_r_449])
	J.mc(v_g_450, "addColorStop", [0.0, "rgba(255,170,90,.32)"])
	J.mc(v_g_450, "addColorStop", [1.0, "rgba(255,140,60,0)"])
	var _t400 = _s222["ctx"]
	J.sp(_t400, "globalCompositeOperation", "lighter")
	var _t401 = _s222["ctx"]
	J.sp(_t401, "fillStyle", v_g_450)
	J.mc(_s222["ctx"], "fillRect", [J.sub(v_lx_447, v_r_449), J.sub(v_ly_448, v_r_449), J.mul(v_r_449, 2.0), J.mul(v_r_449, 2.0)])
	var _t402 = _s222["ctx"]
	J.sp(_t402, "globalCompositeOperation", "source-over")
	J.mc(_s222["this"], "fog", [_s222["ctx"], _s222["t"], 0.0])
	if J.t(J.gp(_s222["this"], "guide")):
		for _t403 in J.keys(J.G.get("GY_SPOTS")):
			v_k_451 = _t403
			v_sp_452 = J.gp(J.G.get("GY_SPOTS"), v_k_451)
			var _t404 = J.mc(_s222["this"], "pt", [J.gp(v_sp_452, "x"), J.gp(v_sp_452, "y")])
			var _t405 = J.gp(_t404, 0.0)
			v_x_453 = _t405
			var _t406 = J.gp(_t404, 1.0)
			v_y_454 = _t406
			var _t407 = J.gp(J.G.get("GY_ROWW"), J.gp(v_sp_452, "row"))
			var _t408 = [J.mc(_t407, "replace", ["那座", ""]), ("" if J.seq(J.gp(v_sp_452, "side"), 1.0) else J.gp(J.G.get("GY_SIDEW"), J.gp(v_sp_452, "side")))]
			var _t409 = J.mc(_t408, "filter", [J.G.get("Boolean")])
			v_lab_455 = J.add(J.mc(_t409, "join", ["・"]), ("・牌坊旁" if J.seq(v_k_451, "D") else ""))
			var _t410 = _s222["ctx"]
			var _t411 = ("800 " + J.str(J.round(J.num(J.mul(13.0, _s222["u"])))) + "px sans-serif")
			J.sp(_t410, "font", _t411)
			var _t412 = _s222["ctx"]
			J.sp(_t412, "textAlign", "center")
			v_w_456 = J.add(J.gp(J.mc(_s222["ctx"], "measureText", [v_lab_455]), "width"), 12.0)
			var _t413 = _s222["ctx"]
			J.sp(_t413, "fillStyle", "rgba(20,14,30,.82)")
			J.mc(_s222["ctx"], "beginPath", [])
			J.mc(_s222["ctx"], "roundRect", [J.sub(v_x_453, J.div(v_w_456, 2.0)), J.add(v_y_454, J.mul(14.0, _s222["u"])), v_w_456, J.mul(20.0, _s222["u"]), 6.0])
			J.mc(_s222["ctx"], "fill", [])
			var _t414 = _s222["ctx"]
			J.sp(_t414, "fillStyle", "#ffe9a8")
			J.mc(_s222["ctx"], "fillText", [v_lab_455, v_x_453, J.add(v_y_454, J.mul(29.0, _s222["u"]))])
	v_restK_440 = (J.min_([1.0, J.div(J.gp(_s222["this"], "restT"), 2.6)]) if J.cmp(J.gp(_s222["this"], "restT"), 0.0, ">") else 0.0)
	var _t415 = J.gp(J.gp(_s222["this"], "p"), "graves")
	J.mc(_t415, "forEach", [Callable(self, "_f118").bind(_s222)])
	var _t417 = (not J.leq(J.gp(_s222["this"], "sel"), null))
	if not J.t(_t417):
		var _t416 = J.gp(_s222["this"], "drag")
		_t417 = (J.gp(J.gp(_s222["this"], "drag"), "moved") if J.t(_t416) else _t416)
	if J.t(_t417):
		var _t418 = J.gp(J.gp(_s222["this"], "p"), "graves")
		J.mc(_t418, "forEach", [Callable(self, "_f119").bind(_s222)])
	var _t424 = J.mc(_s222["this"], "pt", [0.12, 0.965])
	var _t425 = J.gp(_t424, 0.0)
	v_ax_463 = _t425
	var _t426 = J.gp(_t424, 1.0)
	v_ay_464 = _t426
	v_s_465 = J.mul(1.2, _s222["u"])
	if (not J.seq(J.typeof_(J.G.get("ART")), "undefined")):
		var _t427 = J.G.get("__gyDC")
		J.cl(_t427, null, [_s222["ctx"], "afu", v_ax_463, v_ay_464, v_s_465, {"t": _s222["t"], "pose": "idle", "shadow": false}])
	v_lx_466 = J.add(v_ax_463, J.mul(30.0, _s222["u"]))
	v_ly_467 = (J.sub(v_ay_464, J.mul(46.0, _s222["u"])) + J.mul((sin(J.num(J.mul(_s222["t"], 1.8))) * 1.5), _s222["u"]))
	v_g_468 = J.mc(_s222["ctx"], "createRadialGradient", [v_lx_466, J.add(v_ly_467, J.mul(6.0, _s222["u"])), 1.0, v_lx_466, J.add(v_ly_467, J.mul(6.0, _s222["u"])), J.mul(46.0, _s222["u"])])
	J.mc(v_g_468, "addColorStop", [0.0, "rgba(255,190,110,.42)"])
	J.mc(v_g_468, "addColorStop", [1.0, "rgba(255,160,80,0)"])
	var _t428 = _s222["ctx"]
	J.sp(_t428, "globalCompositeOperation", "lighter")
	var _t429 = _s222["ctx"]
	J.sp(_t429, "fillStyle", v_g_468)
	J.mc(_s222["ctx"], "fillRect", [J.sub(v_lx_466, J.mul(46.0, _s222["u"])), J.sub(v_ly_467, J.mul(40.0, _s222["u"])), J.mul(92.0, _s222["u"]), J.mul(92.0, _s222["u"])])
	var _t430 = _s222["ctx"]
	J.sp(_t430, "globalCompositeOperation", "source-over")
	var _t431 = _s222["ctx"]
	J.sp(_t431, "strokeStyle", "#3a2a1a")
	var _t432 = _s222["ctx"]
	var _t433 = J.mul(2.0, _s222["u"])
	J.sp(_t432, "lineWidth", _t433)
	J.mc(_s222["ctx"], "beginPath", [])
	J.mc(_s222["ctx"], "moveTo", [J.add(v_ax_463, J.mul(14.0, _s222["u"])), J.sub(v_ay_464, J.mul(36.0, _s222["u"]))])
	J.mc(_s222["ctx"], "lineTo", [v_lx_466, J.sub(v_ly_467, J.mul(12.0, _s222["u"]))])
	J.mc(_s222["ctx"], "stroke", [])
	J.mc(_s222["ctx"], "save", [])
	J.mc(_s222["ctx"], "translate", [v_lx_466, v_ly_467])
	J.mc(_s222["ctx"], "scale", [J.mul(1.6, _s222["u"]), J.mul(1.6, _s222["u"])])
	if J.t(J.gp(J.G.get("ART"), "lantern")):
		J.mc(J.G.get("ART"), "lantern", [_s222["ctx"], 0.0, 0.0, _s222["t"], "#e0a040"])
	J.mc(_s222["ctx"], "restore", [])
	if J.t(J.gp(_s222["this"], "bub")):
		J.mc(_s222["this"], "bubble", [_s222["ctx"], J.gp(J.gp(_s222["this"], "bub"), "text"), J.add(v_ax_463, J.mul(10.0, _s222["u"])), J.sub(v_ay_464, J.mul(80.0, _s222["u"])), J.min_([1.0, J.mul(J.gp(J.gp(_s222["this"], "bub"), "life"), 2.0)])])
	var _t434 = J.mc(J.gp(_s222["this"], "souls"), "slice", [])
	v_order_441 = J.mc(_t434, "sort", [Callable(self, "_f120").bind(_s222)])
	for _t435 in J.iter(v_order_441):
		v_s_471 = _t435
		J.mc(_s222["this"], "drawSoul", [_s222["ctx"], v_s_471, _s222["t"], v_restK_440])
	for _t436 in J.iter(J.gp(_s222["this"], "parts")):
		v_p_472 = _t436
		var _t437 = J.mc(_s222["this"], "pt", [J.gp(v_p_472, "x"), J.gp(v_p_472, "y")])
		var _t438 = J.gp(_t437, 0.0)
		v_x_473 = _t438
		var _t439 = J.gp(_t437, 1.0)
		v_y_474 = _t439
		var _t440 = _s222["ctx"]
		var _t441 = J.min_([1.0, J.gp(v_p_472, "life")])
		J.sp(_t440, "globalAlpha", _t441)
		var _t442 = _s222["ctx"]
		var _t443 = J.gp(v_p_472, "col")
		var _t444 = (_t443 if J.t(_t443) else "#fff")
		J.sp(_t442, "fillStyle", _t444)
		J.mc(_s222["ctx"], "beginPath", [])
		J.mc(_s222["ctx"], "arc", [v_x_473, v_y_474, J.mul(2.4, _s222["u"]), 0.0, (PI * 2.0)])
		J.mc(_s222["ctx"], "fill", [])
		var _t445 = _s222["ctx"]
		J.sp(_t445, "globalAlpha", 1.0)
	for _t446 in J.iter(J.gp(_s222["this"], "wisps")):
		v_w_475 = _t446
		var _t447 = J.mc(_s222["this"], "pt", [J.gp(v_w_475, "x"), J.add(J.gp(v_w_475, "y"), (sin(J.num(J.mul(J.gp(v_w_475, "ph"), 2.0))) * 0.01))])
		var _t448 = J.gp(_t447, 0.0)
		v_x_476 = _t448
		var _t449 = J.gp(_t447, 1.0)
		v_y_477 = _t449
		v_a_478 = (0.45 + (0.35 * sin(J.num(J.mul(J.gp(v_w_475, "ph"), 3.0)))))
		v_r_479 = J.mul(14.0, _s222["u"])
		v_g_480 = J.mc(_s222["ctx"], "createRadialGradient", [v_x_476, v_y_477, 0.0, v_x_476, v_y_477, v_r_479])
		J.mc(v_g_480, "addColorStop", [0.0, ("rgba(170,255,240," + J.str(v_a_478) + ")")])
		J.mc(v_g_480, "addColorStop", [0.35, ("rgba(90,220,210," + J.str(J.mul(v_a_478, 0.45)) + ")")])
		J.mc(v_g_480, "addColorStop", [1.0, "rgba(60,200,200,0)"])
		var _t450 = _s222["ctx"]
		J.sp(_t450, "globalCompositeOperation", "lighter")
		var _t451 = _s222["ctx"]
		J.sp(_t451, "fillStyle", v_g_480)
		J.mc(_s222["ctx"], "beginPath", [])
		J.mc(_s222["ctx"], "arc", [v_x_476, v_y_477, v_r_479, 0.0, (PI * 2.0)])
		J.mc(_s222["ctx"], "fill", [])
		var _t452 = _s222["ctx"]
		J.sp(_t452, "globalCompositeOperation", "source-over")
	for _t453 in J.iter(J.gp(_s222["this"], "crows")):
		v_cw_481 = _t453
		if J.cmp(J.gp(v_cw_481, "delay"), 0.0, ">"):
			continue
		var _t454 = J.mc(_s222["this"], "pt", [J.gp(v_cw_481, "x"), J.gp(v_cw_481, "y")])
		var _t455 = J.gp(_t454, 0.0)
		v_x_482 = _t455
		var _t456 = J.gp(_t454, 1.0)
		v_y_483 = _t456
		var _t457 = _s222["ctx"]
		var _t458 = J.min_([1.0, J.gp(v_cw_481, "life")])
		J.sp(_t457, "globalAlpha", _t458)
		if J.t(J.gp(J.G.get("ART"), "drawCrow")):
			J.mc(J.G.get("ART"), "drawCrow", [_s222["ctx"], v_x_482, v_y_483, J.mul(J.mul(J.gp(v_cw_481, "s"), 1.4), _s222["u"]), J.gp(v_cw_481, "ph"), 1.0, false])
		var _t459 = _s222["ctx"]
		J.sp(_t459, "globalAlpha", 1.0)
	J.mc(_s222["this"], "fog", [_s222["ctx"], _s222["t"], 1.0])
	if J.cmp(v_restK_440, 0.0, ">"):
		var _t460 = _s222["ctx"]
		var _t461 = ("rgba(255,240,200," + J.str((0.12 * sin(J.num(J.mul(v_restK_440, PI))))) + ")")
		J.sp(_t460, "fillStyle", _t461)
		J.mc(_s222["ctx"], "fillRect", [0.0, 0.0, v_W_435, v_H_436])
	v_vg_442 = J.mc(_s222["ctx"], "createRadialGradient", [J.div(v_W_435, 2.0), J.mul(v_H_436, 0.55), J.mul(v_H_436, 0.3), J.div(v_W_435, 2.0), J.mul(v_H_436, 0.55), J.mul(v_H_436, 0.85)])
	J.mc(v_vg_442, "addColorStop", [0.0, "rgba(0,0,0,0)"])
	J.mc(v_vg_442, "addColorStop", [1.0, "rgba(0,0,0,.5)"])
	var _t462 = _s222["ctx"]
	J.sp(_t462, "fillStyle", v_vg_442)
	J.mc(_s222["ctx"], "fillRect", [0.0, 0.0, v_W_435, v_H_436])

func _f121(this_, a: Array, env):
	var v_ctx_486 = null; var v_t_487 = null; var v_front_488 = null; var v_W_489 = null; var v_u_490 = null; var v_i_491 = null; var v_fy_492 = null; var v_sp_493 = null; var v_fx_494 = null; var v_x_495 = null; var v_y_496 = null; var v_rx_497 = null; var v_ry_498 = null; var v_a_499 = null; var v_g_500 = null
	v_ctx_486 = J.arg(a, 0)
	v_t_487 = J.arg(a, 1)
	v_front_488 = J.arg(a, 2)
	v_W_489 = J.gp(this_, "W")
	v_u_490 = J.mc(this_, "unit", [])
	v_i_491 = 0.0
	while true:
		if not J.cmp(v_i_491, 4.0, "<"): break
		v_fy_492 = ((0.86 + J.mul(v_i_491, 0.03)) if J.t(v_front_488) else (0.5 + J.mul(v_i_491, 0.09)))
		v_sp_493 = ((0.012 if J.t(v_front_488) else 0.008) * (1.0 if J.t(J.mod(v_i_491, 2.0)) else (-1.0)))
		v_fx_494 = (J.mod((J.mod((J.mul(v_i_491, 0.37) + J.mul(v_t_487, v_sp_493)), 1.4) + 1.4), 1.4) - 0.2)
		var _t463 = J.mc(this_, "pt", [v_fx_494, v_fy_492])
		var _t464 = J.gp(_t463, 0.0)
		v_x_495 = _t464
		var _t465 = J.gp(_t463, 1.0)
		v_y_496 = _t465
		v_rx_497 = J.mul(v_W_489, 0.55)
		v_ry_498 = J.mul(34.0, v_u_490)
		v_a_499 = (0.1 if J.t(v_front_488) else 0.09)
		J.mc(v_ctx_486, "save", [])
		J.mc(v_ctx_486, "translate", [v_x_495, v_y_496])
		J.mc(v_ctx_486, "scale", [1.0, J.div(v_ry_498, v_rx_497)])
		v_g_500 = J.mc(v_ctx_486, "createRadialGradient", [0.0, 0.0, 0.0, 0.0, 0.0, v_rx_497])
		J.mc(v_g_500, "addColorStop", [0.0, ("rgba(200,210,230," + J.str(v_a_499) + ")")])
		J.mc(v_g_500, "addColorStop", [1.0, "rgba(200,210,230,0)"])
		J.sp(v_ctx_486, "fillStyle", v_g_500)
		J.mc(v_ctx_486, "beginPath", [])
		J.mc(v_ctx_486, "arc", [0.0, 0.0, v_rx_497, 0.0, (PI * 2.0)])
		J.mc(v_ctx_486, "fill", [])
		J.mc(v_ctx_486, "restore", [])
		v_i_491 = J.num(v_i_491) + 1.0

func _f123(this_, a: Array, env):
	J.mc(env["__p"]["ctx"], "beginPath", [])
	J.mc(env["__p"]["ctx"], "moveTo", [env["x"], J.sub(J.gp(env["__p"]["r"], "by"), J.mul(6.0, env["__p"]["u"]))])
	J.mc(env["__p"]["ctx"], "lineTo", [env["x"], J.add(env["y"], env["rr"])])
	J.mc(env["__p"]["ctx"], "arc", [J.add(env["x"], env["rr"]), J.add(env["y"], env["rr"]), env["rr"], PI, 0.0])
	J.mc(env["__p"]["ctx"], "lineTo", [J.add(env["x"], env["w"]), J.sub(J.gp(env["__p"]["r"], "by"), J.mul(6.0, env["__p"]["u"]))])
	J.mc(env["__p"]["ctx"], "closePath", [])

func _f124(this_, a: Array, env):
	var v_ch_534 = null; var v_k_535 = null; var v_yy_536 = null
	v_ch_534 = J.arg(a, 0)
	v_k_535 = J.arg(a, 1)
	v_yy_536 = J.add(env["y1"], (J.mul(v_k_535, env["fs"]) * 1.04))
	var _t489 = env["__p"]["ctx"]
	J.sp(_t489, "fillStyle", "rgba(255,255,255,.3)")
	J.mc(env["__p"]["ctx"], "fillText", [v_ch_534, J.add(J.gp(env["__p"]["tab"], "cx"), 0.7), J.add(v_yy_536, 0.7)])
	var _t490 = env["__p"]["ctx"]
	J.sp(_t490, "fillStyle", "#8a1e16")
	J.mc(env["__p"]["ctx"], "fillText", [v_ch_534, J.gp(env["__p"]["tab"], "cx"), v_yy_536])

func _f125(this_, a: Array, env):
	var v_ch_538 = null; var v_k_539 = null; var v_yy_540 = null
	v_ch_538 = J.arg(a, 0)
	v_k_539 = J.arg(a, 1)
	v_yy_540 = J.add(J.add(J.gp(env["__p"]["r"], "y"), J.mul(20.0, env["__p"]["u"])), J.mul(v_k_539, J.add(env["fs"], 1.0)))
	var _t496 = env["__p"]["ctx"]
	J.sp(_t496, "fillStyle", "rgba(255,255,255,.25)")
	J.mc(env["__p"]["ctx"], "fillText", [v_ch_538, J.add(J.gp(env["__p"]["r"], "cx"), 0.8), J.add(v_yy_540, 0.8)])
	var _t497 = env["__p"]["ctx"]
	J.sp(_t497, "fillStyle", "#1e1c22")
	J.mc(env["__p"]["ctx"], "fillText", [v_ch_538, J.gp(env["__p"]["r"], "cx"), v_yy_540])

func _f122(this_, a: Array, env):
	var v_g_504 = null; var v_gi_505 = null; var v_t_506 = null; var v_view_509 = null; var v_tk_510 = null; var v_im_512 = null; var v_w_513 = null; var v_h_514 = null; var v_x0_515 = null; var v_y0_516 = null; var v_T_517 = null; var v_h_521 = null; var v_path_523 = null; var v_gr_524 = null; var v_a_525 = null; var v_b2_526 = null; var v_ang_527 = null; var v_k_528 = null; var v_sx_529 = null; var v_sy_530 = null; var v_chs_531 = null; var v_k_541 = null; var v_hx_542 = null; var v_hy_543 = null; var v_fs_544 = null; var v_txt_545 = null; var v_tw_546 = null; var v_th_547 = null; var v_ty_548 = null
	var _s244 = {"__p": env, "ctx": null, "r": null, "u": null, "tab": null}
	_s244["ctx"] = J.arg(a, 0)
	v_g_504 = J.arg(a, 1)
	v_gi_505 = J.arg(a, 2)
	v_t_506 = J.arg(a, 3)
	_s244["r"] = J.mc(this_, "stoneRect", [v_gi_505])
	_s244["u"] = J.mc(this_, "unit", [])
	var _t466 = J.seq(J.gp(J.gp(this_, "view"), "k"), "grave")
	v_view_509 = (J.seq(J.gp(J.gp(this_, "view"), "i"), v_gi_505) if _t466 else _t466)
	J.mc(_s244["ctx"], "save", [])
	var _t467 = _s244["ctx"]
	J.sp(_t467, "fillStyle", "rgba(0,0,0,.35)")
	J.mc(_s244["ctx"], "beginPath", [])
	J.mc(_s244["ctx"], "ellipse", [J.gp(_s244["r"], "cx"), J.gp(_s244["r"], "by"), J.mul(J.gp(_s244["r"], "w"), 0.62), J.mul(7.0, _s244["u"]), 0.0, 0.0, (PI * 2.0)])
	J.mc(_s244["ctx"], "fill", [])
	v_tk_510 = J.add("tomb", (J.mod(v_gi_505, 4.0) + 1.0))
	_s244["tab"] = null
	var _t468 = J.G.get("sprOk")
	if J.t(J.cl(_t468, null, [v_tk_510])):
		v_im_512 = J.gp(J.G.get("SPR"), v_tk_510)
		v_w_513 = J.mul(J.gp(_s244["r"], "w"), 2.25)
		v_h_514 = J.div(J.mul(v_w_513, J.gp(v_im_512, "naturalHeight")), J.gp(v_im_512, "naturalWidth"))
		v_x0_515 = J.sub(J.gp(_s244["r"], "cx"), J.div(v_w_513, 2.0))
		v_y0_516 = J.sub(J.add(J.gp(_s244["r"], "by"), J.mul(4.0, _s244["u"])), v_h_514)
		v_T_517 = J.gp(J.G.get("GY_TOMB_TAB"), J.mod(v_gi_505, 4.0))
		J.mc(_s244["ctx"], "drawImage", [v_im_512, v_x0_515, v_y0_516, v_w_513, v_h_514])
		var _t469 = {"cx": J.add(v_x0_515, J.mul(J.gp(v_T_517, 0.0), v_w_513)), "top": J.add(v_y0_516, J.mul(J.gp(v_T_517, 1.0), v_h_514)), "bot": J.add(v_y0_516, J.mul(J.gp(v_T_517, 2.0), v_h_514)), "w": J.mul(J.sub(J.gp(v_T_517, 4.0), J.gp(v_T_517, 3.0)), v_w_513)}
		_s244["tab"] = _t469
	else:
		var _s246 = {"__p": _s244, "x": null, "y": null, "w": null, "rr": null}
		_s246["x"] = J.gp(_s246["__p"]["r"], "x")
		_s246["y"] = J.gp(_s246["__p"]["r"], "y")
		_s246["w"] = J.gp(_s246["__p"]["r"], "w")
		v_h_521 = J.gp(_s246["__p"]["r"], "h")
		_s246["rr"] = J.div(_s246["w"], 2.0)
		v_path_523 = Callable(self, "_f123").bind(_s246)
		v_gr_524 = J.mc(_s246["__p"]["ctx"], "createLinearGradient", [_s246["x"], _s246["y"], J.add(_s246["x"], _s246["w"]), J.gp(_s246["__p"]["r"], "by")])
		J.mc(v_gr_524, "addColorStop", [0.0, "#9aa0a6"])
		J.mc(v_gr_524, "addColorStop", [1.0, "#5c6168"])
		var _t470 = _s246["__p"]["ctx"]
		J.sp(_t470, "fillStyle", v_gr_524)
		J.cl(v_path_523, null, [])
		J.mc(_s246["__p"]["ctx"], "fill", [])
		J.mc(_s246["__p"]["ctx"], "save", [])
		J.cl(v_path_523, null, [])
		J.mc(_s246["__p"]["ctx"], "clip", [])
		for _t471 in J.iter(J.gp(J.gp(this_, "stones"), v_gi_505)):
			var _t472 = J.gp(_t471, 0.0)
			v_a_525 = _t472
			var _t473 = J.gp(_t471, 1.0)
			v_b2_526 = _t473
			var _t474 = J.gp(_t471, 2.0)
			v_ang_527 = _t474
			var _t475 = J.gp(_t471, 3.0)
			v_k_528 = _t475
			var _t476 = _s246["__p"]["ctx"]
			var _t477 = ("rgba(255,255,255,.13)" if J.cmp(v_k_528, 0.5, ">") else "rgba(30,30,40,.16)")
			J.sp(_t476, "strokeStyle", _t477)
			var _t478 = _s246["__p"]["ctx"]
			var _t479 = J.mul(1.6, _s246["__p"]["u"])
			J.sp(_t478, "lineWidth", _t479)
			v_sx_529 = J.add(_s246["x"], J.mul(v_a_525, _s246["w"]))
			v_sy_530 = J.add(_s246["y"], J.mul(v_b2_526, v_h_521))
			J.mc(_s246["__p"]["ctx"], "beginPath", [])
			J.mc(_s246["__p"]["ctx"], "moveTo", [v_sx_529, v_sy_530])
			J.mc(_s246["__p"]["ctx"], "lineTo", [J.add(v_sx_529, J.mul(10.0, _s246["__p"]["u"])), J.add(v_sy_530, J.mul(J.mul(v_ang_527, 10.0), _s246["__p"]["u"]))])
			J.mc(_s246["__p"]["ctx"], "stroke", [])
		var _t480 = _s246["__p"]["ctx"]
		J.sp(_t480, "fillStyle", "rgba(80,110,60,.5)")
		J.mc(_s246["__p"]["ctx"], "beginPath", [])
		J.mc(_s246["__p"]["ctx"], "ellipse", [J.add(_s246["x"], J.mul(_s246["w"], 0.2)), J.sub(J.gp(_s246["__p"]["r"], "by"), J.mul(7.0, _s246["__p"]["u"])), J.mul(9.0, _s246["__p"]["u"]), J.mul(4.0, _s246["__p"]["u"]), 0.0, 0.0, (PI * 2.0)])
		J.mc(_s246["__p"]["ctx"], "fill", [])
		J.mc(_s246["__p"]["ctx"], "restore", [])
		var _t481 = _s246["__p"]["ctx"]
		J.sp(_t481, "strokeStyle", "#26232a")
		var _t482 = _s246["__p"]["ctx"]
		var _t483 = J.mul(2.4, _s246["__p"]["u"])
		J.sp(_t482, "lineWidth", _t483)
		J.cl(v_path_523, null, [])
		J.mc(_s246["__p"]["ctx"], "stroke", [])
		var _t484 = _s246["__p"]["ctx"]
		J.sp(_t484, "fillStyle", "#4a4e55")
		J.mc(_s246["__p"]["ctx"], "fillRect", [J.sub(_s246["x"], J.mul(5.0, _s246["__p"]["u"])), J.sub(J.gp(_s246["__p"]["r"], "by"), J.mul(7.0, _s246["__p"]["u"])), J.add(_s246["w"], J.mul(10.0, _s246["__p"]["u"])), J.mul(7.0, _s246["__p"]["u"])])
		J.mc(_s246["__p"]["ctx"], "strokeRect", [J.sub(_s246["x"], J.mul(5.0, _s246["__p"]["u"])), J.sub(J.gp(_s246["__p"]["r"], "by"), J.mul(7.0, _s246["__p"]["u"])), J.add(_s246["w"], J.mul(10.0, _s246["__p"]["u"])), J.mul(7.0, _s246["__p"]["u"])])
	if J.t(_s244["tab"]):
		var _s250 = {"__p": _s244, "fs": null, "y1": null}
		v_chs_531 = J.spread([J.SP(J.gp(v_g_504, "name"))])
		_s250["fs"] = J.min_([J.mul(J.gp(_s250["__p"]["tab"], "w"), 0.62), J.div(J.sub(J.gp(_s250["__p"]["tab"], "bot"), J.gp(_s250["__p"]["tab"], "top")), (J.len(v_chs_531) + 0.6))])
		var _t485 = _s250["__p"]["ctx"]
		var _t486 = ("900 " + J.str(_s250["fs"]) + "px \"Songti TC\",\"Noto Serif CJK TC\",serif")
		J.sp(_t485, "font", _t486)
		var _t487 = _s250["__p"]["ctx"]
		J.sp(_t487, "textAlign", "center")
		var _t488 = _s250["__p"]["ctx"]
		J.sp(_t488, "textBaseline", "middle")
		_s250["y1"] = (J.div(J.add(J.gp(_s250["__p"]["tab"], "top"), J.gp(_s250["__p"]["tab"], "bot")), 2.0) - (J.mul((J.len(v_chs_531) - 1.0), _s250["fs"]) * 0.52))
		J.mc(v_chs_531, "forEach", [Callable(self, "_f124").bind(_s250)])
		var _t491 = _s250["__p"]["ctx"]
		J.sp(_t491, "textBaseline", "alphabetic")
	else:
		var _s252 = {"__p": _s244, "fs": null}
		_s252["fs"] = J.round(J.num(J.mul(12.5, _s252["__p"]["u"])))
		var _t492 = _s252["__p"]["ctx"]
		var _t493 = ("900 " + J.str(_s252["fs"]) + "px \"Songti TC\",\"Noto Serif CJK TC\",serif")
		J.sp(_t492, "font", _t493)
		var _t494 = _s252["__p"]["ctx"]
		J.sp(_t494, "textAlign", "center")
		var _t495 = J.spread([J.SP(J.gp(v_g_504, "name"))])
		J.mc(_t495, "forEach", [Callable(self, "_f125").bind(_s252)])
	if (not J.t(_s244["tab"])):
		v_k_541 = (-1.0)
		while true:
			if not J.cmp(v_k_541, 1.0, "<="): break
			v_hx_542 = J.sub(J.add(J.gp(_s244["r"], "cx"), J.mul(J.mul(v_k_541, 5.0), _s244["u"])), J.mul(J.gp(_s244["r"], "w"), 0.66))
			v_hy_543 = J.add(J.gp(_s244["r"], "by"), J.mul(2.0, _s244["u"]))
			var _t498 = _s244["ctx"]
			J.sp(_t498, "strokeStyle", "#b8742a")
			var _t499 = _s244["ctx"]
			var _t500 = J.mul(1.4, _s244["u"])
			J.sp(_t499, "lineWidth", _t500)
			J.mc(_s244["ctx"], "beginPath", [])
			J.mc(_s244["ctx"], "moveTo", [v_hx_542, v_hy_543])
			J.mc(_s244["ctx"], "lineTo", [J.add(v_hx_542, J.mul(J.mul(v_k_541, 1.5), _s244["u"])), J.sub(v_hy_543, J.mul(14.0, _s244["u"]))])
			J.mc(_s244["ctx"], "stroke", [])
			var _t501 = _s244["ctx"]
			var _t502 = ("rgba(255," + J.str((120.0 + (60.0 * sin(J.num(J.add(J.add(J.mul(v_t_506, 5.0), v_k_541), v_gi_505)))))) + ",60,.95)")
			J.sp(_t501, "fillStyle", _t502)
			J.mc(_s244["ctx"], "beginPath", [])
			J.mc(_s244["ctx"], "arc", [J.add(v_hx_542, J.mul(J.mul(v_k_541, 1.5), _s244["u"])), J.sub(v_hy_543, J.mul(14.0, _s244["u"])), J.mul(1.6, _s244["u"]), 0.0, (PI * 2.0)])
			J.mc(_s244["ctx"], "fill", [])
			v_k_541 = J.num(v_k_541) + 1.0
	if J.t(v_view_509):
		var _t503 = _s244["ctx"]
		J.sp(_t503, "strokeStyle", "rgba(255,230,140,.9)")
		var _t504 = _s244["ctx"]
		J.sp(_t504, "lineWidth", 2.5)
		J.mc(_s244["ctx"], "beginPath", [])
		J.mc(_s244["ctx"], "roundRect", [J.sub(J.gp(_s244["r"], "x"), J.mul(6.0, _s244["u"])), J.sub(J.gp(_s244["r"], "y"), J.mul(6.0, _s244["u"])), J.add(J.gp(_s244["r"], "w"), J.mul(12.0, _s244["u"])), J.add(J.gp(_s244["r"], "h"), J.mul(8.0, _s244["u"])), J.mul(10.0, _s244["u"])])
		J.mc(_s244["ctx"], "stroke", [])
	if J.t(J.gp(v_g_504, "off")):
		v_fs_544 = J.max_([11.0, J.round(J.num(J.mul(11.5, _s244["u"])))])
		var _t505 = _s244["ctx"]
		var _t506 = ("800 " + J.str(v_fs_544) + "px \"PingFang TC\",\"Noto Sans CJK TC\",sans-serif")
		J.sp(_t505, "font", _t506)
		var _t507 = _s244["ctx"]
		J.sp(_t507, "textAlign", "center")
		var _t508 = _s244["ctx"]
		J.sp(_t508, "textBaseline", "middle")
		v_txt_545 = J.add("祭品・", J.gp(v_g_504, "off"))
		v_tw_546 = J.add(J.gp(J.mc(_s244["ctx"], "measureText", [v_txt_545]), "width"), J.mul(12.0, _s244["u"]))
		v_th_547 = J.add(v_fs_544, J.mul(8.0, _s244["u"]))
		v_ty_548 = J.add(J.add(J.gp(_s244["r"], "by"), J.mul(10.0, _s244["u"])), J.div(v_th_547, 2.0))
		var _t509 = _s244["ctx"]
		J.sp(_t509, "fillStyle", "rgba(250,240,214,.94)")
		var _t510 = _s244["ctx"]
		J.sp(_t510, "strokeStyle", "#6b4a2b")
		var _t511 = _s244["ctx"]
		var _t512 = J.mul(1.6, _s244["u"])
		J.sp(_t511, "lineWidth", _t512)
		J.mc(_s244["ctx"], "beginPath", [])
		J.mc(_s244["ctx"], "roundRect", [J.sub(J.gp(_s244["r"], "cx"), J.div(v_tw_546, 2.0)), J.sub(v_ty_548, J.div(v_th_547, 2.0)), v_tw_546, v_th_547, J.mul(5.0, _s244["u"])])
		J.mc(_s244["ctx"], "fill", [])
		J.mc(_s244["ctx"], "stroke", [])
		var _t513 = _s244["ctx"]
		J.sp(_t513, "fillStyle", "#3a2614")
		J.mc(_s244["ctx"], "fillText", [v_txt_545, J.gp(_s244["r"], "cx"), J.add(v_ty_548, 0.5)])
		var _t514 = _s244["ctx"]
		J.sp(_t514, "textBaseline", "alphabetic")
	J.mc(_s244["ctx"], "restore", [])

func _f126(this_, a: Array, env):
	var v_ctx_551 = null; var v_s_552 = null; var v_t_553 = null; var v_restK_554 = null; var v_u_555 = null; var v_hh_556 = null; var v_d_557 = null; var v_x_558 = null; var v_y_559 = null; var v_pose_560 = null; var v_pt_561 = null; var v_alpha_562 = null; var v_lift_563 = null; var v_flip_564 = null; var v_g_565 = null; var v_ty_566 = null; var v_r_567 = null
	v_ctx_551 = J.arg(a, 0)
	v_s_552 = J.arg(a, 1)
	v_t_553 = J.arg(a, 2)
	v_restK_554 = J.arg(a, 3)
	v_u_555 = J.mc(this_, "unit", [])
	v_hh_556 = J.mc(this_, "soulH", [])
	var _t515 = J.gp(this_, "drag")
	var _t516 = (J.seq(J.gp(J.gp(this_, "drag"), "s"), v_s_552) if J.t(_t515) else _t515)
	v_d_557 = (J.gp(this_, "drag") if J.t((J.gp(J.gp(this_, "drag"), "moved") if J.t(_t516) else _t516)) else null)
	var _t517 = J.mc(this_, "pt", [J.gp(v_s_552, "x"), J.gp(v_s_552, "y")])
	var _t518 = J.gp(_t517, 0.0)
	v_x_558 = _t518
	var _t519 = J.gp(_t517, 1.0)
	v_y_559 = _t519
	if J.t(v_d_557):
		v_x_558 = J.gp(v_d_557, "mx")
		var _t520 = J.add(J.gp(v_d_557, "my"), J.mul(18.0, v_u_555))
		v_y_559 = _t520
	v_pose_560 = ("idle" if (not J.leq(J.gp(v_s_552, "place"), null)) else "idle")
	v_pt_561 = 0.0
	v_alpha_562 = J.gp(v_s_552, "a")
	v_lift_563 = 0.0
	v_flip_564 = false
	if J.t(v_d_557):
		v_pose_560 = "move"
	if (not J.leq(J.gp(v_s_552, "place"), null)):
		v_flip_564 = true
	var _t521 = J.gp(v_s_552, "rx")
	if J.t((J.cmp(J.gp(J.gp(v_s_552, "rx"), "t"), 0.0, ">=") if J.t(_t521) else _t521)):
		v_pose_560 = "hurt"
		var _t522 = J.min_([1.0, J.div(J.gp(J.gp(v_s_552, "rx"), "t"), J.gp(J.gp(v_s_552, "rx"), "dur"))])
		v_pt_561 = _t522
		var _t523 = J.add(v_x_558, (J.mul((sin(J.num(J.mul(J.gp(J.gp(v_s_552, "rx"), "t"), 40.0))) * 3.0), v_u_555) * J.sub(1.0, v_pt_561)))
		v_x_558 = _t523
	if J.cmp(v_restK_554, 0.0, ">"):
		v_pose_560 = "cast"
		v_pt_561 = v_restK_554
		var _t524 = (J.mul(J.mul(v_restK_554, v_restK_554), v_hh_556) * 1.6)
		v_lift_563 = _t524
		var _t525 = J.mul(J.gp(v_s_552, "a"), (1.0 - J.max_([0.0, J.div(J.sub(v_restK_554, 0.45), 0.55)])))
		v_alpha_562 = _t525
	J.sp(v_s_552, "px", v_x_558)
	J.sp(v_s_552, "py", v_y_559)
	if J.cmp(v_alpha_562, 0.01, "<="):
		return null
	v_g_565 = J.mc(v_ctx_551, "createRadialGradient", [v_x_558, J.sub(J.sub(v_y_559, J.mul(v_hh_556, 0.5)), v_lift_563), 2.0, v_x_558, J.sub(J.sub(v_y_559, J.mul(v_hh_556, 0.5)), v_lift_563), J.mul(v_hh_556, (0.75 + J.mul(v_restK_554, 0.8)))])
	J.mc(v_g_565, "addColorStop", [0.0, J.mc(this_, "rgba", [J.gp(v_s_552, "col"), (J.mul((0.55 if J.seq(J.gp(this_, "sel"), J.gp(v_s_552, "i")) else 0.3), v_alpha_562) + J.mul(v_restK_554, 0.3))])])
	J.mc(v_g_565, "addColorStop", [1.0, J.mc(this_, "rgba", [J.gp(v_s_552, "col"), 0.0])])
	J.sp(v_ctx_551, "globalCompositeOperation", "lighter")
	J.sp(v_ctx_551, "fillStyle", v_g_565)
	J.mc(v_ctx_551, "beginPath", [])
	J.mc(v_ctx_551, "arc", [v_x_558, J.sub(J.sub(v_y_559, J.mul(v_hh_556, 0.5)), v_lift_563), J.mul(v_hh_556, (0.75 + J.mul(v_restK_554, 0.8))), 0.0, (PI * 2.0)])
	J.mc(v_ctx_551, "fill", [])
	J.sp(v_ctx_551, "globalCompositeOperation", "source-over")
	if J.seq(J.gp(this_, "sel"), J.gp(v_s_552, "i")):
		var _t526 = J.mc(this_, "rgba", [J.gp(v_s_552, "col"), 0.9])
		J.sp(v_ctx_551, "strokeStyle", _t526)
		J.sp(v_ctx_551, "lineWidth", 2.5)
		J.mc(v_ctx_551, "setLineDash", [[5.0, 4.0]])
		J.mc(v_ctx_551, "beginPath", [])
		J.mc(v_ctx_551, "ellipse", [v_x_558, v_y_559, J.mul(v_hh_556, 0.4), J.mul(v_hh_556, 0.11), 0.0, 0.0, (PI * 2.0)])
		J.mc(v_ctx_551, "stroke", [])
		J.mc(v_ctx_551, "setLineDash", [[]])
	if (not J.seq(J.typeof_(J.G.get("ART")), "undefined")):
		var _t527 = J.G.get("__gyDC")
		J.cl(_t527, null, [v_ctx_551, "youhun", v_x_558, J.sub(v_y_559, v_lift_563), J.div(v_hh_556, 50.0), {"t": J.add(J.mul(v_t_553, (1.5 if J.seq(v_pose_560, "hurt") else 1.0)), J.gp(v_s_552, "ph")), "pose": v_pose_560, "pt": v_pt_561, "flip": v_flip_564, "alpha": v_alpha_562, "shadow": false}])
	v_ty_566 = (J.sub(J.sub(v_y_559, J.mul(v_hh_556, 1.1)), v_lift_563) + J.mul((sin(J.num(J.add(J.mul(v_t_553, 2.0), J.gp(v_s_552, "ph")))) * 3.0), v_u_555))
	v_r_567 = J.mul(13.0, v_u_555)
	var _t528 = J.min_([1.0, J.mul(v_alpha_562, 1.15)])
	J.sp(v_ctx_551, "globalAlpha", _t528)
	J.sp(v_ctx_551, "fillStyle", "rgba(14,10,20,.85)")
	J.mc(v_ctx_551, "beginPath", [])
	J.mc(v_ctx_551, "arc", [v_x_558, v_ty_566, v_r_567, 0.0, (PI * 2.0)])
	J.mc(v_ctx_551, "fill", [])
	var _t529 = J.gp(v_s_552, "col")
	J.sp(v_ctx_551, "strokeStyle", _t529)
	J.sp(v_ctx_551, "lineWidth", 2.2)
	J.mc(v_ctx_551, "stroke", [])
	var _t530 = ("900 " + J.str(J.round(J.num(J.mul(18.0, v_u_555)))) + "px sans-serif")
	J.sp(v_ctx_551, "font", _t530)
	J.sp(v_ctx_551, "textAlign", "center")
	J.sp(v_ctx_551, "textBaseline", "middle")
	var _t531 = J.gp(v_s_552, "col")
	J.sp(v_ctx_551, "fillStyle", _t531)
	J.mc(v_ctx_551, "fillText", [J.gp(v_s_552, "tag"), v_x_558, J.add(v_ty_566, 1.0)])
	J.sp(v_ctx_551, "textBaseline", "alphabetic")
	J.sp(v_ctx_551, "globalAlpha", 1.0)

func _f127(this_, a: Array, env):
	var v_hex_570 = null; var v_a_571 = null; var v_v_572 = null
	v_hex_570 = J.arg(a, 0)
	v_a_571 = J.arg(a, 1)
	v_v_572 = J.F_parseInt([J.mc(v_hex_570, "slice", [1.0]), 16.0])
	return ("rgba(" + J.str(J.band(J.shr(v_v_572, 16.0), 255.0)) + "," + J.str(J.band(J.shr(v_v_572, 8.0), 255.0)) + "," + J.str(J.band(v_v_572, 255.0)) + "," + J.str(J.max_([0.0, J.min_([1.0, v_a_571])])) + ")")

func _f129(this_, a: Array, env):
	var v_l_590 = null
	v_l_590 = J.arg(a, 0)
	return J.gp(J.mc(env["ctx"], "measureText", [v_l_590]), "width")

func _f130(this_, a: Array, env):
	var v_l_591 = null; var v_i_592 = null
	v_l_591 = J.arg(a, 0)
	v_i_592 = J.arg(a, 1)
	return J.mc(env["ctx"], "fillText", [v_l_591, J.add(env["bx"], 9.0), J.add(J.add(env["by"], 6.0), J.mul(env["lh"], J.add(v_i_592, 0.78)))])

func _f128(this_, a: Array, env):
	var v_text_576 = null; var v_x_577 = null; var v_y_578 = null; var v_a_579 = null; var v_u_580 = null; var v_maxW_581 = null; var v_lines_582 = null; var v_cur_583 = null; var v_w_585 = null; var v_h_586 = null; var v_ch_589 = null
	var _s265 = {"__p": env, "ctx": null, "lh": null, "bx": null, "by": null}
	_s265["ctx"] = J.arg(a, 0)
	v_text_576 = J.arg(a, 1)
	v_x_577 = J.arg(a, 2)
	v_y_578 = J.arg(a, 3)
	v_a_579 = J.arg(a, 4)
	v_u_580 = J.mc(this_, "unit", [])
	J.mc(_s265["ctx"], "save", [])
	var _t532 = _s265["ctx"]
	J.sp(_t532, "globalAlpha", v_a_579)
	var _t533 = _s265["ctx"]
	var _t534 = ("700 " + J.str(J.round(J.num(J.mul(14.0, v_u_580)))) + "px sans-serif")
	J.sp(_t533, "font", _t534)
	v_maxW_581 = J.mul(J.gp(this_, "W"), 0.62)
	v_lines_582 = []
	v_cur_583 = ""
	for _t535 in J.iter(v_text_576):
		v_ch_589 = _t535
		if J.cmp(J.gp(J.mc(_s265["ctx"], "measureText", [J.add(v_cur_583, v_ch_589)]), "width"), v_maxW_581, ">"):
			J.mc(v_lines_582, "push", [v_cur_583])
			v_cur_583 = v_ch_589
		else:
			var _t536 = J.add(v_cur_583, v_ch_589)
			v_cur_583 = _t536
	J.mc(v_lines_582, "push", [v_cur_583])
	_s265["lh"] = J.mul(19.0, v_u_580)
	v_w_585 = (J.max_(J.spread([J.SP(J.mc(v_lines_582, "map", [Callable(self, "_f129").bind(_s265)]))])) + 18.0)
	v_h_586 = (J.mul(J.len(v_lines_582), _s265["lh"]) + 12.0)
	_s265["bx"] = J.max_([6.0, J.min_([(J.sub(J.gp(this_, "W"), v_w_585) - 6.0), J.sub(v_x_577, 20.0)])])
	_s265["by"] = J.sub(v_y_578, v_h_586)
	var _t537 = _s265["ctx"]
	J.sp(_t537, "fillStyle", "rgba(255,250,236,.95)")
	var _t538 = _s265["ctx"]
	J.sp(_t538, "strokeStyle", "#3a2a1a")
	var _t539 = _s265["ctx"]
	J.sp(_t539, "lineWidth", 1.5)
	J.mc(_s265["ctx"], "beginPath", [])
	J.mc(_s265["ctx"], "roundRect", [_s265["bx"], _s265["by"], v_w_585, v_h_586, 9.0])
	J.mc(_s265["ctx"], "fill", [])
	J.mc(_s265["ctx"], "stroke", [])
	J.mc(_s265["ctx"], "beginPath", [])
	J.mc(_s265["ctx"], "moveTo", [J.sub(v_x_577, 6.0), J.add(_s265["by"], v_h_586)])
	J.mc(_s265["ctx"], "lineTo", [J.sub(v_x_577, 2.0), J.add(J.add(_s265["by"], v_h_586), 9.0)])
	J.mc(_s265["ctx"], "lineTo", [J.add(v_x_577, 6.0), J.add(_s265["by"], v_h_586)])
	J.mc(_s265["ctx"], "fill", [])
	var _t540 = _s265["ctx"]
	J.sp(_t540, "fillStyle", "#2a1a10")
	var _t541 = _s265["ctx"]
	J.sp(_t541, "textAlign", "left")
	J.mc(v_lines_582, "forEach", [Callable(self, "_f130").bind(_s265)])
	J.mc(_s265["ctx"], "restore", [])
