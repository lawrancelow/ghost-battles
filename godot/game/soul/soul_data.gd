# [soul] 魂魄（碎片）招降＋祭壇招降／升職（全部 static；冇 class_name、冇 autoload：熱更新規矩）
#   const SOUL = preload("res://game/soul/soul_data.gd")   或   load(...)（其他檔用 load，免循環 preload）
#   設計稿：/home/claude/bs/soul.md（第 2–4 節品級、掉落、祭壇；第 6 節舊存檔；第 8 節接口）
#   數據：data/nat/soul.json（tools/soul/soul_build.py 產生）：PIN 品級、CAMP 據點駐守臨時表、WISH 心願供品、STORY_JOIN
#   據點駐守鬼：data/nat/counter.json 有 guard 就用（cdata 線），否則用 soul.json CAMP 臨時表
#   存檔：S.soul = {v, mig, sh{k:n}, san, rk{k:0-5}, seen{k:1}, got{k:1}, sec{"c:id":n}, fr{day, n{"c:id":n}}, dir{k:1}, log[]}
#   品級用新欄位（soul.json PIN），**唔郁 g.q**（q 永遠係「名」）。
extends RefCounted

const PATH := "res://data/nat/soul.json"
const CT_PATH := "res://data/nat/counter.json"

# ======================= 常數表（測試員試玩後只改呢度＋soul.json） =======================
const PINS := ["凡", "靈", "煞", "王"]
const PV := {"凡": 1, "靈": 2, "煞": 3, "王": 4}                 # 品值（散魂、冥幣倍數）
const SUMMON := {"凡": 30, "靈": 60, "煞": 90, "王": 120}        # 招降要幾多本鬼魂魄
const SUMMON_COIN := 80.0                                        # 招降冥幣 = 80 × 品值 × (章+1)
const WISH_N := 20.0                                             # 心願供品 = 20 × 品值 × (章+1)
const SAN_SUB_MAX := 0.5                                         # 招降：散魂最多頂一半魂魄
const SAN_BUY := 2                                               # 頂 1 隻魂魄要 品值 × 2 散魂（來回蝕一半）
const ALTAR_PIN := {"凡": 1, "靈": 2, "煞": 3, "王": 4}          # 招降要祭壇等級
const RANK_NAME := [["試用", "試用"], ["正式", "正式"], ["主任", "主任"], ["經理", "經理"], ["總監", "總監"], ["合夥人", "合夥人"]]
const RANK_MAX := 5
const RANK_COST := {"凡": [5, 10, 20, 30, 45], "靈": [10, 15, 25, 40, 55], "煞": [10, 20, 30, 45, 70], "王": [15, 25, 40, 60, 80]}   # 升到第 1..5 級要幾多魂魄
const RANK_COIN := [50.0, 200.0, 450.0, 800.0, 1250.0]           # 升到第 1..5 級冥幣（× 品值）
const ALTAR_RANK := [0, 2, 3, 4, 5, 6]                           # 升到第 r 級要祭壇等級
const STAT_PCT := {"凡": 0.05, "靈": 0.04, "煞": 0.04, "王": 0.04}   # 每職級三圍 +%（合夥人合計：凡 +25%、其餘 +20%；FIXES_review1 第 16 項：防練幾隻就通關）
const CAP_PER_RANK := 2                                          # 每職級等級上限 +2（最多 +10）
const PRI := [3, 4, 5, 6]                                        # 每次打贏主魂（第 1～4 圈）
const PRI_BONUS_P := 0.30                                        # 30% 多 1 隻
const GOOD_BONUS := 1                                            # 「打得好」：用到 ≥1 個正確應對（克制或機制）主魂 +1
const RANK_SUB_MAX := 0.5                                        # 升職：散魂最多頂每級消耗嘅一半
const FIRST := [10, 8, 6, 6]                                     # 首勝見面禮（主魂）
const SEC_P := 0.25                                              # 副魂機會
const SEC_N := 2                                                 # 副魂隻數
const SEC_PITY := 4                                              # 連續 3 次冇 → 第 4 次必掉
const SAN := [1, 1, 2, 2]                                        # 每次打贏散魂（第 1～4 圈）
const FRESH := [1.0, 1.0, 0.5, 0.25]                             # 怨氣：當日第 1、2、3、4+ 次贏嘅魂魄倍率
const RESET_H := 5                                               # 每日 05:00（本地時間）重置怨氣
const KING_FIRST := 15                                           # 野外王（非劇情）首殺：該王魂魄
const STAGE_SAN := 10                                            # 主線關卡首通：散魂
const RAID_SAN := {"auto": 1, "fight": 3}                        # 惡鬼襲擾：自動擊退／親自迎戰
const DIRECT_OWNED := 10                                         # 舊直接加入途徑：已擁有就送 10 隻
const MIG_RANK := [[30.0, 3], [20.0, 2], [10.0, 1]]              # 舊存檔：等級 ≥30 經理、≥20 主任、≥10 正式
const DISMANTLE_PER_LV := 0.02                                   # 祭壇每級分解 +2% 散魂
const WRAP_JOIN := true                                          # 舊直接加入途徑（非劇情）改送魂魄
const SCALE := 1.0                                               # 測試員旋鈕：招降數 ×

