# [rts] 地圖半即時戰鬥：一場仗（一個 op）嘅模擬（純邏輯，冇畫面；畫面喺 rts_view.gd）
#   單位＝Battle.start 生成嘅原裝單位（數值 100% 同舊版），加地圖欄位：p（世界座標）、face、s（行軍弧長）……
#   規則逐條搬自 native/battle.gd（出手節奏、冷卻、嚇氣、技能、嚇彈起／腳軟／擊退、吸血、偷錢）＋ native/rework.gd（嚇法相剋、失神、連嚇、嚇功）。
#   唯一唔同：位置由一條直線變成地圖平面（搵最近嘅敵人行埋去打）。
#   冇 class_name（熱更新規矩）：const SIM = preload("res://game/rts/rts_sim.gd")
extends RefCounted

const YB = preload("res://game/yinbing/yb_data.gd")   # [yinbing] 陰兵兵種（醫護兵回血）
const MD = preload("res://game/outpost/mv_data.gd")
const AB = preload("res://game/rts/abil.gd")   # [ab] 能力引擎（AB.on() 假＝全部行舊路）
const AF = preload("res://game/rts/abform.gd")   # [abform] 陣型、揀目標、AoE 半徑、護衛、自動施放 AI
const AH = preload("res://game/rts/ab_hud.gd")   # [abui] 名鬼長按切自動／手動（S.ab_auto）

# ---- 同 battle.gd 一樣 ----
const WIND := 0.22
const STRIKE := 0.12
const REC := 0.25
const IMPACT := 0.05
const PSPD := 640.0
const CAST := 0.45
const TIME_LIMIT := 90.0
# ---- 地圖節奏（設計稿第 6 節） ----
const MARCH := 72.0          # 行軍（世界 px／秒）
const BACK := 84.0           # 回村
const AGGRO := 170.0         # 接觸範圍
const GAP := 46.0            # 隊與隊之間（弧長 px ≈ 0.6 秒）
const SALUTE := 1.0          # 回到集合點敬禮幾秒
const REPS := 2              # 每隊畫幾個代表兵
const DEPLOY := 250.0        # 離迎戰點幾遠開始由行軍隊形展開成戰鬥橫隊
const ROWGAP := 46.0         # 橫隊前後行距
const DEP_WAIT := 6.0        # 前排最多等後面幾秒（等齊就一齊推前）
const CLOSE := 100.0         # [qaudit2] 離目標「射程 + 呢個」以內、而陣位比自己而家更遠離目標：唔再追陣位，直接埋身
#   （陣位係跟對面位置計：雙方都追緊自己陣位時會變成你追我走，兩隻企喺 93px 互相望住一齊平行移，行出地圖（實測 x=-1300）、成半分鐘冇出手）

var id := 0
var kind := "stage"
var sid := ""
var title := ""
var phase := "march"         # march → fight → end（等結算）→ back → done
var units: Array = []
var proj: Array = []
var fx: Array = []
# 畫面特效隊列（rts_view 喺鏡頭內先開 vfx_on；鏡頭外／測試唔開＝零成本、模擬照舊）
var vfx_on := false
var vq: Array = []
var hstop := 0.0              # 命中停頓：只停呢場仗（只喺 vfx_on 時有）
var events: Array = []       # 畫面／測試用：[事件, 資料]
var t := 0.0                 # 交戰時間（同舊 B.t）
var T := 0.0                 # 總時間
var path := PackedVector2Array()
var path_len := 0.0
var gate := Vector2.ZERO     # 村門（打卡位）
var gate_s := 0.0
var anchor := Vector2.ZERO
var adviser = null
var adv_cast = null
var result = null            # {win, quit, timeout}
var recalled := false
var auto := false
var coins_won := 0.0
var rw = null                # J.G.Rework
var snd_t := 0.0
var settled := false
var ax := Vector2(0, -1)      # 陣線軸：我方 → 敵方
var perp := Vector2(1, 0)
var org := Vector2.ZERO
var cosmetic := false         # 純畫面（派兵攻佔、自動擊退）：我方唔會死、結果由舊規則定
var no_heroes := false
var foe_from = null           # 敵人由邊度行過嚟（襲擾）
var tune_minion := 120.0         # 敵人揀目標：陰兵小隊（企正面）優先幾多（同舊版直線一樣，前面嘅小隊食傷害）
var tune_open := 2.0           # 接觸後我方要幾耐排陣先出第一下
var dep_go := false           # 橫隊排齊咗，一齊推前
var dep_t := 0.0              # 第一隊到位等咗幾耐
var ab := false               # [ab] 呢場用能力引擎
var ab_log := {}              # [ab] 戰後：kills=[{k, sum, boss}]、ev={積木: 次數}（魂魄線、測試用）
var ab_st = null              # [ab] 引擎內部狀態

func _init() -> void:
	rw = J.G.get("Rework")

# ================= 開局 =================
# units：Battle.start 生成嘅單位；out_path：村內集合點 → 迎戰點；at：敵人據點
func setup(us: Array, out_path: PackedVector2Array, at: Vector2, gate_p: Vector2) -> void:
	units = us; path = out_path; path_len = MD.poly_len(path); anchor = at; gate = gate_p
	gate_s = _s_of(gate)
	# 出發次序：陰兵開路兩隊 → 名鬼 → 其餘陰兵 → 遊魂兵（隊與隊相隔 GAP）
	var yin = []; var hs = []; var mls = []
	for u in units:
		if _nn(u, "side") != 0: continue
		if not J.t(u.get("minion")): hs.append(u)
		elif u.get("ml") == null: yin.append(u)
		else: mls.append(u)
	var order = yin.slice(0, 2) + hs + yin.slice(2) + mls
	for i in order.size():
		var u = order[i]
		u["s"] = -i * GAP
		u["lat"] = 0.0 if not J.t(u.get("minion")) else (11.0 if i % 2 == 0 else -11.0)
		u["p"] = path[0]; u["face"] = 1.0; u["out"] = false; u["eng"] = false
		u["stamp"] = false
	_deploy_slots(order)
	var foes = []
	for u in units: if _nn(u, "side") == 1: foes.append(u)
	var pos = camp_layout(at, foes.size(), _dir_in())
	for i in foes.size():
		var u = foes[i]; u["p"] = pos[i]; u["post"] = pos[i]; u["face"] = -1.0 if _dir_in().x >= 0 else 1.0
		if foe_from is Vector2: u["p"] = (foe_from as Vector2) + (pos[i] - at); u["walking"] = true
		u["eng"] = false
	for i in units.size():
		var u = units[i]
		u["_id"] = i
		u["st"] = u.get("st", {}) if u.get("st") is Dictionary else {}
		if u.get("cd") == null: u["cd"] = randf() * 0.5
	ab = AB.on()   # [ab]
	if ab: AB.setup(self)   # [ab]

