# [chain] 生產鏈：村子（後院）採集／加工建築嘅「產量」（引擎線）
# 冇 class_name、冇 autoload（熱更新規矩）：const CE = preload("res://game/outpost/chain_eco.gd")，全部 static。
#
# 介面（後院線 chain_bld.gd 用）：
#   建築鍵 = 崗位鍵 = chain.json 嘅 bid（GATHER／WORKSHOPS 嘅 key）；等級 S.bld[bid]（0 / 冇 = 未起）；鬼 post = bid。
#   CE.rates()      → {bid: {"w":員工數, "out":{mid:每分}, "in":{mid:每分}}}（只計拓展建築，即 old 冇填嘅）
#   CE.produce(dt)  → 由 native/game.gd produce() 尾叫（即時同離線都經佢，離線自動按原料計、最多 8 小時）
#   CE.starved(bid) → 缺邊啲料（mid 陣列）
#   CE.recipe_txt(bid)／produce_txt(bid)／unlocked(bid)／need_ci(bid)／mat_cost(bid)：顯示同解鎖用
#  - old 有填（wood/rice/plank/bun）＝ 舊建築：照用舊公式（native/game.gd），包子鋪改咗出普通包子 m_bao。
#
# 公式（照 chain.json RULES；L = 建築等級，最少 1）：
#   採集：每隻鬼每分鐘 = rate × (1 + 0.15 × (L − 1))
#   加工：每隻鬼每批 time ÷ (1 + 0.10 × (L − 1)) 秒；每批食 in、出 out
#         原料唔夠就按比例做（同舊 produce 一樣）；出貨倉滿就停（唔會食咗料冇貨）
#   上限：新材料跟 MATS.cap，冇填就跟後院倉庫上限（mat.gd cap()）
extends RefCounted

const M = preload("res://game/outpost/mat.gd")

static func S():
	var s = J.G.get("S")
	return s if s is Dictionary else null
static func T(a) -> String:
	if a is Array and a.size() >= 2: return str(a[0]) if DB.lang == "yue" else str(a[1])
	return str(a) if a != null else ""

# ---------------- 鍵（bid 直接做建築鍵／崗位鍵）----------------
static func is_chain_key(key: String) -> bool: return key in M.new_blds()
static func keys() -> Array: return M.new_blds()

# 舊存檔兼容：S.mat 補返（壽包、棺材板數量照留，唔郁）
static func migrate(s: Dictionary) -> void:
	if not (s.get("mat") is Dictionary): s["mat"] = {}
	if int(J.num(s.get("chain_v", 0))) < 1: s["chain_v"] = 1.0

# ---------------- 文字 ----------------
static func desc(bid: String) -> String:
	var d = M.bld(bid); var h = T(d.get("how", ""))
	return (h + "　" if h != "" else "") + recipe_txt(bid)
static func recipe_txt(bid: String) -> String:   # 「陰竹 ×2 → 紙 ×1」／「產出 陰竹」
	var d = M.bld(bid)
	if d.get("kind") == "gather": return T(["產出：%s", "產出：%s"]) % M.name(str(d.get("out", "")))
	return "%s → %s" % [_list(M.bin(bid)), _list(M.bout(bid))]
static func _list(c: Dictionary) -> String:
	var o = []
	for m in c: o.append("%s ×%s" % [M.name(str(m)), M.qty(J.num(c[m]))])
	return "＋".join(o)
static func produce_txt(bid: String) -> String:
	var d = M.bld(bid)
	if d.get("kind") == "gather": return T(["產出%s（看等級）", "產出%s（看等級）"]) % M.name(str(d.get("out", "")))
	return recipe_txt(bid) + T(["（看等級）", "（看等級）"])

# 建造費：材料 mid → 舊資源鍵（舊面板 canPay/pay/costText 用得）；有新材料嘅就由 bldAct 包裝扣
static func mat_cost(bid: String) -> Dictionary:
	var u = M.bld(bid).get("unlock", {})
	var c = u.get("cost", {}) if u is Dictionary else {}
	return c if c is Dictionary else {}
static func res_cost(bid: String) -> Variant:
	var o = {}
	for m in mat_cost(bid):
		var rk = M.res_key(str(m))
		if rk == "": return null   # 有新材料：舊 canPay 唔識，交俾包裝處理
		o[rk] = J.num(mat_cost(bid)[m])
	return o
static func cost_txt(c: Dictionary) -> String:
	var o = []
	for m in c:
		var ok = M.amt(str(m)) >= J.num(c[m]) - 1e-6
		var t = "%s %s" % [M.name(str(m)), M.qty(J.num(c[m]))]
		o.append(t if ok else "<span class=\"lack\">%s</span>" % t)
	return "　".join(o) if o.size() else T(["免費", "免費"])

# ---------------- 解鎖：移動村去到第幾張圖（或者舊進度打通到邊）----------------
static func frontier() -> int:
	var s = S(); var c = 0
	if s == null: return 0
	if s.get("mv") is Dictionary: c = int(J.num(s.mv.get("ci", 0)))
	var cl = s.get("cleared")
	if cl is Dictionary:
		for i in 12: if J.t(cl.get("%d-3" % (i + 1))): c = maxi(c, i + 1)
	return c
static func need_ci(bid: String) -> int:
	var u = M.bld(bid).get("unlock", {})
	return int(J.num(u.get("ci", 0))) if u is Dictionary else 0
