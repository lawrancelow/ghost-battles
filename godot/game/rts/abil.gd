# [abcore] 能力引擎：敵我共用「能力積木」＋敵人「機制」＋兩層克制（ability.md 第 2–4 節；數值以 counter.md 第 3、4 節為準）
#   用法：const AB = preload("res://game/rts/abil.gd")（冇 class_name、冇 autoload：熱更新規矩）
#   AB.on() 假（冇 data/abil.json／AB.OFF=true／abil.json 頂層 "off": true／AB.force=0）＝ rts_sim 全部行舊路，同改之前一模一樣（一鍵回舊路；全域開關，唔入存檔）
#   公開接口：on()、mechs_of(k)、counters_of(k)、tags_of(k)、describe(k)、sys_of(k)、scares_of(k)、fear_of(k)
#   戰鬥：setup(sim)、hit(sim, src, v, mult, ctx)、cast(sim, u, sk)、tick_unit(sim, u, dt)、tick(sim, dt)、pick_fix(sim, u, tg)、emul(sim, u)、report(sim)
#   單位能力狀態全部喺 u.ab（Dictionary）；buff／debuff 統一 u.ab.bf = [{p, stat, v, until, neg, tags}]
extends RefCounted

const PATH := "res://data/abil.json"
const CT_PATH := "res://data/nat/counter.json"
const NG_PATH := "res://game/newghost/ng_data.gd"
const CAP_LO := 0.2           # 兩層克制＋機制＋追擊 總倍率封頂
const CAP_HI := 4.0
const ADV_CAP := 0.25         # 軍師加成封頂 +25%
const AOE_R := 130.0          # 舊 aoe 技：以目標為圓心 130px（唔再係全場）
const SUM_CAP := 12           # 每場召喚物／分裂體上限
const TICK := 0.25            # 光環／定時觸發
static var D = null
static var CT = null
static var OFF := false       # 全域一鍵回舊路（唔入存檔）；data/abil.json 頂層 "off": true 一樣關
static var force := -1        # 測試：-1 跟 OFF／數據、0 關、1 開

# ================= 數據 =================
static func data() -> Dictionary:
	if D == null:
		D = {}
		if FileAccess.file_exists(PATH):
			var f = FileAccess.open(PATH, FileAccess.READ)
			if f:
				var x = JSON.parse_string(f.get_as_text())
				if x is Dictionary: D = x
		if not D.is_empty() and ResourceLoader.exists(NG_PATH):   # newghost：ABIL／ENEMY／LINK 只補冇嘅 key（reload 後都補返）
			var NG = load(NG_PATH)
			if NG != null and NG.has_method("merge_abil"): NG.merge_abil(D)
	return D
static func abil(k) -> Dictionary: return _ent("ABIL", J.str(k))   # ng_data.abil_of 用
static func ct() -> Dictionary:
	if CT == null:
		CT = {}
		if FileAccess.file_exists(CT_PATH):
			var f = FileAccess.open(CT_PATH, FileAccess.READ)
			if f:
				var x = JSON.parse_string(f.get_as_text())
				if x is Dictionary: CT = x
	return CT
static func reload() -> void:
	D = null; CT = null; _gt = {}; _fcache = {}
static func on() -> bool:
	if force == 0: return false
	if data().is_empty(): return false
	if force == 1: return true
	return not OFF and not J.t(data().get("off", false))
static func _sec(name: String) -> Dictionary:
	var x = data().get(name, {})
	return x if x is Dictionary else {}
static func mech_def(m: String) -> Dictionary:
	var x = _sec("MECH").get(m, {})
	return x if x is Dictionary else {}
static func mp(m: String, key: String, def: float) -> float:
	var x = mech_def(m).get(key)
	return J.num(x) if x != null else def

# ================= 8 系 × 8 嚇法（counter.md 3.3） =================
const W := {"breath": "吹氣", "light": "燈", "cold": "凍", "sound": "怪聲", "paper": "紙", "phone": "電話", "face": "鬼臉", "shadow": "黑影"}
const WZ := {"吹氣": "breath", "燈": "light", "凍": "cold", "怪聲": "sound", "紙": "paper", "電話": "phone", "鬼臉": "face", "黑影": "shadow"}
const SYS := {
	"屍": {"w": ["breath", "sound"], "i": ["cold"], "why": ["生人氣", "雞啼", "屍體本來就凍"]},
	"魂": {"w": ["light", "shadow"], "i": ["breath"], "why": ["遊魂怕光", "以為聻來了", "飄慣了"]},
	"紙紮": {"w": ["light", "breath"], "i": ["paper"], "why": ["怕火", "紙輕一吹就飛", "自己就是紙"]},
	"妖": {"w": ["sound", "cold"], "i": ["shadow"], "why": ["爆竹", "一凍就要冬眠", "山林夜色是主場"]},
	"厲": {"w": ["phone", "face"], "i": ["sound"], "why": ["公司走唔開嗰通電話", "笑佢樣衰", "尖叫是她們的專利"]},
	"使": {"w": ["paper", "shadow"], "i": ["face"], "why": ["主人的契約字條", "以為主人回來了", "自己最愛扮鬼臉"]},
	"官": {"w": ["paper", "phone"], "i": ["light"], "why": ["公文投訴信", "上頭 call", "24 小時開燈返工"]},
	"橫": {"w": ["cold", "face"], "i": ["phone"], "why": ["停屍間雪櫃", "扮佢死相", "自己就是因為電話死"]},
}
# 後備表（abil.json 冇 SCARE 段先用）：名鬼／敵人 系、嚇法、預設標籤（counter.md 6.4、6.5）
const GT := """
laojiang 屍 凍 定
n30_dongsi 屍 凍 拉破刺
n30_gashadokuro 屍 凍 掃
n30_hanba 屍 燈 掃削照
n30_jenglot 屍 凍 掃
n30_jerangkung 屍 凍 遠破
n30_vetala 屍 鬼臉 拉刺削
nw_baimao 屍 凍 破定
nw_buhuagu 屍 凍 定
nw_honeonna 屍 燈 遠照
nw_mummy 屍 凍 定收
pocong 屍 凍 掃收
afu 魂 鬼臉 刺
eguiking 魂 怪聲 破刺回
n30_danxiao 魂 吹氣 破
n30_dugui 魂 紙 破
n30_guhangui 魂 紙 -
n30_hantugalah 魂 黑影 拉
n30_jiugui 魂 吹氣 -
n30_maoshi 魂 吹氣 拉
n30_phiam 魂 黑影 拉削
n30_qionggui 魂 吹氣 掃削
n30_xiasi 魂 鬼臉 掃削
n30_yangui 魂 吹氣 削
nw_ganshi 魂 怪聲 遠收
nw_guihuo 魂 燈 遠掃照
pg_ji 魂 黑影 掃削
pg_songding 魂 鬼臉 拉刺
pg_tuimo 魂 怪聲 掃定
tianhua 魂 鬼臉 遠拉刺
n30_chochin 紙紮 燈 遠破照
n30_kasaobake 紙紮 紙 -
n30_xiangcai 紙紮 紙 破
nw_zzcar 紙紮 燈 掃破照
nw_zzhouse 紙紮 紙 定
nw_zzphone 紙紮 電話 遠削
xiaozhi 紙紮 紙 遠拉掃
n30_aswang 妖 黑影 破刺回
n30_baigujing 妖 黑影 回
n30_bunian 妖 黑影 刺削照
n30_genderuwo 妖 黑影 破刺定
n30_kappa 妖 凍 拉
n30_nopperabo 妖 鬼臉 定
n30_rokurokubi 妖 黑影 -
n30_shanxiao 妖 黑影 破
n30_tikbalang 妖 黑影 刺
nw_daqiang 妖 黑影 照
nw_dullahan 妖 黑影 破刺
nw_huli 妖 黑影 遠照
nw_kapre 妖 吹氣 掃定
nw_krahang 妖 黑影 遠拉
nw_shejing 妖 凍 掃回
nw_tiangou 妖 黑影 遠拉
n30_banshee 厲 怪聲 掃
n30_churel 厲 怪聲 -
n30_diaosi 厲 鬼臉 刺收
n30_guixinniang 厲 怪聲 掃
n30_hannya 厲 鬼臉 破
n30_kuchisake 厲 鬼臉 破
n30_maenak 厲 怪聲 回
n30_yukionna 厲 凍 拉掃削
nw_ameonna 厲 凍 遠削
nw_huapi 厲 紙 削照
nw_teketeke 厲 怪聲 刺
penanggal 厲 鬼臉 遠回
pg_ex 厲 電話 拉掃
pontianak 厲 怪聲 拉
n30_changgui 使 鬼臉 -
n30_hanturaya 使 黑影 拉掃
n30_pelesit 使 怪聲 -
n30_polong 使 鬼臉 回
n30_taozhai 使 紙 拉刺削
nw_bajang 使 鬼臉 刺削
nw_kuaidi 使 電話 遠刺
nw_yeleng_guard 使 鬼臉 定
nw_yeleng_sales 使 電話 遠削
toyol 使 鬼臉 削
baiwu 官 紙 掃收
heiwu 官 黑影 掃定收
mamian 官 燈 照
mengpo 官 吹氣 遠削回
n30_yecha 官 燈 破刺照定
niutou 官 燈 照定
nw_shenpi 官 紙 照收
nw_toutai 官 紙 削回
n30_chehuo 橫 燈 刺照
n30_chengsi 橫 吹氣 回
n30_daji 橫 電話 破
n30_diansi 橫 電話 遠拉掃
n30_leipi 橫 燈 掃照
n30_liulian 橫 電話 遠刺
n30_shedu 橫 電話 回
n30_shidu 橫 吹氣 掃
n30_wutou 橫 鬼臉 拉掃
n30_xiaosi 橫 怪聲 掃削
n30_yesi 橫 電話 遠
n30_yezi 橫 電話 拉
n30_zhongshu 橫 燈 掃削照
n30_zipai 橫 電話 拉
nw_tisi 橫 凍 拉收
pg_landlady 橫 紙 掃
youhun 魂 吹氣 -
egui 魂 吹氣 -
shuigui 橫 凍 -
zombie 屍 凍 -
zd_bone 屍 凍 -
zhiren 紙紮 紙 -
zd_zhima 紙紮 紙 -
zd_shanjing 妖 黑影 -
zd_shuihou 妖 黑影 -
zd_hongyi 厲 怪聲 -
xiaogui 使 鬼臉 -
zd_paotui 使 鬼臉 -
zd_yinchai 官 燈 -
zd_hengsi 橫 電話 -
bm_taotie 妖 黑影 -
bm_jembalang 妖 黑影 -
bm_hou 屍 凍 -
bm_langsuir 厲 怪聲 -
bm_krasue 厲 鬼臉 -
huang 官 電話 -
bm_pang 官 紙 -
bm_shuten 妖 黑影 -
"""
static var _gt := {}
static var _fcache := {}
static func _gtab() -> Dictionary:
	if _gt.is_empty():
		var sc = data().get("SCARE")
		if sc is Dictionary and sc.size():
			for k in sc:
				var e = sc[k]
				if not (e is Dictionary): continue
				var tg0 = []
				for x in _arr(e.get("tags")): tg0.append(norm_tag(x))
				var ss = []
				for x in _arr(e.get("sc")): ss.append(WZ.get(J.str(x), J.str(x)))
				_gt[k] = {"sys": J.str(e.get("sys", "")), "sc": ss, "tags": tg0}
			return _gt
		for ln in GT.split("\n"):
			var p = ln.strip_edges().split(" ", false)
			if p.size() < 3: continue
			var tg = []
			if p.size() > 3 and p[3] != "-":
				for i in p[3].length(): tg.append(p[3].substr(i, 1))
			_gt[p[0]] = {"sys": p[1], "sc": [WZ.get(p[2], p[2])], "tags": tg}
	return _gt
const TAG_EN := {"ranged": "遠", "pull": "拉", "sweep": "掃", "break": "破", "stab": "刺", "sap": "削", "heal": "回", "reveal": "照", "steady": "定", "seal": "收"}
const MECH_EN := {"fly": "飛", "stealth": "隱", "shell": "殼", "armor": "殼", "regen": "再生", "split": "散骨", "summon": "召喚", "thorns": "反傷", "fear_aura": "嚇氣光環", "cc_immune": "霸體", "undead": "屍變", "revive": "屍變", "rush": "突襲", "confuse": "迷魂", "clone": "分身"}
static func norm_tag(x) -> String:
	var s = J.str(x)
	return TAG_EN.get(s, s)
static func norm_mech(x) -> String:
	var s = J.str(x)
	return MECH_EN.get(s, s)
static func _arr(x) -> Array:
	if x is Array: return x
	if x == null: return []
	if x is String and x != "": return [x]
	return []
static func _ent(sec: String, k: String) -> Dictionary:
	var x = _sec(sec).get(k)
	return x if x is Dictionary else {}
static func _ctg(k: String) -> Dictionary:   # counter.json（cdata）ghost／enemy 條目
	for s in ["ghost", "enemy"]:
		var t = ct().get(s, {})
		if t is Dictionary and t.get(k) is Dictionary: return t[k]
	return {}

static func sys_of(k) -> String:
	var ks = J.str(k)
	for e in [_ent("ABIL", ks), _ent("ENEMY", ks), _ctg(ks)]:
		if J.t(e.get("sys")): return J.str(e.sys)
	return J.str(_gtab().get(ks, {}).get("sys", ""))
static func scares_of(k) -> Array:   # 名鬼嘅嚇法（英文 key）；全部名鬼都有（counter.md 6.5）
	var ks = J.str(k)
	for e in [_ent("ABIL", ks), _ent("ENEMY", ks), _ctg(ks)]:
		var s = _arr(e.get("sc", e.get("scare")))
		if s.size():
			var o = []
			for x in s: o.append(WZ.get(J.str(x), J.str(x)))
			return o
	var g = _gtab().get(ks)
	if g is Dictionary: return g.sc
	var rw = J.G.get("Rework") if J.G != null else null
	if rw != null:
		var ts = J.mc(rw, "typesOf", [ks])
		if ts is Array and ts.size(): return ts
	return []
static func fear_of(k) -> Dictionary:   # {w: 怕, i: 唔怕}：ENEMY／counter.json 寫定優先；再按系民俗表；冇就跟舊 rework
	var ks = J.str(k)
	if _fcache.has(ks): return _fcache[ks]
	for e in [_ent("ENEMY", ks), _ctg(ks)]:
		if e.get("fear") != null or e.get("imm") != null:
			var w = []; var im = []
			for x in _arr(e.get("fear")): w.append(WZ.get(J.str(x), J.str(x)))
			for x in _arr(e.get("imm")): im.append(WZ.get(J.str(x), J.str(x)))
			_fcache[ks] = {"w": w, "i": im}
			return _fcache[ks]
	var s = sys_of(k)
	if SYS.has(s): return SYS[s]
	var rw = J.G.get("Rework") if J.G != null else null
	if rw != null:
		var f = J.mc(rw, "fearOf", [J.str(k)])
		if f is Dictionary: return f
	return {"w": [], "i": []}
