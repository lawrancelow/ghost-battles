# [sfx43] 補丁 43 音效接入測試
# 用法：bash /home/claude/setup/edtest.sh <godot目錄> sfx_43 res://tools/tests/sfx43_test.gd all 600
#   files ：49 個音檔全部載入到（AudioStreamOggVorbis、長度 0.1–2.6 秒）
#   map   ：skills2.json 每個副技模板、每個王牌技都有聲；ab 狀態事件對到聲；漂浮兵器四種打法有聲
#   play  ：Snd.play 播得到、同一個聲有最短間隔、技能聲之後 0.2 秒內唔出狀態聲
#   ui    ：一鍵穿戴／套裝、戰報排隊（掉魂魄）
#   game  ：1-1 地圖實戰：副技、兵器普攻、狀態中招真係有出聲；打完戰報出 MVP＋排隊嘅掉魂魄聲
extends "res://tools/tests/eqview2_test.gd"

const SX = preload("res://core/sfx43.gd")
const KEYS := ["sub_slash", "sub_break", "sub_exec", "sub_slam", "sub_stun", "sub_guard", "sub_drain", "sub_sap", "sub_poison", "sub_vanish", "sub_dash",
	"sub_shoot", "sub_chain", "sub_blast", "sub_burn", "sub_frost", "sub_hush", "sub_rally", "sub_rage", "sub_haste", "sub_heal", "sub_clean",
	"ace_strike", "ace_curse", "ace_bless",
	"st_stun", "st_silence", "st_burn", "st_poison", "st_mark", "st_flee", "st_confuse", "st_slow", "st_shell",
	"fuse", "star", "eq_plus", "eq_wear", "eq_set", "eq_ex", "boss_capture", "soul_drop", "mvp", "preset_load", "preset_save",
	"wp_thrust", "wp_swing", "wp_spin", "wp_throw"]

func _p(m): print("[sfx43] ", m)

func all(t) -> void:
	var m = await _boot(t)
	_files(); _map(); await _play(t); await _ui(t)
	await _game43(t, m)
	_p("RESULT ok=%d bad=%d" % [ok, bad])
func quick(t) -> void:
	await _boot(t)
	_files(); _map(); await _play(t); await _ui(t)
	_p("RESULT ok=%d bad=%d" % [ok, bad])

func _files() -> void:
	var miss = []; var badlen = []
	for k in KEYS:
		var st = Snd.f43_stream(k)
		if not (st is AudioStreamOggVorbis): miss.append(k); continue
		var L = st.get_length()
		if L < 0.1 or L > 2.6: badlen.append([k, L])
	_chk("49 個音檔全部載入到（ogg）", miss.is_empty() and KEYS.size() == 49, miss)
	_chk("長度全部 0.1–2.6 秒（短促）", badlen.is_empty(), badlen)
	_chk("冇呢個檔就照舊行合成聲（click 唔受影響）", Snd.f43_stream("click") == null)

func _map() -> void:
	var D = load("res://game/rts/abil.gd").sk2()
	var nos = []
	for k in D.get("SUB", {}):
		var tpl = str(D.SUB[k].get("tpl", ""))
		if not SX.SUB.has(tpl) or not (SX.SUB[tpl] in KEYS): nos.append([k, tpl])
	_chk("副技 %d 個（30 個模板）全部對到聲" % D.get("SUB", {}).size(), nos.is_empty(), nos)
	var noa = []
	for k in D.get("ACE", {}):
		var a = SX.ace_key(k)
		if not (a in KEYS) or not SX.ACE.has(k): noa.append([k, a])
	_chk("王牌技 %d 個全部對到重聲（ace_*）" % D.get("ACE", {}).size(), noa.is_empty() and D.get("ACE", {}).size() == 19, noa)
	var u = {"k": "afu", "p": Vector2.ZERO}
	var tgb = {"p": Vector2.ZERO, "ab": {"bf": [{"p": "dot", "kind": "burn"}]}}
	var tgp = {"p": Vector2.ZERO, "ab": {"bf": [{"p": "dot", "kind": "poison"}]}}
	var cases = [[["ab", u, "sub", null], "sub_slash"], [["ab", {"k": "heiwu"}, "ace", null], "ace_strike"], [["ab", {"k": "mengpo"}, "ace", null], "ace_bless"],
		[["ab", u, "stun", u], "st_stun"], [["ab", u, "silence", u], "st_silence"], [["ab", u, "mark", u], "st_mark"], [["ab", u, "flee", u], "st_flee"],
		[["ab", u, "confuse", u], "st_confuse"], [["ab", u, "slow", u], "st_slow"], [["ab", u, "shell_break", u], "st_shell"],
		[["ab", null, "dot", tgb], "st_burn"], [["ab", null, "dot", tgp], "st_poison"], [["ab", u, "heal", u], ""], [["ab", u, "trig_every", null], ""]]
	var wr = []
	for c in cases:
		var r = SX.ev_key(c[0])
		if r != c[1]: wr.append([c[0][2], r, c[1]])
	_chk("ab 事件 → 聲（副技／王牌／定身／封口／易傷／驚走／迷魂／減速／破殼／燒傷／中毒；其他唔出聲）", wr.is_empty(), wr)
	var EA = load("res://game/equip/eq_art.gd")
	var sty = {}
	for sh in EA.ATK: sty[EA.ATK[sh]] = true
	var nw = []
	for s in sty: if not (SX.wp_key(s) in KEYS): nw.append(s)
	_chk("漂浮兵器打法 %s 全部有聲" % [sty.keys()], nw.is_empty() and sty.size() >= 3, nw)

