# [equip] 裝備暫代圖（程序墨線，core/art.gd 風格：墨線、偏灰病態色）——美術到咗換圖只改呢個檔
#   有 assets/spr/eqi_<id>.webp 就用圖（圖示＋手持共用：透明底、物件向上、手揸位喺底中間）
#   座標約定：每件喺 24×24 框（x −12..12、y −24..0），手揸位／底部中間＝(0,0)
extends RefCounted

const EQ = preload("res://game/equip/eq_data.gd")
const INK := "#2a1a10"
const HAND_SHAPES := ["pole", "duster", "cleaver", "cleaver_old", "axe", "ruler", "spatula", "shield", "umbrella", "mop", "pipe", "ring_sword", "abacus", "slipper", "slingshot", "fork_pole", "wok_spatula_gold", "coffin_shield"]
const LONG := ["pole", "duster", "mop", "fork_pole", "umbrella", "pipe", "ring_sword", "slingshot", "spatula", "wok_spatula_gold", "cleaver", "cleaver_old", "axe", "ruler"]   # [p44] 菜刀（cleaver_old）同柴刀共用畫法，之前漏咗入斜放圖示表同長兵器表

static func img_key(id: String) -> String: return "eqi_" + id
static func has_img(id: String) -> bool: return Spr.ok(img_key(id)) and Spr.get_tex(img_key(id)) != null
# 圖示專用（斜放 icon 版，商店／名冊／圖鑑用）：eqi_<id>_i；未有就退回手持圖 eqi_<id>（垂直，照舊轉 0.7）；再冇就程序畫
static func icon_key(id: String) -> String: return "eqi_%s_i" % id
static func has_icon(id: String) -> bool: return Spr.ok(icon_key(id)) and Spr.get_tex(icon_key(id)) != null
static func shape_of(id: String) -> String: return str(EQ.item(id).get("shape", ""))
static func is_long(id: String) -> bool: return LONG.has(shape_of(id))
# [補丁43] 漂浮兵器普攻方式：thrust 直刺、swing 揮斬、spin 轉住撞、throw 飛出去
const ATK := {"pole": "thrust", "fork_pole": "thrust", "mop": "thrust", "pipe": "swing", "cleaver": "swing", "cleaver_old": "swing", "ring_sword": "swing",
	"spatula": "swing", "wok_spatula_gold": "swing", "abacus": "swing", "stapler": "swing", "axe": "swing", "duster": "spin", "umbrella": "spin", "shield": "spin",
	"coffin_shield": "spin", "ruler": "thrust", "slipper": "throw", "slingshot": "throw"}   # [p44] 三角尺：尖角向前直刺
static func atk_style(id: String) -> String: return str(ATK.get(shape_of(id), "thrust"))

# 圖示：(x, y)＝底部中間；sz＝闊高；ring＝畫底圓＋等級色邊
static func icon(ctx: Ctx, id: String, x: float, y: float, sz: float, ring := true) -> void:
	var c = Vector2(x, y - sz * 0.5); var s = sz / 26.0
	if ring:
		var gc = EQ.grade_col(EQ.grade_of(id)) if str(EQ.item(id).get("kind")) in ["eq", "ex"] else Color("#8a8478")
		Art.el(ctx, c.x, c.y, sz * 0.5, sz * 0.5, "rgba(236,226,200,.94)", "#" + gc.to_html(false), maxf(1.2, 2.0 * s))
	if has_icon(id):
		Art.put(ctx, icon_key(id), x, y - sz * 0.08, sz * 0.84, sz * 0.84); return
	ctx.save(); ctx.translate(c.x, c.y); ctx.scale(s * 0.86, s * 0.86)
	if has_img(id):   # 冇 icon 版：用手持圖（垂直）照程序圖一樣斜放
		if HAND_SHAPES.has(shape_of(id)): ctx.rotate(0.7)
		ctx.translate(0, 12); Art.put(ctx, img_key(id), 0, 0, 24, 24); ctx.restore(); return
	if HAND_SHAPES.has(shape_of(id)):
		ctx.rotate(0.7); ctx.translate(0, 12)
	else: ctx.translate(0, 12)
	shape(ctx, shape_of(id))
	ctx.restore()

