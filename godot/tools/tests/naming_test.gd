# [int] 改名檢查：玩家睇到嘅文字唔可以再出現「大排檔」（功能已改名「過勞鬼市集」）同「奈何一杯」（已定「奈河一杯」）
#   例外（指陽間真正嘅大排檔，唔係遊戲功能）：裝備／名鬼描述入面嘅「大排檔鑊鏟」「大排檔炒…」「大排檔師傅」「大排檔夜更／夜班師傅」
# 用法：bash /home/claude/gbslot.sh bash /home/claude/setup/edtest.sh <godot目錄> naming res://tools/tests/naming_test.gd all 300
extends RefCounted
const SKIP_DIRS := ["res://tools", "res://jsgen", "res://js", "res://web", "res://.godot", "res://assets", "res://fonts"]
const ALLOW := ["大排檔鑊鏟", "大排檔鍋鏟", "大排檔炒", "大排檔師傅", "大排檔夜更師傅", "大排檔夜班師傅"]
var ok := 0
var bad := 0
func all(_t) -> void:
	var hits: Array = []
	_walk("res://", hits)
	for h in hits: print("[naming]   ", h)
	if hits.is_empty(): ok += 1
	else: bad += 1
	print("[naming] %s 玩家可見文字冇殘留「大排檔」／「奈何一杯」（%d 處）" % ["ok " if hits.is_empty() else "BAD", hits.size()])
	print("[naming] RESULT ok=%d bad=%d" % [ok, bad])
func _walk(dir: String, hits: Array) -> void:
	for s in SKIP_DIRS: if dir.begins_with(s): return
	var d = DirAccess.open(dir)
	if d == null: return
	for sub in d.get_directories(): if not sub.begins_with("."): _walk(dir.path_join(sub), hits)
	for f in d.get_files():
		var p = dir.path_join(f)
		if f.ends_with(".gd"): _scan_gd(p, hits)
		elif f.ends_with(".json") and f.find("manifest") < 0: _scan_txt(p, FileAccess.get_file_as_string(p).split("\n"), hits, false)
func _bad_str(s: String) -> bool:
	if s.contains("奈何一杯"): return true
	var t = s
	for a in ALLOW: t = t.replace(a, "")
	return t.contains("大排檔")
func _scan_txt(p: String, lines, hits: Array, _gd: bool) -> void:
	var n = 0
	for l in lines:
		n += 1
		if (l.contains("大排檔") or l.contains("奈何一杯")) and _bad_str(l): hits.append("%s:%d %s" % [p, n, l.strip_edges().left(80)])
func _scan_gd(p: String, hits: Array) -> void:
	var n = 0
	for l in FileAccess.get_file_as_string(p).split("\n"):
		n += 1
		if not (l.contains("大排檔") or l.contains("奈何一杯")): continue
		for s in _strs(l):
			if _bad_str(s): hits.append("%s:%d %s" % [p, n, s.left(80)])
func _strs(line: String) -> Array:   # 抽出字串字面量（註解唔計）
	var out: Array = []; var i = 0; var cur = ""; var buf = ""
	while i < line.length():
		var c = line[i]
		if cur == "":
			if c == "#": break
			if c == "\"" or c == "'": cur = c; buf = ""
		else:
			if c == "\\": buf += line.substr(i, 2); i += 2; continue
			if c == cur: out.append(buf); cur = ""
			else: buf += c
		i += 1
	return out
