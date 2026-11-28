# 劇情播放器（移植 game.js Story）：talk（舞台＋對話框）、sys（陰司 KPI 系統視窗）；其他樣式暫時用旁白框
extends Control

var q: Array = []
var cur = null
var li = 0
var typing = false
var shown = 0
var full_text = ""
var type_acc = 0.0
var actors: Array = []

var stage: Control
var talkbox: Panel
var nm: Label
var tx: Label
var pt: TextureRect
var syswin: Panel
var sysbody: VBoxContainer
var sysscroll: ScrollContainer
var tap_hint: Label
var _sys_want := 180.0

func _sys_layout() -> void:   # [cg] 系統窗位置：有插圖時，插圖＋系統窗成組喺畫面居中；冇就系統窗自己居中
	if syswin == null or not is_instance_valid(syswin): return
	var want = _sys_want
	var on = cg != null and is_instance_valid(cg) and cg.visible
	if on:
		var total = cg.size.y + 12.0 + want
		var top = maxf(8.0, (size.y - total) / 2.0)
		cg.offset_top = top
		syswin.anchor_top = 0; syswin.anchor_bottom = 0
		syswin.offset_top = top + cg.size.y + 12.0; syswin.offset_bottom = syswin.offset_top + want
	else:
		syswin.anchor_top = 0.5; syswin.anchor_bottom = 0.5
		syswin.offset_top = -want / 2; syswin.offset_bottom = want / 2
	if tap_hint != null: tap_hint.position.y = (syswin.offset_bottom if on else size.y / 2 + want / 2) + 14
var cur_line_label: Label
const CGC = preload("res://ui/story_cg.gd")   # [cg] 劇情插圖卡
const VOX = preload("res://ui/story_vox.gd")   # [vox] 角色語氣聲
var vox: Node = null
var cg: Control = null

func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_STOP
	visible = false
	G.story_busy = func() -> bool: return busy()
	G.story_req.connect(queue)

func busy() -> bool: return cur != null or q.size() > 0

func queue(sc, cb: Callable = Callable()) -> void:
	q.append({"sc": sc, "cb": cb})
	if cur == null: next()

func next() -> void:
	if cur != null and cur.cb.is_valid():
		var f: Callable = cur.cb; cur.cb = Callable(); f.call()
	if q.is_empty():
		cur = null; visible = false; _clear(); G.refreshed.emit(); G.quest_check(); G.save(); return
	var it: Dictionary = q.pop_front()
	var sc = it.sc
	if sc is String:
		G.S.seen[sc] = true
		sc = DB.D.SCENES.get(sc)
		if sc == null: next(); return
		sc = filter_lines(sc, G.S)
	cur = {"sc": sc, "cb": it.cb, "id": it.sc if it.sc is String else ""}
	li = 0; visible = true
	_build(sc)
	if wa != null: return
	_show_line()

func _clear() -> void:
	for c in get_children(): c.queue_free()
	stage = null; talkbox = null; syswin = null; wa = null; cg = null; vox = null; more_hint = null

var wa: WA = null

