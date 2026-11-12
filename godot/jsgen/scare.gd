# 自動轉譯自 scare.js（tools/jsgd.js）——唔好直接改，改原 JS 再轉
extends RefCounted

func run(env):
	var this_ = null; var a = []
	var v_k_30 = null; var v_p_31 = null; var v_c_32 = null; var v_p_33 = null; var v_O_34 = null; var v_SP_35 = null; var v_A_36 = null; var v_R_37 = null; var v_px_38 = null
	J.G["pick"] = Callable(self, "_f250").bind(env)
	J.G["SCARE_TYPES"] = {"breath": "氣", "light": "燈", "cold": "冷", "sound": "聲", "paper": "紙", "phone": "訊息", "face": "臉", "shadow": "影"}
	J.G["NIGHT_SEC"] = 180.0
	J.G["SEE_DIST"] = 0.7
	J.G["SCARE_PAY"] = 0.3
	J.G["FEAR"] = {"gain": 1.4, "weakSmall": 1.6, "spread": 0.15, "decay": 0.3, "nearCalm": 0.5, "shaken": 24.0, "shakenDecay": 0.4, "shakenFloor": 32.0, "shakenMul": 1.3, "smallCap": 58.0, "plainCap": 45.0, "shakenCap": 75.0, "habMul": 0.82, "habMin": 0.45, "habForget": 5.0, "combo": 6.0, "comboStep": 0.15, "comboMax": 0.6, "burstMul": 2.4, "burstBonus": 30.0, "comboPts": 20.0, "multiPts": 50.0, "guardCalm": 15.0, "mockMul": 0.12, "mockFear": 4.0, "mockPts": 6.0, "noBelieve": 25.0, "alone": 1.2, "seenMul": 0.5, "seenPen": 25.0, "witFear": 15.0, "groupMul": 0.8, "uneasy": 20.0, "uneasyMul": 1.25, "aoeMul": 0.6}
	J.G["FEAR_MID"] = {"small": 0.6, "big": 0.75}
	J.G["FEAR_WORD"] = {"breath": "背後吹氣", "light": "燈", "cold": "凍", "sound": "怪聲", "paper": "紙", "phone": "電話", "face": "鬼臉", "shadow": "黑影"}
	J.G["EXPO"] = {"seen": 16.0, "perWit": 6.0, "repeat": 8.0, "aoe": 12.0, "group": 3.0, "blatant": 5.0, "decay": 0.5, "lowDecay": 1.5, "sus": 35.0, "call": 70.0, "ritual": 30.0, "giveUp": 15.0, "expelMul": 0.5}
	J.G["DAOSHI"] = {"k": "daoshi", "name": "林師傅", "role": "道士・車馬費另計", "spr": "npc_daoshi", "speed": 0.09, "calm": 3.0, "weak": ["phone", "cold"], "immune": ["face", "shadow"], "karma": 0.0, "phone": true, "daoshi": true, "route": [[0.55, 0.78, 1.0, "idle"]], "imm": {"face": "（眼都唔眨）呢啲我見得多。", "shadow": "影啫，唔使驚。"}, "lines": ["（搖鈴）", "（講電話）係呀，車馬費另計㗎……", "阿徒，唔好震啦，拎穩張符。", "（揮桃木劍）"], "say": {"immune": "（眼都唔眨）呢啲我見得多。", "rational": ["氣場亂咗少少啫。", "冇嘢，繼續。"], "prime": ["……嗯？", "（鈴聲停咗一停）"], "hit": ["哎呀！嚇親我！", "阿徒！支劍呢？！"], "weak": "（電話震）唔……唔識嘅號碼？！", "shout": "呢單唔收錢喇！", "flee": "林師傅執起鈴就走：「呢單唔收錢喇！」徒弟跑得仲快。"}, "chat": [["美美", "01:40", "師傅，二十三樓好似有嘢，可唔可以上嚟睇睇？"], ["林師傅", "01:41", "得。夜晚出車，車馬費另計。"], ["徒弟", "01:45", "師傅，我今晚可唔可以喺樓下等？"], ["林師傅", "01:45", "唔得。拎穩張符。"]]}
	J.G["MOCK_SAY"] = {"ken": ["（頭都唔抬）OT 做到傻咗呀？", "咪自己嚇自己啦。"], "it": ["應該係 cache 問題。", "你又發乜神經？"], "mis": ["（反白眼）", "黐線㗎佢……"], "boss": ["做唔切就話做唔切，唔好扮病！", "有時間驚，冇時間做嘢？"], "auntie": ["後生仔，飲多啲水啦。", "佢呢排怪怪哋……"], "guard": ["冇嘢㗎，我喺度三十年。"]}
	J.G["GROUP_IMMUNE"] = {"guard": {"light": "呢棟樓啲燈成日都係咁。", "shadow": "呢棟樓啲燈成日都係咁。", "cold": "冷氣又發神經，唔使理佢。"}, "auntie": {"light": "又跳掣？唔關我事。", "shadow": "又跳掣？唔關我事。", "cold": "冷氣又壞，聽日報修。"}}
	J.G["PARA_SAY"] = ["你哋真係聽唔到？！", "我冇講大話㗎！", "頭先係咪有人叫我？", "點解得我一個見到……"]
	J.G["WIT_SAY"] = ["咩……咩嚟㗎？！", "你……你都見到？！", "頭先嗰個係咩嚟？！"]
	J.G["SHAKEN_SAY"] = ["……邊個喺度？", "（望一望後面）", "頭先係咪有人？", "唔好玩喇……", "（吞一啖口水）", "我……我好地地㗎……"]
	J.G["JUMPY_SAY"] = ["吓？！", "咩聲嚟㗎？！", "（成個彈起）"]
	J.G["NPC_UNIT"] = (64.0 * 1.08)
	J.G["SCARE_PROPS"] = {"lamp": {"name": "檯燈", "type": "light", "tier": 1.0, "base": 15.0, "cost": 18.0, "r": 0.22, "front": [0.66, 0.713], "vis": true, "rect": [0.435, 0.398, 0.065, 0.046], "obj": "lamp", "label": "up", "say": "燈在閃"}, "ac": {"name": "冷氣", "type": "cold", "tier": 1.0, "base": 12.0, "cost": 22.0, "r": 0.0, "group": true, "cdT": 18.0, "rect": [0.815, 0.148, 0.16, 0.097], "say": "好冷"}, "water": {"name": "飲水機", "type": "sound", "tier": 1.0, "base": 20.0, "cost": 15.0, "r": 0.2, "vis": true, "front": [0.8, 0.58], "rect": [0.793, 0.406, 0.074, 0.105], "obj": "water", "label": "up", "say": "咕嚕——"}, "printer": {"name": "影印機", "type": "paper", "tier": 2.0, "base": 30.0, "cost": 25.0, "r": 0.2, "vis": true, "front": [0.66, 0.57], "rect": [0.635, 0.42, 0.14, 0.098], "obj": "copier", "say": "自己在印"}, "lights": {"name": "玩電燈", "type": "shadow", "tier": 2.0, "base": 14.0, "cost": 30.0, "r": 0.0, "group": true, "cdT": 18.0, "rect": [0.165, 0.142, 0.62, 0.036], "say": "燈一段一段熄掉"}, "drop": {"name": "東西掉地上", "type": "sound", "tier": 2.0, "base": 24.0, "cost": 25.0, "r": 0.3, "vis": true, "front": [0.15, 0.56], "rect": [0.1, 0.4, 0.08, 0.11], "obj": "cabinet", "label": "up", "say": "哐啷——"}, "chair": {"name": "辦公椅自己轉", "type": "shadow", "tier": 1.0, "base": 16.0, "cost": 20.0, "r": 0.25, "vis": true, "front": [0.43, 0.58], "rect": [0.64, 0.5, 0.06, 0.08], "obj": "achair", "say": "吱——"}}
	for _t1 in J.keys(J.G.get("SCARE_PROPS")):
		v_k_30 = _t1
		v_p_31 = J.gp(J.G.get("SCARE_PROPS"), v_k_30)
		J.sp(v_p_31, "room", "main")
		if J.t(J.gp(v_p_31, "group")):
			continue
		var _t2 = [J.mc(J.G.get("OFFMAP"), "M", [J.gp(J.gp(v_p_31, "front"), 0.0)]), J.mc(J.G.get("OFFMAP"), "MY", [J.gp(J.gp(v_p_31, "front"), 1.0)])]
		J.sp(v_p_31, "front", _t2)
		var _t3 = [J.mc(J.G.get("OFFMAP"), "M", [J.gp(J.gp(v_p_31, "rect"), 0.0)]), J.mc(J.G.get("OFFMAP"), "MY", [J.gp(J.gp(v_p_31, "rect"), 1.0)]), J.gp(J.gp(v_p_31, "rect"), 2.0), J.mul(J.gp(J.gp(v_p_31, "rect"), 3.0), 0.75)]
		J.sp(v_p_31, "rect", _t3)
	v_c_32 = J.gp(J.gp(J.G.get("OFFMAP"), "SPOT"), "copier")
	v_p_33 = J.gp(J.G.get("SCARE_PROPS"), "printer")
	J.sp(v_p_33, "room", "pantry")
	var _t4 = [J.add(J.gp(v_c_32, 0.0), 0.12), J.add(J.gp(v_c_32, 1.0), 0.05)]
	J.sp(v_p_33, "front", _t4)
	J.sp(v_p_33, "r", 0.4)
	var _t5 = [J.sub(J.gp(v_c_32, 0.0), 0.13), J.sub(J.gp(v_c_32, 1.0), 0.2), 0.26, 0.2]
	J.sp(v_p_33, "rect", _t5)
	v_O_34 = J.G.get("OFFMAP")
	v_SP_35 = J.gp(v_O_34, "SPOT")
	v_A_36 = J.gp(v_O_34, "A")
	v_R_37 = J.gp(v_O_34, "R")
	v_px_38 = J.gp(v_O_34, "px")
	J.S_Object_("assign", [J.G.get("SCARE_PROPS"), {"micro": {"room": "pantry", "name": "微波爐", "type": "light", "tier": 1.0, "base": 16.0, "cost": 18.0, "r": 0.42, "vis": true, "front": J.gp(v_SP_35, "micro"), "rect": J.cl(v_R_37, null, [J.gp(v_A_36, "micro")]), "label": "up", "say": "自己叮"}, "fridge": {"room": "pantry", "name": "雪櫃門", "type": "cold", "tier": 1.0, "base": 14.0, "cost": 16.0, "r": 0.42, "vis": true, "front": J.gp(v_SP_35, "fridge"), "rect": J.cl(v_R_37, null, [J.gp(v_A_36, "fridge")]), "say": "自己打開"}, "kettle": {"room": "pantry", "name": "熱水壺", "type": "breath", "tier": 1.0, "base": 18.0, "cost": 18.0, "r": 0.42, "vis": true, "front": J.gp(v_SP_35, "kettle"), "rect": J.cl(v_R_37, null, [J.gp(v_A_36, "kettle")]), "label": "up", "say": "嗚——"}, "vend": {"room": "pantry", "name": "汽水機", "type": "sound", "tier": 2.0, "base": 26.0, "cost": 24.0, "r": 0.42, "vis": true, "front": J.gp(v_SP_35, "vend"), "rect": J.cl(v_R_37, null, [J.gp(v_A_36, "vend")]), "say": "哐咚"}, "tv": {"room": "meeting", "name": "電視", "type": "face", "tier": 2.0, "base": 26.0, "cost": 26.0, "r": 0.5, "vis": true, "front": [J.cl(v_px_38, null, [4920.0]), 0.72], "rect": J.cl(v_R_37, null, [J.gp(v_A_36, "tv")]), "label": "up", "say": "沙沙沙"}, "speaker": {"room": "meeting", "name": "會議電話", "type": "phone", "tier": 1.0, "base": 18.0, "cost": 18.0, "r": 0.45, "vis": true, "front": [J.cl(v_px_38, null, [5190.0]), 0.72], "rect": J.cl(v_R_37, null, [J.gp(v_A_36, "speaker")]), "label": "up", "say": "呼……"}, "chairs": {"room": "meeting", "name": "椅子自己行", "type": "shadow", "tier": 2.0, "base": 22.0, "cost": 24.0, "r": 0.55, "vis": true, "front": [J.cl(v_px_38, null, [4800.0]), 0.8], "rect": J.cl(v_R_37, null, [[4530.0, 640.0, 240.0, 270.0]]), "say": "吱——"}, "golf": {"room": "boss", "name": "高爾夫球", "type": "shadow", "tier": 1.0, "base": 16.0, "cost": 18.0, "r": 0.55, "vis": true, "front": [J.cl(v_px_38, null, [420.0]), 0.76], "rect": J.cl(v_R_37, null, [J.gp(v_A_36, "golfBag")]), "say": "咕碌——"}, "bchair": {"room": "boss", "name": "皮椅自己轉", "type": "face", "tier": 2.0, "base": 26.0, "cost": 24.0, "r": 0.45, "vis": true, "front": [J.cl(v_px_38, null, [770.0]), 0.71], "rect": J.cl(v_R_37, null, [J.gp(v_A_36, "chair")]), "label": "up", "say": "吱——"}, "trophy": {"room": "boss", "name": "獎盃", "type": "sound", "tier": 2.0, "base": 24.0, "cost": 24.0, "r": 0.5, "vis": true, "front": [J.cl(v_px_38, null, [320.0]), 0.72], "rect": J.cl(v_R_37, null, [J.gp(v_A_36, "trophy")]), "label": "up", "say": "哐啷"}}])
	J.G["SCARE_GHOSTS"] = {"afu": {"name": "阿福", "skill": "坐回工位", "type": "face", "base": 34.0, "line": "（鍵盤自己在響。螢幕上打著：「好的老闆，收到。」）"}, "pontianak": {"name": "Pontianak", "skill": "窗外笑聲", "type": "sound", "aoe": true, "base": 16.0, "line": "嘻——嘻——嘻——"}, "tianhua": {"name": "天花姐", "skill": "倒掛", "type": "face", "base": 40.0, "line": "哎喲……（頭髮垂到他面前）"}, "xiaozhi": {"name": "小紙", "skill": "紙人", "type": "shadow", "base": 32.0, "line": "（角落多了一個紙人，對著他笑）"}, "eguiking": {"name": "餓鬼王", "skill": "叮叮叮", "type": "sound", "aoe": true, "base": 14.0, "line": "叮叮叮叮！開飯了沒有？"}, "penanggal": {"name": "Penanggal", "skill": "飛頭", "type": "face", "base": 38.0, "line": "（一個頭從他身邊飄過去）"}, "laojiang": {"name": "老殭", "skill": "跳過走廊", "type": "shadow", "base": 32.0, "line": "（玻璃門外，一跳、一跳、一跳）"}}
	J.G["MIS_POST"] = J.gp(J.gp(J.G.get("OFFMAP"), "SPOT"), "reception")
	J.G["COPY_AT"] = [J.add(J.gp(J.gp(J.gp(J.G.get("OFFMAP"), "SPOT"), "copier"), 0.0), 0.16), J.add(J.gp(J.gp(J.gp(J.G.get("OFFMAP"), "SPOT"), "copier"), 1.0), 0.05)]
	J.G["EMPTY_SAY"] = J.cl(Callable(self, "_f1").bind(env), null, [])
	J.G["BRK"] = J.cl(Callable(self, "_f3").bind(env), null, [])
	J.G["_M"] = J.gp(J.G.get("OFFMAP"), "M")
	J.G["_MY"] = J.gp(J.G.get("OFFMAP"), "MY")
	J.G["_SP"] = J.gp(J.G.get("OFFMAP"), "SPOT")
	var _t51 = {"c": 0.211, "hz": (-0.7)}
	var _t52 = [1100.0, 1300.0, 1480.0]
	var _t53 = [250.0, 450.0, 760.0]
	var _t54 = J.gp(J.gp(J.G.get("OFFMAP"), "SPOT"), "elev")
	var _t55 = [["旁白", "凌晨十二點。阿福回到他生前的公司。"], ["阿福", "門禁卡還能刷。公司也沒有人通知它。"], ["系統", "親～今晚的 KPI：嚇人。點場景裡發光的東西附身，點人可以偷看手機。"], ["系統", "先用小動靜讓他起疑，等他頭上冒「！」再出大招。小心巡邏的保安阿伯，被他的手電筒照到，就會被請去喝茶。"]]
	var _t27 = ["phone", "face", "paper"]
	var _t28 = ["light", "cold"]
	var _t29 = ["paper"]
	var _t30 = {"light": "（盯住手機）燈閃？我部手機光過佢。", "cold": "凍？OT 慣咗。"}
	var _t8 = J.G.get("_M")
	var _t10 = J.cl(_t8, null, [0.24])
	var _t9 = J.G.get("_MY")
	var _t14 = [_t10, J.cl(_t9, null, [0.6]), 14.0, "work"]
	var _t11 = J.G.get("_M")
	var _t13 = J.cl(_t11, null, [0.64])
	var _t12 = J.G.get("_MY")
	var _t18 = [_t13, J.cl(_t12, null, [0.55]), 4.0, "idle"]
	var _t15 = J.G.get("_M")
	var _t17 = J.cl(_t15, null, [0.24])
	var _t16 = J.G.get("_MY")
	var _t22 = [_t17, J.cl(_t16, null, [0.6]), 12.0, "work"]
	var _t19 = J.G.get("_M")
	var _t21 = J.cl(_t19, null, [0.79])
	var _t20 = J.G.get("_MY")
	var _t26 = [_t21, J.cl(_t20, null, [0.57]), 5.0, "idle"]
	var _t23 = J.G.get("_M")
	var _t25 = J.cl(_t23, null, [0.24])
	var _t24 = J.G.get("_MY")
	var _t42 = {"k": "ken", "name": "阿Ken", "role": "加班仔", "spr": "npc_ken", "speed": 0.05, "calm": 2.2, "weak": _t27, "immune": _t28, "hide": _t29, "imm": _t30, "karma": 3.0, "phone": true, "route": [_t14, _t18, _t22, _t26, [_t25, J.cl(_t24, null, [0.6]), 12.0, "work"], [J.gp(J.gp(J.gp(J.G.get("_SP"), "restSeats"), 0.0), 0.0), J.gp(J.gp(J.gp(J.G.get("_SP"), "restSeats"), 0.0), 1.0), 9.0, "brk_nap"]], "say": {"immune": "（沒抬頭，在回老闆訊息）", "rational": ["我太累了……", "眼花，一定是眼花。", "加班加到出現幻覺了。"], "prime": ["……誰？", "剛剛是不是有聲音？", "（回頭看了一眼）"], "hit": ["哇！！", "老……老闆？！", "不、不是我做的！"], "weak": "（手機一亮，整個人跳起來）在、在！我在！", "flee": "阿Ken 看著空氣很久：「你也是……做到這麼晚？」第二天，他遞了辭職信，回老家吃媽媽煮的飯。"}, "chat": [["老闆", "23:02", "阿Ken，明早九點董事會，PPT 再改一版。"], ["阿Ken", "23:03", "好的老闆，收到。"], ["老闆", "01:40", "在嗎？"], ["阿Ken", "01:40", "在！"], ["媽", "昨天", "阿Ken，這個禮拜回來吃飯嗎？媽煲了湯。"], ["阿Ken", "昨天", "下次吧，最近很忙"]]}
	var _t31 = J.G.get("_M")
	var _t33 = [J.cl(_t31, null, [0.66]), 0.8, "work"]
	var _t34 = [26.0, 40.0]
	var _t35 = [["water", 2.6, J.gp(J.G.get("_SP"), "water"), [4.0, 6.0], "去茶水間斟杯水先。"], ["tea", 1.6, J.gp(J.G.get("_SP"), "kettle"), [4.0, 6.0], "沖杯茶頂下。"], ["copier", 1.2, J.G.get("COPY_AT"), [3.0, 5.0], "印埋份 log。"], ["rest", 1.2, "rest", [8.0, 12.0], J.gp(J.G.get("BRK"), "it"), null, ["brk_phone", "brk_drink"]], ["out", 1.4, "out", [12.0, 18.0], "去個洗手間。", "返嚟喇。"]]
	var _t36 = {"cue": "（收拾筆電）差唔多喇……", "bye": "終於收工！", "back": "唔記得拎充電器……", "work": ["server 又 down……", "邊個又改咗個 config……", "（飲一啖珍奶）頂住先。"]}
	var _t37 = ["phone", "sound", "light"]
	var _t38 = ["cold", "paper"]
	var _t39 = ["light"]
	var _t40 = {"cold": "（拉緊帽T）我有帽，唔凍。", "paper": "紙？我哋 paperless 㗎。"}
	var _t41 = (-1.0)
	var _t32 = J.G.get("_M")
	var _t49 = {"k": "it", "name": "小晴", "role": "IT 工程師・今晚值班", "spr": "npc_it", "speed": 0.08, "post": _t33, "work": _t34, "trips": _t35, "lines": _t36, "calm": 2.4, "weak": _t37, "immune": _t38, "hide": _t39, "imm": _t40, "karma": _t41, "phone": true, "route": [[J.cl(_t32, null, [0.66]), 0.8, 16.0, "work"]], "say": {"immune": "（拉緊帽T：我有帽子，不冷。）", "rational": ["應該是網絡延遲。", "是 cache 的問題。", "伺服器又在搞我。", "一定是 Windows 在更新。"], "prime": ["……誰 ping 我？", "耳機裡怎麼有人在講話？", "（把耳機拿下來聽了一下）"], "hit": ["production 掛了嗎？！", "這不是 bug……這不是 bug……", "我只是來值班的！"], "weak": "（手機和耳機一起響：「小晴……還在嗎……」）！！！", "flee": "小晴把電腦一合：「這個 bug 明天再修！」衝進電梯。第二天她請了一星期假，去喝了七杯珍奶。"}, "chat": [["值班系統", "01:12", "【P1】23 樓伺服器溫度 4°C，請立即處理。"], ["陳總", "02:03", "小晴，網站是不是慢了？我覺得慢了。"], ["小晴", "02:04", "陳總，是你家的 Wi-Fi。"], ["二十三樓八卦群", "00:30", "聽說 23 樓半夜影印機會自己印東西 👻"], ["小晴", "00:31", "是驅動程式的問題，不要迷信。"], ["媽", "23:40", "妹，又值夜班？記得吃飯。"], ["小晴", "23:41", "有啦，珍奶算一餐。"], ["珍奶店", "22:58", "您的訂單：全糖、多珍珠、去冰（第 3 杯）已送達。"]]}
	var _t50 = {"k": "mis", "name": "美美", "role": "陳總的秘書・心腹", "spr": "npc_mis", "speed": 0.075, "post": [J.gp(J.G.get("MIS_POST"), 0.0), J.gp(J.G.get("MIS_POST"), 1.0), "idle", 1.0], "work": [22.0, 34.0], "trips": [["copier", 1.6, J.G.get("COPY_AT"), [4.0, 6.0], "又要印多十份……"], ["rest", 1.0, "rest", [8.0, 12.0], J.gp(J.G.get("BRK"), "mis"), null, ["brk_phone", "brk_drink"]], ["micro", 2.0, J.gp(J.G.get("_SP"), "micro"), [4.0, 6.0], "叮個宵夜先～"], ["boss", 2.2, "boss", [4.0, 6.0], "陳總～份文件幫你印好喇～"], ["out", 1.6, "out", [12.0, 20.0], "去補個妝先。", "補完妝喇～"]], "lines": {"cue": "（照鏡、拎手袋）", "bye": "我走先喇～", "back": "仲有嘢未搞掂……", "late": "仲有嘢未搞掂……", "work": ["（接電話）陳總開緊會喎～", "又要印多十份……", "（釘文件）好煩呀～"]}, "calm": 2.6, "weak": ["phone", "breath"], "immune": ["cold"], "hide": ["breath"], "imm": {"cold": "冷氣凍啲先唔會甩妝。"}, "karma": 1.0, "phone": true, "fleeVia": "boss", "route": [[J.gp(J.G.get("MIS_POST"), 0.0), J.gp(J.G.get("MIS_POST"), 1.0), 7.0, "idle"]], "say": {"immune": "冷氣凍啲先唔會甩妝。", "rational": ["一定係阿Ken搞嘢。", "唔好嚇人啦，我粉底會裂㗎。", "呢啲嘢搵阿Ken做啦。"], "prime": ["……邊個喺度呀？", "（照一照鏡）我頭髮亂咗？", "咩聲嚟㗎？"], "hit": ["呀——我隻甲！", "陳總～有嘢呀～", "我部電話！"], "weak": "（自拍鏡頭入面，佢後面多咗一塊臉）", "shout": "陳總～救命呀～！", "flee": "美美尖叫著衝去找陳總：「陳總～救命呀～！」第二天她請了「驚嚇假」，飛去日本購物壓驚，報告全部丟給阿Ken。"}, "chat": [["陳總", "00:45", "美美，聽日陪我去見客，記得著靚啲。"], ["美美", "00:46", "陳總～人哋要放假啦～"], ["陳總", "00:46", "放！做完呢季就放！"], ["姊妹群", "01:02", "你仲喺公司？"], ["美美", "01:03", "係呀，陳總話佢一個人驚 🙄"], ["美美", "01:20", "阿Ken，份報告你幫我打埋佢啦，陳總要嘅。"], ["阿Ken", "01:21", "……好。"], ["網購", "昨天", "您訂購的「防甩妝噴霧 ×6」已出貨。"]]}
	var _t47 = [J.gp(J.gp(J.G.get("_SP"), "bossDesk"), 0.0), J.gp(J.gp(J.G.get("_SP"), "bossDesk"), 1.0), "call", (-1.0)]
	var _t48 = [22.0, 32.0]
	var _t46 = ["golf", 2.2, J.gp(J.G.get("_SP"), "golf"), [7.0, 10.0], "（練下推桿）"]
	var _t43 = J.G.get("_M")
	var _t45 = J.cl(_t43, null, [0.4])
	var _t44 = J.G.get("_MY")
	J.G["SCARE_SITES"] = {"office": {"name": "舊公司・二十三樓", "bg": "office_pano", "pano": true, "layout": "office", "persp": _t51, "need": "ch1_end", "shift": true, "stars": _t52, "oldStars": _t53, "exit": _t54, "intro": _t55, "npcs": [_t42, _t49, _t50, {"k": "boss", "name": "陳總", "role": "新老闆", "spr": "npc_boss", "speed": 0.075, "post": _t47, "work": _t48, "trips": [_t46, ["ken", 1.4, [_t45, J.cl(_t44, null, [0.665])], [4.0, 6.0], "阿Ken，份 PPT 呢？"], ["coffee", 1.2, J.gp(J.G.get("_SP"), "coffee"), [4.0, 6.0], "（自己沖咖啡）"], ["rest", 0.9, "rest", [8.0, 12.0], J.gp(J.G.get("BRK"), "boss"), null, ["brk_drink", "brk_phone"]], ["out", 1.0, "out", [12.0, 18.0], "出去食支煙。", "繼續做嘢！"]], "lines": {"cue": "（看錶）咁夜喇……", "bye": "我走先，你哋繼續做。", "late": "全部人留低開會！", "golf": ["（推桿）入！", "（推桿）……又偏咗。"], "work": ["喂？我唔理，聽朝九點前要見到！", "（對住電話）你講多次？預算爆咗？", "呢份計劃書邊個寫㗎？成份重做！", "（揭文件）專業啲好唔好呀……"]}, "calm": 3.0, "weak": ["paper", "shadow"], "immune": ["sound", "phone"], "hide": ["shadow"], "imm": {"sound": "（戴住降噪耳機睇高爾夫）", "phone": "（掛咗佢）唔識嘅號碼一律唔聽。"}, "karma": 2.0, "phone": true, "route": [[J.gp(J.gp(J.G.get("_SP"), "bossDesk"), 0.0), J.gp(J.gp(J.G.get("_SP"), "bossDesk"), 1.0), 9.0, "call"]], "say": {"immune": "（戴著降噪耳機看高爾夫）", "rational": ["哼，風水問題。", "明天叫 Master Lee 來看。", "一定是實習生在搞鬼。"], "prime": ["……水晶球呢？", "誰在那裡？", "（把水晶球抱緊）"], "hit": ["誰印的？！虧損報表？！", "誰批准你加班的？！", "Master Lee！救命！"], "weak": "（看到影印機自己在印）本、本季虧損報表？誰印的？！", "flee": "陳總抱著水晶球衝進電梯：「明天開始，全公司……在家工作！」"}, "chat": [["Master Lee", "昨天", "陳總，你這層樓陰氣很重，水晶球記得對著窗口。"], ["Master Lee", "昨天", "還有，千萬不要讓影印機半夜自己開。"], ["秘書", "22:10", "陳總，阿Ken 已經連續加班第三晚了。"], ["陳總", "22:11", "很好。叫他明晚繼續。"]]}, {"k": "auntie", "name": "清潔安娣", "role": "今晚逐間房拖地", "spr": "npc_auntie", "speed": 0.05, "post": [J.gp(J.gp(J.gp(J.G.get("OFFMAP"), "LANE"), 0.0), 0.0), J.gp(J.gp(J.gp(J.G.get("OFFMAP"), "LANE"), 0.0), 1.0), "mop"], "lane": J.gp(J.G.get("OFFMAP"), "LANE"), "laneWait": [3.5, 5.5], "trips": [["out", 1.0, "out", [10.0, 15.0], "換桶水先。", "拖埋呢邊就搞掂。"]], "tripEvery": 2.0, "lines": {"cue": "（收拾水桶）", "bye": "聽日見。", "late": "仲有一層未拖。", "work": ["拖完又踩污……", "呢度又有咖啡漬。"]}, "calm": 3.0, "weak": ["face", "breath"], "immune": ["light", "sound"], "hide": ["breath"], "imm": {"light": "電線有問題，聽日叫人整。", "sound": "哼，咩聲未聽過？"}, "karma": (-1.0), "mop": true, "route": [[J.gp(J.gp(J.gp(J.G.get("OFFMAP"), "LANE"), 0.0), 0.0), J.gp(J.gp(J.gp(J.G.get("OFFMAP"), "LANE"), 0.0), 1.0), 2.0, "mop"]], "backfire": {"paper": "（拍照發到群組）誰亂印？！地上全是紙！"}, "say": {"immune": "電線有問題，明天叫人修。", "rational": ["哼。", "加班費要算雙倍。", "冷氣開這麼冷，電費誰付？"], "prime": ["誰？出來！", "我剛拖完的地……", "（握緊拖把）"], "hit": ["哎呀！我的地！", "誰站在那裡？！", "我不怕你！（揮拖把）"], "weak": "誰的腳印？！天花板也有？！", "flee": "安娣拖著水桶走了：「這間我不做了！隔壁大廈的鬼比較有禮貌！」"}, "chat": [["老闆娘", "20:00", "安娣，今晚地板要拖三次，陳總說要亮。"], ["清潔安娣", "20:01", "好。"], ["兒子", "22:30", "媽，又做到幾點？"], ["清潔安娣", "22:31", "做完就回。你先吃，不用等。"]]}, {"k": "guard", "name": "保安阿伯", "role": "夜班三十年・每間房都巡", "spr": "npc_guard", "speed": 0.07, "post": [J.mc(J.G.get("OFFMAP"), "Ru", [2.49]), 0.79, "doze", (-1.0)], "work": [40.0, 55.0], "lines": {"work": ["（打瞌睡）Zzz……", "（醒一醒）……冇嘢，冇嘢。"]}, "trips": [["patrol", 1.0, "patrol", [3.0, 4.0], "巡一巡先。"]], "calm": 99.0, "weak": [], "immune": ["light", "cold", "sound", "paper", "phone", "face", "shadow"], "karma": (-1.0), "guard": true, "phone": true, "route": [[J.mc(J.G.get("OFFMAP"), "Ru", [2.49]), 0.79, 3.0, "look"]], "say": {"immune": "又來？喝杯茶吧。", "calmOther": "沒事啦，我在這裡三十年了。", "catchG": "出來啦，不要躲。來，喝杯茶。"}, "chat": [["阿福", "三個月前", "阿伯，我又加班，今晚不用幫我留燈。"], ["保安阿伯", "三個月前", "留咯。你走了我才關。"], ["女兒", "今天", "爸，今晚幾點下班？"], ["保安阿伯", "今天", "天亮。"], ["保安阿伯", "今天", "那個阿Ken，跟阿福一樣，都不回家。"]]}]}}
	J.G["PANO_ZOOM"] = 0.72
	J.G["Scare"] = {"active": false, "open": Callable(self, "_f5").bind(env), "migrate": Callable(self, "_f16").bind(env), "starsOf": Callable(self, "_f17").bind(env), "start": Callable(self, "_f18").bind(env), "resize": Callable(self, "_f26").bind(env), "viewW": Callable(self, "_f27").bind(env), "clampCam": Callable(self, "_f28").bind(env), "camRoom": Callable(self, "_f29").bind(env), "roomOf": Callable(self, "_f30").bind(env), "sameRoom": Callable(self, "_f31").bind(env), "onScreen": Callable(self, "_f32").bind(env), "bindPan": Callable(self, "_f33").bind(env), "camTick": Callable(self, "_f42").bind(env), "bgScale": Callable(self, "_f43").bind(env), "pt": Callable(self, "_f44").bind(env), "depth": Callable(self, "_f45").bind(env), "persp": Callable(self, "_f46").bind(env), "bgAR": Callable(self, "_f47").bind(env), "hhF": Callable(self, "_f48").bind(env), "hh": Callable(self, "_f49").bind(env), "office": Callable(self, "_f50").bind(env), "frame": Callable(self, "_f51").bind(env), "step": Callable(self, "_f54").bind(env), "moveNpc": Callable(self, "_f60").bind(env), "rng": Callable(self, "_f63").bind(env), "U": Callable(self, "_f64").bind(env), "exitPt": Callable(self, "_f65").bind(env), "present": Callable(self, "_f66").bind(env), "shiftInit": Callable(self, "_f68").bind(env), "goOut": Callable(self, "_f72").bind(env), "outTick": Callable(self, "_f73").bind(env), "elevator": Callable(self, "_f75").bind(env), "planMove": Callable(self, "_f76").bind(env), "freeSeat": Callable(self, "_f78").bind(env), "restStep": Callable(self, "_f83").bind(env), "sitting": Callable(self, "_f87").bind(env), "viaElev": Callable(self, "_f88").bind(env), "mkStep": Callable(self, "_f89").bind(env), "planNext": Callable(self, "_f90").bind(env), "inDoor": Callable(self, "_f93").bind(env), "walkBlocked": Callable(self, "_f95").bind(env), "busy": Callable(self, "_f98").bind(env), "freeSpot": Callable(self, "_f101").bind(env), "bossCall": Callable(self, "_f104").bind(env), "tagExt": Callable(self, "_f109").bind(env), "drawCue": Callable(self, "_f110").bind(env), "inBeam": Callable(self, "_f111").bind(env), "groupRoom": Callable(self, "_f112").bind(env), "inGroup": Callable(self, "_f113").bind(env), "propOK": Callable(self, "_f114").bind(env), "useProp": Callable(self, "_f116").bind(env), "usePhone": Callable(self, "_f119").bind(env), "useBreath": Callable(self, "_f120").bind(env), "useGhost": Callable(self, "_f121").bind(env), "gpq": Callable(self, "_f124").bind(env), "ghostType": Callable(self, "_f126").bind(env), "hit": Callable(self, "_f129").bind(env), "rnd": Callable(self, "_f138").bind(env), "headsDown": Callable(self, "_f139").bind(env), "watching": Callable(self, "_f140").bind(env), "sees": Callable(self, "_f141").bind(env), "witnesses": Callable(self, "_f142").bind(env), "hearers": Callable(self, "_f144").bind(env), "wakeGuard": Callable(self, "_f146").bind(env), "perceive": Callable(self, "_f148").bind(env), "expose": Callable(self, "_f159").bind(env), "workOf": Callable(self, "_f164").bind(env), "expoTick": Callable(self, "_f165").bind(env), "daoTick": Callable(self, "_f167").bind(env), "jumpy": Callable(self, "_f168").bind(env), "addKarma": Callable(self, "_f169").bind(env), "tap": Callable(self, "_f170").bind(env), "renderDock": Callable(self, "_f171").bind(env), "renderTarget": Callable(self, "_f179").bind(env), "profile": Callable(self, "_f183").bind(env), "peek": Callable(self, "_f186").bind(env), "hud": Callable(self, "_f190").bind(env), "bubble": Callable(self, "_f195").bind(env), "floatTick": Callable(self, "_f198").bind(env), "float": Callable(self, "_f200").bind(env), "floatOld": Callable(self, "_f201").bind(env), "toast": Callable(self, "_f202").bind(env), "dust": Callable(self, "_f203").bind(env), "propParts": Callable(self, "_f204").bind(env), "draw": Callable(self, "_f205").bind(env), "drawEdge": Callable(self, "_f218").bind(env), "drawBreath": Callable(self, "_f219").bind(env), "propMarks": Callable(self, "_f220").bind(env), "react": Callable(self, "_f224").bind(env), "animNpc": Callable(self, "_f225").bind(env), "onReact": Callable(self, "_f226").bind(env), "rigOK": Callable(self, "_f227").bind(env), "visPos": Callable(self, "_f228").bind(env), "npcPose": Callable(self, "_f229").bind(env), "drawNpc": Callable(self, "_f232").bind(env), "drawNpcSprite": Callable(self, "_f233").bind(env), "npcFx": Callable(self, "_f234").bind(env), "drawTeam": Callable(self, "_f236").bind(env), "drawGhost": Callable(self, "_f241").bind(env), "drawBubble": Callable(self, "_f242").bind(env), "finish": Callable(self, "_f246").bind(env)}
	J.cl(Callable(self, "_f251").bind(env), null, [])

func _f250(this_, a: Array, env):
	var v_a_1209 = null
	v_a_1209 = J.arg(a, 0)
	return (J.gp(v_a_1209, floor(J.num((randf() * J.len(v_a_1209))))) if J.t(J.S_Array_("isArray", [v_a_1209])) else v_a_1209)

func _f2(this_, a: Array, env):
	var v_yue_40 = null; var v_zh_41 = null
	v_yue_40 = J.arg(a, 0)
	v_zh_41 = J.arg(a, 1)
	var _t6 = (not J.seq(J.typeof_(J.G.get("LANG")), "undefined"))
	if J.t((J.gp(J.G.get("LANG"), "add") if _t6 else _t6)):
		J.mc(J.G.get("LANG"), "add", [{J.key(v_yue_40): v_zh_41}])
	return v_yue_40

func _f1(this_, a: Array, env):
	var v_T_39 = null
	v_T_39 = Callable(self, "_f2").bind(env)
	J.cl(v_T_39, null, ["陳總～搵我呀？", "陳總～找我嗎？"])
	J.cl(v_T_39, null, ["陳總，搵我？", "陳總，找我？"])
	return {"mis": J.cl(v_T_39, null, ["陳總去咗邊呀？咁我出返去等先啦。", "陳總去哪了？那我先出去等吧。"]), "it": J.cl(v_T_39, null, ["叫人入嚟自己又唔喺度……我返去做嘢先。", "叫人進來自己又不在……我先回去做事。"])}

func _f4(this_, a: Array, env):
	var v_yue_43 = null; var v_zh_44 = null
	v_yue_43 = J.arg(a, 0)
	v_zh_44 = J.arg(a, 1)
	var _t7 = (not J.seq(J.typeof_(J.G.get("LANG")), "undefined"))
	if J.t((J.gp(J.G.get("LANG"), "add") if _t7 else _t7)):
		J.mc(J.G.get("LANG"), "add", [{J.key(v_yue_43): v_zh_44}])
	return v_yue_43

func _f3(this_, a: Array, env):
	var v_T_42 = null
	v_T_42 = Callable(self, "_f4").bind(env)
	return {"it": J.cl(v_T_42, null, ["抖陣先，個 server 自己頂住。", "休息一下，伺服器自己撐著。"]), "mis": J.cl(v_T_42, null, ["坐低碌下手機先～", "坐下來滑一下手機～"]), "boss": J.cl(v_T_42, null, ["（飲啖茶）唔好話我偷懶。", "（喝口茶）別說我偷懶。"]), "auntie": J.cl(v_T_42, null, ["拖到腰都痛，坐陣先。", "拖到腰都痛，坐一會兒。"]), "ken": J.cl(v_T_42, null, ["（打個呵欠）瞇五分鐘……", "（打個呵欠）瞇五分鐘……"])}

func _f7(this_, a: Array, env):
	var v_g_53 = null
	v_g_53 = J.arg(a, 0)
	return J.seq(J.gp(v_g_53, "k"), env["k"])

func _f6(this_, a: Array, env):
	var _s11 = {"__p": env, "k": null}
	_s11["k"] = J.arg(a, 0)
	var _t59 = J.seq(_s11["k"], "afu")
	if not J.t(_t59):
		var _t58 = J.gp(J.G.get("S"), "ghosts")
		_t59 = J.mc(_t58, "some", [Callable(self, "_f7").bind(_s11)])
	return _t59

func _f8(this_, a: Array, env):
	var v_k_54 = null
	v_k_54 = J.arg(a, 0)
	return (not J.seq(v_k_54, "afu"))

func _f11(this_, a: Array, env):
	var v_x_59 = null
	v_x_59 = J.arg(a, 0)
	return J.seq(J.gp(v_x_59, "k"), "afu")

func _f10(this_, a: Array, env):
	var v_k_58 = null
	v_k_58 = J.arg(a, 0)
	var _t67 = J.gp(J.gp(env["this"], "pick"), "chosen")
	var _t70 = ("on" if J.t(J.mc(_t67, "includes", [v_k_58])) else "")
	var _t71 = ("disabled" if J.seq(v_k_58, "afu") else "")
	var _t72 = J.gp(J.gp(J.G.get("SCARE_GHOSTS"), v_k_58), "name")
	var _t73 = J.gp(J.gp(J.G.get("SCARE_GHOSTS"), v_k_58), "skill")
	var _t74 = J.gp(J.G.get("SCARE_TYPES"), J.gp(J.gp(J.G.get("SCARE_GHOSTS"), v_k_58), "type"))
	var _t69 = null
	if J.seq(v_k_58, "afu"):
		var _t68 = J.gp(J.G.get("S"), "ghosts")
		_t69 = J.mc(J.G.get("GP"), "pow", [J.mc(_t68, "find", [Callable(self, "_f11").bind(env)])])
	else:
		_t69 = J.mc(J.G.get("GP"), "kindPow", [v_k_58])
	return ("<button class=\"sc-g " + _t70 + "\" data-k=\"" + J.str(v_k_58) + "\" " + _t71 + "><canvas data-por=\"" + J.str(v_k_58) + "\"></canvas><b>" + J.str(_t72) + "</b><small>" + J.str(_t73) + "・" + J.str(_t74) + "・鬼力 " + J.str(_t69) + "</small></button>")

func _f9(this_, a: Array, env):
	var v_best_55 = null; var v_st_56 = null; var v_h_57 = null
	var _t64 = J.gp(J.G.get("S"), "scare")
	var _t65 = (J.gp(J.gp(J.gp(J.G.get("S"), "scare"), "best"), env["siteId"]) if J.t(_t64) else _t64)
	v_best_55 = (_t65 if J.t(_t65) else 0.0)
	v_st_56 = J.mc(env["this"], "starsOf", [env["siteId"], v_best_55])
	v_h_57 = ("<p class=\"desc\">" + J.str(J.gp(env["site"], "name")) + "。天亮前三分鐘。<br>先用小動靜讓人起疑，等他頭上冒「！」再出大招。</p>")
	var _t66 = J.add(v_h_57, ("<p class=\"desc\">最高紀錄：" + J.str(v_best_55) + "　" + J.str(J.mc("★", "repeat", [v_st_56])) + J.str(J.mc("☆", "repeat", [J.sub(3.0, v_st_56)])) + "</p>"))
	v_h_57 = _t66
	var _t75 = J.mc(env["ghosts"], "map", [Callable(self, "_f10").bind(env)])
	var _t76 = J.add(v_h_57, ("<div class=\"sc-pick\">" + J.str(J.mc(_t75, "join", [""])) + "</div>"))
	v_h_57 = _t76
	var _t77 = J.add(v_h_57, ("<p class=\"desc\">阿福一定去。另外最多帶兩隻。</p><button class=\"btn gold wide\" id=\"sc-go\">出發，回陽間</button>"))
	v_h_57 = _t77
	return v_h_57

func _f14(this_, a: Array, env):
	var v_k_61 = null; var v_c_62 = null
	v_k_61 = J.gp(J.gp(env["b"], "dataset"), "k")
	v_c_62 = J.gp(J.gp(env["__p"]["this"], "pick"), "chosen")
	if J.t(J.mc(v_c_62, "includes", [v_k_61])):
		J.mc(v_c_62, "splice", [J.mc(v_c_62, "indexOf", [v_k_61]), 1.0])
	else:
		if (J.len(v_c_62) < 3.0):
			J.mc(v_c_62, "push", [v_k_61])
		else:
			J.mc(J.G.get("Fx"), "toast", ["最多帶兩隻"])
			return null
	var _t84 = J.G.get("$")
	var _t85 = J.cl(_t84, null, ["#sheet .sh-body"])
	var _t86 = J.cl(env["__p"]["render"], null, [])
	J.sp(_t85, "innerHTML", _t86)
	J.cl(env["__p"]["bind"], null, [])

func _f13(this_, a: Array, env):
	var _s18 = {"__p": env, "b": null}
	_s18["b"] = J.arg(a, 0)
	var _t83 = _s18["b"]
	var _t87 = Callable(self, "_f14").bind(_s18)
	J.sp(_t83, "onclick", _t87)
	return _t87

func _f15(this_, a: Array, env):
	J.mc(J.G.get("UI"), "close", [])
	J.mc(env["this"], "start", [env["siteId"], J.mc(J.gp(J.gp(env["this"], "pick"), "chosen"), "slice", [])])

func _f12(this_, a: Array, env):
	var _t78 = J.G.get("paintPortraits")
	var _t79 = J.G.get("$")
	J.cl(_t78, null, [J.cl(_t79, null, ["#sheet"])])
	var _t80 = J.G.get("$")
	var _t81 = J.cl(_t80, null, ["#sheet"])
	var _t82 = J.mc(_t81, "querySelectorAll", [".sc-g"])
	J.mc(_t82, "forEach", [Callable(self, "_f13").bind(env)])
	var _t88 = J.G.get("$")
	var _t89 = J.cl(_t88, null, ["#sc-go"])
	var _t90 = Callable(self, "_f15").bind(env)
	J.sp(_t89, "onclick", _t90)

func _f5(this_, a: Array, env):
	var _s10 = {"__p": env, "this": null, "siteId": null, "site": null, "ghosts": null, "render": null, "bind": null}
	_s10["this"] = this_
	_s10["siteId"] = J.arg(a, 0)
	var _t56 = (not J.seq(J.typeof_(J.G.get("ScareX")), "undefined"))
	if J.t((J.gp(J.G.get("ScareX"), "open") if _t56 else _t56)):
		return J.mc(J.G.get("ScareX"), "open", [_s10["siteId"]])
	J.mc(_s10["this"], "migrate", [])
	_s10["site"] = J.gp(J.G.get("SCARE_SITES"), _s10["siteId"])
	var _t57 = J.S_Object_("keys", [J.G.get("SCARE_GHOSTS")])
	_s10["ghosts"] = J.mc(_t57, "filter", [Callable(self, "_f6").bind(_s10)])
	var _t60 = _s10["this"]
	var _t61 = ["afu"]
	var _t62 = J.mc(_s10["ghosts"], "filter", [Callable(self, "_f8").bind(_s10)])
	var _t63 = {"chosen": J.mc(_t61, "concat", [J.mc(_t62, "slice", [0.0, 2.0])])}
	J.sp(_t60, "pick", _t63)
	_s10["render"] = Callable(self, "_f9").bind(_s10)
	_s10["bind"] = Callable(self, "_f12").bind(_s10)
	J.mc(J.G.get("UI"), "sheet", ["回陽間・夜班", J.cl(_s10["render"], null, [])])
	J.cl(_s10["bind"], null, [])

func _f16(this_, a: Array, env):
	var v_a_65 = null; var v_b_66 = null; var v_k_67 = null; var v_v_68 = null; var v_i_69 = null; var v_k_70 = null; var v_st_71 = null; var v_v_72 = null; var v_a_73 = null; var v_b_74 = null; var v_i_75 = null
	var _t91 = J.seq(J.typeof_(J.G.get("S")), "undefined")
	var _t92 = (_t91 if _t91 else (not J.t(J.G.get("S"))))
	var _t93 = (_t92 if _t92 else (not J.t(J.gp(J.G.get("S"), "scare"))))
	if (_t93 if _t93 else J.cmp(J.gp(J.gp(J.G.get("S"), "scare"), "fv"), 3.0, ">=")):
		return null
	if J.seq(J.gp(J.gp(J.G.get("S"), "scare"), "fv"), 2.0):
		var _t94 = J.gp(J.G.get("S"), "scare")
		J.sp(_t94, "fv", 3.0)
		v_a_65 = [0.0, 650.0, 1200.0, 1600.0]
		v_b_66 = [0.0, 1100.0, 1300.0, 1480.0]
		for _t95 in J.keys(J.gp(J.gp(J.G.get("S"), "scare"), "best")):
			v_k_67 = _t95
			v_v_68 = J.gp(J.gp(J.gp(J.G.get("S"), "scare"), "best"), v_k_67)
			var _t96 = (not J.t(v_v_68))
			if (_t96 if _t96 else (not J.seq(v_k_67, "office"))):
				continue
			v_i_69 = 0.0
			while true:
				var _t97 = J.cmp(v_i_69, 2.0, "<")
				if not (J.cmp(v_v_68, J.gp(v_a_65, J.add(v_i_69, 1.0)), ">=") if _t97 else _t97): break
				v_i_69 = J.num(v_i_69) + 1.0
			var _t98 = J.gp(J.gp(J.G.get("S"), "scare"), "best")
			var _t99 = (J.round(J.num(J.add(J.gp(v_b_66, 3.0), (J.sub(v_v_68, J.gp(v_a_65, 3.0)) * 0.75)))) if J.cmp(v_v_68, J.gp(v_a_65, 3.0), ">=") else J.round(J.num(J.add(J.gp(v_b_66, v_i_69), J.div((J.sub(v_v_68, J.gp(v_a_65, v_i_69)) * J.sub(J.gp(v_b_66, J.add(v_i_69, 1.0)), J.gp(v_b_66, v_i_69))), J.sub(J.gp(v_a_65, J.add(v_i_69, 1.0)), J.gp(v_a_65, v_i_69)))))))
			J.sp(_t98, v_k_67, _t99)
		if J.seq(J.typeof_(J.G.get("save")), "function"):
			J.cl(J.G.get("save"), null, [])
		return null
	var _t100 = J.gp(J.G.get("S"), "scare")
	J.sp(_t100, "fv", 3.0)
	for _t101 in J.keys(J.gp(J.gp(J.G.get("S"), "scare"), "best")):
		v_k_70 = _t101
		v_st_71 = J.gp(J.G.get("SCARE_SITES"), v_k_70)
		v_v_72 = J.gp(J.gp(J.gp(J.G.get("S"), "scare"), "best"), v_k_70)
		var _t102 = (not J.t(v_st_71))
		var _t103 = (_t102 if _t102 else (not J.t(J.gp(v_st_71, "oldStars"))))
		if (_t103 if _t103 else (not J.t(v_v_72))):
			continue
		var _t104 = [0.0]
		v_a_73 = J.mc(_t104, "concat", [J.gp(v_st_71, "oldStars")])
		var _t105 = [0.0]
		v_b_74 = J.mc(_t105, "concat", [J.gp(v_st_71, "stars")])
		v_i_75 = 0.0
		while true:
			var _t106 = J.cmp(v_i_75, 2.0, "<")
			if not (J.cmp(v_v_72, J.gp(v_a_73, J.add(v_i_75, 1.0)), ">=") if _t106 else _t106): break
			v_i_75 = J.num(v_i_75) + 1.0
		var _t107 = J.gp(J.gp(J.G.get("S"), "scare"), "best")
		var _t108 = (J.round(J.num(J.add(J.gp(v_b_74, 3.0), J.div((J.sub(v_v_72, J.gp(v_a_73, 3.0)) * J.sub(J.gp(v_b_74, 3.0), J.gp(v_b_74, 2.0))), J.sub(J.gp(v_a_73, 3.0), J.gp(v_a_73, 2.0)))))) if J.cmp(v_v_72, J.gp(v_a_73, 3.0), ">=") else J.round(J.num(J.add(J.gp(v_b_74, v_i_75), J.div((J.sub(v_v_72, J.gp(v_a_73, v_i_75)) * J.sub(J.gp(v_b_74, J.add(v_i_75, 1.0)), J.gp(v_b_74, v_i_75))), J.sub(J.gp(v_a_73, J.add(v_i_75, 1.0)), J.gp(v_a_73, v_i_75)))))))
		J.sp(_t107, v_k_70, _t108)
	if J.seq(J.typeof_(J.G.get("save")), "function"):
		J.cl(J.G.get("save"), null, [])

func _f17(this_, a: Array, env):
	var v_siteId_78 = null; var v_v_79 = null; var v_s_80 = null
	v_siteId_78 = J.arg(a, 0)
	v_v_79 = J.arg(a, 1)
	J.mc(this_, "migrate", [])
	v_s_80 = J.gp(J.gp(J.G.get("SCARE_SITES"), v_siteId_78), "stars")
	return (3.0 if J.cmp(v_v_79, J.gp(v_s_80, 2.0), ">=") else (2.0 if J.cmp(v_v_79, J.gp(v_s_80, 1.0), ">=") else (1.0 if J.cmp(v_v_79, J.gp(v_s_80, 0.0), ">=") else 0.0)))

func _f19(this_, a: Array, env):
	var v_k_90 = null
	v_k_90 = J.arg(a, 0)
	var _t120 = J.gp(env["this"], "cd")
	J.sp(_t120, v_k_90, 0.0)
	return 0.0

func _f20(this_, a: Array, env):
	var v_d_91 = null; var v_i_92 = null
	v_d_91 = J.arg(a, 0)
	v_i_92 = J.arg(a, 1)
	return {"d": v_d_91, "x": J.gp(J.gp(J.gp(v_d_91, "route"), 0.0), 0.0), "y": J.gp(J.gp(J.gp(v_d_91, "route"), 0.0), 1.0), "wi": 0.0, "wait": J.mul(J.gp(J.gp(J.gp(v_d_91, "route"), 0.0), 2.0), (0.3 + J.mul(v_i_92, 0.25))), "dir": 1.0, "fear": 0.0, "peak": 0.0, "gone": false, "exitT": 0.0, "bounce": 0.0, "look": 0.0, "bub": null, "bubT": 0.0, "act": J.gp(J.gp(J.gp(v_d_91, "route"), 0.0), 3.0), "ph": (randf() * 6.0)}

func _f21(this_, a: Array, env):
	var _t135 = J.G.get("confirmInline")
	var _t136 = J.G.get("$")
	if (not J.t(J.cl(_t135, null, [J.cl(_t136, null, ["#sc-quit"]), "確定收工？"]))):
		return null
	J.mc(env["this"], "finish", [true])

func _f22(this_, a: Array, env):
	var v_e_93 = null
	v_e_93 = J.arg(a, 0)
	return J.mc(env["this"], "tap", [v_e_93])

func _f23(this_, a: Array, env):
	var _t148 = J.gp(env["this"], "active")
	if J.t(((not J.t(J.gp(env["this"], "headless"))) if J.t(_t148) else _t148)):
		J.mc(env["this"], "resize", [])

func _f24(this_, a: Array, env):
	var v_n_96 = null
	v_n_96 = J.arg(a, 0)
	return J.mc(env["this"], "frame", [v_n_96])

func _f25(this_, a: Array, env):
	var _t151 = env["this"]
	J.sp(_t151, "paused", false)
	var _t152 = env["this"]
	var _t153 = J.S_performance_("now", [])
	J.sp(_t152, "last", _t153)

func _f18(this_, a: Array, env):
	var v_siteId_83 = null; var v_team_84 = null; var v_headless_85 = null; var v_seed_86 = null; var v_site_87 = null; var v_el_88 = null; var v_cv_89 = null; var v_k_94 = null; var v_r_95 = null
	var _s29 = {"__p": env, "this": null}
	_s29["this"] = this_
	v_siteId_83 = J.arg(a, 0)
	v_team_84 = J.arg(a, 1)
	v_headless_85 = J.arg(a, 2)
	v_seed_86 = J.arg(a, 3)
	v_site_87 = J.gp(J.G.get("SCARE_SITES"), v_siteId_83)
	var _t113 = _s29["this"]
	var _t110 = (-99.0)
	var _t111 = {}
	var _t112 = (not (not J.t(v_headless_85)))
	var _t109 = (not J.seq(J.typeof_(J.G.get("GhostStreet")), "undefined"))
	J.S_Object_("assign", [_t113, {"endAt": 0.0, "expo": 0.0, "expoMax": 0.0, "expoT": _t110, "alert": false, "daoCall": 0.0, "daoIn": false, "expelled": false, "kpiCut": false, "known": _t111, "guardKarma": false, "site": v_site_87, "siteId": v_siteId_83, "active": true, "headless": _t112, "t": 0.0, "kpi": 0.0, "mana": J.add(60.0, (J.mc(J.G.get("GhostStreet"), "bonus", ["mana"]) if ((not J.t(v_headless_85)) if _t109 else _t109) else 0.0)), "team": v_team_84, "fx": [], "parts": [], "floats": [], "fq": [], "bq": [], "karma": [], "shake": 0.0, "vign": 0.0, "paused": (not J.t(v_headless_85)), "sel": null}])
	var _t114 = _s29["this"]
	var _t115 = {}
	J.sp(_t114, "cd", _t115)
	var _t116 = _s29["this"]
	var _t117 = {}
	J.sp(_t116, "pcd", _t117)
	var _t118 = _s29["this"]
	var _t119 = {}
	J.sp(_t118, "caught", _t119)
	J.mc(v_team_84, "forEach", [Callable(self, "_f19").bind(_s29)])
	var _t121 = _s29["this"]
	var _t122 = J.gp(v_site_87, "npcs")
	var _t123 = J.mc(_t122, "map", [Callable(self, "_f20").bind(_s29)])
	J.sp(_t121, "npcs", _t123)
	var _t124 = _s29["this"]
	var _t125 = (v_seed_86 if (not J.leq(v_seed_86, null)) else J.mod(J.S_Date_("now", []), 100000.0))
	J.sp(_t124, "seed", _t125)
	var _t126 = _s29["this"]
	J.sp(_t126, "door", 0.0)
	if J.t(J.gp(v_site_87, "shift")):
		J.mc(_s29["this"], "shiftInit", [])
	var _t127 = _s29["this"]
	var _t128 = J.gp(J.gp(_s29["this"], "npcs"), 0.0)
	J.sp(_t127, "sel", _t128)
	var _t129 = _s29["this"]
	J.sp(_t129, "selAuto", false)
	if (not J.seq(J.typeof_(J.G.get("ScareX")), "undefined")):
		J.mc(J.G.get("ScareX"), "night", [_s29["this"]])
	if J.t(v_headless_85):
		return null
	var _t130 = J.G.get("$")
	v_el_88 = J.cl(_t130, null, ["#scare"])
	var _t131 = J.gp(v_el_88, "classList")
	J.mc(_t131, "add", ["on"])
	var _t132 = ("<div id=\"sc-top\"><button class=\"btn sm ghost\" id=\"sc-quit\">收工</button><span id=\"sc-clock\"></span><div id=\"sc-mana\"><i></i><b>陰氣</b></div><span id=\"sc-kpi\"></span></div>\n      <div id=\"sc-stage\"><canvas id=\"sc-cvs\"></canvas>" + J.str((J.mc(J.G.get("OFFMAP"), "mapHTML", []) if J.t(J.gp(v_site_87, "pano")) else "")) + "</div>\n      <div id=\"sc-panel\"><div id=\"sc-target\"></div><div id=\"sc-dock\"></div></div><div id=\"sc-phone\"></div>")
	J.sp(v_el_88, "innerHTML", _t132)
	var _t133 = J.G.get("$")
	var _t134 = J.cl(_t133, null, ["#sc-quit"])
	var _t137 = Callable(self, "_f21").bind(_s29)
	J.sp(_t134, "onclick", _t137)
	var _t138 = J.G.get("$")
	v_cv_89 = J.cl(_t138, null, ["#sc-cvs"])
	var _t139 = _s29["this"]
	J.sp(_t139, "camX", 0.0)
	var _t140 = _s29["this"]
	J.sp(_t140, "camV", 0.0)
	var _t141 = _s29["this"]
	J.sp(_t141, "follow", false)
	if J.t(J.gp(v_site_87, "pano")):
		J.mc(_s29["this"], "bindPan", [v_cv_89])
	else:
		J.mc(v_cv_89, "addEventListener", ["pointerdown", Callable(self, "_f22").bind(_s29)])
	J.mc(J.G.get("Sound"), "setMode", ["story"])
	J.mc(_s29["this"], "renderDock", [])
	J.mc(_s29["this"], "renderTarget", [])
	J.mc(_s29["this"], "resize", [])
	if J.t(J.gp(v_site_87, "pano")):
		J.mc(J.G.get("OFFMAP"), "init", [_s29["this"]])
		var _t142 = _s29["this"]
		var _t143 = J.mc(_s29["this"], "clampCam", [J.sub(J.gp(J.gp(J.gp(_s29["this"], "npcs"), 0.0), "x"), J.mul(J.mc(_s29["this"], "viewW", []), 0.5))])
		J.sp(_t142, "camX", _t143)
	if J.t(J.mc(_s29["this"], "office", [])):
		J.mc(J.G.get("OFFICE"), "init", [_s29["this"]])
		for _t144 in J.keys(J.G.get("SCARE_PROPS")):
			v_k_94 = _t144
			var _t145 = J.gp(J.gp(J.G.get("SCARE_PROPS"), v_k_94), "obj")
			v_r_95 = (J.mc(J.G.get("OFFICE"), "rectOf", [J.gp(J.gp(J.G.get("SCARE_PROPS"), v_k_94), "obj")]) if J.t(_t145) else _t145)
			if J.t(v_r_95):
				var _t146 = J.gp(J.G.get("SCARE_PROPS"), v_k_94)
				J.sp(_t146, "rect", v_r_95)
	if (not J.t(J.gp(_s29["this"], "_rs"))):
		var _t147 = _s29["this"]
		J.sp(_t147, "_rs", true)
		J.S_window_("addEventListener", ["resize", Callable(self, "_f23").bind(_s29)])
	var _t149 = _s29["this"]
	var _t150 = J.S_performance_("now", [])
	J.sp(_t149, "last", _t150)
	J.F_requestAnimationFrame([Callable(self, "_f24").bind(_s29)])
	J.mc(J.G.get("Story"), "queue", [{"style": "sys", "lines": J.gp(v_site_87, "intro")}, Callable(self, "_f25").bind(_s29)])

func _f26(this_, a: Array, env):
	var v_c_99 = null; var v_box_100 = null; var v_dpr_101 = null
	var _t154 = J.G.get("$")
	v_c_99 = J.cl(_t154, null, ["#sc-cvs"])
	var _t155 = J.G.get("$")
	v_box_100 = J.mc(J.cl(_t155, null, ["#sc-stage"]), "getBoundingClientRect", [])
	var _t156 = J.gp(J.G.get("window"), "devicePixelRatio")
	var _t157 = J.gp(J.G.get("window"), "devicePixelRatio")
	v_dpr_101 = J.min_([2.0, (_t157 if J.t(_t157) else 1.0)])
	var _t158 = J.mul(J.gp(v_box_100, "width"), v_dpr_101)
	J.sp(v_c_99, "width", _t158)
	var _t159 = J.mul(J.gp(v_box_100, "height"), v_dpr_101)
	J.sp(v_c_99, "height", _t159)
	var _t160 = J.gp(v_c_99, "style")
	var _t161 = J.add(J.gp(v_box_100, "width"), "px")
	J.sp(_t160, "width", _t161)
	var _t162 = J.gp(v_c_99, "style")
	var _t163 = J.add(J.gp(v_box_100, "height"), "px")
	J.sp(_t162, "height", _t163)
	var _t164 = this_
	var _t165 = J.gp(v_box_100, "width")
	J.sp(_t164, "W", _t165)
	var _t166 = this_
	var _t167 = J.gp(v_box_100, "height")
	J.sp(_t166, "H", _t167)
	var _t168 = this_
	J.sp(_t168, "dpr", v_dpr_101)

func _f27(this_, a: Array, env):
	var v_b_104 = null
	v_b_104 = J.mc(this_, "bgScale", [])
	var _t169 = J.gp(this_, "W")
	return J.div((_t169 if J.t(_t169) else 390.0), J.mul(J.gp(v_b_104, "iw"), J.gp(v_b_104, "s")))

func _f28(this_, a: Array, env):
	var v_x_107 = null
	v_x_107 = J.arg(a, 0)
	return J.max_([0.0, J.min_([J.sub(J.gp(J.G.get("OFFMAP"), "WW"), J.mc(this_, "viewW", [])), v_x_107])])

func _f29(this_, a: Array, env):
	var _t170 = J.gp(this_, "camX")
	return J.mc(J.G.get("OFFMAP"), "roomAt", [J.add((_t170 if J.t(_t170) else 0.0), J.div(J.mc(this_, "viewW", []), 2.0))])

func _f30(this_, a: Array, env):
	var v_n_112 = null
	v_n_112 = J.arg(a, 0)
	return J.gp(J.mc(J.G.get("OFFMAP"), "roomAt", [J.gp(v_n_112, "x")]), "k")

func _f31(this_, a: Array, env):
	var v_a_115 = null; var v_b_116 = null
	v_a_115 = J.arg(a, 0)
	v_b_116 = J.arg(a, 1)
	var _t171 = (not J.t(J.gp(J.gp(this_, "site"), "pano")))
	return (_t171 if _t171 else J.seq(J.mc(J.G.get("OFFMAP"), "roomAt", [J.gp(v_a_115, "x")]), J.mc(J.G.get("OFFMAP"), "roomAt", [J.gp(v_b_116, "x")])))

func _f32(this_, a: Array, env):
	var v_x_119 = null; var v_m_120 = null
	v_x_119 = J.arg(a, 0)
	v_m_120 = J.arg(a, 1)
	var _t172 = (0.25 if J.leq(v_m_120, null) else v_m_120)
	v_m_120 = _t172
	var _t173 = J.gp(this_, "camX")
	var _t175 = J.cmp(v_x_119, J.sub((_t173 if J.t(_t173) else 0.0), v_m_120), ">")
	if J.t(_t175):
		var _t174 = J.gp(this_, "camX")
		_t175 = J.cmp(v_x_119, J.add(J.add((_t174 if J.t(_t174) else 0.0), J.mc(this_, "viewW", [])), v_m_120), "<")
	return _t175

func _f34(this_, a: Array, env):
	var v_b_129 = null
	v_b_129 = J.mc(env["this"], "bgScale", [])
	return J.mul(J.gp(v_b_129, "iw"), J.gp(v_b_129, "s"))

func _f35(this_, a: Array, env):
	var v_e_130 = null; var v___131 = null
	v_e_130 = J.arg(a, 0)
	var _t176 = {"x0": J.gp(v_e_130, "clientX"), "y0": J.gp(v_e_130, "clientY"), "c0": J.gp(env["this"], "camX"), "moved": false, "lx": J.gp(v_e_130, "clientX"), "lt": J.S_performance_("now", []), "id": J.gp(v_e_130, "pointerId")}
	env["d"] = _t176
	var _t177 = env["this"]
	J.sp(_t177, "camV", 0.0)
	J.mc(env["cv"], "setPointerCapture", [J.gp(v_e_130, "pointerId")])

func _f36(this_, a: Array, env):
	var v_e_132 = null; var v_dx_133 = null; var v_now_134 = null; var v_dt_135 = null
	v_e_132 = J.arg(a, 0)
	if (not J.t(env["d"])):
		return null
	v_dx_133 = J.sub(J.gp(v_e_132, "clientX"), J.gp(env["d"], "x0"))
	var _t178 = (not J.t(J.gp(env["d"], "moved")))
	if ((absf(J.num(v_dx_133)) > 9.0) if _t178 else _t178):
		var _t179 = env["d"]
		J.sp(_t179, "moved", true)
	if J.t(J.gp(env["d"], "moved")):
		v_now_134 = J.S_performance_("now", [])
		v_dt_135 = J.max_([16.0, J.sub(v_now_134, J.gp(env["d"], "lt"))])
		var _t180 = env["this"]
		var _t181 = J.mc(env["this"], "clampCam", [J.sub(J.gp(env["d"], "c0"), J.div(v_dx_133, J.cl(env["unit"], null, [])))])
		J.sp(_t180, "camX", _t181)
		var _t182 = env["this"]
		var _t183 = J.max_([(-2.5), J.min_([2.5, (J.mul(0.7, J.gp(env["this"], "camV")) + J.div((0.3 * J.div((-J.sub(J.gp(v_e_132, "clientX"), J.gp(env["d"], "lx"))), J.cl(env["unit"], null, []))), J.div(v_dt_135, 1000.0)))])])
		J.sp(_t182, "camV", _t183)
		var _t184 = env["d"]
		var _t185 = J.gp(v_e_132, "clientX")
		J.sp(_t184, "lx", _t185)
		var _t186 = env["d"]
		J.sp(_t186, "lt", v_now_134)
		var _t187 = env["this"]
		var _t188 = J.gp(env["this"], "t")
		J.sp(_t187, "userPan", _t188)

func _f37(this_, a: Array, env):
	var v_e_136 = null; var v_was_137 = null
	v_e_136 = J.arg(a, 0)
	if (not J.t(env["d"])):
		return null
	v_was_137 = env["d"]
	env["d"] = null
	if (not J.t(J.gp(v_was_137, "moved"))):
		var _t189 = env["this"]
		J.sp(_t189, "camV", 0.0)
		J.mc(env["this"], "tap", [v_e_136])
	else:
		var _t190 = (J.sub(J.S_performance_("now", []), J.gp(v_was_137, "lt")) > 90.0)
		if (_t190 if _t190 else (absf(J.num(J.sub(J.gp(v_e_136, "clientX"), J.gp(v_was_137, "x0")))) < 40.0)):
			var _t191 = env["this"]
			J.sp(_t191, "camV", 0.0)
		var _t192 = env["this"]
		var _t193 = J.gp(env["this"], "t")
		J.sp(_t192, "userPan", _t193)

func _f38(this_, a: Array, env):
	env["d"] = null

func _f39(this_, a: Array, env):
	var v_e_138 = null; var v_r_139 = null; var v_x_140 = null
	v_e_138 = J.arg(a, 0)
	v_r_139 = J.mc(env["m"], "getBoundingClientRect", [])
	v_x_140 = J.mul(J.div(J.sub(J.gp(v_e_138, "clientX"), J.gp(v_r_139, "left")), J.gp(v_r_139, "width")), J.gp(J.G.get("OFFMAP"), "WW"))
	var _t195 = env["this"]
	J.sp(_t195, "camV", 0.0)
	var _t196 = env["this"]
	var _t197 = J.mc(env["this"], "clampCam", [J.sub(v_x_140, J.div(J.mc(env["this"], "viewW", []), 2.0))])
	J.sp(_t196, "camTo", _t197)
	var _t198 = env["this"]
	var _t199 = J.gp(env["this"], "t")
	J.sp(_t198, "userPan", _t199)

func _f40(this_, a: Array, env):
	var _t202 = env["this"]
	var _t203 = (not J.t(J.gp(env["this"], "follow")))
	J.sp(_t202, "follow", _t203)
	var _t204 = J.gp(env["f"], "classList")
	J.mc(_t204, "toggle", ["on", J.gp(env["this"], "follow")])
	if J.t(J.gp(env["this"], "follow")):
		var _t205 = env["this"]
		var _t206 = (-99.0)
		J.sp(_t205, "userPan", _t206)

func _f41(this_, a: Array, env):
	return (not (not J.t(env["d"])))

func _f33(this_, a: Array, env):
	var v_up_126 = null
	var _s49 = {"__p": env, "this": null, "cv": null, "d": null, "unit": null, "m": null, "f": null}
	_s49["this"] = this_
	_s49["cv"] = J.arg(a, 0)
	_s49["d"] = null
	_s49["unit"] = Callable(self, "_f34").bind(_s49)
	J.mc(_s49["cv"], "addEventListener", ["pointerdown", Callable(self, "_f35").bind(_s49)])
	J.mc(_s49["cv"], "addEventListener", ["pointermove", Callable(self, "_f36").bind(_s49)])
	v_up_126 = Callable(self, "_f37").bind(_s49)
	J.mc(_s49["cv"], "addEventListener", ["pointerup", v_up_126])
	J.mc(_s49["cv"], "addEventListener", ["pointercancel", Callable(self, "_f38").bind(_s49)])
	var _t194 = J.G.get("$")
	_s49["m"] = J.cl(_t194, null, ["#sc-map"])
	if J.t(_s49["m"]):
		J.mc(_s49["m"], "addEventListener", ["pointerdown", Callable(self, "_f39").bind(_s49)])
	var _t200 = J.G.get("$")
	_s49["f"] = J.cl(_t200, null, ["#sc-follow"])
	if J.t(_s49["f"]):
		var _t201 = _s49["f"]
		var _t207 = Callable(self, "_f40").bind(_s49)
		J.sp(_t201, "onclick", _t207)
	var _t208 = _s49["this"]
	var _t209 = Callable(self, "_f41").bind(_s49)
	J.sp(_t208, "_panning", _t209)

func _f42(this_, a: Array, env):
	var v_rdt_143 = null; var v_vw_144 = null; var v_c_145 = null; var v_n_146 = null; var v_vx_147 = null; var v_l_148 = null; var v_r_149 = null
	v_rdt_143 = J.arg(a, 0)
	if (not J.t(J.gp(J.gp(this_, "site"), "pano"))):
		return null
	v_vw_144 = J.mc(this_, "viewW", [])
	if (not J.leq(J.gp(this_, "camTo"), null)):
		var _t210 = this_
		var _t211 = J.add(J.gp(_t210, "camX"), (J.sub(J.gp(this_, "camTo"), J.gp(this_, "camX")) * J.min_([1.0, J.mul(v_rdt_143, 9.0)])))
		J.sp(_t210, "camX", _t211)
		if (absf(J.num(J.sub(J.gp(this_, "camTo"), J.gp(this_, "camX")))) < 0.002):
			var _t212 = this_
			var _t213 = J.gp(this_, "camTo")
			J.sp(_t212, "camX", _t213)
			var _t214 = this_
			J.sp(_t214, "camTo", null)
	else:
		var _t215 = J.gp(this_, "_panning")
		if (not J.t((J.mc(this_, "_panning", []) if J.t(_t215) else _t215))):
			if (absf(J.num(J.gp(this_, "camV"))) > 0.01):
				var _t216 = this_
				var _t217 = J.add(J.gp(_t216, "camX"), J.mul(J.gp(this_, "camV"), v_rdt_143))
				J.sp(_t216, "camX", _t217)
				var _t218 = this_
				var _t219 = J.mul(J.gp(_t218, "camV"), exp(J.num(((-J.num(v_rdt_143)) * 4.5))))
				J.sp(_t218, "camV", _t219)
			v_n_146 = J.gp(this_, "sel")
			var _t220 = J.gp(this_, "follow")
			var _t221 = (v_n_146 if J.t(_t220) else _t220)
			var _t222 = ((not J.t(J.gp(v_n_146, "gone"))) if J.t(_t221) else _t221)
			var _t223 = ((not J.t(J.gp(v_n_146, "out"))) if J.t(_t222) else _t222)
			var _t224 = ((not J.t(J.gp(v_n_146, "fleeing"))) if J.t(_t223) else _t223)
			var _t225 = ((not J.t(J.gp(v_n_146, "leaving"))) if J.t(_t224) else _t224)
			var _t226 = ((not J.t(J.gp(this_, "selAuto"))) if J.t(_t225) else _t225)
			var _t227 = ((J.sub(J.gp(this_, "t"), J.gp(this_, "userPan")) > 2.5) if J.t(_t226) else _t226)
			if J.t(((absf(J.num(J.gp(this_, "camV"))) < 0.05) if J.t(_t227) else _t227)):
				v_vx_147 = (J.gp(v_n_146, "vX") if (not J.leq(J.gp(v_n_146, "vX"), null)) else J.gp(v_n_146, "x"))
				v_l_148 = J.add(J.gp(this_, "camX"), J.mul(v_vw_144, 0.18))
				v_r_149 = J.add(J.gp(this_, "camX"), J.mul(v_vw_144, 0.82))
				var _t228 = J.cmp(v_vx_147, v_l_148, "<")
				if (_t228 if _t228 else J.cmp(v_vx_147, v_r_149, ">")):
					var _t229 = this_
					var _t230 = J.add(J.gp(_t229, "camX"), ((J.sub(v_vx_147, J.mul(v_vw_144, 0.18)) if J.cmp(v_vx_147, v_l_148, "<") else J.sub(v_vx_147, J.mul(v_vw_144, 0.82))) * J.min_([1.0, J.mul(v_rdt_143, 2.2)])))
					J.sp(_t229, "camX", _t230)
	v_c_145 = J.mc(this_, "clampCam", [J.gp(this_, "camX")])
	if (not J.seq(v_c_145, J.gp(this_, "camX"))):
		var _t231 = this_
		J.sp(_t231, "camV", 0.0)
	var _t232 = this_
	J.sp(_t232, "camX", v_c_145)

func _f43(this_, a: Array, env):
	var v_img_152 = null; var v_iw_153 = null; var v_ih_154 = null; var v_W_155 = null; var v_H_156 = null; var v_s_157 = null; var v_W_158 = null; var v_H_159 = null; var v_iw_160 = null; var v_ih_161 = null; var v_s_162 = null
	var _t233 = J.gp(this_, "site")
	if J.t((J.gp(J.gp(this_, "site"), "pano") if J.t(_t233) else _t233)):
		var _t234 = J.gp(this_, "W")
		v_W_158 = (_t234 if J.t(_t234) else 390.0)
		var _t235 = J.gp(this_, "H")
		v_H_159 = (_t235 if J.t(_t235) else 580.0)
		v_iw_160 = J.gp(J.G.get("OFFMAP"), "PXU")
		v_ih_161 = J.gp(J.G.get("OFFMAP"), "SH")
		v_s_162 = J.max_([J.mul(J.div(v_H_159, v_ih_161), J.G.get("PANO_ZOOM")), J.div(v_W_158, J.mul(J.gp(J.G.get("OFFMAP"), "WW"), v_iw_160))])
		var _t236 = J.gp(this_, "camX")
		return {"s": v_s_162, "iw": v_iw_160, "ih": v_ih_161, "ox": J.mul(J.mul((-J.num((_t236 if J.t(_t236) else 0.0))), v_iw_160), v_s_162), "oy": J.sub(v_H_159, J.mul(v_ih_161, v_s_162))}
	v_img_152 = J.gp(J.G.get("SPR"), J.add("bg_", J.gp(J.gp(this_, "site"), "bg")))
	var _t237 = (J.gp(v_img_152, "naturalWidth") if J.t(v_img_152) else v_img_152)
	v_iw_153 = (_t237 if J.t(_t237) else 768.0)
	var _t238 = (J.gp(v_img_152, "naturalHeight") if J.t(v_img_152) else v_img_152)
	v_ih_154 = (_t238 if J.t(_t238) else 1152.0)
	var _t239 = J.gp(this_, "W")
	v_W_155 = (_t239 if J.t(_t239) else 390.0)
	var _t240 = J.gp(this_, "H")
	v_H_156 = (_t240 if J.t(_t240) else 580.0)
	v_s_157 = J.max_([J.div(v_W_155, v_iw_153), J.div(v_H_156, v_ih_154)])
	return {"s": v_s_157, "iw": v_iw_153, "ih": v_ih_154, "ox": J.div(J.sub(v_W_155, J.mul(v_iw_153, v_s_157)), 2.0), "oy": J.sub(v_H_156, J.mul(v_ih_154, v_s_157))}

func _f44(this_, a: Array, env):
	var v_fx_165 = null; var v_fy_166 = null; var v_b_167 = null
	v_fx_165 = J.arg(a, 0)
	v_fy_166 = J.arg(a, 1)
	v_b_167 = J.mc(this_, "bgScale", [])
	return [J.add(J.mul(J.mul(v_fx_165, J.gp(v_b_167, "iw")), J.gp(v_b_167, "s")), J.gp(v_b_167, "ox")), J.add(J.mul(J.mul(v_fy_166, J.gp(v_b_167, "ih")), J.gp(v_b_167, "s")), J.gp(v_b_167, "oy"))]

func _f45(this_, a: Array, env):
	var v_y_170 = null
	v_y_170 = J.arg(a, 0)
	var _t241 = J.gp(this_, "site")
	var _t244 = null
	if J.t((J.gp(J.gp(this_, "site"), "persp") if J.t(_t241) else _t241)):
		var _t243 = J.mc(this_, "hh", [v_y_170])
		var _t242 = J.gp(this_, "H")
		_t244 = J.div(_t243, J.mul((_t242 if J.t(_t242) else 580.0), 0.165))
	else:
		_t244 = (0.72 + (0.5 * J.max_([0.0, J.min_([1.0, J.div(J.sub(v_y_170, 0.55), 0.42)])])))
	return _t244

func _f46(this_, a: Array, env):
	var _t245 = J.gp(this_, "site")
	return (J.gp(J.gp(this_, "site"), "persp") if J.t(_t245) else _t245)

func _f47(this_, a: Array, env):
	var v_b_175 = null
	v_b_175 = J.mc(this_, "bgScale", [])
	return J.div(J.gp(v_b_175, "ih"), J.gp(v_b_175, "iw"))

func _f48(this_, a: Array, env):
	var v_y_178 = null; var v_p_179 = null
	v_y_178 = J.arg(a, 0)
	v_p_179 = J.gp(J.gp(this_, "site"), "persp")
	return J.mul(J.gp(v_p_179, "c"), J.sub(v_y_178, J.gp(v_p_179, "hz")))

func _f49(this_, a: Array, env):
	var v_y_182 = null; var v_b_183 = null
	v_y_182 = J.arg(a, 0)
	if (not J.t(J.mc(this_, "persp", []))):
		var _t246 = J.gp(this_, "H")
		return J.mul(J.mul((_t246 if J.t(_t246) else 580.0), 0.165), J.mc(this_, "depth", [v_y_182]))
	v_b_183 = J.mc(this_, "bgScale", [])
	return J.mul(J.mul(J.gp(v_b_183, "ih"), J.gp(v_b_183, "s")), J.mc(this_, "hhF", [v_y_182]))

func _f50(this_, a: Array, env):
	var _t247 = (not J.t(J.gp(this_, "headless")))
	var _t248 = (J.gp(this_, "site") if _t247 else _t247)
	var _t249 = (J.seq(J.gp(J.gp(this_, "site"), "layout"), "office") if J.t(_t248) else _t248)
	return ((not J.seq(J.typeof_(J.G.get("OFFICE")), "undefined")) if J.t(_t249) else _t249)

func _f52(this_, a: Array, env):
	var v_n_191 = null
	v_n_191 = J.arg(a, 0)
	return J.mc(env["this"], "frame", [v_n_191])

func _f53(this_, a: Array, env):
	var v_n_192 = null
	v_n_192 = J.arg(a, 0)
	return J.mc(env["this"], "frame", [v_n_192])

func _f51(this_, a: Array, env):
	var v_now_188 = null; var v_rdt_189 = null; var v_dt_190 = null
	var _s79 = {"__p": env, "this": null}
	_s79["this"] = this_
	v_now_188 = J.arg(a, 0)
	if (not J.t(J.gp(_s79["this"], "active"))):
		return null
	if (J.sub(v_now_188, J.gp(_s79["this"], "last")) < (J.div(1000.0, 30.0) - 2.0)):
		J.F_requestAnimationFrame([Callable(self, "_f52").bind(_s79)])
		return null
	v_rdt_189 = J.min_([0.05, J.div(J.sub(v_now_188, J.gp(_s79["this"], "last")), 1000.0)])
	var _t250 = J.gp(_s79["this"], "timeScale")
	v_dt_190 = J.mul(v_rdt_189, (_t250 if J.t(_t250) else 1.0))
	var _t251 = _s79["this"]
	J.sp(_t251, "last", v_now_188)
	J.mc(_s79["this"], "camTick", [v_rdt_189])
	var _t252 = (not J.t(J.gp(_s79["this"], "paused")))
	if ((not J.t(J.mc(J.G.get("Story"), "busy", []))) if _t252 else _t252):
		J.mc(_s79["this"], "step", [v_dt_190])
	if (not J.t(J.gp(_s79["this"], "active"))):
		return null
	J.mc(_s79["this"], "floatTick", [v_rdt_189])
	J.mc(_s79["this"], "draw", [J.div(v_now_188, 1000.0)])
	if (not J.t(J.gp(_s79["this"], "paused"))):
		J.mc(_s79["this"], "hud", [])
	J.F_requestAnimationFrame([Callable(self, "_f53").bind(_s79)])

func _f55(this_, a: Array, env):
	var v_n_200 = null
	v_n_200 = J.arg(a, 0)
	return J.gp(J.gp(v_n_200, "d"), "guard")

func _f56(this_, a: Array, env):
	var v_f_202 = null
	v_f_202 = J.arg(a, 0)
	var _t276 = J.sub(J.gp(v_f_202, "life"), env["dt"])
	J.sp(v_f_202, "life", _t276)
	return (_t276 > 0.0)

func _f57(this_, a: Array, env):
	var v_p_203 = null
	v_p_203 = J.arg(a, 0)
	if J.cmp(J.gp(v_p_203, "delay"), 0.0, ">"):
		var _t280 = J.sub(J.gp(v_p_203, "delay"), env["dt"])
		J.sp(v_p_203, "delay", _t280)
		return true
	var _t281 = J.sub(J.gp(v_p_203, "life"), env["dt"])
	J.sp(v_p_203, "life", _t281)
	var _t282 = J.add(J.gp(v_p_203, "x"), J.mul(J.gp(v_p_203, "vx"), env["dt"]))
	J.sp(v_p_203, "x", _t282)
	var _t283 = J.add(J.gp(v_p_203, "y"), J.mul(J.gp(v_p_203, "vy"), env["dt"]))
	J.sp(v_p_203, "y", _t283)
	var _t284 = J.gp(v_p_203, "g")
	var _t285 = J.add(J.gp(v_p_203, "vy"), J.mul((_t284 if J.t(_t284) else 0.0), env["dt"]))
	J.sp(v_p_203, "vy", _t285)
	var _t286 = J.gp(v_p_203, "rot")
	var _t288 = (_t286 if J.t(_t286) else 0.0)
	var _t287 = J.gp(v_p_203, "vr")
	var _t289 = J.add(_t288, J.mul((_t287 if J.t(_t287) else 0.0), env["dt"]))
	J.sp(v_p_203, "rot", _t289)
	return J.cmp(J.gp(v_p_203, "life"), 0.0, ">")

func _f58(this_, a: Array, env):
	var v_m_204 = null
	v_m_204 = J.arg(a, 0)
	var _t293 = J.gp(v_m_204, "bub")
	var _t294 = (J.cmp(J.gp(v_m_204, "bubT"), 0.0, ">") if J.t(_t293) else _t293)
	return ((not J.t(J.gp(v_m_204, "gone"))) if J.t(_t294) else _t294)

func _f59(this_, a: Array, env):
	var v_n_206 = null
	v_n_206 = J.arg(a, 0)
	var _t307 = J.gp(v_n_206, "gone")
	var _t309 = (_t307 if J.t(_t307) else J.gp(J.gp(v_n_206, "d"), "guard"))
	if not J.t(_t309):
		var _t308 = J.gp(v_n_206, "left")
		_t309 = (J.gp(v_n_206, "out") if J.t(_t308) else _t308)
	return _t309

func _f54(this_, a: Array, env):
	var v_g_196 = null; var v_k_197 = null; var v_k_198 = null; var v_n_199 = null; var v_f_201 = null; var v_q_205 = null
	var _s83 = {"__p": env, "dt": null}
	_s83["dt"] = J.arg(a, 0)
	var _t253 = this_
	var _t254 = J.add(J.gp(_t253, "t"), _s83["dt"])
	J.sp(_t253, "t", _t254)
	var _t255 = this_
	var _t256 = J.min_([100.0, J.add(J.gp(this_, "mana"), J.mul(7.0, _s83["dt"]))])
	J.sp(_t255, "mana", _t256)
	for _t257 in J.keys(J.gp(this_, "cd")):
		v_k_197 = _t257
		var _t258 = J.gp(this_, "cd")
		var _t259 = J.max_([0.0, J.sub(J.gp(J.gp(this_, "cd"), v_k_197), _s83["dt"])])
		J.sp(_t258, v_k_197, _t259)
	if J.t(J.gp(this_, "pcd")):
		for _t260 in J.keys(J.gp(this_, "pcd")):
			v_k_198 = _t260
			var _t261 = J.gp(this_, "pcd")
			var _t262 = J.max_([0.0, J.sub(J.gp(J.gp(this_, "pcd"), v_k_198), _s83["dt"])])
			J.sp(_t261, v_k_198, _t262)
	for _t263 in J.iter(J.gp(this_, "npcs")):
		v_n_199 = _t263
		J.mc(this_, "moveNpc", [v_n_199, _s83["dt"]])
		if (not J.t(J.gp(this_, "headless"))):
			J.mc(this_, "animNpc", [v_n_199, _s83["dt"]])
	if J.t(J.mc(this_, "office", [])):
		J.mc(J.G.get("OFFICE"), "tick", [_s83["dt"]])
		if J.t(J.gp(J.gp(this_, "site"), "pano")):
			J.mc(J.G.get("OFFMAP"), "tick", [_s83["dt"]])
	J.mc(this_, "expoTick", [_s83["dt"]])
	if (not J.seq(J.typeof_(J.G.get("ScareX")), "undefined")):
		J.mc(J.G.get("ScareX"), "tick", [this_, _s83["dt"]])
	var _t264 = J.gp(this_, "npcs")
	v_g_196 = J.mc(_t264, "find", [Callable(self, "_f55").bind(_s83)])
	for _t265 in J.iter(J.gp(this_, "fx")):
		v_f_201 = _t265
		var _t266 = J.gp(v_f_201, "ghost")
		var _t267 = ((not J.t(J.gp(v_f_201, "caught"))) if J.t(_t266) else _t266)
		var _t268 = (v_g_196 if J.t(_t267) else _t267)
		if J.t((J.mc(this_, "inBeam", [v_g_196, J.gp(v_f_201, "gx"), J.gp(v_f_201, "gy")]) if J.t(_t268) else _t268)):
			J.sp(v_f_201, "caught", true)
			var _t269 = J.gp(this_, "caught")
			var _t270 = J.gp(v_f_201, "ghost")
			J.sp(_t269, _t270, true)
			var _t271 = J.gp(this_, "cd")
			var _t272 = J.gp(v_f_201, "ghost")
			J.sp(_t271, _t272, 999.0)
			J.mc(this_, "bubble", [v_g_196, J.gp(J.gp(J.gp(v_g_196, "d"), "say"), "catchG"), 2.6])
			J.mc(this_, "react", [v_g_196, "catch"])
			var _t273 = J.gp(this_, "t")
			J.sp(v_f_201, "busted", _t273)
			J.mc(this_, "float", [J.gp(v_f_201, "gx"), J.sub(J.gp(v_f_201, "gy"), 0.08), (J.str(J.gp(J.gp(J.G.get("SCARE_GHOSTS"), J.gp(v_f_201, "ghost")), "name")) + " 被請去喝茶"), "#9ad"])
			J.mc(this_, "addKarma", [J.gp(v_g_196, "d"), 0.0, ""])
			if (not J.t(J.gp(this_, "headless"))):
				J.mc(this_, "renderDock", [])
	var _t274 = this_
	var _t275 = J.gp(this_, "fx")
	var _t277 = J.mc(_t275, "filter", [Callable(self, "_f56").bind(_s83)])
	J.sp(_t274, "fx", _t277)
	var _t278 = this_
	var _t279 = J.gp(this_, "parts")
	var _t290 = J.mc(_t279, "filter", [Callable(self, "_f57").bind(_s83)])
	J.sp(_t278, "parts", _t290)
	if (not J.t(J.gp(this_, "headless"))):
		var _t291 = J.gp(this_, "bq")
		var _t295 = (J.len(J.gp(this_, "bq")) if J.t(_t291) else _t291)
		if J.t(_t295):
			var _t292 = J.gp(this_, "npcs")
			_t295 = (J.len(J.mc(_t292, "filter", [Callable(self, "_f58").bind(_s83)])) < 2.0)
		if J.t(_t295):
			while true:
				if not J.t(J.len(J.gp(this_, "bq"))): break
				v_q_205 = J.mc(J.gp(this_, "bq"), "shift", [])
				var _t296 = (J.sub(J.gp(this_, "t"), J.gp(v_q_205, "at")) < 4.0)
				var _t297 = ((not J.t(J.gp(J.gp(v_q_205, "n"), "gone"))) if _t296 else _t296)
				if ((not J.t(J.gp(J.gp(v_q_205, "n"), "out"))) if _t297 else _t297):
					J.mc(this_, "bubble", [J.gp(v_q_205, "n"), J.gp(v_q_205, "text"), J.gp(v_q_205, "dur"), J.gp(v_q_205, "ghost")])
					break
	var _t298 = this_
	var _t299 = J.max_([0.0, J.sub(J.gp(this_, "shake"), J.mul(_s83["dt"], 2.2))])
	J.sp(_t298, "shake", _t299)
	var _t300 = this_
	var _t301 = J.max_([0.0, J.sub(J.gp(this_, "vign"), J.mul(_s83["dt"], 1.2))])
	J.sp(_t300, "vign", _t301)
	if J.t(J.gp(this_, "expelled")):
		if (not J.t(J.gp(this_, "kpiCut"))):
			var _t302 = this_
			J.sp(_t302, "kpiCut", true)
			var _t303 = this_
			var _t304 = J.round(J.num(J.mul(J.gp(this_, "kpi"), J.gp(J.G.get("EXPO"), "expelMul"))))
			J.sp(_t303, "kpi", _t304)
		if J.t(J.gp(this_, "headless")):
			var _t305 = this_
			J.sp(_t305, "active", false)
		else:
			if (J.sub(J.gp(this_, "t"), J.gp(this_, "endAt")) > 2.6):
				J.mc(this_, "finish", [false])
		return null
	var _t310 = J.cmp(J.gp(this_, "t"), J.G.get("NIGHT_SEC"), ">=")
	if not J.t(_t310):
		var _t306 = J.gp(this_, "npcs")
		_t310 = J.mc(_t306, "every", [Callable(self, "_f59").bind(_s83)])
	if J.t(_t310):
		if J.t(J.gp(this_, "headless")):
			var _t311 = this_
			J.sp(_t311, "active", false)
		else:
			if J.cmp(J.gp(this_, "t"), J.G.get("NIGHT_SEC"), ">="):
				J.mc(this_, "finish", [false])
			else:
				var _t312 = this_
				var _t313 = J.gp(this_, "endAt")
				var _t314 = (_t313 if J.t(_t313) else J.gp(this_, "t"))
				J.sp(_t312, "endAt", _t314)
				if (J.sub(J.gp(this_, "t"), J.gp(this_, "endAt")) > 2.2):
					J.mc(this_, "finish", [false])

func _f61(this_, a: Array, env):
	var v_m_218 = null
	v_m_218 = J.arg(a, 0)
	var _t323 = (not J.seq(v_m_218, env["n"]))
	var _t324 = ((not J.t(J.gp(v_m_218, "gone"))) if _t323 else _t323)
	var _t325 = ((not J.t(J.gp(v_m_218, "out"))) if _t324 else _t324)
	var _t326 = (J.mc(env["this"], "sameRoom", [v_m_218, env["n"]]) if _t325 else _t325)
	return ((J.hypot_([J.sub(J.gp(v_m_218, "x"), J.gp(env["n"], "x")), J.sub(J.gp(v_m_218, "y"), J.gp(env["n"], "y"))]) < 0.22) if J.t(_t326) else _t326)

func _f62(this_, a: Array, env):
	var v_m_227 = null
	v_m_227 = J.arg(a, 0)
	var _t369 = J.seq(J.gp(J.gp(v_m_227, "d"), "k"), J.gp(J.gp(env["n"], "d"), "fleeVia"))
	return ((not J.t(J.gp(v_m_227, "gone"))) if _t369 else _t369)

func _f60(this_, a: Array, env):
	var v_dt_210 = null; var v_near_211 = null; var v_cr_212 = null; var v_nxt_213 = null; var v_dx_214 = null; var v_dy_215 = null; var v_d_216 = null; var v_sp_217 = null; var v_k_219 = null; var v_ex_220 = null; var v_ey_221 = null; var v_dx_222 = null; var v_dy_223 = null; var v_d_224 = null; var v_sp_225 = null; var v_b_226 = null
	var _s105 = {"__p": env, "this": null, "n": null}
	_s105["this"] = this_
	_s105["n"] = J.arg(a, 0)
	v_dt_210 = J.arg(a, 1)
	var _t315 = _s105["n"]
	var _t316 = J.max_([0.0, J.sub(J.gp(_s105["n"], "bounce"), J.mul(v_dt_210, 2.5))])
	J.sp(_t315, "bounce", _t316)
	var _t317 = _s105["n"]
	var _t318 = J.add(J.gp(_t317, "ph"), v_dt_210)
	J.sp(_t317, "ph", _t318)
	if J.cmp(J.gp(_s105["n"], "bubT"), 0.0, ">"):
		var _t319 = _s105["n"]
		var _t320 = J.sub(J.gp(_t319, "bubT"), v_dt_210)
		J.sp(_t319, "bubT", _t320)
		if J.cmp(J.gp(_s105["n"], "bubT"), 0.0, "<="):
			var _t321 = _s105["n"]
			J.sp(_t321, "bub", null)
	if J.t(J.gp(_s105["n"], "gone")):
		return null
	if J.t(J.gp(_s105["n"], "out")):
		J.mc(_s105["this"], "outTick", [_s105["n"], v_dt_210])
		return null
	var _t322 = J.gp(_s105["this"], "npcs")
	v_near_211 = J.len(J.mc(_t322, "filter", [Callable(self, "_f61").bind(_s105)]))
	if (not J.t(J.gp(J.gp(_s105["n"], "d"), "guard"))):
		var _t327 = _s105["n"]
		var _t328 = J.sub(((3.0 + J.mul(8.0, J.mc(_s105["this"], "rnd", [_s105["n"]]))) if J.leq(J.gp(_s105["n"], "lookCD"), null) else J.gp(_s105["n"], "lookCD")), v_dt_210)
		J.sp(_t327, "lookCD", _t328)
		if J.cmp(J.gp(_s105["n"], "lookUp"), 0.0, ">"):
			var _t329 = _s105["n"]
			var _t330 = J.sub(J.gp(_t329, "lookUp"), v_dt_210)
			J.sp(_t329, "lookUp", _t330)
		else:
			if J.cmp(J.gp(_s105["n"], "lookCD"), 0.0, "<="):
				var _t331 = _s105["n"]
				J.sp(_t331, "lookUp", 2.5)
				var _t332 = _s105["n"]
				var _t333 = (7.0 + J.mul(7.0, J.mc(_s105["this"], "rnd", [_s105["n"]])))
				J.sp(_t332, "lookCD", _t333)
	var _t334 = J.cmp(J.gp(_s105["n"], "fear"), 50.0, ">=")
	if ((not J.t(J.gp(J.gp(_s105["n"], "d"), "guard"))) if _t334 else _t334):
		var _t335 = _s105["n"]
		var _t336 = J.gp(J.G.get("FEAR"), "shaken")
		J.sp(_t335, "shaken", _t336)
	var _t337 = _s105["n"]
	var _t338 = J.gp(_s105["n"], "shaken")
	var _t339 = J.gp(_s105["n"], "shaken")
	var _t340 = J.max_([0.0, J.sub((_t339 if J.t(_t339) else 0.0), v_dt_210)])
	J.sp(_t337, "shaken", _t340)
	if J.cmp(J.gp(_s105["n"], "uneasy"), 0.0, ">"):
		var _t341 = _s105["n"]
		var _t342 = J.sub(J.gp(_t341, "uneasy"), v_dt_210)
		J.sp(_t341, "uneasy", _t342)
	v_cr_212 = J.mul((J.mul(J.gp(J.gp(_s105["n"], "d"), "calm"), J.gp(J.G.get("FEAR"), "decay")) + J.mul(v_near_211, J.gp(J.G.get("FEAR"), "nearCalm"))), (J.gp(J.G.get("FEAR"), "shakenDecay") if J.cmp(J.gp(_s105["n"], "shaken"), 0.0, ">") else 1.0))
	var _t343 = _s105["n"]
	var _t344 = J.max_([(J.min_([J.gp(_s105["n"], "fear"), J.gp(J.G.get("FEAR"), "shakenFloor")]) if J.cmp(J.gp(_s105["n"], "shaken"), 0.0, ">") else 0.0), J.sub(J.gp(_s105["n"], "fear"), J.mul(v_cr_212, v_dt_210))])
	J.sp(_t343, "fear", _t344)
	if J.t(J.gp(_s105["n"], "hab")):
		for _t345 in J.keys(J.gp(_s105["n"], "hab")):
			v_k_219 = _t345
			var _t346 = J.gp(_s105["n"], "hab")
			var _t347 = J.max_([0.0, J.sub(J.gp(J.gp(_s105["n"], "hab"), v_k_219), J.div(v_dt_210, J.gp(J.G.get("FEAR"), "habForget")))])
			J.sp(_t346, v_k_219, _t347)
	var _t348 = J.cmp(J.gp(_s105["n"], "shaken"), 0.0, ">")
	if ((not J.t(J.gp(_s105["n"], "fleeing"))) if _t348 else _t348):
		var _t349 = _s105["n"]
		var _t350 = J.sub((3.0 if J.leq(J.gp(_s105["n"], "glance"), null) else J.gp(_s105["n"], "glance")), v_dt_210)
		J.sp(_t349, "glance", _t350)
		if J.cmp(J.gp(_s105["n"], "glance"), 0.0, "<="):
			var _t351 = _s105["n"]
			var _t352 = (3.5 + (randf() * 3.0))
			J.sp(_t351, "glance", _t352)
			var _t353 = (not J.t(J.gp(_s105["this"], "headless")))
			var _t354 = ((not J.t(J.gp(_s105["n"], "rx"))) if _t353 else _t353)
			if ((not J.seq(J.gp(_s105["n"], "act"), "walk")) if _t354 else _t354):
				J.mc(_s105["this"], "react", [_s105["n"], "chill", {"dur": 2.2}])
				var _t355 = (not J.t(J.gp(_s105["n"], "bub")))
				if ((randf() < 0.45) if _t355 else _t355):
					var _t357 = _s105["n"]
					var _t356 = J.G.get("pick")
					J.mc(_s105["this"], "bubble", [_t357, J.cl(_t356, null, [J.G.get("SHAKEN_SAY")]), 1.8])
	if J.cmp(J.gp(_s105["n"], "fear"), 25.0, ">="):
		var _t358 = _s105["n"]
		var _t359 = J.sub(J.gp(_t358, "look"), v_dt_210)
		J.sp(_t358, "look", _t359)
		if J.cmp(J.gp(_s105["n"], "look"), 0.0, "<="):
			var _t360 = _s105["n"]
			var _t361 = J.mul(J.gp(_t360, "dir"), (-1.0))
			J.sp(_t360, "dir", _t361)
			var _t362 = _s105["n"]
			var _t363 = (0.9 + (randf() * 0.8))
			J.sp(_t362, "look", _t363)
	if J.t(J.gp(_s105["n"], "fleeing")):
		var _t364 = J.gp(J.gp(_s105["this"], "site"), "exit")
		var _t365 = J.gp(_t364, 0.0)
		v_ex_220 = _t365
		var _t366 = J.gp(_t364, 1.0)
		v_ey_221 = _t366
		var _t367 = J.gp(J.gp(_s105["n"], "d"), "fleeVia")
		if J.t(((not J.t(J.gp(_s105["n"], "viaDone"))) if J.t(_t367) else _t367)):
			var _t368 = J.gp(_s105["this"], "npcs")
			v_b_226 = J.mc(_t368, "find", [Callable(self, "_f62").bind(_s105)])
			if J.t(v_b_226):
				v_ex_220 = J.gp(v_b_226, "x")
				v_ey_221 = J.gp(v_b_226, "y")
				if (J.hypot_([J.sub(v_ex_220, J.gp(_s105["n"], "x")), J.sub(v_ey_221, J.gp(_s105["n"], "y"))]) < 0.05):
					var _t370 = _s105["n"]
					J.sp(_t370, "viaDone", true)
			else:
				var _t371 = _s105["n"]
				J.sp(_t371, "viaDone", true)
		v_dx_222 = J.sub(v_ex_220, J.gp(_s105["n"], "x"))
		v_dy_223 = J.sub(v_ey_221, J.gp(_s105["n"], "y"))
		v_d_224 = J.hypot_([v_dx_222, v_dy_223])
		var _t372 = _s105["n"]
		var _t373 = (1.0 if J.cmp(v_dx_222, 0.0, ">=") else (-1.0))
		J.sp(_t372, "dir", _t373)
		if J.cmp(v_d_224, 0.02, "<"):
			var _t374 = J.gp(J.gp(_s105["n"], "d"), "fleeVia")
			if J.t(((not J.t(J.gp(_s105["n"], "viaDone"))) if J.t(_t374) else _t374)):
				var _t375 = _s105["n"]
				J.sp(_t375, "viaDone", true)
				return null
			var _t376 = _s105["n"]
			J.sp(_t376, "gone", true)
			var _t377 = _s105["n"]
			var _t378 = J.gp(_s105["this"], "t")
			J.sp(_t377, "exitT", _t378)
			return null
		v_sp_225 = J.mul(0.28, v_dt_210)
		var _t379 = _s105["n"]
		var _t380 = J.add(J.gp(_t379, "x"), J.mul(J.div(v_dx_222, v_d_224), v_sp_225))
		J.sp(_t379, "x", _t380)
		var _t381 = _s105["n"]
		var _t382 = J.add(J.gp(_t381, "y"), J.mul(J.div(v_dy_223, v_d_224), v_sp_225))
		J.sp(_t381, "y", _t382)
		if (randf() < 0.5):
			J.mc(_s105["this"], "dust", [_s105["n"]])
		return null
	if J.t(J.gp(J.gp(_s105["n"], "d"), "daoshi")):
		J.mc(_s105["this"], "daoTick", [_s105["n"], v_dt_210])
		return null
	var _t383 = J.gp(J.gp(_s105["n"], "d"), "post")
	if J.t((J.gp(J.gp(_s105["this"], "site"), "shift") if J.t(_t383) else _t383)):
		J.mc(_s105["this"], "planMove", [_s105["n"], v_dt_210])
		return null
	if J.cmp(J.gp(_s105["n"], "wait"), 0.0, ">"):
		var _t384 = _s105["n"]
		var _t385 = J.sub(J.gp(_t384, "wait"), J.mul(v_dt_210, (0.4 if J.cmp(J.gp(_s105["n"], "fear"), 50.0, ">=") else 1.0)))
		J.sp(_t384, "wait", _t385)
		var _t386 = _s105["n"]
		var _t387 = J.gp(J.gp(J.gp(J.gp(_s105["n"], "d"), "route"), J.gp(_s105["n"], "wi")), 3.0)
		J.sp(_t386, "act", _t387)
		var _t388 = J.seq(J.gp(_s105["n"], "act"), "brk_nap")
		if (J.cmp(J.gp(_s105["n"], "fear"), 25.0, "<") if _t388 else _t388):
			var _t389 = _s105["n"]
			var _t390 = (1.0 if J.cmp(J.gp(_s105["n"], "x"), J.add(J.gp(J.gp(J.G.get("_SP"), "restTable"), 0.0), 0.01), "<=") else (-1.0))
			J.sp(_t389, "dir", _t390)
		return null
	v_nxt_213 = J.gp(J.gp(J.gp(_s105["n"], "d"), "route"), J.mod(J.add(J.gp(_s105["n"], "wi"), 1.0), J.len(J.gp(J.gp(_s105["n"], "d"), "route"))))
	var _t391 = J.seq(J.gp(v_nxt_213, 3.0), "brk_nap")
	if J.t((J.gp(J.gp(_s105["this"], "site"), "pano") if _t391 else _t391)):
		if (not J.t(J.gp(_s105["n"], "napAt"))):
			var _t392 = _s105["n"]
			var _t393 = J.mc(_s105["this"], "freeSeat", [_s105["n"], v_nxt_213])
			J.sp(_t392, "napAt", _t393)
		var _t394 = [J.gp(J.gp(_s105["n"], "napAt"), 0.0), J.gp(J.gp(_s105["n"], "napAt"), 1.0), J.gp(v_nxt_213, 2.0), J.gp(v_nxt_213, 3.0)]
		v_nxt_213 = _t394
	else:
		var _t395 = _s105["n"]
		J.sp(_t395, "napAt", null)
	v_dx_214 = J.sub(J.gp(v_nxt_213, 0.0), J.gp(_s105["n"], "x"))
	v_dy_215 = J.sub(J.gp(v_nxt_213, 1.0), J.gp(_s105["n"], "y"))
	v_d_216 = J.hypot_([v_dx_214, v_dy_215])
	v_sp_217 = J.mul(J.mul(J.gp(J.gp(_s105["n"], "d"), "speed"), (0.55 if J.cmp(J.gp(_s105["n"], "fear"), 50.0, ">=") else 1.0)), v_dt_210)
	var _t396 = _s105["n"]
	J.sp(_t396, "act", "walk")
	if J.cmp(J.gp(_s105["n"], "fear"), 25.0, "<"):
		var _t397 = _s105["n"]
		var _t398 = (1.0 if J.cmp(v_dx_214, 0.0, ">=") else (-1.0))
		J.sp(_t397, "dir", _t398)
	if J.cmp(v_d_216, v_sp_217, "<="):
		var _t399 = _s105["n"]
		var _t400 = J.gp(v_nxt_213, 0.0)
		J.sp(_t399, "x", _t400)
		var _t401 = _s105["n"]
		var _t402 = J.gp(v_nxt_213, 1.0)
		J.sp(_t401, "y", _t402)
		var _t403 = _s105["n"]
		var _t404 = J.mod(J.add(J.gp(_s105["n"], "wi"), 1.0), J.len(J.gp(J.gp(_s105["n"], "d"), "route")))
		J.sp(_t403, "wi", _t404)
		var _t405 = _s105["n"]
		var _t406 = J.gp(v_nxt_213, 2.0)
		J.sp(_t405, "wait", _t406)
	else:
		var _t407 = _s105["n"]
		var _t408 = J.add(J.gp(_t407, "x"), J.mul(J.div(v_dx_214, v_d_216), v_sp_217))
		J.sp(_t407, "x", _t408)
		var _t409 = _s105["n"]
		var _t410 = J.add(J.gp(_t409, "y"), J.mul(J.div(v_dy_215, v_d_216), v_sp_217))
		J.sp(_t409, "y", _t410)

func _f63(this_, a: Array, env):
	var v_n_230 = null; var v_a_231 = null; var v_t_232 = null
	v_n_230 = J.arg(a, 0)
	var _t411 = J.bor(J.add(J.gp(v_n_230, "_seed"), 1831565813.0), 0.0)
	J.sp(v_n_230, "_seed", _t411)
	v_a_231 = _t411
	v_t_232 = J.math("imul", [J.bxor(v_a_231, J.ushr(v_a_231, 15.0)), J.bor(1.0, v_a_231)])
	var _t412 = J.bxor(J.add(v_t_232, J.math("imul", [J.bxor(v_t_232, J.ushr(v_t_232, 7.0)), J.bor(61.0, v_t_232)])), v_t_232)
	v_t_232 = _t412
	return J.div(J.ushr(J.bxor(v_t_232, J.ushr(v_t_232, 14.0)), 0.0), 4294967296.0)

func _f64(this_, a: Array, env):
	var v_n_235 = null; var v_a_236 = null; var v_b_237 = null
	v_n_235 = J.arg(a, 0)
	v_a_236 = J.arg(a, 1)
	v_b_237 = J.arg(a, 2)
	return J.add(v_a_236, J.mul(J.sub(v_b_237, v_a_236), J.mc(this_, "rng", [v_n_235])))

func _f65(this_, a: Array, env):
	var _t413 = J.gp(J.gp(this_, "site"), "exit")
	return (_t413 if J.t(_t413) else [0.905, 0.535])

func _f67(this_, a: Array, env):
	var v_m_243 = null
	v_m_243 = J.arg(a, 0)
	var _t415 = (not J.seq(v_m_243, env["ex"]))
	var _t416 = ((not J.t(J.gp(J.gp(v_m_243, "d"), "guard"))) if _t415 else _t415)
	var _t417 = ((not J.t(J.gp(J.gp(v_m_243, "d"), "daoshi"))) if _t416 else _t416)
	var _t418 = ((not J.t(J.gp(v_m_243, "gone"))) if _t417 else _t417)
	var _t419 = ((not J.t(J.gp(v_m_243, "out"))) if _t418 else _t418)
	var _t420 = ((not J.t(J.gp(v_m_243, "fleeing"))) if _t419 else _t419)
	return ((not J.t(J.gp(v_m_243, "leaving"))) if _t420 else _t420)

func _f66(this_, a: Array, env):
	var _s132 = {"__p": env, "ex": null}
	_s132["ex"] = J.arg(a, 0)
	var _t414 = J.gp(this_, "npcs")
	return J.len(J.mc(_t414, "filter", [Callable(self, "_f67").bind(_s132)]))

func _f69(this_, a: Array, env):
	return J.mc(env["__p"]["this"], "rng", [env["n"]])

func _f70(this_, a: Array, env):
	var v_a_253 = null; var v_b_254 = null
	v_a_253 = J.arg(a, 0)
	v_b_254 = J.arg(a, 1)
	return J.mc(env["__p"]["this"], "U", [env["n"], v_a_253, v_b_254])

func _f71(this_, a: Array, env):
	var v_a_256 = null; var v_b_257 = null
	v_a_256 = J.arg(a, 0)
	v_b_257 = J.arg(a, 1)
	return J.sub(J.gp(v_a_256, "t"), J.gp(v_b_257, "t"))

func _f68(this_, a: Array, env):
	var v_S0_246 = null; var v_i_247 = null; var v_d_249 = null; var v_L_250 = null; var v_r_251 = null; var v_U_252 = null; var v_t1_255 = null; var v_e_258 = null
	var _s134 = {"__p": env, "this": null}
	_s134["this"] = this_
	v_S0_246 = J.gp(_s134["this"], "seed")
	for _t421 in J.iter(J.mc(J.gp(_s134["this"], "npcs"), "entries", [])):
		var _s135 = {"__p": _s134, "n": null}
		var _t422 = J.gp(_t421, 0.0)
		v_i_247 = _t422
		var _t423 = J.gp(_t421, 1.0)
		_s135["n"] = _t423
		var _t424 = _s135["n"]
		var _t425 = J.bor((J.mul(v_S0_246, 7919.0) + J.mul(v_i_247, 104729.0)), 0.0)
		J.sp(_t424, "_seed", _t425)
		var _t426 = _s135["n"]
		var _t427 = []
		J.sp(_t426, "ev", _t427)
		v_d_249 = J.gp(_s135["n"], "d")
		var _t428 = J.gp(v_d_249, "lines")
		v_L_250 = (_t428 if J.t(_t428) else {})
		v_r_251 = Callable(self, "_f69").bind(_s135)
		v_U_252 = Callable(self, "_f70").bind(_s135)
		if J.t(J.gp(v_d_249, "post")):
			var _t429 = _s135["n"]
			var _t430 = J.gp(J.gp(v_d_249, "post"), 0.0)
			J.sp(_t429, "x", _t430)
			var _t431 = _s135["n"]
			var _t432 = J.gp(J.gp(v_d_249, "post"), 1.0)
			J.sp(_t431, "y", _t432)
			var _t433 = _s135["n"]
			var _t434 = J.gp(J.gp(v_d_249, "post"), 2.0)
			J.sp(_t433, "act", _t434)
			var _t435 = _s135["n"]
			J.sp(_t435, "wait", 0.0)
			var _t436 = _s135["n"]
			var _t437 = {"x": J.gp(_s135["n"], "x"), "y": J.gp(_s135["n"], "y"), "wait": J.cl(v_U_252, null, [6.0, (J.gp(J.gp(v_d_249, "work"), 1.0) if J.t(J.gp(v_d_249, "work")) else 6.0)]), "act": J.gp(J.gp(v_d_249, "post"), 2.0), "arrived": true}
			J.sp(_t436, "step", _t437)
			var _t438 = _s135["n"]
			var _t439 = J.gp(J.gp(_s135["n"], "step"), "wait")
			J.sp(_t438, "wait", _t439)
			var _t440 = _s135["n"]
			J.sp(_t440, "li", 0.0)
		if J.seq(J.gp(v_d_249, "k"), "boss"):
			var _t441 = J.gp(_s135["n"], "ev")
			J.mc(_t441, "push", [{"t": J.cl(v_U_252, null, [18.0, 40.0]), "k": "in", "say": J.gp(v_L_250, "late")}])
			var _t442 = J.gp(_s135["n"], "ev")
			J.mc(_t442, "push", [{"t": J.cl(v_U_252, null, [42.0, 56.0]), "k": "callin"}])
			var _t443 = J.gp(_s135["n"], "ev")
			J.mc(_t443, "push", [{"t": J.cl(v_U_252, null, [70.0, 84.0]), "k": "meeting"}])
			if J.cmp(J.cl(v_r_251, null, []), 0.6, "<"):
				var _t444 = J.gp(_s135["n"], "ev")
				J.mc(_t444, "push", [{"t": J.cl(v_U_252, null, [122.0, 136.0]), "k": "callin"}])
			if J.cmp(J.cl(v_r_251, null, []), 0.5, "<"):
				var _t445 = J.gp(_s135["n"], "ev")
				J.mc(_t445, "push", [{"t": J.cl(v_U_252, null, [150.0, 165.0]), "k": "leave"}])
		if J.seq(J.gp(v_d_249, "k"), "it"):
			v_t1_255 = J.cl(v_U_252, null, [100.0, 145.0])
			if J.cmp(J.cl(v_r_251, null, []), 0.45, "<"):
				var _t446 = J.gp(_s135["n"], "ev")
				J.mc(_t446, "push", [{"t": v_t1_255, "k": "leave", "back": J.cl(v_U_252, null, [12.0, 20.0])}])
			else:
				var _t447 = J.gp(_s135["n"], "ev")
				J.mc(_t447, "push", [{"t": J.add(v_t1_255, 15.0), "k": "leave"}])
		if J.seq(J.gp(v_d_249, "k"), "mis"):
			if J.cmp(J.cl(v_r_251, null, []), 0.35, "<"):
				var _t448 = J.gp(_s135["n"], "ev")
				J.mc(_t448, "push", [{"t": J.cl(v_U_252, null, [25.0, 60.0]), "k": "in", "say": J.gp(v_L_250, "late")}])
			if J.cmp(J.cl(v_r_251, null, []), 0.6, "<"):
				var _t449 = J.gp(_s135["n"], "ev")
				J.mc(_t449, "push", [{"t": J.cl(v_U_252, null, [120.0, 160.0]), "k": "leave"}])
		if J.seq(J.gp(v_d_249, "k"), "auntie"):
			if J.cmp(J.cl(v_r_251, null, []), 0.5, "<"):
				var _t450 = J.gp(_s135["n"], "ev")
				J.mc(_t450, "push", [{"t": J.cl(v_U_252, null, [20.0, 50.0]), "k": "in", "say": J.gp(v_L_250, "late")}])
			if J.cmp(J.cl(v_r_251, null, []), 0.5, "<"):
				var _t451 = J.gp(_s135["n"], "ev")
				J.mc(_t451, "push", [{"t": J.cl(v_U_252, null, [135.0, 168.0]), "k": "leave"}])
		var _t452 = J.gp(_s135["n"], "ev")
		J.mc(_t452, "sort", [Callable(self, "_f71").bind(_s135)])
		var _t453 = J.gp(J.gp(_s135["n"], "ev"), 0.0)
		if J.t((J.seq(J.gp(J.gp(J.gp(_s135["n"], "ev"), 0.0), "k"), "in") if J.t(_t453) else _t453)):
			v_e_258 = J.mc(J.gp(_s135["n"], "ev"), "shift", [])
			J.mc(_s135["__p"]["this"], "goOut", [_s135["n"], J.gp(v_e_258, "t"), false, J.gp(v_e_258, "say"), true])

func _f72(this_, a: Array, env):
	var v_n_261 = null; var v_dur_262 = null; var v_leave_263 = null; var v_backSay_264 = null; var v_silent_265 = null; var v_ex_266 = null; var v_ey_267 = null
	v_n_261 = J.arg(a, 0)
	v_dur_262 = J.arg(a, 1)
	v_leave_263 = J.arg(a, 2)
	v_backSay_264 = J.arg(a, 3)
	v_silent_265 = J.arg(a, 4)
	var _t454 = J.mc(this_, "exitPt", [])
	var _t455 = J.gp(_t454, 0.0)
	v_ex_266 = _t455
	var _t456 = J.gp(_t454, 1.0)
	v_ey_267 = _t456
	J.sp(v_n_261, "out", true)
	J.sp(v_n_261, "leaving", false)
	var _t457 = (not (not J.t(v_leave_263)))
	J.sp(v_n_261, "left", _t457)
	J.sp(v_n_261, "outT", v_dur_262)
	var _t458 = ((-9.0) if J.t(v_silent_265) else J.gp(this_, "t"))
	J.sp(v_n_261, "outAt", _t458)
	var _t459 = (v_backSay_264 if J.t(v_backSay_264) else null)
	J.sp(v_n_261, "inSay", _t459)
	J.sp(v_n_261, "x", v_ex_266)
	J.sp(v_n_261, "y", v_ey_267)
	J.sp(v_n_261, "step", null)
	J.sp(v_n_261, "act", "idle")
	if (not J.t(v_silent_265)):
		J.mc(this_, "elevator", [])
	var _t460 = J.mc(this_, "office", [])
	if J.t((J.seq(J.gp(J.gp(v_n_261, "d"), "k"), "it") if J.t(_t460) else _t460)):
		J.mc(J.G.get("OFFICE"), "offline", ["it", (not (not J.t(v_leave_263)))])

func _f74(this_, a: Array, env):
	var v_m_274 = null
	v_m_274 = J.arg(a, 0)
	var _t468 = (not J.seq(v_m_274, env["n"]))
	var _t469 = ((not J.t(J.gp(v_m_274, "gone"))) if _t468 else _t468)
	var _t470 = ((not J.t(J.gp(v_m_274, "out"))) if _t469 else _t469)
	var _t471 = (J.seq(J.gp(v_m_274, "act"), "walk") if _t470 else _t470)
	return (J.seq(J.mc(env["this"], "roomOf", [v_m_274]), "main") if _t471 else _t471)

func _f73(this_, a: Array, env):
	var v_dt_271 = null; var v_ex_272 = null; var v_ey_273 = null
	var _s148 = {"__p": env, "this": null, "n": null}
	_s148["this"] = this_
	_s148["n"] = J.arg(a, 0)
	v_dt_271 = J.arg(a, 1)
	if J.t(J.gp(_s148["n"], "left")):
		return null
	var _t461 = _s148["n"]
	var _t462 = J.sub(J.gp(_t461, "outT"), v_dt_271)
	J.sp(_t461, "outT", _t462)
	if J.cmp(J.gp(_s148["n"], "outT"), 0.0, ">"):
		return null
	var _t466 = J.gp(J.gp(_s148["this"], "site"), "pano")
	if J.t(_t466):
		var _t463 = _s148["n"]
		var _t464 = J.gp(_s148["n"], "inWait")
		var _t465 = J.add((_t464 if J.t(_t464) else 0.0), v_dt_271)
		J.sp(_t463, "inWait", _t465)
		_t466 = J.cmp(_t465, 8.0, "<")
	var _t472 = _t466
	if J.t(_t472):
		var _t467 = J.gp(_s148["this"], "npcs")
		_t472 = (J.len(J.mc(_t467, "filter", [Callable(self, "_f74").bind(_s148)])) >= 2.0)
	if J.t(_t472):
		return null
	var _t473 = _s148["n"]
	J.sp(_t473, "inWait", 0.0)
	var _t474 = _s148["n"]
	J.sp(_t474, "out", false)
	var _t475 = _s148["n"]
	var _t476 = J.gp(_s148["this"], "t")
	J.sp(_t475, "inAt", _t476)
	J.mc(_s148["this"], "elevator", [])
	var _t477 = J.mc(_s148["this"], "office", [])
	if J.t((J.seq(J.gp(J.gp(_s148["n"], "d"), "k"), "it") if J.t(_t477) else _t477)):
		J.mc(J.G.get("OFFICE"), "offline", ["it", false])
	var _t478 = J.mc(_s148["this"], "exitPt", [])
	var _t479 = J.gp(_t478, 0.0)
	v_ex_272 = _t479
	var _t480 = J.gp(_t478, 1.0)
	v_ey_273 = _t480
	var _t481 = _s148["n"]
	J.sp(_t481, "x", v_ex_272)
	var _t482 = _s148["n"]
	J.sp(_t482, "y", v_ey_273)
	var _t483 = _s148["n"]
	var _t484 = (-1.0)
	J.sp(_t483, "dir", _t484)
	if J.t(J.gp(_s148["n"], "inSay")):
		J.mc(_s148["this"], "bubble", [_s148["n"], J.gp(_s148["n"], "inSay"), 2.6])
	var _t485 = _s148["n"]
	J.sp(_t485, "inSay", null)
	var _t486 = _s148["n"]
	J.sp(_t486, "step", null)
	var _t487 = _s148["n"]
	J.sp(_t487, "next", null)

func _f75(this_, a: Array, env):
	var _t488 = this_
	J.sp(_t488, "door", 1.8)
	J.mc(this_, "jumpy", [null, "lobby"])
	if (not J.t(J.gp(this_, "headless"))):
		if (not J.seq(J.typeof_(J.G.get("Sound")), "undefined")):
			J.mc(J.G.get("Sound"), "play", ["coin"])
		if J.t(J.mc(this_, "office", [])):
			J.mc(J.G.get("OFFICE"), "elevator", [])

func _f77(this_, a: Array, env):
	var v_m_293 = null
	v_m_293 = J.arg(a, 0)
	var _t565 = J.gp(v_m_293, "bub")
	return (J.cmp(J.gp(v_m_293, "bubT"), 0.0, ">") if J.t(_t565) else _t565)

func _f76(this_, a: Array, env):
	var v_n_279 = null; var v_dt_280 = null; var v_d_281 = null; var v_s_282 = null; var v_atPost_283 = null; var v_e_284 = null; var v_c_285 = null; var v_cb_286 = null; var v_tgt_287 = null; var v_dx_288 = null; var v_dy_289 = null; var v_dd_290 = null; var v_sp_291 = null; var v_b_292 = null; var v_i_294 = null; var v_m_295 = null
	v_n_279 = J.arg(a, 0)
	v_dt_280 = J.arg(a, 1)
	v_d_281 = J.gp(v_n_279, "d")
	while true:
		var _t489 = J.len(J.gp(v_n_279, "ev"))
		if not J.t((J.cmp(J.gp(this_, "t"), J.gp(J.gp(J.gp(v_n_279, "ev"), 0.0), "t"), ">=") if J.t(_t489) else _t489)): break
		v_e_284 = J.gp(J.gp(v_n_279, "ev"), 0.0)
		if J.seq(J.gp(v_e_284, "k"), "leave"):
			if J.cmp(J.mc(this_, "present", [v_n_279]), 2.0, "<"):
				var _t490 = J.add(J.gp(v_e_284, "t"), 3.0)
				J.sp(v_e_284, "t", _t490)
				break
			J.mc(J.gp(v_n_279, "ev"), "shift", [])
			J.sp(v_n_279, "leaving", true)
			var _t491 = {"x": J.gp(v_n_279, "x"), "y": J.gp(v_n_279, "y"), "wait": 3.5, "act": "pack", "arrived": true, "cue": true}
			J.sp(v_n_279, "step", _t491)
			J.sp(v_n_279, "wait", 3.5)
			var _t492 = J.gp(v_d_281, "lines")
			J.mc(this_, "bubble", [v_n_279, (J.gp(J.gp(v_d_281, "lines"), "cue") if J.t(_t492) else _t492), 3.0])
			var _t494 = (not J.t(J.gp(v_e_284, "back")))
			var _t493 = J.gp(v_e_284, "back")
			var _t496 = (_t493 if J.t(_t493) else 0.0)
			var _t495 = J.gp(v_d_281, "lines")
			var _t498 = (J.gp(J.gp(v_d_281, "lines"), "back") if J.t(_t495) else _t495)
			var _t497 = J.gp(v_d_281, "lines")
			var _t499 = {"out": true, "leave": _t494, "outDur": _t496, "backSay": _t498, "sayStart": (J.gp(J.gp(v_d_281, "lines"), "bye") if J.t(_t497) else _t497)}
			J.sp(v_n_279, "next", _t499)
			continue
		if J.seq(J.gp(v_e_284, "k"), "in"):
			J.mc(J.gp(v_n_279, "ev"), "shift", [])
			continue
		var _t500 = J.seq(J.gp(v_e_284, "k"), "callin")
		if (_t500 if _t500 else J.seq(J.gp(v_e_284, "k"), "meeting")):
			var _t501 = J.gp(v_n_279, "leaving")
			var _t502 = (_t501 if J.t(_t501) else J.gp(v_n_279, "fleeing"))
			var _t503 = (_t502 if J.t(_t502) else J.cmp(J.gp(v_n_279, "fear"), 50.0, ">="))
			if J.t((_t503 if J.t(_t503) else (not J.t(J.mc(this_, "bossCall", [v_n_279, J.gp(v_e_284, "k")]))))):
				var _t504 = J.add(J.gp(v_e_284, "t"), 5.0)
				J.sp(v_e_284, "t", _t504)
				break
			J.mc(J.gp(v_n_279, "ev"), "shift", [])
			continue
	var _t505 = J.gp(v_n_279, "call")
	if J.t(((not J.t(J.gp(v_n_279, "leaving"))) if J.t(_t505) else _t505)):
		v_c_285 = J.gp(v_n_279, "call")
		v_cb_286 = J.gp(v_c_285, "boss")
		var _t508 = v_cb_286
		if J.t(_t508):
			var _t506 = J.gp(v_cb_286, "gone")
			var _t507 = (_t506 if J.t(_t506) else J.gp(v_cb_286, "out"))
			_t508 = (_t507 if J.t(_t507) else J.gp(v_cb_286, "fleeing"))
		if J.t(_t508):
			J.sp(v_n_279, "call", null)
		else:
			var _t511 = ((not J.seq(J.mc(this_, "roomOf", [v_cb_286]), "boss")) if J.t(v_cb_286) else v_cb_286)
			if J.t(_t511):
				var _t509 = J.gp(v_c_285, "hold")
				var _t510 = J.add((_t509 if J.t(_t509) else 0.0), v_dt_280)
				J.sp(v_c_285, "hold", _t510)
				_t511 = J.cmp(_t510, 25.0, "<")
			if J.t(_t511):
				pass
			else:
				if J.cmp(J.gp(v_c_285, "delay"), 0.0, ">"):
					var _t512 = J.sub(J.gp(v_c_285, "delay"), v_dt_280)
					J.sp(v_c_285, "delay", _t512)
				else:
					J.sp(v_n_279, "call", null)
					J.sp(v_n_279, "next", null)
					var _t514 = J.gp(v_c_285, "x")
					var _t515 = J.gp(v_c_285, "y")
					var _t516 = J.gp(v_c_285, "wait")
					var _t517 = J.gp(v_c_285, "act")
					var _t518 = J.gp(v_c_285, "say")
					var _t513 = J.gp(v_c_285, "boss")
					var _t519 = {"x": _t514, "y": _t515, "wait": _t516, "act": _t517, "arrived": false, "path": null, "pi": 0.0, "say": _t518, "called": true, "boss": (_t513 if J.t(_t513) else null)}
					J.sp(v_n_279, "step", _t519)
					if J.t(J.gp(v_c_285, "go")):
						J.mc(this_, "bubble", [v_n_279, J.gp(v_c_285, "go"), 2.2])
	if (not J.t(J.gp(v_n_279, "step"))):
		var _t520 = (J.mc(this_, "mkStep", [v_n_279, J.gp(v_n_279, "next")]) if J.t(J.gp(v_n_279, "next")) else J.mc(this_, "planNext", [v_n_279]))
		J.sp(v_n_279, "step", _t520)
		J.sp(v_n_279, "next", null)
		if J.t(J.gp(J.gp(v_n_279, "step"), "arrived")):
			var _t521 = J.gp(J.gp(v_n_279, "step"), "wait")
			J.sp(v_n_279, "wait", _t521)
	v_s_282 = J.gp(v_n_279, "step")
	var _t522 = (not J.t(J.gp(v_s_282, "arrived")))
	if ((not J.t(J.gp(v_s_282, "go"))) if _t522 else _t522):
		var _t523 = J.gp(v_s_282, "hold")
		var _t524 = J.add((_t523 if J.t(_t523) else 0.0), v_dt_280)
		J.sp(v_s_282, "hold", _t524)
		var _t525 = (not J.seq(J.gp(v_n_279, "act"), "walk"))
		var _t527 = ((not J.t(J.mc(this_, "inDoor", [J.gp(v_n_279, "x")]))) if _t525 else _t525)
		if J.t(_t527):
			var _t526 = J.gp(v_s_282, "called")
			_t527 = (not J.t((J.seq(J.gp(J.gp(v_n_279, "d"), "k"), "boss") if J.t(_t526) else _t526)))
		var _t528 = (J.mc(this_, "walkBlocked", [v_n_279, J.gp(v_s_282, "x")]) if _t527 else _t527)
		var _t529 = (J.cmp(J.gp(v_s_282, "hold"), 6.0, "<") if J.t(_t528) else _t528)
		if J.t(((not J.t(J.gp(v_n_279, "fleeing"))) if J.t(_t529) else _t529)):
			J.sp(v_n_279, "act", "idle")
			return null
		J.sp(v_s_282, "go", true)
	if (not J.t(J.gp(v_s_282, "arrived"))):
		var _t530 = J.gp(v_s_282, "path")
		v_tgt_287 = (J.gp(J.gp(v_s_282, "path"), J.gp(v_s_282, "pi")) if J.t((J.cmp(J.gp(v_s_282, "pi"), J.len(J.gp(v_s_282, "path")), "<") if J.t(_t530) else _t530)) else [J.gp(v_s_282, "x"), J.gp(v_s_282, "y")])
		v_dx_288 = J.sub(J.gp(v_tgt_287, 0.0), J.gp(v_n_279, "x"))
		v_dy_289 = J.sub(J.gp(v_tgt_287, 1.0), J.gp(v_n_279, "y"))
		v_dd_290 = J.hypot_([v_dx_288, v_dy_289])
		v_sp_291 = J.mul(J.mul(J.gp(v_d_281, "speed"), (0.55 if J.cmp(J.gp(v_n_279, "fear"), 50.0, ">=") else 1.0)), v_dt_280)
		var _t531 = ("mop" if J.t(J.gp(v_s_282, "mopWalk")) else "walk")
		J.sp(v_n_279, "act", _t531)
		if J.t(J.gp(v_s_282, "mopWalk")):
			J.sp(v_n_279, "act", "walk")
		if J.cmp(J.gp(v_n_279, "fear"), 25.0, "<"):
			var _t532 = (1.0 if J.cmp(v_dx_288, 0.0, ">=") else (-1.0))
			J.sp(v_n_279, "dir", _t532)
		if J.cmp(v_dd_290, v_sp_291, "<="):
			var _t533 = J.gp(v_tgt_287, 0.0)
			J.sp(v_n_279, "x", _t533)
			var _t534 = J.gp(v_tgt_287, 1.0)
			J.sp(v_n_279, "y", _t534)
			var _t535 = J.gp(v_s_282, "path")
			if J.t((J.cmp(J.gp(v_s_282, "pi"), J.len(J.gp(v_s_282, "path")), "<") if J.t(_t535) else _t535)):
				J.sp(v_s_282, "pi", J.num(J.gp(v_s_282, "pi")) + 1.0)
				return null
			J.sp(v_s_282, "arrived", true)
			var _t536 = J.gp(v_s_282, "wait")
			J.sp(v_n_279, "wait", _t536)
			if J.t(J.gp(v_s_282, "say")):
				J.mc(this_, "bubble", [v_n_279, J.gp(v_s_282, "say"), 2.4])
			if J.t(J.gp(v_s_282, "out")):
				J.mc(this_, "goOut", [v_n_279, J.gp(v_s_282, "outDur"), J.gp(v_s_282, "leave"), J.gp(v_s_282, "backSay")])
				return null
		else:
			var _t537 = J.add(J.gp(v_n_279, "x"), J.mul(J.div(v_dx_288, v_dd_290), v_sp_291))
			J.sp(v_n_279, "x", _t537)
			var _t538 = J.add(J.gp(v_n_279, "y"), J.mul(J.div(v_dy_289, v_dd_290), v_sp_291))
			J.sp(v_n_279, "y", _t538)
		return null
	var _t539 = J.gp(v_s_282, "act")
	J.sp(v_n_279, "act", _t539)
	var _t540 = J.sub(J.gp(v_n_279, "wait"), J.mul(v_dt_280, (0.4 if J.cmp(J.gp(v_n_279, "fear"), 50.0, ">=") else 1.0)))
	J.sp(v_n_279, "wait", _t540)
	var _t541 = J.gp(v_s_282, "called")
	var _t542 = (J.gp(v_s_282, "boss") if J.t(_t541) else _t541)
	if J.t((J.cmp(J.gp(v_n_279, "fear"), 50.0, "<") if J.t(_t542) else _t542)):
		v_b_292 = J.gp(v_s_282, "boss")
		var _t543 = J.gp(v_b_292, "gone")
		var _t544 = (_t543 if J.t(_t543) else J.gp(v_b_292, "out"))
		var _t545 = (_t544 if J.t(_t544) else J.gp(v_b_292, "fleeing"))
		if J.t((_t545 if J.t(_t545) else (not J.seq(J.mc(this_, "roomOf", [v_b_292]), "boss")))):
			var _t546 = J.gp(v_s_282, "empty")
			var _t547 = J.add((_t546 if J.t(_t546) else 0.0), v_dt_280)
			J.sp(v_s_282, "empty", _t547)
			var _t548 = J.add(J.gp(v_n_279, "wait"), v_dt_280)
			J.sp(v_n_279, "wait", _t548)
			if J.cmp(J.gp(v_s_282, "empty"), 6.0, ">"):
				var _t549 = J.gp(J.G.get("EMPTY_SAY"), J.gp(J.gp(v_n_279, "d"), "k"))
				J.mc(this_, "bubble", [v_n_279, (_t549 if J.t(_t549) else J.gp(J.G.get("EMPTY_SAY"), "it")), 2.6])
				J.sp(v_n_279, "step", null)
				return null
		else:
			J.sp(v_s_282, "empty", 0.0)
	var _t550 = J.gp(v_d_281, "post")
	v_atPost_283 = ((J.hypot_([J.sub(J.gp(v_n_279, "x"), J.gp(J.gp(v_d_281, "post"), 0.0)), J.sub(J.gp(v_n_279, "y"), J.gp(J.gp(v_d_281, "post"), 1.0))]) < 0.012) if J.t(_t550) else _t550)
	var _t551 = (J.gp(J.gp(v_d_281, "post"), 3.0) if J.t(v_atPost_283) else v_atPost_283)
	if J.t((J.cmp(J.gp(v_n_279, "fear"), 25.0, "<") if J.t(_t551) else _t551)):
		var _t552 = J.gp(J.gp(v_d_281, "post"), 3.0)
		J.sp(v_n_279, "dir", _t552)
	var _t553 = J.seq(J.gp(v_n_279, "act"), "present")
	if (J.cmp(J.gp(v_n_279, "fear"), 25.0, "<") if _t553 else _t553):
		J.sp(v_n_279, "dir", 1.0)
	var _t554 = J.gp(v_s_282, "sit")
	var _t555 = (J.seq(J.gp(v_s_282, "act"), "brk_nap") if J.t(_t554) else _t554)
	if J.t((J.cmp(J.gp(v_n_279, "fear"), 25.0, "<") if J.t(_t555) else _t555)):
		var _t556 = (1.0 if J.cmp(J.gp(v_n_279, "x"), J.add(J.gp(J.gp(J.G.get("_SP"), "restTable"), 0.0), 0.01), "<=") else (-1.0))
		J.sp(v_n_279, "dir", _t556)
	var _t557 = J.gp(J.gp(v_n_279, "d"), "guard")
	var _t558 = (J.seq(J.gp(v_n_279, "act"), "doze") if J.t(_t557) else _t557)
	if J.t((J.cmp(J.gp(v_n_279, "fear"), 0.0, ">") if J.t(_t558) else _t558)):
		J.sp(v_n_279, "act", "look")
	var _t559 = (J.gp(v_d_281, "lines") if J.t(v_atPost_283) else v_atPost_283)
	var _t560 = (J.gp(J.gp(v_d_281, "lines"), "work") if J.t(_t559) else _t559)
	var _t561 = (J.cmp(J.gp(v_n_279, "fear"), 25.0, "<") if J.t(_t560) else _t560)
	if J.t(((not J.t(J.gp(v_s_282, "cue"))) if J.t(_t561) else _t561)):
		var _t562 = J.sub(((4.0 + J.mul(J.mc(this_, "rng", [v_n_279]), 6.0)) if J.leq(J.gp(v_n_279, "wl"), null) else J.gp(v_n_279, "wl")), v_dt_280)
		J.sp(v_n_279, "wl", _t562)
		if J.cmp(J.gp(v_n_279, "wl"), 0.0, "<="):
			var _t563 = (9.0 + J.mul(J.mc(this_, "rng", [v_n_279]), 8.0))
			J.sp(v_n_279, "wl", _t563)
			var _t567 = (not J.t(J.gp(v_n_279, "bub")))
			if J.t(_t567):
				var _t566 = J.gp(this_, "headless")
				if not J.t(_t566):
					var _t564 = J.gp(this_, "npcs")
					_t566 = (not J.t(J.mc(_t564, "some", [Callable(self, "_f77").bind(env)])))
				_t567 = _t566
			if J.t(_t567):
				J.mc(this_, "bubble", [v_n_279, J.gp(J.gp(J.gp(v_d_281, "lines"), "work"), floor(J.num(J.mul(J.mc(this_, "rng", [v_n_279]), J.len(J.gp(J.gp(v_d_281, "lines"), "work")))))), 2.4])
	if J.cmp(J.gp(v_n_279, "wait"), 0.0, "<="):
		if J.t(J.gp(v_s_282, "meet")):
			v_i_294 = 0.0
			for _t568 in J.iter(J.gp(this_, "npcs")):
				v_m_295 = _t568
				var _t569 = J.gp(v_m_295, "step")
				var _t570 = (J.seq(J.gp(J.gp(v_m_295, "step"), "act"), "notes") if J.t(_t569) else _t569)
				if J.t((J.gp(J.gp(v_m_295, "step"), "arrived") if J.t(_t570) else _t570)):
					var _t572 = J.gp(v_m_295, "wait")
					var _t571 = J.num(v_i_294)
					v_i_294 = _t571 + 1.0
					var _t574 = J.gp(v_m_295, "wait")
					var _t573 = J.num(v_i_294)
					v_i_294 = _t573 + 1.0
					var _t575 = J.min_([_t574, (1.5 + (3.0 * _t573))])
					J.sp(v_m_295, "wait", _t575)
				else:
					var _t576 = J.gp(v_m_295, "call")
					if J.t((J.seq(J.gp(J.gp(v_m_295, "call"), "act"), "notes") if J.t(_t576) else _t576)):
						J.sp(v_m_295, "call", null)
			J.mc(this_, "bubble", [v_n_279, "散會！聽朝九點前交。", 2.4])
		J.sp(v_n_279, "step", null)

func _f79(this_, a: Array, env):
	var v_a_304 = null; var v_p_305 = null
	v_a_304 = J.arg(a, 0)
	v_p_305 = J.arg(a, 1)
	return ((J.hypot_([J.sub(J.gp(v_a_304, 0.0), J.gp(v_p_305, 0.0)), J.sub(J.gp(v_a_304, 1.0), J.gp(v_p_305, 1.0))]) < 0.02) if J.t(v_a_304) else v_a_304)

func _f81(this_, a: Array, env):
	var v_m_307 = null
	v_m_307 = J.arg(a, 0)
	var _t578 = (not J.seq(v_m_307, env["__p"]["n"]))
	var _t579 = ((not J.t(J.gp(v_m_307, "gone"))) if _t578 else _t578)
	var _t586 = ((not J.t(J.gp(v_m_307, "out"))) if _t579 else _t579)
	if J.t(_t586):
		var _t580 = env["__p"]["near"]
		var _t583 = J.cl(_t580, null, [[J.gp(v_m_307, "x"), J.gp(v_m_307, "y")], env["p"]])
		if not J.t(_t583):
			var _t582 = J.gp(v_m_307, "step")
			if J.t(_t582):
				var _t581 = env["__p"]["near"]
				_t582 = J.cl(_t581, null, [[J.gp(J.gp(v_m_307, "step"), "x"), J.gp(J.gp(v_m_307, "step"), "y")], env["p"]])
			_t583 = _t582
		var _t585 = _t583
		if not J.t(_t585):
			var _t584 = env["__p"]["near"]
			_t585 = J.cl(_t584, null, [J.gp(v_m_307, "napAt"), env["p"]])
		_t586 = _t585
	return _t586

func _f80(this_, a: Array, env):
	var _s183 = {"__p": env, "p": null}
	_s183["p"] = J.arg(a, 0)
	var _t577 = J.gp(_s183["__p"]["this"], "npcs")
	return J.mc(_t577, "some", [Callable(self, "_f81").bind(_s183)])

func _f82(this_, a: Array, env):
	var v_p_308 = null
	v_p_308 = J.arg(a, 0)
	var _t588 = env["busy"]
	return (not J.t(J.cl(_t588, null, [v_p_308])))

func _f78(this_, a: Array, env):
	var v_pref_299 = null; var v_S_300 = null; var v_f_303 = null
	var _s181 = {"__p": env, "this": null, "n": null, "near": null, "busy": null}
	_s181["this"] = this_
	_s181["n"] = J.arg(a, 0)
	v_pref_299 = J.arg(a, 1)
	v_S_300 = J.gp(J.G.get("_SP"), "restSeats")
	_s181["near"] = Callable(self, "_f79").bind(_s181)
	_s181["busy"] = Callable(self, "_f80").bind(_s181)
	var _t587 = _s181["busy"]
	if (not J.t(J.cl(_t587, null, [v_pref_299]))):
		return [J.gp(v_pref_299, 0.0), J.gp(v_pref_299, 1.0)]
	v_f_303 = J.mc(v_S_300, "find", [Callable(self, "_f82").bind(_s181)])
	return ([J.gp(v_f_303, 0.0), J.gp(v_f_303, 1.0)] if J.t(v_f_303) else [J.gp(v_pref_299, 0.0), J.gp(v_pref_299, 1.0)])

func _f85(this_, a: Array, env):
	var v_m_324 = null
	v_m_324 = J.arg(a, 0)
	var _t590 = (not J.seq(v_m_324, env["__p"]["n"]))
	var _t591 = ((not J.t(J.gp(v_m_324, "gone"))) if _t590 else _t590)
	var _t596 = ((not J.t(J.gp(v_m_324, "out"))) if _t591 else _t591)
	if J.t(_t596):
		var _t592 = J.gp(v_m_324, "step")
		var _t593 = ((J.hypot_([J.sub(J.gp(J.gp(v_m_324, "step"), "x"), J.gp(env["p"], 0.0)), J.sub(J.gp(J.gp(v_m_324, "step"), "y"), J.gp(env["p"], 1.0))]) < 0.01) if J.t(_t592) else _t592)
		var _t595 = (_t593 if J.t(_t593) else (J.hypot_([J.sub(J.gp(v_m_324, "x"), J.gp(env["p"], 0.0)), J.sub(J.gp(v_m_324, "y"), J.gp(env["p"], 1.0))]) < 0.01))
		if not J.t(_t595):
			var _t594 = J.gp(v_m_324, "napAt")
			_t595 = ((J.hypot_([J.sub(J.gp(J.gp(v_m_324, "napAt"), 0.0), J.gp(env["p"], 0.0)), J.sub(J.gp(J.gp(v_m_324, "napAt"), 1.0), J.gp(env["p"], 1.0))]) < 0.01) if J.t(_t594) else _t594)
		_t596 = _t595
	return _t596

func _f84(this_, a: Array, env):
	var _s187 = {"__p": env, "p": null}
	_s187["p"] = J.arg(a, 0)
	var _t589 = J.gp(_s187["__p"]["this"], "npcs")
	return J.mc(_t589, "some", [Callable(self, "_f85").bind(_s187)])

func _f86(this_, a: Array, env):
	var v_p_325 = null
	v_p_325 = J.arg(a, 0)
	var _t597 = env["busy"]
	return (not J.t(J.cl(_t597, null, [v_p_325])))

func _f83(this_, a: Array, env):
	var v_wait_312 = null; var v_say_313 = null; var v_acts_314 = null; var v_S_315 = null; var v_free_317 = null; var v_px_318 = null; var v_py_319 = null; var v_pact_320 = null; var v_p_321 = null; var v_a_322 = null
	var _s186 = {"__p": env, "this": null, "n": null, "busy": null}
	_s186["this"] = this_
	_s186["n"] = J.arg(a, 0)
	v_wait_312 = J.arg(a, 1)
	v_say_313 = J.arg(a, 2)
	v_acts_314 = J.arg(a, 3)
	v_S_315 = J.gp(J.G.get("_SP"), "restSeats")
	_s186["busy"] = Callable(self, "_f84").bind(_s186)
	v_free_317 = J.mc(v_S_315, "filter", [Callable(self, "_f86").bind(_s186)])
	var _t598 = J.gp(J.gp(_s186["n"], "d"), "post")
	var _t599 = J.gp(_t598, 0.0)
	v_px_318 = _t599
	var _t600 = J.gp(_t598, 1.0)
	v_py_319 = _t600
	var _t601 = J.gp(_t598, 2.0)
	v_pact_320 = _t601
	var _t602 = (not J.t(J.len(v_free_317)))
	if J.t((_t602 if _t602 else J.mc(_s186["this"], "busy", [_s186["n"], J.gp(J.gp(v_free_317, 0.0), 0.0)]))):
		return {"x": v_px_318, "y": v_py_319, "wait": J.mc(_s186["this"], "U", [_s186["n"], 4.0, 8.0]), "act": v_pact_320, "arrived": true}
	v_p_321 = J.gp(v_free_317, floor(J.num(J.mul(J.mc(_s186["this"], "rng", [_s186["n"]]), J.len(v_free_317)))))
	v_a_322 = (v_acts_314 if J.t(v_acts_314) else ["brk_phone", "brk_drink", "brk_nap"])
	if J.t(v_say_313):
		J.mc(_s186["this"], "bubble", [_s186["n"], v_say_313, 2.2])
	return {"x": J.gp(v_p_321, 0.0), "y": J.gp(v_p_321, 1.0), "wait": v_wait_312, "act": J.gp(v_a_322, floor(J.num(J.mul(J.mc(_s186["this"], "rng", [_s186["n"]]), J.len(v_a_322))))), "arrived": false, "path": null, "pi": 0.0, "sit": true}

func _f87(this_, a: Array, env):
	var v_n_328 = null
	v_n_328 = J.arg(a, 0)
	var _t603 = J.gp(v_n_328, "gone")
	var _t604 = (_t603 if J.t(_t603) else J.gp(v_n_328, "out"))
	var _t605 = (_t604 if J.t(_t604) else J.gp(v_n_328, "fleeing"))
	if J.t((_t605 if J.t(_t605) else J.seq(J.gp(v_n_328, "act"), "walk"))):
		return false
	var _t608 = J.gp(v_n_328, "act")
	if J.t(_t608):
		var _t606 = J.gp(v_n_328, "act")
		var _t607 = J.mc(_t606, "startsWith", ["brk_"])
		_t608 = (_t607 if J.t(_t607) else J.seq(J.gp(v_n_328, "act"), "notes"))
	if J.t(_t608):
		return true
	var _t609 = J.gp(J.gp(this_, "site"), "pano")
	var _t610 = (J.seq(J.gp(J.gp(v_n_328, "d"), "k"), "mis") if J.t(_t609) else _t609)
	return ((J.hypot_([J.sub(J.gp(v_n_328, "x"), J.gp(J.G.get("MIS_POST"), 0.0)), J.sub(J.gp(v_n_328, "y"), J.gp(J.G.get("MIS_POST"), 1.0))]) < 0.012) if J.t(_t610) else _t610)

func _f88(this_, a: Array, env):
	var v_n_331 = null; var v_x_332 = null; var v_y_333 = null; var v_p_334 = null
	v_n_331 = J.arg(a, 0)
	v_x_332 = J.arg(a, 1)
	v_y_333 = J.arg(a, 2)
	v_p_334 = []
	var _t611 = J.G.get("_MY")
	var _t613 = J.cmp(v_y_333, J.cl(_t611, null, [0.6]), "<")
	if J.t(_t613):
		var _t612 = J.G.get("_M")
		_t613 = J.cmp(v_x_332, J.cl(_t612, null, [0.5]), ">")
	var _t615 = _t613
	if J.t(_t615):
		var _t614 = J.G.get("_M")
		_t615 = J.cmp(v_x_332, J.cl(_t614, null, [0.86]), "<")
	if _t615:
		var _t616 = J.G.get("_M")
		var _t618 = J.cl(_t616, null, [0.8])
		var _t617 = J.G.get("_MY")
		J.mc(v_p_334, "push", [[_t618, J.cl(_t617, null, [0.6])]])
	return v_p_334

func _f89(this_, a: Array, env):
	var v_n_337 = null; var v_o_338 = null; var v_ex_339 = null; var v_ey_340 = null
	v_n_337 = J.arg(a, 0)
	v_o_338 = J.arg(a, 1)
	var _t619 = J.mc(this_, "exitPt", [])
	var _t620 = J.gp(_t619, 0.0)
	v_ex_339 = _t620
	var _t621 = J.gp(_t619, 1.0)
	v_ey_340 = _t621
	if J.t(J.gp(v_o_338, "out")):
		J.sp(v_n_337, "leaving", true)
		if J.t(J.gp(v_o_338, "sayStart")):
			J.mc(this_, "bubble", [v_n_337, J.gp(v_o_338, "sayStart"), 2.4])
		return {"x": v_ex_339, "y": v_ey_340, "path": J.mc(this_, "viaElev", [v_n_337, J.gp(v_n_337, "x"), J.gp(v_n_337, "y")]), "pi": 0.0, "out": true, "leave": J.gp(v_o_338, "leave"), "outDur": J.gp(v_o_338, "outDur"), "backSay": J.gp(v_o_338, "backSay")}
	return v_o_338

func _f91(this_, a: Array, env):
	var v_a_355 = null; var v_b_356 = null
	v_a_355 = J.arg(a, 0)
	v_b_356 = J.arg(a, 1)
	return J.mc(env["this"], "U", [env["n"], v_a_355, v_b_356])

func _f92(this_, a: Array, env):
	var v_m_367 = null
	v_m_367 = J.arg(a, 0)
	var _t657 = J.seq(J.gp(J.gp(v_m_367, "d"), "k"), "boss")
	var _t658 = ((not J.t(J.gp(v_m_367, "out"))) if _t657 else _t657)
	var _t659 = ((not J.t(J.gp(v_m_367, "gone"))) if _t658 else _t658)
	return ((not J.t(J.gp(v_m_367, "fleeing"))) if _t659 else _t659)

func _f90(this_, a: Array, env):
	var v_d_344 = null; var v_U_345 = null; var v_px_346 = null; var v_py_347 = null; var v_pact_348 = null; var v_atPost_349 = null; var v_tr_350 = null; var v_tot_351 = null; var v_r_352 = null; var v_e_353 = null; var v_to_354 = null; var v_p0_357 = null; var v_p_358 = null; var v_tr_359 = null; var v_st_360 = null; var v_p_361 = null; var v_e_362 = null; var v_q_363 = null; var v_P_364 = null; var v_p_365 = null; var v_b_366 = null
	var _s194 = {"__p": env, "this": null, "n": null}
	_s194["this"] = this_
	_s194["n"] = J.arg(a, 0)
	v_d_344 = J.gp(_s194["n"], "d")
	v_U_345 = Callable(self, "_f91").bind(_s194)
	var _t622 = J.gp(v_d_344, "post")
	var _t623 = J.gp(_t622, 0.0)
	v_px_346 = _t623
	var _t624 = J.gp(_t622, 1.0)
	v_py_347 = _t624
	var _t625 = J.gp(_t622, 2.0)
	v_pact_348 = _t625
	v_atPost_349 = (J.hypot_([J.sub(J.gp(_s194["n"], "x"), v_px_346), J.sub(J.gp(_s194["n"], "y"), v_py_347)]) < 0.012)
	if J.t(J.gp(v_d_344, "lane")):
		var _t626 = _s194["n"]
		var _t627 = J.gp(_s194["n"], "li")
		var _t628 = J.add((_t627 if J.t(_t627) else 0.0), 1.0)
		J.sp(_t626, "li", _t628)
		var _t629 = J.gp(v_d_344, "tripEvery")
		var _t630 = (J.seq(J.mod(J.gp(_s194["n"], "li"), J.mul(J.gp(v_d_344, "tripEvery"), J.len(J.gp(v_d_344, "lane")))), 0.0) if J.t(_t629) else _t629)
		if J.t((J.cmp(J.mc(_s194["this"], "present", [_s194["n"]]), 3.0, ">=") if J.t(_t630) else _t630)):
			v_tr_359 = J.gp(J.gp(v_d_344, "trips"), 0.0)
			return J.mc(_s194["this"], "mkStep", [_s194["n"], {"out": true, "outDur": J.cl(v_U_345, null, J.spread([J.SP(J.gp(v_tr_359, 3.0))])), "backSay": J.gp(v_tr_359, 5.0), "sayStart": J.gp(v_tr_359, 4.0)}])
		var _t631 = J.seq(J.mod(J.gp(_s194["n"], "li"), J.len(J.gp(v_d_344, "lane"))), 4.0)
		var _t632 = (J.seq(J.mc(_s194["this"], "roomOf", [_s194["n"]]), "pantry") if _t631 else _t631)
		if (J.cmp(J.mc(_s194["this"], "rng", [_s194["n"]]), 0.6, "<") if _t632 else _t632):
			v_st_360 = J.mc(_s194["this"], "restStep", [_s194["n"], J.cl(v_U_345, null, [8.0, 12.0]), J.gp(J.G.get("BRK"), "auntie"), ["brk_drink", "brk_nap"]])
			if J.t(J.gp(v_st_360, "sit")):
				return v_st_360
		v_p0_357 = J.gp(J.gp(v_d_344, "lane"), J.mod(J.gp(_s194["n"], "li"), J.len(J.gp(v_d_344, "lane"))))
		v_p_358 = J.mc(_s194["this"], "freeSpot", [_s194["n"], J.gp(v_p0_357, 0.0), J.gp(v_p0_357, 1.0)])
		return {"x": J.gp(v_p_358, 0.0), "y": J.gp(v_p_358, 1.0), "wait": J.cl(v_U_345, null, J.spread([J.SP(J.gp(v_d_344, "laneWait"))])), "act": "mop", "arrived": false, "mopWalk": true}
	var _t633 = J.gp(v_d_344, "guard")
	var _t634 = (J.gp(_s194["n"], "tour") if J.t(_t633) else _t633)
	if J.t((J.len(J.gp(_s194["n"], "tour")) if J.t(_t634) else _t634)):
		v_p_361 = J.mc(J.gp(_s194["n"], "tour"), "shift", [])
		return {"x": J.gp(v_p_361, 0.0), "y": J.gp(v_p_361, 1.0), "wait": J.cl(v_U_345, null, [3.0, 4.5]), "act": "look", "arrived": false, "path": null, "pi": 0.0}
	if (not J.t(v_atPost_349)):
		var _t644 = J.cl(v_U_345, null, J.spread([J.SP(J.mc(_s194["this"], "workOf", [_s194["n"]]))]))
		var _t636 = J.gp(_s194["n"], "y")
		var _t635 = J.G.get("_MY")
		var _t639 = J.cmp(_t636, J.cl(_t635, null, [0.56]), "<")
		if J.t(_t639):
			var _t638 = J.gp(_s194["n"], "x")
			var _t637 = J.G.get("_M")
			_t639 = J.cmp(_t638, J.cl(_t637, null, [0.85]), ">")
		var _t643 = null
		if _t639:
			var _t640 = J.G.get("_M")
			var _t642 = J.cl(_t640, null, [0.8])
			var _t641 = J.G.get("_MY")
			_t643 = [[_t642, J.cl(_t641, null, [0.6])]]
		else:
			_t643 = null
		return {"x": v_px_346, "y": v_py_347, "wait": _t644, "act": v_pact_348, "arrived": false, "path": _t643, "pi": 0.0}
	var _t645 = J.gp(v_d_344, "trips")
	v_tr_350 = (_t645 if J.t(_t645) else [])
	v_tot_351 = 0.0
	for _t646 in J.iter(v_tr_350):
		v_e_362 = _t646
		var _t647 = J.add(v_tot_351, J.gp(v_e_362, 1.0))
		v_tot_351 = _t647
	v_r_352 = J.mul(J.mc(_s194["this"], "rng", [_s194["n"]]), v_tot_351)
	v_e_353 = J.gp(v_tr_350, 0.0)
	for _t648 in J.iter(v_tr_350):
		v_q_363 = _t648
		var _t649 = J.sub(v_r_352, J.gp(v_q_363, 1.0))
		v_r_352 = _t649
		if J.cmp(v_r_352, 0.0, "<="):
			v_e_353 = v_q_363
			break
	if (not J.t(v_e_353)):
		return {"x": v_px_346, "y": v_py_347, "wait": J.cl(v_U_345, null, J.spread([J.SP(J.mc(_s194["this"], "workOf", [_s194["n"]]))])), "act": v_pact_348, "arrived": true}
	if J.seq(J.gp(v_e_353, 2.0), "out"):
		var _t650 = J.cmp(J.mc(_s194["this"], "present", [_s194["n"]]), 2.0, "<")
		if J.t((_t650 if _t650 else J.mc(_s194["this"], "busy", [_s194["n"], J.gp(J.mc(_s194["this"], "exitPt", []), 0.0)]))):
			return {"x": v_px_346, "y": v_py_347, "wait": J.cl(v_U_345, null, [4.0, 8.0]), "act": v_pact_348, "arrived": true}
		return J.mc(_s194["this"], "mkStep", [_s194["n"], {"out": true, "outDur": J.cl(v_U_345, null, J.spread([J.SP(J.gp(v_e_353, 3.0))])), "backSay": J.gp(v_e_353, 5.0), "sayStart": J.gp(v_e_353, 4.0)}])
	v_to_354 = J.gp(v_e_353, 2.0)
	if J.seq(v_to_354, "patrol"):
		v_P_364 = J.gp(J.G.get("OFFMAP"), "PATROL")
		var _t651 = _s194["n"]
		var _t652 = J.gp(_s194["n"], "pt")
		var _t653 = J.add((_t652 if J.t(_t652) else 0.0), 1.0)
		J.sp(_t651, "pt", _t653)
		var _t654 = _s194["n"]
		var _t655 = (J.mc(v_P_364, "slice", [3.0]) if J.t(J.mod(J.gp(_s194["n"], "pt"), 2.0)) else [J.gp(v_P_364, 2.0), J.gp(v_P_364, 1.0), J.gp(v_P_364, 0.0)])
		J.sp(_t654, "tour", _t655)
		v_p_365 = J.mc(J.gp(_s194["n"], "tour"), "shift", [])
		if J.t(J.gp(v_e_353, 4.0)):
			J.mc(_s194["this"], "bubble", [_s194["n"], J.gp(v_e_353, 4.0), 2.2])
		return {"x": J.gp(v_p_365, 0.0), "y": J.gp(v_p_365, 1.0), "wait": J.cl(v_U_345, null, [3.0, 4.5]), "act": "look", "arrived": false, "path": null, "pi": 0.0}
	if J.seq(v_to_354, "rest"):
		return J.mc(_s194["this"], "restStep", [_s194["n"], J.cl(v_U_345, null, J.spread([J.SP(J.gp(v_e_353, 3.0))])), J.gp(v_e_353, 4.0), J.gp(v_e_353, 6.0)])
	if J.seq(v_to_354, "boss"):
		var _t656 = J.gp(_s194["this"], "npcs")
		v_b_366 = J.mc(_t656, "find", [Callable(self, "_f92").bind(_s194)])
		var _t660 = (not J.t(v_b_366))
		if (_t660 if _t660 else (not J.seq(J.mc(_s194["this"], "roomOf", [v_b_366]), "boss"))):
			return {"x": v_px_346, "y": v_py_347, "wait": J.cl(v_U_345, null, [4.0, 8.0]), "act": v_pact_348, "arrived": true}
		v_to_354 = J.gp(J.G.get("_SP"), "bossVisit")
	if J.t(J.mc(_s194["this"], "busy", [_s194["n"], J.gp(v_to_354, 0.0)])):
		return {"x": v_px_346, "y": v_py_347, "wait": J.cl(v_U_345, null, [3.0, 6.0]), "act": v_pact_348, "arrived": true}
	var _t661 = J.mc(_s194["this"], "freeSpot", [_s194["n"], J.gp(v_to_354, 0.0), J.gp(v_to_354, 1.0)])
	v_to_354 = _t661
	if J.t(J.gp(v_e_353, 4.0)):
		J.mc(_s194["this"], "bubble", [_s194["n"], J.gp(v_e_353, 4.0), 2.2])
	return {"x": J.gp(v_to_354, 0.0), "y": J.gp(v_to_354, 1.0), "wait": J.cl(v_U_345, null, J.spread([J.SP(J.gp(v_e_353, 3.0))])), "act": "idle", "arrived": false, "path": null, "pi": 0.0}

func _f94(this_, a: Array, env):
	var v_v_373 = null
	v_v_373 = J.arg(a, 0)
	var _t662 = J.cmp(env["x"], J.div(J.sub(v_v_373, 45.0), 1165.0), ">=")
	return (J.cmp(env["x"], J.div(J.add(J.add(v_v_373, env["w"]), 45.0), 1165.0), "<=") if _t662 else _t662)

func _f93(this_, a: Array, env):
	var v_W_371 = null
	var _s208 = {"__p": env, "x": null, "w": null}
	_s208["x"] = J.arg(a, 0)
	if (not J.t(J.gp(J.gp(this_, "site"), "pano"))):
		return false
	v_W_371 = J.gp(J.G.get("OFFMAP"), "WALLS")
	_s208["w"] = J.gp(J.G.get("OFFMAP"), "WALLW")
	return J.mc(v_W_371, "some", [Callable(self, "_f94").bind(_s208)])

func _f97(this_, a: Array, env):
	var v_m_381 = null
	v_m_381 = J.arg(a, 0)
	var _t666 = (not J.seq(v_m_381, env["__p"]["n"]))
	var _t667 = ((not J.t(J.gp(v_m_381, "gone"))) if _t666 else _t666)
	var _t668 = ((not J.t(J.gp(v_m_381, "out"))) if _t667 else _t667)
	var _t672 = ((not J.t(J.gp(v_m_381, "fleeing"))) if _t668 else _t668)
	if J.t(_t672):
		var _t671 = J.seq(J.gp(v_m_381, "act"), "walk")
		if not J.t(_t671):
			var _t669 = (not J.t(J.gp(J.gp(v_m_381, "d"), "post")))
			var _t670 = ((not J.t(J.gp(J.gp(v_m_381, "d"), "daoshi"))) if _t669 else _t669)
			_t671 = (J.cmp(J.gp(v_m_381, "wait"), 7.0, "<") if _t670 else _t670)
		_t672 = _t671
	return (J.seq(J.mc(J.G.get("OFFMAP"), "roomAt", [J.gp(v_m_381, "x")]), env["r"]) if _t672 else _t672)

func _f96(this_, a: Array, env):
	var _s211 = {"__p": env, "r": null}
	_s211["r"] = J.arg(a, 0)
	var _t664 = J.cmp(J.gp(_s211["r"], "x1"), _s211["__p"]["a"], ">")
	var _t673 = (J.cmp(J.gp(_s211["r"], "x0"), J.add(_s211["__p"]["b"], 0.000001), "<") if _t664 else _t664)
	if J.t(_t673):
		var _t665 = J.gp(_s211["__p"]["this"], "npcs")
		_t673 = (J.len(J.mc(_t665, "filter", [Callable(self, "_f97").bind(_s211)])) >= 2.0)
	return _t673

func _f95(this_, a: Array, env):
	var v_tx_377 = null
	var _s210 = {"__p": env, "this": null, "n": null, "a": null, "b": null}
	_s210["this"] = this_
	_s210["n"] = J.arg(a, 0)
	v_tx_377 = J.arg(a, 1)
	if (not J.t(J.gp(J.gp(_s210["this"], "site"), "pano"))):
		return false
	_s210["a"] = J.min_([J.gp(_s210["n"], "x"), v_tx_377])
	_s210["b"] = J.max_([J.gp(_s210["n"], "x"), v_tx_377])
	var _t663 = J.gp(J.G.get("OFFMAP"), "ROOMS")
	return J.mc(_t663, "some", [Callable(self, "_f96").bind(_s210)])

func _f100(this_, a: Array, env):
	var v_m_388 = null
	v_m_388 = J.arg(a, 0)
	var _t675 = (not J.seq(v_m_388, env["__p"]["n"]))
	var _t676 = ((not J.t(J.gp(v_m_388, "gone"))) if _t675 else _t675)
	var _t677 = ((not J.t(J.gp(v_m_388, "out"))) if _t676 else _t676)
	var _t678 = (J.seq(J.gp(v_m_388, "act"), "walk") if _t677 else _t677)
	return (J.seq(J.mc(J.G.get("OFFMAP"), "roomAt", [J.gp(v_m_388, "x")]), env["r"]) if _t678 else _t678)

func _f99(this_, a: Array, env):
	var _s214 = {"__p": env, "r": null}
	_s214["r"] = J.arg(a, 0)
	var _t674 = J.gp(_s214["__p"]["this"], "npcs")
	return (J.len(J.mc(_t674, "filter", [Callable(self, "_f100").bind(_s214)])) >= 2.0)

func _f98(this_, a: Array, env):
	var v_tx_385 = null; var v_rs_386 = null
	var _s213 = {"__p": env, "this": null, "n": null}
	_s213["this"] = this_
	_s213["n"] = J.arg(a, 0)
	v_tx_385 = J.arg(a, 1)
	if (not J.t(J.gp(J.gp(_s213["this"], "site"), "pano"))):
		return false
	v_rs_386 = [J.mc(J.G.get("OFFMAP"), "roomAt", [J.gp(_s213["n"], "x")]), J.mc(J.G.get("OFFMAP"), "roomAt", [v_tx_385])]
	return J.mc(v_rs_386, "some", [Callable(self, "_f99").bind(_s213)])

func _f102(this_, a: Array, env):
	var v_m_397 = null; var v_p_398 = null
	v_m_397 = J.arg(a, 0)
	var _t679 = J.seq(v_m_397, env["n"])
	var _t680 = (_t679 if _t679 else J.gp(v_m_397, "gone"))
	var _t681 = (_t680 if J.t(_t680) else J.gp(v_m_397, "out"))
	if J.t((_t681 if J.t(_t681) else J.gp(J.gp(v_m_397, "d"), "daoshi"))):
		return []
	v_p_398 = [[J.gp(v_m_397, "x"), J.gp(v_m_397, "y")]]
	var _t682 = J.gp(v_m_397, "step")
	if J.t(((not J.t(J.gp(J.gp(v_m_397, "step"), "arrived"))) if J.t(_t682) else _t682)):
		J.mc(v_p_398, "push", [[J.gp(J.gp(v_m_397, "step"), "x"), J.gp(J.gp(v_m_397, "step"), "y")]])
	var _t683 = J.gp(J.gp(v_m_397, "d"), "post")
	if J.t(((not J.t(J.gp(J.gp(v_m_397, "d"), "guard"))) if J.t(_t683) else _t683)):
		J.mc(v_p_398, "push", [[J.gp(J.gp(J.gp(v_m_397, "d"), "post"), 0.0), J.gp(J.gp(J.gp(v_m_397, "d"), "post"), 1.0)]])
	return v_p_398

func _f103(this_, a: Array, env):
	var v_p_401 = null
	v_p_401 = J.arg(a, 0)
	var _t686 = (absf(J.num(J.sub(J.gp(v_p_401, 0.0), env["xx"]))) < 0.13)
	return ((absf(J.num(J.sub(J.gp(v_p_401, 1.0), env["__p"]["y"]))) < 0.3) if _t686 else _t686)

func _f101(this_, a: Array, env):
	var v_x_392 = null; var v_taken_394 = null; var v_occ_395 = null; var v_best_396 = null; var v_dx_399 = null
	var _s216 = {"__p": env, "n": null, "y": null}
	_s216["n"] = J.arg(a, 0)
	v_x_392 = J.arg(a, 1)
	_s216["y"] = J.arg(a, 2)
	v_taken_394 = Callable(self, "_f102").bind(_s216)
	var _t684 = J.gp(this_, "npcs")
	v_occ_395 = J.mc(_t684, "flatMap", [v_taken_394])
	v_best_396 = [v_x_392, _s216["y"]]
	for _t685 in J.iter([0.0, 0.14, (-0.14)]):
		v_dx_399 = _t685
		var _s219 = {"__p": _s216, "xx": null}
		_s219["xx"] = J.add(v_x_392, v_dx_399)
		if (not J.t(J.mc(v_occ_395, "some", [Callable(self, "_f103").bind(_s219)]))):
			var _t687 = [_s219["xx"], _s219["__p"]["y"]]
			v_best_396 = _t687
			break
	return v_best_396

func _f105(this_, a: Array, env):
	var v_m_409 = null
	v_m_409 = J.arg(a, 0)
	var _t689 = J.seq(J.gp(J.gp(v_m_409, "d"), "k"), "it")
	var _t690 = (_t689 if _t689 else J.seq(J.gp(J.gp(v_m_409, "d"), "k"), "mis"))
	var _t691 = ((not J.t(J.gp(v_m_409, "gone"))) if _t690 else _t690)
	var _t692 = ((not J.t(J.gp(v_m_409, "out"))) if _t691 else _t691)
	var _t693 = ((not J.t(J.gp(v_m_409, "fleeing"))) if _t692 else _t692)
	var _t694 = ((not J.t(J.gp(v_m_409, "leaving"))) if _t693 else _t693)
	var _t696 = ((not J.t(J.gp(v_m_409, "call"))) if _t694 else _t694)
	if J.t(_t696):
		var _t695 = J.gp(v_m_409, "step")
		_t696 = (not J.t((J.gp(J.gp(v_m_409, "step"), "called") if J.t(_t695) else _t695)))
	return (J.cmp(J.gp(v_m_409, "fear"), 50.0, "<") if _t696 else _t696)

func _f106(this_, a: Array, env):
	return J.sub(J.mc(env["this"], "rng", [env["b"]]), 0.5)

func _f107(this_, a: Array, env):
	var v_m_411 = null
	v_m_411 = J.arg(a, 0)
	return J.gp(J.gp(v_m_411, "d"), "name")

func _f108(this_, a: Array, env):
	var v_c_412 = null; var v_i_413 = null
	v_c_412 = J.arg(a, 0)
	v_i_413 = J.arg(a, 1)
	var _t713 = {"x": J.gp(J.gp([J.gp(J.G.get("_SP"), "seat1"), J.gp(J.G.get("_SP"), "seat2"), J.gp(J.G.get("_SP"), "seat3")], J.mod(v_i_413, 3.0)), 0.0), "y": J.gp(J.gp([J.gp(J.G.get("_SP"), "seat1"), J.gp(J.G.get("_SP"), "seat2"), J.gp(J.G.get("_SP"), "seat3")], J.mod(v_i_413, 3.0)), 1.0), "wait": 60.0, "act": "notes", "delay": (1.5 + J.mul(v_i_413, 3.5)), "go": (null if J.t(v_i_413) else "又開會……")}
	J.sp(v_c_412, "call", _t713)

func _f104(this_, a: Array, env):
	var v_kind_405 = null; var v_cand_406 = null; var v_k_407 = null; var v_who_408 = null; var v_c_410 = null
	var _s222 = {"__p": env, "this": null, "b": null}
	_s222["this"] = this_
	_s222["b"] = J.arg(a, 0)
	v_kind_405 = J.arg(a, 1)
	var _t688 = J.gp(_s222["this"], "npcs")
	v_cand_406 = J.mc(_t688, "filter", [Callable(self, "_f105").bind(_s222)])
	if (not J.t(J.len(v_cand_406))):
		return false
	if J.seq(v_kind_405, "callin"):
		v_c_410 = J.gp(v_cand_406, floor(J.num(J.mul(J.mc(_s222["this"], "rng", [_s222["b"]]), J.len(v_cand_406)))))
		J.mc(_s222["this"], "bubble", [_s222["b"], (J.str(J.gp(J.gp(v_c_410, "d"), "name")) + "，入嚟我房！"), 2.6])
		var _t697 = _s222["b"]
		J.sp(_t697, "next", null)
		var _t698 = _s222["b"]
		var _t699 = {"x": J.gp(J.gp(J.gp(_s222["b"], "d"), "post"), 0.0), "y": J.gp(J.gp(J.gp(_s222["b"], "d"), "post"), 1.0), "wait": 24.0, "act": "read", "arrived": (J.hypot_([J.sub(J.gp(_s222["b"], "x"), J.gp(J.gp(J.gp(_s222["b"], "d"), "post"), 0.0)), J.sub(J.gp(_s222["b"], "y"), J.gp(J.gp(J.gp(_s222["b"], "d"), "post"), 1.0))]) < 0.012), "path": null, "pi": 0.0, "say": "（睇報告）企喺度等我睇完先。", "called": true}
		J.sp(_t698, "step", _t699)
		if J.t(J.gp(J.gp(_s222["b"], "step"), "arrived")):
			var _t700 = _s222["b"]
			J.sp(_t700, "wait", 24.0)
			J.mc(_s222["this"], "bubble", [_s222["b"], J.gp(J.gp(_s222["b"], "step"), "say"), 2.4])
		var _t701 = {"x": J.gp(J.gp(J.G.get("_SP"), "bossFront"), 0.0), "y": J.gp(J.gp(J.G.get("_SP"), "bossFront"), 1.0), "wait": 14.0, "act": "idle", "delay": 1.2, "go": ("嚟緊喇陳總～" if J.seq(J.gp(J.gp(v_c_410, "d"), "k"), "mis") else "……係。"), "say": ("陳總～搵我呀？" if J.seq(J.gp(J.gp(v_c_410, "d"), "k"), "mis") else "陳總，搵我？"), "boss": _s222["b"]}
		J.sp(v_c_410, "call", _t701)
		var _t702 = _s222["this"]
		var _t703 = J.gp(_s222["this"], "t")
		J.sp(_t702, "callT", _t703)
		var _t704 = _s222["this"]
		J.sp(_t704, "callWho", v_c_410)
		return true
	var _t705 = (J.len(v_cand_406) > 1.0)
	v_k_407 = (2.0 if (J.cmp(J.mc(_s222["this"], "rng", [_s222["b"]]), 0.6, "<") if _t705 else _t705) else 1.0)
	var _t706 = J.mc(v_cand_406, "sort", [Callable(self, "_f106").bind(_s222)])
	v_who_408 = J.mc(_t706, "slice", [0.0, v_k_407])
	var _t709 = _s222["b"]
	var _t708 = null
	if (J.len(v_who_408) > 1.0):
		var _t707 = J.mc(v_who_408, "map", [Callable(self, "_f107").bind(_s222)])
		_t708 = (J.str(J.mc(_t707, "join", ["、"])) + "，入會議室開會！")
	else:
		_t708 = (J.str(J.gp(J.gp(J.gp(v_who_408, 0.0), "d"), "name")) + "，入會議室！")
	J.mc(_s222["this"], "bubble", [_t709, _t708, 2.8])
	var _t710 = _s222["b"]
	J.sp(_t710, "next", null)
	var _t711 = _s222["b"]
	var _t712 = {"x": J.gp(J.gp(J.G.get("_SP"), "board"), 0.0), "y": J.gp(J.gp(J.G.get("_SP"), "board"), 1.0), "wait": 22.0, "act": "present", "arrived": false, "path": null, "pi": 0.0, "say": "（指住白板）呢季嘅數……", "called": true, "meet": true}
	J.sp(_t711, "step", _t712)
	J.mc(v_who_408, "forEach", [Callable(self, "_f108").bind(_s222)])
	var _t714 = _s222["this"]
	var _t715 = J.gp(_s222["this"], "t")
	J.sp(_t714, "meetT", _t715)
	return true

func _f109(this_, a: Array, env):
	var v_n_416 = null
	v_n_416 = J.arg(a, 0)
	var _t717 = J.seq(v_n_416, J.gp(this_, "sel"))
	if not J.t(_t717):
		var _t716 = J.cmp(J.gp(v_n_416, "mocked"), 0.0, ">")
		_t717 = ((not J.t(J.gp(J.gp(v_n_416, "d"), "guard"))) if _t716 else _t716)
	return (16.0 if _t717 else 0.0)

func _f110(this_, a: Array, env):
	var v_ctx_419 = null; var v_n_420 = null; var v_x_421 = null; var v_by_422 = null; var v_t_423 = null; var v_k_424 = null; var v_cx_425 = null; var v_cy_426 = null; var v_r_427 = null
	v_ctx_419 = J.arg(a, 0)
	v_n_420 = J.arg(a, 1)
	v_x_421 = J.arg(a, 2)
	v_by_422 = J.arg(a, 3)
	v_t_423 = J.arg(a, 4)
	v_k_424 = J.max_([0.0, J.min_([1.0, (1.0 - J.div(J.gp(v_n_420, "wait"), 3.5))])])
	v_cx_425 = J.add(v_x_421, 46.0)
	v_cy_426 = J.add(v_by_422, 1.0)
	v_r_427 = 9.0
	J.mc(v_ctx_419, "save", [])
	J.sp(v_ctx_419, "fillStyle", "rgba(0,0,0,.55)")
	J.mc(v_ctx_419, "beginPath", [])
	J.mc(v_ctx_419, "arc", [v_cx_425, v_cy_426, J.add(v_r_427, 3.0), 0.0, (PI * 2.0)])
	J.mc(v_ctx_419, "fill", [])
	J.sp(v_ctx_419, "strokeStyle", "#ffb34a")
	J.sp(v_ctx_419, "lineWidth", 3.0)
	J.mc(v_ctx_419, "beginPath", [])
	J.mc(v_ctx_419, "arc", [v_cx_425, v_cy_426, v_r_427, J.div((-PI), 2.0), (J.div((-PI), 2.0) + (J.mul(v_k_424, PI) * 2.0))])
	J.mc(v_ctx_419, "stroke", [])
	J.sp(v_ctx_419, "font", "900 11px sans-serif")
	J.sp(v_ctx_419, "textAlign", "center")
	J.sp(v_ctx_419, "textBaseline", "middle")
	J.sp(v_ctx_419, "fillStyle", "#ffe2b0")
	J.mc(v_ctx_419, "fillText", ["走", v_cx_425, J.add(v_cy_426, 0.5)])
	J.mc(v_ctx_419, "restore", [])

func _f111(this_, a: Array, env):
	var v_g_430 = null; var v_x_431 = null; var v_y_432 = null; var v_dx_433 = null; var v_dy_434 = null; var v_d_435 = null
	v_g_430 = J.arg(a, 0)
	v_x_431 = J.arg(a, 1)
	v_y_432 = J.arg(a, 2)
	if J.seq(J.gp(v_g_430, "act"), "doze"):
		return false
	var _t718 = J.gp(J.gp(this_, "site"), "pano")
	if J.t(((not J.seq(J.mc(J.G.get("OFFMAP"), "roomAt", [J.gp(v_g_430, "x")]), J.mc(J.G.get("OFFMAP"), "roomAt", [v_x_431]))) if J.t(_t718) else _t718)):
		return false
	v_dx_433 = J.sub(v_x_431, J.gp(v_g_430, "x"))
	v_dy_434 = J.sub(v_y_432, J.sub(J.gp(v_g_430, "y"), 0.08))
	if (not J.seq(signf(J.num(v_dx_433)), J.gp(v_g_430, "dir"))):
		return false
	v_d_435 = absf(J.num(v_dx_433))
	var _t719 = J.cmp(v_d_435, 0.4, "<")
	return ((absf(J.num(v_dy_434)) < (0.06 + J.mul(v_d_435, 0.35))) if _t719 else _t719)

func _f112(this_, a: Array, env):
	if (not J.t(J.gp(J.gp(this_, "site"), "pano"))):
		return null
	if J.t(J.gp(this_, "headless")):
		return (J.mc(this_, "roomOf", [J.gp(this_, "sel")]) if J.t(J.gp(this_, "sel")) else "main")
	return J.gp(J.mc(this_, "camRoom", []), "k")

func _f113(this_, a: Array, env):
	var v_m_440 = null; var v_room_441 = null
	v_m_440 = J.arg(a, 0)
	v_room_441 = J.arg(a, 1)
	var _t720 = (not J.t(v_room_441))
	return (_t720 if _t720 else J.seq(J.mc(this_, "roomOf", [v_m_440]), v_room_441))

func _f115(this_, a: Array, env):
	var v_m_448 = null
	v_m_448 = J.arg(a, 0)
	var _t723 = (not J.t(J.gp(v_m_448, "gone")))
	var _t724 = ((not J.t(J.gp(v_m_448, "out"))) if _t723 else _t723)
	var _t725 = ((not J.t(J.gp(v_m_448, "fleeing"))) if _t724 else _t724)
	var _t726 = ((not J.t(J.gp(J.gp(v_m_448, "d"), "guard"))) if _t725 else _t725)
	return (J.mc(env["__p"]["this"], "inGroup", [v_m_448, env["rm"]]) if _t726 else _t726)

func _f114(this_, a: Array, env):
	var v_k_444 = null; var v_n_445 = null; var v_p_446 = null
	var _s234 = {"__p": env, "this": null}
	_s234["this"] = this_
	v_k_444 = J.arg(a, 0)
	v_n_445 = J.arg(a, 1)
	v_p_446 = J.gp(J.G.get("SCARE_PROPS"), v_k_444)
	if J.t(J.gp(v_p_446, "group")):
		var _s235 = {"__p": _s234, "rm": null}
		_s235["rm"] = J.mc(_s235["__p"]["this"], "groupRoom", [])
		var _t721 = J.gp(_s235["__p"]["this"], "pcd")
		var _t727 = (not J.cmp(J.gp((_t721 if J.t(_t721) else {}), v_k_444), 0.0, ">"))
		if J.t(_t727):
			var _t722 = J.gp(_s235["__p"]["this"], "npcs")
			_t727 = J.mc(_t722, "some", [Callable(self, "_f115").bind(_s235)])
		return _t727
	var _t728 = ((not J.t(J.gp(v_n_445, "gone"))) if J.t(v_n_445) else v_n_445)
	var _t729 = ((not J.t(J.gp(v_n_445, "out"))) if J.t(_t728) else _t728)
	var _t730 = ((not J.t(J.gp(v_n_445, "fleeing"))) if J.t(_t729) else _t729)
	var _t732 = ((not J.t(J.gp(J.gp(v_n_445, "d"), "guard"))) if J.t(_t730) else _t730)
	if J.t(_t732):
		var _t731 = J.seq(J.gp(v_p_446, "r"), 0.0)
		_t732 = (_t731 if _t731 else J.cmp(J.hypot_([J.sub(J.gp(v_n_445, "x"), J.gp(J.gp(v_p_446, "front"), 0.0)), (J.sub(J.gp(v_n_445, "y"), J.gp(J.gp(v_p_446, "front"), 1.0)) * 1.4)]), J.gp(v_p_446, "r"), "<"))
	return (not (not J.t(_t732)))

func _f117(this_, a: Array, env):
	var v_m_462 = null
	v_m_462 = J.arg(a, 0)
	var _t737 = (not J.t(J.gp(v_m_462, "gone")))
	var _t738 = ((not J.t(J.gp(v_m_462, "out"))) if _t737 else _t737)
	var _t739 = ((not J.t(J.gp(v_m_462, "fleeing"))) if _t738 else _t738)
	var _t740 = ((not J.t(J.gp(J.gp(v_m_462, "d"), "guard"))) if _t739 else _t739)
	return (J.mc(env["__p"]["this"], "inGroup", [v_m_462, env["rm"]]) if _t740 else _t740)

func _f118(this_, a: Array, env):
	var v_m_463 = null
	v_m_463 = J.arg(a, 0)
	var _t748 = (not J.t(J.gp(v_m_463, "gone")))
	var _t749 = ((not J.t(J.gp(v_m_463, "out"))) if _t748 else _t748)
	var _t750 = ((not J.t(J.gp(v_m_463, "fleeing"))) if _t749 else _t749)
	return (J.mc(env["__p"]["this"], "inGroup", [v_m_463, env["rm"]]) if _t750 else _t750)

func _f116(this_, a: Array, env):
	var v_k_451 = null; var v_who_452 = null; var v_p_453 = null; var v_n_454 = null; var v_cx_455 = null; var v_cy_456 = null; var v_RR_458 = null; var v_cx_459 = null; var v_cy_460 = null; var v_tg_461 = null; var v_m_464 = null
	var _s237 = {"__p": env, "this": null}
	_s237["this"] = this_
	v_k_451 = J.arg(a, 0)
	v_who_452 = J.arg(a, 1)
	v_p_453 = J.gp(J.G.get("SCARE_PROPS"), v_k_451)
	v_n_454 = (v_who_452 if J.t(v_who_452) else J.gp(_s237["this"], "sel"))
	var _t733 = _s237["this"]
	var _t734 = J.gp(_s237["this"], "pcd")
	var _t735 = (_t734 if J.t(_t734) else {})
	J.sp(_t733, "pcd", _t735)
	if J.t(J.gp(v_p_453, "group")):
		var _s238 = {"__p": _s237, "rm": null}
		if J.cmp(J.gp(J.gp(_s238["__p"]["this"], "pcd"), v_k_451), 0.0, ">"):
			J.mc(_s238["__p"]["this"], "toast", [(J.str(J.gp(v_p_453, "name")) + "冷卻中")])
			return null
		if J.cmp(J.gp(_s238["__p"]["this"], "mana"), J.gp(v_p_453, "cost"), "<"):
			J.mc(_s238["__p"]["this"], "toast", ["陰氣不夠，等一下"])
			return null
		_s238["rm"] = J.mc(_s238["__p"]["this"], "groupRoom", [])
		v_RR_458 = (J.gp(J.gp(J.G.get("OFFMAP"), "RM"), _s238["rm"]) if J.t(_s238["rm"]) else _s238["rm"])
		var _t736 = J.gp(_s238["__p"]["this"], "npcs")
		if (not J.t(J.mc(_t736, "some", [Callable(self, "_f117").bind(_s238)]))):
			J.mc(_s238["__p"]["this"], "toast", [(J.str((J.gp(v_RR_458, "name") if J.t(v_RR_458) else "呢度")) + "冇人")])
			return null
		if J.t(v_RR_458):
			var _t741 = [J.sub(J.mc(J.G.get("OFFMAP"), "npx", [J.gp(J.gp(v_RR_458, "vent"), 0.0)]), 0.06), J.mc(J.G.get("OFFMAP"), "py", [J.gp(J.gp(v_RR_458, "vent"), 1.0)]), 0.12, 0.02]
			J.sp(v_p_453, "rect", _t741)
		var _t742 = _s238["__p"]["this"]
		var _t743 = J.sub(J.gp(_t742, "mana"), J.gp(v_p_453, "cost"))
		J.sp(_t742, "mana", _t743)
		var _t744 = J.gp(_s238["__p"]["this"], "pcd")
		var _t745 = J.gp(v_p_453, "cdT")
		J.sp(_t744, v_k_451, _t745)
		v_cx_459 = J.add(J.gp(J.gp(v_p_453, "rect"), 0.0), J.div(J.gp(J.gp(v_p_453, "rect"), 2.0), 2.0))
		v_cy_460 = J.add(J.gp(J.gp(v_p_453, "rect"), 1.0), J.gp(J.gp(v_p_453, "rect"), 3.0))
		var _t746 = J.gp(_s238["__p"]["this"], "fx")
		J.mc(_t746, "push", [{"kind": v_k_451, "life": 2.2, "x": v_cx_459, "y": v_cy_460, "room": _s238["rm"]}])
		if (not J.t(J.gp(_s238["__p"]["this"], "headless"))):
			J.mc(J.G.get("Sound"), "play", [("click" if J.seq(v_k_451, "lights") else "whoosh")])
			J.mc(_s238["__p"]["this"], "propParts", [v_k_451, v_p_453])
			if J.t(J.gp(J.gp(_s238["__p"]["this"], "site"), "pano")):
				J.mc(J.G.get("OFFMAP"), "onProp", [v_k_451, null, _s238["rm"]])
			else:
				if J.t(J.mc(_s238["__p"]["this"], "office", [])):
					J.mc(J.G.get("OFFICE"), "onProp", [v_k_451])
			J.mc(_s238["__p"]["this"], "float", [0.5, 0.36, ((J.add(J.gp(v_RR_458, "name"), "入面") if J.t(v_RR_458) else "全場") + "一齊經歷：冇人會話邊個黐線　之後單嚇 ×" + J.str(J.gp(J.G.get("FEAR"), "uneasyMul"))), "#bcd4ff", 2.2])
		var _t747 = J.gp(_s238["__p"]["this"], "npcs")
		v_tg_461 = J.mc(_t747, "filter", [Callable(self, "_f118").bind(_s238)])
		var _t751 = _s238["__p"]["this"]
		J.sp(_t751, "_src", v_cx_459)
		var _t752 = _s238["__p"]["this"]
		J.sp(_t752, "_dl", 0.0)
		var _t753 = _s238["__p"]["this"]
		J.sp(_t753, "_group", true)
		for _t754 in J.iter(v_tg_461):
			v_m_464 = _t754
			J.mc(_s238["__p"]["this"], "hit", [v_m_464, J.gp(v_p_453, "type"), J.gp(v_p_453, "base"), J.gp(v_p_453, "tier")])
		var _t755 = _s238["__p"]["this"]
		J.sp(_t755, "_group", false)
		var _t756 = _s238["__p"]["this"]
		J.sp(_t756, "_src", null)
		J.mc(_s238["__p"]["this"], "expose", [J.gp(J.G.get("EXPO"), "group")])
		return null
	var _t757 = (not J.t(v_n_454))
	var _t758 = (_t757 if _t757 else J.gp(v_n_454, "gone"))
	var _t759 = (_t758 if J.t(_t758) else J.gp(v_n_454, "out"))
	var _t760 = (_t759 if J.t(_t759) else J.gp(v_n_454, "fleeing"))
	if J.t((_t760 if J.t(_t760) else J.gp(J.gp(v_n_454, "d"), "guard"))):
		J.mc(_s237["this"], "toast", ["先點一個人"])
		return null
	if (not J.t(J.mc(_s237["this"], "propOK", [v_k_451, v_n_454]))):
		J.mc(_s237["this"], "toast", [(J.str(J.gp(J.gp(v_n_454, "d"), "name")) + "離" + J.str(J.gp(v_p_453, "name")) + "太遠")])
		return null
	if J.cmp(J.gp(_s237["this"], "mana"), J.gp(v_p_453, "cost"), "<"):
		J.mc(_s237["this"], "toast", ["陰氣不夠，等一下"])
		return null
	var _t761 = _s237["this"]
	var _t762 = J.sub(J.gp(_t761, "mana"), J.gp(v_p_453, "cost"))
	J.sp(_t761, "mana", _t762)
	v_cx_455 = (J.add(J.gp(J.gp(v_p_453, "rect"), 0.0), J.div(J.gp(J.gp(v_p_453, "rect"), 2.0), 2.0)) if J.t(J.gp(v_p_453, "r")) else J.gp(v_n_454, "x"))
	v_cy_456 = (J.add(J.gp(J.gp(v_p_453, "rect"), 1.0), J.gp(J.gp(v_p_453, "rect"), 3.0)) if J.t(J.gp(v_p_453, "r")) else J.sub(J.gp(v_n_454, "y"), 0.2))
	var _t763 = J.gp(_s237["this"], "fx")
	J.mc(_t763, "push", [{"kind": v_k_451, "life": 2.2, "x": v_cx_455, "y": v_cy_456, "n": v_n_454}])
	if (not J.t(J.gp(_s237["this"], "headless"))):
		var _t764 = J.seq(v_k_451, "printer")
		var _t769 = null
		if (_t764 if _t764 else J.seq(v_k_451, "vend")):
			_t769 = "paper"
		else:
			var _t765 = J.seq(v_k_451, "lamp")
			var _t766 = (_t765 if _t765 else J.seq(v_k_451, "drop"))
			var _t768 = null
			if (_t766 if _t766 else J.seq(v_k_451, "trophy")):
				_t768 = "hit"
			else:
				var _t767 = J.seq(v_k_451, "water")
				_t768 = ("crow" if (_t767 if _t767 else J.seq(v_k_451, "kettle")) else "whoosh")
			_t769 = _t768
		J.mc(J.G.get("Sound"), "play", [_t769])
		J.mc(_s237["this"], "propParts", [v_k_451, v_p_453, v_n_454])
		if J.t(J.mc(_s237["this"], "office", [])):
			var _t770 = J.gp(v_p_453, "room")
			var _t771 = ((not J.seq(J.gp(v_p_453, "room"), "main")) if J.t(_t770) else _t770)
			if J.t(((not J.seq(v_k_451, "printer")) if J.t(_t771) else _t771)):
				J.mc(J.G.get("OFFMAP"), "onProp", [v_k_451, v_n_454])
			else:
				J.mc(J.G.get("OFFICE"), "onProp", [v_k_451])
	var _t772 = _s237["this"]
	J.sp(_t772, "_src", v_cx_455)
	var _t773 = _s237["this"]
	J.sp(_t773, "_dl", 0.0)
	var _t774 = _s237["this"]
	var _t775 = (not (not J.t(J.gp(v_p_453, "vis"))))
	J.sp(_t774, "_vis", _t775)
	J.mc(_s237["this"], "hit", [v_n_454, J.gp(v_p_453, "type"), J.gp(v_p_453, "base"), J.gp(v_p_453, "tier")])
	var _t776 = _s237["this"]
	J.sp(_t776, "_src", null)
	var _t777 = _s237["this"]
	J.sp(_t777, "_vis", false)

func _f119(this_, a: Array, env):
	var v_n_467 = null; var v_cost_468 = null
	v_n_467 = J.arg(a, 0)
	v_cost_468 = 22.0
	var _t778 = (not J.t(v_n_467))
	var _t779 = (_t778 if _t778 else J.gp(v_n_467, "gone"))
	if J.t((_t779 if J.t(_t779) else (not J.t(J.gp(J.gp(v_n_467, "d"), "phone"))))):
		return null
	if J.t(J.gp(v_n_467, "out")):
		J.mc(this_, "toast", [(J.str(J.gp(J.gp(v_n_467, "d"), "name")) + "不在")])
		return null
	if J.cmp(J.gp(this_, "mana"), v_cost_468, "<"):
		J.mc(this_, "toast", ["陰氣不夠，等一下"])
		return null
	var _t780 = this_
	var _t781 = J.sub(J.gp(_t780, "mana"), v_cost_468)
	J.sp(_t780, "mana", _t781)
	var _t782 = J.gp(this_, "fx")
	J.mc(_t782, "push", [{"kind": "phone", "life": 1.6, "n": v_n_467}])
	if (not J.t(J.gp(this_, "headless"))):
		J.mc(J.G.get("Sound"), "play", ["click"])
	var _t783 = this_
	J.sp(_t783, "_src", null)
	var _t784 = this_
	J.sp(_t784, "_dl", 0.0)
	var _t785 = this_
	J.sp(_t785, "_vis", false)
	J.mc(this_, "hit", [v_n_467, "phone", 22.0, 1.0, null, true])

func _f120(this_, a: Array, env):
	var v_n_471 = null; var v_cost_472 = null
	v_n_471 = J.arg(a, 0)
	v_cost_472 = 20.0
	var _t786 = (not J.t(v_n_471))
	var _t787 = (_t786 if _t786 else J.gp(v_n_471, "gone"))
	if J.t((_t787 if J.t(_t787) else J.gp(v_n_471, "fleeing"))):
		return null
	if J.t(J.gp(v_n_471, "out")):
		J.mc(this_, "toast", [(J.str(J.gp(J.gp(v_n_471, "d"), "name")) + "不在")])
		return null
	if J.cmp(J.gp(this_, "mana"), v_cost_472, "<"):
		J.mc(this_, "toast", ["陰氣不夠，等一下"])
		return null
	var _t788 = this_
	var _t789 = J.sub(J.gp(_t788, "mana"), v_cost_472)
	J.sp(_t788, "mana", _t789)
	var _t790 = J.gp(this_, "fx")
	J.mc(_t790, "push", [{"kind": "breath", "life": 2.4, "max": 2.4, "n": v_n_471}])
	if (not J.t(J.gp(this_, "headless"))):
		J.mc(J.G.get("Sound"), "play", ["whoosh"])
	var _t791 = this_
	J.sp(_t791, "_src", null)
	var _t792 = this_
	J.sp(_t792, "_dl", 0.0)
	var _t793 = this_
	J.sp(_t793, "_vis", false)
	var _t794 = J.gp(J.gp(v_n_471, "d"), "weak")
	J.mc(this_, "hit", [v_n_471, ("breath" if J.t(J.mc(_t794, "includes", ["breath"])) else "cold"), 24.0, 1.0, null, true])
	var _t795 = (not J.t(J.gp(this_, "headless")))
	var _t796 = (J.gp(v_n_471, "rx") if _t795 else _t795)
	var _t797 = ((not J.seq(J.gp(J.gp(v_n_471, "rx"), "k"), "burst")) if J.t(_t796) else _t796)
	if J.t(((not J.t(J.gp(v_n_471, "fleeing"))) if J.t(_t797) else _t797)):
		J.mc(this_, "react", [v_n_471, "chill", {"dur": 2.4}])
	var _t798 = (not J.t(J.gp(this_, "headless")))
	var _t799 = (J.gp(v_n_471, "rx") if _t798 else _t798)
	if J.t((J.seq(J.gp(J.gp(v_n_471, "rx"), "k"), "chill") if J.t(_t799) else _t799)):
		J.sp(v_n_471, "hair", 1.2)
		J.sp(v_n_471, "goose", 2.0)

func _f122(this_, a: Array, env):
	var _t812 = J.gp(env["this"], "active")
	return (J.mc(J.G.get("OFFICE"), "onScare", [env["gx"], env["gy"], (0.75 if J.t(J.gp(env["g"], "aoe")) else 1.0)]) if J.t(_t812) else _t812)

func _f123(this_, a: Array, env):
	var v_m_483 = null
	v_m_483 = J.arg(a, 0)
	var _t814 = (not J.t(J.gp(v_m_483, "gone")))
	var _t815 = ((not J.t(J.gp(v_m_483, "out"))) if _t814 else _t814)
	return ((not J.t(J.gp(v_m_483, "fleeing"))) if _t815 else _t815)

func _f121(this_, a: Array, env):
	var v_k_475 = null; var v_n_476 = null; var v_cost_478 = null; var v_gq_479 = null; var v_tg_482 = null; var v_m_484 = null
	var _s258 = {"__p": env, "this": null, "g": null, "gx": null, "gy": null}
	_s258["this"] = this_
	v_k_475 = J.arg(a, 0)
	v_n_476 = J.arg(a, 1)
	_s258["g"] = J.gp(J.G.get("SCARE_GHOSTS"), v_k_475)
	var _t800 = (not J.t(_s258["g"]))
	if (_t800 if _t800 else J.cmp(J.gp(J.gp(_s258["this"], "cd"), v_k_475), 0.0, ">")):
		return null
	var _t801 = J.gp(_s258["g"], "cost")
	v_cost_478 = (_t801 if J.t(_t801) else 35.0)
	if J.cmp(J.gp(_s258["this"], "mana"), v_cost_478, "<"):
		J.mc(_s258["this"], "toast", ["陰氣不夠，等一下"])
		return null
	var _t803 = (not J.t(J.gp(_s258["g"], "aoe")))
	if J.t(_t803):
		var _t802 = (not J.t(v_n_476))
		_t803 = (_t802 if _t802 else J.gp(v_n_476, "gone"))
	if J.t(_t803):
		J.mc(_s258["this"], "toast", ["先點一個人"])
		return null
	var _t804 = (not J.t(J.gp(_s258["g"], "aoe")))
	if J.t((J.gp(v_n_476, "out") if _t804 else _t804)):
		J.mc(_s258["this"], "toast", [(J.str(J.gp(J.gp(v_n_476, "d"), "name")) + "不在")])
		return null
	v_gq_479 = J.mc(_s258["this"], "gpq", [v_k_475])
	var _t805 = _s258["this"]
	var _t806 = J.sub(J.gp(_t805, "mana"), v_cost_478)
	J.sp(_t805, "mana", _t806)
	var _t807 = J.gp(_s258["this"], "cd")
	var _t808 = J.div(J.round(J.num((J.div(22.0, (1.0 + (0.25 * J.sub(v_gq_479, 1.0)))) * 10.0))), 10.0)
	J.sp(_t807, v_k_475, _t808)
	_s258["gx"] = ((J.add(J.gp(_s258["this"], "camX"), J.div(J.mc(_s258["this"], "viewW", []), 2.0)) if J.t(J.gp(J.gp(_s258["this"], "site"), "pano")) else 0.5) if J.t(J.gp(_s258["g"], "aoe")) else J.add(J.gp(v_n_476, "x"), (((-0.13) if J.cmp(J.gp(J.mc(_s258["this"], "pt", [J.gp(v_n_476, "x"), 0.0]), 0.0), J.div(J.gp(_s258["this"], "W"), 2.0), ">") else 0.13) if J.t(J.gp(J.gp(_s258["this"], "site"), "pano")) else ((-0.13) if J.cmp(J.gp(v_n_476, "x"), 0.5, ">") else 0.13))))
	_s258["gy"] = (0.45 if J.t(J.gp(_s258["g"], "aoe")) else J.gp(v_n_476, "y"))
	var _t809 = J.gp(_s258["this"], "fx")
	J.mc(_t809, "push", [{"kind": "ghost", "ghost": v_k_475, "life": 2.4, "max": 2.4, "gx": _s258["gx"], "gy": _s258["gy"], "n": v_n_476, "sig": J.gp(_s258["g"], "fx"), "sigText": J.gp(_s258["g"], "fxText"), "col": J.gp(_s258["g"], "col")}])
	if (not J.t(J.gp(_s258["this"], "headless"))):
		J.mc(J.G.get("Sound"), "play", ["skill"])
		var _t810 = _s258["this"]
		J.sp(_t810, "shake", 1.0)
		var _t811 = _s258["this"]
		J.sp(_t811, "vign", 1.0)
		if J.t(J.mc(_s258["this"], "office", [])):
			J.F_setTimeout([Callable(self, "_f122").bind(_s258), ((0.5 if J.t(J.gp(_s258["g"], "aoe")) else 0.9) * 1000.0)])
	var _t816 = null
	if J.t(J.gp(_s258["g"], "aoe")):
		var _t813 = J.gp(_s258["this"], "npcs")
		_t816 = J.mc(_t813, "filter", [Callable(self, "_f123").bind(_s258)])
	else:
		_t816 = [v_n_476]
	v_tg_482 = _t816
	var _t817 = J.gp(_s258["g"], "aoe")
	if J.t(((not J.t(J.gp(_s258["this"], "headless"))) if J.t(_t817) else _t817)):
		J.mc(_s258["this"], "float", [0.5, 0.4, J.gp(_s258["g"], "line"), "#e8c8ff", 2.2])
	var _t818 = _s258["this"]
	var _t819 = _s258["gx"]
	J.sp(_t818, "_src", _t819)
	var _t820 = _s258["this"]
	var _t821 = (0.5 if J.t(J.gp(_s258["g"], "aoe")) else 0.9)
	J.sp(_t820, "_dl", _t821)
	var _t822 = _s258["this"]
	J.sp(_t822, "_ghost", v_k_475)
	var _t823 = _s258["this"]
	J.sp(_t823, "_vis", true)
	var _t824 = _s258["this"]
	var _t825 = (not (not J.t(J.gp(_s258["g"], "aoe"))))
	J.sp(_t824, "_aoe", _t825)
	for _t826 in J.iter(v_tg_482):
		v_m_484 = _t826
		var _t830 = J.mc(_s258["this"], "ghostType", [v_k_475, v_m_484])
		var _t831 = J.round(J.num(J.mul(J.gp(_s258["g"], "base"), (1.0 + (0.35 * J.sub(v_gq_479, 1.0))))))
		var _t829 = null
		if J.t(J.gp(_s258["g"], "aoe")):
			_t829 = null
		else:
			var _t828 = null
			if J.seq(J.typeof_(J.G.get("L")), "function"):
				var _t827 = J.G.get("L")
				_t828 = J.cl(_t827, null, [J.gp(_s258["g"], "line")])
			else:
				_t828 = J.gp(_s258["g"], "line")
			_t829 = _t828
		J.mc(_s258["this"], "hit", [v_m_484, _t830, _t831, 3.0, _t829, (not J.t(J.gp(_s258["g"], "aoe")))])
	var _t832 = _s258["this"]
	J.sp(_t832, "_ghost", null)
	var _t833 = _s258["this"]
	J.sp(_t833, "_src", null)
	var _t834 = _s258["this"]
	J.sp(_t834, "_dl", 0.0)
	var _t835 = _s258["this"]
	J.sp(_t835, "_vis", false)
	var _t836 = _s258["this"]
	J.sp(_t836, "_aoe", false)
	if J.t(J.gp(_s258["g"], "aoe")):
		J.mc(_s258["this"], "wakeGuard", [null])
		J.mc(_s258["this"], "expose", [J.gp(J.G.get("EXPO"), "aoe")])
		if (not J.t(J.gp(_s258["this"], "headless"))):
			J.mc(_s258["this"], "float", [0.5, 0.33, "全場都見到：冇人會話佢哋黐線", "#c9b8ff", 2.2])

func _f125(this_, a: Array, env):
	var v_g_488 = null
	v_g_488 = J.arg(a, 0)
	return J.seq(J.gp(v_g_488, "k"), "afu")

func _f124(this_, a: Array, env):
	var v_k_487 = null; var v_e_489 = null
	v_k_487 = J.arg(a, 0)
	var _t838 = null
	if J.seq(v_k_487, "afu"):
		var _t837 = J.gp(J.G.get("S"), "ghosts")
		_t838 = J.mc(J.G.get("GP"), "grow", [J.mc(_t837, "find", [Callable(self, "_f125").bind(env)])])
	else:
		_t838 = J.mc(J.G.get("GP"), "kindGrow", [v_k_487])
	return _t838

func _f127(this_, a: Array, env):
	var v_t_496 = null
	v_t_496 = J.arg(a, 0)
	var _t841 = J.gp(J.gp(env["n"], "d"), "weak")
	return J.mc(_t841, "includes", [v_t_496])

func _f128(this_, a: Array, env):
	var v_t_497 = null
	v_t_497 = J.arg(a, 0)
	var _t842 = J.gp(J.gp(env["n"], "d"), "immune")
	return (not J.t(J.mc(_t842, "includes", [v_t_497])))

func _f126(this_, a: Array, env):
	var v_k_492 = null; var v_g_494 = null; var v_ts_495 = null
	var _s272 = {"__p": env, "n": null}
	v_k_492 = J.arg(a, 0)
	_s272["n"] = J.arg(a, 1)
	v_g_494 = J.gp(J.G.get("SCARE_GHOSTS"), v_k_492)
	var _t839 = J.gp(v_g_494, "types")
	v_ts_495 = (_t839 if J.t(_t839) else [J.gp(v_g_494, "type")])
	var _t840 = (not J.t(_s272["n"]))
	if (_t840 if _t840 else (J.len(v_ts_495) < 2.0)):
		return J.gp(v_ts_495, 0.0)
	var _t843 = J.mc(v_ts_495, "find", [Callable(self, "_f127").bind(_s272)])
	var _t844 = (_t843 if J.t(_t843) else J.mc(v_ts_495, "find", [Callable(self, "_f128").bind(_s272)]))
	return (_t844 if J.t(_t844) else J.gp(v_ts_495, 0.0))

func _f130(this_, a: Array, env):
	var v_x_532 = null
	v_x_532 = J.arg(a, 0)
	var _t900 = J.gp(J.gp(v_x_532, "d"), "guard")
	var _t901 = ((not J.t(J.gp(v_x_532, "gone"))) if J.t(_t900) else _t900)
	return ((not J.t(J.gp(v_x_532, "out"))) if J.t(_t901) else _t901)

func _f131(this_, a: Array, env):
	var v_x_533 = null
	v_x_533 = J.arg(a, 0)
	return (not J.t(J.gp(J.gp(v_x_533, "d"), "guard")))

func _f132(this_, a: Array, env):
	return J.mc(env["this"], "bubble", [env["n"], env["line"], 2.2])

func _f133(this_, a: Array, env):
	var _t965 = env["this"]
	var _t966 = J.max_([J.gp(env["this"], "shake"), J.min_([0.7, J.div(env["pts"], 60.0)])])
	J.sp(_t965, "shake", _t966)

func _f134(this_, a: Array, env):
	return J.mc(env["this"], "bubble", [env["g"], J.gp(J.gp(J.gp(env["g"], "d"), "say"), "calmOther"), 2.0])

func _f135(this_, a: Array, env):
	var _t985 = env["n"]
	var _t986 = J.gp(env["n"], "scream")
	var _t987 = J.gp(env["n"], "scream")
	var _t988 = J.max_([(_t987 if J.t(_t987) else 0.0), 1.1])
	J.sp(_t985, "scream", _t988)
	var _t989 = env["this"]
	var _t990 = J.max_([J.gp(env["this"], "shake"), 0.5])
	J.sp(_t989, "shake", _t990)

func _f136(this_, a: Array, env):
	var _t995 = env["this"]
	var _t996 = J.max_([J.gp(env["this"], "shake"), 0.9])
	J.sp(_t995, "shake", _t996)

func _f137(this_, a: Array, env):
	var _t1012 = env["n"]
	var _t1011 = J.gp(J.gp(env["d"], "say"), "shout")
	return J.mc(env["this"], "bubble", [_t1012, (_t1011 if J.t(_t1011) else "哇啊啊啊——！"), 2.0])

func _f129(this_, a: Array, env):
	var v_type_501 = null; var v_base_502 = null; var v_tier_503 = null; var v_ghostLine_504 = null; var v_direct_505 = null; var v_grp_507 = null; var v_w_508 = null; var v_im_509 = null; var v_hab_510 = null; var v_sh_511 = null; var v_KS_512 = null; var v_m_513 = null; var v_rational_514 = null; var v_burst_515 = null; var v_before_516 = null; var v_combo_517 = null; var v_aoe_519 = null; var v_wits_520 = null; var v_seen_521 = null; var v_alone_522 = null; var v_mk_523 = null; var v_cap_525 = null; var v_oldPeak_526 = null; var v_gain_527 = null; var v_clean_528 = null; var v_tag_530 = null; var v_L_531 = null; var v_b_534 = null; var v_i_535 = null; var v_say_536 = null; var v_k_537 = null
	var _s275 = {"__p": env, "this": null, "n": null, "d": null, "g": null, "pts": null, "line": null}
	_s275["this"] = this_
	_s275["n"] = J.arg(a, 0)
	v_type_501 = J.arg(a, 1)
	v_base_502 = J.arg(a, 2)
	v_tier_503 = J.arg(a, 3)
	v_ghostLine_504 = J.arg(a, 4)
	v_direct_505 = J.arg(a, 5)
	_s275["d"] = J.gp(_s275["n"], "d")
	v_grp_507 = (not (not J.t(J.gp(_s275["this"], "_group"))))
	if J.t((J.gp(J.G.get("GROUP_IMMUNE"), J.gp(_s275["d"], "k")) if J.t(v_grp_507) else v_grp_507)):
		var _t846 = _s275["n"]
		var _t845 = J.gp(J.gp(J.G.get("GROUP_IMMUNE"), J.gp(_s275["d"], "k")), v_type_501)
		J.mc(_s275["this"], "bubble", [_t846, (_t845 if J.t(_t845) else J.gp(J.gp(J.G.get("GROUP_IMMUNE"), J.gp(_s275["d"], "k")), "light")), 2.4])
		J.mc(_s275["this"], "float", [J.gp(_s275["n"], "x"), J.sub(J.gp(_s275["n"], "y"), 0.2), "慣咗，唔怕", "#9ab"])
		if (not J.t(J.gp(_s275["this"], "headless"))):
			J.mc(_s275["this"], "react", [_s275["n"], ("sip" if J.t(J.gp(_s275["d"], "guard")) else "numb")])
		return null
	if J.t(J.gp(_s275["d"], "guard")):
		J.mc(_s275["this"], "bubble", [_s275["n"], J.gp(J.gp(_s275["d"], "say"), "immune"), 2.0])
		J.mc(_s275["this"], "react", [_s275["n"], "sip"])
		if J.t(((not J.t(J.gp(_s275["this"], "guardKarma"))) if J.t(v_direct_505) else v_direct_505)):
			var _t847 = _s275["this"]
			J.sp(_t847, "guardKarma", true)
			J.mc(_s275["this"], "addKarma", [_s275["d"], (-1.0), "嚇保安阿伯：他倒了一杯茶給你。"])
		return null
	var _t848 = J.gp(_s275["d"], "backfire")
	if J.t((J.gp(J.gp(_s275["d"], "backfire"), v_type_501) if J.t(_t848) else _t848)):
		var _t849 = _s275["this"]
		var _t850 = J.max_([0.0, J.sub(J.gp(_s275["this"], "kpi"), 15.0)])
		J.sp(_t849, "kpi", _t850)
		J.mc(_s275["this"], "bubble", [_s275["n"], J.gp(J.gp(_s275["d"], "backfire"), v_type_501), 2.4])
		J.mc(_s275["this"], "float", [J.gp(_s275["n"], "x"), J.sub(J.gp(_s275["n"], "y"), 0.2), "好評 -15", "#ff8a7a"])
		return null
	var _t851 = J.gp(_s275["d"], "weak")
	v_w_508 = J.mc(_t851, "includes", [v_type_501])
	var _t852 = J.gp(_s275["d"], "immune")
	v_im_509 = J.mc(_t852, "includes", [v_type_501])
	var _t853 = _s275["n"]
	var _t854 = J.gp(_s275["n"], "hab")
	var _t855 = (_t854 if J.t(_t854) else {})
	J.sp(_t853, "hab", _t855)
	var _t856 = J.gp(J.gp(_s275["n"], "hab"), v_type_501)
	v_hab_510 = (_t856 if J.t(_t856) else 0.0)
	var _t857 = J.gp(_s275["n"], "hab")
	var _t858 = J.add(v_hab_510, 1.0)
	J.sp(_t857, v_type_501, _t858)
	var _t859 = J.gp(_s275["n"], "shaken")
	v_sh_511 = J.cmp((_t859 if J.t(_t859) else 0.0), 0.0, ">")
	if J.t(v_im_509):
		var _t860 = _s275["this"]
		var _t861 = J.gp(_s275["this"], "known")
		var _t862 = (_t861 if J.t(_t861) else {})
		J.sp(_t860, "known", _t862)
		var _t863 = J.gp(_s275["this"], "known")
		var _t864 = J.gp(_s275["d"], "k")
		var _t865 = J.gp(J.gp(_s275["this"], "known"), J.gp(_s275["d"], "k"))
		var _t866 = (_t865 if J.t(_t865) else J.new_("Set", []))
		J.sp(_t863, _t864, _t866)
		J.mc(_t866, "add", [v_type_501])
		var _t867 = J.gp(_s275["d"], "imm")
		var _t868 = (J.gp(J.gp(_s275["d"], "imm"), v_type_501) if J.t(_t867) else _t867)
		v_L_531 = (_t868 if J.t(_t868) else J.gp(J.gp(_s275["d"], "say"), "immune"))
		J.mc(_s275["this"], "bubble", [_s275["n"], v_L_531, 2.4])
		var _t870 = J.gp(_s275["n"], "x")
		var _t871 = J.sub(J.gp(_s275["n"], "y"), 0.2)
		var _t869 = J.gp(J.G.get("FEAR_WORD"), v_type_501)
		J.mc(_s275["this"], "float", [_t870, _t871, (J.str((_t869 if J.t(_t869) else v_type_501)) + "？唔怕！"), "#9ab", 1.6])
		if (not J.t(J.gp(_s275["this"], "headless"))):
			var _t873 = _s275["n"]
			var _t872 = J.gp(_s275["this"], "_dl")
			J.mc(_s275["this"], "react", [_t873, "rational", {"delay": (_t872 if J.t(_t872) else 0.0)}])
		var _t874 = J.gp(_s275["this"], "_vis")
		var _t875 = ((not J.t(J.gp(_s275["this"], "_aoe"))) if J.t(_t874) else _t874)
		var _t876 = ((not J.t(v_grp_507)) if J.t(_t875) else _t875)
		if J.t((J.len(J.mc(_s275["this"], "witnesses", [_s275["n"]])) if J.t(_t876) else _t876)):
			J.mc(_s275["this"], "expose", [J.div(J.gp(J.G.get("EXPO"), "seen"), 2.0), _s275["n"]])
		return null
	var _t877 = _s275["this"]
	var _t878 = J.gp(_s275["this"], "known")
	var _t879 = (_t878 if J.t(_t878) else {})
	J.sp(_t877, "known", _t879)
	var _t880 = J.gp(_s275["this"], "known")
	var _t881 = J.gp(_s275["d"], "k")
	var _t882 = J.gp(J.gp(_s275["this"], "known"), J.gp(_s275["d"], "k"))
	var _t883 = (_t882 if J.t(_t882) else J.new_("Set", []))
	J.sp(_t880, _t881, _t883)
	v_KS_512 = _t883
	if (not J.t(J.mc(v_KS_512, "has", [v_type_501]))):
		J.mc(v_KS_512, "add", [v_type_501])
		var _t884 = (not J.t(J.gp(_s275["this"], "headless")))
		var _t885 = (J.seq(_s275["n"], J.gp(_s275["this"], "sel")) if _t884 else _t884)
		if J.t((v_w_508 if _t885 else _t885)):
			J.mc(_s275["this"], "renderTarget", [])
			J.mc(_s275["this"], "float", [J.gp(_s275["n"], "x"), J.sub(J.gp(_s275["n"], "y"), 0.34), ("發現：" + J.str(J.gp(_s275["d"], "name")) + "怕" + J.str(J.gp(J.G.get("FEAR_WORD"), v_type_501)) + "！"), "#ffb070", 1.8])
	var _t889 = J.mul(J.mul(J.mul(((J.gp(J.G.get("FEAR"), "weakSmall") if J.cmp(v_tier_503, 3.0, "<") else 2.0) if J.t(v_w_508) else (J.gp(J.G.get("FEAR_MID"), "small") if J.cmp(v_tier_503, 3.0, "<") else J.gp(J.G.get("FEAR_MID"), "big"))), J.max_([J.gp(J.G.get("FEAR"), "habMin"), pow(J.num(J.gp(J.G.get("FEAR"), "habMul")), J.num(v_hab_510))])), (J.gp(J.G.get("FEAR"), "gain") if J.cmp(v_tier_503, 3.0, "<") else 1.0)), (J.gp(J.G.get("FEAR"), "shakenMul") if J.t(v_sh_511) else 1.0))
	var _t888 = J.gp(J.G.get("FEAR"), "spread")
	var _t886 = J.gp(_s275["this"], "_nt")
	var _t887 = J.gp(_s275["this"], "_nt")
	v_m_513 = J.div(_t889, (1.0 + J.mul(_t888, J.max_([0.0, J.sub((_t887 if J.t(_t887) else 1.0), 1.0)]))))
	v_rational_514 = false
	v_burst_515 = false
	v_before_516 = J.gp(_s275["n"], "fear")
	if J.seq(v_tier_503, 3.0):
		var _t890 = J.cmp(v_before_516, 25.0, "<")
		if ((not J.t(v_sh_511)) if _t890 else _t890):
			var _t891 = J.mul(v_m_513, 0.45)
			v_m_513 = _t891
			v_rational_514 = true
		else:
			if J.cmp(v_before_516, 50.0, "<"):
				var _t892 = J.mul(v_m_513, 1.35)
				v_m_513 = _t892
			else:
				var _t893 = J.mul(v_m_513, J.gp(J.G.get("FEAR"), "burstMul"))
				v_m_513 = _t893
				v_burst_515 = true
	var _t896 = null
	if J.cmp(J.sub(J.gp(_s275["this"], "t"), ((-99.0) if J.leq(J.gp(_s275["n"], "comboT"), null) else J.gp(_s275["n"], "comboT"))), J.gp(J.G.get("FEAR"), "combo"), "<"):
		var _t894 = J.gp(_s275["n"], "combo")
		var _t895 = J.gp(_s275["n"], "combo")
		_t896 = J.min_([4.0, J.add((_t895 if J.t(_t895) else 0.0), 1.0)])
	else:
		_t896 = 0.0
	v_combo_517 = _t896
	var _t897 = (not J.t(v_im_509))
	if ((not J.t(v_rational_514)) if _t897 else _t897):
		var _t898 = J.mul(v_m_513, (1.0 + J.min_([J.gp(J.G.get("FEAR"), "comboMax"), J.mul(v_combo_517, J.gp(J.G.get("FEAR"), "comboStep"))])))
		v_m_513 = _t898
	var _t899 = J.gp(_s275["this"], "npcs")
	_s275["g"] = J.mc(_t899, "find", [Callable(self, "_f130").bind(_s275)])
	v_aoe_519 = (not (not J.t(J.gp(_s275["this"], "_aoe"))))
	v_wits_520 = ([] if J.t((v_aoe_519 if J.t(v_aoe_519) else v_grp_507)) else J.mc(_s275["this"], "witnesses", [_s275["n"]]))
	var _t902 = (not J.t(v_aoe_519))
	var _t903 = ((not J.t(v_grp_507)) if _t902 else _t902)
	var _t904 = (J.gp(_s275["this"], "_vis") if _t903 else _t903)
	v_seen_521 = ((J.len(v_wits_520) > 0.0) if J.t(_t904) else _t904)
	var _t906 = (not J.t(v_aoe_519))
	if J.t(_t906):
		var _t905 = J.mc(_s275["this"], "hearers", [_s275["n"]])
		_t906 = (not J.t(J.mc(_t905, "some", [Callable(self, "_f131").bind(_s275)])))
	v_alone_522 = _t906
	var _t907 = J.gp(_s275["n"], "mocked")
	var _t908 = J.gp(_s275["n"], "mocked")
	v_mk_523 = J.min_([4.0, (_t908 if J.t(_t908) else 0.0)])
	var _t909 = J.mul(v_m_513, (J.mul(J.mul(J.mul((J.gp(J.G.get("FEAR"), "aoeMul") if J.t(v_aoe_519) else 1.0), (J.gp(J.G.get("FEAR"), "groupMul") if J.t(v_grp_507) else (J.gp(J.G.get("FEAR"), "uneasyMul") if J.cmp(J.gp(_s275["n"], "uneasy"), 0.0, ">") else 1.0))), (J.gp(J.G.get("FEAR"), "seenMul") if J.t(v_seen_521) else 1.0)), (J.gp(J.G.get("FEAR"), "alone") if J.t(((not J.t(v_grp_507)) if J.t(v_alone_522) else v_alone_522)) else 1.0)) * (1.0 + (0.0 if J.t(v_grp_507) else J.mul(J.gp(J.G.get("FEAR"), "mockMul"), v_mk_523)))))
	v_m_513 = _t909
	if J.t(v_grp_507):
		var _t910 = _s275["n"]
		var _t911 = J.gp(J.G.get("FEAR"), "uneasy")
		J.sp(_t910, "uneasy", _t911)
	_s275["pts"] = J.round(J.num(J.mul(v_base_502, v_m_513)))
	v_cap_525 = (J.gp(J.G.get("FEAR"), "shakenCap") if J.t(v_sh_511) else (J.gp(J.G.get("FEAR"), "smallCap") if J.t(v_w_508) else J.gp(J.G.get("FEAR"), "plainCap")))
	if J.cmp(v_tier_503, 3.0, "<"):
		var _t912 = J.max_([0.0, J.round(J.num(J.min_([_s275["pts"], J.sub(v_cap_525, v_before_516)])))])
		_s275["pts"] = _t912
	var _t913 = _s275["n"]
	var _t914 = J.add(J.gp(_t913, "fear"), _s275["pts"])
	J.sp(_t913, "fear", _t914)
	var _t915 = _s275["n"]
	var _t916 = (1.0 if J.cmp(_s275["pts"], 0.0, ">") else 0.3)
	J.sp(_t915, "bounce", _t916)
	var _t917 = _s275["n"]
	var _t918 = (1.0 if J.cmp(_s275["pts"], 0.0, ">") else 0.0)
	J.sp(_t917, "barHit", _t918)
	var _t919 = J.cmp(_s275["pts"], 6.0, ">=")
	if ((not J.t(v_rational_514)) if _t919 else _t919):
		var _t920 = _s275["n"]
		J.sp(_t920, "combo", v_combo_517)
		var _t921 = _s275["n"]
		var _t922 = J.gp(_s275["this"], "t")
		J.sp(_t921, "comboT", _t922)
	else:
		var _t923 = _s275["n"]
		J.sp(_t923, "combo", 0.0)
	v_oldPeak_526 = J.min_([100.0, J.gp(_s275["n"], "peak")])
	var _t924 = _s275["n"]
	var _t925 = J.max_([J.gp(_s275["n"], "peak"), J.gp(_s275["n"], "fear")])
	J.sp(_t924, "peak", _t925)
	v_gain_527 = J.round(J.num(J.sub(J.min_([100.0, J.gp(_s275["n"], "peak")]), v_oldPeak_526)))
	var _t926 = (J.cmp(_s275["pts"], 20.0, ">=") if J.t(v_burst_515) else v_burst_515)
	var _t927 = ((not J.t(v_seen_521)) if J.t(_t926) else _t926)
	var _t928 = ((not J.t(v_aoe_519)) if J.t(_t927) else _t927)
	v_clean_528 = ((not J.t(v_grp_507)) if J.t(_t928) else _t928)
	if J.t(v_clean_528):
		var _t929 = J.add(v_gain_527, J.gp(J.G.get("FEAR"), "burstBonus"))
		v_gain_527 = _t929
	if J.t((J.cmp(v_combo_517, 1.0, ">=") if J.t(v_clean_528) else v_clean_528)):
		var _t930 = J.add(v_gain_527, J.mul(J.mul(J.gp(J.G.get("FEAR"), "comboPts"), 2.0), v_combo_517))
		v_gain_527 = _t930
	if J.t((J.cmp(v_mk_523, 2.0, ">=") if J.t(v_clean_528) else v_clean_528)):
		v_b_534 = J.mul(J.gp(J.G.get("FEAR"), "noBelieve"), v_mk_523)
		var _t931 = J.add(v_gain_527, v_b_534)
		v_gain_527 = _t931
		J.mc(_s275["this"], "float", [J.gp(_s275["n"], "x"), J.sub(J.gp(_s275["n"], "y"), 0.34), ("無人信佢！+" + J.str(v_b_534)), "#d08cff", 2.0])
	var _t932 = _s275["this"]
	var _t933 = J.add(J.gp(_t932, "kpi"), v_gain_527)
	J.sp(_t932, "kpi", _t933)
	var _t934 = _s275["this"]
	J.sp(_t934, "_hab", v_hab_510)
	if (not J.seq(J.typeof_(J.G.get("ScareX")), "undefined")):
		var _t937 = _s275["this"]
		var _t938 = _s275["n"]
		var _t936 = _s275["pts"]
		var _t935 = J.gp(_s275["this"], "_ghost")
		J.mc(J.G.get("ScareX"), "onHit", [_t937, _t938, {"type": v_type_501, "pts": _t936, "gain": v_gain_527, "clean": v_clean_528, "mk": v_mk_523, "alone": v_alone_522, "seen": v_seen_521, "burst": v_burst_515, "tier": v_tier_503, "ghost": (_t935 if J.t(_t935) else "afu")}])
	if J.t(((not J.t(J.gp(_s275["this"], "_aoe"))) if J.t(v_rational_514) else v_rational_514)):
		J.mc(_s275["this"], "expose", [J.gp(J.G.get("EXPO"), "blatant"), _s275["n"]])
	var _t939 = J.gp(_s275["d"], "daoshi")
	if J.t((J.cmp(_s275["pts"], 0.0, ">") if J.t(_t939) else _t939)):
		var _t940 = _s275["n"]
		var _t941 = J.gp(_s275["n"], "prog")
		var _t942 = J.gp(_s275["n"], "prog")
		var _t943 = J.max_([0.0, J.sub((_t942 if J.t(_t942) else 0.0), (J.div(_s275["pts"], 100.0) * 0.5))])
		J.sp(_t940, "prog", _t943)
		if (not J.t(J.gp(_s275["this"], "headless"))):
			J.mc(_s275["this"], "float", [J.gp(_s275["n"], "x"), J.sub(J.gp(_s275["n"], "y"), 0.34), "做法被打斷！", "#ffd36a", 1.4])
	if (not J.t(v_grp_507)):
		J.mc(_s275["this"], "perceive", [_s275["n"], _s275["pts"], v_rational_514, v_seen_521, v_wits_520, v_aoe_519, v_alone_522])
	var _t953 = null
	if J.t(v_rational_514):
		var _t944 = J.G.get("pick")
		_t953 = J.cl(_t944, null, [J.gp(J.gp(_s275["d"], "say"), "rational")])
	else:
		var _t947 = v_w_508
		if J.t(_t947):
			var _t945 = J.seq(v_type_501, "phone")
			var _t946 = (_t945 if _t945 else J.seq(v_type_501, "paper"))
			_t947 = (_t946 if _t946 else J.seq(v_tier_503, 3.0))
		var _t952 = null
		if J.t(_t947):
			_t952 = J.gp(J.gp(_s275["d"], "say"), "weak")
		else:
			var _t951 = null
			if J.cmp(J.gp(_s275["n"], "fear"), 50.0, ">="):
				var _t948 = J.G.get("pick")
				_t951 = J.cl(_t948, null, [J.gp(J.gp(_s275["d"], "say"), "hit")])
			else:
				var _t950 = null
				if J.cmp(_s275["pts"], 0.0, ">"):
					var _t949 = J.G.get("pick")
					_t950 = J.cl(_t949, null, [J.gp(J.gp(_s275["d"], "say"), "prime")])
				else:
					_t950 = "（習慣了）"
				_t951 = _t950
			_t952 = _t951
		_t953 = _t952
	_s275["line"] = _t953
	if J.t(((not J.t(v_rational_514)) if J.t(v_ghostLine_504) else v_ghostLine_504)):
		J.mc(_s275["this"], "bubble", [_s275["n"], v_ghostLine_504, 1.2, true])
	if J.t(J.gp(_s275["this"], "headless")):
		J.mc(_s275["this"], "bubble", [_s275["n"], _s275["line"], 2.2])
	else:
		var _t955 = Callable(self, "_f132").bind(_s275)
		var _t954 = J.gp(_s275["this"], "_dl")
		J.F_setTimeout([_t955, J.mul((_t954 if J.t(_t954) else 0.0), 1000.0)])
	var _t961 = null
	if J.t(v_seen_521):
		_t961 = "　穿崩！"
	else:
		var _t956 = (J.cmp(_s275["pts"], 20.0, ">=") if J.t(v_burst_515) else v_burst_515)
		var _t960 = null
		if J.t((v_aoe_519 if J.t(_t956) else _t956)):
			_t960 = "　（全場都見到）"
		else:
			var _t959 = null
			if J.t((J.cmp(_s275["pts"], 20.0, ">=") if J.t(v_burst_515) else v_burst_515)):
				_t959 = "　爆點！"
			else:
				var _t958 = null
				if J.t(v_rational_514):
					_t958 = "　還沒鋪墊"
				else:
					var _t957 = J.cmp(v_tier_503, 3.0, "<")
					_t958 = ("　小動靜不夠，出大招！" if (J.cmp(v_before_516, v_cap_525, ">=") if _t957 else _t957) else ("　有點習慣了" if J.cmp(v_hab_510, 2.0, ">=") else ("　怕！" if J.t(v_w_508) else ("　不怕" if J.t(v_im_509) else ("　餘悸未消" if J.t(v_sh_511) else "")))))
				_t959 = _t958
			_t960 = _t959
		_t961 = _t960
	v_tag_530 = _t961
	J.mc(_s275["this"], "float", [J.gp(_s275["n"], "x"), J.sub(J.gp(_s275["n"], "y"), 0.2), ((J.add("恐懼 +", _s275["pts"]) if J.cmp(_s275["pts"], 0.0, ">") else "沒反應") + J.str(v_tag_530)), ("#ff9a5a" if J.t(v_burst_515) else ("#ffb070" if J.t(v_w_508) else ("#ffe08a" if J.cmp(v_gain_527, 0.0, ">") else "#9ab")))])
	var _t962 = J.cmp(v_combo_517, 1.0, ">=")
	var _t963 = (J.cmp(_s275["pts"], 6.0, ">=") if _t962 else _t962)
	if ((not J.t(v_rational_514)) if _t963 else _t963):
		J.mc(_s275["this"], "float", [J.gp(_s275["n"], "x"), J.sub(J.gp(_s275["n"], "y"), 0.27), ("連擊 ×" + J.str(J.add(v_combo_517, 1.0))), "#ff7ad0", 1.4])
	var _t964 = (not J.t(J.gp(_s275["this"], "headless")))
	if (J.cmp(_s275["pts"], 12.0, ">=") if _t964 else _t964):
		var _t968 = Callable(self, "_f133").bind(_s275)
		var _t967 = J.gp(_s275["this"], "_dl")
		J.F_setTimeout([_t968, J.mul((_t967 if J.t(_t967) else 0.0), 1000.0)])
	var _t969 = (not J.t(J.gp(_s275["this"], "headless")))
	if (J.cmp(J.gp(_s275["n"], "fear"), 25.0, ">=") if _t969 else _t969):
		v_i_535 = 0.0
		while true:
			if not J.cmp(v_i_535, 3.0, "<"): break
			var _t970 = J.gp(_s275["this"], "parts")
			var _t972 = J.add(J.gp(_s275["n"], "x"), ((randf() - 0.5) * 0.05))
			var _t973 = J.sub(J.gp(_s275["n"], "y"), 0.17)
			var _t974 = ((randf() - 0.5) * 0.08)
			var _t975 = (-0.1)
			var _t971 = J.gp(_s275["this"], "_dl")
			J.mc(_t970, "push", [{"kind": "sweat", "x": _t972, "y": _t973, "vx": _t974, "vy": _t975, "g": 0.5, "life": 0.8, "delay": (_t971 if J.t(_t971) else 0.0)}])
			v_i_535 = J.num(v_i_535) + 1.0
	var _t976 = (J.mc(_s275["this"], "sameRoom", [_s275["g"], _s275["n"]]) if J.t(_s275["g"]) else _s275["g"])
	var _t977 = ((J.hypot_([J.sub(J.gp(_s275["g"], "x"), J.gp(_s275["n"], "x")), J.sub(J.gp(_s275["g"], "y"), J.gp(_s275["n"], "y"))]) < 0.24) if J.t(_t976) else _t976)
	if J.t((J.cmp(_s275["pts"], 15.0, ">") if J.t(_t977) else _t977)):
		var _t978 = _s275["n"]
		var _t979 = J.max_([0.0, J.sub(J.gp(_s275["n"], "fear"), J.gp(J.G.get("FEAR"), "guardCalm"))])
		J.sp(_t978, "fear", _t979)
		v_say_536 = Callable(self, "_f134").bind(_s275)
		if J.t(J.gp(_s275["this"], "headless")):
			J.cl(v_say_536, null, [])
		else:
			var _t980 = J.gp(_s275["this"], "_dl")
			J.F_setTimeout([v_say_536, (600.0 + J.mul((_t980 if J.t(_t980) else 0.0), 1000.0))])
			var _t982 = _s275["g"]
			var _t981 = J.gp(_s275["this"], "_dl")
			J.mc(_s275["this"], "react", [_t982, "sip", {"delay": J.add(0.6, (_t981 if J.t(_t981) else 0.0)), "dur": 2.8}])
		J.mc(_s275["this"], "float", [J.gp(_s275["g"], "x"), J.sub(J.gp(_s275["g"], "y"), 0.22), "阿伯在旁邊壯膽", "#9ad"])
	if (not J.t(J.gp(_s275["this"], "headless"))):
		var _t983 = J.cmp(J.gp(_s275["n"], "fear"), 100.0, ">=")
		v_k_537 = ("burst" if J.t((_t983 if _t983 else (J.cmp(_s275["pts"], 20.0, ">=") if J.t(v_burst_515) else v_burst_515))) else ("numb" if J.t((v_im_509 if J.t(v_im_509) else J.cmp(_s275["pts"], 0.0, "<="))) else ("rational" if J.t(v_rational_514) else ("startle" if J.seq(v_tier_503, 3.0) else ("weakjump" if J.t(v_w_508) else ("startle" if J.cmp(J.gp(_s275["n"], "fear"), 50.0, ">=") else "flinch"))))))
		var _t984 = (J.cmp(_s275["pts"], 0.0, ">") if J.t(v_w_508) else v_w_508)
		if J.t(((not J.t(v_rational_514)) if J.t(_t984) else _t984)):
			var _t992 = Callable(self, "_f135").bind(_s275)
			var _t991 = J.gp(_s275["this"], "_dl")
			J.F_setTimeout([_t992, J.mul((_t991 if J.t(_t991) else 0.0), 1000.0)])
		var _t994 = _s275["n"]
		var _t993 = J.gp(_s275["this"], "_dl")
		J.mc(_s275["this"], "react", [_t994, v_k_537, {"delay": (_t993 if J.t(_t993) else 0.0), "src": J.gp(_s275["this"], "_src"), "big": J.seq(v_tier_503, 3.0)}])
		if J.seq(v_k_537, "burst"):
			var _t998 = Callable(self, "_f136").bind(_s275)
			var _t997 = J.gp(_s275["this"], "_dl")
			J.F_setTimeout([_t998, J.mul((_t997 if J.t(_t997) else 0.0), 1000.0)])
	var _t999 = J.cmp(J.gp(_s275["n"], "fear"), 100.0, ">=")
	if ((not J.t(J.gp(_s275["n"], "fleeing"))) if _t999 else _t999):
		var _t1000 = _s275["n"]
		J.sp(_t1000, "fleeing", true)
		var _t1001 = _s275["this"]
		var _t1002 = J.add(J.gp(_t1001, "kpi"), 120.0)
		J.sp(_t1001, "kpi", _t1002)
		J.mc(_s275["this"], "float", [J.gp(_s275["n"], "x"), J.sub(J.gp(_s275["n"], "y"), 0.3), "嚇跑了！+120", "#ff6a5a", 2.0])
		J.mc(_s275["this"], "addKarma", [_s275["d"], J.gp(_s275["d"], "karma"), J.gp(J.gp(_s275["d"], "say"), "flee")])
		if (not J.t(J.gp(_s275["this"], "headless"))):
			J.mc(J.G.get("Sound"), "play", ["heartbeat"])
			var _t1003 = _s275["this"]
			J.sp(_t1003, "shake", 0.6)
			var _t1004 = _s275["n"]
			var _t1005 = J.gp(_s275["this"], "t")
			J.sp(_t1004, "fleeT", _t1005)
			var _t1006 = _s275["n"]
			var _t1007 = J.gp(_s275["this"], "_dl")
			var _t1008 = J.add((_t1007 if J.t(_t1007) else 0.0), 0.4)
			J.sp(_t1006, "fleeHold", _t1008)
			var _t1009 = _s275["n"]
			var _t1010 = [[J.gp(_s275["this"], "t"), J.gp(_s275["n"], "x"), J.gp(_s275["n"], "y")]]
			J.sp(_t1009, "trail", _t1010)
			J.F_setTimeout([Callable(self, "_f137").bind(_s275), 1200.0])

func _f138(this_, a: Array, env):
	var v_n_540 = null
	v_n_540 = J.arg(a, 0)
	return (J.mc(this_, "rng", [v_n_540]) if (not J.leq(J.gp(v_n_540, "_seed"), null)) else randf())

func _f139(this_, a: Array, env):
	var v_m_543 = null; var v_a_544 = null; var v_p_545 = null
	v_m_543 = J.arg(a, 0)
	v_a_544 = J.gp(v_m_543, "act")
	var _t1013 = J.seq(v_a_544, "work")
	var _t1014 = (_t1013 if _t1013 else J.seq(v_a_544, "mop"))
	var _t1015 = (_t1014 if _t1014 else J.seq(v_a_544, "doze"))
	var _t1016 = (_t1015 if _t1015 else J.seq(v_a_544, "pack"))
	var _t1017 = (_t1016 if _t1016 else J.seq(v_a_544, "read"))
	var _t1018 = (_t1017 if _t1017 else J.seq(v_a_544, "notes"))
	if (_t1018 if _t1018 else J.seq(v_a_544, "present")):
		return true
	v_p_545 = J.gp(J.gp(v_m_543, "d"), "post")
	var _t1019 = (J.seq(v_a_544, J.gp(v_p_545, 2.0)) if J.t(v_p_545) else v_p_545)
	return (not (not J.t(((J.hypot_([J.sub(J.gp(v_m_543, "x"), J.gp(v_p_545, 0.0)), J.sub(J.gp(v_m_543, "y"), J.gp(v_p_545, 1.0))]) < 0.015) if J.t(_t1019) else _t1019))))

func _f140(this_, a: Array, env):
	var v_m_548 = null
	v_m_548 = J.arg(a, 0)
	var _t1020 = J.gp(v_m_548, "gone")
	var _t1021 = (_t1020 if J.t(_t1020) else J.gp(v_m_548, "out"))
	if J.t((_t1021 if J.t(_t1021) else J.gp(v_m_548, "fleeing"))):
		return false
	if J.t(J.gp(J.gp(v_m_548, "d"), "guard")):
		return (not J.seq(J.gp(v_m_548, "act"), "doze"))
	if J.t(J.gp(J.gp(v_m_548, "d"), "influencer")):
		return true
	var _t1023 = J.seq(J.gp(v_m_548, "act"), "walk")
	if not J.t(_t1023):
		var _t1022 = J.gp(v_m_548, "lookUp")
		_t1023 = J.cmp((_t1022 if J.t(_t1022) else 0.0), 0.0, ">")
	var _t1024 = (_t1023 if _t1023 else J.cmp(J.gp(v_m_548, "fear"), 25.0, ">="))
	return (_t1024 if _t1024 else (not J.t(J.mc(this_, "headsDown", [v_m_548]))))

func _f141(this_, a: Array, env):
	var v_m_551 = null; var v_n_552 = null; var v_dx_553 = null
	v_m_551 = J.arg(a, 0)
	v_n_552 = J.arg(a, 1)
	var _t1025 = J.seq(v_m_551, v_n_552)
	var _t1026 = (_t1025 if _t1025 else (not J.t(J.mc(this_, "watching", [v_m_551]))))
	if (_t1026 if _t1026 else (not J.t(J.mc(this_, "sameRoom", [v_m_551, v_n_552])))):
		return false
	v_dx_553 = J.sub(J.gp(v_n_552, "x"), J.gp(v_m_551, "x"))
	if J.cmp(J.hypot_([v_dx_553, (J.sub(J.gp(v_n_552, "y"), J.gp(v_m_551, "y")) * 1.3)]), J.G.get("SEE_DIST"), ">"):
		return false
	var _t1027 = J.seq(J.gp(v_m_551, "act"), "walk")
	return ((J.mul(v_dx_553, J.gp(v_m_551, "dir")) >= (-0.03)) if J.t((_t1027 if _t1027 else J.gp(J.gp(v_m_551, "d"), "guard"))) else true)

func _f143(this_, a: Array, env):
	var v_m_557 = null
	v_m_557 = J.arg(a, 0)
	return J.mc(env["this"], "sees", [v_m_557, env["n"]])

func _f142(this_, a: Array, env):
	var _s308 = {"__p": env, "this": null, "n": null}
	_s308["this"] = this_
	_s308["n"] = J.arg(a, 0)
	var _t1028 = J.gp(_s308["this"], "npcs")
	return J.mc(_t1028, "filter", [Callable(self, "_f143").bind(_s308)])

func _f145(this_, a: Array, env):
	var v_m_561 = null
	v_m_561 = J.arg(a, 0)
	var _t1030 = (not J.seq(v_m_561, env["n"]))
	var _t1031 = ((not J.t(J.gp(v_m_561, "gone"))) if _t1030 else _t1030)
	var _t1032 = ((not J.t(J.gp(v_m_561, "out"))) if _t1031 else _t1031)
	var _t1033 = ((not J.t(J.gp(v_m_561, "fleeing"))) if _t1032 else _t1032)
	var _t1034 = (J.mc(env["this"], "sameRoom", [v_m_561, env["n"]]) if _t1033 else _t1033)
	return ((J.hypot_([J.sub(J.gp(v_m_561, "x"), J.gp(env["n"], "x")), J.sub(J.gp(v_m_561, "y"), J.gp(env["n"], "y"))]) < 0.75) if J.t(_t1034) else _t1034)

func _f144(this_, a: Array, env):
	var _s310 = {"__p": env, "this": null, "n": null}
	_s310["this"] = this_
	_s310["n"] = J.arg(a, 0)
	var _t1029 = J.gp(_s310["this"], "npcs")
	return J.mc(_t1029, "filter", [Callable(self, "_f145").bind(_s310)])

func _f147(this_, a: Array, env):
	var v_x_566 = null
	v_x_566 = J.arg(a, 0)
	var _t1036 = J.gp(J.gp(v_x_566, "d"), "guard")
	var _t1037 = ((not J.t(J.gp(v_x_566, "gone"))) if J.t(_t1036) else _t1036)
	return ((not J.t(J.gp(v_x_566, "out"))) if J.t(_t1037) else _t1037)

func _f146(this_, a: Array, env):
	var v_n_564 = null; var v_g_565 = null
	v_n_564 = J.arg(a, 0)
	var _t1035 = J.gp(this_, "npcs")
	v_g_565 = J.mc(_t1035, "find", [Callable(self, "_f147").bind(env)])
	if (not J.t(v_g_565)):
		return null
	if J.seq(J.gp(v_g_565, "act"), "doze"):
		J.mc(this_, "bubble", [v_g_565, "（醒咗）咩事？", 2.0])
	if J.t(v_n_564):
		J.sp(v_g_565, "tour", null)
		var _t1038 = {"x": J.max_([0.1, J.min_([J.sub((J.gp(J.G.get("OFFMAP"), "WW") if J.t(J.gp(J.gp(this_, "site"), "pano")) else 1.0), 0.1), J.add(J.gp(v_n_564, "x"), ((-0.12) if J.cmp(J.gp(v_n_564, "x"), J.gp(v_g_565, "x"), ">") else 0.12))])]), "y": J.max_([0.66, J.min_([0.93, J.add(J.gp(v_n_564, "y"), 0.02)])]), "wait": 6.0, "act": "look", "arrived": false, "path": null, "pi": 0.0}
		J.sp(v_g_565, "step", _t1038)
		J.sp(v_g_565, "next", null)
	else:
		if J.seq(J.gp(v_g_565, "act"), "doze"):
			J.sp(v_g_565, "step", null)

func _f150(this_, a: Array, env):
	var _t1039 = J.gp(env["__p"]["this"], "active")
	return (J.cl(env["f"], null, []) if J.t(_t1039) else _t1039)

func _f149(this_, a: Array, env):
	var v_s_579 = null
	var _s317 = {"__p": env, "f": null}
	_s317["f"] = J.arg(a, 0)
	v_s_579 = J.arg(a, 1)
	if J.t(J.gp(_s317["__p"]["this"], "headless")):
		J.cl(_s317["f"], null, [])
	else:
		var _t1041 = Callable(self, "_f150").bind(_s317)
		var _t1040 = J.gp(_s317["__p"]["this"], "_dl")
		J.F_setTimeout([_t1041, J.mul(J.add((_t1040 if J.t(_t1040) else 0.0), (v_s_579 if J.t(v_s_579) else 0.0)), 1000.0)])

func _f151(this_, a: Array, env):
	var v_w_581 = null
	v_w_581 = J.arg(a, 0)
	return J.gp(J.gp(v_w_581, "d"), "influencer")

func _f152(this_, a: Array, env):
	var v_w_582 = null
	v_w_582 = J.arg(a, 0)
	return J.gp(J.gp(v_w_582, "d"), "name")

func _f153(this_, a: Array, env):
	var _t1060 = env["w"]
	var _t1059 = J.G.get("pick")
	return J.mc(env["__p"]["this"], "bubble", [_t1060, J.cl(_t1059, null, [J.G.get("WIT_SAY")]), 2.0])

func _f154(this_, a: Array, env):
	var v_m_584 = null
	v_m_584 = J.arg(a, 0)
	var _t1067 = (not J.t(J.gp(J.gp(v_m_584, "d"), "guard")))
	return ((not J.cmp(J.gp(v_m_584, "fear"), 50.0, ">=")) if _t1067 else _t1067)

func _f155(this_, a: Array, env):
	var v_a_585 = null; var v_b_586 = null
	v_a_585 = J.arg(a, 0)
	v_b_586 = J.arg(a, 1)
	return (J.hypot_([J.sub(J.gp(v_a_585, "x"), J.gp(env["n"], "x")), J.sub(J.gp(v_a_585, "y"), J.gp(env["n"], "y"))]) - J.hypot_([J.sub(J.gp(v_b_586, "x"), J.gp(env["n"], "x")), J.sub(J.gp(v_b_586, "y"), J.gp(env["n"], "y"))]))

func _f157(this_, a: Array, env):
	var v_L_589 = null
	v_L_589 = J.gp(J.G.get("MOCK_SAY"), J.gp(J.gp(env["m"], "d"), "k"))
	var _t1083 = env["m"]
	var _t1082 = null
	if J.t(v_L_589):
		var _t1081 = J.G.get("pick")
		_t1082 = J.cl(_t1081, null, [v_L_589])
	else:
		_t1082 = "你又發乜神經？"
	J.mc(env["__p"]["this"], "bubble", [_t1083, _t1082, 2.4])
	var _t1084 = J.gp(env["m"], "mis")
	if J.t((J.seq(J.gp(J.gp(env["m"], "d"), "k"), "mis") if J.t(_t1084) else _t1084)):
		J.S_Object_("assign", [J.gp(env["m"], "mis"), {"act": "roll", "at": 0.0, "dur": 1.8}])
	var _t1085 = env["m"]
	var _t1086 = (1.0 if J.cmp(J.gp(env["__p"]["n"], "x"), J.gp(env["m"], "x"), ">") else (-1.0))
	J.sp(_t1085, "dir", _t1086)

func _f156(this_, a: Array, env):
	var v_i_588 = null
	var _s330 = {"__p": env, "m": null}
	_s330["m"] = J.arg(a, 0)
	v_i_588 = J.arg(a, 1)
	var _t1080 = _s330["__p"]["later"]
	return J.cl(_t1080, null, [Callable(self, "_f157").bind(_s330), (1.0 + J.mul(v_i_588, 0.7))])

func _f158(this_, a: Array, env):
	if (not J.t(J.gp(env["n"], "fleeing"))):
		var _t1089 = env["n"]
		var _t1088 = J.G.get("pick")
		J.mc(env["this"], "bubble", [_t1089, J.cl(_t1088, null, [J.G.get("PARA_SAY")]), 2.2])

func _f148(this_, a: Array, env):
	var v_pts_570 = null; var v_rational_571 = null; var v_seen_572 = null; var v_wits_573 = null; var v_aoe_574 = null; var v_alone_575 = null; var v_mk_577 = null; var v_w0_580 = null
	var _s316 = {"__p": env, "this": null, "n": null, "later": null}
	_s316["this"] = this_
	_s316["n"] = J.arg(a, 0)
	v_pts_570 = J.arg(a, 1)
	v_rational_571 = J.arg(a, 2)
	v_seen_572 = J.arg(a, 3)
	v_wits_573 = J.arg(a, 4)
	v_aoe_574 = J.arg(a, 5)
	v_alone_575 = J.arg(a, 6)
	_s316["later"] = Callable(self, "_f149").bind(_s316)
	if J.t(v_aoe_574):
		var _t1042 = _s316["n"]
		J.sp(_t1042, "mocked", 0.0)
		return null
	if J.t(v_seen_572):
		var _t1043 = _s316["n"]
		J.sp(_t1043, "mocked", 0.0)
		var _t1044 = _s316["this"]
		var _t1045 = J.max_([0.0, J.sub(J.gp(_s316["this"], "kpi"), J.gp(J.G.get("FEAR"), "seenPen"))])
		J.sp(_t1044, "kpi", _t1045)
		v_w0_580 = J.gp(v_wits_573, 0.0)
		if J.t(J.gp(_s316["this"], "night")):
			var _t1046 = J.gp(_s316["this"], "night")
			J.sp(_t1046, "seen", J.num(J.gp(_t1046, "seen")) + 1.0)
			if J.t(J.mc(v_wits_573, "some", [Callable(self, "_f151").bind(_s316)])):
				var _t1047 = J.gp(_s316["this"], "night")
				J.sp(_t1047, "filmed", J.num(J.gp(_t1047, "filmed")) + 1.0)
		var _t1049 = J.add(J.gp(J.G.get("EXPO"), "seen"), J.mul(J.gp(J.G.get("EXPO"), "perWit"), (J.len(v_wits_573) - 1.0)))
		var _t1048 = J.gp(_s316["this"], "_hab")
		J.mc(_s316["this"], "expose", [J.add(_t1049, (J.gp(J.G.get("EXPO"), "repeat") if J.cmp((_t1048 if J.t(_t1048) else 0.0), 1.0, ">=") else 0.0)), _s316["n"]])
		var _t1051 = J.gp(_s316["n"], "x")
		var _t1052 = J.sub(J.gp(_s316["n"], "y"), 0.3)
		var _t1050 = J.mc(v_wits_573, "map", [Callable(self, "_f152").bind(_s316)])
		J.mc(_s316["this"], "float", [_t1051, _t1052, ("穿崩！" + J.str(J.mc(_t1050, "join", ["、"])) + "望到 −" + J.str(J.gp(J.G.get("FEAR"), "seenPen"))), "#ff8a7a", 2.0])
		for _t1053 in J.iter(v_wits_573):
			var _s324 = {"__p": _s316, "w": null}
			_s324["w"] = _t1053
			if J.t(J.gp(J.gp(_s324["w"], "d"), "guard")):
				continue
			var _t1054 = _s324["w"]
			var _t1055 = J.max_([J.gp(_s324["w"], "fear"), J.min_([99.0, J.add(J.gp(_s324["w"], "fear"), J.gp(J.G.get("FEAR"), "witFear"))])])
			J.sp(_t1054, "fear", _t1055)
			var _t1056 = _s324["w"]
			var _t1057 = J.max_([J.gp(_s324["w"], "peak"), J.gp(_s324["w"], "fear")])
			J.sp(_t1056, "peak", _t1057)
			var _t1058 = _s324["__p"]["later"]
			J.cl(_t1058, null, [Callable(self, "_f153").bind(_s324), 0.5])
			if (not J.t(J.gp(_s324["__p"]["this"], "headless"))):
				var _t1062 = _s324["w"]
				var _t1061 = J.gp(_s324["__p"]["this"], "_dl")
				J.mc(_s324["__p"]["this"], "react", [_t1062, "startle", {"delay": J.add((_t1061 if J.t(_t1061) else 0.0), 0.4), "src": J.gp(_s324["__p"]["n"], "x")}])
		if J.t(v_w0_580):
			J.mc(_s316["this"], "wakeGuard", [_s316["n"]])
		return null
	var _t1063 = J.cmp(v_pts_570, 8.0, "<")
	var _t1064 = (_t1063 if _t1063 else v_rational_571)
	var _t1065 = (_t1064 if J.t(_t1064) else J.gp(_s316["n"], "fleeing"))
	if J.t((_t1065 if J.t(_t1065) else J.cmp(J.gp(_s316["n"], "fear"), 100.0, ">="))):
		return null
	var _t1066 = J.mc(_s316["this"], "hearers", [_s316["n"]])
	var _t1068 = J.mc(_t1066, "filter", [Callable(self, "_f154").bind(_s316)])
	var _t1069 = J.mc(_t1068, "sort", [Callable(self, "_f155").bind(_s316)])
	v_mk_577 = J.mc(_t1069, "slice", [0.0, 2.0])
	if (not J.t(J.len(v_mk_577))):
		if J.t(v_alone_575):
			J.mc(_s316["this"], "float", [J.gp(_s316["n"], "x"), J.sub(J.gp(_s316["n"], "y"), 0.27), "冇人喺度 ×1.2", "#9fe0c0", 1.4])
		return null
	var _t1070 = _s316["n"]
	var _t1071 = J.gp(_s316["n"], "mocked")
	var _t1072 = J.gp(_s316["n"], "mocked")
	var _t1073 = J.min_([5.0, J.add((_t1072 if J.t(_t1072) else 0.0), 1.0)])
	J.sp(_t1070, "mocked", _t1073)
	var _t1074 = _s316["n"]
	var _t1075 = J.max_([J.gp(_s316["n"], "fear"), J.min_([99.0, J.add(J.gp(_s316["n"], "fear"), J.gp(J.G.get("FEAR"), "mockFear"))])])
	J.sp(_t1074, "fear", _t1075)
	var _t1076 = _s316["n"]
	var _t1077 = J.max_([J.gp(_s316["n"], "peak"), J.gp(_s316["n"], "fear")])
	J.sp(_t1076, "peak", _t1077)
	var _t1078 = _s316["this"]
	var _t1079 = J.add(J.gp(_t1078, "kpi"), J.gp(J.G.get("FEAR"), "mockPts"))
	J.sp(_t1078, "kpi", _t1079)
	J.mc(v_mk_577, "forEach", [Callable(self, "_f156").bind(_s316)])
	if J.cmp(J.gp(_s316["n"], "mocked"), 2.0, ">="):
		var _t1087 = _s316["later"]
		J.cl(_t1087, null, [Callable(self, "_f158").bind(_s316), 2.6])

func _f160(this_, a: Array, env):
	var v_x_596 = null
	v_x_596 = J.arg(a, 0)
	var _t1107 = (not J.t(J.gp(v_x_596, "gone")))
	var _t1108 = ((not J.t(J.gp(v_x_596, "out"))) if _t1107 else _t1107)
	var _t1109 = ((not J.t(J.gp(v_x_596, "fleeing"))) if _t1108 else _t1108)
	var _t1110 = ((not J.t(J.gp(J.gp(v_x_596, "d"), "guard"))) if _t1109 else _t1109)
	return ((not J.t(J.gp(J.gp(v_x_596, "d"), "daoshi"))) if _t1110 else _t1110)

func _f161(this_, a: Array, env):
	var v_x_597 = null
	v_x_597 = J.arg(a, 0)
	var _t1112 = J.gp(J.gp(v_x_597, "d"), "guard")
	return ((not J.t(J.gp(v_x_597, "gone"))) if J.t(_t1112) else _t1112)

func _f162(this_, a: Array, env):
	var v_x_599 = null
	v_x_599 = J.arg(a, 0)
	var _t1117 = J.seq(J.gp(J.gp(v_x_599, "d"), "k"), "mis")
	var _t1118 = (_t1117 if _t1117 else J.seq(J.gp(J.gp(v_x_599, "d"), "k"), "boss"))
	var _t1119 = ((not J.t(J.gp(v_x_599, "gone"))) if _t1118 else _t1118)
	var _t1120 = ((not J.t(J.gp(v_x_599, "out"))) if _t1119 else _t1119)
	return ((not J.t(J.gp(v_x_599, "fleeing"))) if _t1120 else _t1120)

func _f163(this_, a: Array, env):
	var v_x_600 = null
	v_x_600 = J.arg(a, 0)
	var _t1122 = (not J.t(J.gp(v_x_600, "gone")))
	var _t1123 = ((not J.t(J.gp(v_x_600, "out"))) if _t1122 else _t1122)
	var _t1124 = ((not J.t(J.gp(v_x_600, "fleeing"))) if _t1123 else _t1123)
	return ((not J.t(J.gp(J.gp(v_x_600, "d"), "guard"))) if _t1124 else _t1124)

func _f159(this_, a: Array, env):
	var v_v_592 = null; var v_n_593 = null; var v_m_594 = null; var v_g_595 = null; var v_c_598 = null
	v_v_592 = J.arg(a, 0)
	v_n_593 = J.arg(a, 1)
	var _t1090 = (not J.t(v_v_592))
	if J.t((_t1090 if _t1090 else J.gp(this_, "expelled"))):
		return null
	if J.t((J.gp(J.gp(this_, "site"), "pano") if J.t(v_n_593) else v_n_593)):
		var _t1091 = this_
		var _t1092 = J.mc(this_, "roomOf", [v_n_593])
		J.sp(_t1091, "expoRoom", _t1092)
	var _t1093 = this_
	var _t1094 = J.gp(this_, "expo")
	var _t1095 = J.gp(this_, "expo")
	var _t1096 = J.min_([100.0, J.add((_t1095 if J.t(_t1095) else 0.0), v_v_592)])
	J.sp(_t1093, "expo", _t1096)
	var _t1097 = this_
	var _t1098 = J.gp(this_, "t")
	J.sp(_t1097, "expoT", _t1098)
	var _t1099 = this_
	var _t1100 = J.gp(this_, "expoMax")
	var _t1101 = J.gp(this_, "expoMax")
	var _t1102 = J.max_([(_t1101 if J.t(_t1101) else 0.0), J.gp(this_, "expo")])
	J.sp(_t1099, "expoMax", _t1102)
	var _t1103 = (not J.t(J.gp(this_, "headless")))
	if (J.cmp(v_v_592, 5.0, ">=") if _t1103 else _t1103):
		J.mc(this_, "float", [0.2, 0.06, ("穿崩度 +" + J.str(J.round(J.num(v_v_592)))), "#ff9a7a", 1.4])
	var _t1104 = J.cmp(J.gp(this_, "expo"), J.gp(J.G.get("EXPO"), "sus"), ">=")
	if ((not J.t(J.gp(this_, "alert"))) if _t1104 else _t1104):
		var _t1105 = this_
		J.sp(_t1105, "alert", true)
		var _t1106 = J.gp(this_, "npcs")
		v_m_594 = J.mc(_t1106, "find", [Callable(self, "_f160").bind(env)])
		if J.t(v_m_594):
			J.mc(this_, "bubble", [v_m_594, "呢度……係咪有嘢？", 2.4])
		var _t1111 = J.gp(this_, "npcs")
		v_g_595 = J.mc(_t1111, "find", [Callable(self, "_f161").bind(env)])
		if J.t(v_g_595):
			J.mc(this_, "bubble", [v_g_595, "我行多幾轉睇睇。", 2.2])
			J.mc(this_, "wakeGuard", [null])
	var _t1114 = J.gp(this_, "expo")
	var _t1113 = J.gp(this_, "daoAt")
	var _t1115 = J.cmp(_t1114, (_t1113 if J.t(_t1113) else J.gp(J.G.get("EXPO"), "call")), ">=")
	if ((not J.t(J.gp(this_, "daoCall"))) if _t1115 else _t1115):
		var _t1116 = J.gp(this_, "npcs")
		var _t1125 = J.mc(_t1116, "find", [Callable(self, "_f162").bind(env)])
		if not J.t(_t1125):
			var _t1121 = J.gp(this_, "npcs")
			_t1125 = J.mc(_t1121, "find", [Callable(self, "_f163").bind(env)])
		v_c_598 = _t1125
		if J.t(v_c_598):
			var _t1126 = this_
			var _t1127 = J.gp(this_, "t")
			J.sp(_t1126, "daoCall", _t1127)
			J.mc(this_, "bubble", [v_c_598, ("喂？林師傅？即刻上嚟二十三樓！" if J.seq(J.gp(J.gp(v_c_598, "d"), "k"), "boss") else "喂～林師傅呀？二十三樓好似有嘢……"), 3.0])
			if (not J.t(J.gp(this_, "headless"))):
				J.mc(this_, "float", [0.5, 0.3, (J.str(J.gp(J.gp(v_c_598, "d"), "name")) + "打電話請咗道士！"), "#ffcf6a", 2.6])

func _f164(this_, a: Array, env):
	var v_n_603 = null
	v_n_603 = J.arg(a, 0)
	var _t1128 = J.gp(J.gp(v_n_603, "d"), "guard")
	return ([12.0, 18.0] if J.t((J.gp(this_, "alert") if J.t(_t1128) else _t1128)) else J.gp(J.gp(v_n_603, "d"), "work"))

func _f166(this_, a: Array, env):
	var v_x_609 = null
	v_x_609 = J.arg(a, 0)
	var _t1130 = J.gp(J.gp(v_x_609, "d"), "daoshi")
	var _t1131 = ((not J.t(J.gp(v_x_609, "gone"))) if J.t(_t1130) else _t1130)
	var _t1132 = ((not J.t(J.gp(v_x_609, "out"))) if J.t(_t1131) else _t1131)
	return ((not J.t(J.gp(v_x_609, "fleeing"))) if J.t(_t1132) else _t1132)

func _f165(this_, a: Array, env):
	var v_dt_606 = null; var v_dao_607 = null; var v_quiet_608 = null; var v_ex_610 = null; var v_ey_611 = null; var v_n_612 = null
	v_dt_606 = J.arg(a, 0)
	var _t1129 = J.gp(this_, "npcs")
	v_dao_607 = J.mc(_t1129, "find", [Callable(self, "_f166").bind(env)])
	var _t1134 = J.gp(this_, "t")
	var _t1133 = J.gp(this_, "expoT")
	v_quiet_608 = (J.sub(_t1134, (_t1133 if J.t(_t1133) else (-99.0))) > 5.0)
	var _t1135 = this_
	var _t1136 = J.gp(this_, "expo")
	var _t1137 = J.gp(this_, "expo")
	var _t1138 = J.max_([0.0, J.sub((_t1137 if J.t(_t1137) else 0.0), J.mul((J.gp(J.G.get("EXPO"), "lowDecay") if J.t((v_quiet_608 if J.t(v_dao_607) else v_dao_607)) else J.gp(J.G.get("EXPO"), "decay")), v_dt_606))])
	J.sp(_t1135, "expo", _t1138)
	var _t1139 = J.gp(this_, "daoCall")
	var _t1142 = ((not J.t(J.gp(this_, "daoIn"))) if J.t(_t1139) else _t1139)
	if J.t(_t1142):
		var _t1141 = J.sub(J.gp(this_, "t"), J.gp(this_, "daoCall"))
		var _t1140 = J.gp(this_, "daoDelay")
		_t1142 = J.cmp(_t1141, (_t1140 if J.t(_t1140) else 7.0), ">")
	if J.t(_t1142):
		var _t1143 = this_
		J.sp(_t1143, "daoIn", true)
		var _t1144 = J.mc(this_, "exitPt", [])
		var _t1145 = J.gp(_t1144, 0.0)
		v_ex_610 = _t1145
		var _t1146 = J.gp(_t1144, 1.0)
		v_ey_611 = _t1146
		v_n_612 = {"d": J.G.get("DAOSHI"), "x": v_ex_610, "y": v_ey_611, "wi": 0.0, "wait": 0.0, "dir": (-1.0), "fear": 0.0, "peak": 0.0, "gone": false, "exitT": 0.0, "bounce": 0.0, "look": 0.0, "bub": null, "bubT": 0.0, "act": "walk", "ph": 0.0, "prog": 0.0, "ds": "in", "inAt": J.gp(this_, "t")}
		var _t1147 = J.gp(this_, "npcs")
		J.mc(_t1147, "push", [v_n_612])
		J.mc(this_, "elevator", [])
		J.mc(this_, "bubble", [v_n_612, "邊度有嘢？等我睇睇。", 2.6])

func _f167(this_, a: Array, env):
	var v_n_615 = null; var v_dt_616 = null; var v_spot_617 = null; var v_r_618 = null; var v_dx_619 = null; var v_dy_620 = null; var v_d_621 = null; var v_sp_622 = null; var v_startled_623 = null; var v_ex_624 = null; var v_ey_625 = null; var v_dx_626 = null; var v_dy_627 = null; var v_d_628 = null; var v_sp_629 = null
	v_n_615 = J.arg(a, 0)
	v_dt_616 = J.arg(a, 1)
	if (not J.t(J.gp(v_n_615, "spot"))):
		var _t1148 = J.gp(J.gp(this_, "site"), "pano")
		var _t1149 = (J.gp(this_, "expoRoom") if J.t(_t1148) else _t1148)
		v_r_618 = (J.gp(J.gp(J.G.get("OFFMAP"), "RM"), J.gp(this_, "expoRoom")) if J.t(((not J.seq(J.gp(this_, "expoRoom"), "main")) if J.t(_t1149) else _t1149)) else null)
		var _t1154 = null
		if J.t(v_r_618):
			_t1154 = [J.gp(v_r_618, "cx"), 0.86]
		else:
			var _t1153 = null
			if J.t(J.gp(J.gp(this_, "site"), "pano")):
				var _t1150 = J.G.get("_M")
				var _t1152 = J.cl(_t1150, null, [0.66])
				var _t1151 = J.G.get("_MY")
				_t1153 = [_t1152, J.cl(_t1151, null, [0.9])]
			else:
				_t1153 = [0.66, 0.9]
			_t1154 = _t1153
		J.sp(v_n_615, "spot", _t1154)
		var _t1155 = (J.gp(v_r_618, "name") if J.t(v_r_618) else null)
		J.sp(v_n_615, "spotRoom", _t1155)
		if J.t(v_r_618):
			J.mc(this_, "bubble", [v_n_615, (J.str(J.gp(v_r_618, "name")) + "？帶路。"), 2.4])
	v_spot_617 = J.gp(v_n_615, "spot")
	if J.seq(J.gp(v_n_615, "ds"), "in"):
		v_dx_619 = J.sub(J.gp(v_spot_617, 0.0), J.gp(v_n_615, "x"))
		v_dy_620 = J.sub(J.gp(v_spot_617, 1.0), J.gp(v_n_615, "y"))
		v_d_621 = J.hypot_([v_dx_619, v_dy_620])
		v_sp_622 = J.mul(J.gp(J.gp(v_n_615, "d"), "speed"), v_dt_616)
		J.sp(v_n_615, "act", "walk")
		var _t1156 = (1.0 if J.cmp(v_dx_619, 0.0, ">=") else (-1.0))
		J.sp(v_n_615, "dir", _t1156)
		if J.cmp(v_d_621, v_sp_622, "<="):
			var _t1157 = J.gp(v_spot_617, 0.0)
			J.sp(v_n_615, "x", _t1157)
			var _t1158 = J.gp(v_spot_617, 1.0)
			J.sp(v_n_615, "y", _t1158)
			J.sp(v_n_615, "ds", "ritual")
			J.sp(v_n_615, "rT", 0.0)
			J.sp(v_n_615, "act", "ritual")
			J.mc(this_, "bubble", [v_n_615, "（搖鈴）各位，借個位。", 2.4])
		else:
			var _t1159 = J.add(J.gp(v_n_615, "x"), J.mul(J.div(v_dx_619, v_d_621), v_sp_622))
			J.sp(v_n_615, "x", _t1159)
			var _t1160 = J.add(J.gp(v_n_615, "y"), J.mul(J.div(v_dy_620, v_d_621), v_sp_622))
			J.sp(v_n_615, "y", _t1160)
		return null
	if J.seq(J.gp(v_n_615, "ds"), "ritual"):
		J.sp(v_n_615, "act", "ritual")
		var _t1161 = J.add(J.gp(v_n_615, "rT"), v_dt_616)
		J.sp(v_n_615, "rT", _t1161)
		v_startled_623 = J.cmp(J.gp(v_n_615, "fear"), 50.0, ">=")
		if (not J.t(v_startled_623)):
			var _t1162 = J.gp(v_n_615, "prog")
			var _t1163 = J.gp(v_n_615, "prog")
			var _t1164 = J.min_([1.0, J.add((_t1163 if J.t(_t1163) else 0.0), (J.div(v_dt_616, J.gp(J.G.get("EXPO"), "ritual")) * (1.0 if J.cmp(J.gp(this_, "expo"), 25.0, ">=") else 0.4)))])
			J.sp(v_n_615, "prog", _t1164)
		var _t1165 = J.sub((5.0 if J.leq(J.gp(v_n_615, "lt"), null) else J.gp(v_n_615, "lt")), v_dt_616)
		J.sp(v_n_615, "lt", _t1165)
		var _t1166 = J.cmp(J.gp(v_n_615, "lt"), 0.0, "<=")
		if ((not J.t(J.gp(v_n_615, "bub"))) if _t1166 else _t1166):
			var _t1167 = (6.0 + (randf() * 4.0))
			J.sp(v_n_615, "lt", _t1167)
			var _t1169 = null
			if J.t(v_startled_623):
				_t1169 = "（執返個鈴）冇嘢，冇嘢……"
			else:
				var _t1168 = J.G.get("pick")
				_t1169 = J.cl(_t1168, null, [J.gp(J.gp(v_n_615, "d"), "lines")])
			J.mc(this_, "bubble", [v_n_615, _t1169, 2.4])
		if J.cmp(J.gp(v_n_615, "prog"), 1.0, ">="):
			var _t1170 = this_
			J.sp(_t1170, "expelled", true)
			J.mc(this_, "bubble", [v_n_615, "（符紙一貼）收工！", 2.6])
			if (not J.t(J.gp(this_, "headless"))):
				J.mc(this_, "float", [0.5, 0.35, "阿福被請走了……", "#ffcf6a", 3.0])
			var _t1171 = this_
			var _t1172 = J.gp(this_, "endAt")
			var _t1173 = (_t1172 if J.t(_t1172) else J.gp(this_, "t"))
			J.sp(_t1171, "endAt", _t1173)
			return null
		var _t1174 = J.cmp(J.gp(this_, "expo"), J.gp(J.G.get("EXPO"), "giveUp"), "<")
		if (J.cmp(J.gp(v_n_615, "rT"), 10.0, ">") if _t1174 else _t1174):
			J.sp(v_n_615, "ds", "out")
			J.mc(this_, "bubble", [v_n_615, "冇嘢喎……今晚收你半價。", 2.8])
			if (not J.t(J.gp(this_, "headless"))):
				J.mc(this_, "float", [0.5, 0.35, "道士放棄了", "#9fe0c0", 2.2])
		return null
	if J.seq(J.gp(v_n_615, "ds"), "out"):
		var _t1175 = J.mc(this_, "exitPt", [])
		var _t1176 = J.gp(_t1175, 0.0)
		v_ex_624 = _t1176
		var _t1177 = J.gp(_t1175, 1.0)
		v_ey_625 = _t1177
		v_dx_626 = J.sub(v_ex_624, J.gp(v_n_615, "x"))
		v_dy_627 = J.sub(v_ey_625, J.gp(v_n_615, "y"))
		v_d_628 = J.hypot_([v_dx_626, v_dy_627])
		v_sp_629 = J.mul(J.mul(J.gp(J.gp(v_n_615, "d"), "speed"), 1.2), v_dt_616)
		J.sp(v_n_615, "act", "walk")
		var _t1178 = (1.0 if J.cmp(v_dx_626, 0.0, ">=") else (-1.0))
		J.sp(v_n_615, "dir", _t1178)
		if J.cmp(v_d_628, v_sp_629, "<="):
			J.mc(this_, "goOut", [v_n_615, 0.0, true])
			J.sp(v_n_615, "left", true)
		else:
			var _t1179 = J.add(J.gp(v_n_615, "x"), J.mul(J.div(v_dx_626, v_d_628), v_sp_629))
			J.sp(v_n_615, "x", _t1179)
			var _t1180 = J.add(J.gp(v_n_615, "y"), J.mul(J.div(v_dy_627, v_d_628), v_sp_629))
			J.sp(v_n_615, "y", _t1180)

func _f168(this_, a: Array, env):
	var v_skip_632 = null; var v_room_633 = null; var v_n_634 = null; var v_before_635 = null
	v_skip_632 = J.arg(a, 0)
	v_room_633 = J.arg(a, 1)
	for _t1181 in J.iter(J.gp(this_, "npcs")):
		v_n_634 = _t1181
		var _t1182 = J.gp(v_n_634, "gone")
		var _t1183 = (_t1182 if J.t(_t1182) else J.gp(v_n_634, "out"))
		var _t1184 = (_t1183 if J.t(_t1183) else J.gp(v_n_634, "fleeing"))
		var _t1185 = (_t1184 if J.t(_t1184) else J.gp(J.gp(v_n_634, "d"), "guard"))
		var _t1186 = (_t1185 if J.t(_t1185) else (not J.cmp(J.gp(v_n_634, "shaken"), 0.0, ">")))
		var _t1188 = (_t1186 if J.t(_t1186) else (J.mc(v_skip_632, "includes", [v_n_634]) if J.t(v_skip_632) else v_skip_632))
		if not J.t(_t1188):
			var _t1187 = (J.gp(J.gp(this_, "site"), "pano") if J.t(v_room_633) else v_room_633)
			_t1188 = ((not J.seq(J.mc(this_, "roomOf", [v_n_634]), v_room_633)) if J.t(_t1187) else _t1187)
		if J.t(_t1188):
			continue
		v_before_635 = J.min_([100.0, J.gp(v_n_634, "peak")])
		var _t1189 = J.min_([99.0, J.add(J.gp(v_n_634, "fear"), 5.0)])
		J.sp(v_n_634, "fear", _t1189)
		var _t1190 = J.max_([J.gp(v_n_634, "peak"), J.gp(v_n_634, "fear")])
		J.sp(v_n_634, "peak", _t1190)
		var _t1191 = this_
		var _t1192 = J.add(J.gp(_t1191, "kpi"), J.round(J.num(J.sub(J.min_([100.0, J.gp(v_n_634, "peak")]), v_before_635))))
		J.sp(_t1191, "kpi", _t1192)
		if (not J.t(J.gp(this_, "headless"))):
			J.mc(this_, "react", [v_n_634, "flinch"])
			J.sp(v_n_634, "barHit", 0.6)
			if (randf() < 0.5):
				var _t1193 = J.G.get("pick")
				J.mc(this_, "bubble", [v_n_634, J.cl(_t1193, null, [J.G.get("JUMPY_SAY")]), 1.4])

func _f169(this_, a: Array, env):
	var v_d_638 = null; var v_v_639 = null; var v_why_640 = null
	v_d_638 = J.arg(a, 0)
	v_v_639 = J.arg(a, 1)
	v_why_640 = J.arg(a, 2)
	if J.t(v_v_639):
		var _t1194 = J.gp(this_, "karma")
		J.mc(_t1194, "push", [{"v": v_v_639, "who": J.gp(v_d_638, "name"), "why": v_why_640}])

func _f170(this_, a: Array, env):
	var v_e_643 = null; var v_r_644 = null; var v_mx_645 = null; var v_my_646 = null; var v_best_647 = null; var v_bd_648 = null; var v_n_649 = null; var v_n_650 = null; var v_x_651 = null; var v_y_652 = null; var v_hh_653 = null; var v_dd_654 = null; var v_k_655 = null; var v_k_656 = null; var v_p_657 = null; var v_x1_658 = null; var v_y1_659 = null; var v_x2_660 = null; var v_y2_661 = null; var v_g_662 = null; var v_k_663 = null
	v_e_643 = J.arg(a, 0)
	var _t1195 = J.gp(this_, "paused")
	if J.t((_t1195 if J.t(_t1195) else J.gp(this_, "endAt"))):
		return null
	var _t1196 = J.G.get("$")
	v_r_644 = J.mc(J.cl(_t1196, null, ["#sc-cvs"]), "getBoundingClientRect", [])
	v_mx_645 = J.sub(J.gp(v_e_643, "clientX"), J.gp(v_r_644, "left"))
	v_my_646 = J.sub(J.gp(v_e_643, "clientY"), J.gp(v_r_644, "top"))
	var _t1197 = J.gp(this_, "_edge")
	var _t1198 = (J.cmp(v_mx_645, J.gp(J.gp(this_, "_edge"), 0.0), ">") if J.t(_t1197) else _t1197)
	var _t1199 = (J.cmp(v_mx_645, J.add(J.gp(J.gp(this_, "_edge"), 0.0), J.gp(J.gp(this_, "_edge"), 2.0)), "<") if J.t(_t1198) else _t1198)
	var _t1200 = (J.cmp(v_my_646, J.gp(J.gp(this_, "_edge"), 1.0), ">") if J.t(_t1199) else _t1199)
	if J.t((J.cmp(v_my_646, J.add(J.gp(J.gp(this_, "_edge"), 1.0), J.gp(J.gp(this_, "_edge"), 3.0)), "<") if J.t(_t1200) else _t1200)):
		v_n_649 = J.gp(J.gp(this_, "_edge"), 4.0)
		var _t1201 = this_
		var _t1202 = J.mc(this_, "clampCam", [J.sub(J.gp(v_n_649, "x"), J.div(J.mc(this_, "viewW", []), 2.0))])
		J.sp(_t1201, "camTo", _t1202)
		var _t1203 = this_
		var _t1204 = (-99.0)
		J.sp(_t1203, "userPan", _t1204)
		return null
	v_best_647 = null
	v_bd_648 = 1000000000.0
	for _t1205 in J.iter(J.gp(this_, "npcs")):
		v_n_650 = _t1205
		var _t1206 = J.gp(v_n_650, "gone")
		if J.t((_t1206 if J.t(_t1206) else J.gp(v_n_650, "out"))):
			continue
		var _t1207 = J.mc(this_, "pt", [J.add(J.gp(v_n_650, "x"), (J.mc(J.G.get("OFFICE"), "kenOff", [v_n_650]) if J.t(J.mc(this_, "office", [])) else 0.0)), J.gp(v_n_650, "y")])
		var _t1208 = J.gp(_t1207, 0.0)
		v_x_651 = _t1208
		var _t1209 = J.gp(_t1207, 1.0)
		v_y_652 = _t1209
		v_hh_653 = J.mc(this_, "hh", [J.gp(v_n_650, "y")])
		var _t1210 = J.cmp(v_mx_645, J.sub(v_x_651, J.mul(v_hh_653, 0.32)), ">")
		var _t1211 = (J.cmp(v_mx_645, J.add(v_x_651, J.mul(v_hh_653, 0.32)), "<") if _t1210 else _t1210)
		var _t1212 = (J.cmp(v_my_646, J.sub(v_y_652, v_hh_653), ">") if _t1211 else _t1211)
		if (J.cmp(v_my_646, J.add(v_y_652, 6.0), "<") if _t1212 else _t1212):
			v_dd_654 = (absf(J.num(J.sub(v_mx_645, v_x_651))) + (absf(J.num(J.sub(v_my_646, J.sub(v_y_652, J.div(v_hh_653, 2.0))))) * 0.3))
			if J.cmp(v_dd_654, v_bd_648, "<"):
				v_bd_648 = v_dd_654
				v_best_647 = v_n_650
	var _t1213 = J.gp(this_, "armed")
	if J.t((v_best_647 if J.t(_t1213) else _t1213)):
		v_k_655 = J.gp(this_, "armed")
		var _t1214 = this_
		J.sp(_t1214, "armed", null)
		J.mc(this_, "useGhost", [v_k_655, v_best_647])
		var _t1215 = this_
		J.sp(_t1215, "sel", v_best_647)
		var _t1216 = this_
		J.sp(_t1216, "selAuto", false)
		J.mc(this_, "renderDock", [])
		J.mc(this_, "renderTarget", [])
		return null
	if J.t(v_best_647):
		var _t1217 = this_
		J.sp(_t1217, "sel", v_best_647)
		var _t1218 = this_
		J.sp(_t1218, "selAuto", false)
		J.mc(this_, "renderTarget", [])
		return null
	for _t1219 in J.keys(J.G.get("SCARE_PROPS")):
		v_k_656 = _t1219
		if J.t(J.gp(J.gp(J.G.get("SCARE_PROPS"), v_k_656), "group")):
			continue
		v_p_657 = J.gp(J.G.get("SCARE_PROPS"), v_k_656)
		var _t1220 = J.mc(this_, "pt", [J.gp(J.gp(v_p_657, "rect"), 0.0), J.gp(J.gp(v_p_657, "rect"), 1.0)])
		var _t1221 = J.gp(_t1220, 0.0)
		v_x1_658 = _t1221
		var _t1222 = J.gp(_t1220, 1.0)
		v_y1_659 = _t1222
		var _t1223 = J.mc(this_, "pt", [J.add(J.gp(J.gp(v_p_657, "rect"), 0.0), J.gp(J.gp(v_p_657, "rect"), 2.0)), J.add(J.gp(J.gp(v_p_657, "rect"), 1.0), J.gp(J.gp(v_p_657, "rect"), 3.0))])
		var _t1224 = J.gp(_t1223, 0.0)
		v_x2_660 = _t1224
		var _t1225 = J.gp(_t1223, 1.0)
		v_y2_661 = _t1225
		var _t1226 = J.cmp(v_mx_645, J.sub(v_x1_658, 10.0), ">")
		var _t1227 = (J.cmp(v_mx_645, J.add(v_x2_660, 10.0), "<") if _t1226 else _t1226)
		var _t1228 = (J.cmp(v_my_646, J.sub(v_y1_659, 10.0), ">") if _t1227 else _t1227)
		if (J.cmp(v_my_646, J.add(v_y2_661, 10.0), "<") if _t1228 else _t1228):
			J.mc(this_, "useProp", [v_k_656])
			return null
	if J.t(J.gp(this_, "armed")):
		v_g_662 = J.gp(J.G.get("SCARE_GHOSTS"), J.gp(this_, "armed"))
		if J.t(J.gp(v_g_662, "aoe")):
			v_k_663 = J.gp(this_, "armed")
			var _t1229 = this_
			J.sp(_t1229, "armed", null)
			J.mc(this_, "useGhost", [v_k_663])
			J.mc(this_, "renderDock", [])

func _f172(this_, a: Array, env):
	var v_k_667 = null
	v_k_667 = J.arg(a, 0)
	return ("<button class=\"btn sm sc-room\" data-p=\"" + J.str(v_k_667) + "\" style=\"padding:5px 2px;font-size:12px;line-height:1.25;width:100%\"><b>" + J.str(J.gp(J.gp(J.G.get("SCARE_PROPS"), v_k_667), "name")) + "</b><br><small>" + ("呢間房" if J.t(J.gp(J.gp(env["this"], "site"), "pano")) else "全場") + "・" + J.str(J.gp(J.gp(J.G.get("SCARE_PROPS"), v_k_667), "cost")) + "</small></button>")

func _f174(this_, a: Array, env):
	var v_t_671 = null
	v_t_671 = J.arg(a, 0)
	var _t1238 = null
	if J.t(J.gp(J.G.get("FEAR_WORD"), v_t_671)):
		var _t1237 = J.gp(J.G.get("FEAR_WORD"), v_t_671)
		_t1238 = J.mc(_t1237, "slice", [(-2.0)])
	else:
		_t1238 = v_t_671
	return _t1238

func _f173(this_, a: Array, env):
	var v_k_668 = null; var v_g_669 = null; var v_c_670 = null
	v_k_668 = J.arg(a, 0)
	v_g_669 = J.gp(J.G.get("SCARE_GHOSTS"), v_k_668)
	v_c_670 = J.gp(J.gp(env["this"], "caught"), v_k_668)
	var _t1242 = ("arm" if J.seq(J.gp(env["this"], "armed"), v_k_668) else "")
	var _t1243 = ("caught" if J.t(v_c_670) else "")
	var _t1244 = J.gp(v_g_669, "skill")
	var _t1241 = null
	if J.t(v_c_670):
		_t1241 = "喝茶中"
	else:
		var _t1240 = J.add(J.gp(v_g_669, "name"), "・")
		var _t1235 = J.gp(v_g_669, "types")
		var _t1236 = (_t1235 if J.t(_t1235) else [J.gp(v_g_669, "type")])
		var _t1239 = J.mc(_t1236, "map", [Callable(self, "_f174").bind(env)])
		_t1241 = (J.add(_t1240, J.mc(_t1239, "join", ["／"])) + ("・全場" if J.t(J.gp(v_g_669, "aoe")) else ""))
	return ("<button class=\"sc-gb " + _t1242 + " " + _t1243 + "\" data-k=\"" + J.str(v_k_668) + "\"><canvas data-por=\"" + J.str(v_k_668) + "\"></canvas><i class=\"cd\"></i><b>" + J.str(_t1244) + "</b><small>" + _t1241 + "</small></button>")

func _f176(this_, a: Array, env):
	var _t1253 = J.gp(env["__p"]["this"], "paused")
	if J.t((_t1253 if J.t(_t1253) else J.gp(env["__p"]["this"], "endAt"))):
		return null
	J.mc(env["__p"]["this"], "useProp", [J.gp(J.gp(env["b"], "dataset"), "p")])

func _f175(this_, a: Array, env):
	var _s380 = {"__p": env, "b": null}
	_s380["b"] = J.arg(a, 0)
	var _t1252 = _s380["b"]
	var _t1254 = Callable(self, "_f176").bind(_s380)
	J.sp(_t1252, "onclick", _t1254)
	return _t1254

func _f178(this_, a: Array, env):
	var v_k_674 = null; var v_g_675 = null
	v_k_674 = J.gp(J.gp(env["b"], "dataset"), "k")
	var _t1259 = J.gp(J.gp(env["__p"]["this"], "caught"), v_k_674)
	var _t1260 = (_t1259 if J.t(_t1259) else J.cmp(J.gp(J.gp(env["__p"]["this"], "cd"), v_k_674), 0.0, ">"))
	var _t1261 = (_t1260 if J.t(_t1260) else J.gp(env["__p"]["this"], "paused"))
	if J.t((_t1261 if J.t(_t1261) else J.gp(env["__p"]["this"], "endAt"))):
		return null
	v_g_675 = J.gp(J.G.get("SCARE_GHOSTS"), v_k_674)
	if J.t(J.gp(v_g_675, "aoe")):
		J.mc(env["__p"]["this"], "useGhost", [v_k_674])
		var _t1262 = env["__p"]["this"]
		J.sp(_t1262, "armed", null)
	else:
		var _t1263 = J.gp(env["__p"]["this"], "sel")
		var _t1264 = ((not J.t(J.gp(J.gp(env["__p"]["this"], "sel"), "gone"))) if J.t(_t1263) else _t1263)
		var _t1265 = ((not J.t(J.gp(J.gp(env["__p"]["this"], "sel"), "out"))) if J.t(_t1264) else _t1264)
		if J.t(((not J.t(J.gp(J.gp(J.gp(env["__p"]["this"], "sel"), "d"), "guard"))) if J.t(_t1265) else _t1265)):
			J.mc(env["__p"]["this"], "useGhost", [v_k_674, J.gp(env["__p"]["this"], "sel")])
			var _t1266 = env["__p"]["this"]
			J.sp(_t1266, "armed", null)
		else:
			var _t1267 = env["__p"]["this"]
			var _t1268 = (null if J.seq(J.gp(env["__p"]["this"], "armed"), v_k_674) else v_k_674)
			J.sp(_t1267, "armed", _t1268)
			J.mc(env["__p"]["this"], "toast", ["點一個人"])
	J.mc(env["__p"]["this"], "renderDock", [])

func _f177(this_, a: Array, env):
	var _s382 = {"__p": env, "b": null}
	_s382["b"] = J.arg(a, 0)
	var _t1258 = _s382["b"]
	var _t1269 = Callable(self, "_f178").bind(_s382)
	J.sp(_t1258, "onclick", _t1269)
	return _t1269

func _f171(this_, a: Array, env):
	var v_room_666 = null
	var _s376 = {"__p": env, "this": null}
	_s376["this"] = this_
	var _t1230 = ["lights", "ac"]
	var _t1231 = J.mc(_t1230, "map", [Callable(self, "_f172").bind(_s376)])
	v_room_666 = ("<div style=\"display:flex;flex-direction:column;gap:5px;flex:0 0 76px\">" + J.str(J.mc(_t1231, "join", [""])) + "</div>")
	var _t1232 = J.G.get("$")
	var _t1233 = J.cl(_t1232, null, ["#sc-dock"])
	var _t1234 = J.gp(_s376["this"], "team")
	var _t1245 = J.mc(_t1234, "map", [Callable(self, "_f173").bind(_s376)])
	var _t1246 = J.add(v_room_666, J.mc(_t1245, "join", [""]))
	J.sp(_t1233, "innerHTML", _t1246)
	var _t1247 = J.G.get("paintPortraits")
	var _t1248 = J.G.get("$")
	J.cl(_t1247, null, [J.cl(_t1248, null, ["#sc-dock"])])
	var _t1249 = J.G.get("$")
	var _t1250 = J.cl(_t1249, null, ["#sc-dock"])
	var _t1251 = J.mc(_t1250, "querySelectorAll", [".sc-room"])
	J.mc(_t1251, "forEach", [Callable(self, "_f175").bind(_s376)])
	var _t1255 = J.G.get("$")
	var _t1256 = J.cl(_t1255, null, ["#sc-dock"])
	var _t1257 = J.mc(_t1256, "querySelectorAll", [".sc-gb"])
	J.mc(_t1257, "forEach", [Callable(self, "_f177").bind(_s376)])

func _f180(this_, a: Array, env):
	return J.mc(env["this"], "peek", [env["n"]])

func _f181(this_, a: Array, env):
	return J.mc(env["this"], "usePhone", [env["n"]])

func _f182(this_, a: Array, env):
	return J.mc(env["this"], "useBreath", [env["n"]])

func _f179(this_, a: Array, env):
	var v_off_679 = null
	var _s387 = {"__p": env, "this": null, "n": null}
	_s387["this"] = this_
	var _t1270 = J.gp(_s387["this"], "sel")
	var _t1271 = ((not J.t(J.gp(J.gp(_s387["this"], "sel"), "gone"))) if J.t(_t1270) else _t1270)
	_s387["n"] = (J.gp(_s387["this"], "sel") if J.t(((not J.t(J.gp(J.gp(_s387["this"], "sel"), "fleeing"))) if J.t(_t1271) else _t1271)) else null)
	v_off_679 = ("disabled" if J.t((J.gp(_s387["n"], "out") if J.t(_s387["n"]) else _s387["n"])) else "")
	var _t1272 = _s387["this"]
	var _t1273 = (not (not J.t((J.gp(_s387["n"], "out") if J.t(_s387["n"]) else _s387["n"]))))
	J.sp(_t1272, "_selOut", _t1273)
	var _t1274 = J.G.get("$")
	var _t1275 = J.cl(_t1274, null, ["#sc-target"])
	var _t1276 = (("<div class=\"sc-who\"><b>" + J.str(J.gp(J.gp(_s387["n"], "d"), "name")) + "</b><small>" + J.str((("已經走了" if J.t(J.gp(_s387["n"], "left")) else "暫時不在") if J.t(J.gp(_s387["n"], "out")) else J.gp(J.gp(_s387["n"], "d"), "role"))) + "</small>" + (("<button class=\"btn sm\" id=\"sc-peek\">偷看手機</button><button class=\"btn sm gold\" id=\"sc-wa\" " + J.str(v_off_679) + ">傳訊息</button>") if J.t(J.gp(J.gp(_s387["n"], "d"), "phone")) else "") + "<button class=\"btn sm gold\" id=\"sc-br\" " + J.str(v_off_679) + ">背後呼氣</button></div><div class=\"sc-prof\" style=\"font-size:13px;line-height:1.5;padding:4px 2px 2px;opacity:.95\">" + J.str(J.mc(_s387["this"], "profile", [_s387["n"]])) + "</div>") if J.t(_s387["n"]) else "<div class=\"sc-who\"><small>點場景裡的人，或發光的東西。</small></div>")
	J.sp(_t1275, "innerHTML", _t1276)
	if J.t((J.gp(J.gp(_s387["n"], "d"), "phone") if J.t(_s387["n"]) else _s387["n"])):
		var _t1277 = J.G.get("$")
		var _t1278 = J.cl(_t1277, null, ["#sc-peek"])
		var _t1279 = Callable(self, "_f180").bind(_s387)
		J.sp(_t1278, "onclick", _t1279)
		var _t1280 = J.G.get("$")
		var _t1281 = J.cl(_t1280, null, ["#sc-wa"])
		var _t1282 = Callable(self, "_f181").bind(_s387)
		J.sp(_t1281, "onclick", _t1282)
	if J.t(_s387["n"]):
		var _t1283 = J.G.get("$")
		var _t1284 = J.cl(_t1283, null, ["#sc-br"])
		var _t1285 = Callable(self, "_f182").bind(_s387)
		J.sp(_t1284, "onclick", _t1285)

func _f184(this_, a: Array, env):
	var v_t_687 = null
	v_t_687 = J.arg(a, 0)
	var _t1290 = J.mc(env["hid"], "includes", [v_t_687])
	return ("？" if J.t(((not J.t(J.mc(env["K"], "has", [v_t_687]))) if J.t(_t1290) else _t1290)) else J.gp(J.G.get("FEAR_WORD"), v_t_687))

func _f185(this_, a: Array, env):
	var v_t_688 = null
	v_t_688 = J.arg(a, 0)
	return J.gp(J.G.get("FEAR_WORD"), v_t_688)

func _f183(this_, a: Array, env):
	var v_n_682 = null; var v_d_683 = null; var v_w_686 = null
	var _s392 = {"__p": env, "K": null, "hid": null}
	v_n_682 = J.arg(a, 0)
	v_d_683 = J.gp(v_n_682, "d")
	if J.t(J.gp(v_d_683, "guard")):
		return "怕：<b>乜都唔怕</b>（做咗三十年夜班）"
	var _t1286 = J.gp(this_, "known")
	var _t1287 = (J.gp(J.gp(this_, "known"), J.gp(v_d_683, "k")) if J.t(_t1286) else _t1286)
	_s392["K"] = (_t1287 if J.t(_t1287) else J.new_("Set", []))
	var _t1288 = J.gp(v_d_683, "hide")
	_s392["hid"] = (_t1288 if J.t(_t1288) else [])
	var _t1289 = J.gp(v_d_683, "weak")
	v_w_686 = J.mc(_t1289, "map", [Callable(self, "_f184").bind(_s392)])
	var _t1294 = J.mc(v_w_686, "join", ["、"])
	var _t1291 = J.gp(v_d_683, "immune")
	var _t1292 = J.mc(_t1291, "map", [Callable(self, "_f185").bind(_s392)])
	var _t1293 = J.mc(_t1292, "join", ["、"])
	return ("怕：<b style=\"color:#ffb070\">" + J.str(_t1294) + "</b>　唔怕：<b style=\"color:#9ab\">" + J.str((_t1293 if J.t(_t1293) else "—")) + "</b>" + ("（全場燈／冷氣都唔怕）" if J.t(J.gp(J.G.get("GROUP_IMMUNE"), J.gp(v_d_683, "k"))) else ""))

func _f187(this_, a: Array, env):
	var v_t_694 = null
	v_t_694 = J.arg(a, 0)
	return J.mc(env["K"], "add", [v_t_694])

func _f188(this_, a: Array, env):
	var v_m_695 = null
	v_m_695 = J.arg(a, 0)
	return ("<div class=\"sc-m " + ("me" if J.seq(J.gp(v_m_695, 0.0), J.gp(J.gp(env["n"], "d"), "name")) else "") + "\"><i>" + J.str(J.gp(v_m_695, 0.0)) + "・" + J.str(J.gp(v_m_695, 1.0)) + "</i>" + J.str(J.gp(v_m_695, 2.0)) + "</div>")

func _f189(this_, a: Array, env):
	var _t1314 = J.gp(env["p"], "classList")
	J.mc(_t1314, "remove", ["on"])
	var _t1315 = env["this"]
	J.sp(_t1315, "paused", false)
	var _t1316 = env["this"]
	var _t1317 = J.S_performance_("now", [])
	J.sp(_t1316, "last", _t1317)

func _f186(this_, a: Array, env):
	var _s395 = {"__p": env, "this": null, "n": null, "K": null, "p": null}
	_s395["this"] = this_
	_s395["n"] = J.arg(a, 0)
	var _t1295 = _s395["this"]
	var _t1296 = J.gp(_s395["this"], "known")
	var _t1297 = (_t1296 if J.t(_t1296) else {})
	J.sp(_t1295, "known", _t1297)
	var _t1298 = J.gp(_s395["this"], "known")
	var _t1299 = J.gp(J.gp(_s395["n"], "d"), "k")
	var _t1300 = J.gp(J.gp(_s395["this"], "known"), J.gp(J.gp(_s395["n"], "d"), "k"))
	var _t1301 = (_t1300 if J.t(_t1300) else J.new_("Set", []))
	J.sp(_t1298, _t1299, _t1301)
	_s395["K"] = _t1301
	var _t1302 = J.gp(J.gp(_s395["n"], "d"), "hide")
	var _t1303 = (_t1302 if J.t(_t1302) else [])
	J.mc(_t1303, "forEach", [Callable(self, "_f187").bind(_s395)])
	J.mc(_s395["this"], "renderTarget", [])
	var _t1304 = _s395["this"]
	J.sp(_t1304, "paused", true)
	var _t1305 = J.G.get("$")
	_s395["p"] = J.cl(_t1305, null, ["#sc-phone"])
	var _t1306 = _s395["p"]
	var _t1309 = J.gp(J.gp(_s395["n"], "d"), "name")
	var _t1307 = J.gp(J.gp(_s395["n"], "d"), "chat")
	var _t1308 = J.mc(_t1307, "map", [Callable(self, "_f188").bind(_s395)])
	var _t1310 = ("<div class=\"sc-ph\"><div class=\"sc-ph-h\">" + J.str(_t1309) + " 的手機<button id=\"sc-ph-x\">✕</button></div><div class=\"sc-ph-b\">" + J.str(J.mc(_t1308, "join", [""])) + "</div><div class=\"sc-ph-f\">偷看的時候，時間是停的。</div></div>")
	J.sp(_t1306, "innerHTML", _t1310)
	var _t1311 = J.gp(_s395["p"], "classList")
	J.mc(_t1311, "add", ["on"])
	var _t1312 = J.G.get("$")
	var _t1313 = J.cl(_t1312, null, ["#sc-ph-x"])
	var _t1318 = Callable(self, "_f189").bind(_s395)
	J.sp(_t1313, "onclick", _t1318)

func _f191(this_, a: Array, env):
	var v_n_703 = null
	v_n_703 = J.arg(a, 0)
	return J.mc(env["this"], "onScreen", [(J.gp(v_n_703, "vX") if (not J.leq(J.gp(v_n_703, "vX"), null)) else J.gp(v_n_703, "x")), 0.0])

func _f192(this_, a: Array, env):
	var v_n_704 = null
	v_n_704 = J.arg(a, 0)
	var _t1324 = (not J.t(J.gp(v_n_704, "gone")))
	var _t1325 = ((not J.t(J.gp(v_n_704, "out"))) if _t1324 else _t1324)
	var _t1326 = ((not J.t(J.gp(v_n_704, "fleeing"))) if _t1325 else _t1325)
	return ((not J.t(J.gp(J.gp(v_n_704, "d"), "guard"))) if _t1326 else _t1326)

func _f193(this_, a: Array, env):
	var v_b_705 = null; var v_k_706 = null; var v_c_707 = null
	v_b_705 = J.arg(a, 0)
	v_k_706 = J.gp(J.gp(v_b_705, "dataset"), "p")
	var _t1347 = J.gp(env["this"], "pcd")
	var _t1348 = J.gp((_t1347 if J.t(_t1347) else {}), v_k_706)
	v_c_707 = (_t1348 if J.t(_t1348) else 0.0)
	var _t1349 = J.mc(v_b_705, "querySelector", ["small"])
	var _t1350 = (("冷卻 " + J.str(ceil(J.num(v_c_707))) + " 秒") if J.cmp(v_c_707, 0.0, ">") else (J.str((J.gp(J.mc(env["this"], "camRoom", []), "name") if J.t(J.gp(J.gp(env["this"], "site"), "pano")) else "全場")) + "・" + J.str(J.gp(J.gp(J.G.get("SCARE_PROPS"), v_k_706), "cost"))))
	J.sp(_t1349, "textContent", _t1350)
	var _t1351 = J.gp(v_b_705, "style")
	var _t1352 = J.cmp(v_c_707, 0.0, ">")
	var _t1353 = (0.5 if (_t1352 if _t1352 else J.cmp(J.gp(env["this"], "mana"), J.gp(J.gp(J.G.get("SCARE_PROPS"), v_k_706), "cost"), "<")) else 1.0)
	J.sp(_t1351, "opacity", _t1353)

func _f194(this_, a: Array, env):
	var v_b_708 = null; var v_k_709 = null; var v_c_710 = null
	v_b_708 = J.arg(a, 0)
	v_k_709 = J.gp(J.gp(v_b_708, "dataset"), "k")
	v_c_710 = J.gp(J.gp(env["this"], "cd"), v_k_709)
	var _t1357 = J.gp(v_b_708, "classList")
	var _t1358 = J.cmp(v_c_710, 0.0, ">")
	J.mc(_t1357, "toggle", ["cool", ((not J.t(J.gp(J.gp(env["this"], "caught"), v_k_709))) if _t1358 else _t1358)])
	var _t1359 = J.gp(J.mc(v_b_708, "querySelector", [".cd"]), "style")
	var _t1360 = J.add((100.0 if J.t(J.gp(J.gp(env["this"], "caught"), v_k_709)) else (J.div(v_c_710, 22.0) * 100.0)), "%")
	J.sp(_t1359, "height", _t1360)
	var _t1361 = J.gp(v_b_708, "classList")
	var _t1364 = J.gp(env["this"], "mana")
	var _t1362 = J.gp(J.G.get("SCARE_GHOSTS"), v_k_709)
	var _t1363 = J.gp((_t1362 if J.t(_t1362) else {}), "cost")
	J.mc(_t1361, "toggle", ["low", J.cmp(_t1364, (_t1363 if J.t(_t1363) else 35.0), "<")])

func _f190(this_, a: Array, env):
	var v_mins_698 = null; var v_hh_699 = null; var v_mm_700 = null; var v_vis_701 = null; var v_ok_702 = null
	var _s399 = {"__p": env, "this": null}
	_s399["this"] = this_
	var _t1322 = J.gp(_s399["this"], "sel")
	if J.t(_t1322):
		var _t1319 = J.gp(J.gp(_s399["this"], "sel"), "gone")
		var _t1321 = (_t1319 if J.t(_t1319) else J.gp(J.gp(_s399["this"], "sel"), "fleeing"))
		if not J.t(_t1321):
			var _t1320 = J.gp(J.gp(_s399["this"], "sel"), "left")
			_t1321 = (J.gp(J.gp(_s399["this"], "sel"), "out") if J.t(_t1320) else _t1320)
		_t1322 = _t1321
	if J.t(_t1322):
		v_vis_701 = Callable(self, "_f191").bind(_s399)
		var _t1323 = J.gp(_s399["this"], "npcs")
		v_ok_702 = J.mc(_t1323, "filter", [Callable(self, "_f192").bind(_s399)])
		var _t1327 = _s399["this"]
		var _t1328 = J.mc(v_ok_702, "find", [v_vis_701])
		var _t1329 = (_t1328 if J.t(_t1328) else J.gp(v_ok_702, 0.0))
		var _t1330 = (_t1329 if J.t(_t1329) else null)
		J.sp(_t1327, "sel", _t1330)
		var _t1331 = _s399["this"]
		J.sp(_t1331, "selAuto", true)
		J.mc(_s399["this"], "renderTarget", [])
	else:
		var _t1332 = J.gp(_s399["this"], "sel")
		if J.t(((not J.seq((not (not J.t(J.gp(J.gp(_s399["this"], "sel"), "out")))), (not (not J.t(J.gp(_s399["this"], "_selOut")))))) if J.t(_t1332) else _t1332)):
			J.mc(_s399["this"], "renderTarget", [])
	v_mins_698 = J.min_([360.0, floor(J.num((J.div(J.gp(_s399["this"], "t"), J.G.get("NIGHT_SEC")) * 360.0)))])
	var _t1333 = J.F_String([floor(J.num(J.div(v_mins_698, 60.0)))])
	v_hh_699 = J.mc(_t1333, "padStart", [2.0, "0"])
	var _t1334 = J.F_String([(floor(J.num(J.div(J.mod(v_mins_698, 60.0), 10.0))) * 10.0)])
	v_mm_700 = J.mc(_t1334, "padStart", [2.0, "0"])
	var _t1335 = J.G.get("$")
	var _t1336 = J.cl(_t1335, null, ["#sc-clock"])
	var _t1337 = (J.str(v_hh_699) + ":" + J.str(v_mm_700))
	J.sp(_t1336, "textContent", _t1337)
	var _t1338 = J.G.get("$")
	var _t1339 = J.cl(_t1338, null, ["#sc-kpi"])
	var _t1340 = ("驚嚇 " + J.str(J.gp(_s399["this"], "kpi")))
	J.sp(_t1339, "textContent", _t1340)
	var _t1341 = J.G.get("$")
	var _t1342 = J.gp(J.cl(_t1341, null, ["#sc-mana i"]), "style")
	var _t1343 = J.add(J.gp(_s399["this"], "mana"), "%")
	J.sp(_t1342, "width", _t1343)
	if J.t(J.gp(J.gp(_s399["this"], "site"), "pano")):
		J.mc(J.G.get("OFFMAP"), "mapTick", [_s399["this"]])
	var _t1344 = J.G.get("$")
	var _t1345 = J.cl(_t1344, null, ["#sc-dock"])
	var _t1346 = J.mc(_t1345, "querySelectorAll", [".sc-room"])
	J.mc(_t1346, "forEach", [Callable(self, "_f193").bind(_s399)])
	var _t1354 = J.G.get("$")
	var _t1355 = J.cl(_t1354, null, ["#sc-dock"])
	var _t1356 = J.mc(_t1355, "querySelectorAll", [".sc-gb"])
	J.mc(_t1356, "forEach", [Callable(self, "_f194").bind(_s399)])

func _f196(this_, a: Array, env):
	var v_m_718 = null
	v_m_718 = J.arg(a, 0)
	var _t1369 = (not J.seq(v_m_718, env["n"]))
	var _t1370 = (J.gp(v_m_718, "bub") if _t1369 else _t1369)
	var _t1371 = (J.cmp(J.gp(v_m_718, "bubT"), 0.0, ">") if J.t(_t1370) else _t1370)
	return ((not J.t(J.gp(v_m_718, "gone"))) if J.t(_t1371) else _t1371)

func _f197(this_, a: Array, env):
	var v_q_719 = null
	v_q_719 = J.arg(a, 0)
	return (not J.seq(J.gp(v_q_719, "n"), env["n"]))

func _f195(this_, a: Array, env):
	var v_text_714 = null; var v_dur_715 = null; var v_ghost_716 = null; var v_live_717 = null
	var _s405 = {"__p": env, "n": null}
	_s405["n"] = J.arg(a, 0)
	v_text_714 = J.arg(a, 1)
	v_dur_715 = J.arg(a, 2)
	v_ghost_716 = J.arg(a, 3)
	var _t1365 = (not J.t(_s405["n"]))
	if (_t1365 if _t1365 else (not J.t(v_text_714))):
		return null
	var _t1367 = (not J.t(J.gp(this_, "headless")))
	if J.t(_t1367):
		var _t1366 = J.gp(_s405["n"], "bub")
		_t1367 = (not J.t((J.cmp(J.gp(_s405["n"], "bubT"), 0.0, ">") if J.t(_t1366) else _t1366)))
	if _t1367:
		var _t1368 = J.gp(this_, "npcs")
		v_live_717 = J.len(J.mc(_t1368, "filter", [Callable(self, "_f196").bind(_s405)]))
		if J.cmp(v_live_717, 2.0, ">="):
			var _t1372 = this_
			var _t1373 = J.gp(this_, "bq")
			var _t1374 = (_t1373 if J.t(_t1373) else [])
			var _t1375 = J.mc(_t1374, "filter", [Callable(self, "_f197").bind(_s405)])
			J.sp(_t1372, "bq", _t1375)
			var _t1376 = J.gp(this_, "bq")
			J.mc(_t1376, "push", [{"n": _s405["n"], "text": v_text_714, "dur": v_dur_715, "ghost": v_ghost_716, "at": J.gp(this_, "t")}])
			if (J.len(J.gp(this_, "bq")) > 3.0):
				J.mc(J.gp(this_, "bq"), "shift", [])
			return null
	var _t1377 = _s405["n"]
	J.sp(_t1377, "bub", v_text_714)
	var _t1378 = _s405["n"]
	var _t1379 = (v_dur_715 if J.t(v_dur_715) else 2.0)
	J.sp(_t1378, "bubT", _t1379)
	var _t1380 = _s405["n"]
	var _t1381 = (not (not J.t(v_ghost_716)))
	J.sp(_t1380, "bubG", _t1381)
	var _t1382 = _s405["n"]
	var _t1383 = J.gp(this_, "t")
	J.sp(_t1382, "bubAt", _t1383)

func _f199(this_, a: Array, env):
	var v_f_723 = null
	v_f_723 = J.arg(a, 0)
	var _t1386 = J.sub(J.gp(v_f_723, "life"), env["dt"])
	J.sp(v_f_723, "life", _t1386)
	return (_t1386 > 0.02)

func _f198(this_, a: Array, env):
	var v_f_724 = null
	var _s410 = {"__p": env, "dt": null}
	_s410["dt"] = J.arg(a, 0)
	var _t1384 = this_
	var _t1385 = J.gp(this_, "floats")
	var _t1387 = J.mc(_t1385, "filter", [Callable(self, "_f199").bind(_s410)])
	J.sp(_t1384, "floats", _t1387)
	var _t1388 = (not J.t(J.len(J.gp(this_, "floats"))))
	var _t1389 = (J.gp(this_, "fq") if _t1388 else _t1388)
	if J.t((J.len(J.gp(this_, "fq")) if J.t(_t1389) else _t1389)):
		v_f_724 = J.mc(J.gp(this_, "fq"), "shift", [])
		var _t1390 = (0.9 if J.t(J.len(J.gp(this_, "fq"))) else J.gp(v_f_724, "max"))
		J.sp(v_f_724, "max", _t1390)
		J.sp(v_f_724, "life", _t1390)
		var _t1391 = J.gp(this_, "floats")
		J.mc(_t1391, "push", [v_f_724])

func _f200(this_, a: Array, env):
	var v_x_727 = null; var v_y_728 = null; var v_text_729 = null; var v_color_730 = null; var v_life_731 = null
	v_x_727 = J.arg(a, 0)
	v_y_728 = J.arg(a, 1)
	v_text_729 = J.arg(a, 2)
	v_color_730 = J.arg(a, 3)
	v_life_731 = J.arg(a, 4)
	if J.t(J.gp(this_, "headless")):
		return null
	var _t1392 = this_
	var _t1393 = J.gp(this_, "fq")
	var _t1394 = (_t1393 if J.t(_t1393) else [])
	J.sp(_t1392, "fq", _t1394)
	var _t1395 = J.gp(this_, "fq")
	J.mc(_t1395, "push", [{"text": v_text_729, "color": v_color_730, "life": J.min_([1.6, (v_life_731 if J.t(v_life_731) else 1.3)]), "max": J.min_([1.6, (v_life_731 if J.t(v_life_731) else 1.3)])}])
	if (J.len(J.gp(this_, "fq")) > 3.0):
		J.mc(J.gp(this_, "fq"), "shift", [])

func _f201(this_, a: Array, env):
	var v_x_734 = null; var v_y_735 = null; var v_text_736 = null; var v_color_737 = null; var v_life_738 = null
	v_x_734 = J.arg(a, 0)
	v_y_735 = J.arg(a, 1)
	v_text_736 = J.arg(a, 2)
	v_color_737 = J.arg(a, 3)
	v_life_738 = J.arg(a, 4)
	var _t1396 = J.gp(this_, "floats")
	J.mc(_t1396, "push", [{"x": v_x_734, "y": v_y_735, "text": v_text_736, "color": v_color_737, "life": (v_life_738 if J.t(v_life_738) else 1.6), "max": (v_life_738 if J.t(v_life_738) else 1.6)}])

func _f202(this_, a: Array, env):
	var v_t_741 = null
	v_t_741 = J.arg(a, 0)
	if (not J.t(J.gp(this_, "headless"))):
		J.mc(this_, "float", [0.5, 0.5, v_t_741, "#fff", 1.2])

func _f203(this_, a: Array, env):
	var v_n_744 = null; var v_x_745 = null; var v_y_746 = null
	v_n_744 = J.arg(a, 0)
	var _t1397 = J.gp(v_n_744, "fleeT")
	if J.t((J.cmp(J.sub(J.gp(this_, "t"), J.gp(v_n_744, "fleeT")), J.gp(v_n_744, "fleeHold"), "<") if J.t(_t1397) else _t1397)):
		return null
	v_x_745 = (J.gp(v_n_744, "vX") if (not J.leq(J.gp(v_n_744, "vX"), null)) else J.gp(v_n_744, "x"))
	v_y_746 = (J.gp(v_n_744, "vY") if (not J.leq(J.gp(v_n_744, "vY"), null)) else J.gp(v_n_744, "y"))
	var _t1398 = J.gp(this_, "parts")
	J.mc(_t1398, "push", [{"kind": "dust", "x": J.sub(v_x_745, J.mul(J.gp(v_n_744, "dir"), 0.03)), "y": v_y_746, "vx": ((-J.num(J.gp(v_n_744, "dir"))) * 0.05), "vy": (-0.03), "life": 0.6}])

func _f204(this_, a: Array, env):
	var v_k_749 = null; var v_p_750 = null; var v_n_751 = null; var v_cx_752 = null; var v_cy_753 = null; var v_i_754 = null; var v_i_755 = null; var v_i_756 = null; var v_hy_757 = null; var v_i_758 = null
	v_k_749 = J.arg(a, 0)
	v_p_750 = J.arg(a, 1)
	v_n_751 = J.arg(a, 2)
	v_cx_752 = J.add(J.gp(J.gp(v_p_750, "rect"), 0.0), J.div(J.gp(J.gp(v_p_750, "rect"), 2.0), 2.0))
	v_cy_753 = J.add(J.gp(J.gp(v_p_750, "rect"), 1.0), J.div(J.gp(J.gp(v_p_750, "rect"), 3.0), 2.0))
	var _t1399 = J.seq(v_k_749, "printer")
	if ((not J.t(J.mc(this_, "office", []))) if _t1399 else _t1399):
		v_i_754 = 0.0
		while true:
			if not J.cmp(v_i_754, 14.0, "<"): break
			var _t1400 = J.gp(this_, "parts")
			J.mc(_t1400, "push", [{"kind": "paper", "x": v_cx_752, "y": v_cy_753, "vx": ((randf() - 0.7) * 0.35), "vy": ((-0.15) - (randf() * 0.25)), "g": 0.35, "vr": ((randf() - 0.5) * 9.0), "life": (1.6 + randf())}])
			v_i_754 = J.num(v_i_754) + 1.0
	var _t1401 = J.seq(v_k_749, "ac")
	if ((not J.t(v_n_751)) if _t1401 else _t1401):
		v_i_755 = 0.0
		while true:
			if not J.cmp(v_i_755, 26.0, "<"): break
			var _t1402 = J.gp(this_, "parts")
			J.mc(_t1402, "push", [{"kind": "frost", "x": J.add(J.gp(J.gp(v_p_750, "rect"), 0.0), J.mul(randf(), J.gp(J.gp(v_p_750, "rect"), 2.0))), "y": J.add(J.gp(J.gp(v_p_750, "rect"), 1.0), J.gp(J.gp(v_p_750, "rect"), 3.0)), "vx": ((randf() - 0.5) * 0.06), "vy": (0.05 + (randf() * 0.12)), "life": (2.0 + randf())}])
			v_i_755 = J.num(v_i_755) + 1.0
	var _t1403 = J.seq(v_k_749, "ac")
	if J.t((v_n_751 if _t1403 else _t1403)):
		v_i_756 = 0.0
		while true:
			if not J.cmp(v_i_756, 22.0, "<"): break
			v_hy_757 = (J.sub(J.gp(v_n_751, "y"), J.mul(J.mc(this_, "hhF", [J.gp(v_n_751, "y")]), 1.05)) if J.t(v_n_751) else J.add(J.gp(J.gp(v_p_750, "rect"), 1.0), J.gp(J.gp(v_p_750, "rect"), 3.0)))
			var _t1404 = J.gp(this_, "parts")
			J.mc(_t1404, "push", [{"kind": "frost", "x": J.add((J.gp(v_n_751, "x") if J.t(v_n_751) else v_cx_752), ((randf() - 0.5) * 0.09)), "y": J.sub(v_hy_757, (randf() * 0.03)), "vx": ((randf() - 0.5) * 0.04), "vy": (0.03 + (randf() * 0.06)), "life": (1.6 + randf()), "delay": (randf() * 0.6)}])
			v_i_756 = J.num(v_i_756) + 1.0
	if J.seq(v_k_749, "water"):
		v_i_758 = 0.0
		while true:
			if not J.cmp(v_i_758, 10.0, "<"): break
			var _t1405 = J.gp(this_, "parts")
			J.mc(_t1405, "push", [{"kind": "bubble", "x": J.add(v_cx_752, ((randf() - 0.5) * 0.04)), "y": J.add(v_cy_753, 0.05), "vx": 0.0, "vy": ((-0.04) - (randf() * 0.05)), "life": (1.2 + randf())}])
			v_i_758 = J.num(v_i_758) + 1.0

func _f206(this_, a: Array, env):
	var v_n_777 = null
	v_n_777 = J.arg(a, 0)
	var _t1411 = J.gp(J.gp(v_n_777, "d"), "guard")
	var _t1412 = ((not J.t(J.gp(v_n_777, "gone"))) if J.t(_t1411) else _t1411)
	var _t1413 = ((not J.t(J.gp(v_n_777, "out"))) if J.t(_t1412) else _t1412)
	return ((not J.seq(J.gp(v_n_777, "act"), "doze")) if J.t(_t1413) else _t1413)

func _f207(this_, a: Array, env):
	var v_n_795 = null
	v_n_795 = J.arg(a, 0)
	var _t1438 = (not J.t(J.gp(v_n_795, "gone")))
	if J.t(_t1438):
		var _t1437 = J.gp(v_n_795, "out")
		if J.t(_t1437):
			var _t1436 = J.gp(env["this"], "t")
			var _t1435 = J.gp(v_n_795, "outAt")
			_t1437 = (J.sub(_t1436, (_t1435 if J.t(_t1435) else 0.0)) > 0.6)
		_t1438 = (not J.t(_t1437))
	var _t1441 = _t1438
	if not J.t(_t1441):
		var _t1439 = J.cmp(J.gp(v_n_795, "exitT"), 0.0, ">")
		var _t1440 = ((J.sub(J.gp(env["this"], "t"), J.gp(v_n_795, "exitT")) < (0.8 if J.t(env["OF"]) else 3.0)) if _t1439 else _t1439)
		_t1441 = (J.cmp(J.gp(J.mc(env["this"], "visPos", [v_n_795]), 0.0), 1.15, "<") if _t1440 else _t1440)
	var _t1443 = _t1441
	if J.t(_t1443):
		var _t1442 = (not J.t(J.gp(J.gp(env["this"], "site"), "pano")))
		_t1443 = (_t1442 if _t1442 else J.mc(env["this"], "onScreen", [J.gp(v_n_795, "x"), 0.3]))
	return _t1443

func _f209(this_, a: Array, env):
	var v_c_797 = null; var v_r_798 = null
	v_c_797 = J.arg(a, 0)
	v_r_798 = J.mc(env["__p"]["this"], "drawNpc", [v_c_797, env["n"], env["__p"]["t"]])
	var _t1446 = (not J.t(J.gp(env["n"], "gone")))
	var _t1447 = (J.cmp(J.gp(v_r_798, "x"), (-30.0), ">") if _t1446 else _t1446)
	if (J.cmp(J.gp(v_r_798, "x"), J.add(J.gp(env["__p"]["this"], "W"), 30.0), "<") if _t1447 else _t1447):
		J.mc(env["__p"]["tags"], "push", [[env["n"], J.gp(v_r_798, "x"), J.sub(J.gp(v_r_798, "top"), 8.0)]])

func _f208(this_, a: Array, env):
	var _s437 = {"__p": env, "n": null}
	_s437["n"] = J.arg(a, 0)
	var _t1445 = null
	if J.t((J.mc(J.G.get("OFFICE"), "seated", [_s437["n"]]) if J.t(_s437["__p"]["OF"]) else _s437["__p"]["OF"])):
		_t1445 = J.sub(J.mc(J.G.get("OFFICE"), "kenZ", [_s437["n"]]), 0.0001)
	else:
		var _t1444 = (not J.leq(J.gp(_s437["n"], "vY"), null))
		_t1445 = (J.gp(_s437["n"], "vY") if ((not J.t(J.gp(_s437["n"], "gone"))) if _t1444 else _t1444) else J.gp(J.mc(_s437["__p"]["this"], "visPos", [_s437["n"]]), 1.0))
	return [_t1445, Callable(self, "_f209").bind(_s437)]

func _f210(this_, a: Array, env):
	var v_a_799 = null; var v_c_800 = null
	v_a_799 = J.arg(a, 0)
	v_c_800 = J.arg(a, 1)
	return J.sub(J.gp(v_a_799, 0.0), J.gp(v_c_800, 0.0))

func _f211(this_, a: Array, env):
	var v_a_814 = null; var v_b_815 = null
	v_a_814 = J.arg(a, 0)
	v_b_815 = J.arg(a, 1)
	return J.sub(J.gp(v_b_815, 2.0), J.gp(v_a_814, 2.0))

func _f212(this_, a: Array, env):
	var v_r_820 = null
	v_r_820 = J.arg(a, 0)
	var _t1477 = (absf(J.num(J.sub(J.gp(v_r_820, 0.0), J.gp(env["__p"]["q"], 1.0)))) < 100.0)
	var _t1478 = (J.cmp(J.sub(J.sub(env["y"], 20.0), env["ext"]), J.add(J.gp(v_r_820, 1.0), 9.0), "<") if _t1477 else _t1477)
	return (J.cmp(J.add(env["y"], 9.0), J.sub(J.sub(J.gp(v_r_820, 1.0), 20.0), J.gp(v_r_820, 3.0)), ">") if _t1478 else _t1478)

func _f213(this_, a: Array, env):
	var v_q_821 = null
	v_q_821 = J.arg(a, 0)
	return J.seq(J.gp(v_q_821, 0.0), env["sel"])

func _f214(this_, a: Array, env):
	var v_r_825 = null
	v_r_825 = J.arg(a, 0)
	return [J.sub(J.gp(v_r_825, 0.0), 52.0), J.sub(J.sub(J.gp(v_r_825, 1.0), 22.0), J.gp(v_r_825, 3.0)), 104.0, J.add(32.0, J.gp(v_r_825, 3.0))]

func _f215(this_, a: Array, env):
	var v_q_828 = null
	v_q_828 = J.arg(a, 0)
	var _t1505 = J.gp(J.gp(v_q_828, 0.0), "bub")
	return ((not J.t(J.gp(J.gp(v_q_828, 0.0), "out"))) if J.t(_t1505) else _t1505)

func _f216(this_, a: Array, env):
	var v_a_829 = null; var v_b_830 = null
	v_a_829 = J.arg(a, 0)
	v_b_830 = J.arg(a, 1)
	var _t1510 = J.sub(J.seq(J.gp(v_b_830, 0.0), J.gp(env["this"], "sel")), J.seq(J.gp(v_a_829, 0.0), J.gp(env["this"], "sel")))
	if not J.t(_t1510):
		var _t1507 = J.gp(J.gp(v_b_830, 0.0), "bubAt")
		var _t1509 = (_t1507 if J.t(_t1507) else 0.0)
		var _t1508 = J.gp(J.gp(v_a_829, 0.0), "bubAt")
		_t1510 = J.sub(_t1509, (_t1508 if J.t(_t1508) else 0.0))
	return _t1510

func _f217(this_, a: Array, env):
	var v_q_831 = null
	v_q_831 = J.arg(a, 0)
	return J.gp(v_q_831, 0.0)

func _f205(this_, a: Array, env):
	var v_c_762 = null; var v_ctx_763 = null; var v_b_764 = null; var v_img_765 = null; var v_W_766 = null; var v_H_767 = null; var v_g_769 = null; var v_list_770 = null; var v_zs_772 = null; var v_sp_774 = null; var v_vg_775 = null; var v_f_776 = null; var v_gx_778 = null; var v_gy0_779 = null; var v_gy_780 = null; var v_ex_781 = null; var v_len_782 = null; var v_grd_783 = null; var v_f_784 = null; var v_x_785 = null; var v_y_786 = null; var v_hh_787 = null; var v_r_788 = null; var v_g_789 = null; var v_on_790 = null; var v_g_791 = null; var v_cx0_792 = null; var v_cy0_793 = null; var v_g2_794 = null; var v_z_801 = null; var v_f_802 = null; var v_p_803 = null; var v_px_804 = null; var v_py_805 = null; var v_f_806 = null; var v_f_807 = null; var v_x_808 = null; var v_y_809 = null; var v_hh_810 = null; var v_a_811 = null; var v_placed_812 = null; var v_k_818 = null; var v_o_819 = null; var v_m_822 = null; var v_x_823 = null; var v_by_824 = null; var v_nb_826 = null; var v_bs_827 = null; var v_n_832 = null; var v_x_833 = null; var v_by_834 = null; var v_bw_835 = null; var v_f_836 = null; var v_hk_837 = null; var v_shk_838 = null; var v_bh_839 = null; var v_mark_840 = null; var v_nw2_841 = null; var v_ex_842 = null; var v_ey_843 = null; var v_op_844 = null; var v_red_845 = null; var v_nw_846 = null; var v_a_847 = null; var v_b_848 = null; var v_tx_849 = null; var v_tw_850 = null; var v_pw_851 = null; var v_pr_852 = null; var v_fy_853 = null; var v_pop_854 = null; var v_ms_855 = null; var v_f_856 = null; var v_k_857 = null; var v_x_858 = null; var v_y_859 = null; var v_al_860 = null; var v_w_861 = null; var v_e_862 = null; var v_bx_863 = null; var v_by_864 = null; var v_bw_865 = null; var v_bh_866 = null; var v_q_867 = null
	var _s423 = {"__p": env, "this": null, "t": null, "OF": null, "tags": null, "sel": null}
	_s423["this"] = this_
	_s423["t"] = J.arg(a, 0)
	var _t1406 = J.G.get("$")
	v_c_762 = J.cl(_t1406, null, ["#sc-cvs"])
	if (not J.t(v_c_762)):
		return null
	v_ctx_763 = J.mc(v_c_762, "getContext", ["2d"])
	J.mc(v_ctx_763, "setTransform", [J.gp(_s423["this"], "dpr"), 0.0, 0.0, J.gp(_s423["this"], "dpr"), 0.0, 0.0])
	v_b_764 = J.mc(_s423["this"], "bgScale", [])
	v_img_765 = J.gp(J.G.get("SPR"), J.add("bg_", J.gp(J.gp(_s423["this"], "site"), "bg")))
	v_W_766 = J.gp(_s423["this"], "W")
	v_H_767 = J.gp(_s423["this"], "H")
	J.mc(v_ctx_763, "save", [])
	if J.cmp(J.gp(_s423["this"], "shake"), 0.0, ">"):
		J.mc(v_ctx_763, "translate", [J.mul(((randf() - 0.5) * 10.0), J.gp(_s423["this"], "shake")), J.mul(((randf() - 0.5) * 8.0), J.gp(_s423["this"], "shake"))])
	J.sp(v_ctx_763, "fillStyle", "#0d0b10")
	J.mc(v_ctx_763, "fillRect", [(-20.0), (-20.0), J.add(v_W_766, 40.0), J.add(v_H_767, 40.0)])
	_s423["OF"] = J.mc(_s423["this"], "office", [])
	if J.t(_s423["OF"]):
		J.mc(J.G.get("OFFICE"), "drawBack", [v_ctx_763, _s423["t"]])
	else:
		if J.t((J.gp(v_img_765, "complete") if J.t(v_img_765) else v_img_765)):
			J.mc(v_ctx_763, "drawImage", [v_img_765, J.gp(v_b_764, "ox"), J.gp(v_b_764, "oy"), J.mul(J.gp(v_b_764, "iw"), J.gp(v_b_764, "s")), J.mul(J.gp(v_b_764, "ih"), J.gp(v_b_764, "s"))])
	var _t1407 = ("rgba(12,10,34," + J.str(((0.12 if J.t(_s423["OF"]) else 0.22) + (0.1 * sin(J.num((J.div(J.gp(_s423["this"], "t"), J.G.get("NIGHT_SEC")) * PI)))))) + ")")
	J.sp(v_ctx_763, "fillStyle", _t1407)
	J.mc(v_ctx_763, "fillRect", [0.0, 0.0, v_W_766, v_H_767])
	if J.t(_s423["OF"]):
		for _t1408 in J.iter(J.gp(_s423["this"], "fx")):
			v_f_776 = _t1408
			var _t1409 = J.seq(J.gp(v_f_776, "kind"), "ghost")
			if (J.seq(J.gp(v_f_776, "ghost"), "pontianak") if _t1409 else _t1409):
				J.mc(v_ctx_763, "save", [])
				J.mc(J.G.get("OFFICE"), "clipWindow", [v_ctx_763])
				J.mc(_s423["this"], "drawGhost", [v_ctx_763, v_f_776, _s423["t"]])
				J.mc(v_ctx_763, "restore", [])
	if J.t(_s423["OF"]):
		J.mc(J.G.get("OFFICE"), "drawFloor", [v_ctx_763, _s423["t"]])
	if (not J.t(_s423["OF"])):
		J.mc(_s423["this"], "propMarks", [v_ctx_763, _s423["t"]])
	var _t1410 = J.gp(_s423["this"], "npcs")
	v_g_769 = J.mc(_t1410, "find", [Callable(self, "_f206").bind(_s423)])
	if J.t(v_g_769):
		var _t1414 = J.mc(_s423["this"], "pt", [J.gp(v_g_769, "x"), J.gp(v_g_769, "y")])
		var _t1415 = J.gp(_t1414, 0.0)
		v_gx_778 = _t1415
		var _t1416 = J.gp(_t1414, 1.0)
		v_gy0_779 = _t1416
		v_gy_780 = (J.sub(v_gy0_779, J.mul(J.mc(_s423["this"], "hh", [J.gp(v_g_769, "y")]), 0.5)) if J.t(J.mc(_s423["this"], "persp", [])) else J.gp(J.mc(_s423["this"], "pt", [J.gp(v_g_769, "x"), J.sub(J.gp(v_g_769, "y"), 0.08)]), 1.0))
		var _t1417 = J.mc(_s423["this"], "pt", [J.add(J.gp(v_g_769, "x"), J.mul(J.gp(v_g_769, "dir"), 0.4)), 0.0])
		var _t1418 = J.gp(_t1417, 0.0)
		v_ex_781 = _t1418
		v_len_782 = absf(J.num(J.sub(v_ex_781, v_gx_778)))
		v_grd_783 = J.mc(v_ctx_763, "createLinearGradient", [v_gx_778, 0.0, v_ex_781, 0.0])
		J.mc(v_grd_783, "addColorStop", [0.0, "rgba(255,240,170,.42)"])
		J.mc(v_grd_783, "addColorStop", [1.0, "rgba(255,240,170,0)"])
		J.sp(v_ctx_763, "fillStyle", v_grd_783)
		J.mc(v_ctx_763, "beginPath", [])
		J.mc(v_ctx_763, "moveTo", [v_gx_778, v_gy_780])
		J.mc(v_ctx_763, "lineTo", [v_ex_781, (J.sub(v_gy_780, J.mul(v_len_782, 0.35)) - 8.0)])
		J.mc(v_ctx_763, "lineTo", [v_ex_781, J.add(J.add(v_gy_780, J.mul(v_len_782, 0.35)), 8.0)])
		J.mc(v_ctx_763, "closePath", [])
		J.mc(v_ctx_763, "fill", [])
	for _t1419 in J.iter(J.gp(_s423["this"], "fx")):
		v_f_784 = _t1419
		var _t1420 = J.seq(J.gp(v_f_784, "kind"), "ac")
		var _t1421 = ((not J.t(J.gp(v_f_784, "n"))) if _t1420 else _t1420)
		if ((not J.t(J.gp(J.gp(_s423["this"], "site"), "pano"))) if _t1421 else _t1421):
			var _t1422 = ("rgba(150,200,255," + J.str(J.div(J.mul(0.16, J.gp(v_f_784, "life")), 2.2)) + ")")
			J.sp(v_ctx_763, "fillStyle", _t1422)
			J.mc(v_ctx_763, "fillRect", [0.0, 0.0, v_W_766, v_H_767])
		var _t1423 = J.seq(J.gp(v_f_784, "kind"), "lamp")
		var _t1424 = (_t1423 if _t1423 else J.seq(J.gp(v_f_784, "kind"), "lights"))
		var _t1425 = (_t1424 if _t1424 else J.seq(J.gp(v_f_784, "kind"), "ac"))
		var _t1426 = (J.gp(v_f_784, "n") if _t1425 else _t1425)
		if J.t(((not J.t(J.gp(J.gp(v_f_784, "n"), "gone"))) if J.t(_t1426) else _t1426)):
			var _t1427 = J.mc(_s423["this"], "pt", [J.gp(J.gp(v_f_784, "n"), "x"), J.gp(J.gp(v_f_784, "n"), "y")])
			var _t1428 = J.gp(_t1427, 0.0)
			v_x_785 = _t1428
			var _t1429 = J.gp(_t1427, 1.0)
			v_y_786 = _t1429
			v_hh_787 = J.mc(_s423["this"], "hh", [J.gp(J.gp(v_f_784, "n"), "y")])
			v_r_788 = J.mul(v_hh_787, 0.9)
			if J.seq(J.gp(v_f_784, "kind"), "ac"):
				v_g_789 = J.mc(v_ctx_763, "createRadialGradient", [v_x_785, J.sub(v_y_786, J.mul(v_hh_787, 0.6)), 0.0, v_x_785, J.sub(v_y_786, J.mul(v_hh_787, 0.6)), v_r_788])
				J.mc(v_g_789, "addColorStop", [0.0, ("rgba(170,215,255," + J.str(J.div(J.mul(0.32, J.gp(v_f_784, "life")), 2.2)) + ")")])
				J.mc(v_g_789, "addColorStop", [1.0, "rgba(170,215,255,0)"])
				J.sp(v_ctx_763, "fillStyle", v_g_789)
				J.mc(v_ctx_763, "fillRect", [J.sub(v_x_785, v_r_788), J.sub(J.sub(v_y_786, J.mul(v_hh_787, 0.6)), v_r_788), J.mul(v_r_788, 2.0), J.mul(v_r_788, 2.0)])
			else:
				v_on_790 = ((sin(J.num(J.mul(_s423["t"], 38.0))) + sin(J.num(J.mul(_s423["t"], 17.0)))) > 0.4)
				v_g_791 = J.mc(v_ctx_763, "createRadialGradient", [v_x_785, J.sub(v_y_786, J.mul(v_hh_787, 0.5)), 0.0, v_x_785, J.sub(v_y_786, J.mul(v_hh_787, 0.5)), J.mul(v_r_788, 1.1)])
				J.mc(v_g_791, "addColorStop", [0.0, ("rgba(255,245,200,.22)" if J.t(v_on_790) else "rgba(0,0,0,.55)")])
				J.mc(v_g_791, "addColorStop", [1.0, "rgba(0,0,0,0)"])
				J.sp(v_ctx_763, "fillStyle", v_g_791)
				J.mc(v_ctx_763, "fillRect", [J.sub(v_x_785, J.mul(v_r_788, 1.1)), (J.sub(v_y_786, J.mul(v_hh_787, 0.5)) - J.mul(v_r_788, 1.1)), J.mul(v_r_788, 2.2), J.mul(v_r_788, 2.2)])
				if J.seq(J.gp(v_f_784, "kind"), "lights"):
					var _t1430 = J.mc(_s423["this"], "pt", [J.gp(J.gp(v_f_784, "n"), "x"), 0.17])
					var _t1431 = J.gp(_t1430, 0.0)
					v_cx0_792 = _t1431
					var _t1432 = J.gp(_t1430, 1.0)
					v_cy0_793 = _t1432
					var _t1433 = ("rgba(255,250,215,.9)" if J.t(v_on_790) else "rgba(90,90,110,.6)")
					J.sp(v_ctx_763, "strokeStyle", _t1433)
					J.sp(v_ctx_763, "lineWidth", 4.0)
					J.mc(v_ctx_763, "beginPath", [])
					J.mc(v_ctx_763, "moveTo", [J.sub(v_cx0_792, J.mul(v_hh_787, 0.3)), v_cy0_793])
					J.mc(v_ctx_763, "lineTo", [J.add(v_cx0_792, J.mul(v_hh_787, 0.3)), v_cy0_793])
					J.mc(v_ctx_763, "stroke", [])
					if J.t(v_on_790):
						v_g2_794 = J.mc(v_ctx_763, "createLinearGradient", [0.0, v_cy0_793, 0.0, v_y_786])
						J.mc(v_g2_794, "addColorStop", [0.0, "rgba(255,250,215,.18)"])
						J.mc(v_g2_794, "addColorStop", [1.0, "rgba(255,250,215,0)"])
						J.sp(v_ctx_763, "fillStyle", v_g2_794)
						J.mc(v_ctx_763, "beginPath", [])
						J.mc(v_ctx_763, "moveTo", [J.sub(v_cx0_792, J.mul(v_hh_787, 0.3)), v_cy0_793])
						J.mc(v_ctx_763, "lineTo", [J.add(v_cx0_792, J.mul(v_hh_787, 0.3)), v_cy0_793])
						J.mc(v_ctx_763, "lineTo", [J.add(v_x_785, J.mul(v_hh_787, 0.5)), v_y_786])
						J.mc(v_ctx_763, "lineTo", [J.sub(v_x_785, J.mul(v_hh_787, 0.5)), v_y_786])
						J.mc(v_ctx_763, "closePath", [])
						J.mc(v_ctx_763, "fill", [])
	J.mc(_s423["this"], "drawTeam", [v_ctx_763, _s423["t"]])
	var _t1434 = J.gp(_s423["this"], "npcs")
	v_list_770 = J.mc(_t1434, "filter", [Callable(self, "_f207").bind(_s423)])
	_s423["tags"] = []
	v_zs_772 = J.mc(v_list_770, "map", [Callable(self, "_f208").bind(_s423)])
	if J.t(_s423["OF"]):
		J.mc(v_zs_772, "push", J.spread([J.SP(J.mc(J.G.get("OFFICE"), "drawables", [_s423["t"]]))]))
		if J.t(J.gp(J.gp(_s423["this"], "site"), "pano")):
			J.mc(v_zs_772, "push", J.spread([J.SP(J.mc(J.G.get("OFFMAP"), "drawables", []))]))
	J.mc(v_zs_772, "sort", [Callable(self, "_f210").bind(_s423)])
	for _t1448 in J.iter(v_zs_772):
		v_z_801 = _t1448
		J.mc(v_z_801, 1.0, [v_ctx_763])
	if J.t(_s423["OF"]):
		J.mc(J.G.get("OFFICE"), "drawDark", [v_ctx_763, _s423["t"]])
		if J.t(J.gp(J.gp(_s423["this"], "site"), "pano")):
			J.mc(J.G.get("OFFMAP"), "drawOver", [v_ctx_763, _s423["t"]])
		J.mc(_s423["this"], "propMarks", [v_ctx_763, _s423["t"]])
	if (not J.seq(J.typeof_(J.G.get("ScareX")), "undefined")):
		J.mc(J.G.get("ScareX"), "draw", [_s423["this"], v_ctx_763, _s423["t"]])
	for _t1449 in J.iter(J.gp(_s423["this"], "fx")):
		v_f_802 = _t1449
		var _t1450 = J.seq(J.gp(v_f_802, "kind"), "ghost")
		if ((not J.t((J.seq(J.gp(v_f_802, "ghost"), "pontianak") if J.t(_s423["OF"]) else _s423["OF"]))) if _t1450 else _t1450):
			J.mc(_s423["this"], "drawGhost", [v_ctx_763, v_f_802, _s423["t"]])
	for _t1451 in J.iter(J.gp(_s423["this"], "parts")):
		v_p_803 = _t1451
		if J.cmp(J.gp(v_p_803, "delay"), 0.0, ">"):
			continue
		var _t1452 = J.mc(_s423["this"], "pt", [J.gp(v_p_803, "x"), J.gp(v_p_803, "y")])
		var _t1453 = J.gp(_t1452, 0.0)
		v_px_804 = _t1453
		var _t1454 = J.gp(_t1452, 1.0)
		v_py_805 = _t1454
		if J.seq(J.gp(v_p_803, "kind"), "paper"):
			J.mc(v_ctx_763, "save", [])
			J.mc(v_ctx_763, "translate", [v_px_804, v_py_805])
			J.mc(v_ctx_763, "rotate", [J.gp(v_p_803, "rot")])
			J.sp(v_ctx_763, "fillStyle", "#f4f0e6")
			J.sp(v_ctx_763, "strokeStyle", "#555")
			J.sp(v_ctx_763, "lineWidth", 0.8)
			J.mc(v_ctx_763, "fillRect", [(-7.0), (-9.0), 14.0, 18.0])
			J.mc(v_ctx_763, "strokeRect", [(-7.0), (-9.0), 14.0, 18.0])
			J.sp(v_ctx_763, "fillStyle", "#b44")
			J.mc(v_ctx_763, "fillRect", [(-4.0), (-5.0), 8.0, 1.5])
			J.mc(v_ctx_763, "restore", [])
		if J.seq(J.gp(v_p_803, "kind"), "frost"):
			var _t1455 = ("rgba(220,240,255," + J.str(J.min_([1.0, J.gp(v_p_803, "life")])) + ")")
			J.sp(v_ctx_763, "fillStyle", _t1455)
			J.mc(v_ctx_763, "beginPath", [])
			J.mc(v_ctx_763, "arc", [v_px_804, v_py_805, 2.2, 0.0, (PI * 2.0)])
			J.mc(v_ctx_763, "fill", [])
		if J.seq(J.gp(v_p_803, "kind"), "bubble"):
			var _t1456 = ("rgba(190,230,255," + J.str(J.min_([1.0, J.gp(v_p_803, "life")])) + ")")
			J.sp(v_ctx_763, "strokeStyle", _t1456)
			J.sp(v_ctx_763, "lineWidth", 1.2)
			J.mc(v_ctx_763, "beginPath", [])
			J.mc(v_ctx_763, "arc", [v_px_804, v_py_805, 3.0, 0.0, (PI * 2.0)])
			J.mc(v_ctx_763, "stroke", [])
		if J.seq(J.gp(v_p_803, "kind"), "sweat"):
			J.sp(v_ctx_763, "fillStyle", "rgba(150,210,255,.9)")
			J.mc(v_ctx_763, "beginPath", [])
			J.mc(v_ctx_763, "ellipse", [v_px_804, v_py_805, 2.5, 4.0, 0.0, 0.0, (PI * 2.0)])
			J.mc(v_ctx_763, "fill", [])
		if J.seq(J.gp(v_p_803, "kind"), "dust"):
			var _t1457 = ("rgba(200,190,170," + J.str(J.gp(v_p_803, "life")) + ")")
			J.sp(v_ctx_763, "fillStyle", _t1457)
			J.mc(v_ctx_763, "beginPath", [])
			J.mc(v_ctx_763, "arc", [v_px_804, v_py_805, (6.0 * J.sub(1.2, J.gp(v_p_803, "life"))), 0.0, (PI * 2.0)])
			J.mc(v_ctx_763, "fill", [])
		if J.seq(J.gp(v_p_803, "kind"), "drop"):
			var _t1458 = ("rgba(170,210,230," + J.str(J.mul(J.gp(v_p_803, "life"), 0.4)) + ")")
			J.sp(v_ctx_763, "fillStyle", _t1458)
			J.mc(v_ctx_763, "beginPath", [])
			J.mc(v_ctx_763, "ellipse", [v_px_804, v_py_805, 9.0, 3.0, 0.0, 0.0, (PI * 2.0)])
			J.mc(v_ctx_763, "fill", [])
	for _t1459 in J.iter(J.gp(_s423["this"], "fx")):
		v_f_806 = _t1459
		var _t1460 = J.seq(J.gp(v_f_806, "kind"), "breath")
		if ((not J.t(J.gp(J.gp(v_f_806, "n"), "gone"))) if _t1460 else _t1460):
			J.mc(_s423["this"], "drawBreath", [v_ctx_763, v_f_806, _s423["t"]])
	for _t1461 in J.iter(J.gp(_s423["this"], "fx")):
		v_f_807 = _t1461
		var _t1462 = J.seq(J.gp(v_f_807, "kind"), "phone")
		if ((not J.t(J.gp(J.gp(v_f_807, "n"), "gone"))) if _t1462 else _t1462):
			var _t1463 = J.mc(_s423["this"], "pt", [(J.gp(J.gp(v_f_807, "n"), "vX") if (not J.leq(J.gp(J.gp(v_f_807, "n"), "vX"), null)) else J.gp(J.gp(v_f_807, "n"), "x")), (J.gp(J.gp(v_f_807, "n"), "vY") if (not J.leq(J.gp(J.gp(v_f_807, "n"), "vY"), null)) else J.gp(J.gp(v_f_807, "n"), "y"))])
			var _t1464 = J.gp(_t1463, 0.0)
			v_x_808 = _t1464
			var _t1465 = J.gp(_t1463, 1.0)
			v_y_809 = _t1465
			var _t1467 = J.mc(_s423["this"], "hh", [J.gp(J.gp(v_f_807, "n"), "y")])
			var _t1466 = J.mc(_s423["this"], "office", [])
			v_hh_810 = J.mul(_t1467, (0.8 if J.t((J.mc(J.G.get("OFFICE"), "seated", [J.gp(v_f_807, "n")]) if J.t(_t1466) else _t1466)) else 1.0))
			v_a_811 = (0.5 + (0.5 * sin(J.num(J.mul(_s423["t"], 20.0)))))
			var _t1468 = ("rgba(120,255,170," + J.str(J.mul(0.35, v_a_811)) + ")")
			J.sp(v_ctx_763, "fillStyle", _t1468)
			J.mc(v_ctx_763, "beginPath", [])
			J.mc(v_ctx_763, "arc", [J.add(v_x_808, (J.mul(J.gp(J.gp(v_f_807, "n"), "dir"), v_hh_810) * 0.05)), J.sub(v_y_809, J.mul(v_hh_810, 0.62)), J.mul(v_hh_810, 0.18), 0.0, (PI * 2.0)])
			J.mc(v_ctx_763, "fill", [])
	v_placed_812 = []
	var _t1470 = J.mc(_s423["tags"], "slice", [])
	for _t1469 in J.iter(J.mc(_t1470, "sort", [Callable(self, "_f211").bind(_s423)])):
		var _s456 = {"__p": _s423, "q": null}
		_s456["q"] = _t1469
		var _s458 = {"__p": _s456, "ext": null, "y": null}
		if J.t(J.gp(J.gp(_s458["__p"]["q"], 0.0), "out")):
			continue
		var _t1471 = _s458["__p"]["q"]
		var _t1472 = J.gp(_s458["__p"]["__p"]["this"], "W")
		var _t1473 = J.gp(_s458["__p"]["__p"]["this"], "W")
		var _t1474 = J.gp(_s458["__p"]["__p"]["this"], "W")
		var _t1475 = J.gp(_s458["__p"]["__p"]["this"], "W")
		var _t1476 = J.max_([56.0, J.min_([J.sub((_t1475 if J.t(_t1475) else 390.0), 58.0), J.gp(_s458["__p"]["q"], 1.0)])])
		J.sp(_t1471, 1.0, _t1476)
		_s458["ext"] = J.mc(_s458["__p"]["__p"]["this"], "tagExt", [J.gp(_s458["__p"]["q"], 0.0)])
		_s458["y"] = J.gp(_s458["__p"]["q"], 2.0)
		v_k_818 = 0.0
		while true:
			if not J.cmp(v_k_818, 8.0, "<"): break
			v_o_819 = J.mc(v_placed_812, "find", [Callable(self, "_f212").bind(_s458)])
			if (not J.t(v_o_819)):
				break
			var _t1479 = ((J.sub(J.sub(J.gp(v_o_819, 1.0), 20.0), J.gp(v_o_819, 3.0)) - 9.0) - 2.0)
			_s458["y"] = _t1479
			v_k_818 = J.num(v_k_818) + 1.0
		var _t1480 = _s458["__p"]["q"]
		var _t1481 = _s458["y"]
		J.sp(_t1480, 2.0, _t1481)
		J.mc(v_placed_812, "push", [[J.gp(_s458["__p"]["q"], 1.0), _s458["y"], 8.0, _s458["ext"]]])
	var _t1482 = _s423["this"]
	J.sp(_t1482, "_tagR", v_placed_812)
	var _t1483 = J.gp(_s423["this"], "sel")
	var _t1484 = ((not J.t(J.gp(J.gp(_s423["this"], "sel"), "gone"))) if J.t(_t1483) else _t1483)
	var _t1485 = ((not J.t(J.gp(J.gp(_s423["this"], "sel"), "out"))) if J.t(_t1484) else _t1484)
	var _t1486 = ((not J.t(J.gp(J.gp(_s423["this"], "sel"), "fleeing"))) if J.t(_t1485) else _t1485)
	_s423["sel"] = (J.gp(_s423["this"], "sel") if J.t(((not J.t(J.gp(J.gp(J.gp(_s423["this"], "sel"), "d"), "guard"))) if J.t(_t1486) else _t1486)) else null)
	v_sp_774 = (J.mc(_s423["tags"], "find", [Callable(self, "_f213").bind(_s423)]) if J.t(_s423["sel"]) else _s423["sel"])
	if J.t(v_sp_774):
		J.mc(v_ctx_763, "save", [])
		J.mc(v_ctx_763, "setLineDash", [[6.0, 5.0]])
		var _t1487 = ((-J.num(_s423["t"])) * 20.0)
		J.sp(v_ctx_763, "lineDashOffset", _t1487)
		J.sp(v_ctx_763, "lineWidth", 2.0)
		J.sp(v_ctx_763, "strokeStyle", "rgba(255,90,80,.75)")
		for _t1488 in J.iter(_s423["tags"]):
			var _t1489 = J.gp(_t1488, 0.0)
			v_m_822 = _t1489
			var _t1490 = J.gp(_t1488, 1.0)
			v_x_823 = _t1490
			var _t1491 = J.gp(_t1488, 2.0)
			v_by_824 = _t1491
			var _t1492 = (not J.seq(v_m_822, _s423["sel"]))
			var _t1493 = ((not J.t(J.gp(v_m_822, "out"))) if _t1492 else _t1492)
			if J.t((J.mc(_s423["this"], "sees", [v_m_822, _s423["sel"]]) if _t1493 else _t1493)):
				J.mc(v_ctx_763, "beginPath", [])
				J.mc(v_ctx_763, "moveTo", [v_x_823, J.add(v_by_824, 6.0)])
				J.mc(v_ctx_763, "lineTo", [J.gp(v_sp_774, 1.0), J.sub(J.gp(v_sp_774, 2.0), 4.0)])
				J.mc(v_ctx_763, "stroke", [])
		J.mc(v_ctx_763, "restore", [])
	var _t1494 = _s423["this"]
	var _t1495 = J.gp(_s423["this"], "_bubR")
	var _t1496 = (_t1495 if J.t(_t1495) else [])
	var _t1497 = J.gp(_s423["this"], "_nTag")
	var _t1498 = J.mc(_t1496, "slice", [(_t1497 if J.t(_t1497) else 0.0)])
	J.sp(_t1494, "_bubLast", _t1498)
	var _t1499 = _s423["this"]
	var _t1500 = J.gp(_s423["this"], "_tagR")
	var _t1501 = (_t1500 if J.t(_t1500) else [])
	var _t1502 = J.mc(_t1501, "map", [Callable(self, "_f214").bind(_s423)])
	J.sp(_t1499, "_bubR", _t1502)
	var _t1503 = _s423["this"]
	var _t1504 = J.len(J.gp(_s423["this"], "_bubR"))
	J.sp(_t1503, "_nTag", _t1504)
	v_nb_826 = 0.0
	var _t1506 = J.mc(_s423["tags"], "filter", [Callable(self, "_f215").bind(_s423)])
	v_bs_827 = J.mc(_t1506, "sort", [Callable(self, "_f216").bind(_s423)])
	var _t1511 = _s423["this"]
	var _t1512 = J.mc(v_bs_827, "slice", [0.0, 2.0])
	var _t1513 = J.new_("Set", [J.mc(_t1512, "map", [Callable(self, "_f217").bind(_s423)])])
	J.sp(_t1511, "_bubOK", _t1513)
	for _t1514 in J.iter(_s423["tags"]):
		var _t1515 = J.gp(_t1514, 0.0)
		v_n_832 = _t1515
		var _t1516 = J.gp(_t1514, 1.0)
		v_x_833 = _t1516
		var _t1517 = J.gp(_t1514, 2.0)
		v_by_834 = _t1517
		if J.t(J.gp(v_n_832, "out")):
			continue
		J.sp(v_ctx_763, "font", "700 11px sans-serif")
		v_nw2_841 = J.div(J.gp(J.mc(v_ctx_763, "measureText", [J.gp(J.gp(v_n_832, "d"), "name")]), "width"), 2.0)
		v_ex_842 = (J.sub(v_x_833, v_nw2_841) - 12.0)
		v_ey_843 = J.sub(v_by_834, 10.0)
		v_op_844 = J.mc(_s423["this"], "watching", [v_n_832])
		var _t1518 = ((not J.seq(v_n_832, _s423["sel"])) if J.t(_s423["sel"]) else _s423["sel"])
		v_red_845 = (J.mc(_s423["this"], "sees", [v_n_832, _s423["sel"]]) if J.t(_t1518) else _t1518)
		J.mc(v_ctx_763, "save", [])
		J.sp(v_ctx_763, "fillStyle", "rgba(0,0,0,.6)")
		J.mc(v_ctx_763, "beginPath", [])
		J.mc(v_ctx_763, "arc", [v_ex_842, v_ey_843, 7.5, 0.0, (PI * 2.0)])
		J.mc(v_ctx_763, "fill", [])
		J.sp(v_ctx_763, "lineWidth", 1.6)
		if J.t(v_op_844):
			var _t1519 = ("#ff6a5a" if J.t(v_red_845) else "#f2f2f2")
			J.sp(v_ctx_763, "fillStyle", _t1519)
			J.mc(v_ctx_763, "beginPath", [])
			J.mc(v_ctx_763, "ellipse", [v_ex_842, v_ey_843, 5.5, 3.5, 0.0, 0.0, (PI * 2.0)])
			J.mc(v_ctx_763, "fill", [])
			J.sp(v_ctx_763, "fillStyle", "#111")
			J.mc(v_ctx_763, "beginPath", [])
			var _t1520 = J.gp(v_n_832, "dir")
			J.mc(v_ctx_763, "arc", [J.add(v_ex_842, J.mul((_t1520 if J.t(_t1520) else 1.0), 1.2)), v_ey_843, 2.0, 0.0, (PI * 2.0)])
			J.mc(v_ctx_763, "fill", [])
		else:
			J.sp(v_ctx_763, "strokeStyle", "#9aa")
			J.mc(v_ctx_763, "beginPath", [])
			J.mc(v_ctx_763, "arc", [v_ex_842, J.sub(v_ey_843, 2.0), 4.5, (0.25 * PI), (0.75 * PI)])
			J.mc(v_ctx_763, "stroke", [])
		J.mc(v_ctx_763, "restore", [])
		var _t1521 = J.gp(v_n_832, "step")
		if J.t((J.gp(J.gp(v_n_832, "step"), "cue") if J.t(_t1521) else _t1521)):
			J.mc(_s423["this"], "drawCue", [v_ctx_763, v_n_832, v_x_833, v_by_834, _s423["t"]])
		v_bw_835 = 60.0
		v_f_836 = J.min_([1.0, J.div(J.gp(v_n_832, "fear"), 100.0)])
		var _t1522 = J.gp(v_n_832, "barHit")
		var _t1523 = J.gp(v_n_832, "barHit")
		v_hk_837 = J.max_([0.0, (_t1523 if J.t(_t1523) else 0.0)])
		v_shk_838 = J.cmp(J.gp(v_n_832, "shaken"), 0.0, ">")
		v_bh_839 = (6.0 + J.mul(v_hk_837, 3.0))
		J.sp(v_ctx_763, "fillStyle", "rgba(0,0,0,.65)")
		J.mc(v_ctx_763, "fillRect", [(J.sub(v_x_833, J.div(v_bw_835, 2.0)) - 2.0), (J.sub(v_by_834, 3.0) - J.mul(v_hk_837, 1.5)), J.add(v_bw_835, 4.0), J.add(v_bh_839, 4.0)])
		if J.t(v_shk_838):
			var _t1524 = ("rgba(255,90,80," + J.str((0.45 + (0.4 * sin(J.num(J.mul(_s423["t"], 7.0)))))) + ")")
			J.sp(v_ctx_763, "strokeStyle", _t1524)
			J.sp(v_ctx_763, "lineWidth", 1.6)
			J.mc(v_ctx_763, "strokeRect", [(J.sub(v_x_833, J.div(v_bw_835, 2.0)) - 2.5), (J.sub(v_by_834, 3.5) - J.mul(v_hk_837, 1.5)), J.add(v_bw_835, 5.0), J.add(v_bh_839, 5.0)])
		var _t1525 = ("#ff5a4a" if J.cmp(v_f_836, 0.5, ">=") else ("#ffb84a" if J.cmp(v_f_836, 0.25, ">=") else "#9be8b0"))
		J.sp(v_ctx_763, "fillStyle", _t1525)
		J.mc(v_ctx_763, "fillRect", [J.sub(v_x_833, J.div(v_bw_835, 2.0)), (J.sub(v_by_834, 1.0) - J.mul(v_hk_837, 1.5)), J.mul(v_bw_835, v_f_836), v_bh_839])
		if J.cmp(v_hk_837, 0.0, ">"):
			var _t1526 = ("rgba(255,255,255," + J.str(J.mul(v_hk_837, 0.75)) + ")")
			J.sp(v_ctx_763, "fillStyle", _t1526)
			J.mc(v_ctx_763, "fillRect", [J.sub(v_x_833, J.div(v_bw_835, 2.0)), (J.sub(v_by_834, 1.0) - J.mul(v_hk_837, 1.5)), J.mul(v_bw_835, v_f_836), v_bh_839])
		J.sp(v_ctx_763, "fillStyle", "rgba(255,255,255,.4)")
		J.mc(v_ctx_763, "fillRect", [(J.sub(v_x_833, J.div(v_bw_835, 2.0)) + J.mul(v_bw_835, 0.25)), J.sub(v_by_834, 2.0), 1.0, J.add(v_bh_839, 2.0)])
		J.mc(v_ctx_763, "fillRect", [(J.sub(v_x_833, J.div(v_bw_835, 2.0)) + J.mul(v_bw_835, 0.5)), J.sub(v_by_834, 2.0), 1.0, J.add(v_bh_839, 2.0)])
		J.sp(v_ctx_763, "font", "700 11px sans-serif")
		J.sp(v_ctx_763, "textAlign", "center")
		J.sp(v_ctx_763, "lineWidth", 3.0)
		J.sp(v_ctx_763, "strokeStyle", "rgba(0,0,0,.8)")
		J.mc(v_ctx_763, "strokeText", [J.gp(J.gp(v_n_832, "d"), "name"), v_x_833, J.sub(v_by_834, 6.0)])
		var _t1527 = ("#a8ffcf" if J.seq(v_n_832, J.gp(_s423["this"], "sel")) else "#eee")
		J.sp(v_ctx_763, "fillStyle", _t1527)
		J.mc(v_ctx_763, "fillText", [J.gp(J.gp(v_n_832, "d"), "name"), v_x_833, J.sub(v_by_834, 6.0)])
		var _t1529 = J.seq(v_n_832, _s423["sel"])
		if not J.t(_t1529):
			var _t1528 = J.cmp(J.gp(v_n_832, "mocked"), 0.0, ">")
			_t1529 = ((not J.t(J.gp(J.gp(v_n_832, "d"), "guard"))) if _t1528 else _t1528)
		if _t1529:
			v_nw_846 = (J.len(J.mc(_s423["this"], "witnesses", [v_n_832])) if J.seq(v_n_832, _s423["sel"]) else (-1.0))
			v_a_847 = ("" if J.cmp(v_nw_846, 0.0, "<") else ((J.str(v_nw_846) + "人望緊") if J.t(v_nw_846) else "冇人望緊"))
			v_b_848 = (("冇人信×" + J.str(J.min_([4.0, J.gp(v_n_832, "mocked")]))) if J.cmp(J.gp(v_n_832, "mocked"), 0.0, ">") else "")
			J.sp(v_ctx_763, "font", "800 11px sans-serif")
			var _t1530 = [v_a_847, v_b_848]
			var _t1531 = J.mc(_t1530, "filter", [J.G.get("Boolean")])
			v_tx_849 = J.mc(_t1531, "join", ["・"])
			v_tw_850 = J.gp(J.mc(v_ctx_763, "measureText", [v_tx_849]), "width")
			J.sp(v_ctx_763, "fillStyle", "rgba(10,8,18,.72)")
			J.mc(v_ctx_763, "beginPath", [])
			J.mc(v_ctx_763, "roundRect", [(J.sub(v_x_833, J.div(v_tw_850, 2.0)) - 6.0), J.sub(v_by_834, 33.0), J.add(v_tw_850, 12.0), 15.0, 7.5])
			J.mc(v_ctx_763, "fill", [])
			var _t1532 = ("#ff8a7a" if J.cmp(v_nw_846, 0.0, ">") else ("#d6a0ff" if J.t((J.cmp(v_nw_846, 0.0, "<") if J.t(v_b_848) else v_b_848)) else "#8fe8b0"))
			J.sp(v_ctx_763, "fillStyle", _t1532)
			J.mc(v_ctx_763, "fillText", [v_tx_849, v_x_833, J.sub(v_by_834, 21.5)])
		var _t1533 = J.gp(J.gp(v_n_832, "d"), "daoshi")
		if J.t((J.seq(J.gp(v_n_832, "ds"), "ritual") if J.t(_t1533) else _t1533)):
			v_pw_851 = 110.0
			var _t1534 = J.gp(v_n_832, "prog")
			var _t1535 = J.gp(v_n_832, "prog")
			v_pr_852 = J.min_([1.0, (_t1535 if J.t(_t1535) else 0.0)])
			v_fy_853 = J.add(J.gp(J.mc(_s423["this"], "pt", [J.gp(v_n_832, "x"), J.gp(v_n_832, "y")]), 1.0), 10.0)
			J.mc(v_ctx_763, "save", [])
			J.sp(v_ctx_763, "fillStyle", "rgba(0,0,0,.72)")
			J.mc(v_ctx_763, "fillRect", [(J.sub(v_x_833, J.div(v_pw_851, 2.0)) - 3.0), v_fy_853, J.add(v_pw_851, 6.0), 26.0])
			J.sp(v_ctx_763, "fillStyle", "#4a3a10")
			J.mc(v_ctx_763, "fillRect", [J.sub(v_x_833, J.div(v_pw_851, 2.0)), J.add(v_fy_853, 16.0), v_pw_851, 6.0])
			J.sp(v_ctx_763, "fillStyle", "#ffd36a")
			J.mc(v_ctx_763, "fillRect", [J.sub(v_x_833, J.div(v_pw_851, 2.0)), J.add(v_fy_853, 16.0), J.mul(v_pw_851, v_pr_852), 6.0])
			J.sp(v_ctx_763, "font", "800 11px sans-serif")
			J.sp(v_ctx_763, "textAlign", "center")
			J.sp(v_ctx_763, "fillStyle", "#ffe9a8")
			var _t1538 = J.round(J.num(J.mul(v_pr_852, 100.0)))
			var _t1537 = null
			if J.cmp(J.gp(v_n_832, "fear"), 50.0, ">="):
				_t1537 = "・嚇親停咗"
			else:
				var _t1536 = J.gp(_s423["this"], "expo")
				_t1537 = ("・冇動靜慢咗" if J.cmp((_t1536 if J.t(_t1536) else 0.0), 25.0, "<") else "")
			J.mc(v_ctx_763, "fillText", [("做法中 " + J.str(_t1538) + "%" + _t1537), v_x_833, J.add(v_fy_853, 12.0)])
			J.mc(v_ctx_763, "restore", [])
		v_mark_840 = ("!!!" if J.t(J.gp(v_n_832, "fleeing")) else ("！" if J.cmp(J.gp(v_n_832, "fear"), 50.0, ">=") else ("？" if J.cmp(J.gp(v_n_832, "fear"), 25.0, ">=") else "")))
		if J.t(v_mark_840):
			var _t1539 = J.gp(v_n_832, "markPop")
			var _t1540 = J.gp(v_n_832, "markPop")
			v_pop_854 = J.max_([0.0, (_t1540 if J.t(_t1540) else 0.0)])
			v_ms_855 = (1.0 + J.mul(v_pop_854, 0.8))
			J.sp(v_ctx_763, "font", "700 11px sans-serif")
			J.mc(v_ctx_763, "save", [])
			J.mc(v_ctx_763, "translate", [J.add(J.add(v_x_833, J.div(J.gp(J.mc(v_ctx_763, "measureText", [J.gp(J.gp(v_n_832, "d"), "name")]), "width"), 2.0)), (16.0 if (J.len(v_mark_840) > 1.0) else 10.0)), (J.sub(v_by_834, 3.0) - (absf(J.num(sin(J.num(J.mul(_s423["t"], 6.0))))) * 2.0))])
			var _t1541 = ("900 " + J.str((19.0 if J.cmp(J.gp(v_n_832, "fear"), 50.0, ">=") else 16.0)) + "px sans-serif")
			J.sp(v_ctx_763, "font", _t1541)
			J.sp(v_ctx_763, "textAlign", "center")
			var _t1542 = ("#ff6a5a" if J.cmp(J.gp(v_n_832, "fear"), 50.0, ">=") else "#ffd36a")
			J.sp(v_ctx_763, "fillStyle", _t1542)
			J.sp(v_ctx_763, "strokeStyle", "#000")
			J.sp(v_ctx_763, "lineWidth", 3.0)
			J.mc(v_ctx_763, "strokeText", [v_mark_840, 0.0, 0.0])
			J.mc(v_ctx_763, "fillText", [v_mark_840, 0.0, 0.0])
			J.mc(v_ctx_763, "restore", [])
		var _t1544 = J.gp(v_n_832, "bub")
		if J.t(_t1544):
			var _t1543 = J.gp(_s423["this"], "_bubOK")
			_t1544 = J.mc(_t1543, "has", [v_n_832])
		if J.t(_t1544):
			var _t1547 = J.gp(v_n_832, "bub")
			var _t1548 = J.sub(J.sub(v_by_834, 20.0), J.mc(_s423["this"], "tagExt", [v_n_832]))
			var _t1549 = J.gp(v_n_832, "bubG")
			var _t1546 = J.gp(_s423["this"], "t")
			var _t1545 = J.gp(v_n_832, "bubAt")
			J.mc(_s423["this"], "drawBubble", [v_ctx_763, _t1547, v_x_833, _t1548, _t1549, J.sub(_t1546, (_t1545 if J.t(_t1545) else 0.0))])
	if J.t(J.gp(J.gp(_s423["this"], "site"), "pano")):
		J.mc(_s423["this"], "drawEdge", [v_ctx_763, _s423["t"]])
	for _t1550 in J.iter(J.gp(_s423["this"], "floats")):
		v_f_856 = _t1550
		v_k_857 = (1.0 - J.div(J.gp(v_f_856, "life"), J.gp(v_f_856, "max")))
		v_x_858 = J.div(J.gp(_s423["this"], "W"), 2.0)
		v_y_859 = (64.0 - (J.min_([1.0, J.mul(v_k_857, 6.0)]) * 4.0))
		v_al_860 = J.min_([1.0, J.mul(J.gp(v_f_856, "life"), 3.0), (J.mul(v_k_857, 8.0) + 0.2)])
		J.mc(v_ctx_763, "save", [])
		J.sp(v_ctx_763, "globalAlpha", v_al_860)
		J.sp(v_ctx_763, "font", "800 15px sans-serif")
		J.sp(v_ctx_763, "textAlign", "center")
		v_w_861 = J.min_([J.sub(J.gp(_s423["this"], "W"), 20.0), J.add(J.gp(J.mc(v_ctx_763, "measureText", [J.gp(v_f_856, "text")]), "width"), 26.0)])
		J.sp(v_ctx_763, "fillStyle", "rgba(12,10,20,.82)")
		J.mc(v_ctx_763, "beginPath", [])
		J.mc(v_ctx_763, "roundRect", [J.sub(v_x_858, J.div(v_w_861, 2.0)), J.sub(v_y_859, 17.0), v_w_861, 26.0, 13.0])
		J.mc(v_ctx_763, "fill", [])
		var _t1551 = J.gp(v_f_856, "color")
		J.sp(v_ctx_763, "strokeStyle", _t1551)
		var _t1552 = J.mul(v_al_860, 0.6)
		J.sp(v_ctx_763, "globalAlpha", _t1552)
		J.sp(v_ctx_763, "lineWidth", 1.2)
		J.mc(v_ctx_763, "stroke", [])
		J.sp(v_ctx_763, "globalAlpha", v_al_860)
		var _t1553 = J.gp(v_f_856, "color")
		J.sp(v_ctx_763, "fillStyle", _t1553)
		J.mc(v_ctx_763, "fillText", [J.gp(v_f_856, "text"), v_x_858, J.add(v_y_859, 1.0)])
		J.mc(v_ctx_763, "restore", [])
	J.mc(v_ctx_763, "restore", [])
	v_vg_775 = J.mc(v_ctx_763, "createRadialGradient", [J.div(v_W_766, 2.0), J.div(v_H_767, 2.0), J.mul(v_H_767, 0.3), J.div(v_W_766, 2.0), J.div(v_H_767, 2.0), J.mul(v_H_767, 0.8)])
	J.mc(v_vg_775, "addColorStop", [0.0, "rgba(0,0,0,0)"])
	J.mc(v_vg_775, "addColorStop", [1.0, ("rgba(" + J.str(J.round(J.num(J.mul(90.0, J.gp(_s423["this"], "vign"))))) + ",0,0," + J.str((0.45 + J.mul(0.3, J.gp(_s423["this"], "vign")))) + ")")])
	J.sp(v_ctx_763, "fillStyle", v_vg_775)
	J.mc(v_ctx_763, "fillRect", [0.0, 0.0, v_W_766, v_H_767])
	var _t1554 = J.gp(_s423["this"], "expo")
	var _t1555 = J.gp(_s423["this"], "expo")
	v_e_862 = J.min_([100.0, (_t1555 if J.t(_t1555) else 0.0)])
	v_bx_863 = 10.0
	v_by_864 = (J.sub(J.gp(_s423["this"], "H"), 34.0) if J.t(J.gp(J.gp(_s423["this"], "site"), "pano")) else 10.0)
	v_bw_865 = 132.0
	v_bh_866 = 9.0
	J.mc(v_ctx_763, "save", [])
	J.sp(v_ctx_763, "fillStyle", "rgba(0,0,0,.62)")
	J.mc(v_ctx_763, "fillRect", [J.sub(v_bx_863, 4.0), J.sub(v_by_864, 4.0), J.add(v_bw_865, 8.0), J.add(v_bh_866, 22.0)])
	J.sp(v_ctx_763, "font", "700 11px sans-serif")
	J.sp(v_ctx_763, "textAlign", "left")
	var _t1556 = ("#ff8a6a" if J.cmp(v_e_862, J.gp(J.G.get("EXPO"), "call"), ">=") else ("#ffcf6a" if J.cmp(v_e_862, J.gp(J.G.get("EXPO"), "sus"), ">=") else "#cfe8d8"))
	J.sp(v_ctx_763, "fillStyle", _t1556)
	J.mc(v_ctx_763, "fillText", [("穿崩度 " + J.str(J.round(J.num(v_e_862))) + ("　道士到！" if J.t(J.gp(_s423["this"], "daoIn")) else ("　請咗道士" if J.t(J.gp(_s423["this"], "daoCall")) else ("　有人起疑" if J.t(J.gp(_s423["this"], "alert")) else "")))), v_bx_863, J.add(v_by_864, 8.0)])
	J.sp(v_ctx_763, "fillStyle", "rgba(255,255,255,.15)")
	J.mc(v_ctx_763, "fillRect", [v_bx_863, J.add(v_by_864, 12.0), v_bw_865, J.sub(v_bh_866, 2.0)])
	var _t1557 = ("#ff6a4a" if J.cmp(v_e_862, J.gp(J.G.get("EXPO"), "call"), ">=") else ("#ffb84a" if J.cmp(v_e_862, J.gp(J.G.get("EXPO"), "sus"), ">=") else "#7fd6a0"))
	J.sp(v_ctx_763, "fillStyle", _t1557)
	J.mc(v_ctx_763, "fillRect", [v_bx_863, J.add(v_by_864, 12.0), J.div(J.mul(v_bw_865, v_e_862), 100.0), J.sub(v_bh_866, 2.0)])
	J.sp(v_ctx_763, "fillStyle", "rgba(255,255,255,.7)")
	for _t1558 in J.iter([J.gp(J.G.get("EXPO"), "sus"), J.gp(J.G.get("EXPO"), "call")]):
		v_q_867 = _t1558
		J.mc(v_ctx_763, "fillRect", [J.add(v_bx_863, J.div(J.mul(v_bw_865, v_q_867), 100.0)), J.add(v_by_864, 10.0), 1.5, J.add(v_bh_866, 2.0)])
	J.mc(v_ctx_763, "restore", [])
	if J.cmp(J.gp(_s423["this"], "t"), J.mul(J.G.get("NIGHT_SEC"), 0.85), ">"):
		var _t1559 = ("rgba(120,150,210," + J.str(((J.div(J.gp(_s423["this"], "t"), J.G.get("NIGHT_SEC")) - 0.85) * 1.2)) + ")")
		J.sp(v_ctx_763, "fillStyle", _t1559)
		J.mc(v_ctx_763, "fillRect", [0.0, 0.0, v_W_766, v_H_767])

func _f218(this_, a: Array, env):
	var v_ctx_870 = null; var v_t_871 = null; var v_n_872 = null; var v_x_873 = null; var v_right_874 = null; var v_H_875 = null; var v_y_876 = null; var v_ex_877 = null; var v_bob_878 = null; var v_lab_879 = null; var v_tw_880 = null; var v_bx_881 = null; var v_ax_882 = null
	v_ctx_870 = J.arg(a, 0)
	v_t_871 = J.arg(a, 1)
	v_n_872 = J.gp(this_, "sel")
	var _t1560 = this_
	J.sp(_t1560, "_edge", null)
	var _t1561 = (not J.t(v_n_872))
	var _t1562 = (_t1561 if _t1561 else J.gp(v_n_872, "gone"))
	if J.t((_t1562 if J.t(_t1562) else J.gp(v_n_872, "out"))):
		return null
	v_x_873 = (J.gp(v_n_872, "vX") if (not J.leq(J.gp(v_n_872, "vX"), null)) else J.gp(v_n_872, "x"))
	if J.t(J.mc(this_, "onScreen", [v_x_873, (-0.04)])):
		return null
	v_right_874 = J.cmp(v_x_873, J.add(J.gp(this_, "camX"), J.div(J.mc(this_, "viewW", []), 2.0)), ">")
	v_H_875 = J.gp(this_, "H")
	v_y_876 = 58.0
	v_ex_877 = (J.sub(J.gp(this_, "W"), 8.0) if J.t(v_right_874) else 8.0)
	v_bob_878 = (sin(J.num(J.mul(v_t_871, 5.0))) * 3.0)
	v_lab_879 = (J.str(J.gp(J.gp(v_n_872, "d"), "name")) + "・" + J.str(J.gp(J.mc(J.G.get("OFFMAP"), "roomAt", [v_x_873]), "name")))
	J.mc(v_ctx_870, "save", [])
	J.sp(v_ctx_870, "font", "800 12px sans-serif")
	v_tw_880 = J.add(J.gp(J.mc(v_ctx_870, "measureText", [v_lab_879]), "width"), 34.0)
	v_bx_881 = (J.sub(J.sub(v_ex_877, v_tw_880), v_bob_878) if J.t(v_right_874) else J.add(v_ex_877, v_bob_878))
	J.sp(v_ctx_870, "fillStyle", "rgba(12,10,20,.85)")
	J.sp(v_ctx_870, "strokeStyle", "#a8ffcf")
	J.sp(v_ctx_870, "lineWidth", 1.5)
	J.mc(v_ctx_870, "beginPath", [])
	J.mc(v_ctx_870, "roundRect", [v_bx_881, J.sub(v_y_876, 14.0), v_tw_880, 28.0, 14.0])
	J.mc(v_ctx_870, "fill", [])
	J.mc(v_ctx_870, "stroke", [])
	J.sp(v_ctx_870, "fillStyle", "#a8ffcf")
	J.mc(v_ctx_870, "beginPath", [])
	v_ax_882 = (J.sub(J.add(v_bx_881, v_tw_880), 12.0) if J.t(v_right_874) else J.add(v_bx_881, 12.0))
	J.mc(v_ctx_870, "moveTo", [J.add(v_ax_882, (7.0 if J.t(v_right_874) else (-7.0))), v_y_876])
	J.mc(v_ctx_870, "lineTo", [J.sub(v_ax_882, (5.0 if J.t(v_right_874) else (-5.0))), J.sub(v_y_876, 8.0)])
	J.mc(v_ctx_870, "lineTo", [J.sub(v_ax_882, (5.0 if J.t(v_right_874) else (-5.0))), J.add(v_y_876, 8.0)])
	J.mc(v_ctx_870, "closePath", [])
	J.mc(v_ctx_870, "fill", [])
	J.sp(v_ctx_870, "textAlign", "center")
	J.sp(v_ctx_870, "fillStyle", "#eafff2")
	J.mc(v_ctx_870, "fillText", [v_lab_879, J.add(J.add(v_bx_881, J.div(v_tw_880, 2.0)), ((-6.0) if J.t(v_right_874) else 6.0)), J.add(v_y_876, 4.0)])
	J.mc(v_ctx_870, "restore", [])
	var _t1563 = this_
	var _t1564 = [v_bx_881, J.sub(v_y_876, 14.0), v_tw_880, 28.0, v_n_872]
	J.sp(_t1563, "_edge", _t1564)

func _f219(this_, a: Array, env):
	var v_ctx_885 = null; var v_f_886 = null; var v_t_887 = null; var v_n_888 = null; var v_k_889 = null; var v_seat_890 = null; var v_x_891 = null; var v_y_892 = null; var v_hh_893 = null; var v_face_894 = null; var v_back_895 = null; var v_nx_896 = null; var v_ny_897 = null; var v_a_898 = null; var v_i_899 = null; var v_q_900 = null; var v_px_901 = null; var v_py_902 = null; var v_r_903 = null; var v_g_904 = null; var v_i_905 = null; var v_q_906 = null; var v_sx_907 = null; var v_sy_908 = null
	v_ctx_885 = J.arg(a, 0)
	v_f_886 = J.arg(a, 1)
	v_t_887 = J.arg(a, 2)
	v_n_888 = J.gp(v_f_886, "n")
	v_k_889 = (1.0 - J.div(J.gp(v_f_886, "life"), J.gp(v_f_886, "max")))
	var _t1565 = J.mc(this_, "office", [])
	v_seat_890 = (J.mc(J.G.get("OFFICE"), "seated", [v_n_888]) if J.t(_t1565) else _t1565)
	var _t1566 = J.mc(this_, "pt", [(J.gp(v_n_888, "vX") if (not J.leq(J.gp(v_n_888, "vX"), null)) else J.gp(v_n_888, "x")), (J.gp(v_n_888, "vY") if (not J.leq(J.gp(v_n_888, "vY"), null)) else J.gp(v_n_888, "y"))])
	var _t1567 = J.gp(_t1566, 0.0)
	v_x_891 = _t1567
	var _t1568 = J.gp(_t1566, 1.0)
	v_y_892 = _t1568
	v_hh_893 = J.mul(J.mc(this_, "hh", [J.gp(v_n_888, "y")]), (0.8 if J.t(v_seat_890) else 1.0))
	var _t1570 = null
	if J.t(v_seat_890):
		_t1570 = (-1.0)
	else:
		var _t1569 = J.gp(v_n_888, "dir")
		_t1570 = (_t1569 if J.t(_t1569) else 1.0)
	v_face_894 = _t1570
	v_back_895 = (-J.num(v_face_894))
	v_nx_896 = J.add(v_x_891, (J.mul(v_back_895, v_hh_893) * (0.02 if J.t(v_seat_890) else 0.2)))
	v_ny_897 = J.sub(v_y_892, J.mul(v_hh_893, (0.62 if J.t(v_seat_890) else 0.72)))
	v_a_898 = (J.min_([1.0, J.mul(v_k_889, 6.0)]) * J.max_([0.0, (1.0 - J.div(J.max_([0.0, J.sub(v_k_889, 0.45)]), 0.4))]))
	if J.cmp(v_a_898, 0.0, "<="):
		return null
	J.mc(v_ctx_885, "save", [])
	J.sp(v_ctx_885, "lineCap", "round")
	v_i_899 = 0.0
	while true:
		if not J.cmp(v_i_899, 4.0, "<"): break
		v_q_900 = J.min_([1.0, J.max_([0.0, (J.mul(v_k_889, 2.2) - J.mul(v_i_899, 0.18))])])
		if J.cmp(v_q_900, 0.0, "<="):
			v_i_899 = J.num(v_i_899) + 1.0
			continue
		v_px_901 = J.add(J.add(v_nx_896, (J.mul(v_back_895, v_hh_893) * (0.28 - J.mul(0.22, v_q_900)))), (sin(J.num(J.add(J.mul(v_t_887, 3.0), v_i_899))) * 2.0))
		v_py_902 = (J.sub(v_ny_897, J.mul(J.mul(v_hh_893, 0.04), v_i_899)) + (sin(J.num(J.add(J.mul(v_t_887, 2.0), v_i_899))) * 1.5))
		v_r_903 = J.mul(v_hh_893, (0.05 + J.mul(0.07, v_q_900)))
		v_g_904 = J.mc(v_ctx_885, "createRadialGradient", [v_px_901, v_py_902, 0.0, v_px_901, v_py_902, v_r_903])
		J.mc(v_g_904, "addColorStop", [0.0, ("rgba(240,248,255," + J.str(J.mul(0.8, v_a_898)) + ")")])
		J.mc(v_g_904, "addColorStop", [1.0, "rgba(235,245,255,0)"])
		J.sp(v_ctx_885, "fillStyle", v_g_904)
		J.mc(v_ctx_885, "beginPath", [])
		J.mc(v_ctx_885, "arc", [v_px_901, v_py_902, v_r_903, 0.0, (PI * 2.0)])
		J.mc(v_ctx_885, "fill", [])
		var _t1571 = ("rgba(245,250,255," + J.str(J.mul(0.6, v_a_898)) + ")")
		J.sp(v_ctx_885, "strokeStyle", _t1571)
		J.sp(v_ctx_885, "lineWidth", 1.6)
		J.mc(v_ctx_885, "beginPath", [])
		J.mc(v_ctx_885, "arc", [v_px_901, v_py_902, J.mul(v_r_903, 0.6), (PI * (0.2 + J.mul(v_i_899, 0.3))), (PI * (1.3 + J.mul(v_i_899, 0.3)))])
		J.mc(v_ctx_885, "stroke", [])
		v_i_899 = J.num(v_i_899) + 1.0
	var _t1572 = ("rgba(220,240,255," + J.str(v_a_898) + ")")
	J.sp(v_ctx_885, "fillStyle", _t1572)
	v_i_905 = 0.0
	while true:
		if not J.cmp(v_i_905, 6.0, "<"): break
		v_q_906 = J.mod((J.mul(v_k_889, 2.0) + J.div(v_i_905, 6.0)), 1.0)
		v_sx_907 = J.add(v_nx_896, (J.mul(v_back_895, v_hh_893) * (0.05 + (0.2 * sin(J.num(J.mul(v_i_905, 2.1)))))))
		v_sy_908 = J.add(v_ny_897, J.mul(v_hh_893, (J.mul(v_q_906, 0.2) - 0.08)))
		J.mc(v_ctx_885, "beginPath", [])
		J.mc(v_ctx_885, "arc", [v_sx_907, v_sy_908, 1.4, 0.0, (PI * 2.0)])
		J.mc(v_ctx_885, "fill", [])
		v_i_905 = J.num(v_i_905) + 1.0
	J.mc(v_ctx_885, "restore", [])

func _f222(this_, a: Array, env):
	var v_r_930 = null
	v_r_930 = J.arg(a, 0)
	var _t1588 = J.cmp(absf(J.num(J.sub(J.gp(v_r_930, 0.0), env["__p"]["lx"]))), J.add(env["__p"]["tw"], 44.0), "<")
	var _t1589 = (J.cmp(env["yy"], J.sub(J.gp(v_r_930, 1.0), 22.0), ">") if _t1588 else _t1588)
	return (J.cmp(J.sub(env["yy"], 12.0), J.add(J.gp(v_r_930, 1.0), J.gp(v_r_930, 2.0)), "<") if _t1589 else _t1589)

func _f223(this_, a: Array, env):
	var v_r_931 = null
	v_r_931 = J.arg(a, 0)
	var _t1590 = J.cmp(J.add(env["__p"]["lx"], env["__p"]["tw"]), J.gp(v_r_931, 0.0), ">")
	var _t1591 = (J.cmp(J.sub(env["__p"]["lx"], env["__p"]["tw"]), J.add(J.gp(v_r_931, 0.0), J.gp(v_r_931, 2.0)), "<") if _t1590 else _t1590)
	var _t1592 = (J.cmp(env["yy"], J.gp(v_r_931, 1.0), ">") if _t1591 else _t1591)
	return (J.cmp(J.sub(env["yy"], 12.0), J.add(J.gp(v_r_931, 1.0), J.gp(v_r_931, 3.0)), "<") if _t1592 else _t1592)

func _f221(this_, a: Array, env):
	var _s495 = {"__p": env, "yy": null}
	_s495["yy"] = J.arg(a, 0)
	var _t1593 = J.mc(_s495["__p"]["TR"], "some", [Callable(self, "_f222").bind(_s495)])
	return (_t1593 if J.t(_t1593) else J.mc(_s495["__p"]["BR"], "some", [Callable(self, "_f223").bind(_s495)]))

func _f220(this_, a: Array, env):
	var v_ctx_911 = null; var v_t_912 = null; var v_k_913 = null; var v_p_914 = null; var v_x1_915 = null; var v_y1_916 = null; var v_x2_917 = null; var v_y2_918 = null; var v_ok_919 = null; var v_a_920 = null; var v_cdl_921 = null; var v_lab_922 = null; var v_hit_927 = null; var v_ly_928 = null; var v_c_932 = null
	v_ctx_911 = J.arg(a, 0)
	v_t_912 = J.arg(a, 1)
	for _t1573 in J.keys(J.G.get("SCARE_PROPS")):
		v_k_913 = _t1573
		var _s494 = {"__p": env, "tw": null, "lx": null, "TR": null, "BR": null}
		var _t1574 = J.gp(J.gp(J.G.get("SCARE_PROPS"), v_k_913), "group")
		if J.t((_t1574 if J.t(_t1574) else (not J.t(J.mc(this_, "propOK", [v_k_913, J.gp(this_, "sel")]))))):
			continue
		var _t1575 = J.gp(J.gp(this_, "site"), "pano")
		if J.t(((not J.t(J.mc(this_, "onScreen", [J.add(J.gp(J.gp(J.gp(J.G.get("SCARE_PROPS"), v_k_913), "rect"), 0.0), J.div(J.gp(J.gp(J.gp(J.G.get("SCARE_PROPS"), v_k_913), "rect"), 2.0), 2.0)), 0.0]))) if J.t(_t1575) else _t1575)):
			continue
		v_p_914 = J.gp(J.G.get("SCARE_PROPS"), v_k_913)
		var _t1576 = J.mc(this_, "pt", [J.gp(J.gp(v_p_914, "rect"), 0.0), J.gp(J.gp(v_p_914, "rect"), 1.0)])
		var _t1577 = J.gp(_t1576, 0.0)
		v_x1_915 = _t1577
		var _t1578 = J.gp(_t1576, 1.0)
		v_y1_916 = _t1578
		var _t1579 = J.mc(this_, "pt", [J.add(J.gp(J.gp(v_p_914, "rect"), 0.0), J.gp(J.gp(v_p_914, "rect"), 2.0)), J.add(J.gp(J.gp(v_p_914, "rect"), 1.0), J.gp(J.gp(v_p_914, "rect"), 3.0))])
		var _t1580 = J.gp(_t1579, 0.0)
		v_x2_917 = _t1580
		var _t1581 = J.gp(_t1579, 1.0)
		v_y2_918 = _t1581
		var _t1582 = J.cmp(J.gp(this_, "mana"), J.gp(v_p_914, "cost"), ">=")
		v_ok_919 = (J.mc(this_, "propOK", [v_k_913, J.gp(this_, "sel")]) if _t1582 else _t1582)
		v_a_920 = ((0.35 + (0.25 * sin(J.num(J.add(J.mul(v_t_912, 3.0), v_x1_915))))) if J.t(v_ok_919) else 0.1)
		var _t1583 = ("rgba(150,255,200," + J.str(v_a_920) + ")")
		J.sp(v_ctx_911, "strokeStyle", _t1583)
		J.sp(v_ctx_911, "lineWidth", 2.0)
		J.mc(v_ctx_911, "setLineDash", [[5.0, 4.0]])
		J.mc(v_ctx_911, "strokeRect", [v_x1_915, v_y1_916, J.sub(v_x2_917, v_x1_915), J.sub(v_y2_918, v_y1_916)])
		J.mc(v_ctx_911, "setLineDash", [[]])
		var _t1585 = J.gp(v_p_914, "group")
		if J.t(_t1585):
			var _t1584 = J.gp(this_, "pcd")
			_t1585 = J.cmp(J.gp((_t1584 if J.t(_t1584) else {}), v_k_913), 0.0, ">")
		v_cdl_921 = (J.add(ceil(J.num(J.gp(J.gp(this_, "pcd"), v_k_913))), "秒") if J.t(_t1585) else J.gp(v_p_914, "cost"))
		v_lab_922 = (J.str(J.gp(v_p_914, "name")) + ("（全場）" if J.t(J.gp(v_p_914, "group")) else "") + "・" + J.str(v_cdl_921))
		J.sp(v_ctx_911, "font", "600 11px sans-serif")
		J.sp(v_ctx_911, "textAlign", "center")
		_s494["tw"] = (J.div(J.gp(J.mc(v_ctx_911, "measureText", [v_lab_922]), "width"), 2.0) + 4.0)
		_s494["lx"] = J.max_([_s494["tw"], J.min_([J.sub(J.gp(this_, "W"), _s494["tw"]), J.div(J.add(v_x1_915, v_x2_917), 2.0)])])
		var _t1586 = J.gp(this_, "_tagR")
		_s494["TR"] = (_t1586 if J.t(_t1586) else [])
		var _t1587 = J.gp(this_, "_bubLast")
		_s494["BR"] = (_t1587 if J.t(_t1587) else [])
		v_hit_927 = Callable(self, "_f221").bind(_s494)
		v_ly_928 = (J.sub(v_y1_916, 5.0) if J.seq(J.gp(v_p_914, "label"), "up") else J.add(v_y2_918, 13.0))
		for _t1594 in J.iter([J.sub(v_y1_916, 5.0), J.add(v_y2_918, 13.0), J.add(v_y1_916, 14.0)]):
			v_c_932 = _t1594
			if (not J.t(J.cl(v_hit_927, null, [v_ly_928]))):
				break
			else:
				v_ly_928 = v_c_932
		if J.t(J.cl(v_hit_927, null, [v_ly_928])):
			continue
		if J.t(J.mc(this_, "office", [])):
			J.sp(v_ctx_911, "lineWidth", 3.0)
			J.sp(v_ctx_911, "strokeStyle", "rgba(10,8,20,.75)")
			J.mc(v_ctx_911, "strokeText", [v_lab_922, _s494["lx"], v_ly_928])
		var _t1595 = (("rgba(190,215,255," + J.str((0.9 if J.t(v_ok_919) else 0.4)) + ")") if J.t(J.gp(v_p_914, "group")) else ("rgba(190,255,215," + J.str((0.9 if J.t(v_ok_919) else 0.4)) + ")"))
		J.sp(v_ctx_911, "fillStyle", _t1595)
		J.mc(v_ctx_911, "fillText", [v_lab_922, _s494["lx"], v_ly_928])

func _f224(this_, a: Array, env):
	var v_n_935 = null; var v_k_936 = null; var v_o_937 = null; var v_D_938 = null
	v_n_935 = J.arg(a, 0)
	v_k_936 = J.arg(a, 1)
	v_o_937 = J.arg(a, 2)
	var _t1596 = J.gp(this_, "headless")
	if J.t((_t1596 if J.t(_t1596) else (not J.t(v_n_935)))):
		return null
	var _t1597 = (v_o_937 if J.t(v_o_937) else {})
	v_o_937 = _t1597
	v_D_938 = {"flinch": 0.5, "startle": 0.75, "weakjump": 0.95, "burst": 2.6, "rational": 1.6, "numb": 1.3, "sip": 2.6, "catch": 2.4, "chill": 2.4}
	var _t1598 = J.gp(v_n_935, "rx")
	var _t1599 = (J.seq(J.gp(J.gp(v_n_935, "rx"), "k"), "burst") if J.t(_t1598) else _t1598)
	var _t1600 = (J.cmp(J.gp(J.gp(v_n_935, "rx"), "t"), J.mul(J.gp(J.gp(v_n_935, "rx"), "dur"), 0.75), "<") if J.t(_t1599) else _t1599)
	if J.t(((not J.seq(v_k_936, "burst")) if J.t(_t1600) else _t1600)):
		return null
	var _t1601 = J.gp(v_o_937, "delay")
	var _t1604 = (-J.num((_t1601 if J.t(_t1601) else 0.0)))
	var _t1602 = J.gp(v_o_937, "dur")
	var _t1603 = (_t1602 if J.t(_t1602) else J.gp(v_D_938, v_k_936))
	var _t1605 = {"k": v_k_936, "t": _t1604, "dur": (_t1603 if J.t(_t1603) else 1.0), "src": J.gp(v_o_937, "src"), "big": (not (not J.t(J.gp(v_o_937, "big"))))}
	J.sp(v_n_935, "rx", _t1605)

func _f225(this_, a: Array, env):
	var v_n_941 = null; var v_dt_942 = null; var v_lv_943 = null; var v_vx_944 = null; var v_vy_945 = null; var v_key_946 = null
	v_n_941 = J.arg(a, 0)
	v_dt_942 = J.arg(a, 1)
	var _t1606 = J.gp(v_n_941, "at")
	var _t1608 = (_t1606 if J.t(_t1606) else 0.0)
	var _t1607 = J.gp(v_n_941, "spd")
	var _t1609 = J.add(_t1608, J.mul(v_dt_942, (_t1607 if J.t(_t1607) else 1.0)))
	J.sp(v_n_941, "at", _t1609)
	if (not J.seq(J.typeof_(J.G.get("TOWN")), "undefined")):
		J.mc(J.G.get("TOWN"), "npcTick", [v_n_941, v_dt_942])
	if J.t(J.mc(this_, "office", [])):
		J.mc(J.G.get("OFFICE"), "kenTick", [v_n_941, v_dt_942])
	if J.t(J.gp(v_n_941, "rx")):
		var _t1610 = J.gp(v_n_941, "rx")
		var _t1611 = J.add(J.gp(_t1610, "t"), v_dt_942)
		J.sp(_t1610, "t", _t1611)
		var _t1612 = (not J.t(J.gp(J.gp(v_n_941, "rx"), "fired")))
		if (J.cmp(J.gp(J.gp(v_n_941, "rx"), "t"), 0.0, ">=") if _t1612 else _t1612):
			var _t1613 = J.gp(v_n_941, "rx")
			J.sp(_t1613, "fired", true)
			J.mc(this_, "onReact", [v_n_941])
		var _t1614 = J.gp(v_n_941, "rx")
		if J.t((J.cmp(J.gp(J.gp(v_n_941, "rx"), "t"), J.gp(J.gp(v_n_941, "rx"), "dur"), ">=") if J.t(_t1614) else _t1614)):
			J.sp(v_n_941, "rx", null)
	v_lv_943 = (3.0 if J.t(J.gp(v_n_941, "fleeing")) else (2.0 if J.cmp(J.gp(v_n_941, "fear"), 50.0, ">=") else (1.0 if J.cmp(J.gp(v_n_941, "fear"), 25.0, ">=") else 0.0)))
	var _t1615 = J.gp(v_n_941, "lv")
	if J.cmp(v_lv_943, (_t1615 if J.t(_t1615) else 0.0), ">"):
		J.sp(v_n_941, "markPop", 0.5)
		if J.cmp(v_lv_943, 1.0, ">="):
			var _t1616 = J.gp(v_n_941, "goose")
			var _t1617 = J.gp(v_n_941, "goose")
			var _t1618 = J.max_([(_t1617 if J.t(_t1617) else 0.0), 1.2])
			J.sp(v_n_941, "goose", _t1618)
	J.sp(v_n_941, "lv", v_lv_943)
	var _t1619 = J.gp(v_n_941, "markPop")
	var _t1620 = J.sub((_t1619 if J.t(_t1619) else 0.0), J.mul(v_dt_942, 2.0))
	J.sp(v_n_941, "markPop", _t1620)
	for _t1621 in J.iter(["goose", "hair", "shock", "scream"]):
		v_key_946 = _t1621
		if J.cmp(J.gp(v_n_941, v_key_946), 0.0, ">"):
			var _t1622 = J.max_([0.0, J.sub(J.gp(v_n_941, v_key_946), v_dt_942)])
			J.sp(v_n_941, v_key_946, _t1622)
	if J.cmp(J.gp(v_n_941, "barHit"), 0.0, ">"):
		var _t1623 = J.max_([0.0, J.sub(J.gp(v_n_941, "barHit"), J.mul(v_dt_942, 2.0))])
		J.sp(v_n_941, "barHit", _t1623)
	var _t1624 = J.cmp(J.gp(v_n_941, "shaken"), 0.0, ">")
	var _t1625 = ((not J.t(J.gp(v_n_941, "fleeing"))) if _t1624 else _t1624)
	if ((randf() < J.mul(v_dt_942, 0.9)) if _t1625 else _t1625):
		var _t1626 = J.gp(this_, "parts")
		J.mc(_t1626, "push", [{"kind": "sweat", "x": J.add((J.gp(v_n_941, "vX") if (not J.leq(J.gp(v_n_941, "vX"), null)) else J.gp(v_n_941, "x")), ((randf() - 0.5) * 0.05)), "y": J.sub((J.gp(v_n_941, "vY") if (not J.leq(J.gp(v_n_941, "vY"), null)) else J.gp(v_n_941, "y")), 0.16), "vx": ((randf() - 0.5) * 0.05), "vy": (-0.05), "g": 0.45, "life": 0.7}])
	var _t1627 = J.gp(v_n_941, "fleeing")
	var _t1628 = ((not J.t(J.gp(v_n_941, "gone"))) if J.t(_t1627) else _t1627)
	if J.t((J.gp(v_n_941, "trail") if J.t(_t1628) else _t1628)):
		var _t1629 = J.gp(v_n_941, "trail")
		J.mc(_t1629, "push", [[J.gp(this_, "t"), J.gp(v_n_941, "x"), J.gp(v_n_941, "y")]])
	v_vx_944 = (J.gp(v_n_941, "vX") if (not J.leq(J.gp(v_n_941, "vX"), null)) else J.gp(v_n_941, "x"))
	v_vy_945 = (J.gp(v_n_941, "vY") if (not J.leq(J.gp(v_n_941, "vY"), null)) else J.gp(v_n_941, "y"))
	var _t1630 = (not J.t(J.gp(v_n_941, "gone")))
	var _t1631 = (J.cmp(J.gp(v_n_941, "fear"), 50.0, ">=") if _t1630 else _t1630)
	if ((randf() < J.mul(v_dt_942, (5.0 if J.cmp(J.gp(v_n_941, "fear"), 80.0, ">=") else 2.2))) if _t1631 else _t1631):
		var _t1632 = J.gp(this_, "parts")
		J.mc(_t1632, "push", [{"kind": "sweat", "x": J.add(v_vx_944, ((randf() - 0.5) * 0.06)), "y": (J.sub(v_vy_945, 0.16) - (randf() * 0.03)), "vx": ((randf() - 0.5) * 0.06), "vy": (-0.06), "g": 0.45, "life": 0.7}])

func _f226(this_, a: Array, env):
	var v_n_949 = null; var v_k_950 = null; var v_vx_951 = null; var v_vy_952 = null; var v_i_953 = null; var v_a_954 = null
	v_n_949 = J.arg(a, 0)
	v_k_950 = J.gp(J.gp(v_n_949, "rx"), "k")
	v_vx_951 = (J.gp(v_n_949, "vX") if (not J.leq(J.gp(v_n_949, "vX"), null)) else J.gp(v_n_949, "x"))
	v_vy_952 = (J.gp(v_n_949, "vY") if (not J.leq(J.gp(v_n_949, "vY"), null)) else J.gp(v_n_949, "y"))
	var _t1633 = J.seq(v_k_950, "startle")
	var _t1634 = (_t1633 if _t1633 else J.seq(v_k_950, "weakjump"))
	if (_t1634 if _t1634 else J.seq(v_k_950, "burst")):
		var _t1635 = (1.6 if J.seq(v_k_950, "burst") else 1.0)
		J.sp(v_n_949, "hair", _t1635)
		J.sp(v_n_949, "goose", 1.6)
		J.sp(v_n_949, "shock", 0.5)
		v_i_953 = 0.0
		while true:
			if not J.cmp(v_i_953, (7.0 if J.seq(v_k_950, "burst") else 4.0), "<"): break
			v_a_954 = (J.div((-PI), 2.0) + ((randf() - 0.5) * 2.2))
			var _t1636 = J.gp(this_, "parts")
			J.mc(_t1636, "push", [{"kind": "sweat", "x": J.add(v_vx_951, (cos(J.num(v_a_954)) * 0.03)), "y": J.sub(v_vy_952, 0.17), "vx": (cos(J.num(v_a_954)) * 0.16), "vy": (sin(J.num(v_a_954)) * 0.18), "g": 0.6, "life": 0.75}])
			v_i_953 = J.num(v_i_953) + 1.0
	if J.seq(v_k_950, "burst"):
		J.sp(v_n_949, "scream", 1.8)
	if J.seq(v_k_950, "flinch"):
		J.sp(v_n_949, "shock", 0.28)
		var _t1637 = J.gp(v_n_949, "goose")
		var _t1638 = J.gp(v_n_949, "goose")
		var _t1639 = J.max_([(_t1638 if J.t(_t1638) else 0.0), 0.8])
		J.sp(v_n_949, "goose", _t1639)

func _f227(this_, a: Array, env):
	var v_type_957 = null
	v_type_957 = J.arg(a, 0)
	var _t1643 = (not J.seq(J.typeof_(J.G.get("ART")), "undefined"))
	if J.t(_t1643):
		var _t1640 = (not J.seq(J.typeof_(J.G.get("Puppet")), "undefined"))
		var _t1642 = (J.mc(J.G.get("Puppet"), "has", [v_type_957]) if _t1640 else _t1640)
		if not J.t(_t1642):
			var _t1641 = J.gp(J.G.get("ART"), "hasRig")
			_t1642 = (not (not J.t((J.mc(J.G.get("ART"), "hasRig", [v_type_957]) if J.t(_t1641) else _t1641))))
		_t1643 = _t1642
	return _t1643

func _f228(this_, a: Array, env):
	var v_n_960 = null; var v_age_961 = null; var v_hold_962 = null; var v_tr_963 = null; var v_lag_964 = null; var v_ts_965 = null; var v_i_966 = null; var v_x_967 = null; var v_y_968 = null; var v_dir_969 = null; var v_b_970 = null; var v_k_971 = null; var v_e_972 = null
	v_n_960 = J.arg(a, 0)
	var _t1644 = (not J.t(J.gp(v_n_960, "fleeT")))
	var _t1645 = (_t1644 if _t1644 else (not J.t(J.gp(v_n_960, "trail"))))
	if (_t1645 if _t1645 else (not J.t(J.len(J.gp(v_n_960, "trail"))))):
		return [J.gp(v_n_960, "x"), J.gp(v_n_960, "y"), null]
	v_age_961 = J.sub(J.gp(this_, "t"), J.gp(v_n_960, "fleeT"))
	var _t1646 = J.gp(v_n_960, "fleeHold")
	v_hold_962 = (_t1646 if J.t(_t1646) else 0.0)
	v_tr_963 = J.gp(v_n_960, "trail")
	v_lag_964 = (v_age_961 if J.cmp(v_age_961, v_hold_962, "<") else J.mul(v_hold_962, J.max_([0.0, (1.0 - J.div(J.sub(v_age_961, v_hold_962), 0.7))])))
	v_ts_965 = J.sub(J.gp(this_, "t"), v_lag_964)
	v_i_966 = (J.len(v_tr_963) - 1.0)
	while true:
		var _t1647 = J.cmp(v_i_966, 0.0, ">")
		if not (J.cmp(J.gp(J.gp(v_tr_963, v_i_966), 0.0), v_ts_965, ">") if _t1647 else _t1647): break
		v_i_966 = J.num(v_i_966) + -1.0
	v_x_967 = J.gp(J.gp(v_tr_963, v_i_966), 1.0)
	v_y_968 = J.gp(J.gp(v_tr_963, v_i_966), 2.0)
	v_dir_969 = J.gp(v_n_960, "dir")
	if J.cmp(v_i_966, (J.len(v_tr_963) - 1.0), "<"):
		v_b_970 = J.gp(v_tr_963, J.add(v_i_966, 1.0))
		var _t1649 = J.sub(v_ts_965, J.gp(J.gp(v_tr_963, v_i_966), 0.0))
		var _t1648 = J.sub(J.gp(v_b_970, 0.0), J.gp(J.gp(v_tr_963, v_i_966), 0.0))
		var _t1651 = J.sub(v_ts_965, J.gp(J.gp(v_tr_963, v_i_966), 0.0))
		var _t1650 = J.sub(J.gp(v_b_970, 0.0), J.gp(J.gp(v_tr_963, v_i_966), 0.0))
		var _t1653 = J.sub(v_ts_965, J.gp(J.gp(v_tr_963, v_i_966), 0.0))
		var _t1652 = J.sub(J.gp(v_b_970, 0.0), J.gp(J.gp(v_tr_963, v_i_966), 0.0))
		var _t1655 = J.sub(v_ts_965, J.gp(J.gp(v_tr_963, v_i_966), 0.0))
		var _t1654 = J.sub(J.gp(v_b_970, 0.0), J.gp(J.gp(v_tr_963, v_i_966), 0.0))
		v_k_971 = J.max_([0.0, J.min_([1.0, J.div(_t1655, (_t1654 if J.t(_t1654) else 1.0))])])
		var _t1656 = J.add(v_x_967, J.mul(J.sub(J.gp(v_b_970, 1.0), v_x_967), v_k_971))
		v_x_967 = _t1656
		var _t1657 = J.add(v_y_968, J.mul(J.sub(J.gp(v_b_970, 2.0), v_y_968), v_k_971))
		v_y_968 = _t1657
	else:
		if J.t(J.gp(v_n_960, "gone")):
			v_e_972 = J.sub(v_ts_965, J.gp(v_n_960, "exitT"))
			if J.cmp(v_e_972, 0.0, ">"):
				var _t1658 = J.add(v_x_967, J.mul(v_e_972, 0.45))
				v_x_967 = _t1658
				v_dir_969 = 1.0
	return [v_x_967, v_y_968, v_dir_969]

func _f230(this_, a: Array, env):
	var v_k_983 = null
	v_k_983 = J.arg(a, 0)
	return J.cmp(J.gp(J.gp(env["n"], "hab"), v_k_983), 1.5, ">=")

func _f231(this_, a: Array, env):
	var v_A_989 = null; var v_mul_990 = null; var v_q_991 = null; var v_up_992 = null
	v_A_989 = J.arg(a, 0)
	v_mul_990 = J.arg(a, 1)
	if J.cmp(J.gp(env["rx"], "t"), v_A_989, "<"):
		var _t1690 = env["o"]
		J.sp(_t1690, "sx", 1.09)
		var _t1691 = env["o"]
		J.sp(_t1691, "sy", 0.88)
		var _t1692 = env["o"]
		J.sp(_t1692, "face", "s")
		return null
	v_q_991 = J.min_([1.0, J.div(J.sub(J.gp(env["rx"], "t"), v_A_989), J.max_([0.2, J.sub((0.55 if J.seq(J.gp(env["rx"], "k"), "burst") else J.gp(env["rx"], "dur")), v_A_989)]))])
	v_up_992 = sin(J.num((J.min_([1.0, J.mul(v_q_991, 1.5)]) * PI)))
	var _t1695 = env["o"]
	var _t1694 = J.seq(J.gp(env["rx"], "k"), "burst")
	if not J.t(_t1694):
		var _t1693 = J.cmp(v_q_991, 0.4, ">")
		_t1694 = (J.cmp(env["f"], 75.0, ">=") if _t1693 else _t1693)
	J.S_Object_("assign", [_t1695, {"pose": "startle", "pt": v_q_991, "walk": false, "face": ("t" if _t1694 else "s"), "lift": J.mul(v_up_992, v_mul_990), "sy": (1.0 + J.mul(0.13, v_up_992)), "sx": J.div(1.0, (1.0 + J.mul(0.13, v_up_992))), "jit": 0.0}])

func _f229(this_, a: Array, env):
	var v_d_976 = null; var v_walking_979 = null; var v_habit_980 = null; var v_calm_981 = null; var v_age_984 = null; var v_hold_985 = null; var v_p_986 = null; var v_p_987 = null; var v_jump_988 = null; var v_sh_993 = null; var v_t2_994 = null; var v_sh_995 = null; var v_sq_996 = null
	var _s516 = {"__p": env, "n": null, "f": null, "rx": null, "o": null}
	_s516["n"] = J.arg(a, 0)
	v_d_976 = J.gp(_s516["n"], "d")
	_s516["f"] = J.gp(_s516["n"], "fear")
	var _t1659 = J.gp(_s516["n"], "rx")
	_s516["rx"] = (J.gp(_s516["n"], "rx") if J.t((J.cmp(J.gp(J.gp(_s516["n"], "rx"), "t"), 0.0, ">=") if J.t(_t1659) else _t1659)) else null)
	v_walking_979 = J.seq(J.gp(_s516["n"], "act"), "walk")
	var _t1661 = J.gp(_s516["n"], "hab")
	if J.t(_t1661):
		var _t1660 = J.S_Object_("keys", [J.gp(_s516["n"], "hab")])
		_t1661 = J.mc(_t1660, "some", [Callable(self, "_f230").bind(_s516)])
	v_habit_980 = _t1661
	var _t1662 = J.seq(J.gp(v_d_976, "k"), "ken")
	var _t1665 = null
	if (_t1662 if _t1662 else J.seq(J.gp(v_d_976, "k"), "auntie")):
		_t1665 = "b"
	else:
		var _t1664 = null
		if J.seq(J.gp(v_d_976, "k"), "boss"):
			var _t1663 = J.gp(_s516["n"], "at")
			_t1664 = ("q" if (sin(J.num(J.mul((_t1663 if J.t(_t1663) else 0.0), 0.9))) > 0.55) else "n")
		else:
			_t1664 = "n"
		_t1665 = _t1664
	v_calm_981 = _t1665
	_s516["o"] = {"pose": "idle", "face": ("b" if J.t((J.cmp(_s516["f"], 25.0, "<") if J.t(v_habit_980) else v_habit_980)) else v_calm_981), "pt": 0.0, "walk": false, "src": null, "sx": 1.0, "sy": 1.0, "lift": 0.0, "jit": 0.0, "rot": 0.0, "spd": 1.0}
	if J.t(J.gp(_s516["n"], "fleeing")):
		var _t1667 = J.gp(this_, "t")
		var _t1666 = J.gp(_s516["n"], "fleeT")
		v_age_984 = J.sub(_t1667, (_t1666 if J.t(_t1666) else 0.0))
		var _t1668 = J.gp(_s516["n"], "fleeHold")
		v_hold_985 = (_t1668 if J.t(_t1668) else 0.0)
		var _t1669 = J.cmp(v_age_984, v_hold_985, ">=")
		if J.t((_t1669 if _t1669 else J.gp(_s516["n"], "gone"))):
			return J.S_Object_("assign", [_s516["o"], {"pose": "run", "face": "t", "walk": true, "jit": 0.35, "spd": 2.2, "run": true}])
		if J.cmp(v_age_984, J.sub(v_hold_985, 0.4), ">="):
			v_p_986 = J.div((J.sub(v_age_984, v_hold_985) + 0.4), 0.4)
			var _t1674 = _s516["o"]
			var _t1671 = (sin(J.num(J.mul(v_p_986, PI))) * 1.3)
			var _t1672 = (1.0 + (0.14 * sin(J.num(J.mul(v_p_986, PI)))))
			var _t1673 = J.div(1.0, (1.0 + (0.14 * sin(J.num(J.mul(v_p_986, PI))))))
			var _t1670 = J.gp(_s516["n"], "rx")
			return J.S_Object_("assign", [_t1674, {"pose": "startle", "pt": v_p_986, "face": "t", "lift": _t1671, "sy": _t1672, "sx": _t1673, "src": (J.gp(J.gp(_s516["n"], "rx"), "src") if J.t(_t1670) else _t1670)}])
	if J.t(v_walking_979):
		var _t1675 = _s516["o"]
		J.sp(_t1675, "pose", "move")
		var _t1676 = _s516["o"]
		J.sp(_t1676, "walk", true)
		if J.cmp(_s516["f"], 50.0, ">="):
			J.S_Object_("assign", [_s516["o"], {"face": ("t" if J.cmp(_s516["f"], 80.0, ">=") else "f"), "jit": 0.45, "spd": 0.75}])
		else:
			if J.cmp(_s516["f"], 25.0, ">="):
				var _t1677 = _s516["o"]
				J.sp(_t1677, "face", "q")
	else:
		if J.cmp(_s516["f"], 80.0, ">="):
			J.S_Object_("assign", [_s516["o"], {"pose": "cower", "face": "t", "jit": 0.8}])
		else:
			if J.cmp(_s516["f"], 50.0, ">="):
				J.S_Object_("assign", [_s516["o"], {"pose": "tremble", "face": "f", "jit": 0.3}])
			else:
				if J.cmp(_s516["f"], 25.0, ">="):
					J.S_Object_("assign", [_s516["o"], {"pose": "look", "face": "q"}])
				else:
					if J.seq(J.gp(_s516["n"], "act"), "brk_nap"):
						J.S_Object_("assign", [_s516["o"], {"pose": "idle", "face": "c", "doze": true}])
					else:
						if J.seq(J.gp(_s516["n"], "act"), "brk_phone"):
							J.S_Object_("assign", [_s516["o"], {"pose": "phone", "face": "b"}])
						else:
							if J.seq(J.gp(_s516["n"], "act"), "brk_drink"):
								J.S_Object_("assign", [_s516["o"], {"pose": "sip", "face": "c"}])
							else:
								if J.seq(J.gp(v_d_976, "k"), "ken"):
									J.S_Object_("assign", [_s516["o"], {"pose": "phone", "face": "b"}])
								else:
									if J.seq(J.gp(_s516["n"], "act"), "mop"):
										J.S_Object_("assign", [_s516["o"], {"pose": "mop", "face": "b"}])
									else:
										var _t1678 = J.gp(v_d_976, "daoshi")
										if J.t((J.seq(J.gp(_s516["n"], "act"), "ritual") if J.t(_t1678) else _t1678)):
											var _t1679 = _s516["o"]
											J.sp(_t1679, "pose", "ritual")
										else:
											var _t1680 = J.gp(v_d_976, "guard")
											if J.t((J.seq(J.gp(_s516["n"], "act"), "doze") if J.t(_t1680) else _t1680)):
												J.S_Object_("assign", [_s516["o"], {"pose": "idle", "face": "c", "doze": true}])
											else:
												if J.t(J.gp(v_d_976, "guard")):
													J.S_Object_("assign", [_s516["o"], {"pose": "look", "face": "n"}])
												else:
													if J.seq(J.gp(v_d_976, "k"), "boss"):
														var _t1681 = _s516["o"]
														J.sp(_t1681, "pose", "hold")
	var _t1682 = J.cmp(_s516["f"], 25.0, "<")
	var _t1683 = ((not J.t(v_walking_979)) if _t1682 else _t1682)
	var _t1684 = ((not J.t(J.gp(_s516["n"], "fleeing"))) if _t1683 else _t1683)
	var _t1685 = ((not J.seq(J.typeof_(J.G.get("TOWN")), "undefined")) if _t1684 else _t1684)
	if J.t((J.mc(J.G.get("TOWN"), "actAnim", [_s516["n"]]) if _t1685 else _t1685)):
		var _t1686 = _s516["o"]
		var _t1687 = J.gp(_s516["n"], "act")
		J.sp(_t1686, "pose", _t1687)
	if J.t(_s516["rx"]):
		v_p_987 = J.min_([1.0, J.div(J.gp(_s516["rx"], "t"), J.gp(_s516["rx"], "dur"))])
		var _t1688 = _s516["o"]
		var _t1689 = J.gp(_s516["rx"], "src")
		J.sp(_t1688, "src", _t1689)
		v_jump_988 = Callable(self, "_f231").bind(_s516)
		var _t1696 = J.gp(_s516["rx"], "k")
		var _t1697 = -1
		var _t1698 = false
		if _t1697 == -1 and J.seq(_t1696, "flinch"): _t1697 = 0
		if _t1697 == -1 and J.seq(_t1696, "startle"): _t1697 = 1
		if _t1697 == -1 and J.seq(_t1696, "weakjump"): _t1697 = 2
		if _t1697 == -1 and J.seq(_t1696, "burst"): _t1697 = 3
		if _t1697 == -1 and J.seq(_t1696, "rational"): _t1697 = 4
		if _t1697 == -1 and J.seq(_t1696, "numb"): _t1697 = 5
		if _t1697 == -1 and J.seq(_t1696, "sip"): _t1697 = 6
		if _t1697 == -1 and J.seq(_t1696, "catch"): _t1697 = 7
		if _t1697 == -1 and J.seq(_t1696, "chill"): _t1697 = 8
		while true:
			if _t1697 <= 0 and _t1697 >= 0:
				J.S_Object_("assign", [_s516["o"], {"pose": ("move" if J.t(J.gp(_s516["o"], "walk")) else "hurt"), "pt": v_p_987, "face": "s", "sx": (1.0 + (0.06 * J.sub(1.0, v_p_987))), "sy": (1.0 - (0.06 * J.sub(1.0, v_p_987)))}])
				break
			if _t1697 <= 1 and _t1697 >= 0:
				J.cl(v_jump_988, null, [0.08, (1.1 if J.t(J.gp(_s516["rx"], "big")) else 0.75)])
				break
			if _t1697 <= 2 and _t1697 >= 0:
				J.cl(v_jump_988, null, [0.09, 1.5])
				break
			if _t1697 <= 3 and _t1697 >= 0:
				if J.cmp(J.gp(_s516["rx"], "t"), 0.55, "<"):
					J.cl(v_jump_988, null, [0.07, 1.4])
				else:
					J.S_Object_("assign", [_s516["o"], ({"face": "t", "jit": 1.0, "spd": 1.6} if J.t(J.gp(_s516["o"], "walk")) else {"pose": "cower", "face": "t", "jit": 1.0, "pt": J.min_([1.0, J.div(J.sub(J.gp(_s516["rx"], "t"), 0.55), 0.3)])})])
				break
			if _t1697 <= 4 and _t1697 >= 0:
				v_sh_993 = sin(J.num((J.min_([1.0, J.div(J.gp(_s516["rx"], "t"), 0.55)]) * PI)))
				J.S_Object_("assign", [_s516["o"], {"face": "q", "sy": (1.0 + J.mul(0.06, v_sh_993)), "sx": (1.0 - J.mul(0.02, v_sh_993)), "lift": J.mul(0.18, v_sh_993), "rot": J.mul((-0.06), v_sh_993), "shrug": v_sh_993}])
				if (not J.t(J.gp(_s516["o"], "walk"))):
					var _t1699 = _s516["o"]
					J.sp(_t1699, "pose", "shrug")
					var _t1700 = _s516["o"]
					var _t1701 = J.min_([1.0, J.div(J.gp(_s516["rx"], "t"), 0.9)])
					J.sp(_t1700, "pt", _t1701)
				break
			if _t1697 <= 5 and _t1697 >= 0:
				var _t1702 = _s516["o"]
				J.sp(_t1702, "face", "b")
				if (not J.t(J.gp(_s516["o"], "walk"))):
					var _t1703 = _s516["o"]
					var _t1704 = ("phone" if J.seq(J.gp(v_d_976, "k"), "ken") else ("mop" if J.t(J.gp(v_d_976, "mop")) else ("hold" if J.seq(J.gp(v_d_976, "k"), "boss") else "idle")))
					J.sp(_t1703, "pose", _t1704)
				break
			if _t1697 <= 6 and _t1697 >= 0:
				if (not J.t(J.gp(_s516["o"], "walk"))):
					var _t1705 = _s516["o"]
					J.sp(_t1705, "pose", "sip")
				var _t1706 = _s516["o"]
				J.sp(_t1706, "face", "c")
				break
			if _t1697 <= 7 and _t1697 >= 0:
				var _t1707 = _s516["o"]
				J.sp(_t1707, "pose", "look")
				var _t1708 = _s516["o"]
				J.sp(_t1708, "face", "q")
				var _t1709 = _s516["o"]
				J.sp(_t1709, "walk", false)
				break
			if _t1697 <= 8 and _t1697 >= 0:
				v_t2_994 = J.gp(_s516["rx"], "t")
				v_sh_995 = ((1.0 - J.div(v_t2_994, 0.7)) if J.cmp(v_t2_994, 0.7, "<") else 0.0)
				v_sq_996 = J.min_([1.0, J.div(absf(J.num(J.sub(v_t2_994, 0.9))), 0.12), J.div(absf(J.num(J.sub(v_t2_994, 1.9))), 0.12)])
				J.S_Object_("assign", [_s516["o"], {"face": ("s" if J.cmp(v_t2_994, 0.7, "<") else "q"), "jit": J.mul(0.5, v_sh_995), "sy": (1.0 - J.mul(0.06, v_sh_995)), "sx": ((1.0 + J.mul(0.03, v_sh_995)) * (0.45 + J.mul(0.55, v_sq_996)))}])
				if (not J.t(J.gp(_s516["o"], "walk"))):
					var _t1710 = _s516["o"]
					var _t1711 = ("tremble" if J.cmp(v_t2_994, 0.7, "<") else "look")
					J.sp(_t1710, "pose", _t1711)
				var _t1712 = _s516["o"]
				var _t1713 = J.cmp(v_t2_994, 0.9, ">")
				var _t1714 = (J.cmp(v_t2_994, 1.9, "<") if _t1713 else _t1713)
				J.sp(_t1712, "turn", _t1714)
				var _t1715 = _s516["o"]
				var _t1716 = (0.0 if J.cmp(v_t2_994, 0.9, "<") else (J.div(J.sub(v_t2_994, 0.9), 0.25) if J.cmp(v_t2_994, 1.15, "<") else (1.0 if J.cmp(v_t2_994, 1.65, "<") else ((1.0 - J.div(J.sub(v_t2_994, 1.65), 0.25)) if J.cmp(v_t2_994, 1.9, "<") else 0.0))))
				J.sp(_t1715, "turnK", _t1716)
				break
			break
		var _t1717 = _s516["o"]
		var _t1718 = J.gp(_s516["rx"], "k")
		J.sp(_t1717, "rxk", _t1718)
	return _s516["o"]

func _f232(this_, a: Array, env):
	var v_ctx_999 = null; var v_n_1000 = null; var v_t_1001 = null; var v_vp_1002 = null; var v_x_1003 = null; var v_y_1004 = null; var v_hh_1005 = null; var v_d_1006 = null; var v_o_1007 = null; var v_right_1008 = null; var v_rig_1009 = null; var v_jx_1010 = null; var v_jy_1011 = null; var v_lift_1012 = null; var v_shk_1013 = null; var v_sit_1014 = null; var v_nap_1015 = null; var v_sx_1016 = null; var v_sy_1017 = null; var v_sh_1018 = null; var v_r_1019 = null; var v_o_1020 = null
	v_ctx_999 = J.arg(a, 0)
	v_n_1000 = J.arg(a, 1)
	v_t_1001 = J.arg(a, 2)
	var _t1719 = J.mc(this_, "office", [])
	var _t1720 = (J.mc(J.G.get("OFFICE"), "seated", [v_n_1000]) if J.t(_t1719) else _t1719)
	if J.t(((not J.t(J.gp(v_n_1000, "out"))) if J.t(_t1720) else _t1720)):
		var _t1721 = J.add(J.gp(v_n_1000, "x"), J.mc(J.G.get("OFFICE"), "kenOff", [v_n_1000]))
		J.sp(v_n_1000, "vX", _t1721)
		var _t1722 = J.gp(v_n_1000, "y")
		J.sp(v_n_1000, "vY", _t1722)
		var _t1723 = J.mc(this_, "pt", [J.gp(v_n_1000, "vX"), J.gp(v_n_1000, "y")])
		var _t1724 = J.gp(_t1723, 0.0)
		v_sx_1016 = _t1724
		var _t1725 = J.gp(_t1723, 1.0)
		v_sy_1017 = _t1725
		v_sh_1018 = J.mc(this_, "hh", [J.gp(v_n_1000, "y")])
		if J.seq(v_n_1000, J.gp(this_, "sel")):
			J.sp(v_ctx_999, "fillStyle", "rgba(160,255,200,.28)")
			J.mc(v_ctx_999, "beginPath", [])
			J.mc(v_ctx_999, "ellipse", [J.sub(v_sx_1016, J.mul(v_sh_1018, 0.12)), v_sy_1017, J.mul(v_sh_1018, 0.4), J.mul(v_sh_1018, 0.09), 0.0, 0.0, (PI * 2.0)])
			J.mc(v_ctx_999, "fill", [])
		v_r_1019 = J.mc(J.G.get("OFFICE"), "drawKen", [v_ctx_999, v_n_1000, v_t_1001])
		v_o_1020 = J.mc(this_, "npcPose", [v_n_1000])
		J.sp(v_o_1020, "pose", "seat")
		J.mc(this_, "npcFx", [v_ctx_999, v_n_1000, v_o_1020, J.gp(v_r_1019, "x"), J.add(J.gp(v_r_1019, "top"), J.gp(v_r_1019, "H")), J.gp(v_r_1019, "H"), false, v_t_1001])
		return {"x": J.gp(v_r_1019, "x"), "top": J.gp(v_r_1019, "top")}
	var _t1726 = J.mc(this_, "office", [])
	if J.t((J.gp(v_n_1000, "gone") if J.t(_t1726) else _t1726)):
		var _t1727 = J.max_([0.0, (1.0 - J.div(J.sub(J.gp(this_, "t"), J.gp(v_n_1000, "exitT")), 0.8))])
		J.sp(v_ctx_999, "globalAlpha", _t1727)
	else:
		if J.t(J.gp(v_n_1000, "out")):
			var _t1729 = J.gp(this_, "t")
			var _t1728 = J.gp(v_n_1000, "outAt")
			var _t1731 = J.gp(this_, "t")
			var _t1730 = J.gp(v_n_1000, "outAt")
			var _t1732 = J.max_([0.0, (1.0 - J.div(J.sub(_t1731, (_t1730 if J.t(_t1730) else 0.0)), 0.6))])
			J.sp(v_ctx_999, "globalAlpha", _t1732)
		else:
			var _t1733 = (not J.leq(J.gp(v_n_1000, "inAt"), null))
			if ((J.sub(J.gp(this_, "t"), J.gp(v_n_1000, "inAt")) < 0.6) if _t1733 else _t1733):
				var _t1734 = J.min_([1.0, J.div(J.sub(J.gp(this_, "t"), J.gp(v_n_1000, "inAt")), 0.6)])
				J.sp(v_ctx_999, "globalAlpha", _t1734)
	v_vp_1002 = J.mc(this_, "visPos", [v_n_1000])
	if J.t(J.mc(this_, "office", [])):
		var _t1735 = J.add(J.gp(v_vp_1002, 0.0), J.mc(J.G.get("OFFICE"), "kenOff", [v_n_1000]))
		J.sp(v_vp_1002, 0.0, _t1735)
	var _t1736 = J.mc(this_, "pt", [J.gp(v_vp_1002, 0.0), J.gp(v_vp_1002, 1.0)])
	var _t1737 = J.gp(_t1736, 0.0)
	v_x_1003 = _t1737
	var _t1738 = J.gp(_t1736, 1.0)
	v_y_1004 = _t1738
	v_hh_1005 = J.mc(this_, "hh", [J.gp(v_vp_1002, 1.0)])
	v_d_1006 = J.gp(v_n_1000, "d")
	var _t1739 = J.gp(v_vp_1002, 0.0)
	J.sp(v_n_1000, "vX", _t1739)
	var _t1740 = J.gp(v_vp_1002, 1.0)
	J.sp(v_n_1000, "vY", _t1740)
	v_o_1007 = J.mc(this_, "npcPose", [v_n_1000])
	var _t1741 = J.gp(v_o_1007, "spd")
	J.sp(v_n_1000, "spd", _t1741)
	v_right_1008 = (J.cmp(J.gp(v_vp_1002, 2.0), 0.0, ">") if (not J.leq(J.gp(v_vp_1002, 2.0), null)) else J.cmp(J.gp(v_n_1000, "dir"), 0.0, ">"))
	var _t1742 = (not J.leq(J.gp(v_o_1007, "src"), null))
	var _t1743 = ((not J.t(J.gp(v_d_1006, "guard"))) if _t1742 else _t1742)
	var _t1744 = ((not J.t(J.gp(v_o_1007, "walk"))) if _t1743 else _t1743)
	if ((not J.t(J.gp(v_o_1007, "run"))) if _t1744 else _t1744):
		var _t1745 = J.cmp(J.gp(v_o_1007, "src"), J.gp(v_vp_1002, 0.0), ">=")
		v_right_1008 = _t1745
	if J.t(J.gp(v_o_1007, "turn")):
		v_right_1008 = (not J.t(v_right_1008))
	v_rig_1009 = J.mc(this_, "rigOK", [J.gp(v_d_1006, "spr")])
	v_jx_1010 = (J.mul(((randf() - 0.5) * 3.2), J.gp(v_o_1007, "jit")) if J.t(J.gp(v_o_1007, "jit")) else 0.0)
	v_jy_1011 = (J.mul(((randf() - 0.5) * 1.2), J.gp(v_o_1007, "jit")) if J.t(J.gp(v_o_1007, "jit")) else 0.0)
	v_lift_1012 = (J.mul(J.gp(v_o_1007, "lift"), v_hh_1005) * (0.1 if J.t(v_rig_1009) else 0.16))
	var _t1746 = J.seq(v_n_1000, J.gp(this_, "sel"))
	var _t1747 = ((not J.t(J.gp(v_n_1000, "gone"))) if _t1746 else _t1746)
	if ((not J.t(J.gp(v_n_1000, "fleeing"))) if _t1747 else _t1747):
		J.sp(v_ctx_999, "fillStyle", "rgba(160,255,200,.28)")
		J.mc(v_ctx_999, "beginPath", [])
		J.mc(v_ctx_999, "ellipse", [v_x_1003, v_y_1004, J.mul(v_hh_1005, 0.34), J.mul(v_hh_1005, 0.08), 0.0, 0.0, (PI * 2.0)])
		J.mc(v_ctx_999, "fill", [])
	v_shk_1013 = (1.0 - J.min_([0.5, J.mul(J.gp(v_o_1007, "lift"), 0.35)]))
	J.sp(v_ctx_999, "fillStyle", "rgba(0,0,0,.35)")
	J.mc(v_ctx_999, "beginPath", [])
	J.mc(v_ctx_999, "ellipse", [v_x_1003, v_y_1004, (J.mul(J.mul(v_hh_1005, 0.22), v_shk_1013) * (1.2 if J.seq(J.gp(v_o_1007, "pose"), "cower") else 1.0)), J.mul(J.mul(v_hh_1005, 0.05), v_shk_1013), 0.0, 0.0, (PI * 2.0)])
	J.mc(v_ctx_999, "fill", [])
	v_sit_1014 = (J.mul(v_hh_1005, 0.22) if J.t(J.mc(this_, "sitting", [v_n_1000])) else 0.0)
	var _t1748 = (J.seq(J.gp(v_d_1006, "k"), "mis") if J.t(v_sit_1014) else v_sit_1014)
	if J.t(((not J.t(J.gp(v_o_1007, "src"))) if J.t(_t1748) else _t1748)):
		v_right_1008 = true
	J.mc(v_ctx_999, "save", [])
	if J.t(v_sit_1014):
		J.mc(v_ctx_999, "beginPath", [])
		J.mc(v_ctx_999, "rect", [J.sub(v_x_1003, v_hh_1005), J.sub(v_y_1004, J.mul(v_hh_1005, 2.0)), J.mul(v_hh_1005, 2.0), (J.mul(v_hh_1005, 2.0) - J.mul(v_hh_1005, 0.02))])
		J.mc(v_ctx_999, "clip", [])
	J.mc(v_ctx_999, "translate", [J.add(v_x_1003, v_jx_1010), J.add(J.sub(J.add(v_y_1004, v_jy_1011), v_lift_1012), v_sit_1014)])
	if J.t(J.gp(v_o_1007, "rot")):
		J.mc(v_ctx_999, "rotate", [J.mul(J.gp(v_o_1007, "rot"), (1.0 if J.t(v_right_1008) else (-1.0)))])
	J.mc(v_ctx_999, "scale", [J.gp(v_o_1007, "sx"), J.gp(v_o_1007, "sy")])
	if J.t(J.gp(v_d_1006, "tint")):
		var _t1749 = J.gp(v_d_1006, "tint")
		J.sp(v_ctx_999, "filter", _t1749)
	var _t1750 = J.seq(J.gp(v_d_1006, "k"), "mis")
	var _t1751 = (J.mc(this_, "office", []) if _t1750 else _t1750)
	if J.t((J.mc(J.G.get("OFFICE"), "drawMis", [v_ctx_999, v_n_1000, v_o_1007, v_hh_1005, v_right_1008, v_t_1001]) if J.t(_t1751) else _t1751)):
		pass
	else:
		if J.t(v_rig_1009):
			var _t1753 = J.gp(v_d_1006, "spr")
			var _t1754 = J.div(v_hh_1005, J.G.get("NPC_UNIT"))
			var _t1752 = J.gp(v_n_1000, "at")
			J.mc(J.G.get("ART"), "drawChar", [v_ctx_999, _t1753, 0.0, 0.0, _t1754, J.S_Object_("assign", [{"t": (_t1752 if J.t(_t1752) else 0.0), "pose": J.gp(v_o_1007, "pose"), "pt": J.gp(v_o_1007, "pt"), "face": J.gp(v_o_1007, "face"), "flip": (not J.t(v_right_1008)), "walk": J.gp(v_o_1007, "walk"), "shadow": false}, (J.mc(J.G.get("TOWN"), "npcOpts", [v_n_1000]) if (not J.seq(J.typeof_(J.G.get("TOWN")), "undefined")) else {})])])
		else:
			J.mc(this_, "drawNpcSprite", [v_ctx_999, v_n_1000, v_o_1007, v_hh_1005, v_right_1008])
	J.sp(v_ctx_999, "filter", "none")
	J.mc(v_ctx_999, "restore", [])
	var _t1755 = J.gp(v_d_1006, "mop")
	var _t1756 = (J.seq(J.gp(v_o_1007, "pose"), "mop") if J.t(_t1755) else _t1755)
	if J.t(((randf() < 0.05) if J.t(_t1756) else _t1756)):
		var _t1757 = J.gp(this_, "parts")
		J.mc(_t1757, "push", [{"kind": "drop", "x": J.add(J.gp(v_vp_1002, 0.0), ((1.0 if J.t(v_right_1008) else (-1.0)) * 0.05)), "y": J.gp(v_vp_1002, 1.0), "vx": 0.0, "vy": 0.0, "life": 1.4}])
	J.mc(this_, "npcFx", [v_ctx_999, v_n_1000, v_o_1007, J.add(v_x_1003, v_jx_1010), J.sub(v_y_1004, v_lift_1012), v_hh_1005, v_right_1008, v_t_1001])
	J.sp(v_ctx_999, "globalAlpha", 1.0)
	var _t1758 = J.seq(J.gp(v_n_1000, "act"), "brk_nap")
	var _t1759 = (J.gp(v_n_1000, "daily") if _t1758 else _t1758)
	var _t1760 = (J.gp(J.gp(v_n_1000, "daily"), "forced") if J.t(_t1759) else _t1759)
	v_nap_1015 = (J.mul(v_hh_1005, 0.15) if J.t((J.cmp(J.gp(J.gp(v_n_1000, "daily"), "w"), 0.5, ">") if J.t(_t1760) else _t1760)) else 0.0)
	return {"x": v_x_1003, "top": J.sub(J.add(J.add(J.sub(v_y_1004, v_lift_1012), v_sit_1014), v_nap_1015), J.mul(J.mul(v_hh_1005, (0.8 if J.seq(J.gp(v_o_1007, "pose"), "cower") else 1.0)), J.gp(v_o_1007, "sy")))}

func _f233(this_, a: Array, env):
	var v_ctx_1023 = null; var v_n_1024 = null; var v_o_1025 = null; var v_hh_1026 = null; var v_right_1027 = null; var v_spr_1028 = null; var v_w_1029 = null; var v_a_1030 = null; var v_bob_1031 = null; var v_tilt_1032 = null; var v_sx_1033 = null; var v_sy_1034 = null
	v_ctx_1023 = J.arg(a, 0)
	v_n_1024 = J.arg(a, 1)
	v_o_1025 = J.arg(a, 2)
	v_hh_1026 = J.arg(a, 3)
	v_right_1027 = J.arg(a, 4)
	v_spr_1028 = J.gp(J.G.get("SPR"), J.gp(J.gp(v_n_1024, "d"), "spr"))
	var _t1761 = (not J.t(v_spr_1028))
	var _t1762 = (_t1761 if _t1761 else (not J.t(J.gp(v_spr_1028, "complete"))))
	if (_t1762 if _t1762 else (not J.t(J.gp(v_spr_1028, "naturalWidth")))):
		return null
	v_w_1029 = J.div(J.mul(v_hh_1026, J.gp(v_spr_1028, "naturalWidth")), J.gp(v_spr_1028, "naturalHeight"))
	var _t1763 = J.gp(v_n_1024, "at")
	v_a_1030 = (_t1763 if J.t(_t1763) else 0.0)
	v_bob_1031 = 0.0
	v_tilt_1032 = 0.0
	v_sx_1033 = 1.0
	v_sy_1034 = (1.0 + (sin(J.num(J.mul(v_a_1030, 2.2))) * 0.012))
	var _t1764 = J.gp(v_o_1025, "pose")
	var _t1765 = -1
	var _t1766 = false
	if _t1765 == -1 and J.seq(_t1764, "move"): _t1765 = 0
	if _t1765 == -1 and J.seq(_t1764, "run"): _t1765 = 1
	if _t1765 == -1 and J.seq(_t1764, "startle"): _t1765 = 2
	if _t1765 == -1 and J.seq(_t1764, "cower"): _t1765 = 3
	if _t1765 == -1 and J.seq(_t1764, "tremble"): _t1765 = 4
	if _t1765 == -1 and J.seq(_t1764, "phone"): _t1765 = 5
	if _t1765 == -1 and J.seq(_t1764, "mop"): _t1765 = 6
	if _t1765 == -1 and J.seq(_t1764, "look"): _t1765 = 7
	if _t1765 == -1 and J.seq(_t1764, "hurt"): _t1765 = 8
	if _t1765 == -1 and J.seq(_t1764, "sip"): _t1765 = 9
	while true:
		if _t1765 <= 0 and _t1765 >= 0:
			var _t1767 = (J.mul(absf(J.num(sin(J.num(J.mul(v_a_1030, 9.0))))), v_hh_1026) * 0.05)
			v_bob_1031 = _t1767
			var _t1768 = (sin(J.num(J.mul(v_a_1030, 9.0))) * 0.04)
			v_tilt_1032 = _t1768
			break
		if _t1765 <= 1 and _t1765 >= 0:
			var _t1769 = (J.mul(absf(J.num(sin(J.num(J.mul(v_a_1030, 11.0))))), v_hh_1026) * 0.08)
			v_bob_1031 = _t1769
			var _t1770 = (0.22 + (sin(J.num(J.mul(v_a_1030, 11.0))) * 0.06))
			v_tilt_1032 = _t1770
			v_sx_1033 = 1.04
			break
		if _t1765 <= 2 and _t1765 >= 0:
			var _t1771 = ((-0.25) * sin(J.num((J.min_([1.0, J.mul(J.gp(v_o_1025, "pt"), 1.6)]) * PI))))
			v_tilt_1032 = _t1771
			break
		if _t1765 <= 3 and _t1765 >= 0:
			var _t1772 = (0.8 + (sin(J.num(J.mul(v_a_1030, 30.0))) * 0.015))
			v_sy_1034 = _t1772
			v_sx_1033 = 1.1
			v_tilt_1032 = 0.12
			break
		if _t1765 <= 4 and _t1765 >= 0:
			var _t1773 = (sin(J.num(J.mul(v_a_1030, 40.0))) * 0.025)
			v_tilt_1032 = _t1773
			break
		if _t1765 <= 5 and _t1765 >= 0:
			var _t1774 = (0.06 + (sin(J.num(J.mul(v_a_1030, 1.3))) * 0.01))
			v_tilt_1032 = _t1774
			break
		if _t1765 <= 6 and _t1765 >= 0:
			var _t1775 = (sin(J.num(J.mul(v_a_1030, 4.0))) * 0.06)
			v_tilt_1032 = _t1775
			break
		if _t1765 <= 7 and _t1765 >= 0:
			var _t1776 = (sin(J.num(J.mul(v_a_1030, 1.6))) * 0.05)
			v_tilt_1032 = _t1776
			break
		if _t1765 <= 8 and _t1765 >= 0:
			var _t1777 = ((-0.2) * J.sub(1.0, J.gp(v_o_1025, "pt")))
			v_tilt_1032 = _t1777
			break
		if _t1765 <= 9 and _t1765 >= 0:
			var _t1778 = ((-0.05) + (sin(J.num(J.mul(v_a_1030, 1.2))) * 0.03))
			v_tilt_1032 = _t1778
			break
		break
	J.mc(v_ctx_1023, "translate", [0.0, (-J.num(v_bob_1031))])
	J.mc(v_ctx_1023, "rotate", [J.mul(v_tilt_1032, (1.0 if J.t(v_right_1027) else (-1.0)))])
	J.mc(v_ctx_1023, "scale", [J.mul((1.0 if J.t(v_right_1027) else (-1.0)), v_sx_1033), v_sy_1034])
	J.mc(v_ctx_1023, "drawImage", [v_spr_1028, J.div((-J.num(v_w_1029)), 2.0), (-J.num(v_hh_1026)), v_w_1029, v_hh_1026])

func _f235(this_, a: Array, env):
	var v_ch_1088 = null; var v_i_1089 = null; var v_ox_1090 = null; var v_oy_1091 = null
	v_ch_1088 = J.arg(a, 0)
	v_i_1089 = J.arg(a, 1)
	v_ox_1090 = J.add(J.add(env["x0"], J.mul(v_i_1089, env["step"])), ((randf() - 0.5) * 3.0))
	v_oy_1091 = ((J.sub(env["__p"]["y"], J.mul(env["__p"]["hh"], 0.5)) + (sin(J.num(J.add(J.mul(env["__p"]["t"], 25.0), v_i_1089))) * 2.5)) - J.mul(v_i_1089, 1.5))
	J.mc(env["__p"]["ctx"], "strokeText", [v_ch_1088, v_ox_1090, v_oy_1091])
	J.mc(env["__p"]["ctx"], "fillText", [v_ch_1088, v_ox_1090, v_oy_1091])

func _f234(this_, a: Array, env):
	var v_n_1038 = null; var v_o_1039 = null; var v_x_1040 = null; var v_right_1043 = null; var v_side_1045 = null; var v_hy_1046 = null; var v_hx_1047 = null; var v_goose_1048 = null; var v_gx_1049 = null; var v_gy_1050 = null; var v_r_1051 = null; var v_fl_1052 = null; var v_g_1053 = null; var v_s_1054 = null; var v_i_1055 = null; var v_bx_1056 = null; var v_by_1057 = null; var v_j_1058 = null; var v_k_1059 = null; var v_i_1060 = null; var v_bx_1061 = null; var v_by_1062 = null; var v_k_1063 = null; var v_i_1064 = null; var v_a_1065 = null; var v_r0_1066 = null; var v_r1_1067 = null; var v_dx_1068 = null; var v_dy_1069 = null; var v_i_1070 = null; var v_bx_1071 = null; var v_s_1072 = null; var v_s_1073 = null; var v_i_1074 = null; var v_r_1075 = null; var v_i_1076 = null; var v_q_1077 = null; var v_i_1078 = null; var v_ly_1079 = null; var v_lx_1080 = null; var v_k_1081 = null; var v_chars_1082 = null; var v_fs_1083 = null; var v_w_1085 = null; var v_sd_1086 = null
	var _s536 = {"__p": env, "ctx": null, "y": null, "hh": null, "t": null}
	_s536["ctx"] = J.arg(a, 0)
	v_n_1038 = J.arg(a, 1)
	v_o_1039 = J.arg(a, 2)
	v_x_1040 = J.arg(a, 3)
	_s536["y"] = J.arg(a, 4)
	_s536["hh"] = J.arg(a, 5)
	v_right_1043 = J.arg(a, 6)
	_s536["t"] = J.arg(a, 7)
	v_side_1045 = (1.0 if J.t(v_right_1043) else (-1.0))
	v_hy_1046 = J.sub(_s536["y"], J.mul(_s536["hh"], 0.86))
	v_hx_1047 = J.add(v_x_1040, (J.mul(v_side_1045, _s536["hh"]) * 0.03))
	J.mc(_s536["ctx"], "save", [])
	var _t1779 = _s536["ctx"]
	J.sp(_t1779, "lineCap", "round")
	var _t1780 = J.seq(J.gp(v_o_1039, "pose"), "phone")
	if ((not J.t(J.gp(v_o_1039, "rxk"))) if _t1780 else _t1780):
		v_gx_1049 = J.add(v_x_1040, (J.mul(v_side_1045, _s536["hh"]) * 0.14))
		v_gy_1050 = J.sub(_s536["y"], J.mul(_s536["hh"], 0.66))
		v_r_1051 = J.mul(_s536["hh"], 0.3)
		v_fl_1052 = ((0.3 + (0.06 * sin(J.num(J.add(J.mul(_s536["t"], 3.0), J.gp(v_n_1038, "ph")))))) + (0.15 if (sin(J.num(J.add(J.mul(_s536["t"], 0.7), J.gp(v_n_1038, "ph")))) > 0.92) else 0.0))
		v_g_1053 = J.mc(_s536["ctx"], "createRadialGradient", [v_gx_1049, v_gy_1050, 0.0, v_gx_1049, v_gy_1050, v_r_1051])
		J.mc(v_g_1053, "addColorStop", [0.0, ("rgba(150,220,255," + J.str(v_fl_1052) + ")")])
		J.mc(v_g_1053, "addColorStop", [1.0, "rgba(150,220,255,0)"])
		var _t1781 = _s536["ctx"]
		J.sp(_t1781, "globalCompositeOperation", "lighter")
		var _t1782 = _s536["ctx"]
		J.sp(_t1782, "fillStyle", v_g_1053)
		J.mc(_s536["ctx"], "beginPath", [])
		J.mc(_s536["ctx"], "arc", [v_gx_1049, v_gy_1050, v_r_1051, 0.0, (PI * 2.0)])
		J.mc(_s536["ctx"], "fill", [])
		var _t1783 = _s536["ctx"]
		J.sp(_t1783, "globalCompositeOperation", "source-over")
	var _t1784 = J.gp(v_n_1038, "goose")
	var _t1786 = (_t1784 if J.t(_t1784) else 0.0)
	var _t1785 = J.seq(J.gp(v_o_1039, "face"), "f")
	var _t1787 = J.gp(v_n_1038, "goose")
	var _t1789 = (_t1787 if J.t(_t1787) else 0.0)
	var _t1788 = J.seq(J.gp(v_o_1039, "face"), "f")
	v_goose_1048 = J.max_([_t1789, (0.6 if (_t1788 if _t1788 else J.seq(J.gp(v_o_1039, "face"), "t")) else 0.0)])
	if J.cmp(v_goose_1048, 0.0, ">"):
		var _t1790 = _s536["ctx"]
		var _t1791 = ("rgba(255,255,255," + J.str(J.min_([0.85, J.mul(v_goose_1048, 0.7)])) + ")")
		J.sp(_t1790, "strokeStyle", _t1791)
		var _t1792 = _s536["ctx"]
		J.sp(_t1792, "lineWidth", 1.4)
		for _t1793 in J.iter([(-1.0), 1.0]):
			v_s_1054 = _t1793
			v_i_1055 = 0.0
			while true:
				if not J.cmp(v_i_1055, 3.0, "<"): break
				v_bx_1056 = J.add(v_x_1040, (J.mul(v_s_1054, _s536["hh"]) * (0.24 + (0.03 * sin(J.num(J.add(J.mul(_s536["t"], 20.0), v_i_1055)))))))
				v_by_1057 = J.sub(_s536["y"], J.mul(_s536["hh"], (0.62 - J.mul(v_i_1055, 0.09))))
				J.mc(_s536["ctx"], "beginPath", [])
				J.mc(_s536["ctx"], "moveTo", [v_bx_1056, v_by_1057])
				v_j_1058 = 1.0
				while true:
					if not J.cmp(v_j_1058, 3.0, "<="): break
					J.mc(_s536["ctx"], "lineTo", [J.add(v_bx_1056, (J.mul(v_s_1054, v_j_1058) * 3.0)), J.add(v_by_1057, ((-3.0) if J.t(J.mod(v_j_1058, 2.0)) else 3.0))])
					v_j_1058 = J.num(v_j_1058) + 1.0
				J.mc(_s536["ctx"], "stroke", [])
				v_i_1055 = J.num(v_i_1055) + 1.0
	if J.cmp(J.gp(v_n_1038, "hair"), 0.0, ">"):
		v_k_1059 = J.min_([1.0, J.gp(v_n_1038, "hair")])
		var _t1794 = _s536["ctx"]
		var _t1795 = ("rgba(30,24,30," + J.str(v_k_1059) + ")")
		J.sp(_t1794, "strokeStyle", _t1795)
		var _t1796 = _s536["ctx"]
		J.sp(_t1796, "lineWidth", 2.0)
		v_i_1060 = (-2.0)
		while true:
			if not J.cmp(v_i_1060, 2.0, "<="): break
			v_bx_1061 = J.add(v_hx_1047, (J.mul(v_i_1060, _s536["hh"]) * 0.045))
			v_by_1062 = J.sub(v_hy_1046, J.mul(_s536["hh"], 0.06))
			J.mc(_s536["ctx"], "beginPath", [])
			J.mc(_s536["ctx"], "moveTo", [v_bx_1061, v_by_1062])
			J.mc(_s536["ctx"], "quadraticCurveTo", [J.add(v_bx_1061, (sin(J.num(J.add(J.mul(_s536["t"], 50.0), v_i_1060))) * 2.5)), J.sub(v_by_1062, J.mul(J.mul(_s536["hh"], 0.07), v_k_1059)), J.add(v_bx_1061, J.mul(v_i_1060, 1.5)), J.sub(v_by_1062, J.mul(J.mul(_s536["hh"], 0.14), v_k_1059))])
			J.mc(_s536["ctx"], "stroke", [])
			v_i_1060 = J.num(v_i_1060) + 1.0
	if J.cmp(J.gp(v_n_1038, "shock"), 0.0, ">"):
		v_k_1063 = (1.0 - J.div(J.gp(v_n_1038, "shock"), 0.5))
		var _t1797 = _s536["ctx"]
		var _t1798 = ("rgba(255,236,150," + J.str(J.min_([1.0, J.mul(J.gp(v_n_1038, "shock"), 3.0)])) + ")")
		J.sp(_t1797, "strokeStyle", _t1798)
		var _t1799 = _s536["ctx"]
		J.sp(_t1799, "lineWidth", 2.2)
		v_i_1064 = 0.0
		while true:
			if not J.cmp(v_i_1064, 9.0, "<"): break
			v_a_1065 = ((((-PI) * 0.95) + (J.div((J.mul(v_i_1064, PI) * 0.95), 8.0) * 1.0)) - 0.05)
			v_r0_1066 = J.mul(_s536["hh"], (0.2 + J.mul(v_k_1063, 0.08)))
			v_r1_1067 = J.add(v_r0_1066, J.mul(_s536["hh"], 0.1))
			J.mc(_s536["ctx"], "beginPath", [])
			J.mc(_s536["ctx"], "moveTo", [J.add(v_hx_1047, J.mul(cos(J.num(v_a_1065)), v_r0_1066)), J.add(v_hy_1046, J.mul(sin(J.num(v_a_1065)), v_r0_1066))])
			J.mc(_s536["ctx"], "lineTo", [J.add(v_hx_1047, J.mul(cos(J.num(v_a_1065)), v_r1_1067)), J.add(v_hy_1046, J.mul(sin(J.num(v_a_1065)), v_r1_1067))])
			J.mc(_s536["ctx"], "stroke", [])
			v_i_1064 = J.num(v_i_1064) + 1.0
	var _t1800 = J.seq(J.gp(v_o_1039, "rxk"), "rational")
	if (_t1800 if _t1800 else J.seq(J.gp(v_o_1039, "rxk"), "numb")):
		var _t1801 = _s536["ctx"]
		J.sp(_t1801, "strokeStyle", "rgba(40,40,90,.75)")
		var _t1802 = _s536["ctx"]
		J.sp(_t1802, "lineWidth", 1.6)
		v_i_1070 = 0.0
		while true:
			if not J.cmp(v_i_1070, 3.0, "<"): break
			v_bx_1071 = (J.sub(v_hx_1047, (J.mul(v_side_1045, _s536["hh"]) * 0.02)) + (J.mul(J.sub(v_i_1070, 1.0), _s536["hh"]) * 0.035))
			J.mc(_s536["ctx"], "beginPath", [])
			J.mc(_s536["ctx"], "moveTo", [v_bx_1071, J.sub(v_hy_1046, J.mul(_s536["hh"], 0.02))])
			J.mc(_s536["ctx"], "lineTo", [v_bx_1071, J.add(v_hy_1046, J.mul(_s536["hh"], (0.06 + (0.02 if J.seq(v_i_1070, 1.0) else 0.0))))])
			J.mc(_s536["ctx"], "stroke", [])
			v_i_1070 = J.num(v_i_1070) + 1.0
		v_dx_1068 = J.sub(v_hx_1047, (J.mul(v_side_1045, _s536["hh"]) * 0.13))
		v_dy_1069 = J.add(J.add(v_hy_1046, J.mul(_s536["hh"], 0.02)), ((J.mul(J.min_([1.0, J.gp(J.gp(v_n_1038, "rx"), "t")]), _s536["hh"]) * 0.05) if J.t(J.gp(v_n_1038, "rx")) else 0.0))
		var _t1803 = _s536["ctx"]
		J.sp(_t1803, "fillStyle", "rgba(160,215,255,.95)")
		J.mc(_s536["ctx"], "beginPath", [])
		J.mc(_s536["ctx"], "moveTo", [v_dx_1068, J.sub(v_dy_1069, 6.0)])
		J.mc(_s536["ctx"], "quadraticCurveTo", [J.add(v_dx_1068, 4.5), J.add(v_dy_1069, 2.0), v_dx_1068, J.add(v_dy_1069, 3.5)])
		J.mc(_s536["ctx"], "quadraticCurveTo", [J.sub(v_dx_1068, 4.5), J.add(v_dy_1069, 2.0), v_dx_1068, J.sub(v_dy_1069, 6.0)])
		J.mc(_s536["ctx"], "fill", [])
		if J.cmp(J.gp(v_o_1039, "shrug"), 0.2, ">"):
			var _t1804 = _s536["ctx"]
			var _t1805 = ("rgba(255,255,255," + J.str(J.mul(J.gp(v_o_1039, "shrug"), 0.7)) + ")")
			J.sp(_t1804, "strokeStyle", _t1805)
			var _t1806 = _s536["ctx"]
			J.sp(_t1806, "lineWidth", 1.5)
			for _t1807 in J.iter([(-1.0), 1.0]):
				v_s_1072 = _t1807
				J.mc(_s536["ctx"], "beginPath", [])
				J.mc(_s536["ctx"], "arc", [J.add(v_x_1040, (J.mul(v_s_1072, _s536["hh"]) * 0.26)), J.sub(_s536["y"], J.mul(_s536["hh"], 0.62)), 5.0, ((-1.2) if J.cmp(v_s_1072, 0.0, ">") else ((PI + 1.2) - 2.4)), (((1.2 - 2.4) + 2.4) if J.cmp(v_s_1072, 0.0, ">") else (PI + 1.2))])
				J.mc(_s536["ctx"], "stroke", [])
	var _t1808 = J.seq(J.gp(v_o_1039, "pose"), "tremble")
	var _t1810 = (_t1808 if _t1808 else J.seq(J.gp(v_o_1039, "pose"), "cower"))
	if not J.t(_t1810):
		var _t1809 = J.cmp(J.gp(v_o_1039, "jit"), 0.5, ">")
		_t1810 = ((not J.t(J.gp(v_o_1039, "run"))) if _t1809 else _t1809)
	if _t1810:
		var _t1811 = _s536["ctx"]
		J.sp(_t1811, "strokeStyle", "rgba(255,200,180,.55)")
		var _t1812 = _s536["ctx"]
		J.sp(_t1812, "lineWidth", 1.5)
		for _t1813 in J.iter([(-1.0), 1.0]):
			v_s_1073 = _t1813
			v_i_1074 = 0.0
			while true:
				if not J.cmp(v_i_1074, 2.0, "<"): break
				v_r_1075 = (J.mul(_s536["hh"], (0.3 + J.mul(v_i_1074, 0.06))) + (sin(J.num(J.mul(_s536["t"], 30.0))) * 1.5))
				J.mc(_s536["ctx"], "beginPath", [])
				J.mc(_s536["ctx"], "arc", [v_x_1040, J.sub(_s536["y"], J.mul(_s536["hh"], 0.45)), v_r_1075, ((-0.35) if J.cmp(v_s_1073, 0.0, ">") else (PI - 0.35)), (0.35 if J.cmp(v_s_1073, 0.0, ">") else (PI + 0.35))])
				J.mc(_s536["ctx"], "stroke", [])
				v_i_1074 = J.num(v_i_1074) + 1.0
	var _t1814 = J.gp(v_o_1039, "doze")
	var _t1817 = ((not J.t(J.gp(v_o_1039, "rxk"))) if J.t(_t1814) else _t1814)
	if J.t(_t1817):
		var _t1815 = J.gp(v_n_1038, "daily")
		var _t1816 = (J.gp(J.gp(v_n_1038, "daily"), "forced") if J.t(_t1815) else _t1815)
		_t1817 = (not J.t((J.cmp(J.gp(J.gp(v_n_1038, "daily"), "w"), 0.0, ">") if J.t(_t1816) else _t1816)))
	if J.t(_t1817):
		var _t1818 = _s536["ctx"]
		J.sp(_t1818, "font", "800 13px sans-serif")
		var _t1819 = _s536["ctx"]
		J.sp(_t1819, "textAlign", "center")
		v_i_1076 = 0.0
		while true:
			if not J.cmp(v_i_1076, 3.0, "<"): break
			v_q_1077 = J.mod((J.mul(_s536["t"], 0.45) + J.div(v_i_1076, 3.0)), 1.0)
			var _t1820 = _s536["ctx"]
			var _t1821 = ("rgba(220,230,255," + J.str((0.85 * sin(J.num(J.mul(v_q_1077, PI))))) + ")")
			J.sp(_t1820, "fillStyle", _t1821)
			J.mc(_s536["ctx"], "fillText", ["Z", J.add(v_x_1040, (J.mul(v_side_1045, _s536["hh"]) * (0.18 + J.mul(v_q_1077, 0.15)))), J.sub(_s536["y"], J.mul(_s536["hh"], (0.95 + J.mul(v_q_1077, 0.3))))])
			v_i_1076 = J.num(v_i_1076) + 1.0
	if J.t(J.gp(v_o_1039, "run")):
		var _t1822 = _s536["ctx"]
		J.sp(_t1822, "strokeStyle", "rgba(255,255,255,.45)")
		var _t1823 = _s536["ctx"]
		J.sp(_t1823, "lineWidth", 2.0)
		v_i_1078 = 0.0
		while true:
			if not J.cmp(v_i_1078, 4.0, "<"): break
			v_ly_1079 = J.sub(_s536["y"], J.mul(_s536["hh"], (0.25 + J.mul(v_i_1078, 0.17))))
			v_lx_1080 = J.sub(v_x_1040, (J.mul(v_side_1045, _s536["hh"]) * (0.3 + (J.mod((J.mul(_s536["t"], 3.0) + J.mul(v_i_1078, 0.37)), 1.0) * 0.15))))
			J.mc(_s536["ctx"], "beginPath", [])
			J.mc(_s536["ctx"], "moveTo", [v_lx_1080, v_ly_1079])
			J.mc(_s536["ctx"], "lineTo", [J.sub(v_lx_1080, (J.mul(v_side_1045, _s536["hh"]) * 0.25)), v_ly_1079])
			J.mc(_s536["ctx"], "stroke", [])
			v_i_1078 = J.num(v_i_1078) + 1.0
	var _t1824 = J.gp(v_o_1039, "run")
	if J.t(((not J.t(J.gp(v_n_1038, "bub"))) if J.t(_t1824) else _t1824)):
		var _s565 = {"__p": _s536, "step": null, "x0": null}
		v_k_1081 = (J.min_([1.0, J.mul(J.gp(v_n_1038, "scream"), 2.0)]) if J.cmp(J.gp(v_n_1038, "scream"), 0.0, ">") else 0.75)
		v_chars_1082 = J.spread([J.SP(("哎呀——！" if J.seq(J.gp(J.gp(v_n_1038, "d"), "k"), "auntie") else "啊——！"))])
		v_fs_1083 = J.round(J.num((14.0 + J.mul(_s565["__p"]["hh"], 0.05))))
		_s565["step"] = J.mul(v_fs_1083, 0.85)
		v_w_1085 = J.mul(_s565["step"], J.len(v_chars_1082))
		v_sd_1086 = v_side_1045
		_s565["x0"] = (J.add(v_x_1040, J.mul(_s565["__p"]["hh"], 0.3)) if J.cmp(v_sd_1086, 0.0, ">") else J.sub(J.sub(v_x_1040, J.mul(_s565["__p"]["hh"], 0.3)), v_w_1085))
		if J.cmp(J.add(_s565["x0"], v_w_1085), J.sub(J.gp(this_, "W"), 6.0), ">"):
			var _t1825 = J.sub(J.sub(v_x_1040, J.mul(_s565["__p"]["hh"], 0.3)), v_w_1085)
			_s565["x0"] = _t1825
		if J.cmp(_s565["x0"], 6.0, "<"):
			var _t1826 = J.add(v_x_1040, J.mul(_s565["__p"]["hh"], 0.3))
			_s565["x0"] = _t1826
		var _t1827 = _s565["__p"]["ctx"]
		var _t1828 = ("900 " + J.str(v_fs_1083) + "px sans-serif")
		J.sp(_t1827, "font", _t1828)
		var _t1829 = _s565["__p"]["ctx"]
		J.sp(_t1829, "textAlign", "left")
		var _t1830 = _s565["__p"]["ctx"]
		J.sp(_t1830, "lineWidth", 3.5)
		var _t1831 = _s565["__p"]["ctx"]
		var _t1832 = ("rgba(0,0,0," + J.str(v_k_1081) + ")")
		J.sp(_t1831, "strokeStyle", _t1832)
		var _t1833 = _s565["__p"]["ctx"]
		var _t1834 = ("rgba(255,96,80," + J.str(v_k_1081) + ")")
		J.sp(_t1833, "fillStyle", _t1834)
		J.mc(v_chars_1082, "forEach", [Callable(self, "_f235").bind(_s565)])
	J.mc(_s536["ctx"], "restore", [])

func _f237(this_, a: Array, env):
	var v_f_1099 = null
	v_f_1099 = J.arg(a, 0)
	return J.seq(J.gp(v_f_1099, "kind"), "ghost")

func _f238(this_, a: Array, env):
	var v_f_1100 = null
	v_f_1100 = J.arg(a, 0)
	return J.gp(v_f_1100, "ghost")

func _f239(this_, a: Array, env):
	var v_n_1101 = null
	v_n_1101 = J.arg(a, 0)
	var _t1838 = J.gp(J.gp(v_n_1101, "d"), "guard")
	return ((not J.t(J.gp(v_n_1101, "gone"))) if J.t(_t1838) else _t1838)

func _f240(this_, a: Array, env):
	var v_k_1102 = null; var v_i_1103 = null; var v_ready_1104 = null; var v_dx_1105 = null; var v_x_1106 = null; var v_y_1107 = null; var v_a_1108 = null; var v_gx_1109 = null; var v_x_1110 = null; var v_y_1111 = null; var v_s_1112 = null; var v_j_1113 = null; var v_sx_1114 = null; var v_sy_1115 = null
	v_k_1102 = J.arg(a, 0)
	v_i_1103 = J.arg(a, 1)
	if J.t(J.mc(env["busy"], "has", [v_k_1102])):
		return null
	var _t1840 = J.gp(J.gp(env["this"], "caught"), v_k_1102)
	if J.t((env["g"] if J.t(_t1840) else _t1840)):
		env["ci"] = J.num(env["ci"]) + 1.0
		v_gx_1109 = J.sub(J.gp(env["g"], "x"), J.mul(J.mul(J.gp(env["g"], "dir"), 0.075), env["ci"]))
		var _t1841 = J.mc(env["this"], "pt", [v_gx_1109, J.add(J.gp(env["g"], "y"), 0.004)])
		var _t1842 = J.gp(_t1841, 0.0)
		v_x_1110 = _t1842
		var _t1843 = J.gp(_t1841, 1.0)
		v_y_1111 = _t1843
		v_s_1112 = J.div(J.mc(env["this"], "hh", [J.gp(env["g"], "y")]), 62.0)
		J.mc(J.G.get("ART"), "drawChar", [env["ctx"], v_k_1102, v_x_1110, v_y_1111, v_s_1112, {"t": J.add(env["t"], v_i_1103), "pose": "idle", "alpha": 0.5, "flip": J.cmp(J.gp(env["g"], "x"), v_gx_1109, "<"), "shadow": false}])
		var _t1844 = env["ctx"]
		J.sp(_t1844, "strokeStyle", "rgba(255,255,255,.35)")
		var _t1845 = env["ctx"]
		J.sp(_t1845, "lineWidth", 1.5)
		v_j_1113 = 0.0
		while true:
			if not J.cmp(v_j_1113, 2.0, "<"): break
			v_sx_1114 = J.add(v_x_1110, (J.sub(v_j_1113, 0.5) * 6.0))
			v_sy_1115 = J.sub(v_y_1111, J.mul(v_s_1112, 66.0))
			J.mc(env["ctx"], "beginPath", [])
			J.mc(env["ctx"], "moveTo", [v_sx_1114, v_sy_1115])
			J.mc(env["ctx"], "bezierCurveTo", [J.add(v_sx_1114, 5.0), (J.sub(v_sy_1115, 6.0) - (sin(J.num(J.add(J.mul(env["t"], 3.0), v_j_1113))) * 3.0)), J.sub(v_sx_1114, 5.0), J.sub(v_sy_1115, 12.0), J.add(v_sx_1114, (sin(J.num(J.add(J.mul(env["t"], 2.0), v_j_1113))) * 3.0)), J.sub(v_sy_1115, 20.0)])
			J.mc(env["ctx"], "stroke", [])
			v_j_1113 = J.num(v_j_1113) + 1.0
		return null
	var _t1846 = (not J.t(J.gp(J.gp(env["this"], "caught"), v_k_1102)))
	var _t1847 = (J.cmp(J.gp(J.gp(env["this"], "cd"), v_k_1102), 0.0, "<=") if _t1846 else _t1846)
	v_ready_1104 = (J.cmp(J.gp(env["this"], "mana"), 35.0, ">=") if _t1847 else _t1847)
	v_dx_1105 = sin(J.num((J.mul(env["t"], 0.35) + J.mul(v_i_1103, 2.1))))
	v_x_1106 = (J.mul(J.gp(env["this"], "W"), (0.17 + J.mul(0.33, v_i_1103))) + (J.mul(v_dx_1105, J.gp(env["this"], "W")) * 0.06))
	v_y_1107 = J.add((J.gp(J.mc(env["this"], "pt", [0.0, 0.36]), 1.0) if J.t(J.gp(J.gp(env["this"], "site"), "pano")) else J.mul(J.gp(env["this"], "H"), 0.27)), (sin(J.num(J.add(J.mul(env["t"], 0.9), v_i_1103))) * 6.0))
	v_a_1108 = ((0.34 if J.t(v_ready_1104) else 0.13) + (0.06 * sin(J.num(J.add(J.mul(env["t"], 1.7), v_i_1103)))))
	J.mc(J.G.get("ART"), "drawChar", [env["ctx"], v_k_1102, v_x_1106, v_y_1107, 0.8, {"t": J.add(env["t"], J.mul(v_i_1103, 1.3)), "pose": "idle", "alpha": v_a_1108, "flip": (cos(J.num((J.mul(env["t"], 0.35) + J.mul(v_i_1103, 2.1)))) < 0.0), "shadow": false}])

func _f236(this_, a: Array, env):
	var _s567 = {"__p": env, "this": null, "ctx": null, "t": null, "busy": null, "g": null, "ci": null}
	_s567["this"] = this_
	_s567["ctx"] = J.arg(a, 0)
	_s567["t"] = J.arg(a, 1)
	var _t1835 = J.gp(_s567["this"], "fx")
	var _t1836 = J.mc(_t1835, "filter", [Callable(self, "_f237").bind(_s567)])
	_s567["busy"] = J.new_("Set", [J.mc(_t1836, "map", [Callable(self, "_f238").bind(_s567)])])
	var _t1837 = J.gp(_s567["this"], "npcs")
	_s567["g"] = J.mc(_t1837, "find", [Callable(self, "_f239").bind(_s567)])
	_s567["ci"] = 0.0
	var _t1839 = J.gp(_s567["this"], "team")
	J.mc(_t1839, "forEach", [Callable(self, "_f240").bind(_s567)])

func _f241(this_, a: Array, env):
	var v_ctx_1118 = null; var v_f_1119 = null; var v_t_1120 = null; var v_k_1121 = null; var v_H_1122 = null; var v_W_1123 = null; var v_gx_1124 = null; var v_gy_1125 = null; var v_a_1126 = null; var v_n_1127 = null; var v_tx_1128 = null; var v_faceL_1129 = null; var v_side_1130 = null; var v_ph_1131 = null; var v_hit_1132 = null; var v_wind_1133 = null; var v_sc_1134 = null; var v_img_1135 = null; var v_hh_1136 = null; var v_w_1137 = null; var v_e_1138 = null; var v_back_1139 = null; var v_up_1140 = null; var v_drop_1141 = null; var v_wy_1142 = null; var v_x_1143 = null; var v_y_1144 = null; var v_q_1145 = null; var v_pose_1146 = null; var v_pq_1147 = null; var v_bump_1148 = null; var v_e_1149 = null; var v_x_1150 = null; var v_y_1151 = null; var v_i_1152 = null; var v_x_1153 = null; var v_hop_1154 = null; var v_y_1155 = null; var v_rise_1156 = null; var v_lunge_1157 = null; var v_pose_1158 = null; var v_pt_1159 = null; var v_q_1160 = null; var v_px_1161 = null; var v_py_1162 = null; var v_hh_1163 = null
	v_ctx_1118 = J.arg(a, 0)
	v_f_1119 = J.arg(a, 1)
	v_t_1120 = J.arg(a, 2)
	v_k_1121 = (1.0 - J.div(J.gp(v_f_1119, "life"), J.gp(v_f_1119, "max")))
	v_H_1122 = J.gp(this_, "H")
	v_W_1123 = J.gp(this_, "W")
	var _t1848 = J.mc(this_, "pt", [J.gp(v_f_1119, "gx"), J.gp(v_f_1119, "gy")])
	var _t1849 = J.gp(_t1848, 0.0)
	v_gx_1124 = _t1849
	var _t1850 = J.gp(_t1848, 1.0)
	v_gy_1125 = _t1850
	v_a_1126 = J.min_([1.0, J.mul(v_k_1121, 6.0), J.mul(J.gp(v_f_1119, "life"), 2.2)])
	if J.cmp(v_k_1121, 0.16, "<"):
		var _t1851 = J.mul(v_a_1126, (0.7 + (0.3 * sin(J.num(J.mul(v_t_1120, 40.0))))))
		v_a_1126 = _t1851
	if J.t(J.gp(v_f_1119, "caught")):
		var _t1852 = J.mul(v_a_1126, 0.55)
		v_a_1126 = _t1852
	v_n_1127 = J.gp(v_f_1119, "n")
	v_tx_1128 = ((J.gp(v_n_1127, "vX") if (not J.leq(J.gp(v_n_1127, "vX"), null)) else J.gp(v_n_1127, "x")) if J.t(v_n_1127) else 0.5)
	v_faceL_1129 = (J.cmp(v_tx_1128, J.gp(v_f_1119, "gx"), "<") if J.t(v_n_1127) else J.cmp(J.gp(v_f_1119, "gx"), 0.5, ">"))
	v_side_1130 = ((-1.0) if J.t(v_faceL_1129) else 1.0)
	v_ph_1131 = (["idle", 0.0] if J.cmp(v_k_1121, 0.2, "<") else (["windup", J.div(J.sub(v_k_1121, 0.2), 0.175)] if J.cmp(v_k_1121, 0.375, "<") else (["strike", J.div(J.sub(v_k_1121, 0.375), 0.175)] if J.cmp(v_k_1121, 0.55, "<") else (["recover", J.div(J.sub(v_k_1121, 0.55), 0.27)] if J.cmp(v_k_1121, 0.82, "<") else ["idle", 0.0]))))
	v_hit_1132 = (sin(J.num(J.div((J.min_([1.0, J.mul(J.gp(v_ph_1131, 1.0), 1.4)]) * PI), 2.0))) if J.seq(J.gp(v_ph_1131, 0.0), "strike") else (J.sub(1.0, J.gp(v_ph_1131, 1.0)) if J.seq(J.gp(v_ph_1131, 0.0), "recover") else 0.0))
	v_wind_1133 = (J.gp(v_ph_1131, 1.0) if J.seq(J.gp(v_ph_1131, 0.0), "windup") else 0.0)
	v_sc_1134 = J.mul(1.25, J.mc(this_, "depth", [J.gp(v_f_1119, "gy")]))
	J.mc(v_ctx_1118, "save", [])
	var _t1853 = J.seq(J.gp(v_f_1119, "ghost"), "tianhua")
	var _t1854 = (J.gp(J.G.get("SPR"), "tianhua_hang") if _t1853 else _t1853)
	if J.t((J.gp(J.gp(J.G.get("SPR"), "tianhua_hang"), "complete") if J.t(_t1854) else _t1854)):
		v_img_1135 = J.gp(J.G.get("SPR"), "tianhua_hang")
		v_hh_1136 = (J.mul(J.mc(this_, "hh", [J.gp(v_f_1119, "gy")]), 1.9) if J.t(J.mc(this_, "persp", [])) else J.mul(v_H_1122, 0.32))
		v_w_1137 = J.div(J.mul(v_hh_1136, J.gp(v_img_1135, "naturalWidth")), J.gp(v_img_1135, "naturalHeight"))
		v_e_1138 = J.min_([1.0, J.div(v_k_1121, 0.375)])
		v_back_1139 = ((1.0 + (2.4 * pow(J.num(J.sub(v_e_1138, 1.0)), J.num(3.0)))) + (1.4 * pow(J.num(J.sub(v_e_1138, 1.0)), J.num(2.0))))
		v_up_1140 = (J.div(J.sub(v_k_1121, 0.82), 0.18) if J.cmp(v_k_1121, 0.82, ">") else 0.0)
		v_drop_1141 = (J.sub(v_back_1139, J.mul(v_up_1140, 1.2)) * J.sub(v_gy_1125, J.mul(v_hh_1136, 0.95)))
		var _t1855 = J.mul(v_a_1126, 0.92)
		J.sp(v_ctx_1118, "globalAlpha", _t1855)
		J.mc(v_ctx_1118, "translate", [v_gx_1124, (J.max_([(-J.num(v_hh_1136)), J.sub(v_drop_1141, J.mul(v_hh_1136, 0.2))]) + (sin(J.num(J.mul(v_t_1120, 3.0))) * 3.0))])
		J.mc(v_ctx_1118, "rotate", [(sin(J.num(J.mul(v_t_1120, (2.4 + J.mul(v_hit_1132, 6.0))))) * (0.05 + J.mul(v_hit_1132, 0.1)))])
		J.mc(v_ctx_1118, "scale", [(1.0 + J.mul(v_hit_1132, 0.08)), (1.0 + J.mul(v_hit_1132, 0.08))])
		J.mc(v_ctx_1118, "drawImage", [v_img_1135, J.div((-J.num(v_w_1137)), 2.0), 0.0, v_w_1137, v_hh_1136])
	else:
		if J.seq(J.gp(v_f_1119, "ghost"), "pontianak"):
			v_wy_1142 = (J.gp(J.mc(this_, "pt", [0.0, J.add(J.gp(J.gp(J.G.get("OFFICE"), "WIN"), 1.0), J.mul(J.gp(J.gp(J.G.get("OFFICE"), "WIN"), 3.0), 0.62))]), 1.0) if J.t(J.mc(this_, "office", [])) else J.mul(v_H_1122, 0.25))
			v_x_1143 = ((-60.0) + J.mul(J.add(v_W_1123, 120.0), v_k_1121))
			v_y_1144 = J.add(v_wy_1142, (sin(J.num(J.mul(v_k_1121, 9.0))) * 12.0))
			J.mc(J.G.get("ART"), "drawChar", [v_ctx_1118, "pontianak", v_x_1143, v_y_1144, 1.3, {"t": v_t_1120, "pose": "cast", "pt": J.min_([1.0, J.mul(v_k_1121, 2.0)]), "alpha": J.mul(v_a_1126, 0.8), "flip": false, "shadow": false, "rot": (sin(J.num(J.mul(v_t_1120, 4.0))) * 0.08)}])
			J.sp(v_ctx_1118, "font", "900 18px serif")
			var _t1856 = ("rgba(255,200,230," + J.str(v_a_1126) + ")")
			J.sp(v_ctx_1118, "fillStyle", _t1856)
			J.sp(v_ctx_1118, "textAlign", "center")
			J.mc(v_ctx_1118, "fillText", ["嘻——嘻——", J.add(v_x_1143, (sin(J.num(J.mul(v_t_1120, 20.0))) * 2.0)), J.sub(v_y_1144, 70.0)])
		else:
			if J.seq(J.gp(v_f_1119, "ghost"), "eguiking"):
				v_q_1145 = J.mod(J.div(J.mul(v_k_1121, J.gp(v_f_1119, "max")), 0.34), 1.0)
				v_pose_1146 = ("windup" if J.cmp(v_q_1145, 0.55, "<") else "strike")
				v_pq_1147 = (J.div(v_q_1145, 0.55) if J.cmp(v_q_1145, 0.55, "<") else J.div(J.sub(v_q_1145, 0.55), 0.45))
				v_bump_1148 = (sin(J.num(J.mul(v_pq_1147, PI))) if J.seq(v_pose_1146, "strike") else 0.0)
				J.mc(J.G.get("ART"), "drawChar", [v_ctx_1118, "eguiking", (J.mul(v_W_1123, 0.86) - J.mul(v_bump_1148, 8.0)), J.mul(v_H_1122, 0.55), (1.1 * (1.0 + J.mul(v_bump_1148, 0.05))), {"t": v_t_1120, "pose": v_pose_1146, "pt": v_pq_1147, "atk": J.seq(v_pose_1146, "strike"), "alpha": J.mul(v_a_1126, 0.8), "flip": true, "shadow": false, "rot": ((-J.num(v_bump_1148)) * 0.1)}])
				J.sp(v_ctx_1118, "font", "900 20px sans-serif")
				var _t1857 = ("rgba(255,230,150," + J.str(v_a_1126) + ")")
				J.sp(v_ctx_1118, "fillStyle", _t1857)
				J.sp(v_ctx_1118, "textAlign", "center")
				J.mc(v_ctx_1118, "fillText", ["叮叮叮叮！", J.mul(v_W_1123, 0.8), (J.mul(v_H_1122, 0.4) - J.mul(v_k_1121, 20.0))])
				if J.cmp(v_bump_1148, 0.6, ">"):
					J.sp(v_ctx_1118, "font", "900 15px sans-serif")
					J.mc(v_ctx_1118, "fillText", ["叮！", (J.mul(v_W_1123, 0.72) + (sin(J.num(J.mul(v_k_1121, 40.0))) * 20.0)), (J.mul(v_H_1122, 0.47) - J.mul(v_bump_1148, 10.0))])
			else:
				if J.seq(J.gp(v_f_1119, "ghost"), "penanggal"):
					v_e_1149 = J.min_([1.0, J.div(v_k_1121, 0.6)])
					v_x_1150 = J.add(J.add(v_gx_1124, (J.mul((-J.num(v_side_1130)), v_W_1123) * 0.2)), ((J.mul(v_side_1130, v_W_1123) * 0.38) * (J.mul(v_e_1149, v_e_1149) * (3.0 - J.mul(2.0, v_e_1149)))))
					v_y_1151 = ((J.sub(v_gy_1125, J.mul(v_H_1122, 0.13)) - (sin(J.num(J.mul(v_e_1149, PI))) * 20.0)) + (sin(J.num(J.mul(v_t_1120, 6.0))) * 4.0))
					v_i_1152 = 1.0
					while true:
						if not J.cmp(v_i_1152, 5.0, "<="): break
						var _t1858 = ("rgba(200,40,60," + J.str((J.mul(v_a_1126, 0.35) * (1.0 - J.div(v_i_1152, 6.0)))) + ")")
						J.sp(v_ctx_1118, "fillStyle", _t1858)
						J.mc(v_ctx_1118, "beginPath", [])
						J.mc(v_ctx_1118, "arc", [J.sub(v_x_1150, (J.mul(v_side_1130, v_i_1152) * 9.0)), J.add(J.add(v_y_1151, 8.0), (sin(J.num(J.add(J.mul(v_t_1120, 8.0), v_i_1152))) * 3.0)), (4.0 - J.mul(v_i_1152, 0.5)), 0.0, (PI * 2.0)])
						J.mc(v_ctx_1118, "fill", [])
						v_i_1152 = J.num(v_i_1152) + 1.0
					J.mc(J.G.get("ART"), "drawChar", [v_ctx_1118, "penanggal", v_x_1150, J.add(v_y_1151, J.mul(v_H_1122, 0.05)), v_sc_1134, {"t": v_t_1120, "pose": J.gp(v_ph_1131, 0.0), "pt": J.gp(v_ph_1131, 1.0), "alpha": J.mul(v_a_1126, 0.85), "flip": v_faceL_1129, "shadow": false, "rot": (J.mul(v_side_1130, v_hit_1132) * 0.15)}])
				else:
					if J.seq(J.gp(v_f_1119, "ghost"), "laojiang"):
						v_x_1153 = J.add(J.add(v_gx_1124, (J.mul((-J.num(v_side_1130)), v_W_1123) * 0.22)), ((J.mul(v_side_1130, v_W_1123) * 0.44) * J.min_([1.0, J.mul(v_k_1121, 1.15)])))
						v_hop_1154 = absf(J.num(sin(J.num((J.mul(v_k_1121, PI) * 5.0)))))
						v_y_1155 = J.sub(v_gy_1125, J.mul(v_hop_1154, 26.0))
						J.sp(v_ctx_1118, "fillStyle", "rgba(0,0,0,.25)")
						J.mc(v_ctx_1118, "beginPath", [])
						J.mc(v_ctx_1118, "ellipse", [v_x_1153, J.add(v_gy_1125, 2.0), (16.0 * (1.0 - J.mul(v_hop_1154, 0.4))), 4.0, 0.0, 0.0, (PI * 2.0)])
						J.mc(v_ctx_1118, "fill", [])
						J.mc(J.G.get("ART"), "drawChar", [v_ctx_1118, "laojiang", v_x_1153, v_y_1155, v_sc_1134, {"t": v_t_1120, "walk": true, "pose": "move", "alpha": J.mul(v_a_1126, 0.88), "flip": v_faceL_1129, "shadow": false}])
					else:
						v_rise_1156 = ((1.0 - J.min_([1.0, J.mul(v_k_1121, 4.0)])) * 30.0)
						v_lunge_1157 = J.mul(v_side_1130, (J.mul(v_hit_1132, 16.0) - J.mul(v_wind_1133, 8.0)))
						v_pose_1158 = J.gp(v_ph_1131, 0.0)
						v_pt_1159 = J.gp(v_ph_1131, 1.0)
						var _t1859 = J.seq(J.gp(v_f_1119, "ghost"), "afu")
						if (J.cmp(v_k_1121, 0.375, "<") if _t1859 else _t1859):
							v_pose_1158 = "knead"
							var _t1860 = J.mod((J.mul(v_k_1121, J.gp(v_f_1119, "max")) * 1.6), 1.0)
							v_pt_1159 = _t1860
						J.mc(J.G.get("ART"), "drawChar", [v_ctx_1118, J.gp(v_f_1119, "ghost"), J.add(v_gx_1124, v_lunge_1157), J.add(v_gy_1125, v_rise_1156), J.mul(v_sc_1134, (1.0 + J.mul(v_hit_1132, 0.12))), {"t": v_t_1120, "pose": v_pose_1158, "pt": v_pt_1159, "atk": J.cmp(v_hit_1132, 0.3, ">"), "alpha": J.mul(v_a_1126, 0.85), "flip": v_faceL_1129, "shadow": false, "rot": J.mul(v_side_1130, (J.mul(v_hit_1132, 0.12) - J.mul(v_wind_1133, 0.1)))}])
						var _t1861 = J.seq(J.gp(v_f_1119, "ghost"), "afu")
						var _t1862 = (J.cmp(v_k_1121, 0.08, ">") if _t1861 else _t1861)
						if (J.cmp(v_k_1121, 0.4, "<") if _t1862 else _t1862):
							J.sp(v_ctx_1118, "font", "800 12px sans-serif")
							J.sp(v_ctx_1118, "textAlign", "center")
							var _t1863 = ("rgba(190,255,215," + J.str(J.mul(v_a_1126, 0.9)) + ")")
							J.sp(v_ctx_1118, "fillStyle", _t1863)
							J.mc(v_ctx_1118, "fillText", [J.gp(["噠", "噠噠", "噠噠噠"], J.mod(floor(J.num(J.mul(v_k_1121, 30.0))), 3.0)), J.add(v_gx_1124, J.mul(v_side_1130, 18.0)), J.sub(v_gy_1125, J.mul(v_H_1122, 0.13))])
	J.mc(v_ctx_1118, "restore", [])
	var _t1864 = J.gp(v_f_1119, "sig")
	if J.t(((not J.seq(J.typeof_(J.G.get("ScareX")), "undefined")) if J.t(_t1864) else _t1864)):
		J.mc(J.G.get("ScareX"), "sigFx", [this_, v_ctx_1118, v_f_1119, v_t_1120, v_k_1121])
	var _t1865 = ((not J.t(J.gp(v_n_1127, "gone"))) if J.t(v_n_1127) else v_n_1127)
	var _t1866 = (J.cmp(v_k_1121, 0.37, ">") if J.t(_t1865) else _t1865)
	if J.t((J.cmp(v_k_1121, 0.6, "<") if J.t(_t1866) else _t1866)):
		v_q_1160 = J.div(J.sub(v_k_1121, 0.37), 0.23)
		var _t1867 = J.mc(this_, "pt", [v_tx_1128, (J.gp(v_n_1127, "vY") if (not J.leq(J.gp(v_n_1127, "vY"), null)) else J.gp(v_n_1127, "y"))])
		var _t1868 = J.gp(_t1867, 0.0)
		v_px_1161 = _t1868
		var _t1869 = J.gp(_t1867, 1.0)
		v_py_1162 = _t1869
		v_hh_1163 = J.mc(this_, "hh", [J.gp(v_n_1127, "y")])
		var _t1870 = ("rgba(210,150,255," + J.str((J.sub(1.0, v_q_1160) * 0.8)) + ")")
		J.sp(v_ctx_1118, "strokeStyle", _t1870)
		var _t1871 = ((3.0 * J.sub(1.0, v_q_1160)) + 1.0)
		J.sp(v_ctx_1118, "lineWidth", _t1871)
		J.mc(v_ctx_1118, "beginPath", [])
		J.mc(v_ctx_1118, "arc", [v_px_1161, J.sub(v_py_1162, J.mul(v_hh_1163, 0.75)), J.mul(v_hh_1163, (0.15 + J.mul(v_q_1160, 0.5))), 0.0, (PI * 2.0)])
		J.mc(v_ctx_1118, "stroke", [])

func _f243(this_, a: Array, env):
	var v_l_1186 = null
	v_l_1186 = J.arg(a, 0)
	return J.gp(J.mc(env["ctx"], "measureText", [v_l_1186]), "width")

func _f244(this_, a: Array, env):
	var v_r_1189 = null
	v_r_1189 = J.arg(a, 0)
	var _t1886 = J.cmp(env["bx"], J.add(J.add(J.gp(v_r_1189, 0.0), J.gp(v_r_1189, 2.0)), 3.0), "<")
	var _t1887 = (J.cmp(J.add(J.add(env["bx"], env["w"]), 3.0), J.gp(v_r_1189, 0.0), ">") if _t1886 else _t1886)
	var _t1888 = (J.cmp(env["by"], J.add(J.add(J.gp(v_r_1189, 1.0), J.gp(v_r_1189, 3.0)), 3.0), "<") if _t1887 else _t1887)
	return (J.cmp(J.add(J.add(env["by"], env["h"]), 3.0), J.gp(v_r_1189, 1.0), ">") if _t1888 else _t1888)

func _f245(this_, a: Array, env):
	var v_l_1190 = null; var v_i_1191 = null
	v_l_1190 = J.arg(a, 0)
	v_i_1191 = J.arg(a, 1)
	return J.mc(env["ctx"], "fillText", [v_l_1190, J.add(env["bx"], 8.0), J.add(J.add(env["by"], 18.0), J.mul(v_i_1191, 17.0))])

func _f242(this_, a: Array, env):
	var v_text_1167 = null; var v_x_1168 = null; var v_y_1169 = null; var v_ghost_1170 = null; var v_age_1171 = null; var v_pk_1172 = null; var v_ps_1173 = null; var v_maxW_1174 = null; var v_words_1175 = null; var v_lines_1176 = null; var v_cur_1177 = null; var v_by0_1182 = null; var v_R_1183 = null; var v_ch_1184 = null; var v_pv_1185 = null; var v_k_1187 = null; var v_o_1188 = null
	var _s588 = {"__p": env, "ctx": null, "w": null, "h": null, "bx": null, "by": null}
	_s588["ctx"] = J.arg(a, 0)
	v_text_1167 = J.arg(a, 1)
	v_x_1168 = J.arg(a, 2)
	v_y_1169 = J.arg(a, 3)
	v_ghost_1170 = J.arg(a, 4)
	v_age_1171 = J.arg(a, 5)
	v_pk_1172 = (1.0 if J.leq(v_age_1171, null) else J.min_([1.0, J.div(v_age_1171, 0.22)]))
	v_ps_1173 = (1.0 if J.cmp(v_pk_1172, 1.0, ">=") else ((1.0 + (2.70158 * pow(J.num(J.sub(v_pk_1172, 1.0)), J.num(3.0)))) + (1.70158 * pow(J.num(J.sub(v_pk_1172, 1.0)), J.num(2.0)))))
	J.mc(_s588["ctx"], "save", [])
	J.mc(_s588["ctx"], "translate", [v_x_1168, v_y_1169])
	J.mc(_s588["ctx"], "scale", [J.max_([0.05, v_ps_1173]), J.max_([0.05, v_ps_1173])])
	J.mc(_s588["ctx"], "translate", [(-J.num(v_x_1168)), (-J.num(v_y_1169))])
	if J.cmp(v_pk_1172, 1.0, "<"):
		var _t1872 = _s588["ctx"]
		var _t1873 = J.mul(J.gp(_t1872, "globalAlpha"), J.min_([1.0, J.mul(v_pk_1172, 3.0)]))
		J.sp(_t1872, "globalAlpha", _t1873)
	var _t1874 = _s588["ctx"]
	J.sp(_t1874, "font", "600 13px sans-serif")
	v_maxW_1174 = 200.0
	v_words_1175 = J.spread([J.SP(v_text_1167)])
	v_lines_1176 = []
	v_cur_1177 = ""
	for _t1875 in J.iter(v_words_1175):
		v_ch_1184 = _t1875
		if J.cmp(J.gp(J.mc(_s588["ctx"], "measureText", [J.add(v_cur_1177, v_ch_1184)]), "width"), v_maxW_1174, ">"):
			J.mc(v_lines_1176, "push", [v_cur_1177])
			v_cur_1177 = v_ch_1184
		else:
			var _t1876 = J.add(v_cur_1177, v_ch_1184)
			v_cur_1177 = _t1876
	J.mc(v_lines_1176, "push", [v_cur_1177])
	var _t1877 = (J.len(v_lines_1176) > 1.0)
	if ((J.len(J.spread([J.SP(J.gp(v_lines_1176, (J.len(v_lines_1176) - 1.0)))])) <= 2.0) if _t1877 else _t1877):
		v_pv_1185 = J.spread([J.SP(J.gp(v_lines_1176, (J.len(v_lines_1176) - 2.0)))])
		var _t1878 = (J.len(v_lines_1176) - 1.0)
		var _t1879 = J.mc(v_pv_1185, "splice", [(-2.0)])
		var _t1880 = J.add(J.mc(_t1879, "join", [""]), J.gp(v_lines_1176, (J.len(v_lines_1176) - 1.0)))
		J.sp(v_lines_1176, _t1878, _t1880)
		var _t1881 = (J.len(v_lines_1176) - 2.0)
		var _t1882 = J.mc(v_pv_1185, "join", [""])
		J.sp(v_lines_1176, _t1881, _t1882)
	_s588["w"] = (J.min_([v_maxW_1174, J.max_(J.spread([J.SP(J.mc(v_lines_1176, "map", [Callable(self, "_f243").bind(_s588)]))]))]) + 16.0)
	_s588["h"] = ((J.len(v_lines_1176) * 17.0) + 10.0)
	_s588["bx"] = J.max_([6.0, J.min_([(J.sub(J.gp(this_, "W"), _s588["w"]) - 6.0), J.sub(v_x_1168, J.div(_s588["w"], 2.0))])])
	_s588["by"] = (J.sub(v_y_1169, _s588["h"]) - 10.0)
	v_by0_1182 = _s588["by"]
	var _t1885 = J.gp(this_, "_bubR")
	if not J.t(_t1885):
		var _t1883 = this_
		var _t1884 = []
		J.sp(_t1883, "_bubR", _t1884)
		_t1885 = _t1884
	v_R_1183 = _t1885
	v_k_1187 = 0.0
	while true:
		if not J.cmp(v_k_1187, 6.0, "<"): break
		v_o_1188 = J.mc(v_R_1183, "find", [Callable(self, "_f244").bind(_s588)])
		if (not J.t(v_o_1188)):
			break
		var _t1889 = (J.sub(J.gp(v_o_1188, 1.0), _s588["h"]) - 5.0)
		_s588["by"] = _t1889
		v_k_1187 = J.num(v_k_1187) + 1.0
	if J.cmp(_s588["by"], 4.0, "<"):
		_s588["by"] = 4.0
	J.mc(v_R_1183, "push", [[_s588["bx"], _s588["by"], _s588["w"], _s588["h"]]])
	if J.cmp(_s588["by"], J.sub(v_by0_1182, 2.0), "<"):
		var _t1890 = _s588["ctx"]
		var _t1891 = ("rgba(180,138,216,.8)" if J.t(v_ghost_1170) else "rgba(255,253,245,.8)")
		J.sp(_t1890, "strokeStyle", _t1891)
		var _t1892 = _s588["ctx"]
		J.sp(_t1892, "lineWidth", 1.5)
		J.mc(_s588["ctx"], "beginPath", [])
		J.mc(_s588["ctx"], "moveTo", [v_x_1168, J.add(_s588["by"], _s588["h"])])
		J.mc(_s588["ctx"], "lineTo", [v_x_1168, J.sub(v_y_1169, 2.0)])
		J.mc(_s588["ctx"], "stroke", [])
	var _t1893 = _s588["ctx"]
	var _t1894 = ("rgba(60,30,80,.92)" if J.t(v_ghost_1170) else "rgba(255,253,245,.95)")
	J.sp(_t1893, "fillStyle", _t1894)
	var _t1895 = _s588["ctx"]
	var _t1896 = ("#b48ad8" if J.t(v_ghost_1170) else "#3a2a1a")
	J.sp(_t1895, "strokeStyle", _t1896)
	var _t1897 = _s588["ctx"]
	J.sp(_t1897, "lineWidth", 1.5)
	J.mc(_s588["ctx"], "beginPath", [])
	J.mc(_s588["ctx"], "roundRect", [_s588["bx"], _s588["by"], _s588["w"], _s588["h"], 9.0])
	J.mc(_s588["ctx"], "fill", [])
	J.mc(_s588["ctx"], "stroke", [])
	J.mc(_s588["ctx"], "beginPath", [])
	J.mc(_s588["ctx"], "moveTo", [J.sub(v_x_1168, 6.0), J.add(_s588["by"], _s588["h"])])
	J.mc(_s588["ctx"], "lineTo", [v_x_1168, J.add(J.add(_s588["by"], _s588["h"]), 8.0)])
	J.mc(_s588["ctx"], "lineTo", [J.add(v_x_1168, 6.0), J.add(_s588["by"], _s588["h"])])
	J.mc(_s588["ctx"], "fill", [])
	var _t1898 = _s588["ctx"]
	var _t1899 = ("#f0e0ff" if J.t(v_ghost_1170) else "#2a1a10")
	J.sp(_t1898, "fillStyle", _t1899)
	var _t1900 = _s588["ctx"]
	J.sp(_t1900, "textAlign", "left")
	J.mc(v_lines_1176, "forEach", [Callable(self, "_f245").bind(_s588)])
	J.mc(_s588["ctx"], "restore", [])

func _f247(this_, a: Array, env):
	var v_s_1204 = null; var v_k_1205 = null
	v_s_1204 = J.arg(a, 0)
	v_k_1205 = J.arg(a, 1)
	return J.add(v_s_1204, J.gp(v_k_1205, "v"))

func _f248(this_, a: Array, env):
	var v_k_1206 = null
	v_k_1206 = J.arg(a, 0)
	return ("<li class=\"" + ("up" if J.cmp(J.gp(v_k_1206, "v"), 0.0, ">") else "dn") + "\">陰德 " + ("+" if J.cmp(J.gp(v_k_1206, "v"), 0.0, ">") else "") + J.str(J.gp(v_k_1206, "v")) + "　" + J.str(J.gp(v_k_1206, "why")) + "</li>")

func _f249(this_, a: Array, env):
	var _t1929 = J.G.get("$")
	var _t1930 = J.gp(J.cl(_t1929, null, ["#scare"]), "classList")
	J.mc(_t1930, "remove", ["on"])
	var _t1931 = J.G.get("$")
	var _t1932 = J.cl(_t1931, null, ["#scare"])
	J.sp(_t1932, "innerHTML", "")
	J.mc(J.G.get("Sound"), "setMode", ["village"])
	J.mc(J.G.get("UI"), "refresh", [])

func _f246(this_, a: Array, env):
	var v_quit_1194 = null; var v_best_1195 = null; var v_stars_1196 = null; var v_first_1197 = null; var v_kar_1198 = null; var v_rw_1199 = null; var v_got_1200 = null; var v_rate_1201 = null; var v_kl_1202 = null; var v_kword_1203 = null
	v_quit_1194 = J.arg(a, 0)
	if (not J.t(J.gp(this_, "active"))):
		return null
	var _t1901 = this_
	J.sp(_t1901, "active", false)
	var _t1902 = J.G.get("S")
	var _t1903 = J.gp(J.G.get("S"), "scare")
	var _t1904 = (_t1903 if J.t(_t1903) else {"best": {}, "runs": 0.0, "fv": 3.0})
	J.sp(_t1902, "scare", _t1904)
	J.mc(this_, "migrate", [])
	var _t1905 = J.gp(J.G.get("S"), "scare")
	J.sp(_t1905, "runs", J.num(J.gp(_t1905, "runs")) + 1.0)
	var _t1906 = J.gp(J.gp(J.gp(J.G.get("S"), "scare"), "best"), J.gp(this_, "siteId"))
	v_best_1195 = (_t1906 if J.t(_t1906) else 0.0)
	v_stars_1196 = J.mc(this_, "starsOf", [J.gp(this_, "siteId"), J.gp(this_, "kpi")])
	v_first_1197 = J.cmp(v_stars_1196, J.mc(this_, "starsOf", [J.gp(this_, "siteId"), v_best_1195]), ">")
	if J.cmp(J.gp(this_, "kpi"), v_best_1195, ">"):
		var _t1907 = J.gp(J.gp(J.G.get("S"), "scare"), "best")
		var _t1908 = J.gp(this_, "siteId")
		var _t1909 = J.gp(this_, "kpi")
		J.sp(_t1907, _t1908, _t1909)
	var _t1910 = J.gp(this_, "karma")
	v_kar_1198 = J.mc(_t1910, "reduce", [Callable(self, "_f247").bind(env), 0.0])
	v_rw_1199 = {"exp": J.round(J.num(J.mul(J.div(J.gp(this_, "kpi"), 5.0), J.G.get("SCARE_PAY")))), "coins": J.round(J.num(J.mul(J.div(J.gp(this_, "kpi"), 2.0), J.G.get("SCARE_PAY"))))}
	if J.t(v_first_1197):
		var _t1911 = J.gp(["g", "b", "p"], J.sub(v_stars_1196, 1.0))
		J.sp(v_rw_1199, "chest", _t1911)
	var _t1912 = this_
	var _t1913 = (J.mc(J.G.get("ScareX"), "finish", [this_, v_stars_1196, v_quit_1194]) if (not J.seq(J.typeof_(J.G.get("ScareX")), "undefined")) else "")
	J.sp(_t1912, "_legendHTML", _t1913)
	var _t1914 = J.G.get("give")
	v_got_1200 = J.cl(_t1914, null, [v_rw_1199])
	J.cl(J.G.get("save"), null, [])
	v_rate_1201 = J.gp(["親，今晚的 KPI 沒達標哦～明晚加油！", "親，一星好評！離退休還有九百九十九顆星～", "親，二星好評！黃總說你很有潛力（並沒有加薪）。", "親，三星好評！全陰司本月最佳嚇人員工！"], v_stars_1196)
	var _t1917 = null
	if J.t(J.len(J.gp(this_, "karma"))):
		var _t1915 = J.gp(this_, "karma")
		var _t1916 = J.mc(_t1915, "map", [Callable(self, "_f248").bind(env)])
		_t1917 = J.mc(_t1916, "join", [""])
	else:
		_t1917 = "<li>今晚沒有人因為你改變人生。</li>"
	v_kl_1202 = _t1917
	v_kword_1203 = ("你今晚救了人。系統不會算這個，但是有人會記得。" if J.cmp(v_kar_1198, 4.0, ">=") else ("嚇對人了。" if J.cmp(v_kar_1198, 0.0, ">") else ("有些人，其實不用嚇。" if J.cmp(v_kar_1198, 0.0, "<") else "")))
	var _t1918 = J.G.get("$")
	var _t1919 = J.cl(_t1918, null, ["#scare"])
	var _t1921 = ("阿福被道士請走了" if J.t(J.gp(this_, "expelled")) else ("提早收工" if J.t(v_quit_1194) else "天亮了，收工"))
	var _t1922 = (("<p class=\"desc\">做法完成，今晚 KPI 只計一半。下次低調啲：唔好俾人望到。</p>") if J.t(J.gp(this_, "expelled")) else "")
	var _t1923 = J.mc("★", "repeat", [v_stars_1196])
	var _t1924 = J.mc("☆", "repeat", [J.sub(3.0, v_stars_1196)])
	var _t1925 = J.gp(this_, "kpi")
	var _t1920 = J.gp(this_, "_legendHTML")
	var _t1926 = ("<div class=\"sc-end\"><h3>" + _t1921 + "</h3>" + _t1922 + "<div class=\"sc-stars\">" + J.str(_t1923) + J.str(_t1924) + "</div>\n      <p class=\"sc-big\">驚嚇值 " + J.str(_t1925) + "</p><p class=\"desc\">【陰司 KPI 系統】" + J.str(v_rate_1201) + "</p><p class=\"desc\">獎勵：" + J.str(v_got_1200) + "</p>\n      " + J.str((_t1920 if J.t(_t1920) else "")) + "<h4>陰德（系統沒有算這一欄）</h4><ul class=\"sc-karma\">" + J.str(v_kl_1202) + "</ul><p class=\"desc\">" + J.str(v_kword_1203) + "</p><button class=\"btn gold wide\" id=\"sc-back\">回村子</button></div>")
	J.sp(_t1919, "innerHTML", _t1926)
	var _t1927 = J.G.get("$")
	var _t1928 = J.cl(_t1927, null, ["#sc-back"])
	var _t1933 = Callable(self, "_f249").bind(env)
	J.sp(_t1928, "onclick", _t1933)

func _f252(this_, a: Array, env):
	var v_ctx_1212 = null; var v_a_1213 = null; var v_o_1214 = null; var v_ps_1215 = null; var v_A_1216 = null; var v_k_1217 = null; var v_img_1218 = null; var v_kk_1219 = null; var v_pz_1220 = null; var v_n_1221 = null
	v_ctx_1212 = J.arg(a, 0)
	v_a_1213 = J.arg(a, 1)
	v_o_1214 = J.gp(v_a_1213, "o")
	v_ps_1215 = J.gp(v_o_1214, "pose")
	v_A_1216 = J.gp(J.G.get("MeshAnim"), "ANIM")
	var _t1942 = ["scared", "startle", "tremble", "cower", "hurt"]
	var _t1946 = null
	if J.t(J.mc(_t1942, "includes", [v_ps_1215])):
		_t1946 = "jump"
	else:
		var _t1943 = J.gp(v_o_1214, "walk")
		var _t1944 = (_t1943 if J.t(_t1943) else J.seq(v_ps_1215, "move"))
		var _t1945 = (_t1944 if J.t(_t1944) else J.seq(v_ps_1215, "walk"))
		_t1946 = ("walk" if J.t((_t1945 if J.t(_t1945) else J.seq(v_ps_1215, "run"))) else ("ritual" if J.seq(v_ps_1215, "ritual") else "stand"))
	v_k_1217 = _t1946
	var _t1947 = J.gp(env["P"], v_k_1217)
	var _t1948 = J.gp(_t1947, 0.0)
	v_img_1218 = _t1948
	var _t1949 = J.gp(_t1947, 1.0)
	v_kk_1219 = _t1949
	var _t1951 = (not J.seq(J.typeof_(J.G.get("sprOk")), "function"))
	if not J.t(_t1951):
		var _t1950 = J.G.get("sprOk")
		_t1951 = (not J.t(J.cl(_t1950, null, [v_img_1218])))
	if _t1951:
		return false
	v_pz_1220 = null
	if J.seq(v_k_1217, "walk"):
		var _t1952 = J.mc(v_A_1216, "walk", [J.gp(v_o_1214, "t")])
		v_pz_1220 = _t1952
		for _t1953 in J.keys(v_pz_1220):
			v_n_1221 = _t1953
			var _t1955 = J.seq(J.typeof_(J.gp(v_pz_1220, v_n_1221)), "number")
			if J.t(_t1955):
				var _t1954 = ["y", "sx", "sy"]
				_t1955 = (not J.t(J.mc(_t1954, "includes", [v_n_1221])))
			if _t1955:
				var _t1956 = (-J.num(J.gp(v_pz_1220, v_n_1221)))
				J.sp(v_pz_1220, v_n_1221, _t1956)
		J.sp(v_pz_1220, "x", 0.0)
		J.sp(v_pz_1220, "rot", 0.0)
	else:
		var _t1957 = J.mc(v_A_1216, "idle", [J.gp(v_o_1214, "t")])
		v_pz_1220 = _t1957
	if J.seq(v_k_1217, "ritual"):
		var _t1958 = J.gp(v_pz_1220, "armF")
		var _t1959 = J.add((_t1958 if J.t(_t1958) else 0.0), (sin(J.num(J.mul(J.gp(v_o_1214, "t"), 10.0))) * 0.07))
		J.sp(v_pz_1220, "armF", _t1959)
	J.mc(v_a_1213, "shadow", [J.gp(v_a_1213, "x")])
	J.mc(J.G.get("MeshAnim"), "draw", [v_ctx_1212, v_img_1218, J.gp(v_a_1213, "x"), J.gp(v_a_1213, "y"), J.mul(J.gp(v_a_1213, "H"), v_kk_1219), v_pz_1220, J.gp(v_a_1213, "faceRight")])
	return true

func _f251(this_, a: Array, env):
	var v_k_1211 = null
	var _s604 = {"__p": env, "P": null}
	var _t1934 = J.seq(J.typeof_(J.G.get("MeshAnim")), "undefined")
	if (_t1934 if _t1934 else J.seq(J.typeof_(J.G.get("ART")), "undefined")):
		return null
	_s604["P"] = {"stand": ["npc_daoshi", 1.0, {"c": 0.5, "n": 0.4, "h": 0.55, "ht": 0.1, "hr": 0.3, "L": [0.3, 0.48, 0.12, 0.47], "R": [0.7, 0.48, 0.75, 0.54], "legs": [0.82, 0.38, 0.65]}], "walk": ["npc_daoshi_walk", 0.98, {"c": 0.45, "n": 0.42, "h": 0.4, "ht": 0.08, "hr": 0.26, "L": [0.28, 0.45, 0.15, 0.25], "R": [0.62, 0.48, 0.4, 0.55], "legs": [0.8, 0.25, 0.55]}], "ritual": ["npc_daoshi_ritual", 1.0, {"c": 0.5, "n": 0.42, "h": 0.55, "ht": 0.06, "hr": 0.24, "L": [0.4, 0.4, 0.32, 0.18], "R": [0.7, 0.5, 0.62, 0.6], "tail": 0.5}], "jump": ["npc_daoshi_jump", 1.0, {"c": 0.5, "n": 0.42, "h": 0.55, "ht": 0.06, "hr": 0.24, "L": [0.38, 0.48, 0.2, 0.4], "R": [0.72, 0.48, 0.88, 0.42], "legs": [0.78, 0.3, 0.55]}]}
	for _t1935 in J.keys(_s604["P"]):
		v_k_1211 = _t1935
		var _t1936 = J.gp(J.G.get("MeshAnim"), "RIG")
		var _t1937 = J.gp(J.gp(_s604["P"], v_k_1211), 0.0)
		var _t1938 = J.mc(J.G.get("MeshAnim"), "mk", [J.gp(J.gp(_s604["P"], v_k_1211), 2.0)])
		J.sp(_t1936, _t1937, _t1938)
	var _t1939 = J.gp(J.G.get("ART"), "CHAR_H")
	J.sp(_t1939, "npc_daoshi", 64.0)
	if J.t(J.gp(J.G.get("ART"), "SOLID")):
		var _t1940 = J.gp(J.G.get("ART"), "SOLID")
		J.sp(_t1940, "npc_daoshi", 1.0)
	var _t1941 = J.gp(J.gp(J.G.get("MeshAnim"), "RIG"), "npc_daoshi")
	var _t1960 = Callable(self, "_f252").bind(_s604)
	J.sp(_t1941, "custom", _t1960)
