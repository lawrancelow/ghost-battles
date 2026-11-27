# [account] 帳號＋雲端存檔管理（熱更新：冇 class_name；const ACC = preload("res://game/account/acct.gd")）
#   登入狀態存 user://account.json（裝置設定，唔跟存檔碼走）
#   存檔本體照舊喺 JSRun.ls[SAVE_KEY]；雲端存一份完整字串＋ts（存檔 last）＋rev（雲端版本號，樂觀鎖）
#   同步規則：
#     本機有改、雲端冇改 → 上傳；雲端有改（例如另一部手機）、本機冇改 → 下載；兩邊都改 → 衝突，玩家揀
#     第一次登入（綁定）：本機有、雲端冇 → 上傳（舊玩家遷移，唔會丟進度）；本機冇、雲端有 → 下載；兩邊都有又唔同 → 揀
#     冇網：照玩，記住未上傳，下次連到再同步
extends RefCounted

const AC = preload("res://game/account/acct_cfg.gd")
const FILE := "user://account.json"
const SAVE_KEY := "ghostBattles_v1"
const BAK := "acct_bak_"          # 登出時本機進度備份（按帳號），同一帳號再登入會接返

static var email := ""
static var uid := ""
static var token := ""
static var rtoken := ""
static var last_sync := 0          # 上次成功同步（unix 秒）
static var synced_ts := -1         # 上次同步時本機存檔嘅 last（-1＝未綁定）
static var rev := -1               # 上次見到嘅雲端 rev（-1＝未綁定）
static var force_gate := false     # 測試用：GB_TEST 下都要登入
static var guest := false          # [guest] 揀咗「先以遊客身分遊玩」（未綁定帳號，進度只喺本機）
static var allow_guest_test := -1  # 測試用：-1 跟 AC.ALLOW_GUEST；0／1 強制
static var _loaded := false
static var _svc = null

# ---------------- 後端 ----------------
static func svc():
	if _svc == null:
		var p = {"supabase": "res://game/account/svc_supabase.gd", "firebase": "res://game/account/svc_firebase.gd", "nakama": "res://game/account/svc_nakama.gd"}.get(AC.BACKEND, "res://game/account/svc_mock.gd")
		_svc = load(p).new()
	return _svc
static func is_mock() -> bool: return not (AC.BACKEND in ["supabase", "firebase", "nakama"])

# ---------------- 登入狀態 ----------------
static func load_state() -> void:
	if _loaded: return
	_loaded = true
	if not FileAccess.file_exists(FILE): return
	var o = JSON.parse_string(FileAccess.get_file_as_string(FILE))
	if not (o is Dictionary): return
	email = str(o.get("email", "")); uid = str(o.get("uid", "")); token = str(o.get("token", "")); rtoken = str(o.get("refresh", ""))
	last_sync = int(o.get("last_sync", 0)); synced_ts = int(o.get("synced_ts", -1)); rev = int(o.get("rev", -1))
	guest = bool(o.get("guest", false))

static func save_state() -> void:
	var f = FileAccess.open(FILE, FileAccess.WRITE)
	if f:
		f.store_string(JSON.stringify({"email": email, "uid": uid, "token": token, "refresh": rtoken, "last_sync": last_sync, "synced_ts": synced_ts, "rev": rev, "guest": guest}))
		f.close()

static func logged_in() -> bool: load_state(); return uid != "" and token != ""

# [guest] 遊客：冇網或者唔想註冊都可以直接玩；進度照存本機。之後綁定帳號＝登入／註冊，第一次同步會將本機進度上傳（同舊玩家遷移一樣）
static func allow_guest() -> bool: return AC.ALLOW_GUEST if allow_guest_test < 0 else allow_guest_test == 1
static func is_guest() -> bool: load_state(); return guest and not logged_in()
static func play_as_guest() -> void:
	load_state(); guest = true; save_state()

