# 分村＋補給網（autoload「Garrison」，D 線）
# 存檔：S.gar（舊存檔用到先建立）。設定：data/nat/supply.json。面板：game/garrison/gr_panel.gd。
#
# 公式（全部數值喺 supply.json）：
#   陰間夜     night = floor((now - t0) / (NIGHT_MIN 分鐘))；每晚結算一次（night_step），離線最多補 OFFLINE_H 小時（= 24 晚）
#   等級倍數   lvmul(lv) = 1 + LV_MUL × (lv − 1)；招牌 mile(lv) = Π 1.5（lv ≥ 5／10／15／20）
#   幫工位     HELP：lv1 → 1 位、lv6 → 2 位、lv11 → 3 位；管事位永遠 1 個（要有名有姓嘅鬼，雜鬼唔做得）
#   鄉里       home(鬼, 圖)：Boss 守老家 ×1.5；其他鬼守出身地圖 ×1.3（n30 睇 N30_G.at；pg／雜鬼睇巡陰 TKING／CH_FOD；Boss 睇章）
#   駐守產量   每隻駐守鬼每晚：yield[物] × (1 + GLV_K × 鬼等級) × home  → 入該圖存糧倉（上限 store_cap）；冥幣直接入 S.res
#   檔口收入   base × incMul(圖) × lvmul × mile × Σ員工[(1 + 該檔屬性/100) × 角色(管事 1.5／幫工 1) × home] × 斷糧倍數
#              （第二期）每晚收入唔再喺 night_step 一次過計，改為實時累積：每毫秒 = income ÷ 一晚毫秒（_accrue）
#              有管事＝自動入賬（S.res.coins）；冇管事＝入收銀箱 m.till，上限 TILL.nights 晚收入（唔計斷糧），滿咗停收，要玩家撳 collect
#              離線：累積最多 OFFLINE_H 小時（g.acc 唔早過 now − OFFLINE_H）；逐晚分段累積（每段用嗰晚嘅斷糧倍數），同舊每晚結算一樣
#   孤魂騷擾   每晚最後 (1 − RAID.start) 時間（子時）：thieves = clamp(ceil(RAID.max × theft_rate ÷ THEFT.rate), 1, RAID.max)
#              玩家嚇走／派宵夜 gone 隻 → 嗰晚失竊 × (thieves − gone) ÷ thieves；冇郁（離線）＝ 原公式
#              派宵夜：壽包 RAID.feed × (1 + feedMapMul × ci)（落魄村 S.res），名冊有位就用 recruitFodder 收編，自動填分村空幫工位
#   守夜       guard = Σ員工[武 × 角色 × home] × lvmul × mile；每晚失竊 = 存貨 × rate × max(0, 1 − guard / (need × mapMul^ci))
#   存糧倉     store_cap = base × (1 + mapMul × ci) × (1 + perLv × (lv − 1)) × mile
#   前線       已解鎖但未通關嘅最後一張圖；每晚食 upkeep；不夠＝斷糧 +1 級（最多 3），夠＝斷糧清零
#   車隊       每 CONVOY_EVERY 晚出車，CONVOY_EVERY 晚後送到；容量 = (base + perTroop × min(陰兵, troopMax)) × (睇過 gift_car ? carMul : 1)
#              裝貨：want = 前線上限 − 前線存貨 + 途中會食嘅 CONVOY_EVERY 晚；先由近前線嘅分村攞，唔夠再由老家 S.res 攞（每樣最多 HOME_SHARE）
#              同時每張分村存貨嘅 TO_RES 跟車返老家（冇前線時 TO_RES_NOFRONT）
#   急件車     每晚一次，即刻送到；每件貨 URGENT.perItem 冥幣
extends Node

const STALL_IDS := ["bun", "rest", "guard"]
const ITEMS := ["buns", "planks"]

var D: Dictionary = {}
var BOSS_CI: Dictionary = {}     # k → 章（ci）
var ORIGIN: Dictionary = {}      # k → 出身地圖（ci）
var SITES: Array = []            # 巡陰 REG site 次序
var _acc := 0.0
var _posts_done := false
var panel = null
var quiet := false               # 測試用：唔出 toast／交更簿
var last_rep = null              # 最近一次跨晚結算（場景顯示孤魂偷咗幾多）

func _ready() -> void:
	var f = FileAccess.open("res://data/nat/supply.json", FileAccess.READ)
	if f: D = JSON.parse_string(f.get_as_text())
	_build_origin()
	set_process(true)

func _build_origin() -> void:
	var pt = _json("res://data/nat/patrol.json")
	for r in pt.get("REG", []): SITES.append(str(r.site))
	var fod = pt.get("CH_FOD", [])
	for ci in fod.size():
		for k in fod[ci]: ORIGIN[str(k)] = ci
	var tk = pt.get("TKING", [])
	for ci in tk.size():
		for z in tk[ci]:
			for sz in tk[ci][z]: ORIGIN[str(tk[ci][z][sz])] = ci
	var n30 = _json("res://data/n30_data.json")
	var NG = n30.get("N30_G", {})
	for k in NG:
		var at = str(NG[k].get("at", ""))
		if SITES.has(at): ORIGIN[str(k)] = SITES.find(at)
	var dd = _json("res://data/nat/data.json")
	var CH = dd.get("CHAPTERS", [])
	for ci in CH.size():
		for stg in CH[ci].get("stages", []):
			for k in stg.get("join", []): BOSS_CI[str(k)] = ci; ORIGIN[str(k)] = ci

func _json(p: String) -> Dictionary:
	var f = FileAccess.open(p, FileAccess.READ)
	if f == null: return {}
	var o = JSON.parse_string(f.get_as_text())
	return o if o is Dictionary else {}

# ---------------- 小工具 ----------------
func S():
	var s = J.G.get("S")
	return s if s is Dictionary else null
