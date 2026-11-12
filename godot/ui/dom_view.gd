# 把 JS 嘅 DOM（各玩法嘅 HTML 介面）按 style.css 排版並畫出嚟；撳落去轉成 pointer/click 事件
# 支援：block 流、flex（行／列、gap、對齊、grow、wrap）、absolute/fixed、文字自動換行、背景色／漸變／圖、邊框圓角、圖片、<canvas>
extends Control

const SKIP_IDS := {"top": 1, "nav": 1, "stagewrap": 1, "dlg": 1, "title": 1, "banner": 1, "toasts": 1, "village": 1, "quest": 1, "praise": 1}
var boxes: Array = []      # 畫的次序
var vw = 390.0
var vh = 844.0
var _press_box = null
var _press_pos = Vector2.ZERO
var _drag_scroll = null

class Box:
	var zkey: Array = []
	var el: El
	var cs: Dictionary
	var x = 0.0
	var y = 0.0
	var w = 0.0
	var h = 0.0
	var z = 0
	var depth = 0
	var alpha = 1.0
	var kind = "block"     # block / text / img / canvas
	var lines: Array = []   # 文字：[[text, x, y, font, size, color]]
	var xf = Transform2D.IDENTITY
	var clip = null

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

func _process(_dt: float) -> void:
	vw = size.x; vh = size.y
	J.G["__vw"] = vw; J.G["__vh"] = vh
	_layout_all()
	queue_redraw()

func _has_point(p: Vector2) -> bool:
	return _hit(p) != null

# ---------------- 排版 ----------------
func _layout_all() -> void:
	boxes.clear()
	var body: El = JSRun.doc.body
	var root_cs = {"font-size": "15px", "color": "#e9e4f2", "font-family": "sans-serif", "line-height": "1.45"}
	var cb = Rect2(0, 0, vw, vh)
	for c in body.children:
		if not (c is El) or c.tagName == "#TEXT" or SKIP_IDS.has(c.id_): continue
		if c.id_ == "app":
			var app_cs = Css.computed(c, root_cs)
			for k in c.children:
				if k is El and k.tagName != "#TEXT" and not SKIP_IDS.has(k.id_):
					_layout(k, app_cs, cb, cb, 1, 0.0, 0.0, vw, 1.0, Transform2D.IDENTITY)
			continue
		_layout(c, root_cs, cb, cb, 0, 0.0, 0.0, vw, 1.0, Transform2D.IDENTITY)

func _num(cs: Dictionary, k: String, ref: float, fs: float):
	return Css.px(cs.get(k), ref, fs, vw, vh)
func _fs(cs: Dictionary) -> float:
	var v = Css.px(cs.get("font-size", "15px"), 15.0, 15.0, vw, vh)
	return 15.0 if v == null else v