static var test_now := -1.0
static var rng := RandomNumberGenerator.new()
static var LOG: Array = []
static var _D = null
static var _CT = null
static var _bypass := false       # 祭壇招降自己叫 joinGhost：唔好被 wrap_join 攔
static var pending_toast := ""    # 遷移總結：等介面得閒先出

static func L(yue: String, zhs: String) -> String: return str(DB.N(zhs if DB.lang != "yue" else yue))
static func T(a) -> String:
	if a is Array and a.size() >= 2: return L(str(a[0]), str(a[1]))
	return str(a) if a != null else ""
static func S():
	var s = J.G.get("S")
	return s if s is Dictionary and not s.is_empty() else null
static func now_ms() -> float: return test_now if test_now >= 0 else Time.get_unix_time_from_system() * 1000.0
static func ri(ring) -> int: return clampi(int(J.num(ring)), 1, 4) - 1

# ======================= 數據 =======================
static func D() -> Dictionary:
	if _D == null:
		var f = FileAccess.open(PATH, FileAccess.READ)
		var o = JSON.parse_string(f.get_as_text()) if f != null else null
		_D = o if o is Dictionary else {}
		for k in ["PIN", "CAMP", "WISH", "STORY_CH"]: if not (_D.get(k) is Dictionary): _D[k] = {}
		if not (_D.get("STORY_JOIN") is Array): _D["STORY_JOIN"] = ["afu"]
	return _D
static func CT() -> Dictionary:   # cdata 線 counter.json（未合併就係 {}）
	if _CT == null:
		_CT = {}
		if FileAccess.file_exists(CT_PATH):
			var f = FileAccess.open(CT_PATH, FileAccess.READ)
			var o = JSON.parse_string(f.get_as_text()) if f != null else null
			if o is Dictionary: _CT = o
	return _CT
static func reload() -> void: _D = null; _CT = null
static func GH() -> Dictionary:
	var g = J.G.get("GHOSTS")
	return g if g is Dictionary else {}
static func is_ghost(k: String) -> bool: return k != "" and k != "afu" and GH().has(k)
static func gname(k: String) -> String:
	var d = GH().get(k)
	return str(DB.N(str(d.get("name", k)))) if d is Dictionary else k
static func pin(k: String) -> String:
	var p = str(D().PIN.get(k, ""))
	if p in PINS: return p
	var ct = CT().get("ghost", {})   # 新鬼：counter／名冊線可加 pin
	if ct is Dictionary and ct.get(k) is Dictionary and str(ct[k].get("pin", "")) in PINS: return str(ct[k].pin)
	return "凡"
static func pv(k: String) -> int: return int(PV[pin(k)])
static func story(k: String) -> bool: return k in D().STORY_JOIN
static func unsummonable(k: String) -> bool:   # 大魔王：counter.json boss／黃總
	return k == "huang" or k.begins_with("bm_")

# ======================= 存檔 =======================
static func st():
	var s = S()
	if s == null: return null
	if not (s.get("soul") is Dictionary): s["soul"] = {"v": 1.0, "mig": 0.0}
	var o = s.soul
	for k in ["sh", "rk", "seen", "got", "sec", "dir"]: if not (o.get(k) is Dictionary): o[k] = {}
	if not (o.get("fr") is Dictionary): o["fr"] = {"day": -1.0, "n": {}}
	if not (o.fr.get("n") is Dictionary): o.fr["n"] = {}
	if o.get("san") == null: o["san"] = 0.0
	if int(J.num(o.get("mig", 0))) < 1: migrate(s, o)
	return o
static func souls(k: String) -> int:
	var o = st()
	return int(J.num(o.sh.get(k, 0))) if o != null else 0
static func san() -> int:
	var o = st()
	return int(J.num(o.san)) if o != null else 0
static func rank(k: String) -> int:
	var o = st()
	return clampi(int(J.num(o.rk.get(k, 0))), 0, RANK_MAX) if o != null else 0
static func rank_name(r: int) -> String: return T(RANK_NAME[clampi(r, 0, RANK_MAX)])
static func seen(k: String) -> bool:
	var o = st()
	return o != null and (J.t(o.seen.get(k)) or owned(k) or J.num(o.sh.get(k, 0)) > 0)
static func owned(k: String) -> bool:
	var s = S()
	if s == null: return false
	for g in J.iter(s.get("ghosts")): if J.str(g.get("k")) == k: return true
	return false
