# 移動村「戰鬥線」：義勇軍、鬼潮、影響力、告急、親自出征、霸檔（冇 class_name、冇 autoload；熱更新規矩）
# 用法：mv_sim.gd 有一個 `var war = MVW.new()`（掛鈎行標 # [war]），每格 sim.step → war.step(sim, dt)；
#       mv_scene.gd 嘅掛鈎行叫 sim.war.draw_world／draw_hud／draw_boss／tap／eat；main.gd 每 0.5 秒叫 MVW.poll() 收出征結果。
# 狀態存 S.mv.war（JSON 安全：只有數字、字串、陣列、字典）：
#   inf:{"ci":0–100}  每張圖影響力（預設 60）      vol:[義勇軍]  {cid,k,g:{gid:件數},atk,def,mx,hp}
#   wave_t 下一波鬼潮倒數（秒，只喺在線時減）       wn:{"ci":已打完幾多波}
#   alarm:{t:剩幾秒} 或 null                         occ:{"ci":被霸咗嘅 sid}
#   exp:{sid,ci} 出征緊（等戰鬥結果）                t0 第一張圖在線累計秒數（新手保護）
#
# ======================= 公式 =======================
#   地圖倍數   k(ci) = 1 + 0.6 × ci                                    （同圍欄孤魂血一樣）
#   影響力倍數 M(inf) = 0.6 + 0.4 × inf ÷ 60          （inf ≤ 60）
#                     = 1.0 + 0.3 × (inf − 60) ÷ 40   （inf > 60）     → 0 = 0.6×、60 = 1.0×、100 = 1.3×
#   客人來嘅頻率      每個客人間隔 ÷ M(inf)
#   賣價              客人付錢 × M(inf) × (1 + 裝備佔比 × 回血加成)
#   回血加成（裝備）  B(inf) = 1.5 × max(0, (60 − inf) ÷ 60)           → inf 0 時裝備 ×2.5（再 × M = 1.5×）；inf ≥ 60 冇
#   低影響力時想買裝備嘅客人多啲：揀客人時有 0.6 × max(0,(60−inf)÷60) 機會重揀一個要裝備嘅
#   離線收益          × max(1, M(inf))                                  （離線唔罰錢，高影響力有獎）
#   義勇軍            攻 = (4 + Σ 裝備攻 × min(件數,3)) × k   （每秒傷害）
#                     血 = (50 + Σ 裝備血 × min(件數,3)) × k
#                     防 = 4 + Σ 裝備防 × min(件數,3)；受傷 = 來襲傷害 × 40 ÷ (40 + 防)
#                     VIP 客人 ×1.5；上限 VOL_MAX 個，超出就最弱（攻×血×(40+防)）嗰個退休
#   孤魂打義勇軍      每秒 5 × k（頭目 12 × k）
#   鬼潮              每 WAVE_GAP 秒一波（新圖第一波 WAVE_FIRST 秒）；隻數 = 3 + ci + min(3, floor(wn/2))，最尾一隻頭目
#                     每隻血 = 圍欄孤魂血(ci) × min(2.5, 1 + 0.12 × wn)；頭目血 × 5；限時 WAVE_TIME 秒
#   影響力升跌        守贏 +6（冇人散、冇失貨再 +4）；守唔住 −12；義勇軍散 −2；孤魂偷貨／嚇走客 −1
#                     出征打贏：inf = max(inf + 35, 65)；夾 0–100
#   告急              在線、唔係新手保護、唔係戰鬥中、inf < ALARM(30) → 告急，倒數 ALARM_T(180) 秒（只喺在線時減）
#                     倒數完 → 最好賺嗰個已解鎖檔畀孤魂霸咗（停工），要出征打贏先復工；inf 回到 ≥ 40 而冇檔被霸 → 解除
#   新手保護          第一張圖在線頭 NEWBIE 秒（600）：唔告急、孤魂唔偷嘢唔嚇客、影響力最低 35
#   離線              每 WAVE_GAP 秒當打一波：守方每秒傷害 Σ(義勇攻) + Σ(守夜 dps) ≥ 鬼潮總血 ÷ (WAVE_TIME × 0.5) → +2，否則 −8；
#                     最多跌到 50（本身低過 50 就唔再跌）；離線唔會霸檔、唔會告急、義勇軍唔會散
#   圍欄孤魂          拍圍欄（冇義勇軍／守夜擋住）累計 PRESS 秒 → 偷櫃台貨（最多嗰種，1–2 件）；櫃台冇貨就嚇走排尾嘅客
extends RefCounted

const MD = preload("res://game/outpost/mv_data.gd")
const M = preload("res://game/outpost/mat.gd")

const INF0 := 60.0
const ALARM := 30.0
const ALARM_OFF := 40.0
const ALARM_T := 180.0
const NEWBIE := 600.0
const NEWBIE_FLOOR := 35.0
const OFF_FLOOR := 50.0
const VOL_MAX := 8
const WAVE_GAP := 240.0
const WAVE_FIRST := 180.0
const WAVE_TIME := 75.0
const WAVE_WARN := 10.0
const PRESS := 5.0
const EXP_UP := 35.0
const EXP_MIN := 65.0
const VOL_BASE := {"atk": 4.0, "def": 4.0, "hp": 50.0}
const FOE_DPS := 5.0
const BOSS_DPS := 12.0
# chain.json 未有 GEAR（設計線未交貨）時用嘅後備：outpost.json 現有貨品入面似裝備嘅
const GEAR_FIXTURE := {
	"g_zhishan": {"slot": "body", "atk": 2, "def": 6, "hp": 40},
	"g_tuoxie": {"slot": "legs", "atk": 3, "def": 2, "hp": 20},
	"g_zhulong": {"slot": "shield", "atk": 0, "def": 10, "hp": 30},
	"g_caoxie": {"slot": "legs", "atk": 3, "def": 3, "hp": 25},
	"g_jiushengquan": {"slot": "shield", "atk": 0, "def": 12, "hp": 60},
	"g_mingbiao": {"slot": "hand", "atk": 6, "def": 0, "hp": 10},
	"g_xizhuang": {"slot": "body", "atk": 4, "def": 8, "hp": 60},
	"g_zhiku": {"slot": "legs", "atk": 4, "def": 6, "hp": 50},
}
const FW := 390.0
const CS := 1.1
const HUD_H := 90.0
const SLOT_COL := {"body": "#e05a8a", "legs": "#4f9fd0", "head": "#e0b040", "hand": "#9a6ad0", "shield": "#50b070"}

static var NEWS: Array = []      # 出征結果（main.gd 收到都要話返畀畫面知）
static var gear_override = null  # 測試用：指定 GEAR 表

var vols: Array = []      # 即時：{d(存檔字典), pos, st:"walk|post|fight", path, s, tgt, cd, ph, flip, walk, slot}
var wave = null           # {t, q:[待出], qt, foes:[], boss, lost(失貨), died, n}
var _warned := false
var _btn := {}            # 畫面掣（畫面座標）
var _rng := RandomNumberGenerator.new()
var _sim_ref = null       # 只係畫嘢用（weakref）