# 手持：(gx, gy)＝手位；L＝長度（世界 px）；ang＝弧度（0＝向上，正＝順時針）
# [補丁43 修正] 刀口方向：兵器直立時刀口喺圖嘅邊一邊（+1 右、−1 左）。規矩：目標喺邊，刀鋒就向邊（揮落時刀口行先）
#   [p44] 主角斧（eq_hero_axe）：斧刃喺右（預設 +1）；三角尺（eq_hero_ruler）：有刻度嗰條直邊（工作邊）喺左 → −1
const EDGE := {"eq_huanshou": -1, "ml_huanshou": -1, "eq_hero_ruler": -1}
static func edge_side(id: String) -> int: return int(EDGE.get(id, 1))
static func held(ctx: Ctx, id: String, gx: float, gy: float, L: float, ang: float, mir := false) -> void:
	ctx.save(); ctx.translate(gx, gy); ctx.rotate(ang)
	if mir: ctx.scale(-1, 1)   # 沿兵器長軸翻轉：刀口換邊
	var k = L / 24.0
	ctx.scale(k, k)
	if has_img(id): Art.put(ctx, img_key(id), 0, 0, 24, 24)
	else: shape(ctx, shape_of(id))
	ctx.restore()

static func _l(ctx: Ctx, x0: float, y0: float, x1: float, y1: float, col: String, w: float) -> void:
	ctx.strokeStyle = col; ctx.lineWidth = w
	ctx.beginPath(); ctx.moveTo(x0, y0); ctx.lineTo(x1, y1); ctx.stroke()

