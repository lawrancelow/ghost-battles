# 回陽間：平日動作（daily_town.js 嘅 DAILY.town_ken_*／town_boss_*／town_guard_*／town_auntie_*／office_*）逐行移植做原生
# 數值、時間、畫法同 JS 一樣；JS 版仍然喺度做後備（呢度冇嘅動作照交俾 JS）
class_name ScDaily
extends RefCounted

const D := PI / 180.0

class St:
	extends RefCounted
	var ctx: Ctx
	var a: Dictionary
	var o: Dictionary
	var t := 0.0
	var at := 0.0
	var dur := 0.0
	var env := 0.0
	var H := 0.0
	var W := 0.0
	var z: Dictionary
	var flip := false
	var fs := 1.0
	var walk := false
	func P(u: float, v: float) -> Vector2: return Vector2((u - 0.5) * W, (v - 1) * H)

# ---------- 小工具 ----------
static func cl(v: float, a := 0.0, b := 1.0) -> float: return a if v < a else (b if v > b else v)
static func ss(t: float) -> float: t = cl(t); return t * t * (3 - 2 * t)
static func seg(t: float, a: float, b: float) -> float: return cl((t - a) / (b - a))
static func bump(t: float, a: float, m: float, b: float) -> float:
	if t <= a or t >= b: return 0.0
	return ss((t - a) / (m - a)) if t < m else 1 - ss((t - m) / (b - m))
static func kf(K: Array, t: float) -> float:
	if t <= K[0][0]: return K[0][1]
	for i in range(1, K.size()):
		if t <= K[i][0]:
			var a: Array = K[i - 1]; var b: Array = K[i]; var q = (t - a[0]) / (b[0] - a[0])
			return a[1] + (b[1] - a[1]) * (0.5 - 0.5 * cos(PI * q))
	return K[K.size() - 1][1]
static func rnd(s: float) -> float: var x = sin(s * 127.1 + 311.7) * 43758.5453; return x - floor(x)
static func loopt(t: float, T: float) -> float: return fmod(fmod(t, T) + T, T)
static func _jm(v: float, m: float) -> float: return fmod(v, m)   # JS %（正數）

static func _num(o: Dictionary, k: String, d := 0.0) -> float:
	var v = o.get(k)
	if v == null: return d
	var n = J.num(v)
	return d if is_nan(n) else n

# ---------- 畫一個角色：開始（原點 = 腳底中央，原圖方向，不翻；最後依面向整個翻）----------
static func begin(ctx: Ctx, a: Dictionary, key: String, nr: bool, no_lift := false) -> St:
	if not Spr.ok(key): return null
	var tex := Spr.get_tex(key)
	if tex == null: return null
	var S := St.new()
	var o: Dictionary = a.o
	S.ctx = ctx; S.a = a; S.o = o
	S.t = _num(o, "t"); S.H = a.H; S.W = S.H * tex.get_width() / tex.get_height()
	S.at = _num(o, "at"); S.dur = _num(o, "adur")
	var env = ss(S.at / 0.35)
	if S.dur: env = minf(env, ss((S.dur - S.at) / 0.35))
	if o.get("aw") != null: env *= cl(_num(o, "aw"))
	S.env = env
	if not (o.get("shadow") is bool and o.shadow == false):
		var s: float = a.s
		Art.shadow(ctx, a.x, a.y + 1 * s, s * (1.0 if a.solid else 0.8))
	S.z = MeshAnim.idle(S.t)
	S.flip = a.faceRight != nr
	S.fs = 1.0 if nr else -1.0
	S.walk = J.t(o.get("walk"))
	ctx.save()
	var fy = 0.0 if a.solid else -(3 + sin(S.t * 2.4) * 2) * (a.s if a.s else S.H / 60.0)
	ctx.translate(a.x, a.y + fy)
	if S.flip: ctx.scale(-1, 1)
	ctx.translate(0, (0.0 if no_lift else float(S.z.y)) * S.H); ctx.scale(S.z.sx, S.z.sy)
	return S

static func end(S: St) -> void: S.ctx.restore()

# 網格身體嘅姿勢：沿用待機嘅頭、尾巴、頭髮晃動；手臂骨、身體骨歸零（拆出嚟嘅件先接得上）
static func mpose(S: St, add: Dictionary) -> Dictionary:
	var z: Dictionary = MeshAnim.walk(S.t) if S.walk else S.z.duplicate()
	z.armF = 0.0; z.armB = 0.0; z.axe = 0.0; z.body = 0.0; z.x = 0.0; z.y = 0.0; z.sx = 1.0; z.sy = 1.0; z.rot = 0.0
	if not S.walk: z.legF = 0.0; z.legB = 0.0
	for k in add: z[k] = float(z.get(k, 0.0)) + add[k]
	return z
static func body(S: St, rig: String, key: String, add: Dictionary) -> void: MeshAnim.draw_body(S.ctx, rig, key, S.H, mpose(S, add))
static func lean(S: St, ang: float, ly := 0.35, dx := 0.0, dy := 0.0) -> void:
	var c := S.ctx; c.translate(dx, dy); c.translate(0, -S.H * ly); c.rotate(ang); c.translate(0, S.H * ly)
# 整張原圖大小嘅切塊：支點 pv（原圖比例）放到 at，轉 ang，縮放 sc；fn(L) 喺切塊座標入面再畫（L(u,v) = 原圖比例 → 本地座標）
static func piece(S: St, key: String, pv: Vector2, at: Vector2, ang := 0.0, sc := 0.0, fn = null) -> void:
	if not Spr.ok(key): return
	var c := S.ctx; c.save(); c.translate(at.x, at.y); c.rotate(ang)
	if sc: c.scale(sc, sc)
	c.drawImage(Spr.get_tex(key), -pv.x * S.W, -pv.y * S.H, S.W, S.H)
	if fn != null: fn.call(func(u: float, v: float) -> Vector2: return Vector2((u - pv.x) * S.W, (v - pv.y) * S.H))
	c.restore()
# 道具（裁好嘅細圖）：闊 w，錨點 (ax,ay)，喺 (x,y) 轉 ang
static func prop(ctx: Ctx, key: String, x: float, y: float, w: float, ang := 0.0, ax := 0.5, ay := 0.5, sx := 1.0, sy := 1.0) -> void:
	if not Spr.ok(key): return
	var im := Spr.get_tex(key); var h = w * im.get_height() / im.get_width()
	ctx.save(); ctx.translate(x, y); ctx.rotate(ang); ctx.scale(sx if sx else 1.0, sy if sy else 1.0); ctx.drawImage(im, -ax * w, -ay * h, w, h); ctx.restore()
static func rotP(S: St, pu: float, pv: float, at: Vector2, ang: float, u: float, v: float) -> Vector2:
	var x = (u - pu) * S.W; var y = (v - pv) * S.H; var c = cos(ang); var s = sin(ang)
	return Vector2(at.x + x * c - y * s, at.y + x * s + y * c)