# 回傳佔用嘅高度（block 流用）
func _layout(el: El, pcs: Dictionary, cb: Rect2, pcb_pos: Rect2, depth: int, x: float, y: float, avail_w: float, alpha: float, xf: Transform2D) -> Vector2:
	if el.tagName == "#TEXT" or el.tagName == "SVG" or el.tagName == "SCRIPT" or el.tagName == "STYLE": return Vector2.ZERO
	var cs = (el.props["_pcs"].duplicate() if el.props.has("_pcs") else Css.computed(el, pcs))
	el.props["_cs"] = cs
	if cs.get("display", "") == "none" or (el.props.get("hidden") != null and J.t(el.props.get("hidden"))): return Vector2.ZERO
	if cs.get("visibility", "") == "hidden": alpha = 0.0
	var fs = _fs(cs)
	var op = cs.get("opacity")
	if op != null: alpha *= clampf(J.num(Css.resolve_var(J.str(op))), 0, 1)
	var pos: String = cs.get("position", "static")
	var b = Box.new(); b.el = el; b.cs = cs; b.depth = depth; b.alpha = alpha
	b.z = int(J.num(cs.get("z-index", "0"))) if cs.get("z-index", "auto") != "auto" else 0
	var pz: Array = pcs.get("_zkey", [])
	b.zkey = pz + [b.z] if (cs.get("z-index", "auto") != "auto" and pos != "static") else pz
	cs["_zkey"] = b.zkey
	var ml = _num(cs, "margin-left", cb.size.x, fs); var mr = _num(cs, "margin-right", cb.size.x, fs)
	var mt = _num(cs, "margin-top", cb.size.x, fs); var mb = _num(cs, "margin-bottom", cb.size.x, fs)
	ml = 0.0 if ml == null else ml; mr = 0.0 if mr == null else mr; mt = 0.0 if mt == null else mt; mb = 0.0 if mb == null else mb
	var pl = _num(cs, "padding-left", cb.size.x, fs); var pr = _num(cs, "padding-right", cb.size.x, fs)
	var pt = _num(cs, "padding-top", cb.size.x, fs); var pb = _num(cs, "padding-bottom", cb.size.x, fs)
	pl = 0.0 if pl == null else pl; pr = 0.0 if pr == null else pr; pt = 0.0 if pt == null else pt; pb = 0.0 if pb == null else pb
	var bw = _num(cs, "border-width", 0, fs); bw = 0.0 if bw == null else bw
	var abs_ = pos == "absolute" or pos == "fixed"
	var ref: Rect2 = Rect2(0, 0, vw, vh) if pos == "fixed" else (pcb_pos if abs_ else cb)
	var W = _num(cs, "width", ref.size.x, fs); var H = _num(cs, "height", ref.size.y, fs)
	var L = _num(cs, "left", ref.size.x, fs); var R = _num(cs, "right", ref.size.x, fs)
	var T = _num(cs, "top", ref.size.y, fs); var Bt = _num(cs, "bottom", ref.size.y, fs)
	var ar = cs.get("aspect-ratio")
	if W == null and abs_ and L != null and R != null: W = ref.size.x - L - R - ml - mr
	if H == null and abs_ and T != null and Bt != null: H = ref.size.y - T - Bt - mt - mb
	if W == null and el.tagName == "IMG" and el.tex: W = (H * el.tex.get_width() / el.tex.get_height()) if H != null else float(el.tex.get_width()) * 0.5
	if W == null and el.tagName == "CANVAS" and el.rec: W = el.rec.width if not abs_ else null
	var disp: String = cs.get("display", "block" if not (el.tagName in ["SPAN", "B", "I", "SMALL", "EM", "STRONG", "A", "IMG", "BUTTON", "LABEL", "CANVAS", "INPUT", "SVG", "SELECT"]) else "inline")
	var is_inline = disp.begins_with("inline")
	if W == null and not abs_ and not is_inline and not el.props.get("_flexitem", false): W = avail_w - ml - mr
	if el.props.has("_capw"):
		if W == null: W = float(el.props["_capw"]) - ml - mr
		el.props.erase("_capw")
	# 直排 flex（align-items: stretch）入面嘅項目：闊度跟容器
	if W == null and not abs_ and el.props.get("_flexitem", false) and J.str(pcs.get("display", "")).ends_with("flex") and J.str(pcs.get("flex-direction", "row")).begins_with("column") \
		and not (J.str(pcs.get("align-items", "stretch")) in ["center", "flex-start", "start", "flex-end", "end", "baseline"]) and J.str(cs.get("align-self", "auto")) in ["auto", "stretch"]:
		W = avail_w - ml - mr
	var maxw = _num(cs, "max-width", ref.size.x, fs)
	var minw = _num(cs, "min-width", ref.size.x, fs)
	if W != null:
		if cs.get("box-sizing", "border-box") == "content-box": W += pl + pr + bw * 2
		if maxw != null: W = minf(W, maxw)
		if minw != null: W = maxf(W, minw)
	var inner_w: float = (W if W != null else maxf(0.0, (maxw if maxw != null else avail_w - ml - mr))) - pl - pr - bw * 2
	if ar != null and W != null and H == null:
		var parts = J.str(ar).split("/")
		if parts.size() == 2: H = W * parts[1].to_float() / maxf(0.001, parts[0].to_float())
		elif J.str(ar).is_valid_float(): H = W / maxf(0.001, J.str(ar).to_float())
	if H == null and el.tagName == "IMG" and el.tex and W != null: H = W * el.tex.get_height() / maxf(1, el.tex.get_width())
	if H == null and el.tagName == "CANVAS" and el.rec and W != null and el.rec.width > 0: H = W * el.rec.height / el.rec.width if not abs_ else null
	boxes.append(b)
	var bi = boxes.size() - 1
	# 先排子節點（暫時以 (0,0) 為內容原點），再搬
	var content_h = 0.0; var content_w = 0.0
	var my_cb = Rect2(0, 0, W if W != null else inner_w + pl + pr, H if H != null else 0.0)
	var kids_start = boxes.size()
	var child_cb_pos: Rect2 = my_cb if (pos != "static") else pcb_pos
	var flex = disp == "flex" or disp == "inline-flex" or disp == "grid" or disp == "inline-grid"
	var kids: Array = el.children
	var text_only = kids.size() > 0 and kids.all(func(k): return k.tagName == "#TEXT" or k.tagName in ["B", "I", "SMALL", "SPAN", "EM", "STRONG", "BR"] and k.children.all(func(q): return q.tagName == "#TEXT"))
	if el.tagName == "#TEXT": pass
	elif text_only and not flex:
		var tb = _text_layout(el, cs, inner_w if (W != null or not is_inline or el.props.get("_flexitem", false)) else 10000.0)
		if W == null and J.str(cs.get("text-align", "left")) in ["center", "right", "end"]:
			# 收縮包住內容嘅盒：用實際闊度再排一次，置中先準
			var fitw = tb[1]
			if minw != null: fitw = maxf(fitw, minw - pl - pr - bw * 2)
			tb = _text_layout(el, cs, fitw + 0.6)
		b.kind = "text"; b.lines = tb[0]; content_w = tb[1]; content_h = tb[2]
	elif flex:
		var r = _flex(el, cs, inner_w if W != null or not (abs_ or is_inline or el.props.get("_flexitem", false)) else -1.0, H - pt - pb - bw * 2 if H != null else -1.0, child_cb_pos, depth + 1, alpha, fs)
		content_w = r.x; content_h = r.y
	else:
		# 一般流式排版：塊級逐行落；行內（文字、span、inline-block）同一行排，排唔落先換行；text-align 對成行生效
		var cy = 0.0; var line_x = 0.0; var line_h = 0.0; var ls = boxes.size()
		var talign = J.str(cs.get("text-align", "left"))
		# 注意：GDScript lambda 係按值捕捉變數，所以 ls 要當參數傳入
		var flush = func(cy_: float, lx: float, lh: float, ls_: int) -> float:
			if lh > 0 and lx < inner_w and (talign == "center" or talign == "right" or talign == "end"):
				var off = (inner_w - lx) / (2.0 if talign == "center" else 1.0)
				for bi3 in range(ls_, boxes.size()): boxes[bi3].x += off
			return cy_ + lh
		for k in kids:
			if not (k is El): continue
			if k.tagName == "#TEXT":
				var t = J.str(k.props.get("textContent", "")).strip_edges()
				if t == "": continue
				var tb2 = _text_layout(k, cs, inner_w, t)
				var one_line = tb2[2] <= fs * 2.0
				if one_line: tb2 = _text_layout(k, cs, 10000.0, t)
				var tbx = Box.new(); tbx.el = k; tbx.cs = cs; tbx.kind = "text"; tbx.lines = tb2[0]; tbx.alpha = alpha; tbx.depth = depth + 1; tbx.zkey = b.zkey
				tbx.w = tb2[1]; tbx.h = tb2[2]
				if one_line and line_x + tb2[1] <= inner_w + 0.5:
					boxes.append(tbx); tbx.x = line_x; tbx.y = cy; line_x += tb2[1]; line_h = maxf(line_h, tb2[2]); content_w = maxf(content_w, line_x); continue
				if line_h > 0: cy = flush.call(cy, line_x, line_h, ls); line_x = 0; line_h = 0
				ls = boxes.size(); boxes.append(tbx)
				tbx.x = 0; tbx.y = cy
				if one_line: line_x = tb2[1]; line_h = tb2[2]; content_w = maxf(content_w, line_x); continue
				cy += tb2[2]; content_w = maxf(content_w, tb2[1]); ls = boxes.size(); continue
			var kcs0 = Css.computed(k, cs)
			var kcs_pos: String = kcs0.get("position", "static")
			var kabs = kcs_pos == "absolute" or kcs_pos == "fixed"
			var kd = J.str(kcs0.get("display", "inline" if k.tagName in ["SPAN", "B", "I", "SMALL", "EM", "STRONG", "A", "IMG", "BUTTON", "LABEL", "CANVAS", "INPUT", "SELECT"] else "block"))
			if kabs:
				_layout(k, cs, Rect2(0, 0, inner_w, H if H != null else 0.0), child_cb_pos, depth + 1, 0.0, 0.0, inner_w, alpha, xf); continue
			var inl = kd.begins_with("inline")
			if not inl and line_h > 0:
				cy = flush.call(cy, line_x, line_h, ls); line_x = 0; line_h = 0
			var start_k = boxes.size()
			var sz = _layout(k, cs, Rect2(0, 0, inner_w, H if H != null else 0.0), child_cb_pos, depth + 1, 0.0, cy, inner_w, alpha, xf)
			if not inl:
				cy += sz.y; content_w = maxf(content_w, sz.x); ls = boxes.size(); continue
			if line_x + sz.x <= inner_w + 0.5 or line_x == 0:
				for bi4 in range(start_k, boxes.size()): boxes[bi4].x += line_x
				line_x += sz.x; line_h = maxf(line_h, sz.y); content_w = maxf(content_w, line_x); continue
			# 換行：成個元素搬去下一行頭
			var moved = boxes.slice(start_k); boxes.resize(start_k)
			var y_laid = cy
			cy = flush.call(cy, line_x, line_h, ls)
			ls = boxes.size()
			for mvb in moved: mvb.y += cy - y_laid; boxes.append(mvb)
			line_x = sz.x; line_h = sz.y; content_w = maxf(content_w, sz.x)
		if line_h > 0: cy = flush.call(cy, line_x, line_h, ls); line_h = 0
		content_h = cy
	var bw_total: float = W if W != null else (content_w + pl + pr + bw * 2)
	if W == null and minw != null: bw_total = maxf(bw_total, minw)
	var bh_total: float = H if H != null else (content_h + pt + pb + bw * 2)
	var minh = _num(cs, "min-height", ref.size.y, fs)
	if minh != null: bh_total = maxf(bh_total, minh)
	var maxh = _num(cs, "max-height", ref.size.y, fs)
	if maxh != null: bh_total = minf(bh_total, maxh)
	b.w = bw_total; b.h = bh_total
	# ::before／::after（只做絕對定位嗰種：紅點、印章、漸層遮罩之類）
	if not el.props.has("_pcs") and el.tagName != "#TEXT":
		var pad_box = Rect2(-pl, -pt, bw_total - bw * 2, bh_total - bw * 2)
		for pk in ["before", "after"]:
			var pcs2 = Css.pseudo(el, pk, cs)
			if pcs2 == null or not (pcs2.get("position", "") in ["absolute", "fixed"]): continue
			var key = "_pseudo_" + pk
			var pe: El = el.props.get(key)
			if pe == null:
				pe = El.new("div"); pe.tagName = "PSEUDO"; pe.parentNode = el; el.props[key] = pe
			var txt = J.str(pcs2.get("content", "")).strip_edges().trim_prefix("\"").trim_suffix("\"").trim_prefix("'").trim_suffix("'")
			pe.children.clear()
			if txt != "":
				var tn = El.new("#text"); tn.tagName = "#TEXT"; tn.props["textContent"] = txt; tn.parentNode = pe; pe.children.append(tn)
			pe.props["_pcs"] = pcs2
			var s0 = boxes.size()
			_layout(pe, cs, Rect2(0, 0, inner_w, bh_total), pad_box, depth + 1, 0.0, 0.0, inner_w, alpha, xf)
			if pk == "before" and boxes.size() > s0:
				var moved = boxes.slice(s0); boxes.resize(s0)
				for mi in moved.size(): boxes.insert(kids_start + mi, moved[mi])
	# 位置
	var bx = x + ml; var by = y + mt
	if abs_:
		bx = ref.position.x + (L + ml if L != null else (ref.size.x - R - mr - bw_total if R != null else ml))
		by = ref.position.y + (T + mt if T != null else (ref.size.y - Bt - mb - bh_total if Bt != null else mt))
		if pos == "fixed": bx = (L if L != null else (vw - R - bw_total if R != null else 0.0)); by = (T if T != null else (vh - Bt - bh_total if Bt != null else 0.0))
	elif cs.get("margin-left") == "auto" and cs.get("margin-right") == "auto" and W != null: bx = x + (avail_w - bw_total) / 2
	if pos == "relative":
		if L != null: bx += L
		if T != null: by += T
	# transform（translate / scale / rotate 簡化）
	var tfs: String = Css.resolve_var(J.str(cs.get("transform", "")))
	if tfs != "" and tfs != "none":
		var rx = RegEx.create_from_string("(translate[XY]?|scale|rotate)\\(([^)]*)\\)")
		for m in rx.search_all(tfs):
			var args = m.get_string(2).split(",")
			match m.get_string(1):
				"translate":
					var tx = Css.px(args[0].strip_edges(), bw_total, fs, vw, vh); var ty = Css.px(args[1].strip_edges(), bh_total, fs, vw, vh) if args.size() > 1 else 0.0
					bx += 0.0 if tx == null else tx; by += 0.0 if ty == null else ty
				"translateX":
					var tx2 = Css.px(args[0].strip_edges(), bw_total, fs, vw, vh); bx += 0.0 if tx2 == null else tx2
				"translateY":
					var ty2 = Css.px(args[0].strip_edges(), bh_total, fs, vw, vh); by += 0.0 if ty2 == null else ty2
	b.x = bx; b.y = by
	# 子節點喺內容原點 (0,0) 排好，而家搬去實際位置
	var ox = bx + pl + bw; var oy = by + pt + bw
	var st = el.props.get("scrollTop")
	if st != null and (cs.get("overflow-y", cs.get("overflow", "")) in ["auto", "scroll"]): oy -= J.num(st)
	for i in range(kids_start, boxes.size()):
		var kb: Box = boxes[i]
		if kb.el != null and kb.el.props.get("_fixed", false): continue
		var kpos: String = kb.cs.get("position", "static") if kb.el != el else "static"
		kb.x += ox; kb.y += oy
	el.props["_rect"] = {"left": bx, "top": by, "x": bx, "y": by, "width": bw_total, "height": bh_total, "right": bx + bw_total, "bottom": by + bh_total}
	if el.tagName == "CANVAS": b.kind = "canvas"
	elif el.tagName == "IMG": b.kind = "img"
	if abs_: return Vector2.ZERO
	return Vector2(bw_total + ml + mr, bh_total + mt + mb)

