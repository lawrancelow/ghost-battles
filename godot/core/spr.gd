# 蠟筆畫素材登記（對應網頁版 SPR / sprOk）：鍵名同網頁版一樣，背景加 bg_ 前綴
extends Node

var _man = {}
var _tex = {}

func _ready() -> void:
	var f = FileAccess.open("res://assets/spr_manifest.json", FileAccess.READ)
	if f: _man = JSON.parse_string(f.get_as_text())

func ok(k: String) -> bool:
	return _man.has(k)

# 女主角（S.hero.sex == "f"）換圖：afu → afuf、afu_xxx → afuf_xxx、rg_afu_xxx → rg_afuf_xxx（afu__axe 之類一樣）
# 有對應 afuf 版圖先換，冇就照用阿福張圖。女主選項開唔開放：fem_ok()（＝ ok("afuf")）
static func fem_key(k: String) -> String:
	if k == "afu": return "afuf"
	if k.begins_with("afu_"): return "afuf" + k.substr(3)
	if k.begins_with("rg_afu_"): return "rg_afuf_" + k.substr(7)
	return k

func fem_ok() -> bool: return _man.has("afuf")

func key_for(k: String) -> String:
	if not k.contains("afu"): return k
	if not DB.hero_female(): return k
	var fk = fem_key(k)
	return fk if fk != k and _man.has(fk) else k

# JS 圖（SPR／SPR_SRC 經 El.src 載）：res://assets/spr/afu_body.webp → 有 afuf_body 就用佢嘅路徑
func fem_src(path: String) -> String:
	if not DB.hero_female(): return path
	var k = path.get_file().get_basename()
	var fk = key_for(k)
	return str(_man[fk]) if fk != k else path

func get_tex(k: String) -> Texture2D:
	k = key_for(k)
	if _tex.has(k): return _tex[k]
	if not _man.has(k): return null
	var t: Texture2D = load(_man[k])
	_tex[k] = t
	return t

func w(k: String) -> float:
	var t = get_tex(k); return t.get_width() if t else 0.0
func h(k: String) -> float:
	var t = get_tex(k); return t.get_height() if t else 0.0
