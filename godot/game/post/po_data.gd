# [post] 野外 v2：外派駐點（普通據點打贏＝佔領，派鬼做主任自動出資源，幫派反撲要守）＋名鬼據點可刷（名鬼按品級請假，銷假先再掉主魂）
#   const PO = preload("res://game/post/po_data.gd")（全部 static；冇 class_name、冇 autoload：熱更新規矩）
#   設計：meeting-assets wild/design_wild_v2.md。數值、權重表、文案全部喺 data/nat/wild2.json（介面顯示同實際計算讀同一個檔）。
#   只對 wild2.json maps 入面嘅圖生效（第一批＝第 1 關 ci 0）；其他圖照舊（按圈重生、舊魂魄公式）。GB_NOPOST=1 強制關。
#
# 據點分法：第 4 圈全部、每圈關鍵據點（ring_key）、魔王據點＝名鬼據點（唔可以佔領）；其餘＝普通據點（可以佔領）。
#
# 存檔 S.post = {v:1,
#   p:{"<ci>:<id>": {held:1, lost:0/1, chief:<鬼 id>|"", acc:<ms 上次結算>, coins:<收銀箱冥幣>, planks:<收銀箱棺材板>, boost:<ms 加成到幾時>}},
#   cd:{"<ci>:<id>": <ms 名鬼幾時銷假>},  fk:{"<鬼 k>": 1 已首殺},  n_open:<累計開張>, n_repel:<累計擊退反撲>, n_lost:<累計失守>}
#
# 規則：
#   產出（每個駐點、有主任先有）：每小時 冥幣 = wins_h × win_coin_lv × 據點等級；棺材板 = wins_h × win_plank[圈]；
#        親自擊退反撲後 boost_min 分鐘 ×boost；酒館鬼肚餓 ×0.5、罷工 ×0（tavern.work_mul）。
#   收銀箱：主任係名鬼＝自動入賬（直接入 S.res）；普通鬼＝入收銀箱，最多存 till_h 小時嘅基本產量，滿咗停，要玩家收。
#   離線：一次結算最多補 off_h 小時。
#   反撲（raid.gd 目標 "p:<ci>:<id>"，同村子襲擾共用一個計時器，一次只嚟一隊）：
#        守備 = 主任等級 × (名鬼 def_named／普通鬼 def_plain)；來犯 = foe_base + foe_lv × 據點等級 × retake_k（唔隨次數變強）
#        守備 ≥ 來犯＝自動擊退；唔夠＝圍住，可以親自迎戰（敵陣＝據點原班人馬，強度 × retake_k）或者派包子打發（第 1 關「討飯」）
#        親自打贏：boost ＋ 領隊名鬼掉主魂（抽權重表）；冇守住：停業整頓（收銀箱 × (1 − fail_store)、主任返村、停產），要再打贏一次收復。
#        一次反撲只影響 1 個駐點；解霧、拔營、KPI 完全唔讀呢度嘅「而家狀態」，只讀首勝／首殺／累計數。
#   第 1 關「討飯」：收銀箱越滿越易被揀中（權重 1 + beg_w × 滿度）；任何一個駐點滿度 ≥ beg_fill → 下次反撲間隔 × beg_gap。
#   名鬼據點：打贏（名鬼在場）→ 首殺（每隻名鬼第一次）必掉 first[品]；之後每場抽 weights[品]（冇「空手」）；
#        之後名鬼請假 cd_min[品] 分鐘（真實時間，離線照計）；請假期間據點照打得（代班頭目），唔掉主魂。取消每日打折。
extends RefCounted

const PATH := "res://data/nat/wild2.json"
const TKEY := "p:"
static var _D = null
static var test_now := -1.0
static var rng := RandomNumberGenerator.new()
static var LOG: Array = []
static var NEWS: Array = []          # 畫面提示佇列（po_view 讀）
static var force_off := false

