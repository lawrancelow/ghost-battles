# [rebuild] 荒村重建（大排檔前大更新 P1；設計：docs/PreStall_Design_v1.md）
# 冇 class_name、冇 autoload（熱更新規矩）：用 load("res://game/rebuild/rb.gd") 叫 static func。
#
# 做咩：
#  1. 新存檔（真玩家；GB_TEST 下要 S.rb.test＝1 先開）開局：鬼宅、伐木場、糯米田全部係廢墟（S.bld = 0）。
#  2. 每棟周圍散落雜物堆（雜草、瓦礫、破棺材、紙紮殘骸）：撳幾下清走，每下跳資源字＋音效，清完一堆金光。
#  3. 三步重建：① 清理周圍雜物 ② 交少量材料修復（搭棚 4 秒，撳棚架每下 -1 秒）③ 開張（外觀變新＋大字）。
#  4. 虛擬任務（排喺正式主線 QUESTS 之前，唔郁 S.qi）：清理鬼宅 → 修復鬼宅 → 清理伐木場 → 修復 → 清理糯米田 → 修復；做完先入正式主線。
#  5. 開場劇情接口：OPENING（地府→孟婆湯→流放→荒村）佔位文本，文案組 story_v1.md 交咗再換。
#  6. 舊存檔：S.rb 冇 on ＝ 完全唔受影響。
extends RefCounted

const ORDER := ["house", "wood", "rice"]
# 每棟雜物堆：相對建築位置（x, y 偏移）同款式
const PILES := {
	"house": [[-62, 18, "weed"], [58, 22, "rubble"], [-34, 46, "coffin"], [30, 52, "paper"], [0, 74, "lantern"]],
	"wood": [[-40, 26, "weed"], [36, 30, "rubble"], [-12, 54, "coffin"], [44, -10, "weed"]],
	"rice": [[-38, 26, "weed"], [40, 24, "paper"], [8, 52, "rubble"], [-44, -8, "weed"]],
}
const HITS := 3
const FIX_SEC := 4.0
const COST := {"house": {}, "wood": {"coins": 6.0}, "rice": {"wood": 6.0}}
const DROP := {"weed": ["rice", 1.0, 2.0], "rubble": ["coins", 1.0, 2.0], "coffin": ["wood", 1.0, 3.0], "paper": ["coins", 1.0, 2.0], "lantern": ["coins", 2.0, 3.0]}
const PILE_NAME := {"weed": ["雜草", "雜草"], "rubble": ["瓦礫", "瓦礫"], "coffin": ["爛棺材", "破棺材"], "paper": ["紙紮殘骸", "紙紮殘骸"], "lantern": ["跌落嚟嘅燈籠", "掉下來的燈籠"]}
const BNAME := {"house": "鬼宅", "wood": "伐木場", "rice": "糯米田"}
const OPENING := ["rb_op_hall", "rb_op_soup", "rb_op_exile", "rb_op_arrive"]

static func S():
	var s = J.G.get("S")
	return s if s is Dictionary else null
static func yue() -> bool: return DB.lang == "yue"
static func T(y: String, z: String) -> String: return y if yue() else z

static func st() -> Dictionary:
	var s = S()
	if s == null: return {}
	var r = s.get("rb")
	return r if r is Dictionary else {}

static func ever() -> bool: return J.t(st().get("on"))   # 呢個存檔用新荒村開局（做完都係）

static func on() -> bool:
	var r = st()
	if not J.t(r.get("on")): return false
	if OS.has_environment("GB_TEST") and not J.t(r.get("test")): return false
	return not J.t(r.get("done"))

# ================= 存檔 =================
static func fresh_state() -> Dictionary:
	var piles := {}
	for b in ORDER:
		for i in PILES[b].size(): piles["%s_%d" % [b, i]] = float(HITS)
	return {"on": 1.0, "piles": piles, "fix": {}, "open": {}, "found": 0.0, "done": false}

