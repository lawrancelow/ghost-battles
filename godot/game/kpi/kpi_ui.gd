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
	var oi := -1; var imap := {}   # [kpi-cg] 原行號 → 篩走男女專句之後嘅行號（插圖要跟返原行）
	for l in sd.get("lines", []):
		oi += 1
		if not (l is Array) or l.size() < 2: continue
		if l.size() >= 4:
			var c = str(l[3])
			if c == "m" and f: continue
			if c == "f" and not f: continue
		imap[oi] = ls.size()
		var tx = str(l[1]) if yue or l.size() < 3 else str(l[2])
		tx = tx.replace("{少爺}", "大小姐" if f else "少爺")
		if tx.contains("{rebuilt}"): tx = tx.replace("{rebuilt}", cn_num(int(KG.metric("rebuilt"))))
		ls.append([str(l[0]), tx])
	var out = {"style": "talk", "bg": "village", "title": str(sd.get("title", "")), "lines": ls}
	var cg = cg_of(key, sd, imap, ls.size())
	if not cg.is_empty(): out["cg"] = cg
	return out
# [kpi-cg] KPI 劇情插圖：同主線劇情用同一套插圖卡（寬框＋分層／後備動態＋牌匾疊字），老闆已選用嘅圖先接。
#   CG_AT：場景 → [由第幾行（原行號）開始出圖, 插圖鍵, 女主版鍵]；*_bribe_ok／kpi_ma_food＝收賄圖（男 C2 公案版、女主專屬版）；*_caught＝被抓包。
#   陳不辦、龐總、甄好賣冇專屬登場圖＝唔出；*_bribe_fail（送錯人被推返）冇啱嘅圖＝唔出。kpi.json 場景自己寫 "cg" 就以資料為準。
const CG_AT := {
	"kpi_he_open": [1, "cg_he_wake", ""],
	"kpi_qian_open": [0, "cg_qian_bite", ""],
	"kpi_dato_open": [1, "cg_dato_plaque", ""],
	"kpi_nuo_open": [0, "cg_nuopo_taste", ""],
	"kpi_ma_food": [0, "cg_c2_bribe", "cg_f_bribe"],
}
const CG_BRIBE := [0, "cg_c2_bribe", "cg_f_bribe"]
const CG_CAUGHT := [0, "cg_caught", ""]
static func cg_rule(key: String) -> Array:
	if CG_AT.has(key): return CG_AT[key]
	if key == "kpi_pang_bribe": return []
	if key.ends_with("_bribe_ok"): return CG_BRIBE
	if key.ends_with("_caught") or key == "kpi_caught": return CG_CAUGHT
	return []
static func cg_has(k: String) -> bool:
	if k == "": return false
	if load("res://ui/story_cg.gd").review_hold(k): return false   # 老闆退回重做緊嘅圖（data/cg_review.json 的 hold）唔出
	var CGM = load("res://ui/cg_motion.gd")
	return Spr.ok(k) or (CGM != null and CGM.known(k))
static func cg_of(key: String, sd: Dictionary, imap: Dictionary, n: int) -> Dictionary:
	if n <= 0: return {}
	var own = sd.get("cg")
	if own is Dictionary:   # 資料自帶：行號按篩句後重新對位
		var o2 = {}
		for k in own:
			var i0 = int(str(k))
			if imap.has(i0): o2[str(imap[i0])] = own[k]
		return o2
	var r = cg_rule(key)
	if r.is_empty() or not cg_has(str(r[1])): return {}
	var at = int(r[0])
	while at > 0 and not imap.has(at): at -= 1
	var li = int(imap.get(at, 0))
	var spec = {"k": str(r[1])}
	if str(r[2]) != "" and cg_has(str(r[2])): spec["kf"] = str(r[2])
	return {str(li): spec}
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
# 考核卡（v2：少字、多圖）：大倒數＋指標進度條＋牛頭／馬面頭像＋三件禮物卡；送錯唔預先講，送咗先吐槽
static var _to := {}   # gid → "niu"／"ma"（揀咗送俾邊個）
const KS = preload("res://ui/kit_skin.gd")
const GIFT_ICON := {"snack": "mvi_nuomici", "watch": "mvi_watch", "car": "mvi_car"}
const WHO := {"niu": ["ace_niutou_s1", "牛頭"], "ma": ["ace_mamian_s1", "馬面"]}
static func _tex(k: String) -> Texture2D: return Spr.get_tex(k) if Spr.ok(k) else null
static func _img(k: String, sz: float) -> TextureRect:
	var r = TextureRect.new(); r.texture = _tex(k); r.custom_minimum_size = Vector2(sz, sz)
	r.expand_mode = TextureRect.EXPAND_IGNORE_SIZE; r.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	r.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return r
