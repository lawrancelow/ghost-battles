# 原生改寫自 chatter.js：碎碎念、雜鬼性格、雜鬼入村、鬼與鬼對話（劇本：CHAT_DATA）
# 存檔：S.chat = { u:{池:[用過嘅序號]}, arc:{笑話:進度}, c:{對話池:[用過]}, e:{類型:[用過嘅入村]}, ev:{事件:{t,n}} }；雜鬼性格存 g.arch
# 接駁同 JS 一樣：Village.pickChatter 換新版；包 Village.update、recruitFodder、joinGhost、Battle.finish、Theater.play；名冊加「性格」一行
# 隨機數用 randf()，次序同轉譯版（Math.random）一致，對照測試用同一個種子
extends RefCounted

const EV_LIFE := {"win": 180e3, "lose": 180e3, "new": 240e3, "boss": 300e3, "rival": 300e3, "hr": 300e3}
const EVENT_TAGS := ["win", "lose", "new", "boss", "rival", "hr"]
const CSS := "#gjoin{position:absolute;left:10px;right:10px;top:calc(env(safe-area-inset-top) + 8px);z-index:62;display:none;background:linear-gradient(#2a2133,#1b1522);border-radius:12px;box-shadow:0 8px 24px rgba(0,0,0,.6),inset 0 0 0 1.5px #6a5236;color:#f4e6c4;overflow:hidden;cursor:pointer}\n#gjoin.on{display:flex;animation:gjin .25s ease-out}@keyframes gjin{from{transform:translateY(-30px);opacity:0}to{transform:none;opacity:1}}\n#gjoin canvas{width:118px;height:118px;flex:0 0 118px;background:radial-gradient(circle at 50% 70%,#3d3247,#1d1724)}\n#gjoin .gj-b{flex:1;padding:9px 34px 9px 10px;display:flex;flex-direction:column;justify-content:center;min-height:118px;box-sizing:border-box}\n#gjoin .gj-t{font-size:12px;color:#d9b36a;font-weight:800;letter-spacing:1px;margin-bottom:3px}\n#gjoin .gj-w{font-size:13px;color:#ff9f8a;font-weight:800}\n#gjoin .gj-x{font-size:15.5px;line-height:1.45;font-weight:700}\n#gjoin .gj-x.narr{color:#cbbfe0;font-weight:600;font-size:14.5px}\n#gjoin .gj-k{position:absolute;right:6px;top:6px;width:26px;height:26px;border-radius:13px;background:rgba(0,0,0,.35);color:#f4e6c4;font-size:15px;line-height:26px;text-align:center}\n#gjoin .gj-n{position:absolute;right:10px;bottom:6px;font-size:11px;color:#9c8fae}"

static var D: Dictionary = {}
static var started := false
static var queue: Array = []
static var q_owner = null
static var enter_busy := false
static var recent: Array = []
static var hold_until := 0.0
static var ej = null
static var _re_en: RegEx = null

static func _g(n: String): return J.G.get(n)
static func _S(): return _g("S")
static func _has(n: String) -> bool: return J.G.has(n) and J.G[n] != null
static func zh() -> bool:
	var LANG = _g("LANG")
	return LANG == null or J.str(J.gp(LANG, "cur")) != "yue"
static func pick_t(y, z): return z if zh() else y
static func rnd(a):
	var n = J.len(a)
	var i = floor(randf() * n)
	return J.gp(a, i)
static func now() -> float: return J.num(J.S_Date_("now", []))
static func _hasnum(arr, i: int) -> bool:
	if not (arr is Array): return false
	for x in arr: if (x is float or x is int) and int(x) == i: return true
	return false
static func _idx(n: int) -> Array:
	var r = []
	for i in n: r.append(i)
	return r
static func _toast(msg: String) -> void:
	var Fx = _g("Fx")
	if Fx != null: J.mc(Fx, "toast", [msg])

static func st():
	var S = _S()
	if not J.t(S): return null
	if not J.t(J.gp(S, "chat")): J.sp(S, "chat", {})
	var c = J.gp(S, "chat")
	for k in ["u", "arc", "c", "e", "ev"]:
		if not J.t(J.gp(c, k)): J.sp(c, k, {})
	return c
static func seen(id: String) -> bool:
	var S = _S()
	return J.t(S) and J.t(J.gp(S, "seen")) and J.t(J.gp(J.gp(S, "seen"), id))
