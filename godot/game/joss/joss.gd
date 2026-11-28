# 燒嘢線（joss）：化寶爐改做「陽間包裹」——陽間有人燒嘢落嚟，玩家收件攞額外獎勵。
# 冇 class_name、冇 autoload（熱更新規矩）：用 preload/load("res://game/joss/joss.gd") 叫 static func。
#
# 狀態 S.joss = {v, next(ms 下一件到嘅時間), q:[{k:"n"|節日, t:ms}], seen:{信id:次數}, log:[{id,t,r}], tix:{spd,inc},
#               deco:{id:1}, fest:{"<節日>-<年>":1}, n(總收件數), bd("MMDD" 生日), lvseen(上次見到嘅爐等級)}
# 規則：
#  - 化寶爐建咗（S.bld.furnace ≥ 1）先開始派件；每件相隔 interval_ms(等級)（1 級 40 分鐘 → 10 級 20 分鐘，跟 TIME_SCALE）。
#  - 最多儲 CAP=3 件；儲滿就停表（離線最多儲 3 件），收走一件先再計。
#  - 舊存檔：第一次初始化時，舊化寶爐 CD 已經夠鐘 → 即刻有 1 件；未夠鐘 → 第一件喺舊 CD 完嗰刻到。
#  - 節日（清明、農曆七月、冬至、農曆新年、生日）：當日到嘅第一件變「大包裹」，每個節日每年一次。
#  - 收件：揀一封未睇過（或者睇得最少）嘅信，獎勵 = 信嘅禮物（按等級放大）＋ 基本材料。
extends RefCounted

const PATH := "res://data/nat/joss.json"
const CAP := 3
const MAXLV := 10
const FIRST_MS := 90000.0          # 啱啱起好爐：第一件 90 秒後到（媽試寄）
const OLD_CD := 300.0              # 舊化寶爐冷卻（秒），舊存檔兼容用
const LOG_MAX := 30
const OLD_RES := {"m_wood": "wood", "m_rice": "rice", "m_plank": "planks", "m_shoubao": "buns"}
const MAT_NAMES := {"m_wood": ["槐木", "槐木"], "m_rice": ["糯米", "糯米"], "m_plank": ["棺材板", "棺材板"], "m_shoubao": ["壽包", "壽包"], "m_bao": ["普通包子", "普通包子"]}
const FAC := ["yuan", "chan", "lan"]
const M := preload("res://game/outpost/mat.gd")

static var _D = null
static var _patched := false
static var now_override := -1.0     # 測試用：>0 就當係而家時間（ms）
static var date_override := ""      # 測試用："YYYY-MM-DD"
static var rng := RandomNumberGenerator.new()

# ---------------- 基本 ----------------
static func D() -> Dictionary:
	if _D == null:
		var o = JSON.parse_string(FileAccess.get_file_as_string(PATH)) if FileAccess.file_exists(PATH) else null
		_D = o if o is Dictionary else {}
		for k in ["SENDERS", "DECO", "STRINGS", "LUNAR"]:
			if not (_D.get(k) is Dictionary): _D[k] = {}
		if not (_D.get("LETTERS") is Array): _D["LETTERS"] = []
		rng.randomize()
	return _D
static func yue() -> bool: return DB.lang == "yue"
static func T(yue_s: String, zh_s: String) -> String: return yue_s if yue() else zh_s
static func P(pair) -> String:
	if pair is Array and pair.size() >= 2: return str(pair[0]) if yue() else str(pair[1])
	return str(pair) if pair != null else ""
static func STR(k: String) -> String: return P(D().STRINGS.get(k, ["", ""]))
static func S() -> Variant:
	var s = J.G.get("S")
	if s is Dictionary and not s.is_empty(): return s
	var ml = Engine.get_main_loop()
	var g = ml.root.get_node_or_null("G") if ml is SceneTree else null
	if g != null and g.S is Dictionary and not g.S.is_empty(): return g.S
	return null
static func now() -> float: return now_override if now_override > 0 else Time.get_unix_time_from_system() * 1000.0
static func tscale() -> float:
	var t = J.num(J.G.get("TIME_SCALE")) if J.G.get("TIME_SCALE") != null else 1.0
	return t if t > 0 else 1.0