# 據點排位：主將（王）喺中間前面，其餘左右兩邊、嘍囉喺後面（同 view 嘅預覽一樣）
static func camp_layout(at: Vector2, n: int, dir_in: Vector2) -> Array:
	var o = []
	var fw = -dir_in.normalized() if dir_in.length() > 0.1 else Vector2(0, 1)   # 敵人望住隊伍嚟嘅方向
	var sd = Vector2(-fw.y, fw.x)
	var row = [Vector2.ZERO, sd * 48 - fw * 8, -sd * 48 - fw * 8, sd * 24 - fw * 46, -sd * 24 - fw * 46, sd * 72 - fw * 40, -sd * 72 - fw * 40]
	for i in n:
		if i < row.size(): o.append(at + row[i])
		else: o.append(at + sd * (((i - row.size()) % 6) - 2.5) * 30 - fw * (78 + 30 * floor((i - row.size()) / 6.0)))
	return o
# 行軍隊形 → 戰鬥隊形：預先定好每隊喺橫隊嘅橫位（dl）同第幾行（drow），次序同接觸時 _form 一樣
#   前行：名鬼一半 ＋ 陰兵小隊 ＋ 名鬼另一半（近身）；後行：遠程。一行太長（> 8 隊）就分兩行。
func _deploy_slots(order: Array) -> void:
	var mel = []; var rng = []
	for u in order: (rng if _nn(u, "range") > 60 else mel).append(u)
	var hs = mel.filter(func(x): return not J.t(x.get("minion")))
	var sq = mel.filter(func(x): return J.t(x.get("minion")))
	var line = hs.slice(0, (hs.size() + 1) / 2) + sq + hs.slice((hs.size() + 1) / 2)
	var rows = []
	if AF.on(): line = AF.line_order(mel); rows = AF.split_rows(line)   # [abform] 前排名鬼企中間、小隊企兩頭
	elif line.size() > 8:   # 兩行：單數位企前、雙數位企後（同 _slots 兩行排法一樣）
		var a = []; var b = []
		for i in line.size(): (a if i % 2 == 0 else b).append(line[i])
		rows = [a, b]
	else: rows = [line]
	if rng.size(): rows.append(rng)
	for r in rows.size():
		var arr = rows[r]
		for i in arr.size():
			arr[i]["dl"] = (i - (arr.size() - 1) * 0.5) * (42.0 if r < rows.size() - 1 or rng.is_empty() else 46.0)
			arr[i]["drow"] = r
			arr[i]["dep"] = 0   # 0 行軍 1 到位等緊 2 推前
func _dir_in() -> Vector2:   # 隊伍最後一段嘅方向（入據點）
	if path.size() < 2: return Vector2(0, -1)
	return (path[path.size() - 1] - path[path.size() - 2]).normalized()

# ================= 小工具 =================
static func _nn(u, k: String) -> float: return J.num(u.get(k, 0)) if u is Dictionary else 0.0
static func scale_of(u: Dictionary) -> float: return 0.75 if J.t(u.get("minion")) else (1.7 if J.t(u.get("boss")) else 1.32)
static func period(u: Dictionary) -> float: return 1.15 if _nn(u, "range") > 60 else 0.95
func _sign(v: float) -> float: return 1.0 if v > 0 else (-1.0 if v < 0 else 0.0)
func present(u: Dictionary) -> bool:
	if _nn(u, "side") == 1: return true
	return J.t(u.get("out")) and not J.t(u.get("home"))
func alive(u: Dictionary) -> bool: return _nn(u, "hp") > 0 and present(u)
func enemies_of(u: Dictionary) -> Array:
	var o = []; var sd = _nn(u, "side")
	for v in units: if _nn(v, "side") != sd and alive(v): o.append(v)
	return o
func nearest(u: Dictionary):
	var best = null; var bd = 1e9
	var up: Vector2 = u.get("p", anchor)
	for v in enemies_of(u):
		var d = up.distance_to(v.p)
		if d < bd: bd = d; best = v
	return best
func dist(a: Dictionary, b: Dictionary) -> float: return (a.p as Vector2).distance_to(b.p)
func lead_of(u: Dictionary, tg: Dictionary) -> float:
	if _nn(u, "range") > 60: return WIND + maxf(0.0, dist(u, tg) - 10) / PSPD
	return WIND + IMPACT
func _ours_alive() -> int:
	var n = 0
	for u in units: if _nn(u, "side") == 0 and _nn(u, "hp") > 0: n += 1
	return n
func heroes_alive() -> int:
	var n = 0
	for u in units: if _nn(u, "side") == 0 and not J.t(u.get("minion")) and _nn(u, "hp") > 0: n += 1
	if ab: n += AB.pending(self, 0)   # [ab] 返生中
	return n
func foes_alive() -> int:
	var n = 0
	for u in units: if _nn(u, "side") == 1 and _nn(u, "hp") > 0: n += 1
	if ab: n += AB.pending(self, 1)   # [ab] 屍變中
	return n
func center() -> Vector2:   # 而家戰場（俾鏡頭／戰況條）
	if phase == "march" or phase == "back":
		var s = Vector2.ZERO; var n = 0
		for u in units:
			if _nn(u, "side") == 0 and present(u) and _nn(u, "hp") > 0: s += u.p; n += 1
		if n > 0: return s / n
	return anchor
func _s_of(p: Vector2) -> float:   # 路線上最近 p 嗰點嘅弧長
	var best = INF; var bs = 0.0; var acc = 0.0
	for i in path.size() - 1:
		var a = path[i]; var b = path[i + 1]; var L = a.distance_to(b)
		var k = clampf((p - a).dot(b - a) / maxf(0.001, L * L), 0.0, 1.0)
		var d = p.distance_to(a.lerp(b, k))
		if d < best: best = d; bs = acc + L * k
		acc += L
	return bs
func _path_at(pts: PackedVector2Array, s: float, lat: float) -> Vector2:
	var p = MD.poly_at(pts, clampf(s, 0.0, MD.poly_len(pts)))
	if lat == 0.0: return p
	var q = MD.poly_at(pts, clampf(s + 6.0, 0.0, MD.poly_len(pts)))
	var d = (q - p)
	if d.length() < 0.01: return p
	d = d.normalized()
	return p + Vector2(-d.y, d.x) * lat

# ================= 特效（世界座標） =================
func _vq(e: Array) -> void:
	if vfx_on and vq.size() < 64: vq.append(e)
func _fx(d: Dictionary) -> void: d["t"] = 0.0; fx.append(d)
func spark(p: Vector2, k: float, col: String) -> void: _fx({"kind": "spark", "p": p, "life": 0.24, "k": k, "col": col, "rot": randf() * PI})
func text(p: Vector2, s: String, col: String, life := 1.1, px := 15) -> void: _fx({"kind": "txt", "p": p, "text": s, "col": col, "life": life, "px": px})