# ---------- 蠟筆小特效 ----------
static func crayon(ctx: Ctx, pts: Array, w: float, col, out = null) -> void:
	ctx.lineCap = "round"; ctx.lineJoin = "round"
	if out != null: ctx.strokeStyle = out; ctx.lineWidth = w * 2; _path(ctx, pts); ctx.stroke()
	ctx.strokeStyle = col; ctx.lineWidth = w; _path(ctx, pts); ctx.stroke()
static func _path(ctx: Ctx, pts: Array) -> void:
	ctx.beginPath()
	for i in pts.size():
		var p: Vector2 = pts[i]
		if i: ctx.lineTo(p.x, p.y)
		else: ctx.moveTo(p.x, p.y)

const FONT_FAM := "\"Noto Sans CJK TC\",\"Noto Sans TC\",\"PingFang TC\",\"Microsoft JhengHei\",sans-serif"
const C_TXT := Color("#fff3e8")
const C_OUT := Color("#2a1a22")
# 字：唔跟角色翻（翻咗就翻返轉）。字號只用幾個固定大細再縮放：Zzz 嗰啲字一路變大細，
# 每個新字號都要重新點陣化字形（第一次會卡十幾 ms），而且字型快取會一路漲
const FBASE := [12, 18, 24, 36, 48, 72]
static func _fbase(size: float) -> int:
	for b in FBASE:
		if b >= size: return b
	return 72
static func text(S: St, x: float, y: float, txt: String, size: float, alpha: float, rot := 0.0, col = C_TXT, out = C_OUT, fx := false) -> void:
	if alpha <= 0.01 or (J.t(S.o.get("quiet")) and not fx): return
	var c := S.ctx
	c.save(); c.translate(x, y)
	if S.flip: c.scale(-1, 1)
	c.rotate(rot); c.globalAlpha *= cl(alpha)
	var base := _fbase(size); c.scale(size / base, size / base)
	c.font = "900 %dpx %s" % [base, FONT_FAM]; c.textAlign = "center"; c.textBaseline = "middle"; c.lineJoin = "round"
	c.strokeStyle = out; c.lineWidth = base * 0.26; c.strokeText(txt, 0, 0)
	c.fillStyle = col; c.fillText(txt, 0, 0); c.restore()

const C_PUFF := Color(245 / 255.0, 245 / 255.0, 250 / 255.0, 0.85)
const C_PUFF_O := Color(60 / 255.0, 60 / 255.0, 80 / 255.0, 0.35)
static func puff(ctx: Ctx, x: float, y: float, r: float, k: float, seed: float) -> void:
	if k <= 0 or k >= 1: return
	ctx.save(); ctx.globalAlpha *= sin(k * PI) * 0.85
	for i in 3:
		var a = rnd(seed + i) * 6.28; var rr = r * (0.45 + 0.4 * rnd(seed + i * 3)) * (0.6 + k * 0.6)
		var px = x + cos(a) * r * 0.5 * k + i * r * 0.35 * k; var py = y + sin(a) * r * 0.3 - k * r * 0.4
		ctx.fillStyle = C_PUFF; ctx.strokeStyle = C_PUFF_O; ctx.lineWidth = maxf(1, r * 0.08)
		ctx.beginPath(); ctx.arc(px, py, rr, 0, PI * 2); ctx.fill(); ctx.stroke()
	ctx.restore()
const C_STEAM := Color(250 / 255.0, 246 / 255.0, 240 / 255.0, 0.9)
const C_STEAM_O := Color(60 / 255.0, 50 / 255.0, 60 / 255.0, 0.25)
static func steam_curl(ctx: Ctx, x: float, y: float, h: float, k: float, seed: float, a: float) -> void:
	if k <= 0 or k >= 1: return
	ctx.save(); ctx.globalAlpha *= sin(k * PI) * (a if a else 0.75)
	var pts: Array = []
	for i in 11:
		var u = i / 10.0; pts.append(Vector2(x + sin(u * 5 + seed + k * 5) * h * 0.12, y - u * h * (0.4 + k * 0.6) - k * h * 0.3))
	crayon(ctx, pts, maxf(1.4, h * 0.06), C_STEAM, C_STEAM_O); ctx.restore()
const C_DROP_O := Color(30 / 255.0, 60 / 255.0, 72 / 255.0, 0.9)
const C_DROP := Color(165 / 255.0, 215 / 255.0, 232 / 255.0, 0.95)
static func drop(ctx: Ctx, x: float, y: float, r: float, k: float, fall: float) -> void:
	if k <= 0 or k >= 1: return
	var py = y + fall * k * k; ctx.save(); ctx.globalAlpha *= 1 - k * 0.5
	ctx.fillStyle = C_DROP_O; ctx.beginPath(); ctx.ellipse(x, py, r * 1.2, r * 1.7, 0, 0, PI * 2); ctx.fill()
	ctx.fillStyle = C_DROP; ctx.beginPath(); ctx.ellipse(x, py, r * 0.85, r * 1.3, 0, 0, PI * 2); ctx.fill(); ctx.restore()
const C_SPK := Color("#fffbe8")
const C_SPK_O := Color(90 / 255.0, 70 / 255.0, 20 / 255.0, 0.6)
static func sparkle(ctx: Ctx, x: float, y: float, r: float, k: float) -> void:
	if k <= 0: return
	ctx.save(); ctx.translate(x, y); ctx.scale(k, k); ctx.globalAlpha *= minf(1, k * 1.5)
	ctx.beginPath()
	for i in 8:
		var an = i / 8.0 * PI * 2; var rr = r * 0.22 if i % 2 else r; ctx.lineTo(cos(an) * rr, sin(an) * rr)
	ctx.closePath(); ctx.fillStyle = C_SPK; ctx.strokeStyle = C_SPK_O; ctx.lineWidth = maxf(1, r * 0.12); ctx.stroke(); ctx.fill(); ctx.restore()
const C_Z := Color("#dfe8ff")
const C_Z_O := Color("#2a2a48")
static func zzz(S: St, x: float, y: float, size: float, t: float, a: float) -> void:
	for i in 3:
		var q = _jm(t * 0.45 + i / 3.0, 1.0)
		text(S, x + q * size * 1.2 + sin(q * 6 + i) * size * 0.2, y - q * size * 2.2, "Z" if i == 1 else "z", size * (0.6 + q * 0.6), a * sin(q * PI), 0.0, C_Z, C_Z_O, true)
const C_MARK := Color("#fff2c0")
const C_MARK_O := Color(40 / 255.0, 20 / 255.0, 20 / 255.0, 0.6)
static func marks(ctx: Ctx, x: float, y: float, r: float, k: float) -> void:
	if k <= 0: return
	ctx.save(); ctx.globalAlpha *= k
	for i in range(-1, 2):
		var an = -PI / 2 + i * 0.55
		crayon(ctx, [Vector2(x + cos(an) * r * 0.55, y + sin(an) * r * 0.55), Vector2(x + cos(an) * r, y + sin(an) * r)], maxf(1.5, r * 0.12), C_MARK, C_MARK_O)
	ctx.restore()
