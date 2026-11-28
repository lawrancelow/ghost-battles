# [p55] 資源圖示：有美術版（assets/ui/icons/res_<k>_<64|128>.webp）就用，冇就退返舊 svg（i-<k>.svg）
#   k：wood／rice／planks／buns／coins／troops。美術組之後補 res_wood／res_rice／res_coins 同名檔，唔使再改程式。
#   用法：load("res://ui/res_icon.gd").tex("planks")／.path("buns", true)（大面板用 128）
extends RefCounted

static func path(k: String, big := false) -> String:
	var a = "res://assets/ui/icons/res_%s_%d.webp" % [k, 128 if big else 64]
	if ResourceLoader.exists(a): return a
	var s = "res://assets/ui/i-%s.svg" % k
	return s if ResourceLoader.exists(s) else ""
static func tex(k: String, big := false) -> Texture2D:
	var p = path(k, big)
	return load(p) if p != "" else null
static func is_art(k: String) -> bool: return path(k).ends_with(".webp")
