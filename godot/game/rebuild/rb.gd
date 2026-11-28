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

const ORDER := ["house", "wood", "rice", "furnace"]   # 虛擬任務帶住修（化寶爐排第 4：前期冥幣來源）
const LATER := ["plank", "bun", "store", "home", "altar", "camp"]   # 跟舊建造流程（建築卡「建造」）：要先清雜物，起完搭棚再開張
const ALL := ORDER + LATER
# 每棟雜物堆：相對建築位置（x, y 偏移）同款式
const PILES := {
	"house": [[-62, 18, "weed"], [58, 22, "rubble"], [-34, 46, "coffin"], [30, 52, "paper"], [0, 74, "lantern"]],
	"wood": [[-40, 26, "weed"], [36, 30, "rubble"], [-12, 54, "coffin"], [44, -10, "weed"]],
	"rice": [[-38, 26, "weed"], [40, 24, "paper"], [8, 52, "rubble"], [-44, -8, "weed"]],
	"furnace": [[-26, 22, "paper"], [24, 26, "rubble"], [0, 46, "lantern"]],
	"plank": [[-40, 24, "coffin"], [38, 26, "rubble"], [0, 48, "weed"]],
	"bun": [[-38, 24, "weed"], [40, 26, "paper"], [0, 48, "rubble"]],
	"store": [[-44, 24, "rubble"], [42, 28, "coffin"], [0, 50, "weed"]],
	"home": [[-38, 24, "weed"], [36, 26, "rubble"]],
	"altar": [[-36, 24, "paper"], [36, 26, "lantern"], [0, 46, "weed"]],
	"camp": [[-38, 24, "rubble"], [38, 26, "weed"]],
}
const HITS := 3
const FIX_SEC := 4.0
const FIX_SEC_LATER := 8.0
const COST := {"house": {}, "wood": {"coins": 6.0}, "rice": {"wood": 6.0}, "furnace": {"wood": 10.0, "coins": 10.0}}
# 舊建造流程（BUILDINGS.build）在荒村存檔的修復費（設計 v1 第十一節）；冇列嘅照舊
const LATER_COST := {"home": {"planks": 30.0}, "store": {"planks": 40.0}, "altar": {"planks": 30.0, "coins": 40.0}}
const DROP := {"weed": ["rice", 1.0, 2.0], "rubble": ["coins", 1.0, 2.0], "coffin": ["wood", 1.0, 3.0], "paper": ["coins", 1.0, 2.0], "lantern": ["coins", 2.0, 3.0]}
const PILE_NAME := {"weed": ["雜草", "雜草"], "rubble": ["瓦礫", "瓦礫"], "coffin": ["爛棺材", "破棺材"], "paper": ["紙紮殘骸", "紙紮殘骸"], "lantern": ["跌落嚟嘅燈籠", "掉下來的燈籠"]}
const OPENING := ["rb_op_hall", "rb_op_soup", "rb_op_exile", "rb_op_arrive"]
# 睡著的名鬼：倉庫瓦礫底下挖出椰子砸死鬼（理由見設計 v1 3.3）
const SLEEPER := {"pile": "store_0", "k": "n30_yezi", "scene": "rb_sleeper"}

static func bname(b: String) -> String:
	var B = J.G.get("BUILDINGS")
	if B is Dictionary and B.get(b) is Dictionary: return J.str(B[b].get("name", b))
	return b

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

static func active() -> bool:   # 荒村存檔、重建仲有嘢做（10 棟未開齊）
	var r = st()
	if not J.t(r.get("on")): return false
	if OS.has_environment("GB_TEST") and not J.t(r.get("test")): return false
	return true
static func on() -> bool: return active() and not J.t(st().get("done"))   # 虛擬任務階段（ORDER 四棟）

# ================= 對外接口（kpi／opening／tavern／juice 用）=================
# opened_count()：村子 10 棟（BLD_ORDER）已開張幾多棟；vitality()：生氣值 0–1（＝開張比例，畫面亮度／遊魂數量可跟）
# all_lit()：全村點燈咗未；listen(fn)：fn.call(kind, arg) — kind：open（開張，arg＝建築 id）／relic（舊物件 id）／lit（全村點燈）
# J.G["rb_opening"]（Array）：opening 組可換開場場景 id 次序；未設就用 OPENING
static var _ls: Array = []
static func listen(fn: Callable) -> void: if not (fn in _ls): _ls.append(fn)
static func _emit(kind: String, arg) -> void:
	for f in _ls: if f.is_valid(): f.call(kind, arg)
