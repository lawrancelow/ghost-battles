# 聲音引擎（移植 audio.js）：全部即時合成，唔使任何音檔
# tone／noise 同網頁版一樣用指數包絡、指數滑音、biquad 濾波；殘響用 Schroeder（4 comb＋2 allpass）
# 背景音樂：底層 loop（drone＋風聲／日光燈）預先合成，旋律音符逐粒即時合成
extends Node

const SR := 22050
const SCALE := [146.83, 174.61, 196.0, 220.0, 261.63, 293.66, 349.23, 392.0, 440.0]

var on := true
var mode := ""
var _cache := {}
var _sfx: Array = []
var _mus: Array = []
var _bed: AudioStreamPlayer
var _bed2: AudioStreamPlayer
var _timers: Array = []
var _rng := RandomNumberGenerator.new()
var _gen := 0
var _bus_m := 0

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_rng.randomize()
	PF.ensure_buses()   # [settings] 音樂／音效／語音各自一條音軌
	for i in 10:
		var p = AudioStreamPlayer.new(); p.bus = PF.bus("sfx"); add_child(p); _sfx.append(p)
	for i in 10:
		var p = AudioStreamPlayer.new(); p.bus = PF.bus("music"); add_child(p); _mus.append(p)
	_bed = AudioStreamPlayer.new(); _bed.bus = PF.bus("music"); add_child(_bed)
	_bed2 = AudioStreamPlayer.new(); _bed2.bus = PF.bus("music"); add_child(_bed2)
	var v = JSRun.ls.get("gb_sound") if JSRun.get("ls") is Dictionary else null
	on = str(v) != "0"
	_apply_master()

const PF = preload("res://game/settings/prefs.gd")
func _apply_master() -> void:
	PF.apply_audio(on)   # [settings] 總音量跟設置
	AudioServer.set_bus_mute(0, not on)

func is_on() -> bool: return on
func toggle() -> bool:
	on = not on
	if JSRun.get("ls") is Dictionary: JSRun.ls["gb_sound"] = "1" if on else "0"; JSRun.flush_ls()
	_apply_master()
	if on and mode != "": var m = mode; mode = ""; set_mode(m)
	elif not on: _stop_music()
	return on

func _notification(what: int) -> void:
	# 切去後台：成個引擎停（同網頁版 sync() 一樣，唔好喺背景燒電）
	if what == NOTIFICATION_APPLICATION_FOCUS_OUT or what == NOTIFICATION_APPLICATION_PAUSED: AudioServer.set_bus_mute(0, true)
	elif what == NOTIFICATION_APPLICATION_FOCUS_IN or what == NOTIFICATION_APPLICATION_RESUMED: AudioServer.set_bus_mute(0, not on)
	elif what == NOTIFICATION_PREDELETE or what == NOTIFICATION_WM_CLOSE_REQUEST or what == NOTIFICATION_EXIT_TREE:
		if _note_task >= 0: WorkerThreadPool.wait_for_task_completion(_note_task); _note_task = -1   # [perf2] 關遊戲前等背景旋律計完

# ====================================================================
# 合成：聲部清單 → 一段 PCM
# ====================================================================
class Mix:
	var dry: PackedFloat32Array
	var wet: PackedFloat32Array
	var has_wet := false
	var n := 0
	var sr := 22050
	func _init(sec: float, rate := 22050) -> void:
		sr = rate; n = int(sec * rate) + 1; dry.resize(n); wet.resize(n)

static func _expv(v0: float, v1: float, x: float) -> float: return v0 * pow(v1 / v0, clampf(x, 0.0, 1.0))

func tone(m: Mix, o: Dictionary) -> void:
	var t: float = o.get("t", 0.0); var a: float = o.get("a", 0.005); var d: float = o.get("d", 0.3); var v: float = o.get("v", 0.2)
	var f: float = o.get("f", 440.0); var f2: float = o.get("f2", 0.0); var sl: float = o.get("slide", d)
	var typ: String = o.get("type", "sine"); var det: float = pow(2.0, o.get("detune", 0.0) / 1200.0)
	var wet: float = o.get("wet", 0.0)
	var i0 = int(t * SR); var i1 = mini(m.n, int((t + a + d + 0.05) * SR))
	var ph = 0.0
	for i in range(i0, i1):
		var lt = float(i - i0) / SR
		var fr = (f if f2 <= 0.0 else _expv(f, f2, lt / sl)) * det
		ph += fr / SR; ph -= floor(ph)
		var s: float
		match typ:
			"square": s = 1.0 if ph < 0.5 else -1.0
			"sawtooth": s = 2.0 * ph - 1.0
			"triangle": s = 4.0 * absf(ph - 0.5) - 1.0
			_: s = sin(TAU * ph)
		var g: float
		if lt < a: g = _expv(0.0001, v, lt / a)
		else: g = _expv(v, 0.0001, (lt - a) / d)
		s *= g
		m.dry[i] += s
		if wet > 0.0: m.wet[i] += s * wet
	if wet > 0.0: m.has_wet = true