static func word(tp) -> String: return W.get(J.str(tp), J.str(tp))

# ================= 標籤／機制（公開接口） =================
static func _legacy_tags(k: String) -> Array:   # counter.md 4.2 自動推導
	var o = []
	var GH = J.G.get("GHOSTS") if J.G != null else null
	var SK = J.G.get("SKILLS") if J.G != null else null
	var g = GH.get(k) if GH is Dictionary else null
	var sk = SK.get(k) if SK is Dictionary else null
	if g is Dictionary and J.str(g.get("range")) == "ranged": o.append("遠")
	if sk is Dictionary:
		var kd = J.str(sk.get("kind")); var mu = J.num(sk.get("mult"))
		if J.str(sk.get("apply")) == "down": o.append("拉")
		if kd == "aoe": o.append("掃")
		if J.num(sk.get("hits")) >= 2 or mu >= 1.8: o.append("破")
		if kd == "hit" and mu >= 1.7 and J.num(sk.get("hits")) < 2: o.append("刺")
		if J.num(sk.get("sap")) > 0 or J.t(sk.get("forget")): o.append("削")
		if J.num(sk.get("drain")) > 0 or kd == "heal": o.append("回")
	if scares_of(k).has("light"): o.append("照")
	return o
const PRIM_TAG := {"anti_air": "遠", "pull": "拉", "down": "拉", "reveal": "照", "shield_break": "破", "armor_break": "破", "dispel": "削", "silence": "削", "interrupt": "削", "sap": "削", "wound": "削",
	"heal": "回", "hot": "回", "drain": "回", "taunt": "定", "guard": "定", "banish": "收", "execute": "刺", "dash": "刺"}
static func _act_tags(e: Dictionary) -> Array:
	var o = []
	var lists = []
	if e.get("act") is Dictionary:
		lists.append(_arr(e.act.get("fx")))
		var tg = e.act.get("tg")
		if tg is Dictionary and J.str(tg.get("shape", "single")) in ["circle", "self_circle", "cone", "line", "chain"]: o.append("掃")
	for pe in _arr(e.get("pas")): if pe is Dictionary: lists.append(_arr(pe.get("fx")))
	for L in lists:
		for fx in L:
			if not (fx is Dictionary): continue
			var p = J.str(fx.get("p"))
			if PRIM_TAG.has(p) and not o.has(PRIM_TAG[p]): o.append(PRIM_TAG[p])
			if p == "immune" and ("fear_aura" in _arr(fx.get("tags")) or "嚇氣光環" in _arr(fx.get("tags"))) and not o.has("定"): o.append("定")
			if p == "dmg" and J.num(fx.get("hits")) >= 2 and not o.has("破"): o.append("破")
	return o
static func tags_of(k) -> Array:   # 名鬼應對標籤（10 個之中 0–3 個；ABIL.tags 手寫優先）
	var ks = J.str(k)
	var e = _ent("ABIL", ks)
	if e.has("tags"):
		var o = []
		for x in _arr(e.tags): var t = norm_tag(x); if not o.has(t): o.append(t)
		return o
	var c = _ctg(ks)
	if c.has("tags"):
		var o2 = []
		for x in _arr(c.tags): var t2 = norm_tag(x); if not o2.has(t2): o2.append(t2)
		return o2
	var g = _gtab().get(ks)
	var o3 = []
	if g is Dictionary and (g.tags as Array).size(): o3 = (g.tags as Array).duplicate()
	else: o3 = _legacy_tags(ks)
	for t3 in _act_tags(e): if not o3.has(t3): o3.append(t3)
	return o3
static func mechs_of(k) -> Array:   # 敵人機制（中文 key：飛、隱、殼……）
	var ks = J.str(k); var o = []
	for e in [_ent("ENEMY", ks), _ctg(ks)]:
		for m in _arr(e.get("mech")):
			var n = norm_mech(m)
			if n != "" and not o.has(n) and not mech_def(n).is_empty(): o.append(n)
		if o.size(): return o
	return o
static func counters_of(k) -> Array:   # 打呢隻敵人要帶邊啲標籤
	var o = []
	for m in mechs_of(k):
		for t in _arr(mech_def(m).get("counter")): if not o.has(t): o.append(t)
	return o
const SOUL := "res://game/soul/soul_data.gd"
static var _sd = null
static func _soul():
	if _sd == null:
		_sd = false
		if ResourceLoader.exists(SOUL): _sd = load(SOUL)
	return _sd if _sd is Script else null
static func rank_of(k) -> int:   # 職級 0–5：唯一來源 soul_data.rank(k)（S.soul.rk）；soul 線未合併＝0
	var sd = _soul()
	if sd != null and sd.has_method("rank"): return clampi(int(sd.rank(J.str(k))), 0, 5)
	return 0
static func pin_of(k) -> String:
	var e = _ent("ABIL", J.str(k))
	if J.t(e.get("pin")): return J.str(e.pin)
	var sd = _soul()
	if sd != null and sd.has_method("pin"): return J.str(sd.pin(J.str(k)))
	return ""
static func perks_of(k, rk := -1) -> Array:   # 專長解鎖（唯一一張表）：職級 2 主任開專長 1、職級 4 總監開專長 2；王品入村即有專長 1
	var e = _ent("ABIL", J.str(k))
	var pk = _arr(e.get("perk"))
	if rk < 0: rk = rank_of(k)
	var o = []
	if pk.size() > 0 and pk[0] is Dictionary and (rk >= 2 or pin_of(k) == "王"): o.append(pk[0])
	if pk.size() > 1 and pk[1] is Dictionary and rk >= 4: o.append(pk[1])
	return o
static func act_of(k, sk = null):   # 編譯好嘅主動技（ABIL 手寫優先；冇就由舊 SKILLS 自動轉換）
	var e = _ent("ABIL", J.str(k))
	if e.get("act") is Dictionary: return e.act
	if sk == null:
		var SK = J.G.get("SKILLS") if J.G != null else null
		sk = SK.get(J.str(k)) if SK is Dictionary else null
	return from_legacy(sk)
const PN := {"dmg": "傷害", "dot": "持續傷害", "execute": "斬殺", "chain": "彈射", "splash": "濺射", "mark": "易傷", "pierce": "穿殼", "down": "腳軟", "air": "嚇彈起", "push": "嚇退", "pull": "扯近",
	"stun": "定身", "silence": "封口", "interrupt": "打斷", "slow": "減速", "flee": "驚走", "taunt": "嘲諷", "heal": "治療", "hot": "持續回血", "shield": "護盾", "drain": "吸血", "guard": "護衛",
	"immune": "免疫", "cleanse": "淨化", "revive": "返生", "buff": "強化", "energy": "回嚇氣", "anti_air": "對空", "reveal": "照妖", "armor_break": "破甲", "shield_break": "破盾", "dispel": "驅散",
	"banish": "收魂", "sap": "抽嚇氣", "wound": "重創", "dash": "突進", "stealth": "隱身", "summon": "召喚", "coin": "偷冥幣", "zone": "地面陷阱"}
static func describe(k) -> String:   # 自動生成描述（名冊／配搭 UI）
	var ks = J.str(k)
	var act = act_of(ks)
	var parts = []
	if act is Dictionary:
		var fs = []
		for fx in _arr(act.get("fx")):
			if fx is Dictionary:
				var p = J.str(fx.get("p")); var s = PN.get(p, p)
				if p == "dmg": s = "傷害 ×%s" % str(snappedf(_v(fx, "mult", 1.0, 0), 0.01)) + ("（%d 段）" % int(J.num(fx.hits)) if J.num(fx.get("hits")) > 1 else "")
				fs.append(s)
		var tg = act.get("tg", {}); var sh = J.str(tg.get("shape", "single")) if tg is Dictionary else "single"
		parts.append("%s：%s%s" % [J.str(act.get("name")), "範圍 " if sh != "single" else "", "、".join(fs)])
	var tg2 = tags_of(ks)
	if tg2.size(): parts.append("應對：" + "".join(tg2))
	var ms = mechs_of(ks)
	if ms.size(): parts.append("機制：" + "、".join(ms))
	var sc = scares_of(ks)
	if sc.size(): parts.append("嚇法：%s（%s系）" % [word(sc[0]), sys_of(ks)])
	return "；".join(parts)

# ================= 舊 SKILLS 自動轉換（ability.md 2.4） =================
static func from_legacy(sk):
	if not (sk is Dictionary) or sk.is_empty(): return null
	var kd = J.str(sk.get("kind")); var mult = J.num(sk.get("mult"))
	var act = {"name": J.str(sk.get("name")), "kind": kd, "leg": true, "fx": []}
	if kd == "heal":
		act["tg"] = {"sel": "allies"}
		act.fx.append({"p": "heal", "pct": mult})
		if J.t(sk.get("forget")): act.fx.append({"p": "sap", "v": 100.0, "tg": "foes"})
		return act
	act["tg"] = {"sel": "near", "shape": "circle", "r": AOE_R} if kd == "aoe" else {"sel": "near"}
	var d = {"p": "dmg", "mult": mult}
	if J.num(sk.get("hits")) > 1: d["hits"] = int(J.num(sk.hits))
	if J.t(sk.get("follow")): d["vs_state"] = J.str(sk.follow); d["x"] = 1.8
	if J.num(sk.get("drain")) > 0: d["drain"] = J.num(sk.drain)
	act.fx.append(d)
	if J.num(sk.get("sap")) > 0: act.fx.append({"p": "sap", "v": J.num(sk.sap)})
	if J.num(sk.get("steal")) > 0: act.fx.append({"p": "coin", "v": J.num(sk.steal)})
	var ap = J.str(sk.get("apply")) if J.t(sk.get("apply")) else ""
	if ap == "down": act.fx.append({"p": "down", "dur": 1.4})
	elif ap == "air": act.fx.append({"p": "air", "dur": 1.0})
	elif ap == "push": act.fx.append({"p": "push", "dist": 40.0})
	if J.t(sk.get("forget")): act.fx.append({"p": "sap", "v": 100.0, "tg": "foes"})
	return act

# ================= 小工具 =================
static func _nn(u, k: String) -> float: return J.num(u.get(k, 0)) if u is Dictionary else 0.0
static func _v(fx: Dictionary, key: String, def: float, star: int) -> float:   # 數值陣列＝按星級
	var x = fx.get(key)
	if x == null: return def
	if x is Array:
		if x.is_empty(): return def
		return J.num(x[mini(star, x.size() - 1)])
	return J.num(x)
static func A(u) -> Dictionary:
	if not (u is Dictionary): return {}
	var a = u.get("ab")
	return a if a is Dictionary else {}
static func has_tag(u, t: String) -> bool: return (A(u).get("tags", []) as Array).has(t)
static func has_mech(u, m: String) -> bool: return (A(u).get("mech", []) as Array).has(m)
static func is_hero(u) -> bool: return u is Dictionary and _nn(u, "side") == 0 and not J.t(u.get("minion"))
static func ranged(u) -> bool: return _nn(u, "range") > 60 or has_tag(u, "遠")
static func stat(sim, u, key: String) -> float:
	var a = A(u)
	if a.is_empty(): return 1.0
	var s = 1.0
	for b in a.get("bf", []):
		if J.str(b.get("stat")) == key and J.num(b.until) > sim.t: s += J.num(b.v)
	return maxf(0.0, s)
static func has_bf(sim, u, p: String) -> bool:
	for b in A(u).get("bf", []):
		if J.str(b.get("p")) == p and J.num(b.until) > sim.t: return true
	return false
static func get_bf(sim, u, p: String):
	for b in A(u).get("bf", []):
		if J.str(b.get("p")) == p and J.num(b.until) > sim.t: return b
	return null
static func add_bf(sim, u, b: Dictionary) -> void:
	var a = A(u)
	if a.is_empty(): return
	var dur = J.num(b.get("dur", 1.0))
	b["until"] = sim.t + (1e9 if dur < 0 else dur)
	# 同 id 唔疊（刷新時間），dot 最多疊 3 層
	var id = J.str(b.get("id", b.get("p")))
	var same = []
	for x in a.bf: if J.str(x.get("id", x.get("p"))) == id and J.num(x.until) > sim.t: same.append(x)
	var lim = int(J.num(b.get("stack", 1)))
	if same.size() >= maxi(1, lim):
		var o = same[0]
		for k in b: o[k] = b[k]
		return
	a.bf.append(b)
static func ev(sim, p: String, src, v) -> void:   # 能力事件（畫面飄字、測試計數）
	var e = sim.ab_log.get("ev")
	if e is Dictionary: e[p] = int(e.get(p, 0)) + 1
	sim.events.append(["ab", src, p, v])
	sim._vq(["ab", src, p, v])
static func flying(sim, u) -> bool:
	var a = A(u)
	return J.t(a.get("fly")) and J.num(a.get("ground_until", -1.0)) <= sim.t and _nn(u, "hp") > 0
static func stealthed(sim, u) -> bool:
	var a = A(u)
	if J.t(a.get("st_on")) and J.num(a.get("rev_until", -1.0)) <= sim.t: return true
	return has_bf(sim, u, "stealth")
static func targetable(sim, u, v, area := false) -> bool:
	if not sim.alive(v): return false
	if area: return true
	if stealthed(sim, v):
		var up = u.get("p")
		if up is Vector2 and (up as Vector2).distance_to(v.p) <= mp("隱", "near", 80.0): return true
		return false
	return true
static func foes(sim, u, area := false) -> Array:
	var o = []; var sd = _nn(u, "side")
	for v in sim.units:
		if _nn(v, "side") != sd and targetable(sim, u, v, area): o.append(v)
	return o
static func allies(sim, u) -> Array:
	var o = []; var sd = _nn(u, "side")
	for v in sim.units: if _nn(v, "side") == sd and sim.alive(v): o.append(v)
	return o
static func _pos(sim, u) -> Vector2:
	var p = u.get("p") if u is Dictionary else null
	return p if p is Vector2 else sim.center()
static func protected(sim, u) -> bool:   # 「定」：自己有，或者 150px 內有隊友有
	if has_tag(u, "定") or has_bf(sim, u, "steady"): return true
	var up = _pos(sim, u)
	for w in sim.units:
		if w != u and _nn(w, "side") == _nn(u, "side") and sim.alive(w) and (has_tag(w, "定") or has_bf(sim, w, "steady")) and up.distance_to(w.p) <= 150.0: return true
	return false
