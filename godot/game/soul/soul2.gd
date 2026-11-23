# [soul2] 養成第二部份：抄功課（掃蕩）、王座重遊（劇情王）、名鬼圖鑑完成獎、戰後掛鈎（全部 static；冇 class_name、冇 autoload）
#   const S2 = preload("res://game/soul/soul2.gd")
#   設計稿：/home/claude/bs/soul.md 第 3.2 節（抄功課）、3.1（王座重遊）、7.2（圖鑑完成獎）；PLAN.md 第 5 節
#   存檔（全部喺 S.soul，讀一律 .get）：swp{day, n}、swp_gp{"c:id": 鬼力}、king{day, done{k:1}}、ms{"10":1}
#   唔改 soul 線邏輯：只叫 soul_data 嘅公開函數（st、on_sortie_win、gain、guard_of……）
extends RefCounted

const SOUL = preload("res://game/soul/soul_data.gd")
const SO = preload("res://game/sortie/so_data.gd")
const ZD = preload("res://game/zone/zone_data.gd")
const CODEX_PATH := "res://data/nat/codex.json"

# ======================= 常數（測試員試玩後只改呢度） =======================
const SWEEP_WINS := 3          # 據點贏過幾次先可以抄功課
const SWEEP_DAY := 20          # 每日上限（全部據點共用）
const SWEEP_GP := 0.9          # 出陣鬼力要 ≥ 上次贏嗰陣 90%
const THRONE_SOULS := 3        # 王座重遊：每次贏掉該王魂魄
const THRONE_MUL := 1.1        # 難度 = 原王戰 × 1.1
const MS_STEP := 10            # 圖鑑：每招降 10 隻一個獎
const MS_SAN := 20             # 完成獎：散魂
const MS_CHEST := "p"          # 完成獎：紫箱 ×1

static var LOG: Array = []
static var _C = null
static var last_sweep := {}

static func L(yue: String, zhs: String) -> String: return SOUL.L(yue, zhs)
static func S(): return SOUL.S()
static func o():   # S.soul（補齊本線欄位）
	var x = SOUL.st()
	if x == null: return null
	if not (x.get("swp") is Dictionary): x["swp"] = {"day": -1.0, "n": 0.0}
	if not (x.get("swp_gp") is Dictionary): x["swp_gp"] = {}
	if not (x.get("king") is Dictionary): x["king"] = {"day": -1.0, "done": {}}
	if not (x.king.get("done") is Dictionary): x.king["done"] = {}
	if not (x.get("ms") is Dictionary): x["ms"] = {}
	return x
static func _main(): return Engine.get_main_loop().root.get_node_or_null("Main") if Engine.get_main_loop() != null else null
static func _toast(m: String) -> void:
	var mm = _main()
	if mm != null and mm.has_method("show_toast"): mm.show_toast(m)
static func _save() -> void:
	var f = J.G.get("save")
	if f != null: J.cl(f, null, [])
static func team_pow() -> int: return int(load("res://game/outpost/act_targets.gd").team_pow())

# ======================= 圖鑑資料 =======================
static func C() -> Dictionary:
	if _C == null:
		var f = FileAccess.open(CODEX_PATH, FileAccess.READ)
		var d = JSON.parse_string(f.get_as_text()) if f != null else null
		_C = d if d is Dictionary else {}
		for k in ["SYS", "SC", "TAGS", "MECH", "REG"]: if not (_C.get(k) is Dictionary): _C[k] = {}
		if not (_C.get("LIST") is Array): _C["LIST"] = []
		var by = {}
		for x in _C.LIST: by[str(x.k)] = x
		_C["BY"] = by
	return _C
static func entry(k: String) -> Dictionary: return C().BY.get(k, {})
static func list() -> Array: return C().LIST
static func pin(k: String) -> String:
	if k == "afu": return "主"
	if SOUL.D().PIN.has(k): return SOUL.pin(k)
	var p = str(entry(k).get("pin", ""))
	return p if p in SOUL.PINS else SOUL.pin(k)
