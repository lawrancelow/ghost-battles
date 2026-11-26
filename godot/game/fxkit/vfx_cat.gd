# [vfx] 特效目錄（序列幀版）：需求鍵 → 用邊張序列幀、幾格、幾大、放喺邊、色系
#   序列幀放 res://art/vfx/<sheet>.png：4×4＝16 格、每格 256、純黑底（加色混合）；家族配色見 FAM
#   觸發：abil.gd trig() 名技（副技／王牌技）→ sim._vq(["sk2", u, pe, ts]) → rts_fx.consume() → play()
#   key：王牌技 "ace_<鬼 k>"；副技 "sub_<tpl>"；升級 "up_fuse"／"up_star"
#   at：tgt＝第一個目標身中；tgt_all＝每個目標各一個（最多 4）；self＝出手者身中；self_g＝出手者腳底（地面層）；
#       area＝出手者腳底大範圍；line＝出手者→目標中點、沿方向轉
#   s＝每格 256px 喺世界嘅縮放（0.5＝128px 闊）；life＝成段幾秒；add＝加色混合
extends RefCounted

const DIR := "res://art/vfx/"
const GRID := 4

# 家族（交接文件 20 個特效家族）→ 主色（同一家族配色一致）
const FAM := {
	"slash": {"n": "斬", "col": "暗紫／骨白邊"}, "smash": {"n": "撞", "col": "骨白閃＋啡灰塵"}, "blast": {"n": "爆", "col": "暗金＋餘燼橙"},
	"miasma": {"n": "毒霧", "col": "暗綠／病黃綠"}, "wisp": {"n": "鬼火", "col": "淡青綠"}, "frost": {"n": "冰霜", "col": "淡冰藍"},
	"thunder": {"n": "雷", "col": "紫電＋淡金芯"}, "coin": {"n": "紙錢", "col": "舊金＋骨白"}, "hair": {"n": "頭髮", "col": "墨黑髮＋淡綠光"},
	"tongue": {"n": "長舌", "col": "暗紫紅（唔係血紅）"}, "chain": {"n": "鎖鏈", "col": "鐵灰＋紫黑煙"}, "shadow": {"n": "黑影", "col": "黑＋暗紫"},
	"soul": {"n": "魂光", "col": "淡金／淡青"}, "heal": {"n": "治療光", "col": "淡翠綠＋奶白"}, "guard": {"n": "護盾", "col": "青藍＋白邊"},
	"smoke": {"n": "隱身煙", "col": "黑紫煙"}, "circle": {"n": "召喚陣", "col": "淡藍灰（純幾何圈，冇符字）"}, "signal": {"n": "電話信號", "col": "青綠掃描線"},
	"spit": {"n": "口水", "col": "黃綠黏液"}, "wind": {"n": "風刃", "col": "淡青白"},
	"skin": {"n": "剝皮（畫皮專屬）", "col": "象牙白＋淡紫"},
}