func now() -> float: return J.now()
func night_ms() -> float: return float(D.get("NIGHT_MIN", 20)) * 60000.0
func T(yue: String, zh: String) -> String: return yue if DB.lang == "yue" else zh
func TA(a) -> String: return str(a[0]) if DB.lang == "yue" else str(a[1])
func N(s: String) -> String: return DB.N(s) if DB.has_method("N") else s
func fmt(v) -> String:
	var f = J.G.get("fmt")
	return J.str(J.cl(f, null, [floor(J.num(v))])) if f != null else str(int(floor(J.num(v))))
func save() -> void:
	var f = J.G.get("save")
	if f != null: J.cl(f, null, [])
func toast(html: String) -> void:
	if quiet: return
	var fx = J.G.get("Fx")
	if fx != null: J.mc(fx, "toast", [N(html)])
func map_def(ci: int) -> Dictionary: return D.MAPS[ci]
func maps_n() -> int: return D.MAPS.size()

# ---------------- 地圖狀態 ----------------
# 移動村（S.mv_on）：村子喺 S.mv.ci；拔咗營嘅圖（ci < S.mv.ci）先係分村，前線 = 村子所在地圖
func mv_ci() -> int:
	var s = S()
	if s == null or not J.t(s.get("mv_on")) or not (s.get("mv") is Dictionary): return -1
	return clampi(int(J.num(s.mv.get("ci", 0))), 0, maps_n() - 1)
func is_open(ci: int) -> bool:   # 嗰張圖通關未（巡陰區域第 3 關＝主線 Boss）；移動村：拔咗營未
	var s = S()
	if s == null or ci < 0 or ci >= maps_n(): return false
	var mc = mv_ci()
	if mc >= 0: return ci < mc
	var cl = s.get("cleared")
	return cl is Dictionary and J.t(cl.get("%d-3" % (ci + 1)))
func region_open(ci: int) -> bool: return ci == 0 or is_open(ci - 1)
func open_maps() -> Array:
	var o = []
	for ci in maps_n(): if is_open(ci): o.append(ci)
	return o
func frontline() -> int:
	var mc = mv_ci()
	if mc >= 0: return mc
	for ci in maps_n():
		if not is_open(ci): return ci if region_open(ci) else -1
	return -1
func upkeep(ci: int):
	if ci < 0: return null
	var u = map_def(ci).get("upkeep")
	return u if u is Dictionary else null

func _new_map() -> Dictionary:
	var posts = {}
	for sid in STALL_IDS: posts[sid] = [null, null, null, null]
	return {"lv": {"bun": 1.0, "rest": 1.0, "guard": 1.0, "store": 1.0}, "posts": posts, "stock": {"buns": 0.0, "planks": 0.0}, "till": {"bun": 0.0, "rest": 0.0}, "raid": null}

func st():
	var s = S()
	if s == null: return null
	if not (s.get("gar") is Dictionary):
		s["gar"] = {"v": 1.0, "t0": now(), "done": 0.0, "night": 0.0, "home": true, "urgent": -1.0, "starve": 0.0,
			"maps": {}, "front": {"ci": -1.0, "buns": 0.0, "planks": 0.0}, "convoy": null, "log": [], "tot": {}}
	var g = s.gar
	for k in ["maps", "front", "tot"]: if not (g.get(k) is Dictionary): g[k] = {} if k != "front" else {"ci": -1.0, "buns": 0.0, "planks": 0.0}
	if not (g.get("log") is Array): g["log"] = []
	for ci in maps_n():
		var key = str(ci)
		if not (g.maps.get(key) is Dictionary): g.maps[key] = _new_map()
		var m = g.maps[key]
		for sid in STALL_IDS:
			if not (m.posts.get(sid) is Array): m.posts[sid] = [null, null, null, null]
			while m.posts[sid].size() < 4: m.posts[sid].append(null)
		if not (m.get("till") is Dictionary): m["till"] = {"bun": 0.0, "rest": 0.0}
	if g.get("acc") == null: g["acc"] = J.num(g.t0) + J.num(g.done) * night_ms()   # 舊存檔：由今晚開頭起計
	return g
func ms(ci: int) -> Dictionary: return st().maps[str(ci)]

# ---------------- 鬼 ----------------
func ghost(id):
	var s = S()
	if s == null or id == null: return null
	for gh in J.iter(s.get("ghosts")): if J.seq(J.gp(gh, "id"), id): return gh
	return null
func glv(gh) -> float:
	var F = J.G.get("F")
	return J.num(J.mc(F, "glv", [gh])) if F != null else J.num(J.gp(gh, "lv"))
func stat(gh, i: int) -> float:
	var F = J.G.get("F")
	if F != null: return J.num(J.mc(F, "stat", [gh, float(i)]))
	return J.num(J.gp(gh, "st")[i])
func is_fodder(gh) -> bool: return J.seq(J.gp(gh, "q"), "藍") or J.seq(J.gp(gh, "q"), "紫")
func home_mul(gh, ci: int) -> float:
	var k = J.str(J.gp(gh, "k"))
	if BOSS_CI.has(k): return float(D.HOME.boss) if int(BOSS_CI[k]) == ci else 1.0
	if ORIGIN.has(k) and int(ORIGIN[k]) == ci: return float(D.HOME.own)
	return 1.0
func home_ci(gh) -> int:
	var k = J.str(J.gp(gh, "k"))
	return int(ORIGIN[k]) if ORIGIN.has(k) else -1

func validate() -> void:
	var g = st(); if g == null: return
	var seen = {}
	for ci in maps_n():
		var m = g.maps[str(ci)]
		for sid in STALL_IDS:
			var p = m.posts[sid]
			for i in p.size():
				var gid = p[i]
				if gid == null: continue
				var gh = ghost(gid); var key = J.str(gid)
				if gh == null or not J.seq(J.gp(gh, "post"), "garrison") or seen.has(key): p[i] = null; continue
				seen[key] = true
	# 冇登記喺任何格嘅 garrison 鬼（例如舊存檔殘留）：放返佢自由
	var s = S()
	for gh in J.iter(s.get("ghosts")):
		if J.seq(J.gp(gh, "post"), "garrison") and not seen.has(J.str(J.gp(gh, "id"))): J.sp(gh, "post", null)

