# [motion] 大排檔區（合一地圖上半）角色「特別動作」：按鬼種類／身份
#  客人：專屬行路（跳、飄、紙片飄、醉步、躡手躡腳、回頭望、跌倒、倒行……）、排隊待機（每隻 n30 鬼用返佢自己嘅平日小動作，
#        原版鬼用廣場動作，冇身份嘅用通用隨機：抓頭、打喊露、望錶、竊竊私語）、攞到貨、等太耐、嬲走、開心走。
#  員工：按台做貨（搓、剪、攪、推磨、扇火……用村子打工嗰套 WORK 動作，原圖工具）、頂住貨行、低機率跌貨執返；
#        領班：有嘢做就巡、冇嘢做打瞌睡（Z），撳一下嚇醒。
#  村外惡鬼：遊蕩扭曲／爬行、貼柵欄窺望、出場（淡入＋由地升起）、被打抖、死時化煙；頭目：地面爆裂＋霧散出場。
#  義勇軍：入伍著裝轉身、企崗挺胸／敬禮、打嗰下撲前；守衛：換班伸懶腰。
# 全部用現有圖（Art.draw_char／DAILY 平日動作／WORK 打工動作）＋變形（擠壓伸展、搖擺、翻轉、殘影）＋蠟筆粒子；冇新畫角色。
# 冇 class_name（熱更新）；mv_scene.gd 用 preload 掛入（# [motion] 掛鈎）。
extends RefCounted

const MD = preload("res://game/outpost/mv_data.gd")
const SIM = preload("res://game/outpost/mv_sim.gd")
const FW := 390.0
const MAXP := 90

# ---------------- 每種鬼嘅行路方式 ----------------
const GAIT := {
	"pocong": "hop", "zombie": "hop", "laojiang": "hop", "n30_pelesit": "hop", "n30_polong": "hop", "n30_shedu": "hop",
	"n30_shanxiao": "hop1", "n30_kasaobake": "hop1",
	"xiaozhi": "paper", "zhiren": "paper", "n30_xiangcai": "paper",
	"youhun": "float", "shuigui": "float", "pontianak": "float", "n30_bunian": "fade", "n30_hanturaya": "float", "n30_banshee": "float",
	"n30_yukionna": "float", "pg_ji": "float", "xiaogui": "float", "mengpo": "float", "tianhua": "float",
	"baiwu": "glide", "heiwu": "glide", "n30_guixinniang": "glide",
	"penanggal": "head", "n30_diaosi": "dangle",
	"n30_jiugui": "drunk", "n30_danxiao": "sneak", "n30_xiasi": "sneak", "n30_chehuo": "glance", "n30_maoshi": "trip", "n30_churel": "moon",
	"n30_chengsi": "waddle", "n30_yesi": "waddle", "eguiking": "waddle", "egui": "shuffle", "n30_shidu": "shuffle",
	"niutou": "stomp", "mamian": "stomp", "n30_taozhai": "stomp", "n30_genderuwo": "stomp", "n30_yecha": "stomp", "n30_gashadokuro": "stomp",
	"n30_tikbalang": "trot", "n30_jerangkung": "rattle", "n30_hantugalah": "tall", "n30_rokurokubi": "tall",
	"n30_nopperabo": "brisk", "n30_daji": "hunch", "n30_xiaosi": "bounce", "toyol": "scamper", "n30_zipai": "selfie", "n30_dongsi": "freeze",
	"n30_leipi": "smoke", "n30_diansi": "zap", "n30_aswang": "flap", "n30_vetala": "glide", "pg_ex": "sulk", "pg_landlady": "brisk", "pg_songding": "sneak",
	"pg_tuimo": "hunch", "n30_qionggui": "shuffle", "n30_wutou": "nodwalk", "n30_kuchisake": "glide", "n30_hannya": "stomp",
	"n30_jenglot": "scamper", "n30_baigujing": "catwalk", "n30_phiam": "sleepy", "n30_kappa": "waddle", "n30_maenak": "glide", "n30_yezi": "sneak",
	"n30_liulian": "walk", "n30_zhongshu": "sleepy", "n30_changgui": "trot",
}
# 原版鬼（有網格）用嘅廣場平日動作（DAILY['plaza_*']，原圖）
const PLAZA := {
	"egui": ["plaza_sniff", "plaza_look"], "eguiking": ["plaza_eat", "plaza_sniff"], "xiaozhi": ["plaza_spin", "plaza_look", "plaza_shake"],
	"zhiren": ["plaza_spin", "plaza_shake", "plaza_look"], "zombie": ["plaza_dizzy", "plaza_look"], "laojiang": ["plaza_dizzy", "plaza_bow"],
	"pontianak": ["plaza_hair", "plaza_laugh"], "shuigui": ["plaza_shake", "plaza_look"], "youhun": ["plaza_boo", "plaza_look"],
	"baiwu": ["plaza_bow", "plaza_look"], "heiwu": ["plaza_bow", "plaza_look"], "niutou": ["plaza_stretch", "plaza_look"],
	"mamian": ["plaza_stretch", "plaza_look"], "mengpo": ["plaza_look", "plaza_stretch"], "tianhua": ["plaza_backrub", "plaza_look"],
	"xiaogui": ["plaza_boo", "plaza_laugh"], "afu": ["plaza_stretch", "plaza_look"], "huang": ["plaza_look", "plaza_stretch"],
}
const PLAZA_D := {"plaza_sniff": 2.6, "plaza_look": 2.0, "plaza_eat": 4.0, "plaza_spin": 2.2, "plaza_shake": 1.8, "plaza_dizzy": 2.2, "plaza_bow": 1.4,
	"plaza_hair": 2.3, "plaza_laugh": 1.8, "plaza_boo": 1.1, "plaza_stretch": 2.2, "plaza_backrub": 2.6, "plaza_doze": 6.0, "plaza_startle": 1.0, "plaza_wave": 1.6}
# 冇網格嘅特殊鬼（Pocong／Toyol／Penanggal）同冇骨架嘅新鬼：用變形待機
const T_IDLE := {"pocong": ["t_hop", "t_armup", "t_look"], "toyol": ["t_peek", "t_peek", "t_look"], "penanggal": ["t_hover", "t_look", "t_laugh"],
	"pg_songding": ["t_look", "t_scratch"], "pg_ji": ["t_hover", "t_look"], "pg_ex": ["t_phone", "t_sigh"], "pg_landlady": ["t_watch", "t_count"], "pg_tuimo": ["t_sigh", "t_yawn"]}
const GENERIC := ["t_yawn", "t_scratch", "t_watch", "t_whisper", "t_look"]
const T_D := {"t_yawn": 1.8, "t_scratch": 1.5, "t_watch": 2.0, "t_whisper": 2.2, "t_look": 1.6, "t_hop": 1.0, "t_armup": 1.8, "t_peek": 3.4, "t_hover": 2.4,
	"t_laugh": 1.8, "t_phone": 2.4, "t_sigh": 2.0, "t_count": 2.2}
# 等太耐：有專屬就用專屬平日動作
const IMPAT := {"n30_nopperabo": "n30_nopperabo_watch", "n30_taozhai": "n30_taozhai_knock", "n30_guhangui": "n30_guhangui_abacus", "n30_hannya": "n30_hannya_fume",
	"n30_jiugui": "n30_jiugui_drink", "n30_yangui": "n30_yangui_cough", "n30_dugui": "n30_dugui_dice", "n30_shidu": "n30_shidu_run", "n30_daji": "n30_daji_play",
	"n30_tikbalang": "n30_tikbalang_stomp", "n30_yecha": "n30_yecha_roar", "n30_diansi": "n30_diansi_zap", "n30_xiasi": "n30_xiasi_look"}
const GLUTTON := {"egui": 1, "eguiking": 1, "n30_chengsi": 1, "n30_yesi": 1, "n30_gashadokuro": 1}
const PAPER := {"xiaozhi": 1, "zhiren": 1, "n30_xiangcai": 1}
const WET := {"shuigui": 1, "n30_kappa": 1}
const FOOD := {"m_shoubao": 1, "m_douhua": 1, "m_nuomici": 1, "m_yejiangfan": 1, "m_liulian": 1, "m_wucha": 1, "m_xianyu": 1, "m_ningmengcha": 1,
	"m_mengpotang": 1, "m_waimai": 1, "m_baogu": 1, "m_jiaoye": 1, "m_zhulong": 1, "m_tiaodan": 1}
# 有火嘅台（紙紮鬼走近會縮開）
const FIRE := {"mvs_steamer": 1, "mvs_kiln": 1, "mvs_soup": 1, "mvs_charcoal": 1, "mvs_ricepot": 1, "mvs_baogu": 1, "mvs_lamp": 1, "mvs_denglong": 1, "mvs_teahouse": 1}
# 台 → 村子打工動作（WORK，原圖工具；兩個輪住做）
const ST_ACT := {"mvs_steamer": ["knead", "steam"], "mvs_tailor": ["reap", "sight"], "mvs_well": ["plant", "rest"], "mvs_mill": ["push", "push"],
	"mvs_kiln": ["burn", "rest"], "mvs_denglong": ["chop", "hammer"], "mvs_tiaodan": ["crate", "rest"], "mvs_charcoal": ["burn", "chop"],
	"mvs_rubber": ["knead", "push"], "mvs_bamboo": ["sand", "sight"], "mvs_durian": ["chop", "crate"], "mvs_ricepot": ["steam", "knead"],
	"mvs_straw": ["knead", "sight"], "mvs_teahouse": ["steam", "rest"], "mvs_coffin": ["hammer", "sand"], "mvs_huajiao": ["hammer", "sight"],
	"mvs_notice": ["sight", "sand"], "mvs_ganlu": ["crate", "push"], "mvs_banana": ["knead", "crate"], "mvs_fish": ["plant", "crate"],
	"mvs_lemon": ["steam", "knead"], "mvs_exchange": ["coins", "sight"], "mvs_float": ["blow", "push"], "mvs_pier": ["inspect", "coins"],
	"mvs_delivery": ["crate", "knead"], "mvs_phone": ["hammer", "sight"], "mvs_watch": ["sight", "hammer"], "mvs_garage": ["hammer", "push"],
	"mvs_vinegar": ["steam", "crate"], "mvs_cinema": ["inspect", "coins"], "mvs_baogu": ["burn", "steam"], "mvs_soup": ["steam", "burn"],
	"mvs_copier": ["push", "coins"], "mvs_umbrella": ["reap", "sand"], "mvs_files": ["coins", "sight"], "mvs_lamp": ["burn", "hammer"],
	"mvs_lounge": ["hammer", "sand"], "mvs_daka": ["coins", "push"], "mvs_house": ["crate", "push"]}
