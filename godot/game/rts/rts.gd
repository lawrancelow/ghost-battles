# [rts] 地圖半即時戰鬥：入口、出擊、結算接駁（全部 static；冇 class_name、冇 autoload：熱更新規矩）
#   const RTS = preload("res://game/rts/rts.gd")
#   設計稿：/home/claude/docs/rts_design.md
#
#   做法：
#     開戰（下令嗰一刻）：照舊叫 Battle.start（宵夜、羈絆、存在感、奪回地盤、遊魂兵、嘍囉全部照舊算），攞走生成嘅單位，即刻將 Battle 關返（active=false）
#       → Battle 冇被佔住，村子同其他系統完全唔受影響，可以同時有幾場。
#     打鬥：rts_sim.gd（地圖平面，規則搬自 battle.gd／rework.gd）。
#     結算（分勝負嗰一刻）：將打完嘅單位交返 Battle，叫原本嘅 Battle.finish（包住佢嘅 rework／presence／chatter／bonds 照跑）
#       → 戰死扣兵、遊魂兵扣人、獎勵、通關、劇情、收編全部係舊程式；再自動撳「繼續」（_on_ok：主線推進、關後劇情）。
#   原型：只對 ON_SIDS 入面嘅主線關卡開（其他戰鬥照舊，方便老闆比較）。
extends RefCounted

const ZD = preload("res://game/zone/zone_data.gd")
const MD = preload("res://game/outpost/mv_data.gd")
const SIM = preload("res://game/rts/rts_sim.gd")

const ON_SIDS := []               # 邊幾場主線關卡用新打法（[] ＝ 全部主線關卡；全面鋪開）
const MAX_OPS := 2                # 同時最多幾場（名鬼帶隊嘅最多 1 場）
const TA = preload("res://game/zone/zone_taunt.gd")
const RALLY := 120.0              # 迎戰點：離敵人據點幾遠停低
const CAMP_OFF := Vector2(0, -40)  # 據點比舊迎戰位（大排檔兩檔之間）再近野外門少少：戰場唔好疊住檔口

static var ops: Array = []
static var LOG: Array = []
static var force := -1            # 測試：-1 照 ON_SIDS；0 全關；1 全開
static var _last_f := -1
static var _next_id := 1
static var last_report := {}
static var pending = null         # 出擊小卡開緊：{kind, id, cb, opt, tg, name}
static var _pend_f := 0

# ================= 開關 =================
static func enabled_for(sid: String) -> bool:
	if force == 0 or OS.has_environment("GB_NORTS"): return false
	if not ZD.on(): return false
	if force == 1: return true
	return ON_SIDS.is_empty() or sid in ON_SIDS
static func owns(sid: String) -> bool: return enabled_for(sid)   # zone_view：據點由 rts_view 畫
static func op_for(sid: String):
	for o in ops: if o.sid == sid and o.phase != "done": return o
	return null
static func busy() -> bool:
	for o in ops: if o.phase != "done": return true
	return false
static func L(yue: String, zhs: String) -> String: return str(DB.N(ZD.L(yue, zhs)))
static func _main(): return Engine.get_main_loop().root.get_node_or_null("Main")
static func toast(s: String) -> void:
	var m = _main()
	if m != null and m.has_method("show_toast"): m.show_toast(s)

# ================= 路線（村門內集合點 → 村門 → 大排檔 → 迎戰點） =================
static func gate_pos() -> Vector2: return ZD.v2(ZD.cur().get("village", {}).get("POS", {}).get("gate", [0, 0]))
static func stage_path(at: Vector2) -> PackedVector2Array:
	var o = PackedVector2Array()
	var mk = ZD.cur().get("market", {})
	var por = mk.get("porter", [])
	var g = gate_pos()
	if por.size() >= 3:
		for i in 3: o.append(ZD.v2(por[i]))
	else:
		o.append(g + Vector2(0, 110)); o.append(g); o.append(g + Vector2(0, -60))
	var q = mk.get("q2", [])
	if q.is_empty(): q = mk.get("vol_mid", [])
	var last = o[o.size() - 1]
	for p in q:
		var v = ZD.v2(p)
		if v.distance_to(at) < 150.0: break
		if v.distance_to(at) > last.distance_to(at) + 40.0: continue   # 越行越遠嘅點唔要
		o.append(v); last = v
	var dir = (last - at).normalized() if last.distance_to(at) > 1.0 else Vector2(0, 1)
	o.append(at + dir * RALLY)
	return o

