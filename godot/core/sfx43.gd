# [sfx43] 補丁 43 新內容音效對照表（音檔：res://assets/snd/sfx43/<key>.ogg，播放：Snd.play(key)）
# 全部素材 CC0（OpenGameArt）或本組原創合成，來源授權見 res://assets/snd/LICENSES_sfx43.md
extends RefCounted

const DIR := "res://assets/snd/sfx43/"

# 副技 30 個模板 → 22 種聲
const SUB := {
	"W_CLEAVE": "sub_slash", "W_BREAK": "sub_break", "A_EXEC": "sub_exec",
	"T_SLAM": "sub_slam", "W_KNOCK": "sub_slam", "T_STUN": "sub_stun", "S_STUN": "sub_stun",
	"T_GUARD": "sub_guard", "T_WALL": "sub_guard", "H_SHIELD": "sub_guard",
	"T_DRAIN": "sub_drain", "S_SAP": "sub_sap", "A_POISON": "sub_poison", "A_VANISH": "sub_vanish", "A_BACK": "sub_dash",
	"R_SNIPE": "sub_shoot", "R_LINE": "sub_shoot", "R_ANTI": "sub_shoot", "R_CHAIN": "sub_chain",
	"M_BLAST": "sub_blast", "M_BURN": "sub_burn", "M_FROST": "sub_frost", "M_HUSH": "sub_hush",
	"S_RALLY": "sub_rally", "W_RAGE": "sub_rage", "S_HASTE": "sub_haste",
	"H_HOT": "sub_heal", "H_BURST": "sub_heal", "H_CLEAN": "sub_clean", "S_DISPEL": "sub_clean",
}
# 王牌技 19 個 → 三種重聲（攻擊／控場詛咒／加持）
const ACE := {
	"heiwu": "ace_strike", "niutou": "ace_strike", "mamian": "ace_strike", "nw_dullahan": "ace_strike", "bm_taotie": "ace_strike",
	"bm_jembalang": "ace_strike", "bm_langsuir": "ace_strike", "bm_krasue": "ace_strike",
	"nw_huapi": "ace_curse", "nw_qiongqi": "ace_curse", "nw_nian": "ace_curse", "pontianak": "ace_curse", "bm_hou": "ace_curse", "bm_pang": "ace_curse",
	"baiwu": "ace_bless", "mengpo": "ace_bless", "nw_niexiaoqian": "ace_bless", "nw_dokkaebi": "ace_bless", "bm_shuten": "ace_bless",
}
# 狀態中招（ab 事件名 → 聲）
const ST := {
	"stun": "st_stun", "silence": "st_silence", "mark": "st_mark", "armor_break": "st_mark", "wound": "st_mark",
	"flee": "st_flee", "confuse": "st_confuse", "charm": "st_confuse", "slow": "st_slow",
	"shell_break": "st_shell", "break": "st_shell", "shield_break": "st_shell", "殼破": "st_shell",
}
const DOT := {"burn": "st_burn", "fire": "st_burn", "poison": "st_poison"}

static func _sk2() -> Dictionary:
	return load("res://game/rts/abil.gd").sk2()

static func sub_key(k) -> String:
	var e = _sk2().get("SUB", {}).get(str(k))
	return str(SUB.get(str(e.get("tpl", "")), "sub_slash")) if e is Dictionary else ""

static func ace_key(k) -> String:
	if ACE.has(str(k)): return ACE[str(k)]
	var e = _sk2().get("ACE", {}).get(str(k))   # 新加嘅王牌：按第一個效果估
	if not (e is Dictionary): return ""
	var p0 = ""
	for fx in e.get("fx", []): if fx is Dictionary: p0 = str(fx.get("p", "")); break
	if p0 in ["heal", "buff", "energy", "revive", "cleanse", "shield", "immune"]: return "ace_bless"
	if p0 in ["charm", "flee", "silence", "dispel", "mark", "sap"]: return "ace_curse"
	return "ace_strike"

# ab 事件 → 聲（"" ＝ 唔出聲）
static func ev_key(e: Array) -> String:
	if e.size() < 3: return ""
	var src = e[1]; var p = str(e[2]); var tg = e[3] if e.size() > 3 else null
	if p == "sub" and src is Dictionary: return sub_key(src.get("k", ""))
	if p == "ace" and src is Dictionary: return ace_key(src.get("k", ""))
	if p == "dot" and tg is Dictionary:
		var ta = tg.get("ab")
		if ta is Dictionary:
			for b in ta.get("bf", []):
				if b is Dictionary and str(b.get("p", "")) == "dot": return str(DOT.get(str(b.get("kind", "")), ""))
		return ""
	return str(ST.get(p, ""))

# 漂浮兵器普攻（eq_art.atk_style）→ 聲
static func wp_key(style: String) -> String:
	return "wp_" + (style if style in ["thrust", "swing", "spin", "throw"] else "thrust")

# 戰報要出嘅聲（魔王掉魂魄、專屬物）：結算時排隊，戰報卡出嗰陣先播
static var _q: Array = []
static func queue(key: String) -> void:
	_q.append([key, Time.get_ticks_msec()])
static func take() -> Array:
	var now = Time.get_ticks_msec(); var o = []
	for x in _q: if now - int(x[1]) < 20000: o.append(x[0])
	_q.clear()
	return o
