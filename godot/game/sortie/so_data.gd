# [sortie] 野外出擊：據點、等級、出擊消耗、普通／首勝／極稀有（保底）、已清空／重生（全部 static；冇 class_name、冇 autoload）
#   const SO = preload("res://game/sortie/so_data.gd")
#   設計稿：/home/claude/docs/sortie_design.md
#   打法沿用 rts 線（rts.gd／rts_sim.gd）：借 Battle.start 生成單位 → 地圖模擬 → Battle.finish 結算（只計「再打」獎，唔推主線）→ 本檔加出擊獎勵。
#   存檔：S.sortie = {v:1, camps:{"c:id": {first, wins, tries, pity, rare, clr}}, n}
extends RefCounted

const ZD = preload("res://game/zone/zone_data.gd")
const M = preload("res://game/outpost/mat.gd")

# ======================= 常數表（測試員試玩後只改呢度） =======================
const LV_BASE := [1.0, 5.0, 9.0, 13.0, 17.0, 21.0]   # fallback：每關第 1 圈等級（＝主線 x-1 難度）
const LV_RING := [0.0, 1.0, 2.5, 4.0]                # fallback：第 1～4 圈加幾級
const ENEMY_N := [3, 4, 5, 5]                        # 每圈敵人隻數（第 4 圈最後一隻係頭目）
const BOSS_HP := 1.6                                 # 第 4 圈頭目血 ×
const RING_NAME := [["近郊", "近郊"], ["荒野", "荒野"], ["深處", "深處"], ["絕地", "絕地"]]
# 出擊消耗
const COST_YIN_BUNS := [3, 4, 6, 8]                  # 每隊陰兵：壽包（第 1～4 圈）
const COST_ML_COIN := 2.0                            # 每隊遊魂兵：冥幣 × lv（車馬費）
const COST_HERO_COIN := 6.0                          # 每隻名鬼：冥幣 × lv（出差津貼）
# 獎勵（Battle.finish 另外照舊俾「再打」獎：冥幣 20×lv、好評 8×lv）
const REW_COIN := 30.0                               # 普通：冥幣 × lv
const REW_PLANK := [4, 8, 14, 20]                    # 普通：棺材板
const FIRST_CHEST := [["g"], ["b"], ["p"], ["p", "p"]]   # 首勝：寶箱
const FIRST_COIN := 100.0                            # 首勝：冥幣 × lv
const RARE_P := [0.03, 0.04, 0.05, 0.06]             # 極稀有概率（每次打贏擲一次）
const RARE_PITY := [40, 35, 30, 25]                  # 保底：第 N 次打贏仍未掉＝必掉
const RARE := [                                      # 極稀有內容（本作已有物品）
	[{"k": "tix", "id": "inc", "n": 1}],
	[{"k": "tix", "id": "spd", "n": 2}, {"k": "tix", "id": "inc", "n": 1}],
	[{"k": "gear", "n": 1}],
	[{"k": "gear", "n": 1}, {"k": "chest", "id": "p", "n": 2}],
]
const RESPAWN_MIN := [5.0, 10.0, 20.0, 40.0]         # 已清空 → 幾多分鐘後重生（真實時間）
const NAMED := ["eguiking", "toyol", "laojiang", "pontianak", "pocong", "penanggal", "huang", "baiwu", "heiwu"]   # 主線名角（唔放入據點）

static var test_now := -1.0
static var rng := RandomNumberGenerator.new()
static var LOG: Array = []
static var force_open := false    # 測試：唔理解霧

static func S():
	var s = J.G.get("S")
	return s if s is Dictionary and not s.is_empty() else null
static func L(yue: String, zhs: String) -> String: return str(DB.N(ZD.L(yue, zhs)))
static func now_ms() -> float: return test_now if test_now >= 0 else Time.get_unix_time_from_system() * 1000.0
static func ri(ring: int) -> int: return clampi(ring, 1, 4) - 1

