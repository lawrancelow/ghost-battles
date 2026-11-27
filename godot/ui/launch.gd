# 開機畫面（遊戲主場景 res://main.tscn 嘅腳本）
# 流程：檢查更新 → 有新補丁就即場下載（大進度條、MB、速度）→ 校驗 → 載入補丁
#       → 將真正遊戲代碼換上 autoload 節點（core/db.gd 等係外殼，真身喺 *_impl.gd）→ 載入遊戲主畫面
#       → 遊戲自己載模塊（ui/main.gd 繼續推同一條進度條）→ 標題畫面，直接撳「開始」。唔使重開遊戲。
#
# 硬規矩（唔守就會「更新咗都用舊代碼」）：
#   1. 呢個檔只可以用引擎本身嘅類；唔好用 UIKit、J、Ctx 等自己寫嘅 class_name，亦唔好 preload／load 任何遊戲腳本。
#      更新前載入過嘅腳本會留喺快取，更新後都係舊版。
#   2. core/db.gd 等 autoload 外殼檔唔好加嘢。
#   3. 呢個檔本身改咗，要下一次開遊戲先生效（佢自己喺更新前已經載入咗）。所以介面要穩定：
#      main.gd 只會叫 prog(f)、text(s)、finish()、hide_now()、ver_label()。
#
# 同底包 Boot（core/boot.gd，裝喺 APK 入面改唔到）嘅分工：
#   Boot 開機時載入上次落好嘅補丁，2 秒後會自己喺背景查更新。為咗唔好兩邊一齊落，
#   開機畫面一開始喺 state.json 將 ver 寫成「好大」（Boot 會當已是最新），自己查完就寫返真正版本；
#   真正版本另外記喺 lv。開機畫面查唔到（冇網）就即刻寫返真版本，Boot 嘅背景更新照舊做後備。
extends Node

func _ready() -> void:
	var ov = Overlay.new(); ov.name = "GBLoad"
	get_tree().root.add_child.call_deferred(ov)


