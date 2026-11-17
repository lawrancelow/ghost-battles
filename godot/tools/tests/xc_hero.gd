# L1 對照：daily_hero（阿福日常）原生 vs 轉譯版（同一進程；轉譯版另外載一份）
# 畫圖：用錄製器逐格錄低全部畫圖指令（序列化後逐條比）；排程：同一個隨機種子行 update，比 Q 同 opts
# ["gdrun","res://tools/tests/xc_hero.gd","run"]
extends RefCounted

var ok := 0
var bad := 0
var keep := []

static func _ser(r) -> String: return load("res://tools/tests/xc_l4.gd").ser_rec(r)
func _cmp(name: String, x: String, y: String) -> void:
	if x == y: ok += 1; return
	bad += 1
	if bad <= 12:
		var i = 0
		while i < mini(x.length(), y.length()) and x[i] == y[i]: i += 1
		var st = maxi(0, i - 200)
		print("[hdiff] %s @%d/%d,%d\n nat=…%s\n tr =…%s" % [name, i, x.length(), y.length(), x.substr(st, 420), y.substr(st, 420)])

static func _hero_daily() -> Dictionary:
	var o = {}
	for k in J.G.DAILY: if String(k).begins_with("hero_"): o[k] = J.G.DAILY[k]
	return o

# 一段段動作（名, 秒數, 每秒移動）；中途打斷用嚟試淡入（斧頭由地上飛返手、手機收埋）
const SEQ := [["idle", 0.8, 0.0], ["yawn", 3.7, 0.0], ["stretch", 3.7, 0.0], ["scratch", 3.1, 0.0], ["tap", 3.5, 0.0], ["sweat", 2.9, 0.0],
	["dust", 3.1, 0.0], ["proud", 2.3, 0.0], ["phone", 7.7, 0.0], ["idle", 0.6, 0.0], ["phone", 4.0, 0.0], ["walk", 1.2, 40.0],
	["phone", 2.2, 0.0], ["idle", 0.8, 0.0], ["doze", 9.0, 0.0], ["wake", 2.5, 0.0], ["doze", 3.0, 0.0], ["walk", 14.0, 55.0],
	["walk", 6.0, 0.0], ["idle", 1.0, 0.0]]

func _draw_seq(DA: Dictionary, flip: bool, s: float, hid, step: int) -> Array:
	var out = []
	var t = 50.0; var x = 120.0; var y = 600.0
	var H = 98.0 * s
	for sg in SEQ:
		var name: String = sg[0]; var dur: float = sg[1]; var vx: float = sg[2]
		var at = 0.0; var f = 0
		while at < dur:
			var r = Recorder.new(); var ctx = Ctx.new(r, Transform2D.IDENTITY)
			if f % step == 0:
				var o = {"t": t, "at": at}
				if hid != null: o["hid"] = hid
				var sh = func(_tt, aa):
					ctx.beginPath(); ctx.ellipse(J.num(J.arg(aa, 0)), y + s, 14 * s * J.num(J.arg(aa, 1)), 4 * s, 0, 0, 7); ctx.fill(); return null
				var a = {"type": "afu", "x": x, "y": y, "s": s, "H": H, "o": o, "faceRight": not flip, "solid": false, "shadow": sh}
				ctx.save(); var res = J.cl(DA["hero_" + name], null, [ctx, a]); ctx.restore()
				out.append("%s@%.3f %s %s" % [name, at, J.str(res), _ser(r)])
			at += 1.0 / 30; t += 1.0 / 30; f += 1
			x += vx / 30 * (-1.0 if flip else 1.0)
	return out

static func _qser(Q) -> String:
	var o = {}
	for k in Q:
		var v = Q[k]
		if v is Dictionary:
			var kk = v.keys(); kk.sort(); var d = {}
			for z in kk: d[z] = "%.6f" % J.num(v[z])
			o[k] = d
		elif v is float: o[k] = "%.6f" % v
		else: o[k] = v
	return JSON.stringify(o)