static func ghost(k: String):
	var s = S()
	if s == null: return null
	for g in J.iter(s.get("ghosts")): if J.str(g.get("k")) == k: return g
	return null

# ======================= 日子／怨氣 =======================
static func day_of(ms: float) -> int:
	var bias = 0.0
	var tz = Time.get_time_zone_from_system()
	if tz is Dictionary: bias = float(tz.get("bias", 0))
	var local_s = ms / 1000.0 + bias * 60.0 - RESET_H * 3600.0
	return int(floor(local_s / 86400.0))
static func today() -> int: return day_of(now_ms())
static func _fr() -> Dictionary:
	var o = st()
	if int(J.num(o.fr.get("day", -1))) != today(): o["fr"] = {"day": float(today()), "n": {}}
	return o.fr
static func wins_today(key: String) -> int: return int(J.num(_fr().n.get(key, 0)))
static func fresh_mul(key: String) -> float: return FRESH[mini(wins_today(key), FRESH.size() - 1)]
static func fresh_text(key: String) -> String:
	var n = wins_today(key)
	if n < 2: return L("今日怨氣：滿（仲有 %d 次全數）", "今日怨氣：滿（還有 %d 次全數）") % (2 - n)
	if n == 2: return L("今日怨氣：半（魂魄 ×½，換個據點啦）", "今日怨氣：半（魂魄 ×½，換個據點吧）")
	return L("今日怨氣：散（魂魄 ×¼，聽日 05:00 回復）", "今日怨氣：散（魂魄 ×¼，明天 05:00 回復）")

# ======================= 據點駐守 =======================
static func ckey(e: Dictionary) -> String: return "%d:%s" % [int(J.num(e.get("c", 0))), str(e.get("id", ""))]
static func _ct_guard(e: Dictionary) -> String:
	var ct = CT()
	var key = ckey(e); var id = str(e.get("id", ""))
	for f in ["camps", "camp", "sorties"]:
		var cs = ct.get(f)
		if cs is Dictionary:
			for kk in [key, id]:
				var d = cs.get(kk)
				if d is Dictionary and str(d.get("guard", "")) != "": return str(d.guard)
				if d is String and d != "": return d
			var cc = cs.get(str(int(J.num(e.get("c", 0)))))   # {"0": {"so1_r1_1": {guard}}}
			if cc is Dictionary and cc.get(id) is Dictionary and str(cc[id].get("guard", "")) != "": return str(cc[id].guard)
		elif cs is Array:
			for d in cs:
				if d is Dictionary and str(d.get("id", "")) == id and (not d.has("c") or int(J.num(d.c)) == int(J.num(e.get("c", 0)))) and str(d.get("guard", "")) != "": return str(d.guard)
	var g = ct.get("guard")
	if g is Dictionary and str(g.get(key, g.get(id, ""))) != "": return str(g.get(key, g.get(id, "")))
	return ""
static func guard_of(e: Dictionary) -> String:
	if e.is_empty(): return ""
	var k = str(e.get("guard", ""))   # zones.json 可直接寫
	if k == "": k = _ct_guard(e)
	if k == "": k = str(D().CAMP.get(ckey(e), ""))
	return k if is_ghost(k) else ""
static func _camps(c: int) -> Array: return load("res://game/sortie/so_data.gd").camps(c)
static func sec_of(e: Dictionary) -> String:   # 副魂 = 同章往後第 5 個據點嘅駐守鬼
	var cs = _camps(int(J.num(e.get("c", 0))))
	var n = cs.size()
	if n < 2: return ""
	for i in n:
		if str(cs[i].id) == str(e.get("id", "")):
			for j in range(5, 5 + n):
				var k = guard_of(cs[(i + j) % n])
				if k != "" and k != guard_of(e): return k
	return ""
static func guard_live(e: Dictionary) -> bool:   # 劇情鬼未加入：據點用舊頭目，唔掉主魂
	var k = guard_of(e)
	if k == "": return false
	return not story(k) or owned(k)
static func sources(k: String) -> Array:   # [{e, pri:bool}]：邊度有（所有章）
	var o = []
	for c in 6:
		for e in _camps(c):
			if guard_of(e) == k: o.append({"e": e, "pri": true})
			elif sec_of(e) == k: o.append({"e": e, "pri": false})
	return o
static func ch_of(k: String) -> int:   # 招降費用嘅「章」
	var best = 99
	for key in D().CAMP:
		if str(D().CAMP[key]) == k: best = mini(best, int(str(key).get_slice(":", 0)))
	if best < 99: return best
	return int(J.num(D().STORY_CH.get(k, 0)))

