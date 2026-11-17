# 原生改寫自 daily_town.js：冥街夜市（店主做生意、閒鬼逛街）＋回陽間（四個活人冇俾人嚇嘅時候做緊乜）
# 全部用原圖：身體 = 原圖拆咗手嗰張（MeshAnim 網格：頭、腳、尾、呼吸），手 = 原圖拆出嚟嘅件（繞關節轉），
# 道具 = 現成原圖件（furnace__paper、afu__phone、bun__basket…）或者由背景切出嚟嘅（street_strainer、street_lanternW/R）。
# 汗、Zzz、熱氣、水滴、亮點、字 = 程式畫嘅蠟筆小特效。
# DAILY['town_xxx'](ctx, a)：a.o.at = 做咗幾秒、a.o.adur = 今次做幾耐（頭尾 0.35 秒自己淡入淡出）、a.o.aw = 外面俾嘅權重、a.o.walk = 邊行邊做、a.o.prop = 道具／場景資料
# TOWN.tick／opts／npcTick／npcOpts：排程（隨機數 randf 次序同 JS 一樣）
# （回陽間另有 game/scare/sc_daily.gd 喺原生場景直接畫；呢度係 DAILY 登記表同 JS 介面嗰份，畫出嚟嘅指令同網頁版逐條一樣）
extends RefCounted

const D := PI / 180
const FONT := "\"Noto Sans CJK TC\",\"Noto Sans TC\",\"PingFang TC\",\"Microsoft JhengHei\",sans-serif"

# ---------------- 小工具 ----------------
static func _g(n: String): return J.G.get(n)
static func cl(v: float, a := 0.0, b := 1.0) -> float: return a if v < a else (b if v > b else v)
static func lerp_(a: float, b: float, k: float) -> float: return a + (b - a) * k
static func ss(t: float) -> float:
	t = cl(t); return t * t * (3 - 2 * t)
static func seg(t: float, a: float, b: float) -> float: return cl((t - a) / (b - a))
static func bump(t: float, a: float, m: float, b: float) -> float:
	if t <= a or t >= b: return 0.0
	return ss((t - a) / (m - a)) if t < m else 1 - ss((t - m) / (b - m))
# 關鍵格（cos 緩動）：K = [[時間, 值], ...]
static func kf(K: Array, t: float) -> float:
	if t <= K[0][0]: return K[0][1]
	for i in range(1, K.size()):
		if t <= K[i][0]:
			var a = K[i - 1]; var b = K[i]; var q = (t - a[0]) / (b[0] - a[0])
			return a[1] + (b[1] - a[1]) * (0.5 - 0.5 * cos(PI * q))
	return K[K.size() - 1][1]
static func rnd(s: float) -> float:
	var x = sin(s * 127.1 + 311.7) * 43758.5453
	return x - floor(x)
static func jm(a: float, b: float) -> float: return fmod(a, b)
static func loopt(t: float, T: float) -> float: return fmod(fmod(t, T) + T, T)
static func z0(v) -> float: return J.num(v) if J.t(v) else 0.0
static func ok(k: String) -> bool:
	var so = _g("sprOk")
	return so != null and J.t(J.cl(so, null, [k]))
static func _ma(): return _g("MeshAnim")
static func _spr(k: String): return J.gp(_g("SPR"), k)
static func _anim(n: String, a: Array) -> Dictionary: return J.cl(J.gp(J.gp(_ma(), "ANIM"), n), null, a)
static func _hyp(x: float, y: float) -> float: return sqrt(x * x + y * y)

# 一個動作嘅畫畫狀態（JS 嘅 S）
class St:
	extends RefCounted
	var ctx
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
	func P(u: float, v: float) -> Array: return [(u - 0.5) * W, (v - 1) * H]

# ---------- 畫一個角色：開始（原點 = 腳底中央，原圖方向，唔翻；最後跟面向成個翻）----------
# nr = 原圖面向右。fs = 「向前」喺原圖 x 嘅方向（向前低頭 = rotate(fs*角度)）
static func begin(ctx, a: Dictionary, key: String, nr: bool, no_lift := false) -> St:
	if not ok(key) or _ma() == null: return null
	var img = _spr(key); var o: Dictionary = a.o; var S = St.new()
	S.ctx = ctx; S.a = a; S.o = o; S.t = z0(o.get("t")); S.H = J.num(a.H); S.W = S.H * J.num(J.gp(img, "naturalWidth")) / J.num(J.gp(img, "naturalHeight"))
	S.at = z0(o.get("at")); S.dur = z0(o.get("adur"))
	var e = ss(S.at / 0.35)
	if S.dur: e = minf(e, ss((S.dur - S.at) / 0.35))
	if o.get("aw") != null: e *= cl(J.num(o.aw))
	S.env = e
	if not (o.get("shadow") is bool and o.shadow == false) and J.t(a.get("shadow")): J.cl(a.shadow, null, [a.x])
	S.z = _anim("idle", [S.t])
	S.flip = J.t(a.faceRight) != nr
	ctx.save()
	var fy = 0.0 if J.t(a.get("solid")) else -(3 + sin(S.t * 2.4) * 2) * (J.num(a.s) if J.t(a.get("s")) else S.H / 60)
	ctx.translate(J.num(a.x), J.num(a.y) + fy)
	if S.flip: ctx.scale(-1, 1)
	ctx.translate(0, (0.0 if no_lift else J.num(S.z.y)) * S.H); ctx.scale(J.num(S.z.sx), J.num(S.z.sy))
	S.fs = 1.0 if nr else -1.0; S.walk = J.t(o.get("walk"))
	return S
static func end_(S: St) -> void: S.ctx.restore()
# 網格身體嘅姿勢：沿用待機嘅頭、尾、頭髮晃動；手臂骨、身體骨歸零（拆出嚟嘅件先接得上）
static func mpose(S: St, add) -> Dictionary:
	var z = (_anim("walk", [S.t]) if S.walk else S.z).duplicate()
	z["armF"] = 0.0; z["armB"] = 0.0; z["axe"] = 0.0; z["body"] = 0.0; z["x"] = 0.0; z["y"] = 0.0; z["sx"] = 1.0; z["sy"] = 1.0; z["rot"] = 0.0
	if not S.walk: z["legF"] = 0.0; z["legB"] = 0.0
	if add != null:
		for k in add: z[k] = z0(z.get(k)) + J.num(add[k])
	return z
static func body(S: St, rig: String, key: String, add) -> void: J.cl(J.gp(_ma(), "drawBody"), null, [S.ctx, rig, key, S.H, mpose(S, add)])
# 繞腰（離地 ly 倍身高）轉 ang、再移位
static func lean(S: St, ang: float, ly := 0.35, dx := 0.0, dy := 0.0) -> void:
	var c = S.ctx; var l = ly if ly else 0.35
	c.translate(dx, dy); c.translate(0, -S.H * l); c.rotate(ang); c.translate(0, S.H * l)
# 成張原圖大小嘅切塊：支點 pv（原圖比例）放到 at（本地座標），轉 ang，縮放 sc；fn(L) 喺切塊座標入面再畫
static func piece(S: St, key: String, pv: Array, at: Array, ang := 0.0, sc := 0.0, fn = null) -> void:
	if not ok(key): return
	var c = S.ctx; c.save(); c.translate(at[0], at[1]); c.rotate(ang)
	if sc: c.scale(sc, sc)
	c.drawImage(_spr(key), -pv[0] * S.W, -pv[1] * S.H, S.W, S.H)
	if fn != null: fn.call(func(u: float, v: float) -> Array: return [(u - pv[0]) * S.W, (v - pv[1]) * S.H])
	c.restore()
# 道具（裁好嘅細圖）：闊 w，錨點 (ax,ay)，喺 (x,y) 轉 ang
static func prop(ctx, key: String, x: float, y: float, w: float, ang := 0.0, ax = null, ay = null, sx := 0.0, sy := 0.0) -> void:
	if not ok(key): return
	var im = _spr(key); var h = w * J.num(J.gp(im, "naturalHeight")) / J.num(J.gp(im, "naturalWidth"))
	ctx.save(); ctx.translate(x, y); ctx.rotate(ang); ctx.scale(sx if sx else 1.0, sy if sy else 1.0)
	ctx.drawImage(im, -(0.5 if ax == null else float(ax)) * w, -(0.5 if ay == null else float(ay)) * h, w, h); ctx.restore()
# 點 (u,v) 繞 (pu,pv) 轉 ang 之後喺邊（本地座標）
static func rotP(S: St, pu: float, pv: float, at: Array, ang: float, u: float, v: float) -> Array:
	var x = (u - pu) * S.W; var y = (v - pv) * S.H; var c = cos(ang); var s = sin(ang)
	return [at[0] + x * c - y * s, at[1] + x * s + y * c]

# ---------- 蠟筆小特效 ----------
static func _path(ctx, pts: Array) -> void:
	ctx.beginPath()
	for i in pts.size():
		if i: ctx.lineTo(pts[i][0], pts[i][1])
		else: ctx.moveTo(pts[i][0], pts[i][1])
static func crayon(ctx, pts: Array, w: float, col: String, out = null) -> void:
	ctx.lineCap = "round"; ctx.lineJoin = "round"
	if J.t(out): ctx.strokeStyle = out; ctx.lineWidth = w * 2; _path(ctx, pts); ctx.stroke()
	ctx.strokeStyle = col; ctx.lineWidth = w; _path(ctx, pts); ctx.stroke()
# 字：唔跟角色翻（翻咗就翻返轉）
static func text(S: St, x: float, y: float, txt: String, size: float, alpha: float, opt := {}) -> void:
	if alpha <= 0.01 or (J.t(S.o.get("quiet")) and not J.t(opt.get("fx"))): return   # quiet：頭上有對白框 → 動作自帶嘅字唔出
	var c = S.ctx
	c.save(); c.translate(x, y)
	if S.flip: c.scale(-1, 1)
	c.rotate(float(opt.get("rot", 0.0))); c.globalAlpha *= cl(alpha)
	c.font = "900 %spx %s" % [J.str(size), FONT]; c.textAlign = "center"; c.textBaseline = "middle"; c.lineJoin = "round"
	c.strokeStyle = opt.get("out", "#2a1a22"); c.lineWidth = size * 0.26; c.strokeText(txt, 0, 0)
	c.fillStyle = opt.get("col", "#fff3e8"); c.fillText(txt, 0, 0); c.restore()
static func puff(ctx, x: float, y: float, r: float, k: float, seed: float, col = null) -> void:   # 一團呼出嚟嘅氣
	if k <= 0 or k >= 1: return
	ctx.save(); ctx.globalAlpha *= sin(k * PI) * 0.85
	for i in 3:
		var a = rnd(seed + i) * 6.28; var rr = r * (0.45 + 0.4 * rnd(seed + i * 3)) * (0.6 + k * 0.6)
		var px = x + cos(a) * r * 0.5 * k + i * r * 0.35 * k; var py = y + sin(a) * r * 0.3 - k * r * 0.4
		ctx.fillStyle = col if J.t(col) else "rgba(245,245,250,.85)"; ctx.strokeStyle = "rgba(60,60,80,.35)"; ctx.lineWidth = maxf(1, r * 0.08)
		ctx.beginPath(); ctx.arc(px, py, rr, 0, PI * 2); ctx.fill(); ctx.stroke()
	ctx.restore()
