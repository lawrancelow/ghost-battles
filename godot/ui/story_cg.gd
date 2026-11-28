# [cg] 劇情插圖：特殊報導／情節播放時，用「老舊電視」形式喺畫面上半部播一張插圖
#   出場：電視開機（中間一條光線拉開 → 上下撐開成畫面）＋掃描線、暗角、輕微雜訊閃爍；收場：關機縮返一點光。
#   插圖出現時，後面嘅場景背景會濛化＋黑化（對話框唔受影響）。
#   數據（寫喺 SCENES 某場）：
#     "cg": {"<行號>": spec}   由第幾行開始換圖（之後一直顯示，直到下一個 spec；spec 係 "" 就收起）
#     或者行本身第三個元素：["旁白", "……", spec]
#   spec："cg7_box" 或 {"k": "cg7_box", "over": [{"spr": "afu", "x": 0.2, "y": 0.95, "h": 0.55, "flip": false}],
#                       "txt": [{"t": "…", "x": 0.5, "y": 0.2, "s": 22, "c": "#3a2a1a"}]}
#     txt 加 "h"（同 "w"）＝一個框：字自動縮細到完全喺框入面、上下左右置中（y 變成框中心），唔自動斷行，用 \n 分行
#     over 入面 spr 寫 "hero"＝主角（跟性別揀 afu／afuf）
#     over＝喺插圖上疊遊戲現有立繪（老闆原創角色唔交 AI 重畫，一律用程式疊）；x、y 係腳底位置（0–1），h 係高度（插圖高度的比例）
#     txt＝喺插圖上疊文字（插圖本身冇字）
#   插圖冇入 manifest（未批／未到）就自動唔顯示，劇情照播；spec 有 "ph"（佔位圖 key）就先顯示佔位圖。
# 熱更新：冇 class_name；story.gd 用 preload
extends Control

const TV_SHADER := """
shader_type canvas_item;
uniform float pw = 1.0;      // 開機進度 0→1（<0.35 光線橫向拉開；之後上下撐開）
uniform float tm = 0.0;      // 時間（雜訊／閃爍）
float hash(vec2 p){ return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453); }
void fragment(){
	vec2 uv = UV;
	vec2 cc = uv - 0.5;
	uv = 0.5 + cc * (1.0 + dot(cc, cc) * 0.10);   // 輕微弧面
	float a1 = clamp(pw / 0.35, 0.0, 1.0);
	float a2 = clamp((pw - 0.35) / 0.65, 0.0, 1.0);
	float hh = mix(0.006, 0.5, a2 * a2 * (3.0 - 2.0 * a2));
	float ww = mix(0.0, 0.5, a1);
	vec2 suv = vec2(uv.x, 0.5 + (uv.y - 0.5) * (0.5 / max(hh, 0.006)));
	vec3 col = texture(TEXTURE, clamp(suv, 0.0, 1.0)).rgb;
	float ca = 0.0015;   // 少少色散
	col.r = texture(TEXTURE, clamp(suv + vec2(ca, 0.0), 0.0, 1.0)).r;
	col.b = texture(TEXTURE, clamp(suv - vec2(ca, 0.0), 0.0, 1.0)).b;
	float sl = 0.86 + 0.14 * sin(uv.y * 900.0);   // 掃描線
	col *= sl;
	float n = hash(floor(uv * vec2(320.0, 240.0)) + floor(tm * 24.0));
	col += (n - 0.5) * 0.07;   // 雜訊
	col *= 0.97 + 0.03 * sin(tm * 9.0);   // 閃爍
	float vg = smoothstep(0.85, 0.25, length(cc * vec2(1.0, 1.15)));   // 暗角
	col *= mix(0.45, 1.0, vg);
	col += 0.05 * smoothstep(0.45, 0.0, uv.y) * smoothstep(1.0, 0.2, uv.x);   // 玻璃反光
	col = mix(vec3(1.0), col, a2);   // 開機時光線先白後出畫
	bool ins = abs(uv.y - 0.5) <= hh && abs(uv.x - 0.5) <= ww && uv.x >= 0.0 && uv.x <= 1.0 && uv.y >= 0.0 && uv.y <= 1.0;
	COLOR = vec4(ins ? col : vec3(0.02, 0.03, 0.03), 1.0);
}
"""