func _init() -> void:
	_rng.seed = 4242

# ================= 狀態 =================
static func SS():
	var s = J.G.get("S")
	return s if s is Dictionary else null
static func ws():
	var s = SS()
	if s == null or not (s.get("mv") is Dictionary): return null
	var m = s.mv
	if not (m.get("war") is Dictionary):
		m["war"] = {"inf": {}, "vol": [], "wave_t": WAVE_FIRST, "wn": {}, "alarm": null, "occ": {}, "exp": null, "t0": 0.0}
	var w = m.war
	for k in ["inf", "wn", "occ"]: if not (w.get(k) is Dictionary): w[k] = {}
	if not (w.get("vol") is Array): w["vol"] = []
	if w.get("wave_t") == null: w["wave_t"] = WAVE_FIRST
	if w.get("t0") == null: w["t0"] = 0.0
	return w
static func cur_ci() -> int:
	var s = SS()
	if s == null or not (s.get("mv") is Dictionary): return 0
	return clampi(int(J.num(s.mv.get("ci"))), 0, maxi(0, MD.maps_n() - 1))
static func kmap(ci: int) -> float: return 1.0 + 0.6 * ci

static func inf(ci := -1) -> float:
	var w = ws(); if w == null: return INF0
	if ci < 0: ci = cur_ci()
	var v = w.inf.get(str(ci))
	return INF0 if v == null else clampf(J.num(v), 0.0, 100.0)
static func newbie() -> bool:
	var w = ws(); if w == null: return false
	return cur_ci() == 0 and J.num(w.get("t0")) < NEWBIE
static func floor_now() -> float: return NEWBIE_FLOOR if newbie() else 0.0
# 改影響力：回實際改咗幾多
static func add_inf(d: float, lo := -1.0) -> float:
	var w = ws(); if w == null: return 0.0
	var a = inf()
	var f = floor_now() if lo < 0.0 else lo
	var b = clampf(a + d, minf(a, f) if d < 0.0 else 0.0, 100.0)
	w.inf[str(cur_ci())] = b
	return b - a
static func mul(v: float) -> float:   # M(inf)
	if v <= 60.0: return 0.6 + 0.4 * v / 60.0
	return 1.0 + 0.3 * (v - 60.0) / 40.0
static func gear_bonus(v: float) -> float: return 1.5 * maxf(0.0, (60.0 - v) / 60.0)

static func gear_tab() -> Dictionary:
	if gear_override is Dictionary: return gear_override
	var g = M.D().get("GEAR")
	if g is Dictionary and not g.is_empty():
		if _gear_norm == null: _gear_norm = _norm_gear(g)
		return _gear_norm
	return GEAR_FIXTURE
# [integ] chain.json 嘅 GEAR 係「絕對值」（後面地圖件件都大好多），而呢度會再 × kmap(ci)；
#   所以按件貨喺邊張圖出（OUTPOST 台嘅地圖序）先除返 kmap，免得重複放大（後期義勇軍會無敵）。
static var _gear_norm = null
static func _norm_gear(g: Dictionary) -> Dictionary:
	var MDd = preload("res://game/outpost/mv_data.gd")
	var where := {}
	for c in MDd.maps_n():
		for sid in MDd.stations(c):
			var gid = str(MDd.st_def(sid).get("good", ""))
			if gid != "" and not where.has(gid): where[gid] = c
	var o := {}
	for k in g:
		var d: Dictionary = (g[k] as Dictionary).duplicate()
		var kk = kmap(int(where.get(k, 0)))
		for f in ["atk", "def", "hp"]: d[f] = J.num(d.get(f, 0)) / kk
		o[k] = d
	return o
static func is_gear(gid: String) -> bool: return gear_tab().has(gid)
static func occ_sid() -> String:
	var w = ws(); if w == null: return ""
	var v = w.occ.get(str(cur_ci()))
	return str(v) if v != null else ""
func blocked(_sim, sid: String) -> bool: return sid != "" and occ_sid() == sid
static func alarm_on() -> bool:
	var w = ws(); return w != null and w.get("alarm") is Dictionary
static func need_exp() -> bool: return alarm_on() or occ_sid() != ""
static func vol_list() -> Array:
	var w = ws(); return w.vol if w != null else []

# ================= 文字（chain.json STRINGS → outpost.json STRINGS → 預設） =================
static func T(key: String, yue: String, zh: String) -> String:
	var a = M.D().STRINGS.get(key)
	if a is Array and a.size() >= 2:
		var s = str(a[0]) if DB.lang == "yue" else str(a[1])
		if MD._fmt_sig(s) == MD._fmt_sig(yue if DB.lang == "yue" else zh): return s
	return MD.S(key, yue, zh)
const L_JOIN := [["件嘢好襯我，順手幫你睇場！", "這件很襯我，順便幫你看場！"], ["買咗你啲嘢，你個檔我罩！", "買了你的東西，你的攤我罩！"],
	["死都死咗，仲驚咩孤魂？", "都死了，還怕什麼孤魂？"], ["著新衫唔打餐交，嘥咗。", "穿了新衣不打一架，浪費。"], ["我去圍欄企吓，當行街。", "我去圍欄站站，當逛街。"]]
const L_DIE := [["件衫爛晒……我返去補吓先。", "衣服爛了……我先回去補補。"], ["我散住先，聽日再嚟。", "我先散了，明天再來。"], ["紙紮嘢，唔經打㗎。", "紙紮的，不耐打的。"]]
const L_STEAL := [["呢啲我拎住先！", "這些我先拿走！"], ["冇人睇檔？多謝晒！", "沒人看攤？謝啦！"], ["免費試食！", "免費試吃！"]]
const L_SCARE := [["喂！排咩隊呀，走啦！", "喂！排什麼隊，走啦！"], ["嘩——（扮嘢）", "哇——（裝神弄鬼）"]]
static func pick(a: Array, rng: RandomNumberGenerator) -> String: return MD.T(a[rng.randi() % a.size()])

# ================= 義勇軍數值 =================
static func vol_stats(g: Dictionary, ci: int, vip := false) -> Dictionary:
	var GT = gear_tab(); var atk = VOL_BASE.atk; var df = VOL_BASE.def; var hp = VOL_BASE.hp
	for gid in g:
		var e = GT.get(str(gid))
		if not (e is Dictionary): continue
		var n = minf(3.0, J.num(g[gid]))
		atk += J.num(e.get("atk", 0)) * n; df += J.num(e.get("def", 0)) * n; hp += J.num(e.get("hp", 0)) * n
	var kk = kmap(ci) * (1.5 if vip else 1.0)
	return {"atk": atk * kk, "def": df * (1.5 if vip else 1.0), "mx": hp * kk}