static func female() -> bool: return DB.hero_female()
static func lv() -> int:
	var s = S()
	if s == null or not (s.get("bld") is Dictionary): return 0
	return int(J.num(s.bld.get("furnace", 0)))
static func letter(id: String) -> Dictionary:
	for o in D().LETTERS: if str(o.id) == id: return o
	return {}

# ---------------- 數值 ----------------
static func interval_min(l: int) -> float:   # 每件相隔（分鐘）
	var k = clampi(l, 1, MAXLV)
	return 40.0 - (k - 1) * 20.0 / (MAXLV - 1)
static func interval_ms(l: int) -> float:
	if early(): return float(TVD().JOSS_EARLY.int_s) * 1000.0 / tscale()   # [tavern] 前期：舊化寶爐 5 分鐘一件
	return interval_min(l) * 60000.0 / tscale()

# ---------------- [tavern] 前期冥幣模式 ----------------
# 大排檔未開（tavern.stall_open() == false）：化寶爐係前期冥幣來源——每件包裹以冥幣為主（媽、爸、表姐、隔籬陳太輪流，間中寄錯地址）。
# 第一次收件＝地府郵政積壓三個月嘅包裹，一次過送到（backlog）。大排檔開咗之後第一次收件：轉「祭品模式」（返回原有來信系統），回傳 shift=true 俾 UI 播 joss_shift。
static func TVD() -> Dictionary: return load("res://game/tavern/tv_gen.gd").D()
static func early() -> bool:
	var tv = load("res://game/tavern/tavern.gd")
	if not tv.ON: return false
	var s = S()
	if s != null and s.get("joss") is Dictionary and str(s.joss.get("mode", "")) == "gift": return false
	return not tv.stall_open()
static func early_coins(l: int, big: bool) -> float:
	var E = TVD().JOSS_EARLY; var s = S()
	var hl = J.num(s.get("lv", 1)) if s != null else 1.0
	return roundf((float(E.base) + float(E.per_lv) * maxi(1, l) + float(E.per_hero) * hl) * (2.5 if big else 1.0))
static func collect_early(j: Dictionary, kind: String) -> Dictionary:
	var l = maxi(1, lv()); var big = kind != "n"
	var E = TVD().JOSS_EARLY; var ss: Array = E.senders
	var first = J.num(j.get("early_n", 0)) <= 0
	var o: Dictionary = ss[0] if first else ss[int(J.num(j.get("early_n", 0))) % (ss.size() - 1)]
	if not first and rng.randf() < 0.1: o = ss[ss.size() - 1]   # 寄錯地址
	var c = early_coins(l, big)
	if o.get("wrong"): c = roundf(c * 0.5)
	var rw = []
	if first:
		c += float(E.backlog)
		rw.append({"k": "coins", "n": float(E.backlog), "label": T("積壓包裹 冥幣 +%d", "積壓包裹 冥幣 +%d") % int(E.backlog), "icon": load("res://ui/res_icon.gd").path("coins")})
	var s = S()
	s.res["coins"] = J.num(s.res.get("coins", 0)) + c
	rw.append({"k": "coins", "n": c - (float(E.backlog) if first else 0.0), "label": T("冥幣 +%d", "冥幣 +%d") % int(c - (float(E.backlog) if first else 0.0)), "icon": load("res://ui/res_icon.gd").path("coins")})
	var mid = "m_wood" if rng.randf() < 0.5 else "m_rice"; var mn = roundf(6 * qmul(l))
	mat_add(mid, mn); rw.append({"k": "mat", "mid": mid, "n": mn, "label": "%s +%d" % [mat_name(mid), int(mn)], "icon": mat_icon(mid)})
	j["early_n"] = J.num(j.get("early_n", 0)) + 1
	j["n"] = J.num(j.n) + 1; j["mode"] = "early"
	var name = str(DB.hero().get("name", "")) if DB.has_method("hero") else ""
	var txt = P(o.t).replace("阿仔／阿女", name if name != "" else ("阿女" if female() else "阿仔")).replace("孩子", name if name != "" else "孩子")
	var labels = []
	for x in rw: labels.append(str(x.label))
	j.log.push_front({"id": "early", "t": now(), "r": "，".join(labels), "k": kind})
	while j.log.size() > LOG_MAX: j.log.pop_back()
	if s.get("cnt") is Dictionary: s.cnt["joss"] = J.num(s.cnt.get("joss", 0)) + 1
	return {"ok": true, "id": "early", "kind": kind, "fest": fest_name(kind), "item": T("一疊冥幣", "一疊冥幣"), "sender": P(o.s), "text": txt, "note": "",
		"shape": "box", "art": "", "rw": rw, "more": j.q.size(), "early": true, "backlog": first, "coins": c}