# 要唔要喺標題畫面前彈登入：自動測試／自檢唔彈（除非測試自己要）
static func gate_needed() -> bool:
	load_state()
	if not AC.REQUIRE_LOGIN or logged_in(): return false
	if guest and allow_guest(): return false   # [guest] 遊客唔再彈；ALLOW_GUEST 改 false 就照彈（強制登入）
	if force_gate or OS.get_environment("GB_ACCT_GATE") == "1": return true
	if OS.get_environment("GB_TEST") != "" or OS.get_environment("GB_SELFTEST") != "": return false
	var st = Engine.get_main_loop().root.get_node_or_null("SelfTestHost") if Engine.get_main_loop() is SceneTree else null
	return st == null

static func masked() -> String:
	var i = email.find("@")
	if i <= 1: return email
	return email.substr(0, 1) + "***" + email.substr(i)

static func ok_email(e: String) -> bool:
	var r = RegEx.new(); r.compile("^[^@\\s]+@[^@\\s]+\\.[^@\\s]{2,}$")
	return r.search(e) != null

# 錯誤代碼 → 中文
static func msg(err: String) -> String:
	match err:
		"offline": return "連不上伺服器，檢查一下網絡再試。"
		"bad_login": return "郵箱或密碼不對。"
		"exists": return "這個郵箱已經註冊過了，直接登入就可以。"
		"unverified": return "這個郵箱還沒驗證。打開驗證郵件點連結，再回來登入。"
		"weak_pw": return "密碼太簡單，至少 %d 個字元。" % AC.MIN_PW
		"bad_email": return "郵箱格式不對。"
		"mismatch": return "兩次輸入的密碼不一樣。"
		"rate": return "太頻密了，等一分鐘再試。"
		"expired": return "登入已過期，請重新登入。"
		"conflict": return "雲端進度剛被另一部裝置更新了。"
	return "伺服器出了點問題，稍後再試。"

# ---------------- 帳號操作（協程） ----------------
static func sign_up(e: String, pw: String) -> Dictionary:
	e = e.strip_edges().to_lower()
	if not ok_email(e): return {"ok": false, "err": "bad_email"}
	if pw.length() < AC.MIN_PW: return {"ok": false, "err": "weak_pw"}
	var r: Dictionary = await svc().sign_up(e, pw)
	if r.ok and not bool(r.get("need_verify", false)): _set_session(e, r)
	return r

static func sign_in(e: String, pw: String) -> Dictionary:
	e = e.strip_edges().to_lower()
	if not ok_email(e): return {"ok": false, "err": "bad_email"}
	var r: Dictionary = await svc().sign_in(e, pw)
	if r.ok: _set_session(e, r)
	return r

static func recover(e: String) -> Dictionary:
	e = e.strip_edges().to_lower()
	if not ok_email(e): return {"ok": false, "err": "bad_email"}
	return await svc().recover(e)

static func resend(e: String, pw := "") -> Dictionary: return await svc().resend(e.strip_edges().to_lower(), pw)

static func _set_session(e: String, r: Dictionary) -> void:
	load_state()
	var same = e == email and str(r.uid) == uid
	email = e; uid = str(r.uid); token = str(r.token); rtoken = str(r.get("refresh", ""))
	guest = false   # [guest] 綁定咗帳號就唔再係遊客
	if not same: synced_ts = -1; rev = -1   # 新帳號／換帳號：當第一次綁定
	# 之前登出過同一帳號、本機冇存檔：接返登出前嘅本機進度
	if _ls() is Dictionary and not _ls().has(SAVE_KEY) and _ls().has(BAK + uid):
		_ls()[SAVE_KEY] = _ls()[BAK + uid]; _ls().erase(BAK + uid); _flush()
	save_state()