# ======================= 共用 =======================
static func D() -> Dictionary:
	if _D == null:
		_D = {}
		if FileAccess.file_exists(PATH):
			var j = JSON.parse_string(FileAccess.get_file_as_string(PATH))
			if j is Dictionary: _D = j
	return _D
static func reload() -> void: _D = null
static func P() -> Dictionary: return D().get("post", {})
static func N() -> Dictionary: return D().get("named", {})
static func S():
	var s = J.G.get("S")
	return s if s is Dictionary and not s.is_empty() else null
static func now_ms() -> float: return test_now if test_now >= 0 else Time.get_unix_time_from_system() * 1000.0
static func _SO(): return load("res://game/sortie/so_data.gd")
static func _ZD(): return load("res://game/zone/zone_data.gd")
static func _SOUL(): return load("res://game/soul/soul_data.gd")
static func _BK(): return load("res://game/barracks/bk_data.gd")
static func zh() -> bool: return DB.lang != "yue"
static func L(yue: String, zhs: String) -> String: return str(DB.N(zhs if zh() else yue))
static func T(a) -> String:
	if a is Array and a.size() >= 2: return str(DB.N(str(a[1]) if zh() else str(a[0])))
	return str(a) if a != null else ""
static func off() -> bool: return force_off or OS.has_environment("GB_NOPOST") or D().is_empty()
static func on_for(c: int) -> bool:
	if off(): return false
	for x in D().get("maps", []): if int(J.num(x)) == c: return true
	return false
static func key(e: Dictionary) -> String: return "%d:%s" % [int(J.num(e.get("c", 0))), str(e.get("id", ""))]
static func camp_of(k: String) -> Dictionary:   # "<ci>:<id>" → 據點
	var p = k.split(":")
	if p.size() < 2: return {}
	return _SO().camp(p[1], int(p[0]))

# ======================= 據點分法 =======================
static func is_named(e: Dictionary) -> bool:   # 名鬼據點（唔可以佔領）
	if e.is_empty(): return true
	if int(J.num(e.get("ring", 1))) >= 4 or str(e.get("bm", "")) != "" or e.has("lg"): return true
	return J.t(_ZD().sortie(str(e.get("id", "")), int(J.num(e.get("c", 0)))).get("ring_key"))
static func is_post(e: Dictionary) -> bool:   # 普通據點（可以佔領）
	return not e.is_empty() and not J.t(e.get("tmp")) and on_for(int(J.num(e.get("c", 0)))) and not is_named(e)
static func posts(c: int) -> Array:
	var o = []
	if not on_for(c): return o
	for e in _SO().camps(c): if is_post(e): o.append(e)
	return o
static func named(c: int) -> Array:
	var o = []
	if not on_for(c): return o
	for e in _SO().camps(c): if is_named(e): o.append(e)
	return o

# ======================= 存檔 =======================
static func st():
	var s = S()
	if s == null: return null
	if not (s.get("post") is Dictionary): s["post"] = {"v": 1.0}
	var o = s.post
	for f in ["p", "cd", "fk"]: if not (o.get(f) is Dictionary): o[f] = {}
	for f in ["n_open", "n_repel", "n_lost"]: if o.get(f) == null: o[f] = 0.0
	if int(J.num(o.get("mig", 0))) < 1: _migrate(s, o)
	return o
static func pst(e: Dictionary):   # 呢個駐點嘅狀態（未佔領＝null）
	var o = st()
	if o == null: return null
	var d = o.p.get(key(e))
	return d if d is Dictionary else null
