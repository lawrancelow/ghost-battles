# [abui] 機制／應對標籤／頭頂狀態圖示（★暫代圖：全部程序畫，墨線＋偏灰病態色，同 core/art.gd 一路）
#   換正式圖只改一處：放 res://art/ab/<key>.png（正方，透明底），draw() 會自動改用貼圖（縮入圓圈內，唔裁切）。
#   key 一律用英文正名（下面 ALIAS 容許 abcore／cdata 用中文或別名）。
#   冇 class_name；const AI = preload("res://game/rts/ab_icon.gd")
extends RefCounted

const INK := Color("#1a1426")
const BONE := Color("#efe6d2")

# 別名 → 正名（機制 13＋標籤 10＋ability.md 舊名）
const ALIAS := {
	"飛": "fly", "飛行": "fly", "隱": "stealth", "隱身": "stealth", "殼": "shell", "硬殼": "shell", "armor": "shell", "shield": "shell",
	"再生": "regen", "散骨": "split", "分裂": "split", "召喚": "summon", "反傷": "thorns", "嚇氣光環": "fear_aura", "恐懼光環": "fear_aura", "sap_aura": "fear_aura",
	"霸體": "cc_immune", "免控": "cc_immune", "屍變": "revive", "返生": "revive", "突襲": "rush", "迷魂": "confuse", "分身": "clone",
	"遠": "ranged", "遠程": "ranged", "anti_air": "ranged", "拉": "pull", "ground": "pull", "掃": "sweep", "群攻": "sweep", "aoe": "sweep",
	"破": "break", "armor_break": "break", "shield_break": "break", "刺": "pierce", "dash": "pierce", "execute": "pierce", "削": "sap", "interrupt": "sap", "wound": "sap",
	"回": "heal", "drain": "heal", "照": "reveal", "照妖": "reveal", "定": "steady", "定神": "steady", "guard": "steady", "taunt": "steady", "收": "seal", "收魂": "seal", "banish": "seal",
}
static func canon(k) -> String:
	var s = str(k)
	return ALIAS.get(s, s)

