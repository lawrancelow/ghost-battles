# 原生改寫自 standup.js：冥街夜市棟篤笑（SU_BITS＋引擎）＋主線串場（XO）
# 資料：data/nat/standup.json（由網頁原碼抽出，品牌名已換；XO_AFTER 加咗 epilogue → c6_after）
# 接駁同 JS 一樣：包 Story.queue（串場）、GhostStreet.mul／renderPanel、UI.openStory；每 4 秒喺村裡預告新節目
extends RefCounted

const FILL := ["egui", "youhun", "zombie", "shuigui", "zhiren", "xiaozhi"]
const NAMES := {"egui": "餓鬼", "youhun": "遊魂阿強", "zombie": "殭屍兵", "shuigui": "水鬼", "zhiren": "紙人偶", "xiaozhi": "小紙", "n30_xiaosi": "笑死鬼"}
const KEY := {"笑死鬼": "n30_xiaosi", "遊魂阿強": "youhun", "孤寒鬼": "n30_guhangui", "天花姐": "tianhua", "窮鬼": "n30_qionggui", "牛頭": "niutou"}

static var BITS: Array = []
static var XO_SCENES: Dictionary = {}
static var XO_AFTER: Dictionary = {}
static var XO_SPEAKERS: Dictionary = {}

static func _g(n: String): return J.G.get(n)
static func _S(): return _g("S")
static func _L(s): return J.cl(_g("L"), null, [s]) if _g("L") != null else s
static func _snd(n: String) -> void:
	var Sd = _g("Sound")
	if Sd != null and J.t(J.gp(Sd, "play")): J.mc(Sd, "play", [n])
static func _doc(m: String, a: Array): return J.S_document_(m, a)
static func _save() -> void:
	var f = _g("save")
	if f != null: J.cl(f, null, [])

static func st():
	var S = _S()
	if not J.t(S): return null
	if not J.t(J.gp(S, "su")): J.sp(S, "su", {})
	var s = J.gp(S, "su")
	if not J.t(J.gp(s, "seen")): J.sp(s, "seen", {})
	if not J.t(J.gp(s, "ann")): J.sp(s, "ann", {})
	if not J.t(J.gp(s, "buff")): J.sp(s, "buff", 0.0)
	return s
static func art(k) -> bool:
	var f = _g("sprOk")
	return f == null or J.t(J.cl(f, null, [k]))
static func ok(b) -> bool:
	var S = _S()
	if not J.t(S): return false
	var need = b.get("need")
	return (not J.t(need) or J.t(J.gp(J.gp(S, "seen"), need))) and art(b.k)

static func audience(b) -> Array:
	var list = []; var used = {J.str(b.k): true}
	var add = func(name, k):
		if used.has(J.str(k)) or not art(k) or list.size() >= 5: return
		used[J.str(k)] = true; list.append([name, k])
	for l in b.lines:   # 有喝倒彩嘅一定坐喺台下
		if l.size() > 1 and l[1] is Dictionary: add.call(l[1].h, KEY.get(J.str(l[1].h), "youhun"))
	add.call("笑死鬼", "n30_xiaosi")
	for k in FILL: add.call(NAMES[k], k)
	if list.size() >= 3:   # 喝倒彩嗰個唔好坐最邊
		var h = list.pop_front(); list.insert(int(floor(list.size() / 2.0)), h)
	return list

static func beats(b) -> Array:
	var out = []
	for l in b.lines:
		var text = l[0]; var re = l[1] if l.size() > 1 else null; var act = l[2] if l.size() > 2 else null
		if re is Dictionary:
			out.append({"who": b.who, "text": text, "act": act if J.t(act) else null, "react": "l"})
			out.append({"who": re.h, "text": re.t, "react": "h"})
			out.append({"who": b.who, "text": re.back, "react": re.r if J.t(re.get("r")) else "L"})
		else: out.append({"who": b.who, "text": text, "act": act if J.t(act) else null, "react": re if J.t(re) else null})
	out.append({"who": "旁白", "text": b.end, "react": "E"})
	return out