# 舊存檔：已經首勝過嘅普通據點＝已佔領但主任位空（唔派人唔出嘢，唔會一入遊戲多一筆錢）；名鬼據點重生倒數清零
static func _migrate(s: Dictionary, o: Dictionary) -> void:
	o["mig"] = 1.0
	var so = s.get("sortie")
	if not (so is Dictionary) or not (so.get("camps") is Dictionary): return
	for mc in D().get("maps", []):
		var c = int(J.num(mc))
		for e in _SO().camps(c):
			var d = so.camps.get(key(e))
			if not (d is Dictionary): continue
			if is_post(e):
				if J.t(d.get("first")) and not o.p.has(key(e)):
					o.p[key(e)] = _blank(); o["n_open"] = J.num(o.n_open) + 1.0
				d["clr"] = 0.0
			elif J.t(d.get("first")):
				var g = _SOUL().guard_of(e)
				if g != "": o.fk[g] = 1.0   # 舊版首勝已經攞過見面禮：唔再補首殺
	LOG.append(["migrate", o.p.size()])
static func _blank() -> Dictionary:
	return {"held": 1.0, "lost": 0.0, "chief": "", "acc": now_ms(), "coins": 0.0, "planks": 0.0, "boost": 0.0}

# ======================= 狀態 =======================
static func held(e: Dictionary) -> bool: return pst(e) != null
static func lost(e: Dictionary) -> bool:
	var d = pst(e)
	return d != null and J.t(d.get("lost"))
# so_data.state() 掛鈎：回 ""＝照舊；"held"＝營業中／空缺（唔使打）；"lost"＝停業整頓（可以出擊收復）
static func camp_state(e: Dictionary) -> String:
	if not is_post(e): return ""
	var d = pst(e)
	if d == null: return ""
	return "lost" if J.t(d.get("lost")) else "held"
static func chief(e: Dictionary):   # 主任（鬼 dict）／null
	var d = pst(e)
	if d == null or str(d.get("chief", "")) == "": return null
	var g = _BK().ghost(d.chief)
	if g == null or str(g.get("post", "")) != post_id(e): d["chief"] = ""; return null   # 隻鬼冇咗／畀人調走
	return g
static func post_id(e: Dictionary) -> String: return "wp:" + key(e)   # g.post 用（唔喺 POSTS＝bk_data.job() 當「村外工作」）
static func gname(g) -> String:
	if not (g is Dictionary): return ""
	if g.get("gen") is Dictionary and str(g.gen.get("name", "")) != "": return str(DB.N(str(g.gen.name)))
	if str(g.get("name", "")) != "": return str(DB.N(str(g.name)))
	return _SOUL().gname(str(g.get("k", "")))
static func is_named_ghost(g) -> bool: return g is Dictionary and J.str(g.get("q")) == "名"
static func camp_name(e: Dictionary) -> String:
	var ct = load("res://game/counter/ct_data.gd").camp(str(e.get("id", "")))
	var gang = str(ct.get("gang", "")) if ct is Dictionary else ""
	var nm = L("%s駐點辦事處", "%s駐點辦事處") % (str(DB.N(gang)) if gang != "" else "")
	return nm

# ======================= 佔領／派人 =======================
# so_data.reward() 掛鈎：普通據點打贏。回 "open"（第一次佔領）／"retake"（收復）／""
static func on_win(e: Dictionary) -> String:
	if not is_post(e): return ""
	var o = st(); var d = pst(e)
	if d == null:
		o.p[key(e)] = _blank(); o["n_open"] = J.num(o.n_open) + 1.0
		NEWS.append({"k": "open", "key": key(e)})
		LOG.append(["open", key(e)])
		return "open"
	if J.t(d.get("lost")):
		d["lost"] = 0.0; d["acc"] = now_ms()
		NEWS.append({"k": "retake", "key": key(e)})
		LOG.append(["retake", key(e)])
		return "retake"
	return ""
# 可以派去做主任嘅鬼（閒著／出陣／村子工位都列，揀咗會調走；主角、已經外派嘅唔列）
static func candidates() -> Array:
	var s = S(); var o = []
	if s == null: return o
	for g in J.iter(s.get("ghosts")):
		if not (g is Dictionary) or J.str(g.get("k")) == "afu": continue
		var jb = _BK().job(g)
		if jb == "away" or jb == "cap_def" or jb == "cap_sweep": continue
		o.append(g)
	o.sort_custom(_cand_lt)
	return o
