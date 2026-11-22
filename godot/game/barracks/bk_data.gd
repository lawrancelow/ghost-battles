# [barracks] 第三期：陰兵兵營＋派遣＋名鬼分配（資料＋規則，全部 static；冇 class_name、冇 autoload）
#   const BK = preload("res://game/barracks/bk_data.gd")
#
# 存檔 S.army（本線擁有；讀一律 .get(key, 預設)）：
#   def:int            村子防衛陰兵數
#   sweep:{zid:int}    野外清剿（zid＝而家呢張圖嘅野外區 id）
#   cap_def:[鬼id]     防衛隊長（名鬼）
#   cap_sweep:{zid:鬼id} 清剿隊長
#   （本線自用）v、floor（舊存檔戰力保底倍率）、t（清剿上次結算 ms）、lacc（折損累積分鐘）、story（兵營劇情播咗未）、earn（清剿累計收入，顯示用）
#
# 規則：
#   陰兵總數仍然係 S.res.troops（民宅產）。待命 = 總數 − 防衛 − 清剿；攻佔（ZD.capture_auto）只用待命。
#   戰力倍率 troop_mul = max(1 + 0.08 × 兵營等級, floor)；floor＝升級前舊存檔嘅民宅加成 1 + 0.08 × max(0, 民宅 − 1)（只記一次，唔會變弱）
#   兵營等級 L：陰兵上限 +100L、民宅招兵速度 ×(1 + 0.15L)、戰力倍率 1 + 0.08L、防衛隊長名額 1 + floor(L/5)、每區清剿上限 100 + 50L
#   清剿：每分鐘 冥幣 0.03 × 有效戰力 × (1 + 0.25 × 關數)、棺材板 0.008 × 有效戰力（倉庫上限內）；每 10 分鐘折損 1%（最少 1）
#         清剿隊長：收入 ×(1 + 0.015 × 等級)、折損 ×max(0.3, 1 − 0.02 × 等級)；離線（未結算）最多計 240 分鐘
#   名鬼（q＝名）每隻同時只做一件事：出陣／生產（村子工位）／防衛隊長／清剿隊長／閒著；切換時自動由原職務移走。
extends RefCounted

const ZD = preload("res://game/zone/zone_data.gd")
const AT = preload("res://game/outpost/act_targets.gd")
const ID := "barracks"
const NAME := "陰兵兵營"
const REL := Vector2(770, 610)          # 分區地圖：相對村子區左上角（六關村子佈局一樣）
const OLD_POS := [330.0, 880.0]         # 舊豎條村子（冇分區地圖時）
const BUILD := {"planks": 100.0, "coins": 150.0}
const POW_K := 0.08
const TRAIN_K := 0.15
const CAP_K := 100.0
const SWEEP_BASE := 100
const SWEEP_PER_LV := 50
const COIN_K := 0.03
const PLANK_K := 0.008
const LOSS_EVERY := 10.0                # 分鐘
const LOSS_P := 0.01
const OFFLINE_CAP_MIN := 240.0
const STEP := 10                        # 派遣加減掣一下幾多

static var _inst_ref = null
static var _at_done := false
static var test_now := -1.0             # 測試：指定「而家」（ms）

# ---------------- 安裝（建築資料、POS、行動目標） ----------------
static func S() -> Variant:
	var s = J.G.get("S")
	return s if s is Dictionary and not s.is_empty() else null
static func zh() -> bool: return DB.lang != "yue"
static func T(yue: String, zhs: String) -> String: return str(DB.N(zhs if zh() else yue))

static func bdef() -> Dictionary:
	return {"name": NAME, "desc": "陰兵住的地方。升級可以提高陰兵上限、民宅招兵速度和陰兵戰力；在這裡派陰兵去守村、去野外清剿，或者留下待命攻佔。名鬼可以當防衛隊長、清剿隊長。",
		"build": BUILD.duplicate(), "posts": [], "unlockBld": "home"}
