# 生產鏈面板（chainui）測試＋截圖。
# GB_TEST：[["wait",3],["notitle"],["gdrun","res://tools/tests/chainui_test.gd","logic"],["gdrun","res://tools/tests/chainui_test.gd","shots"],["quit"]]
# 資料：有 data/nat/chain.json 就用正式檔；冇就用 tools/tests/chainui_fixture.json（直接塞入 mat.gd，唔寫檔）。
# 驗算全部由原始 JSON 獨立計（唔叫面板嘅反查／解鎖函數）再同面板對。
extends RefCounted

const M = preload("res://game/outpost/mat.gd")
const MD = preload("res://game/outpost/mv_data.gd")
const CP = preload("res://game/outpost/chain_panel.gd")
const OUT := "/tmp/chainui/shots/"
const FIX := "res://tools/tests/chainui_fixture.json"
var D: Dictionary
var bad := 0
var rows := 0
var src := ""

func _p(s) -> void: print("[cu] ", s)
func _ok(name: String, cond: bool, info := "") -> void:
	rows += 1
	if not cond: bad += 1
	print("[cu]   %-46s %s %s" % [name, "OK" if cond else "<<< 唔對", info])
func _S(): return J.G.get("S")
func _tree(): return Engine.get_main_loop()
func _wait(s: float) -> void: await _tree().create_timer(s).timeout
func _frames(n := 2) -> void:
	for i in n: await _tree().process_frame

func _load_data() -> void:
	if FileAccess.file_exists(M.PATH):
		src = M.PATH; M.reload()
	else:
		src = FIX; M.use_file(FIX)
	D = JSON.parse_string(FileAccess.get_file_as_string(src))
	MD.reload()
	_p("資料：%s（%d 樣材料）" % [src, D.MATS.size()])

# ---- 獨立反查 ----
func _x_makers(mid: String) -> Array:
	var o = []
	for b in D.GATHER: if str(D.GATHER[b].get("out")) == mid: o.append("gather:" + b)
	for b in D.WORKSHOPS: if (D.WORKSHOPS[b].get("out", {}) as Dictionary).has(mid): o.append("shop:" + b)
	for s in D.RECIPES: if str(D.RECIPES[s].get("out")) == mid: o.append("st:" + s)
	o.sort(); return o
func _x_users(mid: String) -> Array:
	var o = []
	for b in D.WORKSHOPS: if (D.WORKSHOPS[b].get("in", {}) as Dictionary).has(mid): o.append("shop:" + b)
	for s in D.RECIPES: if (D.RECIPES[s].get("in", {}) as Dictionary).has(mid): o.append("st:" + s)
	o.sort(); return o
func _keys(a: Array) -> Array:
	var o = []
	for e in a: o.append("%s:%s" % [e.k, e.id])
	o.sort(); return o
func _x_tier_n(t: int) -> int:
	var n = 0
	for k in D.MATS: if int(D.MATS[k].get("tier", 1)) == t: n += 1
	return n
func _x_st_ci(sid: String) -> int:
	if sid in D.CARRY: return 0
	var OP = JSON.parse_string(FileAccess.get_file_as_string(MD.PATH))
	for m in OP.MAPS: if sid in m.stations: return int(m.ci)
	return -1
# 獨立解鎖判斷
func _x_ok(kind: String, id: String) -> bool:
	var S = _S(); var c = int(S.mv.ci)
	if kind == "st":
		var mc = _x_st_ci(id)
		if mc < 0: return false
		if not (id in D.CARRY):
			if mc > c: return false
			if mc < c: return true
		var e = S.mv.st.get(id)
		return e is Dictionary and bool(e.get("unlocked", false))
	var d = D.GATHER.get(id, D.WORKSHOPS.get(id))
	if c < int(d.get("unlock", {}).get("ci", 0)): return false
	var old = str(d.get("old", ""))
	return float(S.bld.get(old if old != "" else id, 0)) > 0.0
func _x_mat_ok(mid: String) -> bool:
	for k in _x_makers(mid):
		var a = k.split(":")
		if _x_ok(a[0], a[1]): return true
	return false

func _texts(n: Node, acc: Array) -> Array:
	if n is Label: acc.append(n.text)
	elif n is Button: acc.append(n.text)
	for c in n.get_children(): _texts(c, acc)
	return acc
func _name(mid: String) -> String:
	var n = D.MATS.get(mid, {}).get("n", [mid, mid])
	return str(n[0]) if DB.lang == "yue" else str(n[1])