static func steam_curl(ctx, x: float, y: float, h: float, k: float, seed: float, a = null) -> void:   # 一縷熱氣
	if k <= 0 or k >= 1: return
	ctx.save(); ctx.globalAlpha *= sin(k * PI) * (J.num(a) if J.t(a) else 0.75)
	var pts = []
	for i in 11:
		var u = i / 10.0; pts.append([x + sin(u * 5 + seed + k * 5) * h * 0.12, y - u * h * (0.4 + k * 0.6) - k * h * 0.3])
	crayon(ctx, pts, maxf(1.4, h * 0.06), "rgba(250,246,240,.9)", "rgba(60,50,60,.25)"); ctx.restore()
static func drop(ctx, x: float, y: float, r: float, k: float, fall: float) -> void:   # 一滴水跌落嚟
	if k <= 0 or k >= 1: return
	var py = y + fall * k * k; ctx.save(); ctx.globalAlpha *= 1 - k * 0.5
	ctx.fillStyle = "rgba(30,60,72,.9)"; ctx.beginPath(); ctx.ellipse(x, py, r * 1.2, r * 1.7, 0, 0, PI * 2); ctx.fill()
	ctx.fillStyle = "rgba(165,215,232,.95)"; ctx.beginPath(); ctx.ellipse(x, py, r * 0.85, r * 1.3, 0, 0, PI * 2); ctx.fill(); ctx.restore()
static func sparkle(ctx, x: float, y: float, r: float, k: float) -> void:   # 四角亮點（擦亮）
	if k <= 0: return
	ctx.save(); ctx.translate(x, y); ctx.scale(k, k); ctx.globalAlpha *= minf(1, k * 1.5)
	ctx.beginPath()
	for i in 8:
		var an = i / 8.0 * PI * 2; var rr = r * 0.22 if i % 2 else r
		ctx.lineTo(cos(an) * rr, sin(an) * rr)
	ctx.closePath(); ctx.fillStyle = "#fffbe8"; ctx.strokeStyle = "rgba(90,70,20,.6)"; ctx.lineWidth = maxf(1, r * 0.12); ctx.stroke(); ctx.fill(); ctx.restore()
static func zzz(S: St, x: float, y: float, size: float, t: float, a: float) -> void:   # Zzz 向上飄
	for i in 3:
		var q = jm(t * 0.45 + i / 3.0, 1)
		text(S, x + q * size * 1.2 + sin(q * 6 + i) * size * 0.2, y - q * size * 2.2, "Z" if i == 1 else "z", size * (0.6 + q * 0.6), a * sin(q * PI), {"col": "#dfe8ff", "out": "#2a2a48", "fx": 1})
static func marks(ctx, x: float, y: float, r: float, k: float, col = null) -> void:   # 驚／嬲嘅三條短線
	if k <= 0: return
	ctx.save(); ctx.globalAlpha *= k
	for i in range(-1, 2):
		var an = -PI / 2 + i * 0.55
		crayon(ctx, [[x + cos(an) * r * 0.55, y + sin(an) * r * 0.55], [x + cos(an) * r, y + sin(an) * r]], maxf(1.5, r * 0.12), col if J.t(col) else "#fff2c0", "rgba(40,20,20,.6)")
	ctx.restore()
static func anger(ctx, x: float, y: float, r: float, k: float) -> void:   # 嬲到起青筋（十字）
	if k <= 0: return
	ctx.save(); ctx.globalAlpha *= k; ctx.translate(x, y); ctx.scale(0.7 + 0.3 * k, 0.7 + 0.3 * k)
	for i in 4:
		ctx.save(); ctx.rotate(i * PI / 2 + PI / 4); crayon(ctx, [[r * 0.2, -r * 0.35], [r * 0.55, -r * 0.1], [r * 0.55, r * 0.3]], maxf(1.5, r * 0.2), "#e8333a", "rgba(60,0,0,.5)"); ctx.restore()
	ctx.restore()
static func _pp(S: St, uv: Array) -> Array: return S.P(uv[0], uv[1])

# ======================================================================
# 回陽間・阿Ken：右手前臂（npc_ken__fore）繞手肘轉；手機喺另一隻手（身上）
# ======================================================================
const KEN := {"ELB": [0.69, 0.565], "HAND": [0.33, 0.50], "MOUTH": [0.37, 0.355], "EYE": [0.43, 0.305], "PHONE": [0.16, 0.43]}
static func ken_draw(S: St, P: Dictionary) -> void:
	var c = S.ctx
	c.save(); lean(S, z0(P.get("lean")), 0.35)
	body(S, "npc_ken", "npc_ken__bodyF", {"head": z0(P.get("head")), "legF": z0(P.get("legF")), "legB": z0(P.get("legB"))})
	var e = _pp(S, KEN.ELB)
	piece(S, "npc_ken__fore", KEN.ELB, [e[0] + z0(P.get("fx")) * S.H, e[1] - z0(P.get("lift")) * S.H], z0(P.get("ang")), J.num(P.sc) if J.t(P.get("sc")) else 1.0)
	c.restore()
static func ken_face(S: St, P: Dictionary) -> Array:
	var l = z0(P.get("lean")); var p = S.P(0.40, 0.33); var r = [p[0], p[1] + S.H * 0.35]; var cs = cos(l); var sn = sin(l)
	return [r[0] * cs - r[1] * sn, r[0] * sn + r[1] * cs - S.H * 0.35]
# 碌手機：拇指一下一下向上掃（前臂跟住輕輕震），頭跟住內容點一點
static func ken_scroll(ctx, a: Dictionary):
	var S = begin(ctx, a, "npc_ken__bodyF", false)
	if S == null: return false
	var k = S.env; var q = jm(S.at, 1.1) / 1.1; var fl = bump(q, 0.55, 0.66, 0.85)
	ken_draw(S, {"ang": k * (0.035 * fl + 0.01 * sin(S.at * 1.7)), "head": k * S.fs * (0.05 + 0.02 * fl), "lean": k * S.fs * 0.02})
	if fl > 0.2:
		var h = S.P(0.30, 0.445); ctx.save(); ctx.globalAlpha *= k * fl * 0.7
		crayon(ctx, [[h[0] - S.W * 0.05, h[1] + S.H * 0.012], [h[0], h[1] - S.H * 0.004], [h[0] + S.W * 0.04, h[1] - S.H * 0.02]], maxf(1, S.H * 0.008), "rgba(255,255,255,.9)"); ctx.restore()
	end_(S); return true
# 打喊路：吸氣伸懶腰、頭向後仰、手揞嘴、眼角擠出一滴眼淚，「哈～」，放低嚟擰擰頭
static func ken_yawn(ctx, a: Dictionary):
	var S = begin(ctx, a, "npc_ken__bodyF", false)
	if S == null: return false
	var t = S.at; var k = S.env
	var up = kf([[0, 0], [0.7, 1], [2.2, 1], [2.8, 0]], t); var back = kf([[0, 0], [0.5, 0.3], [0.9, 1], [2.0, 1], [2.6, 0], [2.9, -0.25], [3.2, 0]], t)
	var sy = 1 + 0.045 * kf([[0, 0], [0.6, 1], [1.9, 1.15], [2.6, 0], [2.9, -0.3], [3.3, 0]], t) * k
	ctx.save(); ctx.scale(1 / sqrt(sy), sy)
	ken_draw(S, {"ang": k * up * 0.62, "lift": k * up * 0.035, "fx": k * up * 0.02, "sc": 1 + 0.05 * up * k, "head": -S.fs * k * back * 0.16 + S.fs * k * 0.05 * sin(maxf(0, t - 2.6) * 18) * seg(t, 2.6, 2.75) * (1 - seg(t, 2.95, 3.2)), "lean": -S.fs * k * back * 0.03})
	ctx.restore()
	var f = ken_face(S, {}); var hk = bump(t, 0.6, 1.0, 2.3) * k
	text(S, f[0] - S.fs * S.H * 0.32, f[1] - S.H * 0.25 - hk * S.H * 0.04, "哈～", S.H * 0.11, hk, {"rot": -0.1})
	var tk = bump(t, 1.2, 1.6, 2.8) * k
	if tk > 0:
		var e = S.P(0.25, 0.33); ctx.save(); ctx.globalAlpha *= tk; ctx.fillStyle = "rgba(170,220,255,.95)"; ctx.strokeStyle = "rgba(40,70,110,.6)"; ctx.lineWidth = 1
		ctx.beginPath(); ctx.ellipse(e[0], e[1] + tk * S.H * 0.01, S.H * 0.008, S.H * 0.012, 0, 0, PI * 2); ctx.fill(); ctx.stroke(); ctx.restore()
	end_(S); return true
# 擦眼：手背頂住眼鏡下面揉幾圈，頭低少少湊過去
static func ken_rub(ctx, a: Dictionary):
	var S = begin(ctx, a, "npc_ken__bodyF", false)
	if S == null: return false
	var t = S.at; var k = S.env; var up = kf([[0, 0], [0.6, 1], [2.2, 1], [2.8, 0]], t); var rb = seg(t, 0.6, 2.2) * (1 - seg(t, 2.1, 2.3))
	var wig = sin(t * 15) * rb
	ken_draw(S, {"ang": k * (up * 0.8 + wig * 0.035), "lift": k * (up * 0.10 + cos(t * 15) * rb * 0.006), "fx": k * up * 0.03, "sc": 1 + 0.06 * up * k, "head": S.fs * k * up * 0.09, "lean": S.fs * k * up * 0.025})
	end_(S); return true
# 對住個螢幕嘆氣
static func ken_sigh(ctx, a: Dictionary):
	var S = begin(ctx, a, "npc_ken__bodyF", false)
	if S == null: return false
	var t = S.at; var k = S.env; var inh = kf([[0, 0], [0.7, 1], [1.0, 1], [1.5, -0.6], [2.6, -0.5], [3.0, 0]], t)
	ctx.save(); ctx.scale(1, 1 + 0.03 * inh * k)
	ken_draw(S, {"ang": k * (0.05 * inh), "head": S.fs * k * (-0.05 * maxf(0, inh) + 0.14 * maxf(0, -inh)), "lean": S.fs * k * 0.03 * maxf(0, -inh)})
	ctx.restore()
	var f = ken_face(S, {})
	puff(ctx, f[0] + S.fs * S.H * 0.04, f[1] + S.H * 0.06, S.H * 0.05, seg(t, 1.0, 2.2), 3.1)
	text(S, f[0] - S.fs * S.H * 0.30, f[1] - S.H * 0.22, "唉……", S.H * 0.1, bump(t, 1.0, 1.4, 2.6) * k, {"col": "#cfd8ff", "out": "#1e2238"})
	end_(S); return true