static func _cand_lt(a, b) -> bool:   # 閒著嘅排先，之後按等級
	var ja = 0 if _BK().job(a) == "idle" else 1; var jb2 = 0 if _BK().job(b) == "idle" else 1
	if ja != jb2: return ja < jb2
	return _BK().glv(a) > _BK().glv(b)
# 派主任：回 "ok" 或者原因
static func assign(e: Dictionary, gid) -> String:
	var d = pst(e)
	if d == null: return L("呢度未佔領", "這裡還沒佔領")
	if J.t(d.get("lost")): return L("停業整頓緊，要打返贏先", "停業整頓中，要先打贏收復")
	var g = _BK().ghost(gid)
	if g == null: return L("搵唔到呢隻鬼", "找不到這隻鬼")
	if J.str(g.get("k")) == "afu": return L("村長行唔開", "村長走不開")
	var jb = _BK().job(g)
	if jb == "away": return L("佢喺村外做緊嘢", "他在村外工作中")
	accrue(e)
	recall(e, false)
	_BK().clear_roles(g)   # 一鬼一職：由出陣／村子工位／隊長全部移走
	g["post"] = post_id(e)
	d["chief"] = g.get("id"); d["acc"] = now_ms()
	LOG.append(["assign", key(e), J.str(gid)])
	_save()
	return "ok"
# 叫返主任（收銀箱照留）
static func recall(e: Dictionary, save := true) -> void:
	var d = pst(e)
	if d == null: return
	accrue(e)
	var g = _BK().ghost(d.get("chief")) if str(d.get("chief", "")) != "" else null
	if g != null and str(g.get("post", "")) == post_id(e): g["post"] = null
	d["chief"] = ""
	if save: LOG.append(["recall", key(e)]); _save()

# ======================= 產出 =======================
static func ri(e: Dictionary) -> int: return clampi(int(J.num(e.get("ring", 1))), 1, 4) - 1
# 基本每小時產量（唔計加成、肚餓）：介面顯示同結算都用呢個
static func base_rate(e: Dictionary) -> Dictionary:
	var p = P()
	var wp = p.get("win_plank", [4, 8, 14, 20])
	return {"coins": float(p.get("wins_h", 3.0)) * float(p.get("win_coin_lv", 50.0)) * float(e.get("lv", 1.0)),
		"planks": float(p.get("wins_h", 3.0)) * float(wp[ri(e)])}
static func work_mul(e: Dictionary) -> float:   # 主任肚餓／罷工
	var g = chief(e)
	if g == null: return 0.0
	return float(load("res://game/tavern/tavern.gd").work_mul(g))
static func boost_on(e: Dictionary, t := -1.0) -> bool:
	var d = pst(e)
	return d != null and J.num(d.get("boost", 0)) > (now_ms() if t < 0 else t)
# 而家每小時產量（介面顯示）：{coins, planks, mul}
static func rate(e: Dictionary) -> Dictionary:
	var b = base_rate(e); var d = pst(e)
	var m = 0.0
	if d != null and not J.t(d.get("lost")) and chief(e) != null:
		m = work_mul(e) * (float(P().get("boost", 1.5)) if boost_on(e) else 1.0)
	return {"coins": b.coins * m, "planks": b.planks * m, "mul": m}
static func auto_bank(e: Dictionary) -> bool: return is_named_ghost(chief(e))   # 名鬼主任：自動入賬
static func till_cap(e: Dictionary) -> Dictionary:
	var b = base_rate(e); var h = float(P().get("till_h", 2.0))
	return {"coins": b.coins * h, "planks": b.planks * h}
static func till(e: Dictionary) -> Dictionary:
	var d = pst(e)
	return {"coins": J.num(d.get("coins", 0)), "planks": J.num(d.get("planks", 0))} if d != null else {"coins": 0.0, "planks": 0.0}
