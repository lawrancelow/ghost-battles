# [account] Supabase 後端（REST，唔使插件）：Auth（郵箱＋密碼、驗證郵件、忘記密碼）＋ saves 資料表（RLS 只准讀寫自己）
# 用法同 svc_mock.gd 一樣：協程，回傳 {ok, err, ...}
# 資料表 SQL 見專案文件 claude/HC_GhostBattles_Account_Plan_20261127.md
extends RefCounted

const AC = preload("res://game/account/acct_cfg.gd")
const TIMEOUT := 15.0

func _root() -> Node:
	var ml = Engine.get_main_loop()
	return (ml as SceneTree).root if ml is SceneTree else null

# 回傳 {code: HTTP 狀態（0＝連唔到）, body: 解析後 JSON 或 null}
func _req(method: int, path: String, body = null, token := "", extra: PackedStringArray = PackedStringArray()) -> Dictionary:
	var r = _root()
	if r == null or AC.SUPA_URL == "": return {"code": 0, "body": null}
	var h = HTTPRequest.new(); h.timeout = TIMEOUT; r.add_child(h)
	var hd = PackedStringArray(["apikey: " + AC.SUPA_KEY, "Content-Type: application/json", "Authorization: Bearer " + (token if token != "" else AC.SUPA_KEY)])
	hd.append_array(extra)
	var e = h.request(AC.SUPA_URL.trim_suffix("/") + path, hd, method, "" if body == null else JSON.stringify(body))
	if e != OK: h.queue_free(); return {"code": 0, "body": null}
	var res = await h.request_completed
	h.queue_free()
	if int(res[0]) != HTTPRequest.RESULT_SUCCESS: return {"code": 0, "body": null}
	var txt = (res[3] as PackedByteArray).get_string_from_utf8()
	return {"code": int(res[1]), "body": JSON.parse_string(txt) if txt != "" else null}

# Supabase 錯誤 → 遊戲錯誤代碼（帳號面板再轉中文）
func _err(r: Dictionary) -> String:
	if int(r.code) == 0: return "offline"
	var b = r.body if r.body is Dictionary else {}
	var c = str(b.get("error_code", b.get("code", ""))); var m = str(b.get("msg", b.get("error_description", b.get("message", "")))).to_lower()
	if c in ["user_already_exists", "email_exists"] or "already registered" in m: return "exists"
	if c == "email_not_confirmed" or "not confirmed" in m: return "unverified"
	if c == "invalid_credentials" or "invalid login" in m: return "bad_login"
	if c == "weak_password" or "password" in m and "least" in m: return "weak_pw"
	if c in ["email_address_invalid", "validation_failed"] or "invalid" in m and "email" in m: return "bad_email"
	if c == "over_email_send_rate_limit" or int(r.code) == 429: return "rate"
	if int(r.code) == 401 or "jwt" in m: return "expired"
	return "server"

func _sess(b: Dictionary) -> Dictionary:
	var u = b.get("user", {})
	return {"ok": true, "uid": str(u.get("id", "")), "token": str(b.get("access_token", "")), "refresh": str(b.get("refresh_token", ""))}

func sign_up(email: String, pw: String) -> Dictionary:
	var r = await _req(HTTPClient.METHOD_POST, "/auth/v1/signup", {"email": email, "password": pw})
	if int(r.code) != 200 or not (r.body is Dictionary): return {"ok": false, "err": _err(r)}
	var b: Dictionary = r.body
	if b.has("access_token"): var s = _sess(b); s["need_verify"] = false; return s
	# 要驗證郵件：Supabase 只回 user（重複註冊時亦可能回假 user，identities 為空）
	if b.get("identities") is Array and (b.identities as Array).is_empty(): return {"ok": false, "err": "exists"}
	return {"ok": true, "need_verify": true, "uid": str(b.get("id", ""))}

func sign_in(email: String, pw: String) -> Dictionary:
	var r = await _req(HTTPClient.METHOD_POST, "/auth/v1/token?grant_type=password", {"email": email, "password": pw})
	if int(r.code) != 200 or not (r.body is Dictionary): return {"ok": false, "err": _err(r)}
	return _sess(r.body)

func refresh(rt: String) -> Dictionary:
	var r = await _req(HTTPClient.METHOD_POST, "/auth/v1/token?grant_type=refresh_token", {"refresh_token": rt})
	if int(r.code) != 200 or not (r.body is Dictionary): return {"ok": false, "err": _err(r)}
	return _sess(r.body)

func recover(email: String) -> Dictionary:
	var r = await _req(HTTPClient.METHOD_POST, "/auth/v1/recover", {"email": email})
	return {"ok": true} if int(r.code) == 200 else {"ok": false, "err": _err(r)}

func resend(email: String, _pw := "") -> Dictionary:
	var r = await _req(HTTPClient.METHOD_POST, "/auth/v1/resend", {"type": "signup", "email": email})
	return {"ok": true} if int(r.code) == 200 else {"ok": false, "err": _err(r)}

func sign_out(token: String) -> Dictionary:
	await _req(HTTPClient.METHOD_POST, "/auth/v1/logout", null, token)
	return {"ok": true}

func load_save(uid: String, token: String) -> Dictionary:
	var r = await _req(HTTPClient.METHOD_GET, "/rest/v1/saves?user_id=eq.%s&select=data,ts,rev" % uid, null, token)
	if int(r.code) != 200 or not (r.body is Array): return {"ok": false, "err": _err(r)}
	if (r.body as Array).is_empty(): return {"ok": true, "data": "", "ts": 0, "rev": 0}
	var s = r.body[0]
	return {"ok": true, "data": str(s.get("data", "")), "ts": int(s.get("ts", 0)), "rev": int(s.get("rev", 0))}

# 樂觀鎖：只喺雲端 rev 仍然係 base_rev 先寫得入（PATCH ... &rev=eq.N）；第一次（rev 0）用 INSERT
func store_save(uid: String, token: String, data: String, ts: int, base_rev: int, force := false) -> Dictionary:
	var ret = PackedStringArray(["Prefer: return=representation"])
	if base_rev == 0 and not force:
		var r0 = await _req(HTTPClient.METHOD_POST, "/rest/v1/saves", {"user_id": uid, "data": data, "ts": ts, "rev": 1}, token, ret)
		if int(r0.code) == 201: return {"ok": true, "rev": 1}
		if int(r0.code) == 409: return {"ok": false, "err": "conflict"}
		return {"ok": false, "err": _err(r0)}
	var cur = base_rev
	if force:
		var l = await load_save(uid, token)
		if not l.ok: return l
		cur = int(l.rev)
		if cur == 0: return await store_save(uid, token, data, ts, 0, false)
	var r = await _req(HTTPClient.METHOD_PATCH, "/rest/v1/saves?user_id=eq.%s&rev=eq.%d" % [uid, cur], {"data": data, "ts": ts, "rev": cur + 1}, token, ret)
	if int(r.code) == 200 and r.body is Array:
		if (r.body as Array).is_empty(): return {"ok": false, "err": "conflict"}
		return {"ok": true, "rev": cur + 1}
	return {"ok": false, "err": _err(r)}
