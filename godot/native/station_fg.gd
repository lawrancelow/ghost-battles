# 原生改寫自 station_fg.js（陽間站崗前景遮擋：資料 data/nat/station_fg.json＋圖片快取／列表／畫）
extends RefCounted

static func _key(it) -> String:
	return "%s:%s:%s" % [J.str(J.len(J.gp(it, "src"))), J.str(J.gp(it, "x")), J.str(J.gp(it, "y"))]

static func img(it):
	var C = J.G.STN_FG_IMG; var k = _key(it)
	var im = C.get(k)
	if not J.t(im): im = J.new_("Image", []); J.sp(im, "src", J.gp(it, "src")); C[k] = im
	return im

static func preload_(site) -> void:
	var FG = J.G.STN_FG
	for s in FG:
		if not J.t(site) or s == J.str(site):
			for p in FG[s]:
				for it in p: img(it)

static func list(site, panel_index, foot_y):
	var FG = J.G.STN_FG
	var sp = FG.get(J.str(site), [])
	var i = int(J.num(panel_index))
	var P = sp[i] if sp is Array and i >= 0 and i < sp.size() else []
	if foot_y == null: return P
	var out = []
	for it in P: if J.num(it.baseY) > J.num(foot_y): out.append(it)
	return out

static func draw(ctx, site, panel_index, ox, oy, scale, only) -> void:
	var P = [only] if J.t(only) else list(site, panel_index, null)
	for it in P:
		var im = img(it)
		if not J.t(J.gp(im, "complete")) or not J.t(J.gp(im, "naturalWidth")): continue
		var k = J.num(scale)
		J.mc(ctx, "drawImage", [im, J.num(ox) + J.num(it.x) * k, J.num(oy) + J.num(it.y) * k, J.num(it.w) * k, J.num(it.h) * k])

func run(_env) -> void:
	preload("res://native/_datamod.gd").install("station_fg")   # STN_FG、STN_FG_W、STN_FG_H
	J.G["STN_FG_img"] = func(_t, a): return img(J.arg(a, 0))
	J.G["STN_FG_preload"] = func(_t, a): preload_(J.arg(a, 0)); return null
	J.G["STN_FG_list"] = func(_t, a): return list(J.arg(a, 0), J.arg(a, 1), J.arg(a, 2))
	J.G["STN_FG_draw"] = func(_t, a): draw(J.arg(a, 0), J.arg(a, 1), J.arg(a, 2), J.arg(a, 3), J.arg(a, 4), J.arg(a, 5), J.arg(a, 6)); return null
	J.G["STN_FG_IMG"] = {}
	var w = J.G.get("window")
	if w != null: J.S_Object_("assign", [w, {"STN_FG": J.G.STN_FG, "STN_FG_W": J.G.STN_FG_W, "STN_FG_H": J.G.STN_FG_H, "STN_FG_draw": J.G.STN_FG_draw, "STN_FG_list": J.G.STN_FG_list, "STN_FG_preload": J.G.STN_FG_preload}])
