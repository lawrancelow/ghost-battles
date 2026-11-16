# 原生改寫自 graveyard.js（亂葬崗・無名墳推理）
# 公平原則照舊：生成器逐位照搬（同一個種子 → 同一晚題目，同轉譯版一模一樣）；驗證器 solve 暴力列舉，唯一解先出題
# 全局同轉譯版一樣：GY_*、GY_GEN、Graveyard；畫面由 MiniStage（G._nd）＋ GyPanel／GyEnd 原生畫
extends RefCounted

const GY_SPOTS := {
	"A": {"x": 0.25, "y": 0.375, "row": 0.0, "side": 0.0, "name": "左上"},
	"B": {"x": 0.76, "y": 0.37, "row": 0.0, "side": 2.0, "name": "右上"},
	"C": {"x": 0.52, "y": 0.475, "row": 1.0, "side": 1.0, "name": "正中間"},
	"D": {"x": 0.24, "y": 0.585, "row": 2.0, "side": 0.0, "name": "左下"},
	"E": {"x": 0.76, "y": 0.58, "row": 2.0, "side": 2.0, "name": "右下"},
}
const GY_TOMB_TAB := [[0.50, 0.29, 0.52, 0.38, 0.62], [0.49, 0.24, 0.55, 0.37, 0.61], [0.50, 0.30, 0.52, 0.38, 0.62], [0.50, 0.24, 0.52, 0.38, 0.62]]
const GY_TAGS := ["①", "②", "③", "④", "⑤"]
const GY_LEVELS := {"1": {"n": 3.0, "g": 3.0, "direct": 2.0}, "2": {"n": 4.0, "g": 4.0, "direct": 1.0}, "3": {"n": 4.0, "g": 5.0, "direct": 1.0}, "4": {"n": 5.0, "g": 5.0, "direct": 1.0}}
const GY_JOBS := {
	"會計": {"ep": [["數了一輩子別人的錢", ["一輩子", "別人的錢"]], ["帳終於對平了", ["對平"]]], "last": "帳……對平了。"},
	"保安": {"ep": [["守了三十年大門，今天準時下班", ["大門", "準時下班"]], ["大家都回家了，我也回家", ["回家"]]], "last": "可以關燈了。"},
	"外賣員": {"ep": [["這一單，終於送到了", ["送到了", "這一單"]], ["風雨無阻，請給五星", ["五星", "風雨無阻"]]], "last": "這一單……送到了。"},
	"補習老師": {"ep": [["下課鐘響了，不用再補", ["下課", "不用再補"]], ["考試範圍：無", ["考試範圍"]]], "last": "今天，不留功課。"},
	"茶室頭手": {"ep": [["最後一杯，走甜", ["走甜", "最後一杯"]], ["爐火熄了，人也歇了", ["爐火"]]], "last": "Kopi-O，走甜。"},
	"地產經紀": {"ep": [["此地永久地契，不設轉售", ["永久地契", "不設轉售"]], ["風水一流，近地鐵站", ["風水", "地鐵站"]]], "last": "這個單位……我自己住。"},
	"夜班護士": {"ep": [["換班了，這次真的睡了", ["換班", "真的睡了"]], ["不用再叫醒我了", ["叫醒"]]], "last": "下一更，交給你們了。"},
	"羅里司機": {"ep": [["跑了一百萬公里，終於泊好", ["泊好", "一百萬公里"]], ["前路不再塞車", ["塞車"]]], "last": "引擎，熄了。"},
	"收銀員": {"ep": [["找你零錢，不用謝", ["零錢", "不用謝"]], ["收工了，抽屜對數", ["抽屜"]]], "last": "下一位……沒有了。"},
	"銀行櫃員": {"ep": [["請取號，下一位", ["取號", "下一位"]], ["本櫃台暫停服務", ["暫停服務"]]], "last": "本櫃台，暫停服務。"},
	"文員": {"ep": [["影印了半生，終於原件歸檔", ["原件歸檔", "影印"]], ["已讀，不回", ["已讀"]]], "last": "這份，不用再改了。"},
	"網約車司機": {"ep": [["目的地：已抵達", ["已抵達", "目的地"]], ["乘客已下車，請給好評", ["下車", "好評"]]], "last": "目的地，到了。"},
	"小販": {"ep": [["今天早點收檔", ["收檔", "早點"]], ["賣完了，明天請早", ["明天請早"]]], "last": "今天，賣完了。"},
	"人事專員": {"ep": [["您的離職申請已批准", ["離職申請", "已批准"]], ["恭喜轉正，永不續約", ["轉正", "永不續約"]]], "last": "這次，是我自己批准的。"},
}
const GY_OFFERS := ["榴槤", "麻將牌", "一封沒拆的公司信", "老花眼鏡", "麥芽飲品罐", "椰漿飯", "計算機", "粉筆", "安全帽", "一串鑰匙", "舊手機", "萬字票", "紅包", "藍白拖鞋"]
const GY_SURN := ["陳", "林", "黃", "李", "張", "王", "吳", "劉", "蔡", "楊", "鄭", "何", "謝", "羅", "梁", "周", "許", "曾", "蕭", "郭"]
const GY_GIVEN := ["美玲", "志強", "國華", "秀英", "家豪", "淑芬", "偉明", "亞清", "文傑", "麗珠", "金水", "月娥", "俊傑", "寶珠", "德福", "玉蘭", "振興", "素貞", "建國", "惠敏"]
const GY_DEC := ["", "", "二", "三", "四", "五", "六", "七", "八"]
const GY_TPL := {
	"job_is": ["我生前是{job}。", "每天上班、下班……我是{job}。"],
	"job_not": ["我生前不是{job}。", "我沒做過{job}。"],
	"ojob_not": ["{J}生前不是{job}。", "{J}沒做過{job}。"],
	"off_is": ["我的墳前，有人放了{off}。", "我記得墳前放著{off}。"],
	"off_not": ["我的墳前放的不是{off}。"],
	"quote": ["碑文我只記得『{q}』。", "我的碑文裡有『{q}』。"],
	"quote_not": ["我的碑文裡沒有『{q}』。"],
	"age": ["我走的時候{d}十幾歲。"],
	"surname": ["我姓{sn}。"],
	"row_is": ["我睡在{row}。"], "row_not": ["我不是睡在{row}。"],
	"side_is": ["我睡在{side}。"], "side_not": ["我不是睡在{side}。"],
	"tree": ["我睡在牌坊旁邊那座。"], "tree_not": ["我不是睡在牌坊旁邊那座。"],
	"rel": ["我的墳在{J}的墳{dir}。"],
	"same_row": ["我和{J}睡在同一排。"],
	"died": ["我比{J}{when}。"],
}
const GY_ROWW := ["上排", "正中間那座", "下排"]
const GY_SIDEW = ["左側", null, "右側"]
const GY_COLORS := ["#9fe8ff", "#ffd27a", "#d0b0ff", "#a8ffb8", "#ffa8c0"]
const GY_ALPHA := [0.9, 0.84, 0.88, 0.86, 0.8]
const GY_RULES := [
	["他們記得的，都是真的", "每一晚只有一種擺法說得通。擺錯了，就是哪一步想錯了。"],
	["排（高低）", "上排＝上面兩座（左上、右上）；正中間那座自成一排；下排＝下面兩座（左下、右下）。"],
	["側（左右）", "左側＝左上、左下；右側＝右上、右下。正中間那座不算左側，也不算右側。"],
	["上面／下面", "只比排：上排在正中間上面，正中間在下排上面。同一排不算上下，不用對正。"],
	["左邊／右邊", "只比側：左側在正中間左邊，正中間在右側左邊。同一側不算左右，不用對齊。"],
	["同一排", "兩座都在上排，或都在下排。"],
	["牌坊旁邊那座", "左下那座（就在石牌坊旁邊）。"],
	["幾十幾歲", "卒年減生年。"],
	["早走／晚走", "卒年比較早／比較晚。"],
	["碑文", "墓碑卡上「碑文」那一行；『』裡的字一字不差出現在碑文裡。"],
	["只算立了碑的", "沒立碑的空地不是墳。有時會多一座墳，裡面的人早就安息了，不屬於今晚任何一個魂。"],
]
const W0 := {"job_is": 1, "job_not": 3, "ojob_not": 2, "off_is": 1, "off_not": 2, "quote": 3, "quote_not": 2, "age": 3, "surname": 1, "row_is": 2, "row_not": 2, "side_is": 2, "side_not": 2, "tree": 1, "tree_not": 2, "rel": 5, "same_row": 4, "died": 4}

# ================= 隨機數（mulberry32，同 JS 逐位一樣） =================
static func _i32(x: int) -> int:
	x = x & 0xFFFFFFFF
	return x - 0x100000000 if x >= 0x80000000 else x
static func _u32(x: int) -> int: return x & 0xFFFFFFFF
static func _imul(a: int, b: int) -> int: return _i32(_i32(a) * _i32(b))

class Rng extends RefCounted:
	var a := 0
	func _init(seed: float) -> void: a = int(fmod(floor(seed), 4294967296.0)) & 0xFFFFFFFF
	func next() -> float:
		a = (a + 0x6D2B79F5) & 0xFFFFFFFF
		var t = a
		t = _i32(_i32(_i32(t) ^ ((t & 0xFFFFFFFF) >> 15)) * _i32(_i32(t) | 1))
		var s2 = t + _i32(_i32(_i32(t) ^ ((t & 0xFFFFFFFF) >> 7)) * _i32(_i32(t) | 61))
		t = _i32(_i32(t) ^ _i32(s2))
		return float((_i32(t) ^ ((t & 0xFFFFFFFF) >> 14)) & 0xFFFFFFFF) / 4294967296.0
	static func _i32(x: int) -> int:
		x = x & 0xFFFFFFFF
		return x - 0x100000000 if x >= 0x80000000 else x