func noise(m: Mix, o: Dictionary) -> void:
	var t: float = o.get("t", 0.0); var a: float = o.get("a", 0.003); var d: float = o.get("d", 0.2); var v: float = o.get("v", 0.2)
	var f: float = o.get("f", 1000.0); var f2: float = o.get("f2", 0.0); var q: float = o.get("q", 1.0)
	var typ: String = o.get("type", "bandpass"); var wet: float = o.get("wet", 0.0)
	var i0 = int(t * SR); var i1 = mini(m.n, int((t + a + d + 0.05) * SR))
	var x1 = 0.0; var x2 = 0.0; var y1 = 0.0; var y2 = 0.0
	var b0 = 0.0; var b1 = 0.0; var b2 = 0.0; var a1 = 0.0; var a2 = 0.0
	var k = 0
	for i in range(i0, i1):
		var lt = float(i - i0) / SR
		if k % 32 == 0:
			var fr = minf(f if f2 <= 0.0 else _expv(f, f2, lt / d), SR * 0.45)
			var c = _biquad(typ, fr, q); b0 = c[0]; b1 = c[1]; b2 = c[2]; a1 = c[3]; a2 = c[4]
		k += 1
		var x = _rng.randf() * 2.0 - 1.0
		var y = b0 * x + b1 * x1 + b2 * x2 - a1 * y1 - a2 * y2
		x2 = x1; x1 = x; y2 = y1; y1 = y
		var g: float
		if lt < a: g = _expv(0.0001, v, lt / a)
		else: g = _expv(v, 0.0001, (lt - a) / d)
		var s = y * g
		m.dry[i] += s
		if wet > 0.0: m.wet[i] += s * wet
	if wet > 0.0: m.has_wet = true

static func _biquad(typ: String, f: float, q: float, rate := 22050) -> Array:
	var w0 = TAU * f / float(rate); var cw = cos(w0); var al = sin(w0) / (2.0 * maxf(q, 0.0001))
	var b0; var b1; var b2
	match typ:
		"lowpass": b0 = (1 - cw) / 2; b1 = 1 - cw; b2 = (1 - cw) / 2
		"highpass": b0 = (1 + cw) / 2; b1 = -(1 + cw); b2 = (1 + cw) / 2
		_: b0 = al; b1 = 0.0; b2 = -al   # bandpass（constant 0 dB peak，同 WebAudio 一樣）
	var a0 = 1 + al
	return [b0 / a0, b1 / a0, b2 / a0, (-2 * cw) / a0, (1 - al) / a0]

func _reverb(m: Mix) -> void:
	if not m.has_wet: return
	var combs = [[1557, 0.84], [1617, 0.83], [1491, 0.85], [1422, 0.86]]
	var out = PackedFloat32Array(); out.resize(m.n)
	for cdef in combs:
		var L = int(cdef[0] * 0.5); var fb: float = cdef[1]; var buf = PackedFloat32Array(); buf.resize(L); var idx = 0; var lp = 0.0
		for i in m.n:
			var y = buf[idx]; lp = y * 0.7 + lp * 0.3
			buf[idx] = m.wet[i] + lp * fb; idx = (idx + 1) % L
			out[i] += y
	for adef in [278, 556]:
		var L2 = adef; var buf2 = PackedFloat32Array(); buf2.resize(L2); var j = 0
		for i in m.n:
			var bo = buf2[j]; var x = out[i]
			buf2[j] = x + bo * 0.5; out[i] = bo - x * 0.5; j = (j + 1) % L2
	for i in m.n: m.dry[i] += out[i] * 0.22

func _stream(m: Mix, loop := false, gain := 1.0) -> AudioStreamWAV:
	_reverb(m)
	var b = PackedByteArray(); b.resize(m.n * 2)
	for i in m.n:
		var s = m.dry[i] * gain
		s = s if absf(s) < 0.8 else signf(s) * (0.8 + (1.0 - exp(-(absf(s) - 0.8) * 3.0)) * 0.2)  # 簡單壓縮／軟削波
		b.encode_s16(i * 2, int(clampf(s, -1.0, 1.0) * 32000))
	var w = AudioStreamWAV.new(); w.format = AudioStreamWAV.FORMAT_16_BITS; w.mix_rate = m.sr; w.stereo = false; w.data = b
	if loop: w.loop_mode = AudioStreamWAV.LOOP_FORWARD; w.loop_begin = 0; w.loop_end = m.n - 1
	return w

