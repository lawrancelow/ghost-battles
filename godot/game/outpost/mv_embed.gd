# [unify] 合一地圖：「村子」分頁＝一張直向連續地圖（UNIFIED_CONTRACT.md）
#   村外惡鬼區＋柵欄＋大排檔區（mv_scene 嵌入模式，世界 0..EH）→ 出村門 → 原版村子（ui/nv_village.gd，唔變）→ 村尾拓展地。
#   座標：大排檔區世界 y = 村子 y + EH；鏡頭只有一個（村子 JS Village.camY，可以拖到 -EH）。
#   呢個節點（冇 class_name，熱更新規矩）掛喺村子畫面入面，做：
#     1. 開 mv_scene（embed = true）蓋喺村子世界上面（只畫 y < 0 嗰段＋HUD）；
#     2. 包 Village.setCam（准拖到最頂）同 Village.tap（y < 0／HUD → 轉俾大排檔區）；
#     3. 每格同步鏡頭（mv_scene.cam = 村子 camY + EH + top_pad）、HUD 淡入淡出、升級條要求嘅鏡頭移動；
#     4. 挑夫鬼：每隔一陣由村子經「出村」門挑貨上大排檔區（純畫面；冇料唔行）；
#     5. 留位（layout.spare）：「待開檔」空地。
extends Node

const MV_SCENE := "res://game/outpost/mv_scene.gd"
const CB = preload("res://game/outpost/chain_bld.gd")
const MD = preload("res://game/outpost/mv_data.gd")
const M = preload("res://game/outpost/mat.gd")
const ZD = preload("res://game/zone/zone_data.gd")   # [zone] 分區地圖
const HUD_CAM := -40.0        # 村子 camY 細過呢個（睇到大排檔區）先出 HUD
const GATE := Vector2(195, 118)

var main = null
var village: Control = null
var sc: Control = null         # mv_scene（嵌入）
var porters: Array = []        # {s, k, mid, back}
var _pt := 3.0
var _rng := RandomNumberGenerator.new()
var _cam_anim = null           # 村子鏡頭目標（村子 y）

static func attach(m, vil: Control) -> Node:
	var e = load("res://game/outpost/mv_embed.gd").new(); e.name = "MvEmbed"
	e.main = m; e.village = vil
	vil.add_child(e)
	return e

func _ready() -> void:
	_rng.seed = 4242
	sc = Control.new(); sc.set_script(load(MV_SCENE)); sc.name = "MvScene"
	sc.embed = true; sc.hide_host = false
	sc.embed_draw = _draw_extra
	sc.embed_ground = _draw_join   # [village2] 大排檔區底 → 原村子地面：漸變接駁（冇接縫、冇黑帶）
	sc.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	village.add_child(sc)   # 加喺 world 後面 → 畫喺村子上面
	sc.setup(main)
	_update_top()

func eh() -> float:
	if sc == null or sc.sim == null or sc.sim.L.is_empty(): return 1110.0
	return float(sc.sim.L.get("h", 1110.0))

func vcam() -> float:
	var V = J.G.get("Village")
	return J.num(V.get("camY", 180.0)) if V is Dictionary else 180.0
func set_vcam(y: float) -> void:
	var V = J.G.get("Village")
	if V is Dictionary: J.mc(V, "setCam", [y])

func _update_top() -> void:
	var qb = main.get("quest_bar") if main != null else null
	var top = 0.0
	if qb is Control and qb.visible: top = maxf(0.0, qb.get_global_rect().end.y - village.get_global_rect().position.y + 4.0)
	if absf(top - float(sc.embed_top)) > 0.5: sc.embed_top = top; sc._layout()

# ---------------- 包村子 JS（鏡頭範圍、點擊） ----------------
func _install() -> void:
	var V = J.G.get("Village")
	if not (V is Dictionary): return
	if V.get("__un_tap_w") != null and is_same(V.get("__un_tap_w"), V.get("tap")) and is_same(V.get("__cb_tap_w"), V.get("tap")): return
	CB.install()   # 先俾後院線包（佢包完 __cb_tap_w = tap），再喺上面包一層
	var o_tap = V.get("tap"); var o_cam = V.get("setCam")
	var me_ref = weakref(self)
	var tap = func(t, a):
		var x = J.num(J.arg(a, 0)); var y = J.num(J.arg(a, 1))
		var me = me_ref.get_ref()
		if me != null and me.on_tap(x, y): return null
		return J.cl(o_tap, t, a)
	var cam = func(t, a):
		var v = t if t != null else V
		var r = J.cl(o_cam, v, a)
		var me = me_ref.get_ref()
		var top = -me.eh() - me.top_extra() if me != null and me.active() else 0.0
		var vh = J.num(v.get("h", 600)) / maxf(0.01, J.num(v.get("scale", 1)))
		var wh = maxf(1130.0, CB.world_h())
		v["camY"] = clampf(J.num(J.arg(a, 0)), top, maxf(0.0, wh - vh))
		return r
	V["tap"] = tap; V["__un_tap_w"] = tap; V["__cb_tap_w"] = tap
	V["setCam"] = cam

