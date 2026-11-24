# [vox] 劇情語氣聲：角色開口時先出一聲短真人語氣（嗯？／蛤？！／唉／嘻嘻），唔係念台詞
#   聲音檔：res://assets/vox/<角色key>_<語氣>.ogg（data/vox.json 登記：講者名 → 角色key；角色key → 有咩語氣）
#   自動揀語氣：？→q（疑問）  ！→ex（驚訝）  開頭／結尾「……」→sigh（嘆氣）  嘻／哈哈／呵呵→laugh（笑）
#   手動指定：場景 "vox": {"<行號>": "語氣"}，或者 "" ＝呢句唔出聲
#   主角跟性別：講者「阿福」→ 男 afu／女 afuf
#   同一個講者連續講，同一種語氣唔重複出（唔好嘈）
# 熱更新：冇 class_name；story.gd 用 preload
extends Node

var _p: AudioStreamPlayer
var _cfg: Dictionary = {}
var _last := ""
var _who := ""
static var _cache := {}
static var LOG: Array = []   # 測試用：播過嘅語氣 key

func _ready() -> void:
	_p = AudioStreamPlayer.new(); add_child(_p)
	var f = FileAccess.open("res://data/vox.json", FileAccess.READ)
	if f: var d = JSON.parse_string(f.get_as_text()); if d is Dictionary: _cfg = d

static func mood_of(text: String) -> String:
	var t = text.strip_edges()
	if t.begins_with("（") and t.find("）") > 0: t = t.substr(t.find("）") + 1).strip_edges()   # 動作提示唔計
	if t == "": return ""
	if t.begins_with("……") or t.ends_with("……"): return "sigh"
	if t.find("嘻") >= 0 or t.find("哈哈") >= 0 or t.find("呵呵") >= 0: return "laugh"
	var e = t.substr(maxi(0, t.length() - 3))
	if e.find("？") >= 0 or e.find("?") >= 0: return "q"
	if e.find("！") >= 0 or e.find("!") >= 0: return "ex"
	return ""

func line(sc: Dictionary, li: int, who: String, text: String) -> void:
	if who != _who: _last = ""   # 換人講就可以再出同一種聲
	_who = who
	if not Snd.is_on(): return
	var m = ""
	var vm = sc.get("vox")
	if vm is Dictionary and vm.has(str(li)): m = str(vm[str(li)])
	else: m = mood_of(text)
	if m == "": return
	var ck = str(_cfg.get("speakers", {}).get(who, ""))
	if ck == "": return
	if ck == "afu":
		var S = J.G.get("S"); var h = S.get("hero") if S is Dictionary else null
		if h is Dictionary and str(h.get("sex", "m")) == "f": ck = "afuf"
	var moods = _cfg.get("moods", {}).get(ck, [])
	if not (moods is Array) or not moods.has(m): return
	var key = ck + "_" + m
	if key == _last: return
	_last = key
	var st = _cache.get(key)
	if st == null:
		var path = "res://assets/vox/%s.ogg" % key
		if not ResourceLoader.exists(path): return
		st = load(path); _cache[key] = st
	LOG.append(key)
	_p.stream = st; _p.volume_db = linear_to_db(0.9); _p.play()

func reset() -> void: _last = ""
