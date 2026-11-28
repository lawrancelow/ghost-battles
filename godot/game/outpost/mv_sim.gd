# 移動村：狀態（S.mv）＋即時模擬（員工做貨→搬貨→櫃台→客人收齊付錢；圍欄孤魂；目標；拔營；離線）
# 冇畫嘢：畫面（mv_scene.gd）每格叫 step(dt)，再讀 workers／custs／foes／guards 畫；特效靠 ev（事件）通知畫面。
# headless 測試可以直接 new 一個嚟跑（唔使開場景）。
extends RefCounted

const MD = preload("res://game/outpost/mv_data.gd")
const M = preload("res://game/outpost/mat.gd")   # [chain] 材料庫
const MK = preload("res://game/market/mk_data.gd")   # [market] 過勞鬼市集：街道＋過勞營業
const MKO = preload("res://game/market/mk_ops.gd")   # [market M1 營運] 店員位、雙貨、櫃檯、巡邏、事件
# [chain] 生產鏈：台做貨要按 chain.json RECIPES 由材料庫扣 in；冇料就停（斷料），有料自動復工。
#   每轉（一次做 out(lv) 件）食 in × out(lv) ÷ RECIPES.n（即係 n 件要一份 in；升級多出嘅件數照比例食料）。
#   開工嗰下先扣料（扣唔到就企喺台前等，顯示「斷料：缺 XX」）；鬼中途被調走，未做完嗰轉退返料。
# [chain] 分流規則（每台可以喺資料卡揀：自動／全部入倉／全部出售；記喺 S.mv.route[sid]，跨地圖保留）：
#   自動：① 上層要料優先——呢張圖有已解鎖嘅台用緊呢樣貨做原料，而材料庫存量 < 需求線
#           （Σ 用料台每轉用量 × 員工數(最少 1) × BUF_CYCLES 轉，最少 BUF_MIN）→ 成轉入倉；
#         ② 壽包（m_shoubao，前線命脈）→ 每台輪流：一件擺櫃台、一件入倉（[sell] 唔再向上取整，一轉 1 件都係一半）；
#   [sell] 以上規則之前先做「客人優先」：排緊隊客人仲差嘅件數先擺櫃台（全部入倉除外，會提示改出售）。
#         ③ 戰鬥道具（BATTLE_ITEMS）→ 庫存未夠 ITEM_KEEP 件就入倉，夠咗擺櫃台；
#         ④ 其他（包括裝備 GEAR，要賣畀鬼佢先會做義勇軍）→ 擺櫃台出售。
#   櫃台嗰樣貨滿咗（COUNTER_CAP）而呢樣貨入得倉（有人用／壽包／道具）→ 改入倉，唔使員工企喺度等。
#   入倉嘅貨即刻入庫（唔使搬去櫃台），員工即刻做下一轉；出售嘅照搬去櫃台。倉滿就全部擺櫃台。
const BUF_CYCLES := 4.0
const BUF_MIN := 5.0
const ITEM_KEEP := 10.0
const ROUTES := ["auto", "stock", "sell"]
const MVW = preload("res://game/outpost/mv_war.gd")   # [war]
const IDL = preload("res://game/outpost/mv_idle.gd")   # [idle] Idle Outpost 式升級（解鎖鏈／累計產量門檻／品質星／領班）
const MVP = preload("res://game/outpost/mv_plus.gd")   # [play] 鬼客脾氣／委託單／詭異事件／羈絆／夜潮／招牌菜
const ML = preload("res://game/militia/ml_data.gd")   # [militia] 客人只要有供應嘅貨、高級客循序漸進、遊魂兵
const FW := 390.0
const ZDm = preload("res://game/zone/zone_data.gd")   # [zone]
const WALK := 120.0
const FOE_MAX := 5
const PATIENCE := 15.0     # 客人喺櫃台前等幾多秒冇貨就走
const MOVABLE_POSTS := ["mv", "garrison", "wood", "rice", "plank", "bun", "store", "boss", "camp", "station"]

var rng := RandomNumberGenerator.new()
var L := {}                 # 版面（relayout 計）
var workers: Array = []     # {gid,k,sid,slot,st,prog,pos,home,carry,t}
var custs: Array = []       # {cid,k,wants,got,st,pos,slot,t,ph,take}
var foes: Array = []        # {k,pos,hp,mx,st,t,tgt,ph}
var guards: Array = []      # {gid,k,pos,slot,cd,tgt,atk}
var mk := {}                # 手動做貨進度：sid → 0..1（-1＝冇做）
var ev: Array = []          # 事件（畫面攞嚟出特效）
var spawn_t := 1.0
var foe_t := 2.0
var paused := false
var _sync_key := ""
var war = MVW.new()   # [war] 義勇軍／鬼潮／影響力（邏輯全部喺 mv_war.gd）
var idle := {}   # [idle] 即時狀態（領班自動撳台計時）
var plus = MVP.new()   # [play]

func _init() -> void:
	rng.seed = 20261119
	relayout(102.0, 844.0 - 58.0)

# ================= 狀態 =================
func SS():
	var s = J.G.get("S")
	return s if s is Dictionary else null
func now() -> float: return J.now()

func st():
	var s = SS()
	if s == null: return null
	if not (s.get("mv") is Dictionary):
		s["mv"] = {"v": 1.0, "ci": 0.0, "st": {}, "goals_done": [], "sold": {}, "done": {}, "guards": [], "last": now(),
			"boost": {"inc_end": 0.0, "inc_cd": 0.0, "spd_end": 0.0, "spd_cd": 0.0}, "pile": {}, "counter": {}, "earned": 0.0, "served": 0.0}
	var m = s.mv
	for k in ["st", "sold", "done", "boost", "pile", "counter", "route", "made", "carry_st"]: if not (m.get(k) is Dictionary): m[k] = {}   # [chain] route/made/carry_st
	for k in ["goals_done", "guards"]: if not (m.get(k) is Array): m[k] = []
	while m.guards.size() < MD.GUARD_SLOTS: m.guards.append(null)
	if m.get("last") == null: m["last"] = now()
	IDL.migrate(m)   # [idle] 舊存檔：補 made_n／領班位
	var c = ci_of(m)
	for sid in MD.stations(c):
		if not (m.st.get(sid) is Dictionary):
			m.st[sid] = {"lv": 1.0, "unlocked": float(MD.st_def(sid).get("unlock_cost", 0)) <= 0.0, "workers": [], "made_n": 0.0, "fore": [null]}   # [idle] made_n／fore
			var cs = m.carry_st.get(sid)   # [chain] 隨村台：跟大屋抬過嚟，等級／解鎖照舊
			if MD.is_carry(sid) and cs is Dictionary:
				m.st[sid].lv = maxf(1.0, J.num(cs.get("lv", 1))); m.st[sid].unlocked = J.t(cs.get("unlocked")) or J.t(m.st[sid].unlocked)
				m.st[sid].made_n = J.num(cs.get("made_n"))   # [idle] 累計產量跟大屋走
		var e = m.st[sid]
		if not (e.get("workers") is Array): e["workers"] = []
		if not (e.get("fore") is Array) or e.fore.is_empty(): e["fore"] = [null]   # [idle]
		while e.workers.size() < MD.slots(sid): e.workers.append(null)
	return m
func ci_of(m) -> int: return clampi(int(J.num(m.get("ci"))), 0, maxi(0, MD.maps_n() - 1))
func ci() -> int:
	var m = st()
	return ci_of(m) if m != null else 0
const _NO_ST := {"lv": 0.0, "unlocked": false, "workers": []}
func sst(sid: String) -> Dictionary:   # 唔存在嘅 sid：回一個空殼（唔報錯）
	var m = st()
	if m == null: return _NO_ST.duplicate(true)
	var e = m.st.get(sid)
	return e if e is Dictionary else _NO_ST.duplicate(true)
func lv(sid: String) -> float: return J.num(sst(sid).lv)
func unlocked(sid: String) -> bool: return J.t(sst(sid).unlocked)
func coins() -> float: return J.num(SS().res.get("coins"))
func add_coins(v: float) -> void: SS().res["coins"] = coins() + v
func nworkers(sid: String) -> int:
	var n = 0
	for g in sst(sid).workers: if g != null: n += 1
	return n

