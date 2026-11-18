# 原生改寫自 patrol.js：夜班巡陰（Patrol）＋裝備房（Gear）
# Godot：巡邏本身係原生 PtRun（__nat_patrol），選單係原生 PatrolMenu（__nat_patrolMenu）。呢度係規則函數、存檔、常數（_nat）、
# 選單資料（_menu）、劇情（intro／start）、備用 HTML 選單同 Gear 全部。
# JS 巡邏主迴圈（mount/update/draw…，約 900 行）喺 Godot 永遠唔會行（__nat_patrol 一定接手）；萬一 __nat_patrol 回 false，
# 先懶載轉譯版行佢個 begin（_R／_end／_gain／spots／openMap／_test 亦經轉譯版，未載就照 JS 喺 R 係 null 時嘅結果）。
# 資料：data/nat/patrol.json（由網頁原碼抽出）。
extends RefCounted

static var D: Dictionary = {}
static var FAC: Dictionary = {}
static var FAC_OF: Dictionary = {}
static var COLS := 9
static var CW := 800.0
static var CH := 700.0
static var MIR := false
static var FACI: Array = []
static var GATES: Array = []
static var HOOK: Dictionary = {}
static var active := false
static var _tr = null          # 轉譯版（只有後備巡邏先會載）
static var _trx: Dictionary = {}
static var P: Dictionary = {}  # J.G.Patrol
static var GE: Dictionary = {} # J.G.Gear
# Gear 狀態
static var g_back = null
static var g_tab := "wea"

const CN := "一二三四五六"

# ---------- 小工具 ----------
static func G(n: String): return J.G.get(n)
static func has(n: String) -> bool: return J.typeof_(J.G.get(n)) != "undefined"
static func g(o, k): return J.gp(o, k)
static func n(v) -> float: return J.num(v)
static func t_(v) -> bool: return J.t(v)
static func s_(v) -> String: return J.str(v)
static func S_(): return G("S")
static func T(yue: String, zh: String) -> String: return s_(J.mc(G("GP"), "T", [yue, zh])) if has("GP") else zh
static func q(sel: String): return J.cl(G("$"), null, [sel])
static func fmt(v) -> String: return s_(J.cl(G("fmt"), null, [v]))
static func save() -> void: J.cl(G("save"), null, [])
static func now() -> float: return n(J.S_Date_("now", []))
static func jround(x: float) -> float: return J.round(x)

static func fac_of(k) -> String:
	var ks = s_(k)
	if t_(FAC_OF.get(ks)): return FAC_OF[ks]
	var sk = J.gp(G("SKILLS"), k) if has("SKILLS") else null
	if not t_(sk): sk = {}
	if t_(g(sk, "drain")) or t_(g(sk, "steal")): return "chan"
	if J.seq(g(sk, "kind"), "heal") or J.seq(g(sk, "apply"), "down") or J.seq(g(sk, "apply"), "push") or t_(g(sk, "sap")): return "lan"
	return "yuan"
static func mc_(c: int) -> int: return COLS - 1 - c if MIR else c
static func ter_at(r: int, c: int) -> float: return n(D.TLAY[r][COLS - 1 - c if MIR else c])
static func zone_cell(z: float) -> Dictionary:
	var r = floor(z / COLS); var c = fmod(z, COLS)
	return {"r": r, "c": c, "x": c * CW + CW / 2, "y": r * CH + CH / 2}
static func ter_of(z) -> float:
	var c = zone_cell(n(z)); return ter_at(int(c.r), int(c.c))
static func gate_list() -> Array:
	var out = []
	for i in D.TGATE.size():
		var tg = D.TGATE[i]; var a = tg[0]; var b = tg[1]; var ca = tg[2]; var cb = tg[3]
		var ra = n(ca[0]); var rb = n(cb[0]); var xa = float(mc_(int(n(ca[1])))); var xb = float(mc_(int(n(cb[1])))); var za = ra * COLS + xa; var zb = rb * COLS + xb
		var sec = tg.size() > 4 and t_(tg[4])
		if ra == rb: out.append({"i": float(i), "a": a, "b": b, "za": za, "zb": zb, "sec": sec, "vert": true, "x": maxf(xa, xb) * CW, "y": ra * CH + CH / 2})
		else: out.append({"i": float(i), "a": a, "b": b, "za": za, "zb": zb, "sec": sec, "vert": false, "x": xa * CW + CW / 2, "y": maxf(ra, rb) * CH})
	return out
static func mk_faci() -> void:
	FACI = []
	for f in D.FACI0: FACI.append({"t": f[0], "z": n(f[1]) * COLS + mc_(int(n(f[2]))), "ox": -n(f[3]) if MIR else n(f[3]), "oy": f[4]})
	GATES = gate_list()

# ---------- 存檔 ----------
static func st():
	var S = S_()
	if not t_(g(S, "pt")): J.sp(S, "pt", {})
	var p = g(S, "pt")
	J.sp(p, "reg", g(p, "reg") if t_(g(p, "reg")) else {}); J.sp(p, "mats", g(p, "mats") if t_(g(p, "mats")) else {"yuan": 0.0, "chan": 0.0, "lan": 0.0})
	J.sp(p, "pity", g(p, "pity") if t_(g(p, "pity")) else {}); J.sp(p, "lead", g(p, "lead") if t_(g(p, "lead")) else null)
	if g(p, "min") == null: J.sp(p, "min", 18.0 * 60)
	J.sp(p, "kills", g(p, "kills") if t_(g(p, "kills")) else 0.0); J.sp(p, "rec", g(p, "rec") if t_(g(p, "rec")) else 0.0); J.sp(p, "poach", g(p, "poach") if t_(g(p, "poach")) else [])
	return p
static func reg_st(ci):
	var p = st(); var reg = g(p, "reg"); var r = J.gp(reg, ci)
	if not t_(r) or (not J.seq(g(r, "v"), 2.0) and not J.seq(g(r, "v"), 3.0)):
		r = {"v": 3.0, "fog": "", "sta": {}, "ot": -1.0, "pr": -1.0, "kings": {}}; J.sp(reg, ci, r)
	if J.seq(g(r, "v"), 2.0): J.sp(r, "v", 3.0); J.sp(r, "fog", ""); J.sp(r, "sta", {})
	for k in ["sta", "kings", "lm", "ca", "pg", "sg"]: J.sp(r, k, g(r, k) if t_(g(r, k)) else {})
	return r
static func start_z(ci) -> float:
	var m = MIR; MIR = int(n(ci)) % 2 == 1; var z = 6.0 * COLS + mc_(0); MIR = m; return z
static func sid_of(ci, si) -> String: return s_(n(ci) + 1) + "-" + s_(n(si) + 1)
static func region_open(ci) -> bool: return n(ci) == 0 or t_(J.gp(g(S_(), "cleared"), sid_of(n(ci) - 1, 2)))
static func elites_of(ci) -> Array:
	if not has("N30W"): return []
	var site = D.REG[int(n(ci))].site; var out = []
	for k in J.iter(J.mc(G("N30W"), "ids", [])):
		if J.seq(g(J.gp(G("N30_G"), k), "at"), site): out.append(k)
	return out
