# [story] 移動村（合一地圖大排檔區）劇本接駁：data/nat/mv_story.json（劇本線出內容，本檔只係照住播）
#   - beats：每張圖（ci）一串小故事，每個 beat 一世播一次（S.mv.story_seen[id] = 1 播咗／2 跳過）；
#     只喺 S.mv.ci == 呢張圖 ci 先檢查；主對話（劇情佇列、手機、標題、載入、自檢、彈窗）全部冇嘢先播；
#     同一刻多個達成 → 按陣列次序逐個播（一個播完再等下一格）。
#     when.t：open／unlock k／level k n／sold k('*'或貨 id) n／goal i／boss_next／all_done／inf_below n／wave n／move
#     need：after [id...]（要先播過）、boss_alive（Boss 已打低 → 記做跳過）
#   - move beat：撳拔營之後、拔營動畫之前播（mv_scene.move_next 掛鈎），播完先開始動畫。
#   - 分區地圖劇情（zstory）：when.t == "zone"，kind ∈ map_enter／zone_seen／zone_cap／boss_pre／boss_win／factory／liberate，id＝zones.json 區 id／王 id
#     （factory 可以傳加工廠建築 id，會自動換成所屬資源區；boss_* 可以傳野外區 id，會換成該區而家／啱啱打嗰個王；
#      when 有 z＋bi 嘅話，王 id 對唔上都可以靠「野外區＋第幾個王」對返）。
#     map_enter：分區地圖開咗（ZD.on_for(ci)）就自己播，唔使等事件；未播之前，呢張圖其他 beat（包括大排檔 open）全部等。
#     其他：分區線叫 zone_ev(kind, id[, cb])（static，搵唔到 mv_story 實例都得）或者實例 zone_event(kind, id[, cb])；
#       冇 cb：記入 S.mv.story_zq（存檔），主對話空、唔喺戰鬥、冇彈出卡先逐個播；
#       有 cb（boss_pre）：即刻排入劇情播放器，播完先 call cb（開戰）；冇 beat／播過 → 即刻 call cb。回 true＝cb 會遲啲先 call。
#     舊存檔：已佔領嘅區唔播 zone_seen、已打低嘅王唔播 boss_pre；冇事件就唔補播（只有 map_enter 會補）。
#     line 第 4 格（可選）＝出場條件："has:<鬼 k>"（S.ghosts 有）／"seen:<scene id 或 beat id>"，前面加 "!" 係相反；唔中就成句唔播。
#   - 客人氣泡：outpost.json CUSTOMERS[].say {q 排隊, buy 買到, wait 等太耐, vol 變義勇軍}；冇 say 就用 lines／預設句；
#     同一個客人（cid）唔會連續講同一句；全部經 DB.N()（改名／女主）。
#   - 惡鬼：FOE.head（鬼潮頭目出場）、FOE.roam（遊魂撞圍欄）、FOE.wave（鬼潮預告）；冇就用舊句。
# 用法（mv_scene）：story = load("res://game/outpost/mv_story.gd").new()；_process → story.tick(self, dt)；
#   _eat_events 開頭 → story.eat(self)；move_next → story.before_move(self, instant)。冇 class_name、冇 autoload。
extends RefCounted

const MD = preload("res://game/outpost/mv_data.gd")
const MVW = preload("res://game/outpost/mv_war.gd")
const SIM = preload("res://game/outpost/mv_sim.gd")
const ZD = preload("res://game/zone/zone_data.gd")
const ZKINDS := ["map_enter", "zone_seen", "zone_cap", "boss_pre", "boss_win", "factory", "liberate"]
const PATH := "res://data/nat/mv_story.json"
const CHECK_DT := 0.5          # 幾耐檢查一次觸發
const GAP := 1.2               # 一個 beat 播完，隔幾秒先播下一個
const WAIT_K := 0.55           # 客人喺櫃台等咗 PATIENCE × 呢個比例 → 出「等太耐」氣泡
const BUY_P := 0.5             # 買到貨出氣泡嘅機會
const ROAM_P := 0.5            # 遊魂撞圍欄出氣泡嘅機會
const WAVE_CH := 18            # 鬼潮預告飄字一行最多幾個字（17px × 18 ≈ 306px，畫面 390）