func _len_of(voices: Array) -> float:
	var e = 0.0; var wet = false
	for v in voices:
		e = maxf(e, v.get("t", 0.0) + v.get("a", 0.005) + v.get("d", 0.3) + 0.06)
		if v.get("wet", 0.0) > 0: wet = true
	return e + (1.6 if wet else 0.0)

func render(voices: Array, gain := 1.0) -> AudioStreamWAV:
	var m = Mix.new(_len_of(voices))
	for v in voices:
		if v.get("n", false): noise(m, v)
		else: tone(m, v)
	return _stream(m, false, gain)

# ====================================================================
# 音效（同 audio.js 嘅 S 一一對應）
# ====================================================================
func _N(o: Dictionary) -> Dictionary: o["n"] = true; return o
func _musicbox(f: float, t: float, v := 0.07) -> Array:
	return [{"f": f, "t": t, "d": 2.6, "v": v, "wet": 0.9, "detune": -18}, {"f": f * 2, "t": t, "d": 1.2, "v": v * 0.35, "wet": 0.9, "detune": -12}]
func _gong() -> Array:
	var r = []
	var ms = [1, 1.48, 2.02, 2.76, 3.9]
	for i in ms.size(): r.append({"f": 98 * ms[i], "f2": 96 * ms[i], "t": 0.0, "a": 0.01, "d": 3.2 / (i * 0.5 + 1), "v": 0.18 / (i + 1), "wet": 0.9})
	r.append(_N({"t": 0.0, "d": 0.05, "type": "lowpass", "f": 600, "v": 0.3}))
	return r
func _bell(f: float, t: float, v: float) -> Array:
	var r = []; var ms = [1, 2.76, 5.4, 8.93]
	for i in 4: r.append({"f": f * ms[i], "t": t, "a": 0.004, "d": 4.5 / (i + 1), "v": v / (i + 1.2), "wet": 1.0})
	return r

func sfx_voices(name: String, arg = null) -> Array:
	match name:
		"chop": return [_N({"d": 0.09, "f": 1700, "q": 1.4, "v": 0.45}), {"f": 150, "f2": 55, "d": 0.16, "v": 0.5}, {"f": 420, "f2": 300, "d": 0.05, "v": 0.12, "type": "triangle"}]
		"treeFall": return [_N({"d": 0.7, "type": "lowpass", "f": 900, "f2": 200, "v": 0.35, "a": 0.05}), {"f": 90, "f2": 40, "t": 0.5, "d": 0.4, "v": 0.5}]
		"harvest": return [_N({"d": 0.32, "f": 3200, "f2": 700, "q": 0.9, "v": 0.32, "a": 0.02})]
		"craft":
			var r = []
			for d in [0.0, 0.13]: r.append({"f": 330, "f2": 180, "t": d, "d": 0.08, "v": 0.35, "type": "triangle"}); r.append(_N({"t": d, "d": 0.03, "f": 2500, "v": 0.2}))
			return r
		"coin": return [{"f": 1320, "d": 0.35, "v": 0.12, "wet": 0.3}, {"f": 1980, "t": 0.06, "d": 0.4, "v": 0.1, "wet": 0.3}]
		"build":
			var r = []
			for i in 3: r.append({"f": 220, "f2": 110, "t": i * 0.16, "d": 0.09, "v": 0.4, "type": "triangle"}); r.append(_N({"t": i * 0.16, "d": 0.04, "f": 1800, "v": 0.25}))
			return r
		"gong": return _gong()
		"levelUp":
			var r = _gong(); var ks = [0, 2, 4, 7]
			for i in 4: r.append_array(_musicbox(SCALE[mini(8, ks[i] + 1)] * 2, 0.25 + i * 0.12, 0.09))
			return r
		"click": return [{"f": 1700, "d": 0.025, "v": 0.06, "type": "triangle"}]
		"paper": return [_N({"d": 0.12, "type": "highpass", "f": 2500, "v": 0.12, "a": 0.01})]
		"waIn": return [{"f": 880, "d": 0.09, "v": 0.13}, {"f": 1318, "t": 0.09, "d": 0.16, "v": 0.13}]
		"waOut": return [_N({"d": 0.14, "type": "highpass", "f": 1500, "f2": 5000, "v": 0.12, "a": 0.01}), {"f": 1046, "d": 0.06, "v": 0.05}]
		"key": return [{"f": 2600 + _rng.randf() * 600, "d": 0.015, "v": 0.03, "type": "square"}]
		"praise": return [{"f": 1568, "d": 0.12, "v": 0.06, "type": "square"}, {"f": 2093, "t": 0.08, "d": 0.16, "v": 0.06, "type": "square"}]
		"hit": return [_N({"d": 0.07, "type": "lowpass", "f": 1200, "v": 0.35}), {"f": 110, "f2": 55, "d": 0.1, "v": 0.35}]
		"skill": return [_N({"d": 0.35, "f": 400, "f2": 3000, "q": 2, "v": 0.25, "a": 0.05}), {"f": 880, "t": 0.25, "d": 0.8, "v": 0.08, "wet": 0.8}]
		"combo":
			var n = int(J.num(arg)) if arg != null else 0; var r = []
			for i in 3: r.append({"f": SCALE[mini(8, 3 + i + n % 3)] * 2, "type": "triangle", "t": i * 0.06, "d": 0.2, "v": 0.1})
			return r
		"win":
			var r = _gong(); var ks = [4, 5, 6, 8]
			for i in 4: r.append_array(_musicbox(SCALE[ks[i]] * 2, 0.4 + i * 0.18, 0.1))
			return r
		"chest": return [{"f": 180, "f2": 320, "d": 0.35, "v": 0.15, "type": "sawtooth"}, {"f": 1320, "d": 0.35, "v": 0.12, "wet": 0.3}, {"f": 1980, "t": 0.06, "d": 0.4, "v": 0.1, "wet": 0.3}]
		"flatline": return [{"f": 988, "a": 0.01, "d": 3.2, "v": 0.09}]
		"heartbeat": return [{"f": 60, "f2": 40, "d": 0.12, "v": 0.5}, {"f": 55, "f2": 38, "t": 0.22, "d": 0.12, "v": 0.35}]
		"whoosh", "scare": return [_N({"d": 0.5, "f": 300, "f2": 2500, "q": 1.5, "v": 0.2, "a": 0.15})]
	return []

