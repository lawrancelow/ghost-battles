# godot --headless -s make_pck.gd -- <list.json> <out.pck>
extends SceneTree
func _init():
	var a = OS.get_cmdline_user_args()
	var lst = JSON.parse_string(FileAccess.get_file_as_string(a[0]))
	var pk = PCKPacker.new()
	pk.pck_start(a[1])
	for e in lst: pk.add_file(e[0], e[1])
	pk.flush()
	print("packed ", lst.size())
	quit()