# 據點敵人：最後一隻換成駐守名鬼（cdata 已放入就唔郁）；第 4 圈頭目血 ×1.25 交 so_data
static func guard_stage(e: Dictionary, stg: Dictionary) -> Dictionary:
	if not guard_live(e): return stg
	var k = guard_of(e)
	var ET = J.G.get("ENEMY_T")
	if not (ET is Dictionary) or not ET.has(k): return stg
	var en = (stg.get("en", []) as Array).duplicate()
	if en.is_empty(): return stg
	if not (k in en): en[en.size() - 1] = k
	var o = stg.duplicate(); o["en"] = en; o["guard"] = k
	return o

# ======================= 得魂魄 =======================
# 回 {k, n, to_san}：合夥人之後自動化散魂
static func gain(k: String, n: int, why := "") -> Dictionary:
	var o = st()
	if o == null or n <= 0 or not is_ghost(k): return {"k": k, "n": 0, "to_san": 0}
	o.seen[k] = 1.0
	if owned(k) and rank(k) >= RANK_MAX:
		var sn = n * pv(k)
		o["san"] = J.num(o.san) + sn
		LOG.append(["gain", k, n, why, "san", sn])
		return {"k": k, "n": n, "to_san": sn}
	o.sh[k] = J.num(o.sh.get(k, 0)) + n
	LOG.append(["gain", k, n, why])
	return {"k": k, "n": n, "to_san": 0}
static func add_san(n: int, why := "") -> void:
	var o = st()
	if o == null or n <= 0: return
	o["san"] = J.num(o.san) + n
	LOG.append(["san", n, why])
static func _gain_txt(g: Dictionary, tag := "") -> String:
	var k = str(g.k)
	if int(g.to_san) > 0: return L("%s +%d（→散魂 %d）", "%s +%d（→散魂 %d）") % [gname(k), int(g.n), int(g.to_san)] + tag
	if owned(k):
		var r = rank(k)
		if r < RANK_MAX: return "%s +%d（%d/%d）" % [gname(k), int(g.n), souls(k), rank_cost(k, r + 1)] + tag
		return "%s +%d" % [gname(k), int(g.n)] + tag
	return "%s +%d（%d/%d）" % [gname(k), int(g.n), souls(k), need_of(k)] + tag

# 野外出擊打贏（so_data.settle 掛鈎）：回 {line, ready:[k], items:[{k,n,sec}], san}
static func on_sortie_win(e: Dictionary, first: bool, good := false) -> Dictionary:
	var out = {"line": "", "ready": [], "items": [], "san": 0, "mul": 1.0, "good": good}
	var o = st()
	if o == null: return out
	var key = ckey(e); var r = ri(e.get("ring", 1))
	var mul = fresh_mul(key); out.mul = mul
	var parts = []
	var k = guard_of(e)
	var was_ready = {}
	for kk in [k, sec_of(e)]: if kk != "": was_ready[kk] = can_summon(kk).ok
	if k != "" and guard_live(e):
		var base = PRI[r] + (1 if rng.randf() < PRI_BONUS_P else 0)
		var n = maxi(1, int(round(base * mul)))
		if good: n += GOOD_BONUS
		if first: n += FIRST[r]
		var g = gain(k, n, "sortie")
		out.items.append({"k": k, "n": n, "sec": false})
		parts.append(_gain_txt(g))
	# 副魂（保底）
	var k2 = sec_of(e)
	if k2 != "":
		var c = int(J.num(o.sec.get(key, 0)))
		var hit = rng.randf() < SEC_P or c + 1 >= SEC_PITY
		if hit:
			o.sec[key] = 0.0
			var n2 = maxi(1, int(round(SEC_N * maxf(0.5, mul))))
			var g2 = gain(k2, n2, "sec")
			out.items.append({"k": k2, "n": n2, "sec": true})
			parts.append(_gain_txt(g2, L("（副）", "（副）")))
		else: o.sec[key] = float(c + 1)
	# 散魂
	var sn = SAN[r]
	add_san(sn, "sortie"); out.san = sn
	parts.append(L("散魂 +%d", "散魂 +%d") % sn)
	var fr = _fr(); fr.n[key] = float(wins_today(key) + 1)
	var line = L("魂魄：", "魂魄：") + "、".join(parts)
	if good and k != "" and guard_live(e): line += L("（打得好 +%d）", "（打得好 +%d）") % GOOD_BONUS
	if mul < 0.99: line += L("（怨氣已散 ×%s）", "（怨氣已散 ×%s）") % ("½" if mul >= 0.5 else "¼")
	for kk in was_ready:
		if not was_ready[kk] and can_summon(kk).ok: out.ready.append(kk)
	for kk in out.ready: line += "　" + L("%s魂魄夠喇！返祭壇招降", "%s魂魄夠了！回祭壇招降") % gname(kk)
	out.line = line
	LOG.append(["sortie", key, out])
	return out
