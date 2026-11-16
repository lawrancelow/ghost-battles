# L5（動畫與日常）原生改寫對照
extends "res://tools/tests/native_xcheck.gd"

func eqv(name: String, a, b) -> void:
	if JSON.stringify(a) == JSON.stringify(b): ok += 1
	else:
		bad += 1
		var sa = JSON.stringify(a); var sb = JSON.stringify(b); var i = 0
		while i < mini(sa.length(), sb.length()) and sa[i] == sb[i]: i += 1
		print("[xcheck-diff] %s @%d nat=%s tr=%s" % [name, i, sa.substr(maxi(0, i - 40), 120), sb.substr(maxi(0, i - 40), 120)])

static func _cap_rigs(scr_path: String):
	var P = J.G.Puppet; var orig = P.addRigs; var got = [null]
	P["addRigs"] = func(_t, a): got[0] = JSON.parse_string(JSON.stringify(a[0])); return null
	var m = load(scr_path).new(); _keep_alive.append(m); m.run(null)
	P["addRigs"] = orig
	return got[0]

func data(_t) -> void:
	mod = "l5_data"
	var tr = load_trans("limbdata", ["LIMBS_DATA"])
	eqv("LIMBS_DATA", J.G.LIMBS_DATA, tr.LIMBS_DATA)
	eqv("rigs", _cap_rigs("res://native/rigs.gd"), _cap_rigs("res://jsgen/rigs.gd"))
	eqv("DAILY.keys", J.G.DAILY.keys().size() > 50, true)
	eqv("MOVES.keys", J.G.MOVES.keys().size() > 20, true)
	print("[xc] DAILY=%d MOVES=%d" % [J.G.DAILY.size(), J.G.MOVES.size()])
	_report()
