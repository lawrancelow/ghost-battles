# 移動村（出殯巡遊大排檔）× 舊系統 嘅接駁層（整合線）
# 冇 class_name、冇 autoload（熱更新規矩）：用 load("res://game/outpost/mv_bridge.gd") 叫 static func。
#
# 做咩：
#  1. 開關 S.mv_on：新存檔預設開；舊存檔第一次入嚟開、彈介紹（S.mv_intro = 1 → 介紹完 = 2），
#     按進度落圖：已打通（cleared "N-3"）嘅圖當已拔營（變分村），村子落喺第一張未打通嘅圖（全部通晒 → 最後一張）。
#  2. 資源對照（移動村開咗先生效，舊村子畫面照用舊公式）：
#     ratesPerMin 包一層 → 加入移動村各台嘅「副產出」，經舊 produce() 加工鏈入 S.res
#       棺材板工場（角色 planks）→ 槐木（斬槐木）＋ 棺材板（2 槐木 → 1 板）
#       蒸籠台（角色 buns）      → 糯米 ＋ 壽包（2 糯米 → 1 包）
#       守夜／訓練台（角色 troops）→ 陰兵；台上員工順手練嚇功（同舊嚇人訓練班一樣食壽包）
#       紙紮大屋（每張圖自帶）   → 少量保底（防止某張圖冇對應台而斷糧）
#     冥幣：由移動村賣貨直接入 S.res.coins（引擎線），呢度唔再計。
#  3. 虛擬建築等級：S.bld 每次同步 = max(舊等級, 移動村換算等級)（只升唔跌）——舊公式（倉庫上限、陰兵上限、
#     雜鬼名額、箱子收穫、任務「建造／升級 X」）全部照行，唔使改其他模塊。
#  4. 任務計數：砍樹／割稻／做板／包包 = 對應台等級（S.cnt 只升唔跌）；顯示文字有移動村版（quest_text）。
#  5. 員工互斥：移動村員工 gh.post = "mv"；validate() 清走已經去咗第二度（分村 garrison／舊崗位）嘅員工。
#  6. 離線：包 offlineGain：先叫移動村 offline_gain(ms)（只計賣貨冥幣），再行舊 offlineGain（produce 加工鏈，
#     已含移動村副產出）。兩邊資源唔重疊，唔會重複計；舊嘅「最多 8 小時」同一個上限。
extends RefCounted

const ROLE_KEYS := {
	"buns": ["bun", "steam", "bao", "包", "蒸"],
	"planks": ["coffin", "plank", "board", "棺", "板"],
	"troops": ["guard", "watch", "train", "drill", "troop", "night", "守", "練", "兵"],
}
const OFFLINE_MAX_MS := 8.0 * 3600.0 * 1000.0

static var _scene = null      # 而家掛住嘅移動村場景（main 設定）
static var _od := {}          # outpost.json 快取
static var _od_ok := false
static var _installed := false

# ---------------- 基本 ----------------
static func S():
	var s = J.G.get("S")
	return s if s is Dictionary else null
static func on() -> bool:
	var s = S()
	return s != null and J.t(s.get("mv_on"))
static func T(yue: String, zh: String) -> String: return yue if DB.lang == "yue" else zh
static func set_scene(sc) -> void: _scene = sc
static func scene(): return _scene if _scene != null and is_instance_valid(_scene) else null

static func od() -> Dictionary:
	if not _od_ok:
		_od_ok = true
		if FileAccess.file_exists("res://data/nat/outpost.json"):
			var o = JSON.parse_string(FileAccess.get_file_as_string("res://data/nat/outpost.json"))
			if o is Dictionary: _od = o
	return _od

static func garrison():
	var ml = Engine.get_main_loop()
	return ml.root.get_node_or_null("Garrison") if ml is SceneTree else null

static func maps_n() -> int:
	var M = od().get("MAPS", [])
	return M.size() if M is Array and M.size() > 0 else 6

static func cleared(ci: int) -> bool:
	var s = S()
	if s == null: return false
	var cl = s.get("cleared")
	return cl is Dictionary and J.t(cl.get("%d-3" % (ci + 1)))

# 舊進度 → 村子應該喺邊張圖（第一張未打通；全部通晒 = 最後一張）
static func front_by_progress() -> int:
	for ci in maps_n():
		if not cleared(ci): return ci
	return maps_n() - 1

