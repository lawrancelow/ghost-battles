# 自動測試：設環境變數 GB_TEST=<json 檔> 先會跑。腳本格式：[["wait",秒],["shot","/tmp/x.png"],["import","存檔碼檔"],["notitle"],["eval","village.tap", x, y], ["quit"]]
extends Node

var steps: Array = []
var errors: Array = []

func _ready() -> void:
	var p := OS.get_environment("GB_TEST")
	if p == "": set_process(false); return
	var f := FileAccess.open(p, FileAccess.READ)
	if f == null: push_error("no test file"); return
	steps = JSON.parse_string(f.get_as_text())
	_run()

func main() -> Node: return get_tree().root.get_node_or_null("Main")

func _run() -> void:
	await get_tree().process_frame
	while main() == null or main().get("loading") != null or J.G.get("S") == null:
		await get_tree().create_timer(0.2).timeout
	for s in steps:
		var cmd: String = s[0]
		match cmd:
			"wait": await get_tree().create_timer(float(s[1])).timeout
			"frames":
				for i in int(s[1]): await get_tree().process_frame
			"shot":
				await RenderingServer.frame_post_draw
				get_viewport().get_texture().get_image().save_png(s[1]); print("SHOT ", s[1])
			"import":
				var code = FileAccess.open(s[1], FileAccess.READ).get_as_text()
				print("IMPORT ", main().import_save(code))
				await get_tree().create_timer(12.0).timeout
			"notitle": main()._hide_title()
			"sndbake":
				await Snd.bake(s[1]); print("SND baked")
			"sndtest":
				for n in s.slice(1):
					var t1 = Time.get_ticks_msec(); Snd._cache.erase(n)
					var st = Snd._sfx_stream(n, 1)
					print("SND ", n, " ", st.data.size() / 2, " samples ", Time.get_ticks_msec() - t1, "ms"); st.save_to_wav("/tmp/snd_%s.wav" % n)
			"modetest":
				var t1 = Time.get_ticks_msec(); Snd.mode = ""; Snd._cache.clear(); Snd.set_mode(s[1])
				while not Snd._bed.playing: await get_tree().process_frame
				print("SND mode ", s[1], " ready ", Time.get_ticks_msec() - t1, "ms"); Snd._bed.stream.save_to_wav("/tmp/bed_%s.wav" % s[1])
			"click":
				var pos = Vector2(float(s[1]), float(s[2]))
				var vp = get_viewport(); var xf = vp.get_final_transform()
				for down in [true, false]:
					var ev = InputEventMouseButton.new(); ev.button_index = MOUSE_BUTTON_LEFT; ev.pressed = down
					ev.position = xf * pos; ev.global_position = ev.position
					vp.push_input(ev)
					await get_tree().process_frame
			"js":
				print("JS ", s[1], " = ", J.str(J.cl(J.G.get(s[1]), null, s.slice(2))).substr(0, 200))
			"tap": J.mc(J.G.get("Village"), "tap", [float(s[1]), float(s[2])])
			"cam": J.mc(J.G.get("Village"), "setCam", [float(s[1])])
			"call":
				if s[1] == "main": main().callv(s[2], s.slice(3))
				else: J.mc(J.G.get(s[1]), s[2], s.slice(3))
			"set": G.S[s[1]] = s[2]
			"print": print("STATE ", s[1], "=", str(G.S.get(s[1])).substr(0, 300))
			"export":
				var fo = FileAccess.open(s[1], FileAccess.WRITE); fo.store_string(G.enc(G.S)); fo.close(); print("EXPORT ok")
			"assign":
				var g = G.ghostById(s[1]); g.post = s[2]; print("ASSIGN ", g.name, " -> ", s[2])
			"dom":
				var dv = main().dom
				print("DOM boxes=", dv.boxes.size())
				for b in dv.boxes.slice(0, int(s[1]) if s.size() > 1 else 40):
					print("  ", "  ".repeat(b.depth), b.el.tagName, "#", b.el.id_, ".", ".".join(b.el.classList.d.keys()), " ", b.kind, " [", int(b.x), ",", int(b.y), " ", int(b.w), "x", int(b.h), "] a=", snapped(b.alpha, 0.01), " disp=", b.cs.get("display", ""), " pos=", b.cs.get("position", ""), " bg=", J.str(b.cs.get("background", b.cs.get("background-color", ""))).substr(0, 30), (" txt=" + str(b.lines.size())) if b.kind == "text" else "")
			"jget":
				var o = J.G.get(s[1])
				for k in s.slice(2): print("JGET ", s[1], ".", k, " = ", J.str(J.gp(o, k)).substr(0, 160), "  type=", typeof(J.gp(o, k)))
			"encdec":
				var w = J.G["Web"]; var code = J.mc(w, "enc", [J.G["S"]]); var back = J.mc(w, "dec", [code])
				print("ENCDEC len=", str(code).length(), " lv=", back.get("lv") if back is Dictionary else "FAIL", " G.dec ok=", G.dec(code) != null)
			"jeval":
				# 用法 ["jeval", "Battle", "units"] → 逐個印
				var arr = J.gp(J.G.get(s[1]), s[2])
				for u in J.iter(arr): print("JEV ", J.to_json(u).substr(0, 220))
			"el":
				var e = JSRun.query(s[1], null)
				if e == null: print("EL ", s[1], " = null")
				else: print("EL ", s[1], " tag=", e.tagName, " cls=", e.classList.d.keys(), " kids=", e.children.size(), " parent=", (e.parentNode.tagName if e.parentNode else "none"), " cs.display=", Css.computed(e, {}).get("display"), " pos=", Css.computed(e, {}).get("position"), " z=", Css.computed(e, {}).get("z-index"), " style=", e.style)
			"css":
				var e2 = JSRun.query(s[1], null)
				if e2: print("CSSALL ", s[1], " ", str(e2.props.get("_cs", {})).substr(0, 900))
				if e2: print("CSS ", s[1], " ", e2.props.get("_cs", {}).keys().filter(func(k): return k.begins_with("back") or k == "display" or k == "opacity"), " bg=", J.str(e2.props.get("_cs", {}).get("background", "")).substr(0, 200), " bgi=", J.str(e2.props.get("_cs", {}).get("background-image", "")).substr(0, 120), " bgc=", e2.props.get("_cs", {}).get("background-color"))
			"quit": get_tree().quit(); return