static func opened_count() -> int:
	var s = S(); var n := 0
	if s == null: return 0
	var BO = J.G.get("BLD_ORDER")
	for b in (BO if BO is Array else ORDER): if J.num(s.bld.get(b, 0)) > 0 and not holds(str(b)): n += 1
	return n
static func vitality() -> float:
	var BO = J.G.get("BLD_ORDER")
	return float(opened_count()) / float(maxi(1, (BO as Array).size() if BO is Array else 10))
static func all_lit() -> bool: return J.t(st().get("lit"))

# ================= 存檔 =================
static func fresh_state() -> Dictionary:
	var piles := {}
	for b in ALL:
		for i in PILES[b].size(): piles["%s_%d" % [b, i]] = float(HITS)
	return {"on": 1.0, "piles": piles, "fix": {}, "open": {}, "found": 0.0, "done": false}

static func migrate(s, fresh: bool) -> void:
	if s == null or not fresh: return
	if OS.has_environment("GB_TEST") or OS.has_environment("GB_NORB"): return   # 其他測試照舊；rebuild_test 自己開（start_fresh）
	start_fresh(s)

static func start_fresh(s: Dictionary, test := false) -> void:
	s["rb"] = fresh_state()
	if test: s.rb["test"] = 1.0
	for b in ALL: s.bld[b] = 0.0
	if not (s.get("cnt") is Dictionary): s["cnt"] = {}

# ================= 雜物堆 =================
static func _pos(b: String) -> Vector2:
	var P = J.G.get("POS")
	if P is Dictionary and P.has(b): return Vector2(float(P[b][0]), float(P[b][1]))
	return Vector2.ZERO

static func piles() -> Array:   # [{id, b, kind, p: Vector2, left}]
	var out := []
	if not active(): return out
	var r = st(); var pl = r.get("piles", {})
	for b in ALL:
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
# [rebuild2] 廢墟前景雜草密度 0.1–1（剩幾多堆雜物）；冇荒村（舊存檔未起嘅地盤）＝0.6
static func weed_k(b: String) -> float:
	if not active() or not PILES.has(b): return 0.6
	return 0.1 + 0.9 * float(left_of(b)) / float(maxi(1, PILES[b].size()))
static func is_open(b: String) -> bool: return J.t(st().get("open", {}).get(b))
static func fixing(b: String) -> bool: return st().get("fix", {}).has(b)
static func fix_left(b: String) -> float: return maxf(0.0, J.num(st().get("fix", {}).get(b, 0)) - J.now() / 1000.0)

# ================= 撳 =================
# 回 true ＝ 食咗呢下（唔再行舊撳邏輯）
static func tap(village, x: float, y: float) -> bool:
	if not active(): return false
	var p = Vector2(x, y)
	var best = null; var bd := 30.0
	for e in piles():
		var d = (e.p as Vector2).distance_to(p + Vector2(0, 6))
		if d < bd: bd = d; best = e
	if best != null: _hit_pile(village, best); return true
	for b in ALL:
		if is_open(b): continue
		var bp = _pos(b)
		var hw = 30.0 if b == "furnace" else 46.0
		if not (absf(x - bp.x) < hw and y > bp.y - 90 and y < bp.y + 14): continue
		if b in ORDER:
			if not on(): continue
			_tap_ruin(village, b); return true
		if fixing(b): _speed(b); return true   # 後段：搭緊棚撳加快
		if not cleared(b):
			_float(bp.x, bp.y - 70, T("周圍啲雜物仲未清（剩 %d 堆）", "周圍的雜物還沒清（剩 %d 堆）") % left_of(b), "#e8d8b0"); return true
		return false   # 清咗：行舊流程（彈建築卡、撳「建造」）
	return false

static func _speed(b: String) -> void:
	var bp = _pos(b); var f = st().fix; f[b] = J.num(f[b]) - 1.0
	_snd("click"); _float(bp.x + randf_range(-26.0, 26.0), bp.y - 92, T("加快！", "加快！"), "#ffe9a8")   # [rebuild2] 唔好同「搭棚修復中」疊埋