static func qmul(l: int) -> float: return 1.0 + 0.2 * (clampi(l, 1, MAXLV) - 1)   # 數量倍數
static func rare_mul(l: int) -> float: return 0.3 + 0.15 * clampi(l, 1, MAXLV)      # 稀有信權重倍數
static func quality_text(l: int) -> String:
	if l >= 8: return T("極品（壽包、稀有紙紮常見）", "極品（壽包、稀有紙紮常見）")
	if l >= 5: return T("上等（有機會出壽包）", "上等（有機會出壽包）")
	if l >= 3: return T("中等（多咗棺材板、包）", "中等（棺材板、包子變多）")
	return T("普通（多數係原料）", "普通（大多是原料）")

# ---------------- 狀態 ----------------
static func st() -> Variant:
	var s = S()
	if s == null: return null
	_patch_texts()
	if not (s.get("joss") is Dictionary):
		s["joss"] = {"v": 1.0, "next": 0.0, "q": [], "seen": {}, "log": [], "tix": {"spd": 0.0, "inc": 0.0}, "deco": {}, "fest": {}, "n": 0.0, "bd": _mmdd(_date()), "bd_y0": float(_date().year), "lvseen": 0.0}
		_migrate(s)
	var j = s.joss
	for k in ["seen", "tix", "deco", "fest"]: if not (j.get(k) is Dictionary): j[k] = {}
	for k in ["q", "log"]: if not (j.get(k) is Array): j[k] = []
	for k in ["spd", "inc"]: if j.tix.get(k) == null: j.tix[k] = 0.0
	if j.get("bd") == null or str(j.bd) == "": j["bd"] = _mmdd(_date())
	return j

# 舊存檔：舊化寶爐冷卻狀態轉做第一件包裹嘅到達時間（唔會壞、唔會蝕）
static func _migrate(s: Dictionary) -> void:
	var j = s.joss
	var l = lv()
	if l <= 0: return
	j["lvseen"] = float(l)
	var at = J.num(s.get("furnaceAt", 0))
	var t = now()
	var ready_at = at + OLD_CD * 1000.0 / tscale()
	if at <= 0 or ready_at <= t:
		j.q.append({"k": "n", "t": t}); j["next"] = t + interval_ms(l)
	else:
		j["next"] = ready_at

# 每次查詢都叫：按時間派件（離線都係靠呢度補）
static func tick() -> int:
	var j = st()
	if j == null: return 0
	var l = lv()
	if l <= 0: j["next"] = 0.0; return j.q.size()
	var t = now()
	if J.num(j.get("lvseen", 0)) <= 0:   # 啱啱起好爐
		j["lvseen"] = float(l)
		if J.num(j.n) <= 0 and j.q.is_empty(): j["next"] = t + FIRST_MS / tscale()
	elif float(l) != J.num(j.lvseen): j["lvseen"] = float(l)
	if J.num(j.next) <= 0: j["next"] = t + interval_ms(l)
	var guard = 0
	while t >= J.num(j.next) and guard < 50:
		guard += 1
		if j.q.size() >= CAP:
			j["next"] = t + interval_ms(l); break   # 儲滿：停表，收走先再計
		var at = J.num(j.next)
		j.q.append({"k": _fest_kind(at), "t": at})
		j["next"] = at + interval_ms(l)
	return j.q.size()

static func count() -> int: return tick()
static func ready() -> bool: return lv() > 0 and count() > 0
static func next_left_s() -> float:   # 下一件仲有幾多秒（儲滿 = -1）
	var j = st()
	if j == null or lv() <= 0: return -1.0
	tick()
	if j.q.size() >= CAP: return -1.0
	return maxf(0.0, (J.num(j.next) - now()) / 1000.0 * tscale())
static func tix(k: String) -> int:
	var j = st()
	return int(J.num(j.tix.get(k, 0))) if j != null else 0
# 面板簽名：有變先重畫
static func sig() -> Dictionary:
	var j = st()
	if j == null: return {}
	return {"n": count(), "m": int(ceil(next_left_s() / 60.0)), "spd": tix("spd"), "inc": tix("inc"), "lv": lv(), "d": j.deco.size(), "g": j.log.size()}

