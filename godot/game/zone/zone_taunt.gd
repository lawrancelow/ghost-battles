# [mapbattle] 打唔過王：王留喺柵欄／野外門外面叫囂（頭頂對白泡泡）
# 全部 static（冇 class_name、冇 autoload）；const TA = preload("res://game/zone/zone_taunt.gd")
# 台詞：data/nat/taunts.json（台詞線 taunts）：bosses.<bid>.{name,lose,idle,rematch,defeat}、cap.<ci>.<zid>.{…}、raid.<ci>:[…]
#   每句 [粵, 中]，顯示前經 DB.N()（女版）。冇檔／冇鍵就用 FALLBACK 幾句佔位。
# 狀態（存檔，JSON 安全）：S.zone.taunt = {"<ci>:<bid>": {"k":"boss","z":"<wild zid>"}, "<ci>:cap:<zid>": {"k":"cap","z":"<zid>"}}
#   輸咗／撤退 → 記低（王企喺門外）；打贏 → 清走。再挑戰唔清（再輸照叫）。
# 叫囂節奏：輸完即講 lose；之後 idle 每 15–30 秒一句（只計喺地圖上嘅在線時間，離線唔計；戰鬥中唔講；王唔喺畫面就唔講、重新計時）
# 泡泡畫喺世界層（zone_over，喺大排檔 HUD 下面，唔遮 UI），字固定畫面 16px（縮放唔變細）。
extends RefCounted

const ZD = preload("res://game/zone/zone_data.gd")
const PATH := "res://data/nat/taunts.json"
const IDLE_MIN := 15.0
const IDLE_MAX := 30.0
const LIFE := 4.6
const FALLBACK := {
	"lose": [["就咁就收工？返去練多兩年先啦。", "就這樣收工？回去多練兩年吧。"], ["你隊鬼，嚇唔到我隔籬隻狗。", "你這隊鬼，連我旁邊的狗都嚇不到。"]],
	"idle": [["喂！仲匿喺圍欄後面？", "喂！還躲在圍欄後面？"], ["阿福，夠膽就再出嚟。", "阿福，有膽就再出來。"]],
	"rematch": [["又嚟？今次記得帶多啲鬼。", "又來？這次記得多帶點鬼。"]],
	"defeat": [["得得得，我認輸……", "好好好，我認輸……"]],
}

static var _D = null
static var bubbles: Array = []        # {key, text, t, life, p(世界), unit?(戰鬥單位 dict 跟住行)}
static var _next := {}                # key → 下一句 idle 剩幾秒
static var _order := {}               # key|which → [洗牌次序, 位置]
static var _ms := 0
static var LOG: Array = []            # 測試用：[[key, which, text], …]
static var hide_keys := {}            # 戰鬥中由 zone_battle 收埋嘅（王喺戰場上）
static var hits: Array = []           # [[Rect2(世界), wild zid]] 撳中叫囂緊嘅王 → 開挑戰卡
static var rng := RandomNumberGenerator.new()
static var _top_min := 6.0
static var _avoid: Array = []
static var world_rects: Array = []   # 今格叫囂泡泡（世界座標）：大排檔閒談對白框會避開（mv_scene._brects）

static func D() -> Dictionary:
	if _D == null:
		var f = FileAccess.open(PATH, FileAccess.READ)
		var o = JSON.parse_string(f.get_as_text()) if f != null else null
		_D = o if o is Dictionary else {}
		rng.randomize()
	return _D
static func N(s: String) -> String: return DB.N(s) if DB.has_method("N") else s
static func T(a) -> String:
	if a is Array and a.size() >= 2: return N(str(a[1]) if ZD.zh() else str(a[0]))
	return N(str(a)) if a != null else ""

# ---------------- 鍵 ----------------
static func boss_key(c: int, bid: String) -> String: return "%d:%s" % [c, bid]
static func cap_key(c: int, zid: String) -> String: return "%d:cap:%s" % [c, zid]
static func raid_key(c: int) -> String: return "%d:raid" % c
static func _def(key: String) -> Dictionary:
	var p = key.split(":")
	var d = D()
	if p.size() >= 3 and p[1] == "cap":
		var cc = d.get("cap", {}).get(p[0], {})
		return cc.get(p[2], {}) if cc is Dictionary and cc.get(p[2]) is Dictionary else {}
	if p.size() >= 2 and p[1] == "raid":
		var r = d.get("raid", {}).get(p[0], [])
		return {"lose": r} if r is Array else {}
	var b = d.get("bosses", {}).get(p[1] if p.size() >= 2 else key, {})
	return b if b is Dictionary else {}
static func lines(key: String, which: String) -> Array:
	var a = _def(key).get(which)
	if a is Array and a.size(): return a
	if which == "rematch" and key.contains(":cap:"): return []   # 資源區頭目冇 rematch
	return FALLBACK.get(which, [])