static func metric_icon(key: String, kind: String) -> Texture2D:   # 指標圖示：舊資源用美術資源圖示；材料用 mvi_*；其他用建築／鬼
	var RI = load("res://ui/res_icon.gd")
	if key == "coins": return RI.tex("coins")
	if kind == "mat":
		var Mm = load("res://game/outpost/mat.gd")
		var rk = Mm.res_key(key)
		if rk != "" and RI.tex(rk) != null: return RI.tex(rk)
		return _tex(str(Mm.icon(key)))
	match key:
		"rebuilt": return _tex("house") if Spr.ok("house") else RI.tex("planks")
		"home": return _tex("home") if Spr.ok("home") else RI.tex("planks")
		"named_hired", "named_working": return RI.tex("troops")
		"self_sufficient": return RI.tex("rice")
	return _tex(key) if kind == "bld" else null
static func _bar(frac: float, met: bool) -> Control:
	var pb = ProgressBar.new(); pb.min_value = 0.0; pb.max_value = 1.0; pb.value = clampf(frac, 0.0, 1.0); pb.show_percentage = false
	pb.custom_minimum_size = Vector2(0, 14); pb.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var tr = KS.box("bar_track", Vector4(0, 0, 0, 0)); var fl = KS.box("bar_fill", Vector4(0, 0, 0, 0))
	if tr != null and not KS.OFF: pb.add_theme_stylebox_override("background", tr)
	else: pb.add_theme_stylebox_override("background", UIKit.sb(Color("#3a2c26"), 6))
	if met or fl == null or KS.OFF: pb.add_theme_stylebox_override("fill", UIKit.sb(Color("#3d7a3a") if met else Color("#a8322a"), 6))
	else: pb.add_theme_stylebox_override("fill", fl)
	return pb