# 「打得好」：今場出陣名鬼有冇用到正確應對（敵人系怕佢嘅嚇法＝克制，或者佢嘅標籤應對敵人機制）
#   優先用 abcore 戰後記錄 op.ab_log.good；冇就用 abil.gd API（AB.tags_of／counters_of）推算；兩樣都冇（能力線未合併）＝false
static func good_play(op) -> bool:
	if not (op is Object): return false
	var lg = op.get("ab_log")
	if lg == null and op.has_meta("ab_log"): lg = op.get_meta("ab_log")
	if lg is Dictionary and lg.has("good"): return J.t(lg.good)
	if not ResourceLoader.exists("res://game/rts/abil.gd"): return false
	var AB = load("res://game/rts/abil.gd")
	if AB == null or not AB.has_method("tags_of") or not AB.has_method("counters_of"): return false
	if AB.has_method("on") and not AB.on(): return false
	var mine = {}; var foes = []
	for u in J.iter(op.get("units")):
		var k = J.str(J.gp(u, "k"))
		if J.num(J.gp(u, "side")) == 0 and is_ghost(k):
			for t in J.iter(AB.tags_of(k)): mine[str(t)] = true
		elif J.num(J.gp(u, "side")) == 1: foes.append(k)
	for k in foes:
		for t in J.iter(AB.counters_of(k)):
			if mine.has(str(t)): return true
	return false
# 專長格（FIXES_review1 第 2 項；abcore 按呢個解鎖 ABIL[k].perk[0..1]）：主任開 1、總監開 2；王品入村即有 1
static func perk_slots(k: String) -> int:
	var r = rank(k)
	var n = (1 if r >= 2 else 0) + (1 if r >= 4 else 0)
	if pin(k) == "王": n = maxi(n, 1 + (1 if r >= 4 else 0))
	return mini(2, n)

# 野外王（zone_data.resolve 掛鈎）：非劇情王首殺 +15
static func on_king(bid: String, c: int, first: bool) -> String:
	if not first or st() == null: return ""
	var k = king_ghost(bid, c)
	if k == "" or story(k): return ""
	var g = gain(k, KING_FIRST, "king")
	return L("魂魄：", "魂魄：") + _gain_txt(g)
static func king_ghost(bid: String, c: int) -> String:
	var zs = load("res://game/zone/zone_data.gd").mdef(c).get("zones", [])
	for z in (zs if zs is Array else []):
		if not (z is Dictionary): continue
		for b in J.iter(z.get("bosses", [])):
			if str(b.get("id", "")) != bid or J.t(b.get("main")): continue
			var stg = b.get("stage", {})
			var k = str(stg.get("boss", "")) if stg is Dictionary else ""
			return k if is_ghost(k) else ""
	return ""
static func on_stage_first(sid: String) -> String:
	if st() == null: return ""
	add_san(STAGE_SAN, "stage:" + sid)
	return L("散魂 +%d（首次通關）", "散魂 +%d（首次通關）") % STAGE_SAN
static func on_raid(how: String) -> void:
	if st() == null: return
	add_san(int(RAID_SAN.get(how, 1)), "raid:" + how)

# ======================= 祭壇 =======================
static func altar_lv() -> int:
	var s = S()
	return int(J.num(J.gp(s.get("bld", {}), "altar"))) if s != null else 0
static func need_of(k: String) -> int:
	var n = int(round(SUMMON[pin(k)] * SCALE))
	var o = st()
	if o != null and J.t(o.got.get(k)) and not owned(k): n = int(ceil(n * 0.5))   # 魂飛魄散過、重新招魂：一半，職級保留
	return n
static func wish_of(k: String) -> Array:   # [資源 key, 句子]
	var w = D().WISH.get(k)
	if w is Array and w.size() >= 3: return [str(w[0]), L(str(w[1]), str(w[2]))]
	return ["buns", L("壽包就得，最緊要係心意。", "壽包就好，最重要是心意。")]
static func res_name(r: String) -> String:
	var RN = J.G.get("RES_NAMES")
	return str(RN.get(r, r)) if RN is Dictionary else r
static func have(r: String) -> float:
	var s = S()
	return J.num(J.gp(s.get("res", {}), r)) if s != null else 0.0
static func summon_cost(k: String) -> Dictionary:
	var c1 = float(ch_of(k) + 1); var p = float(pv(k))
	var w = wish_of(k)
	var re = J.t(st().got.get(k)) and not owned(k)
	return {"souls": need_of(k), "coins": 0.0 if re else SUMMON_COIN * p * c1, "wish": w[0], "wish_n": 0.0 if re else WISH_N * p * c1, "say": w[1], "altar": int(ALTAR_PIN[pin(k)]), "re": re}