static func sys_of(k: String) -> String:   # 8 系：abil.json 有就用，否則用 codex.json
	var AB = _ab()
	if AB != null:
		var e = AB._ent("ABIL", k) if abm("_ent") else {}
		if e is Dictionary and str(e.get("sys", "")) != "": return str(e.sys)
	return str(entry(k).get("sys", ""))
static func tags_of(k: String) -> Array:
	var AB = _ab()
	if AB != null and abm("tags_of"):
		var t = AB.tags_of(k)
		if t is Array and t.size(): return t
	return entry(k).get("tags", [])
static var _abs = null
static var _abn := {}
static func abm(n: String) -> bool:   # abil.gd 有冇呢個函數
	var AB = _ab()
	if AB == null: return false
	if _abn.is_empty():
		for m in AB.get_script_method_list(): _abn[str(m.name)] = true
	return _abn.has(n)
static func _ab():   # abcore 線 abil.gd（未合併就 null）
	if _abs == null:
		_abs = false
		if ResourceLoader.exists("res://game/rts/abil.gd"): _abs = load("res://game/rts/abil.gd")
	return _abs if not (_abs is bool) else null
# 四種狀態：own（已招降）／prog（有魂魄未招降）／seen（已遇見）／unseen（未遇見）
static func state(k: String) -> String:
	if k == "afu": return "own"
	if not SOUL.is_ghost(k): return "unseen"   # 新鬼未有數據：一律未遇見
	if SOUL.owned(k): return "own"
	if SOUL.souls(k) > 0: return "prog"
	if SOUL.seen(k): return "seen"
	return "unseen"
static func got_n() -> int:   # 已招降（唔計阿福）
	var n = 0
	for x in list():
		var k = str(x.k)
		if k != "afu" and SOUL.is_ghost(k) and SOUL.owned(k): n += 1
	return n
static func total() -> int: return maxi(0, list().size() - 1)

# ---- 完成獎：每 10 隻 ----
static func ms_list() -> Array:   # [{m, state:"got"／"can"／"lock"}]
	var x = o(); var n = got_n(); var out = []
	var m = MS_STEP
	while m <= total() + MS_STEP - 1:
		var mm = mini(m, total())
		var st = "got" if x != null and J.t(x.ms.get(str(mm))) else ("can" if n >= mm else "lock")
		out.append({"m": mm, "state": st})
		if mm >= total(): break
		m += MS_STEP
	return out
static func ms_claim(m: int) -> String:
	var x = o()
	if x == null: return "no"
	if J.t(x.ms.get(str(m))): return "got"
	if got_n() < m: return "lock"
	x.ms[str(m)] = 1.0
	SOUL.add_san(MS_SAN, "codex:%d" % m)
	var s = S()
	if not (s.get("chests") is Dictionary): s["chests"] = {"g": 0, "b": 0, "p": 0}
	s.chests[MS_CHEST] = int(J.num(s.chests.get(MS_CHEST, 0))) + 1
	LOG.append(["ms", m])
	_save()
	return "ok"
static func ms_text(m: int) -> String: return L("年度員工大合照（%d 隻）：散魂 +%d、紫箱 ×1", "年度員工大合照（%d 隻）：散魂 +%d、紫箱 ×1") % [m, MS_SAN]

# ======================= 抄功課（掃蕩） =======================
static func swp_today() -> int:
	var x = o()
	if x == null: return 0
	if int(J.num(x.swp.get("day", -1))) != SOUL.today(): x["swp"] = {"day": float(SOUL.today()), "n": 0.0}
	return int(J.num(x.swp.get("n", 0)))