static func vpow(d: Dictionary) -> float: return J.num(d.atk) * J.num(d.mx) * (40.0 + J.num(d.def)) / 40.0
static func main_slot(g: Dictionary) -> Array:   # [gid, slot]：件數最多（同數揀血多）嗰件做外觀
	var GT = gear_tab(); var best = ""; var bn = -1.0
	for gid in g:
		if not GT.has(str(gid)): continue
		var n = J.num(g[gid]) * 1000.0 + J.num(GT[str(gid)].get("hp", 0))
		if n > bn: bn = n; best = str(gid)
	return [best, str(GT[best].get("slot", "body")) if best != "" else "body"]

# ================= 掛鈎：客人 =================
func freq_mul(_sim) -> float: return mul(inf())
func pay_mul(sim, c: Dictionary) -> float:
	var tot = 0.0; var gear = 0.0; var ci = sim.ci()
	for g in c.got:
		var sid = sim.sid_of(str(g))
		if sid == "": continue
		var v = float(c.got[g]) * MD.val(sid, sim.lv(sid), ci)
		tot += v
		if is_gear(str(g)): gear += v
	var v0 = inf()
	return mul(v0) * (1.0 + (gear / tot if tot > 0.0 else 0.0) * gear_bonus(v0))
func pick_cust(_sim, cands: Array, cur: Array) -> Array:
	var p = 0.6 * maxf(0.0, (60.0 - inf()) / 60.0)
	if p <= 0.0 or _rng.randf() >= p: return cur
	var gc = []
	for e in cands:
		for g in e[1]: if is_gear(str(g)): gc.append(e); break
	return gc[_rng.randi() % gc.size()] if gc.size() else cur
func off_mul(_sim) -> float: return maxf(1.0, mul(inf()))

# 客人付完錢：買咗裝備 → 唔走，變義勇軍行去圍欄
func on_paid(sim, c: Dictionary) -> void:
	var g = {}
	for k in c.got:
		if is_gear(str(k)) and int(c.got[k]) > 0: g[str(k)] = float(c.got[k])
	if g.is_empty(): return
	var w = ws(); if w == null: return
	var stt = vol_stats(g, sim.ci(), J.t(c.get("vip")))
	var d = {"cid": str(c.cid), "k": str(c.k), "g": g, "atk": stt.atk, "def": stt.def, "mx": stt.mx, "hp": stt.mx}
	w.vol.append(d)
	sim.custs.erase(c)
	var rt = _mk_rt(sim, d, c.pos)
	vols.append(rt)
	sim.ev.append({"k": "war_join", "pos": c.pos + Vector2(0, -60), "line": pick(L_JOIN, _rng), "gid": main_slot(g)[0], "cid": str(c.cid)})   # [story] cid：換客人 say.vol
	_cap(sim)

func _cap(sim) -> void:   # 超出上限：最弱嘅退休
	var w = ws()
	while w.vol.size() > VOL_MAX:
		var worst = null
		for d in w.vol: if worst == null or vpow(d) < vpow(worst): worst = d
		w.vol.erase(worst)
		for r in vols.duplicate():
			if is_same(r.d, worst):
				vols.erase(r); sim.ev.append({"k": "war_retire", "pos": r.pos + Vector2(0, -60)})

func _mk_rt(sim, d: Dictionary, from: Vector2) -> Dictionary:
	var rt = {"d": d, "pos": from, "st": "walk", "s": 0.0, "tgt": null, "cd": _rng.randf() * 0.5, "ph": _rng.randf() * 10.0, "flip": false, "walk": true, "slot": 0}
	rt.path = _path_to_fence(sim, from)
	return rt
func _path_to_fence(sim, from: Vector2) -> PackedVector2Array:
	var o = PackedVector2Array(); o.append(from)
	if sim.L.get("vol_mid") is Array:   # [zone] 分區地圖：經大排檔中間路上野外門
		for q in sim.L.vol_mid: if float(q[1]) < from.y: o.append(MD.v2(q))
		return o
	var rd = sim.L.get("road", []); var j = int(MD.layout(sim.ci()).get("j", 2))
	for i in range(j, rd.size()):
		if rd[i].y < from.y: o.append(rd[i])
	o.append(Vector2(195, float(sim.L.fence_y) + 62.0))
	return o
func vol_home(sim, i: int) -> Vector2:
	var vs = sim.L.get("vol_slots")
	if vs is Array and vs.size(): return MD.v2(vs[i % vs.size()])   # [zone] 兩道野外門兩邊
	return Vector2(36.0 + 45.0 * (i % VOL_MAX), float(sim.L.fence_y) + 62.0 + (8.0 if i % 2 else 0.0))

func reset_live() -> void:
	vols.clear(); wave = null; _warned = false
func _sync(sim) -> void:   # 存檔 ↔ 即時：返嚟時義勇軍直接企喺圍欄
	var w = ws(); var keep = []
	for r in vols: if _has_ref(w.vol, r.d): keep.append(r)
	vols = keep
	for d in w.vol:
		var found = false
		for r in vols: if is_same(r.d, d): found = true; break
		if found: continue
		var r2 = _mk_rt(sim, d, Vector2.ZERO); r2.st = "post"; r2.walk = false
		vols.append(r2)
	for i in vols.size():
		vols[i].slot = i
		if vols[i].st == "post" and vols[i].pos == Vector2.ZERO: vols[i].pos = vol_home(sim, i)
static func _has_ref(a: Array, d) -> bool:
	for x in a: if is_same(x, d): return true
	return false

# ================= 每格（只喺在線、畫面開住時行） =================
static func battle_on() -> bool:
	var B = J.G.get("Battle")
	return B is Dictionary and J.t(B.get("active"))
func step(sim, dt: float) -> void:
	var w = ws(); if w == null or sim.L.is_empty(): return
	_sim_ref = weakref(sim)
	_sync(sim)
	if battle_on(): return
	if sim.ci() == 0: w.t0 = J.num(w.t0) + dt
	_step_wave(sim, w, dt)
	_step_flee(sim, dt)
	_step_vols(sim, dt)
	_step_press(sim, dt)
	_step_alarm(sim, w, dt)

# ---------------- 鬼潮 ----------------
static func wave_n(ci: int) -> float:
	var w = ws(); return J.num(w.wn.get(str(ci))) if w != null else 0.0
static func wave_size(ci: int) -> int: return 3 + ci + mini(3, int(wave_n(ci) / 2.0))
static func wave_hp(ci: int) -> float: return MD.foe_hp(ci) * minf(2.5, 1.0 + 0.12 * wave_n(ci))
static func wave_total_hp(ci: int) -> float: return wave_hp(ci) * (wave_size(ci) - 1 + 5)
func _step_wave(sim, w: Dictionary, dt: float) -> void:
	if wave == null:
		w.wave_t = J.num(w.wave_t) - dt
		if J.num(w.wave_t) <= WAVE_WARN and not _warned:
			_warned = true; sim.ev.append({"k": "war_warn"})
		if J.num(w.wave_t) <= 0.0: start_wave(sim)
		return
	wave.t += dt
	# 逐隻出
	if wave.q.size():
		wave.qt -= dt
		if wave.qt <= 0.0:
			wave.qt = 0.7
			_spawn_wave_foe(sim, wave.q.pop_front())
	for f in wave.foes:
		if f.st == "roam": f.st = "charge"; f.tgt = sim.fence_tgt(f.pos.x); f.t = 0.0   # [zone] 野外門／柵欄
	var alive = 0
	for f in wave.foes: if f.st != "die" and f.st != "flee" and sim.foes.has(f): alive += 1
	if wave.q.is_empty() and alive == 0: _end_wave(sim, w, true)
	elif wave.t >= WAVE_TIME: _end_wave(sim, w, false)