static var _D = null
static var _live = null   # 最近一個喺度 tick 嘅實例（weakref）：zone_ev 用
# 自動播 beat 開關：自動化測試（GB_TEST，其他線嘅測試會直接撳村子／截圖）預設關，免得 beat 蓋住畫面、擋住撳；
# 真玩（冇 GB_TEST）同自檢（GB_SELFTEST：main.selftest 期間本身唔播）照開。storyhook_test 自己打開。
static var auto_on := not OS.has_environment("GB_TEST")

var play_fn: Callable = Callable()   # 測試用：代替劇情播放器 func(scene: Dictionary, cb: Callable)
var busy_fn: Callable = Callable()   # 測試用：代替「主對話忙唔忙」
var pending_move := false            # move beat 播緊（播完先拔營）
var played: Array = []               # 今次運行播過嘅 beat id（測試／除錯）
var _ct := 0.0
var _gap := 0.0
var _playing := false
var _last := {}                      # cid／"foe:<kind>" → 上一句
var _rng := RandomNumberGenerator.new()
var _sc = null                       # 最近 tick 嘅場景（weakref）：zone_event 播 boss_pre 用

func _init() -> void: _rng.randomize()

# ================= 資料 =================
static func D() -> Dictionary:
	if _D == null: reload()
	return _D
static func reload() -> void:
	var f = FileAccess.open(PATH, FileAccess.READ)
	var o = JSON.parse_string(f.get_as_text()) if f != null else null
	_D = o if o is Dictionary else {"MAPS": []}
	if not (_D.get("MAPS") is Array): _D["MAPS"] = []
static func map_story(ci: int) -> Dictionary:
	for m in D().MAPS: if m is Dictionary and int(m.get("ci", -1)) == ci: return m
	return {}
static func beats(ci: int) -> Array:
	var b = map_story(ci).get("beats", [])
	return b if b is Array else []
static func beat(id: String) -> Dictionary:
	for m in D().MAPS:
		for b in m.get("beats", []): if str(b.get("id")) == id: return b
	return {}

# 選語言再過 DB.N（改名、女主版）
static func TN(a) -> String: return str(DB.N(MD.T(a)))

# ================= 已播記錄（S.mv.story_seen） =================
static func _mv():
	var s = J.G.get("S")
	if not (s is Dictionary) or not (s.get("mv") is Dictionary): return null
	return s.mv
static func seen_d() -> Dictionary:
	var m = _mv()
	if m == null: return {}
	if not (m.get("story_seen") is Dictionary): m["story_seen"] = {}
	var s = J.G.get("S")   # 舊存檔兼容：劇本線文件建議過 S.mv_story[id]
	if s.get("mv_story") is Dictionary:
		for k in s.mv_story: if J.t(s.mv_story[k]) and not m.story_seen.has(k): m.story_seen[str(k)] = 1.0
	return m.story_seen
static func is_seen(id: String) -> bool: return seen_d().has(id)
static func mark(id: String, v := 1.0) -> void:
	var m = _mv()
	if m == null: return
	seen_d()[id] = v

# ================= 觸發條件 =================
static func sold_n(sim, k: String) -> float:
	var sd = sim.st().get("sold", {})
	if k == "" or k == "*":
		var n = 0.0
		for g in sd: n += J.num(sd[g])
		return n
	return J.num(sd.get(k))
static func boss_k(ci: int) -> String:
	for g in MD.goals(ci): if str(g.get("t")) == "boss": return str(g.get("k", ""))
	return ""
static func boss_alive(sim) -> bool: return not sim.boss_ok(sim.ci(), boss_k(sim.ci()))
static func goal_ok(sim, i: int) -> bool: return sim.goal_claimed(i) or sim.goal_done(i)
static func boss_next(sim) -> bool:
	var G = MD.goals(sim.ci())
	for i in G.size():
		if str(G[i].get("t")) == "boss": continue
		if not goal_ok(sim, i): return false
	return true