static func level_of(night: float) -> int: return 1 if night <= 2 else (2 if night <= 4 else (3 if night <= 7 else 4))

# ================= 驗證器 =================
static func _gidx(asg, who) -> int:
	return int(asg[int(who)])

static func holds(c: Dictionary, asg, graves: Array) -> bool:
	var me = graves[_gidx(asg, c.who)]
	var o = graves[_gidx(asg, c.j)] if c.get("j") != null else null
	var sp = GY_SPOTS[me.spot]; var so = GY_SPOTS[o.spot] if o != null else null
	var v = c.get("v")
	match J.str(c.t):
		"job_is": return me.job == v
		"job_not": return me.job != v
		"ojob_not": return o.job != v
		"off_is": return me.off == v
		"off_not": return me.off != v
		"quote": return J.str(me.ep).contains(J.str(v))
		"quote_not": return not J.str(me.ep).contains(J.str(v))
		"age": return floor((J.num(me.death) - J.num(me.birth)) / 10.0) == J.num(v)
		"surname": return J.str(me.name).substr(0, 1) == J.str(v)
		"row_is": return sp.row == J.num(v)
		"row_not": return sp.row != J.num(v)
		"side_is": return sp.side == J.num(v)
		"side_not": return sp.side != J.num(v)
		"tree": return me.spot == "D"
		"tree_not": return me.spot != "D"
		"rel":
			if v == "up": return sp.row < so.row
			if v == "down": return sp.row > so.row
			if v == "left": return sp.side < so.side
			return sp.side > so.side
		"same_row": return sp.row == so.row
		"died": return J.num(me.death) < J.num(o.death) if v == "early" else J.num(me.death) > J.num(o.death)
	return false

static func solve(n: int, graves: Array, clues: Array, cap: int) -> Array:
	var out = []; var asg = []; asg.resize(n); var used = []; used.resize(graves.size()); used.fill(false)
	var by_who = []
	for i in n: by_who.append([])
	for c in clues: by_who[maxi(int(J.num(c.who)), int(J.num(c.j)) if c.get("j") != null else -1)].append(c)
	_rec(0, n, graves, by_who, asg, used, out, cap)
	return out

static func _rec(i: int, n: int, graves: Array, by_who: Array, asg: Array, used: Array, out: Array, cap: int) -> void:
	if cap > 0 and out.size() >= cap: return
	if i == n: out.append(asg.duplicate()); return
	for g in graves.size():
		if used[g]: continue
		used[g] = true; asg[i] = g
		var okk = true
		for c in by_who[i]:
			if not holds(c, asg, graves): okk = false; break
		if okk: _rec(i + 1, n, graves, by_who, asg, used, out, cap)
		used[g] = false

static func _rep1(s: String, pat: String, val) -> String:
	var i = s.find(pat)
	if i < 0: return s
	return s.substr(0, i) + J.str(val) + s.substr(i + pat.length())

static func text(c: Dictionary, r: Rng) -> String:
	var tp: Array = GY_TPL[c.t]; var s: String = tp[int(floor(r.next() * tp.size()))]
	var Jt = GY_TAGS[int(J.num(c.j))] if c.get("j") != null else ""
	var v = c.get("v")
	var vv = v
	if c.t == "age": vv = GY_DEC[int(J.num(v))]
	var ri = int(J.num(v)) if (v is float or v is int) else -1
	s = _rep1(s, "{job}", v); s = _rep1(s, "{off}", v); s = _rep1(s, "{q}", v); s = _rep1(s, "{d}", vv); s = _rep1(s, "{sn}", v)
	s = _rep1(s, "{row}", GY_ROWW[ri] if ri >= 0 and ri < 3 else null)
	s = _rep1(s, "{side}", GY_SIDEW[ri] if ri >= 0 and ri < 3 else null)
	s = _rep1(s, "{J}", Jt)
	s = _rep1(s, "{dir}", {"up": "上面", "down": "下面", "left": "左邊", "right": "右邊"}.get(v))
	s = _rep1(s, "{when}", "早走" if typeof(v) == TYPE_STRING and v == "early" else "晚走")
	return s

static func shuffle(a: Array, r: Rng) -> Array:
	var i = a.size() - 1
	while i > 0:
		var j = int(floor(r.next() * (i + 1)))
		var tmp = a[i]; a[i] = a[j]; a[j] = tmp
		i -= 1
	return a

static func gen(night: float, seed: float) -> Dictionary:
	var level = level_of(night); var L = GY_LEVELS[str(level)]
	for tries in 400:
		var r = Rng.new(float(_u32(int(seed))) + tries * 7919)
		var p = try_gen(L, r)
		if not p.is_empty():
			p["level"] = float(level); p["night"] = night; p["seed"] = seed; p["tries"] = float(tries)
			return p
	push_error("graveyard gen failed")
	return {}

static func _clue(t: String, who: int, v = null, j = -1) -> Dictionary:
	var c = {"t": t, "who": float(who)}
	if j >= 0: c["j"] = float(j)
	if v != null or t == "tree" or t == "tree_not" or t == "same_row": pass
	c["v"] = v
	return c

static func _key(c: Dictionary) -> String: return JSON.stringify([c.t, c.who, c.get("j"), c.get("v")])

static func _sig(c: Dictionary) -> String:
	var a = c.who; var b = c.get("j")
	match J.str(c.t):
		"job_is", "job_not": return JSON.stringify(["job", a, c.v])
		"ojob_not": return JSON.stringify(["job", b, c.v])
		"same_row": return JSON.stringify(["row=", minf(a, b), maxf(a, b)])
		"died": return JSON.stringify(["died", a if c.v == "early" else b, b if c.v == "early" else a])
		"rel":
			match J.str(c.v):
				"up": return JSON.stringify(["above", a, b])
				"down": return JSON.stringify(["above", b, a])
				"left": return JSON.stringify(["leftof", a, b])
				_: return JSON.stringify(["leftof", b, a])
	return JSON.stringify([c.t, a, c.get("v")])

