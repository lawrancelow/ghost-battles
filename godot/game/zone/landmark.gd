# [landmark] 地標：無名義山、破塔樓（第二期「三地標取代出村」；紙錢陣等老闆談完先做）
#   const LM = preload("res://game/zone/landmark.gd")；全部 static，冇 class_name、冇 autoload（熱更新規矩）
# 資料：zones.json 每張圖 type "landmark" 嘅區（tools/zone_build.py _landmarks）：
#   {id:"lm_hill"/"lm_tower", lm:"hill"/"tower", rect, n, at（圖底邊中心）, stand（玩完返嚟主角企位）, unlock:{條件}}
#   unlock 條件同 zone_data reveal 一樣寫法：quest_done [t, key]／enter（睇完該關開場劇情）＋ hint
#   （唔用 "reveal"：出村門外解霧嘅計數、提示、橫額照舊，唔受地標影響）
# 狀態：S.lm = {"open": {"hill": 1, "1:tower": 1}, "card": {"hill": 1}}（讀一律 .get；舊存檔冇呢欄照用）
#   無名義山跟村拔營：開過一次之後每張圖都開；破塔樓每張圖各自（到埗、睇完開場劇情先開）
# 玩法：撳地標（或者行動目標 go）→ 第一次先播一段短劇情（一個任務一段故事：播完照樣「等」）→ 選地點卡
#   卡入面每個地點：插圖、一句簡介、紅點（Guide.dot）、未開嘅寫明點樣開；撳「去」入舊玩法（World.SPOTS 嘅 go）
#   玩完：舊玩法收尾會叫 World.open → 呢度攔住（唔開舊世界地圖），返村子鏡頭帶去地標、主角企喺地標旁邊
extends RefCounted

const ZD = preload("res://game/zone/zone_data.gd")
const LA = preload("res://game/zone/landmark_art.gd")
const AT = preload("res://game/outpost/act_targets.gd")

# 每個地標嘅地點（id ＝ 舊世界地圖 World.SPOTS 嘅 id；sub ＝ 再分）
const PLACES := {
	"hill": [
		{"id": "street", "n": ["冥街夜市", "冥街夜市"], "d": ["收工後嘅陰間夜市：食宵夜、講價、燒紙紮、睇棟篤笑。", "下班後的陰間夜市：吃宵夜、講價、燒紙紮、看脫口秀。"]},
		{"id": "gyard", "n": ["亂葬崗", "亂葬崗"], "d": ["無名墳一排排，聽清楚邊個講大話，幫佢哋返屋企。", "無名墳一排排，聽清楚誰在說謊，幫他們回家。"]},
	],
	"tower": [
		{"id": "station", "n": ["陽間站崗", "陽間站崗"], "d": ["喺陽間地盤擺鬼站崗，嚇走路過嘅人，收穩定收入。", "在陽間地盤派鬼站崗，嚇走路過的人，收穩定收入。"]},
		{"id": "back", "n": ["回陽間", "回陽間"], "d": ["返上去陽間做嘢：揀返夜班，定係揀一棟樓。", "回到陽間辦事：選上夜班，還是選一棟樓。"],
			"sub": [{"id": "scare", "n": ["夜班嚇人", "夜班嚇人"], "d": ["返夜班，一間間辦公室嚇過去。", "上夜班，一間間辦公室嚇過去。"]},
				{"id": "tower", "n": ["樓裡有鬼", "樓裡有鬼"], "d": ["揀一棟樓，由地下嚇到天台，天光前返嚟。", "選一棟樓，從地下嚇到天台，天亮前回來。"]}]},
	],
}
const INTRO := {
	"hill": ["村邊嘅墳山。山後兩條小路：一條去冥街夜市，一條落亂葬崗。", "村邊的墳山。山後兩條小路：一條去冥街夜市，一條下亂葬崗。"],
	"tower": ["一半喺陰間、一半喺陽間嘅爛塔樓。爬上去，就返到陽間。", "一半在陰間、一半在陽間的破塔樓。爬上去，就回到陽間。"],
}
# 第一次開：短劇情（港式粵語原句＋中文；講者名／少爺等稱呼由 DB.N 換女主版）
const STORY := {
	"hill": {"style": "talk", "bg": "field", "title": ["無名義山", "無名義山"], "lines": [
		["旁白", "村邊多咗座矮山丘。山路兩邊插住一條條爛木牌，冇一塊寫名；山頂一堆亂石，掛住一盞燈。", "村邊多了一座矮山丘。山路兩邊插著一根根爛木牌，沒有一塊寫著名字；山頂一堆亂石，掛著一盞燈。"],
		["小紙", "少爺，義山即係墳山。呢度啲墳冇人記得叫咩名，所以叫「無名」。", "少爺，義山就是墳山。這裡的墳沒人記得叫什麼名字，所以叫「無名」。"],
		["阿福", "山後面有兩條路：一條出去冥街夜市，一條落去亂葬崗。", "山後面有兩條路：一條出去冥街夜市，一條下去亂葬崗。"],
		["系統", "親，收工去夜市都計 KPI。記得打卡。", "親，下班去夜市也算 KPI。記得打卡。"]]},
	"tower": {"style": "talk", "bg": "field", "title": ["破塔樓", "破塔樓"], "lines": [
		["旁白", "村外荒地企住一座爛塔樓：石腳、木身，瓦頂崩咗一半，掛住幾條爛紅布，一條長梯斜斜搭上去。", "村外荒地立著一座破塔樓：石底、木身，瓦頂塌了一半，掛著幾條破紅布，一道長梯斜斜搭上去。"],
		["小紙", "少爺，呢座塔下半截喺陰間，上半截喺陽間。爬上頂，就返到上面。", "少爺，這座塔下半截在陰間，上半截在陽間。爬到頂，就回到上面。"],
		["阿福", "上面……即係我以前返工嗰度？", "上面……就是我以前上班的地方？"],
		["系統", "親，陽間任務一律由塔樓出發：站崗、返夜班，全部有得計。", "親，陽間任務一律從塔樓出發：站崗、上夜班，全都算數。"]]},
}

