# [account] Firebase 後端（REST，唔使插件；Spark 免費方案：唔使綁卡，超額只會停到下個週期，唔會收費）
#   Auth：Identity Toolkit REST（郵箱＋密碼、驗證郵件、忘記密碼）
#   存檔：Firestore 文件 saves/{uid} = {data: 字串, ts: 整數, rev: 整數}
#   安全規則（Firestore Rules）見專案文件 claude/HC_GhostBattles_Account_Plan_20261127.md
# 用法同 svc_mock.gd 一樣：協程，回傳 {ok, err, ...}
extends RefCounted

const AC = preload("res://game/account/acct_cfg.gd")
const AUTH := "https://identitytoolkit.googleapis.com/v1/"
const TOKEN := "https://securetoken.googleapis.com/v1/token?key="
const TIMEOUT := 15.0

func _root() -> Node:
	var ml = Engine.get_main_loop()
	return (ml as SceneTree).root if ml is SceneTree else null

func _fs() -> String: return "https://firestore.googleapis.com/v1/projects/%s/databases/(default)/documents/" % AC.FB_PROJECT

func _req(method: int, url: String, body = null, token := "", form := false) -> Dictionary:
	var r = _root()
	if r == null or AC.FB_API_KEY == "": return {"code": 0, "body": null}
	var h = HTTPRequest.new(); h.timeout = TIMEOUT; r.add_child(h)
	var hd = PackedStringArray(["Content-Type: " + ("application/x-www-form-urlencoded" if form else "application/json")])
	if token != "": hd.append("Authorization: Bearer " + token)
	var payload = ""
	if body != null: payload = str(body) if form else JSON.stringify(body)
	var e = h.request(url, hd, method, payload)
	if e != OK: h.queue_free(); return {"code": 0, "body": null}
	var res = await h.request_completed
	h.queue_free()
	if int(res[0]) != HTTPRequest.RESULT_SUCCESS: return {"code": 0, "body": null}
	var txt = (res[3] as PackedByteArray).get_string_from_utf8()
	return {"code": int(res[1]), "body": JSON.parse_string(txt) if txt != "" else null}

func _err(r: Dictionary) -> String:
	if int(r.code) == 0: return "offline"
	var b = r.body if r.body is Dictionary else {}
	var e = b.get("error", {})
	var m = (str(e.get("message", "")) if e is Dictionary else str(e)).to_upper()
	var st = str(e.get("status", "")) if e is Dictionary else ""
	if "EMAIL_EXISTS" in m: return "exists"
	if "INVALID_LOGIN_CREDENTIALS" in m or "INVALID_PASSWORD" in m or "EMAIL_NOT_FOUND" in m: return "bad_login"
	if "WEAK_PASSWORD" in m: return "weak_pw"
	if "INVALID_EMAIL" in m: return "bad_email"
	if "TOO_MANY_ATTEMPTS" in m or int(r.code) == 429: return "rate"
	if "TOKEN_EXPIRED" in m or "INVALID_ID_TOKEN" in m or int(r.code) == 401 or st == "UNAUTHENTICATED": return "expired"
	if st == "FAILED_PRECONDITION" or st == "ALREADY_EXISTS": return "conflict"
	return "server"

func _send_verify(id_token: String) -> void:
	await _req(HTTPClient.METHOD_POST, AUTH + "accounts:sendOobCode?key=" + AC.FB_API_KEY, {"requestType": "VERIFY_EMAIL", "idToken": id_token})

func sign_up(email: String, pw: String) -> Dictionary:
	var r = await _req(HTTPClient.METHOD_POST, AUTH + "accounts:signUp?key=" + AC.FB_API_KEY, {"email": email, "password": pw, "returnSecureToken": true})
	if int(r.code) != 200 or not (r.body is Dictionary): return {"ok": false, "err": _err(r)}
	await _send_verify(str(r.body.get("idToken", "")))
	return {"ok": true, "need_verify": true, "uid": str(r.body.get("localId", ""))}