func inc_on() -> bool: return now() < J.num(st().boost.get("inc_end"))
func spd_on() -> bool: return now() < J.num(st().boost.get("spd_end"))
func inc_mul() -> float: return 2.0 if inc_on() else 1.0
func spd_mul() -> float: return 2.0 if spd_on() else 1.0
func boost_left(kind: String) -> float: return maxf(0.0, (J.num(st().boost.get(kind + "_end")) - now()) / 1000.0)
func boost_cd(kind: String) -> float: return maxf(0.0, (J.num(st().boost.get(kind + "_cd")) - now()) / 1000.0)
func use_boost(kind: String) -> bool:
	if boost_cd(kind) > 0.0: return false
	var B = MD.BOOST_INC if kind == "inc" else MD.BOOST_SPD
	st().boost[kind + "_end"] = now() + B.dur * 1000.0
	st().boost[kind + "_cd"] = now() + B.cd * 1000.0
	ev.append({"k": "boost", "kind": kind})
	return true

# ================= 鬼（同村子崗位、站崗、巡陰、分村互斥：gh.post = "mv"） =================
func ghost(id):
	var s = SS()
	if s == null or id == null: return null
	for gh in J.iter(s.get("ghosts")): if J.seq(J.gp(gh, "id"), id): return gh
	return null
func glv(gh) -> float:
	var F = J.G.get("F")
	return J.num(J.mc(F, "glv", [gh])) if F != null else J.num(J.gp(gh, "lv"))
func reg_post() -> void:
	var PO = J.G.get("POSTS")
	if PO is Dictionary and not PO.has("mv"):
		PO["mv"] = {"name": "移動村開工", "bld": null, "stat": 0.0, "desc": "喺出殯巡遊・過勞鬼市集做貨／守圍欄"}
# 存檔一致：格入面嘅鬼要 post == "mv"；post == "mv" 但冇格嘅鬼放返自由
func validate() -> void:
	var m = st(); if m == null: return
	var seen = {}
	var lists = []
	for sid in m.st: lists.append(m.st[sid].workers)
	for sid in m.st: if m.st[sid].get("fore") is Array: lists.append(m.st[sid].fore)   # [idle] 領班
	lists.append(m.guards)
	for p in lists:
		for i in p.size():
			var gid = p[i]
			if gid == null: continue
			var gh = ghost(gid); var key = J.str(gid)
			if gh == null or not J.seq(J.gp(gh, "post"), "mv") or seen.has(key): p[i] = null; continue
			seen[key] = true
	for gh in J.iter(SS().get("ghosts")):
		if J.seq(J.gp(gh, "post"), "mv") and not seen.has(J.str(J.gp(gh, "id"))): J.sp(gh, "post", null)

func pick_list() -> Array:
	var out = []; var t0 = now()
	for gh in J.iter(SS().get("ghosts")):
		if J.seq(J.gp(gh, "k"), "afu") or J.num(J.gp(gh, "tiredUntil")) > t0: continue
		var p = J.gp(gh, "post")
		if J.t(p) and not (J.str(p) in MOVABLE_POSTS): continue    # 樓裡有鬼出更等：唔郁
		out.append(gh)
	out.sort_custom(func(a, b):
		var fa = 0 if not J.t(J.gp(a, "post")) else (1 if not J.seq(J.gp(a, "post"), "mv") else 2)
		var fb = 0 if not J.t(J.gp(b, "post")) else (1 if not J.seq(J.gp(b, "post"), "mv") else 2)
		if fa != fb: return fa < fb
		return glv(a) > glv(b))
	return out

func _release(gid) -> void:   # 由其他崗位調走
	var gh = ghost(gid); if gh == null: return
	var p = J.str(J.gp(gh, "post"))
	if p == "garrison":
		var GR = Engine.get_main_loop().root.get_node_or_null("Garrison") if Engine.get_main_loop() != null else null
		if GR != null and GR.st() != null:
			for c2 in GR.maps_n():
				var m2 = GR.ms(c2)
				for s2 in m2.posts:
					var p2 = m2.posts[s2]
					for i in p2.size(): if J.seq(p2[i], gid): p2[i] = null
	var m = st()
	for sid in m.st:
		var w = m.st[sid].workers
		for i in w.size(): if J.seq(w[i], gid): w[i] = null
		var fa = m.st[sid].get("fore")   # [idle]
		if fa is Array: for i in fa.size(): if J.seq(fa[i], gid): fa[i] = null
	for i in m.guards.size(): if J.seq(m.guards[i], gid): m.guards[i] = null
	J.sp(gh, "post", null)

# list: "guard" 或者 sid
func assign(list: String, slot: int, gid) -> bool:
	var m = st()
	var arr: Array = m.guards if list == "guard" else (sst(list).workers if m.st.has(list) else [])
	var lsid = list   # [idle] "fore:<sid>" = 領班位
	if list.begins_with("fore:"): lsid = list.substr(5); arr = IDL.fore_arr(self, lsid)
	if slot < 0 or slot >= arr.size(): return false
	if list != "guard" and not unlocked(lsid): return false
	if gid != null:
		var gh = ghost(gid)
		if gh == null or J.seq(J.gp(gh, "k"), "afu"): return false
		var p = J.gp(gh, "post")
		if J.t(p) and not (J.str(p) in MOVABLE_POSTS): return false
	var old = arr[slot]
	if old != null:
		var og = ghost(old)
		if og != null and J.seq(J.gp(og, "post"), "mv"): J.sp(og, "post", null)
		arr[slot] = null
	if gid != null:
		_release(gid)
		J.sp(ghost(gid), "post", "mv"); arr[slot] = J.gp(ghost(gid), "id")
	_sync_key = ""
	return true

# ================= 升級／解鎖 =================
func unlock(sid: String) -> bool:
	if unlocked(sid): return false
	if not IDL.unlock_req(self, sid)[0]: return false   # [idle] 解鎖鏈：上一個台要到 Lv10
	var c = float(MD.st_def(sid).get("unlock_cost", 0))
	if coins() < c: return false
	add_coins(-c); sst(sid).unlocked = true; _sync_key = ""
	ev.append({"k": "unlock", "sid": sid})
	return true
func up_n_for(sid: String, mode: String) -> int:   # mode: "1"／"10"／"mile"
	var l = lv(sid); var mx = MD.max_lv(sid)
	var n = 1
	if mode == "10": n = 10
	elif mode == "mile":
		var nm = MD.next_mile(sid, l); n = (nm - int(l)) if nm > 0 else 1
	return clampi(n, 0, mini(mx, IDL.cap_lv(self, sid)) - int(l))   # [idle] 累計產量未夠：升到里程碑前一級為止
func upgrade(sid: String, n: int) -> int:
	if not unlocked(sid) or n <= 0: return 0
	var l0 = lv(sid); n = mini(n, mini(MD.max_lv(sid), IDL.cap_lv(self, sid)) - int(l0))   # [idle] 門檻
	if n <= 0: return 0
	var c = MD.cost_n(sid, l0, n)
	if coins() < c: return 0
	add_coins(-c); sst(sid).lv = l0 + n
	var nm0 = MD.nm(sid, l0); var nm1 = MD.nm(sid, l0 + n)
	ev.append({"k": "up", "sid": sid, "from": l0, "to": l0 + n})
	if nm1 > nm0: ev.append({"k": "mile", "sid": sid, "x": pow(2.0, nm1 - nm0), "lv": l0 + n, "stars": nm1,   # [idle] 速度／售價 ×2＋品質星
		"spd": MD.ns(sid, l0 + n) - MD.ns(sid, l0), "val": MD.nv(sid, l0 + n) - MD.nv(sid, l0)})
	return n

# ================= 目標 =================
func boss_ok(c: int, k := "") -> bool:
	var cl = SS().get("cleared")
	if not (cl is Dictionary): return false
	if k != "" and k.contains("-") and J.t(cl.get(k)): return true
	var r = J.t(cl.get("%d-3" % (c + 1)))
	if k == "" and ZDm.on_for(c): return r and ZDm.all_bosses_done(c)   # [zone] 分區地圖：全部野外王打低先算（拔營、all_done）
	return r
func goal_prog(i: int) -> Array:   # [而家, 要幾多]
	var c = ci(); var G = MD.goals(c)
	if i < 0 or i >= G.size(): return [0, 1]
	var g = G[i]; var k = str(g.get("k", "")); var n = float(g.get("n", 1)); var cur = 0.0
	match str(g.get("t")):
		"unlock": cur = 1.0 if st().st.has(k) and unlocked(k) else 0.0; n = 1.0
		"level": cur = lv(k) if st().st.has(k) else 0.0
		"sell": cur = J.num(st().sold.get(k))
		"hire":
			if st().st.has(k): cur = nworkers(k)
			else:
				for sid in st().st: cur += nworkers(sid)
		"boss": cur = 1.0 if boss_ok(c, k) else 0.0; n = 1.0
	return [minf(cur, n), n]
