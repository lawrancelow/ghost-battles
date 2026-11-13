# 熱更新（第一個 autoload，一定要排第一）
# 開遊戲 → 查伺服器 version.json → 有新補丁就即刻下載（細，幾百 KB～幾 MB）→ 校驗 md5 → 載入 → 先至載其他 autoload 同遊戲
# 冇網／伺服器有事：用機入面上次下載好嘅補丁照玩；下載太耐就轉去背景下載，下次開遊戲生效
# 補丁 = 同「安裝包嗰個基礎版本」比較，有改過嘅檔案（累積），所以只需要載一個 pck
# 規矩：熱更新唔可以加新 class_name、新 autoload、改 project.godot 設定（呢啲要出新安裝包）
extends Node

const DEFAULT_URL := "https://lawrancelow.github.io/ghost-battles/godot-update/version.json"
const DIR := "user://update"
const CHECK_MS := 4000          # 查版本最多等幾耐
const BLOCK_DL_MS := 45000      # 開機時最多花幾耐即場下載
const BLOCK_DL_MAX := 40 << 20  # 超過呢個大小就唔即場下載，轉背景

var base := ""          # 安裝包基礎版本（project.godot 嘅 version）
var plat := ""
var content_ver := 0    # 而家用緊嘅補丁版本（0 = 冇補丁）
var status := ""        # 俾畫面顯示／測試用
var _bg_entry = null

func _init() -> void:
	base = str(ProjectSettings.get_setting("application/config/version", "0"))
	plat = OS.get_name().to_lower()
	if OS.has_feature("web") or OS.has_feature("editor"): status = "off"; return
	DirAccess.make_dir_recursive_absolute(DIR)
	var st = _state()
	# 換咗新安裝包：舊補丁作廢
	if str(st.get("base", "")) != base:
		_clear(); st = {}
	var url = OS.get_environment("GB_UPDATE_URL") if OS.get_environment("GB_UPDATE_URL") != "" else DEFAULT_URL
	var t0 = Time.get_ticks_msec()
	var info = _get_json(url + "?t=%d" % int(Time.get_unix_time_from_system()), CHECK_MS)
	if info is Dictionary:
		var e = info.get("base", {}).get(base, {}).get(plat)
		if e is Dictionary and int(e.get("ver", 0)) > int(st.get("ver", 0)):
			var size = int(e.get("size", 0))
			if size <= BLOCK_DL_MAX:
				var ok = _download(url.get_base_dir() + "/" + str(e.file), e, BLOCK_DL_MS)
				if ok: st = _state()
				else: _bg_entry = [url.get_base_dir() + "/" + str(e.file), e]
			else: _bg_entry = [url.get_base_dir() + "/" + str(e.file), e]
		status = "checked %dms" % (Time.get_ticks_msec() - t0)
	else:
		status = "offline"
	# 載入補丁
	var f = str(st.get("file", ""))
	if f != "" and FileAccess.file_exists(DIR + "/" + f):
		if ProjectSettings.load_resource_pack(DIR + "/" + f, true):
			content_ver = int(st.get("ver", 0))
		else:
			_clear(); content_ver = 0
	print("[boot] base=", base, " plat=", plat, " content=", content_ver, " ", status)

func _ready() -> void:
	if _bg_entry != null: _bg_download.call_deferred()

func label() -> String:
	return "v%s%s" % [base, ("・更新 %d" % content_ver) if content_ver > 0 else ""]

# ---------------- 狀態檔 ----------------
func _state() -> Dictionary:
	var p = DIR + "/state.json"
	if not FileAccess.file_exists(p): return {}
	var o = JSON.parse_string(FileAccess.get_file_as_string(p))
	return o if o is Dictionary else {}

func _save_state(o: Dictionary) -> void:
	var fa = FileAccess.open(DIR + "/state.json", FileAccess.WRITE)
	if fa: fa.store_string(JSON.stringify(o)); fa.close()