func sign_in(email: String, pw: String) -> Dictionary:
	var r = await _req(HTTPClient.METHOD_POST, AUTH + "accounts:signInWithPassword?key=" + AC.FB_API_KEY, {"email": email, "password": pw, "returnSecureToken": true})
	if int(r.code) != 200 or not (r.body is Dictionary): return {"ok": false, "err": _err(r)}
	var b: Dictionary = r.body; var tok = str(b.get("idToken", ""))
	var lk = await _req(HTTPClient.METHOD_POST, AUTH + "accounts:lookup?key=" + AC.FB_API_KEY, {"idToken": tok})
	var ver = false
	if int(lk.code) == 200 and lk.body is Dictionary and lk.body.get("users") is Array and not (lk.body.users as Array).is_empty():
		ver = bool(lk.body.users[0].get("emailVerified", false))
	if not ver: return {"ok": false, "err": "unverified"}
	return {"ok": true, "uid": str(b.get("localId", "")), "token": tok, "refresh": str(b.get("refreshToken", ""))}

func refresh(rt: String) -> Dictionary:
	var r = await _req(HTTPClient.METHOD_POST, TOKEN + AC.FB_API_KEY, "grant_type=refresh_token&refresh_token=" + rt.uri_encode(), "", true)
	if int(r.code) != 200 or not (r.body is Dictionary): return {"ok": false, "err": _err(r)}
	return {"ok": true, "uid": str(r.body.get("user_id", "")), "token": str(r.body.get("id_token", "")), "refresh": str(r.body.get("refresh_token", rt))}

func recover(email: String) -> Dictionary:
	var r = await _req(HTTPClient.METHOD_POST, AUTH + "accounts:sendOobCode?key=" + AC.FB_API_KEY, {"requestType": "PASSWORD_RESET", "email": email})
	if int(r.code) == 200 or _err(r) == "bad_login": return {"ok": true}   # 冇呢個帳號都答 ok，免被人試郵箱
	return {"ok": false, "err": _err(r)}

# 重寄驗證郵件：Firebase 要先用密碼登入攞 idToken
func resend(email: String, pw := "") -> Dictionary:
	var r = await _req(HTTPClient.METHOD_POST, AUTH + "accounts:signInWithPassword?key=" + AC.FB_API_KEY, {"email": email, "password": pw, "returnSecureToken": true})
	if int(r.code) != 200 or not (r.body is Dictionary): return {"ok": false, "err": _err(r)}
	await _send_verify(str(r.body.get("idToken", "")))
	return {"ok": true}

func sign_out(_token: String) -> Dictionary: return {"ok": true}   # Firebase REST 冇伺服器端登出，客戶端清 token 就得

func _doc(uid: String, token: String) -> Dictionary:
	var r = await _req(HTTPClient.METHOD_GET, _fs() + "saves/" + uid, null, token)
	if int(r.code) == 404: return {"ok": true, "data": "", "ts": 0, "rev": 0, "upd": ""}
	if int(r.code) != 200 or not (r.body is Dictionary): return {"ok": false, "err": _err(r)}
	var f = r.body.get("fields", {})
	return {"ok": true, "data": str(f.get("data", {}).get("stringValue", "")), "ts": int(f.get("ts", {}).get("integerValue", "0")),
		"rev": int(f.get("rev", {}).get("integerValue", "0")), "upd": str(r.body.get("updateTime", ""))}

func load_save(uid: String, token: String) -> Dictionary:
	var g = await _doc(uid, token); g.erase("upd"); return g

# 樂觀鎖：先讀 rev／updateTime；rev 唔等於 base_rev → 衝突；寫入帶 currentDocument 前置條件，期間被改都會失敗
func store_save(uid: String, token: String, data: String, ts: int, base_rev: int, force := false) -> Dictionary:
	var g = await _doc(uid, token)
	if not g.ok: return g
	if not force and int(g.rev) != base_rev: return {"ok": false, "err": "conflict"}
	var nr = int(g.rev) + 1
	var pre = ("currentDocument.exists=false" if str(g.upd) == "" else "currentDocument.updateTime=" + str(g.upd).uri_encode())
	var body = {"fields": {"data": {"stringValue": data}, "ts": {"integerValue": str(ts)}, "rev": {"integerValue": str(nr)}}}
	var r = await _req(HTTPClient.METHOD_PATCH, _fs() + "saves/" + uid + "?" + pre, body, token)
	if int(r.code) == 200: return {"ok": true, "rev": nr}
	return {"ok": false, "err": _err(r)}