# 全部目標已領＋Boss 已打低（同 mv_sim.can_move() 一樣，不過唔理有冇下一張圖；最後一張圖收尾用）
static func all_done(sim) -> bool:
	for i in MD.goals(sim.ci()).size(): if not sim.goal_claimed(i): return false
	return sim.boss_ok(sim.ci())

# when 條件（move 唔喺度判斷：由 before_move 叫）
static func when_ok(sim, b: Dictionary) -> bool:
	var w = b.get("when", {})
	if not (w is Dictionary): return false
	var k = str(w.get("k", "")); var n = float(w.get("n", 1))
	match str(w.get("t", "")):
		"open": return true
		"unlock": return sim.st().st.has(k) and sim.unlocked(k)
		"level": return sim.st().st.has(k) and sim.lv(k) >= n
		"sold": return sold_n(sim, k) >= n
		"goal": return goal_ok(sim, int(w.get("i", w.get("n", 0))))
		"boss_next": return boss_next(sim)
		"all_done": return all_done(sim)
		"inf_below": return MVW.inf(sim.ci()) < n
		"wave": return MVW.wave_n(sim.ci()) + (1.0 if sim.war != null and sim.war.get("wave") != null else 0.0) >= n
	return false

# need：0 = 得；1 = 未得（等）；2 = 永遠唔會得（Boss 已打低）→ 跳過
static func need_st(sim, b: Dictionary) -> int:
	var nd = b.get("need", {})
	if not (nd is Dictionary): return 0
	if J.t(nd.get("boss_alive")) and not boss_alive(sim): return 2
	var af = nd.get("after", [])
	if af is Array:
		for id in af:
			if is_seen(str(id)): continue
			var zb = beat(str(id))
			if not zb.is_empty() and is_zone(zb) and (not ZD.on_for(sim.ci()) or zstate_done(zb)): continue   # 分區地圖未開／狀態已經過咗：唔等
			return 1
	return 0

# 而家第一個要播嘅 beat（會順手記低要跳過嘅）；冇就回 {}
static func next_beat(sim, kind := "") -> Dictionary:
	if sim == null or sim.st() == null: return {}
	if kind != "move" and not enter_beat(sim.ci()).is_empty() and ZD.on_for(sim.ci()) and not is_seen(str(enter_beat(sim.ci()).id)): return {}   # 開場未播：其他等
	for b in beats(sim.ci()):
		var id = str(b.get("id", ""))
		if id == "" or is_seen(id) or is_zone(b): continue
		var is_move = str(b.get("when", {}).get("t", "")) == "move"
		if (kind == "move") != is_move: continue
		var ns = need_st(sim, b)
		if ns == 2: mark(id, 2.0); continue
		if ns == 1: continue
		if is_move or when_ok(sim, b): return b
	return {}

# ================= 播 =================
# 劇本 beat → 劇情播放器用嘅 scene（lines 變 [講者, 句]；title 揀語言；art 補 SPEAKER_ART）
static func build_scene(b: Dictionary) -> Dictionary:
	var sc: Dictionary = (b.get("scene", {}) as Dictionary).duplicate(true)
	if sc.get("title") is Array: sc["title"] = MD.T(sc.title)
	if sc.get("group") is Array: sc["group"] = MD.T(sc.group)
	var yue = DB.lang == "yue"
	var ls = []
	for l in sc.get("lines", []):
		if not (l is Array) or l.is_empty(): continue
		if l.size() >= 4 and not cond_ok(str(l[3])): continue
		var tx = str(l[1]) if l.size() >= 2 else ""
		if not yue and l.size() >= 3 and str(l[2]) != "": tx = str(l[2])
		ls.append([str(l[0]), tx])
	sc["lines"] = ls
	if not sc.has("style"): sc["style"] = "talk"
	var art = b.get("art", {})
	var SA = DB.D.get("SPEAKER_ART")
	if art is Dictionary and SA is Dictionary:
		for who in art: if not SA.has(who) and str(art[who]) != "": SA[who] = str(art[who])
	return sc

func _player(sc):
	var m = sc.get("main") if sc != null else null
	if m != null and is_instance_valid(m):
		var p = m.get("story")
		if p is Control and p.has_method("queue"): return p
	return null

