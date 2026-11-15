# 全面自檢：裝新版第一次開遊戲自動跑（設定／救命畫面都可以手動開）
# - 逐項測試顯示卡功能、字型、聲音、存檔，再逐個玩法開幾秒
# - 每項開始前寫低「而家測緊邊項」；閃退後重開會自動記低嗰項「閃退」並繼續下一項
# - 用測試存檔跑，玩家自己嘅存檔先收埋，測完自動還原
# - 完成出報告：複製／WhatsApp 傳俾開發者
class_name SelfTest
extends Control

const ST := "user://selftest.json"
const BAK := "user://selftest_backup_save.json"
const LS := "user://localStorage.json"

const PRE := [
	["info", "裝置資料"], ["draw", "基本繪圖"], ["font", "中文字型"], ["tex", "圖片"], ["tex4k", "4096 大圖"], ["tex8k", "8192 超大圖"],
	["grad_new", "漸變（新做法）"], ["grad_old", "漸變（舊做法）"], ["poly", "大量多邊形"], ["lines", "大量線條"],
	["subvp", "離屏拍照"], ["sh_gray", "灰階效果"], ["sh_sprite", "角色效果"], ["sh_hue", "變色效果"], ["sh_hue_mix", "混色效果"],
	["sh_dark", "黑夜效果"], ["sh_mesh", "骨架動畫效果"], ["audio", "聲音"], ["file", "存檔讀寫"]]
const POST := [
	["boot", "載入遊戲"], ["ground", "村子地面（重畫）"], ["village", "村子"], ["world", "陰間地圖"], ["patrol", "夜班巡陰"],
	["scare", "回陽間・夜班嚇人"], ["battle", "主線戰鬥"], ["tower", "樓裡有鬼"], ["street", "陽間站崗"],
	["gstreet", "冥街夜市"], ["gyard", "亂葬崗"], ["sports", "運動會"]]

static var S := {}

static func load_state() -> void:
	S = {}
	if FileAccess.file_exists(ST):
		var o = JSON.parse_string(FileAccess.get_file_as_string(ST))
		if o is Dictionary: S = o
static func save_state() -> void:
	var f = FileAccess.open(ST, FileAccess.WRITE)
	if f: f.store_string(JSON.stringify(S)); f.flush(); f.close()
static func active() -> bool: return S.get("active", false)
static func ver() -> String: return str(ProjectSettings.get_setting("application/config/version", "0"))

# 開機時叫：決定要唔要自檢；上次測緊嘅項目冇完成 = 閃退
static func on_boot() -> void:
	load_state()
	if OS.has_environment("GB_TEST") and not OS.has_environment("GB_SELFTEST"): S = {}; return
	if not active() and not FileAccess.file_exists("user://selftest_done_" + ver()): start(false)
	if active() and str(S.get("cur", "")) != "":
		S.res[S.cur] = "閃退"; S.cur = ""; save_state()

static func start(manual: bool) -> void:
	S = {"active": true, "ver": ver(), "res": {}, "cur": "", "manual": manual, "t0": Time.get_unix_time_from_system()}
	# 玩家存檔收埋（測完還原）
	if FileAccess.file_exists(LS) and not FileAccess.file_exists(BAK): DirAccess.copy_absolute(LS, BAK)
	save_state()

static func begin(id: String) -> void:
	S.cur = id; save_state()
static func done(id: String, r: String) -> void:
	S.res[id] = r; S.cur = ""; save_state()
static func pending(list: Array) -> Array:
	return list.filter(func(x): return not S.res.has(x[0]))

# 自檢期間用測試存檔
static func test_save_json() -> String:
	var o = JSON.parse_string(FileAccess.get_file_as_string("res://data/selftest_save.json"))
	var d = G.dec(str(o.code)) if o is Dictionary else null
	if d == null: return ""
	d.last = G.now_ms()
	return J.to_json(d)

static func finish_restore() -> void:
	if FileAccess.file_exists(BAK):
		DirAccess.copy_absolute(BAK, LS); DirAccess.remove_absolute(BAK)
	else: DirAccess.remove_absolute(LS)
	var f = FileAccess.open("user://selftest_done_" + ver(), FileAccess.WRITE); if f: f.store_string("1"); f.close()
	S.active = false; save_state()