static func L(yue: String, zhs: String) -> String: return ZD.L(yue, zhs)
static func T(a) -> String: return str(DB.N(ZD.T(a)))

# ---------------- 資料 ----------------
static func zones_of(c := -1) -> Array: return ZD.of_type("landmark", c)
static func zone_of(lm: String, c := -1) -> Dictionary:
	for z in zones_of(c): if str(z.get("lm", "")) == lm: return z
	return {}
static func has(lm: String, c := -1) -> bool: return not zone_of(lm, c).is_empty()
static func at(lm: String, c := -1) -> Vector2: return ZD.v2(zone_of(lm, c).get("at", [0, 0]))
static func stand(lm: String, c := -1) -> Vector2: return ZD.v2(zone_of(lm, c).get("stand", zone_of(lm, c).get("at", [0, 0])))
static func art_rect(lm: String, c := -1) -> Rect2: return LA.rect_of(lm, at(lm, c))
static func hit_rect(lm: String, c := -1) -> Rect2:   # 撳嘅範圍：最少手指大細
	var r = art_rect(lm, c)
	return r.grow_individual(maxf(0.0, (88.0 - r.size.x) / 2.0), 0.0, maxf(0.0, (88.0 - r.size.x) / 2.0), 0.0).grow(8.0)
static func name_of(lm: String) -> String:
	var z = zone_of(lm)
	if z.is_empty(): z = zone_of(lm, 1)
	var n = ZD.T(z.get("n", ["", ""]))
	return n.split("　")[-1] if n != "" else lm

# ---------------- 狀態（S.lm） ----------------
static func st():
	var s = ZD.S()
	if s == null: return null
	if not (s.get("lm") is Dictionary): s["lm"] = {}
	var d = s.lm
	for k in ["open", "card"]: if not (d.get(k) is Dictionary): d[k] = {}
	return d
static func _okey(lm: String, c: int) -> String:
	var u = zone_of(lm, c).get("unlock")
	return "%d:%s" % [c, lm] if u is Dictionary and J.t(u.get("enter")) else lm
# 開咗未（測試／自動化唔閘：同 ZD.gate_on 一齊）
static func unlocked(lm: String, c := -1) -> bool:
	var cc = ZD.ci() if c < 0 else c
	if zone_of(lm, cc).is_empty(): return false
	if not ZD.gate_on: return true
	var d = st()
	return d != null and J.t(d.open.get(_okey(lm, cc)))