func assign(ci: int, sid: String, idx: int, gid) -> bool:
	var m = ms(ci); var posts = m.posts[sid]; var old = posts[idx]
	if gid != null:
		if idx > helpers(lv_of(ci, sid)): return false
		var gh0 = ghost(gid)
		if gh0 == null or J.seq(J.gp(gh0, "k"), "afu"): return false
		if idx == 0 and is_fodder(gh0): return false
	if old != null:
		var og = ghost(old)
		if og != null and J.seq(J.gp(og, "post"), "garrison"): J.sp(og, "post", null)
	if gid == null: posts[idx] = null; return true
	var gh = ghost(gid)
	for c2 in maps_n():
		var m2 = ms(c2)
		for s2 in STALL_IDS:
			var p2 = m2.posts[s2]
			for i in p2.size(): if J.seq(p2[i], gid): p2[i] = null
	J.sp(gh, "post", "garrison"); posts[idx] = J.gp(gh, "id")
	return true

func free_ghosts() -> Array:
	var t0 = now(); var out = []
	var s = S(); if s == null: return out
	for gh in J.iter(s.get("ghosts")):
		if not J.seq(J.gp(gh, "k"), "afu") and not J.t(J.gp(gh, "post")) and not (J.num(J.gp(gh, "tiredUntil")) > t0): out.append(gh)
	return out
# 揀人名單：自由嘅鬼排先；喺其他地方做緊嘢（村子崗位／站崗／其他分村）嘅都列出，揀咗會調走
func pick_list(ci: int, sid: String, idx: int) -> Array:
	var s = S(); var out = []; var t0 = now(); var si = stall_def(sid).stat
	for gh in J.iter(s.get("ghosts")):
		if J.seq(J.gp(gh, "k"), "afu") or J.num(J.gp(gh, "tiredUntil")) > t0: continue
		if idx == 0 and is_fodder(gh): continue
		var p = J.gp(gh, "post")
		if J.t(p) and not (J.str(p) in ["garrison", "wood", "rice", "plank", "bun", "store", "boss", "camp", "station"]): continue   # 樓裡有鬼出更等：唔郁
		out.append(gh)
	out.sort_custom(func(a, b):
		var fa = 0 if not J.t(J.gp(a, "post")) else 1; var fb = 0 if not J.t(J.gp(b, "post")) else 1
		if fa != fb: return fa < fb
		var va = stat(a, int(si)) * home_mul(a, ci); var vb = stat(b, int(si)) * home_mul(b, ci)
		return va > vb)
	return out

# ---------------- 檔口數值 ----------------
func stall_def(sid: String) -> Dictionary:
	for x in D.STALLS: if x.id == sid: return x
	return {"id": sid, "name": "存糧倉", "stat": 2, "base": 0}
func lv_of(ci: int, sid: String) -> float: return J.num(ms(ci).lv.get(sid, 1.0))
func helpers(lv: float) -> int:
	var n = 0
	for h in D.HELP: if lv >= float(h[0]): n = int(h[1])
	return n
func lvmul(lv: float) -> float: return 1.0 + float(D.LV_MUL) * (lv - 1.0)
func mile(lv: float) -> float:
	var m = 1.0
	for x in D.MILESTONE: if lv >= float(x[0]): m *= float(x[1])
	return m
func mile_name(lv: float) -> String:
	var nm = ""
	for x in D.MILESTONE: if lv >= float(x[0]): nm = str(x[2])
	return nm
func next_mile(lv: float) -> Array:
	for x in D.MILESTONE: if lv < float(x[0]): return x
	return []
func staff(ci: int, sid: String) -> Array:   # [[gh, 角色倍數], ...]
	var o = []; var p = ms(ci).posts[sid]
	for i in p.size():
		if p[i] == null: continue
		var gh = ghost(p[i])
		if gh != null: o.append([gh, float(D.ROLE.mgr) if i == 0 else float(D.ROLE.help)])
	return o
func starve_mul() -> float:
	var lvl = int(J.num(st().get("starve")))
	return float(D.STARVE[min(lvl, D.STARVE.size()) - 1].inc) if lvl > 0 else 1.0
func starve_level() -> int: return int(J.num(st().get("starve"))) if st() != null else 0
func starve_atk() -> float:   # 俾巡陰用（第一期未接）：前線攻擊加成（負數）
	var lvl = starve_level()
	return float(D.STARVE[min(lvl, D.STARVE.size()) - 1].get("atk", 0)) if lvl > 0 else 0.0
func income(ci: int, sid: String, with_starve := true) -> float:
	var sd = stall_def(sid)
	if float(sd.base) <= 0: return 0.0
	var k = 0.0
	for e in staff(ci, sid): k += (1.0 + stat(e[0], int(sd.stat)) / 100.0) * e[1] * home_mul(e[0], ci)
	var lv = lv_of(ci, sid)
	return float(sd.base) * float(map_def(ci).incMul) * lvmul(lv) * mile(lv) * k * (starve_mul() if with_starve else 1.0)
func guard_pow(ci: int) -> float:
	var k = 0.0
	for e in staff(ci, "guard"): k += stat(e[0], 2) * e[1] * home_mul(e[0], ci)
	var lv = lv_of(ci, "guard")
	return k * lvmul(lv) * mile(lv)
func guard_need(ci: int) -> float: return float(D.THEFT.need) * pow(float(D.THEFT.mapMul), ci)
func theft_rate(ci: int) -> float: return float(D.THEFT.rate) * maxf(0.0, 1.0 - guard_pow(ci) / guard_need(ci))
func yield_of(ci: int) -> Dictionary:   # 全圖每晚產量
	var y = {}; var Y = map_def(ci).yield
	for sid in STALL_IDS:
		for e in staff(ci, sid):
			var gh = e[0]; var k = (1.0 + float(D.GLV_K) * glv(gh)) * home_mul(gh, ci)
			for it in Y: y[it] = float(y.get(it, 0.0)) + float(Y[it]) * k
	return y
