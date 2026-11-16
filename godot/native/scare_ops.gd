# 原生改寫自 scare_ops.js（回陽間・近身操作：手機／電腦／茶水間；資料 data/nat/scare_ops.json）
# 補丁照保留：openPhone／compose／openPC／openPantry 先問 __nat_scOps（原生視窗 game/scare/sc_ops.gd）；對外多出 TAB、INTEL_NAME、cdOf、close
extends RefCounted

const CD := 25.0
static var OPS = {}
static var PANTRY = []
static var TAB = {}
static var INTEL_NAME = {}

static func _g(n: String): return J.G.get(n)
static func Lx(s): var f = _g("L"); return J.cl(f, null, [s]) if f != null else s
static func _s(v) -> String: return J.str(v)
static func _q(sel: String): return J.cl(_g("$"), null, [sel])
static func _nat(kind: String, args: Array) -> bool:
	var f = _g("__nat_scOps")
	return f != null and J.t(J.cl(f, null, [kind] + args))

# ---------- 狀態 ----------
static func intel(Sc, k):
	if not J.t(J.gp(Sc, "_intel")): J.sp(Sc, "_intel", {})
	var I = J.gp(Sc, "_intel")
	var v = J.gp(I, k)
	if not J.t(v): v = J.new_("Set", []); J.sp(I, k, v)
	return v

static func cd_of(Sc, n, id) -> float:
	if not J.t(J.gp(Sc, "_opcd")): J.sp(Sc, "_opcd", {})
	var v = J.gp(J.gp(Sc, "_opcd"), J.add(J.gp(J.gp(n, "d"), "k"), id))
	return maxf(0.0, J.num(v if J.t(v) else 0.0) - J.num(J.gp(Sc, "t")))

static func ctx(Sc, n) -> Dictionary:
	var st = J.gp(n, "step")
	if not J.t(st): st = {}
	var room = J.mc(Sc, "roomOf", [n]) if J.t(J.gp(J.gp(Sc, "site"), "pano")) else ""
	var act = J.gp(n, "act")
	if not J.t(act):
		act = J.gp(st, "act") if J.t(J.gp(st, "arrived")) else J.gp(st, "arrived")
	if not J.t(act): act = ""
	var O = J.gp(OPS, J.gp(J.gp(n, "d"), "k"))
	var at_desk = J.t(O) and J.t(J.gp(O, "pc")) and (J.seq(act, "work") or J.seq(act, "call")) and not J.seq(room, "pantry")
	return {"room": room, "atDesk": at_desk, "pantry": J.seq(room, "pantry")}

static func buttons(Sc, n) -> String:
	var O = J.gp(OPS, J.gp(J.gp(n, "d"), "k"))
	if not J.t(O) or J.t(J.gp(n, "out")): return ""
	var c = ctx(Sc, n); var h = ""
	if J.t(J.gp(O, "apps")): h += "<button class=\"btn sm\" data-op=\"phone\">手機</button>"
	if c.atDesk: h += "<button class=\"btn sm gold\" data-op=\"pc\">電腦</button>"
	if c.pantry and not J.t(J.gp(J.gp(n, "d"), "guard")): h += "<button class=\"btn sm gold\" data-op=\"pantry\">茶水間</button>"
	return h

# ---------- 視窗 ----------
static func modal(Sc, html: String, cls: String):
	J.sp(Sc, "paused", true)
	var p = _q("#sc-phone")
	J.sp(p, "innerHTML", "<div class=\"" + cls + "\">" + html + "</div>")
	J.mc(J.gp(p, "classList"), "add", ["on"])
	for b in J.iter(J.mc(p, "querySelectorAll", ["[data-x]"])):
		J.sp(b, "onclick", func(_t, _a): close(Sc); return null)
	return p

static func close(Sc) -> void:
	var p = _q("#sc-phone")
	J.mc(J.gp(p, "classList"), "remove", ["on"])
	J.sp(p, "innerHTML", "")
	J.sp(Sc, "paused", false)
	J.sp(Sc, "last", J.S_performance_("now", []))
	J.mc(Sc, "renderTarget", [])