const C_ANG := Color("#e8333a")
const C_ANG_O := Color(60 / 255.0, 0, 0, 0.5)
static func anger(ctx: Ctx, x: float, y: float, r: float, k: float) -> void:
	if k <= 0: return
	ctx.save(); ctx.globalAlpha *= k; ctx.translate(x, y); ctx.scale(0.7 + 0.3 * k, 0.7 + 0.3 * k)
	for i in 4:
		ctx.save(); ctx.rotate(i * PI / 2 + PI / 4)
		crayon(ctx, [Vector2(r * 0.2, -r * 0.35), Vector2(r * 0.55, -r * 0.1), Vector2(r * 0.55, r * 0.3)], maxf(1.5, r * 0.2), C_ANG, C_ANG_O); ctx.restore()
	ctx.restore()

# ---------- 派發 ----------
const ACTS := {
	"town_ken_scroll": 1, "town_ken_yawn": 1, "town_ken_rub": 1, "town_ken_sigh": 1, "office_ken_nap": 1,
	"town_boss_polish": 1, "town_boss_watch": 1, "town_boss_call": 1, "town_boss_admire": 1,
	"office_boss_present": 1, "office_boss_read": 1, "office_boss_phone": 1, "office_boss_pack": 1,
	"town_guard_patrol": 1, "town_guard_sip": 1, "town_guard_doze": 1, "town_guard_dozeL": 1,
	"town_auntie_mop": 1, "town_auntie_wring": 1, "town_auntie_grumble": 1, "office_auntie_pack": 1,
	"office_it_notes": 1, "office_it_pack": 1,
}
static var off := OS.has_environment("GB_JSDAILY")   # GB_JSDAILY=1：用返 JS 版（對照用）
static func has(act: String) -> bool: return not off and ACTS.has(act)

# a = {type,x,y,s,H,o,faceRight,solid}；回傳 false = 畫唔到（照一般畫法）
static func draw(ctx: Ctx, act: String, a: Dictionary) -> bool:
	match act:
		"town_ken_scroll": return _ken_scroll(ctx, a)
		"town_ken_yawn": return _ken_yawn(ctx, a)
		"town_ken_rub": return _ken_rub(ctx, a)
		"town_ken_sigh": return _ken_sigh(ctx, a)
		"office_ken_nap": return _ken_nap(ctx, a)
		"town_boss_polish": return _boss_polish(ctx, a)
		"town_boss_watch": return _boss_watch(ctx, a)
		"town_boss_call": return _boss_call(ctx, a)
		"town_boss_admire": return _boss_admire(ctx, a)
		"office_boss_present": return _boss_present(ctx, a)
		"office_boss_read": return _boss_read(ctx, a)
		"office_boss_phone": return _boss_phone(ctx, a)
		"office_boss_pack": return _boss_pack(ctx, a)
		"town_guard_patrol": return _guard_patrol(ctx, a)
		"town_guard_sip": return _guard_sip_act(ctx, a)
		"town_guard_doze": return _guard_doze(ctx, a)
		"town_guard_dozeL": return _guard_dozeL(ctx, a)
		"town_auntie_mop": return _auntie_mop(ctx, a)
		"town_auntie_wring": return _auntie_wring(ctx, a)
		"town_auntie_grumble": return _auntie_grumble(ctx, a)
		"office_auntie_pack": return _auntie_pack(ctx, a)
		"office_it_notes": return _it_notes(ctx, a)
		"office_it_pack": return _it_pack(ctx, a)
	return false

# ======================================================================
# 阿Ken：右手前臂（npc_ken__fore）繞手肘轉；手機喺另一隻手（身上）
# ======================================================================
const KEN_ELB := Vector2(0.69, 0.565)
static func ken_draw(S: St, lean_a := 0.0, head := 0.0, ang := 0.0, lift := 0.0, fx := 0.0, sc := 1.0) -> void:
	var c := S.ctx
	c.save(); lean(S, lean_a, 0.35)
	body(S, "npc_ken", "npc_ken__bodyF", {"head": head, "legF": 0.0, "legB": 0.0})
	var e := S.P(KEN_ELB.x, KEN_ELB.y)
	piece(S, "npc_ken__fore", KEN_ELB, Vector2(e.x + fx * S.H, e.y - lift * S.H), ang, sc if sc else 1.0)
	c.restore()

const C_WHITE9 := Color(1, 1, 1, 0.9)
static func _ken_scroll(ctx: Ctx, a: Dictionary) -> bool:
	var S := begin(ctx, a, "npc_ken__bodyF", false)
	if S == null: return false
	var k = S.env; var q = _jm(S.at, 1.1) / 1.1; var fl = bump(q, 0.55, 0.66, 0.85)
	ken_draw(S, k * S.fs * 0.02, k * S.fs * (0.05 + 0.02 * fl), k * (0.035 * fl + 0.01 * sin(S.at * 1.7)))
	if fl > 0.2:
		var h := S.P(0.30, 0.445); ctx.save(); ctx.globalAlpha *= k * fl * 0.7
		crayon(ctx, [Vector2(h.x - S.W * 0.05, h.y + S.H * 0.012), Vector2(h.x, h.y - S.H * 0.004), Vector2(h.x + S.W * 0.04, h.y - S.H * 0.02)], maxf(1, S.H * 0.008), C_WHITE9); ctx.restore()
	end(S); return true

const K_YAWN_UP := [[0, 0], [0.7, 1], [2.2, 1], [2.8, 0]]
const K_YAWN_BACK := [[0, 0], [0.5, 0.3], [0.9, 1], [2.0, 1], [2.6, 0], [2.9, -0.25], [3.2, 0]]
const K_YAWN_SY := [[0, 0], [0.6, 1], [1.9, 1.15], [2.6, 0], [2.9, -0.3], [3.3, 0]]
const C_TEAR := Color(170 / 255.0, 220 / 255.0, 1, 0.95)
const C_TEAR_O := Color(40 / 255.0, 70 / 255.0, 110 / 255.0, 0.6)
static func _ken_yawn(ctx: Ctx, a: Dictionary) -> bool:
	var S := begin(ctx, a, "npc_ken__bodyF", false)
	if S == null: return false
	var t = S.at; var k = S.env
	var up = kf(K_YAWN_UP, t); var back = kf(K_YAWN_BACK, t)
	var sy = 1 + 0.045 * kf(K_YAWN_SY, t) * k
	ctx.save(); ctx.scale(1 / sqrt(sy), sy)
	ken_draw(S, -S.fs * k * back * 0.03, -S.fs * k * back * 0.16 + S.fs * k * 0.05 * sin(maxf(0, t - 2.6) * 18) * seg(t, 2.6, 2.75) * (1 - seg(t, 2.95, 3.2)),
		k * up * 0.62, k * up * 0.035, k * up * 0.02, 1 + 0.05 * up * k)
	ctx.restore()
	var f := S.P(0.40, 0.33); var hk = bump(t, 0.6, 1.0, 2.3) * k
	text(S, f.x - S.fs * S.H * 0.32, f.y - S.H * 0.25 - hk * S.H * 0.04, "哈～", S.H * 0.11, hk, -0.1)
	var tk = bump(t, 1.2, 1.6, 2.8) * k
	if tk > 0:
		var e := S.P(0.25, 0.33); ctx.save(); ctx.globalAlpha *= tk; ctx.fillStyle = C_TEAR; ctx.strokeStyle = C_TEAR_O; ctx.lineWidth = 1
		ctx.beginPath(); ctx.ellipse(e.x, e.y + tk * S.H * 0.01, S.H * 0.008, S.H * 0.012, 0, 0, PI * 2); ctx.fill(); ctx.stroke(); ctx.restore()
	end(S); return true