# 二胡：鋸齒波＋顫音＋帶通，直接逐點合成
func _erhu(m: Mix, f1: float, f2: float, t: float, dur: float, v: float) -> void:
	var i0 = int(t * SR); var i1 = mini(m.n, int((t + dur + 0.1) * SR)); var ph = 0.0
	var c = _biquad("bandpass", 1100, 2.2); var x1 = 0.0; var x2 = 0.0; var y1 = 0.0; var y2 = 0.0
	for i in range(i0, i1):
		var lt = float(i - i0) / SR
		var fr = _expv(f1, f2, lt / (dur * 0.8)) + sin(TAU * 5.2 * lt) * f1 * 0.018 * clampf(lt / (dur * 0.5), 0, 1)
		ph += fr / SR; ph -= floor(ph)
		var x = 2.0 * ph - 1.0
		var y = c[0] * x + c[1] * x1 + c[2] * x2 - c[3] * y1 - c[4] * y2
		x2 = x1; x1 = x; y2 = y1; y1 = y
		var g: float
		if lt < 0.35: g = _expv(0.0001, v, lt / 0.35)
		elif lt < dur - 0.5: g = v
		else: g = _expv(v, 0.0001, (lt - (dur - 0.5)) / 0.5)
		m.dry[i] += y * g * 2.0; m.wet[i] += y * g * 1.6
	m.has_wet = true

func _sfx_stream(name: String, arg = null) -> AudioStreamWAV:
	var key = name
	if name == "combo": key = name + str(int(J.num(arg)) % 3 if arg != null else 0)
	if name == "key": key = "key%d" % _rng.randi_range(0, 3)
	if name == "crow": key = "crow%d" % _rng.randi_range(0, 2)
	if _cache.has(key): return _cache[key]
	var dc = _disk_get(key)
	if dc: _cache[key] = dc; return dc
	var st: AudioStreamWAV
	if name.begins_with("crow"): st = _crow()
	elif name == "lose":
		var m = Mix.new(4.6); _erhu(m, 392, 196, 0.05, 2.4, 0.09)
		for v in _bell(73.42, 0.1, 0.12): tone(m, v)
		st = _stream(m)
	else:
		var vs = sfx_voices(name, arg)
		if vs.is_empty(): return null
		st = render(vs)
	_cache[key] = st; _disk_put(key, st)
	return st