static func _sheet(main, gid: String) -> void:
	var gd = KG.gate(gid); var g = KG.gs(gid)
	main.open_sheet(L("%s・KPI 考核", "%s・KPI 考核") % str(gd.boss_n), func(): _sheet(main, gid))
	var body = main.sheet_body
	# ① 大倒數
	var top = HBoxContainer.new(); top.add_theme_constant_override("separation", 10)
	var who = boss_portrait(str(gd.boss), 60); top.add_child(who)
	var tv = VBoxContainer.new(); tv.add_theme_constant_override("separation", 0); tv.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	tv.add_child(UIKit.label(str(gd.get("title", "")), 13, UIKit.INKDIM))
	var cd = UIKit.label(_fmt_t(J.num(g.left)), 34, UIKit.CINNABAR2, "sans", 900); tv.add_child(cd)
	top.add_child(tv); body.add_child(top)
	body.add_child(UIKit.rich("[color=#8a7a6a]%s[/color]" % L("逾期：Bryan 搶功拎走倉庫一成", "逾期：Bryan 搶功拿走倉庫一成"), 12))
	if g.stolen.size() > 0: body.add_child(UIKit.rich("[color=#a8322a]%s[/color]" % (L("已被搶：%s（達標追回一半）", "已被搶：%s（達標追回一半）") % KG.stolen_txt(gid)), 12))
	if J.num(g.get("plus", 0.0)) > 0.0: body.add_child(UIKit.rich("[color=#a8322a]%s[/color]" % L("上一區被拍照：KPI +10%", "上一區被拍照：KPI +10%"), 12))
	# ② 指標：圖示＋名＋進度條＋數字
	for p in KG.progress(gid):
		var row = HBoxContainer.new(); row.add_theme_constant_override("separation", 8)
		var ic = TextureRect.new(); ic.texture = metric_icon(str(p.key), _kind(gid, str(p.key))); ic.custom_minimum_size = Vector2(30, 30)
		ic.expand_mode = TextureRect.EXPAND_IGNORE_SIZE; ic.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED; row.add_child(ic)
		var col = VBoxContainer.new(); col.add_theme_constant_override("separation", 2); col.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		var nl = HBoxContainer.new()
		var lb = UIKit.label(str(p.label), 15, UIKit.INKTXT, "sans", 700); lb.size_flags_horizontal = Control.SIZE_EXPAND_FILL; nl.add_child(lb)
		var nt = L("免考", "免考") if p.skip else "%d / %d" % [int(p.cur), int(p.need)]
		nl.add_child(UIKit.label(nt, 15, Color("#3d7a3a") if p.met else UIKit.CINNABAR2, "sans", 900))
		col.add_child(nl)
		col.add_child(_bar(1.0 if p.skip else float(p.cur) / maxf(1.0, float(p.need)), p.met))
		row.add_child(col); body.add_child(row)
	var b1 = UIKit.btn(L("交考核", "交考核"), "gold")
	b1.disabled = not KG.all_met(gid)
	b1.pressed.connect(func(): _submit(main, gid))
	body.add_child(b1)
	# ③ 打點
	if J.t(gd.get("nobribe")):
		var hp = HBoxContainer.new(); hp.add_theme_constant_override("separation", 10)
		hp.add_child(boss_portrait("pang", 46))
		var bp = UIKit.btn(L("送一籠包子", "送一籠包子"), "")
		bp.icon = metric_icon("m_bao", "mat"); bp.expand_icon = false
		bp.disabled = M_amt("m_bao") < 10.0
		bp.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		bp.pressed.connect(func():
			if KG.gift_pang(gid).get("ok"):
				main.close_sheet(); play(main, "kpi_pang_bribe", L("（考核指標冇變）", "（考核指標沒有變化）"), func(): _sheet(main, gid)))
		hp.add_child(bp); body.add_child(hp)
		return
	var why = KG.can_bribe(gid)
	body.add_child(UIKit.hsep())
	if why == "used":
		body.add_child(UIKit.rich("[color=#8a7a6a]%s[/color]" % L("呢區已經打點過", "這區已經打點過"), 13)); return
	var tip = L("請飲茶：先揀人，再揀禮物", "請喝茶：先選人，再選禮物")
	if J.t(g.get("rebribe")): tip = L("老闆話再送一次就算", "老闆說再送一次就算")
	if J.num(KG.st().get("disc", 0.0)) > 0.0: tip += L("　牛頭馬面心虛：半價", "　牛頭馬面心虛：半價")
	body.add_child(UIKit.label(tip, 14, UIKit.INKTXT, "sans", 700))
	var sel = str(_to.get(gid, ""))
	var hw = HBoxContainer.new(); hw.add_theme_constant_override("separation", 12); hw.alignment = BoxContainer.ALIGNMENT_CENTER
	for w in ["niu", "ma"]:
		var bw = Button.new(); bw.toggle_mode = true; bw.button_pressed = sel == w; bw.focus_mode = Control.FOCUS_NONE
		bw.custom_minimum_size = Vector2(96, 112); bw.text = ""
		var on = sel == w
		var sb = KS.box("avatar_slot") if not KS.OFF else null
		if sb == null: sb = UIKit.sb(Color("#3a2c26"), 8)
		for st0 in ["normal", "hover", "pressed", "hover_pressed", "focus"]: bw.add_theme_stylebox_override(st0, sb)
		bw.modulate = Color(1, 1, 1) if on or sel == "" else Color(0.78, 0.76, 0.76)
		var vb = VBoxContainer.new(); vb.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); vb.mouse_filter = Control.MOUSE_FILTER_IGNORE
		vb.add_theme_constant_override("separation", 0)
		var im = _img(WHO[w][0], 84); im.size_flags_vertical = Control.SIZE_EXPAND_FILL; vb.add_child(im)
		var nm = UIKit.label(WHO[w][1], 14, Color("#fff2c8") if on else Color("#f0e2c8"), "sans", 900); nm.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; vb.add_child(nm)
		bw.add_child(vb)
		if on:
			var ring = Panel.new(); ring.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); ring.mouse_filter = Control.MOUSE_FILTER_IGNORE
			var rs = StyleBoxFlat.new(); rs.bg_color = Color(0, 0, 0, 0); rs.border_color = Color("#e8b04a"); rs.set_border_width_all(3); rs.set_corner_radius_all(8)
			ring.add_theme_stylebox_override("panel", rs); bw.add_child(ring)
		var w0 = w
		bw.pressed.connect(func(): _to[gid] = w0; _sheet(main, gid))
		hw.add_child(bw)
	body.add_child(hw)
	var hg = HBoxContainer.new(); hg.add_theme_constant_override("separation", 6)
	for tier in ["snack", "watch", "car"]:
		hg.add_child(_gift_card(main, gid, tier, sel))
	body.add_child(hg)
