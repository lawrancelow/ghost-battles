# [xzfollow] 派工中嘅鬼出擊：借調規則（老闆 11-27）
#   * 出擊（地圖戰鬥）帶走嘅名鬼，如果有派工（村子／營地崗位、大排檔員工／領班／守夜、分村等），
#     出發一刻：崗位暫時空出（記低原位），佢喺村入面唔再出現（唔做工、唔跟主角、唔喺廣場行），只由出擊隊伍代表。
#   * 打完（隊伍返到村）：自動返原崗位復工（原位俾人佔咗就搵同一個台嘅空位；冇位就留喺閒著並提示）。
#   * 出擊卡會列出邊幾隻係派工中借調，等玩家知。
#   * 中途關遊戲（ops 冇存檔）：下次見到冇對應隊伍嘅借調記錄，即刻還原。
# 記錄放喺鬼身上：g.sortie = {"op": op_id, "post": 原 post, "mv": [list, slot] 或 null, "gr": [ci, sid, idx] 或 null}
extends RefCounted

static var SESS := ""   # 今次開遊戲嘅記號：只有上一次開遊戲留低（冇得再完成）嘅借調先由 heal 還原
static func sess() -> String:
	if SESS == "": SESS = str(Time.get_ticks_usec()) + "_" + str(randi())
	return SESS

static func _S(): return J.G.get("S")
static func _sim() -> Variant:
	var m = Engine.get_main_loop().root.get_node_or_null("Main") if Engine.get_main_loop() != null else null
	var em = m.get("mv_embed") if m != null else null
	if em != null and is_instance_valid(em) and em.get("sc") != null and em.sc.get("sim") != null: return em.sc.sim
	return null
static func _ghost(id) -> Variant:
	var S = _S()
	if not (S is Dictionary): return null
	for g in J.iter(S.get("ghosts")): if g is Dictionary and J.str(g.get("id")) == J.str(id): return g
	return null
static func T(yue: String, zhs: String) -> String: return str(DB.N(zhs if DB.lang != "yue" else yue))

# 呢隻鬼而家喺邊個大排檔位（[list, slot]，list ＝ sid／"fore:sid"／"guard"）
static func mv_slot(gid) -> Array:
	var sim = _sim()
	if sim == null or sim.st() == null: return []
	var m = sim.st()
	for sid in m.st:
		var e = m.st[sid]
		if e.get("workers") is Array:
			for i in e.workers.size(): if e.workers[i] != null and J.seq(e.workers[i], gid): return [str(sid), i]
		if e.get("fore") is Array:
			for i in e.fore.size(): if e.fore[i] != null and J.seq(e.fore[i], gid): return ["fore:" + str(sid), i]
	for i in m.guards.size(): if m.guards[i] != null and J.seq(m.guards[i], gid): return ["guard", i]
	return []

# 人睇得明嘅崗位名（「嘆氣蒸籠領班」「包子鋪」…）
static func where(g) -> String:
	var p = J.str(g.get("post")) if J.t(g.get("post")) else ""
	if p == "": return ""
	if p == "mv":
		var sl = mv_slot(g.get("id"))
		if sl.is_empty(): return T("過勞鬼市集", "過勞鬼市集")
		var MD = load("res://game/outpost/mv_data.gd")
		var l = str(sl[0])
		if l == "guard": return T("守夜", "守夜")
		if l.begins_with("fore:"): return T("%s領班", "%s領班") % MD.T(MD.st_def(l.substr(5)).get("n"))
		return T("%s員工", "%s員工") % MD.T(MD.st_def(l).get("n"))
	var PO = J.G.get("POSTS")
	if PO is Dictionary and PO.has(p): return str(PO[p].get("name", p))
	return p

# 出擊卡提示：team 入面派緊工嘅名鬼
static func busy_lines() -> Array:
	var o = []
	var S = _S()
	if not (S is Dictionary): return o
	for id in J.iter(S.get("team")):
		if not J.t(id): continue
		var g: Variant = _ghost(id)
		if g == null or not J.t(g.get("post")): continue
		o.append(T("%s 正在%s做工：出擊期間呢個崗位會暫時空出，打完自動返去復工。", "%s 正在%s做工：出擊期間這個崗位會暫時空出，打完自動回去復工。") % [str(DB.L(J.str(g.name))), where(g)])
	return o