static func hash32(s: String) -> int:
	var h := 2166136261
	for i in s.length():
		h = (h ^ s.unicode_at(i)) & 0xFFFFFFFF
		h = (h * 16777619) & 0xFFFFFFFF
	return h
static func nick(g) -> String:
	var n = J.str(J.gp(g, "name")); var i = n.find("・")
	return n.substr(i + 1) if i >= 0 else n
static func is_fodder(g) -> bool:
	if not J.t(g): return false
	var q = J.str(J.gp(g, "q"))
	return (q == "藍" or q == "紫") and J.t(J.gp(D.arch, J.gp(g, "k")))

# ---------- 雜鬼性格 ----------
static func arch_of(g, fresh := false):
	if not is_fodder(g): return null
	var list: Array = D.arch[J.str(g.k)]
	var cur = J.gp(g, "arch")
	if J.t(cur):
		for a in list: if J.str(a.id) == J.str(cur): return a
	if _re_en == null: _re_en = RegEx.new(); _re_en.compile("[A-Za-z]")
	var en = _re_en.search(nick(g)) != null
	var enA = list.filter(func(a): return J.t(a.get("en")))
	var a
	if fresh:
		a = rnd(enA) if (en and enA.size() > 0 and randf() < 0.6) else rnd(list)
	else:
		var h = hash32(J.str(J.gp(g, "id")) + "|" + J.str(J.gp(g, "name")))
		a = enA[(h >> 3) % enA.size()] if (en and enA.size() > 0 and (h & 7) < 5) else list[(h >> 3) % list.size()]
	J.sp(g, "arch", a.id)
	return a
static func sample(g) -> String:
	var a = arch_of(g)
	if a == null: return ""
	var l = a.lines[0]
	return fill(pick_t(l[0], l[1]), g)

# ---------- 情境 ----------
static func ev_on(k: String) -> bool:
	var c = st(); var e = J.gp(J.gp(c, "ev"), k) if c != null else null
	return J.t(e) and now() - J.num(J.gp(e, "t")) < float(EV_LIFE[k])
static func mark(k: String, n = "") -> void:
	var c = st()
	if c != null: J.sp(c.ev, k, {"t": now(), "n": n if J.t(n) else ""})
static func hour() -> int: return int(J.num(J.mc(J.new_("Date", []), "getHours", [])))
static func tag_ok(tag, g) -> bool:
	if not J.t(tag): return true
	for t in J.str(tag).split(","):
		if t == "夜":
			var h = hour(); if not (h >= 23 or h < 4): return false
		elif t == "晨":
			var h = hour(); if not (h >= 5 and h < 9): return false
		elif t.begins_with("p:"):
			if not J.t(g) or J.str(J.gp(g, "post")) != t.substr(2) or J.gp(g, "post") == null: return false
		elif EVENT_TAGS.has(t):
			if not ev_on(t): return false
		elif t == "early":
			if seen("ch1_end"): return false
		elif t == "mid":
			if not seen("ch3_end"): return false
		elif t == "late":
			if not (J.t(J.gp(_S(), "ended")) or seen("ch6_end")): return false
		elif t.begins_with("arc:"):
			var p = t.split(":")
			var have = J.gp(st().arc, p[1])
			if (J.num(have) if J.t(have) else 0.0) + 1 != J.num(p[2]): return false
	return true
static func is_event(tag) -> bool:
	if not J.t(tag): return false
	for t in J.str(tag).split(","): if EVENT_TAGS.has(t): return true
	return false
static func is_ctx(tag) -> bool:
	if not J.t(tag): return false
	for t in J.str(tag).split(","): if t == "夜" or t == "晨" or t.begins_with("p:") or t.begins_with("arc:"): return true
	return false
static func fill(s, g) -> String:
	var c = st()
	var e = J.gp(J.gp(c, "ev"), "new") if c != null else null
	var nn = J.gp(e, "n") if J.t(e) else null
	if not J.t(nn): nn = "新同事"
	var who = (nick(g) if is_fodder(g) else J.str(J.gp(g, "name"))) if J.t(g) else ""
	return str(DB.N(J.str(s).replace("{N}", J.str(nn)).replace("{n}", who)))   # [qa54] 女主：碎碎念「少爺」都要換

# ---------- 揀一句 ----------
static func pool_of(g):
	if not J.t(g): return null
	var k = J.str(J.gp(g, "k"))
	if J.t(J.gp(D.named, k)) and not is_fodder(g): return {"key": "n:" + k, "lines": D.named[k]}
	var a = arch_of(g)
	if a != null: return {"key": "a:" + k + ":" + J.str(a.id), "lines": a.lines}
	return null