static func cond_ok(lm: String, c := -1) -> bool:
	var cc = ZD.ci() if c < 0 else c
	var u = zone_of(lm, cc).get("unlock")
	if not (u is Dictionary): return true
	var s = ZD.S()
	if s == null: return false
	if J.t(u.get("always")): return true
	if u.get("quest_done") is Array:
		var t0 = str(u.quest_done[0]); var k0 = str(u.quest_done[1])
		var i = ZD._qidx(t0, k0)
		if i >= 0 and int(J.num(s.get("qi", 0))) > i: return true
		if t0 == "stage" and s.get("cleared") is Dictionary and J.t(s.cleared.get(k0)): return true
	if J.t(u.get("enter")) and ZD._enter_done(cc): return true
	return false
static func hint(lm: String, c := -1) -> String:
	var cc = ZD.ci() if c < 0 else c
	var u = zone_of(lm, cc).get("unlock")
	if u is Dictionary and u.get("quest_done") is Array:
		var q = ZD._quest(str(u.quest_done[0]), str(u.quest_done[1]))
		if not q.is_empty(): return L("完成主線任務「%s」後開放", "完成主線任務「%s」後開放") % load("res://game/outpost/mv_bridge.gd").quest_text(q)
	if u is Dictionary and u.get("hint") != null: return ZD.T(u.hint)
	return L("跟住主線任務行落去就會開", "跟著主線任務走就會開放")
static var OPENED := {}   # "<ci>:<lm>" → 解鎖嗰刻（霧散動畫）
static var NEWS: Array = []   # 啱啱開咗嘅地標名（出 toast）
static var _pt := 0
# 解鎖檢查（畫面每格叫，十格查一次；force＝即刻查）
static func poll(force := false) -> Array:
	var out = []
	if not ZD.on() or not ZD.gate_on: return out
	_pt += 1
	if not force and _pt % 10 != 0: return out
	var d = st()
	if d == null: return out
	var c = ZD.ci()
	for z in zones_of(c):
		var lm = str(z.get("lm", ""))
		var k = _okey(lm, c)
		if J.t(d.open.get(k)) or not cond_ok(lm, c): continue
		d.open[k] = 1.0; out.append(lm)
		OPENED["%d:%s" % [c, lm]] = Time.get_ticks_msec()
		NEWS.append(lm)
	if out.size(): ZD._save()
	return out
static func open_k(lm: String) -> float:   # 霧散動畫：0＝啱啱開、1＝散晒
	var t0 = OPENED.get("%d:%s" % [ZD.ci(), lm])
	if t0 == null: return 1.0
	return clampf(float(Time.get_ticks_msec() - int(t0)) / 1600.0, 0.0, 1.0)

# ---------------- 地點（舊世界地圖 World.SPOTS） ----------------
static func spot(pid: String):
	var W = J.G.get("World")
	if W == null: return null
	for s in J.iter(J.gp(W, "SPOTS")): if J.str(J.gp(s, "id")) == pid: return s
	return null
static func place_ready(pid: String) -> bool:
	if pid == "back": return place_ready("scare") or place_ready("tower")
	var s = spot(pid)
	return s != null and (s.get("ready") == null or J.t(J.cl(s.ready, null, [])))
static func place_open(pid: String) -> bool:
	if pid == "back": return place_open("scare") or place_open("tower")
	var s = spot(pid)
	return s != null and load("res://native/guide.gd").open_(s)
static func place_lock(pid: String) -> String:
	if pid == "back": pid = "scare"
	if not place_ready(pid): return L("仲喺度起緊，遲啲再嚟", "還在施工，晚點再來")
	var s = spot(pid)
	var lk = str(s.get("lock", "")) if s != null else ""
	if lk.contains("第一章"): return L("打完第一章（餓鬼王）先開", "打完第一章（餓鬼王）才開放")
	return lk if lk != "" else L("未開放", "未開放")
static func place_dot(pid: String) -> bool:
	if pid == "back": return place_dot("scare") or place_dot("tower")
	var G = J.G.get("Guide")
	return G != null and J.t(J.mc(G, "dot", [pid]))
# 地標本身嘅紅點：未開過卡，或者入面有新地點未去過
static func dot(lm: String) -> bool:
	if not unlocked(lm): return false
	var d = st()
	if d != null and not J.t(d.card.get(lm)): return true
	for p in PLACES.get(lm, []): if place_dot(str(p.id)): return true
	return false