static func open_phone(Sc, n, tab) -> void:
	var d = J.gp(n, "d"); var k = J.gp(d, "k")
	var O = J.gp(OPS, k); var A = J.gp(O, "apps"); var I = intel(Sc, k)
	if not J.t(tab): tab = "msg"
	if not J.t(J.gp(Sc, "known")): J.sp(Sc, "known", {})
	var KN = J.gp(Sc, "known")
	if not J.t(J.gp(KN, k)): J.sp(KN, k, J.new_("Set", []))
	var K = J.gp(KN, k)
	var hide = J.gp(d, "hide")
	for t in J.iter(hide if J.t(hide) else []): J.mc(K, "add", [t])   # 舊規則：揭手機就知佢隱藏嘅弱點
	var got = []
	var learn = func(ik):
		if J.t(ik) and not J.t(J.mc(I, "has", [ik])):
			J.mc(I, "add", [ik])
			var nm = J.gp(INTEL_NAME, ik); got.append(nm if J.t(nm) else ik)
	var body = ""
	if J.seq(tab, "msg"):
		var parts = []
		for c in J.iter(J.gp(A, "msg")):
			learn.call(J.gp(c, "intel"))
			var its = []
			for m in J.iter(J.gp(c, "items")):
				if J.t(m[0]): its.append("<div class=\"sc-m %s\"><i>%s・%s</i>%s</div>" % ["me" if J.seq(m[0], J.gp(d, "name")) else "", _s(m[0]), _s(m[1]), _s(m[2])])
				else: its.append("<div class=\"so-sys\">%s</div>" % _s(m[2]))
			parts.append("<div class=\"so-chat\"><div class=\"so-ct\">%s</div>%s</div>" % [_s(J.gp(c, "title")), "".join(its)])
		body = "".join(parts)
	if J.seq(tab, "photo"):
		learn.call(J.gp(A, "intelPhoto"))
		var ph = []; var i = 0
		for p in J.iter(J.gp(A, "photo")): i += 1; ph.append("<div class=\"so-ph\"><span>%d</span>%s</div>" % [i, _s(p)])
		body = "<div class=\"so-photos\">%s</div>" % "".join(ph)
	if J.seq(tab, "search"):
		var ss = []
		for s in J.iter(J.gp(A, "search")): learn.call(s[1]); ss.append("<div class=\"so-search\">🔍 %s</div>" % _s(s[0]))
		body = "".join(ss)
	if J.seq(tab, "note"):
		var ls = []
		for l in J.iter(J.gp(A, "note")): ls.append("<p>%s</p>" % _s(l))
		body = "<div class=\"so-note\">%s</div>" % "".join(ls)
	var msgs = J.gp(O, "msgs")
	if not J.t(msgs): msgs = []
	if _nat("phone", [Sc, n, tab, got]):
		J.sp(Sc, "paused", true)
		if got.size() and not J.t(J.gp(Sc, "headless")): J.mc(Sc, "renderTarget", [])
		return
	var tabs = []
	for tk in TAB: tabs.append("<button class=\"%s\" data-tab=\"%s\">%s</button>" % ["on" if J.seq(tk, tab) else "", tk, _s(TAB[tk])])
	var html = "<div class=\"sc-ph-h\">%s 的手機<button data-x>✕</button></div>\n      <div class=\"so-tabs\">%s</div>\n      <div class=\"sc-ph-b\">%s</div>\n      %s\n      <div class=\"sc-ph-f\">%s<small>看手機時，時間是停的。</small></div>" % [
		_s(J.gp(d, "name")), "".join(tabs), body,
		("<div class=\"so-got\">得到情報：%s</div>" % "、".join(got.map(func(x): return _s(x)))) if got.size() else "",
		"<button class=\"btn gold wide\" data-send>傳訊息嚇他</button>" if J.len(msgs) > 0 else ""]
	var pp = modal(Sc, html, "sc-ph so-phone")
	for b in J.iter(J.mc(pp, "querySelectorAll", ["[data-tab]"])):
		J.sp(b, "onclick", func(_t, _a): open_phone(Sc, n, J.gp(J.gp(b, "dataset"), "tab")); return null)
	var sb = J.mc(pp, "querySelector", ["[data-send]"])
	if J.t(sb): J.sp(sb, "onclick", func(_t, _a): compose(Sc, n); return null)
	if got.size() and not J.t(J.gp(Sc, "headless")): J.mc(Sc, "renderTarget", [])

