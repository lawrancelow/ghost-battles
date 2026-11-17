# 原生改寫自 art.js（＋scene.js 蠟筆畫素材版嘅建築／樹／稻田／擺設／烏鴉）
# 介面同轉譯版一樣：J.G["ART"] = { CHAR_H, SOLID, hasRig, drawCrow, drawDecor, drawChar, portrait, sysIcon, drawBuilding, drawSite, drawTree, drawPaddy, drawGate, el, rr, poly, lantern, OUT }
# 繪畫全部交俾 core/art.gd（Art autoload）；CHAR_H／SOLID 係可改嘅表（n30_rigs、npc_antag、patrol_ghosts 會加嘢），Art 以佢為準
# 同網頁版唔同：程序畫法（DRAW／BDRAW）只保留 DRAW.youhun 做冇素材時嘅後備；建築、樹等直接用蠟筆畫素材（scene.js 版）
extends RefCounted

const CHAR_H0 := {"npc_it": 60, "npc_mis": 62, "npc_ken": 64, "npc_boss": 64, "npc_guard": 64, "npc_auntie": 60, "afu": 58, "xiaozhi": 54, "egui": 54, "eguiking": 66, "xiaogui": 46, "toyol": 46, "laojiang": 58, "zombie": 54, "shuigui": 56, "pontianak": 60, "pocong": 54, "penanggal": 52, "mengpo": 56, "youhun": 46, "baiwu": 76, "heiwu": 76, "niutou": 64, "mamian": 64, "huang": 62, "zhiren": 54, "tianhua": 60}
const SOLID0 := {"npc_it": 1, "npc_mis": 1, "npc_ken": 1, "npc_boss": 1, "npc_guard": 1, "npc_auntie": 1, "laojiang": 1, "zombie": 1, "pocong": 1, "xiaozhi": 1, "zhiren": 1, "penanggal": 1}

static var portrait_cache := {}

static func _A() -> Node: return Engine.get_main_loop().root.get_node("Art")
static func _o(v) -> Dictionary: return v if v is Dictionary else {}
static func _n(a: Array, i: int, d := 0.0) -> float: return J.num(a[i]) if i < a.size() and a[i] != null else d
static func _v(a: Array, i: int): return a[i] if i < a.size() else null
static func _f(a: Array, i: int): return a[i] if i < a.size() and J.t(a[i]) else null   # fill／stroke／lw：JS 用真假值判斷

# 頭像：畫喺一塊細畫布（El canvas）上，快取
static func portrait(type: String, size: float, opt) -> Variant:
	var A = _A(); var spr = A.has_spr(type)
	var key = type + "_" + J.str(size) + "_" + (JSON.stringify(opt) if opt != null else "{}") + ("_s" if spr else "")
	if portrait_cache.has(key): return portrait_cache[key]
	var c = J.S_document_("createElement", ["canvas"])
	var dpr = minf(2, J.num(J.gp(J.G.get("window"), "devicePixelRatio")) if J.t(J.gp(J.G.get("window"), "devicePixelRatio")) else 1.0)
	J.sp(c, "width", size * dpr); J.sp(c, "height", size * dpr)
	var ctx = J.mc(c, "getContext", ["2d"]); ctx.scale(dpr, dpr)
	if spr:
		var pr = A.portrait_region(type)
		var img = pr[0]; var r: Rect2 = pr[1]
		ctx.imageSmoothingQuality = "high"
		ctx.drawImage(img, r.position.x, r.position.y, r.size.x, r.size.y, size * 0.04, size * 0.04, size * 0.92, size * 0.92)
		portrait_cache[key] = c; return c
	var s = size / 52.0
	var oy = (-size * 0.05 if type == "penanggal" else 0.0) + (size * 0.3 if type in ["baiwu", "heiwu"] else 0.0) + (size * 0.12 if type in ["eguiking", "huang", "niutou", "mamian"] else 0.0)
	var o = {"shadow": false, "t": 0.3}
	if opt is Dictionary: for k in opt: o[k] = opt[k]
	A.draw_char(ctx, type, size / 2, size * 0.98 + oy, s * (0.85 if type in ["baiwu", "heiwu"] else 1.0), o, true)
	if J.G.get("SPR") == null or A.char_h(type) <= 0: portrait_cache[key] = c
	return c

