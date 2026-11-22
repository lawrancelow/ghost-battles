# [perf] 村子靜態物件烘圖：建築、樹、稻田、擺設、生產鏈建築等「冇變就唔重畫」嘅物件，
#   以前每格都要將幾十筆指令（墨線描邊 8 次、接地排線、名牌字）交俾渲染器（村子畫面一格 2000 幾個 draw call）。
#   而家第一次畫（或者狀態／縮放變咗）先錄低 → 喺 SubViewport 畫一次（UPDATE_ONCE，唔讀返 CPU）→ 之後每格只畫一張圖。
#   畫法完全一樣（同一個 Art 函數），只係多咗一層貼圖；解像度跟住畫面實際 px（縮放變大會重烘），唔會矇。
# 用法（nv_village）：_draw_static 開頭 `if NB.draw(self, c, key, s): return`；_process 尾 `NB.frame(self)`。
# 熱更新：冇 class_name；nv_village 用 preload。
extends RefCounted

static var enabled := true          # 總開關（測試／出事可以熄）
static var budget := 6              # 每格最多烘幾件（避免縮放時一格烘晒全部）
static var _used := 0
static var _probe_done := false
static var _mat: CanvasItemMaterial = null
static var stats := {"bake": 0, "hit": 0}
const K_MAX := 4.0                  # 每世界單位最多幾 px
const TEX_MAX := 2048
const PAD := 3.0

static func mat() -> CanvasItemMaterial:
	if _mat == null:
		_mat = CanvasItemMaterial.new(); _mat.blend_mode = CanvasItemMaterial.BLEND_MODE_PREMULT_ALPHA   # SubViewport 入面疊出嚟嘅係預乘 alpha
	return _mat

static func ok() -> bool:
	return enabled and not G.safe_gfx and not G.gfx_bad.has("bake") and not G.gfx_bad.has("nvbake")   # 安全畫面模式／烘圖閃退過：逐格畫

# 而家每世界單位等於幾多實際螢幕 px
static func px_k(nv) -> float:
	var vp = nv.world.get_viewport() if nv.world != null and nv.world.is_inside_tree() else nv.get_viewport()   # 流暢模式：世界喺 0.75 SubViewport 入面
	var fs = vp.get_final_transform().get_scale().x if vp != null else 1.0
	return clampf(float(nv.sc) * fs, 0.25, K_MAX)
static func _quant(k: float) -> float: return minf(K_MAX, snappedf(k, 1.0 / 64.0))
# 縮放緊（兩指／滾輪）嗰陣唔重烘，用舊圖放大縮細；停咗 0.25 秒先按新解像度重烘
static var _k_last := 0.0
static var _k_still := 0.0
static func _k_stable() -> bool: return _k_still >= 0.25

# 畫一件靜態物件：用烘好嘅圖就回 true（唔使原本畫法）
#   s.live（可選）：會郁嘅部分（例如「可重建」木牌上下浮、生產鏈冒煙），每格照畫喺貼圖上面
static func draw(nv, c: CanvasItem, key: String, s: Dictionary) -> bool:
	var live: Callable = s.get("live", Callable())
	if not ok() or (bool(s.get("anim", false)) and not live.is_valid()):
		_unbake(c, s); return false
	var k = _quant(px_k(nv))
	var b = s.get("bk")
	var kfresh = b != null and (absf(b.k - k) < 0.004 or not _k_stable())
	var fresh = b != null and b.sig_ver == s.get("ver", 0) and kfresh and b.map == nv._st_map and b.zone == nv.zone
	if not fresh:
		if _used >= budget:   # 今格烘夠喇：照舊畫法，之後 frame() 再叫重畫
			_unbake(c, s); return false
		_used += 1
		b = _bake(nv, key, s, k, b)
		if b == null:
			s["bk_fail"] = s.get("ver", 0)
			if s.has("bk"): s.bk.vp.queue_free(); s.erase("bk")
			_unbake(c, s); return false
		s["bk"] = b
		# SubViewport 今格先畫：今格照舊畫法，兩格後先轉用貼圖（唔會閃一格空白）
		_unbake(c, s)
		return false
	if b.wait > 0: _unbake(c, s); return false
	var tn = _tex_node(c)
	var r: Rect2 = b.rect
	var dr = Rect2(r.position - Vector2(0, c.position.y), b.size / b.k)
	if not tn.visible or tn.get_meta("vp") != b.vp or tn.get_meta("r") != dr:
		tn.set_meta("vp", b.vp); tn.set_meta("r", dr); tn.visible = true; tn.queue_redraw()
	if live.is_valid():   # 會郁嘅部分：照原本畫法畫喺貼圖上面
		var ctx = Ctx.new(c, Transform2D(0, Vector2(0, -c.position.y)))
		var iw = Art.ink_w
		Art.ink_w = 0.85 if nv.zone else 0.0
		live.call(ctx)
		Art.ink_w = iw
	stats.hit += 1
	return true

