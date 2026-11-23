# [abform] 地圖戰鬥：陣型、走位、同邊互推、揀目標（威脅值＋每隻目標最多幾人打）、AoE 半徑、前排護衛、自動施放 AI（我方名鬼＋敵人）
#   全部 static，傳 sim（rts_sim 實例）入嚟；rts_sim 只加一行級掛鈎（`# [abform]`）。
#   on() 假（abil.gd OFF／abil.json off，或者測試 force＝0）→ rts_sim 行返舊路，同種子結果同舊版一模一樣（abform_test regress 驗證）。
#   冇 class_name（熱更新規矩）：const AF = preload("res://game/rts/abform.gd")
extends RefCounted

static var force := -1          # 測試：-1 跟總開關；0 全關（舊路）；1 全開
const AOE_R := 130.0            # AoE 半徑（唔再打全場）
const MEL_CAP := 3              # 每隻目標最多幾個近戰同時打（遠程唔計）
static var MEL_CAP_HERO := 2         # 敵人打我方名鬼：最多 2 個近戰（其餘去打小隊／等位）→ 名鬼唔會被圍
static var T_FRONT := 60.0           # 敵人揀目標：威脅值（愈大愈優先；單位＝橫距 px／1.6）
static var T_SQ := 30.0              #   陰兵小隊（舊版 120：敵人一定先打小隊 → 小隊秒死）
const T_BACK := -80.0           #   後排名鬼（唔易被揀）
const T_TAUNT := 999.0          #   嘲諷（st.taunt > 0 或者 bf 有 taunt，由 abcore 積木設）
static var GUARD_R := 70.0           # 前排名鬼護衛：身邊幾遠嘅陰兵小隊
static var GUARD_PCT := 0.35         #   小隊受傷幾成轉去名鬼身
const GUARD_CAP := 0.06         #   每秒最多轉名鬼 maxhp 幾多成
const GUARD_FLOOR := 0.3        #   名鬼自己血低過呢個比例就唔再擋
const WAIT := 5.0               # 自動施放：滿咗嚇氣等夠幾秒條件都唔成立 → 照放（唔會儲住唔用）
const BOSS_OPEN := 3.0          # 敵人王：接觸後幾秒先第一次放技（俾玩家睇到）
const SIDE_LANE := 50.0         # 橫距 < 呢個先直接埋身；否則由自己嗰邊側身埋去（保住橫隊次序）
static var RESC_N := 2               # 名鬼被幾多隻近戰鎖住 → 叫最近嘅小隊過嚟救
static var RESC_K := 2            # 救援派幾多隊小隊
const RESC_T := 3.0             # 救援維持幾秒
static var SQ_BACK := 0.0             # 小隊比前排名鬼企後幾多（開頭 8 秒）
const CLOSE := 100.0            # 同 rts_sim.CLOSE：射程＋呢個以內當「近」

# 總開關（審查修正第 3 項：全域、唔入玩家存檔）：abil.gd 嘅 static var OFF＝true，或者 data/abil.json 頂層 "off": true → 全部行舊路
const ABE = preload("res://game/rts/abil.gd")   # [abform] 真 abcore（targetable 用）；總開關照用 AB_PATH
static var AB_PATH := "res://game/rts/abil.gd"   # abcore 檔；測試可以指去 stub
static var _ab = null
static var _ab_path := ""
static func on() -> bool:
	if force >= 0: return force == 1
	_abil("")
	if J.t(_D.get("off", false)): return false
	if _ab_path != AB_PATH:
		_ab_path = AB_PATH
		_ab = load(AB_PATH) if ResourceLoader.exists(AB_PATH) else null
	if _ab != null and J.t(_ab.get("OFF")): return false
	return true

# ---- 能力數據（abcore／cdata 嘅 data/abil.json；冇檔＝用預設，唔會出錯） ----
static var _D = null
static func _abil(k) -> Dictionary:
	if _D == null:
		_D = {}
		if FileAccess.file_exists("res://data/abil.json"):
			var f = FileAccess.open("res://data/abil.json", FileAccess.READ)
			var d = JSON.parse_string(f.get_as_text()) if f else null
			if d is Dictionary: _D = d
	var a = _D.get("ABIL", {})
	var e = a.get(str(k)) if a is Dictionary else null
	return e if e is Dictionary else {}