# 出發：帶走嘅名鬼標記 sortie（就算冇派工都標，村入面就唔會再畫佢，例如跟住主角嘅小紙）
static func borrow(op, units: Array) -> Array:
	var names = []
	for u in units:
		if J.num(u.get("side")) != 0 or not J.t(u.get("gid")): continue
		var g: Variant = _ghost(u.gid)
		if g == null or J.str(g.get("k")) == "afu": continue
		var rec = {"op": op.id, "post": g.get("post"), "mv": null, "sess": sess()}
		if J.t(g.get("post")):
			var p = J.str(g.post)
			if p == "mv":
				var sl = mv_slot(g.id); var sim = _sim()
				if not sl.is_empty() and sim != null:
					rec.mv = sl; names.append([J.str(g.name), where(g)])
					sim.assign(str(sl[0]), int(sl[1]), null)   # 空出個位（post → null）
			else:
				names.append([J.str(g.name), where(g)])
				g["post"] = null
		g["sortie"] = rec
	return names

# 打完／叫回返到村：還原
static func restore(op_id) -> Array:
	var back = []
	var S = _S()
	if not (S is Dictionary): return back
	for g in J.iter(S.get("ghosts")):
		if not (g is Dictionary) or not (g.get("sortie") is Dictionary): continue
		if op_id != null and J.num(g.sortie.get("op")) != J.num(op_id): continue
		var r = g.sortie; g.erase("sortie")
		if not J.t(r.get("post")) or J.t(g.get("post")): continue   # 本身冇派工／出擊期間已經派咗第二度
		var ok = false
		if r.get("mv") is Array:
			var sim = _sim()
			if sim != null:
				var l = str(r.mv[0]); var i = int(r.mv[1])
				var arr: Array = []
				if l == "guard": arr = sim.st().guards
				elif l.begins_with("fore:"): arr = load("res://game/outpost/mv_idle.gd").fore_arr(sim, l.substr(5))
				elif sim.st().st.has(l): arr = sim.sst(l).workers
				if i < arr.size() and arr[i] != null and not J.seq(arr[i], g.id):   # 原位有人：搵同一列嘅空位
					i = arr.find(null)
				if i >= 0 and i < arr.size(): ok = sim.assign(l, i, g.id)
		else:
			var post = J.str(r.post)
			var F = J.G.get("F")
			var PO = J.G.get("POSTS")
			var slots = J.num(J.mc(F, "slots", [post])) if F != null and PO is Dictionary and PO.has(post) else -1.0   # -1 ＝ 唔係村子崗位（分村、站崗等）：照放返
			var n = 0
			for x in J.iter(S.ghosts): if x is Dictionary and J.str(x.get("post")) == post: n += 1
			if slots < 0.0 or n < slots: g["post"] = r.post; ok = true
		if ok: back.append(T("%s 打完仗，返去%s復工", "%s 打完仗，回去%s復工") % [str(DB.L(J.str(g.name))), where(g)])
		else: back.append(T("%s 打完仗返嚟，原本嘅崗位冇位，暫時閒著", "%s 打完仗回來，原本的崗位沒位置，暫時閒著") % str(DB.L(J.str(g.name))))
	return back

# 冇對應隊伍嘅借調記錄（中途關咗遊戲）：還原
static func heal() -> void:
	var S = _S()
	if not (S is Dictionary): return
	var me = sess()
	for g in J.iter(S.get("ghosts")):
		if g is Dictionary and g.get("sortie") is Dictionary and J.str(g.sortie.get("sess")) != me:
			var oid = g.sortie.get("op")
			for m in restore(oid): print("[sortie_post] heal ", m)

static func away(g) -> bool: return g is Dictionary and g.get("sortie") is Dictionary
