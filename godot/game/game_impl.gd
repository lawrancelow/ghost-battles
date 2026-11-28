# 遊戲核心（移植 game.js 上半）：存檔狀態 S、數值公式 F、經濟、任務、存檔／存檔碼
# 存檔格式同網頁版一樣（同一份 JSON），存檔碼互通：網頁版「備份存檔」嘅碼可以直接導入 Godot 版，反之亦然。
extends Node

signal refreshed
signal banner(text: String)
signal toast(text: String)
signal praise(kind: String)
signal floated(x: float, y: float, text: String, col: String)
signal story_req(scene: Variant, cb: Callable)
signal sound(name: String)

const SAVE_PATH := "user://save.json"
const CE = preload("res://game/outpost/chain_eco.gd")   # [chain]
const CM = preload("res://game/outpost/mat.gd")         # [chain]
var S: Dictionary = {}
var TIME_SCALE = 1.0
var exp_acc = 0.0
var story_busy = func() -> bool: return false   # 由 Story 接管
var modal_open = func() -> bool: return false
var gfx_bad := {}   # 顯示卡測試試到閃退嘅功能（例如 bake = SubViewport 拍照），之後避開
var boot_agents_ok := false   # 開機逐樣顯示完先起村子廣場鬼
var safe_gfx := false   # 安全畫面模式：上次開機喺畫面階段閃退 → 唔用自訂 shader
var last_crash := ""     # 上次閃退停喺邊一步（顯示俾玩家／開發者）
var js_mode := false   # true = 遊戲邏輯由轉譯版 JS 跑，呢度只做轉駁
func jcall(n: String, a: Array = []): return J.cl(J.G.get(n), null, a)
func jm(o: String, m: String, a: Array = []): return J.mc(J.G.get(o), m, a)

func now_ms() -> float: return Time.get_unix_time_from_system() * 1000.0
func D(n: String) -> Variant: return DB.D[n]

static func fmt(n: float) -> String:
	n = floor(n)
	if n >= 1e12: return "%.1fT" % (n / 1e12)   # [polish4] 同大排檔 HUD（MD.fmt）一樣去到 B／T，唔再出 1000.0M
	if n >= 1e9: return "%.1fB" % (n / 1e9)
	if n >= 1e6: return "%.1fM" % (n / 1e6)
	if n >= 1e4: return "%.1fK" % (n / 1e3)
	return str(int(n))

func new_state() -> Dictionary:
	return {
		"v": 1, "lv": 1, "exp": 0,
		"res": {"wood": 0, "rice": 0, "planks": 0, "buns": 0, "coins": 0, "troops": 0},
		"bld": {"house": 1, "wood": 1, "rice": 1, "plank": 0, "bun": 0, "store": 0, "home": 0, "camp": 0, "altar": 0, "furnace": 0},
		"ghosts": [{"id": "afu", "k": "afu", "name": "阿福", "q": "主", "lv": 1, "st": [30, 30, 30], "post": null, "spent": 0}],
		"team": ["afu", null, null], "adviser": null,
		"cleared": {}, "qi": 0, "cnt": {"chop": 0, "rice": 0, "craftPlank": 0, "craftBun": 0, "recruit": 0, "feast": 0, "chest": 0},
		"seen": {}, "chests": {"g": 0, "b": 0, "p": 0}, "furnaceAt": 0, "feastAt": 0, "last": now_ms(), "ended": false,
		"trees": [3, 3, 3, 3, 3, 3, 3, 3], "treeRegrow": [0, 0, 0, 0, 0, 0, 0, 0], "paddy": [1, 1, 1, 1, 1, 1, 1, 1], "paddyRegrow": [0, 0, 0, 0, 0, 0, 0, 0],
		"uid": 1, "prod": {}, "visit": {}, "wmSeen": {}, "qv": 3,
		"hero": {"name": "阿福", "full": "陳大福", "en": "Kelvin", "sex": "m", "set": false},   # 主角名／性別（DB.N 顯示時替換）
	}