func _stname(sid: String) -> String:
	var n = MD.st_def(sid).get("n", [sid, sid])
	return str(n[0]) if DB.lang == "yue" else str(n[1])
func _mkname(key: String) -> String:
	var a = key.split(":")
	if a[0] == "st": return _stname(a[1])
	var d = D.GATHER.get(a[1], D.WORKSHOPS.get(a[1]))
	return str(d.n[0]) if DB.lang == "yue" else str(d.n[1])

# 字細／爆格：面板入面所有睇得見嘅 Label／Button 字 ≥ 14，橫向唔出面板
func _layout_check(p: Control, tag: String) -> void:
	var small = []; var over = []
	var pr = p.get_global_rect()
	var vr = p.view.get_global_rect()
	var stack = [p]
	while stack.size():
		var n = stack.pop_back()
		stack.append_array(n.get_children())
		if not (n is Control) or not n.is_visible_in_tree(): continue
		if n is Label or n is Button:
			var fs = n.get_theme_font_size("font_size")
			if fs < 14 and n.text != "": small.append("%s(%d)" % [n.text.substr(0, 8), fs])
		var r = n.get_global_rect()
		if p.view.is_ancestor_of(n) and (r.end.y < vr.position.y or r.position.y > vr.end.y): continue
		if r.position.x < pr.position.x - 0.5 or r.end.x > pr.end.x + 0.5: over.append("%s %s [%.0f..%.0f]" % [n.get_class(), n.name, r.position.x, r.end.x])
		if n is Label and n.autowrap_mode == TextServer.AUTOWRAP_OFF and not n.clip_text:
			var f = n.get_theme_font("font"); var w = f.get_string_size(n.text, HORIZONTAL_ALIGNMENT_LEFT, -1, n.get_theme_font_size("font_size")).x
			if w > n.size.x + 1.0: over.append("字出格 %s（%.0f > %.0f）" % [n.text.substr(0, 10), w, n.size.x])
	_ok("[%s] 字最細 14px" % tag, small.is_empty(), str(small.slice(0, 5)))
	_ok("[%s] 唔爆格（橫向喺面板內、字唔出格）" % tag, over.is_empty(), str(over.slice(0, 5)))

func _setup_state(ci: int) -> void:
	var S = _S()
	if not (S.get("mv") is Dictionary): S["mv"] = {"ci": 0.0, "st": {}}
	S.mv.ci = float(ci); S["cleared"] = {}
	S.mv.st = {}
	var OP = JSON.parse_string(FileAccess.get_file_as_string(MD.PATH))
	for m in OP.MAPS:
		if int(m.ci) != ci: continue
		var i = 0
		for sid in m.stations:
			S.mv.st[sid] = {"lv": 1.0, "unlocked": i < 2, "workers": []}; i += 1
	for sid in D.CARRY: S.mv.st[sid] = {"lv": 1.0, "unlocked": true, "workers": []}
	if not (S.get("bld") is Dictionary): S["bld"] = {}
	S.bld["wood"] = 1.0; S.bld["rice"] = 1.0; S.bld["plank"] = 1.0; S.bld["bun"] = 0.0
	# 拓展建築：頭一個起咗，其他未起
	var first = true
	for b in D.GATHER.keys() + D.WORKSHOPS.keys():
		var d = D.GATHER.get(b, D.WORKSHOPS.get(b))
		if str(d.get("old", "")) != "": continue
		S.bld[b] = 1.0 if first else 0.0; first = false

var sc = null
var own := true
func _scene(tt) -> void:
	var m = tt.main()
	var mv = m.get("mv_view")
	if mv != null and is_instance_valid(mv) and mv.get_script() != null and mv.get_script().resource_path == "res://game/outpost/mv_scene.gd":
		sc = mv; own = false   # 主畫面已經嵌咗移動村：直接用佢（唔好疊兩個場景）
		sc.on_show(); sc.card = null
		if sc.get("embed") == true:   # [unify] 合一地圖：鏡頭移去大排檔區（HUD／生產鏈掣先出）
			var ZD = load("res://game/zone/zone_data.gd")
			var nv = m.get("village")
			if ZD.on() and nv != null and nv.has_method("zone_cam"):   # [p45] 分區地圖（zone）：HUD 睇 zone_hud_vis（畫面三成係大排檔），唔再睇舊 setCam；大排檔要先散霧
				ZD.reveal_all(-1, true)
				var c = nv.zone_cam(); c.center_on(ZD.zrect("market").get_center()); c.tgt = null; c.vel = Vector2.ZERO
			else: J.mc(J.G.get("Village"), "setCam", [-600.0])
			await _frames(30)
		await _frames(3); return
	own = true
	sc = load("res://game/outpost/mv_scene.gd").new(); sc.name = "MvSceneCU"
	var vil = m.get("village")
	m.add_child(sc)
	if vil != null: m.move_child(sc, vil.get_index() + 1)
	sc.setup(m); sc.on_show(); sc.card = null
	await _frames(3)

