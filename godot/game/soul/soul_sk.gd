# [補丁43] 圖鑑「技能七層」：主技／副技／天生被動／職業被動／專長一／專長二／王牌技（全部 static；冇 class_name；熱更新規矩）
#   未解鎖嘅灰色，寫明幾時開；突破星級顯示主技、副技強化幾多。
extends RefCounted

const SOUL = preload("res://game/soul/soul_data.gd")

static func L(yue: String, zhs: String) -> String: return SOUL.L(yue, zhs)
static func AB(): return load("res://game/rts/abil.gd")
static func UP(): return load("res://game/soul/soul_up.gd")
static func RO(): return load("res://game/rts/roles.gd")
static func _d(x) -> String: return str(x[1] if DB.lang != "yue" else x[0]) if x is Array and x.size() >= 2 else str(x)

const TR := {"start": ["開場", "開場"], "kill": ["擊倒敵人時", "擊倒敵人時"], "low_hp": ["血低時", "血量低時"], "hit_taken": ["捱打時", "受擊時"],
	"ally_down": ["隊友倒低時", "隊友倒下時"], "ally_cast": ["隊友放大招時", "隊友放大招時"], "foe_cast": ["敵人放大招時", "敵人放大招時"], "death": ["倒低時", "倒下時"]}
static func _tr_txt(pe: Dictionary) -> String:
	var tr = J.str(pe.get("tr"))
	if tr == "every": return L("每 %d 秒", "每 %d 秒") % int(J.num(pe.get("t", 5)))
	if tr == "attack":
		var n = int(J.num(pe.get("n", 1)))
		return L("每打 %d 下", "每攻擊 %d 下") % n if n > 1 else L("攻擊時", "攻擊時")
	return _d(TR.get(tr, [tr, tr]))
static func pas_txt(pe: Dictionary) -> String:   # 冇手寫說明嘅被動：觸發＋積木名
	var fs = []
	for fx in pe.get("fx", []):
		if fx is Dictionary:
			var p = J.str(fx.get("p")); var nm = str(AB().PN.get(p, p))
			if not fs.has(nm): fs.append(nm)
	return "%s：%s" % [_tr_txt(pe), "、".join(fs)]

# 回 [{lay, name, desc, on, how}]
static func layers(k: String) -> Array:
	var A = AB(); var U = UP(); var R = RO()
	var o = []
	var own = SOUL.owned(k) or k == "afu"
	var rk = SOUL.rank(k) if SOUL.is_ghost(k) else 0
	var st = U.star(k) if SOUL.is_ghost(k) else 0
	var al = U.act_lv(k); var sl = U.sub_lv(k)
	# 1 主技
	var act = A.act_of(k)
	var an = J.str(act.get("name")) if act is Dictionary else ""
	var ad = str(A.describe(k)).split("；")[0] if an != "" else ""
	if ad.find("：") >= 0: ad = ad.substr(ad.find("：") + 1)
	if al > 0: ad += L("　（突破強化 +%d%%）", "　（突破強化 +%d%%）") % (12 * al)
	o.append({"lay": L("主技", "主技"), "name": an, "desc": ad + L("　能量滿就放（開咗自動就自動放）", "　能量滿就放（開了自動就自動放）"), "on": true, "how": ""})
	# 2 副技
	var sb = A.sub_of(k)
	if sb != null:
		var sd = _d(sb.get("d"))
		if sl > 0: sd += L("　（突破強化 +%d%%）", "　（突破強化 +%d%%）") % (12 * sl)
		o.append({"lay": L("副技", "副技"), "name": str(sb.name), "desc": sd + L("　自動放；被封口、定身就放唔到。", "　自動施放；被封口、定身時放不出。"), "on": true, "how": ""})
	# 3 天生被動
	var e = A.abil(k)
	for pe in (e.get("pas", []) if e is Dictionary and not k.begins_with("bm_") else []):
		if not (pe is Dictionary): continue
		var need = int(J.num(pe.get("star", 0)))
		o.append({"lay": L("被動", "被動"), "name": "", "desc": pas_txt(pe), "on": rk >= need, "how": "" if need <= 0 else L("職級升到【%s】開", "職級升到【%s】開放") % SOUL.rank_name(need)})
	# 4 職業被動
	if true:
		var ci = R.info(k)
		if str(ci.zh) != "": o.append({"lay": L("職業", "職業"), "name": "%s・%s" % [str(ci.zh), R.T(ci.full)], "desc": R.T(ci.desc), "on": true, "how": ""})
	# 5、6 專長
	var pk = A.perk_list(k)
	var ace_born = U.born_ace(k)
	for i in mini(2, pk.size()):
		var pe2 = pk[i]
		if not (pe2 is Dictionary): continue
		var on = (rk >= 2 or ace_born) if i == 0 else rk >= 4
		var how = L("天生王牌入村即有", "天生王牌入村即有") if (i == 0 and ace_born) else (L("職級升到【%s】開", "職級升到【%s】開放") % SOUL.rank_name(2 if i == 0 else 4))
		var ds = _d(pe2.get("d")) if pe2.get("d") != null else pas_txt(pe2)
		o.append({"lay": L("專長一", "專長一") if i == 0 else L("專長二", "專長二"), "name": str(pe2.get("name", "")), "desc": ds, "on": on and own, "how": how})
	# 7 王牌技
	var ac = A.ace_of(k)
	if ac != null and ace_born:
		o.append({"lay": L("王牌技", "王牌技"), "name": str(ac.name), "desc": _d(ac.get("d")), "on": own, "how": L("收服就有", "收服即擁有")})
	else:
		o.append({"lay": L("王牌技", "王牌技"), "name": "", "desc": L("只有天生王牌先有王牌技。", "只有天生王牌才有王牌技。"), "on": false, "how": ""})
	return o

# 突破一行
static func star_line(k: String) -> String:
	if not SOUL.is_ghost(k): return ""
	var U = UP(); var st = U.star(k)
	var t = L("突破 %s%s　（上限 ★%d，要合夥人先開）", "突破 %s%s　（上限 ★%d，需合夥人才開放）") % ["★".repeat(st), "☆".repeat(maxi(0, U.star_cap(k) - st)), U.star_cap(k)]
	t += L("\n★1、★3、★5 主技升級；★2、★4 副技升級；★3 換進階立繪", "\n★1、★3、★5 主技升級；★2、★4 副技升級；★3 換進階立繪")
	return t

# 加落圖鑑詳情（rich＝soul_codex._rich）
static func add_to(body: Control, k: String, rich: Callable, dim: Color, ink: Color) -> void:
	for x in layers(k):
		var col = "#3a2a18" if x.on else "#9a9080"
		var nm = (" [b]【%s】[/b]" % str(DB.N(str(x.name)))) if str(x.name) != "" else ""
		var lk = "" if x.on or str(x.how) == "" else ("　[color=#a05030]（%s）[/color]" % str(x.how))
		body.add_child(rich.call("[color=%s][b]%s[/b]%s　%s[/color]%s" % [col, str(x.lay), nm, str(x.desc), lk], 15, ink if x.on else dim))
	var sl = star_line(k)
	if sl != "": body.add_child(rich.call(sl, 14, dim))