static func report() -> String:
	var lines = ["【過勞鬼大作戰 自檢報告】v" + ver()]
	lines.append("型號：%s　系統：%s %s" % [OS.get_model_name(), OS.get_name(), OS.get_version()])
	lines.append("顯示卡：%s / %s　API：%s" % [RenderingServer.get_video_adapter_vendor(), RenderingServer.get_video_adapter_name(), RenderingServer.get_video_adapter_api_version()])
	lines.append("螢幕：%s　DPI：%d　記憶體：%s" % [str(DisplayServer.screen_get_size()), DisplayServer.screen_get_dpi(), str(OS.get_memory_info().get("physical", 0) / 1048576) + "MB"])
	var bad = []
	for grp in [PRE, POST]:
		for x in grp:
			var r = str(S.get("res", {}).get(x[0], "未測"))
			lines.append(("✓ " if r.begins_with("OK") else "✗ ") + x[1] + "：" + r)
			if not r.begins_with("OK"): bad.append(x[1])
	lines.insert(1, "結果：" + ("全部通過" if bad.is_empty() else "有問題 → " + "、".join(bad)))
	return "\n".join(lines)

# ---------------- 畫面（自檢進度）----------------
var list_lbl: Label
var title_lbl: Label
func build(host: Control) -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); mouse_filter = Control.MOUSE_FILTER_STOP; z_index = 100
	var bg = ColorRect.new(); bg.color = Color(0.05, 0.04, 0.06, 0.94); bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); add_child(bg)
	var vb = VBoxContainer.new(); vb.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); vb.offset_left = 14; vb.offset_right = -14; vb.offset_top = 40; vb.offset_bottom = -20; add_child(vb)
	title_lbl = Label.new(); title_lbl.text = "全面自檢中…（約 3–5 分鐘）\n如果閃退，重新打開會自動繼續。"; title_lbl.add_theme_font_size_override("font_size", 15); title_lbl.add_theme_color_override("font_color", Color("#f3e6c8")); title_lbl.autowrap_mode = TextServer.AUTOWRAP_ARBITRARY; vb.add_child(title_lbl)
	list_lbl = Label.new(); list_lbl.add_theme_font_size_override("font_size", 12); list_lbl.add_theme_color_override("font_color", Color("#d8ccb8")); list_lbl.autowrap_mode = TextServer.AUTOWRAP_ARBITRARY; list_lbl.size_flags_vertical = Control.SIZE_EXPAND_FILL; vb.add_child(list_lbl)
	var stop = Button.new(); stop.text = "停止自檢（還原我嘅存檔）"; stop.custom_minimum_size = Vector2(0, 40); vb.add_child(stop)
	stop.pressed.connect(func(): finish_restore(); JSRun.reset_world(); get_tree().call_deferred("reload_current_scene"))
	host.add_child(self); refresh()

func refresh(cur := "") -> void:
	if list_lbl == null: return
	var t = []
	for grp in [PRE, POST]:
		for x in grp:
			var r = S.get("res", {}).get(x[0], "")
			var mark = "…" if x[0] == cur else ("✓" if str(r).begins_with("OK") else ("✗" if r != "" else "・"))
			t.append("%s %s %s" % [mark, x[1], ("" if r == "" or str(r).begins_with("OK") else "（" + str(r) + "）")])
	list_lbl.text = "\n".join(t)

# ---------------- 第一階段：未載遊戲前 ----------------
func run_pre() -> void:
	for x in pending(PRE):
		begin(x[0]); refresh(x[0]); await get_tree().process_frame
		var r = await _test(x[0])
		if r == null or str(r) == "": r = "出錯（腳本錯誤，睇記錄）"
		done(x[0], r); refresh()

func _probe_draw(fn: Callable, frames := 3, mat: Material = null) -> String:
	var n = PtDraw.new(); n.fn = fn; n.position = Vector2(20, 300); n.material = mat; add_child(n); n.queue_redraw()
	for i in frames: await RenderingServer.frame_post_draw
	n.queue_free(); return "OK"