static func cc_ok(sim, src, v, kind: String) -> bool:   # 控場免疫：霸體（「破」無視）、immune buff
	if has_mech(v, "霸體") and not has_tag(src, "破"): return false
	for b in A(v).get("bf", []):
		if J.str(b.get("p")) == "immune" and J.num(b.until) > sim.t:
			var ts = _arr(b.get("tags"))
			if ts.is_empty() or ts.has(kind) or (kind in ["down", "air", "push", "pull", "stun"] and ts.has("cc")): return false
	return true

# ================= 開局：編譯每隻單位 =================
static func setup(sim) -> void:
	sim.ab_log = {"kills": [], "ev": {}, "cast": 0}
	sim.ab_st = {"t0": false, "acc": 0.0, "pend": [], "zones": [], "spawn": [], "sums": 0, "combo": [], "depth": 0}
	for u in sim.units: compile(sim, u)
	if sim.adviser is Dictionary: compile(sim, sim.adviser)
	for u in sim.units.duplicate(): _mech_setup(sim, u)
	_flush(sim)
	_combos(sim)
static func compile(sim, u: Dictionary) -> void:
	var k = J.str(u.get("k")); var sd = _nn(u, "side")
	var a = {"tags": [], "mech": [], "bf": [], "shd": 0.0, "spd0": _nn(u, "spd"), "sys": "", "sc": [], "act": null, "pas": [], "aura": null, "star": 0, "icd": {}, "n_att": 0,
		"sum": J.t(u.get("sum")), "hero": sd == 0 and not J.t(u.get("minion"))}
	var e = _ent("ABIL", k)
	if sd == 0 and not J.t(u.get("minion")):
		a.star = rank_of(k)
		a.tags = tags_of(k)
		if _nn(u, "range") > 60 and not a.tags.has("遠"): a.tags.append("遠")
		a.sc = scares_of(k); a.sys = sys_of(k)
		a.act = e.act if e.get("act") is Dictionary else from_legacy(u.get("sk"))
	elif sd == 1:
		a.sc = scares_of(k); a.sys = sys_of(k)
		var en = _ent("ENEMY", k)
		var ms = mechs_of(k)
		for m in _arr(u.get("mech")):
			var n = norm_mech(m)
			if n != "" and not ms.has(n): ms.append(n)
		a.mech = ms
		if J.t(en.get("use_abil")) and e.get("act") is Dictionary:
			a.act = e.act; a.star = 2 if J.t(u.get("boss")) else 0   # 名鬼做敵人：職級 0；王當主任
		else: a.act = from_legacy(u.get("sk"))
		for t in _arr(en.get("tags")): a.tags.append(norm_tag(t))
	if e.size() and (a.hero or J.t(_ent("ENEMY", k).get("use_abil"))):
		for pe in _arr(e.get("pas")):   # 被動：star 0 一入隊就有；star n＝職級 ≥ n 先開（2 主任、4 總監）
			if pe is Dictionary and int(J.num(pe.get("star", 0))) <= int(a.star): a.pas.append(pe)
		for pe in perks_of(k, int(a.star) if a.hero else (2 if J.t(u.get("boss")) else 0)):   # 專長：按職級（做敵人：王當主任）
			if pe.get("aura") is Dictionary: a.aura = pe.aura
			if pe.get("tr") != null: a.pas.append(pe)
		if e.get("aura") is Dictionary and a.aura == null: a.aura = e.aura
	if a.act is Dictionary and not J.t(a.act.get("leg")) and J.t(u.get("sk")) == false: u["sk"] = {"name": J.str(a.act.get("name")), "kind": "ab"}
	if a.act is Dictionary and not J.t(a.act.get("leg")) and u.get("sk") is Dictionary and J.str(u.sk.get("name")) != J.str(a.act.get("name")):
		u["sk"] = (u.sk as Dictionary).duplicate(); u.sk["name"] = J.str(a.act.get("name"))
	u["ab"] = a
static func _mech_setup(sim, u: Dictionary) -> void:
	var a = A(u)
	for m in a.get("mech", []):
		match m:
			"飛": a["fly"] = true
			"殼": a["shell"] = _nn(u, "maxhp") * mp("殼", "pct", 0.35); a["shell0"] = a.shell
			"召喚":
				if not J.t(u.get("sk")): u["sk"] = {"name": "召喚", "kind": "hit", "mult": 1.0}
			"突襲": a["rush"] = true
			"迷魂": a["conf_t"] = 2.0
			"分身": _clones(sim, u); a["clone_t"] = mp("分身", "re", 10.0)
static func _clones(sim, u: Dictionary) -> void:   # 放分身（補返夠 n_clone 個）
	var have = 0
	for w in sim.units: if J.t(A(w).get("clone")) and A(w).get("by") == u and sim.alive(w): have += 1
	for i in range(have, int(mp("分身", "n_clone", 2))):
		var c = _clone_of(u)
		c["ab"]["clone"] = true; c["ab"]["by"] = u
		var off = Vector2((i * 2 - 1) * 34.0, 10.0)
		if sim.perp is Vector2: off = (sim.perp as Vector2) * (i * 2 - 1) * 34.0
		_spawn(sim, c, _pos(sim, u) + off)
	if have < int(mp("分身", "n_clone", 2)) and sim.phase == "fight": sim.text(sim.head(u) + Vector2(0, -24), "分身", "#d8b4fe", 0.9); ev(sim, "clone", u, null)
static func _clone_of(u: Dictionary) -> Dictionary:
	var c = {}
	for k in ["side", "k", "name", "atk", "range", "spd", "boss"]: c[k] = u.get(k)
	c["hp"] = 1.0; c["maxhp"] = 1.0; c["sk"] = null; c["energy"] = 0.0; c["st"] = {}; c["sum"] = true; c["boss"] = false
	c["ab"] = {"tags": [], "mech": [], "bf": [], "shd": 0.0, "spd0": _nn(u, "spd"), "sys": A(u).get("sys", ""), "sc": A(u).get("sc", []), "act": null, "pas": [], "aura": null, "star": 0, "icd": {}, "n_att": 0, "sum": true, "hero": false}
	return c
static func _spawn(sim, u: Dictionary, at: Vector2) -> void:   # 中途加單位（排隊，每格尾先加，唔好喺迴圈入面改 units）
	if int(sim.ab_st.get("sums", 0)) >= SUM_CAP: return
	sim.ab_st["sums"] = int(sim.ab_st.get("sums", 0)) + 1
	u["p"] = at; u["post"] = at; u["face"] = -1.0 if _nn(u, "side") == 1 else 1.0
	u["eng"] = true; u["out"] = true; u["stamp"] = true; u["s"] = 0.0; u["cd"] = 0.4 + randf() * 0.4
	if not (u.get("st") is Dictionary): u["st"] = {}
	if u.get("ab") == null: compile(sim, u)
	A(u)["sum"] = true; u["sum"] = true
	sim.ab_st.spawn.append(u)
static func _flush(sim) -> void:
	var sp = sim.ab_st.get("spawn", [])
	if sp.is_empty(): return
	for u in sp:
		u["_id"] = sim.units.size()
		sim.units.append(u)
	sim.ab_st["spawn"] = []

# ================= 合體技（COMBOS＋LINK，在地圖戰鬥生效） =================
static func links() -> Array:   # LINK（abil.json＋newghost）優先；舊 COMBOS 補冇嘅 id（a、b → m）
	var o = []; var ids = {}
	for c in _arr(data().get("LINK")):
		if c is Dictionary and not ids.has(J.str(c.get("id"))): o.append(c); ids[J.str(c.get("id"))] = true
	var CB = J.G.get("COMBOS") if J.G != null else null
	if CB is Array:
		for c in CB:
			if c is Dictionary and not ids.has(J.str(c.get("id"))):
				var x = (c as Dictionary).duplicate(); x["leg"] = true; ids[J.str(c.get("id"))] = true; o.append(x)
	return o
static func link_members(c: Dictionary) -> Array:
	var m = _arr(c.get("m"))
	if m.is_empty(): m = [c.get("a"), c.get("b")]
	return m
static func _combos(sim) -> void:
	sim.ab_st["combo"] = []
	var S = J.G.get("S") if J.G != null else null
	var lv = J.num(S.get("lv", 1)) if S is Dictionary else 1.0
	for c in links():
		var need_lv = J.num(c.get("lv", data().get("COMBO_LV", 17) if J.t(c.get("leg")) else 0))
		if lv < need_lv: continue
		var mem = []; var ks = {}
		for k in link_members(c):
			for u in sim.units:
				if is_hero(u) and J.str(u.get("k")) == J.str(k) and not ks.has(J.str(k)) and not J.t(u.get("sum")): mem.append(u); ks[J.str(k)] = true; break
		if mem.size() < int(J.num(c.get("need", 2))): continue
		var ok = true
		for k in _arr(c.get("must")): if not ks.has(J.str(k)): ok = false
		if not ok: continue
		var kind = J.str(c.get("kind", "strike"))
		var cb = {"c": c, "a": mem[0], "b": mem[1] if mem.size() > 1 else mem[0], "m": mem, "n": mem.size(), "energy": 0.0, "cast": null, "kind": kind, "on": false}
		sim.ab_st.combo.append(cb)
static func _link_fx(cb: Dictionary) -> Array:
	var L = _arr(cb.c.get("fx")).duplicate()
	if int(cb.n) >= 3: L += _arr(cb.c.get("fx3"))
	return L
static func _link_tg(sim, cb: Dictionary, src: Dictionary, fx: Dictionary) -> Array:   # 合體技 fx.tg：members／allies／foes／all_r／near／back（fx 上可帶 shape、r）
	var tg = fx.get("tg")
	var o = []
	match J.str(tg):
		"members":
			for u in cb.m: if sim.alive(u): o.append([u, 1.0])
			return o
		"allies":
			for u in allies(sim, src): o.append([u, 1.0])
			return o
		"foes", "":
			if J.str(tg) == "" and J.str(fx.get("p")) in SELF_P:
				for u in cb.m: if sim.alive(u): o.append([u, 1.0])
				return o
			return select(sim, src, {"sel": "foes", "r": J.num(fx.get("r", 0))})
		"all_r": return select(sim, src, {"sel": "foes", "r": J.num(fx.get("r", 400))})
	var d = {"sel": J.str(tg)}
	for k in ["shape", "r", "n", "falloff", "deg", "len", "w"]: if fx.has(k): d[k] = fx[k]
	return select(sim, src, d)
static func _link_src(sim, cb: Dictionary) -> Dictionary:
	var ps = Vector2.ZERO; var n = 0; var atk = 0.0
	for u in cb.m:
		if u.get("p") is Vector2: ps += u.p; n += 1
		atk += _nn(u, "atk")
	return {"k": "", "atk": atk / maxf(1, cb.m.size()), "side": 0.0, "hp": 1.0, "maxhp": 1.0, "p": ps / maxf(1, n), "energy": 0.0, "minion": true, "range": 150.0, "link": true,
		"ab": {"tags": ["遠", "破"], "mech": [], "bf": [], "sc": [], "pas": [], "icd": {}, "n_att": 0, "star": 0}}
static func combo_list(sim) -> Array: return sim.ab_st.get("combo", []) if sim.ab_st is Dictionary else []
static func combo_cast(sim, i := 0) -> bool:   # 合體技按鈕（abui 接）
	var L = combo_list(sim)
	if i >= L.size(): return false
	var cb = L[i]
	if J.str(cb.get("kind", "strike")) == "aura": return false
	if J.num(cb.energy) < 100 or sim.result != null or sim.phase != "fight" or cb.cast != null: return false
	var alive_n = 0
	for u in cb.m: if _nn(u, "hp") > 0: alive_n += 1
	if alive_n < int(J.num(cb.c.get("need", 2))): return false
	cb["energy"] = 0.0; cb["cast"] = {"t": 0.0, "dur": 0.45}
	sim.events.append(["combo_cast", cb.c])
	return true
static func _combo_tick(sim, dt: float) -> void:
	for i in combo_list(sim).size():
		var cb = combo_list(sim)[i]
		var alive_n = 0
		for u in cb.m: if _nn(u, "hp") > 0: alive_n += 1
		var both = alive_n >= int(J.num(cb.c.get("need", 2)))
		if J.str(cb.get("kind")) == "aura":
			if both and not J.t(cb.get("on")): _aura_link_on(sim, cb)
			if J.t(cb.get("on")): _aura_link_tick(sim, cb, dt)
			continue
		if both: cb["energy"] = minf(100.0, J.num(cb.energy) + 5.0 * dt)
		if cb.cast == null and J.num(cb.energy) >= 100 and both and sim.auto: combo_cast(sim, i)
		if cb.cast != null:
			cb.cast["t"] = J.num(cb.cast.t) + dt
			if J.num(cb.cast.t) >= J.num(cb.cast.dur):
				cb["cast"] = null
				if both: _combo_fire(sim, cb)
static func _aura_link_on(sim, cb: Dictionary) -> void:   # 被動合體技：同場即生效（成場有效）
	cb["on"] = true
	var src = _link_src(sim, cb)
	for fx in _link_fx(cb):
		if not (fx is Dictionary): continue
		var f2 = (fx as Dictionary).duplicate()
		var p = J.str(f2.get("p"))
		var ts = _link_tg(sim, cb, src, f2)
		if f2.get("who") != null:
			var keep = []
			for pr in ts: if J.str(pr[0].get("k")) == J.str(f2.who): keep.append(pr)
			ts = keep
		if f2.get("dur") == null and p in ["buff", "immune", "shield"]: f2["dur"] = -1
		match p:
			"on_kill_heal", "on_kill_maxhp", "on_ally_down":
				for u in cb.m: A(u)[p] = f2
			"foe_summon_cd":
				for w in sim.units:
					if _nn(w, "side") == 1 and has_mech(w, "召喚"): add_bf(sim, w, {"id": "sum_cd", "p": "sum_cd", "stat": "energy", "v": -J.num(f2.get("v", 0.5)), "dur": -1, "neg": true})
				cb["sum_cd"] = J.num(f2.get("v", 0.5))
			"reveal_pulse": cb["pulse"] = f2; cb["pulse_t"] = 0.0
			_:
				var src2 = cb.m[0] if p in SELF_P else src
				prim(sim, src2, f2, ts, {"sk": false, "link": true, "kind": "aura"})
	sim.text(sim.center() + Vector2(0, -110), J.str(DB.L(J.str(cb.c.get("name")))), "#ffb0ff", 1.4, 18)
	sim.events.append(["combo", cb.c])
	ev(sim, "link_" + J.str(cb.c.get("id")), cb.a, cb.b)