static func _l2(l): return l[2] if l is Array and l.size() > 2 else null
static func pick_from(pool, g):
	var c = st(); var key = J.str(pool.key)
	if not J.t(J.gp(c.u, key)): J.sp(c.u, key, [])
	var used = J.gp(c.u, key)
	var lines: Array = pool.lines
	var ok = _idx(lines.size()).filter(func(i): return not _hasnum(used, i) and tag_ok(_l2(lines[i]), g))
	if ok.is_empty():
		J.sp(c.u, key, [])
		for l in lines:
			var tg = _l2(l)
			if J.t(tg):
				for t in J.str(tg).split(","): if t.begins_with("arc:"): J.sp(c.arc, t.split(":")[1], 0.0)
		ok = _idx(lines.size()).filter(func(i): return tag_ok(_l2(lines[i]), g))
		if ok.is_empty(): return null
	var ev = ok.filter(func(i): return is_event(_l2(lines[i])))
	var cx = ok.filter(func(i): return is_ctx(_l2(lines[i])))
	var i
	if ev.size() > 0 and randf() < 0.7: i = rnd(ev)
	elif cx.size() > 0 and randf() < 0.4: i = rnd(cx)
	else: i = rnd(ok)
	J.mc(J.gp(c.u, key), "push", [float(i)])
	var l = lines[i]
	var tg2 = _l2(l)
	if J.t(tg2):
		for t in J.str(tg2).split(","):
			if t.begins_with("arc:"): var p = t.split(":"); J.sp(c.arc, p[1], J.num(p[2]))
	return fill(pick_t(l[0], l[1]), g)
static func line_for(g):
	var p = pool_of(g)
	return pick_from(p, g) if p != null else null

# ---------- 鬼與鬼對話 ----------
static func feud_of(a, b):
	var BF = _g("BOND_FEUDS"); var S = _S()
	if BF == null or not J.t(J.gp(S, "bonds")): return null
	var ak = J.str(J.gp(a, "k")); var bk = J.str(J.gp(b, "k"))
	for F in J.iter(BF):
		var ab = J.str(J.gp(F, "a")) == ak and J.str(J.gp(F, "b")) == bk
		var ba = J.str(J.gp(F, "a")) == bk and J.str(J.gp(F, "b")) == ak
		if not ab and not ba: continue
		var fe = J.gp(J.gp(S, "bonds"), "feud")
		var f = J.gp(fe, J.gp(F, "id")) if J.t(fe) else null
		if not J.t(f) or not J.t(J.gp(f, "st")): return null
		var en = J.gp(f, "end")
		return {"F": F, "state": en if J.t(en) else "fight", "A": a if ab else b, "B": b if ab else a}
	return null
static func take_conv(key: String, list: Array, okf = null):
	var c = st()
	if not J.t(J.gp(c.c, key)): J.sp(c.c, key, [])
	var used = J.gp(c.c, key)
	var idx = _idx(list.size()).filter(func(i): return not _hasnum(used, i) and (okf == null or okf.call(list[i])))
	if idx.is_empty():
		J.sp(c.c, key, [])
		idx = _idx(list.size()).filter(func(i): return okf == null or okf.call(list[i]))
	if idx.is_empty(): return null
	var i = rnd(idx)
	J.mc(J.gp(c.c, key), "push", [float(i)])
	return list[i]
static func conv_for(a, b):
	var fd = feud_of(a, b)
	if fd != null:
		var key = J.str(J.gp(fd.F, "id")) + ":" + J.str(fd.state)
		var list = D.feud.get(key)
		if J.t(list) and randf() < 0.85:
			var cv = take_conv("f:" + key, list)
			if cv != null: return {"cv": cv, "A": fd.A, "B": fd.B}
	var ak = J.str(J.gp(a, "k")); var bk = J.str(J.gp(b, "k"))
	var pairs = D.pair.filter(func(p): return (J.str(p.a) == ak and J.str(p.b) == bk) or (J.str(p.a) == bk and J.str(p.b) == ak))
	if pairs.size() > 0 and randf() < 0.7 and not is_fodder(a) and not is_fodder(b):
		var ks = [ak, bk]; ks.sort()
		var cv = take_conv("p:" + "+".join(ks), pairs)
		if cv != null: return {"cv": cv, "A": a if J.str(cv.a) == ak else b, "B": b if J.str(cv.a) == ak else a}
	var cv2 = take_conv("g", D.gen, func(x): return tag_ok(x.get("tag"), null))
	return {"cv": cv2, "A": a, "B": b} if cv2 != null else null
