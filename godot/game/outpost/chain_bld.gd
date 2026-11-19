# [village] 後院拓展建築（生產鏈 T1 採集／T2 加工）：資料驅動、起／升／派鬼、建築卡、後院擺位、工作動畫資料
# 冇 class_name、冇 autoload（熱更新規矩）：const CB = preload("res://game/outpost/chain_bld.gd")，全部 static。
#
# 資料：data/nat/chain.json 嘅 GATHER／WORKSHOPS（經 mat.gd 讀）。old 有填嘅係舊建築（伐木場／糯米田／棺材鋪／包子鋪），
#       其餘係「拓展建築」。冇 chain.json → 冇拓展建築，所有包裝原封不動行舊嘢。
# 介面（同引擎線 chain_eco.gd 一致）：建築鍵 = 崗位鍵 = bid；等級 S.bld[bid]（0／冇 = 未起）；鬼 post = bid。
# 產量：全部用引擎線 chain_eco.gd（CE.rates；CE.produce 已喺 native produce() 尾叫，離線自動跟）——呢度唔計產出。
# 解鎖：unlock.ci —— 移動村去到嗰張圖（S.mv.ci）或者舊進度打通到嗰張圖之後；起建築扣 unlock.cost（mat.gd）。
# 升級：費用 = 起建築費 × 0.6 × 等級^1.45（冇起建築費就用棺材板）＋ 冥幣；上限 = 鬼宅（紙紮大屋）等級，同舊建築一樣。
# 崗位：同舊公式 min(4, 1 + floor((等級 − 1) ÷ 3))；POSTS[bid] 自動登記（派人面板用）。
# 後院擺位：舊村子世界 390×1130 底下加一段「後院拓展地」，兩行排，每行 150 高；只顯示已起／解鎖咗／下一張圖會解鎖嘅。
extends RefCounted

const M = preload("res://game/outpost/mat.gd")
const CE = preload("res://game/outpost/chain_eco.gd")
const VF = preload("res://game/village_fence.gd")   # [village2]
const CF = preload("res://game/outpost/chain_field.gd")   # [village2] 一級資源田（資源點）
const OLD_WH := 1130.0
const FENCE_Y := 1168.0
const ROW0 := 1290.0
const ROW_H := 150.0
const COL_X := [95.0, 295.0]
const ICONISH := ["mvi_", "op_", "n30_", "furnace__", "mi_", "of_"]   # 呢啲係道具圖示，唔當建築圖用

static var _ix = null          # {"D": 字典身份, "defs": {bid: def+kind}, "new": [bid 排好], "old": {old: bid}}

# ---------------- 基本 ----------------
static func S():
	var s = J.G.get("S")
	return s if s is Dictionary else null
static func zh() -> bool: return DB.lang != "yue"
static func L(yue: String, zhs: String) -> String: return zhs if zh() else yue
static func T(a) -> String:
	if a is Array and a.size() >= 2: return str(a[1]) if zh() else str(a[0])
	return str(a) if a != null else ""
static func _index() -> Dictionary:
	var D = M.D()
	if _ix != null and is_same(_ix.D, D): return _ix
	var ix = {"D": D, "defs": {}, "new": [], "old": {}}
	var order = 0
	for kk in [["GATHER", "gather"], ["WORKSHOPS", "shop"]]:
		var src = D.get(kk[0], {})
		if not (src is Dictionary): continue
		for b in src:
			var e = src[b]
			if not (e is Dictionary): continue
			var c = e.duplicate(); c["kind"] = kk[1]; c["_o"] = order; order += 1
			ix.defs[str(b)] = c
			var od = str(e.get("old", ""))
			if od != "": ix.old[od] = str(b)
			else: ix.new.append(str(b))
	ix.new.sort_custom(func(a, b):
		var da = ix.defs[a]; var db = ix.defs[b]
		var ca = _uci(da); var cb = _uci(db)
		if ca != cb: return ca < cb
		if da.kind != db.kind: return da.kind == "gather"
		return int(da._o) < int(db._o))
	_ix = ix
	return ix
static func reset() -> void: _ix = null
static func _uci(d: Dictionary) -> int:
	var u = d.get("unlock", {})
	return int(J.num(u.get("ci", 0))) if u is Dictionary else 0

