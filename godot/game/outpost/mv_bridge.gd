# 移動村（出殯巡遊大排檔）× 舊系統 嘅接駁層（整合線）
# 冇 class_name、冇 autoload（熱更新規矩）：用 load("res://game/outpost/mv_bridge.gd") 叫 static func。
#
# 做咩：
#  1. 開關 S.mv_on：新存檔預設開；舊存檔第一次入嚟開、彈介紹（S.mv_intro = 1 → 介紹完 = 2），
#     按進度落圖：已打通（cleared "N-3"）嘅圖當已拔營（變分村），村子落喺第一張未打通嘅圖（全部通晒 → 最後一張）。
#  2. [chain] 資源：唔再有「副產出」（舊 add_rates 按台名關鍵字猜角色——例如錶攤撞中 "watch" 變咗產陰兵——已刪）。
#     而家係真生產鏈：T1／T2 由後院建築出（native/game.gd produce＋chain_eco.gd），移動村嘅台由材料庫扣料做貨
#     （mv_sim.gd），壽包只由隨村台「嘆氣蒸籠」用普通包子蒸。冥幣由賣貨入 S.res.coins。
#  3. 虛擬建築等級：S.bld 每次同步 = max(舊等級, 移動村換算等級)（只升唔跌），只管冇喺後院自己升嘅：
#     鬼宅（house）、倉庫（store）、民宅（home）、招魂台（altar）、化寶爐（furnace）。伐木場／糯米田／棺材鋪／包子鋪／
#     訓練班係後院真建築（生產鏈 T1／T2），唔再虛擬升。
#  4. 任務計數：「包壽包」（craftBun）= max(親手包數, 嘆氣蒸籠產出壽包數 S.mv.made.m_shoubao)（只升唔跌）；
#     顯示文字有移動村版（quest_text）。
#  5. 員工互斥：移動村員工 gh.post = "mv"；validate() 清走已經去咗第二度（分村 garrison／舊崗位）嘅員工。
#  6. [chain] 離線：包 offlineGain（移動村開咗先生效）：每 60 秒一段，先行後院 produce（T1／T2 入倉），
#     再行移動村 offline_step（扣料做貨、分流、賣貨），交替做到離開時間（最多 8 小時）——上層受原料限制；
#     兩邊各計一次，唔再行舊 offlineGain（唔會重複計）。完咗 S.last 同 S.mv.last 都設做而家。
extends RefCounted

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
	l.append(["旁白", T("槐木、糯米由營地採集；棺材鋪出棺材板、包子鋪出普通包子；普通包子送去大屋隨身嘅「嘆氣蒸籠」先蒸得成壽包。原本條村嘅建築全部喺大地圖底嘅「營地」（向下拉就見），跟大屋一齊搬。", "槐木、糯米由營地採集；棺材鋪出棺材板、包子鋪出普通包子；普通包子送去大屋隨身的「嘆氣蒸籠」才蒸得成壽包。原本村子的建築全部在大地圖底部的「營地」（往下拉就看到），跟大屋一起搬。")])   # [chain] [camp]
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

# ---------------- 2. 台 ----------------
# 而家呢張圖嘅台（已解鎖）：[{sid, lv, workers:[gh...]}]
static func stations() -> Array:
	var s = S(); var o = []
	if s == null or not (s.get("mv") is Dictionary): return o
	var st = s.mv.get("st", {})
	if not (st is Dictionary): return o
	for sid in st:
		var e = st[sid]
		if not (e is Dictionary) or not J.t(e.get("unlocked", true)): continue
		var lv = J.num(e.get("lv", 1))
		if lv <= 0: continue
		var ws = []
		for gid in (e.get("workers", []) if e.get("workers") is Array else []):
			var gh = ghost(gid)
			if gh != null: ws.append(gh)
		o.append({"sid": str(sid), "lv": lv, "workers": ws})
	return o

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

static func steamed() -> float:   # 嘆氣蒸籠（及其他出壽包嘅台）累計產出壽包
	var s = S()
	if s == null or not (s.get("mv") is Dictionary) or not (s.mv.get("made") is Dictionary): return 0.0
	return J.num(s.mv.made.get("m_shoubao"))