# 輪住講：每種句洗牌一輪講晒先再洗（同一輪唔重複；新一輪頭句唔同上一句）
static func pick(key: String, which: String) -> String:
	var ls = lines(key, which)
	if ls.is_empty(): return ""
	var ok = key + "|" + which
	var o = _order.get(ok)
	if o == null or int(o[1]) >= o[0].size():
		var last = o[0][o[0].size() - 1] if o != null and o[0].size() else -1
		var idx = range(ls.size()); idx.shuffle()
		if idx.size() > 1 and idx[0] == last: idx.reverse()
		o = [idx, 0]; _order[ok] = o
	var i = int(o[0][int(o[1])]); o[1] = int(o[1]) + 1
	return T(ls[i % ls.size()])

# ---------------- 狀態 ----------------
static func st() -> Dictionary:
	var z = ZD.st()
	if z == null: return {}
	if not (z.get("taunt") is Dictionary): z["taunt"] = {}
	return z.taunt
static func on(key: String) -> bool: return st().has(key)
static func set_on(key: String, k: String, zid: String) -> void:
	var s = ZD.st()
	if s == null: return
	st()[key] = {"k": k, "z": zid}
	_next[key] = rng.randf_range(IDLE_MIN, IDLE_MAX)
static func clear(key: String) -> void:
	st().erase(key); _next.erase(key)
	for b in bubbles.duplicate(): if b.key == key and not b.has("unit"): bubbles.erase(b)
# 而家呢個野外區叫囂緊嘅王（下一個要打嗰個）
static func boss_taunting(zid: String, c := -1) -> String:
	var cc = ZD.ci() if c < 0 else c
	var bi = ZD.boss_next(zid, cc)
	if bi < 0: return ""
	var k = boss_key(cc, str(ZD.bosses(zid, cc)[bi].id))
	return k if on(k) else ""

# 講一句：p＝世界座標（腳底）；unit＝戰鬥單位（泡泡跟住行，座標由 pos_fn 換）
static func say(key: String, which: String, p := Vector2.ZERO, pos_fn := Callable()) -> String:
	var tx = pick(key, which)
	if tx == "": return ""
	for b in bubbles.duplicate(): if b.key == key: bubbles.erase(b)   # 同一個王一次一句
	var b = {"key": key, "text": tx, "t": 0.0, "life": LIFE, "p": p}
	if pos_fn.is_valid(): b["fn"] = pos_fn
	bubbles.append(b)
	LOG.append([key, which, tx])
	return tx

# ---------------- 位置 ----------------
static func gate_of(zid: String) -> Array:   # [門中心, dir（1＝野外喺上面）]
	var z = ZD.zone(zid)
	if z.is_empty(): return [Vector2.ZERO, 1.0]
	var r = ZD.rect(z.rect); var g = z.get("gate", {})
	var dir = float(g.get("dir", 1))
	var gy = float(g.get("y", r.end.y + 10.0 if dir > 0 else r.position.y - 10.0))
	return [Vector2(float(g.get("x", r.get_center().x)), gy), dir]
# 叫囂企位（腳底，世界座標）
static func spot(key: String) -> Vector2:
	var e = st().get(key, {})
	var zid = str(e.get("z", ""))
	if str(e.get("k", "")) == "cap":
		var z = ZD.zone(zid)
		if z.get("door") is Dictionary:
			var o = ZD.v2(z.door.out); var i = ZD.v2(z.door.get("in", z.door.out))
			return o + (o - i).normalized() * 26.0 + Vector2(0, 8)
		return ZD.zrect(zid).get_center()
	var g = gate_of(zid); var r = ZD.zrect(zid)
	var y = minf(g[0].y - 30.0, r.end.y - 12.0) if float(g[1]) > 0 else maxf(g[0].y + 30.0, r.position.y + 40.0)   # 野外區那邊、貼住門
	return Vector2(g[0].x + 46.0, y)
static func art_of(key: String) -> String:
	var e = st().get(key, {})
	var zid = str(e.get("z", ""))
	var ET = J.G.get("ENEMY_T")
	if str(e.get("k", "")) == "cap":
		var sg = ZD.zone(zid).get("stage", {})
		var k = str(sg.get("boss", "youhun"))
		return k if not (ET is Dictionary) or ET.has(k) or Spr.ok(k) else "youhun"
	var p = key.split(":")
	for b in ZD.bosses(zid): if str(b.id) == (p[1] if p.size() > 1 else ""): return str(b.get("art", "youhun"))
	return "youhun"