# ======================================================================
# 陳總：水晶球手（npc_boss__arm，繞手肘）＋手套手（npc_boss__point，繞膊頭），身體 npc_boss__bodyN
# ======================================================================
const BOSS := {"EL": [0.23, 0.56], "BALL": [0.12, 0.27], "SH": [0.775, 0.475], "HAND": [0.835, 0.75], "WATCH": [0.80, 0.63], "MOUTH": [0.39, 0.315]}
static func boss_draw(S: St, P: Dictionary, after = null) -> void:
	var c = S.ctx; c.save(); lean(S, z0(P.get("lean")), 0.35, z0(P.get("dx")), 0)
	body(S, "npc_boss", "npc_boss__bodyN", {"head": z0(P.get("head")), "legF": z0(P.get("legF")), "legB": z0(P.get("legB"))})
	var sh = _pp(S, BOSS.SH); var el = _pp(S, BOSS.EL)
	var gl = func(): piece(S, "npc_boss__point", BOSS.SH, [sh[0], sh[1] - z0(P.get("shUp")) * S.H], z0(P.get("glove")), 1, P.get("gfn"))
	if J.t(P.get("gloveBack")): gl.call()
	piece(S, "npc_boss__arm", BOSS.EL, [el[0], el[1] - z0(P.get("elUp")) * S.H], z0(P.get("ball")), 1, P.get("bfn"))
	if not J.t(P.get("gloveBack")): gl.call()
	if after != null: after.call()
	c.restore()
# 擦水晶球
static func boss_polish(ctx, a: Dictionary):
	var S = begin(ctx, a, "npc_boss__bodyN", false)
	if S == null: return false
	var t = S.at; var k = S.env; var near = kf([[0, 0], [0.6, 1], [3.1, 1], [3.6, 0]], t); var rub = seg(t, 1.3, 2.7) * (1 - seg(t, 2.6, 2.8))
	boss_draw(S, {"ball": k * (near * 0.13 + sin(t * 13) * 0.03 * rub), "elUp": k * near * 0.015, "head": S.fs * k * (near * 0.1 - 0.06 * bump(t, 2.9, 3.1, 3.4)), "lean": S.fs * k * near * 0.025,
		"bfn": func(L):
			var p = L.call(BOSS.BALL[0], BOSS.BALL[1]); var fog = bump(t, 0.9, 1.25, 2.4) * k
			if fog > 0: ctx.save(); ctx.globalAlpha *= fog * 0.55; ctx.fillStyle = "rgba(235,240,250,.9)"; ctx.beginPath(); ctx.arc(p[0], p[1], S.W * 0.1, 0, PI * 2); ctx.fill(); ctx.restore()
			if rub > 0:
				ctx.save(); ctx.globalAlpha *= rub * k * 0.8; var r = S.W * 0.07; var an = t * 13
				crayon(ctx, [[p[0] + cos(an) * r, p[1] + sin(an) * r * 0.7], [p[0] + cos(an + 0.9) * r, p[1] + sin(an + 0.9) * r * 0.7]], maxf(1, S.H * 0.008), "rgba(255,255,255,.9)"); ctx.restore()
			sparkle(ctx, p[0] + S.W * 0.04, p[1] - S.W * 0.05, S.H * 0.05, bump(t, 2.75, 2.9, 3.4) * k)})
	var m = _pp(S, BOSS.MOUTH); puff(ctx, lerp_(m[0], m[0] + S.fs * S.W * 0.12, seg(t, 0.75, 1.2)), m[1], S.H * 0.035, seg(t, 0.7, 1.3), 7.7)
	text(S, m[0] - S.fs * S.W * 0.30, m[1] - S.H * 0.17, "哈——", S.H * 0.085, bump(t, 0.7, 0.85, 1.3) * k)
	end_(S); return true
# 睇錶
static func boss_watch(ctx, a: Dictionary):
	var S = begin(ctx, a, "npc_boss__bodyN", false)
	if S == null: return false
	var t = S.at; var k = S.env; var up = kf([[0, 0], [0.5, 1], [2.2, 1], [2.7, 0]], t); var flick = sin(maxf(0, t - 0.5) * 30) * bump(t, 0.5, 0.55, 0.75)
	var tap = maxf(0, sin(t * 9)) * seg(t, 1.2, 1.4) * (1 - seg(t, 2.3, 2.5))
	boss_draw(S, {"glove": k * (up * 1.45 + flick * 0.05), "shUp": k * up * 0.01, "head": S.fs * k * up * 0.16, "lean": S.fs * k * up * 0.02, "legF": k * tap * 0.12 * -S.fs})
	var m = S.P(0.5, 0.0); text(S, m[0] - S.fs * S.W * 0.42, m[1] + S.H * 0.04, "嘖", S.H * 0.11, bump(t, 1.4, 1.6, 2.3) * k)
	end_(S); return true
# 罵電話
static func boss_call(ctx, a: Dictionary):
	var S = begin(ctx, a, "npc_boss__bodyN", false)
	if S == null: return false
	var t = S.at; var k = S.env; var up = kf([[0, 0], [0.5, 1], [3.4, 1], [3.9, 0]], t); var yell = seg(t, 0.8, 1.0) * (1 - seg(t, 3.2, 3.5))
	var jab = maxf(0, sin(t * 7.5)) * yell; var sh = sin(t * 40) * 0.008 * yell
	boss_draw(S, {"glove": k * (up * 1.75 + jab * 0.06), "shUp": k * up * 0.03, "head": S.fs * k * (up * 0.06 + jab * 0.08) + sh, "lean": S.fs * k * (jab * 0.04), "dx": S.fs * k * jab * S.H * 0.01,
		"gfn": func(L):
			var p = L.call(BOSS.HAND[0], BOSS.HAND[1]); prop(ctx, "afu__phone", p[0] + S.fs * S.W * 0.02, p[1] - S.H * 0.04, S.H * 0.14 * up * k + 0.0001, -S.fs * 0.3 - (up * 1.75) * k, 0.5, 0.6, -S.fs, 1)})
	var m = _pp(S, BOSS.MOUTH)
	var words = ["喂？！", "我不管！", "明天交！"]; var wi = mini(2, int(floor(maxf(0, t - 0.9) / 0.85)))
	text(S, m[0] + S.fs * S.W * 0.55, m[1] - S.H * 0.30 - jab * S.H * 0.02, words[wi], S.H * 0.1, yell * k, {"col": "#ffe0d8", "rot": -0.08})
	var ap = S.P(0.66, 0.08); anger(ctx, ap[0], ap[1], S.H * 0.07, yell * k * (0.8 + 0.2 * sin(t * 12)))
	end_(S); return true
static func boss_admire(ctx, a: Dictionary):
	var S = begin(ctx, a, "npc_boss__bodyN", false)
	if S == null: return false
	var t = S.at; var k = S.env; boss_draw(S, {"ball": k * sin(t * 1.6) * 0.06, "head": S.fs * k * (0.05 + sin(t * 1.6 + 0.4) * 0.025)})
	end_(S); return true

# ======================================================================
# 保安阿伯：電筒手（npc_guard__arm，繞膊頭）＋保溫壺：袖（npc_guard__sleeve，繞膊頭）＋手同壺（npc_guard__tea，繞手腕）
# ======================================================================
const GU := {"FL": [0.33, 0.53], "FTIP": [0.06, 0.66], "SH": [0.882, 0.4565], "WR": [0.885, 0.578], "CAP": [0.745, 0.465], "MOUTH": [0.5, 0.335]}
static func guard_draw(S: St, P: Dictionary, after = null) -> void:
	var c = S.ctx; c.save(); lean(S, z0(P.get("lean")), 0.4, 0, z0(P.get("dy")))
	body(S, "npc_guard", "npc_guard__bodyN", {"head": z0(P.get("head"))})
	var sh = _pp(S, GU.SH); var fl = _pp(S, GU.FL)
	var wr = rotP(S, GU.SH[0], GU.SH[1], sh, z0(P.get("arm")), GU.WR[0], GU.WR[1])
	piece(S, "npc_guard__tea", GU.WR, wr, z0(P.get("arm")) + z0(P.get("wrist")), 1, P.get("tfn"))
	piece(S, "npc_guard__sleeve", GU.SH, sh, z0(P.get("arm")))
	piece(S, "npc_guard__arm", GU.FL, fl, z0(P.get("fl")), 1, P.get("ffn"))
	if after != null: after.call()
	c.restore()
static func guard_patrol(ctx, a: Dictionary):
	var S = begin(ctx, a, "npc_guard__bodyN", false)
	if S == null: return false
	var t = S.at; var k = S.env; var sw = sin(t * 1.9) * 0.16 + sin(t * 0.7) * 0.05
	guard_draw(S, {"fl": k * (sw + 0.04), "head": S.fs * k * (-sw * 0.35 + 0.02), "arm": k * sin(S.t * 7) * 0.05 * (1.0 if S.walk else 0.0)})
	end_(S); return true
# 飲保溫壺嘅茶（IK：壺口去到嘴邊；結果只同左右同圖比例有關，計一次就記住）
static var IKC := {}
static func guard_sip(S: St) -> void:
	var t = S.at; var k = S.env; var up = kf([[0, 0], [0.7, 1], [2.3, 1], [2.9, 0]], minf(t, 3.3) if S.dur else t); var drink = bump(t, 0.9, 1.2, 2.2)
	var sh = _pp(S, GU.SH); var m = _pp(S, GU.MOUTH); var tgt = [m[0] + S.fs * S.W * 0.02, m[1] + S.H * 0.03]
	var ikK = J.str(S.fs) + "|" + JStr.num_call(S.W / S.H, "toFixed", [5.0])
	var best = (IKC[ikK] as Array).duplicate() if IKC.has(ikK) else [0.0, 0.0]; var be = -1.0 if IKC.has(ikK) else 1e9
	if be > 0:
		var a1 = 0.0
		while a1 <= 2.2:
			var a2 = -2.4
			while a2 <= 0.4:
				var w = rotP(S, GU.SH[0], GU.SH[1], sh, a1, GU.WR[0], GU.WR[1]); var c = rotP(S, GU.WR[0], GU.WR[1], w, a1 + a2, GU.CAP[0], GU.CAP[1])
				var e = _hyp(c[0] - tgt[0], c[1] - tgt[1]) + absf(a1 + a2 - S.fs * 0.55) * S.H * 0.03
				if e < be: be = e; best = [a1, a2]
				a2 += 0.05
			a1 += 0.05
	IKC[ikK] = best.duplicate(); var A = k * up
	guard_draw(S, {"arm": best[0] * A, "wrist": (best[1] - drink * 0.25) * A, "head": -S.fs * k * (up * 0.06 + drink * 0.1), "lean": -S.fs * k * drink * 0.03, "fl": k * up * 0.05,
		"tfn": func(L):
			var p = L.call(GU.CAP[0], GU.CAP[1]); steam_curl(S.ctx, p[0], p[1] - S.H * 0.02, S.H * 0.18, jm(t * 0.9, 1), 2.1, 0.6 * k)})
	var f = S.P(0.45, 0.30)
	puff(S.ctx, f[0] - S.fs * S.W * 0.05, f[1] + S.H * 0.04, S.H * 0.04, seg(t, 2.3, 3.2), 5.5)
	text(S, f[0] - S.fs * S.W * 0.35, f[1] - S.H * 0.18, "哈～", S.H * 0.095, bump(t, 2.3, 2.5, 3.1) * k)