func _play(t) -> void:
	var was = Snd.on; Snd.on = true
	Snd._f43t.clear(); Snd.f43_log.clear(); Snd._f43_sk = -100000
	var fails = []
	for k in KEYS:
		var n0 = Snd.f43_log.size()
		Snd._f43_sk = -100000   # 逐個獨立試（唔計「技能聲後唔出狀態聲」）
		Snd.play(k)
		if Snd.f43_log.size() != n0 + 1: fails.append(k)
		await t.get_tree().process_frame
	_chk("49 個聲 Snd.play 都播到", fails.is_empty(), fails)
	var n1 = Snd.f43_log.size()
	Snd._f43t.clear(); Snd._f43_sk = -100000
	Snd.play("st_stun"); Snd.play("st_stun")
	_chk("同一個狀態聲 0.3 秒內只出一次", Snd.f43_log.size() == n1 + 1)
	await _w(t, 0.35)
	var n2 = Snd.f43_log.size()
	Snd.play("sub_slam"); Snd.play("st_slow")
	_chk("副技聲之後 0.2 秒內唔出狀態聲（唔會一嚿）", Snd.f43_log.size() == n2 + 1 and Snd.f43_log[-1] == "sub_slam")
	var busy = 0
	for q in Snd._f43p: if q.playing: busy += 1
	_chk("自己一組 8 個播放器（唔搶 UI 合成聲）", Snd._f43p.size() == 8, busy)
	Snd.on = was

func _ui(t) -> void:
	Snd.on = true
	Snd._f43t.clear(); Snd._f43_sk = -100000
	var EU = load("res://game/equip/eq_ui.gd")
	var n0 = Snd.f43_log.size()
	EU.wear_sfx("none", 99)
	_chk("一鍵穿戴／換裝：出 eq_wear", Snd.f43_log.size() == n0 + 1 and Snd.f43_log[-1] == "eq_wear")
	EU.wear_sfx("none", -1)   # 套裝級數升咗（-1 → 0 唔算；用 -1 模擬「升級」）
	await _w(t, 0.5)
	_chk("套裝湊齊：0.35 秒後再「叮」eq_set", Snd.f43_log.has("eq_set"), Snd.f43_log.slice(-3))
	SX.queue("soul_drop"); SX.queue("eq_ex")
	var q = SX.take()
	_chk("戰報排隊：掉魂魄／專屬物（take 之後清空）", q == ["soul_drop", "eq_ex"] and SX.take().is_empty(), q)

func _game43(t, m) -> void:
	var ids = await _team(t, ["afu", "n30_kappa", "nw_guihuo"])
	_chk("出陣名鬼 3 隻穿好裝備", ids.size() >= 3, ids)
	Snd.on = true; Snd.f43_log.clear(); Snd._f43t.clear()
	var op = await _start(t, m, 60.0)
	_chk("1-1 地圖戰鬥開到並交戰", op != null and op.phase == "fight", op.phase if op else null)
	if op == null: return
	for u in op.units:
		u["hp"] = J.num(u.hp) * 12; u["maxhp"] = J.num(u.maxhp) * 12
	var h = _hero(op)
	if not h.is_empty(): _cam(m, (h.p as Vector2) + Vector2(20, -30), 140.0)
	var seen = {}
	for i in 60:
		await _w(t, 0.5)
		h = _hero(op)
		if i % 4 == 0 and not h.is_empty(): _cam(m, (h.p as Vector2) + Vector2(20, -30), 140.0)
		for k in Snd.f43_log: seen[k] = int(seen.get(k, 0)) + 1
		Snd.f43_log.clear()
		if op.phase != "fight": break
	_p("戰鬥中出過嘅聲：%s" % [seen])
	var subs = 0; var wps = 0; var sts = 0
	for k in seen:
		if str(k).begins_with("sub_") or str(k).begins_with("ace_"): subs += seen[k]
		elif str(k).begins_with("wp_"): wps += seen[k]
		elif str(k).begins_with("st_"): sts += seen[k]
	_chk("實戰：副技發動有聲（%d 次）" % subs, subs >= 1)
	_chk("實戰：漂浮兵器普攻有聲（%d 次）" % wps, wps >= 3)
	_p("實戰：狀態中招聲 %d 次（視乎有冇控場技）" % sts)
	var ab = op.ab_log.get("ev", {}) if op.get("ab_log") is Dictionary else {}
	_p("ab 事件計數：sub=%s ace=%s stun=%s slow=%s" % [ab.get("sub"), ab.get("ace"), ab.get("stun"), ab.get("slow")])
	# 打完：戰報卡（MVP）＋排隊嘅掉魂魄
	SX.queue("soul_drop")
	Snd.f43_log.clear(); Snd._f43t.clear()
	B_end(op)
	var got = []
	for i in 40:
		await _w(t, 0.25)
		got.append_array(Snd.f43_log); Snd.f43_log.clear()
		if got.has("soul_drop"): break
	_chk("打贏戰報卡：MVP 聲＋之後排隊嘅掉魂魄聲", got.has("mvp") and got.has("soul_drop") and got.find("mvp") < got.find("soul_drop"), got)