static func _mechs(v: Dictionary) -> Array:
	if v.get("mech") is Array: return v.mech
	var en = _D.get("ENEMY", {}) if _D is Dictionary else {}
	var e = en.get(str(v.get("k"))) if en is Dictionary else null
	return e.get("mech", []) if e is Dictionary and e.get("mech") is Array else []

static func _nn(u, k: String) -> float: return J.num(u.get(k, 0)) if u is Dictionary else 0.0
static func _mel(u: Dictionary) -> bool: return _nn(u, "range") <= 60

# ================= 站位：前排 front／後排 back／側翼 flank（陰兵小隊 sq） =================
static func role_of(u: Dictionary) -> String:
	if J.t(u.get("minion")): return "sq"
	if u.has("role_"): return str(u.role_)
	var r = ""
	var S = J.G.get("S")
	var ar = S.get("ab_role") if S is Dictionary else null
	if ar is Dictionary and _nn(u, "side") == 0: r = str(ar.get(str(u.get("gid", "")), ""))
	if r == "": r = str(_abil(u.get("k")).get("role", ""))
	if not _mel(u): r = "back"                       # 遠程一定企後排
	elif r != "flank": r = "front"                   # 近戰：前排（除非數據／玩家揀側翼）
	u["role_"] = r
	return r

# 一條近身橫隊嘅次序：[翼] [小隊…] [前排名鬼] [小隊…] [前排名鬼] [小隊…] [翼]
#   前排名鬼擺喺中間三分一，兩頭係小隊（或者側翼名鬼）→ 名鬼唔會企兩頭俾人圍
static func line_order(mel: Array) -> Array:
	var fr = []; var fl = []; var sq = []
	for u in mel:
		var r = role_of(u)
		if r == "sq": sq.append(u)
		elif r == "flank": fl.append(u)
		else: fr.append(u)
	var n = sq.size() + fr.size()
	var slot = []
	slot.resize(n)
	var F = fr.size()
	for j in F:   # 側翼接觸 2 秒就離線去繞後，所以「中間」按小隊＋前排計（唔連側翼）
		var f = 0.5 if F == 1 else 0.35 + 0.3 * float(j) / float(F - 1)   # 中間三分一以內
		var idx = clampi(int(round(f * (n - 1))), 0, n - 1)
		while slot[idx] != null: idx = (idx + 1) % n
		slot[idx] = fr[j]
	var si = 0
	for i in n:
		if slot[i] == null: slot[i] = sq[si]; si += 1
	var o = []
	for i in fl.size(): if i % 2 == 0: o.append(fl[i])
	o += slot
	for i in fl.size(): if i % 2 == 1: o.append(fl[i])
	return o
# 分兩行：前排名鬼、側翼一定企前行；小隊按次序補（保住橫向次序）
static func _ab_split(line: Array) -> Array:
	var a = []; var b = []
	var need_a = (line.size() + 1) / 2
	var lock = 0
	for u in line: if role_of(u) != "sq": lock += 1
	var m = line.size() - lock
	var free_a = clampi(need_a - lock, 0, m)
	var k = 0
	for u in line:
		if role_of(u) != "sq": a.append(u)
		else:   # 平均揀 free_a 隊企前行（唔好前面嗰幾隊搶晒，令名鬼喺前行變咗企一邊）
			if m > 0 and floori((k + 1) * free_a / float(m) + 0.0001) > floori(k * free_a / float(m) + 0.0001): a.append(u)
			else: b.append(u)
			k += 1
	return [a, b]
# 行軍展開用：一行太長（> 8）先分兩行
static func split_rows(line: Array) -> Array:
	if line.size() <= 8: return [line]
	return _ab_split(line)
# 接觸：同 sim._slots 一樣出 ls（一行）、ls2／row（對面窄過自己時壓成兩行用）
static func slots(line: Array, gap: float) -> void:
	for i in line.size():
		line[i]["ls"] = (i - (line.size() - 1) * 0.5) * gap
	var rows = _ab_split(line)
	for r in 2:
		var arr = rows[r]
		for j in arr.size():
			arr[j]["row"] = r; arr[j]["ls2"] = (j - (arr.size() - 1) * 0.5) * gap