static func guard_sip_act(ctx, a: Dictionary):
	var S = begin(ctx, a, "npc_guard__bodyN", false)
	if S == null: return false
	guard_sip(S); end_(S); return true
static func guard_doze(ctx, a: Dictionary):
	var S = begin(ctx, a, "npc_guard__bodyN", false)
	if S == null: return false
	var t = S.at; var k = S.env; var nod = kf([[0, 0], [1.2, 0.6], [1.5, 0.5], [2.6, 1], [3.2, 1], [3.35, -0.25], [3.7, 0.05], [4.2, 0]], t)
	var jerk = bump(t, 3.2, 3.35, 3.7)
	ctx.save(); ctx.scale(1, 1 - 0.03 * maxf(0, nod) * k)
	guard_draw(S, {"head": S.fs * k * nod * 0.5, "lean": S.fs * k * nod * 0.06, "dy": k * (maxf(0, nod) * S.H * 0.015 - jerk * S.H * 0.03), "fl": -k * maxf(0, nod) * 0.45, "arm": -k * maxf(0, nod) * 0.06})
	ctx.restore()
	var h = S.P(0.3, 0.12); zzz(S, h[0] - S.fs * S.W * 0.15, h[1], S.H * 0.09, t, seg(t, 1.0, 1.5) * (1 - seg(t, 3.1, 3.25)) * k)
	var mp = S.P(0.5, 0.05); marks(ctx, mp[0], mp[1] - S.H * 0.03, S.H * 0.09, jerk * k)
	end_(S); return true

# ======================================================================
# 清潔安娣：拖把（npc_auntie__mop）＋拳頭（npc_auntie__fist）＋叉腰嘅手（npc_auntie__hip）
# ======================================================================
const AU := {"FIST": [0.275, 0.512], "TOP": [0.235, 0.34], "BOT": [0.37, 0.95], "HEAD": [0.10, 0.40], "SH": [0.765, 0.43], "HAND": [0.735, 0.595]}
static func au_axis(S: St) -> Dictionary:
	var ax = (AU.BOT[0] - AU.TOP[0]) * S.W; var ay = (AU.BOT[1] - AU.TOP[1]) * S.H; var L = _hyp(ax, ay)
	return {"ux": ax / L, "uy": ay / L, "L": L}
static func au_head(S: St, fx: float, fy: float, th: float, s: float) -> Array:
	var A = au_axis(S); var hx = (AU.HEAD[0] - AU.FIST[0]) * S.W - A.ux * s * A.L; var hy = (AU.HEAD[1] - AU.FIST[1]) * S.H - A.uy * s * A.L; var c = cos(th); var sn = sin(th)
	return [fx + hx * c - hy * sn, fy + hx * sn + hy * c]
static func au_reach(S: St, fx: float, fy: float, th: float, floor_: float) -> float:
	var h0 = au_head(S, fx, fy, th, 0); var h1 = au_head(S, fx, fy, th, 1); var dd = h1[1] - h0[1]
	return cl((floor_ - h0[1]) / (dd if dd else 1e-6), 0, 1.05)
static func head0() -> float: return atan2(AU.TOP[1] - AU.FIST[1], AU.TOP[0] - AU.FIST[0])
static func au_mop(S: St, fx: float, fy: float, th: float, s: float, wfn) -> void:
	var ctx = S.ctx; var A = au_axis(S)
	ctx.save(); ctx.translate(fx, fy); ctx.rotate(th); ctx.translate(-A.ux * s * A.L, -A.uy * s * A.L)
	ctx.drawImage(_spr("npc_auntie__mop"), -AU.FIST[0] * S.W, -AU.FIST[1] * S.H, S.W, S.H)
	if wfn != null: wfn.call(func(u: float, v: float) -> Array: return [(u - AU.FIST[0]) * S.W, (v - AU.FIST[1]) * S.H])
	ctx.restore()
static func resid(th: float) -> float: return th - J.round(th / PI) * PI
const WR := [0.386, 0.526]
static func auntie_draw(S: St, P: Dictionary) -> Dictionary:
	var c = S.ctx; c.save(); lean(S, z0(P.get("lean")), 0.35, z0(P.get("dx")), 0)
	var hand_ok = ok("npc_auntie__hand") and ok("npc_auntie__bodyM")
	body(S, "npc_auntie", "npc_auntie__bodyM" if hand_ok else "npc_auntie__bodyH", {"head": z0(P.get("head")), "legF": z0(P.get("legF")), "legB": z0(P.get("legB"))})
	var f = _pp(S, AU.FIST); var w = S.P(WR[0], WR[1]); var th = z0(P.get("th"))
	var want = [f[0] + z0(P.get("fx")) * S.H, f[1] + z0(P.get("fy")) * S.H]
	var ha = atan2(want[1] - w[1], want[0] - w[0]) - atan2(f[1] - w[1], f[0] - w[0])
	while ha > PI: ha -= 2 * PI
	while ha < -PI: ha += 2 * PI
	ha = cl(ha, -0.55, 0.55) + z0(P.get("fa"))
	var cs = cos(ha); var sn = sin(ha); var rx = f[0] - w[0]; var ry = f[1] - w[1]
	var fx = w[0] + rx * cs - ry * sn if hand_ok else want[0]; var fy = w[1] + rx * sn + ry * cs if hand_ok else want[1]
	var s = z0(P.get("s"))
	if P.get("floor") != null: s = lerp_(0, au_reach(S, fx, fy, th, J.num(P.floor)), 1.0 if P.get("reach") == null else J.num(P.reach))
	au_mop(S, fx, fy, th, s, P.get("mfn"))
	if hand_ok: piece(S, "npc_auntie__hand", WR, w, ha)
	else: piece(S, "npc_auntie__fist", AU.FIST, [fx, fy], resid(th) + z0(P.get("fa")))
	if P.get("hip") != null: P.hip.call(fx, fy, th, s)
	else: piece(S, "npc_auntie__hip", AU.SH, _pp(S, AU.SH), z0(P.get("hipA")))
	c.restore()
	return {"fx": fx, "fy": fy, "th": th, "s": s}
static func au_th(S: St, down: float) -> float:
	var want = down if S.fs > 0 else PI - down; var th = want - head0()
	while th > PI: th -= 2 * PI
	while th < -PI: th += 2 * PI
	return th
static func auntie_mop(ctx, a: Dictionary):
	var S = begin(ctx, a, "npc_auntie__bodyH", false)
	if S == null: return false
	var t = S.at; var k = S.env; var push = sin(t * 3.4); var q = ss(k)
	var th = au_th(S, 0.62 + push * 0.06) * q
	var fx = q * S.fs * (0.03 + push * 0.05); var fy = q * (0.05 - push * 0.01)
	if k > 0.3:
		var g = _pp(S, AU.FIST)[0] + S.fs * S.H * 0.42; ctx.save(); ctx.globalAlpha *= (k - 0.3) * 0.8; ctx.fillStyle = "rgba(160,210,230,.2)"; ctx.beginPath(); ctx.ellipse(g, -S.H * 0.004, S.H * 0.28, S.H * 0.035, 0, 0, PI * 2); ctx.fill(); ctx.restore()
	auntie_draw(S, {"th": th, "fx": fx, "fy": fy, "floor": -S.H * 0.045, "reach": q, "lean": S.fs * k * (0.05 + push * 0.025), "head": S.fs * k * (0.08 + push * 0.02), "legF": 0.0,
		"mfn": func(L):
			if k < 0.5: return
			var h = L.call(AU.HEAD[0], AU.HEAD[1])
			for i in 2: drop(ctx, h[0] + (i - 0.5) * S.H * 0.05, h[1], S.H * 0.009, jm(t * 0.7 + i * 0.5, 1), S.H * 0.04)})
	end_(S); return true
static func auntie_wring(ctx, a: Dictionary):
	var S = begin(ctx, a, "npc_auntie__bodyH", false)
	if S == null: return false
	var t = S.at; var k = S.env; var q = ss(k); var tw = sin(t * 8) * seg(t, 0.45, 0.65) * (1 - seg(t, 1.8, 2.0))
	var th = au_th(S, PI / 2 + S.fs * 0.12) * q + tw * 0.04
	var fx = q * S.fs * 0.05; var fy = q * 0.04
	var hip = func(FX: float, FY: float, TH: float, _s: float):   # 叉腰嘅手移到拖把柄上（拳頭上面少少）
		var sh = _pp(S, AU.SH); var H0 = _pp(S, AU.HAND); var h0 = [H0[0] - sh[0], H0[1] - sh[1]]; var A = au_axis(S)
		var c = cos(TH); var sn = sin(TH); var up = [-(A.ux * c - A.uy * sn), -(A.ux * sn + A.uy * c)]
		var g = [FX - up[0] * S.H * 0.12, FY - up[1] * S.H * 0.12]
		var a0 = atan2(h0[1], h0[0]); var ang = atan2(g[1] - sh[1], g[0] - sh[0]) - a0; var r = _hyp(h0[0], h0[1])
		var fix = [g[0] - (sh[0] + cos(ang + a0) * r), g[1] - (sh[1] + sin(ang + a0) * r)]
		piece(S, "npc_auntie__hip", AU.SH, [sh[0] + fix[0] * q, sh[1] + fix[1] * q], ang * q - tw * 0.06 * q)
	auntie_draw(S, {"th": th, "fx": fx, "fy": fy, "floor": -S.H * 0.06, "reach": q, "fa": tw * 0.08, "lean": S.fs * k * 0.06, "head": S.fs * k * 0.12, "hip": hip,
		"mfn": func(L):
			if k < 0.5: return
			var h = L.call(AU.HEAD[0], AU.HEAD[1]); var sq = absf(tw)
			for i in 4: drop(ctx, h[0] + (rnd(i) - 0.5) * S.H * 0.1, h[1] + S.H * 0.01, S.H * 0.01, jm(t * 1.7 + i / 4.0, 1), S.H * 0.05 * (0.4 + sq))})
	end_(S); return true
static func auntie_grumble(ctx, a: Dictionary):
	var S = begin(ctx, a, "npc_auntie__bodyH", false)
	if S == null: return false
	var t = S.at; var k = S.env; var tap = maxf(0, sin(t * 7)) * seg(t, 0.2, 0.4) * (1 - seg(t, 1.0, 1.2)); var shake = sin(t * 9) * seg(t, 1.1, 1.3) * (1 - seg(t, 2.0, 2.2))
	auntie_draw(S, {"fy": -k * tap * 0.025, "head": k * (shake * 0.1 + S.fs * 0.03), "lean": -S.fs * k * 0.02})
	var h = S.P(0.45, 0.12)
	text(S, h[0] - S.fs * S.W * 0.42, h[1] - S.H * 0.05, "哼！" if t < 1.1 else "嘖嘖……", S.H * 0.1, (bump(t, 0.15, 0.3, 1.0) + bump(t, 1.1, 1.3, 2.2)) * k)
	var ap = S.P(0.70, 0.10); anger(ctx, ap[0], ap[1], S.H * 0.075, bump(t, 0.2, 0.4, 2.1) * k)
	end_(S); return true

