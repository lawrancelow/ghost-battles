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

const CGM = preload("res://ui/cg_motion.gd")   # [cgm] 分層動態插圖
var mot = null   # [cgm] 當前動態插圖實例（冇分層素材＝null，用靜態圖）

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
var _psz := Vector2.ZERO   # [wide] 上次排版時父節點大細（視窗改大細／轉向就重排）
var _spec = null

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	anchor_left = 0.5; anchor_right = 0.5; anchor_top = 0.0; anchor_bottom = 0.0
	offset_top = 56
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
	var k = str(d.get("k", "")); var used_kf = false
	# [opening] 女主版插圖：kf（有圖先用，冇就用男女共用嗰張）；rv＝待審標記（插圖右下角貼「待審」，老闆選定後刪走）
	if str(d.get("kf", "")) != "" and (Spr.ok(str(d.kf)) or CGM.known(str(d.kf))):
		var HS = J.G.get("S"); var hh0 = HS.get("hero") if HS is Dictionary else null
		if hh0 is Dictionary and str(hh0.get("sex", "m")) == "f": k = str(d.kf); used_kf = true
	# [opening] 上線規矩：圖未到／未經老闆選定（rv、cg_review.json）→ 呢句唔顯示插圖（只有對話），唔用佔位圖、唔出「待審」。
	#   審圖截圖先設 GB_RV_SHOW=1：未到用佔位圖（ph）、未選定照顯示並貼「待審」。
	var rv_show = OS.get_environment("GB_RV_SHOW") == "1"
	var pending = (str(d.get("rv", "")) != "" and not used_kf) or review_pending(k)
	var have = k != "" and (Spr.ok(k) or CGM.known(k))   # [cgm] 分層／後備動態素材都算有圖
	if not rv_show and (pending or not have): hide_cg(); return
	if not have and str(d.get("ph", "")) != "": k = str(d.ph)
	if k == "" or (not Spr.ok(k) and not CGM.known(k)):
		hide_cg(); return
	var tex: Texture2D = CGM.bg(k) if (CGM.has(k) and not (d.get("anim") is bool and not d.anim)) else null   # [cgm] 有分層素材：用挖走角色嘅底圖
	var layered = tex != null
	if tex == null and CGM.known(k): tex = CGM.still(k)   # [cgm] 關動態：用原整張圖（有就用）
	if tex == null: tex = Spr.get_tex(k) if Spr.ok(k) else null
	if tex == null:
		if mot != null: mot.free_all(); mot = null   # [cgm] 收起時唔再郁
		hide_cg(); return
	if not layered and mot != null: mot.free_all(); mot = null
	var same = visible and cur_key == k and _off < 0.0
	cur_key = k
	# [wide] 框跟插圖長寬比：先盡量佔滿闊度；高度超過可用空間（對話框／系統窗以上）就按比例縮細、左右置中。原圖唔裁。
	var psz: Vector2 = get_parent().size
	_psz = psz; _spec = d
	var ar = float(tex.get_height()) / float(tex.get_width())
	var ws = maxf(160.0, psz.x - 20.0 - B * 2)
	var hs = ws * ar
	var ah = maxf(120.0, _avail_h(psz) - B * 2)
	if hs > ah: hs = ah; ws = hs / ar
	var W = ws + B * 2; var H = hs + B * 2
	anchor_left = 0.5; anchor_right = 0.5
	custom_minimum_size = Vector2(W, H)   # 先改最細尺寸再改 size（調轉會俾上一張圖嘅最細尺寸撐住，直圖之後嘅橫圖會變高、被裁）
	offset_left = -W / 2.0; offset_right = W / 2.0
	size = Vector2(W, H)
	frame.position = Vector2.ZERO; frame.size = size
	screen.position = Vector2(B, B); screen.size = size - Vector2(B, B) * 2
	tv.position = Vector2.ZERO; tv.size = screen.size
	var vs = Vector2i(int(screen.size.x * 2.0), int(screen.size.y * 2.0))   # 2 倍解像度畫入去，縮細出嚟夠清
	vp.size = vs
	pic.texture = tex; pic.position = Vector2.ZERO; pic.size = Vector2(vs); pic.pivot_offset = pic.size / 2
	layer.position = Vector2.ZERO; layer.size = Vector2(vs)
	var keep_t = mot.t if (same and mot != null) else 0.0   # [cgm] 同一張圖換行：動作接住播，唔重頭
	if mot != null: mot.free_all(); mot = null
	if layered:
		mot = CGM.make(k, vp, Vector2(vs), tex)
		if mot != null:
			mot.t = keep_t
			vp.move_child(mot.root, layer.get_index())   # 底圖之上、疊人／疊字之下
	W = layer.size.x; H = layer.size.y
	for c in layer.get_children(): layer.remove_child(c); c.queue_free()   # 即刻移走：新一張嘅疊圖／牌匾節點名唔會同舊嘅撞
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
	_plaques(k, d, tex, W, H)
	if pending and str(d.get("rv", "")) == "": d = d.duplicate(); d["rv"] = "待審"; used_kf = false   # 素材本身未選定（data/cg_review.json）
	if str(d.get("rv", "")) != "" and not used_kf:   # 女主版（kf）老闆已全部選用，唔貼；[opening] 老闆未選定嘅圖：右下角貼「待審」；選定後喺 story_v2.json 刪走 rv
		var rb = Label.new(); rb.name = "RvBadge"; rb.mouse_filter = Control.MOUSE_FILTER_IGNORE; rb.text = str(d.rv)
		rb.add_theme_font_size_override("font_size", 34); rb.add_theme_color_override("font_color", Color("#fff4d8"))
		var rs = StyleBoxFlat.new(); rs.bg_color = Color("#c8322a"); rs.set_corner_radius_all(8)
		rs.content_margin_left = 14; rs.content_margin_right = 14; rs.content_margin_top = 4; rs.content_margin_bottom = 4
		rb.add_theme_stylebox_override("normal", rs)
		layer.add_child(rb); rb.reset_size(); rb.position = Vector2(W - rb.get_minimum_size().x - 16, H - rb.get_minimum_size().y - 14)   # 右下角：唔遮牌匾
	visible = true; modulate.a = 1.0; _off = -1.0; _anim = true
	if not same: _t = 0.0   # 換新圖先重新開機；同一張就唔再閃
	_ensure_blur()
	_place()
	var stg = get_parent().get("stage")   # 插圖出現時，舞台只畫背景、唔畫角色（唔好同插圖入面嘅角色重複）
	if stg != null and is_instance_valid(stg): stg.set("hide_acts", true); stg.queue_redraw()