# ================= 揀目標：威脅值＋每隻目標最多 MEL_CAP 個近戰 =================
static func threat(v: Dictionary) -> float:   # 敵人眼中我方單位幾「值得打」
	var st = v.get("st", {})
	if (st is Dictionary and _nn(st, "taunt") > 0) or J.t(v.get("taunt")): return T_TAUNT
	match role_of(v):
		"sq": return T_SQ
		"back": return T_BACK
		"flank": return 0.0
	return T_FRONT
# 每格開頭：數每隻目標有幾多近戰鎖住（_tgn）、處理「被圍救援」
static func pre_tick(sim, dt: float) -> void:
	var n = {}
	for u in sim.units:
		if not sim.alive(u) or not _mel(u): continue
		var tg = u.get("tg")
		if tg is Dictionary and sim.alive(tg):
			var key = int(_nn(tg, "_id")); n[key] = int(n.get(key, 0)) + 1
	sim.set_meta("af_tgn", n)
	var rt = float(sim.get_meta("af_rt", 0.0)) - dt
	if rt <= 0.0:
		rt = 0.5
		_rescue(sim)
	sim.set_meta("af_rt", rt)
static func cap_of(v: Dictionary) -> int:
	return MEL_CAP_HERO if _nn(v, "side") == 0 and not J.t(v.get("minion")) else MEL_CAP
static func _load_of(sim, v: Dictionary) -> int:
	var n = sim.get_meta("af_tgn", {})
	return int(n.get(int(_nn(v, "_id")), 0))
static func _bump(sim, old, nv) -> void:
	var n = sim.get_meta("af_tgn", {})
	if old is Dictionary: var k = int(_nn(old, "_id")); n[k] = maxi(0, int(n.get(k, 0)) - 1)
	if nv is Dictionary: var k2 = int(_nn(nv, "_id")); n[k2] = int(n.get(k2, 0)) + 1
static func targetable(sim, u: Dictionary, v: Dictionary) -> bool:
	# abcore 嘅 AB.targetable（隱身、飛行）合併後喺呢度接：sim 有 ab_targetable 就問佢
	if sim.has_method("ab_targetable"): return sim.ab_targetable(u, v)
	if J.t(sim.get("ab")): return ABE.targetable(sim, u, v)   # [abform] 整合：隱身遠過 80px 唔揀，免得 AB.pick_fix 改揀最近而爆每目標上限
	return true
static func line_tg(sim, u: Dictionary):
	var cur = u.get("tg")
	var my = float(u.get("ls", sim._lat(u.p)))
	var mel = _mel(u)
	if cur is Dictionary and sim.alive(cur) and targetable(sim, u, cur):
		if _nn(u, "resc") > sim.t: return cur                         # 救援中：黐實
		if absf(sim._lat(cur.p) - my) < 90.0 and (not mel or _load_of(sim, cur) <= cap_of(cur)): return cur
	var best = null; var bk = 1e9
	var foe = _nn(u, "side") == 1
	for v in sim.enemies_of(u):
		if not targetable(sim, u, v): continue
		var k = absf(sim._lat(v.p) - my) * 1.6 + absf(sim._axl(v.p) - sim._axl(u.p)) * 0.4
		if foe: k -= threat(v)
		if mel and _load_of(sim, v) - (1 if v == cur else 0) >= cap_of(v): k += 100000.0   # 夠人打緊：揀下一隻（全部都滿先返嚟）
		if k < bk: bk = k; best = v
	if mel: _bump(sim, cur if cur is Dictionary and sim.alive(cur) else null, best)
	u["tg"] = best
	return best
