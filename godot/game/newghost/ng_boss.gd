# [newghost] 魔王據點（每關第 4 圈一個，zones.json sorties 有 "boss": "bm_*"）：鎖、敵陣、頭目名牌、掉散魂、隱藏酒吞童子
#   const NGB = preload("res://game/newghost/ng_boss.gd")
#   so_data.gd 掛鈎（全部標 # [newghost]）：camps() 帶 bm、state() 鎖、stage_of() 敵陣、dispatch() 名牌、reward() 散魂
#   存檔：S.ngb = {beat: {bm_*: 次數}}（讀一律 .get；舊存檔冇呢欄照用）
extends RefCounted

const NG = preload("res://game/newghost/ng_data.gd")
const SOUL_GD := "res://game/soul/soul_data.gd"
# 魔王身邊嘅嘍囉（每關主題；雜兵 ENEMY_T 由 newghost.json 登記）
const ESCORT := {
	"bm_taotie": ["egui", "egui", "youhun", "egui"], "bm_jembalang": ["zd_shanjing", "xiaogui", "zd_shanjing", "xiaogui"],
	"bm_hou": ["zombie", "zd_bone", "zombie", "zd_bone"], "bm_langsuir": ["zd_hongyi", "zd_shuihou", "zd_hongyi", "zd_shuihou"],
	"bm_krasue": ["zd_bone", "zd_hongyi", "zd_bone", "zd_hongyi"], "bm_pang": ["zd_paotui", "zd_yinchai", "zd_paotui", "zd_yinchai"],
	"bm_shuten": ["zd_shanjing", "zd_hongyi", "zd_shanjing", "zd_hongyi"],
}

static func S():
	var s = J.G.get("S")
	return s if s is Dictionary and not s.is_empty() else null
static func st() -> Dictionary:
	var s = S()
	if s == null: return {}
	if not (s.get("ngb") is Dictionary): s["ngb"] = {"beat": {}}
	if not (s.ngb.get("beat") is Dictionary): s.ngb["beat"] = {}
	return s.ngb
static func beat(bm: String) -> int: return int(J.num(st().get("beat", {}).get(bm, 0)))
static func info(bm: String) -> Dictionary:
	var b = NG.D().get("BOSS", {}).get(bm)
	return b if b is Dictionary else {}

# zones.json 據點 → 呢個據點而家係邊隻魔王（第 1 關：六隻章魔王全部打低之後換酒吞童子）
static func boss_of(z: Dictionary, c: int) -> String:
	var bm = str(z.get("boss", ""))
	if bm == "": return ""
	var H = NG.D().get("HIDDEN", {})
	for hk in H:
		var h = H[hk]
		if int(J.num(h.get("c", -1))) != c: continue
		var all_ok = true
		for x in h.get("after", []): if beat(str(x)) <= 0: all_ok = false
		if all_ok: return str(hk)
	return bm

# 鎖：本關第 4 圈其他據點未全部首勝 → 鎖住（counter.md 11.4）
static func locked(e: Dictionary) -> bool:
	if str(e.get("bm", "")) == "": return false
	var SO = load("res://game/sortie/so_data.gd")
	for x in SO.camps(int(e.c)):
		if int(x.ring) == 4 and str(x.get("bm", "")) == "" and not J.t(SO.cst(x).get("first")): return true
	return false

static func stage(e: Dictionary, title: String) -> Dictionary:
	var bm = str(e.bm)
	var c = int(e.c)
	var CH = J.G.get("CHAPTERS")
	var bg = str(CH[c].get("bg", "field")) if CH is Array and c < CH.size() else "field"
	var en = (ESCORT.get(bm, ["youhun", "youhun", "youhun", "youhun"]) as Array).duplicate()
	en.append(bm)
	var b = info(bm)
	return {"name": "%s　%s" % [title, str(b.get("name", bm))], "en": en, "boss": "", "p": float(e.lv), "sortie": true, "bg": bg, "bm": bm}

# dispatch 之後：魔王單位名牌、旗標
static func decorate(snap: Dictionary, e: Dictionary) -> void:
	var bm = str(e.get("bm", ""))
	if bm == "": return
	for u in snap.get("units", []):
		if J.num(u.get("side")) == 1 and str(u.get("k", "")) == bm:
			u["boss"] = true; u["bm"] = true; u["name"] = str(info(bm).get("name", bm))

# 打贏：掉散魂（首勝 first＋win，之後每次 win）；記錄打低次數。回一行戰報
static func on_win(e: Dictionary, first: bool) -> String:
	var bm = str(e.get("bm", ""))
	if bm == "": return ""
	var b = info(bm); var dr = b.get("drop", {})
	var n = int(J.num(dr.get("win", 5))) + (int(J.num(dr.get("first", 20))) if first else 0)
	var o = st()
	if o.is_empty(): return ""
	o.beat[bm] = beat(bm) + 1
	add_san(n, "boss:" + bm)
	return "散魂 +%d（打低魔王 %s）" % [n, str(b.get("name", bm))]

static func add_san(n: int, why: String) -> void:
	if ResourceLoader.exists(SOUL_GD):
		var SD = load(SOUL_GD)
		if SD != null and SD.has_method("add_san"): SD.add_san(n, why); return
	var s = S()   # soul 線未合併：直接記入 S.soul.san（soul_data.st() 之後會補齊其他欄）
	if s == null: return
	if not (s.get("soul") is Dictionary): s["soul"] = {"v": 1.0, "mig": 0.0}
	s.soul["san"] = J.num(s.soul.get("san", 0)) + n