static func defs() -> Dictionary: return _index().defs
static func new_blds() -> Array: return _index().new
static func def(bid: String) -> Dictionary: return defs().get(bid, {})
static func is_new(bid: String) -> bool: return bid in new_blds()
static func of_old(old: String) -> String: return str(_index().old.get(old, ""))
static func kind(bid: String) -> String: return str(def(bid).get("kind", ""))
static func bname(bid: String) -> String:
	var n = def(bid).get("n")
	return T(n) if n is Array else bid
static func outs(bid: String) -> Dictionary:
	var d = def(bid)
	if d.get("kind") == "gather": return {str(d.get("out", "")): 1.0}
	var o = d.get("out")
	return o if o is Dictionary else {}
static func ins(bid: String) -> Dictionary:
	if kind(bid) == "gather": return {}
	var o = def(bid).get("in")
	return o if o is Dictionary else {}
static func main_out(bid: String) -> String:
	var o = outs(bid)
	return str(o.keys()[0]) if o.size() else ""

# ---------------- 解鎖、等級、費用 ----------------
static func frontier() -> int: return CE.frontier()
static func need_ci(bid: String) -> int: return CE.need_ci(bid)
static func unlocked(bid: String) -> bool: return CE.unlocked(bid)
static func lv(bid: String) -> int:
	var s = S()
	if s == null or not (s.get("bld") is Dictionary): return 0
	var od = str(def(bid).get("old", ""))
	return int(J.num(s.bld.get(od if od != "" else bid, 0)))
static func house() -> int:
	var s = S()
	return maxi(1, int(J.num(s.bld.get("house", 1)))) if s != null and s.get("bld") is Dictionary else 1
static func max_lv(bid: String) -> int: return maxi(1, house())
static func build_cost(bid: String) -> Dictionary: return CE.mat_cost(bid)
static func up_cost(bid: String, at_lv: int) -> Dictionary:
	var base = build_cost(bid); var o = {}
	var f = 0.6 * pow(float(maxi(1, at_lv)), 1.45)
	if base.is_empty(): base = {"m_plank": 30}
	for m in base: o[str(m)] = maxf(1.0, round(J.num(base[m]) * f))
	o["coins"] = round(24 * pow(float(maxi(1, at_lv)), 1.7))
	return o
# 費用：mid 或者舊資源鍵（"coins"）都得
static func _amt(k: String) -> float:
	if M.has_def(k): return M.amt(k)
	var s = S()
	return J.num(s.res.get(k, 0)) if s != null and s.get("res") is Dictionary else 0.0
static func _nm(k: String) -> String:
	if M.has_def(k): return M.name(k)
	var RN = DB.D.get("RES_NAMES", {})
	return L("冥幣", "冥幣") if k == "coins" else str(RN.get(k, k))
static func can_pay(c: Dictionary) -> bool:
	for k in c: if _amt(str(k)) < J.num(c[k]) - 1e-6: return false
	return true
static func pay(c: Dictionary) -> bool:
	if not can_pay(c): return false
	for k in c:
		var kk = str(k)
		if M.has_def(kk): M.add(kk, -J.num(c[k]))
		else: S().res[kk] = _amt(kk) - J.num(c[k])
	return true
static func cost_bb(c: Dictionary) -> String:
	if c.is_empty(): return L("免費", "免費")
	var o = []
	for k in c:
		var t = "%s %s" % [_nm(str(k)), _q(J.num(c[k]))]
		o.append(t if _amt(str(k)) >= J.num(c[k]) - 1e-6 else "[color=#ff8a7a]%s[/color]" % t)
	return "　".join(o)

static func slots(bid: String) -> int:
	var l = lv(bid)
	return 0 if l <= 0 else mini(4, 1 + int(floor((l - 1) / 3.0)))
static func workers(bid: String) -> Array:
	var o = []
	var s = S()
	if s == null: return o
	for g in J.iter(s.get("ghosts")):
		if J.seq(J.gp(g, "post"), bid): o.append(g)
	return o