static func try_gen(L: Dictionary, r: Rng) -> Dictionary:
	var g_n = int(L.g); var n = int(L.n)
	var spots = shuffle(GY_SPOTS.keys(), r).slice(0, g_n); spots.sort()
	var sn = shuffle(GY_SURN.duplicate(), r).slice(0, g_n)
	var gv = shuffle(GY_GIVEN.duplicate(), r).slice(0, g_n)
	var jobs = shuffle(GY_JOBS.keys(), r).slice(0, g_n)
	var offs = shuffle(GY_OFFERS.duplicate(), r).slice(0, g_n)
	var deaths = []
	while deaths.size() < g_n:
		var d = 1986.0 + floor(r.next() * 39)
		var okk = true
		for x in deaths: if absf(x - d) < 2: okk = false; break
		if okk: deaths.append(d)
	var graves = []
	for i in spots.size():
		var dec = 2 + floor(r.next() * 7); var age = dec * 10 + 2 + floor(r.next() * 7)
		var eps: Array = GY_JOBS[jobs[i]].ep; var e = eps[int(floor(r.next() * eps.size()))]
		graves.append({"spot": spots[i], "name": sn[i] + gv[i], "job": jobs[i], "off": offs[i], "ep": e[0], "keys": e[1].duplicate(), "death": deaths[i], "birth": deaths[i] - age})
	var eps_seen = {}
	for g in graves: eps_seen[g.ep] = 1
	if eps_seen.size() != graves.size(): return {}
	var idx = []
	for i in graves.size(): idx.append(i)
	var truth = shuffle(idx, r).slice(0, n)
	# ---- 所有真話 ----
	var pool = []
	var add = func(c): if holds(c, truth, graves): pool.append(c)
	var used_rows = []; var used_sides = []
	for g in graves:
		var rw = GY_SPOTS[g.spot].row; var sd = GY_SPOTS[g.spot].side
		if not used_rows.has(rw): used_rows.append(rw)
		if not used_sides.has(sd): used_sides.append(sd)
	var has_d = false
	for g in graves: if g.spot == "D": has_d = true
	for i in n:
		var me = graves[truth[i]]; var sp = GY_SPOTS[me.spot]
		var others = []
		for g in graves: if not is_same(g, me): others.append(g)
		add.call(_clue("job_is", i, me.job))
		for o in others: add.call(_clue("job_not", i, o.job)); add.call(_clue("off_not", i, o.off))
		add.call(_clue("off_is", i, me.off))
		for q in me.keys: add.call(_clue("quote", i, q))
		for o in others:
			for q in o.keys:
				if not J.str(me.ep).contains(q): add.call(_clue("quote_not", i, q))
		add.call(_clue("age", i, floor((me.death - me.birth) / 10.0)))
		add.call(_clue("surname", i, J.str(me.name).substr(0, 1)))
		for rw in used_rows:
			if rw == sp.row: add.call(_clue("row_is", i, rw))
			else: add.call(_clue("row_not", i, rw))
		for sd in used_sides:
			if sd == 1: continue
			if sd == sp.side: add.call(_clue("side_is", i, sd))
			else: add.call(_clue("side_not", i, sd))
		if has_d: add.call(_clue("tree" if me.spot == "D" else "tree_not", i))
		for j in n:
			if j == i: continue
			for v in ["up", "down", "left", "right"]: add.call(_clue("rel", i, v, j))
			add.call(_clue("same_row", i, null, j))
			for v in ["early", "late"]: add.call(_clue("died", i, v, j))
			for o in graves:
				if not is_same(o, graves[truth[j]]): add.call(_clue("ojob_not", i, o.job, j))
	# 只留有過濾作用嘅
	var useful = []
	for c in pool:
		var any_false = false
		for g in graves.size():
			for h in graves.size():
				if c.get("j") == null and h > 0: break
				if c.get("j") != null and g == h: continue
				var asg = {}; asg[int(c.who)] = g
				if c.get("j") != null: asg[int(c.j)] = h
				if not holds(c, asg, graves): any_false = true
			if any_false: break
		if any_false: useful.append(c)
	var is_direct = func(c) -> bool:
		if c.get("j") != null: return false
		var cnt = 0
		for g in graves.size():
			var asg = {}; asg[int(c.who)] = g
			if holds(c, asg, graves): cnt += 1
		return cnt == 1
	var W = W0.duplicate()
	if n == 3: W.merge({"rel": 2, "died": 2, "same_row": 1, "ojob_not": 1, "quote": 4, "age": 3, "job_not": 3, "off_not": 3}, true)
	var wpick = func(arr: Array):
		var by = {}
		for c in arr:
			if not by.has(c.t): by[c.t] = []
			by[c.t].append(c)
		var ts = by.keys(); var s = 0.0
		for t in ts: s += W[t]
		var x = r.next() * s
		for t in ts:
			x -= W[t]
			if x <= 0: return by[t][int(floor(r.next() * by[t].size()))]
		var l = by[ts[ts.size() - 1]]
		return l[int(floor(r.next() * l.size()))]
	var per = []
	for i in n:
		var a = []
		for c in useful: if int(c.who) == i: a.append(c)
		per.append(a)
	var chosen = []; var has = {}; var said = {}; var n_direct = [0]
	var take = func(c):
		chosen.append(c); has[_key(c)] = 1; said[_sig(c)] = 1
		if is_direct.call(c): n_direct[0] += 1
	var avail = func(i: int) -> Array:
		var out = []
		for c in per[i]:
			if not has.has(_key(c)) and not said.has(_sig(c)) and (not is_direct.call(c) or n_direct[0] < int(L.direct)): out.append(c)
		return out
	for i in n:
		for k in 2:
			var a = avail.call(i)
			if a.is_empty(): return {}
			take.call(wpick.call(a))
	var sols = solve(n, graves, chosen, 3)
	var guard = 0
	while sols.size() > 1 and guard < 20:
		guard += 1
		var cand = []
		for i in n:
			var cnt = 0
			for c in chosen: if int(c.who) == i: cnt += 1
			if cnt < 3: for c in avail.call(i): cand.append(c)
		if cand.is_empty(): return {}
		shuffle(cand, r)
		var best = null; var bs = 1e9
		for c in cand.slice(0, 24):
			var s = solve(n, graves, chosen + [c], 0).size(); var sc = s * 10 - W[c.t]
			if s >= 1 and sc < bs: bs = sc; best = c
		take.call(best); sols = solve(n, graves, chosen, 3)
	if sols.size() != 1: return {}
	# 精簡
	for c in shuffle(chosen.duplicate(), r):
		var cnt = 0
		for x in chosen: if x.who == c.who: cnt += 1
		if cnt <= 2: continue
		var rest = []
		for x in chosen: if not is_same(x, c): rest.append(x)
		if solve(n, graves, rest, 2).size() == 1: chosen.erase(c)
	if n >= 4:
		var any_j = false
		for c in chosen: if c.get("j") != null: any_j = true
		if not any_j: return {}
	var lines = {}; var souls = []
	for i in n:
		var mine0 = []
		for c in chosen: if int(c.who) == i: mine0.append(c)
		var mine = shuffle(mine0, r)
		var ls = []
		for c in mine:
			var t = ""; var k = 0
			while true:
				t = text(c, r)
				if not (lines.has(t) and k < 8): break
				k += 1
			ls.append(t)
		for t in ls: if lines.has(t): return {}
		for t in ls: lines[t] = 1
		souls.append({"tag": GY_TAGS[i], "grave": float(truth[i]), "clues": mine, "lines": ls})
	var sol = solve(n, graves, chosen, 0)
	if sol.size() != 1: return {}
	for i in n: if sol[0][i] != truth[i]: return {}
	return {"graves": graves, "souls": souls}

static func card(g: Dictionary) -> Dictionary:
	return {"spot": g.spot, "name": g.name, "years": "%s – %s" % [J.str(g.birth), J.str(g.death)], "job": g.job, "ep": g.ep, "off": g.off}

# ================= 遊戲 =================
static var Y: Dictionary = {}

static func _g(n: String): return J.G.get(n)
static func _S() -> Dictionary: return J.G.get("S")
static func _el(sel: String):
	var f = _g("$")
	return J.cl(f, null, [sel]) if f != null else null
static func _snd(n, x = null) -> void:
	var s = _g("Sound")
	if s != null: J.mc(s, "play", [n] if x == null else [n, x])
static func _save() -> void: J.cl(_g("save"), null, [])
static func _onclick(sel: String, f: Callable) -> void:
	var e = _el(sel)
	if e != null: J.sp(e, "onclick", func(_t = null, _a = null): f.call())

static func ensure() -> Dictionary:
	var S = _S()
	if not (S.get("yard") is Dictionary): S["yard"] = {}
	var y = S.yard
	if not (J.num(y.get("night")) >= 1): y["night"] = 1.0
	y["night"] = floor(J.num(y.night))
	if not (J.num(y.get("best")) >= 0) or y.get("best") == null: y["best"] = 0.0
	if not (y.get("rested") is Array): y["rested"] = []
	if not (J.num(y.get("seed")) > 0): y["seed"] = 1 + floor(randf() * 2e9)
	return y

static func open_() -> void:
	var y = ensure(); _save()
	Y["p"] = gen(J.num(y.night), J.num(y.seed))
	var p = Y.p; var n = p.souls.size()
	Y.merge({"active": true, "t": 0.0, "tries": 0.0, "phase": "play", "sel": null, "view": {"k": "soul", "i": 0.0}, "drag": null, "parts": [], "crows": [], "crowT": 4.0, "bub": null, "restT": 0.0, "guide": false}, true)
	var souls = []
	for i in n: souls.append({"i": float(i), "tag": p.souls[i].tag, "place": null, "x": 0.0, "y": 0.0, "ph": randf() * 6, "rx": null, "col": GY_COLORS[i], "a": GY_ALPHA[i]})
	Y["souls"] = souls
	var wisps = []
	for i in 7: wisps.append({"x": randf(), "y": 0.35 + randf() * 0.55, "ph": randf() * 9, "sp": 0.3 + randf() * 0.5})
	Y["wisps"] = wisps
	var stones = []
	for gi in p.graves.size():
		var r = Rng.new(J.num(p.seed) + gi * 101); var st = []
		for k in 26: st.append([r.next(), r.next(), (r.next() - 0.5) * 0.5, r.next()])
		stones.append(st)
	Y["stones"] = stones
	var el = _el("#gyard"); J.mc(J.gp(el, "classList"), "add", ["on"])
	J.sp(el, "innerHTML", "<div id=\"gy-top\"><button class=\"btn sm ghost\" id=\"gy-quit\">收工</button><b>亂葬崗・第 %s 夜</b><span id=\"gy-tries\"></span><button class=\"btn sm\" id=\"gy-rule\">規矩</button></div>\n      <div id=\"gy-hint\"></div><div id=\"gy-stage\"><canvas id=\"gy-cvs\"></canvas></div>\n      <div id=\"gy-panel\"><div id=\"gy-chips\"></div><div id=\"gy-info\"></div><div class=\"gy-acts\"><button class=\"btn\" id=\"gy-reset\">全部退回</button><button class=\"btn gold\" id=\"gy-go\">送他們安息</button></div></div><div id=\"gy-end\"></div>" % J.str(y.night))
	_onclick("#gy-quit", func():
		if J.str(Y.phase) != "play": return
		if not J.t(J.cl(_g("confirmInline"), null, [_el("#gy-quit"), "確定收工？"])): return
		close())
	_onclick("#gy-rule", func():
		if J.str(Y.view.k) == "rules":
			Y["view"] = {"k": "soul", "i": Y.sel} if Y.sel != null else {"k": "soul", "i": 0.0}; Y["guide"] = false
		else: Y["view"] = {"k": "rules"}; Y["guide"] = true
		render_panel())
	_onclick("#gy-reset", func():
		if J.str(Y.phase) != "play": return
		for s in Y.souls: s["place"] = null
		Y["sel"] = null; render_panel())
	_onclick("#gy-go", func(): submit())
	var cv = _el("#gy-cvs")
	J.mc(cv, "addEventListener", ["pointerdown", func(_t, a): down(J.arg(a, 0))])
	J.mc(cv, "addEventListener", ["pointermove", func(_t, a): move(J.arg(a, 0))])
	J.mc(cv, "addEventListener", ["pointerup", func(_t, a): up(J.arg(a, 0))])
	J.mc(cv, "addEventListener", ["pointercancel", func(_t, _a): if J.t(Y.get("drag")): Y["drag"] = null])
	if not J.t(Y.get("_rs")):
		Y["_rs"] = true
		var w = _g("window")
		if w != null: J.mc(w, "addEventListener", ["resize", func(_t, _a): if J.t(Y.active): resize()])
	J.mc(_g("Sound"), "setMode", ["story"]); _snd("crow", -0.6)
	render_panel(); resize()
	if not J.t(y.get("seen")): y["seen"] = 1.0; _save(); hint("點魂，聽他記得什麼；點墓碑，看碑文。把每個魂拖到自己的墳前（或先點魂再點墳）。方位怎麼算，按右上「規矩」。", 14)
	else: hint("今晚 %d 個魂%s。" % [n, ("，%d 座墳（有一座不是他們的）" % p.graves.size()) if p.graves.size() > n else ""], 5)
	var nm = _g("__nat_mini")
	Y["_nat"] = nm != null and J.t(J.cl(nm, null, [Y, "#gy-stage", "#gyard", "_nd", "", "#gy-panel"]))
	var tok = {}; Y["_tok"] = tok; Y["last"] = J.S_performance_("now", [])
	_raf(tok)