const BLUR_SHADER := """
shader_type canvas_item;
uniform sampler2D scr : hint_screen_texture, filter_linear_mipmap;
uniform float amt = 0.0;     // 0→1：濛化＋黑化程度
void fragment(){
	vec2 px = SCREEN_PIXEL_SIZE * 3.0 * amt;
	vec3 s = vec3(0.0); float w = 0.0;
	for (int x = -3; x <= 3; x++) { for (int y = -3; y <= 3; y++) {
		float k = exp(-float(x * x + y * y) / 8.0);
		s += texture(scr, SCREEN_UV + vec2(float(x), float(y)) * px).rgb * k; w += k; } }
	s /= w;
	COLOR = vec4(s * mix(1.0, 0.35, amt), 1.0);
}
"""

var frame: Panel
var screen: Panel
var vp: SubViewport
var tv: TextureRect
var pic: TextureRect
var layer: Control
var blur: ColorRect
var cur_key := ""
var _t := 0.0
var _anim := false
var _off := -1.0   # >=0：關機中
var _tvmat: ShaderMaterial
var _blmat: ShaderMaterial
const B := 12.0   # 電視機殼闊度

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	anchor_left = 0.0; anchor_right = 1.0; anchor_top = 0.0; anchor_bottom = 0.0
	offset_left = 10; offset_right = -10; offset_top = 56
	frame = Panel.new(); frame.mouse_filter = Control.MOUSE_FILTER_IGNORE   # 舊電視機殼（深啡木＋黑邊）
	var sb = StyleBoxFlat.new(); sb.bg_color = Color("#3b2a1c"); sb.border_color = Color("#140d08"); sb.set_border_width_all(3)
	sb.set_corner_radius_all(16); sb.shadow_color = Color(0, 0, 0, 0.7); sb.shadow_size = 18
	frame.add_theme_stylebox_override("panel", sb)
	add_child(frame)
	screen = Panel.new(); screen.mouse_filter = Control.MOUSE_FILTER_IGNORE   # 螢幕（圓角、內陷）
	var ss = StyleBoxFlat.new(); ss.bg_color = Color("#050606"); ss.border_color = Color("#0b0806"); ss.set_border_width_all(2); ss.set_corner_radius_all(22)
	screen.add_theme_stylebox_override("panel", ss); screen.clip_children = CanvasItem.CLIP_CHILDREN_AND_DRAW
	frame.add_child(screen)
	vp = SubViewport.new(); vp.transparent_bg = false; vp.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	add_child(vp)
	pic = TextureRect.new(); pic.mouse_filter = Control.MOUSE_FILTER_IGNORE
	pic.expand_mode = TextureRect.EXPAND_IGNORE_SIZE; pic.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	vp.add_child(pic)
	layer = Control.new(); layer.mouse_filter = Control.MOUSE_FILTER_IGNORE; vp.add_child(layer)
	tv = TextureRect.new(); tv.mouse_filter = Control.MOUSE_FILTER_IGNORE; tv.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	tv.texture = vp.get_texture()
	var sh = Shader.new(); sh.code = TV_SHADER; _tvmat = ShaderMaterial.new(); _tvmat.shader = sh; tv.material = _tvmat
	screen.add_child(tv)
	visible = false

static func spec_of(sc: Dictionary, li: int, line: Array):
	if line.size() >= 3 and (line[2] is String or line[2] is Dictionary): return line[2]
	var m = sc.get("cg")
	if m is Dictionary and m.has(str(li)): return m[str(li)]
	return null

func _ensure_blur() -> void:   # 背景濛化＋黑化：放喺舞台之上、對話框之下
	var par = get_parent()
	if par == null: return
	if blur == null or not is_instance_valid(blur):
		blur = ColorRect.new(); blur.mouse_filter = Control.MOUSE_FILTER_IGNORE
		blur.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		var sh = Shader.new(); sh.code = BLUR_SHADER; _blmat = ShaderMaterial.new(); _blmat.shader = sh; blur.material = _blmat
		par.add_child(blur)
	var st = par.get("stage")
	var idx = (st.get_index() + 1) if (st != null and is_instance_valid(st)) else 1
	par.move_child(blur, mini(idx, par.get_child_count() - 1))
	blur.visible = true