static func _kind(gid: String, key: String) -> String:
	for nd in KG.gate(gid).get("need", []): if str(nd.key) == key: return str(nd.kind)
	return "fn"
# 禮物卡：圖＋名＋效果（短字）＋風險小圖示＋價錢；未揀人＝灰
static func _gift_card(main, gid: String, tier: String, sel: String) -> Control:
	var bd = KG.bribe_def(tier); var cost = KG.bribe_cost(tier)
	var b = Button.new(); b.focus_mode = Control.FOCUS_NONE; b.text = ""
	b.size_flags_horizontal = Control.SIZE_EXPAND_FILL; b.custom_minimum_size = Vector2(0, 150)
	var sb = KS.box("card") if not KS.OFF else null
	if sb == null: sb = UIKit.sb(Color("#efe2c8"), 8, Color("#b89a52"), 1)
	for st0 in ["normal", "hover", "pressed", "disabled", "focus"]: b.add_theme_stylebox_override(st0, sb)
	b.disabled = sel == "" or not KG.can_pay(cost)
	b.modulate = Color(1, 1, 1) if not b.disabled else Color(0.7, 0.68, 0.66)
	var vb = VBoxContainer.new(); vb.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); vb.mouse_filter = Control.MOUSE_FILTER_IGNORE
	vb.add_theme_constant_override("separation", 1); vb.offset_top = 6; vb.offset_bottom = -6
	var im = _img(GIFT_ICON[tier], 52); im.size_flags_horizontal = Control.SIZE_SHRINK_CENTER; vb.add_child(im)
	var nm = UIKit.label(str(bd.get("n", "")).replace("紙紮", ""), 14, UIKit.INKTXT, "sans", 900); nm.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; vb.add_child(nm)
	var eff = {"snack": L("一項 -20%", "一項 -20%"), "watch": L("一項免考", "一項免考"), "car": L("全部 -40%", "全部 -40%")}[tier]
	var el = UIKit.label(eff, 14, Color("#3d7a3a"), "sans", 900); el.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; vb.add_child(el)
	var risk = str(bd.get("risk", "none"))
	var rr = HBoxContainer.new(); rr.alignment = BoxContainer.ALIGNMENT_CENTER; rr.add_theme_constant_override("separation", 2); rr.mouse_filter = Control.MOUSE_FILTER_IGNORE
	if risk != "none":
		rr.add_child(_img("kpi_risk_photo" if risk == "photo" else "kpi_risk_caught", 18))
		rr.add_child(UIKit.label("%d%%" % int(round(J.num(bd.get("p", 0)) * 100)), 12, UIKit.CINNABAR2, "sans", 900))
	else: rr.add_child(UIKit.label(L("冇風險", "無風險"), 12, UIKit.INKDIM, "sans", 700))
	vb.add_child(rr)
	var cr = HBoxContainer.new(); cr.alignment = BoxContainer.ALIGNMENT_CENTER; cr.add_theme_constant_override("separation", 2); cr.mouse_filter = Control.MOUSE_FILTER_IGNORE
	for k in cost:
		var t = metric_icon(str(k), "res" if str(k) == "coins" else "mat")
		var ic = TextureRect.new(); ic.texture = t; ic.custom_minimum_size = Vector2(15, 15); ic.expand_mode = TextureRect.EXPAND_IGNORE_SIZE; ic.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED; ic.mouse_filter = Control.MOUSE_FILTER_IGNORE
		cr.add_child(ic); cr.add_child(UIKit.label(str(int(J.num(cost[k]))), 12, UIKit.INKTXT, "sans", 700))
	vb.add_child(cr)
	b.add_child(vb)
	b.pressed.connect(func(): _bribe(main, gid, tier, sel))
	return b
