# [ctl] 行動目標登記（LINES.md 共用約定；ctl 線建立，其他線照住加 provider）
#   const AT = preload("res://game/outpost/act_targets.gd")
#   AT.providers：靜態 Array of Callable；每個 Callable 傳入 game（Main 節點，可以係 null）、回傳 Array[Dictionary]
#   每個目標：{id:String, kind:"stage"/"king"/"res"/"landmark"/"barracks"/"raid", name:String, pos:Vector2(村地圖世界座標),
#             my_pow:int, foe_pow:int(0=非戰鬥), icon:String(可空；Art.draw_char 嘅角色鍵), go:Callable}
#   可選欄位（ctl 自己用，其他線可以唔填）：
#     stand:Vector2  主角企喺邊度先算「走近」（冇就用 pos）
#     tap:Callable   喺地圖上直接撳中目標做咩（冇就用 go）
#     hit:Rect2      地圖上原本嘅點擊範圍（世界座標；冇就用 pos 附近）
#     enemy:bool     係咪敵人（重疊時敵人優先；冇就睇 foe_pow > 0）
#   AT.collect(game)：收齊所有 provider 嘅目標（內建三個：主線關卡迎戰位、野外王、可攻佔資源區），壞嘅 provider 唔會拖死其他。
#   全部 static；冇 class_name、冇 autoload（熱更新規矩）。
extends RefCounted

const ZD = preload("res://game/zone/zone_data.gd")
const GPW = preload("res://native/gpower.gd")

static var providers: Array = []
static var _builtin_on := false

static func _ensure() -> void:
	if _builtin_on: return
	_builtin_on = true
	providers.push_front(func(g): return _p_res(g))
	providers.push_front(func(g): return _p_king(g))
	providers.push_front(func(g): return _p_stage(g))

static func collect(game = null) -> Array:
	_ensure()
	var out: Array = []
	for f in providers:
		if not (f is Callable) or not f.is_valid(): continue
		var r = f.call(game)
		if not (r is Array): continue
		for t in r:
			if t is Dictionary and t.has("id") and t.get("pos") is Vector2: out.append(t)
	return out

# ---------------- 共用 ----------------
static func L(yue: String, zhs: String) -> String: return ZD.L(yue, zhs)
static func is_enemy(t: Dictionary) -> bool:
	if t.has("enemy"): return bool(t.enemy)
	return int(t.get("foe_pow", 0)) > 0
static func stand_of(t: Dictionary) -> Vector2: return t.get("stand", t.pos) if t.get("stand") is Vector2 else t.pos
# 出陣隊伍鬼力（同戰鬥結算 GP.avg(team) 一樣）
static func team_pow() -> int:
	var S = ZD.S()
	if S == null: return 0
	var gl = []
	for id in J.iter(S.get("team")):
		if not J.t(id): continue
		for g in J.iter(S.get("ghosts")):
			if g is Dictionary and J.str(g.get("id")) == J.str(id): gl.append(g); break
	return int(GPW.avg(gl)) if gl.size() else 0
static func stage_need(stg, sid: String) -> int: return int(GPW.stage_need(stg if stg is Dictionary else {}, sid))
static func _busy() -> bool:
	var st = J.G.get("Story"); var ui = J.G.get("UI")
	return (st != null and J.t(J.mc(st, "busy", []))) or (ui != null and J.t(J.mc(ui, "modalOpen", [])))
static func _toast(game, s: String) -> void:
	if game != null and game.has_method("show_toast"): game.show_toast(s)
static func _noteam(game) -> void:
	_toast(game, L("未有出戰隊伍：去「鬼怪」揀隊先", "還沒有出戰隊伍：先到「鬼怪」選隊"))
static func _zv(): return load("res://game/zone/zone_view.gd")
static func _ta(): return load("res://game/zone/zone_taunt.gd")
static func _inside(r: Rect2, p: Vector2, inset := 40.0) -> Vector2:
	var q = r.grow(-inset)
	if q.size.x <= 0 or q.size.y <= 0: return r.get_center()
	return Vector2(clampf(p.x, q.position.x, q.end.x), clampf(p.y, q.position.y, q.end.y))