# 舊建造流程鈎（native/game.gd n_bld_act、chain_bld.build、ui/main.gd 都叫）：回 true ＝ 荒村接手（唔好再行舊嘅「建好了」）
static func build_hook(b: String) -> bool:
	if not active() or not (b in ALL) or is_open(b): return false
	var bp = _pos(b)
	if b in ORDER:
		_float(bp.x, bp.y - 70, T("清走周圍雜物，再撳廢墟修復", "清掉周圍雜物，再點廢墟修復"), "#e8d8b0"); return true
	if fixing(b): return true
	if not cleared(b):
		_float(bp.x, bp.y - 70, T("周圍啲雜物仲未清（剩 %d 堆）", "周圍的雜物還沒清（剩 %d 堆）") % left_of(b), "#e8d8b0"); return true
	var B = J.G.get("BUILDINGS"); var c = B[b].get("build") if B is Dictionary and B.get(b) is Dictionary else {}
	if c is Dictionary and not c.is_empty():
		if not J.t(J.cl(J.G.get("canPay"), null, [c])): return true
		J.cl(J.G.get("pay"), null, [c])
	st().fix[b] = J.now() / 1000.0 + FIX_SEC_LATER
	_snd("build"); _float(bp.x, bp.y - 70, T("搭棚修復中…", "搭棚修復中…"), "#ffe9a8")
	return true

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
		if str(e.id) == SLEEPER.pile: _sleeper()
		elif randf() < 0.1: _relic(e.p)
		if cleared(b): _float(_pos(b).x, _pos(b).y - 100, T("%s 可以修喇", "%s 可以修了") % bname(b), "#9fe3a0")
	J.mc(J.G.get("Quest"), "check", [])
	J.mc(J.G.get("UI"), "refresh", [])

# 村史館：前任村長留低嘅舊物件（每件一次；集齊有獎）。文案組可改 RELICS 文字
const RELICS := [   # [id, 名（粵）, 名（中）, 說明（粵）, 說明（中）]；文案組可改
	["clock", "生鏽打卡鐘", "生鏽打卡鐘", "指針停喺兩點四十七分。", "指針停在兩點四十七分。"],
	["diary", "前任村長日記殘頁", "前任村長日記殘頁", "「第三百日：KPI 又加咗。」", "「第三百天：KPI 又加了。」"],
	["mahjong", "缺咗一隻嘅麻雀", "缺了一張的麻將", "缺嗰隻係紅中。", "缺的那張是紅中。"],
	["badge", "地府員工證", "地府員工證", "相片位置係一片空白。", "照片的位置是一片空白。"],
	["abacus", "崩齒算盤", "缺珠算盤", "撥嚟撥去都係負數。", "怎麼撥都是負數。"],
	["lantern", "褪色燈籠", "褪色燈籠", "上面寫住「落魄村」三個字。", "上面寫著「落魄村」三個字。"],
	["teacup", "崩口茶杯", "缺口茶杯", "杯底刻住一個「孟」字。", "杯底刻著一個「孟」字。"],
	["seal", "生鏽公章", "生鏽公章", "印出嚟係「已批」。", "蓋出來是「已批」。"],
]
const RELIC_REWARD := {"coins": 200.0, "exp": 60.0}
static func relics() -> Array: return st().get("relics", []) if st().get("relics") is Array else []
static func relic_name(e: Array) -> String: return e[1] if yue() else e[2]
static func relic_desc(e: Array) -> String: return e[3] if yue() else e[4]
static func _relic(p: Vector2) -> void:   # 10% 挖到舊物件（未有嘅先出）
	var r = st()
	if not (r.get("relics") is Array): r["relics"] = []
	var have: Array = r.relics; var left = []
	for e in RELICS: if not (e[0] in have): left.append(e)
	if left.is_empty(): return
	var e = left[randi() % left.size()]
	have.append(e[0]); r["found"] = float(have.size())
	_snd("gong")
	_float(p.x, p.y - 66, T("挖到舊物件：%s（村史館 %d/%d）", "挖到舊物件：%s（村史館 %d/%d）") % [relic_name(e), have.size(), RELICS.size()], "#c9a6ff")
	_note("toast", "<b>%s</b><br>%s" % [relic_name(e), relic_desc(e)])
	if have.size() == RELICS.size():
		var txt = J.str(J.cl(J.G.get("give"), null, [RELIC_REWARD]))
		_note("banner", T("村史館集齊！", "村史館集齊！")); _note("toast", txt)
	_emit("relic", e[0])