# 把 el 之後新加嘅 box（el 自己同後代）橫移
func _shift(el: El, dx: float, dy: float) -> void:
	var start = -1
	for i in boxes.size():
		if boxes[i].el == el: start = i; break
	if start < 0: return
	for i in range(start, boxes.size()): boxes[i].x += dx; boxes[i].y += dy
func _shift_abs(el: El, dx: float, dy: float) -> void: _shift(el, dx, dy)

func _flex(el: El, cs: Dictionary, inner_w: float, inner_h: float, cb_pos: Rect2, depth: int, alpha: float, fs: float) -> Vector2:
	var disp: String = cs.get("display", "flex")
	var grid = disp.ends_with("grid")
	var dir: String = "row" if grid else cs.get("flex-direction", "row")
	var col = dir.begins_with("column")
	var wrap: bool = grid or cs.get("flex-wrap", "nowrap") == "wrap"
	var gapc = Css.px(cs.get("column-gap", "0"), inner_w, fs, vw, vh); gapc = 0.0 if gapc == null else gapc
	var gapr = Css.px(cs.get("row-gap", "0"), inner_w, fs, vw, vh); gapr = 0.0 if gapr == null else gapr
	var ncols = 0
	if grid:
		var gtc = J.str(cs.get("grid-template-columns", ""))
		var mrep = RegEx.create_from_string("repeat\\((\\d+)").search(gtc)
		ncols = mrep.get_string(1).to_int() if mrep else maxi(1, Css._tokens(gtc).size())
	var items = []
	for k in el.children:
		if not (k is El): continue
		if k.tagName == "#TEXT":
			var t = J.str(k.props.get("textContent", "")).strip_edges()
			if t == "": continue
		items.append(k)
	var shrink: bool = inner_w < 0
	if shrink: inner_w = 2000.0
	var main_size = inner_h if col else (-1.0 if shrink else inner_w)
	var pos_main = 0.0; var pos_cross = 0.0; var line_cross = 0.0
	var placed = []   # [el, main, cross, mainsize, crosssize, grow]
	var total_grow = 0.0
	var caps = {}
	var s0 = boxes.size()
	for pass_i in 2:
		if pass_i == 1:
			# 第二輪：按最終闊度重排（flex-grow 攤分剩餘位、flex-shrink 收窄文字），文字先會喺正確位置換行
			if col or wrap or shrink or main_size < 0: break
			var tot = 0.0
			for p in placed: tot += p[3]
			tot += gapc * maxf(0, placed.size() - 1)
			var over = tot - main_size
			if over < -0.5 and total_grow > 0:
				for p in placed:
					if p[6] == null and p[5] > 0: caps[p[0]] = p[3] + (-over) * p[5] / total_grow
			elif over > 0.5:
				var shr = []
				for p in placed:
					if p[6] != null: continue
					var pk: El = p[0]; var pcs3 = Css.computed(pk, cs)
					if J.num(pcs3.get("flex-shrink", "1")) <= 0 or pcs3.has("width") or pk.tagName in ["BUTTON", "IMG", "CANVAS"]: continue
					if pcs3.get("white-space", "") == "nowrap" or J.str(pcs3.get("display", "")).ends_with("flex"): continue
					shr.append(p)
				var base = 0.0
				for p in shr: base += maxf(p[3], 1.0)
				for p in shr: caps[p[0]] = maxf(20.0, p[3] - over * maxf(p[3], 1.0) / maxf(1.0, base))
			if caps.is_empty(): break
			boxes.resize(s0); placed = []; total_grow = 0.0
		for k in items:
			var kcs = Css.computed(k, cs) if k.tagName != "#TEXT" else cs
			if k.tagName != "#TEXT" and (kcs.get("position", "") == "absolute" or kcs.get("position", "") == "fixed"):
				_layout(k, cs, Rect2(0, 0, inner_w, maxf(inner_h, 0)), cb_pos, depth, 0, 0, inner_w, alpha, Transform2D.IDENTITY); continue
			var grow = J.num(kcs.get("flex-grow", "0")) if k.tagName != "#TEXT" else 0.0
			var avail = inner_w if col else (((inner_w - gapc * (ncols - 1)) / ncols) if grid else inner_w)
			if caps.has(k): avail = caps[k]; k.props["_capw"] = caps[k]
			if k.tagName == "#TEXT":
				var tb = _text_layout(k, cs, avail, J.str(k.props.get("textContent", "")).strip_edges())
				var tbx = Box.new(); tbx.el = k; tbx.cs = cs; tbx.kind = "text"; tbx.lines = tb[0]; tbx.alpha = alpha; tbx.depth = depth; tbx.zkey = cs.get("_zkey", [])
				tbx.w = tb[1]; tbx.h = tb[2]; boxes.append(tbx)
				placed.append([k, 0.0, 0.0, tb[1] if not col else tb[2], tb[2] if not col else tb[1], 0.0, tbx]); continue
			var kcs2 = kcs.duplicate(); kcs2["_flexitem"] = true
			k.props["_flexitem"] = true
			var before = boxes.size()
			var sz: Vector2
			if grid:
				var save_w = k.style.get("width")
				sz = _layout_item(k, cs, avail, cb_pos, depth, alpha, true)
			else:
				sz = _layout_item(k, cs, avail, cb_pos, depth, alpha, col or grow > 0 and false)
			if sz == Vector2.ZERO and boxes.size() == before: continue
			total_grow += grow
			placed.append([k, 0.0, 0.0, sz.y if col else sz.x, sz.x if col else sz.y, grow, null, before, boxes.size()])
	# 擺位
	var lines = [[]]; var used = 0.0
	for i in placed.size():
		var p = placed[i]
		var need: float = p[3] + (gapc if not col else gapr) * (1 if lines[-1].size() else 0)
		if wrap and lines[-1].size() and (used + need > main_size + 0.5 or (grid and lines[-1].size() >= ncols)):
			lines.append([]); used = 0.0; need = p[3]
		lines[-1].append(p); used += need
	var cross = 0.0; var max_main = 0.0
	var max_cross_item = 0.0
	for p in placed: max_cross_item = maxf(max_cross_item, p[4])
	var jc: String = cs.get("justify-content", "flex-start"); var ai: String = cs.get("align-items", "stretch")
	for ln in lines:
		var lmain = 0.0; var lcross = 0.0; var g = 0.0
		for p in ln: lmain += p[3]; lcross = maxf(lcross, p[4]); g += p[5]
		var gap: float = gapr if col else gapc
		lmain += gap * maxf(0, ln.size() - 1)
		var free = (main_size - lmain) if main_size >= 0 else 0.0
		var start = 0.0; var between = gap
		if g > 0 and free > 0:
			for p in ln:
				if p[5] > 0: _grow(p, free * p[5] / g, col); p[3] += free * p[5] / g
			free = 0
		elif g > 0 and free < 0 and main_size >= 0:
			# 超出：由 flex-grow 嘅項目讓出（flex:1 嘅 basis 係 0）
			for p in ln:
				if p[5] > 0:
					var cut: float = minf(p[3], -free * p[5] / g)
					_grow(p, -cut, col); p[3] -= cut
					if p[0] is El and (p[0] as El).tagName == "CANVAS": pass
			free = 0
		match jc:
			"center": start = free / 2
			"flex-end", "end", "right": start = free
			"space-between": between = gap + (free / maxf(1, ln.size() - 1) if ln.size() > 1 else 0.0); start = 0.0 if ln.size() > 1 else free / 2
			"space-around": between = gap + free / maxf(1, ln.size()); start = between / 2 - gap / 2
			"space-evenly": between = gap + free / (ln.size() + 1); start = free / (ln.size() + 1)
		var m = start
		for p in ln:
			var c_off = 0.0
			var line_c: float = lcross
			if lines.size() == 1:
				if col: line_c = max_cross_item if shrink else inner_w
				elif inner_h >= 0: line_c = inner_h
			match ai:
				"center": c_off = (line_c - p[4]) / 2
				"flex-end", "end": c_off = line_c - p[4]
			var dx: float = (c_off + cross) if col else m
			var dy: float = m if col else (c_off + cross)
			if p[6] != null: (p[6] as Box).x += dx; (p[6] as Box).y += dy
			else:
				# 只搬呢個項目自己嘅 box（唔好連後面嘅項目一齊搬）
				for bi2 in range(p[7], p[8]): boxes[bi2].x += dx; boxes[bi2].y += dy
			m += p[3] + between
		max_main = maxf(max_main, m - between)
		cross += lcross + (gapc if col else gapr)
	cross -= (gapc if col else gapr) if lines.size() else 0.0
	if false: print("DBGFLEX ", el.classList.d.keys(), " inner_w=", inner_w, " shrink=", shrink, " main=", main_size, " placed=", placed.map(func(p): return [p[0].tagName, p[3], p[4], p[5]]), " max_main=", max_main, " caps=", caps.values())
	return Vector2(cross, max_main) if col else Vector2(max_main, cross)