# 台下反應：大笑、細笑、拍手、冷場
static func react(code) -> void:
	var Th = _g("Theater")
	var A: Array = J.iter(J.mc(Th, "aud", []))
	var sz = J.mc(Th, "size", []); var W = J.num(J.gp(sz, "W")); var H = J.num(J.gp(sz, "H"))
	var Lo = J.mc(Th, "layout", [])
	if not J.t(Lo): return
	var top = H - J.num(J.gp(Lo, "ch")) * 0.78 * 0.95
	var laugh = func(a):
		var xs = J.str(J.gp(a, "k")) == "n30_xiaosi"
		J.mc(Th, "act", [a, "n30:laugh" if xs else "laugh", 2.4 if xs else 0.0])
	var c = J.str(code)
	if c == "L" or c == "E":
		for i in A.size():
			var a = A[i]
			J.F_setTimeout([func(_t, _a): laugh.call(a); return null, float(i * 90)])
		var side = 0.3 if randf() < 0.5 else 0.7
		var msg = "好嘢！再嚟！" if c == "E" else ["哈哈哈哈！", "笑死我！", "哈哈哈！"][int(floor(randf() * 3))]
		J.mc(Th, "float", [W * side, top - 34, msg, "#ffcf6a" if c == "E" else "#ffe9a8", 30.0 if c == "E" else 24.0, 1.4])
		if c == "E": J.mc(Th, "joss", [30.0]); _snd("gong")
		else: _snd("praise")
	elif c == "l":
		var B = A.duplicate(); B.shuffle()   # JS 用 sort(() => Math.random() - 0.5)：隨機揀兩隻
		for a in B.slice(0, 2): laugh.call(a)
	elif c == "c":
		for a in A: J.mc(Th, "act", [a, "wave"])
		J.mc(Th, "float", [W / 2, top - 30, "啪啪啪啪", "#ffe9a8", 22.0])
	elif c == "?":
		J.mc(Th, "float", [W / 2, top - 30, "……", "#c8c0d8", 26.0])
		for a in A:
			if J.str(J.gp(a, "k")) == "n30_xiaosi":
				laugh.call(a); J.mc(Th, "float", [J.gp(a, "px"), top - 60, "（只有他在笑）", "#ffe9a8", 16.0, 1.8]); break

static func find_bit(id):
	if id is Dictionary: return id
	for b in BITS: if J.str(b.id) == J.str(id): return b
	return null

static func play(id, opt = null) -> bool:
	var b = find_bit(id)
	if b == null: return false
	var o = opt if opt is Dictionary else {}
	var s = st(); var first = s != null and not J.t(J.gp(J.gp(s, "seen"), b.id))
	var sc = {"mode": "standup", "tag": "棟篤笑", "title": J.str(b.who) + "《" + J.str(_L(b.title)) + "》", "bg": "street", "banner": "棟篤笑・今晚開咪",
		"cast": [[b.who, b.k, {"face": false}]], "aud": audience(b), "lines": beats(b), "react": func(_t, a): react(J.arg(a, 0)); return null}
	J.mc(_g("Theater"), "play", [sc, func(_t, a):
		var res = J.arg(a, 0)
		if s == null or J.t(J.gp(res, "skipped")):
			_save()
			if J.t(o.get("after")): J.cl(o.after, null, [])
			return null
		J.sp(J.gp(s, "seen"), b.id, 1.0); J.sp(s, "buff", J.num(J.S_Date_("now", [])) + 10 * 60 * 1000)
		var msg = "笑到肚痛：村民工作速度 +10%（10 分鐘）"
		if first and not J.t(o.get("replay")):
			var r = J.cl(_g("give"), null, [{"coins": J.cl(_g("rwd"), null, [40.0])}])
			msg = J.str(r) + "<br>" + msg
		J.mc(_g("Fx"), "toast", ["棟篤笑：<b>" + msg + "</b>"])
		_save(); var UI = _g("UI"); if UI != null: J.mc(UI, "refresh", [])
		if J.t(o.get("after")): J.cl(o.after, null, [])
		return null])
	return true