static func start_conv(r) -> void:
	var V = _g("Village")
	var nA = J.str(J.gp(r.A, "name")); var nB = J.str(J.gp(r.B, "name"))
	queue = []
	for l in r.cv.lines:
		var w = J.str(l[0])
		queue.append({"who": l[0], "text": fill(pick_t(l[1], l[2]), null).replace("{A}", nA).replace("{B}", nB), "g": r.A if w == "A" else (r.B if w == "B" else null)})
	q_owner = r
	next_line(V)
static func next_line(V) -> void:
	if queue.is_empty(): q_owner = null; return
	var it = queue.pop_front()
	if it.g == null:   # 旁白：浮字
		var v = null
		for o in J.iter(J.gp(V, "vis")):
			if J.t(J.gp(o, "g")) and q_owner != null and J.seq(J.gp(J.gp(o, "g"), "id"), J.gp(q_owner.A, "id")): v = o; break
		var Fx = _g("Fx")
		if Fx != null: J.mc(Fx, "float", [J.gp(v, "x") if v != null else 195.0, J.num(J.gp(v, "y")) - 90 if v != null else 400.0, it.text, "#d9ccff"])
		hold_until = now() + 1800
		return
	J.sp(V, "bubble", {"id": J.gp(it.g, "id"), "hero": false, "text": it.text, "t": 0.9})

# ---------- 取代村民碎碎念（this = Village） ----------
static func _sort_pairs(pairs: Array) -> void:
	# 同 JS Array.sort 一樣穩定：同分就保留原本次序
	for i in pairs.size(): pairs[i].append(i)
	pairs.sort_custom(func(x, y):
		var fx = 1 if feud_of(x[0], x[1]) != null else 0
		var fy = 1 if feud_of(y[0], y[1]) != null else 0
		var d = (fy - fx) if fy != fx else (x[2] - y[2])
		if d == 0: return x[3] < y[3]
		return d < 0)
	for p in pairs: p.pop_back()
static func pick_chatter(V) -> void:
	if not queue.is_empty() or now() < hold_until: return
	var camY = J.num(J.gp(V, "camY"))
	var top = camY + 60; var bot = camY + J.num(J.gp(V, "h")) / J.num(J.gp(V, "scale")) - 20
	if J.t(J.mc(_g("Story"), "busy", [])) or J.t(J.mc(_g("UI"), "modalOpen", [])): return
	var S = _S()
	var cand = []
	for v in J.iter(J.gp(V, "vis")):
		var y = J.num(J.gp(v, "y")); var g = J.gp(v, "g")
		if y > top + 120 and y < bot and J.t(g) and pool_of(g) != null and (not J.t(J.gp(v, "hero")) or J.num(J.gp(S, "qi")) > 3): cand.append(v)
	if cand.is_empty(): return
	if randf() < 0.38:
		var np = cand.filter(func(v): return not J.t(J.gp(v, "hero")))
		var pairs = []
		for i in np.size():
			for j in range(i + 1, np.size()):
				var d = J.hypot_([J.num(J.gp(np[i], "x")) - J.num(J.gp(np[j], "x")), J.num(J.gp(np[i], "y")) - J.num(J.gp(np[j], "y"))])
				if d < 130 and not J.seq(J.gp(np[i].g, "id"), J.gp(np[j].g, "id")): pairs.append([np[i].g, np[j].g, d])
		if pairs.size() > 0:
			_sort_pairs(pairs)
			var p = pairs[0] if randf() < 0.6 else rnd(pairs)
			var r = conv_for(p[0], p[1])
			if r != null:
				start_conv(r); J.sp(V, "chatT", 9 + randf() * 5); return
	var v = rnd(cand); var line = line_for(J.gp(v, "g"))
	if not J.t(line): return
	J.sp(V, "bubble", {"id": J.gp(J.gp(v, "g"), "id"), "hero": J.t(J.gp(v, "hero")), "text": line, "t": 0.0})

# ---------- 雜鬼入村 ----------
static func _arch_ok(e, a) -> bool:
	var ar = e.get("arch")
	return not J.t(ar) or (a != null and ar.has(a.id))
