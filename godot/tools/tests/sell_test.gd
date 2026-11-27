# [sell] 大排檔「客人要嘅貨做出嚟會去到櫃台」專項測試（老闆回報：一直撳嘆氣蒸籠做壽包，客人收唔到、一個個嬲走）
# GB_TEST：[["wait",3],["notitle"],["gdrun","res://tools/tests/sell_test.gd","logic"],["quit"]]
extends RefCounted

const M = preload("res://game/outpost/mat.gd")
const MD = preload("res://game/outpost/mv_data.gd")
const SIM = preload("res://game/outpost/mv_sim.gd")
const ML = preload("res://game/militia/ml_data.gd")
const A := "st_shoubao"
const G := "m_shoubao"
var bad := 0
var rows := 0
func _p(s) -> void: print("[sell] ", s)
func _chk(name: String, cond: bool, info = "") -> void:
	rows += 1
	if not cond: bad += 1
	print("[sell]   %-44s %s %s" % [name, "OK" if cond else "<<< 唔對", str(info)])
func _S(): return J.G.get("S")
var _saved := {}

func _setup():
	var S = _S()
	J.test_clock = 1.9e12
	S.erase("mv"); S["mat"] = {}
	S.res["buns"] = 0.0; S.res["coins"] = 0.0
	S.mat["m_bao"] = 200.0
	if not S.ghosts.any(func(g): return str(g.get("id")) == "t_sell1"):
		S.ghosts.append({"id": "t_sell1", "k": "zhiren", "name": "測試紙人", "q": "藍", "lv": 8.0, "st": [30.0, 30.0, 30.0], "post": null, "spent": 0.0})
	var sim = SIM.new(); sim.reg_post(); sim.st(); sim.relayout(102.0, 786.0)
	sim.plus.off = true; sim.plus.test_off = true
	sim.spawn_t = 1e9   # 唔自動出客，測試自己放
	for sid in ["st_nuomici", "st_shougongcu"]:
		if sim.st().st.has(sid): sim.st().st[sid].unlocked = false
	sim.st().counter = {}; sim.st().pile = {}
	return sim
func _cust(sim, wants: Dictionary) -> Dictionary:
	var c = {"cid": "t", "k": "youhun", "wants": wants, "got": {}, "st": "in", "slot": 99, "take": 0.3,
		"s": sim.QLEN, "pos": MD.poly_at(sim.QP, sim.QLEN), "ph": 0.0, "flip": true, "lines": [], "vip": false, "tp": "none"}
	sim.custs.append(c); return c
func _run(sim, secs: float, tap := false, dt := 0.05) -> Array:
	var evs = []; var tt = 0.0
	for i in int(secs / dt):
		J.test_clock += dt * 1000.0
		sim.spawn_t = 1e9
		if tap:
			tt += dt
			if tt >= 0.4: tt = 0.0; sim.tap_station(A)
		sim.step(dt); evs.append_array(sim.ev); sim.ev.clear()
	return evs
func _cnt(evs: Array, k: String) -> int:
	var n = 0
	for e in evs: if e.k == k: n += 1
	return n

func logic(_t) -> void:
	_saved = _S().duplicate(true)
	manual()
	upper()
	workers()
	routes()
	half()
	all_maps()
	var S = _S()
	for k in S.keys(): if not _saved.has(k): S.erase(k)
	for k in _saved: S[k] = _saved[k]
	J.test_clock = -1.0
	_p("RESULT ok=%d bad=%d" % [rows - bad, bad])

func manual() -> void:
	_p("===== 1. 冇員工、手撳嘆氣蒸籠，客人要 2 個壽包 =====")
	var sim = _setup()
	var c = _cust(sim, {G: 2})
	var evs = _run(sim, 40.0, true)
	_chk("客人收齊付錢（pay）", _cnt(evs, "pay") >= 1, "pay=%d got=%s" % [_cnt(evs, "pay"), str(c.got)])
	_chk("冇因缺貨嬲走（leave = 0）", _cnt(evs, "leave") == 0, _cnt(evs, "leave"))
	_chk("手做出售件數自動送去櫃台（collect 事件）", _cnt(evs, "collect") >= 1, _cnt(evs, "collect"))
	_chk("收到 2 個壽包", int(c.got.get(G, 0)) == 2, c.got)