func logic(tt) -> void:
	_load_data()
	var S = _S()
	var lang0 = DB.lang
	for lang in ["yue", "zh"]:
		DB.lang = lang
		_p("==== 語言 %s ====" % lang)
		_setup_state(0)
		# ---- 反查 ----
		var rbad = []
		for mid in D.MATS:
			if _keys(CP.makers(mid)) != _x_makers(mid): rbad.append("做 " + mid)
			if _keys(CP.users(mid)) != _x_users(mid): rbad.append("用 " + mid)
		_ok("反查：每樣材料邊個做／邊個用（%d 樣）" % D.MATS.size(), rbad.is_empty(), str(rbad.slice(0, 6)))
		# ---- 解鎖（ci 0 同 ci 1 兩個情況）----
		for c in [0, 1]:
			_setup_state(c)
			var ub = []; var nlock = 0; var nok = 0
			for b in D.GATHER.keys() + D.WORKSHOPS.keys():
				var k = "gather" if D.GATHER.has(b) else "shop"
				if CP.mk_state({"k": k, "id": b}).ok != _x_ok(k, b): ub.append(b)
			for sid in D.RECIPES:
				if CP.mk_state({"k": "st", "id": sid}).ok != _x_ok("st", sid): ub.append(sid)
			for mid in D.MATS:
				var x = _x_mat_ok(mid)
				if CP.unlocked(mid) != x: ub.append("mat " + mid)
				if x: nok += 1
				else: nlock += 1
			_ok("解鎖判斷（ci=%d）：建築、台、材料" % c, ub.is_empty(), "開 %d／鎖 %d %s" % [nok, nlock, str(ub.slice(0, 6))])
		# 鎖住嘅理由：未到嘅圖要寫「第 N 張」
		_setup_state(0)
		var why_ok = true; var seen_map = 0
		for mid in D.MATS:
			var st = CP.mat_state(mid)
			if st.ok: continue
			var best = 99
			for k in _x_makers(mid):
				var a = k.split(":")
				var cc = _x_st_ci(a[1]) if a[0] == "st" else int(D.GATHER.get(a[1], D.WORKSHOPS.get(a[1], {})).get("unlock", {}).get("ci", 0))
				best = mini(best, cc)
			if best >= 1 and best < 99:
				seen_map += 1
				if not ("第 %d 張" % (best + 1) in st.why): why_ok = false; _p("  理由唔啱 %s：%s" % [mid, st.why])
		_ok("未到嘅圖寫「第 N 張圖解鎖」", why_ok and seen_map > 0, "（%d 樣）" % seen_map)
		# ---- 面板開關 ----
		await _scene(tt)
		var btn = sc.frame.get_node_or_null("ChainBtn")
		_ok("移動村有「生產鏈」掣", btn != null and btn.visible)
		var p = btn.open_panel(); await _frames(3)
		_ok("撳掣開面板（全螢幕、喺最頂）", is_instance_valid(p) and p.get_parent() == sc.frame and p.get_index() == sc.frame.get_child_count() - 1 and not btn.visible, "size=%s" % str(p.size))
		var mb = tt.main().get("mv_back")
		_ok("面板開住：主畫面「後院」掣收埋（唔蓋住關閉掣）", mb == null or not mb.is_visible_in_tree())
		_ok("面板闊 390、高 = 畫面去頂欄底欄", absf(p.size.x - 390.0) < 0.5 and absf(p.size.y - (sc.H - sc.top_pad - sc.bot_pad)) < 1.0)
		# ---- 每層數量 ----
		var tot = 0
		for t in range(1, 6):
			p.set_tier(t); await _frames(2)
			var n = p.rows.size(); tot += n
			_ok("T%d 行數 = chain.json（%d）" % [t, _x_tier_n(t)], n == _x_tier_n(t) and p.list.get_child_count() == maxi(1, n), "面板 %d" % n)
			# 每行文字：名、邊個做、用去邊
			var tb = []
			for mid in p.rows:
				var tx = " ".join(_texts(p.rows[mid], []))
				if not (_name(mid) in tx): tb.append(mid + " 冇名")
				for k in _x_makers(mid): if not (_mkname(k) in tx): tb.append(mid + " 冇寫 " + _mkname(k))
				for k in _x_users(mid):
					var a = k.split(":")
					var outs = [str(D.RECIPES[a[1]].out)] if a[0] == "st" else (D.WORKSHOPS[a[1]].out as Dictionary).keys()
					for o in outs: if not (_name(o) in tx): tb.append(mid + " 冇寫用去 " + o)
				var tg = (D.get("GEAR", {}) as Dictionary).has(mid)
				if tg != ("裝備" in tx): tb.append(mid + " 裝備標籤")
				if (D.get("BATTLE_ITEMS", {}) as Dictionary).has(mid) != ("戰鬥道具" in tx): tb.append(mid + " 道具標籤")
				if not _x_mat_ok(mid) and not ("未解鎖" in tx): tb.append(mid + " 鎖冇寫")
			_ok("T%d 每行：名／邊度做／用去邊／標籤／未解鎖" % t, tb.is_empty(), str(tb.slice(0, 5)))
			_layout_check(p, "T%d" % t)
		_ok("五層加埋 = 全部材料", tot == D.MATS.size(), "%d／%d" % [tot, D.MATS.size()])
		# ---- 展開鏈 ----
		var top = ""
		for t in [5, 4, 3]:
			for mid in D.MATS: if top == "" and int(D.MATS[mid].tier) == t: top = mid
		if top != "":
			p.set_tier(int(D.MATS[top].tier)); await _frames(2)
			var r = p.rows[top]
			var lp = r.get_global_transform() * Vector2(40, 20)
			p.tap_at(p.view.get_global_transform().affine_inverse() * lp); await _frames(3)
			var ch = p.rows[top].find_child("Chain", true, false)
			_ok("撳 %s → 展開上下游鏈" % top, ch != null and p.open_mid == top)
			if ch != null:
				var downs = {}; var ups = {}; var part = 0
				for n in ch.get_child(0).get_children():
					if n.name == "HDown": part = 1
					elif n.name == "HUp": part = 2
					elif str(n.name).begins_with("N_"):
						var mm = str(n.name).substr(2)
						if part == 1: downs[mm] = true
						else: ups[mm] = true
				var exp = {}; var q = [top]
				while q.size():
					var x = q.pop_back()
					for k in _x_makers(x):
						var a = k.split(":"); var ins = {}
						if a[0] == "st": ins = D.RECIPES[a[1]].get("in", {})
						elif a[0] == "shop": ins = D.WORKSHOPS[a[1]].get("in", {})
						for i in ins:
							if not exp.has(i): exp[i] = true; q.append(i)
						if ins.size(): break
				var reach_t1 = false
				for mm in downs: if int(D.MATS.get(mm, {}).get("tier", 0)) == 1: reach_t1 = true
				_ok("鏈向下追到 T1（%d 樣）" % exp.size(), reach_t1 and downs.keys().all(func(x): return exp.has(x)) and (exp.size() > 40 or exp.keys().all(func(x): return downs.has(x))), "面板 %d" % downs.size())
				_layout_check(p, "展開 " + top)
			# 由 T1 追上去
			var t1 = ""
			for mid in D.MATS: if t1 == "" and int(D.MATS[mid].tier) == 1 and _x_users(mid).size(): t1 = mid
			p.jump(t1); await _frames(4)
			var ch2 = p.rows[t1].find_child("Chain", true, false)
			var ups2 = {}
			if ch2 != null:
				var part2 = 0
				for n in ch2.get_child(0).get_children():
					if n.name == "HUp": part2 = 2
					elif part2 == 2 and str(n.name).begins_with("N_"): ups2[str(n.name).substr(2)] = true
			var expu = {}; var q2 = [t1]
			while q2.size():
				var x2 = q2.pop_back()
				for k in _x_users(x2):
					var a2 = k.split(":")
					var outs2 = [str(D.RECIPES[a2[1]].out)] if a2[0] == "st" else (D.WORKSHOPS[a2[1]].out as Dictionary).keys()
					for o in outs2:
						if o != t1 and not expu.has(o): expu[o] = true; q2.append(o)
			var maxt = 0
			for o in ups2: maxt = maxi(maxt, int(D.MATS.get(o, {}).get("tier", 0)))
			var maxx = 0
			for o in expu: maxx = maxi(maxx, int(D.MATS.get(o, {}).get("tier", 0)))
			_ok("%s 鏈向上追到最高層 T%d" % [t1, maxx], ch2 != null and maxt == maxx and ups2.keys().all(func(x): return expu.has(x)), "面板去到 T%d，%d 樣（應 %d）" % [maxt, ups2.size(), expu.size()])
			# 撳鏈入面一樣 → 跳過去
			if ch2 != null:
				var node = null
				for n in ch2.get_child(0).get_children(): if node == null and str(n.name).begins_with("N_"): node = n
				if node != null:
					var tgt = str(node.name).substr(2)
					p.tap_at(p.view.get_global_transform().affine_inverse() * (node.get_global_transform() * Vector2(30, 10))); await _frames(4)
					_ok("撳鏈入面「%s」跳去佢嗰層展開" % tgt, p.open_mid == tgt and p.tier == int(D.MATS[tgt].tier))
		# ---- 拖動 ----
		var big = 1
		for t in range(1, 6): if _x_tier_n(t) > _x_tier_n(big): big = t
		p.set_tier(big); await _frames(2)
		if p.rows.size(): p.toggle(p.rows.keys()[0]); await _frames(3)
		var ms = p.max_scroll()
		var s0 = p.scroll
		_drag(p, Vector2(180, 400), Vector2(180, 250))
		var s1 = p.scroll
		await _wait(0.5)
		_ok("向上拖 150px：列表落 150（有得拖，max %.0f）" % ms, ms <= 0.0 or absf((s1 - s0) - minf(150.0, ms + 40.0 - s0)) < 1.0, "%.0f → %.0f" % [s0, s1])
		_ok("拖完唔會當撳（冇切換展開）", p.open_mid == (p.rows.keys()[0] if p.rows.size() else ""))
		_ok("拖完夾返界內", p.scroll >= -0.5 and p.scroll <= ms + 0.5, "%.1f" % p.scroll)
		# ---- 新！ ----
		var nm = ""
		for mid in D.MATS: if nm == "" and str(D.MATS[mid].get("res", "")) == "": nm = mid
		p.close(); await _frames(3)
		_ok("撳關閉：面板冇咗、掣返嚟", not is_instance_valid(p) and btn.visible)
		_ok("關咗面板：「後院」掣還原", mb == null or mb.visible)
		S["mat_seen"] = {}
		if nm != "":
			M.add(nm, -M.amt(nm)); M.add(nm, 3.0)
			_ok("第一次攞到 %s → 新！" % nm, CP.is_new(nm) and CP.has_new(int(D.MATS[nm].tier)))
			await _wait(0.7)
			_ok("生產鏈掣有紅點", btn._new_cache)
			p = btn.open_panel(); await _frames(2)
			p.set_tier(int(D.MATS[nm].tier)); await _frames(2)
			var tx2 = " ".join(_texts(p.rows[nm], []))
			_ok("面板行有「新！」、分頁有新字", "新！" in tx2 and p.tabs[int(D.MATS[nm].tier) - 1][1].visible)
			var cbn = p.find_child("Close", true, false)
			cbn.emit_signal("pressed"); await _frames(3)
			_ok("睇過關閉 → S.mat_seen 記住、唔再新", not CP.is_new(nm) and J.t(S.mat_seen.get(nm)) and not is_instance_valid(p))
			var fresh = ""
			for mid in D.MATS: if fresh == "" and mid != nm and str(D.MATS[mid].get("res", "")) == "" and M.amt(mid) <= 0.0: fresh = mid
			if fresh != "": _ok("未攞過嘅 %s 唔算新" % fresh, not CP.is_new(fresh))
			var oldm = ""
			for mid in D.MATS: if oldm == "" and str(D.MATS[mid].get("res", "")) != "": oldm = mid
			if oldm != "": M.add(oldm, 5.0); _ok("舊資源 %s 唔當新" % oldm, not CP.is_new(oldm))
		# 冇場景都開得（open_in）
		var host = Control.new(); host.size = Vector2(390, 844); _tree().root.add_child(host)
		var p2 = CP.open_in(host); await _frames(2)
		_ok("冇移動村場景都開得（open_in）", is_instance_valid(p2) and p2.rows.size() == _x_tier_n(1))
		host.queue_free()
		if own: sc.on_hide(); sc.queue_free()
		sc = null
		await _frames(2)
	DB.lang = lang0
	_p("RESULT rows=%d bad=%d" % [rows, bad])
	print("CHAINUI_RESULT ", "PASS" if bad == 0 else "FAIL", " ", rows, " ", bad)