func _avail_h(psz: Vector2) -> float:   # 插圖卡可以用嘅高度：唔好遮對話框；系統窗場要留位畀系統窗
	var par = get_parent()
	if par.get("syswin") != null and is_instance_valid(par.get("syswin")):
		return maxf(psz.y * 0.3, psz.y - 16.0 - 12.0 - J.num(par.get("_sys_want")))
	if par.get("talkbox") != null: return psz.y - 182.0 - 16.0
	return psz.y - 16.0

func _place() -> void:   # 居中：對話場＝對話框以上嘅空間正中；系統窗場＝插圖＋系統窗成組居中（由 story.gd 排）
	var par = get_parent()
	if par == null: return
	if par.get("syswin") != null and is_instance_valid(par.get("syswin")):
		par.call("_sys_layout"); return
	var bot = par.size.y - (182.0 if par.get("talkbox") != null else 0.0)
	set_top(maxf(8.0, (bot - custom_minimum_size.y) / 2.0))

func set_top(v: float) -> void:   # [wide] 上下一齊郁（淨改 offset_top 會連高度都變，卡同框尺寸唔一致、撐落對話框）
	offset_top = v; offset_bottom = v + custom_minimum_size.y

static func _hero_spr() -> String:
	var S = J.G.get("S")
	var h = S.get("hero") if S is Dictionary else null
	return "afuf" if h is Dictionary and str(h.get("sex", "m")) == "f" and Spr.ok("afuf") else "afu"

func hide_cg() -> void:   # 關機：畫面縮返做一條線再熄
	if not visible: _restore(); return
	if _off < 0.0: _off = 0.0
	cur_key = ""