static func _raf(tok) -> void:
	var raf = _g("requestAnimationFrame")
	if raf != null: J.cl(raf, null, [func(_t, a): frame(J.num(J.arg(a, 0)), tok)])

static func close() -> void:
	Y["active"] = false; Y["_tok"] = null
	if J.t(Y.get("_nat")):
		var me = _g("__nat_miniEnd")
		if me != null: J.cl(me, null, ["#gyard"]); Y["_nat"] = false
	var el = _el("#gyard"); J.mc(J.gp(el, "classList"), "remove", ["on"]); J.sp(el, "innerHTML", "")
	J.mc(_g("Sound"), "setMode", ["village"]); J.mc(_g("UI"), "refresh", [])

static func hint(text: String, sec := 6.0) -> void:
	var h = _el("#gy-hint")
	if h == null: return
	J.sp(h, "innerHTML", "<span>%s</span><button aria-label=\"關閉\">✕</button>" % text); J.mc(J.gp(h, "classList"), "add", ["on"])
	J.sp(J.mc(h, "querySelector", ["button"]), "onclick", func(_t = null, _a = null): J.mc(J.gp(h, "classList"), "remove", ["on"]))
	J.cl(_g("clearTimeout"), null, [Y.get("_ht")])
	Y["_ht"] = J.F_setTimeout([func(_t = null, _a = null): J.mc(J.gp(h, "classList"), "remove", ["on"]), sec * 1000.0])

static func resize() -> void:
	var c = _el("#gy-cvs"); var bw: float; var bh: float; var dpr = 1.0
	if J.t(Y.get("_nat")):
		var r = J.cl(_g("__nat_miniSize"), null, ["#gyard"]); bw = J.num(r[0]); bh = J.num(r[1])
	else:
		var r = J.mc(_el("#gy-stage"), "getBoundingClientRect", []); bw = J.num(J.gp(r, "width")); bh = J.num(J.gp(r, "height"))
	if c != null:
		J.sp(c, "width", bw * dpr); J.sp(c, "height", bh * dpr)
		J.sp(J.gp(c, "style"), "width", J.str(bw) + "px"); J.sp(J.gp(c, "style"), "height", J.str(bh) + "px")
	Y["W"] = bw; Y["H"] = bh; Y["dpr"] = dpr

static func _img(k: String): return J.gp(_g("SPR"), k)
static func _spr_ok(k: String) -> bool: return J.t(J.cl(_g("sprOk"), null, [k]))

static func bg_scale() -> Dictionary:
	var img = _img("bg_graveyard")
	var iw = J.num(J.gp(img, "naturalWidth")) if img != null else 0.0
	var ih = J.num(J.gp(img, "naturalHeight")) if img != null else 0.0
	if iw == 0: iw = 768.0
	if ih == 0: ih = 1152.0
	var W = J.num(Y.get("W")) if J.t(Y.get("W")) else 390.0; var H = J.num(Y.get("H")) if J.t(Y.get("H")) else 560.0
	var s = maxf(W / iw, H / ih)
	if ih * s * 0.75 > H: s = H / (ih * 0.75)
	return {"s": s, "iw": iw, "ih": ih, "ox": (W - iw * s) / 2, "oy": H - ih * s}

static func pt(fx: float, fy: float) -> Vector2:
	var b = bg_scale(); return Vector2(fx * b.iw * b.s + b.ox, fy * b.ih * b.s + b.oy)
static func unit() -> float:
	var b = bg_scale(); return b.iw * b.s / 390.0
static func soul_h() -> float: return 64 * unit()
static func home_of(i: int) -> Vector2:
	var n = Y.souls.size(); var x0 = 0.32; var x1 = 0.9
	return Vector2(x0 + (0.5 if n == 1 else float(i) / (n - 1)) * (x1 - x0), 0.955)
static func grave_at(gi: int) -> Vector2:
	var s = GY_SPOTS[Y.p.graves[gi].spot]; return Vector2(s.x, s.y)
static func stand_of(gi: int) -> Vector2:
	var p = grave_at(gi); return Vector2(p.x + 0.13, p.y + 0.045)
static func target_of(s: Dictionary) -> Vector2: return stand_of(int(s.place)) if s.place != null else home_of(int(s.i))
static func stone_rect(gi: int) -> Dictionary:
	var g = grave_at(gi); var p = pt(g.x, g.y); var u = unit(); var w = 50 * u; var h = 64 * u
	return {"x": p.x - w / 2, "y": p.y - h + 6 * u, "w": w, "h": h, "cx": p.x, "by": p.y + 6 * u}

# ---------- 操作 ----------
static func local(e) -> Vector2:
	var r = J.mc(_el("#gy-cvs"), "getBoundingClientRect", [])
	return Vector2(J.num(J.gp(e, "clientX")) - J.num(J.gp(r, "left")), J.num(J.gp(e, "clientY")) - J.num(J.gp(r, "top")))

static func soul_at_px(mx: float, my: float):
	var hh = soul_h(); var best = null; var bd = 1e9
	for s in Y.souls:
		if s.get("px") == null: continue
		var x = J.num(s.px); var y = J.num(s.py)
		if mx > x - hh * 0.42 and mx < x + hh * 0.42 and my > y - hh * 1.05 and my < y + 8:
			var d = absf(mx - x) + absf(my - (y - hh / 2))
			if d < bd: bd = d; best = s
	return best

static func grave_at_px(mx: float, my: float):
	var best = null; var bd = 1e9; var u = unit()
	for gi in Y.p.graves.size():
		var r = stone_rect(gi); var cy = r.by - 10 * u; var d = Vector2((mx - r.cx) / 1.25, my - cy).length()
		if d < 58 * u and d < bd: bd = d; best = gi
	return best

static func down(e) -> void:
	if J.str(Y.phase) != "play": return
	var m = local(e); var s = soul_at_px(m.x, m.y)
	if s != null:
		Y["drag"] = {"s": s, "x0": m.x, "y0": m.y, "mx": m.x, "my": m.y, "moved": false}
		return
	var g = grave_at_px(m.x, m.y)
	if g != null:
		if Y.sel != null: place(int(Y.sel), g)
		else: Y["view"] = {"k": "grave", "i": float(g)}; Y["guide"] = false; _snd("paper"); render_panel()
		return
	if Y.sel != null: Y["sel"] = null; render_panel()

static func move(e) -> void:
	var d = Y.get("drag")
	if not J.t(d): return
	var m = local(e); d["mx"] = m.x; d["my"] = m.y
	if Vector2(m.x - J.num(d.x0), m.y - J.num(d.y0)).length() > 9: d["moved"] = true

static func up(e) -> void:
	var d = Y.get("drag")
	if not J.t(d): return
	Y["drag"] = null
	var m = local(e)
	if not J.t(d.moved):
		var si = J.num(d.s.i)
		Y["sel"] = null if (Y.sel != null and J.num(Y.sel) == si) else si
		if Y.sel != null: Y["view"] = {"k": "soul", "i": si}; Y["guide"] = false; _snd("click")
		render_panel(); return
	var g = grave_at_px(m.x, m.y - 20 * unit())
	if g != null: place(int(d.s.i), g)
	else: d.s["place"] = null; render_panel()

static func place(si: int, gi: int) -> void:
	if J.str(Y.phase) != "play": return
	for o in Y.souls: if o.place != null and int(o.place) == gi and int(o.i) != si: o["place"] = null
	Y.souls[si]["place"] = float(gi); Y["sel"] = null; Y["view"] = {"k": "grave", "i": float(gi), "who": float(si)}; Y["guide"] = false
	_snd("whoosh"); render_panel()

static func all_placed() -> bool:
	for s in Y.souls: if s.place == null: return false
	return true

static func correct() -> int:
	var k = 0
	for s in Y.souls: if s.place != null and J.num(s.place) == J.num(Y.p.souls[int(s.i)].grave): k += 1
	return k

static func submit() -> void:
	if J.str(Y.phase) != "play" or not all_placed(): return
	var k = correct(); var n = Y.souls.size()
	if k == n: rest(); return
	Y["tries"] = J.num(Y.tries) + 1
	for j in n: Y.souls[j]["rx"] = {"k": "hurt", "t": -j * 0.08, "dur": 1.3}
	_snd("lose")
	if J.num(Y.tries) >= 2:
		Y["phase"] = "fail"; say("還是不對……只有 %d 個擺對了。天快亮了。" % k, 3)
		J.F_setTimeout([func(_t = null, _a = null): finish(false, k), 1900.0])
	else:
		say("他們不肯躺下。只有 %d 個擺對了。" % k, 4.5); hint("只有 %d 個擺對了（不告訴你是哪幾個）。還有一次機會。" % k, 8)
	render_panel()