# ================= 受擊（battle.gd hit ＋ rework 包裝） =================
func head(u: Dictionary) -> Vector2:   # 頭頂（世界）
	var h = 40.0 if J.t(u.get("minion")) else (78.0 if J.t(u.get("boss")) else 56.0)
	if not (u.get("p") is Vector2): return Vector2(-9999, -9999)   # [整合] 軍師等冇場上位置嘅單位：唔報錯
	return (u.p as Vector2) + Vector2(0, -h)
func hit(src: Dictionary, v: Dictionary, mult: float, sk) -> float:
	if ab: return AB.hit(self, src, v, mult, sk)   # [ab] 新管線（兩層克制、機制、積木）；舊管線原封不動留喺下面
	var m = mult
	var tag = null; var tcol = "#e8d0ff"; var chain = false
	# rework：名鬼技能打敵人 → 嚇法相剋
	if J.t(sk) and _nn(src, "side") == 0 and _nn(v, "side") == 1 and J.str(sk.get("kind")) != "heal" and not J.t(src.get("minion")) and rw != null:
		var ts = J.mc(rw, "typesOf", [src.get("k")])
		if ts is Array and ts.size():
			var f = J.mc(rw, "fearOf", [v.get("k")])
			var tp = null
			for x in ts: if f.w.has(x): tp = x; break
			if tp == null:
				for x in ts: if not f.i.has(x): tp = x; break
			if tp == null: tp = ts[0]
			m *= 1 + 0.05 * (J.num(J.mc(rw, "drillLv", [src.get("k")])) - 1)
			var marked = v.get("fearT") is Dictionary and J.num(v.fearT.until) > t
			var wd = J.str(J.mc(rw, "word", [tp]))
			if f.i.has(tp): m *= 0.6; tag = "不怕" + wd; tcol = "#9aa"
			elif f.w.has(tp):
				m *= 1.35
				if marked and v.fearT.t != tp: m *= 1.8; chain = true; tag = "%s＋%s・連嚇" % [J.str(J.mc(rw, "word", [v.fearT.t])), wd]; tcol = "#ffd84a"
				else: tag = "怕%s・失神" % wd
				v["fearT"] = {"t": tp, "until": t + 3.2}
			elif marked and v.fearT.t != tp: m *= 1.3; tag = "追嚇"; tcol = "#ffe8a0"
	var bonus = 1.0 + J.num(adviser.bonus) if _nn(src, "side") == 0 and adviser is Dictionary else 1.0
	var combo_hit = false
	if J.t(sk) and J.t(sk.get("follow")) and _state(v) == sk.get("follow"): m *= 1.8; combo_hit = true
	var dmg = J.round(_nn(src, "atk") * m * bonus * (0.9 + randf() * 0.2))
	if cosmetic and _nn(v, "side") == 0: v["hp"] = maxf(_nn(v, "maxhp") * 0.25, _nn(v, "hp") - dmg)   # 純畫面：結果由舊規則定，唔好畫錯
	else: v["hp"] = _nn(v, "hp") - dmg
	var sp: Vector2 = src.get("p", v.p)
	var dir = _sign((v.p as Vector2).x - sp.x)
	if dir == 0: dir = 1.0 if _nn(v, "side") != 0 else -1.0
	v["flash"] = 1.0; v["kbDir"] = -dir if J.str(src.get("k")) == "heiwu" else dir; v["kbT"] = 0.0
	if not J.t(v.get("anim")) and not J.t(v.get("casting")): v["hurtT"] = 0.25
	var hp_ = head(v)
	var vs = _nn(v, "side")
	spark(hp_.lerp(v.p, 0.45) - Vector2(dir * 5, 0), 1.35 if combo_hit or J.t(sk) else (0.7 if J.t(v.get("minion")) else 1.0), "#ff9a7a" if vs == 0 else ("#ffd84a" if combo_hit else "#fff4c0"))
	_fx({"kind": "num", "p": hp_ + Vector2((randf() - 0.5) * 14, -6), "vx": dir * (14 + randf() * 18), "text": J.str(dmg), "life": 0.95,
		"col": "#ffd84a" if combo_hit else ("#ff8a8a" if vs == 0 else "#ffffff"), "big": combo_hit or J.t(sk)})
	if tag != null: text(hp_ + Vector2(0, -22), tag, tcol)
	if chain: text(center() + Vector2(0, -90), "連嚇！", "#ffd84a", 1.2, 20)
	if J.t(sk) and J.t(sk.get("apply")) and _nn(v, "hp") > 0:
		var ap = J.str(sk.apply)
		if ap == "air": v.st["air"] = 1.0; v.st["airMax"] = 1.0; v.st["down"] = 0.0
		if ap == "down": v.st["down"] = 1.4; v.st["downMax"] = 1.4; v.st["air"] = 0.0
		if ap == "push": v.st["push"] = 0.25; v["pushD"] = ((v.p as Vector2) - sp).normalized() if (v.p as Vector2).distance_to(sp) > 0.5 else Vector2(dir, 0)
		v["anim"] = null
	if J.t(sk) and J.t(sk.get("drain")): src["hp"] = minf(_nn(src, "maxhp"), _nn(src, "hp") + dmg * J.num(sk.drain))
	if J.t(sk) and J.t(sk.get("sap")): v["energy"] = maxf(0.0, _nn(v, "energy") - J.num(sk.sap))
	if J.t(sk) and J.t(sk.get("steal")) and _nn(src, "side") == 0: coins_won += J.num(sk.steal)
	if not J.t(sk): src["energy"] = minf(100.0, _nn(src, "energy") + 8)
	v["energy"] = minf(100.0, _nn(v, "energy") + 4)
	if _nn(v, "hp") <= 0:
		_load.erase(str(v.get("_id", "")))
		v["hp"] = 0.0; v["deadT"] = 0.0; v["dieDir"] = dir; v["anim"] = null; v["casting"] = null
		spark(hp_.lerp(v.p, 0.4), 1.6, "#ffffff")
		events.append(["down", v])
	_vq(["hit", src, v, J.t(sk) or combo_hit, _nn(v, "hp") <= 0])
	events.append(["hit", v])
	return dmg
func ab_down(v: Dictionary, dir: float) -> void:   # [ab] 倒下（同舊 hit 一樣嘅畫面同事件）
	_load.erase(str(v.get("_id", "")))
	v["hp"] = 0.0; v["deadT"] = 0.0; v["dieDir"] = dir; v["anim"] = null; v["casting"] = null
	spark(head(v).lerp(v.p, 0.4), 1.6, "#ffffff")
	events.append(["down", v])
func _state(v: Dictionary):
	if _nn(v.st, "air") > 0: return "air"
	if _nn(v.st, "down") > 0: return "down"
	return null