# ---------------- 節日 ----------------
static func _date(ms := -1.0) -> Dictionary:
	if ms <= 0 and date_override != "":
		var p = date_override.split("-")
		return {"year": int(p[0]), "month": int(p[1]), "day": int(p[2])}
	var unix = (ms if ms > 0 else now()) / 1000.0
	if date_override != "" and ms > 0 and now_override > 0:
		# 測試：以 date_override 為「而家」嘅日期，ms 偏移幾多日就推幾多日
		var base = Time.get_unix_time_from_datetime_dict(_date(-1.0).merged({"hour": 12, "minute": 0, "second": 0}))
		unix = base + (ms - now_override) / 1000.0
	var bias = Time.get_time_zone_from_system().get("bias", 0) * 60.0   # 玩家本地日期
	return Time.get_datetime_dict_from_unix_time(int(unix + bias))
static func _mmdd(d: Dictionary) -> String: return "%02d%02d" % [int(d.month), int(d.day)]
static func fest_of(d: Dictionary) -> String:
	var md = _mmdd(d); var y = str(int(d.year))
	var LU = D().LUNAR.get(y)
	if LU is Array and LU.size() >= 3:
		if md >= str(LU[1]) and md < str(LU[2]): return "ghost"   # 農曆七月成個月
		var ny = str(LU[0])
		if md >= ny and md <= _add_days(int(d.year), ny, 2): return "cny"   # 初一至初三
	if md >= "0401" and md <= "0412": return "qingming"
	if md == "1221" or md == "1222": return "dongzhi"
	var j = st()
	if j != null and md == str(j.get("bd", "")): return "bday"
	return ""
static func _add_days(y: int, mmdd: String, n: int) -> String:
	var u = Time.get_unix_time_from_datetime_dict({"year": y, "month": int(mmdd.substr(0, 2)), "day": int(mmdd.substr(2, 2)), "hour": 12, "minute": 0, "second": 0})
	return _mmdd(Time.get_datetime_dict_from_unix_time(int(u + n * 86400)))
static func _fest_kind(at_ms: float) -> String:
	var d = _date(at_ms)
	var f = fest_of(d)
	if f == "": return "n"
	var j = st()
	var key = "%s-%d" % [f, int(d.year)]
	if f == "bday" and int(d.year) <= int(J.num(j.get("bd_y0", 0))): return "n"
	if J.t(j.fest.get(key)): return "n"
	j.fest[key] = 1.0
	return f
static func fest_name(k: String) -> String:
	match k:
		"qingming": return T("清明大包裹", "清明大包裹")
		"ghost": return T("七月鬼節大包裹", "七月鬼節大包裹")
		"dongzhi": return T("冬至大包裹", "冬至大包裹")
		"cny": return T("新年大包裹", "新年大包裹")
		"bday": return T("生日大包裹", "生日大包裹")
	return ""

# ---------------- 揀信 ----------------
static func _need_ok(o: Dictionary) -> bool:
	var n = str(o.get("need", ""))
	if n == "": return true
	var s = S()
	if n.begins_with("seen:"): return s != null and s.get("seen") is Dictionary and J.t(s.seen.get(n.substr(5)))
	return true
static func pool_of(kind: String, l: int) -> Array:
	var o = []
	for x in D().LETTERS:
		if str(x.get("pool", "n")) != kind: continue
		if int(J.num(x.get("lv", 1))) > l: continue
		if not _need_ok(x): continue
		o.append(x)
	return o
static func pick(kind: String) -> Dictionary:
	var j = st(); var l = maxi(1, lv())
	if J.num(j.seen.get("ma00", 0)) <= 0 and kind == "n" and not letter("ma00").is_empty(): return letter("ma00")
	var pool = pool_of(kind, l)
	if pool.is_empty(): pool = pool_of("n", l)
	if pool.is_empty(): return {}
	var mn = 1e9
	for x in pool: mn = minf(mn, J.num(j.seen.get(str(x.id), 0)))
	var cand = pool.filter(func(x): return J.num(j.seen.get(str(x.id), 0)) <= mn)
	var tot = 0.0; var ws = []
	for x in cand:
		var w = J.num(x.get("w", 10))
		if _rare(x): w *= rare_mul(l)
		ws.append(w); tot += w
	var r = rng.randf() * tot
	for i in cand.size():
		r -= ws[i]
		if r <= 0: return cand[i]
	return cand[cand.size() - 1]