# 冥街夜市而家去唔去得到（棟篤笑「今晚登台」提示用）
static func street_ok() -> bool: return has("hill") and unlocked("hill")

# ---------------- 撳 ----------------
static func _main():
	var ml = Engine.get_main_loop()
	return ml.root.get_node_or_null("Main") if ml is SceneTree else null
static func lm_at(p: Vector2) -> String:
	for z in zones_of():
		var lm = str(z.get("lm", ""))
		if lm == "hill":
			if LA.solid(lm, at(lm), p): return lm   # 大山：成座山（圖入面實色位）都撳得
		elif hit_rect(lm).has_point(p): return lm
	return ""
# zone_view.tap 掛鈎：回 true＝處理咗
static func tap(main, p: Vector2) -> bool:
	if not ZD.on(): return false
	var lm = lm_at(p)
	if lm == "": return false
	if not unlocked(lm):
		if main != null and main.has_method("show_toast"): main.show_toast(name_of(lm) + L("：未開放。", "：未開放。") + hint(lm))
		return true
	open(main, lm)
	return true
# 打開地標：第一次先播劇情，播完先出選地點卡
static func open(main, lm: String) -> void:
	if main == null or not unlocked(lm): return
	var ZV = load("res://game/zone/zone_view.gd")
	if ZV._busy(): return
	play_story(lm, func(): open_card(main, lm))
static var STORY_LOG: Array = []   # 測試用：播過嘅地標劇情 id
static func story_id(lm: String) -> String: return "lm_open_" + lm
static func play_story(lm: String, cb: Callable) -> void:
	var MS = load("res://game/outpost/mv_story.gd")
	var id = story_id(lm)
	if not MS.auto_on or MS.is_seen(id) or not STORY.has(lm): cb.call(); return
	STORY_LOG.append(id)
	var me = MS._live.get_ref() if MS._live != null else null
	if me == null: me = MS.new()
	var sc = me._sc.get_ref() if me._sc != null else null
	me.play(sc, {"id": id, "scene": STORY[lm]}, cb)   # mv_story.play：記低播過、播完「等」（一個任務一段故事）

# ---------------- 選地點卡 ----------------
static var CARD := ""   # 而家開緊邊個地標嘅卡（測試用）
static func open_card(main, lm: String) -> void:
	if main == null: return
	var d = st()
	if d != null: d.card[lm] = 1.0
	CARD = lm
	main.open_sheet(name_of(lm), func(): open_card(main, lm))
	if main.has_method("_clear_body"): main._clear_body()   # 即刻拎走舊內容（唔好等 queue_free，免得同名節點改名）
	var body = main.sheet_body
	var intro = UIKit.rich(T(INTRO.get(lm, ["", ""])), 15, UIKit.INKDIM); body.add_child(intro)
	body.add_child(UIKit.hsep())
	for p in PLACES.get(lm, []): body.add_child(_row(main, lm, p))
static func _row(main, lm: String, p: Dictionary) -> Control:
	var pid = str(p.id)
	var box = PanelContainer.new(); box.name = "lm_" + pid
	box.add_theme_stylebox_override("panel", UIKit.sb(Color("#e2cc92"), 6, UIKit.PAPERLINE, 1, Vector4(8, 8, 8, 8)))
	var hb = HBoxContainer.new(); hb.add_theme_constant_override("separation", 10); box.add_child(hb)
	var pic = TextureRect.new(); pic.custom_minimum_size = Vector2(112, 70); pic.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	pic.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED; pic.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	pic.texture = LA.illus(pid); pic.clip_contents = true
	var op = place_open(pid)
	if not op: pic.modulate = Color(0.55, 0.52, 0.5)
	hb.add_child(pic)
	var vb = VBoxContainer.new(); vb.add_theme_constant_override("separation", 4); vb.size_flags_horizontal = Control.SIZE_EXPAND_FILL; hb.add_child(vb)
	var title = HBoxContainer.new(); title.add_theme_constant_override("separation", 6); vb.add_child(title)
	title.add_child(UIKit.label(T(p.n), 18, UIKit.INKTXT, "serif", 900))
	if op and place_dot(pid):
		var dt = Panel.new(); dt.name = "dot"; dt.custom_minimum_size = Vector2(11, 11); dt.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		dt.add_theme_stylebox_override("panel", UIKit.sb(Color("#e8303a"), 6, Color("#fff3e0"), 1)); title.add_child(dt)
		var nw = UIKit.label(L("新", "新"), 13, UIKit.CINNABAR, "sans", 900); title.add_child(nw)
	var ds = UIKit.rich(T(p.d), 15, UIKit.INKTXT); vb.add_child(ds)
	if p.get("sub") is Array:   # 回陽間：再分夜班嚇人／樓裡有鬼
		for sp in p.sub:
			var sid = str(sp.id)
			var row = HBoxContainer.new(); row.add_theme_constant_override("separation", 6); vb.add_child(row)
			var t2 = UIKit.rich("[b]%s[/b]　%s" % [T(sp.n), T(sp.d)], 14, UIKit.INKTXT); t2.size_flags_horizontal = Control.SIZE_EXPAND_FILL; row.add_child(t2)
			row.add_child(_go_btn(main, lm, sid))
	else:
		var row2 = HBoxContainer.new(); row2.alignment = BoxContainer.ALIGNMENT_END; vb.add_child(row2)
		row2.add_child(_go_btn(main, lm, pid))
	return box
