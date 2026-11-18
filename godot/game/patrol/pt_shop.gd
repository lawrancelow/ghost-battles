# 巡陰地圖：甘榜「村口雜貨店」（第 1 區地標 1）——店舖＋雜貨店伯，可以撳佢傾偈
# 支線「賒數簿」（c2_shop）：未完成 → 佢講現時要做乜同進度；完成之後 → 每日可以喺佢度賒一份貨（寫入賒數簿）
# 圖：店舖用 store（村子倉庫同款木舖），人物用 npc_shop（劇情入面嘅雜貨店伯）
class_name PtShop
extends RefCounted

const CI := 1          # 甘榜
const LM := 1          # LMNAME[1][1] = 村口雜貨店
const QID := "c2_shop"
const OFF := Vector2(122, -6)     # 店舖相對地標木牌嘅位置
const TALK_R := 230.0            # 阿福要行到幾近先傾得偈

static func find(run) -> Variant:
	if run.ci != CI: return null
	for sp in run.spots:
		if sp.k == "lm" and int(sp.id) == LM: return sp
	return null

static func pos(sp) -> Vector2: return Vector2(sp.x, sp.y) + OFF

# ---------------- 畫 ----------------
static func draw(c: CanvasItem, run, t: float) -> void:
	# 原點 = 店舖底中間
	var st: Texture2D = PtGfx.tex("store")
	run._ell(c, 0, 4, 64, 13, Color(0, 0, 0, 0.38))
	if st:
		var h = 122.0; var w = h * st.get_width() / st.get_height()
		c.draw_texture_rect(st, Rect2(-w / 2, -h + 6, w, h), false)
	# 門口膠凳＋紙箱
	var stl: Texture2D = PtGfx.tex("pr_stools"); var bx: Texture2D = PtGfx.tex("pr_boxes")
	if bx: var bh = 30.0; c.draw_texture_rect(bx, Rect2(48, -bh + 6, bh * bx.get_width() / bx.get_height(), bh), false)
	if stl: var sh = 30.0; c.draw_texture_rect(stl, Rect2(-86, -sh + 8, sh * stl.get_width() / stl.get_height(), sh), false)
	# 招牌
	var fnt = PtGfx.font(900); var txt = "雜貨店"; var fs = 13
	var tw = fnt.get_string_size(txt, HORIZONTAL_ALIGNMENT_LEFT, -1, fs).x + 16
	c.draw_rect(Rect2(-tw / 2, -128, tw, 20), Color("#7a2a1c")); c.draw_rect(Rect2(-tw / 2, -128, tw, 20), Color("#1a0c06"), false, 2)
	c.draw_string(fnt, Vector2(-tw / 2 + 8, -113), txt, HORIZONTAL_ALIGNMENT_LEFT, -1, fs, Color("#f4e2b0"))
	# 雜貨店伯：企喺門口左邊，輕輕浮
	var np: Texture2D = PtGfx.tex("npc_shop")
	if np:
		var bob = sin(t * 2.0) * 2.0; var nh = 66.0; var nw = nh * np.get_width() / np.get_height()
		run._ell(c, -46, 10, 16, 5, Color(0, 0, 0, 0.3))
		c.draw_texture_rect(np, Rect2(-46 - nw / 2, 8 - nh + bob, nw, nh), false)
		# 有嘢講就喺頭頂出個對話泡
		if has_news(run):
			var by = 8 - nh + bob - 16; var pul = 1.0 + 0.08 * sin(t * 5.0)
			c.draw_circle(Vector2(-46, by), 11 * pul, Color("#f4e2b0")); c.draw_arc(Vector2(-46, by), 11 * pul, 0, TAU, 20, Color("#1a0c06"), 2)
			c.draw_string(fnt, Vector2(-50, by + 5), "！", HORIZONTAL_ALIGNMENT_LEFT, -1, 13, Color("#9c2219"))

# ---------------- 狀態 ----------------
static func _q() -> Variant: return QX.sq().get(QID)
static func _today() -> String: return QX._today()
static func _book() -> Dictionary:
	var s = QX.S()
	if not (s.get("zhs") is Dictionary): s["zhs"] = {"day": "", "n": 0.0}
	return s.zhs

static func has_news(_run) -> bool:
	var e = _q()
	if e == null: return false
	if not J.t(e.get("done")): return true
	return _book().day != _today()   # 今日仲未賒