func _crow() -> AudioStreamWAV:
	var m = Mix.new(2.4)
	var caws = [0.02]
	if _rng.randf() < 0.7: caws.append(0.32)
	var c = _biquad("bandpass", 1500, 3)
	for t in caws:
		var i0 = int(t * SR); var i1 = int((t + 0.3) * SR); var ph = 0.0; var x1 = 0.0; var x2 = 0.0; var y1 = 0.0; var y2 = 0.0
		for i in range(i0, i1):
			var lt = float(i - i0) / SR
			var fr = _expv(560, 400, lt / 0.24) + sin(TAU * 38 * lt) * 140
			ph += fr / SR; ph -= floor(ph)
			var x = 2.0 * ph - 1.0
			var y = c[0] * x + c[1] * x1 + c[2] * x2 - c[3] * y1 - c[4] * y2
			x2 = x1; x1 = x; y2 = y1; y1 = y
			var g = _expv(0.0001, 0.16, lt / 0.015) if lt < 0.015 else _expv(0.16, 0.0001, (lt - 0.015) / 0.24)
			m.dry[i] += y * g * 2.2; m.wet[i] += y * g * 1.1
	m.has_wet = true
	for i in 5: noise(m, {"t": 0.02 + i * 0.07, "d": 0.05, "type": "bandpass", "f": 900, "q": 0.8, "v": 0.06})
	return _stream(m)

func play(name: String, arg = null) -> void:
	if not on: return
	if _f43(name): return   # [sfx43] 補丁 43 新音效（音檔）
	var st = _sfx_stream(name, arg)
	if st == null: return
	var p: AudioStreamPlayer = null
	for q in _sfx: if not q.playing: p = q; break
	if p == null: p = _sfx[0]
	p.stream = st; p.volume_db = linear_to_db(0.85); p.play()

# ====================================================================
# [sfx43] 補丁 43 音效：res://assets/snd/sfx43/<key>.ogg（CC0 素材組合，見 LICENSES_sfx43.md）
#   自己一組 8 個播放器（唔搶 UI 聲）；同一個聲有最短間隔；技能聲啱啱響過，狀態聲先唔出（免得一嚿）
# ====================================================================
const F43_DIR := "res://assets/snd/sfx43/"
const F43_GAP := {"wp_": 0.11, "st_": 0.3, "sub_": 0.12, "ace_": 0.25}
const F43_DB := {"wp_": -5.0, "st_": -2.0, "sub_": 0.0, "ace_": 0.0}
var _f43s := {}       # key → AudioStream／null（冇檔）
var _f43t := {}       # key → 上次播（毫秒）
var _f43p: Array = []
var _f43_sk := -100000
var f43_log: Array = []   # 測試用：播過乜
func _f43_pre(name: String) -> String:
	for p in F43_GAP: if name.begins_with(p): return p
	return ""
func f43_stream(name: String):
	if _f43s.has(name): return _f43s[name]
	var path = F43_DIR + name + ".ogg"
	var st = load(path) if ResourceLoader.exists(path) else null
	_f43s[name] = st
	return st
func _f43(name: String) -> bool:
	var st = f43_stream(name)
	if st == null: return false
	var now = Time.get_ticks_msec(); var pre = _f43_pre(name)
	if now - int(_f43t.get(name, -100000)) < int(float(F43_GAP.get(pre, 0.08)) * 1000.0): return true
	if pre == "st_" and now - _f43_sk < 200: return true
	if pre in ["sub_", "ace_"]: _f43_sk = now
	_f43t[name] = now
	if _f43p.is_empty():
		for i in 8:
			var q = AudioStreamPlayer.new(); q.bus = PF.bus("sfx"); add_child(q); _f43p.append(q)
	var p: AudioStreamPlayer = null
	for q in _f43p: if not q.playing: p = q; break
	if p == null:   # 全部響緊：搶播得最耐嗰個
		p = _f43p[0]
		for q in _f43p: if q.get_playback_position() > p.get_playback_position(): p = q
	p.stream = st
	p.volume_db = linear_to_db(0.85) + float(F43_DB.get(pre, 0.0))
	p.pitch_scale = _rng.randf_range(0.95, 1.05) if pre in ["wp_", "st_"] else 1.0   # 密集嘅聲微微變調，唔似機關槍
	p.play()
	f43_log.append(name)
	if f43_log.size() > 200: f43_log.pop_front()
	return true