static func install() -> void:
	var B = J.G.get("BUILDINGS")
	if B is Dictionary and not B.has(ID): B[ID] = bdef()
	var O = J.G.get("BLD_ORDER")
	if O is Array and not O.has(ID): O.append(ID)
	var D = DB.D
	if D is Dictionary:
		if D.get("BUILDINGS") is Dictionary and not D.BUILDINGS.has(ID): D.BUILDINGS[ID] = bdef()
		if D.get("BLD_ORDER") is Array and not D.BLD_ORDER.has(ID): D.BLD_ORDER.append(ID)
	var FL = J.G.get("FLAVOR")
	if FL is Dictionary and not FL.has(ID): FL[ID] = "一排紙紮頭盔掛在竹架上。陰兵沒有腳，所以操步靠飄，敬禮靠誠意。"
	var P = J.G.get("POS")
	if P is Dictionary and not P.has(ID): P[ID] = pos_now()
	if not _at_done:
		_at_done = true
		AT.providers.append(func(game): return targets(game))
# 而家呢張圖兵營喺邊（分區地圖：村子區左上角 + REL）
static func pos_now() -> Array:
	if ZD.on():
		var vr = ZD.zrect("village")
		if vr.size != Vector2.ZERO: return [vr.position.x + REL.x, vr.position.y + REL.y]
	return OLD_POS.duplicate()
# ZD.apply() 換咗 POS 之後叫
static func on_apply() -> void:
	install()
	var P = J.G.get("POS")
	if P is Dictionary: P[ID] = pos_now()

# ---------------- 狀態 ----------------
static func now_ms() -> float: return test_now if test_now >= 0 else J.now()
static func st() -> Variant:
	var s = S()
	if s == null: return null
	if not (s.get("army") is Dictionary): s["army"] = {}
	var a = s.army
	if int(J.num(a.get("v", 0))) < 1: _migrate(s, a)
	for k in ["sweep", "cap_sweep"]: if not (a.get(k) is Dictionary): a[k] = {}
	if not (a.get("cap_def") is Array): a["cap_def"] = []
	return a
# 舊存檔：記低民宅加成做保底（戰力唔會因為加成搬咗去兵營而跌）
static func _migrate(s: Dictionary, a: Dictionary) -> void:
	var home = J.num(s.bld.get("home", 0)) if s.get("bld") is Dictionary else 0.0
	a["v"] = 1.0
	a["floor"] = 1.0 + POW_K * maxf(0.0, home - 1.0)
	if not a.has("def"): a["def"] = 0.0
	a["t"] = now_ms()
	a["lacc"] = 0.0
	a["earn"] = {"coins": 0.0, "planks": 0.0, "lost": 0.0}
static func lv() -> int:
	var s = S()
	return int(J.num(s.bld.get(ID, 0))) if s != null and s.get("bld") is Dictionary else 0
static func built() -> bool: return lv() > 0
static func unlocked() -> bool:
	var s = S()
	return s != null and J.num(s.bld.get("home", 0)) > 0

static func effect_text() -> String: return load("res://game/barracks/bk_ui.gd").effect_text()   # 建築卡效果行

# ---------------- 數值 ----------------
static func troop_mul() -> float:
	var a = st()
	if a == null: return 1.0
	return maxf(1.0 + POW_K * lv(), J.num(a.get("floor", 1.0)))
static func cap_bonus() -> float: return CAP_K * lv()
static func train_mul() -> float: return 1.0 + TRAIN_K * lv()
static func max_def_caps() -> int: return 0 if lv() <= 0 else 1 + int(lv() / 5)
static func sweep_cap() -> int: return SWEEP_BASE + SWEEP_PER_LV * lv()
static func total() -> int:
	var s = S()
	return int(floor(J.num(s.res.get("troops", 0)))) if s != null else 0
static func def_n() -> int:
	var a = st()
	return int(J.num(a.get("def", 0))) if a != null else 0
static func sweep_n(zid := "") -> int:
	var a = st()
	if a == null: return 0
	if zid != "": return int(J.num(a.sweep.get(zid, 0)))
	var n = 0
	for k in a.sweep: n += int(J.num(a.sweep[k]))
	return n