# ======================================================================
# 回陽間・辦公室專屬動作（scare 按 n.act 強制播：office_*／town_guard_dozeL）
# ======================================================================
static func office_boss_present(ctx, a: Dictionary):
	var S = begin(ctx, a, "npc_boss__bodyN", false)
	if S == null: return false
	var t = S.at; var k = S.env; var q = loopt(t, 5.2); var up = kf([[0, 0.55], [0.6, 1], [3.6, 1], [4.3, 0.55], [5.2, 0.55]], q)
	var jab = maxf(0, sin(t * 6.5)) * bump(q, 0.8, 1.2, 3.2); var look = sin(t * 0.9)
	boss_draw(S, {"glove": -k * (up * 2.3 + jab * 0.10), "shUp": k * up * 0.012, "head": S.fs * k * (-0.05 * up + 0.04 * look), "lean": -S.fs * k * jab * 0.012, "ball": k * 0.04 * sin(t * 1.3)})
	end_(S); return true
static func office_boss_read(ctx, a: Dictionary):
	var S = begin(ctx, a, "npc_boss__bodyN", false)
	if S == null: return false
	var t = S.at; var k = S.env; var q = loopt(t, 4.6); var flip = bump(q, 3.6, 3.85, 4.2); var scan = jm(q / 3.6, 1)
	boss_draw(S, {"glove": k * (1.25 + 0.04 * sin(t * 1.1) - flip * 0.12), "shUp": k * 0.012, "head": S.fs * k * (0.13 + scan * 0.05), "lean": S.fs * k * 0.02,
		"gfn": func(L):
			var p = L.call(BOSS.HAND[0], BOSS.HAND[1]); prop(ctx, "op_paper_fly", p[0] + S.fs * S.W * 0.03, p[1] - S.H * 0.05, S.H * 0.22 * k + 0.0001, -S.fs * 0.15 - 1.25 * k, 0.5, 0.6, (1 - flip * 1.6) * (1.0 if S.fs > 0 else -1.0), 1)})
	end_(S); return true
static func office_boss_phone(ctx, a: Dictionary):
	var S = begin(ctx, a, "npc_boss__bodyN", false)
	if S == null: return false
	var t = S.at; var k = S.env; var q = loopt(t, 7); var rant = bump(q, 4.6, 5.0, 6.2); var nod = maxf(0, sin(t * 2.2)) * (1 - rant)
	boss_draw(S, {"glove": k * (2.55 - rant * 0.25 + sin(t * 9) * 0.03 * rant), "shUp": k * 0.04, "head": S.fs * k * (-0.10 + nod * 0.05 - rant * 0.04), "lean": -S.fs * k * rant * 0.02, "ball": k * (rant * 0.12 * sin(t * 6)),
		"gfn": func(L):
			var p = L.call(BOSS.HAND[0], BOSS.HAND[1]); prop(ctx, "afu__phone", p[0] + S.fs * S.W * 0.01, p[1] - S.H * 0.035, S.H * 0.12 * k + 0.0001, -S.fs * 0.5 - 2.55 * k, 0.5, 0.6, -S.fs, 1)})
	end_(S); return true
static func office_boss_pack(ctx, a: Dictionary):
	var S = begin(ctx, a, "npc_boss__bodyN", false)
	if S == null: return false
	var t = S.at; var k = S.env; var sweep = sin(t * 4.5) * bump(t, 0.3, 0.6, 2.0); var watch = kf([[0, 0], [2.1, 0], [2.5, 1], [3.5, 1]], t)
	boss_draw(S, {"glove": k * (lerp_(-0.45 + sweep * 0.25, 1.45, watch)), "shUp": k * watch * 0.01, "ball": k * 0.22, "elUp": k * 0.01, "head": S.fs * k * (0.12 + watch * 0.05), "lean": S.fs * k * 0.05 * (1 - watch)})
	end_(S); return true
static func guard_dozeL(ctx, a: Dictionary):
	var S = begin(ctx, a, "npc_guard__bodyN", false)
	if S == null: return false
	var t = S.at; var k = S.env; var q = loopt(t, 8); var br = sin(t * 1.5)
	var nod = kf([[0, 0.25], [1.6, 0.85], [5.9, 1], [6.15, 1.12], [6.3, -0.2], [6.8, 0.1], [8, 0.25]], q) + br * 0.04; var jerk = bump(q, 6.15, 6.3, 6.8)
	ctx.save(); ctx.scale(1, 1 - 0.025 * maxf(0, nod) * k + 0.006 * br * k)
	guard_draw(S, {"head": S.fs * k * nod * 0.45, "lean": S.fs * k * nod * 0.05, "dy": k * (maxf(0, nod) * S.H * 0.012 - jerk * S.H * 0.02), "fl": -k * maxf(0, nod) * 0.32})
	ctx.restore()
	var h = S.P(0.3, 0.12); zzz(S, h[0] - S.fs * S.W * 0.15, h[1], S.H * 0.09, t, (1 - bump(q, 6.0, 6.3, 7.2)) * k)
	var mp = S.P(0.5, 0.05); marks(ctx, mp[0], mp[1] - S.H * 0.03, S.H * 0.09, jerk * k)
	end_(S); return true
static func office_ken_nap(ctx, a: Dictionary):
	var S = begin(ctx, a, "npc_ken__bodyF", false, true)
	if S == null: return false
	var t = S.at; var k = S.env; var br = sin(t * 1.25)
	ctx.save(); ctx.scale(1, 1 + 0.012 * br * k)
	ken_draw(S, {"lean": S.fs * k * (0.42 + 0.012 * br), "head": S.fs * k * (0.75 + 0.02 * br), "ang": -k * 0.55})
	ctx.restore()
	var h = S.P(0.45, 0.40); zzz(S, h[0] + S.fs * S.W * 0.55, h[1] - S.H * 0.05, S.H * 0.1, t * 0.7, k)
	end_(S); return true
# 小晴／其他網格角色：網格身體直接擺姿勢
static func mesh_body(S: St, rig: String, key: String, add: Dictionary) -> void:
	var z = S.z.duplicate(); z["x"] = 0.0; z["y"] = 0.0; z["sx"] = 1.0; z["sy"] = 1.0; z["rot"] = 0.0; z["legF"] = 0.0; z["legB"] = 0.0
	for k in add: z[k] = z0(z.get(k)) + J.num(add[k])
	J.cl(J.gp(_ma(), "drawBody"), null, [S.ctx, rig, key, S.H, z])
static func office_it_notes(ctx, a: Dictionary):
	var S = begin(ctx, a, "npc_it", true)
	if S == null: return false
	var t = S.at; var k = S.env; var q = loopt(t, 6); var look = bump(q, 4.2, 4.6, 5.5); var tap = sin(t * 14) * (1 - look)
	mesh_body(S, "npc_it", "npc_it", {"head": S.fs * k * (0.26 - look * 0.34), "body": S.fs * k * 0.04 * (1 - look), "armF": S.fs * k * (0.10 + tap * 0.03), "armB": S.fs * k * (0.08 + tap * 0.02)})
	end_(S); return true
static func office_it_pack(ctx, a: Dictionary):
	var S = begin(ctx, a, "npc_it", true)
	if S == null: return false
	var t = S.at; var k = S.env; var bend = bump(t, 0.2, 0.7, 2.2); var sw = sin(t * 7) * bend
	mesh_body(S, "npc_it", "npc_it", {"head": S.fs * k * (bend * 0.22 - bump(t, 2.3, 2.8, 3.5) * 0.12), "body": S.fs * k * bend * 0.12, "armF": -S.fs * k * (0.25 * bend + sw * 0.06), "armB": S.fs * k * (0.18 * bend + sw * 0.05)})
	end_(S); return true
static func office_auntie_pack(ctx, a: Dictionary):
	var S = begin(ctx, a, "npc_auntie__bodyH", false)
	if S == null: return false
	var t = S.at; var k = S.env; var q = ss(k); var bend = bump(t, 0.2, 0.7, 1.4) + bump(t, 1.3, 1.8, 2.5); var rub = bump(t, 2.5, 2.8, 3.5)
	auntie_draw(S, {"th": au_th(S, PI / 2 + S.fs * 0.12) * q, "fx": q * S.fs * 0.05, "fy": q * 0.04, "floor": -S.H * 0.06, "reach": q, "lean": S.fs * k * (0.16 * bend - 0.05 * rub), "head": S.fs * k * (0.22 * bend - 0.08 * rub), "hipA": k * rub * sin(t * 16) * 0.12})
	end_(S); return true

# ======================================================================
# 冥街夜市・店主
# ======================================================================
# 小紙（紙紮鋪）：手拎一張紙，摺一摺（紙翻轉、變窄），拍平，再摺
static func paper_fold(ctx, a: Dictionary):
	var S = begin(ctx, a, "xiaozhi__body", false)
	if S == null: return false
	var t = jm(S.at, 2.4); var k = S.env; var up = k * kf([[0, 0.6], [0.4, 1], [1.6, 1], [2.0, 0.75], [2.4, 0.6]], t); var fold = seg(t, 0.5, 0.9); var pat = bump(t, 1.2, 1.3, 1.45) + bump(t, 1.5, 1.6, 1.75)
	var pv = [0.315, 0.535]; var at = S.P(pv[0], pv[1])
	body(S, "xiaozhi", "xiaozhi__body", {"head": S.fs * k * (0.08 + 0.03 * pat)})
	piece(S, "xiaozhi__arm", pv, [at[0], at[1] - pat * S.H * 0.01], -S.fs * (up * 0.55 + pat * 0.05) * 1, 1, func(L):
		var h = L.call(0.16, 0.71); var w = S.H * 0.26 * k
		var sx = cos(fold * PI) * (1.0 if jm(S.at, 4.8) < 2.4 else -1.0); var sy = 1 - 0.35 * fold
		prop(ctx, "furnace__paper", h[0], h[1] - S.H * 0.02, w, S.fs * 0.5, 0.5, 0.6, 0.08 if absf(sx) < 0.08 else sx, sy))
	end_(S); return true