static func _aura_link_tick(sim, cb: Dictionary, dt: float) -> void:
	if cb.get("pulse") is Dictionary:
		cb["pulse_t"] = J.num(cb.pulse_t) - dt
		if J.num(cb.pulse_t) <= 0:
			cb["pulse_t"] = J.num(cb.pulse.get("t", 6.0))
			for u in cb.m:
				if sim.alive(u) and u.get("p") is Vector2: _reveal(sim, u, u.p, J.num(cb.pulse.get("r", 180)), 3.0)
			ev(sim, "reveal_pulse", cb.a, null)
	if J.num(cb.get("sum_cd", 0)) > 0:   # 中途召喚出嚟嘅召喚者都減速
		for w in sim.units:
			if _nn(w, "side") == 1 and has_mech(w, "召喚") and not has_bf(sim, w, "sum_cd"): add_bf(sim, w, {"id": "sum_cd", "p": "sum_cd", "stat": "energy", "v": -J.num(cb.sum_cd), "dur": -1, "neg": true})
static func _combo_fire(sim, cb: Dictionary) -> void:
	var c = cb.c
	var src = _link_src(sim, cb)
	var L = _link_fx(cb)
	if L.size() and not J.t(c.get("leg")):
		var first = []
		for fx in L:
			if not (fx is Dictionary): continue
			var ts = _link_tg(sim, cb, src, fx) if fx.get("tg") != null else first
			if fx.get("tg") != null and first.is_empty(): first = ts
			if fx.get("tg") == null and first.is_empty(): ts = select(sim, src, {"sel": "foes"}); first = ts
			prim(sim, src, fx, ts, {"sk": true, "kind": "aoe", "aoe": true, "combo": true, "name": J.str(c.get("name"))})
	else:   # 舊 COMBOS：全場嚇彈起後重重摔下（battle.gd fire_combo）
		for v in foes(sim, src, true):
			hit(sim, src, v, J.num(c.get("mult", 2.0)), {"sk": true, "kind": "aoe", "aoe": true, "combo": true})
			if _nn(v, "hp") > 0 and cc_ok(sim, src, v, "down"):
				v.st["down"] = 1.6; v.st["downMax"] = 1.6; v.st["air"] = 0.0; v["anim"] = null
				_ground(sim, v)
	sim.text(sim.center() + Vector2(0, -120), J.str(DB.L(J.str(c.get("name")))), "#ffb0ff", 1.5, 22)
	sim._fx({"kind": "ring", "p": sim.center(), "life": 0.6, "col": "#ffb0ff"})
	sim.events.append(["combo", c])
	ev(sim, "combo", cb.a, cb.b)
	ev(sim, "link_" + J.str(c.get("id")), cb.a, cb.b)

# ================= 目標選擇器（ability.md 2.5） =================
# 回 Array of [單位, 倍數]
static func select(sim, u: Dictionary, tg) -> Array:
	if tg is String: tg = {"sel": tg}
	if not (tg is Dictionary): tg = {"sel": "near"}
	var sel = J.str(tg.get("sel", "near")); var shape = J.str(tg.get("shape", "single"))
	var up = _pos(sim, u)
	var area = shape != "single"
	var cand = foes(sim, u, false)
	var pri = null
	match sel:
		"self": return [[u, 1.0]]
		"allies":
			var o = []
			var r = J.num(tg.get("r", 0))
			for w in allies(sim, u): if r <= 0 or up.distance_to(w.p) <= r: o.append([w, 1.0])
			return o
		"ally_low":
			var bl = 2.0
			for w in allies(sim, u):
				var f = _nn(w, "hp") / maxf(1.0, _nn(w, "maxhp"))
				if f < bl: bl = f; pri = w
			return [[pri, 1.0]] if pri != null else []
		"foes", "all_r":
			var o2 = []
			var r2 = J.num(tg.get("r", 0))
			for w in foes(sim, u, true): if r2 <= 0 or up.distance_to(w.p) <= r2: o2.append([w, 1.0])
			return o2
		"far":
			var bd = -1.0
			for w in cand: var d = up.distance_to(w.p); if d > bd: bd = d; pri = w
		"low":
			var bl2 = 2.0
			for w in cand:
				var f2 = _nn(w, "hp") / maxf(1.0, _nn(w, "maxhp"))
				if f2 < bl2: bl2 = f2; pri = w
		"strong":
			var ba = -1.0
			for w in cand: if _nn(w, "atk") > ba: ba = _nn(w, "atk"); pri = w
		"back":   # 沿陣線軸最後面（炮台／施法者／遠程）
			var bb = -INF
			var axv: Vector2 = sim.ax if _nn(u, "side") == 0 else -sim.ax
			for w in cand: var q = (w.p as Vector2).dot(axv); if q > bb: bb = q; pri = w
		"boss":
			for w in cand: if J.t(w.get("boss")): pri = w; break
		"caster":
			for w in cand: if J.t(w.get("casting")): pri = w; break
		"flyer":
			for w in cand: if flying(sim, w): pri = w; break
		"summoner":
			for w in cand: if has_mech(w, "召喚"): pri = w; break
		"dense":   # 身邊最多敵人嗰隻
			var bc = -1
			var rr0 = J.num(tg.get("r", AOE_R))
			for w in cand:
				var n0 = 0
				for w2 in cand: if (w2.p as Vector2).distance_to(w.p) <= rr0: n0 += 1
				if n0 > bc: bc = n0; pri = w
		"first_low":
			for w in cand: if _nn(w, "hp") < J.num(tg.get("hp_pct", 0.3)) * _nn(w, "maxhp"): pri = w; break
			if pri == null: return []
		"ally_top":
			var bt = -1.0
			for w in allies(sim, u): if w != u and _nn(w, "atk") > bt: bt = _nn(w, "atk"); pri = w
			return [[pri, 1.0]] if pri != null else []
		_:
			if sel.begins_with("mech:"):
				var mm = norm_mech(sel.substr(5))
				for w in cand: if has_mech(w, mm): pri = w; break
	if pri == null:   # near（或者上面揀唔到）：最近
		var bn = 1e9
		var cur = u.get("tg")
		if sel == "near" and cur is Dictionary and cand.has(cur) and up.distance_to(cur.p) <= _nn(u, "range") + 60: pri = cur
		else:
			for w in cand: var d2 = up.distance_to(w.p); if d2 < bn: bn = d2; pri = w
	if pri == null: return []
	match shape:
		"circle":
			var r3 = J.num(tg.get("r", AOE_R)); var o3 = []
			for w in foes(sim, u, true): if (w.p as Vector2).distance_to(pri.p) <= r3: o3.append([w, 1.0])
			return o3
		"self_circle":
			var r4 = J.num(tg.get("r", AOE_R)); var o4 = []
			for w in foes(sim, u, true): if up.distance_to(w.p) <= r4: o4.append([w, 1.0])
			return o4
		"cone":
			var r5 = J.num(tg.get("r", 160)); var hd = deg_to_rad(J.num(tg.get("deg", 70)) * 0.5); var o5 = []
			var dir = ((pri.p as Vector2) - up).normalized()
			for w in foes(sim, u, true):
				var dv = (w.p as Vector2) - up
				if dv.length() <= r5 and (dv.length() < 1.0 or absf(dir.angle_to(dv)) <= hd): o5.append([w, 1.0])
			return o5
		"line":
			var L = J.num(tg.get("len", 220)); var wd = J.num(tg.get("w", 40)); var o6 = []
			var dir2 = ((pri.p as Vector2) - up).normalized()
			for w in foes(sim, u, true):
				var dv2 = (w.p as Vector2) - up; var along = dv2.dot(dir2)
				if along >= -10 and along <= L and absf(dv2.dot(Vector2(-dir2.y, dir2.x))) <= wd * 0.5: o6.append([w, 1.0])
			return o6
		"chain":
			var n = int(J.num(tg.get("n", 3))); var fo = J.num(tg.get("falloff", 0.8)); var rr = J.num(tg.get("r", 140))
			var o7 = [[pri, 1.0]]; var seen = [pri]; var cur2 = pri; var k = 1.0
			for i in n - 1:
				var nx = null; var bd2 = rr
				for w in foes(sim, u, true):
					if seen.has(w): continue
					var d3 = (w.p as Vector2).distance_to(cur2.p)
					if d3 <= bd2: bd2 = d3; nx = w
				if nx == null: break
				k *= fo; o7.append([nx, k]); seen.append(nx); cur2 = nx
			return o7
	return [[pri, 1.0]]

# ================= 放技能 =================
static func cast(sim, u: Dictionary, sk = null) -> void:
	if u.get("ab") == null: compile(sim, u)
	var a = A(u)
	sim.ab_log["cast"] = int(sim.ab_log.get("cast", 0)) + 1
	if _nn(u, "side") == 1 and has_mech(u, "召喚"):   # 機制「召喚」：嚇氣滿唔放技能，召 2 隻雜兵
		_summon_mech(sim, u); return
	var act = a.get("act")
	if not (act is Dictionary): return
	var tl = select(sim, u, act.get("tg", {"sel": "near"}))
	var tg = act.get("tg", {}); var shape = J.str(tg.get("shape", "single")) if tg is Dictionary else "single"
	var sel = J.str(tg.get("sel", "near")) if tg is Dictionary else "near"
	var area = shape != "single" or sel in ["foes", "all_r"]
	var sd = _nn(u, "side")
	var pri = tl[0][0] if tl.size() else null
	if pri != null and pri.get("p") is Vector2 and _nn(pri, "side") != sd:
		if area: sim._fx({"kind": "ring", "p": pri.p, "life": 0.5, "col": "#bbffff" if sd == 0 else "#ff99aa"})
		else:
			var d = signf((pri.p as Vector2).x - _pos(sim, u).x)
			sim._fx({"kind": "slash", "p": sim.head(pri).lerp(pri.p, 0.45), "dir": d if d != 0 else 1.0, "life": 0.22, "r": 34.0, "col": "#bbffff" if sd == 0 else "#ff99aa"})
	run_fx(sim, u, _arr(act.get("fx")), tl, {"sk": true, "kind": J.str(act.get("kind", "aoe" if area else "hit")), "aoe": area, "name": J.str(act.get("name"))})
	var kd = J.str(act.get("kind", "aoe" if area else "hit"))
	sim._vq(["skill", u, kd, pri if not area and pri != null and _nn(pri, "side") != sd else null])
	var at = sim.head(u) + Vector2(0, -34) if u.get("p") != null else sim.center() + Vector2(0, -120)
	sim.text(at, J.str(DB.L(J.str(act.get("name")))), "#bbffff" if sd == 0 else "#ff99aa", 1.1, 17)
	sim.events.append(["skill", u])
	for w in sim.units:   # 隊友放技：ally_cast 觸發
		if w != u and _nn(w, "side") == sd and sim.alive(w) and A(w).get("pas", []).size(): trig(sim, w, "ally_cast", u)
	# 名鬼放技：附近敵人嘅 foe_cast 觸發
	for w in sim.units:
		if _nn(w, "side") != sd and sim.alive(w) and A(w).get("pas", []).size() and _pos(sim, u).distance_to(w.p) <= 300: trig(sim, w, "foe_cast", u)
const CTX_TG := ["attacker", "killer", "target", "victim"]
static func run_fx(sim, u: Dictionary, L: Array, tl: Array, ctx: Dictionary, other = null) -> void:
	for fx in L:
		if not (fx is Dictionary): continue
		var ts = tl
		var o = fx.get("tg")
		if o is String and o in CTX_TG:
			ts = [[other, 1.0]] if other is Dictionary and _nn(other, "hp") > 0 else (tl if o == "target" else [])
		elif o is String and o == "first_low": ts = select(sim, u, {"sel": "first_low", "hp_pct": J.num(fx.get("hp_pct", 0.3))})
		elif o != null: ts = select(sim, u, o)
		if J.str(fx.get("p")) == "recast":
			if not J.t(ctx.get("recast")) and A(u).get("act") is Dictionary:
				var c2 = ctx.duplicate(); c2["recast"] = true; c2["rx"] = J.num(fx.get("x", 0.5))
				run_fx(sim, u, _arr(A(u).act.get("fx")), select(sim, u, A(u).act.get("tg", {"sel": "near"})), c2)
				ev(sim, "recast", u, null)
			continue
		prim(sim, u, fx, ts, ctx)
const SELF_P := ["shield", "heal", "hot", "buff", "immune", "cleanse", "energy", "stealth", "revive", "guard", "taunt", "anti_air", "splash", "pierce", "dash", "summon", "zone_self"]