# 剪紙嘅台：做貨時飄紙碎
const SNIP := {"mvs_tailor": 1, "mvs_umbrella": 1, "mvs_notice": 1, "mvs_copier": 1}
# 村外惡鬼遊蕩樣
const FOE_ROAM := {"youhun": "twist", "zhiren": "flutter", "shuigui": "crawl", "egui": "crawl", "n30_jerangkung": "rattle", "n30_changgui": "prowl",
	"n30_aswang": "flap", "n30_kuchisake": "stalk", "n30_hannya": "twist", "toyol": "scamper", "pontianak": "twist", "penanggal": "twist"}

var parts: Array = []
var seen := {}          # 測試用：type → {動作名: true}
var _rng := RandomNumberGenerator.new()
var _prof := {}
var _tap_t := -9.0
var fore_pos := {}      # sid → Vector2（領班企位；畫嗰陣計）
var fore_mo := {}       # sid → 領班狀態
var perf_us := 0        # 測試用：今幀 motion 額外耗時（微秒）

func _init() -> void: _rng.randomize()

# ======================= 資料 =======================
static func _sid_of(type: String) -> String: return type.substr(4) if type.begins_with("n30_") else type
func daily_acts(type: String) -> Array:
	var N = J.G.get("N30D"); var A = J.gp(N, "ACTS") if N != null else null
	var out = []
	if A is Dictionary and type.begins_with("n30_") and A.get(_sid_of(type)) is Array:
		for e in A[_sid_of(type)]: out.append([J.str(e[0]), J.num(e[2])])
	return out
func profile(type: String) -> Dictionary:
	if _prof.has(type): return _prof[type]
	var p = {"gait": GAIT.get(type, "walk"), "idle": [], "mesh": Art._ma_has(type) and not Art._special_has(type)}
	for a in daily_acts(type): p.idle.append(a)
	if p.idle.is_empty() and p.mesh and PLAZA.has(type):
		for a in PLAZA[type]: p.idle.append([a, PLAZA_D.get(a, 2.0)])
	if T_IDLE.has(type):
		for a in T_IDLE[type]: p.idle.append([a, T_D[a]])
	p["specific"] = not p.idle.is_empty() or GAIT.has(type)
	if p.idle.is_empty() and p.mesh:
		for a in ["plaza_look", "plaza_stretch", "plaza_laugh"]: p.idle.append([a, PLAZA_D[a]])
	_prof[type] = p
	return p
func _mark(type: String, what: String) -> void:
	if not seen.has(type): seen[type] = {}
	seen[type][what] = true

static func _mo(e: Dictionary) -> Dictionary:
	if not (e.get("_mo") is Dictionary): e["_mo"] = {"act": "", "at": 0.0, "gap": randf_range(0.4, 2.2), "re": "", "rt": 0.0, "age": 0.0, "wt": 0.0, "got": 0, "st": "", "qt": 0.0, "seed": randf() * 100.0}
	return e["_mo"]
static func _env(t: float, a: float, b: float, c: float, d: float) -> float:
	if t <= a or t >= d: return 0.0
	if t < b: return (t - a) / maxf(0.001, b - a)
	if t > c: return 1.0 - (t - c) / maxf(0.001, d - c)
	return 1.0
static func _ez(k: float) -> float: k = clampf(k, 0, 1); return k * k * (3.0 - 2.0 * k)

# ======================= 粒子（世界座標） =======================
func _add(p: Dictionary) -> void:
	if parts.size() >= MAXP: parts.pop_front()
	p["t"] = 0.0
	parts.append(p)
func puff(x: float, y: float, col: String, n: int, sp := 30.0, life := 0.8, r := 5.0) -> void:
	for i in n:
		var an = _rng.randf_range(-PI, 0.0)
		_add({"k": "puff", "x": x + _rng.randf_range(-6, 6), "y": y, "vx": cos(an) * sp * _rng.randf_range(0.4, 1.0), "vy": sin(an) * sp * _rng.randf_range(0.3, 1.0) - 8.0,
			"life": life * _rng.randf_range(0.8, 1.2), "r": r * _rng.randf_range(0.7, 1.3), "c": col})
func drop(x: float, y: float, col: String, vx := 0.0) -> void:
	_add({"k": "drop", "x": x, "y": y, "vx": vx, "vy": -10.0, "life": 0.7, "r": 2.2, "c": col, "gy": y + 40.0})
func ftxt(x: float, y: float, s: String, col: String, life := 1.2, sz := 15) -> void:
	_add({"k": "txt", "x": x, "y": y, "vx": 0.0, "vy": -18.0, "life": life, "s": s, "c": col, "sz": sz})

func step(sc, dt: float) -> void:
	var t0 = Time.get_ticks_usec()
	for p in parts.duplicate():
		p.t += dt
		if p.t >= p.life: parts.erase(p); continue
		match p.k:
			"drop":
				p.vy += 260.0 * dt; p.x += p.vx * dt; p.y += p.vy * dt
				if p.y >= p.gy: p.y = p.gy; p.vy = 0.0; p.vx = 0.0
			"good":
				if p.t < p.get("fall", 0.35):
					p.vy += 420.0 * dt; p.x += p.vx * dt; p.y = minf(p.y + p.vy * dt, p.gy)
			"print", "crack", "ring": pass
			_:
				p.x += p.vx * dt; p.y += p.vy * dt; p.vx *= (1.0 - minf(1.0, 2.0 * dt))
	var sim = sc.sim
	if sim == null or sim.st() == null: return
	for c in sim.custs: _step_cust(sc, c, dt)
	for w in sim.workers: _step_worker(sc, w, dt)
	for f in sim.foes: _step_foe(sc, f, dt)
	for g in sim.guards: _step_guard(sc, g, dt)
	if sim.war != null:
		for r in sim.war.vols: _step_vol(sc, r, dt)
	for sid in fore_mo.keys(): _step_fore(sc, sid, dt)
	perf_us = Time.get_ticks_usec() - t0

# 畫：地面粒子（腳印、裂地）入 y 排序；其他喺上層
func add_items(sc, ctx: Ctx, items: Array, vy0: float, vy1: float) -> void:
	var t0 = Time.get_ticks_usec()
	for p in parts:
		if p.y < vy0 - 40.0 or p.y > vy1 + 40.0: continue
		var pp = p
		var gy = p.y - 60.0 if p.k in ["print", "crack", "ring"] else p.y + 20.0
		if p.k == "good": gy = p.gy
		items.append([gy, func(): _draw_part(sc, ctx, pp)])
	_fore_items(sc, ctx, items, vy0, vy1)
	perf_us += Time.get_ticks_usec() - t0
func _draw_part(sc, ctx: Ctx, p: Dictionary) -> void:
	var k = clampf(p.t / p.life, 0, 1); var a = 1.0 - k
	ctx.save()
	match p.k:
		"puff":
			ctx.globalAlpha = a * 0.55; Art.el(ctx, p.x, p.y, p.r * (1.0 + k * 1.6), p.r * (0.8 + k * 1.2), p.c)
		"drop":
			ctx.globalAlpha = minf(1.0, a * 1.6); Art.el(ctx, p.x, p.y, p.r * 0.8, p.r * 1.2, p.c, "rgba(20,30,40,.5)", 0.6)
		"txt":
			ctx.globalAlpha = minf(1.0, a * 2.0); sc._txt(ctx, p.s, p.x, p.y, int(p.sz), Color(p.c), "center", 900, 3)
		"print":
			ctx.globalAlpha = a * 0.5
			Art.el(ctx, p.x, p.y, 4.5, 2.2, "rgba(90,150,200,.85)"); Art.el(ctx, p.x + 2, p.y - 0.5, 1.6, 0.9, "rgba(200,235,255,.7)")
		"spark":
			ctx.globalAlpha = a; Art.el(ctx, p.x, p.y, 1.8 + 2.0 * a, 1.8 + 2.0 * a, p.c)
		"good":
			var back = clampf((p.t - p.get("hold", 0.9)) / 0.35, 0, 1)
			var x = lerpf(p.x, p.tx, _ez(back)); var y = lerpf(p.y, p.ty, _ez(back)) - sin(PI * back) * 24.0
			ctx.globalAlpha = 1.0 if back < 1.0 else 0.0
			sc._icon(ctx, str(p.gid), x, y, 18.0)
		"crack":
			ctx.globalAlpha = minf(1.0, 3.0 * a) * 0.85
			var g = clampf(p.t / 0.35, 0, 1)
			ctx.strokeStyle = "#160a08"; ctx.lineWidth = 3.0; ctx.lineCap = "round"
			for i in 7:
				var an = PI * (i / 6.0) + sin(i * 7.3) * 0.25
				var L = (26.0 + 16.0 * sin(i * 3.1 + 1.0)) * g
				ctx.beginPath(); ctx.moveTo(p.x, p.y)
				var mx = p.x + cos(an) * L * 0.5 + sin(i * 5.0) * 5.0; var my = p.y + sin(an) * L * 0.22
				ctx.lineTo(mx, my); ctx.lineTo(p.x + cos(an) * L, p.y + sin(an) * L * 0.42); ctx.stroke()
			ctx.strokeStyle = "rgba(255,90,50,.55)"; ctx.lineWidth = 1.2
			for i in 7:
				var an2 = PI * (i / 6.0) + sin(i * 7.3) * 0.25; var L2 = (26.0 + 16.0 * sin(i * 3.1 + 1.0)) * g
				ctx.beginPath(); ctx.moveTo(p.x, p.y); ctx.lineTo(p.x + cos(an2) * L2 * 0.7, p.y + sin(an2) * L2 * 0.3); ctx.stroke()
		"ring":
			var r = 20.0 + 90.0 * _ez(k)
			ctx.globalAlpha = a * 0.45
			Art.el(ctx, p.x, p.y, r, r * 0.34, "rgba(200,205,215,.55)")
			ctx.globalAlpha = a * 0.3
			Art.el(ctx, p.x, p.y - 8, r * 0.7, r * 0.28, "rgba(220,225,235,.6)")
		"z":
			ctx.globalAlpha = sin(PI * k); sc._txt(ctx, "z" if p.get("small", false) else "Z", p.x + sin(p.t * 3.0) * 4.0, p.y, int(p.sz), Color("#c8d8ff"), "center", 900, 3)
	ctx.restore()