func _shader_rect(path: String, params := {}) -> String:
	var sh = load(path)
	if sh == null: return "載入失敗"
	var m = ShaderMaterial.new(); m.shader = sh
	for k in params: m.set_shader_parameter(k, params[k])
	var tx = Spr.get_tex("cover")
	return await _probe_draw(func(c): c.draw_texture_rect(tx, Rect2(0, 0, 120, 120), false), 4, m)

func _test(id: String) -> String:
	match id:
		"info": return "OK " + RenderingServer.get_video_adapter_name()
		"draw": return await _probe_draw(func(c): c.draw_rect(Rect2(0, 0, 100, 60), Color.RED); c.draw_circle(Vector2(50, 90), 20, Color.GREEN); c.draw_line(Vector2.ZERO, Vector2(100, 100), Color.WHITE, 3))
		"font":
			var f = UIKit.font("serif", 900)
			return await _probe_draw(func(c): c.draw_string(f, Vector2(0, 30), "過勞鬼大作戰 粵語中文", HORIZONTAL_ALIGNMENT_LEFT, -1, 22))
		"tex":
			var t = Spr.get_tex("cover"); if t == null: return "封面圖讀唔到"
			return await _probe_draw(func(c): c.draw_texture_rect(t, Rect2(0, 0, 150, 220), false))
		"tex4k", "tex8k":
			var s = 4096 if id == "tex4k" else 8192
			var img = Image.create(s, 64, false, Image.FORMAT_RGBA8); img.fill(Color(0.3, 0.2, 0.4))
			var t2 = ImageTexture.create_from_image(img)
			var r = await _probe_draw(func(c): c.draw_texture_rect(t2, Rect2(0, 0, 200, 10), false))
			return r + " (max %d)" % RenderingServer.get_rendering_device().limit_get(RenderingDevice.LIMIT_MAX_TEXTURE_SIZE_2D) if RenderingServer.get_rendering_device() else r
		"grad_new":
			var g = Gradient.new(); g.set_color(0, Color.BLACK); g.set_color(1, Color.WHITE)
			var a = GradTex.linear(g); var b = GradTex.radial(g)
			return await _probe_draw(func(c): c.draw_texture_rect(a, Rect2(0, 0, 100, 20), false); c.draw_texture_rect(b, Rect2(0, 30, 60, 60), false))
		"grad_old":
			var g = Gradient.new(); g.set_color(0, Color.BLACK); g.set_color(1, Color.WHITE)
			var a = GradientTexture1D.new(); a.gradient = g
			var b = GradientTexture2D.new(); b.gradient = g; b.fill = GradientTexture2D.FILL_RADIAL; b.width = 64; b.height = 64
			return await _probe_draw(func(c): c.draw_texture_rect(a, Rect2(0, 0, 100, 20), false); c.draw_texture_rect(b, Rect2(0, 30, 60, 60), false))
		"poly":
			return await _probe_draw(func(c):
				for i in 3000:
					var x = fmod(i * 7.3, 300.0); var y = fmod(i * 3.1, 200.0)
					c.draw_colored_polygon(PackedVector2Array([Vector2(x, y), Vector2(x + 6, y), Vector2(x + 3, y + 6)]), Color(1, 1, 1, 0.05)))
		"lines":
			return await _probe_draw(func(c):
				var pts = PackedVector2Array()
				for i in 20000: pts.append(Vector2(fmod(i * 1.7, 300.0), fmod(i * 2.9, 200.0)))
				c.draw_multiline(pts, Color(1, 1, 1, 0.05), 1.5))
		"subvp":
			var vp = SubViewport.new(); vp.size = Vector2i(256, 256); vp.transparent_bg = true; vp.render_target_update_mode = SubViewport.UPDATE_ONCE
			var n = PtDraw.new(); n.fn = func(c): c.draw_rect(Rect2(0, 0, 128, 128), Color.ORANGE); vp.add_child(n); add_child(vp)
			await RenderingServer.frame_post_draw; await RenderingServer.frame_post_draw
			var img = vp.get_texture().get_image(); vp.queue_free()
			return "OK" if img != null else "拍唔到"
		"sh_gray":
			var m = ShaderMaterial.new(); var sh = Shader.new(); sh.code = "shader_type canvas_item; void fragment(){ vec4 c = texture(TEXTURE, UV) * COLOR; float g = dot(c.rgb, vec3(0.299,0.587,0.114)); COLOR = vec4(mix(c.rgb, vec3(g), 0.85), c.a); }"; m.shader = sh
			var tx = Spr.get_tex("cover")
			return await _probe_draw(func(c): c.draw_texture_rect(tx, Rect2(0, 0, 120, 120), false), 4, m)
		"sh_sprite": return await _shader_rect("res://game/patrol/pt_sprite.gdshader")
		"sh_hue": return await _shader_rect("res://game/patrol/pt_hue.gdshader")
		"sh_hue_mix": return await _shader_rect("res://game/patrol/pt_hue_mix.gdshader")
		"sh_dark": return await _shader_rect("res://game/patrol/pt_dark.gdshader")
		"sh_mesh":
			# 同角色骨架一樣：ArrayMesh＋CUSTOM0/1 權重＋pt_mesh shader
			var verts = PackedVector2Array([Vector2(0, 0), Vector2(1, 0), Vector2(0, 1), Vector2(1, 1)])
			var c0 = PackedFloat32Array(); var c1 = PackedFloat32Array()
			for v in 4: c0.append_array([1.0, 0.0, 0.0, 0.0]); c1.append_array([0.0, 0.0, 0.0, 0.0])
			var arr = []; arr.resize(Mesh.ARRAY_MAX)
			arr[Mesh.ARRAY_VERTEX] = verts; arr[Mesh.ARRAY_TEX_UV] = verts; arr[Mesh.ARRAY_CUSTOM0] = c0; arr[Mesh.ARRAY_CUSTOM1] = c1; arr[Mesh.ARRAY_INDEX] = PackedInt32Array([0, 1, 2, 1, 3, 2])
			var me = ArrayMesh.new()
			me.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arr, [], {}, (Mesh.ARRAY_CUSTOM_RGBA_FLOAT << Mesh.ARRAY_FORMAT_CUSTOM0_SHIFT) | (Mesh.ARRAY_CUSTOM_RGBA_FLOAT << Mesh.ARRAY_FORMAT_CUSTOM1_SHIFT))
			me.custom_aabb = AABB(Vector3(-4000, -4000, 0), Vector3(8000, 8000, 0))
			var m = ShaderMaterial.new(); m.shader = load("res://game/patrol/pt_mesh.gdshader")
			var bones = []; for b in 12: bones.append(Vector4(1, 0, 0, 0))
			m.set_shader_parameter("bone", bones); m.set_shader_parameter("dims", Vector3(100, 100, 1)); m.set_shader_parameter("aff_o", Vector2(200, 300))
			var mi = MeshInstance2D.new(); mi.mesh = me; mi.texture = Spr.get_tex("cover"); mi.material = m; add_child(mi)
			for k in 4: await RenderingServer.frame_post_draw
			mi.queue_free(); return "OK"
		"audio": Snd.play("click"); await get_tree().create_timer(0.3).timeout; return "OK"
		"file":
			var f = FileAccess.open("user://selftest_io.txt", FileAccess.WRITE); if f == null: return "寫唔到"
			f.store_string("abc"); f.close()
			return "OK" if FileAccess.get_file_as_string("user://selftest_io.txt") == "abc" else "讀寫唔一致"
	return "未知"