# ================= 提示排隊（唔好同劇情／彈窗／其他提示疊埋）=================
static var _notes: Array = []
static var _note_t := -99.0
const NOTE_GAP := 1.6
static func _note(kind: String, text: String) -> void: _notes.append([kind, text])
static func notes_left() -> int: return _notes.size()
static func _busy() -> bool:
	if J.t(J.mc(J.G.get("Story"), "busy", [])): return true
	var UI = J.G.get("UI")
	return UI != null and J.t(J.mc(UI, "modalOpen", []))
static func flush_notes() -> void:
	if _notes.is_empty() or _busy(): return
	var now = Time.get_ticks_msec() / 1000.0
	if now - _note_t < NOTE_GAP: return
	_note_t = now
	var n = _notes.pop_front()
	if n[0] == "banner": _banner(n[1])
	else: J.mc(J.G.get("Fx"), "toast", [n[1]])

# ================= 睡著的名鬼 =================
static func _sleeper() -> void:
	var r = st()
	if J.t(r.get("sleeper")): return
	r["sleeper"] = 1.0
	var k: String = SLEEPER.k
	var GH = J.G.get("GHOSTS")
	var own = false
	for g in S().ghosts: if J.str(g.get("k")) == k: own = true
	if not (GH is Dictionary) or not GH.has(k) or own: return
	add_scenes()
	_snd("gong")
	var p = _pos("store")
	_float(p.x, p.y - 80, T("瓦礫下面有鼻鼾聲……", "瓦礫底下有鼾聲……"), "#c9a6ff")
	J.mc(J.G.get("Story"), "queue", [SLEEPER.scene, func(_t, _a): J.cl(J.G.get("joinGhost"), null, [k]); _emit("sleeper", k); return null])

static func _tap_ruin(village, b: String) -> void:
	var bp = _pos(b)
	if fixing(b): _speed(b); return   # 搭緊棚：撳一下快 1 秒
	if not _turn(b):
		_float(bp.x, bp.y - 70, T("先修好%s", "先修好%s") % bname(_next_b()), "#e8d8b0"); return
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
	for b in ORDER: if not is_open(b): return b
	return ""

# ================= 每 0.5 秒（Quest.check） =================
static func tick() -> void:
	flush_notes()
	_lit_check()
	if not active(): return
	_costs()
	guard()
	var f: Dictionary = st().fix
	for b in f.keys():
		if fix_left(b) <= 0: _open(b)

static func holds(k: String) -> bool: return active() and k in ALL and not is_open(k)

# 荒村期間：ORDER 未開張一律 0（mv_bridge.sync 會拉鬼宅，已跳過 holds；呢度係保險）；
#   LATER 有其他路徑（冇經 build_hook）起咗 → 當開張（唔扣返、唔重複搭棚）
static func guard() -> void:
	var s = S(); var op = st().get("open", {})
	for b in ALL:
		if J.t(op.get(b)) or fixing(b): continue
		if J.num(s.bld.get(b, 0)) == 0.0: continue
		if b in ORDER: s.bld[b] = 0.0
		else: op[b] = 1.0; _emit("open", b)
	for b in st().get("fix", {}): if not (b in ORDER) and J.num(s.bld.get(b, 0)) != 0.0: s.bld[b] = 0.0

static var _cost0 := {}
static func _costs() -> void:   # 荒村存檔：後段修復費（只改一次；存原值）
	var B = J.G.get("BUILDINGS")
	if not (B is Dictionary): return
	for b in LATER_COST:
		if B.get(b) is Dictionary and B[b].get("build") != LATER_COST[b]:
			if not _cost0.has(b): _cost0[b] = B[b].get("build")
			B[b]["build"] = LATER_COST[b].duplicate()

static func _lit_check() -> void:   # 全村 10 棟開張：全村點燈（一次）
	if not ever() or all_lit(): return
	if vitality() < 1.0: return
	st()["lit"] = 1.0
	_snd("gong"); _note("banner", T("全村點燈！落魄村活返嚟喇！", "全村點燈！落魄村活過來了！"))
	_emit("lit", null)

static func _open(b: String) -> void:
	var s = S(); var r = st()
	r.fix.erase(b); r.open[b] = 1.0
	s.bld[b] = maxf(1.0, J.num(s.bld.get(b, 0)))
	_snd("levelUp")
	_note("banner", T("%s 重開！", "%s 重新開張！") % bname(b))
	var bp = _pos(b)
	_float(bp.x, bp.y - 120, "✦ ✦ ✦", "#ffd54a")
	J.cl(J.G.get("gainExp"), null, [15.0])
	_emit("open", b)
	if b in ORDER and _next_b() == "": r["done"] = true; _note("banner", T("荒村重建第一步完成！", "荒村重建第一步完成！"))
	J.mc(J.G.get("Quest"), "check", [])
	J.mc(J.G.get("UI"), "refresh", [])