static func reserved() -> int: return def_n() + sweep_n()
static func standby() -> int: return maxi(0, total() - reserved())
# 陰兵（總數）唔夠派遣數（例如打仗死咗）：先減清剿、再減防衛
static func normalize() -> void:
	var a = st()
	if a == null: return
	var over = reserved() - total()
	if over <= 0: return
	for k in a.sweep.keys():
		var take = mini(over, int(J.num(a.sweep[k])))
		a.sweep[k] = float(int(J.num(a.sweep[k])) - take); over -= take
		if int(J.num(a.sweep[k])) <= 0: a.sweep.erase(k)
		if over <= 0: return
	a["def"] = float(maxi(0, def_n() - over))
# 攻佔戰力（待命）
static func power() -> int:
	normalize()
	return int(floor(float(standby()) * troop_mul()))
static func glv(g) -> float:
	return float(load("res://native/game.gd").glv(g)) if g is Dictionary else 0.0
static func ghost(id) -> Variant:
	var s = S()
	if s == null or id == null: return null
	for g in s.get("ghosts", []):
		if J.str(g.get("id")) == J.str(id): return g
	return null
# 防衛隊長加成：每位 +1.2% × 等級（合共最多 +60%）
static func def_cap_bonus() -> float:
	var a = st()
	if a == null: return 0.0
	var b = 0.0
	for id in a.cap_def:
		var g = ghost(id)
		if g != null: b += 0.012 * glv(g)
	return minf(0.6, b)
# 防衛戰力（raid 線讀）
static func def_power() -> int:
	normalize()
	return int(floor(float(def_n()) * troop_mul() * (1.0 + def_cap_bonus())))

# ---------------- 派遣 ----------------
static func set_def(n: int) -> int:
	var a = st()
	if a == null: return 0
	var mx = def_n() + standby()
	a["def"] = float(clampi(n, 0, mx))
	_save()
	return def_n()
static func add_def(d: int) -> int: return set_def(def_n() + d)
static func sweep_zones() -> Array:   # 可以清剿嘅野外區（呢張圖、王全部打低）
	var o = []
	if not ZD.on(): return o
	for z in ZD.of_type("wild"):
		if ZD.wild_done(str(z.id)): o.append(str(z.id))
	return o
static func zone_name(zid: String) -> String:
	var z = ZD.zone(zid)
	if z.is_empty(): return zid
	return str(DB.N(ZD.T(z.get("n", [zid, zid])))).trim_prefix("野外區").strip_edges().trim_prefix("　").strip_edges()
static func set_sweep(zid: String, n: int) -> int:
	var a = st()
	if a == null: return 0
	if not (zid in sweep_zones()): return 0
	var cur = sweep_n(zid)
	var v = clampi(n, 0, mini(sweep_cap(), cur + standby()))
	if v <= 0: a.sweep.erase(zid)
	else:
		if cur == 0 and sweep_n() == 0: a["t"] = now_ms(); a["lacc"] = 0.0   # 第一隊出發：由而家開始計
		a.sweep[zid] = float(v)
	_save()
	return sweep_n(zid)
static func add_sweep(zid: String, d: int) -> int: return set_sweep(zid, sweep_n(zid) + d)
# 換咗圖／區唔再可以清剿：收隊（陰兵返待命），隊長變閒
static func _recall_invalid() -> void:
	var a = st()
	if a == null: return
	var ok = sweep_zones()
	for k in a.sweep.keys(): if not (str(k) in ok): a.sweep.erase(k)
	for k in a.cap_sweep.keys(): if not (str(k) in ok): a.cap_sweep.erase(k)

# 每分鐘收入／每 10 分鐘折損（一區）
static func sweep_rate(zid: String) -> Dictionary:
	var a = st(); var n = sweep_n(zid)
	if a == null or n <= 0: return {"coins": 0.0, "planks": 0.0, "loss": 0}
	var eff = float(n) * troop_mul()
	var g = ghost(a.cap_sweep.get(zid))
	var cb = 1.0 + (0.015 * glv(g) if g != null else 0.0)
	var lf = maxf(0.3, 1.0 - 0.02 * glv(g)) if g != null else 1.0
	var tier = 1.0 + 0.25 * float(ZD.ci())
	return {"coins": COIN_K * eff * tier * cb, "planks": PLANK_K * eff * cb, "loss": maxi(1, int(ceil(float(n) * LOSS_P * lf)))}

