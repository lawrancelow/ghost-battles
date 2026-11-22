# [barracks] 村裡陰兵巡邏：畫面（掛喺 ui/nv_village.gd；每隻陰兵一個 Node2D 放入 ysort，同建築、人物一齊按 y 排）
#   邏輯：bk_patrol.gd；畫法：bk_art.gd draw_soldier（陰兵圖接口集中喺嗰度：每姿勢一張圖）
#   效能：用圖時每隻 2 個 draw（地影＋圖）；鏡頭外唔重畫、唔顯示；面板蓋住村子時跟 nv_village 一齊暫停
extends Node

const BK = preload("res://game/barracks/bk_data.gd")
const BP = preload("res://game/barracks/bk_patrol.gd")
const BA = preload("res://game/barracks/bk_art.gd")
const ZD = preload("res://game/zone/zone_data.gd")

var nv = null
var logic = BP.new()
var nodes: Array = []
var _chk := 0.0
var _n := 0

static func attach(village) -> void:
	var n = Node.new(); n.name = "BkPatrol"
	n.set_script(load("res://game/barracks/bk_patrol_view.gd"))
	n.nv = village
	village.add_child(n)

class Soldier extends Node2D:
	var st: Dictionary = {}
	func _draw() -> void:
		if st.is_empty(): return
		BA.draw_soldier(self, str(st.pose), float(st.ph), float(st.dir), int(st.seed))

func _process(dt: float) -> void:
	if nv == null or not is_instance_valid(nv) or nv.ysort == null: return
	_chk -= dt
	if _chk <= 0.0:   # 數量每秒對一次
		_chk = 1.0
		var on = nv.zone and ZD.S() != null
		_n = BP.count_for(BK.def_n() + BK.standby(), BK.built()) if on else 0
	var org = ZD.zrect("village").position if _n > 0 else Vector2.ZERO
	var P = J.G.get("POS")
	var bp = Vector2(J.num(P.barracks[0]), J.num(P.barracks[1])) if _n > 0 and P is Dictionary and P.has("barracks") else Vector2.ZERO
	logic.sync(_n, org, bp)
	while nodes.size() < _n:
		var s = Soldier.new(); nv.ysort.add_child(s); nodes.append(s)
	var V = J.G.get("Village")
	var hero = Vector2.INF
	if V is Dictionary and V.get("hero") is Dictionary: hero = Vector2(J.num(V.hero.get("x", 0)), J.num(V.hero.get("y", 0)))
	if _n > 0: logic.step(minf(dt, 0.1), hero)
	var vr: Rect2 = nv.view_rect().grow(60)
	for i in nodes.size():
		var nd: Node2D = nodes[i]
		if i >= _n: nd.visible = false; continue
		var s = logic.sol[i]
		var inview = vr.has_point(s.p)
		nd.visible = inview
		if not inview: continue
		nd.position = s.p
		nd.st = s
		nd.queue_redraw()