# ====================================================================
# 背景音樂
# ====================================================================
func _bed_drone(freqs: Array, cutoff: float, vol: float, wind_vol: float, sec: float, hum := false) -> AudioStreamWAV:
	var key = "bed_%s_%d_%d_%d" % [str(freqs), int(cutoff), int(vol * 100), int(hum)]
	if _cache.has(key): return _cache[key]
	var dc = _disk_get(key)
	if dc: _cache[key] = dc; return dc
	const BR = 11025
	var m = Mix.new(sec, BR); var n = m.n
	var phs = []; phs.resize(freqs.size()); phs.fill(0.0)
	var x1 = 0.0; var x2 = 0.0; var y1 = 0.0; var y2 = 0.0; var c = []
	var wx1 = 0.0; var wx2 = 0.0; var wy1 = 0.0; var wy2 = 0.0; var wc = []
	var dfs = []
	for k in freqs.size(): dfs.append(freqs[k] * pow(2.0, (7.0 if k % 2 else -6.0) / 1200.0) / BR)
	var nf = freqs.size(); var tb = Time.get_ticks_usec()
	for i in n:
		var lt = float(i) / BR
		if i % 64 == 0:
			c = _biquad("lowpass", cutoff + sin(TAU * lt / sec) * cutoff * 0.45, 3.0, BR)
			wc = _biquad("bandpass", 500 + sin(TAU * lt / sec * 0.75 + 1.0) * 320, 1.2, BR)
		var x = 0.0
		for k in nf:
			var ph = phs[k] + dfs[k]
			if ph >= 1.0: ph -= 1.0
			phs[k] = ph
			x += sin(TAU * phs[k]) if k == 0 and not hum else 2.0 * phs[k] - 1.0
		var y = c[0] * x + c[1] * x1 + c[2] * x2 - c[3] * y1 - c[4] * y2
		x2 = x1; x1 = x; y2 = y1; y1 = y
		var s = y * vol
		if wind_vol > 0:
			var wx = _rng.randf() * 2.0 - 1.0
			var wy = wc[0] * wx + wc[1] * wx1 + wc[2] * wx2 - wc[3] * wy1 - wc[4] * wy2
			wx2 = wx1; wx1 = wx; wy2 = wy1; wy1 = wy
			s += wy * wind_vol
		m.dry[i] = s * 0.5
		if i % 256 == 0 and Time.get_ticks_usec() - tb > 6000:
			await get_tree().process_frame; tb = Time.get_ticks_usec()
	# 頭尾交叉淡化，loop 唔會「咔」一聲
	var fade = int(0.25 * BR)
	for i in fade:
		var k = float(i) / fade
		m.dry[i] = m.dry[i] * k + m.dry[n - fade + i] * (1.0 - k)
	m.n = n - fade; m.dry.resize(m.n); m.wet.resize(m.n)
	var st = _stream(m, true)
	_cache[key] = st; _disk_put(key, st)
	return st

func _office_ticks() -> AudioStreamWAV:
	if _cache.has("office_tick"): return _cache["office_tick"]
	var dc = _disk_get("office_tick")
	if dc: _cache["office_tick"] = dc; return dc
	var m = Mix.new(2.0)
	tone(m, {"f": 2400, "t": 0.02, "d": 0.03, "v": 0.035 * 0.5})
	tone(m, {"f": 2100, "t": 1.02, "d": 0.03, "v": 0.035 * 0.5})
	var st = _stream(m, true); _cache["office_tick"] = st; return st

func _stop_music() -> void:
	_gen += 1
	for p in [_bed, _bed2]:
		if p.playing:
			var tw = create_tween(); tw.tween_property(p, "volume_db", -60.0, 1.2); tw.tween_callback(p.stop)
	for t in _timers: if is_instance_valid(t): t.queue_free()
	_timers.clear()

func _play_bed(p: AudioStreamPlayer, st: AudioStreamWAV, lin: float) -> void:
	p.stop(); p.stream = st; p.volume_db = -60.0; p.play()
	create_tween().tween_property(p, "volume_db", linear_to_db(lin), 3.0)

# [perf2] 旋律音符：以前喺主線程逐粒即時合成（連殘響）＝ 每隔幾秒卡一下（手機上出征、村子都會頓）。
#   而家：同一粒音合成過就記住；未合成過就交俾背景線程計，計好先播（遲一兩格冇人聽得出）。
var _note_cache := {}
var _note_busy := false
var _note_task := -1
func _note(voices: Array, extra: Callable = Callable(), sec := 0.0, key := "") -> void:
	if key == "" and not extra.is_valid(): key = "n_%s_%s" % [str(voices), str(sec)]
	if key != "" and _note_cache.has(key): _play_note(_note_cache[key]); return
	if _note_busy: return   # 背景仲計緊上一粒：呢粒唔播（旋律本身就係隨機點綴）
	_note_busy = true
	var g = _gen
	var wr = weakref(self)   # 關遊戲時背景線程計完，Snd 可能已經冇咗
	_note_task = WorkerThreadPool.add_task(func():
		var m = Mix.new(maxf(_len_of(voices), sec))
		for v in voices:
			if v.get("n", false): noise(m, v)
			else: tone(m, v)
		if extra.is_valid(): extra.call(m)
		var st = _stream(m)
		var me = wr.get_ref()
		if me != null: me.call_deferred("_note_done", key, st, g))

