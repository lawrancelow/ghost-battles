# 轉譯版 JS 遊戲同 Godot 之間嘅橋：載入前放原生替身，載入後接 UI
class_name JSBridge
extends RefCounted

class SprProxy:
	extends RefCounted
	var extra = {}
	func _get(p: StringName):
		var k = String(p)
		if extra.has(k): return extra[k]
		return Spr.get_tex(k)
	func _set(p: StringName, v) -> bool: extra[String(p)] = v; return true

class SrcProxy:
	extends RefCounted
	var pre = ""
	func _init(p := "") -> void: pre = p
	func _get(p: StringName):
		var k = pre + String(p)
		return Spr._man.get(k)

static func f(obj: Object, m: String) -> Callable: return Callable(obj, m)

static func install_natives(host: Node) -> void:
	var G = J.G
	G["SPR"] = SprProxy.new()
	G["SPR_SRC"] = SrcProxy.new("")
	G["BG_SRC"] = SrcProxy.new("bg_")
	G["SPR_READY"] = JSPromise.new(null)
	G["sprOk"] = func(_t, a): return a.size() > 0 and (Spr.ok(J.str(a[0])) or (G["SPR"] as SprProxy).extra.has(J.str(a[0])))
	G["__nat_patrolMenu"] = func(_t, a): return PatrolMenu.hook(a)
	G["__nat_world"] = func(_t, a): return WmRun.hook(J.t(a[0]))
	G["__nat_menu"] = func(_t, a): return Menus.hook(a)
	G["__nat_menuClose"] = func(_t, a): Menus.close_hook(); return null
	G["__nat_patrol"] = func(_t, a): return PtRun.start_run(int(J.num(a[0])), int(J.num(a[1])))
	G["__nat_scare"] = func(_t, a): return ScRun.hook(a[0])
	G["__nat_tower"] = func(_t, a): return TwRun.hook(J.t(a[0]))
	G["__nat_twUnits1"] = func(_t, a): return TwDraw.units1(a[0], a[1], a[2], a[3])
	G["__nat_twLamps"] = func(_t, a): return TwDraw.lamps(a[0], a[1], a[2], int(J.num(a[3])), J.num(a[4]), J.num(a[5]), J.num(a[6]))
	G["__nat_twMask"] = func(_t, a): return TwDraw.mask(a[0], a[1], a[2], a[3], a[4])
	G["__nat_twMini"] = func(_t, a): return TwDraw.mini(a[0], a[1], a[2], J.num(a[3]), J.num(a[4]), J.num(a[5]), J.num(a[6]), J.num(a[7]), J.num(a[8]), J.num(a[9]), J.num(a[10]), J.num(a[11]), J.num(a[12]), int(J.num(a[13])))
	G["__nat_twProps"] = func(_t, a): return TwDraw.props(a[0], a[1], a[2], a[3])
	G["__nat_crText"] = func(_t, a): TwRun.cr_text(a[0], J.str(a[1]), J.num(a[2]), J.num(a[3]), J.num(a[4]), a[5], J.str(a[6]), J.num(a[7]), J.t(a[8]), J.str(a[9])); return null
	G["__nat_scSize"] = func(_t, a): return ScRun.size_of()
	G["__nat_scNpc"] = func(_t, a): return ScNpc.draw(a[0], a[1], a[2], J.num(a[3]))
	G["__nat_scItem"] = func(_t, a):
		match J.str(a[4]):
			"chair": ScOffice.draw_free_chair(a[0], a[1], a[2])
			"kenchair": ScOffice.draw_ken_chair(a[0], a[1], a[2])
			_: ScOffice.draw_item(a[0], a[1], a[2], J.num(a[3]))
		return null
	G["__nat_scKen"] = func(_t, a): return ScOffice.draw_ken(a[0], a[1], a[2], J.num(a[3]))
	G["__nat_scEnd"] = func(_t, a): ScRun.end_hook(a[0]); NvDomCard.scare_end.call_deferred(); return null
	G["__nat_scTag"] = func(_t, a): ScTag.draw(a[0], a[1], a[2], J.num(a[3]), J.num(a[4]), J.num(a[5]), a[6]); return null
	G["__nat_scSky"] = func(_t, a): ScFast.sky(a[0], a[1], J.num(a[2]), J.num(a[3])); return null
	G["__nat_scBub"] = func(_t, a): ScFast.bubble(a[0], a[1], J.str(a[2]), J.num(a[3]), J.num(a[4]), J.t(a[5]), a[6] if a.size() > 6 else null); return null
	G["__nat_scSel"] = func(_t, a): return ScSelect.hook(a[0])
	G["__nat_scOps"] = func(_t, a): return ScOps.hook(a)
	G["__nat_battle"] = func(_t, a): return BtRun.hook(a[0])
	G["__nat_btSize"] = func(_t, a): return BtRun.size_of()
	G["__nat_btSelect"] = func(_t, a): return BtSelect.hook(a)
	G["__nat_stStreet"] = func(_t, a): return StStreet.hook()
	G["__nat_stOn"] = func(_t, a): return NvPolTip.station_on()
	G["__nat_stStreetEnd"] = func(_t, a): StStreet.end_hook(); return null
	G["__nat_turf"] = func(_t, a): return StTurf.hook(a[0])
	G["__nat_turfEnd"] = func(_t, a): StTurf.end_hook(a[0]); return null
	G["__nat_mini"] = func(_t, a): return MiniStage.hook(a[0], J.str(a[1]), J.str(a[2]), J.str(a[3]) if a.size() > 3 else "draw", J.str(a[4]) if a.size() > 4 else "", J.str(a[5]) if a.size() > 5 else "")
	G["__nat_miniSize"] = func(_t, a): return MiniStage.size_of(J.str(a[0]) if a.size() > 0 else "")
	G["__nat_gyEnd"] = func(_t, a): return GyEnd.hook(a[0])
	G["__nat_miniEnd"] = func(_t, a): MiniStage.end_hook(J.str(a[0]) if a.size() > 0 else ""); return null
	G["__nat_chip"] = func(_t, a): VChips.set_chip(J.str(a[0]), J.str(a[1]), J.str(a[2]) if a.size() > 2 else ""); return null
	G["__nat_gsDraw"] = func(_t, a): GsDraw.draw(a[0], a[1], J.num(a[2])); return null
	G["__nat_drawChar"] = func(_t, a): Art.draw_char(a[0], J.str(a[1]), J.num(a[2]), J.num(a[3]), J.num(a[4]), (a[5] as Dictionary).duplicate() if a.size() > 5 and a[5] is Dictionary else {}); return null
	G["__nat_meshDraw"] = func(_t, a): return MeshAnim.draw_js(a[0], J.str(a[1]), a[2], J.num(a[3]), J.num(a[4]), J.num(a[5]), a[6] if a[6] is Dictionary else {}, J.t(a[7]))
	G["Web"] = {"boot": func(_t, a): return false, "receive": func(_t, a): J.cl(a[0], null, []); return null, "init": func(_t, a): return null,
		"enc": func(_t, a): return G_enc(a[0]), "dec": func(_t, a): return G_dec(J.str(a[0])), "installGuide": func(_t, a): return null, "local": true}
	G["GAME_VER"] = DB.D.get("GAME_VER", "godot")
	G["IS_WEB"] = false; G["IS_FILE"] = false; G["IS_IOS"] = false; G["IS_SAMSUNG"] = false
	G["isStandalone"] = func(_t, a): return true

