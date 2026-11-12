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
				print("IMPORT ", G.import_code(code), " lv=", G.S.get("lv"))
				main().refresh()
			"notitle": main()._hide_title()
			"tap": main().village.tap(float(s[1]), float(s[2]))
			"cam": main().village.set_cam(float(s[1]))
			"call":
				var obj = main() if s[1] == "main" else (main().village if s[1] == "village" else get_tree().root.get_node(s[1]))
				obj.callv(s[2], s.slice(3))
			"set": G.S[s[1]] = s[2]
			"print": print("STATE ", s[1], "=", str(G.S.get(s[1])).substr(0, 300))
			"export":
				var fo = FileAccess.open(s[1], FileAccess.WRITE); fo.store_string(G.enc(G.S)); fo.close(); print("EXPORT ok")
			"assign":
				var g = G.ghostById(s[1]); g.post = s[2]; print("ASSIGN ", g.name, " -> ", s[2])
			"quit": get_tree().quit(); return
