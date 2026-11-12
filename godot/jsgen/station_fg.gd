# 自動轉譯自 station_fg.js（tools/jsgd.js）——唔好直接改，改原 JS 再轉
extends RefCounted

func run(env):
	var this_ = null; var a = []
	J.G["STN_FG_img"] = Callable(self, "_f1").bind(env)
	J.G["STN_FG_preload"] = Callable(self, "_f2").bind(env)
	J.G["STN_FG_list"] = Callable(self, "_f4").bind(env)
	J.G["STN_FG_draw"] = Callable(self, "_f6").bind(env)
	J.G["STN_FG_W"] = 768.0
	J.G["STN_FG_H"] = 1152.0
	J.G["STN_FG"] = {"flat": [[{"k": "bikes", "x": 595.0, "y": 716.0, "w": 143.0, "h": 127.0, "baseY": 843.0, "hide": false, "src": "res://assets/img/station_fg/bikes.webp"}, {"k": "mailL", "x": 205.0, "y": 539.0, "w": 36.0, "h": 195.0, "baseY": 734.0, "hide": false, "src": "res://assets/img/station_fg/mailL.webp"}, {"k": "mailR", "x": 447.0, "y": 545.0, "w": 32.0, "h": 183.0, "baseY": 728.0, "hide": false, "src": "res://assets/img/station_fg/mailR.webp"}], [{"k": "cage", "x": 226.0, "y": 591.0, "w": 335.0, "h": 187.0, "baseY": 778.0, "hide": true, "src": "res://assets/img/station_fg/cage.webp"}, {"k": "ebox", "x": 25.0, "y": 816.0, "w": 98.0, "h": 142.0, "baseY": 958.0, "hide": false, "src": "res://assets/img/station_fg/ebox.webp"}, {"k": "pallet", "x": 151.0, "y": 870.0, "w": 79.0, "h": 150.0, "baseY": 1018.0, "hide": false, "src": "res://assets/img/station_fg/pallet.webp"}], [{"k": "block", "x": 205.0, "y": 335.0, "w": 267.0, "h": 247.0, "baseY": 582.0, "hide": true, "src": "res://assets/img/station_fg/block.webp"}, {"k": "jar", "x": 580.0, "y": 527.0, "w": 31.0, "h": 46.0, "baseY": 573.0, "hide": false, "src": "res://assets/img/station_fg/jar.webp"}, {"k": "plant", "x": 636.0, "y": 502.0, "w": 29.0, "h": 59.0, "baseY": 561.0, "hide": false, "src": "res://assets/img/station_fg/plant.webp"}], [{"k": "tank", "x": 245.0, "y": 367.0, "w": 275.0, "h": 377.0, "baseY": 732.0, "hide": true, "src": "res://assets/img/station_fg/tank.webp"}, {"k": "aircon2", "x": 37.0, "y": 778.0, "w": 59.0, "h": 173.0, "baseY": 951.0, "hide": false, "src": "res://assets/img/station_fg/aircon2.webp"}, {"k": "clothes", "x": 288.0, "y": 885.0, "w": 182.0, "h": 86.0, "baseY": 955.0, "hide": false, "src": "res://assets/img/station_fg/clothes.webp"}]], "office": [[{"k": "cubicle", "x": 302.0, "y": 324.0, "w": 264.0, "h": 92.0, "baseY": 416.0, "hide": true, "src": "res://assets/img/station_fg/cubicle.webp"}, {"k": "cubicle2", "x": 293.0, "y": 585.0, "w": 306.0, "h": 166.0, "baseY": 751.0, "hide": false, "src": "res://assets/img/station_fg/cubicle2.webp"}], [{"k": "shelfA", "x": 283.0, "y": 230.0, "w": 99.0, "h": 230.0, "baseY": 454.0, "hide": true, "src": "res://assets/img/station_fg/shelfA.webp"}, {"k": "shelfB", "x": 451.0, "y": 244.0, "w": 65.0, "h": 191.0, "baseY": 435.0, "hide": false, "src": "res://assets/img/station_fg/shelfB.webp"}, {"k": "shelfC", "x": 216.0, "y": 522.0, "w": 326.0, "h": 204.0, "baseY": 723.0, "hide": true, "src": "res://assets/img/station_fg/shelfC.webp"}, {"k": "shelfD", "x": 230.0, "y": 806.0, "w": 254.0, "h": 147.0, "baseY": 953.0, "hide": false, "src": "res://assets/img/station_fg/shelfD.webp"}], [{"k": "cabinet", "x": 47.0, "y": 418.0, "w": 53.0, "h": 201.0, "baseY": 619.0, "hide": true, "src": "res://assets/img/station_fg/cabinet.webp"}, {"k": "fridge", "x": 205.0, "y": 811.0, "w": 70.0, "h": 228.0, "baseY": 1039.0, "hide": false, "src": "res://assets/img/station_fg/fridge.webp"}, {"k": "plant", "x": 673.0, "y": 292.0, "w": 48.0, "h": 90.0, "baseY": 382.0, "hide": false, "src": "res://assets/img/station_fg/plant_1.webp"}], [{"k": "cabinet", "x": 34.0, "y": 783.0, "w": 82.0, "h": 175.0, "baseY": 958.0, "hide": true, "src": "res://assets/img/station_fg/cabinet_1.webp"}, {"k": "shelf", "x": 262.0, "y": 853.0, "w": 227.0, "h": 116.0, "baseY": 964.0, "hide": false, "src": "res://assets/img/station_fg/shelf.webp"}, {"k": "plant", "x": 139.0, "y": 844.0, "w": 35.0, "h": 114.0, "baseY": 958.0, "hide": false, "src": "res://assets/img/station_fg/plant_2.webp"}]], "cafe": [[{"k": "teashelf", "x": 649.0, "y": 482.0, "w": 81.0, "h": 177.0, "baseY": 659.0, "hide": true, "src": "res://assets/img/station_fg/teashelf.webp"}, {"k": "shelf", "x": 53.0, "y": 289.0, "w": 78.0, "h": 61.0, "baseY": 349.0, "hide": false, "src": "res://assets/img/station_fg/shelf_1.webp"}], [{"k": "fridge", "x": 553.0, "y": 103.0, "w": 76.0, "h": 140.0, "baseY": 243.0, "hide": false, "src": "res://assets/img/station_fg/fridge_1.webp"}, {"k": "shelfL", "x": 40.0, "y": 631.0, "w": 73.0, "h": 206.0, "baseY": 837.0, "hide": true, "src": "res://assets/img/station_fg/shelfL.webp"}], [{"k": "shelves", "x": 19.0, "y": 107.0, "w": 189.0, "h": 322.0, "baseY": 429.0, "hide": true, "src": "res://assets/img/station_fg/shelves.webp"}, {"k": "gas", "x": 603.0, "y": 487.0, "w": 112.0, "h": 166.0, "baseY": 653.0, "hide": false, "src": "res://assets/img/station_fg/gas.webp"}, {"k": "ricebags", "x": 142.0, "y": 850.0, "w": 211.0, "h": 155.0, "baseY": 1005.0, "hide": true, "src": "res://assets/img/station_fg/ricebags.webp"}], [{"k": "crates", "x": 259.0, "y": 345.0, "w": 214.0, "h": 241.0, "baseY": 576.0, "hide": true, "src": "res://assets/img/station_fg/crates.webp"}, {"k": "clothes", "x": 165.0, "y": 758.0, "w": 192.0, "h": 126.0, "baseY": 884.0, "hide": false, "src": "res://assets/img/station_fg/clothes_1.webp"}, {"k": "dumpster", "x": 610.0, "y": 603.0, "w": 139.0, "h": 127.0, "baseY": 730.0, "hide": false, "src": "res://assets/img/station_fg/dumpster.webp"}]], "bus": [[{"k": "phone", "x": 120.0, "y": 181.0, "w": 91.0, "h": 151.0, "baseY": 330.0, "hide": false, "src": "res://assets/img/station_fg/phone.webp"}, {"k": "kiosk", "x": 223.0, "y": 793.0, "w": 234.0, "h": 165.0, "baseY": 958.0, "hide": true, "src": "res://assets/img/station_fg/kiosk.webp"}, {"k": "tree", "x": 144.0, "y": 316.0, "w": 281.0, "h": 334.0, "baseY": 639.0, "hide": true, "src": "res://assets/img/station_fg/tree.webp"}], [{"k": "pillar", "x": 307.0, "y": 401.0, "w": 166.0, "h": 287.0, "baseY": 688.0, "hide": true, "src": "res://assets/img/station_fg/pillar.webp"}, {"k": "vending", "x": 124.0, "y": 218.0, "w": 98.0, "h": 167.0, "baseY": 381.0, "hide": false, "src": "res://assets/img/station_fg/vending.webp"}], [{"k": "lockers", "x": 503.0, "y": 107.0, "w": 169.0, "h": 143.0, "baseY": 250.0, "hide": false, "src": "res://assets/img/station_fg/lockers.webp"}, {"k": "rack", "x": 27.0, "y": 695.0, "w": 108.0, "h": 85.0, "baseY": 780.0, "hide": false, "src": "res://assets/img/station_fg/rack.webp"}], [{"k": "bus", "x": 203.0, "y": 265.0, "w": 366.0, "h": 443.0, "baseY": 696.0, "hide": true, "src": "res://assets/img/station_fg/bus.webp"}, {"k": "hut", "x": 176.0, "y": 103.0, "w": 118.0, "h": 124.0, "baseY": 223.0, "hide": true, "src": "res://assets/img/station_fg/hut.webp"}, {"k": "shed", "x": 349.0, "y": 856.0, "w": 323.0, "h": 137.0, "baseY": 993.0, "hide": false, "src": "res://assets/img/station_fg/shed.webp"}]], "market": [[{"k": "stallC", "x": 195.0, "y": 309.0, "w": 334.0, "h": 288.0, "baseY": 582.0, "hide": true, "src": "res://assets/img/station_fg/stallC.webp"}, {"k": "stallB", "x": 222.0, "y": 756.0, "w": 250.0, "h": 202.0, "baseY": 958.0, "hide": true, "src": "res://assets/img/station_fg/stallB.webp"}, {"k": "stallR", "x": 618.0, "y": 263.0, "w": 123.0, "h": 223.0, "baseY": 486.0, "hide": false, "src": "res://assets/img/station_fg/stallR.webp"}], [{"k": "crates", "x": 27.0, "y": 205.0, "w": 54.0, "h": 247.0, "baseY": 452.0, "hide": false, "src": "res://assets/img/station_fg/crates_1.webp"}, {"k": "bin", "x": 664.0, "y": 643.0, "w": 85.0, "h": 91.0, "baseY": 734.0, "hide": false, "src": "res://assets/img/station_fg/bin.webp"}, {"k": "cratesL", "x": 25.0, "y": 574.0, "w": 48.0, "h": 137.0, "baseY": 711.0, "hide": false, "src": "res://assets/img/station_fg/cratesL.webp"}], [{"k": "tents", "x": 179.0, "y": 311.0, "w": 424.0, "h": 381.0, "baseY": 676.0, "hide": true, "src": "res://assets/img/station_fg/tents.webp"}, {"k": "bedR", "x": 652.0, "y": 643.0, "w": 93.0, "h": 264.0, "baseY": 907.0, "hide": false, "src": "res://assets/img/station_fg/bedR.webp"}], [{"k": "truck", "x": 262.0, "y": 360.0, "w": 272.0, "h": 286.0, "baseY": 642.0, "hide": true, "src": "res://assets/img/station_fg/truck.webp"}, {"k": "tree", "x": 618.0, "y": 234.0, "w": 127.0, "h": 205.0, "baseY": 443.0, "hide": false, "src": "res://assets/img/station_fg/tree_1.webp"}, {"k": "durian", "x": 23.0, "y": 673.0, "w": 240.0, "h": 308.0, "baseY": 980.0, "hide": true, "src": "res://assets/img/station_fg/durian.webp"}]]}
	J.G["STN_FG_IMG"] = {}
	if (not J.seq(J.typeof_(J.G.get("window")), "undefined")):
		J.S_Object_("assign", [J.G.get("window"), {"STN_FG": J.G.get("STN_FG"), "STN_FG_W": J.G.get("STN_FG_W"), "STN_FG_H": J.G.get("STN_FG_H"), "STN_FG_draw": J.G.get("STN_FG_draw"), "STN_FG_list": J.G.get("STN_FG_list"), "STN_FG_preload": J.G.get("STN_FG_preload")}])