static func fill(e: Dictionary) -> float:   # 收銀箱滿度 0–1
	var c = till_cap(e); var t = till(e)
	return clampf(t.coins / c.coins, 0.0, 1.0) if c.coins > 0 else 0.0
static func till_full(e: Dictionary) -> bool: return not auto_bank(e) and fill(e) >= 0.999
# 結算到而家（或者 t1）：分段計加成；一次最多補 off_h 小時。回今次加咗幾多 {coins, planks}
static func accrue(e: Dictionary, t1 := -1.0) -> Dictionary:
	var out = {"coins": 0.0, "planks": 0.0}
	var d = pst(e)
	if d == null: return out
	var t = now_ms() if t1 < 0 else t1
	var t0 = J.num(d.get("acc", t))
	d["acc"] = t
	if t <= t0 or J.t(d.get("lost")) or chief(e) == null: return out
	var cap_ms = float(P().get("off_h", 8.0)) * 3600000.0
	if t - t0 > cap_ms: t0 = t - cap_ms
	var b = base_rate(e); var wm = work_mul(e)
	var bo = float(P().get("boost", 1.5)); var bt = J.num(d.get("boost", 0))
	var h_b = clampf(minf(t, bt) - t0, 0.0, t - t0) / 3600000.0   # 加成期間嘅鐘數
	var h_n = (t - t0) / 3600000.0 - h_b
	var k = wm * (h_n + h_b * bo)
	var gc = b.coins * k; var gp = b.planks * k
	if auto_bank(e):
		var s = S()
		s.res["coins"] = J.num(s.res.get("coins", 0)) + gc
		s.res["planks"] = J.num(s.res.get("planks", 0)) + gp
		d["banked"] = J.num(d.get("banked", 0)) + gc
	else:
		var c = till_cap(e)
		var nc = minf(c.coins, J.num(d.get("coins", 0)) + gc); var np = minf(c.planks, J.num(d.get("planks", 0)) + gp)
		gc = nc - J.num(d.get("coins", 0)); gp = np - J.num(d.get("planks", 0))
		d["coins"] = nc; d["planks"] = np
	out.coins = gc; out.planks = gp
	return out
static func accrue_all(t1 := -1.0) -> void:
	var o = st()
	if o == null: return
	for k in o.p.keys():
		var e = camp_of(str(k))
		if not e.is_empty(): accrue(e, t1)
# 收錢：回 {coins, planks}
static func collect(e: Dictionary) -> Dictionary:
	var d = pst(e); var out = {"coins": 0.0, "planks": 0.0}
	if d == null: return out
	accrue(e)
	var s = S()
	out.coins = floor(J.num(d.get("coins", 0))); out.planks = floor(J.num(d.get("planks", 0)))
	if out.coins <= 0 and out.planks <= 0: return out
	s.res["coins"] = J.num(s.res.get("coins", 0)) + out.coins
	s.res["planks"] = J.num(s.res.get("planks", 0)) + out.planks
	d["coins"] = J.num(d.get("coins", 0)) - out.coins; d["planks"] = J.num(d.get("planks", 0)) - out.planks
	LOG.append(["collect", key(e), out])
	_save()
	return out
static func collect_all() -> Dictionary:
	var o = st(); var out = {"coins": 0.0, "planks": 0.0}
	if o == null: return out
	for k in o.p.keys():
		var e = camp_of(str(k))
		if e.is_empty(): continue
		var g = collect(e)
		out.coins += g.coins; out.planks += g.planks
	return out
static var _tick_ms := 0
static func tick() -> void:   # ui/main.gd _mv_tick 每 0.5 秒
	if off() or S() == null: return
	var ms = Time.get_ticks_msec()
	if ms - _tick_ms < 1000: return
	_tick_ms = ms
	accrue_all()

