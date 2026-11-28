# [tap_priority] 補丁 55：野外區撳優先——孤魂（敵人）＞ 王／名牌／挑戰牌 ＞ 已解放牌；空地唔開卡
#   全部經玩家同一條撳屏路（nv_village.zone_tap，畫面座標）
# 用法：/home/claude/setup/edtest.sh <godot目錄> tap_priority res://tools/tests/tap_priority_test.gd all 600
extends RefCounted

var ok := 0
var bad := 0
const ZD = preload("res://game/zone/zone_data.gd")
const ZV = preload("res://game/zone/zone_view.gd")
const PF = preload("res://tools/tests/paddyfix_test.gd")
const SHOTS := "/tmp/tap_priority/shots/"

func _p(m): print("[tap_priority] ", m)
func _chk(name: String, cond: bool, extra = "") -> void:
	if cond: ok += 1; _p("ok  " + name + ("　" + str(extra) if str(extra) != "" else ""))
	else: bad += 1; _p("BAD " + name + ("　" + str(extra) if str(extra) != "" else ""))
func _w(t, s: float): await t.get_tree().create_timer(s).timeout
func _shot(t, name: String):
	await RenderingServer.frame_post_draw
	t.get_viewport().get_texture().get_image().save_png(SHOTS + name + ".png"); _p("shot " + name)

var m; var nv; var sim; var cam
func _sheet_open() -> bool: return m.sheet != null and m.sheet.visible
func _close() -> void:
	if m.sheet != null: m.sheet.visible = false
	var UI = J.G.get("UI")
	if UI != null: J.mc(UI, "close", [])
func _foe(at: Vector2) -> Dictionary:
	var f = {"k": "youhun", "pos": at, "hp": 999.0, "mx": 999.0, "st": "bang", "t": 0.0, "tgt": at, "ph": 0.0, "flip": false}
	sim.foes.append(f); _mine.append(f); return f
var _mine: Array = []
func _tap(t, wp: Vector2) -> void:
	_close(); await t.get_tree().process_frame
	await RenderingServer.frame_post_draw   # 等 ZV.draw_over 登記咗今格嘅牌
	for f in sim.foes.duplicate(): if not _mine.has(f): sim.foes.erase(f)   # 自然出嘅孤魂行開（唔好干擾）
	for f in _mine: if not sim.foes.has(f): sim.foes.append(f)
	nv.zone_tap(nv.zone_w2s(wp))
	await t.get_tree().process_frame

func all(t) -> void:
	DirAccess.make_dir_recursive_absolute(SHOTS)
	var pf = PF.new()
	m = await pf._boot(t)
	ZD.gate_on = false
	nv = m.village; sim = m.mv_view.sim; cam = nv.zone_cam()
	sim.foe_t = 1e9
	for f in sim.foes.duplicate(): sim.foes.erase(f)
	var wz = ZD.of_type("wild")[0]; var zid = str(wz.id)
	var r = ZD.rect(wz.rect); var at = ZD.v2(wz.get("boss_at", [r.get_center().x, r.get_center().y]))
	cam.z = nv.size.x / 390.0; cam.vel = Vector2.ZERO
	cam.center_on(at + Vector2(0, -20)); await _w(t, 0.8)
	var bs = ZD.bosses(zid); var keep = {}
	for b in bs: keep[ZD._k(str(b.id))] = ZD.st().boss.get(ZD._k(str(b.id)))
	# --- 王未打：孤魂企喺王身邊（舊 140×200 王撳位入面） ---
	for b in bs: ZD.st().boss.erase(ZD._k(str(b.id)))
	await _w(t, 0.3)
	var unlib = ZD.boss_next(zid) >= 0 and not (bs[0].get("chapter") is Array and ZD.boss_done(zid, 0))
	if unlib:
		var f1 = _foe(at + Vector2(52, 20))
		await _shot(t, "unlib_foe")
		await _tap(t, f1.pos + Vector2(0, -30))
		_chk("王未打：撳王旁邊嘅孤魂 → 打中孤魂、唔開王卡", f1.hp < 999.0 and not _sheet_open(), [f1.hp, _sheet_open()])
		var hp1 = f1.hp
		await _tap(t, f1.pos + Vector2(28, -50))   # 偏開 ~35px 都要中（判定放大）
		_chk("撳孤魂偏開少少都打得中（判定 46）", f1.hp < hp1 and not _sheet_open(), f1.hp)
		sim.foes.erase(f1); _mine.erase(f1)
		await _tap(t, at + Vector2(0, -50))
		_chk("撳王本身 → 開王卡", _sheet_open())
		_close()
	else: _p("（呢關野外王跟主線章節，略過未打測試）")
	# --- 已解放：孤魂行過「已解放」牌 ---
	for b in bs: ZD.st().boss[ZD._k(str(b.id))] = true
	await _w(t, 0.3)
	_chk("已解放：boss_next = -1", ZD.boss_next(zid) < 0)
	var f2 = _foe(at + Vector2(6, 12))   # 身體中間（pos-30）啱啱喺「已解放」牌（at.y-20）上
	await _w(t, 0.2); await _shot(t, "lib_foe_on_plate")
	await _tap(t, f2.pos + Vector2(0, -30))
	_chk("已解放：撳蓋住牌嘅孤魂 → 打中孤魂、唔開區卡", f2.hp < 999.0 and not _sheet_open(), [f2.hp, _sheet_open()])
	sim.foes.erase(f2); _mine.erase(f2)
	await _tap(t, at + Vector2(0, -20))
	_chk("已解放：冇孤魂時撳「已解放」牌 → 開區卡", _sheet_open())
	_close()
	await _tap(t, at + Vector2(0, 90))
	_chk("已解放：撳牌以外嘅空地 → 唔開卡", not _sheet_open())
	_close()
	await _tap(t, at + Vector2(-120, 40))
	_chk("撳野外區空地（離牌遠）→ 唔開卡", not _sheet_open())
	_close()
	# 牌細：已解放牌高度 ≤ 26
	var lp = null
	for q in ZV.wild_hit.get(zid, []): if (q as Rect2).has_point(at + Vector2(0, -20)): lp = q
	_chk("「已解放」牌縮細（高 ≤ 26）", lp != null and (lp as Rect2).size.y <= 26.0, lp)
	await _shot(t, "lib_plate")
	for k in keep:
		if keep[k] == null: ZD.st().boss.erase(k)
		else: ZD.st().boss[k] = keep[k]
	_p("RESULT ok=%d bad=%d" % [ok, bad])