static func G_enc(o) -> String: return Marshalls.utf8_to_base64(J.to_json(o))
static func G_dec(t: String):
	t = t.strip_edges()
	var i = t.find("#save=")
	if i >= 0: t = t.substr(i + 6).uri_decode()
	return JSON.parse_string(Marshalls.base64_to_utf8(t))

# 簡單 HTML → BBCode（提示、面板文字用）
static func html2bb(h: String) -> String:
	var s = h
	s = s.replace("<br>", "\n").replace("<br/>", "\n").replace("<br />", "\n")
	for t in ["b", "strong"]: s = s.replace("<%s>" % t, "[b]").replace("</%s>" % t, "[/b]")
	s = s.replace("<small>", "[font_size=12]").replace("</small>", "[/font_size]")
	s = s.replace("<i>", "[i]").replace("</i>", "[/i]")
	var rx = RegEx.create_from_string("<p[^>]*>"); s = rx.sub(s, "", true)
	s = s.replace("</p>", "\n")
	rx = RegEx.create_from_string("<(div|li)[^>]*>"); s = rx.sub(s, "", true)
	s = s.replace("</div>", "\n").replace("</li>", "\n")
	rx = RegEx.create_from_string("<span class=\"lack\">([^<]*)</span>"); s = rx.sub(s, "[color=#ff8a7a]$1[/color]", true)
	rx = RegEx.create_from_string("<[^>]+>"); s = rx.sub(s, "", true)
	s = s.replace("&nbsp;", " ").replace("&lt;", "<").replace("&gt;", ">").replace("&amp;", "&")
	return s.strip_edges()