# ---------------- 3. 虛擬建築等級（只升唔跌）----------------
static func mapped_bld() -> Dictionary:
	var s = S(); var c = maxf(0, ci()); var sl = sum_lv()
	var house = clampf(2 + c + floor(sl / 30.0), 1, 20)
	var o = {"house": house}
	o["store"] = (1 + c + floor(sl / 40.0)) if (c >= 1 or sl >= 20) else 0.0
	o["home"] = 1.0 if c >= 1 else 0.0
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
	# [chain] 任務計數（只升唔跌）：包壽包 = 嘆氣蒸籠蒸出嘅壽包數（砍樹／割稻／做板係後院真動作，唔再虛擬）
	var cnt = s.get("cnt")
	if cnt is Dictionary:
		var sb = floor(steamed())
		if J.num(cnt.get("craftBun", 0)) < sb: cnt["craftBun"] = sb

# ---------------- 4. 任務文字（移動村版；只換顯示，唔郁劇情）----------------
# [chain] 砍樹／割稻／做板／起舊建築／升舊建築 = 後院真建築（照舊文字加「後院」），包壽包 = 嘆氣蒸籠
const QTXT := {
	"craftBun": ["用嘆氣蒸籠蒸出 %d 個壽包（普通包子 → 壽包）", "用嘆氣蒸籠蒸出 %d 個壽包（普通包子 → 壽包）"],
}
const BTXT := {
	"bun": ["營地起包子鋪（出普通包子）", "營地建造包子鋪（出普通包子）"],   # [camp] 後院 → 營地
	"store": ["拔營一次或各台合共 20 級", "拔營一次或各台合計 20 級"],
	"altar": ["打低餓鬼王，開招魂台", "打倒餓鬼王，開放招魂台"], "furnace": ["升到 6 級（營地化寶爐）", "升到 6 級（營地化寶爐）"],   # [camp] [qaudit] 招魂台唔使起：打低餓鬼王自動開
}
static func quest_disp(_q, p: Array) -> Array: return p   # 進度照舊（後院建築係真等級）

static func quest_text(q) -> String: return _qx_unify(_quest_text(q), q)   # [qaudit] 全部入口（任務條、任務面板、完成提示、解霧提示）用同一套字
# [qaudit] 合一地圖已經冇「營地」：統一換做村子；野外王任務：王前面仲有頭目要先打，講清楚
static func _qx_unify(s: String, q) -> String:
	s = s.trim_prefix("營地：").replace("營地或者生產台", "村子或者大排檔").replace("營地建造", "建造").replace("（營地招魂台）", "（招魂台）").replace("（營地化寶爐）", "（化寶爐）")
	if on() and q is Dictionary and str(q.get("t", "")) == "stage":
		var ZDq = load("res://game/zone/zone_data.gd")
		var tg = ZDq.stage_target()
		if tg.has("zid") and str(tg.get("sid", "")) == str(q.get("s", "")):
			var bn = ZDq.boss_next(str(tg.zid))
			if bn >= 0 and bn < int(tg.get("bi", 0)):
				s += T("（先打低%s）", "（先打倒%s）") % ZDq.T(ZDq.bosses(str(tg.zid))[bn].get("n", ["", ""]))
	return s
static func _quest_text(q) -> String:
	var txt = str(J.gp(q, "text"))
	if not on() or not (q is Dictionary): return txt
	var t = str(q.get("t", ""))
	if QTXT.has(t): return (QTXT[t][0] if DB.lang == "yue" else QTXT[t][1]) % int(J.num(q.get("n", 1)))
	if t == "build" and BTXT.has(str(q.get("b", ""))):
		var a = BTXT[str(q.b)]; return a[0] if DB.lang == "yue" else a[1]
	if t == "bLevel":
		var b = str(q.get("b", ""))
		if b == "house": return T("紙紮大屋擴建到 %d 級（拔營／升台）" % int(J.num(q.get("n", 1))), "紙紮大屋擴建到 %d 級（拔營／升台）" % int(J.num(q.get("n", 1))))
		if b == "store": return T("大屋倉庫擴到 %d 級（拔營／升台）" % int(J.num(q.get("n", 1))), "大屋倉庫擴到 %d 級（拔營／升台）" % int(J.num(q.get("n", 1))))
	if t in ["chop", "rice", "craftPlank", "build", "bLevel"]: return T("營地：", "營地：") + txt   # [camp] 原本村子嘅建築喺大地圖底「營地」
	if t == "stage" and txt.begins_with("夜班巡陰"):   # [outgate] 新版：主線關卡喺大排檔前面打（唔再經舊世界地圖「夜班巡陰」）
		var sid = str(q.get("s", "")); var nm = sid
		var CH = J.G.get("CHAPTERS"); var p2 = sid.split("-")
		if CH is Array and p2.size() == 2 and int(p2[0]) - 1 < CH.size() and CH[int(p2[0]) - 1].get("stages") is Array and int(p2[1]) - 1 < CH[int(p2[0]) - 1].stages.size():
			nm = str(CH[int(p2[0]) - 1].stages[int(p2[1]) - 1].get("name", sid))
		return T("出村迎戰：%s（%s）" % [nm, sid], "出村迎戰：%s（%s）" % [nm, sid])
	if t == "assign": return T("派 %d 隻鬼去打工（營地或者生產台）" % int(J.num(q.get("n", 1))), "派 %d 隻鬼去打工（營地或者生產台）" % int(J.num(q.get("n", 1))))   # [camp]
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