func start_wave(sim) -> void:
	var w = ws(); var ci = sim.ci()
	var n = wave_size(ci); var q = []
	for i in n - 1: q.append(false)
	q.append(true)
	wave = {"t": 0.0, "q": q, "qt": 0.0, "foes": [], "boss": null, "lost": 0, "died": 0, "n": n}
	w.wave_t = WAVE_GAP; _warned = false
	sim.ev.append({"k": "war_wave", "n": n})
func _spawn_wave_foe(sim, boss: bool) -> void:
	sim.spawn_foe()
	var f = sim.foes[sim.foes.size() - 1]
	var ci = sim.ci(); var hp = wave_hp(ci) * (5.0 if boss else 1.0)
	var ks = MD.map_def(ci).get("fence_foes", ["youhun"])
	if boss and ks is Array and ks.size(): f.k = str(ks[ks.size() - 1])
	f.hp = hp; f.mx = hp; f.st = "charge"; f.t = 0.0; f["wave"] = true
	f.tgt = sim.fence_tgt(_rng.randf_range(40, sim.ww() - 40)) if not sim.L.has("gdir") else sim.fence_tgt(f.pos.x, f.pos.y)   # [zone2] 由自己嗰區衝最近嘅門
	if boss: f["boss"] = true; wave.boss = f
	wave.foes.append(f)
func _end_wave(sim, w: Dictionary, won: bool) -> void:
	var ci = sim.ci(); var d = 0.0
	if won:
		d = add_inf(6.0 + (4.0 if wave.died == 0 and wave.lost == 0 else 0.0))
		var cc = MD.foe_coin(ci) * (3 + int(wave.n))
		sim.add_coins(cc)
		sim.ev.append({"k": "war_won", "d": d, "coins": cc})
	else:
		for f in wave.foes:   # 守唔住：衝入嚟嘅每隻偷／嚇一次，然後走
			if f.st != "die" and sim.foes.has(f):
				_raid(sim, f, true)
				f.st = "flee"; f.t = 0.0
		d = add_inf(-12.0)
		sim.ev.append({"k": "war_lost", "d": d})
	w.wn[str(ci)] = wave_n(ci) + 1.0
	wave = null
func _step_flee(sim, dt: float) -> void:
	for f in sim.foes.duplicate():
		if f.st != "flee": continue
		f.pos += Vector2(0, 80.0 * dt * sim.flee_dir(f.pos)) + Vector2(-60.0 if f.pos.x < sim.ww() / 2.0 else 60.0, 0) * dt   # [zone2] 野外喺下面就向下逃
		f["walk"] = true
		if f.pos.y < 20.0 or f.pos.y > float(sim.L.get("wh", 1e9)) - 20.0 or f.pos.x < -40.0 or f.pos.x > sim.ww() + 40.0: sim.foes.erase(f)

# ---------------- 義勇軍 ----------------
func _near_fence(sim, f) -> bool: return f.st != "die" and f.st != "flee" and sim.at_fence(f.pos, 90.0)   # [zone2] 任何方向嘅野外門
func _step_vols(sim, dt: float) -> void:
	var fy = float(sim.L.fence_y)
	for r in vols.duplicate():
		r.cd -= dt
		if r.has("hurt"):
			r.hurt -= dt
			if r.hurt <= 0.0: r.erase("hurt")
		match r.st:
			"walk":
				r.s += 120.0 * dt
				var np = MD.poly_at(r.path, r.s)
				var dv = np - r.pos
				if dv.length() > 0.01: r.flip = dv.x < 0
				r.pos = np; r.walk = true
				if r.s >= MD.poly_len(r.path): r.st = "post"
			"post", "fight":
				var tgt = r.tgt
				if tgt == null or not sim.foes.has(tgt) or not _near_fence(sim, tgt): tgt = null
				if tgt == null:
					var best = 1e9
					for f in sim.foes:
						if not _near_fence(sim, f): continue
						var n_on = 0
						for r2 in vols: if r2 != r and r2.tgt == f: n_on += 1
						var dd = absf(f.pos.x - r.pos.x) + 50.0 * n_on - (40.0 if f.get("wave", false) else 0.0)
						if dd < best: best = dd; tgt = f
				r.tgt = tgt
				if tgt == null:
					r.st = "post"
					var hp = vol_home(sim, int(r.slot))
					r.walk = _mv(r, hp, dt, 70.0) == false
					r.d.hp = minf(J.num(r.d.mx), J.num(r.d.hp) + J.num(r.d.mx) * 0.03 * dt)   # 冇嘢打：慢慢回血
					continue
				r.st = "fight"
				var side = -1.0 if (int(r.slot) % 2 == 0) else 1.0
				var want = Vector2(clampf(tgt.pos.x + side * (18.0 + 6.0 * (int(r.slot) % 3)), 16, sim.ww() - 16), sim.guard_line(tgt.pos, 24.0 + (int(r.slot) % 2) * 8.0))   # [zone2]
				r.walk = not _mv(r, want, dt, 110.0)
				if absf(tgt.pos.x - r.pos.x) < 40.0 and absf(r.pos.y - want.y) < 6.0:
					r.flip = tgt.pos.x < r.pos.x
					if r.cd <= 0.0:
						r.cd = 0.8; r["atk_t"] = 0.25
						sim.hit_foe(tgt, J.num(r.d.atk) * 0.8, "vol")
		if r.has("atk_t"):
			r.atk_t -= dt
			if r.atk_t <= 0.0: r.erase("atk_t")
static func _mv(e: Dictionary, to: Vector2, dt: float, spd: float) -> bool:
	var d = to - e.pos
	if d.length() <= spd * dt: e.pos = to; return true
	e.pos += d.normalized() * spd * dt; e.flip = d.x < 0
	return false

# 擋住（義勇軍喺身邊）就打義勇軍；冇人擋就累計，夠 PRESS 秒偷嘢／嚇客
func _blocker(sim, f):
	var best = null; var bd = 1e9
	for r in vols:
		if r.st == "walk": continue
		var dx = absf(r.pos.x - f.pos.x)
		if dx < 46.0 and sim.inside_d(r.pos, f.pos) < 50.0 and dx < bd: bd = dx; best = r   # [zone2]
	return best
func _guarded(sim, f) -> bool:
	for g in sim.guards: if absf(g.pos.x - f.pos.x) < 34.0: return true
	return false