# ======================= 共用：畫身體（變形包住 Art.draw_char） =======================
# tf: dx, dy（向上負）, r（向前正，弧度）, sx, sy, gs（地影）, ghost（殘影 alpha）
func body(ctx: Ctx, k: String, x: float, y: float, s: float, o: Dictionary, tf: Dictionary) -> void:
	var fwd = -1.0 if o.get("flip", false) else 1.0
	var dx = float(tf.get("dx", 0.0)); var dy = float(tf.get("dy", 0.0)); var r = float(tf.get("r", 0.0)) * fwd
	var sx = float(tf.get("sx", 1.0)); var sy = float(tf.get("sy", 1.0))
	x = clampf(x + dx, 16.0, FW - 16.0)
	if tf.has("gs"):   # 跳／飄：影留喺地面
		o["shadow"] = false
		var lift = clampf(-dy / 30.0, 0.0, 1.0)
		ctx.save(); ctx.globalAlpha *= float(o.get("alpha", 1.0)) * (0.55 - 0.3 * lift); Art.shadow(ctx, x, y + 1.0, s * float(tf.gs) * (1.0 - 0.35 * lift)); ctx.restore()
	if tf.has("ghost") and float(tf.ghost) > 0.0:   # 殘影（Penanggal 身留低）
		var og = o.duplicate(); og["alpha"] = float(o.get("alpha", 1.0)) * float(tf.ghost); og["shadow"] = false; og.erase("act")
		ctx.save(); ctx.translate(x, y); ctx.scale(1.0, 0.92); Art.draw_char(ctx, k, 0, 0, s, og); ctx.restore()
	if dy == 0.0 and r == 0.0 and sx == 1.0 and sy == 1.0:
		Art.draw_char(ctx, k, x, y, s, o); return
	ctx.save(); ctx.translate(x, y + dy)
	if r != 0.0: ctx.rotate(r)
	ctx.scale(sx, sy)
	Art.draw_char(ctx, k, 0, 0, s, o)
	ctx.restore()

static func head_of(k: String, x: float, y: float, s: float, fwd: float) -> Vector2:
	var H = maxf(30.0, Art.char_h(k)) * s
	return Vector2(x + fwd * H * 0.06, y - H * 0.86)

# 冇網格／冇平日動作嗰批用嘅變形待機（同時都係通用隨機待機）
func t_idle(act: String, at: float, dur: float, tf: Dictionary, o: Dictionary, k: String, x: float, y: float, s: float, sc, ctx, extra := {}) -> Array:
	var e = _env(at, 0.0, 0.25, dur - 0.3, dur); var fx = []
	var fwd = -1.0 if o.get("flip", false) else 1.0
	var hp = head_of(k, x, y, s, fwd)
	match act:
		"t_yawn":
			tf["sy"] = float(tf.get("sy", 1.0)) * (1.0 + 0.06 * e); tf["r"] = float(tf.get("r", 0.0)) - 0.06 * e
			fx.append(["txt", "呵～", hp + Vector2(fwd * 12.0, -10.0 - at * 6.0), e, "#e8dcc4"])
		"t_scratch":
			tf["r"] = float(tf.get("r", 0.0)) + sin(at * 28.0) * 0.035 * e
			fx.append(["scratch", hp + Vector2(-fwd * 10.0, 2.0), e, at])
		"t_watch":
			tf["r"] = float(tf.get("r", 0.0)) + 0.07 * e
			fx.append(["clock", hp + Vector2(fwd * 14.0, 22.0), e, at])
		"t_whisper":
			var side = float(extra.get("side", fwd))
			tf["r"] = float(tf.get("r", 0.0)) + 0.09 * e * side * fwd; o["flip"] = side < 0
			fx.append(["txt", "噓…", hp + Vector2(side * 16.0, -6.0), e, "#d8d0f0"])
		"t_look":
			var mid = at > dur * 0.3 and at < dur * 0.75
			if mid: o["flip"] = not o.get("flip", false)
			fx.append(["txt", "？", hp + Vector2(0, -12.0), _env(at, dur * 0.3, dur * 0.4, dur * 0.65, dur * 0.75), "#f3d68a"])
		"t_hop":
			var hpz = clampf(at / dur, 0, 1); var up = sin(PI * clampf((hpz - 0.2) / 0.65, 0, 1))
			var crouch = sin(PI * clampf(hpz / 0.2, 0, 1)) if hpz < 0.2 else 0.0
			tf["dy"] = float(tf.get("dy", 0.0)) - up * 14.0 * s; tf["sy"] = float(tf.get("sy", 1.0)) * (1.0 - 0.12 * crouch + 0.06 * up); tf["sx"] = float(tf.get("sx", 1.0)) * (1.0 + 0.08 * crouch - 0.03 * up); tf["gs"] = 0.9
		"t_armup":   # Pocong：「終於可以舉手了」——成條伸長、左右擰
			tf["sy"] = float(tf.get("sy", 1.0)) * (1.0 + 0.08 * e); tf["sx"] = float(tf.get("sx", 1.0)) * (1.0 - 0.05 * e); tf["r"] = float(tf.get("r", 0.0)) + sin(at * 9.0) * 0.08 * e
			fx.append(["txt", "舉手！", hp + Vector2(0, -14.0), e, "#f3d68a"])
		"t_peek":   # Toyol：偷望櫃台冥幣 → 被望到即刻扮乖
			var lean = _env(at, 0.0, 0.5, 1.5, 1.7); var caught = _env(at, 1.6, 1.7, dur - 0.2, dur)
			var to_c = float(extra.get("to_counter", fwd))
			if lean > 0.0: o["flip"] = to_c < 0
			var f2 = -1.0 if o.get("flip", false) else 1.0
			tf["r"] = float(tf.get("r", 0.0)) + 0.2 * lean * (1.0 if f2 == to_c else -1.0)
			tf["sy"] = float(tf.get("sy", 1.0)) * (1.0 - 0.06 * lean + 0.05 * caught)
			if lean > 0.3: fx.append(["coin", hp + Vector2(to_c * 26.0, 6.0), lean, at])
			if at > 1.5 and at < 2.1: fx.append(["txt", "！", hp + Vector2(0, -14.0), _env(at, 1.5, 1.55, 1.95, 2.1), "#ff8a6a"])
			if caught > 0.0:
				o["flip"] = false
				fx.append(["txt", "乖～", hp + Vector2(fwd * 14.0, -8.0), caught, "#c8f5b8"])
				fx.append(["spark", hp + Vector2(-12.0, -4.0), caught, at])
		"t_hover":
			tf["dy"] = float(tf.get("dy", 0.0)) - 10.0 * e - sin(at * 3.0) * 3.0 * e; tf["r"] = float(tf.get("r", 0.0)) + sin(at * 2.2) * 0.1 * e; tf["gs"] = 0.8
		"t_laugh":
			tf["sy"] = float(tf.get("sy", 1.0)) * (1.0 - absf(sin(at * 14.0)) * 0.04 * e)
			fx.append(["txt", "嘻嘻", hp + Vector2(-fwd * 14.0, -6.0 - at * 4.0), e, "#c8f5b8"])
		"t_phone":
			tf["r"] = float(tf.get("r", 0.0)) + 0.1 * e
			fx.append(["txt", "哦。", hp + Vector2(fwd * 16.0, -8.0), _env(at, 0.8, 1.0, dur - 0.3, dur), "#d8d0f0"])
		"t_sigh":
			tf["sy"] = float(tf.get("sy", 1.0)) * (1.0 - 0.05 * e); tf["r"] = float(tf.get("r", 0.0)) + 0.06 * e
			fx.append(["txt", "唉……", hp + Vector2(fwd * 14.0, -6.0 + at * 3.0), e, "#b8c0d0"])
		"t_count":
			tf["r"] = float(tf.get("r", 0.0)) + 0.05 * e
			fx.append(["coin", hp + Vector2(fwd * 14.0, 20.0), e, at])
	return fx

func draw_fx(sc, ctx: Ctx, fx: Array) -> void:
	for f in fx:
		match f[0]:
			"txt":
				if float(f[3]) <= 0.01: continue
				ctx.save(); ctx.globalAlpha *= clampf(float(f[3]), 0, 1); sc._txt(ctx, str(f[1]), f[2].x, f[2].y, 15, Color(f[4]), "center", 900, 3); ctx.restore()
			"scratch":
				var p: Vector2 = f[1]; var a = float(f[2])
				if a <= 0.01: continue
				ctx.save(); ctx.globalAlpha *= a; ctx.strokeStyle = "#f3e2bd"; ctx.lineWidth = 1.6; ctx.lineCap = "round"
				for i in 3:
					var ph = fmod(float(f[3]) * 6.0 + i * 0.33, 1.0)
					ctx.beginPath(); ctx.moveTo(p.x - 5 + i * 5, p.y - 4 - ph * 4); ctx.lineTo(p.x - 3 + i * 5, p.y + 2 - ph * 4); ctx.stroke()
				ctx.restore()
			"clock":
				var p2: Vector2 = f[1]; var a2 = float(f[2])
				if a2 <= 0.01: continue
				ctx.save(); ctx.globalAlpha *= a2
				Art.el(ctx, p2.x, p2.y, 7, 7, "#f3e2bd", "#2b1d12", 1.4)
				ctx.strokeStyle = "#2b1d12"; ctx.lineWidth = 1.4; ctx.beginPath(); ctx.moveTo(p2.x, p2.y); ctx.lineTo(p2.x, p2.y - 5)
				var an = float(f[3]) * 4.0; ctx.moveTo(p2.x, p2.y); ctx.lineTo(p2.x + cos(an) * 4.0, p2.y + sin(an) * 4.0); ctx.stroke()
				ctx.restore()
				sc._txt(ctx, "…", p2.x + 10, p2.y - 14, 15, Color("#e8dcc4"), "center", 900, 3)
			"coin":
				var p3: Vector2 = f[1]; var a3 = float(f[2])
				if a3 <= 0.01: continue
				ctx.save(); ctx.globalAlpha *= a3
				var sx = absf(cos(float(f[3]) * 5.0))
				ctx.translate(p3.x, p3.y); ctx.scale(maxf(0.2, sx), 1.0)
				Art.el(ctx, 0, 0, 5.5, 5.5, "#e8b84a", "#6a4a10", 1.2); ctx.restore()
			"spark":
				var p4: Vector2 = f[1]; var a4 = float(f[2])
				ctx.save(); ctx.globalAlpha *= a4
				for i in 3:
					var ph2 = fmod(float(f[3]) * 1.7 + i * 0.33, 1.0)
					Art.el(ctx, p4.x + i * 12.0 - 6.0, p4.y - ph2 * 10.0, 2.2 * (1.0 - ph2) + 0.6, 2.2 * (1.0 - ph2) + 0.6, "#fff2b0")
				ctx.restore()
			"anger":   # 漫畫青筋（四瓣向內彎）
				var p5: Vector2 = f[1]; var a5 = float(f[2])
				if a5 <= 0.01: continue
				var pu = 1.0 + 0.18 * sin(float(f[3]) * 14.0); var R = 6.5 * pu
				ctx.save(); ctx.globalAlpha *= a5; ctx.lineCap = "round"
				for pass_i in 2:
					ctx.strokeStyle = "rgba(40,8,6,.9)" if pass_i == 0 else "#ff4a32"; ctx.lineWidth = 4.2 if pass_i == 0 else 2.2
					for i in 4:
						var an2 = PI * 0.5 * i + PI * 0.25
						var a0 = Vector2(cos(an2 - 0.55), sin(an2 - 0.55)) * R; var a1 = Vector2(cos(an2 + 0.55), sin(an2 + 0.55)) * R
						var cc = Vector2(cos(an2), sin(an2)) * R * 0.35
						ctx.beginPath(); ctx.moveTo(p5.x + a0.x, p5.y + a0.y); ctx.lineTo(p5.x + cc.x, p5.y + cc.y); ctx.lineTo(p5.x + a1.x, p5.y + a1.y); ctx.stroke()
				ctx.restore()
			"sweat":
				var p6: Vector2 = f[1]; var a6 = float(f[2])
				var ph3 = fmod(float(f[3]) * 1.6, 1.0)
				ctx.save(); ctx.globalAlpha *= a6 * (1.0 - ph3)
				Art.el(ctx, p6.x, p6.y + ph3 * 10.0, 2.0, 3.0, "rgba(160,215,255,.95)", "rgba(20,40,60,.6)", 0.8); ctx.restore()

