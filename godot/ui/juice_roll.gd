# [juice] 數字滾動器：掛喺 Label 下面；go(to) 由舊數滾去新數
#   做法：數值用 back-ease 衝過頭再回彈；顯示時由左至右逐位「停定」，未停嘅位亂跳（老虎機感）
#   每停定一位響一下 tick（最多每 45ms 一聲）
extends Node

var fmt: Callable
var cur := 0.0
var _from := 0.0
var _to := 0.0
var _t := 0.0
var _dur := 0.0
var _tick := 0
var _stopped := 0

func go(to: float, dur := 0.55) -> void:
	if is_equal_approx(to, _to) and _dur > 0.0 and _t < _dur: return
	_from = cur; _to = to; _t = 0.0; _dur = maxf(0.05, dur); _stopped = 0
	set_process(true)

func _ready() -> void: set_process(false)

static func _back(k: float) -> float:   # easeOutBack（輕微衝過頭）
	var c1 = 1.2; var c3 = c1 + 1.0
	return 1.0 + c3 * pow(k - 1.0, 3) + c1 * pow(k - 1.0, 2)

func _process(dt: float) -> void:
	var lb = get_parent() as Label
	if lb == null: queue_free(); return
	_t += dt
	var k = clampf(_t / _dur, 0.0, 1.0)
	cur = lerpf(_from, _to, _back(k))
	var final_s: String = fmt.call(_to)
	if k >= 1.0:
		cur = _to; lb.text = final_s; set_process(false); return
	# 逐位停：第 i 個數字喺 k ≥ 0.35 + 0.6×i/n 先停；之前顯示滾緊嘅數嗰位
	var now_s: String = fmt.call(cur)
	if now_s.length() != final_s.length(): lb.text = now_s; return
	var digits = 0
	for ch in final_s: if ch >= "0" and ch <= "9": digits += 1
	var out = ""; var di = 0; var st_n = 0
	for i in final_s.length():
		var ch = final_s[i]
		if ch >= "0" and ch <= "9":
			var stop_k = 0.35 + 0.6 * float(di) / maxf(1.0, float(digits))
			if k >= stop_k: out += ch; st_n += 1
			else: out += now_s[i]
			di += 1
		else: out += ch
	if st_n > _stopped:   # 停定一位就「噠」一聲（最多每 45ms 一聲）
		_stopped = st_n
		var ms = Time.get_ticks_msec()
		if ms - _tick > 45: _tick = ms; Snd.play("tick")
	lb.text = out