# 每件形狀（24×24 框；底中間＝揸位）
static func shape(ctx: Ctx, sh: String) -> void:
	match sh:
		"pole":   # 晾衫竹：長竹＋竹節＋衫夾
			_l(ctx, 0, 2, 0, -24, INK, 3.4); _l(ctx, 0, 2, 0, -24, "#8a9a58", 2.2)
			for y in [-6, -13, -20]: _l(ctx, -1.6, y, 1.6, y, INK, 0.9)
			Art.rr(ctx, 1.2, -18, 2.6, 5, 0.8, "#c8b080", INK, 0.6)
		"duster":   # 雞毛掃：竹柄＋一撮灰羽
			_l(ctx, 0, 2, 0, -12, INK, 2.8); _l(ctx, 0, 2, 0, -12, "#a8844a", 1.8)
			for i in 7:
				var a = -0.75 + i * 0.25
				Art.el(ctx, sin(a) * 4.0, -16 + absf(a) * 2.0 - cos(a) * 3.0, 2.0, 4.6, "#8c7f74" if i % 2 else "#b4a898", INK, 0.6)
		"stapler":   # [補丁43] 重型釘書機
			Art.rr(ctx, -9, -10, 18, 6, 2, "#3e4658", INK, 1.0); Art.rr(ctx, -9, -4, 18, 4, 1.5, "#5a6270", INK, 0.9)
			Art.rr(ctx, -9, -12, 6, 3, 1, "#c8483a", INK, 0.7)
		"coffee_cup":   # [補丁43] 凍咗嘅咖啡杯
			Art.rr(ctx, -6, -16, 12, 16, 2, "#f2ecd8", INK, 1.0); Art.el(ctx, 8, -9, 3.5, 4.5, null, INK, 1.4)
			Art.el(ctx, 0, -15, 5, 1.4, "#5a3a20")
		"luichar_bag":   # [補丁43] Lui Char 手袋（LC 字樣）
			Art.rr(ctx, -9, -14, 18, 14, 2, "#6a4a2a", INK, 1.0); Art.el(ctx, 0, -14, 5, 5, null, INK, 1.2)
			_l(ctx, -4, -9, -4, -4, "#e0c050", 1.2); _l(ctx, -4, -4, -1, -4, "#e0c050", 1.2); Art.el(ctx, 3, -6.5, 2.2, 2.6, null, "#e0c050", 1.2)
		"ex":   # [補丁43] 王牌專屬物（暫代：金邊錦囊）
			Art.el(ctx, 0, -9, 8, 9, "#8a2a5a", INK, 1.1); _l(ctx, -4, -17, 4, -17, "#e0c050", 1.6); Art.el(ctx, 0, -9, 3, 3, "#e0c050", INK, 0.6)
		"axe":   # [p44] 主角斧頭（暫代程序圖）：木柄＋斧頭，斧刃喺右（EDGE +1）
			_l(ctx, 0, 2, 0, -22, INK, 3.4); _l(ctx, 0, 2, 0, -22, "#b07a44", 2.2)
			for y in [-4, -10]: _l(ctx, -1.2, y, 1.2, y - 1, "#7a4e28", 0.7)
			Art.poly(ctx, [-1.5, -23, 3, -23.5, 9.5, -26, 10.5, -18.5, 9, -11.5, 3, -14.5, -1.5, -15], "#9a9aa2", INK, 1.0)
			_l(ctx, 9.6, -25, 9.8, -12.5, "#e8e8f0", 1.0)   # 刃口亮邊
			Art.poly(ctx, [-1.5, -22.5, -4.5, -21.5, -4.5, -16.5, -1.5, -15.5], "#6e6e76", INK, 0.8)
			Art.el(ctx, 5.5, -19, 1.2, 1.0, "#b8483a")
		"ruler":   # [p44] 女主三角尺（暫代程序圖）：直角三角形木尺，直邊（刻度）喺左（EDGE −1），尖角向上
			Art.poly(ctx, [-3.5, 1, -3.5, -25, 6.5, -7, 4.5, 1], "#e8b882", INK, 1.0)
			Art.poly(ctx, [-1.2, -3, -1.2, -16.5, 3.4, -6.5, 2.6, -3], "#3a2a3a", INK, 0.8)   # 中間鏤空（深色）
			for i in 9: _l(ctx, -3.5, -2 - i * 2.4, -2.2 if i % 2 else -1.4, -2 - i * 2.4, "#6a4428", 0.6)
		"cleaver", "cleaver_old":   # 生鏽柴刀（老字號菜刀共用）
			Art.rr(ctx, -1.5, -7, 3, 9, 1, "#6a4428", INK, 0.9)
			Art.poly(ctx, [-2, -7, 6, -7, 7, -20, 1, -22, -2, -18], "#8c7a6a", INK, 1.0)
			Art.el(ctx, 3.5, -12, 1.6, 1.2, "#9a5a32"); Art.el(ctx, 1.5, -17, 1.2, 1.0, "#9a5a32")
		"spatula", "wok_spatula_gold":   # 鐵鑊鏟（名品：金邊）
			var gold = sh == "wok_spatula_gold"
			_l(ctx, 0, 2, 0, -14, INK, 3.0); _l(ctx, 0, 2, 0, -14, "#6a4428", 2.0)
			Art.poly(ctx, [-5, -14, 5, -14, 6, -23, -6, -23], "#5a5a62", "#c8a030" if gold else INK, 1.4 if gold else 1.0)
			_l(ctx, -3, -18, 3, -18, "#8a8a92", 0.8)
			if gold:
				for k in 3: Art.el(ctx, -4 + k * 4, -25.5 - k % 2, 1.2, 1.8, "rgba(255,180,80,.8)")
		"shield":   # 藤牌：圓盾織紋
			Art.el(ctx, 0, -11, 9.5, 9.5, "#c8a868", INK, 1.2)
			Art.el(ctx, 0, -11, 6.0, 6.0, null, "#7a5a30", 0.9)
			Art.el(ctx, 0, -11, 2.8, 2.8, "#a8442e", INK, 0.7)
			for k in 6:
				var a = k * PI / 3.0
				_l(ctx, cos(a) * 3.0, -11 + sin(a) * 3.0, cos(a) * 9.0, -11 + sin(a) * 9.0, "#7a5a30", 0.7)
		"umbrella":   # 縮骨遮：開咗嘅遮（灰藍）
			_l(ctx, 0, 2, 0, -18, INK, 1.6)
			Art.poly(ctx, [-11, -15, -8, -21, 0, -24, 8, -21, 11, -15, 7, -16.5, 3.5, -15, 0, -16.5, -3.5, -15, -7, -16.5], "#5e6e80", INK, 1.0)
			_l(ctx, 0, 2, 2.5, 2, INK, 1.4)
		"mop":   # 地拖：木柄＋灰布條
			_l(ctx, 0, 2, 0, -17, INK, 2.6); _l(ctx, 0, 2, 0, -17, "#b89060", 1.6)
			for i in 6: _l(ctx, -5 + i * 2.0, -17, -6 + i * 2.4, -24, "#b8b0a0" if i % 2 else "#8e8678", 2.0)
			Art.rr(ctx, -5, -18.5, 10, 2.5, 1, "#6a6a6a", INK, 0.6)
		"pipe":   # 收數鐵通：鐵管＋黃膠布
			_l(ctx, 0, 2, 0, -24, INK, 4.6); _l(ctx, 0, 2, 0, -24, "#7a7e86", 3.2)
			_l(ctx, 0, -1, 0, -5, "#c8b048", 3.6)
			Art.el(ctx, 0, -24, 2.3, 1.3, "#5a5e66", INK, 0.7)
		"ring_sword":   # 環首刀：柄頭鐵環＋直刀身＋鏽斑
			Art.el(ctx, 0, 3, 2.4, 2.4, null, INK, 1.4)
			Art.rr(ctx, -1.4, -5, 2.8, 6, 0.8, "#4a3020", INK, 0.7)
			_l(ctx, -3.2, -5, 3.2, -5, INK, 1.4)
			Art.poly(ctx, [-1.6, -5, 1.8, -5, 1.6, -21, -0.2, -24, -1.6, -21], "#9a9a98", INK, 0.9)
			Art.el(ctx, 0.2, -11, 0.9, 1.4, "#9a5a32"); Art.el(ctx, -0.3, -17, 0.7, 1.0, "#9a5a32")
		"abacus":   # 鐵算盤：長方框＋珠
			Art.rr(ctx, -9, -20, 18, 18, 1.5, "#5a3a20", INK, 1.2)
			_l(ctx, -9, -15, 9, -15, INK, 1.0)
			for c in 5:
				var x = -7 + c * 3.5
				_l(ctx, x, -19, x, -3, "#c8b080", 0.6)
				Art.el(ctx, x, -17.5, 1.4, 1.0, "#2a2a2a")
				for r in 2: Art.el(ctx, x, -10 + r * 3 + (c % 2), 1.4, 1.0, "#2a2a2a")
		"slipper":   # 膠拖鞋：鞋底＋人字帶
			Art.el(ctx, 0, -11, 5.2, 11, "#4f8ab8", INK, 1.1)
			Art.el(ctx, 0, -11, 3.6, 9, "#77a8d0")
			_l(ctx, 0, -17, -3.5, -11, "#e6e0d0", 1.6); _l(ctx, 0, -17, 3.5, -11, "#e6e0d0", 1.6)
		"slingshot":   # 天台彈叉：Y 字木叉＋膠筋
			_l(ctx, 0, 2, 0, -11, INK, 3.0); _l(ctx, 0, 2, 0, -11, "#8a6a40", 2.0)
			_l(ctx, 0, -11, -5, -21, "#8a6a40", 2.2); _l(ctx, 0, -11, 5, -21, "#8a6a40", 2.2)
			_l(ctx, -5, -21, 0, -15, "#c85a3a", 0.9); _l(ctx, 5, -21, 0, -15, "#c85a3a", 0.9)
		"fork_pole":   # 晾衫叉：長竹＋頂 U 叉
			_l(ctx, 0, 2, 0, -20, INK, 3.0); _l(ctx, 0, 2, 0, -20, "#a0905a", 2.0)
			_l(ctx, -3.5, -20, 3.5, -20, "#5a5a5a", 1.6); _l(ctx, -3.5, -20, -3.5, -25, "#5a5a5a", 1.6); _l(ctx, 3.5, -20, 3.5, -25, "#5a5a5a", 1.6)
		"coffin_shield":   # 棺材板盾：六角木板＋釘
			Art.poly(ctx, [-6, -24, 6, -24, 9, -16, 7, 0, -7, 0, -9, -16], "#6e4a30", INK, 1.2)
			for p in [[-5, -21], [5, -21], [-5, -3], [5, -3]]: Art.el(ctx, p[0], p[1], 0.9, 0.9, "#c8c0b0")
			_l(ctx, 0, -22, 0, -2, "#4a3020", 0.8)
		"wok_helm":   # 反轉鐵鑊頭盔（頭戴：底邊＝0）
			Art.poly(ctx, [-11, 0, -9, -6, -5, -10, 5, -10, 9, -6, 11, 0], "#4a4a52", INK, 1.1)
			Art.el(ctx, -12, -1, 2.0, 1.5, null, INK, 1.0); Art.el(ctx, 12, -1, 2.0, 1.5, null, INK, 1.0)
			_l(ctx, -5, -7, 3, -8, "#8a8a92", 1.0)
		"hardhat":   # 工地安全帽（頭戴）
			Art.poly(ctx, [-12, 0, -9, -1, -8, -7, -4, -11, 4, -11, 8, -7, 9, -1, 12, 0], "#e0b43a", INK, 1.1)
			_l(ctx, 0, -11, 0, -2, "#b88a1a", 1.2)
		"wok_back":   # 反轉鐵鑊（揹喺背：圓鑊）
			Art.el(ctx, 0, -12, 10, 10, "#4a4a52", INK, 1.2); Art.el(ctx, -3, -15, 3, 2, "#6a6a72")
		"paper_armor", "ot_armor", "suit", "apron", "guard_uniform", "raincoat", "old_uniform", "manager_suit":   # 身上衫（圖示用）
			var col = {"paper_armor": "#d8cfc0", "ot_armor": "#3e4658", "suit": "#2e2e34", "apron": "#b8a888", "guard_uniform": "#41557a", "raincoat": "#d8dcc0", "old_uniform": "#7a8a6a", "manager_suit": "#4a2a3a"}[sh]
			Art.poly(ctx, [-10, -18, -4, -22, 4, -22, 10, -18, 9, 0, -9, 0], col, INK, 1.1)
			Art.poly(ctx, [-4, -22, 0, -16, 4, -22], "#f0e8d8", INK, 0.7)
			if sh == "paper_armor":
				for r in 3:
					for k in 4: Art.el(ctx, -5 + k * 3.4, -12 + r * 4.0, 1.7, 1.3, "#b8483a" if (r + k) % 2 == 0 else "#ece2cc", INK, 0.4)
			elif sh == "ot_armor" or sh == "old_uniform":
				Art.rr(ctx, 1, -10, 7, 5, 1, "#f2ecd8", INK, 0.7)
			elif sh == "apron":
				Art.el(ctx, -3, -8, 2.0, 1.4, "#8a5a2a"); Art.el(ctx, 3, -4, 1.6, 1.0, "#8a5a2a")
			elif sh == "guard_uniform":
				Art.rr(ctx, -7, -16, 4, 3, 0.5, "#e0c050", INK, 0.5)
		"staff_card", "gold_card":   # 員工證（掛繩）
			var gc = sh == "gold_card"
			_l(ctx, -4, -24, 0, -14, "#c8483a", 1.2); _l(ctx, 4, -24, 0, -14, "#c8483a", 1.2)
			Art.rr(ctx, -6, -14, 12, 14, 1.5, "#e0c050" if gc else "#f2ecd8", INK, 1.0)
			Art.rr(ctx, -4, -11, 4, 5, 0.5, "#9a9a9a"); _l(ctx, 1, -10, 4, -10, INK, 0.7); _l(ctx, 1, -8, 4, -8, INK, 0.7); _l(ctx, -4, -3, 4, -3, INK, 0.7)
		"tea_pot":   # 涼茶壺：瓦壺
			Art.el(ctx, 0, -9, 8, 8, "#7a4a2a", INK, 1.1); Art.rr(ctx, -3, -19, 6, 3, 1, "#7a4a2a", INK, 0.9)
			_l(ctx, 7, -10, 11, -15, INK, 1.8); Art.el(ctx, -2, -11, 2.5, 1.5, "#a8724a")
		"flashlight":   # 保安電筒：黑柄＋光
			Art.rr(ctx, -2.5, -16, 5, 16, 1.2, "#2e2e34", INK, 0.9); Art.rr(ctx, -4, -21, 8, 5, 1.2, "#5a5a62", INK, 0.9)
			Art.poly(ctx, [-4, -21, 4, -21, 8, -26, -8, -26], "rgba(255,240,170,.55)")
		"alarm_clock":   # 舊鬧鐘：兩隻鈴
			Art.el(ctx, 0, -10, 8, 8, "#c8483a", INK, 1.1); Art.el(ctx, 0, -10, 5.5, 5.5, "#f2ecd8", INK, 0.6)
			_l(ctx, 0, -10, 0, -14, INK, 0.9); _l(ctx, 0, -10, 3, -10, INK, 0.9)
			Art.el(ctx, -6, -18, 3, 2.4, "#c8a030", INK, 0.8); Art.el(ctx, 6, -18, 3, 2.4, "#c8a030", INK, 0.8)
		"whistle":   # 銀雞：銀色哨＋繩
			_l(ctx, -6, -22, 2, -12, "#c8483a", 1.0)
			Art.rr(ctx, -6, -12, 12, 6, 3, "#c8ccd4", INK, 1.0); Art.el(ctx, 2, -9, 3.5, 3.5, "#c8ccd4", INK, 1.0); Art.el(ctx, -4, -9, 1, 1, INK)
		"paper_phone":   # 紙紮手提電話：大磚頭機＋天線
			Art.rr(ctx, -5, -20, 10, 20, 1.5, "#d8cfb8", INK, 1.0); _l(ctx, 3, -20, 3, -25, INK, 1.2)
			Art.rr(ctx, -3.5, -17, 7, 5, 0.6, "#8aa080", INK, 0.6)
			for r in 3:
				for c in 3: Art.el(ctx, -2.5 + c * 2.5, -9 + r * 2.5, 0.8, 0.7, INK)
		"oil_bottle":   # 驅風油：細綠瓶
			Art.rr(ctx, -4, -14, 8, 14, 1.5, "#4e8a4a", INK, 1.0); Art.rr(ctx, -2, -18, 4, 4, 0.8, "#e0d8c0", INK, 0.8)
			Art.rr(ctx, -3, -10, 6, 5, 0.5, "#f2ecd8", INK, 0.5)
		_:
			Art.el(ctx, 0, -12, 8, 8, "#a89a88", INK, 1.0)