# 顯示資料：n＝名（粵／中同字）、c＝底色、ch＝一個字（細圖用）、w＝冇應對會點（粵, 中）、d＝說明（粵, 中）
const INFO := {
	"fly": {"n": "飛行", "ch": "飛", "c": "#5f7f96", "w": ["近身打佢只有三成傷害", "近身打它只有三成傷害"], "d": ["浮喺半空，要遠程或者腳軟拉佢落地", "浮在半空，要遠程或者腳軟拉它落地"]},
	"stealth": {"n": "隱身", "ch": "隱", "c": "#6c6680", "w": ["隱咗身揀唔到做目標", "隱身時選不到做目標"], "d": ["每 6 秒隱身 4 秒，要「照」現形", "每 6 秒隱身 4 秒，要「照」現形"]},
	"shell": {"n": "硬殼", "ch": "殼", "c": "#7a6a4e", "w": ["殼未破只食一半傷害", "殼未破只受一半傷害"], "d": ["殼值＝三成半血，要「破」先打得入", "殼值＝三成半血，要「破」才打得進"]},
	"regen": {"n": "再生", "ch": "生", "c": "#5a7a5a", "w": ["每秒回血，拖到時間到", "每秒回血，拖到時間到"], "d": ["要「削」或者凍嚇法停佢回血", "要「削」或者凍嚇法停它回血"]},
	"split": {"n": "散骨", "ch": "散", "c": "#8a8478", "w": ["死咗散開三隻小怪", "死後散成三隻小怪"], "d": ["要「掃」全體技一次清", "要「掃」全體技一次清"]},
	"summon": {"n": "召喚", "ch": "召", "c": "#6e5a7a", "w": ["越打越多嘍囉", "越打越多嘍囉"], "d": ["要「刺」先斬召喚者，或者「削」佢嚇氣", "要「刺」先斬召喚者，或者「削」它嚇氣"]},
	"thorns": {"n": "反傷", "ch": "反", "c": "#8a5a4a", "w": ["近身打佢反彈兩成傷害", "近身打它反彈兩成傷害"], "d": ["要「遠」唔反彈，或者「回」補返", "要「遠」不反彈，或者「回」補回"]},
	"fear_aura": {"n": "嚇氣光環", "ch": "壓", "c": "#7a4a5e", "w": ["身邊我方嚇氣慢一半，放唔到技", "身邊我方嚇氣慢一半，放不出技能"], "d": ["要「定」免疫，鬼臉嚇法可以驅散", "要「定」免疫，鬼臉嚇法可以驅散"]},
	"cc_immune": {"n": "霸體", "ch": "霸", "c": "#6a5040", "w": ["腳軟、嚇退全部冇用", "腳軟、嚇退全部無效"], "d": ["要「破」或者「刺」純傷害", "要「破」或者「刺」純傷害"]},
	"revive": {"n": "屍變", "ch": "變", "c": "#56604a", "w": ["倒低四秒後半血再起", "倒下四秒後半血再起"], "d": ["場上有「收」就唔會再起", "場上有「收」就不會再起"]},
	"rush": {"n": "突襲", "ch": "襲", "c": "#8a4a3e", "w": ["繞過陰兵直衝後排", "繞過陰兵直衝後排"], "d": ["要「定」吸住佢，或者「拉」截停", "要「定」吸住它，或者「拉」截停"]},
	"confuse": {"n": "迷魂", "ch": "迷", "c": "#5e5a82", "w": ["我方三隻亂走", "我方三隻亂走"], "d": ["要「定」免疫", "要「定」免疫"]},
	"clone": {"n": "分身", "ch": "分", "c": "#6a7078", "w": ["分身吸走三成攻擊", "分身吸走三成攻擊"], "d": ["要「照」破分身，或者「掃」一次清", "要「照」破分身，或者「掃」一次清"]},
	"ranged": {"n": "遠", "ch": "遠", "c": "#4e6e86", "d": ["遠程：打得中飛行、唔食反傷", "遠程：打得中飛行、不受反傷"]},
	"pull": {"n": "拉", "ch": "拉", "c": "#7a6a3e", "d": ["腳軟拉落地、截停突襲", "腳軟拉落地、截停突襲"]},
	"sweep": {"n": "掃", "ch": "掃", "c": "#8a6a3a", "d": ["全體技：清散骨、分身", "全體技：清散骨、分身"]},
	"break": {"n": "破", "ch": "破", "c": "#8a4a3a", "d": ["破殼、無視霸體", "破殼、無視霸體"]},
	"pierce": {"n": "刺", "ch": "刺", "c": "#7a3a4a", "d": ["單體爆發、先斬召喚者", "單體爆發、先斬召喚者"]},
	"sap": {"n": "削", "ch": "削", "c": "#4a6a7a", "d": ["削嚇氣、停回血、延遲召喚", "削嚇氣、停回血、延遲召喚"]},
	"heal": {"n": "回", "ch": "回", "c": "#4a7a5a", "d": ["吸血／治療", "吸血／治療"]},
	"reveal": {"n": "照", "ch": "照", "c": "#9a8a3a", "d": ["現形、破分身", "現形、破分身"]},
	"steady": {"n": "定", "ch": "定", "c": "#5a5a6a", "d": ["免疫光環、迷魂，吸住突襲", "免疫光環、迷魂，吸住突襲"]},
	"seal": {"n": "收", "ch": "收", "c": "#3e4e5e", "d": ["收屍：敵人唔會屍變", "收屍：敵人不會屍變"]},
	"st_shield": {"n": "護盾", "ch": "盾", "c": "#4a7aa0"},
	"st_shell": {"n": "硬殼", "ch": "殼", "c": "#8a7450"},
	"st_stealth": {"n": "隱身", "ch": "隱", "c": "#6c6680"},
	"st_fly": {"n": "飛行", "ch": "飛", "c": "#5f7f96"},
	"st_ground": {"n": "擊落", "ch": "落", "c": "#7a6a3e"},
	"st_daze": {"n": "失神", "ch": "神", "c": "#7a5a96"},
	# [補丁43] buff／debuff 目錄（頭頂一排最多 4 個＋「+N」；點單位睇全部）
	"st_atk": {"n": "加攻", "ch": "攻", "c": "#a0543a", "d": ["攻擊提升", "攻擊提升"]},
	"st_aspd": {"n": "加速", "ch": "快", "c": "#a07a2a", "d": ["攻速提升", "攻速提升"]},
	"st_spd": {"n": "疾行", "ch": "疾", "c": "#6a8a3a", "d": ["移動加快", "移動加快"]},
	"st_def": {"n": "減傷", "ch": "守", "c": "#3e6a8a", "d": ["受到傷害減少", "受到傷害減少"]},
	"st_healup": {"n": "醫術", "ch": "醫", "c": "#3a8a6a", "d": ["治療量提升", "治療量提升"]},
	"st_hot": {"n": "回血", "ch": "回", "c": "#3a8a4a", "d": ["持續回血", "持續回血"]},
	"st_immune": {"n": "免疫", "ch": "免", "c": "#7a7a7a", "d": ["免疫部分控制", "免疫部分控制"]},
	"st_steady": {"n": "定神", "ch": "定", "c": "#5a5a7a", "d": ["唔受迷魂、光環影響", "不受迷魂、光環影響"]},
	"st_revive": {"n": "返生", "ch": "魂", "c": "#6a7a4a", "d": ["倒低會返生一次", "倒下會復活一次"]},
	"st_guard": {"n": "護衛", "ch": "護", "c": "#4a6a9a", "d": ["替身邊隊友分擔傷害", "替身邊隊友分擔傷害"]},
	"st_taunt": {"n": "嘲諷中", "ch": "嘲", "c": "#8a6a3a", "d": ["吸引敵人打自己", "吸引敵人攻擊自己"]},
	"st_atkd": {"n": "減攻", "ch": "弱", "c": "#5a3a4a", "neg": true, "d": ["攻擊下降", "攻擊下降"]},
	"st_slow": {"n": "減速", "ch": "慢", "c": "#3a5a7a", "neg": true, "d": ["移動變慢", "移動變慢"]},
	"st_aslow": {"n": "遲鈍", "ch": "鈍", "c": "#4a4a6a", "neg": true, "d": ["攻速下降", "攻速下降"]},
	"st_mark": {"n": "易傷", "ch": "傷", "c": "#8a3a3a", "neg": true, "d": ["受到傷害增加", "受到傷害增加"]},
	"st_abreak": {"n": "破甲", "ch": "破", "c": "#7a4a2a", "neg": true, "d": ["防護被破", "防護被破"]},
	"st_wound": {"n": "重創", "ch": "創", "c": "#6a2a3a", "neg": true, "d": ["治療效果下降", "治療效果下降"]},
	"st_silence": {"n": "封口", "ch": "封", "c": "#5a4a8a", "neg": true, "d": ["放唔到技能、副技", "放不出技能、副技"]},
	"st_stun": {"n": "定身", "ch": "僵", "c": "#6a5a2a", "neg": true, "d": ["郁唔到", "動不了"]},
	"st_down": {"n": "腳軟", "ch": "軟", "c": "#7a5a3a", "neg": true, "d": ["跌低企唔起", "跌倒站不起"]},
	"st_air": {"n": "嚇彈起", "ch": "起", "c": "#4a7a8a", "neg": true, "d": ["嚇到彈起半空", "嚇到彈到半空"]},
	"st_flee": {"n": "驚走", "ch": "逃", "c": "#5a6a3a", "neg": true, "d": ["嚇到逃走", "嚇到逃跑"]},
	"st_confuse": {"n": "迷魂", "ch": "迷", "c": "#5e5a82", "neg": true, "d": ["亂行亂撞", "亂走亂撞"]},
	"st_charm": {"n": "迷惑", "ch": "惑", "c": "#8a4a6a", "neg": true, "d": ["轉頭打自己友", "轉頭攻擊自己人"]},
	"st_taunted": {"n": "被嘲諷", "ch": "引", "c": "#7a5a2a", "neg": true, "d": ["只可以打嘲諷佢嗰隻", "只能攻擊嘲諷它的單位"]},
	"st_burn": {"n": "燒傷", "ch": "燒", "c": "#9a4a2a", "neg": true, "d": ["持續受傷（可疊 3 層）", "持續受傷（可疊 3 層）"]},
	"st_poison": {"n": "中毒", "ch": "毒", "c": "#4a7a3a", "neg": true, "d": ["持續受傷（可疊 3 層）", "持續受傷（可疊 3 層）"]},
	"st_claw": {"n": "抓傷", "ch": "抓", "c": "#7a3a2a", "neg": true, "d": ["持續受傷（可疊 3 層）", "持續受傷（可疊 3 層）"]},
	"st_curse": {"n": "陰氣", "ch": "陰", "c": "#4a3a5a", "neg": true, "d": ["持續受傷（可疊 3 層）", "持續受傷（可疊 3 層）"]},
	"st_saplock": {"n": "鎖嚇氣", "ch": "鎖", "c": "#3a4a6a", "neg": true, "d": ["唔會儲能量", "不會累積能量"]},
}
const TAGS := ["ranged", "pull", "sweep", "break", "pierce", "sap", "heal", "reveal", "steady", "seal"]
const TEAM_TAGS := ["reveal", "steady", "seal", "sap", "pull"]   # counter.md 5.4：軍師提供嘅全隊型標籤