# ======================= 反撲（raid.gd 掛鈎） =======================
static func tkey(e: Dictionary) -> String: return TKEY + key(e)
static func is_tkey(k: String) -> bool: return k.begins_with(TKEY)
static func camp_of_t(k: String) -> Dictionary: return camp_of(k.substr(TKEY.length())) if is_tkey(k) else {}
static func raid_targets(c: int) -> Array:   # 營業中（有冇主任都會嚟）嘅駐點
	var o = []
	for e in posts(c):
		var d = pst(e)
		if d != null and not J.t(d.get("lost")): o.append(tkey(e))
	return o
static func def_pow(e: Dictionary) -> int:   # 守備
	var g = chief(e)
	if g == null: return 0
	var p = P()
	return int(round(_BK().glv(g) * float(p.get("def_named", 12.0) if is_named_ghost(g) else p.get("def_plain", 6.0))))
static func foe_pow(e: Dictionary) -> int:   # 來犯（唔隨次數變強）
	var p = P()
	return int(round(float(p.get("foe_base", 10.0)) + float(p.get("foe_lv", 8.0)) * float(e.get("lv", 1.0)) * float(p.get("retake_k", 0.8))))
static func leader(e: Dictionary) -> String: return _SOUL().guard_of(e)   # 反撲領隊＝據點原本嘅駐守名鬼
# 揀目標（begin_warn）：第 1 關「討飯」收銀箱越滿越易中
static func pick_target(ts: Array) -> String:
	var w = []; var sum = 0.0
	for k in ts:
		var x = 1.0
		if is_tkey(str(k)): x = 1.0 + float(P().get("beg_w", 2.0)) * fill(camp_of_t(str(k)))
		w.append(x); sum += x
	var r = rng.randf() * sum
	for i in ts.size():
		r -= w[i]
		if r <= 0: return str(ts[i])
	return str(ts[ts.size() - 1])
static func gap_mul(c: int) -> float:   # 下次反撲間隔倍數
	for e in posts(c):
		var d = pst(e)
		if d != null and not J.t(d.get("lost")) and fill(e) >= float(P().get("beg_fill", 0.5)): return float(P().get("beg_gap", 0.75))
	return 1.0
# 親自迎戰嘅敵陣：據點原班人馬（領隊照出），強度 × retake_k
static func fight_stage(e: Dictionary) -> Dictionary:
	var stg = _SO().stage_of(e)
	stg = _SOUL().guard_stage(e, stg)
	var en = (stg.get("en", []) as Array).duplicate()
	var CH = J.G.get("CHAPTERS"); var bg = str(stg.get("bg", "field"))
	var nm = L("%s反撲", "%s反撲") % camp_name(e).replace(L("駐點辦事處", "駐點辦事處"), "")
	return {"stage": {"name": nm, "p": maxf(1.0, float(e.get("lv", 1.0)) * float(P().get("retake_k", 0.8))), "en": en, "boss": en[en.size() - 1] if en.size() else ""},
		"bg": bg, "sid": L("反撲", "反撲") + "·" + key(e)}
# 擊退：how＝auto／fight／feed。回魂魄一行（親自打贏先有）
static func on_repel(e: Dictionary, how: String) -> String:
	var o = st(); var d = pst(e)
	if d == null: return ""
	accrue(e)
	o["n_repel"] = J.num(o.n_repel) + 1.0
	var line = ""
	if how == "fight":
		d["boost"] = now_ms() + float(P().get("boost_min", 30.0)) * 60000.0
		var k = leader(e)
		if k != "" and _SOUL().guard_live(e):
			var r = roll(k)
			var g = _SOUL().gain(k, int(r.n), "repel")
			line = L("領隊%s魂魄 +%d（%s）%s", "領隊%s魂魄 +%d（%s）%s") % [_SOUL().gname(k), int(r.n), r.name, r.say]
			d["last_roll"] = r
	NEWS.append({"k": "repel", "key": key(e), "how": how, "line": line})
	LOG.append(["repel", key(e), how, line])
	return line