func do_skill(u: Dictionary, sk) -> void:
	if not J.t(sk): return
	if ab: AB.cast(self, u, sk); return   # [ab]
	var mult = J.num(sk.mult)
	var kd = J.str(sk.get("kind"))
	var sd = _nn(u, "side")
	if kd == "heal":
		for v in units:
			if _nn(v, "side") == sd and alive(v):
				var h = _nn(v, "maxhp") * J.num(sk.mult); v["hp"] = minf(_nn(v, "maxhp"), _nn(v, "hp") + h)
				text(head(v) + Vector2(0, -10), "+" + J.str(J.round(h)), "#8affb0", 0.9)
				_fx({"kind": "ring", "p": v.p, "life": 0.5, "col": "#8affb0"})
		if J.t(sk.get("forget")): for v in enemies_of(u): v["energy"] = 0.0
	elif kd == "aoe":
		for v in (AF.aoe_targets(self, u) if AF.on() else enemies_of(u)): hit(u, v, mult, sk)   # [abform] 半徑 130，唔再打全場
	else:
		var v = nearest(u)
		if v != null:
			var d = _sign((v.p as Vector2).x - (u.get("p", v.p) as Vector2).x)
			_fx({"kind": "slash", "p": head(v).lerp(v.p, 0.45), "dir": d if d != 0 else 1.0, "life": 0.22, "r": 34.0, "col": "#bbffff" if sd == 0 else "#ff99aa"})
			var hits = J.num(sk.get("hits")) if J.t(sk.get("hits")) else 0.0
			if hits > 1:
				for i in int(hits):
					if _nn(v, "hp") > 0:
						var s2 = sk
						if i != int(hits) - 1:
							s2 = sk.duplicate(); s2["apply"] = null; s2["sap"] = 0.0; s2["steal"] = 0.0
						hit(u, v, mult / hits, s2)
			else: hit(u, v, mult, sk)
	_vq(["skill", u, kd, nearest(u) if kd != "heal" and kd != "aoe" else null])
	var at = head(u) + Vector2(0, -34) if u.get("p") != null else center() + Vector2(0, -120)
	text(at, J.str(DB.L(J.str(sk.name))), "#bbffff" if sd == 0 else "#ff99aa", 1.1, 17)
	events.append(["skill", u])

func begin_cast(u: Dictionary) -> void:
	u["energy"] = 0.0
	if u.get("p") == null: adv_cast = {"u": u, "t": 0.0, "dur": CAST}; return
	u["anim"] = null; u["walking"] = false; u["casting"] = {"t": 0.0, "dur": CAST, "slow": false}
	_vq(["cast", u])
func cast(u: Dictionary) -> bool:   # 撳技能鈕（同 battle.cast 一樣嘅條件）
	if result != null or phase != "fight" or _nn(u, "energy") < 100: return false
	if u.get("hp") != null and _nn(u, "hp") <= 0: return false
	if u.get("p") != null and (_nn(u.st, "air") > 0 or _nn(u.st, "down") > 0 or J.t(u.get("casting"))): return false
	if u.get("p") == null and adv_cast != null: return false
	begin_cast(u)
	events.append(["cast", u])
	return true
func fire_cast(u: Dictionary) -> void: u["casting"] = null; do_skill(u, u.get("sk"))

# ================= 出手節奏 =================
func step_anim(u: Dictionary, dt: float) -> void:
	var a = u.anim; a["t"] = J.num(a.t) + dt; u["cd"] = _nn(u, "cd") - dt
	var ranged = _nn(u, "range") > 60
	var nm = J.str(a.name)
	if nm == "windup" and J.num(a.t) >= WIND:
		u["anim"] = {"name": "strike", "t": J.num(a.t) - WIND, "dur": STRIKE, "tg": a.get("tg")}
		if ranged: fire(u, a.get("tg"))
		return
	if nm == "strike":
		if not ranged and not J.t(a.get("done")) and J.num(a.t) >= IMPACT:
			a["done"] = true
			var tg = a.get("tg")
			if not (tg is Dictionary and alive(tg) and dist(tg, u) <= _nn(u, "range") + 24): tg = null
			if tg == null:
				var n = nearest(u)
				if n != null and dist(n, u) <= _nn(u, "range") + 24: tg = n
			if tg != null:
				u["cd"] = period(u)
				var d = _sign((tg.p as Vector2).x - (u.p as Vector2).x)
				if d == 0: d = -1.0 if _nn(u, "side") != 0 else 1.0
				_fx({"kind": "slash", "p": head(tg).lerp(tg.p, 0.45), "dir": d, "life": 0.17, "r": (18.0 if J.t(u.get("minion")) else 26.0) * (1.4 if J.t(u.get("boss")) else 1.0), "col": "#e8fbff" if _nn(u, "side") == 0 else "#ffd0c0"})
				_vq(["melee", u, tg])
				hit(u, tg, 1.0, null)
		if J.num(a.t) >= STRIKE: u["anim"] = {"name": "recover", "t": J.num(a.t) - STRIKE, "dur": REC}
		return
	if nm == "recover" and J.num(a.t) >= REC: u["anim"] = null
func fire(u: Dictionary, tg) -> void:
	if not (tg is Dictionary) or not alive(tg):
		tg = nearest(u)
		if tg == null: return
	u["cd"] = period(u) + maxf(0.0, dist(u, tg) - 10) / PSPD
	var p0 = head(u).lerp(u.p, 0.35) + Vector2(_nn(u, "face") * 12, 0)
	proj.append({"src": u, "tg": tg, "p": p0, "trail": [], "col": "#9ff3ff" if _nn(u, "side") == 0 else "#ff9ac0"})
func step_proj(dt: float) -> void:
	var keep = []
	for q in proj:
		if not (q.tg is Dictionary) or not alive(q.tg):
			q["tg"] = nearest(q.src)
			if q.tg == null: continue
		var tp = head(q.tg).lerp(q.tg.p, 0.45)
		var d = (tp - q.p).length(); var step = PSPD * dt
		q.trail.append(q.p)
		if q.trail.size() > 7: q.trail.pop_front()
		if d <= step + 4: _vq(["phit", q.src, q.tg, q.p]); hit(q.src, q.tg, 1.0, null); continue
		q["p"] = q.p + (tp - q.p) / d * step
		keep.append(q)
	proj = keep

func vis_tick(u: Dictionary, dt: float) -> void:
	if _nn(u, "hp") <= 0: u["deadT"] = _nn(u, "deadT") + dt
	u["flash"] = maxf(0.0, _nn(u, "flash") - dt / 0.18)
	u["hurtT"] = maxf(0.0, _nn(u, "hurtT") - dt)
	if u.get("kbT") != null:
		u["kbT"] = J.num(u.kbT) + dt
		if J.num(u.kbT) > 0.3: u["kbT"] = null