static func info(k) -> Dictionary: return INFO.get(canon(k), {"n": str(k), "ch": str(k).substr(0, 1), "c": "#6a6060"})
static func name_of(k) -> String: return str(DB.L(str(info(k).get("n", str(k)))))

static var _tex := {}
static func _tex_of(k: String):
	if not _tex.has(k):
		var p = "res://art/ab/%s.png" % k
		_tex[k] = load(p) if ResourceLoader.exists(p) else null
	return _tex[k]

static func _col(k: String) -> Color:
	return Color(str(info(k).get("c", "#6a6060")))

# 畫一個圓形圖示：c＝中心、r＝半徑；dim＝灰（未應對／未有）
static func draw(ci: CanvasItem, key, c: Vector2, r: float, dim := false, a := 1.0) -> void:
	var k = canon(key)
	var base = _col(k)
	if dim: base = Color(0.36, 0.34, 0.34)
	ci.draw_circle(c + Vector2(0, r * 0.08), r, Color(0, 0, 0, 0.35 * a))
	var tx0 = _tex_of(k)
	if tx0 is Texture2D:   # [整合] 正式圖示本身已有底色同深褐圈：畫滿 2r，唔再疊自己嘅圈；未應對就變灰
		var m = Color(0.55, 0.53, 0.53, a) if dim else Color(1, 1, 1, a)
		ci.draw_texture_rect(tx0, Rect2(c - Vector2(r, r), Vector2(r, r) * 2.0), false, m)
		return
	ci.draw_circle(c, r, Color(base.darkened(0.15), 0.96 * a))
	ci.draw_circle(c, r * 0.82, Color(base.lightened(0.06), 0.96 * a))
	var tx = _tex_of(k)
	if tx is Texture2D:
		var s = r * 1.5
		ci.draw_texture_rect(tx, Rect2(c - Vector2(s, s) * 0.5, Vector2(s, s)), false, Color(1, 1, 1, a))
	else:
		_glyph(ci, k, c, r * 0.58, Color(BONE, a), Color(INK, a))
	ci.draw_arc(c, r, 0, TAU, 32, Color(INK, 0.95 * a), maxf(1.5, r * 0.12), true)