# ======================= 客人 =======================
func _step_cust(sc, c: Dictionary, dt: float) -> void:
	var m = _mo(c); m.age += dt
	var got = 0
	for g in c.got: got += int(c.got[g])
	if got > int(m.got): m.re = "chomp" if GLUTTON.has(str(c.k)) else "got"; m.rt = 0.0
	m.got = got
	if str(c.st) != str(m.st):
		if str(c.st) == "out": m.re = "happy" if got > 0 else "angry"; m.rt = 0.0; m.act = ""
		m.st = str(c.st)
	if m.re != "":
		m.rt += dt
		if m.rt > {"got": 0.55, "chomp": 0.95, "happy": 1.3, "angry": 1.5, "trip": 1.1}.get(m.re, 1.0): m.re = ""
	var walking = c.get("walk", false)
	if walking: m.wt += dt
	if c.st in ["queue", "serve"]: m.qt += dt
	else: m.qt = 0.0
	# 冒失鬼：行行下跌倒
	if walking and str(c.k) == "n30_maoshi" and m.re == "" and _rng.randf() < dt * 0.35:
		m.re = "trip"; m.rt = 0.0; m["fz"] = c.pos
	_step_idle(c, m, dt, not walking and c.st in ["queue", "serve"] and m.re == "")
	if WET.has(str(c.k)) and walking and fmod(m.wt, 0.32) < dt: _add({"k": "print", "x": c.pos.x + _rng.randf_range(-4, 4), "y": c.pos.y + 1.0, "vx": 0.0, "vy": 0.0, "life": 2.6})
	if GLUTTON.has(str(c.k)) and not walking and c.st in ["queue", "serve"] and _wants_food(c) and fmod(m.age + m.seed, 0.45) < dt:
		var fwd = -1.0 if c.get("flip", false) else 1.0
		var hp = head_of(str(c.k), c.pos.x, c.pos.y, 1.1, fwd)
		drop(hp.x + fwd * 6.0, hp.y + 16.0, "rgba(220,240,255,.95)", fwd * 6.0)
	if str(c.k) == "pontianak" and fmod(m.age + m.seed, 3.4) < dt: ftxt(c.pos.x + _rng.randf_range(-12, 12), c.pos.y - 70.0, "嘻嘻", "#c8f5b8", 1.4)
	if m.re == "angry" and m.rt < dt * 1.5: puff(c.pos.x, c.pos.y - 62.0, "#9a9aa4", 4, 26.0, 0.8, 4.0)
func _wants_food(c: Dictionary) -> bool:
	for g in c.wants: if FOOD.has(str(g)): return true
	return false

# 待機輪替：一個動作做完，停一陣再揀下一個
func _step_idle(e: Dictionary, m: Dictionary, dt: float, idle: bool) -> void:
	if not idle: m.act = ""; return
	if m.act == "":
		m.gap -= dt
		if m.gap <= 0.0:
			var p = profile(str(e.k))
			var pool: Array = p.idle.duplicate()
			if pool.is_empty() or _rng.randf() < (0.3 if p.specific else 1.0):
				var a = GENERIC[_rng.randi() % GENERIC.size()]; pool = [[a, T_D[a]]]
			var pick = pool[_rng.randi() % pool.size()]
			if GLUTTON.has(str(e.k)) and e.get("wants") is Dictionary and _wants_food(e) and p.mesh and _rng.randf() < 0.6: pick = ["plaza_sniff", 2.6]
			m.act = str(pick[0]); m["dur"] = float(pick[1]); m.at = 0.0
	else:
		m.at += dt
		if m.at >= float(m.get("dur", 2.0)):
			m.act = ""; m.gap = _rng.randf_range(0.8, 2.8)

# 按當前動作（平日／廣場／變形）設 o、tf；回特效清單
func _apply_act(sc, ctx, e: Dictionary, m: Dictionary, o: Dictionary, tf: Dictionary, x: float, y: float, s: float, extra := {}) -> Array:
	var a = str(m.act); var k = str(e.k)
	if a == "": return []
	_mark(k, a)
	if a.begins_with("t_"): return t_idle(a, m.at, float(m.get("dur", 2.0)), tf, o, k, x, y, s, sc, ctx, extra)
	o["act"] = a; o["_daily"] = true; o["at"] = m.at; o["walk"] = false
	if a.begins_with("plaza_"):
		o["pl"] = {"d": float(m.get("dur", 2.0))}
		var fx = []
		if a == "plaza_doze": fx.append(["z", head_of(k, x, y, s, 1.0)])
		return fx
	return []

func _gait(k: String, e: Dictionary, m: Dictionary, o: Dictionary, tf: Dictionary, t: float, s: float) -> Array:
	var g = profile(k).gait; var fx = []
	var w = float(m.wt)
	_mark(k, "gait_" + g)
	match g:
		"hop", "hop1":
			var hp = fmod(w * (2.4 if g == "hop" else 3.0), 1.0)
			var up = sin(PI * clampf((hp - 0.22) / 0.68, 0, 1)) if hp > 0.22 and hp < 0.9 else 0.0
			var cr = sin(PI * clampf(hp / 0.22, 0, 1)) if hp < 0.22 else 0.0
			var land = sin(PI * clampf((hp - 0.9) / 0.1, 0, 1)) if hp >= 0.9 else 0.0
			if profile(k).mesh and k in ["zombie", "laojiang"]:
				o["act"] = "plaza_walk"; o["_daily"] = true; o["hp"] = hp; o["walk"] = false; o["at"] = w
			else:
				o["walk"] = false
				tf["dy"] = -up * (12.0 if g == "hop" else 9.0) * s
				tf["sy"] = 1.0 - 0.12 * cr - 0.1 * land + 0.07 * up; tf["sx"] = 1.0 + 0.08 * cr + 0.08 * land - 0.03 * up
				tf["gs"] = 1.0
				if g == "hop1": tf["r"] = sin(w * 6.0) * 0.06
			if hp >= 0.9 and hp - 0.9 < 0.05: fx.append(["land"])
		"paper":
			tf["r"] = sin(t * 6.3) * 0.13 + sin(t * 2.1) * 0.05
			tf["dy"] = -4.0 - absf(sin(t * 3.4)) * 5.0
			tf["sx"] = 1.0 - 0.55 * pow(absf(sin(t * 1.3)), 10.0)   # 紙片側身一下（翻）
			tf["gs"] = 0.8
		"float", "glide":
			o["walk"] = false
			tf["r"] = 0.07 if g == "float" else 0.03
			tf["dy"] = -6.0 - sin(t * 2.2) * (3.0 if g == "float" else 1.5)
			tf["gs"] = 0.8
		"head":
			o["walk"] = false
			tf["dy"] = -14.0 - sin(t * 2.6) * 4.0; tf["r"] = sin(t * 3.1) * 0.1; tf["gs"] = 0.7; tf["ghost"] = 0.18
		"dangle":
			o["walk"] = false
			tf["dy"] = -8.0 - sin(t * 1.8) * 2.0; tf["r"] = sin(t * 2.4) * 0.16; tf["gs"] = 0.7
		"drunk":
			tf["r"] = sin(t * 2.3) * 0.15; tf["dx"] = sin(t * 1.7) * 5.0
			if fmod(t, 2.6) < 0.05: fx.append(["hic"])
		"sneak":
			tf["sy"] = 0.9; tf["sx"] = 1.05; tf["r"] = 0.1
			if fmod(w, 1.8) > 1.45: o["flip"] = not o.get("flip", false)
		"glance":   # 車禍鬼：行兩步、回頭望（打量後面有冇車）
			if fmod(w, 1.9) > 1.5: o["flip"] = not o.get("flip", false); tf["r"] = -0.06
		"trip": pass
		"moon":   # Churel：雙腳反轉——面向同行嘅方向相反
			o["flip"] = not o.get("flip", false)
		"waddle":
			tf["r"] = sin(t * 6.0) * 0.1; tf["sx"] = 1.06; tf["sy"] = 0.97
		"shuffle":
			tf["r"] = 0.12 + sin(t * 9.0) * 0.04; tf["sy"] = 0.94
		"stomp":
			tf["sy"] = 1.0 - absf(sin(t * 4.5)) * 0.04
			if fmod(w, 0.7) < 0.05: fx.append(["dust"])
		"trot":
			tf["dy"] = -absf(sin(t * 8.0)) * 3.0
		"rattle":
			tf["dx"] = sin(t * 41.0) * 1.2; tf["r"] = sin(t * 23.0) * 0.05
		"tall":
			tf["r"] = sin(t * 1.6) * 0.07
		"brisk":
			o["t"] = float(o.get("t", 0.0)) * 1.5; tf["r"] = 0.05
		"hunch":
			tf["r"] = 0.14; tf["sy"] = 0.95
		"bounce":
			tf["dy"] = -absf(sin(t * 7.0)) * 4.0; tf["sy"] = 1.0 + sin(t * 14.0) * 0.03
		"scamper":
			tf["dy"] = -absf(sin(t * 12.0)) * 3.0; tf["r"] = 0.1
		"shiver":
			tf["dx"] = sin(t * 47.0) * 1.0; tf["sy"] = 0.97
		"smoke":
			if fmod(w, 0.5) < 0.05: fx.append(["smoke"])
		"zap":
			if fmod(w, 1.4) < 0.12:
				tf["dx"] = sin(t * 80.0) * 2.0; tf["sy"] = 1.04
				if fmod(w, 1.4) < 0.05: fx.append(["zapfx"])
		"flap":
			tf["dy"] = -4.0 - sin(t * 7.0) * 3.0; tf["gs"] = 0.8
		"sulk":
			tf["r"] = 0.08; tf["sy"] = 0.97
		"fade":   # Orang Bunian：隱身族，行行下隱咗又現
			o["walk"] = false; tf["dy"] = -5.0 - sin(t * 2.0) * 2.0; tf["gs"] = 0.8
			o["alpha"] = float(o.get("alpha", 0.95)) * (0.3 + 0.7 * absf(cos(t * 1.4)))
		"catwalk":   # 白骨精：扭腰行貓步
			tf["r"] = sin(t * 4.5) * 0.09; tf["dx"] = sin(t * 4.5) * 2.0; tf["sy"] = 1.0 + absf(sin(t * 9.0)) * 0.02
		"sleepy":   # 半瞓半醒：行得慢、頭一沉一沉
			o["t"] = float(o.get("t", 0.0)) * 0.6; tf["r"] = 0.06 + maxf(0.0, sin(t * 1.3)) * 0.1; tf["sy"] = 0.97
			if fmod(t, 3.0) < 0.05: fx.append(["zz"])
		"selfie":   # 自拍鬼：一路彈一路影，閃光
			tf["dy"] = -absf(sin(t * 7.0)) * 4.0
			if fmod(w, 1.6) < 0.05: fx.append(["flash"])
		"freeze":   # 凍死鬼：震、行過留雪花
			tf["dx"] = sin(t * 47.0) * 1.0; tf["sy"] = 0.97
			if fmod(w, 0.4) < 0.05: fx.append(["snow"])
		"nodwalk":   # 無頭鬼：雙手捧頭行，個頭隨步點
			tf["dy"] = -absf(sin(t * 6.0)) * 1.5; tf["r"] = sin(t * 3.0) * 0.03
	return fx

