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
var S: Dictionary = {}
var TIME_SCALE = 1.0
var exp_acc = 0.0
var story_busy = func() -> bool: return false   # 由 Story 接管
var modal_open = func() -> bool: return false
var js_mode := false   # true = 遊戲邏輯由轉譯版 JS 跑，呢度只做轉駁
func jcall(n: String, a: Array = []): return J.cl(J.G.get(n), null, a)
func jm(o: String, m: String, a: Array = []): return J.mc(J.G.get(o), m, a)

func now_ms() -> float: return Time.get_unix_time_from_system() * 1000.0
func D(n: String) -> Variant: return DB.D[n]

static func fmt(n: float) -> String:
	n = floor(n)
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
		"trees": [3, 3, 3, 3, 3, 3, 3, 3], "treeRegrow": [0, 0, 0, 0, 0, 0, 0, 0], "paddy": [1, 1, 1, 1, 1, 1], "paddyRegrow": [0, 0, 0, 0, 0, 0],
		"uid": 1, "prod": {}, "visit": {}, "wmSeen": {}, "qv": 2,
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
	var d = new_state()
	for k in d:
		if not S.has(k): S[k] = d[k]
	if S.get("visit") == null: S.visit = {}
	if S.get("wmSeen") == null: S.wmSeen = {}
	if fresh: S.qv = 2; return
	# guide.js：舊存檔（qv<2）喺「出征 1-2」「擊敗餓鬼王 1-3」之後插咗兩個任務，索引要往後挪
	if int(S.get("qv", 1) if S.get("qv") != null else 1) >= 2: return
	var Q: Array = D("QUESTS"); var at = []
	for i in Q.size():
		if Q[i].t == "visit" and Q[i].get("place") == "street": at.append(i)
		if Q[i].t == "visit" and Q[i].get("place") == "yard": at.append(i - 1)
	var old = int(S.qi); var add = 0
	for pos in at:
		if old >= pos: add += 1
	S.qi = old + add; S.qv = 2

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
	var planks: float = round(25 * pow(lv, 1.72) * k); var coins: float = round(28 * pow(lv, 1.8) * k)
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
func mult(bid: String) -> float: return 1 + 0.3 * (float(S.bld[bid]) - 1)
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
				var o2 = (2.5 + stat(g, 1) * 0.05) * mult("bun"); r.buns += o2; r.riceUse += o2 * 2
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
		var need2: float = r.riceUse * m; var k2 = minf(1, R.rice / need2) if need2 > 0 else 0.0
		R.rice -= need2 * k2; R.buns = minf(c, R.buns + r.buns * m * k2)
	if r.troops and R.troops < troopCap(): R.troops = minf(troopCap(), R.troops + r.troops * m)
	if r.has("drillBy"):
		var need3: float = r.bunUse * m; var k3 = minf(1, R.buns / need3) if need3 > 0 else 0.0
		R.buns -= need3 * k3
		if not S.has("drill") or S.drill == null: S.drill = {}
		for e in r.drillBy: S.drill[e[0]] = float(S.drill.get(e[0], 0.0)) + e[1] * m * k3
	R.coins += r.coins * m
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
		var Q: Array = D("QUESTS")
		for i in Q.size():
			if Q[i].t == "build" and Q[i].get("b") == id:
				if i > S.qi: return false
				break
	return true
func furnaceReady() -> bool:
	return float(S.bld.furnace) > 0 and now_ms() - float(S.furnaceAt) >= furnaceCD * 1000 / TIME_SCALE

# ---------------- 任務 ----------------
func quest_cur() -> Variant:
	var Q: Array = D("QUESTS")
	return Q[int(S.qi)] if int(S.qi) < Q.size() else null
func quest_progress(q: Dictionary) -> Array:
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