# 鏡頭最頂可以再上啲：HUD 蓋住嘅高度，等柵欄外孤魂露出嚟
func top_extra() -> float: return float(sc.EHUD_H) + 40.0 if sc != null else 0.0
func active() -> bool: return sc != null and is_instance_valid(sc) and sc.visible

# 村子世界座標 (x, y) 嘅一下撳：屬於大排檔區／HUD 就轉俾 mv_scene，回 true
func on_tap(x: float, y: float) -> bool:
	if not active() or sc.sim == null or sc.sim.st() == null: return false
	if ZD.on(): return false   # [zone] 分區地圖：nv_village.zone_tap 已經分派咗
	var sp = Vector2(x, y - vcam())   # mv_scene 舞台座標（同村子一樣縮放）
	var hud = sc.hud_on and sp.y < sc.top_pad + sc.EHUD_H
	var wb = false
	var w = sc.sim.war
	if sc.hud_on and w != null and w.get("_btn") is Dictionary:
		for k in w._btn:
			var r = w._btn[k]
			if r is Rect2 and r.grow(4).has_point(sp): wb = true
	if sc.hud_on:
		for k in sc._btns:
			if sc._btns[k].has_point(sp): wb = true
	if y < 0.0 or hud or wb or sc.card != null:
		sc.tap(sp); return true
	if sc.sheet.visible: sc.close_sheet()
	return false

# ---------------- 每格 ----------------
func _process(dt: float) -> void:
	if not active() or not village.is_visible_in_tree(): return
	_install()
	_update_top()
	if ZD.on(): _zone_frame(dt); return   # [zone]
	if sc.zone: sc.zone = false; sc._layout(); sc.sim.relayout(); sc.sim._sync_key = ""; sc.sim.sync()   # [zone] 換返舊豎條
	var cy = vcam()
	sc.hud_on = cy < HUD_CAM or sc.sheet.visible or sc.anim != null
	var qb = main.get("quest_bar") if main != null else null   # 精簡 HUD 已經包主線：任務條收埋
	if qb is Control and qb.visible == sc.hud_on: qb.visible = not sc.hud_on
	# 升級條／目標要求鏡頭移動（mv_scene.focus 設 cam_tgt，係 mv 鏡頭）→ 轉做村子鏡頭
	if sc.cam_tgt != null:
		_cam_anim = float(sc.cam_tgt) - eh() - sc.top_pad; sc.cam_tgt = null
	if _cam_anim != null:
		var ny = lerpf(cy, float(_cam_anim), minf(1.0, dt * 7.0))
		if absf(ny - float(_cam_anim)) < 0.5: ny = float(_cam_anim); _cam_anim = null
		set_vcam(ny); cy = vcam()
	var V = J.G.get("Village")
	if V is Dictionary and V.get("drag") != null and J.t(V.get("drag")): _cam_anim = null
	sc.cam = cy + eh() + sc.top_pad
	_step_porters(dt)

# ================= [zone] 分區地圖 =================
func _zone_frame(dt: float) -> void:
	var nv = village
	if not nv.has_method("zone_cam") or nv.size.x <= 0: return
	var c = nv.zone_cam()
	if not sc.zone: sc.zone = true; sc._layout(); sc.sim.relayout(); sc.sim._sync_key = ""; sc.sim.sync()
	sc.zt = {"z": c.z / maxf(0.01, sc.k), "x": c.x, "y": c.y}
	sc.hud_on = zone_hud_vis() or sc.sheet.visible or sc.anim != null
	var qb = main.get("quest_bar") if main != null else null
	var mbf = load("res://game/zone/zone_battle.gd").fighting()   # [mapbattle] 打緊仗：收埋大排檔 HUD（招牌菜、生產鏈、影響力…）同任務條
	if mbf:
		sc.hud_on = false
		if sc.sheet.visible: sc.close_sheet()
		if qb is Control and qb.visible: qb.visible = false
	elif qb is Control and qb.visible == sc.hud_on: qb.visible = not sc.hud_on
	if sc.zfocus != null:   # 升級條／目標要求鏡頭移動 → 村子 2D 鏡頭
		var f = sc.zfocus; sc.zfocus = null
		var wx = float(f[2]) if not is_nan(float(f[2])) else c.x + c.vw() / 2.0
		var top = float(f[0]) - float(f[1]) / float(sc.zt.z)
		c.tgt = Vector2(wx - c.vw() / 2.0, top); c.vel = Vector2.ZERO
	if sc.cam_tgt != null: sc.cam_tgt = null
	_step_porters(dt)