const K_RUB_UP := [[0, 0], [0.6, 1], [2.2, 1], [2.8, 0]]
static func _ken_rub(ctx: Ctx, a: Dictionary) -> bool:
	var S := begin(ctx, a, "npc_ken__bodyF", false)
	if S == null: return false
	var t = S.at; var k = S.env; var up = kf(K_RUB_UP, t); var rb = seg(t, 0.6, 2.2) * (1 - seg(t, 2.1, 2.3))
	var wig = sin(t * 15) * rb
	ken_draw(S, S.fs * k * up * 0.025, S.fs * k * up * 0.09, k * (up * 0.8 + wig * 0.035), k * (up * 0.10 + cos(t * 15) * rb * 0.006), k * up * 0.03, 1 + 0.06 * up * k)
	end(S); return true

const K_SIGH := [[0, 0], [0.7, 1], [1.0, 1], [1.5, -0.6], [2.6, -0.5], [3.0, 0]]
const C_SIGH := Color("#cfd8ff")
const C_SIGH_O := Color("#1e2238")
static func _ken_sigh(ctx: Ctx, a: Dictionary) -> bool:
	var S := begin(ctx, a, "npc_ken__bodyF", false)
	if S == null: return false
	var t = S.at; var k = S.env; var inh = kf(K_SIGH, t)
	ctx.save(); ctx.scale(1, 1 + 0.03 * inh * k)
	ken_draw(S, S.fs * k * 0.03 * maxf(0, -inh), S.fs * k * (-0.05 * maxf(0, inh) + 0.14 * maxf(0, -inh)), k * (0.05 * inh))
	ctx.restore()
	var f := S.P(0.40, 0.33)
	puff(ctx, f.x + S.fs * S.H * 0.04, f.y + S.H * 0.06, S.H * 0.05, seg(t, 1.0, 2.2), 3.1)
	text(S, f.x - S.fs * S.H * 0.30, f.y - S.H * 0.22, "唉……", S.H * 0.1, bump(t, 1.0, 1.4, 2.6) * k, 0.0, C_SIGH, C_SIGH_O)
	end(S); return true

# 阿Ken 喺茶水間圓枱瞓著（循環）
static func _ken_nap(ctx: Ctx, a: Dictionary) -> bool:
	var S := begin(ctx, a, "npc_ken__bodyF", false, true)
	if S == null: return false
	var t = S.at; var k = S.env; var br = sin(t * 1.25)
	ctx.save(); ctx.scale(1, 1 + 0.012 * br * k)
	ken_draw(S, S.fs * k * (0.42 + 0.012 * br), S.fs * k * (0.75 + 0.02 * br), -k * 0.55)
	ctx.restore()
	var h := S.P(0.45, 0.40); zzz(S, h.x + S.fs * S.W * 0.55, h.y - S.H * 0.05, S.H * 0.1, t * 0.7, k)
	end(S); return true

# ======================================================================
# 陳總：水晶球手（npc_boss__arm，繞手肘）＋手套手（npc_boss__point，繞膊頭），身體 npc_boss__bodyN
# ======================================================================
const B_EL := Vector2(0.23, 0.56)
const B_BALL := Vector2(0.12, 0.27)
const B_SH := Vector2(0.775, 0.475)
const B_HAND := Vector2(0.835, 0.75)
const B_MOUTH := Vector2(0.39, 0.315)
# P：lean dx head legF legB glove shUp ball elUp gloveBack；gfn／bfn 喺手套手／水晶球手座標入面再畫
static func boss_draw(S: St, P: Dictionary, gfn = null, bfn = null) -> void:
	var c := S.ctx; c.save(); lean(S, P.get("lean", 0.0), 0.35, P.get("dx", 0.0), 0)
	body(S, "npc_boss", "npc_boss__bodyN", {"head": P.get("head", 0.0), "legF": P.get("legF", 0.0), "legB": 0.0})
	var sh := S.P(B_SH.x, B_SH.y); var el := S.P(B_EL.x, B_EL.y)
	piece(S, "npc_boss__arm", B_EL, Vector2(el.x, el.y - P.get("elUp", 0.0) * S.H), P.get("ball", 0.0), 1, bfn)
	piece(S, "npc_boss__point", B_SH, Vector2(sh.x, sh.y - P.get("shUp", 0.0) * S.H), P.get("glove", 0.0), 1, gfn)
	c.restore()

const K_POL_NEAR := [[0, 0], [0.6, 1], [3.1, 1], [3.6, 0]]
const C_FOG := Color(235 / 255.0, 240 / 255.0, 250 / 255.0, 0.9)
static func _boss_polish(ctx: Ctx, a: Dictionary) -> bool:
	var S := begin(ctx, a, "npc_boss__bodyN", false)
	if S == null: return false
	var t = S.at; var k = S.env; var near = kf(K_POL_NEAR, t); var rub = seg(t, 1.3, 2.7) * (1 - seg(t, 2.6, 2.8))
	var bfn = func(L: Callable) -> void:
		var p: Vector2 = L.call(B_BALL.x, B_BALL.y); var fog = bump(t, 0.9, 1.25, 2.4) * k
		if fog > 0: ctx.save(); ctx.globalAlpha *= fog * 0.55; ctx.fillStyle = C_FOG; ctx.beginPath(); ctx.arc(p.x, p.y, S.W * 0.1, 0, PI * 2); ctx.fill(); ctx.restore()
		if rub > 0:
			ctx.save(); ctx.globalAlpha *= rub * k * 0.8; var r = S.W * 0.07; var an = t * 13
			crayon(ctx, [Vector2(p.x + cos(an) * r, p.y + sin(an) * r * 0.7), Vector2(p.x + cos(an + 0.9) * r, p.y + sin(an + 0.9) * r * 0.7)], maxf(1, S.H * 0.008), C_WHITE9); ctx.restore()
		sparkle(ctx, p.x + S.W * 0.04, p.y - S.W * 0.05, S.H * 0.05, bump(t, 2.75, 2.9, 3.4) * k)
	boss_draw(S, {"ball": k * (near * 0.13 + sin(t * 13) * 0.03 * rub), "elUp": k * near * 0.015, "head": S.fs * k * (near * 0.1 - 0.06 * bump(t, 2.9, 3.1, 3.4)), "lean": S.fs * k * near * 0.025}, null, bfn)
	var m := S.P(B_MOUTH.x, B_MOUTH.y)
	puff(ctx, lerpf(m.x, m.x + S.fs * S.W * 0.12, seg(t, 0.75, 1.2)), m.y, S.H * 0.035, seg(t, 0.7, 1.3), 7.7)
	text(S, m.x - S.fs * S.W * 0.30, m.y - S.H * 0.17, "哈——", S.H * 0.085, bump(t, 0.7, 0.85, 1.3) * k)
	end(S); return true