func goal_done(i: int) -> bool:
	var p = goal_prog(i); return p[0] >= p[1]
func goal_claimed(i: int) -> bool:
	for x in st().goals_done: if int(J.num(x)) == i: return true
	if MK.goal_skip(ci(), MD.goals(ci())[i] if i >= 0 and i < MD.goals(ci()).size() else {}): return true   # [market] 改成系統／原料／移去別章嘅台：目標當跳過（唔畀獎）
	return false
func cur_goal() -> int:
	var G = MD.goals(ci())
	for i in G.size(): if not goal_claimed(i): return i
	return -1
func claim(i: int) -> bool:
	if i < 0 or goal_claimed(i) or not goal_done(i): return false
	st().goals_done.append(float(i))
	var r = MD.goals(ci())[i].get("reward", {})
	var cc = float(r.get("coins", 0)) if r is Dictionary else 0.0
	if cc > 0.0: add_coins(cc)
	ev.append({"k": "claim", "i": i, "coins": cc})
	return true
func goals_claimed_n() -> int: return st().goals_done.size()
func can_move() -> bool:
	var c = ci()
	if c + 1 >= MD.maps_n(): return false
	for i in MD.goals(c).size(): if not goal_claimed(i): return false
	return boss_ok(c)

# 拔營：記低呢張圖嘅台等級（俾分村用），放返所有鬼，下一張圖由零開始
func move_next() -> bool:
	if not can_move(): return false
	var m = st(); var c = ci()
	var rec = {}
	for sid in m.st: if J.t(m.st[sid].unlocked): rec[sid] = J.num(m.st[sid].lv)
	m.done[str(c)] = rec
	for sid in m.st:   # [chain] 隨村台跟住走
		if MD.is_carry(sid): m.carry_st[sid] = {"lv": J.num(m.st[sid].lv), "unlocked": J.t(m.st[sid].unlocked), "made_n": J.num(m.st[sid].get("made_n"))}   # [idle] made_n
	for sid in m.st:
		for gid in m.st[sid].workers + (m.st[sid].get("fore") if m.st[sid].get("fore") is Array else []):   # [idle] 領班一齊放
			if gid != null and ghost(gid) != null and J.seq(J.gp(ghost(gid), "post"), "mv"): J.sp(ghost(gid), "post", null)
	for gid in m.guards:
		if gid != null and ghost(gid) != null and J.seq(J.gp(ghost(gid), "post"), "mv"): J.sp(ghost(gid), "post", null)
	war.on_move(self, c)   # [war]
	plus.on_move(self, c)   # [play]
	m.ci = float(c + 1); m.st = {}; m.goals_done = []; m.sold = {}; m.pile = {}; m.counter = {}; m.guards = []
	reset_live(); st()
	ev.append({"k": "moved", "from": c, "to": c + 1})
	return true

func reset_live() -> void:
	for w in workers: if w.get("paid") is Dictionary: M.give(w.paid)   # [chain] 退返做到一半嗰轉
	for sid in mk: if float(mk[sid]) >= 0.0: M.give(need(sid))
	workers.clear(); custs.clear(); foes.clear(); guards.clear(); mk.clear(); mk_starve.clear(); _sync_key = ""
	spawn_t = 0.6; foe_t = 1.5
	war.reset_live()   # [war]
	plus.reset_live()   # [play]

# ================= [chain] 生產鏈：用料、斷料、分流 =================
func need(sid: String, n := -1.0) -> Dictionary:   # 做 n 件（預設一轉 = out(lv)）要幾多料
	var ri = M.rin(sid)
	if ri.is_empty(): return {}
	if n < 0.0: n = float(MD.out(sid, lv(sid)))
	var k = n / M.rn(sid); var o = {}
	for mid in ri: o[str(mid)] = J.num(ri[mid]) * k
	return o
func missing(sid: String) -> Array:   # 而家缺邊啲料（一轉計）
	var o = []
	var nd = need(sid)
	for mid in nd: if M.amt(mid) < nd[mid] - 1e-6: o.append(mid)
	return o
func starving(sid: String) -> bool:   # 有人做（或者手做緊）但冇料
	for w in workers: if w.sid == sid and J.t(w.get("starve")): return true
	return J.t(mk_starve.get(sid)) and missing(sid).size() > 0
var mk_starve := {}
func route(sid: String) -> String:
	var r = str(st().route.get(sid, "auto"))
	return r if r in ROUTES else "auto"
func set_route(sid: String, r: String) -> void:
	if r in ROUTES: st().route[sid] = r
func next_route(sid: String) -> String:
	var r = ROUTES[(ROUTES.find(route(sid)) + 1) % ROUTES.size()]
	set_route(sid, r); return r
# 呢張圖用 mid 做原料嘅已解鎖台
func consumers(mid: String, except := "") -> Array:
	var o = []
	for sid in M.st_users(mid):
		if sid != except and st().st.has(sid) and unlocked(sid): o.append(sid)
	return o
func buffer_of(mid: String, except := "") -> float:   # 需求線
	var b = 0.0
	for sid in consumers(mid, except):
		b += J.num(need(sid).get(mid)) * maxf(1.0, nworkers(sid)) * BUF_CYCLES
	return maxf(BUF_MIN, b) if b > 0.0 else 0.0
func storeable(mid: String) -> bool:
	return mid != "" and (M.users(mid).size() > 0 or mid == "m_shoubao" or M.is_item(mid))
# [sell] 客人優先：排緊隊嘅客人對 gid 仲差幾件（扣咗櫃台、台面、員工搬緊嘅貨）
func demand_short(gid: String) -> int:
	if gid == "": return 0
	var need = 0
	for c in custs:
		if c.st == "out": continue
		need += maxi(0, int(c.wants.get(gid, 0)) - int(c.got.get(gid, 0)))
	if need <= 0: return 0
	var have = counter_n(gid)
	for sid in MD.stations(ci()):
		if str(MD.st_def(sid).get("good", "")) == gid: have += pile_n(sid)
	for w in workers:
		if str(MD.st_def(w.sid).get("good", "")) == gid and w.st in ["to_path", "go"]: have += int(w.carry)
	return maxi(0, need - have)
# [sell] 壽包「一半一半」：每台輪流（第 1 件擺櫃台、第 2 件入倉…），一轉 1 件都真係一半
func _half_k(sid: String, n: int) -> int:
	var m = st()
	if not (m.get("half") is Dictionary): m["half"] = {}
	var acc = int(J.num(m.half.get(sid)))
	var k = 0
	for i in n:
		if acc % 2 == 1: k += 1
		acc += 1
	m.half[sid] = float(acc % 2)
	return k
# 一轉 n 件：回 [入倉件數, 出售件數]（入倉已經夾咗倉位）
# [sell] 自動／全部出售：先補足排緊隊客人要嘅數擺櫃台，剩低先按規則入倉（全部入倉＝玩家自己揀，照入倉）
func split(sid: String, n: int) -> Array:
	var mid = M.rout(sid)
	if mid == "" or n <= 0: return [0, n]
	var r = route(sid); var gid = str(MD.st_def(sid).get("good", ""))
	if r == "stock":
		var ks = mini(n, int(floor(M.room(mid) + 1e-6)))
		if ks < n or demand_short(gid) > 0: _hint_sell(sid, gid)
		return [ks, n - ks]
	if r == "sell": return [0, n]
	var short = demand_short(gid)
	var buf = buffer_of(mid, sid)
	if buf > 0.0 and M.amt(mid) < buf:   # 上層要料：冇客等＝全入倉；有客等＝一件畀客、一件入倉（兩邊都唔斷）
		var ks = n if short <= 0 else n - mini(short, n - _half_k(sid, n))
		ks = mini(ks, int(floor(M.room(mid) + 1e-6)))
		return [ks, n - ks]
	var sell_first = mini(n, short)
	var rest = n - sell_first; var k = 0
	if rest > 0:
		if mid == "m_shoubao": k = _half_k(sid, rest)
		elif M.is_item(mid) and M.amt(mid) < ITEM_KEEP: k = rest
		if k < rest and storeable(mid) and counter_n(gid) >= MD.COUNTER_CAP: k = rest
	k = mini(k, int(floor(M.room(mid) + 1e-6)))
	return [k, n - k]
