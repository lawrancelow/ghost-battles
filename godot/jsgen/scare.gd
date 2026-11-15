# 自動轉譯自 scare.js（tools/jsgd.js）——唔好直接改，改原 JS 再轉
extends RefCounted

func run(env):
	var this_ = null; var a = []
	var v_k_37 = null; var v_p_38 = null; var v_c_39 = null; var v_p_40 = null; var v_O_41 = null; var v_SP_42 = null; var v_A_43 = null; var v_R_44 = null; var v_px_45 = null
	J.G["pick"] = Callable(self, "_f251").bind(env)
	J.G["SCARE_TYPES"] = {"breath": "氣", "light": "燈", "cold": "冷", "sound": "聲", "paper": "紙", "phone": "訊息", "face": "臉", "shadow": "影"}
	J.G["NIGHT_SEC"] = 180.0
	J.G["__scDC"] = Callable(self, "_f1").bind(env)
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
	for _t4 in J.keys(J.G.get("SCARE_PROPS")):
		v_k_37 = _t4
		v_p_38 = J.gp(J.G.get("SCARE_PROPS"), v_k_37)
		J.sp(v_p_38, "room", "main")
		if J.t(J.gp(v_p_38, "group")):
			continue
		var _t5 = [J.mc(J.G.get("OFFMAP"), "M", [J.gp(J.gp(v_p_38, "front"), 0.0)]), J.mc(J.G.get("OFFMAP"), "MY", [J.gp(J.gp(v_p_38, "front"), 1.0)])]
		J.sp(v_p_38, "front", _t5)
		var _t6 = [J.mc(J.G.get("OFFMAP"), "M", [J.gp(J.gp(v_p_38, "rect"), 0.0)]), J.mc(J.G.get("OFFMAP"), "MY", [J.gp(J.gp(v_p_38, "rect"), 1.0)]), J.gp(J.gp(v_p_38, "rect"), 2.0), J.mul(J.gp(J.gp(v_p_38, "rect"), 3.0), 0.75)]
		J.sp(v_p_38, "rect", _t6)
	v_c_39 = J.gp(J.gp(J.G.get("OFFMAP"), "SPOT"), "copier")
	v_p_40 = J.gp(J.G.get("SCARE_PROPS"), "printer")
	J.sp(v_p_40, "room", "pantry")
	var _t7 = [J.add(J.gp(v_c_39, 0.0), 0.12), J.add(J.gp(v_c_39, 1.0), 0.05)]
	J.sp(v_p_40, "front", _t7)
	J.sp(v_p_40, "r", 0.4)
	var _t8 = [J.sub(J.gp(v_c_39, 0.0), 0.13), J.sub(J.gp(v_c_39, 1.0), 0.2), 0.26, 0.2]
	J.sp(v_p_40, "rect", _t8)
	v_O_41 = J.G.get("OFFMAP")
	v_SP_42 = J.gp(v_O_41, "SPOT")
	v_A_43 = J.gp(v_O_41, "A")
	v_R_44 = J.gp(v_O_41, "R")
	v_px_45 = J.gp(v_O_41, "px")
	J.S_Object_("assign", [J.G.get("SCARE_PROPS"), {"micro": {"room": "pantry", "name": "微波爐", "type": "light", "tier": 1.0, "base": 16.0, "cost": 18.0, "r": 0.42, "vis": true, "front": J.gp(v_SP_42, "micro"), "rect": J.cl(v_R_44, null, [J.gp(v_A_43, "micro")]), "label": "up", "say": "自己叮"}, "fridge": {"room": "pantry", "name": "雪櫃門", "type": "cold", "tier": 1.0, "base": 14.0, "cost": 16.0, "r": 0.42, "vis": true, "front": J.gp(v_SP_42, "fridge"), "rect": J.cl(v_R_44, null, [J.gp(v_A_43, "fridge")]), "say": "自己打開"}, "kettle": {"room": "pantry", "name": "熱水壺", "type": "breath", "tier": 1.0, "base": 18.0, "cost": 18.0, "r": 0.42, "vis": true, "front": J.gp(v_SP_42, "kettle"), "rect": J.cl(v_R_44, null, [J.gp(v_A_43, "kettle")]), "label": "up", "say": "嗚——"}, "vend": {"room": "pantry", "name": "汽水機", "type": "sound", "tier": 2.0, "base": 26.0, "cost": 24.0, "r": 0.42, "vis": true, "front": J.gp(v_SP_42, "vend"), "rect": J.cl(v_R_44, null, [J.gp(v_A_43, "vend")]), "say": "哐咚"}, "tv": {"room": "meeting", "name": "電視", "type": "face", "tier": 2.0, "base": 26.0, "cost": 26.0, "r": 0.5, "vis": true, "front": [J.cl(v_px_45, null, [4920.0]), 0.72], "rect": J.cl(v_R_44, null, [J.gp(v_A_43, "tv")]), "label": "up", "say": "沙沙沙"}, "speaker": {"room": "meeting", "name": "會議電話", "type": "phone", "tier": 1.0, "base": 18.0, "cost": 18.0, "r": 0.45, "vis": true, "front": [J.cl(v_px_45, null, [5190.0]), 0.72], "rect": J.cl(v_R_44, null, [J.gp(v_A_43, "speaker")]), "label": "up", "say": "呼……"}, "chairs": {"room": "meeting", "name": "椅子自己行", "type": "shadow", "tier": 2.0, "base": 22.0, "cost": 24.0, "r": 0.55, "vis": true, "front": [J.cl(v_px_45, null, [4800.0]), 0.8], "rect": J.cl(v_R_44, null, [[4530.0, 640.0, 240.0, 270.0]]), "say": "吱——"}, "golf": {"room": "boss", "name": "高爾夫球", "type": "shadow", "tier": 1.0, "base": 16.0, "cost": 18.0, "r": 0.55, "vis": true, "front": [J.cl(v_px_45, null, [420.0]), 0.76], "rect": J.cl(v_R_44, null, [J.gp(v_A_43, "golfBag")]), "say": "咕碌——"}, "bchair": {"room": "boss", "name": "皮椅自己轉", "type": "face", "tier": 2.0, "base": 26.0, "cost": 24.0, "r": 0.45, "vis": true, "front": [J.cl(v_px_45, null, [770.0]), 0.71], "rect": J.cl(v_R_44, null, [J.gp(v_A_43, "chair")]), "label": "up", "say": "吱——"}, "trophy": {"room": "boss", "name": "獎盃", "type": "sound", "tier": 2.0, "base": 24.0, "cost": 24.0, "r": 0.5, "vis": true, "front": [J.cl(v_px_45, null, [320.0]), 0.72], "rect": J.cl(v_R_44, null, [J.gp(v_A_43, "trophy")]), "label": "up", "say": "哐啷"}}])
	J.G["SCARE_GHOSTS"] = {"afu": {"name": "阿福", "skill": "坐回工位", "type": "face", "base": 34.0, "line": "（鍵盤自己在響。螢幕上打著：「好的老闆，收到。」）"}, "pontianak": {"name": "Pontianak", "skill": "窗外笑聲", "type": "sound", "aoe": true, "base": 16.0, "line": "嘻——嘻——嘻——"}, "tianhua": {"name": "天花姐", "skill": "倒掛", "type": "face", "base": 40.0, "line": "哎喲……（頭髮垂到他面前）"}, "xiaozhi": {"name": "小紙", "skill": "紙人", "type": "shadow", "base": 32.0, "line": "（角落多了一個紙人，對著他笑）"}, "eguiking": {"name": "餓鬼王", "skill": "叮叮叮", "type": "sound", "aoe": true, "base": 14.0, "line": "叮叮叮叮！開飯了沒有？"}, "penanggal": {"name": "Penanggal", "skill": "飛頭", "type": "face", "base": 38.0, "line": "（一個頭從他身邊飄過去）"}, "laojiang": {"name": "老殭", "skill": "跳過走廊", "type": "shadow", "base": 32.0, "line": "（玻璃門外，一跳、一跳、一跳）"}}
	J.G["MIS_POST"] = J.gp(J.gp(J.G.get("OFFMAP"), "SPOT"), "reception")
	J.G["COPY_AT"] = [J.add(J.gp(J.gp(J.gp(J.G.get("OFFMAP"), "SPOT"), "copier"), 0.0), 0.16), J.add(J.gp(J.gp(J.gp(J.G.get("OFFMAP"), "SPOT"), "copier"), 1.0), 0.05)]
	J.G["EMPTY_SAY"] = J.cl(Callable(self, "_f2").bind(env), null, [])
	J.G["BRK"] = J.cl(Callable(self, "_f4").bind(env), null, [])
	J.G["_M"] = J.gp(J.G.get("OFFMAP"), "M")
	J.G["_MY"] = J.gp(J.G.get("OFFMAP"), "MY")
	J.G["_SP"] = J.gp(J.G.get("OFFMAP"), "SPOT")
	var _t54 = {"c": 0.211, "hz": (-0.7)}
	var _t55 = [1100.0, 1300.0, 1480.0]
	var _t56 = [250.0, 450.0, 760.0]
	var _t57 = J.gp(J.gp(J.G.get("OFFMAP"), "SPOT"), "elev")
	var _t58 = [["旁白", "凌晨十二點。阿福回到他生前的公司。"], ["阿福", "門禁卡還能刷。公司也沒有人通知它。"], ["系統", "親～今晚的 KPI：嚇人。點場景裡發光的東西附身，點人可以偷看手機。"], ["系統", "先用小動靜讓他起疑，等他頭上冒「！」再出大招。小心巡邏的保安阿伯，被他的手電筒照到，就會被請去喝茶。"]]
	var _t30 = ["phone", "face", "paper"]
	var _t31 = ["light", "cold"]
	var _t32 = ["paper"]
	var _t33 = {"light": "（盯住手機）燈閃？我部手機光過佢。", "cold": "凍？OT 慣咗。"}
	var _t11 = J.G.get("_M")
	var _t13 = J.cl(_t11, null, [0.24])
	var _t12 = J.G.get("_MY")
	var _t17 = [_t13, J.cl(_t12, null, [0.6]), 14.0, "work"]
	var _t14 = J.G.get("_M")
	var _t16 = J.cl(_t14, null, [0.64])
	var _t15 = J.G.get("_MY")
	var _t21 = [_t16, J.cl(_t15, null, [0.55]), 4.0, "idle"]
	var _t18 = J.G.get("_M")
	var _t20 = J.cl(_t18, null, [0.24])
	var _t19 = J.G.get("_MY")
	var _t25 = [_t20, J.cl(_t19, null, [0.6]), 12.0, "work"]
	var _t22 = J.G.get("_M")
	var _t24 = J.cl(_t22, null, [0.79])
	var _t23 = J.G.get("_MY")
	var _t29 = [_t24, J.cl(_t23, null, [0.57]), 5.0, "idle"]
	var _t26 = J.G.get("_M")
	var _t28 = J.cl(_t26, null, [0.24])
	var _t27 = J.G.get("_MY")
	var _t45 = {"k": "ken", "name": "阿Ken", "role": "加班仔", "spr": "npc_ken", "speed": 0.05, "calm": 2.2, "weak": _t30, "immune": _t31, "hide": _t32, "imm": _t33, "karma": 3.0, "phone": true, "route": [_t17, _t21, _t25, _t29, [_t28, J.cl(_t27, null, [0.6]), 12.0, "work"], [J.gp(J.gp(J.gp(J.G.get("_SP"), "restSeats"), 0.0), 0.0), J.gp(J.gp(J.gp(J.G.get("_SP"), "restSeats"), 0.0), 1.0), 9.0, "brk_nap"]], "say": {"immune": "（沒抬頭，在回老闆訊息）", "rational": ["我太累了……", "眼花，一定是眼花。", "加班加到出現幻覺了。"], "prime": ["……誰？", "剛剛是不是有聲音？", "（回頭看了一眼）"], "hit": ["哇！！", "老……老闆？！", "不、不是我做的！"], "weak": "（手機一亮，整個人跳起來）在、在！我在！", "flee": "阿Ken 看著空氣很久：「你也是……做到這麼晚？」第二天，他遞了辭職信，回老家吃媽媽煮的飯。"}, "chat": [["老闆", "23:02", "阿Ken，明早九點董事會，PPT 再改一版。"], ["阿Ken", "23:03", "好的老闆，收到。"], ["老闆", "01:40", "在嗎？"], ["阿Ken", "01:40", "在！"], ["媽", "昨天", "阿Ken，這個禮拜回來吃飯嗎？媽煲了湯。"], ["阿Ken", "昨天", "下次吧，最近很忙"]]}
	var _t34 = J.G.get("_M")
	var _t36 = [J.cl(_t34, null, [0.66]), 0.8, "work"]
	var _t37 = [26.0, 40.0]
	var _t38 = [["water", 2.6, J.gp(J.G.get("_SP"), "water"), [4.0, 6.0], "去茶水間斟杯水先。"], ["tea", 1.6, J.gp(J.G.get("_SP"), "kettle"), [4.0, 6.0], "沖杯茶頂下。"], ["copier", 1.2, J.G.get("COPY_AT"), [3.0, 5.0], "印埋份 log。"], ["rest", 1.2, "rest", [8.0, 12.0], J.gp(J.G.get("BRK"), "it"), null, ["brk_phone", "brk_drink"]], ["out", 1.4, "out", [12.0, 18.0], "去個洗手間。", "返嚟喇。"]]
	var _t39 = {"cue": "（收拾筆電）差唔多喇……", "bye": "終於收工！", "back": "唔記得拎充電器……", "work": ["server 又 down……", "邊個又改咗個 config……", "（飲一啖珍奶）頂住先。"]}
	var _t40 = ["phone", "sound", "light"]
	var _t41 = ["cold", "paper"]
	var _t42 = ["light"]
	var _t43 = {"cold": "（拉緊帽T）我有帽，唔凍。", "paper": "紙？我哋 paperless 㗎。"}
	var _t44 = (-1.0)
	var _t35 = J.G.get("_M")
	var _t52 = {"k": "it", "name": "小晴", "role": "IT 工程師・今晚值班", "spr": "npc_it", "speed": 0.08, "post": _t36, "work": _t37, "trips": _t38, "lines": _t39, "calm": 2.4, "weak": _t40, "immune": _t41, "hide": _t42, "imm": _t43, "karma": _t44, "phone": true, "route": [[J.cl(_t35, null, [0.66]), 0.8, 16.0, "work"]], "say": {"immune": "（拉緊帽T：我有帽子，不冷。）", "rational": ["應該是網絡延遲。", "是 cache 的問題。", "伺服器又在搞我。", "一定是 Windows 在更新。"], "prime": ["……誰 ping 我？", "耳機裡怎麼有人在講話？", "（把耳機拿下來聽了一下）"], "hit": ["production 掛了嗎？！", "這不是 bug……這不是 bug……", "我只是來值班的！"], "weak": "（手機和耳機一起響：「小晴……還在嗎……」）！！！", "flee": "小晴把電腦一合：「這個 bug 明天再修！」衝進電梯。第二天她請了一星期假，去喝了七杯珍奶。"}, "chat": [["值班系統", "01:12", "【P1】23 樓伺服器溫度 4°C，請立即處理。"], ["陳總", "02:03", "小晴，網站是不是慢了？我覺得慢了。"], ["小晴", "02:04", "陳總，是你家的 Wi-Fi。"], ["二十三樓八卦群", "00:30", "聽說 23 樓半夜影印機會自己印東西 👻"], ["小晴", "00:31", "是驅動程式的問題，不要迷信。"], ["媽", "23:40", "妹，又值夜班？記得吃飯。"], ["小晴", "23:41", "有啦，珍奶算一餐。"], ["珍奶店", "22:58", "您的訂單：全糖、多珍珠、去冰（第 3 杯）已送達。"]]}
	var _t53 = {"k": "mis", "name": "美美", "role": "陳總的秘書・心腹", "spr": "npc_mis", "speed": 0.075, "post": [J.gp(J.G.get("MIS_POST"), 0.0), J.gp(J.G.get("MIS_POST"), 1.0), "idle", 1.0], "work": [22.0, 34.0], "trips": [["copier", 1.6, J.G.get("COPY_AT"), [4.0, 6.0], "又要印多十份……"], ["rest", 1.0, "rest", [8.0, 12.0], J.gp(J.G.get("BRK"), "mis"), null, ["brk_phone", "brk_drink"]], ["micro", 2.0, J.gp(J.G.get("_SP"), "micro"), [4.0, 6.0], "叮個宵夜先～"], ["boss", 2.2, "boss", [4.0, 6.0], "陳總～份文件幫你印好喇～"], ["out", 1.6, "out", [12.0, 20.0], "去補個妝先。", "補完妝喇～"]], "lines": {"cue": "（照鏡、拎手袋）", "bye": "我走先喇～", "back": "仲有嘢未搞掂……", "late": "仲有嘢未搞掂……", "work": ["（接電話）陳總開緊會喎～", "又要印多十份……", "（釘文件）好煩呀～"]}, "calm": 2.6, "weak": ["phone", "breath"], "immune": ["cold"], "hide": ["breath"], "imm": {"cold": "冷氣凍啲先唔會甩妝。"}, "karma": 1.0, "phone": true, "fleeVia": "boss", "route": [[J.gp(J.G.get("MIS_POST"), 0.0), J.gp(J.G.get("MIS_POST"), 1.0), 7.0, "idle"]], "say": {"immune": "冷氣凍啲先唔會甩妝。", "rational": ["一定係阿Ken搞嘢。", "唔好嚇人啦，我粉底會裂㗎。", "呢啲嘢搵阿Ken做啦。"], "prime": ["……邊個喺度呀？", "（照一照鏡）我頭髮亂咗？", "咩聲嚟㗎？"], "hit": ["呀——我隻甲！", "陳總～有嘢呀～", "我部電話！"], "weak": "（自拍鏡頭入面，佢後面多咗一塊臉）", "shout": "陳總～救命呀～！", "flee": "美美尖叫著衝去找陳總：「陳總～救命呀～！」第二天她請了「驚嚇假」，飛去日本購物壓驚，報告全部丟給阿Ken。"}, "chat": [["陳總", "00:45", "美美，聽日陪我去見客，記得著靚啲。"], ["美美", "00:46", "陳總～人哋要放假啦～"], ["陳總", "00:46", "放！做完呢季就放！"], ["姊妹群", "01:02", "你仲喺公司？"], ["美美", "01:03", "係呀，陳總話佢一個人驚 🙄"], ["美美", "01:20", "阿Ken，份報告你幫我打埋佢啦，陳總要嘅。"], ["阿Ken", "01:21", "……好。"], ["網購", "昨天", "您訂購的「防甩妝噴霧 ×6」已出貨。"]]}
	var _t50 = [J.gp(J.gp(J.G.get("_SP"), "bossDesk"), 0.0), J.gp(J.gp(J.G.get("_SP"), "bossDesk"), 1.0), "call", (-1.0)]
	var _t51 = [22.0, 32.0]
	var _t49 = ["golf", 2.2, J.gp(J.G.get("_SP"), "golf"), [7.0, 10.0], "（練下推桿）"]
	var _t46 = J.G.get("_M")
	var _t48 = J.cl(_t46, null, [0.4])
	var _t47 = J.G.get("_MY")
	J.G["SCARE_SITES"] = {"office": {"name": "舊公司・二十三樓", "bg": "office_pano", "pano": true, "layout": "office", "persp": _t54, "need": "ch1_end", "shift": true, "stars": _t55, "oldStars": _t56, "exit": _t57, "intro": _t58, "npcs": [_t45, _t52, _t53, {"k": "boss", "name": "陳總", "role": "新老闆", "spr": "npc_boss", "speed": 0.075, "post": _t50, "work": _t51, "trips": [_t49, ["ken", 1.4, [_t48, J.cl(_t47, null, [0.665])], [4.0, 6.0], "阿Ken，份 PPT 呢？"], ["coffee", 1.2, J.gp(J.G.get("_SP"), "coffee"), [4.0, 6.0], "（自己沖咖啡）"], ["rest", 0.9, "rest", [8.0, 12.0], J.gp(J.G.get("BRK"), "boss"), null, ["brk_drink", "brk_phone"]], ["out", 1.0, "out", [12.0, 18.0], "出去食支煙。", "繼續做嘢！"]], "lines": {"cue": "（看錶）咁夜喇……", "bye": "我走先，你哋繼續做。", "late": "全部人留低開會！", "golf": ["（推桿）入！", "（推桿）……又偏咗。"], "work": ["喂？我唔理，聽朝九點前要見到！", "（對住電話）你講多次？預算爆咗？", "呢份計劃書邊個寫㗎？成份重做！", "（揭文件）專業啲好唔好呀……"]}, "calm": 3.0, "weak": ["paper", "shadow"], "immune": ["sound", "phone"], "hide": ["shadow"], "imm": {"sound": "（戴住降噪耳機睇高爾夫）", "phone": "（掛咗佢）唔識嘅號碼一律唔聽。"}, "karma": 2.0, "phone": true, "route": [[J.gp(J.gp(J.G.get("_SP"), "bossDesk"), 0.0), J.gp(J.gp(J.G.get("_SP"), "bossDesk"), 1.0), 9.0, "call"]], "say": {"immune": "（戴著降噪耳機看高爾夫）", "rational": ["哼，風水問題。", "明天叫 Master Lee 來看。", "一定是實習生在搞鬼。"], "prime": ["……水晶球呢？", "誰在那裡？", "（把水晶球抱緊）"], "hit": ["誰印的？！虧損報表？！", "誰批准你加班的？！", "Master Lee！救命！"], "weak": "（看到影印機自己在印）本、本季虧損報表？誰印的？！", "flee": "陳總抱著水晶球衝進電梯：「明天開始，全公司……在家工作！」"}, "chat": [["Master Lee", "昨天", "陳總，你這層樓陰氣很重，水晶球記得對著窗口。"], ["Master Lee", "昨天", "還有，千萬不要讓影印機半夜自己開。"], ["秘書", "22:10", "陳總，阿Ken 已經連續加班第三晚了。"], ["陳總", "22:11", "很好。叫他明晚繼續。"]]}, {"k": "auntie", "name": "清潔安娣", "role": "今晚逐間房拖地", "spr": "npc_auntie", "speed": 0.05, "post": [J.gp(J.gp(J.gp(J.G.get("OFFMAP"), "LANE"), 0.0), 0.0), J.gp(J.gp(J.gp(J.G.get("OFFMAP"), "LANE"), 0.0), 1.0), "mop"], "lane": J.gp(J.G.get("OFFMAP"), "LANE"), "laneWait": [3.5, 5.5], "trips": [["out", 1.0, "out", [10.0, 15.0], "換桶水先。", "拖埋呢邊就搞掂。"]], "tripEvery": 2.0, "lines": {"cue": "（收拾水桶）", "bye": "聽日見。", "late": "仲有一層未拖。", "work": ["拖完又踩污……", "呢度又有咖啡漬。"]}, "calm": 3.0, "weak": ["face", "breath"], "immune": ["light", "sound"], "hide": ["breath"], "imm": {"light": "電線有問題，聽日叫人整。", "sound": "哼，咩聲未聽過？"}, "karma": (-1.0), "mop": true, "route": [[J.gp(J.gp(J.gp(J.G.get("OFFMAP"), "LANE"), 0.0), 0.0), J.gp(J.gp(J.gp(J.G.get("OFFMAP"), "LANE"), 0.0), 1.0), 2.0, "mop"]], "backfire": {"paper": "（拍照發到群組）誰亂印？！地上全是紙！"}, "say": {"immune": "電線有問題，明天叫人修。", "rational": ["哼。", "加班費要算雙倍。", "冷氣開這麼冷，電費誰付？"], "prime": ["誰？出來！", "我剛拖完的地……", "（握緊拖把）"], "hit": ["哎呀！我的地！", "誰站在那裡？！", "我不怕你！（揮拖把）"], "weak": "誰的腳印？！天花板也有？！", "flee": "安娣拖著水桶走了：「這間我不做了！隔壁大廈的鬼比較有禮貌！」"}, "chat": [["老闆娘", "20:00", "安娣，今晚地板要拖三次，陳總說要亮。"], ["清潔安娣", "20:01", "好。"], ["兒子", "22:30", "媽，又做到幾點？"], ["清潔安娣", "22:31", "做完就回。你先吃，不用等。"]]}, {"k": "guard", "name": "保安阿伯", "role": "夜班三十年・每間房都巡", "spr": "npc_guard", "speed": 0.07, "post": [J.mc(J.G.get("OFFMAP"), "Ru", [2.49]), 0.79, "doze", (-1.0)], "work": [40.0, 55.0], "lines": {"work": ["（打瞌睡）Zzz……", "（醒一醒）……冇嘢，冇嘢。"]}, "trips": [["patrol", 1.0, "patrol", [3.0, 4.0], "巡一巡先。"]], "calm": 99.0, "weak": [], "immune": ["light", "cold", "sound", "paper", "phone", "face", "shadow"], "karma": (-1.0), "guard": true, "phone": true, "route": [[J.mc(J.G.get("OFFMAP"), "Ru", [2.49]), 0.79, 3.0, "look"]], "say": {"immune": "又來？喝杯茶吧。", "calmOther": "沒事啦，我在這裡三十年了。", "catchG": "出來啦，不要躲。來，喝杯茶。"}, "chat": [["阿福", "三個月前", "阿伯，我又加班，今晚不用幫我留燈。"], ["保安阿伯", "三個月前", "留咯。你走了我才關。"], ["女兒", "今天", "爸，今晚幾點下班？"], ["保安阿伯", "今天", "天亮。"], ["保安阿伯", "今天", "那個阿Ken，跟阿福一樣，都不回家。"]]}]}}
	J.G["PANO_ZOOM"] = 0.72
	J.G["Scare"] = {"active": false, "open": Callable(self, "_f6").bind(env), "migrate": Callable(self, "_f17").bind(env), "starsOf": Callable(self, "_f18").bind(env), "start": Callable(self, "_f19").bind(env), "resize": Callable(self, "_f27").bind(env), "viewW": Callable(self, "_f28").bind(env), "clampCam": Callable(self, "_f29").bind(env), "camRoom": Callable(self, "_f30").bind(env), "roomOf": Callable(self, "_f31").bind(env), "sameRoom": Callable(self, "_f32").bind(env), "onScreen": Callable(self, "_f33").bind(env), "bindPan": Callable(self, "_f34").bind(env), "camTick": Callable(self, "_f43").bind(env), "bgScale": Callable(self, "_f44").bind(env), "pt": Callable(self, "_f45").bind(env), "depth": Callable(self, "_f46").bind(env), "persp": Callable(self, "_f47").bind(env), "bgAR": Callable(self, "_f48").bind(env), "hhF": Callable(self, "_f49").bind(env), "hh": Callable(self, "_f50").bind(env), "office": Callable(self, "_f51").bind(env), "frame": Callable(self, "_f52").bind(env), "step": Callable(self, "_f55").bind(env), "moveNpc": Callable(self, "_f61").bind(env), "rng": Callable(self, "_f64").bind(env), "U": Callable(self, "_f65").bind(env), "exitPt": Callable(self, "_f66").bind(env), "present": Callable(self, "_f67").bind(env), "shiftInit": Callable(self, "_f69").bind(env), "goOut": Callable(self, "_f73").bind(env), "outTick": Callable(self, "_f74").bind(env), "elevator": Callable(self, "_f76").bind(env), "planMove": Callable(self, "_f77").bind(env), "freeSeat": Callable(self, "_f79").bind(env), "restStep": Callable(self, "_f84").bind(env), "sitting": Callable(self, "_f88").bind(env), "viaElev": Callable(self, "_f89").bind(env), "mkStep": Callable(self, "_f90").bind(env), "planNext": Callable(self, "_f91").bind(env), "inDoor": Callable(self, "_f94").bind(env), "walkBlocked": Callable(self, "_f96").bind(env), "busy": Callable(self, "_f99").bind(env), "freeSpot": Callable(self, "_f102").bind(env), "bossCall": Callable(self, "_f105").bind(env), "tagExt": Callable(self, "_f110").bind(env), "drawCue": Callable(self, "_f111").bind(env), "inBeam": Callable(self, "_f112").bind(env), "groupRoom": Callable(self, "_f113").bind(env), "inGroup": Callable(self, "_f114").bind(env), "propOK": Callable(self, "_f115").bind(env), "useProp": Callable(self, "_f117").bind(env), "usePhone": Callable(self, "_f120").bind(env), "useBreath": Callable(self, "_f121").bind(env), "useGhost": Callable(self, "_f122").bind(env), "gpq": Callable(self, "_f125").bind(env), "ghostType": Callable(self, "_f127").bind(env), "hit": Callable(self, "_f130").bind(env), "rnd": Callable(self, "_f139").bind(env), "headsDown": Callable(self, "_f140").bind(env), "watching": Callable(self, "_f141").bind(env), "sees": Callable(self, "_f142").bind(env), "witnesses": Callable(self, "_f143").bind(env), "hearers": Callable(self, "_f145").bind(env), "wakeGuard": Callable(self, "_f147").bind(env), "perceive": Callable(self, "_f149").bind(env), "expose": Callable(self, "_f160").bind(env), "workOf": Callable(self, "_f165").bind(env), "expoTick": Callable(self, "_f166").bind(env), "daoTick": Callable(self, "_f168").bind(env), "jumpy": Callable(self, "_f169").bind(env), "addKarma": Callable(self, "_f170").bind(env), "tap": Callable(self, "_f171").bind(env), "renderDock": Callable(self, "_f172").bind(env), "renderTarget": Callable(self, "_f180").bind(env), "profile": Callable(self, "_f184").bind(env), "peek": Callable(self, "_f187").bind(env), "hud": Callable(self, "_f191").bind(env), "bubble": Callable(self, "_f196").bind(env), "floatTick": Callable(self, "_f199").bind(env), "float": Callable(self, "_f201").bind(env), "floatOld": Callable(self, "_f202").bind(env), "toast": Callable(self, "_f203").bind(env), "dust": Callable(self, "_f204").bind(env), "propParts": Callable(self, "_f205").bind(env), "draw": Callable(self, "_f206").bind(env), "drawEdge": Callable(self, "_f219").bind(env), "drawBreath": Callable(self, "_f220").bind(env), "propMarks": Callable(self, "_f221").bind(env), "react": Callable(self, "_f225").bind(env), "animNpc": Callable(self, "_f226").bind(env), "onReact": Callable(self, "_f227").bind(env), "rigOK": Callable(self, "_f228").bind(env), "visPos": Callable(self, "_f229").bind(env), "npcPose": Callable(self, "_f230").bind(env), "drawNpc": Callable(self, "_f233").bind(env), "drawNpcSprite": Callable(self, "_f234").bind(env), "npcFx": Callable(self, "_f235").bind(env), "drawTeam": Callable(self, "_f237").bind(env), "drawGhost": Callable(self, "_f242").bind(env), "drawBubble": Callable(self, "_f243").bind(env), "finish": Callable(self, "_f247").bind(env)}
	J.cl(Callable(self, "_f252").bind(env), null, [])

func _f251(this_, a: Array, env):
	var v_a_1218 = null
	v_a_1218 = J.arg(a, 0)
	return (J.gp(v_a_1218, floor(J.num((randf() * J.len(v_a_1218))))) if J.t(J.S_Array_("isArray", [v_a_1218])) else v_a_1218)

func _f1(this_, a: Array, env):
	var v_c_31 = null; var v_k_32 = null; var v_x_33 = null; var v_y_34 = null; var v_s_35 = null; var v_o_36 = null
	v_c_31 = J.arg(a, 0)
	v_k_32 = J.arg(a, 1)
	v_x_33 = J.arg(a, 2)
	v_y_34 = J.arg(a, 3)
	v_s_35 = J.arg(a, 4)
	v_o_36 = J.arg(a, 5)
	var _t3 = null
	if (not J.seq(J.typeof_(J.G.get("__nat_drawChar")), "undefined")):
		var _t1 = J.G.get("__nat_drawChar")
		_t3 = J.cl(_t1, null, [v_c_31, v_k_32, v_x_33, v_y_34, v_s_35, (v_o_36 if J.t(v_o_36) else {})])
	else:
		var _t2 = J.G.get("ART")
		_t3 = J.mc(_t2, "drawChar", [v_c_31, v_k_32, v_x_33, v_y_34, v_s_35, v_o_36])
	return _t3

func _f3(this_, a: Array, env):
	var v_yue_47 = null; var v_zh_48 = null
	v_yue_47 = J.arg(a, 0)
	v_zh_48 = J.arg(a, 1)
	var _t9 = (not J.seq(J.typeof_(J.G.get("LANG")), "undefined"))
	if J.t((J.gp(J.G.get("LANG"), "add") if _t9 else _t9)):
		J.mc(J.G.get("LANG"), "add", [{J.key(v_yue_47): v_zh_48}])
	return v_yue_47

func _f2(this_, a: Array, env):
	var v_T_46 = null
	v_T_46 = Callable(self, "_f3").bind(env)
	J.cl(v_T_46, null, ["陳總～搵我呀？", "陳總～找我嗎？"])
	J.cl(v_T_46, null, ["陳總，搵我？", "陳總，找我？"])
	return {"mis": J.cl(v_T_46, null, ["陳總去咗邊呀？咁我出返去等先啦。", "陳總去哪了？那我先出去等吧。"]), "it": J.cl(v_T_46, null, ["叫人入嚟自己又唔喺度……我返去做嘢先。", "叫人進來自己又不在……我先回去做事。"])}

func _f5(this_, a: Array, env):
	var v_yue_50 = null; var v_zh_51 = null
	v_yue_50 = J.arg(a, 0)
	v_zh_51 = J.arg(a, 1)
	var _t10 = (not J.seq(J.typeof_(J.G.get("LANG")), "undefined"))
	if J.t((J.gp(J.G.get("LANG"), "add") if _t10 else _t10)):
		J.mc(J.G.get("LANG"), "add", [{J.key(v_yue_50): v_zh_51}])
	return v_yue_50

func _f4(this_, a: Array, env):
	var v_T_49 = null
	v_T_49 = Callable(self, "_f5").bind(env)
	return {"it": J.cl(v_T_49, null, ["抖陣先，個 server 自己頂住。", "休息一下，伺服器自己撐著。"]), "mis": J.cl(v_T_49, null, ["坐低碌下手機先～", "坐下來滑一下手機～"]), "boss": J.cl(v_T_49, null, ["（飲啖茶）唔好話我偷懶。", "（喝口茶）別說我偷懶。"]), "auntie": J.cl(v_T_49, null, ["拖到腰都痛，坐陣先。", "拖到腰都痛，坐一會兒。"]), "ken": J.cl(v_T_49, null, ["（打個呵欠）瞇五分鐘……", "（打個呵欠）瞇五分鐘……"])}

func _f8(this_, a: Array, env):
	var v_g_60 = null
	v_g_60 = J.arg(a, 0)
	return J.seq(J.gp(v_g_60, "k"), env["k"])

func _f7(this_, a: Array, env):
	var _s12 = {"__p": env, "k": null}
	_s12["k"] = J.arg(a, 0)
	var _t62 = J.seq(_s12["k"], "afu")
	if not J.t(_t62):
		var _t61 = J.gp(J.G.get("S"), "ghosts")
		_t62 = J.mc(_t61, "some", [Callable(self, "_f8").bind(_s12)])
	return _t62

func _f9(this_, a: Array, env):
	var v_k_61 = null
	v_k_61 = J.arg(a, 0)
	return (not J.seq(v_k_61, "afu"))

func _f12(this_, a: Array, env):
	var v_x_66 = null
	v_x_66 = J.arg(a, 0)
	return J.seq(J.gp(v_x_66, "k"), "afu")

func _f11(this_, a: Array, env):
	var v_k_65 = null
	v_k_65 = J.arg(a, 0)
	var _t70 = J.gp(J.gp(env["this"], "pick"), "chosen")
	var _t73 = ("on" if J.t(J.mc(_t70, "includes", [v_k_65])) else "")
	var _t74 = ("disabled" if J.seq(v_k_65, "afu") else "")
	var _t75 = J.gp(J.gp(J.G.get("SCARE_GHOSTS"), v_k_65), "name")
	var _t76 = J.gp(J.gp(J.G.get("SCARE_GHOSTS"), v_k_65), "skill")
	var _t77 = J.gp(J.G.get("SCARE_TYPES"), J.gp(J.gp(J.G.get("SCARE_GHOSTS"), v_k_65), "type"))
	var _t72 = null
	if J.seq(v_k_65, "afu"):
		var _t71 = J.gp(J.G.get("S"), "ghosts")
		_t72 = J.mc(J.G.get("GP"), "pow", [J.mc(_t71, "find", [Callable(self, "_f12").bind(env)])])
	else:
		_t72 = J.mc(J.G.get("GP"), "kindPow", [v_k_65])
	return ("<button class=\"sc-g " + _t73 + "\" data-k=\"" + J.str(v_k_65) + "\" " + _t74 + "><canvas data-por=\"" + J.str(v_k_65) + "\"></canvas><b>" + J.str(_t75) + "</b><small>" + J.str(_t76) + "・" + J.str(_t77) + "・鬼力 " + J.str(_t72) + "</small></button>")

func _f10(this_, a: Array, env):
	var v_best_62 = null; var v_st_63 = null; var v_h_64 = null
	var _t67 = J.gp(J.G.get("S"), "scare")
	var _t68 = (J.gp(J.gp(J.gp(J.G.get("S"), "scare"), "best"), env["siteId"]) if J.t(_t67) else _t67)
	v_best_62 = (_t68 if J.t(_t68) else 0.0)
	v_st_63 = J.mc(env["this"], "starsOf", [env["siteId"], v_best_62])
	v_h_64 = ("<p class=\"desc\">" + J.str(J.gp(env["site"], "name")) + "。天亮前三分鐘。<br>先用小動靜讓人起疑，等他頭上冒「！」再出大招。</p>")
	var _t69 = J.add(v_h_64, ("<p class=\"desc\">最高紀錄：" + J.str(v_best_62) + "　" + J.str(J.mc("★", "repeat", [v_st_63])) + J.str(J.mc("☆", "repeat", [J.sub(3.0, v_st_63)])) + "</p>"))
	v_h_64 = _t69
	var _t78 = J.mc(env["ghosts"], "map", [Callable(self, "_f11").bind(env)])
	var _t79 = J.add(v_h_64, ("<div class=\"sc-pick\">" + J.str(J.mc(_t78, "join", [""])) + "</div>"))
	v_h_64 = _t79
	var _t80 = J.add(v_h_64, ("<p class=\"desc\">阿福一定去。另外最多帶兩隻。</p><button class=\"btn gold wide\" id=\"sc-go\">出發，回陽間</button>"))
	v_h_64 = _t80
	return v_h_64

func _f15(this_, a: Array, env):
	var v_k_68 = null; var v_c_69 = null
	v_k_68 = J.gp(J.gp(env["b"], "dataset"), "k")
	v_c_69 = J.gp(J.gp(env["__p"]["this"], "pick"), "chosen")
	if J.t(J.mc(v_c_69, "includes", [v_k_68])):
		J.mc(v_c_69, "splice", [J.mc(v_c_69, "indexOf", [v_k_68]), 1.0])
	else:
		if (J.len(v_c_69) < 3.0):
			J.mc(v_c_69, "push", [v_k_68])
		else:
			J.mc(J.G.get("Fx"), "toast", ["最多帶兩隻"])
			return null
	var _t87 = J.G.get("$")
	var _t88 = J.cl(_t87, null, ["#sheet .sh-body"])
	var _t89 = J.cl(env["__p"]["render"], null, [])
	J.sp(_t88, "innerHTML", _t89)
	J.cl(env["__p"]["bind"], null, [])

func _f14(this_, a: Array, env):
	var _s19 = {"__p": env, "b": null}
	_s19["b"] = J.arg(a, 0)
	var _t86 = _s19["b"]
	var _t90 = Callable(self, "_f15").bind(_s19)
	J.sp(_t86, "onclick", _t90)
	return _t90

func _f16(this_, a: Array, env):
	J.mc(J.G.get("UI"), "close", [])
	J.mc(env["this"], "start", [env["siteId"], J.mc(J.gp(J.gp(env["this"], "pick"), "chosen"), "slice", [])])

func _f13(this_, a: Array, env):
	var _t81 = J.G.get("paintPortraits")
	var _t82 = J.G.get("$")
	J.cl(_t81, null, [J.cl(_t82, null, ["#sheet"])])
	var _t83 = J.G.get("$")
	var _t84 = J.cl(_t83, null, ["#sheet"])
	var _t85 = J.mc(_t84, "querySelectorAll", [".sc-g"])
	J.mc(_t85, "forEach", [Callable(self, "_f14").bind(env)])
	var _t91 = J.G.get("$")
	var _t92 = J.cl(_t91, null, ["#sc-go"])
	var _t93 = Callable(self, "_f16").bind(env)
	J.sp(_t92, "onclick", _t93)

func _f6(this_, a: Array, env):
	var _s11 = {"__p": env, "this": null, "siteId": null, "site": null, "ghosts": null, "render": null, "bind": null}
	_s11["this"] = this_
	_s11["siteId"] = J.arg(a, 0)
	var _t59 = (not J.seq(J.typeof_(J.G.get("ScareX")), "undefined"))
	if J.t((J.gp(J.G.get("ScareX"), "open") if _t59 else _t59)):
		return J.mc(J.G.get("ScareX"), "open", [_s11["siteId"]])
	J.mc(_s11["this"], "migrate", [])
	_s11["site"] = J.gp(J.G.get("SCARE_SITES"), _s11["siteId"])
	var _t60 = J.S_Object_("keys", [J.G.get("SCARE_GHOSTS")])
	_s11["ghosts"] = J.mc(_t60, "filter", [Callable(self, "_f7").bind(_s11)])
	var _t63 = _s11["this"]
	var _t64 = ["afu"]
	var _t65 = J.mc(_s11["ghosts"], "filter", [Callable(self, "_f9").bind(_s11)])
	var _t66 = {"chosen": J.mc(_t64, "concat", [J.mc(_t65, "slice", [0.0, 2.0])])}
	J.sp(_t63, "pick", _t66)
	_s11["render"] = Callable(self, "_f10").bind(_s11)
	_s11["bind"] = Callable(self, "_f13").bind(_s11)
	J.mc(J.G.get("UI"), "sheet", ["回陽間・夜班", J.cl(_s11["render"], null, [])])
	J.cl(_s11["bind"], null, [])

func _f17(this_, a: Array, env):
	var v_a_72 = null; var v_b_73 = null; var v_k_74 = null; var v_v_75 = null; var v_i_76 = null; var v_k_77 = null; var v_st_78 = null; var v_v_79 = null; var v_a_80 = null; var v_b_81 = null; var v_i_82 = null
	var _t94 = J.seq(J.typeof_(J.G.get("S")), "undefined")
	var _t95 = (_t94 if _t94 else (not J.t(J.G.get("S"))))
	var _t96 = (_t95 if _t95 else (not J.t(J.gp(J.G.get("S"), "scare"))))
	if (_t96 if _t96 else J.cmp(J.gp(J.gp(J.G.get("S"), "scare"), "fv"), 3.0, ">=")):
		return null
	if J.seq(J.gp(J.gp(J.G.get("S"), "scare"), "fv"), 2.0):
		var _t97 = J.gp(J.G.get("S"), "scare")
		J.sp(_t97, "fv", 3.0)
		v_a_72 = [0.0, 650.0, 1200.0, 1600.0]
		v_b_73 = [0.0, 1100.0, 1300.0, 1480.0]
		for _t98 in J.keys(J.gp(J.gp(J.G.get("S"), "scare"), "best")):
			v_k_74 = _t98
			v_v_75 = J.gp(J.gp(J.gp(J.G.get("S"), "scare"), "best"), v_k_74)
			var _t99 = (not J.t(v_v_75))
			if (_t99 if _t99 else (not J.seq(v_k_74, "office"))):
				continue
			v_i_76 = 0.0
			while true:
				var _t100 = J.cmp(v_i_76, 2.0, "<")
				if not (J.cmp(v_v_75, J.gp(v_a_72, J.add(v_i_76, 1.0)), ">=") if _t100 else _t100): break
				v_i_76 = J.num(v_i_76) + 1.0
			var _t101 = J.gp(J.gp(J.G.get("S"), "scare"), "best")
			var _t102 = (J.round(J.num(J.add(J.gp(v_b_73, 3.0), (J.sub(v_v_75, J.gp(v_a_72, 3.0)) * 0.75)))) if J.cmp(v_v_75, J.gp(v_a_72, 3.0), ">=") else J.round(J.num(J.add(J.gp(v_b_73, v_i_76), J.div((J.sub(v_v_75, J.gp(v_a_72, v_i_76)) * J.sub(J.gp(v_b_73, J.add(v_i_76, 1.0)), J.gp(v_b_73, v_i_76))), J.sub(J.gp(v_a_72, J.add(v_i_76, 1.0)), J.gp(v_a_72, v_i_76)))))))
			J.sp(_t101, v_k_74, _t102)
		if J.seq(J.typeof_(J.G.get("save")), "function"):
			J.cl(J.G.get("save"), null, [])
		return null
	var _t103 = J.gp(J.G.get("S"), "scare")
	J.sp(_t103, "fv", 3.0)
	for _t104 in J.keys(J.gp(J.gp(J.G.get("S"), "scare"), "best")):
		v_k_77 = _t104
		v_st_78 = J.gp(J.G.get("SCARE_SITES"), v_k_77)
		v_v_79 = J.gp(J.gp(J.gp(J.G.get("S"), "scare"), "best"), v_k_77)
		var _t105 = (not J.t(v_st_78))
		var _t106 = (_t105 if _t105 else (not J.t(J.gp(v_st_78, "oldStars"))))
		if (_t106 if _t106 else (not J.t(v_v_79))):
			continue
		var _t107 = [0.0]
		v_a_80 = J.mc(_t107, "concat", [J.gp(v_st_78, "oldStars")])
		var _t108 = [0.0]
		v_b_81 = J.mc(_t108, "concat", [J.gp(v_st_78, "stars")])
		v_i_82 = 0.0
		while true:
			var _t109 = J.cmp(v_i_82, 2.0, "<")
			if not (J.cmp(v_v_79, J.gp(v_a_80, J.add(v_i_82, 1.0)), ">=") if _t109 else _t109): break
			v_i_82 = J.num(v_i_82) + 1.0
		var _t110 = J.gp(J.gp(J.G.get("S"), "scare"), "best")
		var _t111 = (J.round(J.num(J.add(J.gp(v_b_81, 3.0), J.div((J.sub(v_v_79, J.gp(v_a_80, 3.0)) * J.sub(J.gp(v_b_81, 3.0), J.gp(v_b_81, 2.0))), J.sub(J.gp(v_a_80, 3.0), J.gp(v_a_80, 2.0)))))) if J.cmp(v_v_79, J.gp(v_a_80, 3.0), ">=") else J.round(J.num(J.add(J.gp(v_b_81, v_i_82), J.div((J.sub(v_v_79, J.gp(v_a_80, v_i_82)) * J.sub(J.gp(v_b_81, J.add(v_i_82, 1.0)), J.gp(v_b_81, v_i_82))), J.sub(J.gp(v_a_80, J.add(v_i_82, 1.0)), J.gp(v_a_80, v_i_82)))))))
		J.sp(_t110, v_k_77, _t111)
	if J.seq(J.typeof_(J.G.get("save")), "function"):
		J.cl(J.G.get("save"), null, [])

func _f18(this_, a: Array, env):
	var v_siteId_85 = null; var v_v_86 = null; var v_s_87 = null
	v_siteId_85 = J.arg(a, 0)
	v_v_86 = J.arg(a, 1)
	J.mc(this_, "migrate", [])
	v_s_87 = J.gp(J.gp(J.G.get("SCARE_SITES"), v_siteId_85), "stars")
	return (3.0 if J.cmp(v_v_86, J.gp(v_s_87, 2.0), ">=") else (2.0 if J.cmp(v_v_86, J.gp(v_s_87, 1.0), ">=") else (1.0 if J.cmp(v_v_86, J.gp(v_s_87, 0.0), ">=") else 0.0)))

func _f20(this_, a: Array, env):
	var v_k_97 = null
	v_k_97 = J.arg(a, 0)
	var _t123 = J.gp(env["this"], "cd")
	J.sp(_t123, v_k_97, 0.0)
	return 0.0

func _f21(this_, a: Array, env):
	var v_d_98 = null; var v_i_99 = null
	v_d_98 = J.arg(a, 0)
	v_i_99 = J.arg(a, 1)
	return {"d": v_d_98, "x": J.gp(J.gp(J.gp(v_d_98, "route"), 0.0), 0.0), "y": J.gp(J.gp(J.gp(v_d_98, "route"), 0.0), 1.0), "wi": 0.0, "wait": J.mul(J.gp(J.gp(J.gp(v_d_98, "route"), 0.0), 2.0), (0.3 + J.mul(v_i_99, 0.25))), "dir": 1.0, "fear": 0.0, "peak": 0.0, "gone": false, "exitT": 0.0, "bounce": 0.0, "look": 0.0, "bub": null, "bubT": 0.0, "act": J.gp(J.gp(J.gp(v_d_98, "route"), 0.0), 3.0), "ph": (randf() * 6.0)}

func _f22(this_, a: Array, env):
	var _t138 = J.G.get("confirmInline")
	var _t139 = J.G.get("$")
	if (not J.t(J.cl(_t138, null, [J.cl(_t139, null, ["#sc-quit"]), "確定收工？"]))):
		return null
	J.mc(env["this"], "finish", [true])

func _f23(this_, a: Array, env):
	var v_e_100 = null
	v_e_100 = J.arg(a, 0)
	return J.mc(env["this"], "tap", [v_e_100])

func _f24(this_, a: Array, env):
	var _t151 = J.gp(env["this"], "active")
	if J.t(((not J.t(J.gp(env["this"], "headless"))) if J.t(_t151) else _t151)):
		J.mc(env["this"], "resize", [])

func _f25(this_, a: Array, env):
	var v_n_103 = null
	v_n_103 = J.arg(a, 0)
	return J.mc(env["this"], "frame", [v_n_103])

func _f26(this_, a: Array, env):
	var _t158 = env["this"]
	J.sp(_t158, "paused", false)
	var _t159 = env["this"]
	var _t160 = J.S_performance_("now", [])
	J.sp(_t159, "last", _t160)

func _f19(this_, a: Array, env):
	var v_siteId_90 = null; var v_team_91 = null; var v_headless_92 = null; var v_seed_93 = null; var v_site_94 = null; var v_el_95 = null; var v_cv_96 = null; var v_k_101 = null; var v_r_102 = null
	var _s30 = {"__p": env, "this": null}
	_s30["this"] = this_
	v_siteId_90 = J.arg(a, 0)
	v_team_91 = J.arg(a, 1)
	v_headless_92 = J.arg(a, 2)
	v_seed_93 = J.arg(a, 3)
	v_site_94 = J.gp(J.G.get("SCARE_SITES"), v_siteId_90)
	var _t116 = _s30["this"]
	var _t113 = (-99.0)
	var _t114 = {}
	var _t115 = (not (not J.t(v_headless_92)))
	var _t112 = (not J.seq(J.typeof_(J.G.get("GhostStreet")), "undefined"))
	J.S_Object_("assign", [_t116, {"endAt": 0.0, "expo": 0.0, "expoMax": 0.0, "expoT": _t113, "alert": false, "daoCall": 0.0, "daoIn": false, "expelled": false, "kpiCut": false, "known": _t114, "guardKarma": false, "site": v_site_94, "siteId": v_siteId_90, "active": true, "headless": _t115, "t": 0.0, "kpi": 0.0, "mana": J.add(60.0, (J.mc(J.G.get("GhostStreet"), "bonus", ["mana"]) if ((not J.t(v_headless_92)) if _t112 else _t112) else 0.0)), "team": v_team_91, "fx": [], "parts": [], "floats": [], "fq": [], "bq": [], "karma": [], "shake": 0.0, "vign": 0.0, "paused": (not J.t(v_headless_92)), "sel": null}])
	var _t117 = _s30["this"]
	var _t118 = {}
	J.sp(_t117, "cd", _t118)
	var _t119 = _s30["this"]
	var _t120 = {}
	J.sp(_t119, "pcd", _t120)
	var _t121 = _s30["this"]
	var _t122 = {}
	J.sp(_t121, "caught", _t122)
	J.mc(v_team_91, "forEach", [Callable(self, "_f20").bind(_s30)])
	var _t124 = _s30["this"]
	var _t125 = J.gp(v_site_94, "npcs")
	var _t126 = J.mc(_t125, "map", [Callable(self, "_f21").bind(_s30)])
	J.sp(_t124, "npcs", _t126)
	var _t127 = _s30["this"]
	var _t128 = (v_seed_93 if (not J.leq(v_seed_93, null)) else J.mod(J.S_Date_("now", []), 100000.0))
	J.sp(_t127, "seed", _t128)
	var _t129 = _s30["this"]
	J.sp(_t129, "door", 0.0)
	if J.t(J.gp(v_site_94, "shift")):
		J.mc(_s30["this"], "shiftInit", [])
	var _t130 = _s30["this"]
	var _t131 = J.gp(J.gp(_s30["this"], "npcs"), 0.0)
	J.sp(_t130, "sel", _t131)
	var _t132 = _s30["this"]
	J.sp(_t132, "selAuto", false)
	if (not J.seq(J.typeof_(J.G.get("ScareX")), "undefined")):
		J.mc(J.G.get("ScareX"), "night", [_s30["this"]])
	if J.t(v_headless_92):
		return null
	var _t133 = J.G.get("$")
	v_el_95 = J.cl(_t133, null, ["#scare"])
	var _t134 = J.gp(v_el_95, "classList")
	J.mc(_t134, "add", ["on"])
	var _t135 = ("<div id=\"sc-top\"><button class=\"btn sm ghost\" id=\"sc-quit\">收工</button><span id=\"sc-clock\"></span><div id=\"sc-mana\"><i></i><b>陰氣</b></div><span id=\"sc-kpi\"></span></div>\n      <div id=\"sc-stage\"><canvas id=\"sc-cvs\"></canvas>" + J.str((J.mc(J.G.get("OFFMAP"), "mapHTML", []) if J.t(J.gp(v_site_94, "pano")) else "")) + "</div>\n      <div id=\"sc-panel\"><div id=\"sc-target\"></div><div id=\"sc-dock\"></div></div><div id=\"sc-phone\"></div>")
	J.sp(v_el_95, "innerHTML", _t135)
	var _t136 = J.G.get("$")
	var _t137 = J.cl(_t136, null, ["#sc-quit"])
	var _t140 = Callable(self, "_f22").bind(_s30)
	J.sp(_t137, "onclick", _t140)
	var _t141 = J.G.get("$")
	v_cv_96 = J.cl(_t141, null, ["#sc-cvs"])
	var _t142 = _s30["this"]
	J.sp(_t142, "camX", 0.0)
	var _t143 = _s30["this"]
	J.sp(_t143, "camV", 0.0)
	var _t144 = _s30["this"]
	J.sp(_t144, "follow", false)
	if J.t(J.gp(v_site_94, "pano")):
		J.mc(_s30["this"], "bindPan", [v_cv_96])
	else:
		J.mc(v_cv_96, "addEventListener", ["pointerdown", Callable(self, "_f23").bind(_s30)])
	J.mc(J.G.get("Sound"), "setMode", ["story"])
	J.mc(_s30["this"], "renderDock", [])
	J.mc(_s30["this"], "renderTarget", [])
	J.mc(_s30["this"], "resize", [])
	if J.t(J.gp(v_site_94, "pano")):
		J.mc(J.G.get("OFFMAP"), "init", [_s30["this"]])
		var _t145 = _s30["this"]
		var _t146 = J.mc(_s30["this"], "clampCam", [J.sub(J.gp(J.gp(J.gp(_s30["this"], "npcs"), 0.0), "x"), J.mul(J.mc(_s30["this"], "viewW", []), 0.5))])
		J.sp(_t145, "camX", _t146)
	if J.t(J.mc(_s30["this"], "office", [])):
		J.mc(J.G.get("OFFICE"), "init", [_s30["this"]])
		for _t147 in J.keys(J.G.get("SCARE_PROPS")):
			v_k_101 = _t147
			var _t148 = J.gp(J.gp(J.G.get("SCARE_PROPS"), v_k_101), "obj")
			v_r_102 = (J.mc(J.G.get("OFFICE"), "rectOf", [J.gp(J.gp(J.G.get("SCARE_PROPS"), v_k_101), "obj")]) if J.t(_t148) else _t148)
			if J.t(v_r_102):
				var _t149 = J.gp(J.G.get("SCARE_PROPS"), v_k_101)
				J.sp(_t149, "rect", v_r_102)
	if (not J.t(J.gp(_s30["this"], "_rs"))):
		var _t150 = _s30["this"]
		J.sp(_t150, "_rs", true)
		J.S_window_("addEventListener", ["resize", Callable(self, "_f24").bind(_s30)])
	var _t153 = (not J.seq(J.typeof_(J.G.get("__nat_scare")), "undefined"))
	if J.t(_t153):
		var _t152 = J.G.get("__nat_scare")
		_t153 = J.cl(_t152, null, [_s30["this"]])
	if J.t(_t153):
		J.mc(_s30["this"], "resize", [])
		if J.t(J.gp(v_site_94, "pano")):
			var _t154 = _s30["this"]
			var _t155 = J.mc(_s30["this"], "clampCam", [J.sub(J.gp(J.gp(J.gp(_s30["this"], "npcs"), 0.0), "x"), J.mul(J.mc(_s30["this"], "viewW", []), 0.5))])
			J.sp(_t154, "camX", _t155)
	var _t156 = _s30["this"]
	var _t157 = J.S_performance_("now", [])
	J.sp(_t156, "last", _t157)
	J.F_requestAnimationFrame([Callable(self, "_f25").bind(_s30)])
	J.mc(J.G.get("Story"), "queue", [{"style": "sys", "lines": J.gp(v_site_94, "intro")}, Callable(self, "_f26").bind(_s30)])

func _f27(this_, a: Array, env):
	var v_c_106 = null; var v_box_107 = null; var v_dpr_108 = null; var v_r_109 = null
	if J.t(J.gp(this_, "_nat")):
		v_r_109 = J.cl(J.G.get("__nat_scSize"), null, [])
		var _t161 = this_
		var _t162 = J.gp(v_r_109, 0.0)
		J.sp(_t161, "W", _t162)
		var _t163 = this_
		var _t164 = J.gp(v_r_109, 1.0)
		J.sp(_t163, "H", _t164)
		var _t165 = this_
		J.sp(_t165, "dpr", 1.0)
		return null
	var _t166 = J.G.get("$")
	v_c_106 = J.cl(_t166, null, ["#sc-cvs"])
	var _t167 = J.G.get("$")
	v_box_107 = J.mc(J.cl(_t167, null, ["#sc-stage"]), "getBoundingClientRect", [])
	var _t168 = J.gp(J.G.get("window"), "devicePixelRatio")
	var _t169 = J.gp(J.G.get("window"), "devicePixelRatio")
	v_dpr_108 = J.min_([2.0, (_t169 if J.t(_t169) else 1.0)])
	var _t170 = J.mul(J.gp(v_box_107, "width"), v_dpr_108)
	J.sp(v_c_106, "width", _t170)
	var _t171 = J.mul(J.gp(v_box_107, "height"), v_dpr_108)
	J.sp(v_c_106, "height", _t171)
	var _t172 = J.gp(v_c_106, "style")
	var _t173 = J.add(J.gp(v_box_107, "width"), "px")
	J.sp(_t172, "width", _t173)
	var _t174 = J.gp(v_c_106, "style")
	var _t175 = J.add(J.gp(v_box_107, "height"), "px")
	J.sp(_t174, "height", _t175)
	var _t176 = this_
	var _t177 = J.gp(v_box_107, "width")
	J.sp(_t176, "W", _t177)
	var _t178 = this_
	var _t179 = J.gp(v_box_107, "height")
	J.sp(_t178, "H", _t179)
	var _t180 = this_
	J.sp(_t180, "dpr", v_dpr_108)

func _f28(this_, a: Array, env):
	var v_b_112 = null
	v_b_112 = J.mc(this_, "bgScale", [])
	var _t181 = J.gp(this_, "W")
	return J.div((_t181 if J.t(_t181) else 390.0), J.mul(J.gp(v_b_112, "iw"), J.gp(v_b_112, "s")))

func _f29(this_, a: Array, env):
	var v_x_115 = null
	v_x_115 = J.arg(a, 0)
	return J.max_([0.0, J.min_([J.sub(J.gp(J.G.get("OFFMAP"), "WW"), J.mc(this_, "viewW", [])), v_x_115])])

func _f30(this_, a: Array, env):
	var _t182 = J.gp(this_, "camX")
	return J.mc(J.G.get("OFFMAP"), "roomAt", [J.add((_t182 if J.t(_t182) else 0.0), J.div(J.mc(this_, "viewW", []), 2.0))])

func _f31(this_, a: Array, env):
	var v_n_120 = null
	v_n_120 = J.arg(a, 0)
	return J.gp(J.mc(J.G.get("OFFMAP"), "roomAt", [J.gp(v_n_120, "x")]), "k")

func _f32(this_, a: Array, env):
	var v_a_123 = null; var v_b_124 = null
	v_a_123 = J.arg(a, 0)
	v_b_124 = J.arg(a, 1)
	var _t183 = (not J.t(J.gp(J.gp(this_, "site"), "pano")))
	return (_t183 if _t183 else J.seq(J.mc(J.G.get("OFFMAP"), "roomAt", [J.gp(v_a_123, "x")]), J.mc(J.G.get("OFFMAP"), "roomAt", [J.gp(v_b_124, "x")])))

func _f33(this_, a: Array, env):
	var v_x_127 = null; var v_m_128 = null
	v_x_127 = J.arg(a, 0)
	v_m_128 = J.arg(a, 1)
	var _t184 = (0.25 if J.leq(v_m_128, null) else v_m_128)
	v_m_128 = _t184
	var _t185 = J.gp(this_, "camX")
	var _t187 = J.cmp(v_x_127, J.sub((_t185 if J.t(_t185) else 0.0), v_m_128), ">")
	if J.t(_t187):
		var _t186 = J.gp(this_, "camX")
		_t187 = J.cmp(v_x_127, J.add(J.add((_t186 if J.t(_t186) else 0.0), J.mc(this_, "viewW", [])), v_m_128), "<")
	return _t187

func _f35(this_, a: Array, env):
	var v_b_137 = null
	v_b_137 = J.mc(env["this"], "bgScale", [])
	return J.mul(J.gp(v_b_137, "iw"), J.gp(v_b_137, "s"))

func _f36(this_, a: Array, env):
	var v_e_138 = null; var v___139 = null
	v_e_138 = J.arg(a, 0)
	var _t188 = {"x0": J.gp(v_e_138, "clientX"), "y0": J.gp(v_e_138, "clientY"), "c0": J.gp(env["this"], "camX"), "moved": false, "lx": J.gp(v_e_138, "clientX"), "lt": J.S_performance_("now", []), "id": J.gp(v_e_138, "pointerId")}
	env["d"] = _t188
	var _t189 = env["this"]
	J.sp(_t189, "camV", 0.0)
	J.mc(env["cv"], "setPointerCapture", [J.gp(v_e_138, "pointerId")])

func _f37(this_, a: Array, env):
	var v_e_140 = null; var v_dx_141 = null; var v_now_142 = null; var v_dt_143 = null
	v_e_140 = J.arg(a, 0)
	if (not J.t(env["d"])):
		return null
	v_dx_141 = J.sub(J.gp(v_e_140, "clientX"), J.gp(env["d"], "x0"))
	var _t190 = (not J.t(J.gp(env["d"], "moved")))
	if ((absf(J.num(v_dx_141)) > 9.0) if _t190 else _t190):
		var _t191 = env["d"]
		J.sp(_t191, "moved", true)
	if J.t(J.gp(env["d"], "moved")):
		v_now_142 = J.S_performance_("now", [])
		v_dt_143 = J.max_([16.0, J.sub(v_now_142, J.gp(env["d"], "lt"))])
		var _t192 = env["this"]
		var _t193 = J.mc(env["this"], "clampCam", [J.sub(J.gp(env["d"], "c0"), J.div(v_dx_141, J.cl(env["unit"], null, [])))])
		J.sp(_t192, "camX", _t193)
		var _t194 = env["this"]
		var _t195 = J.max_([(-2.5), J.min_([2.5, (J.mul(0.7, J.gp(env["this"], "camV")) + J.div((0.3 * J.div((-J.sub(J.gp(v_e_140, "clientX"), J.gp(env["d"], "lx"))), J.cl(env["unit"], null, []))), J.div(v_dt_143, 1000.0)))])])
		J.sp(_t194, "camV", _t195)
		var _t196 = env["d"]
		var _t197 = J.gp(v_e_140, "clientX")
		J.sp(_t196, "lx", _t197)
		var _t198 = env["d"]
		J.sp(_t198, "lt", v_now_142)
		var _t199 = env["this"]
		var _t200 = J.gp(env["this"], "t")
		J.sp(_t199, "userPan", _t200)

func _f38(this_, a: Array, env):
	var v_e_144 = null; var v_was_145 = null
	v_e_144 = J.arg(a, 0)
	if (not J.t(env["d"])):
		return null
	v_was_145 = env["d"]
	env["d"] = null
	if (not J.t(J.gp(v_was_145, "moved"))):
		var _t201 = env["this"]
		J.sp(_t201, "camV", 0.0)
		J.mc(env["this"], "tap", [v_e_144])
	else:
		var _t202 = (J.sub(J.S_performance_("now", []), J.gp(v_was_145, "lt")) > 90.0)
		if (_t202 if _t202 else (absf(J.num(J.sub(J.gp(v_e_144, "clientX"), J.gp(v_was_145, "x0")))) < 40.0)):
			var _t203 = env["this"]
			J.sp(_t203, "camV", 0.0)
		var _t204 = env["this"]
		var _t205 = J.gp(env["this"], "t")
		J.sp(_t204, "userPan", _t205)

func _f39(this_, a: Array, env):
	env["d"] = null

func _f40(this_, a: Array, env):
	var v_e_146 = null; var v_r_147 = null; var v_x_148 = null
	v_e_146 = J.arg(a, 0)
	v_r_147 = J.mc(env["m"], "getBoundingClientRect", [])
	v_x_148 = J.mul(J.div(J.sub(J.gp(v_e_146, "clientX"), J.gp(v_r_147, "left")), J.gp(v_r_147, "width")), J.gp(J.G.get("OFFMAP"), "WW"))
	var _t207 = env["this"]
	J.sp(_t207, "camV", 0.0)
	var _t208 = env["this"]
	var _t209 = J.mc(env["this"], "clampCam", [J.sub(v_x_148, J.div(J.mc(env["this"], "viewW", []), 2.0))])
	J.sp(_t208, "camTo", _t209)
	var _t210 = env["this"]
	var _t211 = J.gp(env["this"], "t")
	J.sp(_t210, "userPan", _t211)

func _f41(this_, a: Array, env):
	var _t214 = env["this"]
	var _t215 = (not J.t(J.gp(env["this"], "follow")))
	J.sp(_t214, "follow", _t215)
	var _t216 = J.gp(env["f"], "classList")
	J.mc(_t216, "toggle", ["on", J.gp(env["this"], "follow")])
	if J.t(J.gp(env["this"], "follow")):
		var _t217 = env["this"]
		var _t218 = (-99.0)
		J.sp(_t217, "userPan", _t218)

func _f42(this_, a: Array, env):
	return (not (not J.t(env["d"])))

func _f34(this_, a: Array, env):
	var v_up_134 = null
	var _s52 = {"__p": env, "this": null, "cv": null, "d": null, "unit": null, "m": null, "f": null}
	_s52["this"] = this_
	_s52["cv"] = J.arg(a, 0)
	_s52["d"] = null
	_s52["unit"] = Callable(self, "_f35").bind(_s52)
	J.mc(_s52["cv"], "addEventListener", ["pointerdown", Callable(self, "_f36").bind(_s52)])
	J.mc(_s52["cv"], "addEventListener", ["pointermove", Callable(self, "_f37").bind(_s52)])
	v_up_134 = Callable(self, "_f38").bind(_s52)
	J.mc(_s52["cv"], "addEventListener", ["pointerup", v_up_134])
	J.mc(_s52["cv"], "addEventListener", ["pointercancel", Callable(self, "_f39").bind(_s52)])
	var _t206 = J.G.get("$")
	_s52["m"] = J.cl(_t206, null, ["#sc-map"])
	if J.t(_s52["m"]):
		J.mc(_s52["m"], "addEventListener", ["pointerdown", Callable(self, "_f40").bind(_s52)])
	var _t212 = J.G.get("$")
	_s52["f"] = J.cl(_t212, null, ["#sc-follow"])
	if J.t(_s52["f"]):
		var _t213 = _s52["f"]
		var _t219 = Callable(self, "_f41").bind(_s52)
		J.sp(_t213, "onclick", _t219)
	var _t220 = _s52["this"]
	var _t221 = Callable(self, "_f42").bind(_s52)
	J.sp(_t220, "_panning", _t221)

func _f43(this_, a: Array, env):
	var v_rdt_151 = null; var v_vw_152 = null; var v_c_153 = null; var v_n_154 = null; var v_vx_155 = null; var v_l_156 = null; var v_r_157 = null
	v_rdt_151 = J.arg(a, 0)
	if (not J.t(J.gp(J.gp(this_, "site"), "pano"))):
		return null
	v_vw_152 = J.mc(this_, "viewW", [])
	if (not J.leq(J.gp(this_, "camTo"), null)):
		var _t222 = this_
		var _t223 = J.add(J.gp(_t222, "camX"), (J.sub(J.gp(this_, "camTo"), J.gp(this_, "camX")) * J.min_([1.0, J.mul(v_rdt_151, 9.0)])))
		J.sp(_t222, "camX", _t223)
		if (absf(J.num(J.sub(J.gp(this_, "camTo"), J.gp(this_, "camX")))) < 0.002):
			var _t224 = this_
			var _t225 = J.gp(this_, "camTo")
			J.sp(_t224, "camX", _t225)
			var _t226 = this_
			J.sp(_t226, "camTo", null)
	else:
		var _t227 = J.gp(this_, "_panning")
		if (not J.t((J.mc(this_, "_panning", []) if J.t(_t227) else _t227))):
			if (absf(J.num(J.gp(this_, "camV"))) > 0.01):
				var _t228 = this_
				var _t229 = J.add(J.gp(_t228, "camX"), J.mul(J.gp(this_, "camV"), v_rdt_151))
				J.sp(_t228, "camX", _t229)
				var _t230 = this_
				var _t231 = J.mul(J.gp(_t230, "camV"), exp(J.num(((-J.num(v_rdt_151)) * 4.5))))
				J.sp(_t230, "camV", _t231)
			v_n_154 = J.gp(this_, "sel")
			var _t232 = J.gp(this_, "follow")
			var _t233 = (v_n_154 if J.t(_t232) else _t232)
			var _t234 = ((not J.t(J.gp(v_n_154, "gone"))) if J.t(_t233) else _t233)
			var _t235 = ((not J.t(J.gp(v_n_154, "out"))) if J.t(_t234) else _t234)
			var _t236 = ((not J.t(J.gp(v_n_154, "fleeing"))) if J.t(_t235) else _t235)
			var _t237 = ((not J.t(J.gp(v_n_154, "leaving"))) if J.t(_t236) else _t236)
			var _t238 = ((not J.t(J.gp(this_, "selAuto"))) if J.t(_t237) else _t237)
			var _t239 = ((J.sub(J.gp(this_, "t"), J.gp(this_, "userPan")) > 2.5) if J.t(_t238) else _t238)
			if J.t(((absf(J.num(J.gp(this_, "camV"))) < 0.05) if J.t(_t239) else _t239)):
				v_vx_155 = (J.gp(v_n_154, "vX") if (not J.leq(J.gp(v_n_154, "vX"), null)) else J.gp(v_n_154, "x"))
				v_l_156 = J.add(J.gp(this_, "camX"), J.mul(v_vw_152, 0.18))
				v_r_157 = J.add(J.gp(this_, "camX"), J.mul(v_vw_152, 0.82))
				var _t240 = J.cmp(v_vx_155, v_l_156, "<")
				if (_t240 if _t240 else J.cmp(v_vx_155, v_r_157, ">")):
					var _t241 = this_
					var _t242 = J.add(J.gp(_t241, "camX"), ((J.sub(v_vx_155, J.mul(v_vw_152, 0.18)) if J.cmp(v_vx_155, v_l_156, "<") else J.sub(v_vx_155, J.mul(v_vw_152, 0.82))) * J.min_([1.0, J.mul(v_rdt_151, 2.2)])))
					J.sp(_t241, "camX", _t242)
	v_c_153 = J.mc(this_, "clampCam", [J.gp(this_, "camX")])
	if (not J.seq(v_c_153, J.gp(this_, "camX"))):
		var _t243 = this_
		J.sp(_t243, "camV", 0.0)
	var _t244 = this_
	J.sp(_t244, "camX", v_c_153)

func _f44(this_, a: Array, env):
	var v_img_160 = null; var v_iw_161 = null; var v_ih_162 = null; var v_W_163 = null; var v_H_164 = null; var v_s_165 = null; var v_W_166 = null; var v_H_167 = null; var v_iw_168 = null; var v_ih_169 = null; var v_s_170 = null
	var _t245 = J.gp(this_, "site")
	if J.t((J.gp(J.gp(this_, "site"), "pano") if J.t(_t245) else _t245)):
		var _t246 = J.gp(this_, "W")
		v_W_166 = (_t246 if J.t(_t246) else 390.0)
		var _t247 = J.gp(this_, "H")
		v_H_167 = (_t247 if J.t(_t247) else 580.0)
		v_iw_168 = J.gp(J.G.get("OFFMAP"), "PXU")
		v_ih_169 = J.gp(J.G.get("OFFMAP"), "SH")
		v_s_170 = J.max_([J.mul(J.div(v_H_167, v_ih_169), J.G.get("PANO_ZOOM")), J.div(v_W_166, J.mul(J.gp(J.G.get("OFFMAP"), "WW"), v_iw_168))])
		var _t248 = J.gp(this_, "camX")
		return {"s": v_s_170, "iw": v_iw_168, "ih": v_ih_169, "ox": J.mul(J.mul((-J.num((_t248 if J.t(_t248) else 0.0))), v_iw_168), v_s_170), "oy": J.sub(v_H_167, J.mul(v_ih_169, v_s_170))}
	v_img_160 = J.gp(J.G.get("SPR"), J.add("bg_", J.gp(J.gp(this_, "site"), "bg")))
	var _t249 = (J.gp(v_img_160, "naturalWidth") if J.t(v_img_160) else v_img_160)
	v_iw_161 = (_t249 if J.t(_t249) else 768.0)
	var _t250 = (J.gp(v_img_160, "naturalHeight") if J.t(v_img_160) else v_img_160)
	v_ih_162 = (_t250 if J.t(_t250) else 1152.0)
	var _t251 = J.gp(this_, "W")
	v_W_163 = (_t251 if J.t(_t251) else 390.0)
	var _t252 = J.gp(this_, "H")
	v_H_164 = (_t252 if J.t(_t252) else 580.0)
	v_s_165 = J.max_([J.div(v_W_163, v_iw_161), J.div(v_H_164, v_ih_162)])
	return {"s": v_s_165, "iw": v_iw_161, "ih": v_ih_162, "ox": J.div(J.sub(v_W_163, J.mul(v_iw_161, v_s_165)), 2.0), "oy": J.sub(v_H_164, J.mul(v_ih_162, v_s_165))}

func _f45(this_, a: Array, env):
	var v_fx_173 = null; var v_fy_174 = null; var v_b_175 = null
	v_fx_173 = J.arg(a, 0)
	v_fy_174 = J.arg(a, 1)
	v_b_175 = J.mc(this_, "bgScale", [])
	return [J.add(J.mul(J.mul(v_fx_173, J.gp(v_b_175, "iw")), J.gp(v_b_175, "s")), J.gp(v_b_175, "ox")), J.add(J.mul(J.mul(v_fy_174, J.gp(v_b_175, "ih")), J.gp(v_b_175, "s")), J.gp(v_b_175, "oy"))]

func _f46(this_, a: Array, env):
	var v_y_178 = null
	v_y_178 = J.arg(a, 0)
	var _t253 = J.gp(this_, "site")
	var _t256 = null
	if J.t((J.gp(J.gp(this_, "site"), "persp") if J.t(_t253) else _t253)):
		var _t255 = J.mc(this_, "hh", [v_y_178])
		var _t254 = J.gp(this_, "H")
		_t256 = J.div(_t255, J.mul((_t254 if J.t(_t254) else 580.0), 0.165))
	else:
		_t256 = (0.72 + (0.5 * J.max_([0.0, J.min_([1.0, J.div(J.sub(v_y_178, 0.55), 0.42)])])))
	return _t256

func _f47(this_, a: Array, env):
	var _t257 = J.gp(this_, "site")
	return (J.gp(J.gp(this_, "site"), "persp") if J.t(_t257) else _t257)

func _f48(this_, a: Array, env):
	var v_b_183 = null
	v_b_183 = J.mc(this_, "bgScale", [])
	return J.div(J.gp(v_b_183, "ih"), J.gp(v_b_183, "iw"))

func _f49(this_, a: Array, env):
	var v_y_186 = null; var v_p_187 = null
	v_y_186 = J.arg(a, 0)
	v_p_187 = J.gp(J.gp(this_, "site"), "persp")
	return J.mul(J.gp(v_p_187, "c"), J.sub(v_y_186, J.gp(v_p_187, "hz")))

func _f50(this_, a: Array, env):
	var v_y_190 = null; var v_b_191 = null
	v_y_190 = J.arg(a, 0)
	if (not J.t(J.mc(this_, "persp", []))):
		var _t258 = J.gp(this_, "H")
		return J.mul(J.mul((_t258 if J.t(_t258) else 580.0), 0.165), J.mc(this_, "depth", [v_y_190]))
	v_b_191 = J.mc(this_, "bgScale", [])
	return J.mul(J.mul(J.gp(v_b_191, "ih"), J.gp(v_b_191, "s")), J.mc(this_, "hhF", [v_y_190]))

func _f51(this_, a: Array, env):
	var _t259 = (not J.t(J.gp(this_, "headless")))
	var _t260 = (J.gp(this_, "site") if _t259 else _t259)
	var _t261 = (J.seq(J.gp(J.gp(this_, "site"), "layout"), "office") if J.t(_t260) else _t260)
	return ((not J.seq(J.typeof_(J.G.get("OFFICE")), "undefined")) if J.t(_t261) else _t261)

func _f53(this_, a: Array, env):
	var v_n_199 = null
	v_n_199 = J.arg(a, 0)
	return J.mc(env["this"], "frame", [v_n_199])

func _f54(this_, a: Array, env):
	var v_n_200 = null
	v_n_200 = J.arg(a, 0)
	return J.mc(env["this"], "frame", [v_n_200])

func _f52(this_, a: Array, env):
	var v_now_196 = null; var v_rdt_197 = null; var v_dt_198 = null
	var _s82 = {"__p": env, "this": null}
	_s82["this"] = this_
	v_now_196 = J.arg(a, 0)
	if (not J.t(J.gp(_s82["this"], "active"))):
		return null
	if (J.sub(v_now_196, J.gp(_s82["this"], "last")) < (J.div(1000.0, 30.0) - 2.0)):
		J.F_requestAnimationFrame([Callable(self, "_f53").bind(_s82)])
		return null
	v_rdt_197 = J.min_([0.05, J.div(J.sub(v_now_196, J.gp(_s82["this"], "last")), 1000.0)])
	var _t262 = J.gp(_s82["this"], "timeScale")
	v_dt_198 = J.mul(v_rdt_197, (_t262 if J.t(_t262) else 1.0))
	var _t263 = _s82["this"]
	J.sp(_t263, "last", v_now_196)
	J.mc(_s82["this"], "camTick", [v_rdt_197])
	var _t264 = (not J.t(J.gp(_s82["this"], "paused")))
	if ((not J.t(J.mc(J.G.get("Story"), "busy", []))) if _t264 else _t264):
		J.mc(_s82["this"], "step", [v_dt_198])
	if (not J.t(J.gp(_s82["this"], "active"))):
		return null
	J.mc(_s82["this"], "floatTick", [v_rdt_197])
	J.mc(_s82["this"], "draw", [J.div(v_now_196, 1000.0)])
	if (not J.t(J.gp(_s82["this"], "paused"))):
		J.mc(_s82["this"], "hud", [])
	J.F_requestAnimationFrame([Callable(self, "_f54").bind(_s82)])

func _f56(this_, a: Array, env):
	var v_n_208 = null
	v_n_208 = J.arg(a, 0)
	return J.gp(J.gp(v_n_208, "d"), "guard")

func _f57(this_, a: Array, env):
	var v_f_210 = null
	v_f_210 = J.arg(a, 0)
	var _t288 = J.sub(J.gp(v_f_210, "life"), env["dt"])
	J.sp(v_f_210, "life", _t288)
	return (_t288 > 0.0)

func _f58(this_, a: Array, env):
	var v_p_211 = null
	v_p_211 = J.arg(a, 0)
	if J.cmp(J.gp(v_p_211, "delay"), 0.0, ">"):
		var _t292 = J.sub(J.gp(v_p_211, "delay"), env["dt"])
		J.sp(v_p_211, "delay", _t292)
		return true
	var _t293 = J.sub(J.gp(v_p_211, "life"), env["dt"])
	J.sp(v_p_211, "life", _t293)
	var _t294 = J.add(J.gp(v_p_211, "x"), J.mul(J.gp(v_p_211, "vx"), env["dt"]))
	J.sp(v_p_211, "x", _t294)
	var _t295 = J.add(J.gp(v_p_211, "y"), J.mul(J.gp(v_p_211, "vy"), env["dt"]))
	J.sp(v_p_211, "y", _t295)
	var _t296 = J.gp(v_p_211, "g")
	var _t297 = J.add(J.gp(v_p_211, "vy"), J.mul((_t296 if J.t(_t296) else 0.0), env["dt"]))
	J.sp(v_p_211, "vy", _t297)
	var _t298 = J.gp(v_p_211, "rot")
	var _t300 = (_t298 if J.t(_t298) else 0.0)
	var _t299 = J.gp(v_p_211, "vr")
	var _t301 = J.add(_t300, J.mul((_t299 if J.t(_t299) else 0.0), env["dt"]))
	J.sp(v_p_211, "rot", _t301)
	return J.cmp(J.gp(v_p_211, "life"), 0.0, ">")

func _f59(this_, a: Array, env):
	var v_m_212 = null
	v_m_212 = J.arg(a, 0)
	var _t305 = J.gp(v_m_212, "bub")
	var _t306 = (J.cmp(J.gp(v_m_212, "bubT"), 0.0, ">") if J.t(_t305) else _t305)
	return ((not J.t(J.gp(v_m_212, "gone"))) if J.t(_t306) else _t306)

func _f60(this_, a: Array, env):
	var v_n_214 = null
	v_n_214 = J.arg(a, 0)
	var _t319 = J.gp(v_n_214, "gone")
	var _t321 = (_t319 if J.t(_t319) else J.gp(J.gp(v_n_214, "d"), "guard"))
	if not J.t(_t321):
		var _t320 = J.gp(v_n_214, "left")
		_t321 = (J.gp(v_n_214, "out") if J.t(_t320) else _t320)
	return _t321

func _f55(this_, a: Array, env):
	var v_g_204 = null; var v_k_205 = null; var v_k_206 = null; var v_n_207 = null; var v_f_209 = null; var v_q_213 = null
	var _s86 = {"__p": env, "dt": null}
	_s86["dt"] = J.arg(a, 0)
	var _t265 = this_
	var _t266 = J.add(J.gp(_t265, "t"), _s86["dt"])
	J.sp(_t265, "t", _t266)
	var _t267 = this_
	var _t268 = J.min_([100.0, J.add(J.gp(this_, "mana"), J.mul(7.0, _s86["dt"]))])
	J.sp(_t267, "mana", _t268)
	for _t269 in J.keys(J.gp(this_, "cd")):
		v_k_205 = _t269
		var _t270 = J.gp(this_, "cd")
		var _t271 = J.max_([0.0, J.sub(J.gp(J.gp(this_, "cd"), v_k_205), _s86["dt"])])
		J.sp(_t270, v_k_205, _t271)
	if J.t(J.gp(this_, "pcd")):
		for _t272 in J.keys(J.gp(this_, "pcd")):
			v_k_206 = _t272
			var _t273 = J.gp(this_, "pcd")
			var _t274 = J.max_([0.0, J.sub(J.gp(J.gp(this_, "pcd"), v_k_206), _s86["dt"])])
			J.sp(_t273, v_k_206, _t274)
	for _t275 in J.iter(J.gp(this_, "npcs")):
		v_n_207 = _t275
		J.mc(this_, "moveNpc", [v_n_207, _s86["dt"]])
		if (not J.t(J.gp(this_, "headless"))):
			J.mc(this_, "animNpc", [v_n_207, _s86["dt"]])
	if J.t(J.mc(this_, "office", [])):
		J.mc(J.G.get("OFFICE"), "tick", [_s86["dt"]])
		if J.t(J.gp(J.gp(this_, "site"), "pano")):
			J.mc(J.G.get("OFFMAP"), "tick", [_s86["dt"]])
	J.mc(this_, "expoTick", [_s86["dt"]])
	if (not J.seq(J.typeof_(J.G.get("ScareX")), "undefined")):
		J.mc(J.G.get("ScareX"), "tick", [this_, _s86["dt"]])
	var _t276 = J.gp(this_, "npcs")
	v_g_204 = J.mc(_t276, "find", [Callable(self, "_f56").bind(_s86)])
	for _t277 in J.iter(J.gp(this_, "fx")):
		v_f_209 = _t277
		var _t278 = J.gp(v_f_209, "ghost")
		var _t279 = ((not J.t(J.gp(v_f_209, "caught"))) if J.t(_t278) else _t278)
		var _t280 = (v_g_204 if J.t(_t279) else _t279)
		if J.t((J.mc(this_, "inBeam", [v_g_204, J.gp(v_f_209, "gx"), J.gp(v_f_209, "gy")]) if J.t(_t280) else _t280)):
			J.sp(v_f_209, "caught", true)
			var _t281 = J.gp(this_, "caught")
			var _t282 = J.gp(v_f_209, "ghost")
			J.sp(_t281, _t282, true)
			var _t283 = J.gp(this_, "cd")
			var _t284 = J.gp(v_f_209, "ghost")
			J.sp(_t283, _t284, 999.0)
			J.mc(this_, "bubble", [v_g_204, J.gp(J.gp(J.gp(v_g_204, "d"), "say"), "catchG"), 2.6])
			J.mc(this_, "react", [v_g_204, "catch"])
			var _t285 = J.gp(this_, "t")
			J.sp(v_f_209, "busted", _t285)
			J.mc(this_, "float", [J.gp(v_f_209, "gx"), J.sub(J.gp(v_f_209, "gy"), 0.08), (J.str(J.gp(J.gp(J.G.get("SCARE_GHOSTS"), J.gp(v_f_209, "ghost")), "name")) + " 被請去喝茶"), "#9ad"])
			J.mc(this_, "addKarma", [J.gp(v_g_204, "d"), 0.0, ""])
			if (not J.t(J.gp(this_, "headless"))):
				J.mc(this_, "renderDock", [])
	var _t286 = this_
	var _t287 = J.gp(this_, "fx")
	var _t289 = J.mc(_t287, "filter", [Callable(self, "_f57").bind(_s86)])
	J.sp(_t286, "fx", _t289)
	var _t290 = this_
	var _t291 = J.gp(this_, "parts")
	var _t302 = J.mc(_t291, "filter", [Callable(self, "_f58").bind(_s86)])
	J.sp(_t290, "parts", _t302)
	if (not J.t(J.gp(this_, "headless"))):
		var _t303 = J.gp(this_, "bq")
		var _t307 = (J.len(J.gp(this_, "bq")) if J.t(_t303) else _t303)
		if J.t(_t307):
			var _t304 = J.gp(this_, "npcs")
			_t307 = (J.len(J.mc(_t304, "filter", [Callable(self, "_f59").bind(_s86)])) < 2.0)
		if J.t(_t307):
			while true:
				if not J.t(J.len(J.gp(this_, "bq"))): break
				v_q_213 = J.mc(J.gp(this_, "bq"), "shift", [])
				var _t308 = (J.sub(J.gp(this_, "t"), J.gp(v_q_213, "at")) < 4.0)
				var _t309 = ((not J.t(J.gp(J.gp(v_q_213, "n"), "gone"))) if _t308 else _t308)
				if ((not J.t(J.gp(J.gp(v_q_213, "n"), "out"))) if _t309 else _t309):
					J.mc(this_, "bubble", [J.gp(v_q_213, "n"), J.gp(v_q_213, "text"), J.gp(v_q_213, "dur"), J.gp(v_q_213, "ghost")])
					break
	var _t310 = this_
	var _t311 = J.max_([0.0, J.sub(J.gp(this_, "shake"), J.mul(_s86["dt"], 2.2))])
	J.sp(_t310, "shake", _t311)
	var _t312 = this_
	var _t313 = J.max_([0.0, J.sub(J.gp(this_, "vign"), J.mul(_s86["dt"], 1.2))])
	J.sp(_t312, "vign", _t313)
	if J.t(J.gp(this_, "expelled")):
		if (not J.t(J.gp(this_, "kpiCut"))):
			var _t314 = this_
			J.sp(_t314, "kpiCut", true)
			var _t315 = this_
			var _t316 = J.round(J.num(J.mul(J.gp(this_, "kpi"), J.gp(J.G.get("EXPO"), "expelMul"))))
			J.sp(_t315, "kpi", _t316)
		if J.t(J.gp(this_, "headless")):
			var _t317 = this_
			J.sp(_t317, "active", false)
		else:
			if (J.sub(J.gp(this_, "t"), J.gp(this_, "endAt")) > 2.6):
				J.mc(this_, "finish", [false])
		return null
	var _t322 = J.cmp(J.gp(this_, "t"), J.G.get("NIGHT_SEC"), ">=")
	if not J.t(_t322):
		var _t318 = J.gp(this_, "npcs")
		_t322 = J.mc(_t318, "every", [Callable(self, "_f60").bind(_s86)])
	if J.t(_t322):
		if J.t(J.gp(this_, "headless")):
			var _t323 = this_
			J.sp(_t323, "active", false)
		else:
			if J.cmp(J.gp(this_, "t"), J.G.get("NIGHT_SEC"), ">="):
				J.mc(this_, "finish", [false])
			else:
				var _t324 = this_
				var _t325 = J.gp(this_, "endAt")
				var _t326 = (_t325 if J.t(_t325) else J.gp(this_, "t"))
				J.sp(_t324, "endAt", _t326)
				if (J.sub(J.gp(this_, "t"), J.gp(this_, "endAt")) > 2.2):
					J.mc(this_, "finish", [false])

func _f62(this_, a: Array, env):
	var v_m_226 = null
	v_m_226 = J.arg(a, 0)
	var _t335 = (not J.seq(v_m_226, env["n"]))
	var _t336 = ((not J.t(J.gp(v_m_226, "gone"))) if _t335 else _t335)
	var _t337 = ((not J.t(J.gp(v_m_226, "out"))) if _t336 else _t336)
	var _t338 = (J.mc(env["this"], "sameRoom", [v_m_226, env["n"]]) if _t337 else _t337)
	return ((J.hypot_([J.sub(J.gp(v_m_226, "x"), J.gp(env["n"], "x")), J.sub(J.gp(v_m_226, "y"), J.gp(env["n"], "y"))]) < 0.22) if J.t(_t338) else _t338)

func _f63(this_, a: Array, env):
	var v_m_235 = null
	v_m_235 = J.arg(a, 0)
	var _t381 = J.seq(J.gp(J.gp(v_m_235, "d"), "k"), J.gp(J.gp(env["n"], "d"), "fleeVia"))
	return ((not J.t(J.gp(v_m_235, "gone"))) if _t381 else _t381)

func _f61(this_, a: Array, env):
	var v_dt_218 = null; var v_near_219 = null; var v_cr_220 = null; var v_nxt_221 = null; var v_dx_222 = null; var v_dy_223 = null; var v_d_224 = null; var v_sp_225 = null; var v_k_227 = null; var v_ex_228 = null; var v_ey_229 = null; var v_dx_230 = null; var v_dy_231 = null; var v_d_232 = null; var v_sp_233 = null; var v_b_234 = null
	var _s108 = {"__p": env, "this": null, "n": null}
	_s108["this"] = this_
	_s108["n"] = J.arg(a, 0)
	v_dt_218 = J.arg(a, 1)
	var _t327 = _s108["n"]
	var _t328 = J.max_([0.0, J.sub(J.gp(_s108["n"], "bounce"), J.mul(v_dt_218, 2.5))])
	J.sp(_t327, "bounce", _t328)
	var _t329 = _s108["n"]
	var _t330 = J.add(J.gp(_t329, "ph"), v_dt_218)
	J.sp(_t329, "ph", _t330)
	if J.cmp(J.gp(_s108["n"], "bubT"), 0.0, ">"):
		var _t331 = _s108["n"]
		var _t332 = J.sub(J.gp(_t331, "bubT"), v_dt_218)
		J.sp(_t331, "bubT", _t332)
		if J.cmp(J.gp(_s108["n"], "bubT"), 0.0, "<="):
			var _t333 = _s108["n"]
			J.sp(_t333, "bub", null)
	if J.t(J.gp(_s108["n"], "gone")):
		return null
	if J.t(J.gp(_s108["n"], "out")):
		J.mc(_s108["this"], "outTick", [_s108["n"], v_dt_218])
		return null
	var _t334 = J.gp(_s108["this"], "npcs")
	v_near_219 = J.len(J.mc(_t334, "filter", [Callable(self, "_f62").bind(_s108)]))
	if (not J.t(J.gp(J.gp(_s108["n"], "d"), "guard"))):
		var _t339 = _s108["n"]
		var _t340 = J.sub(((3.0 + J.mul(8.0, J.mc(_s108["this"], "rnd", [_s108["n"]]))) if J.leq(J.gp(_s108["n"], "lookCD"), null) else J.gp(_s108["n"], "lookCD")), v_dt_218)
		J.sp(_t339, "lookCD", _t340)
		if J.cmp(J.gp(_s108["n"], "lookUp"), 0.0, ">"):
			var _t341 = _s108["n"]
			var _t342 = J.sub(J.gp(_t341, "lookUp"), v_dt_218)
			J.sp(_t341, "lookUp", _t342)
		else:
			if J.cmp(J.gp(_s108["n"], "lookCD"), 0.0, "<="):
				var _t343 = _s108["n"]
				J.sp(_t343, "lookUp", 2.5)
				var _t344 = _s108["n"]
				var _t345 = (7.0 + J.mul(7.0, J.mc(_s108["this"], "rnd", [_s108["n"]])))
				J.sp(_t344, "lookCD", _t345)
	var _t346 = J.cmp(J.gp(_s108["n"], "fear"), 50.0, ">=")
	if ((not J.t(J.gp(J.gp(_s108["n"], "d"), "guard"))) if _t346 else _t346):
		var _t347 = _s108["n"]
		var _t348 = J.gp(J.G.get("FEAR"), "shaken")
		J.sp(_t347, "shaken", _t348)
	var _t349 = _s108["n"]
	var _t350 = J.gp(_s108["n"], "shaken")
	var _t351 = J.gp(_s108["n"], "shaken")
	var _t352 = J.max_([0.0, J.sub((_t351 if J.t(_t351) else 0.0), v_dt_218)])
	J.sp(_t349, "shaken", _t352)
	if J.cmp(J.gp(_s108["n"], "uneasy"), 0.0, ">"):
		var _t353 = _s108["n"]
		var _t354 = J.sub(J.gp(_t353, "uneasy"), v_dt_218)
		J.sp(_t353, "uneasy", _t354)
	v_cr_220 = J.mul((J.mul(J.gp(J.gp(_s108["n"], "d"), "calm"), J.gp(J.G.get("FEAR"), "decay")) + J.mul(v_near_219, J.gp(J.G.get("FEAR"), "nearCalm"))), (J.gp(J.G.get("FEAR"), "shakenDecay") if J.cmp(J.gp(_s108["n"], "shaken"), 0.0, ">") else 1.0))
	var _t355 = _s108["n"]
	var _t356 = J.max_([(J.min_([J.gp(_s108["n"], "fear"), J.gp(J.G.get("FEAR"), "shakenFloor")]) if J.cmp(J.gp(_s108["n"], "shaken"), 0.0, ">") else 0.0), J.sub(J.gp(_s108["n"], "fear"), J.mul(v_cr_220, v_dt_218))])
	J.sp(_t355, "fear", _t356)
	if J.t(J.gp(_s108["n"], "hab")):
		for _t357 in J.keys(J.gp(_s108["n"], "hab")):
			v_k_227 = _t357
			var _t358 = J.gp(_s108["n"], "hab")
			var _t359 = J.max_([0.0, J.sub(J.gp(J.gp(_s108["n"], "hab"), v_k_227), J.div(v_dt_218, J.gp(J.G.get("FEAR"), "habForget")))])
			J.sp(_t358, v_k_227, _t359)
	var _t360 = J.cmp(J.gp(_s108["n"], "shaken"), 0.0, ">")
	if ((not J.t(J.gp(_s108["n"], "fleeing"))) if _t360 else _t360):
		var _t361 = _s108["n"]
		var _t362 = J.sub((3.0 if J.leq(J.gp(_s108["n"], "glance"), null) else J.gp(_s108["n"], "glance")), v_dt_218)
		J.sp(_t361, "glance", _t362)
		if J.cmp(J.gp(_s108["n"], "glance"), 0.0, "<="):
			var _t363 = _s108["n"]
			var _t364 = (3.5 + (randf() * 3.0))
			J.sp(_t363, "glance", _t364)
			var _t365 = (not J.t(J.gp(_s108["this"], "headless")))
			var _t366 = ((not J.t(J.gp(_s108["n"], "rx"))) if _t365 else _t365)
			if ((not J.seq(J.gp(_s108["n"], "act"), "walk")) if _t366 else _t366):
				J.mc(_s108["this"], "react", [_s108["n"], "chill", {"dur": 2.2}])
				var _t367 = (not J.t(J.gp(_s108["n"], "bub")))
				if ((randf() < 0.45) if _t367 else _t367):
					var _t369 = _s108["n"]
					var _t368 = J.G.get("pick")
					J.mc(_s108["this"], "bubble", [_t369, J.cl(_t368, null, [J.G.get("SHAKEN_SAY")]), 1.8])
	if J.cmp(J.gp(_s108["n"], "fear"), 25.0, ">="):
		var _t370 = _s108["n"]
		var _t371 = J.sub(J.gp(_t370, "look"), v_dt_218)
		J.sp(_t370, "look", _t371)
		if J.cmp(J.gp(_s108["n"], "look"), 0.0, "<="):
			var _t372 = _s108["n"]
			var _t373 = J.mul(J.gp(_t372, "dir"), (-1.0))
			J.sp(_t372, "dir", _t373)
			var _t374 = _s108["n"]
			var _t375 = (0.9 + (randf() * 0.8))
			J.sp(_t374, "look", _t375)
	if J.t(J.gp(_s108["n"], "fleeing")):
		var _t376 = J.gp(J.gp(_s108["this"], "site"), "exit")
		var _t377 = J.gp(_t376, 0.0)
		v_ex_228 = _t377
		var _t378 = J.gp(_t376, 1.0)
		v_ey_229 = _t378
		var _t379 = J.gp(J.gp(_s108["n"], "d"), "fleeVia")
		if J.t(((not J.t(J.gp(_s108["n"], "viaDone"))) if J.t(_t379) else _t379)):
			var _t380 = J.gp(_s108["this"], "npcs")
			v_b_234 = J.mc(_t380, "find", [Callable(self, "_f63").bind(_s108)])
			if J.t(v_b_234):
				v_ex_228 = J.gp(v_b_234, "x")
				v_ey_229 = J.gp(v_b_234, "y")
				if (J.hypot_([J.sub(v_ex_228, J.gp(_s108["n"], "x")), J.sub(v_ey_229, J.gp(_s108["n"], "y"))]) < 0.05):
					var _t382 = _s108["n"]
					J.sp(_t382, "viaDone", true)
			else:
				var _t383 = _s108["n"]
				J.sp(_t383, "viaDone", true)
		v_dx_230 = J.sub(v_ex_228, J.gp(_s108["n"], "x"))
		v_dy_231 = J.sub(v_ey_229, J.gp(_s108["n"], "y"))
		v_d_232 = J.hypot_([v_dx_230, v_dy_231])
		var _t384 = _s108["n"]
		var _t385 = (1.0 if J.cmp(v_dx_230, 0.0, ">=") else (-1.0))
		J.sp(_t384, "dir", _t385)
		if J.cmp(v_d_232, 0.02, "<"):
			var _t386 = J.gp(J.gp(_s108["n"], "d"), "fleeVia")
			if J.t(((not J.t(J.gp(_s108["n"], "viaDone"))) if J.t(_t386) else _t386)):
				var _t387 = _s108["n"]
				J.sp(_t387, "viaDone", true)
				return null
			var _t388 = _s108["n"]
			J.sp(_t388, "gone", true)
			var _t389 = _s108["n"]
			var _t390 = J.gp(_s108["this"], "t")
			J.sp(_t389, "exitT", _t390)
			return null
		v_sp_233 = J.mul(0.28, v_dt_218)
		var _t391 = _s108["n"]
		var _t392 = J.add(J.gp(_t391, "x"), J.mul(J.div(v_dx_230, v_d_232), v_sp_233))
		J.sp(_t391, "x", _t392)
		var _t393 = _s108["n"]
		var _t394 = J.add(J.gp(_t393, "y"), J.mul(J.div(v_dy_231, v_d_232), v_sp_233))
		J.sp(_t393, "y", _t394)
		if (randf() < 0.5):
			J.mc(_s108["this"], "dust", [_s108["n"]])
		return null
	if J.t(J.gp(J.gp(_s108["n"], "d"), "daoshi")):
		J.mc(_s108["this"], "daoTick", [_s108["n"], v_dt_218])
		return null
	var _t395 = J.gp(J.gp(_s108["n"], "d"), "post")
	if J.t((J.gp(J.gp(_s108["this"], "site"), "shift") if J.t(_t395) else _t395)):
		J.mc(_s108["this"], "planMove", [_s108["n"], v_dt_218])
		return null
	if J.cmp(J.gp(_s108["n"], "wait"), 0.0, ">"):
		var _t396 = _s108["n"]
		var _t397 = J.sub(J.gp(_t396, "wait"), J.mul(v_dt_218, (0.4 if J.cmp(J.gp(_s108["n"], "fear"), 50.0, ">=") else 1.0)))
		J.sp(_t396, "wait", _t397)
		var _t398 = _s108["n"]
		var _t399 = J.gp(J.gp(J.gp(J.gp(_s108["n"], "d"), "route"), J.gp(_s108["n"], "wi")), 3.0)
		J.sp(_t398, "act", _t399)
		var _t400 = J.seq(J.gp(_s108["n"], "act"), "brk_nap")
		if (J.cmp(J.gp(_s108["n"], "fear"), 25.0, "<") if _t400 else _t400):
			var _t401 = _s108["n"]
			var _t402 = (1.0 if J.cmp(J.gp(_s108["n"], "x"), J.add(J.gp(J.gp(J.G.get("_SP"), "restTable"), 0.0), 0.01), "<=") else (-1.0))
			J.sp(_t401, "dir", _t402)
		return null
	v_nxt_221 = J.gp(J.gp(J.gp(_s108["n"], "d"), "route"), J.mod(J.add(J.gp(_s108["n"], "wi"), 1.0), J.len(J.gp(J.gp(_s108["n"], "d"), "route"))))
	var _t403 = J.seq(J.gp(v_nxt_221, 3.0), "brk_nap")
	if J.t((J.gp(J.gp(_s108["this"], "site"), "pano") if _t403 else _t403)):
		if (not J.t(J.gp(_s108["n"], "napAt"))):
			var _t404 = _s108["n"]
			var _t405 = J.mc(_s108["this"], "freeSeat", [_s108["n"], v_nxt_221])
			J.sp(_t404, "napAt", _t405)
		var _t406 = [J.gp(J.gp(_s108["n"], "napAt"), 0.0), J.gp(J.gp(_s108["n"], "napAt"), 1.0), J.gp(v_nxt_221, 2.0), J.gp(v_nxt_221, 3.0)]
		v_nxt_221 = _t406
	else:
		var _t407 = _s108["n"]
		J.sp(_t407, "napAt", null)
	v_dx_222 = J.sub(J.gp(v_nxt_221, 0.0), J.gp(_s108["n"], "x"))
	v_dy_223 = J.sub(J.gp(v_nxt_221, 1.0), J.gp(_s108["n"], "y"))
	v_d_224 = J.hypot_([v_dx_222, v_dy_223])
	v_sp_225 = J.mul(J.mul(J.gp(J.gp(_s108["n"], "d"), "speed"), (0.55 if J.cmp(J.gp(_s108["n"], "fear"), 50.0, ">=") else 1.0)), v_dt_218)
	var _t408 = _s108["n"]
	J.sp(_t408, "act", "walk")
	if J.cmp(J.gp(_s108["n"], "fear"), 25.0, "<"):
		var _t409 = _s108["n"]
		var _t410 = (1.0 if J.cmp(v_dx_222, 0.0, ">=") else (-1.0))
		J.sp(_t409, "dir", _t410)
	if J.cmp(v_d_224, v_sp_225, "<="):
		var _t411 = _s108["n"]
		var _t412 = J.gp(v_nxt_221, 0.0)
		J.sp(_t411, "x", _t412)
		var _t413 = _s108["n"]
		var _t414 = J.gp(v_nxt_221, 1.0)
		J.sp(_t413, "y", _t414)
		var _t415 = _s108["n"]
		var _t416 = J.mod(J.add(J.gp(_s108["n"], "wi"), 1.0), J.len(J.gp(J.gp(_s108["n"], "d"), "route")))
		J.sp(_t415, "wi", _t416)
		var _t417 = _s108["n"]
		var _t418 = J.gp(v_nxt_221, 2.0)
		J.sp(_t417, "wait", _t418)
	else:
		var _t419 = _s108["n"]
		var _t420 = J.add(J.gp(_t419, "x"), J.mul(J.div(v_dx_222, v_d_224), v_sp_225))
		J.sp(_t419, "x", _t420)
		var _t421 = _s108["n"]
		var _t422 = J.add(J.gp(_t421, "y"), J.mul(J.div(v_dy_223, v_d_224), v_sp_225))
		J.sp(_t421, "y", _t422)

func _f64(this_, a: Array, env):
	var v_n_238 = null; var v_a_239 = null; var v_t_240 = null
	v_n_238 = J.arg(a, 0)
	var _t423 = J.bor(J.add(J.gp(v_n_238, "_seed"), 1831565813.0), 0.0)
	J.sp(v_n_238, "_seed", _t423)
	v_a_239 = _t423
	v_t_240 = J.math("imul", [J.bxor(v_a_239, J.ushr(v_a_239, 15.0)), J.bor(1.0, v_a_239)])
	var _t424 = J.bxor(J.add(v_t_240, J.math("imul", [J.bxor(v_t_240, J.ushr(v_t_240, 7.0)), J.bor(61.0, v_t_240)])), v_t_240)
	v_t_240 = _t424
	return J.div(J.ushr(J.bxor(v_t_240, J.ushr(v_t_240, 14.0)), 0.0), 4294967296.0)

func _f65(this_, a: Array, env):
	var v_n_243 = null; var v_a_244 = null; var v_b_245 = null
	v_n_243 = J.arg(a, 0)
	v_a_244 = J.arg(a, 1)
	v_b_245 = J.arg(a, 2)
	return J.add(v_a_244, J.mul(J.sub(v_b_245, v_a_244), J.mc(this_, "rng", [v_n_243])))

func _f66(this_, a: Array, env):
	var _t425 = J.gp(J.gp(this_, "site"), "exit")
	return (_t425 if J.t(_t425) else [0.905, 0.535])

func _f68(this_, a: Array, env):
	var v_m_251 = null
	v_m_251 = J.arg(a, 0)
	var _t427 = (not J.seq(v_m_251, env["ex"]))
	var _t428 = ((not J.t(J.gp(J.gp(v_m_251, "d"), "guard"))) if _t427 else _t427)
	var _t429 = ((not J.t(J.gp(J.gp(v_m_251, "d"), "daoshi"))) if _t428 else _t428)
	var _t430 = ((not J.t(J.gp(v_m_251, "gone"))) if _t429 else _t429)
	var _t431 = ((not J.t(J.gp(v_m_251, "out"))) if _t430 else _t430)
	var _t432 = ((not J.t(J.gp(v_m_251, "fleeing"))) if _t431 else _t431)
	return ((not J.t(J.gp(v_m_251, "leaving"))) if _t432 else _t432)

func _f67(this_, a: Array, env):
	var _s135 = {"__p": env, "ex": null}
	_s135["ex"] = J.arg(a, 0)
	var _t426 = J.gp(this_, "npcs")
	return J.len(J.mc(_t426, "filter", [Callable(self, "_f68").bind(_s135)]))

func _f70(this_, a: Array, env):
	return J.mc(env["__p"]["this"], "rng", [env["n"]])

func _f71(this_, a: Array, env):
	var v_a_261 = null; var v_b_262 = null
	v_a_261 = J.arg(a, 0)
	v_b_262 = J.arg(a, 1)
	return J.mc(env["__p"]["this"], "U", [env["n"], v_a_261, v_b_262])

func _f72(this_, a: Array, env):
	var v_a_264 = null; var v_b_265 = null
	v_a_264 = J.arg(a, 0)
	v_b_265 = J.arg(a, 1)
	return J.sub(J.gp(v_a_264, "t"), J.gp(v_b_265, "t"))

func _f69(this_, a: Array, env):
	var v_S0_254 = null; var v_i_255 = null; var v_d_257 = null; var v_L_258 = null; var v_r_259 = null; var v_U_260 = null; var v_t1_263 = null; var v_e_266 = null
	var _s137 = {"__p": env, "this": null}
	_s137["this"] = this_
	v_S0_254 = J.gp(_s137["this"], "seed")
	for _t433 in J.iter(J.mc(J.gp(_s137["this"], "npcs"), "entries", [])):
		var _s138 = {"__p": _s137, "n": null}
		var _t434 = J.gp(_t433, 0.0)
		v_i_255 = _t434
		var _t435 = J.gp(_t433, 1.0)
		_s138["n"] = _t435
		var _t436 = _s138["n"]
		var _t437 = J.bor((J.mul(v_S0_254, 7919.0) + J.mul(v_i_255, 104729.0)), 0.0)
		J.sp(_t436, "_seed", _t437)
		var _t438 = _s138["n"]
		var _t439 = []
		J.sp(_t438, "ev", _t439)
		v_d_257 = J.gp(_s138["n"], "d")
		var _t440 = J.gp(v_d_257, "lines")
		v_L_258 = (_t440 if J.t(_t440) else {})
		v_r_259 = Callable(self, "_f70").bind(_s138)
		v_U_260 = Callable(self, "_f71").bind(_s138)
		if J.t(J.gp(v_d_257, "post")):
			var _t441 = _s138["n"]
			var _t442 = J.gp(J.gp(v_d_257, "post"), 0.0)
			J.sp(_t441, "x", _t442)
			var _t443 = _s138["n"]
			var _t444 = J.gp(J.gp(v_d_257, "post"), 1.0)
			J.sp(_t443, "y", _t444)
			var _t445 = _s138["n"]
			var _t446 = J.gp(J.gp(v_d_257, "post"), 2.0)
			J.sp(_t445, "act", _t446)
			var _t447 = _s138["n"]
			J.sp(_t447, "wait", 0.0)
			var _t448 = _s138["n"]
			var _t449 = {"x": J.gp(_s138["n"], "x"), "y": J.gp(_s138["n"], "y"), "wait": J.cl(v_U_260, null, [6.0, (J.gp(J.gp(v_d_257, "work"), 1.0) if J.t(J.gp(v_d_257, "work")) else 6.0)]), "act": J.gp(J.gp(v_d_257, "post"), 2.0), "arrived": true}
			J.sp(_t448, "step", _t449)
			var _t450 = _s138["n"]
			var _t451 = J.gp(J.gp(_s138["n"], "step"), "wait")
			J.sp(_t450, "wait", _t451)
			var _t452 = _s138["n"]
			J.sp(_t452, "li", 0.0)
		if J.seq(J.gp(v_d_257, "k"), "boss"):
			var _t453 = J.gp(_s138["n"], "ev")
			J.mc(_t453, "push", [{"t": J.cl(v_U_260, null, [18.0, 40.0]), "k": "in", "say": J.gp(v_L_258, "late")}])
			var _t454 = J.gp(_s138["n"], "ev")
			J.mc(_t454, "push", [{"t": J.cl(v_U_260, null, [42.0, 56.0]), "k": "callin"}])
			var _t455 = J.gp(_s138["n"], "ev")
			J.mc(_t455, "push", [{"t": J.cl(v_U_260, null, [70.0, 84.0]), "k": "meeting"}])
			if J.cmp(J.cl(v_r_259, null, []), 0.6, "<"):
				var _t456 = J.gp(_s138["n"], "ev")
				J.mc(_t456, "push", [{"t": J.cl(v_U_260, null, [122.0, 136.0]), "k": "callin"}])
			if J.cmp(J.cl(v_r_259, null, []), 0.5, "<"):
				var _t457 = J.gp(_s138["n"], "ev")
				J.mc(_t457, "push", [{"t": J.cl(v_U_260, null, [150.0, 165.0]), "k": "leave"}])
		if J.seq(J.gp(v_d_257, "k"), "it"):
			v_t1_263 = J.cl(v_U_260, null, [100.0, 145.0])
			if J.cmp(J.cl(v_r_259, null, []), 0.45, "<"):
				var _t458 = J.gp(_s138["n"], "ev")
				J.mc(_t458, "push", [{"t": v_t1_263, "k": "leave", "back": J.cl(v_U_260, null, [12.0, 20.0])}])
			else:
				var _t459 = J.gp(_s138["n"], "ev")
				J.mc(_t459, "push", [{"t": J.add(v_t1_263, 15.0), "k": "leave"}])
		if J.seq(J.gp(v_d_257, "k"), "mis"):
			if J.cmp(J.cl(v_r_259, null, []), 0.35, "<"):
				var _t460 = J.gp(_s138["n"], "ev")
				J.mc(_t460, "push", [{"t": J.cl(v_U_260, null, [25.0, 60.0]), "k": "in", "say": J.gp(v_L_258, "late")}])
			if J.cmp(J.cl(v_r_259, null, []), 0.6, "<"):
				var _t461 = J.gp(_s138["n"], "ev")
				J.mc(_t461, "push", [{"t": J.cl(v_U_260, null, [120.0, 160.0]), "k": "leave"}])
		if J.seq(J.gp(v_d_257, "k"), "auntie"):
			if J.cmp(J.cl(v_r_259, null, []), 0.5, "<"):
				var _t462 = J.gp(_s138["n"], "ev")
				J.mc(_t462, "push", [{"t": J.cl(v_U_260, null, [20.0, 50.0]), "k": "in", "say": J.gp(v_L_258, "late")}])
			if J.cmp(J.cl(v_r_259, null, []), 0.5, "<"):
				var _t463 = J.gp(_s138["n"], "ev")
				J.mc(_t463, "push", [{"t": J.cl(v_U_260, null, [135.0, 168.0]), "k": "leave"}])
		var _t464 = J.gp(_s138["n"], "ev")
		J.mc(_t464, "sort", [Callable(self, "_f72").bind(_s138)])
		var _t465 = J.gp(J.gp(_s138["n"], "ev"), 0.0)
		if J.t((J.seq(J.gp(J.gp(J.gp(_s138["n"], "ev"), 0.0), "k"), "in") if J.t(_t465) else _t465)):
			v_e_266 = J.mc(J.gp(_s138["n"], "ev"), "shift", [])
			J.mc(_s138["__p"]["this"], "goOut", [_s138["n"], J.gp(v_e_266, "t"), false, J.gp(v_e_266, "say"), true])

func _f73(this_, a: Array, env):
	var v_n_269 = null; var v_dur_270 = null; var v_leave_271 = null; var v_backSay_272 = null; var v_silent_273 = null; var v_ex_274 = null; var v_ey_275 = null
	v_n_269 = J.arg(a, 0)
	v_dur_270 = J.arg(a, 1)
	v_leave_271 = J.arg(a, 2)
	v_backSay_272 = J.arg(a, 3)
	v_silent_273 = J.arg(a, 4)
	var _t466 = J.mc(this_, "exitPt", [])
	var _t467 = J.gp(_t466, 0.0)
	v_ex_274 = _t467
	var _t468 = J.gp(_t466, 1.0)
	v_ey_275 = _t468
	J.sp(v_n_269, "out", true)
	J.sp(v_n_269, "leaving", false)
	var _t469 = (not (not J.t(v_leave_271)))
	J.sp(v_n_269, "left", _t469)
	J.sp(v_n_269, "outT", v_dur_270)
	var _t470 = ((-9.0) if J.t(v_silent_273) else J.gp(this_, "t"))
	J.sp(v_n_269, "outAt", _t470)
	var _t471 = (v_backSay_272 if J.t(v_backSay_272) else null)
	J.sp(v_n_269, "inSay", _t471)
	J.sp(v_n_269, "x", v_ex_274)
	J.sp(v_n_269, "y", v_ey_275)
	J.sp(v_n_269, "step", null)
	J.sp(v_n_269, "act", "idle")
	if (not J.t(v_silent_273)):
		J.mc(this_, "elevator", [])
	var _t472 = J.mc(this_, "office", [])
	if J.t((J.seq(J.gp(J.gp(v_n_269, "d"), "k"), "it") if J.t(_t472) else _t472)):
		J.mc(J.G.get("OFFICE"), "offline", ["it", (not (not J.t(v_leave_271)))])

func _f75(this_, a: Array, env):
	var v_m_282 = null
	v_m_282 = J.arg(a, 0)
	var _t480 = (not J.seq(v_m_282, env["n"]))
	var _t481 = ((not J.t(J.gp(v_m_282, "gone"))) if _t480 else _t480)
	var _t482 = ((not J.t(J.gp(v_m_282, "out"))) if _t481 else _t481)
	var _t483 = (J.seq(J.gp(v_m_282, "act"), "walk") if _t482 else _t482)
	return (J.seq(J.mc(env["this"], "roomOf", [v_m_282]), "main") if _t483 else _t483)

func _f74(this_, a: Array, env):
	var v_dt_279 = null; var v_ex_280 = null; var v_ey_281 = null
	var _s151 = {"__p": env, "this": null, "n": null}
	_s151["this"] = this_
	_s151["n"] = J.arg(a, 0)
	v_dt_279 = J.arg(a, 1)
	if J.t(J.gp(_s151["n"], "left")):
		return null
	var _t473 = _s151["n"]
	var _t474 = J.sub(J.gp(_t473, "outT"), v_dt_279)
	J.sp(_t473, "outT", _t474)
	if J.cmp(J.gp(_s151["n"], "outT"), 0.0, ">"):
		return null
	var _t478 = J.gp(J.gp(_s151["this"], "site"), "pano")
	if J.t(_t478):
		var _t475 = _s151["n"]
		var _t476 = J.gp(_s151["n"], "inWait")
		var _t477 = J.add((_t476 if J.t(_t476) else 0.0), v_dt_279)
		J.sp(_t475, "inWait", _t477)
		_t478 = J.cmp(_t477, 8.0, "<")
	var _t484 = _t478
	if J.t(_t484):
		var _t479 = J.gp(_s151["this"], "npcs")
		_t484 = (J.len(J.mc(_t479, "filter", [Callable(self, "_f75").bind(_s151)])) >= 2.0)
	if J.t(_t484):
		return null
	var _t485 = _s151["n"]
	J.sp(_t485, "inWait", 0.0)
	var _t486 = _s151["n"]
	J.sp(_t486, "out", false)
	var _t487 = _s151["n"]
	var _t488 = J.gp(_s151["this"], "t")
	J.sp(_t487, "inAt", _t488)
	J.mc(_s151["this"], "elevator", [])
	var _t489 = J.mc(_s151["this"], "office", [])
	if J.t((J.seq(J.gp(J.gp(_s151["n"], "d"), "k"), "it") if J.t(_t489) else _t489)):
		J.mc(J.G.get("OFFICE"), "offline", ["it", false])
	var _t490 = J.mc(_s151["this"], "exitPt", [])
	var _t491 = J.gp(_t490, 0.0)
	v_ex_280 = _t491
	var _t492 = J.gp(_t490, 1.0)
	v_ey_281 = _t492
	var _t493 = _s151["n"]
	J.sp(_t493, "x", v_ex_280)
	var _t494 = _s151["n"]
	J.sp(_t494, "y", v_ey_281)
	var _t495 = _s151["n"]
	var _t496 = (-1.0)
	J.sp(_t495, "dir", _t496)
	if J.t(J.gp(_s151["n"], "inSay")):
		J.mc(_s151["this"], "bubble", [_s151["n"], J.gp(_s151["n"], "inSay"), 2.6])
	var _t497 = _s151["n"]
	J.sp(_t497, "inSay", null)
	var _t498 = _s151["n"]
	J.sp(_t498, "step", null)
	var _t499 = _s151["n"]
	J.sp(_t499, "next", null)

func _f76(this_, a: Array, env):
	var _t500 = this_
	J.sp(_t500, "door", 1.8)
	J.mc(this_, "jumpy", [null, "lobby"])
	if (not J.t(J.gp(this_, "headless"))):
		if (not J.seq(J.typeof_(J.G.get("Sound")), "undefined")):
			J.mc(J.G.get("Sound"), "play", ["coin"])
		if J.t(J.mc(this_, "office", [])):
			J.mc(J.G.get("OFFICE"), "elevator", [])

func _f78(this_, a: Array, env):
	var v_m_301 = null
	v_m_301 = J.arg(a, 0)
	var _t577 = J.gp(v_m_301, "bub")
	return (J.cmp(J.gp(v_m_301, "bubT"), 0.0, ">") if J.t(_t577) else _t577)

func _f77(this_, a: Array, env):
	var v_n_287 = null; var v_dt_288 = null; var v_d_289 = null; var v_s_290 = null; var v_atPost_291 = null; var v_e_292 = null; var v_c_293 = null; var v_cb_294 = null; var v_tgt_295 = null; var v_dx_296 = null; var v_dy_297 = null; var v_dd_298 = null; var v_sp_299 = null; var v_b_300 = null; var v_i_302 = null; var v_m_303 = null
	v_n_287 = J.arg(a, 0)
	v_dt_288 = J.arg(a, 1)
	v_d_289 = J.gp(v_n_287, "d")
	while true:
		var _t501 = J.len(J.gp(v_n_287, "ev"))
		if not J.t((J.cmp(J.gp(this_, "t"), J.gp(J.gp(J.gp(v_n_287, "ev"), 0.0), "t"), ">=") if J.t(_t501) else _t501)): break
		v_e_292 = J.gp(J.gp(v_n_287, "ev"), 0.0)
		if J.seq(J.gp(v_e_292, "k"), "leave"):
			if J.cmp(J.mc(this_, "present", [v_n_287]), 2.0, "<"):
				var _t502 = J.add(J.gp(v_e_292, "t"), 3.0)
				J.sp(v_e_292, "t", _t502)
				break
			J.mc(J.gp(v_n_287, "ev"), "shift", [])
			J.sp(v_n_287, "leaving", true)
			var _t503 = {"x": J.gp(v_n_287, "x"), "y": J.gp(v_n_287, "y"), "wait": 3.5, "act": "pack", "arrived": true, "cue": true}
			J.sp(v_n_287, "step", _t503)
			J.sp(v_n_287, "wait", 3.5)
			var _t504 = J.gp(v_d_289, "lines")
			J.mc(this_, "bubble", [v_n_287, (J.gp(J.gp(v_d_289, "lines"), "cue") if J.t(_t504) else _t504), 3.0])
			var _t506 = (not J.t(J.gp(v_e_292, "back")))
			var _t505 = J.gp(v_e_292, "back")
			var _t508 = (_t505 if J.t(_t505) else 0.0)
			var _t507 = J.gp(v_d_289, "lines")
			var _t510 = (J.gp(J.gp(v_d_289, "lines"), "back") if J.t(_t507) else _t507)
			var _t509 = J.gp(v_d_289, "lines")
			var _t511 = {"out": true, "leave": _t506, "outDur": _t508, "backSay": _t510, "sayStart": (J.gp(J.gp(v_d_289, "lines"), "bye") if J.t(_t509) else _t509)}
			J.sp(v_n_287, "next", _t511)
			continue
		if J.seq(J.gp(v_e_292, "k"), "in"):
			J.mc(J.gp(v_n_287, "ev"), "shift", [])
			continue
		var _t512 = J.seq(J.gp(v_e_292, "k"), "callin")
		if (_t512 if _t512 else J.seq(J.gp(v_e_292, "k"), "meeting")):
			var _t513 = J.gp(v_n_287, "leaving")
			var _t514 = (_t513 if J.t(_t513) else J.gp(v_n_287, "fleeing"))
			var _t515 = (_t514 if J.t(_t514) else J.cmp(J.gp(v_n_287, "fear"), 50.0, ">="))
			if J.t((_t515 if J.t(_t515) else (not J.t(J.mc(this_, "bossCall", [v_n_287, J.gp(v_e_292, "k")]))))):
				var _t516 = J.add(J.gp(v_e_292, "t"), 5.0)
				J.sp(v_e_292, "t", _t516)
				break
			J.mc(J.gp(v_n_287, "ev"), "shift", [])
			continue
	var _t517 = J.gp(v_n_287, "call")
	if J.t(((not J.t(J.gp(v_n_287, "leaving"))) if J.t(_t517) else _t517)):
		v_c_293 = J.gp(v_n_287, "call")
		v_cb_294 = J.gp(v_c_293, "boss")
		var _t520 = v_cb_294
		if J.t(_t520):
			var _t518 = J.gp(v_cb_294, "gone")
			var _t519 = (_t518 if J.t(_t518) else J.gp(v_cb_294, "out"))
			_t520 = (_t519 if J.t(_t519) else J.gp(v_cb_294, "fleeing"))
		if J.t(_t520):
			J.sp(v_n_287, "call", null)
		else:
			var _t523 = ((not J.seq(J.mc(this_, "roomOf", [v_cb_294]), "boss")) if J.t(v_cb_294) else v_cb_294)
			if J.t(_t523):
				var _t521 = J.gp(v_c_293, "hold")
				var _t522 = J.add((_t521 if J.t(_t521) else 0.0), v_dt_288)
				J.sp(v_c_293, "hold", _t522)
				_t523 = J.cmp(_t522, 25.0, "<")
			if J.t(_t523):
				pass
			else:
				if J.cmp(J.gp(v_c_293, "delay"), 0.0, ">"):
					var _t524 = J.sub(J.gp(v_c_293, "delay"), v_dt_288)
					J.sp(v_c_293, "delay", _t524)
				else:
					J.sp(v_n_287, "call", null)
					J.sp(v_n_287, "next", null)
					var _t526 = J.gp(v_c_293, "x")
					var _t527 = J.gp(v_c_293, "y")
					var _t528 = J.gp(v_c_293, "wait")
					var _t529 = J.gp(v_c_293, "act")
					var _t530 = J.gp(v_c_293, "say")
					var _t525 = J.gp(v_c_293, "boss")
					var _t531 = {"x": _t526, "y": _t527, "wait": _t528, "act": _t529, "arrived": false, "path": null, "pi": 0.0, "say": _t530, "called": true, "boss": (_t525 if J.t(_t525) else null)}
					J.sp(v_n_287, "step", _t531)
					if J.t(J.gp(v_c_293, "go")):
						J.mc(this_, "bubble", [v_n_287, J.gp(v_c_293, "go"), 2.2])
	if (not J.t(J.gp(v_n_287, "step"))):
		var _t532 = (J.mc(this_, "mkStep", [v_n_287, J.gp(v_n_287, "next")]) if J.t(J.gp(v_n_287, "next")) else J.mc(this_, "planNext", [v_n_287]))
		J.sp(v_n_287, "step", _t532)
		J.sp(v_n_287, "next", null)
		if J.t(J.gp(J.gp(v_n_287, "step"), "arrived")):
			var _t533 = J.gp(J.gp(v_n_287, "step"), "wait")
			J.sp(v_n_287, "wait", _t533)
	v_s_290 = J.gp(v_n_287, "step")
	var _t534 = (not J.t(J.gp(v_s_290, "arrived")))
	if ((not J.t(J.gp(v_s_290, "go"))) if _t534 else _t534):
		var _t535 = J.gp(v_s_290, "hold")
		var _t536 = J.add((_t535 if J.t(_t535) else 0.0), v_dt_288)
		J.sp(v_s_290, "hold", _t536)
		var _t537 = (not J.seq(J.gp(v_n_287, "act"), "walk"))
		var _t539 = ((not J.t(J.mc(this_, "inDoor", [J.gp(v_n_287, "x")]))) if _t537 else _t537)
		if J.t(_t539):
			var _t538 = J.gp(v_s_290, "called")
			_t539 = (not J.t((J.seq(J.gp(J.gp(v_n_287, "d"), "k"), "boss") if J.t(_t538) else _t538)))
		var _t540 = (J.mc(this_, "walkBlocked", [v_n_287, J.gp(v_s_290, "x")]) if _t539 else _t539)
		var _t541 = (J.cmp(J.gp(v_s_290, "hold"), 6.0, "<") if J.t(_t540) else _t540)
		if J.t(((not J.t(J.gp(v_n_287, "fleeing"))) if J.t(_t541) else _t541)):
			J.sp(v_n_287, "act", "idle")
			return null
		J.sp(v_s_290, "go", true)
	if (not J.t(J.gp(v_s_290, "arrived"))):
		var _t542 = J.gp(v_s_290, "path")
		v_tgt_295 = (J.gp(J.gp(v_s_290, "path"), J.gp(v_s_290, "pi")) if J.t((J.cmp(J.gp(v_s_290, "pi"), J.len(J.gp(v_s_290, "path")), "<") if J.t(_t542) else _t542)) else [J.gp(v_s_290, "x"), J.gp(v_s_290, "y")])
		v_dx_296 = J.sub(J.gp(v_tgt_295, 0.0), J.gp(v_n_287, "x"))
		v_dy_297 = J.sub(J.gp(v_tgt_295, 1.0), J.gp(v_n_287, "y"))
		v_dd_298 = J.hypot_([v_dx_296, v_dy_297])
		v_sp_299 = J.mul(J.mul(J.gp(v_d_289, "speed"), (0.55 if J.cmp(J.gp(v_n_287, "fear"), 50.0, ">=") else 1.0)), v_dt_288)
		var _t543 = ("mop" if J.t(J.gp(v_s_290, "mopWalk")) else "walk")
		J.sp(v_n_287, "act", _t543)
		if J.t(J.gp(v_s_290, "mopWalk")):
			J.sp(v_n_287, "act", "walk")
		if J.cmp(J.gp(v_n_287, "fear"), 25.0, "<"):
			var _t544 = (1.0 if J.cmp(v_dx_296, 0.0, ">=") else (-1.0))
			J.sp(v_n_287, "dir", _t544)
		if J.cmp(v_dd_298, v_sp_299, "<="):
			var _t545 = J.gp(v_tgt_295, 0.0)
			J.sp(v_n_287, "x", _t545)
			var _t546 = J.gp(v_tgt_295, 1.0)
			J.sp(v_n_287, "y", _t546)
			var _t547 = J.gp(v_s_290, "path")
			if J.t((J.cmp(J.gp(v_s_290, "pi"), J.len(J.gp(v_s_290, "path")), "<") if J.t(_t547) else _t547)):
				J.sp(v_s_290, "pi", J.num(J.gp(v_s_290, "pi")) + 1.0)
				return null
			J.sp(v_s_290, "arrived", true)
			var _t548 = J.gp(v_s_290, "wait")
			J.sp(v_n_287, "wait", _t548)
			if J.t(J.gp(v_s_290, "say")):
				J.mc(this_, "bubble", [v_n_287, J.gp(v_s_290, "say"), 2.4])
			if J.t(J.gp(v_s_290, "out")):
				J.mc(this_, "goOut", [v_n_287, J.gp(v_s_290, "outDur"), J.gp(v_s_290, "leave"), J.gp(v_s_290, "backSay")])
				return null
		else:
			var _t549 = J.add(J.gp(v_n_287, "x"), J.mul(J.div(v_dx_296, v_dd_298), v_sp_299))
			J.sp(v_n_287, "x", _t549)
			var _t550 = J.add(J.gp(v_n_287, "y"), J.mul(J.div(v_dy_297, v_dd_298), v_sp_299))
			J.sp(v_n_287, "y", _t550)
		return null
	var _t551 = J.gp(v_s_290, "act")
	J.sp(v_n_287, "act", _t551)
	var _t552 = J.sub(J.gp(v_n_287, "wait"), J.mul(v_dt_288, (0.4 if J.cmp(J.gp(v_n_287, "fear"), 50.0, ">=") else 1.0)))
	J.sp(v_n_287, "wait", _t552)
	var _t553 = J.gp(v_s_290, "called")
	var _t554 = (J.gp(v_s_290, "boss") if J.t(_t553) else _t553)
	if J.t((J.cmp(J.gp(v_n_287, "fear"), 50.0, "<") if J.t(_t554) else _t554)):
		v_b_300 = J.gp(v_s_290, "boss")
		var _t555 = J.gp(v_b_300, "gone")
		var _t556 = (_t555 if J.t(_t555) else J.gp(v_b_300, "out"))
		var _t557 = (_t556 if J.t(_t556) else J.gp(v_b_300, "fleeing"))
		if J.t((_t557 if J.t(_t557) else (not J.seq(J.mc(this_, "roomOf", [v_b_300]), "boss")))):
			var _t558 = J.gp(v_s_290, "empty")
			var _t559 = J.add((_t558 if J.t(_t558) else 0.0), v_dt_288)
			J.sp(v_s_290, "empty", _t559)
			var _t560 = J.add(J.gp(v_n_287, "wait"), v_dt_288)
			J.sp(v_n_287, "wait", _t560)
			if J.cmp(J.gp(v_s_290, "empty"), 6.0, ">"):
				var _t561 = J.gp(J.G.get("EMPTY_SAY"), J.gp(J.gp(v_n_287, "d"), "k"))
				J.mc(this_, "bubble", [v_n_287, (_t561 if J.t(_t561) else J.gp(J.G.get("EMPTY_SAY"), "it")), 2.6])
				J.sp(v_n_287, "step", null)
				return null
		else:
			J.sp(v_s_290, "empty", 0.0)
	var _t562 = J.gp(v_d_289, "post")
	v_atPost_291 = ((J.hypot_([J.sub(J.gp(v_n_287, "x"), J.gp(J.gp(v_d_289, "post"), 0.0)), J.sub(J.gp(v_n_287, "y"), J.gp(J.gp(v_d_289, "post"), 1.0))]) < 0.012) if J.t(_t562) else _t562)
	var _t563 = (J.gp(J.gp(v_d_289, "post"), 3.0) if J.t(v_atPost_291) else v_atPost_291)
	if J.t((J.cmp(J.gp(v_n_287, "fear"), 25.0, "<") if J.t(_t563) else _t563)):
		var _t564 = J.gp(J.gp(v_d_289, "post"), 3.0)
		J.sp(v_n_287, "dir", _t564)
	var _t565 = J.seq(J.gp(v_n_287, "act"), "present")
	if (J.cmp(J.gp(v_n_287, "fear"), 25.0, "<") if _t565 else _t565):
		J.sp(v_n_287, "dir", 1.0)
	var _t566 = J.gp(v_s_290, "sit")
	var _t567 = (J.seq(J.gp(v_s_290, "act"), "brk_nap") if J.t(_t566) else _t566)
	if J.t((J.cmp(J.gp(v_n_287, "fear"), 25.0, "<") if J.t(_t567) else _t567)):
		var _t568 = (1.0 if J.cmp(J.gp(v_n_287, "x"), J.add(J.gp(J.gp(J.G.get("_SP"), "restTable"), 0.0), 0.01), "<=") else (-1.0))
		J.sp(v_n_287, "dir", _t568)
	var _t569 = J.gp(J.gp(v_n_287, "d"), "guard")
	var _t570 = (J.seq(J.gp(v_n_287, "act"), "doze") if J.t(_t569) else _t569)
	if J.t((J.cmp(J.gp(v_n_287, "fear"), 0.0, ">") if J.t(_t570) else _t570)):
		J.sp(v_n_287, "act", "look")
	var _t571 = (J.gp(v_d_289, "lines") if J.t(v_atPost_291) else v_atPost_291)
	var _t572 = (J.gp(J.gp(v_d_289, "lines"), "work") if J.t(_t571) else _t571)
	var _t573 = (J.cmp(J.gp(v_n_287, "fear"), 25.0, "<") if J.t(_t572) else _t572)
	if J.t(((not J.t(J.gp(v_s_290, "cue"))) if J.t(_t573) else _t573)):
		var _t574 = J.sub(((4.0 + J.mul(J.mc(this_, "rng", [v_n_287]), 6.0)) if J.leq(J.gp(v_n_287, "wl"), null) else J.gp(v_n_287, "wl")), v_dt_288)
		J.sp(v_n_287, "wl", _t574)
		if J.cmp(J.gp(v_n_287, "wl"), 0.0, "<="):
			var _t575 = (9.0 + J.mul(J.mc(this_, "rng", [v_n_287]), 8.0))
			J.sp(v_n_287, "wl", _t575)
			var _t579 = (not J.t(J.gp(v_n_287, "bub")))
			if J.t(_t579):
				var _t578 = J.gp(this_, "headless")
				if not J.t(_t578):
					var _t576 = J.gp(this_, "npcs")
					_t578 = (not J.t(J.mc(_t576, "some", [Callable(self, "_f78").bind(env)])))
				_t579 = _t578
			if J.t(_t579):
				J.mc(this_, "bubble", [v_n_287, J.gp(J.gp(J.gp(v_d_289, "lines"), "work"), floor(J.num(J.mul(J.mc(this_, "rng", [v_n_287]), J.len(J.gp(J.gp(v_d_289, "lines"), "work")))))), 2.4])
	if J.cmp(J.gp(v_n_287, "wait"), 0.0, "<="):
		if J.t(J.gp(v_s_290, "meet")):
			v_i_302 = 0.0
			for _t580 in J.iter(J.gp(this_, "npcs")):
				v_m_303 = _t580
				var _t581 = J.gp(v_m_303, "step")
				var _t582 = (J.seq(J.gp(J.gp(v_m_303, "step"), "act"), "notes") if J.t(_t581) else _t581)
				if J.t((J.gp(J.gp(v_m_303, "step"), "arrived") if J.t(_t582) else _t582)):
					var _t584 = J.gp(v_m_303, "wait")
					var _t583 = J.num(v_i_302)
					v_i_302 = _t583 + 1.0
					var _t586 = J.gp(v_m_303, "wait")
					var _t585 = J.num(v_i_302)
					v_i_302 = _t585 + 1.0
					var _t587 = J.min_([_t586, (1.5 + (3.0 * _t585))])
					J.sp(v_m_303, "wait", _t587)
				else:
					var _t588 = J.gp(v_m_303, "call")
					if J.t((J.seq(J.gp(J.gp(v_m_303, "call"), "act"), "notes") if J.t(_t588) else _t588)):
						J.sp(v_m_303, "call", null)
			J.mc(this_, "bubble", [v_n_287, "散會！聽朝九點前交。", 2.4])
		J.sp(v_n_287, "step", null)

func _f80(this_, a: Array, env):
	var v_a_312 = null; var v_p_313 = null
	v_a_312 = J.arg(a, 0)
	v_p_313 = J.arg(a, 1)
	return ((J.hypot_([J.sub(J.gp(v_a_312, 0.0), J.gp(v_p_313, 0.0)), J.sub(J.gp(v_a_312, 1.0), J.gp(v_p_313, 1.0))]) < 0.02) if J.t(v_a_312) else v_a_312)

func _f82(this_, a: Array, env):
	var v_m_315 = null
	v_m_315 = J.arg(a, 0)
	var _t590 = (not J.seq(v_m_315, env["__p"]["n"]))
	var _t591 = ((not J.t(J.gp(v_m_315, "gone"))) if _t590 else _t590)
	var _t598 = ((not J.t(J.gp(v_m_315, "out"))) if _t591 else _t591)
	if J.t(_t598):
		var _t592 = env["__p"]["near"]
		var _t595 = J.cl(_t592, null, [[J.gp(v_m_315, "x"), J.gp(v_m_315, "y")], env["p"]])
		if not J.t(_t595):
			var _t594 = J.gp(v_m_315, "step")
			if J.t(_t594):
				var _t593 = env["__p"]["near"]
				_t594 = J.cl(_t593, null, [[J.gp(J.gp(v_m_315, "step"), "x"), J.gp(J.gp(v_m_315, "step"), "y")], env["p"]])
			_t595 = _t594
		var _t597 = _t595
		if not J.t(_t597):
			var _t596 = env["__p"]["near"]
			_t597 = J.cl(_t596, null, [J.gp(v_m_315, "napAt"), env["p"]])
		_t598 = _t597
	return _t598

func _f81(this_, a: Array, env):
	var _s186 = {"__p": env, "p": null}
	_s186["p"] = J.arg(a, 0)
	var _t589 = J.gp(_s186["__p"]["this"], "npcs")
	return J.mc(_t589, "some", [Callable(self, "_f82").bind(_s186)])

func _f83(this_, a: Array, env):
	var v_p_316 = null
	v_p_316 = J.arg(a, 0)
	var _t600 = env["busy"]
	return (not J.t(J.cl(_t600, null, [v_p_316])))

func _f79(this_, a: Array, env):
	var v_pref_307 = null; var v_S_308 = null; var v_f_311 = null
	var _s184 = {"__p": env, "this": null, "n": null, "near": null, "busy": null}
	_s184["this"] = this_
	_s184["n"] = J.arg(a, 0)
	v_pref_307 = J.arg(a, 1)
	v_S_308 = J.gp(J.G.get("_SP"), "restSeats")
	_s184["near"] = Callable(self, "_f80").bind(_s184)
	_s184["busy"] = Callable(self, "_f81").bind(_s184)
	var _t599 = _s184["busy"]
	if (not J.t(J.cl(_t599, null, [v_pref_307]))):
		return [J.gp(v_pref_307, 0.0), J.gp(v_pref_307, 1.0)]
	v_f_311 = J.mc(v_S_308, "find", [Callable(self, "_f83").bind(_s184)])
	return ([J.gp(v_f_311, 0.0), J.gp(v_f_311, 1.0)] if J.t(v_f_311) else [J.gp(v_pref_307, 0.0), J.gp(v_pref_307, 1.0)])

func _f86(this_, a: Array, env):
	var v_m_332 = null
	v_m_332 = J.arg(a, 0)
	var _t602 = (not J.seq(v_m_332, env["__p"]["n"]))
	var _t603 = ((not J.t(J.gp(v_m_332, "gone"))) if _t602 else _t602)
	var _t608 = ((not J.t(J.gp(v_m_332, "out"))) if _t603 else _t603)
	if J.t(_t608):
		var _t604 = J.gp(v_m_332, "step")
		var _t605 = ((J.hypot_([J.sub(J.gp(J.gp(v_m_332, "step"), "x"), J.gp(env["p"], 0.0)), J.sub(J.gp(J.gp(v_m_332, "step"), "y"), J.gp(env["p"], 1.0))]) < 0.01) if J.t(_t604) else _t604)
		var _t607 = (_t605 if J.t(_t605) else (J.hypot_([J.sub(J.gp(v_m_332, "x"), J.gp(env["p"], 0.0)), J.sub(J.gp(v_m_332, "y"), J.gp(env["p"], 1.0))]) < 0.01))
		if not J.t(_t607):
			var _t606 = J.gp(v_m_332, "napAt")
			_t607 = ((J.hypot_([J.sub(J.gp(J.gp(v_m_332, "napAt"), 0.0), J.gp(env["p"], 0.0)), J.sub(J.gp(J.gp(v_m_332, "napAt"), 1.0), J.gp(env["p"], 1.0))]) < 0.01) if J.t(_t606) else _t606)
		_t608 = _t607
	return _t608

func _f85(this_, a: Array, env):
	var _s190 = {"__p": env, "p": null}
	_s190["p"] = J.arg(a, 0)
	var _t601 = J.gp(_s190["__p"]["this"], "npcs")
	return J.mc(_t601, "some", [Callable(self, "_f86").bind(_s190)])

func _f87(this_, a: Array, env):
	var v_p_333 = null
	v_p_333 = J.arg(a, 0)
	var _t609 = env["busy"]
	return (not J.t(J.cl(_t609, null, [v_p_333])))

func _f84(this_, a: Array, env):
	var v_wait_320 = null; var v_say_321 = null; var v_acts_322 = null; var v_S_323 = null; var v_free_325 = null; var v_px_326 = null; var v_py_327 = null; var v_pact_328 = null; var v_p_329 = null; var v_a_330 = null
	var _s189 = {"__p": env, "this": null, "n": null, "busy": null}
	_s189["this"] = this_
	_s189["n"] = J.arg(a, 0)
	v_wait_320 = J.arg(a, 1)
	v_say_321 = J.arg(a, 2)
	v_acts_322 = J.arg(a, 3)
	v_S_323 = J.gp(J.G.get("_SP"), "restSeats")
	_s189["busy"] = Callable(self, "_f85").bind(_s189)
	v_free_325 = J.mc(v_S_323, "filter", [Callable(self, "_f87").bind(_s189)])
	var _t610 = J.gp(J.gp(_s189["n"], "d"), "post")
	var _t611 = J.gp(_t610, 0.0)
	v_px_326 = _t611
	var _t612 = J.gp(_t610, 1.0)
	v_py_327 = _t612
	var _t613 = J.gp(_t610, 2.0)
	v_pact_328 = _t613
	var _t614 = (not J.t(J.len(v_free_325)))
	if J.t((_t614 if _t614 else J.mc(_s189["this"], "busy", [_s189["n"], J.gp(J.gp(v_free_325, 0.0), 0.0)]))):
		return {"x": v_px_326, "y": v_py_327, "wait": J.mc(_s189["this"], "U", [_s189["n"], 4.0, 8.0]), "act": v_pact_328, "arrived": true}
	v_p_329 = J.gp(v_free_325, floor(J.num(J.mul(J.mc(_s189["this"], "rng", [_s189["n"]]), J.len(v_free_325)))))
	v_a_330 = (v_acts_322 if J.t(v_acts_322) else ["brk_phone", "brk_drink", "brk_nap"])
	if J.t(v_say_321):
		J.mc(_s189["this"], "bubble", [_s189["n"], v_say_321, 2.2])
	return {"x": J.gp(v_p_329, 0.0), "y": J.gp(v_p_329, 1.0), "wait": v_wait_320, "act": J.gp(v_a_330, floor(J.num(J.mul(J.mc(_s189["this"], "rng", [_s189["n"]]), J.len(v_a_330))))), "arrived": false, "path": null, "pi": 0.0, "sit": true}

func _f88(this_, a: Array, env):
	var v_n_336 = null
	v_n_336 = J.arg(a, 0)
	var _t615 = J.gp(v_n_336, "gone")
	var _t616 = (_t615 if J.t(_t615) else J.gp(v_n_336, "out"))
	var _t617 = (_t616 if J.t(_t616) else J.gp(v_n_336, "fleeing"))
	if J.t((_t617 if J.t(_t617) else J.seq(J.gp(v_n_336, "act"), "walk"))):
		return false
	var _t620 = J.gp(v_n_336, "act")
	if J.t(_t620):
		var _t618 = J.gp(v_n_336, "act")
		var _t619 = J.mc(_t618, "startsWith", ["brk_"])
		_t620 = (_t619 if J.t(_t619) else J.seq(J.gp(v_n_336, "act"), "notes"))
	if J.t(_t620):
		return true
	var _t621 = J.gp(J.gp(this_, "site"), "pano")
	var _t622 = (J.seq(J.gp(J.gp(v_n_336, "d"), "k"), "mis") if J.t(_t621) else _t621)
	return ((J.hypot_([J.sub(J.gp(v_n_336, "x"), J.gp(J.G.get("MIS_POST"), 0.0)), J.sub(J.gp(v_n_336, "y"), J.gp(J.G.get("MIS_POST"), 1.0))]) < 0.012) if J.t(_t622) else _t622)

func _f89(this_, a: Array, env):
	var v_n_339 = null; var v_x_340 = null; var v_y_341 = null; var v_p_342 = null
	v_n_339 = J.arg(a, 0)
	v_x_340 = J.arg(a, 1)
	v_y_341 = J.arg(a, 2)
	v_p_342 = []
	var _t623 = J.G.get("_MY")
	var _t625 = J.cmp(v_y_341, J.cl(_t623, null, [0.6]), "<")
	if J.t(_t625):
		var _t624 = J.G.get("_M")
		_t625 = J.cmp(v_x_340, J.cl(_t624, null, [0.5]), ">")
	var _t627 = _t625
	if J.t(_t627):
		var _t626 = J.G.get("_M")
		_t627 = J.cmp(v_x_340, J.cl(_t626, null, [0.86]), "<")
	if _t627:
		var _t628 = J.G.get("_M")
		var _t630 = J.cl(_t628, null, [0.8])
		var _t629 = J.G.get("_MY")
		J.mc(v_p_342, "push", [[_t630, J.cl(_t629, null, [0.6])]])
	return v_p_342

func _f90(this_, a: Array, env):
	var v_n_345 = null; var v_o_346 = null; var v_ex_347 = null; var v_ey_348 = null
	v_n_345 = J.arg(a, 0)
	v_o_346 = J.arg(a, 1)
	var _t631 = J.mc(this_, "exitPt", [])
	var _t632 = J.gp(_t631, 0.0)
	v_ex_347 = _t632
	var _t633 = J.gp(_t631, 1.0)
	v_ey_348 = _t633
	if J.t(J.gp(v_o_346, "out")):
		J.sp(v_n_345, "leaving", true)
		if J.t(J.gp(v_o_346, "sayStart")):
			J.mc(this_, "bubble", [v_n_345, J.gp(v_o_346, "sayStart"), 2.4])
		return {"x": v_ex_347, "y": v_ey_348, "path": J.mc(this_, "viaElev", [v_n_345, J.gp(v_n_345, "x"), J.gp(v_n_345, "y")]), "pi": 0.0, "out": true, "leave": J.gp(v_o_346, "leave"), "outDur": J.gp(v_o_346, "outDur"), "backSay": J.gp(v_o_346, "backSay")}
	return v_o_346

func _f92(this_, a: Array, env):
	var v_a_363 = null; var v_b_364 = null
	v_a_363 = J.arg(a, 0)
	v_b_364 = J.arg(a, 1)
	return J.mc(env["this"], "U", [env["n"], v_a_363, v_b_364])

func _f93(this_, a: Array, env):
	var v_m_375 = null
	v_m_375 = J.arg(a, 0)
	var _t669 = J.seq(J.gp(J.gp(v_m_375, "d"), "k"), "boss")
	var _t670 = ((not J.t(J.gp(v_m_375, "out"))) if _t669 else _t669)
	var _t671 = ((not J.t(J.gp(v_m_375, "gone"))) if _t670 else _t670)
	return ((not J.t(J.gp(v_m_375, "fleeing"))) if _t671 else _t671)

func _f91(this_, a: Array, env):
	var v_d_352 = null; var v_U_353 = null; var v_px_354 = null; var v_py_355 = null; var v_pact_356 = null; var v_atPost_357 = null; var v_tr_358 = null; var v_tot_359 = null; var v_r_360 = null; var v_e_361 = null; var v_to_362 = null; var v_p0_365 = null; var v_p_366 = null; var v_tr_367 = null; var v_st_368 = null; var v_p_369 = null; var v_e_370 = null; var v_q_371 = null; var v_P_372 = null; var v_p_373 = null; var v_b_374 = null
	var _s197 = {"__p": env, "this": null, "n": null}
	_s197["this"] = this_
	_s197["n"] = J.arg(a, 0)
	v_d_352 = J.gp(_s197["n"], "d")
	v_U_353 = Callable(self, "_f92").bind(_s197)
	var _t634 = J.gp(v_d_352, "post")
	var _t635 = J.gp(_t634, 0.0)
	v_px_354 = _t635
	var _t636 = J.gp(_t634, 1.0)
	v_py_355 = _t636
	var _t637 = J.gp(_t634, 2.0)
	v_pact_356 = _t637
	v_atPost_357 = (J.hypot_([J.sub(J.gp(_s197["n"], "x"), v_px_354), J.sub(J.gp(_s197["n"], "y"), v_py_355)]) < 0.012)
	if J.t(J.gp(v_d_352, "lane")):
		var _t638 = _s197["n"]
		var _t639 = J.gp(_s197["n"], "li")
		var _t640 = J.add((_t639 if J.t(_t639) else 0.0), 1.0)
		J.sp(_t638, "li", _t640)
		var _t641 = J.gp(v_d_352, "tripEvery")
		var _t642 = (J.seq(J.mod(J.gp(_s197["n"], "li"), J.mul(J.gp(v_d_352, "tripEvery"), J.len(J.gp(v_d_352, "lane")))), 0.0) if J.t(_t641) else _t641)
		if J.t((J.cmp(J.mc(_s197["this"], "present", [_s197["n"]]), 3.0, ">=") if J.t(_t642) else _t642)):
			v_tr_367 = J.gp(J.gp(v_d_352, "trips"), 0.0)
			return J.mc(_s197["this"], "mkStep", [_s197["n"], {"out": true, "outDur": J.cl(v_U_353, null, J.spread([J.SP(J.gp(v_tr_367, 3.0))])), "backSay": J.gp(v_tr_367, 5.0), "sayStart": J.gp(v_tr_367, 4.0)}])
		var _t643 = J.seq(J.mod(J.gp(_s197["n"], "li"), J.len(J.gp(v_d_352, "lane"))), 4.0)
		var _t644 = (J.seq(J.mc(_s197["this"], "roomOf", [_s197["n"]]), "pantry") if _t643 else _t643)
		if (J.cmp(J.mc(_s197["this"], "rng", [_s197["n"]]), 0.6, "<") if _t644 else _t644):
			v_st_368 = J.mc(_s197["this"], "restStep", [_s197["n"], J.cl(v_U_353, null, [8.0, 12.0]), J.gp(J.G.get("BRK"), "auntie"), ["brk_drink", "brk_nap"]])
			if J.t(J.gp(v_st_368, "sit")):
				return v_st_368
		v_p0_365 = J.gp(J.gp(v_d_352, "lane"), J.mod(J.gp(_s197["n"], "li"), J.len(J.gp(v_d_352, "lane"))))
		v_p_366 = J.mc(_s197["this"], "freeSpot", [_s197["n"], J.gp(v_p0_365, 0.0), J.gp(v_p0_365, 1.0)])
		return {"x": J.gp(v_p_366, 0.0), "y": J.gp(v_p_366, 1.0), "wait": J.cl(v_U_353, null, J.spread([J.SP(J.gp(v_d_352, "laneWait"))])), "act": "mop", "arrived": false, "mopWalk": true}
	var _t645 = J.gp(v_d_352, "guard")
	var _t646 = (J.gp(_s197["n"], "tour") if J.t(_t645) else _t645)
	if J.t((J.len(J.gp(_s197["n"], "tour")) if J.t(_t646) else _t646)):
		v_p_369 = J.mc(J.gp(_s197["n"], "tour"), "shift", [])
		return {"x": J.gp(v_p_369, 0.0), "y": J.gp(v_p_369, 1.0), "wait": J.cl(v_U_353, null, [3.0, 4.5]), "act": "look", "arrived": false, "path": null, "pi": 0.0}
	if (not J.t(v_atPost_357)):
		var _t656 = J.cl(v_U_353, null, J.spread([J.SP(J.mc(_s197["this"], "workOf", [_s197["n"]]))]))
		var _t648 = J.gp(_s197["n"], "y")
		var _t647 = J.G.get("_MY")
		var _t651 = J.cmp(_t648, J.cl(_t647, null, [0.56]), "<")
		if J.t(_t651):
			var _t650 = J.gp(_s197["n"], "x")
			var _t649 = J.G.get("_M")
			_t651 = J.cmp(_t650, J.cl(_t649, null, [0.85]), ">")
		var _t655 = null
		if _t651:
			var _t652 = J.G.get("_M")
			var _t654 = J.cl(_t652, null, [0.8])
			var _t653 = J.G.get("_MY")
			_t655 = [[_t654, J.cl(_t653, null, [0.6])]]
		else:
			_t655 = null
		return {"x": v_px_354, "y": v_py_355, "wait": _t656, "act": v_pact_356, "arrived": false, "path": _t655, "pi": 0.0}
	var _t657 = J.gp(v_d_352, "trips")
	v_tr_358 = (_t657 if J.t(_t657) else [])
	v_tot_359 = 0.0
	for _t658 in J.iter(v_tr_358):
		v_e_370 = _t658
		var _t659 = J.add(v_tot_359, J.gp(v_e_370, 1.0))
		v_tot_359 = _t659
	v_r_360 = J.mul(J.mc(_s197["this"], "rng", [_s197["n"]]), v_tot_359)
	v_e_361 = J.gp(v_tr_358, 0.0)
	for _t660 in J.iter(v_tr_358):
		v_q_371 = _t660
		var _t661 = J.sub(v_r_360, J.gp(v_q_371, 1.0))
		v_r_360 = _t661
		if J.cmp(v_r_360, 0.0, "<="):
			v_e_361 = v_q_371
			break
	if (not J.t(v_e_361)):
		return {"x": v_px_354, "y": v_py_355, "wait": J.cl(v_U_353, null, J.spread([J.SP(J.mc(_s197["this"], "workOf", [_s197["n"]]))])), "act": v_pact_356, "arrived": true}
	if J.seq(J.gp(v_e_361, 2.0), "out"):
		var _t662 = J.cmp(J.mc(_s197["this"], "present", [_s197["n"]]), 2.0, "<")
		if J.t((_t662 if _t662 else J.mc(_s197["this"], "busy", [_s197["n"], J.gp(J.mc(_s197["this"], "exitPt", []), 0.0)]))):
			return {"x": v_px_354, "y": v_py_355, "wait": J.cl(v_U_353, null, [4.0, 8.0]), "act": v_pact_356, "arrived": true}
		return J.mc(_s197["this"], "mkStep", [_s197["n"], {"out": true, "outDur": J.cl(v_U_353, null, J.spread([J.SP(J.gp(v_e_361, 3.0))])), "backSay": J.gp(v_e_361, 5.0), "sayStart": J.gp(v_e_361, 4.0)}])
	v_to_362 = J.gp(v_e_361, 2.0)
	if J.seq(v_to_362, "patrol"):
		v_P_372 = J.gp(J.G.get("OFFMAP"), "PATROL")
		var _t663 = _s197["n"]
		var _t664 = J.gp(_s197["n"], "pt")
		var _t665 = J.add((_t664 if J.t(_t664) else 0.0), 1.0)
		J.sp(_t663, "pt", _t665)
		var _t666 = _s197["n"]
		var _t667 = (J.mc(v_P_372, "slice", [3.0]) if J.t(J.mod(J.gp(_s197["n"], "pt"), 2.0)) else [J.gp(v_P_372, 2.0), J.gp(v_P_372, 1.0), J.gp(v_P_372, 0.0)])
		J.sp(_t666, "tour", _t667)
		v_p_373 = J.mc(J.gp(_s197["n"], "tour"), "shift", [])
		if J.t(J.gp(v_e_361, 4.0)):
			J.mc(_s197["this"], "bubble", [_s197["n"], J.gp(v_e_361, 4.0), 2.2])
		return {"x": J.gp(v_p_373, 0.0), "y": J.gp(v_p_373, 1.0), "wait": J.cl(v_U_353, null, [3.0, 4.5]), "act": "look", "arrived": false, "path": null, "pi": 0.0}
	if J.seq(v_to_362, "rest"):
		return J.mc(_s197["this"], "restStep", [_s197["n"], J.cl(v_U_353, null, J.spread([J.SP(J.gp(v_e_361, 3.0))])), J.gp(v_e_361, 4.0), J.gp(v_e_361, 6.0)])
	if J.seq(v_to_362, "boss"):
		var _t668 = J.gp(_s197["this"], "npcs")
		v_b_374 = J.mc(_t668, "find", [Callable(self, "_f93").bind(_s197)])
		var _t672 = (not J.t(v_b_374))
		if (_t672 if _t672 else (not J.seq(J.mc(_s197["this"], "roomOf", [v_b_374]), "boss"))):
			return {"x": v_px_354, "y": v_py_355, "wait": J.cl(v_U_353, null, [4.0, 8.0]), "act": v_pact_356, "arrived": true}
		v_to_362 = J.gp(J.G.get("_SP"), "bossVisit")
	if J.t(J.mc(_s197["this"], "busy", [_s197["n"], J.gp(v_to_362, 0.0)])):
		return {"x": v_px_354, "y": v_py_355, "wait": J.cl(v_U_353, null, [3.0, 6.0]), "act": v_pact_356, "arrived": true}
	var _t673 = J.mc(_s197["this"], "freeSpot", [_s197["n"], J.gp(v_to_362, 0.0), J.gp(v_to_362, 1.0)])
	v_to_362 = _t673
	if J.t(J.gp(v_e_361, 4.0)):
		J.mc(_s197["this"], "bubble", [_s197["n"], J.gp(v_e_361, 4.0), 2.2])
	return {"x": J.gp(v_to_362, 0.0), "y": J.gp(v_to_362, 1.0), "wait": J.cl(v_U_353, null, J.spread([J.SP(J.gp(v_e_361, 3.0))])), "act": "idle", "arrived": false, "path": null, "pi": 0.0}

func _f95(this_, a: Array, env):
	var v_v_381 = null
	v_v_381 = J.arg(a, 0)
	var _t674 = J.cmp(env["x"], J.div(J.sub(v_v_381, 45.0), 1165.0), ">=")
	return (J.cmp(env["x"], J.div(J.add(J.add(v_v_381, env["w"]), 45.0), 1165.0), "<=") if _t674 else _t674)

func _f94(this_, a: Array, env):
	var v_W_379 = null
	var _s211 = {"__p": env, "x": null, "w": null}
	_s211["x"] = J.arg(a, 0)
	if (not J.t(J.gp(J.gp(this_, "site"), "pano"))):
		return false
	v_W_379 = J.gp(J.G.get("OFFMAP"), "WALLS")
	_s211["w"] = J.gp(J.G.get("OFFMAP"), "WALLW")
	return J.mc(v_W_379, "some", [Callable(self, "_f95").bind(_s211)])

func _f98(this_, a: Array, env):
	var v_m_389 = null
	v_m_389 = J.arg(a, 0)
	var _t678 = (not J.seq(v_m_389, env["__p"]["n"]))
	var _t679 = ((not J.t(J.gp(v_m_389, "gone"))) if _t678 else _t678)
	var _t680 = ((not J.t(J.gp(v_m_389, "out"))) if _t679 else _t679)
	var _t684 = ((not J.t(J.gp(v_m_389, "fleeing"))) if _t680 else _t680)
	if J.t(_t684):
		var _t683 = J.seq(J.gp(v_m_389, "act"), "walk")
		if not J.t(_t683):
			var _t681 = (not J.t(J.gp(J.gp(v_m_389, "d"), "post")))
			var _t682 = ((not J.t(J.gp(J.gp(v_m_389, "d"), "daoshi"))) if _t681 else _t681)
			_t683 = (J.cmp(J.gp(v_m_389, "wait"), 7.0, "<") if _t682 else _t682)
		_t684 = _t683
	return (J.seq(J.mc(J.G.get("OFFMAP"), "roomAt", [J.gp(v_m_389, "x")]), env["r"]) if _t684 else _t684)

func _f97(this_, a: Array, env):
	var _s214 = {"__p": env, "r": null}
	_s214["r"] = J.arg(a, 0)
	var _t676 = J.cmp(J.gp(_s214["r"], "x1"), _s214["__p"]["a"], ">")
	var _t685 = (J.cmp(J.gp(_s214["r"], "x0"), J.add(_s214["__p"]["b"], 0.000001), "<") if _t676 else _t676)
	if J.t(_t685):
		var _t677 = J.gp(_s214["__p"]["this"], "npcs")
		_t685 = (J.len(J.mc(_t677, "filter", [Callable(self, "_f98").bind(_s214)])) >= 2.0)
	return _t685

func _f96(this_, a: Array, env):
	var v_tx_385 = null
	var _s213 = {"__p": env, "this": null, "n": null, "a": null, "b": null}
	_s213["this"] = this_
	_s213["n"] = J.arg(a, 0)
	v_tx_385 = J.arg(a, 1)
	if (not J.t(J.gp(J.gp(_s213["this"], "site"), "pano"))):
		return false
	_s213["a"] = J.min_([J.gp(_s213["n"], "x"), v_tx_385])
	_s213["b"] = J.max_([J.gp(_s213["n"], "x"), v_tx_385])
	var _t675 = J.gp(J.G.get("OFFMAP"), "ROOMS")
	return J.mc(_t675, "some", [Callable(self, "_f97").bind(_s213)])

func _f101(this_, a: Array, env):
	var v_m_396 = null
	v_m_396 = J.arg(a, 0)
	var _t687 = (not J.seq(v_m_396, env["__p"]["n"]))
	var _t688 = ((not J.t(J.gp(v_m_396, "gone"))) if _t687 else _t687)
	var _t689 = ((not J.t(J.gp(v_m_396, "out"))) if _t688 else _t688)
	var _t690 = (J.seq(J.gp(v_m_396, "act"), "walk") if _t689 else _t689)
	return (J.seq(J.mc(J.G.get("OFFMAP"), "roomAt", [J.gp(v_m_396, "x")]), env["r"]) if _t690 else _t690)

func _f100(this_, a: Array, env):
	var _s217 = {"__p": env, "r": null}
	_s217["r"] = J.arg(a, 0)
	var _t686 = J.gp(_s217["__p"]["this"], "npcs")
	return (J.len(J.mc(_t686, "filter", [Callable(self, "_f101").bind(_s217)])) >= 2.0)

func _f99(this_, a: Array, env):
	var v_tx_393 = null; var v_rs_394 = null
	var _s216 = {"__p": env, "this": null, "n": null}
	_s216["this"] = this_
	_s216["n"] = J.arg(a, 0)
	v_tx_393 = J.arg(a, 1)
	if (not J.t(J.gp(J.gp(_s216["this"], "site"), "pano"))):
		return false
	v_rs_394 = [J.mc(J.G.get("OFFMAP"), "roomAt", [J.gp(_s216["n"], "x")]), J.mc(J.G.get("OFFMAP"), "roomAt", [v_tx_393])]
	return J.mc(v_rs_394, "some", [Callable(self, "_f100").bind(_s216)])

func _f103(this_, a: Array, env):
	var v_m_405 = null; var v_p_406 = null
	v_m_405 = J.arg(a, 0)
	var _t691 = J.seq(v_m_405, env["n"])
	var _t692 = (_t691 if _t691 else J.gp(v_m_405, "gone"))
	var _t693 = (_t692 if J.t(_t692) else J.gp(v_m_405, "out"))
	if J.t((_t693 if J.t(_t693) else J.gp(J.gp(v_m_405, "d"), "daoshi"))):
		return []
	v_p_406 = [[J.gp(v_m_405, "x"), J.gp(v_m_405, "y")]]
	var _t694 = J.gp(v_m_405, "step")
	if J.t(((not J.t(J.gp(J.gp(v_m_405, "step"), "arrived"))) if J.t(_t694) else _t694)):
		J.mc(v_p_406, "push", [[J.gp(J.gp(v_m_405, "step"), "x"), J.gp(J.gp(v_m_405, "step"), "y")]])
	var _t695 = J.gp(J.gp(v_m_405, "d"), "post")
	if J.t(((not J.t(J.gp(J.gp(v_m_405, "d"), "guard"))) if J.t(_t695) else _t695)):
		J.mc(v_p_406, "push", [[J.gp(J.gp(J.gp(v_m_405, "d"), "post"), 0.0), J.gp(J.gp(J.gp(v_m_405, "d"), "post"), 1.0)]])
	return v_p_406

func _f104(this_, a: Array, env):
	var v_p_409 = null
	v_p_409 = J.arg(a, 0)
	var _t698 = (absf(J.num(J.sub(J.gp(v_p_409, 0.0), env["xx"]))) < 0.13)
	return ((absf(J.num(J.sub(J.gp(v_p_409, 1.0), env["__p"]["y"]))) < 0.3) if _t698 else _t698)

func _f102(this_, a: Array, env):
	var v_x_400 = null; var v_taken_402 = null; var v_occ_403 = null; var v_best_404 = null; var v_dx_407 = null
	var _s219 = {"__p": env, "n": null, "y": null}
	_s219["n"] = J.arg(a, 0)
	v_x_400 = J.arg(a, 1)
	_s219["y"] = J.arg(a, 2)
	v_taken_402 = Callable(self, "_f103").bind(_s219)
	var _t696 = J.gp(this_, "npcs")
	v_occ_403 = J.mc(_t696, "flatMap", [v_taken_402])
	v_best_404 = [v_x_400, _s219["y"]]
	for _t697 in J.iter([0.0, 0.14, (-0.14)]):
		v_dx_407 = _t697
		var _s222 = {"__p": _s219, "xx": null}
		_s222["xx"] = J.add(v_x_400, v_dx_407)
		if (not J.t(J.mc(v_occ_403, "some", [Callable(self, "_f104").bind(_s222)]))):
			var _t699 = [_s222["xx"], _s222["__p"]["y"]]
			v_best_404 = _t699
			break
	return v_best_404

func _f106(this_, a: Array, env):
	var v_m_417 = null
	v_m_417 = J.arg(a, 0)
	var _t701 = J.seq(J.gp(J.gp(v_m_417, "d"), "k"), "it")
	var _t702 = (_t701 if _t701 else J.seq(J.gp(J.gp(v_m_417, "d"), "k"), "mis"))
	var _t703 = ((not J.t(J.gp(v_m_417, "gone"))) if _t702 else _t702)
	var _t704 = ((not J.t(J.gp(v_m_417, "out"))) if _t703 else _t703)
	var _t705 = ((not J.t(J.gp(v_m_417, "fleeing"))) if _t704 else _t704)
	var _t706 = ((not J.t(J.gp(v_m_417, "leaving"))) if _t705 else _t705)
	var _t708 = ((not J.t(J.gp(v_m_417, "call"))) if _t706 else _t706)
	if J.t(_t708):
		var _t707 = J.gp(v_m_417, "step")
		_t708 = (not J.t((J.gp(J.gp(v_m_417, "step"), "called") if J.t(_t707) else _t707)))
	return (J.cmp(J.gp(v_m_417, "fear"), 50.0, "<") if _t708 else _t708)

func _f107(this_, a: Array, env):
	return J.sub(J.mc(env["this"], "rng", [env["b"]]), 0.5)

func _f108(this_, a: Array, env):
	var v_m_419 = null
	v_m_419 = J.arg(a, 0)
	return J.gp(J.gp(v_m_419, "d"), "name")

func _f109(this_, a: Array, env):
	var v_c_420 = null; var v_i_421 = null
	v_c_420 = J.arg(a, 0)
	v_i_421 = J.arg(a, 1)
	var _t725 = {"x": J.gp(J.gp([J.gp(J.G.get("_SP"), "seat1"), J.gp(J.G.get("_SP"), "seat2"), J.gp(J.G.get("_SP"), "seat3")], J.mod(v_i_421, 3.0)), 0.0), "y": J.gp(J.gp([J.gp(J.G.get("_SP"), "seat1"), J.gp(J.G.get("_SP"), "seat2"), J.gp(J.G.get("_SP"), "seat3")], J.mod(v_i_421, 3.0)), 1.0), "wait": 60.0, "act": "notes", "delay": (1.5 + J.mul(v_i_421, 3.5)), "go": (null if J.t(v_i_421) else "又開會……")}
	J.sp(v_c_420, "call", _t725)

func _f105(this_, a: Array, env):
	var v_kind_413 = null; var v_cand_414 = null; var v_k_415 = null; var v_who_416 = null; var v_c_418 = null
	var _s225 = {"__p": env, "this": null, "b": null}
	_s225["this"] = this_
	_s225["b"] = J.arg(a, 0)
	v_kind_413 = J.arg(a, 1)
	var _t700 = J.gp(_s225["this"], "npcs")
	v_cand_414 = J.mc(_t700, "filter", [Callable(self, "_f106").bind(_s225)])
	if (not J.t(J.len(v_cand_414))):
		return false
	if J.seq(v_kind_413, "callin"):
		v_c_418 = J.gp(v_cand_414, floor(J.num(J.mul(J.mc(_s225["this"], "rng", [_s225["b"]]), J.len(v_cand_414)))))
		J.mc(_s225["this"], "bubble", [_s225["b"], (J.str(J.gp(J.gp(v_c_418, "d"), "name")) + "，入嚟我房！"), 2.6])
		var _t709 = _s225["b"]
		J.sp(_t709, "next", null)
		var _t710 = _s225["b"]
		var _t711 = {"x": J.gp(J.gp(J.gp(_s225["b"], "d"), "post"), 0.0), "y": J.gp(J.gp(J.gp(_s225["b"], "d"), "post"), 1.0), "wait": 24.0, "act": "read", "arrived": (J.hypot_([J.sub(J.gp(_s225["b"], "x"), J.gp(J.gp(J.gp(_s225["b"], "d"), "post"), 0.0)), J.sub(J.gp(_s225["b"], "y"), J.gp(J.gp(J.gp(_s225["b"], "d"), "post"), 1.0))]) < 0.012), "path": null, "pi": 0.0, "say": "（睇報告）企喺度等我睇完先。", "called": true}
		J.sp(_t710, "step", _t711)
		if J.t(J.gp(J.gp(_s225["b"], "step"), "arrived")):
			var _t712 = _s225["b"]
			J.sp(_t712, "wait", 24.0)
			J.mc(_s225["this"], "bubble", [_s225["b"], J.gp(J.gp(_s225["b"], "step"), "say"), 2.4])
		var _t713 = {"x": J.gp(J.gp(J.G.get("_SP"), "bossFront"), 0.0), "y": J.gp(J.gp(J.G.get("_SP"), "bossFront"), 1.0), "wait": 14.0, "act": "idle", "delay": 1.2, "go": ("嚟緊喇陳總～" if J.seq(J.gp(J.gp(v_c_418, "d"), "k"), "mis") else "……係。"), "say": ("陳總～搵我呀？" if J.seq(J.gp(J.gp(v_c_418, "d"), "k"), "mis") else "陳總，搵我？"), "boss": _s225["b"]}
		J.sp(v_c_418, "call", _t713)
		var _t714 = _s225["this"]
		var _t715 = J.gp(_s225["this"], "t")
		J.sp(_t714, "callT", _t715)
		var _t716 = _s225["this"]
		J.sp(_t716, "callWho", v_c_418)
		return true
	var _t717 = (J.len(v_cand_414) > 1.0)
	v_k_415 = (2.0 if (J.cmp(J.mc(_s225["this"], "rng", [_s225["b"]]), 0.6, "<") if _t717 else _t717) else 1.0)
	var _t718 = J.mc(v_cand_414, "sort", [Callable(self, "_f107").bind(_s225)])
	v_who_416 = J.mc(_t718, "slice", [0.0, v_k_415])
	var _t721 = _s225["b"]
	var _t720 = null
	if (J.len(v_who_416) > 1.0):
		var _t719 = J.mc(v_who_416, "map", [Callable(self, "_f108").bind(_s225)])
		_t720 = (J.str(J.mc(_t719, "join", ["、"])) + "，入會議室開會！")
	else:
		_t720 = (J.str(J.gp(J.gp(J.gp(v_who_416, 0.0), "d"), "name")) + "，入會議室！")
	J.mc(_s225["this"], "bubble", [_t721, _t720, 2.8])
	var _t722 = _s225["b"]
	J.sp(_t722, "next", null)
	var _t723 = _s225["b"]
	var _t724 = {"x": J.gp(J.gp(J.G.get("_SP"), "board"), 0.0), "y": J.gp(J.gp(J.G.get("_SP"), "board"), 1.0), "wait": 22.0, "act": "present", "arrived": false, "path": null, "pi": 0.0, "say": "（指住白板）呢季嘅數……", "called": true, "meet": true}
	J.sp(_t723, "step", _t724)
	J.mc(v_who_416, "forEach", [Callable(self, "_f109").bind(_s225)])
	var _t726 = _s225["this"]
	var _t727 = J.gp(_s225["this"], "t")
	J.sp(_t726, "meetT", _t727)
	return true

func _f110(this_, a: Array, env):
	var v_n_424 = null
	v_n_424 = J.arg(a, 0)
	var _t729 = J.seq(v_n_424, J.gp(this_, "sel"))
	if not J.t(_t729):
		var _t728 = J.cmp(J.gp(v_n_424, "mocked"), 0.0, ">")
		_t729 = ((not J.t(J.gp(J.gp(v_n_424, "d"), "guard"))) if _t728 else _t728)
	return (16.0 if _t729 else 0.0)

func _f111(this_, a: Array, env):
	var v_ctx_427 = null; var v_n_428 = null; var v_x_429 = null; var v_by_430 = null; var v_t_431 = null; var v_k_432 = null; var v_cx_433 = null; var v_cy_434 = null; var v_r_435 = null
	v_ctx_427 = J.arg(a, 0)
	v_n_428 = J.arg(a, 1)
	v_x_429 = J.arg(a, 2)
	v_by_430 = J.arg(a, 3)
	v_t_431 = J.arg(a, 4)
	v_k_432 = J.max_([0.0, J.min_([1.0, (1.0 - J.div(J.gp(v_n_428, "wait"), 3.5))])])
	v_cx_433 = J.add(v_x_429, 46.0)
	v_cy_434 = J.add(v_by_430, 1.0)
	v_r_435 = 9.0
	J.mc(v_ctx_427, "save", [])
	J.sp(v_ctx_427, "fillStyle", "rgba(0,0,0,.55)")
	J.mc(v_ctx_427, "beginPath", [])
	J.mc(v_ctx_427, "arc", [v_cx_433, v_cy_434, J.add(v_r_435, 3.0), 0.0, (PI * 2.0)])
	J.mc(v_ctx_427, "fill", [])
	J.sp(v_ctx_427, "strokeStyle", "#ffb34a")
	J.sp(v_ctx_427, "lineWidth", 3.0)
	J.mc(v_ctx_427, "beginPath", [])
	J.mc(v_ctx_427, "arc", [v_cx_433, v_cy_434, v_r_435, J.div((-PI), 2.0), (J.div((-PI), 2.0) + (J.mul(v_k_432, PI) * 2.0))])
	J.mc(v_ctx_427, "stroke", [])
	J.sp(v_ctx_427, "font", "900 11px sans-serif")
	J.sp(v_ctx_427, "textAlign", "center")
	J.sp(v_ctx_427, "textBaseline", "middle")
	J.sp(v_ctx_427, "fillStyle", "#ffe2b0")
	J.mc(v_ctx_427, "fillText", ["走", v_cx_433, J.add(v_cy_434, 0.5)])
	J.mc(v_ctx_427, "restore", [])

func _f112(this_, a: Array, env):
	var v_g_438 = null; var v_x_439 = null; var v_y_440 = null; var v_dx_441 = null; var v_dy_442 = null; var v_d_443 = null
	v_g_438 = J.arg(a, 0)
	v_x_439 = J.arg(a, 1)
	v_y_440 = J.arg(a, 2)
	if J.seq(J.gp(v_g_438, "act"), "doze"):
		return false
	var _t730 = J.gp(J.gp(this_, "site"), "pano")
	if J.t(((not J.seq(J.mc(J.G.get("OFFMAP"), "roomAt", [J.gp(v_g_438, "x")]), J.mc(J.G.get("OFFMAP"), "roomAt", [v_x_439]))) if J.t(_t730) else _t730)):
		return false
	v_dx_441 = J.sub(v_x_439, J.gp(v_g_438, "x"))
	v_dy_442 = J.sub(v_y_440, J.sub(J.gp(v_g_438, "y"), 0.08))
	if (not J.seq(signf(J.num(v_dx_441)), J.gp(v_g_438, "dir"))):
		return false
	v_d_443 = absf(J.num(v_dx_441))
	var _t731 = J.cmp(v_d_443, 0.4, "<")
	return ((absf(J.num(v_dy_442)) < (0.06 + J.mul(v_d_443, 0.35))) if _t731 else _t731)

func _f113(this_, a: Array, env):
	if (not J.t(J.gp(J.gp(this_, "site"), "pano"))):
		return null
	if J.t(J.gp(this_, "headless")):
		return (J.mc(this_, "roomOf", [J.gp(this_, "sel")]) if J.t(J.gp(this_, "sel")) else "main")
	return J.gp(J.mc(this_, "camRoom", []), "k")

func _f114(this_, a: Array, env):
	var v_m_448 = null; var v_room_449 = null
	v_m_448 = J.arg(a, 0)
	v_room_449 = J.arg(a, 1)
	var _t732 = (not J.t(v_room_449))
	return (_t732 if _t732 else J.seq(J.mc(this_, "roomOf", [v_m_448]), v_room_449))

func _f116(this_, a: Array, env):
	var v_m_456 = null
	v_m_456 = J.arg(a, 0)
	var _t735 = (not J.t(J.gp(v_m_456, "gone")))
	var _t736 = ((not J.t(J.gp(v_m_456, "out"))) if _t735 else _t735)
	var _t737 = ((not J.t(J.gp(v_m_456, "fleeing"))) if _t736 else _t736)
	var _t738 = ((not J.t(J.gp(J.gp(v_m_456, "d"), "guard"))) if _t737 else _t737)
	return (J.mc(env["__p"]["this"], "inGroup", [v_m_456, env["rm"]]) if _t738 else _t738)

func _f115(this_, a: Array, env):
	var v_k_452 = null; var v_n_453 = null; var v_p_454 = null
	var _s237 = {"__p": env, "this": null}
	_s237["this"] = this_
	v_k_452 = J.arg(a, 0)
	v_n_453 = J.arg(a, 1)
	v_p_454 = J.gp(J.G.get("SCARE_PROPS"), v_k_452)
	if J.t(J.gp(v_p_454, "group")):
		var _s238 = {"__p": _s237, "rm": null}
		_s238["rm"] = J.mc(_s238["__p"]["this"], "groupRoom", [])
		var _t733 = J.gp(_s238["__p"]["this"], "pcd")
		var _t739 = (not J.cmp(J.gp((_t733 if J.t(_t733) else {}), v_k_452), 0.0, ">"))
		if J.t(_t739):
			var _t734 = J.gp(_s238["__p"]["this"], "npcs")
			_t739 = J.mc(_t734, "some", [Callable(self, "_f116").bind(_s238)])
		return _t739
	var _t740 = ((not J.t(J.gp(v_n_453, "gone"))) if J.t(v_n_453) else v_n_453)
	var _t741 = ((not J.t(J.gp(v_n_453, "out"))) if J.t(_t740) else _t740)
	var _t742 = ((not J.t(J.gp(v_n_453, "fleeing"))) if J.t(_t741) else _t741)
	var _t744 = ((not J.t(J.gp(J.gp(v_n_453, "d"), "guard"))) if J.t(_t742) else _t742)
	if J.t(_t744):
		var _t743 = J.seq(J.gp(v_p_454, "r"), 0.0)
		_t744 = (_t743 if _t743 else J.cmp(J.hypot_([J.sub(J.gp(v_n_453, "x"), J.gp(J.gp(v_p_454, "front"), 0.0)), (J.sub(J.gp(v_n_453, "y"), J.gp(J.gp(v_p_454, "front"), 1.0)) * 1.4)]), J.gp(v_p_454, "r"), "<"))
	return (not (not J.t(_t744)))

func _f118(this_, a: Array, env):
	var v_m_470 = null
	v_m_470 = J.arg(a, 0)
	var _t749 = (not J.t(J.gp(v_m_470, "gone")))
	var _t750 = ((not J.t(J.gp(v_m_470, "out"))) if _t749 else _t749)
	var _t751 = ((not J.t(J.gp(v_m_470, "fleeing"))) if _t750 else _t750)
	var _t752 = ((not J.t(J.gp(J.gp(v_m_470, "d"), "guard"))) if _t751 else _t751)
	return (J.mc(env["__p"]["this"], "inGroup", [v_m_470, env["rm"]]) if _t752 else _t752)

func _f119(this_, a: Array, env):
	var v_m_471 = null
	v_m_471 = J.arg(a, 0)
	var _t760 = (not J.t(J.gp(v_m_471, "gone")))
	var _t761 = ((not J.t(J.gp(v_m_471, "out"))) if _t760 else _t760)
	var _t762 = ((not J.t(J.gp(v_m_471, "fleeing"))) if _t761 else _t761)
	return (J.mc(env["__p"]["this"], "inGroup", [v_m_471, env["rm"]]) if _t762 else _t762)

func _f117(this_, a: Array, env):
	var v_k_459 = null; var v_who_460 = null; var v_p_461 = null; var v_n_462 = null; var v_cx_463 = null; var v_cy_464 = null; var v_RR_466 = null; var v_cx_467 = null; var v_cy_468 = null; var v_tg_469 = null; var v_m_472 = null
	var _s240 = {"__p": env, "this": null}
	_s240["this"] = this_
	v_k_459 = J.arg(a, 0)
	v_who_460 = J.arg(a, 1)
	v_p_461 = J.gp(J.G.get("SCARE_PROPS"), v_k_459)
	v_n_462 = (v_who_460 if J.t(v_who_460) else J.gp(_s240["this"], "sel"))
	var _t745 = _s240["this"]
	var _t746 = J.gp(_s240["this"], "pcd")
	var _t747 = (_t746 if J.t(_t746) else {})
	J.sp(_t745, "pcd", _t747)
	if J.t(J.gp(v_p_461, "group")):
		var _s241 = {"__p": _s240, "rm": null}
		if J.cmp(J.gp(J.gp(_s241["__p"]["this"], "pcd"), v_k_459), 0.0, ">"):
			J.mc(_s241["__p"]["this"], "toast", [(J.str(J.gp(v_p_461, "name")) + "冷卻中")])
			return null
		if J.cmp(J.gp(_s241["__p"]["this"], "mana"), J.gp(v_p_461, "cost"), "<"):
			J.mc(_s241["__p"]["this"], "toast", ["陰氣不夠，等一下"])
			return null
		_s241["rm"] = J.mc(_s241["__p"]["this"], "groupRoom", [])
		v_RR_466 = (J.gp(J.gp(J.G.get("OFFMAP"), "RM"), _s241["rm"]) if J.t(_s241["rm"]) else _s241["rm"])
		var _t748 = J.gp(_s241["__p"]["this"], "npcs")
		if (not J.t(J.mc(_t748, "some", [Callable(self, "_f118").bind(_s241)]))):
			J.mc(_s241["__p"]["this"], "toast", [(J.str((J.gp(v_RR_466, "name") if J.t(v_RR_466) else "呢度")) + "冇人")])
			return null
		if J.t(v_RR_466):
			var _t753 = [J.sub(J.mc(J.G.get("OFFMAP"), "npx", [J.gp(J.gp(v_RR_466, "vent"), 0.0)]), 0.06), J.mc(J.G.get("OFFMAP"), "py", [J.gp(J.gp(v_RR_466, "vent"), 1.0)]), 0.12, 0.02]
			J.sp(v_p_461, "rect", _t753)
		var _t754 = _s241["__p"]["this"]
		var _t755 = J.sub(J.gp(_t754, "mana"), J.gp(v_p_461, "cost"))
		J.sp(_t754, "mana", _t755)
		var _t756 = J.gp(_s241["__p"]["this"], "pcd")
		var _t757 = J.gp(v_p_461, "cdT")
		J.sp(_t756, v_k_459, _t757)
		v_cx_467 = J.add(J.gp(J.gp(v_p_461, "rect"), 0.0), J.div(J.gp(J.gp(v_p_461, "rect"), 2.0), 2.0))
		v_cy_468 = J.add(J.gp(J.gp(v_p_461, "rect"), 1.0), J.gp(J.gp(v_p_461, "rect"), 3.0))
		var _t758 = J.gp(_s241["__p"]["this"], "fx")
		J.mc(_t758, "push", [{"kind": v_k_459, "life": 2.2, "x": v_cx_467, "y": v_cy_468, "room": _s241["rm"]}])
		if (not J.t(J.gp(_s241["__p"]["this"], "headless"))):
			J.mc(J.G.get("Sound"), "play", [("click" if J.seq(v_k_459, "lights") else "whoosh")])
			J.mc(_s241["__p"]["this"], "propParts", [v_k_459, v_p_461])
			if J.t(J.gp(J.gp(_s241["__p"]["this"], "site"), "pano")):
				J.mc(J.G.get("OFFMAP"), "onProp", [v_k_459, null, _s241["rm"]])
			else:
				if J.t(J.mc(_s241["__p"]["this"], "office", [])):
					J.mc(J.G.get("OFFICE"), "onProp", [v_k_459])
			J.mc(_s241["__p"]["this"], "float", [0.5, 0.36, ((J.add(J.gp(v_RR_466, "name"), "入面") if J.t(v_RR_466) else "全場") + "一齊經歷：冇人會話邊個黐線　之後單嚇 ×" + J.str(J.gp(J.G.get("FEAR"), "uneasyMul"))), "#bcd4ff", 2.2])
		var _t759 = J.gp(_s241["__p"]["this"], "npcs")
		v_tg_469 = J.mc(_t759, "filter", [Callable(self, "_f119").bind(_s241)])
		var _t763 = _s241["__p"]["this"]
		J.sp(_t763, "_src", v_cx_467)
		var _t764 = _s241["__p"]["this"]
		J.sp(_t764, "_dl", 0.0)
		var _t765 = _s241["__p"]["this"]
		J.sp(_t765, "_group", true)
		for _t766 in J.iter(v_tg_469):
			v_m_472 = _t766
			J.mc(_s241["__p"]["this"], "hit", [v_m_472, J.gp(v_p_461, "type"), J.gp(v_p_461, "base"), J.gp(v_p_461, "tier")])
		var _t767 = _s241["__p"]["this"]
		J.sp(_t767, "_group", false)
		var _t768 = _s241["__p"]["this"]
		J.sp(_t768, "_src", null)
		J.mc(_s241["__p"]["this"], "expose", [J.gp(J.G.get("EXPO"), "group")])
		return null
	var _t769 = (not J.t(v_n_462))
	var _t770 = (_t769 if _t769 else J.gp(v_n_462, "gone"))
	var _t771 = (_t770 if J.t(_t770) else J.gp(v_n_462, "out"))
	var _t772 = (_t771 if J.t(_t771) else J.gp(v_n_462, "fleeing"))
	if J.t((_t772 if J.t(_t772) else J.gp(J.gp(v_n_462, "d"), "guard"))):
		J.mc(_s240["this"], "toast", ["先點一個人"])
		return null
	if (not J.t(J.mc(_s240["this"], "propOK", [v_k_459, v_n_462]))):
		J.mc(_s240["this"], "toast", [(J.str(J.gp(J.gp(v_n_462, "d"), "name")) + "離" + J.str(J.gp(v_p_461, "name")) + "太遠")])
		return null
	if J.cmp(J.gp(_s240["this"], "mana"), J.gp(v_p_461, "cost"), "<"):
		J.mc(_s240["this"], "toast", ["陰氣不夠，等一下"])
		return null
	var _t773 = _s240["this"]
	var _t774 = J.sub(J.gp(_t773, "mana"), J.gp(v_p_461, "cost"))
	J.sp(_t773, "mana", _t774)
	v_cx_463 = (J.add(J.gp(J.gp(v_p_461, "rect"), 0.0), J.div(J.gp(J.gp(v_p_461, "rect"), 2.0), 2.0)) if J.t(J.gp(v_p_461, "r")) else J.gp(v_n_462, "x"))
	v_cy_464 = (J.add(J.gp(J.gp(v_p_461, "rect"), 1.0), J.gp(J.gp(v_p_461, "rect"), 3.0)) if J.t(J.gp(v_p_461, "r")) else J.sub(J.gp(v_n_462, "y"), 0.2))
	var _t775 = J.gp(_s240["this"], "fx")
	J.mc(_t775, "push", [{"kind": v_k_459, "life": 2.2, "x": v_cx_463, "y": v_cy_464, "n": v_n_462}])
	if (not J.t(J.gp(_s240["this"], "headless"))):
		var _t776 = J.seq(v_k_459, "printer")
		var _t781 = null
		if (_t776 if _t776 else J.seq(v_k_459, "vend")):
			_t781 = "paper"
		else:
			var _t777 = J.seq(v_k_459, "lamp")
			var _t778 = (_t777 if _t777 else J.seq(v_k_459, "drop"))
			var _t780 = null
			if (_t778 if _t778 else J.seq(v_k_459, "trophy")):
				_t780 = "hit"
			else:
				var _t779 = J.seq(v_k_459, "water")
				_t780 = ("crow" if (_t779 if _t779 else J.seq(v_k_459, "kettle")) else "whoosh")
			_t781 = _t780
		J.mc(J.G.get("Sound"), "play", [_t781])
		J.mc(_s240["this"], "propParts", [v_k_459, v_p_461, v_n_462])
		if J.t(J.mc(_s240["this"], "office", [])):
			var _t782 = J.gp(v_p_461, "room")
			var _t783 = ((not J.seq(J.gp(v_p_461, "room"), "main")) if J.t(_t782) else _t782)
			if J.t(((not J.seq(v_k_459, "printer")) if J.t(_t783) else _t783)):
				J.mc(J.G.get("OFFMAP"), "onProp", [v_k_459, v_n_462])
			else:
				J.mc(J.G.get("OFFICE"), "onProp", [v_k_459])
	var _t784 = _s240["this"]
	J.sp(_t784, "_src", v_cx_463)
	var _t785 = _s240["this"]
	J.sp(_t785, "_dl", 0.0)
	var _t786 = _s240["this"]
	var _t787 = (not (not J.t(J.gp(v_p_461, "vis"))))
	J.sp(_t786, "_vis", _t787)
	J.mc(_s240["this"], "hit", [v_n_462, J.gp(v_p_461, "type"), J.gp(v_p_461, "base"), J.gp(v_p_461, "tier")])
	var _t788 = _s240["this"]
	J.sp(_t788, "_src", null)
	var _t789 = _s240["this"]
	J.sp(_t789, "_vis", false)

func _f120(this_, a: Array, env):
	var v_n_475 = null; var v_cost_476 = null
	v_n_475 = J.arg(a, 0)
	v_cost_476 = 22.0
	var _t790 = (not J.t(v_n_475))
	var _t791 = (_t790 if _t790 else J.gp(v_n_475, "gone"))
	if J.t((_t791 if J.t(_t791) else (not J.t(J.gp(J.gp(v_n_475, "d"), "phone"))))):
		return null
	if J.t(J.gp(v_n_475, "out")):
		J.mc(this_, "toast", [(J.str(J.gp(J.gp(v_n_475, "d"), "name")) + "不在")])
		return null
	if J.cmp(J.gp(this_, "mana"), v_cost_476, "<"):
		J.mc(this_, "toast", ["陰氣不夠，等一下"])
		return null
	var _t792 = this_
	var _t793 = J.sub(J.gp(_t792, "mana"), v_cost_476)
	J.sp(_t792, "mana", _t793)
	var _t794 = J.gp(this_, "fx")
	J.mc(_t794, "push", [{"kind": "phone", "life": 1.6, "n": v_n_475}])
	if (not J.t(J.gp(this_, "headless"))):
		J.mc(J.G.get("Sound"), "play", ["click"])
	var _t795 = this_
	J.sp(_t795, "_src", null)
	var _t796 = this_
	J.sp(_t796, "_dl", 0.0)
	var _t797 = this_
	J.sp(_t797, "_vis", false)
	J.mc(this_, "hit", [v_n_475, "phone", 22.0, 1.0, null, true])

func _f121(this_, a: Array, env):
	var v_n_479 = null; var v_cost_480 = null
	v_n_479 = J.arg(a, 0)
	v_cost_480 = 20.0
	var _t798 = (not J.t(v_n_479))
	var _t799 = (_t798 if _t798 else J.gp(v_n_479, "gone"))
	if J.t((_t799 if J.t(_t799) else J.gp(v_n_479, "fleeing"))):
		return null
	if J.t(J.gp(v_n_479, "out")):
		J.mc(this_, "toast", [(J.str(J.gp(J.gp(v_n_479, "d"), "name")) + "不在")])
		return null
	if J.cmp(J.gp(this_, "mana"), v_cost_480, "<"):
		J.mc(this_, "toast", ["陰氣不夠，等一下"])
		return null
	var _t800 = this_
	var _t801 = J.sub(J.gp(_t800, "mana"), v_cost_480)
	J.sp(_t800, "mana", _t801)
	var _t802 = J.gp(this_, "fx")
	J.mc(_t802, "push", [{"kind": "breath", "life": 2.4, "max": 2.4, "n": v_n_479}])
	if (not J.t(J.gp(this_, "headless"))):
		J.mc(J.G.get("Sound"), "play", ["whoosh"])
	var _t803 = this_
	J.sp(_t803, "_src", null)
	var _t804 = this_
	J.sp(_t804, "_dl", 0.0)
	var _t805 = this_
	J.sp(_t805, "_vis", false)
	var _t806 = J.gp(J.gp(v_n_479, "d"), "weak")
	J.mc(this_, "hit", [v_n_479, ("breath" if J.t(J.mc(_t806, "includes", ["breath"])) else "cold"), 24.0, 1.0, null, true])
	var _t807 = (not J.t(J.gp(this_, "headless")))
	var _t808 = (J.gp(v_n_479, "rx") if _t807 else _t807)
	var _t809 = ((not J.seq(J.gp(J.gp(v_n_479, "rx"), "k"), "burst")) if J.t(_t808) else _t808)
	if J.t(((not J.t(J.gp(v_n_479, "fleeing"))) if J.t(_t809) else _t809)):
		J.mc(this_, "react", [v_n_479, "chill", {"dur": 2.4}])
	var _t810 = (not J.t(J.gp(this_, "headless")))
	var _t811 = (J.gp(v_n_479, "rx") if _t810 else _t810)
	if J.t((J.seq(J.gp(J.gp(v_n_479, "rx"), "k"), "chill") if J.t(_t811) else _t811)):
		J.sp(v_n_479, "hair", 1.2)
		J.sp(v_n_479, "goose", 2.0)

func _f123(this_, a: Array, env):
	var _t824 = J.gp(env["this"], "active")
	return (J.mc(J.G.get("OFFICE"), "onScare", [env["gx"], env["gy"], (0.75 if J.t(J.gp(env["g"], "aoe")) else 1.0)]) if J.t(_t824) else _t824)

func _f124(this_, a: Array, env):
	var v_m_491 = null
	v_m_491 = J.arg(a, 0)
	var _t826 = (not J.t(J.gp(v_m_491, "gone")))
	var _t827 = ((not J.t(J.gp(v_m_491, "out"))) if _t826 else _t826)
	return ((not J.t(J.gp(v_m_491, "fleeing"))) if _t827 else _t827)

func _f122(this_, a: Array, env):
	var v_k_483 = null; var v_n_484 = null; var v_cost_486 = null; var v_gq_487 = null; var v_tg_490 = null; var v_m_492 = null
	var _s261 = {"__p": env, "this": null, "g": null, "gx": null, "gy": null}
	_s261["this"] = this_
	v_k_483 = J.arg(a, 0)
	v_n_484 = J.arg(a, 1)
	_s261["g"] = J.gp(J.G.get("SCARE_GHOSTS"), v_k_483)
	var _t812 = (not J.t(_s261["g"]))
	if (_t812 if _t812 else J.cmp(J.gp(J.gp(_s261["this"], "cd"), v_k_483), 0.0, ">")):
		return null
	var _t813 = J.gp(_s261["g"], "cost")
	v_cost_486 = (_t813 if J.t(_t813) else 35.0)
	if J.cmp(J.gp(_s261["this"], "mana"), v_cost_486, "<"):
		J.mc(_s261["this"], "toast", ["陰氣不夠，等一下"])
		return null
	var _t815 = (not J.t(J.gp(_s261["g"], "aoe")))
	if J.t(_t815):
		var _t814 = (not J.t(v_n_484))
		_t815 = (_t814 if _t814 else J.gp(v_n_484, "gone"))
	if J.t(_t815):
		J.mc(_s261["this"], "toast", ["先點一個人"])
		return null
	var _t816 = (not J.t(J.gp(_s261["g"], "aoe")))
	if J.t((J.gp(v_n_484, "out") if _t816 else _t816)):
		J.mc(_s261["this"], "toast", [(J.str(J.gp(J.gp(v_n_484, "d"), "name")) + "不在")])
		return null
	v_gq_487 = J.mc(_s261["this"], "gpq", [v_k_483])
	var _t817 = _s261["this"]
	var _t818 = J.sub(J.gp(_t817, "mana"), v_cost_486)
	J.sp(_t817, "mana", _t818)
	var _t819 = J.gp(_s261["this"], "cd")
	var _t820 = J.div(J.round(J.num((J.div(22.0, (1.0 + (0.25 * J.sub(v_gq_487, 1.0)))) * 10.0))), 10.0)
	J.sp(_t819, v_k_483, _t820)
	_s261["gx"] = ((J.add(J.gp(_s261["this"], "camX"), J.div(J.mc(_s261["this"], "viewW", []), 2.0)) if J.t(J.gp(J.gp(_s261["this"], "site"), "pano")) else 0.5) if J.t(J.gp(_s261["g"], "aoe")) else J.add(J.gp(v_n_484, "x"), (((-0.13) if J.cmp(J.gp(J.mc(_s261["this"], "pt", [J.gp(v_n_484, "x"), 0.0]), 0.0), J.div(J.gp(_s261["this"], "W"), 2.0), ">") else 0.13) if J.t(J.gp(J.gp(_s261["this"], "site"), "pano")) else ((-0.13) if J.cmp(J.gp(v_n_484, "x"), 0.5, ">") else 0.13))))
	_s261["gy"] = (0.45 if J.t(J.gp(_s261["g"], "aoe")) else J.gp(v_n_484, "y"))
	var _t821 = J.gp(_s261["this"], "fx")
	J.mc(_t821, "push", [{"kind": "ghost", "ghost": v_k_483, "life": 2.4, "max": 2.4, "gx": _s261["gx"], "gy": _s261["gy"], "n": v_n_484, "sig": J.gp(_s261["g"], "fx"), "sigText": J.gp(_s261["g"], "fxText"), "col": J.gp(_s261["g"], "col")}])
	if (not J.t(J.gp(_s261["this"], "headless"))):
		J.mc(J.G.get("Sound"), "play", ["skill"])
		var _t822 = _s261["this"]
		J.sp(_t822, "shake", 1.0)
		var _t823 = _s261["this"]
		J.sp(_t823, "vign", 1.0)
		if J.t(J.mc(_s261["this"], "office", [])):
			J.F_setTimeout([Callable(self, "_f123").bind(_s261), ((0.5 if J.t(J.gp(_s261["g"], "aoe")) else 0.9) * 1000.0)])
	var _t828 = null
	if J.t(J.gp(_s261["g"], "aoe")):
		var _t825 = J.gp(_s261["this"], "npcs")
		_t828 = J.mc(_t825, "filter", [Callable(self, "_f124").bind(_s261)])
	else:
		_t828 = [v_n_484]
	v_tg_490 = _t828
	var _t829 = J.gp(_s261["g"], "aoe")
	if J.t(((not J.t(J.gp(_s261["this"], "headless"))) if J.t(_t829) else _t829)):
		J.mc(_s261["this"], "float", [0.5, 0.4, J.gp(_s261["g"], "line"), "#e8c8ff", 2.2])
	var _t830 = _s261["this"]
	var _t831 = _s261["gx"]
	J.sp(_t830, "_src", _t831)
	var _t832 = _s261["this"]
	var _t833 = (0.5 if J.t(J.gp(_s261["g"], "aoe")) else 0.9)
	J.sp(_t832, "_dl", _t833)
	var _t834 = _s261["this"]
	J.sp(_t834, "_ghost", v_k_483)
	var _t835 = _s261["this"]
	J.sp(_t835, "_vis", true)
	var _t836 = _s261["this"]
	var _t837 = (not (not J.t(J.gp(_s261["g"], "aoe"))))
	J.sp(_t836, "_aoe", _t837)
	for _t838 in J.iter(v_tg_490):
		v_m_492 = _t838
		var _t842 = J.mc(_s261["this"], "ghostType", [v_k_483, v_m_492])
		var _t843 = J.round(J.num(J.mul(J.gp(_s261["g"], "base"), (1.0 + (0.35 * J.sub(v_gq_487, 1.0))))))
		var _t841 = null
		if J.t(J.gp(_s261["g"], "aoe")):
			_t841 = null
		else:
			var _t840 = null
			if J.seq(J.typeof_(J.G.get("L")), "function"):
				var _t839 = J.G.get("L")
				_t840 = J.cl(_t839, null, [J.gp(_s261["g"], "line")])
			else:
				_t840 = J.gp(_s261["g"], "line")
			_t841 = _t840
		J.mc(_s261["this"], "hit", [v_m_492, _t842, _t843, 3.0, _t841, (not J.t(J.gp(_s261["g"], "aoe")))])
	var _t844 = _s261["this"]
	J.sp(_t844, "_ghost", null)
	var _t845 = _s261["this"]
	J.sp(_t845, "_src", null)
	var _t846 = _s261["this"]
	J.sp(_t846, "_dl", 0.0)
	var _t847 = _s261["this"]
	J.sp(_t847, "_vis", false)
	var _t848 = _s261["this"]
	J.sp(_t848, "_aoe", false)
	if J.t(J.gp(_s261["g"], "aoe")):
		J.mc(_s261["this"], "wakeGuard", [null])
		J.mc(_s261["this"], "expose", [J.gp(J.G.get("EXPO"), "aoe")])
		if (not J.t(J.gp(_s261["this"], "headless"))):
			J.mc(_s261["this"], "float", [0.5, 0.33, "全場都見到：冇人會話佢哋黐線", "#c9b8ff", 2.2])

func _f126(this_, a: Array, env):
	var v_g_496 = null
	v_g_496 = J.arg(a, 0)
	return J.seq(J.gp(v_g_496, "k"), "afu")

func _f125(this_, a: Array, env):
	var v_k_495 = null; var v_e_497 = null
	v_k_495 = J.arg(a, 0)
	var _t850 = null
	if J.seq(v_k_495, "afu"):
		var _t849 = J.gp(J.G.get("S"), "ghosts")
		_t850 = J.mc(J.G.get("GP"), "grow", [J.mc(_t849, "find", [Callable(self, "_f126").bind(env)])])
	else:
		_t850 = J.mc(J.G.get("GP"), "kindGrow", [v_k_495])
	return _t850

func _f128(this_, a: Array, env):
	var v_t_504 = null
	v_t_504 = J.arg(a, 0)
	var _t853 = J.gp(J.gp(env["n"], "d"), "weak")
	return J.mc(_t853, "includes", [v_t_504])

func _f129(this_, a: Array, env):
	var v_t_505 = null
	v_t_505 = J.arg(a, 0)
	var _t854 = J.gp(J.gp(env["n"], "d"), "immune")
	return (not J.t(J.mc(_t854, "includes", [v_t_505])))

func _f127(this_, a: Array, env):
	var v_k_500 = null; var v_g_502 = null; var v_ts_503 = null
	var _s275 = {"__p": env, "n": null}
	v_k_500 = J.arg(a, 0)
	_s275["n"] = J.arg(a, 1)
	v_g_502 = J.gp(J.G.get("SCARE_GHOSTS"), v_k_500)
	var _t851 = J.gp(v_g_502, "types")
	v_ts_503 = (_t851 if J.t(_t851) else [J.gp(v_g_502, "type")])
	var _t852 = (not J.t(_s275["n"]))
	if (_t852 if _t852 else (J.len(v_ts_503) < 2.0)):
		return J.gp(v_ts_503, 0.0)
	var _t855 = J.mc(v_ts_503, "find", [Callable(self, "_f128").bind(_s275)])
	var _t856 = (_t855 if J.t(_t855) else J.mc(v_ts_503, "find", [Callable(self, "_f129").bind(_s275)]))
	return (_t856 if J.t(_t856) else J.gp(v_ts_503, 0.0))

func _f131(this_, a: Array, env):
	var v_x_540 = null
	v_x_540 = J.arg(a, 0)
	var _t912 = J.gp(J.gp(v_x_540, "d"), "guard")
	var _t913 = ((not J.t(J.gp(v_x_540, "gone"))) if J.t(_t912) else _t912)
	return ((not J.t(J.gp(v_x_540, "out"))) if J.t(_t913) else _t913)

func _f132(this_, a: Array, env):
	var v_x_541 = null
	v_x_541 = J.arg(a, 0)
	return (not J.t(J.gp(J.gp(v_x_541, "d"), "guard")))

func _f133(this_, a: Array, env):
	return J.mc(env["this"], "bubble", [env["n"], env["line"], 2.2])

func _f134(this_, a: Array, env):
	var _t977 = env["this"]
	var _t978 = J.max_([J.gp(env["this"], "shake"), J.min_([0.7, J.div(env["pts"], 60.0)])])
	J.sp(_t977, "shake", _t978)

func _f135(this_, a: Array, env):
	return J.mc(env["this"], "bubble", [env["g"], J.gp(J.gp(J.gp(env["g"], "d"), "say"), "calmOther"), 2.0])

func _f136(this_, a: Array, env):
	var _t997 = env["n"]
	var _t998 = J.gp(env["n"], "scream")
	var _t999 = J.gp(env["n"], "scream")
	var _t1000 = J.max_([(_t999 if J.t(_t999) else 0.0), 1.1])
	J.sp(_t997, "scream", _t1000)
	var _t1001 = env["this"]
	var _t1002 = J.max_([J.gp(env["this"], "shake"), 0.5])
	J.sp(_t1001, "shake", _t1002)

func _f137(this_, a: Array, env):
	var _t1007 = env["this"]
	var _t1008 = J.max_([J.gp(env["this"], "shake"), 0.9])
	J.sp(_t1007, "shake", _t1008)

func _f138(this_, a: Array, env):
	var _t1024 = env["n"]
	var _t1023 = J.gp(J.gp(env["d"], "say"), "shout")
	return J.mc(env["this"], "bubble", [_t1024, (_t1023 if J.t(_t1023) else "哇啊啊啊——！"), 2.0])

func _f130(this_, a: Array, env):
	var v_type_509 = null; var v_base_510 = null; var v_tier_511 = null; var v_ghostLine_512 = null; var v_direct_513 = null; var v_grp_515 = null; var v_w_516 = null; var v_im_517 = null; var v_hab_518 = null; var v_sh_519 = null; var v_KS_520 = null; var v_m_521 = null; var v_rational_522 = null; var v_burst_523 = null; var v_before_524 = null; var v_combo_525 = null; var v_aoe_527 = null; var v_wits_528 = null; var v_seen_529 = null; var v_alone_530 = null; var v_mk_531 = null; var v_cap_533 = null; var v_oldPeak_534 = null; var v_gain_535 = null; var v_clean_536 = null; var v_tag_538 = null; var v_L_539 = null; var v_b_542 = null; var v_i_543 = null; var v_say_544 = null; var v_k_545 = null
	var _s278 = {"__p": env, "this": null, "n": null, "d": null, "g": null, "pts": null, "line": null}
	_s278["this"] = this_
	_s278["n"] = J.arg(a, 0)
	v_type_509 = J.arg(a, 1)
	v_base_510 = J.arg(a, 2)
	v_tier_511 = J.arg(a, 3)
	v_ghostLine_512 = J.arg(a, 4)
	v_direct_513 = J.arg(a, 5)
	_s278["d"] = J.gp(_s278["n"], "d")
	v_grp_515 = (not (not J.t(J.gp(_s278["this"], "_group"))))
	if J.t((J.gp(J.G.get("GROUP_IMMUNE"), J.gp(_s278["d"], "k")) if J.t(v_grp_515) else v_grp_515)):
		var _t858 = _s278["n"]
		var _t857 = J.gp(J.gp(J.G.get("GROUP_IMMUNE"), J.gp(_s278["d"], "k")), v_type_509)
		J.mc(_s278["this"], "bubble", [_t858, (_t857 if J.t(_t857) else J.gp(J.gp(J.G.get("GROUP_IMMUNE"), J.gp(_s278["d"], "k")), "light")), 2.4])
		J.mc(_s278["this"], "float", [J.gp(_s278["n"], "x"), J.sub(J.gp(_s278["n"], "y"), 0.2), "慣咗，唔怕", "#9ab"])
		if (not J.t(J.gp(_s278["this"], "headless"))):
			J.mc(_s278["this"], "react", [_s278["n"], ("sip" if J.t(J.gp(_s278["d"], "guard")) else "numb")])
		return null
	if J.t(J.gp(_s278["d"], "guard")):
		J.mc(_s278["this"], "bubble", [_s278["n"], J.gp(J.gp(_s278["d"], "say"), "immune"), 2.0])
		J.mc(_s278["this"], "react", [_s278["n"], "sip"])
		if J.t(((not J.t(J.gp(_s278["this"], "guardKarma"))) if J.t(v_direct_513) else v_direct_513)):
			var _t859 = _s278["this"]
			J.sp(_t859, "guardKarma", true)
			J.mc(_s278["this"], "addKarma", [_s278["d"], (-1.0), "嚇保安阿伯：他倒了一杯茶給你。"])
		return null
	var _t860 = J.gp(_s278["d"], "backfire")
	if J.t((J.gp(J.gp(_s278["d"], "backfire"), v_type_509) if J.t(_t860) else _t860)):
		var _t861 = _s278["this"]
		var _t862 = J.max_([0.0, J.sub(J.gp(_s278["this"], "kpi"), 15.0)])
		J.sp(_t861, "kpi", _t862)
		J.mc(_s278["this"], "bubble", [_s278["n"], J.gp(J.gp(_s278["d"], "backfire"), v_type_509), 2.4])
		J.mc(_s278["this"], "float", [J.gp(_s278["n"], "x"), J.sub(J.gp(_s278["n"], "y"), 0.2), "好評 -15", "#ff8a7a"])
		return null
	var _t863 = J.gp(_s278["d"], "weak")
	v_w_516 = J.mc(_t863, "includes", [v_type_509])
	var _t864 = J.gp(_s278["d"], "immune")
	v_im_517 = J.mc(_t864, "includes", [v_type_509])
	var _t865 = _s278["n"]
	var _t866 = J.gp(_s278["n"], "hab")
	var _t867 = (_t866 if J.t(_t866) else {})
	J.sp(_t865, "hab", _t867)
	var _t868 = J.gp(J.gp(_s278["n"], "hab"), v_type_509)
	v_hab_518 = (_t868 if J.t(_t868) else 0.0)
	var _t869 = J.gp(_s278["n"], "hab")
	var _t870 = J.add(v_hab_518, 1.0)
	J.sp(_t869, v_type_509, _t870)
	var _t871 = J.gp(_s278["n"], "shaken")
	v_sh_519 = J.cmp((_t871 if J.t(_t871) else 0.0), 0.0, ">")
	if J.t(v_im_517):
		var _t872 = _s278["this"]
		var _t873 = J.gp(_s278["this"], "known")
		var _t874 = (_t873 if J.t(_t873) else {})
		J.sp(_t872, "known", _t874)
		var _t875 = J.gp(_s278["this"], "known")
		var _t876 = J.gp(_s278["d"], "k")
		var _t877 = J.gp(J.gp(_s278["this"], "known"), J.gp(_s278["d"], "k"))
		var _t878 = (_t877 if J.t(_t877) else J.new_("Set", []))
		J.sp(_t875, _t876, _t878)
		J.mc(_t878, "add", [v_type_509])
		var _t879 = J.gp(_s278["d"], "imm")
		var _t880 = (J.gp(J.gp(_s278["d"], "imm"), v_type_509) if J.t(_t879) else _t879)
		v_L_539 = (_t880 if J.t(_t880) else J.gp(J.gp(_s278["d"], "say"), "immune"))
		J.mc(_s278["this"], "bubble", [_s278["n"], v_L_539, 2.4])
		var _t882 = J.gp(_s278["n"], "x")
		var _t883 = J.sub(J.gp(_s278["n"], "y"), 0.2)
		var _t881 = J.gp(J.G.get("FEAR_WORD"), v_type_509)
		J.mc(_s278["this"], "float", [_t882, _t883, (J.str((_t881 if J.t(_t881) else v_type_509)) + "？唔怕！"), "#9ab", 1.6])
		if (not J.t(J.gp(_s278["this"], "headless"))):
			var _t885 = _s278["n"]
			var _t884 = J.gp(_s278["this"], "_dl")
			J.mc(_s278["this"], "react", [_t885, "rational", {"delay": (_t884 if J.t(_t884) else 0.0)}])
		var _t886 = J.gp(_s278["this"], "_vis")
		var _t887 = ((not J.t(J.gp(_s278["this"], "_aoe"))) if J.t(_t886) else _t886)
		var _t888 = ((not J.t(v_grp_515)) if J.t(_t887) else _t887)
		if J.t((J.len(J.mc(_s278["this"], "witnesses", [_s278["n"]])) if J.t(_t888) else _t888)):
			J.mc(_s278["this"], "expose", [J.div(J.gp(J.G.get("EXPO"), "seen"), 2.0), _s278["n"]])
		return null
	var _t889 = _s278["this"]
	var _t890 = J.gp(_s278["this"], "known")
	var _t891 = (_t890 if J.t(_t890) else {})
	J.sp(_t889, "known", _t891)
	var _t892 = J.gp(_s278["this"], "known")
	var _t893 = J.gp(_s278["d"], "k")
	var _t894 = J.gp(J.gp(_s278["this"], "known"), J.gp(_s278["d"], "k"))
	var _t895 = (_t894 if J.t(_t894) else J.new_("Set", []))
	J.sp(_t892, _t893, _t895)
	v_KS_520 = _t895
	if (not J.t(J.mc(v_KS_520, "has", [v_type_509]))):
		J.mc(v_KS_520, "add", [v_type_509])
		var _t896 = (not J.t(J.gp(_s278["this"], "headless")))
		var _t897 = (J.seq(_s278["n"], J.gp(_s278["this"], "sel")) if _t896 else _t896)
		if J.t((v_w_516 if _t897 else _t897)):
			J.mc(_s278["this"], "renderTarget", [])
			J.mc(_s278["this"], "float", [J.gp(_s278["n"], "x"), J.sub(J.gp(_s278["n"], "y"), 0.34), ("發現：" + J.str(J.gp(_s278["d"], "name")) + "怕" + J.str(J.gp(J.G.get("FEAR_WORD"), v_type_509)) + "！"), "#ffb070", 1.8])
	var _t901 = J.mul(J.mul(J.mul(((J.gp(J.G.get("FEAR"), "weakSmall") if J.cmp(v_tier_511, 3.0, "<") else 2.0) if J.t(v_w_516) else (J.gp(J.G.get("FEAR_MID"), "small") if J.cmp(v_tier_511, 3.0, "<") else J.gp(J.G.get("FEAR_MID"), "big"))), J.max_([J.gp(J.G.get("FEAR"), "habMin"), pow(J.num(J.gp(J.G.get("FEAR"), "habMul")), J.num(v_hab_518))])), (J.gp(J.G.get("FEAR"), "gain") if J.cmp(v_tier_511, 3.0, "<") else 1.0)), (J.gp(J.G.get("FEAR"), "shakenMul") if J.t(v_sh_519) else 1.0))
	var _t900 = J.gp(J.G.get("FEAR"), "spread")
	var _t898 = J.gp(_s278["this"], "_nt")
	var _t899 = J.gp(_s278["this"], "_nt")
	v_m_521 = J.div(_t901, (1.0 + J.mul(_t900, J.max_([0.0, J.sub((_t899 if J.t(_t899) else 1.0), 1.0)]))))
	v_rational_522 = false
	v_burst_523 = false
	v_before_524 = J.gp(_s278["n"], "fear")
	if J.seq(v_tier_511, 3.0):
		var _t902 = J.cmp(v_before_524, 25.0, "<")
		if ((not J.t(v_sh_519)) if _t902 else _t902):
			var _t903 = J.mul(v_m_521, 0.45)
			v_m_521 = _t903
			v_rational_522 = true
		else:
			if J.cmp(v_before_524, 50.0, "<"):
				var _t904 = J.mul(v_m_521, 1.35)
				v_m_521 = _t904
			else:
				var _t905 = J.mul(v_m_521, J.gp(J.G.get("FEAR"), "burstMul"))
				v_m_521 = _t905
				v_burst_523 = true
	var _t908 = null
	if J.cmp(J.sub(J.gp(_s278["this"], "t"), ((-99.0) if J.leq(J.gp(_s278["n"], "comboT"), null) else J.gp(_s278["n"], "comboT"))), J.gp(J.G.get("FEAR"), "combo"), "<"):
		var _t906 = J.gp(_s278["n"], "combo")
		var _t907 = J.gp(_s278["n"], "combo")
		_t908 = J.min_([4.0, J.add((_t907 if J.t(_t907) else 0.0), 1.0)])
	else:
		_t908 = 0.0
	v_combo_525 = _t908
	var _t909 = (not J.t(v_im_517))
	if ((not J.t(v_rational_522)) if _t909 else _t909):
		var _t910 = J.mul(v_m_521, (1.0 + J.min_([J.gp(J.G.get("FEAR"), "comboMax"), J.mul(v_combo_525, J.gp(J.G.get("FEAR"), "comboStep"))])))
		v_m_521 = _t910
	var _t911 = J.gp(_s278["this"], "npcs")
	_s278["g"] = J.mc(_t911, "find", [Callable(self, "_f131").bind(_s278)])
	v_aoe_527 = (not (not J.t(J.gp(_s278["this"], "_aoe"))))
	v_wits_528 = ([] if J.t((v_aoe_527 if J.t(v_aoe_527) else v_grp_515)) else J.mc(_s278["this"], "witnesses", [_s278["n"]]))
	var _t914 = (not J.t(v_aoe_527))
	var _t915 = ((not J.t(v_grp_515)) if _t914 else _t914)
	var _t916 = (J.gp(_s278["this"], "_vis") if _t915 else _t915)
	v_seen_529 = ((J.len(v_wits_528) > 0.0) if J.t(_t916) else _t916)
	var _t918 = (not J.t(v_aoe_527))
	if J.t(_t918):
		var _t917 = J.mc(_s278["this"], "hearers", [_s278["n"]])
		_t918 = (not J.t(J.mc(_t917, "some", [Callable(self, "_f132").bind(_s278)])))
	v_alone_530 = _t918
	var _t919 = J.gp(_s278["n"], "mocked")
	var _t920 = J.gp(_s278["n"], "mocked")
	v_mk_531 = J.min_([4.0, (_t920 if J.t(_t920) else 0.0)])
	var _t921 = J.mul(v_m_521, (J.mul(J.mul(J.mul((J.gp(J.G.get("FEAR"), "aoeMul") if J.t(v_aoe_527) else 1.0), (J.gp(J.G.get("FEAR"), "groupMul") if J.t(v_grp_515) else (J.gp(J.G.get("FEAR"), "uneasyMul") if J.cmp(J.gp(_s278["n"], "uneasy"), 0.0, ">") else 1.0))), (J.gp(J.G.get("FEAR"), "seenMul") if J.t(v_seen_529) else 1.0)), (J.gp(J.G.get("FEAR"), "alone") if J.t(((not J.t(v_grp_515)) if J.t(v_alone_530) else v_alone_530)) else 1.0)) * (1.0 + (0.0 if J.t(v_grp_515) else J.mul(J.gp(J.G.get("FEAR"), "mockMul"), v_mk_531)))))
	v_m_521 = _t921
	if J.t(v_grp_515):
		var _t922 = _s278["n"]
		var _t923 = J.gp(J.G.get("FEAR"), "uneasy")
		J.sp(_t922, "uneasy", _t923)
	_s278["pts"] = J.round(J.num(J.mul(v_base_510, v_m_521)))
	v_cap_533 = (J.gp(J.G.get("FEAR"), "shakenCap") if J.t(v_sh_519) else (J.gp(J.G.get("FEAR"), "smallCap") if J.t(v_w_516) else J.gp(J.G.get("FEAR"), "plainCap")))
	if J.cmp(v_tier_511, 3.0, "<"):
		var _t924 = J.max_([0.0, J.round(J.num(J.min_([_s278["pts"], J.sub(v_cap_533, v_before_524)])))])
		_s278["pts"] = _t924
	var _t925 = _s278["n"]
	var _t926 = J.add(J.gp(_t925, "fear"), _s278["pts"])
	J.sp(_t925, "fear", _t926)
	var _t927 = _s278["n"]
	var _t928 = (1.0 if J.cmp(_s278["pts"], 0.0, ">") else 0.3)
	J.sp(_t927, "bounce", _t928)
	var _t929 = _s278["n"]
	var _t930 = (1.0 if J.cmp(_s278["pts"], 0.0, ">") else 0.0)
	J.sp(_t929, "barHit", _t930)
	var _t931 = J.cmp(_s278["pts"], 6.0, ">=")
	if ((not J.t(v_rational_522)) if _t931 else _t931):
		var _t932 = _s278["n"]
		J.sp(_t932, "combo", v_combo_525)
		var _t933 = _s278["n"]
		var _t934 = J.gp(_s278["this"], "t")
		J.sp(_t933, "comboT", _t934)
	else:
		var _t935 = _s278["n"]
		J.sp(_t935, "combo", 0.0)
	v_oldPeak_534 = J.min_([100.0, J.gp(_s278["n"], "peak")])
	var _t936 = _s278["n"]
	var _t937 = J.max_([J.gp(_s278["n"], "peak"), J.gp(_s278["n"], "fear")])
	J.sp(_t936, "peak", _t937)
	v_gain_535 = J.round(J.num(J.sub(J.min_([100.0, J.gp(_s278["n"], "peak")]), v_oldPeak_534)))
	var _t938 = (J.cmp(_s278["pts"], 20.0, ">=") if J.t(v_burst_523) else v_burst_523)
	var _t939 = ((not J.t(v_seen_529)) if J.t(_t938) else _t938)
	var _t940 = ((not J.t(v_aoe_527)) if J.t(_t939) else _t939)
	v_clean_536 = ((not J.t(v_grp_515)) if J.t(_t940) else _t940)
	if J.t(v_clean_536):
		var _t941 = J.add(v_gain_535, J.gp(J.G.get("FEAR"), "burstBonus"))
		v_gain_535 = _t941
	if J.t((J.cmp(v_combo_525, 1.0, ">=") if J.t(v_clean_536) else v_clean_536)):
		var _t942 = J.add(v_gain_535, J.mul(J.mul(J.gp(J.G.get("FEAR"), "comboPts"), 2.0), v_combo_525))
		v_gain_535 = _t942
	if J.t((J.cmp(v_mk_531, 2.0, ">=") if J.t(v_clean_536) else v_clean_536)):
		v_b_542 = J.mul(J.gp(J.G.get("FEAR"), "noBelieve"), v_mk_531)
		var _t943 = J.add(v_gain_535, v_b_542)
		v_gain_535 = _t943
		J.mc(_s278["this"], "float", [J.gp(_s278["n"], "x"), J.sub(J.gp(_s278["n"], "y"), 0.34), ("無人信佢！+" + J.str(v_b_542)), "#d08cff", 2.0])
	var _t944 = _s278["this"]
	var _t945 = J.add(J.gp(_t944, "kpi"), v_gain_535)
	J.sp(_t944, "kpi", _t945)
	var _t946 = _s278["this"]
	J.sp(_t946, "_hab", v_hab_518)
	if (not J.seq(J.typeof_(J.G.get("ScareX")), "undefined")):
		var _t949 = _s278["this"]
		var _t950 = _s278["n"]
		var _t948 = _s278["pts"]
		var _t947 = J.gp(_s278["this"], "_ghost")
		J.mc(J.G.get("ScareX"), "onHit", [_t949, _t950, {"type": v_type_509, "pts": _t948, "gain": v_gain_535, "clean": v_clean_536, "mk": v_mk_531, "alone": v_alone_530, "seen": v_seen_529, "burst": v_burst_523, "tier": v_tier_511, "ghost": (_t947 if J.t(_t947) else "afu")}])
	if J.t(((not J.t(J.gp(_s278["this"], "_aoe"))) if J.t(v_rational_522) else v_rational_522)):
		J.mc(_s278["this"], "expose", [J.gp(J.G.get("EXPO"), "blatant"), _s278["n"]])
	var _t951 = J.gp(_s278["d"], "daoshi")
	if J.t((J.cmp(_s278["pts"], 0.0, ">") if J.t(_t951) else _t951)):
		var _t952 = _s278["n"]
		var _t953 = J.gp(_s278["n"], "prog")
		var _t954 = J.gp(_s278["n"], "prog")
		var _t955 = J.max_([0.0, J.sub((_t954 if J.t(_t954) else 0.0), (J.div(_s278["pts"], 100.0) * 0.5))])
		J.sp(_t952, "prog", _t955)
		if (not J.t(J.gp(_s278["this"], "headless"))):
			J.mc(_s278["this"], "float", [J.gp(_s278["n"], "x"), J.sub(J.gp(_s278["n"], "y"), 0.34), "做法被打斷！", "#ffd36a", 1.4])
	if (not J.t(v_grp_515)):
		J.mc(_s278["this"], "perceive", [_s278["n"], _s278["pts"], v_rational_522, v_seen_529, v_wits_528, v_aoe_527, v_alone_530])
	var _t965 = null
	if J.t(v_rational_522):
		var _t956 = J.G.get("pick")
		_t965 = J.cl(_t956, null, [J.gp(J.gp(_s278["d"], "say"), "rational")])
	else:
		var _t959 = v_w_516
		if J.t(_t959):
			var _t957 = J.seq(v_type_509, "phone")
			var _t958 = (_t957 if _t957 else J.seq(v_type_509, "paper"))
			_t959 = (_t958 if _t958 else J.seq(v_tier_511, 3.0))
		var _t964 = null
		if J.t(_t959):
			_t964 = J.gp(J.gp(_s278["d"], "say"), "weak")
		else:
			var _t963 = null
			if J.cmp(J.gp(_s278["n"], "fear"), 50.0, ">="):
				var _t960 = J.G.get("pick")
				_t963 = J.cl(_t960, null, [J.gp(J.gp(_s278["d"], "say"), "hit")])
			else:
				var _t962 = null
				if J.cmp(_s278["pts"], 0.0, ">"):
					var _t961 = J.G.get("pick")
					_t962 = J.cl(_t961, null, [J.gp(J.gp(_s278["d"], "say"), "prime")])
				else:
					_t962 = "（習慣了）"
				_t963 = _t962
			_t964 = _t963
		_t965 = _t964
	_s278["line"] = _t965
	if J.t(((not J.t(v_rational_522)) if J.t(v_ghostLine_512) else v_ghostLine_512)):
		J.mc(_s278["this"], "bubble", [_s278["n"], v_ghostLine_512, 1.2, true])
	if J.t(J.gp(_s278["this"], "headless")):
		J.mc(_s278["this"], "bubble", [_s278["n"], _s278["line"], 2.2])
	else:
		var _t967 = Callable(self, "_f133").bind(_s278)
		var _t966 = J.gp(_s278["this"], "_dl")
		J.F_setTimeout([_t967, J.mul((_t966 if J.t(_t966) else 0.0), 1000.0)])
	var _t973 = null
	if J.t(v_seen_529):
		_t973 = "　穿崩！"
	else:
		var _t968 = (J.cmp(_s278["pts"], 20.0, ">=") if J.t(v_burst_523) else v_burst_523)
		var _t972 = null
		if J.t((v_aoe_527 if J.t(_t968) else _t968)):
			_t972 = "　（全場都見到）"
		else:
			var _t971 = null
			if J.t((J.cmp(_s278["pts"], 20.0, ">=") if J.t(v_burst_523) else v_burst_523)):
				_t971 = "　爆點！"
			else:
				var _t970 = null
				if J.t(v_rational_522):
					_t970 = "　還沒鋪墊"
				else:
					var _t969 = J.cmp(v_tier_511, 3.0, "<")
					_t970 = ("　小動靜不夠，出大招！" if (J.cmp(v_before_524, v_cap_533, ">=") if _t969 else _t969) else ("　有點習慣了" if J.cmp(v_hab_518, 2.0, ">=") else ("　怕！" if J.t(v_w_516) else ("　不怕" if J.t(v_im_517) else ("　餘悸未消" if J.t(v_sh_519) else "")))))
				_t971 = _t970
			_t972 = _t971
		_t973 = _t972
	v_tag_538 = _t973
	J.mc(_s278["this"], "float", [J.gp(_s278["n"], "x"), J.sub(J.gp(_s278["n"], "y"), 0.2), ((J.add("恐懼 +", _s278["pts"]) if J.cmp(_s278["pts"], 0.0, ">") else "沒反應") + J.str(v_tag_538)), ("#ff9a5a" if J.t(v_burst_523) else ("#ffb070" if J.t(v_w_516) else ("#ffe08a" if J.cmp(v_gain_535, 0.0, ">") else "#9ab")))])
	var _t974 = J.cmp(v_combo_525, 1.0, ">=")
	var _t975 = (J.cmp(_s278["pts"], 6.0, ">=") if _t974 else _t974)
	if ((not J.t(v_rational_522)) if _t975 else _t975):
		J.mc(_s278["this"], "float", [J.gp(_s278["n"], "x"), J.sub(J.gp(_s278["n"], "y"), 0.27), ("連擊 ×" + J.str(J.add(v_combo_525, 1.0))), "#ff7ad0", 1.4])
	var _t976 = (not J.t(J.gp(_s278["this"], "headless")))
	if (J.cmp(_s278["pts"], 12.0, ">=") if _t976 else _t976):
		var _t980 = Callable(self, "_f134").bind(_s278)
		var _t979 = J.gp(_s278["this"], "_dl")
		J.F_setTimeout([_t980, J.mul((_t979 if J.t(_t979) else 0.0), 1000.0)])
	var _t981 = (not J.t(J.gp(_s278["this"], "headless")))
	if (J.cmp(J.gp(_s278["n"], "fear"), 25.0, ">=") if _t981 else _t981):
		v_i_543 = 0.0
		while true:
			if not J.cmp(v_i_543, 3.0, "<"): break
			var _t982 = J.gp(_s278["this"], "parts")
			var _t984 = J.add(J.gp(_s278["n"], "x"), ((randf() - 0.5) * 0.05))
			var _t985 = J.sub(J.gp(_s278["n"], "y"), 0.17)
			var _t986 = ((randf() - 0.5) * 0.08)
			var _t987 = (-0.1)
			var _t983 = J.gp(_s278["this"], "_dl")
			J.mc(_t982, "push", [{"kind": "sweat", "x": _t984, "y": _t985, "vx": _t986, "vy": _t987, "g": 0.5, "life": 0.8, "delay": (_t983 if J.t(_t983) else 0.0)}])
			v_i_543 = J.num(v_i_543) + 1.0
	var _t988 = (J.mc(_s278["this"], "sameRoom", [_s278["g"], _s278["n"]]) if J.t(_s278["g"]) else _s278["g"])
	var _t989 = ((J.hypot_([J.sub(J.gp(_s278["g"], "x"), J.gp(_s278["n"], "x")), J.sub(J.gp(_s278["g"], "y"), J.gp(_s278["n"], "y"))]) < 0.24) if J.t(_t988) else _t988)
	if J.t((J.cmp(_s278["pts"], 15.0, ">") if J.t(_t989) else _t989)):
		var _t990 = _s278["n"]
		var _t991 = J.max_([0.0, J.sub(J.gp(_s278["n"], "fear"), J.gp(J.G.get("FEAR"), "guardCalm"))])
		J.sp(_t990, "fear", _t991)
		v_say_544 = Callable(self, "_f135").bind(_s278)
		if J.t(J.gp(_s278["this"], "headless")):
			J.cl(v_say_544, null, [])
		else:
			var _t992 = J.gp(_s278["this"], "_dl")
			J.F_setTimeout([v_say_544, (600.0 + J.mul((_t992 if J.t(_t992) else 0.0), 1000.0))])
			var _t994 = _s278["g"]
			var _t993 = J.gp(_s278["this"], "_dl")
			J.mc(_s278["this"], "react", [_t994, "sip", {"delay": J.add(0.6, (_t993 if J.t(_t993) else 0.0)), "dur": 2.8}])
		J.mc(_s278["this"], "float", [J.gp(_s278["g"], "x"), J.sub(J.gp(_s278["g"], "y"), 0.22), "阿伯在旁邊壯膽", "#9ad"])
	if (not J.t(J.gp(_s278["this"], "headless"))):
		var _t995 = J.cmp(J.gp(_s278["n"], "fear"), 100.0, ">=")
		v_k_545 = ("burst" if J.t((_t995 if _t995 else (J.cmp(_s278["pts"], 20.0, ">=") if J.t(v_burst_523) else v_burst_523))) else ("numb" if J.t((v_im_517 if J.t(v_im_517) else J.cmp(_s278["pts"], 0.0, "<="))) else ("rational" if J.t(v_rational_522) else ("startle" if J.seq(v_tier_511, 3.0) else ("weakjump" if J.t(v_w_516) else ("startle" if J.cmp(J.gp(_s278["n"], "fear"), 50.0, ">=") else "flinch"))))))
		var _t996 = (J.cmp(_s278["pts"], 0.0, ">") if J.t(v_w_516) else v_w_516)
		if J.t(((not J.t(v_rational_522)) if J.t(_t996) else _t996)):
			var _t1004 = Callable(self, "_f136").bind(_s278)
			var _t1003 = J.gp(_s278["this"], "_dl")
			J.F_setTimeout([_t1004, J.mul((_t1003 if J.t(_t1003) else 0.0), 1000.0)])
		var _t1006 = _s278["n"]
		var _t1005 = J.gp(_s278["this"], "_dl")
		J.mc(_s278["this"], "react", [_t1006, v_k_545, {"delay": (_t1005 if J.t(_t1005) else 0.0), "src": J.gp(_s278["this"], "_src"), "big": J.seq(v_tier_511, 3.0)}])
		if J.seq(v_k_545, "burst"):
			var _t1010 = Callable(self, "_f137").bind(_s278)
			var _t1009 = J.gp(_s278["this"], "_dl")
			J.F_setTimeout([_t1010, J.mul((_t1009 if J.t(_t1009) else 0.0), 1000.0)])
	var _t1011 = J.cmp(J.gp(_s278["n"], "fear"), 100.0, ">=")
	if ((not J.t(J.gp(_s278["n"], "fleeing"))) if _t1011 else _t1011):
		var _t1012 = _s278["n"]
		J.sp(_t1012, "fleeing", true)
		var _t1013 = _s278["this"]
		var _t1014 = J.add(J.gp(_t1013, "kpi"), 120.0)
		J.sp(_t1013, "kpi", _t1014)
		J.mc(_s278["this"], "float", [J.gp(_s278["n"], "x"), J.sub(J.gp(_s278["n"], "y"), 0.3), "嚇跑了！+120", "#ff6a5a", 2.0])
		J.mc(_s278["this"], "addKarma", [_s278["d"], J.gp(_s278["d"], "karma"), J.gp(J.gp(_s278["d"], "say"), "flee")])
		if (not J.t(J.gp(_s278["this"], "headless"))):
			J.mc(J.G.get("Sound"), "play", ["heartbeat"])
			var _t1015 = _s278["this"]
			J.sp(_t1015, "shake", 0.6)
			var _t1016 = _s278["n"]
			var _t1017 = J.gp(_s278["this"], "t")
			J.sp(_t1016, "fleeT", _t1017)
			var _t1018 = _s278["n"]
			var _t1019 = J.gp(_s278["this"], "_dl")
			var _t1020 = J.add((_t1019 if J.t(_t1019) else 0.0), 0.4)
			J.sp(_t1018, "fleeHold", _t1020)
			var _t1021 = _s278["n"]
			var _t1022 = [[J.gp(_s278["this"], "t"), J.gp(_s278["n"], "x"), J.gp(_s278["n"], "y")]]
			J.sp(_t1021, "trail", _t1022)
			J.F_setTimeout([Callable(self, "_f138").bind(_s278), 1200.0])

func _f139(this_, a: Array, env):
	var v_n_548 = null
	v_n_548 = J.arg(a, 0)
	return (J.mc(this_, "rng", [v_n_548]) if (not J.leq(J.gp(v_n_548, "_seed"), null)) else randf())

func _f140(this_, a: Array, env):
	var v_m_551 = null; var v_a_552 = null; var v_p_553 = null
	v_m_551 = J.arg(a, 0)
	v_a_552 = J.gp(v_m_551, "act")
	var _t1025 = J.seq(v_a_552, "work")
	var _t1026 = (_t1025 if _t1025 else J.seq(v_a_552, "mop"))
	var _t1027 = (_t1026 if _t1026 else J.seq(v_a_552, "doze"))
	var _t1028 = (_t1027 if _t1027 else J.seq(v_a_552, "pack"))
	var _t1029 = (_t1028 if _t1028 else J.seq(v_a_552, "read"))
	var _t1030 = (_t1029 if _t1029 else J.seq(v_a_552, "notes"))
	if (_t1030 if _t1030 else J.seq(v_a_552, "present")):
		return true
	v_p_553 = J.gp(J.gp(v_m_551, "d"), "post")
	var _t1031 = (J.seq(v_a_552, J.gp(v_p_553, 2.0)) if J.t(v_p_553) else v_p_553)
	return (not (not J.t(((J.hypot_([J.sub(J.gp(v_m_551, "x"), J.gp(v_p_553, 0.0)), J.sub(J.gp(v_m_551, "y"), J.gp(v_p_553, 1.0))]) < 0.015) if J.t(_t1031) else _t1031))))

func _f141(this_, a: Array, env):
	var v_m_556 = null
	v_m_556 = J.arg(a, 0)
	var _t1032 = J.gp(v_m_556, "gone")
	var _t1033 = (_t1032 if J.t(_t1032) else J.gp(v_m_556, "out"))
	if J.t((_t1033 if J.t(_t1033) else J.gp(v_m_556, "fleeing"))):
		return false
	if J.t(J.gp(J.gp(v_m_556, "d"), "guard")):
		return (not J.seq(J.gp(v_m_556, "act"), "doze"))
	if J.t(J.gp(J.gp(v_m_556, "d"), "influencer")):
		return true
	var _t1035 = J.seq(J.gp(v_m_556, "act"), "walk")
	if not J.t(_t1035):
		var _t1034 = J.gp(v_m_556, "lookUp")
		_t1035 = J.cmp((_t1034 if J.t(_t1034) else 0.0), 0.0, ">")
	var _t1036 = (_t1035 if _t1035 else J.cmp(J.gp(v_m_556, "fear"), 25.0, ">="))
	return (_t1036 if _t1036 else (not J.t(J.mc(this_, "headsDown", [v_m_556]))))

func _f142(this_, a: Array, env):
	var v_m_559 = null; var v_n_560 = null; var v_dx_561 = null
	v_m_559 = J.arg(a, 0)
	v_n_560 = J.arg(a, 1)
	var _t1037 = J.seq(v_m_559, v_n_560)
	var _t1038 = (_t1037 if _t1037 else (not J.t(J.mc(this_, "watching", [v_m_559]))))
	if (_t1038 if _t1038 else (not J.t(J.mc(this_, "sameRoom", [v_m_559, v_n_560])))):
		return false
	v_dx_561 = J.sub(J.gp(v_n_560, "x"), J.gp(v_m_559, "x"))
	if J.cmp(J.hypot_([v_dx_561, (J.sub(J.gp(v_n_560, "y"), J.gp(v_m_559, "y")) * 1.3)]), J.G.get("SEE_DIST"), ">"):
		return false
	var _t1039 = J.seq(J.gp(v_m_559, "act"), "walk")
	return ((J.mul(v_dx_561, J.gp(v_m_559, "dir")) >= (-0.03)) if J.t((_t1039 if _t1039 else J.gp(J.gp(v_m_559, "d"), "guard"))) else true)

func _f144(this_, a: Array, env):
	var v_m_565 = null
	v_m_565 = J.arg(a, 0)
	return J.mc(env["this"], "sees", [v_m_565, env["n"]])

func _f143(this_, a: Array, env):
	var _s311 = {"__p": env, "this": null, "n": null}
	_s311["this"] = this_
	_s311["n"] = J.arg(a, 0)
	var _t1040 = J.gp(_s311["this"], "npcs")
	return J.mc(_t1040, "filter", [Callable(self, "_f144").bind(_s311)])

func _f146(this_, a: Array, env):
	var v_m_569 = null
	v_m_569 = J.arg(a, 0)
	var _t1042 = (not J.seq(v_m_569, env["n"]))
	var _t1043 = ((not J.t(J.gp(v_m_569, "gone"))) if _t1042 else _t1042)
	var _t1044 = ((not J.t(J.gp(v_m_569, "out"))) if _t1043 else _t1043)
	var _t1045 = ((not J.t(J.gp(v_m_569, "fleeing"))) if _t1044 else _t1044)
	var _t1046 = (J.mc(env["this"], "sameRoom", [v_m_569, env["n"]]) if _t1045 else _t1045)
	return ((J.hypot_([J.sub(J.gp(v_m_569, "x"), J.gp(env["n"], "x")), J.sub(J.gp(v_m_569, "y"), J.gp(env["n"], "y"))]) < 0.75) if J.t(_t1046) else _t1046)

func _f145(this_, a: Array, env):
	var _s313 = {"__p": env, "this": null, "n": null}
	_s313["this"] = this_
	_s313["n"] = J.arg(a, 0)
	var _t1041 = J.gp(_s313["this"], "npcs")
	return J.mc(_t1041, "filter", [Callable(self, "_f146").bind(_s313)])

func _f148(this_, a: Array, env):
	var v_x_574 = null
	v_x_574 = J.arg(a, 0)
	var _t1048 = J.gp(J.gp(v_x_574, "d"), "guard")
	var _t1049 = ((not J.t(J.gp(v_x_574, "gone"))) if J.t(_t1048) else _t1048)
	return ((not J.t(J.gp(v_x_574, "out"))) if J.t(_t1049) else _t1049)

func _f147(this_, a: Array, env):
	var v_n_572 = null; var v_g_573 = null
	v_n_572 = J.arg(a, 0)
	var _t1047 = J.gp(this_, "npcs")
	v_g_573 = J.mc(_t1047, "find", [Callable(self, "_f148").bind(env)])
	if (not J.t(v_g_573)):
		return null
	if J.seq(J.gp(v_g_573, "act"), "doze"):
		J.mc(this_, "bubble", [v_g_573, "（醒咗）咩事？", 2.0])
	if J.t(v_n_572):
		J.sp(v_g_573, "tour", null)
		var _t1050 = {"x": J.max_([0.1, J.min_([J.sub((J.gp(J.G.get("OFFMAP"), "WW") if J.t(J.gp(J.gp(this_, "site"), "pano")) else 1.0), 0.1), J.add(J.gp(v_n_572, "x"), ((-0.12) if J.cmp(J.gp(v_n_572, "x"), J.gp(v_g_573, "x"), ">") else 0.12))])]), "y": J.max_([0.66, J.min_([0.93, J.add(J.gp(v_n_572, "y"), 0.02)])]), "wait": 6.0, "act": "look", "arrived": false, "path": null, "pi": 0.0}
		J.sp(v_g_573, "step", _t1050)
		J.sp(v_g_573, "next", null)
	else:
		if J.seq(J.gp(v_g_573, "act"), "doze"):
			J.sp(v_g_573, "step", null)

func _f151(this_, a: Array, env):
	var _t1051 = J.gp(env["__p"]["this"], "active")
	return (J.cl(env["f"], null, []) if J.t(_t1051) else _t1051)

func _f150(this_, a: Array, env):
	var v_s_587 = null
	var _s320 = {"__p": env, "f": null}
	_s320["f"] = J.arg(a, 0)
	v_s_587 = J.arg(a, 1)
	if J.t(J.gp(_s320["__p"]["this"], "headless")):
		J.cl(_s320["f"], null, [])
	else:
		var _t1053 = Callable(self, "_f151").bind(_s320)
		var _t1052 = J.gp(_s320["__p"]["this"], "_dl")
		J.F_setTimeout([_t1053, J.mul(J.add((_t1052 if J.t(_t1052) else 0.0), (v_s_587 if J.t(v_s_587) else 0.0)), 1000.0)])

func _f152(this_, a: Array, env):
	var v_w_589 = null
	v_w_589 = J.arg(a, 0)
	return J.gp(J.gp(v_w_589, "d"), "influencer")

func _f153(this_, a: Array, env):
	var v_w_590 = null
	v_w_590 = J.arg(a, 0)
	return J.gp(J.gp(v_w_590, "d"), "name")

func _f154(this_, a: Array, env):
	var _t1072 = env["w"]
	var _t1071 = J.G.get("pick")
	return J.mc(env["__p"]["this"], "bubble", [_t1072, J.cl(_t1071, null, [J.G.get("WIT_SAY")]), 2.0])

func _f155(this_, a: Array, env):
	var v_m_592 = null
	v_m_592 = J.arg(a, 0)
	var _t1079 = (not J.t(J.gp(J.gp(v_m_592, "d"), "guard")))
	return ((not J.cmp(J.gp(v_m_592, "fear"), 50.0, ">=")) if _t1079 else _t1079)

func _f156(this_, a: Array, env):
	var v_a_593 = null; var v_b_594 = null
	v_a_593 = J.arg(a, 0)
	v_b_594 = J.arg(a, 1)
	return (J.hypot_([J.sub(J.gp(v_a_593, "x"), J.gp(env["n"], "x")), J.sub(J.gp(v_a_593, "y"), J.gp(env["n"], "y"))]) - J.hypot_([J.sub(J.gp(v_b_594, "x"), J.gp(env["n"], "x")), J.sub(J.gp(v_b_594, "y"), J.gp(env["n"], "y"))]))

func _f158(this_, a: Array, env):
	var v_L_597 = null
	v_L_597 = J.gp(J.G.get("MOCK_SAY"), J.gp(J.gp(env["m"], "d"), "k"))
	var _t1095 = env["m"]
	var _t1094 = null
	if J.t(v_L_597):
		var _t1093 = J.G.get("pick")
		_t1094 = J.cl(_t1093, null, [v_L_597])
	else:
		_t1094 = "你又發乜神經？"
	J.mc(env["__p"]["this"], "bubble", [_t1095, _t1094, 2.4])
	var _t1096 = J.gp(env["m"], "mis")
	if J.t((J.seq(J.gp(J.gp(env["m"], "d"), "k"), "mis") if J.t(_t1096) else _t1096)):
		J.S_Object_("assign", [J.gp(env["m"], "mis"), {"act": "roll", "at": 0.0, "dur": 1.8}])
	var _t1097 = env["m"]
	var _t1098 = (1.0 if J.cmp(J.gp(env["__p"]["n"], "x"), J.gp(env["m"], "x"), ">") else (-1.0))
	J.sp(_t1097, "dir", _t1098)

func _f157(this_, a: Array, env):
	var v_i_596 = null
	var _s333 = {"__p": env, "m": null}
	_s333["m"] = J.arg(a, 0)
	v_i_596 = J.arg(a, 1)
	var _t1092 = _s333["__p"]["later"]
	return J.cl(_t1092, null, [Callable(self, "_f158").bind(_s333), (1.0 + J.mul(v_i_596, 0.7))])

func _f159(this_, a: Array, env):
	if (not J.t(J.gp(env["n"], "fleeing"))):
		var _t1101 = env["n"]
		var _t1100 = J.G.get("pick")
		J.mc(env["this"], "bubble", [_t1101, J.cl(_t1100, null, [J.G.get("PARA_SAY")]), 2.2])

func _f149(this_, a: Array, env):
	var v_pts_578 = null; var v_rational_579 = null; var v_seen_580 = null; var v_wits_581 = null; var v_aoe_582 = null; var v_alone_583 = null; var v_mk_585 = null; var v_w0_588 = null
	var _s319 = {"__p": env, "this": null, "n": null, "later": null}
	_s319["this"] = this_
	_s319["n"] = J.arg(a, 0)
	v_pts_578 = J.arg(a, 1)
	v_rational_579 = J.arg(a, 2)
	v_seen_580 = J.arg(a, 3)
	v_wits_581 = J.arg(a, 4)
	v_aoe_582 = J.arg(a, 5)
	v_alone_583 = J.arg(a, 6)
	_s319["later"] = Callable(self, "_f150").bind(_s319)
	if J.t(v_aoe_582):
		var _t1054 = _s319["n"]
		J.sp(_t1054, "mocked", 0.0)
		return null
	if J.t(v_seen_580):
		var _t1055 = _s319["n"]
		J.sp(_t1055, "mocked", 0.0)
		var _t1056 = _s319["this"]
		var _t1057 = J.max_([0.0, J.sub(J.gp(_s319["this"], "kpi"), J.gp(J.G.get("FEAR"), "seenPen"))])
		J.sp(_t1056, "kpi", _t1057)
		v_w0_588 = J.gp(v_wits_581, 0.0)
		if J.t(J.gp(_s319["this"], "night")):
			var _t1058 = J.gp(_s319["this"], "night")
			J.sp(_t1058, "seen", J.num(J.gp(_t1058, "seen")) + 1.0)
			if J.t(J.mc(v_wits_581, "some", [Callable(self, "_f152").bind(_s319)])):
				var _t1059 = J.gp(_s319["this"], "night")
				J.sp(_t1059, "filmed", J.num(J.gp(_t1059, "filmed")) + 1.0)
		var _t1061 = J.add(J.gp(J.G.get("EXPO"), "seen"), J.mul(J.gp(J.G.get("EXPO"), "perWit"), (J.len(v_wits_581) - 1.0)))
		var _t1060 = J.gp(_s319["this"], "_hab")
		J.mc(_s319["this"], "expose", [J.add(_t1061, (J.gp(J.G.get("EXPO"), "repeat") if J.cmp((_t1060 if J.t(_t1060) else 0.0), 1.0, ">=") else 0.0)), _s319["n"]])
		var _t1063 = J.gp(_s319["n"], "x")
		var _t1064 = J.sub(J.gp(_s319["n"], "y"), 0.3)
		var _t1062 = J.mc(v_wits_581, "map", [Callable(self, "_f153").bind(_s319)])
		J.mc(_s319["this"], "float", [_t1063, _t1064, ("穿崩！" + J.str(J.mc(_t1062, "join", ["、"])) + "望到 −" + J.str(J.gp(J.G.get("FEAR"), "seenPen"))), "#ff8a7a", 2.0])
		for _t1065 in J.iter(v_wits_581):
			var _s327 = {"__p": _s319, "w": null}
			_s327["w"] = _t1065
			if J.t(J.gp(J.gp(_s327["w"], "d"), "guard")):
				continue
			var _t1066 = _s327["w"]
			var _t1067 = J.max_([J.gp(_s327["w"], "fear"), J.min_([99.0, J.add(J.gp(_s327["w"], "fear"), J.gp(J.G.get("FEAR"), "witFear"))])])
			J.sp(_t1066, "fear", _t1067)
			var _t1068 = _s327["w"]
			var _t1069 = J.max_([J.gp(_s327["w"], "peak"), J.gp(_s327["w"], "fear")])
			J.sp(_t1068, "peak", _t1069)
			var _t1070 = _s327["__p"]["later"]
			J.cl(_t1070, null, [Callable(self, "_f154").bind(_s327), 0.5])
			if (not J.t(J.gp(_s327["__p"]["this"], "headless"))):
				var _t1074 = _s327["w"]
				var _t1073 = J.gp(_s327["__p"]["this"], "_dl")
				J.mc(_s327["__p"]["this"], "react", [_t1074, "startle", {"delay": J.add((_t1073 if J.t(_t1073) else 0.0), 0.4), "src": J.gp(_s327["__p"]["n"], "x")}])
		if J.t(v_w0_588):
			J.mc(_s319["this"], "wakeGuard", [_s319["n"]])
		return null
	var _t1075 = J.cmp(v_pts_578, 8.0, "<")
	var _t1076 = (_t1075 if _t1075 else v_rational_579)
	var _t1077 = (_t1076 if J.t(_t1076) else J.gp(_s319["n"], "fleeing"))
	if J.t((_t1077 if J.t(_t1077) else J.cmp(J.gp(_s319["n"], "fear"), 100.0, ">="))):
		return null
	var _t1078 = J.mc(_s319["this"], "hearers", [_s319["n"]])
	var _t1080 = J.mc(_t1078, "filter", [Callable(self, "_f155").bind(_s319)])
	var _t1081 = J.mc(_t1080, "sort", [Callable(self, "_f156").bind(_s319)])
	v_mk_585 = J.mc(_t1081, "slice", [0.0, 2.0])
	if (not J.t(J.len(v_mk_585))):
		if J.t(v_alone_583):
			J.mc(_s319["this"], "float", [J.gp(_s319["n"], "x"), J.sub(J.gp(_s319["n"], "y"), 0.27), "冇人喺度 ×1.2", "#9fe0c0", 1.4])
		return null
	var _t1082 = _s319["n"]
	var _t1083 = J.gp(_s319["n"], "mocked")
	var _t1084 = J.gp(_s319["n"], "mocked")
	var _t1085 = J.min_([5.0, J.add((_t1084 if J.t(_t1084) else 0.0), 1.0)])
	J.sp(_t1082, "mocked", _t1085)
	var _t1086 = _s319["n"]
	var _t1087 = J.max_([J.gp(_s319["n"], "fear"), J.min_([99.0, J.add(J.gp(_s319["n"], "fear"), J.gp(J.G.get("FEAR"), "mockFear"))])])
	J.sp(_t1086, "fear", _t1087)
	var _t1088 = _s319["n"]
	var _t1089 = J.max_([J.gp(_s319["n"], "peak"), J.gp(_s319["n"], "fear")])
	J.sp(_t1088, "peak", _t1089)
	var _t1090 = _s319["this"]
	var _t1091 = J.add(J.gp(_t1090, "kpi"), J.gp(J.G.get("FEAR"), "mockPts"))
	J.sp(_t1090, "kpi", _t1091)
	J.mc(v_mk_585, "forEach", [Callable(self, "_f157").bind(_s319)])
	if J.cmp(J.gp(_s319["n"], "mocked"), 2.0, ">="):
		var _t1099 = _s319["later"]
		J.cl(_t1099, null, [Callable(self, "_f159").bind(_s319), 2.6])

func _f161(this_, a: Array, env):
	var v_x_604 = null
	v_x_604 = J.arg(a, 0)
	var _t1119 = (not J.t(J.gp(v_x_604, "gone")))
	var _t1120 = ((not J.t(J.gp(v_x_604, "out"))) if _t1119 else _t1119)
	var _t1121 = ((not J.t(J.gp(v_x_604, "fleeing"))) if _t1120 else _t1120)
	var _t1122 = ((not J.t(J.gp(J.gp(v_x_604, "d"), "guard"))) if _t1121 else _t1121)
	return ((not J.t(J.gp(J.gp(v_x_604, "d"), "daoshi"))) if _t1122 else _t1122)

func _f162(this_, a: Array, env):
	var v_x_605 = null
	v_x_605 = J.arg(a, 0)
	var _t1124 = J.gp(J.gp(v_x_605, "d"), "guard")
	return ((not J.t(J.gp(v_x_605, "gone"))) if J.t(_t1124) else _t1124)

func _f163(this_, a: Array, env):
	var v_x_607 = null
	v_x_607 = J.arg(a, 0)
	var _t1129 = J.seq(J.gp(J.gp(v_x_607, "d"), "k"), "mis")
	var _t1130 = (_t1129 if _t1129 else J.seq(J.gp(J.gp(v_x_607, "d"), "k"), "boss"))
	var _t1131 = ((not J.t(J.gp(v_x_607, "gone"))) if _t1130 else _t1130)
	var _t1132 = ((not J.t(J.gp(v_x_607, "out"))) if _t1131 else _t1131)
	return ((not J.t(J.gp(v_x_607, "fleeing"))) if _t1132 else _t1132)

func _f164(this_, a: Array, env):
	var v_x_608 = null
	v_x_608 = J.arg(a, 0)
	var _t1134 = (not J.t(J.gp(v_x_608, "gone")))
	var _t1135 = ((not J.t(J.gp(v_x_608, "out"))) if _t1134 else _t1134)
	var _t1136 = ((not J.t(J.gp(v_x_608, "fleeing"))) if _t1135 else _t1135)
	return ((not J.t(J.gp(J.gp(v_x_608, "d"), "guard"))) if _t1136 else _t1136)

func _f160(this_, a: Array, env):
	var v_v_600 = null; var v_n_601 = null; var v_m_602 = null; var v_g_603 = null; var v_c_606 = null
	v_v_600 = J.arg(a, 0)
	v_n_601 = J.arg(a, 1)
	var _t1102 = (not J.t(v_v_600))
	if J.t((_t1102 if _t1102 else J.gp(this_, "expelled"))):
		return null
	if J.t((J.gp(J.gp(this_, "site"), "pano") if J.t(v_n_601) else v_n_601)):
		var _t1103 = this_
		var _t1104 = J.mc(this_, "roomOf", [v_n_601])
		J.sp(_t1103, "expoRoom", _t1104)
	var _t1105 = this_
	var _t1106 = J.gp(this_, "expo")
	var _t1107 = J.gp(this_, "expo")
	var _t1108 = J.min_([100.0, J.add((_t1107 if J.t(_t1107) else 0.0), v_v_600)])
	J.sp(_t1105, "expo", _t1108)
	var _t1109 = this_
	var _t1110 = J.gp(this_, "t")
	J.sp(_t1109, "expoT", _t1110)
	var _t1111 = this_
	var _t1112 = J.gp(this_, "expoMax")
	var _t1113 = J.gp(this_, "expoMax")
	var _t1114 = J.max_([(_t1113 if J.t(_t1113) else 0.0), J.gp(this_, "expo")])
	J.sp(_t1111, "expoMax", _t1114)
	var _t1115 = (not J.t(J.gp(this_, "headless")))
	if (J.cmp(v_v_600, 5.0, ">=") if _t1115 else _t1115):
		J.mc(this_, "float", [0.2, 0.06, ("穿崩度 +" + J.str(J.round(J.num(v_v_600)))), "#ff9a7a", 1.4])
	var _t1116 = J.cmp(J.gp(this_, "expo"), J.gp(J.G.get("EXPO"), "sus"), ">=")
	if ((not J.t(J.gp(this_, "alert"))) if _t1116 else _t1116):
		var _t1117 = this_
		J.sp(_t1117, "alert", true)
		var _t1118 = J.gp(this_, "npcs")
		v_m_602 = J.mc(_t1118, "find", [Callable(self, "_f161").bind(env)])
		if J.t(v_m_602):
			J.mc(this_, "bubble", [v_m_602, "呢度……係咪有嘢？", 2.4])
		var _t1123 = J.gp(this_, "npcs")
		v_g_603 = J.mc(_t1123, "find", [Callable(self, "_f162").bind(env)])
		if J.t(v_g_603):
			J.mc(this_, "bubble", [v_g_603, "我行多幾轉睇睇。", 2.2])
			J.mc(this_, "wakeGuard", [null])
	var _t1126 = J.gp(this_, "expo")
	var _t1125 = J.gp(this_, "daoAt")
	var _t1127 = J.cmp(_t1126, (_t1125 if J.t(_t1125) else J.gp(J.G.get("EXPO"), "call")), ">=")
	if ((not J.t(J.gp(this_, "daoCall"))) if _t1127 else _t1127):
		var _t1128 = J.gp(this_, "npcs")
		var _t1137 = J.mc(_t1128, "find", [Callable(self, "_f163").bind(env)])
		if not J.t(_t1137):
			var _t1133 = J.gp(this_, "npcs")
			_t1137 = J.mc(_t1133, "find", [Callable(self, "_f164").bind(env)])
		v_c_606 = _t1137
		if J.t(v_c_606):
			var _t1138 = this_
			var _t1139 = J.gp(this_, "t")
			J.sp(_t1138, "daoCall", _t1139)
			J.mc(this_, "bubble", [v_c_606, ("喂？林師傅？即刻上嚟二十三樓！" if J.seq(J.gp(J.gp(v_c_606, "d"), "k"), "boss") else "喂～林師傅呀？二十三樓好似有嘢……"), 3.0])
			if (not J.t(J.gp(this_, "headless"))):
				J.mc(this_, "float", [0.5, 0.3, (J.str(J.gp(J.gp(v_c_606, "d"), "name")) + "打電話請咗道士！"), "#ffcf6a", 2.6])

func _f165(this_, a: Array, env):
	var v_n_611 = null
	v_n_611 = J.arg(a, 0)
	var _t1140 = J.gp(J.gp(v_n_611, "d"), "guard")
	return ([12.0, 18.0] if J.t((J.gp(this_, "alert") if J.t(_t1140) else _t1140)) else J.gp(J.gp(v_n_611, "d"), "work"))

func _f167(this_, a: Array, env):
	var v_x_617 = null
	v_x_617 = J.arg(a, 0)
	var _t1142 = J.gp(J.gp(v_x_617, "d"), "daoshi")
	var _t1143 = ((not J.t(J.gp(v_x_617, "gone"))) if J.t(_t1142) else _t1142)
	var _t1144 = ((not J.t(J.gp(v_x_617, "out"))) if J.t(_t1143) else _t1143)
	return ((not J.t(J.gp(v_x_617, "fleeing"))) if J.t(_t1144) else _t1144)

func _f166(this_, a: Array, env):
	var v_dt_614 = null; var v_dao_615 = null; var v_quiet_616 = null; var v_ex_618 = null; var v_ey_619 = null; var v_n_620 = null
	v_dt_614 = J.arg(a, 0)
	var _t1141 = J.gp(this_, "npcs")
	v_dao_615 = J.mc(_t1141, "find", [Callable(self, "_f167").bind(env)])
	var _t1146 = J.gp(this_, "t")
	var _t1145 = J.gp(this_, "expoT")
	v_quiet_616 = (J.sub(_t1146, (_t1145 if J.t(_t1145) else (-99.0))) > 5.0)
	var _t1147 = this_
	var _t1148 = J.gp(this_, "expo")
	var _t1149 = J.gp(this_, "expo")
	var _t1150 = J.max_([0.0, J.sub((_t1149 if J.t(_t1149) else 0.0), J.mul((J.gp(J.G.get("EXPO"), "lowDecay") if J.t((v_quiet_616 if J.t(v_dao_615) else v_dao_615)) else J.gp(J.G.get("EXPO"), "decay")), v_dt_614))])
	J.sp(_t1147, "expo", _t1150)
	var _t1151 = J.gp(this_, "daoCall")
	var _t1154 = ((not J.t(J.gp(this_, "daoIn"))) if J.t(_t1151) else _t1151)
	if J.t(_t1154):
		var _t1153 = J.sub(J.gp(this_, "t"), J.gp(this_, "daoCall"))
		var _t1152 = J.gp(this_, "daoDelay")
		_t1154 = J.cmp(_t1153, (_t1152 if J.t(_t1152) else 7.0), ">")
	if J.t(_t1154):
		var _t1155 = this_
		J.sp(_t1155, "daoIn", true)
		var _t1156 = J.mc(this_, "exitPt", [])
		var _t1157 = J.gp(_t1156, 0.0)
		v_ex_618 = _t1157
		var _t1158 = J.gp(_t1156, 1.0)
		v_ey_619 = _t1158
		v_n_620 = {"d": J.G.get("DAOSHI"), "x": v_ex_618, "y": v_ey_619, "wi": 0.0, "wait": 0.0, "dir": (-1.0), "fear": 0.0, "peak": 0.0, "gone": false, "exitT": 0.0, "bounce": 0.0, "look": 0.0, "bub": null, "bubT": 0.0, "act": "walk", "ph": 0.0, "prog": 0.0, "ds": "in", "inAt": J.gp(this_, "t")}
		var _t1159 = J.gp(this_, "npcs")
		J.mc(_t1159, "push", [v_n_620])
		J.mc(this_, "elevator", [])
		J.mc(this_, "bubble", [v_n_620, "邊度有嘢？等我睇睇。", 2.6])

func _f168(this_, a: Array, env):
	var v_n_623 = null; var v_dt_624 = null; var v_spot_625 = null; var v_r_626 = null; var v_dx_627 = null; var v_dy_628 = null; var v_d_629 = null; var v_sp_630 = null; var v_startled_631 = null; var v_ex_632 = null; var v_ey_633 = null; var v_dx_634 = null; var v_dy_635 = null; var v_d_636 = null; var v_sp_637 = null
	v_n_623 = J.arg(a, 0)
	v_dt_624 = J.arg(a, 1)
	if (not J.t(J.gp(v_n_623, "spot"))):
		var _t1160 = J.gp(J.gp(this_, "site"), "pano")
		var _t1161 = (J.gp(this_, "expoRoom") if J.t(_t1160) else _t1160)
		v_r_626 = (J.gp(J.gp(J.G.get("OFFMAP"), "RM"), J.gp(this_, "expoRoom")) if J.t(((not J.seq(J.gp(this_, "expoRoom"), "main")) if J.t(_t1161) else _t1161)) else null)
		var _t1166 = null
		if J.t(v_r_626):
			_t1166 = [J.gp(v_r_626, "cx"), 0.86]
		else:
			var _t1165 = null
			if J.t(J.gp(J.gp(this_, "site"), "pano")):
				var _t1162 = J.G.get("_M")
				var _t1164 = J.cl(_t1162, null, [0.66])
				var _t1163 = J.G.get("_MY")
				_t1165 = [_t1164, J.cl(_t1163, null, [0.9])]
			else:
				_t1165 = [0.66, 0.9]
			_t1166 = _t1165
		J.sp(v_n_623, "spot", _t1166)
		var _t1167 = (J.gp(v_r_626, "name") if J.t(v_r_626) else null)
		J.sp(v_n_623, "spotRoom", _t1167)
		if J.t(v_r_626):
			J.mc(this_, "bubble", [v_n_623, (J.str(J.gp(v_r_626, "name")) + "？帶路。"), 2.4])
	v_spot_625 = J.gp(v_n_623, "spot")
	if J.seq(J.gp(v_n_623, "ds"), "in"):
		v_dx_627 = J.sub(J.gp(v_spot_625, 0.0), J.gp(v_n_623, "x"))
		v_dy_628 = J.sub(J.gp(v_spot_625, 1.0), J.gp(v_n_623, "y"))
		v_d_629 = J.hypot_([v_dx_627, v_dy_628])
		v_sp_630 = J.mul(J.gp(J.gp(v_n_623, "d"), "speed"), v_dt_624)
		J.sp(v_n_623, "act", "walk")
		var _t1168 = (1.0 if J.cmp(v_dx_627, 0.0, ">=") else (-1.0))
		J.sp(v_n_623, "dir", _t1168)
		if J.cmp(v_d_629, v_sp_630, "<="):
			var _t1169 = J.gp(v_spot_625, 0.0)
			J.sp(v_n_623, "x", _t1169)
			var _t1170 = J.gp(v_spot_625, 1.0)
			J.sp(v_n_623, "y", _t1170)
			J.sp(v_n_623, "ds", "ritual")
			J.sp(v_n_623, "rT", 0.0)
			J.sp(v_n_623, "act", "ritual")
			J.mc(this_, "bubble", [v_n_623, "（搖鈴）各位，借個位。", 2.4])
		else:
			var _t1171 = J.add(J.gp(v_n_623, "x"), J.mul(J.div(v_dx_627, v_d_629), v_sp_630))
			J.sp(v_n_623, "x", _t1171)
			var _t1172 = J.add(J.gp(v_n_623, "y"), J.mul(J.div(v_dy_628, v_d_629), v_sp_630))
			J.sp(v_n_623, "y", _t1172)
		return null
	if J.seq(J.gp(v_n_623, "ds"), "ritual"):
		J.sp(v_n_623, "act", "ritual")
		var _t1173 = J.add(J.gp(v_n_623, "rT"), v_dt_624)
		J.sp(v_n_623, "rT", _t1173)
		v_startled_631 = J.cmp(J.gp(v_n_623, "fear"), 50.0, ">=")
		if (not J.t(v_startled_631)):
			var _t1174 = J.gp(v_n_623, "prog")
			var _t1175 = J.gp(v_n_623, "prog")
			var _t1176 = J.min_([1.0, J.add((_t1175 if J.t(_t1175) else 0.0), (J.div(v_dt_624, J.gp(J.G.get("EXPO"), "ritual")) * (1.0 if J.cmp(J.gp(this_, "expo"), 25.0, ">=") else 0.4)))])
			J.sp(v_n_623, "prog", _t1176)
		var _t1177 = J.sub((5.0 if J.leq(J.gp(v_n_623, "lt"), null) else J.gp(v_n_623, "lt")), v_dt_624)
		J.sp(v_n_623, "lt", _t1177)
		var _t1178 = J.cmp(J.gp(v_n_623, "lt"), 0.0, "<=")
		if ((not J.t(J.gp(v_n_623, "bub"))) if _t1178 else _t1178):
			var _t1179 = (6.0 + (randf() * 4.0))
			J.sp(v_n_623, "lt", _t1179)
			var _t1181 = null
			if J.t(v_startled_631):
				_t1181 = "（執返個鈴）冇嘢，冇嘢……"
			else:
				var _t1180 = J.G.get("pick")
				_t1181 = J.cl(_t1180, null, [J.gp(J.gp(v_n_623, "d"), "lines")])
			J.mc(this_, "bubble", [v_n_623, _t1181, 2.4])
		if J.cmp(J.gp(v_n_623, "prog"), 1.0, ">="):
			var _t1182 = this_
			J.sp(_t1182, "expelled", true)
			J.mc(this_, "bubble", [v_n_623, "（符紙一貼）收工！", 2.6])
			if (not J.t(J.gp(this_, "headless"))):
				J.mc(this_, "float", [0.5, 0.35, "阿福被請走了……", "#ffcf6a", 3.0])
			var _t1183 = this_
			var _t1184 = J.gp(this_, "endAt")
			var _t1185 = (_t1184 if J.t(_t1184) else J.gp(this_, "t"))
			J.sp(_t1183, "endAt", _t1185)
			return null
		var _t1186 = J.cmp(J.gp(this_, "expo"), J.gp(J.G.get("EXPO"), "giveUp"), "<")
		if (J.cmp(J.gp(v_n_623, "rT"), 10.0, ">") if _t1186 else _t1186):
			J.sp(v_n_623, "ds", "out")
			J.mc(this_, "bubble", [v_n_623, "冇嘢喎……今晚收你半價。", 2.8])
			if (not J.t(J.gp(this_, "headless"))):
				J.mc(this_, "float", [0.5, 0.35, "道士放棄了", "#9fe0c0", 2.2])
		return null
	if J.seq(J.gp(v_n_623, "ds"), "out"):
		var _t1187 = J.mc(this_, "exitPt", [])
		var _t1188 = J.gp(_t1187, 0.0)
		v_ex_632 = _t1188
		var _t1189 = J.gp(_t1187, 1.0)
		v_ey_633 = _t1189
		v_dx_634 = J.sub(v_ex_632, J.gp(v_n_623, "x"))
		v_dy_635 = J.sub(v_ey_633, J.gp(v_n_623, "y"))
		v_d_636 = J.hypot_([v_dx_634, v_dy_635])
		v_sp_637 = J.mul(J.mul(J.gp(J.gp(v_n_623, "d"), "speed"), 1.2), v_dt_624)
		J.sp(v_n_623, "act", "walk")
		var _t1190 = (1.0 if J.cmp(v_dx_634, 0.0, ">=") else (-1.0))
		J.sp(v_n_623, "dir", _t1190)
		if J.cmp(v_d_636, v_sp_637, "<="):
			J.mc(this_, "goOut", [v_n_623, 0.0, true])
			J.sp(v_n_623, "left", true)
		else:
			var _t1191 = J.add(J.gp(v_n_623, "x"), J.mul(J.div(v_dx_634, v_d_636), v_sp_637))
			J.sp(v_n_623, "x", _t1191)
			var _t1192 = J.add(J.gp(v_n_623, "y"), J.mul(J.div(v_dy_635, v_d_636), v_sp_637))
			J.sp(v_n_623, "y", _t1192)

func _f169(this_, a: Array, env):
	var v_skip_640 = null; var v_room_641 = null; var v_n_642 = null; var v_before_643 = null
	v_skip_640 = J.arg(a, 0)
	v_room_641 = J.arg(a, 1)
	for _t1193 in J.iter(J.gp(this_, "npcs")):
		v_n_642 = _t1193
		var _t1194 = J.gp(v_n_642, "gone")
		var _t1195 = (_t1194 if J.t(_t1194) else J.gp(v_n_642, "out"))
		var _t1196 = (_t1195 if J.t(_t1195) else J.gp(v_n_642, "fleeing"))
		var _t1197 = (_t1196 if J.t(_t1196) else J.gp(J.gp(v_n_642, "d"), "guard"))
		var _t1198 = (_t1197 if J.t(_t1197) else (not J.cmp(J.gp(v_n_642, "shaken"), 0.0, ">")))
		var _t1200 = (_t1198 if J.t(_t1198) else (J.mc(v_skip_640, "includes", [v_n_642]) if J.t(v_skip_640) else v_skip_640))
		if not J.t(_t1200):
			var _t1199 = (J.gp(J.gp(this_, "site"), "pano") if J.t(v_room_641) else v_room_641)
			_t1200 = ((not J.seq(J.mc(this_, "roomOf", [v_n_642]), v_room_641)) if J.t(_t1199) else _t1199)
		if J.t(_t1200):
			continue
		v_before_643 = J.min_([100.0, J.gp(v_n_642, "peak")])
		var _t1201 = J.min_([99.0, J.add(J.gp(v_n_642, "fear"), 5.0)])
		J.sp(v_n_642, "fear", _t1201)
		var _t1202 = J.max_([J.gp(v_n_642, "peak"), J.gp(v_n_642, "fear")])
		J.sp(v_n_642, "peak", _t1202)
		var _t1203 = this_
		var _t1204 = J.add(J.gp(_t1203, "kpi"), J.round(J.num(J.sub(J.min_([100.0, J.gp(v_n_642, "peak")]), v_before_643))))
		J.sp(_t1203, "kpi", _t1204)
		if (not J.t(J.gp(this_, "headless"))):
			J.mc(this_, "react", [v_n_642, "flinch"])
			J.sp(v_n_642, "barHit", 0.6)
			if (randf() < 0.5):
				var _t1205 = J.G.get("pick")
				J.mc(this_, "bubble", [v_n_642, J.cl(_t1205, null, [J.G.get("JUMPY_SAY")]), 1.4])

func _f170(this_, a: Array, env):
	var v_d_646 = null; var v_v_647 = null; var v_why_648 = null
	v_d_646 = J.arg(a, 0)
	v_v_647 = J.arg(a, 1)
	v_why_648 = J.arg(a, 2)
	if J.t(v_v_647):
		var _t1206 = J.gp(this_, "karma")
		J.mc(_t1206, "push", [{"v": v_v_647, "who": J.gp(v_d_646, "name"), "why": v_why_648}])

func _f171(this_, a: Array, env):
	var v_e_651 = null; var v_r_652 = null; var v_mx_653 = null; var v_my_654 = null; var v_best_655 = null; var v_bd_656 = null; var v_n_657 = null; var v_n_658 = null; var v_x_659 = null; var v_y_660 = null; var v_hh_661 = null; var v_dd_662 = null; var v_k_663 = null; var v_k_664 = null; var v_p_665 = null; var v_x1_666 = null; var v_y1_667 = null; var v_x2_668 = null; var v_y2_669 = null; var v_g_670 = null; var v_k_671 = null
	v_e_651 = J.arg(a, 0)
	var _t1207 = J.gp(this_, "paused")
	if J.t((_t1207 if J.t(_t1207) else J.gp(this_, "endAt"))):
		return null
	var _t1209 = null
	if J.t(J.gp(this_, "_nat")):
		_t1209 = {"left": 0.0, "top": 0.0}
	else:
		var _t1208 = J.G.get("$")
		_t1209 = J.mc(J.cl(_t1208, null, ["#sc-cvs"]), "getBoundingClientRect", [])
	v_r_652 = _t1209
	v_mx_653 = J.sub(J.gp(v_e_651, "clientX"), J.gp(v_r_652, "left"))
	v_my_654 = J.sub(J.gp(v_e_651, "clientY"), J.gp(v_r_652, "top"))
	var _t1210 = J.gp(this_, "_edge")
	var _t1211 = (J.cmp(v_mx_653, J.gp(J.gp(this_, "_edge"), 0.0), ">") if J.t(_t1210) else _t1210)
	var _t1212 = (J.cmp(v_mx_653, J.add(J.gp(J.gp(this_, "_edge"), 0.0), J.gp(J.gp(this_, "_edge"), 2.0)), "<") if J.t(_t1211) else _t1211)
	var _t1213 = (J.cmp(v_my_654, J.gp(J.gp(this_, "_edge"), 1.0), ">") if J.t(_t1212) else _t1212)
	if J.t((J.cmp(v_my_654, J.add(J.gp(J.gp(this_, "_edge"), 1.0), J.gp(J.gp(this_, "_edge"), 3.0)), "<") if J.t(_t1213) else _t1213)):
		v_n_657 = J.gp(J.gp(this_, "_edge"), 4.0)
		var _t1214 = this_
		var _t1215 = J.mc(this_, "clampCam", [J.sub(J.gp(v_n_657, "x"), J.div(J.mc(this_, "viewW", []), 2.0))])
		J.sp(_t1214, "camTo", _t1215)
		var _t1216 = this_
		var _t1217 = (-99.0)
		J.sp(_t1216, "userPan", _t1217)
		return null
	v_best_655 = null
	v_bd_656 = 1000000000.0
	for _t1218 in J.iter(J.gp(this_, "npcs")):
		v_n_658 = _t1218
		var _t1219 = J.gp(v_n_658, "gone")
		if J.t((_t1219 if J.t(_t1219) else J.gp(v_n_658, "out"))):
			continue
		var _t1220 = J.mc(this_, "pt", [J.add(J.gp(v_n_658, "x"), (J.mc(J.G.get("OFFICE"), "kenOff", [v_n_658]) if J.t(J.mc(this_, "office", [])) else 0.0)), J.gp(v_n_658, "y")])
		var _t1221 = J.gp(_t1220, 0.0)
		v_x_659 = _t1221
		var _t1222 = J.gp(_t1220, 1.0)
		v_y_660 = _t1222
		v_hh_661 = J.mc(this_, "hh", [J.gp(v_n_658, "y")])
		var _t1223 = J.cmp(v_mx_653, J.sub(v_x_659, J.mul(v_hh_661, 0.32)), ">")
		var _t1224 = (J.cmp(v_mx_653, J.add(v_x_659, J.mul(v_hh_661, 0.32)), "<") if _t1223 else _t1223)
		var _t1225 = (J.cmp(v_my_654, J.sub(v_y_660, v_hh_661), ">") if _t1224 else _t1224)
		if (J.cmp(v_my_654, J.add(v_y_660, 6.0), "<") if _t1225 else _t1225):
			v_dd_662 = (absf(J.num(J.sub(v_mx_653, v_x_659))) + (absf(J.num(J.sub(v_my_654, J.sub(v_y_660, J.div(v_hh_661, 2.0))))) * 0.3))
			if J.cmp(v_dd_662, v_bd_656, "<"):
				v_bd_656 = v_dd_662
				v_best_655 = v_n_658
	var _t1226 = J.gp(this_, "armed")
	if J.t((v_best_655 if J.t(_t1226) else _t1226)):
		v_k_663 = J.gp(this_, "armed")
		var _t1227 = this_
		J.sp(_t1227, "armed", null)
		J.mc(this_, "useGhost", [v_k_663, v_best_655])
		var _t1228 = this_
		J.sp(_t1228, "sel", v_best_655)
		var _t1229 = this_
		J.sp(_t1229, "selAuto", false)
		J.mc(this_, "renderDock", [])
		J.mc(this_, "renderTarget", [])
		return null
	if J.t(v_best_655):
		var _t1230 = this_
		J.sp(_t1230, "sel", v_best_655)
		var _t1231 = this_
		J.sp(_t1231, "selAuto", false)
		J.mc(this_, "renderTarget", [])
		return null
	for _t1232 in J.keys(J.G.get("SCARE_PROPS")):
		v_k_664 = _t1232
		if J.t(J.gp(J.gp(J.G.get("SCARE_PROPS"), v_k_664), "group")):
			continue
		v_p_665 = J.gp(J.G.get("SCARE_PROPS"), v_k_664)
		var _t1233 = J.mc(this_, "pt", [J.gp(J.gp(v_p_665, "rect"), 0.0), J.gp(J.gp(v_p_665, "rect"), 1.0)])
		var _t1234 = J.gp(_t1233, 0.0)
		v_x1_666 = _t1234
		var _t1235 = J.gp(_t1233, 1.0)
		v_y1_667 = _t1235
		var _t1236 = J.mc(this_, "pt", [J.add(J.gp(J.gp(v_p_665, "rect"), 0.0), J.gp(J.gp(v_p_665, "rect"), 2.0)), J.add(J.gp(J.gp(v_p_665, "rect"), 1.0), J.gp(J.gp(v_p_665, "rect"), 3.0))])
		var _t1237 = J.gp(_t1236, 0.0)
		v_x2_668 = _t1237
		var _t1238 = J.gp(_t1236, 1.0)
		v_y2_669 = _t1238
		var _t1239 = J.cmp(v_mx_653, J.sub(v_x1_666, 10.0), ">")
		var _t1240 = (J.cmp(v_mx_653, J.add(v_x2_668, 10.0), "<") if _t1239 else _t1239)
		var _t1241 = (J.cmp(v_my_654, J.sub(v_y1_667, 10.0), ">") if _t1240 else _t1240)
		if (J.cmp(v_my_654, J.add(v_y2_669, 10.0), "<") if _t1241 else _t1241):
			J.mc(this_, "useProp", [v_k_664])
			return null
	if J.t(J.gp(this_, "armed")):
		v_g_670 = J.gp(J.G.get("SCARE_GHOSTS"), J.gp(this_, "armed"))
		if J.t(J.gp(v_g_670, "aoe")):
			v_k_671 = J.gp(this_, "armed")
			var _t1242 = this_
			J.sp(_t1242, "armed", null)
			J.mc(this_, "useGhost", [v_k_671])
			J.mc(this_, "renderDock", [])

func _f173(this_, a: Array, env):
	var v_k_675 = null
	v_k_675 = J.arg(a, 0)
	return ("<button class=\"btn sm sc-room\" data-p=\"" + J.str(v_k_675) + "\" style=\"padding:5px 2px;font-size:12px;line-height:1.25;width:100%\"><b>" + J.str(J.gp(J.gp(J.G.get("SCARE_PROPS"), v_k_675), "name")) + "</b><br><small>" + ("呢間房" if J.t(J.gp(J.gp(env["this"], "site"), "pano")) else "全場") + "・" + J.str(J.gp(J.gp(J.G.get("SCARE_PROPS"), v_k_675), "cost")) + "</small></button>")

func _f175(this_, a: Array, env):
	var v_t_679 = null
	v_t_679 = J.arg(a, 0)
	var _t1251 = null
	if J.t(J.gp(J.G.get("FEAR_WORD"), v_t_679)):
		var _t1250 = J.gp(J.G.get("FEAR_WORD"), v_t_679)
		_t1251 = J.mc(_t1250, "slice", [(-2.0)])
	else:
		_t1251 = v_t_679
	return _t1251

func _f174(this_, a: Array, env):
	var v_k_676 = null; var v_g_677 = null; var v_c_678 = null
	v_k_676 = J.arg(a, 0)
	v_g_677 = J.gp(J.G.get("SCARE_GHOSTS"), v_k_676)
	v_c_678 = J.gp(J.gp(env["this"], "caught"), v_k_676)
	var _t1255 = ("arm" if J.seq(J.gp(env["this"], "armed"), v_k_676) else "")
	var _t1256 = ("caught" if J.t(v_c_678) else "")
	var _t1257 = J.gp(v_g_677, "skill")
	var _t1254 = null
	if J.t(v_c_678):
		_t1254 = "喝茶中"
	else:
		var _t1253 = J.add(J.gp(v_g_677, "name"), "・")
		var _t1248 = J.gp(v_g_677, "types")
		var _t1249 = (_t1248 if J.t(_t1248) else [J.gp(v_g_677, "type")])
		var _t1252 = J.mc(_t1249, "map", [Callable(self, "_f175").bind(env)])
		_t1254 = (J.add(_t1253, J.mc(_t1252, "join", ["／"])) + ("・全場" if J.t(J.gp(v_g_677, "aoe")) else ""))
	return ("<button class=\"sc-gb " + _t1255 + " " + _t1256 + "\" data-k=\"" + J.str(v_k_676) + "\"><canvas data-por=\"" + J.str(v_k_676) + "\"></canvas><i class=\"cd\"></i><b>" + J.str(_t1257) + "</b><small>" + _t1254 + "</small></button>")

func _f177(this_, a: Array, env):
	var _t1266 = J.gp(env["__p"]["this"], "paused")
	if J.t((_t1266 if J.t(_t1266) else J.gp(env["__p"]["this"], "endAt"))):
		return null
	J.mc(env["__p"]["this"], "useProp", [J.gp(J.gp(env["b"], "dataset"), "p")])

func _f176(this_, a: Array, env):
	var _s383 = {"__p": env, "b": null}
	_s383["b"] = J.arg(a, 0)
	var _t1265 = _s383["b"]
	var _t1267 = Callable(self, "_f177").bind(_s383)
	J.sp(_t1265, "onclick", _t1267)
	return _t1267

func _f179(this_, a: Array, env):
	var v_k_682 = null; var v_g_683 = null
	v_k_682 = J.gp(J.gp(env["b"], "dataset"), "k")
	var _t1272 = J.gp(J.gp(env["__p"]["this"], "caught"), v_k_682)
	var _t1273 = (_t1272 if J.t(_t1272) else J.cmp(J.gp(J.gp(env["__p"]["this"], "cd"), v_k_682), 0.0, ">"))
	var _t1274 = (_t1273 if J.t(_t1273) else J.gp(env["__p"]["this"], "paused"))
	if J.t((_t1274 if J.t(_t1274) else J.gp(env["__p"]["this"], "endAt"))):
		return null
	v_g_683 = J.gp(J.G.get("SCARE_GHOSTS"), v_k_682)
	if J.t(J.gp(v_g_683, "aoe")):
		J.mc(env["__p"]["this"], "useGhost", [v_k_682])
		var _t1275 = env["__p"]["this"]
		J.sp(_t1275, "armed", null)
	else:
		var _t1276 = J.gp(env["__p"]["this"], "sel")
		var _t1277 = ((not J.t(J.gp(J.gp(env["__p"]["this"], "sel"), "gone"))) if J.t(_t1276) else _t1276)
		var _t1278 = ((not J.t(J.gp(J.gp(env["__p"]["this"], "sel"), "out"))) if J.t(_t1277) else _t1277)
		if J.t(((not J.t(J.gp(J.gp(J.gp(env["__p"]["this"], "sel"), "d"), "guard"))) if J.t(_t1278) else _t1278)):
			J.mc(env["__p"]["this"], "useGhost", [v_k_682, J.gp(env["__p"]["this"], "sel")])
			var _t1279 = env["__p"]["this"]
			J.sp(_t1279, "armed", null)
		else:
			var _t1280 = env["__p"]["this"]
			var _t1281 = (null if J.seq(J.gp(env["__p"]["this"], "armed"), v_k_682) else v_k_682)
			J.sp(_t1280, "armed", _t1281)
			J.mc(env["__p"]["this"], "toast", ["點一個人"])
	J.mc(env["__p"]["this"], "renderDock", [])

func _f178(this_, a: Array, env):
	var _s385 = {"__p": env, "b": null}
	_s385["b"] = J.arg(a, 0)
	var _t1271 = _s385["b"]
	var _t1282 = Callable(self, "_f179").bind(_s385)
	J.sp(_t1271, "onclick", _t1282)
	return _t1282

func _f172(this_, a: Array, env):
	var v_room_674 = null
	var _s379 = {"__p": env, "this": null}
	_s379["this"] = this_
	var _t1243 = ["lights", "ac"]
	var _t1244 = J.mc(_t1243, "map", [Callable(self, "_f173").bind(_s379)])
	v_room_674 = ("<div style=\"display:flex;flex-direction:column;gap:5px;flex:0 0 76px\">" + J.str(J.mc(_t1244, "join", [""])) + "</div>")
	var _t1245 = J.G.get("$")
	var _t1246 = J.cl(_t1245, null, ["#sc-dock"])
	var _t1247 = J.gp(_s379["this"], "team")
	var _t1258 = J.mc(_t1247, "map", [Callable(self, "_f174").bind(_s379)])
	var _t1259 = J.add(v_room_674, J.mc(_t1258, "join", [""]))
	J.sp(_t1246, "innerHTML", _t1259)
	var _t1260 = J.G.get("paintPortraits")
	var _t1261 = J.G.get("$")
	J.cl(_t1260, null, [J.cl(_t1261, null, ["#sc-dock"])])
	var _t1262 = J.G.get("$")
	var _t1263 = J.cl(_t1262, null, ["#sc-dock"])
	var _t1264 = J.mc(_t1263, "querySelectorAll", [".sc-room"])
	J.mc(_t1264, "forEach", [Callable(self, "_f176").bind(_s379)])
	var _t1268 = J.G.get("$")
	var _t1269 = J.cl(_t1268, null, ["#sc-dock"])
	var _t1270 = J.mc(_t1269, "querySelectorAll", [".sc-gb"])
	J.mc(_t1270, "forEach", [Callable(self, "_f178").bind(_s379)])

func _f181(this_, a: Array, env):
	return J.mc(env["this"], "peek", [env["n"]])

func _f182(this_, a: Array, env):
	return J.mc(env["this"], "usePhone", [env["n"]])

func _f183(this_, a: Array, env):
	return J.mc(env["this"], "useBreath", [env["n"]])

func _f180(this_, a: Array, env):
	var v_off_687 = null
	var _s390 = {"__p": env, "this": null, "n": null}
	_s390["this"] = this_
	var _t1283 = J.gp(_s390["this"], "sel")
	var _t1284 = ((not J.t(J.gp(J.gp(_s390["this"], "sel"), "gone"))) if J.t(_t1283) else _t1283)
	_s390["n"] = (J.gp(_s390["this"], "sel") if J.t(((not J.t(J.gp(J.gp(_s390["this"], "sel"), "fleeing"))) if J.t(_t1284) else _t1284)) else null)
	v_off_687 = ("disabled" if J.t((J.gp(_s390["n"], "out") if J.t(_s390["n"]) else _s390["n"])) else "")
	var _t1285 = _s390["this"]
	var _t1286 = (not (not J.t((J.gp(_s390["n"], "out") if J.t(_s390["n"]) else _s390["n"]))))
	J.sp(_t1285, "_selOut", _t1286)
	var _t1287 = J.G.get("$")
	var _t1288 = J.cl(_t1287, null, ["#sc-target"])
	var _t1289 = (("<div class=\"sc-who\"><b>" + J.str(J.gp(J.gp(_s390["n"], "d"), "name")) + "</b><small>" + J.str((("已經走了" if J.t(J.gp(_s390["n"], "left")) else "暫時不在") if J.t(J.gp(_s390["n"], "out")) else J.gp(J.gp(_s390["n"], "d"), "role"))) + "</small>" + (("<button class=\"btn sm\" id=\"sc-peek\">偷看手機</button><button class=\"btn sm gold\" id=\"sc-wa\" " + J.str(v_off_687) + ">傳訊息</button>") if J.t(J.gp(J.gp(_s390["n"], "d"), "phone")) else "") + "<button class=\"btn sm gold\" id=\"sc-br\" " + J.str(v_off_687) + ">背後呼氣</button></div><div class=\"sc-prof\" style=\"font-size:13px;line-height:1.5;padding:4px 2px 2px;opacity:.95\">" + J.str(J.mc(_s390["this"], "profile", [_s390["n"]])) + "</div>") if J.t(_s390["n"]) else "<div class=\"sc-who\"><small>點場景裡的人，或發光的東西。</small></div>")
	J.sp(_t1288, "innerHTML", _t1289)
	if J.t((J.gp(J.gp(_s390["n"], "d"), "phone") if J.t(_s390["n"]) else _s390["n"])):
		var _t1290 = J.G.get("$")
		var _t1291 = J.cl(_t1290, null, ["#sc-peek"])
		var _t1292 = Callable(self, "_f181").bind(_s390)
		J.sp(_t1291, "onclick", _t1292)
		var _t1293 = J.G.get("$")
		var _t1294 = J.cl(_t1293, null, ["#sc-wa"])
		var _t1295 = Callable(self, "_f182").bind(_s390)
		J.sp(_t1294, "onclick", _t1295)
	if J.t(_s390["n"]):
		var _t1296 = J.G.get("$")
		var _t1297 = J.cl(_t1296, null, ["#sc-br"])
		var _t1298 = Callable(self, "_f183").bind(_s390)
		J.sp(_t1297, "onclick", _t1298)

func _f185(this_, a: Array, env):
	var v_t_695 = null
	v_t_695 = J.arg(a, 0)
	var _t1303 = J.mc(env["hid"], "includes", [v_t_695])
	return ("？" if J.t(((not J.t(J.mc(env["K"], "has", [v_t_695]))) if J.t(_t1303) else _t1303)) else J.gp(J.G.get("FEAR_WORD"), v_t_695))

func _f186(this_, a: Array, env):
	var v_t_696 = null
	v_t_696 = J.arg(a, 0)
	return J.gp(J.G.get("FEAR_WORD"), v_t_696)

func _f184(this_, a: Array, env):
	var v_n_690 = null; var v_d_691 = null; var v_w_694 = null
	var _s395 = {"__p": env, "K": null, "hid": null}
	v_n_690 = J.arg(a, 0)
	v_d_691 = J.gp(v_n_690, "d")
	if J.t(J.gp(v_d_691, "guard")):
		return "怕：<b>乜都唔怕</b>（做咗三十年夜班）"
	var _t1299 = J.gp(this_, "known")
	var _t1300 = (J.gp(J.gp(this_, "known"), J.gp(v_d_691, "k")) if J.t(_t1299) else _t1299)
	_s395["K"] = (_t1300 if J.t(_t1300) else J.new_("Set", []))
	var _t1301 = J.gp(v_d_691, "hide")
	_s395["hid"] = (_t1301 if J.t(_t1301) else [])
	var _t1302 = J.gp(v_d_691, "weak")
	v_w_694 = J.mc(_t1302, "map", [Callable(self, "_f185").bind(_s395)])
	var _t1307 = J.mc(v_w_694, "join", ["、"])
	var _t1304 = J.gp(v_d_691, "immune")
	var _t1305 = J.mc(_t1304, "map", [Callable(self, "_f186").bind(_s395)])
	var _t1306 = J.mc(_t1305, "join", ["、"])
	return ("怕：<b style=\"color:#ffb070\">" + J.str(_t1307) + "</b>　唔怕：<b style=\"color:#9ab\">" + J.str((_t1306 if J.t(_t1306) else "—")) + "</b>" + ("（全場燈／冷氣都唔怕）" if J.t(J.gp(J.G.get("GROUP_IMMUNE"), J.gp(v_d_691, "k"))) else ""))

func _f188(this_, a: Array, env):
	var v_t_702 = null
	v_t_702 = J.arg(a, 0)
	return J.mc(env["K"], "add", [v_t_702])

func _f189(this_, a: Array, env):
	var v_m_703 = null
	v_m_703 = J.arg(a, 0)
	return ("<div class=\"sc-m " + ("me" if J.seq(J.gp(v_m_703, 0.0), J.gp(J.gp(env["n"], "d"), "name")) else "") + "\"><i>" + J.str(J.gp(v_m_703, 0.0)) + "・" + J.str(J.gp(v_m_703, 1.0)) + "</i>" + J.str(J.gp(v_m_703, 2.0)) + "</div>")

func _f190(this_, a: Array, env):
	var _t1327 = J.gp(env["p"], "classList")
	J.mc(_t1327, "remove", ["on"])
	var _t1328 = env["this"]
	J.sp(_t1328, "paused", false)
	var _t1329 = env["this"]
	var _t1330 = J.S_performance_("now", [])
	J.sp(_t1329, "last", _t1330)

func _f187(this_, a: Array, env):
	var _s398 = {"__p": env, "this": null, "n": null, "K": null, "p": null}
	_s398["this"] = this_
	_s398["n"] = J.arg(a, 0)
	var _t1308 = _s398["this"]
	var _t1309 = J.gp(_s398["this"], "known")
	var _t1310 = (_t1309 if J.t(_t1309) else {})
	J.sp(_t1308, "known", _t1310)
	var _t1311 = J.gp(_s398["this"], "known")
	var _t1312 = J.gp(J.gp(_s398["n"], "d"), "k")
	var _t1313 = J.gp(J.gp(_s398["this"], "known"), J.gp(J.gp(_s398["n"], "d"), "k"))
	var _t1314 = (_t1313 if J.t(_t1313) else J.new_("Set", []))
	J.sp(_t1311, _t1312, _t1314)
	_s398["K"] = _t1314
	var _t1315 = J.gp(J.gp(_s398["n"], "d"), "hide")
	var _t1316 = (_t1315 if J.t(_t1315) else [])
	J.mc(_t1316, "forEach", [Callable(self, "_f188").bind(_s398)])
	J.mc(_s398["this"], "renderTarget", [])
	var _t1317 = _s398["this"]
	J.sp(_t1317, "paused", true)
	var _t1318 = J.G.get("$")
	_s398["p"] = J.cl(_t1318, null, ["#sc-phone"])
	var _t1319 = _s398["p"]
	var _t1322 = J.gp(J.gp(_s398["n"], "d"), "name")
	var _t1320 = J.gp(J.gp(_s398["n"], "d"), "chat")
	var _t1321 = J.mc(_t1320, "map", [Callable(self, "_f189").bind(_s398)])
	var _t1323 = ("<div class=\"sc-ph\"><div class=\"sc-ph-h\">" + J.str(_t1322) + " 的手機<button id=\"sc-ph-x\">✕</button></div><div class=\"sc-ph-b\">" + J.str(J.mc(_t1321, "join", [""])) + "</div><div class=\"sc-ph-f\">偷看的時候，時間是停的。</div></div>")
	J.sp(_t1319, "innerHTML", _t1323)
	var _t1324 = J.gp(_s398["p"], "classList")
	J.mc(_t1324, "add", ["on"])
	var _t1325 = J.G.get("$")
	var _t1326 = J.cl(_t1325, null, ["#sc-ph-x"])
	var _t1331 = Callable(self, "_f190").bind(_s398)
	J.sp(_t1326, "onclick", _t1331)

func _f192(this_, a: Array, env):
	var v_n_711 = null
	v_n_711 = J.arg(a, 0)
	return J.mc(env["this"], "onScreen", [(J.gp(v_n_711, "vX") if (not J.leq(J.gp(v_n_711, "vX"), null)) else J.gp(v_n_711, "x")), 0.0])

func _f193(this_, a: Array, env):
	var v_n_712 = null
	v_n_712 = J.arg(a, 0)
	var _t1337 = (not J.t(J.gp(v_n_712, "gone")))
	var _t1338 = ((not J.t(J.gp(v_n_712, "out"))) if _t1337 else _t1337)
	var _t1339 = ((not J.t(J.gp(v_n_712, "fleeing"))) if _t1338 else _t1338)
	return ((not J.t(J.gp(J.gp(v_n_712, "d"), "guard"))) if _t1339 else _t1339)

func _f194(this_, a: Array, env):
	var v_b_713 = null; var v_k_714 = null; var v_c_715 = null
	v_b_713 = J.arg(a, 0)
	v_k_714 = J.gp(J.gp(v_b_713, "dataset"), "p")
	var _t1360 = J.gp(env["this"], "pcd")
	var _t1361 = J.gp((_t1360 if J.t(_t1360) else {}), v_k_714)
	v_c_715 = (_t1361 if J.t(_t1361) else 0.0)
	var _t1362 = J.mc(v_b_713, "querySelector", ["small"])
	var _t1363 = (("冷卻 " + J.str(ceil(J.num(v_c_715))) + " 秒") if J.cmp(v_c_715, 0.0, ">") else (J.str((J.gp(J.mc(env["this"], "camRoom", []), "name") if J.t(J.gp(J.gp(env["this"], "site"), "pano")) else "全場")) + "・" + J.str(J.gp(J.gp(J.G.get("SCARE_PROPS"), v_k_714), "cost"))))
	J.sp(_t1362, "textContent", _t1363)
	var _t1364 = J.gp(v_b_713, "style")
	var _t1365 = J.cmp(v_c_715, 0.0, ">")
	var _t1366 = (0.5 if (_t1365 if _t1365 else J.cmp(J.gp(env["this"], "mana"), J.gp(J.gp(J.G.get("SCARE_PROPS"), v_k_714), "cost"), "<")) else 1.0)
	J.sp(_t1364, "opacity", _t1366)

func _f195(this_, a: Array, env):
	var v_b_716 = null; var v_k_717 = null; var v_c_718 = null
	v_b_716 = J.arg(a, 0)
	v_k_717 = J.gp(J.gp(v_b_716, "dataset"), "k")
	v_c_718 = J.gp(J.gp(env["this"], "cd"), v_k_717)
	var _t1370 = J.gp(v_b_716, "classList")
	var _t1371 = J.cmp(v_c_718, 0.0, ">")
	J.mc(_t1370, "toggle", ["cool", ((not J.t(J.gp(J.gp(env["this"], "caught"), v_k_717))) if _t1371 else _t1371)])
	var _t1372 = J.gp(J.mc(v_b_716, "querySelector", [".cd"]), "style")
	var _t1373 = J.add((100.0 if J.t(J.gp(J.gp(env["this"], "caught"), v_k_717)) else (J.div(v_c_718, 22.0) * 100.0)), "%")
	J.sp(_t1372, "height", _t1373)
	var _t1374 = J.gp(v_b_716, "classList")
	var _t1377 = J.gp(env["this"], "mana")
	var _t1375 = J.gp(J.G.get("SCARE_GHOSTS"), v_k_717)
	var _t1376 = J.gp((_t1375 if J.t(_t1375) else {}), "cost")
	J.mc(_t1374, "toggle", ["low", J.cmp(_t1377, (_t1376 if J.t(_t1376) else 35.0), "<")])

func _f191(this_, a: Array, env):
	var v_mins_706 = null; var v_hh_707 = null; var v_mm_708 = null; var v_vis_709 = null; var v_ok_710 = null
	var _s402 = {"__p": env, "this": null}
	_s402["this"] = this_
	var _t1335 = J.gp(_s402["this"], "sel")
	if J.t(_t1335):
		var _t1332 = J.gp(J.gp(_s402["this"], "sel"), "gone")
		var _t1334 = (_t1332 if J.t(_t1332) else J.gp(J.gp(_s402["this"], "sel"), "fleeing"))
		if not J.t(_t1334):
			var _t1333 = J.gp(J.gp(_s402["this"], "sel"), "left")
			_t1334 = (J.gp(J.gp(_s402["this"], "sel"), "out") if J.t(_t1333) else _t1333)
		_t1335 = _t1334
	if J.t(_t1335):
		v_vis_709 = Callable(self, "_f192").bind(_s402)
		var _t1336 = J.gp(_s402["this"], "npcs")
		v_ok_710 = J.mc(_t1336, "filter", [Callable(self, "_f193").bind(_s402)])
		var _t1340 = _s402["this"]
		var _t1341 = J.mc(v_ok_710, "find", [v_vis_709])
		var _t1342 = (_t1341 if J.t(_t1341) else J.gp(v_ok_710, 0.0))
		var _t1343 = (_t1342 if J.t(_t1342) else null)
		J.sp(_t1340, "sel", _t1343)
		var _t1344 = _s402["this"]
		J.sp(_t1344, "selAuto", true)
		J.mc(_s402["this"], "renderTarget", [])
	else:
		var _t1345 = J.gp(_s402["this"], "sel")
		if J.t(((not J.seq((not (not J.t(J.gp(J.gp(_s402["this"], "sel"), "out")))), (not (not J.t(J.gp(_s402["this"], "_selOut")))))) if J.t(_t1345) else _t1345)):
			J.mc(_s402["this"], "renderTarget", [])
	v_mins_706 = J.min_([360.0, floor(J.num((J.div(J.gp(_s402["this"], "t"), J.G.get("NIGHT_SEC")) * 360.0)))])
	var _t1346 = J.F_String([floor(J.num(J.div(v_mins_706, 60.0)))])
	v_hh_707 = J.mc(_t1346, "padStart", [2.0, "0"])
	var _t1347 = J.F_String([(floor(J.num(J.div(J.mod(v_mins_706, 60.0), 10.0))) * 10.0)])
	v_mm_708 = J.mc(_t1347, "padStart", [2.0, "0"])
	if J.t(J.gp(_s402["this"], "_nat")):
		return null
	var _t1348 = J.G.get("$")
	var _t1349 = J.cl(_t1348, null, ["#sc-clock"])
	var _t1350 = (J.str(v_hh_707) + ":" + J.str(v_mm_708))
	J.sp(_t1349, "textContent", _t1350)
	var _t1351 = J.G.get("$")
	var _t1352 = J.cl(_t1351, null, ["#sc-kpi"])
	var _t1353 = ("驚嚇 " + J.str(J.gp(_s402["this"], "kpi")))
	J.sp(_t1352, "textContent", _t1353)
	var _t1354 = J.G.get("$")
	var _t1355 = J.gp(J.cl(_t1354, null, ["#sc-mana i"]), "style")
	var _t1356 = J.add(J.gp(_s402["this"], "mana"), "%")
	J.sp(_t1355, "width", _t1356)
	if J.t(J.gp(J.gp(_s402["this"], "site"), "pano")):
		J.mc(J.G.get("OFFMAP"), "mapTick", [_s402["this"]])
	var _t1357 = J.G.get("$")
	var _t1358 = J.cl(_t1357, null, ["#sc-dock"])
	var _t1359 = J.mc(_t1358, "querySelectorAll", [".sc-room"])
	J.mc(_t1359, "forEach", [Callable(self, "_f194").bind(_s402)])
	var _t1367 = J.G.get("$")
	var _t1368 = J.cl(_t1367, null, ["#sc-dock"])
	var _t1369 = J.mc(_t1368, "querySelectorAll", [".sc-gb"])
	J.mc(_t1369, "forEach", [Callable(self, "_f195").bind(_s402)])

func _f197(this_, a: Array, env):
	var v_m_726 = null
	v_m_726 = J.arg(a, 0)
	var _t1382 = (not J.seq(v_m_726, env["n"]))
	var _t1383 = (J.gp(v_m_726, "bub") if _t1382 else _t1382)
	var _t1384 = (J.cmp(J.gp(v_m_726, "bubT"), 0.0, ">") if J.t(_t1383) else _t1383)
	return ((not J.t(J.gp(v_m_726, "gone"))) if J.t(_t1384) else _t1384)

func _f198(this_, a: Array, env):
	var v_q_727 = null
	v_q_727 = J.arg(a, 0)
	return (not J.seq(J.gp(v_q_727, "n"), env["n"]))

func _f196(this_, a: Array, env):
	var v_text_722 = null; var v_dur_723 = null; var v_ghost_724 = null; var v_live_725 = null
	var _s408 = {"__p": env, "n": null}
	_s408["n"] = J.arg(a, 0)
	v_text_722 = J.arg(a, 1)
	v_dur_723 = J.arg(a, 2)
	v_ghost_724 = J.arg(a, 3)
	var _t1378 = (not J.t(_s408["n"]))
	if (_t1378 if _t1378 else (not J.t(v_text_722))):
		return null
	var _t1380 = (not J.t(J.gp(this_, "headless")))
	if J.t(_t1380):
		var _t1379 = J.gp(_s408["n"], "bub")
		_t1380 = (not J.t((J.cmp(J.gp(_s408["n"], "bubT"), 0.0, ">") if J.t(_t1379) else _t1379)))
	if _t1380:
		var _t1381 = J.gp(this_, "npcs")
		v_live_725 = J.len(J.mc(_t1381, "filter", [Callable(self, "_f197").bind(_s408)]))
		if J.cmp(v_live_725, 2.0, ">="):
			var _t1385 = this_
			var _t1386 = J.gp(this_, "bq")
			var _t1387 = (_t1386 if J.t(_t1386) else [])
			var _t1388 = J.mc(_t1387, "filter", [Callable(self, "_f198").bind(_s408)])
			J.sp(_t1385, "bq", _t1388)
			var _t1389 = J.gp(this_, "bq")
			J.mc(_t1389, "push", [{"n": _s408["n"], "text": v_text_722, "dur": v_dur_723, "ghost": v_ghost_724, "at": J.gp(this_, "t")}])
			if (J.len(J.gp(this_, "bq")) > 3.0):
				J.mc(J.gp(this_, "bq"), "shift", [])
			return null
	var _t1390 = _s408["n"]
	J.sp(_t1390, "bub", v_text_722)
	var _t1391 = _s408["n"]
	var _t1392 = (v_dur_723 if J.t(v_dur_723) else 2.0)
	J.sp(_t1391, "bubT", _t1392)
	var _t1393 = _s408["n"]
	var _t1394 = (not (not J.t(v_ghost_724)))
	J.sp(_t1393, "bubG", _t1394)
	var _t1395 = _s408["n"]
	var _t1396 = J.gp(this_, "t")
	J.sp(_t1395, "bubAt", _t1396)

func _f200(this_, a: Array, env):
	var v_f_731 = null
	v_f_731 = J.arg(a, 0)
	var _t1399 = J.sub(J.gp(v_f_731, "life"), env["dt"])
	J.sp(v_f_731, "life", _t1399)
	return (_t1399 > 0.02)

func _f199(this_, a: Array, env):
	var v_f_732 = null
	var _s413 = {"__p": env, "dt": null}
	_s413["dt"] = J.arg(a, 0)
	var _t1397 = this_
	var _t1398 = J.gp(this_, "floats")
	var _t1400 = J.mc(_t1398, "filter", [Callable(self, "_f200").bind(_s413)])
	J.sp(_t1397, "floats", _t1400)
	var _t1401 = (not J.t(J.len(J.gp(this_, "floats"))))
	var _t1402 = (J.gp(this_, "fq") if _t1401 else _t1401)
	if J.t((J.len(J.gp(this_, "fq")) if J.t(_t1402) else _t1402)):
		v_f_732 = J.mc(J.gp(this_, "fq"), "shift", [])
		var _t1403 = (0.9 if J.t(J.len(J.gp(this_, "fq"))) else J.gp(v_f_732, "max"))
		J.sp(v_f_732, "max", _t1403)
		J.sp(v_f_732, "life", _t1403)
		var _t1404 = J.gp(this_, "floats")
		J.mc(_t1404, "push", [v_f_732])

func _f201(this_, a: Array, env):
	var v_x_735 = null; var v_y_736 = null; var v_text_737 = null; var v_color_738 = null; var v_life_739 = null
	v_x_735 = J.arg(a, 0)
	v_y_736 = J.arg(a, 1)
	v_text_737 = J.arg(a, 2)
	v_color_738 = J.arg(a, 3)
	v_life_739 = J.arg(a, 4)
	if J.t(J.gp(this_, "headless")):
		return null
	var _t1405 = this_
	var _t1406 = J.gp(this_, "fq")
	var _t1407 = (_t1406 if J.t(_t1406) else [])
	J.sp(_t1405, "fq", _t1407)
	var _t1408 = J.gp(this_, "fq")
	J.mc(_t1408, "push", [{"text": v_text_737, "color": v_color_738, "life": J.min_([1.6, (v_life_739 if J.t(v_life_739) else 1.3)]), "max": J.min_([1.6, (v_life_739 if J.t(v_life_739) else 1.3)])}])
	if (J.len(J.gp(this_, "fq")) > 3.0):
		J.mc(J.gp(this_, "fq"), "shift", [])

func _f202(this_, a: Array, env):
	var v_x_742 = null; var v_y_743 = null; var v_text_744 = null; var v_color_745 = null; var v_life_746 = null
	v_x_742 = J.arg(a, 0)
	v_y_743 = J.arg(a, 1)
	v_text_744 = J.arg(a, 2)
	v_color_745 = J.arg(a, 3)
	v_life_746 = J.arg(a, 4)
	var _t1409 = J.gp(this_, "floats")
	J.mc(_t1409, "push", [{"x": v_x_742, "y": v_y_743, "text": v_text_744, "color": v_color_745, "life": (v_life_746 if J.t(v_life_746) else 1.6), "max": (v_life_746 if J.t(v_life_746) else 1.6)}])

func _f203(this_, a: Array, env):
	var v_t_749 = null
	v_t_749 = J.arg(a, 0)
	if (not J.t(J.gp(this_, "headless"))):
		J.mc(this_, "float", [0.5, 0.5, v_t_749, "#fff", 1.2])

func _f204(this_, a: Array, env):
	var v_n_752 = null; var v_x_753 = null; var v_y_754 = null
	v_n_752 = J.arg(a, 0)
	var _t1410 = J.gp(v_n_752, "fleeT")
	if J.t((J.cmp(J.sub(J.gp(this_, "t"), J.gp(v_n_752, "fleeT")), J.gp(v_n_752, "fleeHold"), "<") if J.t(_t1410) else _t1410)):
		return null
	v_x_753 = (J.gp(v_n_752, "vX") if (not J.leq(J.gp(v_n_752, "vX"), null)) else J.gp(v_n_752, "x"))
	v_y_754 = (J.gp(v_n_752, "vY") if (not J.leq(J.gp(v_n_752, "vY"), null)) else J.gp(v_n_752, "y"))
	var _t1411 = J.gp(this_, "parts")
	J.mc(_t1411, "push", [{"kind": "dust", "x": J.sub(v_x_753, J.mul(J.gp(v_n_752, "dir"), 0.03)), "y": v_y_754, "vx": ((-J.num(J.gp(v_n_752, "dir"))) * 0.05), "vy": (-0.03), "life": 0.6}])

func _f205(this_, a: Array, env):
	var v_k_757 = null; var v_p_758 = null; var v_n_759 = null; var v_cx_760 = null; var v_cy_761 = null; var v_i_762 = null; var v_i_763 = null; var v_i_764 = null; var v_hy_765 = null; var v_i_766 = null
	v_k_757 = J.arg(a, 0)
	v_p_758 = J.arg(a, 1)
	v_n_759 = J.arg(a, 2)
	v_cx_760 = J.add(J.gp(J.gp(v_p_758, "rect"), 0.0), J.div(J.gp(J.gp(v_p_758, "rect"), 2.0), 2.0))
	v_cy_761 = J.add(J.gp(J.gp(v_p_758, "rect"), 1.0), J.div(J.gp(J.gp(v_p_758, "rect"), 3.0), 2.0))
	var _t1412 = J.seq(v_k_757, "printer")
	if ((not J.t(J.mc(this_, "office", []))) if _t1412 else _t1412):
		v_i_762 = 0.0
		while true:
			if not J.cmp(v_i_762, 14.0, "<"): break
			var _t1413 = J.gp(this_, "parts")
			J.mc(_t1413, "push", [{"kind": "paper", "x": v_cx_760, "y": v_cy_761, "vx": ((randf() - 0.7) * 0.35), "vy": ((-0.15) - (randf() * 0.25)), "g": 0.35, "vr": ((randf() - 0.5) * 9.0), "life": (1.6 + randf())}])
			v_i_762 = J.num(v_i_762) + 1.0
	var _t1414 = J.seq(v_k_757, "ac")
	if ((not J.t(v_n_759)) if _t1414 else _t1414):
		v_i_763 = 0.0
		while true:
			if not J.cmp(v_i_763, 26.0, "<"): break
			var _t1415 = J.gp(this_, "parts")
			J.mc(_t1415, "push", [{"kind": "frost", "x": J.add(J.gp(J.gp(v_p_758, "rect"), 0.0), J.mul(randf(), J.gp(J.gp(v_p_758, "rect"), 2.0))), "y": J.add(J.gp(J.gp(v_p_758, "rect"), 1.0), J.gp(J.gp(v_p_758, "rect"), 3.0)), "vx": ((randf() - 0.5) * 0.06), "vy": (0.05 + (randf() * 0.12)), "life": (2.0 + randf())}])
			v_i_763 = J.num(v_i_763) + 1.0
	var _t1416 = J.seq(v_k_757, "ac")
	if J.t((v_n_759 if _t1416 else _t1416)):
		v_i_764 = 0.0
		while true:
			if not J.cmp(v_i_764, 22.0, "<"): break
			v_hy_765 = (J.sub(J.gp(v_n_759, "y"), J.mul(J.mc(this_, "hhF", [J.gp(v_n_759, "y")]), 1.05)) if J.t(v_n_759) else J.add(J.gp(J.gp(v_p_758, "rect"), 1.0), J.gp(J.gp(v_p_758, "rect"), 3.0)))
			var _t1417 = J.gp(this_, "parts")
			J.mc(_t1417, "push", [{"kind": "frost", "x": J.add((J.gp(v_n_759, "x") if J.t(v_n_759) else v_cx_760), ((randf() - 0.5) * 0.09)), "y": J.sub(v_hy_765, (randf() * 0.03)), "vx": ((randf() - 0.5) * 0.04), "vy": (0.03 + (randf() * 0.06)), "life": (1.6 + randf()), "delay": (randf() * 0.6)}])
			v_i_764 = J.num(v_i_764) + 1.0
	if J.seq(v_k_757, "water"):
		v_i_766 = 0.0
		while true:
			if not J.cmp(v_i_766, 10.0, "<"): break
			var _t1418 = J.gp(this_, "parts")
			J.mc(_t1418, "push", [{"kind": "bubble", "x": J.add(v_cx_760, ((randf() - 0.5) * 0.04)), "y": J.add(v_cy_761, 0.05), "vx": 0.0, "vy": ((-0.04) - (randf() * 0.05)), "life": (1.2 + randf())}])
			v_i_766 = J.num(v_i_766) + 1.0

func _f207(this_, a: Array, env):
	var v_n_785 = null
	v_n_785 = J.arg(a, 0)
	var _t1428 = J.gp(J.gp(v_n_785, "d"), "guard")
	var _t1429 = ((not J.t(J.gp(v_n_785, "gone"))) if J.t(_t1428) else _t1428)
	var _t1430 = ((not J.t(J.gp(v_n_785, "out"))) if J.t(_t1429) else _t1429)
	return ((not J.seq(J.gp(v_n_785, "act"), "doze")) if J.t(_t1430) else _t1430)

func _f208(this_, a: Array, env):
	var v_n_803 = null
	v_n_803 = J.arg(a, 0)
	var _t1455 = (not J.t(J.gp(v_n_803, "gone")))
	if J.t(_t1455):
		var _t1454 = J.gp(v_n_803, "out")
		if J.t(_t1454):
			var _t1453 = J.gp(env["this"], "t")
			var _t1452 = J.gp(v_n_803, "outAt")
			_t1454 = (J.sub(_t1453, (_t1452 if J.t(_t1452) else 0.0)) > 0.6)
		_t1455 = (not J.t(_t1454))
	var _t1458 = _t1455
	if not J.t(_t1458):
		var _t1456 = J.cmp(J.gp(v_n_803, "exitT"), 0.0, ">")
		var _t1457 = ((J.sub(J.gp(env["this"], "t"), J.gp(v_n_803, "exitT")) < (0.8 if J.t(env["OF"]) else 3.0)) if _t1456 else _t1456)
		_t1458 = (J.cmp(J.gp(J.mc(env["this"], "visPos", [v_n_803]), 0.0), 1.15, "<") if _t1457 else _t1457)
	var _t1460 = _t1458
	if J.t(_t1460):
		var _t1459 = (not J.t(J.gp(J.gp(env["this"], "site"), "pano")))
		_t1460 = (_t1459 if _t1459 else J.mc(env["this"], "onScreen", [J.gp(v_n_803, "x"), 0.3]))
	return _t1460

func _f210(this_, a: Array, env):
	var v_c_805 = null; var v_r_806 = null
	v_c_805 = J.arg(a, 0)
	v_r_806 = J.mc(env["__p"]["this"], "drawNpc", [v_c_805, env["n"], env["__p"]["t"]])
	var _t1463 = (not J.t(J.gp(env["n"], "gone")))
	var _t1464 = (J.cmp(J.gp(v_r_806, "x"), (-30.0), ">") if _t1463 else _t1463)
	if (J.cmp(J.gp(v_r_806, "x"), J.add(J.gp(env["__p"]["this"], "W"), 30.0), "<") if _t1464 else _t1464):
		J.mc(env["__p"]["tags"], "push", [[env["n"], J.gp(v_r_806, "x"), J.sub(J.gp(v_r_806, "top"), 8.0)]])

func _f209(this_, a: Array, env):
	var _s440 = {"__p": env, "n": null}
	_s440["n"] = J.arg(a, 0)
	var _t1462 = null
	if J.t((J.mc(J.G.get("OFFICE"), "seated", [_s440["n"]]) if J.t(_s440["__p"]["OF"]) else _s440["__p"]["OF"])):
		_t1462 = J.sub(J.mc(J.G.get("OFFICE"), "kenZ", [_s440["n"]]), 0.0001)
	else:
		var _t1461 = (not J.leq(J.gp(_s440["n"], "vY"), null))
		_t1462 = (J.gp(_s440["n"], "vY") if ((not J.t(J.gp(_s440["n"], "gone"))) if _t1461 else _t1461) else J.gp(J.mc(_s440["__p"]["this"], "visPos", [_s440["n"]]), 1.0))
	return [_t1462, Callable(self, "_f210").bind(_s440)]

func _f211(this_, a: Array, env):
	var v_a_807 = null; var v_c_808 = null
	v_a_807 = J.arg(a, 0)
	v_c_808 = J.arg(a, 1)
	return J.sub(J.gp(v_a_807, 0.0), J.gp(v_c_808, 0.0))

func _f212(this_, a: Array, env):
	var v_a_822 = null; var v_b_823 = null
	v_a_822 = J.arg(a, 0)
	v_b_823 = J.arg(a, 1)
	return J.sub(J.gp(v_b_823, 2.0), J.gp(v_a_822, 2.0))

func _f213(this_, a: Array, env):
	var v_r_828 = null
	v_r_828 = J.arg(a, 0)
	var _t1494 = (absf(J.num(J.sub(J.gp(v_r_828, 0.0), J.gp(env["__p"]["q"], 1.0)))) < 100.0)
	var _t1495 = (J.cmp(J.sub(J.sub(env["y"], 20.0), env["ext"]), J.add(J.gp(v_r_828, 1.0), 9.0), "<") if _t1494 else _t1494)
	return (J.cmp(J.add(env["y"], 9.0), J.sub(J.sub(J.gp(v_r_828, 1.0), 20.0), J.gp(v_r_828, 3.0)), ">") if _t1495 else _t1495)

func _f214(this_, a: Array, env):
	var v_q_829 = null
	v_q_829 = J.arg(a, 0)
	return J.seq(J.gp(v_q_829, 0.0), env["sel"])

func _f215(this_, a: Array, env):
	var v_r_833 = null
	v_r_833 = J.arg(a, 0)
	return [J.sub(J.gp(v_r_833, 0.0), 52.0), J.sub(J.sub(J.gp(v_r_833, 1.0), 22.0), J.gp(v_r_833, 3.0)), 104.0, J.add(32.0, J.gp(v_r_833, 3.0))]

func _f216(this_, a: Array, env):
	var v_q_836 = null
	v_q_836 = J.arg(a, 0)
	var _t1522 = J.gp(J.gp(v_q_836, 0.0), "bub")
	return ((not J.t(J.gp(J.gp(v_q_836, 0.0), "out"))) if J.t(_t1522) else _t1522)

func _f217(this_, a: Array, env):
	var v_a_837 = null; var v_b_838 = null
	v_a_837 = J.arg(a, 0)
	v_b_838 = J.arg(a, 1)
	var _t1527 = J.sub(J.seq(J.gp(v_b_838, 0.0), J.gp(env["this"], "sel")), J.seq(J.gp(v_a_837, 0.0), J.gp(env["this"], "sel")))
	if not J.t(_t1527):
		var _t1524 = J.gp(J.gp(v_b_838, 0.0), "bubAt")
		var _t1526 = (_t1524 if J.t(_t1524) else 0.0)
		var _t1525 = J.gp(J.gp(v_a_837, 0.0), "bubAt")
		_t1527 = J.sub(_t1526, (_t1525 if J.t(_t1525) else 0.0))
	return _t1527

func _f218(this_, a: Array, env):
	var v_q_839 = null
	v_q_839 = J.arg(a, 0)
	return J.gp(v_q_839, 0.0)

func _f206(this_, a: Array, env):
	var v_c_770 = null; var v_ctx_771 = null; var v_b_772 = null; var v_img_773 = null; var v_W_774 = null; var v_H_775 = null; var v_g_777 = null; var v_list_778 = null; var v_zs_780 = null; var v_sp_782 = null; var v_vg_783 = null; var v_f_784 = null; var v_gx_786 = null; var v_gy0_787 = null; var v_gy_788 = null; var v_ex_789 = null; var v_len_790 = null; var v_grd_791 = null; var v_f_792 = null; var v_x_793 = null; var v_y_794 = null; var v_hh_795 = null; var v_r_796 = null; var v_g_797 = null; var v_on_798 = null; var v_g_799 = null; var v_cx0_800 = null; var v_cy0_801 = null; var v_g2_802 = null; var v_z_809 = null; var v_f_810 = null; var v_p_811 = null; var v_px_812 = null; var v_py_813 = null; var v_f_814 = null; var v_f_815 = null; var v_x_816 = null; var v_y_817 = null; var v_hh_818 = null; var v_a_819 = null; var v_placed_820 = null; var v_k_826 = null; var v_o_827 = null; var v_m_830 = null; var v_x_831 = null; var v_by_832 = null; var v_nb_834 = null; var v_bs_835 = null; var v_n_840 = null; var v_x_841 = null; var v_by_842 = null; var v_mark_843 = null; var v_bw_844 = null; var v_f_845 = null; var v_hk_846 = null; var v_shk_847 = null; var v_bh_848 = null; var v_nw2_849 = null; var v_ex_850 = null; var v_ey_851 = null; var v_op_852 = null; var v_red_853 = null; var v_nw_854 = null; var v_a_855 = null; var v_b_856 = null; var v_tx_857 = null; var v_tw_858 = null; var v_pw_859 = null; var v_pr_860 = null; var v_fy_861 = null; var v_pop_862 = null; var v_ms_863 = null; var v_f_864 = null; var v_k_865 = null; var v_x_866 = null; var v_y_867 = null; var v_al_868 = null; var v_w_869 = null; var v_e_870 = null; var v_bx_871 = null; var v_by_872 = null; var v_bw_873 = null; var v_bh_874 = null; var v_q_875 = null
	var _s426 = {"__p": env, "this": null, "t": null, "OF": null, "tags": null, "sel": null}
	_s426["this"] = this_
	_s426["t"] = J.arg(a, 0)
	var _t1419 = J.gp(_s426["this"], "_nat")
	if J.t(((not J.t(J.gp(_s426["this"], "_natCtx"))) if J.t(_t1419) else _t1419)):
		return null
	var _t1421 = null
	if J.t(J.gp(_s426["this"], "_natCtx")):
		_t1421 = null
	else:
		var _t1420 = J.G.get("$")
		_t1421 = J.cl(_t1420, null, ["#sc-cvs"])
	v_c_770 = _t1421
	var _t1422 = (not J.t(J.gp(_s426["this"], "_natCtx")))
	if ((not J.t(v_c_770)) if _t1422 else _t1422):
		return null
	var _t1423 = J.gp(_s426["this"], "_natCtx")
	v_ctx_771 = (_t1423 if J.t(_t1423) else J.mc(v_c_770, "getContext", ["2d"]))
	J.mc(v_ctx_771, "setTransform", [J.gp(_s426["this"], "dpr"), 0.0, 0.0, J.gp(_s426["this"], "dpr"), 0.0, 0.0])
	v_b_772 = J.mc(_s426["this"], "bgScale", [])
	v_img_773 = J.gp(J.G.get("SPR"), J.add("bg_", J.gp(J.gp(_s426["this"], "site"), "bg")))
	v_W_774 = J.gp(_s426["this"], "W")
	v_H_775 = J.gp(_s426["this"], "H")
	J.mc(v_ctx_771, "save", [])
	if J.cmp(J.gp(_s426["this"], "shake"), 0.0, ">"):
		J.mc(v_ctx_771, "translate", [J.mul(((randf() - 0.5) * 10.0), J.gp(_s426["this"], "shake")), J.mul(((randf() - 0.5) * 8.0), J.gp(_s426["this"], "shake"))])
	J.sp(v_ctx_771, "fillStyle", "#0d0b10")
	J.mc(v_ctx_771, "fillRect", [(-20.0), (-20.0), J.add(v_W_774, 40.0), J.add(v_H_775, 40.0)])
	_s426["OF"] = J.mc(_s426["this"], "office", [])
	if J.t(_s426["OF"]):
		J.mc(J.G.get("OFFICE"), "drawBack", [v_ctx_771, _s426["t"]])
	else:
		if J.t((J.gp(v_img_773, "complete") if J.t(v_img_773) else v_img_773)):
			J.mc(v_ctx_771, "drawImage", [v_img_773, J.gp(v_b_772, "ox"), J.gp(v_b_772, "oy"), J.mul(J.gp(v_b_772, "iw"), J.gp(v_b_772, "s")), J.mul(J.gp(v_b_772, "ih"), J.gp(v_b_772, "s"))])
	var _t1424 = ("rgba(12,10,34," + J.str(((0.12 if J.t(_s426["OF"]) else 0.22) + (0.1 * sin(J.num((J.div(J.gp(_s426["this"], "t"), J.G.get("NIGHT_SEC")) * PI)))))) + ")")
	J.sp(v_ctx_771, "fillStyle", _t1424)
	J.mc(v_ctx_771, "fillRect", [0.0, 0.0, v_W_774, v_H_775])
	if J.t(_s426["OF"]):
		for _t1425 in J.iter(J.gp(_s426["this"], "fx")):
			v_f_784 = _t1425
			var _t1426 = J.seq(J.gp(v_f_784, "kind"), "ghost")
			if (J.seq(J.gp(v_f_784, "ghost"), "pontianak") if _t1426 else _t1426):
				J.mc(v_ctx_771, "save", [])
				J.mc(J.G.get("OFFICE"), "clipWindow", [v_ctx_771])
				J.mc(_s426["this"], "drawGhost", [v_ctx_771, v_f_784, _s426["t"]])
				J.mc(v_ctx_771, "restore", [])
	if J.t(_s426["OF"]):
		J.mc(J.G.get("OFFICE"), "drawFloor", [v_ctx_771, _s426["t"]])
	if (not J.t(_s426["OF"])):
		J.mc(_s426["this"], "propMarks", [v_ctx_771, _s426["t"]])
	var _t1427 = J.gp(_s426["this"], "npcs")
	v_g_777 = J.mc(_t1427, "find", [Callable(self, "_f207").bind(_s426)])
	if J.t(v_g_777):
		var _t1431 = J.mc(_s426["this"], "pt", [J.gp(v_g_777, "x"), J.gp(v_g_777, "y")])
		var _t1432 = J.gp(_t1431, 0.0)
		v_gx_786 = _t1432
		var _t1433 = J.gp(_t1431, 1.0)
		v_gy0_787 = _t1433
		v_gy_788 = (J.sub(v_gy0_787, J.mul(J.mc(_s426["this"], "hh", [J.gp(v_g_777, "y")]), 0.5)) if J.t(J.mc(_s426["this"], "persp", [])) else J.gp(J.mc(_s426["this"], "pt", [J.gp(v_g_777, "x"), J.sub(J.gp(v_g_777, "y"), 0.08)]), 1.0))
		var _t1434 = J.mc(_s426["this"], "pt", [J.add(J.gp(v_g_777, "x"), J.mul(J.gp(v_g_777, "dir"), 0.4)), 0.0])
		var _t1435 = J.gp(_t1434, 0.0)
		v_ex_789 = _t1435
		v_len_790 = absf(J.num(J.sub(v_ex_789, v_gx_786)))
		v_grd_791 = J.mc(v_ctx_771, "createLinearGradient", [v_gx_786, 0.0, v_ex_789, 0.0])
		J.mc(v_grd_791, "addColorStop", [0.0, "rgba(255,240,170,.42)"])
		J.mc(v_grd_791, "addColorStop", [1.0, "rgba(255,240,170,0)"])
		J.sp(v_ctx_771, "fillStyle", v_grd_791)
		J.mc(v_ctx_771, "beginPath", [])
		J.mc(v_ctx_771, "moveTo", [v_gx_786, v_gy_788])
		J.mc(v_ctx_771, "lineTo", [v_ex_789, (J.sub(v_gy_788, J.mul(v_len_790, 0.35)) - 8.0)])
		J.mc(v_ctx_771, "lineTo", [v_ex_789, J.add(J.add(v_gy_788, J.mul(v_len_790, 0.35)), 8.0)])
		J.mc(v_ctx_771, "closePath", [])
		J.mc(v_ctx_771, "fill", [])
	for _t1436 in J.iter(J.gp(_s426["this"], "fx")):
		v_f_792 = _t1436
		var _t1437 = J.seq(J.gp(v_f_792, "kind"), "ac")
		var _t1438 = ((not J.t(J.gp(v_f_792, "n"))) if _t1437 else _t1437)
		if ((not J.t(J.gp(J.gp(_s426["this"], "site"), "pano"))) if _t1438 else _t1438):
			var _t1439 = ("rgba(150,200,255," + J.str(J.div(J.mul(0.16, J.gp(v_f_792, "life")), 2.2)) + ")")
			J.sp(v_ctx_771, "fillStyle", _t1439)
			J.mc(v_ctx_771, "fillRect", [0.0, 0.0, v_W_774, v_H_775])
		var _t1440 = J.seq(J.gp(v_f_792, "kind"), "lamp")
		var _t1441 = (_t1440 if _t1440 else J.seq(J.gp(v_f_792, "kind"), "lights"))
		var _t1442 = (_t1441 if _t1441 else J.seq(J.gp(v_f_792, "kind"), "ac"))
		var _t1443 = (J.gp(v_f_792, "n") if _t1442 else _t1442)
		if J.t(((not J.t(J.gp(J.gp(v_f_792, "n"), "gone"))) if J.t(_t1443) else _t1443)):
			var _t1444 = J.mc(_s426["this"], "pt", [J.gp(J.gp(v_f_792, "n"), "x"), J.gp(J.gp(v_f_792, "n"), "y")])
			var _t1445 = J.gp(_t1444, 0.0)
			v_x_793 = _t1445
			var _t1446 = J.gp(_t1444, 1.0)
			v_y_794 = _t1446
			v_hh_795 = J.mc(_s426["this"], "hh", [J.gp(J.gp(v_f_792, "n"), "y")])
			v_r_796 = J.mul(v_hh_795, 0.9)
			if J.seq(J.gp(v_f_792, "kind"), "ac"):
				v_g_797 = J.mc(v_ctx_771, "createRadialGradient", [v_x_793, J.sub(v_y_794, J.mul(v_hh_795, 0.6)), 0.0, v_x_793, J.sub(v_y_794, J.mul(v_hh_795, 0.6)), v_r_796])
				J.mc(v_g_797, "addColorStop", [0.0, ("rgba(170,215,255," + J.str(J.div(J.mul(0.32, J.gp(v_f_792, "life")), 2.2)) + ")")])
				J.mc(v_g_797, "addColorStop", [1.0, "rgba(170,215,255,0)"])
				J.sp(v_ctx_771, "fillStyle", v_g_797)
				J.mc(v_ctx_771, "fillRect", [J.sub(v_x_793, v_r_796), J.sub(J.sub(v_y_794, J.mul(v_hh_795, 0.6)), v_r_796), J.mul(v_r_796, 2.0), J.mul(v_r_796, 2.0)])
			else:
				v_on_798 = ((sin(J.num(J.mul(_s426["t"], 38.0))) + sin(J.num(J.mul(_s426["t"], 17.0)))) > 0.4)
				v_g_799 = J.mc(v_ctx_771, "createRadialGradient", [v_x_793, J.sub(v_y_794, J.mul(v_hh_795, 0.5)), 0.0, v_x_793, J.sub(v_y_794, J.mul(v_hh_795, 0.5)), J.mul(v_r_796, 1.1)])
				J.mc(v_g_799, "addColorStop", [0.0, ("rgba(255,245,200,.22)" if J.t(v_on_798) else "rgba(0,0,0,.55)")])
				J.mc(v_g_799, "addColorStop", [1.0, "rgba(0,0,0,0)"])
				J.sp(v_ctx_771, "fillStyle", v_g_799)
				J.mc(v_ctx_771, "fillRect", [J.sub(v_x_793, J.mul(v_r_796, 1.1)), (J.sub(v_y_794, J.mul(v_hh_795, 0.5)) - J.mul(v_r_796, 1.1)), J.mul(v_r_796, 2.2), J.mul(v_r_796, 2.2)])
				if J.seq(J.gp(v_f_792, "kind"), "lights"):
					var _t1447 = J.mc(_s426["this"], "pt", [J.gp(J.gp(v_f_792, "n"), "x"), 0.17])
					var _t1448 = J.gp(_t1447, 0.0)
					v_cx0_800 = _t1448
					var _t1449 = J.gp(_t1447, 1.0)
					v_cy0_801 = _t1449
					var _t1450 = ("rgba(255,250,215,.9)" if J.t(v_on_798) else "rgba(90,90,110,.6)")
					J.sp(v_ctx_771, "strokeStyle", _t1450)
					J.sp(v_ctx_771, "lineWidth", 4.0)
					J.mc(v_ctx_771, "beginPath", [])
					J.mc(v_ctx_771, "moveTo", [J.sub(v_cx0_800, J.mul(v_hh_795, 0.3)), v_cy0_801])
					J.mc(v_ctx_771, "lineTo", [J.add(v_cx0_800, J.mul(v_hh_795, 0.3)), v_cy0_801])
					J.mc(v_ctx_771, "stroke", [])
					if J.t(v_on_798):
						v_g2_802 = J.mc(v_ctx_771, "createLinearGradient", [0.0, v_cy0_801, 0.0, v_y_794])
						J.mc(v_g2_802, "addColorStop", [0.0, "rgba(255,250,215,.18)"])
						J.mc(v_g2_802, "addColorStop", [1.0, "rgba(255,250,215,0)"])
						J.sp(v_ctx_771, "fillStyle", v_g2_802)
						J.mc(v_ctx_771, "beginPath", [])
						J.mc(v_ctx_771, "moveTo", [J.sub(v_cx0_800, J.mul(v_hh_795, 0.3)), v_cy0_801])
						J.mc(v_ctx_771, "lineTo", [J.add(v_cx0_800, J.mul(v_hh_795, 0.3)), v_cy0_801])
						J.mc(v_ctx_771, "lineTo", [J.add(v_x_793, J.mul(v_hh_795, 0.5)), v_y_794])
						J.mc(v_ctx_771, "lineTo", [J.sub(v_x_793, J.mul(v_hh_795, 0.5)), v_y_794])
						J.mc(v_ctx_771, "closePath", [])
						J.mc(v_ctx_771, "fill", [])
	J.mc(_s426["this"], "drawTeam", [v_ctx_771, _s426["t"]])
	var _t1451 = J.gp(_s426["this"], "npcs")
	v_list_778 = J.mc(_t1451, "filter", [Callable(self, "_f208").bind(_s426)])
	_s426["tags"] = []
	v_zs_780 = J.mc(v_list_778, "map", [Callable(self, "_f209").bind(_s426)])
	if J.t(_s426["OF"]):
		J.mc(v_zs_780, "push", J.spread([J.SP(J.mc(J.G.get("OFFICE"), "drawables", [_s426["t"]]))]))
		if J.t(J.gp(J.gp(_s426["this"], "site"), "pano")):
			J.mc(v_zs_780, "push", J.spread([J.SP(J.mc(J.G.get("OFFMAP"), "drawables", []))]))
	J.mc(v_zs_780, "sort", [Callable(self, "_f211").bind(_s426)])
	for _t1465 in J.iter(v_zs_780):
		v_z_809 = _t1465
		J.mc(v_z_809, 1.0, [v_ctx_771])
	if J.t(_s426["OF"]):
		J.mc(J.G.get("OFFICE"), "drawDark", [v_ctx_771, _s426["t"]])
		if J.t(J.gp(J.gp(_s426["this"], "site"), "pano")):
			J.mc(J.G.get("OFFMAP"), "drawOver", [v_ctx_771, _s426["t"]])
		J.mc(_s426["this"], "propMarks", [v_ctx_771, _s426["t"]])
	if (not J.seq(J.typeof_(J.G.get("ScareX")), "undefined")):
		J.mc(J.G.get("ScareX"), "draw", [_s426["this"], v_ctx_771, _s426["t"]])
	for _t1466 in J.iter(J.gp(_s426["this"], "fx")):
		v_f_810 = _t1466
		var _t1467 = J.seq(J.gp(v_f_810, "kind"), "ghost")
		if ((not J.t((J.seq(J.gp(v_f_810, "ghost"), "pontianak") if J.t(_s426["OF"]) else _s426["OF"]))) if _t1467 else _t1467):
			J.mc(_s426["this"], "drawGhost", [v_ctx_771, v_f_810, _s426["t"]])
	for _t1468 in J.iter(J.gp(_s426["this"], "parts")):
		v_p_811 = _t1468
		if J.cmp(J.gp(v_p_811, "delay"), 0.0, ">"):
			continue
		var _t1469 = J.mc(_s426["this"], "pt", [J.gp(v_p_811, "x"), J.gp(v_p_811, "y")])
		var _t1470 = J.gp(_t1469, 0.0)
		v_px_812 = _t1470
		var _t1471 = J.gp(_t1469, 1.0)
		v_py_813 = _t1471
		if J.seq(J.gp(v_p_811, "kind"), "paper"):
			J.mc(v_ctx_771, "save", [])
			J.mc(v_ctx_771, "translate", [v_px_812, v_py_813])
			J.mc(v_ctx_771, "rotate", [J.gp(v_p_811, "rot")])
			J.sp(v_ctx_771, "fillStyle", "#f4f0e6")
			J.sp(v_ctx_771, "strokeStyle", "#555")
			J.sp(v_ctx_771, "lineWidth", 0.8)
			J.mc(v_ctx_771, "fillRect", [(-7.0), (-9.0), 14.0, 18.0])
			J.mc(v_ctx_771, "strokeRect", [(-7.0), (-9.0), 14.0, 18.0])
			J.sp(v_ctx_771, "fillStyle", "#b44")
			J.mc(v_ctx_771, "fillRect", [(-4.0), (-5.0), 8.0, 1.5])
			J.mc(v_ctx_771, "restore", [])
		if J.seq(J.gp(v_p_811, "kind"), "frost"):
			var _t1472 = ("rgba(220,240,255," + J.str(J.min_([1.0, J.gp(v_p_811, "life")])) + ")")
			J.sp(v_ctx_771, "fillStyle", _t1472)
			J.mc(v_ctx_771, "beginPath", [])
			J.mc(v_ctx_771, "arc", [v_px_812, v_py_813, 2.2, 0.0, (PI * 2.0)])
			J.mc(v_ctx_771, "fill", [])
		if J.seq(J.gp(v_p_811, "kind"), "bubble"):
			var _t1473 = ("rgba(190,230,255," + J.str(J.min_([1.0, J.gp(v_p_811, "life")])) + ")")
			J.sp(v_ctx_771, "strokeStyle", _t1473)
			J.sp(v_ctx_771, "lineWidth", 1.2)
			J.mc(v_ctx_771, "beginPath", [])
			J.mc(v_ctx_771, "arc", [v_px_812, v_py_813, 3.0, 0.0, (PI * 2.0)])
			J.mc(v_ctx_771, "stroke", [])
		if J.seq(J.gp(v_p_811, "kind"), "sweat"):
			J.sp(v_ctx_771, "fillStyle", "rgba(150,210,255,.9)")
			J.mc(v_ctx_771, "beginPath", [])
			J.mc(v_ctx_771, "ellipse", [v_px_812, v_py_813, 2.5, 4.0, 0.0, 0.0, (PI * 2.0)])
			J.mc(v_ctx_771, "fill", [])
		if J.seq(J.gp(v_p_811, "kind"), "dust"):
			var _t1474 = ("rgba(200,190,170," + J.str(J.gp(v_p_811, "life")) + ")")
			J.sp(v_ctx_771, "fillStyle", _t1474)
			J.mc(v_ctx_771, "beginPath", [])
			J.mc(v_ctx_771, "arc", [v_px_812, v_py_813, (6.0 * J.sub(1.2, J.gp(v_p_811, "life"))), 0.0, (PI * 2.0)])
			J.mc(v_ctx_771, "fill", [])
		if J.seq(J.gp(v_p_811, "kind"), "drop"):
			var _t1475 = ("rgba(170,210,230," + J.str(J.mul(J.gp(v_p_811, "life"), 0.4)) + ")")
			J.sp(v_ctx_771, "fillStyle", _t1475)
			J.mc(v_ctx_771, "beginPath", [])
			J.mc(v_ctx_771, "ellipse", [v_px_812, v_py_813, 9.0, 3.0, 0.0, 0.0, (PI * 2.0)])
			J.mc(v_ctx_771, "fill", [])
	for _t1476 in J.iter(J.gp(_s426["this"], "fx")):
		v_f_814 = _t1476
		var _t1477 = J.seq(J.gp(v_f_814, "kind"), "breath")
		if ((not J.t(J.gp(J.gp(v_f_814, "n"), "gone"))) if _t1477 else _t1477):
			J.mc(_s426["this"], "drawBreath", [v_ctx_771, v_f_814, _s426["t"]])
	for _t1478 in J.iter(J.gp(_s426["this"], "fx")):
		v_f_815 = _t1478
		var _t1479 = J.seq(J.gp(v_f_815, "kind"), "phone")
		if ((not J.t(J.gp(J.gp(v_f_815, "n"), "gone"))) if _t1479 else _t1479):
			var _t1480 = J.mc(_s426["this"], "pt", [(J.gp(J.gp(v_f_815, "n"), "vX") if (not J.leq(J.gp(J.gp(v_f_815, "n"), "vX"), null)) else J.gp(J.gp(v_f_815, "n"), "x")), (J.gp(J.gp(v_f_815, "n"), "vY") if (not J.leq(J.gp(J.gp(v_f_815, "n"), "vY"), null)) else J.gp(J.gp(v_f_815, "n"), "y"))])
			var _t1481 = J.gp(_t1480, 0.0)
			v_x_816 = _t1481
			var _t1482 = J.gp(_t1480, 1.0)
			v_y_817 = _t1482
			var _t1484 = J.mc(_s426["this"], "hh", [J.gp(J.gp(v_f_815, "n"), "y")])
			var _t1483 = J.mc(_s426["this"], "office", [])
			v_hh_818 = J.mul(_t1484, (0.8 if J.t((J.mc(J.G.get("OFFICE"), "seated", [J.gp(v_f_815, "n")]) if J.t(_t1483) else _t1483)) else 1.0))
			v_a_819 = (0.5 + (0.5 * sin(J.num(J.mul(_s426["t"], 20.0)))))
			var _t1485 = ("rgba(120,255,170," + J.str(J.mul(0.35, v_a_819)) + ")")
			J.sp(v_ctx_771, "fillStyle", _t1485)
			J.mc(v_ctx_771, "beginPath", [])
			J.mc(v_ctx_771, "arc", [J.add(v_x_816, (J.mul(J.gp(J.gp(v_f_815, "n"), "dir"), v_hh_818) * 0.05)), J.sub(v_y_817, J.mul(v_hh_818, 0.62)), J.mul(v_hh_818, 0.18), 0.0, (PI * 2.0)])
			J.mc(v_ctx_771, "fill", [])
	v_placed_820 = []
	var _t1487 = J.mc(_s426["tags"], "slice", [])
	for _t1486 in J.iter(J.mc(_t1487, "sort", [Callable(self, "_f212").bind(_s426)])):
		var _s459 = {"__p": _s426, "q": null}
		_s459["q"] = _t1486
		var _s461 = {"__p": _s459, "ext": null, "y": null}
		if J.t(J.gp(J.gp(_s461["__p"]["q"], 0.0), "out")):
			continue
		var _t1488 = _s461["__p"]["q"]
		var _t1489 = J.gp(_s461["__p"]["__p"]["this"], "W")
		var _t1490 = J.gp(_s461["__p"]["__p"]["this"], "W")
		var _t1491 = J.gp(_s461["__p"]["__p"]["this"], "W")
		var _t1492 = J.gp(_s461["__p"]["__p"]["this"], "W")
		var _t1493 = J.max_([56.0, J.min_([J.sub((_t1492 if J.t(_t1492) else 390.0), 58.0), J.gp(_s461["__p"]["q"], 1.0)])])
		J.sp(_t1488, 1.0, _t1493)
		_s461["ext"] = J.mc(_s461["__p"]["__p"]["this"], "tagExt", [J.gp(_s461["__p"]["q"], 0.0)])
		_s461["y"] = J.gp(_s461["__p"]["q"], 2.0)
		v_k_826 = 0.0
		while true:
			if not J.cmp(v_k_826, 8.0, "<"): break
			v_o_827 = J.mc(v_placed_820, "find", [Callable(self, "_f213").bind(_s461)])
			if (not J.t(v_o_827)):
				break
			var _t1496 = ((J.sub(J.sub(J.gp(v_o_827, 1.0), 20.0), J.gp(v_o_827, 3.0)) - 9.0) - 2.0)
			_s461["y"] = _t1496
			v_k_826 = J.num(v_k_826) + 1.0
		var _t1497 = _s461["__p"]["q"]
		var _t1498 = _s461["y"]
		J.sp(_t1497, 2.0, _t1498)
		J.mc(v_placed_820, "push", [[J.gp(_s461["__p"]["q"], 1.0), _s461["y"], 8.0, _s461["ext"]]])
	var _t1499 = _s426["this"]
	J.sp(_t1499, "_tagR", v_placed_820)
	var _t1500 = J.gp(_s426["this"], "sel")
	var _t1501 = ((not J.t(J.gp(J.gp(_s426["this"], "sel"), "gone"))) if J.t(_t1500) else _t1500)
	var _t1502 = ((not J.t(J.gp(J.gp(_s426["this"], "sel"), "out"))) if J.t(_t1501) else _t1501)
	var _t1503 = ((not J.t(J.gp(J.gp(_s426["this"], "sel"), "fleeing"))) if J.t(_t1502) else _t1502)
	_s426["sel"] = (J.gp(_s426["this"], "sel") if J.t(((not J.t(J.gp(J.gp(J.gp(_s426["this"], "sel"), "d"), "guard"))) if J.t(_t1503) else _t1503)) else null)
	v_sp_782 = (J.mc(_s426["tags"], "find", [Callable(self, "_f214").bind(_s426)]) if J.t(_s426["sel"]) else _s426["sel"])
	if J.t(v_sp_782):
		J.mc(v_ctx_771, "save", [])
		J.mc(v_ctx_771, "setLineDash", [[6.0, 5.0]])
		var _t1504 = ((-J.num(_s426["t"])) * 20.0)
		J.sp(v_ctx_771, "lineDashOffset", _t1504)
		J.sp(v_ctx_771, "lineWidth", 2.0)
		J.sp(v_ctx_771, "strokeStyle", "rgba(255,90,80,.75)")
		for _t1505 in J.iter(_s426["tags"]):
			var _t1506 = J.gp(_t1505, 0.0)
			v_m_830 = _t1506
			var _t1507 = J.gp(_t1505, 1.0)
			v_x_831 = _t1507
			var _t1508 = J.gp(_t1505, 2.0)
			v_by_832 = _t1508
			var _t1509 = (not J.seq(v_m_830, _s426["sel"]))
			var _t1510 = ((not J.t(J.gp(v_m_830, "out"))) if _t1509 else _t1509)
			if J.t((J.mc(_s426["this"], "sees", [v_m_830, _s426["sel"]]) if _t1510 else _t1510)):
				J.mc(v_ctx_771, "beginPath", [])
				J.mc(v_ctx_771, "moveTo", [v_x_831, J.add(v_by_832, 6.0)])
				J.mc(v_ctx_771, "lineTo", [J.gp(v_sp_782, 1.0), J.sub(J.gp(v_sp_782, 2.0), 4.0)])
				J.mc(v_ctx_771, "stroke", [])
		J.mc(v_ctx_771, "restore", [])
	var _t1511 = _s426["this"]
	var _t1512 = J.gp(_s426["this"], "_bubR")
	var _t1513 = (_t1512 if J.t(_t1512) else [])
	var _t1514 = J.gp(_s426["this"], "_nTag")
	var _t1515 = J.mc(_t1513, "slice", [(_t1514 if J.t(_t1514) else 0.0)])
	J.sp(_t1511, "_bubLast", _t1515)
	var _t1516 = _s426["this"]
	var _t1517 = J.gp(_s426["this"], "_tagR")
	var _t1518 = (_t1517 if J.t(_t1517) else [])
	var _t1519 = J.mc(_t1518, "map", [Callable(self, "_f215").bind(_s426)])
	J.sp(_t1516, "_bubR", _t1519)
	var _t1520 = _s426["this"]
	var _t1521 = J.len(J.gp(_s426["this"], "_bubR"))
	J.sp(_t1520, "_nTag", _t1521)
	v_nb_834 = 0.0
	var _t1523 = J.mc(_s426["tags"], "filter", [Callable(self, "_f216").bind(_s426)])
	v_bs_835 = J.mc(_t1523, "sort", [Callable(self, "_f217").bind(_s426)])
	var _t1528 = _s426["this"]
	var _t1529 = J.mc(v_bs_835, "slice", [0.0, 2.0])
	var _t1530 = J.new_("Set", [J.mc(_t1529, "map", [Callable(self, "_f218").bind(_s426)])])
	J.sp(_t1528, "_bubOK", _t1530)
	for _t1531 in J.iter(_s426["tags"]):
		var _t1532 = J.gp(_t1531, 0.0)
		v_n_840 = _t1532
		var _t1533 = J.gp(_t1531, 1.0)
		v_x_841 = _t1533
		var _t1534 = J.gp(_t1531, 2.0)
		v_by_842 = _t1534
		if J.t(J.gp(v_n_840, "out")):
			continue
		var _t1535 = J.gp(_s426["this"], "_nat")
		if J.t(((not J.seq(J.typeof_(J.G.get("__nat_scTag")), "undefined")) if J.t(_t1535) else _t1535)):
			var _t1536 = J.G.get("__nat_scTag")
			J.cl(_t1536, null, [v_ctx_771, _s426["this"], v_n_840, v_x_841, v_by_842, _s426["t"], _s426["sel"]])
			var _t1537 = J.gp(v_n_840, "step")
			if J.t((J.gp(J.gp(v_n_840, "step"), "cue") if J.t(_t1537) else _t1537)):
				J.mc(_s426["this"], "drawCue", [v_ctx_771, v_n_840, v_x_841, v_by_842, _s426["t"]])
		else:
			J.sp(v_ctx_771, "font", "700 11px sans-serif")
			v_nw2_849 = J.div(J.gp(J.mc(v_ctx_771, "measureText", [J.gp(J.gp(v_n_840, "d"), "name")]), "width"), 2.0)
			v_ex_850 = (J.sub(v_x_841, v_nw2_849) - 12.0)
			v_ey_851 = J.sub(v_by_842, 10.0)
			v_op_852 = J.mc(_s426["this"], "watching", [v_n_840])
			var _t1538 = ((not J.seq(v_n_840, _s426["sel"])) if J.t(_s426["sel"]) else _s426["sel"])
			v_red_853 = (J.mc(_s426["this"], "sees", [v_n_840, _s426["sel"]]) if J.t(_t1538) else _t1538)
			J.mc(v_ctx_771, "save", [])
			J.sp(v_ctx_771, "fillStyle", "rgba(0,0,0,.6)")
			J.mc(v_ctx_771, "beginPath", [])
			J.mc(v_ctx_771, "arc", [v_ex_850, v_ey_851, 7.5, 0.0, (PI * 2.0)])
			J.mc(v_ctx_771, "fill", [])
			J.sp(v_ctx_771, "lineWidth", 1.6)
			if J.t(v_op_852):
				var _t1539 = ("#ff6a5a" if J.t(v_red_853) else "#f2f2f2")
				J.sp(v_ctx_771, "fillStyle", _t1539)
				J.mc(v_ctx_771, "beginPath", [])
				J.mc(v_ctx_771, "ellipse", [v_ex_850, v_ey_851, 5.5, 3.5, 0.0, 0.0, (PI * 2.0)])
				J.mc(v_ctx_771, "fill", [])
				J.sp(v_ctx_771, "fillStyle", "#111")
				J.mc(v_ctx_771, "beginPath", [])
				var _t1540 = J.gp(v_n_840, "dir")
				J.mc(v_ctx_771, "arc", [J.add(v_ex_850, J.mul((_t1540 if J.t(_t1540) else 1.0), 1.2)), v_ey_851, 2.0, 0.0, (PI * 2.0)])
				J.mc(v_ctx_771, "fill", [])
			else:
				J.sp(v_ctx_771, "strokeStyle", "#9aa")
				J.mc(v_ctx_771, "beginPath", [])
				J.mc(v_ctx_771, "arc", [v_ex_850, J.sub(v_ey_851, 2.0), 4.5, (0.25 * PI), (0.75 * PI)])
				J.mc(v_ctx_771, "stroke", [])
			J.mc(v_ctx_771, "restore", [])
			var _t1541 = J.gp(v_n_840, "step")
			if J.t((J.gp(J.gp(v_n_840, "step"), "cue") if J.t(_t1541) else _t1541)):
				J.mc(_s426["this"], "drawCue", [v_ctx_771, v_n_840, v_x_841, v_by_842, _s426["t"]])
			v_bw_844 = 60.0
			v_f_845 = J.min_([1.0, J.div(J.gp(v_n_840, "fear"), 100.0)])
			var _t1542 = J.gp(v_n_840, "barHit")
			var _t1543 = J.gp(v_n_840, "barHit")
			v_hk_846 = J.max_([0.0, (_t1543 if J.t(_t1543) else 0.0)])
			v_shk_847 = J.cmp(J.gp(v_n_840, "shaken"), 0.0, ">")
			v_bh_848 = (6.0 + J.mul(v_hk_846, 3.0))
			J.sp(v_ctx_771, "fillStyle", "rgba(0,0,0,.65)")
			J.mc(v_ctx_771, "fillRect", [(J.sub(v_x_841, J.div(v_bw_844, 2.0)) - 2.0), (J.sub(v_by_842, 3.0) - J.mul(v_hk_846, 1.5)), J.add(v_bw_844, 4.0), J.add(v_bh_848, 4.0)])
			if J.t(v_shk_847):
				var _t1544 = ("rgba(255,90,80," + J.str((0.45 + (0.4 * sin(J.num(J.mul(_s426["t"], 7.0)))))) + ")")
				J.sp(v_ctx_771, "strokeStyle", _t1544)
				J.sp(v_ctx_771, "lineWidth", 1.6)
				J.mc(v_ctx_771, "strokeRect", [(J.sub(v_x_841, J.div(v_bw_844, 2.0)) - 2.5), (J.sub(v_by_842, 3.5) - J.mul(v_hk_846, 1.5)), J.add(v_bw_844, 5.0), J.add(v_bh_848, 5.0)])
			var _t1545 = ("#ff5a4a" if J.cmp(v_f_845, 0.5, ">=") else ("#ffb84a" if J.cmp(v_f_845, 0.25, ">=") else "#9be8b0"))
			J.sp(v_ctx_771, "fillStyle", _t1545)
			J.mc(v_ctx_771, "fillRect", [J.sub(v_x_841, J.div(v_bw_844, 2.0)), (J.sub(v_by_842, 1.0) - J.mul(v_hk_846, 1.5)), J.mul(v_bw_844, v_f_845), v_bh_848])
			if J.cmp(v_hk_846, 0.0, ">"):
				var _t1546 = ("rgba(255,255,255," + J.str(J.mul(v_hk_846, 0.75)) + ")")
				J.sp(v_ctx_771, "fillStyle", _t1546)
				J.mc(v_ctx_771, "fillRect", [J.sub(v_x_841, J.div(v_bw_844, 2.0)), (J.sub(v_by_842, 1.0) - J.mul(v_hk_846, 1.5)), J.mul(v_bw_844, v_f_845), v_bh_848])
			J.sp(v_ctx_771, "fillStyle", "rgba(255,255,255,.4)")
			J.mc(v_ctx_771, "fillRect", [(J.sub(v_x_841, J.div(v_bw_844, 2.0)) + J.mul(v_bw_844, 0.25)), J.sub(v_by_842, 2.0), 1.0, J.add(v_bh_848, 2.0)])
			J.mc(v_ctx_771, "fillRect", [(J.sub(v_x_841, J.div(v_bw_844, 2.0)) + J.mul(v_bw_844, 0.5)), J.sub(v_by_842, 2.0), 1.0, J.add(v_bh_848, 2.0)])
			J.sp(v_ctx_771, "font", "700 11px sans-serif")
			J.sp(v_ctx_771, "textAlign", "center")
			J.sp(v_ctx_771, "lineWidth", 3.0)
			J.sp(v_ctx_771, "strokeStyle", "rgba(0,0,0,.8)")
			J.mc(v_ctx_771, "strokeText", [J.gp(J.gp(v_n_840, "d"), "name"), v_x_841, J.sub(v_by_842, 6.0)])
			var _t1547 = ("#a8ffcf" if J.seq(v_n_840, J.gp(_s426["this"], "sel")) else "#eee")
			J.sp(v_ctx_771, "fillStyle", _t1547)
			J.mc(v_ctx_771, "fillText", [J.gp(J.gp(v_n_840, "d"), "name"), v_x_841, J.sub(v_by_842, 6.0)])
			var _t1549 = J.seq(v_n_840, _s426["sel"])
			if not J.t(_t1549):
				var _t1548 = J.cmp(J.gp(v_n_840, "mocked"), 0.0, ">")
				_t1549 = ((not J.t(J.gp(J.gp(v_n_840, "d"), "guard"))) if _t1548 else _t1548)
			if _t1549:
				v_nw_854 = (J.len(J.mc(_s426["this"], "witnesses", [v_n_840])) if J.seq(v_n_840, _s426["sel"]) else (-1.0))
				v_a_855 = ("" if J.cmp(v_nw_854, 0.0, "<") else ((J.str(v_nw_854) + "人望緊") if J.t(v_nw_854) else "冇人望緊"))
				v_b_856 = (("冇人信×" + J.str(J.min_([4.0, J.gp(v_n_840, "mocked")]))) if J.cmp(J.gp(v_n_840, "mocked"), 0.0, ">") else "")
				J.sp(v_ctx_771, "font", "800 11px sans-serif")
				var _t1550 = [v_a_855, v_b_856]
				var _t1551 = J.mc(_t1550, "filter", [J.G.get("Boolean")])
				v_tx_857 = J.mc(_t1551, "join", ["・"])
				v_tw_858 = J.gp(J.mc(v_ctx_771, "measureText", [v_tx_857]), "width")
				J.sp(v_ctx_771, "fillStyle", "rgba(10,8,18,.72)")
				J.mc(v_ctx_771, "beginPath", [])
				J.mc(v_ctx_771, "roundRect", [(J.sub(v_x_841, J.div(v_tw_858, 2.0)) - 6.0), J.sub(v_by_842, 33.0), J.add(v_tw_858, 12.0), 15.0, 7.5])
				J.mc(v_ctx_771, "fill", [])
				var _t1552 = ("#ff8a7a" if J.cmp(v_nw_854, 0.0, ">") else ("#d6a0ff" if J.t((J.cmp(v_nw_854, 0.0, "<") if J.t(v_b_856) else v_b_856)) else "#8fe8b0"))
				J.sp(v_ctx_771, "fillStyle", _t1552)
				J.mc(v_ctx_771, "fillText", [v_tx_857, v_x_841, J.sub(v_by_842, 21.5)])
		var _t1553 = J.gp(J.gp(v_n_840, "d"), "daoshi")
		if J.t((J.seq(J.gp(v_n_840, "ds"), "ritual") if J.t(_t1553) else _t1553)):
			v_pw_859 = 110.0
			var _t1554 = J.gp(v_n_840, "prog")
			var _t1555 = J.gp(v_n_840, "prog")
			v_pr_860 = J.min_([1.0, (_t1555 if J.t(_t1555) else 0.0)])
			v_fy_861 = J.add(J.gp(J.mc(_s426["this"], "pt", [J.gp(v_n_840, "x"), J.gp(v_n_840, "y")]), 1.0), 10.0)
			J.mc(v_ctx_771, "save", [])
			J.sp(v_ctx_771, "fillStyle", "rgba(0,0,0,.72)")
			J.mc(v_ctx_771, "fillRect", [(J.sub(v_x_841, J.div(v_pw_859, 2.0)) - 3.0), v_fy_861, J.add(v_pw_859, 6.0), 26.0])
			J.sp(v_ctx_771, "fillStyle", "#4a3a10")
			J.mc(v_ctx_771, "fillRect", [J.sub(v_x_841, J.div(v_pw_859, 2.0)), J.add(v_fy_861, 16.0), v_pw_859, 6.0])
			J.sp(v_ctx_771, "fillStyle", "#ffd36a")
			J.mc(v_ctx_771, "fillRect", [J.sub(v_x_841, J.div(v_pw_859, 2.0)), J.add(v_fy_861, 16.0), J.mul(v_pw_859, v_pr_860), 6.0])
			J.sp(v_ctx_771, "font", "800 11px sans-serif")
			J.sp(v_ctx_771, "textAlign", "center")
			J.sp(v_ctx_771, "fillStyle", "#ffe9a8")
			var _t1558 = J.round(J.num(J.mul(v_pr_860, 100.0)))
			var _t1557 = null
			if J.cmp(J.gp(v_n_840, "fear"), 50.0, ">="):
				_t1557 = "・嚇親停咗"
			else:
				var _t1556 = J.gp(_s426["this"], "expo")
				_t1557 = ("・冇動靜慢咗" if J.cmp((_t1556 if J.t(_t1556) else 0.0), 25.0, "<") else "")
			J.mc(v_ctx_771, "fillText", [("做法中 " + J.str(_t1558) + "%" + _t1557), v_x_841, J.add(v_fy_861, 12.0)])
			J.mc(v_ctx_771, "restore", [])
		var _t1559 = J.gp(_s426["this"], "_nat")
		v_mark_843 = ("" if J.t(((not J.seq(J.typeof_(J.G.get("__nat_scTag")), "undefined")) if J.t(_t1559) else _t1559)) else ("!!!" if J.t(J.gp(v_n_840, "fleeing")) else ("！" if J.cmp(J.gp(v_n_840, "fear"), 50.0, ">=") else ("？" if J.cmp(J.gp(v_n_840, "fear"), 25.0, ">=") else ""))))
		if J.t(v_mark_843):
			var _t1560 = J.gp(v_n_840, "markPop")
			var _t1561 = J.gp(v_n_840, "markPop")
			v_pop_862 = J.max_([0.0, (_t1561 if J.t(_t1561) else 0.0)])
			v_ms_863 = (1.0 + J.mul(v_pop_862, 0.8))
			J.sp(v_ctx_771, "font", "700 11px sans-serif")
			J.mc(v_ctx_771, "save", [])
			J.mc(v_ctx_771, "translate", [J.add(J.add(v_x_841, J.div(J.gp(J.mc(v_ctx_771, "measureText", [J.gp(J.gp(v_n_840, "d"), "name")]), "width"), 2.0)), (16.0 if (J.len(v_mark_843) > 1.0) else 10.0)), (J.sub(v_by_842, 3.0) - (absf(J.num(sin(J.num(J.mul(_s426["t"], 6.0))))) * 2.0))])
			var _t1562 = ("900 " + J.str((19.0 if J.cmp(J.gp(v_n_840, "fear"), 50.0, ">=") else 16.0)) + "px sans-serif")
			J.sp(v_ctx_771, "font", _t1562)
			J.sp(v_ctx_771, "textAlign", "center")
			var _t1563 = ("#ff6a5a" if J.cmp(J.gp(v_n_840, "fear"), 50.0, ">=") else "#ffd36a")
			J.sp(v_ctx_771, "fillStyle", _t1563)
			J.sp(v_ctx_771, "strokeStyle", "#000")
			J.sp(v_ctx_771, "lineWidth", 3.0)
			J.mc(v_ctx_771, "strokeText", [v_mark_843, 0.0, 0.0])
			J.mc(v_ctx_771, "fillText", [v_mark_843, 0.0, 0.0])
			J.mc(v_ctx_771, "restore", [])
		var _t1565 = J.gp(v_n_840, "bub")
		if J.t(_t1565):
			var _t1564 = J.gp(_s426["this"], "_bubOK")
			_t1565 = J.mc(_t1564, "has", [v_n_840])
		if J.t(_t1565):
			var _t1568 = J.gp(v_n_840, "bub")
			var _t1569 = J.sub(J.sub(v_by_842, 20.0), J.mc(_s426["this"], "tagExt", [v_n_840]))
			var _t1570 = J.gp(v_n_840, "bubG")
			var _t1567 = J.gp(_s426["this"], "t")
			var _t1566 = J.gp(v_n_840, "bubAt")
			J.mc(_s426["this"], "drawBubble", [v_ctx_771, _t1568, v_x_841, _t1569, _t1570, J.sub(_t1567, (_t1566 if J.t(_t1566) else 0.0))])
	if J.t(J.gp(J.gp(_s426["this"], "site"), "pano")):
		J.mc(_s426["this"], "drawEdge", [v_ctx_771, _s426["t"]])
	for _t1571 in J.iter(J.gp(_s426["this"], "floats")):
		v_f_864 = _t1571
		v_k_865 = (1.0 - J.div(J.gp(v_f_864, "life"), J.gp(v_f_864, "max")))
		v_x_866 = J.div(J.gp(_s426["this"], "W"), 2.0)
		v_y_867 = (64.0 - (J.min_([1.0, J.mul(v_k_865, 6.0)]) * 4.0))
		v_al_868 = J.min_([1.0, J.mul(J.gp(v_f_864, "life"), 3.0), (J.mul(v_k_865, 8.0) + 0.2)])
		J.mc(v_ctx_771, "save", [])
		J.sp(v_ctx_771, "globalAlpha", v_al_868)
		J.sp(v_ctx_771, "font", "800 15px sans-serif")
		J.sp(v_ctx_771, "textAlign", "center")
		v_w_869 = J.min_([J.sub(J.gp(_s426["this"], "W"), 20.0), J.add(J.gp(J.mc(v_ctx_771, "measureText", [J.gp(v_f_864, "text")]), "width"), 26.0)])
		J.sp(v_ctx_771, "fillStyle", "rgba(12,10,20,.82)")
		J.mc(v_ctx_771, "beginPath", [])
		J.mc(v_ctx_771, "roundRect", [J.sub(v_x_866, J.div(v_w_869, 2.0)), J.sub(v_y_867, 17.0), v_w_869, 26.0, 13.0])
		J.mc(v_ctx_771, "fill", [])
		var _t1572 = J.gp(v_f_864, "color")
		J.sp(v_ctx_771, "strokeStyle", _t1572)
		var _t1573 = J.mul(v_al_868, 0.6)
		J.sp(v_ctx_771, "globalAlpha", _t1573)
		J.sp(v_ctx_771, "lineWidth", 1.2)
		J.mc(v_ctx_771, "stroke", [])
		J.sp(v_ctx_771, "globalAlpha", v_al_868)
		var _t1574 = J.gp(v_f_864, "color")
		J.sp(v_ctx_771, "fillStyle", _t1574)
		J.mc(v_ctx_771, "fillText", [J.gp(v_f_864, "text"), v_x_866, J.add(v_y_867, 1.0)])
		J.mc(v_ctx_771, "restore", [])
	J.mc(v_ctx_771, "restore", [])
	v_vg_783 = J.mc(v_ctx_771, "createRadialGradient", [J.div(v_W_774, 2.0), J.div(v_H_775, 2.0), J.mul(v_H_775, 0.3), J.div(v_W_774, 2.0), J.div(v_H_775, 2.0), J.mul(v_H_775, 0.8)])
	J.mc(v_vg_783, "addColorStop", [0.0, "rgba(0,0,0,0)"])
	J.mc(v_vg_783, "addColorStop", [1.0, ("rgba(" + J.str(J.round(J.num(J.mul(90.0, J.gp(_s426["this"], "vign"))))) + ",0,0," + J.str((0.45 + J.mul(0.3, J.gp(_s426["this"], "vign")))) + ")")])
	J.sp(v_ctx_771, "fillStyle", v_vg_783)
	J.mc(v_ctx_771, "fillRect", [0.0, 0.0, v_W_774, v_H_775])
	var _t1575 = J.gp(_s426["this"], "expo")
	var _t1576 = J.gp(_s426["this"], "expo")
	v_e_870 = J.min_([100.0, (_t1576 if J.t(_t1576) else 0.0)])
	v_bx_871 = 10.0
	v_by_872 = (J.sub(J.gp(_s426["this"], "H"), 34.0) if J.t(J.gp(J.gp(_s426["this"], "site"), "pano")) else 10.0)
	v_bw_873 = 132.0
	v_bh_874 = 9.0
	J.mc(v_ctx_771, "save", [])
	J.sp(v_ctx_771, "fillStyle", "rgba(0,0,0,.62)")
	J.mc(v_ctx_771, "fillRect", [J.sub(v_bx_871, 4.0), J.sub(v_by_872, 4.0), J.add(v_bw_873, 8.0), J.add(v_bh_874, 22.0)])
	J.sp(v_ctx_771, "font", "700 11px sans-serif")
	J.sp(v_ctx_771, "textAlign", "left")
	var _t1577 = ("#ff8a6a" if J.cmp(v_e_870, J.gp(J.G.get("EXPO"), "call"), ">=") else ("#ffcf6a" if J.cmp(v_e_870, J.gp(J.G.get("EXPO"), "sus"), ">=") else "#cfe8d8"))
	J.sp(v_ctx_771, "fillStyle", _t1577)
	J.mc(v_ctx_771, "fillText", [("穿崩度 " + J.str(J.round(J.num(v_e_870))) + ("　道士到！" if J.t(J.gp(_s426["this"], "daoIn")) else ("　請咗道士" if J.t(J.gp(_s426["this"], "daoCall")) else ("　有人起疑" if J.t(J.gp(_s426["this"], "alert")) else "")))), v_bx_871, J.add(v_by_872, 8.0)])
	J.sp(v_ctx_771, "fillStyle", "rgba(255,255,255,.15)")
	J.mc(v_ctx_771, "fillRect", [v_bx_871, J.add(v_by_872, 12.0), v_bw_873, J.sub(v_bh_874, 2.0)])
	var _t1578 = ("#ff6a4a" if J.cmp(v_e_870, J.gp(J.G.get("EXPO"), "call"), ">=") else ("#ffb84a" if J.cmp(v_e_870, J.gp(J.G.get("EXPO"), "sus"), ">=") else "#7fd6a0"))
	J.sp(v_ctx_771, "fillStyle", _t1578)
	J.mc(v_ctx_771, "fillRect", [v_bx_871, J.add(v_by_872, 12.0), J.div(J.mul(v_bw_873, v_e_870), 100.0), J.sub(v_bh_874, 2.0)])
	J.sp(v_ctx_771, "fillStyle", "rgba(255,255,255,.7)")
	for _t1579 in J.iter([J.gp(J.G.get("EXPO"), "sus"), J.gp(J.G.get("EXPO"), "call")]):
		v_q_875 = _t1579
		J.mc(v_ctx_771, "fillRect", [J.add(v_bx_871, J.div(J.mul(v_bw_873, v_q_875), 100.0)), J.add(v_by_872, 10.0), 1.5, J.add(v_bh_874, 2.0)])
	J.mc(v_ctx_771, "restore", [])
	if J.cmp(J.gp(_s426["this"], "t"), J.mul(J.G.get("NIGHT_SEC"), 0.85), ">"):
		var _t1580 = ("rgba(120,150,210," + J.str(((J.div(J.gp(_s426["this"], "t"), J.G.get("NIGHT_SEC")) - 0.85) * 1.2)) + ")")
		J.sp(v_ctx_771, "fillStyle", _t1580)
		J.mc(v_ctx_771, "fillRect", [0.0, 0.0, v_W_774, v_H_775])

func _f219(this_, a: Array, env):
	var v_ctx_878 = null; var v_t_879 = null; var v_n_880 = null; var v_x_881 = null; var v_right_882 = null; var v_H_883 = null; var v_y_884 = null; var v_ex_885 = null; var v_bob_886 = null; var v_lab_887 = null; var v_tw_888 = null; var v_bx_889 = null; var v_ax_890 = null
	v_ctx_878 = J.arg(a, 0)
	v_t_879 = J.arg(a, 1)
	v_n_880 = J.gp(this_, "sel")
	var _t1581 = this_
	J.sp(_t1581, "_edge", null)
	var _t1582 = (not J.t(v_n_880))
	var _t1583 = (_t1582 if _t1582 else J.gp(v_n_880, "gone"))
	if J.t((_t1583 if J.t(_t1583) else J.gp(v_n_880, "out"))):
		return null
	v_x_881 = (J.gp(v_n_880, "vX") if (not J.leq(J.gp(v_n_880, "vX"), null)) else J.gp(v_n_880, "x"))
	if J.t(J.mc(this_, "onScreen", [v_x_881, (-0.04)])):
		return null
	v_right_882 = J.cmp(v_x_881, J.add(J.gp(this_, "camX"), J.div(J.mc(this_, "viewW", []), 2.0)), ">")
	v_H_883 = J.gp(this_, "H")
	v_y_884 = 58.0
	v_ex_885 = (J.sub(J.gp(this_, "W"), 8.0) if J.t(v_right_882) else 8.0)
	v_bob_886 = (sin(J.num(J.mul(v_t_879, 5.0))) * 3.0)
	v_lab_887 = (J.str(J.gp(J.gp(v_n_880, "d"), "name")) + "・" + J.str(J.gp(J.mc(J.G.get("OFFMAP"), "roomAt", [v_x_881]), "name")))
	J.mc(v_ctx_878, "save", [])
	J.sp(v_ctx_878, "font", "800 12px sans-serif")
	v_tw_888 = J.add(J.gp(J.mc(v_ctx_878, "measureText", [v_lab_887]), "width"), 34.0)
	v_bx_889 = (J.sub(J.sub(v_ex_885, v_tw_888), v_bob_886) if J.t(v_right_882) else J.add(v_ex_885, v_bob_886))
	J.sp(v_ctx_878, "fillStyle", "rgba(12,10,20,.85)")
	J.sp(v_ctx_878, "strokeStyle", "#a8ffcf")
	J.sp(v_ctx_878, "lineWidth", 1.5)
	J.mc(v_ctx_878, "beginPath", [])
	J.mc(v_ctx_878, "roundRect", [v_bx_889, J.sub(v_y_884, 14.0), v_tw_888, 28.0, 14.0])
	J.mc(v_ctx_878, "fill", [])
	J.mc(v_ctx_878, "stroke", [])
	J.sp(v_ctx_878, "fillStyle", "#a8ffcf")
	J.mc(v_ctx_878, "beginPath", [])
	v_ax_890 = (J.sub(J.add(v_bx_889, v_tw_888), 12.0) if J.t(v_right_882) else J.add(v_bx_889, 12.0))
	J.mc(v_ctx_878, "moveTo", [J.add(v_ax_890, (7.0 if J.t(v_right_882) else (-7.0))), v_y_884])
	J.mc(v_ctx_878, "lineTo", [J.sub(v_ax_890, (5.0 if J.t(v_right_882) else (-5.0))), J.sub(v_y_884, 8.0)])
	J.mc(v_ctx_878, "lineTo", [J.sub(v_ax_890, (5.0 if J.t(v_right_882) else (-5.0))), J.add(v_y_884, 8.0)])
	J.mc(v_ctx_878, "closePath", [])
	J.mc(v_ctx_878, "fill", [])
	J.sp(v_ctx_878, "textAlign", "center")
	J.sp(v_ctx_878, "fillStyle", "#eafff2")
	J.mc(v_ctx_878, "fillText", [v_lab_887, J.add(J.add(v_bx_889, J.div(v_tw_888, 2.0)), ((-6.0) if J.t(v_right_882) else 6.0)), J.add(v_y_884, 4.0)])
	J.mc(v_ctx_878, "restore", [])
	var _t1584 = this_
	var _t1585 = [v_bx_889, J.sub(v_y_884, 14.0), v_tw_888, 28.0, v_n_880]
	J.sp(_t1584, "_edge", _t1585)

func _f220(this_, a: Array, env):
	var v_ctx_893 = null; var v_f_894 = null; var v_t_895 = null; var v_n_896 = null; var v_k_897 = null; var v_seat_898 = null; var v_x_899 = null; var v_y_900 = null; var v_hh_901 = null; var v_face_902 = null; var v_back_903 = null; var v_nx_904 = null; var v_ny_905 = null; var v_a_906 = null; var v_i_907 = null; var v_q_908 = null; var v_px_909 = null; var v_py_910 = null; var v_r_911 = null; var v_g_912 = null; var v_i_913 = null; var v_q_914 = null; var v_sx_915 = null; var v_sy_916 = null
	v_ctx_893 = J.arg(a, 0)
	v_f_894 = J.arg(a, 1)
	v_t_895 = J.arg(a, 2)
	v_n_896 = J.gp(v_f_894, "n")
	v_k_897 = (1.0 - J.div(J.gp(v_f_894, "life"), J.gp(v_f_894, "max")))
	var _t1586 = J.mc(this_, "office", [])
	v_seat_898 = (J.mc(J.G.get("OFFICE"), "seated", [v_n_896]) if J.t(_t1586) else _t1586)
	var _t1587 = J.mc(this_, "pt", [(J.gp(v_n_896, "vX") if (not J.leq(J.gp(v_n_896, "vX"), null)) else J.gp(v_n_896, "x")), (J.gp(v_n_896, "vY") if (not J.leq(J.gp(v_n_896, "vY"), null)) else J.gp(v_n_896, "y"))])
	var _t1588 = J.gp(_t1587, 0.0)
	v_x_899 = _t1588
	var _t1589 = J.gp(_t1587, 1.0)
	v_y_900 = _t1589
	v_hh_901 = J.mul(J.mc(this_, "hh", [J.gp(v_n_896, "y")]), (0.8 if J.t(v_seat_898) else 1.0))
	var _t1591 = null
	if J.t(v_seat_898):
		_t1591 = (-1.0)
	else:
		var _t1590 = J.gp(v_n_896, "dir")
		_t1591 = (_t1590 if J.t(_t1590) else 1.0)
	v_face_902 = _t1591
	v_back_903 = (-J.num(v_face_902))
	v_nx_904 = J.add(v_x_899, (J.mul(v_back_903, v_hh_901) * (0.02 if J.t(v_seat_898) else 0.2)))
	v_ny_905 = J.sub(v_y_900, J.mul(v_hh_901, (0.62 if J.t(v_seat_898) else 0.72)))
	v_a_906 = (J.min_([1.0, J.mul(v_k_897, 6.0)]) * J.max_([0.0, (1.0 - J.div(J.max_([0.0, J.sub(v_k_897, 0.45)]), 0.4))]))
	if J.cmp(v_a_906, 0.0, "<="):
		return null
	J.mc(v_ctx_893, "save", [])
	J.sp(v_ctx_893, "lineCap", "round")
	v_i_907 = 0.0
	while true:
		if not J.cmp(v_i_907, 4.0, "<"): break
		v_q_908 = J.min_([1.0, J.max_([0.0, (J.mul(v_k_897, 2.2) - J.mul(v_i_907, 0.18))])])
		if J.cmp(v_q_908, 0.0, "<="):
			v_i_907 = J.num(v_i_907) + 1.0
			continue
		v_px_909 = J.add(J.add(v_nx_904, (J.mul(v_back_903, v_hh_901) * (0.28 - J.mul(0.22, v_q_908)))), (sin(J.num(J.add(J.mul(v_t_895, 3.0), v_i_907))) * 2.0))
		v_py_910 = (J.sub(v_ny_905, J.mul(J.mul(v_hh_901, 0.04), v_i_907)) + (sin(J.num(J.add(J.mul(v_t_895, 2.0), v_i_907))) * 1.5))
		v_r_911 = J.mul(v_hh_901, (0.05 + J.mul(0.07, v_q_908)))
		v_g_912 = J.mc(v_ctx_893, "createRadialGradient", [v_px_909, v_py_910, 0.0, v_px_909, v_py_910, v_r_911])
		J.mc(v_g_912, "addColorStop", [0.0, ("rgba(240,248,255," + J.str(J.mul(0.8, v_a_906)) + ")")])
		J.mc(v_g_912, "addColorStop", [1.0, "rgba(235,245,255,0)"])
		J.sp(v_ctx_893, "fillStyle", v_g_912)
		J.mc(v_ctx_893, "beginPath", [])
		J.mc(v_ctx_893, "arc", [v_px_909, v_py_910, v_r_911, 0.0, (PI * 2.0)])
		J.mc(v_ctx_893, "fill", [])
		var _t1592 = ("rgba(245,250,255," + J.str(J.mul(0.6, v_a_906)) + ")")
		J.sp(v_ctx_893, "strokeStyle", _t1592)
		J.sp(v_ctx_893, "lineWidth", 1.6)
		J.mc(v_ctx_893, "beginPath", [])
		J.mc(v_ctx_893, "arc", [v_px_909, v_py_910, J.mul(v_r_911, 0.6), (PI * (0.2 + J.mul(v_i_907, 0.3))), (PI * (1.3 + J.mul(v_i_907, 0.3)))])
		J.mc(v_ctx_893, "stroke", [])
		v_i_907 = J.num(v_i_907) + 1.0
	var _t1593 = ("rgba(220,240,255," + J.str(v_a_906) + ")")
	J.sp(v_ctx_893, "fillStyle", _t1593)
	v_i_913 = 0.0
	while true:
		if not J.cmp(v_i_913, 6.0, "<"): break
		v_q_914 = J.mod((J.mul(v_k_897, 2.0) + J.div(v_i_913, 6.0)), 1.0)
		v_sx_915 = J.add(v_nx_904, (J.mul(v_back_903, v_hh_901) * (0.05 + (0.2 * sin(J.num(J.mul(v_i_913, 2.1)))))))
		v_sy_916 = J.add(v_ny_905, J.mul(v_hh_901, (J.mul(v_q_914, 0.2) - 0.08)))
		J.mc(v_ctx_893, "beginPath", [])
		J.mc(v_ctx_893, "arc", [v_sx_915, v_sy_916, 1.4, 0.0, (PI * 2.0)])
		J.mc(v_ctx_893, "fill", [])
		v_i_913 = J.num(v_i_913) + 1.0
	J.mc(v_ctx_893, "restore", [])

func _f223(this_, a: Array, env):
	var v_r_938 = null
	v_r_938 = J.arg(a, 0)
	var _t1610 = J.cmp(absf(J.num(J.sub(J.gp(v_r_938, 0.0), env["__p"]["lx"]))), J.add(env["__p"]["tw"], 44.0), "<")
	var _t1611 = (J.cmp(env["yy"], J.sub(J.gp(v_r_938, 1.0), 22.0), ">") if _t1610 else _t1610)
	return (J.cmp(J.sub(env["yy"], 12.0), J.add(J.gp(v_r_938, 1.0), J.gp(v_r_938, 2.0)), "<") if _t1611 else _t1611)

func _f224(this_, a: Array, env):
	var v_r_939 = null
	v_r_939 = J.arg(a, 0)
	var _t1612 = J.cmp(J.add(env["__p"]["lx"], env["__p"]["tw"]), J.gp(v_r_939, 0.0), ">")
	var _t1613 = (J.cmp(J.sub(env["__p"]["lx"], env["__p"]["tw"]), J.add(J.gp(v_r_939, 0.0), J.gp(v_r_939, 2.0)), "<") if _t1612 else _t1612)
	var _t1614 = (J.cmp(env["yy"], J.gp(v_r_939, 1.0), ">") if _t1613 else _t1613)
	return (J.cmp(J.sub(env["yy"], 12.0), J.add(J.gp(v_r_939, 1.0), J.gp(v_r_939, 3.0)), "<") if _t1614 else _t1614)

func _f222(this_, a: Array, env):
	var _s500 = {"__p": env, "yy": null}
	_s500["yy"] = J.arg(a, 0)
	var _t1615 = J.mc(_s500["__p"]["TR"], "some", [Callable(self, "_f223").bind(_s500)])
	return (_t1615 if J.t(_t1615) else J.mc(_s500["__p"]["BR"], "some", [Callable(self, "_f224").bind(_s500)]))

func _f221(this_, a: Array, env):
	var v_ctx_919 = null; var v_t_920 = null; var v_k_921 = null; var v_p_922 = null; var v_x1_923 = null; var v_y1_924 = null; var v_x2_925 = null; var v_y2_926 = null; var v_ok_927 = null; var v_a_928 = null; var v_cdl_929 = null; var v_lab_930 = null; var v_hit_935 = null; var v_ly_936 = null; var v_c_940 = null
	v_ctx_919 = J.arg(a, 0)
	v_t_920 = J.arg(a, 1)
	for _t1594 in J.keys(J.G.get("SCARE_PROPS")):
		v_k_921 = _t1594
		var _s499 = {"__p": env, "tw": null, "lx": null, "TR": null, "BR": null}
		var _t1595 = J.gp(J.gp(this_, "site"), "pano")
		if J.t(((not J.t(J.mc(this_, "onScreen", [J.add(J.gp(J.gp(J.gp(J.G.get("SCARE_PROPS"), v_k_921), "rect"), 0.0), J.div(J.gp(J.gp(J.gp(J.G.get("SCARE_PROPS"), v_k_921), "rect"), 2.0), 2.0)), 0.0]))) if J.t(_t1595) else _t1595)):
			continue
		var _t1596 = J.gp(J.gp(J.G.get("SCARE_PROPS"), v_k_921), "group")
		if J.t((_t1596 if J.t(_t1596) else (not J.t(J.mc(this_, "propOK", [v_k_921, J.gp(this_, "sel")]))))):
			continue
		var _t1597 = J.gp(J.gp(this_, "site"), "pano")
		if J.t(((not J.t(J.mc(this_, "onScreen", [J.add(J.gp(J.gp(J.gp(J.G.get("SCARE_PROPS"), v_k_921), "rect"), 0.0), J.div(J.gp(J.gp(J.gp(J.G.get("SCARE_PROPS"), v_k_921), "rect"), 2.0), 2.0)), 0.0]))) if J.t(_t1597) else _t1597)):
			continue
		v_p_922 = J.gp(J.G.get("SCARE_PROPS"), v_k_921)
		var _t1598 = J.mc(this_, "pt", [J.gp(J.gp(v_p_922, "rect"), 0.0), J.gp(J.gp(v_p_922, "rect"), 1.0)])
		var _t1599 = J.gp(_t1598, 0.0)
		v_x1_923 = _t1599
		var _t1600 = J.gp(_t1598, 1.0)
		v_y1_924 = _t1600
		var _t1601 = J.mc(this_, "pt", [J.add(J.gp(J.gp(v_p_922, "rect"), 0.0), J.gp(J.gp(v_p_922, "rect"), 2.0)), J.add(J.gp(J.gp(v_p_922, "rect"), 1.0), J.gp(J.gp(v_p_922, "rect"), 3.0))])
		var _t1602 = J.gp(_t1601, 0.0)
		v_x2_925 = _t1602
		var _t1603 = J.gp(_t1601, 1.0)
		v_y2_926 = _t1603
		var _t1604 = J.cmp(J.gp(this_, "mana"), J.gp(v_p_922, "cost"), ">=")
		v_ok_927 = (J.mc(this_, "propOK", [v_k_921, J.gp(this_, "sel")]) if _t1604 else _t1604)
		v_a_928 = ((0.35 + (0.25 * sin(J.num(J.add(J.mul(v_t_920, 3.0), v_x1_923))))) if J.t(v_ok_927) else 0.1)
		var _t1605 = ("rgba(150,255,200," + J.str(v_a_928) + ")")
		J.sp(v_ctx_919, "strokeStyle", _t1605)
		J.sp(v_ctx_919, "lineWidth", 2.0)
		J.mc(v_ctx_919, "setLineDash", [[5.0, 4.0]])
		J.mc(v_ctx_919, "strokeRect", [v_x1_923, v_y1_924, J.sub(v_x2_925, v_x1_923), J.sub(v_y2_926, v_y1_924)])
		J.mc(v_ctx_919, "setLineDash", [[]])
		var _t1607 = J.gp(v_p_922, "group")
		if J.t(_t1607):
			var _t1606 = J.gp(this_, "pcd")
			_t1607 = J.cmp(J.gp((_t1606 if J.t(_t1606) else {}), v_k_921), 0.0, ">")
		v_cdl_929 = (J.add(ceil(J.num(J.gp(J.gp(this_, "pcd"), v_k_921))), "秒") if J.t(_t1607) else J.gp(v_p_922, "cost"))
		v_lab_930 = (J.str(J.gp(v_p_922, "name")) + ("（全場）" if J.t(J.gp(v_p_922, "group")) else "") + "・" + J.str(v_cdl_929))
		J.sp(v_ctx_919, "font", "600 11px sans-serif")
		J.sp(v_ctx_919, "textAlign", "center")
		_s499["tw"] = (J.div(J.gp(J.mc(v_ctx_919, "measureText", [v_lab_930]), "width"), 2.0) + 4.0)
		_s499["lx"] = J.max_([_s499["tw"], J.min_([J.sub(J.gp(this_, "W"), _s499["tw"]), J.div(J.add(v_x1_923, v_x2_925), 2.0)])])
		var _t1608 = J.gp(this_, "_tagR")
		_s499["TR"] = (_t1608 if J.t(_t1608) else [])
		var _t1609 = J.gp(this_, "_bubLast")
		_s499["BR"] = (_t1609 if J.t(_t1609) else [])
		v_hit_935 = Callable(self, "_f222").bind(_s499)
		v_ly_936 = (J.sub(v_y1_924, 5.0) if J.seq(J.gp(v_p_922, "label"), "up") else J.add(v_y2_926, 13.0))
		for _t1616 in J.iter([J.sub(v_y1_924, 5.0), J.add(v_y2_926, 13.0), J.add(v_y1_924, 14.0)]):
			v_c_940 = _t1616
			if (not J.t(J.cl(v_hit_935, null, [v_ly_936]))):
				break
			else:
				v_ly_936 = v_c_940
		if J.t(J.cl(v_hit_935, null, [v_ly_936])):
			continue
		if J.t(J.mc(this_, "office", [])):
			J.sp(v_ctx_919, "lineWidth", 3.0)
			J.sp(v_ctx_919, "strokeStyle", "rgba(10,8,20,.75)")
			J.mc(v_ctx_919, "strokeText", [v_lab_930, _s499["lx"], v_ly_936])
		var _t1617 = (("rgba(190,215,255," + J.str((0.9 if J.t(v_ok_927) else 0.4)) + ")") if J.t(J.gp(v_p_922, "group")) else ("rgba(190,255,215," + J.str((0.9 if J.t(v_ok_927) else 0.4)) + ")"))
		J.sp(v_ctx_919, "fillStyle", _t1617)
		J.mc(v_ctx_919, "fillText", [v_lab_930, _s499["lx"], v_ly_936])

func _f225(this_, a: Array, env):
	var v_n_943 = null; var v_k_944 = null; var v_o_945 = null; var v_D_946 = null
	v_n_943 = J.arg(a, 0)
	v_k_944 = J.arg(a, 1)
	v_o_945 = J.arg(a, 2)
	var _t1618 = J.gp(this_, "headless")
	if J.t((_t1618 if J.t(_t1618) else (not J.t(v_n_943)))):
		return null
	var _t1619 = (v_o_945 if J.t(v_o_945) else {})
	v_o_945 = _t1619
	v_D_946 = {"flinch": 0.5, "startle": 0.75, "weakjump": 0.95, "burst": 2.6, "rational": 1.6, "numb": 1.3, "sip": 2.6, "catch": 2.4, "chill": 2.4}
	var _t1620 = J.gp(v_n_943, "rx")
	var _t1621 = (J.seq(J.gp(J.gp(v_n_943, "rx"), "k"), "burst") if J.t(_t1620) else _t1620)
	var _t1622 = (J.cmp(J.gp(J.gp(v_n_943, "rx"), "t"), J.mul(J.gp(J.gp(v_n_943, "rx"), "dur"), 0.75), "<") if J.t(_t1621) else _t1621)
	if J.t(((not J.seq(v_k_944, "burst")) if J.t(_t1622) else _t1622)):
		return null
	var _t1623 = J.gp(v_o_945, "delay")
	var _t1626 = (-J.num((_t1623 if J.t(_t1623) else 0.0)))
	var _t1624 = J.gp(v_o_945, "dur")
	var _t1625 = (_t1624 if J.t(_t1624) else J.gp(v_D_946, v_k_944))
	var _t1627 = {"k": v_k_944, "t": _t1626, "dur": (_t1625 if J.t(_t1625) else 1.0), "src": J.gp(v_o_945, "src"), "big": (not (not J.t(J.gp(v_o_945, "big"))))}
	J.sp(v_n_943, "rx", _t1627)

func _f226(this_, a: Array, env):
	var v_n_949 = null; var v_dt_950 = null; var v_lv_951 = null; var v_vx_952 = null; var v_vy_953 = null; var v_key_954 = null
	v_n_949 = J.arg(a, 0)
	v_dt_950 = J.arg(a, 1)
	var _t1628 = J.gp(v_n_949, "at")
	var _t1630 = (_t1628 if J.t(_t1628) else 0.0)
	var _t1629 = J.gp(v_n_949, "spd")
	var _t1631 = J.add(_t1630, J.mul(v_dt_950, (_t1629 if J.t(_t1629) else 1.0)))
	J.sp(v_n_949, "at", _t1631)
	if (not J.seq(J.typeof_(J.G.get("TOWN")), "undefined")):
		J.mc(J.G.get("TOWN"), "npcTick", [v_n_949, v_dt_950])
	if J.t(J.mc(this_, "office", [])):
		J.mc(J.G.get("OFFICE"), "kenTick", [v_n_949, v_dt_950])
	if J.t(J.gp(v_n_949, "rx")):
		var _t1632 = J.gp(v_n_949, "rx")
		var _t1633 = J.add(J.gp(_t1632, "t"), v_dt_950)
		J.sp(_t1632, "t", _t1633)
		var _t1634 = (not J.t(J.gp(J.gp(v_n_949, "rx"), "fired")))
		if (J.cmp(J.gp(J.gp(v_n_949, "rx"), "t"), 0.0, ">=") if _t1634 else _t1634):
			var _t1635 = J.gp(v_n_949, "rx")
			J.sp(_t1635, "fired", true)
			J.mc(this_, "onReact", [v_n_949])
		var _t1636 = J.gp(v_n_949, "rx")
		if J.t((J.cmp(J.gp(J.gp(v_n_949, "rx"), "t"), J.gp(J.gp(v_n_949, "rx"), "dur"), ">=") if J.t(_t1636) else _t1636)):
			J.sp(v_n_949, "rx", null)
	v_lv_951 = (3.0 if J.t(J.gp(v_n_949, "fleeing")) else (2.0 if J.cmp(J.gp(v_n_949, "fear"), 50.0, ">=") else (1.0 if J.cmp(J.gp(v_n_949, "fear"), 25.0, ">=") else 0.0)))
	var _t1637 = J.gp(v_n_949, "lv")
	if J.cmp(v_lv_951, (_t1637 if J.t(_t1637) else 0.0), ">"):
		J.sp(v_n_949, "markPop", 0.5)
		if J.cmp(v_lv_951, 1.0, ">="):
			var _t1638 = J.gp(v_n_949, "goose")
			var _t1639 = J.gp(v_n_949, "goose")
			var _t1640 = J.max_([(_t1639 if J.t(_t1639) else 0.0), 1.2])
			J.sp(v_n_949, "goose", _t1640)
	J.sp(v_n_949, "lv", v_lv_951)
	var _t1641 = J.gp(v_n_949, "markPop")
	var _t1642 = J.sub((_t1641 if J.t(_t1641) else 0.0), J.mul(v_dt_950, 2.0))
	J.sp(v_n_949, "markPop", _t1642)
	for _t1643 in J.iter(["goose", "hair", "shock", "scream"]):
		v_key_954 = _t1643
		if J.cmp(J.gp(v_n_949, v_key_954), 0.0, ">"):
			var _t1644 = J.max_([0.0, J.sub(J.gp(v_n_949, v_key_954), v_dt_950)])
			J.sp(v_n_949, v_key_954, _t1644)
	if J.cmp(J.gp(v_n_949, "barHit"), 0.0, ">"):
		var _t1645 = J.max_([0.0, J.sub(J.gp(v_n_949, "barHit"), J.mul(v_dt_950, 2.0))])
		J.sp(v_n_949, "barHit", _t1645)
	var _t1646 = J.cmp(J.gp(v_n_949, "shaken"), 0.0, ">")
	var _t1647 = ((not J.t(J.gp(v_n_949, "fleeing"))) if _t1646 else _t1646)
	if ((randf() < J.mul(v_dt_950, 0.9)) if _t1647 else _t1647):
		var _t1648 = J.gp(this_, "parts")
		J.mc(_t1648, "push", [{"kind": "sweat", "x": J.add((J.gp(v_n_949, "vX") if (not J.leq(J.gp(v_n_949, "vX"), null)) else J.gp(v_n_949, "x")), ((randf() - 0.5) * 0.05)), "y": J.sub((J.gp(v_n_949, "vY") if (not J.leq(J.gp(v_n_949, "vY"), null)) else J.gp(v_n_949, "y")), 0.16), "vx": ((randf() - 0.5) * 0.05), "vy": (-0.05), "g": 0.45, "life": 0.7}])
	var _t1649 = J.gp(v_n_949, "fleeing")
	var _t1650 = ((not J.t(J.gp(v_n_949, "gone"))) if J.t(_t1649) else _t1649)
	if J.t((J.gp(v_n_949, "trail") if J.t(_t1650) else _t1650)):
		var _t1651 = J.gp(v_n_949, "trail")
		J.mc(_t1651, "push", [[J.gp(this_, "t"), J.gp(v_n_949, "x"), J.gp(v_n_949, "y")]])
	v_vx_952 = (J.gp(v_n_949, "vX") if (not J.leq(J.gp(v_n_949, "vX"), null)) else J.gp(v_n_949, "x"))
	v_vy_953 = (J.gp(v_n_949, "vY") if (not J.leq(J.gp(v_n_949, "vY"), null)) else J.gp(v_n_949, "y"))
	var _t1652 = (not J.t(J.gp(v_n_949, "gone")))
	var _t1653 = (J.cmp(J.gp(v_n_949, "fear"), 50.0, ">=") if _t1652 else _t1652)
	if ((randf() < J.mul(v_dt_950, (5.0 if J.cmp(J.gp(v_n_949, "fear"), 80.0, ">=") else 2.2))) if _t1653 else _t1653):
		var _t1654 = J.gp(this_, "parts")
		J.mc(_t1654, "push", [{"kind": "sweat", "x": J.add(v_vx_952, ((randf() - 0.5) * 0.06)), "y": (J.sub(v_vy_953, 0.16) - (randf() * 0.03)), "vx": ((randf() - 0.5) * 0.06), "vy": (-0.06), "g": 0.45, "life": 0.7}])

func _f227(this_, a: Array, env):
	var v_n_957 = null; var v_k_958 = null; var v_vx_959 = null; var v_vy_960 = null; var v_i_961 = null; var v_a_962 = null
	v_n_957 = J.arg(a, 0)
	v_k_958 = J.gp(J.gp(v_n_957, "rx"), "k")
	v_vx_959 = (J.gp(v_n_957, "vX") if (not J.leq(J.gp(v_n_957, "vX"), null)) else J.gp(v_n_957, "x"))
	v_vy_960 = (J.gp(v_n_957, "vY") if (not J.leq(J.gp(v_n_957, "vY"), null)) else J.gp(v_n_957, "y"))
	var _t1655 = J.seq(v_k_958, "startle")
	var _t1656 = (_t1655 if _t1655 else J.seq(v_k_958, "weakjump"))
	if (_t1656 if _t1656 else J.seq(v_k_958, "burst")):
		var _t1657 = (1.6 if J.seq(v_k_958, "burst") else 1.0)
		J.sp(v_n_957, "hair", _t1657)
		J.sp(v_n_957, "goose", 1.6)
		J.sp(v_n_957, "shock", 0.5)
		v_i_961 = 0.0
		while true:
			if not J.cmp(v_i_961, (7.0 if J.seq(v_k_958, "burst") else 4.0), "<"): break
			v_a_962 = (J.div((-PI), 2.0) + ((randf() - 0.5) * 2.2))
			var _t1658 = J.gp(this_, "parts")
			J.mc(_t1658, "push", [{"kind": "sweat", "x": J.add(v_vx_959, (cos(J.num(v_a_962)) * 0.03)), "y": J.sub(v_vy_960, 0.17), "vx": (cos(J.num(v_a_962)) * 0.16), "vy": (sin(J.num(v_a_962)) * 0.18), "g": 0.6, "life": 0.75}])
			v_i_961 = J.num(v_i_961) + 1.0
	if J.seq(v_k_958, "burst"):
		J.sp(v_n_957, "scream", 1.8)
	if J.seq(v_k_958, "flinch"):
		J.sp(v_n_957, "shock", 0.28)
		var _t1659 = J.gp(v_n_957, "goose")
		var _t1660 = J.gp(v_n_957, "goose")
		var _t1661 = J.max_([(_t1660 if J.t(_t1660) else 0.0), 0.8])
		J.sp(v_n_957, "goose", _t1661)

func _f228(this_, a: Array, env):
	var v_type_965 = null
	v_type_965 = J.arg(a, 0)
	var _t1665 = (not J.seq(J.typeof_(J.G.get("ART")), "undefined"))
	if J.t(_t1665):
		var _t1662 = (not J.seq(J.typeof_(J.G.get("Puppet")), "undefined"))
		var _t1664 = (J.mc(J.G.get("Puppet"), "has", [v_type_965]) if _t1662 else _t1662)
		if not J.t(_t1664):
			var _t1663 = J.gp(J.G.get("ART"), "hasRig")
			_t1664 = (not (not J.t((J.mc(J.G.get("ART"), "hasRig", [v_type_965]) if J.t(_t1663) else _t1663))))
		_t1665 = _t1664
	return _t1665

func _f229(this_, a: Array, env):
	var v_n_968 = null; var v_age_969 = null; var v_hold_970 = null; var v_tr_971 = null; var v_lag_972 = null; var v_ts_973 = null; var v_i_974 = null; var v_x_975 = null; var v_y_976 = null; var v_dir_977 = null; var v_b_978 = null; var v_k_979 = null; var v_e_980 = null
	v_n_968 = J.arg(a, 0)
	var _t1666 = (not J.t(J.gp(v_n_968, "fleeT")))
	var _t1667 = (_t1666 if _t1666 else (not J.t(J.gp(v_n_968, "trail"))))
	if (_t1667 if _t1667 else (not J.t(J.len(J.gp(v_n_968, "trail"))))):
		return [J.gp(v_n_968, "x"), J.gp(v_n_968, "y"), null]
	v_age_969 = J.sub(J.gp(this_, "t"), J.gp(v_n_968, "fleeT"))
	var _t1668 = J.gp(v_n_968, "fleeHold")
	v_hold_970 = (_t1668 if J.t(_t1668) else 0.0)
	v_tr_971 = J.gp(v_n_968, "trail")
	v_lag_972 = (v_age_969 if J.cmp(v_age_969, v_hold_970, "<") else J.mul(v_hold_970, J.max_([0.0, (1.0 - J.div(J.sub(v_age_969, v_hold_970), 0.7))])))
	v_ts_973 = J.sub(J.gp(this_, "t"), v_lag_972)
	v_i_974 = (J.len(v_tr_971) - 1.0)
	while true:
		var _t1669 = J.cmp(v_i_974, 0.0, ">")
		if not (J.cmp(J.gp(J.gp(v_tr_971, v_i_974), 0.0), v_ts_973, ">") if _t1669 else _t1669): break
		v_i_974 = J.num(v_i_974) + -1.0
	v_x_975 = J.gp(J.gp(v_tr_971, v_i_974), 1.0)
	v_y_976 = J.gp(J.gp(v_tr_971, v_i_974), 2.0)
	v_dir_977 = J.gp(v_n_968, "dir")
	if J.cmp(v_i_974, (J.len(v_tr_971) - 1.0), "<"):
		v_b_978 = J.gp(v_tr_971, J.add(v_i_974, 1.0))
		var _t1671 = J.sub(v_ts_973, J.gp(J.gp(v_tr_971, v_i_974), 0.0))
		var _t1670 = J.sub(J.gp(v_b_978, 0.0), J.gp(J.gp(v_tr_971, v_i_974), 0.0))
		var _t1673 = J.sub(v_ts_973, J.gp(J.gp(v_tr_971, v_i_974), 0.0))
		var _t1672 = J.sub(J.gp(v_b_978, 0.0), J.gp(J.gp(v_tr_971, v_i_974), 0.0))
		var _t1675 = J.sub(v_ts_973, J.gp(J.gp(v_tr_971, v_i_974), 0.0))
		var _t1674 = J.sub(J.gp(v_b_978, 0.0), J.gp(J.gp(v_tr_971, v_i_974), 0.0))
		var _t1677 = J.sub(v_ts_973, J.gp(J.gp(v_tr_971, v_i_974), 0.0))
		var _t1676 = J.sub(J.gp(v_b_978, 0.0), J.gp(J.gp(v_tr_971, v_i_974), 0.0))
		v_k_979 = J.max_([0.0, J.min_([1.0, J.div(_t1677, (_t1676 if J.t(_t1676) else 1.0))])])
		var _t1678 = J.add(v_x_975, J.mul(J.sub(J.gp(v_b_978, 1.0), v_x_975), v_k_979))
		v_x_975 = _t1678
		var _t1679 = J.add(v_y_976, J.mul(J.sub(J.gp(v_b_978, 2.0), v_y_976), v_k_979))
		v_y_976 = _t1679
	else:
		if J.t(J.gp(v_n_968, "gone")):
			v_e_980 = J.sub(v_ts_973, J.gp(v_n_968, "exitT"))
			if J.cmp(v_e_980, 0.0, ">"):
				var _t1680 = J.add(v_x_975, J.mul(v_e_980, 0.45))
				v_x_975 = _t1680
				v_dir_977 = 1.0
	return [v_x_975, v_y_976, v_dir_977]

func _f231(this_, a: Array, env):
	var v_k_991 = null
	v_k_991 = J.arg(a, 0)
	return J.cmp(J.gp(J.gp(env["n"], "hab"), v_k_991), 1.5, ">=")

func _f232(this_, a: Array, env):
	var v_A_997 = null; var v_mul_998 = null; var v_q_999 = null; var v_up_1000 = null
	v_A_997 = J.arg(a, 0)
	v_mul_998 = J.arg(a, 1)
	if J.cmp(J.gp(env["rx"], "t"), v_A_997, "<"):
		var _t1712 = env["o"]
		J.sp(_t1712, "sx", 1.09)
		var _t1713 = env["o"]
		J.sp(_t1713, "sy", 0.88)
		var _t1714 = env["o"]
		J.sp(_t1714, "face", "s")
		return null
	v_q_999 = J.min_([1.0, J.div(J.sub(J.gp(env["rx"], "t"), v_A_997), J.max_([0.2, J.sub((0.55 if J.seq(J.gp(env["rx"], "k"), "burst") else J.gp(env["rx"], "dur")), v_A_997)]))])
	v_up_1000 = sin(J.num((J.min_([1.0, J.mul(v_q_999, 1.5)]) * PI)))
	var _t1717 = env["o"]
	var _t1716 = J.seq(J.gp(env["rx"], "k"), "burst")
	if not J.t(_t1716):
		var _t1715 = J.cmp(v_q_999, 0.4, ">")
		_t1716 = (J.cmp(env["f"], 75.0, ">=") if _t1715 else _t1715)
	J.S_Object_("assign", [_t1717, {"pose": "startle", "pt": v_q_999, "walk": false, "face": ("t" if _t1716 else "s"), "lift": J.mul(v_up_1000, v_mul_998), "sy": (1.0 + J.mul(0.13, v_up_1000)), "sx": J.div(1.0, (1.0 + J.mul(0.13, v_up_1000))), "jit": 0.0}])

func _f230(this_, a: Array, env):
	var v_d_984 = null; var v_walking_987 = null; var v_habit_988 = null; var v_calm_989 = null; var v_age_992 = null; var v_hold_993 = null; var v_p_994 = null; var v_p_995 = null; var v_jump_996 = null; var v_sh_1001 = null; var v_t2_1002 = null; var v_sh_1003 = null; var v_sq_1004 = null
	var _s521 = {"__p": env, "n": null, "f": null, "rx": null, "o": null}
	_s521["n"] = J.arg(a, 0)
	v_d_984 = J.gp(_s521["n"], "d")
	_s521["f"] = J.gp(_s521["n"], "fear")
	var _t1681 = J.gp(_s521["n"], "rx")
	_s521["rx"] = (J.gp(_s521["n"], "rx") if J.t((J.cmp(J.gp(J.gp(_s521["n"], "rx"), "t"), 0.0, ">=") if J.t(_t1681) else _t1681)) else null)
	v_walking_987 = J.seq(J.gp(_s521["n"], "act"), "walk")
	var _t1683 = J.gp(_s521["n"], "hab")
	if J.t(_t1683):
		var _t1682 = J.S_Object_("keys", [J.gp(_s521["n"], "hab")])
		_t1683 = J.mc(_t1682, "some", [Callable(self, "_f231").bind(_s521)])
	v_habit_988 = _t1683
	var _t1684 = J.seq(J.gp(v_d_984, "k"), "ken")
	var _t1687 = null
	if (_t1684 if _t1684 else J.seq(J.gp(v_d_984, "k"), "auntie")):
		_t1687 = "b"
	else:
		var _t1686 = null
		if J.seq(J.gp(v_d_984, "k"), "boss"):
			var _t1685 = J.gp(_s521["n"], "at")
			_t1686 = ("q" if (sin(J.num(J.mul((_t1685 if J.t(_t1685) else 0.0), 0.9))) > 0.55) else "n")
		else:
			_t1686 = "n"
		_t1687 = _t1686
	v_calm_989 = _t1687
	_s521["o"] = {"pose": "idle", "face": ("b" if J.t((J.cmp(_s521["f"], 25.0, "<") if J.t(v_habit_988) else v_habit_988)) else v_calm_989), "pt": 0.0, "walk": false, "src": null, "sx": 1.0, "sy": 1.0, "lift": 0.0, "jit": 0.0, "rot": 0.0, "spd": 1.0}
	if J.t(J.gp(_s521["n"], "fleeing")):
		var _t1689 = J.gp(this_, "t")
		var _t1688 = J.gp(_s521["n"], "fleeT")
		v_age_992 = J.sub(_t1689, (_t1688 if J.t(_t1688) else 0.0))
		var _t1690 = J.gp(_s521["n"], "fleeHold")
		v_hold_993 = (_t1690 if J.t(_t1690) else 0.0)
		var _t1691 = J.cmp(v_age_992, v_hold_993, ">=")
		if J.t((_t1691 if _t1691 else J.gp(_s521["n"], "gone"))):
			return J.S_Object_("assign", [_s521["o"], {"pose": "run", "face": "t", "walk": true, "jit": 0.35, "spd": 2.2, "run": true}])
		if J.cmp(v_age_992, J.sub(v_hold_993, 0.4), ">="):
			v_p_994 = J.div((J.sub(v_age_992, v_hold_993) + 0.4), 0.4)
			var _t1696 = _s521["o"]
			var _t1693 = (sin(J.num(J.mul(v_p_994, PI))) * 1.3)
			var _t1694 = (1.0 + (0.14 * sin(J.num(J.mul(v_p_994, PI)))))
			var _t1695 = J.div(1.0, (1.0 + (0.14 * sin(J.num(J.mul(v_p_994, PI))))))
			var _t1692 = J.gp(_s521["n"], "rx")
			return J.S_Object_("assign", [_t1696, {"pose": "startle", "pt": v_p_994, "face": "t", "lift": _t1693, "sy": _t1694, "sx": _t1695, "src": (J.gp(J.gp(_s521["n"], "rx"), "src") if J.t(_t1692) else _t1692)}])
	if J.t(v_walking_987):
		var _t1697 = _s521["o"]
		J.sp(_t1697, "pose", "move")
		var _t1698 = _s521["o"]
		J.sp(_t1698, "walk", true)
		if J.cmp(_s521["f"], 50.0, ">="):
			J.S_Object_("assign", [_s521["o"], {"face": ("t" if J.cmp(_s521["f"], 80.0, ">=") else "f"), "jit": 0.45, "spd": 0.75}])
		else:
			if J.cmp(_s521["f"], 25.0, ">="):
				var _t1699 = _s521["o"]
				J.sp(_t1699, "face", "q")
	else:
		if J.cmp(_s521["f"], 80.0, ">="):
			J.S_Object_("assign", [_s521["o"], {"pose": "cower", "face": "t", "jit": 0.8}])
		else:
			if J.cmp(_s521["f"], 50.0, ">="):
				J.S_Object_("assign", [_s521["o"], {"pose": "tremble", "face": "f", "jit": 0.3}])
			else:
				if J.cmp(_s521["f"], 25.0, ">="):
					J.S_Object_("assign", [_s521["o"], {"pose": "look", "face": "q"}])
				else:
					if J.seq(J.gp(_s521["n"], "act"), "brk_nap"):
						J.S_Object_("assign", [_s521["o"], {"pose": "idle", "face": "c", "doze": true}])
					else:
						if J.seq(J.gp(_s521["n"], "act"), "brk_phone"):
							J.S_Object_("assign", [_s521["o"], {"pose": "phone", "face": "b"}])
						else:
							if J.seq(J.gp(_s521["n"], "act"), "brk_drink"):
								J.S_Object_("assign", [_s521["o"], {"pose": "sip", "face": "c"}])
							else:
								if J.seq(J.gp(v_d_984, "k"), "ken"):
									J.S_Object_("assign", [_s521["o"], {"pose": "phone", "face": "b"}])
								else:
									if J.seq(J.gp(_s521["n"], "act"), "mop"):
										J.S_Object_("assign", [_s521["o"], {"pose": "mop", "face": "b"}])
									else:
										var _t1700 = J.gp(v_d_984, "daoshi")
										if J.t((J.seq(J.gp(_s521["n"], "act"), "ritual") if J.t(_t1700) else _t1700)):
											var _t1701 = _s521["o"]
											J.sp(_t1701, "pose", "ritual")
										else:
											var _t1702 = J.gp(v_d_984, "guard")
											if J.t((J.seq(J.gp(_s521["n"], "act"), "doze") if J.t(_t1702) else _t1702)):
												J.S_Object_("assign", [_s521["o"], {"pose": "idle", "face": "c", "doze": true}])
											else:
												if J.t(J.gp(v_d_984, "guard")):
													J.S_Object_("assign", [_s521["o"], {"pose": "look", "face": "n"}])
												else:
													if J.seq(J.gp(v_d_984, "k"), "boss"):
														var _t1703 = _s521["o"]
														J.sp(_t1703, "pose", "hold")
	var _t1704 = J.cmp(_s521["f"], 25.0, "<")
	var _t1705 = ((not J.t(v_walking_987)) if _t1704 else _t1704)
	var _t1706 = ((not J.t(J.gp(_s521["n"], "fleeing"))) if _t1705 else _t1705)
	var _t1707 = ((not J.seq(J.typeof_(J.G.get("TOWN")), "undefined")) if _t1706 else _t1706)
	if J.t((J.mc(J.G.get("TOWN"), "actAnim", [_s521["n"]]) if _t1707 else _t1707)):
		var _t1708 = _s521["o"]
		var _t1709 = J.gp(_s521["n"], "act")
		J.sp(_t1708, "pose", _t1709)
	if J.t(_s521["rx"]):
		v_p_995 = J.min_([1.0, J.div(J.gp(_s521["rx"], "t"), J.gp(_s521["rx"], "dur"))])
		var _t1710 = _s521["o"]
		var _t1711 = J.gp(_s521["rx"], "src")
		J.sp(_t1710, "src", _t1711)
		v_jump_996 = Callable(self, "_f232").bind(_s521)
		var _t1718 = J.gp(_s521["rx"], "k")
		var _t1719 = -1
		var _t1720 = false
		if _t1719 == -1 and J.seq(_t1718, "flinch"): _t1719 = 0
		if _t1719 == -1 and J.seq(_t1718, "startle"): _t1719 = 1
		if _t1719 == -1 and J.seq(_t1718, "weakjump"): _t1719 = 2
		if _t1719 == -1 and J.seq(_t1718, "burst"): _t1719 = 3
		if _t1719 == -1 and J.seq(_t1718, "rational"): _t1719 = 4
		if _t1719 == -1 and J.seq(_t1718, "numb"): _t1719 = 5
		if _t1719 == -1 and J.seq(_t1718, "sip"): _t1719 = 6
		if _t1719 == -1 and J.seq(_t1718, "catch"): _t1719 = 7
		if _t1719 == -1 and J.seq(_t1718, "chill"): _t1719 = 8
		while true:
			if _t1719 <= 0 and _t1719 >= 0:
				J.S_Object_("assign", [_s521["o"], {"pose": ("move" if J.t(J.gp(_s521["o"], "walk")) else "hurt"), "pt": v_p_995, "face": "s", "sx": (1.0 + (0.06 * J.sub(1.0, v_p_995))), "sy": (1.0 - (0.06 * J.sub(1.0, v_p_995)))}])
				break
			if _t1719 <= 1 and _t1719 >= 0:
				J.cl(v_jump_996, null, [0.08, (1.1 if J.t(J.gp(_s521["rx"], "big")) else 0.75)])
				break
			if _t1719 <= 2 and _t1719 >= 0:
				J.cl(v_jump_996, null, [0.09, 1.5])
				break
			if _t1719 <= 3 and _t1719 >= 0:
				if J.cmp(J.gp(_s521["rx"], "t"), 0.55, "<"):
					J.cl(v_jump_996, null, [0.07, 1.4])
				else:
					J.S_Object_("assign", [_s521["o"], ({"face": "t", "jit": 1.0, "spd": 1.6} if J.t(J.gp(_s521["o"], "walk")) else {"pose": "cower", "face": "t", "jit": 1.0, "pt": J.min_([1.0, J.div(J.sub(J.gp(_s521["rx"], "t"), 0.55), 0.3)])})])
				break
			if _t1719 <= 4 and _t1719 >= 0:
				v_sh_1001 = sin(J.num((J.min_([1.0, J.div(J.gp(_s521["rx"], "t"), 0.55)]) * PI)))
				J.S_Object_("assign", [_s521["o"], {"face": "q", "sy": (1.0 + J.mul(0.06, v_sh_1001)), "sx": (1.0 - J.mul(0.02, v_sh_1001)), "lift": J.mul(0.18, v_sh_1001), "rot": J.mul((-0.06), v_sh_1001), "shrug": v_sh_1001}])
				if (not J.t(J.gp(_s521["o"], "walk"))):
					var _t1721 = _s521["o"]
					J.sp(_t1721, "pose", "shrug")
					var _t1722 = _s521["o"]
					var _t1723 = J.min_([1.0, J.div(J.gp(_s521["rx"], "t"), 0.9)])
					J.sp(_t1722, "pt", _t1723)
				break
			if _t1719 <= 5 and _t1719 >= 0:
				var _t1724 = _s521["o"]
				J.sp(_t1724, "face", "b")
				if (not J.t(J.gp(_s521["o"], "walk"))):
					var _t1725 = _s521["o"]
					var _t1726 = ("phone" if J.seq(J.gp(v_d_984, "k"), "ken") else ("mop" if J.t(J.gp(v_d_984, "mop")) else ("hold" if J.seq(J.gp(v_d_984, "k"), "boss") else "idle")))
					J.sp(_t1725, "pose", _t1726)
				break
			if _t1719 <= 6 and _t1719 >= 0:
				if (not J.t(J.gp(_s521["o"], "walk"))):
					var _t1727 = _s521["o"]
					J.sp(_t1727, "pose", "sip")
				var _t1728 = _s521["o"]
				J.sp(_t1728, "face", "c")
				break
			if _t1719 <= 7 and _t1719 >= 0:
				var _t1729 = _s521["o"]
				J.sp(_t1729, "pose", "look")
				var _t1730 = _s521["o"]
				J.sp(_t1730, "face", "q")
				var _t1731 = _s521["o"]
				J.sp(_t1731, "walk", false)
				break
			if _t1719 <= 8 and _t1719 >= 0:
				v_t2_1002 = J.gp(_s521["rx"], "t")
				v_sh_1003 = ((1.0 - J.div(v_t2_1002, 0.7)) if J.cmp(v_t2_1002, 0.7, "<") else 0.0)
				v_sq_1004 = J.min_([1.0, J.div(absf(J.num(J.sub(v_t2_1002, 0.9))), 0.12), J.div(absf(J.num(J.sub(v_t2_1002, 1.9))), 0.12)])
				J.S_Object_("assign", [_s521["o"], {"face": ("s" if J.cmp(v_t2_1002, 0.7, "<") else "q"), "jit": J.mul(0.5, v_sh_1003), "sy": (1.0 - J.mul(0.06, v_sh_1003)), "sx": ((1.0 + J.mul(0.03, v_sh_1003)) * (0.45 + J.mul(0.55, v_sq_1004)))}])
				if (not J.t(J.gp(_s521["o"], "walk"))):
					var _t1732 = _s521["o"]
					var _t1733 = ("tremble" if J.cmp(v_t2_1002, 0.7, "<") else "look")
					J.sp(_t1732, "pose", _t1733)
				var _t1734 = _s521["o"]
				var _t1735 = J.cmp(v_t2_1002, 0.9, ">")
				var _t1736 = (J.cmp(v_t2_1002, 1.9, "<") if _t1735 else _t1735)
				J.sp(_t1734, "turn", _t1736)
				var _t1737 = _s521["o"]
				var _t1738 = (0.0 if J.cmp(v_t2_1002, 0.9, "<") else (J.div(J.sub(v_t2_1002, 0.9), 0.25) if J.cmp(v_t2_1002, 1.15, "<") else (1.0 if J.cmp(v_t2_1002, 1.65, "<") else ((1.0 - J.div(J.sub(v_t2_1002, 1.65), 0.25)) if J.cmp(v_t2_1002, 1.9, "<") else 0.0))))
				J.sp(_t1737, "turnK", _t1738)
				break
			break
		var _t1739 = _s521["o"]
		var _t1740 = J.gp(_s521["rx"], "k")
		J.sp(_t1739, "rxk", _t1740)
	return _s521["o"]

func _f233(this_, a: Array, env):
	var v_ctx_1007 = null; var v_n_1008 = null; var v_t_1009 = null; var v_vp_1010 = null; var v_x_1011 = null; var v_y_1012 = null; var v_hh_1013 = null; var v_d_1014 = null; var v_o_1015 = null; var v_right_1016 = null; var v_rig_1017 = null; var v_jx_1018 = null; var v_jy_1019 = null; var v_lift_1020 = null; var v_shk_1021 = null; var v_sit_1022 = null; var v_nap_1023 = null; var v_r_1024 = null; var v_sx_1025 = null; var v_sy_1026 = null; var v_sh_1027 = null; var v_r_1028 = null; var v_o_1029 = null
	v_ctx_1007 = J.arg(a, 0)
	v_n_1008 = J.arg(a, 1)
	v_t_1009 = J.arg(a, 2)
	var _t1741 = J.gp(this_, "_nat")
	var _t1745 = ((not J.seq(J.typeof_(J.G.get("__nat_scNpc")), "undefined")) if J.t(_t1741) else _t1741)
	if J.t(_t1745):
		var _t1744 = J.mc(this_, "office", [])
		if J.t(_t1744):
			var _t1742 = J.mc(J.G.get("OFFICE"), "seated", [v_n_1008])
			var _t1743 = ((not J.t(J.gp(v_n_1008, "out"))) if J.t(_t1742) else _t1742)
			_t1744 = (_t1743 if J.t(_t1743) else J.seq(J.gp(J.gp(v_n_1008, "d"), "k"), "mis"))
		_t1745 = (not J.t(_t1744))
	if J.t(_t1745):
		var _t1746 = J.G.get("__nat_scNpc")
		v_r_1024 = J.cl(_t1746, null, [v_ctx_1007, this_, v_n_1008, v_t_1009])
		return {"x": J.gp(v_r_1024, "x"), "top": J.gp(v_r_1024, "top")}
	var _t1747 = J.mc(this_, "office", [])
	var _t1748 = (J.mc(J.G.get("OFFICE"), "seated", [v_n_1008]) if J.t(_t1747) else _t1747)
	if J.t(((not J.t(J.gp(v_n_1008, "out"))) if J.t(_t1748) else _t1748)):
		var _t1749 = J.add(J.gp(v_n_1008, "x"), J.mc(J.G.get("OFFICE"), "kenOff", [v_n_1008]))
		J.sp(v_n_1008, "vX", _t1749)
		var _t1750 = J.gp(v_n_1008, "y")
		J.sp(v_n_1008, "vY", _t1750)
		var _t1751 = J.mc(this_, "pt", [J.gp(v_n_1008, "vX"), J.gp(v_n_1008, "y")])
		var _t1752 = J.gp(_t1751, 0.0)
		v_sx_1025 = _t1752
		var _t1753 = J.gp(_t1751, 1.0)
		v_sy_1026 = _t1753
		v_sh_1027 = J.mc(this_, "hh", [J.gp(v_n_1008, "y")])
		if J.seq(v_n_1008, J.gp(this_, "sel")):
			J.sp(v_ctx_1007, "fillStyle", "rgba(160,255,200,.28)")
			J.mc(v_ctx_1007, "beginPath", [])
			J.mc(v_ctx_1007, "ellipse", [J.sub(v_sx_1025, J.mul(v_sh_1027, 0.12)), v_sy_1026, J.mul(v_sh_1027, 0.4), J.mul(v_sh_1027, 0.09), 0.0, 0.0, (PI * 2.0)])
			J.mc(v_ctx_1007, "fill", [])
		v_r_1028 = J.mc(J.G.get("OFFICE"), "drawKen", [v_ctx_1007, v_n_1008, v_t_1009])
		v_o_1029 = J.mc(this_, "npcPose", [v_n_1008])
		J.sp(v_o_1029, "pose", "seat")
		J.mc(this_, "npcFx", [v_ctx_1007, v_n_1008, v_o_1029, J.gp(v_r_1028, "x"), J.add(J.gp(v_r_1028, "top"), J.gp(v_r_1028, "H")), J.gp(v_r_1028, "H"), false, v_t_1009])
		return {"x": J.gp(v_r_1028, "x"), "top": J.gp(v_r_1028, "top")}
	var _t1754 = J.mc(this_, "office", [])
	if J.t((J.gp(v_n_1008, "gone") if J.t(_t1754) else _t1754)):
		var _t1755 = J.max_([0.0, (1.0 - J.div(J.sub(J.gp(this_, "t"), J.gp(v_n_1008, "exitT")), 0.8))])
		J.sp(v_ctx_1007, "globalAlpha", _t1755)
	else:
		if J.t(J.gp(v_n_1008, "out")):
			var _t1757 = J.gp(this_, "t")
			var _t1756 = J.gp(v_n_1008, "outAt")
			var _t1759 = J.gp(this_, "t")
			var _t1758 = J.gp(v_n_1008, "outAt")
			var _t1760 = J.max_([0.0, (1.0 - J.div(J.sub(_t1759, (_t1758 if J.t(_t1758) else 0.0)), 0.6))])
			J.sp(v_ctx_1007, "globalAlpha", _t1760)
		else:
			var _t1761 = (not J.leq(J.gp(v_n_1008, "inAt"), null))
			if ((J.sub(J.gp(this_, "t"), J.gp(v_n_1008, "inAt")) < 0.6) if _t1761 else _t1761):
				var _t1762 = J.min_([1.0, J.div(J.sub(J.gp(this_, "t"), J.gp(v_n_1008, "inAt")), 0.6)])
				J.sp(v_ctx_1007, "globalAlpha", _t1762)
	v_vp_1010 = J.mc(this_, "visPos", [v_n_1008])
	if J.t(J.mc(this_, "office", [])):
		var _t1763 = J.add(J.gp(v_vp_1010, 0.0), J.mc(J.G.get("OFFICE"), "kenOff", [v_n_1008]))
		J.sp(v_vp_1010, 0.0, _t1763)
	var _t1764 = J.mc(this_, "pt", [J.gp(v_vp_1010, 0.0), J.gp(v_vp_1010, 1.0)])
	var _t1765 = J.gp(_t1764, 0.0)
	v_x_1011 = _t1765
	var _t1766 = J.gp(_t1764, 1.0)
	v_y_1012 = _t1766
	v_hh_1013 = J.mc(this_, "hh", [J.gp(v_vp_1010, 1.0)])
	v_d_1014 = J.gp(v_n_1008, "d")
	var _t1767 = J.gp(v_vp_1010, 0.0)
	J.sp(v_n_1008, "vX", _t1767)
	var _t1768 = J.gp(v_vp_1010, 1.0)
	J.sp(v_n_1008, "vY", _t1768)
	v_o_1015 = J.mc(this_, "npcPose", [v_n_1008])
	var _t1769 = J.gp(v_o_1015, "spd")
	J.sp(v_n_1008, "spd", _t1769)
	v_right_1016 = (J.cmp(J.gp(v_vp_1010, 2.0), 0.0, ">") if (not J.leq(J.gp(v_vp_1010, 2.0), null)) else J.cmp(J.gp(v_n_1008, "dir"), 0.0, ">"))
	var _t1770 = (not J.leq(J.gp(v_o_1015, "src"), null))
	var _t1771 = ((not J.t(J.gp(v_d_1014, "guard"))) if _t1770 else _t1770)
	var _t1772 = ((not J.t(J.gp(v_o_1015, "walk"))) if _t1771 else _t1771)
	if ((not J.t(J.gp(v_o_1015, "run"))) if _t1772 else _t1772):
		var _t1773 = J.cmp(J.gp(v_o_1015, "src"), J.gp(v_vp_1010, 0.0), ">=")
		v_right_1016 = _t1773
	if J.t(J.gp(v_o_1015, "turn")):
		v_right_1016 = (not J.t(v_right_1016))
	v_rig_1017 = J.mc(this_, "rigOK", [J.gp(v_d_1014, "spr")])
	v_jx_1018 = (J.mul(((randf() - 0.5) * 3.2), J.gp(v_o_1015, "jit")) if J.t(J.gp(v_o_1015, "jit")) else 0.0)
	v_jy_1019 = (J.mul(((randf() - 0.5) * 1.2), J.gp(v_o_1015, "jit")) if J.t(J.gp(v_o_1015, "jit")) else 0.0)
	v_lift_1020 = (J.mul(J.gp(v_o_1015, "lift"), v_hh_1013) * (0.1 if J.t(v_rig_1017) else 0.16))
	var _t1774 = J.seq(v_n_1008, J.gp(this_, "sel"))
	var _t1775 = ((not J.t(J.gp(v_n_1008, "gone"))) if _t1774 else _t1774)
	if ((not J.t(J.gp(v_n_1008, "fleeing"))) if _t1775 else _t1775):
		J.sp(v_ctx_1007, "fillStyle", "rgba(160,255,200,.28)")
		J.mc(v_ctx_1007, "beginPath", [])
		J.mc(v_ctx_1007, "ellipse", [v_x_1011, v_y_1012, J.mul(v_hh_1013, 0.34), J.mul(v_hh_1013, 0.08), 0.0, 0.0, (PI * 2.0)])
		J.mc(v_ctx_1007, "fill", [])
	v_shk_1021 = (1.0 - J.min_([0.5, J.mul(J.gp(v_o_1015, "lift"), 0.35)]))
	J.sp(v_ctx_1007, "fillStyle", "rgba(0,0,0,.35)")
	J.mc(v_ctx_1007, "beginPath", [])
	J.mc(v_ctx_1007, "ellipse", [v_x_1011, v_y_1012, (J.mul(J.mul(v_hh_1013, 0.22), v_shk_1021) * (1.2 if J.seq(J.gp(v_o_1015, "pose"), "cower") else 1.0)), J.mul(J.mul(v_hh_1013, 0.05), v_shk_1021), 0.0, 0.0, (PI * 2.0)])
	J.mc(v_ctx_1007, "fill", [])
	v_sit_1022 = (J.mul(v_hh_1013, 0.22) if J.t(J.mc(this_, "sitting", [v_n_1008])) else 0.0)
	var _t1776 = (J.seq(J.gp(v_d_1014, "k"), "mis") if J.t(v_sit_1022) else v_sit_1022)
	if J.t(((not J.t(J.gp(v_o_1015, "src"))) if J.t(_t1776) else _t1776)):
		v_right_1016 = true
	J.mc(v_ctx_1007, "save", [])
	if J.t(v_sit_1022):
		J.mc(v_ctx_1007, "beginPath", [])
		J.mc(v_ctx_1007, "rect", [J.sub(v_x_1011, v_hh_1013), J.sub(v_y_1012, J.mul(v_hh_1013, 2.0)), J.mul(v_hh_1013, 2.0), (J.mul(v_hh_1013, 2.0) - J.mul(v_hh_1013, 0.02))])
		J.mc(v_ctx_1007, "clip", [])
	J.mc(v_ctx_1007, "translate", [J.add(v_x_1011, v_jx_1018), J.add(J.sub(J.add(v_y_1012, v_jy_1019), v_lift_1020), v_sit_1022)])
	if J.t(J.gp(v_o_1015, "rot")):
		J.mc(v_ctx_1007, "rotate", [J.mul(J.gp(v_o_1015, "rot"), (1.0 if J.t(v_right_1016) else (-1.0)))])
	J.mc(v_ctx_1007, "scale", [J.gp(v_o_1015, "sx"), J.gp(v_o_1015, "sy")])
	if J.t(J.gp(v_d_1014, "tint")):
		var _t1777 = J.gp(v_d_1014, "tint")
		J.sp(v_ctx_1007, "filter", _t1777)
	var _t1778 = J.seq(J.gp(v_d_1014, "k"), "mis")
	var _t1779 = (J.mc(this_, "office", []) if _t1778 else _t1778)
	if J.t((J.mc(J.G.get("OFFICE"), "drawMis", [v_ctx_1007, v_n_1008, v_o_1015, v_hh_1013, v_right_1016, v_t_1009]) if J.t(_t1779) else _t1779)):
		pass
	else:
		if J.t(v_rig_1017):
			var _t1780 = J.G.get("__scDC")
			var _t1782 = J.gp(v_d_1014, "spr")
			var _t1783 = J.div(v_hh_1013, J.G.get("NPC_UNIT"))
			var _t1781 = J.gp(v_n_1008, "at")
			J.cl(_t1780, null, [v_ctx_1007, _t1782, 0.0, 0.0, _t1783, J.S_Object_("assign", [{"t": (_t1781 if J.t(_t1781) else 0.0), "pose": J.gp(v_o_1015, "pose"), "pt": J.gp(v_o_1015, "pt"), "face": J.gp(v_o_1015, "face"), "flip": (not J.t(v_right_1016)), "walk": J.gp(v_o_1015, "walk"), "shadow": false}, (J.mc(J.G.get("TOWN"), "npcOpts", [v_n_1008]) if (not J.seq(J.typeof_(J.G.get("TOWN")), "undefined")) else {})])])
		else:
			J.mc(this_, "drawNpcSprite", [v_ctx_1007, v_n_1008, v_o_1015, v_hh_1013, v_right_1016])
	J.sp(v_ctx_1007, "filter", "none")
	J.mc(v_ctx_1007, "restore", [])
	var _t1784 = J.gp(v_d_1014, "mop")
	var _t1785 = (J.seq(J.gp(v_o_1015, "pose"), "mop") if J.t(_t1784) else _t1784)
	if J.t(((randf() < 0.05) if J.t(_t1785) else _t1785)):
		var _t1786 = J.gp(this_, "parts")
		J.mc(_t1786, "push", [{"kind": "drop", "x": J.add(J.gp(v_vp_1010, 0.0), ((1.0 if J.t(v_right_1016) else (-1.0)) * 0.05)), "y": J.gp(v_vp_1010, 1.0), "vx": 0.0, "vy": 0.0, "life": 1.4}])
	J.mc(this_, "npcFx", [v_ctx_1007, v_n_1008, v_o_1015, J.add(v_x_1011, v_jx_1018), J.sub(v_y_1012, v_lift_1020), v_hh_1013, v_right_1016, v_t_1009])
	J.sp(v_ctx_1007, "globalAlpha", 1.0)
	var _t1787 = J.seq(J.gp(v_n_1008, "act"), "brk_nap")
	var _t1788 = (J.gp(v_n_1008, "daily") if _t1787 else _t1787)
	var _t1789 = (J.gp(J.gp(v_n_1008, "daily"), "forced") if J.t(_t1788) else _t1788)
	v_nap_1023 = (J.mul(v_hh_1013, 0.15) if J.t((J.cmp(J.gp(J.gp(v_n_1008, "daily"), "w"), 0.5, ">") if J.t(_t1789) else _t1789)) else 0.0)
	return {"x": v_x_1011, "top": J.sub(J.add(J.add(J.sub(v_y_1012, v_lift_1020), v_sit_1022), v_nap_1023), J.mul(J.mul(v_hh_1013, (0.8 if J.seq(J.gp(v_o_1015, "pose"), "cower") else 1.0)), J.gp(v_o_1015, "sy")))}

func _f234(this_, a: Array, env):
	var v_ctx_1032 = null; var v_n_1033 = null; var v_o_1034 = null; var v_hh_1035 = null; var v_right_1036 = null; var v_spr_1037 = null; var v_w_1038 = null; var v_a_1039 = null; var v_bob_1040 = null; var v_tilt_1041 = null; var v_sx_1042 = null; var v_sy_1043 = null
	v_ctx_1032 = J.arg(a, 0)
	v_n_1033 = J.arg(a, 1)
	v_o_1034 = J.arg(a, 2)
	v_hh_1035 = J.arg(a, 3)
	v_right_1036 = J.arg(a, 4)
	v_spr_1037 = J.gp(J.G.get("SPR"), J.gp(J.gp(v_n_1033, "d"), "spr"))
	var _t1790 = (not J.t(v_spr_1037))
	var _t1791 = (_t1790 if _t1790 else (not J.t(J.gp(v_spr_1037, "complete"))))
	if (_t1791 if _t1791 else (not J.t(J.gp(v_spr_1037, "naturalWidth")))):
		return null
	v_w_1038 = J.div(J.mul(v_hh_1035, J.gp(v_spr_1037, "naturalWidth")), J.gp(v_spr_1037, "naturalHeight"))
	var _t1792 = J.gp(v_n_1033, "at")
	v_a_1039 = (_t1792 if J.t(_t1792) else 0.0)
	v_bob_1040 = 0.0
	v_tilt_1041 = 0.0
	v_sx_1042 = 1.0
	v_sy_1043 = (1.0 + (sin(J.num(J.mul(v_a_1039, 2.2))) * 0.012))
	var _t1793 = J.gp(v_o_1034, "pose")
	var _t1794 = -1
	var _t1795 = false
	if _t1794 == -1 and J.seq(_t1793, "move"): _t1794 = 0
	if _t1794 == -1 and J.seq(_t1793, "run"): _t1794 = 1
	if _t1794 == -1 and J.seq(_t1793, "startle"): _t1794 = 2
	if _t1794 == -1 and J.seq(_t1793, "cower"): _t1794 = 3
	if _t1794 == -1 and J.seq(_t1793, "tremble"): _t1794 = 4
	if _t1794 == -1 and J.seq(_t1793, "phone"): _t1794 = 5
	if _t1794 == -1 and J.seq(_t1793, "mop"): _t1794 = 6
	if _t1794 == -1 and J.seq(_t1793, "look"): _t1794 = 7
	if _t1794 == -1 and J.seq(_t1793, "hurt"): _t1794 = 8
	if _t1794 == -1 and J.seq(_t1793, "sip"): _t1794 = 9
	while true:
		if _t1794 <= 0 and _t1794 >= 0:
			var _t1796 = (J.mul(absf(J.num(sin(J.num(J.mul(v_a_1039, 9.0))))), v_hh_1035) * 0.05)
			v_bob_1040 = _t1796
			var _t1797 = (sin(J.num(J.mul(v_a_1039, 9.0))) * 0.04)
			v_tilt_1041 = _t1797
			break
		if _t1794 <= 1 and _t1794 >= 0:
			var _t1798 = (J.mul(absf(J.num(sin(J.num(J.mul(v_a_1039, 11.0))))), v_hh_1035) * 0.08)
			v_bob_1040 = _t1798
			var _t1799 = (0.22 + (sin(J.num(J.mul(v_a_1039, 11.0))) * 0.06))
			v_tilt_1041 = _t1799
			v_sx_1042 = 1.04
			break
		if _t1794 <= 2 and _t1794 >= 0:
			var _t1800 = ((-0.25) * sin(J.num((J.min_([1.0, J.mul(J.gp(v_o_1034, "pt"), 1.6)]) * PI))))
			v_tilt_1041 = _t1800
			break
		if _t1794 <= 3 and _t1794 >= 0:
			var _t1801 = (0.8 + (sin(J.num(J.mul(v_a_1039, 30.0))) * 0.015))
			v_sy_1043 = _t1801
			v_sx_1042 = 1.1
			v_tilt_1041 = 0.12
			break
		if _t1794 <= 4 and _t1794 >= 0:
			var _t1802 = (sin(J.num(J.mul(v_a_1039, 40.0))) * 0.025)
			v_tilt_1041 = _t1802
			break
		if _t1794 <= 5 and _t1794 >= 0:
			var _t1803 = (0.06 + (sin(J.num(J.mul(v_a_1039, 1.3))) * 0.01))
			v_tilt_1041 = _t1803
			break
		if _t1794 <= 6 and _t1794 >= 0:
			var _t1804 = (sin(J.num(J.mul(v_a_1039, 4.0))) * 0.06)
			v_tilt_1041 = _t1804
			break
		if _t1794 <= 7 and _t1794 >= 0:
			var _t1805 = (sin(J.num(J.mul(v_a_1039, 1.6))) * 0.05)
			v_tilt_1041 = _t1805
			break
		if _t1794 <= 8 and _t1794 >= 0:
			var _t1806 = ((-0.2) * J.sub(1.0, J.gp(v_o_1034, "pt")))
			v_tilt_1041 = _t1806
			break
		if _t1794 <= 9 and _t1794 >= 0:
			var _t1807 = ((-0.05) + (sin(J.num(J.mul(v_a_1039, 1.2))) * 0.03))
			v_tilt_1041 = _t1807
			break
		break
	J.mc(v_ctx_1032, "translate", [0.0, (-J.num(v_bob_1040))])
	J.mc(v_ctx_1032, "rotate", [J.mul(v_tilt_1041, (1.0 if J.t(v_right_1036) else (-1.0)))])
	J.mc(v_ctx_1032, "scale", [J.mul((1.0 if J.t(v_right_1036) else (-1.0)), v_sx_1042), v_sy_1043])
	J.mc(v_ctx_1032, "drawImage", [v_spr_1037, J.div((-J.num(v_w_1038)), 2.0), (-J.num(v_hh_1035)), v_w_1038, v_hh_1035])

func _f236(this_, a: Array, env):
	var v_ch_1097 = null; var v_i_1098 = null; var v_ox_1099 = null; var v_oy_1100 = null
	v_ch_1097 = J.arg(a, 0)
	v_i_1098 = J.arg(a, 1)
	v_ox_1099 = J.add(J.add(env["x0"], J.mul(v_i_1098, env["step"])), ((randf() - 0.5) * 3.0))
	v_oy_1100 = ((J.sub(env["__p"]["y"], J.mul(env["__p"]["hh"], 0.5)) + (sin(J.num(J.add(J.mul(env["__p"]["t"], 25.0), v_i_1098))) * 2.5)) - J.mul(v_i_1098, 1.5))
	J.mc(env["__p"]["ctx"], "strokeText", [v_ch_1097, v_ox_1099, v_oy_1100])
	J.mc(env["__p"]["ctx"], "fillText", [v_ch_1097, v_ox_1099, v_oy_1100])

func _f235(this_, a: Array, env):
	var v_n_1047 = null; var v_o_1048 = null; var v_x_1049 = null; var v_right_1052 = null; var v_side_1054 = null; var v_hy_1055 = null; var v_hx_1056 = null; var v_goose_1057 = null; var v_gx_1058 = null; var v_gy_1059 = null; var v_r_1060 = null; var v_fl_1061 = null; var v_g_1062 = null; var v_s_1063 = null; var v_i_1064 = null; var v_bx_1065 = null; var v_by_1066 = null; var v_j_1067 = null; var v_k_1068 = null; var v_i_1069 = null; var v_bx_1070 = null; var v_by_1071 = null; var v_k_1072 = null; var v_i_1073 = null; var v_a_1074 = null; var v_r0_1075 = null; var v_r1_1076 = null; var v_dx_1077 = null; var v_dy_1078 = null; var v_i_1079 = null; var v_bx_1080 = null; var v_s_1081 = null; var v_s_1082 = null; var v_i_1083 = null; var v_r_1084 = null; var v_i_1085 = null; var v_q_1086 = null; var v_i_1087 = null; var v_ly_1088 = null; var v_lx_1089 = null; var v_k_1090 = null; var v_chars_1091 = null; var v_fs_1092 = null; var v_w_1094 = null; var v_sd_1095 = null
	var _s542 = {"__p": env, "ctx": null, "y": null, "hh": null, "t": null}
	_s542["ctx"] = J.arg(a, 0)
	v_n_1047 = J.arg(a, 1)
	v_o_1048 = J.arg(a, 2)
	v_x_1049 = J.arg(a, 3)
	_s542["y"] = J.arg(a, 4)
	_s542["hh"] = J.arg(a, 5)
	v_right_1052 = J.arg(a, 6)
	_s542["t"] = J.arg(a, 7)
	v_side_1054 = (1.0 if J.t(v_right_1052) else (-1.0))
	v_hy_1055 = J.sub(_s542["y"], J.mul(_s542["hh"], 0.86))
	v_hx_1056 = J.add(v_x_1049, (J.mul(v_side_1054, _s542["hh"]) * 0.03))
	J.mc(_s542["ctx"], "save", [])
	var _t1808 = _s542["ctx"]
	J.sp(_t1808, "lineCap", "round")
	var _t1809 = J.seq(J.gp(v_o_1048, "pose"), "phone")
	if ((not J.t(J.gp(v_o_1048, "rxk"))) if _t1809 else _t1809):
		v_gx_1058 = J.add(v_x_1049, (J.mul(v_side_1054, _s542["hh"]) * 0.14))
		v_gy_1059 = J.sub(_s542["y"], J.mul(_s542["hh"], 0.66))
		v_r_1060 = J.mul(_s542["hh"], 0.3)
		v_fl_1061 = ((0.3 + (0.06 * sin(J.num(J.add(J.mul(_s542["t"], 3.0), J.gp(v_n_1047, "ph")))))) + (0.15 if (sin(J.num(J.add(J.mul(_s542["t"], 0.7), J.gp(v_n_1047, "ph")))) > 0.92) else 0.0))
		v_g_1062 = J.mc(_s542["ctx"], "createRadialGradient", [v_gx_1058, v_gy_1059, 0.0, v_gx_1058, v_gy_1059, v_r_1060])
		J.mc(v_g_1062, "addColorStop", [0.0, ("rgba(150,220,255," + J.str(v_fl_1061) + ")")])
		J.mc(v_g_1062, "addColorStop", [1.0, "rgba(150,220,255,0)"])
		var _t1810 = _s542["ctx"]
		J.sp(_t1810, "globalCompositeOperation", "lighter")
		var _t1811 = _s542["ctx"]
		J.sp(_t1811, "fillStyle", v_g_1062)
		J.mc(_s542["ctx"], "beginPath", [])
		J.mc(_s542["ctx"], "arc", [v_gx_1058, v_gy_1059, v_r_1060, 0.0, (PI * 2.0)])
		J.mc(_s542["ctx"], "fill", [])
		var _t1812 = _s542["ctx"]
		J.sp(_t1812, "globalCompositeOperation", "source-over")
	var _t1813 = J.gp(v_n_1047, "goose")
	var _t1815 = (_t1813 if J.t(_t1813) else 0.0)
	var _t1814 = J.seq(J.gp(v_o_1048, "face"), "f")
	var _t1816 = J.gp(v_n_1047, "goose")
	var _t1818 = (_t1816 if J.t(_t1816) else 0.0)
	var _t1817 = J.seq(J.gp(v_o_1048, "face"), "f")
	v_goose_1057 = J.max_([_t1818, (0.6 if (_t1817 if _t1817 else J.seq(J.gp(v_o_1048, "face"), "t")) else 0.0)])
	if J.cmp(v_goose_1057, 0.0, ">"):
		var _t1819 = _s542["ctx"]
		var _t1820 = ("rgba(255,255,255," + J.str(J.min_([0.85, J.mul(v_goose_1057, 0.7)])) + ")")
		J.sp(_t1819, "strokeStyle", _t1820)
		var _t1821 = _s542["ctx"]
		J.sp(_t1821, "lineWidth", 1.4)
		for _t1822 in J.iter([(-1.0), 1.0]):
			v_s_1063 = _t1822
			v_i_1064 = 0.0
			while true:
				if not J.cmp(v_i_1064, 3.0, "<"): break
				v_bx_1065 = J.add(v_x_1049, (J.mul(v_s_1063, _s542["hh"]) * (0.24 + (0.03 * sin(J.num(J.add(J.mul(_s542["t"], 20.0), v_i_1064)))))))
				v_by_1066 = J.sub(_s542["y"], J.mul(_s542["hh"], (0.62 - J.mul(v_i_1064, 0.09))))
				J.mc(_s542["ctx"], "beginPath", [])
				J.mc(_s542["ctx"], "moveTo", [v_bx_1065, v_by_1066])
				v_j_1067 = 1.0
				while true:
					if not J.cmp(v_j_1067, 3.0, "<="): break
					J.mc(_s542["ctx"], "lineTo", [J.add(v_bx_1065, (J.mul(v_s_1063, v_j_1067) * 3.0)), J.add(v_by_1066, ((-3.0) if J.t(J.mod(v_j_1067, 2.0)) else 3.0))])
					v_j_1067 = J.num(v_j_1067) + 1.0
				J.mc(_s542["ctx"], "stroke", [])
				v_i_1064 = J.num(v_i_1064) + 1.0
	if J.cmp(J.gp(v_n_1047, "hair"), 0.0, ">"):
		v_k_1068 = J.min_([1.0, J.gp(v_n_1047, "hair")])
		var _t1823 = _s542["ctx"]
		var _t1824 = ("rgba(30,24,30," + J.str(v_k_1068) + ")")
		J.sp(_t1823, "strokeStyle", _t1824)
		var _t1825 = _s542["ctx"]
		J.sp(_t1825, "lineWidth", 2.0)
		v_i_1069 = (-2.0)
		while true:
			if not J.cmp(v_i_1069, 2.0, "<="): break
			v_bx_1070 = J.add(v_hx_1056, (J.mul(v_i_1069, _s542["hh"]) * 0.045))
			v_by_1071 = J.sub(v_hy_1055, J.mul(_s542["hh"], 0.06))
			J.mc(_s542["ctx"], "beginPath", [])
			J.mc(_s542["ctx"], "moveTo", [v_bx_1070, v_by_1071])
			J.mc(_s542["ctx"], "quadraticCurveTo", [J.add(v_bx_1070, (sin(J.num(J.add(J.mul(_s542["t"], 50.0), v_i_1069))) * 2.5)), J.sub(v_by_1071, J.mul(J.mul(_s542["hh"], 0.07), v_k_1068)), J.add(v_bx_1070, J.mul(v_i_1069, 1.5)), J.sub(v_by_1071, J.mul(J.mul(_s542["hh"], 0.14), v_k_1068))])
			J.mc(_s542["ctx"], "stroke", [])
			v_i_1069 = J.num(v_i_1069) + 1.0
	if J.cmp(J.gp(v_n_1047, "shock"), 0.0, ">"):
		v_k_1072 = (1.0 - J.div(J.gp(v_n_1047, "shock"), 0.5))
		var _t1826 = _s542["ctx"]
		var _t1827 = ("rgba(255,236,150," + J.str(J.min_([1.0, J.mul(J.gp(v_n_1047, "shock"), 3.0)])) + ")")
		J.sp(_t1826, "strokeStyle", _t1827)
		var _t1828 = _s542["ctx"]
		J.sp(_t1828, "lineWidth", 2.2)
		v_i_1073 = 0.0
		while true:
			if not J.cmp(v_i_1073, 9.0, "<"): break
			v_a_1074 = ((((-PI) * 0.95) + (J.div((J.mul(v_i_1073, PI) * 0.95), 8.0) * 1.0)) - 0.05)
			v_r0_1075 = J.mul(_s542["hh"], (0.2 + J.mul(v_k_1072, 0.08)))
			v_r1_1076 = J.add(v_r0_1075, J.mul(_s542["hh"], 0.1))
			J.mc(_s542["ctx"], "beginPath", [])
			J.mc(_s542["ctx"], "moveTo", [J.add(v_hx_1056, J.mul(cos(J.num(v_a_1074)), v_r0_1075)), J.add(v_hy_1055, J.mul(sin(J.num(v_a_1074)), v_r0_1075))])
			J.mc(_s542["ctx"], "lineTo", [J.add(v_hx_1056, J.mul(cos(J.num(v_a_1074)), v_r1_1076)), J.add(v_hy_1055, J.mul(sin(J.num(v_a_1074)), v_r1_1076))])
			J.mc(_s542["ctx"], "stroke", [])
			v_i_1073 = J.num(v_i_1073) + 1.0
	var _t1829 = J.seq(J.gp(v_o_1048, "rxk"), "rational")
	if (_t1829 if _t1829 else J.seq(J.gp(v_o_1048, "rxk"), "numb")):
		var _t1830 = _s542["ctx"]
		J.sp(_t1830, "strokeStyle", "rgba(40,40,90,.75)")
		var _t1831 = _s542["ctx"]
		J.sp(_t1831, "lineWidth", 1.6)
		v_i_1079 = 0.0
		while true:
			if not J.cmp(v_i_1079, 3.0, "<"): break
			v_bx_1080 = (J.sub(v_hx_1056, (J.mul(v_side_1054, _s542["hh"]) * 0.02)) + (J.mul(J.sub(v_i_1079, 1.0), _s542["hh"]) * 0.035))
			J.mc(_s542["ctx"], "beginPath", [])
			J.mc(_s542["ctx"], "moveTo", [v_bx_1080, J.sub(v_hy_1055, J.mul(_s542["hh"], 0.02))])
			J.mc(_s542["ctx"], "lineTo", [v_bx_1080, J.add(v_hy_1055, J.mul(_s542["hh"], (0.06 + (0.02 if J.seq(v_i_1079, 1.0) else 0.0))))])
			J.mc(_s542["ctx"], "stroke", [])
			v_i_1079 = J.num(v_i_1079) + 1.0
		v_dx_1077 = J.sub(v_hx_1056, (J.mul(v_side_1054, _s542["hh"]) * 0.13))
		v_dy_1078 = J.add(J.add(v_hy_1055, J.mul(_s542["hh"], 0.02)), ((J.mul(J.min_([1.0, J.gp(J.gp(v_n_1047, "rx"), "t")]), _s542["hh"]) * 0.05) if J.t(J.gp(v_n_1047, "rx")) else 0.0))
		var _t1832 = _s542["ctx"]
		J.sp(_t1832, "fillStyle", "rgba(160,215,255,.95)")
		J.mc(_s542["ctx"], "beginPath", [])
		J.mc(_s542["ctx"], "moveTo", [v_dx_1077, J.sub(v_dy_1078, 6.0)])
		J.mc(_s542["ctx"], "quadraticCurveTo", [J.add(v_dx_1077, 4.5), J.add(v_dy_1078, 2.0), v_dx_1077, J.add(v_dy_1078, 3.5)])
		J.mc(_s542["ctx"], "quadraticCurveTo", [J.sub(v_dx_1077, 4.5), J.add(v_dy_1078, 2.0), v_dx_1077, J.sub(v_dy_1078, 6.0)])
		J.mc(_s542["ctx"], "fill", [])
		if J.cmp(J.gp(v_o_1048, "shrug"), 0.2, ">"):
			var _t1833 = _s542["ctx"]
			var _t1834 = ("rgba(255,255,255," + J.str(J.mul(J.gp(v_o_1048, "shrug"), 0.7)) + ")")
			J.sp(_t1833, "strokeStyle", _t1834)
			var _t1835 = _s542["ctx"]
			J.sp(_t1835, "lineWidth", 1.5)
			for _t1836 in J.iter([(-1.0), 1.0]):
				v_s_1081 = _t1836
				J.mc(_s542["ctx"], "beginPath", [])
				J.mc(_s542["ctx"], "arc", [J.add(v_x_1049, (J.mul(v_s_1081, _s542["hh"]) * 0.26)), J.sub(_s542["y"], J.mul(_s542["hh"], 0.62)), 5.0, ((-1.2) if J.cmp(v_s_1081, 0.0, ">") else ((PI + 1.2) - 2.4)), (((1.2 - 2.4) + 2.4) if J.cmp(v_s_1081, 0.0, ">") else (PI + 1.2))])
				J.mc(_s542["ctx"], "stroke", [])
	var _t1837 = J.seq(J.gp(v_o_1048, "pose"), "tremble")
	var _t1839 = (_t1837 if _t1837 else J.seq(J.gp(v_o_1048, "pose"), "cower"))
	if not J.t(_t1839):
		var _t1838 = J.cmp(J.gp(v_o_1048, "jit"), 0.5, ">")
		_t1839 = ((not J.t(J.gp(v_o_1048, "run"))) if _t1838 else _t1838)
	if _t1839:
		var _t1840 = _s542["ctx"]
		J.sp(_t1840, "strokeStyle", "rgba(255,200,180,.55)")
		var _t1841 = _s542["ctx"]
		J.sp(_t1841, "lineWidth", 1.5)
		for _t1842 in J.iter([(-1.0), 1.0]):
			v_s_1082 = _t1842
			v_i_1083 = 0.0
			while true:
				if not J.cmp(v_i_1083, 2.0, "<"): break
				v_r_1084 = (J.mul(_s542["hh"], (0.3 + J.mul(v_i_1083, 0.06))) + (sin(J.num(J.mul(_s542["t"], 30.0))) * 1.5))
				J.mc(_s542["ctx"], "beginPath", [])
				J.mc(_s542["ctx"], "arc", [v_x_1049, J.sub(_s542["y"], J.mul(_s542["hh"], 0.45)), v_r_1084, ((-0.35) if J.cmp(v_s_1082, 0.0, ">") else (PI - 0.35)), (0.35 if J.cmp(v_s_1082, 0.0, ">") else (PI + 0.35))])
				J.mc(_s542["ctx"], "stroke", [])
				v_i_1083 = J.num(v_i_1083) + 1.0
	var _t1843 = J.gp(v_o_1048, "doze")
	var _t1846 = ((not J.t(J.gp(v_o_1048, "rxk"))) if J.t(_t1843) else _t1843)
	if J.t(_t1846):
		var _t1844 = J.gp(v_n_1047, "daily")
		var _t1845 = (J.gp(J.gp(v_n_1047, "daily"), "forced") if J.t(_t1844) else _t1844)
		_t1846 = (not J.t((J.cmp(J.gp(J.gp(v_n_1047, "daily"), "w"), 0.0, ">") if J.t(_t1845) else _t1845)))
	if J.t(_t1846):
		var _t1847 = _s542["ctx"]
		J.sp(_t1847, "font", "800 13px sans-serif")
		var _t1848 = _s542["ctx"]
		J.sp(_t1848, "textAlign", "center")
		v_i_1085 = 0.0
		while true:
			if not J.cmp(v_i_1085, 3.0, "<"): break
			v_q_1086 = J.mod((J.mul(_s542["t"], 0.45) + J.div(v_i_1085, 3.0)), 1.0)
			var _t1849 = _s542["ctx"]
			var _t1850 = ("rgba(220,230,255," + J.str((0.85 * sin(J.num(J.mul(v_q_1086, PI))))) + ")")
			J.sp(_t1849, "fillStyle", _t1850)
			J.mc(_s542["ctx"], "fillText", ["Z", J.add(v_x_1049, (J.mul(v_side_1054, _s542["hh"]) * (0.18 + J.mul(v_q_1086, 0.15)))), J.sub(_s542["y"], J.mul(_s542["hh"], (0.95 + J.mul(v_q_1086, 0.3))))])
			v_i_1085 = J.num(v_i_1085) + 1.0
	if J.t(J.gp(v_o_1048, "run")):
		var _t1851 = _s542["ctx"]
		J.sp(_t1851, "strokeStyle", "rgba(255,255,255,.45)")
		var _t1852 = _s542["ctx"]
		J.sp(_t1852, "lineWidth", 2.0)
		v_i_1087 = 0.0
		while true:
			if not J.cmp(v_i_1087, 4.0, "<"): break
			v_ly_1088 = J.sub(_s542["y"], J.mul(_s542["hh"], (0.25 + J.mul(v_i_1087, 0.17))))
			v_lx_1089 = J.sub(v_x_1049, (J.mul(v_side_1054, _s542["hh"]) * (0.3 + (J.mod((J.mul(_s542["t"], 3.0) + J.mul(v_i_1087, 0.37)), 1.0) * 0.15))))
			J.mc(_s542["ctx"], "beginPath", [])
			J.mc(_s542["ctx"], "moveTo", [v_lx_1089, v_ly_1088])
			J.mc(_s542["ctx"], "lineTo", [J.sub(v_lx_1089, (J.mul(v_side_1054, _s542["hh"]) * 0.25)), v_ly_1088])
			J.mc(_s542["ctx"], "stroke", [])
			v_i_1087 = J.num(v_i_1087) + 1.0
	var _t1853 = J.gp(v_o_1048, "run")
	if J.t(((not J.t(J.gp(v_n_1047, "bub"))) if J.t(_t1853) else _t1853)):
		var _s571 = {"__p": _s542, "step": null, "x0": null}
		v_k_1090 = (J.min_([1.0, J.mul(J.gp(v_n_1047, "scream"), 2.0)]) if J.cmp(J.gp(v_n_1047, "scream"), 0.0, ">") else 0.75)
		v_chars_1091 = J.spread([J.SP(("哎呀——！" if J.seq(J.gp(J.gp(v_n_1047, "d"), "k"), "auntie") else "啊——！"))])
		v_fs_1092 = J.round(J.num((14.0 + J.mul(_s571["__p"]["hh"], 0.05))))
		_s571["step"] = J.mul(v_fs_1092, 0.85)
		v_w_1094 = J.mul(_s571["step"], J.len(v_chars_1091))
		v_sd_1095 = v_side_1054
		_s571["x0"] = (J.add(v_x_1049, J.mul(_s571["__p"]["hh"], 0.3)) if J.cmp(v_sd_1095, 0.0, ">") else J.sub(J.sub(v_x_1049, J.mul(_s571["__p"]["hh"], 0.3)), v_w_1094))
		if J.cmp(J.add(_s571["x0"], v_w_1094), J.sub(J.gp(this_, "W"), 6.0), ">"):
			var _t1854 = J.sub(J.sub(v_x_1049, J.mul(_s571["__p"]["hh"], 0.3)), v_w_1094)
			_s571["x0"] = _t1854
		if J.cmp(_s571["x0"], 6.0, "<"):
			var _t1855 = J.add(v_x_1049, J.mul(_s571["__p"]["hh"], 0.3))
			_s571["x0"] = _t1855
		var _t1856 = _s571["__p"]["ctx"]
		var _t1857 = ("900 " + J.str(v_fs_1092) + "px sans-serif")
		J.sp(_t1856, "font", _t1857)
		var _t1858 = _s571["__p"]["ctx"]
		J.sp(_t1858, "textAlign", "left")
		var _t1859 = _s571["__p"]["ctx"]
		J.sp(_t1859, "lineWidth", 3.5)
		var _t1860 = _s571["__p"]["ctx"]
		var _t1861 = ("rgba(0,0,0," + J.str(v_k_1090) + ")")
		J.sp(_t1860, "strokeStyle", _t1861)
		var _t1862 = _s571["__p"]["ctx"]
		var _t1863 = ("rgba(255,96,80," + J.str(v_k_1090) + ")")
		J.sp(_t1862, "fillStyle", _t1863)
		J.mc(v_chars_1091, "forEach", [Callable(self, "_f236").bind(_s571)])
	J.mc(_s542["ctx"], "restore", [])

func _f238(this_, a: Array, env):
	var v_f_1108 = null
	v_f_1108 = J.arg(a, 0)
	return J.seq(J.gp(v_f_1108, "kind"), "ghost")

func _f239(this_, a: Array, env):
	var v_f_1109 = null
	v_f_1109 = J.arg(a, 0)
	return J.gp(v_f_1109, "ghost")

func _f240(this_, a: Array, env):
	var v_n_1110 = null
	v_n_1110 = J.arg(a, 0)
	var _t1867 = J.gp(J.gp(v_n_1110, "d"), "guard")
	return ((not J.t(J.gp(v_n_1110, "gone"))) if J.t(_t1867) else _t1867)

func _f241(this_, a: Array, env):
	var v_k_1111 = null; var v_i_1112 = null; var v_ready_1113 = null; var v_dx_1114 = null; var v_x_1115 = null; var v_y_1116 = null; var v_a_1117 = null; var v_gx_1118 = null; var v_x_1119 = null; var v_y_1120 = null; var v_s_1121 = null; var v_j_1122 = null; var v_sx_1123 = null; var v_sy_1124 = null
	v_k_1111 = J.arg(a, 0)
	v_i_1112 = J.arg(a, 1)
	if J.t(J.mc(env["busy"], "has", [v_k_1111])):
		return null
	var _t1869 = J.gp(J.gp(env["this"], "caught"), v_k_1111)
	if J.t((env["g"] if J.t(_t1869) else _t1869)):
		env["ci"] = J.num(env["ci"]) + 1.0
		v_gx_1118 = J.sub(J.gp(env["g"], "x"), J.mul(J.mul(J.gp(env["g"], "dir"), 0.075), env["ci"]))
		var _t1870 = J.mc(env["this"], "pt", [v_gx_1118, J.add(J.gp(env["g"], "y"), 0.004)])
		var _t1871 = J.gp(_t1870, 0.0)
		v_x_1119 = _t1871
		var _t1872 = J.gp(_t1870, 1.0)
		v_y_1120 = _t1872
		v_s_1121 = J.div(J.mc(env["this"], "hh", [J.gp(env["g"], "y")]), 62.0)
		var _t1873 = J.G.get("__scDC")
		J.cl(_t1873, null, [env["ctx"], v_k_1111, v_x_1119, v_y_1120, v_s_1121, {"t": J.add(env["t"], v_i_1112), "pose": "idle", "alpha": 0.5, "flip": J.cmp(J.gp(env["g"], "x"), v_gx_1118, "<"), "shadow": false}])
		var _t1874 = env["ctx"]
		J.sp(_t1874, "strokeStyle", "rgba(255,255,255,.35)")
		var _t1875 = env["ctx"]
		J.sp(_t1875, "lineWidth", 1.5)
		v_j_1122 = 0.0
		while true:
			if not J.cmp(v_j_1122, 2.0, "<"): break
			v_sx_1123 = J.add(v_x_1119, (J.sub(v_j_1122, 0.5) * 6.0))
			v_sy_1124 = J.sub(v_y_1120, J.mul(v_s_1121, 66.0))
			J.mc(env["ctx"], "beginPath", [])
			J.mc(env["ctx"], "moveTo", [v_sx_1123, v_sy_1124])
			J.mc(env["ctx"], "bezierCurveTo", [J.add(v_sx_1123, 5.0), (J.sub(v_sy_1124, 6.0) - (sin(J.num(J.add(J.mul(env["t"], 3.0), v_j_1122))) * 3.0)), J.sub(v_sx_1123, 5.0), J.sub(v_sy_1124, 12.0), J.add(v_sx_1123, (sin(J.num(J.add(J.mul(env["t"], 2.0), v_j_1122))) * 3.0)), J.sub(v_sy_1124, 20.0)])
			J.mc(env["ctx"], "stroke", [])
			v_j_1122 = J.num(v_j_1122) + 1.0
		return null
	var _t1876 = (not J.t(J.gp(J.gp(env["this"], "caught"), v_k_1111)))
	var _t1877 = (J.cmp(J.gp(J.gp(env["this"], "cd"), v_k_1111), 0.0, "<=") if _t1876 else _t1876)
	v_ready_1113 = (J.cmp(J.gp(env["this"], "mana"), 35.0, ">=") if _t1877 else _t1877)
	v_dx_1114 = sin(J.num((J.mul(env["t"], 0.35) + J.mul(v_i_1112, 2.1))))
	v_x_1115 = (J.mul(J.gp(env["this"], "W"), (0.17 + J.mul(0.33, v_i_1112))) + (J.mul(v_dx_1114, J.gp(env["this"], "W")) * 0.06))
	v_y_1116 = J.add((J.gp(J.mc(env["this"], "pt", [0.0, 0.36]), 1.0) if J.t(J.gp(J.gp(env["this"], "site"), "pano")) else J.mul(J.gp(env["this"], "H"), 0.27)), (sin(J.num(J.add(J.mul(env["t"], 0.9), v_i_1112))) * 6.0))
	v_a_1117 = ((0.34 if J.t(v_ready_1113) else 0.13) + (0.06 * sin(J.num(J.add(J.mul(env["t"], 1.7), v_i_1112)))))
	var _t1878 = J.G.get("__scDC")
	J.cl(_t1878, null, [env["ctx"], v_k_1111, v_x_1115, v_y_1116, 0.8, {"t": J.add(env["t"], J.mul(v_i_1112, 1.3)), "pose": "idle", "alpha": v_a_1117, "flip": (cos(J.num((J.mul(env["t"], 0.35) + J.mul(v_i_1112, 2.1)))) < 0.0), "shadow": false}])

func _f237(this_, a: Array, env):
	var _s573 = {"__p": env, "this": null, "ctx": null, "t": null, "busy": null, "g": null, "ci": null}
	_s573["this"] = this_
	_s573["ctx"] = J.arg(a, 0)
	_s573["t"] = J.arg(a, 1)
	var _t1864 = J.gp(_s573["this"], "fx")
	var _t1865 = J.mc(_t1864, "filter", [Callable(self, "_f238").bind(_s573)])
	_s573["busy"] = J.new_("Set", [J.mc(_t1865, "map", [Callable(self, "_f239").bind(_s573)])])
	var _t1866 = J.gp(_s573["this"], "npcs")
	_s573["g"] = J.mc(_t1866, "find", [Callable(self, "_f240").bind(_s573)])
	_s573["ci"] = 0.0
	var _t1868 = J.gp(_s573["this"], "team")
	J.mc(_t1868, "forEach", [Callable(self, "_f241").bind(_s573)])

func _f242(this_, a: Array, env):
	var v_ctx_1127 = null; var v_f_1128 = null; var v_t_1129 = null; var v_k_1130 = null; var v_H_1131 = null; var v_W_1132 = null; var v_gx_1133 = null; var v_gy_1134 = null; var v_a_1135 = null; var v_n_1136 = null; var v_tx_1137 = null; var v_faceL_1138 = null; var v_side_1139 = null; var v_ph_1140 = null; var v_hit_1141 = null; var v_wind_1142 = null; var v_sc_1143 = null; var v_img_1144 = null; var v_hh_1145 = null; var v_w_1146 = null; var v_e_1147 = null; var v_back_1148 = null; var v_up_1149 = null; var v_drop_1150 = null; var v_wy_1151 = null; var v_x_1152 = null; var v_y_1153 = null; var v_q_1154 = null; var v_pose_1155 = null; var v_pq_1156 = null; var v_bump_1157 = null; var v_e_1158 = null; var v_x_1159 = null; var v_y_1160 = null; var v_i_1161 = null; var v_x_1162 = null; var v_hop_1163 = null; var v_y_1164 = null; var v_rise_1165 = null; var v_lunge_1166 = null; var v_pose_1167 = null; var v_pt_1168 = null; var v_q_1169 = null; var v_px_1170 = null; var v_py_1171 = null; var v_hh_1172 = null
	v_ctx_1127 = J.arg(a, 0)
	v_f_1128 = J.arg(a, 1)
	v_t_1129 = J.arg(a, 2)
	v_k_1130 = (1.0 - J.div(J.gp(v_f_1128, "life"), J.gp(v_f_1128, "max")))
	v_H_1131 = J.gp(this_, "H")
	v_W_1132 = J.gp(this_, "W")
	var _t1879 = J.mc(this_, "pt", [J.gp(v_f_1128, "gx"), J.gp(v_f_1128, "gy")])
	var _t1880 = J.gp(_t1879, 0.0)
	v_gx_1133 = _t1880
	var _t1881 = J.gp(_t1879, 1.0)
	v_gy_1134 = _t1881
	v_a_1135 = J.min_([1.0, J.mul(v_k_1130, 6.0), J.mul(J.gp(v_f_1128, "life"), 2.2)])
	if J.cmp(v_k_1130, 0.16, "<"):
		var _t1882 = J.mul(v_a_1135, (0.7 + (0.3 * sin(J.num(J.mul(v_t_1129, 40.0))))))
		v_a_1135 = _t1882
	if J.t(J.gp(v_f_1128, "caught")):
		var _t1883 = J.mul(v_a_1135, 0.55)
		v_a_1135 = _t1883
	v_n_1136 = J.gp(v_f_1128, "n")
	v_tx_1137 = ((J.gp(v_n_1136, "vX") if (not J.leq(J.gp(v_n_1136, "vX"), null)) else J.gp(v_n_1136, "x")) if J.t(v_n_1136) else 0.5)
	v_faceL_1138 = (J.cmp(v_tx_1137, J.gp(v_f_1128, "gx"), "<") if J.t(v_n_1136) else J.cmp(J.gp(v_f_1128, "gx"), 0.5, ">"))
	v_side_1139 = ((-1.0) if J.t(v_faceL_1138) else 1.0)
	v_ph_1140 = (["idle", 0.0] if J.cmp(v_k_1130, 0.2, "<") else (["windup", J.div(J.sub(v_k_1130, 0.2), 0.175)] if J.cmp(v_k_1130, 0.375, "<") else (["strike", J.div(J.sub(v_k_1130, 0.375), 0.175)] if J.cmp(v_k_1130, 0.55, "<") else (["recover", J.div(J.sub(v_k_1130, 0.55), 0.27)] if J.cmp(v_k_1130, 0.82, "<") else ["idle", 0.0]))))
	v_hit_1141 = (sin(J.num(J.div((J.min_([1.0, J.mul(J.gp(v_ph_1140, 1.0), 1.4)]) * PI), 2.0))) if J.seq(J.gp(v_ph_1140, 0.0), "strike") else (J.sub(1.0, J.gp(v_ph_1140, 1.0)) if J.seq(J.gp(v_ph_1140, 0.0), "recover") else 0.0))
	v_wind_1142 = (J.gp(v_ph_1140, 1.0) if J.seq(J.gp(v_ph_1140, 0.0), "windup") else 0.0)
	v_sc_1143 = J.mul(1.25, J.mc(this_, "depth", [J.gp(v_f_1128, "gy")]))
	J.mc(v_ctx_1127, "save", [])
	var _t1884 = J.seq(J.gp(v_f_1128, "ghost"), "tianhua")
	var _t1885 = (J.gp(J.G.get("SPR"), "tianhua_hang") if _t1884 else _t1884)
	if J.t((J.gp(J.gp(J.G.get("SPR"), "tianhua_hang"), "complete") if J.t(_t1885) else _t1885)):
		v_img_1144 = J.gp(J.G.get("SPR"), "tianhua_hang")
		v_hh_1145 = (J.mul(J.mc(this_, "hh", [J.gp(v_f_1128, "gy")]), 1.9) if J.t(J.mc(this_, "persp", [])) else J.mul(v_H_1131, 0.32))
		v_w_1146 = J.div(J.mul(v_hh_1145, J.gp(v_img_1144, "naturalWidth")), J.gp(v_img_1144, "naturalHeight"))
		v_e_1147 = J.min_([1.0, J.div(v_k_1130, 0.375)])
		v_back_1148 = ((1.0 + (2.4 * pow(J.num(J.sub(v_e_1147, 1.0)), J.num(3.0)))) + (1.4 * pow(J.num(J.sub(v_e_1147, 1.0)), J.num(2.0))))
		v_up_1149 = (J.div(J.sub(v_k_1130, 0.82), 0.18) if J.cmp(v_k_1130, 0.82, ">") else 0.0)
		v_drop_1150 = (J.sub(v_back_1148, J.mul(v_up_1149, 1.2)) * J.sub(v_gy_1134, J.mul(v_hh_1145, 0.95)))
		var _t1886 = J.mul(v_a_1135, 0.92)
		J.sp(v_ctx_1127, "globalAlpha", _t1886)
		J.mc(v_ctx_1127, "translate", [v_gx_1133, (J.max_([(-J.num(v_hh_1145)), J.sub(v_drop_1150, J.mul(v_hh_1145, 0.2))]) + (sin(J.num(J.mul(v_t_1129, 3.0))) * 3.0))])
		J.mc(v_ctx_1127, "rotate", [(sin(J.num(J.mul(v_t_1129, (2.4 + J.mul(v_hit_1141, 6.0))))) * (0.05 + J.mul(v_hit_1141, 0.1)))])
		J.mc(v_ctx_1127, "scale", [(1.0 + J.mul(v_hit_1141, 0.08)), (1.0 + J.mul(v_hit_1141, 0.08))])
		J.mc(v_ctx_1127, "drawImage", [v_img_1144, J.div((-J.num(v_w_1146)), 2.0), 0.0, v_w_1146, v_hh_1145])
	else:
		if J.seq(J.gp(v_f_1128, "ghost"), "pontianak"):
			v_wy_1151 = (J.gp(J.mc(this_, "pt", [0.0, J.add(J.gp(J.gp(J.G.get("OFFICE"), "WIN"), 1.0), J.mul(J.gp(J.gp(J.G.get("OFFICE"), "WIN"), 3.0), 0.62))]), 1.0) if J.t(J.mc(this_, "office", [])) else J.mul(v_H_1131, 0.25))
			v_x_1152 = ((-60.0) + J.mul(J.add(v_W_1132, 120.0), v_k_1130))
			v_y_1153 = J.add(v_wy_1151, (sin(J.num(J.mul(v_k_1130, 9.0))) * 12.0))
			var _t1887 = J.G.get("__scDC")
			J.cl(_t1887, null, [v_ctx_1127, "pontianak", v_x_1152, v_y_1153, 1.3, {"t": v_t_1129, "pose": "cast", "pt": J.min_([1.0, J.mul(v_k_1130, 2.0)]), "alpha": J.mul(v_a_1135, 0.8), "flip": false, "shadow": false, "rot": (sin(J.num(J.mul(v_t_1129, 4.0))) * 0.08)}])
			J.sp(v_ctx_1127, "font", "900 18px serif")
			var _t1888 = ("rgba(255,200,230," + J.str(v_a_1135) + ")")
			J.sp(v_ctx_1127, "fillStyle", _t1888)
			J.sp(v_ctx_1127, "textAlign", "center")
			J.mc(v_ctx_1127, "fillText", ["嘻——嘻——", J.add(v_x_1152, (sin(J.num(J.mul(v_t_1129, 20.0))) * 2.0)), J.sub(v_y_1153, 70.0)])
		else:
			if J.seq(J.gp(v_f_1128, "ghost"), "eguiking"):
				v_q_1154 = J.mod(J.div(J.mul(v_k_1130, J.gp(v_f_1128, "max")), 0.34), 1.0)
				v_pose_1155 = ("windup" if J.cmp(v_q_1154, 0.55, "<") else "strike")
				v_pq_1156 = (J.div(v_q_1154, 0.55) if J.cmp(v_q_1154, 0.55, "<") else J.div(J.sub(v_q_1154, 0.55), 0.45))
				v_bump_1157 = (sin(J.num(J.mul(v_pq_1156, PI))) if J.seq(v_pose_1155, "strike") else 0.0)
				var _t1889 = J.G.get("__scDC")
				J.cl(_t1889, null, [v_ctx_1127, "eguiking", (J.mul(v_W_1132, 0.86) - J.mul(v_bump_1157, 8.0)), J.mul(v_H_1131, 0.55), (1.1 * (1.0 + J.mul(v_bump_1157, 0.05))), {"t": v_t_1129, "pose": v_pose_1155, "pt": v_pq_1156, "atk": J.seq(v_pose_1155, "strike"), "alpha": J.mul(v_a_1135, 0.8), "flip": true, "shadow": false, "rot": ((-J.num(v_bump_1157)) * 0.1)}])
				J.sp(v_ctx_1127, "font", "900 20px sans-serif")
				var _t1890 = ("rgba(255,230,150," + J.str(v_a_1135) + ")")
				J.sp(v_ctx_1127, "fillStyle", _t1890)
				J.sp(v_ctx_1127, "textAlign", "center")
				J.mc(v_ctx_1127, "fillText", ["叮叮叮叮！", J.mul(v_W_1132, 0.8), (J.mul(v_H_1131, 0.4) - J.mul(v_k_1130, 20.0))])
				if J.cmp(v_bump_1157, 0.6, ">"):
					J.sp(v_ctx_1127, "font", "900 15px sans-serif")
					J.mc(v_ctx_1127, "fillText", ["叮！", (J.mul(v_W_1132, 0.72) + (sin(J.num(J.mul(v_k_1130, 40.0))) * 20.0)), (J.mul(v_H_1131, 0.47) - J.mul(v_bump_1157, 10.0))])
			else:
				if J.seq(J.gp(v_f_1128, "ghost"), "penanggal"):
					v_e_1158 = J.min_([1.0, J.div(v_k_1130, 0.6)])
					v_x_1159 = J.add(J.add(v_gx_1133, (J.mul((-J.num(v_side_1139)), v_W_1132) * 0.2)), ((J.mul(v_side_1139, v_W_1132) * 0.38) * (J.mul(v_e_1158, v_e_1158) * (3.0 - J.mul(2.0, v_e_1158)))))
					v_y_1160 = ((J.sub(v_gy_1134, J.mul(v_H_1131, 0.13)) - (sin(J.num(J.mul(v_e_1158, PI))) * 20.0)) + (sin(J.num(J.mul(v_t_1129, 6.0))) * 4.0))
					v_i_1161 = 1.0
					while true:
						if not J.cmp(v_i_1161, 5.0, "<="): break
						var _t1891 = ("rgba(200,40,60," + J.str((J.mul(v_a_1135, 0.35) * (1.0 - J.div(v_i_1161, 6.0)))) + ")")
						J.sp(v_ctx_1127, "fillStyle", _t1891)
						J.mc(v_ctx_1127, "beginPath", [])
						J.mc(v_ctx_1127, "arc", [J.sub(v_x_1159, (J.mul(v_side_1139, v_i_1161) * 9.0)), J.add(J.add(v_y_1160, 8.0), (sin(J.num(J.add(J.mul(v_t_1129, 8.0), v_i_1161))) * 3.0)), (4.0 - J.mul(v_i_1161, 0.5)), 0.0, (PI * 2.0)])
						J.mc(v_ctx_1127, "fill", [])
						v_i_1161 = J.num(v_i_1161) + 1.0
					var _t1892 = J.G.get("__scDC")
					J.cl(_t1892, null, [v_ctx_1127, "penanggal", v_x_1159, J.add(v_y_1160, J.mul(v_H_1131, 0.05)), v_sc_1143, {"t": v_t_1129, "pose": J.gp(v_ph_1140, 0.0), "pt": J.gp(v_ph_1140, 1.0), "alpha": J.mul(v_a_1135, 0.85), "flip": v_faceL_1138, "shadow": false, "rot": (J.mul(v_side_1139, v_hit_1141) * 0.15)}])
				else:
					if J.seq(J.gp(v_f_1128, "ghost"), "laojiang"):
						v_x_1162 = J.add(J.add(v_gx_1133, (J.mul((-J.num(v_side_1139)), v_W_1132) * 0.22)), ((J.mul(v_side_1139, v_W_1132) * 0.44) * J.min_([1.0, J.mul(v_k_1130, 1.15)])))
						v_hop_1163 = absf(J.num(sin(J.num((J.mul(v_k_1130, PI) * 5.0)))))
						v_y_1164 = J.sub(v_gy_1134, J.mul(v_hop_1163, 26.0))
						J.sp(v_ctx_1127, "fillStyle", "rgba(0,0,0,.25)")
						J.mc(v_ctx_1127, "beginPath", [])
						J.mc(v_ctx_1127, "ellipse", [v_x_1162, J.add(v_gy_1134, 2.0), (16.0 * (1.0 - J.mul(v_hop_1163, 0.4))), 4.0, 0.0, 0.0, (PI * 2.0)])
						J.mc(v_ctx_1127, "fill", [])
						var _t1893 = J.G.get("__scDC")
						J.cl(_t1893, null, [v_ctx_1127, "laojiang", v_x_1162, v_y_1164, v_sc_1143, {"t": v_t_1129, "walk": true, "pose": "move", "alpha": J.mul(v_a_1135, 0.88), "flip": v_faceL_1138, "shadow": false}])
					else:
						v_rise_1165 = ((1.0 - J.min_([1.0, J.mul(v_k_1130, 4.0)])) * 30.0)
						v_lunge_1166 = J.mul(v_side_1139, (J.mul(v_hit_1141, 16.0) - J.mul(v_wind_1142, 8.0)))
						v_pose_1167 = J.gp(v_ph_1140, 0.0)
						v_pt_1168 = J.gp(v_ph_1140, 1.0)
						var _t1894 = J.seq(J.gp(v_f_1128, "ghost"), "afu")
						if (J.cmp(v_k_1130, 0.375, "<") if _t1894 else _t1894):
							v_pose_1167 = "knead"
							var _t1895 = J.mod((J.mul(v_k_1130, J.gp(v_f_1128, "max")) * 1.6), 1.0)
							v_pt_1168 = _t1895
						var _t1896 = J.G.get("__scDC")
						J.cl(_t1896, null, [v_ctx_1127, J.gp(v_f_1128, "ghost"), J.add(v_gx_1133, v_lunge_1166), J.add(v_gy_1134, v_rise_1165), J.mul(v_sc_1143, (1.0 + J.mul(v_hit_1141, 0.12))), {"t": v_t_1129, "pose": v_pose_1167, "pt": v_pt_1168, "atk": J.cmp(v_hit_1141, 0.3, ">"), "alpha": J.mul(v_a_1135, 0.85), "flip": v_faceL_1138, "shadow": false, "rot": J.mul(v_side_1139, (J.mul(v_hit_1141, 0.12) - J.mul(v_wind_1142, 0.1)))}])
						var _t1897 = J.seq(J.gp(v_f_1128, "ghost"), "afu")
						var _t1898 = (J.cmp(v_k_1130, 0.08, ">") if _t1897 else _t1897)
						if (J.cmp(v_k_1130, 0.4, "<") if _t1898 else _t1898):
							J.sp(v_ctx_1127, "font", "800 12px sans-serif")
							J.sp(v_ctx_1127, "textAlign", "center")
							var _t1899 = ("rgba(190,255,215," + J.str(J.mul(v_a_1135, 0.9)) + ")")
							J.sp(v_ctx_1127, "fillStyle", _t1899)
							J.mc(v_ctx_1127, "fillText", [J.gp(["噠", "噠噠", "噠噠噠"], J.mod(floor(J.num(J.mul(v_k_1130, 30.0))), 3.0)), J.add(v_gx_1133, J.mul(v_side_1139, 18.0)), J.sub(v_gy_1134, J.mul(v_H_1131, 0.13))])
	J.mc(v_ctx_1127, "restore", [])
	var _t1900 = J.gp(v_f_1128, "sig")
	if J.t(((not J.seq(J.typeof_(J.G.get("ScareX")), "undefined")) if J.t(_t1900) else _t1900)):
		J.mc(J.G.get("ScareX"), "sigFx", [this_, v_ctx_1127, v_f_1128, v_t_1129, v_k_1130])
	var _t1901 = ((not J.t(J.gp(v_n_1136, "gone"))) if J.t(v_n_1136) else v_n_1136)
	var _t1902 = (J.cmp(v_k_1130, 0.37, ">") if J.t(_t1901) else _t1901)
	if J.t((J.cmp(v_k_1130, 0.6, "<") if J.t(_t1902) else _t1902)):
		v_q_1169 = J.div(J.sub(v_k_1130, 0.37), 0.23)
		var _t1903 = J.mc(this_, "pt", [v_tx_1137, (J.gp(v_n_1136, "vY") if (not J.leq(J.gp(v_n_1136, "vY"), null)) else J.gp(v_n_1136, "y"))])
		var _t1904 = J.gp(_t1903, 0.0)
		v_px_1170 = _t1904
		var _t1905 = J.gp(_t1903, 1.0)
		v_py_1171 = _t1905
		v_hh_1172 = J.mc(this_, "hh", [J.gp(v_n_1136, "y")])
		var _t1906 = ("rgba(210,150,255," + J.str((J.sub(1.0, v_q_1169) * 0.8)) + ")")
		J.sp(v_ctx_1127, "strokeStyle", _t1906)
		var _t1907 = ((3.0 * J.sub(1.0, v_q_1169)) + 1.0)
		J.sp(v_ctx_1127, "lineWidth", _t1907)
		J.mc(v_ctx_1127, "beginPath", [])
		J.mc(v_ctx_1127, "arc", [v_px_1170, J.sub(v_py_1171, J.mul(v_hh_1172, 0.75)), J.mul(v_hh_1172, (0.15 + J.mul(v_q_1169, 0.5))), 0.0, (PI * 2.0)])
		J.mc(v_ctx_1127, "stroke", [])

func _f244(this_, a: Array, env):
	var v_l_1195 = null
	v_l_1195 = J.arg(a, 0)
	return J.gp(J.mc(env["ctx"], "measureText", [v_l_1195]), "width")

func _f245(this_, a: Array, env):
	var v_r_1198 = null
	v_r_1198 = J.arg(a, 0)
	var _t1924 = J.cmp(env["bx"], J.add(J.add(J.gp(v_r_1198, 0.0), J.gp(v_r_1198, 2.0)), 3.0), "<")
	var _t1925 = (J.cmp(J.add(J.add(env["bx"], env["w"]), 3.0), J.gp(v_r_1198, 0.0), ">") if _t1924 else _t1924)
	var _t1926 = (J.cmp(env["by"], J.add(J.add(J.gp(v_r_1198, 1.0), J.gp(v_r_1198, 3.0)), 3.0), "<") if _t1925 else _t1925)
	return (J.cmp(J.add(J.add(env["by"], env["h"]), 3.0), J.gp(v_r_1198, 1.0), ">") if _t1926 else _t1926)

func _f246(this_, a: Array, env):
	var v_l_1199 = null; var v_i_1200 = null
	v_l_1199 = J.arg(a, 0)
	v_i_1200 = J.arg(a, 1)
	return J.mc(env["ctx"], "fillText", [v_l_1199, J.add(env["bx"], 8.0), J.add(J.add(env["by"], 18.0), J.mul(v_i_1200, 17.0))])

func _f243(this_, a: Array, env):
	var v_text_1176 = null; var v_x_1177 = null; var v_y_1178 = null; var v_ghost_1179 = null; var v_age_1180 = null; var v_pk_1181 = null; var v_ps_1182 = null; var v_maxW_1183 = null; var v_words_1184 = null; var v_lines_1185 = null; var v_cur_1186 = null; var v_by0_1191 = null; var v_R_1192 = null; var v_ch_1193 = null; var v_pv_1194 = null; var v_k_1196 = null; var v_o_1197 = null
	var _s594 = {"__p": env, "ctx": null, "w": null, "h": null, "bx": null, "by": null}
	_s594["ctx"] = J.arg(a, 0)
	v_text_1176 = J.arg(a, 1)
	v_x_1177 = J.arg(a, 2)
	v_y_1178 = J.arg(a, 3)
	v_ghost_1179 = J.arg(a, 4)
	v_age_1180 = J.arg(a, 5)
	var _t1908 = J.gp(this_, "_nat")
	if J.t(((not J.seq(J.typeof_(J.G.get("__nat_scBub")), "undefined")) if J.t(_t1908) else _t1908)):
		var _t1909 = J.G.get("__nat_scBub")
		return J.cl(_t1909, null, [_s594["ctx"], this_, v_text_1176, v_x_1177, v_y_1178, v_ghost_1179, v_age_1180])
	v_pk_1181 = (1.0 if J.leq(v_age_1180, null) else J.min_([1.0, J.div(v_age_1180, 0.22)]))
	v_ps_1182 = (1.0 if J.cmp(v_pk_1181, 1.0, ">=") else ((1.0 + (2.70158 * pow(J.num(J.sub(v_pk_1181, 1.0)), J.num(3.0)))) + (1.70158 * pow(J.num(J.sub(v_pk_1181, 1.0)), J.num(2.0)))))
	J.mc(_s594["ctx"], "save", [])
	J.mc(_s594["ctx"], "translate", [v_x_1177, v_y_1178])
	J.mc(_s594["ctx"], "scale", [J.max_([0.05, v_ps_1182]), J.max_([0.05, v_ps_1182])])
	J.mc(_s594["ctx"], "translate", [(-J.num(v_x_1177)), (-J.num(v_y_1178))])
	if J.cmp(v_pk_1181, 1.0, "<"):
		var _t1910 = _s594["ctx"]
		var _t1911 = J.mul(J.gp(_t1910, "globalAlpha"), J.min_([1.0, J.mul(v_pk_1181, 3.0)]))
		J.sp(_t1910, "globalAlpha", _t1911)
	var _t1912 = _s594["ctx"]
	J.sp(_t1912, "font", "600 13px sans-serif")
	v_maxW_1183 = 200.0
	v_words_1184 = J.spread([J.SP(v_text_1176)])
	v_lines_1185 = []
	v_cur_1186 = ""
	for _t1913 in J.iter(v_words_1184):
		v_ch_1193 = _t1913
		if J.cmp(J.gp(J.mc(_s594["ctx"], "measureText", [J.add(v_cur_1186, v_ch_1193)]), "width"), v_maxW_1183, ">"):
			J.mc(v_lines_1185, "push", [v_cur_1186])
			v_cur_1186 = v_ch_1193
		else:
			var _t1914 = J.add(v_cur_1186, v_ch_1193)
			v_cur_1186 = _t1914
	J.mc(v_lines_1185, "push", [v_cur_1186])
	var _t1915 = (J.len(v_lines_1185) > 1.0)
	if ((J.len(J.spread([J.SP(J.gp(v_lines_1185, (J.len(v_lines_1185) - 1.0)))])) <= 2.0) if _t1915 else _t1915):
		v_pv_1194 = J.spread([J.SP(J.gp(v_lines_1185, (J.len(v_lines_1185) - 2.0)))])
		var _t1916 = (J.len(v_lines_1185) - 1.0)
		var _t1917 = J.mc(v_pv_1194, "splice", [(-2.0)])
		var _t1918 = J.add(J.mc(_t1917, "join", [""]), J.gp(v_lines_1185, (J.len(v_lines_1185) - 1.0)))
		J.sp(v_lines_1185, _t1916, _t1918)
		var _t1919 = (J.len(v_lines_1185) - 2.0)
		var _t1920 = J.mc(v_pv_1194, "join", [""])
		J.sp(v_lines_1185, _t1919, _t1920)
	_s594["w"] = (J.min_([v_maxW_1183, J.max_(J.spread([J.SP(J.mc(v_lines_1185, "map", [Callable(self, "_f244").bind(_s594)]))]))]) + 16.0)
	_s594["h"] = ((J.len(v_lines_1185) * 17.0) + 10.0)
	_s594["bx"] = J.max_([6.0, J.min_([(J.sub(J.gp(this_, "W"), _s594["w"]) - 6.0), J.sub(v_x_1177, J.div(_s594["w"], 2.0))])])
	_s594["by"] = (J.sub(v_y_1178, _s594["h"]) - 10.0)
	v_by0_1191 = _s594["by"]
	var _t1923 = J.gp(this_, "_bubR")
	if not J.t(_t1923):
		var _t1921 = this_
		var _t1922 = []
		J.sp(_t1921, "_bubR", _t1922)
		_t1923 = _t1922
	v_R_1192 = _t1923
	v_k_1196 = 0.0
	while true:
		if not J.cmp(v_k_1196, 6.0, "<"): break
		v_o_1197 = J.mc(v_R_1192, "find", [Callable(self, "_f245").bind(_s594)])
		if (not J.t(v_o_1197)):
			break
		var _t1927 = (J.sub(J.gp(v_o_1197, 1.0), _s594["h"]) - 5.0)
		_s594["by"] = _t1927
		v_k_1196 = J.num(v_k_1196) + 1.0
	if J.cmp(_s594["by"], 4.0, "<"):
		_s594["by"] = 4.0
	J.mc(v_R_1192, "push", [[_s594["bx"], _s594["by"], _s594["w"], _s594["h"]]])
	if J.cmp(_s594["by"], J.sub(v_by0_1191, 2.0), "<"):
		var _t1928 = _s594["ctx"]
		var _t1929 = ("rgba(180,138,216,.8)" if J.t(v_ghost_1179) else "rgba(255,253,245,.8)")
		J.sp(_t1928, "strokeStyle", _t1929)
		var _t1930 = _s594["ctx"]
		J.sp(_t1930, "lineWidth", 1.5)
		J.mc(_s594["ctx"], "beginPath", [])
		J.mc(_s594["ctx"], "moveTo", [v_x_1177, J.add(_s594["by"], _s594["h"])])
		J.mc(_s594["ctx"], "lineTo", [v_x_1177, J.sub(v_y_1178, 2.0)])
		J.mc(_s594["ctx"], "stroke", [])
	var _t1931 = _s594["ctx"]
	var _t1932 = ("rgba(60,30,80,.92)" if J.t(v_ghost_1179) else "rgba(255,253,245,.95)")
	J.sp(_t1931, "fillStyle", _t1932)
	var _t1933 = _s594["ctx"]
	var _t1934 = ("#b48ad8" if J.t(v_ghost_1179) else "#3a2a1a")
	J.sp(_t1933, "strokeStyle", _t1934)
	var _t1935 = _s594["ctx"]
	J.sp(_t1935, "lineWidth", 1.5)
	J.mc(_s594["ctx"], "beginPath", [])
	J.mc(_s594["ctx"], "roundRect", [_s594["bx"], _s594["by"], _s594["w"], _s594["h"], 9.0])
	J.mc(_s594["ctx"], "fill", [])
	J.mc(_s594["ctx"], "stroke", [])
	J.mc(_s594["ctx"], "beginPath", [])
	J.mc(_s594["ctx"], "moveTo", [J.sub(v_x_1177, 6.0), J.add(_s594["by"], _s594["h"])])
	J.mc(_s594["ctx"], "lineTo", [v_x_1177, J.add(J.add(_s594["by"], _s594["h"]), 8.0)])
	J.mc(_s594["ctx"], "lineTo", [J.add(v_x_1177, 6.0), J.add(_s594["by"], _s594["h"])])
	J.mc(_s594["ctx"], "fill", [])
	var _t1936 = _s594["ctx"]
	var _t1937 = ("#f0e0ff" if J.t(v_ghost_1179) else "#2a1a10")
	J.sp(_t1936, "fillStyle", _t1937)
	var _t1938 = _s594["ctx"]
	J.sp(_t1938, "textAlign", "left")
	J.mc(v_lines_1185, "forEach", [Callable(self, "_f246").bind(_s594)])
	J.mc(_s594["ctx"], "restore", [])

func _f248(this_, a: Array, env):
	var v_s_1213 = null; var v_k_1214 = null
	v_s_1213 = J.arg(a, 0)
	v_k_1214 = J.arg(a, 1)
	return J.add(v_s_1213, J.gp(v_k_1214, "v"))

func _f249(this_, a: Array, env):
	var v_k_1215 = null
	v_k_1215 = J.arg(a, 0)
	return ("<li class=\"" + ("up" if J.cmp(J.gp(v_k_1215, "v"), 0.0, ">") else "dn") + "\">陰德 " + ("+" if J.cmp(J.gp(v_k_1215, "v"), 0.0, ">") else "") + J.str(J.gp(v_k_1215, "v")) + "　" + J.str(J.gp(v_k_1215, "why")) + "</li>")

func _f250(this_, a: Array, env):
	var _t1969 = J.G.get("$")
	var _t1970 = J.gp(J.cl(_t1969, null, ["#scare"]), "classList")
	J.mc(_t1970, "remove", ["on"])
	var _t1971 = J.G.get("$")
	var _t1972 = J.cl(_t1971, null, ["#scare"])
	J.sp(_t1972, "innerHTML", "")
	J.mc(J.G.get("Sound"), "setMode", ["village"])
	J.mc(J.G.get("UI"), "refresh", [])

func _f247(this_, a: Array, env):
	var v_quit_1203 = null; var v_best_1204 = null; var v_stars_1205 = null; var v_first_1206 = null; var v_kar_1207 = null; var v_rw_1208 = null; var v_got_1209 = null; var v_rate_1210 = null; var v_kl_1211 = null; var v_kword_1212 = null
	v_quit_1203 = J.arg(a, 0)
	if (not J.t(J.gp(this_, "active"))):
		return null
	var _t1939 = this_
	J.sp(_t1939, "active", false)
	var _t1940 = J.gp(this_, "_nat")
	if J.t(((not J.seq(J.typeof_(J.G.get("__nat_scEnd")), "undefined")) if J.t(_t1940) else _t1940)):
		var _t1941 = J.G.get("__nat_scEnd")
		J.cl(_t1941, null, [this_])
	var _t1942 = J.G.get("S")
	var _t1943 = J.gp(J.G.get("S"), "scare")
	var _t1944 = (_t1943 if J.t(_t1943) else {"best": {}, "runs": 0.0, "fv": 3.0})
	J.sp(_t1942, "scare", _t1944)
	J.mc(this_, "migrate", [])
	var _t1945 = J.gp(J.G.get("S"), "scare")
	J.sp(_t1945, "runs", J.num(J.gp(_t1945, "runs")) + 1.0)
	var _t1946 = J.gp(J.gp(J.gp(J.G.get("S"), "scare"), "best"), J.gp(this_, "siteId"))
	v_best_1204 = (_t1946 if J.t(_t1946) else 0.0)
	v_stars_1205 = J.mc(this_, "starsOf", [J.gp(this_, "siteId"), J.gp(this_, "kpi")])
	v_first_1206 = J.cmp(v_stars_1205, J.mc(this_, "starsOf", [J.gp(this_, "siteId"), v_best_1204]), ">")
	if J.cmp(J.gp(this_, "kpi"), v_best_1204, ">"):
		var _t1947 = J.gp(J.gp(J.G.get("S"), "scare"), "best")
		var _t1948 = J.gp(this_, "siteId")
		var _t1949 = J.gp(this_, "kpi")
		J.sp(_t1947, _t1948, _t1949)
	var _t1950 = J.gp(this_, "karma")
	v_kar_1207 = J.mc(_t1950, "reduce", [Callable(self, "_f248").bind(env), 0.0])
	v_rw_1208 = {"exp": J.round(J.num(J.mul(J.div(J.gp(this_, "kpi"), 5.0), J.G.get("SCARE_PAY")))), "coins": J.round(J.num(J.mul(J.div(J.gp(this_, "kpi"), 2.0), J.G.get("SCARE_PAY"))))}
	if J.t(v_first_1206):
		var _t1951 = J.gp(["g", "b", "p"], J.sub(v_stars_1205, 1.0))
		J.sp(v_rw_1208, "chest", _t1951)
	var _t1952 = this_
	var _t1953 = (J.mc(J.G.get("ScareX"), "finish", [this_, v_stars_1205, v_quit_1203]) if (not J.seq(J.typeof_(J.G.get("ScareX")), "undefined")) else "")
	J.sp(_t1952, "_legendHTML", _t1953)
	var _t1954 = J.G.get("give")
	v_got_1209 = J.cl(_t1954, null, [v_rw_1208])
	J.cl(J.G.get("save"), null, [])
	v_rate_1210 = J.gp(["親，今晚的 KPI 沒達標哦～明晚加油！", "親，一星好評！離退休還有九百九十九顆星～", "親，二星好評！黃總說你很有潛力（並沒有加薪）。", "親，三星好評！全陰司本月最佳嚇人員工！"], v_stars_1205)
	var _t1957 = null
	if J.t(J.len(J.gp(this_, "karma"))):
		var _t1955 = J.gp(this_, "karma")
		var _t1956 = J.mc(_t1955, "map", [Callable(self, "_f249").bind(env)])
		_t1957 = J.mc(_t1956, "join", [""])
	else:
		_t1957 = "<li>今晚沒有人因為你改變人生。</li>"
	v_kl_1211 = _t1957
	v_kword_1212 = ("你今晚救了人。系統不會算這個，但是有人會記得。" if J.cmp(v_kar_1207, 4.0, ">=") else ("嚇對人了。" if J.cmp(v_kar_1207, 0.0, ">") else ("有些人，其實不用嚇。" if J.cmp(v_kar_1207, 0.0, "<") else "")))
	var _t1958 = J.G.get("$")
	var _t1959 = J.cl(_t1958, null, ["#scare"])
	var _t1961 = ("阿福被道士請走了" if J.t(J.gp(this_, "expelled")) else ("提早收工" if J.t(v_quit_1203) else "天亮了，收工"))
	var _t1962 = (("<p class=\"desc\">做法完成，今晚 KPI 只計一半。下次低調啲：唔好俾人望到。</p>") if J.t(J.gp(this_, "expelled")) else "")
	var _t1963 = J.mc("★", "repeat", [v_stars_1205])
	var _t1964 = J.mc("☆", "repeat", [J.sub(3.0, v_stars_1205)])
	var _t1965 = J.gp(this_, "kpi")
	var _t1960 = J.gp(this_, "_legendHTML")
	var _t1966 = ("<div class=\"sc-end\"><h3>" + _t1961 + "</h3>" + _t1962 + "<div class=\"sc-stars\">" + J.str(_t1963) + J.str(_t1964) + "</div>\n      <p class=\"sc-big\">驚嚇值 " + J.str(_t1965) + "</p><p class=\"desc\">【陰司 KPI 系統】" + J.str(v_rate_1210) + "</p><p class=\"desc\">獎勵：" + J.str(v_got_1209) + "</p>\n      " + J.str((_t1960 if J.t(_t1960) else "")) + "<h4>陰德（系統沒有算這一欄）</h4><ul class=\"sc-karma\">" + J.str(v_kl_1211) + "</ul><p class=\"desc\">" + J.str(v_kword_1212) + "</p><button class=\"btn gold wide\" id=\"sc-back\">回村子</button></div>")
	J.sp(_t1959, "innerHTML", _t1966)
	var _t1967 = J.G.get("$")
	var _t1968 = J.cl(_t1967, null, ["#sc-back"])
	var _t1973 = Callable(self, "_f250").bind(env)
	J.sp(_t1968, "onclick", _t1973)

func _f253(this_, a: Array, env):
	var v_ctx_1221 = null; var v_a_1222 = null; var v_o_1223 = null; var v_ps_1224 = null; var v_A_1225 = null; var v_k_1226 = null; var v_img_1227 = null; var v_kk_1228 = null; var v_pz_1229 = null; var v_n_1230 = null
	v_ctx_1221 = J.arg(a, 0)
	v_a_1222 = J.arg(a, 1)
	v_o_1223 = J.gp(v_a_1222, "o")
	v_ps_1224 = J.gp(v_o_1223, "pose")
	v_A_1225 = J.gp(J.G.get("MeshAnim"), "ANIM")
	var _t1982 = ["scared", "startle", "tremble", "cower", "hurt"]
	var _t1986 = null
	if J.t(J.mc(_t1982, "includes", [v_ps_1224])):
		_t1986 = "jump"
	else:
		var _t1983 = J.gp(v_o_1223, "walk")
		var _t1984 = (_t1983 if J.t(_t1983) else J.seq(v_ps_1224, "move"))
		var _t1985 = (_t1984 if J.t(_t1984) else J.seq(v_ps_1224, "walk"))
		_t1986 = ("walk" if J.t((_t1985 if J.t(_t1985) else J.seq(v_ps_1224, "run"))) else ("ritual" if J.seq(v_ps_1224, "ritual") else "stand"))
	v_k_1226 = _t1986
	var _t1987 = J.gp(env["P"], v_k_1226)
	var _t1988 = J.gp(_t1987, 0.0)
	v_img_1227 = _t1988
	var _t1989 = J.gp(_t1987, 1.0)
	v_kk_1228 = _t1989
	var _t1991 = (not J.seq(J.typeof_(J.G.get("sprOk")), "function"))
	if not J.t(_t1991):
		var _t1990 = J.G.get("sprOk")
		_t1991 = (not J.t(J.cl(_t1990, null, [v_img_1227])))
	if _t1991:
		return false
	v_pz_1229 = null
	if J.seq(v_k_1226, "walk"):
		var _t1992 = J.mc(v_A_1225, "walk", [J.gp(v_o_1223, "t")])
		v_pz_1229 = _t1992
		for _t1993 in J.keys(v_pz_1229):
			v_n_1230 = _t1993
			var _t1995 = J.seq(J.typeof_(J.gp(v_pz_1229, v_n_1230)), "number")
			if J.t(_t1995):
				var _t1994 = ["y", "sx", "sy"]
				_t1995 = (not J.t(J.mc(_t1994, "includes", [v_n_1230])))
			if _t1995:
				var _t1996 = (-J.num(J.gp(v_pz_1229, v_n_1230)))
				J.sp(v_pz_1229, v_n_1230, _t1996)
		J.sp(v_pz_1229, "x", 0.0)
		J.sp(v_pz_1229, "rot", 0.0)
	else:
		var _t1997 = J.mc(v_A_1225, "idle", [J.gp(v_o_1223, "t")])
		v_pz_1229 = _t1997
	if J.seq(v_k_1226, "ritual"):
		var _t1998 = J.gp(v_pz_1229, "armF")
		var _t1999 = J.add((_t1998 if J.t(_t1998) else 0.0), (sin(J.num(J.mul(J.gp(v_o_1223, "t"), 10.0))) * 0.07))
		J.sp(v_pz_1229, "armF", _t1999)
	J.mc(v_a_1222, "shadow", [J.gp(v_a_1222, "x")])
	J.mc(J.G.get("MeshAnim"), "draw", [v_ctx_1221, v_img_1227, J.gp(v_a_1222, "x"), J.gp(v_a_1222, "y"), J.mul(J.gp(v_a_1222, "H"), v_kk_1228), v_pz_1229, J.gp(v_a_1222, "faceRight")])
	return true

func _f252(this_, a: Array, env):
	var v_k_1220 = null
	var _s610 = {"__p": env, "P": null}
	var _t1974 = J.seq(J.typeof_(J.G.get("MeshAnim")), "undefined")
	if (_t1974 if _t1974 else J.seq(J.typeof_(J.G.get("ART")), "undefined")):
		return null
	_s610["P"] = {"stand": ["npc_daoshi", 1.0, {"c": 0.5, "n": 0.4, "h": 0.55, "ht": 0.1, "hr": 0.3, "L": [0.3, 0.48, 0.12, 0.47], "R": [0.7, 0.48, 0.75, 0.54], "legs": [0.82, 0.38, 0.65]}], "walk": ["npc_daoshi_walk", 0.98, {"c": 0.45, "n": 0.42, "h": 0.4, "ht": 0.08, "hr": 0.26, "L": [0.28, 0.45, 0.15, 0.25], "R": [0.62, 0.48, 0.4, 0.55], "legs": [0.8, 0.25, 0.55]}], "ritual": ["npc_daoshi_ritual", 1.0, {"c": 0.5, "n": 0.42, "h": 0.55, "ht": 0.06, "hr": 0.24, "L": [0.4, 0.4, 0.32, 0.18], "R": [0.7, 0.5, 0.62, 0.6], "tail": 0.5}], "jump": ["npc_daoshi_jump", 1.0, {"c": 0.5, "n": 0.42, "h": 0.55, "ht": 0.06, "hr": 0.24, "L": [0.38, 0.48, 0.2, 0.4], "R": [0.72, 0.48, 0.88, 0.42], "legs": [0.78, 0.3, 0.55]}]}
	for _t1975 in J.keys(_s610["P"]):
		v_k_1220 = _t1975
		var _t1976 = J.gp(J.G.get("MeshAnim"), "RIG")
		var _t1977 = J.gp(J.gp(_s610["P"], v_k_1220), 0.0)
		var _t1978 = J.mc(J.G.get("MeshAnim"), "mk", [J.gp(J.gp(_s610["P"], v_k_1220), 2.0)])
		J.sp(_t1976, _t1977, _t1978)
	var _t1979 = J.gp(J.G.get("ART"), "CHAR_H")
	J.sp(_t1979, "npc_daoshi", 64.0)
	if J.t(J.gp(J.G.get("ART"), "SOLID")):
		var _t1980 = J.gp(J.G.get("ART"), "SOLID")
		J.sp(_t1980, "npc_daoshi", 1.0)
	var _t1981 = J.gp(J.gp(J.G.get("MeshAnim"), "RIG"), "npc_daoshi")
	var _t2000 = Callable(self, "_f253").bind(_s610)
	J.sp(_t1981, "custom", _t2000)