# ================= 每格 =================
func step(dt: float) -> void:
	T += dt
	var nfx = []
	for f in fx:
		f["t"] = J.num(f.t) + dt
		if J.num(f.t) < J.num(f.life): nfx.append(f)
	fx = nfx
	snd_t -= dt
	if hstop > 0.0:
		hstop -= dt
		if vfx_on and phase == "fight": return

	match phase:
		"march": _step_march(dt); _contact()
		"fight": _step_fight(dt)
		"end":
			for u in units: vis_tick(u, dt)
		"back": _step_back(dt)

# [sortiepos] 主角由自己而家企嘅位出發（例如已經行咗去大排檔）：先行一段「引路」去最近嘅行軍路線點，等隊伍行到先歸隊
func hero_lead(from) -> void:
	if not (from is Vector2) or path.size() < 2: return
	var fp: Vector2 = from
	if fp.distance_to(path[0]) < 40.0: return
	var js = _s_of(fp)
	var jp = _path_at(path, js, 0.0)
	for u in units:
		if _nn(u, "side") != 0 or J.t(u.get("minion")) or J.str(u.get("k")) != "afu": continue
		u["p"] = fp; u["pre"] = PackedVector2Array([fp, jp]); u["pre_s"] = 0.0; u["join_s"] = js; u["origin"] = fp
		if js >= gate_s: u["stamp"] = true   # 唔經村門：唔使打卡
func _walk_pre(u: Dictionary, dt: float, spd: float) -> bool:   # 回 true＝仲喺引路／等歸隊（呢格唔行主路）
	u["s"] = _nn(u, "s") + spd * dt   # 隊伍次序照計
	var pre: PackedVector2Array = u.pre
	var pl = MD.poly_len(pre)
	if not J.t(u.get("out")): u["out"] = true; events.append(["depart", u])
	if _nn(u, "pre_s") < pl:
		var p0: Vector2 = u.p
		u["pre_s"] = minf(pl, _nn(u, "pre_s") + spd * dt)
		u["p"] = MD.poly_at(pre, _nn(u, "pre_s"))
		var dx = (u.p as Vector2).x - p0.x
		if absf(dx) > 0.02: u["face"] = _sign(dx)
		u["walking"] = true
		return true
	if _nn(u, "s") < _nn(u, "join_s"): u["walking"] = false; return true   # 到咗會合點：等隊伍
	u["s"] = _nn(u, "join_s"); u.erase("pre")
	return false
func _walk_path(u: Dictionary, dt: float, spd: float, pts: PackedVector2Array, plen: float) -> bool:   # 回 true＝行到尾
	if phase != "back" and u.has("pre") and _walk_pre(u, dt, spd): return false   # [sortiepos]
	var p0: Vector2 = u.p
	u["s"] = _nn(u, "s") + spd * dt
	if _nn(u, "s") < 0.0: u["walking"] = false; return false
	if not J.t(u.get("out")): u["out"] = true; events.append(["depart", u])
	var done = _nn(u, "s") >= plen
	if done: u["s"] = plen
	var lt = _nn(u, "lat") * (1.0 - clampf((_nn(u, "s") - (plen - 60.0)) / 60.0, 0.0, 1.0)) if phase != "back" else _nn(u, "lat")
	if phase != "back" and u.has("wl"): lt = _nn(u, "wl")   # 展開中／已展開：用橫隊橫位
	u["p"] = _path_at(pts, _nn(u, "s"), lt)
	var dx = (u.p as Vector2).x - p0.x
	if absf(dx) > 0.02: u["face"] = _sign(dx)
	u["walking"] = not done
	if phase != "back" and not J.t(u.get("stamp")) and _nn(u, "s") >= gate_s:   # 出村門：上班打卡
		u["stamp"] = true; events.append(["stamp", u, "打卡"])
	return done

func _step_march(dt: float) -> void:
	for u in units:
		vis_tick(u, dt)
		if _nn(u, "side") != 0:
			if foe_from != null and u.get("post") is Vector2:   # 惡鬼由野地行入嚟
				var d = (u.post as Vector2) - (u.p as Vector2)
				if d.length() > 2.0:
					u["p"] = (u.p as Vector2) + d.normalized() * minf(d.length(), 40.0 * dt); u["walking"] = true; u["face"] = _sign(d.x) if absf(d.x) > 1 else u.get("face", -1.0)
				else: u["walking"] = false
			continue
		_deploy_walk(u, dt)
	# 全部到位（或者等夠鐘）→ 成條橫隊一齊推前
	if not dep_go:
		var all_in = true; var any_in = false
		for u in units:
			if _nn(u, "side") != 0 or _nn(u, "hp") <= 0: continue
			if int(_nn(u, "dep")) >= 1: any_in = true
			else: all_in = false
		if any_in: dep_t += dt
		if any_in and (all_in or dep_t >= DEP_WAIT):
			dep_go = true; events.append(["deploy", null])

func _stop_s(u: Dictionary) -> float: return path_len - DEPLOY - _nn(u, "drow") * ROWGAP
func _deploy_walk(u: Dictionary, dt: float) -> void:
	if u.has("pre"): _walk_path(u, dt, MARCH, path, path_len); return   # [sortiepos] 引路中
	if not u.has("dl"): _walk_path(u, dt, MARCH, path, path_len); return
	var stop = _stop_s(u)
	if dep_go:   # 推前：同一速度，行住橫隊
		u["wl"] = _nn(u, "dl"); u["dep"] = 2
		_walk_path(u, dt, MARCH, path, path_len); return
	var s0 = _nn(u, "s")
	if s0 >= stop:   # 到位：企定等後面
		u["dep"] = 1; u["wl"] = _nn(u, "dl")
		u["p"] = _path_at(path, s0, _nn(u, "dl")); u["walking"] = false
		u["face"] = _sign(_dir_in().x) if absf(_dir_in().x) > 0.1 else u.get("face", 1.0)
		return
	# 未到位：前面有人等緊就跑步；最後 120px 斜斜行去自己橫位
	var any_wait = dep_t > 0.0
	var k = clampf((s0 - (stop - 120.0)) / 120.0, 0.0, 1.0)
	if k > 0.0: u["wl"] = lerpf(_nn(u, "lat"), _nn(u, "dl"), k)
	_walk_path(u, dt, MARCH * (1.35 if any_wait else 1.0), path, path_len)
	if _nn(u, "s") > stop: u["s"] = stop

func _contact() -> void:
	for u in units:
		if _nn(u, "side") != 0 or not alive(u): continue
		for v in units:
			if _nn(v, "side") == 1 and alive(v) and dist(u, v) <= AGGRO:
				phase = "fight"; t = 0.0
				_form()
				events.append(["contact", null])
				for e in units:
					if _nn(e, "side") == 1 and _nn(e, "hp") > 0: text(head(e) + Vector2(0, -16), "！", "#ffdd55", 0.9, 24)
				return