var _hint_t := {}
func _hint_sell(sid: String, gid: String) -> void:   # [sell] 全部入倉但客人等緊：提示改出售（每台 6 秒一次）
	if demand_short(gid) <= 0: return
	var t = now()
	if t - float(_hint_t.get(sid, -1e12)) < 6000.0: return
	_hint_t[sid] = t
	ev.append({"k": "hint_sell", "sid": sid, "pos": st_pos(sid)})
func _made(sid: String, n: int) -> void:   # 記數（任務「做壽包」= 嘆氣蒸籠產出數 → m.made.m_shoubao）
	var mid = M.rout(sid)
	var key = mid if mid != "" else str(MD.st_def(sid).get("good", ""))
	st().made[key] = J.num(st().made.get(key)) + float(n)
	IDL.add_made(self, sid, float(n))   # [idle] 累計產量
func _stock(sid: String, k: int, pos: Vector2) -> void:
	if k <= 0: return
	var mid = M.rout(sid)
	M.add(mid, float(k))
	ev.append({"k": "stock", "sid": sid, "mid": mid, "n": k, "pos": pos})

# ================= 離線 =================
# [chain] 離線（同埋場景收埋咗嘅時間）：按生產鏈逐段計（每段 ≤ 60 秒）——低層台先做、即刻入倉畀上層用；
#   每台每段：轉數 = 員工 × 秒 ÷ (做貨時間 + 出售比例 × 搬貨來回)，再按原料比例收細（冇料就冇得做）；
#   出貨照分流規則：入倉入材料庫、出售件數 × 單價 = 冥幣（唔計加速／收益掣）。最多 OFFLINE_H 小時。
func offline_rate() -> float:   # 每秒（估算：有料當全速、全部出售）
	var c = ci(); var r = 0.0
	for sid in st().st:
		if not unlocked(sid): continue
		var ow = IDL.off_w(self, sid); var w = ow[0]   # [idle] 領班：×1.25；只得領班 = 唔使搬貨嘅手做
		if w <= 0 or missing(sid).size() > 0: continue
		var l = lv(sid)
		r += w * MD.out(sid, l) * MD.val(sid, l, c) / (MD.tm(sid, l) + (MD.carry_s(c, sid) if ow[1] else 0.0)) * plus.off_mul(self, sid)   # [play] 羈絆
	return r
func _order() -> Array:   # 低層先
	var o = []
	for sid in st().st: if unlocked(sid) and (nworkers(sid) > 0 or IDL.has_fore(self, sid)): o.append(sid)   # [idle] 領班
	o.sort_custom(func(a, b):
		var ta = M.tier(M.rout(a)) if M.rout(a) != "" else 99
		var tb = M.tier(M.rout(b)) if M.rout(b) != "" else 99
		if ta != tb: return ta < tb
		return a < b)
	return o
# 推進 secs 秒（唔加冥幣入賬嘅細節由 acc 收集）；acc = {coins, rows:{sid: coins}, mats:{mid: +n}, made:{sid: n}}
func offline_step(secs: float, acc: Dictionary) -> void:
	var c = ci()
	for sid in _order():
		if war.blocked(self, sid): continue   # [war] 畀孤魂霸咗嘅檔停工
		var ow = IDL.off_w(self, sid); var l = lv(sid); var w = ow[0]; var n1 = MD.out(sid, l)   # [idle] 領班
		var sp = split(sid, n1)
		var sell_f = float(sp[1]) / maxf(1.0, n1) if ow[1] else 0.0
		var cyc = w * secs / (MD.tm(sid, l) + sell_f * MD.carry_s(c, sid)) * plus.off_mul(self, sid)   # [play] 羈絆
		var nd = need(sid, cyc * n1); var k = 1.0
		for mid in nd: if nd[mid] > 0.0: k = minf(k, M.amt(mid) / nd[mid])
		k = clampf(k, 0.0, 1.0)
		if k <= 0.0: continue
		for mid in nd: M.add(mid, -nd[mid] * k)
		var items = cyc * n1 * k
		var mid_o = M.rout(sid); var put = 0.0
		if mid_o != "":
			var buf = buffer_of(mid_o, sid)
			if route(sid) == "auto" and buf > 0.0 and M.amt(mid_o) < buf:
				put = minf(items, buf - M.amt(mid_o))   # 上層要料：補到需求線為止（唔好成段時間都入倉）
			else: put = items * float(sp[0]) / maxf(1.0, n1)
			put = minf(put, M.room(mid_o))
			if put > 0.0:
				M.add(mid_o, put); acc.mats[mid_o] = J.num(acc.mats.get(mid_o)) + put
		var sold = items - put
		var v = sold * MD.val(sid, l, c)
		acc.coins = J.num(acc.coins) + v
		acc.rows[sid] = J.num(acc.rows.get(sid)) + v
		var key = mid_o if mid_o != "" else str(MD.st_def(sid).get("good", ""))
		st().made[key] = J.num(st().made.get(key)) + items
		IDL.add_made(self, sid, items)   # [idle]
func offline_acc() -> Dictionary: return {"coins": 0.0, "rows": {}, "mats": {}}
func offline_gain(ms: float) -> Dictionary:
	var m = st()
	var secs = clampf(ms / 1000.0, 0.0, MD.OFFLINE_H * 3600.0)
	var acc = offline_acc(); var s = 0.0
	while s < secs - 1e-6:
		var d = minf(60.0, secs - s); offline_step(d, acc); s += d
	return offline_finish(acc, secs, ms / 1000.0 > MD.OFFLINE_H * 3600.0)
func offline_finish(acc: Dictionary, secs: float, capped: bool) -> Dictionary:
	var m = st()
	var tot = floor(J.num(acc.coins))
	tot = floor(tot * war.off_mul(self)); war.offline(self, secs)   # [war]
	if tot > 0.0: add_coins(tot); m.earned = J.num(m.get("earned")) + tot
	m.last = now()
	var rows = []
	for sid in acc.rows: rows.append([sid, acc.rows[sid]])
	return {"coins": tot, "secs": secs, "capped": capped, "rows": rows, "mats": acc.mats}
func check_away() -> Dictionary:   # 返嚟：由上次記低嘅時間計
	var m = st(); if m == null: return {}
	var ms = now() - J.num(m.get("last"))
	if ms < 60000.0: m.last = now(); return {}
	return offline_gain(ms)

# ================= 版面（世界座標：大地圖，由 MD.layout(ci) 讀） =================
var QP := PackedVector2Array()   # 客人排隊線
var QLEN := 0.0
var PATHS := {}                  # sid → 搬貨路線
var QP2 := PackedVector2Array()  # [unify] 第二條排隊線（左邊入）
var QLEN2 := 0.0
func _qp(c: Dictionary) -> PackedVector2Array: return QP2 if c.get("side", 0) == 1 and QP2.size() > 1 else QP   # [unify]
func _ql(c: Dictionary) -> float: return QLEN2 if c.get("side", 0) == 1 and QP2.size() > 1 else QLEN   # [unify]
func relayout(_top := 0.0, _bot := 0.0) -> void:
	var c = ci() if SS() != null else 0
	var Ly = MD.layout(c)
	var o = {"w": float(Ly.get("w", 390)), "h": float(Ly.h)}
	o.fence_y = float(Ly.get("fence_y", 150))
	o.guard_y = o.fence_y + 26.0
	o.foe_y0 = 70.0; o.foe_y1 = o.fence_y - 12.0
	# [zone] 分區地圖：孤魂喺野外區遊蕩，衝野外門（唔係成條柵欄）；守夜企喺門口
	o.gates = []; o.wild = []
	for q in Ly.get("gates", []): o.gates.append(MD.v2(q))
	if Ly.get("gdir") is Array: o.gdir = Ly.gdir   # [zone2] 野外門方向：1＝野外喺門上面，-1＝野外喺門下面
	if Ly.has("wh"): o.wh = float(Ly.wh)
	if Ly.get("guard_slots") is Array: o.guard_slots = Ly.guard_slots
	if Ly.get("vol_slots") is Array: o.vol_slots = Ly.vol_slots
	if Ly.get("vol_mid") is Array: o.vol_mid = Ly.vol_mid
	if J.t(Ly.get("zone")):
		for z in ZDm.of_type("wild", c): o.wild.append(ZDm.rect(z.rect))
	var cp = MD.v2(Ly.counter)
	o.counter = cp; o.counter_y = cp.y; o.counter_x0 = cp.x - 92.0; o.counter_x1 = cp.x + 92.0
	o.house = MD.v2(Ly.get("house", [cp.x - 14, cp.y - 68]))
	o.serve = MD.v2(Ly.serve)
	var rd = []
	for q in Ly.road: rd.append(MD.v2(q))
	o.road = rd
	L = o
	QP = MD.queue_poly(c); QLEN = MD.poly_len(QP)
	QP2 = PackedVector2Array()   # [unify] 左邊入口排隊線（合一地圖：客人由左右兩邊入）
	for q in Ly.get("q2", []): QP2.append(MD.v2(q))
	QLEN2 = MD.poly_len(QP2)
	PATHS.clear(); SPOS.clear()
	var smap = MK.slot_map(c)   # [market] 過勞鬼市集：當前街嘅台輪流佔本章台位（其他街照生產、唔畫）
	for sid in MD.stations(c):
		var ps = str(smap.get(sid, sid))
		SPOS[sid] = MD.st_xy(c, ps); PATHS[sid] = MD.st_path(c, ps)
	for w in workers: w.home = slot_pos(w.sid, int(w.slot))
	_sync_key = ""