# ---------------- 存檔 ----------------
func save() -> void:
	if js_mode: jcall("save"); return
	if S.is_empty(): return
	S.last = now_ms()
	var prev = _read(SAVE_PATH)
	if prev and float(prev.get("lv", 1)) > float(S.get("lv", 1)) + 2: _write(SAVE_PATH + "_hi", prev)
	_write(SAVE_PATH, S)

func _write(p: String, o: Dictionary) -> void:
	var f = FileAccess.open(p, FileAccess.WRITE)
	if f: f.store_string(JSON.stringify(o))

func _read(p: String) -> Variant:
	if not FileAccess.file_exists(p): return null
	var f = FileAccess.open(p, FileAccess.READ)
	if not f: return null
	var o = JSON.parse_string(f.get_as_text())
	return o if o is Dictionary else null

func has_save() -> bool: return FileAccess.file_exists(SAVE_PATH)

# 存檔碼：base64(UTF-8 JSON)，同網頁版 Web.enc / Web.dec 一樣
func enc(o: Dictionary) -> String: return Marshalls.utf8_to_base64(JSON.stringify(o))
func dec(t: String) -> Variant:
	t = t.strip_edges()
	var i = t.find("#save=")
	if i >= 0: t = t.substr(i + 6).uri_decode()
	var s = Marshalls.base64_to_utf8(t)
	var o = JSON.parse_string(s)
	return o if o is Dictionary and o.has("res") else null

func import_code(code: String) -> bool:
	var o = dec(code)
	if o == null: return false
	if not S.is_empty(): _write(SAVE_PATH + "_bak", S)
	o.last = now_ms()
	_write(SAVE_PATH, o)
	S = o; _migrate(false)
	return true

func start(fresh_ok := true) -> bool:
	var o = _read(SAVE_PATH)
	var fresh: bool = o == null
	S = new_state() if fresh else o
	_migrate(fresh)
	return fresh

func reset() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		var o = _read(SAVE_PATH)
		if o: _write(SAVE_PATH + "_del", o)
		DirAccess.remove_absolute(SAVE_PATH)
	S = new_state(); _migrate(true)

func _migrate(fresh: bool) -> void:
	_drop_visit_quests()   # [landmark] [outgate]
	var d = new_state()
	for k in d:
		if not S.has(k): S[k] = d[k]
	if S.get("visit") == null: S.visit = {}
	if S.get("wmSeen") == null: S.wmSeen = {}
	if fresh: S.qv = 4; return   # [onboard] 4：第一章新手重排（game/onboard/ob.gd）；[outgate] 3：冥街夜市、陰陽交界兩個插入任務已拎走（見 native/guide.gd）
	# guide.js：舊存檔（qv<2）喺「出征 1-2」「擊敗餓鬼王 1-3」之後插咗兩個任務，索引要往後挪
	if int(S.get("qv", 1) if S.get("qv") != null else 1) >= 2: return
	var Q: Array = D("QUESTS"); var at = []
	for i in Q.size():
		if Q[i].t == "visit" and Q[i].get("place") == "street": at.append(i)
		if Q[i].t == "visit" and Q[i].get("place") == "yard": at.append(i - 1)
	if at.is_empty(): S.qv = 3; return   # [outgate] 清單已冇插入任務：舊存檔（qv 1）索引唔使郁
	var old = int(S.qi); var add = 0
	for pos in at:
		if old >= pos: add += 1
	S.qi = old + add; S.qv = 2

# [landmark] [outgate] core.json（舊網頁版導出）主線清單仲有「冥街夜市」「陰陽交界」兩個 visit 插入任務，JS 嗰份（J.G.QUESTS，任務進度用佢）已經冇；
#   兩份唔對齊 → 任務條／建築解鎖顯示錯位（1-2 之後顯示「下班後去冥街夜市逛逛」）。呢度拎走，同 JS 對齊（S.qi 本來就係跟 JS 清單，唔使遷移）
func _drop_visit_quests() -> void:
	var Q = DB.D.get("QUESTS")
	if not (Q is Array): return
	for i in range(Q.size() - 1, -1, -1):
		if Q[i] is Dictionary and str(Q[i].get("t", "")) == "visit": Q.remove_at(i)