static func fod_of(ci) -> Array:
	var a = []
	for i in int(n(ci)) + 1: a += D.CH_FOD[i]
	return a
static func page_ghosts(ci) -> Array:
	var d = J.gp(D.TKING, ci); var out = []; var GH = G("GHOSTS")
	if not t_(d): d = {}
	for v in d.values():
		for k in [v.get("big"), v.get("small")]:
			if t_(k) and t_(J.gp(GH, k)) and t_(g(J.gp(GH, k), "lore")) and not out.has(k): out.append(k)
	return out.slice(0, 6)
static func phase(mn) -> String:
	var h = floor(n(mn) / 60)
	return "zi" if h < 4 else ("off" if h < 8 else ("work" if h < 18 else "ot"))
static func landmarks(ci) -> Array:
	var out = []
	for i in D.LMNAME[int(n(ci))].size(): out.append({"id": float(i), "name": D.LMNAME[int(n(ci))][i], "found": t_(J.gp(g(reg_st(ci), "lm"), float(i)))})
	return out
static func on_(e: String, f) -> void:
	if not HOOK.has(e): HOOK[e] = []
	HOOK[e].append(f)
static func emit(e, d) -> void:
	for f in HOOK.get(s_(e), []): J.cl(f, null, [d])

# ---------- 部門 ----------
static func crew_cap() -> float: return minf(12.0, 3 + n(g(g(S_(), "bld"), "home")))
static func troop_teams() -> float: return minf(4.0, floor(n(g(g(S_(), "res"), "troops")) / 25))
static func crew_list() -> Array:
	var a = []
	for gh in J.iter(g(S_(), "ghosts")):
		var qq = g(gh, "q")
		if (J.seq(qq, "藍") or J.seq(qq, "紫")) and not t_(g(gh, "post")) and not t_(g(gh, "poached")) and n(g(gh, "fat")) < 100: a.append(gh)
	var F = G("F")
	a = J.mc(a, "sort", [func(_t, x): return n(J.mc(F, "glv", [x[1]])) - n(J.mc(F, "glv", [x[0]]))])
	return a.slice(0, int(crew_cap()))
static func leads() -> Array:
	var p = st(); var ids = g(p, "lead")
	if not t_(ids):
		ids = []
		for id in J.iter(g(S_(), "team")): if t_(id) and not J.seq(id, "afu"): ids.append(id)
	var out = []
	for id in J.iter(ids):
		var gh = J.cl(G("ghostById"), null, [id])
		if t_(gh) and not J.seq(g(gh, "k"), "afu"): out.append(gh)
	return out.slice(0, 3)
static func rest_recover() -> void:
	var p = st(); var t0 = now()
	if t_(g(p, "restAt")):
		var m = (t0 - n(g(p, "restAt"))) / 60000
		if m > 0:
			for gh in J.iter(g(S_(), "ghosts")):
				if t_(g(gh, "fat")): J.sp(gh, "fat", maxf(0.0, n(g(gh, "fat")) - m * 2))
	J.sp(p, "restAt", t0)

# ---------- 劇情、選單 ----------
static func intro(then) -> void:
	var p = st()
	if t_(g(p, "introSeen")):
		if t_(then): J.cl(then, null, [])
		return
	J.sp(p, "introSeen", 1.0); save()
	J.mc(G("Story"), "queue", [{"style": "narr", "lines": [
		["龐總", T("各位同事，宣佈新政策：「夜班巡陰計劃」。由今晚開始，搶地盤取消，改為巡邏。", "各位同事，宣佈新政策：「夜班巡陰計劃」。從今晚開始，取消搶地盤，改為巡邏。")],
		["龐總", T("每個部門帶隊出去，見到遊魂，有兩個處理方法：送去投胎，或者遞合約收編。", "每個部門帶隊出去，見到遊魂，有兩個處理方法：送去投胎，或者遞合約收編。")],
		["冼小姐", T("提提大家：收編要有編制，編制睇民宅。合約工資係壽包，自己準備。", "提醒大家：收編要有編制，編制看民宅。合約工資是壽包，自己準備。")],
		["龐總", T("仲有，部門唔好做到過勞。過勞咗……都係你哋自己嘅事。", "還有，部門不要做到過勞。過勞了……也是你們自己的事。")],
		["阿福", T("……即係同以前一樣。", "……就是跟以前一樣。")],
	]}, then])
static func menu_obj() -> Dictionary:
	return {"st": func(_t, _a): return st(), "regSt": func(_t, a): return reg_st(J.arg(a, 0)), "crewList": func(_t, _a): return crew_list(), "leads": func(_t, _a): return leads(),
		"crewCap": func(_t, _a): return crew_cap(), "troopTeams": func(_t, _a): return troop_teams(), "regionOpen": func(_t, a): return region_open(J.arg(a, 0)),
		"sidOf": func(_t, a): return sid_of(J.arg(a, 0), J.arg(a, 1)), "startZ": func(_t, a): return start_z(J.arg(a, 0)), "mkFaci": func(_t, _a): mk_faci(); return null,
		"faci": func(_t, _a): return FACI, "TNAME": D.TNAME, "LMNAME": D.LMNAME, "terOf": func(_t, a): return ter_of(J.arg(a, 0)), "restRecover": func(_t, _a): rest_recover(); return null,
		"start": func(_t, a): start(J.arg(a, 0), J.arg(a, 1)); return null, "intro": func(_t, a): intro(J.arg(a, 0)); return null, "facOf": func(_t, a): return fac_of(J.arg(a, 0)),
		"FAC": FAC, "setMir": func(_t, a): MIR = int(n(J.arg(a, 0))) % 2 == 1; return null,
		"mapInfo": func(_t, a): return map_info(int(n(J.arg(a, 0)))), "mapCheck": func(_t, _a): return map_check_all(false)}
static func open_prep() -> void:
	map_check_all(false)
	if has("__nat_patrolMenu"):
		P["_menu"] = menu_obj()
		if t_(J.cl(G("__nat_patrolMenu"), null, ["prep"])): return
	rest_recover(); J.mc(G("UI"), "close", [])
	var show = func(_t = null, _a = null): J.mc(G("UI"), "sheet", ["夜班巡陰", prep_html()]); bind_prep(); return null
	if not t_(g(st(), "introSeen")): intro(show)
	else: show.call()
