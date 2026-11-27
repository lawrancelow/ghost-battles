# 蠟筆畫素材登記（對應網頁版 SPR / sprOk）：鍵名同網頁版一樣，背景加 bg_ 前綴
extends Node

var _man = {}
var _tex = {}
var trace := false      # [perf2] 測試用：記低每張圖同步載入幾耐
var trace_log := []
var audit = null        # [p47] 測試：{key: 次數}（空手稽查：記低實際攞過嘅圖鍵）

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

const HERO_FULL := {"afu": 1, "afuf": 1, "afu_body": 1, "afuf_body": 1}   # [p47] 主角手持兵器整張圖
var _ace = null   # [p44] 王牌晉級立繪（game/soul/ace_art.gd）
func key_for(k: String) -> String:
	if _ace == null: _ace = load("res://game/soul/ace_art.gd")
	if _ace.STAGES.has(k) or _ace.NWP.has(k): return _ace.map(k)   # [p44] 王牌階段圖／軍團空手圖
	if not k.contains("afu"): return k
	if HERO_FULL.has(k) and _ace.active("afu"):   # [p47] 主角整張圖（手揸斧頭／三角尺）一律換空手姿勢圖（頭像、圖鑑、劇情、回陽間等）
		# [p0102_1] 明確要女主圖（afuf／afuf_body，例如名字卡「四眼妹」、劇情插圖）就一定換女主空手圖，唔理而家存檔揀咗邊個
		if k.begins_with("afuf") and _man.has(fem_key(_ace.POSES[0])): return fem_key(_ace.POSES[0])
		k = _ace.POSES[0]
	if not DB.hero_female(): return k
	var fk = fem_key(k)
	return fk if fk != k and _man.has(fk) else k

# JS 圖（SPR／SPR_SRC 經 El.src 載）：res://assets/spr/afu_body.webp → 有 afuf_body 就用佢嘅路徑
func fem_src(path: String) -> String:
	if not DB.hero_female(): return path
	var k = path.get_file().get_basename()
	if not k.contains("afu"): return path   # [p44] 只換女主圖（王牌階段圖唔經 JS 路徑）
	var fk = key_for(k)
	return str(_man[fk]) if fk != k else path

func get_tex(k: String) -> Texture2D:
	k = key_for(k)
	if audit != null: audit[k] = int(audit.get(k, 0)) + 1
	if _tex.has(k): return _tex[k]
	if not _man.has(k): return null
	var tl0 = Time.get_ticks_usec()
	var t: Texture2D = load(_man[k])
	_tex[k] = t
	if trace: trace_log.append([k, (Time.get_ticks_usec() - tl0) / 1000.0])
	return t

func w(k: String) -> float:
	var t = get_tex(k); return t.get_width() if t else 0.0
func h(k: String) -> float:
	var t = get_tex(k); return t.get_height() if t else 0.0
