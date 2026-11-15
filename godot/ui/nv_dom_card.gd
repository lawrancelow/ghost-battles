# 全屏 DOM 結算框原生化（線 F3）：戰鬥結算 #b-result（主線／野戰／收服）、嚇人「天亮了，收工」.sc-end
#  做法同 StDomPanel 一樣：讀 JS 砌好嘅 El 樹逐個轉做 Godot 控件；掣照叫返 El 嘅 onclick（獎勵、存檔、劇情全部仲係 JS）
#  JS 改咗 innerHTML 就重建；alive_fn 話唔再顯示（例如 #b-result 冇咗 .on）就自己收起
class_name NvDomCard
extends StDomPanel

var alive_fn: Callable
var backdrop := 0.5
var on_close: Callable

const TITLE := Color("#ffd27a")

# 嚇人收工結算：ScRun.end_hook 之後（同一幀 JS 先寫 #scare innerHTML），所以要 call_deferred
static func scare_end() -> void:
	if OS.has_environment("GB_RESDOM"): return
	var f = J.G.get("$")
	var sc = J.cl(f, null, ["#scare"]) if f != null else null
	if sc == null or not J.str(sc.props.get("innerHTML", "")).contains("sc-end"): return
	var main = Engine.get_main_loop().root.get_node_or_null("Main")
	if main == null: return
	var c = NvDomCard.new(); c.name = "NvScEnd"
	main.add_child(c)
	var dom = main.get("dom")
	if dom: main.move_child(c, dom.get_index() + 1)   # 蓋住 DOM，劇情／toast 仍然喺上面
	c.backdrop = 1.0
	var scc = sc
	c.alive_fn = func(): return scc.classList.d.has("on") and J.str(scc.props.get("innerHTML", "")).contains("sc-end")
	c.open(sc)

func open(root_el) -> void:
	setup(root_el, null, "pick")
	var dim = get_child(0) as ColorRect
	if dim: dim.color = Color(0.03, 0.02, 0.04, backdrop)
	var sb = UIKit.sb(Color("#1b1517"), 14, Color("#8a5a3a"), 2, Vector4(16, 14, 16, 14))
	sb.shadow_color = Color(0, 0, 0, 0.6); sb.shadow_size = 12
	box.add_theme_stylebox_override("panel", sb)

static var _sl: FontVariation = null
static func _slant() -> Font:
	if _sl == null:
		_sl = FontVariation.new(); _sl.base_font = UIKit.font("sans", 400); _sl.variation_transform = Transform2D(Vector2(1, 0), Vector2(0.2, 1), Vector2.ZERO)
	return _sl

func alive() -> bool:
	if el == null: return false
	if alive_fn.is_valid(): return alive_fn.call()
	return el.parentNode != null

func _process(dt: float) -> void:
	if not alive():
		if on_close.is_valid(): on_close.call()
		queue_free(); return
	super._process(dt)

func _layout() -> void:
	var vs = get_viewport_rect().size
	var w = minf(vs.x - 24, 340.0)
	var need = body.get_combined_minimum_size().y + 30
	var h = minf(need, vs.y * 0.86)
	scroll.custom_minimum_size = Vector2(w - 32, h - 28)
	box.offset_left = -w / 2; box.offset_right = w / 2; box.offset_top = -h / 2; box.offset_bottom = h / 2

# 結算框嘅外殼 div（.br／.sc-end／.gp-fail）直接攤平
func _add(parent: Control, e) -> void:
	if e.tagName == "#TEXT" or J.str(e.style.get("display", "")) == "none":
		super._add(parent, e); return
	var cl = _cls(e)
	match e.tagName:
		"H2", "H3":
			var l = _rich("[center][b]" + _bb(e) + "[/b][/center]", 24 if e.tagName == "H2" else 22, TITLE)
			l.add_theme_font_override("bold_font", UIKit.font("serif", 900)); l.add_theme_font_override("normal_font", UIKit.font("serif", 900))
			parent.add_child(l); return
		"H4":
			var l = _rich("[center][b]" + _bb(e) + "[/b][/center]", 16, TITLE)
			l.add_theme_font_override("bold_font", UIKit.font("serif", 900)); parent.add_child(l); return
		"UL":
			for li in e.children:
				if li.tagName != "LI": continue
				var lc = _cls(li)
				var col = Color("#9fe0b8") if lc.has("up") else (Color("#ff9a8a") if lc.has("dn") else INK)
				parent.add_child(_rich("・" + _bb(li), 13, col))
			return
		"P":
			var t = _bb(e)
			if t == "": return
			if cl.has("quip"):
				var q = _rich("[center][i]" + t + "[/i][/center]", 15, Color("#e8dcc8")); q.add_theme_font_override("italics_font", _slant()); parent.add_child(q); return
			if cl.has("sc-big"):
				parent.add_child(_rich("[center][b]" + t + "[/b][/center]", 20, Color("#fff1d6"))); return
			if cl.has("lost"):
				parent.add_child(_rich(t, 13, Color("#ff9a8a"))); return
			parent.add_child(_rich(t, 13, DIM if cl.has("gp-hint") else INK)); return
		"DIV":
			if cl.has("sc-stars"):
				parent.add_child(_rich("[color=#ffd27a]" + _bb(e) + "[/color]", 18, TITLE)); return
			if cl.has("br") or cl.has("sc-end") or cl.has("gp-fail") or cl.has("pe-card"):
				_children_into(parent, e, false); return
	super._add(parent, e)

func _button(e) -> Button:
	var b = super._button(e)
	var gold = _cls(e).has("gold")
	var s = UIKit.sb(Color("#c9973a") if gold else Color("#2a2420"), 9, Color("#f0c870") if gold else Color("#6a5a46"), 2, Vector4(10, 8, 10, 8))
	for k in ["normal", "hover", "pressed"]: b.add_theme_stylebox_override(k, s)
	var fc = Color("#2a1608") if gold else INK
	for k in ["font_color", "font_hover_color", "font_pressed_color"]: b.add_theme_color_override(k, fc)
	b.custom_minimum_size.y = 44
	return b