const K_WATCH := [[0, 0], [0.5, 1], [2.2, 1], [2.7, 0]]
static func _boss_watch(ctx: Ctx, a: Dictionary) -> bool:
	var S := begin(ctx, a, "npc_boss__bodyN", false)
	if S == null: return false
	var t = S.at; var k = S.env; var up = kf(K_WATCH, t); var flick = sin(maxf(0, t - 0.5) * 30) * bump(t, 0.5, 0.55, 0.75)
	var tap = maxf(0, sin(t * 9)) * seg(t, 1.2, 1.4) * (1 - seg(t, 2.3, 2.5))
	boss_draw(S, {"glove": k * (up * 1.45 + flick * 0.05), "shUp": k * up * 0.01, "head": S.fs * k * up * 0.16, "lean": S.fs * k * up * 0.02, "legF": k * tap * 0.12 * -S.fs})
	var m := S.P(0.5, 0.0); text(S, m.x - S.fs * S.W * 0.42, m.y + S.H * 0.04, "嘖", S.H * 0.11, bump(t, 1.4, 1.6, 2.3) * k)
	end(S); return true

const K_CALL := [[0, 0], [0.5, 1], [3.4, 1], [3.9, 0]]
const CALL_WORDS := ["喂？！", "我不管！", "明天交！"]
const C_YELL := Color("#ffe0d8")
static func _boss_call(ctx: Ctx, a: Dictionary) -> bool:
	var S := begin(ctx, a, "npc_boss__bodyN", false)
	if S == null: return false
	var t = S.at; var k = S.env; var up = kf(K_CALL, t); var yell = seg(t, 0.8, 1.0) * (1 - seg(t, 3.2, 3.5))
	var jab = maxf(0, sin(t * 7.5)) * yell; var sh = sin(t * 40) * 0.008 * yell
	var gfn = func(L: Callable) -> void:
		var p: Vector2 = L.call(B_HAND.x, B_HAND.y)
		prop(ctx, "afu__phone", p.x + S.fs * S.W * 0.02, p.y - S.H * 0.04, S.H * 0.14 * up * k + 0.0001, -S.fs * 0.3 - (up * 1.75) * k, 0.5, 0.6, -S.fs, 1)
	boss_draw(S, {"glove": k * (up * 1.75 + jab * 0.06), "shUp": k * up * 0.03, "head": S.fs * k * (up * 0.06 + jab * 0.08) + sh, "lean": S.fs * k * (jab * 0.04), "dx": S.fs * k * jab * S.H * 0.01}, gfn)
	var m := S.P(B_MOUTH.x, B_MOUTH.y)
	var wi = mini(2, int(floor(maxf(0, t - 0.9) / 0.85)))
	text(S, m.x + S.fs * S.W * 0.55, m.y - S.H * 0.30 - jab * S.H * 0.02, CALL_WORDS[wi], S.H * 0.1, yell * k, -0.08, C_YELL)
	var ap := S.P(0.66, 0.08); anger(ctx, ap.x, ap.y, S.H * 0.07, yell * k * (0.8 + 0.2 * sin(t * 12)))
	end(S); return true

static func _boss_admire(ctx: Ctx, a: Dictionary) -> bool:
	var S := begin(ctx, a, "npc_boss__bodyN", false)
	if S == null: return false
	var t = S.at; var k = S.env
	boss_draw(S, {"ball": k * sin(t * 1.6) * 0.06, "head": S.fs * k * (0.05 + sin(t * 1.6 + 0.4) * 0.025)})
	end(S); return true

const K_PRESENT := [[0, 0.55], [0.6, 1], [3.6, 1], [4.3, 0.55], [5.2, 0.55]]
static func _boss_present(ctx: Ctx, a: Dictionary) -> bool:
	var S := begin(ctx, a, "npc_boss__bodyN", false)
	if S == null: return false
	var t = S.at; var k = S.env; var q = loopt(t, 5.2); var up = kf(K_PRESENT, q)
	var jab = maxf(0, sin(t * 6.5)) * bump(q, 0.8, 1.2, 3.2); var look = sin(t * 0.9)
	boss_draw(S, {"glove": -k * (up * 2.3 + jab * 0.10), "shUp": k * up * 0.012, "head": S.fs * k * (-0.05 * up + 0.04 * look), "lean": -S.fs * k * jab * 0.012, "ball": k * 0.04 * sin(t * 1.3)})
	end(S); return true

static func _boss_read(ctx: Ctx, a: Dictionary) -> bool:
	var S := begin(ctx, a, "npc_boss__bodyN", false)
	if S == null: return false
	var t = S.at; var k = S.env; var q = loopt(t, 4.6); var fl = bump(q, 3.6, 3.85, 4.2); var scan = _jm(q / 3.6, 1.0)
	var gfn = func(L: Callable) -> void:
		var p: Vector2 = L.call(B_HAND.x, B_HAND.y)
		prop(ctx, "op_paper_fly", p.x + S.fs * S.W * 0.03, p.y - S.H * 0.05, S.H * 0.22 * k + 0.0001, -S.fs * 0.15 - 1.25 * k, 0.5, 0.6, (1 - fl * 1.6) * (1.0 if S.fs > 0 else -1.0), 1)
	boss_draw(S, {"glove": k * (1.25 + 0.04 * sin(t * 1.1) - fl * 0.12), "shUp": k * 0.012, "head": S.fs * k * (0.13 + scan * 0.05), "lean": S.fs * k * 0.02}, gfn)
	end(S); return true

static func _boss_phone(ctx: Ctx, a: Dictionary) -> bool:
	var S := begin(ctx, a, "npc_boss__bodyN", false)
	if S == null: return false
	var t = S.at; var k = S.env; var q = loopt(t, 7); var rant = bump(q, 4.6, 5.0, 6.2); var nod = maxf(0, sin(t * 2.2)) * (1 - rant)
	var gfn = func(L: Callable) -> void:
		var p: Vector2 = L.call(B_HAND.x, B_HAND.y)
		prop(ctx, "afu__phone", p.x + S.fs * S.W * 0.01, p.y - S.H * 0.035, S.H * 0.12 * k + 0.0001, -S.fs * 0.5 - 2.55 * k, 0.5, 0.6, -S.fs, 1)
	boss_draw(S, {"glove": k * (2.55 - rant * 0.25 + sin(t * 9) * 0.03 * rant), "shUp": k * 0.04, "head": S.fs * k * (-0.10 + nod * 0.05 - rant * 0.04), "lean": -S.fs * k * rant * 0.02, "ball": k * (rant * 0.12 * sin(t * 6))}, gfn)
	end(S); return true