# 接觸：定兩條陣線（我方一條、敵方一條，橫排站開；遠程企後一行）
func _lat(p: Vector2) -> float: return (p - org).dot(perp)
func _axl(p: Vector2) -> float: return (p - org).dot(ax)
func _form() -> void:
	var fo = []; var ou = []
	for u in units:
		if _nn(u, "hp") <= 0: continue
		if _nn(u, "side") == 1: fo.append(u)
		else: ou.append(u)
	var c0 = Vector2.ZERO
	for u in fo: c0 += u.p
	c0 = c0 / maxf(1, fo.size()) if fo.size() else anchor
	var c1 = path[path.size() - 1] if path.size() else c0 + Vector2(0, 120)
	ax = (c0 - c1).normalized() if c0.distance_to(c1) > 1 else Vector2(0, -1)
	perp = Vector2(-ax.y, ax.x); org = (c0 + c1) * 0.5
	var mel = []; var rng = []
	for u in ou: (rng if _nn(u, "range") > 60 else mel).append(u)
	# 近身：陰兵小隊頂正面（同舊版小隊企最前一樣），名鬼喺兩翼包抄
	var hs = mel.filter(func(x): return not J.t(x.get("minion")))
	var sq = mel.filter(func(x): return J.t(x.get("minion")))
	var line = hs.slice(0, (hs.size() + 1) / 2) + sq + hs.slice((hs.size() + 1) / 2)
	if AF.on(): AF.slots(AF.line_order(mel), 42.0)   # [abform] [翼][小隊][前排名鬼][小隊][前排名鬼][小隊][翼]
	else: _slots(line, 42.0)
	_slots(rng, 46.0)
	fo.sort_custom(func(a, b): return _lat(a.p) < _lat(b.p))
	_slots(fo, 46.0)
	if tune_open > 0.0:
		for u in ou: u["cd"] = maxf(_nn(u, "cd"), tune_open)
func _slots(arr: Array, gap: float) -> void:
	var h = (arr.size() + 1) / 2   # 兩行排法：人多過對面陣線闊就分前後兩行（後行補位），唔會疊成直龍
	for i in arr.size():
		arr[i]["ls"] = (i - (arr.size() - 1) * 0.5) * gap
		var row = i % 2; var j = i / 2; var nr = h if row == 0 else arr.size() - h
		arr[i]["row"] = row; arr[i]["ls2"] = (j - (nr - 1) * 0.5) * gap
# 陣線走位：守住自己橫位，沿軸向前去到「對面最近嗰隻」射程邊；對面冇人先橫移
func _line_tg(u: Dictionary):
	if AF.on(): return AF.line_tg(self, u)   # [abform] 威脅值＋每隻目標最多 3 個近戰
	var cur = u.get("tg")
	var my = float(u.get("ls", _lat(u.p)))
	if cur is Dictionary and alive(cur) and absf(_lat(cur.p) - my) < 90.0: return cur
	var best = null; var bk = 1e9
	for v in enemies_of(u):
		var k = absf(_lat(v.p) - my) * 1.6 + absf(_axl(v.p) - _axl(u.p)) * 0.4
		if tune_minion != 0.0 and _nn(u, "side") == 1 and J.t(v.get("minion")): k -= tune_minion
		if k < bk: bk = k; best = v
	u["tg"] = best
	return best
var _span := {}   # side → [對面中心, 對面半闊, 自己半闊]（每格算一次）
func _spans() -> void:
	for sd in [0, 1]:
		var lo = INF; var hi = -INF; var mine = 0.0
		for v in units:
			if _nn(v, "hp") <= 0: continue
			if _nn(v, "side") != sd and alive(v): var l = _lat(v.p); lo = minf(lo, l); hi = maxf(hi, l)
			elif _nn(v, "side") == sd: mine = maxf(mine, absf(float(v.get("ls", 0.0))))
		var mine2 = 0.0
		for v in units: if _nn(v, "side") == sd and _nn(v, "hp") > 0: mine2 = maxf(mine2, absf(float(v.get("ls2", 0.0))))
		_span[sd] = [(lo + hi) * 0.5 if lo < INF else 0.0, (hi - lo) * 0.5 if lo < INF else 0.0, mine, mine2]
func _line_want(u: Dictionary, tg: Dictionary) -> Vector2:
	# 自己陣位按比例壓入「對面陣線闊度 + 兩翼」：保持次序、排成一條線（人多過對面就兩翼包抄，唔會疊成一條直龍）
	var sp = _span.get(int(_nn(u, "side")), [0.0, 0.0, 0.0, 0.0])
	var ls = float(u.get("ls", 0.0))
	var k = minf(1.0, (float(sp[1]) + 56.0) / maxf(1.0, float(sp[2])))
	var back = 0.0
	if k < 0.85 and u.has("ls2"):   # 一行擺唔落：分兩行，後行企後 40px
		ls = float(u.ls2); k = minf(1.0, (float(sp[1]) + 56.0) / maxf(1.0, float(sp[3])))
		back = 40.0 * float(u.get("row", 0))
	var my = float(sp[0]) + ls * k
	var sg = 1.0 if _nn(u, "side") == 0 else -1.0
	var a = _axl(tg.p) - sg * (_nn(u, "range") * 0.85 + back)
	return org + perp * my + ax * a

