# [perf] 大排檔（MvScene）畫布烘圖：檔台名牌、HUD 等「好少變」嘅部分，錄低 → 內容冇變就用烘好嘅圖（一筆），變咗先重烘。
#   點知變冇變：每格照錄一次（CPU 好平），將錄到嘅指令 hash 比較；唔使逐個列出狀態。
#   成日變（例如有閃動）嘅內容：短時間內重烘太多次 → 自動轉返逐格畫一陣，唔會越烘越慢。
#   烘圖喺 SubViewport 入面經 CanvasGroup 還原成「非預乘 alpha」，可以直接喺大排檔畫布原位（保持 y 排序）畫，外觀同逐格畫一樣。
#   安全畫面模式、或者呢部機烘圖閃退過（G.gfx_bad 有 bake／mvbake）：一律逐格畫。第一次烘圖會留閃退記號（probe:mvbake），閃退咗下次自動避開。
# 熱更新：冇 class_name；const MB = preload("res://game/outpost/mv_bake.gd")
extends RefCounted

static var enabled := true
static var budget := 3            # 每格最多烘幾張
static var _used := 0
static var _frame := -1
static var stats := {"bake": 0, "hit": 0, "live": 0}
static var _probe_done := false
const K_MAX := 4.0
const K_MIN := 0.8
const TEX_MAX := 2048
const PAD := 3.0
const SH := """shader_type canvas_item;
render_mode unshaded, blend_premul_alpha;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
void fragment() {
	vec4 c = textureLod(screen_texture, SCREEN_UV, 0.0);
	if (c.a > 0.0001) c.rgb /= c.a;
	COLOR = c;   // 預乘混合寫入清空咗嘅透明底 → 存低非預乘顏色
}"""
static var _sh: Shader = null

static func ok() -> bool:
	return enabled and not G.safe_gfx and not G.gfx_bad.has("bake") and not G.gfx_bad.has("mvbake")

# 畫一件：owner＝MvScene（記住烘圖）；ctx＝大排檔畫布 Ctx（有鏡頭變換）；fn(c: Ctx) 照原本畫法畫
static func draw(owner: Node, ctx: Ctx, key: String, fn: Callable) -> void:
	if not ok() or ctx.globalAlpha < 0.999:
		fn.call(ctx); return
	var f = Engine.get_process_frames()
	if f != _frame: _frame = f; _used = 0
	var cache: Dictionary = owner.get_meta("mvbake") if owner.has_meta("mvbake") else {}
	if cache.is_empty(): owner.set_meta("mvbake", cache)
	var rec = Recorder.new()
	var rc = Ctx.new(rec)
	fn.call(rc)
	var e = cache.get(key)
	if e == null: e = {"h": 0, "k": 0.0, "vp": null, "wait": 0, "n": 0, "t0": 0.0, "live_until": 0.0, "f": f}; cache[key] = e
	e.f = f
	var now = Time.get_ticks_msec() / 1000.0
	var xf = owner.get_viewport().get_final_transform() * ctx.ci.get_global_transform_with_canvas() * ctx.T
	var k = minf(K_MAX, snappedf(maxf(xf.x.length(), 0.01), 1.0 / 64.0))
	if k < K_MIN:   # [int] 鏡頭拉遠（k 細過 0.8）時烘出嚟嘅圖會變成成塊實心黑（整合版實測 k=0.5、0.64 都中，0.86 正常）；遠景名牌好細、逐格畫好平，直接逐格畫
		_live(ctx, rec); return
	var h = hash(rec.cmds)
	if rec.cmds.is_empty(): return
	if now < float(e.live_until):
		_live(ctx, rec); return
	var fresh = e.vp != null and int(e.h) == h and absf(float(e.k) - k) < 0.004
	if not fresh:
		# 重烘太密（2 秒內第 5 次）：呢件係會郁嘅內容，逐格畫 3 秒
		if now - float(e.t0) > 2.0: e.t0 = now; e.n = 0
		e.n = int(e.n) + 1
		if int(e.n) > 4:   # 連續成日變：逐格畫嘅時間越拉越長（3→6→12→最多 30 秒）
			e.lv = mini(int(e.get("lv", 0)) + 1, 4); e.live_until = now + minf(30.0, 3.0 * pow(2.0, e.lv - 1)); e.n = 0; _live(ctx, rec); return
		if _used >= budget: _live(ctx, rec); return
		_used += 1
		if not _bake(owner, e, rec, k): e.live_until = now + 3.0; _live(ctx, rec); return
		e.h = h; e.k = k; e.wait = 2
		if int(e.n) <= 1 and e.has("lv"): e.lv = 0   # 穩定返：唔再罰
	if int(e.wait) > 0:
		e.wait = int(e.wait) - 1; _live(ctx, rec); return
	# 用烘好嘅圖：對齊實際螢幕 px
	var r: Rect2 = e.rect
	var dr = Rect2(r.position, e.size / float(e.k))
	var sp = xf * dr.position
	var sx = xf.x.x
	if absf(sx) > 0.001 and absf(xf.y.x) < 0.0001 and absf(xf.x.y) < 0.0001: dr.position -= (sp - sp.round()) / sx
	ctx.ci.draw_set_transform_matrix(ctx.T)
	ctx.ci.draw_texture_rect(e.vp.get_texture(), dr, false)
	ctx.ci.draw_set_transform_matrix(Transform2D.IDENTITY)
	stats.hit += 1