func play(sc, b: Dictionary, cb := Callable()) -> void:
	var id = str(b.get("id", ""))
	mark(id, 1.0); played.append(id); _playing = true
	var scene = build_scene(b)
	var done = func():
		_playing = false; _gap = GAP
		if cb.is_valid(): cb.call()
	if play_fn.is_valid(): play_fn.call(scene, done); return
	var p = _player(sc)
	if p != null: p.queue(scene, done); return
	var st = J.G.get("Story")
	if st is Dictionary: J.mc(st, "queue", [scene, func(_t, _a): done.call(); return null]); return
	done.call()

# 主對話忙緊？（劇情佇列、手機、標題、載入、自檢、JS 彈窗）
func main_busy(sc) -> bool:
	if busy_fn.is_valid(): return bool(busy_fn.call())
	if _playing: return true
	var p = _player(sc)
	if p != null and p.busy(): return true
	var st = J.G.get("Story")
	if p == null and st is Dictionary and J.t(J.mc(st, "busy", [])): return true
	var m = sc.get("main") if sc != null else null
	if m != null and is_instance_valid(m):
		for k in ["title_ov", "phone", "loading", "selftest"]:
			var v = m.get(k)
			if v != null and is_instance_valid(v): return true
	var UI = J.G.get("UI")
	if UI is Dictionary and UI.get("modalOpen") != null and J.t(J.mc(UI, "modalOpen", [])): return true
	return false

# 睇緊大排檔區？（嵌入：鏡頭喺大排檔區先算；全屏：見到就算）
static func viewing(sc) -> bool:
	if sc == null or not sc.visible: return false
	if sc.get("anim") != null or sc.get("card") != null: return false
	if sc.get("sheet") != null and sc.sheet.visible: return false
	if sc.get("picker") != null: return false
	return not sc.embed or sc.hud_on

# 每格（mv_scene._process）
func tick(sc, dt: float) -> void:
	if sc == null or sc.sim == null or sc.sim.st() == null: return
	_live = weakref(self); _sc = weakref(sc)
	_cust_wait(sc)
	_foe_head(sc)
	if _gap > 0.0: _gap -= dt; return
	_ct -= dt
	if _ct > 0.0: return
	_ct = CHECK_DT
	if not auto_on: return
	if pending_move or main_busy(sc): return
	if zviewing(sc):
		var zb = next_zone(sc.sim)
		if not zb.is_empty(): play(sc, zb); return
	if not viewing(sc): return
	var b = next_beat(sc.sim)
	if not b.is_empty(): play(sc, b)

# 拔營掣（mv_scene.move_next 開頭）：有 move beat 未播 → 先播，播完再拔營；回 true＝而家唔好郁
func before_move(sc, instant := false) -> bool:
	if pending_move: return true
	if not auto_on: return false
	var b = next_beat(sc.sim, "move")
	if b.is_empty(): return false
	if instant:   # 冇動畫（程式叫）：照播，唔阻
		play(sc, b); return false
	pending_move = true
	play(sc, b, func():
		pending_move = false
		if is_instance_valid(sc): sc.move_next(false))
	return true

# ================= 分區地圖劇情（zstory） =================
static func is_zone(b: Dictionary) -> bool: return b.get("when") is Dictionary and str(b.when.get("t", "")) == "zone"
static func enter_beat(ci: int) -> Dictionary:
	for b in beats(ci): if is_zone(b) and str(b.when.get("kind")) == "map_enter": return b
	return {}

# 出場條件（line 第 4 格）
static func cond_ok(c: String) -> bool:
	if c == "": return true
	var neg = c.begins_with("!")
	if neg: c = c.substr(1)
	var r = true
	var s = J.G.get("S")
	if c.begins_with("has:"):
		r = false
		if s is Dictionary:
			for g in J.iter(s.get("ghosts")): if g is Dictionary and str(g.get("k", "")) == c.substr(4): r = true; break
	elif c.begins_with("seen:"):
		var k = c.substr(5)
		r = is_seen(k) or (s is Dictionary and s.get("seen") is Dictionary and J.t(s.seen.get(k)))
	return r != neg