func _step_press(sim, dt: float) -> void:
	var kk = kmap(sim.ci())
	for f in sim.foes.duplicate():
		if f.st != "bang": continue
		var r = _blocker(sim, f)
		if r != null:
			var raw = (BOSS_DPS if f.get("boss", false) else FOE_DPS) * kk * dt
			r.d.hp = J.num(r.d.hp) - raw * 40.0 / (40.0 + J.num(r.d.def)); r["hurt"] = 0.2
			if J.num(r.d.hp) <= 0.0: _vol_die(sim, r)
			continue
		if _guarded(sim, f): continue
		f["press"] = float(f.get("press", 0.0)) + dt
		if f.press >= PRESS:
			f.press = 0.0
			if not newbie(): _raid(sim, f, false)
func _vol_die(sim, r: Dictionary) -> void:
	var w = ws()
	w.vol.erase(r.d); vols.erase(r)
	var d = add_inf(-2.0)
	if wave != null: wave.died += 1
	sim.ev.append({"k": "war_vdie", "pos": r.pos + Vector2(0, -60), "line": pick(L_DIE, _rng), "d": d})
# 孤魂衝入：偷櫃台貨（最多嗰種 1–2 件）；冇貨就嚇走排尾客人
func _raid(sim, f: Dictionary, _force: bool) -> String:
	if newbie(): return ""   # 新手保護：連鬼潮衝入都唔偷
	var m = sim.st(); var best = ""; var bn = 0
	for g in m.counter:
		var n = int(J.num(m.counter[g]))
		if n > bn: bn = n; best = str(g)
	if best != "":
		var take = mini(bn, 1 + _rng.randi() % 2)
		m.counter[best] = float(bn - take)
		var d = add_inf(-1.0)
		if wave != null: wave.lost += take
		sim.ev.append({"k": "war_steal", "gid": best, "n": take, "from": sim.counter_slot(best), "to": f.pos + Vector2(0, -30), "pos": f.pos + Vector2(0, -50), "line": pick(L_STEAL, _rng), "d": d})
		return "steal"
	var tail = null
	for c in sim.custs: if c.st == "queue" or c.st == "in": tail = c
	if tail != null:
		tail.st = "out"
		var d2 = add_inf(-1.0)
		if wave != null: wave.lost += 1
		sim.ev.append({"k": "leave", "pos": tail.pos + Vector2(0, -60)})
		sim.ev.append({"k": "war_scare", "pos": f.pos + Vector2(0, -50), "line": pick(L_SCARE, _rng), "d": d2})
		return "scare"
	return ""

# ---------------- 告急 → 霸檔 ----------------
func _step_alarm(sim, w: Dictionary, dt: float) -> void:
	var v = inf()
	if w.get("alarm") is Dictionary:
		if occ_sid() == "":
			w.alarm.t = J.num(w.alarm.t) - dt
			if J.num(w.alarm.t) <= 0.0:
				var sid = _occupy_pick(sim)
				if sid != "":
					w.occ[str(sim.ci())] = sid; sim.mk[sid] = -1.0
					sim.ev.append({"k": "war_occ", "sid": sid})
				w.alarm.t = 0.0
		if v >= ALARM_OFF and occ_sid() == "": w.alarm = null; sim.ev.append({"k": "war_calm"})
	elif v < ALARM and not newbie():
		w.alarm = {"t": ALARM_T}
		sim.ev.append({"k": "war_alarm"})
func _occupy_pick(sim) -> String:   # 最好賺嗰個已解鎖檔
	var best = ""; var bv = -1.0; var ci = sim.ci()
	for sid in MD.stations(ci):
		if not sim.unlocked(sid): continue
		var v = MD.val(sid, sim.lv(sid), ci) * MD.out(sid, sim.lv(sid)) / MD.tm(sid, sim.lv(sid)) * (1.0 + sim.nworkers(sid))
		if v > bv: bv = v; best = sid
	return best

# ================= 親自出征 =================
static func exp_stage(ci: int) -> Dictionary:
	var ET = J.G.get("ENEMY_T"); var ks = MD.map_def(ci).get("fence_foes", ["youhun"])
	var ok = []
	if ks is Array:
		for k in ks: if ET is Dictionary and ET.has(str(k)): ok.append(str(k))
	var CH = J.G.get("CHAPTERS"); var p = 1.0 + 4.0 * ci; var bg = "field"
	if CH is Array and ci < CH.size():
		var ch = CH[ci]; bg = str(ch.get("bg", "field"))
		var st0 = ch.stages[0]; p = J.num(st0.p)
		if ok.is_empty():
			for e in st0.en: if not ok.has(str(e)): ok.append(str(e))
	if ok.is_empty(): ok = ["youhun"]
	var boss = ok[ok.size() - 1]
	var en = [ok[0], boss, ok[0]]
	var nm = MD.T(MD.map_def(ci).get("name", ["", ""]))
	return {"stage": {"name": nm + T("war_exp_t", "告急", "告急"), "p": p, "en": en, "boss": boss}, "bg": bg, "sid": T("war_exp_sid", "出征", "出征") + "·%d" % (ci + 1)}
func start_expedition(sim) -> String:
	var w = ws(); if w == null: return "nostate"
	if not need_exp(): return "noneed"
	var S = SS(); var any = false
	for x in J.iter(S.get("team")): if J.t(x): any = true; break
	if not any:
		var fx = J.G.get("Fx")
		if fx != null: J.mc(fx, "toast", [T("war_noteam", "至少要派一位鬼怪出陣（去「鬼怪」頁揀隊）", "至少要派一位鬼怪出陣（去「鬼怪」頁選隊）")])
		return "noteam"
	var B = J.G.get("Battle")
	if not (B is Dictionary): return "nobattle"
	var ex = exp_stage(sim.ci())
	if not (S.get("cleared") is Dictionary): S["cleared"] = {}
	w.exp = {"sid": ex.sid, "ci": float(sim.ci()), "had": J.t(S.cleared.get(ex.sid))}
	S.cleared[ex.sid] = true   # 當「再打」：戰鬥只畀少量冥幣＋好評（唔出寶箱）；結算後 resolve 會清返
	var ui = J.G.get("UI")
	if ui != null: J.mc(ui, "close", [])
	var go = func(): J.mc(B, "start", [-1.0, -1.0, ex])
	if not load("res://game/zone/zone_battle.gd").start("raid", "", go): go.call()   # [mapbattle] 分區地圖：喺大排檔即時迎戰
	return "ok"

# 收戰鬥結果（main.gd 每 0.5 秒叫；畫面每格叫）：回 {} 或 {win, d, mats}
static func poll() -> Dictionary:
	var w = ws(); if w == null or not (w.get("exp") is Dictionary): return {}
	var B = J.G.get("Battle")
	if not (B is Dictionary): return {}
	if J.str(B.get("sid")) != J.str(w.exp.sid): return {}
	var r = B.get("result")
	if not (r is Dictionary): return {}
	return resolve(J.t(r.get("win")))