func _build(sc: Dictionary) -> void:
	G.crumb("ng:story_" + str(cur.id if cur != null else ""))
	_clear()
	var dim = ColorRect.new(); dim.color = Color(0.04, 0.03, 0.05, 0.72); dim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); dim.mouse_filter = Control.MOUSE_FILTER_IGNORE; add_child(dim)
	var style: String = sc.get("style", "talk")
	if style == "chat":
		dim.color = Color(0, 0, 0, 1)
		wa = WA.new(); add_child(wa)
		wa.start_scene(sc, str(cur.id), func(): next(), func(): skip_scene())
		return
	if style == "talk":
		stage = Control.new(); stage.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); stage.mouse_filter = Control.MOUSE_FILTER_IGNORE
		stage.set_script(load("res://ui/story_stage.gd")); add_child(stage)
		actors = []
		for l in sc.lines:
			var who: String = l[0]
			if DB.D.SPEAKER_ART.has(who) and who != "黑白無常" and not actors.has(who): actors.append(who)
		actors = actors.slice(0, 6)
		stage.set("player", self)
		talkbox = Panel.new()
		var s = UIKit.sb(UIKit.PAPER, 2, UIKit.PAPERLINE, 1); s.shadow_color = Color(0, 0, 0, 0.6); s.shadow_size = 12
		talkbox.add_theme_stylebox_override("panel", s)
		talkbox.anchor_left = 0; talkbox.anchor_right = 1; talkbox.anchor_top = 1; talkbox.anchor_bottom = 1
		talkbox.offset_left = 8; talkbox.offset_right = -8; talkbox.offset_top = -168; talkbox.offset_bottom = -14
		talkbox.mouse_filter = Control.MOUSE_FILTER_IGNORE
		add_child(talkbox)
		pt = TextureRect.new(); pt.position = Vector2(8, 22); pt.size = Vector2(92, 92); pt.expand_mode = TextureRect.EXPAND_IGNORE_SIZE; pt.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		talkbox.add_child(pt)
		var nmp = PanelContainer.new(); nmp.add_theme_stylebox_override("panel", UIKit.sb(UIKit.CINNABAR, 2, Color("#f0c8b4"), 1, Vector4(12, 3, 12, 3)))
		nmp.position = Vector2(108, -15); talkbox.add_child(nmp)
		nm = UIKit.label("", 16, Color("#fff3e0"), "serif", 900); nmp.add_child(nm)
		tx = UIKit.label("", 18, UIKit.INKTXT); tx.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		tx.position = Vector2(108, 24); tx.size = Vector2(250, 120); tx.anchor_right = 1; tx.offset_right = -14
		talkbox.add_child(tx)
	else:
		if sc.has("bg") and Spr.ok("bg_" + str(sc.bg)):
			# 信件／電台／工單都可以有背景（例如電台錄音室），窗口疊喺上面
			var bgr = TextureRect.new(); bgr.texture = Spr.get_tex("bg_" + str(sc.bg)); bgr.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
			bgr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE; bgr.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED; bgr.mouse_filter = Control.MOUSE_FILTER_IGNORE
			bgr.modulate = Color(0.75, 0.72, 0.8); add_child(bgr); move_child(bgr, dim.get_index())
			dim.color.a = 0.25
		syswin = Panel.new()
		var ss = UIKit.sb(Color(0.016, 0.118, 0.11, 0.94), 6, Color("#6ff0d0"), 2); ss.shadow_color = Color(0.43, 0.94, 0.82, 0.3); ss.shadow_size = 24
		if style != "sys": ss = UIKit.sb(Color(0.08, 0.06, 0.09, 0.95), 4, Color("#8a6a4a"), 1)
		syswin.add_theme_stylebox_override("panel", ss)
		syswin.anchor_left = 0.05; syswin.anchor_right = 0.95; syswin.anchor_top = 0.5; syswin.anchor_bottom = 0.5; syswin.offset_top = -90; syswin.offset_bottom = 90
		syswin.mouse_filter = Control.MOUSE_FILTER_IGNORE
		add_child(syswin)
		var hl = UIKit.label("陰司 KPI 系統" if style == "sys" else DB.N(str(sc.get("title", ""))), 18, Color("#6ff0d0") if style == "sys" else UIKit.GOLD2, "serif", 900)
		hl.position = Vector2(14, 10); syswin.add_child(hl)
		sysscroll = ScrollContainer.new(); sysscroll.anchor_right = 1; sysscroll.anchor_bottom = 1; sysscroll.offset_left = 14; sysscroll.offset_top = 44; sysscroll.offset_right = -14; sysscroll.offset_bottom = -14
		sysscroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED; sysscroll.mouse_filter = Control.MOUSE_FILTER_IGNORE
		syswin.add_child(sysscroll)
		sysbody = VBoxContainer.new(); sysbody.size_flags_horizontal = Control.SIZE_EXPAND_FILL; sysbody.add_theme_constant_override("separation", 10)
		sysscroll.add_child(sysbody)
		tap_hint = UIKit.label("點擊繼續", 14, Color(1, 1, 1, 0.55)); tap_hint.position = Vector2(0, 0); tap_hint.size = Vector2(390, 20); tap_hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		add_child(tap_hint)
	cg = Control.new(); cg.set_script(CGC); add_child(cg)   # [cg] 插圖卡（喺對話框／系統窗之上）
	var sk = UIKit.btn("跳過 ▸▸", "ghost", true); sk.anchor_left = 1; sk.anchor_right = 1; sk.offset_left = -96; sk.offset_top = 10; sk.offset_right = -10
	sk.add_theme_color_override("font_color", Color("#e8dcc0")); sk.add_theme_font_size_override("font_size", 14)
	sk.pressed.connect(skip_scene); add_child(sk)