static func say(text: String, sec := 3.0) -> void: Y["bub"] = {"text": text, "life": sec, "max": sec}

static func rest() -> void:
	Y["phase"] = "rest"; Y["restT"] = 0.0; Y["sel"] = null
	_snd("gong")
	J.F_setTimeout([func(_t = null, _a = null): _snd("crow", -0.4), 900.0]); J.F_setTimeout([func(_t = null, _a = null): _snd("crow", 0.3), 1400.0])
	for i in 6: Y.crows.append({"x": 0.08 + randf() * 0.2, "y": 0.12 + randf() * 0.12, "vx": 0.16 + randf() * 0.12, "vy": -0.05 - randf() * 0.06, "ph": randf() * 6, "s": 0.9 + randf() * 0.5, "delay": 0.8 + i * 0.18, "life": 4.0})
	say("都對了。去吧，下班了。", 3)
	render_panel()
	J.F_setTimeout([func(_t = null, _a = null): finish(true, Y.souls.size()), 3600.0])

static func finish(ok: bool, k: int) -> void:
	if not J.t(Y.active) or J.str(Y.phase) == "end": return
	var S = _S(); var y = ensure(); var n = Y.souls.size(); var night = J.num(y.night); var perfect = ok and J.num(Y.tries) == 0
	Y["phase"] = "end"; J.cl(_g("clearTimeout"), null, [Y.get("_ht")])
	var hn = _el("#gy-hint")
	if hn != null: J.mc(J.gp(hn, "classList"), "remove", ["on"])
	var rw
	if ok:
		rw = {"coins": J.round((25 * n + 5 * minf(night, 20)) * (1.0 if perfect else 0.6)), "exp": J.round((5 * n + night) * (1.0 if perfect else 0.6))}
		if perfect: rw["chest"] = "b" if night >= 5 else "g"
	else: rw = {"coins": maxf(5.0, 8.0 * k), "exp": 2.0 * k}
	var got = J.str(J.cl(_g("give"), null, [rw])); var stay = ""
	var p = Y.p
	if ok:
		y["best"] = maxf(J.num(y.best), night)
		for s in p.souls: y.rested.append(p.graves[int(s.grave)].name)
		if y.rested.size() > 200: y["rested"] = y.rested.slice(y.rested.size() - 200)
		if randf() < 0.12:
			var s = p.souls[int(floor(randf() * n))]; var nm = J.str(p.graves[int(s.grave)].name)
			var has_youhun = false
			for g in S.ghosts: if J.str(g.k) == "youhun": has_youhun = true
			if not has_youhun: stay = "%s（%s）回頭看了一眼：「村子裡……還缺人嗎？」" % [J.str(s.tag), nm]; Y["_join"] = true
			else:
				stay = "%s（%s）本來想留下，可是村裡已經有遊魂了。他把身上的冥幣都留給你。" % [J.str(s.tag), nm]
				got += "，" + J.str(J.cl(_g("give"), null, [{"coins": 30.0}]))
		if stay == "" and _g("N30W") != null:
			var v = J.mc(_g("N30W"), "graveVisit", [])
			if J.t(v): stay = J.str(J.gp(v, "text")); Y["_joinK"] = J.gp(v, "k")
	y["night"] = night + 1; y["seed"] = 1 + floor(randf() * 2e9); _save()
	var rows = ""; var end_rows = []
	for i in p.souls.size():
		var s = p.souls[i]; var g = p.graves[int(s.grave)]; var wrong = Y.souls[i].place == null or J.num(Y.souls[i].place) != J.num(s.grave)
		var b = ("「%s」" % J.str(GY_JOBS[g.job].last)) if ok else ("%s%s那座%s" % ["其實睡在" if wrong else "睡在", J.str(GY_SPOTS[g.spot].name), "" if wrong else "，你擺對了"])
		var a = "%s・%s・%s–%s" % [J.str(g.name), J.str(g.job), J.str(g.birth), J.str(g.death)]
		rows += "<li><b style=\"color:%s\">%s</b> <span>%s<br><small>%s</small></span></li>" % [GY_COLORS[i], J.str(s.tag), a, b]
		end_rows.append({"tag": s.tag, "col": GY_COLORS[i], "a": a, "b": b})
	var title = ("一次就全對" if perfect else "都安息了") if ok else "天亮了"
	var word = ("陰司 KPI 系統：零投訴，五星好評。" if perfect else "陰司 KPI 系統：有投訴，但最後都結案了。") if ok else "陰司 KPI 系統：未結案。他們明晚還會在這裡等。"
	J.sp(_el("#gy-end"), "innerHTML", "<div class=\"gy-card\"><h3>%s</h3><p class=\"desc\">%s</p><ul class=\"gy-who\">%s</ul>%s<p class=\"desc\">獎勵：%s</p><div class=\"gy-acts\"><button class=\"btn\" id=\"gy-back\">回村子</button><button class=\"btn gold\" id=\"gy-next\">下一夜</button></div></div>" % [title, word, rows, ("<p class=\"desc gy-stay\">%s</p>" % stay) if stay != "" else "", got])
	Y["_endRows"] = end_rows; Y["_endInfo"] = {"title": title, "word": word, "stay": stay, "got": got}
	var ge = _g("__nat_gyEnd")
	if not (J.t(Y.get("_nat")) and ge != null and J.t(J.cl(ge, null, [Y]))): J.mc(J.gp(_el("#gy-end"), "classList"), "add", ["on"])
	var after = func():
		var jg = _g("joinGhost")
		if J.t(Y.get("_join")): Y["_join"] = false; J.cl(jg, null, ["youhun"]); _save()
		if J.t(Y.get("_joinK")): var kk = Y._joinK; Y["_joinK"] = null; J.cl(jg, null, [kk]); _save()
	var back = func(_t = null, _a = null): close(); after.call()
	var nxt = func(_t = null, _a = null): after.call(); open_()
	J.sp(_el("#gy-back"), "onclick", back); Y["_endBack"] = back
	J.sp(_el("#gy-next"), "onclick", nxt); Y["_endNext"] = nxt

# ---------- 面板（DOM：GyPanel 讀狀態畫原生，掣叫返呢度設嘅 onclick） ----------
static func render_panel() -> void:
	if not J.t(Y.get("active")) or _el("#gy-panel") == null: return
	var tries = int(J.num(Y.tries))
	J.sp(_el("#gy-tries"), "innerHTML", "機會 %s%s" % ["●".repeat(maxi(0, 2 - tries)), "○".repeat(tries)])
	var chips = ""; var v = Y.view
	for s in Y.souls:
		var g = Y.p.graves[int(s.place)] if s.place != null else null
		var si = J.num(s.i)
		chips += "<button class=\"gy-chip %s %s\" data-i=\"%s\" style=\"--c:%s\"><b>%s</b><small>%s</small></button>" % ["sel" if Y.sel != null and J.num(Y.sel) == si else "", "on" if J.str(v.k) == "soul" and J.num(v.get("i")) == si else "", J.str(si), s.col, s.tag, (J.str(g.name).substr(0, 1) + "家墳前") if g != null else "還沒安置"]
	var ce = _el("#gy-chips"); J.sp(ce, "innerHTML", chips)
	for b in J.iter(J.mc(ce, "querySelectorAll", [".gy-chip"])):
		var bb = b
		J.sp(b, "onclick", func(_t = null, _a = null):
			var i = J.num(J.gp(J.gp(bb, "dataset"), "i"))
			Y["view"] = {"k": "soul", "i": i}; Y["guide"] = false
			Y["sel"] = (null if (Y.sel != null and J.num(Y.sel) == i) else i) if J.str(Y.phase) == "play" else null
			render_panel())
	var h = ""
	if J.str(v.k) == "rules":
		h = "<div class=\"gy-rules\">"
		for r in GY_RULES: h += "<p><b>%s</b>%s</p>" % [r[0], r[1]]
		h += "</div>"
	elif J.str(v.k) == "grave":
		var vi = int(J.num(v.i)); var g = Y.p.graves[vi]; var c = card(g); var who = null
		for s in Y.souls: if s.place != null and int(s.place) == vi: who = s; break
		var note = ("<b style=\"color:%s\">%s</b> 站在這座墳前。" % [who.col, who.tag]) if who != null else ("" if Y.sel != null else "先點一個魂，再點這座墳，就能把他送過來。")
		h = "<div class=\"gy-grave\"><div class=\"gy-gh\"><b>%s</b><span>%s</span><em>%s</em></div>\n        <p><i>生前</i>%s</p><p><i>碑文</i>%s</p><p><i>祭品</i>%s</p>\n        <p class=\"gy-note\">%s</p></div>" % [c.name, c.years, GY_SPOTS[g.spot].name, c.job, c.ep, c.off, note]
	else:
		var vi = int(J.num(v.i)); var s = Y.souls[vi]; var d = Y.p.souls[vi]
		var li = ""
		for l in d.lines: li += "<li>%s</li>" % l
		h = "<div class=\"gy-soul\"><div class=\"gy-sh\" style=\"--c:%s\"><b>%s</b><span>%s</span></div><ul>%s</ul></div>" % [s.col, s.tag, "選好了：點一座墳，把他送過去" if Y.sel != null and J.num(Y.sel) == J.num(s.i) else "他記得的事", li]
	J.sp(_el("#gy-info"), "innerHTML", h)
	var go = _el("#gy-go"); var ap = all_placed()
	J.sp(go, "disabled", J.str(Y.phase) != "play" or not ap)
	var miss = 0
	for s in Y.souls: if s.place == null: miss += 1
	J.sp(go, "textContent", "送他們安息" if ap else "送他們安息（差 %d）" % miss)
	J.sp(_el("#gy-reset"), "disabled", J.str(Y.phase) != "play")

