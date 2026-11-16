# 原生改寫：street.js（陽間街／站崗嚇人）——分段做（L3）
# 未完成、未列入 ACTIVE.txt。分段方法：run() 先載轉譯版（jsgen/street.gd）攞齊全部全局，
# 再用原生版逐段覆蓋（轉譯版入面叫 CrUI／DevFx 都係經 J.G 搵，所以覆蓋咗即刻生效），每段對照過先做下一段；
# 全部段落完成之後先拎走轉譯版、加入 ACTIVE.txt。
#   第一段：__stDC、CrUI（蠟筆面板／進度條／手寫字）  ← 而家
#   第二段：DevFx（設備色框、待機動畫、鬼影現身）
#   第三段：Street 資料、地盤／路線、離線收益
#   第四段：Turf（地盤場景、路人、Bryan 一夥、建設）
extends RefCounted

static var _tr_keep: Array = []

# ---------------- 第一段：__stDC ----------------
static func stDC(c, k, x, y, s, o) -> void:
	var nd = J.G.get("__nat_drawChar")
	if nd != null: J.cl(nd, null, [c, k, x, y, s, o if o != null else {}])
	else: J.mc(J.G.get("ART"), "drawChar", [c, k, x, y, s, o])

# ---------------- 第一段：CrUI ----------------
const CR_COL := {"bone": "217,201,168", "red": "163,48,42", "rust": "192,106,44", "violet": "138,111,176", "gold": "217,164,65"}
static func cr_hs(n: float) -> float:
	var x = sin(n * 91.7 + 13.1) * 43758.5453; return x - floor(x)
# 抖邊多邊形（seed 固定，唔會閃）
static func cr_rough(c, x: float, y: float, w: float, h: float, seed_v: float, j: float) -> void:
	var n = maxi(3, int(J.round((w + h) / 26))); var pts = []; var k = 0
	for i in n: pts.append([x + w * i / n, y, k]); k += 1
	for i in n: pts.append([x + w, y + h * i / n, k]); k += 1
	for i in n: pts.append([x + w - w * i / n, y + h, k]); k += 1
	for i in n: pts.append([x, y + h - h * i / n, k]); k += 1
	c.beginPath()
	for i in pts.size():
		var q = pts[i]; var px = q[0] + (cr_hs(seed_v + q[2]) - 0.5) * j; var py = q[1] + (cr_hs(seed_v + q[2] + 0.5) - 0.5) * j
		if i: c.lineTo(px, py)
		else: c.moveTo(px, py)
	c.closePath()
static func _o(o, k, d = null):
	var v = J.gp(o, k) if o != null else null
	return v if J.t(v) else d
# 面板：深色紙底＋斜線排線＋兩層蠟筆邊
static func cr_panel(c, x: float, y: float, w: float, h: float, o) -> void:
	var seed_v = J.num(_o(o, "seed", x * 7 + y * 3)); var ck = _o(o, "col", "bone"); var col = CR_COL[ck] if CR_COL.has(J.str(ck)) else J.gp(o, "col"); var U = J.num(_o(o, "U", 1.0))
	c.save(); cr_rough(c, x, y, w, h, seed_v, 2.2 * U); c.fillStyle = _o(o, "fill", "rgba(26,18,22,0.9)"); c.fill(); c.save(); c.clip(); c.strokeStyle = "rgba(235,215,185,0.05)"; c.lineWidth = 1
	var k = -h
	while k < w: c.beginPath(); c.moveTo(x + k, y + h); c.lineTo(x + k + h * 0.8, y); c.stroke(); k += 6 * U
	c.restore()
	c.lineJoin = "round"; c.strokeStyle = "rgba(" + J.str(col) + ",0.95)"; c.lineWidth = 2.6 * U; cr_rough(c, x, y, w, h, seed_v + 3, 2.6 * U); c.stroke()
	c.strokeStyle = "rgba(" + J.str(col) + ",0.45)"; c.lineWidth = 1.2 * U; cr_rough(c, x + 1.5 * U, y + 1.5 * U, w - 3 * U, h - 3 * U, seed_v + 9, 2.4 * U); c.stroke(); c.restore()
