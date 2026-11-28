# [xzfollow] 測試：小紙派去打工之後，地圖上唔再跟住主角；撤回就恢復跟隨；同一隻鬼唔會同時出現兩處
# 用法：bash godot/tools/devkit/edtest.sh <godot目錄> xzf res://tools/tests/xzfollow_test.gd all 600
#   截圖：/home/claude/docs/shots/xzf/
extends "res://tools/tests/eqview2_test.gd"

const SH := "/home/claude/docs/shots/xzf/"
const CB = preload("res://game/outpost/chain_bld.gd")
func _p(m): print("[xzf] ", m)

func all(t) -> void:
	var m = await _boot(t)
	DirAccess.make_dir_recursive_absolute(SH)
	var S = J.G.S; var V = J.G.Village
	var xz = _xz(S)
	if xz == null:
		J.cl(J.G.joinGhost, null, ["xiaozhi"]); xz = _xz(S)
	_chk("有小紙", xz != null)
	if xz == null: _p("RESULT ok=%d bad=%d" % [ok, bad]); return
	xz["post"] = null
	await _w(t, 0.6)
	_chk("未派工：小紙跟住主角", _following(V, xz), _dump(V, xz))
	_chk("未派工：小紙只出現一次", _count(V, xz) == 1, _dump(V, xz))
	# ---- 路徑一：舊村建築（包子鋪 bun）— 撳建築 → 派人（native/game.gd n_pick_do）----
	for post in ["bun", "wood", "rice", "plank"]:
		S.bld[post] = maxf(1.0, J.num(S.bld.get(post)))
		load("res://native/game.gd").n_pick_do(post, xz.id)
		await _w(t, 0.6)
		_chk("派去 %s：post 已記低（%s）" % [post, str(xz.get("post"))], J.str(xz.get("post")) == post)
		_chk("派去 %s：唔再跟住主角" % post, not _following(V, xz), _dump(V, xz))
		_chk("派去 %s：地圖上只出現一次（喺崗位做工）" % post, _count(V, xz) == 1, _dump(V, xz))
		if post == "bun":
			_cam(m, Vector2(295, 760), 90.0); await _w(t, 0.5); await _shot2(t, "bun_working")
			var H = V.hero; _cam(m, Vector2(J.num(H.x), J.num(H.y) - 25), 90.0); await _w(t, 0.5); await _shot2(t, "hero_alone")
	# 撤回
	xz["post"] = null
	await _w(t, 0.6)
	_chk("撤回後：恢復跟住主角", _following(V, xz), _dump(V, xz))
	# ---- 路徑二：生產鏈建築（chain_bld.assign）----
	var bid = ""
	for b in J.iter(J.G.S.bld.keys()):
		if CB.is_new(str(b)) and CB.slots(str(b)) > 0: bid = str(b); break
	if bid != "":
		CB.assign(bid, xz.id); await _w(t, 0.6)
		_chk("派去生產鏈 %s：唔再跟住主角" % bid, not _following(V, xz), _dump(V, xz))
		_chk("派去生產鏈 %s：只出現一次" % bid, _count(V, xz) <= 1, _dump(V, xz))
		CB.unassign(xz.id); await _w(t, 0.6)
	# ---- 路徑二b：移動村大排檔台（嘆氣蒸籠等；mv_sim.assign → post "mv"）----
	if m.get("mv_embed") != null:
		var sim = m.mv_embed.sc.sim
		for sid in ["st_shoubao"] + load("res://game/outpost/mv_data.gd").stations(sim.ci()):
			if not sim.st().st.has(sid): continue
			sim.sst(sid).unlocked = true
			var okk = sim.assign(sid, 0, xz.id)
			await _w(t, 0.8)
			_chk("派去大排檔 %s（assign=%s）：post=%s" % [sid, str(okk), str(xz.get("post"))], J.str(xz.get("post")) == "mv")
			_chk("派去大排檔 %s：唔再跟住主角" % sid, not _following(V, xz), _dump(V, xz))
			var nw = 0
			for w in sim.workers: if J.seq(w.gid, xz.id): nw += 1
			_chk("派去大排檔 %s：大排檔有佢做工（%d）" % [sid, nw], nw == 1)
			_cam(m, sim.st_pos(sid), 90.0); await _w(t, 0.5); await _shot2(t, "mv_" + sid)
			sim.assign(sid, 0, null); await _w(t, 0.5)
			_chk("大排檔撤回：恢復跟隨", _following(V, xz), _dump(V, xz))
			# 領班位／守夜位：派完之後經過一次「返嚟／離線結算」（mv_bridge.sync → validate）都唔可以被放返自由
			var MB = load("res://game/outpost/mv_bridge.gd")
			for lst in ["fore:" + sid, "guard"]:
				var ok2 = sim.assign(lst, 0, xz.id)
				MB.sync(); sim.validate(); sim.sync(); await _w(t, 0.6)
				_chk("派做 %s（assign=%s）再經離線結算：post 仲係 mv（%s）" % [lst, str(ok2), str(xz.get("post"))], J.str(xz.get("post")) == "mv")
				_chk("派做 %s：唔再跟住主角" % lst, not _following(V, xz), _dump(V, xz))
				var arr = load("res://game/outpost/mv_idle.gd").fore_arr(sim, sid) if lst != "guard" else sim.st().guards
				_chk("派做 %s：位仲喺度（%s）" % [lst, str(arr)], arr.size() > 0 and J.seq(arr[0], xz.id))
				sim.assign(lst, 0, null); await _w(t, 0.4)
			break
	# ---- 出擊借調（game/rts/sortie_post.gd）----
	await _sortie(t, m, V, xz)
	# ---- 路徑三：任何非空 post（守夜、移動村、出擊、站崗等）----
	for p in ["station", "street", "boss:x"]:
		xz["post"] = p; await _w(t, 0.4)
		_chk("post=%s：唔再跟住主角" % p, not _following(V, xz), _dump(V, xz))
	xz["post"] = null; await _w(t, 0.4)
	_chk("最後撤回：恢復跟隨", _following(V, xz), _dump(V, xz))
	_p("RESULT ok=%d bad=%d" % [ok, bad])

