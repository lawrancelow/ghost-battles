# [offer] 回陽間・燒貨單（第三章起）
#  玩法照舊（限時嚇人、嚇走一個加分），只係多咗「今晚揀邊單」：每單一個燒貨人(target)＋要佢燒嘅貨。
#  收工：燒貨人有俾嚇走 → 按星數燒貨落嚟（入冥牌坊貨倉 S.mpf.stock），之後播「陽間人嚇到問米／請師傅 → 去紙紮舖買 → 燒」。
#  數據 data/nat/offer_jobs.json；存檔 S.offer = {done:{job:best星}, runs:n}、S.mpf = {stock:{g:n}, sold:{g:n}, seen:{g:true}}
# 熱更新：冇 class_name，用 load() 攞
extends RefCounted

const PATH := "res://data/nat/offer_jobs.json"
static var D: Dictionary = {}
static var cur: Dictionary = {}       # 今晚揀咗嘅單（{} ＝自由夜班）
static var _bak: Dictionary = {}      # 改咗嘅原值，收工還原
static var pending: Dictionary = {}   # 收工後要播嘅燒貨劇情

static func data() -> Dictionary:
	if D.is_empty():
		var t = FileAccess.get_file_as_string(PATH)
		var p = JSON.parse_string(t) if t != "" else null
		D = p if p is Dictionary else {"GOODS": {}, "JOBS": []}
	return D

static func S():
	var s = J.G.get("S")
	return s if s is Dictionary else null

static func T(a) -> String:
	if a is Array: return str(DB.N(a[0] if DB.lang == "yue" else a[1]))
	return str(DB.N(str(a)))

static func seen(k: String) -> bool:
	var s = S()
	return s != null and s.get("seen") is Dictionary and J.t(s.seen.get(k))

static func opened() -> bool:   # 攞到陰陽通商許可證（支線 c3x_permit 完成）先開
	var s = S()
	if s == null or not (s.get("sq") is Dictionary): return false
	var e = s.sq.get("c3x_permit")
	return e is Dictionary and J.t(e.get("done"))

static func jobs_open() -> Array:
	var r = []
	for j in data().JOBS: if seen(str(j.need)): r.append(j)
	return r

static func job(id: String) -> Dictionary:
	for j in data().JOBS: if j.id == id: return j
	return {}

static func best(id: String) -> int:
	var s = S()
	if s == null or not (s.get("offer") is Dictionary): return 0
	return int(J.num(s.offer.get("done", {}).get(id, 0)))

static func mpf() -> Dictionary:
	var s = S()
	if not (s.get("mpf") is Dictionary): s["mpf"] = {}
	for k in ["stock", "sold", "seen"]:
		if not (s.mpf.get(k) is Dictionary): s.mpf[k] = {}
	return s.mpf

static func npc_def(k: String) -> Variant:
	var site = J.G.get("SCARE_SITES").get("office")
	for d in site.npcs: if str(d.k) == k: return d
	return null

static func npc_name(k: String) -> String:
	var d: Variant = npc_def(k)
	return T([str(d.name), str(DB.D.get("LANG_ZH", {}).get(str(d.name), d.name))]) if d != null else k

# 計呢單每個星數燒乜：g[0] 按 tier；其餘貨三星先有一件
static func loot(j: Dictionary, st: int) -> Dictionary:
	var r = {}
	if st <= 0: return r
	var n = int(j.tier[clampi(st, 0, j.tier.size() - 1)])
	if n > 0: r[str(j.g[0])] = n
	if st >= 3:
		for i in range(1, j.g.size()): r[str(j.g[i])] = int(r.get(str(j.g[i]), 0)) + 1
	return r

# ---------------- 出發／收工 ----------------
static func begin(id: String) -> void:
	restore()
	cur = job(id) if id != "" else {}
	if cur.is_empty(): return
	var d: Variant = npc_def(str(cur.target))
	_bak = {"sec": J.G.get("NIGHT_SEC"), "calm": d.calm if d != null else null}
	J.G["NIGHT_SEC"] = float(cur.mod.get("sec", 180))
	if d != null: d["calm"] = J.num(d.calm) * float(cur.mod.get("calm", 1.0))
	var main = Engine.get_main_loop().root.get_node_or_null("Main")
	if main != null and main.has_method("show_toast"):
		main.show_toast(T(["今晚燒貨人：%s。嚇走佢，佢就會燒%s落嚟！" % [npc_name(str(cur.target)), data().GOODS.get(str(cur.g[0]), {"n": ["嘢", "東西"]}).n[0]], "今晚燒貨人：%s。嚇走他，他就會燒%s下來！" % [npc_name(str(cur.target)), data().GOODS.get(str(cur.g[0]), {"n": ["嘢", "東西"]}).n[1]]]))

