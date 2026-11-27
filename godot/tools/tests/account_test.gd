# [account] 帳號＋雲端存檔專項測試（Mock 後端）
#   logic：註冊、格式檢查、未驗證、錯密碼、登入、舊進度綁定（遷移）、上傳、下載、衝突、離線、token 過期、登出備份接回、換帳號、登入門
#   ui：登入門（標題前出登入面板）→ 註冊 → 驗證 → 登入 → 標題畫面＋帳號標籤；設置「存檔」頁帳號區；衝突對話框；截圖
#   wide：1920×1080 截圖（登入、註冊、設置帳號區、衝突）
# 跑法：bash /home/claude/setup/acct_edtest.sh <godotdir> acct res://tools/tests/account_test.gd logic 600 [450x975|1920x1080]
extends RefCounted
const SHOTS := "/tmp/account_shots/"
const ACC = preload("res://game/account/acct.gd")
const MK = preload("res://game/account/svc_mock.gd")
var ok := 0
var bad := 0
func _p(m): print("[acct] ", m)
func _ck(c: bool, msg: String) -> void:
	if c: ok += 1
	else: bad += 1; _p("BAD " + msg)
func _w(t, s: float): await t.get_tree().create_timer(s).timeout
func _main(t): return t.get_tree().root.get_node_or_null("Main")
func _shot(t, name: String):
	await RenderingServer.frame_post_draw
	t.get_viewport().get_texture().get_image().save_png(SHOTS + name + ".png"); _p("shot " + name)
func _done() -> void: _p("RESULT ok=%d bad=%d" % [ok, bad])

func _boot(t):
	var m = null
	for i in 160:
		await _w(t, 0.5)
		m = _main(t)
		if m and m.get("loading") == null and m.get("title_ov") != null: break
	await _w(t, 1.0)
	return m

func _reset() -> void:
	MK.mock_reset()
	if FileAccess.file_exists(ACC.FILE): DirAccess.remove_absolute(ProjectSettings.globalize_path(ACC.FILE))
	ACC._loaded = false; ACC.email = ""; ACC.uid = ""; ACC.token = ""; ACC.rtoken = ""; ACC.synced_ts = -1; ACC.rev = -1; ACC.last_sync = 0

func _mk_save(lv: int, ts: int, name := "阿福") -> String:
	var o = G.new_state(); o.lv = lv; o.last = ts; o.hero.name = name
	return JSON.stringify(o)

func _set_local(d: String) -> void:
	if d == "": JSRun.ls.erase(ACC.SAVE_KEY)
	else: JSRun.ls[ACC.SAVE_KEY] = d

func _cloud(uid: String) -> Dictionary:
	var db = MK._db(); return db.saves.get(uid, {})