# 王 id → [野外區 id, 第幾個]（搵唔到回 ["", -1]）
static func boss_pos(bid: String, c: int) -> Array:
	for z in ZD.of_type("wild", c):
		var bs = ZD.bosses(str(z.id), c)
		for i in bs.size(): if str(bs[i].get("id", "")) == bid: return [str(z.id), i]
	return ["", -1]

# 事件 id 正規化：factory 建築 id → 資源區；boss_* 野外區 id → 王 id
static func norm_id(kind: String, id: String, c: int) -> String:
	if kind == "factory" and ZD.zone(id, c).is_empty():
		var z = ZD.bid_zone(id, c)
		if z != "": return z
	if kind.begins_with("boss_") and str(ZD.zone(id, c).get("type", "")) == "wild":
		var bs = ZD.bosses(id, c)
		var i = ZD.boss_next(id, c)
		if kind == "boss_win": i = (bs.size() if i < 0 else i) - 1
		if i >= 0 and i < bs.size(): return str(bs[i].get("id", id))
	return id

# 搵對應 beat：when.id 對中；或者 when.z＋bi（王 id 改咗名都對得返）
static func zone_beat(c: int, kind: String, id: String) -> Dictionary:
	var bp = boss_pos(id, c) if kind.begins_with("boss_") else ["", -1]
	for b in beats(c):
		if not is_zone(b) or str(b.when.get("kind")) != kind: continue
		var wid = str(b.when.get("id", ""))
		if kind == "map_enter" or kind == "liberate": return b
		if wid == id: return b
		if bp[1] >= 0 and str(b.when.get("z", "")) == bp[0] and int(b.when.get("bi", -1)) == bp[1]: return b
	return {}

# 呢個 zone beat 喺存檔狀態上「已經過咗」？（舊存檔唔補播；need.after 唔使等）
static func zstate_done(b: Dictionary) -> bool:
	var w = b.get("when", {}); var c = _beat_ci(str(b.get("id", "")))
	if c < 0 or ZD.mdef(c).is_empty(): return false
	var id = str(w.get("id", ""))
	match str(w.get("kind", "")):
		"zone_cap": return ZD.owned(id, c)
		"boss_win": return _boss_done(w, c)
		"liberate": return ZD.all_bosses_done(c)
	return false
static func _boss_done(w: Dictionary, c: int) -> bool:
	var bp = boss_pos(str(w.get("id", "")), c)
	if bp[1] < 0: bp = [str(w.get("z", "")), int(w.get("bi", -1))]
	return bp[1] >= 0 and ZD.boss_done(bp[0], bp[1], c)
static func _beat_ci(id: String) -> int:
	for m in D().MAPS:
		for b in m.get("beats", []): if str(b.get("id")) == id: return int(m.get("ci", -1))
	return -1

# 舊存檔／重複：呢個事件而家唔應該播（記做跳過）
static func zskip(b: Dictionary, c: int) -> bool:
	var w = b.when; var id = str(w.get("id", ""))
	match str(w.get("kind", "")):
		"zone_seen": return str(ZD.zone(id, c).get("type", "")) == "res" and ZD.owned(id, c)
		"boss_pre": return _boss_done(w, c)
	return false

static func zq() -> Array:
	var m = _mv()
	if m == null: return []
	if not (m.get("story_zq") is Array): m["story_zq"] = []
	return m.story_zq

# 分區線叫（static）：有活實例就交佢；冇就照記佇列（boss_pre 都即刻播，用全域劇情佇列）
static func zone_ev(kind: String, id := "", cb := Callable()) -> bool:
	var me = _live.get_ref() if _live != null else null
	if me == null: me = load("res://game/outpost/mv_story.gd").new()
	return me.zone_event(kind, id, cb)

func zone_event(kind: String, id := "", cb := Callable()) -> bool:
	var s = J.G.get("S")
	var c = int(J.num(s.mv.get("ci", 0))) if s is Dictionary and s.get("mv") is Dictionary else ZD.ci()
	var b = {}
	if ZKINDS.has(kind): b = zone_beat(c, kind, norm_id(kind, str(id), c))
	var bid = str(b.get("id", ""))
	if b.is_empty() or is_seen(bid) or zskip(b, c):
		if not b.is_empty() and not is_seen(bid): mark(bid, 2.0)
		if cb.is_valid(): cb.call()
		return false
	if cb.is_valid():   # boss_pre：即刻播，播完先開戰（開場未播就順手先播開場）
		var eb = enter_beat(c)
		var sc = _sc.get_ref() if _sc != null else null
		if not eb.is_empty() and not is_seen(str(eb.id)) and ZD.on_for(c): play(sc, eb)
		play(sc, b, cb)
		return true
	var q = zq()
	if not q.has(bid): q.append(bid)
	return true