# ---------------- 第二階段：遊戲載入後，逐個玩法開幾秒（每項之後重開遊戲畫面）----------------
func run_post(main: Node) -> void:
	S.res["boot"] = S.res.get("boot", "OK"); save_state()
	var p = pending(POST)
	if p.is_empty(): _finish(); return
	var x = p[0]
	begin(x[0]); refresh(x[0]); visible = true
	var r = await _mode(x[0], main)
	if r == null or str(r) == "": r = "出錯（腳本錯誤，睇記錄）"
	done(x[0], r); refresh()
	if pending(POST).is_empty(): _finish(); return
	# 重開遊戲畫面，乾淨狀態測下一項
	JSRun.skip_title = true; JSRun.reset_world(); get_tree().call_deferred("reload_current_scene")

func _wait(s: float) -> void: await get_tree().create_timer(s).timeout

func _mode(id: String, main: Node) -> String:
	var errs0 = _err_count()
	modulate.a = 0.0   # 測玩法時隱藏自檢畫面，等玩法真係畫出嚟
	match id:
		"ground":
			var gl = J.cl(J.G.get("groundLayer"), null, [])
			if not (gl is El) or gl.rec == null: modulate.a = 1; return "冇地面記錄"
			var n = PtDraw.new(); n.fn = func(c): gl.rec.replay(c, Transform2D(Vector2(0.5, 0), Vector2(0, 0.5), Vector2.ZERO)); main.add_child(n)
			await _wait(1.0); n.queue_free()
		"village": await _wait(4.0)
		"world": J.mc(J.G.get("World"), "open", []); await _wait(3.0)
		"patrol":
			var S0 = J.G.get("S")
			if S0 is Dictionary and S0.get("pt") is Dictionary: S0.pt["introSeen"] = 1
			J.cl(J.G.get("__nat_patrol"), null, [0.0, 54.0]); await _wait(5.0)
		"scare": J.mc(J.G.get("Scare"), "start", ["office", ["afu", "eguiking", "toyol"]]); await _wait(5.0)
		"battle": J.mc(J.G.get("Battle"), "start", [0.0, 0.0]); await _wait(5.0)
		"tower": J.mc(J.G.get("Tower"), "open", []); await _wait(4.0)
		"street": J.mc(J.G.get("Street"), "open", []); await _wait(4.0)
		"gstreet": J.mc(J.G.get("GhostStreet"), "open", []); await _wait(4.0)
		"gyard": J.mc(J.G.get("Graveyard"), "open", []); await _wait(4.0)
		"sports": J.mc(J.G.get("Sports"), "open", []); await _wait(4.0)
	modulate.a = 1.0
	var ne = _err_count() - errs0
	return "OK" if ne == 0 else "OK（%d 個腳本錯誤）" % ne