func _gait_fx(sc, k: String, e: Dictionary, fx: Array) -> void:
	for f in fx:
		match f[0]:
			"dust": puff(e.pos.x, e.pos.y, "#8a7458", 2, 18.0, 0.5, 3.5)
			"land": puff(e.pos.x, e.pos.y, "#8a7458", 3, 22.0, 0.45, 3.5)
			"smoke": puff(e.pos.x, e.pos.y - 52.0, "#5a5a62", 1, 12.0, 1.0, 4.0)
			"hic": ftxt(e.pos.x + 12.0, e.pos.y - 70.0, "嗝", "#ffb0a0", 0.9)
			"zapfx":
				for i in 5: _add({"k": "spark", "x": e.pos.x + _rng.randf_range(-14, 14), "y": e.pos.y - _rng.randf_range(30, 64), "vx": _rng.randf_range(-40, 40), "vy": _rng.randf_range(-40, 0), "life": 0.3, "c": "#bfe8ff"})
			"zz": ftxt(e.pos.x + 14.0, e.pos.y - 68.0, "z", "#c8d8ff", 1.0)
			"flash":
				for i in 4: _add({"k": "spark", "x": e.pos.x + 16.0 + _rng.randf_range(-5, 5), "y": e.pos.y - 70.0 + _rng.randf_range(-5, 5), "vx": _rng.randf_range(-30, 30), "vy": _rng.randf_range(-30, 10), "life": 0.35, "c": "#ffffff"})
				ftxt(e.pos.x + 18.0, e.pos.y - 80.0, "咔嚓", "#ffffff", 0.7)
			"snow":
				_add({"k": "drop", "x": e.pos.x + _rng.randf_range(-10, 10), "y": e.pos.y - 40.0, "vx": _rng.randf_range(-10, 10), "vy": 0.0, "life": 1.0, "r": 2.0, "c": "#eaf6ff", "gy": e.pos.y + 2.0})

# 客人：mv_scene._draw_cust 掛鈎（取代 Art.draw_char 嗰行）
func cust(sc, ctx: Ctx, c: Dictionary) -> bool:
	var t0 = Time.get_ticks_usec()
	var m = _mo(c); var k = str(c.k); var s = sc.CS
	var o = {"t": sc.t + c.ph, "walk": c.get("walk", false), "flip": c.get("flip", true), "alpha": 0.95}
	var tf = {}; var fx = []
	var x = c.pos.x; var y = c.pos.y
	var fwd = -1.0 if o.flip else 1.0
	var hp = head_of(k, x, y, s, fwd)
	if m.re == "trip" and m.has("fz"):   # 跌倒：企喺跌低嗰度，起身再追返
		var q = m.rt / 1.1
		var fz: Vector2 = m.fz
		var catch = clampf((q - 0.75) / 0.25, 0, 1)
		x = lerpf(fz.x, c.pos.x, _ez(catch)); y = lerpf(fz.y, c.pos.y, _ez(catch))
		var fall = _env(q, 0.0, 0.18, 0.5, 0.75)
		o["walk"] = catch > 0.0; tf["r"] = 1.15 * _ez(fall); tf["dy"] = 2.0 * fall; tf["sy"] = 1.0 - 0.08 * fall
		if m.rt < 0.2 and not m.has("tp"): m["tp"] = true; puff(x + fwd * 18.0, y, "#8a7458", 5, 30.0, 0.6, 4.0)
		if q > 0.3 and q < 0.75: fx.append(["txt", "哎呀", hp + Vector2(fwd * 22.0, 30.0), _env(q, 0.3, 0.35, 0.68, 0.75), "#ffd27a"])
		_mark(k, "trip")
	elif m.re != "" and m.re != "trip":
		_react(m, k, o, tf, fx, hp, fwd, s, c)
	elif c.get("walk", false):
		fx += _gait(k, c, m, o, tf, float(o.t), s)
		m.erase("tp")
	else:
		var ex = {"to_counter": -1.0 if c.pos.x > 195.0 else 1.0}
		if m.act == "t_whisper": ex["side"] = _neighbor_side(sc, c)
		fx += _apply_act(sc, ctx, c, m, o, tf, x, y, s, ex)
		# 等太耐（櫃台前）：跺腳、冒火；排隊太耐：嘆氣
		var pat = SIM.PATIENCE
		var w = float(c.get("wait", 0.0)) / pat if c.st == "serve" else 0.0
		if w > 0.55 or (c.st == "queue" and m.qt > 16.0):
			_mark(k, "impatient")
			var ia = IMPAT.get(k, "")
			var lvl = clampf((w - 0.55) / 0.45, 0, 1) if c.st == "serve" else 0.4
			if ia != "" and m.act == "" and _has_daily(ia):
				o["act"] = ia; o["_daily"] = true; o["at"] = fmod(m.qt, 3.0); o["walk"] = false
			elif m.act == "" or m.act.begins_with("t_"):
				tf["dy"] = float(tf.get("dy", 0.0)) - absf(sin(sc.t * 13.0)) * 1.6
				tf["r"] = float(tf.get("r", 0.0)) + sin(sc.t * 13.0) * 0.02
			fx.append(["anger", hp + Vector2(fwd * 14.0, -6.0), 0.5 + 0.5 * lvl, sc.t])
			if lvl > 0.6 and fmod(sc.t + m.seed, 0.7) < 0.03: puff(hp.x, hp.y - 8.0, "#d8d8e0", 1, 16.0, 0.9, 4.0)
		# 紙紮客近火：縮開、震
		if PAPER.has(k):
			var fd = _fire_dist(sc, Vector2(x, y))
			if fd[0] < 110.0:
				var away = 1.0 if x >= float(fd[1]) else -1.0
				tf["r"] = float(tf.get("r", 0.0)) + 0.12 * away * fwd
				tf["dx"] = float(tf.get("dx", 0.0)) + sin(sc.t * 40.0) * 1.0
				fx.append(["sweat", hp + Vector2(-fwd * 10.0, 4.0), 1.0, sc.t + m.seed]); _mark(k, "fire_fear")
		if GLUTTON.has(k):   # 餓鬼：肚脹（攞到幾多件就脹幾多）
			tf["sx"] = float(tf.get("sx", 1.0)) * (1.0 + 0.045 * mini(int(m.got), 4))
			if _wants_food(c): _mark(k, "drool")
	if c.get("walk", false) or m.re != "": _gait_fx(sc, k, c, fx)
	body(ctx, k, x, y, s, o, tf)
	draw_fx(sc, ctx, fx)
	perf_us += Time.get_ticks_usec() - t0
	return true

func _react(m: Dictionary, k: String, o: Dictionary, tf: Dictionary, fx: Array, hp: Vector2, fwd: float, s: float, e: Dictionary) -> void:
	var q = float(m.rt); _mark(k, "re_" + m.re)
	match m.re:
		"got":   # 攞到貨：彈一彈
			var b = sin(PI * clampf(q / 0.45, 0, 1))
			tf["sy"] = 1.0 + 0.1 * b; tf["sx"] = 1.0 - 0.06 * b; tf["dy"] = -6.0 * b * s; tf["gs"] = 1.0
		"chomp":   # 餓鬼：大啖吞，肚一脹
			var c3 = absf(sin(q * 20.0)) * (1.0 - q / 0.95)
			tf["sy"] = 1.0 - 0.1 * c3; tf["sx"] = 1.08 + 0.06 * c3; tf["r"] = 0.08 * c3
			if fmod(q, 0.3) < 0.05: drop(hp.x + fwd * 8.0, hp.y + 18.0, "#e8d6a8", fwd * 30.0)
			fx.append(["txt", "啊嗚", hp + Vector2(fwd * 18.0, -4.0), _env(q, 0.0, 0.1, 0.7, 0.95), "#ffe9a8"])
		"happy":
			var b2 = absf(sin(q * 9.0)) * (1.0 - q / 1.3)
			tf["dy"] = -8.0 * b2 * s; tf["sy"] = 1.0 + 0.05 * b2; tf["gs"] = 1.0
			if k in ["pocong", "zombie", "laojiang"]: o["walk"] = false
		"angry":
			tf["r"] = sin(q * 26.0) * 0.08 * (1.0 - q / 1.5); tf["sy"] = 0.96
			fx.append(["anger", hp + Vector2(fwd * 14.0, -6.0), 1.0 - q / 1.5, q])
			fx.append(["txt", "哼！", hp + Vector2(-fwd * 16.0, -10.0), _env(q, 0.0, 0.1, 1.1, 1.5), "#ff9a7a"])
			if fmod(q, 0.4) < 0.05: puff(e.pos.x, e.pos.y, "#8a7458", 2, 20.0, 0.5, 3.5)

func _neighbor_side(sc, c: Dictionary) -> float:
	var best = 1e9; var side = 0.0
	for o in sc.sim.custs:
		if o == c or o.st == "out": continue
		var d = o.pos.distance_to(c.pos)
		if d < best and d < 70.0: best = d; side = signf(o.pos.x - c.pos.x) if o.pos.x != c.pos.x else 1.0
	return side if side != 0.0 else (-1.0 if c.get("flip", true) else 1.0)
func _fire_dist(sc, p: Vector2) -> Array:
	var best = 1e9; var bx = p.x
	for sid in MD.stations(sc.sim.ci()):
		if not sc.sim.unlocked(sid): continue
		if not FIRE.has(str(MD.st_def(sid).get("art", ""))): continue
		var sp = sc.sim.st_pos(sid); var d = sp.distance_to(p)
		if d < best: best = d; bx = sp.x
	return [best, bx]