static func resolve(win: bool) -> Dictionary:
	var w = ws(); if w == null or not (w.get("exp") is Dictionary): return {}
	var ex = w.exp; w.exp = null
	var ci = int(J.num(ex.ci)); var S = SS()
	if S.get("cleared") is Dictionary and not J.t(ex.get("had")): S.cleared.erase(J.str(ex.sid))   # 唔好污染主線通關紀錄
	var out = {"win": win, "ci": ci, "d": 0.0, "mats": {}}
	if win and ci == cur_ci():
		var a = inf()
		var b = clampf(maxf(a + EXP_UP, EXP_MIN), 0.0, 100.0)
		w.inf[str(ci)] = b; out.d = b - a
		w.alarm = null; w.occ.erase(str(ci))
		var mats = {"m_wood": 40.0 * (ci + 1), "m_rice": 40.0 * (ci + 1), "m_plank": 12.0 * (ci + 1)}
		for mid in mats: give_mat(mid, mats[mid])
		out.mats = mats
	NEWS.append(out)
	return out
const OLD_RES := {"m_wood": "wood", "m_rice": "rice", "m_plank": "planks", "m_shoubao": "buns"}
static func give_mat(mid: String, n: float) -> void:
	if M.has_def(mid): M.add(mid, n); return
	var S = SS(); if S == null: return
	if OLD_RES.has(mid):
		if not (S.get("res") is Dictionary): S["res"] = {}
		S.res[OLD_RES[mid]] = J.num(S.res.get(OLD_RES[mid])) + n
	else: M.add(mid, n)

# ================= 離線 =================
func offline(sim, secs: float) -> Dictionary:
	var w = ws(); if w == null: return {}
	var a = inf(); var ci = sim.ci()
	var nw = mini(30, int(secs / WAVE_GAP))
	var dps = 0.0
	for d in w.vol: dps += J.num(d.atk)
	for gid in sim.st().guards:
		if gid != null and sim.ghost(gid) != null: dps += MD.guard_dps(sim.glv(sim.ghost(gid)))
	var need = wave_total_hp(ci) / (WAVE_TIME * 0.5)
	var v = a; var won = 0
	for i in nw:
		if dps >= need: v = minf(100.0, v + 2.0); won += 1
		else: v -= 8.0
	v = clampf(maxf(v, minf(a, OFF_FLOOR)), 0.0, 100.0)
	w.inf[str(ci)] = v
	if nw > 0: w.wave_t = WAVE_GAP
	var r = {"waves": nw, "won": won, "from": a, "to": v}
	if nw > 0: NEWS.append({"off": true, "from": a, "to": v, "waves": nw, "won": won})
	return r

# ================= 拔營 =================
func on_move(sim, from_ci: int) -> void:
	var w = ws(); if w == null: return
	w.vol = []; w.alarm = null; w.exp = null; w.occ.erase(str(from_ci))
	w.wave_t = WAVE_FIRST
	reset_live()

# ================================================================
# 畫面（mv_scene 嘅掛鈎叫；sc = 場景，ctx = Ctx）
# ================================================================
func eat(sc) -> void:
	var sim = sc.sim
	var r = poll()
	while NEWS.size():
		var n = NEWS.pop_front()
		if n.get("off", false):
			if int(n.waves) > 0:
				sc._banner_set(T("war_off_a", "你唔喺度嗰陣嚟咗 %d 波鬼潮", "你不在時來了 %d 波鬼潮") % int(n.waves),
					T("war_off_b", "影響力 %d → %d", "影響力 %d → %d") % [int(n.from), int(n.to)], 3.0)
		elif n.win:
			sc._banner_set(T("war_exp_win", "出征凱旋！影響力 +%d", "出征凱旋！影響力 +%d") % int(n.d), T("war_exp_win_b", "孤魂執包袱走人", "孤魂捲鋪蓋走人"), 3.0)
			sc._snd("levelUp")
		else:
			sc._banner_set(T("war_exp_lose", "出征失手", "出征失利"), T("war_exp_lose_b", "執好隊再嚟過", "整好隊伍再來"), 2.6)
	for e in sim.ev:
		match str(e.k):
			"war_join":
				sc._bubble(e.pos + Vector2(-60, -50), str(e.line), T("war_vol", "義勇軍", "義勇軍"), 2.6)
				sc._burst(e.pos, Color("#bff0a0"), 10)
			"war_retire":
				sc._float(e.pos, T("war_retire", "退休返屋企", "退休回家"), Color("#e8dcc4"), 15, 1.4)
			"war_vdie":
				sc._burst(e.pos, Color("#f2e2c0"), 14)
				sc._float(e.pos, T("war_vdie", "義勇軍散咗　影響力 %d", "義勇軍散了　影響力 %d") % int(e.d), Color("#ffb0a0"), 15, 1.6)
				sc._bubble(e.pos + Vector2(-60, -40), str(e.line), T("war_vol", "義勇軍", "義勇軍"), 2.2)
			"war_steal":
				sc._item(e.from, e.to, str(e.gid), 0.6)
				sc._float(e.pos, T("war_steal", "畀孤魂偷咗 %s 件！", "被孤魂偷了 %s 件！") % MD.fmt(e.n), Color("#ffb0a0"), 16, 1.5)
				sc._bubble(e.pos + Vector2(-60, -40), str(e.line), T("foe", "孤魂", "孤魂"), 2.0)
				sc._snd("scare")
			"war_scare":
				sc._float(e.pos, T("war_scare", "孤魂嚇走咗客！", "孤魂嚇跑了客人！"), Color("#ffb0a0"), 16, 1.5)
				sc._bubble(e.pos + Vector2(-60, -40), str(e.line), T("foe", "孤魂", "孤魂"), 2.0)
			"war_warn":
				if not e.has("said"): sc._float(sc.s2w(Vector2(195, sc.top_pad + HUD_H + 90)), T("war_warn", "圍欄外面好嘈……鬼潮就嚟！", "圍欄外很吵……鬼潮快來了！"), Color("#ffd27a"), 17, 2.2)   # [story] said：mv_story 已經出咗 FOE.wave
			"war_wave":
				sc._banner_set(T("war_wave_a", "鬼潮嚟喇！", "鬼潮來了！"), T("war_wave_b", "%d 隻孤魂衝圍欄", "%d 隻孤魂衝圍欄") % int(e.n), 2.4)
				sc._snd("whoosh")
			"war_won":
				sc._banner_set(T("war_won_a", "守住喇！影響力 +%d", "守住了！影響力 +%d") % int(e.d), "+" + MD.fmt(e.coins) + " " + T("coin", "冥幣", "冥幣"), 2.4)
				sc._snd("chest")
			"war_lost":
				sc._banner_set(T("war_lost_a", "畀鬼潮衝咗入嚟", "被鬼潮衝了進來"), T("war_lost_b", "影響力 %d", "影響力 %d") % int(e.d), 2.6)
				sc._snd("lose")
			"war_alarm":
				sc._banner_set(T("war_alarm_a", "告急！", "告急！"), T("war_alarm_b", "影響力跌穿 %d，孤魂想霸檔", "影響力跌破 %d，孤魂想霸攤") % int(ALARM), 2.8)
				sc._snd("scare")
			"war_occ":
				sc._banner_set(T("war_occ_a", "有檔畀孤魂霸咗！", "有攤位被孤魂霸佔！"), MD.T(MD.st_def(str(e.sid)).get("n")), 2.8)
			"war_calm":
				sc._float(sc.s2w(Vector2(195, sc.top_pad + HUD_H + 90)), T("war_calm", "告急解除", "告急解除"), Color("#9fe39a"), 18, 1.8)

