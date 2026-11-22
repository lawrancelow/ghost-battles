# [barracks] 村裡陰兵巡邏（純邏輯，畫面喺 bk_patrol_view.gd）
#   最多 8 隻：頭 2 隻企兵營門口站崗，其餘喺村路（村子區相對座標嘅路網）隨機巡。
#   主角行近（NEAR）：停低、轉身面向主角、敬禮 SALUTE 秒，再繼續；主角要行開（FAR）先會再敬禮。
extends RefCounted

const NEAR := 58.0
const FAR := 96.0
const SALUTE := 1.0
const SPEED := 24.0
const MAX_N := 8
const PER := 25            # 每 25 個陰兵（村裡：待命＋防衛）畫 1 隻
# 路網（相對村子區左上角；六關村子佈局一樣）。D＝兵營門口；行村中直路（x 442）、橫路（y 470）同南面小路（y 700），避開所有建築（測試逐關檢查）
const NODES := {"D": Vector2(752, 650), "SE": Vector2(700, 700), "S1": Vector2(442, 700), "C": Vector2(442, 470), "E1": Vector2(700, 470),
	"E2": Vector2(840, 470), "W1": Vector2(170, 470), "N1": Vector2(442, 300), "N2": Vector2(442, 120)}
const EDGES := [["D", "SE"], ["SE", "S1"], ["S1", "C"], ["C", "E1"], ["E1", "E2"], ["C", "W1"], ["C", "N1"], ["N1", "N2"]]
const GUARDS := [Vector2(-36, 22), Vector2(6, 24)]   # 兵營門口兩個崗（相對兵營 POS；草棚門口兩邊，唔遮名牌）

var origin := Vector2.ZERO
var bpos := Vector2.ZERO
var sol: Array = []        # {p, dir, pose, ph, seed, guard, home, cur, prev, tgt, sal, saluted}
var rng := RandomNumberGenerator.new()
var _adj := {}

func _init(seed_ := 7) -> void:
	rng.seed = seed_
	for e in EDGES:
		_adj[e[0]] = _adj.get(e[0], []) + [e[1]]; _adj[e[1]] = _adj.get(e[1], []) + [e[0]]

static func count_for(village_troops: int, built: bool) -> int:
	if not built or village_troops <= 0: return 0
	return mini(MAX_N, int(ceil(float(village_troops) / float(PER))))

func npos(k: String) -> Vector2: return origin + NODES[k]

# 對齊數量（多咗就加、少咗就減）；地圖換咗（origin 變）就重排
func sync(n: int, org: Vector2, bp: Vector2) -> void:
	if org != origin or bp != bpos:
		origin = org; bpos = bp; sol.clear()
	while sol.size() > n: sol.pop_back()
	while sol.size() < n:
		var i = sol.size()
		var s = {"seed": i * 37 + 11, "ph": rng.randf() * 3.0, "dir": 1.0, "pose": "stand", "sal": 0.0, "saluted": false, "guard": i < GUARDS.size()}
		if s.guard:
			s["home"] = bp + GUARDS[i]; s["p"] = s.home; s["dir"] = -1.0 if i == 0 else 1.0
		else:
			var keys = NODES.keys(); var k = keys[(i * 2 + 1) % keys.size()]   # 每隻起點唔同（唔會疊埋一齊行）
			s["p"] = npos(k) + Vector2(rng.randf_range(-6, 6), rng.randf_range(-4, 4)); s["cur"] = k; s["prev"] = ""; s["tgt"] = _next(k, "")
			s["wait"] = 0.0; s["spd"] = SPEED * rng.randf_range(0.85, 1.15)   # 快慢少少唔同，唔會一路並排
		sol.append(s)

func _next(k: String, prev: String) -> String:
	var a: Array = _adj.get(k, [])
	if a.is_empty(): return k
	var c = a.filter(func(x): return x != prev)
	if c.is_empty(): c = a
	return c[rng.randi() % c.size()]

# 走一格；hero＝主角世界座標（冇主角傳 Vector2.INF）
func step(dt: float, hero: Vector2) -> void:
	for s in sol:
		s.ph += dt
		var d = s.p.distance_to(hero) if hero != Vector2.INF else 1e9
		if s.saluted and d > FAR: s.saluted = false
		if s.sal > 0.0:   # 敬禮中
			s.sal -= dt; s.pose = "salute"
			if hero != Vector2.INF and absf(hero.x - s.p.x) > 2.0: s.dir = 1.0 if hero.x > s.p.x else -1.0
			if s.sal <= 0.0: s.sal = 0.0; s.pose = "stand"
			continue
		if not s.saluted and d < NEAR:
			s.saluted = true; s.sal = SALUTE; s.pose = "salute"
			if absf(hero.x - s.p.x) > 2.0: s.dir = 1.0 if hero.x > s.p.x else -1.0
			continue
		if s.guard:
			s.pose = "stand"
			s.dir = -1.0 if s.home.x < bpos.x else 1.0
			continue
		if s.get("wait", 0.0) > 0.0:
			s.wait -= dt; s.pose = "stand"; continue
		var tp = npos(s.tgt)
		var v = tp - s.p; var L = v.length()
		if L < 3.0:
			s.prev = s.cur; s.cur = s.tgt; s.tgt = _next(s.cur, s.prev)
			if rng.randf() < 0.35: s.wait = rng.randf_range(0.8, 2.5)   # 偶然企定望吓
			continue
		var mv = minf(L, float(s.get("spd", SPEED)) * dt)
		s.p += v / L * mv
		if absf(v.x) > 1.0: s.dir = 1.0 if v.x > 0 else -1.0
		s.pose = "walk"

func saluting() -> int:
	var n = 0
	for s in sol: if s.pose == "salute": n += 1
	return n