# ---------------- 數值公式 F ----------------
func expNeed(lv: float) -> int: return int(round(30 * pow(lv, 1.75)))
func ghostCap() -> int:
	var lv: float = S.lv
	return 40 if lv >= 15 else (30 if lv >= 7 else 20)
func glv(g: Dictionary) -> int:
	return mini(ghostCap(), int(S.lv) * 2) if g.k == "afu" else int(g.lv)
func stat(g: Dictionary, i: int) -> int: return int(round(float(g.st[i]) * (1 + 0.06 * (glv(g) - 1))))
func lvCost(lv: float) -> int: return int(floor(6 * pow(lv, 1.5))) + 4
func bldMax(id: String) -> int: return 20 if id == "house" else int(S.bld.house)
func upCost(id: String, lv: float) -> Dictionary:
	var k = 1.1 if id == "house" else 0.9
	var planks: float = round(25 * pow(lv, 1.5) * k); var coins: float = round(28 * pow(lv, 1.55) * k)   # [p56]
	planks = round(planks * (1 - builderDiscount()))
	return {"planks": planks, "coins": coins}
func builderDiscount() -> float:
	var w = workersAt("boss")
	return minf(0.35, glv(w[0]) * 0.012) if w.size() else 0.0
func slots(post: String) -> int:
	var P: Dictionary = D("POSTS")[post]
	if P.bld == null: return 0
	var lv: int = int(S.bld.get(P.bld, 0))
	if lv == 0: return 0
	if post == "boss": return 1
	return mini(4, 1 + int(floor((lv - 1) / 3.0)))
func mult(bid: String) -> float: var d = maxf(0.0, float(S.bld[bid]) - 1); return 1 + 0.45 * d + 0.04 * d * d   # [p56] 同 native/game.gd mult_lv
func cap() -> int:
	var c = 400.0 + (400 * pow(float(S.bld.store), 1.5) if float(S.bld.store) > 0 else 0.0) + (600.0 if S.lv >= 9 else 0.0)
	var m = workersAt("store")
	if m.size(): c *= 1 + stat(m[0], 2) / 100.0
	return int(round(c))
func troopCap() -> float: return 150 + 150 * float(S.bld.home) + 50 * float(S.bld.camp)
func rosterCap() -> int: return 5 + 2 * int(S.bld.home)
func walk() -> float: return 150.0 if S.lv >= 5 else 95.0
func chopTime() -> float: return 0.42 if S.lv >= 2 else 0.7
const furnaceCD := 300.0
const feastCD := 1200.0
func furnaceCoins() -> int: return 30 + 15 * int(S.bld.furnace) + 6 * int(S.lv)
func chestGain(c: String) -> Dictionary:
	if c == "g": return {"buns": 40 + 30 * int(S.bld.bun)}
	if c == "b": return {"planks": 30 + 25 * int(S.bld.plank)}
	return {"coins": 120 + 60 * int(S.bld.house)}
func recruitCost() -> Dictionary: return {"coins": 150, "buns": 40}
const feastNeed := 350

func fodderCount() -> int:
	var n = 0
	for g in S.ghosts:
		if g.q == "藍" or g.q == "紫": n += 1
	return n
func workersAt(post: String) -> Array:
	var o = []
	for g in S.ghosts:
		if g.get("post") == post: o.append(g)
	return o
func ghostById(id) -> Variant:
	for g in S.ghosts:
		if g.id == id: return g
	return null
func gdef(g: Dictionary) -> Dictionary:
	return D("GHOSTS").get(g.k, D("FODDER").get(g.k, {}))