# ---------------- 世界：義勇軍＋霸檔標記 ----------------
func draw_world(sc, ctx, vy0: float, vy1: float) -> void:
	var sim = sc.sim
	var os = occ_sid()
	if os != "": _draw_occ(sc, ctx, sim, os)
	var vs = vols.duplicate(); vs.sort_custom(func(a, b): return a.pos.y < b.pos.y)
	for r in vs:
		if r.pos.y < vy0 - 20.0 or r.pos.y - 120.0 > vy1: continue
		_draw_vol(sc, ctx, r)

func _draw_vol(sc, ctx, r: Dictionary) -> void:
	var o = {"t": sc.t + r.ph, "walk": r.get("walk", false), "flip": r.get("flip", false), "tamed": true, "shadow": true}
	if r.has("atk_t"): o["atk"] = true
	if r.has("hurt"): o["hurt"] = true
	var p = r.pos; var s = CS * 0.9
	if sc.get("mot") == null or not sc.mot.vol(sc, ctx, r, p.x, p.y, s, o): Art.draw_char(ctx, str(r.d.k), p.x, p.y, s, o)   # [motion]
	# 著住嘅紙紮裝備：顏色帶＋件貨細圖
	var ms = main_slot(r.d.g); var col = SLOT_COL.get(ms[1], "#e05a8a")
	var by = {"body": -30.0, "legs": -12.0, "head": -54.0, "hand": -26.0, "shield": -26.0}.get(ms[1], -30.0)
	ctx.save(); ctx.globalAlpha = 0.85
	Art.rr(ctx, p.x - 13, p.y + by - 4, 26, 7, 3, col, "#2a1a10", 1)
	ctx.restore()
	if ms[0] != "":
		var ix = p.x + (14.0 if ms[1] in ["hand", "shield"] else 0.0) * (-1.0 if r.get("flip", false) else 1.0)
		sc._icon(ctx, ms[0], ix, p.y + by + 12.0, 22.0 if ms[1] == "shield" else 18.0)
	# 血條（受過傷先出）
	var hp = J.num(r.d.hp); var mx = maxf(1.0, J.num(r.d.mx))
	if hp < mx:
		Art.rr(ctx, p.x - 17, p.y - 66, 34, 6, 3, "rgba(0,0,0,.7)")
		Art.rr(ctx, p.x - 16, p.y - 65, 32 * clampf(hp / mx, 0, 1), 4, 2, "#7ad06a")
	if r.st == "post": sc._txt(ctx, T("war_vol_tag", "義勇", "義勇"), p.x, p.y + 12, 14, Color("#bff0a0"), "center", 900, 4)

func _draw_occ(sc, ctx, sim, sid: String) -> void:
	var p = sim.st_pos(sid); var tt = sc.t
	ctx.save(); ctx.globalAlpha = 0.9
	ctx.strokeStyle = "#b8322a"; ctx.lineWidth = 9; ctx.lineCap = "round"
	ctx.beginPath(); ctx.moveTo(p.x - 54, p.y - 96); ctx.lineTo(p.x + 54, p.y - 8); ctx.stroke()
	ctx.beginPath(); ctx.moveTo(p.x + 54, p.y - 96); ctx.lineTo(p.x - 54, p.y - 8); ctx.stroke()
	ctx.strokeStyle = "#f2e2c0"; ctx.lineWidth = 2
	ctx.beginPath(); ctx.moveTo(p.x - 54, p.y - 96); ctx.lineTo(p.x + 54, p.y - 8); ctx.stroke()
	ctx.beginPath(); ctx.moveTo(p.x + 54, p.y - 96); ctx.lineTo(p.x - 54, p.y - 8); ctx.stroke()
	ctx.restore()
	var ks = MD.map_def(sim.ci()).get("fence_foes", ["youhun"])
	var k = str(ks[0]) if ks is Array and ks.size() else "youhun"
	Art.draw_char(ctx, k, p.x + 34, p.y - 46 + sin(tt * 2.0) * 3.0, CS * 0.8, {"t": tt, "flip": true, "alpha": 0.92, "noShadow": true})
	var s1 = T("war_occ_tag", "畀孤魂霸咗", "被孤魂霸佔"); var s2 = T("war_occ_tag2", "出征打贏先復工", "出征打贏才復工")
	ctx.font = "900 15px sans-serif"; var tw = maxf(ctx.measureText(s1).width, 0.0)
	ctx.font = "900 14px sans-serif"; tw = maxf(tw, ctx.measureText(s2).width) + 16.0
	var bx = clampf(p.x - tw / 2.0, sc.vx0() + 4.0, sc.vx1() - tw - 4.0); var y = p.y + 74.0   # 名牌＋Lv 下面（[zone] 夾喺可見範圍）
	Art.rr(ctx, bx, y, tw, 42, 7, "rgba(60,10,8,.88)", "#ff8a7a", 1.5)
	sc._txt(ctx, s1, bx + tw / 2.0, y + 13, 15, Color("#ffd8c8"), "center", 900, 0)
	sc._txt(ctx, s2, bx + tw / 2.0, y + 30, 14, Color("#ffd27a"), "center", 900, 0)

# 頭目：放大＋名牌（mv_scene._draw_foe 第一行掛鈎）
func draw_boss(sc, ctx, f: Dictionary) -> void:
	var a = 0.95
	if f.st == "die": a = maxf(0.0, 0.95 - f.t * 1.3)
	var y = f.pos.y + float(f.get("bob", 0.0)) + sin(sc.t * 2.0 + f.ph) * 2.0
	var o = {"t": sc.t + f.ph, "walk": f.get("walk", false) or f.st == "bang", "flip": f.get("flip", false), "alpha": a, "noShadow": true}
	if f.has("hurt"): o["hurt"] = true
	if f.st == "bang": o["atk"] = true
	Art.el(ctx, f.pos.x, y - 40, 48, 44, "rgba(255,120,100,.14)")
	if sc.get("mot") == null or not sc.mot.boss(sc, ctx, f, f.pos.x, y, CS * 1.45, o): Art.draw_char(ctx, str(f.k), f.pos.x, y, CS * 1.45, o)   # [motion]
	if f.st == "die": return
	var w = 56.0
	Art.rr(ctx, f.pos.x - w / 2 - 1, y - 96, w + 2, 8, 3, "rgba(0,0,0,.75)")
	Art.rr(ctx, f.pos.x - w / 2, y - 95, w * clampf(f.hp / f.mx, 0, 1), 6, 2, "#ff5a3a")
	var ET = J.G.get("ENEMY_T"); var nm = str(f.k)
	if ET is Dictionary and ET.get(str(f.k)) is Array: nm = J.str(ET[str(f.k)][2])
	elif J.G.get("GHOSTS") is Dictionary and J.G.GHOSTS.get(str(f.k)) is Dictionary: nm = J.str(J.G.GHOSTS[str(f.k)].get("name", f.k))
	sc._txt(ctx, T("war_boss", "大佬・%s", "老大・%s") % nm, f.pos.x, y - 108, 15, Color("#ffd27a"), "center", 900, 4)