class Overlay extends CanvasLayer:
	const GAME := "res://ui/main_game.tscn"
	# 次序要同 project.godot 嘅 autoload 一樣（Boot 除外）
	const LIVE := [
		["DB", "res://core/db_impl.gd"], ["Spr", "res://core/spr_impl.gd"], ["MeshAnim", "res://core/meshanim_impl.gd"],
		["Limbs", "res://core/limbs_impl.gd"], ["Art", "res://core/art_impl.gd"], ["G", "res://game/game_impl.gd"],
		["Tst", "res://core/tester_impl.gd"], ["JSRun", "res://js/jsrun_impl.gd"], ["Snd", "res://core/snd_impl.gd"],
		["QX", "res://game/quest/qx_impl.gd"]]
	const DIR := "user://update"
	const DEFAULT_URL := "https://lawrancelow.github.io/ghost-battles/godot-update/version.json"
	const SENT := 1 << 30
	const TMP := "launch_dl.tmp"

	var passive := false    # main.gd 自己開嘅（重載畫面時）：只顯示，唔行流程
	var boot: Node
	var base := ""
	var plat := ""

	# 介面
	var root_c: Control
	var cover: TextureRect
	var status_l: Label
	var pct_l: Label
	var detail_l: Label
	var ver_l: Label
	var bar_bg: Panel
	var bar_fill: Panel
	var shine: ColorRect
	var btns: HBoxContainer
	var shown := 0.0        # 畫面上嘅進度（追住 target）
	var target := 0.0
	var lo := 0.0
	var hi := 0.04
	var fake := false       # 冇真實進度時慢慢爬（唔好成條 bar 停住）
	var t := 0.0

	# 下載
	var http: HTTPRequest
	var entry := {}
	var dl_from := 0        # 續傳：已經有幾多 bytes
	var dl_last_b := 0
	var dl_last_t := 0
	var speed := 0.0
	var spd_b := 0
	var spd_t := 0
	var tries := 0

	func _ready() -> void:
		layer = 120
		boot = get_node_or_null("/root/Boot")
		base = str(boot.get("base")) if boot else str(ProjectSettings.get_setting("application/config/version", "0"))
		plat = str(boot.get("plat")) if boot else OS.get_name().to_lower()
		_build()
		if passive:
			text("載入遊戲中…"); stage(0.0, 0.96); return
		if Engine.has_meta("gb_live"):   # 已經換過真正代碼（例如有人轉返去 main.tscn）：直接入遊戲
			_load_game(); return
		if boot == null or str(boot.get("status")) == "off":   # 編輯器／網頁版：冇熱更新
			ver_label(); _activate(); return
		_clean_dir()
		_hold_boot()
		_check()

	# ================= 介面 =================
	func _font(f: String) -> Font: return load("res://fonts/%s.otf" % f)

	func _lab(sz: int, col: Color, f := "sans_b") -> Label:
		var l = Label.new(); l.add_theme_font_override("font", _font(f)); l.add_theme_font_size_override("font_size", sz)
		l.add_theme_color_override("font_color", col)
		l.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.85)); l.add_theme_constant_override("outline_size", 5)
		l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; l.mouse_filter = Control.MOUSE_FILTER_IGNORE
		return l

	func _sb(bg: Color, r: int, bc := Color(0, 0, 0, 0), bw := 0) -> StyleBoxFlat:
		var s = StyleBoxFlat.new(); s.bg_color = bg; s.set_corner_radius_all(r); s.anti_aliasing = true
		if bw > 0: s.border_color = bc; s.set_border_width_all(bw)
		return s

	func _build() -> void:
		root_c = Control.new(); root_c.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); add_child(root_c)
		root_c.mouse_filter = Control.MOUSE_FILTER_STOP   # 載入時唔好撳到後面
		var bg = ColorRect.new(); bg.color = Color("#0d0b10"); bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); root_c.add_child(bg)
		# 封面：有新封面 cover2（無字）就鋪滿居中＋疊 Logo＋慢推鏡；冇就用舊 cover（闊度鋪滿、靠頂，字烤喺圖上）
		# 用 IGNORE 載入，唔好留舊版喺快取
		var nc = ResourceLoader.exists("res://assets/spr/cover2.webp")
		var ctex = ResourceLoader.load("res://assets/spr/cover2.webp" if nc else "res://assets/spr/cover.webp", "", ResourceLoader.CACHE_MODE_IGNORE) as Texture2D
		cover = TextureRect.new(); cover.texture = ctex; cover.expand_mode = TextureRect.EXPAND_IGNORE_SIZE; cover.mouse_filter = Control.MOUSE_FILTER_IGNORE
		if nc:
			cover.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED; cover.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); cover.modulate = Color(0.7, 0.7, 0.72)
			root_c.add_child(cover)
			var zf = func(): cover.pivot_offset = root_c.size / 2
			root_c.resized.connect(zf); zf.call_deferred()
			var zt = cover.create_tween().set_loops(); zt.tween_property(cover, "scale", Vector2(1.05, 1.05), 14.0).set_trans(Tween.TRANS_SINE); zt.tween_property(cover, "scale", Vector2.ONE, 14.0).set_trans(Tween.TRANS_SINE)
			if ResourceLoader.exists("res://assets/spr/title_logo.webp"):
				var lg = TextureRect.new(); lg.texture = ResourceLoader.load("res://assets/spr/title_logo.webp", "", ResourceLoader.CACHE_MODE_IGNORE) as Texture2D
				lg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE; lg.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED; lg.mouse_filter = Control.MOUSE_FILTER_IGNORE
				lg.anchor_left = 0.07; lg.anchor_right = 0.93; lg.anchor_top = 0.045; lg.anchor_bottom = 0.25; root_c.add_child(lg)
		else:
			cover.stretch_mode = TextureRect.STRETCH_SCALE; cover.anchor_right = 1; cover.modulate = Color(0.55, 0.55, 0.55); root_c.add_child(cover)
			var fit = func(): if ctex: cover.offset_bottom = root_c.size.x * ctex.get_height() / ctex.get_width()
			root_c.resized.connect(fit); fit.call_deferred()
		# 底部漸暗，令進度條清楚
		var shade = ColorRect.new(); shade.anchor_right = 1; shade.anchor_top = 0.70; shade.anchor_bottom = 1; shade.mouse_filter = Control.MOUSE_FILTER_IGNORE
		shade.color = Color(0, 0, 0, 0.55); root_c.add_child(shade)
		status_l = _lab(19, Color("#f3e6c8"), "serif_k"); status_l.anchor_right = 1; status_l.anchor_top = 0.775; status_l.anchor_bottom = 0.775
		status_l.offset_bottom = 30; root_c.add_child(status_l)
		# 進度條：粗、有框、有百分比
		bar_bg = Panel.new(); bar_bg.anchor_left = 0.08; bar_bg.anchor_right = 0.92; bar_bg.anchor_top = 0.82; bar_bg.anchor_bottom = 0.82
		bar_bg.offset_bottom = 26; bar_bg.add_theme_stylebox_override("panel", _sb(Color("#241c18"), 13, Color("#8a7358"), 2))
		bar_bg.mouse_filter = Control.MOUSE_FILTER_IGNORE; root_c.add_child(bar_bg)
		bar_fill = Panel.new(); bar_fill.position = Vector2(3, 3); bar_fill.size = Vector2(0, 20); bar_fill.clip_contents = true
		bar_fill.add_theme_stylebox_override("panel", _sb(Color("#c2362b"), 10)); bar_fill.mouse_filter = Control.MOUSE_FILTER_IGNORE; bar_bg.add_child(bar_fill)
		var hl = ColorRect.new(); hl.color = Color(1, 0.85, 0.6, 0.22); hl.position = Vector2(0, 2); hl.size = Vector2(4000, 6); hl.mouse_filter = Control.MOUSE_FILTER_IGNORE; bar_fill.add_child(hl)
		shine = ColorRect.new(); shine.color = Color(1, 0.95, 0.8, 0.16); shine.size = Vector2(26, 20); shine.mouse_filter = Control.MOUSE_FILTER_IGNORE; bar_fill.add_child(shine)
		pct_l = _lab(15, Color.WHITE, "sans_k"); pct_l.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); pct_l.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		pct_l.text = "0%"; bar_bg.add_child(pct_l)
		detail_l = _lab(14, Color("#d9ccb2")); detail_l.anchor_right = 1; detail_l.anchor_top = 0.82; detail_l.anchor_bottom = 0.82
		detail_l.offset_top = 34; detail_l.offset_bottom = 56; root_c.add_child(detail_l)
		btns = HBoxContainer.new(); btns.anchor_left = 0.08; btns.anchor_right = 0.92; btns.anchor_top = 0.82; btns.anchor_bottom = 0.82
		btns.offset_top = 66; btns.offset_bottom = 112; btns.alignment = BoxContainer.ALIGNMENT_CENTER; btns.add_theme_constant_override("separation", 14)
		btns.visible = false; root_c.add_child(btns)
		ver_l = _lab(11, Color(1, 1, 1, 0.45), "sans_r"); ver_l.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		ver_l.anchor_left = 1; ver_l.anchor_right = 1; ver_l.anchor_top = 1; ver_l.anchor_bottom = 1
		ver_l.offset_left = -300; ver_l.offset_right = -8; ver_l.offset_top = -20; ver_l.offset_bottom = -4; root_c.add_child(ver_l)

	func _btn(txt: String, main_btn: bool, cb: Callable) -> Button:
		var b = Button.new(); b.text = txt; b.focus_mode = Control.FOCUS_NONE; b.custom_minimum_size = Vector2(140, 44)
		b.add_theme_font_override("font", _font("sans_k")); b.add_theme_font_size_override("font_size", 16)
		var c = Color("#c2362b") if main_btn else Color("#3a2e26")
		b.add_theme_stylebox_override("normal", _sb(c, 10, Color("#e0c9a0"), 2))
		b.add_theme_stylebox_override("hover", _sb(c.lightened(0.1), 10, Color("#e0c9a0"), 2))
		b.add_theme_stylebox_override("pressed", _sb(c.darkened(0.2), 10, Color("#e0c9a0"), 2))
		for k in ["font_color", "font_hover_color", "font_pressed_color"]: b.add_theme_color_override(k, Color("#fbf1dc"))
		b.pressed.connect(cb); btns.add_child(b); return b

	func _ask(msg: String, buttons: Array) -> void:
		text(msg); detail_l.text = ""
		for c in btns.get_children(): c.queue_free()
		for b in buttons: _btn(b[0], b[1], b[2])
		btns.visible = true

	func _unask() -> void:
		btns.visible = false
		for c in btns.get_children(): c.queue_free()

	var _shot_dir := OS.get_environment("GB_LAUNCH_SHOTS")   # 開發用：每秒截一張圖（測試進度條）
	var _shot_t := 0.0
	func _process(dt: float) -> void:
		t += dt
		if _shot_dir != "":
			_shot_t += dt
			if _shot_t >= 1.0:
				_shot_t = 0.0; get_viewport().get_texture().get_image().save_png("%s/%05d.png" % [_shot_dir, Time.get_ticks_msec()])
		if fake: target = minf(hi - 0.002, target + (hi - target) * dt * 0.6)
		shown = target if target < shown else lerpf(shown, target, minf(1.0, dt * 8.0))
		if bar_bg:
			var w = maxf(0.0, bar_bg.size.x - 6)
			bar_fill.size = Vector2(w * clampf(shown, 0, 1), bar_bg.size.y - 6)
			shine.visible = shown < 0.999
			shine.position.x = fmod(t * 160.0, maxf(w, 1) + 60) - 40
			pct_l.text = "%d%%" % int(floor(clampf(shown, 0, 1) * 100.0 + 0.0001))
		if http and is_instance_valid(http) and not entry.is_empty(): _dl_tick()

	# 進度：stage(由, 到) 之後 prog(0..1)
	func stage(a: float, b: float, crawl := false) -> void:
		lo = maxf(a, target); hi = maxf(b, lo); fake = crawl
		target = maxf(target, lo)

	func prog(f: float) -> void:
		fake = false
		target = maxf(target, lo + (hi - lo) * clampf(f, 0, 1))

	func text(s: String) -> void: if status_l: status_l.text = s

	func detail(s: String) -> void: if detail_l: detail_l.text = s

	# main.gd：模塊載入接手
	func handoff() -> float:
		var p = target
		stage(p, 0.96); text("載入遊戲中…"); detail(""); return p

	func finish() -> void:
		stage(1.0, 1.0); prog(1.0); shown = 1.0; text("準備好了！"); detail("")
		set_process(true)
		await get_tree().create_timer(0.35).timeout
		var tw = create_tween(); tw.tween_property(root_c, "modulate:a", 0.0, 0.3)
		await tw.finished
		queue_free()

	func hide_now() -> void:
		queue_free()

	func ver_label() -> String:
		var cv = int(boot.get("content_ver")) if boot else 0
		var s = "v%s%s" % [base, ("・更新 %d" % cv) if cv > 0 else ""]
		Engine.set_meta("gb_ver", s)
		if ver_l: ver_l.text = s
		return s

	# ================= 狀態檔（同 Boot 共用 user://update/state.json）=================
	func _state() -> Dictionary:
		var p = DIR + "/state.json"
		if not FileAccess.file_exists(p): return {}
		var o = JSON.parse_string(FileAccess.get_file_as_string(p))
		return o if o is Dictionary else {}

	func _save(o: Dictionary) -> void:
		DirAccess.make_dir_recursive_absolute(DIR)
		var fa = FileAccess.open(DIR + "/state.json", FileAccess.WRITE)
		if fa: fa.store_string(JSON.stringify(o)); fa.close()

	# 而家機入面真正有嘅補丁版本
	func _have() -> int:
		var st = _state()
		if str(st.get("base", "")) != base: return 0
		if st.has("lv"): return int(st.lv)
		var v = int(st.get("ver", 0))
		return 0 if v >= SENT else v

	func _hold_boot() -> void:
		var st = _state(); var h = _have()
		_save({"base": base, "ver": SENT, "file": str(st.get("file", "")) if str(st.get("base", "")) == base else "", "lv": h})
		if boot: boot.set("content_ver", h)
		ver_label()

	func _release_boot(claim := -1) -> void:
		var st = _state(); var h = _have()
		st["base"] = base; st["lv"] = h; st["ver"] = maxi(h, claim)
		if not st.has("file"): st["file"] = ""
		_save(st)

	# 清走舊補丁、半路斷咗嘅下載（而家用緊嗰個唔郁）
	func _clean_dir() -> void:
		var d = DirAccess.open(DIR)
		if d == null: return
		var keep = str(_state().get("file", ""))
		for fn in d.get_files():
			if fn == "state.json" or fn == keep or fn == TMP: continue
			if fn.ends_with(".pck") or fn.ends_with(".tmp"): d.remove(fn)

	# ================= 檢查更新 =================
	func _url() -> String:
		var u = OS.get_environment("GB_UPDATE_URL")
		return u if u != "" else DEFAULT_URL

	func _check() -> void:
		text("檢查更新中…"); detail(""); stage(0.0, 0.04, true)
		var info = null
		for i in 2:
			info = await _get_json(_url())
			if info is Dictionary: break
			await get_tree().create_timer(0.8).timeout
		if not (info is Dictionary):
			_release_boot()
			text("連不上更新伺服器，先用目前的版本"); detail("")
			if boot: boot.set("status", "offline")
			await get_tree().create_timer(0.7).timeout
			_activate(); return
		var e = info.get("base", {}).get(base, {}).get(plat)
		var h = _have()
		if e is Dictionary and int(e.get("ver", 0)) > h and str(e.get("file", "")) != "":
			entry = e; entry["url"] = _url().get_base_dir() + "/" + str(e.file)
			_release_boot(int(e.ver))   # 話俾 Boot 知已經有人落緊，佢唔使再落
			tries = 0; _download(); return
		_release_boot()
		if boot: boot.set("status", "latest")
		ver_label(); prog(1.0)
		_activate()

	func _get_json(url: String):
		var h = HTTPRequest.new(); h.timeout = 10.0; add_child(h)
		var out = [null]
		h.request_completed.connect(func(result, code, _hd, body):
			if result == HTTPRequest.RESULT_SUCCESS and code == 200:
				out[0] = JSON.parse_string(body.get_string_from_utf8())
			else: print("[launch] check failed result=", result, " code=", code))
		if h.request(url + "?t=%d" % int(Time.get_unix_time_from_system()), ["Cache-Control: no-cache"]) != OK:
			h.queue_free(); return null
		await h.request_completed
		h.queue_free()
		return out[0]

	# ================= 下載（有進度、斷咗會續傳）=================
	func _mb(b: float) -> String: return "%.1f" % (b / 1048576.0)

	func _download() -> void:
		_unask()
		var size = int(entry.get("size", 0))
		text("下載更新中…（更新 %d）" % int(entry.ver))
		stage(0.04, 0.58)
		var tmp = DIR + "/" + TMP
		dl_from = 0
		var part = DIR + "/" + TMP + ".part"
		if FileAccess.file_exists(part): DirAccess.remove_absolute(part)
		# 上次（或者頭先）落咗一半：續傳
		if FileAccess.file_exists(tmp) and str(_state().get("dl", "")) == str(entry.md5):
			var f = FileAccess.open(tmp, FileAccess.READ)
			if f: dl_from = f.get_length(); f.close()
			if size > 0 and dl_from >= size: dl_from = 0
		if dl_from == 0 and FileAccess.file_exists(tmp): DirAccess.remove_absolute(tmp)
		var st = _state(); st["dl"] = str(entry.md5); _save(st)
		http = HTTPRequest.new(); http.use_threads = true; http.download_chunk_size = 1 << 18
		http.download_file = part if dl_from > 0 else tmp
		add_child(http)
		http.request_completed.connect(_dl_done)
		var hd = ["User-Agent: GhostBattles", "Cache-Control: no-cache"]
		if dl_from > 0: hd.append("Range: bytes=%d-" % dl_from)
		dl_last_b = 0; dl_last_t = Time.get_ticks_msec(); spd_b = dl_from; spd_t = dl_last_t; speed = 0.0
		print("[launch] download ", entry.url, " from ", dl_from)
		if http.request(str(entry.url), hd) != OK:
			http.queue_free(); http = null; _dl_fail("無法開始下載"); return
		_dl_tick()

	func _dl_tick() -> void:
		var size = float(int(entry.get("size", 0)))
		var got = float(dl_from + http.get_downloaded_bytes())
		if size <= 0: size = float(dl_from + maxi(http.get_body_size(), 0))
		var now = Time.get_ticks_msec()
		if got != dl_last_b: dl_last_b = int(got); dl_last_t = now
		elif now - dl_last_t > 30000:   # 30 秒都冇新數據：當斷線
			http.cancel_request(); var h0 = http; http = null; h0.queue_free(); _dl_fail("網絡沒有反應"); return
		if now - spd_t >= 700:
			var inst = (got - spd_b) / ((now - spd_t) / 1000.0)
			speed = inst if speed <= 0 else lerpf(speed, inst, 0.35)
			spd_b = int(got); spd_t = now
		if size > 0:
			prog(got / size)
			var s = "%s / %s MB" % [_mb(got), _mb(size)]
			if speed > 1024:
				s += "　%s MB/秒" % ("%.2f" % (speed / 1048576.0))
				var left = (size - got) / speed
				if left >= 1: s += "　約 %s" % (("%d 秒" % int(ceil(left))) if left < 90 else ("%d 分鐘" % int(ceil(left / 60.0))))
			detail(s)

	func _dl_done(result: int, code: int, _hd, _body) -> void:
		var h0 = http; http = null
		if h0: h0.queue_free()
		var tmp = DIR + "/" + TMP; var part = tmp + ".part"
		if result != HTTPRequest.RESULT_SUCCESS or not (code == 200 or code == 206):
			# 唔完整都留低，下次續傳（.part 先併入）
			if dl_from > 0 and code == 206: _append(part, tmp)
			_dl_fail("%d/%d" % [result, code]); return
		if dl_from > 0:
			if code == 206: _append(part, tmp)
			else:   # 伺服器唔肯續傳，成個重新落咗
				DirAccess.remove_absolute(tmp); DirAccess.rename_absolute(part, tmp)
		prog(1.0)
		if await _md5(tmp) != str(entry.md5):
			DirAccess.remove_absolute(tmp)
			_dl_fail("檔案不完整"); return
		stage(0.58, 0.61); text("安裝更新中…")
		await get_tree().process_frame
		var fn = str(entry.file).get_file()
		var dst = DIR + "/" + fn
		if FileAccess.file_exists(dst): DirAccess.remove_absolute(dst)
		DirAccess.rename_absolute(tmp, dst)
		_save({"base": base, "ver": int(entry.ver), "file": fn, "lv": int(entry.ver)})   # 舊補丁下次開機先刪（而家仲掛住）
		if not ProjectSettings.load_resource_pack(dst, true):
			_ask("更新已下載，重開遊戲後生效", [["先玩", true, func(): _unask(); _activate()]]); return
		print("[launch] patch ", entry.ver, " loaded in-session")
		if boot: boot.set("content_ver", int(entry.ver)); boot.set("status", "latest")
		ver_label(); prog(1.0)
		_activate()

	# 分幀計 md5（大補丁喺手機要一兩秒，唔好成個畫面停住）
	func _md5(path: String) -> String:
		text("校驗更新中…"); detail("")
		var f = FileAccess.open(path, FileAccess.READ)
		if f == null: return ""
		var hc = HashingContext.new(); hc.start(HashingContext.HASH_MD5)
		var n = float(maxi(f.get_length(), 1)); var tt = Time.get_ticks_msec()
		while f.get_position() < f.get_length():
			hc.update(f.get_buffer(1 << 20))
			if Time.get_ticks_msec() - tt > 30:
				detail("%d%%" % int(f.get_position() * 100.0 / n))
				await get_tree().process_frame; tt = Time.get_ticks_msec()
		f.close(); detail("")
		return hc.finish().hex_encode()

	func _append(src: String, dst: String) -> void:
		var a = FileAccess.open(src, FileAccess.READ)
		if a == null: return
		var b = FileAccess.open(dst, FileAccess.READ_WRITE)
		if b == null: a.close(); return
		b.seek_end()
		while a.get_position() < a.get_length(): b.store_buffer(a.get_buffer(1 << 20))
		a.close(); b.close(); DirAccess.remove_absolute(src)

	func _dl_fail(why: String) -> void:
		print("[launch] download failed ", why)
		tries += 1
		if tries <= 2:   # 自己再試兩次（續傳）
			text("網絡不穩定，重新連接中…"); detail(why)
			await get_tree().create_timer(1.5).timeout
			_download(); return
		_ask("更新下載失敗（%s）" % why, [
			["重試", true, func(): tries = 0; _download()],
			["先玩目前的版本", false, func():
				_unask(); _release_boot()
				if boot: boot.set("status", "dlfail"); boot.set("_err", why)
				_activate()]])

	# ================= 換上真正代碼、入遊戲 =================
	func _activate() -> void:
		_unask(); text("載入遊戲中…"); detail("")
		stage(target, target + 0.06)
		await get_tree().process_frame
		var root = get_tree().root
		var todo = []
		for i in LIVE.size():
			var n = root.get_node_or_null(LIVE[i][0])
			var scr = load(LIVE[i][1])
			if n == null or not (scr is Script) or not scr.can_instantiate():
				_ask("遊戲檔案有問題（%s），請重新安裝" % LIVE[i][0], []); return
			todo.append([n, scr])
			prog(float(i + 1) / LIVE.size() * 0.5)
		# 同引擎開機一樣：先全部掛上腳本，再逐個（照次序）入樹、行 _ready
		for p in todo: p[0].set_script(p[1])
		for p in todo: root.remove_child(p[0])
		var prev: Node = root.get_node("Boot")
		for p in todo:
			p[0].request_ready(); prev.add_sibling(p[0]); prev = p[0]
		Engine.set_meta("gb_live", true)
		print("[launch] live code ready ", Time.get_ticks_msec(), "ms")
		prog(1.0)
		_load_game()

	func _load_game() -> void:
		text("載入遊戲中…")
		stage(target, target + 0.06, true)
		await get_tree().process_frame
		var ps = load(GAME) as PackedScene
		if ps == null: _ask("遊戲檔案有問題（主畫面），請重新安裝", []); return
		prog(1.0)
		print("[launch] game scene loaded ", Time.get_ticks_msec(), "ms")
		get_tree().change_scene_to_packed(ps)