static func unlocked(bid: String) -> bool: return frontier() >= need_ci(bid)
static func lv(bid: String) -> float:
	var s = S()
	if s == null or not (s.get("bld") is Dictionary): return 0.0
	var old = str(M.bld(bid).get("old", ""))
	return J.num(s.bld.get(old if old != "" else bid, 0))

# ---------------- 產量 ----------------
static func _glv(g) -> float:
	var F = J.G.get("F")
	return J.num(J.mc(F, "glv", [g])) if F != null else J.num(J.gp(g, "lv"))
# 每分鐘（拓展建築）：{bid: {"w":員工數, "out":{mid:每分}, "in":{mid:每分}}}
const STAT_REF := 30.0   # 一般鬼能力值大約 30 ＝ 1 份產能
const STAT_MIN := 0.2
# 每間拓展建築睇邊項能力（0 力、1 智、2 武）；冇列明：採集睇力、加工睇智
const BSTAT := {"b_well": 0, "b_bamboo": 0, "b_coco": 0, "b_latex": 1, "b_tea": 1, "b_straw": 0, "b_banana": 0, "b_fish": 2,
	"b_newspaper": 0, "b_toner": 1, "b_paper": 1, "b_strip": 2, "b_cocomilk": 0, "b_rubbersheet": 0, "b_rope": 1, "b_pulp": 0, "b_ink": 1}
static func stat_i(bid: String) -> int:
	if BSTAT.has(bid): return int(BSTAT[bid])
	return 0 if M.bld(bid).get("kind") == "gather" else 1
static func worker_f(g, bid: String) -> float:
	var F = J.G.get("F"); var i = stat_i(bid)
	var v = J.num(J.mc(F, "stat", [g, float(i)])) if F != null else J.num(J.gp(g, "st")[i])
	return maxf(STAT_MIN, v / STAT_REF)
static func rates() -> Dictionary:
	var s = S(); var o = {}
	if s == null: return o
	var nb = M.new_blds()
	if nb.is_empty(): return o
	# 老闆定案：一定要派鬼先有產出；每隻鬼嘅產能 = 呢間建築指定嗰項能力值 ÷ STAT_REF（力／智／武，見 BSTAT）
	var units = []
	for g in J.iter(s.get("ghosts")):
		var p = J.gp(g, "post")
		if not (p is String) or not (p in nb): continue
		units.append([str(p), worker_f(g, str(p))])
	for u in units:
		var bid: String = u[0]; var d = M.bld(bid); var wf: float = u[1]; var p = bid
		if not (s.get("bld") is Dictionary) or J.num(s.bld.get(p, 0)) <= 0: continue
		if not o.has(bid): o[bid] = {"w": 0, "out": {}, "in": {}}
		var e = o[bid]
		e.w += 1
		var L = maxf(1.0, J.num(s.bld.get(p, 1)))
		if d.get("kind") == "gather":
			var mid = str(d.get("out", ""))
			e.out[mid] = J.num(e.out.get(mid)) + wf * J.num(d.get("rate", 0)) * (1.0 + 0.15 * (L - 1.0))
		else:
			var cpm = wf * 60.0 / (maxf(0.1, J.num(d.get("time", 30))) / (1.0 + 0.10 * (L - 1.0)))
			for m in M.bout(bid): e.out[m] = J.num(e.out.get(m)) + J.num(M.bout(bid)[m]) * cpm
			for m in M.bin(bid): e["in"][m] = J.num(e["in"].get(m)) + J.num(M.bin(bid)[m]) * cpm
	return o

# 推進 dt 秒（包住舊 produce 之後叫）。回 {mid: 實際淨變化}
static func produce(dt: float) -> Dictionary:
	var R = rates(); var mm = dt / 60.0; var got = {}
	# 先採集（T1）再加工（T2）：同一格採到嘅料加工即刻用得
	for bid in R:
		if M.bld(bid).get("kind") != "gather": continue
		for mid in R[bid].out:
			var a = M.add_capped(mid, J.num(R[bid].out[mid]) * mm)
			got[mid] = J.num(got.get(mid)) + a
	for bid in R:
		if M.bld(bid).get("kind") != "shop": continue
		var e = R[bid]; var k = 1.0
		for mid in e["in"]:
			var need = J.num(e["in"][mid]) * mm
			if need > 0: k = minf(k, M.amt(mid) / need)
		for mid in e.out:
			var mk = J.num(e.out[mid]) * mm
			if mk > 0: k = minf(k, M.room(mid) / mk)
		k = clampf(k, 0.0, 1.0)
		if k <= 0.0: continue
		for mid in e["in"]:
			var u = J.num(e["in"][mid]) * mm * k
			M.add(mid, -u); got[mid] = J.num(got.get(mid)) - u
		for mid in e.out:
			var a2 = M.add_capped(mid, J.num(e.out[mid]) * mm * k)
			got[mid] = J.num(got.get(mid)) + a2
	return got

# 斷料？（後院卡顯示）：加工建築有人做但原料唔夠一分鐘
static func starved(bid: String) -> Array:
	var e = rates().get(bid)
	if e == null: return []
	var o = []
	for mid in e["in"]:
		if M.amt(mid) < J.num(e["in"][mid]) / 60.0: o.append(mid)
	return o

