# 原生改寫自 world.js（陰間地圖）——畫面由 ui/world_map/wm_run.gd（WmRun）原生畫，呢度只係去處資料同開／收
# 唔再砌 #world 嘅 HTML（WmRun 會收埋 DOM）；#world.on 狀態照設（GP.goVillage、任務掣等都靠佢判斷）
extends RefCounted

static func _g(n: String): return J.G.get(n)
static func _S(): return J.G.get("S")
static func _seen(k: String) -> bool:
	var S = _S()
	return S is Dictionary and S.get("seen") is Dictionary and J.t(S.seen.get(k))
static func _win(k: String) -> bool:
	var w = _g("window")
	return w != null and J.t(J.gp(w, k))
static func _has(n: String) -> bool: return _g(n) != null

static func _el(sel: String):
	var f = _g("$")
	return J.cl(f, null, [sel]) if f != null else null

static func spots() -> Array:
	return [
		{"id": "battle", "x": 0.2, "y": 0.68, "lx": 0.25, "ly": 0.745, "name": "夜班巡陰", "sub": "帶部門巡陰間",
			"go": func(_t, _a): return J.mc(_g("Patrol"), "openPrep", []) if _has("Patrol") else J.mc(_g("UI"), "open", ["battle"])},
		{"id": "yard", "x": 0.76, "y": 0.7, "lx": 0.79, "ly": 0.745, "name": "陰陽交界", "sub": "生死之間",
			"go": func(_t, _a): return LbRun.start()},
		{"id": "street", "x": 0.22, "y": 0.53, "lx": 0.25, "ly": 0.565, "name": "冥街夜市", "sub": "下班後的陰間",
			"go": func(_t, _a): return J.mc(_g("GhostStreet"), "open", []),
			"ready": func(_t, _a): return _has("GhostStreet")},
		{"id": "station", "x": 0.8, "y": 0.52, "lx": 0.735, "ly": 0.555, "name": "陽間站崗", "sub": "派鬼嚇路人",
			"go": func(_t, _a): return J.mc(_g("Street"), "open", []),
			"ready": func(_t, _a): return _has("Street"),
			"need": func(_t, _a): return _seen("ch1_end") or _win("STN_TEST"), "lock": "打完第一章才開放"},
		{"id": "scare", "x": 0.5, "y": 0.4, "lx": 0.5, "ly": 0.47, "name": "回陽間", "sub": "夜班嚇人",
			"go": func(_t, _a): return J.mc(_g("Scare"), "open", ["office"]),
			"need": func(_t, _a): return _seen("ch1_end"), "lock": "打完第一章才開放"},
		{"id": "tower", "x": 0.22, "y": 0.24, "lx": 0.23, "ly": 0.325, "name": "樓裡有鬼", "sub": "揀一棟樓嚇到天光",
			"go": func(_t, _a): return J.mc(_g("Tower"), "open", []),
			"ready": func(_t, _a): return _has("Tower"),
			"need": func(_t, _a): return _seen("ch1_end") or _win("STN_TEST"), "lock": "打完第一章才開放"},
	]

static func open_() -> void:
	var doc = _g("document")
	for e in J.iter(J.S_document_("querySelectorAll", ["#pol-tip"])): J.mc(e, "remove", [])
	var el = _el("#world")
	if el == null:
		el = J.S_document_("createElement", ["section"]); J.sp(el, "id", "world")
		J.mc(J.gp(doc, "body"), "appendChild", [el])
	J.sp(el, "innerHTML", "")
	J.mc(J.gp(el, "classList"), "add", ["on"])
	var Snd_ = _g("Sound")
	if Snd_ != null and J.t(J.gp(Snd_, "play")): J.mc(Snd_, "play", ["click"])
	var w = _g("window")
	var Pol = J.gp(w, "Policy") if w != null else null
	if J.t(Pol): J.mc(Pol, "maybe", [])
	var nw = _g("__nat_world")
	if nw != null: J.cl(nw, null, [true])

static func close_() -> void:
	var nw = _g("__nat_world")
	if nw != null: J.cl(nw, null, [false])
	var el = _el("#world")
	if el != null:
		J.mc(J.gp(el, "classList"), "remove", ["on"]); J.sp(el, "innerHTML", "")
	var UI = _g("UI")
	if UI is Dictionary and J.t(UI.get("refresh")): J.mc(UI, "refresh", [])

func run(_env) -> void:
	var W = {
		"YARD_READY": true,
		"SPOTS": spots(),
		"RESERVED": 3.0,
		"ICON": {"battle": "巡", "yard": "界", "street": "市", "scare": "嚇", "station": "崗"},
		"DESC": {"battle": "帶住部門巡陰間：遊魂可以送去投胎，亦可以遞合約收編。主線關卡嘅主管同總監都喺度。", "yard": "條村停咗喺發大水嗰晚。救返卡住嘅人，唔好俾佢哋俾拖走。", "street": "收工後嘅陰間夜市，食嘢、行街、見老友。", "station": "喺陽間地盤擺鬼站崗，嚇走路過嘅人。", "scare": "返去陽間返夜班，一間間辦公室嚇過去。", "tower": "揀一棟樓，由地下嚇到天台，天光前返陰間。"},
		"RES_SPOTS": [{"x": 0.78, "y": 0.27, "lx": 0.80, "ly": 0.325}, {"x": 0.50, "y": 0.06, "lx": 0.50, "ly": 0.135}, {"x": 0.15, "y": 0.07, "lx": 0.15, "ly": 0.135}],
		"open": func(_t, _a): open_(); return null,
		"close": func(_t, _a): close_(); return null,
	}
	J.G["World"] = W