static func ci() -> int:
	var s = S()
	if s == null or not (s.get("mv") is Dictionary): return -1
	return int(J.num(s.mv.get("ci", 0)))

# ---------------- 1. 開關＋舊存檔搬遷 ----------------
# 回傳 "new"／"old"／""（已搬過）
static func migrate() -> String:
	var s = S()
	if s == null: return ""
	if s.has("mv_on"):
		_ensure_mv(s)
		return ""
	var fresh = int(J.num(s.get("qi", 0))) == 0 and J.num(s.get("lv", 1)) <= 1 and not (s.get("cleared") is Dictionary and (s.cleared as Dictionary).size() > 0)
	s["mv_on"] = true
	if not (s.get("mv") is Dictionary): s["mv"] = {"ci": float(0 if fresh else front_by_progress())}
	_ensure_mv(s)
	if fresh:
		s["mv_intro"] = 2.0
		return "new"
	s["mv_intro"] = 1.0
	_move_old_posts(s)
	return "old"

static func _ensure_mv(s: Dictionary) -> void:
	if not (s.get("mv") is Dictionary): s["mv"] = {"ci": float(front_by_progress())}
	var m: Dictionary = s.mv
	if m.get("ci") == null: m["ci"] = float(front_by_progress())
	if not (m.get("st") is Dictionary): m["st"] = {}
	if not (m.get("goals_done") is Array): m["goals_done"] = []
	if m.get("cash_till") == null: m["cash_till"] = 0.0

# 舊存檔：舊崗位（伐木場／棺材鋪／包子鋪／訓練班…）嘅鬼保留喺「後院」照做（舊公式照計），唔強行搬——
# 玩家可以喺移動村自己調人；呢度乜都唔郁，只係記低。保留函數方便日後改主意。
static func _move_old_posts(_s: Dictionary) -> void:
	pass

static func intro_pending() -> bool:
	var s = S()
	return s != null and on() and int(J.num(s.get("mv_intro", 0))) == 1

static func intro_lines() -> Array:
	var c = ci()
	var nm = map_name(c)
	var moved = []
	for i in c: moved.append(map_name(i))
	var l = [
		["系統", T("通知：落魄村升級做「出殯巡遊大排檔」！間紙紮大屋由抬棺鬼抬住，一張地圖接一張地圖咁擺檔。", "通知：落魄村升級成「出殯巡遊大排檔」！紙紮大屋由抬棺鬼抬著，一張地圖接一張地圖地擺攤。")],
		["系統", T("而家喺「%s」開檔：生產台做貨、客人排隊買、賺冥幣、完成目標；打低主線 Boss 就可以拔營去下一張圖。" % nm, "現在在「%s」開攤：生產台做貨、客人排隊買、賺冥幣、完成目標；打倒主線 Boss 就能拔營去下一張圖。" % nm)],
	]
	if moved.size() > 0:
		l.append(["系統", T("你打通咗嘅地圖（%s）當已經拔營，留低嘅檔已經變咗分村。" % "、".join(moved), "你打通了的地圖（%s）視為已拔營，留下的攤位已變成分村。" % "、".join(moved))])
	l.append(["旁白", T("壽包由蒸籠台出、棺材板由棺材板工場出、陰兵由守夜台出。舊建築搬咗去「後院」，撳右上角「後院」照用得。", "壽包由蒸籠台出、棺材板由棺材板工場出、陰兵由守夜台出。舊建築搬到了「後院」，按右上角「後院」照樣可用。")])
	return l

static func map_name(c: int) -> String:
	var M = od().get("MAPS", [])
	if M is Array and c >= 0 and c < M.size():
		var n = M[c].get("name")
		if n is Array and n.size() >= 2: return str(n[0]) if DB.lang == "yue" else str(n[1])
	var f = FileAccess.get_file_as_string("res://data/nat/maps.json")
	var o = JSON.parse_string(f) if f != "" else null
	if o is Dictionary and o.get("MAPS") is Array and c >= 0 and c < o.MAPS.size():
		var n2 = o.MAPS[c].get("name")
		if n2 is Array and n2.size() >= 2: return str(n2[0]) if DB.lang == "yue" else str(n2[1])
	return T("第 %d 張圖" % (c + 1), "第 %d 張圖" % (c + 1))

# ---------------- 2. 台 → 資源角色 ----------------
static func station_def(sid: String) -> Dictionary:
	var ST = od().get("STATIONS", {})
	return ST.get(sid, {}) if ST is Dictionary else {}