func _f1(this_, a: Array, env):
	var v_it_11 = null; var v_im_12 = null
	v_it_11 = J.arg(a, 0)
	v_im_12 = J.gp(J.G.get("STN_FG_IMG"), J.add((J.add(J.add(J.len(J.gp(v_it_11, "src")), ":"), J.gp(v_it_11, "x")) + ":"), J.gp(v_it_11, "y")))
	if (not J.t(v_im_12)):
		var _t1 = J.new_("Image", [])
		v_im_12 = _t1
		var _t2 = J.gp(v_it_11, "src")
		J.sp(v_im_12, "src", _t2)
		var _t3 = J.G.get("STN_FG_IMG")
		var _t4 = J.add((J.add(J.add(J.len(J.gp(v_it_11, "src")), ":"), J.gp(v_it_11, "x")) + ":"), J.gp(v_it_11, "y"))
		J.sp(_t3, _t4, v_im_12)
	return v_im_12

func _f3(this_, a: Array, env):
	var v_p_17 = null
	v_p_17 = J.arg(a, 0)
	return J.mc(v_p_17, "forEach", [J.G.get("STN_FG_img")])

func _f2(this_, a: Array, env):
	var v_site_15 = null; var v_s_16 = null
	v_site_15 = J.arg(a, 0)
	for _t5 in J.keys(J.G.get("STN_FG")):
		v_s_16 = _t5
		var _t6 = (not J.t(v_site_15))
		if (_t6 if _t6 else J.seq(v_s_16, v_site_15)):
			var _t7 = J.gp(J.G.get("STN_FG"), v_s_16)
			J.mc(_t7, "forEach", [Callable(self, "_f3").bind(env)])