func _has_daily(a: String) -> bool:
	var D = J.G.get("DAILY")
	return D is Dictionary and D.has(a)

# ======================= 員工 =======================
func _step_worker(sc, w: Dictionary, dt: float) -> void:
	var m = _mo(w); m.age += dt
	var working = w.st == "work" and not w.get("walk", false) and not w.get("starve", false) and w.get("paid") is Dictionary
	if working: m.wt += dt
	var carrying = w.st in ["to_path", "go"] and int(w.carry) > 0
	if carrying and str(m.st) != "carry":
		m.st = "carry"
		if _rng.randf() < 0.05: m["trip_at"] = _rng.randf_range(0.6, 1.6); m["ct"] = 0.0   # 低機率跌貨
	elif not carrying and str(m.st) == "carry": m.st = ""; m.erase("trip_at"); m.re = ""
	if carrying:
		m["ct"] = float(m.get("ct", 0.0)) + dt
		if m.has("trip_at") and float(m.ct) >= float(m.trip_at) and m.re == "":
			m.re = "drop"; m.rt = 0.0; m["fz"] = w.pos; m.erase("trip_at")
			var gid = str(MD.st_def(w.sid).get("good", ""))
			for i in mini(int(w.carry), 3):
				var gx = w.pos.x + _rng.randf_range(-26, 26)
				_add({"k": "good", "gid": gid, "x": w.pos.x, "y": w.pos.y - 60.0, "vx": (gx - w.pos.x) / 0.35, "vy": -120.0, "gy": w.pos.y + _rng.randf_range(-4, 6),
					"life": 1.55, "fall": 0.35, "hold": 0.75 + i * 0.12, "tx": w.pos.x, "ty": w.pos.y - 60.0})
			puff(w.pos.x, w.pos.y, "#8a7458", 4, 26.0, 0.6, 4.0)
	if m.re != "":
		m.rt += dt
		if m.rt > 1.6: m.re = ""
	var idle = w.st == "work" and not w.get("walk", false) and not working
	_step_idle(w, m, dt, idle and not w.get("starve", false))

# mv_scene._draw_worker 掛鈎：成個員工（連頂住嘅貨）
func worker(sc, ctx: Ctx, w: Dictionary) -> bool:
	var t0 = Time.get_ticks_usec()
	var m = _mo(w); var k = str(w.k); var s = sc.CS * 0.9
	var o = {"t": sc.t + w.ph, "tamed": true, "shadow": true, "walk": w.get("walk", false), "flip": w.get("flip", false)}
	var tf = {}; var fx = []
	var x = w.pos.x; var y = w.pos.y
	var art = str(MD.st_def(w.sid).get("art", ""))
	var working = w.st == "work" and not w.get("walk", false) and not w.get("starve", false) and w.get("paid") is Dictionary
	var fwd0 = -1.0 if o.flip else 1.0
	var drawn = false
	var carry_y = -66.0; var carry_dx = 0.0; var carry_a = 1.0
	if m.re == "drop" and m.has("fz"):   # 跌貨：仆低 → 手忙腳亂執 → 追返
		var q = m.rt
		var fz: Vector2 = m.fz; var catch = clampf((q - 1.2) / 0.4, 0, 1)
		x = lerpf(fz.x, w.pos.x, _ez(catch)); y = lerpf(fz.y, w.pos.y, _ez(catch))
		var fall = _env(q, 0.0, 0.15, 0.35, 0.55); var scr = _env(q, 0.45, 0.6, 1.1, 1.25)
		tf["r"] = 0.9 * _ez(fall) + 0.25 * scr; tf["sy"] = 1.0 - 0.06 * fall - 0.12 * scr; tf["dx"] = sin(q * 38.0) * 3.0 * scr
		if scr > 0.0: o["flip"] = fmod(q, 0.24) < 0.12
		o["walk"] = catch > 0.0 or scr > 0.0
		carry_a = 0.0 if q < 1.15 else 1.0
		var hp = head_of(k, x, y, s, fwd0)
		fx.append(["txt", "跌咗！" if q < 0.6 else "執返執返…", hp + Vector2(0, -16.0), _env(q, 0.05, 0.15, 1.1, 1.25), "#ffd27a"])
		fx.append(["sweat", hp + Vector2(fwd0 * 10.0, 4.0), scr, sc.t])
		_mark(k, "w_drop")
	elif working and w.get("wait", false) == false:
		var acts: Array = ST_ACT.get(art, ["knead", "sight"])
		var WK = J.G.get("WORK")
		if WK != null:
			if not m.has("wv"): m["wv"] = {}
			var cyc = int(m.wt / 6.0) % 2
			var a = str(w.get("force_act", acts[cyc]))
			if not m.wv.has(a): m.wv[a] = J.mc(WK, "defaults", [a, k, 1.0 + float(m.seed)])
			var v = m.wv[a]
			var du = J.num(J.cl(J.gp(J.gp(J.gp(WK, "ACT"), a), "dur"), null, [v]))
			var at = fmod(m.wt, maxf(0.5, du))
			_mark(k, "work_" + a)
			var paper_fire = PAPER.has(k) and FIRE.has(art)
			if paper_fire:   # 紙紮員工對住火：做嘢都要縮開少少
				ctx.save(); ctx.translate(x, y); ctx.rotate(-0.1 * fwd0); ctx.translate(-x, -y); _mark(k, "fire_fear")
				fx.append(["sweat", head_of(k, x, y, s, fwd0) + Vector2(-fwd0 * 10.0, 4.0), 1.0, sc.t + m.seed])
			J.mc(WK, "drawAct", [ctx, k, x, y, s, a, at, {"flip": o.flip, "tamed": true, "untied": true, "wv": v, "t": sc.t + w.ph}])
			if SNIP.has(art) and fmod(m.wt + float(m.seed), 0.55) < 0.02:   # 剪：紙碎飄落
				_add({"k": "drop", "x": x + fwd0 * 16.0, "y": y - 30.0, "vx": _rng.randf_range(-20, 20), "vy": -30.0, "life": 0.9, "r": 2.4, "c": "#efe6d2", "gy": y + 2.0})
			if paper_fire: ctx.restore()
			drawn = true
	elif w.get("wait", false) and w.st == "go":   # 櫃台滿：企喺度跺腳
		tf["dy"] = -absf(sin(sc.t * 12.0)) * 1.5; o["walk"] = false
		_mark(k, "w_wait")
	elif w.st == "work" and not w.get("walk", false):
		if w.get("starve", false):   # 斷料：坐低打瞌睡
			if profile(k).mesh:
				o["act"] = "plaza_doze"; o["_daily"] = true; o["at"] = 2.0 + fmod(m.age, 3.0); o["pl"] = {"d": 99.0}
			else: tf["sy"] = 0.94; tf["r"] = 0.08
			fx.append(["z", head_of(k, x, y, s, fwd0)])
			_mark(k, "w_starve")
		else:
			fx += _apply_act(sc, ctx, w, m, o, tf, x, y, s, {"to_counter": -1.0 if x > 195.0 else 1.0})
	elif w.get("walk", false):
		var carrying = int(w.carry) > 0
		if carrying:   # 頂住貨：腳步重少少、貨跟步彈
			tf["sy"] = 0.96 + absf(sin(sc.t * 9.0)) * 0.02; tf["r"] = 0.05
			carry_y = -64.0 + absf(sin(sc.t * 9.0 + w.ph)) * -3.0
			carry_dx = sin(sc.t * 4.5 + w.ph) * 2.0
			_mark(k, "w_carry")
		var g = profile(k).gait
		if g in ["hop", "hop1", "float", "glide", "head", "paper", "dangle", "fade", "catwalk", "nodwalk"]:
			m["wt2"] = float(m.get("wt2", 0.0)) + 1.0 / 60.0
			var mm = {"wt": sc.t * 1.0 + float(m.seed)}
			var gfx = _gait(k, w, mm, o, tf, float(o.t), s); fx += gfx; _gait_fx(sc, k, w, gfx)
			if carrying: carry_y += float(tf.get("dy", 0.0))
	if not drawn: body(ctx, k, x, y, s, o, tf)
	for f in fx:
		if f[0] == "z": _zz(sc, ctx, f[1], sc.t + float(m.seed))
	draw_fx(sc, ctx, fx.filter(func(f): return f[0] != "z"))
	# 頂住嘅貨（原本 mv_scene 畫法＋彈）
	if int(w.carry) > 0 and carry_a > 0.0:
		var gid = str(MD.st_def(w.sid).get("good", ""))
		var by = y + carry_y + sin(sc.t * 10.0 + w.ph) * 1.5
		for i in mini(int(w.carry), 3): sc._icon(ctx, gid, x + carry_dx + i * 3.0, by - i * 7.0, 22.0)
		if w.carry > 1: sc._txt(ctx, "×%d" % int(w.carry), x + 22, by - 8, 14, Color.WHITE, "center", 900, 4)
		if w.get("wait", false): sc._txt(ctx, MD.S("full", "櫃台滿", "櫃台滿"), x, by - 34, 14, Color("#ffb0a0"), "center", 900, 4)
	perf_us += Time.get_ticks_usec() - t0
	return true

func _zz(sc, ctx: Ctx, hp: Vector2, t: float) -> void:
	for i in 3:
		var q = fmod(t * 0.55 + i / 3.0, 1.0)
		ctx.save(); ctx.globalAlpha *= sin(PI * q)
		sc._txt(ctx, "Z" if i == 2 else "z", hp.x + 10.0 + q * 14.0 + sin(q * 6.0) * 3.0, hp.y - 4.0 - q * 26.0, 14 + i * 2, Color("#c8d8ff"), "center", 900, 3)
		ctx.restore()

# ======================= 領班（站喺台側） =======================
const IDL = preload("res://game/outpost/mv_idle.gd")
func _fore_items(sc, ctx: Ctx, items: Array, vy0: float, vy1: float) -> void:
	var sim = sc.sim
	var live = {}
	for sid in MD.stations(sim.ci()):
		if not sim.unlocked(sid) or MD.is_carry(sid): continue
		var gid = IDL.fore(sim, sid)
		if gid == null: continue
		var gh = sim.ghost(gid)
		if gh == null: continue
		var sp = sim.st_pos(sid)
		var side = 1.0 if sp.x < 195.0 else -1.0
		var p = Vector2(clampf(sp.x + side * (sc._st_w() * 0.5 + 6.0), 22.0, FW - 22.0), sp.y + 4.0)
		fore_pos[sid] = p; live[sid] = true
		if not fore_mo.has(sid): fore_mo[sid] = {"k": J.str(J.gp(gh, "k")), "st": "doze", "t": 0.0, "seed": randf() * 10.0, "flip": side > 0}
		var fm = fore_mo[sid]; fm.k = J.str(J.gp(gh, "k")); fm.flip = side > 0
		if p.y < vy0 - 20.0 or p.y - 120.0 > vy1: continue
		var s2 = sid
		items.append([p.y, func(): _draw_fore(sc, ctx, s2)])
	for sid in fore_mo.keys(): if not live.has(sid): fore_mo.erase(sid)