static func _is_bp(gh) -> bool: return J.seq(g(gh, "q"), "藍") or J.seq(g(gh, "q"), "紫")
static func prep_html() -> String:
	var p = st(); var crew = crew_list(); var ld = leads(); var S = S_(); var GP = G("GP"); var F = G("F")
	var all = []
	for gh in J.iter(g(S, "ghosts")): if _is_bp(gh): all.append(gh)
	var busy = 0; var tired = 0; var poached = 0
	for gh in all:
		if t_(g(gh, "post")): busy += 1
		if not t_(g(gh, "post")) and n(g(gh, "fat")) >= 100: tired += 1
		if t_(g(gh, "poached")): poached += 1
	var h = "<p class=\"desc\">" + T("帶部門出去巡邏。打倒嘅遊魂：<b>送去投胎</b>（冥幣＋執念）或者<b>遞合約</b>收編（要編制同壽包）。部門主管同區域總監就係主線關卡。", "帶部門出去巡邏。打倒的遊魂：<b>送去投胎</b>（冥幣＋執念）或<b>遞合約</b>收編（要編制和壽包）。部門主管和區域總監就是主線關卡。") + "</p>"
	h += "<div class=\"pt-mats\">"
	for f in FAC: h += "<span style=\"color:" + s_(FAC[f].col) + "\"><b>" + s_(FAC[f].mat) + "</b> " + fmt(g(g(p, "mats"), f)) + "</span>"
	h += "<span><b>壽包</b> " + fmt(g(g(S, "res"), "buns")) + "</span></div>"
	h += "<div class=\"pt-box\"><div class=\"pt-bh\"><b>我的部門</b><button class=\"btn sm\" id=\"pt-gear\">裝備房</button></div>"
	h += "<div class=\"pt-lead\">"
	for i in 3:
		var gh = ld[i] if i < ld.size() else null
		h += "<div class=\"pt-ls\" data-ls=\"" + s_(i) + "\">" + (("<canvas data-por=\"" + s_(g(gh, "k")) + "\"></canvas><b>" + s_(g(gh, "name")) + "</b><small>" + s_(J.mc(GP, "T", ["鬼力", "鬼力"])) + " " + s_(J.mc(GP, "pow", [gh])) + "</small>") if t_(gh) else "<span>＋<br>帶隊主管</span>") + "</div>"
	h += "</div>"
	h += "<p class=\"desc\">組員 <b>" + s_(crew.size()) + "</b>／編制 " + s_(crew_cap()) + "（民宅越高級編制越多）　陰兵 " + s_(troop_teams()) + " 隊（每 25 個一隊，最多 4 隊）</p>"
	var cs = ""
	for gh in crew: cs += "<span class=\"pt-cm\" title=\"" + s_(g(gh, "name")) + "\"><canvas data-por=\"" + s_(g(gh, "k")) + "\"></canvas><i style=\"background:" + s_(FAC[fac_of(g(gh, "k"))].col) + "\"></i><s style=\"width:" + s_(minf(100.0, n(g(gh, "fat")))) + "%\"></s><em>Lv" + s_(J.mc(F, "glv", [gh])) + "</em></span>"
	h += "<div class=\"pt-crew\">" + (cs if cs != "" else "<small>（村裡沒有閒置的雜鬼。先去招魂台招，或在巡邏中收編。）</small>") + "</div>"
	if busy or tired or poached: h += "<p class=\"desc pt-note\">" + (s_(busy) + " 隻派了工，留在村裡做事。" if busy else "") + (s_(tired) + " 隻過勞請病假（在村裡休息會慢慢恢復）。" if tired else "") + ("<b class=\"pt-red\">" + s_(poached) + " 隻被 Bryan 挖角</b>：在巡邏中打贏 Bryan 部門就能搶回來。" if poached else "") + "</p>"
	h += "</div>"
	var p0 = st()
	h += "<div class=\"pt-regs\">"
	var CHS = G("CHAPTERS"); var cleared = g(S, "cleared")
	for ci in int(J.len(CHS)):
		var ch = J.gp(CHS, float(ci)); var open = region_open(float(ci)); var r = reg_st(float(ci)); var stages = g(ch, "stages"); var nn = 0
		for si in int(J.len(stages)): if t_(J.gp(cleared, sid_of(ci, si))): nn += 1
		var cur = open and nn < 3; MIR = ci % 2 == 1; mk_faci(); var st0 = start_z(float(ci)); var stas = []
		for f in FACI: if J.seq(f.t, "station") and (f.z == st0 or t_(J.gp(g(r, "sta"), f.z))): stas.append(f)
		var kn = J.keys(g(r, "kings")).size() + nn; var lmn = J.keys(g(r, "lm") if t_(g(r, "lm")) else {}).size()
		var si2 = mini(2, nn)
		h += "<div class=\"pt-reg " + ("" if open else "locked") + " " + ("cur" if cur else "") + "\"><div><b>" + map_name(ci) + "・" + s_(g(ch, "name")) + "</b><small>" + (("地頭 " + s_(kn) + "/9　地標 " + s_(lmn) + "/" + s_(D.LMNAME[ci].size()) + "　主線 " + s_(nn) + "/3　" + s_(J.mc(GP, "T", ["建議鬼力", "建議鬼力"])) + " " + s_(J.mc(GP, "stageNeed", [J.gp(stages, float(si2)), sid_of(ci, si2)])) + "　需主公 Lv" + s_(g(J.gp(stages, 0.0), "req"))) if open else "打完上一區總監才開放") + "</small></div>"
		if open:
			h += "<div class=\"pt-go\">"
			for f in stas: h += "<button class=\"btn sm " + ("gold" if cur and f.z == st0 else "") + "\" data-go=\"" + s_(ci) + "," + s_(f.z) + "\">" + ("出發" if f.z == st0 else s_(D.TNAME[ci][int(ter_of(f.z))]) + "站") + "</button>"
			h += "</div></div>"
		else: h += "<span class=\"lk\">🔒</span></div>"
	if t_(g(g(S, "seen"), "ch1_end")) and has("Sports"): h += "</div><div class=\"sc-entry sp-entry\"><div><b>陰間運動會</b><small>殭屍跳遠、舌頭對脖子拔河、倒掛耐力、河童游泳</small></div><button class=\"btn gold\" id=\"sp-open\">參加</button>"
	h += "</div><label class=\"pt-auto\"><input type=\"checkbox\" id=\"pt-autoc\" " + ("checked" if t_(g(p0, "auto")) else "") + "> 自動送去投胎（不用逐隻選；遞合約要手動）</label>"
	return h
static func bind_prep() -> void:
	var root = q("#sheet"); J.cl(G("paintPortraits"), null, [root])
	for b in J.iter(J.mc(root, "querySelectorAll", ["[data-go]"])):
		J.sp(b, "onclick", func(_t, _a):
			var pr = s_(g(g(b, "dataset"), "go")).split(","); start(J.num(pr[0]), J.num(pr[1])); return null)
	for b in J.iter(J.mc(root, "querySelectorAll", ["[data-ls]"])):
		J.sp(b, "onclick", func(_t, _a): pick_lead(int(J.num(g(g(b, "dataset"), "ls")))); return null)
	var gb = q("#pt-gear")
	if t_(gb): J.sp(gb, "onclick", func(_t, _a): gear_open(func(_t2, _a2): open_prep(); return null); return null)
	var spo = q("#sp-open")
	if t_(spo): J.sp(spo, "onclick", func(_t, _a): J.mc(G("UI"), "close", []); J.mc(G("Sports"), "open", []); return null)
	var ac = q("#pt-autoc")
	if t_(ac): J.sp(ac, "onchange", func(_t, _a): J.sp(st(), "auto", g(ac, "checked")); save(); return null)