static func opt_row(Sc, n, o, locked) -> String:
	var cd = cd_of(Sc, n, J.gp(o, "id")); var poor = J.num(J.gp(Sc, "mana")) < J.num(J.gp(o, "cost"))
	var who = J.gp(o, "who")
	var small = ""
	if J.t(locked): small = "需要情報：%s（先看他的手機）" % _s(J.gp(INTEL_NAME, J.gp(o, "need")))
	elif cd > 0: small = "冷卻 %s 秒" % _s(ceil(cd))
	else:
		small = "陰氣 %s%s" % [_s(J.gp(o, "cost")), "" if (J.t(J.gp(o, "trap")) or J.t(J.gp(o, "warm"))) else "・算「%s」" % _s(J.gp(_g("FEAR_WORD"), J.gp(o, "type")))]
	return "<button class=\"so-op %s %s\" data-o=\"%s\" %s>\n      %s<span>%s</span><small>%s</small></button>" % [
		"lock" if J.t(locked) else "", "dim" if (cd > 0 or poor) else "", _s(J.gp(o, "id")), "disabled" if (J.t(locked) or cd > 0) else "",
		("<b>%s</b>" % _s(who)) if J.t(who) else "", _s(J.gp(o, "text")), small]

static func compose(Sc, n) -> void:
	if _nat("msg", [Sc, n]): J.sp(Sc, "paused", true); return
	var d = J.gp(n, "d"); var O = J.gp(OPS, J.gp(d, "k")); var I = intel(Sc, J.gp(d, "k"))
	var rows = []
	for o in J.iter(J.gp(O, "msgs")):
		var need = J.gp(o, "need")
		rows.append(opt_row(Sc, n, o, J.t(need) and not J.t(J.mc(I, "has", [need]))))
	var p = modal(Sc, "<div class=\"sc-ph-h\">傳訊息給 %s<button data-x>✕</button></div><div class=\"sc-ph-b so-list\"><p class=\"so-hint\">選冒充誰、傳什麼。對準他怕的、用上情報，嚇得最狠；選錯了可能反效果。</p>%s</div><div class=\"sc-ph-f\"><button class=\"btn sm\" data-back>返回手機</button></div>" % [_s(J.gp(d, "name")), "".join(rows)], "sc-ph so-phone")
	J.sp(J.mc(p, "querySelector", ["[data-back]"]), "onclick", func(_t, _a): open_phone(Sc, n, null); return null)
	bind_ops(Sc, n, p, J.gp(O, "msgs"), "msg")

static func open_pc(Sc, n) -> void:
	if _nat("pc", [Sc, n]): J.sp(Sc, "paused", true); return
	var d = J.gp(n, "d"); var P = J.gp(J.gp(OPS, J.gp(d, "k")), "pc")
	var ls = []; for l in J.iter(J.gp(P, "lines")): ls.append("<p>%s</p>" % _s(l))
	var os_ = []; for o in J.iter(J.gp(P, "ops")): os_.append(opt_row(Sc, n, o, null))
	var p = modal(Sc, "<div class=\"so-mon\"><div class=\"so-mh\">%s 的電腦<button data-x>✕</button></div><div class=\"so-scr\"><b>%s</b>%s</div></div><div class=\"so-list\">%s</div>" % [_s(J.gp(d, "name")), _s(J.gp(P, "title")), "".join(ls), "".join(os_)], "so-pc")
	bind_ops(Sc, n, p, J.gp(P, "ops"), "pc")

static func open_pantry(Sc, n) -> void:
	if _nat("pantry", [Sc, n]): J.sp(Sc, "paused", true); return
	var os_ = []; for o in PANTRY: os_.append(opt_row(Sc, n, o, null))
	var p = modal(Sc, "<div class=\"so-mh\">茶水間・%s<button data-x>✕</button></div><div class=\"so-list\"><p class=\"so-hint\">他在茶水間。選一樣他怕的。</p>%s</div>" % [_s(J.gp(J.gp(n, "d"), "name")), "".join(os_)], "so-pc")
	bind_ops(Sc, n, p, PANTRY, "pantry")

