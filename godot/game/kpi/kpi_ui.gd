# [kpi] 考核牌彈出卡＋考核劇情＋結果橫額（UI 層；規則喺 kpi_data.gd）
#   const KU = preload("res://game/kpi/kpi_ui.gd")
#   KU.open(main, gid)：彈考核卡（第一次撳先播「巡查」，播完開始倒數）
#   KU.eat_news(main)：main 每格叫，處理逾期（Bryan）、賄賂結果、達標
#   KU.scene(key)：由 kpi.json 砌劇情（男女主分句、少爺／大小姐）
extends RefCounted

const KG = preload("res://game/kpi/kpi_data.gd")
static var play_fn := Callable()   # 測試用：Callable(scene, done)
static var PLAYED: Array = []      # 測試用：播過嘅場景 key

static func L(yue: String, zhs: String) -> String: return zhs if DB.lang != "yue" else yue

# ---------------- 劇情 ----------------
static func scene(key: String) -> Dictionary:
	var sd = KG.D().get("scenes", {}).get(key)
	if not (sd is Dictionary): return {}
	var f = DB.hero_female()
	var yue = DB.lang == "yue"
	var ls = []
	for l in sd.get("lines", []):
		if not (l is Array) or l.size() < 2: continue
		if l.size() >= 4:
			var c = str(l[3])
			if c == "m" and f: continue
			if c == "f" and not f: continue
		var tx = str(l[1]) if yue or l.size() < 3 else str(l[2])
		tx = tx.replace("{少爺}", "大小姐" if f else "少爺")
		if tx.contains("{rebuilt}"): tx = tx.replace("{rebuilt}", cn_num(int(KG.metric("rebuilt"))))
		ls.append([str(l[0]), tx])
	return {"style": "talk", "bg": "village", "title": str(sd.get("title", "")), "lines": ls}
static func cn_num(n: int) -> String:
	var D = ["零", "一", "兩", "三", "四", "五", "六", "七", "八", "九", "十"]
	return D[n] if n >= 0 and n <= 10 else str(n)
static func play(main, key: String, extra_sys := "", cb := Callable()) -> void:
	var sc = scene(key)
	if sc.is_empty():
		if cb.is_valid(): cb.call()
		return
	if extra_sys != "": sc.lines.append(["系統", extra_sys])
	PLAYED.append(key)
	if play_fn.is_valid(): play_fn.call(sc, cb); return
	var p = main.get("story") if main != null else null
	if p is Control and p.has_method("queue"): p.queue(sc, cb); return
	var st = J.G.get("Story")
	if st is Dictionary: J.mc(st, "queue", [sc, func(_t, _a): (cb.call() if cb.is_valid() else null); return null]); return
	if cb.is_valid(): cb.call()

# ---------------- 考核卡 ----------------
static func _fmt_t(s: float) -> String:
	var n = maxi(0, int(s))
	return "%d:%02d" % [n / 60, n % 60]
static func _cost_txt(c: Dictionary) -> String:
	var a = []
	for k in c: a.append("%s %d" % [KG.mname(str(k)), int(J.num(c[k]))])
	return "、".join(a)
static func open(main, gid: String) -> void:
	if main == null: return
	if not KG.active(gid):
		if main.has_method("show_toast"): main.show_toast(L("呢區要等上一個考核達標先開", "這區要等上一個考核達標才開放"))
		return
	var g = KG.gs(gid)
	if not J.t(g.get("started")):   # 第一次：播巡查，播完開始倒數再開卡
		play(main, "kpi_%s_open" % str(KG.gate(gid).boss), "", func():
			KG.start(gid)
			_sheet(main, gid))
		return
	_sheet(main, gid)