# 睇緊分區地圖？（唔理鏡頭喺邊；彈出卡、拔營動畫、戰鬥中都唔播）
static func zviewing(sc) -> bool:
	if sc == null or not sc.visible: return false
	if sc.get("anim") != null or sc.get("card") != null or sc.get("picker") != null: return false
	if sc.get("sheet") != null and sc.sheet.visible: return false
	if MVW.battle_on(): return false
	var m = sc.get("main")
	if m != null and is_instance_valid(m):
		var sh = m.get("sheet")
		if sh is Control and sh.visible: return false
	return true

# 下一個要播嘅分區 beat：開場（分區地圖開咗就播）→ 佇列（按事件次序；唔係呢張圖嘅清走）
static func next_zone(sim) -> Dictionary:
	if sim == null or sim.st() == null: return {}
	var c = sim.ci()
	var eb = enter_beat(c)
	if not eb.is_empty() and not is_seen(str(eb.id)):
		return eb if ZD.on_for(c) else {}
	var q = zq()
	var i = 0
	while i < q.size():
		var b = beat(str(q[i]))
		if b.is_empty() or is_seen(str(q[i])) or _beat_ci(str(q[i])) != c: q.remove_at(i); continue
		if zskip(b, c): mark(str(q[i]), 2.0); q.remove_at(i); continue
		var ns = need_st(sim, b)
		if ns == 2: mark(str(q[i]), 2.0); q.remove_at(i); continue
		if ns == 0: q.remove_at(i); return b
		i += 1
	return {}

# ================= 客人氣泡 =================
static func say_pool(cid: String, kind: String) -> Array:
	var cd = MD.cust_def(cid)
	var say = cd.get("say")
	if say is Dictionary and say.get(kind) is Array and not say[kind].is_empty(): return say[kind]
	match kind:
		"q", "buy":
			var ls = cd.get("lines", [])
			if ls is Array and ls.size(): return ls
		"vol": return MVW.L_JOIN
		"wait": return []   # 舊資料冇 wait：唔出氣泡（mv_scene 本身有「等到嬲，走人！」飄字）
	return []

# 揀一句（同一個 key 唔連續重複），回已換名嘅句；冇句回 ""
func _pick_nr(key: String, pool: Array) -> String:
	if pool.is_empty(): return ""
	var cands = []
	for a in pool: cands.append(TN(a))
	var last = str(_last.get(key, ""))
	var ok = []
	for s in cands: if s != last: ok.append(s)
	if ok.is_empty(): ok = cands
	var s2: String = ok[_rng.randi() % ok.size()]
	_last[key] = s2
	return s2
func cust_line(cid: String, kind: String) -> String: return _pick_nr(cid, say_pool(cid, kind))

func _who_cust() -> String: return MD.S("cust", "客人", "客人")
func bubble_cust(sc, c: Dictionary, kind: String, p = null) -> void:
	var s = cust_line(str(c.get("cid", "")), kind)
	if s == "": return
	var at: Vector2 = p if p is Vector2 else c.pos + Vector2(-90, -120)
	sc._bubble(at, s, _who_cust(), 2.8 if kind != "buy" else 2.4)

# 排隊氣泡（代替 mv_scene._random_line）：櫃台前等太耐講 wait，其他講 q
func random_line(sc) -> void:
	var pick = null
	for c in sc.sim.custs: if c.st == "serve": pick = c; break
	if pick == null:
		var qs = []
		for c in sc.sim.custs: if c.st == "queue": qs.append(c)
		if qs.size(): pick = qs[_rng.randi() % qs.size()]
	if pick == null: return
	bubble_cust(sc, pick, "wait" if _late(sc.sim, pick) else "q")