static func _rare(o: Dictionary) -> bool:
	var g = o.get("g", {})
	return g is Dictionary and (g.has("ghost") or g.has("deco"))

# ---------------- 信嘅文字（跟語言、主角性別、改名） ----------------
static func text_of(o: Dictionary) -> String:
	var t = o.get("f") if female() and o.get("f") is Array else o.get("t")
	return str(DB.N(P(t)))
static func sender_of(o: Dictionary) -> String:
	var sd = D().SENDERS.get(str(o.get("who", "")), {})
	var n = sd.get("nf") if female() and sd.get("nf") is Array else sd.get("n", ["", ""])
	return str(DB.N(P(n)))
static func item_of(o: Dictionary) -> String: return str(DB.N(P(o.get("item", ["", ""]))))
static func note_of(o: Dictionary) -> String: return str(DB.N(P(o.get("note")))) if o.get("note") is Array else ""

# ---------------- 材料 ----------------
static func mat_name(mid: String) -> String:
	if M.has_def(mid): return M.name(mid)
	return P(MAT_NAMES.get(mid, [mid, mid]))
static func mat_amt(mid: String) -> float:
	if M.has_def(mid): return M.amt(mid)
	var s = S()
	if OLD_RES.has(mid): return J.num(s.res.get(OLD_RES[mid], 0)) if s != null else 0.0
	return M.amt(mid)
static func mat_add(mid: String, n: float) -> void:
	if M.has_def(mid): M.add(mid, n); return
	var s = S()
	if s == null: return
	if OLD_RES.has(mid): s.res[OLD_RES[mid]] = J.num(s.res.get(OLD_RES[mid], 0)) + n; return
	M.add(mid, n)
static func mat_icon(mid: String) -> String:   # 回圖片路徑（冇就 ""）
	if OLD_RES.has(mid): return load("res://ui/res_icon.gd").path(OLD_RES[mid])   # [p55] 美術版優先
	return ""

# 基本材料：等級越高，越多半成品／壽包
static func base_bundle(l: int, big: bool) -> Dictionary:
	var r = rng.randf(); var mid = ""; var n = 0.0
	if l >= 6 and r < 0.3: mid = "m_shoubao"; n = 6
	elif l >= 3 and r < 0.65: mid = "m_plank" if rng.randf() < 0.5 else "m_bao"; n = 10
	else: mid = "m_wood" if rng.randf() < 0.5 else "m_rice"; n = 18
	n = round(n * qmul(l) * (2.5 if big else 1.0))
	return {mid: n}