# ================= 敵人據點預覽（未出擊時企喺度） =================
static func camp_preview(tg: Dictionary) -> Array:
	var at: Vector2 = tg.pos + CAMP_OFF
	var pth = stage_path(at)
	var din = (pth[pth.size() - 1] - pth[pth.size() - 2]).normalized()
	var ks = []
	for e in (tg.get("en", []) as Array): ks.append(str(e))
	var bo = str(tg.get("boss")) if tg.get("boss") != null else ""
	var ET = J.G.get("ENEMY_T")
	var pos = SIM.camp_layout(at, ks.size(), din)
	var o = []
	for i in ks.size():
		var nm = str(ET[ks[i]][2]) if ET is Dictionary and ET.has(ks[i]) else ks[i]
		o.append({"side": 1.0, "k": ks[i], "name": nm, "hp": 1.0, "maxhp": 1.0, "st": {}, "boss": ks[i] == bo, "p": pos[i], "post": pos[i],
			"face": -1.0 if din.x >= 0 else 1.0, "preview": true})
	return o

# ================= 出擊 =================
# 主線關卡（zone_data.start_stage 掛鈎）：回 "ok"／"noteam"／"nobattle"／"busy"
static func dispatch_stage(tg: Dictionary) -> String:
	var sid = str(tg.sid)
	var ex = op_for(sid)
	if ex != null: focus(ex); return "ok"
	var B = J.G.get("Battle")
	if not (B is Dictionary): return "nobattle"
	if not ZD.team_ok(): return "noteam"
	var c = float(tg.c); var si = float(tg.s)
	var pend = {"kind": "stage", "id": sid, "cb": func(): J.mc(B, "start", [c, si]), "opt": {}, "tg": tg, "name": str(DB.L(str(tg.get("name", sid))))}
	open_card(pend)
	return "ok"

# ================= 舊大地圖戰鬥入口（zone_battle.start 掛鈎）：王、親征、襲擾迎戰、鬼潮告急 =================
static func on() -> bool: return force != 0 and not OS.has_environment("GB_NORTS") and ZD.on()
static func on_zone(zid: String) -> bool:
	for o in ops: if o.get_meta("zid", "") == zid and o.phase != "done" and o.kind in ["boss", "cap"]: return true
	return false
static func has_kind(k: String) -> bool:
	for o in ops: if o.kind == k and o.phase != "done": return true
	return false
static func start_generic(k: String, id: String, cb: Callable, opt := {}) -> bool:
	if not on(): return false
	var nm = ""
	var B = J.G.get("Battle")
	var pend = {"kind": k, "id": id, "cb": cb, "opt": opt, "name": nm}
	if k == "boss" and str(opt.get("bid", "")) != "":
		for z in ZD.of_type("wild"):
			for b in ZD.bosses(str(z.id)): if str(b.id) == str(opt.bid): pend.name = ZD.T(b.get("n", ["", ""]))
	elif k == "cap": pend.name = ZD.T(ZD.zone(id).get("n", ["", ""]))
	elif k == "raid": pend.name = L("迎擊惡鬼", "迎擊惡鬼")
	if k == "raid":   # 迎敵：唔問，全部出
		if _launch(pend, -1, -1) != "ok": _cancel(pend)
		return true
	open_card(pend)
	return true

# ================= 出擊小卡：揀帶幾隊；同時最多 2 場（名鬼帶隊最多 1 場） =================
static func _hero_ops() -> int:
	var n = 0
	for o in ops: if o.phase != "done" and not o.no_heroes: n += 1
	return n
static func busy_reason() -> String:
	var B = J.G.get("Battle")
	if B is Dictionary and J.t(B.get("active")): return L("而家打緊另一場，等佢打完先", "現在正在打另一場，等它打完再說")
	if ops.size() >= MAX_OPS: return L("同時最多出擊 %d 場", "同時最多出擊 %d 場") % MAX_OPS
	if _hero_ops() >= 1: return L("名鬼已經帶緊隊喺外面，等佢哋返嚟先", "名鬼已經帶隊在外面，等他們回來再說")
	return ""