static func _new_count(s) -> int:
	var n = 0
	for b in BITS: if ok(b) and not J.t(J.gp(J.gp(s, "seen"), b.id)): n += 1
	return n

# ---------- 揀邊段 ----------
static func open_picker(on_close = null) -> void:
	var el = _doc("getElementById", ["su-pick"])
	if not J.t(el):
		el = _doc("createElement", ["section"]); J.sp(el, "id", "su-pick")
		var app = _doc("getElementById", ["app"])
		J.mc(app if J.t(app) else J.gp(_g("document"), "body"), "appendChild", [el])
	var s = st()
	if s == null: s = {"seen": {}}
	var n = _new_count(s)
	var items = ""
	for b in BITS:
		var o = ok(b); var sn = J.t(J.gp(J.gp(s, "seen"), b.id))
		items += "<button class=\"sp-it %s\" data-id=\"%s\" %s><canvas data-k=\"%s\" width=\"112\" height=\"112\"></canvas><span><b>%s</b><small>%s</small></span>%s</button>" % [
			"" if o else "off", J.str(b.id), "" if o else "disabled", J.str(b.k) if o else "",
			(J.str(b.who) + "《" + J.str(_L(b.title)) + "》") if o else "？？？",
			("改編自 " + J.str(b.src)) if o else ("解鎖：" + J.str(b.hint)),
			"<em>新</em>" if (o and not sn) else ""]
	J.sp(el, "innerHTML", "<div class=\"sp-h\"><b>冥街夜市・棟篤笑</b><button class=\"btn sm\" id=\"sp-x\">離開</button></div>\n      <p class=\"sp-sub\">夜市盡頭有個小舞台，村裡的鬼輪流上台。看完會「笑到肚痛」：村民工作速度 +10%，持續 10 分鐘。第一次看另有冥幣。" + (("<br>今晚有 <b>%d</b> 段還沒看。" % n) if n > 0 else "") + "</p>\n      <div class=\"sp-list\">" + items + "</div>")
	J.mc(J.gp(el, "classList"), "add", ["on"])
	for c in J.iter(J.mc(el, "querySelectorAll", ["canvas[data-k]"])):
		var k = J.gp(J.gp(c, "dataset"), "k")
		if not J.t(k): continue
		var ART = _g("ART")
		if ART == null: continue
		var p = J.mc(ART, "portrait", [k, 56.0, {"tamed": true, "untied": true}])
		if not J.t(p): continue
		J.sp(c, "width", J.gp(p, "width")); J.sp(c, "height", J.gp(p, "height"))
		J.mc(J.mc(c, "getContext", ["2d"]), "drawImage", [p, 0.0, 0.0])
	var close = func():
		J.mc(J.gp(el, "classList"), "remove", ["on"]); J.sp(el, "innerHTML", "")
		if on_close != null: J.cl(on_close, null, [])
	J.sp(J.mc(el, "querySelector", ["#sp-x"]), "onclick", func(_t, _a): _snd("click"); close.call(); return null)
	for btn in J.iter(J.mc(el, "querySelectorAll", [".sp-it"])):
		J.sp(btn, "onclick", func(_t, _a):
			if J.t(J.gp(btn, "disabled")): return null
			_snd("gong"); J.mc(J.gp(el, "classList"), "remove", ["on"]); J.sp(el, "innerHTML", "")
			play(J.gp(J.gp(btn, "dataset"), "id"), {"after": func(_t2, _a2): open_picker(on_close); return null})
			return null)