func _restore() -> void:
	visible = false; cur_key = ""; _off = -1.0; _spec = null
	if mot != null: mot.free_all(); mot = null
	if blur != null and is_instance_valid(blur): blur.visible = false
	var par = get_parent()
	if par != null and par.has_method("_sys_layout"): par.call("_sys_layout")
	var st = get_parent().get("stage")
	if st != null and is_instance_valid(st): st.set("hide_acts", false); st.queue_redraw()

func _process(dt: float) -> void:
	if not visible: return
	if _off < 0.0 and _spec != null and get_parent() != null and (get_parent().size - _psz).length() > 1.0:
		show_spec(_spec)   # [wide] 視窗改咗大細：按新尺寸重排（同一張圖，動作接住播）
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
	if mot != null:   # [cgm] 分層動態：慢推鏡＋視差＋每層動作由 cg_motion 計
		var cz = mot.tick(dt)
		pic.pivot_offset = pic.size / 2; pic.scale = Vector2(cz[0], cz[0]); pic.position = cz[1]
		layer.pivot_offset = layer.size / 2; layer.scale = pic.scale; layer.position = cz[1]
		return
	var z = 1.0 + minf(_t, 12.0) * 0.004   # 慢慢推近
	pic.scale = Vector2(z, z)
	layer.pivot_offset = layer.size / 2; layer.scale = pic.scale   # 疊圖／疊字跟插圖一齊推近，唔會錯位


# ---------------- [plaque] 牌匾疊字：插圖上空白牌匾嘅字由程序貼（四角座標透視貼字，跟插圖一齊推近／移動） ----------------
# 座標：data/cg_plaque.json → {"<插圖鍵>": [{"size":[原圖闊,高], "quad":[[左上],[右上],[右下],[左下]], "text":"…", "color":"#5a2a1c", "vertical":false}]}
#   quad 可以係原圖像素（配 size）或者 0–1 比例。場景 cg 可以用 "plaque": {"t": "字"} 或 ["第一塊字", "第二塊字"] 覆蓋文字；"plaque": false＝唔貼。
static var _rv_keys = null
static func review_pending(k: String) -> bool:   # data/cg_review.json 嘅 pending：未經老闆選定嘅插圖鍵
	if _rv_keys == null:
		_rv_keys = []
		if FileAccess.file_exists("res://data/cg_review.json"):
			var j = JSON.parse_string(FileAccess.get_file_as_string("res://data/cg_review.json"))
			if j is Dictionary and j.get("pending") is Array: _rv_keys = j.pending
	return (_rv_keys as Array).has(k)
static var _pl_data = null
static func plaque_data() -> Dictionary:
	if _pl_data == null:
		_pl_data = {}
		if FileAccess.file_exists("res://data/cg_plaque.json"):
			var j = JSON.parse_string(FileAccess.get_file_as_string("res://data/cg_plaque.json"))
			if j is Dictionary: _pl_data = j
	return _pl_data

# 0–1 方格 → 四邊形嘅透視變換（Heckbert）；回傳 [a,b,c,d,e,f,g,h]
static func homography(q: Array) -> Array:
	var p0: Vector2 = q[0]; var p1: Vector2 = q[1]; var p2: Vector2 = q[2]; var p3: Vector2 = q[3]
	var sx = p0.x - p1.x + p2.x - p3.x; var sy = p0.y - p1.y + p2.y - p3.y
	if absf(sx) < 0.0001 and absf(sy) < 0.0001: return [p1.x - p0.x, p3.x - p0.x, p0.x, p1.y - p0.y, p3.y - p0.y, p0.y, 0.0, 0.0]
	var dx1 = p1.x - p2.x; var dx2 = p3.x - p2.x; var dy1 = p1.y - p2.y; var dy2 = p3.y - p2.y
	var den = dx1 * dy2 - dx2 * dy1
	if absf(den) < 0.000001: return [p1.x - p0.x, p3.x - p0.x, p0.x, p1.y - p0.y, p3.y - p0.y, p0.y, 0.0, 0.0]
	var g = (sx * dy2 - dx2 * sy) / den; var h = (dx1 * sy - sx * dy1) / den
	return [p1.x - p0.x + g * p1.x, p3.x - p0.x + h * p3.x, p0.x, p1.y - p0.y + g * p1.y, p3.y - p0.y + h * p3.y, p0.y, g, h]