static func max_yin() -> int: return mini(8, int(floor(float(load("res://game/barracks/bk_data.gd").standby()) / 25.0)))
static func max_ml() -> int: return load("res://game/militia/ml_data.gd").squads().size()
static func open_card(pend: Dictionary) -> void:
	var m = _main()
	var why = busy_reason()
	if why != "": toast(why); _cancel(pend); return
	if m == null or not m.has_method("open_sheet") or OS.has_environment("GB_RTS_NOCARD"):
		_launch(pend, -1, -1); return
	pending = pend; _pend_f = Engine.get_process_frames()
	pend["ny"] = max_yin(); pend["nm"] = max_ml() if pend.kind != "raid" else 0
	m.open_sheet(L("出擊：%s", "出擊：%s") % str(pend.name), func(): pass)
	_card_body(m, pend)
static func _card_body(m, pend: Dictionary) -> void:
	var body: VBoxContainer = m.sheet_body
	for c in body.get_children(): c.queue_free()
	var S = J.G.S
	var hn = []
	for id in J.iter(S.get("team")):
		if not J.t(id): continue
		for g in J.iter(S.ghosts): if g is Dictionary and J.str(g.id) == J.str(id): hn.append(str(DB.L(J.str(g.name))))
	body.add_child(UIKit.rich("[b]%s[/b]　%s" % [L("名鬼帶隊", "名鬼帶隊"), "、".join(hn) if hn.size() else L("（冇）", "（無）")], 17, UIKit.INKTXT))
	var row = func(label: String, key: String, mx: int, per: String):
		var hb = HBoxContainer.new(); hb.add_theme_constant_override("separation", 10)
		var l = UIKit.label(label, 17, UIKit.INKTXT, "sans", 900); l.custom_minimum_size = Vector2(96, 44); l.vertical_alignment = VERTICAL_ALIGNMENT_CENTER; hb.add_child(l)
		var bm = UIKit.btn("－", ""); bm.custom_minimum_size = Vector2(48, 44); hb.add_child(bm)
		var v = UIKit.label("%d / %d %s" % [int(pend[key]), mx, per], 18, UIKit.INKTXT, "sans", 900); v.custom_minimum_size = Vector2(110, 44)
		v.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; v.vertical_alignment = VERTICAL_ALIGNMENT_CENTER; hb.add_child(v)
		var bp = UIKit.btn("＋", ""); bp.custom_minimum_size = Vector2(48, 44); hb.add_child(bp)
		bm.pressed.connect(func(): pend[key] = maxi(0, int(pend[key]) - 1); v.text = "%d / %d %s" % [int(pend[key]), mx, per])
		bp.pressed.connect(func(): pend[key] = mini(mx, int(pend[key]) + 1); v.text = "%d / %d %s" % [int(pend[key]), mx, per])
		body.add_child(hb)
	row.call(L("陰兵", "陰兵"), "ny", max_yin(), L("隊", "隊"))
	if max_ml() > 0 and pend.kind != "raid": row.call(L("遊魂兵", "遊魂兵"), "nm", max_ml(), L("隊", "隊"))
	body.add_child(UIKit.rich("[color=#6e5838]%s[/color]" % L("每隊 25 個。留低嘅隊伍守村／待命。同時最多出擊 2 場，名鬼帶隊嘅一次一場。", "每隊 25 個。留下的隊伍守村／待命。同時最多出擊 2 場，名鬼帶隊的一次一場。"), 15, UIKit.INKTXT))
	body.add_child(UIKit.hsep())
	var go = UIKit.btn(L("出發", "出發"), "gold")
	go.custom_minimum_size = Vector2(0, 50)
	go.pressed.connect(func():
		var p = pending
		if p == null: return
		pending = null
		m.close_sheet()
		var r = _launch(p, int(p.ny), int(p.nm))
		if r != "ok": _cancel(p); toast(busy_reason() if r == "busy" else L("出擊唔到", "無法出擊")))
	body.add_child(go)
static func card_go() -> String:   # 測試：撳「出發」
	var p = pending
	if p == null: return "none"
	pending = null
	var m = _main()
	if m != null and m.has_method("close_sheet"): m.close_sheet()
	return _launch(p, int(p.get("ny", -1)), int(p.get("nm", -1)))
