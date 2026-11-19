# 原生改寫自 scene.js（蠟筆畫素材取代程序繪製：建築、樹、稻田、道具、烏鴉、背景）
# 介面同轉譯版一樣：J.G["SCENE"] = { drawBg, img }；載入時包 ART.drawBuilding/drawGate/drawTree/drawPaddy/drawDecor/drawCrow
extends RefCounted

const SERIF := "\"Songti TC\",\"Noto Serif CJK TC\",\"Noto Serif TC\",\"STSong\",serif"
const BW := {"house": 150.0, "gate": 124.0, "plank": 106.0, "bun": 106.0, "wood": 108.0, "rice": 108.0, "store": 112.0, "home": 104.0, "camp": 108.0, "altar": 104.0, "furnace": 62.0}
const PLAQUE := {"house": [0.47, 0.49, 0.24], "gate": [0.50, 0.36, 0.30], "plank": [0.44, 0.36, 0.32], "store": [0.48, 0.43, 0.33], "wood": [0.40, 0.36, 0.26]}
const PERCH := [[-0.22, 0.40, 1.0], [0.24, 0.30, -1.0]]
const DECO := {"scarecrow": ["scarecrow", 0.0, 62.0], "grave": ["grave", 26.0, 0.0], "post": ["lamppost", 0.0, 46.0], "banana": ["banana", 0.0, 64.0]}

static func _g(n: String): return J.G.get(n)
static func c(ctx, m: String, a: Array = []): return J.mc(ctx, m, a)
static func s(ctx, k: String, v) -> void: J.sp(ctx, k, v)

static func img(n):
	var SPR = _g("SPR")
	if SPR == null: return null
	var sp = J.gp(SPR, n)
	return sp if J.t(sp) and J.t(J.gp(sp, "complete")) and J.t(J.gp(sp, "naturalWidth")) else null
static func _nw(im) -> float: return J.num(J.gp(im, "naturalWidth"))
static func _nh(im) -> float: return J.num(J.gp(im, "naturalHeight"))

# 以底邊中心 (x,y) 畫一張圖，寬 w；回傳實際矩形
static func put(ctx, im, x: float, y: float, w: float, h: float = 0.0) -> Dictionary:
	if h == 0: h = w * _nh(im) / _nw(im)
	if w == 0: w = h * _nw(im) / _nh(im)
	c(ctx, "drawImage", [im, x - w / 2, y - h, w, h])
	return {"x": x - w / 2, "y": y - h, "w": w, "h": h}

# [villageart] 新畫風：舊圖壓暗（JS 畫布只支援 brightness 濾鏡，用調色嘅平均亮度）
const VS = preload("res://game/village_style.gd")
static func vput(ctx, key: String, im, x: float, y: float, w: float, h: float = 0.0) -> Dictionary:
	var tc: Color = VS.tint_for(key)
	if tc == Color.WHITE: return put(ctx, im, x, y, w, h)
	c(ctx, "save"); s(ctx, "filter", "brightness(%.3f)" % ((tc.r + tc.g + tc.b) / 3.0))
	var r = put(ctx, im, x, y, w, h); c(ctx, "restore"); return r

static func lv_badge(ctx, x: float, y: float, lv) -> void:
	c(ctx, "save"); c(ctx, "translate", [x, y]); c(ctx, "rotate", [0.12])
	J.mc(_g("ART"), "rr", [ctx, -1.0, -8.0, 22.0, 16.0, 2.0, "#c2362b", "#f0c8b4", 1.0])
	s(ctx, "fillStyle", "#fff3e0"); s(ctx, "font", "900 10px sans-serif"); s(ctx, "textAlign", "center"); s(ctx, "textBaseline", "middle"); c(ctx, "fillText", [lv, 10.0, 0.5]); c(ctx, "restore")