func ratesPerMin() -> Dictionary:
	var r = {"wood": 0.0, "rice": 0.0, "planks": 0.0, "buns": 0.0, "troops": 0.0, "coins": 0.0, "woodUse": 0.0, "riceUse": 0.0, "bunUse": 0.0, "exp": 0.0}
	for g in S.ghosts:
		if g.get("post") == null: continue
		var lv = glv(g)
		match g.post:
			"wood": r.wood += (9 + 0.7 * lv) * mult("wood")
			"rice": r.rice += (9 + 0.7 * lv) * mult("rice")
			"plank":
				var o = (2.5 + stat(g, 0) * 0.05) * mult("plank"); r.planks += o; r.woodUse += o * 2
			"bun":
				var o2 = (2.5 + stat(g, 1) * 0.05) * mult("bun"); r["bao"] = float(r.get("bao", 0.0)) + o2; r.riceUse += o2 * 2; r["baoUse"] = float(r.get("baoUse", 0.0)) + o2 * 2   # [chain] 包子鋪出普通包子 m_bao
			"camp":
				var o3 = (2 + stat(g, 2) * 0.04) * mult("camp"); r.drill = r.get("drill", 0.0) + o3; r.bunUse += o3 * 0.6
				if not r.has("drillBy"): r.drillBy = []
				r.drillBy.append([g.k, o3])
			"store":
				if g.k == "toyol": r.coins += 2 + lv * 0.25
		r.exp += 0.6
	if float(S.bld.home) > 0: r.troops += 1.2 + 1.3 * float(S.bld.home)
	return r

func produce(dt: float) -> void:
	var r = ratesPerMin(); var m = dt / 60.0; var c = float(cap()); var R: Dictionary = S.res
	if R.wood < c: R.wood = minf(c, R.wood + r.wood * m)
	if R.rice < c: R.rice = minf(c, R.rice + r.rice * m)
	if r.planks and R.planks < c:
		var need: float = r.woodUse * m; var k = minf(1, R.wood / need) if need > 0 else 0.0
		R.wood -= need * k; R.planks = minf(c, R.planks + r.planks * m * k)
	if r.buns and R.buns < c:
		var need2: float = (r.riceUse - float(r.get("baoUse", 0.0))) * m; var k2 = minf(1, R.rice / need2) if need2 > 0 else 0.0
		R.rice -= need2 * k2; R.buns = minf(c, R.buns + r.buns * m * k2)
	if r.get("bao", 0.0) and CM.amt("m_bao") < CM.cap("m_bao"):   # [chain]
		var need5: float = r.baoUse * m; var k5 = minf(1, R.rice / need5) if need5 > 0 else 0.0
		R.rice -= need5 * k5; CM.add_capped("m_bao", r.bao * m * k5)
	if r.troops and R.troops < troopCap(): R.troops = minf(troopCap(), R.troops + r.troops * m)
	if r.has("drillBy"):
		var need3: float = r.bunUse * m; var k3 = minf(1, R.buns / need3) if need3 > 0 else 0.0
		R.buns -= need3 * k3
		if not S.has("drill") or S.drill == null: S.drill = {}
		for e in r.drillBy: S.drill[e[0]] = float(S.drill.get(e[0], 0.0)) + e[1] * m * k3
	R.coins += r.coins * m
	CE.produce(dt)   # [chain] 拓展採集／加工建築（崗位鍵 = bid）
	exp_acc += r.exp * m
	if exp_acc >= 1:
		var e = floor(exp_acc); exp_acc -= e; gainExp(e, true)

# ---------------- 資源操作 ----------------
func canPay(c: Dictionary) -> bool:
	for k in c:
		if float(S.res.get(k, 0)) < float(c[k]) - 1e-6: return false
	return true
func pay(c: Dictionary) -> void:
	if js_mode: jcall("pay", [c]); return
	for k in c: S.res[k] = float(S.res[k]) - float(c[k])
func costText(c: Dictionary) -> String:
	var parts = []
	for k in c:
		if not c[k]: continue
		var ok = float(S.res.get(k, 0)) >= float(c[k])
		var t = "%s %s" % [D("RES_NAMES")[k], fmt(c[k])]
		parts.append(t if ok else "[color=#ff8a7a]%s[/color]" % t)
	return "　".join(parts)