func _grow(p: Array, extra: float, col: bool) -> void:
	var el: El = p[0]
	for b in boxes:
		if b.el == el:
			if col: b.h += extra
			else: b.w += extra
			return

func _layout_item(k: El, pcs: Dictionary, avail: float, cb_pos: Rect2, depth: int, alpha: float, full: bool) -> Vector2:
	var kcs = Css.computed(k, pcs)
	var has_w = kcs.has("width") or kcs.has("flex-basis") and kcs.get("flex-basis") != "0" and Css.px(kcs.get("flex-basis"), avail, 15) != null
	if not has_w and not full:
		# 收縮包住內容：先用 avail 排，再用實際內容寬
		k.style["__shrink"] = true
	var sz = _layout(k, pcs, Rect2(0, 0, avail, 0), cb_pos, depth, 0.0, 0.0, avail, alpha, Transform2D.IDENTITY)
	k.style.erase("__shrink")
	return sz

# 文字排版：回傳 [lines, w, h]
func _text_layout(el: El, cs: Dictionary, maxw: float, override_text = null) -> Array:
	var runs = []   # [text, cs]
	if override_text != null: runs.append([override_text, cs])
	else: _collect_runs(el, cs, runs)
	var lines = []; var x = 0.0; var y = 0.0; var line_h = 0.0; var wmax = 0.0
	var align: String = cs.get("text-align", "left")
	var cur_line = []
	var lh_mul = J.num(Css.resolve_var(J.str(cs.get("line-height", "1.45")))) if J.str(cs.get("line-height", "1.45")).is_valid_float() else 1.45
	for r in runs:
		var rcs: Dictionary = r[1]; var fs = _fs(rcs)
		var fw = _weight(rcs)
		var font = Ctx.font_res("serif" if J.str(rcs.get("font-family", "")).contains("serif") and not J.str(rcs.get("font-family", "")).contains("sans") else "sans-serif", fw)
		var col = Css.color(rcs.get("color", "#e9e4f2"))
		var lh = fs * lh_mul
		var text: String = r[0]
		if text == "\v":
			# 塊級元素嘅換行：已經喺行頭就唔使再換
			if cur_line.is_empty() and x == 0: continue
			text = "\n"
		if text == "\n":
			_flush_line(lines, cur_line, x, y, maxw, align); wmax = maxf(wmax, x); y += maxf(line_h, lh); x = 0; line_h = 0; cur_line = []; continue
		var seg = ""
		for ch in text:
			if ch == "\n":
				cur_line.append([seg, x - font.get_string_size(seg, 0, -1, int(fs)).x, font, int(fs), col]); _flush_line(lines, cur_line, x, y, maxw, align)
				wmax = maxf(wmax, x); y += maxf(line_h, lh); x = 0; line_h = 0; cur_line = []; seg = ""; continue
			var cw = font.get_string_size(ch, 0, -1, int(fs)).x
			if x + cw > maxw + 0.5 and x > 0:
				cur_line.append([seg, x - font.get_string_size(seg, 0, -1, int(fs)).x, font, int(fs), col])
				_flush_line(lines, cur_line, x, y, maxw, align)
				wmax = maxf(wmax, x); y += maxf(line_h, lh); x = 0; line_h = 0; cur_line = []; seg = ""
				if ch == " ": continue
			seg += ch; x += cw; line_h = maxf(line_h, lh)
		if seg != "": cur_line.append([seg, x - font.get_string_size(seg, 0, -1, int(fs)).x, font, int(fs), col])
	if cur_line.size(): _flush_line(lines, cur_line, x, y, maxw, align)
	wmax = maxf(wmax, x)
	return [lines, wmax, y + line_h]