# 側翼：接觸 2 秒後去打對面最後面嗰隻（遠程／施法中／召喚者），被 ≥3 隻圍就退返陣線（10 秒一次）
static func flank_tg(sim, u: Dictionary):
	if role_of(u) != "flank" or sim.t < 2.0 or _nn(u, "side") != 0: return null
	if _nn(u, "retreat") > sim.t: return null
	if _load_of(sim, u) >= 3 and _nn(u, "retreat_cd") <= sim.t:
		u["retreat"] = sim.t + 1.5; u["retreat_cd"] = sim.t + 10.0; u["tg"] = null
		return null
	var best = null; var bk = -1e9
	for v in sim.enemies_of(u):
		if not targetable(sim, u, v): continue
		var k = sim._axl(v.p) + (120.0 if not _mel(v) else 0.0) + (150.0 if J.t(v.get("casting")) else 0.0) + (150.0 if "summon" in _mechs(v) else 0.0)
		if k > bk: bk = k; best = v
	if best != null:
		_bump(sim, u.get("tg"), best); u["tg"] = best; u["resc"] = sim.t + 1.0
	return best
# 被圍救援：名鬼被 ≥RESC_N 隻近戰鎖住 → 最近 2 隊小隊改打圍佢嘅敵人
static func _rescue(sim) -> void:
	for h in sim.units:
		if _nn(h, "side") != 0 or J.t(h.get("minion")) or not sim.alive(h): continue
		var att = []
		for v in sim.units:
			if _nn(v, "side") == 1 and sim.alive(v) and _mel(v) and v.get("tg") == h and sim.dist(v, h) <= _nn(v, "range") + 40.0: att.append(v)
		if att.size() < RESC_N: continue
		var sqs = []
		for s in sim.units:
			if _nn(s, "side") == 0 and J.t(s.get("minion")) and sim.alive(s) and J.t(s.get("eng")) and _nn(s, "resc") <= sim.t: sqs.append(s)
		sqs.sort_custom(func(a, b): return sim.dist(a, h) < sim.dist(b, h))
		for i in mini(RESC_K, sqs.size()):
			var tg = att[i % att.size()]
			_bump(sim, sqs[i].get("tg"), tg); sqs[i]["tg"] = tg; sqs[i]["resc"] = sim.t + RESC_T
		if sqs.size(): sim.events.append(["af_rescue", h])

# ================= 走位：要去邊 =================
#   遠：去自己陣位（_line_want）；近（射程＋CLOSE 內）：喺目標「自己嗰邊」側身企定（橫距夾住 ≤ 射程 0.6）→ 唔會全部擠向正中
static func want(sim, u: Dictionary, tg: Dictionary, d: float) -> Vector2:
	var r = _nn(u, "range")
	var up: Vector2 = u.p
	if _nn(u, "resc") > sim.t or _nn(u, "retreat") > sim.t:
		if _nn(u, "retreat") > sim.t:   # 側翼退返陣線
			return sim.org + sim.perp * float(u.get("ls", 0.0)) - sim.ax * (60.0 if _nn(u, "side") == 0 else -60.0)
		return tg.p
	var lw: Vector2 = sim._line_want(u, tg)
	if J.t(u.get("minion")) and _nn(u, "side") == 0 and sim.t < 8.0: lw -= sim.ax * SQ_BACK   # 開頭幾秒小隊企後少少：前排名鬼先頂住
	if d >= r + CLOSE: return lw
	var my = sim._lat(lw)
	var dl = clampf(my - sim._lat(tg.p), -r * 0.6, r * 0.6)
	if absf(sim._lat(up) - sim._lat(tg.p)) < SIDE_LANE: dl = clampf(sim._lat(up) - sim._lat(tg.p), -r * 0.6, r * 0.6)
	var sg = 1.0 if _nn(u, "side") == 0 else -1.0
	var fwd = sqrt(maxf(0.0, r * r * 0.72 - dl * dl))
	var spot = (tg.p as Vector2) + sim.perp * dl - sim.ax * sg * fwd
	if spot.distance_to(up) < 3.0: return tg.p   # 企到位都未入射程（對方郁緊）：直接埋身
	return spot