func store_cap(ci: int) -> float:
	var lv = lv_of(ci, "store"); var C = D.STORE
	return float(C.base) * (1.0 + float(C.mapMul) * ci) * (1.0 + float(C.perLv) * (lv - 1.0)) * mile(lv)
func front_cap(ci: int, it: String) -> float:
	var u = upkeep(ci)
	return float(u.get(it, 0.0)) * float(D.STOCK_NIGHTS) if u != null else 0.0
func up_cost(ci: int, sid: String) -> Dictionary:
	var lv = lv_of(ci, sid); var U = D.UP; var k = 1.0 + float(U.mapMul) * ci
	return {"planks": round(float(U.planks[0]) * pow(lv, float(U.planks[1])) * k), "coins": round(float(U.coins[0]) * pow(lv, float(U.coins[1])) * k)}
# 連升 n 級嘅總費用（去到 MAX_LV 為止）：{planks, coins, n}
func up_cost_n(ci: int, sid: String, n: int) -> Dictionary:
	var m = ms(ci); var lv0 = lv_of(ci, sid); var o = {"planks": 0.0, "coins": 0.0, "n": 0}
	for i in n:
		if lv0 + i >= float(D.MAX_LV): break
		m.lv[sid] = lv0 + i; var c = up_cost(ci, sid)
		o.planks += c.planks; o.coins += c.coins; o.n += 1
	m.lv[sid] = lv0
	return o
func can_up_n(ci: int, sid: String, n: int) -> bool:
	var c = up_cost_n(ci, sid, n); var R = S().res
	return c.n > 0 and J.num(R.get("planks")) >= c.planks and J.num(R.get("coins")) >= c.coins
# 假設升到 lv 時嘅數值（介面預覽用）：f 係 Callable，喺臨時等級下計
func at_lv(ci: int, sid: String, lv: float, f: Callable):
	var m = ms(ci); var lv0 = lv_of(ci, sid); m.lv[sid] = lv
	var r = f.call(); m.lv[sid] = lv0
	return r
func can_up(ci: int, sid: String) -> bool:
	if lv_of(ci, sid) >= float(D.MAX_LV): return false
	var c = up_cost(ci, sid); var R = S().res
	return J.num(R.get("planks")) >= c.planks and J.num(R.get("coins")) >= c.coins
func upgrade(ci: int, sid: String) -> bool:
	if not can_up(ci, sid): return false
	var c = up_cost(ci, sid); var R = S().res
	R["planks"] = J.num(R.planks) - c.planks; R["coins"] = J.num(R.coins) - c.coins
	var m = ms(ci); m.lv[sid] = lv_of(ci, sid) + 1.0
	var nm = next_mile(m.lv[sid] - 1.0)
	if nm.size() and float(nm[0]) == m.lv[sid]:
		toast(T("<b>%s</b>掛咗新招牌：「%s」！收入再 ×%s", "<b>%s</b>掛上新招牌：「%s」！收入再 ×%s") % [stall_def(sid).name, nm[2], str(nm[1])])
	save(); return true

# ---------------- 車隊 ----------------
func convoy_cap() -> float:
	var C = D.CONVOY; var s = S()
	var tr = minf(J.num(J.gp(s.res, "troops")), float(C.troopMax))
	var c = float(C.base) + float(C.perTroop) * floor(tr)
	if J.t(J.gp(s.get("seen"), str(C.carSeen))): c *= float(C.carMul)
	return c
func pocong() -> bool: return J.t(J.gp(S().get("seen"), str(D.CONVOY.pocongSeen)))
func vcap() -> float:
	var F = J.G.get("F")
	return J.num(J.mc(F, "cap", [])) if F != null else 1e12
func _add_res(it: String, x: float) -> void:
	var R = S().res; var c = vcap(); var v = J.num(R.get(it))
	R[it] = maxf(v, minf(c, v + x)) if it != "coins" else v + x

# 由後方裝貨：want = {buns, planks}；回 {buns, planks}（已由來源扣走）
func _gather(want: Dictionary, capacity: float, fci: int) -> Dictionary:
	var g = st(); var tot = 0.0
	for it in ITEMS: tot += maxf(0.0, float(want.get(it, 0.0)))
	var sc = minf(1.0, capacity / tot) if tot > 0 else 0.0
	var got = {"buns": 0.0, "planks": 0.0}
	for it in ITEMS:
		var need = maxf(0.0, float(want.get(it, 0.0))) * sc
		var src = open_maps(); src.reverse()   # 近前線先
		for ci in src:
			if need <= 0: break
			var stk = ms(ci).stock; var x = minf(need, J.num(stk.get(it)))
			stk[it] = J.num(stk.get(it)) - x; got[it] += x; need -= x
		if need > 0 and J.t(g.get("home")):
			var R = S().res; var x2 = minf(need, J.num(R.get(it)) * float(D.HOME_SHARE))
			R[it] = J.num(R.get(it)) - x2; got[it] += x2; need -= x2
	return got

func _front_sync() -> void:
	var g = st(); var fci = frontline(); var fr = g.front
	if int(J.num(fr.get("ci"))) == fci: return
	var old = int(J.num(fr.get("ci")))
	if old >= 0 and is_open(old):   # 舊前線通關咗：剩低嘅糧入佢分村
		var stk = ms(old).stock
		for it in ITEMS: stk[it] = J.num(stk.get(it)) + J.num(fr.get(it))
	fr["ci"] = float(fci); g["starve"] = 0.0
	var u = upkeep(fci)
	for it in ITEMS: fr[it] = float(u.get(it, 0.0)) * float(D.START_NIGHTS) if u != null else 0.0
	if g.get("convoy") is Dictionary: g.convoy["to"] = float(fci)

func _log(h: String, n: float) -> void:
	var lg = st().log; lg.push_front({"n": n, "h": h})
	while lg.size() > 30: lg.pop_back()