static func _go_btn(main, lm: String, pid: String) -> Control:
	var op = place_open(pid)
	if not op:
		var lk = UIKit.rich("[color=#9c2219]%s[/color]" % place_lock(pid), 14, UIKit.INKTXT); lk.custom_minimum_size = Vector2(120, 0); lk.name = "lock_" + pid
		return lk
	var dot2 = place_dot(pid)
	var b = UIKit.btn(L("去", "前往") + ("・" + L("新", "新") if dot2 else ""), "gold", true); b.name = "go_" + pid
	b.custom_minimum_size = Vector2(76, 44); b.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	b.pressed.connect(func(): go(main, lm, pid))
	return b

# ---------------- 入舊玩法；玩完返地標旁邊 ----------------
static var ret := {}   # {lm, ci, pid, t, hid}
static var GO_LOG: Array = []   # 測試用：[lm, pid]
static var go_fn: Callable = Callable()   # 測試用：代替真正開舊玩法
static func go(main, lm: String, pid: String) -> bool:
	if not place_open(pid):
		if main != null and main.has_method("show_toast"): main.show_toast(place_lock(pid))
		return false
	var s = spot(pid)
	if s == null: return false
	ret = {"lm": lm, "ci": ZD.ci(), "pid": pid, "t": Time.get_ticks_msec(), "hid": false}
	GO_LOG.append([lm, pid])
	var G = J.G.get("Guide")
	if G != null: J.mc(G, "visit", [pid])
	if main != null: main.close_sheet()
	if go_fn.is_valid(): go_fn.call(pid); return true
	J.cl(s.go, null, [])
	return true
# native/world.gd open_() 掛鈎：由地標入嘅玩法收尾叫 World.open → 唔開舊世界地圖（回 true＝攔咗）
static func intercept_world() -> bool:
	if ret.is_empty() or not ZD.on(): return false
	ret["back"] = true
	var UI = J.G.get("UI")
	if UI is Dictionary and J.t(UI.get("refresh")): J.mc(UI, "refresh", [])
	return true
# main._process 掛鈎：玩法收咗（村子再見得到）→ 返地標旁邊
static func tick(main) -> void:
	if not NEWS.is_empty() and main != null and main.has_method("show_toast"):
		var ns = []
		for lm in NEWS: ns.append(name_of(lm))
		NEWS.clear()
		main.show_toast(L("發現新地方！", "發現新地方！") + "、".join(ns))
	if ret.is_empty() or main == null: return
	var nv = main.get("village")
	var hidden = nv == null or not nv.is_visible_in_tree() or main.get_node_or_null("WmRun") != null
	if hidden: ret["hid"] = true; return
	if not J.t(ret.get("hid")) and not J.t(ret.get("back")):
		if Time.get_ticks_msec() - int(ret.t) > 8000: ret = {}   # 開唔到（冇蓋住村子）：放棄
		return
	var lm = str(ret.lm); var c = int(ret.ci)
	ret = {}
	if c == ZD.ci(): arrive(main, lm)