static func role_of(sid: String) -> String:
	var d = station_def(sid)
	var r = str(d.get("res", ""))   # 建議設計線加呢欄（可選）："buns"／"planks"／"troops"
	if r in ["buns", "planks", "troops"]: return r
	var hay = (sid + " " + str(d.get("good", "")) + " " + str(d.get("art", "")) + " " + (str(d.n[0]) if d.get("n") is Array else "")).to_lower()
	for role in ["buns", "planks", "troops"]:
		for k in ROLE_KEYS[role]:
			if hay.contains(k): return role
	return ""

# 而家呢張圖嘅台（已解鎖）：[{sid, role, lv, workers:[gh...]}]
static func stations() -> Array:
	var s = S(); var o = []
	if s == null or not (s.get("mv") is Dictionary): return o
	var st = s.mv.get("st", {})
	if not (st is Dictionary): return o
	var allow = null
	var M = od().get("MAPS", [])
	var c = ci()
	if M is Array and c >= 0 and c < M.size() and M[c].get("stations") is Array: allow = M[c].stations
	for sid in st:
		if allow != null and not (allow as Array).has(sid): continue
		var e = st[sid]
		if not (e is Dictionary) or not J.t(e.get("unlocked", true)): continue
		var lv = J.num(e.get("lv", 1))
		if lv <= 0: continue
		var ws = []
		for gid in (e.get("workers", []) if e.get("workers") is Array else []):
			var gh = ghost(gid)
			if gh != null: ws.append(gh)
		o.append({"sid": str(sid), "role": role_of(str(sid)), "lv": lv, "workers": ws})
	return o

static func role_lv(role: String) -> float:
	var m = 0.0
	for e in stations(): if e.role == role: m = maxf(m, e.lv)
	return m

static func sum_lv() -> float:
	var t = 0.0
	for e in stations(): t += e.lv
	return t

static func ghost(id) -> Variant:
	var s = S()
	if s == null or id == null: return null
	for gh in s.get("ghosts", []):
		if J.seq(J.gp(gh, "id"), id): return gh
	return null

static func _glv(gh) -> float:
	var F = J.G.get("F")
	return J.num(J.mc(F, "glv", [gh])) if F != null else J.num(J.gp(gh, "lv"))
static func _stat(gh, i: int) -> float:
	var F = J.G.get("F")
	return J.num(J.mc(F, "stat", [gh, float(i)])) if F != null else J.num(J.gp(gh, "st")[i])

# 每分鐘副產出（加落舊 ratesPerMin 結果）
static func add_rates(r: Dictionary) -> Dictionary:
	if not on(): return r
	var c = maxf(0, ci())
	# 紙紮大屋保底
	var base_p = 1.0 + 0.5 * c; var base_b = 1.0 + 0.5 * c
	r["planks"] = J.num(r.get("planks")) + base_p; r["woodUse"] = J.num(r.get("woodUse")) + base_p * 2; r["wood"] = J.num(r.get("wood")) + base_p * 2.3
	r["buns"] = J.num(r.get("buns")) + base_b; r["riceUse"] = J.num(r.get("riceUse")) + base_b * 2; r["rice"] = J.num(r.get("rice")) + base_b * 2.3
	r["troops"] = J.num(r.get("troops")) + 0.5 + 0.3 * c
	for e in stations():
		var lv: float = e.lv; var w = 0.0
		for gh in e.workers: w += 1.0 + _glv(gh) * 0.03
		match str(e.role):
			"planks":
				var p = (2.0 + 0.25 * lv) * (1.0 + 0.5 * w)
				r["planks"] = J.num(r.get("planks")) + p; r["woodUse"] = J.num(r.get("woodUse")) + p * 2; r["wood"] = J.num(r.get("wood")) + p * 2.3
			"buns":
				var b = (2.0 + 0.25 * lv) * (1.0 + 0.5 * w)
				r["buns"] = J.num(r.get("buns")) + b; r["riceUse"] = J.num(r.get("riceUse")) + b * 2; r["rice"] = J.num(r.get("rice")) + b * 2.3
			"troops":
				r["troops"] = J.num(r.get("troops")) + 1.0 + 0.15 * lv + 0.6 * w
				for gh in e.workers:   # 守夜台員工順手練嚇功（同舊訓練班一樣食壽包）
					var o = (2.0 + _stat(gh, 2) * 0.04) * (1.0 + 0.02 * lv)
					r["drill"] = J.num(r.get("drill")) + o; r["bunUse"] = J.num(r.get("bunUse")) + o * 0.6
					if not (r.get("drillBy") is Array): r["drillBy"] = []
					r.drillBy.append([J.gp(gh, "k"), o])
		# 好評：舊 ratesPerMin 已經對每隻有 post 嘅鬼（包括 "mv"）加 0.6/分，呢度唔再加
	return r