# 結算清剿（每格叫都得：唔夠 1 分鐘唔做嘢）。回 {"min":結算分鐘, "coins", "planks", "lost"}
static func tick(now := -1.0) -> Dictionary:
	var a = st()
	var out = {"min": 0.0, "coins": 0.0, "planks": 0.0, "lost": 0}
	if a == null: return out
	var nw = now if now >= 0 else now_ms()
	if ZD.on(): _recall_invalid()
	normalize()
	var t0 = J.num(a.get("t", nw))
	if sweep_n() <= 0: a["t"] = nw; return out
	var ts = J.num(J.G.get("TIME_SCALE")) if J.G.get("TIME_SCALE") != null else 1.0
	if ts <= 0: ts = 1.0
	var mins = floor((nw - t0) * ts / 60000.0)
	if mins < 1: return out
	var use = minf(mins, OFFLINE_CAP_MIN)
	a["t"] = nw if mins > OFFLINE_CAP_MIN else t0 + mins * 60000.0 / ts
	var s = S(); var cp = J.num(J.mc(J.G.get("F"), "cap", [])) if J.G.get("F") != null else 1e12
	var co = 0.0; var pl = 0.0
	for zid in a.sweep.keys():
		var r = sweep_rate(str(zid))
		co += r.coins * use; pl += r.planks * use
	s.res["coins"] = J.num(s.res.get("coins", 0)) + co
	var p0 = J.num(s.res.get("planks", 0))
	if p0 < cp: s.res["planks"] = minf(cp, p0 + pl)
	# 折損：每 LOSS_EVERY 分鐘一次
	var lacc = J.num(a.get("lacc", 0)) + use
	var lost = 0
	while lacc >= LOSS_EVERY:
		lacc -= LOSS_EVERY
		for zid in a.sweep.keys():
			var l = mini(int(sweep_rate(str(zid)).loss), sweep_n(str(zid)))
			a.sweep[zid] = float(sweep_n(str(zid)) - l)
			s.res["troops"] = maxf(0.0, J.num(s.res.get("troops", 0)) - l)
			lost += l
			if sweep_n(str(zid)) <= 0: a.sweep.erase(zid); a.cap_sweep.erase(zid)
	a["lacc"] = lacc
	if not (a.get("earn") is Dictionary): a["earn"] = {"coins": 0.0, "planks": 0.0, "lost": 0.0}
	a.earn["coins"] = J.num(a.earn.get("coins", 0)) + co; a.earn["planks"] = J.num(a.earn.get("planks", 0)) + pl; a.earn["lost"] = J.num(a.earn.get("lost", 0)) + lost
	out = {"min": use, "coins": co, "planks": pl, "lost": lost}
	if use >= 30 and J.G.get("Fx") != null:   # 離線返嚟：一句提示
		J.mc(J.G.get("Fx"), "toast", [T("野外清剿 %d 分鐘：冥幣 +%d、棺材板 +%d，折損陰兵 %d", "野外清剿 %d 分鐘：冥幣 +%d、棺材板 +%d，折損陰兵 %d") % [int(use), int(co), int(pl), lost]])
	return out
# main.gd 每 0.5 秒叫
static func poll() -> void:
	install()
	if S() == null: return
	tick()

# ---------------- 名鬼分配（每隻同時只做一件事） ----------------
static func is_named(g) -> bool: return g is Dictionary and J.str(g.get("q")) == "名"
static func village_post(p) -> bool:
	var P = J.G.get("POSTS")
	return p != null and J.t(p) and P is Dictionary and P.has(J.str(p))
# 回 "team"／"post"／"away"（村外工作：站崗、樓裡有鬼…）／"cap_def"／"cap_sweep"／"idle"
static func job(g) -> String:
	var s = S(); var a = st()
	if s == null or not (g is Dictionary): return "idle"
	var id = J.str(g.get("id"))
	if J.iter(s.get("team", [])).has(g.get("id")): return "team"
	if a != null:
		for x in a.cap_def: if J.str(x) == id: return "cap_def"
		for k in a.cap_sweep: if J.str(a.cap_sweep[k]) == id: return "cap_sweep"
	var p = g.get("post")
	if p != null and J.t(p): return "post" if village_post(p) else "away"
	return "idle"