func _xz(S):
	for g in S.ghosts: if J.str(g.k) == "xiaozhi": return g
	return null
func _entries(V, xz) -> Array:
	var o = []
	var vs = V.get("vis")
	if vs is Array:
		for e in vs: if J.seq(J.gp(J.gp(e, "g"), "id"), xz.id): o.append(e)
	return o
func _count(V, xz) -> int: return _entries(V, xz).size()
func _following(V, xz) -> bool:
	return bool(V.get("xz_on"))
func _dump(V, xz) -> String:
	var a = []
	for e in _entries(V, xz): a.append("(%d,%d)" % [int(J.num(e.x)), int(J.num(e.y))])
	return "xz_on=%s 次數=%d %s post=%s hero=(%d,%d)" % [str(V.get("xz_on")), a.size(), " ".join(a), str(xz.get("post")), int(J.num(V.hero.x)), int(J.num(V.hero.y))]
func _cam(m, wp: Vector2, z: float) -> void:
	var V = J.G.Village
	if J.G.get("Village") != null: J.mc(V, "focus", [wp.x, wp.y])
func _shot2(t, name: String):
	await RenderingServer.frame_post_draw
	t.get_viewport().get_texture().get_image().save_png(SH + name + ".png"); _p("shot " + name)

# [xzfollow] 出擊借調：派工中（領班）嘅小紙出擊 → 崗位暫時空出、村入面唔再出現；打完 → 返原位；跟隨中嘅小紙出擊 → 地圖唔再畫跟隨，打完恢復
func _sortie(t, m, V, xz) -> void:
	var SP = load("res://game/rts/sortie_post.gd")
	var BK = load("res://game/barracks/bk_data.gd")
	if m.get("mv_embed") == null: _chk("有大排檔（出擊借調測試）", false); return
	var sim = m.mv_embed.sc.sim; var sid = "st_shoubao"
	if not sim.st().st.has(sid): _chk("有嘆氣蒸籠", false); return
	sim.sst(sid).unlocked = true
	var S = J.G.S
	BK.pad_team()
	if not S.team.has(xz.id): S.team[S.team.find(null)] = xz.id
	# 1. 領班 + 出陣隊並存（新規則）
	sim.assign("fore:" + sid, 0, xz.id); await _w(t, 0.4)
	_chk("領班小紙仍喺出陣隊（並存）", S.team.has(xz.id) and J.str(xz.get("post")) == "mv")
	var bl = SP.busy_lines()
	_chk("出擊卡有借調提示（%s）" % str(bl), bl.size() > 0 and str(bl[0]).find("嘆氣蒸籠領班") >= 0 and str(bl[0]).find("自動") >= 0)
	var op = {"id": 9901}
	var names = SP.borrow(op, [{"side": 0.0, "gid": xz.id}])
	await _w(t, 0.5)
	var fa = load("res://game/outpost/mv_idle.gd").fore_arr(sim, sid)
	_chk("出擊：嘆氣蒸籠領班位暫時空出（%s）" % str(fa), fa[0] == null)
	_chk("出擊：小紙唔再跟主角", not _following(V, xz), _dump(V, xz))
	_chk("出擊：村入面完全見唔到小紙（只由出擊隊代表）", _count(V, xz) == 0, _dump(V, xz))
	_chk("出擊：借調訊息（%s）" % str(names), names.size() == 1)
	var back = SP.restore(9901); await _w(t, 0.6)
	fa = load("res://game/outpost/mv_idle.gd").fore_arr(sim, sid)
	_chk("打完：返嘆氣蒸籠做領班（%s）%s" % [str(fa), str(back)], J.seq(fa[0], xz.id) and J.str(xz.get("post")) == "mv")
	_chk("打完：唔跟主角", not _following(V, xz), _dump(V, xz))
	_chk("打完：仍喺出陣隊", S.team.has(xz.id))
	# 2. 跟隨中嘅小紙出擊
	sim.assign("fore:" + sid, 0, null); await _w(t, 0.4)
	_chk("撤領班：跟返主角", _following(V, xz), _dump(V, xz))
	SP.borrow({"id": 9902}, [{"side": 0.0, "gid": xz.id}]); await _w(t, 0.5)
	_chk("跟隨小紙出擊：地圖唔再畫跟隨", not _following(V, xz) and _count(V, xz) == 0, _dump(V, xz))
	SP.restore(9902); await _w(t, 0.5)
	_chk("跟隨小紙打完：恢復跟隨（只一隻）", _following(V, xz) and _count(V, xz) == 1, _dump(V, xz))
	# 3. 中途關遊戲：冇對應隊伍嘅借調 → heal 還原
	sim.assign("fore:" + sid, 0, xz.id); await _w(t, 0.3)
	SP.borrow({"id": 9903}, [{"side": 0.0, "gid": xz.id}]); await _w(t, 0.2)
	xz.sortie["sess"] = "上一次開遊戲"   # 扮上一次開遊戲留低
	SP.heal(); await _w(t, 0.4)
	fa = load("res://game/outpost/mv_idle.gd").fore_arr(sim, sid)
	_chk("中途關遊戲：借調自動還原返領班位", J.seq(fa[0], xz.id) and not (xz.get("sortie") is Dictionary))
	# 4. 村子崗位（包子鋪）出擊再返
	sim.assign("fore:" + sid, 0, null)
	load("res://native/game.gd").n_pick_do("bun", xz.id); await _w(t, 0.3)
	_chk("包子鋪：派工後仍喺出陣隊", S.team.has(xz.id) and J.str(xz.post) == "bun")
	SP.borrow({"id": 9904}, [{"side": 0.0, "gid": xz.id}]); await _w(t, 0.4)
	_chk("包子鋪出擊：[p56] 崗位保留照開工、村入面見唔到", J.str(xz.get("post")) == "bun" and _count(V, xz) == 0, _dump(V, xz))
	SP.restore(9904); await _w(t, 0.4)
	_chk("包子鋪打完：返去復工", J.str(xz.get("post")) == "bun" and _count(V, xz) == 1, _dump(V, xz))
	xz["post"] = null