func _fore_busy(sim, sid: String) -> bool:
	if float(sim.mk.get(sid, -1.0)) >= 0.0: return true
	for w in sim.workers: if w.sid == sid and w.get("paid") is Dictionary and not w.get("walk", false): return true
	return false
func _step_fore(sc, sid: String, dt: float) -> void:
	var fm = fore_mo[sid]; fm.t += dt
	var busy = _fore_busy(sc.sim, sid)
	match str(fm.st):
		"wake":
			if fm.t > 1.1: fm.st = "work"; fm.t = 0.0
		"work":
			if not busy and fm.t > 6.0: fm.st = "doze"; fm.t = 0.0
		"doze":
			if busy: fm.st = "work"; fm.t = 0.0
func _draw_fore(sc, ctx: Ctx, sid: String) -> void:
	var fm = fore_mo.get(sid); var p = fore_pos.get(sid)
	if fm == null or p == null: return
	var k = str(fm.k); var s = sc.CS * 0.82
	var o = {"t": sc.t + fm.seed, "tamed": true, "flip": not fm.flip}
	var tf = {}
	var hp = head_of(k, p.x, p.y, s, 1.0)
	match str(fm.st):
		"doze":
			_mark(k, "fore_doze")
			if profile(k).mesh: o["act"] = "plaza_doze"; o["_daily"] = true; o["at"] = 2.0 + fmod(fm.t, 3.0); o["pl"] = {"d": 99.0}
			else: tf["sy"] = 0.95 + sin(sc.t * 1.2) * 0.015; tf["r"] = 0.1
			body(ctx, k, p.x, p.y, s, o, tf)
			_zz(sc, ctx, hp, sc.t + fm.seed)
		"wake":
			_mark(k, "fore_wake")
			var j = sin(PI * clampf(fm.t / 0.35, 0, 1)) if fm.t < 0.35 else 0.0
			if profile(k).mesh: o["act"] = "plaza_startle"; o["_daily"] = true; o["at"] = fm.t; o["pl"] = {"d": 1.1}
			else: tf["dy"] = -12.0 * j; tf["sy"] = 1.0 + 0.1 * j; tf["gs"] = 1.0; tf["dx"] = sin(fm.t * 50.0) * 2.0 * (1.0 - fm.t)
			body(ctx, k, p.x, p.y, s, o, tf)
			sc._txt(ctx, "嚇醒！", hp.x, hp.y - 14.0 - j * 8.0, 15, Color("#ffd27a"), "center", 900, 3)
		_:
			_mark(k, "fore_work")
			var WK = J.G.get("WORK")
			if WK != null:
				if not fm.has("v"): fm["v"] = J.mc(WK, "defaults", ["inspect", k, 2.0 + fm.seed])
				var du = J.num(J.cl(J.gp(J.gp(J.gp(WK, "ACT"), "inspect"), "dur"), null, [fm.v]))
				J.mc(WK, "drawAct", [ctx, k, p.x, p.y, s, "inspect", fmod(fm.t, maxf(0.5, du)), {"flip": o.flip, "tamed": true, "wv": fm.v, "t": o.t}])
			else: body(ctx, k, p.x, p.y, s, o, tf)
	sc._txt(ctx, MD.S("fore_t", "領班", "領班"), p.x, p.y + 12.0, 14, Color("#f3d68a"), "center", 900, 4)

# 撳：瞓緊嘅領班嚇醒（食咗呢下撳）；偷望緊嘅 Toyol 即刻扮乖（唔食）
func tap(sc, p: Vector2) -> bool:
	for sid in fore_mo:
		var fp = fore_pos.get(sid)
		if fp == null: continue
		if Rect2(fp.x - 22.0, fp.y - 58.0, 44.0, 64.0).has_point(p) and str(fore_mo[sid].st) == "doze":
			fore_mo[sid].st = "wake"; fore_mo[sid].t = 0.0
			if sc.has_method("_snd"): sc._snd("click")
			return true
	for e in sc.sim.custs + sc.sim.workers:
		if str(e.k) != "toyol": continue
		var m = _mo(e)
		if m.act == "t_peek" and m.at < 1.5 and Rect2(e.pos.x - 24.0, e.pos.y - 56.0, 48.0, 60.0).has_point(p): m.at = 1.55
	return false

# ======================= 村外惡鬼 =======================
func _step_foe(sc, f: Dictionary, dt: float) -> void:
	var m = _mo(f); m.age += dt
	if m.age <= dt * 1.01:
		if f.get("boss", false):
			_add({"k": "crack", "x": f.pos.x, "y": f.pos.y + 2.0, "vx": 0.0, "vy": 0.0, "life": 2.2})
			_add({"k": "ring", "x": f.pos.x, "y": f.pos.y - 10.0, "vx": 0.0, "vy": 0.0, "life": 1.8})
			for i in 8: _add({"k": "puff", "x": f.pos.x + _rng.randf_range(-20, 20), "y": f.pos.y, "vx": _rng.randf_range(-70, 70), "vy": _rng.randf_range(-160, -60), "life": 0.7, "r": 3.0, "c": "#3a2a20"})
		else: puff(f.pos.x, f.pos.y - 10.0, "#b8c0cc", 3, 14.0, 1.0, 6.0)
	if f.st == "die" and str(m.st) != "die":
		m.st = "die"
		var big = f.get("boss", false)
		for i in (14 if big else 9): _add({"k": "puff", "x": f.pos.x + _rng.randf_range(-14, 14), "y": f.pos.y - _rng.randf_range(10, 50), "vx": _rng.randf_range(-24, 24), "vy": _rng.randf_range(-60, -24),
			"life": _rng.randf_range(0.9, 1.5), "r": _rng.randf_range(5, 9) * (1.5 if big else 1.0), "c": "#4a4650" if i % 2 else "#8c8896"})
	if f.has("hurt") and not m.has("hit0"): m["hit0"] = true; m["ht"] = 0.0
	if not f.has("hurt"): m.erase("hit0")
	m["ht"] = float(m.get("ht", 9.0)) + dt
	if f.st == "bang": m.qt += dt
	else: m.qt = 0.0

func _foe_tf(sc, f: Dictionary, m: Dictionary, o: Dictionary, tf: Dictionary, boss: bool) -> Array:
	var k = str(f.k); var t = sc.t + float(f.ph); var fx = []
	var fwd = -1.0 if o.get("flip", false) else 1.0
	# 出場：由地升起＋淡入（頭目：地裂、霧散，慢啲、撐大少少先收）
	var in_t = 1.4 if boss else 0.7
	if m.age < in_t:
		var q = m.age / in_t
		var rise = _ez(clampf((q - (0.25 if boss else 0.0)) / (0.75 if boss else 1.0), 0, 1))
		tf["sy"] = (0.15 + 0.85 * rise) * (1.0 + (0.12 * sin(PI * clampf((q - 0.6) / 0.4, 0, 1)) if boss else 0.0))
		tf["sx"] = 1.0 + 0.15 * (1.0 - rise)
		o["alpha"] = float(o.get("alpha", 0.92)) * minf(1.0, rise * 1.4)
		if boss: tf["dx"] = sin(m.age * 60.0) * 2.0 * (1.0 - q)
		_mark(k, "boss_intro" if boss else "foe_spawn")
	if f.st == "die":
		var d = clampf(f.t / 0.7, 0, 1)
		tf["sy"] = 1.0 - 0.75 * _ez(d); tf["sx"] = 1.0 + 0.45 * d; tf["dy"] = -14.0 * d; o["alpha"] = (0.95 if boss else 0.92) * (1.0 - d)
		tf["r"] = sin(f.t * 30.0) * 0.1 * (1.0 - d)
		_mark(k, "foe_die"); return fx
	if f.has("hurt"):   # 被打：抖、壓扁、閃
		var hk = clampf(float(f.hurt) / 0.25, 0, 1)
		tf["dx"] = float(tf.get("dx", 0.0)) + sin(t * 70.0) * 3.5 * hk
		tf["sx"] = float(tf.get("sx", 1.0)) * (1.0 + 0.1 * hk); tf["sy"] = float(tf.get("sy", 1.0)) * (1.0 - 0.08 * hk)
		if fmod(t, 0.1) < 0.05: o["alpha"] = float(o.get("alpha", 0.92)) * 0.6
		_mark(k, "foe_hurt")
	if f.st == "bang":   # 貼柵欄：踮腳、身向前、窺望（一陣縮低一陣探頭）＋眼光
		var cyc = fmod(m.qt + float(m.seed), 2.6)
		var peek = _env(cyc, 1.4, 1.6, 2.2, 2.5)
		tf["sy"] = float(tf.get("sy", 1.0)) * (1.05 + 0.04 * peek); tf["r"] = float(tf.get("r", 0.0)) + 0.1 + 0.08 * peek
		tf["dy"] = float(tf.get("dy", 0.0)) - 4.0 * peek
		if peek > 0.2: fx.append(["eyes", head_of(k, f.pos.x, f.pos.y, sc.CS * 0.9, fwd) + Vector2(fwd * 4.0, 4.0), peek])
		_mark(k, "foe_peek")
	elif f.get("walk", false) or f.st in ["roam", "charge", "flee"]:
		var g = "stomp" if boss else FOE_ROAM.get(k, "twist")
		_mark(k, "foe_" + g)
		match g:
			"twist":   # 扭曲：唔規則咁擰、拉、縮
				tf["r"] = float(tf.get("r", 0.0)) + sin(t * 3.1) * 0.16 + sin(t * 7.7) * 0.05
				tf["sx"] = float(tf.get("sx", 1.0)) * (1.0 + sin(t * 4.6) * 0.09); tf["sy"] = float(tf.get("sy", 1.0)) * (1.0 - sin(t * 4.6) * 0.07)
			"flutter":
				tf["r"] = float(tf.get("r", 0.0)) + sin(t * 6.0) * 0.18; tf["sx"] = float(tf.get("sx", 1.0)) * (1.0 - 0.5 * pow(absf(sin(t * 1.5)), 8.0)); tf["dy"] = -4.0 - absf(sin(t * 3.0)) * 4.0
			"crawl":   # 爬行：伏低、向前、一下一下扒
				tf["r"] = float(tf.get("r", 0.0)) + 0.42 + sin(t * 10.0) * 0.05; tf["sy"] = float(tf.get("sy", 1.0)) * 0.8; tf["sx"] = float(tf.get("sx", 1.0)) * 1.12; tf["dy"] = 3.0
				if WET.has(k) and fmod(t, 0.35) < 0.02: _add({"k": "print", "x": f.pos.x, "y": f.pos.y + 1.0, "vx": 0.0, "vy": 0.0, "life": 2.2})
			"rattle":
				tf["dx"] = float(tf.get("dx", 0.0)) + sin(t * 41.0) * 1.6; tf["r"] = float(tf.get("r", 0.0)) + sin(t * 19.0) * 0.08
			"prowl":
				tf["r"] = float(tf.get("r", 0.0)) + 0.2; tf["sy"] = float(tf.get("sy", 1.0)) * 0.9
			"flap":
				tf["dy"] = -6.0 - sin(t * 7.0) * 4.0
			"stalk":
				tf["r"] = float(tf.get("r", 0.0)) + 0.06; o["t"] = float(o.get("t", 0.0)) * 0.6
			"scamper":
				tf["dy"] = -absf(sin(t * 12.0)) * 3.0
			"stomp":
				tf["sy"] = float(tf.get("sy", 1.0)) * (1.0 - absf(sin(t * 3.5)) * 0.05)
				if fmod(t, 0.8) < 0.03: puff(f.pos.x, f.pos.y, "#5a4636", 3, 26.0, 0.6, 5.0)
	return fx