func queue_s(i: int) -> float: return 46.0 * i
func queue_pos(i: int) -> Vector2: return MD.poly_at(QP, queue_s(i))
func drop_pos(_gid := "") -> Vector2: return MD.drop_xy(ci())
func counter_slot(gid: String) -> Vector2:   # 櫃台面疊貨位
	var gs = goods_list(); var i = maxi(0, gs.find(gid)); var n = maxi(1, gs.size())
	var x = lerpf(L.counter_x0 + 26.0, L.counter_x1 - 26.0, (i + 0.5) / n)
	return Vector2(x, L.counter_y - 44.0)
var SPOS := {}
func _place_stations() -> void: relayout()
func market_street(id: String) -> bool:   # [market] 切街：重排台位，喺位嘅員工跟住過去
	if not MK.set_cur(id): return false
	relayout()
	for w in workers: if str(w.get("st", "")) in ["work", "home"]: w.pos = w.home
	var i = 0
	for f in foes:   # 霸檔孤魂跟返個檔嘅新位
		if not f.has("occ") or f.st == "die" or f.st == "flee": continue
		var at = st_pos(str(f.occ)) + MVW.OCC_OFF[i % MVW.OCC_OFF.size()]; i += 1
		if f.st == "occ": f.pos = at
		f.tgt = at
	return true
func st_pos(sid: String) -> Vector2: return SPOS.get(sid, Vector2(195, 600))
func slot_pos(sid: String, i: int) -> Vector2:
	var p = st_pos(sid); var off = [Vector2(-40, 26), Vector2(6, 32), Vector2(50, 26)]
	return p + off[i % 3]
func guard_home(i: int) -> Vector2:
	if L.has("guard_slots") and i < L.guard_slots.size(): return MD.v2(L.guard_slots[i])   # [zone]
	return Vector2(80.0 + 115.0 * i, L.guard_y)
func ww() -> float: return float(L.get("w", FW))   # [zone] 世界闊（舊豎條 390）
# [zone] 孤魂衝邊度：舊＝正前面柵欄；分區＝最近嘅野外門
func fence_tgt(x: float, y := NAN) -> Vector2:
	if L.get("gates") is Array and L.gates.size():
		if L.has("gdir"):   # [zone2] 最近嘅野外門（上／下都得）
			var i = gate_i(Vector2(x, y if not is_nan(y) else L.gates[0].y))
			if is_nan(y): i = _gate_x(x)
			return Vector2(L.gates[i].x + rng.randf_range(-16, 16), L.gates[i].y - gate_d(i) * 8.0)
		var best = L.gates[0]
		for g in L.gates: if absf(g.x - x) < absf(best.x - x): best = g
		return Vector2(best.x + rng.randf_range(-16, 16), L.fence_y - 8.0)
	return Vector2(clampf(x, 24, FW - 24), L.fence_y - 8.0)
# [zone2] 野外門（任何方向）：最近嗰道門、方向、「喺門口」、守夜／義勇軍企位
func gate_i(p: Vector2) -> int:
	var bi = 0; var bd = INF
	for i in L.gates.size():
		var d = L.gates[i].distance_squared_to(p)
		if d < bd: bd = d; bi = i
	return bi
func _gate_x(x: float) -> int:
	var bi = 0
	for i in L.gates.size(): if absf(L.gates[i].x - x) < absf(L.gates[bi].x - x): bi = i
	return bi
func gate_d(i: int) -> float:
	var gd = L.get("gdir")
	return float(gd[i]) if gd is Array and i < gd.size() else 1.0
func at_fence(p: Vector2, m := 90.0) -> bool:   # 孤魂衝到門口（大排檔嗰邊 m 以內或者已經入咗）
	if L.has("gdir") and L.gates.size():
		var i = gate_i(p)
		return (p.y - L.gates[i].y) * gate_d(i) >= -m
	return p.y >= L.fence_y - m
func inside_d(p: Vector2, ref: Vector2) -> float:   # p 喺 ref 最近嗰道門大排檔嗰邊幾遠
	if L.has("gdir") and L.gates.size():
		var i = gate_i(ref)
		return (p.y - L.gates[i].y) * gate_d(i)
	return p.y - L.fence_y
func guard_line(ref: Vector2, off: float) -> float:   # 打 ref 呢隻孤魂要企嘅 y
	if L.has("gdir") and L.gates.size():
		var i = gate_i(ref)
		return L.gates[i].y + gate_d(i) * off
	return L.fence_y + off
func flee_dir(p: Vector2) -> float:   # 逃走方向（-1 向上、1 向下）
	if L.has("gdir") and L.gates.size(): return -gate_d(gate_i(p))
	return -1.0
func _wild_of(p: Vector2) -> Rect2:
	for r in L.get("wild", []): if r.grow(30).has_point(p): return r
	return L.wild[0] if L.get("wild", []).size() else Rect2(0, L.foe_y0, FW, L.foe_y1 - L.foe_y0)
func foe_roam(p: Vector2) -> Vector2:   # 喺自己嗰區隨便行
	if L.get("wild", []).size():
		var r = _wild_of(p).grow(-40)
		if L.has("gdir"): return Vector2(rng.randf_range(r.position.x, r.end.x), rng.randf_range(r.position.y + 40, r.end.y - 20))   # [zone2]
		return Vector2(rng.randf_range(r.position.x, r.end.x), rng.randf_range(maxf(r.position.y, L.foe_y0), L.foe_y1 - 30))
	return Vector2(rng.randf_range(24, FW - 24), rng.randf_range(L.foe_y0, L.foe_y1 - 30))
func view_cull(p: Vector2) -> bool: return true

func goods_list() -> Array:
	var o = []
	for sid in MD.stations(ci()):
		var g = str(MD.st_def(sid).get("good", ""))
		if g != "" and not o.has(g): o.append(g)
	for g in MKO.sub_goods(): if not o.has(g): o.append(g)   # [market M1 營運] 副貨都上櫃台
	return o
func avail_goods() -> Array:   # 客人可以要嘅貨：有人做緊／櫃台有貨／台面有貨／手做緊嘅台優先；全部都冇就用所有已解鎖
	var o = []; var act = []
	for sid in MD.stations(ci()):
		if unlocked(sid):
			var g = str(MD.st_def(sid).get("good", ""))
			if g == "" or o.has(g): continue
			if route(sid) == "stock" and counter_n(g) <= 0 and pile_n(sid) <= 0: continue   # [sell] 全部入倉嘅貨唔招客
			o.append(g)
			if (nworkers(sid) > 0 and not starving(sid)) or counter_n(g) > 0 or pile_n(sid) > 0 or float(mk.get(sid, -1.0)) >= 0.0: act.append(g)   # [chain] 斷料嘅台唔招客
	for g in MKO.sub_goods():   # [market M1 營運] 副貨：寄賣攤有人做／櫃台有貨先招客
		var h = MKO.host_of(g)
		if o.has(g) or h == "": continue
		o.append(g)
		if (nworkers(h) > 0 and not starving(h)) or counter_n(g) > 0: act.append(g)
	return act if act.size() else o
