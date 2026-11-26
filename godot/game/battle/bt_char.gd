# 主線戰鬥（原生）：一隻單位嘅畫法
#  - 平時（待機、行、受擊、嚇彈起、腳軟、倒下、蓄力）：巡陰嗰套 GPU 網格（PtChar＋pt_mesh shader），CPU 唔使逐點蒙皮
#  - 出招（windup／strike／follow／recover）而且有專屬招式（MOVES）、或者反派有自己原畫（RIG.custom）：Ctx 畫（BtMoves 原生，未移植嘅先叫 JS）
class_name BtChar
extends Node2D

const ATK := {"windup": 1, "strike": 1, "follow": 1, "recover": 1}
static var _moves = null
static var _rig = null

var u: Dictionary            # battle.js 嘅單位
var pu := {}                 # 畀 PtChar 用：{k, x, y, boss, side}
var pc: PtChar
var back: PtDraw             # 蓄力光暈（角色後面）
var mv: PtDraw               # 出招（Ctx 畫）＋蓄力光圈（角色前面）
var B: Dictionary
var st := {}                 # 今幀：x y0 y s o P cast
var use_ctx := false

func _init(unit: Dictionary, battle: Dictionary) -> void:
	u = unit; B = battle
	if _moves == null: _moves = J.G.get("MOVES"); _rig = J.gp(J.G.get("MeshAnim"), "RIG")
	pu = {"k": J.str(u.k), "x": 0.0, "y": 0.0, "boss": J.t(u.get("boss")), "side": int(J.num(u.side))}
	back = PtDraw.new(); back.fn = _draw_back; back.tag = "back"; var gm = CanvasItemMaterial.new(); gm.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD; back.material = gm; add_child(back)
	pc = PtChar.new(pu, self); add_child(pc)
	pc.over.visible = false; pc.glow.visible = false
	mv = PtDraw.new(); mv.fn = _draw_mv; mv.tag = "mv"; add_child(mv)

func _seed():   # [eastsoul] 每個單位固定一隻亡魂樣
	if not u.has("_soul"): u["_soul"] = randi() % 1000
	return u._soul
# PtChar 要嘅 run 介面
func fx_tex(_n): return null
func draw_over(_n, _u, _o) -> void: pass

func custom_draw(k: String, pose) -> bool:
	if k == "youhun": return true   # [eastsoul] 遊魂唔用白布鬼網格，改畫東方亡魂
	if pc != null and (pc.ace or pc.hero): return false   # [p44] 王牌階段圖／主角空手：整張圖（唔行手持兵器專屬招式畫法）
	if ATK.has(pose) and _moves is Dictionary and _moves.has(k): return true
	return _rig is Dictionary and _rig.get(k) is Dictionary and _rig[k].get("custom") != null

# 每幀：P = BtDraw.pose_of 結果
func sync(T: float) -> void:
	var hp = J.num(u.hp)
	if hp <= 0 and J.num(u.get("deadT", 0)) > 0.8:
		visible = false; return
	visible = true
	var P = BtDraw.pose_of(B, u); var s = BtDraw.scale_of(u)
	var x = J.num(u.x) + P.ox; var y0 = BtDraw.uy(B, u); var side1 = J.num(u.side) != 0
	var tg = u.anim.get("tg") if u.get("anim") is Dictionary else null
	if tg is Dictionary and J.num(tg.hp) <= 0: tg = null
	var o = {"tdx": J.num(tg.x) - J.num(u.x) if tg != null else (-40.0 if side1 else 40.0), "tdy": BtDraw.uy(B, tg) - y0 if tg != null else 0.0,
		"t": T + J.num(u.get("lane", 0)), "seed": _seed(), "walk": P.pose == "move", "pose": P.pose, "pt": P.pt, "flip": side1, "enemy": side1, "alpha": P.alpha, "rot": P.rot, "tamed": not side1, "untied": not side1}
	var cast = J.num(u.casting.t) / J.num(u.casting.dur) if u.get("casting") is Dictionary else -1.0
	st = {"x": x, "y0": y0, "y": y0 + P.oy, "s": s, "o": o, "P": P, "cast": cast, "T": T, "side1": side1, "flash": J.num(u.get("flash", 0))}
	var k = pu.k
	use_ctx = custom_draw(k, P.pose)
	pc.visible = not use_ctx
	if not use_ctx:
		pu.x = J.num(u.x); pu.y = y0
		var po = {"ox": P.ox, "oy": P.oy, "s": s, "t": o.t, "alpha": P.alpha, "flash": st.flash * 0.85, "pose": P.pose, "pt": P.pt, "flip": side1, "enemy": side1,
			"rot": P.rot, "walk": o.walk, "tdx": o.tdx, "tdy": o.tdy, "cloth": null, "badge": null, "wtex": null, "dying": hp <= 0, "aura": 0.0, "charge": -1.0,
			"lweapon": null, "swing_t": -1.0, "wsty": ""}
		pc.sync(po)
	back.queue_redraw(); mv.queue_redraw()

func _draw_back(n: CanvasItem) -> void:
	if st.is_empty() or st.cast < 0: return
	var ctx = Ctx.new(n)
	BtDraw.draw_charge(ctx, st.T, st.x, st.y0 - 28 * st.s, st.s, st.cast, Color("#ff9ac0") if st.side1 else Color("#9ff3ff"), false)

func _draw_mv(n: CanvasItem) -> void:
	if st.is_empty(): return
	var ctx = null
	if use_ctx:
		ctx = BtCtx.new(n)
		BtDraw.draw_char(ctx, pu.k, st.x, st.y, st.s, st.o)
		if st.flash > 0:
			ctx.save(); ctx.globalCompositeOperation = "lighter"
			var o2 = st.o.duplicate(); o2.alpha = st.P.alpha * st.flash * 0.85; o2.shadow = false
			BtDraw.draw_char(ctx, pu.k, st.x, st.y, st.s, o2); ctx.restore()
	if st.cast >= 0:
		if ctx == null: ctx = Ctx.new(n)
		BtDraw.draw_charge(ctx, st.T, st.x, st.y0 - 28 * st.s, st.s, st.cast, Color("#ff9ac0") if st.side1 else Color("#9ff3ff"), true)