static func job_label(g) -> String:
	match job(g):
		"team": return T("出陣", "出陣")
		"post": return T("生產：", "生產：") + str(J.gp(J.G.get("POSTS")[J.str(g.post)], "name"))
		"away": return T("村外工作中", "村外工作中")
		"cap_def": return T("防衛隊長", "防衛隊長")
		"cap_sweep":
			var a = st()
			for k in a.cap_sweep: if J.str(a.cap_sweep[k]) == J.str(g.id): return T("清剿隊長・", "清剿隊長・") + zone_name(str(k))
	return T("閒著", "閒著")
# 由所有職務移走（keep＝唔郁嗰樣）
static func clear_roles(g, keep := "") -> void:
	var s = S(); var a = st()
	if s == null or not (g is Dictionary): return
	var id = g.get("id")
	if keep != "team" and s.get("team") is Array:
		for i in s.team.size(): if s.team[i] != null and J.str(s.team[i]) == J.str(id): s.team[i] = null
	if keep != "post" and village_post(g.get("post")): g["post"] = null
	if a != null:
		if keep != "cap_def": a["cap_def"] = a.cap_def.filter(func(x): return J.str(x) != J.str(id))
		if keep != "cap_sweep":
			for k in a.cap_sweep.keys(): if J.str(a.cap_sweep[k]) == J.str(id): a.cap_sweep.erase(k)
# 設定職務：job ∈ team／post（arg＝工位 id）／cap_def（arg＝要換走嘅鬼 id，可空）／cap_sweep（arg＝野外區 id）／idle
# 回 "ok" 或者原因
static func set_job(gid, jb: String, arg = null) -> String:
	var s = S(); var a = st(); var g = ghost(gid)
	if s == null or g == null: return T("搵唔到呢隻鬼", "找不到這隻鬼")
	if not is_named(g): return T("只有名鬼可以分配", "只有名鬼可以分配")
	if job(g) == "away" and jb != "away": return T("佢喺村外工作緊，先喺嗰邊撤返", "他在村外工作中，先在那邊撤回")
	match jb:
		"team":
			if not (s.get("team") is Array): s["team"] = [null, null, null]
			if s.team.has(g.id): clear_roles(g, "team"); _save(); return "ok"
			var i = s.team.find(null)
			if i < 0 and arg != null:
				for j in s.team.size(): if J.str(s.team[j]) == J.str(arg): i = j
			if i < 0: return T("出陣已滿（最多 3）", "出陣已滿（最多 3）")
			clear_roles(g)
			s.team[i] = g.id
		"post":
			var post = J.str(arg)
			var F = J.G.get("F")
			var n = int(J.num(J.mc(F, "slots", [post]))) if F != null else 0
			if n <= 0: return T("呢個工位未開", "這個工位還沒開")
			clear_roles(g)
			var ws = []
			for x in s.ghosts: if J.str(x.get("post")) == post and not is_same(x, g): ws.append(x)
			if ws.size() >= n: ws[0]["post"] = null
			g["post"] = post
		"cap_def":
			if not built(): return T("先起兵營", "先建兵營")
			var mx = max_def_caps()
			if a.cap_def.has(g.id) or _has_id(a.cap_def, g.id): clear_roles(g, "cap_def"); _save(); return "ok"
			if a.cap_def.size() >= mx:
				if arg == null: return T("防衛隊長已滿（兵營 Lv%d 最多 %d 位）", "防衛隊長已滿（兵營 Lv%d 最多 %d 位）") % [lv(), mx]
				a["cap_def"] = a.cap_def.filter(func(x): return J.str(x) != J.str(arg))
			clear_roles(g)
			a.cap_def.append(g.id)
		"cap_sweep":
			if not built(): return T("先起兵營", "先建兵營")
			var zid = J.str(arg)
			if not (zid in sweep_zones()): return T("呢區未可以清剿（要先打低區內所有王）", "這區還不能清剿（要先打倒區內所有王）")
			clear_roles(g)
			a.cap_sweep[zid] = g.id
		"idle": clear_roles(g)
		_: return "?"
	_save()
	var ui = J.G.get("UI")
	if ui != null: J.mc(ui, "refresh", [])
	return "ok"