# ======================= 據點 =======================
# zones.json 每關 sorties [{id, ring, lv, pos}]；冇就 fallback（每關兩個野外區各放兩個）
static func camps(c := -1) -> Array:
	if c < 0: c = ZD.ci()
	var m = ZD.mdef(c)
	var o = []
	var src = m.get("sorties")
	if src is Array and src.size():
		for e in src:
			if not (e is Dictionary) or not e.has("pos"): continue
			var r = clampi(int(J.num(e.get("ring", 1))), 1, 4)
			# [integ] mapx 嘅 lv 係「每關 Lv1–62 顯示等級」；戰鬥難度要用主線同一把尺：每關基準＋圈加成＋圈內次序（0～0.8）
			var mlv = J.num(e.get("lv", 0)); var rmin = c * 10 + 1 + (r - 1) * 3
			var p = LV_BASE[clampi(c, 0, 5)] + LV_RING[r - 1] + clampf(mlv - rmin, 0.0, 2.0) * 0.4
			o.append({"id": str(e.get("id", "s%d" % o.size())), "ring": r, "lv": p, "pos": ZD.v2(e.pos), "c": c})
		return o
	return fallback(c)
static func fallback(c: int) -> Array:
	var wz = ZD.of_type("wild", c)
	if wz.is_empty(): return []
	var mk = ZD.zrect("market", c).get_center()
	var pts = []   # [離村距離, 位置]
	for z in wz:
		var r = ZD.rect(z.rect)
		var ba = ZD.v2(z.get("boss_at", [-9999, -9999]))
		var near_y = r.end.y - 130.0 if mk.y > r.get_center().y else r.position.y + 130.0
		var far_y = r.position.y + 90.0 if mk.y > r.get_center().y else r.end.y - 90.0
		if r.size.x < r.size.y * 0.9:   # 豎長嘅區（左右兩邊）：近＝向住市集嗰邊
			near_y = r.get_center().y + (r.size.y * 0.3 if mk.y > r.get_center().y else -r.size.y * 0.3)
			far_y = r.get_center().y - (r.size.y * 0.3 if mk.y > r.get_center().y else -r.size.y * 0.3)
		for y in [near_y, far_y]:
			var x = r.get_center().x
			if absf(x - ba.x) < 140.0 and absf(y - ba.y) < 140.0: x = ba.x + (150.0 if ba.x < r.get_center().x + 1 else -150.0)
			x = clampf(x, r.position.x + 60.0, r.end.x - 60.0)
			var p = Vector2(x, y)
			pts.append([p.distance_to(mk), p])
	pts.sort_custom(func(a, b): return a[0] < b[0])
	var o = []
	for i in mini(4, pts.size()):
		var r = i + 1
		o.append({"id": "tmp%d" % r, "ring": r, "lv": LV_BASE[clampi(c, 0, 5)] + LV_RING[r - 1], "pos": pts[i][1], "c": c, "tmp": true})
	return o
static func camp(id: String, c := -1) -> Dictionary:
	for e in camps(c): if str(e.id) == id: return e
	return {}
static func key(e: Dictionary) -> String: return "%d:%s" % [int(e.c), str(e.id)]
static func sid_of(e: Dictionary) -> String: return "出擊·" + key(e)
static func short(e: Dictionary) -> String: return "Lv.%d %s" % [int(e.lv), ZD.T(RING_NAME[ri(e.ring)])]
static func title(e: Dictionary) -> String: return L("Lv.%d　%s據點", "Lv.%d　%s據點") % [int(e.lv), ZD.T(RING_NAME[ri(e.ring)])]

# ======================= 存檔 =======================
static func st():
	var s = S()
	if s == null: return null
	if not (s.get("sortie") is Dictionary): s["sortie"] = {"v": 1.0, "camps": {}, "n": 0.0}   # 舊存檔：自動補
	var o = s.sortie
	if not (o.get("camps") is Dictionary): o["camps"] = {}
	return o