static func restore() -> void:
	if _bak.is_empty(): return
	J.G["NIGHT_SEC"] = _bak.sec
	var d: Variant = npc_def(str(cur.get("target", "")))
	if d != null and _bak.calm != null: d["calm"] = _bak.calm
	_bak = {}

# 由 __nat_scEnd 叫（JS finish 一開始；kpi 已經計好）
static func on_end(sc) -> void:
	var QXs = load("res://game/quest/qx_impl.gd")
	if not J.t(J.gp(sc, "headless")):   # 計數：許可證考驗用（完成一晚、嚇走幾多人）
		QXs.bump("scareNight")
		var nf = 0
		for n in J.gp(sc, "npcs") if J.gp(sc, "npcs") is Array else []: if J.t(J.gp(n, "fleeing")): nf += 1
		if nf > 0: QXs.bump("scareFled", nf)
	if cur.is_empty(): return
	var j = cur
	restore(); cur = {}
	var tk = str(j.target); var fled = false
	for n in J.gp(sc, "npcs") if J.gp(sc, "npcs") is Array else []:
		if str(J.gp(J.gp(n, "d"), "k")) == tk and J.t(J.gp(n, "fleeing")): fled = true
	if fled:   # 燒貨人嚇走：額外加分（分數越高燒越多）
		var bonus = round(150.0 * float(j.mod.get("pts", 1.5)))
		J.sp(sc, "kpi", J.num(J.gp(sc, "kpi")) + bonus)
	var kpi = J.num(J.gp(sc, "kpi"))
	var st = int(J.num(J.mc(J.G.get("Scare"), "starsOf", ["office", kpi])))
	if J.t(J.gp(sc, "expelled")): st = mini(st, 1)
	var s = S()
	if not (s.get("offer") is Dictionary): s["offer"] = {"done": {}, "runs": 0}
	if not (s.offer.get("done") is Dictionary): s.offer["done"] = {}
	s.offer["runs"] = int(J.num(s.offer.get("runs", 0))) + 1
	if not fled:
		pending = {"job": j, "fail": true}
		return
	if st > best(str(j.id)): s.offer.done[str(j.id)] = st
	QXs.bump("offerDone")
	var got = loot(j, st)
	var M = mpf()
	for g in got:
		M.stock[g] = int(M.stock.get(g, 0)) + got[g]
	pending = {"job": j, "got": got, "st": st}
	var EQd = load("res://game/equip/eq_data.gd")   # [補丁43] 陽間人燒紙紮兵器落嚟（名鬼裝備高級來源）
	var eqid = EQd.drop_offer(st)
	if eqid != "":
		pending["eq"] = eqid
		var mn = Engine.get_main_loop().root.get_node_or_null("Main")
		if mn != null and mn.has_method("show_toast"): mn.show_toast(T(["陽間仲燒埋一件名鬼裝備落嚟：%s〔%s〕！" % [EQd.name_of(eqid), EQd.grade_name(EQd.grade_of(eqid))], "陽間還燒了一件名鬼裝備下來：%s〔%s〕！" % [EQd.name_of(eqid), EQd.grade_name(EQd.grade_of(eqid))]]))
	J.cl(J.G.get("save"), null, [])

# 收工結算框收起之後先播（結算框喺劇情下面，唔好疊埋）
static func tick() -> void:
	if pending.is_empty(): return
	var main = Engine.get_main_loop().root.get_node_or_null("Main")
	if main == null or main.get_node_or_null("NvScEnd") != null: return
	var Sc = J.G.get("Scare")
	if Sc != null and J.t(Sc.get("active")): return
	var p = pending; pending = {}
	var qx = Engine.get_main_loop().root.get_node_or_null("QX")
	if qx == null: return
	var SA = DB.D.get("SPEAKER_ART")
	if SA is Dictionary:
		for k in SPK: if not SA.has(k): SA[k] = SPK[k]
	if J.t(p.get("fail")):
		qx.call("_story", {"style": "talk", "bg": "office", "lines": [["小紙", [
			"少爺，%s冇俾你嚇走。冇人驚，就冇人燒嘢。" % npc_name(str(p.job.target)),
			"少爺，%s沒被你嚇走。沒人害怕，就沒人燒東西。" % npc_name(str(p.job.target))]]]})
		return
	for sc in scenes(p.job, p.got): qx.call("_story", sc)