func _msg_depart(load: Dictionary, eta: float, fci: int) -> String:
	var where = map_def(fci).name if fci >= 0 else "落魄村"
	if pocong():
		return T("Pocong 速遞：「交俾我！我跳得好快㗎！……只係要跳三晚。」（壽包 %s、棺材板 %s，送去%s）", "Pocong 速遞：「交給我！我跳得很快的！……只是要跳三晚。」（壽包 %s、棺材板 %s，送去%s）") % [fmt(load.buns), fmt(load.planks), where]
	return T("叮！冥通快遞溫馨提示：親，你嘅補給（壽包 %s、棺材板 %s）已經收件，一晚收貨、一晚排隊蓋印、一晚送貨，預計三個工作夜送達%s，已經係全地府最快嘅服務呢親～", "叮！冥通快遞溫馨提示：親，你的補給（壽包 %s、棺材板 %s）已收件，一晚收貨、一晚排隊蓋章、一晚送貨，預計三個工作夜送達%s，已經是全地府最快的服務了哦親～") % [fmt(load.buns), fmt(load.planks), where]
func _msg_arrive(fci: int) -> String:
	var where = map_def(fci).name if fci >= 0 else "落魄村"
	if pocong(): return T("Pocong 速遞：「到咗%s！跳咗三晚，我冇偷食㗎！」", "Pocong 速遞：「到%s了！跳了三晚，我沒有偷吃！」") % where
	return T("叮！冥通快遞：你嘅補給已經送達%s，記得幫我哋畀五星好評呢親～", "叮！冥通快遞：你的補給已送達%s，記得給我們五星好評哦親～") % where

func _depart(nidx: float, rep) -> void:
	var g = st(); var fci = frontline(); var u = upkeep(fci)
	var load = {"buns": 0.0, "planks": 0.0, "res": {"buns": 0.0, "planks": 0.0}, "eta": nidx + float(D.CONVOY_EVERY), "to": float(fci)}
	if u != null:
		var want = {}
		for it in ITEMS: want[it] = maxf(0.0, front_cap(fci, it) - J.num(g.front.get(it)) + float(u.get(it, 0.0)) * float(D.CONVOY_EVERY))
		var got = _gather(want, convoy_cap(), fci)
		for it in ITEMS: load[it] = got[it]
	var share = float(D.TO_RES) if u != null else float(D.TO_RES_NOFRONT)
	for ci in open_maps():
		var stk = ms(ci).stock
		for it in ITEMS:
			var x = J.num(stk.get(it)) * share; stk[it] = J.num(stk.get(it)) - x; load.res[it] += x
	if load.buns + load.planks + load.res.buns + load.res.planks <= 0.0: g["convoy"] = null; return
	g["convoy"] = load
	var m = _msg_depart(load, load.eta, fci); _log(m, nidx)
	rep.convoys += 1.0
	if rep.get("online", false): toast(m)

func _arrive(nidx: float, rep) -> void:
	var g = st(); var cv = g.get("convoy")
	if not (cv is Dictionary) or nidx < J.num(cv.get("eta")): return
	g["convoy"] = null
	var fci = frontline(); var fr = g.front
	for it in ITEMS:
		var x = J.num(cv.get(it))
		if fci >= 0 and upkeep(fci) != null:
			var room = maxf(0.0, front_cap(fci, it) - J.num(fr.get(it))); var a = minf(room, x)
			fr[it] = J.num(fr.get(it)) + a; x -= a
		_add_res(it, x + J.num(cv.res.get(it)))
		rep.home[it] += x + J.num(cv.res.get(it))
	_recover()
	var m = _msg_arrive(fci); _log(m, nidx)
	rep.arrived += 1.0
	if rep.get("online", false): toast(m)

func _recover() -> void:   # 車一到：前線有一晚糧就即刻恢復
	var g = st(); var fci = frontline(); var u = upkeep(fci)
	if u == null: g["starve"] = 0.0; return
	var ok = true
	for it in ITEMS: if J.num(g.front.get(it)) < float(u.get(it, 0.0)): ok = false
	if ok: g["starve"] = 0.0

func urgent_today() -> bool: return J.num(st().get("urgent")) == J.num(st().get("done"))
func urgent_plan() -> Dictionary:   # 唔扣嘢，只計（介面顯示用）
	var fci = frontline(); var u = upkeep(fci); var g = st()
	var o = {"ok": false, "buns": 0.0, "planks": 0.0, "cost": 0.0, "why": ""}
	if u == null: o.why = T("冇前線要補", "沒有前線要補"); return o
	if urgent_today(): o.why = T("今晚已經叫過", "今晚已經叫過"); return o
	var want = {}; var tot = 0.0
	for it in ITEMS: want[it] = maxf(0.0, front_cap(fci, it) - J.num(g.front.get(it))); tot += want[it]
	var sc = minf(1.0, convoy_cap() / tot) if tot > 0 else 0.0
	for it in ITEMS:
		var need = want[it] * sc; var have = 0.0
		for ci in open_maps(): have += J.num(ms(ci).stock.get(it))
		if J.t(g.get("home")): have += J.num(S().res.get(it)) * float(D.HOME_SHARE)
		o[it] = minf(need, have)
	o.cost = ceil((o.buns + o.planks) * float(D.URGENT.perItem))
	if o.buns + o.planks <= 0: o.why = T("前線糧倉滿晒／後方冇貨", "前線糧倉已滿／後方沒貨"); return o
	if J.num(S().res.get("coins")) < o.cost: o.why = T("冥幣唔夠", "冥幣不夠"); return o
	o.ok = true; return o