func _flush_line(lines: Array, cur: Array, w: float, y: float, maxw: float, align: String) -> void:
	var off = 0.0
	if maxw < 9000:
		if align == "center": off = (maxw - w) / 2
		elif align == "right" or align == "end": off = maxw - w
	for s in cur:
		var lh: float = s[3] * 1.45
		lines.append([s[0], s[1] + off, y + (lh - s[3]) / 2 + s[2].get_ascent(s[3]), s[2], s[3], s[4]])

func _collect_runs(el: El, cs: Dictionary, runs: Array) -> void:
	for k in el.children:
		if k.tagName == "#TEXT": runs.append([J.str(k.props.get("textContent", "")), cs])
		elif k.tagName == "BR": runs.append(["\n", cs])
		else:
			var kcs = Css.computed(k, cs)
			if kcs.get("display", "") == "none": continue
			if k.tagName in ["B", "STRONG"] and not kcs.has("font-weight"): kcs["font-weight"] = "800"
			if k.tagName == "SMALL" and not kcs.has("font-size"): kcs["font-size"] = str(_fs(cs) * 0.85) + "px"
			if kcs.get("display", "inline") == "block" and runs.size(): runs.append(["\v", cs])
			_collect_runs(k, kcs, runs)
			if kcs.get("display", "inline") == "block": runs.append(["\v", cs])

