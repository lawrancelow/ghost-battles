# [p44] 王牌晉級立繪（三階；酒吞童子四階）＋主角空手三姿勢＋主角漂浮兵器
#   全部 static；冇 class_name（熱更新規矩）。Spr.key_for 會叫 map()：所有經 Spr／PtGfx 攞圖嘅地方（圖鑑、名冊、
#   村子、招募、戰鬥整張圖模式）自動換成目前階段嘅空手圖。
#
#   階段（按星級突破，同「★3 換進階立繪」一致）：
#     三階王牌： ★0–2 → 第一階（空手原圖）  ★3–4 → 第二階  ★5 → 第三階
#     酒吞童子（四階）：★0–2 → 第一階  ★3 → 第二階  ★4 → 第三階  ★5 → 第四階
#     未收服／敵方：讀唔到星級 → 第一階
#
#   對話規矩（老闆 11-26）：黑無常、白無常、牛頭、馬面、孟婆喺故事對話入面照用原本手持兵器嘅原立繪；
#     其餘角色對話用目前階段圖。對話畫面（story.gd、story_stage.gd、story_cg.gd）畫圖前後用 dlg_begin()／dlg_end() 包住。
#
#   檔案：assets/spr/ace_<k>_s<n>.webp（白底已去背，tools/devkit/art/cutout_white.py）
#         assets/spr/afu_pose_a|b|c.webp（男主空手）、afuf_pose_a|b|c.webp（女主空手；Spr.key_for 按性別自動換）
#   主角兵器：equip.json eq_hero_axe（斧・重・揮斬）／eq_hero_ruler（三角尺・巧・突刺），主角預設裝上；暫用 eq_art 程序圖
#   軍團空手圖（老闆 11-26：遊戲介面一律空手，兵器另做漂浮兵器）：NWP 名單嘅 lg_ 角色 → assets/spr/nwp_<k>.webp
#     （同原圖一樣尺寸、同一位置，只係兵器區改咗，網格／頭像裁切照用）。對話都用空手圖（只有上面五隻例外）。冇圖就照用原圖。
extends RefCounted

const STAGES := {"heiwu": 3, "baiwu": 3, "niutou": 3, "mamian": 3, "mengpo": 3, "pontianak": 3,
	"nw_dokkaebi": 3, "nw_huapi": 3, "nw_nian": 3, "nw_niexiaoqian": 3, "nw_qiongqi": 3,
	"bm_hou": 3, "bm_jembalang": 3, "bm_krasue": 3, "bm_langsuir": 3, "bm_taotie": 3, "bm_shuten": 4}
const NWP := {"lg_dpl_bing": 1, "lg_dpl_boss": 1, "lg_dpl_boss2": 1, "lg_dpl_elite": 1, "lg_dpl_king": 1, "lg_dpl_shoot": 1, "lg_egs_bing": 1, "lg_egs_boss": 1,
	"lg_egs_boss2": 1, "lg_egs_king": 1, "lg_egs_shoot": 1, "lg_klj_bing": 1, "lg_klj_boss": 1, "lg_klj_elite": 1, "lg_klj_king": 1, "lg_klj_shoot": 1,
	"lg_klj_tank": 1, "lg_sgj_boss": 1, "lg_sgj_boss2": 1, "lg_sgj_king": 1, "lg_ssg_boss2": 1, "lg_ssg_elite": 1, "lg_ssg_king": 1, "lg_wkj_bing": 1,
	"lg_wkj_boss": 1, "lg_wkj_boss2": 1, "lg_wkj_elite": 1, "lg_wkj_king": 1, "lg_wkj_shoot": 1, "lg_wkj_tank": 1, "lg_zzj_bing": 1, "lg_zzj_boss": 1,
	"lg_zzj_boss2": 1, "lg_zzj_elite": 1, "lg_zzj_king": 1, "lg_zzj_shoot": 1}   # Dictionary：key_for 每次畫都查，用 has() O(1)
const KEEP_DLG := ["heiwu", "baiwu", "niutou", "mamian", "mengpo"]   # 對話照用手持兵器原圖
const H_K := {"ace_heiwu_s2": 0.95, "ace_heiwu_s3": 0.82, "ace_baiwu_s2": 0.93, "ace_baiwu_s3": 0.84, "ace_niutou_s2": 0.93, "ace_niutou_s3": 0.91, "ace_mamian_s2": 0.98, "ace_mamian_s3": 0.98, "ace_mengpo_s2": 0.89, "ace_mengpo_s3": 0.82, "ace_pontianak_s2": 0.97, "ace_pontianak_s3": 0.92, "ace_nw_huapi_s2": 0.87, "ace_nw_huapi_s3": 0.83, "ace_nw_niexiaoqian_s2": 0.88, "ace_nw_niexiaoqian_s3": 0.87, "ace_bm_langsuir_s3": 0.99, "ace_bm_taotie_s2": 0.98, "ace_bm_taotie_s3": 0.95}   # 闊過原圖嘅階段圖：高度按闊度比例收細（√(原闊高比/新闊高比)，0.82–1），同原圖佔地差唔多、唔會大過人
const POSES := ["afu_pose_a", "afu_pose_b", "afu_pose_c"]
const POSE_MIN := 18.0      # 姿勢最少維持幾多秒先換（隨機 18–35 秒）
const POSE_MAX := 35.0