# ---------------- 動作 ----------------
static func build(bid: String) -> bool:
	if not is_new(bid) or lv(bid) > 0 or not unlocked(bid): return false
	if not pay(build_cost(bid)): return false
	S().bld[bid] = 1.0
	_gain(15.0)
	return true
static func upgrade(bid: String) -> bool:
	var l = lv(bid)
	if not is_new(bid) or l <= 0 or l >= max_lv(bid): return false
	if not pay(up_cost(bid, l)): return false
	S().bld[bid] = float(l + 1)
	_gain(10.0 + 8.0 * (l + 1))
	return true
static func assign(bid: String, gid) -> bool:
	if slots(bid) <= 0: return false
	var s = S(); var g = null
	for x in J.iter(s.get("ghosts")): if J.seq(J.gp(x, "id"), gid): g = x
	if g == null or J.seq(J.gp(g, "k"), "afu"): return false
	var ws = workers(bid)
	if ws.size() >= slots(bid): ws[0]["post"] = null
	g["post"] = bid
	return true
static func unassign(gid) -> void:
	var s = S()
	for x in J.iter(s.get("ghosts")): if J.seq(J.gp(x, "id"), gid): x["post"] = null
static func _gain(n: float) -> void:
	var f = J.G.get("gainExp")
	if f != null: J.cl(f, null, [n])

# ---------------- 產量 ----------------
static func _glv(g) -> float:
	var F = J.G.get("F")
	return J.num(J.mc(F, "glv", [g])) if F != null else J.num(J.gp(g, "lv"))
static func mult(bid: String) -> float: return 1.0 + 0.3 * (maxf(1.0, float(lv(bid))) - 1.0)
# 每分鐘：{"w":員工數, "out":{mid:每分}, "in":{mid:每分}}（舊建築唔計，交返舊公式）
static func rates(bid: String) -> Dictionary:
	var r = CE.rates().get(bid)
	return r if r is Dictionary else {"w": 0, "out": {}, "in": {}}
static func starved(bid: String) -> Array: return CE.starved(bid)
# 後院畫面用：一次過計晒 {bid: "work"／"starve"／"idle"}
static func work_states() -> Dictionary:
	var R = CE.rates(); var o = {}
	for bid in R:
		var e = R[bid]; var st = "work"
		for mid in e.get("in", {}):
			if M.amt(mid) < J.num(e["in"][mid]) / 60.0: st = "starve"
		for mid in e.get("out", {}):
			if M.room(mid) < 0.5: st = "starve" if st == "starve" else "full"
		o[bid] = st if st != "full" else "idle"
	return o
static func working(bid: String) -> bool:
	return lv(bid) > 0 and not workers(bid).is_empty() and starved(bid).is_empty()

# ---------------- 文字 ----------------
static func _list(c: Dictionary) -> String:
	var o = []
	for m in c: o.append("%s ×%s" % [M.name(str(m)), _q(J.num(c[m]))])
	return "＋".join(o)
static func _q(v: float) -> String:
	if absf(v - round(v)) < 0.001: return str(int(round(v)))
	return "%.1f" % v
static func recipe_bb(bid: String) -> String:
	if kind(bid) == "gather": return L("產出：[b]%s[/b]（一級原料）", "產出：[b]%s[/b]（一級原料）") % M.name(main_out(bid))
	return L("用料：%s　→　出貨：[b]%s[/b]", "用料：%s　→　產出：[b]%s[/b]") % [_list(ins(bid)), _list(outs(bid))]
static func map_name(c: int) -> String:
	var B = load("res://game/outpost/mv_bridge.gd")
	if B != null and B.has_method("map_name"):
		var n = str(B.map_name(c))
		if n != "": return n
	return L("第 %d 張圖", "第 %d 張地圖") % (c + 1)