# 冇出發：清返入口設咗嘅嘢（王／親征嘅 exp、襲擾 fight、鬼潮 exp），當冇撳過
static func _cancel(pend: Dictionary) -> void:
	var S = J.G.get("S")
	if not (S is Dictionary): return
	var zst = ZD.st()
	if pend.kind in ["boss", "cap"] and zst != null and zst.get("exp") is Dictionary:
		var ex = zst.exp
		if not J.t(ex.get("chap")) and not J.t(ex.get("had")) and S.get("cleared") is Dictionary: S.cleared.erase(J.str(ex.sid))
		zst["exp"] = null
	if pend.kind == "raid":
		var r = S.get("raid")
		if r is Dictionary and r.get("fight") is Dictionary:
			if not J.t(r.fight.get("had")) and S.get("cleared") is Dictionary: S.cleared.erase(J.str(r.fight.sid))
			r["fight"] = null
		var w = load("res://game/outpost/mv_war.gd").ws()
		if w is Dictionary and w.get("exp") is Dictionary:
			if not J.t(w.exp.get("had")) and S.get("cleared") is Dictionary: S.cleared.erase(J.str(w.exp.sid))
			w["exp"] = null
	LOG.append(["cancel", pend.kind, pend.id])

# 真正出發
static func _launch(pend: Dictionary, ny: int, nm: int) -> String:
	if busy_reason() != "": return "busy"
	var snap = _start_battle(pend.cb)
	if snap.is_empty(): return "nobattle"
	_trim(snap, ny, nm)
	var op = SIM.new()
	op.id = _next_id; _next_id += 1
	op.kind = pend.kind
	op.adviser = snap.get("adviser")
	op.set_meta("snap", snap); op.set_meta("zid", "")
	var g = geometry(pend)
	if g.is_empty(): return "nobattle"
	op.sid = str(pend.id) if pend.kind == "stage" else J.str(snap.get("sid"))
	op.title = str(pend.name)
	op.set_meta("zid", str(g.get("zid", "")))
	op.set_meta("tkey", str(g.get("tkey", "")))
	if g.get("from") is Vector2: op.foe_from = g.from
	op.setup(snap.units, g.path, g.at, gate_pos())
	if pend.kind == "boss":   # 王用呢度嘅名（例如「亂葬崗守墓鬼」）
		for z in ZD.of_type("wild"):
			for b in ZD.bosses(str(z.id)):
				if str(b.id) == str(pend.opt.get("bid", "")) and J.t(b.get("rename")):
					for u in op.units: if J.t(u.get("boss")): u["name"] = ZD.T(b.get("n", ["", ""]))
	var tk = str(g.get("tkey", ""))
	if tk != "": TA.hide_keys[tk] = true
	ops.append(op)
	LOG.append(["dispatch", op.sid, _count(op), pend.kind])
	var m = _main()
	var nv = m.get("village") if m != null else null
	if nv != null and nv.has_method("zone_cam"):
		var cam = nv.zone_cam()
		if not cam.rect().grow(-60).has_point(op.path[0]): cam.glide_to(op.path[0].lerp(op.path[min(1, op.path.size() - 1)], 0.5))
	Snd.play("click")
	return "ok"
# 揀少咗嘅隊：由單位表拎走（留喺村，唔計戰死）
static func _trim(snap: Dictionary, ny: int, nm: int) -> void:
	var o = []; var cy = 0; var cm = 0
	for u in snap.units:
		if J.num(u.side) == 0 and J.t(u.get("minion")):
			if u.get("ml") == null:
				if ny >= 0 and cy >= ny: continue
				cy += 1
			else:
				if nm >= 0 and cm >= nm: continue
				cm += 1
		o.append(u)
	snap["units"] = o

# ================= 純兵出擊（唔使名鬼、唔借 Battle）：派兵攻佔、自動擊退襲擾 =================
# 數值用返舊公式（陰兵小隊同 battle.gd；遊魂兵同 ml_data）；結果由舊規則定（cosmetic：我方唔會畫錯死晒）
static func mk_squads(ny: int, nm: int) -> Array:
	var S = J.G.S; var lv = J.num(S.get("lv", 1)); var tb = ZD.troop_mul(); var o = []
	for i in ny:
		var hp = (90 + 14 * lv) * tb
		o.append({"side": 0.0, "k": "youhun", "name": "陰兵", "minion": true, "hp": hp, "maxhp": hp, "atk": (9 + 2.2 * lv) * tb, "range": 38.0, "spd": 52.0, "energy": 0.0, "sk": null, "st": {}, "cd": randf()})
	var ML = load("res://game/militia/ml_data.gd"); var sq = ML.squads()
	for i in mini(nm, sq.size()):
		var t = int(sq[i][0]); var k = ML.pw(t)
		var hp = (90 + 14 * lv) * k * float(ML.TUNE.hp_k)
		o.append({"side": 0.0, "k": "youhun", "name": "遊魂兵", "minion": true, "ml": float(t), "hp": hp, "maxhp": hp, "atk": (9 + 2.2 * lv) * k * float(ML.TUNE.atk_k), "range": 38.0, "spd": 52.0, "energy": 0.0, "sk": null, "st": {}, "cd": randf()})
	return o