# 冇守住：停業整頓。回丟咗幾多 {coins, planks}
static func on_lost(e: Dictionary) -> Dictionary:
	var o = st(); var d = pst(e); var out = {"coins": 0.0, "planks": 0.0}
	if d == null: return out
	accrue(e)
	var f = float(P().get("fail_store", 0.3))
	out.coins = J.num(d.get("coins", 0)) * f; out.planks = J.num(d.get("planks", 0)) * f
	d["coins"] = J.num(d.get("coins", 0)) - out.coins; d["planks"] = J.num(d.get("planks", 0)) - out.planks
	recall(e, false)
	d["lost"] = 1.0; d["boost"] = 0.0
	o["n_lost"] = J.num(o.n_lost) + 1.0
	NEWS.append({"k": "lost", "key": key(e), "coins": out.coins, "planks": out.planks})
	LOG.append(["lost", key(e), out])
	_save()
	return out
# 第 1 關「討飯」：派包子打發（反撲預告／圍住期間）。回 "ok" 或者原因
static func feed_cost() -> float: return float(P().get("feed_buns", 20.0))
static func can_feed() -> bool:
	var RAID = load("res://game/raid/raid.gd")
	var r = RAID._peek()
	if r == null or not (r.get("cur") is Dictionary) or not is_tkey(str(r.cur.get("tgt", ""))): return false
	if r.get("fight") is Dictionary: return false
	return str(r.get("ph", "")) in ["warn", "siege"]
static func feed() -> String:
	if not can_feed(): return L("而家冇反撲", "現在沒有反撲")
	var s = S()
	if J.num(s.res.get("buns", 0)) < feed_cost(): return L("壽包唔夠（要 %d 個）", "壽包不夠（要 %d 個）") % int(feed_cost())
	s.res["buns"] = J.num(s.res.get("buns", 0)) - feed_cost()
	load("res://game/raid/raid.gd").repel("feed")
	return "ok"

# ======================= 名鬼據點：請假／魂魄 =======================
static func cd_left_s(e: Dictionary) -> float:   # 名鬼仲有幾耐銷假（0＝在場）
	var o = st()
	if o == null or not on_for(int(J.num(e.get("c", 0)))): return 0.0
	return maxf(0.0, (J.num(o.cd.get(key(e), 0)) - now_ms()) / 1000.0)
static func guard_away(e: Dictionary) -> bool: return cd_left_s(e) > 0.0
static func cd_min(pin: String) -> float: return float(N().get("cd_min", {}).get(pin, 10))
static func first_n(pin: String) -> int: return int(J.num(N().get("first", {}).get(pin, 10)))
static func weights(pin: String) -> Array:   # [[數量, 權重]…]（同 tiers 次序一樣）
	var w = N().get("weights", {}).get(pin)
	return w if w is Array and w.size() else [[1, 1]]
# 介面顯示用：[{id, name, say, n, pct}]；pct＝權重 ÷ 總權重 × 100（同 roll() 用同一張表）
static func tiers(pin: String) -> Array:
	var w = weights(pin); var ids = N().get("tiers", []); var sum = 0.0
	for x in w: sum += float(x[1])
	var o = []
	for i in w.size():
		var id = str(ids[i]) if i < ids.size() else str(i)
		o.append({"id": id, "name": T(N().get("tier_name", {}).get(id, [id, id])), "say": T(N().get("tier_say", {}).get(id, ["", ""])),
			"n": int(J.num(w[i][0])), "pct": float(w[i][1]) / sum * 100.0})
	return o
# 抽一次：回 {n, id, name, say, i}
static func roll(k: String) -> Dictionary:
	var ts = tiers(_SOUL().pin(k)); var w = weights(_SOUL().pin(k)); var sum = 0.0
	for x in w: sum += float(x[1])
	var r = rng.randf() * sum; var hit = ts.size() - 1
	for i in w.size():
		r -= float(w[i][1])
		if r <= 0: hit = i; break
	var t = ts[hit]
	return {"n": t.n, "id": t.id, "name": t.name, "say": t.say, "i": hit}
