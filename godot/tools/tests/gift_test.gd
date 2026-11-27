# [gift] 測試大禮包存檔碼：解碼、開場未完唔派、開場完先派（res／mat 唔受上限／寶箱）、派完刪 gift
extends RefCounted
var ok := 0
var bad := 0
func _p(m): print("[gift] ", m)
func _chk(n: String, c: bool, e = "") -> void:
	if c: ok += 1; _p("ok  " + n + "　" + str(e))
	else: bad += 1; _p("BAD " + n + "　" + str(e))
func _main(t): return t.get_tree().root.get_node_or_null("Main")
func all(t) -> void:
	await t.get_tree().create_timer(2.0).timeout
	var m = _main(t)
	var NC = load("res://ui/name_card.gd")
	for f in ["/tmp/gift/GiftSave_Player1.txt", "/tmp/gift/GiftSave_Player2.txt"]:
		if not FileAccess.file_exists(f):   # [p45] 存檔碼唔喺 repo（README：容器重開後冇咗，要老闆再提供）：清楚報缺檔，唔好行落去報腳本錯誤
			_chk("存檔碼檔案存在 " + f + "（唔喺 repo，要老闆再提供）", false); continue
		var code = FileAccess.get_file_as_string(f)
		var o = G.dec(code)
		_chk("解碼 " + f.get_file(), o is Dictionary and o.has("gift"))
		G.S = o; J.G["S"] = o
		_chk("開場未完（會播開場＋改名卡）", NC.opening_unfinished(G.S) and not NC.hero_set(G.S))
		m._gift_tick()
		_chk("開場未完唔派", G.S.has("gift") and J.num(G.S.res.coins) == 0)
		G.S.hero.set = true; G.S.seen["prologue_sys"] = 1
		m.title_ov = null; m.phone = null; m.loading = null; m.selftest = null
		m._gift_tick()
		var MATm = load("res://game/outpost/mat.gd")
		_chk("派咗冥幣 200 萬", J.num(G.S.res.coins) == 2000000, G.S.res.coins)
		_chk("派咗陰兵 3000", J.num(G.S.res.troops) == 3000)
		_chk("材料唔受倉庫上限：竹 2000", is_equal_approx(MATm.amt("m_bamboo"), 2000.0), MATm.amt("m_bamboo"))
		_chk("寶箱 金30 銀15 紫5", J.num(G.S.chests.g) == 30 and J.num(G.S.chests.b) == 15 and J.num(G.S.chests.p) == 5)
		_chk("派完刪 gift", not G.S.has("gift"))
		_chk("開場判斷之後唔會再當未完", not NC.opening_unfinished(G.S))
	print("[gift] RESULT ok=%d bad=%d" % [ok, bad])