# 返到地標旁邊：鏡頭帶去地標、主角企喺 stand
static func arrive(main, lm: String) -> void:
	if main == null or not has(lm): return
	if main.has_method("_nav_on"): main._nav_on("village")
	var V = J.G.get("Village")
	if V is Dictionary and V.get("hero") is Dictionary:
		var H = V.hero; var p = stand(lm)
		H["x"] = p.x; H["y"] = p.y; H["tx"] = p.x; H["ty"] = p.y; H["act"] = null; H["target"] = null; H["zq"] = []; H.erase("zf")
	var nv = main.get("village")
	if nv != null and nv.has_method("zone_cam"):
		var cam = nv.zone_cam()
		if cam != null: cam.center_on(at(lm) + Vector2(0, -minf(art_rect(lm).size.y * 0.35, 90.0)))

# ---------------- 行動目標（act_targets，kind "landmark"；go 開選地點卡） ----------------
static func targets(_game = null) -> Array:
	var o = []
	if not ZD.on(): return o
	for z in zones_of():
		var lm = str(z.get("lm", ""))
		if not unlocked(lm): continue
		o.append({"id": str(z.id), "kind": "landmark", "name": name_of(lm), "pos": stand(lm), "my_pow": 0, "foe_pow": 0, "icon": "",
			"go": func(): open(_main(), lm)})
	return o
static func _static_init() -> void: register()
static func register() -> void:
	var cb: Callable = targets
	for c in AT.providers:
		if c is Callable and c == cb: return
	AT.providers.append(cb)

# ---------------- 畫：地圖上（nv_village 靜態層） ----------------
#   大山：泥地（最底，y＝圖頂）＋山圖（y＝山腳橢圓中間）＋外圍道具（每件自己 y）；全部靜態（sig 唔變就唔重畫）
static func statics(nv) -> void:
	if not ZD.on(): return
	var ci = ZD.ci()
	for z in zones_of():
		var lm = str(z.get("lm", "")); var a = at(lm)
		nv._static("lm_" + lm, a.y + LA.sort_dy(lm), [ci, lm], false, func(ctx): LA.draw(ctx, lm, a.x, a.y))
		if lm != "hill": continue
		nv._static("lm_hill_pt", art_rect(lm).position.y, [ci, "pt"], false, func(ctx): LA.draw_patch(ctx, a.x, a.y))
		var ring = z.get("ring", [])
		for i in ring.size():
			var e = ring[i]
			nv._static("lmr_%d" % i, float(e[2]), [ci, i], false, func(ctx): LA.draw_ring(ctx, e))
# 上層（zone_view.draw_over 尾）：未開＝黑霧＋名牌＋鎖＋點樣開；開咗＝名牌（＋紅點）
static func draw_over(c: CanvasItem, nv, ctx: Ctx, vr: Rect2, t: float) -> void:
	if not ZD.on(): return
	poll()
	var ZV = load("res://game/zone/zone_view.gd")
	var mbf = ZV._mb().fighting()
	for z in zones_of():
		var lm = str(z.get("lm", ""))
		var zr = ZD.rect(z.rect); var ar = art_rect(lm)
		if not zr.grow(160).intersects(vr): continue
		var op = unlocked(lm)
		var k = open_k(lm)
		if not op: ZV._fog_body(c, zr, t, vr, 1.0, 0.0); ZV.fog_log.append(["lm_fog", lm])
		elif k < 1.0: ZV._fog_body(c, zr, t, vr, 1.0 - ZV._ease(k), k * 40.0)
		var npx = ZV._name_px(nv)
		var py = ar.position.y - npx * 0.6
		var pr = ZV._plate(ctx, ZV._name(nv, z), ar.get_center().x, py, npx, ZV._rgba(str(z.get("col", "#4a4458")), 0.92))
		if not op:
			var lk = maxf(22.0, npx * 1.1)
			ZV._lock(ctx, ar.get_center().x, zr.get_center().y - lk * 0.2, lk)
			var da = ZV._det(nv)
			if da > 0.0 and not mbf:
				ctx.globalAlpha = da
				ZV._hint_box(ctx, hint(lm), ar.get_center().x, zr.get_center().y + lk * 0.75, maxi(14, int(npx * 0.8)))
				ctx.globalAlpha = 1.0
		elif dot(lm) and not mbf:
			var r = 7.0 + sin(t * 5.0) * 1.2
			ctx.fillStyle = "#e8303a"; ctx.strokeStyle = "#fff3e0"; ctx.lineWidth = 2
			ctx.beginPath(); ctx.arc(pr.end.x - 2, pr.position.y + 2, r, 0, TAU); ctx.fill(); ctx.stroke()