static func wrap0(f: Callable) -> Callable: return func(_t, _a): return f.call()

# 載入模塊之後、startGame 之前：JS 嘅 DOM 介面換成 Godot 介面
static func connect_ui(main) -> void:
	var G = J.G
	var story = main.story
	G["Title"] = {"show": func(_t, a): main.call_deferred("_show_title", J.t(a[0])), "hide": func(_t, a): main._hide_title()}
	# 聲音：WebAudio 換成原生合成引擎（core/snd.gd）
	G["Sound"] = {"play": func(_t, a): Snd.play(J.str(a[0]), a[1] if a.size() > 1 else null); return null,
		"setMode": func(_t, a): Snd.set_mode(J.str(a[0])); return null,
		"toggle": func(_t, a): return Snd.toggle(),
		"isOn": func(_t, a): return Snd.is_on(),
		"unlock": func(_t, a): return null}
	var phone = G.get("Phone")
	if phone is Dictionary:
		phone["home"] = func(_t, a): main.call_deferred("phone_home", J.str(a[0]) if a.size() > 0 else "post"); return null
		phone["close"] = func(_t, a): main.phone_close(); return null
		phone["enter"] = func(_t, a): main._phone_enter("post"); return null
		phone["on"] = false
	var st = {"q": [], "cur": null,
		"busy": func(_t, a): return story.busy(),
		"queue": func(_t, a):
			var cb = a[1] if a.size() > 1 else null
			story.queue(a[0], (func(): J.cl(cb, null, [])) if cb != null else Callable()); return null,
		"next": func(_t, a): story.next(); return null,
		"skipScene": func(_t, a): story.skip_scene(); return null}
	st["__getters"] = {"cur": func(_t, a): return {} if story.cur != null else null}
	G["Story"] = st
	var fx = G.get("Fx")
	if fx is Dictionary:
		fx["toast"] = func(_t, a): main.show_toast(html2bb(J.str(a[0]))); return null
		fx["banner"] = func(_t, a): main.show_banner(J.str(a[0])); return null
		fx["praise"] = func(_t, a): main.show_praise(J.str(a[0])); return null
	var ui = G.get("UI")
	if ui is Dictionary:
		var orig_refresh = ui.get("refresh")
		ui["refresh"] = func(_t, a):
			J.cl(orig_refresh, ui, a); main.call_deferred("refresh"); return null
		var orig_open = ui.get("open")
		ui["open"] = func(_t, a):
			J.cl(orig_open, ui, a); main._nav_on(J.str(a[0])); return null
		var orig_close = ui.get("close")
		ui["close"] = func(_t, a):
			J.cl(orig_close, ui, a); main._nav_on("village"); return null
	var joss = G.get("JossFx")
	if joss is Dictionary: joss["play"] = func(_t, a): return null