# ---------------- 3. 虛擬建築等級（只升唔跌）----------------
static func mapped_bld() -> Dictionary:
	var s = S(); var c = maxf(0, ci()); var sl = sum_lv()
	var lp = role_lv("planks"); var lb = role_lv("buns"); var lt = role_lv("troops")
	var house = clampf(2 + c + floor(sl / 30.0), 1, 20)
	var o = {"house": house}
	o["wood"] = 1 + floor(lp / 10.0)
	o["rice"] = 1 + floor(lb / 10.0)
	o["plank"] = (1 + floor(lp / 10.0)) if lp > 0 else 0.0
	o["bun"] = (1 + floor(lb / 10.0)) if lb > 0 else 0.0
	o["store"] = (1 + c + floor(sl / 40.0)) if (c >= 1 or sl >= 20) else 0.0
	o["home"] = (1 + floor(lt / 10.0)) if lt > 0 else (1.0 if c >= 1 else 0.0)
	o["camp"] = (1 + floor(lt / 15.0)) if (lt > 0 and J.num(s.get("lv", 1)) >= 5) else 0.0
	o["altar"] = 1.0 if J.t(J.gp(s.get("cleared", {}), "1-3")) else 0.0
	o["furnace"] = 1.0 if J.num(s.get("lv", 1)) >= 6 else 0.0
	for k in o:
		if k != "house": o[k] = minf(o[k], house)
	return o

static func sync() -> void:
	var s = S()
	if s == null or not on(): return
	_ensure_mv(s)
	validate()
	var b = s.get("bld")
	if b is Dictionary:
		var mb = mapped_bld()
		for k in mb:
			if J.num(b.get(k, 0)) < mb[k]: b[k] = float(mb[k])
	# 任務計數（只升唔跌）：砍樹／做板 = 棺材板工場等級；割稻／包包 = 蒸籠台等級
	var cnt = s.get("cnt")
	if cnt is Dictionary:
		var lp = role_lv("planks"); var lb = role_lv("buns")
		for pair in [["chop", lp], ["craftPlank", lp], ["rice", lb], ["craftBun", lb]]:
			if J.num(cnt.get(pair[0], 0)) < pair[1]: cnt[pair[0]] = float(pair[1])

# ---------------- 4. 任務文字（移動村版；只換顯示，唔郁劇情）----------------
const QTXT := {
	"chop": ["把棺材板工場升到 %d 級（抬棺鬼順手斬槐木）", "把棺材板工場升到 %d 級（抬棺鬼順手砍槐木）"],
	"craftPlank": ["把棺材板工場升到 %d 級", "把棺材板工場升到 %d 級"],
	"rice": ["把蒸籠台升到 %d 級（順手收糯米）", "把蒸籠台升到 %d 級（順手收糯米）"],
	"craftBun": ["把蒸籠台升到 %d 級", "把蒸籠台升到 %d 級"],
}
const BTXT := {
	"plank": ["開棺材板工場", "開棺材板工場"], "bun": ["開蒸籠台", "開蒸籠台"], "home": ["開守夜台（陰兵有地方企）", "開守夜台（陰兵有地方站）"],
	"camp": ["開守夜台（主公 5 級後兼做嚇人訓練）", "開守夜台（主公 5 級後兼做嚇人訓練）"], "store": ["拔營一次或者各台合共升到 20 級（倉庫跟大屋擴建）", "拔營一次或各台合計升到 20 級（倉庫隨大屋擴建）"],
	"altar": ["打低餓鬼王（招魂台喺後院自動起好）", "打倒餓鬼王（招魂台在後院自動建好）"], "furnace": ["升到 6 級（化寶爐喺後院自動起好）", "升到 6 級（化寶爐在後院自動建好）"],
}
static func quest_text(q) -> String:
	var txt = str(J.gp(q, "text"))
	if not on() or not (q is Dictionary): return txt
	var t = str(q.get("t", ""))
	if QTXT.has(t): return (QTXT[t][0] if DB.lang == "yue" else QTXT[t][1]) % int(J.num(q.get("n", 1)))
	if t == "build" and BTXT.has(str(q.get("b", ""))):
		var a = BTXT[str(q.b)]; return a[0] if DB.lang == "yue" else a[1]
	if t == "bLevel":
		var b = str(q.get("b", ""))
		var nm = {"wood": ["棺材板工場", 10, "伐木場"], "plank": ["棺材板工場", 10, "棺材鋪"], "rice": ["蒸籠台", 10, "糯米田"], "bun": ["蒸籠台", 10, "包子鋪"], "home": ["守夜台", 10, "民宅"], "camp": ["守夜台", 15, "嚇人訓練班"]}
		if nm.has(b):
			var n = int(J.num(q.get("n", 1)))
			var lvn = maxi(1, int((n - 1) * nm[b][1]))
			return T("把%s升到 %d 級（後院%s跟住升到 Lv%d）" % [nm[b][0], lvn, nm[b][2], n], "把%s升到 %d 級（後院%s隨之升到 Lv%d）" % [nm[b][0], lvn, nm[b][2], n])
		if b == "house" or b == "store": return T("%s（拔營／各台升級令紙紮大屋擴建）" % txt, "%s（拔營／各台升級讓紙紮大屋擴建）" % txt)
	if t == "assign": return T("%s（移動村生產台都算）" % txt, "%s（移動村生產台也算）" % txt)
	return txt

