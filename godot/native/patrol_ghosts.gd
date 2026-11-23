# 原生改寫自 patrol_ghosts.js（資料 data/nat/patrol_ghosts.json；巡夜新名鬼：GHOSTS／SKILLS／ENEMY_T 登記、hantugalah 補脫口秀、LANG、圖片掛鈎）
extends RefCounted

const H_SUFFIX := "　黑色靈異脫口秀 KS08《不要抬頭》：佢其實好懶，成日望地下；越多人望佢就越高，「國家銀行每開一次會我就高一次，一連高咗三十五年」，同吉隆坡樓價一樣。"
const H_YUE := "佢其實好懶，成日望地下；越多人望佢就越高，「國家銀行每開一次會我就高一次，一連高咗三十五年」，同吉隆坡樓價一樣。"
const H_ZH := "他其實很懶，整天看地上；越多人看他就越高，「國家銀行每開一次會我就高一次，連續高了三十五年」，跟吉隆坡房價一樣。"

static var D := {}

static func hook() -> void:
	var SPR = J.G.get("SPR"); var SRC = J.G.get("PT_IMG_SRC"); var ART = J.G.get("ART")
	if SPR == null or SRC == null or ART == null or not J.t(J.gp(ART, "CHAR_H")): return
	for k in D.H:
		var src = J.gp(SRC, k)
		if not J.t(src): continue
		if not J.t(J.gp(SPR, k)):
			var im = J.new_("Image", [])
			J.sp(im, "onload", func(_t, _a): J.sp(im, "_ok", true); return null)
			J.sp(im, "src", src)
			J.sp(SPR, k, im)
		J.sp(J.gp(ART, "CHAR_H"), k, J.num(D.H[k]))

func run(_env) -> void:
	D = JSON.parse_string(FileAccess.get_file_as_string("res://data/nat/patrol_ghosts.json"))
	var GH = J.G.GHOSTS; var SK = J.G.SKILLS; var EN = J.G.ENEMY_T
	for k in D.keys:
		GH[k] = D.GHOSTS[k].duplicate(true); SK[k] = D.SKILLS[k].duplicate(true); EN[k] = D.ENEMY_T[k].duplicate(true)
	var ZH = D.ZH.duplicate()
	var hg = GH.get("n30_hantugalah")
	if J.t(hg):
		hg["say"] = "唔好抬頭。我話你知，你一望，我就高多截。"
		hg["lore"] = J.str(hg.lore) + H_SUFFIX
		ZH[hg.lore] = J.str(hg.lore).replace(H_YUE, H_ZH)
	var LANG = J.G.get("LANG")
	if LANG != null: J.mc(LANG, "add", [ZH])
	hook()
	J.G["PG_GHOSTS"] = {"keys": D.keys.duplicate(), "hook": func(_t, _a): hook(); return null}
	preload("res://game/newghost/ng_data.gd").install()   # [newghost] 新名鬼 26＋牛頭馬面＋大魔王＋新雜兵＋合體技（data/nat/newghost.json）