# ---------- 每一幀 ----------
static func frame(now: float, tok) -> void:
	if not J.t(Y.get("active")) or not is_same(tok, Y.get("_tok")): return
	if now - J.num(Y.last) < 1000.0 / 30 - 2: _raf(tok); return
	var dt = minf(0.05, (now - J.num(Y.last)) / 1000.0); Y["last"] = now
	step(dt)
	if not J.t(Y.get("_nat")): draw(J.num(Y.t))
	_raf(tok)

static func step(dt: float) -> void:
	Y["t"] = J.num(Y.t) + dt
	if J.str(Y.phase) == "rest": Y["restT"] = J.num(Y.restT) + dt
	for s in Y.souls:
		if J.t(s.get("rx")):
			s.rx["t"] = J.num(s.rx.t) + dt
			if J.num(s.rx.t) >= J.num(s.rx.dur): s["rx"] = null
		var tg = target_of(s)
		if J.num(s.x) == 0 and J.num(s.y) == 0: s["x"] = tg.x; s["y"] = tg.y
		var k = minf(1.0, dt * 6); s["x"] = J.num(s.x) + (tg.x - J.num(s.x)) * k; s["y"] = J.num(s.y) + (tg.y - J.num(s.y)) * k
	for w in Y.wisps:
		w["ph"] = J.num(w.ph) + dt * J.num(w.sp); w["x"] = J.num(w.x) + sin(J.num(w.ph) * 0.7) * dt * 0.02; w["y"] = J.num(w.y) + cos(J.num(w.ph) * 0.5) * dt * 0.012
		if J.num(w.x) < -0.05: w["x"] = 1.05
		if J.num(w.x) > 1.05: w["x"] = -0.05
	Y["crowT"] = J.num(Y.crowT) - dt
	if J.num(Y.crowT) <= 0 and J.str(Y.phase) == "play":
		Y["crowT"] = 8 + randf() * 8; Y.crows.append({"x": -0.05, "y": 0.08 + randf() * 0.1, "vx": 0.13, "vy": -0.01, "ph": 0.0, "s": 0.8, "delay": 0.0, "life": 9.0})
	var nc = []
	for c in Y.crows:
		if J.num(c.delay) > 0: c["delay"] = J.num(c.delay) - dt; nc.append(c); continue
		c["life"] = J.num(c.life) - dt; c["x"] = J.num(c.x) + J.num(c.vx) * dt; c["y"] = J.num(c.y) + J.num(c.vy) * dt; c["ph"] = J.num(c.ph) + dt * 14
		if J.num(c.life) > 0 and J.num(c.x) < 1.2: nc.append(c)
	Y["crows"] = nc
	var np = []
	for p in Y.parts:
		p["life"] = J.num(p.life) - dt; p["x"] = J.num(p.x) + J.num(p.vx) * dt; p["y"] = J.num(p.y) + J.num(p.vy) * dt
		if J.num(p.life) > 0: np.append(p)
	Y["parts"] = np
	if J.str(Y.phase) == "rest" and randf() < dt * 40:
		var s = Y.souls[int(floor(randf() * Y.souls.size()))]
		Y.parts.append({"x": J.num(s.x) + (randf() - 0.5) * 0.08, "y": J.num(s.y) - 0.05 - J.num(Y.restT) * 0.07, "vx": (randf() - 0.5) * 0.03, "vy": -0.08 - randf() * 0.06, "life": 1.4, "col": s.col})
	if J.t(Y.get("bub")):
		Y.bub["life"] = J.num(Y.bub.life) - dt
		if J.num(Y.bub.life) <= 0: Y["bub"] = null

# ---------- 畫 ----------
static func draw(t: float) -> void:
	if J.t(Y.get("_nat")) and not J.t(Y.get("_natCtx")): return
	var ctx: Ctx
	if J.t(Y.get("_natCtx")): ctx = Y._natCtx
	else:
		var c = _el("#gy-cvs")
		if c == null: return
		ctx = J.mc(c, "getContext", ["2d"])
	var dp = 1.0 if J.t(Y.get("_natCtx")) else J.num(Y.get("dpr", 1.0))
	ctx.setTransform(dp, 0, 0, dp, 0, 0)
	var W = J.num(Y.W); var H = J.num(Y.H); var b = bg_scale(); var img = _img("bg_graveyard"); var u = unit()
	ctx.fillStyle = "#0d0b10"; ctx.fillRect(0, 0, W, H)
	if img != null and _spr_ok("bg_graveyard"): ctx.drawImage(img, b.ox, b.oy, b.iw * b.s, b.ih * b.s)
	else:
		var g = ctx.createLinearGradient(0, 0, 0, H); g.addColorStop(0, "#1c2030"); g.addColorStop(1, "#2a2a22"); ctx.fillStyle = g; ctx.fillRect(0, 0, W, H)
		for k in GY_SPOTS:
			var p = pt(GY_SPOTS[k].x, GY_SPOTS[k].y); ctx.fillStyle = "#6a5038"; ctx.beginPath(); ctx.ellipse(p.x, p.y, 62 * u, 30 * u, 0, 0, PI * 2); ctx.fill()
	ctx.fillStyle = "rgba(10,12,34,.18)"; ctx.fillRect(0, 0, W, H)
	var lp = pt(0.25, 0.29); var lr = 60 * u * (1 + 0.06 * sin(t * 2.3)); var lg = ctx.createRadialGradient(lp.x, lp.y, 2, lp.x, lp.y, lr)
	lg.addColorStop(0, "rgba(255,170,90,.32)"); lg.addColorStop(1, "rgba(255,140,60,0)"); ctx.globalCompositeOperation = "lighter"; ctx.fillStyle = lg; ctx.fillRect(lp.x - lr, lp.y - lr, lr * 2, lr * 2); ctx.globalCompositeOperation = "source-over"
	fog(ctx, t, 0)
	if J.t(Y.get("guide")):
		for k in GY_SPOTS:
			var sp = GY_SPOTS[k]; var p = pt(sp.x, sp.y)
			var parts = [GY_ROWW[int(sp.row)].replace("那座", "")]
			if sp.side != 1: parts.append(GY_SIDEW[int(sp.side)])
			var lab = "・".join(parts) + ("・牌坊旁" if k == "D" else "")
			ctx.font = "800 %dpx sans-serif" % int(J.round(13 * u)); ctx.textAlign = "center"
			var w = J.num(ctx.measureText(lab).width) + 12
			ctx.fillStyle = "rgba(20,14,30,.82)"; ctx.beginPath(); ctx.roundRect(p.x - w / 2, p.y + 14 * u, w, 20 * u, 6); ctx.fill(); ctx.fillStyle = "#ffe9a8"; ctx.fillText(lab, p.x, p.y + 29 * u)
	var rest_k = minf(1.0, J.num(Y.restT) / 2.6) if J.num(Y.restT) > 0 else 0.0
	for gi in Y.p.graves.size(): draw_stone(ctx, Y.p.graves[gi], gi, t)
	var drg = Y.get("drag")
	if Y.sel != null or (J.t(drg) and J.t(drg.moved)):
		for gi in Y.p.graves.size():
			var r = stone_rect(gi); var al = 0.75 + 0.25 * sin(t * 4)
			ctx.fillStyle = "rgba(160,255,200,%s)" % J.str(0.10 * al); ctx.strokeStyle = "rgba(200,255,225,%s)" % J.str(al); ctx.lineWidth = 3; ctx.setLineDash([7, 5]); ctx.beginPath(); ctx.ellipse(r.cx, r.by - 4 * u, 54 * u, 22 * u, 0, 0, PI * 2); ctx.fill(); ctx.stroke(); ctx.setLineDash([])
	# 阿福提燈
	var ap = pt(0.12, 0.965); var s = 1.2 * u; var ax = ap.x; var ay = ap.y
	Art.draw_char(ctx, "afu", ax, ay, s, {"t": t, "pose": "idle", "shadow": false})
	var lx = ax + 30 * u; var ly = ay - 46 * u + sin(t * 1.8) * 1.5 * u; var g2 = ctx.createRadialGradient(lx, ly + 6 * u, 1, lx, ly + 6 * u, 46 * u)
	g2.addColorStop(0, "rgba(255,190,110,.42)"); g2.addColorStop(1, "rgba(255,160,80,0)"); ctx.globalCompositeOperation = "lighter"; ctx.fillStyle = g2; ctx.fillRect(lx - 46 * u, ly - 40 * u, 92 * u, 92 * u); ctx.globalCompositeOperation = "source-over"
	ctx.strokeStyle = "#3a2a1a"; ctx.lineWidth = 2 * u; ctx.beginPath(); ctx.moveTo(ax + 14 * u, ay - 36 * u); ctx.lineTo(lx, ly - 12 * u); ctx.stroke()
	ctx.save(); ctx.translate(lx, ly); ctx.scale(1.6 * u, 1.6 * u)
	var ART = _g("ART")
	if ART != null and J.t(J.gp(ART, "lantern")): J.mc(ART, "lantern", [ctx, 0.0, 0.0, t, "#e0a040"])
	ctx.restore()
	if J.t(Y.get("bub")): bubble(ctx, J.str(Y.bub.text), ax + 10 * u, ay - 80 * u, minf(1.0, J.num(Y.bub.life) * 2))
	var order = Y.souls.duplicate(); order.sort_custom(func(a, c2): return J.num(a.y) < J.num(c2.y))
	for so in order: draw_soul(ctx, so, t, rest_k)
	for p in Y.parts:
		var pp = pt(J.num(p.x), J.num(p.y)); ctx.globalAlpha = minf(1.0, J.num(p.life)); ctx.fillStyle = p.col if J.t(p.get("col")) else "#fff"; ctx.beginPath(); ctx.arc(pp.x, pp.y, 2.4 * u, 0, PI * 2); ctx.fill(); ctx.globalAlpha = 1
	for w in Y.wisps:
		var wp = pt(J.num(w.x), J.num(w.y) + sin(J.num(w.ph) * 2) * 0.01); var a = 0.45 + 0.35 * sin(J.num(w.ph) * 3); var r = 14 * u; var g3 = ctx.createRadialGradient(wp.x, wp.y, 0, wp.x, wp.y, r)
		g3.addColorStop(0, "rgba(170,255,240,%s)" % J.str(a)); g3.addColorStop(0.35, "rgba(90,220,210,%s)" % J.str(a * 0.45)); g3.addColorStop(1, "rgba(60,200,200,0)"); ctx.globalCompositeOperation = "lighter"; ctx.fillStyle = g3; ctx.beginPath(); ctx.arc(wp.x, wp.y, r, 0, PI * 2); ctx.fill(); ctx.globalCompositeOperation = "source-over"
	for cw in Y.crows:
		if J.num(cw.delay) > 0: continue
		var cp = pt(J.num(cw.x), J.num(cw.y)); ctx.globalAlpha = minf(1.0, J.num(cw.life))
		if ART != null and J.t(J.gp(ART, "drawCrow")): J.mc(ART, "drawCrow", [ctx, cp.x, cp.y, J.num(cw.s) * 1.4 * u, J.num(cw.ph), 1.0, false])
		ctx.globalAlpha = 1
	fog(ctx, t, 1)
	if rest_k > 0: ctx.fillStyle = "rgba(255,240,200,%s)" % J.str(0.12 * sin(rest_k * PI)); ctx.fillRect(0, 0, W, H)
	var vg = ctx.createRadialGradient(W / 2, H * 0.55, H * 0.3, W / 2, H * 0.55, H * 0.85); vg.addColorStop(0, "rgba(0,0,0,0)"); vg.addColorStop(1, "rgba(0,0,0,.5)"); ctx.fillStyle = vg; ctx.fillRect(0, 0, W, H)