func _step_fight(dt: float) -> void:
	auto = J.t(J.gp(J.G.get("Battle"), "auto")) if J.G.get("Battle") != null else auto
	t += dt
	step_proj(dt)
	_spans()
	var af = AF.on()   # [abform]
	if af: AF.pre_tick(self, dt)
	for u in units:
		vis_tick(u, dt)
		if _nn(u, "hp") <= 0: continue
		if ab and AB.tick_unit(self, u, dt): continue   # [ab] 定身／驚走／迷魂／dot／再生
		if _nn(u, "side") == 0 and not J.t(u.get("eng")):   # 未到前線：照路線行；有敵人入咗接觸範圍就開打
			var n0 = nearest(u) if present(u) else null
			if n0 != null and dist(u, n0) <= AGGRO * 2.6: u["eng"] = true   # 開打咗：近戰場嘅直接去自己陣位（排成一條線），遠嘅照路線行
			elif _walk_path(u, dt, MARCH * 1.3, path, path_len): u["eng"] = true   # 開打咗：後面嘅跑步上前
			continue
		var st = u.st
		if _nn(st, "air") > 0:
			if J.t(u.get("casting")): fire_cast(u)
			u["anim"] = null; st["air"] = J.num(st.air) - dt; continue
		if _nn(st, "down") > 0:
			if J.t(u.get("casting")): fire_cast(u)
			u["anim"] = null; st["down"] = J.num(st.down) - dt; continue
		if _nn(st, "push") > 0:
			u["anim"] = null; st["push"] = J.num(st.push) - dt
			u["p"] = (u.p as Vector2) + (u.get("pushD", Vector2.ZERO) as Vector2) * 160.0 * dt
			continue
		if u.get("yb_heal") is Dictionary:   # [yinbing] 醫護兵：唔出手，定時醫身邊血最少嘅陰兵／遊魂兵（唔醫名鬼）
			var hr = YB.heal_tick(self, u, dt)
			if hr != null:
				text(head(hr[1]) + Vector2(0, -10), "+" + str(int(round(float(hr[0])))), "#8affb0", 1.1, 17)
				_vq(["ybheal", u, hr[1]])
		if J.t(u.get("sk")): u["energy"] = minf(100.0, _nn(u, "energy") + (11.0 if J.t(u.get("boss")) else 9.0) * dt * (AB.emul(self, u) if ab else 1.0))   # [ab] 嚇氣光環／封口
		if J.t(u.get("casting")):
			u["cd"] = _nn(u, "cd") - dt
			u.casting["t"] = J.num(u.casting.t) + dt
			if J.num(u.casting.t) >= J.num(u.casting.dur): fire_cast(u)
			continue
		var may_auto = _nn(u, "side") == 1 or (AH.auto_of(u, auto) and not J.t(u.get("minion")))   # [整合] abui 每隻名鬼自動／手動
		if af:   # [abform] 自動施放 AI（6 條件＋5 秒保底；敵人都經 AI）
			if may_auto and J.t(u.get("sk")) and not J.t(u.get("anim")) and AF.want_cast(self, u, dt): begin_cast(u); continue
		elif J.t(u.get("sk")) and _nn(u, "energy") >= 100 and not J.t(u.get("anim")) and may_auto: begin_cast(u); continue
		if J.t(u.get("anim")): step_anim(u, dt); continue
		var ft = AF.flank_tg(self, u) if af else null   # [abform] 側翼繞後
		var tg = ft if ft != null else _line_tg(u)
		if ab: tg = AB.pick_fix(self, u, tg)   # [ab] 嘲諷／突襲／刺／隱身（整合：在 abform 揀目標之後修正）
		if tg == null: u["walking"] = false; continue
		var d = dist(u, tg)
		var dx = (tg.p as Vector2).x - (u.p as Vector2).x
		if absf(dx) > 3.0: u["face"] = _sign(dx)
		if d > _nn(u, "range") + 12.0:
			var want = AF.want(self, u, tg, d) if af else _line_want(u, tg)   # [abform] 近身時喺目標自己嗰邊側身企（唔再直衝成一團）
			var dv = (want - (u.p as Vector2))
			if af: pass
			elif dv.length() < 3.0 or (d < _nn(u, "range") + CLOSE and want.distance_to(tg.p) > d): dv = (tg.p as Vector2) - (u.p as Vector2)   # [qaudit2] 陣位反而離目標更遠：直接埋身
			u["p"] = (u.p as Vector2) + dv.normalized() * minf(_nn(u, "spd") * dt, dv.length()); u["walking"] = true
		else:
			u["walking"] = false; u["cd"] = _nn(u, "cd") - dt
			if J.num(u.cd) <= lead_of(u, tg) and not (u.get("yb_heal") is Dictionary): u["anim"] = {"name": "windup", "t": 0.0, "dur": WIND, "tg": tg}
	# 軍師（唔上場）
	if adviser is Dictionary:
		adviser["energy"] = minf(100.0, _nn(adviser, "energy") + 7 * dt)
		if auto and J.num(adviser.energy) >= 100 and adv_cast == null: cast(adviser)
	if adv_cast != null:
		adv_cast["t"] = J.num(adv_cast.t) + dt
		if J.num(adv_cast.t) >= J.num(adv_cast.dur):
			var cu = adv_cast.u; adv_cast = null; do_skill(cu, cu.get("sk"))
	if ab: AB.tick(self, dt)   # [ab] 機制計時、光環、合體技、召喚物入場
	if af: AF.guard_tick(self, dt)   # [abform] 前排名鬼護衛身邊陰兵
	_separate(dt)
	if foes_alive() == 0: finish(true)
	elif (heroes_alive() == 0 and not no_heroes) or (no_heroes and _ours_alive() == 0): finish(false)
	elif t >= TIME_LIMIT: finish(false, false, true)

# 揀目標：黐住而家嗰個；冇就揀「近 ＋ 少人打緊」嘅（唔好全部擠埋一隻）
var _load := {}
func _pick(u: Dictionary):
	var cur = u.get("tg")
	if cur is Dictionary and alive(cur): return cur
	var best = null; var bk = 1e9
	for v in enemies_of(u):
		var k = dist(u, v) + 45.0 * float(_load.get(str(v.get("_id", "")), 0))
		if k < bk: bk = k; best = v
	if best != null:
		var key = str(best.get("_id", ""))
		u["slot"] = int(_load.get(key, 0)); _load[key] = int(_load.get(key, 0)) + 1
	u["tg"] = best
	return best
# 圍住目標嘅位：正面、左右 40°、80°、120°（近身兵按次序排開，遠程企後啲）
const SLOT_A := [0.0, 0.7, -0.7, 1.4, -1.4, 2.1, -2.1, 2.6, -2.6]
func _slot_pos(u: Dictionary, tg: Dictionary) -> Vector2:
	var base: Vector2 = (u.p as Vector2) - (tg.p as Vector2)
	var fr = anchor - path[path.size() - 1] if path.size() else Vector2(0, -1)   # 我方 → 敵方
	if _nn(u, "side") == 0: base = -fr
	else: base = fr
	if base.length() < 0.01: base = Vector2(1, 0)
	base = base.normalized()
	var a = SLOT_A[int(_nn(u, "slot")) % SLOT_A.size()]
	var r = _nn(u, "range") * 0.85 + (6.0 if J.t(u.get("minion")) else 10.0)
	return (tg.p as Vector2) + base.rotated(a) * r
func _separate(dt: float) -> void:
	if AF.on(): AF.separate(self, dt); return   # [abform] 同邊沿橫向推、異邊沿軸推
	var al = []
	for u in units: if alive(u) and (_nn(u, "side") == 1 or J.t(u.get("eng"))): al.append(u)
	for i in al.size():
		for j in range(i + 1, al.size()):
			var a = al[i]; var b = al[j]
			var same = _nn(a, "side") == _nn(b, "side")
			var lim = (42.0 if J.t(a.get("minion")) and J.t(b.get("minion")) else 34.0) if same else 26.0   # 小隊三個代表兵闊約 40
			var d: Vector2 = (b.p as Vector2) - (a.p as Vector2)
			var L = d.length()
			if L >= lim: continue
			var n = d / L if L > 0.01 else Vector2(1, 0).rotated(float(i * 7 + j))
			var k = (lim - L) * 5.0 * dt
			a["p"] = (a.p as Vector2) - n * k; b["p"] = (b.p as Vector2) + n * k