# 墨線符號（全部喺半徑 g 內，唔出界）
static func _ln(ci, pts: PackedVector2Array, col: Color, ink: Color, w: float) -> void:
	ci.draw_polyline(pts, ink, w + 2.2, true)
	ci.draw_polyline(pts, col, w, true)
static func _arc(ci, c: Vector2, r: float, a0: float, a1: float, col: Color, ink: Color, w: float) -> void:
	ci.draw_arc(c, r, a0, a1, 16, ink, w + 2.2, true)
	ci.draw_arc(c, r, a0, a1, 16, col, w, true)
static func _dot(ci, c: Vector2, r: float, col: Color, ink: Color) -> void:
	ci.draw_circle(c, r + 1.1, ink); ci.draw_circle(c, r, col)
static func _P(c: Vector2, g: float, a: Array) -> PackedVector2Array:
	var o = PackedVector2Array()
	for i in range(0, a.size(), 2): o.append(c + Vector2(a[i], a[i + 1]) * g)
	return o
static func _glyph(ci: CanvasItem, k: String, c: Vector2, g: float, col: Color, ink: Color) -> void:
	var w = maxf(1.4, g * 0.2)
	match k:
		"fly", "st_fly":   # 一對翼（實心骨白＋墨邊）＋身
			for sx in [-1.0, 1.0]:
				var wp = []
				for q in [0.05, 0.1, 0.4, -0.6, 0.98, -0.35, 0.78, -0.02, 0.9, 0.32, 0.52, 0.18, 0.3, 0.5]: wp.append(q)
				for i in range(0, wp.size(), 2): wp[i] *= sx
				var pg = _P(c, g, wp)
				ci.draw_colored_polygon(pg, col)
				pg.append(pg[0]); ci.draw_polyline(pg, ink, maxf(1.2, w * 0.7), true)
			_dot(ci, c + Vector2(0, 0.12) * g, g * 0.2, ink, ink)
		"stealth", "st_stealth":   # 半隻眼＋斜線
			_arc(ci, c + Vector2(0, g * 0.45), g * 0.85, PI * 1.15, PI * 1.85, col, ink, w)
			_arc(ci, c - Vector2(0, g * 0.45), g * 0.85, PI * 0.15, PI * 0.85, col, ink, w)
			_ln(ci, _P(c, g, [-0.8, 0.8, 0.8, -0.8]), col, ink, w)
		"shell", "st_shell":   # 六角龜殼
			var h = PackedVector2Array()
			for i in 7: h.append(c + Vector2.from_angle(PI / 6 + i * PI / 3) * g * 0.92)
			_ln(ci, h, col, ink, w)
			_ln(ci, _P(c, g, [-0.4, 0, 0.4, 0]), col, ink, w * 0.8)
		"st_shield":   # 盾
			_ln(ci, _P(c, g, [0, -0.9, 0.8, -0.6, 0.7, 0.2, 0, 0.95, -0.7, 0.2, -0.8, -0.6, 0, -0.9]), col, ink, w)
			_ln(ci, _P(c, g, [0, -0.55, 0, 0.55]), col, ink, w * 0.8)
		"regen":   # 十字＋圈箭
			_arc(ci, c, g * 0.85, -PI * 0.2, PI * 1.3, col, ink, w * 0.8)
			_ln(ci, _P(c, g, [0, -0.45, 0, 0.45]), col, ink, w); _ln(ci, _P(c, g, [-0.45, 0, 0.45, 0]), col, ink, w)
		"split":   # 一粒散三粒
			_dot(ci, c + Vector2(0, -0.45) * g, g * 0.24, col, ink)
			_dot(ci, c + Vector2(-0.6, 0.5) * g, g * 0.2, col, ink); _dot(ci, c + Vector2(0.6, 0.5) * g, g * 0.2, col, ink); _dot(ci, c + Vector2(0, 0.6) * g, g * 0.18, col, ink)
		"summon":   # 細公仔＋加號
			_dot(ci, c + Vector2(-0.35, -0.35) * g, g * 0.22, col, ink)
			_ln(ci, _P(c, g, [-0.75, 0.75, -0.35, 0.05, 0.05, 0.75]), col, ink, w)
			_ln(ci, _P(c, g, [0.5, -0.3, 0.5, 0.5]), col, ink, w); _ln(ci, _P(c, g, [0.1, 0.1, 0.9, 0.1]), col, ink, w)
		"thorns":   # 刺星
			var s = PackedVector2Array()
			for i in 13: s.append(c + Vector2.from_angle(-PI / 2 + i * PI / 6) * g * (0.95 if i % 2 == 0 else 0.45))
			_ln(ci, s, col, ink, w * 0.8)
		"fear_aura":   # 三圈波
			_dot(ci, c, g * 0.18, col, ink)
			_arc(ci, c, g * 0.5, 0, TAU, col, ink, w * 0.7); _arc(ci, c, g * 0.88, -PI * 0.3, PI * 0.3, col, ink, w * 0.7); _arc(ci, c, g * 0.88, PI * 0.7, PI * 1.3, col, ink, w * 0.7)
		"cc_immune":   # 鐵砧／磚
			_ln(ci, _P(c, g, [-0.85, -0.3, 0.85, -0.3, 0.55, 0.15, 0.55, 0.7, -0.55, 0.7, -0.55, 0.15, -0.85, -0.3]), col, ink, w)
			_ln(ci, _P(c, g, [-0.3, -0.85, 0.3, -0.85]), col, ink, w)
		"revive":   # 棺材＋向上箭
			_ln(ci, _P(c, g, [-0.4, -0.9, 0.4, -0.9, 0.6, -0.3, 0.4, 0.9, -0.4, 0.9, -0.6, -0.3, -0.4, -0.9]), col, ink, w * 0.8)
			_ln(ci, _P(c, g, [0, 0.5, 0, -0.45]), col, ink, w * 0.8); _ln(ci, _P(c, g, [-0.25, -0.2, 0, -0.5, 0.25, -0.2]), col, ink, w * 0.8)
		"rush":   # 雙箭頭
			_ln(ci, _P(c, g, [-0.85, -0.7, -0.15, 0, -0.85, 0.7]), col, ink, w)
			_ln(ci, _P(c, g, [0.0, -0.7, 0.7, 0, 0.0, 0.7]), col, ink, w)
		"confuse", "st_daze":   # 螺旋
			var sp = PackedVector2Array()
			for i in 26: sp.append(c + Vector2.from_angle(i * 0.5) * g * (0.08 + 0.034 * i))
			_ln(ci, sp, col, ink, w * 0.8)
		"clone":   # 兩個重疊人形
			_dot(ci, c + Vector2(-0.3, -0.4) * g, g * 0.24, Color(col, col.a * 0.55), ink)
			_dot(ci, c + Vector2(0.3, -0.3) * g, g * 0.24, col, ink)
			_ln(ci, _P(c, g, [-0.8, 0.8, -0.3, 0.05, 0.2, 0.8]), Color(col, col.a * 0.55), ink, w * 0.9)
			_ln(ci, _P(c, g, [-0.2, 0.85, 0.3, 0.15, 0.8, 0.85]), col, ink, w * 0.9)
		"ranged":   # 箭
			_ln(ci, _P(c, g, [-0.8, 0.8, 0.75, -0.75]), col, ink, w)
			_ln(ci, _P(c, g, [0.25, -0.8, 0.8, -0.8, 0.8, -0.25]), col, ink, w)
		"pull", "st_ground":   # 向下箭到地
			_ln(ci, _P(c, g, [0, -0.85, 0, 0.35]), col, ink, w); _ln(ci, _P(c, g, [-0.4, 0, 0, 0.4, 0.4, 0]), col, ink, w)
			_ln(ci, _P(c, g, [-0.8, 0.8, 0.8, 0.8]), col, ink, w)
		"sweep":   # 大弧
			_arc(ci, c + Vector2(0, g * 0.5), g * 1.0, PI * 1.1, PI * 1.9, col, ink, w)
			_arc(ci, c + Vector2(0, g * 0.6), g * 0.55, PI * 1.1, PI * 1.9, col, ink, w * 0.8)
		"break":   # 裂紋
			_ln(ci, _P(c, g, [-0.2, -0.9, 0.25, -0.3, -0.2, 0.1, 0.3, 0.9]), col, ink, w)
			_ln(ci, _P(c, g, [0.25, -0.3, 0.7, -0.45]), col, ink, w * 0.8)
		"pierce":   # 匕首
			_ln(ci, _P(c, g, [0, -0.95, 0.22, -0.2, 0, 0.2, -0.22, -0.2, 0, -0.95]), col, ink, w * 0.8)
			_ln(ci, _P(c, g, [-0.5, 0.3, 0.5, 0.3]), col, ink, w); _ln(ci, _P(c, g, [0, 0.3, 0, 0.9]), col, ink, w)
		"sap":   # 水滴減號
			_ln(ci, _P(c, g, [0, -0.9, 0.55, 0.1, 0.4, 0.6, 0, 0.8, -0.4, 0.6, -0.55, 0.1, 0, -0.9]), col, ink, w * 0.8)
			_ln(ci, _P(c, g, [-0.3, 0.3, 0.3, 0.3]), col, ink, w)
		"heal":   # 十字
			_ln(ci, _P(c, g, [0, -0.8, 0, 0.8]), col, ink, w * 1.4); _ln(ci, _P(c, g, [-0.8, 0, 0.8, 0]), col, ink, w * 1.4)
		"reveal":   # 燈籠
			ci.draw_circle(c + Vector2(0, 0.1) * g, g * 0.62 + 1.1, ink); ci.draw_circle(c + Vector2(0, 0.1) * g, g * 0.62, Color(1, 0.86, 0.5, col.a))
			_ln(ci, _P(c, g, [-0.3, -0.85, 0.3, -0.85]), col, ink, w); _ln(ci, _P(c, g, [-0.3, 0.85, 0.3, 0.85]), col, ink, w)
		"steady":   # 山／柱
			_ln(ci, _P(c, g, [-0.9, 0.75, -0.3, -0.5, 0.05, 0.1, 0.4, -0.75, 0.9, 0.75, -0.9, 0.75]), col, ink, w * 0.8)
		"seal":   # 鎖
			_arc(ci, c + Vector2(0, -0.25) * g, g * 0.42, PI, TAU, col, ink, w)
			_ln(ci, _P(c, g, [-0.6, -0.2, 0.6, -0.2, 0.6, 0.85, -0.6, 0.85, -0.6, -0.2]), col, ink, w * 0.8)
			_dot(ci, c + Vector2(0, 0.35) * g, g * 0.12, ink, ink)
		_:
			var f = UIKit.font("sans", 900)
			var t = str(info(k).get("ch", "?")); var px = int(g * 1.5)
			var tw = f.get_string_size(t, HORIZONTAL_ALIGNMENT_LEFT, -1, px).x
			ci.draw_string_outline(f, c + Vector2(-tw / 2, px * 0.36), t, HORIZONTAL_ALIGNMENT_LEFT, -1, px, 3, ink)
			ci.draw_string(f, c + Vector2(-tw / 2, px * 0.36), t, HORIZONTAL_ALIGNMENT_LEFT, -1, px, col)

# UI 用：一個圓圖示 Control（size＝直徑；圖一定喺格內）
class Icon extends Control:
	var key := ""
	var dim := false
	var ring := Color(0, 0, 0, 0)   # 亮起外圈（例如 ✔ 綠、✘ 紅）
	func _init(k := "", d := 40.0, dm := false) -> void:
		key = k; dim = dm
		custom_minimum_size = Vector2(d, d); size = Vector2(d, d)
		mouse_filter = Control.MOUSE_FILTER_PASS
	func _draw() -> void:
		var d = minf(size.x, size.y)
		var c = size * 0.5
		var r = d * 0.5 - 3.0
		if ring.a > 0: draw_arc(c, r + 1.5, 0, TAU, 36, ring, 3.0, true); r -= 2.0
		load("res://game/rts/ab_icon.gd").draw(self, key, c, r, dim)