static func enter_for(g):
	var k = J.str(J.gp(g, "k"))
	var list = D.enter.get(k)
	if not J.t(list): return null
	var a = arch_of(g)
	var c = st()
	if not J.t(J.gp(c.e, k)): J.sp(c.e, k, [])
	var used = J.gp(c.e, k)
	var idx = _idx(list.size()).filter(func(i): return not _hasnum(used, i) and _arch_ok(list[i], a))
	if idx.is_empty():
		J.sp(c.e, k, [])
		idx = _idx(list.size()).filter(func(i): return _arch_ok(list[i], a))
	var mine = idx.filter(func(i): return J.t(list[i].get("arch")))
	var i = rnd(mine) if (mine.size() > 0 and randf() < 0.55) else rnd(idx)
	J.mc(J.gp(c.e, k), "push", [float(i)])
	return list[i]
static func _doc(m: String, a: Array): return J.S_document_(m, a)
static func css() -> void:
	if J.t(_doc("getElementById", ["gjoin-css"])): return
	var s = _doc("createElement", ["style"]); J.sp(s, "id", "gjoin-css")
	J.sp(s, "textContent", CSS)
	J.mc(J.gp(_g("document"), "head"), "appendChild", [s])
static func _q(el, sel: String): return J.mc(el, "querySelector", [sel])
static func play_enter(g, e) -> void:
	css()
	var el = _doc("getElementById", ["gjoin"])
	if not J.t(el):
		el = _doc("createElement", ["div"]); J.sp(el, "id", "gjoin")
		J.sp(el, "innerHTML", "<canvas></canvas><div class=\"gj-b\"><div class=\"gj-t\"></div><div class=\"gj-w\"></div><div class=\"gj-x\"></div></div><div class=\"gj-k\">✕</div><div class=\"gj-n\"></div>")
		var app = _doc("getElementById", ["app"])
		J.mc(app if J.t(app) else J.gp(_g("document"), "body"), "appendChild", [el])
	var cv = _q(el, "canvas")
	var dp = J.gp(_g("window"), "devicePixelRatio")
	var dpr = minf(2.0, J.num(dp) if J.t(dp) else 1.0)
	J.sp(cv, "width", 118 * dpr); J.sp(cv, "height", 118 * dpr)
	var a = arch_of(g)
	J.sp(_q(el, ".gj-t"), "textContent", "新鬼入村・" + J.str(J.gp(g, "name")) + (("（" + J.str(a.label) + "）") if a != null else ""))
	var lines = []
	for l in e.lines: lines.append({"who": l[0], "text": fill(pick_t(l[1], l[2]), g)})
	ej = {"g": g, "e": e, "lines": lines, "i": -1, "t": 0.0, "lt": 0.0, "el": el, "cv": cv, "dpr": dpr, "raf": 0.0, "last": J.num(J.S_performance_("now", []))}
	enter_busy = true; J.sp(el, "className", "on")
	_adv()
	J.sp(el, "onclick", func(_t, aa):
		var ev = J.arg(aa, 0)
		J.mc(ev, "stopPropagation", [])
		if J.t(J.mc(J.gp(J.gp(ev, "target"), "classList"), "contains", ["gj-k"])): close_enter(); return null
		_adv(); return null)
	ej.raf = J.F_requestAnimationFrame([func(_t, aa): _loop(J.arg(aa, 0)); return null])
static func _adv() -> void:
	if ej == null: return
	ej.i += 1; ej.lt = 0.0
	if ej.i >= ej.lines.size(): close_enter(); return
	var l = ej.lines[ej.i]; var el = ej.el; var who = J.str(l.who)
	J.sp(_q(el, ".gj-w"), "textContent", "" if who == "旁白" else (J.str(J.gp(ej.g, "name")) if who == "G" else who))
	var x = _q(el, ".gj-x")
	J.sp(x, "className", "gj-x" + (" narr" if who == "旁白" else ""))
	J.sp(x, "textContent", l.text)
	J.sp(_q(el, ".gj-n"), "textContent", str(ej.i + 1) + "／" + str(ej.lines.size()))
static func _loop(tm) -> void:
	if ej == null: return
	var dt = minf(0.05, (J.num(tm) - ej.last) / 1000.0); ej.last = J.num(tm)
	ej.t += dt; ej.lt += dt
	draw_enter()
	if ej != null and ej.lt > maxf(2.6, J.str(ej.lines[ej.i].text).length() * 0.11): _adv()
	if ej != null: ej.raf = J.F_requestAnimationFrame([func(_t, aa): _loop(J.arg(aa, 0)); return null])
static func close_enter() -> void:
	if ej == null: return
	J.F_cancelAnimationFrame([ej.raf]); J.sp(ej.el, "className", ""); ej = null; enter_busy = false