const K_PACK_WATCH := [[0, 0], [2.1, 0], [2.5, 1], [3.5, 1]]
static func _boss_pack(ctx: Ctx, a: Dictionary) -> bool:
	var S := begin(ctx, a, "npc_boss__bodyN", false)
	if S == null: return false
	var t = S.at; var k = S.env; var sweep = sin(t * 4.5) * bump(t, 0.3, 0.6, 2.0); var watch = kf(K_PACK_WATCH, t)
	boss_draw(S, {"glove": k * (lerpf(-0.45 + sweep * 0.25, 1.45, watch)), "shUp": k * watch * 0.01, "ball": k * 0.22, "elUp": k * 0.01, "head": S.fs * k * (0.12 + watch * 0.05), "lean": S.fs * k * 0.05 * (1 - watch)})
	end(S); return true

# ======================================================================
# 保安阿伯：手電筒手（npc_guard__arm，繞膊頭）＋保溫瓶：袖（npc_guard__sleeve）＋手同瓶（npc_guard__tea，繞手腕）
# ======================================================================
const G_FL := Vector2(0.33, 0.53)
const G_SH := Vector2(0.882, 0.4565)
const G_WR := Vector2(0.885, 0.578)
const G_CAP := Vector2(0.745, 0.465)
const G_MOUTH := Vector2(0.5, 0.335)
static func guard_draw(S: St, head: float, lean_a := 0.0, dy := 0.0, fl_a := 0.0, arm := 0.0, wrist := 0.0, tfn = null) -> void:
	var c := S.ctx; c.save(); lean(S, lean_a, 0.4, 0, dy)
	body(S, "npc_guard", "npc_guard__bodyN", {"head": head})
	var sh := S.P(G_SH.x, G_SH.y); var fl := S.P(G_FL.x, G_FL.y)
	var wr := rotP(S, G_SH.x, G_SH.y, sh, arm, G_WR.x, G_WR.y)
	piece(S, "npc_guard__tea", G_WR, wr, arm + wrist, 1, tfn)
	piece(S, "npc_guard__sleeve", G_SH, sh, arm)
	piece(S, "npc_guard__arm", G_FL, fl, fl_a, 1)
	c.restore()

static func _guard_patrol(ctx: Ctx, a: Dictionary) -> bool:
	var S := begin(ctx, a, "npc_guard__bodyN", false)
	if S == null: return false
	var t = S.at; var k = S.env; var sw = sin(t * 1.9) * 0.16 + sin(t * 0.7) * 0.05
	guard_draw(S, S.fs * k * (-sw * 0.35 + 0.02), 0, 0, k * (sw + 0.04), k * sin(S.t * 7) * 0.05 * (1.0 if S.walk else 0.0))
	end(S); return true

# 飲茶 IK：瓶口對準嘴（只同身形同面向有關，計一次記住；JS 版每幀掃 2500 次）
static var _ik := {}
static func _sip_ik(S: St) -> Array:
	var key = "%d|%.3f|%.3f" % [int(S.fs), S.W, S.H]
	if _ik.has(key): return _ik[key]
	var sh := S.P(G_SH.x, G_SH.y); var m := S.P(G_MOUTH.x, G_MOUTH.y); var tgt = Vector2(m.x + S.fs * S.W * 0.02, m.y + S.H * 0.03)
	var best = [0.0, 0.0]; var be = 1e9
	var a1 = 0.0
	while a1 <= 2.2:
		var a2 = -2.4
		while a2 <= 0.4:
			var w := rotP(S, G_SH.x, G_SH.y, sh, a1, G_WR.x, G_WR.y); var c := rotP(S, G_WR.x, G_WR.y, w, a1 + a2, G_CAP.x, G_CAP.y)
			var e = (c - tgt).length() + absf(a1 + a2 - S.fs * 0.55) * S.H * 0.03
			if e < be: be = e; best = [a1, a2]
			a2 += 0.05
		a1 += 0.05
	if _ik.size() > 64: _ik.clear()
	_ik[key] = best
	return best

const K_SIP := [[0, 0], [0.7, 1], [2.3, 1], [2.9, 0]]
static func _guard_sip(S: St) -> void:
	var t = S.at; var k = S.env; var up = kf(K_SIP, minf(t, 3.3) if S.dur else t); var drink = bump(t, 0.9, 1.2, 2.2)
	var best := _sip_ik(S)
	var A = k * up
	var ctx := S.ctx
	var tfn = func(L: Callable) -> void:
		var p: Vector2 = L.call(G_CAP.x, G_CAP.y); steam_curl(ctx, p.x, p.y - S.H * 0.02, S.H * 0.18, _jm(t * 0.9, 1.0), 2.1, 0.6 * k)
	guard_draw(S, -S.fs * k * (up * 0.06 + drink * 0.1), -S.fs * k * drink * 0.03, 0, k * up * 0.05, best[0] * A, (best[1] - drink * 0.25) * A, tfn)
	var f := S.P(0.45, 0.30)
	puff(ctx, f.x - S.fs * S.W * 0.05, f.y + S.H * 0.04, S.H * 0.04, seg(t, 2.3, 3.2), 5.5)
	text(S, f.x - S.fs * S.W * 0.35, f.y - S.H * 0.18, "哈～", S.H * 0.095, bump(t, 2.3, 2.5, 3.1) * k)
static func _guard_sip_act(ctx: Ctx, a: Dictionary) -> bool:
	var S := begin(ctx, a, "npc_guard__bodyN", false)
	if S == null: return false
	_guard_sip(S); end(S); return true

const K_DOZE := [[0, 0], [1.2, 0.6], [1.5, 0.5], [2.6, 1], [3.2, 1], [3.35, -0.25], [3.7, 0.05], [4.2, 0]]
static func _guard_doze(ctx: Ctx, a: Dictionary) -> bool:
	var S := begin(ctx, a, "npc_guard__bodyN", false)
	if S == null: return false
	var t = S.at; var k = S.env; var nod = kf(K_DOZE, t); var jerk = bump(t, 3.2, 3.35, 3.7)
	ctx.save(); ctx.scale(1, 1 - 0.03 * maxf(0, nod) * k)
	guard_draw(S, S.fs * k * nod * 0.5, S.fs * k * nod * 0.06, k * (maxf(0, nod) * S.H * 0.015 - jerk * S.H * 0.03), -k * maxf(0, nod) * 0.45, -k * maxf(0, nod) * 0.06)
	ctx.restore()
	var h := S.P(0.3, 0.12); zzz(S, h.x - S.fs * S.W * 0.15, h.y, S.H * 0.09, t, seg(t, 1.0, 1.5) * (1 - seg(t, 3.1, 3.25)) * k)
	var mp := S.P(0.5, 0.05); marks(ctx, mp.x, mp.y - S.H * 0.03, S.H * 0.09, jerk * k)
	end(S); return true