# ---------------- 撳 ----------------
# 撳到店舖／伯伯就返 true（食咗呢下）
static func tap(run, wp: Vector2) -> bool:
	var sp = find(run)
	if sp == null: return false
	var p = pos(sp)
	if not Rect2(p.x - 80, p.y - 130, 160, 145).has_point(wp): return false
	var d = Vector2(p.x - run.L.x, (p.y - run.L.y) * 1.2).length()
	if d > TALK_R:
		run.msg(run.T("行埋去雜貨店先同伯伯傾偈", "走近雜貨店再跟伯伯說話"), 2.0); return true
	talk(run)
	return true

static func _ln(yue: String, zh: String) -> Array: return ["雜貨店伯", [yue, zh]]

const CHAT := [
	["今日又嚟賒？寫低，寫低。", "今天又來賒帳？寫下來，寫下來。"],
	["呢本簿有成條村嘅名，你個名寫喺最尾。", "這本簿子有整個村子的名字，你的名字寫在最後。"],
	["個細鬼而家晚晚喺門口坐，攬住個錢罌唔出聲。我由得佢。", "那個小鬼現在每晚在門口坐，抱著錢罐不出聲。我隨他。"],
	["你哋做鬼都要返工？咁辛苦，飲支汽水先。", "你們做鬼也要上班？這麼辛苦，先喝瓶汽水。"],
	["我唔怕鬼。最驚係有人走咗，條數冇人記。", "我不怕鬼。最怕的是有人走了，帳沒人記。"],
	["包嘢仲熱，拎去俾你啲夥計食。", "包子還熱，拿去給你的夥計吃。"],
]
const GIFT := {"buns": 30.0, "rice": 30.0}

static func talk(run) -> void:
	var e = _q(); var lines: Array = []
	# 每次出巡第一次同伯伯傾：重溫支線「賒數簿」嘅故事（開頭；完成咗就連結尾），之後先講近況
	if e != null and not run.get_meta("shop_story", false):
		run.set_meta("shop_story", true)
		var x = QX.sdef(QID)
		if x.get("start") != null:
			var sc = x.start.duplicate(); sc.title = "支線・" + QX.T(x.title); QX._story(sc)
		if J.t(e.get("done")) and x.get("end") != null:
			var se = x.end.duplicate(); se.title = "支線・" + QX.T(x.title) + "（結局）"; QX._story(se)
	if e == null:
		lines = [_ln("後生仔，咁夜仲行嚟行去？入嚟坐吓，鋪頭照開。", "年輕人，這麼晚還走來走去？進來坐一下，店照常開。")]
	elif not J.t(e.get("done")):
		var x = QX.sdef(QID); var st = int(e.step)
		var pr = QX._step_prog(x, e)
		if st == 0:
			lines = [_ln("啲細鬼又嚟偷嘢喇，你幫我趕走佢哋先。", "那些小鬼又來偷東西了，你先幫我趕走他們。"),
				["旁白", ["（支線「賒數簿」：打走甘榜嘅小鬼 %d/%d）" % pr, "（支線「賒帳簿」：打走村裡的小鬼 %d/%d）" % pr]]]
		else:
			lines = [_ln("地下啲細腳印，一路去咗高腳屋後面。嗰度有個 Toyol 竇。", "地上那些小腳印，一路往高腳屋後面去了。那裡有個 Toyol 窩。"),
				["旁白", ["（支線「賒數簿」：去 Toyol 老窩搵返個錢罌）", "（支線「賒帳簿」：去 Toyol 老窩找回錢罐）"]]]
	else:
		var b = _book(); var c = CHAT[int(J.num(b.n)) % CHAT.size()]
		lines = [_ln(c[0], c[1])]
		if b.day != _today():
			b.day = _today(); b.n = J.num(b.n) + 1.0
			var got = J.str(J.cl(J.G.get("give"), null, [GIFT.duplicate()]))
			lines.append(["旁白", ["（伯伯喺賒數簿寫低第 %d 筆：「阿福」。%s）" % [int(b.n), got], "（伯伯在賒帳簿寫下第 %d 筆：「阿福」。%s）" % [int(b.n), got]]])
			Snd.play("coin"); run.persist()
		else:
			lines.append(_ln("今日賒咗喇，聽日先再嚟。", "今天已經賒過了，明天再來。"))
	QX._story({"style": "talk", "bg": "kampung", "title": "村口雜貨店", "lines": lines})