func upper() -> void:
	_p("===== 2. 上層台（糯米糍，用壽包）已解鎖、庫存未夠：客人照樣優先 =====")
	var sim = _setup()
	if sim.st().st.has("st_nuomici"): sim.st().st["st_nuomici"].unlocked = true
	_chk("上層台用緊壽包（需求線 > 0）", sim.buffer_of(G, A) > 0.0, sim.buffer_of(G, A))
	var c = _cust(sim, {G: 1})
	var evs = _run(sim, 30.0, true)
	_chk("客人收到壽包付錢", _cnt(evs, "pay") >= 1 and int(c.got.get(G, 0)) == 1, c.got)
	_chk("冇嬲走", _cnt(evs, "leave") == 0)
	sim.custs.clear(); _S().res["buns"] = 0.0
	var r0 = sim.split(A, 1)
	_chk("冇客等：照舊上層要料優先入倉", r0 == [1, 0], r0)

func workers() -> void:
	_p("===== 3. 派員工自動做（唔撳），客人要 3 個 =====")
	var sim = _setup()
	sim.assign(A, 0, "t_sell1")
	var c = _cust(sim, {G: 3})
	var evs = _run(sim, 60.0, false)
	_chk("員工做嘅壽包送到客人手（收齊付錢）", _cnt(evs, "pay") >= 1, "got=%s" % str(c.got))
	_chk("冇嬲走", _cnt(evs, "leave") == 0)
	sim.assign(A, 0, null)

func routes() -> void:
	_p("===== 4. 路線設定 =====")
	var sim = _setup()
	sim.set_route(A, "stock")
	_chk("全部入倉 + 櫃台冇貨：唔招想要壽包嘅客（avail_goods）", not sim.avail_goods().has(G), sim.avail_goods())
	_chk("全部入倉：兵器線 supply = 0", ML.supply(sim, A) == 0, ML.supply(sim, A))
	_cust(sim, {G: 1})
	_chk("全部入倉：split 照入倉 [1,0]", sim.split(A, 1) == [1, 0], sim.split(A, 1))
	var hint = false
	for e in sim.ev: if e.k == "hint_sell": hint = true
	_chk("全部入倉但客人等緊：出提示改出售", hint)
	sim.set_route(A, "sell")
	_chk("全部出售 [0,1]", sim.split(A, 1) == [0, 1])
	sim.set_route(A, "auto")
	_chk("自動 + 客人等緊：先擺櫃台 [0,1]", sim.split(A, 1) == [0, 1], sim.split(A, 1))
	_chk("自動 + 客人等緊：avail_goods 有壽包", sim.avail_goods().has(G) or sim.avail_goods().is_empty(), sim.avail_goods())

func half() -> void:
	_p("===== 5. 壽包一半一半（一轉 1 件都真係一半） =====")
	var sim = _setup()
	var k = 0
	for i in 6: k += sim.split(A, 1)[0]
	_chk("6 轉每轉 1 件：3 件入倉、3 件出售", k == 3, k)
	_chk("4 件一轉：[2,2]", sim.split(A, 4) == [2, 2], sim.split(A, 4))

func all_maps() -> void:
	_p("===== 6. 全部地圖、全部櫃台貨：客人等緊時做出嚟嘅貨會擺櫃台 =====")
	var sim = _setup()
	var seen = {}; var badl = []
	for ci in MD.maps_n():
		for sid in MD.stations(ci):
			if seen.has(sid): continue
			seen[sid] = true
			var g = str(MD.st_def(sid).get("good", ""))
			if g == "": continue
			sim.custs.clear(); sim.st().counter = {}; sim.st().pile = {}
			sim.set_route(sid, "auto")
			_cust(sim, {g: 2})
			var r = sim.split(sid, 2)
			var needbuf = sim.buffer_of(M.rout(sid), sid) > 0.0 and M.amt(M.rout(sid)) < sim.buffer_of(M.rout(sid), sid)
			if r[1] < (1 if needbuf else 2): badl.append("%s→%s" % [sid, str(r)])
	_chk("所有台（%d 個）客人優先（上層要料時一半畀客）" % seen.size(), badl.is_empty(), badl)
