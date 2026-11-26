# [p44] 軍團空手圖（ace_art.NWP → assets/spr/nwp_<k>.webp）測試
# 用法：bash godot/tools/devkit/edtest.sh <godot目錄> lgnw res://tools/tests/lgnw_test.gd all 600
#   map ：NWP 名單有圖 → Spr.key_for／Spr.get_tex／PtGfx.tex 換空手圖；冇圖照用原圖；對話（dlg_begin）都係空手圖；
#         名單外嘅軍團（lg_jsj_guan 等）同五隻對話例外（黑白無常、牛頭馬面、孟婆）唔受影響
#   art ：已入庫嘅空手圖同原圖一樣尺寸、四角透明（同位置換圖，網格／頭像裁切照用）
#   fake：未有圖時，臨時將原圖登記做 nwp_ 鍵，驗證掛鈎路徑（唔寫檔）
extends "res://tools/tests/p44_test.gd"

func _q(m): print("[lgnw] ", m)

func all(t) -> void:
	await _boot(t)
	var have := []; var miss := []
	for k in ACE.NWP:
		if Spr.ok("nwp_" + k): have.append(k)
		else: miss.append(k)
	_q("有空手圖 %d／%d；未有：%s" % [have.size(), ACE.NWP.size(), str(miss)])
	# 有圖：換圖＋尺寸一樣＋透明底
	var badmap := []; var badsize := []; var badalpha := []
	for k in have:
		if Spr.key_for(k) != "nwp_" + k or Spr.get_tex(k) != Spr.get_tex("nwp_" + k) or PtGfx.tex(k) != Spr.get_tex("nwp_" + k): badmap.append(k)
		var a = Spr._man[k]; var o: Texture2D = load(a); var n: Texture2D = Spr.get_tex("nwp_" + k)
		if o == null or n == null or o.get_size() != n.get_size(): badsize.append(k)
		var im = _img("nwp_" + k)
		if im == null or not _alpha_ok(im)[0]: badalpha.append(k)
	_chk("有空手圖嘅軍團：Spr／PtGfx 取圖自動換", badmap.is_empty(), str(badmap))
	_chk("空手圖同原圖一樣尺寸", badsize.is_empty(), str(badsize))
	_chk("空手圖四角透明", badalpha.is_empty(), str(badalpha))
	# 冇圖：照用原圖
	var badmiss := []
	for k in miss:
		if Spr.key_for(k) != k: badmiss.append(k)
	_chk("未有空手圖嘅照用原圖", badmiss.is_empty(), str(badmiss))
	# 假圖：驗證掛鈎（臨時登記，完咗還原）
	var fk = "lg_dpl_bing"; var had = Spr._man.has("nwp_" + fk); var old = Spr._man.get("nwp_" + fk)
	Spr._man["nwp_" + fk] = Spr._man[fk]
	_chk("掛鈎：有 nwp_ 鍵就換", Spr.key_for(fk) == "nwp_" + fk)
	ACE.dlg_begin()
	_chk("對話入面軍團都用空手圖", Spr.key_for(fk) == "nwp_" + fk)
	_chk("對話入面五隻例外照用原圖", Spr.key_for("heiwu") == "heiwu" and Spr.key_for("mengpo") == "mengpo")
	ACE.dlg_end()
	if had: Spr._man["nwp_" + fk] = old
	else: Spr._man.erase("nwp_" + fk)
	_chk("名單外軍團唔受影響", Spr.key_for("lg_jsj_guan") == "lg_jsj_guan" and Spr.key_for("lg_sgj_bing") == "lg_sgj_bing" and Spr.key_for("lg_zzj_tank") == "lg_zzj_tank")
	_chk("名單 36 隻全部係現有軍團圖", ACE.NWP.keys().all(func(k): return Spr.ok(k)))
	_q("RESULT ok=%d bad=%d" % [ok, bad])