func urgent() -> bool:
	var p = urgent_plan()
	if not p.ok: return false
	var g = st(); var fci = frontline(); var want = {}; var tot = 0.0
	for it in ITEMS: want[it] = maxf(0.0, front_cap(fci, it) - J.num(g.front.get(it))); tot += want[it]
	var got = _gather(want, convoy_cap(), fci)
	var cost = ceil((got.buns + got.planks) * float(D.URGENT.perItem))
	S().res["coins"] = J.num(S().res.coins) - cost
	for it in ITEMS: g.front[it] = J.num(g.front.get(it)) + got[it]
	g["urgent"] = J.num(g.get("done"))
	_recover()
	var m = (T("Pocong 急件：「加急？我跳快少少！」即晚送到%s（壽包 %s、棺材板 %s，冥幣 −%s）", "Pocong 急件：「加急？我跳快一點！」當晚送到%s（壽包 %s、棺材板 %s，冥幣 −%s）") if pocong() else T("冥通急件車：加急費收咗，即晚送到%s（壽包 %s、棺材板 %s，冥幣 −%s）", "冥通急件車：加急費已收，當晚送到%s（壽包 %s、棺材板 %s，冥幣 −%s）")) % [map_def(fci).name, fmt(got.buns), fmt(got.planks), fmt(cost)]
	_log(m, J.num(g.get("done"))); toast(m); save(); return true

# ---------------- 實時收入／收銀箱（第二期） ----------------
const INC_IDS := ["bun", "rest"]
func rate_ps(ci: int, sid: String) -> float: return income(ci, sid) / night_ms() * 1000.0   # 每秒收入
func has_mgr(ci: int, sid: String) -> bool:
	var p = ms(ci).posts[sid]
	return p[0] != null and ghost(p[0]) != null
func till_cap(ci: int, sid: String) -> float: return income(ci, sid, false) * float(D.get("TILL", {}).get("nights", 1.0))
func till(ci: int, sid: String) -> float: return J.num(ms(ci).till.get(sid, 0.0))
func till_full(ci: int, sid: String) -> bool:
	if has_mgr(ci, sid): return false
	var c = till_cap(ci, sid)
	return c > 0.0 and till(ci, sid) >= c - 1e-6
func _till_full_any() -> bool:
	for ci in open_maps():
		for sid in INC_IDS: if till_full(ci, sid): return true
	return false
# 累積到 t1（毫秒時間戳）；rep 可以係 null
func _accrue(t1: float, rep) -> void:
	var g = st(); var a0 = J.num(g.acc)
	if t1 <= a0: return
	var dt = t1 - a0; g["acc"] = t1
	var nm = night_ms(); var R = S().res
	for ci in open_maps():
		var m = ms(ci)
		for sid in INC_IDS:
			var inc = income(ci, sid)
			if inc <= 0.0: continue
			var amt = inc * dt / nm
			if has_mgr(ci, sid):
				R["coins"] = J.num(R.coins) + amt
				g.tot["coins"] = J.num(g.tot.get("coins")) + amt
				if rep != null:
					rep.auto += amt; rep.coins += amt; rep.per[str(ci)] = float(rep.per.get(str(ci), 0.0)) + amt
			else:
				var cap = till_cap(ci, sid); var v = J.num(m.till.get(sid, 0.0))
				var add = clampf(cap - v, 0.0, amt)
				m.till[sid] = v + add
				if rep != null: rep.till += add
# 介面用：輕量推進（冇跨晚就唔使 validate／save）
func accrue_live() -> void:
	var g = st(); if g == null: return
	var night = floor((now() - J.num(g.t0)) / night_ms())
	if night > J.num(g.done) or now() < J.num(g.acc): tick()
	else: _accrue(now(), null)
func collect(ci: int, sid: String) -> float:
	var m = ms(ci); var v = J.num(m.till.get(sid, 0.0))
	if v <= 0.0: return 0.0
	m.till[sid] = 0.0
	var R = S().res; R["coins"] = J.num(R.coins) + v
	st().tot["coins"] = J.num(st().tot.get("coins")) + v
	save(); return v

# ---------------- 孤魂騷擾（子時） ----------------
func night_frac() -> float:   # 今晚行到幾多（0–1）
	var g = st(); return fmod(now() - J.num(g.t0), night_ms()) / night_ms()
func raid_time() -> bool: return night_frac() >= float(D.RAID.start)
func thieves_n(ci: int) -> int:
	var r = theft_rate(ci)
	if r <= 0.0: return 0
	return clampi(int(ceil(float(D.RAID.max) * r / float(D.THEFT.rate) - 1e-9)), 1, int(D.RAID.max))
# 今晚（done + 1）嘅騷擾狀態；子時先建立
func raid(ci: int, make := true):
	var m = ms(ci); var n = J.num(st().done) + 1.0; var r = m.get("raid")
	if r is Dictionary and J.num(r.get("n")) == n: return r
	if not make: return null
	r = {"n": n, "tot": float(thieves_n(ci)), "gone": 0.0}
	m["raid"] = r; return r
func raid_share(ci: int, nidx: float) -> float:
	var r = ms(ci).get("raid")
	if not (r is Dictionary) or J.num(r.get("n")) != nidx or J.num(r.get("tot")) <= 0.0: return 1.0
	return maxf(0.0, J.num(r.tot) - J.num(r.gone)) / J.num(r.tot)
func thieves_left(ci: int) -> int:
	var r = raid(ci, false)
	if r == null: return thieves_n(ci)
	return int(maxf(0.0, J.num(r.tot) - J.num(r.gone)))
# 嚇走一隻偷嘢嘅孤魂：回 true＝今晚失竊減少
func raid_scare(ci: int) -> bool:
	var r = raid(ci)
	if J.num(r.gone) >= J.num(r.tot): return false
	r["gone"] = J.num(r.gone) + 1.0; return true
func feed_cost(ci: int) -> float: return round(float(D.RAID.feed) * (1.0 + float(D.RAID.feedMapMul) * ci))
func roster_room() -> bool:
	var F = J.G.get("F"); var fc = J.G.get("fodderCount")
	if F == null or fc == null: return false
	return J.num(J.cl(fc, null, [])) < J.num(J.mc(F, "rosterCap", []))