static func bind_ops(Sc, n, p, list, kind: String) -> void:
	for b in J.iter(J.mc(p, "querySelectorAll", ["[data-o]"])):
		J.sp(b, "onclick", func(_t, _a):
			var id = J.gp(J.gp(b, "dataset"), "o")
			for o in J.iter(list):
				if J.seq(J.gp(o, "id"), id): act(Sc, n, o, kind); break
			return null)

# ---------- 執行 ----------
static func act(Sc, n, o, kind) -> void:
	var d = J.gp(n, "d"); var cost = J.num(J.gp(o, "cost"))
	if J.num(J.gp(Sc, "mana")) < cost: J.mc(Sc, "toast", ["陰氣不夠，等一下"]); return
	if cd_of(Sc, n, J.gp(o, "id")) > 0: return
	close(Sc)
	if J.t(J.gp(n, "gone")) or J.t(J.gp(n, "out")) or J.t(J.gp(n, "fleeing")): J.mc(Sc, "toast", [_s(J.gp(d, "name")) + "不在"]); return
	J.sp(Sc, "mana", J.num(J.gp(Sc, "mana")) - cost)
	if not J.t(J.gp(Sc, "_opcd")): J.sp(Sc, "_opcd", {})
	J.sp(J.gp(Sc, "_opcd"), J.add(J.gp(d, "k"), J.gp(o, "id")), J.num(J.gp(Sc, "t")) + CD)
	var headless = J.t(J.gp(Sc, "headless"))
	if not headless:
		J.mc(_g("Sound"), "play", ["click" if J.seq(kind, "msg") else ("paper" if J.seq(kind, "pc") else "whoosh")])
		J.mc(J.gp(Sc, "fx"), "push", [{"kind": "phone" if J.seq(kind, "msg") else "breath", "life": 1.6, "max": 1.6, "n": n}])
	var tag = ("📱 " + _s(J.gp(o, "who")) + "：" + _s(J.gp(o, "text"))) if J.seq(kind, "msg") else J.gp(o, "text")
	var x = J.gp(n, "x"); var y = J.num(J.gp(n, "y"))
	J.mc(Sc, "float", [x, y - 0.3, J.add(J.mc(tag, "slice", [0.0, 25.0]), "…") if J.len(tag) > 26 else tag, "#e8d8ff", 2.0])
	var Pa = _g("Pantry")
	if J.t(J.gp(o, "fx")) and Pa != null and not headless: J.mc(Pa, "fx", [J.gp(o, "fx"), n])   # 茶水間：對應嗰部機真係郁
	if J.t(J.gp(o, "trap")):
		J.sp(n, "fear", maxf(0.0, J.num(J.gp(n, "fear")) - 20)); J.sp(n, "combo", 0.0)
		J.mc(Sc, "bubble", [n, Lx(J.gp(o, "say")), 2.6])
		J.mc(Sc, "float", [x, y - 0.34, "反效果：" + _s(J.gp(o, "why")), "#ff9a8a", 2.0])
		return
	if J.t(J.gp(o, "warm")):
		J.sp(n, "fear", maxf(0.0, J.num(J.gp(n, "fear")) - 10))
		J.mc(Sc, "bubble", [n, Lx(J.gp(o, "say")), 2.8])
		J.mc(Sc, "addKarma", [d, 1.0, _s(J.gp(d, "name")) + "：" + _s(J.gp(o, "why"))])
		J.mc(Sc, "float", [x, y - 0.34, "陰德 +1", "#a8f0b0", 2.0])
		return
	var personal = J.t(J.gp(o, "need"))
	J.sp(Sc, "_src", null); J.sp(Sc, "_dl", 0.0); J.sp(Sc, "_vis", false)   # 隔空出手：冇人望到阿福
	J.mc(Sc, "hit", [n, J.gp(o, "type"), floor(J.num(J.gp(o, "base")) * (1.4 if personal else 1.0) + 0.5), J.gp(o, "tier"), null, true])
	if personal and not headless: J.mc(Sc, "float", [x, y - 0.38, "用上情報：正中要害", "#ffd84a", 1.8])
	if J.t(J.gp(o, "say")) and not J.t(J.mc(J.gp(d, "immune"), "includes", [J.gp(o, "type")])):
		var say = func(_t = null, _a = null):
			if J.t(J.gp(Sc, "active")) and not J.t(J.gp(n, "gone")):
				J.sp(n, "bubT", 0.0); J.mc(Sc, "bubble", [n, Lx(J.gp(o, "say")), 2.8])
			return null
		say.call()
		if not headless: J.F_setTimeout([say, 1100.0])   # 引擎嘅反應會遲一啲出，之後再蓋返針對呢招嘅對白