static func pick_lead(i: int) -> void:
	var p = st(); var cur = leads().map(func(x): return g(x, "id")); var nowid = cur[i] if i < cur.size() else null
	var GP = G("GP"); var F = G("F"); var SK = G("SKILLS")
	var list = []
	for gh in J.iter(g(S_(), "ghosts")): if J.seq(g(gh, "q"), "名"): list.append(gh)
	list = J.mc(list, "sort", [func(_t, x): return n(J.mc(GP, "pow", [x[1]])) - n(J.mc(GP, "pow", [x[0]]))])
	var h = "<p class=\"desc\">選帶隊主管（最多 3 隻）。主管不佔編制，倒下 25 秒後自動歸隊。</p><div class=\"glist\">"
	if t_(nowid): h += "<div class=\"gi\" data-g=\"\"><div><b>— 空著 —</b></div></div>"
	for gh in list:
		var k = g(gh, "k"); var fk = fac_of(k); var sk = J.gp(SK, k)
		h += "<div class=\"gi " + ("sel" if J.seq(g(gh, "id"), nowid) else "") + "\" data-g=\"" + s_(g(gh, "id")) + "\"><canvas data-por=\"" + s_(k) + "\"></canvas><div><b>" + s_(g(gh, "name")) + "</b> " + ("<i class=\"tag\">帶隊中</i>" if J.mc(cur, "includes", [g(gh, "id")]) else "") + "<small>Lv" + s_(J.mc(F, "glv", [gh])) + "　<b class=\"gp-pw\">" + s_(J.mc(GP, "T", ["鬼力", "鬼力"])) + " " + s_(J.mc(GP, "pow", [gh])) + "</b>　<span style=\"color:" + s_(FAC[fk].col) + "\">" + s_(FAC[fk].name) + "</span></small><small class=\"sk\">【" + s_(g(sk, "name")) + "】" + s_(g(sk, "desc")) + "</small></div></div>"
	h += "</div><button class=\"btn wide\" id=\"pkback\">返回</button>"
	J.mc(G("UI"), "sheet", ["帶隊主管", h]); J.cl(G("paintPortraits"), null, [q("#sheet")])
	J.sp(q("#pkback"), "onclick", func(_t, _a): open_prep(); return null)
	for el in J.iter(J.mc(q("#sheet"), "querySelectorAll", [".gi"])):
		J.sp(el, "onclick", func(_t, _a):
			var id = g(g(el, "dataset"), "g"); if not t_(id): id = null
			var arr = cur.duplicate()
			while arr.size() < 3: arr.append(null)
			var j = -1
			if id != null: j = int(n(J.mc(arr, "indexOf", [id])))
			if j >= 0: arr[j] = arr[i]
			arr[i] = id
			J.sp(p, "lead", arr.filter(func(x): return t_(x))); save(); open_prep(); return null)
static func start(ci, z) -> void:
	J.mc(G("UI"), "close", []); rest_recover()
	var ch = J.gp(G("CHAPTERS"), ci); var seen = g(S_(), "seen"); var any = false
	for id in J.iter(g(ch, "intro")): if not t_(J.gp(seen, id)): any = true
	for id in J.iter(g(ch, "intro")): if not t_(J.gp(seen, id)): J.mc(G("Story"), "queue", [id])
	var go = func(_t = null, _a = null): begin(ci, z); return null
	if any: J.mc(G("Story"), "queue", [{"style": "narr", "lines": [["旁白", map_name(int(n(ci))) + "・" + s_(g(ch, "name"))]]}, go])
	else: go.call()
static func begin(ci, z0) -> void:
	if has("__nat_patrol") and t_(J.cl(G("__nat_patrol"), null, [ci, z0])): return
	# 後備（Godot 唔會發生）：轉譯版冇對外 begin，用佢嘅 start（劇情已播就直接出發）
	push_warning("Patrol: __nat_patrol declined, falling back to transpiled patrol run")
	_load_tr()
	var sv = J.G.get("__nat_patrol"); J.G.erase("__nat_patrol")
	J.cl(_trx.start, null, [ci, z0])
	if sv != null: J.G["__nat_patrol"] = sv
static func close() -> void:
	if _tr != null and t_(J.mc(_trx.Patrol, "_R", [])): J.mc(_trx.Patrol, "close", []); return
	active = false; J.F_cancelAnimationFrame([0.0])
	var Snd = G("Sound")
	if t_(g(Snd, "setMode")): J.mc(Snd, "setMode", ["village"])
	J.mc(G("Quest"), "check", []); save(); J.mc(G("UI"), "refresh", [])

# 後備：載轉譯版（佢自己會設 J.G.Patrol／Gear，載完還原返原生）
static func _load_tr() -> void:
	if _tr != null: return
	var kp = J.G.get("Patrol"); var kg = J.G.get("Gear")
	_tr = load("res://jsgen/patrol.gd").new(); _tr.run(null)
	var tp = J.G.get("Patrol")
	# 攞轉譯版 start：叫一次佢嘅 openPrep（暫時換個只答 true 嘅 __nat_patrolMenu），佢會設 _menu
	var sm = J.G.get("__nat_patrolMenu"); J.G["__nat_patrolMenu"] = func(_t, _a): return true
	J.mc(tp, "openPrep", [])
	if sm != null: J.G["__nat_patrolMenu"] = sm
	else: J.G.erase("__nat_patrolMenu")
	_trx = {"Patrol": tp, "Gear": J.G.get("Gear"), "start": J.gp(J.gp(tp, "_menu"), "start")}
	J.G["Patrol"] = kp; J.G["Gear"] = kg
static func tr_call(name: String, a: Array, dflt):
	if _tr == null: return dflt
	return J.mc(_trx.Patrol, name, a)


# ======================= 地圖制（第一期）=======================
# data/nat/maps.json：6 張地圖（ci 0–5 ＝ patrol 區域）。通關送固有裝備（刻名版），隱藏鬼／隱藏裝備靠確定性條件。
# 已發記錄：S.pt.reg[ci].rw = {"boss":1, "eq":1, "he":1, "hg":1}
static var MAPS: Array = []
static var _mc_busy := false
static func _N(s: String) -> String: return s_(DB.call("N", s)) if DB.has_method("N") else s
static func map_def(ci: int) -> Dictionary: return MAPS[ci] if ci >= 0 and ci < MAPS.size() else {}
static func map_name(ci: int) -> String:
	var M = map_def(ci)
	if M.is_empty(): return "第" + CN[clampi(ci, 0, 5)] + "區"
	return T(s_(M.name[0]), s_(M.name[1]))