static func draw_enter() -> void:
	var cv = ej.cv; var dpr: float = ej.dpr; var g = ej.g; var e = ej.e; var t: float = ej.t
	var ctx = J.mc(cv, "getContext", ["2d"])
	var W := 118.0; var H := 118.0
	var PL = _g("PlazaLife"); var SC = J.num(J.gp(PL, "SC")) if PL != null else 0.58
	J.mc(ctx, "setTransform", [dpr, 0.0, 0.0, dpr, 0.0, 0.0]); J.mc(ctx, "clearRect", [0.0, 0.0, W, H])
	J.sp(ctx, "fillStyle", "rgba(0,0,0,.35)"); J.mc(ctx, "beginPath", []); J.mc(ctx, "ellipse", [W / 2, H - 14, 26.0, 6.0, 0.0, 0.0, PI * 2]); J.mc(ctx, "fill", [])
	var ART = _g("ART"); var chh = J.gp(J.gp(ART, "CHAR_H"), J.gp(g, "k")) if ART != null and J.t(J.gp(ART, "CHAR_H")) else null
	var ch = (J.num(chh) if J.t(chh) else 56.0) * SC; var K = 78.0 / ch
	var mo = J.str(e.get("mo")); var enterP = minf(1.0, t / 0.9); var ease = 1 - pow(1 - enterP, 3)
	var x = W / 2; var y = H - 14; var rot = 0.0; var alpha = 1.0; var walk = enterP < 1; var flip = false
	if mo == "fall": y = -10 + (H - 4) * ease; rot = t * 9 if enterP < 1 else 0.0
	elif mo == "wind": x = -30 + (W / 2 + 30) * ease; y = H - 14 - sin(t * 3) * 6 * (1 - enterP * 0.5); rot = sin(t * 4) * 0.25
	elif mo == "rise" or mo == "pop": y = H + 70 - 84 * ease
	elif mo == "fast":
		var p = minf(1.0, t / 0.5); x = -40 + (W / 2 + 70) * p - (maxf(0.0, 30 - (t - 0.5) * 60) if p >= 1 else 0.0)
	elif mo == "float": x = -30 + (W / 2 + 30) * ease; y = H - 18 - sin(t * 2.2) * 4; alpha = 0.85
	else: x = -30 + (W / 2 + 30) * ease
	if mo in ["hop", "crash", "row", "bow", "blind", "resume", "dance"]:
		y -= absf(sin(t * 6)) * (12.0 if (enterP < 1 or mo == "dance") else 3.0); walk = false
	if mo == "crash" and t > 0.9 and t < 1.3:
		x += sin(t * 80) * 3
		if t < 1.25: J.sp(ctx, "fillStyle", "#ffe9a8"); J.sp(ctx, "font", "900 18px sans-serif"); J.mc(ctx, "fillText", ["咚！", W / 2 + 8, 26.0])
	if mo == "bow" and t > 1.1: rot = minf(0.9, (t - 1.1) * 2)
	if mo == "dance": rot = sin(t * 5) * 0.2; flip = sin(t * 2.5) > 0
	if mo == "grab" and t < 1.2:
		var gx = W * (t / 1.2) * 1.4
		J.sp(ctx, "fillStyle", "#4caf50"); J.mc(ctx, "fillRect", [gx - 70, H - 32, 52.0, 18.0])
		J.sp(ctx, "fillStyle", "#222"); J.mc(ctx, "beginPath", []); J.mc(ctx, "arc", [gx - 58, H - 13, 5.0, 0.0, 7.0]); J.mc(ctx, "arc", [gx - 28, H - 13, 5.0, 0.0, 7.0]); J.mc(ctx, "fill", [])
	var draw = func(dx: float, a2: float):
		J.mc(ctx, "save", []); J.mc(ctx, "setTransform", [dpr * K, 0.0, 0.0, dpr * K, 0.0, 0.0]); J.sp(ctx, "globalAlpha", alpha * a2)
		var px = (x + dx) / K; var py = y / K
		J.mc(ctx, "translate", [px, py]); J.mc(ctx, "rotate", [rot]); J.mc(ctx, "translate", [-px, -py])
		if ART != null: J.mc(ART, "drawChar", [ctx, J.gp(g, "k"), px, py, SC, {"t": t * 1.3, "walk": walk, "flip": flip, "tamed": true, "untied": true, "act": "plaza_sniff" if mo == "sniff" else null, "at": t}])
		J.mc(ctx, "restore", [])
	if mo == "row" and t < 2.2: draw.call(-34.0, 0.55); draw.call(34.0, 0.55)
	draw.call(0.0, 1.0)
	if mo == "drip" or mo == "rise":
		J.sp(ctx, "fillStyle", "rgba(150,200,255,.8)")
		for i in 3: J.mc(ctx, "fillRect", [x - 10 + i * 9, (H - 60) + fmod(t * 40 + i * 17, 40.0), 2.0, 4.0])
	if mo == "blind": J.sp(ctx, "fillStyle", "#ffe9a8"); J.sp(ctx, "font", "900 12px sans-serif"); J.mc(ctx, "fillText", ["？", x + 18, y - 70 + sin(t * 3) * 3])
	if mo == "resume" and t > 0.9:
		J.sp(ctx, "fillStyle", "#f4ecd6"); J.mc(ctx, "fillRect", [x + 16, y - 52, 16.0, 20.0]); J.sp(ctx, "strokeStyle", "#8a7a5a"); J.mc(ctx, "strokeRect", [x + 16, y - 52, 16.0, 20.0])