static func hmap(m: Array, u: float, v: float) -> Vector2:
	var w = m[6] * u + m[7] * v + 1.0
	return Vector2((m[0] * u + m[1] * v + m[2]) / w, (m[3] * u + m[4] * v + m[5]) / w)

# 原圖比例座標 → layer 座標（插圖係「鋪滿、置中裁切」）
static func img_to_layer(uv: Vector2, tex_size: Vector2, W: float, H: float) -> Vector2:
	var sc = maxf(W / tex_size.x, H / tex_size.y)
	var o = (Vector2(W, H) - tex_size * sc) / 2.0
	return o + uv * tex_size * sc

func _plaques(k: String, d: Dictionary, tex: Texture2D, W: float, H: float) -> void:
	var ov = d.get("plaque")
	if ov is bool and not ov: return
	var arr = plaque_data().get(k)
	if not (arr is Array): return
	var ts = Vector2(tex.get_width(), tex.get_height())
	for i in arr.size():
		var e = arr[i]
		if not (e is Dictionary) or not (e.get("quad") is Array) or (e.quad as Array).size() != 4: continue
		var text = str(e.get("text", ""))
		if ov is Dictionary and ov.has("t"): text = str(ov.t)
		elif ov is Array and i < ov.size(): text = str(ov[i])
		elif ov is String: text = ov
		text = str(DB.L(text))
		if text.strip_edges() == "": continue
		var sz = e.get("size")
		var q: Array = []
		for p in e.quad:
			var v = Vector2(J.num(p[0]), J.num(p[1]))
			if sz is Array and sz.size() == 2: v = v / Vector2(J.num(sz[0]), J.num(sz[1]))
			q.append(img_to_layer(v, ts, W, H))
		layer.add_child(_plaque_node(text, q, Color(str(e.get("color", "#5a2a1c"))), J.t(e.get("vertical")), i, str(e.get("style", ""))))

# 便條斷行：逐字量闊度，每行唔超過 maxw；行首唔放收尾標點（將上一行最後一個字一齊帶落嚟）
static func note_wrap(text: String, f: Font, fs: int, maxw: float) -> Array:
	var out: Array = []; var cur = ""
	var NOHEAD = "，。：；、！？」』）…"
	for ch in text.split(""):
		if ch == "\n": out.append(cur); cur = ""; continue
		if cur != "" and f.get_string_size(cur + ch, HORIZONTAL_ALIGNMENT_LEFT, -1, fs).x > maxw:
			if NOHEAD.contains(ch) and cur.length() > 1:
				var kk = cur.length() - 1
				while kk > 0 and NOHEAD.contains(cur[kk]): kk -= 1   # 連續收尾標點（例如 』。）成串帶落嚟，行首一定係字
				out.append(cur.substr(0, kk)); cur = cur.substr(kk) + ch
			else:
				out.append(cur); cur = ch
		else: cur += ch
	if cur != "": out.append(cur)
	return out