# 小紙：攬住一疊紙紮，向下篤兩下對齊，點頭
static func paper_arrange(ctx, a: Dictionary):
	var S = begin(ctx, a, "xiaozhi__body", false)
	if S == null: return false
	var t = jm(S.at, 2.2); var k = S.env; var tap = bump(t, 0.3, 0.42, 0.55) + bump(t, 0.7, 0.82, 0.95); var nod = bump(t, 1.3, 1.5, 1.8)
	var pv = [0.315, 0.535]; var at = S.P(pv[0], pv[1])
	body(S, "xiaozhi", "xiaozhi__body", {"head": S.fs * k * (0.06 + 0.1 * nod)})
	var st = S.P(0.18, 0.75); prop(ctx, "furnace__stack", st[0], st[1] + tap * S.H * 0.03 * k - S.H * 0.04 * k, S.H * 0.36 * k + 0.001, 0, 0.5, 0.5)
	piece(S, "xiaozhi__arm", pv, [at[0], at[1] + tap * S.H * 0.03 * k], -S.fs * k * 0.1)
	end_(S); return true
# 小鬼（講價攤）：爪喺攤面畫圈抹枱
static func haggle_polish(ctx, a: Dictionary):
	var S = begin(ctx, a, "xiaogui__body", true)
	if S == null: return false
	var t = S.at; var k = S.env; var an = t * 7; var pv = [0.61, 0.585]; var at = S.P(pv[0], pv[1])
	body(S, "xiaogui", "xiaogui__body", {"head": S.fs * k * (0.1 + sin(an) * 0.02), "tail1": sin(an) * 0.05 * k})
	piece(S, "xiaogui__arm", pv, [at[0] + cos(an) * S.H * 0.03 * k, at[1] + (0.04 + sin(an) * 0.015) * S.H * k], S.fs * k * (0.25 + sin(an) * 0.06), 1, func(L):
		var p = L.call(0.93, 0.58)
		if sin(an) > 0.6: sparkle(ctx, p[0] + S.H * 0.05, p[1] + S.H * 0.01, S.H * 0.035, (sin(an) - 0.6) * 2.5 * k))
	end_(S); return true
# 小鬼：拎張冥鈔舉到眼前瞇眼睇
static func haggle_squint(ctx, a: Dictionary):
	var S = begin(ctx, a, "xiaogui__body", true)
	if S == null: return false
	var t = S.at; var k = S.env; var up = k * kf([[0, 0], [0.5, 1], [2.6, 1], [3.0, 0]], t); var look = sin(t * 2.2) * seg(t, 0.8, 1.0) * (1 - seg(t, 2.3, 2.6))
	var pv = [0.61, 0.585]; var at = S.P(pv[0], pv[1])
	body(S, "xiaogui", "xiaogui__body", {"head": S.fs * (up * 0.14 + look * 0.05)})
	piece(S, "xiaogui__arm", pv, [at[0] + S.fs * up * S.W * 0.06, at[1] - up * S.H * 0.05], -S.fs * up * 0.45, 1, func(L):
		var p = L.call(0.95, 0.55); prop(ctx, "furnace__paper", p[0] + S.fs * S.W * 0.06, p[1] - S.H * 0.03, S.H * 0.22 * up + 0.001, S.fs * (0.3 + look * 0.1), 0.5, 0.7))
	var h = S.P(0.6, 0.15); text(S, h[0] + S.fs * S.W * 0.2, h[1] - S.H * 0.08, "嗯……", S.H * 0.11, bump(t, 1.0, 1.3, 2.6) * k)
	end_(S); return true
# 白無常（冥幣兌換）：一疊冥鈔扇開嚟數，一張一張翻；舔一舔手指
const NUMS := ["一", "二", "三", "四", "五", "六"]
static func _wpn(S: St, ctx, k: float) -> void:
	if ok("baiwu__wpn"):
		var g = S.P(0.12, 1.0); prop(ctx, "baiwu__wpn", g[0] + S.fs * S.W * 0.05, g[1], S.H * 0.42, -S.fs * 0.12 * k, 0.5, 1)
static func exch_count(ctx, a: Dictionary):
	var S = begin(ctx, a, "baiwu__body", false)
	if S == null: return false
	var t = S.at; var k = S.env; var pv = [0.32, 0.655]; var at = S.P(pv[0], pv[1])
	var lick = bump(jm(t, 3.6), 2.4, 2.65, 3.0); var flipN = int(floor(t * 2.6)); var fq = jm(t * 2.6, 1)
	_wpn(S, ctx, k)
	body(S, "baiwu", "baiwu__body", {"head": S.fs * k * (0.1 - lick * 0.12 + 0.02 * sin(t * 5.2))})
	piece(S, "baiwu__arm", pv, [at[0] + S.fs * (0.03 + lick * 0.03) * S.W * k, at[1] - (0.01 + lick * 0.13) * S.H * k], -S.fs * k * (0.12 + lick * 0.55 + 0.04 * sin(fq * PI)), 1, func(L):
		var h = L.call(0.27, 0.62)
		if lick < 0.5:
			for i in 5:   # 扇開嘅冥鈔，最上面嗰張翻過去
				var top = i == 4; var an = (i - 2) * 0.16 + (-0.32 * ss(fq) if top else 0.0)
				prop(ctx, "furnace__paper", h[0], h[1], S.H * 0.22 * k * (1 - lick) + 0.001, S.fs * 0.15 + an, 0.5, 0.9))
	if k > 0.5:
		var tp = S.P(0.5, 0.1); text(S, tp[0] + S.fs * S.W * 0.4, tp[1], NUMS[flipN % 6], S.H * 0.07, (1 - fq) * (1 - lick) * (k - 0.5) * 2, {"col": "#ffe08a"})
	end_(S); return true
static func exch_stamp(ctx, a: Dictionary):
	var S = begin(ctx, a, "baiwu__body", false)
	if S == null: return false
	var t = S.at; var k = S.env; var pv = [0.32, 0.655]; var at = S.P(pv[0], pv[1])
	var lift = kf([[0, 0], [0.5, 1], [0.7, 1.1], [0.8, -0.2], [1.0, 0], [1.3, 0.8], [1.45, -0.2], [1.6, 0], [2.0, 0]], t)
	_wpn(S, ctx, k)
	body(S, "baiwu", "baiwu__body", {"head": S.fs * k * (0.14 - lift * 0.04)})
	var n = S.P(0.18, 0.80); prop(ctx, "furnace__paper", n[0], n[1], S.H * 0.24 * k + 0.001, 0.1, 0.5, 0.5)
	if t > 0.8:
		ctx.save(); ctx.globalAlpha *= k * 0.85; ctx.translate(n[0], n[1]); ctx.rotate(-0.2); ctx.strokeStyle = "#c8202a"; ctx.lineWidth = S.H * 0.008; ctx.strokeRect(-S.H * 0.035, -S.H * 0.035, S.H * 0.07, S.H * 0.07)
		ctx.font = "900 %spx %s" % [J.str(S.H * 0.05), FONT]; ctx.fillStyle = "#c8202a"; ctx.textAlign = "center"; ctx.textBaseline = "middle"
		if S.flip: ctx.scale(-1, 1)
		ctx.fillText("冥", 0, S.H * 0.002); ctx.restore()
	piece(S, "baiwu__arm", pv, [at[0] - S.fs * S.W * 0.02 * k, at[1] - lift * S.H * 0.06 * k + S.H * 0.03 * k], -S.fs * k * (0.15 + lift * 0.25))
	marks(ctx, n[0], n[1] - S.H * 0.05, S.H * 0.06, (bump(t, 0.78, 0.82, 1.0) + bump(t, 1.43, 1.47, 1.65)) * k)
	end_(S); return true
# 餓鬼王（宵夜檔）：漏勺喺鍋入面攪、撈起一勺麵、偷食一啖
# o.prop = { potDX, potDY }：鍋口中心相對腳底嘅位置（世界座標）
static func egui_pot(S: St) -> Array:
	var p = S.o.get("prop") if J.t(S.o.get("prop")) else {}
	if J.gp(p, "potDX") == null: return [S.fs * S.H * 0.42, -S.H * 0.47]
	return [(-1.0 if S.flip else 1.0) * J.num(J.gp(p, "potDX")) / J.num(S.z.sx), (J.num(J.gp(p, "potDY")) - J.num(S.z.y) * S.H) / J.num(S.z.sy)]
static func noodles(ctx, x: float, y: float, s: float, k: float, t: float) -> void:   # 掛喺漏勺上面嘅麵
	if k <= 0: return
	ctx.save(); ctx.globalAlpha *= cl(k)
	for i in 6:
		var ox = (i - 2.5) * s * 0.07; var ln = s * (0.22 + 0.16 * rnd(i + 3)); var sw = sin(t * 6 + i) * s * 0.04
		crayon(ctx, [[x + ox, y], [x + ox + sw * 0.5, y + ln * 0.5], [x + ox + sw, y + ln]], maxf(1.2, s * 0.03), "#f4d77a", "rgba(110,70,20,.55)")
	ctx.restore()
# 漏勺（由背景切出嚟嘅原圖）：柄上端揸喺手，網向下。回傳網中心
static func strainer(S: St, hx: float, hy: float, ang: float, nood: float, t: float, clipY):
	var ctx = S.ctx
	if not ok("street_strainer"): return null
	var im = _spr("street_strainer"); var h = S.H * 0.34; var w = h * J.num(J.gp(im, "naturalWidth")) / J.num(J.gp(im, "naturalHeight"))
	ctx.save()
	if clipY != null: ctx.beginPath(); ctx.rect(-S.H * 5, -S.H * 5, S.H * 10, J.num(clipY) + S.H * 5); ctx.clip()
	ctx.translate(hx, hy); ctx.rotate(ang)
	ctx.drawImage(im, -w / 2, -h * 0.1, w, h)
	var net = [0.0, h * 0.68]
	if nood > 0: noodles(ctx, net[0], net[1] + h * 0.12, h, nood, t)
	var c = cos(ang); var s = sin(ang); ctx.restore()
	return {"x": hx + net[0] * c - net[1] * s, "y": hy + net[0] * s + net[1] * c}
