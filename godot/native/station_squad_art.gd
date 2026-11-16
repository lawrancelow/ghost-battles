# 原生改寫自 station_squad_art.js（陽間站崗 A／B 批美術：資料 data/nat/station_squad_art.json，再登記入 SPR／SPR_SRC）
extends RefCounted
func run(_env) -> void:
	preload("res://native/_datamod.gd").install("station_squad_art")   # STN_AB_SRC、STN_AB_NOLEG
	var d = {"STN_AB_SRC": J.G.STN_AB_SRC}
	var SPR = J.G.get("SPR")
	if SPR == null: return
	var SS = J.G.get("SPR_SRC")
	if SS != null: J.S_Object_("assign", [SS, d.STN_AB_SRC])
	for k in d.STN_AB_SRC:
		if J.t(J.gp(SPR, k)): continue
		var im = J.new_("Image", []); J.sp(im, "src", d.STN_AB_SRC[k])
		J.sp(SPR, k, im)
		var ok = func(_t, _a): J.sp(im, "_ok", true); return null
		if J.t(J.gp(im, "decode")): J.mc(J.mc(im, "decode", []), "then", [ok, func(_t, _a): J.sp(im, "onload", ok); return null])
		else: J.sp(im, "onload", ok)