# 回 {ok, why, wins, left, gp, need_gp, cost}
static func can_sweep(e: Dictionary) -> Dictionary:
	var out = {"ok": false, "why": "", "wins": 0, "left": 0, "gp": 0, "need_gp": 0, "cost": {}}
	var x = o()
	if x == null or e.is_empty(): out.why = "no"; return out
	var c = SO.cst(e)
	out.wins = int(J.num(c.get("wins", 0)))
	out.left = SWEEP_DAY - swp_today()
	var lu = SO.lineup(); out.cost = SO.cost(e, lu)
	out.gp = team_pow()
	out.need_gp = int(ceil(J.num(x.swp_gp.get(SOUL.ckey(e), 0)) * SWEEP_GP))
	var st = SO.state(e)
	if st == "locked": out.why = "locked"; return out
	if out.wins < SWEEP_WINS: out.why = "wins"; return out
	if st == "cleared": out.why = "cleared"; return out
	if st == "out": out.why = "out"; return out
	if out.left <= 0: out.why = "cap"; return out
	if lu.hero <= 0: out.why = "noteam"; return out
	if out.gp < out.need_gp: out.why = "gp"; return out
	if not SO.afford(out.cost): out.why = "poor"; return out
	out.ok = true
	return out
static func why_text(c: Dictionary) -> String:
	match str(c.why):
		"wins": return L("要贏夠 %d 次先抄得（而家 %d/%d）", "要贏夠 %d 次才能抄（現在 %d/%d）") % [SWEEP_WINS, int(c.wins), SWEEP_WINS]
		"cap": return L("今日抄夠 %d 次喇，聽日 05:00 再嚟", "今天已抄 %d 次，明天 05:00 再來") % SWEEP_DAY
		"gp": return L("隊伍鬼力 %d，要 %d（上次贏嗰陣嘅 90%%）", "隊伍鬼力 %d，需要 %d（上次獲勝時的 90%%）") % [int(c.gp), int(c.need_gp)]
		"poor": return L("資源不夠，抄唔到", "資源不夠，不能抄")
		"cleared": return L("據點已清空，等重生", "據點已清空，等重生")
		"noteam": return L("未有出戰名鬼", "還沒有出戰名鬼")
		"out": return L("出擊中", "出擊中")
		"locked": return L("未開放", "未開放")
	return ""
# 一鍵重打：扣同一份消耗 → 即刻結算（照 so_data.reward：冥幣、棺材板、極稀有＋保底、清空重生）＋「再打」獎（冥幣 20×lv、好評 8×lv）＋魂魄（怨氣照計）
# 回 {ok, why, line, soul, rare}
static func sweep(e: Dictionary) -> Dictionary:
	var c = can_sweep(e)
	if not c.ok: return {"ok": false, "why": c.why}
	var x = o()
	SO.pay(c.cost)
	var cs = SO.cst(e); cs["tries"] = J.num(cs.get("tries", 0)) + 1
	var lv = float(e.lv)
	var give = J.G.get("give")
	var rt = {"coins": 20.0 * lv, "exp": 8.0 * lv}
	if give != null: J.cl(give, null, [rt])
	else:
		var s = S(); s.res["coins"] = SO.have("coins") + rt.coins
	var g = SO.reward(e)
	var sl = SOUL.on_sortie_win(e, false)
	x.swp["n"] = float(swp_today() + 1)
	var lines = [L("抄功課：%s", "抄功課：%s") % SO.title(e), L("冥幣 +%d　好評 +%d　棺材板 +%d", "冥幣 +%d　好評 +%d　棺材板 +%d") % [int(g.coin + rt.coins), int(rt.exp), SO.REW_PLANK[SO.ri(int(e.ring))]]]
	if g.rare != "": lines.append(L("極稀有！", "極稀有！") + g.rare)
	if str(sl.line) != "": lines.append(str(sl.line))
	var out = {"ok": true, "why": "", "line": "　".join(lines), "soul": sl, "rare": g.rare, "n": swp_today(), "cost": c.cost}
	last_sweep = out
	LOG.append(["sweep", SOUL.ckey(e), out])
	_save()
	return out
static func sweep_quip() -> String:
	return L("阿福影印咗上次份戰報，交咗上去。系統：「親，格式完全一樣，好有效率呢～」", "阿福影印了上次那份戰報，交了上去。系統：「親，格式完全一樣，很有效率呢～」")