# ================= 同邊互推（分方向） =================
#   同邊：主要沿橫向推（保住前後行）；異邊：只沿陣線軸推（唔會左右滑走亂晒）
static func separate(sim, dt: float) -> void:
	var al = []
	for u in sim.units: if sim.alive(u) and (_nn(u, "side") == 1 or J.t(u.get("eng"))): al.append(u)
	var ax: Vector2 = sim.ax; var pp: Vector2 = sim.perp
	for i in al.size():
		for j in range(i + 1, al.size()):
			var a = al[i]; var b = al[j]
			var same = _nn(a, "side") == _nn(b, "side")
			var lim = (42.0 if J.t(a.get("minion")) and J.t(b.get("minion")) else 34.0) if same else 26.0
			var d: Vector2 = (b.p as Vector2) - (a.p as Vector2)
			var L = d.length()
			if L >= lim: continue
			var k = (lim - L) * 5.0 * dt
			var n: Vector2
			if same:
				var lp = d.dot(pp)
				if absf(lp) < 0.5:
					var sgn = signf(float(b.get("ls", 0.0)) - float(a.get("ls", 0.0)))
					if sgn == 0.0: sgn = 1.0 if (i + j) % 2 == 0 else -1.0
					lp = sgn
				n = pp * signf(lp) + ax * (d.dot(ax) / maxf(L, 0.01)) * 0.3
			else:
				var la = d.dot(ax)
				n = ax * (signf(la) if absf(la) > 0.5 else (1.0 if _nn(b, "side") == 1 else -1.0))
			n = n.normalized()
			a["p"] = (a.p as Vector2) - n * k; b["p"] = (b.p as Vector2) + n * k

# ================= AoE：半徑 130（以最近嗰隻做圓心） =================
static func aoe_targets(sim, u: Dictionary) -> Array:
	var c = sim.nearest(u)
	if c == null: return []
	var o = []
	for v in sim.enemies_of(u):
		if not targetable(sim, u, v): continue
		if (v.p as Vector2).distance_to(c.p) <= AOE_R: o.append(v)
	sim.events.append(["af_aoe", u, c.p, AOE_R])
	sim._fx({"kind": "ring", "p": c.p, "life": 0.45, "col": "#ffb0c8" if _nn(u, "side") == 1 else "#bbffff", "r": AOE_R})
	return o
static func _n_in(sim, u: Dictionary) -> int:
	var c = sim.nearest(u)
	if c == null: return 0
	var n = 0
	for v in sim.enemies_of(u): if (v.p as Vector2).distance_to(c.p) <= AOE_R: n += 1
	return n

# ================= 前排護衛：前排名鬼身邊嘅陰兵小隊受傷，一部份轉去名鬼身 =================
#   唔掂 hit()（abcore 擁有）：每格比較小隊血量，跌咗就由名鬼「分擔」返；致命嗰下唔救（死咗就死咗）。
#   abcore 嘅 hit 管線如果自己做咗 guard 積木（sim.ab_guard_hit＝true），呢度唔再做，免得雙重計。
static func guard_tick(sim, dt: float) -> void:
	if J.t(sim.get("ab_guard_hit")): return
	var frs = []
	for h in sim.units:
		if _nn(h, "side") == 0 and not J.t(h.get("minion")) and sim.alive(h) and role_of(h) == "front":
			h["gbud"] = minf(GUARD_CAP * _nn(h, "maxhp"), _nn(h, "gbud") + GUARD_CAP * _nn(h, "maxhp") * dt)
			frs.append(h)
	for s in sim.units:
		if _nn(s, "side") != 0 or not J.t(s.get("minion")): continue
		var hp = _nn(s, "hp")
		var ph = float(s.get("af_ph", hp))
		s["af_ph"] = hp
		if hp <= 0 or ph <= hp or frs.is_empty() or J.t(sim.cosmetic): continue
		var best = null; var bd = GUARD_R
		for h in frs:
			var d = sim.dist(h, s)
			if d <= bd and _nn(h, "hp") > _nn(h, "maxhp") * GUARD_FLOOR: bd = d; best = h
		if best == null: continue
		var sh = minf((ph - hp) * GUARD_PCT, _nn(best, "gbud"))
		sh = minf(sh, _nn(best, "hp") - _nn(best, "maxhp") * GUARD_FLOOR)
		if sh <= 0: continue
		s["hp"] = hp + sh; s["af_ph"] = hp + sh
		best["hp"] = _nn(best, "hp") - sh; best["gbud"] = _nn(best, "gbud") - sh
		best["guarded"] = _nn(best, "guarded") + sh
		if randf() < 0.08: sim._fx({"kind": "ring", "p": s.p, "life": 0.35, "col": "#9fd8ff"})