func sid_of(gid: String) -> String:
	for sid in MD.stations(ci()):
		if str(MD.st_def(sid).get("good", "")) == gid and unlocked(sid): return sid
	for sid in MD.stations(ci()): if str(MD.st_def(sid).get("good", "")) == gid: return sid
	return ""
func counter_n(gid: String) -> int: return int(J.num(st().counter.get(gid)))
func pile_n(sid: String) -> int: return int(J.num(st().pile.get(sid)))
func pile_cap(sid: String) -> int: return MD.out(sid, lv(sid)) * 5

# ================= 實體同步（派鬼／撤走之後） =================
func sync() -> void:
	var m = st(); var key = ""
	for sid in m.st: key += sid + str(m.st[sid].workers) + str(m.st[sid].unlocked)
	key += str(m.guards) + str(ci())
	if key == _sync_key: return
	_sync_key = key
	_place_stations()
	var keep = []
	for w in workers:
		var arr = m.st[w.sid].workers if m.st.has(w.sid) else []
		if int(w.slot) < arr.size() and J.seq(arr[int(w.slot)], w.gid): keep.append(w)
		else:
			if w.carry > 0: _put_counter(str(MD.st_def(w.sid).get("good", "")), int(w.carry))   # 搬緊嘅貨唔好蒸發
			if w.get("paid") is Dictionary: M.give(w.paid)   # [chain] 未做完嗰轉：退返料
	workers = keep
	for sid in m.st:
		var arr = m.st[sid].workers
		for i in arr.size():
			if arr[i] == null: continue
			var found = false
			for w in workers: if w.sid == sid and int(w.slot) == i: found = true
			if found: continue
			var gh = ghost(arr[i])
			var hp = slot_pos(sid, i)
			workers.append({"gid": arr[i], "k": J.str(J.gp(gh, "k")), "name": J.str(J.gp(gh, "name")), "sid": sid, "slot": i, "st": "work", "prog": rng.randf() * 0.3,
				"pos": hp, "home": hp, "carry": 0, "t": 0.0, "s": 0.0, "ph": rng.randf() * 10.0})
	var gk = []
	for g in guards:
		if int(g.slot) < m.guards.size() and J.seq(m.guards[int(g.slot)], g.gid): gk.append(g)
	guards = gk
	for i in m.guards.size():
		if m.guards[i] == null: continue
		var found = false
		for g in guards: if int(g.slot) == i: found = true
		if found: continue
		var gh = ghost(m.guards[i])
		guards.append({"gid": m.guards[i], "k": J.str(J.gp(gh, "k")), "name": J.str(J.gp(gh, "name")), "slot": i, "pos": guard_home(i), "cd": 0.0, "tgt": null, "atk": 0.0,
			"dps": MD.guard_dps(glv(gh)), "ph": rng.randf() * 10.0})

# ================= 每格 =================
func step(dt: float) -> void:
	if paused or st() == null: return
	sync()
	var sp = spd_mul()
	_step_workers(dt, sp)
	_step_manual(dt, sp)
	IDL.step(self, dt)   # [idle] 領班自動收錢／開工
	_step_custs(dt)
	_step_foes(dt)
	_step_guards(dt)
	war.step(self, dt)   # [war]
	plus.step(self, dt)   # [play]
	if MK.active(): MK.tick(MD.stations(ci()), dt * sp, func(x): return nworkers(x) > 0 or float(mk.get(x, -1.0)) >= 0.0)   # [market] 過勞值
	if MK.active(): MKO.tick(self, dt * sp)   # [market M1 營運] 店員位、換貨、收銀箱、治安事件＋巡邏

func _move(e: Dictionary, to: Vector2, dt: float, spd := WALK) -> bool:
	var d = to - e.pos
	if d.length() <= spd * dt: e.pos = to; e["walk"] = false; return true
	e.pos += d.normalized() * spd * dt; e["walk"] = true; e["flip"] = d.x < 0
	return false

func _put_counter(gid: String, n: int) -> int:
	var c = counter_n(gid); var put = mini(n, MD.COUNTER_CAP - c)
	if put > 0: st().counter[gid] = float(c + put)
	return put

func _step_workers(dt: float, sp: float) -> void:
	for w in workers:
		var sid: String = w.sid; var gid = str(MD.st_def(sid).get("good", ""))
		gid = MKO.wgood(w, gid)   # [market M1 營運] 呢轉係副貨
		if war.blocked(self, sid): w["walk"] = false; continue   # [war]
		var P: PackedVector2Array = PATHS.get(sid, PackedVector2Array())
		var plen = MD.poly_len(P)
		match w.st:
			"work":
				if not _move(w, w.home, dt): continue
				# 台面有手做剩嘅貨：先搬走
				if pile_n(sid) > 0 and w.prog <= 0.0:
					var n = mini(pile_n(sid), MD.out(sid, lv(sid)) * 2)
					st().pile[sid] = float(pile_n(sid) - n); w.carry = n; _go(w); continue
				# [chain] 開工先扣料：扣唔到 = 斷料（企喺度等，有料自動復工）
				if not (w.get("paid") is Dictionary):
					var nd = need(sid)
					if not M.take(nd): w["starve"] = true; continue
					w["paid"] = nd; w["starve"] = false
				w.prog += dt * sp * IDL.eff(self, sid) * plus.wmul(self, w) * MK.mul(sid) / MD.tm(sid, lv(sid))   # [market] 加班 ×2／趴低 0   # [idle] 領班 ×1.25  [play] 羈絆／瞌眼瞓／借領班
				if w.prog >= 1.0:
					var n = MD.out(sid, lv(sid))
					w.prog = 0.0; w.erase("paid"); _made(sid, n)
					if MKO.batch_sub(self, sid, w, n): continue   # [market M1 營運] 雙貨：呢轉做副貨，全數搬去櫃台
					var sp2 = split(sid, n)   # [chain] 分流：入倉即刻入庫，出售先搬去櫃台
					_stock(sid, sp2[0], w.home)
					ev.append({"k": "made", "sid": sid, "n": n, "pos": w.home})
					if sp2[1] > 0: w.carry = sp2[1]; _go(w)
			"to_path":   # 由企位行去台前（路線起點）
				if _move(w, P[0] if P.size() else w.home, dt, MD.WALK_W): w.st = "go"; w.s = 0.0
			"go":
				w.s = minf(plen, float(w.s) + MD.WALK_W * dt)
				_along(w, P, w.s)
				if w.s >= plen:
					w.t = float(w.get("t", 0.0)) + dt
					if w.t < MD.PICK_S * 0.5: continue
					var put = _put_counter(gid, int(w.carry))
					if put > 0:
						w.carry -= put
						ev.append({"k": "deliver", "gid": gid, "n": put, "pos": w.pos})
					if w.carry <= 0: w.st = "back"; w.t = 0.0; w.erase("wait")
					else: w["wait"] = true
			"back":
				w.s = maxf(0.0, float(w.s) - MD.WALK_W * dt)
				_along(w, P, w.s)
				if w.s <= 0.0: w.st = "home"
			"home":
				if _move(w, w.home, dt, MD.WALK_W): w.st = "work"; w.prog = 0.0
func _go(w: Dictionary) -> void: w.st = "to_path"; w.t = 0.0
func _along(e: Dictionary, P: PackedVector2Array, sv: float) -> void:
	var np = MD.poly_at(P, sv)
	var d = np - e.pos
	if d.length() > 0.01: e["flip"] = d.x < 0; e["walk"] = true
	e.pos = np

func _step_manual(dt: float, sp: float) -> void:
	for sid in mk.keys():
		if float(mk[sid]) < 0.0: continue
		mk[sid] = float(mk[sid]) + dt * sp * IDL.eff(self, sid) * plus.smul(self, sid) * MK.mul(sid) / MD.tm(sid, lv(sid))   # [market]   # [idle]  [play] 借領班
		if mk[sid] >= 1.0:
			mk[sid] = -1.0
			var n = MD.out(sid, lv(sid)); _made(sid, n)
			var sp2 = split(sid, n)   # [chain]
			_stock(sid, sp2[0], st_pos(sid))
			# [sell] 手做嘅出售件數直接送去櫃台（唔使再撳一下「收」）；櫃台滿先留喺台面
			var gid2 = str(MD.st_def(sid).get("good", ""))
			var put2 = _put_counter(gid2, sp2[1])
			if put2 > 0: ev.append({"k": "collect", "sid": sid, "gid": gid2, "n": put2, "pos": st_pos(sid)})
			st().pile[sid] = float(mini(pile_cap(sid), pile_n(sid) + sp2[1] - put2))
			ev.append({"k": "made", "sid": sid, "n": n, "pos": st_pos(sid)})
			# [qa54] 新手「大排檔賣貨」那一步：仲有客等緊呢樣貨就自動接住做下一籠（有料先做），玩家撳一下就得，唔使狂撳
			if load("res://game/onboard/ob.gd")._sell_on() and _cust_wants(gid2) > counter_n(gid2) and M.take(need(sid)):
				mk[sid] = 0.0
