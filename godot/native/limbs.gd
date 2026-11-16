# 原生改寫自 limbs.js（拆手揮武器）：實作喺 core/limbs.gd（autoload Limbs），呢度只係 JS 介面
extends RefCounted

func run(_env) -> void:
	var L = Engine.get_main_loop().root.get_node("Limbs")
	# 用 limbdata 嘅最新資料（DB.RIGS.LIMBS 係舊版，冇阿福等）
	var LD = J.G.get("LIMBS_DATA")
	if LD is Dictionary: L.CH = LD.get("chars", {}); L.WP = LD.get("weapons", {}); L._kn.clear()
	J.G["Limbs"] = {
		"has": func(_t, a): return L.has(J.str(J.arg(a, 0))),
		"stateOf": func(_t, a): return L.state_of(J.str(J.arg(a, 0)), J.arg(a, 1), J.num(J.arg(a, 2))),
		"weaponOf": func(_t, a): return L.weapon_of(J.str(J.arg(a, 0)), J.arg(a, 1) if J.t(J.arg(a, 1)) else null),
		"draw": func(_t, a):
			var mp = J.arg(a, 7)
			return L.draw(a[0], J.str(a[1]), J.num(a[2]), J.num(a[3]), J.num(a[4]), a[5] if a[5] is Dictionary else {}, J.t(J.arg(a, 6)), mp if mp is Dictionary else {}),
	}