# 在畫裡那塊空白牌匾上寫字
static func plaque_text(ctx, r: Dictionary, p: Array, text: String, lv) -> void:
	var cx = r.x + r.w * p[0]; var cy = r.y + r.h * p[1]; var pw = r.w * p[2]
	var fs = minf(15, pw / (text.length() * 1.08)); fs = maxf(7, fs)
	c(ctx, "save"); s(ctx, "font", "900 %spx %s" % [J.str(fs), SERIF]); s(ctx, "textAlign", "center"); s(ctx, "textBaseline", "middle")
	s(ctx, "lineWidth", maxf(2, fs * 0.28)); s(ctx, "strokeStyle", "rgba(40,20,8,.95)"); s(ctx, "lineJoin", "round")
	c(ctx, "strokeText", [text, cx, cy + 0.5]); s(ctx, "fillStyle", "#f6d58a"); c(ctx, "fillText", [text, cx, cy + 0.5]); c(ctx, "restore")
	if J.t(lv): lv_badge(ctx, cx + pw / 2 - 2, cy - 9, lv)

# 沒有牌匾的建築：在前方插一塊小木牌
static func sign_board(ctx, x: float, y: float, text: String, lv) -> void:
	var ART = _g("ART")
	c(ctx, "save"); s(ctx, "font", "900 11.5px " + SERIF); var w = J.num(J.gp(c(ctx, "measureText", [text]), "width")) + 14
	J.mc(ART, "rr", [ctx, x - 1.5, y - 6, 3.0, 10.0, 1.0, "#4a3020"])
	J.mc(ART, "rr", [ctx, x - w / 2, y - 21, w, 16.0, 2.0, "#7a5634", "#2a1a0e", 1.4])
	s(ctx, "fillStyle", "rgba(255,230,180,.15)"); c(ctx, "fillRect", [x - w / 2 + 2, y - 19, w - 4, 2.0])
	s(ctx, "fillStyle", "#f6e2b0"); s(ctx, "textAlign", "center"); s(ctx, "textBaseline", "middle"); c(ctx, "fillText", [text, x, y - 12.5]); c(ctx, "restore")
	if J.t(lv): lv_badge(ctx, x + w / 2 - 1, y - 23, lv)

static func _glow(ctx, x0: float, y0: float, r0: float, r1: float, rgb: String, a: float, rx: float, ry: float, rw: float, rh: float) -> void:
	var g = c(ctx, "createRadialGradient", [x0, y0, r0, x0, y0, r1])
	J.mc(g, "addColorStop", [0.0, "rgba(%s,%s)" % [rgb, J.str(a)]]); J.mc(g, "addColorStop", [1.0, "rgba(%s,0)" % rgb])
	s(ctx, "fillStyle", g); c(ctx, "fillRect", [rx, ry, rw, rh])

# 背景：cover 方式鋪滿
static func draw_bg(ctx, w: float, h: float, bg) -> bool:
	var im = img("bg_" + J.str(bg))
	if im == null: return false
	var sc = maxf(w / _nw(im), h / _nh(im)); var iw = _nw(im) * sc; var ih = _nh(im) * sc
	c(ctx, "drawImage", [im, (w - iw) / 2, (h - ih) / 2, iw, ih])
	var v = c(ctx, "createLinearGradient", [0.0, 0.0, 0.0, h])
	J.mc(v, "addColorStop", [0.0, "rgba(10,8,14,.18)"]); J.mc(v, "addColorStop", [0.5, "rgba(10,8,14,0)"]); J.mc(v, "addColorStop", [1.0, "rgba(10,8,14,.32)"])
	s(ctx, "fillStyle", v); c(ctx, "fillRect", [0.0, 0.0, w, h])
	return true

static func _a(a: Array, i: int): return a[i] if i < a.size() else null