static func cst(e: Dictionary) -> Dictionary:
	var o = st()
	if o == null: return {}
	var k = key(e)
	if not (o.camps.get(k) is Dictionary): o.camps[k] = {"first": false, "wins": 0.0, "tries": 0.0, "pity": 0.0, "rare": 0.0, "clr": 0.0}
	var d = o.camps[k]
	for f in ["wins", "tries", "pity", "rare", "clr"]: if d.get(f) == null: d[f] = 0.0
	if d.get("first") == null: d["first"] = false
	return d

# ======================= 狀態 =======================
static func ring_open(ring: int, c := -1) -> bool:
	if c < 0: c = ZD.ci()
	if ring <= 1: return force_open or ZD.wild_open(c)
	if ZD.rings(c).size() > 0: return force_open or ZD.ring_open(ring, c)   # [integ] 有 mapx 分圈就以 mapx 為準
	for e in camps(c):
		if int(e.ring) == ring - 1 and J.t(cst(e).get("first")): return true
	return false
static func cleared_left_s(e: Dictionary) -> float:   # 已清空仲有幾多秒重生（0＝冇清空）
	var t = J.num(cst(e).get("clr", 0))
	return maxf(0.0, (t - now_ms()) / 1000.0)
static func state(e: Dictionary) -> String:   # "open"／"cleared"／"locked"／"out"（出擊中）
	if not ring_open(int(e.ring), int(e.c)): return "locked"
	if cleared_left_s(e) > 0: return "cleared"
	var RTS = _rts()
	if RTS.op_for(sid_of(e)) != null: return "out"
	return "open"
static func _rts(): return load("res://game/rts/rts.gd")

# ======================= 陣容／消耗 =======================
static func lineup() -> Dictionary:   # 同 Battle.start 一樣嘅算法
	var s = S()
	var h = 0
	if s != null:
		var ids = {}
		for g in J.iter(s.get("ghosts")): ids[J.str(g.get("id"))] = true
		for x in J.iter(s.get("team")): if J.t(x) and ids.has(J.str(x)): h += 1
	var yin = mini(8, int(floor(float(load("res://game/barracks/bk_data.gd").standby()) / 25)))
	var ML = load("res://game/militia/ml_data.gd")
	var ml = ML.squads().size() if ML.on() else 0
	return {"hero": h, "yin": yin, "ml": ml}
static func cost(e: Dictionary, lu = null) -> Dictionary:
	if lu == null: lu = lineup()
	var lv = float(e.lv)
	return {"buns": float(lu.yin * COST_YIN_BUNS[ri(e.ring)]), "coins": round(lu.ml * COST_ML_COIN * lv + lu.hero * COST_HERO_COIN * lv)}
static func have(k: String) -> float:
	var s = S()
	return J.num((s.res as Dictionary).get(k, 0)) if s != null and s.get("res") is Dictionary else 0.0
static func afford(cs: Dictionary) -> bool:
	for k in cs: if have(k) < float(cs[k]) - 1e-6: return false
	return true
static func pay(cs: Dictionary, sign := -1.0) -> void:
	var s = S()
	for k in cs: s.res[k] = maxf(0.0, have(k) + sign * float(cs[k]))
static func res_name(k: String) -> String: return {"buns": L("壽包", "壽包"), "coins": L("冥幣", "冥幣")}.get(k, k)
static func cost_text(cs: Dictionary) -> String:
	var o = []
	for k in ["buns", "coins"]: if float(cs.get(k, 0)) > 0: o.append("%s %d" % [res_name(k), int(cs[k])])
	return "　".join(o) if o.size() else L("免費", "免費")