func _f5(this_, a: Array, env):
	var v_it_24 = null
	v_it_24 = J.arg(a, 0)
	return J.cmp(J.gp(v_it_24, "baseY"), env["footY"], ">")

func _f4(this_, a: Array, env):
	var v_site_20 = null; var v_panelIndex_21 = null; var v_P_23 = null
	var _s7 = {"__p": env, "footY": null}
	v_site_20 = J.arg(a, 0)
	v_panelIndex_21 = J.arg(a, 1)
	_s7["footY"] = J.arg(a, 2)
	var _t8 = J.gp(J.G.get("STN_FG"), v_site_20)
	var _t9 = J.gp((_t8 if J.t(_t8) else []), v_panelIndex_21)
	v_P_23 = (_t9 if J.t(_t9) else [])
	return (v_P_23 if J.leq(_s7["footY"], null) else J.mc(v_P_23, "filter", [Callable(self, "_f5").bind(_s7)]))

func _f6(this_, a: Array, env):
	var v_ctx_27 = null; var v_site_28 = null; var v_panelIndex_29 = null; var v_ox_30 = null; var v_oy_31 = null; var v_scale_32 = null; var v_only_33 = null; var v_P_34 = null; var v_it_35 = null; var v_im_36 = null
	v_ctx_27 = J.arg(a, 0)
	v_site_28 = J.arg(a, 1)
	v_panelIndex_29 = J.arg(a, 2)
	v_ox_30 = J.arg(a, 3)
	v_oy_31 = J.arg(a, 4)
	v_scale_32 = J.arg(a, 5)
	v_only_33 = J.arg(a, 6)
	var _t11 = null
	if J.t(v_only_33):
		_t11 = [v_only_33]
	else:
		var _t10 = J.G.get("STN_FG_list")
		_t11 = J.cl(_t10, null, [v_site_28, v_panelIndex_29])
	v_P_34 = _t11
	for _t12 in J.iter(v_P_34):
		v_it_35 = _t12
		var _t13 = J.G.get("STN_FG_img")
		v_im_36 = J.cl(_t13, null, [v_it_35])
		var _t14 = (not J.t(J.gp(v_im_36, "complete")))
		if (_t14 if _t14 else (not J.t(J.gp(v_im_36, "naturalWidth")))):
			continue
		J.mc(v_ctx_27, "drawImage", [v_im_36, J.add(v_ox_30, J.mul(J.gp(v_it_35, "x"), v_scale_32)), J.add(v_oy_31, J.mul(J.gp(v_it_35, "y"), v_scale_32)), J.mul(J.gp(v_it_35, "w"), v_scale_32), J.mul(J.gp(v_it_35, "h"), v_scale_32)])