# ======================= 戰後掛鈎（so_data.settle 打贏） =======================
static func after_win(op, e: Dictionary, sl) -> void:
	var x = o()
	if x == null: return
	x.swp_gp[SOUL.ckey(e)] = float(team_pow())   # 抄功課門檻：今次贏嗰陣鬼力
	if op != null:   # 戰場上見過嘅名鬼：記「遇見」
		for u in J.iter(op.units):
			if J.num(u.get("side")) == 1 and SOUL.is_ghost(J.str(u.get("k"))): x.seen[J.str(u.k)] = 1.0
	if sl is Dictionary and op != null:
		load("res://game/soul/soul_fx.gd").soul_fire(op, sl)

# ======================= 王座重遊（劇情王，每王每日 1 次） =======================
static func kings() -> Array:   # [{k, ks:[掉魂魄嘅名鬼], ci, si, sid, name}]
	var out = []
	var CH = J.G.get("CHAPTERS")
	if not (CH is Array): return out
	for ci in CH.size():
		var sts = CH[ci].get("stages", [])
		for si in sts.size():
			var st = sts[si]
			var b = J.str(st.get("boss"))
			if b == "" or SOUL.unsummonable(b) or not SOUL.story(b) or not SOUL.is_ghost(b): continue
			var ks = [b]
			for k in J.iter(st.get("en")):
				var kk = J.str(k)
				if kk != b and SOUL.story(kk) and SOUL.is_ghost(kk) and not (kk in ks): ks.append(kk)
			var nm = "、".join(ks.map(func(q): return SOUL.gname(q))) if ks.size() > 1 else SOUL.gname(b)
			out.append({"k": b, "ks": ks, "ci": ci, "si": si, "sid": "%d-%d" % [ci + 1, si + 1], "name": nm})
	return out
static func king(k: String) -> Dictionary:
	for x in kings(): if str(x.k) == k: return x
	return {}
static func _kday() -> Dictionary:
	var x = o()
	if int(J.num(x.king.get("day", -1))) != SOUL.today(): x["king"] = {"day": float(SOUL.today()), "done": {}}
	return x.king
static func can_throne(k: String) -> Dictionary:
	var out = {"ok": false, "why": ""}
	var x = o(); var kd = king(k)
	if x == null or kd.is_empty(): out.why = "no"; return out
	var s = S()
	if not J.t(J.gp(s.get("cleared", {}), str(kd.sid))): out.why = "lock"; return out
	if J.t(_kday().done.get(k)): out.why = "done"; return out
	var RTS = load("res://game/rts/rts.gd")
	if not ZD.team_ok(): out.why = "noteam"; return out
	if RTS.busy_reason() != "": out.why = "busy"; return out
	if RTS.op_for(throne_sid(kd)) != null: out.why = "out"; return out
	out.ok = true
	return out
static func throne_why(c: Dictionary, kd: Dictionary) -> String:
	match str(c.why):
		"lock": return L("打完主線 %s 先開", "通關主線 %s 後開放") % str(kd.get("sid", ""))
		"done": return L("今日挑戰咗，聽日 05:00 再嚟", "今天已挑戰，明天 05:00 再來")
		"noteam": return L("未有出戰隊伍", "還沒有出戰隊伍")
		"busy": return load("res://game/rts/rts.gd").busy_reason()
		"out": return L("出擊中", "出擊中")
	return ""
static func throne_sid(kd: Dictionary) -> String: return "王座·" + str(kd.get("k", ""))
static func throne_mul(kd: Dictionary) -> float:   # 原王戰（第 5、6 章主線有 SOFT 打折）× 1.1
	var RTS = load("res://game/rts/rts.gd")
	return float(RTS.SOFT.get(int(kd.ci), 1.0)) * THRONE_MUL