# 冥界老闆頭像：美術「探出圈」版（kpi_boss_<id>：畫布＝圓直徑 3 倍、圓心喺正中；帽連展腳全長／頭頂越出圈，最闊離圓心 2.2R、最高 1.8R）；冇就圓牌＋姓（佔位）
# sz＝圓圈直徑；返回嘅格仔預留展腳同頭頂出圈位（唔裁切）
const BOSS_CH := {"chen": "陳", "he": "何", "qian": "錢", "dato": "冥", "nuo": "糯", "pang": "龐"}
static func boss_key(boss: String) -> String:
	if Spr.ok("kpi_boss_" + boss): return "kpi_boss_" + boss
	return ""
static func boss_portrait(boss: String, sz: float) -> Control:
	var k = boss_key(boss)
	var box = Control.new(); box.mouse_filter = Control.MOUSE_FILTER_IGNORE; box.clip_contents = false
	box.custom_minimum_size = Vector2(sz * 2.2, sz * 1.5)   # 闊＝±1.1 直徑（展腳），高＝頭頂 0.9＋圓下半 0.5＋留白
	if k != "":
		var tr = TextureRect.new(); tr.texture = Spr.get_tex(k + ("_s" if sz <= 40 and Spr.ok(k + "_s") else ""))
		tr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE; tr.stretch_mode = TextureRect.STRETCH_SCALE; tr.mouse_filter = Control.MOUSE_FILTER_IGNORE
		tr.size = Vector2(sz * 3.0, sz * 3.0)
		tr.position = Vector2(sz * 1.1 - sz * 1.5, sz * 0.92 - sz * 1.5)   # 圓心 → (格中, 頭頂下 0.92 直徑)
		box.add_child(tr)
		return box
	var p = Panel.new(); p.size = Vector2(sz, sz); p.position = Vector2(sz * 0.6, sz * 0.42); p.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var s = StyleBoxFlat.new(); s.bg_color = Color("#3a2440"); s.border_color = Color("#e8b04a"); s.set_border_width_all(2); s.set_corner_radius_all(int(sz / 2))
	p.add_theme_stylebox_override("panel", s)
	var l = UIKit.label(str(BOSS_CH.get(boss, "?")), int(sz * 0.5), Color("#ffe9a8"), "serif", 900)
	l.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; l.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	p.add_child(l); box.add_child(p)
	return box
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
			if J.t(o.get("half")): tx2 = L("牛頭：「我淨係收名牌㗎……不過都唔好浪費。」（送錯：效果減半）", "牛頭：「我只收名牌的……不過也別浪費。」（送錯：效果減半）") + tx2
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