# ---------------- 收件 ----------------
# 回：{ok, id, kind, fest, item, sender, text, note, shape, art, rw:[{k, label, icon, mid, n}], more}
static func collect() -> Dictionary:
	var j = st()
	if j == null or count() <= 0: return {"ok": false}
	var p = j.q.pop_front()
	var kind = str(p.get("k", "n"))
	if early(): return collect_early(j, kind)   # [tavern] 前期冥幣模式
	var shift = str(j.get("mode", "")) == "early"   # [tavern] 大排檔開咗後第一次收件：轉祭品模式
	j["mode"] = "gift"
	var o = pick(kind if kind != "n" else "n")
	if o.is_empty(): return {"ok": false}
	var l = maxi(1, lv()); var big = kind != "n"
	var rw = []
	var g: Dictionary = o.get("g", {})
	var mats = {}
	if g.get("mat") is Dictionary:
		for k in g.mat: mats[str(k)] = J.num(mats.get(str(k), 0)) + round(J.num(g.mat[k]) * qmul(l) * (1.5 if big else 1.0))
	var bb = base_bundle(l, big)
	for k in bb: mats[k] = J.num(mats.get(k, 0)) + bb[k]
	for k in mats:
		mat_add(k, mats[k])
		rw.append({"k": "mat", "mid": k, "n": mats[k], "label": "%s +%d" % [mat_name(k), int(mats[k])], "icon": mat_icon(k)})
	if g.has("tix"):
		var tk = str(g.tix); var tn = 2.0 if big else 1.0
		j.tix[tk] = J.num(j.tix.get(tk, 0)) + tn
		rw.append({"k": "tix", "t": tk, "n": tn, "label": "%s ×%d" % [tix_name(tk), int(tn)]})
	if g.has("gear"):
		var it = give_gear(str(g.gear), big)
		if not it.is_empty(): rw.append({"k": "gear", "label": T("裝備：", "裝備：") + str(it.name), "it": it.id})
	if g.has("ghost"):
		rw.append(give_ghost(g.ghost))
	if g.has("deco"):
		rw.append(give_deco(str(g.deco), l))
	if big and not g.has("tix"):
		var tk2 = "spd" if rng.randf() < 0.5 else "inc"
		j.tix[tk2] = J.num(j.tix.get(tk2, 0)) + 1
		rw.append({"k": "tix", "t": tk2, "n": 1.0, "label": "%s ×1" % tix_name(tk2)})
	var id = str(o.id)
	j.seen[id] = J.num(j.seen.get(id, 0)) + 1
	j["n"] = J.num(j.n) + 1
	var labels = []
	for x in rw: labels.append(str(x.label))
	j.log.push_front({"id": id, "t": now(), "r": "，".join(labels), "k": kind})
	while j.log.size() > LOG_MAX: j.log.pop_back()
	var s = S()
	if s != null and s.get("cnt") is Dictionary: s.cnt["joss"] = J.num(s.cnt.get("joss", 0)) + 1
	return {"ok": true, "id": id, "kind": kind, "fest": fest_name(kind), "item": item_of(o), "sender": sender_of(o), "text": text_of(o), "note": note_of(o),
		"shape": str(o.get("shape", "box")), "art": str(o.get("art", "")), "rw": rw, "more": j.q.size(), "shift": shift}

# 舊信重溫（唔再派獎勵）
static func reread(entry: Dictionary) -> Dictionary:
	var o = letter(str(entry.get("id", "")))
	if o.is_empty(): return {"ok": false}
	return {"ok": true, "id": str(o.id), "kind": str(entry.get("k", "n")), "fest": fest_name(str(entry.get("k", "n"))), "item": item_of(o), "sender": sender_of(o),
		"text": text_of(o), "note": note_of(o), "shape": str(o.get("shape", "box")), "art": str(o.get("art", "")), "rw": [], "old": str(entry.get("r", "")), "more": 0}

# ---------------- 獎勵：裝備／紙紮員工／裝飾／加速卡 ----------------
static func tix_name(k: String) -> String:
	return T("加速卡", "加速卡") if k == "spd" else T("收益×2卡", "收益×2卡")
static var _PD = null
static func _gear_names() -> Dictionary:
	if _PD == null:
		var o = JSON.parse_string(FileAccess.get_file_as_string("res://data/nat/patrol.json")) if FileAccess.file_exists("res://data/nat/patrol.json") else null
		_PD = o.get("GEAR", {}).get("NAMES", {}) if o is Dictionary and o.get("GEAR") is Dictionary else {}
	return _PD
static func gear_tier() -> int:
	var s = S(); var c = 0
	if s != null and s.get("cleared") is Dictionary:
		for k in s.cleared:
			if J.t(s.cleared[k]) and str(k).contains("-"): c = maxi(c, int(str(k).split("-")[0]) - 1)
	return clampi(c, 0, 5)
static func give_gear(slot: String, big: bool) -> Dictionary:
	var s = S()
	if s == null: return {}
	if not (s.get("gear") is Dictionary): s["gear"] = {"items": [], "uid": 1.0}
	var gs = s.gear
	if not (gs.get("items") is Array): gs["items"] = []
	var c = gear_tier()
	if not big and lv() < 4: c = maxi(0, c - 1)
	var fi = rng.randi() % 3
	var uid = J.num(gs.get("uid", 1)); gs["uid"] = uid + 1
	var it = {"id": "e" + J.str(uid), "slot": slot, "c": float(c), "f": FAC[fi], "lv": 1.0, "who": null, "jz": 1.0}
	gs.items.append(it)
	var NM = _gear_names(); var nm = ""
	var l = NM.get(slot)
	if l is Array and c < l.size():
		var row = l[c]
		nm = str(row[0]) if slot == "acc" else str(row[fi])
	return {"id": it.id, "name": T("紙紮", "紙紮") + nm}