func give(r: Dictionary) -> String:
	if js_mode: return JSBridge.html2bb(J.str(jcall("give", [r])))
	var parts = []
	for k in r:
		if k == "exp": gainExp(r.exp); parts.append("好評 +%d" % int(r.exp))
		elif k == "chest": S.chests[r.chest] = int(S.chests[r.chest]) + 1; parts.append({"g": "綠箱", "b": "藍箱", "p": "紫箱"}[r.chest] + " ×1")
		else: S.res[k] = float(S.res.get(k, 0)) + float(r[k]); parts.append("%s +%s" % [D("RES_NAMES")[k], fmt(r[k])])
	return "，".join(parts)
func gainExp(n: float, _silent := false) -> void:
	if js_mode: jcall("gainExp", [n]); return
	S.exp = float(S.exp) + n; var up = false
	while S.lv < 20 and S.exp >= expNeed(S.lv):
		S.exp -= expNeed(S.lv); S.lv = int(S.lv) + 1; up = true; onLevelUp(int(S.lv))
	if S.lv >= 20: S.exp = minf(S.exp, expNeed(20))
	if up: refreshed.emit()
func onLevelUp(lv: int) -> void:
	var u = D("LEVEL_UNLOCKS").get(str(lv))
	sound.emit("levelUp")
	banner.emit("升級！Lv %d" % lv + ("　解鎖【%s】" % u.name if u else ""))
	if u:
		var lines: Array = u.lines.duplicate(); lines.append(["旁白", "解鎖：" + u.desc])
		story_req.emit({"style": "sys", "lines": lines}, Callable())
	if lv == 4 and not S.seen.get("gift_xiaozhi", false):
		story_req.emit("gift_xiaozhi", Callable())
		story_req.emit("gift_xiaozhi2", func(): joinGhost("xiaozhi"))
func joinGhost(k: String) -> void:
	if js_mode: jcall("joinGhost", [k]); return
	for g in S.ghosts:
		if g.k == k: return
	var d: Dictionary = D("GHOSTS")[k]
	var g = {"id": "g%d" % int(S.uid), "k": k, "name": d.name, "q": "名", "lv": maxi(1, mini(ghostCap(), int(floor(S.lv * 1.3)))), "st": d.base.duplicate(), "post": null, "spent": 0}
	S.uid = int(S.uid) + 1
	S.ghosts.append(g)
	var i: int = S.team.find(null)
	if i >= 0: S.team[i] = g.id
	sound.emit("gong"); banner.emit("【%s】加入了落魄村！" % d.name)
	refreshed.emit()

func recruitFodder(rare: bool) -> Dictionary:
	if js_mode: return jcall("recruitFodder", [rare])
	var F_: Dictionary = D("FODDER"); var pool = []
	for k in F_:
		if F_[k].get("unlock") == null or S.cleared.get(F_[k].unlock, false): pool.append(k)
	var k: String = pool[randi() % pool.size()]
	var purple = rare or randf() < 0.15; var m = 1.45 if purple else 1.0
	var st = [0, 0, 0].map(func(_x): return int(round((15 + randf() * 32) * m)))
	var used = {}
	for g in S.ghosts: used[g.name] = 1
	var nm = ""; var nicks: Array = D("NICKS")
	for i in 40:
		nm = F_[k].name + "・" + nicks[randi() % nicks.size()]
		if not used.has(nm): break
	var g = {"id": "g%d" % int(S.uid), "k": k, "name": nm, "q": "紫" if purple else "藍", "lv": 1, "st": st, "post": null, "spent": 0}
	S.uid = int(S.uid) + 1
	S.ghosts.append(g); return g

func bldUnlocked(id: String) -> bool:
	var b: Dictionary = D("BUILDINGS")[id]
	if b.get("unlockLv") and S.lv < b.unlockLv: return false
	if b.get("unlockStage") and not S.cleared.get(b.unlockStage, false): return false
	if b.get("unlockQuest"):
		_drop_visit_quests()   # [landmark] [outgate]
		var Q: Array = D("QUESTS")
		for i in Q.size():
			if Q[i].t == "build" and Q[i].get("b") == id:
				if i > S.qi: return false
				break
	return true
func furnaceReady() -> bool:
	return float(S.bld.furnace) > 0 and load("res://game/joss/joss.gd").count() > 0   # [joss] 有陽間包裹等收