# 大排檔 HUD 出唔出：畫面有三成以上係大排檔／野外區
func zone_hud_vis() -> bool:
	var c = village.zone_cam(); var vr = c.rect(); var a = 0.0
	for z in ZD.zones():
		if str(z.type) in ["market", "wild"] and ZD.revealed(str(z.id)): a += ZD.rect(z.rect).intersection(vr).get_area()   # [fogfix] 未開放（黑霧）唔計
	return a >= vr.get_area() * 0.3
# 畫面座標（村子 px）撳中大排檔 HUD／掣／卡 → 交俾 mv_scene，回 true
func zone_hud_tap(p: Vector2) -> bool:
	if not active() or sc.sim == null or sc.sim.st() == null: return false
	var fp = p / maxf(0.01, sc.k)
	var hit = sc.card != null or sc.anim != null or (sc.sim.plus != null and sc.sim.plus.card != null)
	if sc.hud_on and fp.y < sc.top_pad + sc.EHUD_H: hit = true
	var w = sc.sim.war
	if sc.hud_on and w != null and w.get("_btn") is Dictionary:
		for k in w._btn:
			var r = w._btn[k]
			if r is Rect2 and r.grow(4).has_point(fp): hit = true
	if sc.hud_on:
		for k in sc._btns:
			if sc._btns[k].has_point(fp): hit = true
	if hit: sc.tap(fp); return true
	var wp = village.zone_s2w(p); var zid = ZD.zone_at(wp)
	if sc.sheet.visible and not (zid != "" and str(ZD.zone(zid).type) in ["market", "wild"]): sc.close_sheet()
	return false
# 世界座標撳大排檔／野外區（台、客、孤魂、空位）
func zone_world_tap(wp: Vector2) -> void:
	if not active() or sc.sim == null: return
	sc.tap(sc.w2s(wp))
	if sc.get("tap_free"): load("res://game/outpost/ctl_ui.gd").walk_free(wp)   # [ctl] 撳大排檔／野外空地：主角行過去

# 鏡頭移去大排檔區（拔營、測試、主線任務用）
func focus_outpost(frac := 0.5) -> void:
	if ZD.on():   # [zone]
		var mr = ZD.zrect("market"); var c = village.zone_cam()
		c.glide_to(Vector2(mr.get_center().x, mr.position.y + mr.size.y * frac)); return
	var vh = village.size.y / maxf(0.01, village.size.x / 390.0)
	_cam_anim = -eh() + eh() * frac - vh * 0.5

# ---------------- 挑夫鬼（純畫面） ----------------
func _has_stock() -> bool:
	var sim = sc.sim
	for sid in MD.stations(sim.ci()):
		if not sim.unlocked(sid): continue
		for mid in sim.need(sid):
			if float(M.amt(str(mid))) >= 1.0: return true
	return false
func _path() -> PackedVector2Array:
	if ZD.on():   # [zone] 由村子石板路經出村門到櫃台後面
		var o = PackedVector2Array()
		for q in MD.layout(sc.sim.ci()).get("porter", []): o.append(MD.v2(q))
		if o.size() >= 2: return o
	var E = eh(); var L = sc.sim.L
	var dx = float(L.counter.x) + 70.0
	return PackedVector2Array([Vector2(GATE.x + 8, E + 172), Vector2(GATE.x, E + GATE.y - 4), Vector2(GATE.x, E + 26), Vector2(dx + 34, E - 6), Vector2(dx, float(L.counter_y) - 24.0)])