func _cust_wants(gid: String) -> int:   # [qa54] 排隊客人仲差幾件呢樣貨
	var n = 0
	for c in custs:
		if c.st == "out": continue
		n += maxi(0, int(c.wants.get(gid, 0)) - int(c.got.get(gid, 0)))
	return n

# 撳台面：有貨＝收去櫃台；冇貨＝開始做一轉
func tap_station(sid: String) -> String:
	if not unlocked(sid): return ""
	if war.blocked(self, sid): return "occ"   # [war]
	if pile_n(sid) > 0:
		var gid = str(MD.st_def(sid).get("good", ""))
		var put = _put_counter(gid, pile_n(sid))
		if put <= 0: return "full"
		st().pile[sid] = float(pile_n(sid) - put)
		ev.append({"k": "collect", "sid": sid, "gid": gid, "n": put, "pos": st_pos(sid)})
		return "collect"
	if float(mk.get(sid, -1.0)) >= 0.0: return "busy"
	if not M.take(need(sid)):   # [chain] 手做都要料
		mk_starve[sid] = true; ev.append({"k": "starve", "sid": sid, "miss": missing(sid), "pos": st_pos(sid)})
		return "starve"
	mk_starve.erase(sid)
	mk[sid] = 0.0
	return "make"

# ---------------- 客人 ----------------
# [p55] 客人等緊而櫃台唔夠：自動由倉庫補上櫃台（扣倉庫；保留上層台要料線＋升級／招魂最低庫存；呢台揀「全部入倉」唔補）
const RESTOCK_EVERY := 0.5
var _rs_t := 0.0
func up_keep(mid: String) -> float:   # 升級／招魂要用嘅最低庫存
	var rk = M.res_key(mid)
	if rk == "buns": return 40.0   # 招魂台招雜鬼（recruitCost）
	if rk == "planks":
		var G = J.G; var k = 0.0
		if G.get("upCost") is Callable and G.get("S") is Dictionary and G.S.get("bld") is Dictionary:
			var best = INF
			for b in G.S.bld:
				var c = J.mc(G, "upCost", [str(b), J.num(G.S.bld[b])])
				if c is Dictionary and J.num(G.S.bld[b]) > 0.0: best = minf(best, J.num(c.get("planks")))
			if best < INF: k = best
		return k
	return 0.0
func restock_keep(mid: String) -> float: return buffer_of(mid) + up_keep(mid)
func restock_counter() -> int:
	var moved = 0
	for sid in MD.stations(ci()):
		if not unlocked(sid) or route(sid) == "stock": continue
		var gid = str(MD.st_def(sid).get("good", "")); var mid = M.rout(sid)
		if gid == "" or mid == "": continue
		var short = demand_short(gid)
		if short <= 0: continue
		var n = mini(short, mini(int(floor(M.amt(mid) - restock_keep(mid) + 1e-6)), MD.COUNTER_CAP - counter_n(gid)))
		if n <= 0 or not M.take({mid: float(n)}): continue
		st().counter[gid] = float(counter_n(gid) + n); moved += n
		ev.append({"k": "restock", "sid": sid, "gid": gid, "n": n, "to": counter_slot(gid)})
	return moved
func _step_custs(dt: float) -> void:
	_rs_t -= dt
	if _rs_t <= 0.0: _rs_t = RESTOCK_EVERY; restock_counter()   # [p55]
	var waiting = 0
	for c in custs: if c.st != "out": waiting += 1
	spawn_t -= dt
	if spawn_t <= 0.0:
		spawn_t = rng.randf_range(2.2, 4.0) * (2.0 if fence_pressure() >= 2 else 1.0)
		spawn_t /= war.freq_mul(self)   # [war]
		spawn_t /= plus.freq_mul(self)   # [play] 夜潮
		spawn_t /= MKO.flow_mul(self)   # [market M1 營運] 加班叫賣吸客（data/market_ops.json demand）
		if waiting < MD.QUEUE_MAX: spawn_cust()
	var order = []
	for c in custs: if c.st != "out": order.append(c)
	var side_n = [0, 0]   # [unify] 兩條排隊線各自計位（第 0 位＝收貨位，兩邊共用）
	for i in order.size():
		var c = order[i]; c.slot = i
		var sd = int(c.get("side", 0)) if QP2.size() > 1 else 0
		var qi = i
		if i > 0: side_n[sd] += 1; qi = side_n[sd]
		var ts = queue_s(qi)
		match c.st:
			"in", "queue":
				# 由入口沿路行入嚟（排隊線上嘅弧長 s 慢慢減到自己個位）
				c.s = maxf(ts, float(c.s) - 90.0 * dt)
				_along(c, _qp(c), c.s)
				if c.s <= ts + 0.01:
					c["walk"] = false
					c.st = "serve" if i == 0 else "queue"
					if i == 0: c.take = 0.3
			"serve":
				if i != 0: c.st = "queue"; continue
				c.flip = true; c["walk"] = false
				c.take -= dt
				c.wait = float(c.get("wait", 0.0)) + dt
				if c.wait > PATIENCE + IDL.PAT_STAR * _cust_stars(c) + plus.pat_add(c):   # [play]   # [idle] 品質星：客人肯等耐啲； 等太耐：有攞到嘅就俾嗰啲錢走人，冇就嬲嬲走
					if _got_n(c) > 0: _pay(c)
					else: c.st = "out"; ev.append({"k": "leave", "pos": c.pos + Vector2(0, -60), "cid": c.cid})   # [story] cid：客人 say.wait
					continue
				if c.take <= 0.0 and not plus.hold_take(self):   # [play] 囤貨
					c.take = 0.16
					var all_ok = true
					for g in c.wants:
						var need = int(c.wants[g]) - int(c.got.get(g, 0))
						if need <= 0: continue
						all_ok = false
						if counter_n(g) > 0:
							st().counter[g] = float(counter_n(g) - 1); c.got[g] = int(c.got.get(g, 0)) + 1; c.wait = 0.0
							ev.append({"k": "take", "gid": g, "from": counter_slot(g), "to": c.pos + Vector2(0, -40)})
							break
					if all_ok and not plus.hold_pay(self, c): _pay(c)   # [play] 講價／挑剔等決定
	for c in custs.duplicate():
		if c.st == "out":
			c.s = float(c.s) + 110.0 * dt
			_along(c, _qp(c), c.s)
			if c.s >= _ql(c): custs.erase(c)

func _cust_stars(c: Dictionary) -> float:   # [idle] 客人要嘅貨裡面最高品質星
	var b = 0
	for g in c.wants:
		var s = sid_of(str(g))
		if s != "": b = maxi(b, MD.stars(s, lv(s)))
	return float(b)
func spawn_cust() -> bool:
	if ML.on(): return ML.spawn_cust(self)   # [militia]
	var av = avail_goods(); if av.is_empty(): return false
	var cands = []
	for cid in MD.map_def(ci()).get("customers", []):
		var cd = MD.cust_def(str(cid)); if cd.is_empty(): continue
		var ok = []
		for g in cd.get("wants", []): if av.has(str(g)): ok.append(str(g))
		if ok.size(): cands.append([cd, ok])
	if cands.is_empty(): return false
	var pick = cands[rng.randi() % cands.size()]
	pick = war.pick_cust(self, cands, pick)   # [war]
	var ok: Array = pick[1].duplicate()
	var ng = 2 if ok.size() >= 2 and rng.randf() < 0.3 else 1
	var wants = {}
	var served = J.num(st().get("served"))
	var qmax = clampi(2 + int(served / 10.0), 2, 6)
	for j in ng:
		var g = ok[rng.randi() % ok.size()]; ok.erase(g)
		wants[g] = 1 + rng.randi() % qmax
	var c = {"cid": str(pick[0].id), "k": str(pick[0].get("art", "youhun")), "wants": wants, "got": {}, "st": "in", "slot": 99, "take": 0.3,
		"s": QLEN, "pos": MD.poly_at(QP, QLEN), "ph": rng.randf() * 10.0, "flip": true, "lines": pick[0].get("lines", []), "vip": J.t(pick[0].get("vip"))}
	if QP2.size() > 1 and rng.randf() < 0.5:   # [unify] 一半客人由左邊入
		c["side"] = 1; c.s = QLEN2; c.pos = MD.poly_at(QP2, QLEN2); c.flip = false
	custs.append(c)
	plus.on_spawn(self, c)   # [play] 脾氣
	return true

