# [account] Nakama 後端骨架（自架，例如 Hetzner 新加坡 VPS；開源免授權費，之後聯機、Steam 登入都喺同一套）
#   正式上線大規模（月活 > 5 萬）時由 Firebase 換過嚟用；介面同 svc_mock／svc_firebase 一樣（協程，回傳 {ok, err, ...}）
#   Auth：/v2/account/authenticate/email（伺服器 key 走 Basic）；session refresh／logout
#   存檔：Storage 物件 saves/main（value＝{"data": 壓縮字串, "ts", "rev"}），用 version 做樂觀鎖
#   Nakama 冇內建「驗證郵件／忘記密碼」：要喺伺服器加兩個 RPC（send_verify、recover_pw，經 SMTP 寄信），
#     同埋喺 before-hook 擋未驗證帳號登入（回 403 + "unverified"）。由 Firebase 搬過嚟嘅舊帳號：見 claude/HC_GhostBattles_Backend_Cost_Plan_20261127.md「搬用戶」
# 狀態：骨架（未接真伺服器）；切換＝acct_cfg.gd BACKEND = "nakama"＋填 NAKAMA_URL、NAKAMA_KEY
extends RefCounted

const AC = preload("res://game/account/acct_cfg.gd")
const TIMEOUT := 15.0
const COL := "saves"
const KEY := "main"

func _root() -> Node:
	var ml = Engine.get_main_loop()
	return (ml as SceneTree).root if ml is SceneTree else null

func _basic() -> String: return "Authorization: Basic " + Marshalls.utf8_to_base64(AC.NAKAMA_KEY + ":")

func _req(method: int, path: String, body = null, token := "") -> Dictionary:
	var r = _root()
	if r == null or AC.NAKAMA_URL == "": return {"code": 0, "body": null}
	var h = HTTPRequest.new(); h.timeout = TIMEOUT; r.add_child(h)
	var hd = PackedStringArray(["Content-Type: application/json", ("Authorization: Bearer " + token) if token != "" else _basic()])
	var e = h.request(AC.NAKAMA_URL.trim_suffix("/") + path, hd, method, JSON.stringify(body) if body != null else "")
	if e != OK: h.queue_free(); return {"code": 0, "body": null}
	var res = await h.request_completed
	h.queue_free()
	if int(res[0]) != HTTPRequest.RESULT_SUCCESS: return {"code": 0, "body": null}
	var txt = (res[3] as PackedByteArray).get_string_from_utf8()
	return {"code": int(res[1]), "body": JSON.parse_string(txt) if txt != "" else null}

func _err(r: Dictionary) -> String:
	var c = int(r.code)
	if c == 0: return "offline"
	var m = str((r.body as Dictionary).get("message", "")) if r.body is Dictionary else ""
	if "unverified" in m: return "unverified"
	if c == 409: return "exists"
	if c == 401: return "expired" if "token" in m.to_lower() else "bad_login"
	if c == 404 and "not found" in m.to_lower(): return "bad_login"
	if c == 400 and "password" in m.to_lower(): return "weak_pw"
	if c == 400 and "email" in m.to_lower(): return "bad_email"
	if c == 429: return "rate"
	return "server"

# Nakama session token 係 JWT：uid 喺 payload 嘅 "uid"
static func uid_of(jwt: String) -> String:
	var p = jwt.split(".")
	if p.size() < 2: return ""
	var s = p[1].replace("-", "+").replace("_", "/")
	while s.length() % 4 != 0: s += "="
	var o = JSON.parse_string(Marshalls.base64_to_utf8(s))
	return str(o.get("uid", "")) if o is Dictionary else ""

func _sess(b) -> Dictionary:
	if not (b is Dictionary): return {"ok": false, "err": "server"}
	var t = str(b.get("token", ""))
	return {"ok": true, "uid": uid_of(t), "token": t, "refresh": str(b.get("refresh_token", ""))}