# ================= 40 個積木 =================
static func prim(sim, u: Dictionary, fx: Dictionary, ts: Array, ctx: Dictionary) -> void:
	var p = J.str(fx.get("p")); var star = int(A(u).get("star", 0)); var t = sim.t
	var sd = _nn(u, "side")
	match p:
		# ---- 傷害類 ----
		"dmg":
			if fx.get("pct_hp") != null:   # 按目標最大血直接扣（反電）
				for pr in ts: if _nn(pr[0], "side") != sd: raw(sim, pr[0], _v(fx, "pct_hp", 0.05, star) * _nn(pr[0], "maxhp"), u)
				return
			var mult = _v(fx, "mult", 1.0, star) * (J.num(ctx.get("rx", 1.0)) if J.t(ctx.get("recast")) else 1.0); var hits = maxi(1, int(_v(fx, "hits", 1, star)))
			var c = ctx.duplicate()
			c["mult"] = mult; c["hits"] = hits
			if fx.get("vs_state") != null: c["follow"] = J.str(fx.vs_state); c["fol_x"] = _v(fx, "x", 1.8, star)
			if fx.get("vs_mech") is Dictionary: c["vs_mech"] = fx.vs_mech
			if fx.get("vs_tag") is Dictionary: c["vs_tag"] = fx.vs_tag
			if fx.get("vs_sys") is Dictionary: c["vs_sys"] = fx.vs_sys
			if fx.get("drain") != null: c["drain"] = _v(fx, "drain", 0.0, star)
			if fx.get("execute") is Dictionary: c["execute"] = fx.execute
			for pr in ts:
				var v = pr[0]
				for i in hits:
					if _nn(v, "hp") > 0: hit(sim, u, v, mult * J.num(pr[1]) / hits, c)
		"dot":   # 燒／毒／咒：每 0.5 秒扣 dps×atk×0.5，最多疊 3 層
			for pr in ts:
				var v = pr[0]
				if _nn(v, "side") == sd: continue
				add_bf(sim, v, {"id": "dot_" + J.str(fx.get("kind", "burn")), "p": "dot", "kind": J.str(fx.get("kind", "burn")), "v": _v(fx, "dps", 0.3, star) * _nn(u, "atk"), "dur": _v(fx, "dur", 4.0, star), "neg": true, "src": u, "tick": 0.0, "stack": 3})
				ev(sim, "dot", u, v)
		"execute":   # 斬殺：血 < hp_pct 直接 ×x
			for pr in ts:
				var v = pr[0]
				if _nn(v, "hp") > 0 and _nn(v, "hp") < _v(fx, "hp_pct", 0.25, star) * _nn(v, "maxhp"):
					var c4 = ctx.duplicate(); c4["exec"] = true
					hit(sim, u, v, _v(fx, "x", 3.0, star), c4)
					ev(sim, "execute", u, v)
		"chain":   # 彈射：由第一個目標跳 n 下
			var tl2 = select(sim, u, {"sel": "near", "shape": "chain", "n": _v(fx, "n", 3, star), "falloff": _v(fx, "falloff", 0.8, star), "r": _v(fx, "r", 140, star)}) if ts.size() <= 1 else ts
			for pr in tl2:
				if _nn(pr[0], "hp") > 0: hit(sim, u, pr[0], _v(fx, "mult", 1.0, star) * J.num(pr[1]), ctx)
			if tl2.size() > 1: ev(sim, "chain", u, tl2[tl2.size() - 1][0])
		"splash": A(u)["splash"] = {"r": _v(fx, "r", 60, star), "pct": _v(fx, "pct", 0.3, star)}; ev(sim, "splash", u, u)
		"mark":
			for pr in ts:
				if _nn(pr[0], "side") == sd: continue
				add_bf(sim, pr[0], {"id": "mark", "p": "mark", "stat": "taken", "v": _v(fx, "v", 0.25, star), "dur": _v(fx, "dur", 5.0, star), "neg": true}); ev(sim, "mark", u, pr[0])
		"pierce": A(u)["pierce"] = _v(fx, "v", 1.0, star); ev(sim, "pierce", u, u)
		# ---- 控場類 ----
		"down", "air", "push", "pull", "stun":
			for pr in ts:
				var v = pr[0]
				if _nn(v, "hp") <= 0 or _nn(v, "side") == sd: continue
				cc(sim, u, v, p, fx, star)
		"silence":
			for pr in ts:
				var v = pr[0]
				if _nn(v, "side") == sd or _nn(v, "hp") <= 0: continue
				if v.get("casting") != null: v["casting"] = null
				add_bf(sim, v, {"id": "silence", "p": "silence", "dur": _v(fx, "dur", 3.0, star), "neg": true}); ev(sim, "silence", u, v)
				sim.text(sim.head(v) + Vector2(0, -18), "封口", "#c4b5fd", 0.9)
		"interrupt":
			for pr in ts:
				var v = pr[0]
				if _nn(v, "side") == sd or _nn(v, "hp") <= 0: continue
				var was = v.get("casting") != null
				v["casting"] = null; v["energy"] = maxf(0.0, _nn(v, "energy") - 50.0)
				if was: A(v)["stun_until"] = maxf(J.num(A(v).get("stun_until", 0)), t + 1.0)
				ev(sim, "interrupt", u, v); sim.text(sim.head(v) + Vector2(0, -18), "打斷", "#c4b5fd", 0.9)
		"slow":
			for pr in ts:
				var v = pr[0]
				if _nn(v, "side") == sd: continue
				add_bf(sim, v, {"id": "slow", "p": "slow", "stat": "spd", "v": -_v(fx, "v", 0.4, star), "dur": _v(fx, "dur", 3.0, star), "neg": true})
				if _v(fx, "va", 0.0, star) > 0: add_bf(sim, v, {"id": "slow_a", "p": "slow", "stat": "aspd", "v": -_v(fx, "va", 0.0, star), "dur": _v(fx, "dur", 3.0, star), "neg": true})
				ev(sim, "slow", u, v)
		"flee":
			for pr in ts:
				var v = pr[0]
				if _nn(v, "side") == sd or _nn(v, "hp") <= 0 or not cc_ok(sim, u, v, "flee"): continue
				A(v)["flee_until"] = t + _v(fx, "dur", 2.0, star); A(v)["flee_from"] = _pos(sim, u)
				v["anim"] = null; v["casting"] = null; ev(sim, "flee", u, v)
		"taunt":
			var r = _v(fx, "r", 160, star)
			for w in foes(sim, u, true):
				if _pos(sim, u).distance_to(w.p) <= r:
					A(w)["taunt_by"] = u; A(w)["taunt_until"] = t + _v(fx, "dur", 3.0, star); w["tg"] = u
			add_bf(sim, u, {"id": "steady_t", "p": "steady", "dur": _v(fx, "dur", 3.0, star)})
			ev(sim, "taunt", u, u); sim.text(sim.head(u) + Vector2(0, -18), "嘲諷", "#93c5fd", 0.9)
		# ---- 防守／支援 ----
		"heal":
			for pr in _self_or(ts, u, sd):
				var w = pr[0]
				if _nn(w, "hp") <= 0: continue
				var h = (_v(fx, "pct", 0.0, star) * _nn(w, "maxhp") + _v(fx, "mult", 0.0, star) * _nn(u, "atk")) * stat(sim, w, "heal_in") * stat(sim, u, "heal_out")
				_heal(sim, w, h)
				if w.get("p") is Vector2: sim._fx({"kind": "ring", "p": w.p, "life": 0.5, "col": "#8affb0"})
			ev(sim, "heal", u, u)
		"hot":
			for pr in _self_or(ts, u, sd):
				add_bf(sim, pr[0], {"id": "hot", "p": "hot", "v": _v(fx, "pct", 0.03, star), "dur": _v(fx, "dur", 5.0, star), "tick": 0.0})
			ev(sim, "hot", u, u)
		"shield":
			for pr in _self_or(ts, u, sd):
				var w = pr[0]
				var wa = A(w)
				wa["shd"] = J.num(wa.get("shd", 0)) + _v(fx, "pct", 0.15, star) * _nn(w, "maxhp"); wa["shd_until"] = t + _v(fx, "dur", 6.0, star)
				ev(sim, "shield", u, w)
		"drain": pass   # 由 dmg 帶（ctx.drain）；獨立用時：下一下普攻吸血
		"guard":
			A(u)["guard"] = {"r": _v(fx, "r", 110, star), "pct": _v(fx, "pct", 0.4, star), "until": t + _v(fx, "dur", -1, star) if _v(fx, "dur", -1, star) > 0 else 1e9}
			ev(sim, "guard", u, u)
		"immune":
			for pr in _self_or(ts, u, sd):
				add_bf(sim, pr[0], {"id": "immune", "p": "immune", "tags": _arr(fx.get("tags")), "dur": _v(fx, "dur", 4.0, star)})
				if "fear_aura" in _arr(fx.get("tags")) or "confuse" in _arr(fx.get("tags")): add_bf(sim, pr[0], {"id": "steady", "p": "steady", "dur": _v(fx, "dur", 4.0, star)})
				ev(sim, "immune", u, pr[0])
		"cleanse":
			var n = int(_v(fx, "n", 9, star))
			for pr in _self_or(ts, u, sd):
				var w = pr[0]; var wa = A(w); var keep = []; var rm = 0
				for b in wa.get("bf", []):
					if J.t(b.get("neg")) and rm < n: rm += 1; continue
					keep.append(b)
				wa["bf"] = keep; wa["stun_until"] = 0.0; wa["flee_until"] = 0.0; wa["conf_until"] = 0.0
				if rm > 0: ev(sim, "cleanse", u, w)
		"revive":
			for pr in _self_or(ts, u, sd): A(pr[0])["revive"] = _v(fx, "pct", 0.4, star); ev(sim, "revive_set", u, pr[0])
		"buff":
			if J.str(fx.get("stat")) == "maxhp":
				for pr in _self_or(ts, u, sd):
					var w = pr[0]; var add = _nn(w, "maxhp") * _v(fx, "v", 0.1, star)
					w["maxhp"] = _nn(w, "maxhp") + add; w["hp"] = _nn(w, "hp") + maxf(0.0, add); ev(sim, "buff", u, w)
				return
			var tsb = _self_or(ts, u, sd) if _v(fx, "v", 0.2, star) >= 0 or ts.is_empty() or _nn(ts[0][0], "side") == sd else ts
			for pr in tsb:
				add_bf(sim, pr[0], {"id": "buff_" + J.str(fx.get("stat", "atk")), "p": "buff", "stat": J.str(fx.get("stat", "atk")), "v": _v(fx, "v", 0.2, star), "dur": _v(fx, "dur", 5.0, star)})
				ev(sim, "buff", u, pr[0])
		"energy":
			for pr in _self_or(ts, u, sd):
				pr[0]["energy"] = minf(100.0, _nn(pr[0], "energy") + _v(fx, "v", 30, star)); ev(sim, "energy", u, pr[0])
		# ---- 應對（克制）專用 ----
		"anti_air": A(u)["anti_air"] = _v(fx, "x", 1.25, star); ev(sim, "anti_air", u, u)
		"reveal":
			var rr = _v(fx, "r", 150, star)
			var c0 = ts[0][0].p if ts.size() and ts[0][0].get("p") is Vector2 else _pos(sim, u)
			_reveal(sim, u, c0, rr, _v(fx, "dur", 8.0, star))
		"armor_break":
			for pr in ts:
				if _nn(pr[0], "side") == sd: continue
				add_bf(sim, pr[0], {"id": "abreak", "p": "armor_break", "v": _v(fx, "v", 1.0, star), "dur": _v(fx, "dur", 6.0, star), "neg": true}); ev(sim, "armor_break", u, pr[0])
		"shield_break":
			for pr in ts:
				var v = pr[0]
				if _nn(v, "side") == sd: continue
				var va = A(v); var did = J.num(va.get("shd", 0)) > 0 or J.num(va.get("shell", 0)) > 0
				va["shd"] = 0.0
				if J.num(va.get("shell", 0)) > 0:
					va["shell"] = J.num(va.shell) - _v(fx, "pct", 0.5, star) * J.num(va.get("shell0", va.shell))
					if J.num(va.shell) <= 0: va["shell"] = 0.0; sim.text(sim.head(v) + Vector2(0, -20), "殼破", "#f97316", 1.0); ev(sim, "shell_break", u, v)
				if did: ev(sim, "shield_break", u, v)
		"dispel":
			for pr in ts:
				var v = pr[0]
				if _nn(v, "side") == sd: continue
				var va2 = A(v); var keep2 = []; var rm2 = 0; var n2 = int(_v(fx, "n", 9, star))
				for b in va2.get("bf", []):
					if not J.t(b.get("neg")) and rm2 < n2: rm2 += 1; continue
					keep2.append(b)
				va2["bf"] = keep2; va2["shd"] = 0.0
				if has_mech(v, "再生"): va2["regen_stop"] = t + mp("再生", "stop_s", 6.0)
				if has_mech(v, "嚇氣光環"): va2["aura_off"] = t + mp("嚇氣光環", "dispel_s", 5.0)
				ev(sim, "dispel", u, v)
		"banish":
			for pr in ts:
				var v = pr[0]
				if _nn(v, "side") == sd: continue
				var va3 = A(v)
				va3["no_rev"] = true
				if (J.t(va3.get("sum")) or J.t(v.get("sum"))) and _nn(v, "hp") > 0 and _nn(v, "hp") <= _v(fx, "hp_pct", 0.4, star) * _nn(v, "maxhp"):
					raw(sim, v, _nn(v, "hp") + 1.0, u, {"banish": true})
					sim.text(sim.head(v) + Vector2(0, -20), "收", "#e5e7eb", 1.0)
				ev(sim, "banish", u, v)
		"sap":
			for pr in ts:
				var v = pr[0]
				if _nn(v, "side") == sd: continue
				v["energy"] = maxf(0.0, _nn(v, "energy") - _v(fx, "v", 30, star))
				if has_mech(v, "再生"): A(v)["regen_stop"] = t + mp("再生", "stop_s", 6.0)
				ev(sim, "sap", u, v)
		"wound":
			for pr in ts:
				if _nn(pr[0], "side") == sd: continue
				add_bf(sim, pr[0], {"id": "wound", "p": "wound", "stat": "heal_in", "v": -_v(fx, "v", 0.6, star), "dur": _v(fx, "dur", 6.0, star), "neg": true}); ev(sim, "wound", u, pr[0])
		# ---- 位置／召喚 ----
		"dash":
			if not (u.get("p") is Vector2): return
			var to = J.str(fx.get("to", "back"))
			var tl3 = select(sim, u, {"sel": "back" if to == "back" else ("summoner" if to == "summoner" else "near")})
			if tl3.is_empty(): return
			var v = tl3[0][0]
			var dir = ((u.p as Vector2) - (v.p as Vector2)).normalized()
			if dir.length() < 0.1: dir = Vector2(0, 1)
			u["p"] = (v.p as Vector2) + dir * (_nn(u, "range") * 0.8 + 8.0); u["tg"] = v; u["anim"] = null
			A(u)["lock"] = v; A(u)["lock_until"] = t + 4.0
			sim._fx({"kind": "ring", "p": u.p, "life": 0.4, "col": "#ffffff"}); ev(sim, "dash", u, v)
		"stealth":
			add_bf(sim, u, {"id": "stealth", "p": "stealth", "dur": _v(fx, "dur", 3.0, star), "first_x": _v(fx, "first_x", 1.5, star)}); ev(sim, "stealth", u, u)
		"summon":
			var n3 = int(_v(fx, "n", 1, star))
			for i in n3:
				var k = J.str(fx.get("k", "youhun"))
				var c2 = {"side": sd, "k": k, "name": J.str(fx.get("name", "嘍囉")), "hp": _nn(u, "maxhp") * _v(fx, "hp_pct", 0.25, star), "atk": _nn(u, "atk") * _v(fx, "atk_pct", 0.35, star),
					"range": 38.0, "spd": 50.0, "energy": 0.0, "sk": null, "st": {}, "minion": sd == 0, "boss": false}
				c2["maxhp"] = c2.hp
				_spawn(sim, c2, _pos(sim, u) + Vector2(randf_range(-30, 30), randf_range(-12, 12)) + (sim.ax as Vector2) * (20.0 if sd == 0 else -20.0))
				if _v(fx, "dur", -1, star) > 0: A(c2)["expire"] = t + _v(fx, "dur", -1, star) * stat(sim, u, "summon_dur")
			ev(sim, "summon", u, u)
		"dmg_self":
			raw(sim, u, _v(fx, "pct", 0.1, star) * _nn(u, "maxhp"), null, {"self": true}); ev(sim, "dmg_self", u, u)
		"charm":   # 迷惑：目標轉頭打自己友
			for pr in ts:
				var v = pr[0]
				if _nn(v, "side") == sd or _nn(v, "hp") <= 0 or not cc_ok(sim, u, v, "charm"): continue
				A(v)["charm_until"] = t + _v(fx, "dur", 3.0, star); v["tg"] = null; v["anim"] = null
				sim.text(sim.head(v) + Vector2(0, -18), "迷惑", "#f9a8d4", 0.9); ev(sim, "charm", u, v)
		"confuse":
			for pr in ts:
				var v = pr[0]
				if _nn(v, "side") == sd or _nn(v, "hp") <= 0 or not cc_ok(sim, u, v, "confuse") or protected(sim, v): continue
				A(v)["conf_until"] = t + _v(fx, "dur", 2.5, star); A(v)["conf_dir"] = Vector2.from_angle(randf() * TAU)
				sim.text(sim.head(v) + Vector2(0, -18), "迷魂", "#d8b4fe", 0.9); ev(sim, "confuse_fx", u, v)
		"sap_lock":   # 鎖嚇氣：一段時間唔加嚇氣
			var tl5 = ts if ts.size() else select(sim, u, {"sel": "foes"})
			for pr in tl5:
				if _nn(pr[0], "side") == sd: continue
				add_bf(sim, pr[0], {"id": "sap_lock", "p": "sap_lock", "stat": "energy", "v": -1.0, "dur": _v(fx, "dur", 5.0, star), "neg": true})
			ev(sim, "sap_lock", u, null)
		"on_kill_heal", "on_kill_maxhp", "on_ally_down": A(u)[p] = fx; ev(sim, p + "_set", u, u)
		"foe_summon_cd":
			for w in sim.units:
				if _nn(w, "side") != sd and has_mech(w, "召喚"): add_bf(sim, w, {"id": "sum_cd", "p": "sum_cd", "stat": "energy", "v": -_v(fx, "v", 0.5, star), "dur": -1, "neg": true})
			ev(sim, "foe_summon_cd", u, null)
		"reveal_pulse": _reveal(sim, u, _pos(sim, u), _v(fx, "r", 180, star), 3.0)
		"coin":
			if sd == 0: sim.coins_won += _v(fx, "v", 10, star)
			ev(sim, "coin", u, u)
		"zone":
			var c3 = ts[0][0].p if ts.size() and ts[0][0].get("p") is Vector2 else _pos(sim, u)
			sim.ab_st.zones.append({"p": c3, "r": _v(fx, "r", 90, star), "until": t + _v(fx, "dur", 4.0, star), "fx": _arr(fx.get("fx")), "src": u, "acc": 0.0})
			sim._fx({"kind": "ring", "p": c3, "life": 0.6, "col": "#a3e635"}); ev(sim, "zone", u, u)