func _step_porters(dt: float) -> void:
	if sc.sim == null or sc.sim.L.is_empty() or sc.anim != null: return
	_pt -= dt
	if _pt <= 0.0:
		_pt = _rng.randf_range(6.0, 10.0)
		if porters.size() < 2 and _has_stock():
			var mids = []
			for sid in MD.stations(sc.sim.ci()):
				if sc.sim.unlocked(sid):
					for mid in sc.sim.need(sid): if float(M.amt(str(mid))) >= 1.0: mids.append(str(mid))
			porters.append({"s": 0.0, "k": ["youhun", "n30_jiugui", "egui"][_rng.randi() % 3], "mid": mids[_rng.randi() % mids.size()] if mids.size() else "", "back": false, "ph": _rng.randf() * 9.0})
	var P = _path(); var L = MD.poly_len(P)
	for p in porters.duplicate():
		if not p.back:
			p.s += 46.0 * dt
			if p.s >= L: p.back = true; p.mid = ""
		else:
			p.s -= 58.0 * dt
			if p.s <= 0.0: porters.erase(p)
func porter_pos(p: Dictionary) -> Vector2: return MD.poly_at(_path(), float(p.s))

func _draw_extra(ctx, vy0: float, vy1: float, items: Array) -> void:
	var sim = sc.sim; var Ly = MD.layout(sim.ci())
	for q in Ly.get("spare", []):   # 留位：「待開檔」
		var x = float(q[0]); var y = float(q[1])
		if y < vy0 - 40.0 or y - 120.0 > vy1: continue
		items.append([y - 30.0, func(): _draw_spare(ctx, x, y)])
	var P = _path()
	for p in porters:
		var pos = MD.poly_at(P, float(p.s)); var nx = MD.poly_at(P, float(p.s) + (2.0 if not p.back else -2.0))
		var a = clampf(float(p.s) / 40.0, 0.0, 1.0)   # 喺村子石板路慢慢現身
		var pp = p
		items.append([pos.y, func(): _draw_porter(ctx, pp, pos, nx.x < pos.x, a)])

# [village2] 大排檔區最底 JOIN_H 高：將原村子地面頂（y 0..JOIN_H）上下反轉鋪上去，由上而下慢慢實，
#   去到分界（大排檔世界 y = EH ＝ 村子 y 0）就同村子地面第一行一模一樣 → 冇接縫
const JOIN_H := 90.0
func _draw_join(ctx, vy0: float, vy1: float) -> void:
	var E = eh()
	if vy1 < E - JOIN_H or vy0 > E: return
	var gt = village.get("ground_tex") if village != null else null
	if not (gt is Texture2D): return
	var k = gt.get_height() / 1130.0
	ctx.save(); ctx.translate(0, E); ctx.scale(1, -1)
	var n = 18; var d = JOIN_H / n
	for j in n:
		var v = j * d
		var f = 1.0 - (v + d * 0.5) / JOIN_H
		ctx.globalAlpha = f * f * (3.0 - 2.0 * f)
		ctx.drawImage(gt, 0, v * k, gt.get_width(), d * k, 0, v, 390, d + 0.6)
	ctx.globalAlpha = 1.0
	ctx.restore()

func _draw_spare(ctx, x: float, y: float) -> void:
	ctx.save()
	Art.el(ctx, x, y - 4, 48, 14, "rgba(30,20,14,.35)")
	ctx.setLineDash([5, 5]); ctx.strokeStyle = "rgba(236,217,164,.55)"; ctx.lineWidth = 2
	ctx.beginPath(); ctx.ellipse(x, y - 4, 48, 14, 0, 0, TAU); ctx.stroke(); ctx.setLineDash([])
	for k in 2: Art.rr(ctx, x - 30 + k * 52, y - 34, 6, 32, 1, "#4a3424", "#22160e", 1)
	Art.rr(ctx, x - 34, y - 40, 68, 22, 3, "rgba(60,40,26,.92)", "#b89a52", 1.2)
	sc._txt(ctx, MD.S("spare", "待開檔", "待開攤"), x, y - 29, 14, Color("#f0e2c8"), "center", 900, 0)
	ctx.restore()

# 擔挑：用遊戲本身嘅蠟筆畫素材，唔再程序畫，畫風同成個遊戲一樣：
#   扁擔 mvp_biandan＝劈開竹片（中間闊兩頭尖、已壓彎、兩頭麻繩＋鐵鈎；竹紋用裝備「竹竿」原圖，砌法見 tools/devkit/art/biandan_make.py）；
#   籮筐 mvp_basket／mvp_basket_front＝大排檔「竹籮」原圖剪出（前後兩層夾住貨）。
#   扁擔中間擱喺膊頭（跟角色高度、餓鬼弓身較低），行路一彈一彈、輕輕側；籮筐由鐵鈎吊住輕輕擺。
const LOAD_INK := "rgba(34,22,16,.85)"
var _lt = {}
func _ltex(k: String) -> Texture2D:
	if not _lt.has(k): _lt[k] = load("res://assets/spr/%s.webp" % k)
	return _lt[k]