# ---------------- 內建 1：主線關卡迎戰位（大排檔前面；zone_battle kind "stage"） ----------------
static func _p_stage(game) -> Array:
	if not ZD.on(): return []
	var tg = ZD.stage_target()
	if not tg.has("pos"): return []
	var sid = str(tg.sid); var at: Vector2 = tg.pos
	var stg = {}
	var CH = J.G.get("CHAPTERS")
	var cc = int(tg.get("c", 0)); var si = int(tg.get("s", 0))
	if CH is Array and cc >= 0 and cc < CH.size() and CH[cc].get("stages") is Array and si < CH[cc].stages.size(): stg = CH[cc].stages[si]
	var icon = str(tg.boss) if tg.get("boss") != null else ""
	if icon == "" and tg.get("en") is Array and tg.en.size(): icon = str(tg.en[0])
	var mr = ZD.zrect("market")
	var vc = ZD.zrect("village").get_center()
	var stand = _inside(mr, at + (vc - at).normalized() * 95.0, 30.0)
	return [{"id": "stage:" + sid, "kind": "stage", "name": L("迎戰：%s", "迎戰：%s") % str(tg.get("name", sid)), "pos": at,
		"my_pow": team_pow(), "foe_pow": stage_need(stg, sid), "icon": icon if icon != "" else "youhun", "stand": stand,
		"hit": Rect2(at.x - 100, at.y - 150, 200, 210), "enemy": true,
		"go": func(): _go_stage(game), "tap": func(): _go_stage(game)}]
static func _go_stage(game) -> void:
	if _busy(): return
	var r = ZD.start_stage()
	if r == "noteam": _noteam(game)

# ---------------- 內建 2：野外王（每個已解霧野外區下一個要打嘅王；輸咗喺門外叫囂嘅位都算） ----------------
static func _p_king(game) -> Array:
	if not ZD.on(): return []
	var out = []
	var TA = _ta()
	for z in ZD.of_type("wild"):
		var zid = str(z.id)
		if not ZD.revealed(zid): continue
		var bi = ZD.boss_next(zid)
		if bi < 0: continue
		var b = ZD.bosses(zid)[bi]
		var r = ZD.zrect(zid)
		var at = ZD.v2(z.get("boss_at", [r.get_center().x, r.get_center().y]))
		var g = TA.gate_of(zid)
		var gate: Vector2 = g[0]
		var stand = _inside(r, at + (gate - at).normalized() * 95.0, 30.0)
		var hit = Rect2(at.x - 70, at.y - 130, 140, 200)
		var tk = TA.boss_taunting(zid)
		if tk != "":   # 輸咗：王企喺門外（大排檔嗰邊）叫囂
			at = TA.spot(tk)
			stand = at + Vector2(-60.0, 0.0)
			hit = Rect2(at.x - 50, at.y - 110, 100, 150)
		var foe = 0
		if b.get("chapter") is Array:
			var ch = b.chapter
			var sid = "%d-%d" % [int(ch[0]) + 1, int(ch[1]) + 1]
			var CH = J.G.get("CHAPTERS"); var stg = {}
			if CH is Array and int(ch[0]) < CH.size() and CH[int(ch[0])].get("stages") is Array and int(ch[1]) < CH[int(ch[0])].stages.size(): stg = CH[int(ch[0])].stages[int(ch[1])]
			foe = stage_need(stg, sid)
		else: foe = stage_need(b.get("stage", {}), "")
		var zz = zid
		out.append({"id": "king:" + str(b.id), "kind": "king", "name": L("挑戰：%s", "挑戰：%s") % ZD.T(b.get("n", ["", ""])), "pos": at,
			"my_pow": team_pow(), "foe_pow": foe, "icon": str(b.get("art", "youhun")), "stand": stand, "hit": hit, "enemy": true, "zid": zid,
			"go": func(): _go_king(game, zz), "tap": func(): _zv().open_boss(game, zz)})
	return out
static func _go_king(game, zid: String) -> void:
	if _busy(): return
	var r = ZD.start_battle("boss", zid)
	if r == "noteam": _noteam(game)

static func short_name(n: String) -> String:   # 「資源區 A　後山竹林」→「後山竹林」（按鈕位唔夠）
	return n.split("　")[-1] if n.contains("　") else n

# ---------------- 內建 3：可攻佔資源區（已介紹、未佔領；企喺門口） ----------------
static func _p_res(game) -> Array:
	if not ZD.on(): return []
	var out = []
	for z in ZD.of_type("res"):
		var zid = str(z.id)
		if ZD.owned(zid) or not ZD.revealed(zid) or not (z.get("door") is Dictionary): continue
		var d = z.door
		var dr = ZD.rect(d.get("vis", d.rect))
		var stand = ZD.v2(d.get("in", d.out))
		var zz = zid
		out.append({"id": "res:" + zid, "kind": "res", "name": L("攻佔：%s", "攻佔：%s") % short_name(ZD.T(z.get("n", ["", ""]))), "pos": dr.get_center(),
			"my_pow": ZD.power(), "foe_pow": ZD.need(zid), "icon": "", "stand": stand, "hit": dr, "enemy": false, "zid": zid,
			"go": func(): _zv().open_capture(game, zz), "tap": func(): _zv().open_capture(game, zz)})
	return out