static func give_ghost(pair) -> Dictionary:
	var s = S()
	var fc = J.num(J.cl(J.G.get("fodderCount"), null, [])) if J.G.get("fodderCount") != null else 0.0
	var cap = J.num(J.mc(J.G.get("F"), "rosterCap", [])) if J.G.get("F") is Dictionary else 5.0
	var pre = P(pair)
	if s == null or fc >= cap:
		if s != null and s.get("chests") is Dictionary: s.chests["p"] = J.num(s.chests.get("p", 0)) + 1
		return {"k": "chest", "label": T("%s想入村，但係冇位住（民宅滿咗）→ 留低紫箱 ×1", "%s想入村，但沒地方住（民宅滿了）→ 留下紫箱 ×1") % pre}
	var NK = J.G.get("NICKS"); var used = {}
	for g in s.ghosts: used[str(g.name)] = true
	var name = pre
	if NK is Array and NK.size():
		for i in 40:
			name = pre + "・" + str(NK[rng.randi() % NK.size()])
			if not used.has(name): break
	var st = []
	for i in 3: st.append(round((15 + rng.randf() * 32) * 1.45))
	var uid = J.num(s.get("uid", 1)); s["uid"] = uid + 1
	var g = {"id": "g" + J.str(uid), "k": "zhiren", "name": name, "q": "紫", "lv": 1.0, "st": st, "post": null, "spent": 0.0, "jz": 1.0}
	s.ghosts.append(g)
	return {"k": "ghost", "label": T("紙紮員工：", "紙紮員工：") + name + T("（紫，雜鬼）", "（紫，雜鬼）"), "gid": g.id}
static func give_deco(id: String, l: int) -> Dictionary:
	var j = st()
	var dd = D().DECO.get(id, {})
	var nm = P(dd.get("n", [id, id]))
	if J.t(j.deco.get(id)):
		var n = round(8 * qmul(l)); mat_add("m_shoubao", n)
		return {"k": "mat", "mid": "m_shoubao", "n": n, "label": T("%s（已經有）→ 壽包 +%d", "%s（已擁有）→ 壽包 +%d") % [nm, int(n)], "icon": mat_icon("m_shoubao")}
	j.deco[id] = now()
	return {"k": "deco", "label": T("限定裝飾：", "限定裝飾：") + nm, "deco": id}

# 加速卡／收益×2卡：移動村 boost 直接開（唔理冷卻，亦唔加冷卻）
static func can_use_tix() -> bool:
	var s = S()
	return s != null and s.get("mv") is Dictionary
static func use_tix(k: String) -> bool:
	var j = st(); var s = S()
	if j == null or tix(k) <= 0 or not can_use_tix(): return false
	var MD = load("res://game/outpost/mv_data.gd")
	var B = MD.BOOST_INC if k == "inc" else MD.BOOST_SPD
	if not (s.mv.get("boost") is Dictionary): s.mv["boost"] = {"inc_end": 0.0, "inc_cd": 0.0, "spd_end": 0.0, "spd_cd": 0.0}
	var bo = s.mv.boost; var key = k + "_end"; var t = J.now()
	bo[key] = maxf(t, J.num(bo.get(key, 0))) + float(B.dur) * 1000.0
	j.tix[k] = J.num(j.tix[k]) - 1
	return true

# ---------------- 舊文字修正（化寶爐唔再燒冥幣） ----------------
static func _patch_texts() -> void:
	if _patched and J.G.get("__joss_patched") != null: return
	_patched = true; J.G["__joss_patched"] = true
	for src in [J.G, DB.D]:
		if not (src is Dictionary): continue
		var B = src.get("BUILDINGS")
		if B is Dictionary and B.get("furnace") is Dictionary: B.furnace["desc"] = STR("desc")
		var FL = src.get("FLAVOR")
		if FL is Dictionary and FL.has("furnace"): FL["furnace"] = STR("flavor")
		var LU = src.get("LEVEL_UNLOCKS")
		if LU is Dictionary:
			for k in ["6", 6, 6.0]:
				var u = LU.get(k)
				if u is Dictionary:
					u["desc"] = STR("unlock_d")
					if u.get("lines") is Array and u.lines.size() and u.lines[0] is Array and u.lines[0].size() >= 2: u.lines[0][1] = STR("unlock")
static func repatch() -> void: _patched = false; _patch_texts()