# ---------- 接駁 ----------
static func init_hooks() -> void:
	var Sc_ = _g("Scare")
	var ort = J.gp(Sc_, "renderTarget")
	J.sp(Sc_, "renderTarget", func(this_, a):
		var r = J.cl(ort, this_, a)
		var sel = J.gp(this_, "sel")
		var n = sel if (J.t(sel) and not J.t(J.gp(sel, "gone")) and not J.t(J.gp(sel, "fleeing"))) else null
		if not J.t(n): return r
		var who = _q("#sc-target .sc-who")
		if not J.t(who): return r
		for b in J.iter(J.mc(who, "querySelectorAll", ["#sc-peek,#sc-wa"])): J.mc(b, "remove", [])   # 舊嘅偷看／傳訊息由新手機取代
		var box = J.mc(_g("document"), "createElement", ["span"]); J.sp(box, "className", "so-btns"); J.sp(box, "innerHTML", buttons(this_, n))
		J.mc(who, "insertBefore", [box, J.mc(who, "querySelector", ["#sc-br"])])
		for b in J.iter(J.mc(box, "querySelectorAll", ["[data-op]"])):
			J.sp(b, "onclick", func(_t, _a):
				var k = J.gp(J.gp(b, "dataset"), "op")
				if J.seq(k, "phone"): open_phone(this_, n, null)
				elif J.seq(k, "pc"): open_pc(this_, n)
				else: open_pantry(this_, n)
				return null)
		J.sp(this_, "_opCtx", J.S_JSON_("stringify", [ctx(this_, n)]))
		return r)
	# 佢行開／坐低時，按鈕跟住變
	var ohud = J.gp(Sc_, "hud")
	J.sp(Sc_, "hud", func(this_, a):
		var r = J.cl(ohud, this_, a)
		var n = J.gp(this_, "sel")
		if J.t(n) and not J.t(J.gp(n, "gone")) and not J.t(J.gp(this_, "paused")) and not J.seq(J.S_JSON_("stringify", [ctx(this_, n)]), J.gp(this_, "_opCtx")): J.mc(this_, "renderTarget", [])
		return r)

static func boot(_t = null, _a = null):
	var Sc_ = _g("Scare")
	if Sc_ == null or not J.t(J.gp(Sc_, "renderTarget")): J.F_setTimeout([boot, 200.0]); return null
	init_hooks()
	return null

func run(_env) -> void:
	var D = JSON.parse_string(FileAccess.get_file_as_string("res://data/nat/scare_ops.json"))
	OPS = D.OPS; PANTRY = D.PANTRY; TAB = D.TAB; INTEL_NAME = D.INTEL_NAME
	var LANG = _g("LANG")
	if LANG != null and D.ZH.size(): J.mc(LANG, "add", [D.ZH])
	boot()
	J.G["ScareOps"] = {
		"TAB": TAB, "INTEL_NAME": INTEL_NAME, "OPS": OPS, "PANTRY": PANTRY,
		"cdOf": func(_t, a): return cd_of(J.arg(a, 0), J.arg(a, 1), J.arg(a, 2)),
		"close": func(_t, a): close(J.arg(a, 0)); return null,
		"ctx": func(_t, a): return ctx(J.arg(a, 0), J.arg(a, 1)),
		"openPhone": func(_t, a): open_phone(J.arg(a, 0), J.arg(a, 1), J.arg(a, 2)); return null,
		"openPC": func(_t, a): open_pc(J.arg(a, 0), J.arg(a, 1)); return null,
		"openPantry": func(_t, a): open_pantry(J.arg(a, 0), J.arg(a, 1)); return null,
		"compose": func(_t, a): compose(J.arg(a, 0), J.arg(a, 1)); return null,
		"act": func(_t, a): act(J.arg(a, 0), J.arg(a, 1), J.arg(a, 2), J.arg(a, 3)); return null,
		"intel": func(_t, a): return intel(J.arg(a, 0), J.arg(a, 1)),
	}