# ---------------- 任務 ----------------
func quest_cur() -> Variant:
	_drop_visit_quests()   # [landmark] [outgate] 開機路徑唔一定經 _migrate：用之前對齊一次（冇 visit 就即刻返）
	var rq = load("res://game/rebuild/rb.gd").cur_q()   # [rebuild] 荒村重建虛擬任務
	if rq != null: return rq
	var Q: Array = D("QUESTS")
	return Q[int(S.qi)] if int(S.qi) < Q.size() else null
func quest_progress(q: Dictionary) -> Array:
	if q.get("rb"): return load("res://game/rebuild/rb.gd").progress(q)   # [rebuild]
	match q.t:
		"chop": return [S.cnt.chop, q.n]
		"rice": return [S.cnt.rice, q.n]
		"craftPlank": return [S.cnt.craftPlank, q.n]
		"craftBun": return [S.cnt.craftBun, q.n]
		"level": return [S.lv, q.n]
		"build": return [1 if float(S.bld.get(q.b, 0)) > 0 else 0, 1]
		"bLevel": return [S.bld[q.b], q.n]
		"assign":
			var n = 0
			for g in S.ghosts:
				if g.get("post") != null: n += 1
			return [n, q.n]
		"stage": return [1 if S.cleared.get(q.s, false) else 0, 1]
		"recruit": return [S.cnt.recruit, q.n]
		"ghostLv":
			var m = 0
			for g in S.ghosts:
				if g.k != "afu": m = maxi(m, int(g.lv))
			return [m, q.n]
		"troops": return [floor(S.res.troops), q.n]
		"drill":
			var mx = 0.0
			for v in (S.get("drill", {}) if S.get("drill") != null else {}).values(): mx = maxf(mx, v)
			return [floor(minf(mx, q.n)), q.n]
		"feast": return [S.cnt.feast, q.n]
		"visit": return [1 if S.get("visit", {}).get(q.place, false) else 0, 1]
	var obp = load("res://game/onboard/ob.gd").progress(q)   # [onboard] 大排檔賣貨／第一次守夜
	if obp.size() == 2: return obp
	return [0, 1]
func quest_done(q: Dictionary) -> bool:
	var p = quest_progress(q); return float(p[0]) >= float(p[1])
func quest_check() -> void:
	if js_mode: jm("Quest", "check"); return
	var q = quest_cur()
	if q == null: return
	if quest_done(q) and not story_busy.call(): quest_complete()
	if S.seen.get("ch2_end", false) and float(S.bld.house) >= 4 and not S.seen.get("side_tianhua", false) and not story_busy.call():
		story_req.emit("side_tianhua", func(): joinGhost("tianhua"))
func quest_complete() -> void:
	var q: Dictionary = quest_cur(); S.qi = int(S.qi) + 1
	var txt = give(q.r); sound.emit("coin")
	toast.emit("任務完成：%s\n[b]%s[/b]" % [q.text, txt] + ("\n" + q.note if q.get("note") else ""))
	var nq = quest_cur()
	if nq and nq.get("onStart"):
		for id in nq.onStart:
			if not S.seen.get(id, false): story_req.emit(id, Callable())
	save(); refreshed.emit()

# ---------------- 離線收益 ----------------
func offline_gain() -> void:
	if js_mode: jcall("offlineGain"); return
	var sec = minf(8 * 3600, maxf(0, (now_ms() - float(S.get("last", now_ms()))) / 1000.0))
	if sec < 60: return
	var before: Dictionary = S.res.duplicate()
	var s = 0.0
	while s < sec:
		produce(minf(60, sec - s)); s += 60
	var parts = []
	for k in ["wood", "rice", "planks", "buns", "troops", "coins"]:
		var d = floor(float(S.res[k]) - float(before[k]))
		if d > 0: parts.append("%s +%s" % [D("RES_NAMES")[k], fmt(d)])
	S.last = now_ms()
	if parts.size():
		story_req.emit({"style": "sys", "lines": [["系統", "親，你離開了 %d 小時 %d 分鐘。鬼怪們沒有偷懶哦～（最多計 8 小時）" % [int(sec / 3600), int(fmod(sec, 3600) / 60)]], ["旁白", "離線收益：" + "，".join(parts)]]}, Callable())