func show_spec(spec) -> void:
	if spec == null: return
	var d: Dictionary = spec if spec is Dictionary else {"k": str(spec)}
	var k = str(d.get("k", ""))
	if k != "" and not Spr.ok(k) and str(d.get("ph", "")) != "": k = str(d.ph)   # [opening] 新插圖未到：先用佔位圖（ph）
	if k == "" or not Spr.ok(k):
		hide_cg(); return
	var tex: Texture2D = Spr.get_tex(k)
	if tex == null: hide_cg(); return
	var same = visible and cur_key == k and _off < 0.0
	cur_key = k
	var W = maxf(200.0, get_parent().size.x - 20.0)
	var H = W * float(tex.get_height()) / float(tex.get_width())
	H = minf(H, get_parent().size.y * 0.46)
	size = Vector2(W, H); custom_minimum_size = size
	frame.position = Vector2.ZERO; frame.size = size
	screen.position = Vector2(B, B); screen.size = size - Vector2(B, B) * 2
	tv.position = Vector2.ZERO; tv.size = screen.size
	var vs = Vector2i(int(screen.size.x * 2.0), int(screen.size.y * 2.0))   # 2 倍解像度畫入去，縮細出嚟夠清
	vp.size = vs
	pic.texture = tex; pic.position = Vector2.ZERO; pic.size = Vector2(vs); pic.pivot_offset = pic.size / 2
	layer.position = Vector2.ZERO; layer.size = Vector2(vs)
	W = layer.size.x; H = layer.size.y
	for c in layer.get_children(): c.queue_free()
	for o in d.get("over", []):
		if not (o is Dictionary): continue
		var sk = str(o.get("spr", ""))
		if sk == "hero": sk = _hero_spr()   # 主角：跟玩家揀嘅性別（男 afu／女 afuf）
		var ACE = load("res://game/soul/ace_art.gd"); ACE.dlg_begin()   # [p44] 劇情插圖疊人：五隻用手持兵器原圖
		var st: Texture2D = Spr.get_tex(Art.spr_key(sk)) if Spr.ok(Art.spr_key(sk)) else (Spr.get_tex(sk) if Spr.ok(sk) else null)
		ACE.dlg_end()
		if st == null: continue
		var tr = TextureRect.new(); tr.mouse_filter = Control.MOUSE_FILTER_IGNORE; tr.texture = st
		tr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE; tr.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
		var hh = H * J.num(o.get("h", 0.5)); var ww = hh * float(st.get_width()) / float(st.get_height())
		tr.size = Vector2(ww, hh); tr.position = Vector2(W * J.num(o.get("x", 0.5)) - ww / 2, H * J.num(o.get("y", 0.95)) - hh)
		if J.t(o.get("top")): tr.position.y = H * J.num(o.get("y", 0.05))   # 吊喺天花板嘅角色：y＝頭頂（圖頂）位置
		tr.flip_h = J.t(o.get("flip"))
		if J.t(o.get("top")) or (o.get("shadow") is bool and not o.shadow):   # 唔企喺地上：冇腳底影
			layer.add_child(tr); continue
		var sh = Panel.new(); sh.mouse_filter = Control.MOUSE_FILTER_IGNORE   # 腳底影，令疊上去嘅立繪企得穩
		var ss = StyleBoxFlat.new(); ss.bg_color = Color(0, 0, 0, 0.38); ss.set_corner_radius_all(int(ww * 0.25))
		sh.add_theme_stylebox_override("panel", ss)
		sh.size = Vector2(ww * 0.62, ww * 0.12); sh.position = Vector2(tr.position.x + ww * 0.19, tr.position.y + hh - ww * 0.07)
		layer.add_child(sh); layer.add_child(tr)
	for t in d.get("txt", []):
		if not (t is Dictionary): continue
		var lb = Label.new(); lb.mouse_filter = Control.MOUSE_FILTER_IGNORE
		var tx = str(DB.L(str(t.get("t", ""))))
		lb.text = tx
		lb.add_theme_color_override("font_color", Color(str(t.get("c", "#3a2a1a"))))
		lb.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		var bw = W * J.num(t.get("w", 0.8))
		if t.has("h"):   # 有框（例如紙箱嘅白色標籤）：字一定要喺框入面，自動縮細、唔自動斷行、上下置中
			var bh = H * J.num(t.get("h"))
			var ls = tx.split("\n"); var mc = 1
			for l in ls: mc = maxi(mc, l.length())
			var fs = mini(int(J.num(t.get("s", 20)) * 2.0), int(minf(bw * 0.92 / mc, bh * 0.9 / (ls.size() * 1.25))))
			lb.add_theme_font_size_override("font_size", fs)
			lb.add_theme_constant_override("line_spacing", int(fs * 0.12))
			lb.autowrap_mode = TextServer.AUTOWRAP_OFF; lb.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
			lb.clip_text = true
			lb.size = Vector2(bw, bh)
			lb.position = Vector2(W * J.num(t.get("x", 0.5)) - bw / 2, H * J.num(t.get("y", 0.2)) - bh / 2)   # 有框時 y＝框中心
		else:
			lb.add_theme_font_size_override("font_size", int(J.num(t.get("s", 20)) * 2.0))
			lb.autowrap_mode = TextServer.AUTOWRAP_ARBITRARY
			lb.size = Vector2(bw, 10)
			lb.position = Vector2(W * J.num(t.get("x", 0.5)) - bw / 2, H * J.num(t.get("y", 0.2)))
		layer.add_child(lb)
	visible = true; modulate.a = 1.0; _off = -1.0; _anim = true
	if not same: _t = 0.0   # 換新圖先重新開機；同一張就唔再閃
	_ensure_blur()
	_place()
	var stg = get_parent().get("stage")   # 插圖出現時，舞台只畫背景、唔畫角色（唔好同插圖入面嘅角色重複）
	if stg != null and is_instance_valid(stg): stg.set("hide_acts", true); stg.queue_redraw()