func _draw_load(ctx, p: Dictionary, pos: Vector2, flip: bool, t: float) -> void:
	var k = str(p.k); var s = 0.85
	var h = Art.SOUL_H if k == "youhun" else Art.char_h(k)
	if h <= 0.0: h = 52.0
	var bob = absf(sin(t * 9.0)) * 1.8                 # 腳步彈
	var sh = Vector2(pos.x + (-3.0 if flip else 3.0), pos.y - h * s * {"egui": 0.62}.get(k, 0.74) + bob)   # 膊頭
	# 扁擔（mvp_biandan：劈開嘅竹片、中間闊兩頭尖、已經壓彎；兩頭綁麻繩＋鐵鈎）：圖中間竹底擱喺膊頭
	var bt = _ltex("mvp_biandan"); var bw = 62.0; var bh = bw * bt.get_height() / bt.get_width()
	var tilt = sin(t * 4.5 + float(p.ph)) * 0.025      # 跟步輕輕側
	ctx.save(); ctx.translate(sh.x, sh.y); ctx.rotate(tilt)
	var o = Vector2(-bw * 0.5, -bh * BD_REST)
	var hooks = []
	for hx in BD_HOOK: hooks.append(Vector2(o.x + bw * hx, o.y + bh * BD_HOOK_Y))
	var sw = sin(t * 4.5 + float(p.ph)) * 0.14          # 籮筐擺
	_basket(ctx, hooks[0], sw, str(p.mid))
	_basket(ctx, hooks[1], sw * 0.85 + 0.03, str(p.mid))
	if flip: ctx.save(); ctx.scale(-1, 1)
	ctx.drawImage(bt, o.x, o.y, bw, bh)
	if flip: ctx.restore()
	ctx.restore()
const BD_REST := 0.382          # 圖入面：中間竹底（擱膊頭）嘅高度比例
const BD_HOOK := [0.102, 0.872] # 兩個鐵鈎底嘅橫向比例
const BD_HOOK_Y := 0.99

# 一個籮筐：top＝扁擔吊點；ang＝擺動角度
func _basket(ctx, top: Vector2, ang: float, mid: String) -> void:
	var bt = _ltex("mvp_basket"); var bf = _ltex("mvp_basket_front")
	var bw = 23.0; var bh = bw * bt.get_height() / bt.get_width()
	var ry = 8.0    # 籮頂（圖頂）離吊點（鐵鈎底）
	var rim = ry + bh * 0.215   # 籮口左右兩端
	ctx.save(); ctx.translate(top.x, top.y); ctx.rotate(ang)
	# 三條麻繩（微微彎）
	ctx.strokeStyle = LOAD_INK; ctx.lineWidth = 0.9; ctx.lineCap = "round"
	for rx in [-bw * 0.46, 0.0, bw * 0.46]:
		ctx.beginPath(); ctx.moveTo(0, 0); ctx.quadraticCurveTo(rx * 0.45, rim * 0.5, rx, rim - (2.0 if rx == 0.0 else 0.0)); ctx.stroke()
	ctx.drawImage(bt, -bw * 0.5, ry, bw, bh)                 # 籮（後半＋內籮）
	sc._icon(ctx, mid, 0.0, ry + bh * 0.36, 17.0)              # 貨坐喺籮入面
	ctx.drawImage(bf, -bw * 0.5, ry, bw, bh)                 # 籮前半蓋住貨底
	ctx.restore()

func _draw_porter(ctx, p: Dictionary, pos: Vector2, flip: bool, a: float) -> void:
	ctx.save(); ctx.globalAlpha = a
	var t = float(sc.t) + float(p.ph)
	if sc.get("mot") == null or not sc.mot.porter(sc, ctx, p, pos, flip, a, t): Art.draw_char(ctx, str(p.k), pos.x, pos.y, 0.85, {"t": t, "walk": true, "flip": flip, "tamed": true, "alpha": 0.95 * a})   # [motion] 挑夫步法
	if str(p.mid) != "": _draw_load(ctx, p, pos, flip, t)   # 擔挑：竹扁擔擱喺膊頭，兩頭吊住籮筐，籮入面係貨
	ctx.restore()