# 派宵夜：扣壽包、算嚇走一隻；名冊有位就收編（k＝畫面上嗰隻孤魂嘅樣，有喺雜鬼池先用）
# 回 {ok, why, gh(收編咗嘅鬼或 null), slot:[sid, idx] 或 []}
# thief＝false：請嘅係俾守夜攔低嗰啲（本身唔計失竊），只收編
func feed(ci: int, look := "", thief := true) -> Dictionary:
	var o = {"ok": false, "why": "", "gh": null, "slot": []}
	var R = S().res; var c = feed_cost(ci)
	if J.num(R.get("buns")) < c: o.why = T("壽包唔夠", "壽包不夠"); return o
	var r = raid(ci)
	if thief and J.num(r.gone) >= J.num(r.tot): o.why = T("今晚冇孤魂偷嘢", "今晚沒有孤魂偷東西"); return o
	R["buns"] = J.num(R.buns) - c
	if thief: r["gone"] = J.num(r.gone) + 1.0
	o.ok = true
	if roster_room():
		var gh = J.cl(J.G.get("recruitFodder"), null, [false])
		var FO = DB.D.get("FODDER", {})
		if gh is Dictionary and look != "" and FO.has(look):
			var ok_pool = not J.t(FO[look].get("unlock")) or J.t(J.gp(S().get("cleared"), J.str(FO[look].unlock)))
			if ok_pool:
				var nm = J.str(gh.name); var i = nm.find("・")
				gh["k"] = look; gh["name"] = J.str(FO[look].name) + (nm.substr(i) if i >= 0 else "")
		o.gh = gh
		if gh != null:
			for sid in STALL_IDS:
				if o.slot.size(): break
				var p = ms(ci).posts[sid]
				for i2 in range(1, helpers(lv_of(ci, sid)) + 1):
					if p[i2] == null and assign(ci, sid, i2, J.gp(gh, "id")): o.slot = [sid, i2]; break
	save(); return o

# ---------------- 每晚結算 ----------------
func _new_rep() -> Dictionary:
	return {"nights": 0.0, "coins": 0.0, "yield": {"buns": 0.0, "planks": 0.0}, "theft": {"buns": 0.0, "planks": 0.0}, "eat": {"buns": 0.0, "planks": 0.0},
		"home": {"buns": 0.0, "planks": 0.0}, "convoys": 0.0, "arrived": 0.0, "starve": 0.0, "starveMax": 0.0, "per": {}, "auto": 0.0, "till": 0.0}

func night_step(nidx: float, rep: Dictionary) -> void:
	var g = st(); var s = S(); var R = s.res
	_front_sync()
	# 1. 分村：產量、收入、失竊
	for ci in open_maps():
		var stk = ms(ci).stock; var y = yield_of(ci); var cap = store_cap(ci); var per = {"coins": 0.0}
		for it in y:
			if it == "coins": R["coins"] = J.num(R.coins) + y[it]; rep.coins += y[it]; per.coins += y[it]; continue
			var before = J.num(stk.get(it)); stk[it] = minf(maxf(cap, before), before + y[it])
			rep.yield[it] = float(rep.yield.get(it, 0.0)) + (J.num(stk[it]) - before)
		# 檔口收入已經喺 _accrue 實時累積咗，呢度唔再計
		var tr = theft_rate(ci) * raid_share(ci, nidx)
		for it in ITEMS:
			var lost = J.num(stk.get(it)) * tr; stk[it] = J.num(stk.get(it)) - lost; rep.theft[it] += lost
		ms(ci)["raid"] = null
		rep.per[str(ci)] = float(rep.per.get(str(ci), 0.0)) + per.coins
		g.tot["coins"] = J.num(g.tot.get("coins")) + per.coins
	# 2. 車隊：到埋先，再出新一班
	_arrive(nidx, rep)
	if fmod(nidx, float(D.CONVOY_EVERY)) == 0.0 and not (g.get("convoy") is Dictionary): _depart(nidx, rep)
	# 3. 前線食糧
	var fci = frontline(); var u = upkeep(fci)
	if u != null:
		var short = false
		for it in ITEMS:
			var need = float(u.get(it, 0.0)); var have = J.num(g.front.get(it))
			if have + 1e-6 < need: short = true
			var e = minf(have, need); g.front[it] = have - e; rep.eat[it] += e
		var before = int(J.num(g.get("starve")))
		g["starve"] = float(mini(D.STARVE.size(), before + 1)) if short else 0.0
		var after = int(g.starve)
		if after > 0:
			rep.starve += 1.0; rep.starveMax = maxf(rep.starveMax, after)
			if after != before:
				var nm = TA(D.STARVE[after - 1].name)
				var m = T("%s斷糧第 %d 晚：「%s」（分村收入 ×%s）", "%s斷糧第 %d 晚：「%s」（分村收入 ×%s）") % [map_def(fci).name, after, nm, str(D.STARVE[after - 1].inc)]
				_log(m, nidx)
				if rep.get("online", false): toast(m)
	else: g["starve"] = 0.0

# 推進到而家（離線最多 OFFLINE_H 小時）
func tick() -> Dictionary:
	var s = S()
	if s == null or not (s.get("ghosts") is Array) or not (s.get("res") is Dictionary): return {}
	var g = st(); _reg_post(); validate(); _front_sync()
	var nm = night_ms(); var tn = now(); var night = floor((tn - J.num(g.t0)) / nm)
	if night < J.num(g.done): g["t0"] = tn - J.num(g.done) * nm; night = J.num(g.done)   # 時鐘倒退：唔扣返
	if J.num(g.acc) > tn: g["acc"] = tn
	g["acc"] = maxf(J.num(g.acc), tn - float(D.OFFLINE_H) * 3600000.0)   # 離線累積上限
	g["night"] = night
	var todo = night - J.num(g.done)
	if todo <= 0: _accrue(tn, null); return {}
	var maxn = floor(float(D.OFFLINE_H) * 60.0 / float(D.NIGHT_MIN))
	var skip = maxf(0.0, todo - maxn)
	var rep = _new_rep(); rep["skip"] = skip; rep["online"] = todo == 1
	var n = J.num(g.done) + skip
	while n < night:
		n += 1.0; rep.nights += 1.0
		_accrue(J.num(g.t0) + n * nm, rep)   # 先累積到呢晚完（用呢晚嘅斷糧倍數）
		night_step(n, rep)
		g["done"] = n
	_accrue(tn, rep)
	g["done"] = night
	last_rep = rep
	if rep.nights >= 2.0 and not open_maps().is_empty(): _report(rep)
	save()
	return rep