# ======================= 敵人 =======================
static func stage_of(e: Dictionary) -> Dictionary:
	var c = int(e.c); var r = ri(e.ring)
	var CH = J.G.get("CHAPTERS")
	var pool = []; var bg = "field"
	if CH is Array and c < CH.size():
		bg = str(CH[c].get("bg", "field"))
		var sts = CH[c].stages
		var si = mini(r, sts.size() - 1)
		for k in sts[si].en: if not (str(k) in NAMED): pool.append(str(k))
		if pool.is_empty():
			for s0 in sts:
				for k in s0.en: if not (str(k) in NAMED): pool.append(str(k))
	if pool.is_empty(): pool = ["youhun"]
	var ET = J.G.get("ENEMY_T")
	var en = []
	var h = abs(hash(str(e.id)))
	for i in ENEMY_N[r]:
		var k = pool[(i + h) % pool.size()]
		en.append(k if not (ET is Dictionary) or ET.has(k) else "youhun")
	return {"name": title(e), "en": en, "boss": "", "p": float(e.lv), "sortie": true, "bg": bg}

# ======================= 出擊 =======================
# 回 "ok"／"locked"／"cleared"／"busy"／"noteam"／"poor"／"nobattle"
static func dispatch(e: Dictionary) -> String:
	var RTS = _rts()
	var s0 = state(e)
	if s0 == "out": return "ok"
	if s0 != "open": return s0
	var B = J.G.get("Battle")
	if not (B is Dictionary): return "nobattle"
	if not ZD.team_ok(): return "noteam"
	if RTS.busy() or J.t(B.get("active")): return "busy"
	var lu = lineup()
	var cs = cost(e, lu)
	if not afford(cs): return "poor"
	var stg = stage_of(e)
	stg = load("res://game/soul/soul_data.gd").guard_stage(e, stg)   # [soul] 駐守名鬼做頭目
	var sid = sid_of(e)
	var wild = {"stage": stg, "bg": stg.bg, "sid": sid, "sortie": true}
	var snap = RTS._start_battle(func(): J.mc(B, "start", [-1.0, -1.0, wild]))
	if snap.is_empty(): return "nobattle"
	if int(e.ring) >= 4:   # 第 4 圈：最後一隻做頭目
		var last = null
		for u in snap.units: if J.num(u.side) == 1 and not J.t(u.get("minion")): last = u
		if last != null:
			var gk = str(stg.get("guard", ""))   # [soul] 駐守名鬼：血 ×1.25（ENEMY_T 已有品級倍率）、名牌顯示鬼名
			last["boss"] = true; last["hp"] = J.num(last.hp) * (1.25 if gk != "" else BOSS_HP); last["maxhp"] = last.hp; last["name"] = L("惡鬼頭目", "惡鬼頭目") if gk == "" else str(last.get("name", gk))
	pay(cs)
	var c = cst(e); c["tries"] = J.num(c.tries) + 1
	var op = RTS.SIM.new()
	op.id = RTS._next_id; RTS._next_id += 1
	op.kind = "sortie"; op.sid = sid
	op.title = title(e)
	op.adviser = snap.get("adviser")
	op.set_meta("snap", snap); op.set_meta("camp", e); op.set_meta("cost", cs)
	var at: Vector2 = e.pos
	op.setup(snap.units, path_of(e, at), at, RTS.gate_pos())
	RTS.ops.append(op)
	LOG.append(["dispatch", key(e), cs, lu])
	var m = RTS._main()
	var nv = m.get("village") if m != null else null
	if nv != null and nv.has_method("zone_cam"):
		var cam = nv.zone_cam()
		if not cam.rect().grow(-60).has_point(op.path[0]): cam.glide_to(op.path[0].lerp(op.path[1], 0.5))
	Snd.play("click")
	return "ok"

# 行軍中叫回（未開打）：糧食帶返嚟，退回消耗（只退一次）
static func refund(op) -> void:
	if op.has_meta("refunded"): return
	op.set_meta("refunded", true)
	pay(op.get_meta("cost"), 1.0)
	LOG.append(["refund", key(op.get_meta("camp"))])