static func rw_of(ci: int) -> Dictionary:
	var r = reg_st(float(ci))
	if not (g(r, "rw") is Dictionary): J.sp(r, "rw", {})
	return g(r, "rw")
static func _has_num_key(d, v) -> bool:
	if not (d is Dictionary): return false
	for k in d.keys():
		if J.num(k) == n(v) and t_(d[k]): return true
	return false
static func _owned(k: String) -> bool:
	for gh in J.iter(g(S_(), "ghosts")): if J.seq(g(gh, "k"), k): return true
	return false
static func cond_ok(c: Dictionary) -> bool:
	var ci = int(n(c.get("ci", 0)))
	match s_(c.get("t")):
		"lm": return _has_num_key(g(reg_st(float(ci)), "lm"), c.id)
		"lmall":
			var lm = g(reg_st(float(ci)), "lm"); var cnt = 0
			if lm is Dictionary:
				for k in lm.keys(): if t_(lm[k]): cnt += 1
			return cnt >= D.LMNAME[ci].size()
		"king": return _has_num_key(g(reg_st(float(ci)), "kings"), c.tile)
		"clear": return t_(J.gp(g(S_(), "cleared"), s_(c.sid)))
		"rw": return t_(rw_of(ci).get(s_(c.k)))
		"own": return _owned(s_(c.k))
	return false
static func conds_ok(arr) -> bool:
	if not (arr is Array) or arr.is_empty(): return false
	for c in arr: if not cond_ok(c): return false
	return true
static func cleared_map(ci: int) -> bool: return t_(J.gp(g(S_(), "cleared"), sid_of(float(ci), 2.0)))
static func has_unique(uid: String) -> bool:
	for it in J.iter(g(gst(), "items")): if J.seq(g(it, "u"), uid): return true
	return false
static func give_unique(uid: String):
	var UT = D.GEAR.get("UNIQUE", {})
	if not UT.has(uid) or has_unique(uid): return null
	var U = UT[uid]; var s = gst(); var id = n(g(s, "uid")); J.sp(s, "uid", id + 1)
	var it = {"id": "e" + s_(id), "slot": s_(U.slot), "c": float(n(U.c)), "f": s_(U.f), "lv": 1.0, "who": null, "u": uid}
	J.mc(g(s, "items"), "push", [it])
	return it
static func _ghost_name(k: String) -> String:
	var d = J.gp(G("GHOSTS"), k)
	return s_(g(d, "name")) if t_(d) else k
static func _lines(story) -> Array:
	var out = []
	if story is Array:
		for l in story: out.append([s_(l[0]), T(s_(l[1]), s_(l[2]))])
	return out
# 檢查一張地圖；回傳 {"msgs": [...], "lines": [...]}
static func map_check(ci: int) -> Dictionary:
	var out = {"msgs": [], "lines": []}
	var M = map_def(ci)
	if M.is_empty() or not t_(S_()) or not t_(g(S_(), "ghosts")): return out
	var rw = rw_of(ci); var mn = map_name(ci)
	if cleared_map(ci):
		if not t_(rw.get("boss")): rw["boss"] = 1.0
		if not t_(rw.get("eq")) and M.get("eq") is Dictionary:
			var uid = s_(M.eq.u); give_unique(uid); rw["eq"] = 1.0
			out.msgs.append(T("【%s】通關獎勵：<b>%s</b>", "【%s】通關獎勵：<b>%s</b>") % [mn, s_(D.GEAR.UNIQUE[uid].n)])
	var he = M.get("he"); var hg = M.get("hg")
	if he is Dictionary and not t_(rw.get("he")) and conds_ok(he.get("cond")):
		var uid2 = s_(he.u); give_unique(uid2); rw["he"] = 1.0
		out.msgs.append(T("【%s】隱藏裝備：<b>%s</b>", "【%s】隱藏裝備：<b>%s</b>") % [mn, s_(D.GEAR.UNIQUE[uid2].n)])
		out.lines += _lines(he.get("story"))
	if hg is Dictionary and not t_(rw.get("hg")) and conds_ok(hg.get("cond")):
		var k = s_(hg.k); rw["hg"] = 1.0
		out.lines += _lines(hg.get("story"))
		if not _owned(k) and t_(J.gp(G("GHOSTS"), k)):
			J.cl(G("joinGhost"), null, [k])
			out.msgs.append(T("【%s】隱藏鬼：<b>%s</b> 跟你返村", "【%s】隱藏鬼：<b>%s</b> 跟你回村") % [mn, _ghost_name(k)])
		else:
			var ch = g(S_(), "chests")
			if t_(ch): J.sp(ch, "p", n(g(ch, "p")) + 1)
			out.msgs.append(T("【%s】隱藏鬼：<b>%s</b>（已經喺村，送你紫箱 ×1）", "【%s】隱藏鬼：<b>%s</b>（已經在村裡，送你紫箱 ×1）") % [mn, _ghost_name(k)])
	return out
# 全部地圖檢查一次；quiet＝開機補發（只出一個 toast，唔播劇情）
static func map_check_all(quiet := false) -> Array:
	if _mc_busy or not has("S") or not t_(S_()) or not t_(g(S_(), "ghosts")): return []
	_mc_busy = true
	var msgs = []; var lines = []
	for ci in MAPS.size():
		var r = map_check(ci); msgs += r.msgs; lines += r.lines
	_mc_busy = false
	if msgs.is_empty(): return msgs
	save()
	if has("Fx"): J.mc(G("Fx"), "toast", [_N(("<br>".join(msgs)) if not quiet else T("補發地圖獎勵：", "補發地圖獎勵：") + "<br>" + "<br>".join(msgs))])
	if not quiet and lines.size() and has("Story"): J.mc(G("Story"), "queue", [{"style": "narr", "lines": lines}])
	if has("UI"): J.mc(G("UI"), "refresh", [])
	return msgs
# 地圖卡用：名、環境、簡介、通關獎勵、隱藏 ?/2
static func map_info(ci: int) -> Dictionary:
	var M = map_def(ci)
	if M.is_empty(): return {}
	var rw = rw_of(ci); var boss = []
	for k in M.get("boss", []): boss.append(_ghost_name(s_(k)))
	var eqn = s_(D.GEAR.UNIQUE[s_(M.eq.u)].n) if M.get("eq") is Dictionary else ""
	var hid = []
	for key in ["hg", "he"]:
		var h = M.get(key)
		if not (h is Dictionary): continue
		var got = t_(rw.get(key))
		var nm = _ghost_name(s_(h.k)) if key == "hg" else s_(D.GEAR.UNIQUE[s_(h.u)].n)
		hid.append({"kind": key, "got": got, "name": nm, "hint": T(s_(h.hint[0]), s_(h.hint[1]))})
	var hn = 0
	for h in hid: if h.got: hn += 1
	return {"name": T(s_(M.name[0]), s_(M.name[1])), "ch": s_(M.get("ch", "")), "env": T(s_(M.env[0]), s_(M.env[1])), "intro": T(s_(M.intro[0]), s_(M.intro[1])),
		"boss": boss, "eq": eqn, "cleared": cleared_map(ci), "eqGot": t_(rw.get("eq")), "hidden": hid, "hn": hn, "ht": hid.size()}

