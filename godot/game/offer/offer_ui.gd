# [offer] 冥牌坊貨倉（第一版）：陽間燒落嚟嘅紙紮奢侈品，上架即賣換冥幣
extends RefCounted

static func OJ(): return load("res://game/offer/offer_jobs.gd")
static func main() -> Control: return Engine.get_main_loop().root.get_node_or_null("Main")
static func L(s) -> String: return J.str(DB.L(J.str(s)))

static func open() -> void:
	var m = main()
	if m == null: return
	m.open_sheet(L("冥牌坊・貨倉"), func(): pass)
	render()

static func render() -> void:
	var m = main(); var b: VBoxContainer = m.sheet_body
	for c in b.get_children(): b.remove_child(c); c.queue_free()
	var O = OJ(); var M = O.mpf(); var G = O.data().GOODS
	var top = TextureRect.new(); top.custom_minimum_size = Vector2(0, 150); top.expand_mode = TextureRect.EXPAND_IGNORE_SIZE; top.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	if Spr.ok("mpf_building"): top.texture = Spr.get_tex("mpf_building")
	b.add_child(top)
	var intro = UIKit.rich(L("陽間人嚇到燒落嚟嘅紙紮名牌，全部喺度。上架即刻有女鬼搶，賣得冥幣。想要新貨？返陽間做燒貨單。"), 13, UIKit.INKTXT)
	intro.fit_content = true; intro.scroll_active = false; b.add_child(intro)
	var any = false
	for g in G:
		var n = int(M.stock.get(g, 0)); var sold = int(M.sold.get(g, 0))
		if n <= 0 and sold <= 0: continue
		any = true
		var gd = G[g]
		var p = PanelContainer.new(); p.add_theme_stylebox_override("panel", UIKit.sb(Color("#efe2bf"), 5, Color("#a08a5a"), 1, Vector4(6, 5, 6, 5)))
		var hb = HBoxContainer.new(); hb.add_theme_constant_override("separation", 6); p.add_child(hb)
		var ic = TextureRect.new(); ic.custom_minimum_size = Vector2(52, 52); ic.expand_mode = TextureRect.EXPAND_IGNORE_SIZE; ic.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		if Spr.ok(str(gd.spr)): ic.texture = Spr.get_tex(str(gd.spr))
		hb.add_child(ic)
		var r = UIKit.rich("[b]%s[/b]　×%d\n[font_size=11]%s[/font_size]\n[font_size=11][color=#2e6d5a]%s %d %s[/color]　[color=#8a7650]%s %d[/color][/font_size]" % [
			O.T(gd.n), n, O.T(gd.say), L("每件"), O.price(g), L("冥幣"), L("已賣"), sold], 13, UIKit.INKTXT)
		r.fit_content = true; r.scroll_active = false; r.size_flags_horizontal = Control.SIZE_EXPAND_FILL; hb.add_child(r)
		var vb = VBoxContainer.new(); hb.add_child(vb)
		for q in [1, n]:
			if q <= 0 or (q == n and n <= 1): continue
			var bt = UIKit.btn((L("賣一件") if q == 1 else L("全部上架")), "gold" if q > 1 else "", true)
			var gg = g; var qq = q
			bt.pressed.connect(func():
				var c = O.sell(gg, qq)
				if c > 0: Snd.play("coin"); m.show_toast(L("女鬼搶購！") + " +%d %s" % [c, L("冥幣")])
				render())
			vb.add_child(bt)
		b.add_child(p)
	if not any:
		var e = UIKit.rich(L("貨倉仲係空嘅。返陽間揀一張燒貨單，嚇到佢燒嘢落嚟啦。"), 13, UIKit.INKDIM); e.fit_content = true; b.add_child(e)