# ---------------- 5. 員工互斥 ----------------
static func validate() -> void:
	var s = S()
	if s == null or not (s.get("mv") is Dictionary): return
	var seen = {}
	var st = s.mv.get("st", {})
	if not (st is Dictionary): return
	for sid in st:
		var e = st[sid]
		if not (e is Dictionary) or not (e.get("workers") is Array): continue
		var keep = []
		for gid in e.workers:
			var gh: Variant = ghost(gid); var key = J.str(gid)
			if gh == null or seen.has(key) or J.seq(J.gp(gh, "k"), "afu"): continue
			var p = gh.get("post")
			if p == null or J.seq(p, "mv"):
				gh["post"] = "mv"; seen[key] = true; keep.append(gid)
			# 其他崗位（分村 garrison／舊崗位）＝ 已經被調走，唔再算移動村員工
		if keep.size() != e.workers.size(): e["workers"] = keep
	# 冇登記喺任何台嘅 "mv" 鬼（例如場景換咗）：放返自由
	for gh in s.get("ghosts", []):
		if J.seq(gh.get("post"), "mv") and not seen.has(J.str(gh.get("id"))): gh["post"] = null

# ---------------- 6. 安裝包裝（ratesPerMin、offlineGain）----------------
static func install() -> void:
	var G = J.G
	var rp = G.get("ratesPerMin")
	if rp == null or (G.get("__mv_rates_orig") != null and is_same(G.get("__mv_rates_wrapped"), rp)): return
	G["__mv_rates_orig"] = rp
	var wrapped = func(t, a):
		var r = J.cl(G["__mv_rates_orig"], t, a)
		return add_rates(r) if r is Dictionary else r
	G["ratesPerMin"] = wrapped; G["__mv_rates_wrapped"] = wrapped
	var og = G.get("offlineGain")
	if og != null:
		G["__mv_offline_orig"] = og
		G["offlineGain"] = func(t, a):
			mv_offline()
			return J.cl(G["__mv_offline_orig"], t, a)
	_installed = true

# 移動村離線（只計賣貨）：用同舊離線一樣嘅 S.last、一樣 8 小時上限、一樣 60 秒門檻
static func mv_offline() -> float:
	var s = S()
	if s == null or not on(): return 0.0
	sync()
	var last = J.num(s.get("last")) if J.t(s.get("last")) else J.now()
	var ms = minf(OFFLINE_MAX_MS, maxf(0, J.now() - last))
	if ms < 60000: return 0.0
	var sc = scene()
	if sc == null or not sc.has_method("offline_gain"): return 0.0
	var before = J.num(s.res.get("coins"))
	sc.offline_gain(ms)
	return J.num(s.res.get("coins")) - before

# 每 0.5 秒（main.refresh）叫：同步虛擬等級、計數、員工
static func tick() -> void:
	if not on(): return
	if not _installed or not is_same(J.G.get("ratesPerMin"), J.G.get("__mv_rates_wrapped")): install()
	sync()