static func migrate(s, fresh: bool) -> void:
	if s == null or not fresh: return
	if OS.has_environment("GB_TEST") or OS.has_environment("GB_NORB"): return   # 其他測試照舊；rebuild_test 自己開（start_fresh）
	start_fresh(s)

static func start_fresh(s: Dictionary, test := false) -> void:
	s["rb"] = fresh_state()
	if test: s.rb["test"] = 1.0
	for b in ORDER: s.bld[b] = 0.0
	if not (s.get("cnt") is Dictionary): s["cnt"] = {}

# ================= 雜物堆 =================
static func _pos(b: String) -> Vector2:
	var P = J.G.get("POS")
	if P is Dictionary and P.has(b): return Vector2(float(P[b][0]), float(P[b][1]))
	return Vector2.ZERO

static func piles() -> Array:   # [{id, b, kind, p: Vector2, left}]
	var out := []
	if not on(): return out
	var r = st(); var pl = r.get("piles", {})
	for b in ORDER:
		var bp = _pos(b)
		for i in PILES[b].size():
			var id = "%s_%d" % [b, i]
			var left = J.num(pl.get(id, 0))
			if left <= 0: continue
			var e = PILES[b][i]
			out.append({"id": id, "b": b, "kind": e[2], "p": bp + Vector2(float(e[0]), float(e[1])), "left": left})
	return out

static func left_of(b: String) -> int:
	var n := 0
	var pl = st().get("piles", {})
	for i in PILES[b].size(): if J.num(pl.get("%s_%d" % [b, i], 0)) > 0: n += 1
	return n

static func cleared(b: String) -> bool: return left_of(b) == 0
static func is_open(b: String) -> bool: return J.t(st().get("open", {}).get(b)) or (S() != null and J.num(S().bld.get(b, 0)) > 0 and not on())
static func fixing(b: String) -> bool: return st().get("fix", {}).has(b)
static func fix_left(b: String) -> float: return maxf(0.0, J.num(st().get("fix", {}).get(b, 0)) - J.now() / 1000.0)

# ================= 撳 =================
# 回 true ＝ 食咗呢下（唔再行舊撳邏輯）
static func tap(village, x: float, y: float) -> bool:
	if not on(): return false
	var p = Vector2(x, y)
	var best = null; var bd := 30.0
	for e in piles():
		var d = (e.p as Vector2).distance_to(p + Vector2(0, 6))
		if d < bd: bd = d; best = e
	if best != null: _hit_pile(village, best); return true
	for b in ORDER:
		if J.num(S().bld.get(b, 0)) > 0: continue
		var bp = _pos(b)
		if absf(x - bp.x) < 46 and y > bp.y - 90 and y < bp.y + 14:
			_tap_ruin(village, b); return true
	return false

static func _float(x: float, y: float, txt: String, col := "#ffe9a8") -> void: J.mc(J.G.get("Fx"), "float", [x, y, txt, col])
static func _snd(n: String) -> void: J.mc(J.G.get("Sound"), "play", [n])
static func _banner(t: String) -> void: J.mc(J.G.get("Fx"), "banner", [t])

static func _hit_pile(village, e: Dictionary) -> void:
	var s = S(); var pl = st().piles
	var left = J.num(pl.get(e.id, 0)) - 1.0
	pl[e.id] = left
	if village != null: J.mc(village, "walkTo", [(e.p as Vector2).x + 18, (e.p as Vector2).y + 4, null])
	var dr = DROP.get(e.kind, ["coins", 1.0, 1.0])
	var amt = float(randi_range(int(dr[1]), int(dr[2])))
	s.res[dr[0]] = J.num(s.res.get(dr[0], 0)) + amt
	var RN = J.G.get("RES_NAMES")
	var rn = str(RN.get(dr[0], dr[0])) if RN is Dictionary else str(dr[0])
	_snd("chop" if e.kind in ["coffin", "weed"] else "click")
	_float((e.p as Vector2).x, (e.p as Vector2).y - 26, "+%d %s" % [int(amt), rn])
	load("res://game/onboard/ob.gd").bump("rb_hit")
	if left <= 0:
		_snd("coin")
		var b = str(e.b)
		var n = PILES[b].size(); var done = n - left_of(b)
		_float((e.p as Vector2).x, (e.p as Vector2).y - 46, T("清走咗%s！%d/%d", "清掉了%s！%d/%d") % [PILE_NAME[e.kind][0 if yue() else 1], done, n], "#ffd54a")
		if randf() < 0.1: _relic(e.p)
		if cleared(b): _float(_pos(b).x, _pos(b).y - 100, T("%s 可以修喇", "%s 可以修了") % BNAME[b], "#9fe3a0")
	J.mc(J.G.get("Quest"), "check", [])
	J.mc(J.G.get("UI"), "refresh", [])