static func card_desc(bid: String) -> String:
	var o = [recipe_bb(bid)]
	var l = lv(bid)
	if l > 0:
		var r = rates(bid); var parts = []
		for m in r.get("out", {}): parts.append("%s +%s" % [M.name(m), _q(J.num(r.out[m]))])
		var uses = []
		for m in r.get("in", {}): uses.append("%s %s" % [M.name(m), _q(J.num(r["in"][m]))])
		if parts.is_empty(): o.append(L("每分鐘：冇鬼開工（派鬼先有產出）", "每分鐘：沒有鬼開工（派鬼才有產出）"))
		else: o.append(L("每分鐘：%s", "每分鐘：%s") % "　".join(parts) + (L("（食 %s）", "（消耗 %s）") % "　".join(uses) if uses.size() else ""))
		var sv = starved(bid)
		if sv.size():
			var nm = []
			for m in sv: nm.append(M.name(m))
			o.append("[color=#c2362b]" + L("斷料！等緊：%s", "缺料！等待：%s") % "、".join(nm) + "[/color]")
		var mo = main_out(bid)
		o.append(L("存貨：%s %s　每崗產量 ×%.1f　崗位 %d", "庫存：%s %s　每崗產量 ×%.1f　崗位 %d") % [M.name(mo), _q(floor(M.amt(mo))), mult(bid), slots(bid)])
		o.append(L("一定要派鬼先有產出；每隻鬼嘅產能睇佢嘅「%s」（30 點 = 1 份）", "必須派鬼才有產出；每隻鬼的產能看牠的「%s」（30 點 = 1 份）") % [["力", "智", "武"][CE.stat_i(bid)]])   # 老闆定案
	else:
		var u = need_ci(bid)
		if not unlocked(bid): o.append("[color=#c2362b]" + L("村子去到 %s（第 %d 張圖）先起得", "村子抵達 %s（第 %d 張地圖）才能建造") % [map_name(u), u + 1] + "[/color]")
		elif CF.is_field(bid): o.append(L("「開墾」之後先派得鬼自動採，等級越高崗位越多。", "「開墾」之後才能派鬼自動採，等級越高崗位越多。"))
		else: o.append(L("起好之後派鬼嚟做，等級越高崗位越多。", "建好後派鬼來做，等級越高崗位越多。"))
	if CF.is_field(bid):   # [village2] 資源田：親手採永遠得
		o.insert(1, L("撳地上嘅資源點就可以親手%s（每次 +%d，採完 %d 秒再生）", "點地上的資源點就能親手%s（每次 +%d，採完 %d 秒再生）") % [T(CF.cfg(bid).verb), CF.yield_n(bid), int(CF.REGROW)])
	var users = _users(main_out(bid))
	if users != "": o.append(L("用途：%s", "用途：%s") % users)
	return "\n".join(o)
# 呢樣料俾邊個用（後院加工／移動村台）
static func _users(mid: String) -> String:
	if mid == "": return ""
	var o = []
	for b in defs():
		if mid in ins(str(b)): o.append(bname(str(b)))
	var R = M.D().get("RECIPES", {}); var n = 0
	for sid in R:
		var r = R[sid]
		if r is Dictionary and r.get("in") is Dictionary and r["in"].has(mid): n += 1
	if n > 0: o.append(L("移動村 %d 個台", "移動村 %d 個台") % n)
	return "、".join(o.slice(0, 5))