func foe(sc, ctx: Ctx, f: Dictionary) -> bool:
	var t0 = Time.get_ticks_usec()
	var m = _mo(f)
	var a = 0.92
	var y = f.pos.y + float(f.get("bob", 0.0)) + sin(sc.t * 2.2 + f.ph) * 2.0
	var o = {"t": sc.t + f.ph, "walk": f.get("walk", false) or f.st == "bang", "flip": f.get("flip", false), "alpha": a, "noShadow": true}
	if f.has("hurt"): o["hurt"] = true
	if f.st == "bang": o["atk"] = true
	var tf = {}
	var fx = _foe_tf(sc, f, m, o, tf, false)
	if f.st != "die": Art.el(ctx, f.pos.x, y - 26, 30, 30, "rgba(140,190,255,.12)"); Art.el(ctx, f.pos.x, y - 26, 18, 18, "rgba(160,200,255,.14)")
	body(ctx, str(f.k), f.pos.x, y, sc.CS * 0.9, o, tf)
	_foe_fx(ctx, fx)
	if f.hp < f.mx and f.st != "die":
		var w = 36.0
		Art.rr(ctx, f.pos.x - w / 2 - 1, y - 62, w + 2, 7, 3, "rgba(0,0,0,.7)")
		Art.rr(ctx, f.pos.x - w / 2, y - 61, w * clampf(f.hp / f.mx, 0, 1), 5, 2, "#e05a4a")
	perf_us += Time.get_ticks_usec() - t0
	return true
func _foe_fx(ctx: Ctx, fx: Array) -> void:
	for e in fx:
		if e[0] == "eyes":
			var p: Vector2 = e[1]
			ctx.save(); ctx.globalAlpha *= clampf(float(e[2]), 0, 1)
			Art.el(ctx, p.x - 4.0, p.y, 2.4, 1.6, "#ff4a2a"); Art.el(ctx, p.x + 4.0, p.y, 2.4, 1.6, "#ff4a2a")
			Art.el(ctx, p.x - 4.0, p.y, 4.5, 3.0, "rgba(255,80,40,.25)"); Art.el(ctx, p.x + 4.0, p.y, 4.5, 3.0, "rgba(255,80,40,.25)")
			ctx.restore()

# 頭目身體（mv_war.draw_boss 掛鈎）：回 true = 畫咗
func boss(sc, ctx: Ctx, f: Dictionary, x: float, y: float, s: float, o: Dictionary) -> bool:
	var m = _mo(f); var tf = {}
	var fx = _foe_tf(sc, f, m, o, tf, true)
	body(ctx, str(f.k), x, y, s, o, tf)
	_foe_fx(ctx, fx)
	return true

# ======================= 守衛、義勇軍 =======================
func _step_guard(sc, g: Dictionary, dt: float) -> void:
	var m = _mo(g); m.age += dt
	var home = g.tgt == null and not g.get("walk", false) and float(g.atk) <= 0.0
	if not m.has("shift"): m["shift"] = _rng.randf_range(8.0, 20.0)
	if home:
		m.shift -= dt
		if m.shift <= 0.0 and m.act == "": m.act = "shift"; m.at = 0.0; m["dur"] = 2.4; m.shift = _rng.randf_range(18.0, 30.0)
	if m.act != "":
		m.at += dt
		if m.at >= float(m.get("dur", 2.4)) or not home: m.act = ""
# 守衛身體（mv_scene._draw_guard 掛鈎：取代 Art.draw_char 嗰行）
func guard(sc, ctx: Ctx, g: Dictionary, o: Dictionary) -> bool:
	var m = _mo(g); var k = str(g.k); var tf = {}; var fx = []
	var s = sc.CS * 0.95; var fwd = -1.0 if o.get("flip", false) else 1.0
	if m.act == "shift":   # 換班伸懶腰
		_mark(k, "guard_shift")
		var e = _env(m.at, 0.0, 0.5, 1.8, 2.4)
		if profile(k).mesh: o["act"] = "plaza_stretch"; o["_daily"] = true; o["at"] = m.at; o["pl"] = {"d": 2.4}
		else: tf["sy"] = 1.0 + 0.08 * e; tf["sx"] = 1.0 - 0.04 * e; tf["r"] = -0.06 * e
		fx.append(["txt", "呵～換更", head_of(k, g.pos.x, g.pos.y, s, fwd) + Vector2(0, -12.0), e, "#e8dcc4"])
	elif float(g.atk) > 0.0:   # 打：撲前
		var q = clampf(float(g.atk) / 0.25, 0, 1)
		tf["dx"] = fwd * 6.0 * sin(PI * q); tf["r"] = 0.12 * sin(PI * q)
		_mark(k, "guard_hit")
	elif g.get("walk", false):
		var gfx = _gait(k, g, {"wt": sc.t + float(m.seed)}, o, tf, float(o.t), s); fx += gfx; _gait_fx(sc, k, g, gfx)
	else:
		tf["sy"] = 1.0 + sin(sc.t * 1.6 + float(m.seed)) * 0.015   # 企崗呼吸
	body(ctx, k, g.pos.x, g.pos.y, s, o, tf)
	draw_fx(sc, ctx, fx)
	return true

func _step_vol(sc, r: Dictionary, dt: float) -> void:
	var m = _mo(r); m.age += dt
	if m.age <= dt * 1.01:
		for i in 6: _add({"k": "spark", "x": r.pos.x + _rng.randf_range(-16, 16), "y": r.pos.y - _rng.randf_range(10, 60), "vx": 0.0, "vy": -20.0, "life": 0.9, "c": "#fff2b0"})
	if r.st == "post" and not r.get("walk", false):
		if m.act == "":
			m.gap -= dt
			if m.gap <= 0.0: m.act = ["pose", "salute", "pose"][_rng.randi() % 3]; m.at = 0.0; m["dur"] = 2.6 if m.act == "salute" else 2.2
		else:
			m.at += dt
			if m.at >= float(m.dur): m.act = ""; m.gap = _rng.randf_range(2.0, 5.0)
	else: m.act = ""
# 義勇軍身體（mv_war._draw_vol 掛鈎）
func vol(sc, ctx: Ctx, r: Dictionary, x: float, y: float, s: float, o: Dictionary) -> bool:
	var m = _mo(r); var k = str(r.d.k); var tf = {}; var fx = []
	var fwd = -1.0 if o.get("flip", false) else 1.0
	if m.age < 1.3:   # 入伍：轉一圈著好裝備，挺胸
		var q = m.age / 1.3
		var c = cos(_ez(clampf(q / 0.7, 0, 1)) * TAU * 1.0)
		tf["sx"] = signf(c if c != 0.0 else 1.0) * maxf(0.08, absf(c)); tf["sy"] = 1.0 + 0.08 * sin(PI * q); tf["dy"] = -8.0 * sin(PI * clampf(q / 0.7, 0, 1)); tf["gs"] = 1.0
		_mark(k, "vol_join")
	elif r.has("atk_t"):
		var q2 = clampf(float(r.atk_t) / 0.25, 0, 1)
		tf["dx"] = fwd * 7.0 * sin(PI * q2); tf["r"] = 0.14 * sin(PI * q2); tf["sx"] = 1.0 + 0.06 * sin(PI * q2)
		_mark(k, "vol_hit")
	elif r.get("walk", false):
		var gfx = _gait(k, r, {"wt": sc.t + float(m.seed)}, o, tf, float(o.t), s); fx += gfx; _gait_fx(sc, k, r, gfx)
		tf["r"] = float(tf.get("r", 0.0)) + 0.04   # 行軍：身向前
	elif m.act == "salute":
		_mark(k, "vol_salute")
		var WK = J.G.get("WORK")
		if WK != null and profile(k).mesh:
			if not m.has("v"): m["v"] = J.mc(WK, "defaults", ["salute", k, 3.0 + float(m.seed)])
			J.mc(WK, "drawAct", [ctx, k, x, y, s, "salute", m.at, {"flip": o.get("flip", false), "tamed": true, "wv": m.v, "t": o.t}])
			return true
		var e = _env(m.at, 0.0, 0.3, 2.2, 2.6)
		tf["sy"] = 1.0 + 0.06 * e; tf["r"] = -0.07 * e
		fx.append(["spark", head_of(k, x, y, s, fwd) + Vector2(0, 20.0), e, m.at])
	else:   # 企崗：挺胸、深呼吸
		var e2 = _env(m.at, 0.0, 0.4, 1.8, 2.2) if m.act == "pose" else 0.0
		tf["sy"] = 1.03 + 0.03 * e2 + sin(sc.t * 1.8 + float(m.seed)) * 0.012; tf["r"] = -0.06 * e2
		if e2 > 0.2: fx.append(["spark", head_of(k, x, y, s, fwd) + Vector2(fwd * 12.0, 26.0), e2, m.at])
		_mark(k, "vol_pose")
	body(ctx, k, x, y, s, o, tf)
	draw_fx(sc, ctx, fx)
	return true

# 客人走嗰陣頭頂出唔出 ♪（嬲走就唔出）
func happy(c: Dictionary) -> bool:
	return str(_mo(c).get("re", "")) != "angry" and int(_mo(c).get("got", 0)) > 0

# 玩法線（mv_plus.act_draw）有事件動作緊：讓佢畫（同 act_draw 嘅條件一致）
static func play_busy(e: Dictionary) -> bool:
	var tp = str(e.get("tp", ""))
	# 玩法線嘅「定時做貨姿勢」（knead／hammer／chop／reap）同動作線按台做貨重複：保留動作線（有原圖工具）
	if e.has("sid") and e.get("act") is Dictionary and str(e.act.get("k", "")) in ["knead", "hammer", "chop", "reap"] and not J.t(e.get("doze")): return false
	return e.get("act") is Dictionary or tp == "fake" or J.t(e.get("doze")) or J.t(e.get("dash")) or (tp == "haggle" and J.t(e.get("prompt")))
