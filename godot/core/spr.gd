# 蠟筆畫素材登記（對應網頁版 SPR / sprOk）：鍵名同網頁版一樣，背景加 bg_ 前綴
extends Node

var _man = {}
var _tex = {}

func _ready() -> void:
	var f = FileAccess.open("res://assets/spr_manifest.json", FileAccess.READ)
	if f: _man = JSON.parse_string(f.get_as_text())

func ok(k: String) -> bool:
	return _man.has(k)

func get_tex(k: String) -> Texture2D:
	if _tex.has(k): return _tex[k]
	if not _man.has(k): return null
	var t: Texture2D = load(_man[k])
	_tex[k] = t
	return t

func w(k: String) -> float:
	var t = get_tex(k); return t.get_width() if t else 0.0
func h(k: String) -> float:
	var t = get_tex(k); return t.get_height() if t else 0.0