# ======================= Gear =======================
static func gst():
	var S = S_()
	if not t_(g(S, "gear")): J.sp(S, "gear", {"items": [], "uid": 1.0})
	return g(S, "gear")
static func held(gh) -> Array:
	if not t_(gh): return []
	var out = []
	for it in J.iter(g(gst(), "items")): if J.seq(g(it, "who"), g(gh, "id")): out.append(it)
	return out
static func fki(f) -> int: return D.GEAR.FK.find(s_(f))
static func weapon_of(gh):
	for it in held(gh):
		if J.seq(g(it, "slot"), "wea"):
			var c = int(n(g(it, "c"))); var i = fki(g(it, "f")); var sty = D.GEAR.WSTY[c][i]; var img = D.GEAR.WIMG[c][i]
			var U = uq(it)
			if U != null:
				if s_(U.get("sty", "")) != "": sty = s_(U.sty)
				if s_(U.get("img", "")) != "": img = s_(U.img)
			return {"it": it, "img": img, "sty": sty, "S": D.GEAR.STY[sty], "lvMul": 1 + 0.04 * (n(g(it, "lv")) - 1)}
	return null
static func _slot_of(gh, sl: String):
	for it in held(gh): if J.seq(g(it, "slot"), sl): return it
	return null
# 唯一裝備（地圖固有／隱藏）：物品有 u 欄 → 查 GEAR.UNIQUE
static func uq(it):
	var u = g(it, "u")
	if not t_(u): return null
	var UT = D.GEAR.get("UNIQUE", {})
	return UT.get(s_(u))
static func img_of(it) -> String:
	var U = uq(it)
	if U != null and s_(U.get("img", "")) != "": return s_(U.img)
	if not J.seq(g(it, "slot"), "wea"): return ""
	return s_(D.GEAR.WIMG[int(n(g(it, "c")))][fki(g(it, "f"))])
static func desc_of(it) -> String:
	var U = uq(it)
	if U == null or not (U.get("d") is Array): return ""
	return T(s_(U.d[0]), s_(U.d[1]))
static func name_of(it) -> String:
	var U = uq(it)
	if U != null: return s_(U.n)
	var l = D.GEAR.NAMES[s_(g(it, "slot"))][int(n(g(it, "c")))]
	return s_(l[0]) + "・" + s_(FAC[s_(g(it, "f"))].name) if J.seq(g(it, "slot"), "acc") else s_(l[fki(g(it, "f"))])
static func pct(it) -> float:
	var U = uq(it); var mul = n(U.get("mul", 1.0)) if U != null else 1.0
	return jround((5 + 5 * n(g(it, "c"))) * (1 + 0.15 * (n(g(it, "lv")) - 1)) * mul)
static func craft_cost(c, f) -> Dictionary:
	var k = n(c) + 1
	return {"r": {"coins": jround(150 * pow(k, 1.7)), "planks": jround(40 * pow(k, 1.5))}, "mat": {s_(f): jround(12 * pow(k, 1.4))}}
static func up_cost(it) -> Dictionary:
	var k = n(g(it, "c")) + 1; var lv = n(g(it, "lv"))
	return {"r": {"coins": jround(60 * k * lv), "planks": jround(10 * k * lv)}, "mat": {s_(g(it, "f")): jround(4 * k * lv)}}
static func can_pay_all(c) -> bool:
	var m = g(st(), "mats")
	if not t_(J.cl(G("canPay"), null, [g(c, "r")])): return false
	for f in J.keys(g(c, "mat")): if not (n(J.gp(m, f)) >= n(J.gp(g(c, "mat"), f))): return false
	return true
static func pay_all(c) -> void:
	J.cl(G("pay"), null, [g(c, "r")]); var m = g(st(), "mats")
	for f in J.keys(g(c, "mat")): J.sp(m, f, n(J.gp(m, f)) - n(J.gp(g(c, "mat"), f)))
static func cost_html(c) -> String:
	var m = g(st(), "mats"); var s = s_(J.cl(G("costText"), null, [g(c, "r")])) + "　"
	for f in J.keys(g(c, "mat")): s += "<span class=\"" + ("" if n(J.gp(m, f)) >= n(J.gp(g(c, "mat"), f)) else "lack") + "\">" + s_(FAC[s_(f)].mat) + " " + s_(J.gp(g(c, "mat"), f)) + "</span>"
	return s
static func unit_mul(gh) -> Dictionary:
	var atk = 1.0; var hp = 1.0
	for it in held(gh):
		var p = pct(it) / 100; var sl = s_(g(it, "slot"))
		if sl == "wea": atk += p
		elif sl == "arm": hp += p * 1.2
		else: atk += p * 0.3
	return {"atk": atk, "hp": hp}
static func gp_mul(gh) -> float:
	var m = unit_mul(gh); return 1 + ((m.atk - 1) + (m.hp - 1)) / 2
static func crew_buff() -> Dictionary:
	var out = {"yuan": {"atk": 1.0, "hp": 1.0}, "chan": {"atk": 1.0, "hp": 1.0}, "lan": {"atk": 1.0, "hp": 1.0}}
	var S = S_(); var ids = ["afu"]; var pt = g(S, "pt"); var ld = g(pt, "lead") if t_(pt) else null
	if t_(ld): ids += Array(J.iter(ld))
	else:
		for x in J.iter(g(S, "team")): if t_(x): ids.append(x)
	for it in J.iter(g(gst(), "items")):
		if J.mc(ids, "includes", [g(it, "who")]):
			var p = pct(it) / 100; var f = s_(g(it, "f"))
			if J.seq(g(it, "slot"), "acc"): out[f].atk += p * 0.6
			if J.seq(g(it, "slot"), "arm"): out[f].hp += p * 0.5
	return out
static func eff_text(it) -> String:
	var p = pct(it); var f = s_(FAC[s_(g(it, "f"))].name); var sl = s_(g(it, "slot"))
	if sl == "wea":
		var sk = D.GEAR.WSTY[int(n(g(it, "c")))][fki(g(it, "f"))]; var U = uq(it)
		if U != null and s_(U.get("sty", "")) != "": sk = s_(U.sty)
		var S2 = D.GEAR.STY[sk]
		return "攻擊 +" + s_(p) + "%・" + s_(S2.n) + "：" + s_(S2.d)
	if sl == "arm": return "血 +" + s_(jround(p * 1.2)) + "%・" + f + "組員血 +" + s_(jround(p * 0.5)) + "%"
	return f + "組員攻擊 +" + s_(jround(p * 0.6)) + "%・自己攻擊 +" + s_(jround(p * 0.3)) + "%"
