# [perf] 主角深色描邊改用 shader：主角畫入一個 CanvasGroup，群組 shader 喺 6 個偏移位取樣 alpha 做描邊。
#   以前（[herobig]）係同一份主角錄製重播 6 次（偏少少、染黑）＝ 每格多 6 倍主角筆數。
#   偏移、顏色、透明度同舊版一樣（HERO_OL、Color(0.05,0.03,0.04,0.78)），逐層疊嘅計法都照舊，所以外觀一樣。
# 用法（nv_village._sync_dynamic）：主角用 HOL.node(nv, y) 代替 _seg()；每格 HOL.begin(nv) / HOL.end(nv)。
# 熱更新：冇 class_name。
extends RefCounted

static var enabled := true
const OFFS := [Vector2(-1.6, 0), Vector2(1.6, 0), Vector2(0, -1.6), Vector2(0, 1.4), Vector2(-1.1, -1.1), Vector2(1.1, -1.1)]   # 同 nv_village.HERO_OL
const SH := """shader_type canvas_item;
render_mode unshaded;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_linear;
uniform vec2 offs[6];
uniform vec4 ol = vec4(0.05, 0.03, 0.04, 0.78);
void fragment() {
	vec4 c = textureLod(screen_texture, SCREEN_UV, 0.0);
	// 舊版：6 份染黑嘅主角逐份疊（每份 alpha = 主角 alpha × 0.78），最後主角本體疊上面
	vec3 acc = vec3(0.0); float A = 0.0;
	for (int i = 0; i < 6; i++) {
		vec4 s = textureLod(screen_texture, SCREEN_UV - offs[i] * SCREEN_PIXEL_SIZE, 0.0);
		float a = s.a * ol.a;
		vec3 rgb = s.a > 0.0001 ? s.rgb / s.a : vec3(0.0);
		acc = acc * (1.0 - a) + rgb * ol.rgb * a;
		A = A * (1.0 - a) + a;
	}
	vec3 pm = c.rgb + acc * (1.0 - c.a);   // c 已經係預乘
	float fa = c.a + A * (1.0 - c.a);
	COLOR = vec4(fa > 0.0001 ? pm / fa : vec3(0.0), fa);
}"""

static func on() -> bool:
	return enabled and not G.safe_gfx and not G.gfx_bad.has("herool")

static func _grp(nv) -> CanvasGroup:
	var g = nv.get_meta("hol_grp") if nv.has_meta("hol_grp") else null
	if g != null and is_instance_valid(g): return g
	g = CanvasGroup.new(); g.name = "hero_grp"
	g.fit_margin = 14.0; g.clear_margin = 14.0
	var sm = ShaderMaterial.new(); var sh = Shader.new(); sh.code = SH; sm.shader = sh
	g.material = sm
	nv.ysort.add_child(g)
	var n = PtDraw.new(); n.tag = "hero"
	n.set_meta("rec", Recorder.new())
	n.fn = func(c):
		var r: Recorder = n.get_meta("rec")
		r.replay(c, Transform2D(0, Vector2(0, -g.position.y)))
	g.add_child(n)
	g.set_meta("node", n)
	nv.set_meta("hol_grp", g)
	return g

static var _used := false
static func begin(_nv) -> void: _used = false

# 主角今格用嘅畫節點（喺 CanvasGroup 入面；群組位置 y 用嚟 y 排序）
static func node(nv, y: float) -> PtDraw:
	if not on(): return null
	var g = _grp(nv)
	g.position = Vector2(0, y)
	g.visible = true
	var n: PtDraw = g.get_meta("node")
	n.position = Vector2.ZERO; n.visible = true
	# 偏移：世界單位 → 實際螢幕 px
	var vp = nv.world.get_viewport() if nv.world.is_inside_tree() else nv.get_viewport()   # 流暢模式：世界喺 0.75 SubViewport 入面
	var k = float(nv.sc) * (vp.get_final_transform().get_scale().x if vp != null else 1.0)
	var arr = PackedVector2Array()
	for o in OFFS: arr.append(o * k)
	(g.material as ShaderMaterial).set_shader_parameter("offs", arr)
	_used = true
	return n

static func end(nv) -> void:
	if _used: return
	var g = nv.get_meta("hol_grp") if nv.has_meta("hol_grp") else null
	if g != null and is_instance_valid(g) and g.visible: g.visible = false