# 登出：先盡量上傳；本機進度按帳號備份後清走（下一個人登入唔會撈亂），重新載入
static func sign_out() -> Dictionary:
	load_state()
	var r = await sync()
	var st = str(r.get("state", ""))
	if logged_in() and _ls() is Dictionary and _ls().has(SAVE_KEY):
		_ls()[BAK + uid] = _ls()[SAVE_KEY]; _ls().erase(SAVE_KEY); _flush()
	await svc().sign_out(token)
	email = ""; uid = ""; token = ""; rtoken = ""; synced_ts = -1; rev = -1; last_sync = 0
	save_state()
	return {"ok": true, "synced": st in ["same", "uploaded", "none"]}

# ---------------- 存檔 ----------------
static func _ls():
	var j = Engine.get_main_loop().root.get_node_or_null("JSRun") if Engine.get_main_loop() is SceneTree else null
	return j.get("ls") if j != null else null
static func _flush() -> void:
	var j = Engine.get_main_loop().root.get_node_or_null("JSRun")
	if j != null and j.has_method("flush_ls"): j.call("flush_ls")

static func local_data() -> String:
	# 只喺真係玩緊（標題畫面已收、唔係載入中）先將記憶體進度寫落 ls；標題畫面／新機未開局唔好寫，否則會當咗一份 1 級空進度
	var g = Engine.get_main_loop().root.get_node_or_null("G")
	var m = Engine.get_main_loop().root.get_node_or_null("Main")
	var playing = m != null and m.get("title_ov") == null and m.get("loading") == null
	if playing and g != null and g.get("S") is Dictionary and not (g.get("S") as Dictionary).is_empty(): g.call("save")
	var ls = _ls()
	return str(ls.get(SAVE_KEY, "")) if ls is Dictionary else ""

static func data_ts(d: String) -> int:
	if d == "": return 0
	var o = JSON.parse_string(d)
	return int(float(o.get("last", 0))) if o is Dictionary else 0

# 存檔摘要（衝突對話框用）
static func summary(d: String) -> Dictionary:
	var o = JSON.parse_string(d) if d != "" else null
	if not (o is Dictionary): return {"lv": 0, "name": "", "ts": 0}
	var h = o.get("hero", {})
	return {"lv": int(float(o.get("lv", 1))), "name": str(h.get("name", "")) if h is Dictionary else "", "ts": int(float(o.get("last", 0))), "ghosts": (o.get("ghosts", []) as Array).size() if o.get("ghosts") is Array else 0}

static func _mark(local_ts: int, crev: int) -> void:
	synced_ts = local_ts; rev = crev; last_sync = int(Time.get_unix_time_from_system()); save_state()

# token 過期自動 refresh 一次
static func _call(m: String, args: Array) -> Dictionary:
	var r: Dictionary = await _do(m, args)
	if not r.ok and str(r.err) == "expired" and rtoken != "":
		var f: Dictionary = await svc().refresh(rtoken)
		if f.ok:
			token = str(f.token); rtoken = str(f.get("refresh", rtoken)); save_state()
			r = await _do(m, args)
		else: return {"ok": false, "err": "expired"}
	return r

static func _do(m: String, a: Array) -> Dictionary:
	if m == "load_meta":
		# [cost] 只讀 rev／ts（唔落成份存檔）：後端有 load_meta 就用，冇就退返 load_save
		if svc().has_method("load_meta"): return await svc().load_meta(uid, token)
		var f: Dictionary = await svc().load_save(uid, token)
		if f.ok: f["has"] = str(f.get("data", "")) != ""; f.erase("data")
		return f
	if m == "load_save":
		var l: Dictionary = await svc().load_save(uid, token)
		if l.ok: l["data"] = unpack(str(l.get("data", "")))
		return l
	return await svc().store_save(uid, token, pack(str(a[0])), int(a[1]), int(a[2]), bool(a[3]))

# [cost] 雲端存檔壓縮：gzip＋base64，前綴 z1:（約細 7–10 倍，慳流量同儲存）；舊（冇前綴）照讀
const PACK := "z1:"
static func pack(d: String) -> String:
	if d == "": return ""
	return PACK + Marshalls.raw_to_base64(d.to_utf8_buffer().compress(FileAccess.COMPRESSION_GZIP))