func _note_done(key: String, st: AudioStreamWAV, g: int) -> void:
	_note_busy = false
	if _note_task >= 0: WorkerThreadPool.wait_for_task_completion(_note_task); _note_task = -1
	if key != "": _note_cache[key] = st
	if g == _gen and on: _play_note(st)

func _play_note(st: AudioStreamWAV) -> void:
	var p: AudioStreamPlayer = null
	for q in _mus: if not q.playing: p = q; break
	if p == null: return
	p.stream = st; p.volume_db = linear_to_db(0.5); p.play()

func _every(f: Callable, mn: float, mx: float) -> void:
	var g = _gen
	var t = Timer.new(); t.one_shot = true; add_child(t); _timers.append(t)
	t.timeout.connect(func():
		if g != _gen: return
		f.call(); t.wait_time = mn + _rng.randf() * (mx - mn); t.start())
	t.wait_time = mn * 0.5; t.start()

func set_mode(m: String) -> void:
	if m == mode: return
	mode = m
	_stop_music()
	if not on: return
	var g = _gen
	match m:
		"village":
			var st = await _bed_drone([36.71, 73.42, 110.3], 320, 0.16, 0.05, 8.0)
			if g != _gen: return
			_play_bed(_bed, st, 0.5)
			_every(func():
				var i = _rng.randi() % SCALE.size(); var vs = _musicbox(SCALE[i] * 2, 0.0)
				if _rng.randf() < 0.4: vs.append_array(_musicbox(SCALE[(i + 2) % SCALE.size()] * 2, 0.45, 0.05))
				_note(vs), 2.4, 4.8)
			_every(func():
				if _rng.randf() < 0.5: _note(_bell(146.83, 0.0, 0.09))
				else: _note([], func(mx): _erhu(mx, 440, 349.23, 0.0, 2.6, 0.05), 4.4, "erhu_v"), 11, 19)
		"story", "scare":
			var st = await _bed_drone([36.71, 73.42], 260, 0.12, 0.03, 8.0)
			if g != _gen: return
			_play_bed(_bed, st, 0.5)
			_every(func(): _note(_bell(110, 0.0, 0.06)), 9, 16)
		"office":
			var st = await _bed_drone([50.0], 180, 0.05, 0.0, 4.0, true)
			if g != _gen: return
			_play_bed(_bed, st, 0.5); _play_bed(_bed2, _office_ticks(), 0.5)
		"battle":
			var st = await _bed_drone([36.71, 73.42], 420, 0.11, 0.0, 8.0)
			if g != _gen: return
			_play_bed(_bed, st, 0.5)
			var lp = await _battle_loop()
			if g != _gen: return
			_play_bed(_bed2, lp, 0.5)

# 戰鼓：108 BPM，4 小節一個 loop（太鼓＋五聲音階旋律＋低音）
func _battle_loop() -> AudioStreamWAV:
	if _cache.has("battle_loop"): return _cache["battle_loop"]
	var dc = _disk_get("battle_loop")
	if dc: _cache["battle_loop"] = dc; return dc
	var beat = 60.0 / 108.0; var bar = beat * 4; var bars = 4
	var m = Mix.new(bar * bars + 0.6)
	var pat = [[0.0, 0.55], [1.5, 0.35], [2.0, 0.5], [3.5, 0.3]]
	var note = 4
	for n in bars:
		var t = n * bar
		for pv in pat:
			var v = pv[1] * (1.4 if n % 4 == 3 and pv[0] == 3.5 else 1.0)
			tone(m, {"f": 120, "f2": 48, "slide": 0.25, "t": t + pv[0] * beat, "d": 0.45, "v": v})
			noise(m, {"t": t + pv[0] * beat, "d": 0.06, "type": "lowpass", "f": 900, "v": v * 0.4})
		for s in 8:
			if _rng.randf() < 0.55:
				note = clampi(note + [-2, -1, 1, 2][_rng.randi() % 4], 0, SCALE.size() - 1)
				tone(m, {"f": SCALE[note] * 2, "type": "triangle", "t": t + s * beat / 2, "d": 0.35, "v": 0.06, "wet": 0.4})
		tone(m, {"f": 73.42, "type": "triangle", "t": t, "d": beat * 1.6, "v": 0.12})
		tone(m, {"f": 87.31 if n % 2 else 65.41, "type": "triangle", "t": t + beat * 2, "d": beat * 1.6, "v": 0.1})
		if n % 4 == 0: noise(m, {"t": t, "d": 1.4, "type": "highpass", "f": 6000, "v": 0.05, "wet": 0.6, "a": 0.01})
		await get_tree().process_frame
	# 尾巴（殘響）疊返去開頭，loop 先順
	var L = int(bar * bars * SR)
	_reverb(m); m.has_wet = false
	for i in range(L, m.n): m.dry[i - L] += m.dry[i]
	m.n = L; m.dry.resize(L); m.wet.resize(L)
	var st = _stream(m, true); _cache["battle_loop"] = st; _disk_put("battle_loop", st)
	return st