# ---------- 掛鈎 ----------
static func install() -> void:
	var GS = _g("GhostStreet")
	if GS != null:
		var om = J.gp(GS, "mul")
		J.sp(GS, "mul", func(this_, a):
			var v = J.cl(om, this_, a)
			var S = _S()
			if J.str(J.arg(a, 0)) == "work" and J.t(S) and J.t(J.gp(S, "su")) and J.num(J.gp(J.gp(S, "su"), "buff")) > J.num(J.S_Date_("now", [])): return J.num(v) * 1.1
			return v)
		var orp = J.gp(GS, "renderPanel")
		J.sp(GS, "renderPanel", func(this_, a):
			var r = J.cl(orp, this_, a)
			var view = J.gp(this_, "view")
			if J.t(view) and J.str(J.gp(view, "k")) == "idle":
				var chips = _doc("querySelector", ["#gs-panel .gs-chips"])
				if J.t(chips) and not J.t(_doc("querySelector", ["#gs-panel .su-wide"])):
					var s = st()
					if s == null: s = {"seen": {}}
					var n = _new_count(s)
					var b = _doc("createElement", ["button"]); J.sp(b, "className", "btn gold wide su-wide")
					J.sp(b, "innerHTML", "棟篤笑・今晚開咪" + (("<small>（%d 段新節目）</small>" % n) if n > 0 else ""))
					J.sp(b, "onclick", func(_t, _a): _snd("click"); open_picker(); return null)
					J.mc(J.gp(chips, "parentNode"), "insertBefore", [b, J.gp(chips, "nextSibling")])
			return r)
	var UI = _g("UI")
	if UI != null and J.t(J.gp(UI, "openStory")):
		var os = J.gp(UI, "openStory")
		J.sp(UI, "openStory", func(this_, a):
			var r = J.cl(os, this_, a)
			_story_page()
			return r)
	J.F_setInterval([func(_t, _a): _announce(); return null, 4000.0])

static func _story_page() -> void:
	var body = _doc("querySelector", ["#sheet .sh-body"])
	var hr = J.mc(body, "querySelector", ["hr"]) if J.t(body) else null
	if J.t(hr):
		var s = st()
		if s == null: s = {"seen": {}}
		var div = _doc("createElement", ["div"])
		var btns = ""
		for b in BITS:
			var sn = J.t(J.gp(J.gp(s, "seen"), b.id))
			btns += "<button class=\"btn wide %s\" data-su=\"%s\" %s>%s</button>" % ["" if sn else "ghost", J.str(b.id), "" if sn else "disabled",
				("<small>%s</small>　%s" % [J.str(b.who), J.str(_L(b.title))]) if sn else ("？？？（" + ("到冥街夜市觀看" if ok(b) else J.str(b.hint)) + "）")]
		J.sp(div, "innerHTML", "<h4 class=\"stand-h\">冥街夜市・棟篤笑</h4><p class=\"desc\">在冥街夜市看過的節目，可以在這裡重溫。</p><div class=\"slist\">" + btns + "</div>")
		J.mc(J.gp(hr, "parentNode"), "insertBefore", [div, hr])
		for x in J.iter(J.mc(div, "querySelectorAll", ["[data-su]"])):
			J.sp(x, "onclick", func(_t, _a):
				J.mc(_g("UI"), "close", [])
				var id = J.gp(J.gp(x, "dataset"), "su")
				J.F_setTimeout([func(_t2, _a2): play(id, {"replay": true}); return null, 60.0])
				return null)
	var snd = _doc("getElementById", ["sndbtn"])
	var LANG = _g("LANG")
	if J.t(snd) and LANG != null and not J.t(_doc("getElementById", ["langbtn"])):
		var lb = _doc("createElement", ["button"]); J.sp(lb, "className", "btn wide"); J.sp(lb, "id", "langbtn")
		var lab = func(): J.sp(lb, "textContent", "對白：" + ("中文（點擊切換為粵語）" if J.str(J.gp(LANG, "cur")) == "zh" else "粵語（點擊切換為中文）"))
		lab.call()
		J.sp(lb, "onclick", func(_t, _a): J.mc(LANG, "toggle", []); lab.call(); _snd("click"); return null)
		J.mc(J.gp(snd, "parentNode"), "insertBefore", [lb, J.gp(snd, "nextSibling")])