func logic(t) -> void:
	await _boot(t)
	_reset()
	var keep = JSRun.ls.get(ACC.SAVE_KEY)
	# 登入門
	ACC.force_gate = true
	_ck(ACC.gate_needed(), "未登入冇彈登入門")
	# 格式檢查
	var r = await ACC.sign_up("abc", "12345678"); _ck(not r.ok and r.err == "bad_email", "壞郵箱冇擋")
	r = await ACC.sign_up("a@ghost.my", "123"); _ck(not r.ok and r.err == "weak_pw", "短密碼冇擋")
	# 舊玩家：本機已有 12 級進度
	var old = _mk_save(12, 1000)
	_set_local(old)
	r = await ACC.sign_up(" A@Ghost.my ", "12345678"); _ck(r.ok and bool(r.need_verify), "註冊冇要求驗證")
	_ck(not ACC.logged_in(), "未驗證就當登入咗")
	r = await ACC.sign_up("a@ghost.my", "abcdefgh"); _ck(not r.ok and r.err == "exists", "重複註冊冇擋")
	r = await ACC.sign_in("a@ghost.my", "12345678"); _ck(not r.ok and r.err == "unverified", "未驗證都登入到")
	MK.mock_verify("a@ghost.my")
	r = await ACC.sign_in("a@ghost.my", "wrongpass"); _ck(not r.ok and r.err == "bad_login", "錯密碼都登入到")
	r = await ACC.sign_in("a@ghost.my", "12345678"); _ck(r.ok and ACC.logged_in() and ACC.email == "a@ghost.my", "登入失敗 %s" % r)
	_ck(not ACC.gate_needed(), "登入咗仲彈登入門")
	var uid1 = ACC.uid
	# 遷移：本機有、雲端冇 → 上傳綁定
	r = await ACC.sync(); _ck(r.state == "uploaded", "舊進度冇綁定上傳 %s" % r.state)
	_ck(str(_cloud(uid1).get("data", "")) == old, "雲端內容唔等於本機舊進度")
	_ck(JSRun.ls.get(ACC.SAVE_KEY) == old, "綁定時本機進度被改")
	r = await ACC.sync(); _ck(r.state == "same", "再同步唔係 same：%s" % r.state)
	# 本機玩咗 → 上傳
	var l2 = _mk_save(13, 2000); _set_local(l2)
	r = await ACC.sync(); _ck(r.state == "uploaded" and int(_cloud(uid1).rev) == 2, "本機改咗冇上傳 %s" % r.state)
	# 另一部機改咗雲端、本機冇改 → 下載
	var c3 = _mk_save(15, 3000); MK.mock_cloud_write(uid1, c3, 3000)
	r = await ACC.sync(); _ck(r.state == "download" and str(r.data) == c3, "雲端較新冇提示下載 %s" % r.state)
	_set_local(str(r.data)); ACC._mark(ACC.data_ts(str(r.data)), int(r.rev))   # 模擬 apply_cloud（唔重載）
	r = await ACC.sync(); _ck(r.state == "same", "下載後唔係 same：%s" % r.state)
	# 兩邊都改 → 衝突；揀本機 → 強制覆蓋
	_set_local(_mk_save(16, 4000)); MK.mock_cloud_write(uid1, _mk_save(17, 4100), 4100)
	r = await ACC.sync(); _ck(r.state == "conflict", "兩邊都改冇衝突：%s" % r.state)
	_ck(int(r.local.lv) == 16 and int(r.cloud.lv) == 17, "衝突摘要等級錯 %s %s" % [r.get("local"), r.get("cloud")])
	r = await ACC.keep_local(); _ck(r.state == "uploaded" and ACC.summary(str(_cloud(uid1).data)).lv == 16, "揀本機冇覆蓋雲端")
	# 離線：照玩，連返先上傳
	MK.offline = true
	_set_local(_mk_save(18, 5000))
	r = await ACC.sync(); _ck(r.state == "offline", "離線狀態錯：%s" % r.state)
	_ck(ACC.summary(str(JSRun.ls.get(ACC.SAVE_KEY))).lv == 18, "離線時本機進度唔見咗")
	MK.offline = false
	r = await ACC.sync(); _ck(r.state == "uploaded" and ACC.summary(str(_cloud(uid1).data)).lv == 18, "連返網冇補上傳 %s" % r.state)
	# token 過期 → 自動 refresh
	var db = MK._db(); db.tokens.erase(ACC.token); db.tokens["rt_x"] = uid1; MK._put(db); ACC.rtoken = "rt_x"
	r = await ACC.sync(); _ck(r.state == "same" and ACC.token != "", "token 過期冇自動續期：%s" % r.state)
	# 登出：先上傳、本機清走並按帳號備份；再登入同一帳號接返
	_set_local(_mk_save(19, 6000))
	r = await ACC.sign_out(); _ck(r.ok and bool(r.synced), "登出冇先同步")
	_ck(not ACC.logged_in() and not JSRun.ls.has(ACC.SAVE_KEY) and JSRun.ls.has(ACC.BAK + uid1), "登出後本機冇清／冇備份")
	_ck(ACC.summary(str(_cloud(uid1).data)).lv == 19, "登出前冇上傳最新")
	_ck(ACC.gate_needed(), "登出後冇彈登入門")
	# 換帳號：新帳號冇進度 → none
	MK.auto_verify = true
	r = await ACC.sign_up("b@ghost.my", "bbbbbbbb"); _ck(r.ok and ACC.logged_in() and ACC.uid != uid1, "第二個帳號註冊即登入失敗")
	r = await ACC.sync(); _ck(r.state == "none" and not JSRun.ls.has(ACC.SAVE_KEY), "新帳號唔係空進度：%s" % r.state)
	await ACC.sign_out()
	# 登入返第一個帳號：本機接返登出前備份 → same
	r = await ACC.sign_in("a@ghost.my", "12345678"); _ck(r.ok, "再登入失敗")
	_ck(ACC.summary(str(JSRun.ls.get(ACC.SAVE_KEY, ""))).lv == 19 and not JSRun.ls.has(ACC.BAK + uid1), "登入同一帳號冇接返本機備份")
	r = await ACC.sync(); _ck(r.state in ["same", "conflict"], "接返後同步狀態異常：%s" % r.state)
	# 新裝置：本機冇、雲端有 → 下載
	_set_local(""); ACC.synced_ts = -1; ACC.rev = -1
	r = await ACC.sync(); _ck(r.state == "download" and ACC.summary(str(r.data)).lv == 19, "新裝置冇下載雲端進度：%s" % r.state)
	# 錯誤訊息全部中文
	for e in ["offline", "bad_login", "exists", "unverified", "weak_pw", "bad_email", "mismatch", "rate", "expired", "conflict", "server"]:
		var s = ACC.msg(e); _ck(s != "" and not s.contains(e), "錯誤訊息未翻譯 " + e)
	# 遊戲中自動同步節點
	var sn = _main(t).get_node_or_null("AcctSync"); _ck(sn != null, "冇自動同步節點")
	if keep != null: JSRun.ls[ACC.SAVE_KEY] = keep
	else: JSRun.ls.erase(ACC.SAVE_KEY)
	ACC.force_gate = false
	_reset()
	_done()