static func fog(ctx: Ctx, t: float, front: int) -> void:
	var W = J.num(Y.W); var u = unit()
	for i in 4:
		var fy = 0.86 + i * 0.03 if front else 0.5 + i * 0.09
		var sp = (0.012 if front else 0.008) * (1.0 if i % 2 else -1.0)
		var fx = fmod(fmod(i * 0.37 + t * sp, 1.4) + 1.4, 1.4) - 0.2
		var p = pt(fx, fy); var rx = W * 0.55; var ry = 34 * u; var a = 0.10 if front else 0.09
		ctx.save(); ctx.translate(p.x, p.y); ctx.scale(1, ry / rx)
		var g = ctx.createRadialGradient(0, 0, 0, 0, 0, rx); g.addColorStop(0, "rgba(200,210,230,%s)" % J.str(a)); g.addColorStop(1, "rgba(200,210,230,0)")
		ctx.fillStyle = g; ctx.beginPath(); ctx.arc(0, 0, rx, 0, PI * 2); ctx.fill(); ctx.restore()

static func draw_stone(ctx: Ctx, g: Dictionary, gi: int, t: float) -> void:
	var r = stone_rect(gi); var u = unit(); var view = J.str(Y.view.k) == "grave" and int(J.num(Y.view.get("i"))) == gi
	ctx.save()
	ctx.fillStyle = "rgba(0,0,0,.35)"; ctx.beginPath(); ctx.ellipse(r.cx, r.by, r.w * 0.62, 7 * u, 0, 0, PI * 2); ctx.fill()
	var tk = "tomb" + str(gi % 4 + 1); var tab = null
	if _spr_ok(tk):
		var im = _img(tk); var w = r.w * 2.25; var h = w * J.num(J.gp(im, "naturalHeight")) / J.num(J.gp(im, "naturalWidth")); var x0 = r.cx - w / 2; var y0 = r.by + 4 * u - h; var T = GY_TOMB_TAB[gi % 4]
		ctx.drawImage(im, x0, y0, w, h); tab = {"cx": x0 + T[0] * w, "top": y0 + T[1] * h, "bot": y0 + T[2] * h, "w": (T[4] - T[3]) * w}
	else:
		var x = r.x; var y = r.y; var w = r.w; var h = r.h; var rr = w / 2
		var path = func(): ctx.beginPath(); ctx.moveTo(x, r.by - 6 * u); ctx.lineTo(x, y + rr); ctx.arc(x + rr, y + rr, rr, PI, 0); ctx.lineTo(x + w, r.by - 6 * u); ctx.closePath()
		var gr = ctx.createLinearGradient(x, y, x + w, r.by); gr.addColorStop(0, "#9aa0a6"); gr.addColorStop(1, "#5c6168"); ctx.fillStyle = gr; path.call(); ctx.fill()
		ctx.save(); path.call(); ctx.clip()
		for q in Y.stones[gi]:
			ctx.strokeStyle = "rgba(255,255,255,.13)" if q[3] > 0.5 else "rgba(30,30,40,.16)"; ctx.lineWidth = 1.6 * u
			var sx = x + q[0] * w; var sy = y + q[1] * h; ctx.beginPath(); ctx.moveTo(sx, sy); ctx.lineTo(sx + 10 * u, sy + q[2] * 10 * u); ctx.stroke()
		ctx.fillStyle = "rgba(80,110,60,.5)"; ctx.beginPath(); ctx.ellipse(x + w * 0.2, r.by - 7 * u, 9 * u, 4 * u, 0, 0, PI * 2); ctx.fill()
		ctx.restore()
		ctx.strokeStyle = "#26232a"; ctx.lineWidth = 2.4 * u; path.call(); ctx.stroke()
		ctx.fillStyle = "#4a4e55"; ctx.fillRect(x - 5 * u, r.by - 7 * u, w + 10 * u, 7 * u); ctx.strokeRect(x - 5 * u, r.by - 7 * u, w + 10 * u, 7 * u)
	var name = J.str(g.name)
	if tab != null:
		var n = name.length(); var fs = minf(tab.w * 0.62, (tab.bot - tab.top) / (n + 0.6))
		ctx.font = "900 %spx \"Songti TC\",\"Noto Serif CJK TC\",serif" % J.str(fs); ctx.textAlign = "center"; ctx.textBaseline = "middle"
		var y1 = (tab.top + tab.bot) / 2 - (n - 1) * fs * 0.52
		for k in n:
			var yy = y1 + k * fs * 1.04; ctx.fillStyle = "rgba(255,255,255,.3)"; ctx.fillText(name[k], tab.cx + 0.7, yy + 0.7); ctx.fillStyle = "#8a1e16"; ctx.fillText(name[k], tab.cx, yy)
		ctx.textBaseline = "alphabetic"
	else:
		var fs = J.round(12.5 * u); ctx.font = "900 %spx \"Songti TC\",\"Noto Serif CJK TC\",serif" % J.str(fs); ctx.textAlign = "center"
		for k in name.length():
			var yy = r.y + 20 * u + k * (fs + 1); ctx.fillStyle = "rgba(255,255,255,.25)"; ctx.fillText(name[k], r.cx + 0.8, yy + 0.8); ctx.fillStyle = "#1e1c22"; ctx.fillText(name[k], r.cx, yy)
	if tab == null:
		for k in range(-1, 2):
			var hx = r.cx + k * 5 * u - r.w * 0.66; var hy = r.by + 2 * u
			ctx.strokeStyle = "#b8742a"; ctx.lineWidth = 1.4 * u; ctx.beginPath(); ctx.moveTo(hx, hy); ctx.lineTo(hx + k * 1.5 * u, hy - 14 * u); ctx.stroke()
			ctx.fillStyle = "rgba(255,%s,60,.95)" % J.str(120 + 60 * sin(t * 5 + k + gi)); ctx.beginPath(); ctx.arc(hx + k * 1.5 * u, hy - 14 * u, 1.6 * u, 0, PI * 2); ctx.fill()
	if view: ctx.strokeStyle = "rgba(255,230,140,.9)"; ctx.lineWidth = 2.5; ctx.beginPath(); ctx.roundRect(r.x - 6 * u, r.y - 6 * u, r.w + 12 * u, r.h + 8 * u, 10 * u); ctx.stroke()
	if J.t(g.get("off")):
		var fs = maxf(11.0, J.round(11.5 * u)); ctx.font = "800 %spx \"PingFang TC\",\"Noto Sans CJK TC\",sans-serif" % J.str(fs); ctx.textAlign = "center"; ctx.textBaseline = "middle"
		var txt = "祭品・" + J.str(g.off); var tw = J.num(ctx.measureText(txt).width) + 12 * u; var th = fs + 8 * u; var ty = r.by + 10 * u + th / 2
		ctx.fillStyle = "rgba(250,240,214,.94)"; ctx.strokeStyle = "#6b4a2b"; ctx.lineWidth = 1.6 * u; ctx.beginPath(); ctx.roundRect(r.cx - tw / 2, ty - th / 2, tw, th, 5 * u); ctx.fill(); ctx.stroke()
		ctx.fillStyle = "#3a2614"; ctx.fillText(txt, r.cx, ty + 0.5); ctx.textBaseline = "alphabetic"
	ctx.restore()