static func icon(it) -> String:
	if not J.seq(g(it, "slot"), "wea"): return ""
	var src = J.gp(G("PT_IMG_SRC"), img_of(it)) if has("PT_IMG_SRC") else false
	return "<img class=\"gr-ic\" src=\"" + s_(src) + "\" alt=\"\">" if t_(src) else ""
static func gmenu_obj() -> Dictionary:
	return {"st": func(_t, _a): return gst(), "nameOf": func(_t, a): return name_of(J.arg(a, 0)), "effText": func(_t, a): return eff_text(J.arg(a, 0)),
		"craftCost": func(_t, a): return craft_cost(J.arg(a, 0), J.arg(a, 1)), "upCost": func(_t, a): return up_cost(J.arg(a, 0)),
		"canPayAll": func(_t, a): return can_pay_all(J.arg(a, 0)), "payAll": func(_t, a): pay_all(J.arg(a, 0)); return null,
		"held": func(_t, a): return held(J.arg(a, 0)), "FK": D.GEAR.FK, "WIMG": D.GEAR.WIMG, "SLOTS": D.GEAR.SLOTS,
		"imgOf": func(_t, a): return img_of(J.arg(a, 0)), "descOf": func(_t, a): return desc_of(J.arg(a, 0)), "isUnique": func(_t, a): return uq(J.arg(a, 0)) != null,
		"mapName": func(_t, a): return map_name(int(n(J.arg(a, 0))))}
static func gear_open(b) -> void:
	if has("__nat_patrolMenu"):
		GE["_menu"] = gmenu_obj()
		if t_(J.cl(G("__nat_patrolMenu"), null, ["gear", b])): return
	if t_(b): g_back = b
	gear_render()
static func gear_render() -> void:
	var s = gst(); var m = g(st(), "mats"); var S = S_(); var SL = D.GEAR.SLOTS
	var who = []
	for gh in J.iter(g(S, "ghosts")): if J.seq(g(gh, "q"), "名") or J.seq(g(gh, "q"), "主"): who.append(gh)
	var h = "<p class=\"desc\">用冥幣、棺材板和執念打造。武器、衣服、掛繩都可以隨時換給別的角色戴。加成會帶到所有玩法（鬼力）。</p>"
	h += "<div class=\"pt-mats\">"
	for f in FAC: h += "<span style=\"color:" + s_(FAC[f].col) + "\"><b>" + s_(FAC[f].mat) + "</b> " + fmt(J.gp(m, f)) + "</span>"
	h += "<span><b>棺材板</b> " + fmt(g(g(S, "res"), "planks")) + "</span><span><b>冥幣</b> " + fmt(g(g(S, "res"), "coins")) + "</span></div>"
	h += "<div class=\"gr-tabs\">"
	for k in SL: h += "<button class=\"btn sm " + ("gold" if g_tab == k else "") + "\" data-tab=\"" + k + "\">" + s_(SL[k]) + "</button>"
	h += "</div>"
	var mine = []
	for it in J.iter(g(s, "items")): if J.seq(g(it, "slot"), g_tab): mine.append(it)
	h += "<div class=\"ch-h\">我的" + s_(SL[g_tab]) + "（" + s_(mine.size()) + "）</div><div class=\"gr-list\">"
	for it in mine:
		var w = J.cl(G("ghostById"), null, [g(it, "who")]); var uc = up_cost(it)
		h += "<div class=\"gr-it\"><div class=\"gr-n\">" + icon(it) + "<b style=\"color:" + s_(FAC[s_(g(it, "f"))].col) + "\">" + name_of(it) + "</b> <i>Lv" + s_(g(it, "lv")) + "</i><small>" + eff_text(it) + "</small><small>" + ("佩戴：" + s_(g(w, "name")) if t_(w) else "未戴") + "</small></div>\n        <div class=\"gr-b\"><select data-who=\"" + s_(g(it, "id")) + "\"><option value=\"\">— 不戴 —</option>"
		for gh in who: h += "<option value=\"" + s_(g(gh, "id")) + "\" " + ("selected" if J.seq(g(gh, "id"), g(it, "who")) else "") + ">" + s_(g(gh, "name")) + "</option>"
		h += "</select>\n        " + (("<button class=\"btn sm gold\" data-up=\"" + s_(g(it, "id")) + "\" " + ("" if can_pay_all(uc) else "disabled") + ">升級<small>" + cost_html(uc) + "</small></button>") if n(g(it, "lv")) < 10 else "<small>滿級</small>") + "</div></div>"
	if not mine.size(): h += "<p class=\"desc\">還沒有。在下面打造。</p>"
	h += "</div><div class=\"ch-h\">打造</div><div class=\"gr-list\">"
	var CHS = G("CHAPTERS")
	for c in int(J.len(CHS)):
		var open = region_open(float(c))
		for f in D.GEAR.FK:
			var it = {"slot": g_tab, "c": float(c), "f": f, "lv": 1.0}; var cc = craft_cost(float(c), f)
			h += "<div class=\"gr-it " + ("" if open else "dis") + "\"><div class=\"gr-n\">" + icon(it) + "<b style=\"color:" + s_(FAC[f].col) + "\">" + name_of(it) + "</b> <i>" + map_name(c) + "</i><small>" + eff_text(it) + "</small></div><div class=\"gr-b\">" + (("<button class=\"btn sm\" data-mk=\"" + s_(c) + "," + f + "\" " + ("" if can_pay_all(cc) else "disabled") + ">打造<small>" + cost_html(cc) + "</small></button>") if open else "<small>巡到這區才解鎖</small>") + "</div></div>"
	h += "</div><button class=\"btn wide\" id=\"gr-back\">返回</button>"
	J.mc(G("UI"), "sheet", ["裝備房", h])
	var root = q("#sheet")
	for b in J.iter(J.mc(root, "querySelectorAll", ["[data-tab]"])):
		J.sp(b, "onclick", func(_t, _a): g_tab = s_(g(g(b, "dataset"), "tab")); _keep(); return null)
	for b in J.iter(J.mc(root, "querySelectorAll", ["[data-mk]"])):
		J.sp(b, "onclick", func(_t, _a):
			var pr = s_(g(g(b, "dataset"), "mk")).split(","); var cc = craft_cost(J.num(pr[0]), pr[1])
			if not can_pay_all(cc): return null
			pay_all(cc); var uid = n(g(s, "uid")); J.sp(s, "uid", uid + 1)
			var it = {"id": "e" + s_(uid), "slot": g_tab, "c": J.num(pr[0]), "f": pr[1], "lv": 1.0, "who": null}; J.mc(g(s, "items"), "push", [it])
			J.mc(G("Fx"), "toast", ["打造了 <b>" + name_of(it) + "</b>"]); J.mc(G("Sound"), "play", ["gong"]); save(); _keep(); return null)
	for b in J.iter(J.mc(root, "querySelectorAll", ["[data-up]"])):
		J.sp(b, "onclick", func(_t, _a):
			var it = null
			for x in J.iter(g(s, "items")): if J.seq(g(x, "id"), g(g(b, "dataset"), "up")): it = x; break
			var uc = up_cost(it)
			if not can_pay_all(uc) or n(g(it, "lv")) >= 10: return null
			pay_all(uc); J.sp(it, "lv", n(g(it, "lv")) + 1); J.mc(G("Fx"), "toast", [name_of(it) + " 升到 Lv" + s_(g(it, "lv"))]); save(); _keep(); return null)
	for sel in J.iter(J.mc(root, "querySelectorAll", ["[data-who]"])):
		J.sp(sel, "onchange", func(_t, _a):
			var it = null
			for x in J.iter(g(s, "items")): if J.seq(g(x, "id"), g(g(sel, "dataset"), "who")): it = x; break
			var id = g(sel, "value"); if not t_(id): id = null
			if id != null:
				for x in J.iter(g(s, "items")):
					if not is_same(x, it) and J.seq(g(x, "who"), id) and J.seq(g(x, "slot"), g(it, "slot")): J.sp(x, "who", null)
			J.sp(it, "who", id); save(); _keep(); return null)
	J.sp(q("#gr-back"), "onclick", func(_t, _a):
		if g_back != null: J.cl(g_back, null, [])
		else: J.mc(G("UI"), "close", [])
		return null)