# 回 {ok, why, have, need, sub, sub_cost, cost}
static func can_summon(k: String) -> Dictionary:
	var o = st()
	var out = {"ok": false, "why": "", "have": 0, "need": 0, "sub": 0, "sub_cost": 0, "cost": {}}
	if o == null or not is_ghost(k): out.why = "no"; return out
	var cs = summon_cost(k); out.cost = cs
	var have_n = souls(k); out.have = have_n; out.need = int(cs.souls)
	if owned(k): out.why = "owned"; return out
	if story(k) and not J.t(o.got.get(k)): out.why = "story"; return out
	if unsummonable(k): out.why = "boss"; return out
	var miss = maxi(0, int(cs.souls) - have_n)
	if miss > 0:
		var cap = int(floor(cs.souls * SAN_SUB_MAX))
		if not seen(k) or miss > cap: out.why = "souls"; return out
		out.sub = miss; out.sub_cost = miss * pv(k) * SAN_BUY
		if san() < out.sub_cost: out.why = "souls"; return out
	if altar_lv() < int(cs.altar): out.why = "altar"; return out
	var coin_need = float(cs.coins) + (float(cs.wish_n) if str(cs.wish) == "coins" else 0.0)   # 心願係冥幣：一齊計
	if have("coins") < coin_need - 1e-6: out.why = "coins"; return out
	if str(cs.wish) != "coins" and have(str(cs.wish)) < float(cs.wish_n) - 1e-6: out.why = "wish"; return out
	out.ok = true
	return out
static func summon(k: String) -> String:
	var c = can_summon(k)
	if not c.ok: return str(c.why)
	var o = st(); var s = S(); var cs = c.cost
	var use = mini(souls(k), int(cs.souls))
	o.sh[k] = float(souls(k) - use)
	if J.num(o.sh[k]) <= 0: o.sh.erase(k)
	o["san"] = J.num(o.san) - c.sub_cost
	s.res["coins"] = have("coins") - float(cs.coins)
	s.res[str(cs.wish)] = have(str(cs.wish)) - float(cs.wish_n)
	var keep_rk = rank(k)
	_bypass = true
	J.cl(J.G.get("joinGhost"), null, [k])
	_bypass = false
	var g = ghost(k)
	if g == null: return "fail"
	o.got[k] = 1.0; o.seen[k] = 1.0
	o.rk[k] = float(keep_rk if cs.re else 0)
	apply_stats(g)
	LOG.append(["summon", k, cs])
	_save()
	return "ok"

# ---- 升職 ----
static func rank_cost(k: String, to: int) -> int: return int(RANK_COST[pin(k)][clampi(to, 1, RANK_MAX) - 1])
static func can_promote(k: String) -> Dictionary:
	var out = {"ok": false, "why": "", "have": souls(k), "need": 0, "sub": 0, "sub_cost": 0, "coins": 0.0, "altar": 0, "to": 0}
	if st() == null or not owned(k) or not is_ghost(k): out.why = "notown"; return out
	var r = rank(k)
	if r >= RANK_MAX: out.why = "max"; return out
	var to = r + 1; out.to = to
	out.need = rank_cost(k, to); out.coins = RANK_COIN[to - 1] * pv(k); out.altar = ALTAR_RANK[to]
	var miss = maxi(0, out.need - out.have)
	if miss > 0:
		if miss > int(floor(out.need * RANK_SUB_MAX)): out.why = "souls"; return out   # 散魂封頂一半
		out.sub = miss; out.sub_cost = miss * pv(k) * SAN_BUY
		if san() < out.sub_cost: out.why = "souls"; return out
	if altar_lv() < out.altar: out.why = "altar"; return out
	if have("coins") < out.coins - 1e-6: out.why = "coins"; return out
	out.ok = true
	return out
static func promote(k: String) -> String:
	var c = can_promote(k)
	if not c.ok: return str(c.why)
	var o = st(); var s = S()
	var use = mini(souls(k), c.need)
	o.sh[k] = float(souls(k) - use)
	if J.num(o.sh[k]) <= 0: o.sh.erase(k)
	o["san"] = J.num(o.san) - c.sub_cost
	s.res["coins"] = have("coins") - c.coins
	o.rk[k] = float(c.to)
	var g = ghost(k)
	if g != null: apply_stats(g)
	LOG.append(["promote", k, c.to])
	_save()
	return "ok"
static func stat_target(k: String, r: int) -> Array:
	var d = GH().get(k)
	var base = d.get("base", [0, 0, 0]) if d is Dictionary else [0, 0, 0]
	var o = []
	for i in 3: o.append(float(round(J.num(base[i]) * (1.0 + STAT_PCT[pin(k)] * r))))
	return o
static func apply_stats(g) -> void:
	var k = J.str(g.get("k"))
	if not is_ghost(k): return
	var tg = stat_target(k, rank(k))
	var st0 = g.get("st")
	if not (st0 is Array) or st0.size() < 3: g["st"] = tg; return
	for i in 3: st0[i] = maxf(J.num(st0[i]), tg[i])
static func cap_of(g) -> float:
	var NG = load("res://native/game.gd")
	var cap = NG.ghost_cap()
	var k = J.str(J.gp(g, "k"))
	if is_ghost(k): cap += CAP_PER_RANK * rank(k)
	return cap