static func draw_soul(ctx: Ctx, s: Dictionary, t: float, rest_k: float) -> void:
	var u = unit(); var hh = soul_h(); var dr = Y.get("drag")
	var d = dr if J.t(dr) and is_same(dr.s, s) and J.t(dr.moved) else null
	var p = pt(J.num(s.x), J.num(s.y)); var x = p.x; var y = p.y
	if d != null: x = J.num(d.mx); y = J.num(d.my) + 18 * u
	var pose = "idle"; var ptv = 0.0; var alpha = J.num(s.a); var lift = 0.0; var flip = false
	if d != null: pose = "move"
	if s.place != null: flip = true
	var rx = s.get("rx")
	if J.t(rx) and J.num(rx.t) >= 0: pose = "hurt"; ptv = minf(1.0, J.num(rx.t) / J.num(rx.dur)); x += sin(J.num(rx.t) * 40) * 3 * u * (1 - ptv)
	if rest_k > 0: pose = "cast"; ptv = rest_k; lift = rest_k * rest_k * hh * 1.6; alpha = J.num(s.a) * (1 - maxf(0.0, (rest_k - 0.45) / 0.55))
	s["px"] = x; s["py"] = y
	if alpha <= 0.01: return
	var selm = Y.sel != null and J.num(Y.sel) == J.num(s.i)
	var g = ctx.createRadialGradient(x, y - hh * 0.5 - lift, 2, x, y - hh * 0.5 - lift, hh * (0.75 + rest_k * 0.8))
	g.addColorStop(0, rgba(s.col, (0.55 if selm else 0.3) * alpha + rest_k * 0.3)); g.addColorStop(1, rgba(s.col, 0))
	ctx.globalCompositeOperation = "lighter"; ctx.fillStyle = g; ctx.beginPath(); ctx.arc(x, y - hh * 0.5 - lift, hh * (0.75 + rest_k * 0.8), 0, PI * 2); ctx.fill(); ctx.globalCompositeOperation = "source-over"
	if selm: ctx.strokeStyle = rgba(s.col, 0.9); ctx.lineWidth = 2.5; ctx.setLineDash([5, 4]); ctx.beginPath(); ctx.ellipse(x, y, hh * 0.4, hh * 0.11, 0, 0, PI * 2); ctx.stroke(); ctx.setLineDash([])
	Art.draw_char(ctx, "youhun", x, y - lift, hh / 50, {"t": t * (1.5 if pose == "hurt" else 1.0) + J.num(s.ph), "pose": pose, "pt": ptv, "flip": flip, "alpha": alpha, "shadow": false})
	var ty = y - hh * 1.1 - lift + sin(t * 2 + J.num(s.ph)) * 3 * u; var r = 13 * u
	ctx.globalAlpha = minf(1.0, alpha * 1.15)
	ctx.fillStyle = "rgba(14,10,20,.85)"; ctx.beginPath(); ctx.arc(x, ty, r, 0, PI * 2); ctx.fill(); ctx.strokeStyle = s.col; ctx.lineWidth = 2.2; ctx.stroke()
	ctx.font = "900 %spx sans-serif" % J.str(J.round(18 * u)); ctx.textAlign = "center"; ctx.textBaseline = "middle"; ctx.fillStyle = s.col; ctx.fillText(s.tag, x, ty + 1); ctx.textBaseline = "alphabetic"
	ctx.globalAlpha = 1

static func rgba(hex, a: float) -> String:
	var v = J.str(hex).substr(1).hex_to_int()
	return "rgba(%d,%d,%d,%s)" % [v >> 16 & 255, v >> 8 & 255, v & 255, J.str(clampf(a, 0.0, 1.0))]

static func bubble(ctx: Ctx, text: String, x: float, y: float, a: float) -> void:
	var u = unit(); ctx.save(); ctx.globalAlpha = a; ctx.font = "700 %spx sans-serif" % J.str(J.round(14 * u))
	var maxw = J.num(Y.W) * 0.62; var lines = []; var cur = ""
	for ch in text:
		if J.num(ctx.measureText(cur + ch).width) > maxw: lines.append(cur); cur = ch
		else: cur += ch
	lines.append(cur)
	var lh = 19 * u; var mw = 0.0
	for l in lines: mw = maxf(mw, J.num(ctx.measureText(l).width))
	var w = mw + 18; var h = lines.size() * lh + 12; var bx = maxf(6.0, minf(J.num(Y.W) - w - 6, x - 20)); var by = y - h
	ctx.fillStyle = "rgba(255,250,236,.95)"; ctx.strokeStyle = "#3a2a1a"; ctx.lineWidth = 1.5; ctx.beginPath(); ctx.roundRect(bx, by, w, h, 9); ctx.fill(); ctx.stroke()
	ctx.beginPath(); ctx.moveTo(x - 6, by + h); ctx.lineTo(x - 2, by + h + 9); ctx.lineTo(x + 6, by + h); ctx.fill()
	ctx.fillStyle = "#2a1a10"; ctx.textAlign = "left"
	for i in lines.size(): ctx.fillText(lines[i], bx + 9, by + 6 + lh * (i + 0.78))
	ctx.restore()

# ================= 登記 =================
func run(_env) -> void:
	J.G["GY_SPOTS"] = GY_SPOTS.duplicate(true)
	J.G["GY_TOMB_TAB"] = GY_TOMB_TAB.duplicate(true)
	J.G["GY_TAGS"] = GY_TAGS.duplicate()
	J.G["GY_LEVELS"] = GY_LEVELS.duplicate(true)
	J.G["GY_JOBS"] = GY_JOBS.duplicate(true)
	J.G["GY_OFFERS"] = GY_OFFERS.duplicate()
	J.G["GY_SURN"] = GY_SURN.duplicate()
	J.G["GY_GIVEN"] = GY_GIVEN.duplicate()
	J.G["GY_DEC"] = GY_DEC.duplicate()
	J.G["GY_TPL"] = GY_TPL.duplicate(true)
	J.G["GY_ROWW"] = GY_ROWW.duplicate()
	J.G["GY_SIDEW"] = GY_SIDEW.duplicate()
	J.G["GY_COLORS"] = GY_COLORS.duplicate()
	J.G["GY_ALPHA"] = GY_ALPHA.duplicate()
	J.G["GY_RULES"] = GY_RULES.duplicate(true)
	J.G["GY_GEN"] = {
		"rng": func(_t, a): var r = Rng.new(J.num(J.arg(a, 0))); return func(_t2 = null, _a2 = null): return r.next(),
		"levelOf": func(_t, a): return float(level_of(J.num(J.arg(a, 0)))),
		"holds": func(_t, a): return holds(J.arg(a, 0), J.arg(a, 1), J.arg(a, 2)),
		"solve": func(_t, a): return solve(int(J.num(J.arg(a, 0))), J.arg(a, 1), J.arg(a, 2), int(J.num(J.arg(a, 3)))),
		"gen": func(_t, a): return gen(J.num(J.arg(a, 0)), J.num(J.arg(a, 1))),
		"card": func(_t, a): return card(J.arg(a, 0)),
	}
	J.G["__gyDC"] = func(_t, a): Art.draw_char(J.arg(a, 0), J.str(J.arg(a, 1)), J.num(J.arg(a, 2)), J.num(J.arg(a, 3)), J.num(J.arg(a, 4)), (J.arg(a, 5) as Dictionary).duplicate() if J.arg(a, 5) is Dictionary else {}); return null
	Y = {
		"active": false,
		"_nd": func(_t, _a): draw(J.num(Y.get("t", 0.0))); return null,
		"ensure": func(_t, _a): return ensure(),
		"open": func(_t, _a): open_(); return null,
		"close": func(_t, _a): close(); return null,
		"hint": func(_t, a): hint(J.str(J.arg(a, 0)), J.num(J.arg(a, 1)) if J.t(J.arg(a, 1)) else 6.0); return null,
		"resize": func(_t, _a): resize(); return null,
		"bgScale": func(_t, _a): return bg_scale(),
		"unit": func(_t, _a): return unit(),
		"down": func(_t, a): down(J.arg(a, 0)); return null,
		"move": func(_t, a): move(J.arg(a, 0)); return null,
		"up": func(_t, a): up(J.arg(a, 0)); return null,
		"place": func(_t, a): place(int(J.num(J.arg(a, 0))), int(J.num(J.arg(a, 1)))); return null,
		"allPlaced": func(_t, _a): return all_placed(),
		"correct": func(_t, _a): return float(correct()),
		"submit": func(_t, _a): submit(); return null,
		"say": func(_t, a): say(J.str(J.arg(a, 0)), J.num(J.arg(a, 1)) if J.t(J.arg(a, 1)) else 3.0); return null,
		"rest": func(_t, _a): rest(); return null,
		"finish": func(_t, a): finish(J.t(J.arg(a, 0)), int(J.num(J.arg(a, 1)))); return null,
		"renderPanel": func(_t, _a): render_panel(); return null,
		"step": func(_t, a): step(J.num(J.arg(a, 0))); return null,
		"draw": func(_t, a): draw(J.num(J.arg(a, 0))); return null,
		"rgba": func(_t, a): return rgba(J.arg(a, 0), J.num(J.arg(a, 1))),
	}
	J.G["Graveyard"] = Y