static func mk_foes(ks: Array, p: float, weak := 1.0) -> Array:
	var ET = J.G.get("ENEMY_T"); var o = []
	for i in ks.size():
		var e = str(ks[i]); if not (ET is Dictionary and ET.has(e)): e = "youhun"
		var T = ET[e]; var hp = (260 + 90 * p) * J.num(T[0]) * weak
		o.append({"side": 1.0, "k": e, "name": T[2], "hp": hp, "maxhp": hp, "atk": (16 + 7.5 * p) * J.num(T[1]), "range": 46.0, "spd": 42.0, "energy": 0.0, "sk": null, "st": {}, "cd": randf() * 0.6, "boss": false})
	return o
static func _solo(kind: String, title: String, units: Array, path: PackedVector2Array, at: Vector2, on_end: Callable, from = null):
	if ops.size() >= MAX_OPS: return null
	var op = SIM.new()
	op.id = _next_id; _next_id += 1
	op.kind = kind; op.sid = kind + ":%d" % op.id; op.title = title
	op.cosmetic = true; op.no_heroes = true
	op.set_meta("custom", on_end); op.set_meta("zid", "")
	if from is Vector2: op.foe_from = from
	op.setup(units, path, at, gate_pos())
	ops.append(op)
	LOG.append(["dispatch", op.sid, _count(op), kind])
	return op
# 派陰兵攻佔（zone_view.open_capture 掛鈎）：真係派隊行去門洞，打贏先佔（折損照舊 ZD.capture_auto）
static func dispatch_capture(zid: String) -> String:
	if ZD.owned(zid): return "owned"
	if ZD.power() < ZD.need(zid): return "weak"
	if ops.size() >= MAX_OPS: toast(busy_reason() if busy_reason() != "" else L("同時最多出擊 %d 場", "同時最多出擊 %d 場") % MAX_OPS); return "busy"
	for o in ops: if o.get_meta("zid", "") == zid: return "busy"
	var z = ZD.zone(zid)
	var g = geometry({"kind": "cap", "id": zid, "opt": {}})
	var ny = maxi(1, max_yin()); var nm = max_ml()
	var st = z.get("stage", {"en": ["youhun", "youhun", "youhun"], "p": 1.0})
	var us = mk_squads(ny, nm) + mk_foes(st.get("en", ["youhun"]), J.num(st.get("p", 1)), 0.6)
	var op = _solo("capauto", L("攻佔：%s", "攻佔：%s") % ZD.T(z.get("n", ["", ""])), us, g.path, g.at, func(win):
		if win:
			if ZD.capture_auto(zid) == "ok":
				var m = _main()
				if m != null and m.has_method("show_banner"): m.show_banner(ZD.L("%s 攻佔咗！", "%s 攻佔了！") % ZD.T(z.n))
		return {"head": L("攻佔成功", "攻佔成功") if win else L("撤退", "撤退"), "reward": "", "lost": []})
	if op == null: return "busy"
	op.set_meta("zid", zid)
	return "ok"