func _got_n(c: Dictionary) -> int:
	var n = 0
	for g in c.got: n += int(c.got[g])
	return n
func cust_value(c: Dictionary) -> float:   # 按實際攞到嘅件數計（收齊＝要嘅數）
	var amt = 0.0; var cc = ci()
	for g in c.got:
		var sid = sid_of(g)
		if sid != "": amt += float(c.got[g]) * MD.val(sid, lv(sid), cc)
	amt += MKO.sub_adj(self, c)   # [market M1 營運] 副貨按自己底價計
	return amt * inc_mul()
func _pay(c: Dictionary) -> void:
	var amt = cust_value(c)
	amt *= war.pay_mul(self, c)   # [war]
	amt *= plus.pay_mul(self, c)   # [play]
	add_coins(amt)
	MKO.on_pay(self, c, amt)   # [market M1 營運] 錢先入收銀箱，櫃檯員／店員／玩家收咗先入帳
	var m = st()
	var _obn = 0
	for g in c.got: m.sold[g] = J.num(m.sold.get(g)) + float(c.got[g]); _obn += int(c.got[g])
	load("res://game/onboard/ob.gd").on_sold(_obn, amt)   # [onboard] 新手任務：大排檔賣貨
	m.earned = J.num(m.get("earned")) + amt; m.served = J.num(m.get("served")) + 1.0
	c.st = "out"
	ev.append({"k": "pay", "amt": amt, "pos": c.pos + Vector2(0, -60), "cid": c.cid})
	war.on_paid(self, c)   # [war]
	plus.on_paid(self, c, amt)   # [play]
	ML.on_paid(self, c)   # [militia] 買兵器 → 加入遊魂兵

# ---------------- 圍欄孤魂 ----------------
func fence_pressure() -> int:
	var n = 0
	for f in foes: if f.st == "bang": n += 1
	return n
func _step_foes(dt: float) -> void:
	var c = ci()
	foe_t -= dt
	var alive = 0
	for f in foes: if f.st != "die": alive += 1
	load("res://game/onboard/ob.gd").guard_step(self, dt)   # [onboard] 第一次守夜：固定三隻弱孤魂
	if foe_t <= 0.0:
		foe_t = rng.randf_range(3.0, 6.5) / plus.foe_mul(self)   # [play] 夜潮
		if alive < FOE_MAX and load("res://game/zone/zone_data.gd").wild_open(): spawn_foe()   # [fogfix] 野外區未開放：冇孤魂由野外出
	for f in foes.duplicate():
		f.t += dt
		match f.st:
			"roam":
				if _move(f, f.tgt, dt, 40.0):
					if f.t > f.get("calm", 3.0): f.st = "charge"; f.tgt = fence_tgt(f.pos.x, f.pos.y); f.t = 0.0   # [zone]
					else: f.tgt = foe_roam(f.pos)
			"charge":
				if _move(f, f.tgt, dt, 95.0): f.st = "bang"; f.t = 0.0; ev.append({"k": "bang", "pos": f.pos})
			"bang":
				f["bob"] = sin(f.t * 18.0) * 3.0
				if fmod(f.t, 0.6) < dt: ev.append({"k": "rattle", "x": f.pos.x})
				if f.t > 7.0:
					f.st = "roam"; f.t = 0.0; f.calm = rng.randf_range(3, 6); f.tgt = Vector2(f.pos.x + rng.randf_range(-60, 60), L.foe_y0 + 20)
					if L.get("wild", []).size(): f.tgt = foe_roam(f.pos)   # [zone]
			"die":
				if f.t > 0.7: foes.erase(f)

func spawn_foe() -> bool:
	var ks = MD.map_def(ci()).get("fence_foes", ["youhun"])
	if not (ks is Array) or ks.is_empty(): ks = ["youhun"]
	var left = rng.randf() < 0.5
	var y = rng.randf_range(L.foe_y0 + 10, L.foe_y1 - 30)
	var hp = MD.foe_hp(ci())
	var p0 = Vector2(-30.0 if left else FW + 30.0, y); var t0 = Vector2(rng.randf_range(40, FW - 40), y)
	if L.get("wild", []).size():   # [zone] 由野外區深處（頂）出
		var wr: Rect2 = L.wild[rng.randi() % L.wild.size()]
		p0 = Vector2(rng.randf_range(wr.position.x + 40, wr.end.x - 40), wr.position.y + 120.0)
		if L.has("gdir") and gate_d(gate_i(wr.get_center())) < 0: p0.y = wr.end.y - 120.0   # [zone2] 野外喺下面：由底出
		t0 = foe_roam(p0); left = t0.x > p0.x
	foes.append({"k": str(ks[rng.randi() % ks.size()]), "pos": p0, "hp": hp, "mx": hp, "st": "roam", "t": 0.0, "calm": rng.randf_range(1.5, 4.0),
		"tgt": t0, "ph": rng.randf() * 10.0, "flip": not left})
	return true

func hit_foe(f: Dictionary, dmg: float, by: String) -> void:
	if f.st == "die": return
	dmg *= plus.dmg_mul(self, f)   # [play] 招牌菜 Boss 弱點
	f.hp -= dmg; f["hurt"] = 0.25
	ev.append({"k": "hit", "pos": f.pos + Vector2(0, -30), "dmg": dmg, "by": by})
	if f.hp <= 0.0:
		f.st = "die"; f.t = 0.0
		load("res://game/onboard/ob.gd").guard_kill(f)   # [onboard]
		var cc = MD.foe_coin(ci()) * plus.kill_mul(self); add_coins(cc)   # [play] 夜潮
		ev.append({"k": "kill", "pos": f.pos + Vector2(0, -40), "coins": cc})
const TAP_R := 46.0   # [p55] 撳孤魂判定放大（34→46）：揀最近嗰隻
func tap_foe(p: Vector2) -> bool:
	var best = null; var bd = TAP_R
	for f in foes:
		if f.st == "die" or f.st == "flee": continue
		var d = p.distance_to(f.pos + Vector2(0, -30))
		if d < bd: bd = d; best = f
	if best == null: return false
	hit_foe(best, MD.TAP_DMG, "tap"); return true

func _step_guards(dt: float) -> void:
	for f in foes:
		if f.has("hurt"):
			f.hurt -= dt
			if f.hurt <= 0: f.erase("hurt")
	for g in guards:
		g.atk = maxf(0.0, g.atk - dt); g.cd -= dt
		var tgt = g.tgt
		if tgt == null or not (tgt in foes) or tgt.st == "die":
			tgt = null; var best = 1e9
			for f in foes:
				if f.st == "die" or f.has("occ") or not at_fence(f.pos, 90.0): continue   # [zone2]  [p55] 霸檔孤魂：玩家親手撳走
				var taken = false
				for g2 in guards: if g2 != g and g2.tgt == f: taken = true
				var d = absf(f.pos.x - g.pos.x) + (60.0 if taken else 0.0) + (0.0 if f.st == "bang" else 40.0)
				if d < best: best = d; tgt = f
			g.tgt = tgt
		if tgt == null:
			_move(g, guard_home(int(g.slot)), dt, 70.0)
			continue
		var want = Vector2(clampf(tgt.pos.x + (-22.0 if tgt.pos.x > g.pos.x else 22.0), 20, ww() - 20), guard_line(tgt.pos, 26.0))   # [zone2]
		if _move(g, want, dt, 110.0) or absf(tgt.pos.x - g.pos.x) < 30.0:
			g.flip = tgt.pos.x < g.pos.x
			if g.cd <= 0.0 and at_fence(tgt.pos, 90.0):
				g.cd = 0.5; g.atk = 0.25
				hit_foe(tgt, g.dps * 0.5, "guard")