static func _self_or(ts: Array, u: Dictionary, sd: float) -> Array:   # 支援積木：目標係敵人就改為自己
	var o = []
	for pr in ts: if pr[0] is Dictionary and _nn(pr[0], "side") == sd: o.append(pr)
	return o if o.size() else [[u, 1.0]]
static func _heal(sim, w: Dictionary, h: float) -> void:
	if h <= 0 or _nn(w, "hp") <= 0: return
	w["hp"] = minf(_nn(w, "maxhp"), _nn(w, "hp") + h)
	if w.get("p") is Vector2: sim.text(sim.head(w) + Vector2(0, -10), "+" + J.str(J.round(h)), "#8affb0", 0.9)
static func _ground(sim, v: Dictionary) -> void:   # 飛行被腳軟／彈起／扯近＝拉落地 4 秒
	var a = A(v)
	if J.t(a.get("fly")) and J.num(a.get("ground_until", -1)) <= sim.t:
		a["ground_until"] = sim.t + mp("飛", "ground_s", 4.0)
		sim.text(sim.head(v) + Vector2(0, -20), "拉落地", "#a3e635", 1.0); ev(sim, "ground", null, v)
	elif J.t(a.get("fly")): a["ground_until"] = sim.t + mp("飛", "ground_s", 4.0)
static func _reveal(sim, src, c: Vector2, r: float, dur: float) -> void:
	var did = false
	for w in sim.units:
		if _nn(w, "side") == _nn(src, "side") or _nn(w, "hp") <= 0: continue
		if (w.p as Vector2).distance_to(c) > r: continue
		var wa = A(w)
		if J.t(wa.get("clone")):
			raw(sim, w, 99.0, src, {"reveal": true}); did = true; continue
		if has_mech(w, "隱") or has_bf(sim, w, "stealth"):
			if stealthed(sim, w): sim.text(sim.head(w) + Vector2(0, -20), "現形", "#fde68a", 1.0)
			wa["rev_until"] = maxf(J.num(wa.get("rev_until", 0)), sim.t + dur)
			var keep = []
			for b in wa.get("bf", []): if J.str(b.get("p")) != "stealth": keep.append(b)
			wa["bf"] = keep; did = true
	if did: ev(sim, "reveal", src, null)
static func cc(sim, src, v: Dictionary, kind: String, fx := {}, star := 0) -> bool:
	if not cc_ok(sim, src, v, kind):
		if has_mech(v, "霸體"): sim.text(sim.head(v) + Vector2(0, -20), "霸體", "#fca5a5", 0.8); ev(sim, "cc_immune", src, v)
		return false
	var sp = _pos(sim, src)
	match kind:
		"air": v.st["air"] = _v(fx, "dur", 1.0, star) * stat(sim, v, "cc_taken"); v.st["airMax"] = v.st.air; v.st["down"] = 0.0
		"down": v.st["down"] = _v(fx, "dur", 1.4, star) * stat(sim, v, "cc_taken"); v.st["downMax"] = v.st.down; v.st["air"] = 0.0
		"push":
			var dist = _v(fx, "dist", 40.0, star)
			v.st["push"] = dist / 160.0
			v["pushD"] = ((v.p as Vector2) - sp).normalized() if (v.p as Vector2).distance_to(sp) > 0.5 else Vector2(1, 0)
		"pull":
			var dist2 = _v(fx, "dist", 60.0, star)
			v.st["push"] = dist2 / 160.0
			v["pushD"] = (sp - (v.p as Vector2)).normalized() if (v.p as Vector2).distance_to(sp) > 0.5 else Vector2(-1, 0)
		"stun":
			A(v)["stun_until"] = maxf(J.num(A(v).get("stun_until", 0)), sim.t + _v(fx, "dur", 1.2, star))
	v["anim"] = null
	if kind in ["down", "air", "pull"]: _ground(sim, v)
	if kind in ["down", "pull", "stun"]: A(v)["rush_off"] = true
	if kind in ["pull", "stun"]: ev(sim, kind, src, v)
	return true

# ================= 受擊管線（取代舊 hit；ab 開先行） =================
static func hit(sim, src: Dictionary, v: Dictionary, mult: float, c = null) -> float:
	if not (c is Dictionary):
		c = {}
	elif c.has("kind") and not c.has("sk") and not c.has("aoe"):   # 舊式 sk 字典（其他程式直接叫 op.hit）
		var lg = c; c = {"sk": true, "kind": J.str(lg.get("kind")), "mult": J.num(lg.get("mult")), "hits": int(J.num(lg.get("hits"))) if J.t(lg.get("hits")) else 1,
			"follow": lg.get("follow"), "drain": J.num(lg.get("drain")), "apply": lg.get("apply"), "sap": J.num(lg.get("sap")), "aoe": J.str(lg.get("kind")) == "aoe"}
	if _nn(v, "hp") <= 0: return 0.0
	if v.get("ab") == null: compile(sim, v)
	if src.get("ab") == null: compile(sim, src)
	var sk = J.t(c.get("sk")); var aoe = J.t(c.get("aoe"))
	var sa = A(src); var va = A(v)
	if not sk and not J.t(c.get("splash")):   # 閃避（buff dodge／dodge_ranged）對命中（buff hit）
		var miss = (stat(sim, v, "dodge") - 1.0) + ((stat(sim, v, "dodge_ranged") - 1.0) if ranged(src) else 0.0) - (stat(sim, src, "hit") - 1.0)
		if miss > 0 and randf() < miss:
			if v.get("p") is Vector2: sim.text(sim.head(v) + Vector2(0, -14), "閃", "#e5e7eb", 0.6)
			ev(sim, "dodge", src, v)
			return 0.0
	var sd = _nn(src, "side"); var vsd = _nn(v, "side")
	var mod = 1.0
	var tag = null; var tcol = "#e8d0ff"; var chain = false; var tp = null
	var rw = sim.rw
	# ---- 第一層：嚇法相剋 ----
	if is_hero(src) and vsd == 1 and J.str(c.get("kind")) != "heal":
		var ts = sa.get("sc", [])
		if ts.size():
			var f = fear_of(v.get("k"))
			for x in ts: if f.w.has(x): tp = x; break
			if tp == null:
				for x in ts: if not f.i.has(x): tp = x; break
			if tp == null: tp = ts[0]
			var wd = word(tp)
			var marked = v.get("fearT") is Dictionary and J.num(v.fearT.until) > sim.t
			if sk:
				if rw != null: mod *= 1 + 0.05 * (J.num(J.mc(rw, "drillLv", [src.get("k")])) - 1)
				if f.i.has(tp): mod *= 0.6; tag = "不怕" + wd; tcol = "#9aa"
				elif f.w.has(tp):
					mod *= 1.35
					if marked and v.fearT.t != tp: mod *= 1.8; chain = true; tag = "%s＋%s・連嚇" % [word(v.fearT.t), wd]; tcol = "#ffd84a"
					else: tag = "怕%s・失神" % wd
					v["fearT"] = {"t": tp, "until": sim.t + 3.2}
				elif marked and v.fearT.t != tp: mod *= 1.3; tag = "追嚇"; tcol = "#ffe8a0"
			else:   # 普攻也吃克制（counter.md 3.5）
				if f.i.has(tp): mod *= 0.8
				elif f.w.has(tp): mod *= 1.15
	elif sd == 1 and is_hero(v) and sk:   # 敵人技能打名鬼：敵方嚇法 vs 名鬼嘅系 ×1.25／×0.75
		var es = sa.get("sc", [])
		var hs = J.str(va.get("sys", ""))
		if es.size() and SYS.has(hs):
			if (SYS[hs].w as Array).has(es[0]): mod *= 1.25
			elif (SYS[hs].i as Array).has(es[0]): mod *= 0.75
	# ---- 追擊（舊 follow）：霸體唔成立（「破」照計） ----
	var combo_hit = false
	var fol = c.get("follow")
	if fol != null and J.str(fol) != "" and sim._state(v) == J.str(fol):
		if not has_mech(v, "霸體") or has_tag(src, "破"): mod *= J.num(c.get("fol_x", 1.8)); combo_hit = true
	# ---- 第二層：機制 ----
	if c.get("vs_mech") is Dictionary:
		for m in c.vs_mech: if has_mech(v, norm_mech(m)): mod *= J.num(c.vs_mech[m])
	if c.get("vs_sys") is Dictionary and c.vs_sys.has(J.str(va.get("sys", ""))): mod *= J.num(c.vs_sys[J.str(va.sys)])
	if J.num(stat(sim, v, "taken_melee")) != 1.0 and not ranged(src): mod *= stat(sim, v, "taken_melee")
	if c.get("vs_tag") is Dictionary:
		for tg in c.vs_tag: if has_tag(v, norm_tag(tg)): mod *= J.num(c.vs_tag[tg])
	if c.get("execute") is Dictionary and _nn(v, "hp") < J.num(c.execute.get("hp_pct", 0.25)) * _nn(v, "maxhp"): mod *= J.num(c.execute.get("x", 2.0)); ev(sim, "execute", src, v)
	if flying(sim, v):
		if J.num(sa.get("anti_air", 0)) > 0: mod *= J.num(sa.anti_air)
		elif ranged(src): pass
		else: mod *= mp("飛", "aoe", 0.7) if aoe else mp("飛", "melee", 0.3)
	if aoe and stealthed(sim, v): mod *= mp("隱", "aoe", 0.5)
	if aoe and J.t(v.get("small")): mod *= mp("散骨", "aoe_x", 3.0)   # 碎骨一掃就散（「掃」應對散骨）
	var sb = get_bf(sim, src, "stealth")
	if sb != null and not sk:   # 隱身首擊
		mod *= J.num(sb.get("first_x", 1.5))
		var keep = []
		for b in sa.bf: if b != sb: keep.append(b)
		sa["bf"] = keep
		ev(sim, "stealth_hit", src, v)
	mod *= stat(sim, v, "taken")
	mod = clampf(mod, CAP_LO, CAP_HI)
	# ---- 傷害 ----
	var bonus = 1.0
	if sd == 0 and sim.adviser is Dictionary: bonus = 1.0 + minf(ADV_CAP, J.num(sim.adviser.get("bonus")))
	var atk = _nn(src, "atk") * stat(sim, src, "atk")
	if sd == 0 and J.t(src.get("minion")) and J.t(sa.get("in_fear")): atk *= mp("嚇氣光環", "minion_atk", 0.8)
	var dmg = J.round(atk * mult * mod * bonus * (0.9 + randf() * 0.2))
	var dmg_hp = float(dmg)
	# 護衛：我方陰兵小隊受傷，部份轉去身邊有「護衛」嘅名鬼
	if vsd == 0 and J.t(v.get("minion")) and dmg_hp > 0:
		var gu = _guard_of(sim, v)
		if gu != null:
			var tr = dmg_hp * J.num(A(gu).guard.pct)
			dmg_hp -= tr; raw(sim, gu, tr, src, {"guard": true}); ev(sim, "guard", gu, v)
	# 護盾
	if J.num(va.get("shd", 0)) > 0 and dmg_hp > 0:
		if J.num(va.get("shd_until", 1e9)) <= sim.t: va["shd"] = 0.0
		else:
			var ab_ = minf(J.num(va.shd), dmg_hp)
			va["shd"] = J.num(va.shd) - ab_; dmg_hp -= ab_
			ev(sim, "shield_hit", src, v)
	# 殼：殼未破前受傷 ×0.5（全部食落殼）；「破」：多段 ×3、重擊 ×2
	var shell_hit = false
	if J.num(va.get("shell", 0)) > 0 and dmg_hp > 0 and not J.t(c.get("exec")):
		var k = 1.0
		if sk and int(J.num(c.get("hits", 1))) >= 2: k = mp("殼", "multi_x", 3.0)
		elif sk and J.num(c.get("mult", mult)) >= mp("殼", "heavy_mult", 1.8): k = mp("殼", "heavy_x", 2.0)
		if has_tag(src, "破"): k = maxf(k, mp("殼", "heavy_x", 2.0))
		var abk = get_bf(sim, v, "armor_break")
		if abk != null: k *= 1.0 + J.num(abk.get("v", 1.0))
		if J.num(sa.get("pierce", 0)) > 0 and not sk: k *= 1.0 + J.num(sa.pierce)
		var sdm = dmg_hp * mp("殼", "taken", 0.5) * k
		va["shell"] = J.num(va.shell) - sdm; shell_hit = true
		dmg_hp = 0.0
		if J.num(va.shell) <= 0:
			dmg_hp = -J.num(va.shell) / k; va["shell"] = 0.0
			sim.text(sim.head(v) + Vector2(0, -20), "殼破", "#f97316", 1.0); ev(sim, "shell_break", src, v)
	if sim.cosmetic and vsd == 0: v["hp"] = maxf(_nn(v, "maxhp") * 0.25, _nn(v, "hp") - dmg_hp)
	else: v["hp"] = _nn(v, "hp") - dmg_hp
	# ---- 畫面（同舊 hit 一樣） ----
	var sp: Vector2 = src.get("p", v.p) if src.get("p") is Vector2 else v.p
	var dir = signf((v.p as Vector2).x - sp.x)
	if dir == 0: dir = 1.0 if vsd != 0 else -1.0
	v["flash"] = 1.0; v["kbDir"] = -dir if J.str(src.get("k")) == "heiwu" else dir; v["kbT"] = 0.0
	if not J.t(v.get("anim")) and not J.t(v.get("casting")): v["hurtT"] = 0.25
	var hp_ = sim.head(v)
	sim.spark(hp_.lerp(v.p, 0.45) - Vector2(dir * 5, 0), 1.35 if combo_hit or sk else (0.7 if J.t(v.get("minion")) else 1.0), "#ff9a7a" if vsd == 0 else ("#ffd84a" if combo_hit else "#fff4c0"))
	sim._fx({"kind": "num", "p": hp_ + Vector2((randf() - 0.5) * 14, -6), "vx": dir * (14 + randf() * 18), "text": J.str(J.round(dmg_hp)) if not shell_hit or dmg_hp > 0 else "殼", "life": 0.95,
		"col": "#ffd84a" if combo_hit else ("#9aa" if shell_hit else ("#ff8a8a" if vsd == 0 else "#ffffff")), "big": combo_hit or sk})
	if tag != null: sim.text(hp_ + Vector2(0, -22), tag, tcol)
	if chain: sim.text(sim.center() + Vector2(0, -90), "連嚇！", "#ffd84a", 1.2, 20)
	# ---- 舊式 apply（直接叫 op.hit 嗰啲） ----
	if c.get("apply") != null and J.str(c.apply) != "" and _nn(v, "hp") > 0: cc(sim, src, v, J.str(c.apply))
	if J.num(c.get("drain", 0)) > 0: _heal_quiet(src, dmg_hp * J.num(c.drain) * stat(sim, src, "heal_in"))
	if J.num(c.get("sap", 0)) > 0: v["energy"] = maxf(0.0, _nn(v, "energy") - J.num(c.sap))
	if not sk: src["energy"] = minf(100.0, _nn(src, "energy") + 8 * emul(sim, src))
	v["energy"] = minf(100.0, _nn(v, "energy") + 4 * emul(sim, v))
	# ---- 機制應對：凍停回血、照現形、鬼臉驅散光環、拉落地 ----
	if has_mech(v, "再生") and (tp == "cold" or J.num(c.get("sap", 0)) > 0): va["regen_stop"] = sim.t + mp("再生", "stop_s", 6.0)
	if has_tag(src, "照") and vsd != sd and v.get("p") is Vector2: _reveal_hit(sim, src, v)
	if tp == "face" and has_mech(v, "嚇氣光環") and J.num(va.get("aura_off", 0)) <= sim.t: va["aura_off"] = sim.t + mp("嚇氣光環", "dispel_s", 5.0); sim.text(hp_ + Vector2(0, -36), "光環散", "#fde68a", 1.0); ev(sim, "aura_off", src, v)
	if sk and has_tag(src, "拉") and flying(sim, v) and _nn(v, "hp") > 0: _ground(sim, v)
	# 反傷：近戰命中反彈 20%（遠程唔反彈）
	if has_mech(v, "反傷") and not ranged(src) and not J.t(c.get("thorn")) and dmg > 0 and _nn(src, "hp") > 0 and src.get("p") is Vector2:
		raw(sim, src, float(dmg) * mp("反傷", "pct", 0.2), v, {"thorn": true}); ev(sim, "thorns", v, src)
	if _nn(v, "hp") <= 0:
		sim.ab_down(v, dir)
		on_down(sim, v, src, c)
	sim._vq(["hit", src, v, sk or combo_hit, _nn(v, "hp") <= 0])
	sim.events.append(["hit", v])
	# ---- 觸發（depth ≤ 1） ----
	if int(sim.ab_st.get("depth", 0)) == 0:
		sim.ab_st["depth"] = 1
		if not sk and not J.t(c.get("splash")):
			sa["n_att"] = int(sa.get("n_att", 0)) + 1
			trig(sim, src, "attack", v)
			if sa.get("splash") is Dictionary and v.get("p") is Vector2:
				for w in foes(sim, src, true):
					if w != v and (w.p as Vector2).distance_to(v.p) <= J.num(sa.splash.r): hit(sim, src, w, mult * J.num(sa.splash.pct), {"splash": true})
		if _nn(v, "hp") > 0: trig(sim, v, "hit_taken", src)
		sim.ab_st["depth"] = 0
	return dmg
