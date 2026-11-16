# 原生改寫自 audio.js：網頁版用 WebAudio 即時合成；Godot 版合成引擎已經係 core/snd.gd（autoload Snd，預先合成）
# 呢度直接設 J.G["Sound"] = { play, setMode, toggle, isOn, unlock } 轉駁 Snd（同 js/bridge.gd connect_ui 換上嘅一樣）
extends RefCounted

func run(_env) -> void:
	J.G["Sound"] = {
		"play": func(_t, a): Snd.play(J.str(a[0]), a[1] if a.size() > 1 else null); return null,
		"setMode": func(_t, a): Snd.set_mode(J.str(a[0])); return null,
		"toggle": func(_t, _a): return Snd.toggle(),
		"isOn": func(_t, _a): return Snd.is_on(),
		"unlock": func(_t, _a): return null,
	}