static func _sheet(main, gid: String) -> void:
	var gd = KG.gate(gid); var g = KG.gs(gid)
	main.open_sheet(L("%s・KPI 考核", "%s・KPI 考核") % str(gd.boss_n), func(): _sheet(main, gid))
	var body = main.sheet_body
	var R = func(bb: String, sz := 16): var r = UIKit.rich(bb, sz, UIKit.INKTXT); body.add_child(r); return r
	R.call("[color=#6b5e52]%s[/color]" % str(gd.get("title", "")), 14)
	R.call("[b]%s[/b]　[color=#a8322a]%s[/color]" % [L("本季度剩", "本季度剩"), _fmt_t(J.num(g.left))], 17)
	for p in KG.progress(gid):
		var col = "#3d7a3a" if p.met else "#a8322a"
		var st = L("（免考：已打點）", "（免考：已打點）") if p.skip else ""
		var nd = int(p.need)
		var cut = "" if p.skip or nd == int(p.base) else "[color=#8a7a6a]（原本 %d）[/color]" % int(p.base)
		R.call("%s　[color=%s][b]%d / %d[/b][/color]%s%s" % [p.label, col, int(p.cur), nd, cut, st], 17)
	if J.num(g.get("plus", 0.0)) > 0.0: R.call("[color=#a8322a]%s[/color]" % L("上一區被馬面拍照存證：本區 KPI +10%", "上一區被馬面拍照存證：本區 KPI +10%"), 14)
	if g.stolen.size() > 0: R.call("[color=#a8322a]%s[/color]" % (L("Bryan 搶功拎走：%s（達標可追回一半）", "Bryan 搶功拿走：%s（達標可追回一半）") % KG.stolen_txt(gid)), 14)
	R.call(L("倒數完仲未達標：Bryan 會嚟搶功（拎走倉庫最多嗰樣 10%），倒數重來。", "倒數結束仍未達標：Bryan 會來搶功（拿走倉庫最多那樣的 10%），倒數重來。"), 13)
	body.add_child(UIKit.hsep())
	var b1 = UIKit.btn(L("交考核", "交考核"), "gold")
	b1.disabled = not KG.all_met(gid)
	b1.pressed.connect(func(): _submit(main, gid))
	body.add_child(b1)
	if J.t(gd.get("nobribe")):
		var bp = UIKit.btn(L("送龐總一籠包子（普通包子 10）", "送龐總一籠包子（普通包子 10）"), "")
		bp.disabled = M_amt("m_bao") < 10.0
		bp.pressed.connect(func():
			if KG.gift_pang(gid).get("ok"):
				main.close_sheet(); play(main, "kpi_pang_bribe", L("（考核指標冇變）", "（考核指標沒有變化）"), func(): _sheet(main, gid)))
		body.add_child(bp)
		return
	var why = KG.can_bribe(gid)
	R.call("[b]%s[/b]" % L("請牛頭馬面飲茶", "請牛頭馬面飲茶"), 16)
	if why == "used": R.call(L("呢區已經打點過（每區一次）", "這區已經打點過（每區一次）"), 14); return
	if J.t(g.get("rebribe")): R.call("[color=#3d7a3a]%s[/color]" % L("老闆話再送一次就算：今次唔會畀人撞破", "老闆說再送一次就算：這次不會被撞破"), 14)
	if J.num(KG.st().get("disc", 0.0)) > 0.0: R.call("[color=#3d7a3a]%s[/color]" % L("牛頭馬面心虛：今次賄賂半價", "牛頭馬面心虛：這次賄賂半價"), 14)
	R.call(L("牛頭只收名牌（收據一式三份），馬面只收食物。送錯：點心減半；名牌送馬面會被退回，仲要加 KPI。", "牛頭只收名牌（收據一式三份），馬面只收食物。送錯：點心效果減半；名牌送馬面會被退回，還要加 KPI。"), 13)
	var rows = [["snack", "ma", L("點心 → 馬面：最差一項 -20%", "點心 → 馬面：最差一項 -20%")],
		["watch", "niu", L("名錶 → 牛頭：最差一項免考（20% 被拍照：下一區 +10%）", "名錶 → 牛頭：最差一項免考（20% 被拍照：下一區 +10%）")],
		["car", "niu", L("跑車 → 牛頭：全部 -40%（30% 被老闆撞破）", "跑車 → 牛頭：全部 -40%（30% 被老闆撞破）")],
		["snack", "niu", L("點心 → 牛頭（送錯：-10%）", "點心 → 牛頭（送錯：-10%）")],
		["watch", "ma", L("名錶 → 馬面（會被退回）", "名錶 → 馬面（會被退回）")]]
	for r in rows:
		var cost = KG.bribe_cost(r[0])
		var b = UIKit.btn("%s　[%s]" % [r[2], _cost_txt(cost)], "")
		b.disabled = not KG.can_pay(cost)
		var t0 = r[0]; var to0 = r[1]
		b.pressed.connect(func(): _bribe(main, gid, t0, to0))
		body.add_child(b)
static func M_amt(m: String) -> float: return KG.amt_of(m)