func _place() -> void:   # 居中：對話場＝對話框以上嘅空間正中；系統窗場＝插圖＋系統窗成組居中（由 story.gd 排）
	var par = get_parent()
	if par == null: return
	if par.get("syswin") != null and is_instance_valid(par.get("syswin")):
		par.call("_sys_layout"); return
	var bot = par.size.y - (182.0 if par.get("talkbox") != null else 0.0)
	offset_top = maxf(8.0, (bot - size.y) / 2.0)

static func _hero_spr() -> String:
	var S = J.G.get("S")
	var h = S.get("hero") if S is Dictionary else null
	return "afuf" if h is Dictionary and str(h.get("sex", "m")) == "f" and Spr.ok("afuf") else "afu"

func hide_cg() -> void:   # 關機：畫面縮返做一條線再熄
	if not visible: _restore(); return
	if _off < 0.0: _off = 0.0
	cur_key = ""

func _restore() -> void:
	visible = false; cur_key = ""; _off = -1.0
	if blur != null and is_instance_valid(blur): blur.visible = false
	var par = get_parent()
	if par != null and par.has_method("_sys_layout"): par.call("_sys_layout")
	var st = get_parent().get("stage")
	if st != null and is_instance_valid(st): st.set("hide_acts", false); st.queue_redraw()

func _process(dt: float) -> void:
	if not visible: return
	_t += dt
	var pw = clampf(_t / 0.55, 0.0, 1.0)
	var amt = clampf(_t / 0.4, 0.0, 1.0)
	if _off >= 0.0:
		_off += dt
		pw = clampf(1.0 - _off / 0.3, 0.0, 1.0)
		amt = minf(amt, pw)
		if _off >= 0.32: _restore(); return
	_tvmat.set_shader_parameter("pw", pw)
	_tvmat.set_shader_parameter("tm", _t)
	if _blmat != null: _blmat.set_shader_parameter("amt", amt)
	var z = 1.0 + minf(_t, 12.0) * 0.004   # 慢慢推近
	pic.scale = Vector2(z, z)
	layer.pivot_offset = layer.size / 2; layer.scale = pic.scale   # 疊圖／疊字跟插圖一齊推近，唔會錯位