static func _live(ctx: Ctx, rec: Recorder) -> void:
	rec.replay(ctx.ci, ctx.T)
	stats.live += 1

static func _bake(owner: Node, e: Dictionary, rec: Recorder, k: float) -> bool:
	var NB = load("res://ui/nv_bake.gd")
	var r: Rect2 = NB.bounds(rec)
	if r.size.x <= 0.0 or r.size.y <= 0.0: return false
	r = r.grow(PAD)
	var sz = Vector2i(int(ceil(r.size.x * k)) + 2, int(ceil(r.size.y * k)) + 2)
	if sz.x > TEX_MAX or sz.y > TEX_MAX: return false
	var vp: SubViewport = e.vp
	if vp == null or not is_instance_valid(vp):
		if not _probe_done:   # 第一次烘：留閃退記號，兩格後還原（閃退咗下次 G.gfx_bad 會有 mvbake）
			_probe_done = true
			var prev = G.crumb_now(); G.crumb("probe:mvbake")
			owner.get_tree().create_timer(0.5).timeout.connect(func(): if G.crumb_now() == "probe:mvbake": G.crumb(prev))
		if _sh == null: _sh = Shader.new(); _sh.code = SH
		vp = SubViewport.new(); vp.transparent_bg = true; vp.disable_3d = true
		vp.canvas_item_default_texture_filter = Viewport.DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_LINEAR
		var g = CanvasGroup.new(); var sm = ShaderMaterial.new(); sm.shader = _sh; g.material = sm
		g.fit_margin = 0.0; g.clear_margin = 0.0
		vp.add_child(g)
		var nd = Node2D.new(); g.add_child(nd)
		nd.draw.connect(func():
			var rr: Recorder = nd.get_meta("rec") if nd.has_meta("rec") else null
			if rr != null: rr.replay(nd, nd.get_meta("M")))
		vp.set_meta("nd", nd)
		_holder(owner).add_child(vp)
		e.vp = vp
	if vp.size != sz: vp.size = sz
	var nd2: Node2D = vp.get_meta("nd")
	nd2.set_meta("rec", rec)
	nd2.set_meta("M", Transform2D(0.0, Vector2(k, k), 0.0, -r.position * k))
	nd2.queue_redraw()
	vp.render_target_clear_mode = SubViewport.CLEAR_MODE_ONCE
	vp.render_target_update_mode = SubViewport.UPDATE_ONCE
	e.rect = r; e.size = Vector2(sz)
	stats.bake += 1
	return true

static func _holder(owner: Node) -> Node:
	var h = owner.get_node_or_null("perf_mvbake")
	if h == null: h = Node.new(); h.name = "perf_mvbake"; owner.add_child(h)
	return h

# 每格尾（MvScene._draw_stage 之後）：十秒冇用過嘅烘圖放返記憶體
static func gc(owner: Node) -> void:
	if not owner.has_meta("mvbake"): return
	var cache: Dictionary = owner.get_meta("mvbake")
	var f = Engine.get_process_frames()
	if f % 120 != 0: return
	for key in cache.keys():
		var e = cache[key]
		if f - int(e.f) > 600:
			if e.vp != null and is_instance_valid(e.vp): e.vp.queue_free()
			cache.erase(key)