# ======================= 結算（rts.gd _settle 掛鈎） =======================
static func settle(op) -> bool:
	var RTS = _rts()
	var e: Dictionary = op.get_meta("camp")
	var r = op.result
	if r == null: return false
	if J.t(r.get("none")): refund(op); return true
	var B = J.G.get("Battle")
	if not (B is Dictionary): return true
	if J.t(B.get("active")): return false
	var s = S()
	if not (s.get("cleared") is Dictionary): s["cleared"] = {}
	var sid = op.sid
	s.cleared[sid] = true   # 當「再打」：Battle 只俾再打獎、唔開箱、唔推主線；之後清返
	var snap: Dictionary = op.get_meta("snap")
	for k in snap: B[k] = snap[k]
	B["units"] = op.units; B["result"] = null; B["coinsWon"] = op.coins_won; B["t"] = op.t; B["proj"] = []; B["fx"] = []
	B["advCast"] = null; B["comboCast"] = null; B["active"] = true
	J.mc(B, "finish", [r.win, r.quit, r.timeout])
	var f = J.G.get("$")
	var box = J.cl(f, null, ["#b-result"]) if f != null else null
	var rep = RTS._report(J.str(J.gp(box, "innerHTML")) if box != null else "")
	var okb = J.cl(f, null, ["#b-ok"]) if f != null else null
	if okb != null and J.gp(okb, "onclick") != null: J.cl(J.gp(okb, "onclick"), okb, [])
	B["active"] = false
	if box != null: J.mc(J.gp(box, "classList"), "remove", ["on"])
	s.cleared.erase(sid)
	rep["win"] = r.win; rep["sid"] = sid; rep["sortie"] = true
	if r.win:
		var g = reward(e)
		rep["first"] = g.first
		rep["head"] = L("首勝！", "首勝！") + title(e) if g.first else L("勝利　%s", "勝利　%s") % title(e)
		rep["full"] = "，".join([str(rep.get("reward", ""))] + g.lines)
		rep["reward"] = L("冥幣 +%d　好評 +%d　棺材板 +%d", "冥幣 +%d　好評 +%d　棺材板 +%d") % [int(g.coin + 20.0 * float(e.lv)), int(8.0 * float(e.lv)), REW_PLANK[ri(e.ring)]]
		var extra = []
		if g.first_txt != "": extra.append(g.first_txt)
		if g.rare != "": extra.append(L("極稀有！", "極稀有！") + g.rare)
		rep["lost"] = extra + rep.lost
		if g.rare != "": rep["rare"] = g.rare
		var sl = load("res://game/soul/soul_data.gd").on_sortie_win(e, g.first)   # [soul] 戰後掉魂魄：戰報加一行
		if str(sl.line) != "": rep["soul"] = sl.line; rep["soul_ready"] = sl.ready; rep["lost"].append(sl.line)
		var ex = J.G.get("save")
		if ex != null: J.cl(ex, null, [])
	op.set_meta("report", rep)
	RTS.last_report = rep
	LOG.append(["settle", key(e), r.win, rep])
	var lines = [rep.head]
	if str(rep.get("full", rep.get("reward", ""))) != "": lines.append(str(rep.get("full", rep.get("reward", ""))))
	for x in rep.lost: if not str(rep.get("full", "")).contains(str(x)): lines.append(x)
	RTS.toast("　".join(lines))
	return true