# ---- 散魂（分解） ----
static func dismantle_rate(k: String) -> float: return pv(k) * (1.0 + DISMANTLE_PER_LV * altar_lv())
static func dismantle(k: String, n: int) -> int:
	var o = st()
	n = mini(n, souls(k))
	if o == null or n <= 0: return 0
	o.sh[k] = float(souls(k) - n)
	if J.num(o.sh[k]) <= 0: o.sh.erase(k)
	var got = int(floor(n * dismantle_rate(k)))
	o["san"] = J.num(o.san) + got
	LOG.append(["dismantle", k, n, got])
	_save()
	return got

# ======================= 名冊／介面用 =======================
static func roster_entry(g, e: Dictionary) -> void:   # native/game.gd n_roster 掛鈎
	var k = J.str(J.gp(g, "k"))
	if not is_ghost(k) or J.str(J.gp(g, "q")) != "名" or st() == null: return
	var r = rank(k)
	var t = L("%s品・職級：%s", "%s品・職級：%s") % [pin(k), rank_name(r)]
	if r < RANK_MAX: t += L("　升職魂魄 %d/%d", "　升職魂魄 %d/%d") % [souls(k), rank_cost(k, r + 1)]
	e.extra.append(["#b07a1f", t])
	var cap = cap_of(g)
	e["maxed"] = J.num(e.get("lv", 0)) >= cap
	e["gpNext"] = e.get("gpNext") if J.num(e.get("lv", 0)) < cap else null
static func ready_count() -> int:   # 祭壇紅點：夠數招降／升職
	var o = st()
	if o == null: return 0
	var n = 0
	for k in o.sh:
		if J.num(o.sh[k]) <= 0: continue
		if owned(k):
			if can_promote(k).ok: n += 1
		elif can_summon(k).ok: n += 1
	return n

# ======================= 舊存檔遷移（S.soul.mig 防重複） =======================
static func migrate(s: Dictionary, o: Dictionary) -> void:
	o["mig"] = 1.0   # 先標記：中途出錯都唔會重複補發
	var lines = []
	var nrk = 0
	# 1. 已擁有名鬼：照留，按等級送職級（最多經理），三圍取大
	for g in J.iter(s.get("ghosts")):
		var k = J.str(g.get("k"))
		if not is_ghost(k) or J.str(g.get("q")) != "名": continue
		o.got[k] = 1.0; o.seen[k] = 1.0
		if o.rk.get(k) == null:
			var r = 0
			for m in MIG_RANK: if J.num(g.get("lv", 1)) >= m[0]: r = maxi(r, int(m[1]))
			o.rk[k] = float(r)
			if r > 0: nrk += 1
		apply_stats(g)
	if nrk > 0: lines.append(L("%d 隻老員工按年資升職", "%d 隻老員工按年資升職") % nrk)
	# 2. 已首勝據點：首勝見面禮＋2×min(勝場,5)
	var nsh = 0
	var so = s.get("sortie")
	if so is Dictionary and so.get("camps") is Dictionary:
		for key in so.camps:
			var d = so.camps[key]
			if not (d is Dictionary) or not J.t(d.get("first")): continue
			var c = int(str(key).get_slice(":", 0)); var id = str(key).get_slice(":", 1)
			var e = {}
			for x in _camps(c): if str(x.id) == id: e = x
			if e.is_empty(): continue
			var k = guard_of(e)
			if k == "" or (story(k) and not owned(k)): continue
			var n = FIRST[ri(e.ring)] + 2 * mini(int(J.num(d.get("wins", 0))), 5)
			gain(k, n, "mig"); nsh += n
	# 3. 已打低嘅野外王（非劇情）：+15
	var zz = s.get("zone")
	if zz is Dictionary and zz.get("boss") is Dictionary:
		for key in zz.boss:
			if not J.t(zz.boss[key]): continue
			var k = king_ghost(str(key).get_slice(":", 1), int(str(key).get_slice(":", 0)))
			if k != "" and not story(k): gain(k, KING_FIRST, "mig"); nsh += KING_FIRST
	if nsh > 0: lines.append(L("補發魂魄 %d 隻", "補發魂魄 %d 隻") % nsh)
	# 4. 已通關主線：每關散魂 10；關卡入面嘅名鬼記「遇見」
	var nst = 0
	var CH = J.G.get("CHAPTERS")
	var cl = s.get("cleared")
	if cl is Dictionary:
		var re = RegEx.create_from_string("^(\\d)-(\\d)$")
		for sid in cl:
			var m = re.search(str(sid))
			if m == null or not J.t(cl[sid]): continue
			nst += 1
			var ci = int(m.get_string(1)) - 1; var si = int(m.get_string(2)) - 1
			if CH is Array and ci >= 0 and ci < CH.size() and si >= 0 and si < CH[ci].stages.size():
				for k in J.iter(CH[ci].stages[si].get("en")): if is_ghost(J.str(k)): o.seen[J.str(k)] = 1.0
	if nst > 0:
		o["san"] = J.num(o.san) + STAGE_SAN * nst
		lines.append(L("散魂 %d", "散魂 %d") % (STAGE_SAN * nst))
	# 5. 魂飛魄散名單入面嘅名鬼：送一半招降數，之後祭壇「重新招魂」（唔失憶、職級保留）
	var pr = s.get("presence")
	if pr is Dictionary and pr.get("gone") is Array:
		var keep = []
		for x in pr.gone:
			var k = J.str(J.gp(x, "k"))
			if J.str(J.gp(x, "q")) == "名" and is_ghost(k) and not owned(k):
				o.got[k] = 1.0; o.seen[k] = 1.0
				var lvx = J.num(J.gp(x, "lv"))
				if o.rk.get(k) == null:
					var r2 = 0
					for m2 in MIG_RANK: if lvx >= m2[0]: r2 = maxi(r2, int(m2[1]))
					o.rk[k] = float(r2)
				o.sh[k] = maxf(J.num(o.sh.get(k, 0)), float(need_of(k)))
				lines.append(L("%s嘅黃紙仲喺祭壇：可以重新招魂", "%s的黃紙還在祭壇：可以重新招魂") % gname(k))
			else: keep.append(x)
		pr["gone"] = keep
	o["mig_note"] = "；".join(lines)
	if lines.size() > 0: pending_toast = L("【祭壇開張】", "【祭壇開張】") + "；".join(lines)
	LOG.append(["migrate", lines])