static func egui_cook(S: St, mode: String) -> void:
	var ctx = S.ctx; var t = S.at; var k = S.env; var pot = egui_pot(S); var pv = [0.12, 0.5]; var at = S.P(pv[0], pv[1]); var G0 = [0.10, 0.30]; var g0 = S.P(G0[0], G0[1])
	var tx = pot[0]; var ty = pot[1] - S.H * 0.31; var sAng = 0.0; var nood = 0.0; var headA = S.fs * 0.12; var tt = ""; var ta = 0.0; var clip = true; var rot = 0.0
	if mode == "stir":
		var an = t * 4.2; tx += cos(an) * S.H * 0.035; ty += S.H * 0.05 + sin(an) * S.H * 0.012; sAng = cos(an) * 0.15; headA = S.fs * (0.14 + sin(an) * 0.02); rot = sin(an) * 0.04
	if mode == "ladle":
		var q = jm(t, 3.0); var lift = kf([[0, 0], [0.5, 0.15], [0.9, -0.1], [1.4, 1], [2.4, 1], [3.0, 0]], q)
		ty += S.H * (0.06 - lift * 0.16); sAng = -S.fs * lift * 0.12; nood = seg(q, 1.0, 1.4) * (1 - seg(q, 2.5, 2.9)); headA = S.fs * (0.12 - lift * 0.06); rot = -S.fs * lift * 0.1
	if mode == "taste":
		var up = kf([[0, 0], [0.5, 0.45], [1.0, 1], [2.2, 1], [2.6, 0.3], [3.3, 0]], t); var m = S.P(0.47, 0.34); var chew = sin(t * 14) * seg(t, 1.0, 1.1) * (1 - seg(t, 1.8, 1.9)); var look = sin((t - 1.9) * 8) * bump(t, 1.9, 2.1, 2.7)
		tx = lerp_(tx, m[0] + S.fs * S.W * 0.1, up); ty = lerp_(ty + S.H * 0.05, m[1] - S.H * 0.22, up); sAng = -S.fs * up * 0.6; nood = (1 - seg(t, 1.0, 1.15)) * minf(1, t / 0.3 + 0.0001)
		headA = S.fs * (0.1 - up * 0.1) + chew * 0.04 + look * 0.18; tt = "嗯～" if t < 1.9 else "……"; ta = bump(t, 1.1, 1.3, 2.0) + bump(t, 2.0, 2.2, 2.7) * 0.8; clip = up < 0.2; rot = -S.fs * up * 0.25
	var dx = (tx - g0[0]) * k; var dy = (ty - g0[1]) * k; var ang = rot * k
	body(S, "eguiking", "eguiking__body", {"head": headA * k})
	# 漏勺先畫（俾手揸住），鍋口以下唔畫
	var hp = rotP(S, pv[0], pv[1], [at[0] + dx, at[1] + dy], ang, G0[0], G0[1])
	if k > 0.02:
		ctx.save(); ctx.globalAlpha *= ss(k * 1.5)
		var net = strainer(S, hp[0], hp[1], sAng * k + ang, nood * k, t, pot[1] if clip else null)
		if net != null and nood > 0: steam_curl(ctx, net.x, net.y - S.H * 0.02, S.H * 0.22, jm(t * 0.8, 1), 1.7, nood * k); drop(ctx, net.x, net.y + S.H * 0.06, S.H * 0.008, jm(t * 1.5, 1), S.H * 0.1)
		if mode == "stir" and k > 0.5: steam_curl(ctx, pot[0] + sin(t) * S.H * 0.04, pot[1] - S.H * 0.03, S.H * 0.3, jm(t * 0.5, 1), 4.4, 0.6)
		ctx.restore()
	piece(S, "eguiking__hand", pv, [at[0] + dx, at[1] + dy], ang)
	if ta > 0:
		var h = S.P(0.5, 0.05); text(S, h[0] - S.fs * S.W * 0.35, h[1], tt, S.H * 0.1, ta * k)
static func food(ctx, a: Dictionary, mode: String):
	var S = begin(ctx, a, "eguiking__body", false)
	if S == null: return false
	egui_cook(S, mode); end_(S); return true

# 店主打招呼：得閒嗰隻手揮一揮／鞠躬
const GREET := {
	"xiaozhi": {"key": "xiaozhi__body", "arm": "xiaozhi__arm", "pv": [0.315, 0.535], "nr": false, "wave": 1},
	"xiaogui": {"key": "xiaogui__body", "arm": "xiaogui__arm", "pv": [0.61, 0.585], "nr": true, "wave": 0},
	"baiwu": {"key": "baiwu__body", "arm": "baiwu__arm", "pv": [0.32, 0.655], "nr": false, "wave": 0, "staff": 1},
	"eguiking": {"key": "eguiking__body", "arm": "eguiking__arm", "pv": [0.12, 0.5], "nr": false, "wave": 1},
}
static func greet(ctx, a: Dictionary):
	var type = J.str(a.type)
	if not GREET.has(type): return false
	var G = GREET[type]
	var S = begin(ctx, a, G.key, G.nr)
	if S == null: return false
	var t = S.at; var k = S.env; var c = S.ctx
	if G.wave:
		var up = k * kf([[0, 0], [0.35, 1], [1.4, 1], [1.7, 0.2]], t); var w = sin(t * 11) * seg(t, 0.3, 0.4) * (1 - seg(t, 1.3, 1.5))
		body(S, type, G.key, {"head": S.fs * k * (-0.06 + 0.03 * w)})
		var at = S.P(G.pv[0], G.pv[1]); piece(S, G.arm, G.pv, [at[0], at[1] - up * S.H * 0.04], (S.fs * up * 0.4 if type == "eguiking" else -S.fs * up * 1.9) + w * 0.22 * up)
	else:   # 鞠躬（白無常：哭喪棒跟住手；小鬼：唔情唔願點個頭）
		var deep = 0.38 if type == "baiwu" else 0.16; var b = k * kf([[0, 0], [0.4, 1], [0.9, 1], [1.4, 0]], t)
		c.save(); lean(S, S.fs * b * deep, 0.25)
		body(S, type, G.key, {"head": S.fs * b * 0.1})
		var at = S.P(G.pv[0], G.pv[1])
		var LB = _g("Limbs")
		if G.get("staff") and LB != null and J.t(J.mc(LB, "has", ["baiwu"])): c.restore(); c.save(); lean(S, S.fs * b * deep, 0.25)
		var fn = null
		if G.get("staff"):
			fn = func(L):
				var h = L.call(0.275, 0.625); var LD = _g("LIMBS_DATA"); var Wp = J.gp(J.gp(LD, "weapons"), J.gp(J.gp(J.gp(LD, "chars"), "baiwu"), "weapon"))
				if J.t(Wp) and ok(J.str(J.gp(Wp, "img"))):
					var im = _spr(J.str(J.gp(Wp, "img"))); var ww = J.num(J.gp(Wp, "w")) * S.H; var wh = J.num(J.gp(Wp, "h")) * S.H; var gr = J.gp(Wp, "grip")
					c.save(); c.translate(h[0], h[1]); c.drawImage(im, -J.num(gr[0]) * ww, -J.num(gr[1]) * wh, ww, wh); c.restore()
		piece(S, G.arm, G.pv, at, 0, 1, fn)
		c.restore()
	end_(S); return true

# ======================================================================
# 冥街夜市・閒鬼：拎住道具行（燈籠、外賣袋、講電話）、撞到人互相道歉、停喺攤前睇
# ======================================================================
const WALK := {
	"youhun": {"key": "youhun__body", "arm": "youhun__arm", "pv": [0.245, 0.47], "tip": [0.04, 0.55], "nr": false},
	"egui": {"key": "egui__body", "arm": "egui__arm", "pv": [0.56, 0.44], "tip": [0.74, 0.27], "nr": true},
	"zombie": {"key": "zombie__body", "arm": "zombie__arm", "pv": [0.27, 0.56], "tip": [0.06, 0.57], "nr": false},
	"shuigui": {"key": "shuigui__body", "arm": "shuigui__arm", "pv": [0.72, 0.53], "tip": [0.92, 0.53], "nr": true},
}
# 吊住嘅嘢：繩由手吊落嚟，跟住行路擺（彈弓感：比手慢半拍）
static func hang(S: St, key: String, x: float, y: float, w: float, ln: float, t: float, walk: bool) -> void:
	var ctx = S.ctx; var sw = (sin(t * 7 - 0.9) * 0.22 if walk else sin(t * 1.7) * 0.06) + (-S.fs * 0.12 if walk else 0.0)
	ctx.save(); ctx.translate(x, y); ctx.rotate(sw)
	ctx.strokeStyle = "rgba(40,28,24,.9)"; ctx.lineWidth = maxf(1, S.H * 0.008); ctx.beginPath(); ctx.moveTo(0, 0); ctx.lineTo(0, ln); ctx.stroke()
	prop(ctx, key, 0, ln, w, -sw * 0.4, 0.5, 0.04); ctx.restore()
static func walker(S: St, G: Dictionary, P: Dictionary) -> void:
	var ctx = S.ctx; var t = S.t; var pr = S.o.get("prop") if J.t(S.o.get("prop")) else {}; var k = S.env
	ctx.save(); lean(S, z0(P.get("lean")), 0.3, z0(P.get("dx")), 0)
	var ad = {"head": z0(P.get("head"))}
	if G.get("still"): ad["head"] = 0.0
	body(S, J.str(S.a.type), G.key, ad)
	var at = S.P(G.pv[0], G.pv[1]); var kind = J.str(J.gp(pr, "kind")) if J.gp(pr, "kind") != null else ""
	var ang = z0(P.get("arm"))
	if kind == "phone": ang += -S.fs * 0.15 * k
	if kind == "lanternW" or kind == "lanternR": ang += (sin(t * 7) * 0.08 if S.walk else 0.0) - S.fs * 0.1 * k
	piece(S, G.arm, G.pv, at, ang, 1, func(L):
		var h = L.call(G.tip[0], G.tip[1])
		if kind == "lanternW" or kind == "lanternR": hang(S, "street_lanternW" if kind == "lanternW" else "street_lanternR", h[0], h[1], S.H * 0.24 * (J.num(J.gp(pr, "big")) if J.t(J.gp(pr, "big")) else 1.0), S.H * 0.06, t, S.walk)
		if kind == "bag": hang(S, "bun__basket", h[0], h[1], S.H * 0.3, S.H * 0.03, t, S.walk)
		if kind == "phone": prop(ctx, "afu__phone", h[0], h[1] - S.H * 0.03, S.H * 0.13, S.fs * 0.2, 0.5, 0.6, -S.fs, 1))
	ctx.restore()
	if kind == "phone":   # 講電話：一句一句冒出嚟
		var sd = z0(J.gp(pr, "seed")); var q = jm(t * 0.5 + sd, 1); var lines = J.iter(J.gp(pr, "lines")) if J.t(J.gp(pr, "lines")) else ["喂？", "收到收到", "在路上了"]
		var h = S.P(0.5, 0.0)
		text(S, h[0] - S.fs * S.W * 0.1, h[1] - S.H * 0.05, J.str(lines[int(floor(t * 0.5 + sd)) % lines.size()]), S.H * 0.13, bump(q, 0.05, 0.2, 0.7) * k * 0.95, {"col": "#e8fff0", "out": "#14281e"})
static func town_walk(ctx, a: Dictionary):
	var type = J.str(a.type)
	if not WALK.has(type): return false
	var G = WALK[type]; var S = begin(ctx, a, G.key, G.nr)
	if S == null: return false
	S.env = maxf(S.env, 0.999)   # 拎住道具：一直拎住（唔淡出）
	walker(S, G, {"head": 0.0}); end_(S); return true