static var dlg := 0                 # >0：而家畫緊對話
static var force := {}              # 測試：{k: 階}
static var force_pose := -1         # 測試：固定姿勢 0–2
static var hero_on := true          # 主角空手＋漂浮兵器（戰鬥）
static var _c := {}                 # 每幀快取 {k: 階}
static var _cf := -1
static var _pose := -1
static var _pose_prev := -1
static var _pose_t := 0.0           # 換姿勢嗰刻（秒）
static var _pose_next := 0.0

static func UP(): return load("res://game/soul/soul_up.gd")
static func has(k: String) -> bool: return STAGES.has(k)
static func n_stages(k: String) -> int: return int(STAGES.get(k, 0))

# 星級 → 階（1 起）
static func stage_of_star(k: String, s: int) -> int:
	var n = n_stages(k)
	if n <= 0: return 0
	if s < 3: return 1
	if n >= 4: return clampi(s - 1, 2, 4)      # ★3→2、★4→3、★5→4
	return 2 if s < 5 else 3
static func stage(k: String) -> int:
	if not STAGES.has(k): return 0
	if force.has(k): return clampi(int(force[k]), 1, n_stages(k))
	var f = Engine.get_process_frames()
	if f != _cf: _c.clear(); _cf = f
	if _c.has(k): return _c[k]
	var s = 0
	var o = UP().st() if J.G.get("S") is Dictionary else null
	if o != null: s = UP().star(k)
	var v = stage_of_star(k, s)
	_c[k] = v
	return v
static func key(k: String, st := -1) -> String:
	return "ace_%s_s%d" % [k, stage(k) if st < 0 else st]
# Spr.key_for 掛鈎：原鍵 → 階段圖鍵（冇圖就照用原圖）
static func map(k: String) -> String:
	if NWP.has(k):
		var nk = "nwp_" + k
		return nk if Spr.ok(nk) else k
	if not STAGES.has(k): return k
	if dlg > 0 and KEEP_DLG.has(k): return k
	var kk = key(k)
	return kk if Spr.ok(kk) else k
# 呢隻而家用緊階段圖（唔用網格／拆手骨架，改整張圖畫）
static func active(k: String) -> bool:
	if STAGES.has(k): return map(k) != k
	if k == "afu": return hero_on and Spr.ok(POSES[0])
	return false
static func h_k(k: String) -> float: return float(H_K.get(Spr.key_for(k), 1.0)) if STAGES.has(k) else 1.0
static func dlg_begin() -> void: dlg += 1
static func dlg_end() -> void: dlg = maxi(0, dlg - 1)

# ---------------- 主角姿勢 ----------------
static func _now() -> float: return Time.get_ticks_msec() / 1000.0
static func new_scene() -> void:   # 每次入戰鬥場景：隨機揀一個姿勢
	_roll(true)
static func _roll(any := false) -> void:
	var t = _now()
	var p = randi() % POSES.size()
	if not any and _pose >= 0 and POSES.size() > 1:
		while p == _pose: p = randi() % POSES.size()
	_pose_prev = _pose if not any else -1
	_pose = p; _pose_t = t if not any else -99.0
	_pose_next = t + randf_range(POSE_MIN, POSE_MAX)
static func pose_i() -> int:
	if force_pose >= 0: return force_pose % POSES.size()
	if _pose < 0: _roll(true)
	elif _now() >= _pose_next: _roll(false)
	return _pose
static func pose_key() -> String: return POSES[pose_i()]
# 換姿勢交叉淡入：[舊姿勢鍵或 ""，新姿勢比例 0..1]
static func pose_fade() -> Array:
	var i = pose_i()
	if force_pose >= 0 or _pose_prev < 0: return ["", 1.0]
	var q = clampf((_now() - _pose_t) / 0.35, 0.0, 1.0)
	return [POSES[_pose_prev] if q < 1.0 and _pose_prev != i else "", q]
static func hero_female() -> bool: return DB.hero_female()
static func hero_weapon() -> String: return load("res://game/equip/eq_data.gd").hero_wea()   # 冇裝兵器時嘅後備（正常主角預設已裝上）