# 舊建築（伐木場、糯米田、棺材鋪、包子鋪）建築卡效果：換新材料名（包子鋪出普通包子）
static func old_effect(id: String, html: bool) -> String:
	if not (id in ["wood", "rice", "plank", "bun"]): return ""
	var F = J.G.get("F"); var r = J.cl(J.G.get("ratesPerMin"), null, [])
	if F == null or not (r is Dictionary): return ""
	var nl = "<br>" if html else "\n"
	var mw = M.name("m_wood") if M.has_def("m_wood") else "槐木"
	var mr = M.name("m_rice") if M.has_def("m_rice") else "糯米"
	var mp = M.name("m_plank") if M.has_def("m_plank") else "棺材板"
	var mb = M.name("m_bao") if M.has_def("m_bao") else ""
	var sl = J.num(J.mc(F, "slots", [id])); var mu = J.num(J.mc(F, "mult", [id]))
	match id:
		"wood": return L("產出：%s（一級原料）%s每崗產量 ×%.1f　崗位 %d　目前 %s +%.1f/分", "產出：%s（一級原料）%s每崗產量 ×%.1f　崗位 %d　目前 %s +%.1f/分") % [mw, nl, mu, sl, mw, J.num(r.get("wood"))]
		"rice": return L("產出：%s（一級原料）%s每崗產量 ×%.1f　崗位 %d　目前 %s +%.1f/分", "產出：%s（一級原料）%s每崗產量 ×%.1f　崗位 %d　目前 %s +%.1f/分") % [mr, nl, mu, sl, mr, J.num(r.get("rice"))]
		"plank":
			var cg = J.mc(F, "chestGain", ["b"])
			return L("用料：%s ×2 → %s ×1%s崗位 %d　目前 %s +%.1f/分（食 %s %.1f/分）%s藍箱可開出 %s %d", "用料：%s ×2 → %s ×1%s崗位 %d　目前 %s +%.1f/分（耗 %s %.1f/分）%s藍箱可開出 %s %d") % [mw, mp, nl, sl, mp, J.num(r.get("planks")), mw, J.num(r.get("woodUse")), nl, mp, int(J.num(J.gp(cg, "planks")))]
		"bun":
			if mb == "": return ""
			var bao = J.num(r.get("bao")); var bu = J.num(r.get("baoUse"))
			var sb = M.name("m_shoubao") if M.has_def("m_shoubao") else "壽包"
			return L("用料：%s ×1 → %s ×2%s崗位 %d　目前 %s +%.1f/分（食 %s %.1f/分）%s%s 送去移動村「嘆氣蒸籠」先蒸成%s", "用料：%s ×1 → %s ×2%s崗位 %d　目前 %s +%.1f/分（耗 %s %.1f/分）%s%s 送去移動村「嘆氣蒸籠」才蒸成%s") % [mr, mb, nl, sl, mb, bao, mr, bu, nl, mb, sb]
	return ""

# ---------------- 建築卡（menus.gd 嘅資料格式）----------------
static func card(bid: String) -> Dictionary:
	var l = lv(bid); var d = def(bid)
	var o = {"id": bid, "name": bname(bid), "flavor": T(d.get("how", "")), "desc": card_desc(bid), "lv": float(l), "house": float(house())}
	if l <= 0:
		var c = build_cost(bid)
		o["unlocked"] = unlocked(bid); o["cost"] = cost_bb(c); o["canBuild"] = unlocked(bid) and can_pay(c)
		if CF.is_field(bid): o["buildLbl"] = L("開墾", "開墾")   # [village2]
		return o
	o["effect"] = ""
	o["max"] = float(max_lv(bid))
	if l < max_lv(bid):
		var uc = up_cost(bid, l); o["upCost"] = cost_bb(uc); o["canUp"] = can_pay(uc); o["disc"] = 0.0
	var sl = []; var ws = workers(bid); var F = J.G.get("F")
	for i in slots(bid):
		var g = ws[i] if i < ws.size() else null
		sl.append({"id": g.id, "k": g.k, "name": g.name, "lv": _glv(g), "stat": L("等級 %d", "等級 %d") % int(_glv(g))} if g != null else null)
	o["posts"] = [{"post": bid, "name": bname(bid), "desc": L("看鬼怪等級", "看鬼怪等級"), "lock": false, "slots": sl}]
	return o
static func act(bid: String, a: String, arg) -> Variant:
	match a:
		"build":
			if build(bid):
				Snd.play("build"); _fx("banner", [(L("%s 開墾好咗！可以派鬼", "%s 開墾好了！可以派鬼") if CF.is_field(bid) else L("%s 起好咗！", "%s 建好了！")) % bname(bid)])
		"up":
			if upgrade(bid):
				Snd.play("build"); _fx("banner", [L("%s 升到 Lv %d", "%s 升到 Lv %d") % [bname(bid), lv(bid)]])
		"unassign": unassign(arg)
	var sv = J.G.get("save")
	if sv != null: J.cl(sv, null, [])
	J.mc(J.G.get("UI"), "refresh", [])
	return null
static func _fx(m: String, a: Array) -> void:
	var fx = J.G.get("Fx")
	if fx != null: J.mc(fx, m, a)