static func _has_id(arr: Array, id) -> bool:
	for x in arr: if J.str(x) == J.str(id): return true
	return false
# 掛鈎：派人去工位（native/game.gd n_pick_do）、佈陣（bt_select._put）之後叫：名鬼由其他職務移走
static func after_post(g) -> void:
	if is_named(g): clear_roles(g, "post")
static func after_team(id) -> void:
	var g = ghost(id)
	if is_named(g): clear_roles(g, "team")
# 名冊／派人清單顯示
static func roster_entry(g, e: Dictionary) -> void:
	if not is_named(g): return
	e["job"] = true
	var j = job(g)
	if j == "cap_def" or j == "cap_sweep":
		e["tag"] = job_label(g).split("・")[0]
		e["where"] = job_label(g)
	elif j == "post" and J.iter(S().get("team", [])).has(g.get("id")): e["where"] = str(e.get("where", "")) + T("（兼出陣：舊安排，再分配會自動分開）", "（兼出陣：舊安排，再分配會自動分開）")
static func where_txt(g, orig: String) -> String:
	var j = job(g)
	if j == "cap_def" or j == "cap_sweep" or (j == "team" and orig == "閒著"): return job_label(g)
	return orig

# ---------------- 劇情：兵營第一次建成 ----------------
static func on_built(sid) -> void:
	if J.str(sid) != ID: return
	var a = st()
	if a == null or J.t(a.get("story")): return
	a["story"] = true
	var Sy = J.G.get("Story")
	if Sy != null: J.mc(Sy, "queue", [story_scene()])
	_save()
# 一段短劇（4 句）：原句港式粵語，中文登記入 LANG_ZH（同 qx.gd _story 一樣，播放器按語言揀、經 DB.N 換女主稱呼）
#   守 mv_story「一個任務只放一段故事」：呢段係「起兵營」嘅回應，播完 mv_story 照樣入「等」狀態（_ext_watch），唔會連播下一幕
const STORY := [
	["小紙", "少爺，兵營搭好喇！啲陰兵排好晒隊，等你訓話。", "少爺，兵營建好了！陰兵都排好隊，等你訓話。"],
	["陰兵", "報告！全營到齊！不過我哋冇腳，所以操步淨係識飄。", "報告！全營到齊！不過我們沒有腳，所以操步只會飄。"],
	["阿福", "冇腳唔緊要，識敬禮就得。", "沒腳沒關係，會敬禮就行。"],
	["陰兵", "收到！（全營敬禮，跌咗三個頭盔）", "收到！（全營敬禮，掉了三個頭盔）"]]
static func story_scene() -> Dictionary:
	var lines = []; var zhm = {}
	for l in STORY:
		lines.append([l[0], l[1]]); zhm[l[1]] = l[2]
	if J.G.get("LANG") != null: J.mc(J.G.get("LANG"), "add", [zhm])
	if DB.D is Dictionary:
		if not DB.D.has("LANG_ZH"): DB.D["LANG_ZH"] = {}
		DB.D.LANG_ZH.merge(zhm, true)
	return {"style": "talk", "bg": "village", "lines": lines}

# ---------------- 行動目標（act_targets） ----------------
static func targets(_game) -> Array:
	if S() == null or not ZD.on(): return []
	if not built() and not unlocked(): return []
	install()
	var p = pos_now()
	return [{"id": ID, "kind": "barracks", "name": T("陰兵兵營", "陰兵兵營"), "pos": Vector2(float(p[0]), float(p[1])),
		"my_pow": power(), "foe_pow": 0, "icon": "", "go": func(): open_panel()}]
static func open_panel() -> void:
	install()
	var ui = J.G.get("UI")
	if ui != null: J.mc(ui, "openBuilding", [ID])

static func _save() -> void:
	var f = J.G.get("save")
	if f != null: J.cl(f, null, [])