# ================= 虛擬任務 =================
static func cur_q():
	if not on(): return null
	var b = _next_b()
	if b == "": return null
	if not cleared(b):
		var n = PILES[b].size()
		return {"t": "rb_clear", "b": b, "n": float(n), "rb": true, "go": b, "text": T("清理%s周圍嘅雜物", "清理%s周圍的雜物") % bname(b), "r": {"exp": 8.0}}
	return {"t": "rb_fix", "b": b, "n": 1.0, "rb": true, "go": b, "text": T("修復%s", "修復%s") % bname(b), "r": {"exp": 15.0}}

static func progress(q) -> Array:
	var t = str(J.gp(q, "t"))
	if t == "rb_clear":
		var b = str(q.b); var n = PILES[b].size()
		return [float(n - left_of(b)), float(n)]
	if t == "rb_fix":
		return [1.0 if is_open(str(q.b)) else 0.0, 1.0]
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
	if not active(): return
	guard()
	for e in piles():
		var ee = e
		nv._static("rb_" + str(e.id), (e.p as Vector2).y, [e.left], false, func(ctx): draw_pile(ctx, ee.kind, ee.p, int(ee.left)))
	for b in ALL:
		if fixing(b):
			var bp = _pos(b); var tot = FIX_SEC if b in ORDER else FIX_SEC_LATER
			nv._static("rbf_" + b, bp.y + 2, [int(fix_left(b) * 4)], true, func(ctx): draw_scaffold(ctx, bp, fix_left(b) / tot))

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
	for b in ALL: if _pos(b) == bp: return b
	return ""
static func draw_scaffold(ctx: Ctx, bp: Vector2, frac: float) -> void:
	var key = _fix_b(bp) + "_repair"   # 美術 B 組：修復中（竹棚＋帆布）
	if Spr.ok(key):
		var b = _fix_b(bp); var w = float(Art.BW.get(b, 100)); var sd = ALL.find(b) + 3
		Art.seat(ctx, bp.x, bp.y + 1, w, sd)   # [rebuild2] 同完成版一樣接地：泥地、後景、斜投影、前景（加木料磚堆）
		Art.seat_back(ctx, bp.x, bp.y + 1, w, sd)
		Art.cast(ctx, key, bp.x, bp.y + 2, w)
		Art.put(ctx, key, bp.x, bp.y + 6, w)
		Art.scaffold_front(ctx, bp.x, bp.y + 1, w, sd)
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
	"rb_sleeper": {"style": "talk", "bg": "village", "lines": [
		["旁白", "瓦礫下面傳嚟一陣鼻鼾聲。", "瓦礫底下傳來一陣鼾聲。"],
		["椰子砸死鬼", "……唔好嘈，俾我瞓多五分鐘。", "……別吵，讓我再睡五分鐘。"],
		["阿福", "你喺度瞓咗幾耐？", "你在這裡睡了多久？"],
		["椰子砸死鬼", "由個椰子跌落嚟嗰陣開始。", "從那顆椰子掉下來的時候開始。"],
		["阿福", "村子要重建，你識做啲咩？", "村子要重建，你會做什麼？"],
		["椰子砸死鬼", "瞓覺。仲有，揀邊棵樹底下最唔安全。", "睡覺。還有，分辨哪棵樹底下最不安全。"],
		["旁白", "椰子砸死鬼伸咗個懶腰，決定留低幫手。", "椰子砸死鬼伸了個懶腰，決定留下來幫忙。"]]},
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
	var ids = J.G.get("rb_opening") if J.G.get("rb_opening") is Array and not (J.G.get("rb_opening") as Array).is_empty() else OPENING
	return J.t(J.gp(seen, "prologue_sys")) and not J.t(J.gp(seen, str(ids.back())))
static func queue_opening() -> void:
	add_scenes(); _op_q = true
	var St = J.G.get("Story")
	var ids = J.G.get("rb_opening") if J.G.get("rb_opening") is Array else OPENING
	for id in ids: J.mc(St, "queue", [id])