# 登記 POSTS（派人面板）同 BUILDINGS（其他模塊查名用；建築卡／起建築由呢度包裝處理，唔行舊 bldAct）
static func reg_posts() -> void:
	var BD = J.G.get("BUILDINGS")
	if BD is Dictionary:
		for b in new_blds():
			if not BD.has(b): BD[b] = {"name": bname(b), "desc": recipe_bb(b), "build": {}, "posts": [b], "chain": true}
	var PO = J.G.get("POSTS")
	if not (PO is Dictionary): return
	for b in new_blds():
		if not PO.has(b): PO[b] = {"name": bname(b), "bld": b, "stat": -1.0, "desc": L("做%s（看等級）", "做%s（看等級）") % M.name(main_out(b))}

# ---------------- 後院擺位 ----------------
# 後院顯示嘅拓展建築：已起、已解鎖、或者下一張圖就解鎖（預告）
static func shown() -> Array:
	var f = frontier(); var o = []
	for b in new_blds():
		if lv(b) > 0 or need_ci(b) <= f + 1: o.append(b)
	return o
# [village2] 擺位固定（CF.ANCHOR，唔再跟解鎖次序排兩行）：資源田回田名牌位置，加工建築回建築腳
static func pos(bid: String) -> Vector2:
	if not (bid in shown()): return Vector2(-999, -999)
	if CF.is_field(bid): return CF.sign_pos(bid)
	return CF.anchor(bid)
static func world_h() -> float:
	var sh = shown()
	if sh.is_empty(): return OLD_WH
	var m = 0.0
	for b in sh: m = maxf(m, CF.anchor(b).y)
	return m + 110.0
# 加工建築（資源田由 CF.hit 處理）
static func hit(x: float, y: float) -> String:
	for b in shown():
		if CF.is_field(b): continue
		var p = pos(b)
		if absf(x - p.x) < 56 and y > p.y - 96 and y < p.y + 34: return b
	return ""
# 鬼喺建築前做嘢：左右兩邊、前排
const SPOT := [[-58, 16, 0], [58, 16, 1], [-34, 34, 0], [34, 34, 1]]
static func worker_spots() -> Array:
	var o = []
	for b in shown():
		if lv(b) <= 0 or CF.is_field(b): continue
		var p = pos(b); var ws = workers(b)
		for i in ws.size():
			var sp = SPOT[i % SPOT.size()]
			o.append({"g": ws[i], "x": p.x + sp[0], "y": p.y + sp[1], "flip": sp[2] == 1, "ph": i * 0.7 + p.x * 0.01, "post": b})
	o.append_array(CF.worker_spots())   # [village2] 資源田：鬼企喺資源點旁邊
	return o

# 材料顏色（後備屋頂／產品堆）
const MAT_COL := {"m_wellwater": "#6f8fa6", "m_bamboo": "#6f9a4a", "m_coconut": "#8a5a32", "m_latex": "#e8e2d0", "m_tealeaf": "#4f8a5a",
	"m_straw": "#d6b45a", "m_bananaleaf": "#5aa04a", "m_fish": "#9fb4c4", "m_newspaper": "#b8b0a0", "m_toner": "#3a3a44",
	"m_paper": "#efe4c4", "m_strip": "#c8a85a", "m_cocomilk": "#f4f0e4", "m_rubbersheet": "#c8913a", "m_rope": "#b8925a", "m_pulp": "#a8a498", "m_ink": "#2c3a6a"}
static func mat_col(mid: String) -> Color:
	if MAT_COL.has(mid): return Color(MAT_COL[mid])
	var h = float(hash(mid) % 360) / 360.0
	return Color.from_hsv(h, 0.45, 0.75)
# 建築圖：chain.json art 有圖而且唔係道具圖示、又未俾前面嘅建築用咗 → 用圖；否則後備（程序畫細屋）
static func art_tex(bid: String) -> Texture2D:
	var k = str(def(bid).get("art", ""))
	if k == "": return null
	for p in ICONISH: if k.begins_with(p): return null
	for b in new_blds():
		if b == bid: break
		if str(def(b).get("art", "")) == k: return null
	if Spr.ok(k): return Spr.get_tex(k)
	return PtGfx.tex(k)

