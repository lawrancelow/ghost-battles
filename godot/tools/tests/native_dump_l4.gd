# L4：把資料模塊（轉譯版跑完之後嘅全局）倒成 JSON（_datamod 格式：{全局名: 值}；patrol_ghosts 係自訂格式），之後抄去 data/nat/
# 要用 GB_NONAT=1 開機（全部轉譯版），然後 ["gdrun","res://tools/tests/native_dump_l4.gd","dump"]
extends RefCounted

const OUT := "/tmp/L4_dump/nat"

static func _w(name: String, v) -> void:
	DirAccess.make_dir_recursive_absolute(OUT)
	var f = FileAccess.open(OUT + "/" + name + ".json", FileAccess.WRITE)
	f.store_string(JSON.stringify(v, "", false, true)); f.close()
	print("[dump] ", name, " ", JSON.stringify(v).length())

func dump(_t) -> void:
	_w("station_fg", {"STN_FG": J.G.STN_FG, "STN_FG_W": J.G.STN_FG_W, "STN_FG_H": J.G.STN_FG_H})
	_w("station_props", {"STN_PROPS": J.G.STN_PROPS})
	_w("station_squad_art", {"STN_AB_SRC": J.G.STN_AB_SRC, "STN_AB_NOLEG": J.G.STN_AB_NOLEG})
	_w("patrol_assets", {"PT_IMG_SRC": J.G.PT_IMG_SRC})
	# patrol_ghosts：GHOSTS／SKILLS／ENEMY_T 嘅 pg 條目、hantugalah 改動、LANG.add 嘅 ZH
	var keys = J.gp(J.G.PG_GHOSTS, "keys")
	var gh = {}; var sk = {}; var en = {}
	for k in keys: gh[k] = J.G.GHOSTS[k]; sk[k] = J.G.SKILLS[k]; en[k] = J.G.ENEMY_T[k]
	var hg = J.G.GHOSTS.get("n30_hantugalah")
	var hsay = hg.say if hg != null else null; var hlore = hg.lore if hg != null else null
	# 攞 ZH：包住 LANG.add 再跑多次轉譯版（之後唔再用呢個進程）
	var LANG = J.G.LANG; var orig = LANG.add; var cap = []
	LANG["add"] = func(t, a): cap.append(a[0]); return J.cl(orig, t, a)
	var scr: GDScript = load("res://jsgen/patrol_ghosts.gd"); var m = scr.new(); m.run(null)
	LANG["add"] = orig
	if cap.size():   # hantugalah 嘅 lore 譯文由原生模塊自己計（重跑會令 lore 疊多次）
		for zk in cap[0].keys(): if J.str(zk).contains("KS08《不要抬頭》"): cap[0].erase(zk)
	_w("patrol_ghosts", {"keys": keys, "GHOSTS": gh, "SKILLS": sk, "ENEMY_T": en, "hsay": hsay, "hlore": hlore, "ZH": cap[0] if cap.size() else {}, "H": {"pg_tuimo": 58, "pg_songding": 58, "pg_ji": 54, "pg_ex": 60, "pg_landlady": 60}})

# scare_ops：OPS／PANTRY／TAB／INTEL_NAME 同 D() 加落 LANG 嘅譯文 → /tmp/L4_dump/nat/scare_ops.json
func dump_ops(_t) -> void:
	var LANG = J.G.LANG; var orig = LANG.add; var zh = {}
	LANG["add"] = func(t, a):
		if a.size() and a[0] is Dictionary: for k in a[0]: zh[k] = a[0][k]
		return J.cl(orig, t, a)
	var keep = J.G.get("ScareOps")
	var scr: GDScript = load("res://jsgen/scare_ops.gd"); var m = scr.new(); m.run(null)
	LANG["add"] = orig
	var SO = J.G.ScareOps; J.G["ScareOps"] = keep
	_w("scare_ops", {"OPS": SO.OPS, "PANTRY": SO.PANTRY, "TAB": SO.TAB, "INTEL_NAME": SO.INTEL_NAME, "ZH": zh})
