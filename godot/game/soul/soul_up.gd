# [soul_up] 品階（魂魄融合）＋星級突破（全部 static；冇 class_name；熱更新規矩）
#   品：凡魂 → 靈鬼 → 煞鬼 → 鬼王 → 冥君 → 幽皇；每品三階：下品／中品／上品（共 18 階，index 0–17）
#   出生品＝soul.json PIN（凡靈煞王）→ 該品下品；融合每次只升一階，冇上限，但現時只開放到 OPEN_MAX（鬼王・上品）。
#   融合材料：本鬼魂魄＋同系其他鬼魂魄＋散魂＋冥幣；煞鬼起要「X系精魄」（只有打特定王，極低機率掉）。
#   星級突破（職級升到合夥人之後）：★1–5；上限按現時品（凡 1、靈 3、煞 4、鬼王 5）；材料：本鬼魂魄＋冥火＋冥幣。
#   存檔 S.soul：pj{k:階}、jp{系:精魄}、mh（冥火）、star{k:星}
extends RefCounted

const SOUL = preload("res://game/soul/soul_data.gd")

const PJ := [["凡魂", "凡魂"], ["靈鬼", "靈鬼"], ["煞鬼", "煞鬼"], ["鬼王", "鬼王"], ["冥君", "冥君"], ["幽皇", "幽皇"]]
const PJ_COL := ["#8f8a7e", "#3f88c8", "#9a4ad0", "#e0a020", "#c83a3a", "#e8e4f0"]
const SUB := [["下品", "下品"], ["中品", "中品"], ["上品", "上品"]]
const PJ_MAX := 17
const OPEN_MAX := 11                 # 現時開放到鬼王・上品；冥君、幽皇預留俾日後改版
const STAT_PER_PJ := 0.03            # 每升一階三圍 +3%
const STAR_MAX := 5
const STAR_CAP := [1, 3, 4, 5, 5, 5] # 按現時品（凡靈煞王冥幽）
const STAR_PCT := 0.06               # 每星三圍 +6%
const STAR_SOUL := [20, 30, 45, 60, 80]
const STAR_MH := [1, 2, 4, 6, 10]
const STAR_COIN := [1500.0, 3000.0, 5000.0, 8000.0, 12000.0]
const JP_P_KING := 0.03              # 野外王每次打贏：3% 掉 1 粒該王系精魄
const JP_P_BOSS := 0.06              # 魔王：6%
const MH_P_RING4 := 0.10             # 第 4 圈據點：10% 掉 1 個冥火
const MH_KING := 1                   # 野外王每次打贏：1 個冥火（首殺 3）

static func L(yue: String, zhs: String) -> String: return SOUL.L(yue, zhs)
static func T(a) -> String: return SOUL.T(a)
static func RO(): return load("res://game/rts/roles.gd")

static func st():
	var o = SOUL.st()
	if o == null: return null
	for kk in ["pj", "jp", "star"]: if not (o.get(kk) is Dictionary): o[kk] = {}
	if o.get("mh") == null: o["mh"] = 0.0
	return o

# ======================= 品階 =======================
static func born(k: String) -> int: return maxi(0, SOUL.PINS.find(SOUL.pin(k))) * 3
static func pj(k: String) -> int:
	var o = st()
	var b = born(k)
	if o == null: return b
	return clampi(maxi(b, int(J.num(o.pj.get(k, b)))), 0, PJ_MAX)
static func pin_i(k: String) -> int: return pj(k) / 3      # 現時品 0–5
static func pj_name_i(i: int) -> String: return T(PJ[clampi(i / 3, 0, 5)]) + "・" + T(SUB[i % 3])
static func pj_name(k: String) -> String: return pj_name_i(pj(k))
static func pin_name(k: String) -> String: return T(PJ[pin_i(k)])
static func pj_col(k: String) -> Color: return Color(PJ_COL[pin_i(k)])
# 出生品單字（凡靈煞王主）→ 新品名（凡魂、靈鬼、煞鬼、鬼王、主角）
static func pin_label(p: String) -> String:
	if p == "主": return L("主角", "主角")
	var i = SOUL.PINS.find(p)
	return T(PJ[i]) if i >= 0 else p
static func pin_col(p: String) -> Color:
	if p == "主": return Color("#9c2219")
	var i = SOUL.PINS.find(p)
	return Color(PJ_COL[i]) if i >= 0 else Color.GRAY