# 襲擾：防衛夠（raid.arrive 自動擊退）→ 畫防衛隊出營迎擊行入嚟嘅惡鬼（結果已經定咗：擊退）
static func raid_show(cur: Dictionary) -> void:
	if not on() or ops.size() >= MAX_OPS: return
	var RAID = load("res://game/raid/raid.gd")
	var at: Vector2 = RAID.tpos(str(cur.tgt))
	var fr = ZD.v2(cur.get("from", [at.x, at.y - 300.0]))
	var BK = load("res://game/barracks/bk_data.gd")
	var ny = clampi(int(floor(float(BK.def_n() + BK.standby()) / 25.0)), 1, 4)
	var ks: Array = cur.ks if cur.get("ks") is Array and cur.ks.size() else ["egui"]
	var en = []
	for i in int(RAID.TUNE.fight_n): en.append(str(ks[i % ks.size()]))
	var g = geometry({"kind": "raid", "id": "", "opt": {"at": at, "from": fr}})
	var us = mk_squads(ny, 0) + mk_foes(en, 1.0 + 3.0 * ZD.ci(), 0.5)
	_solo("raidauto", L("迎擊惡鬼", "迎擊惡鬼"), us, g.path, g.at, func(_win): return {"head": L("擊退惡鬼", "擊退惡鬼"), "reward": "", "lost": []}, fr)

# ================= 路線 =================
static func _porter3() -> PackedVector2Array:
	var o = PackedVector2Array()
	var por = ZD.cur().get("market", {}).get("porter", [])
	var g = gate_pos()
	if por.size() >= 3:
		for i in 3: o.append(ZD.v2(por[i]))
	else: o.append(g + Vector2(0, 110)); o.append(g); o.append(g + Vector2(0, -60))
	return o
static func _rally(o: PackedVector2Array, at: Vector2) -> PackedVector2Array:
	var last = o[o.size() - 1]
	var dir = (last - at).normalized() if last.distance_to(at) > 1.0 else Vector2(0, 1)
	o.append(at + dir * RALLY)
	return o
static func village_cross() -> Vector2:
	var mains = []
	for p in ZD.cur().get("paths", []): if str(p.get("k")) == "main": mains.append(p.pts)
	if mains.size() >= 2:
		var best = INF; var bp = Vector2.ZERO
		for a in mains[0]:
			for b in mains[1]:
				var d = ZD.v2(a).distance_to(ZD.v2(b))
				if d < best: best = d; bp = (ZD.v2(a) + ZD.v2(b)) / 2.0
		return bp
	return ZD.zrect("village").get_center()
# 去野外區：村門 → 大排檔 → 野外門 → 入野外
static func wild_path(wzid: String, at: Vector2, into := true) -> PackedVector2Array:
	var o = _porter3()
	var g = TA.gate_of(wzid); var gp: Vector2 = g[0]; var dir = float(g[1])
	var mk = ZD.cur().get("market", {})
	# 揀去嗰個野外門嘅客人路：左排隊線 q2（櫃台→左門）或者 road 倒轉（櫃台→右門）
	var q = mk.get("vol_mid", [])
	var best = INF
	var rd = (mk.get("road", []) as Array).duplicate(); rd.reverse()
	for cand in [mk.get("q2", []), rd]:
		if (cand as Array).is_empty(): continue
		var d = ZD.v2(cand[cand.size() - 1]).distance_to(gp)
		if d < best: best = d; q = cand
	var last = o[o.size() - 1]
	for p in q:
		var v = ZD.v2(p)
		if v.distance_to(gp) < 90.0: break
		if v.distance_to(gp) > last.distance_to(gp) + 40.0: continue
		o.append(v); last = v
	o.append(gp + Vector2(0, dir * 40.0))
	if into:
		o.append(gp)
		var wr = ZD.zrect(wzid)
		o.append(Vector2(gp.x, minf(gp.y - 46.0, wr.end.y - 30.0) if dir > 0 else maxf(gp.y + 46.0, wr.position.y + 30.0)))
	return _rally(o, at)