func _weight(cs: Dictionary) -> int:
	var w = J.str(cs.get("font-weight", "400"))
	if w == "bold" or w == "bolder": return 700
	if w == "normal": return 400
	return int(w.to_int()) if w.is_valid_int() else 400

# ---------------- 畫 ----------------
func _draw() -> void:
	var order = range(boxes.size())
	order.sort_custom(func(a, b):
		var ka: Array = boxes[a].zkey; var kb: Array = boxes[b].zkey
		for i in mini(ka.size(), kb.size()):
			if ka[i] != kb[i]: return ka[i] < kb[i]
		if ka.size() != kb.size():
			# 一方係另一方嘅前綴：冇自己 z 嘅照文件次序
			var x = ka[kb.size()] if ka.size() > kb.size() else 0; var y = kb[ka.size()] if kb.size() > ka.size() else 0
			if x != y: return x < y
		return a < b)
	for i in order:
		var b: Box = boxes[i]
		if b.alpha <= 0.01: continue
		_paint(b)

func _paint(b: Box) -> void:
	var cs = b.cs; var r = Rect2(b.x, b.y, b.w, b.h)
	if b.el.tagName != "#TEXT" and b.kind != "text" or b.el.tagName != "#TEXT":
		_paint_bg(b, r)
	match b.kind:
		"text":
			for ln in b.lines:
				var c: Color = ln[5]; c.a *= b.alpha
				var ts = cs.get("text-shadow")
				var bare = b.el.tagName == "#TEXT"   # 文字節點嘅 box 已經喺內容區，唔使再加 padding
				draw_string(ln[3], Vector2(b.x + (0.0 if bare else _padl(b)) + ln[1], b.y + (0.0 if bare else _padt(b)) + ln[2]), ln[0], HORIZONTAL_ALIGNMENT_LEFT, -1, ln[4], c)
		"img":
			if b.el.tex: draw_texture_rect(b.el.tex, r, false, Color(1, 1, 1, b.alpha))
		"canvas":
			var rec: Recorder = b.el.rec
			if rec and rec.width > 0 and rec.height > 0:
				rec.replay(self, Transform2D(Vector2(b.w / rec.width, 0), Vector2(0, b.h / rec.height), Vector2(b.x, b.y)), b.alpha)
				rec.stale = true

func _padl(b: Box) -> float:
	var v = Css.px(b.cs.get("padding-left"), b.w, _fs(b.cs), vw, vh); var bw = Css.px(b.cs.get("border-width"), 0, 15)
	return (0.0 if v == null else v) + (0.0 if bw == null else bw)
func _padt(b: Box) -> float:
	var v = Css.px(b.cs.get("padding-top"), b.w, _fs(b.cs), vw, vh); var bw = Css.px(b.cs.get("border-width"), 0, 15)
	return (0.0 if v == null else v) + (0.0 if bw == null else bw)