static func _relic(p: Vector2) -> void:   # 10% 挖到舊物件（村史館收集，P2 先有收集冊；而家記數＋跳字）
	var r = st(); r["found"] = J.num(r.get("found", 0)) + 1.0
	_float(p.x, p.y - 66, T("挖到舊物件！", "挖到舊物件！"), "#c9a6ff")

static func _tap_ruin(village, b: String) -> void:
	var bp = _pos(b)
	if fixing(b):   # 搭緊棚：撳一下快 1 秒
		var f = st().fix; f[b] = J.num(f[b]) - 1.0
		_snd("click"); _float(bp.x, bp.y - 70, T("加快！", "加快！"), "#ffe9a8")
		return
	if not _turn(b):
		_float(bp.x, bp.y - 70, T("先修好%s", "先修好%s") % BNAME[_next_b()], "#e8d8b0"); return
	if not cleared(b):
		_float(bp.x, bp.y - 70, T("周圍啲雜物仲未清（剩 %d 堆）", "周圍的雜物還沒清（剩 %d 堆）") % left_of(b), "#e8d8b0"); return
	var c: Dictionary = COST[b]
	for k in c:
		if J.num(S().res.get(k, 0)) < J.num(c[k]):
			var RN = J.G.get("RES_NAMES")
			_float(bp.x, bp.y - 70, T("修復要 %s %d（而家 %d）", "修復需要 %s %d（現有 %d）") % [str(RN.get(k, k)) if RN is Dictionary else k, int(c[k]), int(J.num(S().res.get(k, 0)))], "#ff9a9a")
			return
	for k in c: S().res[k] = J.num(S().res[k]) - J.num(c[k])
	st().fix[b] = J.now() / 1000.0 + FIX_SEC
	_snd("build")
	_float(bp.x, bp.y - 70, T("搭棚修復中…", "搭棚修復中…"), "#ffe9a8")
	if village != null: J.mc(village, "walkTo", [bp.x + 30, bp.y + 6, null])

static func _turn(b: String) -> bool: return _next_b() == b
static func _next_b() -> String:
	for b in ORDER: if J.num(S().bld.get(b, 0)) <= 0: return b
	return ""

# ================= 每 0.5 秒（Quest.check） =================
static func tick() -> void:
	if not on(): return
	guard()
	var f: Dictionary = st().fix
	for b in f.keys():
		if fix_left(b) <= 0: _open(b)

static func holds(k: String) -> bool: return on() and k in ORDER and not J.t(st().get("open", {}).get(k))

# 重建期間三棟由 rb 話事：未開張嘅一律保持 0（移動村 mv_bridge.sync 會將鬼宅拉到 ≥2，已加 holds() 例外；呢度係保險）
static func guard() -> void:
	var s = S(); var op = st().get("open", {})
	for b in ORDER:
		if not J.t(op.get(b)) and J.num(s.bld.get(b, 0)) != 0.0: s.bld[b] = 0.0

static func _open(b: String) -> void:
	var s = S(); var r = st()
	r.fix.erase(b); r.open[b] = 1.0
	s.bld[b] = 1.0
	_snd("levelUp")
	_banner(T("%s 重開！", "%s 重新開張！") % BNAME[b])
	var bp = _pos(b)
	_float(bp.x, bp.y - 120, "✦ ✦ ✦", "#ffd54a")
	if _next_b() == "": r["done"] = true; _banner(T("荒村重建第一步完成！", "荒村重建第一步完成！"))
	J.mc(J.G.get("UI"), "refresh", [])