const K_DOZEL := [[0, 0.25], [1.6, 0.85], [5.9, 1], [6.15, 1.12], [6.3, -0.2], [6.8, 0.1], [8, 0.25]]
static func _guard_dozeL(ctx: Ctx, a: Dictionary) -> bool:
	var S := begin(ctx, a, "npc_guard__bodyN", false)
	if S == null: return false
	var t = S.at; var k = S.env; var q = loopt(t, 8); var br = sin(t * 1.5)
	var nod = kf(K_DOZEL, q) + br * 0.04; var jerk = bump(q, 6.15, 6.3, 6.8)
	ctx.save(); ctx.scale(1, 1 - 0.025 * maxf(0, nod) * k + 0.006 * br * k)
	guard_draw(S, S.fs * k * nod * 0.45, S.fs * k * nod * 0.05, k * (maxf(0, nod) * S.H * 0.012 - jerk * S.H * 0.02), -k * maxf(0, nod) * 0.32)
	ctx.restore()
	var h := S.P(0.3, 0.12); zzz(S, h.x - S.fs * S.W * 0.15, h.y, S.H * 0.09, t, (1 - bump(q, 6.0, 6.3, 7.2)) * k)
	var mp := S.P(0.5, 0.05); marks(ctx, mp.x, mp.y - S.H * 0.03, S.H * 0.09, jerk * k)
	end(S); return true

# ======================================================================
# 清潔安娣：拖把（npc_auntie__mop）＋揸拖把嘅手（npc_auntie__hand，繞手腕）＋叉腰嘅手（npc_auntie__hip）
# ======================================================================
const AU_FIST := Vector2(0.275, 0.512)
const AU_TOP := Vector2(0.235, 0.34)
const AU_BOT := Vector2(0.37, 0.95)
const AU_HEAD := Vector2(0.10, 0.40)
const AU_SH := Vector2(0.765, 0.43)
const AU_HAND := Vector2(0.735, 0.595)
const AU_WR := Vector2(0.386, 0.526)
static func au_axis(S: St) -> Array:
	var ax = (AU_BOT.x - AU_TOP.x) * S.W; var ay = (AU_BOT.y - AU_TOP.y) * S.H; var L = Vector2(ax, ay).length()
	return [ax / L, ay / L, L]
static func au_head(S: St, fx: float, fy: float, th: float, s: float) -> Vector2:
	var A := au_axis(S); var hx = (AU_HEAD.x - AU_FIST.x) * S.W - A[0] * s * A[2]; var hy = (AU_HEAD.y - AU_FIST.y) * S.H - A[1] * s * A[2]
	var c = cos(th); var sn = sin(th); return Vector2(fx + hx * c - hy * sn, fy + hx * sn + hy * c)
static func au_reach(S: St, fx: float, fy: float, th: float, floor_y: float) -> float:
	var h0 := au_head(S, fx, fy, th, 0); var h1 := au_head(S, fx, fy, th, 1)
	var dd = h1.y - h0.y
	return cl((floor_y - h0.y) / (dd if dd else 1e-6), 0, 1.05)
static func _head0() -> float: return atan2(AU_TOP.y - AU_FIST.y, AU_TOP.x - AU_FIST.x)
static func au_mop(S: St, fx: float, fy: float, th: float, s: float, wfn = null) -> void:
	var ctx := S.ctx; var A := au_axis(S)
	ctx.save(); ctx.translate(fx, fy); ctx.rotate(th); ctx.translate(-A[0] * s * A[2], -A[1] * s * A[2])
	ctx.drawImage(Spr.get_tex("npc_auntie__mop"), -AU_FIST.x * S.W, -AU_FIST.y * S.H, S.W, S.H)
	if wfn != null: wfn.call(func(u: float, v: float) -> Vector2: return Vector2((u - AU_FIST.x) * S.W, (v - AU_FIST.y) * S.H))
	ctx.restore()
static func resid(th: float) -> float: return th - roundf(th / PI) * PI   # JS Math.round（.5 向上）同 roundf 喺呢度唔會撞正 .5
# P：th fx fy fa floor reach s lean dx head legF hipA；hip(fx,fy,th,s) 換掉叉腰手；mfn 喺拖把座標入面再畫
static func auntie_draw(S: St, P: Dictionary, hip = null, mfn = null) -> void:
	var c := S.ctx; c.save(); lean(S, P.get("lean", 0.0), 0.35, P.get("dx", 0.0), 0)
	var hand_ok = Spr.ok("npc_auntie__hand") and Spr.ok("npc_auntie__bodyM")
	body(S, "npc_auntie", "npc_auntie__bodyM" if hand_ok else "npc_auntie__bodyH", {"head": P.get("head", 0.0), "legF": P.get("legF", 0.0), "legB": 0.0})
	var f := S.P(AU_FIST.x, AU_FIST.y); var w := S.P(AU_WR.x, AU_WR.y); var th: float = P.get("th", 0.0)
	var want = Vector2(f.x + P.get("fx", 0.0) * S.H, f.y + P.get("fy", 0.0) * S.H)
	var ha = atan2(want.y - w.y, want.x - w.x) - atan2(f.y - w.y, f.x - w.x)
	while ha > PI: ha -= 2 * PI
	while ha < -PI: ha += 2 * PI
	ha = cl(ha, -0.55, 0.55) + P.get("fa", 0.0)
	var cs = cos(ha); var sn = sin(ha); var rx = f.x - w.x; var ry = f.y - w.y
	var fx = w.x + rx * cs - ry * sn if hand_ok else want.x
	var fy = w.y + rx * sn + ry * cs if hand_ok else want.y
	var s: float = P.get("s", 0.0)
	if P.has("floor"): s = lerpf(0, au_reach(S, fx, fy, th, P.floor), P.get("reach", 1.0))
	au_mop(S, fx, fy, th, s, mfn)
	if hand_ok: piece(S, "npc_auntie__hand", AU_WR, w, ha)
	else: piece(S, "npc_auntie__fist", AU_FIST, Vector2(fx, fy), resid(th) + P.get("fa", 0.0))
	if hip != null: hip.call(fx, fy, th, s)
	else: piece(S, "npc_auntie__hip", AU_SH, S.P(AU_SH.x, AU_SH.y), P.get("hipA", 0.0))
	c.restore()
static func au_th(S: St, down: float) -> float:
	var want = down if S.fs > 0 else PI - down; var th = want - _head0()
	while th > PI: th -= 2 * PI
	while th < -PI: th += 2 * PI
	return th

const C_WET := Color(160 / 255.0, 210 / 255.0, 230 / 255.0, 0.2)
static func _auntie_mop(ctx: Ctx, a: Dictionary) -> bool:
	var S := begin(ctx, a, "npc_auntie__bodyH", false)
	if S == null: return false
	var t = S.at; var k = S.env; var push = sin(t * 3.4); var q = ss(k)
	var th = au_th(S, 0.62 + push * 0.06) * q
	var fx = q * S.fs * (0.03 + push * 0.05); var fy = q * (0.05 - push * 0.01)
	if k > 0.3:
		var g = S.P(AU_FIST.x, AU_FIST.y).x + S.fs * S.H * 0.42; ctx.save(); ctx.globalAlpha *= (k - 0.3) * 0.8
		ctx.fillStyle = C_WET; ctx.beginPath(); ctx.ellipse(g, -S.H * 0.004, S.H * 0.28, S.H * 0.035, 0, 0, PI * 2); ctx.fill(); ctx.restore()
	var mfn = func(L: Callable) -> void:
		if k < 0.5: return
		var h: Vector2 = L.call(AU_HEAD.x, AU_HEAD.y)
		for i in 2: drop(ctx, h.x + (i - 0.5) * S.H * 0.05, h.y, S.H * 0.009, _jm(t * 0.7 + i * 0.5, 1.0), S.H * 0.04)
	auntie_draw(S, {"th": th, "fx": fx, "fy": fy, "floor": -S.H * 0.045, "reach": q, "lean": S.fs * k * (0.05 + push * 0.025), "head": S.fs * k * (0.08 + push * 0.02)}, null, mfn)
	end(S); return true