# ---------------- 安裝包裝（每格由 nv_village 叫；已裝就即刻返）----------------
static func install() -> void:
	var G = J.G
	var V = G.get("Village")
	if V is Dictionary and not is_same(V.get("__cb_tap_w"), V.get("tap")): _wrap_village(V)
	if V is Dictionary and not is_same(V.get("__cf_act_w"), V.get("doAct")): _wrap_field(V)   # [village2]
	var s0 = S()
	if s0 != null and int(J.num(s0.get("cfield_v", 0))) < 1: CF.migrate(s0)
	var UI = G.get("UI")
	var N = J.gp(UI, "_n") if UI != null else null
	if N is Dictionary and not is_same(N.get("__cb_bld_w"), N.get("bld")): _wrap_menu(N)
	if UI is Dictionary and UI.get("bldEffect") != null and not is_same(UI.get("__cb_eff_w"), UI.get("bldEffect")): _wrap_effect(UI)
	reg_posts()

static func _wrap_village(V: Dictionary) -> void:
	var o_tap = V.get("tap"); var o_cam = V.get("setCam"); var o_walk = V.get("walkTo"); var o_ws = V.get("workerSpots")
	var tap = func(t, a):
		var x = J.num(J.arg(a, 0)); var y = J.num(J.arg(a, 1))
		var fh = CF.hit(x, y, shown())   # [village2] 資源田：名牌 → 卡；資源點 → 親手採
		if fh != null:
			var UI0 = J.G.get("UI")
			if J.t(J.mc(J.G.get("Story"), "busy", [])) or J.t(J.mc(UI0, "modalOpen", [])): return null
			if fh.kind == "sign": J.mc(UI0, "openBuilding", [fh.bid])
			else: CF.tap_node(V, str(fh.bid), int(fh.i), x, y)
			return null
		var b = hit(x, y)
		if b != "":
			var UI = J.G.get("UI")
			if J.t(J.mc(J.G.get("Story"), "busy", [])) or J.t(J.mc(UI, "modalOpen", [])): return null
			J.mc(UI, "openBuilding", [b]); return null
		return J.cl(o_tap, t, a)
	var cam = func(t, a):
		var me = t if t != null else V
		var r = J.cl(o_cam, me, a)
		var wh = world_h()
		if wh > OLD_WH:
			var vh = J.num(me.get("h", 600)) / maxf(0.01, J.num(me.get("scale", 1)))
			me["camY"] = maxf(0.0, minf(wh - vh, J.num(J.arg(a, 0))))
		return r
	var walk = func(t, a):
		var me = t if t != null else V
		var r = J.cl(o_walk, me, a)
		var wh = world_h(); var y = J.num(J.arg(a, 1))
		if wh > OLD_WH and y > OLD_WH - 10 and me.get("hero") is Dictionary: me.hero["ty"] = minf(wh - 10, y)
		if me.get("hero") is Dictionary:   # [village2] 柵欄：阿福留喺村子嗰邊
			var H = me.hero
			var to = VF.clamp_to(Vector2(J.num(H.get("x")), J.num(H.get("y"))), Vector2(J.num(H.get("tx")), J.num(H.get("ty"))))
			H["tx"] = to.x; H["ty"] = maxf(to.y, VF.Y + 24.0)
		return r
	var ws = func(t, a):
		var r = J.cl(o_ws, t, a)
		if r is Array and not new_blds().is_empty(): r.append_array(worker_spots())
		return r
	V["tap"] = tap; V["__cb_tap_w"] = tap
	V["setCam"] = cam; V["walkTo"] = walk; V["workerSpots"] = ws

# [village2] 親手採資源點：包 doAct（act.kind == "cnode"）、heroPose、update（再生＋自動採彈數字）
static func _wrap_field(V: Dictionary) -> void:
	var o_act = V.get("doAct"); var o_pose = V.get("heroPose"); var o_up = V.get("update")
	var da = func(t, a):
		var me = t if t != null else V
		var H = me.get("hero")
		if H is Dictionary and H.get("act") is Dictionary and H.act.get("kind") == "cnode":
			CF.do_act(me, J.num(J.arg(a, 0))); return null
		return J.cl(o_act, t, a)
	var hp = func(t, a):
		var me = t if t != null else V
		var p = CF.pose(me)
		if p != null: return p
		return J.cl(o_pose, t, a)
	var up = func(t, a):
		var r = J.cl(o_up, t, a)
		CF.tick(minf(0.1, J.num(J.arg(a, 0))))
		return r
	V["doAct"] = da; V["__cf_act_w"] = da; V["heroPose"] = hp; V["update"] = up

