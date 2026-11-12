# 自動轉譯自 station_squad_art.js（tools/jsgd.js）——唔好直接改，改原 JS 再轉
extends RefCounted

func run(env):
	var this_ = null; var a = []
	J.G["STN_AB_SRC"] = {"pb_sq_host": "res://assets/img/station_squad_art/pb_sq_host.webp", "pb_sq_cam": "res://assets/img/station_squad_art/pb_sq_cam.webp", "pb_sq_aide": "res://assets/img/station_squad_art/pb_sq_aide.webp", "pb_sq_live": "res://assets/img/station_squad_art/pb_sq_live.webp", "pb_sq_lead": "res://assets/img/station_squad_art/pb_sq_lead.webp", "pb_sq_vcam": "res://assets/img/station_squad_art/pb_sq_vcam.webp", "pb_sq_torch": "res://assets/img/station_squad_art/pb_sq_torch.webp", "pb_sq_sound": "res://assets/img/station_squad_art/pb_sq_sound.webp", "pb_guide": "res://assets/img/station_squad_art/pb_guide.webp", "pb_ghostclub": "res://assets/img/station_squad_art/pb_ghostclub.webp", "pb_walkdel": "res://assets/img/station_squad_art/pb_walkdel.webp", "pb_hawker": "res://assets/img/station_squad_art/pb_hawker.webp", "vfx_ghost_rise": "res://assets/img/station_squad_art/vfx_ghost_rise.webp", "vfx_ghost_lunge": "res://assets/img/station_squad_art/vfx_ghost_lunge.webp", "vfx_ghost_smoke": "res://assets/img/station_squad_art/vfx_ghost_smoke.webp", "vfx_hand_crack": "res://assets/img/station_squad_art/vfx_hand_crack.webp", "vfx_mist_ring": "res://assets/img/station_squad_art/vfx_mist_ring.webp", "vfx_water_hands": "res://assets/img/station_squad_art/vfx_water_hands.webp", "vfx_frost": "res://assets/img/station_squad_art/vfx_frost.webp", "vfx_seal": "res://assets/img/station_squad_art/vfx_seal.webp"}
	J.G["STN_AB_NOLEG"] = {"pb_sq_live": 1.0, "pb_hawker": 1.0}
	J.cl(Callable(self, "_f1").bind(env), null, [])

func _f2(this_, a: Array, env):
	var _t6 = env["im"]
	J.sp(_t6, "_ok", true)

func _f3(this_, a: Array, env):
	var _t8 = env["im"]
	var _t9 = env["ok"]
	J.sp(_t8, "onload", _t9)

func _f1(this_, a: Array, env):
	var v_k_3 = null
	if J.seq(J.typeof_(J.G.get("SPR")), "undefined"):
		return null
	if (not J.seq(J.typeof_(J.G.get("SPR_SRC")), "undefined")):
		J.S_Object_("assign", [J.G.get("SPR_SRC"), J.G.get("STN_AB_SRC")])
	for _t1 in J.keys(J.G.get("STN_AB_SRC")):
		v_k_3 = _t1
		var _s4 = {"__p": env, "im": null, "ok": null}
		if J.t(J.gp(J.G.get("SPR"), v_k_3)):
			continue
		_s4["im"] = J.new_("Image", [])
		var _t2 = _s4["im"]
		var _t3 = J.gp(J.G.get("STN_AB_SRC"), v_k_3)
		J.sp(_t2, "src", _t3)
		var _t4 = J.G.get("SPR")
		var _t5 = _s4["im"]
		J.sp(_t4, v_k_3, _t5)
		_s4["ok"] = Callable(self, "_f2").bind(_s4)
		if J.t(J.gp(_s4["im"], "decode")):
			var _t7 = J.mc(_s4["im"], "decode", [])
			J.mc(_t7, "then", [_s4["ok"], Callable(self, "_f3").bind(_s4)])
		else:
			var _t10 = _s4["im"]
			var _t11 = _s4["ok"]
			J.sp(_t10, "onload", _t11)