func _show_line() -> void:
	var sc: Dictionary = cur.sc
	var ln: Array = sc.lines[li]; var who: String = ln[0]; var text: String = DB.L(str(ln[1]))
	if cg != null:   # [cg] 呢行有插圖就換
		var cs = CGC.spec_of(sc, li, ln)
		if cs != null:
			if str(cs) == "": cg.hide_cg()
			else: cg.show_spec(cs)
	if vox == null or not is_instance_valid(vox):
		vox = Node.new(); vox.set_script(VOX); add_child(vox)
	vox.line(sc, li, who, text)
	full_text = text; shown = 0; typing = true; type_acc = 0.0; auto_acc = 0.0; pages = [text]; pg = 0
	if talkbox != null:
		nm.get_parent().visible = who != "旁白"; nm.text = DB.N(who)   # 只換顯示；SPEAKER_ART 照用原講者名
		var art = "sys" if who == "系統" else DB.D.SPEAKER_ART.get(who)
		if art == "youhun": art = Art.soul_of({"seed": who})   # [eastsoul] 遊魂頭像：東方亡魂（同一個講者名＝同一個樣）
		pt.visible = art != null
		tx.offset_left = 108 if art != null else 18
		if art != null and art != "sys":
			load("res://game/soul/ace_art.gd").dlg_begin(); var r = Art.portrait_region(art); load("res://game/soul/ace_art.gd").dlg_end()   # [p44] 對話：黑白無常、牛頭馬面、孟婆用手持兵器原圖
			if r.size(): var at = AtlasTexture.new(); at.atlas = r[0]; at.region = r[1]; pt.texture = at
			else: pt.visible = false; tx.offset_left = 18
		elif art == "sys": pt.texture = null
		tx.add_theme_color_override("font_color", UIKit.INKDIM if who == "旁白" else UIKit.INKTXT)
		cur_line_label = tx; tx.text = ""
		_set_pages(text); full_text = pages[0]; _more_refresh()   # [paging] offset_left（有冇頭像）定咗先量
		if stage: stage.queue_redraw()
	else:
		var row = UIKit.rich("", 16, Color("#d8fff4") if sc.get("style") == "sys" else Color("#f0e2c8"))
		var pre = ""
		if sc.get("style") == "sys": pre = "[b][color=#6ff0d0]【系統】[/color][/b]" if who == "系統" else ("" if who == "旁白" else "[b]%s：[/b]" % DB.N(who))
		else: pre = "" if who == "旁白" or who == "內文" else "[b]%s：[/b]" % DB.N(who)
		row.set_meta("pre", pre); sysbody.add_child(row)
		cur_line_label = null; _sysrow = row
		if who == "旁白": row.add_theme_color_override("default_color", Color("#c8c0b0"))

var _sysrow: RichTextLabel