static func _late(sim, c: Dictionary) -> bool: return c.st == "serve" and float(c.get("wait", 0.0)) >= SIM.PATIENCE * WAIT_K
func _cust_wait(sc) -> void:
	for c in sc.sim.custs:
		if not c.has("_sw") and _late(sc.sim, c):
			c["_sw"] = true; bubble_cust(sc, c, "wait")

func _find_out(sim, cid: String) -> Dictionary:   # 啱啱離開（st=out）嗰個客；冇就 {}
	for c in sim.custs: if c.st == "out" and str(c.cid) == cid: return c
	return {}

# ================= 惡鬼 =================
static func foe_pool(ci: int, kind: String) -> Array:
	var f = map_story(ci).get("FOE", {})
	if f is Dictionary and f.get(kind) is Array and not f[kind].is_empty(): return f[kind]
	if kind == "roam" or kind == "head": return MD.D().FOE_LINES
	return []
func foe_line(ci: int, kind: String) -> String: return _pick_nr("foe:" + kind, foe_pool(ci, kind))

func _foe_head(sc) -> void:
	var sim = sc.sim
	for f in sim.foes:
		if J.t(f.get("boss")) and not f.has("_hd") and f.st != "die" and f.pos.x > 10.0 and f.pos.x < 380.0:
			f["_hd"] = true
			var s = foe_line(sim.ci(), "head")
			if s != "": sc._bubble(f.pos + Vector2(-60, -76), s, MD.S("foe_head", "鬼潮頭目", "鬼潮頭目"), 3.2)

# ================= 事件（mv_scene._eat_events 開頭；喺 war.eat 之前） =================
func eat(sc) -> void:
	var sim = sc.sim
	var vol_cids = {}
	for e in sim.ev: if str(e.k) == "war_join" and e.has("cid"): vol_cids[str(e.cid)] = true
	for e in sim.ev:
		match str(e.k):
			"pay":
				var cid = str(e.get("cid", ""))
				if cid == "" or vol_cids.has(cid): continue
				var c = _find_out(sim, cid)
				if not c.is_empty() and float(c.get("wait", 0.0)) >= SIM.PATIENCE:   # 等到唔耐煩，攞咗少少就走
					if not c.has("_sw"): c["_sw"] = true; bubble_cust(sc, c, "wait", e.pos + Vector2(-90, -60))
				elif _rng.randf() < BUY_P:
					bubble_cust(sc, {"cid": cid}, "buy", e.pos + Vector2(-90, -60))
			"leave":
				var cid2 = str(e.get("cid", ""))
				if cid2 == "": continue
				var c2 = _find_out(sim, cid2)
				if not c2.has("_sw"):
					if not c2.is_empty(): c2["_sw"] = true
					bubble_cust(sc, {"cid": cid2}, "wait", e.pos + Vector2(-90, -60))
			"war_join":
				if e.has("cid"):
					var s = cust_line(str(e.cid), "vol")
					if s != "": e["line"] = s
			"war_warn":
				var w = foe_line(sim.ci(), "wave")
				if w != "":
					e["line"] = w; e["said"] = true
					var ls = split2(w, WAVE_CH)
					var p0 = sc.s2w(Vector2(195, sc.top_pad + MVW.HUD_H + 90))
					for i in ls.size(): sc._float(p0 + Vector2(0, 22.0 * i), ls[i], Color("#ffd27a"), 17, 3.2)
			"bang":
				if _rng.randf() < ROAM_P:
					var r = foe_line(sim.ci(), "roam")
					if r != "": e["line"] = r

# 長句拆兩行（揀近中間嘅標點後面斷；冇標點就對半）
static func split2(s: String, mx: int) -> Array:
	if s.length() <= mx: return [s]
	var best = -1; var mid = s.length() / 2.0
	for i in range(1, s.length() - 1):
		if "，。、——…！？：；".contains(s[i]) and not "，。、——…！？：；".contains(s[i + 1]):
			if best < 0 or absf(i + 1 - mid) < absf(best - mid): best = i + 1
	if best < 0 or best > mx or s.length() - best > mx: best = int(ceil(mid))
	return [s.substr(0, best), s.substr(best)]
