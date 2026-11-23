# [abui stub] 能力引擎最小替身——只為畫面線（abui）喺 abcore 未合併前有嘢讀。
#   ★整合時以 abcore 版 game/rts/abil.gd 為準（成個檔蓋走都得）；畫面線只用以下介面（照 STAGE1）：
#     AB.on()、AB.data()、AB.mechs_of(k)、AB.tags_of(k)、AB.counters_of(m)、AB.describe(k)
#   冇 class_name；用 const AB = preload("res://game/rts/abil.gd")
extends RefCounted

static var D = null

static func data() -> Dictionary:
	if D == null:
		D = {}
		if FileAccess.file_exists("res://data/abil.json"):
			var f = FileAccess.open("res://data/abil.json", FileAccess.READ)
			var x = JSON.parse_string(f.get_as_text()) if f else null
			if x is Dictionary: D = x
	return D

static var OFF := false   # FIXES_review1 第 3 項：ab_off 係全域開關（唔入玩家存檔）；data/abil.json 頂層 "off": true 亦可關
static func on() -> bool:
	if OFF or J.t(data().get("off", false)): return false
	return true   # stub：冇 abil.json 都當開（用下面後備表），俾畫面有嘢顯示

# ---- 後備表（abil.json 未有時用；數據以 cdata 線 ENEMY 為準） ----
const _MECH_FB := {
	"egui": ["regen"], "xiaogui": ["stealth"], "zombie": ["revive", "cc_immune"], "zhiren": ["split"],
	"niutou": ["shell"], "mamian": ["rush"], "eguiking": ["regen", "cc_immune"], "toyol": ["stealth"],
	"laojiang": ["cc_immune", "revive"], "pontianak": ["fly", "fear_aura"], "pocong": ["revive"],
	"penanggal": ["fly"], "baiwu": ["clone"], "heiwu": ["summon"], "huang": ["summon", "shell"],
	"n30_kappa": ["shell"], "n30_bunian": ["stealth"], "n30_polong": ["regen"], "n30_baigujing": ["regen", "clone"],
	"n30_jerangkung": ["split"], "n30_gashadokuro": ["split"], "n30_pelesit": ["fly"], "n30_tikbalang": ["confuse"],
	"n30_kuchisake": ["rush"], "n30_banshee": ["fear_aura"], "n30_hanturaya": ["summon", "clone"], "n30_liulian": ["thorns"],
	"n30_diansi": ["thorns"], "n30_hannya": ["thorns"], "n30_genderuwo": ["cc_immune"], "n30_chehuo": ["rush"],
}
const _COUNTER_FB := {
	"fly": ["ranged", "pull"], "stealth": ["reveal"], "shell": ["break"], "regen": ["sap"], "split": ["sweep"],
	"summon": ["pierce", "sap"], "thorns": ["ranged", "heal"], "fear_aura": ["steady"], "cc_immune": ["break", "pierce"],
	"revive": ["seal"], "rush": ["steady", "pull"], "confuse": ["steady"], "clone": ["reveal", "sweep"],
}
const _TAG_FB := {"laojiang": ["steady"], "heiwu": ["steady", "seal"], "baiwu": ["seal"], "pocong": ["seal"], "mengpo": ["heal"]}

static func mechs_of(k) -> Array:
	var e = data().get("ENEMY", {}).get(str(k))
	if e is Dictionary and e.get("mech") is Array: return e.mech.duplicate()
	return (_MECH_FB.get(str(k), []) as Array).duplicate()

static func counters_of(m) -> Array:   # 機制 → 應對標籤
	var x = data().get("MECH", {}).get(str(m))
	if x is Dictionary and x.get("counter") is Array: return x.counter.duplicate()
	return (_COUNTER_FB.get(str(m), []) as Array).duplicate()

static func tags_of(k) -> Array:   # 名鬼 → 應對標籤（counter.md 4.2 自動推導＋手加）
	var k2 = str(k)
	var a = data().get("ABIL", {}).get(k2)
	if a is Dictionary and a.get("tags") is Array and (a.tags as Array).size(): return a.tags.duplicate()
	var o = []
	var GH = J.G.get("GHOSTS"); var SK = J.G.get("SKILLS")
	var g = GH.get(k2) if GH is Dictionary else null
	var sk = SK.get(k2) if SK is Dictionary else null
	if g is Dictionary and str(g.get("range", "")) == "ranged": o.append("ranged")
	if sk is Dictionary:
		var kd = str(sk.get("kind", "")); var mu = J.num(sk.get("mult", 0)); var hi = J.num(sk.get("hits", 0)) if sk.get("hits") != null else 0.0
		if str(sk.get("apply", "")) == "down": o.append("pull")
		if kd == "aoe": o.append("sweep")
		if hi >= 2 or mu >= 1.8: o.append("break")
		if kd == "hit" and mu >= 1.7 and hi < 2: o.append("pierce")
		if J.num(sk.get("sap", 0)) > 0 or J.t(sk.get("forget")): o.append("sap")
		if J.num(sk.get("drain", 0)) > 0 or kd == "heal": o.append("heal")
	var R = J.G.get("Rework")
	var ts = J.mc(R, "typesOf", [k2]) if R != null else []
	if ts is Array and ts.has("light"): o.append("reveal")
	for x in _TAG_FB.get(k2, []): if not x in o: o.append(x)
	return o.slice(0, 3)

static func describe(k) -> String:
	var SK = J.G.get("SKILLS")
	var sk = SK.get(str(k)) if SK is Dictionary else null
	return str(sk.get("desc", "")) if sk is Dictionary else ""
