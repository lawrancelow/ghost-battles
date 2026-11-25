extends SceneTree
func _walk(d: String, out: Array) -> void:
	var da = DirAccess.open(d)
	if da == null: return
	for f in da.get_files():
		if f.ends_with(".gd"): out.append(d.path_join(f))
	for s in da.get_directories():
		if s.begins_with("."): continue
		_walk(d.path_join(s), out)
func _initialize() -> void:
	var fs = []; _walk("res://", fs)
	var bad = []
	for p in fs:
		var s = load(p)
		if s == null or not (s is Script) or not s.can_instantiate(): bad.append(p)
	print("CHECK files=", fs.size(), " bad=", bad.size())
	for b in bad: print("BAD ", b)
	quit()
