# L1 原生模塊對照：lang、lang_zh、chatter_data、story（同轉譯版比；故意改過嘅只容許 story_v2 列明嘅改動）
extends "res://tools/tests/native_xcheck.gd"

static func _subs() -> Array:
	var f = FileAccess.open("res://data/story_v2.json", FileAccess.READ)
	return JSON.parse_string(f.get_as_text()).subs

static func _sub(o, S: Array):
	if o is String:
		var s: String = o
		for p in S: s = s.replace(p[0], p[1])
		return s
	if o is Array: return o.map(func(x): return _sub(x, S))
	if o is Dictionary:
		var d = {}
		for k in o: d[_sub(k, S)] = _sub(o[k], S)
		return d
	return o

func eq(name: String, a, b) -> void:
	if JSON.stringify(a) == JSON.stringify(b): ok += 1
	else:
		bad += 1
		var sa = JSON.stringify(a); var sb = JSON.stringify(b); var i = 0
		while i < mini(sa.length(), sb.length()) and sa[i] == sb[i]: i += 1
		print("[xcheck-diff] %s at %d nat=…%s… tr=…%s…" % [name, i, sa.substr(maxi(0, i - 40), 120), sb.substr(maxi(0, i - 40), 120)])

func l1(_t) -> void:
	mod = "L1"
	var S = _subs()
	# ---- lang：函數 ----
	var natL = J.G.LANG
	var keepL = J.G.L; var keepLf = J.G.Lf
	var tr = load_trans("lang", ["LANG", "L", "Lf"])
	var trL = tr.LANG
	J.mc(trL, "add", [{"測試粵語": "測試中文", "{n}嚟咗": "{n}來了"}]); J.mc(natL, "add", [{"測試粵語": "測試中文", "{n}嚟咗": "{n}來了"}])
	for lang in ["zh", "yue"]:
		J.mc(trL, "set", [lang]); J.mc(natL, "set", [lang])
		eq("LANG.cur " + lang, J.gp(natL, "cur"), J.gp(trL, "cur"))
		eq("LANG.name " + lang, J.mc(natL, "name", []), J.mc(trL, "name", []))
		# L／Lf 讀 J.G.LANG：輪流換做各自嘅 LANG 嚟比
		for s in ["測試粵語", "冇呢句", 3.0, null]:
			J.G["LANG"] = natL; var x = J.cl(keepL, null, [s])
			J.G["LANG"] = trL; var y = J.cl(tr.L, null, [s])
			eq("L(%s) %s" % [str(s), lang], x, y)
		J.G["LANG"] = natL; var a = J.cl(keepLf, null, ["{n}嚟咗", {"n": "阿福"}])
		J.G["LANG"] = trL; var b = J.cl(tr.Lf, null, ["{n}嚟咗", {"n": "阿福"}])
		eq("Lf " + lang, a, b)
	J.G["LANG"] = natL
	eq("LANG.toggle", J.mc(natL, "toggle", []), J.mc(trL, "toggle", []))
	J.mc(natL, "set", ["zh"])
	# ---- lang_zh：轉譯版加入嘅對照，原生版（換品牌後）全部都有 ----
	var probe = {"ZH": {}, "add": func(_t, a): for k in a[0]: probe_add(k, a[0][k])}
	_probe = {}
	J.G["LANG"] = {"add": func(_t, a): for k in a[0]: _probe[k] = a[0][k]}
	var m = load("res://jsgen/lang_zh.gd").new(); _keep_alive.append(m); m.run(null)
	J.G["LANG"] = natL
	var miss = 0
	for k in _probe:
		var k2 = _sub(k, S)
		if J.str(J.gp(natL.ZH, k)) != _sub(_probe[k], S) or J.str(J.gp(natL.ZH, k2)) != _sub(_probe[k], S): miss += 1
	eq("lang_zh entries missing", miss, 0)
	# ---- chatter_data ----
	var trc = load_trans("chatter_data", ["CHAT_DATA"]).CHAT_DATA
	# 任務系統（QX._pgchat）會喺執行時補 pg_* 名鬼入 named：比之前除走
	var nc = J.G.CHAT_DATA.duplicate(true)
	for k in nc.named.keys(): if str(k).begins_with("pg_") and not trc.named.has(k): nc.named.erase(k)
	eq("CHAT_DATA", nc, _sub(trc, S))
	# ---- story ----
	var keys = ["SCENES", "SCENE_ORDER", "PRAISE_CHOP", "PRAISE_RICE", "PRAISE_CRAFT", "PRAISE_KIND", "LEVEL_UNLOCKS", "CHATTER", "FLAVOR", "WIN_QUIPS", "LOSE_QUIPS", "STANDUP"]
	var trs = load_trans("story", keys)
	var f = FileAccess.open("res://data/story_v2.json", FileAccess.READ)
	var v2 = JSON.parse_string(f.get_as_text())
	for k in keys:
		if k == "SCENES":
			var ts = _sub(trs.SCENES, S); var ns = J.G.SCENES
			for id in ts:
				if v2.scenes.has(id):
					# 改寫過：講者次序同其他欄位要一樣（ch3_intro2、ch6_boss 有新增行）
					var a2 = ns[id].duplicate(); var b2 = ts[id].duplicate(); a2.erase("lines"); b2.erase("lines"); eq("SCENES.%s fields" % id, a2, b2)
					if id != "ch3_intro2" and id != "ch6_boss": eq("SCENES.%s speakers" % id, ns[id].lines.map(func(l): return l[0]), ts[id].lines.map(func(l): return l[0]))
					# 中文模式顯示嘅字 = 轉譯版原文（除咗故意改嘅）
					var shown = ns[id].lines.map(func(l): return J.str(J.cl(J.G.L, null, [l[1]])))
					var orig = ts[id].lines.map(func(l): return l[1])
					var diff = 0
					for s in shown: if not orig.has(s): diff += 1
					var allow = {"prologue_road": 1, "ch3_intro2": 3, "ch6_boss": 3}.get(id, 0)
					eq("SCENES.%s zh-shown changed lines" % id, diff, allow)
				else: eq("SCENES." + id, ns.get(id), ts[id])
		elif k == "SCENE_ORDER":
			# 原生（core.json）已經插咗 XO 串場；轉譯版要等 standup 先插 → 只比原本嗰啲 id 次序
			var ok2 = true
			for i in trs.SCENE_ORDER.size():
				var tids: Array = trs.SCENE_ORDER[i][1]; var nids: Array = J.G.SCENE_ORDER[i][1]
				if J.G.SCENE_ORDER[i][0] != trs.SCENE_ORDER[i][0] or nids.filter(func(x): return tids.has(x)) != tids: ok2 = false
			eq("SCENE_ORDER", ok2, true)
		elif k == "CHATTER":
			# core.json 版本係擴充過嘅（多咗 pg_* 同粵語句）：轉譯版每一句原生版都要有
			var missing = 0
			for g in trs.CHATTER:
				var nl = J.G.CHATTER.get(g, [])
				for l in _sub(trs.CHATTER[g], S): if not nl.has(l): missing += 1
			eq("CHATTER missing lines", missing, 0)
		else: eq(k, J.G[k], _sub(trs[k], S))
	_report()

var _probe := {}
func probe_add(k, v) -> void: _probe[k] = v