func _drag(p, a: Vector2, b: Vector2) -> void:
	var e = InputEventMouseButton.new(); e.button_index = MOUSE_BUTTON_LEFT; e.pressed = true; e.position = a; p._view_input(e)
	for i in range(1, 11):
		var mm = InputEventMouseMotion.new(); mm.position = a.lerp(b, i / 10.0); p._t += 0.016; p._view_input(mm)
	var e2 = InputEventMouseButton.new(); e2.button_index = MOUSE_BUTTON_LEFT; e2.pressed = false; e2.position = b; p._view_input(e2)

func _shot(name: String) -> void:
	var st = _tree().root.get_node("Main").story
	for i in 10:
		if st.cur == null: break
		st.skip_scene(); await _tree().process_frame
	await _tree().process_frame
	await RenderingServer.frame_post_draw
	var img = _tree().root.get_viewport().get_texture().get_image()
	img.save_png(OUT + name + ".png"); _p("SHOT " + OUT + name + ".png")

func shots(tt) -> void:
	DirAccess.make_dir_recursive_absolute(OUT)
	_load_data()
	var S = _S()
	DB.lang = "yue"
	_setup_state(0)
	S["mat_seen"] = {}
	# 啲庫存：有啲有、有啲冇；一樣新材料
	var i = 0
	for mid in D.MATS:
		if str(D.MATS[mid].get("res", "")) == "": M.add(mid, -M.amt(mid)); M.add(mid, float((i * 7) % 23) if i % 3 != 0 else 0.0)
		i += 1
	for mid in D.MATS: if str(D.MATS[mid].get("res", "")) == "" and M.amt(mid) > 0: S.mat_seen[mid] = true
	for mid in D.MATS:
		if int(D.MATS[mid].tier) == 2 and str(D.MATS[mid].get("res", "")) == "": S.mat_seen.erase(mid); M.add(mid, 4.0); break
	await _scene(tt)
	await _wait(1.0)
	await _shot("00_mv_button")
	var btn = sc.frame.get_node("ChainBtn")
	var p = btn.open_panel(); await _wait(0.4)
	for t in range(1, 6):
		p.set_tier(t); await _wait(0.3)
		await _shot("%02d_tab_T%d" % [t, t])
	# 展開：最高層一樣（追落去 T1）
	var top = ""
	for t in [5, 4, 3]:
		for mid in D.MATS: if top == "" and int(D.MATS[mid].tier) == t: top = mid
	p.jump(top); await _wait(0.5)
	await _shot("06_chain_%s" % top)
	p.scroll = p.max_scroll(); await _wait(0.3)
	await _shot("07_chain_%s_bottom" % top)
	# T1 追上去
	var t1 = ""
	for mid in D.MATS: if t1 == "" and int(D.MATS[mid].tier) == 1 and _x_users(mid).size() > 0 and str(D.MATS[mid].get("res", "")) == "": t1 = mid
	if t1 == "": t1 = D.MATS.keys()[0]
	p.jump(t1); await _wait(0.5)
	await _shot("08_chain_up_%s" % t1)
	# T3 中間一樣（上下都有）
	var mid3 = ""
	for mid in D.MATS: if mid3 == "" and int(D.MATS[mid].tier) == 3 and _x_users(mid).size() > 0: mid3 = mid
	if mid3 != "":
		p.jump(mid3); await _wait(0.5)
		await _shot("09_chain_mid_%s" % mid3)
	# 中文版 + 第 2 張圖
	DB.lang = "zh"; _setup_state(1)
	p.close(); await _wait(0.2)
	p = btn.open_panel(); await _wait(0.3)
	p.set_tier(3); await _wait(0.3)
	await _shot("10_zh_ci1_T3")
	p.set_tier(1); await _wait(0.3)
	await _shot("11_zh_ci1_T1")
	if mid3 != "":
		p.jump(mid3); await _wait(0.5)
		await _shot("12_zh_chain_%s" % mid3)
	p.close()
	if own: sc.on_hide(); sc.queue_free()
	DB.lang = "zh"
	_p("shots done")