# ---------------- 6. 安裝包裝（offlineGain）----------------
const SIM = preload("res://game/outpost/mv_sim.gd")
const CE = preload("res://game/outpost/chain_eco.gd")
const M = preload("res://game/outpost/mat.gd")
static func install() -> void:
	var G = J.G
	var og = G.get("offlineGain")
	if og != null and not is_same(G.get("__mv_offline_w"), og):
		G["__mv_offline_orig"] = og
		var w = func(t, a):
			if on(): mv_offline(); return null
			return J.cl(G["__mv_offline_orig"], t, a)
		G["offlineGain"] = w; G["__mv_offline_w"] = w
	_installed = true

static func _sim():
	var sc = scene()
	if sc != null and sc.get("sim") != null: return sc.sim
	var sm = SIM.new(); sm.reg_post(); sm.st(); sm.validate(); sm.sync()
	return sm

# [chain] 離線：後院 produce 同移動村 offline_step 每 60 秒交替行（見檔頭第 6 點）。回總冥幣
static func mv_offline() -> float:
	var s = S()
	if s == null or not on(): return 0.0
	sync()
	CE.migrate(s)
	var last = J.num(s.get("last")) if J.t(s.get("last")) else J.now()
	var raw = maxf(0, J.now() - last)
	var ms = minf(OFFLINE_MAX_MS, raw)
	if ms < 60000:
		return 0.0
	var secs = ms / 1000.0
	var sm = _sim()
	var res0 = (s.res as Dictionary).duplicate(); var mat0 = (s.mat as Dictionary).duplicate()
	var prod = J.G.get("produce")
	var acc = sm.offline_acc(); var t = 0.0
	while t < secs - 1e-6:
		var d = minf(60.0, secs - t)
		J.cl(prod, null, [d])
		sm.offline_step(d, acc)
		t += d
	var r = sm.offline_finish(acc, secs, raw > OFFLINE_MAX_MS)
	s["last"] = J.now()
	# 匯報：舊資源＋新材料淨變化
	var parts = []; var RN = J.G.get("RES_NAMES")
	for k in ["wood", "rice", "planks", "buns", "troops", "coins"]:
		var dd = floor(J.num(s.res.get(k)) - J.num(res0.get(k)))
		if dd > 0: parts.append("%s +%s" % [J.str(RN.get(k)) if RN is Dictionary else k, M.qty(floor(dd))])
	for mid in s.mat:
		var dm = floor(J.num(s.mat.get(mid)) - J.num(mat0.get(mid)))
		if dm > 0: parts.append("%s +%s" % [M.name(str(mid)), M.qty(floor(dm))])
	var sc = scene()
	if sc != null and sc.visible and float(r.coins) > 0.0 and sc.has_method("_show_card"): sc._show_card(r)
	var st = J.G.get("Story")
	if parts.size() and st != null:
		J.mc(st, "queue", [{"style": "sys", "lines": [["系統", T("親，你離開咗 %d 小時 %d 分鐘。後院同大排檔都冇偷懶（最多計 8 小時，上層貨要有下層料先做得）", "親，你離開了 %d 小時 %d 分鐘。後院和大排檔都沒有偷懶（最多計 8 小時，上層貨要有下層料才做得）") % [int(secs / 3600), int(fmod(secs, 3600) / 60)]], ["旁白", T("離線收益：", "離線收益：") + "，".join(parts)]]}])
	return float(r.coins)

# 每 0.5 秒（main.refresh）叫：同步虛擬等級、計數、員工
static func tick() -> void:
	if not on(): return
	if not _installed or not is_same(J.G.get("offlineGain"), J.G.get("__mv_offline_w")): install()
	sync()