static func town_bump(ctx, a: Dictionary):
	var type = J.str(a.type)
	if not WALK.has(type): return false
	var G = WALK[type]; var S = begin(ctx, a, G.key, G.nr)
	if S == null: return false
	var t = S.at; var rec = kf([[0, 0], [0.12, 1], [0.45, 0.6], [0.6, 0]], t); var bow = bump(t, 0.6, 0.8, 1.05) + bump(t, 1.05, 1.25, 1.5)
	S.env = 1.0
	walker(S, G, {"lean": -S.fs * rec * 0.2 + S.fs * bow * 0.3, "dx": -S.fs * rec * S.H * 0.06, "head": S.fs * bow * 0.15})
	var mp = S.P(0.5, 0.02); marks(ctx, mp[0], mp[1] - S.H * 0.04, S.H * 0.12, bump(t, 0.08, 0.15, 0.55))
	var pr = a.o.get("prop"); var tt = J.str(J.gp(pr, "sorry")) if J.t(pr) and J.t(J.gp(pr, "sorry")) else "不好意思"
	var tp = S.P(0.5, 0); text(S, tp[0], tp[1] - S.H * 0.2, tt, S.H * 0.13, bump(t, 0.65, 0.8, 1.7), {"col": "#fff6dc"})
	end_(S); return true
static func town_look(ctx, a: Dictionary):
	var type = J.str(a.type)
	if not WALK.has(type): return false
	var G = WALK[type]; var S = begin(ctx, a, G.key, G.nr)
	if S == null: return false
	var t = S.at; var k = S.env; var scan = sin(t * 1.6); var inq = bump(t, 1.6, 1.9, 2.8)
	walker(S, G, {"lean": S.fs * k * (0.06 + inq * 0.05), "head": S.fs * k * (0.08 + scan * 0.06) - k * inq * 0.08, "arm": -S.fs * k * (0.3 + 0.05 * sin(t * 3))})
	var tp = S.P(0.5, 0); text(S, tp[0] + S.fs * S.W * 0.2, tp[1] - S.H * 0.08, "哦？", S.H * 0.13, inq * k)
	end_(S); return true

# ======================================================================
# 排程：每個人一張動作清單（權重、做幾耐、冷卻），隨機揀，唔連續做同一樣
# ======================================================================
# [動作, 權重, [最短, 最長]秒, 冷卻秒, 'walk' = 行路時都做得]
const LIST := {
	"npc_ken": [["town_ken_scroll", 5, [4, 7], 0], ["town_ken_yawn", 1.3, [3.3, 3.3], 9], ["town_ken_rub", 1.1, [2.9, 2.9], 8], ["town_ken_sigh", 1.1, [3.1, 3.1], 8]],
	"npc_boss": [["town_boss_admire", 2.5, [2.5, 4.5], 0], ["town_boss_polish", 2, [3.7, 3.7], 6], ["town_boss_watch", 1.5, [2.9, 2.9], 8], ["town_boss_call", 1.2, [4.0, 4.0], 12]],
	"npc_guard": [["town_guard_patrol", 3, [3, 5], 0, "walk"], ["town_guard_sip", 1.5, [3.3, 3.3], 8], ["town_guard_doze", 1.0, [4.3, 4.3], 14]],
	"npc_auntie": [["town_auntie_mop", 2, [2.2, 3.5], 0, "walk"], ["town_auntie_wring", 1.5, [2.3, 2.3], 6], ["town_auntie_grumble", 1.4, [2.3, 2.3], 7]],
	"xiaozhi": [["town_paper_fold", 3, [4.8, 7.2], 0], ["town_paper_arrange", 2, [4.4, 6.6], 4]],
	"xiaogui": [["town_haggle_polish", 3, [3, 5], 0], ["town_haggle_squint", 2, [3.1, 3.1], 6]],
	"baiwu": [["town_exch_count", 3, [3.6, 7.2], 0], ["town_exch_stamp", 1.5, [2.1, 2.1], 5]],
	"eguiking": [["town_food_stir", 3, [3, 5], 0], ["town_food_ladle", 2, [3.0, 6.0], 3], ["town_food_taste", 1.3, [3.3, 3.3], 10]],
}
static func _can(e: Array, walk: bool) -> bool: return not walk or (e.size() > 4 and e[4] == "walk")
# st：角色身上嘅排程狀態 { act, at, dur, w, cd:{} }；eligible：而家做唔做得（false = 慢慢放返原圖姿勢）；walk：行緊路
static func tick(st, id: String, dt: float, eligible: bool, walk: bool, force = null) -> Dictionary:
	var L: Array = LIST.get(id, [])
	if not (st is Dictionary) or not J.t(st): st = {"act": null, "at": 0.0, "dur": 0.0, "w": 0.0, "cd": {}}
	if not J.t(force) and J.t(st.get("forced")): st["forced"] = false; st["dur"] = minf(J.num(st.dur), J.num(st.at) + 0.35)   # 唔再強制：0.35 秒淡出，再揀返平日動作
	for k in st.cd: st.cd[k] = J.num(st.cd[k]) - dt
	if J.t(force) and (J.str(st.get("act")) != J.str(force[0]) or J.num(st.at) > J.num(st.dur)): st["act"] = force[0]; st["at"] = 0.0; st["dur"] = force[1]; st["forced"] = true
	st["at"] = J.num(st.at) + dt
	var cur = null
	for e in L: if e[0] == J.str(st.get("act")) and st.get("act") != null: cur = e; break
	var want = eligible and ((_can(cur, walk)) if (J.t(st.get("act")) and cur != null) else true)
	st["w"] = cl(J.num(st.w) + (1.0 if want else -1.0) * dt / 0.25)
	if eligible and (not J.t(st.get("act")) or J.num(st.at) >= J.num(st.dur) or (cur != null and not _can(cur, walk) and J.num(st.w) <= 0)):
		var ncan = 0
		for e in L: if _can(e, walk): ncan += 1
		var opts = []
		for e in L:
			if _can(e, walk) and z0(st.cd.get(e[0])) <= 0 and (e[0] != J.str(st.get("act")) or ncan == 1): opts.append(e)
		if opts.size():
			var tot = 0.0
			for e in opts: tot += float(e[1])
			var r = randf() * tot; var pick = opts[0]
			for o in opts:
				r -= float(o[1])
				if r <= 0: pick = o; break
			st["act"] = pick[0]; st["at"] = 0.0; st["dur"] = float(pick[2][0]) + randf() * (float(pick[2][1]) - float(pick[2][0])); st.cd[pick[0]] = float(pick[3]) + J.num(st.dur)
	if not eligible and J.num(st.w) <= 0: st["act"] = null
	return st
# 畫嗰陣要加嘅參數（冇做緊就回傳空嘅）
static func opts(st) -> Dictionary:
	if st is Dictionary and J.t(st.get("act")) and J.num(st.get("w")) > 0: return {"act": st.act, "at": st.at, "adur": st.dur, "aw": ss(J.num(st.w))}
	return {}

# ---------- 回陽間：scare 用 ----------
const ACT := {"npc_boss": {"present": "office_boss_present", "read": "office_boss_read", "call": "office_boss_phone", "pack": "office_boss_pack"}, "npc_guard": {"doze": "town_guard_dozeL"},
	"npc_ken": {"brk_nap": "office_ken_nap"}, "npc_it": {"notes": "office_it_notes", "pack": "office_it_pack"}, "npc_auntie": {"pack": "office_auntie_pack"}}
static func npc_tick(n: Dictionary, dt: float, _scare = null) -> void:
	var d = n.d; var rx = n.rx if J.t(n.get("rx")) and J.num(J.gp(n.rx, "t")) >= 0 else null
	var rk = J.str(J.gp(rx, "k")) if rx != null else ""
	var calm = not J.t(n.get("fleeing")) and not J.t(n.get("gone")) and n.get("fear") != null and J.num(n.fear) < 25 and (rx == null or rk == "numb" or rk == "sip")
	var walk = J.str(n.get("act")) == "walk"
	var spr = J.str(J.gp(d, "spr"))
	var force = ["town_guard_sip", maxf(3.3, J.num(J.gp(rx, "dur")) + 0.4)] if rx != null and rk == "sip" and spr == "npc_guard" else null
	var fa = null
	if force == null and not walk and ACT.has(spr): fa = ACT[spr].get(J.str(n.get("act")))
	if fa != null: force = [fa, 3.6 if J.str(n.get("act")) == "pack" else 1e9]   # 辦公室嘅事（開會、講電話、瞓覺……）
	n["daily"] = tick(n.get("daily"), spr, dt, calm, walk, force)
static func npc_opts(n: Dictionary) -> Dictionary:
	var o = opts(n.get("daily"))
	if J.t(o.get("act")) and J.t(n.get("bub")) and J.num(n.get("bubT")) > 0: o["quiet"] = true
	return o
static func act_anim(n: Dictionary):
	var spr = J.str(J.gp(n.d, "spr"))
	return ACT[spr].get(J.str(n.get("act"))) if ACT.has(spr) else null

# DAILY 登記（名 → 畫法）
static func _acts() -> Dictionary:
	return {
		"town_ken_scroll": ken_scroll, "town_ken_yawn": ken_yawn, "town_ken_rub": ken_rub, "town_ken_sigh": ken_sigh,
		"town_boss_polish": boss_polish, "town_boss_watch": boss_watch, "town_boss_call": boss_call, "town_boss_admire": boss_admire,
		"town_guard_patrol": guard_patrol, "town_guard_sip": guard_sip_act, "town_guard_doze": guard_doze,
		"town_auntie_mop": auntie_mop, "town_auntie_wring": auntie_wring, "town_auntie_grumble": auntie_grumble,
		"office_boss_present": office_boss_present, "office_boss_read": office_boss_read, "office_boss_phone": office_boss_phone, "office_boss_pack": office_boss_pack,
		"town_guard_dozeL": guard_dozeL, "office_ken_nap": office_ken_nap, "office_it_notes": office_it_notes, "office_it_pack": office_it_pack, "office_auntie_pack": office_auntie_pack,
		"town_paper_fold": paper_fold, "town_paper_arrange": paper_arrange, "town_haggle_polish": haggle_polish, "town_haggle_squint": haggle_squint,
		"town_exch_count": exch_count, "town_exch_stamp": exch_stamp,
		"town_food_stir": func(ctx, a): return food(ctx, a, "stir"), "town_food_ladle": func(ctx, a): return food(ctx, a, "ladle"), "town_food_taste": func(ctx, a): return food(ctx, a, "taste"),
		"town_greet": greet, "town_walk": town_walk, "town_bump": town_bump, "town_look": town_look,
	}

func run(_env) -> void:
	var DA = _g("DAILY")
	if DA is Dictionary:
		var A = _acts()
		for k in A:
			var f: Callable = A[k]
			DA[k] = func(_t, a): return f.call(J.arg(a, 0), J.arg(a, 1))
	J.G["TOWN"] = {
		"tick": func(_t, a): return tick(J.arg(a, 0), J.str(J.arg(a, 1)), J.num(J.arg(a, 2)), J.t(J.arg(a, 3)), J.t(J.arg(a, 4)), J.arg(a, 5)),
		"opts": func(_t, a): return opts(J.arg(a, 0)),
		"npcTick": func(_t, a): npc_tick(a[0], J.num(J.arg(a, 1)), J.arg(a, 2)); return null,
		"npcOpts": func(_t, a): return npc_opts(a[0]),
		"LIST": LIST.duplicate(true), "ACT": ACT.duplicate(true),
		"actAnim": func(_t, a): return act_anim(a[0]),
	}