func _plaque_node(text: String, q: Array, col: Color, vertical: bool, idx: int, style := "") -> Node2D:
	var wtop = (q[1] - q[0]).length(); var wbot = (q[2] - q[3]).length(); var hl = (q[3] - q[0]).length(); var hr = (q[2] - q[1]).length()
	var qw = maxf(8.0, (wtop + wbot) / 2.0); var qh = maxf(8.0, (hl + hr) / 2.0)
	var TW = 768; var TH = maxi(48, int(768.0 * qh / qw))
	var sv = SubViewport.new(); sv.transparent_bg = true; sv.size = Vector2i(TW, TH); sv.render_target_update_mode = SubViewport.UPDATE_ONCE; sv.disable_3d = true
	if style == "note": text = text.trim_prefix("「").trim_suffix("」")
	var lb = Label.new(); lb.text = "\n".join(text.split("")) if vertical else text
	var n = maxi(1, text.length())
	var fs = int(minf(TH * 0.66, TW * 0.9 / n)) if not vertical else int(minf(TW * 0.66, TH * 0.9 / n))
	var note_lines: Array = []
	if style == "note":   # 便條：多行，自己逐字量闊度斷行（唔靠 Label 自動斷行），字盡量大但成段要喺紙面內
		var nf: Font = UIKit.font("serif", 700)
		var aw = TW * 0.86; var ah = TH * 0.88
		fs = int(sqrt(aw * ah / (n * 1.3)))
		while fs > 10:
			note_lines = note_wrap(text, nf, fs, aw)
			if note_lines.size() * (nf.get_height(fs) + int(fs * 0.12)) <= ah: break   # 用字體真行高（宋體行高約 1.45 倍字號），唔好估
			fs -= 1
	if style == "emboss": fs = int(minf(TH * 0.8, TW * 0.98 / n))   # 金匾浮雕字：盡量填滿匾面空位
	lb.add_theme_font_override("font", UIKit.font("serif", 900)); lb.add_theme_font_size_override("font_size", maxi(10, fs))
	lb.add_theme_color_override("font_color", col)
	lb.add_theme_color_override("font_outline_color", Color(1.0, 0.93, 0.8, 0.35)); lb.add_theme_constant_override("outline_size", maxi(2, fs / 14))   # 淡淡亮邊，似刻喺匾面
	lb.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; lb.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	lb.position = Vector2.ZERO; lb.size = Vector2(TW, TH); lb.clip_text = true
	if style == "note":
		lb.text = "\n".join(note_lines)
		lb.clip_text = false; lb.autowrap_mode = TextServer.AUTOWRAP_OFF; lb.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		lb.add_theme_font_override("font", UIKit.font("serif", 700)); lb.add_theme_constant_override("outline_size", 0); lb.add_theme_constant_override("line_spacing", int(fs * 0.12))
		lb.position = Vector2(TW * 0.07, TH * 0.06); lb.size = Vector2(TW * 0.86, TH * 0.88)
	if style == "emboss":   # 金匾浮雕字：下層深色內陰影（偏右下）＋亮色高光（偏左上）＋面層金色，似刻出嚟
		var off = maxf(2.0, fs / 22.0)
		lb.remove_theme_color_override("font_outline_color"); lb.add_theme_constant_override("outline_size", 0)
		var sh = lb.duplicate(); sh.name = "EmbossShadow"; sh.add_theme_color_override("font_color", Color(0.22, 0.1, 0.02, 0.85)); sh.position = Vector2(off, off)
		var hi = lb.duplicate(); hi.name = "EmbossHi"; hi.add_theme_color_override("font_color", Color(1.0, 0.96, 0.75, 0.95)); hi.position = Vector2(-off * 0.7, -off * 0.7)
		lb.add_theme_color_override("font_outline_color", col.darkened(0.45)); lb.add_theme_constant_override("outline_size", maxi(1, int(off * 0.6)))
		sv.add_child(sh); sv.add_child(hi)
	sv.add_child(lb)
	var pg = Polygon2D.new(); pg.name = "Plaque%d" % idx; pg.add_child(sv)
	pg.texture = sv.get_texture(); pg.modulate = Color(1, 1, 1, 0.9)
	pg.set_meta("text", text); pg.set_meta("quad", q); pg.set_meta("lines", note_lines); pg.set_meta("tex_w", TW); pg.set_meta("tex_h", TH); pg.set_meta("font_size", fs); pg.set_meta("style", style); pg.set_meta("layers", sv.get_child_count())
	if style == "emboss": pg.modulate = Color(1, 1, 1, 1)
	var NX = 12; var NY = 6; var m = homography(q)
	var pts := PackedVector2Array(); var uvs := PackedVector2Array(); var polys: Array = []
	for y in NY + 1:
		for x in NX + 1:
			var u = float(x) / NX; var v = float(y) / NY
			pts.append(hmap(m, u, v)); uvs.append(Vector2(u * TW, v * TH))
	for y in NY:
		for x in NX:
			var a = y * (NX + 1) + x
			polys.append(PackedInt32Array([a, a + 1, a + NX + 2, a + NX + 1]))
	pg.polygon = pts; pg.uv = uvs; pg.polygons = polys
	return pg