static func on_recruit(g) -> void:
	if not J.t(g) or not is_fodder(g): return
	arch_of(g, true); mark("new", J.gp(g, "name"))
	var t = now()
	recent = recent.filter(func(x): return t - x < 15000); recent.append(t)
	var e = enter_for(g)
	if e == null: return
	var B = _g("Battle"); var Th = _g("Theater")
	var busy = enter_busy or recent.size() >= 3 or (B != null and J.t(J.gp(B, "active"))) or (Th != null and J.t(J.gp(Th, "on")))
	if busy:
		var s
		if J.t(e.get("toast")): s = pick_t(e.toast[0], e.toast[1])
		else:
			var last = e.lines[e.lines.size() - 1] if e.lines.size() > 0 else []
			s = last[2] if last.size() > 2 else null
		if s != null: _toast("<b>" + J.str(J.gp(g, "name")) + "</b>：" + fill(s, g))
		return
	J.F_setTimeout([func(_t, _a): play_enter(g, e); return null, 250.0])

# ---------- 名冊：性格 ----------
static func paint_roster() -> void:
	var sh = _doc("querySelector", ["#sheet"]); var S = _S()
	if not J.t(sh) or not J.t(S): return
	for c in J.iter(J.mc(sh, "querySelectorAll", [".gcard"])):
		if J.t(_q(c, ".archln")): continue
		var up = _q(c, "[data-up],[data-rel]"); var main = _q(c, ".gc-main")
		if not J.t(main): continue
		var g = null
		var id = null
		if J.t(up):
			var ds = J.gp(up, "dataset"); id = J.gp(ds, "up")
			if not J.t(id): id = J.gp(ds, "rel")
		if J.t(id):
			for x in J.iter(J.gp(S, "ghosts")): if J.seq(J.gp(x, "id"), id): g = x; break
		if g == null:
			var nm = _q(main, "b")
			if J.t(nm):
				for x in J.iter(J.gp(S, "ghosts")): if J.seq(J.gp(x, "name"), J.gp(nm, "textContent")): g = x; break
		if not is_fodder(g): continue
		var a = arch_of(g)
		var el = _doc("createElement", ["small"]); J.sp(el, "className", "tr archln"); J.sp(J.gp(el, "style"), "color", "#7a4a9a")
		J.sp(el, "textContent", "性格：" + J.str(a.label) + "　「" + sample(g) + "」")
		J.mc(main, "appendChild", [el])