# ---------------- 燒貨劇情 ----------------
const SPK := {"靚姨": "npc_mimpo", "林師傅": "npc_daoshi", "阿Ken": "npc_ken", "美美": "npc_mis", "小晴": "npc_it", "清潔安娣": "npc_auntie", "陳總": "npc_boss"}
const BED := {
	"ken": [["", ["（縮喺被竇入面打電話）媽……我公司有嘢……唔係老闆，係真嘢……", "（縮在被窩裡打電話）媽……我公司有東西……不是老闆，是真的東西……"]], ["阿Ken 媽", ["仔，聽日去搵靚姨問米。順便睇吓佢想要乜。", "兒子，明天去找靚姨問米。順便看看他想要什麼。"]]],
	"mis": [["", ["（開晒全屋燈，敷住面膜發抖）我自拍嗰陣……後面多咗一塊面……", "（開了全屋的燈，敷著面膜發抖）我自拍的時候……後面多了一張臉……"]], ["", ["陳總～我唔返工喇～除非你請師傅～", "陳總～我不上班了～除非你請師傅～"]]],
	"it": [["", ["（攬住手提電腦）唔係 bug……我 debug 咗三次……佢真係叫我個名……", "（抱著筆電）不是 bug……我 debug 了三次……它真的在叫我的名字……"]], ["", ["（打俾阿媽）媽，你識唔識問米嘅？唔係，唔係迷信，係……係 hotfix。", "（打給媽媽）媽，你認不認識問米的？不是，不是迷信，是……是 hotfix。"]]],
	"auntie": [["", ["（揸實地拖坐喺床邊）三十年都冇怕過……天花板有腳印……", "（握緊拖把坐在床邊）三十年都沒怕過……天花板上有腳印……"]], ["", ["（打俾個仔）阿仔，聽日陪媽去搵靚姨。媽唔係驚，媽係……想問吓。", "（打給兒子）兒子，明天陪媽去找靚姨。媽不是怕，媽是……想問一下。"]]],
	"boss": [["", ["（攬住水晶球縮喺沙發）水晶球裂咗……影印機自己印咗我嘅虧損報表……", "（抱著水晶球縮在沙發上）水晶球裂了……影印機自己印出了我的虧損報表……"]], ["", ["秘書！即刻幫我約師傅！唔理幾錢！……講多句，唔理幾錢，但係要有收據。", "秘書！馬上幫我約師傅！不管多少錢！……再說一句，不管多少錢，但要有收據。"]]],
}