func _clear() -> void:
	var d = DirAccess.open(DIR)
	if d == null: return
	for fn in d.get_files(): d.remove(fn)

# ---------------- 同步 HTTP（開機階段，未有畫面循環）----------------
func _split(url: String) -> Array:
	var tls = url.begins_with("https://")
	var rest = url.substr(8 if tls else 7)
	var slash = rest.find("/")
	var hostport = rest.substr(0, slash) if slash >= 0 else rest
	var path = rest.substr(slash) if slash >= 0 else "/"
	var host = hostport; var port = 443 if tls else 80
	if hostport.contains(":"): host = hostport.split(":")[0]; port = int(hostport.split(":")[1])
	return [host, port, tls, path]

func _open(url: String, deadline: int) -> HTTPClient:
	var u = _split(url)
	var c = HTTPClient.new()
	if c.connect_to_host(u[0], u[1], TLSOptions.client() if u[2] else null) != OK: return null
	while c.get_status() in [HTTPClient.STATUS_CONNECTING, HTTPClient.STATUS_RESOLVING]:
		c.poll(); OS.delay_msec(5)
		if Time.get_ticks_msec() > deadline: return null
	if c.get_status() != HTTPClient.STATUS_CONNECTED: return null
	if c.request(HTTPClient.METHOD_GET, u[3], ["User-Agent: GhostBattles", "Cache-Control: no-cache"]) != OK: return null
	while c.get_status() == HTTPClient.STATUS_REQUESTING:
		c.poll(); OS.delay_msec(5)
		if Time.get_ticks_msec() > deadline: return null
	if not c.has_response() or c.get_response_code() != 200: return null
	return c

func _get_json(url: String, ms: int):
	var deadline = Time.get_ticks_msec() + ms
	var c = _open(url, deadline)
	if c == null: return null
	var buf = PackedByteArray()
	while c.get_status() == HTTPClient.STATUS_BODY:
		c.poll()
		var ch = c.read_response_body_chunk()
		if ch.size() == 0: OS.delay_msec(5)
		else: buf.append_array(ch)
		if Time.get_ticks_msec() > deadline: return null
	return JSON.parse_string(buf.get_string_from_utf8())

func _download(url: String, e: Dictionary, ms: int) -> bool:
	var deadline = Time.get_ticks_msec() + ms
	var c = _open(url, deadline)
	if c == null: return false
	var tmp = DIR + "/download.tmp"
	var fa = FileAccess.open(tmp, FileAccess.WRITE)
	if fa == null: return false
	while c.get_status() == HTTPClient.STATUS_BODY:
		c.poll()
		var ch = c.read_response_body_chunk()
		if ch.size() == 0: OS.delay_msec(2)
		else: fa.store_buffer(ch)
		if Time.get_ticks_msec() > deadline: fa.close(); return false
	fa.close()
	return _accept(tmp, e)

# 校驗啱先換上；舊補丁刪走
func _accept(tmp: String, e: Dictionary) -> bool:
	if FileAccess.get_md5(tmp) != str(e.get("md5", "")):
		DirAccess.remove_absolute(tmp); return false
	var old = str(_state().get("file", ""))
	var fn = str(e.file).get_file()
	DirAccess.rename_absolute(tmp, DIR + "/" + fn)
	if old != "" and old != fn: DirAccess.remove_absolute(DIR + "/" + old)
	_save_state({"base": base, "ver": int(e.ver), "file": fn})
	return true

# ---------------- 背景下載（開機等唔切嘅大補丁）：下次開遊戲生效 ----------------
func _bg_download() -> void:
	var h = HTTPRequest.new(); add_child(h)
	h.download_file = DIR + "/download.tmp"
	h.request_completed.connect(func(result, code, _hd, _b):
		if result == HTTPRequest.RESULT_SUCCESS and code == 200 and _accept(DIR + "/download.tmp", _bg_entry[1]):
			status = "pending"   # 下次開遊戲生效
		h.queue_free())
	h.request(_bg_entry[0])