# ---------- 接駁 ----------
static func init() -> void:
	if started: return
	started = true
	var V = _g("Village")
	if V != null:
		J.sp(V, "pickChatter", func(this_, _a): pick_chatter(this_); return null)
		var ou = J.gp(V, "update")
		if ou != null:
			J.sp(V, "update", func(this_, a):
				var r = J.cl(ou, this_, a)
				if not queue.is_empty() and not J.t(J.gp(this_, "bubble")) and now() >= hold_until: next_line(this_)
				return r)
	var w = _g("window")
	var WG = J.gp(w, "G") if w != null else null
	if _has("recruitFodder"):
		var orf = J.G["recruitFodder"]
		J.G["recruitFodder"] = func(this_, a):
			var g = J.cl(orf, this_, a)
			on_recruit(g)
			return g
		if J.t(WG) and J.t(J.gp(WG, "recruitFodder")): J.sp(WG, "recruitFodder", J.G["recruitFodder"])
	if _has("joinGhost"):
		var oj = J.G["joinGhost"]
		J.G["joinGhost"] = func(this_, a):
			var k = J.arg(a, 0)
			var had = _owns(k)
			var r = J.cl(oj, this_, a)
			if not had and _owns(k):
				var GH = _g("GHOSTS"); var gd = J.gp(GH, k) if GH != null else null
				mark("new", J.gp(gd, "name") if J.t(gd) else k)
			return r
		if J.t(WG) and J.t(J.gp(WG, "joinGhost")): J.sp(WG, "joinGhost", J.G["joinGhost"])
	var B = _g("Battle")
	if B != null and J.t(J.gp(B, "finish")):
		var of_ = J.gp(B, "finish")
		J.sp(B, "finish", func(this_, a):
			if not J.t(J.gp(this_, "result")): mark("win" if J.t(J.arg(a, 0)) else "lose")
			return J.cl(of_, this_, a))
	var Th = _g("Theater")
	if Th != null and J.t(J.gp(Th, "play")):
		var op = J.gp(Th, "play")
		J.sp(Th, "play", func(this_, a):
			var sc = J.arg(a, 0); var cast = J.gp(sc, "cast") if J.t(sc) else null
			var n = []
			if J.t(cast): for c in J.iter(cast): n.append(J.str(J.gp(c, 0.0)))
			if n.has("龐總"): mark("boss")
			if n.has("Bryan"): mark("rival")
			if n.has("冼小姐"): mark("hr")
			return J.cl(op, this_, a))
	var S = _S()
	if J.t(S): for g in J.iter(J.gp(S, "ghosts")): if is_fodder(g): arch_of(g)   # 舊存檔：補性格
	var sh = _doc("querySelector", ["#sheet"])
	if J.t(sh) and _g("MutationObserver") != null:
		var mo = J.new_("MutationObserver", [func(_t, _a):
			if J.t(J.mc(sh, "querySelector", [".gcard"])): paint_roster()
			return null])
		J.mc(mo, "observe", [sh, {"childList": true, "subtree": true}])
static func _owns(k) -> bool:
	for g in J.iter(J.gp(_S(), "ghosts")): if J.seq(J.gp(g, "k"), k): return true
	return false

static func _boot() -> void:
	if not J.t(_S()) or _g("Village") == null or not J.t(_doc("querySelector", ["#sheet"])):
		J.F_setTimeout([func(_t, _a): _boot(); return null, 300.0]); return
	init()

func run(_env) -> void:
	var cd = _g("CHAT_DATA")
	D = cd if cd is Dictionary else {}
	started = false; queue = []; q_owner = null; enter_busy = false; recent = []; hold_until = 0.0; ej = null
	var demo = {
		"lineFor": func(_t, a): return line_for(J.arg(a, 0)),
		"convFor": func(_t, a): return conv_for(J.arg(a, 0), J.arg(a, 1)),
		"startConv": func(_t, a): var r = conv_for(J.arg(a, 0), J.arg(a, 1)); if r != null: start_conv(r); return r,
		"playEnter": func(_t, a): play_enter(J.arg(a, 0), J.arg(a, 1)); return null,
		"enterFor": func(_t, a): return enter_for(J.arg(a, 0)),
		"onRecruit": func(_t, a): on_recruit(J.arg(a, 0)); return null,
		"mark": func(_t, a): mark(J.str(J.arg(a, 0)), J.arg(a, 1)); return null,
	}
	J.G["Chatter"] = {
		"st": func(_t, _a): return st(),
		"init": func(_t, _a): init(); return null,
		"archOf": func(_t, a): return arch_of(J.arg(a, 0), J.t(J.arg(a, 1))),
		"sample": func(_t, a): return sample(J.arg(a, 0)),
		"lineFor": func(_t, a): return line_for(J.arg(a, 0)),
		"poolOf": func(_t, a): return pool_of(J.arg(a, 0)),
		"pickFrom": func(_t, a): return pick_from(J.arg(a, 0), J.arg(a, 1)),
		"tagOk": func(_t, a): return tag_ok(J.arg(a, 0), J.arg(a, 1)),
		"convFor": func(_t, a): return conv_for(J.arg(a, 0), J.arg(a, 1)),
		"enterFor": func(_t, a): return enter_for(J.arg(a, 0)),
		"onRecruit": func(_t, a): on_recruit(J.arg(a, 0)); return null,
		"demo": demo,
		"close": func(_t, _a): close_enter(); return null,
		"__getters": {"busy": func(_t, _a): return enter_busy},
	}
	_boot()