static func _auntie_wring(ctx: Ctx, a: Dictionary) -> bool:
	var S := begin(ctx, a, "npc_auntie__bodyH", false)
	if S == null: return false
	var t = S.at; var k = S.env; var q = ss(k); var tw = sin(t * 8) * seg(t, 0.45, 0.65) * (1 - seg(t, 1.8, 2.0))
	var th = au_th(S, PI / 2 + S.fs * 0.12) * q + tw * 0.04
	var fx = q * S.fs * 0.05; var fy = q * 0.04
	var hip = func(FX: float, FY: float, TH: float, _s: float) -> void:   # 叉腰嘅手移去桿上面（拳頭上面少少）
		var sh := S.P(AU_SH.x, AU_SH.y); var H0 := S.P(AU_HAND.x, AU_HAND.y); var h0 = H0 - sh; var A := au_axis(S)
		var c = cos(TH); var sn = sin(TH); var up = Vector2(-(A[0] * c - A[1] * sn), -(A[0] * sn + A[1] * c))
		var g = Vector2(FX - up.x * S.H * 0.12, FY - up.y * S.H * 0.12)
		var a0 = atan2(h0.y, h0.x); var ang = atan2(g.y - sh.y, g.x - sh.x) - a0; var r = h0.length()
		var fix = Vector2(g.x - (sh.x + cos(ang + a0) * r), g.y - (sh.y + sin(ang + a0) * r))
		piece(S, "npc_auntie__hip", AU_SH, Vector2(sh.x + fix.x * q, sh.y + fix.y * q), ang * q - tw * 0.06 * q)
	var mfn = func(L: Callable) -> void:
		if k < 0.5: return
		var h: Vector2 = L.call(AU_HEAD.x, AU_HEAD.y); var sq = absf(tw)
		for i in 4: drop(ctx, h.x + (rnd(i) - 0.5) * S.H * 0.1, h.y + S.H * 0.01, S.H * 0.01, _jm(t * 1.7 + i / 4.0, 1.0), S.H * 0.05 * (0.4 + sq))
	auntie_draw(S, {"th": th, "fx": fx, "fy": fy, "floor": -S.H * 0.06, "reach": q, "fa": tw * 0.08, "lean": S.fs * k * 0.06, "head": S.fs * k * 0.12}, hip, mfn)
	end(S); return true

static func _auntie_grumble(ctx: Ctx, a: Dictionary) -> bool:
	var S := begin(ctx, a, "npc_auntie__bodyH", false)
	if S == null: return false
	var t = S.at; var k = S.env
	var tap = maxf(0, sin(t * 7)) * seg(t, 0.2, 0.4) * (1 - seg(t, 1.0, 1.2)); var shake = sin(t * 9) * seg(t, 1.1, 1.3) * (1 - seg(t, 2.0, 2.2))
	auntie_draw(S, {"fy": -k * tap * 0.025, "head": k * (shake * 0.1 + S.fs * 0.03), "lean": -S.fs * k * 0.02})
	var h := S.P(0.45, 0.12)
	text(S, h.x - S.fs * S.W * 0.42, h.y - S.H * 0.05, "哼！" if t < 1.1 else "嘖嘖……", S.H * 0.1, (bump(t, 0.15, 0.3, 1.0) + bump(t, 1.1, 1.3, 2.2)) * k)
	var ap := S.P(0.70, 0.10); anger(ctx, ap.x, ap.y, S.H * 0.075, bump(t, 0.2, 0.4, 2.1) * k)
	end(S); return true

static func _auntie_pack(ctx: Ctx, a: Dictionary) -> bool:
	var S := begin(ctx, a, "npc_auntie__bodyH", false)
	if S == null: return false
	var t = S.at; var k = S.env; var q = ss(k); var bend = bump(t, 0.2, 0.7, 1.4) + bump(t, 1.3, 1.8, 2.5); var rub = bump(t, 2.5, 2.8, 3.5)
	auntie_draw(S, {"th": au_th(S, PI / 2 + S.fs * 0.12) * q, "fx": q * S.fs * 0.05, "fy": q * 0.04, "floor": -S.H * 0.06, "reach": q,
		"lean": S.fs * k * (0.16 * bend - 0.05 * rub), "head": S.fs * k * (0.22 * bend - 0.08 * rub), "hipA": k * rub * sin(t * 16) * 0.12})
	end(S); return true

# ======================================================================
# 小晴（npc_it）：網格身體直接擺姿勢（armF = 揸筆電、armB = 揸珍奶）
# ======================================================================
static func mesh_body(S: St, rig: String, key: String, add: Dictionary) -> void:
	var z: Dictionary = S.z.duplicate(); z.x = 0.0; z.y = 0.0; z.sx = 1.0; z.sy = 1.0; z.rot = 0.0; z.legF = 0.0; z.legB = 0.0
	for k in add: z[k] = float(z.get(k, 0.0)) + add[k]
	MeshAnim.draw_body(S.ctx, rig, key, S.H, z)

static func _it_notes(ctx: Ctx, a: Dictionary) -> bool:
	var S := begin(ctx, a, "npc_it", true)
	if S == null: return false
	var t = S.at; var k = S.env; var q = loopt(t, 6); var look = bump(q, 4.2, 4.6, 5.5); var tap = sin(t * 14) * (1 - look)
	mesh_body(S, "npc_it", "npc_it", {"head": S.fs * k * (0.26 - look * 0.34), "body": S.fs * k * 0.04 * (1 - look), "armF": S.fs * k * (0.10 + tap * 0.03), "armB": S.fs * k * (0.08 + tap * 0.02)})
	end(S); return true

static func _it_pack(ctx: Ctx, a: Dictionary) -> bool:
	var S := begin(ctx, a, "npc_it", true)
	if S == null: return false
	var t = S.at; var k = S.env; var bend = bump(t, 0.2, 0.7, 2.2); var sw = sin(t * 7) * bend
	mesh_body(S, "npc_it", "npc_it", {"head": S.fs * k * (bend * 0.22 - bump(t, 2.3, 2.8, 3.5) * 0.12), "body": S.fs * k * bend * 0.12, "armF": -S.fs * k * (0.25 * bend + sw * 0.06), "armB": S.fs * k * (0.18 * bend + sw * 0.05)})
	end(S); return true