func finish(win: bool, quit := false, timeout := false) -> void:
	if result != null: return
	result = {"win": win, "quit": quit, "timeout": timeout}
	if ab: AB.report(self)   # [ab]
	phase = "end"
	for u in units: u["walking"] = false; u["casting"] = null
	proj.clear()
	events.append(["result", result])
	if win and not quit and vfx_on and not has_meta("j_slow"):   # [juice] 終結慢鏡：喺結算一刻觸發（只限鏡頭內嗰場；背景仗唔好拖慢全遊戲）
		var JU = load("res://ui/juice.gd")
		if JU.on(): set_meta("j_slow", true); JU.vib(40); JU.slowmo(0.4, 0.55)

# ================= 回村 =================
func recall() -> void:   # 叫回：行軍中＝乜都冇發生；交戰中＝撤退（由 rts.gd 結算）
	recalled = true
	if phase == "march": result = {"win": false, "quit": true, "timeout": false, "none": true}; begin_back()
	elif phase == "fight": finish(false, true)
func begin_back() -> void:
	phase = "back"
	var back = path.duplicate(); back.reverse()
	var i = 0
	for u in units:
		if _nn(u, "side") != 0:
			u["walking"] = false; u["anim"] = null
			continue
		if not J.t(u.get("out")): u["home"] = true; continue   # 未出村門嘅：直接收隊
		if J.t(u.get("minion")) and _nn(u, "hp") <= 0: continue   # 全隊倒咗：留喺度淡出
		if _nn(u, "hp") <= 0: u["hp"] = maxf(1.0, _nn(u, "maxhp") * 0.05); u["deadT"] = 0.0   # 名鬼：企返起身行返去（同舊版）
		u.st.clear(); u["anim"] = null; u["casting"] = null; u["kbT"] = null; u["hurtT"] = 0.0
		var pts = PackedVector2Array([u.p])
		var s0 = _s_of(u.p)
		var rev_from = path_len - s0
		var bl = MD.poly_len(back)
		# 由最近嗰點開始沿路返
		var acc = 0.0
		for k in back.size():
			if k > 0: acc += back[k - 1].distance_to(back[k])
			if acc >= rev_from: pts.append(back[k])
		if u.get("origin") is Vector2: pts = _back_to_origin(u)   # [sortiepos] 主角：行返出發嗰度（例如大排檔），唔係村口
		u["bp"] = pts; u["blen"] = MD.poly_len(pts); u["s"] = -i * 14.0; u["lat"] = _nn(u, "lat")
		u["stamp"] = false; u["sal"] = -1.0
		i += 1
	events.append(["back", null])
func _back_to_origin(u: Dictionary) -> PackedVector2Array:   # [sortiepos] 而家位 → 沿路倒行到會合點 → 引路倒返出發點
	var pts = PackedVector2Array([u.p])
	if u.has("pre"):   # 未歸隊就收隊：直接行返出發點
		u.erase("pre"); pts.append(u.origin); return pts
	var js = _nn(u, "join_s")
	var cur = maxf(js, _s_of(u.p))
	var acc = []; var a = 0.0
	for k in path.size():
		if k > 0: a += path[k - 1].distance_to(path[k])
		acc.append(a)
	for k in range(path.size() - 1, -1, -1):
		if acc[k] < cur and acc[k] > js: pts.append(path[k])
	if cur > js: pts.append(_path_at(path, js, 0.0))
	pts.append(u.origin)
	return pts
func _sync_village_hero(p: Vector2) -> void:
	var V = J.G.get("Village")
	if not (V is Dictionary) or not (V.get("hero") is Dictionary): return
	var H = V.hero
	H["x"] = p.x; H["y"] = p.y; H["tx"] = p.x; H["ty"] = p.y; H["walking"] = false; H["target"] = null
func _step_back(dt: float) -> void:
	var all_home = true
	for u in units:
		vis_tick(u, dt)
		if _nn(u, "side") == 1:
			if _nn(u, "hp") > 0 and u.get("post") is Vector2:   # 敵人：行返據點慢慢回血
				var d = (u.post as Vector2) - (u.p as Vector2)
				if d.length() > 2.0: u["p"] = (u.p as Vector2) + d.normalized() * minf(d.length(), 40.0 * dt); u["walking"] = true; u["face"] = _sign(d.x) if absf(d.x) > 1 else u.face
				else: u["walking"] = false
				u["hp"] = minf(_nn(u, "maxhp"), _nn(u, "hp") + _nn(u, "maxhp") * 0.08 * dt)
			continue
		if J.t(u.get("home")) or not (u.get("bp") is PackedVector2Array): continue
		if _nn(u, "sal") >= 0.0:   # 敬禮緊
			u["sal"] = _nn(u, "sal") + dt
			if _nn(u, "sal") >= SALUTE:
				u["home"] = true; events.append(["home", u])
				if u.get("origin") is Vector2: _sync_village_hero(u.p)   # [sortiepos] 村入面嘅主角就喺收隊嗰度出現，唔會閃去第二度
			else: all_home = false
			continue
		all_home = false
		var p0: Vector2 = u.p
		u["s"] = _nn(u, "s") + BACK * dt
		if _nn(u, "s") < 0.0: continue
		var done = _nn(u, "s") >= _nn(u, "blen")
		u["p"] = _path_at(u.bp, minf(_nn(u, "s"), _nn(u, "blen")), _nn(u, "lat"))
		var dx = (u.p as Vector2).x - p0.x
		if absf(dx) > 0.02: u["face"] = _sign(dx)
		u["walking"] = not done
		if not J.t(u.get("stamp")) and (u.p as Vector2).distance_to(gate) < 26.0:
			u["stamp"] = true; events.append(["stamp", u, "收工" if result != null and J.t(result.get("win")) else "早退"])
		if done: u["sal"] = 0.0; u["walking"] = false; u["face"] = -1.0 if (gate.x < (u.p as Vector2).x) else 1.0
	if all_home and T > 0.5: phase = "done"; events.append(["done", null])

# ================= 測試 =================
func t_skip_march() -> void:   # 成隊（保持次序）推到離迎戰點 200px
	var mx = -INF
	for u in units: if _nn(u, "side") == 0: mx = maxf(mx, _nn(u, "s"))
	var sh = maxf(0.0, path_len - 200.0 - mx)
	for u in units:
		if _nn(u, "side") == 0: u["s"] = _nn(u, "s") + sh
		if u.has("pre"): u.erase("pre")   # [sortiepos]
	dep_go = true   # 測試跳行軍：當已排好
	for u in units:
		if _nn(u, "side") == 0 and u.has("dl"): u["wl"] = _nn(u, "dl"); u["dep"] = 2