static func scenes(j: Dictionary, got: Dictionary) -> Array:
	var tk = str(j.target); var spr = "npc_" + tk
	var nm = npc_name(tk)
	var G = data().GOODS
	var names_y = []; var names_z = []; var ov = []; var x = 0.36
	for g in got:
		var gd = G.get(g, {})
		names_y.append("%s ×%d" % [gd.n[0], got[g]]); names_z.append("%s ×%d" % [gd.n[1], got[g]])
		ov.append({"spr": gd.get("spr", ""), "x": x, "y": 0.62, "h": 0.3, "shadow": false}); x += 0.16
	var first = G.get(str(j.g[0]), {"n": ["紙紮", "紙紮"]}).n
	var out = []
	# ① 嚇到皮皮挫
	var bl = []
	for l in BED.get(tk, []): bl.append([nm if str(l[0]) == "" else str(l[0]), l[1]])
	out.append({"style": "talk", "bg": "office", "title": T(j.name), "lines": [["旁白", ["凌晨三點。%s返到屋企，全屋燈都唔敢熄。" % nm, "凌晨三點。%s回到家，全屋的燈都不敢關。" % nm]]] + bl,
		"cg": {"0": {"k": "cg_ow_bed", "over": [{"spr": spr, "x": 0.66, "y": 0.95, "h": 0.55}]}}})
	# ② 問米／請師傅
	if str(j.how) == "master":
		out.append({"style": "talk", "bg": "office", "lines": [
			["林師傅", ["（搖一搖個銅鈴，望住個羅盤）嗯……呢位朋友唔係想害人。佢想要嘢。", "（搖一搖銅鈴，看著羅盤）嗯……這位朋友不是想害人。他想要東西。"]],
			[nm, ["要乜？要幾多？我燒！我即刻燒！", "要什麼？要多少？我燒！我馬上燒！"]],
			["阿福", ["（喺師傅耳邊吹一口凍氣）%s。要正貨。" % first[0], "（在師傅耳邊吹一口冷氣）%s。要正貨。" % first[1]]],
			["林師傅", ["……佢話要%s。正貨。仲有，車馬費另計。" % first[0], "……他說要%s。正貨。還有，車馬費另計。" % first[1]]]],
			"cg": {"0": {"k": "cg_ow_master", "over": [{"spr": "npc_daoshi", "x": 0.3, "y": 0.95, "h": 0.55}, {"spr": spr, "x": 0.7, "y": 0.95, "h": 0.52, "flip": true}]}}})
	else:
		out.append({"style": "talk", "bg": "office", "lines": [
			["靚姨", ["（抓一把米撒落枱）嚟喇嚟喇……佢話佢喺下面開舖，啲貨舊晒，冇客。", "（抓一把米撒在桌上）來了來了……他說他在下面開店，貨都舊了，沒客人。"]],
			[nm, ["咁……佢想要乜？", "那……他想要什麼？"]],
			["阿福", ["%s！最新款！" % first[0], "%s！最新款！" % first[1]]],
			["靚姨", ["佢話要……%s？……我老人家唔識，你自己去紙紮舖問。問米費三百，唔收卡。" % first[0], "他說要……%s？……我老人家不懂，你自己去紙紮店問。問米費三百，不收卡。" % first[1]]]],
			"cg": {"0": {"k": "cg_ow_wenmi", "over": [{"spr": "npc_mimpo", "x": 0.28, "y": 0.95, "h": 0.5}, {"spr": spr, "x": 0.72, "y": 0.95, "h": 0.52, "flip": true}]}}})
	# ③ 紙紮舖
	out.append({"style": "talk", "bg": "office", "lines": [
		["紙紮舖老闆", ["%s？有！今季陰間最潮。你係第三個嚟買，個個都話係「下面叫我買」。" % first[0], "%s？有！這季陰間最潮。你是第三個來買的，個個都說是「下面叫我買」。" % first[1]]],
		[nm, ["全部包起。快啲。", "全部包起來。快一點。"]]],
		"cg": {"0": {"k": "cg_ow_shop", "over": [{"spr": spr, "x": 0.5, "y": 0.95, "h": 0.55}]}}})
	# ④ 燒
	var bover = [{"spr": spr, "x": 0.22, "y": 0.95, "h": 0.55}]; bover.append_array(ov)
	out.append({"style": "talk", "bg": "office", "lines": [
		[nm, ["（一路燒一路拜託）燒俾你喇……正貨嚟㗎……求下你唔好再嚟喇……", "（一邊燒一邊拜託）燒給你了……是正貨……求求你不要再來了……"]],
		["旁白", ["火光入面，一陣青煙飄落陰間。", "火光裡，一陣青煙飄向陰間。"]],
		["小紙", ["少爺！收到喇！%s！我即刻擺上冥牌坊！" % "、".join(names_y), "少爺！收到了！%s！我馬上擺上冥牌坊！" % "、".join(names_z)]]],
		"cg": {"0": {"k": "cg_ow_burn", "over": bover}}})
	return out

# ---------------- 冥牌坊貨倉（第一版：上架即賣） ----------------
static func price(g: String) -> int:
	var gd = data().GOODS.get(g, {})
	var s = S(); var lv = J.num(s.get("lv", 1)) if s != null else 1.0
	return int(round(J.num(gd.get("price", 100)) * (1.0 + 0.25 * maxf(0.0, lv - 1.0))))

static func sell(g: String, n := 1) -> int:
	var M = mpf(); var have = int(M.stock.get(g, 0)); n = mini(n, have)
	if n <= 0: return 0
	M.stock[g] = have - n; M.sold[g] = int(M.sold.get(g, 0)) + n
	var c = price(g) * n
	J.cl(J.G.get("give"), null, [{"coins": c}])
	J.cl(J.G.get("save"), null, [])
	return c
