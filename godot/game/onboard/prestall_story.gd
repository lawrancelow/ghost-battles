# [opening] 大排檔前大更新：劇情掛鈎（文案組 story_v2：化寶爐重開、陰間酒館開張、化寶爐轉祭品）
# 熱更新規矩：冇 class_name；用 load("res://game/onboard/prestall_story.gd") 叫
# 玩法組（vil2／tavern）喺事件發生嗰下叫 play(事件)：每個事件只播一次（記喺 S.seen），女主有 _f 版就用 _f 版
#   "joss_repaired"   修好化寶爐（荒村重建）→ joss_reopen／joss_reopen_f
#   "tavern_open"     陰間酒館開張 → tav_open
#   "joss_open"       每次開化寶爐收件時叫：stall_hook 之後第一次 → joss_shift（化寶爐轉「祭品模式」）
# 接 tavern 分支化寶爐（game/joss/joss.gd 收件結果）：on_joss_result(r)
#   r.backlog＝第一次收件（積壓包裹）→ joss_reopen(_f)；r.shift＝轉祭品模式 → joss_shift
# 大排檔接入點 stall_hook：tick()（native/game.gd 每次 produce 叫）見到大排檔開咗（tavern.stall_open()：KPI 組掛 stall_open_fn／S.tav.stall）就播一次
#   只限睇過新開場（op2_arrive／opf2_arrive）嘅存檔；舊存檔唔觸發。CHAPTERS[0].intro 亦保留 stall_hook（備用）
extends RefCounted

const EV := {"joss_repaired": "joss_reopen", "tavern_open": "tav_open", "joss_open": "joss_shift"}

static func _S():
	var S = J.G.get("S")
	return S if S is Dictionary else {}

static func _female(S) -> bool:
	var h = S.get("hero")
	return h is Dictionary and str(h.get("sex", "m")) == "f"

# 呢個事件而家應該播邊場（"" = 唔使播）
static func scene_for(ev: String, S = null) -> String:
	if S == null: S = _S()
	var base = str(EV.get(ev, ""))
	if base == "": return ""
	var seen = S.get("seen", {})
	if not (seen is Dictionary): seen = {}
	if ev == "joss_open" and not seen.has("stall_hook"): return ""   # 大排檔未出：化寶爐仲係冥幣模式
	var id = base
	var SC = DB.D.get("SCENES", {})
	if _female(S) and SC is Dictionary and SC.has(base + "_f"): id = base + "_f"
	if seen.has(base) or seen.has(base + "_f"): return ""
	if not (SC is Dictionary and SC.has(id)): return ""
	return id

# 播（如果要）；回傳有冇排到劇情
static func play(ev: String, cb: Callable = Callable()) -> bool:
	var id = scene_for(ev)
	if id == "": return false
	var st = J.G.get("Story")
	if st == null: return false
	J.mc(st, "queue", [id, cb] if cb.is_valid() else [id])
	return true

# 大排檔開張：只播一次、劇情框空閒先播
static func tick() -> void:
	var S = _S()
	var seen = S.get("seen", {})
	if not (seen is Dictionary) or seen.has("stall_hook"): return
	if not (seen.has("op2_arrive") or seen.has("opf2_arrive")): return
	if not load("res://game/tavern/tavern.gd").stall_open(): return
	var st = J.G.get("Story")
	if st == null or J.t(J.mc(st, "busy", [])): return
	if not DB.D.get("SCENES", {}).has("stall_hook"): return
	J.mc(st, "queue", ["stall_hook"])

# 荒村重建開張事件 → 陰間酒館開張（招魂台＝酒館）；只註冊一次
static var _hooked := false
static func hook() -> void:
	if _hooked: return
	_hooked = true
	load("res://game/rebuild/rb.gd").listen(func(kind, arg):
		if str(kind) == "open" and str(arg) == "altar": play("tavern_open"))

# 化寶爐收件：開箱畫面收起之後先播劇情（唔好疊住開箱畫面）
static var _pend = null
static func defer_joss(r) -> void:
	if r is Dictionary and (bool(r.get("backlog", false)) or bool(r.get("shift", false))): _pend = r
static func flush_joss() -> bool:
	var r = _pend; _pend = null
	return on_joss_result(r)

# 化寶爐模式："cash"（前期冥幣）／"offer"（大排檔後收祭品）
static func joss_mode(S = null) -> String:
	if S == null: S = _S()
	var seen = S.get("seen", {})
	return "offer" if seen is Dictionary and seen.has("stall_hook") else "cash"

# 化寶爐收件結果（tavern：joss.gd 回傳 dict）→ 播對應劇情；回傳有冇排到
static func on_joss_result(r, cb: Callable = Callable()) -> bool:
	if not (r is Dictionary): return false
	if bool(r.get("backlog", false)): return play("joss_repaired", cb)
	if bool(r.get("shift", false)):
		var S = _S(); var seen = S.get("seen", {})
		if seen is Dictionary and seen.has("joss_shift"): return false
		var st = J.G.get("Story")
		if st == null or not DB.D.get("SCENES", {}).has("joss_shift"): return false
		J.mc(st, "queue", ["joss_shift", cb] if cb.is_valid() else ["joss_shift"])
		return true
	return false