# ======================= 舊直接加入途徑 → 送魂魄（wrap joinGhost） =======================
static func install() -> void:
	var G = J.G
	var b = G.get("BUILDINGS")
	if b is Dictionary and b.get("altar") is Dictionary:
		b.altar["name"] = L("祭壇（招魂台）", "祭壇（招魂台）")
		b.altar["desc"] = L("收集魂魄招降名鬼、幫佢哋升職；仲可以花冥幣同壽包招雜鬼。", "收集魂魄招降名鬼、替他們升職；也可以花冥幣與壽包招雜鬼。")
	var jg = G.get("joinGhost")
	if jg == null or is_same(G.get("__soul_join_w"), jg): return
	G["__soul_join_orig"] = jg
	var w = func(t, a):
		var k = J.str(J.arg(a, 0))
		if WRAP_JOIN and not _bypass and intercept(k): return null
		return J.cl(J.G["__soul_join_orig"], t, a)
	G["joinGhost"] = w; G["__soul_join_w"] = w
	var win = G.get("window")
	var WG = J.gp(win, "G") if win != null else null
	if J.t(WG) and J.t(J.gp(WG, "joinGhost")): J.sp(WG, "joinGhost", w)
# 回 true＝已改送魂魄（唔直接加入）
static func intercept(k: String) -> bool:
	if S() == null or not is_ghost(k) or story(k) or owned(k): return false
	var o = st()
	if J.t(o.got.get(k)): return false   # 招降過（之後散咗）：照舊直接返嚟
	if J.t(o.dir.get(k)):
		gain(k, DIRECT_OWNED, "direct")
		_toast(L("【%s】再交多 %d 隻魂魄畀你（%d/%d）", "【%s】再交給你 %d 隻魂魄（%d/%d）") % [gname(k), DIRECT_OWNED, souls(k), need_of(k)])
		return true
	o.dir[k] = 1.0
	var n = maxi(0, need_of(k) - souls(k))
	gain(k, maxi(1, n), "direct")
	_toast(L("【%s】將 %d 隻魂魄交咗畀你：去祭壇簽入職合約，佢就正式加入落魄村！", "【%s】把 %d 隻魂魄交給了你：去祭壇簽入職合約，他就正式加入落魄村！") % [gname(k), maxi(1, n)])
	_save()
	return true

# 測試大禮包（main.gd gift 掛鈎）：{"san": n, "sh": {k: n}}
static func gift(g: Dictionary) -> void:
	if st() == null: return
	if g.has("san"): add_san(int(J.num(g.san)), "gift")
	if g.get("sh") is Dictionary:
		for k in g.sh: gain(str(k), int(J.num(g.sh[k])), "gift")

static func _toast(m: String) -> void:
	var mm = Engine.get_main_loop().root.get_node_or_null("Main") if Engine.get_main_loop() != null else null
	if mm != null and mm.has_method("show_toast"): mm.show_toast(m)
static func _save() -> void:
	var f = J.G.get("save")
	if f != null: J.cl(f, null, [])
static func flush_toast() -> void:
	if pending_toast == "": return
	_toast(pending_toast); pending_toast = ""