# ---------------- [paging] 對話框自動分頁：長句超出對話框就喺句讀位斷開，撳一下睇下一頁（唔縮字） ----------------
var pages: Array = []      # 呢一句分成幾頁
var pg := 0
var more_hint: Label = null
const TX_TOP := 24.0       # 對白字頂（對話框內）
const TX_BOTTOM := 10.0    # 對白字底留白
const PG_END := "。！？…!?"
const PG_MID := "，、；：,;:—"
const PG_CLOSE := "」』）》〉”’)]】"

# 對話框內對白可用高度
static func tx_avail_h(box_h: float) -> float: return box_h - TX_TOP - TX_BOTTOM

# 用實際字體量：text 喺闊度 w 嘅 Label（lb：同對白一樣嘅字體字號、自動換行）入面排版後幾高
static func measure_h(lb: Label, text: String, w: float) -> float:
	lb.size.x = w; lb.text = text
	var n = lb.get_line_count()
	var sp = lb.get_theme_constant("line_spacing")
	return n * lb.get_line_height() + maxi(0, n - 1) * sp

# 分頁：每頁排版高度 <= max_h；盡量喺句號位斷，其次逗號，最後先硬斷。回傳 Array[String]
static func paginate(lb: Label, text: String, w: float, max_h: float) -> Array:
	var out: Array = []
	var rest := text
	var guard := 0
	while rest != "" and guard < 40:
		guard += 1
		if measure_h(lb, rest, w) <= max_h + 0.5: out.append(rest); rest = ""; break
		var lo := 1; var hi := rest.length()   # 搵最長放得落嘅開頭
		while lo < hi:
			var mid := (lo + hi + 1) / 2
			if measure_h(lb, rest.substr(0, mid), w) <= max_h + 0.5: lo = mid
			else: hi = mid - 1
		var cut := _cut_at(rest, lo)
		out.append(rest.substr(0, cut).strip_edges(false, true))
		rest = rest.substr(cut).strip_edges(true, false)
	if rest != "": out.append(rest)
	if out.is_empty(): out.append(text)
	return out

static func _cut_at(t: String, fit: int) -> int:
	var floor_i := maxi(1, int(fit * 0.35))   # 唔好斷到第一頁得幾隻字
	for set_ in [PG_END, PG_MID]:
		var i := fit
		while i > floor_i:
			if set_.contains(t[i - 1]):
				var j := i
				while j < t.length() and (PG_CLOSE.contains(t[j]) or PG_END.contains(t[j])): j += 1   # 收尾引號／連續句讀跟住上一頁
				if j <= fit: return j
			i -= 1
	var k := fit   # 硬斷：唔好斷喺括號／引號開頭後面、英文數字中間
	while k > floor_i and (_is_word(t[k - 1]) and k < t.length() and _is_word(t[k])): k -= 1
	return k if k > floor_i else fit

static func _is_word(c: String) -> bool:
	var u := c.unicode_at(0)
	return (u >= 48 and u <= 57) or (u >= 65 and u <= 90) or (u >= 97 and u <= 122)

func _tx_w() -> float:
	var bw: float = talkbox.size.x if talkbox.size.x > 50.0 else size.x - 16.0
	return bw - tx.offset_left - 14.0

func _set_pages(text: String) -> void:
	pg = 0
	if talkbox == null or tx == null: pages = [text]; return
	var bh: float = talkbox.size.y if talkbox.size.y > 50.0 else 154.0
	var keep = tx.text
	pages = paginate(tx, text, _tx_w(), tx_avail_h(bh))
	tx.text = keep

func _more_refresh() -> void:
	if talkbox == null: return
	if more_hint == null or not is_instance_valid(more_hint):
		more_hint = UIKit.label("▼", 14, UIKit.CINNABAR, "sans", 900); more_hint.mouse_filter = Control.MOUSE_FILTER_IGNORE
		more_hint.anchor_left = 1; more_hint.anchor_right = 1; more_hint.anchor_top = 1; more_hint.anchor_bottom = 1
		more_hint.offset_left = -26; more_hint.offset_right = -8; more_hint.offset_top = -24; more_hint.offset_bottom = -4
		talkbox.add_child(more_hint)
	more_hint.visible = not typing and pg < pages.size() - 1