static func _eff_txt(o: Dictionary) -> String:
	match str(o.get("eff", "")):
		"skip1": return L("「%s」一項免考", "「%s」一項免考") % _label(str(o.gid), str(o.key))
		"cut1": return L("「%s」指標減 %d%%", "「%s」指標減 %d%%") % [_label(str(o.gid), str(o.key)), int(round(J.num(o.val) * 100))]
		"cutall": return L("全部指標減 %d%%", "全部指標減 %d%%") % int(round(J.num(o.val) * 100))
	return ""
static func _label(gid: String, key: String) -> String:
	for nd in KG.gate(gid).get("need", []): if str(nd.key) == key: return str(nd.label)
	return key
static func _add_txt(gid: String, add: Dictionary) -> String:
	var a = []
	for k in add: a.append("「%s」+%d" % [_label(gid, str(k)), int(J.num(add[k]))])
	return "、".join(a)
static func _bribe(main, gid: String, tier: String, to: String) -> void:
	var o = KG.bribe(gid, tier, to)
	if not o.get("ok"):
		if main.has_method("show_toast"): main.show_toast(L("唔夠錢打點", "不夠錢打點") if str(o.get("why")) == "poor" else L("而家唔可以打點", "現在不能打點"))
		return
	main.close_sheet()
	var boss = str(o.boss)
	var back = func(): _sheet(main, gid)
	match str(o.res):
		"fail":
			var ad = _add_txt(gid, o.get("add", {}))
			play(main, "kpi_%s_bribe_fail" % boss, L("打點失敗：禮物退回。", "打點失敗：禮物退回。") + ("" if ad == "" else L("KPI 加碼：%s", "KPI 加碼：%s") % ad), back)
		"caught":
			var cg = o.get("caught", {})
			var tx = L("被老闆撞破！", "被老闆撞破！")
			if cg.get("mul_all") != null: tx += L("……反而全部指標減半。", "……反而全部指標減半。")
			else:
				tx += L("禮物充公。", "禮物充公。")
				var ad2 = _add_txt(gid, cg.get("add", {}))
				if ad2 != "": tx += L("KPI 加碼：%s。", "KPI 加碼：%s。") % ad2
				if J.t(cg.get("rebribe")): tx += L("可以再送一次。", "可以再送一次。")
			tx += L("牛頭馬面心虛：下次打點半價。", "牛頭馬面心虛：下次打點半價。")
			play(main, "kpi_%s_caught" % boss, tx, back)
		_:
			var key = "kpi_ma_food" if boss == "chen" and to == "ma" and tier == "snack" else "kpi_%s_bribe_ok" % boss
			var tx2 = L("系統核實：%s。", "系統核實：%s。") % _eff_txt(o)
			if J.t(o.get("photo")):
				play(main, key, tx2, func(): play(main, "kpi_photo", "", back))
			else: play(main, key, tx2, back)
static func _submit(main, gid: String) -> void:
	var o = KG.submit(gid)
	if not o.get("ok"): return
	main.close_sheet()
	var boss = str(KG.gate(gid).boss)
	var chain = []
	chain.append("kpi_%s_pass" % boss)
	if J.t(o.get("egg")): chain.append("kpi_pang_egg")
	if J.t(o.get("banner")):
		var a = []
		for m in o.get("back", {}): a.append("%s ×%d" % [KG.mname(str(m)), int(J.num(o.back[m]))])
		chain.append(["kpi_banner_down", (L("追回：%s", "追回：%s") % "、".join(a)) if a.size() else ""])
	_chain(main, chain, func():
		if main.has_method("show_banner"): main.show_banner(L("考核達標！", "考核達標！"))
		if main.has_method("refresh"): main.refresh())
static func _chain(main, keys: Array, done: Callable) -> void:
	if keys.is_empty():
		if done.is_valid(): done.call()
		return
	var k = keys.pop_front()
	play(main, str(k[0]) if k is Array else str(k), str(k[1]) if k is Array else "", func(): _chain(main, keys, done))

# ---------------- 每格：逾期（Bryan） ----------------
static func eat_news(main) -> void:
	KG.tick()
	while KG.NEWS.size() > 0:
		var n = KG.NEWS.pop_front()
		if str(n.get("kind")) != "bryan": continue
		var tx = L("Bryan 搶功：拎走 %s ×%d，倒數重來", "Bryan 搶功：拿走 %s ×%d，倒數重來") % [KG.mname(str(n.mid)), int(J.num(n.n))]
		if J.t(n.get("first")): play(main, "kpi_bryan", tx)
		elif main != null and main.has_method("show_toast"): main.show_toast(tx)