static func name_of(key: String) -> String:
	var n = _def(key).get("name")
	if n != null: return T(n)
	var p = key.split(":")
	var e = st().get(key, {})
	for b in ZD.bosses(str(e.get("z", ""))): if str(b.id) == (p[1] if p.size() > 1 else ""): return T(b.n)
	return ""

# ---------------- 每格（zone_view.draw_over 尾叫） ----------------
static func _dt() -> float:
	var now = Time.get_ticks_msec()
	var d = 0.0 if _ms == 0 else clampf((now - _ms) / 1000.0, 0.0, 0.25)
	_ms = now
	return d
static var _mb_s = null
static func _mbf() -> bool:
	if _mb_s == null: _mb_s = load("res://game/zone/zone_battle.gd")
	return _mb_s.fighting()
static func _battle_on() -> bool:
	var B = J.G.get("Battle")
	return B is Dictionary and J.t(B.get("active"))
static func step(view: Rect2, dt: float) -> void:
	for b in bubbles.duplicate():
		b.t += dt
		if b.t >= b.life: bubbles.erase(b)
	if _battle_on() or not ZD.on(): return
	for key in st().keys():
		if not str(key).begins_with("%d:" % ZD.ci()) or hide_keys.has(key): continue
		var n = float(_next.get(key, rng.randf_range(IDLE_MIN, IDLE_MAX))) - dt
		if n <= 0.0:
			n = rng.randf_range(IDLE_MIN, IDLE_MAX)
			var p = spot(key)
			if view.grow(-20).has_point(p - Vector2(0, 40)): say(key, "idle", p)   # 王唔喺畫面：唔講（重新計時）
		_next[key] = n

static func draw(c: CanvasItem, nv) -> void:
	hits.clear()
	var dt = _dt()
	if not ZD.on(): return
	var vr: Rect2 = nv.view_rect()
	step(vr, dt)
	var ctx = Ctx.new(c)
	var t: float = nv.t
	var z = maxf(0.05, float(nv.sc))
	for key in st().keys():
		if not str(key).begins_with("%d:" % ZD.ci()) or hide_keys.has(key): continue
		var e = st()[key]
		if str(e.k) == "boss" and boss_taunting(str(e.z)) != key: continue   # 已經打低咗／唔係而家嗰個
		var p = spot(key)
		if not vr.grow(120).has_point(p): continue
		# 喺門外踱來踱去、間中揮拳
		var ph = fmod(t * 0.5, TAU)
		var x = p.x + sin(ph) * 22.0
		var flip = cos(ph) < 0.0
		var o = {"t": t, "walk": absf(cos(ph)) > 0.35, "flip": flip}
		if fmod(t, 3.7) < 0.5: o["atk"] = true; o["walk"] = false
		var g = ctx.createRadialGradient(x, p.y - 40, 6, x, p.y - 40, 60)
		g.addColorStop(0, "rgba(200,30,30,.30)"); g.addColorStop(1, "rgba(200,30,30,0)")
		ctx.fillStyle = g; ctx.fillRect(x - 60, p.y - 100, 120, 120)
		var cap = str(e.k) == "cap"
		Art.draw_char(ctx, art_of(key), x, p.y, 0.8 if cap else 0.95, o)
		hits.append([Rect2(p.x - 50, p.y - 110, 100, 150), str(e.z), str(e.k)])
		# 再挑戰提示（畫面 14px）；打緊仗唔出
		if not _mbf(): _screen_txt(c, ZD.L("撳我再挑戰", "點我再挑戰") if not cap else ZD.L("撳我再攻佔", "點我再攻佔"), Vector2(p.x, p.y + 16), z, 14, Color("#ffd27a"))
	# 避開：大排檔 HUD（頂）、大排檔閒談對白框（mv_scene 上一格嘅 _drects，世界座標）
	_top_min = 6.0; _avoid = []
	var em = nv._zone_em() if nv.has_method("_zone_em") else null
	if em != null and em.sc != null and is_instance_valid(em.sc):
		var es = em.sc
		if float(es.hud_k) > 0.3: _top_min = (float(es.embed_top) + float(es.EHUD_H) * float(es.k)) + 4.0 + 48.0   # HUD 下面仲有「招牌菜／生產鏈」掣一行
	world_rects.clear()
	for b in bubbles: _bubble(c, b, z, vr)

static func _screen_txt(c: CanvasItem, s: String, wp: Vector2, z: float, px: int, col: Color) -> void:
	var f = UIKit.font("sans", 900)
	var w = f.get_string_size(s, HORIZONTAL_ALIGNMENT_LEFT, -1, px).x
	c.draw_set_transform(wp, 0, Vector2(1.0 / z, 1.0 / z))
	c.draw_string_outline(f, Vector2(-w / 2, px * 0.35), s, HORIZONTAL_ALIGNMENT_LEFT, -1, px, 5, Color(0.08, 0.03, 0.03, 0.95))
	c.draw_string(f, Vector2(-w / 2, px * 0.35), s, HORIZONTAL_ALIGNMENT_LEFT, -1, px, col)
	c.draw_set_transform_matrix(Transform2D.IDENTITY)