static func first_done(k: String) -> bool:
	var o = st()
	return o != null and o.fk.has(k)
# 打贏之後主魂（soul_data.on_sortie_win 掛鈎；只喺 on_for 嘅圖叫）：回 {n, first, tier（冇＝""）, name, say, away}
#   普通據點：第一次佔領＝首殺；收復＝冇主魂。名鬼據點：名鬼在場先掉，掉完請假。
static func main_soul(e: Dictionary, k: String) -> Dictionary:
	var o = st(); var out = {"n": 0, "first": false, "tier": "", "name": "", "say": "", "away": false}
	if o == null or k == "": return out
	var pin = _SOUL().pin(k)
	if is_post(e):
		if not o.fk.has(k): o.fk[k] = 1.0; out.n = first_n(pin); out.first = true
		return out
	if guard_away(e): out.away = true; return out
	if not o.fk.has(k):
		o.fk[k] = 1.0; out.n = first_n(pin); out.first = true
	else:
		var r = roll(k)
		out.n = int(r.n); out.tier = r.id; out.name = r.name; out.say = r.say
	return out
static func start_cd(e: Dictionary) -> void:   # 名鬼據點打贏（名鬼在場）之後叫
	var o = st(); var k = _SOUL().guard_of(e)
	if o == null or k == "" or is_post(e): return
	o.cd[key(e)] = now_ms() + cd_min(_SOUL().pin(k)) * 60000.0
static func leave_text(e: Dictionary) -> String:   # 「去茶水間　09:59」
	var k = _SOUL().guard_of(e); var s = cd_left_s(e)
	if k == "" or s <= 0: return ""
	return "%s　%s" % [T(N().get("leave", {}).get(_SOUL().pin(k), ["請假", "請假"])), clock(s)]
static func clock(sec: float) -> String:
	var n = int(ceil(sec))
	if n >= 3600: return "%d:%02d:%02d" % [n / 3600, (n % 3600) / 60, n % 60]
	return "%02d:%02d" % [n / 60, n % 60]
# 名鬼請假：敵陣入面嘅名鬼換做代班雜兵（so_data.dispatch 掛鈎）
static func stand_in(e: Dictionary, stg: Dictionary) -> Dictionary:
	if is_post(e) or not guard_away(e): return stg
	var k = _SOUL().guard_of(e); var k2 = _SOUL().guard2_of(e)
	var en = (stg.get("en", []) as Array).duplicate()
	var sub = "youhun"
	for x in en: if not _SOUL().is_ghost(str(x)) and str(x) != str(e.get("bm", "")): sub = str(x); break
	var o = stg.duplicate()
	for i in en.size(): if str(en[i]) == k or (k2 != "" and str(en[i]) == k2): en[i] = sub
	o["en"] = en; o.erase("guard")
	if o.get("ct") is Dictionary:
		var ct = (o.ct as Dictionary).duplicate(); ct["en"] = en; ct["guard"] = ""; o["ct"] = ct
	o["stand_in"] = true
	return o

# ======================= 品階融合消耗倍數（按出生品；老闆睇完數字先開：fuse_k_on） =======================
static func fuse_k(k: String) -> float:
	if off() or not J.t(D().get("fuse_k_on", false)): return 1.0
	return float(D().get("fuse_k", {}).get(_SOUL().pin(k), 1.0))

# ======================= KPI 累計指標（唔會倒退） =======================
static func n_open() -> int:
	var o = st()
	return int(J.num(o.n_open)) if o != null else 0
static func n_repel() -> int:
	var o = st()
	return int(J.num(o.n_repel)) if o != null else 0

static func _save() -> void:
	var ex = J.G.get("save")
	if ex != null: J.cl(ex, null, [])