func _err_count() -> int:
	var f = FileAccess.open(ProjectSettings.get_setting("debug/file_logging/log_path", "user://logs/godot.log"), FileAccess.READ)
	return f.get_as_text().count("SCRIPT ERROR") if f else 0

func _finish() -> void:
	var rep = report()
	finish_restore()
	DisplayServer.clipboard_set(rep)
	for c in get_children(): c.queue_free()
	var bg = ColorRect.new(); bg.color = Color(0.05, 0.04, 0.06, 1.0); bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); add_child(bg)
	var vb = VBoxContainer.new(); vb.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); vb.offset_left = 14; vb.offset_right = -14; vb.offset_top = 40; vb.offset_bottom = -20; add_child(vb)
	var tl = Label.new(); tl.text = "自檢完成！報告已複製，請截圖或者用 WhatsApp 傳俾開發者。"; tl.autowrap_mode = TextServer.AUTOWRAP_ARBITRARY; tl.add_theme_font_size_override("font_size", 15); tl.add_theme_color_override("font_color", Color("#f3e6c8")); vb.add_child(tl)
	var rl = Label.new(); rl.text = rep; rl.autowrap_mode = TextServer.AUTOWRAP_ARBITRARY; rl.add_theme_font_size_override("font_size", 11); rl.add_theme_color_override("font_color", Color("#d8ccb8")); rl.size_flags_vertical = Control.SIZE_EXPAND_FILL; vb.add_child(rl)
	var wa = Button.new(); wa.text = "用 WhatsApp 傳送報告"; wa.custom_minimum_size = Vector2(0, 42); vb.add_child(wa)
	wa.pressed.connect(func(): OS.shell_open("https://wa.me/?text=" + rep.uri_encode()))
	var cp = Button.new(); cp.text = "再複製一次"; cp.custom_minimum_size = Vector2(0, 42); vb.add_child(cp)
	cp.pressed.connect(func(): DisplayServer.clipboard_set(rep))
	var go = Button.new(); go.text = "開始遊戲（已還原你嘅存檔）"; go.custom_minimum_size = Vector2(0, 42); vb.add_child(go)
	go.pressed.connect(func(): JSRun.reset_world(); get_tree().call_deferred("reload_current_scene"))
	visible = true; modulate.a = 1.0