# 貼圖用一個子節點畫（預乘 alpha 材質只影響貼圖，唔影響上面會郁嘅部分）；show_behind_parent：喺父節點嘅筆之下
static func _tex_node(c: CanvasItem) -> Node2D:
	var tn = c.get_node_or_null("bk")
	if tn != null: return tn
	tn = Node2D.new(); tn.name = "bk"; tn.show_behind_parent = true; tn.material = mat(); tn.visible = false
	tn.set_meta("vp", null); tn.set_meta("r", Rect2())
	tn.draw.connect(func():
		var vp = tn.get_meta("vp")
		if vp == null or not is_instance_valid(vp): return
		var r: Rect2 = tn.get_meta("r")
		# 對齊實際螢幕 px：貼圖一個 texel 啱啱對一個 px，唔會因為半格偏移而矇
		var xf = tn.get_viewport().get_final_transform() * tn.get_global_transform_with_canvas()
		var sp = xf * r.position
		var sx = xf.x.x
		if absf(sx) > 0.001 and absf(xf.y.x) < 0.0001 and absf(xf.x.y) < 0.0001: r.position -= (sp - sp.round()) / sx
		tn.draw_texture_rect(vp.get_texture(), r, false))
	c.add_child(tn)
	return tn

static func _unbake(c: CanvasItem, _s: Dictionary) -> void:
	var tn = c.get_node_or_null("bk")
	if tn != null and tn.visible: tn.visible = false

static func _bake(nv, key: String, s: Dictionary, k: float, b):
	var rec = Recorder.new()
	var ctx = Ctx.new(rec)
	var iw = Art.ink_w
	Art.ink_w = 0.85 if nv.zone else 0.0   # 同 nv_village._draw_static 一樣
	s.fn.call(ctx)
	Art.ink_w = iw
	var r = bounds(rec)
	if r.size.x <= 0.0 or r.size.y <= 0.0: return null
	r = r.grow(PAD)
	var sz = Vector2i(int(ceil(r.size.x * k)) + 2, int(ceil(r.size.y * k)) + 2)
	if sz.x > TEX_MAX or sz.y > TEX_MAX: return null
	var vp: SubViewport
	var nd: Node2D
	if b != null and is_instance_valid(b.vp): vp = b.vp; nd = b.node
	else:
		if not _probe_done:   # 第一次烘：留閃退記號（probe:nvbake），0.5 秒後還原；閃退咗下次 G.gfx_bad 有 nvbake → 自動逐格畫
			_probe_done = true
			var prev = G.crumb_now(); G.crumb("probe:nvbake")
			nv.get_tree().create_timer(0.5).timeout.connect(func(): if G.crumb_now() == "probe:nvbake": G.crumb(prev))
		vp = SubViewport.new(); vp.transparent_bg = true; vp.disable_3d = true
		vp.canvas_item_default_texture_filter = Viewport.DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_LINEAR
		nd = Node2D.new(); vp.add_child(nd)
		nd.draw.connect(func():
			var rr: Recorder = nd.get_meta("rec") if nd.has_meta("rec") else null
			if rr != null: rr.replay(nd, nd.get_meta("M")))
		_holder(nv).add_child(vp)
	if vp.size != sz: vp.size = sz
	nd.set_meta("rec", rec)
	nd.set_meta("M", Transform2D(0.0, Vector2(k, k), 0.0, -r.position * k))
	nd.queue_redraw()
	vp.render_target_clear_mode = SubViewport.CLEAR_MODE_ONCE
	vp.render_target_update_mode = SubViewport.UPDATE_ONCE
	stats.bake += 1
	return {"vp": vp, "node": nd, "rect": r, "size": Vector2(sz), "k": k, "sig_ver": s.get("ver", 0), "map": nv._st_map, "zone": nv.zone, "wait": 2}

static func _holder(nv) -> Node:
	var h = nv.get_node_or_null("perf_bake")
	if h == null: h = Node.new(); h.name = "perf_bake"; nv.add_child(h)
	return h