static func geometry(pend: Dictionary) -> Dictionary:
	var k = str(pend.kind); var opt: Dictionary = pend.opt
	match k:
		"stage":
			var at = (pend.tg.pos as Vector2) + CAMP_OFF
			return {"at": at, "path": stage_path(at)}
		"boss":
			var zid = str(pend.id)
			var z = ZD.zone(zid); var r = ZD.rect(z.rect)
			var tk = TA.boss_key(ZD.ci(), str(opt.get("bid", ""))) if str(opt.get("bid", "")) != "" else ""
			if tk != "" and TA.on(tk):   # 上次輸咗：王企喺門外叫囂 → 喺門外打
				var sp = TA.spot(tk)
				return {"at": sp, "path": wild_path(zid, sp, false), "zid": zid, "tkey": tk}
			var at = ZD.v2(z.get("boss_at", [r.get_center().x, r.get_center().y]))
			return {"at": at, "path": wild_path(zid, at), "zid": zid, "tkey": tk}
		"cap":
			var zid = str(pend.id)
			var z = ZD.zone(zid); var r = ZD.rect(z.rect)
			var tk = TA.cap_key(ZD.ci(), zid)
			var o = PackedVector2Array([_porter3()[0], village_cross()])
			var at = r.get_center() + Vector2(0, -30)
			if z.get("door") is Dictionary:
				o.append(ZD.v2(z.door.in)); o.append(ZD.v2(z.door.out))
				var dout = ZD.v2(z.door.out)
				at = dout + (r.get_center() - dout).normalized() * minf(220.0, dout.distance_to(r.get_center()))
			if TA.on(tk): at = TA.spot(tk)
			return {"at": at, "path": _rally(o, at), "zid": zid, "tkey": tk}
		"raid":
			if opt.get("at") is Vector2:   # 村子襲擾：由兵營（冇就村中心）出發，迎擊行入嚟嘅惡鬼
				var at: Vector2 = opt.at
				var P = J.G.get("POS")
				var st = village_cross()
				if P is Dictionary and P.has("barracks") and load("res://game/barracks/bk_data.gd").built(): st = Vector2(J.num(P.barracks[0]), J.num(P.barracks[1])) + Vector2(0, 30)
				var fr = opt.get("from", at + Vector2(0, -300))
				return {"at": at, "path": _rally(PackedVector2Array([st]), at), "from": fr}
			var at2 = ZD.front_anchor() + CAMP_OFF   # 大排檔鬼潮告急：惡鬼由野外門入嚟
			var wz = ZD.of_type("wild")
			var fr2 = TA.gate_of(str(wz[0].id))[0] if wz.size() else at2 + Vector2(0, -200)
			return {"at": at2, "path": stage_path(at2), "from": fr2}
	return {}

static func _count(op) -> Dictionary:
	var r = {"hero": 0, "yin": 0, "ml": 0, "foe": 0}
	for u in op.units:
		if J.num(u.side) == 1: r.foe += 1
		elif u.get("ml") != null: r.ml += 1
		elif J.t(u.get("minion")): r.yin += 1
		else: r.hero += 1
	return r
# 借 Battle.start 生成單位（唔開舊畫面），即刻關返
static func _start_battle(cb: Callable) -> Dictionary:
	var G = J.G
	var ob = G.get("__nat_battle"); var osz = G.get("__nat_btSize")
	G["__nat_battle"] = func(_t, _a): return true
	G["__nat_btSize"] = func(_t, _a): return [390.0, 560.0]
	cb.call()
	G["__nat_battle"] = ob; G["__nat_btSize"] = osz
	var B = G.get("Battle")
	if not (B is Dictionary) or not J.t(B.get("active")): return {}
	var snap = {"units": B.units}
	for k in ["stage", "sid", "ci", "si", "bg", "retake", "adviser", "comboSkill", "squads", "ml_ext", "ml_foe", "ml_my", "ml_sq"]: snap[k] = B.get(k)
	B["active"] = false
	var f = G.get("$")
	var be = J.cl(f, null, ["#battle"]) if f != null else null
	if be != null: J.mc(J.gp(be, "classList"), "remove", ["on"])
	var Sd = G.get("Sound")
	if Sd != null: J.mc(Sd, "setMode", ["village"])
	return snap

# ================= 叫回／鏡頭 =================
static func recall(op) -> void:
	if op == null or op.phase in ["back", "done"]: return
	LOG.append(["recall", op.sid, op.phase])
	op.recall()
static func focus(op) -> void:
	var m = _main()
	var nv = m.get("village") if m != null else null
	if nv != null and nv.has_method("zone_cam"): nv.zone_cam().glide_to(op.center())

# ================= 每格（rts_view 叫；同一格只行一次） =================
static func tick(dt: float) -> void:
	var f = Engine.get_process_frames()
	if f == _last_f: return
	_last_f = f
	dt = minf(dt, 0.1)
	for op in ops.duplicate():
		op.step(dt)
		if op.phase == "end" and not op.settled:
			if _settle(op): op.settled = true; op.begin_back()
		if op.phase == "done":
			ops.erase(op); LOG.append(["done", op.sid])
			var tk = str(op.get_meta("tkey", ""))
			if tk != "": TA.hide_keys.erase(tk)
	if pending != null and Engine.get_process_frames() > _pend_f + 2:
		var m = _main()
		var sh = m.get("sheet") if m != null else null
		if sh == null or not sh.visible: var p = pending; pending = null; _cancel(p)