static func _keep() -> void:
	var b = q("#sheet .sh-body"); var sc = g(b, "scrollTop") if t_(b) else 0.0
	gear_render()
	var b2 = q("#sheet .sh-body")
	if t_(b2): J.sp(b2, "scrollTop", sc)

func run(_env) -> void:
	var f = FileAccess.open("res://data/nat/patrol.json", FileAccess.READ)
	D = JSON.parse_string(f.get_as_text())
	FAC = D.FAC; FAC_OF = D.FAC_OF; COLS = int(D.COLS); CW = D.CW; CH = D.CH
	MIR = false; mk_faci(); HOOK = {}; active = false
	var nat = {}
	for k in ["CW", "CH", "COLS", "ROWS", "FOG", "VIEW", "GW", "FAC", "FAC_OF", "REG", "CH_FOD", "TLAY", "TGATE", "TLAIR", "TMAIN", "TSECRET", "TNAME", "LM_N", "LMNAME", "TKING", "TTIER", "FACI0", "TEA_CD", "DOWN_T", "MEET", "SOLID", "PROP", "HUE", "TC", "CLOTH", "ACC", "RING", "ATK", "PH"]: nat[k] = D[k]
	nat.merge({"st": func(_t, _a): return st(), "regSt": func(_t, a): return reg_st(J.arg(a, 0)), "startZ": func(_t, a): return start_z(J.arg(a, 0)),
		"sidOf": func(_t, a): return sid_of(J.arg(a, 0), J.arg(a, 1)), "regionOpen": func(_t, a): return region_open(J.arg(a, 0)),
		"crewCap": func(_t, _a): return crew_cap(), "troopTeams": func(_t, _a): return troop_teams(), "crewList": func(_t, _a): return crew_list(),
		"leads": func(_t, _a): return leads(), "restRecover": func(_t, _a): rest_recover(); return null, "facOf": func(_t, a): return fac_of(J.arg(a, 0)),
		"phase": func(_t, a): return phase(J.arg(a, 0)), "elitesOf": func(_t, a): return elites_of(J.arg(a, 0)), "fodOf": func(_t, a): return fod_of(J.arg(a, 0)),
		"pageGhosts": func(_t, a): return page_ghosts(J.arg(a, 0)), "emit": func(_t, a): emit(J.arg(a, 0), J.arg(a, 1)); return null,
		"setActive": func(_t, a):
			active = J.t(J.arg(a, 0))
			if not active: J.F_setTimeout([func(_t2, _a2): map_check_all(false); return null, 400.0])
			return null, "T": func(_t, a): return T(J.str(J.arg(a, 0)), J.str(J.arg(a, 1)))})
	P = {"_nat": nat,
		"open": func(_t, _a): open_prep(); return null, "openPrep": func(_t, _a): open_prep(); return null, "close": func(_t, _a): close(); return null,
		"FAC": FAC, "facOf": func(_t, a): return fac_of(J.arg(a, 0)), "st": func(_t, _a): return st(), "regionOpen": func(_t, a): return region_open(J.arg(a, 0)),
		"_R": func(_t, _a): return tr_call("_R", [], null),
		"_end": func(_t, a): return tr_call("_end", a, null),
		"_gain": func(_t, a): return tr_call("_gain", a, null),
		"spots": func(_t, _a): return tr_call("spots", [], []),
		"landmarks": func(_t, a): return landmarks(J.arg(a, 0)),
		"on": func(_t, a): on_(J.str(J.arg(a, 0)), J.arg(a, 1)); return null,
		"openMap": func(_t, _a): return tr_call("openMap", [], null),
		"__getters": {"active": func(_t = null, _a = null): return active, "_test": func(_t = null, _a = null): _load_tr(); return J.gp(_trx.Patrol, "_test")},
	}
	J.G["Patrol"] = P
	GE = {"open": func(_t, a): gear_open(J.arg(a, 0)); return null, "unitMul": func(_t, a): return unit_mul(J.arg(a, 0)), "gpMul": func(_t, a): return gp_mul(J.arg(a, 0)),
		"crewBuff": func(_t, _a): return crew_buff(), "held": func(_t, a): return held(J.arg(a, 0)), "nameOf": func(_t, a): return name_of(J.arg(a, 0)), "pct": func(_t, a): return pct(J.arg(a, 0)),
		"SLOTS": D.GEAR.SLOTS, "weaponOf": func(_t, a): return weapon_of(J.arg(a, 0)), "armorOf": func(_t, a): return _slot_of(J.arg(a, 0), "arm"), "badgeOf": func(_t, a): return _slot_of(J.arg(a, 0), "acc"),
		"STY": D.GEAR.STY, "WIMG": D.GEAR.WIMG}
	J.G["Gear"] = GE
	MAPS = []
	if FileAccess.file_exists("res://data/nat/maps.json"):
		var mf = JSON.parse_string(FileAccess.get_file_as_string("res://data/nat/maps.json"))
		if mf is Dictionary and mf.get("MAPS") is Array: MAPS = mf.MAPS
	for e in ["king", "secret", "page", "cache", "discover"]:
		on_(e, func(_t, _a): map_check_all(false); return null)
	# 舊存檔開機補發一次（條件已達成但未發）
	J.F_setTimeout([func(_t, _a): map_check_all(true); return null, 6000.0])