# ---------------- 開機麵包屑（閃退診斷） ----------------
const CRUMB := "user://boot_crumb.txt"
func crumb(stage: String) -> void:
	var f = FileAccess.open(CRUMB, FileAccess.WRITE)
	if f: f.store_string(stage + "\n" + str(Time.get_unix_time_from_system())); f.flush(); f.close()
func crumb_now() -> String:
	return FileAccess.get_file_as_string(CRUMB).split("\n")[0] if FileAccess.file_exists(CRUMB) else ""
func read_crumb() -> void:
	if OS.has_environment("GB_TEST") and not OS.has_environment("GB_CRUMB_TEST"):   # 測試會中途 quit，唔當閃退
		safe_gfx = OS.has_environment("GB_SAFE_GFX"); return
	var f = FileAccess.open(CRUMB, FileAccess.READ)
	var safe_f = FileAccess.file_exists("user://safe_gfx")
	if safe_f:
		var sv = FileAccess.get_file_as_string("user://safe_gfx").strip_edges()
		if sv != "manual" and sv != "auto:" + str(ProjectSettings.get_setting("application/config/version", "")):
			DirAccess.remove_absolute("user://safe_gfx"); safe_f = false   # 新版本：自動開嘅安全模式重新試過
	if f:
		var st = f.get_line(); f.close()
		if st.begins_with("bake:"):
			# 烘圖（SubViewport 讀返 GPU）途中閃退：以後呢部機唔烘圖（照重播），唔使彈救命畫面
			var bb = FileAccess.get_file_as_string("user://gfx_bad.txt") if FileAccess.file_exists("user://gfx_bad.txt") else ""
			bb += "bake;"; var wbb = FileAccess.open("user://gfx_bad.txt", FileAccess.WRITE); wbb.store_string(bb); wbb.close()
			st = ""
		if st.begins_with("probe:"):
			# 顯示卡測試閃退：記低，下次避開，唔使彈救命畫面
			var bad = FileAccess.get_file_as_string("user://gfx_bad.txt") if FileAccess.file_exists("user://gfx_bad.txt") else ""
			bad += st.substr(6) + ";"; var wb = FileAccess.open("user://gfx_bad.txt", FileAccess.WRITE); wb.store_string(bad); wb.close()
			st = ""
		if FileAccess.file_exists("user://gfx_bad.txt"):
			for b in FileAccess.get_file_as_string("user://gfx_bad.txt").split(";", false): gfx_bad[b] = true
		if st != "" and st != "ok" and st != "bg":
			last_crash = st
			# 畫面相關步驟閃退 → 自動開安全畫面模式
			if st in ["ui", "village", "start", "state", "resize", "refresh", "frame1", "frame30", "snd", "title"] or st.begins_with("show:") or st.begins_with("ng:") or st.begins_with("draw:"):
				var w = FileAccess.open("user://safe_gfx", FileAccess.WRITE); if w: w.store_string("auto:" + str(ProjectSettings.get_setting("application/config/version", ""))); w.close()
				safe_f = true
	safe_gfx = safe_f or OS.has_environment("GB_SAFE_GFX")
# 骨架角色（CPU 蒙皮）用唔用得：安全畫面模式或者開機暗測閃退過就唔用，改畫整張原圖
func skin_ok() -> bool: return not safe_gfx and not gfx_bad.has("cpuskin2")
# 衣服換色層（CpuSkin mode 1）：開機暗測 cpuskin_cloth 閃退過就唔畫衣服層
func cloth_ok() -> bool: return skin_ok() and not gfx_bad.has("cpuskin_cloth")
func set_safe_gfx(on: bool) -> void:
	safe_gfx = on
	if on:
		var w = FileAccess.open("user://safe_gfx", FileAccess.WRITE); if w: w.store_string("manual"); w.close()
	else: DirAccess.remove_absolute("user://safe_gfx")