# 已收：現時品階全名；未收：出生品
static func tag_name(k: String) -> String: return pj_name(k) if SOUL.owned(k) and SOUL.is_ghost(k) else pin_label(SOUL.pin(k))
static func tag_col(k: String) -> Color: return pj_col(k) if SOUL.owned(k) and SOUL.is_ghost(k) else pin_col(SOUL.pin(k))
static func is_ace_k(k: String) -> bool: return pin_i(k) >= 3   # 鬼王或以上＝王牌（王牌上限計呢個）
static func born_ace(k: String) -> bool: return SOUL.pin(k) == "王"
static func stat_mul(k: String) -> float: return 1.0 + STAT_PER_PJ * (pj(k) - born(k)) + STAR_PCT * star(k)

static func sys_of(k: String) -> String: return RO().sys_of(k)
static func jp(sy: String) -> int:
	var o = st()
	return int(J.num(o.jp.get(sy, 0))) if o != null else 0
static func mh() -> int:
	var o = st()
	return int(J.num(o.mh)) if o != null else 0

# 同系其他鬼嘅魂魄（唔計自己）
static func same_sys_souls(k: String) -> int:
	var o = st(); var sy = sys_of(k); var n = 0
	if o == null or sy == "": return 0
	for k2 in o.sh:
		if str(k2) != k and sys_of(str(k2)) == sy: n += int(J.num(o.sh[k2]))
	return n

static func fuse_cost(k: String) -> Dictionary:
	var to = pj(k) + 1
	var own = int(round(round(8.0 * pow(1.45, to)) * load("res://game/post/po_data.gd").fuse_k(k)))   # [post] 王／煞消耗倍數（wild2.json fuse_k，預設關＝×1）
	return {"to": to, "own": own, "sys": int(own / 2), "san": 10 * to, "coins": 100.0 * to * to,
		"jp": maxi(0, to - 5), "altar": clampi(1 + to / 3, 1, 6)}

static func can_fuse(k: String) -> Dictionary:
	var c = fuse_cost(k); c["ok"] = false; c["why"] = ""
	if st() == null or not SOUL.owned(k) or not SOUL.is_ghost(k): c.why = "notown"; return c
	if c.to > PJ_MAX: c.why = "max"; return c
	if c.to > OPEN_MAX: c.why = "locked"; return c
	if SOUL.souls(k) < c.own: c.why = "souls"; return c
	if same_sys_souls(k) < c.sys: c.why = "sys"; return c
	if SOUL.san() < c.san: c.why = "san"; return c
	if jp(sys_of(k)) < c.jp: c.why = "jp"; return c
	if SOUL.altar_lv() < c.altar: c.why = "altar"; return c
	if SOUL.have("coins") < c.coins - 1e-6: c.why = "coins"; return c
	c.ok = true
	return c

static func fuse(k: String) -> String:
	var c = can_fuse(k)
	if not c.ok: return str(c.why)
	var o = st(); var s = SOUL.S()
	o.sh[k] = float(SOUL.souls(k) - c.own)
	if J.num(o.sh[k]) <= 0: o.sh.erase(k)
	var need = int(c.sys); var sy = sys_of(k)   # 同系魂魄：由最多嗰隻開始扣
	var pool = []
	for k2 in o.sh: if str(k2) != k and sys_of(str(k2)) == sy and J.num(o.sh[k2]) > 0: pool.append(str(k2))
	pool.sort_custom(func(a, b): return J.num(o.sh[a]) > J.num(o.sh[b]))
	for k2 in pool:
		if need <= 0: break
		var use = mini(need, int(J.num(o.sh[k2])))
		o.sh[k2] = J.num(o.sh[k2]) - use; need -= use
		if J.num(o.sh[k2]) <= 0: o.sh.erase(k2)
	o["san"] = J.num(o.san) - c.san
	if int(c.jp) > 0: o.jp[sy] = J.num(o.jp.get(sy, 0)) - c.jp
	s.res["coins"] = SOUL.have("coins") - c.coins
	o.pj[k] = float(c.to)
	var g = SOUL.ghost(k)
	if g != null: SOUL.apply_stats(g)
	SOUL.LOG.append(["fuse", k, c.to])
	SOUL._save()
	return "ok"

# ======================= 星級突破 =======================
static func star(k: String) -> int:
	var o = st()
	return clampi(int(J.num(o.star.get(k, 0))), 0, STAR_MAX) if o != null else 0