static func _wrap_menu(N: Dictionary) -> void:
	var o_bld = N.get("bld"); var o_act = N.get("bldAct")
	var bld = func(t, a):
		var id = J.str(J.arg(a, 0))
		if is_new(id): return card(id)
		var r = J.cl(o_bld, t, a)
		return r
	var bact = func(t, a):
		var id = J.str(J.arg(a, 0))
		if is_new(id): return act(id, J.str(J.arg(a, 1)), J.arg(a, 2))
		return J.cl(o_act, t, a)
	N["bld"] = bld; N["__cb_bld_w"] = bld; N["bldAct"] = bact

static func _wrap_effect(UI: Dictionary) -> void:
	var o = UI.get("bldEffect")
	var f = func(t, a):
		var id = J.str(J.arg(a, 0))
		var e = old_effect(id, true)
		return e if e != "" else J.cl(o, t, a)
	UI["bldEffect"] = f; UI["__cb_eff_w"] = f

# ---------------- 移動村模式：後院面板＋入後院睇 ----------------
# main.gd 後院面板（open_backyard）掛鈎叫：列出拓展建築＋「入後院」掣
static func backyard_ui(main) -> void:
	install()
	var nb = new_blds()
	if nb.is_empty(): return
	var body = main.sheet_body
	var go = UIKit.btn(L("去營地睇吓（大地圖底）", "去營地看看（大地圖底部）") if J.t(S().get("mv_on")) else L("入後院睇吓（拓展建築）", "進後院看看（拓展建築）"), "gold"); go.add_theme_font_size_override("font_size", 15)   # [camp]
	go.pressed.connect(func(): show_yard(main))
	body.add_child(go)
	body.add_child(UIKit.rich("[b]%s[/b]" % L("後院拓展建築（一級原料／二級半成品）", "後院拓展建築（一級原料／二級半成品）"), 15, UIKit.INKTXT, "serif"))
	for b in nb:
		var l = lv(b); var st: String
		if l > 0: st = "Lv %d" % l
		elif unlocked(b): st = L("可以起", "可建造")
		else: st = L("第 %d 張圖解鎖", "第 %d 張地圖解鎖") % (need_ci(b) + 1)
		var bb = b
		var btn = UIKit.btn(L("打開", "打開"), "", true)
		btn.disabled = not (l > 0 or unlocked(b))
		btn.pressed.connect(func(): J.mc(J.G.get("UI"), "openBuilding", [bb]))
		var hb = HBoxContainer.new(); hb.add_theme_constant_override("separation", 10)
		var r = UIKit.rich("[b]%s[/b]　%s\n%s" % [bname(b), st, recipe_bb(b)], 14, UIKit.INKTXT); r.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		hb.add_child(r); hb.add_child(btn); body.add_child(hb); body.add_child(UIKit.hsep())

static var yard_on := false
static func show_yard(main) -> void:
	install()
	main.close_sheet()
	var mvv = main.get("mv_view")   # [camp] 移動村模式：後院已經搬咗入大地圖營地 → 鏡頭移去營地
	if mvv != null and is_instance_valid(mvv) and mvv.has_method("cam_camp") and J.t(S().get("mv_on")):
		if str(main.get("tab")) != "village" and main.has_method("_nav_on"): main._nav_on("village")
		mvv.cam_camp(); return
	if main.get("mv_view") != null: main.mv_view.on_hide()
	main.mv_host.visible = false
	main.village.visible = true; main.village.process_mode = Node.PROCESS_MODE_INHERIT
	yard_on = true
	var V = J.G.get("Village")
	if V is Dictionary:
		var sh = shown()
		var y = pos(sh[0]).y if sh.size() else 600.0
		J.mc(V, "focus", [195.0, y])
static func hide_yard(main) -> void:
	yard_on = false
	if main.has_method("_mv_apply"): main._mv_apply()