# 注入「本機進度」：ls 同記憶體 S 一齊換（標題畫面切出去時 Main 會 G.save()，唔換 S 會用開機嘅空進度蓋返）
func _inject(d: String) -> void:
	JSRun.ls[ACC.SAVE_KEY] = d; J.G["S"] = JSON.parse_string(d)

func _press(n: Node) -> void:
	(n as BaseButton).pressed.emit()

func _find(root: Node, nm: String) -> Node: return root.find_child(nm, true, false)

func _in_view(t, c: Control, what: String) -> void:
	var vr = Rect2(Vector2.ZERO, t.get_viewport().get_visible_rect().size)
	_ck(c != null and vr.grow(1).encloses(c.get_global_rect()), "%s 出畫面 %s" % [what, c.get_global_rect() if c else null])

func ui(t) -> void:
	await _flow(t, "")

func wide(t) -> void:
	await _flow(t, "wide_")

func _flow(t, pre: String) -> void:
	DirAccess.make_dir_recursive_absolute(SHOTS)
	var m = await _boot(t)
	var lp = m.get("title_ov")
	_ck(lp != null and lp.name == "LoginPanel", "開機冇先出登入面板（%s）" % (lp.name if lp else "null"))
	if lp == null or lp.name != "LoginPanel": _done(); return
	_ck(m.get_node_or_null("Title") == null, "未登入已經出咗標題畫面")
	await _w(t, 0.6)
	_in_view(t, lp.get_node("Win"), "登入面板")
	await _shot(t, pre + "login")
	# 錯誤提示
	lp.f_email.text = "nobody@ghost.my"; lp.f_pw.text = "12345678"; _press(lp.btn_main); await _w(t, 0.5)
	_ck(lp._err.visible and lp._err.text == ACC.msg("bad_login"), "錯密碼冇提示（%s）" % lp._err.text)
	await _shot(t, pre + "login_error")
	# 舊玩家：本機有進度 → 註冊頁有綁定提示
	_inject(_mk_save(12, 1000, "阿福"))
	_press(_find(lp, "LinkRegister")); await _w(t, 0.4)
	_ck(lp.mode == "register" and _find(lp, "LocalNote") != null, "註冊頁冇顯示舊進度綁定提示")
	lp.f_email.text = "boss@ghost.my"; lp.f_pw.text = "12345678"; lp.f_pw2.text = "12345679"; _press(lp.btn_main); await _w(t, 0.4)
	_ck(lp._err.text == ACC.msg("mismatch"), "兩次密碼唔同冇提示")
	lp.f_pw2.text = "12345678"
	await _shot(t, pre + "register")
	_press(lp.btn_main); await _w(t, 0.6)
	_ck(lp.mode == "verify", "註冊後冇入驗證頁")
	_in_view(t, lp.get_node("Win"), "驗證頁")
	await _shot(t, pre + "verify")
	_press(lp.btn_main); await _w(t, 0.6)
	_ck(lp._err.text == ACC.msg("unverified"), "未驗證按登入冇提示")
	_press(_find(lp, "BtnMockVerify")); await _w(t, 0.3)
	_press(lp.btn_main)
	var tv = null
	for i in 20:
		await _w(t, 0.4); tv = m.get("title_ov")
		if tv != null and tv.name == "Title": break
	_ck(tv != null and tv.name == "Title", "登入後冇出標題畫面")
	_ck(ACC.logged_in() and ACC.email == "boss@ghost.my", "登入狀態錯")
	_ck(ACC.summary(str(_cloud(ACC.uid).get("data", ""))).lv == 12, "舊進度冇綁定上帳號 cloud=%s local=%s" % [ACC.summary(str(_cloud(ACC.uid).get("data", ""))), ACC.summary(str(JSRun.ls.get(ACC.SAVE_KEY, "")))])
	if tv == null: _done(); return
	await _w(t, 2.2)
	var al = _find(tv, "AcctLabel"); _ck(al != null and str(al.text).contains("b***@ghost.my"), "標題畫面冇帳號標籤")
	_in_view(t, al, "帳號標籤")
	await _shot(t, pre + "title_logged_in")
	# 設置 → 存檔頁帳號區
	_press(al); await _w(t, 0.7)
	var sp = m.get_node_or_null("SettingsPanel"); _ck(sp != null and sp.tab == 3, "點帳號標籤冇開設置存檔頁")
	if sp:
		for n in ["AcctEmail", "AcctSync", "AcctLogout", "AcctSwitch"]: _ck(_find(sp, n) != null, "設置帳號區缺 " + n)
		_press(_find(sp, "AcctSync")); await _w(t, 0.6)
		_ck(sp._toast.visible and sp._toast.text in ["進度已經是最新。", "已上傳到帳號。"], "立即同步冇提示（%s）" % sp._toast.text)
		await _shot(t, pre + "settings_account")
		# 衝突對話框
		_inject(_mk_save(14, 5000, "阿福")); MK.mock_cloud_write(ACC.uid, _mk_save(20, 6000, "阿福"), 6000)
		_press(_find(sp, "AcctSync")); await _w(t, 0.7)
		var sd = _find(sp, "SyncDialog"); _ck(sd != null, "兩邊都改冇出衝突對話框")
		if sd:
			_in_view(t, sd.get_node("Win"), "衝突對話框")
			await _shot(t, pre + "conflict")
			_press(sd.btn_local); await _w(t, 0.6)
			_ck(ACC.summary(str(_cloud(ACC.uid).data)).lv == 14 and JSRun.ls.has(ACC.SAVE_KEY + "_cloudbak"), "揀本機冇覆蓋雲端／冇留雲端備份")
		sp.close(); await _w(t, 0.3)
	# 忘記密碼頁（截圖用）：開一個獨立面板
	var lp2 = load("res://ui/account/login_panel.gd").new(); lp2.host = m; m.add_child(lp2); await _w(t, 0.3)
	lp2.show_mode("forgot"); await _w(t, 0.3)
	lp2.f_email.text = "boss@ghost.my"; _press(lp2.btn_main); await _w(t, 0.4)
	await _shot(t, pre + "forgot"); lp2.queue_free()
	_reset()
	_done()
