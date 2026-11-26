# [yinbing] 陰兵兵種×階級 數據測試（phase 1：查表、★對應、圖鍵退返現版、唔郁數值）
# 用法：/home/claude/setup/edtest.sh <godot目錄> yinbing res://tools/tests/yinbing_test.gd logic 120
extends RefCounted

var ok := 0
var bad := 0
const YB = preload("res://game/yinbing/yb_data.gd")
func _chk(name: String, cond: bool, extra = "") -> void:
	if cond: ok += 1; print("[yb] ok  ", name, "　", extra)
	else: bad += 1; print("[yb] BAD ", name, "　", extra)
func logic(t) -> void:
	_chk("數據讀到", YB.on())
	_chk("4 兵種", YB.classes().size() == 4)
	_chk("4 階級", YB.ranks().size() == 4)
	var n = 0
	for c in YB.classes():
		for r in YB.ranks():
			var e = YB.cell(str(c.id), str(r.id))
			if not e.is_empty() and str(e.get("look", "")) != "": n += 1
	_chk("16 格齊", n == 16, n)
	var m = ["za", "za", "shi", "shi", "wei", "wei", "qin"]
	var good = true
	for s in 7: good = good and YB.rank_of_star(s) == m[s]
	_chk("★0–6 → 雜雜士士衛衛親", good)
	_chk("冇圖退返現版 soldier_stand", YB.spr_key("jin", "za", "stand") == "soldier_stand" or Spr.ok("yb_jin_za_stand"))
	_chk("phase 1 數值唔變", YB.mul("yuan", "qin", "hp") == 1.0 and YB.mul("jin", "za", "atk") == 1.0)
	var s = 0.0
	for k in YB.mix_default(): s += float(YB.mix_default()[k])
	_chk("預設編制加埋 1", absf(s - 1.0) < 0.001, s)
	_chk("名", YB.name_of("yi", "qin") != "", YB.name_of("yi", "qin"))
	print("RESULT yinbing ok=%d bad=%d" % [ok, bad])