# 第一批：19 王牌技＋10 個最常見副技模板＋2 升級
const CAT := {
	# ---- 王牌技（每隻專屬）----
	"ace_heiwu": {"n": "鎖魂待審", "who": "黑無常", "fam": "chain", "at": "tgt", "s": 0.84, "life": 1.1},
	"ace_baiwu": {"n": "一見發財", "who": "白無常", "fam": "coin", "at": "self", "s": 1.01, "life": 1.2},
	"ace_mengpo": {"n": "忘憂湯", "who": "孟婆", "fam": "heal", "at": "area", "s": 1.28, "life": 1.3},
	"ace_niutou": {"n": "牛氣沖天", "who": "牛頭", "fam": "smash", "at": "area", "s": 1.15, "life": 0.9},
	"ace_mamian": {"n": "馬不停蹄", "who": "馬面", "fam": "wind", "at": "line", "s": 1.22, "life": 0.8},
	"nw_huapi": {"alias": "ace_huapi"},
	"ace_huapi": {"n": "借皮", "who": "畫皮", "fam": "skin", "at": "tgt", "s": 0.84, "life": 1.1},
	"ace_qiongqi": {"n": "顛倒是非", "who": "窮奇", "fam": "miasma", "at": "tgt", "s": 0.81, "life": 1.1},
	"ace_nian": {"n": "大年夕", "who": "年獸", "fam": "blast", "at": "area", "s": 1.35, "life": 1.0},
	"ace_niexiaoqian": {"n": "歸骨還魂", "who": "聶小倩", "fam": "soul", "at": "tgt", "s": 0.94, "life": 1.4, "anchor": 0.8},
	"ace_pontianak": {"n": "夜半笑聲", "who": "Pontianak", "fam": "hair", "at": "area", "s": 1.35, "life": 1.2},
	"ace_dokkaebi": {"n": "金棒變變變", "who": "Dokkaebi", "fam": "blast", "at": "self", "s": 0.94, "life": 1.1, "anchor": 0.7},
	"ace_dullahan": {"n": "點名索命", "who": "無頭騎士", "fam": "slash", "at": "tgt", "s": 0.84, "life": 1.0},
	"ace_taotie": {"n": "咬一口先", "who": "饕餮", "fam": "miasma", "at": "tgt", "s": 0.84, "life": 0.9},
	"ace_jembalang": {"n": "土地翻身", "who": "Jembalang", "fam": "smash", "at": "tgt_g", "s": 1.08, "life": 1.1, "anchor": 0.75},
	"ace_hou": {"n": "犼食龍", "who": "犼", "fam": "thunder", "at": "area", "s": 1.28, "life": 1.0},
	"ace_langsuir": {"n": "夜梟啼", "who": "Langsuir", "fam": "slash", "at": "tgt", "s": 0.78, "life": 0.8},
	"ace_krasue": {"n": "飛頭夜巡", "who": "Krasue", "fam": "wisp", "at": "tgt_all", "s": 0.65, "life": 1.0},
	"ace_pang": {"n": "甩鍋大師", "who": "胖", "fam": "smash", "at": "tgt", "s": 0.81, "life": 1.0, "anchor": 0.65},
	"ace_shuten": {"n": "千杯不醉", "who": "酒吞童子", "fam": "wisp", "at": "self", "s": 0.97, "life": 1.3, "anchor": 0.75},
	# ---- 副技模板（10 個最常見）----
	"sub_A_BACK": {"n": "閃後排", "fam": "shadow", "at": "self", "s": 0.65, "life": 0.6},
	"sub_S_SAP": {"n": "抽能量", "fam": "soul", "at": "tgt_all", "s": 0.59, "life": 0.8},
	"sub_T_GUARD": {"n": "護盾", "fam": "guard", "at": "self", "s": 0.72, "life": 0.9},
	"sub_S_STUN": {"n": "範圍定身", "fam": "circle", "at": "tgt_g", "s": 0.91, "life": 1.0, "anchor": 0.6},
	"sub_T_STUN": {"n": "震地", "fam": "smash", "at": "area", "s": 0.98, "life": 0.8},
	"sub_T_SLAM": {"n": "搥地", "fam": "smash", "at": "tgt_g", "s": 0.78, "life": 0.7, "anchor": 0.7},
	"sub_T_WALL": {"n": "企硬", "fam": "guard", "at": "self", "s": 0.72, "life": 0.9},
	"sub_W_KNOCK": {"n": "撞低", "fam": "smash", "at": "tgt", "s": 0.65, "life": 0.6, "dirflip": true},
	"sub_R_SNIPE": {"n": "點殺", "fam": "wind", "at": "tgt", "s": 0.59, "life": 0.6},
	"sub_W_BREAK": {"n": "重擊", "fam": "blast", "at": "tgt", "s": 0.65, "life": 0.7},
	# ---- 升級（介面上播）----
	"up_fuse": {"n": "魂魄融合升品", "fam": "soul", "at": "ui", "s": 1.0, "life": 1.4},
	"up_star": {"n": "星級突破", "fam": "soul", "at": "ui", "s": 1.0, "life": 1.4},
}

static func key_of(pe: Dictionary, k: String) -> String:
	if J.t(pe.get("ace")): return "ace_" + k.trim_prefix("nw_").trim_prefix("bm_")
	if J.t(pe.get("sub")): return "sub_" + J.str(pe.get("tpl"))
	return ""
static func get_e(key: String):
	var e = CAT.get(key)
	if e is Dictionary and e.has("alias"): e = CAT.get(e.alias)
	if not (e is Dictionary): return null
	if not ResourceLoader.exists(DIR + key + ".png") and not FileAccess.file_exists(DIR + key + ".png"): return null
	return e
static var _tx := {}
static func tex(key: String) -> Texture2D:
	if _tx.has(key): return _tx[key]
	var p = DIR + key + ".png"; var t: Texture2D = null
	if ResourceLoader.exists(p): t = load(p)
	elif FileAccess.file_exists(p):
		var im = Image.load_from_file(ProjectSettings.globalize_path(p))
		if im != null: t = ImageTexture.create_from_image(im)
	_tx[key] = t
	return t