static func _heal_quiet(u: Dictionary, h: float) -> void:
	if h > 0 and _nn(u, "hp") > 0: u["hp"] = minf(_nn(u, "maxhp"), _nn(u, "hp") + h)
static func _reveal_hit(sim, src, v: Dictionary) -> void:
	var need = false
	for w in sim.units:
		if _nn(w, "side") == _nn(v, "side") and _nn(w, "hp") > 0 and (J.t(A(w).get("clone")) or has_mech(w, "隱") or has_bf(sim, w, "stealth")) and (w.p as Vector2).distance_to(v.p) <= mp("隱", "reveal_r", 150.0):
			if J.t(A(w).get("clone")) or stealthed(sim, w) or J.num(A(w).get("rev_until", 0)) < sim.t + 2.0: need = true; break
	if need: _reveal(sim, src, v.p, mp("隱", "reveal_r", 150.0), mp("隱", "reveal_s", 8.0))
static func _guard_of(sim, v: Dictionary):
	for w in sim.units:
		if _nn(w, "side") != _nn(v, "side") or w == v or not sim.alive(w): continue
		var g = A(w).get("guard")
		if g is Dictionary and J.num(g.until) > sim.t and (w.p as Vector2).distance_to(v.p) <= J.num(g.r): return w
	return null
static func raw(sim, v: Dictionary, amt: float, src, c := {}) -> void:   # 直接扣血（dot、反傷、護衛轉移、收魂）：唔再計倍率、唔觸發
	if _nn(v, "hp") <= 0 or amt <= 0: return
	if sim.cosmetic and _nn(v, "side") == 0: v["hp"] = maxf(_nn(v, "maxhp") * 0.25, _nn(v, "hp") - amt)
	else: v["hp"] = _nn(v, "hp") - amt
	if v.get("p") is Vector2 and amt >= 1.0 and not J.t(c.get("quiet")):
		sim._fx({"kind": "num", "p": sim.head(v) + Vector2((randf() - 0.5) * 14, -2), "vx": 0.0, "text": J.str(J.round(amt)), "life": 0.7, "col": "#c4b5fd" if not J.t(c.get("thorn")) else "#fca5a5", "big": false})
	if _nn(v, "hp") <= 0:
		var dir = 1.0
		if src is Dictionary and src.get("p") is Vector2 and v.get("p") is Vector2: dir = signf((v.p as Vector2).x - (src.p as Vector2).x)
		sim.ab_down(v, dir if dir != 0 else 1.0)
		on_down(sim, v, src if src is Dictionary else {}, c)

# ================= 倒下：屍變、散骨、返生、觸發、記錄 =================
static func on_down(sim, v: Dictionary, src: Dictionary, c: Dictionary) -> void:
	var va = A(v)
	var sd = _nn(v, "side")
	# 返生（積木 revive，一次）
	if J.num(va.get("revive", 0)) > 0 and not J.t(va.get("no_rev")):
		sim.ab_st.pend.append({"u": v, "at": sim.t + 1.5, "pct": J.num(va.revive), "kind": "revive"}); va["revive"] = 0.0
		return
	# 屍變：場上有「收」／最後一擊係名鬼技能 → 唔再起
	if has_mech(v, "屍變") and not J.t(va.get("rev_used")):
		var seal = J.t(va.get("no_rev")) or (J.t(c.get("sk")) and is_hero(src))
		var sealer = null
		if not seal:
			for w in sim.units:
				if _nn(w, "side") != sd and sim.alive(w) and has_tag(w, "收"): seal = true; sealer = w; break
		va["rev_used"] = true
		if seal:
			sim.text(sim.head(v) + Vector2(0, -24), "收", "#e5e7eb", 1.1); ev(sim, "seal", sealer if sealer != null else src, v)
		else:
			sim.ab_st.pend.append({"u": v, "at": sim.t + mp("屍變", "delay", 4.0), "pct": mp("屍變", "hp", 0.5), "kind": "undead"})
			sim.text(sim.head(v) + Vector2(0, -24), "屍變…", "#fca5a5", 1.1); ev(sim, "undead_wait", src, v)
			return
	# 散骨：死後散成 3 隻 25% 血小怪（唔再散）
	if has_mech(v, "散骨") and not J.t(va.get("sum")):
		for i in int(mp("散骨", "n_split", 3)):
			var m = {"side": sd, "k": J.str(v.get("k")), "name": J.str(v.get("name")) + "碎", "hp": _nn(v, "maxhp") * mp("散骨", "hp", 0.25), "atk": _nn(v, "atk") * mp("散骨", "atk", 0.4),
				"range": 46.0, "spd": _nn(v, "spd"), "energy": 0.0, "sk": null, "st": {}, "boss": false, "small": true}
			m["maxhp"] = m.hp
			_spawn(sim, m, (v.p as Vector2) + Vector2(cos(i * 2.1) * 26.0, sin(i * 2.1) * 12.0))
		ev(sim, "split", src, v)
	if J.t(va.get("sum")) or J.t(v.get("sum")): pass
	trig(sim, src, "kill", v)
	if src is Dictionary and _nn(src, "side") != sd:
		var okh = A(src).get("on_kill_heal")
		if okh is Dictionary:
			for w in sim.units: if is_hero(w) and sim.alive(w): _heal_quiet(w, _nn(w, "maxhp") * J.num(okh.get("pct", 0.03)))
			ev(sim, "on_kill_heal", src, v)
		var okm = A(src).get("on_kill_maxhp")
		if okm is Dictionary and int(A(src).get("okm_n", 0)) < int(J.num(okm.get("cap", 5))):
			A(src)["okm_n"] = int(A(src).get("okm_n", 0)) + 1
			var add = _nn(src, "maxhp") * J.num(okm.get("v", 0.03)); src["maxhp"] = _nn(src, "maxhp") + add; src["hp"] = _nn(src, "hp") + add
			ev(sim, "on_kill_maxhp", src, v)
	for w in sim.units:
		if w != v and _nn(w, "side") == sd and sim.alive(w) and A(w).get("on_ally_down") is Dictionary:
			var oad = A(w).on_ally_down
			add_bf(sim, w, {"id": "oad", "p": "buff", "stat": J.str(oad.get("stat", "atk")), "v": J.num(oad.get("v", 0.2)), "dur": -1, "stack": 5}); ev(sim, "on_ally_down", w, v)
	for w in sim.units:
		if w != v and _nn(w, "side") == sd and sim.alive(w) and A(w).get("pas", []).size(): trig(sim, w, "ally_down", v)
	trig(sim, v, "death", src)
	if sd == 1:
		sim.ab_log.kills.append({"k": J.str(v.get("k")), "sum": J.t(va.get("sum")) or J.t(v.get("sum")), "boss": J.t(v.get("boss"))})
static func pending(sim, side: int) -> int:   # 等緊屍變／返生嘅（勝負判定要計）
	if not (sim.ab_st is Dictionary): return 0
	var n = 0
	for p in sim.ab_st.get("pend", []): if int(_nn(p.u, "side")) == side: n += 1
	return n

# ================= 觸發（ability.md 2.3） =================
static func trig(sim, u, tr: String, other = null) -> void:
	if not (u is Dictionary): return
	var a = A(u)
	var L = a.get("pas", [])
	if L.is_empty(): return
	for i in L.size():
		var pe = L[i]
		if J.str(pe.get("tr")) != tr: continue
		var key = str(i)
		if J.num(a.icd.get(key, -1e9)) > sim.t: continue
		if tr == "attack" and int(J.num(pe.get("n", 1))) > 1 and int(a.get("n_att", 0)) % int(J.num(pe.n)) != 0: continue
		if tr == "low_hp":
			if J.t(a.get("low_" + key)) or _nn(u, "hp") > J.num(pe.get("pct", 0.35)) * _nn(u, "maxhp"): continue
			a["low_" + key] = true
		if pe.get("chance") != null and randf() > J.num(pe.chance): continue
		a.icd[key] = sim.t + J.num(pe.get("icd", 1.0))
		var ts = []
		if pe.get("tg") != null: ts = select(sim, u, pe.tg)
		elif other is Dictionary and _nn(other, "side") != _nn(u, "side") and sim.alive(other): ts = [[other, 1.0]]
		else: ts = select(sim, u, {"sel": "near"})
		for fx in _arr(pe.get("fx")):
			if not (fx is Dictionary): continue
			var t2 = ts
			if fx.get("tg") == null and J.str(fx.get("p")) in SELF_P: t2 = [[u, 1.0]]
			run_fx(sim, u, [fx], t2, {"sk": false, "pas": true, "kind": "pas"}, other)
		ev(sim, "trig_" + tr, u, other)

# ================= 每格：單位（喺 _step_fight 每隻單位開頭；回 true＝今格唔郁） =================
static func tick_unit(sim, u: Dictionary, dt: float) -> bool:
	var a = A(u)
	if a.is_empty(): return false
	var t = sim.t
	# buff 到期、dot、hot
	if (a.bf as Array).size():
		var keep = []
		for b in a.bf:
			if J.num(b.until) <= t: continue
			var p = J.str(b.get("p"))
			if p == "dot" or p == "hot":
				b["tick"] = J.num(b.get("tick", 0)) + dt
				if J.num(b.tick) >= 0.5:
					b["tick"] = J.num(b.tick) - 0.5
					if p == "dot": raw(sim, u, J.num(b.v) * 0.5, b.get("src"), {"dot": true})
					else: _heal_quiet(u, J.num(b.v) * _nn(u, "maxhp") * 0.5 * stat(sim, u, "heal_in"))
			keep.append(b)
		a["bf"] = keep
		if _nn(u, "hp") <= 0: return true
	var shb = stat(sim, u, "self_hurt") - 1.0
	if shb > 0: raw(sim, u, _nn(u, "maxhp") * shb * dt, null, {"dot": true, "quiet": true})
	if _nn(u, "hp") <= 0: return true
	# 召喚物到時消失
	if J.num(a.get("expire", 0)) > 0 and J.num(a.expire) <= t: raw(sim, u, _nn(u, "hp") + 1, null, {"expire": true}); return true
	# 再生：每秒回 2.5%（王 1.5%）；削／凍／驅散停 6 秒；重創減
	if has_mech(u, "再生") and J.num(a.get("regen_stop", -1)) <= t and _nn(u, "hp") < _nn(u, "maxhp"):
		var rate = mp("再生", "boss_rate", 0.015) if J.t(u.get("boss")) else mp("再生", "rate", 0.025)
		_heal_quiet(u, _nn(u, "maxhp") * rate * dt * stat(sim, u, "heal_in"))
	# 速度、攻速
	var sm = stat(sim, u, "spd")
	if J.num(a.get("spd0", 0)) > 0: u["spd"] = J.num(a.spd0) * sm
	var am = stat(sim, u, "aspd")
	if am != 1.0 and u.get("cd") != null: u["cd"] = _nn(u, "cd") - dt * (am - 1.0)
	if has_bf(sim, u, "silence") and u.get("casting") != null: u["casting"] = null
	# 定身
	if J.num(a.get("stun_until", 0)) > t:
		u["anim"] = null; u["walking"] = false
		if u.get("casting") != null: u["casting"] = null
		return true
	# 驚走：背向攻擊者行
	if J.num(a.get("flee_until", 0)) > t and u.get("p") is Vector2:
		var away = (u.p as Vector2) - (a.get("flee_from", u.p) as Vector2)
		if away.length() < 1: away = Vector2(randf() - 0.5, randf() - 0.5)
		u["p"] = (u.p as Vector2) + away.normalized() * _nn(u, "spd") * dt; u["walking"] = true; u["anim"] = null
		return true
	# 迷魂：亂走
	if J.num(a.get("conf_until", 0)) > t and u.get("p") is Vector2:
		var wd = a.get("conf_dir", Vector2(1, 0))
		u["p"] = (u.p as Vector2) + (wd as Vector2) * _nn(u, "spd") * 0.7 * dt; u["walking"] = true; u["anim"] = null
		if u.get("casting") != null: u["casting"] = null
		return true
	return false