# ================= 結算：交返 Battle.finish（舊程式） =================
static func _settle(op) -> bool:
	var r = op.result
	if r == null: return false
	if J.t(r.get("none")): return true
	if op.has_meta("custom"):   # 純兵出擊：結果交返舊規則
		var rep0 = op.get_meta("custom").call(J.t(r.win) and not J.t(r.get("quit")))
		if not (rep0 is Dictionary): rep0 = {"head": "", "reward": "", "lost": []}
		rep0["win"] = r.win; rep0["sid"] = op.sid
		op.set_meta("report", rep0); LOG.append(["settle", op.sid, r.win, rep0])
		if str(rep0.head) != "": toast(str(rep0.head))
		return true
	var B = J.G.get("Battle")
	if not (B is Dictionary): return true
	if J.t(B.get("active")): return false   # 舊版戰鬥打緊（例如其他戰鬥未改）：等佢完先
	var snap: Dictionary = op.get_meta("snap")
	for k in snap: B[k] = snap[k]
	B["units"] = op.units; B["result"] = null; B["coinsWon"] = op.coins_won; B["t"] = op.t; B["proj"] = []; B["fx"] = []
	B["advCast"] = null; B["comboCast"] = null; B["active"] = true
	var cl0 = (J.G.S.cleared as Dictionary).duplicate() if J.G.get("S") is Dictionary and J.G.S.get("cleared") is Dictionary else {}
	J.mc(B, "finish", [r.win, r.quit, r.timeout])
	var f = J.G.get("$")
	var box = J.cl(f, null, ["#b-result"]) if f != null else null
	var rep = _report(J.str(J.gp(box, "innerHTML")) if box != null else "")
	rep["win"] = r.win; rep["sid"] = op.sid; rep["first"] = r.win and not J.t(cl0.get(op.sid))
	var okb = J.cl(f, null, ["#b-ok"]) if f != null else null
	if okb != null and J.gp(okb, "onclick") != null: J.cl(J.gp(okb, "onclick"), okb, [])   # 自動「繼續」（_on_ok：主線推進、關後劇情）
	B["active"] = false
	if box != null: J.mc(J.gp(box, "classList"), "remove", ["on"])
	# 入口自己嘅結果（王／親征：zone exp；襲擾；鬼潮）——即刻收，唔好畀下一場 Battle.start 蓋咗
	ZD.poll()
	load("res://game/raid/raid.gd").poll_fight()
	load("res://game/outpost/mv_war.gd").poll()
	B["result"] = null   # 收完即清：唔好俾下一場同名（再挑戰）一開就被當成舊結果
	var tk = str(op.get_meta("tkey", ""))
	if tk != "" and op.kind in ["boss", "cap"] and not J.t(r.get("none")):
		var zid = str(op.get_meta("zid", ""))
		if r.win:
			if TA.on(tk): TA.clear(tk)
		else: TA.set_on(tk, op.kind, zid)   # 輸／撤退：王企喺門外叫囂（同舊版）
	op.set_meta("report", rep)
	last_report = rep
	LOG.append(["settle", op.sid, r.win, rep])
	var lines = [rep.head]
	if rep.reward != "": lines.append(rep.reward)
	for x in rep.lost: lines.append(x)
	toast("　".join(lines))
	return true
static func _strip(h: String) -> String:
	var re = RegEx.new(); re.compile("<[^>]*>")
	return re.sub(h, "", true).strip_edges()
static func _report(html: String) -> Dictionary:
	var o = {"head": "", "reward": "", "quip": "", "lost": []}
	var re = RegEx.new(); re.compile("<h2>(.*?)</h2>")
	var m = re.search(html)
	if m: o.head = _strip(m.get_string(1))
	var rp = RegEx.new(); rp.compile("<p( class=\"([a-z]+)\")?>(.*?)</p>")
	for mm in rp.search_all(html):
		var cls = mm.get_string(2); var tx = _strip(mm.get_string(3))
		if tx == "": continue
		if cls == "quip": o.quip = tx
		elif cls == "lost": o.lost.append(tx)
		elif o.reward == "" and not tx.begins_with("提示"): o.reward = tx
	return o
