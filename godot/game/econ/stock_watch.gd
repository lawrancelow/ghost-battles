# [ux] 庫存監察（冇 class_name、冇 autoload；熱更新規矩）：每秒抄低每樣材料嘅數量，
# 計最近 60 秒每樣「進幾多、出幾多」（換算成每分鐘），俾倉庫總覽同頂欄 +n／−n 小字用。唔入存檔。
# 用法：const SW = preload("res://game/econ/stock_watch.gd")；SW.tick(dt)（main._process 叫）；SW.rate(mid) → [每分鐘進, 每分鐘出]
extends RefCounted

const M = preload("res://game/outpost/mat.gd")
const WIN := 60          # 統計窗（秒）
const EXTRA := ["coins", "troops"]   # 唔喺 MATS 嘅舊資源（用 S.res 鍵）

static var _t := 0.0
static var _last := {}      # key → 上一秒數量
static var _ring := {}      # key → [[gain, spend] × WIN]
static var _pos := 0
static var _filled := 0
static var _pend := {}      # key → 未顯示嘅淨變化（頂欄小字用，取咗就清）
static var off := false     # 測試用

static func S():
	var s = J.G.get("S")
	return s if s is Dictionary else null

static func keys() -> Array:
	var o = []
	for k in M.all_ids():
		if M.is_gear(str(k)): continue
		o.append(str(k))
	o.append_array(EXTRA)
	return o

static func amt(k: String) -> float:
	if k in EXTRA:
		var s = S()
		return J.num((s.get("res", {}) as Dictionary).get(k, 0)) if s != null and s.get("res") is Dictionary else 0.0
	return M.amt(k)

static func reset() -> void:
	_t = 0.0; _last.clear(); _ring.clear(); _pos = 0; _filled = 0; _pend.clear()

static func tick(dt: float) -> void:
	if off or S() == null: return
	_t += dt
	while _t >= 1.0:
		_t -= 1.0
		sample()

static func sample() -> void:
	var ks = keys()
	for k in ks:
		var v = amt(k)
		if not _ring.has(k):
			var arr = []; arr.resize(WIN)
			for i in WIN: arr[i] = [0.0, 0.0]
			_ring[k] = arr
		var d = v - float(_last.get(k, v))
		_last[k] = v
		_ring[k][_pos] = [maxf(0.0, d), maxf(0.0, -d)]
		if absf(d) > 1e-6: _pend[k] = float(_pend.get(k, 0.0)) + d
	_pos = (_pos + 1) % WIN
	_filled = mini(WIN, _filled + 1)

# [每分鐘進, 每分鐘出]（統計窗未滿就按已有秒數換算）
static func rate(k: String) -> Array:
	if not _ring.has(k) or _filled == 0: return [0.0, 0.0]
	var g = 0.0; var s = 0.0
	for e in _ring[k]: g += float(e[0]); s += float(e[1])
	var m = 60.0 / float(_filled)
	return [g * m, s * m]

# 取走頂欄要冒嘅小字（淨變化）；只取 |變化| ≥ min_abs 嘅
static func take_pending(k: String, min_abs := 0.5) -> float:
	var v = float(_pend.get(k, 0.0))
	if absf(v) < min_abs: return 0.0
	_pend[k] = 0.0
	return v

# 呢樣材料由邊度嚟、去邊度（台／建築名）
static func sources(mid: String) -> Array:
	var o = []
	if mid in EXTRA: return o
	for x in M.makers(mid): o.append(_nm(x))
	return o
static func uses(mid: String) -> Array:
	var o = []
	if mid in EXTRA: return o
	for x in M.users(mid): o.append(_nm(x))
	return o
static func _nm(x) -> String:
	var id = str(x.get("id", "")) if x is Dictionary else str(x)
	var MD = load("res://game/outpost/mv_data.gd")
	var d = MD.st_def(id)
	if d is Dictionary and not d.is_empty(): return MD.T(d.get("n"))
	var b = M.bld(id)
	if b is Dictionary and b.has("n"):
		var n = b.n
		return str(n[1] if n is Array and n.size() > 1 and DB.lang != "yue" else (n[0] if n is Array else n))
	return id
