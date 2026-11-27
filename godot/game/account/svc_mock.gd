# [account] 本機模擬後端（開發／測試用；正式版換 svc_supabase.gd）
# 「伺服器」資料存 user://acct_mock_server.json：帳號（密碼只存雜湊）、驗證狀態、雲端存檔（data／ts／rev）
# 所有方法都係協程（await），回傳 {ok: bool, err: 錯誤代碼, ...}，同真後端一樣用法
extends RefCounted

const FILE := "user://acct_mock_server.json"
static var offline := false      # 測試用：模擬冇網
static var auto_verify := false  # 測試用：註冊即當已驗證

static func _db() -> Dictionary:
	if FileAccess.file_exists(FILE):
		var o = JSON.parse_string(FileAccess.get_file_as_string(FILE))
		if o is Dictionary: return o
	return {"users": {}, "saves": {}, "tokens": {}}

static func _put(d: Dictionary) -> void:
	var f = FileAccess.open(FILE, FileAccess.WRITE)
	if f: f.store_string(JSON.stringify(d)); f.close()

static func _hash(email: String, pw: String) -> String: return ("gb|" + email + "|" + pw).sha256_text()

func _tick() -> void:
	var ml = Engine.get_main_loop()
	if ml is SceneTree: await (ml as SceneTree).process_frame

func _off() -> bool: return offline

func _tok(d: Dictionary, uid: String) -> String:
	var t = ("%s|%d|%d" % [uid, Time.get_ticks_usec(), randi()]).sha256_text()
	d.tokens[t] = uid; return t

func sign_up(email: String, pw: String) -> Dictionary:
	await _tick()
	if _off(): return {"ok": false, "err": "offline"}
	var d = _db()
	if d.users.has(email): return {"ok": false, "err": "exists"}
	var uid = ("u|" + email + "|" + str(Time.get_unix_time_from_system())).md5_text().substr(0, 16)
	d.users[email] = {"uid": uid, "pw": _hash(email, pw), "verified": auto_verify}
	if auto_verify:
		var t = _tok(d, uid); _put(d)
		return {"ok": true, "need_verify": false, "uid": uid, "token": t, "refresh": t}
	_put(d)
	return {"ok": true, "need_verify": true, "uid": uid}

func sign_in(email: String, pw: String) -> Dictionary:
	await _tick()
	if _off(): return {"ok": false, "err": "offline"}
	var d = _db()
	var u = d.users.get(email)
	if u == null or str(u.pw) != _hash(email, pw): return {"ok": false, "err": "bad_login"}
	if not bool(u.verified): return {"ok": false, "err": "unverified"}
	var t = _tok(d, str(u.uid)); _put(d)
	return {"ok": true, "uid": str(u.uid), "token": t, "refresh": t}

func refresh(rt: String) -> Dictionary:
	await _tick()
	if _off(): return {"ok": false, "err": "offline"}
	var d = _db()
	if not d.tokens.has(rt): return {"ok": false, "err": "expired"}
	var uid = str(d.tokens[rt]); var t = _tok(d, uid); _put(d)
	return {"ok": true, "uid": uid, "token": t, "refresh": t}

func recover(email: String) -> Dictionary:
	await _tick()
	if _off(): return {"ok": false, "err": "offline"}
	return {"ok": true}   # 真後端：寄重設密碼郵件；為免被人試郵箱，冇呢個帳號都答 ok

func resend(email: String, _pw := "") -> Dictionary:
	await _tick()
	if _off(): return {"ok": false, "err": "offline"}
	return {"ok": true}

func sign_out(_token: String) -> Dictionary:
	await _tick()
	return {"ok": true}

func load_save(uid: String, token: String) -> Dictionary:
	full_calls += 1
	await _tick()
	if _off(): return {"ok": false, "err": "offline"}
	var d = _db()
	if str(d.tokens.get(token, "")) != uid: return {"ok": false, "err": "expired"}
	var s = d.saves.get(uid)
	if s == null: return {"ok": true, "data": "", "ts": 0, "rev": 0}
	return {"ok": true, "data": str(s.data), "ts": int(s.ts), "rev": int(s.rev)}

# [cost] 只回 rev／ts／有冇存檔（真後端只傳幾十 bytes）
static var meta_calls := 0
static var full_calls := 0
func load_meta(uid: String, token: String) -> Dictionary:
	meta_calls += 1
	var r = await load_save(uid, token); full_calls -= 1
	if r.ok: r["has"] = str(r.data) != ""; r.erase("data")
	return r

# base_rev：上次見到嘅雲端版本；雲端已經被其他機改過（rev 唔同）就拒絕（conflict），除非 force
func store_save(uid: String, token: String, data: String, ts: int, base_rev: int, force := false) -> Dictionary:
	await _tick()
	if _off(): return {"ok": false, "err": "offline"}
	var d = _db()
	if str(d.tokens.get(token, "")) != uid: return {"ok": false, "err": "expired"}
	var s = d.saves.get(uid, {"rev": 0})
	if not force and int(s.rev) != base_rev: return {"ok": false, "err": "conflict", "rev": int(s.rev)}
	var nr = int(s.rev) + 1
	d.saves[uid] = {"data": data, "ts": ts, "rev": nr}; _put(d)
	return {"ok": true, "rev": nr}

# ---- 測試／模擬工具 ----
static func mock_verify(email: String) -> void:
	var d = _db()
	if d.users.has(email): d.users[email].verified = true; _put(d)

# 模擬「另一部手機」改咗雲端存檔
static func mock_cloud_write(uid: String, data: String, ts: int) -> void:
	var d = _db(); var s = d.saves.get(uid, {"rev": 0})
	d.saves[uid] = {"data": data, "ts": ts, "rev": int(s.rev) + 1}; _put(d)

static func mock_reset() -> void:
	if FileAccess.file_exists(FILE): DirAccess.remove_absolute(ProjectSettings.globalize_path(FILE))
	offline = false; auto_verify = false; meta_calls = 0; full_calls = 0