# 開打：同野外出擊一樣借 Battle.start 生成單位 → 地圖戰鬥；結果由本檔結算（唔經 Battle.finish，唔推主線）
static func throne_go(k: String) -> String:
	var c = can_throne(k)
	if not c.ok: return str(c.why)
	var kd = king(k)
	var RTS = load("res://game/rts/rts.gd")
	var B = J.G.get("Battle")
	var CH = J.G.get("CHAPTERS")
	if not (B is Dictionary) or not (CH is Array): return "nobattle"
	var stg = (CH[int(kd.ci)].stages[int(kd.si)] as Dictionary).duplicate(true)
	stg["name"] = L("王座重遊：%s", "王座重遊：%s") % str(kd.name)
	stg.erase("after")
	var sid = throne_sid(kd)
	var wild = {"stage": stg, "bg": str(CH[int(kd.ci)].get("bg", "field")), "sid": sid, "throne": true}
	var snap = RTS._start_battle(func(): J.mc(B, "start", [-1.0, -1.0, wild]))
	if snap.is_empty(): return "nobattle"
	var mul = throne_mul(kd)
	for u in snap.units:
		if J.num(u.get("side")) != 1: continue
		u["hp"] = J.num(u.hp) * mul; u["maxhp"] = u.hp
		u["atk"] = J.num(u.get("atk")) * mul
	var geo = _throne_geo()
	var op = RTS.SIM.new()
	op.id = RTS._next_id; RTS._next_id += 1
	op.kind = "throne"; op.sid = sid
	op.title = L("王座：%s", "王座：%s") % str(kd.name)
	op.adviser = snap.get("adviser")
	op.set_meta("snap", snap); op.set_meta("zid", str(geo.get("zid", ""))); op.set_meta("throne", k)
	op.set_meta("custom", func(win): return on_throne_end(k, win))
	op.setup(snap.units, geo.path, geo.at, RTS.gate_pos())
	RTS.ops.append(op)
	LOG.append(["throne", k, mul])
	var m = _main()
	var nv = m.get("village") if m != null else null
	if nv != null and nv.has_method("zone_cam"):
		var cam = nv.zone_cam()
		if not cam.rect().grow(-60).has_point(op.path[0]): cam.glide_to(op.path[0].lerp(op.path[mini(1, op.path.size() - 1)], 0.5))
	Snd.play("click")
	return "ok"
static func _throne_geo() -> Dictionary:   # 喺今關主線王嘅野外區（王座）開打；冇就喺大排檔前
	var RTS = load("res://game/rts/rts.gd")
	for z in ZD.of_type("wild"):
		for b in ZD.bosses(str(z.id)):
			if J.t(b.get("main")):
				var r = ZD.rect(z.rect)
				var at = ZD.v2(z.get("boss_at", [r.get_center().x, r.get_center().y]))
				return {"at": at, "path": RTS.wild_path(str(z.id), at), "zid": str(z.id)}
	var at2 = ZD.front_anchor() + RTS.CAMP_OFF
	return {"at": at2, "path": RTS.stage_path(at2)}
static func on_throne_end(k: String, win: bool) -> Dictionary:
	var kd = king(k)
	var rep = {"head": "", "reward": "", "lost": []}
	if not win:
		rep.head = L("王座重遊：撤退（今日仲可以再挑戰）", "王座重遊：撤退（今天還可以再挑戰）")
		LOG.append(["throne_end", k, false])
		return rep
	_kday().done[k] = 1.0
	var parts = []
	for kk in J.iter(kd.get("ks", [k])):
		var g = SOUL.gain(J.str(kk), THRONE_SOULS, "throne")
		parts.append(SOUL._gain_txt(g))
	rep.head = L("王座重遊：%s 再打低一次！", "王座重遊：%s 再次擊敗！") % str(kd.get("name", k))
	rep.reward = L("魂魄：", "魂魄：") + "、".join(parts)
	rep.lost.append(rep.reward)
	LOG.append(["throne_end", k, true, parts])
	_toast(rep.head + "　" + rep.reward)
	_save()
	return rep