# 每格：烘好嘅轉用貼圖；縮放變咗嘅重烘；冇用嘅放返記憶體
static func frame(nv) -> void:
	_used = 0
	if not ok(): return
	var k = _quant(px_k(nv))
	if absf(k - _k_last) > 0.0001: _k_last = k; _k_still = 0.0
	else: _k_still += nv.get_process_delta_time()
	var req = 0
	for key in nv.statics:
		var s = nv.statics[key]
		var b = s.get("bk")
		var n: PtDraw = s.node
		if b != null and not n.visible and int(s.get("bk_idle", 0)) > 600:   # 收埋咗十秒：放返 SubViewport
			b.vp.queue_free(); s.erase("bk"); s["bk_idle"] = 0; continue
		if b != null and not n.visible: s["bk_idle"] = int(s.get("bk_idle", 0)) + 1
		else: s["bk_idle"] = 0
		if b != null and b.wait == 0 and n.visible:   # 鏡頭郁：重新對齊螢幕 px（只係一筆貼圖）
			var tn = n.get_node_or_null("bk")
			if tn != null and tn.visible: tn.queue_redraw()
		if b != null and b.wait > 0:
			b.wait -= 1
			if b.wait == 0: n.queue_redraw()   # SubViewport 已經畫好：轉用貼圖
			continue
		if (bool(s.get("anim", false)) and not s.get("live", Callable()).is_valid()) or not n.visible or req >= budget: continue
		if b == null:   # 未烘（或者上次超出預算）：叫佢重畫一次，_draw_static 會烘
			if s.get("bk_fail", -1) != s.get("ver", 0): n.queue_redraw(); req += 1
		elif (absf(b.k - k) >= 0.004 and _k_stable()) or b.sig_ver != s.get("ver", 0) or b.map != nv._st_map: n.queue_redraw(); req += 1   # 縮放停咗／狀態變咗：重烘

# ---------------- 錄製指令嘅外框（世界座標） ----------------
static func bounds(rec: Recorder, M := Transform2D.IDENTITY, depth := 0) -> Rect2:
	var out := Rect2(); var have := false
	var cur := Transform2D.IDENTITY
	var T := M
	for c in rec.cmds:
		var r := Rect2(); var ok2 := true
		match int(c[0]):
			0: cur = c[1]; T = M * cur; continue
			1:
				var p: PackedVector2Array = c[1]
				if p.is_empty(): continue
				r = _pts(T, p).grow(float(c[3]) * 0.5 * _sx(T) + 1.0)
			2: r = _pts(T, PackedVector2Array([c[1], c[2]])).grow(float(c[4]) * 0.5 * _sx(T) + 1.0)
			3: r = _rect(T, Rect2(c[1] - Vector2(c[2], c[2]), Vector2(c[2], c[2]) * 2.0)).grow(1.0)
			4:
				var p4: PackedVector2Array = c[1]
				if p4.is_empty(): continue
				r = _pts(T, p4).grow(1.0)
			5: r = _rect(T, c[2])
			6: r = _rect(T, c[2])
			7, 8:
				var f: Font = c[1]; var sz: int = int(c[4]); var s: String = c[3]
				if f == null or s == "": continue
				var w = f.get_string_size(s, HORIZONTAL_ALIGNMENT_LEFT, -1, sz).x
				var asc = f.get_ascent(sz); var dsc = f.get_descent(sz)
				var ow = float(c[5]) if int(c[0]) == 8 else 0.0
				r = _rect(T, Rect2(c[2].x - ow, c[2].y - asc - ow, w + ow * 2.0, asc + dsc + ow * 2.0)).grow(1.0)
			9: r = _rect(T, c[1]).grow(1.0)
			10:
				var p10: PackedVector2Array = c[2]
				if p10.is_empty(): continue
				r = _pts(T, p10).grow(1.0)
			11:
				if depth > 6: continue
				var sub: Recorder = c[1]
				if sub.baked != null: r = _rect(T * c[2], Rect2(0, 0, sub.width, sub.height))
				else:
					r = bounds(sub, T * c[2], depth + 1)
					if r.size == Vector2.ZERO: continue
			_: ok2 = false
		if not ok2: continue
		if have: out = out.merge(r)
		else: out = r; have = true
	return out
static func _sx(T: Transform2D) -> float: return maxf(T.x.length(), T.y.length())
static func _pts(T: Transform2D, p: PackedVector2Array) -> Rect2:
	var a = T * p[0]; var r = Rect2(a, Vector2.ZERO)
	for i in range(1, p.size()): r = r.expand(T * p[i])
	return r
static func _rect(T: Transform2D, r: Rect2) -> Rect2:
	return _pts(T, PackedVector2Array([r.position, Vector2(r.end.x, r.position.y), r.end, Vector2(r.position.x, r.end.y)]))
