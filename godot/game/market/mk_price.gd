# 過勞鬼市集：按章價格視圖（現有攤價格按「各章基價 × 街階倍率」重算）。
# 只放靜態快取，冇依賴（mv_data.gd preload 佢，唔可以反過來 preload mv_data）。
#   st[sid]  ＝ 攤資料副本：up_cost0／unlock_cost 按同一倍數縮放（每個攤自己回本時間不變）
#   gd[gid]  ＝ 商品資料副本：price＝新價
#   goals    ＝ 本章目標副本：獎勵按目標攤嘅倍數縮放
# 由 mk_ops.price_refresh() 建；市集模式關咗（測試預設）就 clear() → 全部照 outpost.json 原值。
extends RefCounted

static var ci := -1
static var st := {}
static var gd := {}
static var goals = null
static var k_of := {}   # sid／gid → 倍數（新價 ÷ 舊價）

static func clear() -> void:
	ci = -1; st = {}; gd = {}; goals = null; k_of = {}

# rows：[{sid, good, price}]（本章全部現有攤）；STATIONS／GOODS／G：outpost.json 原始資料
static func build(c: int, rows: Array, STATIONS: Dictionary, GOODS: Dictionary, G: Array) -> void:
	clear(); ci = c
	var ks = []
	for r in rows:
		var sid = str(r.get("sid", "")); var gid = str(r.get("good", ""))
		if not STATIONS.has(sid) or not GOODS.has(gid): continue
		var old = float(GOODS[gid].get("price", 1.0)); var nw = float(r.get("price", old))
		if old <= 0.0 or nw <= 0.0: continue
		var k = nw / old
		var g2: Dictionary = (GOODS[gid] as Dictionary).duplicate(); g2["price"] = nw; gd[gid] = g2
		var s2: Dictionary = (STATIONS[sid] as Dictionary).duplicate()
		s2["up_cost0"] = maxf(1.0, round(float(s2.get("up_cost0", 10.0)) * k))
		s2["unlock_cost"] = round(float(s2.get("unlock_cost", 0.0)) * k)
		st[sid] = s2; k_of[sid] = k; k_of[gid] = k; ks.append(k)
	ks.sort()
	var kmed = float(ks[ks.size() / 2]) if ks.size() else 1.0
	var out = []
	for g in G:
		if not (g is Dictionary): out.append(g); continue
		var g3: Dictionary = (g as Dictionary).duplicate(true)
		var rw = g3.get("reward")
		if rw is Dictionary and float(rw.get("coins", 0)) > 0.0:
			var k2 = float(k_of.get(str(g3.get("k", "")), kmed))
			rw["coins"] = maxf(1.0, round(float(rw.coins) * k2))
		out.append(g3)
	goals = out