static func star_cap(k: String) -> int: return STAR_CAP[pin_i(k)]
static func can_star(k: String) -> Dictionary:
	var s0 = star(k); var to = s0 + 1
	var c = {"ok": false, "why": "", "to": to}
	if st() == null or not SOUL.owned(k) or not SOUL.is_ghost(k): c.why = "notown"; return c
	if SOUL.rank(k) < SOUL.RANK_MAX: c.why = "rank"; return c
	if s0 >= STAR_MAX: c.why = "max"; return c
	if to > star_cap(k): c.why = "cap"; return c
	c["own"] = STAR_SOUL[to - 1]; c["mh"] = STAR_MH[to - 1]; c["coins"] = STAR_COIN[to - 1]
	if SOUL.souls(k) < c.own: c.why = "souls"; return c
	if mh() < c.mh: c.why = "mh"; return c
	if SOUL.have("coins") < c.coins - 1e-6: c.why = "coins"; return c
	c.ok = true
	return c
static func up_star(k: String) -> String:
	var c = can_star(k)
	if not c.ok: return str(c.why)
	var o = st(); var s = SOUL.S()
	o.sh[k] = float(SOUL.souls(k) - c.own)
	if J.num(o.sh[k]) <= 0: o.sh.erase(k)
	o["mh"] = J.num(o.mh) - c.mh
	s.res["coins"] = SOUL.have("coins") - c.coins
	o.star[k] = float(c.to)
	var g = SOUL.ghost(k)
	if g != null: SOUL.apply_stats(g)
	SOUL.LOG.append(["star", k, c.to])
	SOUL._save()
	return "ok"
# 星級對技能嘅強化：★1 主技、★2 副技、★4 專長、★5 主技再升（技能等級＝數值 ×(1+0.12×級)）
static func act_lv(k: String) -> int:
	var s0 = star(k)
	return (1 if s0 >= 1 else 0) + (1 if s0 >= 3 else 0) + (1 if s0 >= 5 else 0)
static func sub_lv(k: String) -> int:
	var s0 = star(k)
	return (1 if s0 >= 2 else 0) + (1 if s0 >= 4 else 0)
static func adv_art(k: String) -> bool: return star(k) >= 3   # 進階立繪（★3）

# ======================= 掉落 =======================
static func drop_king(k_king: String, boss := false, first := false) -> String:
	var o = st()
	if o == null: return ""
	var out = []
	var nm = MH_KING * (3 if first else 1)
	o["mh"] = J.num(o.mh) + nm; out.append(L("冥火 ×%d", "冥火 ×%d") % nm)
	var sy = sys_of(k_king)
	if sy != "" and randf() < (JP_P_BOSS if boss else JP_P_KING):
		o.jp[sy] = J.num(o.jp.get(sy, 0)) + 1
		out.append(L("★%s系精魄 ×1（極罕有）", "★%s系精魄 ×1（極稀有）") % sy)
	return "、".join(out)
static func drop_ring(ring: int) -> String:
	var o = st()
	if o == null or ring < 4 or randf() >= MH_P_RING4: return ""
	o["mh"] = J.num(o.mh) + 1
	return L("冥火 ×1", "冥火 ×1")

static func why_txt(w: String, c: Dictionary, k: String) -> String:
	match w:
		"souls": return L("本鬼魂魄唔夠（%d/%d）", "本鬼魂魄不夠（%d/%d）") % [SOUL.souls(k), int(c.get("own", 0))]
		"sys": return L("同系（%s）魂魄唔夠（%d/%d）", "同系（%s）魂魄不夠（%d/%d）") % [sys_of(k), same_sys_souls(k), int(c.get("sys", 0))]
		"san": return L("散魂唔夠", "散魂不夠")
		"jp": return L("%s系精魄唔夠（%d/%d）", "%s系精魄不夠（%d/%d）") % [sys_of(k), jp(sys_of(k)), int(c.get("jp", 0))]
		"altar": return L("要祭壇 Lv%d", "需要祭壇 Lv%d") % int(c.get("altar", 0))
		"coins": return L("冥幣唔夠", "冥幣不夠")
		"locked": return L("未開放（日後改版）", "未開放（日後改版）")
		"max": return L("已到頂", "已到頂")
		"rank": return L("要先升到合夥人", "要先升到合夥人")
		"cap": return L("%s最多 %d 星，要先融合升品", "%s最多 %d 星，要先融合升品") % [pin_name(k), star_cap(k)]
		"mh": return L("冥火唔夠（%d/%d）", "冥火不夠（%d/%d）") % [mh(), int(c.get("mh", 0))]
	return w