static func _announce() -> void:
	var s = st(); var Sk = _g("Skits")
	if s == null or Sk == null or not J.t(J.mc(Sk, "quiet", [])): return
	if load("res://game/zone/zone_data.gd").on(): return   # [outgate] 冥街夜市暫時唔開：唔出「今晚登台」提示
	for b in BITS:
		if ok(b) and not J.t(J.gp(J.gp(s, "ann"), b.id)) and not J.t(J.gp(J.gp(s, "seen"), b.id)):
			J.sp(J.gp(s, "ann"), b.id, 1.0)
			J.mc(_g("Fx"), "toast", ["冥街夜市・棟篤笑：<b>%s《%s》</b>今晚登台。<br><small>出村 → 冥街夜市 → 棟篤笑</small>" % [J.str(b.who), J.str(_L(b.title))]])
			_save()
			return

# ---------- 主線串場（包住 Story.queue：某段劇情之後自動接一段，只會出一次） ----------
static func install_xo() -> void:
	var SC = _g("SCENES")
	if SC == null: return
	for id in XO_SCENES: if not J.t(J.gp(SC, id)): J.sp(SC, id, XO_SCENES[id])
	var SA = _g("SPEAKER_ART")
	if SA != null: for n in XO_SPEAKERS: if not J.t(J.gp(SA, n)): J.sp(SA, n, XO_SPEAKERS[n])
	var SO = _g("SCENE_ORDER")
	if SO != null:   # 劇情回顧：串場跟住原本嗰段
		for row in J.iter(SO):
			var ids: Array = J.gp(row, 1.0)
			for after in XO_AFTER:
				var i = ids.find(after)
				if i < 0: continue
				var j = i + 1
				for x in XO_AFTER[after]:
					if ids.find(x) < 0: ids.insert(j, x)
					j = ids.find(x) + 1
	_wrap_story()

# Godot：Story 喺 JS 模塊載入之後先由 connect_ui 建立（會蓋走載入時包嘅嘢）→ 等佢出現先包，包過就做記號
static func _wrap_story() -> void:
	var St = _g("Story")
	var done_ = St != null and J.t(J.gp(St, "__xo"))
	# 包好之後每 2 秒再睇一次（匯入存檔會重建 Story）
	J.F_setTimeout([func(_t, _a): _wrap_story(); return null, 2000.0 if done_ else 300.0])
	if done_ or St == null or not J.t(J.gp(St, "skipScene")): return
	J.sp(St, "__xo", true)
	if J.t(J.gp(St, "queue")):
		var oq = J.gp(St, "queue")
		J.sp(St, "queue", func(this_, a):
			var r = J.cl(oq, this_, a)
			var sc = J.arg(a, 0); var S = _S()
			if sc is String and XO_AFTER.has(sc) and J.t(S):
				for x in XO_AFTER[sc]:
					var q = J.gp(this_, "q")
					var queued = false
					for it in J.iter(q): if J.seq(J.gp(it, "sc"), x): queued = true
					if not J.t(J.gp(J.gp(S, "seen"), x)) and J.t(J.gp(_g("SCENES"), x)) and not queued: J.cl(oq, this_, [x])
			return r)

func run(_env) -> void:
	var f = FileAccess.open("res://data/nat/standup.json", FileAccess.READ)
	var d = JSON.parse_string(f.get_as_text()) if f else {}
	BITS = d.get("SU_BITS", []); XO_SCENES = d.get("XO_SCENES", {}); XO_AFTER = d.get("XO_AFTER", {}); XO_SPEAKERS = d.get("XO_SPEAKERS", {})
	J.G["SU_BITS"] = BITS; J.G["XO_SCENES"] = XO_SCENES; J.G["XO_AFTER"] = XO_AFTER; J.G["XO_SPEAKERS"] = XO_SPEAKERS
	install_xo()
	install()
	J.G["Standup"] = {
		"play": func(_t, a): return play(J.arg(a, 0), J.arg(a, 1)),
		"openPicker": func(_t, a): open_picker(J.arg(a, 0)); return null,
		"list": BITS,
		"ok": func(_t, a): return ok(J.arg(a, 0)),
		"st": func(_t, _a): return st(),
		"audience": func(_t, a): return audience(J.arg(a, 0)),
	}