func _paint_bg(b: Box, r: Rect2) -> void:
	var cs = b.cs
	var cp = J.str(cs.get("clip-path", ""))
	if cp.begins_with("polygon("):
		# clip-path 多邊形（例如紙張撕邊）：直接用底色填多邊形
		var col = Css.color(Css.resolve_var(J.str(cs.get("background", cs.get("background-color", "")))))
		if col.a > 0:
			var pts = PackedVector2Array()
			for pr in cp.substr(8, cp.length() - 9).split(","):
				var xy = Css._tokens(pr.strip_edges())
				if xy.size() < 2: continue
				var px_ = Css.px(xy[0], r.size.x, 15); var py_ = Css.px(xy[1], r.size.y, 15)
				pts.append(r.position + Vector2(0.0 if px_ == null else px_, 0.0 if py_ == null else py_))
			if pts.size() >= 3:
				col.a *= b.alpha
				var tri = Geometry2D.triangulate_polygon(pts)
				if tri.size(): draw_polygon(pts, PackedColorArray([col]))
			return
	var bgc = Css.color(cs.get("background-color"))
	var bgi = cs.get("background-image")
	var bg = cs.get("background")
	var grad_cols = []
	var bg_base = ""
	if bg != null:
		var s0 = Css.resolve_var(J.str(bg))
		# 多層背景：最底嗰層（最後一個）先係底色；紙紋／斜線之類嘅 svg 圖層忽略
		var layers = _split_shadow(s0)
		var s = s0
		if layers.size() > 1:
			s = layers[-1]
			for ly in layers:
				if ly.contains("url(") and not ly.contains("data:image/svg") and not s.contains("url("): bgi = ly
		bg_base = s
		if s.contains("gradient("):
			var rx = RegEx.create_from_string("(#[0-9a-fA-F]{3,8}|rgba?\\([^)]*\\))")
			for m in rx.search_all(s): grad_cols.append(Ctx.col(m.get_string(1)))
		elif s.contains("cr-paper") or s.contains("data:image/svg"):
			bgc = Ctx.col("#e6d5ae")
			var rest = s.substr(s.rfind(")") + 1).strip_edges()
			var c3 = Css.color(rest) if rest != "" else Color(0, 0, 0, 0)
			if c3.a > 0: bgc = c3
		elif s.contains("url("): bgi = s
		else:
			var c2 = Css.color(Css._tokens(s)[0] if Css._tokens(s).size() else s)
			if c2.a > 0: bgc = c2
	var radius = Css.px(cs.get("border-radius"), minf(b.w, b.h), _fs(cs), vw, vh)
	radius = 0.0 if radius == null else radius
	var bwd = Css.px(cs.get("border-width"), 0, 15); bwd = 0.0 if bwd == null else bwd
	var bc = Css.color(cs.get("border-color", cs.get("color", "#000"))) if bwd > 0 else Color(0, 0, 0, 0)
	var shadow = Css.resolve_var(J.str(cs.get("box-shadow", "")))
	# 外陰影（第一個唔係 inset 嘅）：用 StyleBoxFlat 嘅 shadow 畫，跟返圓角
	if shadow != "" and shadow != "none" and b.alpha > 0.05:
		for part in _split_shadow(shadow):
			if part.contains("inset"): continue
			var cm = RegEx.create_from_string("(#[0-9a-fA-F]{3,8}|rgba?\\([^)]*\\))").search(part)
			var nums = []
			for nm in RegEx.create_from_string("(-?[0-9.]+)(px)?(?![0-9a-fA-F]*\\))").search_all(part.replace(cm.get_string(1) if cm else "§", "")): nums.append(nm.get_string(1).to_float())
			if nums.size() < 2: break
			var sc = Css.color(cm.get_string(1)) if cm else Color(0, 0, 0, 0.5)
			sc.a *= b.alpha
			var blur = nums[2] if nums.size() > 2 else 0.0; var spread = nums[3] if nums.size() > 3 else 0.0
			if sc.a <= 0.01: break
			var ss = StyleBoxFlat.new(); ss.bg_color = Color(sc, 0.0); ss.draw_center = false
			ss.shadow_color = sc; ss.shadow_size = int(maxf(1.0, blur * 0.6 + spread)); ss.shadow_offset = Vector2(nums[0], nums[1])
			ss.set_corner_radius_all(int(radius)); ss.anti_aliasing = true
			draw_style_box(ss, r.grow(spread * 0.5))
			break
	if grad_cols.size() >= 2 and bg_base.contains("radial-gradient"):
		var ctx = Ctx.new(self)
		var c0r: Color = grad_cols[0]; c0r.a *= b.alpha
		var c1r: Color = grad_cols[-1]; c1r.a *= b.alpha
		var g = ctx.createRadialGradient(r.get_center().x, r.get_center().y, 0, r.get_center().x, r.get_center().y, minf(r.size.x, r.size.y) / 2)
		g.addColorStop(0, c0r); g.addColorStop(1, c1r)
		ctx.save(); ctx.translate(r.get_center().x, r.get_center().y); ctx.scale(1.0, r.size.y / maxf(1, r.size.x)); ctx.translate(-r.get_center().x, -r.get_center().y)
		ctx.fillStyle = g; ctx.fillRect(r.position.x, r.get_center().y - r.size.x / 2, r.size.x, r.size.x); ctx.restore()
		grad_cols = []
	elif grad_cols.size() >= 2:
		var pts = PackedVector2Array([r.position, Vector2(r.end.x, r.position.y), r.end, Vector2(r.position.x, r.end.y)])
		var c0: Color = grad_cols[0]; var c1: Color = grad_cols[-1]; c0.a *= b.alpha; c1.a *= b.alpha
		var horiz = bg_base.contains("90deg") or bg_base.contains("to right")
		draw_polygon(pts, PackedColorArray([c0, c1 if horiz else c0, c1, c0 if horiz else c1]))
	elif grad_cols.size() == 1: bgc = grad_cols[0]
	if bgc.a > 0 or bwd > 0 or (shadow.contains("inset") and grad_cols.size() < 2):
		var sb = StyleBoxFlat.new()
		bgc.a *= b.alpha
		sb.bg_color = bgc if grad_cols.size() < 2 else Color(0, 0, 0, 0)
		sb.set_corner_radius_all(int(radius))
		if bwd > 0: sb.border_color = Color(bc, bc.a * b.alpha); sb.set_border_width_all(int(ceil(bwd)))
		elif shadow.contains("inset"):
			var m2 = RegEx.create_from_string("inset\\s+0\\s+0\\s+0\\s+([0-9.]+)px\\s+(#[0-9a-fA-F]{3,8}|rgba?\\([^)]*\\)|var\\([^)]*\\)|currentColor)").search(shadow)
			if m2: sb.border_color = Css.color(cs.get("color", "#000") if m2.get_string(2) == "currentColor" else m2.get_string(2)); sb.border_color.a *= b.alpha; sb.set_border_width_all(maxi(1, int(round(m2.get_string(1).to_float()))))
		sb.anti_aliasing = true
		draw_style_box(sb, r)
	if bgi != null:
		var m = RegEx.create_from_string("url\\(['\"]?([^'\")]+)").search(J.str(bgi))
		if m:
			var path = m.get_string(1); var tex: Texture2D = _tex(path)
			if tex:
				var bs = J.str(cs.get("background-size", "auto"))
				var tw = float(tex.get_width()); var th = float(tex.get_height())
				var dr = r
				if bs == "cover" or bs == "contain":
					var k = maxf(r.size.x / tw, r.size.y / th) if bs == "cover" else minf(r.size.x / tw, r.size.y / th)
					dr = Rect2(r.position + (r.size - Vector2(tw, th) * k) / 2, Vector2(tw, th) * k)
				elif bs == "100% 100%": dr = r
				elif bs.begins_with("100%"): dr = Rect2(r.position, Vector2(r.size.x, r.size.x * th / tw))
				draw_texture_rect(tex, dr, false, Color(1, 1, 1, b.alpha))