func _report(rep: Dictionary) -> void:
	st()["report"] = rep
	if quiet: return
	var lines = []
	lines.append(["旁白", T("交更簿：你唔喺度嘅 %d 晚（最多計 %d 個鐘），分村照開工。", "交更簿：你不在的 %d 晚（最多計 %d 小時），分村照常開工。") % [int(rep.nights), int(D.OFFLINE_H)]])
	lines.append(["旁白", T("有管事嘅檔自動入賬：冥幣 +%s", "有管事的檔自動入賬：冥幣 +%s") % fmt(rep.auto)])
	if rep.till >= 1.0 or _till_full_any():
		lines.append(["旁白", T("冇管事嘅檔：收銀箱多咗 %s 冥幣%s，要你親手去收。", "沒有管事的檔：收銀箱多了 %s 冥幣%s，要你親手去收。") % [fmt(rep.till), T("（有啲已經滿咗，客人唔肯再嚟）", "（有些已經滿了，客人不肯再來）") if _till_full_any() else ""]])
	if rep.coins - rep.auto >= 1.0:
		lines.append(["旁白", T("駐守產冥幣：+%s", "駐守產冥幣：+%s") % fmt(rep.coins - rep.auto)])
	lines.append(["旁白", T("駐守產量：壽包 +%s、棺材板 +%s", "駐守產量：壽包 +%s、棺材板 +%s") % [fmt(rep.yield.buns), fmt(rep.yield.planks)]])
	if rep.theft.buns + rep.theft.planks >= 1.0:
		lines.append(["旁白", T("守夜擋唔住，俾孤魂偷咗：壽包 %s、棺材板 %s", "守夜沒擋住，被孤魂偷了：壽包 %s、棺材板 %s") % [fmt(rep.theft.buns), fmt(rep.theft.planks)]])
	lines.append(["旁白", T("補給車：出咗 %d 班、到咗 %d 班", "補給車：出了 %d 班、到了 %d 班") % [int(rep.convoys), int(rep.arrived)]])
	if rep.eat.buns + rep.eat.planks >= 1.0:
		lines.append(["旁白", T("前線食咗：壽包 %s、棺材板 %s", "前線吃了：壽包 %s、棺材板 %s") % [fmt(rep.eat.buns), fmt(rep.eat.planks)]])
	if rep.home.buns + rep.home.planks >= 1.0:
		lines.append(["旁白", T("跟車返老家：壽包 +%s、棺材板 +%s", "跟車回老家：壽包 +%s、棺材板 +%s") % [fmt(rep.home.buns), fmt(rep.home.planks)]])
	if rep.starve > 0:
		lines.append(["系統", T("親，前線斷咗 %d 晚糧，最嚴重係「%s」。", "親，前線斷了 %d 晚糧，最嚴重是「%s」。") % [int(rep.starve), TA(D.STARVE[int(rep.starveMax) - 1].name)]])
		lines.append(["系統", T("記得多派啲鬼駐守，或者叫急件車呢～", "記得多派些鬼駐守，或者叫急件車哦～")])
	else: lines.append(["系統", T("親，前線糧草充足，冇斷過糧呢～", "親，前線糧草充足，沒有斷過糧哦～")])
	for l in lines: l[1] = N(l[1])
	var Sy = J.G.get("Story")
	if Sy != null: J.mc(Sy, "queue", [{"style": "sys", "title": "交更簿", "lines": lines}])

func _reg_post() -> void:
	var PO = J.G.get("POSTS")
	if PO is Dictionary and not PO.has("garrison"):
		PO["garrison"] = {"name": "分村駐守", "bld": null, "stat": 2.0, "desc": "派去已通關地圖嘅分村駐守，自動生產補給"}

func _process(dt: float) -> void:
	_acc += dt
	if _acc < float(D.get("TICK_SEC", 5)): return
	_acc = 0.0
	if S() == null: return
	tick()
	if panel != null and is_instance_valid(panel) and panel.visible: panel.refresh_live()
	if scene != null and is_instance_valid(scene) and scene.visible: scene.refresh_live()

# ---------------- 面板／場景 ----------------
var scene = null
func _host() -> Node:
	var main = get_tree().root.get_node_or_null("Main")
	return main if main != null else get_tree().root
func _below_story(n: Node) -> void:
	var main = get_tree().root.get_node_or_null("Main")
	if main == null: return
	var sto = main.get("story")
	if sto is Node and sto.get_parent() == main: main.move_child(n, sto.get_index())
# 打開分村全屏經營場景（第二期）
func open(ci: int) -> void:
	if S() == null: return
	tick()
	if scene == null or not is_instance_valid(scene):
		scene = load("res://game/garrison/gr_scene.gd").new(); scene.name = "GarrisonScene"; _host().add_child(scene)
	_below_story(scene)
	if not is_open(ci):
		var om = open_maps(); ci = om[0] if om.size() else -1
	scene.show_map(ci)
# 舊數字面板（場景入面「補給／詳細」）
func open_panel(ci: int) -> void:
	if S() == null: return
	tick()
	if panel == null or not is_instance_valid(panel):
		panel = load("res://game/garrison/gr_panel.gd").new(); panel.name = "GarrisonPanel"; _host().add_child(panel)
	_below_story(panel)
	if scene != null and is_instance_valid(scene) and scene.get_parent() == panel.get_parent() and scene.get_index() > panel.get_index():
		panel.get_parent().move_child(panel, scene.get_index())   # 舊面板疊喺場景上面
	if not is_open(ci):
		var om = open_maps(); ci = om[0] if om.size() else -1
	panel.show_map(ci)
func close() -> void:
	if panel != null and is_instance_valid(panel): panel.close()
	if scene != null and is_instance_valid(scene): scene.close()