func sign_up(email: String, pw: String) -> Dictionary:
	var r = await _req(HTTPClient.METHOD_POST, "/v2/account/authenticate/email?create=true", {"email": email, "password": pw})
	if int(r.code) != 200: return {"ok": false, "err": _err(r)}
	var s = _sess(r.body)
	if not s.ok: return s
	await _req(HTTPClient.METHOD_POST, "/v2/rpc/send_verify", JSON.stringify({}), s.token)   # 伺服器 RPC：寄驗證郵件
	return {"ok": true, "need_verify": true, "uid": s.uid}

func sign_in(email: String, pw: String) -> Dictionary:
	var r = await _req(HTTPClient.METHOD_POST, "/v2/account/authenticate/email?create=false", {"email": email, "password": pw})
	if int(r.code) != 200: return {"ok": false, "err": _err(r)}
	return _sess(r.body)

func refresh(rt: String) -> Dictionary:
	var r = await _req(HTTPClient.METHOD_POST, "/v2/account/session/refresh", {"token": rt})
	if int(r.code) != 200: return {"ok": false, "err": _err(r)}
	return _sess(r.body)

func recover(email: String) -> Dictionary:
	var r = await _req(HTTPClient.METHOD_POST, "/v2/rpc/recover_pw?http_key=" + AC.NAKAMA_HTTP_KEY + "&unwrap", {"email": email})
	return {"ok": true} if int(r.code) in [200, 404] else {"ok": false, "err": _err(r)}

func resend(email: String, pw := "") -> Dictionary:
	var s = await sign_in(email, pw)
	if not s.ok and str(s.err) != "unverified": return s
	return {"ok": true}

func sign_out(token: String) -> Dictionary:
	await _req(HTTPClient.METHOD_POST, "/v2/session/logout", {"token": token}, token)
	return {"ok": true}

func _obj(uid: String, token: String) -> Dictionary:
	var r = await _req(HTTPClient.METHOD_POST, "/v2/storage", {"object_ids": [{"collection": COL, "key": KEY, "user_id": uid}]}, token)
	if int(r.code) != 200 or not (r.body is Dictionary): return {"ok": false, "err": _err(r)}
	var objs = r.body.get("objects", [])
	if not (objs is Array) or (objs as Array).is_empty(): return {"ok": true, "data": "", "ts": 0, "rev": 0, "ver": ""}
	var v = JSON.parse_string(str(objs[0].get("value", "{}")))
	if not (v is Dictionary): v = {}
	return {"ok": true, "data": str(v.get("data", "")), "ts": int(v.get("ts", 0)), "rev": int(v.get("rev", 0)), "ver": str(objs[0].get("version", ""))}

func load_save(uid: String, token: String) -> Dictionary:
	var g = await _obj(uid, token); g.erase("ver"); return g

# Nakama 冇欄位遮罩：meta 同全份係同一次讀（存檔已壓縮，流量細）
func load_meta(uid: String, token: String) -> Dictionary:
	var g = await _obj(uid, token)
	if g.ok: g["has"] = str(g.data) != ""; g.erase("data"); g.erase("ver")
	return g

# 樂觀鎖：寫入帶 version（第一次用 "*"＝只准新建）；期間被改 → 409 → conflict
func store_save(uid: String, token: String, data: String, ts: int, base_rev: int, force := false) -> Dictionary:
	var g = await _obj(uid, token)
	if not g.ok: return g
	if not force and int(g.rev) != base_rev: return {"ok": false, "err": "conflict"}
	var nr = int(g.rev) + 1
	var o = {"collection": COL, "key": KEY, "value": JSON.stringify({"data": data, "ts": ts, "rev": nr}), "permission_read": 1, "permission_write": 1,
		"version": (str(g.ver) if str(g.ver) != "" else "*")}
	var r = await _req(HTTPClient.METHOD_PUT, "/v2/storage", {"objects": [o]}, token)
	if int(r.code) == 200: return {"ok": true, "rev": nr}
	if int(r.code) in [400, 409] and "version" in str(r.body).to_lower(): return {"ok": false, "err": "conflict"}
	return {"ok": false, "err": _err(r)}
