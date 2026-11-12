# 數據表（由網頁版 JS 自動導出：tools/dump_data.js → data/core.json）＋ 對白語言 L()/Lf()
extends Node

var D = {}
var RIGS = {}
var lang = "zh"   # 'zh' 中文 | 'yue' 粵語

func _ready() -> void:
	D = _load("res://data/core.json")
	RIGS = _load("res://data/rigs.json")
	var cfg = ConfigFile.new()
	if cfg.load("user://settings.cfg") == OK: lang = cfg.get_value("ui", "dialogue_lang", "zh")

func _load(p: String) -> Dictionary:
	var f = FileAccess.open(p, FileAccess.READ)
	if not f: push_error("缺數據 " + p); return {}
	return JSON.parse_string(f.get_as_text())

func t(name: String) -> Variant: return D.get(name)

func L(s: Variant) -> Variant:
	if not (s is String) or lang != "zh": return s
	var z = D.get("LANG_ZH", {}).get(s)
	return z if z != null and z != "" else s

func Lf(s: String, v: Dictionary = {}) -> String:
	var r: String = L(s)
	for k in v: r = r.replace("{" + k + "}", str(v[k]))
	return r

func set_lang(v: String) -> void:
	lang = "yue" if v == "yue" else "zh"
	var cfg = ConfigFile.new(); cfg.load("user://settings.cfg")
	cfg.set_value("ui", "dialogue_lang", lang); cfg.save("user://settings.cfg")
