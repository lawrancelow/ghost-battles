# [opening] 大排檔前大更新：劇情掛鈎（文案組 story_v2：化寶爐重開、陰間酒館開張、化寶爐轉祭品）
# 熱更新規矩：冇 class_name；用 load("res://game/onboard/prestall_story.gd") 叫
# 玩法組（vil2／tavern）喺事件發生嗰下叫 play(事件)：每個事件只播一次（記喺 S.seen），女主有 _f 版就用 _f 版
#   "joss_repaired"   修好化寶爐（荒村重建）→ joss_reopen／joss_reopen_f
#   "tavern_open"     陰間酒館開張 → tav_open
#   "joss_open"       每次開化寶爐收件時叫：stall_hook 之後第一次 → joss_shift（化寶爐轉「祭品模式」）
# 大排檔接入點 stall_hook：已經放喺 CHAPTERS[0].intro 最前（data/nat/data.json），第一章開場自動先播
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

# 化寶爐模式："cash"（前期冥幣）／"offer"（大排檔後收祭品）
static func joss_mode(S = null) -> String:
	if S == null: S = _S()
	var seen = S.get("seen", {})
	return "offer" if seen is Dictionary and seen.has("stall_hook") else "cash"