# 泡泡：畫面 16px 字、最闊 220px；擺喺講嘢者頭頂，夾喺畫面內
static func bubble_rect(b: Dictionary, z: float, vr: Rect2) -> Rect2:
	var p: Vector2 = b.fn.call() if b.has("fn") else b.p
	var f = UIKit.font("sans", 700)
	var ls = wrap_lines(str(b.text), f, 16, 220.0)
	var w = 0.0
	for l in ls: w = maxf(w, f.get_string_size(l, HORIZONTAL_ALIGNMENT_LEFT, -1, 16).x)
	w += 22.0; var h = ls.size() * 21.0 + 14.0
	var sp = (p - vr.position) * z + Vector2(0, -118.0 * z)   # 頭頂（世界 118 單位上面）
	var x = clampf(sp.x - w / 2, 6.0, vr.size.x * z - w - 6.0)
	var y = clampf(sp.y - h, _top_min, maxf(_top_min, vr.size.y * z - h - 6.0))
	var r = Rect2(x, y, w, h)
	for a in _avoid:   # 撞到大排檔對白框：搬上／搬落（揀近啲、喺畫面內）
		if r.intersects(a.grow(4)):
			var up = a.position.y - h - 8.0; var dn = a.end.y + 8.0
			r.position.y = up if up >= _top_min and absf(up - y) <= absf(dn - y) else dn
	var lab = label_rect(str(b.key), z, vr)   # 唔好疊住「點我再挑戰」同王本身
	if lab.size.x > 0 and r.intersects(lab.grow(4)):
		var up = lab.position.y - h - 6.0
		r.position.y = up if up >= 6.0 else lab.end.y + 6.0
	return r
# 「點我再挑戰」字＋王身（畫面座標）
static func label_rect(key: String, z: float, vr: Rect2) -> Rect2:
	if not on(key) or _mbf() or hide_keys.has(key): return Rect2()
	var p = (spot(key) - vr.position) * z
	return Rect2(p.x - 60.0, p.y - 100.0 * z, 120.0, 100.0 * z + 30.0)
static func wrap_lines(s: String, f: Font, px: int, maxw: float) -> Array:
	var out = []; var cur = ""
	for ch in s:
		if f.get_string_size(cur + ch, HORIZONTAL_ALIGNMENT_LEFT, -1, px).x > maxw and cur != "" and not "，。、！？：；）」』…—,.!?".contains(ch): out.append(cur); cur = ch
		else: cur += ch
	if cur != "": out.append(cur)
	return out
static func _bubble(c: CanvasItem, b: Dictionary, z: float, vr: Rect2) -> void:
	var p: Vector2 = b.fn.call() if b.has("fn") else b.p
	if not vr.grow(60).has_point(p - Vector2(0, 50)): return
	var r = bubble_rect(b, z, vr)
	world_rects.append(Rect2(vr.position + r.position / z, r.size / z))
	var a = clampf(minf(b.t / 0.15, (b.life - b.t) / 0.3), 0.0, 1.0)
	var f = UIKit.font("sans", 700)
	var ls = wrap_lines(str(b.text), f, 16, 220.0)
	c.draw_set_transform(vr.position, 0, Vector2(1.0 / z, 1.0 / z))   # 畫面 px
	var sb = UIKit.sb(Color(0.98, 0.95, 0.88, 0.97 * a), 9, Color(0.55, 0.12, 0.08, a), 2)
	c.draw_style_box(sb, r)
	var tip = (p - vr.position) * z + Vector2(0, -100.0 * z)
	var tx = clampf(tip.x, r.position.x + 14, r.end.x - 14)
	c.draw_colored_polygon(PackedVector2Array([Vector2(tx - 8, r.end.y - 1), Vector2(tx + 8, r.end.y - 1), Vector2(tx, r.end.y + 10)]), Color(0.98, 0.95, 0.88, 0.97 * a))
	var yy = r.position.y + 7.0 + 16.0
	for l in ls:
		c.draw_string(f, Vector2(r.position.x + 11, yy), l, HORIZONTAL_ALIGNMENT_LEFT, -1, 16, Color(0.24, 0.1, 0.06, a)); yy += 21.0
	c.draw_set_transform_matrix(Transform2D.IDENTITY)

# 撳中叫囂緊嘅王（世界座標）→ [zid, kind] 或 []
static func hit(p: Vector2) -> Array:
	for h in hits: if h[0].has_point(p): return [h[1], h[2]]
	return []