static func unpack(s: String) -> String:
	if not s.begins_with(PACK): return s
	var raw = Marshalls.base64_to_raw(s.substr(PACK.length()))
	var out = raw.decompress_dynamic(-1, FileAccess.COMPRESSION_GZIP)
	return out.get_string_from_utf8()

# 同步：回傳 {state: none/same/uploaded/download/conflict/offline/expired/logout/…, data, rev, local, cloud}
static func sync() -> Dictionary:
	load_state()
	if not logged_in(): return {"state": "logout"}
	# [cost] 先只讀 rev／ts；淨係真係要比較內容（第一次綁定）、下載、衝突先落成份存檔
	var mt: Dictionary = await _call("load_meta", [])
	if not mt.ok: return {"state": str(mt.err)}
	var loc = local_data(); var lts = data_ts(loc)
	var crev = int(mt.get("rev", 0)); var has_cloud = bool(mt.get("has", crev > 0))
	if loc == "" and not has_cloud: _mark(0, crev); return {"state": "none"}
	if not has_cloud: return await _upload(loc, lts, crev, false)
	var first = rev < 0 or synced_ts < 0
	var loc_changed = lts != synced_ts
	var cloud_changed = crev != rev
	if loc != "" and not first:
		if not loc_changed and not cloud_changed: _mark(lts, crev); return {"state": "same"}
		if loc_changed and not cloud_changed: return await _upload(loc, lts, crev, false)
	var l: Dictionary = await _call("load_save", [])
	if not l.ok: return {"state": str(l.err)}
	var cd = str(l.data); crev = int(l.rev)
	if cd == "": return await _upload(loc, lts, crev, false)
	if loc == "": return {"state": "download", "data": cd, "rev": crev}
	if loc == cd: _mark(lts, crev); return {"state": "same"}
	if not first and cloud_changed and not loc_changed: return {"state": "download", "data": cd, "rev": crev}
	return {"state": "conflict", "data": cd, "rev": crev, "local": summary(loc), "cloud": summary(cd)}

static func _upload(loc: String, lts: int, base: int, force: bool) -> Dictionary:
	var u: Dictionary = await _call("store_save", [loc, lts, base, force])
	if u.ok: _mark(lts, int(u.rev)); return {"state": "uploaded"}
	if str(u.err) == "conflict": return {"state": "conflict_late"}
	return {"state": str(u.err)}

# 衝突時揀「用這部裝置的進度」：強制覆蓋雲端
static func keep_local() -> Dictionary:
	var loc = local_data()
	return await _upload(loc, data_ts(loc), rev, true)

# 揀「用雲端進度」／需要下載：本機舊進度留一份 _bak，然後重新載入
static func apply_cloud(data: String, crev: int) -> void:
	var ls = _ls()
	if not (ls is Dictionary): return
	if ls.has(SAVE_KEY): ls[SAVE_KEY + "_bak"] = ls[SAVE_KEY]
	ls[SAVE_KEY] = data; _flush()
	_mark(data_ts(data), crev)
	var j = Engine.get_main_loop().root.get_node_or_null("JSRun")
	if j != null:
		j.set("skip_title", false)
		if j.has_method("reset_world"): j.call("reset_world")
	Engine.get_main_loop().call_deferred("reload_current_scene")

static func last_sync_text() -> String:
	load_state()
	if last_sync <= 0: return "還沒同步"
	var d = int(Time.get_unix_time_from_system()) - last_sync
	if d < 60: return "剛剛"
	if d < 3600: return "%d 分鐘前" % (d / 60)
	if d < 86400: return "%d 小時前" % (d / 3600)
	var t = Time.get_datetime_dict_from_unix_time(last_sync + 8 * 3600)
	return "%d/%d %02d:%02d" % [t.month, t.day, t.hour, t.minute]