# ================= 虛擬任務 =================
static func cur_q():
	if not on(): return null
	var b = _next_b()
	if b == "": return null
	if not cleared(b):
		var n = PILES[b].size()
		return {"t": "rb_clear", "b": b, "n": float(n), "rb": true, "go": b, "text": T("清理%s周圍嘅雜物", "清理%s周圍的雜物") % BNAME[b], "r": {"exp": 8.0}}
	return {"t": "rb_fix", "b": b, "n": 1.0, "rb": true, "go": b, "text": T("修復%s", "修復%s") % BNAME[b], "r": {"exp": 15.0}}

static func progress(q) -> Array:
	var t = str(J.gp(q, "t"))
	if t == "rb_clear":
		var b = str(q.b); var n = PILES[b].size()
		return [float(n - left_of(b)), float(n)]
	if t == "rb_fix":
		return [1.0 if J.num(S().bld.get(str(q.b), 0)) > 0 else 0.0, 1.0]
	return []

static func complete(q) -> void:
	var txt = J.str(J.cl(J.G.get("give"), null, [q.get("r", {})]))
	_snd("coin")
	J.mc(J.G.get("Fx"), "toast", [T("任務完成：%s<br><b>%s</b>", "任務完成：%s<br><b>%s</b>") % [str(q.text), txt]])
	J.cl(J.G.get("save"), null, [])
	J.mc(J.G.get("UI"), "refresh", [])

# ================= 畫（nv_village._sync_statics 叫） =================
const PCOL := {"weed": Color("#3d4a2a"), "rubble": Color("#5a5048"), "coffin": Color("#5a3a24"), "paper": Color("#8a7a5a"), "lantern": Color("#8a2a22")}
static func statics(nv) -> void:
	if not on(): return
	guard()
	for e in piles():
		var ee = e
		nv._static("rb_" + str(e.id), (e.p as Vector2).y, [e.left], false, func(ctx): draw_pile(ctx, ee.kind, ee.p, int(ee.left)))
	for b in ORDER:
		if fixing(b):
			var bp = _pos(b)
			nv._static("rbf_" + b, bp.y + 2, [int(fix_left(b) * 4)], true, func(ctx): draw_scaffold(ctx, bp, fix_left(b) / FIX_SEC))

static func draw_pile(ctx: Ctx, kind: String, p: Vector2, left: int) -> void:
	var key = "rb_pile_" + kind   # 美術組交圖之後用圖（同名 key）
	var tex = Spr.get_tex(key)
	var k = 0.55 + 0.15 * left
	if tex != null:
		var w = 46.0 * k; var h = w * tex.get_height() / tex.get_width()
		ctx.drawImage(tex, p.x - w / 2, p.y - h + 4, w, h); return
	var c: Color = PCOL.get(kind, Color("#555"))
	ctx.fillStyle = "rgba(0,0,0,.28)"; ctx.beginPath(); ctx.ellipse(p.x, p.y + 2, 20 * k, 6 * k, 0, 0, TAU); ctx.fill()
	ctx.fillStyle = "#" + c.to_html(false); ctx.beginPath(); ctx.ellipse(p.x, p.y - 6 * k, 18 * k, 11 * k, 0, 0, TAU); ctx.fill()
	ctx.fillStyle = "#" + c.lightened(0.25).to_html(false); ctx.beginPath(); ctx.ellipse(p.x - 5 * k, p.y - 11 * k, 9 * k, 6 * k, 0, 0, TAU); ctx.fill()
	ctx.strokeStyle = "#" + c.darkened(0.35).to_html(false); ctx.lineWidth = 1.6
	for i in 5:
		var a = -2.5 + i * 0.5
		ctx.beginPath(); ctx.moveTo(p.x + (i - 2) * 6 * k, p.y - 6 * k); ctx.lineTo(p.x + (i - 2) * 6 * k + cos(a) * 10 * k, p.y - 6 * k + sin(a) * 12 * k); ctx.stroke()