func _split_shadow(s: String) -> Array:
	var out = []; var d = 0; var cur = ""
	for ch in s:
		if ch == "(": d += 1
		elif ch == ")": d -= 1
		if ch == "," and d == 0: out.append(cur.strip_edges()); cur = ""; continue
		cur += ch
	if cur.strip_edges() != "": out.append(cur.strip_edges())
	return out

var _texc := {}
func _tex(path: String) -> Texture2D:
	if not path.begins_with("res://"): return null
	if not _texc.has(path): _texc[path] = load(path)
	return _texc[path]

# ---------------- 輸入 ----------------
func _hit(p: Vector2):
	var best = null; var best_z = -999999; var best_i = -1
	for i in boxes.size():
		var b: Box = boxes[i]
		if b.el.tagName == "#TEXT" or b.alpha <= 0.01: continue
		if J.str(b.cs.get("pointer-events", "")) == "none": continue
		if not Rect2(b.x, b.y, b.w, b.h).has_point(p): continue
		var zs = 0
		for q in b.zkey: zs = zs * 100 + q
		if zs > best_z or (zs == best_z and i > best_i): best = b; best_z = zs; best_i = i
	return best

func _ev(type: String, p: Vector2, target: El) -> Dictionary:
	return {"type": type, "clientX": p.x, "clientY": p.y, "pageX": p.x, "pageY": p.y, "button": 0.0, "pointerId": 1.0, "isPrimary": true, "pointerType": "touch",
		"target": target, "touches": [{"clientX": p.x, "clientY": p.y}], "changedTouches": [{"clientX": p.x, "clientY": p.y}],
		"preventDefault": func(_t, _a): pass, "stopPropagation": func(_t, _a): pass}

func _bubble(type: String, p: Vector2, target: El) -> void:
	var e = _ev(type, p, target)
	var stop = [false]
	e["stopPropagation"] = func(_t, _a): stop[0] = true
	var el = target
	while el is El and not stop[0]:
		e["currentTarget"] = el
		if not (J.t(el.props.get("disabled")) and type == "click"): el.fire(type, e)
		el = el.parentNode
	if not stop[0]: JSRun.win_fire("doc:" + type, e)

func _gui_input(ev: InputEvent) -> void:
	if ev is InputEventMouseButton and ev.button_index == MOUSE_BUTTON_LEFT:
		var p: Vector2 = ev.position
		var b = _hit(p)
		if ev.pressed:
			_press_box = b; _press_pos = p; _drag_scroll = _scroll_parent(b)
			if b: _bubble("pointerdown", p, b.el); _bubble("mousedown", p, b.el); _bubble("touchstart", p, b.el)
		else:
			if b: _bubble("pointerup", p, b.el); _bubble("mouseup", p, b.el); _bubble("touchend", p, b.el)
			JSRun.win_fire("pointerup", _ev("pointerup", p, b.el if b else null))
			if b and _press_box == b and p.distance_to(_press_pos) < 12: _bubble("click", p, b.el)
			_press_box = null; _drag_scroll = null
		accept_event()
	elif ev is InputEventMouseButton and (ev.button_index == MOUSE_BUTTON_WHEEL_UP or ev.button_index == MOUSE_BUTTON_WHEEL_DOWN) and ev.pressed:
		var sc = _scroll_parent(_hit(ev.position))
		if sc: sc.props["scrollTop"] = maxf(0, J.num(sc.props.get("scrollTop", 0)) + (40 if ev.button_index == MOUSE_BUTTON_WHEEL_DOWN else -40))
	elif ev is InputEventMouseMotion:
		var p2: Vector2 = ev.position
		var b2 = _hit(p2)
		if b2: _bubble("pointermove", p2, b2.el)
		JSRun.win_fire("pointermove", _ev("pointermove", p2, b2.el if b2 else null))
		if _drag_scroll != null and (ev.button_mask & MOUSE_BUTTON_MASK_LEFT):
			_drag_scroll.props["scrollTop"] = maxf(0, J.num(_drag_scroll.props.get("scrollTop", 0)) - ev.relative.y)

func _scroll_parent(b):
	if b == null: return null
	var el = b.el
	while el is El:
		var cs = el.props.get("_cs", {})
		if cs is Dictionary and (cs.get("overflow-y", cs.get("overflow", "")) in ["auto", "scroll"]): return el
		el = el.parentNode
	return null
