# [uikit] UI 套件接入測試：各面板開得、貼圖載入、按鈕可撳、字唔出框／唔俾鐵框蓋
# GB_TEST：[["wait",3],["gdrun","res://tools/tests/uikit_test.gd","all"],["quit"]]
extends RefCounted

const PT = preload("res://tools/tests/play_test.gd")
const KS = preload("res://ui/kit_skin.gd")
var ok := 0
var bad := 0
func _p(s) -> void: print("[uikit] ", s)
func _chk(name: String, cond: bool, info = "") -> void:
	if cond: ok += 1
	else: bad += 1; _p("BAD " + name + " " + str(info))
func _wait(s: float) -> void: await Engine.get_main_loop().create_timer(s).timeout

func _game(m) -> void:
	var pt = PT.new(); pt._setup(1e9)
	if m.has_method("_hide_title"): m._hide_title()
	await _wait(1.0)
	for i in 8:
		var st = m.get("story")
		if st and st.get("cur") != null: st.skip_scene()
		await _wait(0.2)
	if m.has_method("_nav_on"): m._nav_on("village")
	await _wait(1.0)

# 檢查一個面板：有鐵框嘅話，所有可見文字／按鈕都要喺框內（唔俾框蓋）
func _audit(name: String, root: Control) -> void:
	if root == null or not root.is_visible_in_tree(): _chk(name + " 可見", false); return
	_chk(name + " 可見", true)
	var fr = root.get_meta("ks_frame") if root.has_meta("ks_frame") else null
	var gr = root.get_global_rect()
	var th = 0.0
	if fr != null:
		th = 0.0 if fr.get("out", false) else float(fr.m) * float(fr.sc)
		var sb = root.get_theme_stylebox("panel") if root is PanelContainer else null
		if sb != null: _chk(name + " 內距>=框厚", sb.get_content_margin(SIDE_LEFT) >= th, [sb.get_content_margin(SIDE_LEFT), th])
	var n_txt = 0
	var under = []
	for c in root.find_children("*", "Control", true, false):
		if not c.is_visible_in_tree() or c.has_meta("ks_skip") or c is NinePatchRect: continue
		if (c is Label or c is Button) and str(c.get("text")) != "":
			n_txt += 1
			var r: Rect2 = c.get_global_rect()
			if th > 0 and (r.position.x < gr.position.x + th - 1.0): under.append(str(c.get("text")).left(8))
	_chk(name + " 有字", n_txt > 0)
	_chk(name + " 冇字俾框蓋", under.is_empty(), under.slice(0, 6))

func _btns(name: String, root: Control) -> void:
	var nb = 0; var tex = 0
	for c in root.find_children("*", "Button", true, false):
		if not c.is_visible_in_tree(): continue
		nb += 1
		if c.has_meta("ks_btn"): tex += 1
	_chk(name + " 按鈕已換套件", nb == 0 or tex > 0, [nb, tex])

func all(tt) -> void:
	var m = tt.main()
	for n in ["paper_fill", "dark_fill", "panel_large", "btn_primary", "btn_secondary", "btn_close", "nav_village", "nav_village_on", "res_slot", "lord_plaque", "bar_track", "bar_fill", "card", "popup_small"]:
		_chk("貼圖 " + n, KS.tex(n) != null)
	await _game(m)
	# 台面板
	var sc = m.get("mv_view")
	if sc != null:
		sc.open_sheet("st_shoubao"); await _wait(1.0)
		_audit("台面板", sc.sheet); _btns("台面板", sc.sheet)
		sc.close_sheet(); await _wait(0.3)
	for it in [["名冊", "open_roster"], ["箱子", "open_chests"], ["劇情", "open_story"]]:
		m.call(it[1]); await _wait(0.8)
		_audit(it[0], m.sheet); _btns(it[0], m.sheet)
		m.close_sheet(); await _wait(0.3)
	m.open_building("wood"); await _wait(0.8); _audit("建築", m.sheet); m.close_sheet(); await _wait(0.3)
	# 設置
	m.open_settings(false, true); await _wait(1.0)
	var sp = m.find_child("SettingsPanel", true, false)
	_chk("設置面板開到", sp != null)
	# 頂欄、導航
	_chk("導航圖示用套件", m.nav_btns["village"][1].texture != null and str(m.nav_btns["village"][1].texture.resource_path).find("/ui/kit/") >= 0)
	_p("RESULT ok=%d bad=%d" % [ok, bad])