# 排程：站住、行路、做嘢（割稻／砍樹／做木板）、proudT 亮起、Story 唔忙
func _sched(HD) -> Array:
	var out = []; seed(4242)
	var V = {"hero": {"x": 200.0, "y": 600.0, "walking": false, "act": null, "target": null}, "proudT": 0.0}
	var dt = 1.0 / 30
	for f in 30 * 400:
		var sec = f / 30
		var H = V.hero
		H["walking"] = (sec % 47) >= 40
		H["act"] = {"kind": "tree" if (sec / 60) % 2 == 0 else "craft"} if (sec % 53) >= 49 else null
		V["proudT"] = 1.0 if (sec % 53) == 50 and (sec / 60) % 3 != 2 else 0.0
		if (sec % 53) == 50 and (sec / 60) % 3 == 2: H["act"] = null   # 做完木板：冇 proud，之後拍灰／擦汗
		J.mc(HD, "update", [V, dt])
		if f % 15 == 7 and J.gp(J.gp(HD, "Q"), "cur") == "doze":
			var hit = J.mc(HD, "tap", [V, 200.0 + (f % 3) * 30, 578.0])
			out.append("tap %s" % J.str(hit))
		if f % 5 == 0: out.append("%d %s %s" % [f, _qser(J.gp(HD, "Q")), JSON.stringify(J.mc(HD, "opts", [V]))])
	return out

func run(_t) -> void:
	ok = 0; bad = 0
	var NH = load("res://native/daily_hero.gd")
	var dn = _hero_daily(); var HDn = J.G.HeroDaily
	var tr = load("res://jsgen/daily_hero.gd").new(); keep.append(tr); tr.run(null)
	var HDt = J.G.HeroDaily; var dt_ = _hero_daily()
	var nat_src = "native" if HDn.has("ACT") and HDn.ACT is Dictionary and not (HDn.ACT.get("walk") is Dictionary) and NH.Q is Dictionary else "?"
	print("[xchero] nat=%s keys n=%d t=%d" % [nat_src, dn.size(), dt_.size()])
	var cases = [[false, 0.72, null, 1], [true, 0.72, "R", 1], [false, 1.6, "B", 3], [true, 0.45, "S", 3]]
	for cs in cases:
		NH.reset(); seed(1)
		var A = _draw_seq(dn, cs[0], cs[1], cs[2], cs[3])
		var tr2 = load("res://jsgen/daily_hero.gd").new(); keep.append(tr2); tr2.run(null); var dt2 = _hero_daily()
		seed(1)
		var B = _draw_seq(dt2, cs[0], cs[1], cs[2], cs[3])
		var nb0 = bad
		if A.size() != B.size(): bad += 1; print("[hdiff] size %d %d" % [A.size(), B.size()])
		for i in mini(A.size(), B.size()): _cmp("case%s f%d %s" % [str(cs), i, A[i].substr(0, 30)], A[i], B[i])
		print("[xchero] draw case=%s frames=%d bad=%d" % [str(cs), A.size(), bad - nb0])
	# 排程
	NH.reset(); var HDn2 = J.G.HeroDaily
	# reset 換咗 Q／LEN：重新登記一次原生介面
	NH.new().run(null); HDn2 = J.G.HeroDaily
	var SA = _sched(HDn2)
	var tr3 = load("res://jsgen/daily_hero.gd").new(); keep.append(tr3); tr3.run(null)
	var SB = _sched(J.G.HeroDaily)
	var nb1 = bad
	if SA.size() != SB.size(): bad += 1; print("[hdiff] sched size %d %d" % [SA.size(), SB.size()])
	for i in mini(SA.size(), SB.size()): _cmp("sched %d" % i, SA[i], SB[i])
	var acts = {}
	for l in SA:
		var m = l.find("\"act\":\"")
		if m >= 0: acts[l.substr(m + 7, l.find("\"", m + 7) - m - 7)] = true
	print("[xchero] sched lines=%d bad=%d acts=%s" % [SA.size(), bad - nb1, str(acts.keys())])
	# 還原原生
	NH.new().run(null)
	print("[xcheck] daily_hero ok=%d bad=%d" % [ok, bad])
