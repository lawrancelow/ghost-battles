# [p47] 村子主角：空手姿勢（三款輪換、交叉淡入）＋漂浮兵器（老闆 11-26：全員空手、兵器漂浮、刃口朝目標）
#   以前村子主角用網格骨架圖（手揸斧頭）。而家：
#     做嘢（斬樹 chop、割禾 reap、做棺材板 hammer、搓包 knead）→ 做工動畫（work_anim）：工具浮喺面向嗰邊，
#       身體用空手姿勢圖做配合擺動；斬樹／割禾嘅節奏同主角動作進度（pt）逐格同步（撞擊一刻對正樹／禾）。
#     待機／行路／日常小動作 → 整張空手姿勢圖（呼吸、行路搖擺、日常動作按名做簡單身體擺動）＋ 身旁漂浮兵器
#       （有裝備手持兵器就飄裝備兵器；冇就男主斧頭／女主三角尺）。
#   冇 class_name（熱更新）；const HV = preload("res://game/soul/hero_vil.gd")；掛鈎：native/game.gd v_collect／分村 collect。
#   ON＝false 或冇空手圖 → 照舊畫網格骨架。
extends RefCounted

const ACE = preload("res://game/soul/ace_art.gd")
const WA = preload("res://game/outpost/work_anim.gd")
const EV2 = preload("res://game/equip/eq_view2.gd")
const EQD = preload("res://game/equip/eq_data.gd")
static var ON := true
const VERB := {"chop": "chop", "reap": "reap", "hammer": "saw", "knead": "knead"}
static var LAST := {}   # 測試：最後一次畫嘅 {"mode", "verb", "pose", "wea"}
static var story := 0    # [p56] 劇場／劇情畫面入面 >0：唔畫漂浮兵器（以前主角面向龐總，斧頭浮喺兩人中間，似龐總揸斧頭）

static func active() -> bool: return ON and ACE.active("afu")

static func hero_wea() -> String:
	var w = EQD.worn_of_k("afu") if EQD.on() else {}
	var id = str(w.get("wea", ""))
	if id != "" and str(EQD.item(id).get("look")) == "hand": return id
	return ACE.hero_weapon()

static func _native_r() -> bool:
	var MA = J.G.get("MeshAnim")
	var NR = J.gp(MA, "NATIVE_R") if MA != null else null
	return NR is Dictionary and NR.has("afu")

# o：{t, walk, flip, pose, pt, act（日常：hero_yawn…）, at}
static func draw(ctx, x: float, y: float, s: float, o) -> void:
	if not (ctx is Ctx): return
	var T = J.num(J.gp(o, "t")); var flip = J.t(J.gp(o, "flip"))
	var pose = J.gp(o, "pose"); var pt = J.num(J.gp(o, "pt"))
	var pk = ACE.pose_key()
	if pose != null and VERB.has(str(pose)):
		var v: String = VERB[str(pose)]; var Th = WA.chop_time(); var TT = T
		if v == "chop": TT = clampf(pt, 0.0, 0.999) * Th
		elif v == "reap": TT = clampf(pt, 0.0, 0.999) * Th * 1.4
		WA.draw(ctx, "afu", x, y, s, flip, TT, v, 0.0, {"body_key": pk, "solid": true, "body_face_left": not _native_r()})
		LAST = {"mode": "work", "verb": v, "pose": pk, "wea": ""}
		return
	var H = WA._h("afu") * s; var fd = -1.0 if flip else 1.0
	var act = str(J.gp(o, "act")) if J.t(J.gp(o, "act")) else ""
	var at = J.num(J.gp(o, "at"))
	var walk = J.t(J.gp(o, "walk"))
	# 身體擺動（以 H 為單位）
	var lean = 0.0; var dy = 0.0; var sx = 1.0; var sy = 1.0 + sin(T * 2.2) * 0.02
	if walk: lean = sin(T * 9.0) * 4.0; dy = -absf(sin(T * 9.0)) * 0.025
	match act:
		"hero_yawn", "hero_stretch": var k = sin(clampf(at / 3.6, 0, 1) * PI); sy += 0.06 * k; sx -= 0.03 * k; lean -= 6.0 * k
		"hero_scratch", "hero_tap": lean += sin(T * 6.0) * 3.0
		"hero_doze": lean += 9.0; sy -= 0.03 + sin(T * 1.2) * 0.015
		"hero_phone": lean += 6.0
		"hero_proud", "hero_wake": dy -= absf(sin(T * 7.0)) * 0.05
		"hero_sweat", "hero_dust": sx += sin(T * 14.0) * 0.015
	if str(pose) == "proud": dy -= absf(sin(T * 7.0)) * 0.05
	ctx.save()
	ctx.save(); ctx.globalAlpha *= 0.55; Art.shadow(ctx, x, y + 1 * s, s * 0.8); ctx.restore()
	ctx.translate(x, y + dy * H)
	ctx.translate(0, -0.3 * H); ctx.rotate(fd * deg_to_rad(lean)); ctx.translate(0, 0.3 * H)
	ctx.scale(sx, sy)
	if (not flip) != _native_r(): ctx.scale(-1, 1)   # 同巡陰／地圖戰鬥整張圖模式一樣嘅面向規矩
	var pf = ACE.pose_fade(); var fq = float(pf[1])
	var old_k = str(pf[0])
	if old_k != "" and fq < 1.0: _img(ctx, old_k, H, 1.0 - fq)
	_img(ctx, pk, H, fq if old_k != "" else 1.0)
	ctx.restore()
	var wea = hero_wea() if story <= 0 else ""
	if wea != "": EV2.draw(ctx, "float", pk, {"wea": wea}, Vector2(x, y), H, fd, {"T": T, "act": "idle", "ph": 0.0}, false, "front")
	LAST = {"mode": "idle", "verb": "", "pose": pk, "wea": wea}

static func _img(ctx: Ctx, key: String, H: float, a: float) -> void:
	var tex: Texture2D = Spr.get_tex(key)
	if tex == null: return
	var W = H * tex.get_width() / float(tex.get_height())
	ctx.save(); ctx.globalAlpha *= a
	ctx.drawImage(tex, -W / 2, -H, W, H)
	ctx.restore()