# ---------------- 頂部：影響力條、義勇軍數、鬼潮倒數、告急、出征掣 ----------------
func hud_y(sc) -> float:
	var sim = sc.sim; var y = sc.top_pad + HUD_H + 2.0
	if sc.anim == null and sim.can_move(): return y + 62.0
	var gi = sim.cur_goal(); var G = MD.goals(sim.ci())
	if gi >= 0 and str(G[gi].get("t")) == "boss" and not sim.boss_ok(sim.ci(), str(G[gi].get("k", ""))): return y + 28.0
	return y
func draw_hud(sc, ctx) -> void:
	_btn.clear()
	var sim = sc.sim; var w = ws(); if w == null: return
	var tt = sc.t; var y = hud_y(sc); var v = inf()
	var al = alarm_on() or occ_sid() != ""
	var flash = 0.5 + 0.5 * sin(tt * 7.0)
	if al:   # 畫面邊紅光閃
		var g = ctx.createLinearGradient(0, sc.top_pad, 0, sc.top_pad + 40); g.addColorStop(0, "rgba(220,40,30,%.2f)" % (0.35 * flash)); g.addColorStop(1, "rgba(220,40,30,0)")
		ctx.fillStyle = g; ctx.fillRect(0, sc.top_pad + HUD_H, FW, 40)
	var x0 = 178.0; var bw = FW - x0 - 6.0
	Art.rr(ctx, x0, y, bw, 42, 8, "rgba(10,6,14,.72)" if not al else "rgba(80,10,8,%.2f)" % (0.6 + 0.3 * flash), "#5e4a30" if not al else "#ff8a7a", 1.5)
	# 第一行：影響力 [條] 數
	var lab = T("war_inf", "影響力", "影響力")
	sc._txt(ctx, lab, x0 + 8, y + 12, 14, Color("#f0e2c8"), "left", 900, 0)
	ctx.font = "900 14px sans-serif"; var lw = ctx.measureText(lab).width
	var bx = x0 + 14.0 + lw; var bl = bw - (bx - x0) - 40.0
	Art.rr(ctx, bx, y + 7, bl, 10, 5, "rgba(255,255,255,.12)", "#8a7a6a", 1)
	var col = "#5aa05a" if v >= 60.0 else ("#c0902a" if v >= ALARM else "#d8452e")
	Art.rr(ctx, bx, y + 7, bl * v / 100.0, 10, 5, col)
	for mk in [ALARM, 60.0]:   # 警戒線、正常線
		ctx.fillStyle = "#ffd27a" if mk == ALARM else "rgba(255,255,255,.5)"; ctx.fillRect(bx + bl * mk / 100.0 - 1, y + 4, 2, 16)
	sc._txt(ctx, MD.fmt(round(v)), x0 + bw - 8, y + 12, 15, Color(col), "right", 900, 3)
	# 第二行：義勇軍數＋鬼潮
	var s2 = T("war_vols", "義勇軍 %d/%d", "義勇軍 %d/%d") % [w.vol.size(), VOL_MAX]
	var s3 = ""
	if wave != null:
		var left = 0
		for f in wave.foes: if f.st != "die" and f.st != "flee" and sim.foes.has(f): left += 1
		s3 = T("war_wave_on", "鬼潮中 剩%d隻 %d秒", "鬼潮中 剩%d隻 %d秒") % [left + wave.q.size(), int(maxf(0.0, WAVE_TIME - wave.t))]
	else: s3 = T("war_wave_in", "鬼潮 %s", "鬼潮 %s") % sc._mmss(maxf(0.0, J.num(w.wave_t)))
	sc._txt(ctx, s2, x0 + 8, y + 31, 14, Color("#bff0a0"), "left", 900, 0)
	sc._txt(ctx, s3, x0 + bw - 8, y + 31, 14, Color("#ffd27a") if wave != null else Color("#d8ccb8"), "right", 900, 0)
	if newbie() and sim.ci() == 0:
		sc._txt(ctx, T("war_newbie", "新手保護 %s", "新手保護 %s") % sc._mmss(NEWBIE - J.num(w.t0)), 10, y + 31, 14, Color("#9fd8ff"), "left", 900, 4)
	# 告急：出征掣
	if al and sc.anim == null:
		var pw = bw * (1.0 + 0.03 * sin(tt * 6.0)); var cx = x0 + bw / 2.0; var px = cx - pw / 2.0; var py = y + 48.0
		var gl = ctx.createRadialGradient(cx, py + 26, 10, cx, py + 26, 130); gl.addColorStop(0, "rgba(255,90,60,.35)"); gl.addColorStop(1, "rgba(255,90,60,0)")
		ctx.fillStyle = gl; ctx.fillRect(x0 - 30, py - 20, bw + 36, 94)
		Art.rr(ctx, px, py, pw, 54, 12, "#9c2219", "#ffd27a", 3)
		sc._txt(ctx, T("war_alarm_tag", "告急", "告急") + "！" + T("war_exp_btn", "親自出征", "親自出征"), cx, py + 18, 19, Color("#fff3e0"), "center", 900, 4, "serif")
		var sub = ""
		if occ_sid() != "": sub = T("war_exp_sub2", "打贏先攞返個檔", "打贏才能拿回攤位")
		else: sub = T("war_exp_sub", "%s 後有檔畀孤魂霸", "%s 後攤位會被孤魂霸佔") % sc._mmss(maxf(0.0, J.num(w.alarm.t)))
		sc._txt(ctx, sub, cx, py + 40, 14, Color("#ffd8c8"), "center", 900, 3)
		_btn["exp"] = Rect2(px, py, pw, 54)

func tap(sc, p: Vector2) -> bool:
	if _btn.has("exp") and _btn.exp.grow(4).has_point(p):
		var r = start_expedition(sc.sim)
		sc._snd("click")
		return r != "noneed"
	# 頭目大隻：撳中範圍大啲（世界座標）
	if p.y >= sc.top_pad + HUD_H and wave != null and wave.boss != null and sc.sim.foes.has(wave.boss) and wave.boss.st != "die":
		var wp = sc.s2w(p); var b = wave.boss
		if wp.distance_to(b.pos + Vector2(0, -45)) < 52.0:
			sc.sim.hit_foe(b, MD.TAP_DMG, "tap"); return true
	return false