# 揀目標補丁（_line_tg 之後）：嘲諷、突襲、「刺」斬召喚者、隱身唔揀得、突進鎖定
static func pick_fix(sim, u: Dictionary, tg):
	var a = A(u)
	if a.is_empty(): return tg
	var t = sim.t
	if J.num(a.get("charm_until", 0)) > t:   # 迷惑：打自己友
		var bn0 = 1e9; var nb0 = null
		for w in sim.units:
			if w != u and _nn(w, "side") == _nn(u, "side") and sim.alive(w):
				var d0 = (u.p as Vector2).distance_to(w.p)
				if d0 < bn0: bn0 = d0; nb0 = w
		if nb0 != null: u["tg"] = nb0; return nb0
	var tb = a.get("taunt_by")
	if tb is Dictionary and J.num(a.get("taunt_until", 0)) > t and sim.alive(tb): u["tg"] = tb; return tb
	var lk = a.get("lock")
	if lk is Dictionary and J.num(a.get("lock_until", 0)) > t and targetable(sim, u, lk): u["tg"] = lk; return lk
	if _nn(u, "side") == 1 and J.t(a.get("rush")) and not J.t(a.get("rush_off")):
		var best = null; var bk = 1e9
		var up: Vector2 = u.p
		for w in sim.units:   # 「定」吸引突襲者（400px 內）；冇就衝我方遠程／名鬼
			if _nn(w, "side") == 0 and sim.alive(w) and (has_tag(w, "定") or has_bf(sim, w, "steady")) and up.distance_to(w.p) < 400 and up.distance_to(w.p) < bk: bk = up.distance_to(w.p); best = w
		if best == null:
			var bb = -INF
			for w in sim.units:
				if _nn(w, "side") != 0 or not sim.alive(w) or J.t(w.get("minion")): continue
				var q = (2.0 if _nn(w, "range") > 60 else 1.0) * 1000.0 - up.distance_to(w.p)
				if q > bb: bb = q; best = w
		if best != null:
			if not J.t(a.get("rush_said")): a["rush_said"] = true; sim.text(sim.head(u) + Vector2(0, -20), "突襲！", "#fca5a5", 1.0); ev(sim, "rush", u, best)
			u["tg"] = best; return best
	if is_hero(u) and has_tag(u, "刺"):
		for w in sim.units:
			if _nn(w, "side") == 1 and has_mech(w, "召喚") and targetable(sim, u, w): u["tg"] = w; return w
	if tg is Dictionary and not targetable(sim, u, tg):
		var bn = 1e9; var nb = null
		for w in foes(sim, u, false):
			var d = (u.p as Vector2).distance_to(w.p)
			if d < bn: bn = d; nb = w
		u["tg"] = nb
		return nb
	return tg

# 嚇氣增長倍數（_step_fight 嚇氣、hit 嚇氣）：封口 0、嚇氣光環 ×0.5（「定」保護）、buff energy
static func emul(sim, u) -> float:
	var a = A(u)
	if a.is_empty(): return 1.0
	if has_bf(sim, u, "silence"): return 0.0
	var m = stat(sim, u, "energy")
	if J.t(a.get("in_fear")): m *= mp("嚇氣光環", "energy", 0.5)
	return m

# ================= 每格：全場（_step_fight 尾、_separate 之前） =================
static func tick(sim, dt: float) -> void:
	var st = sim.ab_st
	if not (st is Dictionary): return
	var t = sim.t
	if not J.t(st.get("t0")):
		st["t0"] = true
		for u in sim.units: if sim.alive(u): trig(sim, u, "start", null)
	# 屍變／返生
	if (st.pend as Array).size():
		var keep = []
		for p in st.pend:
			var u = p.u
			if J.num(p.at) > t: keep.append(p); continue
			if J.t(A(u).get("no_rev")): continue
			u["hp"] = _nn(u, "maxhp") * J.num(p.pct); u["deadT"] = 0.0; u["anim"] = null; u["casting"] = null; u.st.clear(); u["flash"] = 1.0
			sim.text(sim.head(u) + Vector2(0, -24), "屍變！" if p.kind == "undead" else "返生！", "#fca5a5", 1.2, 18)
			ev(sim, p.kind, null, u)
		st["pend"] = keep
	# 地面陷阱
	if (st.zones as Array).size():
		var kz = []
		for z in st.zones:
			if J.num(z.until) <= t: continue
			z["acc"] = J.num(z.acc) + dt
			if J.num(z.acc) >= 0.5:
				z["acc"] = J.num(z.acc) - 0.5
				var ts = []
				for w in sim.units:
					if _nn(w, "side") != _nn(z.src, "side") and sim.alive(w) and (w.p as Vector2).distance_to(z.p) <= J.num(z.r): ts.append([w, 1.0])
				if ts.size():
					for fx in z.fx: prim(sim, z.src, fx, ts, {"sk": false, "zone": true})
			kz.append(z)
		st["zones"] = kz
	# 隱身循環：開打後每 6 秒隱 4 秒（頭 2 秒現身）
	var cyc = mp("隱", "cycle", 6.0); var sdur = mp("隱", "dur", 4.0)
	for u in sim.units:
		if has_mech(u, "隱") and _nn(u, "hp") > 0:
			var was = J.t(A(u).get("st_on"))
			A(u)["st_on"] = fmod(t, cyc) >= cyc - sdur
			if A(u).st_on and not was and J.num(A(u).get("rev_until", 0)) <= t: ev(sim, "stealth_on", u, u)
	_combo_tick(sim, dt)
	st["acc"] = J.num(st.acc) + dt
	if J.num(st.acc) >= TICK:
		var step = J.num(st.acc); st["acc"] = 0.0
		_slow_tick(sim, step)
	_flush(sim)
static func _slow_tick(sim, step: float) -> void:
	var t = sim.t
	# 嚇氣光環：150px 內我方（冇「定」保護）
	var auras = []
	for w in sim.units:
		if _nn(w, "side") == 1 and sim.alive(w) and has_mech(w, "嚇氣光環") and J.num(A(w).get("aura_off", 0)) <= t: auras.append(w)
	var ar = mp("嚇氣光環", "r", 150.0)
	for u in sim.units:
		if _nn(u, "side") != 0 or not sim.alive(u): continue
		var a = A(u)
		if a.is_empty(): continue
		var inf = false
		if auras.size() and not protected(sim, u):
			for w in auras: if (u.p as Vector2).distance_to(w.p) <= ar: inf = true; break
		if inf and not J.t(a.get("in_fear")): ev(sim, "fear_aura", null, u)
		a["in_fear"] = inf
	# 「照」名鬼身邊 150px：隱身敵人現形
	for u in sim.units:
		if _nn(u, "side") == 0 and sim.alive(u) and has_tag(u, "照"):
			for w in sim.units:
				if _nn(w, "side") == 1 and sim.alive(w) and (has_mech(w, "隱") or J.t(A(w).get("clone"))) and (u.p as Vector2).distance_to(w.p) <= mp("隱", "reveal_r", 150.0):
					_reveal(sim, u, w.p, 40.0, mp("隱", "reveal_s", 8.0) * 0.25)
	# 分身：每 re 秒補返分身（re=0 唔補）
	for w in sim.units:
		if _nn(w, "side") != 1 or not sim.alive(w) or not has_mech(w, "分身") or mp("分身", "re", 10.0) <= 0: continue
		A(w)["clone_t"] = J.num(A(w).get("clone_t", 8.0)) - step
		if J.num(A(w).clone_t) <= 0: A(w)["clone_t"] = mp("分身", "re", 10.0); _clones(sim, w)
	# 迷魂：每 8 秒令 150px 內 3 隻我方亂走 2.5 秒（「定」免疫＋保護身邊）
	for w in sim.units:
		if _nn(w, "side") != 1 or not sim.alive(w) or not has_mech(w, "迷魂"): continue
		var a2 = A(w)
		a2["conf_t"] = J.num(a2.get("conf_t", 2.0)) - step
		if J.num(a2.conf_t) > 0: continue
		a2["conf_t"] = mp("迷魂", "every", 8.0)
		var cand = []
		for u in sim.units:
			if _nn(u, "side") == 0 and sim.alive(u) and (u.p as Vector2).distance_to(w.p) <= mp("迷魂", "r", 150.0): cand.append(u)
		cand.sort_custom(func(x, y): return (x.p as Vector2).distance_to(w.p) < (y.p as Vector2).distance_to(w.p))
		var n = 0; var blocked = 0
		for u in cand:
			if n >= int(mp("迷魂", "n_tg", 3)): break
			if protected(sim, u) or not cc_ok(sim, w, u, "confuse"): blocked += 1; continue
			A(u)["conf_until"] = t + mp("迷魂", "dur", 2.5); A(u)["conf_dir"] = Vector2.from_angle(randf() * TAU); n += 1
			sim.text(sim.head(u) + Vector2(0, -18), "迷魂", "#d8b4fe", 0.9)
		if n > 0: ev(sim, "confuse", w, null)
		if blocked > 0: ev(sim, "confuse_block", w, null)
	# 光環（ABIL aura）、定時觸發、低血觸發
	for u in sim.units:
		if not sim.alive(u): continue
		var a3 = A(u)
		if a3.is_empty(): continue
		var au = a3.get("aura")
		if au is Dictionary:
			var r = J.num(au.get("r", 110)); var sd = _nn(u, "side"); var ally = J.str(au.get("side", "ally")) == "ally"
			for w in sim.units:
				if not sim.alive(w) or ((_nn(w, "side") == sd) != ally) or (u.p as Vector2).distance_to(w.p) > r: continue
				for fx in _arr(au.get("fx")):
					if not (fx is Dictionary): continue
					var f2 = (fx as Dictionary).duplicate(); f2["dur"] = TICK + 0.15
					if J.str(f2.get("p")) == "buff": add_bf(sim, w, {"id": "aura_" + J.str(f2.get("stat", "atk")), "p": "buff", "stat": J.str(f2.get("stat", "atk")), "v": _v(f2, "v", 0.1, int(a3.star)), "dur": TICK + 0.15, "neg": _v(f2, "v", 0.1, int(a3.star)) < 0 and not ally})
					else: prim(sim, u, f2, [[w, 1.0]], {"sk": false, "aura": true})
			if not J.t(a3.get("aura_said")): a3["aura_said"] = true; ev(sim, "aura", u, null)
		for i in (a3.get("pas", []) as Array).size():
			var pe = a3.pas[i]
			if J.str(pe.get("tr")) == "every":
				var k = "ev" + str(i)
				a3[k] = J.num(a3.get(k, 0)) + step
				if J.num(a3[k]) >= J.num(pe.get("t", 5)): a3[k] = 0.0; trig(sim, u, "every", null)
			elif J.str(pe.get("tr")) == "low_hp": trig(sim, u, "low_hp", null)

# ================= 召喚機制 =================
static func _summon_mech(sim, u: Dictionary) -> void:
	var mine = 0   # 場上最多 6 隻（全部召喚者合計，counter.md 4.1）
	for w in sim.units: if _nn(w, "side") == 1 and A(w).get("by") != null and sim.alive(w): mine += 1
	for w in sim.ab_st.spawn: if A(w).get("by") != null: mine += 1
	var cap = int(mp("召喚", "cap", 6)); var n = mini(int(mp("召喚", "n_sum", 2)), cap - mine)
	var en = _ent("ENEMY", J.str(u.get("k")))
	var fk = J.str(en.get("sum_k", _fod(sim)))
	var ET = J.G.get("ENEMY_T") if J.G != null else null
	var nm = J.str(ET[fk][2]) if ET is Dictionary and ET.has(fk) else "嘍囉"
	for i in n:
		var c = {"side": 1.0, "k": fk, "name": nm, "hp": _nn(u, "maxhp") * mp("召喚", "hp", 0.3), "atk": _nn(u, "atk") * mp("召喚", "atk", 0.4), "range": 46.0, "spd": 46.0,
			"energy": 0.0, "sk": null, "st": {}, "boss": false}
		c["maxhp"] = c.hp
		_spawn(sim, c, (u.p as Vector2) + Vector2(randf_range(-40, 40), randf_range(-16, 16)) - (sim.ax as Vector2) * 24.0)
		A(c)["by"] = u
	sim.text(sim.head(u) + Vector2(0, -34), "召喚！", "#ff99aa", 1.0, 17)
	sim.events.append(["skill", u])
	ev(sim, "summon_mech", u, null)
static func _fod(sim) -> String:
	var ZD = load("res://game/zone/zone_data.gd")
	var ci = 0
	if ZD != null and ZD.has_method("ci"): ci = int(ZD.ci())
	return ["youhun", "egui", "xiaogui", "shuigui", "zombie", "zhiren"][clampi(ci, 0, 5)]

# ================= 結算 =================
static func report(sim) -> void:
	# 我方召喚物唔係陰兵：結算前拎走（唔計戰死、唔扣兵）
	var keep = []
	for u in sim.units:
		if _nn(u, "side") == 0 and J.t(u.get("sum")): continue
		keep.append(u)
	sim.units = keep
	sim.ab_log["t"] = sim.t
	sim.ab_log["win"] = sim.result != null and J.t(sim.result.get("win"))