# 打贏：普通＋首勝＋極稀有；清空據點。回 {first, rare, lines}
static func reward(e: Dictionary) -> Dictionary:
	var c = cst(e); var r = ri(e.ring); var lv = float(e.lv)
	var out = {"first": false, "rare": "", "lines": [], "coin": REW_COIN * lv, "first_txt": ""}
	var s = S()
	# 普通
	s.res["coins"] = have("coins") + REW_COIN * lv
	s.res["planks"] = have("planks") + REW_PLANK[r]
	out.lines.append(L("出擊獎：冥幣 +%d，棺材板 +%d", "出擊獎：冥幣 +%d，棺材板 +%d") % [int(REW_COIN * lv), REW_PLANK[r]])
	# 首勝
	if not J.t(c.get("first")):
		c["first"] = true; out.first = true
		if not e.get("tmp", false): ZD.sortie_won(str(e.id))   # [integ] mapx：關鍵據點首勝開下一圈（散霧）
		var cn = {}
		for k in FIRST_CHEST[r]: cn[k] = int(cn.get(k, 0)) + 1
		if not (s.get("chests") is Dictionary): s["chests"] = {"g": 0, "b": 0, "p": 0}
		var parts = []
		for k in cn:
			s.chests[k] = int(J.num(s.chests.get(k, 0))) + cn[k]
			parts.append("%s ×%d" % [{"g": L("綠箱", "綠箱"), "b": L("藍箱", "藍箱"), "p": L("紫箱", "紫箱")}[k], cn[k]])
		s.res["coins"] = have("coins") + FIRST_COIN * lv
		out.coin += FIRST_COIN * lv
		out.first_txt = L("首勝獎：%s", "首勝獎：%s") % "，".join(parts)
		out.lines.append(L("首勝獎：%s，冥幣 +%d", "首勝獎：%s，冥幣 +%d") % ["，".join(parts), int(FIRST_COIN * lv)])
	# 極稀有（保底）
	c["wins"] = J.num(c.wins) + 1
	if roll_rare(c, r):
		out.rare = give_rare(r)
		out.lines.append(L("極稀有！", "極稀有！") + out.rare)
	# 清空 → 重生
	c["clr"] = now_ms() + RESPAWN_MIN[r] * 60000.0
	var o = st(); o["n"] = J.num(o.get("n", 0)) + 1
	return out
# 擲極稀有：回 true＝掉；保底計數喺 c.pity
static func roll_rare(c: Dictionary, r: int, pity_on := true) -> bool:
	var hit = rng.randf() < RARE_P[r]
	if pity_on and J.num(c.get("pity", 0)) + 1 >= RARE_PITY[r]: hit = true
	if hit: c["pity"] = 0.0; c["rare"] = J.num(c.get("rare", 0)) + 1
	else: c["pity"] = J.num(c.get("pity", 0)) + 1
	return hit
static func pity_left(e: Dictionary) -> int: return maxi(1, RARE_PITY[ri(e.ring)] - int(J.num(cst(e).get("pity", 0))))
static func rare_text(r: int) -> String:
	var o = []
	for x in RARE[r]:
		match str(x.k):
			"tix": o.append("%s ×%d" % [L("收益×2卡", "收益×2卡") if x.id == "inc" else L("加速卡", "加速卡"), int(x.n)])
			"gear": o.append(L("紙紮裝備（大）×%d", "紙紮裝備（大）×%d") % int(x.n))
			"chest": o.append(L("紫箱 ×%d", "紫箱 ×%d") % int(x.n))
	return "，".join(o)
static func give_rare(r: int) -> String:
	var JO = load("res://game/joss/joss.gd")
	var s = S()
	var o = []
	for x in RARE[r]:
		match str(x.k):
			"tix":
				var j = JO.st()
				if j != null: j.tix[x.id] = J.num(j.tix.get(x.id, 0)) + x.n
			"gear":
				for i in int(x.n):
					var g = JO.give_gear(["wea", "arm", "acc"][rng.randi() % 3], true)
					if g.has("name"): o.append(str(g.name))
			"chest":
				if not (s.get("chests") is Dictionary): s["chests"] = {"g": 0, "b": 0, "p": 0}
				s.chests[x.id] = int(J.num(s.chests.get(x.id, 0))) + int(x.n)
	var t = rare_text(r)
	return t + ("（%s）" % "、".join(o) if o.size() else "")

# [integ] 行軍路線：mapx 有 route 就沿 route 行，否則用主線路線
static func path_of(e: Dictionary, at: Vector2) -> PackedVector2Array:
	var z = ZD.sortie(str(e.get("id", "")))
	var r = z.get("route")
	if r is Array and r.size() >= 2:
		var o = PackedVector2Array()
		for p in r: o.append(ZD.v2(p))
		if o[o.size() - 1].distance_to(at) > 4.0: o.append(at)
		return o
	return _rts().stage_path(at)