# 進度條：蠟筆塗色（斜紋）＋粗糙框
static func cr_bar(c, x: float, y: float, w: float, h: float, k: float, col1, col2, U0) -> void:
	var U = J.num(U0) if J.t(U0) else 1.0
	c.save(); cr_rough(c, x, y, w, h, x + y, 1.4 * U); c.fillStyle = "rgba(0,0,0,0.65)"; c.fill()
	if k > 0:
		c.save(); cr_rough(c, x, y, w * minf(1.0, k), h, x + y + 1, 1.2 * U); c.clip(); var g = c.createLinearGradient(x, 0, x + w, 0); g.addColorStop(0, col1); g.addColorStop(1, col2 if J.t(col2) else col1); c.fillStyle = g; c.fillRect(x - 2, y - 2, w + 4, h + 4)
		c.strokeStyle = "rgba(0,0,0,0.25)"; c.lineWidth = 1.2 * U
		var q = x - h
		while q < x + w: c.beginPath(); c.moveTo(q, y + h); c.lineTo(q + h, y); c.stroke(); q += 4 * U
		c.restore()
	c.strokeStyle = "rgba(217,201,168,0.7)"; c.lineWidth = 1.4 * U; cr_rough(c, x, y, w, h, x + y + 5, 1.6 * U); c.stroke(); c.restore()
# 手寫感字：黑描邊＋輕微陰影
static func cr_text(c, s, x: float, y: float, o) -> void:
	c.save(); c.font = _o(o, "font", "bold 12px sans-serif"); c.textAlign = _o(o, "align", "left"); c.lineJoin = "round"; c.lineWidth = J.num(_o(o, "lw", 3.5)); c.strokeStyle = "rgba(8,4,6,0.95)"
	c.strokeText(s, x + 1, y + 1); c.strokeText(s, x, y); c.fillStyle = _o(o, "col", "#eadbbf"); c.fillText(s, x, y); c.restore()

static func mk_crui() -> Dictionary:
	return {
		"panel": func(_t, a): cr_panel(J.arg(a, 0), J.num(J.arg(a, 1)), J.num(J.arg(a, 2)), J.num(J.arg(a, 3)), J.num(J.arg(a, 4)), J.arg(a, 5)); return null,
		"bar": func(_t, a): cr_bar(J.arg(a, 0), J.num(J.arg(a, 1)), J.num(J.arg(a, 2)), J.num(J.arg(a, 3)), J.num(J.arg(a, 4)), J.num(J.arg(a, 5)), J.arg(a, 6), J.arg(a, 7), J.arg(a, 8)); return null,
		"text": func(_t, a): cr_text(J.arg(a, 0), J.arg(a, 1), J.num(J.arg(a, 2)), J.num(J.arg(a, 3)), J.arg(a, 4)); return null,
		"rough": func(_t, a): cr_rough(J.arg(a, 0), J.num(J.arg(a, 1)), J.num(J.arg(a, 2)), J.num(J.arg(a, 3)), J.num(J.arg(a, 4)), J.num(J.arg(a, 5)), J.num(J.arg(a, 6))); return null,
		"COL": CR_COL.duplicate(),
	}

func run(_env) -> void:
	# 未完成段落：暫時用轉譯版
	var tr = (load("res://jsgen/street.gd") as GDScript).new(); _tr_keep.append(tr); tr.run(null)
	# 已完成段落：原生覆蓋
	J.G["__stDC"] = func(_t, a): stDC(J.arg(a, 0), J.arg(a, 1), J.arg(a, 2), J.arg(a, 3), J.arg(a, 4), J.arg(a, 5)); return null
	J.G["CrUI"] = mk_crui()