# ======================= 出擊小卡：抄功課掣（so_view.open_card 掛鈎） =======================
static func card_row(vb: VBoxContainer, e: Dictionary) -> void:   # 掣擺喺「出擊／關閉」同一行（小卡唔加高）；抄唔到就喺上面加一行短原因
	if o() == null or e.is_empty() or vb.get_child_count() == 0: return
	var c = can_sweep(e)
	if str(c.why) == "locked": return
	var bb = vb.get_child(vb.get_child_count() - 1)
	if not (bb is HBoxContainer): bb = HBoxContainer.new(); vb.add_child(bb)
	var b = Button.new(); b.name = "SweepBtn"; b.focus_mode = Control.FOCUS_NONE
	var on = bool(c.ok)
	b.text = L("抄功課 %d/%d", "抄功課 %d/%d") % [swp_today(), SWEEP_DAY]
	b.custom_minimum_size = Vector2(118, 42)
	var sib = bb.get_children().filter(func(x): return x is Button)   # 手機直屏：三個掣要擺得落一行（出擊 104、關閉 72）
	if sib.size() >= 1: sib[0].custom_minimum_size.x = minf(sib[0].custom_minimum_size.x, 104.0)
	if sib.size() >= 2: sib[1].custom_minimum_size.x = minf(sib[1].custom_minimum_size.x, 72.0)
	bb.add_theme_constant_override("separation", 8)
	var gs = UIKit.sb(Color("#2e4a6a") if on else Color("#4a4440"), 8, Color("#9ad0ff") if on else Color("#706860"), 2, Vector4(8, 4, 8, 4))
	for k in ["normal", "hover", "pressed", "disabled"]: b.add_theme_stylebox_override(k, gs)
	b.add_theme_font_override("font", UIKit.font("sans", 900)); b.add_theme_font_size_override("font_size", 16)
	for k in ["font_color", "font_hover_color", "font_pressed_color", "font_disabled_color"]: b.add_theme_color_override(k, Color("#eef6ff") if on else Color("#a8a0a0"))
	b.disabled = not on
	b.pressed.connect(func(): press_sweep(e))
	bb.add_child(b)
	if on: return   # 可以抄：唔加行（小卡唔加高）
	var t = short_why(c)
	var l = UIKit.label(t, 15, Color("#d0c4b8"), "sans", 900); l.name = "SweepWhy"
	l.autowrap_mode = TextServer.AUTOWRAP_ARBITRARY; l.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	vb.add_child(l); vb.move_child(l, bb.get_index())
static func short_why(c: Dictionary) -> String:
	match str(c.why):
		"wins": return L("抄功課：贏夠 %d 次先開（%d/%d）", "抄功課：贏夠 %d 次才開（%d/%d）") % [SWEEP_WINS, int(c.wins), SWEEP_WINS]
		"cap": return L("抄功課：今日 %d 次用晒（05:00 重置）", "抄功課：今天 %d 次已用完（05:00 重置）") % SWEEP_DAY
		"gp": return L("抄功課：鬼力 %d／要 %d", "抄功課：鬼力 %d／需 %d") % [int(c.gp), int(c.need_gp)]
		"poor": return L("抄功課：資源不夠", "抄功課：資源不夠")
		"cleared": return L("抄功課：等據點重生", "抄功課：等據點重生")
		"noteam": return L("抄功課：未有出戰名鬼", "抄功課：還沒有出戰名鬼")
		"out": return L("抄功課：出擊中", "抄功課：出擊中")
	return ""
static func press_sweep(e: Dictionary) -> Dictionary:
	var r = sweep(e)
	var SOV = load("res://game/sortie/so_view.gd")
	if not r.ok:
		var t = why_text({"why": r.why, "wins": 0, "gp": 0, "need_gp": 0})
		if t != "": load("res://game/rts/rts.gd").toast(t)
		return r
	SOV.close_card()
	load("res://game/soul/soul_fx.gd").photocopy(SO.title(e), str(r.line))
	load("res://game/rts/rts.gd").toast(str(r.line) + "　" + sweep_quip())
	Snd.play("paper")
	return r