func run(_env) -> void:
	var ART = _g("ART")
	var o_building = ART.drawBuilding; var o_tree = ART.drawTree; var o_paddy = ART.drawPaddy; var o_gate = ART.drawGate; var o_decor = ART.drawDecor; var o_crow = ART.drawCrow
	ART["drawBuilding"] = func(this_, a):
		var ctx = _a(a, 0); var id = J.str(_a(a, 1)); var x = J.num(_a(a, 2)); var y = J.num(_a(a, 3)); var lv = _a(a, 4); var t = J.num(_a(a, 5)); var extra = _a(a, 6)
		var im = img(id)
		if im == null: return J.cl(o_building, this_, a)
		J.mc(ART, "el", [ctx, x, y + 1, BW[id] * 0.44, 7.0, "rgba(10,2,8,.34)"])   # [villageart]
		var r = put(ctx, im, x, y + 6, BW[id])
		var bd = J.gp(_g("BUILDINGS"), id)   # 唔喺 BUILDINGS（例如 gate）：網頁版會出錯，轉譯版當空名照畫；呢度跟轉譯版
		var name = J.str(J.gp(bd, "name")) if J.t(bd) else ""
		if PLAQUE.has(id): plaque_text(ctx, r, PLAQUE[id], name, lv)
		else: sign_board(ctx, x + (0.0 if id == "furnace" else BW[id] * 0.30), y + 12, name, lv)
		if id == "furnace" and J.t(extra): # 爐火正旺
			var fx = r.x + r.w * 0.5; var fy = r.y + r.h * 0.62; var al = 0.35 + sin(t * 7) * 0.12
			_glow(ctx, fx, fy, 2.0, 30.0, "255,170,60", al, fx - 30, fy - 30, 60.0, 60.0)
		return null
	ART["drawGate"] = func(this_, a):
		var ctx = _a(a, 0); var x = J.num(_a(a, 1)); var y = J.num(_a(a, 2)); var t = _a(a, 3)
		var im = img("gate")
		if im == null: return J.cl(o_gate, this_, a)
		var r = vput(ctx, "gate", im, x, y + 6, BW.gate); plaque_text(ctx, r, PLAQUE.gate, "出村", 0.0)
		var Gd = _g("Guide")
		if Gd != null: J.mc(Gd, "drawGateDot", [ctx, r.x + r.w * 0.78, r.y + r.h * 0.52, t])  # 有新地方未去過：紅點
		return null
	# 槐樹：有沒烏鴉的樹就另外畫停著的烏鴉；砍倒畫樹樁
	ART["drawTree"] = func(this_, a):
		var ctx = _a(a, 0); var x = J.num(_a(a, 1)); var y = J.num(_a(a, 2)); var hp = J.num(_a(a, 3)); var t = J.num(_a(a, 4)); var shake = J.t(_a(a, 5)); var perched = J.t(_a(a, 6)); var idx = int(J.num(_a(a, 7)))
		if hp <= 0:
			var stp = img("stump")
			if stp == null: return J.cl(o_tree, this_, a)
			vput(ctx, "stump", stp, x, y + 3, 38.0); return null
		var bare = img("tree_bare"); var full = img("tree")
		if full == null and bare == null: return J.cl(o_tree, this_, a)
		var sx = sin(t * 60) * 2.2 if shake else 0.0; var H = 80.0 + (idx % 3) * 4
		J.mc(ART, "el", [ctx, x, y + 2, 20.0, 5.0, "rgba(0,0,0,.35)"])
		c(ctx, "save")
		if shake: c(ctx, "translate", [x, y]); c(ctx, "rotate", [sin(t * 60) * 0.02]); c(ctx, "translate", [-x, -y])
		var tree = bare if bare != null else full; var flip = idx % 2 == 1
		if flip: c(ctx, "translate", [x, 0.0]); c(ctx, "scale", [-1.0, 1.0]); c(ctx, "translate", [-x, 0.0])
		var r = vput(ctx, "tree_bare", tree, x + sx, y + 4, 0.0, H)
		c(ctx, "restore")
		if bare != null and perched:
			var cs = img("crowsit")
			if cs != null:
				for pr in PERCH:
					var cx = x + r.w * pr[0] * (-1.0 if flip else 1.0) + sx; var cy = r.y + r.h * pr[1]
					c(ctx, "save"); c(ctx, "translate", [cx, cy]); c(ctx, "scale", [pr[2] * (-1.0 if flip else 1.0), 1.0]); put(ctx, cs, 0.0, 0.0, 13.0); c(ctx, "restore")
		return null
	ART["drawPaddy"] = func(this_, a):
		var ctx = _a(a, 0); var x = J.num(_a(a, 1)); var y = J.num(_a(a, 2)); var ripe = J.t(_a(a, 3))
		var ripe_im = img("paddy"); var cut = img("paddy_cut")
		if ripe_im == null: return J.cl(o_paddy, this_, a)
		if ripe: vput(ctx, "paddy", ripe_im, x, y + 9, 56.0); return null
		if cut != null: vput(ctx, "paddy_cut", cut, x, y + 9, 56.0); return null
		c(ctx, "save"); s(ctx, "globalAlpha", 0.55); s(ctx, "filter", "brightness(.55) saturate(.4)"); put(ctx, ripe_im, x, y + 9, 56.0, 34.0); c(ctx, "restore")
		return null
	ART["drawDecor"] = func(this_, a):
		var ctx = _a(a, 0); var kind = J.str(_a(a, 1)); var x = J.num(_a(a, 2)); var y = J.num(_a(a, 3)); var t = J.num(_a(a, 4))
		var d = DECO.get(kind); var im = img(d[0]) if d != null else null
		if im == null: return J.cl(o_decor, this_, a)
		if kind == "banana": c(ctx, "save"); c(ctx, "translate", [x, y]); c(ctx, "rotate", [sin(t * 0.8 + x) * 0.02]); vput(ctx, d[0], im, 0.0, 2.0, d[1], d[2]); c(ctx, "restore"); return null
		if kind == "scarecrow": c(ctx, "save"); c(ctx, "translate", [x, y]); c(ctx, "rotate", [sin(t * 0.9) * 0.03]); vput(ctx, d[0], im, 0.0, 4.0, d[1], d[2]); c(ctx, "restore"); return null
		vput(ctx, d[0], im, x, y + 3, d[1], d[2])
		if kind == "post":
			var al = 0.22 + sin(t * 2 + x) * 0.06
			_glow(ctx, x + 6, y - 30, 1.0, 18.0, "255,236,190", al, x - 14, y - 50, 40.0, 40.0)
		return null
	# 烏鴉：飛的用 crowfly（上下壓扁做拍翅），停著的用 crowsit
	ART["drawCrow"] = func(this_, a):
		var ctx = _a(a, 0); var x = J.num(_a(a, 1)); var y = J.num(_a(a, 2)); var sc = J.num(_a(a, 3)); var ph = J.num(_a(a, 4)); var dir = J.num(_a(a, 5)); var perched = J.t(_a(a, 6))
		var im = img("crowsit" if perched else "crowfly")
		if im == null: return J.cl(o_crow, this_, a)
		c(ctx, "save"); c(ctx, "translate", [x, y]); c(ctx, "scale", [-1.0 if dir < 0 else 1.0, 1.0 if perched else 0.55 + absf(sin(ph)) * 0.55])
		var w = (12.0 if perched else 20.0) * sc; var h = w * _nh(im) / _nw(im); c(ctx, "drawImage", [im, -w / 2, -h / 2, w, h]); c(ctx, "restore")
		return null
	J.G["SCENE"] = {
		"drawBg": func(_t, a): return draw_bg(_a(a, 0), J.num(_a(a, 1)), J.num(_a(a, 2)), _a(a, 3)),
		"img": func(_t, a): return img(_a(a, 0)),
	}