# 開機時喺背景慢慢預先合成常用音效（每格一個），第一次撳唔會卡
func warm() -> void:
	for n in ["click", "chop", "coin", "paper", "waIn", "waOut", "key", "harvest", "craft", "hit", "praise", "whoosh", "build", "heartbeat", "flatline", "gong", "levelUp", "win", "chest", "skill", "treeFall"]:
		_sfx_stream(n)
		await get_tree().process_frame
	# [sfx43] 補丁 43 音檔：開機慢慢預載（每格幾個），第一次播唔會卡一下
	var d = DirAccess.open(F43_DIR)
	if d != null:
		var i = 0
		for f in d.get_files():
			var fn = f.trim_suffix(".import").trim_suffix(".remap")
			if not fn.ends_with(".ogg"): continue
			var k = fn.trim_suffix(".ogg")
			if _f43s.has(k): continue
			f43_stream(k); i += 1
			if i % 6 == 0: await get_tree().process_frame

# 合成過嘅聲存落機（user://snd/），第二次開遊戲唔使再計
const CACHE_VER := "v1"
func _disk_path(key: String) -> String: return "user://snd/%s_%s.res" % [CACHE_VER, key.md5_text().substr(0, 16)]
func _disk_get(key: String) -> AudioStreamWAV:
	var rp = "res://assets/snd/%s.res" % key.md5_text().substr(0, 16)
	if ResourceLoader.exists(rp): return load(rp)
	var p = _disk_path(key)
	if not FileAccess.file_exists(p): return null
	var r = ResourceLoader.load(p, "", ResourceLoader.CACHE_MODE_IGNORE)
	return r if r is AudioStreamWAV else null
func _disk_put(key: String, st: AudioStreamWAV) -> void:
	DirAccess.make_dir_recursive_absolute("user://snd")
	ResourceSaver.save(st, _disk_path(key))

# 開發用：將所有聲預先合成，放入 res://assets/snd（打包入遊戲，開機零延遲）
var baking := false
func bake(dir: String) -> void:
	baking = true
	DirAccess.make_dir_recursive_absolute(dir)
	var keys = []
	for n in ["chop", "treeFall", "harvest", "craft", "coin", "build", "gong", "levelUp", "click", "paper", "waIn", "waOut", "praise", "hit", "skill", "win", "chest", "flatline", "heartbeat", "whoosh", "scare", "lose"]:
		var st = _sfx_stream(n); ResourceSaver.save(st, dir + "/" + n.md5_text().substr(0, 16) + ".res")
	for i in 4:
		var k = "key%d" % i; _rng.seed = 100 + i; var st = render(sfx_voices("key")); ResourceSaver.save(st, dir + "/" + k.md5_text().substr(0, 16) + ".res")
	for i in 3:
		var k = "crow%d" % i; _rng.seed = 200 + i; var st = _crow(); ResourceSaver.save(st, dir + "/" + k.md5_text().substr(0, 16) + ".res")
	for i in 3:
		var k = "combo%d" % i; var st = render(sfx_voices("combo", i)); ResourceSaver.save(st, dir + "/" + k.md5_text().substr(0, 16) + ".res")
	_cache.clear()
	var beds = [[[36.71, 73.42, 110.3], 320, 0.16, 0.05, 8.0, false], [[36.71, 73.42], 260, 0.12, 0.03, 8.0, false], [[50.0], 180, 0.05, 0.0, 4.0, true], [[36.71, 73.42], 420, 0.11, 0.0, 8.0, false]]
	for b in beds:
		var key = "bed_%s_%d_%d_%d" % [str(b[0]), int(b[1]), int(b[2] * 100), int(b[5])]
		var st = await _bed_drone(b[0], b[1], b[2], b[3], b[4], b[5]); ResourceSaver.save(st, dir + "/" + key.md5_text().substr(0, 16) + ".res")
	_rng.seed = 4471
	var bl = await _battle_loop(); ResourceSaver.save(bl, dir + "/" + "battle_loop".md5_text().substr(0, 16) + ".res")
	var ot = _office_ticks(); ResourceSaver.save(ot, dir + "/" + "office_tick".md5_text().substr(0, 16) + ".res")
	baking = false