# 系統頭像：發光嘅工牌
static func sys_icon(size: float) -> Variant:
	var A = _A()
	var c = J.S_document_("createElement", ["canvas"])
	var dpr = minf(2, J.num(J.gp(J.G.get("window"), "devicePixelRatio")) if J.t(J.gp(J.G.get("window"), "devicePixelRatio")) else 1.0)
	J.sp(c, "width", size * dpr); J.sp(c, "height", size * dpr)
	var ctx = J.mc(c, "getContext", ["2d"]); ctx.scale(dpr, dpr)
	var g = ctx.createRadialGradient(size / 2, size / 2, 2, size / 2, size / 2, size / 2)
	g.addColorStop(0, "rgba(120,255,220,.9)"); g.addColorStop(1, "rgba(120,255,220,0)")
	ctx.fillStyle = g; ctx.fillRect(0, 0, size, size)
	A.rr(ctx, size * 0.24, size * 0.18, size * 0.52, size * 0.64, size * 0.08, "#0e2a2a", "#6ff0d0", 2)
	ctx.fillStyle = "#6ff0d0"; ctx.font = "bold %spx sans-serif" % J.str(size * 0.2); ctx.textAlign = "center"; ctx.textBaseline = "middle"
	ctx.fillText("KPI", size / 2, size * 0.42); ctx.fillRect(size * 0.34, size * 0.6, size * 0.32, size * 0.05)
	return c

static func lantern(ctx, x: float, y: float, t: float, col) -> void:
	var A = _A()
	ctx.strokeStyle = "#222"; ctx.lineWidth = 1; ctx.beginPath(); ctx.moveTo(x, y - 6); ctx.lineTo(x, y - 2); ctx.stroke()
	var g = ctx.createRadialGradient(x, y + 5, 1, x, y + 5, 16); g.addColorStop(0, "rgba(255,90,70,.35)"); g.addColorStop(1, "rgba(255,90,70,0)")
	ctx.fillStyle = g; ctx.fillRect(x - 16, y - 11, 32, 32)
	A.el(ctx, x + sin(t * 2 + x) * 0.8, y + 5, 5, 7, col if J.t(col) else "#d8343c", A.OUT, 1.2)
	ctx.fillStyle = "#f2c14a"; ctx.fillRect(x - 3, y - 2, 6, 1.5); ctx.fillRect(x - 3, y + 11, 6, 1.5)

func run(_env) -> void:
	var A = _A()
	var CH = CHAR_H0.duplicate(); var SO = SOLID0.duplicate()
	J.G["ART"] = {
		"CHAR_H": CH, "SOLID": SO, "OUT": A.OUT,
		"hasRig": func(_t, a): var k = J.str(a[0]); return J.t(CH.get(k)) and A._ma_has(k),
		"drawChar": func(_t, a): A.draw_char(a[0], J.str(a[1]), _n(a, 2), _n(a, 3), _n(a, 4), _o(_v(a, 5)) if _v(a, 5) is Dictionary else {}, true); return null,
		"portrait": func(_t, a): return portrait(J.str(a[0]), _n(a, 1), _v(a, 2)),
		"sysIcon": func(_t, a): return sys_icon(_n(a, 0)),
		"drawBuilding": func(_t, a): A.draw_building(a[0], J.str(a[1]), _n(a, 2), _n(a, 3), _v(a, 4), _n(a, 5), _v(a, 6)); return null,
		"drawSite": func(_t, a): A.draw_site(a[0], _n(a, 1), _n(a, 2), J.str(a[3])); return null,
		"drawTree": func(_t, a): A.draw_tree(a[0], _n(a, 1), _n(a, 2), int(_n(a, 3)), _n(a, 4), J.t(_v(a, 5)), J.t(_v(a, 6)), int(_n(a, 7))); return null,
		"drawPaddy": func(_t, a): A.draw_paddy(a[0], _n(a, 1), _n(a, 2), _v(a, 3), _n(a, 4), int(_n(a, 5))); return null,
		"drawGate": func(_t, a): A.draw_gate(a[0], _n(a, 1), _n(a, 2), _n(a, 3)); return null,
		"drawDecor": func(_t, a): A.draw_decor(a[0], J.str(a[1]), _n(a, 2), _n(a, 3), _n(a, 4)); return null,
		"drawCrow": func(_t, a): A.draw_crow(a[0], _n(a, 1), _n(a, 2), _n(a, 3), _n(a, 4), _n(a, 5), J.t(_v(a, 6))); return null,
		"el": func(_t, a): A.el(a[0], _n(a, 1), _n(a, 2), _n(a, 3), _n(a, 4), _f(a, 5), _f(a, 6), _f(a, 7)); return null,
		"rr": func(_t, a): A.rr(a[0], _n(a, 1), _n(a, 2), _n(a, 3), _n(a, 4), _n(a, 5), _f(a, 6), _f(a, 7), _f(a, 8)); return null,
		"poly": func(_t, a): A.poly(a[0], a[1], _f(a, 2), _f(a, 3), _f(a, 4)); return null,
		"lantern": func(_t, a): lantern(a[0], _n(a, 1), _n(a, 2), _n(a, 3), _v(a, 4)); return null,
	}