static func _fix_b(bp: Vector2) -> String:
	for b in ORDER: if _pos(b) == bp: return b
	return ""
static func draw_scaffold(ctx: Ctx, bp: Vector2, frac: float) -> void:
	var key = _fix_b(bp) + "_repair"   # 美術 B 組：修復中（竹棚＋帆布）
	if Spr.ok(key):
		Art.put(ctx, key, bp.x, bp.y + 6, float(Art.BW.get(_fix_b(bp), 100)))
	else:
		ctx.strokeStyle = "#a07a4a"; ctx.lineWidth = 3
		for i in 4:
			var x = bp.x - 45 + i * 30
			ctx.beginPath(); ctx.moveTo(x, bp.y + 4); ctx.lineTo(x, bp.y - 90); ctx.stroke()
		for j in 3:
			var y = bp.y - 20 - j * 30
			ctx.beginPath(); ctx.moveTo(bp.x - 50, y); ctx.lineTo(bp.x + 50, y); ctx.stroke()
	# 進度條
	ctx.fillStyle = "rgba(20,12,8,.8)"; ctx.fillRect(bp.x - 34, bp.y - 108, 68, 8)
	ctx.fillStyle = "#ffd54a"; ctx.fillRect(bp.x - 33, bp.y - 107, 66 * clampf(1.0 - frac, 0, 1), 6)

# ================= 開場劇情接口（佔位；文案組 story_v1.md 交咗再換文本） =================
const SC := {
	"rb_op_hall": {"style": "story", "bg": "hq", "lines": [["白無常", "（佔位）到喇，老細喺入面等緊你。", "（佔位）到了，老闆在裡面等你。"]]},
	"rb_op_soup": {"style": "story", "bg": "road", "lines": [["孟婆", "（佔位）飲咗碗湯先，乖。", "（佔位）先把這碗湯喝了，乖。"]]},
	"rb_op_exile": {"style": "story", "bg": "hq", "lines": [["地府老闆", "（佔位）你咁鍾意揀飲揀食，就去落魄村做村長！", "（佔位）你這麼挑嘴，就去落魄村當村長！"]]},
	"rb_op_arrive": {"style": "story", "bg": "village", "lines": [["旁白", "（佔位）落魄村……全村都係廢墟。", "（佔位）落魄村……整條村都是廢墟。"]]},
}
static var _scn_done := false
static func add_scenes() -> void:
	if _scn_done: return
	_scn_done = true
	var SCN = DB.D.get("SCENES"); var JS = J.G.get("SCENES")
	var ZH = DB.D.get("LANG_ZH")
	if not (ZH is Dictionary): ZH = {}; DB.D["LANG_ZH"] = ZH
	var add = {}
	for id in SC:
		var src: Dictionary = SC[id]
		var lines = []
		for l in src.lines:
			lines.append([l[0], l[1]]); add[l[1]] = l[2]
			if not ZH.has(l[1]): ZH[l[1]] = l[2]
		var sc = {"style": src.style, "bg": src.get("bg", "village"), "lines": lines}
		if SCN is Dictionary and not SCN.has(id): SCN[id] = sc
		if JS is Dictionary and JS != SCN and not JS.has(id): JS[id] = sc.duplicate(true)
	var LANG = J.G.get("LANG")
	if LANG != null: J.mc(LANG, "add", [add])

# 序章睇完（prologue_sys）之後，未入荒村前播開場四段（只播一次）
static var _op_q := false
static func opening_due() -> bool:
	if not on() or _op_q: return false
	var s = S(); var seen = s.get("seen", {})
	return J.t(J.gp(seen, "prologue_sys")) and not J.t(J.gp(seen, "rb_op_arrive"))
static func queue_opening() -> void:
	add_scenes(); _op_q = true
	var St = J.G.get("Story")
	for id in OPENING: J.mc(St, "queue", [id])