const PF = preload("res://game/settings/prefs.gd")   # [settings] 文字速度、自動播放
var auto_acc := 0.0
func _process(dt: float) -> void:
	if cur == null: return
	if not typing:
		_auto_tick(dt); return
	var sec: float = PF.type_sec()
	if sec <= 0.0: shown = full_text.length()
	else:
		type_acc += dt
		while type_acc >= sec and shown < full_text.length():
			type_acc -= sec; shown += 1
	_render_text()
	if shown >= full_text.length(): typing = false; auto_acc = 0.0; _more_refresh()

# 自動播放：打完字 → 等語音播完 → 再等（按字數）→ 翻頁；WhatsApp 模式唔自動
func _auto_tick(dt: float) -> void:
	if not PF.auto_play or wa != null or not visible: auto_acc = 0.0; return
	if vox != null and is_instance_valid(vox) and vox.has_method("playing") and vox.playing(): auto_acc = 0.0; return
	auto_acc += dt
	if auto_acc >= PF.auto_wait(full_text.length()): auto_acc = 0.0; advance()

func _render_text() -> void:
	var s = full_text.substr(0, shown)
	if cur_line_label: cur_line_label.text = s
	elif _sysrow:
		_sysrow.text = str(_sysrow.get_meta("pre", "")) + s.replace("[", "[lb]")
		await get_tree().process_frame
		if sysscroll == null or syswin == null: return
		_sys_want = minf(sysbody.size.y + 58, size.y * 0.6 + 58)
		_sys_layout()
		sysscroll.scroll_vertical = int(sysscroll.get_v_scroll_bar().max_value)

func _gui_input(e: InputEvent) -> void:
	if e is InputEventMouseButton and e.pressed and e.button_index == MOUSE_BUTTON_LEFT: advance()

func advance() -> void:
	if cur == null: return
	if wa != null: wa.advance(false); return
	if typing: shown = full_text.length(); _render_text(); typing = false; _more_refresh(); return
	if pg < pages.size() - 1:   # [paging] 同一句仲有下一頁
		pg += 1; full_text = pages[pg]; shown = 0; typing = true; type_acc = 0.0; auto_acc = 0.0
		if cur_line_label: cur_line_label.text = ""
		_more_refresh(); return
	li += 1
	if li >= cur.sc.lines.size(): next(); return
	_show_line()

func skip_scene() -> void:
	typing = false; next()

func speaker() -> String:
	if wa != null: return ""
	if cur == null or li >= cur.sc.lines.size(): return ""
	return cur.sc.lines[li][0]

# [opening] 條件句："only_seen": {"<行號>": ["場景id", ...]}：玩家未睇過其中任何一場，就略過嗰行
# （例：第 6 章孟婆「又是你」只畀睇過新開場拒湯嘅玩家聽）。cg／vox 行號按原本行號重新對位。
static func filter_lines(sc: Dictionary, S) -> Dictionary:
	var os = sc.get("only_seen")
	if not (os is Dictionary) or os.is_empty(): return sc
	var seen = S.get("seen", {}) if S is Dictionary else {}
	if not (seen is Dictionary): seen = {}
	var keep: Array = []; var remap := {}
	for i in (sc.lines as Array).size():
		var need = os.get(str(i))
		var ok = true
		if need is Array:
			ok = false
			for id in need: if seen.has(str(id)): ok = true
		if ok: remap[str(i)] = str(keep.size()); keep.append(sc.lines[i])
	if keep.size() == (sc.lines as Array).size(): return sc
	var o = sc.duplicate(); o["lines"] = keep
	for fld in ["cg", "vox"]:
		if sc.get(fld) is Dictionary:
			var m := {}
			for k in sc[fld]: if remap.has(str(k)): m[remap[str(k)]] = sc[fld][k]
			o[fld] = m
	return o
