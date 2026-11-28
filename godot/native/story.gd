# 原生改寫自 story.js：劇本資料（SCENES、劇情回顧次序、系統誇獎、等級解鎖、碎碎念、建築一句話、勝負句、棟篤笑）
# 資料用 DB.D（data/core.json），再疊 data/story_v2.json：主線對白改做粵語原句（中文入 LANG）、新伏筆、換走真實品牌名
# J.G 同 DB.D 共用同一份物件：原生劇情框（ui/story.gd 讀 DB.D.SCENES）同 JS 睇到嘅一致
extends RefCounted

const KEYS := ["SCENES", "SCENE_ORDER", "PRAISE_CHOP", "PRAISE_RICE", "PRAISE_CRAFT", "PRAISE_KIND", "LEVEL_UNLOCKS", "CHATTER", "FLAVOR", "WIN_QUIPS", "LOSE_QUIPS", "STANDUP"]
static var applied := false
static var SUBS: Array = []
static var ZH2: Dictionary = {}

static func sub(o):
	if o is String:
		var s: String = o
		for p in SUBS: s = s.replace(p[0], p[1])
		return s
	if o is Array:
		for i in o.size(): o[i] = sub(o[i])
		return o
	if o is Dictionary:
		for k in o.keys(): o[k] = sub(o[k])
		return o
	return o

static func apply_v2() -> void:
	if applied: return
	applied = true
	var f = FileAccess.open("res://data/story_v2.json", FileAccess.READ)
	var v2 = JSON.parse_string(f.get_as_text()) if f else null
	if not (v2 is Dictionary): return
	SUBS = v2.get("subs", [])
	var D = DB.D
	for k in KEYS: if D.has(k): sub(D[k])
	var sc: Dictionary = D.SCENES
	for id in v2.scenes: sc[id] = v2.scenes[id]
	# 中文對照：入 DB（原生劇情框）同 JS LANG
	ZH2 = v2.get("zh", {})
	var yue = v2.get("yue", {})   # [opening] 中文原句 → 粵語（文案組補；空字串＝未補）
	if yue is Dictionary:
		if not (D.get("LANG_YUE") is Dictionary): D["LANG_YUE"] = {}
		for k in yue: D.LANG_YUE[k] = yue[k]
	var dz = D.get("LANG_ZH")
	if dz is Dictionary:
		for k in dz.keys():   # 被替換嘅粵語原句：新句都要有中文
			var k2 = sub(k)
			if k2 != k and not ZH2.has(k2): ZH2[k2] = sub(dz[k])
		for k in ZH2: dz[k] = ZH2[k]

func run(_env) -> void:
	apply_v2()
	var LANG = J.G.get("LANG")   # 每次載入（重開遊戲會重建 LANG）都要加
	if LANG != null: J.mc(LANG, "add", [ZH2])
	for k in KEYS: J.G[k] = DB.D.get(k)