# ================= 自動施放 AI（我方名鬼＋敵人） =================
# 6 種條件：asap 有目標入射程就放｜n_in 圈內 ≥N 隻｜ally_hp 有隊友低血｜foe_cast 附近敵人讀緊條｜tg_mech 場上有某機制嘅敵人｜self_hp 自己低血
# ＋ 保底：滿咗嚇氣等夠 WAIT 秒條件都唔成立就照放
static func ai_of(u: Dictionary) -> Dictionary:
	if u.get("ai_") is Dictionary: return u.ai_
	var o = {}
	var a = _abil(u.get("k"))
	var act = a.get("act") if a.get("act") is Dictionary else null
	var ai = act.get("ai") if act != null else null
	if ai is String: o = {"when": ai}
	elif ai is Dictionary:
		o = ai.duplicate()
		if not o.has("when"):
			for k in ["n_in", "ally_hp", "foe_cast", "tg_mech", "self_hp"]: if o.has(k): o["when"] = k; break
	if not o.has("when"):   # 由舊 SKILLS 推
		var sk = u.get("sk")
		var kd = J.str(sk.get("kind")) if sk is Dictionary else ""
		if kd == "heal": o = {"when": "ally_hp", "ally_hp": 0.5 if _nn(u, "side") == 0 else 0.6}
		elif kd == "aoe": o = {"when": "n_in"}
		elif sk is Dictionary and J.num(sk.get("sap", 0)) >= 25: o = {"when": "foe_cast"}
		elif sk is Dictionary and J.num(sk.get("drain", 0)) >= 0.4: o = {"when": "self_hp", "self_hp": 0.6}
		else: o = {"when": "asap"}
	if not o.has("wait"): o["wait"] = WAIT
	u["ai_"] = o
	return o
static func auto_on(sim, u: Dictionary) -> bool:
	if _nn(u, "side") == 1: return true
	if J.t(u.get("minion")): return false
	var S = J.G.get("S")
	var aa = S.get("ab_auto") if S is Dictionary else null
	if aa is Dictionary and aa.has(str(u.get("gid", ""))): return J.t(aa[str(u.get("gid", ""))])
	return sim.auto
# 每格叫（單位已確定有技能、冇動作、冇讀條）：回 true＝而家放
static func want_cast(sim, u: Dictionary, dt: float) -> bool:
	if _nn(u, "energy") < 100: u["full_t"] = 0.0; return false
	if not auto_on(sim, u): return false
	u["full_t"] = _nn(u, "full_t") + dt
	if _nn(u, "side") == 1 and J.t(u.get("boss")) and sim.t < BOSS_OPEN: return false
	if cond_ok(sim, u): return true
	return _nn(u, "full_t") >= float(ai_of(u).get("wait", WAIT))
static func cond_ok(sim, u: Dictionary) -> bool:
	var ai = ai_of(u)
	var foe = _nn(u, "side") == 1
	match str(ai.get("when", "asap")):
		"asap":
			var n = sim.nearest(u)
			return n != null and sim.dist(u, n) <= maxf(_nn(u, "range"), 46.0) + 60.0
		"n_in":
			var fo = sim.enemies_of(u).size()
			var need = mini(int(ai.get("n_in", 2 if foe else 3)), fo)
			return fo > 0 and _n_in(sim, u) >= maxi(1, need)
		"ally_hp":
			var th = float(ai.get("ally_hp", 0.6 if foe else 0.5))
			for v in sim.units:
				if _nn(v, "side") == _nn(u, "side") and sim.alive(v) and _nn(v, "hp") < _nn(v, "maxhp") * th: return true
			return false
		"foe_cast":
			for v in sim.enemies_of(u):
				if J.t(v.get("casting")) and sim.dist(u, v) <= 300.0: return true
			return false
		"tg_mech":
			var m = str(ai.get("tg_mech", ""))
			for v in sim.enemies_of(u): if m in _mechs(v): return true
			return false
		"self_hp":
			return _nn(u, "hp") < _nn(u, "maxhp") * float(ai.get("self_hp", 0.4))
	return true
